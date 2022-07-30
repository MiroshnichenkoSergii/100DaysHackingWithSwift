//
//  ViewController.swift
//  Project22
//
//  Created by Sergii Miroshnichenko on 11.07.2022.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconReading: UILabel!
    
    var locationManager: CLLocationManager?
    
    let uuidList = ["092": "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", "E2": "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", "7427": "74278BDA-B644-4520-8F0C-720EAF059935"]
    
    var hasShown = false
    let circle = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        view.backgroundColor = .gray
        
        circle.translatesAutoresizingMaskIntoConstraints = false
        let w = view.frame.size.width/2 - 128
        let h = view.frame.size.height/2 - 128
        circle.frame = CGRect(x: w, y: h, width: 256, height: 256)
        circle.layer.cornerRadius = 128
        circle.layer.borderWidth = 3
        circle.layer.borderColor = UIColor.separator.cgColor
        circle.alpha = 0.5
        view.addSubview(circle)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    for key in uuidList.keys {
                        startScanning(uuid: uuidList[key]!, name: key)
                    }
                }
            }
        }
    }
    
    func startScanning(uuid: String, name: String) {
        let uuid = UUID(uuidString: uuid)!
        let beaconIdentity = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconIdentity, identifier: name)
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconIdentity)
    }
    
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)

            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            update(distance: beacon.proximity)
            beaconReading.text = beacon.uuid.description
            if !hasShown {
                let ac = UIAlertController(title: "Detected", message: "Yuor beacon is detected", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [self]_ in hasShown = true }))
                present(ac, animated: true)
            }
        }
//        if let beacon = beacons.first {
//          update(distance: item.proximity)
//
//        } else {
//            update(distance: .unknown)
//            hasShown = false
//        }
    }


}


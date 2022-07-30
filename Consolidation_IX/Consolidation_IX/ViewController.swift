//
//  ViewController.swift
//  Consolidation_IX
//
//  Created by Sergii Miroshnichenko on 17.07.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var PinguinView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PinguinView.bounceOut(duration: 3)
    }
}

extension UIView {
    func bounceOut(duration: Int) {
        UIView.animate(withDuration: TimeInterval(duration)) {
        self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
    }
}


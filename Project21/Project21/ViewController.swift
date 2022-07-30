//
//  ViewController.swift
//  Project21
//
//  Created by Sergii Miroshnichenko on 08.07.2022.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }


    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }

    @objc func scheduleLocal() {
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        let trigger24 = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        let request24 = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger24)
        
        center.add(request)
        center.add(request24)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        
        // Challenge 2
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later")
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
                // Challenge 1
                let ac = UIAlertController(title: "Default", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)

            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")
                
                // Challenge 1
                let ac = UIAlertController(title: "Show", message: "There is more information", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
             
            // Challenge 2
            case "remind":
                print("Reminding is triggered")
                

            default:
                break
            }
        }

        // you must call the completion handler when you're done
        completionHandler()
    }
}


//
//  ViewController.swift
//  Project28
//
//  Created by Sergii Miroshnichenko on 09.08.2022.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    var storedPassword: String = "aaa"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(makePassword))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        title = "Nothing to see here"
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // error
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac, self] _ in
                guard let key = ac?.textFields?[0].text else { return }
                
                if key == storedPassword {
                    unlockSecretMessage()
                }
                
            })
            self.present(ac, animated: true)
        }
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"

        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc func makePassword() {
        if storedPassword == "aaa" {
            let ac = UIAlertController(title: "Password", message: "Set the new password.", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac] _ in
                guard let key = ac?.textFields?[0].text else { return }
                KeychainWrapper.standard.set(key, forKey: "Password")
                self.storedPassword = key
            })
            self.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Password", message: "Change password.", preferredStyle: .alert)
            ac.addTextField()
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac] _ in
                guard let key = ac?.textFields?[0].text else { return }
                guard let newKey = ac?.textFields?[1].text else { return }
                if let text = KeychainWrapper.standard.string(forKey: "Password") {
                    if key == text {
                        KeychainWrapper.standard.set(newKey, forKey: "Password")
                        self.storedPassword = newKey
                    }
                }
            })
            self.present(ac, animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
}


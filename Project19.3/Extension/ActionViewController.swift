//
//  ActionViewController.swift
//  Extension
//
//  Created by Sergii Miroshnichenko on 04.07.2022.
//

import UIKit
import UniformTypeIdentifiers
//import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var selectedScript: String?
    
    var pageTitle = ""
    var pageURL = ""
    
    var defaultScripts = ["Title": "alert(document.title);", "URL": "alert(document.URL);"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)), UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(chooseDefaultScript))]
        
        navigationItem.backBarButtonItem = UIBarButtonItem()
        
        let defaults = UserDefaults.standard
        if let savedScripts = defaults.object(forKey: "script") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                defaultScripts = try jsonDecoder.decode([String: String].self, from: savedScripts)
            } catch {
                print("Failed to load people")
            }
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                
                // Using modern UTType.propertyList.identifier insted kUTTypePropertyList
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""

                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.script.text = self?.selectedScript
                    }
                }
            }
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text!]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        
        // Using modern UTType.propertyList.identifier insted kUTTypePropertyList
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier)
            item.attachments = [customJavaScript]

            extensionContext?.completeRequest(returningItems: [item])
        
        save()
    }
    
    @IBAction func chooseDefaultScript() {
        let ac = UIAlertController(title: "Default Scripts", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Add New Script", style: .default, handler: { _ in self.script.text = "" }))
        ac.addAction(UIAlertAction(title: "Save Script", style: .default, handler: saveScript))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    func save() {
        for key in defaultScripts.keys {
            if key.isEmpty {
                defaultScripts.removeValue(forKey: key)
            }
        }
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(defaultScripts) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "script")
        } else {
            print("Failed to save score.")
        }
    }
    
    func saveScript(alert: UIAlertAction) {
        let ac = UIAlertController(title: "Enter name for script", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self]_ in
            guard let name = ac.textFields?[0].text else { return }
            if !name.isEmpty {
                defaultScripts[name] = script.text
                save()
            }
        }))
        present(ac, animated: true)
    }

}

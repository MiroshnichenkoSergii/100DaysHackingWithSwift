//
//  DetailViewController.swift
//  NotesLikeApple
//
//  Created by Sergii Miroshnichenko on 09.07.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var note: UITextView!
    
    var selectedNote: String?
    var notes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped)), UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote))]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        note.text = selectedNote        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            note.contentInset = .zero
        } else {
            note.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        note.scrollIndicatorInsets = note.contentInset
        let selectedRange = note.selectedRange
        note.scrollRangeToVisible(selectedRange)
    }
    
    @objc func shareTapped() {
        guard let shareNote = note.text else { return }
        let vc = UIActivityViewController(activityItems: [shareNote], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func saveNote() {
        guard let tappedNote = note.text else { return }
        notes.append(tappedNote)
        save()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "note")
        } else {
            print("Failed to save")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }


}

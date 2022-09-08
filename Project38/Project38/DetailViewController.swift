//
//  DetailViewController.swift
//  Project38
//
//  Created by Sergii Miroshnichenko on 01.09.2022.
//

import UIKit

class DetailViewController: UIViewController {
    var detailItem: Commit?
//    var authorCommits: NSSet?

    @IBOutlet var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let detail = self.detailItem {
            detailLabel.text = detail.message
            
             navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commit 1/\(detail.author.commits.count)", style: .plain, target: self, action: #selector(showAuthorCommits))
        }
    }
    
    @objc func showAuthorCommits() {
//        let ac = UIAlertController(title: "Authors commits", message: .none, preferredStyle: .actionSheet)
//
//        for commit in authorCommits! {
//            ac.addAction(UIAlertAction(title: ((commit as AnyObject).message?!)! as String, style: .default, handler: .none))
//        }
//
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(ac, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  DetailViewController.swift
//  Project38assign1
//
//  Created by Sergii Miroshnichenko on 05.09.2022.
//

import WebKit
import UIKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    
    var detailItem: Commit?
    var authorCommits: NSSet?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        if let detail = self.detailItem {
             navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commit 1/\(detail.author.commits.count)", style: .plain, target: self, action: #selector(showAuthorCommits))
        }
        
        if let url = URL(string: detailItem.url) {
            webView.load(URLRequest(url: url))
        }
    }
    
    @objc func showAuthorCommits() {
        let ac = UIAlertController(title: "Authors commits", message: .none, preferredStyle: .actionSheet)

        if let detail = self.detailItem {
            for commit in detail.author.commits {
                ac.addAction(UIAlertAction(title: ((commit as AnyObject).message?!)! as String, style: .default, handler: .none))
            }
        }
        

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
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

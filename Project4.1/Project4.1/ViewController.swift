//
//  ViewController.swift
//  Project4.1
//
//  Created by Sergii Miroshnichenko on 07.06.2022.
//

import UIKit
import WebKit

class ViewController: UITableViewController {
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var websites = ["apple.com", "hackingwithswift.com", "someUnallowedPage.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Websites list"
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Webview" view controller and typecasting it to be WebsitesViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Webview") as? WebsitesViewController {
            // 2: success! Set its selectedWebsite property
            vc.selectedWebsite = websites[indexPath.row]

            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}


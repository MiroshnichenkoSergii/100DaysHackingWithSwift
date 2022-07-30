//
//  ScriptTableViewController.swift
//  Extension
//
//  Created by Sergii Miroshnichenko on 05.07.2022.
//

import UIKit

class ScriptTableViewController: UITableViewController {
    var defaultScripts = ["Title": "alert(document.title);", "URL": "alert(document.URL);"]
    var defaultScriptsList: [String]?
    var selectedScript: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Scripts List"
        
        let defaults = UserDefaults.standard
        if let savedScripts = defaults.object(forKey: "script") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                defaultScripts = try jsonDecoder.decode([String: String].self, from: savedScripts)
            } catch {
                print("Failed to load people")
            }
        }
        
        defaultScriptsList = defaultScripts.keys.map { $0 }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        defaultScripts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for: indexPath)
        cell.textLabel?.text = defaultScriptsList![indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? ActionViewController {
            vc.selectedScript = defaultScripts[defaultScriptsList![indexPath.row]]

            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // add swipe to delete row functionnality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            defaultScripts.removeValue(forKey: defaultScriptsList![indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            save()
        }
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

}

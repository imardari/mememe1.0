//
//  SettingsTableViewController.swift
//  Meme1.0
//
//  Created by Ion M on 5/12/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit

protocol FontChoosedDelegate {
    func didSelectFont(fontName: String)
}

class SettingsTableViewController: UITableViewController {
    
    var fontChoosedDelegate: FontChoosedDelegate?
    var fontFamilyName = [String]()
    
//    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for familyName in UIFont.familyNames {
            fontFamilyName.append("\(familyName)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontFamilyName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fontFamilyName[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        fontChoosedDelegate?.didSelectFont(fontName: fontFamilyName[indexPath.row])
        print(fontFamilyName[indexPath.row])
        dismiss(animated: true, completion: nil)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

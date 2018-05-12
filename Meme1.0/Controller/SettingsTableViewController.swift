//
//  SettingsTableViewController.swift
//  Meme1.0
//
//  Created by Ion M on 5/12/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var fonts = [Font]()
    var memeVC = MemeViewController()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let impact = Font(fontName: "Impact")
        fonts.append(impact)

        let helvetica = Font(fontName: "Helvetica")
        fonts.append(helvetica)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fonts[indexPath.row].fontName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        let font = fonts[indexPath.row].fontName
        
        if font == "Impact" {
            print("Impact")
            memeVC.memeTextAttributes.updateValue(UIFont(name: "Impact", size: 20)!, forKey: NSAttributedStringKey.font.rawValue)
            
        } else if font == "Helvetica" {
            print("Helvetica")
            memeVC.memeTextAttributes.updateValue(UIFont(name: "Helvetica", size: 20)!, forKey: NSAttributedStringKey.font.rawValue)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

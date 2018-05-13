//
//  SettingsViewController.swift
//  Meme1.0
//
//  Created by Ion M on 5/13/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit

protocol ChoosedFontDelegate {
    func didSelectFont(fontName: String)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var picker: UIPickerView!
    var choosedFontDelegate: ChoosedFontDelegate?
    var fontFamilyName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        for familyName in UIFont.familyNames {
            fontFamilyName.append("\(familyName)")
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontFamilyName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontFamilyName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosedFontDelegate?.didSelectFont(fontName: fontFamilyName[row])
    }
}

//
//  MemeViewController.swift
//  ImagePicker
//
//  Created by Ion M on 5/9/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Outlets and properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    
    // Set the custom UI for our text
    var memeTextAttributes: [String : Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -4.0
    ]
    
    //MARK: View methods
    
    override func viewWillAppear(_ animated: Bool) {
        //Subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        
        //If the phone doesn't have a camera the cameraButton will be dissabled
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Disable the shareButton and the cancelButton if there is no image yet
        shareButton.isEnabled = imageView.image == nil ? false : true
        cancelButton.isEnabled = imageView.image == nil ? false : true
        
        //Set the custom UI for both text fields
        configureTexFields(textAttribute: memeTextAttributes, textAlignment: .center)
    }
    
    //Don't forget to cleanup after youself :)
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotification()
    }
    
    //MARK: IBActions
    
    @IBAction func pickAnImageFromLibrary(_ sender: Any) {
        pickAnImage(soure: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(soure: .camera)
    }
    
    //Generate and save the memed image after clickling the share button
    @IBAction func shareImage(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let settingsVC = storyboard?.instantiateViewController(withIdentifier: "pickerVC") as! SettingsViewController
        settingsVC.choosedFontDelegate = self
        present(settingsVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let cleanVC = storyboard?.instantiateViewController(withIdentifier: "MemeVC")
        show(cleanVC!, sender: self)
    }
    
    //Group textField's UI and delegates in one method
    func configureTexFields(textAttribute: [String: Any], textAlignment: NSTextAlignment){
        topText.defaultTextAttributes = textAttribute
        bottomText.defaultTextAttributes = textAttribute
        topText.textAlignment = textAlignment
        bottomText.textAlignment = textAlignment
        topText.delegate = self
        bottomText.delegate = self
    }
    
    //MARK: Shift view's frame up and down
    
    @objc func keyboardWillShow(_ notification: Notification) {
        //Move the view only when the bottom text field has focus
        if bottomText.isEditing {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: UIImagePickerController
    
    func pickAnImage(soure: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = soure
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //Present the image on the screen and dismiss the UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let photo = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = photo
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Generate an save the memed image
    
    func generateMemedImage() -> UIImage {
        //Hide the navbar and the toolbar before generating the memed image
        toolbar.isHidden = true
        navbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show the navbar and the toolbar after the generation is complete
        toolbar.isHidden = false
        navbar.isHidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, oldImage: imageView.image!, memedImage: generateMemedImage())
    }
}

//MARK: textField delegate methods

extension MemeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: ChoosedFontDelegate methods

extension MemeViewController: ChoosedFontDelegate {
    func didSelectFont(fontName: String) {
        memeTextAttributes.updateValue(UIFont(name: fontName, size: 40)!, forKey: NSAttributedStringKey.font.rawValue)
    }
}


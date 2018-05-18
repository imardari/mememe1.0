//
//  MemeCollectionViewController.swift
//  Meme1.0
//
//  Created by Ion M on 5/17/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

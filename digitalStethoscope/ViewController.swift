//
//  ViewController.swift
//  digitalStethoscope
//
//  Created by Andrew Stoycos on 11/5/17.
//  Copyright © 2017 Andrew Stoycos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var RoundedCornerButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RoundedCornerButton.layer.cornerRadius = 7
        tutorialButton.layer.cornerRadius = 7
       
    }

    

}


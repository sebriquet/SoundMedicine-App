//
//  Options.swift
//  digitalStethoscope
//
//  Created by Sofia Briquet on 3/23/20.
//  Copyright © 2020 Andrew Stoycos. All rights reserved.
//

import UIKit

class Options: UIViewController {

    @IBOutlet weak var SendResults: UIButton!
    @IBOutlet weak var Symptoms: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SendResults.layer.cornerRadius = 4
        Symptoms.layer.cornerRadius = 4

       
    }
    


}

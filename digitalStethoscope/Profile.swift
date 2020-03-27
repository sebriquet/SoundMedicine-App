//
//  Profile.swift
//  digitalStethoscope
//
//  Created by Sofia Briquet on 3/23/20.
//  Copyright © 2020 Andrew Stoycos. All rights reserved.
//

import UIKit

var isBoxClicked: Bool!
var name: String!
var emailofUser: String!
var age: String!
var gender: String!


class Profile: UIViewController, UITextFieldDelegate {
    @IBOutlet var sendSymptoms: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var unchecked: UIButton!
    
    var checkedBox  = UIImage (named: "checked-2")
    var uncheckedBox = UIImage (named: "unchecked")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendSymptoms.layer.cornerRadius = 5
        isBoxClicked = false
        
        self.nameField.delegate = self
        self.emailField.delegate = self
        self.ageField.delegate = self
        self.genderField.delegate = self
        
        name = nameField.text!
        emailofUser = emailField.text!
        age = ageField.text!
        gender = genderField.text!
        
    }
    
    //hide keyboard when user touches outside
    override func touchesBegan(_ touches: Set <UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard when users presses done
    func textFieldShouldReturn(_ textField: UITextField) ->
        Bool {
            nameField.resignFirstResponder()
            ageField.resignFirstResponder()
            emailField.resignFirstResponder()
            genderField.resignFirstResponder()
            return true
    }
    
    @IBAction func checkBox(_ sender: Any) {
        if isBoxClicked == true {
            isBoxClicked = false
        }
        else {
            isBoxClicked = true
        }
        
        if isBoxClicked == true {
            unchecked.setImage(checkedBox, for: UIControl.State.normal)
        }
        else {
            unchecked.setImage(uncheckedBox, for: UIControl.State.normal)
        }

    }
    
}

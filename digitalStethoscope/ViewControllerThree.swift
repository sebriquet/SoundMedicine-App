//
//  ViewControllerThree.swift
//  digitalStethoscope
//
//  Created by Andrew Stoycos on 4/23/18.
//  Copyright © 2018 Andrew Stoycos. All rights reserved.
//

import AVFoundation
import UIKit
import MessageUI

class ViewControllerThree:
UIViewController,MFMailComposeViewControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var enterEmail: UITextField!
    @IBOutlet weak var sendEmailobj: UIButton!
    @IBOutlet weak var startOver1: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendEmailobj.layer.cornerRadius = 6
        startOver1.layer.cornerRadius = 6
        self.enterEmail.delegate = self;
    }
    
    //MARK: function to set up email: subject, body and attach data files
    func sendemail(email: String, filename: String){
        if(MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("SoundMedicine: Digital Stethoscope Results")
            mailComposer.setMessageBody("Sound files along with respiratory cycle: .wav file (accelorometer on top, audio on bottom)  \nProfile of User: \nName: \(name ?? "N/A")  \nemail: \(emailofUser ?? "N/A") \nage: \(age ?? "N/A") \ngender: \(gender ?? "N/A") \nuser indicated forced breathing:  \(isBoxClicked ?? false) \n\nAnatomical Positions of Recordings: \n1. Above the Right Breast \n2. Below the Right Breast \n3. Above the Left Breast \n4. Below the Left Breast \n5. On the back, above the Right Scapula \n6. Below the Right Scapula \n7. Above the Left Scapula \n8. Below the Left Scapula \n9. On the side, below the Right Armpit \n10. Below the left armpit \nThank you!", isHTML: false)
            mailComposer.setToRecipients([email])
            
       
//MARK:  code to attach data
           for i in 1...fileNumber{
               if let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as? String {
                   var fileManager = FileManager.default
                   var filecontent = fileManager.contents(atPath: docsDir + "/" + filename + String(i) + ".wav")
                  mailComposer.addAttachmentData(filecontent!, mimeType: "audio/x-wav", fileName: filename + String(i) + ".wav")
                }
                fileNumber = 0
            }
            
            self.present(mailComposer, animated: true, completion: nil)
            
            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                
                controller.dismiss(animated: true, completion: nil)
                
            }
            
        }
    }
    
    //Error handling function for EMAIL
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func sendEmailact(_ sender: UIButton) {
        
        let emailer = enterEmail.text
    
           sendemail(email: emailer! ,filename: "acc_TOP_audio_BOTTOM")
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    
}

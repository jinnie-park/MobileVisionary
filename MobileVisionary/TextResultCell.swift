//
//  textResultCell.swift
//  MobileVisionary
//
//  Created by Jinnie Park on 8/8/18.
//  Copyright © 2018 Jinnie Park. All rights reserved.
//

import UIKit

class TextResultCell: UITableViewCell {
    
   
    @IBOutlet weak var textResult: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    var textToSave = ""
    
    func setTextResult(text: String) {
        self.textToSave = text
        textResult.text = text
    }
    
    
    
//
//    func sendEmail() {
//        if MFMailComposeViewController.canSendMail() {
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            mail.setToRecipients(["you@yoursite.com"])
//            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
//            present(mail, animated: true)
//        } else {
//            // show failure alert
//        }
//    }
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true)
//    }
    
}

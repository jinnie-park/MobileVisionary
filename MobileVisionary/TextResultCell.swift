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
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
    
    func setTextResult(text: String) {
        self.textToSave = text
        textResult.text = text
    }
    
    
    
    
    
}

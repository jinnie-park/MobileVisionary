//
//  FaceResultCell.swift
//  MobileVisionary
//
//  Created by Jinnie Park on 8/8/18.
//  Copyright © 2018 Jinnie Park. All rights reserved.
//

import UIKit

class FaceResultCell: UITableViewCell {

    @IBOutlet weak var emotionField: UILabel!
     @IBOutlet weak var scaleField: UILabel!
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
    
    func setEmotionField(emotion: String) {
        var emotionText = emotion
        switch emotion {
        case "anger":
            emotionText = emotion.uppercased() + " 😡"
        case "surprise":
            emotionText = emotion.uppercased() + " 😲"
        case "sorrow":
            emotionText = emotion.uppercased() + " 😢"
        case "joy":
            emotionText = emotion.uppercased() + " 😀"
        default:
            emotionText = emotion.uppercased()
        }
        emotionField.text = emotionText
    }
    
    func setScaleField(scale: String) {
        scaleField.text = scale.uppercased()
    }
    /*
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

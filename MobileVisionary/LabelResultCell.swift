//
//  FaceResultCell.swift
//  MobileVisionary
//
//  Created by Bowen Sun on 8/8/18.
//  Copyright © 2018 Jinnie Park. All rights reserved.
//

import UIKit

class LabelResultCell: UITableViewCell {
    
    @IBOutlet weak var percentConstraint: NSLayoutConstraint!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var percentage = 0.01

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        percentConstraint.constant = 0.01
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayPercentage(percent: Float){
        DispatchQueue.main.async {
            if let constraint = self.percentConstraint{
                _ = constraint.changeMultiplier(multiplier: CGFloat(percent))
                UIView.animate(withDuration: 10) {
                    self.layoutIfNeeded()
                }
            }
        }
        
        
        
        let text = String(Int(percent * 100)) + "%    "
        percentLabel.text = text
    }

}

public extension NSLayoutConstraint {
    
    func changeMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        newConstraint.priority = priority
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
    
}

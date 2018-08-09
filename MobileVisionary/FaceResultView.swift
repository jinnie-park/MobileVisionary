//
//  FaceResultView.swift
//  MobileVisionary
//
//  Created by Bowen Sun on 8/8/18.
//  Copyright © 2018 Jinnie Park. All rights reserved.
//

import UIKit

class FaceResultView: UIView {

    @IBOutlet weak var tableView: UITableView!
    var data: ([String : String], [String : Any], [String : String])?{
        didSet{
            //refresh ui to display
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        tableView.dataSource = self
        tableView.delegate = self
        let labelNib = UINib(nibName: "LabelResultCell", bundle: nil)
        tableView.register(labelNib, forCellReuseIdentifier: "labelresult")
    }
}

extension FaceResultView: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            return tableView.dequeueReusableCell(withIdentifier: "headercell")?.contentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 35
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "faceResult", for: indexPath) as! FaceResultCell
            cell.setEmotionField(emotion: "anger")
            cell.setScaleField(scale: "likely")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelresult") as! LabelResultCell
            cell.displayPercentage(percent: 0.9)
            return cell
        }
    }
}


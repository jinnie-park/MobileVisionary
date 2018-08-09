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
        if(section == 0) {
            return 4
        } else {
            var numOfRows = 0
            if let unwrappedData = self.data {
                let label : [Dictionary<String, Any>] = unwrappedData.1["results"] as! [Dictionary<String, Any>]
                numOfRows = label.count
            }
            print("number of rows \(numOfRows)")
            return numOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var labels = [Dictionary<String, Any>]()
        if let unwrappedData = self.data {
            labels = unwrappedData.1["results"] as! [Dictionary<String, Any>]
        }
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "faceResult", for: indexPath) as! FaceResultCell
            var emotions = [Substring]()
            if let unwrappedData = self.data {
                let emotionsData = unwrappedData.0["text"] as! String
                emotions = emotionsData.split(separator: "\n")
//                print("--------------" + emotionsData)
                var emotion = emotions[indexPath.row].split(separator: ":")
                cell.setEmotionField(emotion: String(emotion[0]))
                cell.setScaleField(scale: String(emotion[1]))

            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelresult", for: indexPath) as! LabelResultCell
            cell.displayLabelName(name: labels[indexPath.row]["label"] as! String)
            cell.displayPercentage(percent: Float(labels[indexPath.row]["confidence"] as! Double))
            return cell
        }
    }
}


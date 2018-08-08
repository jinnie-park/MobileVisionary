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
        return 20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Strange"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            return UITableViewCell()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelresult") as! LabelResultCell
            cell.displayPercentage(percent: 0.5)
            return cell
        }
    }
}


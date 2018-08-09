//
//  TextResultView.swift
//  MobileVisionary
//
//  Created by Bowen Sun on 8/8/18.
//  Copyright © 2018 Jinnie Park. All rights reserved.
//

import UIKit

class TextResultView: UIView {

    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        tableView.dataSource = self
        tableView.delegate = self
        let labelNib = UINib(nibName: "LabelResultCell", bundle: nil)
        tableView.register(labelNib, forCellReuseIdentifier: "labelresult")
    }

}

extension TextResultView: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 300
        }else{
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            return tableView.dequeueReusableCell(withIdentifier: "textresult", for: indexPath) as! TextResultCell
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "labelresult", for: indexPath) as! LabelResultCell
        }
    }
}

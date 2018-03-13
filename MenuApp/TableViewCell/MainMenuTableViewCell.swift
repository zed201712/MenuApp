//
//  MainMenuTableViewCell.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/2/17.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class MainMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var seatNumberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var mainListListTableView: UITableView!
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    @IBAction func button1TouchUpInside(_ sender: Any) {
        //Clear Button
        
        let index = self.tag
        AddMainListViewController.deleteGlobalMainList(listIndex: index, stateString: "clear")
        let tableView = self.superview as! UITableView
        tableView.reloadData()
    }
    
    @IBAction func button3TouchUpInside(_ sender: Any) {
        //Check Button
        
        let index = self.tag
        self.button1.isHidden = globalMainList[index].isCheck
        globalMainList[index].isCheck = !globalMainList[index].isCheck
        if globalMainList[index].isCheck == true {
            self.backgroundColor = globalMyColor[myColorEnum.lightgreen.rawValue]
        } else {
            self.backgroundColor = globalMyColor[myColorEnum.gray.rawValue]
        }
    }
    
}

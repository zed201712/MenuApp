//
//  AddMainListTableViewCell.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/2/27.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class AddMainListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seatNumberLabel: UILabel!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func seatNumberSubButtonTouchUpInside(_ sender: Any) {
        let index = globalMainList[globalMainListIndex].seatNumber
        globalMainList[globalMainListIndex].seatNumber = SeatListManage.findNextUseable(startIndex: index, toFront: false)
        SeatListManage.setUseable(index: index, useable: true)
        SeatListManage.setUseable(index: globalMainList[globalMainListIndex].seatNumber, useable: false)
        self.seatNumberLabel.text = SeatListManage.displayNumber(index: globalMainList[globalMainListIndex].seatNumber)
    }
    
    @IBAction func seatNumberAddButtonTouchUpInside(_ sender: Any) {
        let index = globalMainList[globalMainListIndex].seatNumber
        globalMainList[globalMainListIndex].seatNumber = SeatListManage.findNextUseable(startIndex: index, toFront: true)
        SeatListManage.setUseable(index: index, useable: true)
        SeatListManage.setUseable(index: globalMainList[globalMainListIndex].seatNumber, useable: false)
        self.seatNumberLabel.text = SeatListManage.displayNumber(index: globalMainList[globalMainListIndex].seatNumber)
    }
}


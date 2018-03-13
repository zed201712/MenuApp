//
//  ListSettingTableViewCell.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/2/15.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class ListSettingViewCell: UITableViewCell {
    @IBOutlet weak var menuNicknameLabel: UILabel!
    @IBOutlet weak var menuPriceLabel: UILabel!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuNameText: UITextField!
    @IBOutlet weak var menuNicknameText: UITextField!
    @IBOutlet weak var menuPriceText: UITextField!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

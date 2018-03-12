//
//  MainListListTableViewCell.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/6.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class MainListListTableViewCell: UITableViewCell {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

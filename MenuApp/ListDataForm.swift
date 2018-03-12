//
//  ListDataForm.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/2/15.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

struct seatNumberListDataForm {
    var useable = Array<Bool>(repeating: true, count: globalLimit)
    var myColorIndex = Array<Int>(repeating: 0, count: globalLimit)
    var groupMap = GroupMap(resolution: globalSeatMapResolution, limit: globalLimit)
}

struct GroupUIArray {
    var groupNameTextView: [UITextView?] = []
}

struct UIIndex {
    var menuIndex = 0
    var groupIndex = 0
}

struct ListDataForm {
    var image: UIImage?
    var name = ""
    var nickname = ""
    var groupNumber = 0
    var price = "0"
    //var menuSet: [Int] = []
}

struct GroupDataForm {
    var name = ""
    var colorNumber = 0
}



struct ListAndCount {
    var data = ListDataForm()
    var listIndex = 0
    var count = 0
    var countIndex = 0
}

struct MainListForm {
    var seatNumber = 0
    var detailInfo = ""
    var startTime = ""
    var list: [ListAndCount] = []
    var isHidden = false
    var state = ""
    var price = ""
    var isCheck = false
    
    //data build date
    var startDate = ""
    var endDate = ""
}

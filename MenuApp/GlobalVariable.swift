//
//  GlobalVariable.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/9.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

let mainListCellHeight = CGFloat(120)
let menuListCellHeight = 35
let globalLimit = 1000
let globalSeatMapResolution = 30

var globalMenuList: [ListDataForm] = []
var globalGroupList: [GroupDataForm] = []
var globalMainList: [MainListForm] = []
var globalMainListHistory: [MainListForm] = []
var globalMainListIndex = 0
var globalMyColor: [UIColor] = []

var globalSeatList = seatNumberListDataForm()



let globalSampleSettingsString = "v001\nListSettings.txt\nGroup\n0\nALL\nGroup\n1\n食物\nGroup\n2\n飲料\nGroup\n6\n揚物\nMenu\n1\n牛肉漢堡\n牛\n120\nMenu\n1\n豬肉漢堡\n豬\n110\nMenu\n1\n雞肉漢堡\n雞\n100\nMenu\n2\n紅茶\n紅茶\n10\nMenu\n2\n奶茶\n奶茶\n30\nMenu\n2\n可樂\n可樂\n50\nMenu\n3\n薯條\n薯\n80\nMenu\n3\n雞米花\n雞米\n80\n\nv001\nMainListSettings.txt\nOrder\n1\n11:36\nfalse\n\n\n2018-03-12 11:36\n\n130\nfalse\n2\n1\n1\n0\n牛肉漢堡\n1\n牛\n120\n1\n1\n3\n紅茶\n2\n紅茶\n10\nOrder\n2\n11:37\nfalse\n\n\n2018-03-12 11:37\n\n140\nfalse\n2\n1\n1\n1\n豬肉漢堡\n1\n豬\n110\n1\n1\n4\n奶茶\n2\n奶茶\n30\nOrder\n3\n11:37\nfalse\n\n\n2018-03-12 11:37\n\n440\nfalse\n5\n2\n2\n2\n雞肉漢堡\n1\n雞\n100\n1\n1\n4\n奶茶\n2\n奶茶\n30\n1\n1\n5\n可樂\n2\n可樂\n50\n1\n1\n6\n薯條\n3\n薯\n80\n1\n1\n7\n雞米花\n3\n雞米\n80\nOrder\n4\n11:37\nfalse\n\n\n2018-03-12 11:37\n\n860\nfalse\n8\n2\n2\n0\n牛肉漢堡\n1\n牛\n120\n1\n1\n1\n豬肉漢堡\n1\n豬\n110\n1\n1\n2\n雞肉漢堡\n1\n雞\n100\n1\n1\n3\n紅茶\n2\n紅茶\n10\n1\n1\n4\n奶茶\n2\n奶茶\n30\n1\n1\n5\n可樂\n2\n可樂\n50\n2\n2\n6\n薯條\n3\n薯\n80\n2\n2\n7\n雞米花\n3\n雞米\n80\nOrder\n5\n11:38\nfalse\n\n\n2018-03-12 11:38\n\n120\nfalse\n1\n1\n1\n0\n牛肉漢堡\n1\n牛\n120\nOrder\n6\n11:38\nfalse\n\n\n2018-03-12 11:38\n\n110\nfalse\n1\n1\n1\n1\n豬肉漢堡\n1\n豬\n110\nOrder\n7\n11:38\nfalse\n\n\n2018-03-12 11:38\n\n160\nfalse\n2\n1\n1\n6\n薯條\n3\n薯\n80\n1\n1\n7\n雞米花\n3\n雞米\n80\n\nv001\nSeatListSettings.txt\nSeatNumber\n1\n1\n9\n7\n21\n7\n22\n7\n23\n8\n23\n9\n23\n9\n22\n8\n22\n8\n21\n9\n21\nSeatNumber\n2\n1\n9\n7\n16\n7\n17\n7\n18\n8\n18\n9\n18\n9\n17\n8\n17\n8\n16\n9\n16\nSeatNumber\n3\n1\n9\n7\n11\n7\n12\n7\n13\n8\n13\n9\n13\n9\n12\n8\n12\n8\n11\n9\n11\nSeatNumber\n4\n2\n6\n15\n13\n16\n13\n15\n12\n15\n11\n16\n11\n16\n12\nSeatNumber\n5\n2\n6\n15\n16\n15\n17\n15\n18\n16\n18\n16\n17\n16\n16\nSeatNumber\n6\n2\n6\n15\n21\n15\n22\n15\n23\n16\n23\n16\n22\n16\n21"

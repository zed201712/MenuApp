//
//  GlobalVariable.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/9.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

let mainListCellHeight = CGFloat(200)
let menuListCellHeight = 80
let globalLimit = 1000
let globalSeatMapResolution = 30

var globalMenuList: [ListDataForm] = []
var globalGroupList: [GroupDataForm] = []
var globalMainList: [MainListForm] = []
var globalMainListHistory: [MainListForm] = []
var globalMainListIndex = 0
var globalMyColor: [UIColor] = []

var globalSeatList = seatNumberListDataForm()



let globalSampleSettingsString = "v001\nListSettings.txt\nGroup\n0\nALL\nGroup\n1\n食べ物\nGroup\n2\n飲み物\nGroup\n6\n揚物\nMenu\n1\n牛肉漢堡\\*Beef burger\\*牛肉ハンバーガー\nB\n120\nMenu\n1\n豬肉漢堡\\*Pork burger\\*豚肉ハンバーガー\nP\n110\nMenu\n1\n雞肉漢堡\\*Chicken burger\\*鶏肉ハンバーガー\nC\n100\nMenu\n2\nWater\nWT\n10\nMenu\n2\nMilk\nMK\n30\nMenu\n2\nCoffee\nCF\n50\nMenu\n3\n薯條\\*FRENCH FRIES\nFF\n80\nMenu\n3\n雞米花\\*POPCORN CHICKEN\nPC\n80\n\nv001\nMainListSettings.txt\nOrder\n1\n11:36\nfalse\n\n\n2018-03-12 11:36\n\n130\nfalse\n2\n1\n1\n0\n牛肉漢堡\\*Beef burger\\*牛肉ハンバーガー\n1\nB\n120\n1\n1\n3\nWater\n2\nWT\n10\nOrder\n2\n11:37\nfalse\n\n\n2018-03-12 11:37\n\n140\nfalse\n2\n1\n1\n1\n豬肉漢堡\\*Pork burger\\*豚肉ハンバーガー\n1\nP\n110\n1\n1\n4\nMilk\n2\nMK\n30\nOrder\n3\n11:37\nfalse\n\n\n2018-03-12 11:37\n\n440\nfalse\n5\n2\n2\n2\n雞肉漢堡\\*Chicken burger\\*鶏肉ハンバーガー\n1\nC\n100\n1\n1\n4\nMilk\n2\nMK\n30\n1\n1\n5\nCoffee\n2\nCF\n50\n1\n1\n6\n薯條\\*FRENCH FRIES\n3\nFF\n80\n1\n1\n7\n雞米花\\*POPCORN CHICKEN\n3\nPC\n80\nOrder\n4\n11:37\nfalse\n\n\n2018-03-12 11:37\n\n860\nfalse\n8\n2\n2\n0\n牛肉漢堡\\*Beef burger\\*牛肉ハンバーガー\n1\nB\n120\n1\n1\n1\n豬肉漢堡\\*Pork burger\\*豚肉ハンバーガー\n1\nP\n110\n1\n1\n2\n雞肉漢堡\\*Chicken burger\\*鶏肉ハンバーガー\n1\nC\n100\n1\n1\n3\nWater\n2\nWT\n10\n1\n1\n4\nMilk\n2\nMK\n30\n1\n1\n5\nCoffee\n2\nCF\n50\n2\n2\n6\n薯條\\*FRENCH FRIES\n3\nFF\n80\n2\n2\n7\n雞米花\\*POPCORN CHICKEN\n3\nPC\n80\nOrder\n5\n11:38\nfalse\n\n\n2018-03-12 11:38\n\n120\nfalse\n1\n1\n1\n0\n牛肉漢堡\\*Beef burger\\*牛肉ハンバーガー\n1\nB\n120\nOrder\n6\n11:38\nfalse\n\n\n2018-03-12 11:38\n\n110\nfalse\n1\n1\n1\n1\n豬肉漢堡\\*Pork burger\\*豚肉ハンバーガー\n1\nP\n110\nOrder\n7\n11:38\nfalse\n\n\n2018-03-12 11:38\n\n160\nfalse\n2\n1\n1\n6\n薯條\\*FRENCH FRIES\n3\nFF\n80\n1\n1\n7\n雞米花\\*POPCORN CHICKEN\n3\nPC\n80\n\nv001\nSeatListSettings.txt\nSeatNumber\n1\n1\n9\n7\n21\n7\n22\n7\n23\n8\n23\n9\n23\n9\n22\n8\n22\n8\n21\n9\n21\nSeatNumber\n2\n1\n9\n7\n16\n7\n17\n7\n18\n8\n18\n9\n18\n9\n17\n8\n17\n8\n16\n9\n16\nSeatNumber\n3\n1\n9\n7\n11\n7\n12\n7\n13\n8\n13\n9\n13\n9\n12\n8\n12\n8\n11\n9\n11\nSeatNumber\n4\n2\n6\n15\n13\n16\n13\n15\n12\n15\n11\n16\n11\n16\n12\nSeatNumber\n5\n2\n6\n15\n16\n15\n17\n15\n18\n16\n18\n16\n17\n16\n16\nSeatNumber\n6\n2\n6\n15\n21\n15\n22\n15\n23\n16\n23\n16\n22\n16\n21"

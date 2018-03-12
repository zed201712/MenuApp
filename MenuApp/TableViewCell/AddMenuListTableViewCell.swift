//
//  AddMenuListTableViewCell.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/2/27.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class AddMenuListTableViewCell: UITableViewCell {
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuNameTextLabel: UILabel!
    @IBOutlet weak var menuPriceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countSlider: UISlider!
    @IBOutlet weak var setButton: UIButton!
    
    @IBOutlet weak var countSubButton: UIButton!
    @IBOutlet weak var countAddButton: UIButton!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    //MARK: - Function
    func countAdd(tableViewTag: Int)->Void {
        let intSliderValue = self.countSlider.value + 1
        if intSliderValue >= self.countSlider.minimumValue {
            self.countSlider.value = intSliderValue
            self.countLabel.text = String(Int(self.countSlider.value))
        }
        
        if (tableViewTag == tableViewTagNum.mainContent.rawValue) {
            let listNum = self.contentView.tag
            globalMainList[globalMainListIndex].list[listNum].countIndex = Int(self.countSlider.value)
        }
    }
    
    func countSub(tableViewTag: Int)->Void {
        let intSliderValue = self.countSlider.value - 1
        if intSliderValue <= self.countSlider.maximumValue {
            self.countSlider.value = intSliderValue
            self.countLabel.text = String(Int(self.countSlider.value))
        }
        
        if (tableViewTag == tableViewTagNum.mainContent.rawValue) {
            let listNum = self.contentView.tag
            globalMainList[globalMainListIndex].list[listNum].countIndex = Int(self.countSlider.value)
        }
    }
    //MARK: - IBAction
    @IBAction func countAddDragInside(_ sender: Any) {
        let bt = sender as! UIButton
        self.countAdd(tableViewTag: bt.tag)
    }
    @IBAction func countAddTouchUpInside(_ sender: Any) {
        let bt = sender as! UIButton
        self.countAdd(tableViewTag: bt.tag)
    }
    
    @IBAction func countSubButtonDragInside(_ sender: Any) {
        let bt = sender as! UIButton
        self.countSub(tableViewTag: bt.tag)
    }
    
    @IBAction func countSubButtonTouchUpInside(_ sender: Any) {
        let bt = sender as! UIButton
        self.countSub(tableViewTag: bt.tag)
    }
    
    @IBAction func countSliderValueChanged(_ sender: Any) {
        let slider = sender as! UISlider
        let cell = slider.superview!.superview! as! AddMenuListTableViewCell
        let intSliderValue = Float(Int(slider.value))
        var point = slider.value - intSliderValue
        
        if point < 0.5 {
            point = 0
        } else {
            point = 1
        }
        slider.value = intSliderValue + point
        cell.countLabel.text = String(Int(slider.value))
        
        if (slider.tag == tableViewTagNum.mainContent.rawValue) {
            let listNum = self.contentView.tag
            globalMainList[globalMainListIndex].list[listNum].countIndex = Int(slider.value)
        }
    }
}


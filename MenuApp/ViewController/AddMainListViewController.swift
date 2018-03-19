//
//  AddMainListViewController.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/2/24.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

enum tableViewTagNum: Int {
    case mainContent = 1
}

class AddMainListViewController: UIViewController {
    @IBOutlet weak var mainListTableView: UITableView!
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var mainContentTableView: UITableView!
    @IBOutlet weak var menuListTableView: UITableView!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var datePickView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var groupSelectList: [Int] = []
    var groupSelectIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startTimeDatePickerInit()
        
        let layout = UICollectionViewFlowLayout()
        let screenSize = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width: screenSize.width / 5, height: 50)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        groupCollectionView.collectionViewLayout = layout
        
        groupSelectList.removeAll()
        for i in 0..<globalMenuList.count {
            groupSelectList.append(i)
        }
        self.menuListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - IBAction
    @IBAction func commentTextFieldEditingChanged(_ sender: Any) {
        let textField = sender as! UITextField
        globalMainList[globalMainListIndex].detailInfo = textField.text!
    }
    
    @IBAction func button1TouchUpInside(_ sender: Any) {
        //cls
        for i in 0..<globalMainList[globalMainListIndex].list.count {
            globalMainList[globalMainListIndex].list[i].countIndex = 0
        }
        self.mainContentTableView.reloadData()
    }
    
    @IBAction func button2TouchUpInside(_ sender: Any) {
        let bt = sender as! UIButton
        let cell = bt.superview!.superview! as! AddMainListTableViewCell
        
        var sum = 0
        for i in 0..<globalMainList[globalMainListIndex].list.count {
            let list = globalMainList[globalMainListIndex].list[i]
            let price = Int(list.data.price)! * list.countIndex
            
            sum = sum + price
        }
        
        cell.priceLabel.text = "$ " + String(sum) + " / " + globalMainList[globalMainListIndex].price
    }
    
    @IBAction func button3TouchUpInside(_ sender: Any) {
        globalMainList[globalMainListIndex].isCheck = !globalMainList[globalMainListIndex].isCheck
        self.mainListTableView.reloadData()
    }
    
    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        if globalMainList[globalMainListIndex].startTime == "" {
            globalMainList[globalMainListIndex].startTime = GetDateString.nowTime()
        }
        FileRW.fileSaveMainList()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func deleteButtonTouchUpInside(_ sender: Any) {
        
        if globalMainList[globalMainListIndex].isCheck == false && globalMainList[globalMainListIndex].list.count > 0 {
            
            let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("DeleteCheckMsg", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!)->Void in
                
                AddMainListViewController.deleteGlobalMainList(listIndex: globalMainListIndex, stateString: "delete")
                
                self.dismiss(animated: false, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if globalMainList[globalMainListIndex].isCheck == true {
            AddMainListViewController.deleteGlobalMainList(listIndex: globalMainListIndex, stateString: "clear")
            self.dismiss(animated: false, completion: nil)
        } else if globalMainList[globalMainListIndex].list.count == 0 {
            AddMainListViewController.deleteGlobalMainList(listIndex: globalMainListIndex, stateString: "clear")
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func startTimeButtonTouchUpInside(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if globalMainList[globalMainListIndex].startTime == "" {
            globalMainList[globalMainListIndex].startTime = GetDateString.nowTime()
        }
        startTimeDatePicker.date = formatter.date(from: globalMainList[globalMainListIndex].startTime)!
        self.datePickView.isHidden = false
    }
    
    @IBAction func dateSaveButtonTouchUpInside(_ sender: Any) {
        self.datePickView.isHidden = true
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        globalMainList[globalMainListIndex].startTime = formatter.string(from: startTimeDatePicker.date)
        
        self.mainListTableView.reloadData()
    }
    
    @IBAction func dateCancelButtonTouchUpInside(_ sender: Any) {
        self.datePickView.isHidden = true
    }
    
    
    //MARK: - Function
    
    func startTimeDatePickerInit()->Void {
        startTimeDatePicker.datePickerMode = .time
        startTimeDatePicker.minuteInterval = 1
        
        startTimeDatePicker.date = NSDate() as Date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
//        let fromDateTime = formatter.date(from: "00:00")
//        startTimeDatePicker.minimumDate = fromDateTime
//        let endDateTime = formatter.date(from: "23:59")
//        startTimeDatePicker.maximumDate = endDateTime
        
        startTimeDatePicker.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
    }
    @objc func setButtonAdd(sender: Any)->Void {
        let bt = sender as! UIButton
        let listNum = bt.superview!.tag
        
        let cell = bt.superview!.superview! as! AddMenuListTableViewCell
        let listCount = Int(cell.countSlider.value)
        
        var listAndCount = ListAndCount()
        listAndCount.data = globalMenuList[listNum]
        listAndCount.listIndex = listNum
        listAndCount.count = listCount
        listAndCount.countIndex = listCount
        
        var findList = false
        for i in 0..<globalMainList[globalMainListIndex].list.count {
            let list = globalMainList[globalMainListIndex].list[i]
            if list.data.name == listAndCount.data.name && list.data.nickname == listAndCount.data.nickname && list.data.price == listAndCount.data.price {
                globalMainList[globalMainListIndex].list[i].count = list.count + listAndCount.count
                globalMainList[globalMainListIndex].list[i].countIndex = list.count + listAndCount.count
                findList = true
                
                break
            }
        }
        if findList == false {
            var insertIndex = 0
            while (insertIndex < globalMainList[globalMainListIndex].list.count) {
                let list = globalMainList[globalMainListIndex].list[insertIndex]
                if listAndCount.listIndex < list.listIndex {
                    break
                }
                insertIndex = insertIndex + 1
            }
            globalMainList[globalMainListIndex].list.insert(listAndCount, at: insertIndex)
        }
        self.mainContentTableView.reloadData()
        self.mainListTableView.reloadData()
    }
    
    @objc func setButtonSub(sender: Any)->Void {
        let bt = sender as! UIButton
        let cellNum = bt.superview!.tag
        
        let cell = bt.superview!.superview! as! AddMenuListTableViewCell
        let cellCount = Int(cell.countSlider.value)
        
        
        
        let listCount = globalMainList[globalMainListIndex].list[cellNum].count
        var subNumber = listCount - cellCount
        if subNumber == 0 {
            subNumber = listCount
        }
        if listCount - subNumber <= 0 {
            globalMainList[globalMainListIndex].list.remove(at: cellNum)
        } else {
            globalMainList[globalMainListIndex].list[cellNum].count = listCount - subNumber
        }
        self.mainContentTableView.reloadData()
        self.mainListTableView.reloadData()
    }
    
    class func deleteGlobalMainList(listIndex: Int, stateString: String) {
        globalMainList[listIndex].state = stateString
        globalMainList[listIndex].endDate = GetDateString.nowDate()
        globalMainList[listIndex].isHidden = true
        
        let temp = globalMainList[listIndex]
        if temp.state == "clear" {
            globalMainListHistory.append(temp)
            while (globalMainListHistory.count >= globalLimit) {
                globalMainListHistory.remove(at: 0)
            }
        }
        if globalSeatList.groupMap.gMap[globalMainList[listIndex].seatNumber].count == 0 {
            globalMainList.remove(at: listIndex)
            SeatListManage.setUseable(index: globalMainList[listIndex].seatNumber, useable: true)
        } else {
            globalMainList[listIndex].detailInfo = ""
            globalMainList[listIndex].startTime = ""
            globalMainList[listIndex].list.removeAll()
            globalMainList[listIndex].isHidden = false
            globalMainList[listIndex].state = ""
            globalMainList[listIndex].price = ""
            globalMainList[listIndex].isCheck = false
            globalMainList[listIndex].startDate = ""
            globalMainList[listIndex].endDate = ""
        }
        
        FileRW.fileSaveMainList()
    }
}

extension AddMainListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupCollectionView.dequeueReusableCell(withReuseIdentifier: "groupCollectionViewCell", for: indexPath) as! GroupCollectionViewCell
        
        if indexPath.row < globalGroupList.count {
            cell.nameLabel.text = globalGroupList[indexPath.row].name
            cell.backgroundColor = globalMyColor[globalGroupList[indexPath.row].colorNumber]
        } else {
            cell.nameLabel.text = ""
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if groupSelectIndex != indexPath.row && indexPath.row < globalGroupList.count {
            groupSelectList.removeAll()
            
            //All
            if indexPath.row == 0 {
                for i in 0..<globalMenuList.count {
                    groupSelectList.append(i)
                }
            } else {
                for i in 0..<globalMenuList.count {
                    if globalMenuList[i].groupNumber == indexPath.row {
                        groupSelectList.append(i)
                    }
                }
            }
            
            groupSelectIndex = indexPath.row
            self.menuListTableView.reloadData()
        }
    }
}

extension AddMainListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.mainListTableView {
            return 1
        } else if tableView == self.mainContentTableView {
            if globalMainList[globalMainListIndex].list.count == 0 {
                saveButton.isHidden = true
            } else {
                saveButton.isHidden = false
            }
            return globalMainList[globalMainListIndex].list.count
        }
        else {//self.menuListTableView
            return groupSelectList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.mainListTableView {
            let cell = self.mainListTableView.dequeueReusableCell(withIdentifier: "mainListTableViewCell") as! AddMainListTableViewCell
            
            cell.startTimeButton.layer.borderWidth = 1
            cell.button1.layer.borderWidth = 1
            cell.button2.layer.borderWidth = 1
            cell.button3.layer.borderWidth = 1
            cell.commentTextField.layer.borderWidth = 1
            
            var seatNumber = globalMainList[globalMainListIndex].seatNumber
            if seatNumber == 0 {
                seatNumber = SeatListManage.findNextUseable(startIndex: 1, toFront: true)
                SeatListManage.setUseable(index: seatNumber, useable: false)
            }
            globalMainList[globalMainListIndex].seatNumber = seatNumber
            
            let list = globalMainList[globalMainListIndex]
            cell.seatNumberLabel.text = SeatListManage.displayNumber(index: list.seatNumber)
            cell.startTimeButton.setTitle(list.startTime, for: .normal)
            cell.commentTextField.text = list.detailInfo
            
            var sum = 0
            for i in 0..<globalMainList[globalMainListIndex].list.count {
                let list = globalMainList[globalMainListIndex].list[i]
                let price = Int(list.data.price)! * list.count
                
                sum = sum + price
            }
            globalMainList[globalMainListIndex].price = String(sum)
            cell.priceLabel.text = "$ " + globalMainList[globalMainListIndex].price
            
            if list.isCheck == true {
                cell.backgroundColor = globalMyColor[myColorEnum.lightgreen.rawValue]
            } else {
                cell.backgroundColor = globalMyColor[myColorEnum.gray.rawValue]
            }
            
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = self.menuListTableView.dequeueReusableCell(withIdentifier: "addMenuListTableViewCell") as! AddMenuListTableViewCell
            var listCount = 1
            var list = ListAndCount()
            
            cell.countSlider.tag = 0
            
            if tableView == self.mainContentTableView {
                //cellNumber
                cell.contentView.tag = indexPath.row
                
                cell.countSlider.tag = tableViewTagNum.mainContent.rawValue
                cell.countAddButton.tag = tableViewTagNum.mainContent.rawValue
                cell.countSubButton.tag = tableViewTagNum.mainContent.rawValue
                
                list = globalMainList[globalMainListIndex].list[indexPath.row]
                listCount = globalMainList[globalMainListIndex].list[indexPath.row].count
                
                let listCountIndex = globalMainList[globalMainListIndex].list[indexPath.row].countIndex
                cell.countSlider.minimumValue = 0
                cell.countSlider.maximumValue = Float(listCount)
                cell.countSlider.value = Float(listCountIndex)
                
                cell.setButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.setButton.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
                cell.setButton.addTarget(self, action: #selector(self.setButtonSub(sender:)), for: .touchUpInside)
            } else if tableView == self.menuListTableView {
                //menuListNumber
                cell.contentView.tag = groupSelectList[indexPath.row]
                
                list.data = globalMenuList[groupSelectList[indexPath.row]]
                list.listIndex = groupSelectList[indexPath.row]
                
                cell.countSlider.minimumValue = 1
                cell.countSlider.maximumValue = 50
                cell.countSlider.value = Float(listCount)
                
                cell.setButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.setButton.setTitle(NSLocalizedString("Add", comment: ""), for: .normal)
                cell.setButton.addTarget(self, action: #selector(self.setButtonAdd(sender:)), for: .touchUpInside)
            }
            cell.menuNameLabel.text = String(list.listIndex + 1)
            cell.menuNameTextLabel.text = list.data.name
            cell.menuPriceLabel.text = "$" + list.data.price
            
            cell.countLabel.text = String(Int(cell.countSlider.value))
            
            let color = globalMyColor[globalGroupList[list.data.groupNumber].colorNumber]
            cell.backgroundColor = color
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.mainListTableView {
            return CGFloat(80)
        } else {
            return CGFloat(menuListCellHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
}

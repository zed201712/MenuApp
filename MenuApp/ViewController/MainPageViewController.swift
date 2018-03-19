//
//  ViewController.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/2/13.
//  Copyright © 2018年 Zed. All rights reserved.
//

import UIKit

enum myColorEnum: Int {
    case lightorange = 0
    case green = 1
    case blue = 2
    case gray = 3
    case brown = 4
    case pink = 5
    case unknown1 = 6
    case lightgreen = 7
    case lightblue = 8
    case unknown2 = 9
    case purple = 10
    case orange = 11
    case red = 12
    case yellow = 13
    case darkgreen = 14
}

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var mainListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FileRW.appFirstLoad()
        
        self.mainListTableView.isEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainListTableView.reloadData()
        for cell in self.mainListTableView.visibleCells {
            let mainCell = cell as! MainMenuTableViewCell
            mainCell.mainListListTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - function
    class func globalManiListChangeExceptSeatNumber(index1: Int, index2: Int) {
        let temp = globalMainList[index1]
        globalMainList[index1] = globalMainList[index2]
        globalMainList[index2] = temp
        
        globalMainList[index2].seatNumber = globalMainList[index1].seatNumber
        globalMainList[index1].seatNumber = temp.seatNumber
        
        FileRW.fileSaveMainList()
    }
    
    class func addEmptyList()->Void {
        for i in 0 ..< globalSeatList.groupMap.gList.count {
            
            if globalSeatList.groupMap.gList[i].count > 0 {
                if globalSeatList.useable[i] == true {
                    var isFind = false
                    for list in globalMainList {
                        if list.seatNumber == i {
                            isFind = true
                            break
                        }
                    }
                    if isFind == false {
                        var list = MainListForm()
                        list.seatNumber = i
                        MainPageViewController.globalMainListPut(list: list)
                    }
                }
            } else {
                if globalSeatList.useable[i] == false {
                    for mainListIndex in 0 ..< globalMainList.count {
                        if globalMainList[mainListIndex].seatNumber == i {
                            if globalMainList[mainListIndex].list.count == 0 {
                                AddMainListViewController.deleteGlobalMainList(listIndex: mainListIndex, stateString: "Delete")
                            }
                            break
                        }
                    }
                }
            }
            
        }
    }
    
    class func globalMainListPut(list: MainListForm)->Void {
        SeatListManage.setUseable(index: list.seatNumber, useable: false)
        
        var insertIndex = -1
        for i in 0 ..< globalMainList.count {
            if list.seatNumber < globalMainList[i].seatNumber {
                insertIndex = i
                break
            }
        }
        if insertIndex >= 0 {
            globalMainList.insert(list, at: insertIndex)
        } else {
            globalMainList.append(list)
        }
        
        while (globalGroupList.count >= globalLimit) {
            AddMainListViewController.deleteGlobalMainList(listIndex: 0, stateString: "Delete")
            globalMainListIndex = globalMainListIndex - 1
        }
    }
    
    class func globalMainListAdd()->Void {
        globalMainListIndex = globalMainList.count
        
        var list = MainListForm()
        list.startTime = GetDateString.nowTime()
        list.startDate = GetDateString.nowDate()
        list.seatNumber = SeatListManage.findNextUseable(startIndex: 1, toFront: true)
        MainPageViewController.globalMainListPut(list: list)
    }
    
    //MARK: - IBAction
    @IBAction func addListButtonTouchUpInside(_ sender: Any) {
        MainPageViewController.globalMainListAdd()
        
        self.performSegue(withIdentifier: "showAddMainList", sender: nil)
    }
    
    @IBAction func clsAllListButtonTouchUpInside(_ sender: Any) {
        var index = globalMainList.count - 1
        while (index >= 0) {
            if globalMainList[index].isCheck == true {
                AddMainListViewController.deleteGlobalMainList(listIndex: index, stateString: "clear")
            }
            index = index - 1
        }
        self.mainListTableView.reloadData()
    }
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.mainListTableView {
            return globalMainList.count
        } else {
            return globalMainList[tableView.superview!.superview!.tag].list.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.mainListTableView {
            globalMainListIndex = indexPath.row
            self.performSegue(withIdentifier: "showAddMainList", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.mainListTableView {
            let cell = self.mainListTableView.dequeueReusableCell(withIdentifier: "mainListTableViewCell") as! MainMenuTableViewCell
            
            cell.mainListListTableView.layer.borderWidth = 1
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor.brown.cgColor
            
            let index = indexPath.row
            cell.seatNumberLabel.text = "Seat. " + SeatListManage.displayNumber(index: globalMainList[index].seatNumber)
            cell.startTimeLabel.text = globalMainList[index].startTime
            cell.priceLabel.text = "$ " + globalMainList[index].price
            
            cell.tag = index
            cell.button1.isHidden = !globalMainList[index].isCheck
            if globalMainList[index].list.count == 0 {
                cell.backgroundColor = UIColor.white
                cell.button3.isHidden = true
            } else if globalMainList[index].isCheck == true {
                cell.backgroundColor = globalMyColor[myColorEnum.lightgreen.rawValue]
                cell.button3.isHidden = false
            } else {
                cell.backgroundColor = globalMyColor[myColorEnum.gray.rawValue]
                cell.button3.isHidden = false
            }
            
            cell.mainListListTableView.reloadData()
            
            cell.selectionStyle = .blue
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainListListTableViewCell") as! MainListListTableViewCell
            let index = tableView.superview!.superview!.tag
            let listIndex = indexPath.row
            let list = globalMainList[index].list[listIndex].data
            cell.nicknameLabel.text = list.nickname
            cell.countLabel.text = "x" + String(globalMainList[index].list[listIndex].count)
            cell.backgroundColor = globalMyColor[globalGroupList[list.groupNumber].colorNumber]
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.mainListTableView {
            return mainListCellHeight
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        MainPageViewController.globalManiListChangeExceptSeatNumber(index1: sourceIndexPath.row, index2: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            AddMainListViewController.deleteGlobalMainList(listIndex: indexPath.row, stateString: "clear")
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

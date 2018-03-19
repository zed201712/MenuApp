//
//  SeatNumberPageViewController.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/9.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit


class SeatNumberPageViewController: UIViewController {
    
    @IBOutlet weak var drawView: DrawView!
    
    
    
    @IBOutlet weak var mainListView: SeatNumberPageTouchView!
    @IBOutlet weak var mainListTableView: UITableView!
    @IBOutlet weak var seatNumberLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var changeListDisplayLable: UIButton!
    
    var drawViewPpt = CGFloat(0)
    var drawCellUnitList: [CGFloat] = []
    var lastDrawListIndex = 0
    var drawViewTouchIndex = -1
    var selectMainListIndex = -1
    
    var touchEnd = true
    var isSetMainListView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.drawView.delegate = self
        self.mainListView.delegate = self
        self.changeListDisplayLable.layer.borderWidth = 0
        self.changeListDisplayLable.backgroundColor = UIColor.yellow
        self.changeListDisplayLable.layer.masksToBounds = true
        self.changeListDisplayLable.layer.cornerRadius = self.changeListDisplayLable.frame.width / 2
        FileRW.appFirstLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.calcDrawViewPpt()
        self.syncGraphWithMap()
        
        if self.drawViewTouchIndex >= 0 {
            self.selectMainListIndex = self.findMainListIndex(seatListIndex: self.drawViewTouchIndex)
        }
        if self.selectMainListIndex < 0 {
            if self.drawViewTouchIndex >= 0 {
                self.clsMainListView(seatNumber: String(self.drawViewTouchIndex))
            } else {
                self.clsMainListView(seatNumber: "-")
            }
        } else {
            self.changeSlideValueDraw()
            globalMainListIndex = self.selectMainListIndex
            self.setMainListView(listIndex: globalMainListIndex)
        }
        self.touchEnd = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - IBAction
    
    @IBAction func button1TouchUpInside(_ sender: Any) {
        //Clear Button
        
        let index = globalMainListIndex
        let seatNumber = String(globalMainList[index].seatNumber)
        AddMainListViewController.deleteGlobalMainList(listIndex: index, stateString: "clear")
        self.clsMainListView(seatNumber: seatNumber)
    }
    
    @IBAction func button2TouchUpInside(_ sender: Any) {
        
    }
    
    @IBAction func button3TouchUpInside(_ sender: Any) {
        //Check Button
        
        let index = globalMainListIndex
        self.button1.isHidden = globalMainList[index].isCheck
        globalMainList[index].isCheck = !globalMainList[index].isCheck
        self.setMainListView(listIndex: globalMainListIndex)
        
        FileRW.fileSaveMainList()
    }
    
    //MARK: - function
    
    func clsMainListView(seatNumber: String)->Void {
        isSetMainListView = false
        
        self.button1.isHidden = true
        self.button2.isHidden = true
        self.button3.isHidden = true
        
        self.seatNumberLabel.text = "Seat. " + seatNumber
        self.startTimeLabel.text = " - : -"
        self.priceLabel.text = "$ -"
        
        self.mainListView.backgroundColor = UIColor.white
        
        self.selectMainListIndex = -1
        self.mainListTableView.reloadData()
    }
    
    func setMainListView(listIndex: Int)->Void {
        isSetMainListView = true
        
        self.button3.isHidden = false
        
        let list = globalMainList[listIndex]
        self.seatNumberLabel.text = "Seat. " + SeatListManage.displayNumber(index: list.seatNumber)
        if list.startTime == "" {
            self.startTimeLabel.text = " - : -"
        } else {
            self.startTimeLabel.text = list.startTime
        }
        if list.price == "" {
            self.priceLabel.text = "$ -"
        } else {
            self.priceLabel.text = "$ " + list.price
        }
        
        self.button1.isHidden = !list.isCheck
        if list.list.count == 0 {
            self.mainListView.backgroundColor = UIColor.white
            self.button3.isHidden = true
        } else if list.isCheck {
            self.mainListView.backgroundColor = globalMyColor[myColorEnum.lightgreen.rawValue]
            self.button3.isHidden = false
        } else {
            self.mainListView.backgroundColor = globalMyColor[myColorEnum.gray.rawValue]
            self.button3.isHidden = false
        }
        self.mainListTableView.reloadData()
    }
    
    func findMainListIndex(seatListIndex: Int)->Int {
        return globalSeatList.findMainIndex(index: seatListIndex)
    }
    
    func globalMainListAdd(seatNumber: Int)->Void {
        globalMainListIndex = globalMainList.count
        
        var list = MainListForm()
        list.startTime = GetDateString.nowTime()
        list.startDate = GetDateString.nowDate()
        list.seatNumber = seatNumber
        MainPageViewController.globalMainListPut(list: list)
    }
    
    
    //MARK: - DrawView function
    
    func calcDrawViewPpt()->Void {
        var width = self.drawView.frame.size.width
        if width > self.drawView.frame.size.width {
            width = self.drawView.frame.size.height
        }
        drawViewPpt = CGFloat(width / CGFloat(globalSeatMapResolution))
        
        for x in 0..<globalSeatMapResolution {
            drawCellUnitList.append(CGFloat(x) * drawViewPpt)
        }
        drawCellUnitList.append(width - 1)
    }
    
    func resetDrawViewGraph()->Void {
        self.drawView.clearAll()
    }
    
    func clearDrawView()->Void {
        globalSeatList.groupMap = GroupMap(resolution: globalSeatMapResolution, limit: globalLimit)
        
        self.resetDrawViewGraph()
    }
    
    func syncGraphWithMap()->Void {
        self.resetDrawViewGraph()
        
        for x in 0..<globalSeatMapResolution {
            for y in 0..<globalSeatMapResolution {
                if globalSeatList.groupMap.gMap[x][y] != 0 {
                    let index = globalSeatList.groupMap.gMap[x][y]
                    globalSeatList.mainIndex[index] = -1
                    self.rectDrawView(mapPoint: CGPoint.init(x: x, y: y), color: globalMyColor[globalSeatList.myColorIndex[index]])
                }
            }
        }
        
        for list in globalMainList {
            if list.seatNumber >= 0 {
                self.drawGroupMapListDrawViewWithUseable(mapListIndex: list.seatNumber, color: globalMyColor[globalSeatList.myColorIndex[list.seatNumber]])
            }
        }
        self.changeSlideValueDraw()
    }
    
    func changeSlideValueDraw()->Void {
        if self.drawViewTouchIndex >= 0 {
            self.drawLastMapList()
            self.setLastDrawIndex(index: self.drawViewTouchIndex)
            self.drawGroupMapListDrawView(mapListIndex: self.lastDrawListIndex, color: UIColor.magenta.withAlphaComponent(1))
        }
    }
    
    func rectDrawView(mapPoint: CGPoint, color: UIColor)->Void {
        let x = Int(mapPoint.x)
        let y = Int(mapPoint.y)
        
        self.drawView.drawRect(rect: CGRect.init(x: drawCellUnitList[x], y: drawCellUnitList[y], width: drawViewPpt + 1, height: drawViewPpt + 1), color: color)
    }
    
    func setLastDrawIndex(index: Int)->Void {
        lastDrawListIndex = index
    }
    
    func drawLastMapList()->Void {
        var color = UIColor.red
        
        let mainListIndex = globalSeatList.findMainIndex(index: lastDrawListIndex)
        if globalSeatList.useable[lastDrawListIndex] {
            color = globalMyColor[globalSeatList.myColorIndex[lastDrawListIndex]]
        } else if mainListIndex >= 0 && globalMainList[mainListIndex].list.count == 0 {
            color = globalMyColor[globalSeatList.myColorIndex[lastDrawListIndex]]
        }
        self.drawGroupMapListDrawViewWithUseable(mapListIndex: lastDrawListIndex, color: color)
    }
    
    func drawGroupMapListDrawView(mapListIndex: Int, color: UIColor)->Void {
        for p in globalSeatList.groupMap.gList[mapListIndex] {
            self.rectDrawView(mapPoint: p, color: color)
        }
        self.setLastDrawIndex(index: mapListIndex)
    }
    
    func drawGroupMapListDrawViewWithUseable(mapListIndex: Int, color: UIColor)->Void {
        var tempColor = UIColor.red
        
        let mainListIndex = globalSeatList.findMainIndex(index: mapListIndex)
        if globalSeatList.useable[mapListIndex] {
            tempColor = color
        } else if mainListIndex >= 0 && globalMainList[mainListIndex].list.count == 0 {
            tempColor = color
        }
        self.drawGroupMapListDrawView(mapListIndex: mapListIndex, color: tempColor)
    }
}

extension SeatNumberPageViewController: DrawViewDelegate {
    func drawViewTouchEnd(point: CGPoint?) {
        self.touchEnd = true
        self.changeListDisplayLable.isHidden = true
        
        if let point = point {
            let x = Int(point.x / drawViewPpt)
            let y = Int(point.y / drawViewPpt)
            let mapPoint = CGPoint.init(x: x, y: y)
            if globalSeatList.groupMap.isValidInput(point: mapPoint, value: globalSeatList.groupMap.listLimit - 1) {
                let seatListIndex = globalSeatList.groupMap.gMap[x][y]
                let touchEndListIndex = self.findMainListIndex(seatListIndex: seatListIndex)
                
                if seatListIndex > 0 && self.selectMainListIndex >= 0 {
                    if touchEndListIndex >= 0 && touchEndListIndex != self.selectMainListIndex {
                        MainPageViewController.globalManiListChangeExceptSeatNumber(index1: touchEndListIndex, index2: self.selectMainListIndex)
                        globalMainListIndex = touchEndListIndex
                        self.setMainListView(listIndex: globalMainListIndex)
                        
                        let temp = self.lastDrawListIndex
                        self.setLastDrawIndex(index: globalMainList[self.selectMainListIndex].seatNumber)
                        self.drawLastMapList()
                        self.setLastDrawIndex(index: temp)
                        
                        self.drawViewTouchIndex = seatListIndex
                        self.changeSlideValueDraw()
                    } else if touchEndListIndex >= 0 && touchEndListIndex == self.selectMainListIndex {
                        if touchEndListIndex < globalMainList.count {
                            globalMainListIndex = self.selectMainListIndex
                            self.performSegue(withIdentifier: "SeatNumberToAddMainList", sender: nil)
                        }
                    }
                }
                
            }
        }
    }
    
    func drawViewTouch(point: CGPoint?)->Void {
        //self.changeListDisplayLable.frame.origin = CGPoint.init(x: self.drawView.frame.origin.x + point!.x, y: self.drawView.frame.origin.y + point!.y)
        self.changeListDisplayLable.center = CGPoint.init(x: self.drawView.frame.origin.x + point!.x, y: self.drawView.frame.origin.y + point!.y)
        
        if let point = point {
            let x = Int(point.x / drawViewPpt)
            let y = Int(point.y / drawViewPpt)
            let mapPoint = CGPoint.init(x: x, y: y)
            
            if globalSeatList.groupMap.isValidInput(point: mapPoint, value: globalSeatList.groupMap.listLimit - 1) {
                
                let seatListIndex = globalSeatList.groupMap.gMap[x][y]
                if seatListIndex != 0 {
                    if seatListIndex != self.drawViewTouchIndex {
                        self.drawViewTouchIndex = seatListIndex
                        self.changeSlideValueDraw()
                        
                        globalMainListIndex = self.findMainListIndex(seatListIndex: seatListIndex)
                        self.setMainListView(listIndex: globalMainListIndex)
                    }
                    
                    if self.touchEnd == true {
                        self.selectMainListIndex = self.findMainListIndex(seatListIndex: seatListIndex)
                        self.changeListDisplayLable.setTitle(String(seatListIndex), for: .normal)
                        self.changeListDisplayLable.isHidden = false
                    }
                } else if self.touchEnd == true {
                    self.selectMainListIndex = -1
                    self.drawViewTouchIndex = -1
                    self.drawLastMapList()
                    self.clsMainListView(seatNumber: "-")
                }
                
                
            }
        }
        
        self.touchEnd = false
    }
    
}

extension SeatNumberPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSetMainListView {
            return globalMainList[globalMainListIndex].list.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seatNumberPageTableViewCell") as! MainListListTableViewCell
        let index = globalMainListIndex
        let listIndex = indexPath.row
        let list = globalMainList[index].list[listIndex].data
        cell.nicknameLabel.text = list.nickname
        cell.countLabel.text = "x" + String(globalMainList[index].list[listIndex].count)
        cell.backgroundColor = globalMyColor[globalGroupList[list.groupNumber].colorNumber]
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

extension SeatNumberPageViewController: SeatNumberPageTouchViewDelegate {
    func touchViewTouchEnd(point: CGPoint?) {
        if globalMainListIndex >= 0 && globalMainListIndex < globalMainList.count {
            self.performSegue(withIdentifier: "SeatNumberToAddMainList", sender: nil)
        }
    }
}

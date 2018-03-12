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
    
    var drawViewPpt = CGFloat(0)
    var drawCellUnitList: [CGFloat] = []
    var lastDrawListIndex = 0
    var lastColorIndex = 0
    var drawViewTouchIndex = -1
    var selectMainListIndex = -1
    
    var touchEnd = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.drawView.delegate = self
        self.mainListView.delegate = self
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
            self.setMainListView(listIndex: self.selectMainListIndex)
        }
        self.touchEnd = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - IBAction
    
    @IBAction func button1TouchUpInside(_ sender: Any) {
        //Clear Button
        
        let index = self.selectMainListIndex
        let seatNumber = String(globalMainList[self.selectMainListIndex].seatNumber)
        AddMainListViewController.deleteGlobalMainList(listIndex: index, stateString: "clear")
        self.clsMainListView(seatNumber: seatNumber)
    }
    
    @IBAction func button2TouchUpInside(_ sender: Any) {
        
    }
    
    @IBAction func button3TouchUpInside(_ sender: Any) {
        //Check Button
        
        let index = self.selectMainListIndex
        self.button1.isHidden = globalMainList[index].isCheck
        globalMainList[index].isCheck = !globalMainList[index].isCheck
        self.setMainListView(listIndex: self.selectMainListIndex)
    }
    
    //MARK: - function
    
    func clsMainListView(seatNumber: String)->Void {
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
        self.button3.isHidden = false
        
        let list = globalMainList[listIndex]
        self.seatNumberLabel.text = "Seat. " + SeatListManage.displayNumber(index: list.seatNumber)
        self.startTimeLabel.text = list.startTime
        self.priceLabel.text = "$ " + list.price
        
        self.button1.isHidden = !list.isCheck
        if list.isCheck {
            self.mainListView.backgroundColor = globalMyColor[myColorEnum.lightgreen.rawValue]
        } else {
            self.mainListView.backgroundColor = globalMyColor[myColorEnum.lightblue.rawValue]
        }
        self.mainListTableView.reloadData()
    }
    
    func findMainListIndex(seatListIndex: Int)->Int {
        var findSeatListIndex = 0
        for list in globalMainList {
            if list.seatNumber == seatListIndex {
                break
            }
            findSeatListIndex = findSeatListIndex + 1
        }
        if findSeatListIndex < globalMainList.count {
            return findSeatListIndex
        } else {
            return -1
        }
    }
    
    func globalMainListAdd(seatNumber: Int)->Void {
        globalMainListIndex = globalMainList.count
        
        var list = MainListForm()
        list.startTime = GetDateString.nowTime()
        list.startDate = GetDateString.nowDate()
        list.seatNumber = seatNumber
        SeatListManage.setUseable(index: list.seatNumber, useable: false)
        globalMainList.append(list)
        while (globalGroupList.count >= globalLimit) {
            globalMainList.remove(at: 0)
            globalMainListIndex = globalMainListIndex - 1
        }
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
                    self.rectDrawView(mapPoint: CGPoint.init(x: x, y: y), color: globalMyColor[globalSeatList.myColorIndex[index]])
                }
            }
        }
        self.changeSlideValueDraw()
    }
    
    func changeSlideValueDraw()->Void {
        if drawViewTouchIndex >= 0 {
            self.drawLastMapList(color: globalMyColor[lastColorIndex])
            self.setLastDrawIndex(index: drawViewTouchIndex)
            self.drawGroupMapListDrawView(mapListIndex: lastDrawListIndex, color: UIColor.magenta.withAlphaComponent(1))
        }
    }
    
    func rectDrawView(mapPoint: CGPoint, color: UIColor)->Void {
        let x = Int(mapPoint.x)
        let y = Int(mapPoint.y)
        
        self.drawView.drawRect(rect: CGRect.init(x: drawCellUnitList[x], y: drawCellUnitList[y], width: drawViewPpt + 1, height: drawViewPpt + 1), color: color)
    }
    
    func setLastDrawIndex(index: Int)->Void {
        lastDrawListIndex = index
        lastColorIndex = globalSeatList.myColorIndex[lastDrawListIndex]
    }
    
    func drawLastMapList(color: UIColor)->Void {
        for p in globalSeatList.groupMap.gList[lastDrawListIndex] {
            self.rectDrawView(mapPoint: p, color: color)
        }
    }
    
    func drawGroupMapListDrawView(mapListIndex: Int, color: UIColor)->Void {
        for p in globalSeatList.groupMap.gList[mapListIndex] {
            self.rectDrawView(mapPoint: p, color: color)
        }
        self.setLastDrawIndex(index: mapListIndex)
    }
}

extension SeatNumberPageViewController: DrawViewDelegate {
    func drawViewTouchEnd(point: CGPoint?) {
        self.touchEnd = true
    }
    
    func drawViewTouch(point: CGPoint?)->Void {
        if self.touchEnd == false {
            return
        }
        
        self.touchEnd = false
        if let point = point {
            let x = Int(point.x / drawViewPpt)
            let y = Int(point.y / drawViewPpt)
            let mapPoint = CGPoint.init(x: x, y: y)
            
            if globalSeatList.groupMap.isValidInput(point: mapPoint, value: globalSeatList.groupMap.listLimit - 1) {
                
                let seatListIndex = globalSeatList.groupMap.gMap[x][y]
                if seatListIndex != 0 {
                    let lastSeatListIndex = self.drawViewTouchIndex
                    self.drawViewTouchIndex = seatListIndex
                    self.changeSlideValueDraw()
                    
                    var clickAgain = false
                    if lastSeatListIndex == seatListIndex {
                        clickAgain = true
                    }
                    if clickAgain {
                        if globalSeatList.useable[seatListIndex] {
                            globalMainListIndex = globalMainList.count
                            self.globalMainListAdd(seatNumber: seatListIndex)
                            self.performSegue(withIdentifier: "SeatNumberToAddMainList", sender: nil)
                        } else {
                            if self.selectMainListIndex >= 0 && self.selectMainListIndex < globalMainList.count {
                                globalMainListIndex = self.selectMainListIndex
                                self.performSegue(withIdentifier: "SeatNumberToAddMainList", sender: nil)
                            }
                        }
                    } else {
                        if globalSeatList.useable[seatListIndex] {
                            self.selectMainListIndex = -1
                            self.clsMainListView(seatNumber: String(seatListIndex))
                        } else {
                            self.selectMainListIndex = self.findMainListIndex(seatListIndex: seatListIndex)
                            
                            self.setMainListView(listIndex: self.selectMainListIndex)
                        }
                    }
                } else {
                    self.selectMainListIndex = -1
                    self.drawViewTouchIndex = -1
                    self.drawLastMapList(color: globalMyColor[lastColorIndex])
                    self.clsMainListView(seatNumber: "-")
                }
                
                
            }
        }
        
    }
    
}

extension SeatNumberPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectMainListIndex >= 0 {
            return globalMainList[self.selectMainListIndex].list.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seatNumberPageTableViewCell") as! MainListListTableViewCell
        let index = self.selectMainListIndex
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
        if self.selectMainListIndex >= 0 {
            globalMainListIndex = self.selectMainListIndex
            self.performSegue(withIdentifier: "SeatNumberToAddMainList", sender: nil)
        }
    }
}

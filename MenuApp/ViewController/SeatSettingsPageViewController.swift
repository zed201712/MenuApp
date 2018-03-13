//
//  SeatSettingsPageViewController.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/7.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class SeatSettingsPageViewController: UIViewController {
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var seatNumberLabel: UILabel!
    @IBOutlet weak var seatNumberSlider: UISlider!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var drawViewPpt = CGFloat(0)
    var drawCellUnitList: [CGFloat] = []
    var lastDrawListIndex = 0
    var lastColorIndex = 0
    var colorGroupIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FileRW.appFirstLoad()
        
        drawView.clipsToBounds = true
        drawView.isMultipleTouchEnabled = false
        drawView.delegate = self
        
        self.seatNumberSlider.minimumValue = 1
        self.seatNumberSlider.maximumValue = Float(globalLimit)
        self.seatNumberLabel.text = String(Int(self.seatNumberSlider.value))
        
        self.setLastDrawIndex(index: Int(self.seatNumberSlider.value))
        
        self.drawView.backgroundColor = UIColor.white
        self.clearButton.layer.borderWidth = 1
        
        let layout = UICollectionViewFlowLayout()
        let screenSize = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width: Int(screenSize.width) / globalMyColor.count, height: 30)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.colorCollectionView.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.calcDrawViewPpt()
        self.syncGraphWithMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction
    
    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        FileRW.fileSaveSeatList()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func SeatNumberAddDragInside(_ sender: Any) {
        self.countAdd()
    }
    @IBAction func SeatNumberAddTouchUpInside(_ sender: Any) {
        self.countAdd()
        self.changeSlideValueDraw()
    }
    
    @IBAction func SeatNumberSubButtonDragInside(_ sender: Any) {
        self.countSub()
    }
    
    @IBAction func SeatNumberSubButtonTouchUpInside(_ sender: Any) {
        self.countSub()
        self.changeSlideValueDraw()
    }
    
    @IBAction func seatNumberSliderTouchUpInside(_ sender: Any) {
        self.changeSlideValueDraw()
    }
    
    @IBAction func seatNumberSliderValueChanged(_ sender: Any) {
        let slider = sender as! UISlider
        let intSliderValue = Float(Int(slider.value))
        var point = slider.value - intSliderValue
        
        if point < 0.5 {
            point = 0
        } else {
            point = 1
        }
        slider.value = intSliderValue + point
        seatNumberLabel.text = String(Int(self.seatNumberSlider.value))
    }
    
    @IBAction func clearButtonTouchUpInside(_ sender: Any) {
        self.clearButton.tag = 1 - self.clearButton.tag
        if self.clearButton.tag == 1 {
            self.clearButton.backgroundColor = globalMyColor[myColorEnum.lightgreen.rawValue]
        } else {
            self.clearButton.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func clearAllButtonTouchUpInside(_ sender: Any) {
        self.clearDrawView()
    }
    //MARK: - Function
    func countAdd()->Void {
        let intSliderValue = self.seatNumberSlider.value + 1
        if intSliderValue >= self.seatNumberSlider.minimumValue {
            self.seatNumberSlider.value = intSliderValue
            self.seatNumberLabel.text = String(Int(self.seatNumberSlider.value))
        }
    }
    
    func countSub()->Void {
        let intSliderValue = self.seatNumberSlider.value - 1
        if intSliderValue <= self.seatNumberSlider.maximumValue {
            self.seatNumberSlider.value = intSliderValue
            self.seatNumberLabel.text = String(Int(self.seatNumberSlider.value))
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
        
        let w = self.drawView.frame.size.width
        let h = self.drawView.frame.size.height
        
        for x in 0..<drawCellUnitList.count {
            self.drawView.drawLine(startPoint: CGPoint.init(x: drawCellUnitList[x], y: 0), endPoint: CGPoint.init(x: drawCellUnitList[x], y: h), width: 1, color: UIColor.red)
        }
        for y in 0..<drawCellUnitList.count {
            self.drawView.drawLine(startPoint: CGPoint.init(x: 0, y: drawCellUnitList[y]), endPoint: CGPoint.init(x: w, y: drawCellUnitList[y]), width: 1, color: UIColor.red)
        }
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
                    self.rectDrawView(mapPoint: CGPoint.init(x: x, y: y), color: UIColor.black)
                }
            }
        }
        self.setLastDrawIndex(index: Int(self.seatNumberSlider.value))
        self.drawGroupMapListDrawView(mapListIndex: lastDrawListIndex, color: globalMyColor[globalSeatList.myColorIndex[lastDrawListIndex]])
    }
    
    func changeSlideValueDraw()->Void {
        self.drawLastMapList(color: UIColor.black)
        self.setLastDrawIndex(index: Int(self.seatNumberSlider.value))
        
        globalSeatList.myColorIndex[lastDrawListIndex] = self.colorGroupIndex
        self.drawGroupMapListDrawView(mapListIndex: lastDrawListIndex, color: globalMyColor[globalSeatList.myColorIndex[lastDrawListIndex]])
    }
    
    func rectDrawView(mapPoint: CGPoint, color: UIColor)->Void {
        let w = self.drawView.frame.size.width
        let h = self.drawView.frame.size.height
        
        let x = Int(mapPoint.x)
        let y = Int(mapPoint.y)
        
        self.drawView.drawRect(rect: CGRect.init(x: drawCellUnitList[x], y: drawCellUnitList[y], width: drawViewPpt - 1, height: drawViewPpt - 1), color: color)
        
        self.drawView.drawLine(startPoint: CGPoint.init(x: drawCellUnitList[x], y: 0), endPoint: CGPoint.init(x: drawCellUnitList[x], y: h), width: 1, color: UIColor.red)
        self.drawView.drawLine(startPoint: CGPoint.init(x: drawCellUnitList[x + 1], y: 0), endPoint: CGPoint.init(x: drawCellUnitList[x + 1], y: h), width: 1, color: UIColor.red)
        
        self.drawView.drawLine(startPoint: CGPoint.init(x: 0, y: drawCellUnitList[y]), endPoint: CGPoint.init(x: w, y: drawCellUnitList[y]), width: 1, color: UIColor.red)
        self.drawView.drawLine(startPoint: CGPoint.init(x: 0, y: drawCellUnitList[y + 1]), endPoint: CGPoint.init(x: w, y: drawCellUnitList[y + 1]), width: 1, color: UIColor.red)
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

extension SeatSettingsPageViewController: DrawViewDelegate {
    func drawViewTouchEnd(point: CGPoint?) {
        
    }
    
    func drawViewTouch(point: CGPoint?)->Void {
        
        if let point = point {
            let value = Int(self.seatNumberSlider.value)
            let x = Int(point.x / drawViewPpt)
            let y = Int(point.y / drawViewPpt)
            let mapPoint = CGPoint.init(x: x, y: y)
            
            if globalSeatList.groupMap.isValidInput(point: mapPoint, value: globalSeatList.groupMap.listLimit - 1) {
                
                
                if self.clearButton.tag == 1 {
                    if globalSeatList.groupMap.gMap[x][y] != 0 {
                        globalSeatList.groupMap.delete(point: mapPoint)
                        self.rectDrawView(mapPoint: mapPoint, color: UIColor.white)
                    }
                } else {
                    if globalSeatList.groupMap.gMap[x][y] != value {
                        globalSeatList.groupMap.add(point: mapPoint, value: value)
                        self.rectDrawView(mapPoint: mapPoint, color: globalMyColor[globalSeatList.myColorIndex[value]])
                    }
                }
                
                
            }
        }
        
    }
    
}

extension SeatSettingsPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalMyColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "normalCollectionViewCell", for: indexPath)
        cell.backgroundColor = globalMyColor[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = Int(self.seatNumberSlider.value)
        colorGroupIndex = indexPath.row
        
        globalSeatList.myColorIndex[index] = indexPath.row
        self.setLastDrawIndex(index: index)
        self.drawGroupMapListDrawView(mapListIndex: index, color: globalMyColor[globalSeatList.myColorIndex[index]])
    }
}

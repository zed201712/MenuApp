//
//  FileRW.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/2/16.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

enum fileSettingProperty: String {
    case listSettingsFileName = "ListSettings.txt"
    case mainListSettingsFileName = "MainListSettings.txt"
    case seatListSettingsFileName = "SeatListSettings.txt"
    case settingsVersion = "v001"
    case componentsSign = "\n"
}

class FileRW: NSObject {
    
    static var rwString = ""
    static var rwStringArray: [String] = []
    static var rwStringArrayIndex = 0
    static var firstLoad = false
    
    //MARK: - sample
    class func FileWrite(fileName: String, content: String)->Void {
        do {
            try content.write(toFile: NSHomeDirectory() + "/Documents/" + fileName, atomically: true, encoding: .unicode)
        } catch {
            print("Write fail")
        }
    }
    
    class func FileRead(fileName: String)->String {
        var loadStr = ""
        do {
            try loadStr = String(NSString(contentsOfFile: NSHomeDirectory() + "/Documents/" + fileName, encoding: String.Encoding.unicode.rawValue))
        } catch {
            print("Read fail")
        }
        
        return loadStr
    }
    
    class func FileExists(path: String)->Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    class func FileDir(path: String)->[String]? {
        var dirPath = path
        if dirPath == "" {
            dirPath = NSHomeDirectory()
        }
        do {
            let fileList = try FileManager.default.contentsOfDirectory(atPath: dirPath)
            return fileList
        } catch {
            print("Cannot List directory")
        }
        return nil
    }
    
    //MARK: - MyDefine
    class func appFirstLoad()->Void {
        if firstLoad == false {
            firstLoad = true
            
            let path = NSHomeDirectory() + "/Documents/"
            var noSettingsFile = true
            if let fileNameArray = self.FileDir(path: path) {
                for fileName in fileNameArray {
                    if fileName == fileSettingProperty.listSettingsFileName.rawValue {
                        noSettingsFile = false
                        break
                    } else if fileName == fileSettingProperty.mainListSettingsFileName.rawValue {
                        noSettingsFile = false
                        break
                    } else if fileName == fileSettingProperty.seatListSettingsFileName.rawValue {
                        noSettingsFile = false
                        break
                    }
                }
            }
            
            if noSettingsFile {
                var temp = globalSampleSettingsString
                FileRW.fileStringLoad(loadString: &temp)
                FileRW.rwString = temp
                FileRW.fileSave()
            } else {
                self.fileLoadAll()
            }
        }
    }
    class func fileLoadAll()->Void {
        self.fileLoad(fileName: fileSettingProperty.listSettingsFileName.rawValue)
        self.fileLoad(fileName: fileSettingProperty.seatListSettingsFileName.rawValue)
        self.fileLoad(fileName: fileSettingProperty.mainListSettingsFileName.rawValue)
    }
    
    class func fileSaveMenuList()->Void {
        let _ = self.fileSaveMenuListString()
        
        FileRW.fileSave()
    }
    
    class func fileSaveSeatList()->Void {
        let _ = self.fileSaveSeatListString()
        
        FileRW.fileSave()
    }
    
    class func fileSaveMainList()->Void {
        let _ = self.fileSaveMainListString()
        
        FileRW.fileSave()
    }
    
    class func fileSave()->Void {
        rwStringArray = self.rwString.components(separatedBy: fileSettingProperty.componentsSign.rawValue)
        let arrCount = rwStringArray.count
        
        self.rwStringArrayIndex = 0
        var tempIndex = arrCount
        var fileName = ""
        
        if arrCount > 2 {
            if FileRW.getNext() == fileSettingProperty.settingsVersion.rawValue {
                fileName = FileRW.getNext()
                switch fileName {
                    case fileSettingProperty.listSettingsFileName.rawValue:
                        tempIndex = 2
                    case fileSettingProperty.mainListSettingsFileName.rawValue:
                        tempIndex = 2
                    case fileSettingProperty.seatListSettingsFileName.rawValue:
                        tempIndex = 2
                    default:
                        tempIndex = arrCount
                }
            }
        }
        self.rwStringArrayIndex = tempIndex
        
        if self.rwStringArrayIndex < arrCount {
            FileRW.FileWrite(fileName: fileName, content: self.rwString)
        }
    }
    
    class func fileStringLoad(loadString: inout String)->Void {
        rwStringArray = loadString.components(separatedBy: fileSettingProperty.componentsSign.rawValue)
        let arrCount = rwStringArray.count
        
        self.rwStringArrayIndex = 0
        var tempIndex = arrCount
        var fileName = ""
        if arrCount > 2 {
            if FileRW.getNext() == fileSettingProperty.settingsVersion.rawValue {
                fileName = FileRW.getNext()
                tempIndex = 2
                
                switch fileName {
                case fileSettingProperty.mainListSettingsFileName.rawValue:
                    globalMainList.removeAll()
                    globalSeatList.useable = Array<Bool>(repeating: true, count: globalLimit)
                case fileSettingProperty.listSettingsFileName.rawValue:
                    globalGroupList.removeAll()
                    globalMenuList.removeAll()
                case fileSettingProperty.seatListSettingsFileName.rawValue:
                    globalSeatList.myColorIndex = Array<Int>(repeating: 0, count: globalLimit)
                    globalSeatList.groupMap = GroupMap(resolution: globalSeatMapResolution, limit: globalLimit)
                default:
                    tempIndex = arrCount
                }
            }
        }
        self.rwStringArrayIndex = tempIndex
        
        while (self.rwStringArrayIndex < arrCount) {
            let typeName: String = FileRW.getNext()
            if (typeName == "Group") {
                var temp = GroupDataForm()
                temp.colorNumber = FileRW.getNext()
                temp.name = FileRW.getNext()
                
                globalGroupList.append(temp)
            }
            
            if (typeName == "Menu") {
                var temp = ListDataForm()
                temp.groupNumber = FileRW.getNext()
                temp.name = FileRW.getNext()
                temp.nickname = FileRW.getNext()
                temp.price = FileRW.getNext()
                
                globalMenuList.append(temp)
            }
            
            if (typeName == "SeatNumber") {
                let index: Int = FileRW.getNext()
                globalSeatList.myColorIndex[index] = FileRW.getNext()
                let count: Int = FileRW.getNext()
                for _ in 0 ..< count {
                    let x: Int = FileRW.getNext()
                    let y: Int = FileRW.getNext()
                    globalSeatList.groupMap.add(point: CGPoint.init(x: x, y: y), value: index)
                }
            }
            
            if (typeName == "Order") {
                var temp = MainListForm()
                temp.seatNumber = FileRW.getNext()
                SeatListManage.setUseable(index: temp.seatNumber, useable: false)
                temp.startTime = FileRW.getNext()
                temp.isHidden = FileRW.getNext()
                temp.detailInfo = FileRW.getNext()
                temp.state = FileRW.getNext()
                temp.startDate = FileRW.getNext()
                temp.endDate = FileRW.getNext()
                temp.price = FileRW.getNext()
                temp.isCheck = FileRW.getNext()
                
                let listCount: Int = FileRW.getNext()
                for _ in 0 ..< listCount {
                    var listAndCount = ListAndCount()
                    listAndCount.count = FileRW.getNext()
                    listAndCount.countIndex = FileRW.getNext()
                    listAndCount.listIndex = FileRW.getNext()
                    listAndCount.data.name = FileRW.getNext()
                    listAndCount.data.groupNumber = FileRW.getNext()
                    listAndCount.data.nickname = FileRW.getNext()
                    listAndCount.data.price = FileRW.getNext()
                    
                    temp.list.append(listAndCount)
                }
                
                globalMainList.append(temp)
            }
        }
    }
    class func fileLoad(fileName: String)->Void {
        var loadStr = FileRW.FileRead(fileName: fileName)
        
        self.fileStringLoad(loadString: &loadStr)
    }
    
    class func fileSaveMenuListString()->String {
        self.rwString = fileSettingProperty.settingsVersion.rawValue
        self.putNext(input: fileSettingProperty.listSettingsFileName.rawValue)
        
        for temp in globalGroupList {
            self.putNext(input: "Group")
            self.putNext(input: temp.colorNumber)
            self.putNext(input: temp.name)
        }
        for temp in globalMenuList {
            self.putNext(input: "Menu")
            self.putNext(input: temp.groupNumber)
            self.putNext(input: temp.name)
            self.putNext(input: temp.nickname)
            self.putNext(input: temp.price)
        }
        
        return self.rwString
    }
    
    class func fileSaveSeatListString()->String {
        self.rwString = fileSettingProperty.settingsVersion.rawValue
        self.putNext(input: fileSettingProperty.seatListSettingsFileName.rawValue)
        
        for i in 0 ..< globalSeatList.groupMap.gList.count {
            let list = globalSeatList.groupMap.gList[i]
            if list.count > 0 {
                self.putNext(input: "SeatNumber")
                self.putNext(input: i)
                self.putNext(input: globalSeatList.myColorIndex[i])
                self.putNext(input: list.count)
                for point in list {
                    self.putNext(input: Int(point.x))
                    self.putNext(input: Int(point.y))
                }
            }
        }
        
        return self.rwString
    }
    
    class func fileSaveMainListString()->String {
        self.rwString = fileSettingProperty.settingsVersion.rawValue
        self.putNext(input: fileSettingProperty.mainListSettingsFileName.rawValue)
        
        for temp in globalMainList {
            self.putNext(input: "Order")
            self.putNext(input: temp.seatNumber)
            self.putNext(input: temp.startTime)
            self.putNext(input: temp.isHidden)
            self.putNext(input: temp.detailInfo)
            self.putNext(input: temp.state)
            self.putNext(input: temp.startDate)
            self.putNext(input: temp.endDate)
            self.putNext(input: temp.price)
            self.putNext(input: temp.isCheck)
            
            self.putNext(input: temp.list.count)
            for list in temp.list {
                self.putNext(input: list.count)
                self.putNext(input: list.countIndex)
                self.putNext(input: list.listIndex)
                self.putNext(input: list.data.name)
                self.putNext(input: list.data.groupNumber)
                self.putNext(input: list.data.nickname)
                self.putNext(input: list.data.price)
            }
        }
        
        return self.rwString
    }
    
    class func getNext()->Bool {
        self.rwStringArrayIndex = self.rwStringArrayIndex + 1
        return Bool(self.rwStringArray[self.rwStringArrayIndex - 1])!
    }
    
    class func getNext()->Int {
        self.rwStringArrayIndex = self.rwStringArrayIndex + 1
        return Int(self.rwStringArray[self.rwStringArrayIndex - 1])!
    }
    
    class func getNext()->String {
        self.rwStringArrayIndex = self.rwStringArrayIndex + 1
        return self.rwStringArray[self.rwStringArrayIndex - 1].decodeCommandString()
    }
    
    class func putNext(input: Bool)->Void {
        self.rwString = self.rwString + fileSettingProperty.componentsSign.rawValue + String(input)
    }
    
    class func putNext(input: Int)->Void {
        self.rwString = self.rwString + fileSettingProperty.componentsSign.rawValue + String(input)
    }
    
    class func putNext(input: String)->Void {
        self.rwString = self.rwString + fileSettingProperty.componentsSign.rawValue + input.encodeCommandString()
    }
}

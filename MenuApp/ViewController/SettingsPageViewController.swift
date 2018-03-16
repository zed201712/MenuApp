//
//  SettingsPageViewController.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/7.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

enum SettingPageEnum: Int {
    case ListSettingPage = 0
    case SeatSettingPage
    case listHistory
    case settingsWithTextAll
    case settingsWithTextMenuList
    case settingsWithTextMainList
    case settingsWithTextSeatList
    case settingsSample
    case count
}

class SettingsPageViewController: UIViewController {
    var clickCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.myColorInit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsToSettingsWithTextView" {
            let vc = segue.destination as! SettingsWithTextViewController
            
            vc.delegate = self
        }
    }
    
    //MARK: - function
    func myColorInit()->Void {
        globalMyColor.append(UIColor.init(red: 255/255, green: 200/255, blue: 15/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 34/255, green: 177/255, blue: 77/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 0/255, green: 162/255, blue: 232/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 195/255, green: 195/255, blue: 195/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 185/255, green: 122/255, blue: 87/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 255/255, green: 174/255, blue: 200/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 239/255, green: 228/255, blue: 176/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 181/255, green: 230/255, blue: 30/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 153/255, green: 217/255, blue: 234/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 112/255, green: 146/255, blue: 190/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 200/255, green: 192/255, blue: 232/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 255/255, green: 128/255, blue: 40/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 255/255, green: 243/255, blue: 0/255, alpha: 1))
        globalMyColor.append(UIColor.init(red: 0/255, green: 128/255, blue: 0/255, alpha: 1))
        
        globalMyColor[myColorEnum.orange.rawValue] = UIColor.orange
    }
    
    func listHistoryDetailListFormat(list: [ListAndCount])->String {
        var temp = ""
        let sign = "-"
        let listHistoryFormatSign = ","
        
        if list.count > 0 {
            temp = list[0].data.name + sign + list[0].data.price + sign + String(list[0].count)
        }
        for i in 1 ..< list.count {
            temp = temp + listHistoryFormatSign + list[i].data.name + sign + list[i].data.price + sign + String(list[i].count)
        }
        
        return temp
    }
    
    func listHistoryFormat(list: MainListForm)->String {
        var temp = list.startTime
        let sign = ","
        
        temp = temp + sign + list.endDate
        temp = temp + sign + String(list.seatNumber)
        temp = temp + sign + list.price
        temp = temp + sign + list.detailInfo
        temp = temp + sign + self.listHistoryDetailListFormat(list: list.list)
        
        return temp
    }
    
    func listHistoryString()->String {
        var temp = ""
        let sign = "\n"
        
        for list in globalMainListHistory {
            temp = temp + self.listHistoryFormat(list: list) + sign
        }
        
        return temp
    }
}

extension SettingsPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingPageEnum.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case SettingPageEnum.ListSettingPage.rawValue:
            cell.textLabel?.text = NSLocalizedString("Menu Settings", comment: "")
        case SettingPageEnum.SeatSettingPage.rawValue:
            cell.textLabel?.text = NSLocalizedString("Seat Settings", comment: "")
        case SettingPageEnum.listHistory.rawValue:
            cell.textLabel?.text = NSLocalizedString("List History", comment: "")
        case SettingPageEnum.settingsWithTextAll.rawValue:
            cell.textLabel?.text = NSLocalizedString("Save All Settings with context", comment: "")
        case SettingPageEnum.settingsWithTextMenuList.rawValue:
            cell.textLabel?.text = NSLocalizedString("Save Menu Settings with context", comment: "")
        case SettingPageEnum.settingsWithTextMainList.rawValue:
            cell.textLabel?.text = NSLocalizedString("Save List Settings with context", comment: "")
        case SettingPageEnum.settingsWithTextSeatList.rawValue:
            cell.textLabel?.text = NSLocalizedString("Save Map Settings with context", comment: "")
        case SettingPageEnum.settingsSample.rawValue:
            cell.textLabel?.text = NSLocalizedString("Sample Settings context", comment: "")
        default:
            print("Settings Page Error")
        }
        cell.textLabel?.text = String(indexPath.row + 1) + ". " + (cell.textLabel?.text)!
        
        cell.selectionStyle = .blue
        cell.backgroundColor = globalMyColor[myColorEnum.lightblue.rawValue]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        clickCellIndex = indexPath.row
        
        switch indexPath.row {
        case SettingPageEnum.ListSettingPage.rawValue:
            self.performSegue(withIdentifier: "ListSetting", sender: nil)
        case SettingPageEnum.SeatSettingPage.rawValue:
            self.performSegue(withIdentifier: "SeatSettings", sender: nil)
        case SettingPageEnum.listHistory.rawValue:
            self.performSegue(withIdentifier: "settingsToSettingsWithTextView", sender: nil)
        case SettingPageEnum.settingsWithTextAll.rawValue:
            self.performSegue(withIdentifier: "settingsToSettingsWithTextView", sender: nil)
        case SettingPageEnum.settingsWithTextMenuList.rawValue:
            self.performSegue(withIdentifier: "settingsToSettingsWithTextView", sender: nil)
        case SettingPageEnum.settingsWithTextMainList.rawValue:
            self.performSegue(withIdentifier: "settingsToSettingsWithTextView", sender: nil)
        case SettingPageEnum.settingsWithTextSeatList.rawValue:
            self.performSegue(withIdentifier: "settingsToSettingsWithTextView", sender: nil)
        case SettingPageEnum.settingsSample.rawValue:
            self.performSegue(withIdentifier: "settingsToSettingsWithTextView", sender: nil)
        default:
            print("Settings Page Error")
        }
        
    }
}

extension SettingsPageViewController: SettingsWithTextViewDelegate {
    func getFileData() -> String {
        let sign = fileSettingProperty.componentsSign.rawValue + fileSettingProperty.componentsSign.rawValue
        
        switch clickCellIndex {
            case SettingPageEnum.listHistory.rawValue:
                return self.listHistoryString()
            case SettingPageEnum.settingsWithTextAll.rawValue:
                return FileRW.fileSaveMenuListString() + sign + FileRW.fileSaveMainListString() + sign + FileRW.fileSaveSeatListString()
            case SettingPageEnum.settingsWithTextMenuList.rawValue:
                return FileRW.fileSaveMenuListString()
            case SettingPageEnum.settingsWithTextMainList.rawValue:
                return FileRW.fileSaveMainListString()
            case SettingPageEnum.settingsWithTextSeatList.rawValue:
                return FileRW.fileSaveSeatListString()
            case SettingPageEnum.settingsSample.rawValue:
                return globalSampleSettingsString
            default:
                return ""
        }
    }
}

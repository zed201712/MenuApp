//
//  ListSettingViewController.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/2/15.
//  Copyright © 2018年 Zed. All rights reserved.
//


import UIKit

class ListSettingViewController: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var AddGroupButton: UIButton!
    
    var uiIndex = UIIndex()
    
    var colorButton: [UIButton] = []
    
    var groupUiArray = GroupUIArray()
    var groupLimit = CGFloat(5)
    var groupButtonWidth = CGFloat(0)
    
    //MARK: - View
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FileRW.appFirstLoad()
        
        listTableView.isEditing = true
        groupButtonWidth = self.view.frame.size.width / groupLimit
        
        let imgView = UIImageView()
        imgView.image = UIImage(named: "BG1")
        self.listTableView.backgroundView = imgView
        
        for i in 0..<globalMyColor.count {
            let bt = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            bt.titleLabel?.text = ""
            bt.backgroundColor = globalMyColor[i]
            bt.tag = i
            bt.removeTarget(nil, action: nil, for: .allEvents)
            bt.addTarget(self, action: #selector(colorButtonTouchUpInside), for: .touchUpInside)
            self.view.addSubview(bt)
            colorButton.append(bt)
        }
        refreshColorButton(isLandscape: false)
        
        if globalGroupList.count > 0 {
            for i in 0..<globalGroupList.count {
                self.addgroupNameTextView()
                groupUiArray.groupNameTextView[i]!.text = globalGroupList[i].name
                uiIndex.groupIndex = i
                self.refreshGroupColor()
            }
        } else {
            self.addGroup()
            globalGroupList[0].name = NSLocalizedString("ALL", comment: "")
            self.groupUiArray.groupNameTextView[0]!.text = NSLocalizedString("ALL", comment: "")
        }
        uiIndex.groupIndex = 0
        self.highlightTextview(textView: groupUiArray.groupNameTextView[0]!)
        self.menuReload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction
    
    @IBAction func AddListButtonTouchUpInside(_ sender: Any) {
        var temp = ListDataForm()
        temp.name = "NA"
        temp.groupNumber = uiIndex.groupIndex
        globalMenuList.append(temp)
        
        self.menuReload()
    }
    
    @IBAction func addGroupButtonTouchUpInside(_ sender: Any) {
        self.addGroup()
    }
    
    @IBAction func removeGroupButtonTouchUpInside(_ sender: Any) {
        self.removeGroup(index: uiIndex.groupIndex)
    }
    
    
    @objc func colorButtonTouchUpInside(sender: Any) {
        let button = sender as! UIButton
        globalGroupList[uiIndex.groupIndex].colorNumber = button.tag
        
        self.selectMenuCell().backgroundColor = globalMyColor[globalGroupList[globalMenuList[uiIndex.menuIndex].groupNumber].colorNumber]
        self.refreshGroupColor()
        self.highlightTextview(textView: groupUiArray.groupNameTextView[uiIndex.groupIndex]!)
        self.menuReload()
    }
    
    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        FileRW.fileSaveMenuList()
        self.dismiss(animated: false, completion: nil)
    }
    //MARK: - Private Function
    
    func intToChar(value:Int, signAdd: String)->Character {
        let temp = Character(UnicodeScalar(value + Int(signAdd.mid(start: 1, length: 1).utf8.min()!))!)
        
        return temp
    }
    
    func refreshColorButton(isLandscape: Bool) {
        //DispatchQueue.main.async {
            for i in 0..<globalMyColor.count {
                var frame = self.view.frame
                frame.origin.y = CGFloat(AddGroupButton.frame.origin.y + AddGroupButton.frame.size.height) + 50//groupNameTextView height
                if isLandscape == true {
                    frame.size.width = frame.size.height / CGFloat(globalMyColor.count)
                } else {
                    frame.size.width = frame.size.width / CGFloat(globalMyColor.count)
                }
                frame.size.height = 30
                frame.origin.x = CGFloat(i) * frame.size.width
                self.colorButton[i].frame = frame
            }
        //}
    }
    
    func addGroup() {
        if globalGroupList.count < Int(groupLimit) {
            var temp = GroupDataForm()
            temp.name = "NA"
            temp.colorNumber = globalGroupList.count % globalMyColor.count
            globalGroupList.append(temp)
            
            self.addgroupNameTextView()
        }
    }
    
    func addgroupNameTextView()->Void {
        let text = UITextView()
        let index = CGFloat(groupUiArray.groupNameTextView.count)
        text.frame = CGRect(x: index * groupButtonWidth, y: CGFloat(AddGroupButton.frame.origin.y + AddGroupButton.frame.size.height), width: groupButtonWidth, height: 50)
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.black.cgColor
        text.text = "NA"
        text.backgroundColor = globalMyColor[groupUiArray.groupNameTextView.count % globalMyColor.count]
        text.delegate = self
        text.tag = Int(index)
        groupUiArray.groupNameTextView.append(text)
        self.view.addSubview(text)
    }
    
    func removeGroup(index: Int) {
        if index > 0 && index < groupUiArray.groupNameTextView.count {
            
            globalGroupList.remove(at: index)
            groupUiArray.groupNameTextView[index]?.removeFromSuperview()
            groupUiArray.groupNameTextView[index] = nil
            groupUiArray.groupNameTextView.remove(at: index)
            
            self.refreshGroupButtonTag()
            
            if uiIndex.groupIndex >= globalGroupList.count {
                uiIndex.groupIndex = globalGroupList.count - 1
            }
            if self.isGroupIndexVaild() {
                self.refreshGroupColor()
                self.highlightTextview(textView: groupUiArray.groupNameTextView[uiIndex.groupIndex]!)
            }
        }
    }
    
    func refreshGroupButtonTag() {
        var i = 0
        for text in groupUiArray.groupNameTextView {
            text?.tag = i
            text?.frame.origin.x = CGFloat(i) * groupButtonWidth
            i = i + 1
        }
    }
    
    func refreshGroupColor() {
        if self.isGroupIndexVaild() {
            groupUiArray.groupNameTextView[uiIndex.groupIndex]!.backgroundColor = globalMyColor[globalGroupList[uiIndex.groupIndex].colorNumber]
        }
    }
    
    func highlightTextview(textView: UITextView) {
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var p = CGFloat(0)
        
        if self.isGroupIndexVaild() {
            textView.backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &p)
            let gray = CGFloat(30) / CGFloat(255)
            r = r + gray
            if r > 1 {r = 1}
            g = g + gray
            if g > 1 {g = 1}
            b = b + gray
            if b > 1 {b = 1}
            textView.backgroundColor = UIColor.init(red: r, green: g, blue: b, alpha: p)
        }
    }
    
    func isGroupIndexVaild()->Bool {
        return uiIndex.groupIndex >= 0 && uiIndex.groupIndex < groupUiArray.groupNameTextView.count
    }
    
    func isMenuIndexVaild()->Bool {
        return uiIndex.menuIndex >= 0 && uiIndex.menuIndex < globalMenuList.count
    }
    
    func menuReload() {
        listTableView.reloadData()
    }
    
    func selectMenuCell()->ListSettingViewCell {
        let index = IndexPath.init(row: uiIndex.menuIndex, section: 0)
        return self.listTableView.cellForRow(at: index) as! ListSettingViewCell
    }
}

//MARK: - UITextViewDelegate
extension ListSettingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.textViewIsMenuTextView(textView: textView) == true {
            uiIndex.menuIndex = textView.tag
        } else {
            if self.isGroupIndexVaild() {
                self.refreshGroupColor()
            }
            uiIndex.groupIndex = textView.tag
            if self.isGroupIndexVaild() {
                self.highlightTextview(textView: groupUiArray.groupNameTextView[uiIndex.groupIndex]!)
            }
        }
        
        if self.isMenuIndexVaild() {
            globalMenuList[uiIndex.menuIndex].groupNumber = uiIndex.groupIndex
            self.selectMenuCell().backgroundColor = globalMyColor[globalGroupList[uiIndex.groupIndex].colorNumber]
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        globalGroupList[uiIndex.groupIndex].name = groupUiArray.groupNameTextView[uiIndex.groupIndex]!.text
        if isMenuIndexVaild() {
            globalMenuList[uiIndex.menuIndex].name = self.selectMenuCell().menuNameTextView.text
        }
    }
    
    func textViewIsMenuTextView(textView: UITextView)->Bool {
        var returnValue = false
        let tempIndex = uiIndex.menuIndex
        
        uiIndex.menuIndex = textView.tag
        if isMenuIndexVaild() {
            if self.selectMenuCell().menuNameTextView == textView {
                returnValue = true
            }
        }
        uiIndex.menuIndex = tempIndex
        
        
        return returnValue
    }
}

//MARK: - UITextFieldDelegate
extension ListSettingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        uiIndex.menuIndex = textField.tag
        globalMenuList[uiIndex.menuIndex].groupNumber = uiIndex.groupIndex
        self.selectMenuCell().backgroundColor = globalMyColor[globalGroupList[globalMenuList[uiIndex.menuIndex].groupNumber].colorNumber]
    }
    
    @objc func priceEditingChanged() {
        globalMenuList[uiIndex.menuIndex].price = self.selectMenuCell().menuPriceText.text!
        globalMenuList[uiIndex.menuIndex].nickname = self.selectMenuCell().menuNicknameText.text!
    }
}

extension ListSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalMenuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(menuListCellHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listTableView.dequeueReusableCell(withIdentifier: "listSettingTableViewCell") as! ListSettingViewCell
        
        //cell.menuNameLabel.text = String(intToChar(value: indexPath.row, signAdd: "A"))
        cell.menuNameLabel.text = String(indexPath.row + 1)
        
        cell.menuNameTextView.tag = indexPath.row
        cell.menuNameTextView.text = globalMenuList[indexPath.row].name
        cell.menuNameTextView.delegate = self
        
        cell.menuPriceText.tag = indexPath.row
        cell.menuPriceText.text = globalMenuList[indexPath.row].price
        cell.menuPriceText.layer.borderWidth = 1
        cell.menuPriceText.delegate = self
        cell.menuPriceText.addTarget(self, action: #selector(self.priceEditingChanged), for: UIControlEvents.editingChanged)
        
        cell.menuNicknameText.tag = indexPath.row
        cell.menuNicknameText.text = globalMenuList[indexPath.row].nickname
        cell.menuNicknameText.delegate = self
        cell.menuNicknameText.layer.borderWidth = 1
        cell.menuNicknameText.addTarget(self, action: #selector(self.priceEditingChanged), for: UIControlEvents.editingChanged)
        
        let color = globalMyColor[globalGroupList[globalMenuList[indexPath.row].groupNumber].colorNumber]
        cell.backgroundColor = color
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tempArr:[ListDataForm] = []
        
        if(sourceIndexPath.row > destinationIndexPath.row)
        { // 排在後的往前移動
            for (index, value) in globalMenuList.enumerated() {
                if index < destinationIndexPath.row
                    || index > sourceIndexPath.row {
                    tempArr.append(value)
                } else if
                    index == destinationIndexPath.row {
                    tempArr.append(globalMenuList[sourceIndexPath.row])
                } else if index <= sourceIndexPath.row {
                    tempArr.append(globalMenuList[index - 1])
                }
            }
        } else if (sourceIndexPath.row <
            destinationIndexPath.row) {
            // 排在前的往後移動
            for (index, value) in globalMenuList.enumerated() {
                if index < sourceIndexPath.row
                    || index > destinationIndexPath.row {
                    tempArr.append(value)
                } else if
                    index < destinationIndexPath.row {
                    tempArr.append(globalMenuList[index + 1])
                } else if
                    index == destinationIndexPath.row {
                    tempArr.append(globalMenuList[sourceIndexPath.row])
                }
            }
        } else {
            tempArr = globalMenuList
        }
        
        globalMenuList = tempArr
        self.menuReload()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            globalMenuList.remove(at: indexPath.row)
            
            self.menuReload()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//
//  SettingsWithTextViewController.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/11.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsWithTextViewDelegate {
    func getFileData()->String
}

class SettingsWithTextViewController: UIViewController {
    
    
    @IBOutlet weak var settingsTextView: UITextView!
    
    var delegate: SettingsWithTextViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.settingsTextView.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.settingsTextView.text = delegate?.getFileData()
    }
    
    //MARK: - IBAction
    
    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        //FileRW.fileSaveSeatList()
        let fileStringCompoents = self.settingsTextView.text.components(separatedBy: fileSettingProperty.settingsVersion.rawValue)
        
//        var catchSample = self.settingsTextView.text!.replacingOccurrences(of: "\n", with: "\\n")
//        catchSample = catchSample.replacingOccurrences(of: "\\*", with: "\\\\*")
//        print(catchSample)
        
        for fileString in fileStringCompoents {
            var temp = fileSettingProperty.settingsVersion.rawValue + fileString
            let stringArr = temp.components(separatedBy: fileSettingProperty.componentsSign.rawValue)
            
            if stringArr.count > 2 {
                FileRW.fileStringLoad(loadString: &temp)
                FileRW.rwString = temp
                FileRW.fileSave()
            }
        }
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

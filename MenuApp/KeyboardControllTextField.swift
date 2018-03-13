//
//  KeyboardControllTextField.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/13.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class KeyboardControllTextField: UITextField {
    var softkeyboardHiddenControll = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(self.KeyboardControllTextFieldEditingDidEndOnExit(sender:)), for: .editingDidEndOnExit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        self.addTarget(self, action: #selector(self.KeyboardControllTextFieldEditingDidEndOnExit(sender:)), for: .editingDidEndOnExit)
    }
    
    @objc func KeyboardControllTextFieldEditingDidEndOnExit(sender: Any)->Void {
        self.endEditing(true)
    }
}

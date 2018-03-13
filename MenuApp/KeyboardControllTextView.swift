//
//  KeyboardControllTextView.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/13.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class KeyboardControllTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

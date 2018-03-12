//
//  GetDateString.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/6.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class GetDateString: NSObject {
    
    class func nowDate()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let nowDate = NSDate() as Date
        
        return formatter.string(from: nowDate)
    }
    
    class func nowTime()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let nowDate = NSDate() as Date
        
        return formatter.string(from: nowDate)
    }
}

//
//  SeatValidManage.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/9.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation


class SeatListManage: NSObject {
    
    class func findNextUseable(startIndex: Int, toFront: Bool)->Int {
        var i = startIndex
        
        if toFront {
            while i < globalSeatList.useable.count {
                if globalSeatList.useable[i] {
                    break
                }
                i = i + 1
            }
            if i >= globalSeatList.useable.count {
                i = 1
                while i < startIndex {
                    if globalSeatList.useable[i] {
                        break
                    }
                    i = i + 1
                }
                if i >= startIndex {
                    i = -1
                }
            }
        } else {
            while i >= 1 {
                if globalSeatList.useable[i] {
                    break
                }
                i = i - 1
            }
            if i < 1 {
                i = globalSeatList.useable.count - 1
                while i > startIndex {
                    if globalSeatList.useable[i] {
                        break
                    }
                    i = i - 1
                }
                if i <= startIndex {
                    i = -1
                }
            }
        }
        
        if self.isValidIndex(index: i) {
            return i
        } else {
            return -1
        }
    }
    
    class func setUseable(index: Int, useable: Bool)->Void {
        if self.isValidIndex(index: index) {
            globalSeatList.useable[index] = useable
        }
    }
    
    class func displayNumber(index: Int)->String {
        if SeatListManage.isValidIndex(index: index) {
            return String(index)
        } else {
            return "N/A"
        }
    }
    
    class func isValidIndex(index: Int)->Bool {
        if index < 1 || index >= globalSeatList.useable.count {
            return false
        } else {
            return true
        }
    }
}

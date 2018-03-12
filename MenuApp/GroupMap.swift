//
//  GroupMap.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/7.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

class GroupMap: NSObject {
    var mapResolution: Int!
    var listLimit: Int!
    
    var gMap: [[Int]]!
    var gList: [[CGPoint]]!
    
    init(resolution: Int, limit: Int) {
        super.init()
        
        mapResolution = resolution
        listLimit = limit
        
        gMap = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: mapResolution),count: mapResolution)
        gList = Array<[CGPoint]>(repeating: [], count: limit)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(point: CGPoint, value: Int)->Void {
        let x = Int(point.x)
        let y = Int(point.y)
        
        if isValidInput(point: point, value: value) {
            
            if gMap[x][y] != value {
                if gMap[x][y] != 0 {
                    self.deleteListItem(point: point, value: gMap[x][y])
                }
                gMap[x][y] = value
                gList[value].append(point)
            }
            
        }
    }
    
    func delete(point: CGPoint)->Void {
        let x = Int(point.x)
        let y = Int(point.y)
        
        if isValidInput(point: point, value: listLimit - 1) {
            
            let value = gMap[x][y]
            if value > 0 {
                self.deleteListItem(point: point, value: value)
            }
            gMap[x][y] = 0
            
        }
    }
    
    func deleteListItem(point: CGPoint, value: Int)->Void {
        for i in 0..<gList[value].count {
            if gList[value][i] == point {
                gList[value].remove(at: i)
                break
            }
        }
    }
    
    func isValidInput(point: CGPoint, value: Int)->Bool {
        if ( point.x < 0 || point.x >= CGFloat(mapResolution) || point.y < 0 || point.y >= CGFloat(mapResolution) ) {
            return false
        }
        
        if (value < 0 || value >= listLimit) {
            return false
        }
        
        return true
    }
}

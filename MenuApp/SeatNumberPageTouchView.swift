//
//  SeatNumberPageTouchView.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/11.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

protocol SeatNumberPageTouchViewDelegate {
    func touchViewTouchEnd(point: CGPoint?)->Void
}

class SeatNumberPageTouchView : UIView {
    var delegate: SeatNumberPageTouchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchViewTouchEnd(point: touches.first?.location(in: self))
    }
}


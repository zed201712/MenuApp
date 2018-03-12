//
//  DrawView.swift
//  MenuApp
//
//  Created by 游聖傑 on 2018/3/7.
//  Copyright © 2018年 Zed. All rights reserved.
//

import Foundation
import UIKit

protocol DrawViewDelegate {
    func drawViewTouch(point: CGPoint?)->Void
    func drawViewTouchEnd(point: CGPoint?)->Void
}

class DrawView : UIView {
    var color = UIColor.black
    var path = UIBezierPath()
    var delegate: DrawViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.drawViewTouch(point: touches.first?.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.drawViewTouch(point: touches.first?.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.drawViewTouchEnd(point: touches.first?.location(in: self))
    }
    
    func drawLine(startPoint: CGPoint, endPoint: CGPoint, width: CGFloat, color: UIColor) {
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func drawRect(rect: CGRect, color: UIColor) {
        path = UIBezierPath(rect: rect)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = color.cgColor
        shapeLayer.lineWidth = 0
        
        
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func clearAll() {
        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }
}

//
//  Rectangle.swift
//  rxs
//
//  Created by Francis on 2018/6/7.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore

public class Rectangle:Shape,Hostable{
    public func applyResult(rect: CGRect) {
        self.rect = rect
    }
    
    public func calcSize(size: CGSize) -> CGSize {
        return size;
    }
    public convenience init(size:CGSize,radius:CGFloat = 0) {
        self.init(rect: CGRect(origin: .zero, size: size), radius: radius)
    }
    public required init(rect:CGRect,radius:CGFloat = 0) {
//        self.rect = rect
        self.flex = FlexBox(width: rect.width, height: rect.height)
        self.radius = radius
        self.rect = rect
        super.init(path: CGPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height), cornerWidth: radius, cornerHeight: radius, transform: nil))
        self.flex.host = self
    }
    override public var originPath: CGPath{
        if radius > 0 && radius <= min(self.rect.width, self.rect.height) / 2{
            return CGPath(roundedRect: CGRect(x: 0, y: 0, width: self.rect.width, height: self.rect.height), cornerWidth: self.radius, cornerHeight: self.radius, transform: nil)
        }else{
            return CGPath(rect: CGRect(x: 0, y: 0, width: self.rect.width, height: self.rect.height), transform: nil)
        }
        
    }
    
    @available(*,unavailable)
    public override init(path: CGPath) {
        fatalError()
    }
    
    //MARK:- store
    public var rect:CGRect
    
    public var flex:FlexBox<Rectangle>
    public var radius:CGFloat
    
    public override var translate: CGPoint{
        get{
            return self.rect.origin
        }
        set{
            self.flex.resultX = newValue.x
            self.flex.resultY = newValue.y
        }
    }
    public func addRect(view: Rectangle) {
        self.addSubView(view: view)
        self.flex.addSubBox(box: view.flex)
    }
}

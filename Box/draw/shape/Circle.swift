//
//  File.swift
//  rxs
//
//  Created by Francis on 2018/6/11.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore


/// 圆形
/// 子图形 圆心为坐标中点
public class Circle:Shape{
    //MARK:- store
    public var center:CGPoint
    public var radius:CGFloat
    public var start:CGFloat
    public var radian:CGFloat
    public var clockwise:Bool
    public var useOriginBound:Bool = false
    public var drawRadius:Bool = false
    //MARK:- init
    public init(center:CGPoint,radius:CGFloat,start:CGFloat = 0,radian:CGFloat = .pi * 2,clockwise:Bool = false) {
        self.center = center
        self.radius = radius
        self.start = start
        self.radian = radian
        self.clockwise = clockwise
        super.init(path: CGMutablePath())
    }
    
    
    //MARK:- override
    override public var originPath: CGPath{
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero, radius: self.radius, startAngle: self.start, endAngle: self.radian, clockwise: clockwise)
        if (drawRadius){
            path.addLine(to: .zero)
            path.closeSubpath()
        }
        return path
    }
    
    public override var originRect: CGRect{
        if useOriginBound{
            return self.originPath.boundingBoxOfPath
        }else{
            return CGRect(x: -self.radius, y: -self.radius, width: self.radius * 2, height: self.radius * 2)
        }
        
    }
    public override var translate: CGPoint{
        get{
            return self.center
        }
        set{
            self.center = newValue
        }
    }
    
    //MARK:- unavailable
    @available(*,unavailable)
    public override var anchorPoint: CGPoint{
        get{return super.anchorPoint}set{fatalError("cannot usage")}
    }
    @available(*,unavailable)
    public required init(rect:CGRect) {
        fatalError("cannot usage")
    }
    @available(*,unavailable)
    public override init(path: CGPath) {
        fatalError("cannot usage")
    }
    //MARK:- static
    static public func createCircleNormal(ellipseIn: CGRect, transform: UnsafePointer<CGAffineTransform>?)->CGPath{
        return CGPath(ellipseIn: CGRect(x: ellipseIn.width / -2, y: ellipseIn.height / -2, width: ellipseIn.width, height: ellipseIn.height), transform: transform)
    }
    static public func createRectNormal(rect: CGRect, transform: UnsafePointer<CGAffineTransform>?)->CGPath{
        return CGPath(rect: CGRect(x: rect.width / -2, y: rect.height / -2, width: rect.width, height: rect.height), transform: transform)
    }
    static public func createrRoundedRectNormal(roundedRect: CGRect, cornerWidth: CGFloat, cornerHeight: CGFloat, transform: UnsafePointer<CGAffineTransform>?)->CGPath{
        return CGPath(roundedRect: roundedRect, cornerWidth: cornerWidth, cornerHeight: cornerHeight, transform: transform)
    }
}

public class Ellipse:Shape{
    public required init(rect:CGRect) {
        self.rect = rect
        super.init(path: CGPath(ellipseIn: rect, transform: nil))
    }
    override public var originPath: CGPath{
        return CGPath(ellipseIn: CGRect(x: 0, y: 0, width: self.rect.width, height: self.rect.height), transform: nil)
    }
    
    @available(*,unavailable)
    public override init(path: CGPath) {
        fatalError()
    }
    
    //MARK:- store
    public var rect:CGRect
    public override var translate: CGPoint{
        get{
            return self.rect.origin
        }
        set{
            self.rect.origin = newValue
        }
    }
}




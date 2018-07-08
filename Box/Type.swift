//
//  Type.swift
//  Box
//
//  Created by hao yin on 2018/7/6.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import QuartzCore

public protocol Rect{
    var width:CGFloat? {get set}
    var height:CGFloat? {get set}
    func layout()
    func storeRect(result:CGRect)
    var needFitSize:Bool {get}
    func fixSize()
}

public protocol UIExtension:class{
    associatedtype T:UIView
    var host:T? {get set}
}
public struct Relative{
    public var left:CGFloat?
    public var top:CGFloat?
    
    public var right:CGFloat?
    public var bottom:CGFloat?
    
    static public var none:Relative{
        return Relative(left: nil, top: nil, right: nil, bottom: nil)
    }
    static public func leftTop(left: CGFloat?, top: CGFloat?)->Relative{
        return Relative(left: left, top: top, right: nil, bottom: nil)
    }
    static public func bottonRight(bottom: CGFloat?, right: CGFloat?)->Relative{
        return Relative(left: nil, top: nil, right: right, bottom: bottom)
    }
}

public protocol LayoutBox:class{
    var resultX:CGFloat {get set}
    var resultY:CGFloat {get set}
    var resultW:CGFloat {get set}
    var resultH:CGFloat {get set}
    var resultRect:CGRect {get}
    var relativePostion:Relative {get}
}

public protocol Container{
    var subBoxs:[Box] {get}
    func addSubBox(box:Box)
}

extension LayoutBox{
    public var resultRect:CGRect{
        var xValue:CGFloat? = 0
        var yValue:CGFloat? = 0
        if let l = self.relativePostion.left{
            xValue = l
        }
    
        if let t = self.relativePostion.top{
            yValue = t
        }
        
        if let r = self.relativePostion.right,xValue == nil{
            xValue = -r
        }
        if let b = self.relativePostion.bottom ,yValue == nil{
            yValue = -b
        }
        return CGRect(x: resultX + (xValue ?? 0), y: resultY + (yValue ?? 0), width: resultW, height: resultH)
    }
}

public typealias FlexSubBox = FlexItem & LayoutBox & Rect

public typealias BlockSubBox = BlockItem & LayoutBox & Rect

public typealias Box = FlexSubBox & BlockSubBox

//
//  BlockBox.swift
//  Box
//
//  Created by hao yin on 2018/7/6.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import QuartzCore

public struct Margin {
    public var left:CGFloat
    public var right:CGFloat
    public var top:CGFloat
    public var bottom:CGFloat
    static public func value(v:CGFloat)->Margin{
        return Margin(left:v, right: v, top: v, bottom: v)
    }
    static public func Axis(h:CGFloat,v:CGFloat)->Margin{
        return Margin(left:h, right: h, top: v, bottom: v)
    }
    static public func full(left:CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat)->Margin{
        return Margin(left: left, right: right, top: top, bottom: bottom)
    }
}

public protocol BlockItem {
    var margin:Margin { get }
    var padding:Margin { get }
}

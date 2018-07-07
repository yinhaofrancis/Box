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

public enum BlockDisplay{
    case inlineBlock
    case block
}

public protocol BlockItem {
    var margin:Margin { get }
    var padding:Margin { get }
    var display:BlockDisplay { get }
}
public class BlockBox:Box{
    
    weak public var host: UIView?
    
    public var resultX: CGFloat
    
    public var resultY: CGFloat
    
    public var resultW: CGFloat
    
    public var resultH: CGFloat
    
    public var grow: Int = 0
    
    public var shrink: Int = 0
    
    public var alignSelf: Align?
    
    public var margin: Margin = .value(v: 0)
    
    public var padding: Margin = .value(v: 0)
    
    public var display: BlockDisplay = .block
    
    public var width: CGFloat?
    
    public var height: CGFloat?
    
    public init(width:CGFloat?,height:CGFloat?){
        resultX = 0
        resultY = 0
        self.width = width ?? 0
        self.height = height ?? 0
        resultW = width ?? 0
        resultH = height ?? 0
    }
    public func layout() {
        
    }
}

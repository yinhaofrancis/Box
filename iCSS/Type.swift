//
//  Type.swift
//  iCSS
//
//  Created by hao yin on 2018/7/3.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import Foundation

public protocol LayoutFrame:class{
    var resultX:CGFloat {get set}
    var resultY:CGFloat  {get set}
    var resultWidth:CGFloat {get set}
    var resultHeight:CGFloat {get set}
}

public enum Dimension{
    case percent(CGFloat)
    case accuracy(CGFloat)
    public func calc(relate:CGFloat)->CGFloat{
        switch self {
        case let .percent(l):
            return relate * l;
        case let .accuracy(l):
            return l
        }
    }
    
}

public protocol Rect{
    var width:Dimension {get}
    var height:Dimension {get}
}
public enum FlexDirection{
    case horizental
    case vertical
}
public protocol FlexItemSupport{
    var grow:Int {get}
    var shrink:Int {get}
    var alignSelf:Align? {get}
}
public protocol layoutTool:Rect{
    var host:LayoutFrame? {get set}
    func layout()
    func addSubTool(tool:ItemProperty)
    init(size:CGSize)
    func setHost(host:LayoutFrame)
    var superBox:layoutTool? {get set}
    var realW:CGFloat{get}
    var realH:CGFloat{get}
    var subBoxes:[layoutTool & ItemProperty] {get set}
    func assigeSuper(sup:ItemProperty)
}
public typealias ItemProperty = FlexItemSupport & Rect & layoutTool & LayoutFrame

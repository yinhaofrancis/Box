//
//  Type.swift
//  Box
//
//  Created by hao yin on 2018/7/6.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import QuartzCore

public protocol Rect{
    var width:CGFloat {get set}
    var height:CGFloat {get set}
}

public protocol LayoutBox:class{
    var resultX:CGFloat {get set}
    var resultY:CGFloat {get set}
    var resultW:CGFloat {get set}
    var resultH:CGFloat {get set}
    var resultRect:CGRect {get}
}

extension LayoutBox{
    public var resultRect:CGRect{
        return CGRect(x: resultX, y: resultY, width: resultW, height: resultH)
    }
}

public typealias Box = FlexItem & LayoutBox & Rect & BlockItem

public typealias FlexSubBox = FlexItem & LayoutBox & Rect

public typealias BlockSubBox = BlockItem & LayoutBox & Rect

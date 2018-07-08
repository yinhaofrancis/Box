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

public protocol LayoutBox:class{
    var resultX:CGFloat {get set}
    var resultY:CGFloat {get set}
    var resultW:CGFloat {get set}
    var resultH:CGFloat {get set}
    var resultRect:CGRect {get}
}

public protocol Container{
    var subBoxs:[Box] {get}
    func addSubBox(box:Box)
}

extension LayoutBox{
    public var resultRect:CGRect{
        return CGRect(x: resultX, y: resultY, width: resultW, height: resultH)
    }
}

public typealias FlexSubBox = FlexItem & LayoutBox & Rect

public typealias BlockSubBox = BlockItem & LayoutBox & Rect

public typealias Box = FlexSubBox & BlockSubBox

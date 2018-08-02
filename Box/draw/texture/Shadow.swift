//
//  Shadow.swift
//  rxs
//
//  Created by Francis on 2018/6/7.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore
/// 阴影
public struct Shadow{
    public var radius:CGFloat
    public var offset:CGSize
    public var color:CGColor?
    /// 构造
    ///
    /// - Parameters:
    ///   - radius: 阴影半径
    ///   - offset: 阴影偏移
    ///   - color: 阴影颜色
    public init (radius:CGFloat,offset:CGSize,color:CGColor? = CGColor.black.copy(alpha: 0.7)){
        self.radius = radius
        self.offset = offset
        self.color = color
    }
    static public var `default`:Shadow{
        return Shadow(radius: 2, offset: .init(width: 1, height: 1))
    }
    static public var none:Shadow{
        return Shadow(radius: 0, offset: .zero,color:nil)
    }
    public func setScale(scale:CGFloat)->Shadow{
        return Shadow(radius: self.radius * scale, offset: CGSize(width: self.offset.width * scale, height: self.offset.height * scale), color: self.color)
    }
}

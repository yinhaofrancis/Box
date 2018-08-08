//
//  PlaygroundSupport.swift
//  rxs
//
//  Created by hao yin on 2018/6/8.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore

func drawTextureToImage(texture:Textureable)->CGImage?{
    let canvas = try! Canvas(size: CGSize(width: 30, height: 30))
    let rect = Rectangle(rect: CGRect(x: 0, y: 0, width: 30, height: 30))
    rect.texture = Texture(content: [texture])
    return canvas.draw(drawable: rect)
}
extension Gradient:CustomPlaygroundDisplayConvertible{
    public var playgroundDescription: Any{
        return drawTextureToImage(texture: self) ?? "nil"
    }
}

extension Image:CustomPlaygroundDisplayConvertible{
    public var playgroundDescription: Any{
        return self.cgImage
    }
}

extension Shading:CustomPlaygroundDisplayConvertible{
    public var playgroundDescription: Any{
        return drawTextureToImage(texture: self) ?? "nil"
    }
}
extension Texture:CustomPlaygroundDisplayConvertible{
    public var playgroundDescription: Any{
        let canvas = try! Canvas(size: CGSize(width: 30, height: 30))
        let rect = Rectangle(rect: CGRect(x: 0, y: 0, width: 30, height: 30))
        rect.texture = self
        return canvas.draw(drawable: rect) ?? "nil"
    }
}
extension Shape:CustomPlaygroundDisplayConvertible{
    public var playgroundDescription: Any{
        let canvas = try! Canvas(size: CGSize(width: 30, height: 30))
        return canvas.draw(drawable: self) ?? "nil"
    }
}
extension Pattern:CustomPlaygroundDisplayConvertible{
    public var playgroundDescription: Any{
        return drawTextureToImage(texture: self) ?? "nil"
    }
}

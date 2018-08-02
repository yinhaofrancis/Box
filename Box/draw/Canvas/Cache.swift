//
//  Cache.swift
//  rxs
//
//  Created by Francis on 2018/6/14.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore
import ImageIO

public class Cache:Context,Textureable{
    public func drawTexture(canvas: Context, shape: Shape, texture: Texture) {
        canvas.context.saveGState()
        canvas.context.beginTransparencyLayer(auxiliaryInfo: nil)
        canvas.context.concatenate(shape.transform)
        self.clipPath(canvas: canvas, shape: shape, texture: texture, useOrigin: true)
        canvas.context.addPath(shape.originPath)
        canvas.context.clip()
        if let layer = self.layer{
            canvas.context.draw(layer, in: shape.originRect)
        }
        canvas.context.endTransparencyLayer()
        canvas.context.restoreGState()
    }
    
    let canvas:Canvas
    let layer:CGLayer?
    public init(canvas:Canvas) {
        self.canvas = canvas
        layer = CGLayer(canvas.context, size: canvas.size, auxiliaryInfo: nil)
    }
    
    public var context: CGContext{
        return layer!.context!
    }
    
    public var size: CGSize{
        return canvas.size
    }
    
    public var scale: CGFloat{
        return canvas.scale
    }
    
    public var colorSpace: CGColorSpace{
        return canvas.colorSpace
    }
    private func clear(){

        self.context.clear(CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        self.context.saveGState()
        self.context.setFillColor(self.canvas.clearColor ?? CGColor.clear)
        self.context.fill(CGRect(origin: .zero, size: self.size))
        self.context.restoreGState()
    }
    public func drawItem(drawable: Drawable) {
        self.context.saveGState()
        self.clear()
        self.context.beginTransparencyLayer(auxiliaryInfo: nil)
        self.context.scaleBy(x: self.scale, y: self.scale)
        drawable.render(canvas: self)
        self.context.endTransparencyLayer()
        self.context.restoreGState()
    }
    
    
}

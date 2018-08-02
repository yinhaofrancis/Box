//
//  Image.swift
//  rxs
//
//  Created by Francis on 2018/6/6.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore


public protocol Textureable{
    func drawTexture(canvas:Context,shape:Shape,texture:Texture)
}
extension Textureable{
    public func clipPath(canvas:Context,shape:Shape,texture:Texture,useOrigin:Bool){
        if useOrigin, let clip = shape.originClipPath{
            canvas.context.addPath(clip)
            canvas.context.clip()
        }else{
            if let p = shape.pathForClip{
                canvas.context.addPath(p)
                canvas.context.clip()
            }
        }
        
    }
}

extension CGColor:Textureable {
    public func drawTexture(canvas: Context,shape:Shape, texture: Texture) {
        switch shape.drawMode {
        case .fill:
            canvas.context.setFillColor(self)
        case .eoFill:
            canvas.context.setFillColor(self)
        case .stroke:
            canvas.context.setStrokeColor(self)
        case .fillStroke:
            canvas.context.setStrokeColor(self)
            canvas.context.setFillColor(self)
        case .eoFillStroke:
            canvas.context.setStrokeColor(self)
            canvas.context.setFillColor(self)
        }
        canvas.context.setFillColor(self)
        if let p = shape.path{
            self.clipPath(canvas: canvas, shape: shape, texture: texture, useOrigin: false)
            canvas.context.addPath(p)
            canvas.context.drawPath(using: shape.drawMode)
        }
    }
}
public class Texture {
    var content:[Textureable]
    public var shadow:Shadow?
    init(content:[Textureable],shadow:Shadow? = nil){
        self.content = content
        self.shadow = shadow
    }
    public init(color:CGColor){
        self.content = [color]
        self.shadow = nil
    }
    public init(image:CGImage,mode:Image.imageDrawMode){
        self.content = [Image(cgImage: image, drawMode: mode)]
        self.shadow = nil
    }
    public init(gradient:Gradient){
        self.content = [gradient]
        self.shadow = nil
    }
    public init(string:NSAttributedString){
        self.content = [string]
        self.shadow = nil
    }
    public init(shading:Shading){
        self.content = [shading]
        self.shadow = nil
    }
    public init(pattern:Pattern){
        self.content = [pattern]
        self.shadow = nil
    }
    public init(cache:Cache){
        self.content = [cache]
        self.shadow = nil
    }
}

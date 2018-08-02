//
//  Pattern.swift
//  rxs
//
//  Created by Francis on 2018/6/11.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore

public class Pattern:Textureable{
    
    public struct PatternConfig{
        public typealias Call = (PatternConfig,CGContext)->Void
        public var bounds:CGRect
        public var transform:CGAffineTransform
        public var xStep:CGFloat
        public var yStep:CGFloat
        public var tiling:CGPatternTiling
        public var iscolored:Bool
        public var draw:Call?
        public init(bounds:CGRect,transform:CGAffineTransform,xStep:CGFloat,yStep:CGFloat, tiling:CGPatternTiling,iscolored:Bool,draw:Call?) {
            self.bounds = bounds
            self.transform = transform
            self.xStep = xStep
            self.yStep = yStep
            self.tiling = tiling
            self.iscolored = iscolored
            self.draw = draw
        }
        public init(bounds:CGRect,xStep:CGFloat,yStep:CGFloat,draw:Call?){
            self.init(bounds: bounds, transform: .identity, xStep: xStep, yStep: yStep, tiling: .constantSpacing, iscolored: false, draw: draw)
        }
        
    }
    private var patternConfig:PatternConfig
    private var pattern:CGPattern
    
    public var fillColorComponent:[CGFloat] = []
    public var strokeColorComponent:[CGFloat] = []
    
    
    
    public convenience init(draw:@escaping PatternConfig.Call,rect:CGRect,line:Int = #line,file:String = #file) throws{
        do{
            try self.init(config: PatternConfig(bounds: rect, xStep: rect.width, yStep: rect.height, draw: draw))
        }catch let error as DrawError{
            var err = error
            err.line = line
            err.filename = file
            throw err
        }
    }
    public required init(config:PatternConfig,line:Int = #line,file:String = #file) throws{
        self.patternConfig = config
        var callback = CGPatternCallbacks(version: 1, drawPattern: { (info, ctx) in
            if let this = info?.assumingMemoryBound(to: PatternConfig.self).pointee{
                if let drawCall = this.draw{
                    drawCall(this,ctx)
                }
            }
        }) { (_) in
            
        }
        if let p = CGPattern(info: &self.patternConfig, bounds: config.bounds, matrix: config.transform, xStep: config.xStep, yStep: config.yStep, tiling: config.tiling, isColored: config.iscolored, callbacks: &callback){
            self.pattern = p
        }else{
            throw DrawError.createCGPatternFail(line,file)
        }
        
    }
    public func drawTexture(canvas: Context, shape: Shape, texture: Texture) {
        canvas.context.saveGState()
        canvas.context.beginTransparencyLayer(auxiliaryInfo: nil)
        canvas.context.concatenate(shape.transform)
        self.clipPath(canvas: canvas, shape: shape, texture: texture, useOrigin: true)
        canvas.context.addPath(shape.originPath)
        
        if let sp = CGColorSpace(patternBaseSpace: self.patternConfig.iscolored ? nil : canvas.colorSpace){
            canvas.context.setFillColorSpace(sp)
        }
        canvas.context.setFillPattern(self.pattern, colorComponents: self.fillColorComponent)
        if let sp = CGColorSpace(patternBaseSpace: self.patternConfig.iscolored ? nil : canvas.colorSpace){
            canvas.context.setStrokeColorSpace(sp)
        }
        canvas.context.setStrokePattern(self.pattern, colorComponents: self.strokeColorComponent)
        canvas.context.drawPath(using: shape.drawMode)
        canvas.context.endTransparencyLayer()
        canvas.context.restoreGState()
    }
}

//
//  Gradient.swift
//  rxs
//
//  Created by Francis on 2018/6/7.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore

public struct Gradient:Textureable{
    /// 过渡绘制方式
    ///
    /// - linear: 线型绘制 参数取值 [0,1]
    /// - circle: 圆形绘制 参数取值 [0,1] 半径 [0,infinity]
    public enum GradientDrawMode{
        case linear(start:CGPoint,end:CGPoint)
        case circle(startCenter:CGPoint,startRadius:CGFloat,endCenter:CGPoint,endRadius:CGFloat)
    }
    /// 过渡内置
    private var gradient:CGGradient
    /// 绘制方式
    public var drawMode:GradientDrawMode
    /// 内置绘制选项
    public var drawOption:CGGradientDrawingOptions = .init(rawValue: 0)

    public func drawTexture(canvas: Context, shape: Shape, texture: Texture) {
        canvas.context.saveGState()
        canvas.context.beginTransparencyLayer(auxiliaryInfo: nil)
        canvas.context.concatenate(shape.transform)
        self.clipPath(canvas: canvas, shape: shape, texture: texture, useOrigin: true)
        canvas.context.addPath(shape.originPath)
        canvas.context.clip()
        
        let originFrame = shape.originRect
        switch self.drawMode {
        case let .linear(s,e):
            let start = CGPoint(x: originFrame.minX + s.x * originFrame.width, y: originFrame.minY + s.y * originFrame.height)
            let end = CGPoint(x: originFrame.minX + e.x * originFrame.width, y: originFrame.minY + e.y * originFrame.height)
            canvas.context.drawLinearGradient(self.gradient, start: start, end: end, options: self.drawOption)
            break
        case let .circle(sc,s,ec,e):
            let sce = CGPoint(x: originFrame.minX + sc.x * originFrame.width, y: originFrame.minY + sc.y * originFrame.height)
            let ece = CGPoint(x: originFrame.minX + ec.x * originFrame.width, y: originFrame.minY + ec.y * originFrame.height)
            canvas.context.drawRadialGradient(self.gradient, startCenter: sce, startRadius: s, endCenter: ece, endRadius: e, options: self.drawOption)
            break
        }
        canvas.context.endTransparencyLayer()
        canvas.context.restoreGState()
    }
    
    /// 构造
    ///
    /// - Parameters:
    ///   - gradient: 过渡效果
    ///   - drawMode: 绘制模式
    ///   - drawOption: 边界绘制
    public init(gradient:CGGradient, drawMode:GradientDrawMode,drawOption:CGGradientDrawingOptions) {
        self.gradient = gradient
        self.drawMode = drawMode
        self.drawOption = drawOption
        
    }
    /// 过渡绘制方式
    ///
    /// - Parameters:
    ///   - colorComponents: 颜色组成
    ///   - locations: 颜色的位置
    ///   - drawMode: 绘制方式
    ///   - drawOption: 边界绘制方式
    ///   - colorSpace: 颜色空间
    ///   - line: 异常的行号
    ///   - file: 异常文件
    /// - Throws: 异常
    public init(colorComponents: [CGFloat],
                locations: [CGFloat],
                drawMode:GradientDrawMode,
                drawOption:CGGradientDrawingOptions = CGGradientDrawingOptions.init(rawValue: 0),
                colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB(),
                line:Int = #line,file:String = #file) throws{
        self.drawOption = drawOption
        self.drawMode = drawMode
        if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: locations.count){
            self.gradient = gradient
        }else{
            throw DrawError.createCGGradientFail(line,file)
        }
        
    }
    
}

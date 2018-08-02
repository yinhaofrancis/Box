//
//  Shader.swift
//  rxs
//
//  Created by Francis on 2018/6/7.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore

/// 绘制函数配置
public struct ShadingFunctionConfig{
    public typealias DrawCall = ([CGFloat])->CGColor
    /// 输入参数个数
    public var domainDimension: Int
    /// 输入参数的取值范围
    /// eg. domainDimension = 1 domain = [0,1] 取值 0 ~ 1
    public var domain: [CGFloat]
    /// 颜色空间
    public var colorSpace:CGColorSpace
    /// 结果剪裁空间
    /// eg. colorSpace 是RGB 三个色域 [0,1,0,1,0,1]
    ///                               r   g   b
    /// eg.  useAlpha = yes colorSpace = RGB range = [0,1,0,1,0,1,0,1]
    ///                                                r   g   b   a
    public var range: [CGFloat]
    /// 是否使用Alpha值
    public var useAlpha:Bool
    
    public var draw:DrawCall?
    
    public static var `default`:ShadingFunctionConfig{
        return ShadingFunctionConfig(domainDimension: 1, domain: [0,1], colorSpace: CGColorSpaceCreateDeviceRGB(), range: [0,1,0,1,0,1,0,1], useAlpha: false)
    }
    
    init(domainDimension: Int, domain: [CGFloat], colorSpace: CGColorSpace, range: [CGFloat], useAlpha: Bool) {
        self.domainDimension = domainDimension
        self.domain = domain
        self.colorSpace = colorSpace
        self.range = range
        self.useAlpha = useAlpha
    }
    /// 完整的Range
    public var rightRange:[CGFloat]{
        let allc = (self.colorSpace.numberOfComponents + (useAlpha ? 1 : 0)) * 2
        var result = self.range
        if (allc - range.count > 0){
            let suffix = (0..<(allc - range.count)).map{_ in CGFloat(0)}
            result.append(contentsOf: suffix)
        }
        return result
    }
}

public class Shading: Textureable {
    /// 内置着色
    var shading:CGShading

    /// 回调
    var callback:CGFunctionCallbacks?

    var draw:([CGFloat])->CGColor
    
    /// 配置
    private var config:ShadingFunctionConfig
    /// 线型绘制
    ///
    /// - Parameters:
    ///   - start: 开始点 (与图形的坐标系一致)
    ///   - end: 结束点 (与图形的坐标系一致)
    ///   - draw: 绘制closure
    ///   - shadingFunctionConfig: 着色配置
    ///   - extendStart: 是否拓展开始区域的绘制
    ///   - extendEnd: 是否拓展结束区域的绘制
    ///   - line: 行号
    ///   - file: 文件
    /// - Throws: 异常
    public init(start:CGPoint,
                end:CGPoint,
                draw:@escaping ([CGFloat])->CGColor,
                shadingFunctionConfig:ShadingFunctionConfig = .default,
                extendStart: Bool = false, extendEnd: Bool = false,line:Int = #line,file:String = #file) throws {
        self.config = shadingFunctionConfig
        self.draw = draw
        callback = CGFunctionCallbacks(version: 1, evaluate: { (s, inp, outp) in
            if let this = s?.assumingMemoryBound(to: ShadingFunctionConfig.self).pointee{
                
                let p = UnsafeMutablePointer<CGFloat>.allocate(capacity: this.domainDimension)
                p.assign(from: inp, count: this.domainDimension)
                let buff = UnsafeMutableBufferPointer(start: p, count: this.domainDimension)
                let array = Array<CGFloat>.init(buff)
                let color = this.draw?(array)
                p.deallocate()
                if let com = color?.components{
                    outp.assign(from: com, count: com.count)
                }
                
            }
        }, releaseInfo: { (s) in
            
        })
        self.config.draw = draw
        let fun = CGFunction(info: &self.config,
                             domainDimension: shadingFunctionConfig.domainDimension,
                             domain: shadingFunctionConfig.domain,
                             rangeDimension: shadingFunctionConfig.colorSpace.numberOfComponents + (shadingFunctionConfig.useAlpha ? 1 : 0),
                             range: shadingFunctionConfig.rightRange, callbacks: &callback!)
        
        if let f = fun{
            if let sh = CGShading(axialSpace: shadingFunctionConfig.colorSpace, start: start, end: end, function: f, extendStart: extendStart, extendEnd: extendEnd){
                self.shading = sh
            }else{
                throw DrawError.createCGFunctionFail(line,file)
            }
        }else{
            throw DrawError.createCGShadingFail(line,file)
        }
    }
    
    
    
    /// 圆形绘制
    ///
    /// - Parameters:
    ///   - start: 开始点 (与图形的坐标系一致)
    ///   - startRadius: 开始半径
    ///   - end: 结束点 (与图形的坐标系一致)
    ///   - endRadius: 结束半径
    ///   - draw: 绘制closure
    ///   - shadingFunctionConfig: 着色配置
    ///   - extendStart: 是否拓展开始区域的绘制
    ///   - extendEnd: 是否拓展结束区域的绘制
    ///   - line: 行号
    ///   - file: 文件
    /// - Throws: 异常
    public init(start:CGPoint,
                startRadius:CGFloat,
                end:CGPoint,
                endRadius:CGFloat,
                draw:@escaping ([CGFloat])->CGColor,
                shadingFunctionConfig:ShadingFunctionConfig = .default,
                extendStart: Bool = false, extendEnd: Bool = false,line:Int = #line,file:String = #file) throws{
        self.config = shadingFunctionConfig
        self.draw = draw
        callback = CGFunctionCallbacks(version: 1, evaluate: { (s, inp, outp) in
            if let this = s?.assumingMemoryBound(to: ShadingFunctionConfig.self).pointee{

                let p = UnsafeMutablePointer<CGFloat>.allocate(capacity: this.domainDimension)
                p.assign(from: inp, count: this.domainDimension)
                let buff = UnsafeMutableBufferPointer(start: p, count: this.domainDimension)
                let array = Array<CGFloat>.init(buff)
                let color = this.draw?(array)
                p.deallocate()
                if let com = color?.components{
                    outp.assign(from: com, count: com.count)
                }
                
            }
        }, releaseInfo: { (s) in
            
        })
        self.config.draw = draw
        let fun = CGFunction(info: &self.config,
                             domainDimension: shadingFunctionConfig.domainDimension,
                             domain: shadingFunctionConfig.domain,
                             rangeDimension: shadingFunctionConfig.colorSpace.numberOfComponents + (shadingFunctionConfig.useAlpha ? 1 : 0),
                             range: shadingFunctionConfig.rightRange, callbacks: &callback!)
        
        if let f = fun{
            
            
            
            if let sh = CGShading(radialSpace: shadingFunctionConfig.colorSpace,
                                  start: start,
                                  startRadius: startRadius,
                                  end: end,
                                  endRadius: endRadius,
                                  function: f,
                                  extendStart: extendStart,
                                  extendEnd: extendEnd){
                self.shading = sh
            }else{
                throw DrawError.createCGFunctionFail(line,file)
            }
        }else{
            throw DrawError.createCGShadingFail(line,file)
        }
    }
    public func drawTexture(canvas: Context, shape: Shape, texture: Texture) {
        canvas.context.saveGState()
        canvas.context.beginTransparencyLayer(auxiliaryInfo: nil)
        canvas.context.concatenate(shape.transform)
        self.clipPath(canvas: canvas, shape: shape, texture: texture, useOrigin: true)
        canvas.context.addPath(shape.originPath)
        canvas.context.clip()
        canvas.context.drawShading(self.shading)
        canvas.context.endTransparencyLayer()
        canvas.context.restoreGState()
    }
}

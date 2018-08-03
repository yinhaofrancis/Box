//
//  Image.swift
//  rxs
//
//  Created by Francis on 2018/6/7.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore
public struct Image:Textureable{    
    /// 图片绘制模式
    ///
    /// - scaleToFit: 图片全部展示缩小或者放大且不拉伸
    /// - scaleToFill: 图片填充缩小或者放大且不拉伸
    /// - fill: 填充缩小或者放大可能拉伸
    /// - tile: 不放大缩小不拉伸重复填满 offset 重复填充的位移
    public enum imageDrawMode{
        case scaleToFit
        case scaleToFill
        case fill
        case tile(offset:CGPoint)
    }
    /// 内置图片
    public var cgImage:CGImage;
    /// 绘制模式
    public var drawMode:imageDrawMode = .fill
    public func drawTexture(canvas: Context, shape: Shape, texture: Texture) {
        canvas.context.saveGState()
        canvas.context.beginTransparencyLayer(auxiliaryInfo: nil)
        canvas.context.concatenate(shape.transform)
        self.clipPath(canvas: canvas, shape: shape, texture: texture, useOrigin: true)
        canvas.context.addPath(shape.originPath)
        canvas.context.clip()
        let size = shape.originRect
        switch drawMode {
        case .fill:
            canvas.context.draw(self.cgImage, in: shape.originRect)
            break
        case let .tile(offset):
            canvas.context.draw(self.cgImage, in: CGRect(x: size.minX + offset.x, y: size.minY + offset.y, width: CGFloat(self.cgImage.width), height: CGFloat(self.cgImage.height)), byTiling: true)
            break
        case .scaleToFit:
            canvas.context.draw(self.cgImage, in: drawSizeToFitRect(contain: shape.originPath.boundingBox, imageSize: CGSize(width: self.cgImage.width, height: self.cgImage.height)))
            break
        case .scaleToFill:
            canvas.context.draw(self.cgImage, in: drawSizeToFillRect(contain: shape.originPath.boundingBox, imageSize: CGSize(width: self.cgImage.width, height: self.cgImage.height)))
            break
        }
        canvas.context.endTransparencyLayer()
        canvas.context.restoreGState()
    }
    /// 计算绘制的图片的区域scaleToFill
    ///
    /// - Parameters:
    ///   - contain: 整个区域大小
    ///   - imageSize: 图片尺寸
    /// - Returns: 区域
    private func drawSizeToFillRect(contain:CGRect,imageSize:CGSize)->CGRect{
        let rw = contain.width / imageSize.width
        let rh = contain.height / imageSize.height
        if rw > rh{
            if (rw > 1){
                //height
                return changeRect(contain: contain, imageSize: imageSize, ratio: rh)
            }else{
                //width
                return changeRect(contain: contain, imageSize: imageSize, ratio: rw)
            }
        }else{
            if(rh < 1){
                //width
                return changeRect(contain: contain, imageSize: imageSize, ratio: rw)
            }else{
                // height
                return changeRect(contain: contain, imageSize: imageSize, ratio: rh)
            }
        }
    }
    
    /// 计算绘制的图片的区域scaleToFit
    ///
    /// - Parameters:
    ///   - contain: 整个区域大小
    ///   - imageSize: 图片尺寸
    /// - Returns: 区域
    private func drawSizeToFitRect(contain:CGRect,imageSize:CGSize)->CGRect{
        let rw = contain.width / imageSize.width
        let rh = contain.height / imageSize.height
        if rw > rh{
            if (rw > 1){
                
                return changeRect(contain: contain, imageSize: imageSize, ratio: rw)
            }else{
                
                return changeRect(contain: contain, imageSize: imageSize, ratio: rh)
            }
        }else{
            if(rh < 1){
                
                return changeRect(contain: contain, imageSize: imageSize, ratio: rh)
            }else{
                
                return changeRect(contain: contain, imageSize: imageSize, ratio: rw)
            }
        }
    }
    /// 执行区域拉伸
    ///
    /// - Parameters:
    ///   - contain: 整个区域大小
    ///   - imageSize: 图片尺寸
    ///   - ratio: 比例
    /// - Returns: 结果区域
    private func changeRect(contain:CGRect,imageSize:CGSize,ratio:CGFloat)->CGRect{
        let target = imageSize.applying(CGAffineTransform(scaleX: ratio, y: ratio))
        return CGRect(x: (contain.width - target.width) / 2 + contain.minX, y: (contain.height - target.height) / 2 + contain.minY, width: target.width, height: target.height)
    }
    
    
}

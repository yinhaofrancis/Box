//
//  View.swift
//  rxs
//
//  Created by Francis on 2018/6/5.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore

public protocol Drawable:class {
    func render(canvas:Context)
    var superView:Drawable? {get}
    var subViews:[Drawable] {get}
    var transform:CGAffineTransform {get}
    var selfTransform:CGAffineTransform {get}
}

public class Shape:Drawable{
    
    public var selfTransform: CGAffineTransform{
        return CGAffineTransform(translationX:anchorPoint.x , y: anchorPoint.y).translatedBy(x: translate.x, y: translate.y).rotated(by: self.rotate).scaledBy(x: self.scale.x, y: self.scale.y).translatedBy(x: -self.anchorPoint.x, y: -self.anchorPoint.y)
    }
    public var outTransform:CGAffineTransform{
        if let p = self.path{
            return CGAffineTransform(translationX:p.boundingBoxOfPath.minX + p.boundingBoxOfPath.width / 2 , y: p.boundingBoxOfPath.minY + p.boundingBoxOfPath.height / 2).rotated(by: self.rotate).scaledBy(x: self.scale.x, y: self.scale.y)
        }
        return CGAffineTransform.identity
    }
    public func render(canvas: Context) {
        canvas.context.saveGState()
        canvas.context.beginTransparencyLayer(auxiliaryInfo: nil)
        self.doClip(canvas: canvas)
        canvas.context.setLineWidth(self.lineWidth)
        if let texture = self.texture{
            if let sha = texture.shadow?.setScale(scale: canvas.scale){
               canvas.context.setShadow(offset: sha.offset, blur: sha.radius, color: sha.color)
            }
            for t in texture.content{
                t.drawTexture(canvas: canvas, shape: self,texture: texture)
            }
        }
        canvas.context.beginTransparencyLayer(auxiliaryInfo: nil)
        for sub in self.subViews {
            sub.render(canvas: canvas)
        }
        canvas.context.endTransparencyLayer()
        canvas.context.endTransparencyLayer()
        canvas.context.restoreGState()
    }
    public var transform:CGAffineTransform  {
        if let su = superView{
            return self.selfTransform.concatenating(su.transform)
        }else{
            return self.selfTransform
        }
    }
    public var originPath:CGPath{
        return innerPath
    }
    public var originRect:CGRect{
        return self.originPath.boundingBoxOfPath
    }
    public var originClipPath:CGPath?{
        get{
            return clipPath
        }
        set{
             clipPath = newValue
        }
    }
    public var originClipRect:CGRect{
        return self.clipPath?.boundingBoxOfPath ?? .zero
    }
    
    public var pathRect:CGRect{
        return self.path?.boundingBoxOfPath ?? .zero
    }
    public var path:CGPath?{
        var tra = self.transform
        return self.originPath.copy(using: &tra)
    }
    public var pathClipRect:CGRect{
        return self.pathForClip?.boundingBoxOfPath ?? .zero
    }
    public var pathForClip:CGPath?{
        var tra = self.transform
        return self.originClipPath?.copy(using: &tra)
    }
    public func doClip(canvas:Context){
        if let cpath = self.pathForClip{
            canvas.context.addPath(cpath)
            canvas.context.clip()
        }
    }
    public init(path:CGPath) {
        self.innerPath = path
    }
    
    public func addSubView(view:Shape){
        self.subViews.append(view)
        view.superView = self
    }
    //MARK:- store
    public var anchorPoint:CGPoint = .zero
    public var scale:CGPoint = CGPoint(x: 1, y: 1)
    public var translate:CGPoint = .zero
    public var rotate:CGFloat = 0
    public var drawMode:CGPathDrawingMode = .fill
    public var texture:Texture?
    public weak var superView: Drawable?
    public var subViews: [Drawable] = []
    public var lineWidth:CGFloat = 1
    private var innerPath:CGPath
    private var clipPath:CGPath?
}

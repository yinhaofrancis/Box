//
//  Canvas.swift
//  rxs
//
//  Created by Francis on 2018/6/5.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import QuartzCore
import ImageIO


#if os(iOS)
import MobileCoreServices
#else
import CoreServices
#endif

public protocol Context {
    var context:CGContext {get}
    var size:CGSize {get}
    var scale:CGFloat {get}
    var colorSpace:CGColorSpace{get}
    func drawItem(drawable:Drawable)
}

public class Canvas:Context{
    public enum ColorFomat{
        case rgb5a1
        case rgb8
        case rgb16
        case rgba8
        case rgba16
        case rgb32
        case rgba32
    }
    public let context:CGContext
    public let size:CGSize
    public let scale:CGFloat
    public let colorSpace:CGColorSpace
    public var clearColor:CGColor?
    private var data:UnsafeMutablePointer<UInt8>
    private var bufferSize:Int
    public required init(size:CGSize,scale:CGFloat = 1,colorFormat:ColorFomat = .rgb8,clearColor:CGColor? = CGColor.white,line:Int=#line,file:String = #file) throws{
        self.scale = scale
        self.colorSpace = CGColorSpaceCreateDeviceRGB()
        let csize = CGSize(width: Int(ceil(size.width * scale)), height: Int(ceil(size.height * scale)))
        self.size = csize
        self.clearColor = clearColor
        var info:uint = 0
        var colorComponent = 0
        var bytesPerRow = 0
        switch colorFormat {
        case .rgb5a1:
            info = CGImageAlphaInfo.noneSkipFirst.rawValue
            colorComponent = 5
            bytesPerRow = 2 * Int(csize.width)
            bufferSize = bytesPerRow * Int(csize.height)
            data = UnsafeMutablePointer.allocate(capacity: bufferSize)
        case .rgb8:
            info = CGImageAlphaInfo.premultipliedLast.rawValue
            colorComponent = 8
            bytesPerRow = (colorSpace.numberOfComponents + 1) * (colorComponent / 8) * Int(csize.width)
            bufferSize = bytesPerRow * Int(csize.height)
            data = UnsafeMutablePointer.allocate(capacity: bufferSize)
        case .rgba16:
            info = CGImageAlphaInfo.premultipliedLast.rawValue
            colorComponent = 16
            bytesPerRow = (colorSpace.numberOfComponents + 1) * (colorComponent / 8) * Int(csize.width)
            bufferSize = bytesPerRow * Int(csize.height)
            data = UnsafeMutablePointer.allocate(capacity: bufferSize)
        case .rgb16:
            colorComponent = 16
            info = CGImageAlphaInfo.noneSkipLast.rawValue
            bytesPerRow = (colorSpace.numberOfComponents + 1) * (colorComponent / 8) * Int(csize.width)
            bufferSize = bytesPerRow * Int(csize.height)
            data = UnsafeMutablePointer.allocate(capacity: bufferSize)
        case .rgba8:
            colorComponent = 8
            info = CGImageAlphaInfo.premultipliedLast.rawValue
            bytesPerRow = (colorSpace.numberOfComponents + 1) * (colorComponent / 8) * Int(csize.width)
            bufferSize = bytesPerRow * Int(csize.height)
            data = UnsafeMutablePointer.allocate(capacity: bufferSize)
        case .rgb32:
            colorComponent = 32
            info = CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.floatComponents.rawValue
            bytesPerRow = (colorSpace.numberOfComponents + 1) * (colorComponent / 8) * Int(csize.width)
            bufferSize = bytesPerRow * Int(csize.height)
            data = UnsafeMutablePointer.allocate(capacity: bufferSize)
        case .rgba32:
            colorComponent = 32
            info = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.floatComponents.rawValue
            bytesPerRow = (colorSpace.numberOfComponents + 1) * (colorComponent / 8) * Int(csize.width)
            bufferSize = bytesPerRow * Int(csize.height)
            data = UnsafeMutablePointer.allocate(capacity: bufferSize)
        }
        let ctx = CGContext(data: data, width: Int(csize.width), height: Int(csize.height), bitsPerComponent: colorComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: info)
        if let c = ctx{
            context = c
            self.clear(clearColor: clearColor)
            context.scaleBy(x: scale, y: scale)
            context.setShouldAntialias(true)
            context.setAllowsAntialiasing(true)
        }else{
            throw DrawError.createContextFail(line,file)
        }
    }
    public func draw(drawable:Drawable,callback:@escaping (CGImage?)->Void){
        self.drawItem(drawable: drawable)
        
        Canvas.group.notify(queue: DispatchQueue.main) {
            callback(self.context.makeImage())
        }
    }
    public func draw(drawable:Drawable)->CGImage?{
        self.drawItem(drawable: drawable)
        Canvas.group.wait()
        return self.context.makeImage()
    }
    public func createLayer(line:Int = #line,file:String = #file) throws ->CGLayer{
        if let layer = CGLayer(self.context, size: self.size, auxiliaryInfo: nil){
            return layer
        }
        throw DrawError.createLayerFail(line,file)
        
    }
    private func clear(clearColor:CGColor?){
        self.clearColor = clearColor
        self.context.clear(CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let color = clearColor{
            self.context.saveGState()
            self.context.setFillColor(color)
            self.context.fill(CGRect(origin: .zero, size: self.size))
            self.context.restoreGState()
        }
    }

    public static func <<<(rv:inout Data,lv:Canvas){
        rv = Data(bytes: lv.data, count: lv.bufferSize)
    }
    
    public func drawItem(drawable:Drawable){
        Canvas.queue.async(group: Canvas.group, qos: DispatchQoS.utility, flags: .inheritQoS) {
            self.clear(clearColor: self.clearColor)
            self.context.saveGState()
            self.context.beginTransparencyLayer(auxiliaryInfo: nil)
            drawable.render(canvas: self)
            self.context.endTransparencyLayer()
            self.context.restoreGState()
        }
    }
    public func drawCache(cache:Cache){
        Canvas.queue.async(group: Canvas.group, qos: DispatchQoS.utility, flags: .inheritQoS) {
            if let l = cache.layer{
                self.clear(clearColor: self.clearColor)
                self.context.saveGState()
                self.context.beginTransparencyLayer(auxiliaryInfo: nil)
                self.context.draw(l, in: CGRect(origin: .zero, size: self.size))
                self.context.endTransparencyLayer()
                self.context.restoreGState()
            }
        }
    }
    var image:CGImage?{
        Canvas.group.wait()
        return self.context.makeImage()
    }
    deinit {
        self.data.deallocate()
    }
    private static let queue:DispatchQueue = DispatchQueue(label: "Canvas")
    private static let group:DispatchGroup = DispatchGroup()
}
infix operator <<< : AdditionPrecedence


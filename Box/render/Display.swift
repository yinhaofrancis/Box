//
//  Display.swift
//  MetalTu
//
//  Created by Francis on 2018/7/24.
//  Copyright © 2018年 Francis. All rights reserved.
//

import Foundation
import Metal
import MetalKit

public class MetalDisplay: RenderTarget {
    
    public weak var render:Render?
    
    private var currentDrawable:CAMetalDrawable?
    
    public init(w:Int,h:Int,render:Render) {
        self.render = render;
        
        layer = CAMetalLayer()
        layer.pixelFormat = MTLPixelFormat.bgra8Unorm_srgb
        layer.frame = CGRect(x: 0, y: 0, width: w, height: h)
        layer.contentsScale = UIScreen.main.scale
        layer.rasterizationScale = UIScreen.main.scale
        width = Double(w * Int(UIScreen.main.scale))
        height = Double(h * Int(UIScreen.main.scale))
        layer.drawableSize = CGSize(width: width, height: height)
        zSpace = 1
        textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: self.depthFormat , width: w * Int(UIScreen.main.scale), height: h * Int(UIScreen.main.scale), mipmapped: true)
        textureDescriptor.usage = .renderTarget
        renderPass = MTLRenderPassDescriptor()
        layer.device = self.render?.device
        self.render?.target = self
    }
    public func nextDepthTexture()->MTLTexture?{
        return self.render?.device.makeTexture(descriptor: self.textureDescriptor)
    }
    
    private var textureDescriptor:MTLTextureDescriptor
    
    public var layer:CAMetalLayer
    
    private var renderPass: MTLRenderPassDescriptor
    
    public var renderPassDescriptor: MTLRenderPassDescriptor{
        if currentDrawable == nil{
            currentDrawable = self.layer.nextDrawable()
        }
        renderPass.colorAttachments[0].texture = currentDrawable?.texture
        renderPass.colorAttachments[0].clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1)
        renderPass.colorAttachments[0].storeAction = .store
        renderPass.colorAttachments[0].loadAction = .clear
        renderPass.depthAttachment.clearDepth = 32
        renderPass.depthAttachment.texture = nextDepthTexture()
        
        return renderPass
    }
    
    public var drawable: CAMetalDrawable?{
        self.layer.drawableSize = CGSize(width: width, height: height)
        let drawable = self.currentDrawable
        self.currentDrawable = nil
        return drawable
    }
    
    public var colorFormat: MTLPixelFormat{
        return self.layer.pixelFormat
    }
    
    public var depthFormat: MTLPixelFormat = MTLPixelFormat.depth32Float
    
    public var stencilFormat: MTLPixelFormat = MTLPixelFormat.stencil8
    
    public var width: Double
    
    public var height: Double
    
    public var zSpace: Double

}
//public class DefaultDisplay:RenderTarget{
//    let view:MTKView
//    public weak var render:Render?
//    public init(render:Render) {
//        self.render = render
//        
//        view = MTKView(frame: UIScreen.main.bounds, device: render.device)
//        render.target  =  self
//    }
//    
//    public var renderPassDescriptor: MTLRenderPassDescriptor{
//        return view.currentRenderPassDescriptor!
//    }
//    
//    public var drawable: CAMetalDrawable?{
//        return view.currentDrawable
//    }
//    
//    public var colorFormat: MTLPixelFormat{
//        return self.view.colorPixelFormat
//    }
//    
//    public var depthFormat: MTLPixelFormat{
//        return self.view.depthStencilPixelFormat
//    }
//    
//    public var stencilFormat: MTLPixelFormat{
//        return self.view.depthStencilPixelFormat
//    }
//    
//    public var width: Double{
//        return Double(self.view.frame.width * UIScreen.main.scale)
//    }
//    
//    public var height: Double{
//        return Double(self.view.frame.height * UIScreen.main.scale)
//    }
//    
//    public var zSpace: Double{
//        return 1
//    }
//    
//    
//}

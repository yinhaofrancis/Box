//
//  RenderService.swift
//  Box
//
//  Created by Francis on 2018/7/26.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import Foundation
import Metal
import MetalKit
public enum RenderError:Error{
    case renderError(String)
}

public class RenderService{
    public let device:MTLDevice
    public let commandQueue:MTLCommandQueue
    private init() throws{
        guard let dev = MTLCreateSystemDefaultDevice() else {
            throw RenderError.renderError("CreateDevice")
        }
        device = dev
        guard let  cq = dev.makeCommandQueue() else{
            throw RenderError.renderError("CreateCommandQueueError")
        }
        commandQueue = cq
    }
    public var renderBuffer:MTLCommandBuffer?{
        return try? self.createRenderBuffer()
    }
    private func createRenderBuffer()throws ->MTLCommandBuffer {
        guard let renderBuffer = commandQueue.makeCommandBuffer() else{
            throw RenderError.renderError("CreateCommandBufferErrors")
        }
        return renderBuffer
    }
    private func createRenderEncoder(buffer:MTLCommandBuffer,
                                     desciptor:MTLRenderPassDescriptor)throws ->MTLRenderCommandEncoder{
        guard let renderEncoder = buffer.makeRenderCommandEncoder(descriptor: desciptor) else {
            throw RenderError.renderError("CreateRenderEncoder")
        }
        return renderEncoder;
    }
//    public func draw(model:RendableModel){
//        if let tar = self.target{
//            do{
//                let buffer = try createRenderBuffer()
//                model.calc(buffer: buffer)
//                let encoder = try createRenderEncoder(buffer: buffer, desciptor: tar.renderPassDescriptor)
//                encoder.setViewport(MTLViewport(originX: 0, originY: 0, width: tar.width, height: tar.height, znear: -tar.zSpace, zfar: tar.zSpace))
//                model.render(encode: encoder)
//                encoder.endEncoding()
//                
//                if let drawab = tar.drawable{
//                    buffer.present(drawab)
//                }
//                
//                buffer.commit()
//            }catch RenderError.renderError(let s) {
//                print(s)
//            }catch{
//                print("unknowed error")
//            }
//        }
//    }
    static public var shared:RenderService = {
        return try! RenderService()
    }()
    
}

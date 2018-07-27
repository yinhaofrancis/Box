//
//  Model.swift
//  Box
//
//  Created by Francis on 2018/7/26.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import Foundation
import MetalKit
import Metal
import simd
public struct Vertex{
    public var location:float3
    public var uv:float2
}

public protocol Model:class{
    var vertex:MTLBuffer? {get}
    var texture:MTLTexture? {get}
    func draw()
}

public class RectModel:Model{
    public var vertex: MTLBuffer?
    
    public var texture: MTLTexture?
    
    public init(size:CGSize){
        self.size = size
        self.vertice = self.makeVertexWith(size: size)
        vertex = RenderService.shared.device.makeBuffer(bytes: self.vertice,
                                                        length: MemoryLayout<Vertex>.stride * self.vertice.count,
                                                        options: .storageModeShared)
    }
    public func makeVertexWith(size:CGSize)->[Vertex]{
        return [
            Vertex(location: float3([Float(size.width / -2),Float(size.height / 2),0]), uv: float2([0,0])),
            Vertex(location: float3([Float(size.width / 2),Float(size.height / 2),0]), uv: float2([1,0])),
            Vertex(location: float3([Float(size.width / -2),Float(size.height / -2),0]), uv: float2([1,1])),
            Vertex(location: float3([Float(size.width / 2),Float(size.height / -2),0]), uv: float2([0,1])),
        ];
    }
    public func draw() {
        
    }
    public var size:CGSize
    public var vertice:[Vertex] = []
}
extension Model{
    public static func sizeToFill(vertexWHRatio:Float,textureWHRatio:Float)->[float2]{
        let ratio = vertexWHRatio / textureWHRatio
        if textureWHRatio  > vertexWHRatio{
            return [float2([(1 - ratio) / 2,0]),float2([(1 - ratio) / 2 + ratio,0]),float2([(1 - ratio) / 2,1]),float2([(1 - ratio) / 2 + ratio,1])]
        }else{
            let tRatio = 1 / ratio
            return [float2([0,(1 - tRatio) / 2]),float2([0,(1 - tRatio) / 2 + tRatio]),float2([1,(1 - tRatio) / 2]),float2([1,(1 - tRatio) / 2 + tRatio])]
        }
    }
}

//
//  RectModel.metal
//  Box
//
//  Created by Francis on 2018/7/27.
//  Copyright © 2018年 hao yin. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

typedef struct{
    float3 location [[attribute(0)]];
    float2 uv [[attribute(1)]];
}vertexIn;

typedef struct{
    float4 location [[position]];
    float2 uv;
}vertexOut;

typedef struct {
    float4 backColor;
    bool useTexture;
    
}RenderState;

vertex vertexOut RectModelVertexShader(vertexIn in[[stage_in]]){
    vertexOut out;
    out.location = float4(in.location,1);
    out.uv = in.uv;
    return out;
}
fragment float4 RectModelFragmentShader(vertexOut out[[stage_in]],
                                         texture2d<half,access::sample>texture[[texture(0)]],
                                         sampler sample [[sampler(1)]],
                                         constant RenderState &state [[buffer(2)]]){
    if (state.useTexture){
        return state.backColor;
    }else{
        return float4(texture.sample(sample,out.uv));
    }
}

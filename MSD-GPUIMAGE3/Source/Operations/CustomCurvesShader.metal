//
//  CustomCurvesShader.metal
//  MyZesty
//
//  Created by ispha on 3/30/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#include <metal_stdlib>

#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
    float intensity;
} CurvesUniform;

fragment half4 CustomCurvesShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                texture2d<half> inputTexture2 [[texture(1)]],
                                constant CurvesUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    float r = color.r;
    float g = color.g;
    float b = color.b;
    
    r = inputTexture2.sample(quadSampler, float2(r, 0.1)).r;
    g = inputTexture2.sample(quadSampler, float2(g, 0.1)).r;
    b = inputTexture2.sample(quadSampler, float2(b, 0.1)).r;
                        
    b = inputTexture2.sample(quadSampler, float2(b, 0.3)).r;
    g = inputTexture2.sample(quadSampler, float2(g, 0.5)).r;
    r = inputTexture2.sample(quadSampler, float2(r, 0.7)).r;
    
    float lum = 0.299 * float(r) + 0.587 * float(g) + 0.114 * float(b);
    float k = 1.0;
    
    if (lum > 0.000001)
        k = inputTexture2.sample(quadSampler, float2(lum, 0.9)).r / lum;
    r = r * k;
    g = g * k;
    b = b * k;

    return half4(r,g,b,color.a);
}



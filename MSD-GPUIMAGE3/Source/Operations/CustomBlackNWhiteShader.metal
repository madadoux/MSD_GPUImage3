//
//  CustomBlackNWhiteShader.metal
//  Zesty
//
//  Created by ispha on 3/23/20.
//  Copyright © 2020 ispha. All rights reserved.
//

#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
    float intensity;
} BlackNWhiteUniform;
fragment half4 CustomBlackNWhiteShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                constant BlackNWhiteUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    half luminance = dot(color.rgb, luminanceWeighting);
    
    color= half4(mix(half3(luminance), color.rgb, half(1-uniform.intensity)), color.a);
    //contrast
    color = half4(((color.rgb - half3(0.5)) * (1+uniform.intensity) + half3(0.5)), color.a);
    return color;
}


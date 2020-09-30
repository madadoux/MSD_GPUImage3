//
//  CustomRainBowShader.metal
//  Zesty
//
//  Created by ispha on 3/20/20.
//  Copyright © 2020 ispha. All rights reserved.
//

#include <metal_stdlib>

#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
    float intensity;
} ShaderUniform;

fragment half4 CustomRainBowShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                constant ShaderUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    float radius = sqrt(tc.x * tc.x + tc.y * tc.y)/(sqrt(2.0));
    color = half4(color.r+(radius)*uniform.intensity,color.g+(1.0-radius)*uniform.intensity,color.b,color.a);
    return color;
}
    

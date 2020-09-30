//
//  CustomSketchShader.metal
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
fragment half4 CustomWaterColorShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                texture2d<half> inputTexture2 [[texture(1)]],
                                constant ShaderUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    half4 color2= inputTexture2.sample(quadSampler, tc);
    half4 finalColor=half4(color.rgb*(1-uniform.intensity)+color2.rgb*(uniform.intensity),color.a);
    return finalColor;
}

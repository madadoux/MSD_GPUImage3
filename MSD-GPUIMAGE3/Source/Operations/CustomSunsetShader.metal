//
//  CustomSunsetShader.metal
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
} SunsetUniform;
fragment half4 CustomSunsetShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                constant SunsetUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    float y = tc.y;

    float distance_factor1 = 1/(1+exp(-(6.0 * (0.6 - y))));
    float distance_factor2 = 1/(1+exp(-(9.0 * (y - 0.15))));
    
    float distance_factor = (distance_factor1 < distance_factor2) ? distance_factor1 : distance_factor2;
    color.rgb -= color.rgb * 0.3* uniform.intensity;
    color = half4(color.r * (1.0 + 0.1 * distance_factor * uniform.intensity),color.g * (1.0 - 0.4 * distance_factor * uniform.intensity),color.b * (1.0 - 0.6 * distance_factor * uniform.intensity), color.a);
    return color;
}

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
    float reverse;
} MirrorUniform;
fragment half4 CustomMirrorShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                constant MirrorUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    if(uniform.reverse>=1.0)
        if(tc.x>uniform.intensity)
            color = inputTexture.sample(quadSampler, float2(1.0-tc.x,tc.y));
        else
            color = inputTexture.sample(quadSampler, float2(tc.x,tc.y));
    else
        if(tc.x>uniform.intensity)
            color = inputTexture.sample(quadSampler, float2(tc.x,tc.y));
        else
            color = inputTexture.sample(quadSampler, float2(1.0-tc.x,tc.y));

    return color;
}

//
//  CustomNewMirror.metal
//  Zesty
//
//  Created by MSD on 5/19/20.
//  Copyright © 2020 ispha. All rights reserved.
#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
    float intensity;
    float reverse;
    float orientation;
} NewMirrorUniform;
fragment half4 CustomNewMirrorShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                constant NewMirrorUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    if(uniform.orientation<1)
        if(uniform.reverse>=1.0)
            if(tc.x>0.5)
                color = inputTexture.sample(quadSampler, float2(1.0-tc.x+uniform.intensity/2,tc.y));
            else
                color = inputTexture.sample(quadSampler, float2(tc.x+uniform.intensity/2,tc.y));
        else
            if(tc.x>0.5)
                color = inputTexture.sample(quadSampler, float2(tc.x-uniform.intensity/2,tc.y));
            else
                color = inputTexture.sample(quadSampler, float2(1.0-tc.x-uniform.intensity/2,tc.y));
    else
        if(uniform.reverse>=1.0)
            if(tc.y>0.5)
                color = inputTexture.sample(quadSampler, float2(tc.x,1.0-tc.y+uniform.intensity/2));
            else
                color = inputTexture.sample(quadSampler, float2(tc.x,tc.y+uniform.intensity/2));
        else
            if(tc.y>0.5)
                color = inputTexture.sample(quadSampler, float2(tc.x,tc.y-uniform.intensity/2));
            else
                color = inputTexture.sample(quadSampler, float2(tc.x,1.0-tc.y-uniform.intensity/2));

    return color;
}

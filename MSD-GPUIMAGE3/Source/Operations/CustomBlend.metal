//
//  CustomBlend.metal
//  Zesty
//
//  Created by ispha on 1/15/20.
//  Copyright © 2020 ispha. All rights reserved.
//

#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
    float intensity;
  
} CustomBlendUniform;

fragment half4 customBlendFragment(TwoInputVertexIO fragmentInput [[stage_in]],
                                       texture2d<half> inputTexture [[texture(0)]],
                                       texture2d<half> inputTexture2 [[texture(1)]]
                                     ,
                                       constant CustomBlendUniform& uniform [[ buffer(1) ]]
                                     )
{
    constexpr sampler quadSampler;
    half4 base = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    constexpr sampler quadSampler2;
    half4 overlay = inputTexture2.sample(quadSampler, fragmentInput.textureCoordinate2);
     return   overlay * (1.0h - uniform.intensity) + base * uniform.intensity;
    //return overlay * base + overlay * (1.0h - uniform.intensity) + base * uniform.intensity;
}

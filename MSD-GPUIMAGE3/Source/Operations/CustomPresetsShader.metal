//
//  CustomPresetsShader.metal
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
    float variation;
    float intensity;
} PresetUniform;
fragment half4 CustomPresetsShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                constant PresetUniform& uniform [[ buffer(1) ]])
{
    half3 colors[7]={half3(128,0,0),half3(123,128,0),half3(0,85,128),half3(64,128,0),half3(85,0,128),half3(128,79,36),half3(89,45,0)};
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    float maxChannel=color.r;
    if(maxChannel<color.g)
        maxChannel=color.g;
    if(maxChannel<color.b)
        maxChannel=color.b;
    float pureValioRate=maxChannel*2.0/255;
    half3 blendColor=colors[int(uniform.variation)];
    return half4(pureValioRate*uniform.intensity*blendColor+color.rgb*(1-uniform.intensity),color.a);
}

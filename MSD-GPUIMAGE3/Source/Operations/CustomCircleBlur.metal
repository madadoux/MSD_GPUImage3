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
    float intensity;// 0-1  rad 0-1, def - 0
    float centerX;
    float centerY;
    float radius;
} CustomCirculBlurUniform;
float circleBlurSigmoid(float x)
{
    return 1.0/(1+exp(-x));
}
float2 newCoordinates(float2 targetCoordinates,float oldSize,float maxDimension)
{
    return targetCoordinates*(maxDimension+10)/oldSize;
}
fragment half4 CustomCircleBlurShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                texture2d<half> inputTexture2 [[texture(1)]],
                                constant CustomCirculBlurUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler(mag_filter::linear,min_filter::linear);
    float2 tc=fragmentInput.textureCoordinate;
    float height= inputTexture.get_height();
    float width=inputTexture.get_width();

    half4 color = inputTexture.sample(quadSampler, tc);
    int trackLen = uniform.intensity*50;
    half4 colorSum = color;
    //  backward track.
    float2 tc_cur = tc;
    for(int i=0; i < trackLen; i++)
    {
        half4 color2i = inputTexture2.sample(quadSampler, ((1.0 - float2(uniform.centerX, uniform.centerY)) / 2.0 + tc_cur / 2.0));
        float2 tc_weight = (float2(color2i.x, color2i.y) - 0.5) * 2.5;
        tc_cur = tc_cur + float2(tc_weight.x/ width, -tc_weight.y /height);
        half4 color1i = inputTexture.sample(quadSampler, tc_cur);
        colorSum += color1i;
    }

    tc_cur = tc;
    for(int i=0; i < trackLen; i++)
    {
        half4 color2i =  inputTexture2.sample(quadSampler, ((1.0 - float2(uniform.centerX, uniform.centerY)) / 2.0 + tc_cur / 2.0));
        float2 tc_weight = (float2(color2i.z, color2i.w) - 0.5) * 2.5;

        tc_cur = tc_cur + float2(tc_weight.x / width, -tc_weight.y /height);

        half4 color1i = inputTexture.sample(quadSampler, tc_cur);
        colorSum += color1i;

    }
  

    half4 color_effect = colorSum / float(1 + 2 * trackLen);


    float effect_weight;
    float dist_x = tc.x - uniform.centerX;
    float dist_y = tc.y - uniform.centerY;
    float dist = sqrt(dist_x * dist_x + dist_y * dist_y);
    effect_weight = circleBlurSigmoid((dist - uniform.radius) * 16.0);
    
                    

    return half4(mix(color, color_effect, effect_weight).rgb,1.0);
}

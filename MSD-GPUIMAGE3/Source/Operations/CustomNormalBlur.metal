//
//  CustomNormalBlur.metal
//  Zesty
//
//  Created by ispha on 3/17/20.
//  Copyright © 2020 ispha. All rights reserved.
//

#include <metal_stdlib>

#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
    float blurWinSize;
} ShaderUniform;
fragment half4 CustomNormalBlurFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                texture2d<half> inputTexture2 [[texture(1)]],
                                constant ShaderUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    if(uniform.blurWinSize<2)
        return color;
    float h=1.0/inputTexture.get_height();
    float w=1.0/inputTexture.get_width();
    float2 pixelSize(w,h);
    //run blur
    float denominator=0.0;
    float4 sum (0.0, 0.0, 0.0, 0.0);
    float step_abs = uniform.blurWinSize / 7.0;
    float2 step_size = pixelSize * step_abs;
    for (int i = -3; i <= 3; ++i)
    {
        for (int j = -3; j <= 3; ++j)
        {
            float x, y;
            float wight = 5.0 -sqrt(float(i*i + j*j));
            x = tc.x + float(i) * step_size.x;
            y = tc.y + float(j) * step_size.y;
            if(uniform.blurWinSize > 11)
                sum += float4(wight * inputTexture2.sample(quadSampler, float2(x,y)));
            else
                sum += float4(wight * inputTexture.sample(quadSampler, float2(x,y)));
            denominator += wight;
        }
    }
    
    half4 blurredColor=half4(half3(sum.rgb / denominator),color.a);
    return blurredColor;
}

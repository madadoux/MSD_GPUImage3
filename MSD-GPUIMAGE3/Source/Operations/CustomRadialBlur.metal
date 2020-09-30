#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;

typedef struct
{

    float blurWinSize;
    float angle;
    float a;
    float b;
    float trans;
    float centerX;
    float centerY;
} RadialBlurUniform;

fragment half4 CustomRadialBlurFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                texture2d<half> inputTexture2 [[texture(1)]],
                                constant RadialBlurUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    float h=1.0/inputTexture.get_height();
    float w=1.0/inputTexture.get_width();
    float2 pixelSize(w,h);
    int blurWinSize=uniform.blurWinSize ;
    
    //calulate elipse radius
    float X = ((tc.x - uniform.centerX) * (h / w) * cos(uniform.angle)) -((tc.y - uniform.centerY)* sin(uniform.angle));
    float Y = ((tc.x - uniform.centerX) * (h / w) * sin(uniform.angle)) +((tc.y - uniform.centerY)* cos(uniform.angle));
    float radius = sqrt(pow(X /uniform.b,2)+pow(Y /uniform.a,2));
    
    float outerElp = (uniform.a +uniform.trans) / uniform.a;
    
    //choose area
    if(radius<1.0)
        return color;
    else if(radius<outerElp)
    {
        float ratio = (radius - 1.0) / (outerElp-1.0);
        blurWinSize = int(ratio * uniform.blurWinSize);
        if(blurWinSize < 1)
            blurWinSize = 1;
    }
    else
        blurWinSize=uniform.blurWinSize;
    
    //run blur
    float denominator=0.0;
    float4 sum (0.0, 0.0, 0.0, 0.0);
    float step_abs = blurWinSize / 7.0;
    float2 step_size = pixelSize * step_abs;
    for (int i = -3; i <= 3; ++i)
    {
        for (int j = -3; j <= 3; ++j)
        {
            float x, y;
            float wight = abs(5.0 -sqrt(float(i*i + j*j)));
            x = tc.x + float(i) * step_size.x;
            y = tc.y + float(j) * step_size.y;
            if(blurWinSize > 11)
                sum += float4(wight * inputTexture2.sample(quadSampler, float2(x,y)));
            else
                sum += float4(wight * inputTexture.sample(quadSampler, float2(x,y)));
            denominator += wight;
        }
    }

    half4 blurredColor=half4(half3(sum.rgb / denominator),color.a);
    return blurredColor;
}

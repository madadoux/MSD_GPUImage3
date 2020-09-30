#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
  float intensity;
} MorningUniform;

fragment half4 CustomMorningShader(SingleInputVertexIO fragmentInput [[stage_in]],
                texture2d<half> inputTexture [[texture(0)]],
                texture2d<half> inputTexture2 [[texture(1)]],
                constant MorningUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler(mag_filter::linear,min_filter::linear);
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    float r=inputTexture2.sample(quadSampler,float2(color.r, (uniform.intensity*0.6 + 1.0) / 2.0)).r;
    float g=inputTexture2.sample(quadSampler,float2(color.g, (uniform.intensity*0.6 + 1.0) / 2.0)).r;
    float b=inputTexture2.sample(quadSampler,float2(color.b, (uniform.intensity*0.6 + 1.0) / 2.0)).r;
    half4 newColor=half4(r,g,b,color.a);
    float y = tc.y;
    float distance_factor = 1/(1+exp(-7.0 * (y - 0.6)));//sigmoid
    newColor = half4(newColor.r * (1.0 + 0.225 * distance_factor * uniform.intensity),newColor.g,
                     newColor.b * (1.0 - 0.25 * distance_factor * uniform.intensity), newColor.a);
    return newColor;
}

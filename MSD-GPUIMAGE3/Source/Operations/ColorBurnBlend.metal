#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;

fragment half4 colorBurnBlendFragment(TwoInputVertexIO fragmentInput [[stage_in]],
                                     texture2d<half> inputTexture [[texture(0)]],
                                     texture2d<half> inputTexture2 [[texture(1)]])
{
    constexpr sampler quadSampler;
    half4 textureColor = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    constexpr sampler quadSampler2;
    half4 textureColor2 = inputTexture2.sample(quadSampler, fragmentInput.textureCoordinate2);
    half4 whiteColor = half4(1.0);
  
    if ( textureColor2.a == 0){
      return  half4(textureColor.rgb, textureColor.a);
    }

    return whiteColor - (whiteColor - textureColor) / textureColor2;
}

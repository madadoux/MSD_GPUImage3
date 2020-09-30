#include <metal_stdlib>

#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
    float satValue0;
    float satValue1;
    float satValue2;
    float satValue3;
    float satValue4;
    float satValue5;
    float satValue6;
    float satValue7;

    float brightValue0;
    float brightValue1;
    float brightValue2;
    float brightValue3;
    float brightValue4;
    float brightValue5;
    float brightValue6;
    float brightValue7;
    
    
    float fade;

    float hueCenter0;
    float hueCenter1;
    float hueCenter2;
    float hueCenter3;
    float hueCenter4;
    float hueCenter5;
    float hueCenter6;
    float hueCenter7;
    
    float hueShiftAll;
    float hueShift0;
    float hueShift1;
    float hueShift2;
    float hueShift3;
    float hueShift4;
    float hueShift5;
    float hueShift6;
    float hueShift7;
    
} ColorShaderUniform;
half3 rgb2hsv(half3 c)
{
    half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    half4 p = mix(half4(c.bg, K.wz), half4(c.gb, K.xy), step(c.b, c.g));
    half4 q = mix(half4(p.xyw, c.r), half4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return half3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

half3 hsv2rgb(half3 c)
{
    half4 K = half4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    half3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float clipInRange01(float val)
{
    if(val < 0.0)
        return 0.0;
    else if(val > 1.0)
        return 1.0;
    else
        return val;
}

float addToNormHue(float inp, float addedVal)
{
    float newHue = inp + addedVal;
    while(newHue > 1.0)
        newHue = newHue - 1.0;
    while(newHue < 0.0)
        newHue = 1.0 + newHue;
    return newHue;
}
float scaleDiff(float inp, float res, float factor)
{
    float res1 = clipInRange01(inp + factor * (res - inp));
    return res1;
}
half3 scaleDiffVec3(half3 inp, half3 res, float factor)
{
    half3 res1 =inp + factor * (res - inp);
    return res1;
}
half3 doFade(float r, float g, float b,float fade)
{
    float grayColor = 0.75;
    r = r * (1.0 - fade) + grayColor * fade;
    g = g * (1.0 - fade) + grayColor * fade;
    b = b * (1.0 - fade) + grayColor * fade;
    return half3(r,g,b);
}

float addWeighted(float inp1, float weight1, float inp2, float weight2)
{
    if(weight1 + weight2 < 0.01)
        return inp1;
    return (inp1 * weight1 + inp2 * weight2) / (weight1 + weight2);
}

float calcDiffRate(float hue_diff)
{
    if(hue_diff < 0.2)
       return 1.0;
    float rate = 15.0 / hue_diff;//gusian distribution without denominator.
    return rate;
}
half3 getHueRate(float normHue,ColorShaderUniform uniform)
{
    float h = normHue;
    float newHue = addToNormHue(h, uniform.hueShiftAll);
    h = newHue * 360.0;
    float minDiff1 = 500.0, minDiff2 = 500.0, diffBetweenCenters = 500.0;
    float hueShiftWithMinDiff1 = 0.0, hueShiftWithMinDiff2 = 0.0;
    float saturationWithMinDiff1 = 0.0, saturationWithMinDiff2 = 0.0;
    float valueWithMinDiff1 = 0.0, valueWithMinDiff2 = 0.0;
    const float secondCenterRatio = 0.8;
    
    float hueCenter0_0 =int(uniform.hueCenter0  - 10+360) % 360;
    float hueCenter0_1 =int(uniform.hueCenter0  + 5) % 360;
    
    float hueCenter3_0 =int(uniform.hueCenter3  - 10) ;
    float hueCenter3_1 =int(uniform.hueCenter3  + 50);
    
    float hueCenter5_0 =int(uniform.hueCenter5 - 5) ;
    float hueCenter5_1 =int(uniform.hueCenter5 + 40)% 360 ;
    
    if(h >= hueCenter0_1 && h <= uniform.hueCenter1)
    {
        float hue_diff0 = abs(h - hueCenter0_1);
        if (hue_diff0 > 360.0 - hue_diff0)
            hue_diff0 = 360.0 - hue_diff0;
        
        float hue_diff1 = abs(h - uniform.hueCenter1);
        if (hue_diff1 > 360.0 - hue_diff1)
            hue_diff1 = 360.0 - hue_diff1;
        diffBetweenCenters = uniform.hueCenter1 - hueCenter0_1;
        minDiff1 = hue_diff0;
        hueShiftWithMinDiff1 = uniform.hueShift0 * secondCenterRatio;
        saturationWithMinDiff1 = uniform.satValue0 * secondCenterRatio;
        valueWithMinDiff1 = uniform.brightValue0 * secondCenterRatio;
        minDiff2 = hue_diff1;
        hueShiftWithMinDiff2 = uniform.hueShift1;
        saturationWithMinDiff2 = uniform.satValue1;
        valueWithMinDiff2 = uniform.brightValue1;
    }
    else if(h >= uniform.hueCenter1 && h <= uniform.hueCenter2)
    {
        float hue_diff1 = abs(h - uniform.hueCenter1);
        if (hue_diff1 > 360.0 - hue_diff1)
            hue_diff1 = 360.0 - hue_diff1;
        
        float hue_diff2 = abs(h - uniform.hueCenter2);
        if (hue_diff2 > 360.0 - hue_diff2)
            hue_diff2 = 360.0 - hue_diff2;
        diffBetweenCenters = uniform.hueCenter2 - uniform.hueCenter1;
        
        minDiff2 = hue_diff1;
        hueShiftWithMinDiff2 = uniform.hueShift1;
        saturationWithMinDiff2 = uniform.satValue1;
        valueWithMinDiff2 = uniform.brightValue1;
        
        minDiff1 = hue_diff2;
        hueShiftWithMinDiff1 = uniform.hueShift2;
        saturationWithMinDiff1 = uniform.satValue2;
        valueWithMinDiff1 = uniform.brightValue2;
    }
    else if(h >= uniform.hueCenter2 && h <= hueCenter3_0)
    {
        float hue_diff2 = abs(h - uniform.hueCenter2);
        if (hue_diff2 > 360.0 - hue_diff2)
            hue_diff2 = 360.0 - hue_diff2;
        float hue_diff3 = abs(h - hueCenter3_0);
        if (hue_diff3 > 360.0 - hue_diff3)
            hue_diff3 = 360.0 - hue_diff3;
        diffBetweenCenters = hueCenter3_0 - uniform.hueCenter2;
        
        minDiff1 = hue_diff2;
        hueShiftWithMinDiff1 = uniform.hueShift2;
        saturationWithMinDiff1 = uniform.satValue2;
        valueWithMinDiff1 = uniform.brightValue2;
    
        minDiff2 = hue_diff3;
        hueShiftWithMinDiff2 = uniform.hueShift3;
        saturationWithMinDiff2 = uniform.satValue3;
        valueWithMinDiff2 = uniform.brightValue3;
    }
    else if(h >= hueCenter3_0 && h <= hueCenter3_1)
    {
        float hue_diff3_0 = abs(h - hueCenter3_0);
        if (hue_diff3_0 > 360.0 - hue_diff3_0)
            hue_diff3_0 = 360.0 - hue_diff3_0;
        float hue_diff3_1 = abs(h - hueCenter3_1);
        if (hue_diff3_1 > 360.0 - hue_diff3_1)
            hue_diff3_1 = 360.0 - hue_diff3_1;
        
        diffBetweenCenters = hueCenter3_1 - hueCenter3_0;
        minDiff2 = hue_diff3_0;
        hueShiftWithMinDiff2 = uniform.hueShift3;
        saturationWithMinDiff2 = uniform.satValue3;
        valueWithMinDiff2 = uniform.brightValue3;
        
        minDiff1 = hue_diff3_1;
        hueShiftWithMinDiff1 = uniform.hueShift3 * secondCenterRatio;
        saturationWithMinDiff1 = uniform.satValue3 * secondCenterRatio;
        valueWithMinDiff1 = uniform.brightValue3 * secondCenterRatio;
    }
    else if(h >= hueCenter3_1 && h <= uniform.hueCenter4)
    {
        float hue_diff3 = abs(h - hueCenter3_1);
        if (hue_diff3 > 360.0 - hue_diff3)
            hue_diff3 = 360.0 - hue_diff3;
        
        float hue_diff4 = abs(h - uniform.hueCenter4);
        if (hue_diff4 > 360.0 - hue_diff4)
            hue_diff4 = 360.0 - hue_diff4;
        
        diffBetweenCenters = uniform.hueCenter4 - hueCenter3_1;
        
        minDiff2 = hue_diff3;
        hueShiftWithMinDiff2 = uniform.hueShift3 * secondCenterRatio;
        saturationWithMinDiff2 = uniform.satValue3 * secondCenterRatio;
        valueWithMinDiff2 = uniform.brightValue3 * secondCenterRatio;
        
        minDiff1 = hue_diff4;
        hueShiftWithMinDiff1 = uniform.hueShift4;
        saturationWithMinDiff1 = uniform.satValue4;
        valueWithMinDiff1 = uniform.brightValue4;
    }
    else if(h >= uniform.hueCenter4 && h <= hueCenter5_0)
    {
        float hue_diff4 = abs(h - uniform.hueCenter4);
        if (hue_diff4 > 360.0 - hue_diff4)
            hue_diff4 = 360.0 - hue_diff4;
        
        float hue_diff5 = abs(h - hueCenter5_0);
        if (hue_diff5 > 360.0 - hue_diff5)
            hue_diff5 = 360.0 - hue_diff5;
        
        diffBetweenCenters = hueCenter5_0 - uniform.hueCenter4;
        
        minDiff1 = hue_diff4;
        hueShiftWithMinDiff1 = uniform.hueShift4;
        saturationWithMinDiff1 = uniform.satValue4;
        valueWithMinDiff1 = uniform.brightValue4;
         
        minDiff2 = hue_diff5;
        hueShiftWithMinDiff2 = uniform.hueShift5;
        saturationWithMinDiff2 = uniform.satValue5;
        valueWithMinDiff2 = uniform.brightValue5;
    }
    else if(h >= hueCenter5_0 && h <= hueCenter5_1)
    {
        float hue_diff5_0 = abs(h - hueCenter5_0);
        if (hue_diff5_0 > 360.0 - hue_diff5_0)
            hue_diff5_0 = 360.0 - hue_diff5_0;
        float hue_diff5_1 = abs(h - hueCenter5_1);
        if (hue_diff5_1 > 360.0 - hue_diff5_1)
            hue_diff5_1 = 360.0 - hue_diff5_1;
        
        diffBetweenCenters = hueCenter5_1 - hueCenter5_0;
        
        minDiff2 = hue_diff5_0;
        hueShiftWithMinDiff2 = uniform.hueShift5;
        saturationWithMinDiff2 = uniform.satValue5;
        valueWithMinDiff2 = uniform.brightValue5;
        
        minDiff1 = hue_diff5_1;
        hueShiftWithMinDiff1 = uniform.hueShift5 * secondCenterRatio;
        saturationWithMinDiff1 = uniform.satValue5 * secondCenterRatio;
        valueWithMinDiff1 = uniform.brightValue5 * secondCenterRatio;
    }
    else if(h >= hueCenter5_1 && h <= uniform.hueCenter6)
    {
        float hue_diff5 = abs(h - hueCenter5_1);
        if (hue_diff5 > 360.0 - hue_diff5)
            hue_diff5 = 360.0 - hue_diff5;
        
        float hue_diff6 = abs(h - uniform.hueCenter6);
        if (hue_diff6 > 360.0 - hue_diff6)
            hue_diff6 = 360.0 - hue_diff6;
        
        diffBetweenCenters = uniform.hueCenter6 - hueCenter5_1;
        
        minDiff2 = hue_diff5;
        hueShiftWithMinDiff2 = uniform.hueShift5 * secondCenterRatio;
        saturationWithMinDiff2 = uniform.satValue5 * secondCenterRatio;
        valueWithMinDiff2 = uniform.brightValue5 * secondCenterRatio;
        
        minDiff1 = hue_diff6;
        hueShiftWithMinDiff1 = uniform.hueShift6;
        saturationWithMinDiff1 = uniform.satValue6;
        valueWithMinDiff1 = uniform.brightValue6;
        
    }
    else if(h >= uniform.hueCenter6 && h <= uniform.hueCenter7)
    {
        float hue_diff6 = abs(h - uniform.hueCenter6);
        if (hue_diff6 > 360.0 - hue_diff6)
            hue_diff6 = 360.0 - hue_diff6;
        float hue_diff7 = abs(h - uniform.hueCenter7);
        if (hue_diff7 > 360.0 - hue_diff7)
            hue_diff7 = 360.0 - hue_diff7;
        diffBetweenCenters = uniform.hueCenter7 - uniform.hueCenter6;
        
        minDiff1 = hue_diff6;
        hueShiftWithMinDiff1 = uniform.hueShift6;
        saturationWithMinDiff1 = uniform.satValue6;
        valueWithMinDiff1 = uniform.brightValue6;
        
        minDiff2 = hue_diff7;
        hueShiftWithMinDiff2 = uniform.hueShift7;
        saturationWithMinDiff2 = uniform.satValue7;
        valueWithMinDiff2 = uniform.brightValue7;
    }
    else if(h >= uniform.hueCenter7 && h <= hueCenter0_0)
    {
        float hue_diff7 = abs(h - uniform.hueCenter7);
        if (hue_diff7 > 360.0 - hue_diff7)
            hue_diff7 = 360.0 - hue_diff7;
        
        float hue_diff0_0 = abs(h - hueCenter0_0);
        if (hue_diff0_0 > 360.0 - hue_diff0_0)
            hue_diff0_0 = 360.0 - hue_diff0_0;
        
        diffBetweenCenters = hueCenter0_0 - uniform.hueCenter7;
        
        minDiff1 = hue_diff7;
        hueShiftWithMinDiff1 = uniform.hueShift7;
        saturationWithMinDiff1 = uniform.satValue7;
        valueWithMinDiff1 = uniform.brightValue7;
        
        minDiff2 = hue_diff0_0;
        hueShiftWithMinDiff2 = uniform.hueShift0;
        saturationWithMinDiff2 = uniform.satValue0;
        valueWithMinDiff2 = uniform.brightValue0;
    }
    else if(h > hueCenter0_0 || h < hueCenter0_1)
    {
        float hue_diff0_0 = abs(h - hueCenter0_0);
        if (hue_diff0_0 > 360.0 - hue_diff0_0)
            hue_diff0_0 = 360.0 - hue_diff0_0;
        
        float hue_diff0_1 = abs(h - hueCenter0_1);
        if (hue_diff0_1 > 360.0 - hue_diff0_1)
            hue_diff0_1 = 360.0 - hue_diff0_1;
        
        diffBetweenCenters = (360.0 - hueCenter0_0) + hueCenter0_1;
        
        minDiff2 = hue_diff0_0;
        hueShiftWithMinDiff2 = uniform.hueShift0;
        saturationWithMinDiff2 = uniform.satValue0;
        valueWithMinDiff2 = uniform.brightValue0;
        
        minDiff1 = hue_diff0_1;
        hueShiftWithMinDiff1 = uniform.hueShift0 * secondCenterRatio;
        saturationWithMinDiff1 = uniform.satValue0 * secondCenterRatio;
        valueWithMinDiff1 = uniform.brightValue0 * secondCenterRatio;
    }
    
    float hueShiftRate = 0.0, saturationRate = 0.0, valueRate = 0.0;
    hueShiftRate = addWeighted(hueShiftWithMinDiff1, minDiff2, hueShiftWithMinDiff2, minDiff1);
    saturationRate =  addWeighted(saturationWithMinDiff1, minDiff2, saturationWithMinDiff2, minDiff1);
    valueRate = addWeighted(valueWithMinDiff1, minDiff2, valueWithMinDiff2, minDiff1);
    return half3(hueShiftRate, saturationRate, valueRate);
    
}
float colorSigmoid(float x)
{
    return 1.0/(1.0+exp(-x));
}
fragment half4 CustomColorShader(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                 texture2d<half> inputTexture2 [[texture(1)]],
                                constant ColorShaderUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler(mag_filter::linear,min_filter::linear);
    float2 tc=fragmentInput.textureCoordinate;
    half4 color = inputTexture.sample(quadSampler, tc);
    
    color.rgb=doFade(color.r, color.g, color.b,uniform.fade*0.8);
    //get rate
    float h = clipInRange01(rgb2hsv(color.rgb).x);
    half3 centerEffect = getHueRate(h,uniform);
    half3 newRate = centerEffect;
    half3 hsv = rgb2hsv(color.rgb);
    
    half newY=inputTexture2.sample(quadSampler,float2(hsv.y, half(newRate.y + 1.0) / 2.0)).r;
    float newSat = scaleDiff(hsv.y, newY, 1.5);
    
    half newZ=inputTexture2.sample(quadSampler,float2(hsv.z, half(newRate.z + 1.0) / 2.0)).r;
    float newBright = scaleDiff(hsv.z, newZ, 1.5);
    
    newSat = clipInRange01(newSat);
    newBright = clipInRange01(newBright);
    
    half3 newhsv = half3(hsv.x, newSat, newBright);
    half blendFactor=colorSigmoid((hsv.y - 0.3) * 10.0);
    newhsv.y = mix(hsv.y, newhsv.y,blendFactor);

    newhsv.z = mix(hsv.z, newhsv.z,hsv.y * hsv.z);
    
    float newHue = newhsv.x;
    newHue = addToNormHue(newHue, uniform.hueShiftAll);
    newHue = addToNormHue(newHue, newRate.x);
    newhsv.x = newHue;
    
    return half4(hsv2rgb(newhsv),color.a);
}

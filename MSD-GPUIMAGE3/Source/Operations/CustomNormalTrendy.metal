//
//  CustomTuneAlllShader.metal
//  Zesty
//
//  Created by ispha on 3/19/20.
//  Copyright © 2020 ispha. All rights reserved.
//
//
#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
    float Intensity;
    float brigtness;
    float saturation;
    float viberance;
    float contrast;
    float shadow;
    float sepia;
    float vignette;
} NormalTrendyUniform;
half3 rgb2hsvTrendy(half3 c)
{
    half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    half4 p = mix(half4(c.bg, K.wz), half4(c.gb, K.xy), step(c.b, c.g));
    half4 q = mix(half4(p.xyw, c.r), half4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return half3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

half3 hsv2rgbTrendy(half3 c)
{
    half4 K = half4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    half3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
half3 TrendyShadow(float r,float g,float b,float shadow)
{
    float colorVal = r;
    if (colorVal < g)
        colorVal = g;
    if (colorVal < b)
        colorVal = b;
    float rate = 0.0;
    if (colorVal > 0.01)
     rate = ( colorVal + (1.0 - colorVal) * (shadow + 0.01) / 2.56 ) / colorVal;
    if (rate > 2.5)
        rate = 2.5;
    r = r * rate;
    g = g * rate;
    b = b * rate;
    return half3(r,g,b);
}
half4 NormalTrendyVigentte(float intensity,float h,float w,half4 color,float2 tc)
{
    float outterValue=intensity;
    float innerValue=0;
    float trans=0.5;
    float a=0.7;
    float b=0.7;
    float centerY=0.5;
    float centerX=0.5;
    float angle=0;
    float X = ((tc.x - centerX) * (h / w) * cos(angle)) -((tc.y - centerY)* sin(angle));
    float Y = ((tc.x - centerX) * (h / w) * sin(angle)) +((tc.y - centerY) * cos(angle));

    float radius = sqrt(pow(X /b,2)+pow(Y /a,2));
    if(a<0.01||b<0.01)
        radius=2.00;
    trans=(1.0-trans)*23.0+2.0;
    float distance_factor =1/(1.0+exp(-trans*(radius - 1.0)));
    float outerIntensity=outterValue;
    float innerIntensity=innerValue;
    float outterFade = distance_factor*outerIntensity;
    float innerFade = (1.0 - distance_factor)*innerIntensity;
    float fade = innerFade*sqrt(abs(innerFade))*0.3 + outterFade*sqrt(abs(outterFade))*0.6;
    float newFactor = fade;
    half4 newColor = half4(color.rgb+ newFactor, color.a);
    return newColor;
}
fragment half4 NormalTrendyFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                texture2d<half> inputTexture2 [[texture(1)]],
                                
                                constant NormalTrendyUniform& uniform [[ buffer(1) ]])
{

    
    
    float brightness=uniform.brigtness*uniform.Intensity;
    float saturation=uniform.saturation*uniform.Intensity;
    float viberance=uniform.viberance*uniform.Intensity;
    float contrast=uniform.contrast*uniform.Intensity;
    float shadow=uniform.shadow*uniform.Intensity;
    float sepia=uniform.sepia*uniform.Intensity;
    
    float vignettIntensity=uniform.vignette*uniform.Intensity;
    
    //float distance_factor = 1/(1+exp(-7.0 * (fragmentInput.textureCoordinate.y - 0.6)));//sigmoid
    
    constexpr sampler quadSampler(mag_filter::linear,min_filter::linear);
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    //brightness
   
    float r=inputTexture2.sample(quadSampler,float2(color.r, (brightness + 1.0) / 2.0)).r;
    float g=inputTexture2.sample(quadSampler,float2(color.g, (brightness + 1.0) / 2.0)).r;
    float b=inputTexture2.sample(quadSampler,float2(color.b, (brightness + 1.0) / 2.0)).r;
    
    half4 newColor=half4(r,g,b,color.a);
    
    //contrast
    r=inputTexture2.sample(quadSampler,float2(r, (contrast + 1.0) / 2.0)).g;
    g=inputTexture2.sample(quadSampler,float2(g, (contrast + 1.0) / 2.0)).g;
    b=inputTexture2.sample(quadSampler,float2(b, (contrast + 1.0) / 2.0)).g;
    newColor=half4(r,g,b,color.a);

    
    //saturation
    float lum = 0.299 * float(r) + 0.587 * float(g) + 0.114 * float(b);
    float slope_b = (lum - b) / -1.0;
    b = (slope_b * saturation + b);
    float slope_g = (lum - g) / -1.0;
    g = (slope_g * saturation + g);
    float slope_r = (lum - r) / -1.0;
    r = (slope_r * saturation + r);
    newColor.rgb=half3(r,g,b);
    
    //viberance
    half3 hsv=rgb2hsvTrendy(newColor.rgb);
    hsv.g=inputTexture2.sample(quadSampler,float2(hsv.g, (viberance + 1.0) / 2.0)).r;
    newColor.rgb=hsv2rgbTrendy(hsv);
    
    //shadow
    newColor.rgb=TrendyShadow(newColor.r,newColor.g,newColor.b,shadow);
    
    //sepia
    float tr = 0.393*newColor.r + 0.769*newColor.g + 0.189*newColor.b;
    float tg = 0.349*newColor.r + 0.686*newColor.g + 0.168*newColor.b;
    float tb = 0.272*newColor.r + 0.534*newColor.g + 0.131*newColor.b;
    newColor.r=sepia*tr + (1.0-sepia)*newColor.r;
    newColor.g=sepia*tg + (1.0-sepia)*newColor.g;
    newColor.b=sepia*tb + (1.0-sepia)*newColor.b;
    
    //vignette
    float2 tc=fragmentInput.textureCoordinate;
    float h=1.0/inputTexture.get_height();
    float w=1.0/inputTexture.get_width();
    newColor=NormalTrendyVigentte(vignettIntensity, h, w, newColor, tc);
    
    //return inputTexture2.sample(quadSampler, fragmentInput.textureCoordinate);
  return newColor;
}

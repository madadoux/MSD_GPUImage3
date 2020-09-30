//
// CustomTuneAlllShader.metal
// Zesty
//
// Created by ispha on 3/19/20.
// Copyright © 2020 ispha. All rights reserved.
//
#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
  float brightness;
  float saturation;
  float shadow;
  float vibrance;
  float contrast;
} TuneAllUniform;
half3 doShadow(float r,float g,float b,float shadow)
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
half3 rgb2hsvTune(half3 c)
{
    half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    half4 p = mix(half4(c.bg, K.wz), half4(c.gb, K.xy), step(c.b, c.g));
    half4 q = mix(half4(p.xyw, c.r), half4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return half3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

half3 hsv2rgbTune(half3 c)
{
    half4 K = half4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    half3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
fragment half4 tuneAllFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                texture2d<half> inputTexture [[texture(0)]],
                texture2d<half> inputTexture2 [[texture(1)]],
                constant TuneAllUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler(mag_filter::linear,min_filter::linear);
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    //brightness
    float r=inputTexture2.sample(quadSampler,float2(color.r, (uniform.brightness + 1.0) / 2.0)).r;
    float g=inputTexture2.sample(quadSampler,float2(color.g, (uniform.brightness + 1.0) / 2.0)).r;
    float b=inputTexture2.sample(quadSampler,float2(color.b, (uniform.brightness + 1.0) / 2.0)).r;
    color.rgb=half3(r,g,b);
    
    //contrast
    r=inputTexture2.sample(quadSampler,float2(color.r, (uniform.contrast + 1.0) / 2.0)).g;
    g=inputTexture2.sample(quadSampler,float2(color.g, (uniform.contrast + 1.0) / 2.0)).g;
    b=inputTexture2.sample(quadSampler,float2(color.b, (uniform.contrast + 1.0) / 2.0)).g;
    color.rgb=half3(r,g,b);
  
    //saturation
    float lum = 0.299 * float(r) + 0.587 * float(g) + 0.114 * float(b);
    float slope_b = (lum - b) / -1.0;
    b = (slope_b * uniform.saturation + b);
    float slope_g = (lum - g) / -1.0;
    g = (slope_g * uniform.saturation + g);
    float slope_r = (lum - r) / -1.0;
    r = (slope_r * uniform.saturation + r);
    color.rgb=half3(r,g,b);
    
    //viberance
    half3 hsv=rgb2hsvTune(color.rgb);
    hsv.g=inputTexture2.sample(quadSampler,float2(hsv.g, (uniform.vibrance + 1.0) / 2.0)).r;
    color.rgb=hsv2rgbTune(hsv);
    //shadow
    color.rgb=doShadow(color.r,color.g,color.b,uniform.shadow);
       
    return color;
}

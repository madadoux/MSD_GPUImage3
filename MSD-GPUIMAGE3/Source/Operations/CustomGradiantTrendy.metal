
#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;
typedef struct
{
    float Intensity;
    float variation;
} GradientTrendyUniform;

half3 GradientTrendyShadow(float r,float g,float b,float shadow)
{
    float colorVal = r;
    if (colorVal < g)
        colorVal = g;
    if (colorVal < b)
        colorVal = b;
    float rate = 0.0;
    if (colorVal > 0.01)
     rate = ( colorVal + (1.0 - colorVal) * (shadow + 0.01) / 2.56 ) / colorVal;
    if (rate > 2)
        rate = 2;
    r = r * rate;
    g = g * rate;
    b = b * rate;
    return half3(r,g,b);
}
half4 vigentte(float intensity,float h,float w,half4 color,float2 tc)
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
fragment half4 GradientTrendyFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]],
                                texture2d<half> inputTexture2 [[texture(1)]],
                                constant GradientTrendyUniform& uniform [[ buffer(1) ]])
{
    float parameters1[10][6]={
        {0,0,.18,1,0.57,0.13},
        {0,0,0.65,1,0.7,0.55},
        {-1,0,0.69,0,-1,-0.11},
        {-1,0.3,0,0.1,0,0.1},
        {0,1,0,0,0,0},
        {0,0,0.7,0.7,-1,0.7},
        {-1,0,0.69,0,-1,-0.11},
        {-1,0,0.6,1,-1,0.7},
        {0,0,0.65,1,0.7,0.55},
        {0,0,0,1,1,0.5}
    };
 
    float parameters2[10][6]={
        {-1,0,0.69,0,-1,-0.11},
        {-1,0,0.6,1,-1,0.7},
        {0,0,0.7,0.7,-1,0.7},
        {0,1,0,0,0,0},
        {0,0,0.57,0,0.15,0.65},
        {-1,0.3,0,0.1,0,0.1},
        {0,0,0,1,1,0.5},
        {0,0,.18,1,0.57,0.13},
        {-1,0,0.6,1,-1,0.7},
        {0,0,0.7,0.7,-1,0.7}
    };
    float parameters3[10][6]={
        {0,0,0.57,0,0.15,0.65},
        {0,0,0.8,0,-1,0.8},
        {0,0,0,1,1,0.5},
        {-1,0,0.6,1,-1,0.7},
        {-1,0,0.69,0,-1,-0.11},
        {0,0,0.7,0.7,-1,0.7},
        {0,0,.18,1,0.57,0.13},
        {-1,0.3,0,0.1,0,0.1},
        {0,0,0.65,1,0.7,0.55},
        {0,0,0,1,1,0.5}
        
    };
    float parameters4[10][6]={
        {0,0,0,1,1,0.5},
        {0,0,0.7,0.7,-1,0.7},
        {0,1,0,0,0,0},
        {-1,0,0.69,0,-1,-0.11},
        {0,0,0.8,0,-1,0.8},
        {0,0,0,1,1,0.5},
        {0,0,0.8,0,-1,0.8},
        {0,0,0.65,1,0.7,0.55},
        {-1,0,0.6,1,-1,0.7},
        {0,0,0.7,0.7,-1,0.7}
    };
    
    float2 tc=fragmentInput.textureCoordinate;
    float vignetteParams[10]={0,0,0,0,0,0,0,0,0,0};
    
    
    float brightness=
    (parameters1[int(uniform.variation)][5]*uniform.Intensity)*tc.x*(1-tc.y)+
    (parameters2[int(uniform.variation)][5]*uniform.Intensity)*(1-tc.x)*(1-tc.y)+
    (parameters3[int(uniform.variation)][5]*uniform.Intensity)*(1-tc.x)*tc.y+
    (parameters4[int(uniform.variation)][5]*uniform.Intensity)*tc.x*tc.y;
    brightness=0;
    
    float saturation=
    (parameters1[int(uniform.variation)][0]*uniform.Intensity)*tc.x*(1-tc.y)+
    (parameters2[int(uniform.variation)][0]*uniform.Intensity)*(1-tc.x)*(1-tc.y)+
    (parameters3[int(uniform.variation)][0]*uniform.Intensity)*(1-tc.x)*tc.y+
    (parameters4[int(uniform.variation)][0]*uniform.Intensity)*tc.x*tc.y+1;
    if(saturation>2)
        saturation=2;
    else if(saturation<0)
        saturation=0;
    
    float viberance=
    (parameters1[int(uniform.variation)][2]*2*uniform.Intensity)*tc.x*(1-tc.y)+
    (parameters2[int(uniform.variation)][2]*2*uniform.Intensity)*(1-tc.x)*(1-tc.y)+
    (parameters3[int(uniform.variation)][2]*2*uniform.Intensity)*(1-tc.x)*tc.y+
    (parameters4[int(uniform.variation)][2]*2*uniform.Intensity)*tc.x*tc.y;
    
    float contrast=
    (parameters1[int(uniform.variation)][3]*0.5*uniform.Intensity)*tc.x*(1-tc.y)+
    (parameters2[int(uniform.variation)][3]*0.5*uniform.Intensity)*(1-tc.x)*(1-tc.y)+
    (parameters3[int(uniform.variation)][3]*0.5*uniform.Intensity)*(1-tc.x)*tc.y+
    (parameters4[int(uniform.variation)][3]*0.5*uniform.Intensity)*tc.x*tc.y+1;
    if(contrast>1.5)
        contrast=1.5;
    else if(contrast<0.5)
        contrast=0.5;
    
    float shadow=
    (parameters1[int(uniform.variation)][4]*uniform.Intensity)*tc.x*(1-tc.y)+
    (parameters2[int(uniform.variation)][4]*uniform.Intensity)*(1-tc.x)*(1-tc.y)+
    (parameters3[int(uniform.variation)][4]*uniform.Intensity)*(1-tc.x)*tc.y+
    (parameters4[int(uniform.variation)][4]*uniform.Intensity)*tc.x*tc.y;
    
    float sepia=
    (parameters1[int(uniform.variation)][1]*uniform.Intensity)*tc.x*(1-tc.y)+
    (parameters2[int(uniform.variation)][1]*uniform.Intensity)*(1-tc.x)*(1-tc.y)+
    (parameters3[int(uniform.variation)][1]*uniform.Intensity)*(1-tc.x)*tc.y+
    (parameters4[int(uniform.variation)][1]*uniform.Intensity)*tc.x*tc.y;
    
    float vignettIntensity=vignetteParams[int(uniform.variation)]*uniform.Intensity;
    
    
    
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    //brightness
    half4 newColor=color;
    
    //saturation
    half luminance = dot(newColor.rgb, luminanceWeighting);
    newColor= half4(mix(half3(luminance), newColor.rgb, half(saturation)), color.a);
    
    //viberance
    half average = (newColor.r + newColor.g + newColor.b) / 3.0;
    half mx = max(newColor.r, max(newColor.g, newColor.b));
    half amt = (mx - average) * (-viberance * 3.0);
    newColor.rgb = mix(newColor.rgb, half3(mx), amt);
    

    
    //shadow
    newColor.rgb=GradientTrendyShadow(newColor.r,newColor.g,newColor.b,shadow);
    
    //contrast
    newColor = half4(((newColor.rgb - half3(0.5)) * contrast + half3(0.5)), color.a);
    
    //sepia
    float tr = 0.393*newColor.r + 0.769*newColor.g + 0.189*newColor.b;
    float tg = 0.349*newColor.r + 0.686*newColor.g + 0.168*newColor.b;
    float tb = 0.272*newColor.r + 0.534*newColor.g + 0.131*newColor.b;
    newColor.r=sepia*tr + (1.0-sepia)*newColor.r;
    newColor.g=sepia*tg + (1.0-sepia)*newColor.g;
    newColor.b=sepia*tb + (1.0-sepia)*newColor.b;
    
    //vignette
    float h=1.0/inputTexture.get_height();
    float w=1.0/inputTexture.get_width();
    newColor=vigentte(vignettIntensity, h, w, newColor, tc);
    
    
//    half3 newColor2=
//    half3(0.5,0,0)*tc.x*(1-tc.y)+
//    half3(123/255.0,128/255.0,0)*(1-tc.x)*(1-tc.y)+
//    half3(0,0,128/255.0)*(1-tc.x)*tc.y+
//    half3(64/255.0,128/255.0,0)*tc.x*tc.y;
    return newColor;
}

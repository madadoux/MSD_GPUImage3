// Sourced from Kyprianidis, J. E., Kang, H., and Doellner, J. "Anisotropic Kuwahara Filtering on the GPU," GPU Pro p.247 (2010).
//
// Original header:
//
// Anisotropic Kuwahara Filtering on the GPU
// by Jan Eric Kyprianidis <www.kyprianidis.com>

#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;

constant float2 src_size = float2(1.0 / 768.0, 1.0 / 1024.0);

fragment half4 kuwaharaRadius3Fragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<half> inputTexture [[texture(0)]])
{
    constexpr sampler quadSampler;
    float2 textureCoordinateToUse = fragmentInput.textureCoordinate;
    float n = 16.0; // radius is assumed to be 3
    float3 m0 = float3(0.0);
    float3 m1 = float3(0.0);
    float3 m2 = float3(0.0);
    float3 m3 = float3(0.0);
    
    float3 s0 = float3(0.0);
    float3 s1 = float3(0.0);
    float3 s2 = float3(0.0);
    float3 s3 = float3(0.0);
    
    float3 c;
    float3 cSq;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-3.0,-3.0) * src_size).rgb);
    m0 += c;
    s0 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-3.0,-2.0) * src_size).rgb);
    m0 += c;
    s0 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-3.0,-1.0) * src_size).rgb);
    m0 += c;
    s0 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-3.0,0.0) * src_size).rgb);
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m1 += c;
    s1 += cSq;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-2.0,-3.0) * src_size).rgb);
    m0 += c;
    s0 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-2.0,-2.0) * src_size).rgb);
    m0 += c;
    s0 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-2.0,-1.0) * src_size).rgb);
    m0 += c;
    s0 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-2.0,0.0) * src_size).rgb);
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m1 += c;
    s1 += cSq;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-1.0,-3.0) * src_size).rgb);
    m0 += c;
    s0 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-1.0,-2.0) * src_size).rgb);
    m0 += c;
    s0 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-1.0,-1.0) * src_size).rgb);
    m0 += c;
    s0 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-1.0,0.0) * src_size).rgb);
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m1 += c;
    s1 += cSq;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(0.0,-3.0) * src_size).rgb);
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m3 += c;
    s3 += cSq;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(0.0,-2.0) * src_size).rgb);
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m3 += c;
    s3 += cSq;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(0.0,-1.0) * src_size).rgb);
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m3 += c;
    s3 += cSq;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(0.0,0.0) * src_size).rgb);
    cSq = c * c;
    m0 += c;
    s0 += cSq;
    m1 += c;
    s1 += cSq;
    m2 += c;
    s2 += cSq;
    m3 += c;
    s3 += cSq;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-3.0,3.0) * src_size).rgb);
    m1 += c;
    s1 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-3.0,2.0) * src_size).rgb);
    m1 += c;
    s1 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-3.0,1.0) * src_size).rgb);
    m1 += c;
    s1 += c * c;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-2.0,3.0) * src_size).rgb);
    m1 += c;
    s1 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-2.0,2.0) * src_size).rgb);
    m1 += c;
    s1 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-2.0,1.0) * src_size).rgb);
    m1 += c;
    s1 += c * c;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-1.0,3.0) * src_size).rgb);
    m1 += c;
    s1 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-1.0,2.0) * src_size).rgb);
    m1 += c;
    s1 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(-1.0,1.0) * src_size).rgb);
    m1 += c;
    s1 += c * c;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(0.0,3.0) * src_size).rgb);
    cSq = c * c;
    m1 += c;
    s1 += cSq;
    m2 += c;
    s2 += cSq;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(0.0,2.0) * src_size).rgb);
    cSq = c * c;
    m1 += c;
    s1 += cSq;
    m2 += c;
    s2 += cSq;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(0.0,1.0) * src_size).rgb);
    cSq = c * c;
    m1 += c;
    s1 += cSq;
    m2 += c;
    s2 += cSq;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(3.0,3.0) * src_size).rgb);
    m2 += c;
    s2 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(3.0,2.0) * src_size).rgb);
    m2 += c;
    s2 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(3.0,1.0) * src_size).rgb);
    m2 += c;
    s2 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(3.0,0.0) * src_size).rgb);
    cSq = c * c;
    m2 += c;
    s2 += cSq;
    m3 += c;
    s3 += cSq;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(2.0,3.0) * src_size).rgb);
    m2 += c;
    s2 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(2.0,2.0) * src_size).rgb);
    m2 += c;
    s2 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(2.0,1.0) * src_size).rgb);
    m2 += c;
    s2 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(2.0,0.0) * src_size).rgb);
    cSq = c * c;
    m2 += c;
    s2 += cSq;
    m3 += c;
    s3 += cSq;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(1.0,3.0) * src_size).rgb);
    m2 += c;
    s2 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(1.0,2.0) * src_size).rgb);
    m2 += c;
    s2 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(1.0,1.0) * src_size).rgb);
    m2 += c;
    s2 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(1.0,0.0) * src_size).rgb);
    cSq = c * c;
    m2 += c;
    s2 += cSq;
    m3 += c;
    s3 += cSq;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(3.0,-3.0) * src_size).rgb);
    m3 += c;
    s3 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(3.0,-2.0) * src_size).rgb);
    m3 += c;
    s3 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(3.0,-1.0) * src_size).rgb);
    m3 += c;
    s3 += c * c;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(2.0,-3.0) * src_size).rgb);
    m3 += c;
    s3 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(2.0,-2.0) * src_size).rgb);
    m3 += c;
    s3 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(2.0,-1.0) * src_size).rgb);
    m3 += c;
    s3 += c * c;
    
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(1.0,-3.0) * src_size).rgb);
    m3 += c;
    s3 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(1.0,-2.0) * src_size).rgb);
    m3 += c;
    s3 += c * c;
    c = float3(inputTexture.sample(quadSampler, textureCoordinateToUse + float2(1.0,-1.0) * src_size).rgb);
    m3 += c;
    s3 += c * c;
    
    float min_sigma2 = 100;
    m0 /= n;
    s0 = abs(s0 / n - m0 * m0);
    
    float sigma2 = s0.r + s0.g + s0.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        return half4(half3(m0), 1.0);
    }
    
    m1 /= n;
    s1 = abs(s1 / n - m1 * m1);
    
    sigma2 = s1.r + s1.g + s1.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        return half4(half3(m1), 1.0);
    }
    
    m2 /= n;
    s2 = abs(s2 / n - m2 * m2);
    
    sigma2 = s2.r + s2.g + s2.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        return half4(half3(m2), 1.0);
    }
    
    m3 /= n;
    s3 = abs(s3 / n - m3 * m3);
    
    sigma2 = s3.r + s3.g + s3.b;
    if (sigma2 < min_sigma2) {
        min_sigma2 = sigma2;
        return half4(half3(m3), 1.0);
    }
}

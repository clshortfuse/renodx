#include "./shared.h"

// Scope and Magic Overlay
sampler2D ActualFrameSampler : register(s0);
float4    g_Color             : register(c1);
float     g_Value             : register(c0);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
    // --- centered UV ---
    float2 centeredUV = texcoord - 0.5;

    // --- doubled UV (for log) ---
    float2 doubleUV = texcoord + texcoord;

    // --- inverted offset ---
    float2 invOffset = -centeredUV + 0.5;

    // --- log values ---
    float2 logDouble = log2(doubleUV);
    float2 logOffset = log2(invOffset * 2.0);

    // --- scale with g_Value ---
    float2 scaledCenter = g_Value * float2(0.6, 0.2) + 1.0;

    logDouble *= scaledCenter.x;
    logOffset *= scaledCenter.x;

    // --- exp ---
    float2 expDouble = exp2(logDouble);
    float2 expOffset = exp2(logOffset);

    // --- saturate multiply/add ---
    expDouble = saturate(expDouble * 0.5);
    expOffset = saturate(expOffset * -0.5 + 1.0);

    // --- quadrant select ---
    float2 sampleUV;
    sampleUV.x = (centeredUV.x >= 0.0) ? expOffset.x : expDouble.x;
    sampleUV.y = (centeredUV.y >= 0.0) ? expOffset.y : expDouble.y;

    // --- squared distance for vignette ---
    float2 sq = abs(centeredUV);
    sq = sq * sq;
    float dist = sq.x + sq.y;
    dist = 1.0 / sqrt(dist);
    dist = 1.0 / dist;
    dist = -dist + 1.0;
    dist *= 1.2;

    // --- sample texture ---
    float4 texSample = tex2D(ActualFrameSampler, sampleUV);

    // --- luminance ---
    float lum = dot(texSample.rgb, float3(0.2126, 0.7152, 0.0722));

    // --- vignette scaled ---
    float vignette = dist * dist;
    float blend = -vignette + 1.0;
    blend *= g_Value;

    // --- lerp texture with luminance ---
    float4 lerpSample = lerp(texSample, float4(lum, lum, lum, 0), -g_Value * 0.5);

    float4 final = 0.f;
    // --- lerp final with scope color ---
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      final = lerp(lerpSample, g_Color, blend);
    } else {
      final = lerp(texSample, g_Color, blend);
    }
	
    // --- apply minor scale/offset ---
    float scale = g_Value * -0.1 + 1.0;
    final = final * scale;
    //final += float4(0.0, 0.0, 0.0, 0.0);
    //final += -0.5;
    //final = final * 1.0 + 0.5;

    return final;
}

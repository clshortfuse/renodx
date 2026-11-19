#include "./shared.h"
// Horizontal bloom blur/composite, reconstructed from the stock 0xD5228145
// disassembly retrieved through RenoDX DevKit. Its vertical pair is 0x61E356D5.
// c5/c6 are HDR desaturation/tint controls; c7-c11 and c20-c30 are blur taps.
// Preserve all 32 authored taps, the scene sample, and scene alpha.
// This shader is NOT the luminance-threshold/mask pass.

sampler2D bloomSampler : register(s0);
sampler2D colorSampler : register(s1);

float4 hdrControl0 : register(c5);
float4 hdrControl1 : register(c6);

float4 postFxControl0 : register(c7);
float4 postFxControl1 : register(c8);
float4 postFxControl2 : register(c9);
float4 postFxControl3 : register(c10);
float4 postFxControl4 : register(c11);
float4 postFxControl5 : register(c20);
float4 postFxControl6 : register(c21);
float4 postFxControl7 : register(c22);
float4 postFxControl8 : register(c23);
float4 postFxControl9 : register(c24);
float4 postFxControlA : register(c25);
float4 postFxControlB : register(c26);
float4 postFxControlC : register(c27);
float4 postFxControlD : register(c28);
float4 postFxControlE : register(c29);
float4 postFxControlF : register(c30);

struct PS_INPUT
{
    float2 texcoord : TEXCOORD0;
};

float3 SampleWeightedBloom(float2 texcoord, float4 blurControl, float direction)
{
    texcoord.x += direction * blurControl.w * (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_VANILLA ? 1.0f : lerp(0.25f, 0.80f, saturate(RENODX_BLOOM_FLARE_SIZE)));
    return tex2D(bloomSampler, texcoord).rgb * blurControl.rgb;
}

float4 main(PS_INPUT input) : COLOR0
{
    float3 blurredBloom = 0.0f;

    // Negative side. The unusual E/F/D ordering matches the original bytecode.
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlE, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlF, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlD, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlC, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlB, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlA, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl9, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl8, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl7, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl6, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl5, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl4, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl3, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl2, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl1, -1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl0, -1.0f);

    // Positive side.
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl0, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl1, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl2, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl3, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl4, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl5, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl6, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl7, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl8, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControl9, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlA, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlB, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlC, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlD, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlE, 1.0f);
    blurredBloom += SampleWeightedBloom(input.texcoord, postFxControlF, 1.0f);

    float bloomLuminance = dot(blurredBloom, hdrControl0.rgb);
    float3 treatedBloom = lerp(bloomLuminance.xxx, blurredBloom, hdrControl0.w);
    float4 sceneColor = tex2D(colorSampler, input.texcoord);
    return float4(sceneColor.rgb + treatedBloom * hdrControl1.rgb, sceneColor.a);
}

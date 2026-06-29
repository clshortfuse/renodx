#include "./shared.h"

float4 CBBloomFilter__packed0 : register(c9);
sampler2D SSFilter__tBaseMap : register(s0);
sampler2D SSLinear__tFilterTempMap2 : register(s3);
sampler2D SSPoint__tColorCorrectTableMap : register(s4);
sampler2D SSWrapPoint__tTVNoiseMap : register(s1);
sampler2D SSWrapPoint__tTVNoiseMaskMap : register(s2);
float4 fColorCorrectColor : register(c10);
float4x4 fColorCorrectMatrix : register(c1);
float4 fTVNoiseHVSync : register(c8);
float4 fTVNoisePower : register(c5);
float4 fTVNoiseScanline : register(c7);
float2 fTVNoiseUVOffset : register(c6);

struct PS_IN
{
    float2 texcoord : TEXCOORD;
    float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
    float4 o;

    float4 r0;
    float4 r1;
    float4 r2;
    float4 r3;
    float3 r4;

    r0.zw = fTVNoisePower.zw;
    r0 = i.texcoord1.xyxy * r0.zzww + fTVNoiseUVOffset.xyxy;
    r1 = tex2D(SSWrapPoint__tTVNoiseMap, r0);

    // Do not early-return here.
    // Returning SSFilter__tBaseMap skips the game's color correction path.
    // r1 = tex2D(SSFilter__tBaseMap, i.texcoord);
    // return r1;

    r0 = tex2D(SSWrapPoint__tTVNoiseMap, r0.zwzw);
    r0.xy = r0.yz + -0.5;
    r0.z = r1.x + -0.5;
    r0.w = 1;

    r1.x = r0.w + fTVNoiseHVSync.z;
    r0.xyz = r0.xyz * r1.x;

    r1 = tex2D(SSFilter__tBaseMap, i.texcoord);

    // sRGB to linear
    r2.xyz = r1.xyz + 0.055;
    r2.xyz = r2.xyz * 0.9478673;
    r1.w = pow(r2.x, 2.4);
    r3.xyz = -r1.xyz + 0.03928;
    r1.xyz = r1.xyz * 0.07739938;

    r4.x = (r3.x >= 0) ? r1.x : r1.w;
    r1.x = pow(r2.y, 2.4);
    r1.w = pow(r2.z, 2.4);
    r4.y = (r3.y >= 0) ? r1.y : r1.x;
    r4.z = (r3.z >= 0) ? r1.z : r1.w;

    // TV noise / scanline color math
    r1.x = dot(r4.xyz, float3(0.299, 0.587, 0.114));
    r1.x = fTVNoisePower.x * r0.z + r1.x;
    r0.z = dot(r4.zxy, float3(0.5, -0.169, -0.331));
    r1.w = dot(r4.xyz, float3(0.5, -0.419, -0.081));
    r1.z = fTVNoisePower.y * r0.y + r1.w;
    r1.y = fTVNoisePower.y * r0.x + r0.z;

    r0.y = dot(r1.xyz, float3(1, -0.344, -0.714));
    r0.z = r1.x + r1.y * 1.772;
    r0.x = r1.x + r1.z * 1.402;

    r1.xy = fTVNoiseScanline.z * i.texcoord1.xy;
    r1 = tex2D(SSWrapPoint__tTVNoiseMaskMap, r1);
    r1.x = -r1.x + 1;
    r0.w = r1.x * -fTVNoiseScanline.y + r0.w;
    r0.xyz = r0.w * r0.xyz;

    /*
    // Bloom texture sample.
    // Keep the sample so register usage/order stays close to the original.
    r1 = tex2D(SSLinear__tFilterTempMap2, i.texcoord);

    r2.xyz = r1.xyz + 0.055;
    r2.xyz = r2.xyz * 0.9478673;
    r0.w = pow(r2.x, 2.4);
    r3.xyz = -r1.xyz + 0.03928;
    r1.xyz = r1.xyz * 0.07739938;

    r4.x = (r3.x >= 0) ? r1.x : r0.w;
    r0.w = pow(r2.y, 2.4);
    r1.x = pow(r2.z, 2.4);
    r4.z = (r3.z >= 0) ? r1.z : r1.x;
    r4.y = (r3.y >= 0) ? r1.y : r0.w;

    // Original bloom combine was:
    // r0.xyz = r4.xyz * CBBloomFilter__packed0.xyz + r0.xyz;
    //
    // Bloom disabled:
    r0.xyz = r0.xyz;
    */

    // Game color-correction matrix
    r1.xyz = r0.y * fColorCorrectMatrix[1].xyz;
    r1.xyz = r0.x * fColorCorrectMatrix[0].xyz + r1.xyz;
    r1.xyz = r0.z * fColorCorrectMatrix[2].xyz + r1.xyz;
    r1.xyz = r1.xyz + fColorCorrectMatrix[3].xyz;

    // LUT/color-correction table
    r2 = tex2D(SSPoint__tColorCorrectTableMap, r1.x);
    r0.w = r2.x + 0.055;
    r0.w = r0.w * 0.9478673;
    r1.x = pow(r0.w, 2.4);
    r0.w = -r2.x + 0.03928;
    r1.w = r2.x * 0.07739938;
    r2.x = (r0.w >= 0) ? r1.w : r1.x;

    r3 = tex2D(SSPoint__tColorCorrectTableMap, r1.y);
    r1 = tex2D(SSPoint__tColorCorrectTableMap, r1.z);

    r0.w = r3.y + 0.055;
    r0.w = r0.w * 0.9478673;
    r1.x = pow(r0.w, 2.4);
    r0.w = -r3.y + 0.03928;
    r1.y = r3.y * 0.07739938;
    r2.y = (r0.w >= 0) ? r1.y : r1.x;

    r0.w = r1.z + 0.055;
    r0.w = r0.w * 0.9478673;
    r1.x = pow(r0.w, 2.4);
    r0.w = -r1.z + 0.03928;
    r1.y = r1.z * 0.07739938;
    r2.z = (r0.w >= 0) ? r1.y : r1.x;

    // ------------------------------------------------------------
    // Two-pass LUT blend
    // ------------------------------------------------------------
    //
    // r0.xyz = pre-LUT color
    // r2.xyz = full LUT-graded color
    //
    // Pass 1:
    // Low-pass the LUT result so the LUT does not reshape contrast/color
    // too harshly.
    //
    // Pass 2:
    // Recover hue/chroma direction from the full LUT in a perceptual-ish
    // sqrt RGB + YCoCg-like space. This helps keep highlight hues from
    // getting washed out by the low-pass.

    const float LUT_LOW_PASS_STRENGTH = 0.35;
    const float LUT_HUE_RESTORE_STRENGTH = 0.75;
    const float CHROMA_EPSILON = 0.00001;

    float lutStrength =
        fColorCorrectColor.w *
        RENODX_COLOR_GRADE_STRENGTH *
        LUT_LOW_PASS_STRENGTH;

    float3 lutFull = max(r2.xyz, 0.0);
    float3 lutLow = max(r0.xyz + (r2.xyz - r0.xyz) * lutStrength, 0.0);

    // Perceptual-ish encoding.
    // sqrt(linear) is cheaper and safer than a full Lab/OKLab conversion
    // for ps_3_0, while still behaving better than direct linear RGB hue math.
    float3 pLow = sqrt(max(lutLow, 0.0));
    float3 pFull = sqrt(max(lutFull, 0.0));

    // YCoCg-like opponent space
    float yLow = dot(pLow, float3(0.25, 0.50, 0.25));
    float coLow = pLow.r - pLow.b;
    float cgLow = pLow.g - yLow;

    float yFull = dot(pFull, float3(0.25, 0.50, 0.25));
    float coFull = pFull.r - pFull.b;
    float cgFull = pFull.g - yFull;

    float chromaLow = sqrt(coLow * coLow + cgLow * cgLow);
    float chromaFull = sqrt(coFull * coFull + cgFull * cgFull);

    // Hue direction from the full LUT.
    float2 fullHueDir = float2(coFull, cgFull) / max(chromaFull, CHROMA_EPSILON);

    // Chroma amount is blended between low-passed chroma and full LUT chroma.
    float restoredChroma = lerp(chromaLow, chromaFull, LUT_HUE_RESTORE_STRENGTH);

    // Avoid injecting strong hue into near-neutral areas.
    float hueMask = saturate(chromaFull * 32.0);

    float2 lowChromaVec = float2(coLow, cgLow);
    float2 restoredChromaVec = fullHueDir * restoredChroma;

    float2 finalChromaVec =
        lerp(lowChromaVec, restoredChromaVec, hueMask * LUT_HUE_RESTORE_STRENGTH);

    // Reconstruct perceptual-ish RGB using the low-passed luminance.
    float Y = yLow;
    float Co = finalChromaVec.x;
    float Cg = finalChromaVec.y;

    float3 pFinal;
    pFinal.g = Y + Cg;
    pFinal.r = Y - 0.5 * Cg + 0.5 * Co;
    pFinal.b = Y - 0.5 * Cg - 0.5 * Co;

    // Back to linear.
    r1.xyz = max(pFinal * pFinal, 0.0);

    // ------------------------------------------------------------
    // Custom color changes
    // ------------------------------------------------------------
    // I left these enabled because they were in your pasted file.
    // For testing the two-pass LUT cleanly, you may want to temporarily
    // comment this block out.

    {
        // Saturation boost
        float lum = dot(r1.xyz, float3(0.299, 0.587, 0.114));
        r1.xyz = lerp(lum.xxx, r1.xyz, 1.15);

        // Mild warm tint
        r1.xyz *= float3(1.25, 1.10, 0.93);

        // Contrast boost
        const float contrast = 1.003;
        r1.xyz = (r1.xyz - 0.5) * contrast + 0.5;
    }

    r1.xyz = max(r1.xyz, 0.0);

    // Linear to sRGB
    r0.x = pow(r1.x, 0.41666666);
    r0.x = r0.x * 1.055 + -0.055;
    r0.yzw = -r1.xyz + 0.003131;
    r2.xyz = r1.xyz * 12.92;

    o.x = (r0.y >= 0) ? r2.x : r0.x;

    r0.x = pow(r1.y, 0.41666666);
    r0.y = pow(r1.z, 0.41666666);

    r0.y = r0.y * 1.055 + -0.055;
    r0.x = r0.x * 1.055 + -0.055;

    o.y = (r0.z >= 0) ? r2.y : r0.x;
    o.z = (r0.w >= 0) ? r2.z : r0.y;
    o.w = 1;

    return o;
}
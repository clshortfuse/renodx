// ---- Created with 3Dmigoto v1.3.16 on Tue Jul 23 02:31:45 2024
// Tonemapper for All effects+FXAA on

#include "./shared.h"
#include "./tonemapper.hlsl" //Include our custom tonemapper

cbuffer _Globals : register(b0)
{
    float fFXAAEdgeThresholdMin : packoffset(c0) = { 0.5 };
    float fFXAAEdgeThreshold : packoffset(c0.y) = { 0.5 };
    float fFXAAEdgeSharpness : packoffset(c0.z) = { 8 };
    float fFXAAPixelRange : packoffset(c0.w) = { 2 };
    float4 vRecipScreenSize : packoffset(c1) = { 0.000781250012, 0.00138888892, 0.000390625006, 0.000694444461 };
    float4 vViewInfo : packoffset(c2);
    float fDistantBlurZThreshold : packoffset(c3);
    float fFar : packoffset(c3.y);
    float fDistantBlurIntensity : packoffset(c3.z);
    float fKIDSDOFType : packoffset(c3.w) = { 0 };
    float fBloomWeight : packoffset(c4) = { 0.5 };
    float fStarWeight : packoffset(c4.y) = { 0.800000012 };
    float fLensFlareWeight : packoffset(c4.z) = { 0.300000012 };
    float2 SimulateHDRParams : packoffset(c5);
    float4 vLightShaftPower : packoffset(c6);
    float3 vColorScale : packoffset(c7) = { 1, 1, 1 };
    float3 vSaturationScale : packoffset(c8) = { 1, 1, 1 };
    float2 vScreenSize : packoffset(c9) = { 1280, 720 };
    float4 vSpotParams : packoffset(c10) = { 640, 360, 300, 400 };
    float fLimbDarkening : packoffset(c11) = { 755364.125 };
    float fLimbDarkeningWeight : packoffset(c11.y) = { 0 };
    float fGamma : packoffset(c11.z) = { 1 };
}

SamplerState smplScene_s : register(s0);
SamplerState smplAdaptedLumCur_s : register(s1);
SamplerState smplZ_s : register(s2);
SamplerState smplBlurFront_s : register(s3);
SamplerState smplDOFMerge_s : register(s4);
SamplerState smplBlurBack_s : register(s5);
SamplerState smplBlurHexFront_s : register(s6);
SamplerState smplBlurHexBack_s : register(s7);
SamplerState smplBloom_s : register(s8);
SamplerState smplStar_s : register(s9);
SamplerState smplFlare_s : register(s10);
SamplerState smplLightShaftLinWork2_s : register(s11);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplAdaptedLumCur_Tex : register(t1);
Texture2D<float4> smplZ_Tex : register(t2);
Texture2D<float4> smplBlurFront_Tex : register(t3);
Texture2D<float4> smplDOFMerge_Tex : register(t4);
Texture2D<float4> smplBlurBack_Tex : register(t5);
Texture2D<float4> smplBlurHexFront_Tex : register(t6);
Texture2D<float4> smplBlurHexBack_Tex : register(t7);
Texture2D<float4> smplBloom_Tex : register(t8);
Texture2D<float4> smplStar_Tex : register(t9);
Texture2D<float4> smplFlare_Tex : register(t10);
Texture2D<float4> smplLightShaftLinWork2_Tex : register(t11);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2, r3, r4, r5;
    uint4 bitmask, uiDest;
    float4 fDest;

    
    
    
    r0.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
    
    if (injectedData.fxaa == 1)
    { //FXAA on/off
        r1.xy = smplScene_Tex.Sample(smplScene_s, v2.xy).xy;
        r1.zw = smplScene_Tex.Sample(smplScene_s, v2.zw).xy;
        r2.xy = smplScene_Tex.Sample(smplScene_s, v3.xy).xy;
        r2.zw = smplScene_Tex.Sample(smplScene_s, v3.zw).xy;
        r3.x = r0.y * 1.9632107 + r0.x;
        r4.z = r1.y * 1.9632107 + r1.x;
        r4.w = r1.w * 1.9632107 + r1.z;
        r4.y = r2.y * 1.9632107 + r2.x;
        r4.x = r2.w * 1.9632107 + r2.z;
        r1.xy = min(r4.zy, r4.wx);
        r1.x = min(r1.x, r1.y);
        r1.x = min(r3.x, r1.x);
        r1.yz = max(r4.zy, r4.wx);
        r1.y = max(r1.y, r1.z);
        r1.y = max(r3.x, r1.y);
        r1.z = r1.y + -r1.x;
        r1.w = fFXAAEdgeThreshold * r1.y;
        r1.w = max(fFXAAEdgeThresholdMin, r1.w);
        r1.z = cmp(r1.z < r1.w);
        r2.xyzw = r4.yzzw + r4.xwyx;
        r2.xy = r2.xz + -r2.yw;
        r1.w = dot(r2.xy, r2.xy);
        r1.w = max(1.00000001e-07, r1.w);
        r1.w = sqrt(r1.w);
        r2.xy = r2.xy / r1.ww;
        r1.w = min(abs(r2.x), abs(r2.y));
        r1.w = r1.w * fFXAAEdgeSharpness + 0.00100000005;
        r2.zw = r2.xy / r1.ww;
        r2.zw = max(-fFXAAPixelRange, r2.zw);
        r2.zw = min(fFXAAPixelRange, r2.zw);
        r3.xy = vRecipScreenSize.xy * fFXAAPixelRange;
        r4.xy = vRecipScreenSize.zw * r2.xy;
        r4.zw = r3.xy * r2.zw;
        r2.xyzw = v1.xyxy + -r4.xyzw;
        r3.xyzw = v1.xyxy + r4.xyzw;

    
        r4.xyz = smplScene_Tex.Sample(smplScene_s, r2.xy).xyz;
        r5.xyz = smplScene_Tex.Sample(smplScene_s, r3.xy).xyz;
        r2.xyz = smplScene_Tex.Sample(smplScene_s, r2.zw).xyz;
        r3.xyz = smplScene_Tex.Sample(smplScene_s, r3.zw).xyz;
        if (r1.z == 0)
        {
            r4.xyz = r5.xyz + r4.xyz;
            r5.xyz = float3(0.5, 0.5, 0.5) * r4.xyz;
            r2.xyz = r3.xyz + r2.xyz;
            r2.xyz = float3(0.25, 0.25, 0.25) * r2.xyz;
            r2.xyz = r4.xyz * float3(0.25, 0.25, 0.25) + r2.xyz;
            r1.z = r2.y * 1.9632107 + r2.x;
            r1.x = cmp(r1.z < r1.x);
            r1.y = cmp(r1.y < r1.z);
            r1.x = (int) r1.y | (int) r1.x;
            r0.xyz = r1.xxx ? r5.xyz : r2.xyz;
        }
  
    } //FXAA slider end
    
    
    r1.x = smplAdaptedLumCur_Tex.Sample(smplAdaptedLumCur_s, float2(0.25, 0.5)).x;
    r1.yzw = r1.xxx * r0.xyz;
    r2.x = smplDOFMerge_Tex.Sample(smplDOFMerge_s, v1.xy).w;
    r2.y = cmp(fKIDSDOFType == 0.000000);
    if (r2.y != 0)
    {
        r2.y = cmp(r2.x < 0.5);
        if (r2.y == 0)
        {
            r2.yzw = smplBlurBack_Tex.Sample(smplBlurBack_s, v1.xy).xyz;
            r3.x = -0.5 + r2.x;
            r3.x = r3.x * -2 + 1;
            r3.x = max(0, r3.x);
            r3.x = 9.99999975e-06 + r3.x;
            r3.x = 1 / r3.x;
            r3.x = -1 + r3.x;
            r3.x = saturate(0.25 * r3.x);
            r2.yzw = -r0.xyz * r1.xxx + r2.yzw;
            r1.yzw = r3.xxx * r2.yzw + r1.yzw;
        }
        r3.xyzw = smplBlurFront_Tex.Sample(smplBlurFront_s, v1.xy).xyzw;
        r2.y = -0.5 + r3.w;
        r2.y = abs(r2.y) * -2 + 1;
        r2.y = max(0, r2.y);
        r2.y = 9.99999975e-06 + r2.y;
        r2.y = 1 / r2.y;
        r2.y = -1 + r2.y;
        r2.y = saturate(0.25 * r2.y);
        r3.xyz = r3.xyz + -r1.yzw;
        r2.yzw = r2.yyy * r3.xyz + r1.yzw;
    }
    else
    {
        r3.x = cmp(fKIDSDOFType == 1.000000);
        if (r3.x != 0)
        {
            r3.x = cmp(r2.x < 0.5);
            if (r3.x == 0)
            {
                r3.xyz = smplBlurHexBack_Tex.Sample(smplBlurHexBack_s, v1.xy).xyz;
                r2.x = -0.5 + r2.x;
                r2.x = r2.x * -2 + 1;
                r2.x = max(0, r2.x);
                r2.x = 9.99999975e-06 + r2.x;
                r2.x = 1 / r2.x;
                r2.x = -1 + r2.x;
                r2.x = saturate(0.25 * r2.x);
                r3.xyz = -r0.xyz * r1.xxx + r3.xyz;
                r1.yzw = r2.xxx * r3.xyz + r1.yzw;
            }
            r3.xyzw = smplBlurHexFront_Tex.Sample(smplBlurHexFront_s, v1.xy).xyzw;
            r2.x = -0.5 + r3.w;
            r2.x = abs(r2.x) * -2 + 1;
            r2.x = max(0, r2.x);
            r2.x = 9.99999975e-06 + r2.x;
            r2.x = 1 / r2.x;
            r2.x = -1 + r2.x;
            r2.x = saturate(0.25 * r2.x);
            r3.xyz = r3.xyz + -r1.yzw;
            r2.yzw = r2.xxx * r3.xyz + r1.yzw;
        }
        else
        {
            r2.x = smplZ_Tex.Sample(smplZ_s, v1.xy).x;
            r2.x = vViewInfo.z + r2.x;
            r2.x = -vViewInfo.w / r2.x;
            r2.x = -fDistantBlurZThreshold + r2.x;
            r3.x = fFar + -fDistantBlurZThreshold;
            r2.x = saturate(r2.x / r3.x);
            r2.x = saturate(fDistantBlurIntensity * r2.x);
            r2.x = sqrt(r2.x);
            r3.xyz = smplBlurFront_Tex.Sample(smplBlurFront_s, v1.xy).xyz;
            r0.xyz = -r0.xyz * r1.xxx + r3.xyz;
            r2.yzw = r2.xxx * r0.xyz + r1.yzw;
        }
    }

 
  
    if (injectedData.bloom == 1)
    { //Bloom on/off
        r0.xyz = smplBloom_Tex.Sample(smplBloom_s, v1.xy).xyz;
        r0.xyz = r0.xyz * (fBloomWeight * injectedData.fxBloom) + r2.yzw; //Adjust bloom strength
    }
    
    r1.xyz = smplStar_Tex.Sample(smplStar_s, v1.xy).xyz;
    r0.xyz = r1.xyz * fStarWeight + r0.xyz;
  
    r1.xyz = smplFlare_Tex.Sample(smplFlare_s, v1.xy).xyz;
    r0.xyz = r1.xyz * fLensFlareWeight + r0.xyz;
  
    r1.xyz = smplLightShaftLinWork2_Tex.Sample(smplLightShaftLinWork2_s, v1.xy).xyz;
    r0.xyz = r1.xyz * vLightShaftPower.xyz + r0.xyz;
  
    r1.xyz = vColorScale.xyz * r0.xyz;
  //r1.x = dot(r1.xyz, float3(0.298909992,0.586610019,0.114480004)); //rec601 og code
    r1.x = dot(r1.xyz, float3(0.2126390059f, 0.7151686788f, 0.0721923154f)); //Fixed to rec709
    r0.xyz = r0.xyz * vColorScale.xyz + -r1.xxx;
    r0.xyz = vSaturationScale.xyz * r0.xyz + r1.xxx;
    r1.xy = v1.xy * vScreenSize.xy + -vSpotParams.xy;
    r1.x = dot(r1.xy, r1.xy);
    r1.y = sqrt(r1.x);
    r1.y = -vSpotParams.z + r1.y;
    r1.z = cmp(0 >= r1.y);
    r1.y = saturate(vSpotParams.w / r1.y);
    r1.y = r1.z ? 1 : r1.y;
    r1.x = fLimbDarkening + r1.x;
    r1.x = fLimbDarkening / r1.x;
    r1.x = r1.x * r1.x;
    r1.xzw = r1.xxx * r0.xyz;
    r1.xyz = r1.xzw * r1.yyy;
    r1.w = 1 + -fLimbDarkeningWeight;
    r1.xyz = fLimbDarkeningWeight * r1.xyz;
    r0.xyz = r0.xyz * r1.www + r1.xyz;
    
    float3 untonemapped = r0.xyz;

 //Original Tonemapper Start [Hable + Gamma]

    r1.xyz = r0.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.0299999993, 0.0299999993, 0.0299999993);
    r1.xyz = r0.xyz * r1.xyz + float3(0.00200000009, 0.00200000009, 0.00200000009);
    r2.xyz = r0.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.300000012, 0.300000012, 0.300000012);
    r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
    r0.xyz = r1.xyz / r0.xyz;
    r0.xyz = float3(-0.0333000012, -0.0333000012, -0.0333000012) + r0.xyz;
    r0.xyz = SimulateHDRParams.xxx * r0.xyz;
  //r0.xyz = log2(r0.xyz); // removing gamma from vanilla tonemapper
  //r0.xyz = fGamma * r0.xyz;
  //o0.xyz = exp2(r0.xyz);
  //Original tonemapper end
        
    float3 vanillaColor = r0.xyz;
 
 // Second hable run added to inject 0.18 midgrey
    r0.rgb = (0.18f, 0.18f, 0.18f);
    
    r1.xyz = r0.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.0299999993, 0.0299999993, 0.0299999993);
    r1.xyz = r0.xyz * r1.xyz + float3(0.00200000009, 0.00200000009, 0.00200000009);
    r2.xyz = r0.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.300000012, 0.300000012, 0.300000012);
    r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
    r0.xyz = r1.xyz / r0.xyz;
    r0.xyz = float3(-0.0333000012, -0.0333000012, -0.0333000012) + r0.xyz;
    r0.xyz = SimulateHDRParams.xxx * r0.xyz;
// Second Hable End

    float3 outputColor;
    
    outputColor = applyUserTonemap(untonemapped, vanillaColor, renodx::color::y::from::BT709(r0.rgb)); //Apply our custom tonemapper from tonemapper.hlsl
 

      outputColor = renodx::math::SafePow(outputColor, fGamma); //fGamma first [inverse 2.2]
// Moving gamma and Paper White to the Final shader 
//   outputColor = renodx::math::SafePow(outputColor, 2.2f); //2.2 gamma
//   outputColor *= injectedData.toneMapGameNits; // Scale by user nits
        
 //   outputColor.rgb /= 80.f;
        
    o0.rgb = outputColor.rgb;
    
    //end custom tonemapper

  
    o0.w = r0.w; //vanilla code -- alpha; leaving for compat
    
    
    return;
}
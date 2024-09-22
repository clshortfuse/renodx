#include "../../shaders/tonemap.hlsl"
#include "./shared.h"
#include "./oklabhelper.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 03:22:41 2024

cbuffer cbDefaultXSC : register(b0)
{
  float4x4 ViewProj : packoffset(c0);
  float4x4 ViewMatrix : packoffset(c4);
  float4x4 SecondaryProj : packoffset(c8);
  float4x4 SecondaryViewProj : packoffset(c12);
  float4x4 SecondaryInvViewProj : packoffset(c16);
  float4 ConstantColour : packoffset(c20);
  float4 Time : packoffset(c21);
  float4 CameraPosition : packoffset(c22);
  float4 InvProjectionParams : packoffset(c23);
  float4 SecondaryInvProjectionParams : packoffset(c24);
  float4 ShaderDebugParams : packoffset(c25);
  float4 ToneMappingDebugParams : packoffset(c26);
  float4 HDR_EncodeScale2 : packoffset(c27);
  float4 EmissiveSurfaceMultiplier : packoffset(c28);
  float4 AlphaLight_OffsetScale : packoffset(c29);
  float4 TessellationScaleFactor : packoffset(c30);
  float4 FogNearColour : packoffset(c31);
  float4 FogFarColour : packoffset(c32);
  float4 FogParams : packoffset(c33);
  float4 AdvanceEnvironmentShaderDebugParams : packoffset(c34);
  float4 SMAA_RTMetrics : packoffset(c35);
}

cbuffer cbDefaultPSC : register(b2)
{
  float4x4 AlphaLight_WorldtoClipMatrix : packoffset(c0);
  float4x4 AlphaLight_CliptoWorldMatrix : packoffset(c4);
  float4x4 ProjectorMatrix : packoffset(c8);
  float4x4 MotionBlurCurrInvViewProjection : packoffset(c12);
  float4x4 MotionBlurPrevViewProjection : packoffset(c16);
  float4x4 MotionBlurPrevSecViewProjection : packoffset(c20);
  float4x4 Spotlight0_Transform : packoffset(c24);
  float4 TextureAnimation : packoffset(c28);
  float4 AmbientDiffuse : packoffset(c29);
  float4 EnvironmentDebugParams : packoffset(c30);
  float4 ShadowFilterESMWeights : packoffset(c31);
  float4 LegacyDofParams : packoffset(c32);
  float4 OnePixelStepForS0 : packoffset(c33);
  float4 RenderTargetSize : packoffset(c34);
  float4 ModelTrackerID : packoffset(c35);
  float4 Sharpness_Bloom_Controls : packoffset(c36);
  float4 Blur_Direction : packoffset(c37);
  float4 LightMeterDebugParams : packoffset(c38);
  float4 SourceResolution : packoffset(c39);
  float4 HDR_EncodeScale : packoffset(c40);
  float4 OutputGamma : packoffset(c41);
  float4 AlphaLight_ScaleParams : packoffset(c42);
  float4 WrinkleMapWeights[6] : packoffset(c43);
  float4 RadiosityCubeMapIdx : packoffset(c49);
  float4 HairShadingParams[8] : packoffset(c50);
  float4 SkinShadingParams : packoffset(c58);
  float4 HDR_EncodeScale3 : packoffset(c59);
  float4 ScreenResolution[4] : packoffset(c60);
  float4 VelocityParams : packoffset(c64);
  float4 DeferredConstColor : packoffset(c65);
  float4 Spotlight0_Shadow_Params : packoffset(c66);
  float4 Spotlight0_ShadowMapDimensions : packoffset(c67);
  float4 ShadowFilterType : packoffset(c68);
  float4 Spotlight0_ReverseZPerspective : packoffset(c69);
  float4 SpacesuitVisorParams : packoffset(c70);
  float4 Directional_Light_Colour : packoffset(c71);
  float4 Directional_Light_Direction : packoffset(c72);
  float4 EnvironmentMap_Params : packoffset(c73);
  float4 Spotlight0_Shadow_Bias_GoboScale : packoffset(c74);
  float4 ScreenSpaceLightShaftParams1 : packoffset(c75);
  float4 ScreenSpaceLightShaftParams2 : packoffset(c76);
  float4 ScreenSpaceLightPosition : packoffset(c77);
  float4 LensAndScreenCenter : packoffset(c78);
  float4 ScaleAndScaleIn : packoffset(c79);
  float4 HmdWarpParam : packoffset(c80);
  float4 ChromAbParam : packoffset(c81);
  float4 SMAA_SubsampleIndices : packoffset(c82);
}

cbuffer cbUbershaderXSC : register(b5)
{
  float4 rp_parameter_vs[32] : packoffset(c0);
  float4 rp_parameter_ps[32] : packoffset(c32);
}

SamplerState SamplerFrameBuffer_SMP_s : register(s6);
SamplerState SamplerDistortion_SMP_s : register(s7);
SamplerState SamplerBloomMap0_SMP_s : register(s8);
SamplerState SamplerQuarterSizeBlur_SMP_s : register(s9);
SamplerState SamplerColourLUT_SMP_s : register(s10);
SamplerState SamplerNoise_SMP_s : register(s12);
SamplerState SamplerToneMapCurve_SMP_s : register(s14);
Texture2D<float4> SamplerFrameBuffer_TEX : register(t6);
Texture2D<float4> SamplerDistortion_TEX : register(t7);
Texture2D<float4> SamplerBloomMap0_TEX : register(t8);
Texture2D<float4> SamplerQuarterSizeBlur_TEX : register(t9);
Texture3D<float4> SamplerColourLUT_TEX : register(t10);
Texture2D<float4> SamplerNoise_TEX : register(t12);
Texture2D<float4> SamplerToneMapCurve_TEX : register(t14);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // distortion
  r0.xyzw = SamplerDistortion_TEX.Sample(SamplerDistortion_SMP_s, v0.xy).xyzw;
  r0.xy = r0.xy + -r0.zw;
  r0.zw = rp_parameter_ps[1].xy * r0.xy;
  r0.xy = r0.xy * rp_parameter_ps[1].xy + v0.xy;
  r0.xy = min(ScreenResolution[1].xy, r0.xy);
  r1.x = rp_parameter_ps[9].y + rp_parameter_ps[0].z;
  r1.x = cmp(0 < r1.x);
  if (r1.x != 0) {
    r1.x = 1 + rp_parameter_ps[0].z;
    r1.xy = r0.zw * r1.xx + v0.xy;
    r2.x = 1 + -rp_parameter_ps[0].z;
    r1.zw = r0.zw * r2.xx + v0.xy;
    r0.zw = v0.xy * float2(2,2) + float2(-1,-1);
    r2.x = dot(r0.zw, r0.zw);
    r2.x = cmp(9.99999975e-005 < r2.x);
    r3.xy = r0.zw * rp_parameter_ps[9].yy + r1.xy;
    r3.zw = -r0.zw * rp_parameter_ps[9].yy + r1.zw;
    r1.xyzw = r2.xxxx ? r3.xyzw : r1.xyzw;
    r2.x = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, r1.xy, 0).x;
    r2.y = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, r0.xy, 0).y;
    r2.z = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, r1.zw, 0).z;
  } else {
    r2.xyz = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, r0.xy, 0).xyz;
  }
  
  // blur?
  r1.xyz = HDR_EncodeScale.www * r2.xyz;
  r2.xyzw = SamplerQuarterSizeBlur_TEX.Sample(SamplerQuarterSizeBlur_SMP_s, r0.xy).xyzw;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = HDR_EncodeScale2.zzz * r2.xyz;
  r0.z = sqrt(r2.w);
  r0.z = rp_parameter_ps[3].x * r0.z * injectedData.fxDoF;
  r2.xyz = r2.xyz * float3(4,4,4) + -r1.xyz;
  r1.xyz = r0.zzz * r2.xyz + r1.xyz;

  // bloom
  r0.xyz = SamplerBloomMap0_TEX.Sample(SamplerBloomMap0_SMP_s, r0.xy).xyz;
  r0.xyz = r0.xyz * r0.xyz * injectedData.fxBloom;
  r0.xyz = r0.xyz * HDR_EncodeScale2.zzz + r1.xyz;

  float3 untonemapped = r0.xyz;

  // start of tonemap (contains some autoexposure)
  r0.w = dot(float3(0.298999995,0.587000012,0.114), r0.xyz);
  if (injectedData.toneMapType != 0) {
    r0.xyz = float3(0.18, 0.18, 0.18);
  }
  r1.x = log2(r0.w);
  r1.x = r1.x * 0.693147182 + 12;
  r1.x = saturate(0.0625 * r1.x);
  r1.y = 0.25;
  r1.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r1.xy, 0).x;
  r1.y = -r1.x * r1.x + 1;
  r2.xyz = max(float3(0,0,0), r0.xyz);
  r1.z = max(9.99999975e-005, r0.w);
  r2.xyz = r2.xyz / r1.zzz;
  r1.y = max(9.99999975e-006, r1.y);
  r2.xyz = log2(r2.xyz);
  r1.yzw = r2.xyz * r1.yyy;
  r1.yzw = exp2(r1.yzw);
  r2.xyz = r1.yzw * r1.xxx;
  r2.w = sqrt(r1.x);
  r3.x = cmp(ToneMappingDebugParams.y < r2.w);
  r2.w = cmp(r2.w < ToneMappingDebugParams.x);
  r4.xyzw = r2.wwww ? float4(0,0,1,1) : 0;
  r3.xyzw = r3.xxxx ? float4(1,0,0,1) : r4.xyzw;
  r2.w = ToneMappingDebugParams.z * r3.w;
  r1.xyz = -r1.yzw * r1.xxx + r3.xyz;
  r1.xyz = r2.www * r1.xyz + r2.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.693147182,0.693147182,0.693147182) + float3(12,12,12);
  r2.xyz = max(0, float3(0.0625,0.0625,0.0625) * r0.xyz);
  r2.w = 0.25;
  r0.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.xw, 0).x;
  r0.y = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.yw, 0).x;
  r0.z = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.zw, 0).x;
  r1.w = dot(float3(0.298999995,0.587000012,0.114), r0.xyz);
  r1.w = sqrt(r1.w);
  r2.x = cmp(ToneMappingDebugParams.y < r1.w);
  r1.w = cmp(r1.w < ToneMappingDebugParams.x);
  r3.xyzw = r1.wwww ? float4(0,0,1,1) : 0;
  r2.xyzw = r2.xxxx ? float4(1,0,0,1) : r3.xyzw;
  r1.w = ToneMappingDebugParams.z * r2.w;
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r1.www * r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = ToneMappingDebugParams.www * r0.xyz + r1.xyz;
  float exposureScale = renodx::color::y::from::BT709(r0.rgb) / 0.18f; // autoexposure

  // vanilla run 2
  r0.xyz = untonemapped;
  r1.x = log2(r0.w);
  r1.x = r1.x * 0.693147182 + 12;
  r1.x = saturate(0.0625 * r1.x);
  r1.y = 0.25;
  r1.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r1.xy, 0).x;
  r1.y = -r1.x * r1.x + 1;
  r2.xyz = max(float3(0,0,0), r0.xyz);
  r1.z = max(9.99999975e-005, r0.w);
  r2.xyz = r2.xyz / r1.zzz;
  r1.y = max(9.99999975e-006, r1.y);
  r2.xyz = log2(r2.xyz);
  r1.yzw = r2.xyz * r1.yyy;
  r1.yzw = exp2(r1.yzw);
  r2.xyz = r1.yzw * r1.xxx;
  r2.w = sqrt(r1.x);
  r3.x = cmp(ToneMappingDebugParams.y < r2.w);
  r2.w = cmp(r2.w < ToneMappingDebugParams.x);
  r4.xyzw = r2.wwww ? float4(0,0,1,1) : 0;
  r3.xyzw = r3.xxxx ? float4(1,0,0,1) : r4.xyzw;
  r2.w = ToneMappingDebugParams.z * r3.w;
  r1.xyz = -r1.yzw * r1.xxx + r3.xyz;
  r1.xyz = r2.www * r1.xyz + r2.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.693147182,0.693147182,0.693147182) + float3(12,12,12);
  r2.xyz = max(0, float3(0.0625,0.0625,0.0625) * r0.xyz);
  r2.w = 0.25;
  r0.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.xw, 0).x;
  r0.y = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.yw, 0).x;
  r0.z = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.zw, 0).x;
  r1.w = dot(float3(0.298999995,0.587000012,0.114), r0.xyz);
  r1.w = sqrt(r1.w);
  r2.x = cmp(ToneMappingDebugParams.y < r1.w);
  r1.w = cmp(r1.w < ToneMappingDebugParams.x);
  r3.xyzw = r1.wwww ? float4(0,0,1,1) : 0;
  r2.xyzw = r2.xxxx ? float4(1,0,0,1) : r3.xyzw;
  r1.w = ToneMappingDebugParams.z * r2.w;
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r1.www * r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = ToneMappingDebugParams.www * r0.xyz + r1.xyz;
  
  float3 vanillaColor = r0.rgb;

  untonemapped *= exposureScale;
  float vanillaMidGray = 0.18f;
  float renoDRTContrast = 0.78f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 0.68f;
  float renoDRTDechroma = injectedData.colorGradeBlowout;
  float renoDRTSaturation = 1.f;
  float renoDRTHighlights = 1.4f;

  if (injectedData.toneMapType != 4) {
    if (injectedData.toneMapType == 0) {
      untonemapped = vanillaColor.rgb;
    }
    float3 tonemapped = renodx::tonemap::config::Apply(
        untonemapped,
        renodx::tonemap::config::Create(
            injectedData.toneMapType,
            injectedData.toneMapPeakNits,
            injectedData.toneMapGameNits,
            injectedData.toneMapGammaCorrection,
            injectedData.colorGradeExposure,
            injectedData.colorGradeHighlights,
            injectedData.colorGradeShadows,
            injectedData.colorGradeContrast,
            injectedData.colorGradeSaturation,
            vanillaMidGray,
            vanillaMidGray * 100.f,
            renoDRTHighlights,
            renoDRTShadows,
            renoDRTContrast,
            renoDRTSaturation,
            renoDRTDechroma,
            renoDRTFlare,
            renodx::tonemap::config::hue_correction_type::CUSTOM,
            injectedData.toneMapHueCorrection,
            vanillaColor.rgb));

    r0.xyz = tonemapped;
  }
  else {  // Vanilla+
    float renoDRTHighlights = 1.596f;
    float3 tonemapped = renodx::tonemap::config::Apply(
        untonemapped,
        renodx::tonemap::config::Create(
            3.f,
            injectedData.toneMapPeakNits,
            injectedData.toneMapGameNits,
            injectedData.toneMapGammaCorrection,
            1.f,
            injectedData.colorGradeHighlights,
            1.f,
            1.f,
            1.f,
            vanillaMidGray,
            vanillaMidGray * 100.f,
            renoDRTHighlights,
            renoDRTShadows,
            renoDRTContrast,
            renoDRTSaturation,
            renoDRTDechroma,
            renoDRTFlare,
            renodx::tonemap::config::hue_correction_type::CUSTOM,
            injectedData.toneMapHueCorrection,
            vanillaColor.rgb));
      r0.xyz = tonemapped;

    float3 negHDR = min(0, r0.xyz);
    float vanillaLum = renodx::color::y::from::BT709(vanillaColor.rgb);
    r0.xyz = lerp(vanillaColor.rgb, max(0, r0.xyz), saturate(vanillaLum));  // combine tonemappers
    r0.xyz += negHDR;

    // allow for user adjustments
    r0.xyz = renodx::color::grade::UserColorGrading(
        r0.xyz,
        injectedData.colorGradeExposure,
        1.f,
        injectedData.colorGradeShadows,
        injectedData.colorGradeContrast,
        injectedData.colorGradeSaturation);
  }


  // no idea what this does
  r1.xy = (uint2)v2.xy;
  uiDest.xy = (uint2)r1.xy / int2(5,5);
  r1.xy = uiDest.xy;
  r1.x = (int)r1.x + (int)r1.y;
  r1.x = (int)r1.x & 1;
  r1.y = cmp(LightMeterDebugParams.y < r0.w);
  r0.w = cmp(r0.w < LightMeterDebugParams.x);
  r2.xyzw = r0.wwww ? float4(0,0,1,1) : 0;
  r2.xyzw = r1.yyyy ? float4(1,0,0,1) : r2.xyzw;
  r0.w = LightMeterDebugParams.w * r2.w;
  r1.yzw = r2.xyz + -r0.xyz;
  r1.yzw = r0.www * r1.yzw + r0.xyz;
  r0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  r0.xyz = v1.zzz * r0.xyz;
  r1.xyz = sign(r0.xyz) * sqrt(abs(r0.xyz));  //  r1.xyz = sqrt(r0.xyz);
  r1.xyz = rp_parameter_ps[2].zzz + r1.xyz;


  // LUT application
  float3 preLUTColor = r1.xyz;

  r1.xyz = SamplerColourLUT_TEX.Sample(SamplerColourLUT_SMP_s, r1.xyz).xyz;
  r0.w = rp_parameter_ps[2].y * rp_parameter_ps[2].x;
  r1.xyz = r1.xyz * r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;

  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), OutputGamma.xxx);  //  r0.xyz = pow(r0.xyz, OutputGamma.xxx);

  float3 scaledLUT = renodx::tonemap::UpgradeToneMap(preLUTColor, saturate(preLUTColor), saturate(r0.xyz), injectedData.colorGradeLUTStrength);
  r0.xyz = lerp(preLUTColor, r0.xyz, injectedData.colorGradeLUTStrength);

  if (injectedData.colorGradeLUTScaling) {
    r0.xyz = lerp(r0.xyz, lightnessCorrect(r0.xyz, scaledLUT), injectedData.colorGradeLUTScaling);
  }

  // film grain
  if (injectedData.fxFilmGrain) {
    r1.xyz = SamplerNoise_TEX.Sample(SamplerNoise_SMP_s, v1.xy).xyz;
    r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
    r0.w = dot(float3(0.298999995,0.587000012,0.114), r0.xyz);
    r2.xyz = float3(0,0.5,1) + -r0.www;
    r2.xyz = saturate(rp_parameter_ps[7].xyz + -abs(r2.xyz));
    r2.xyz = r2.xyz / rp_parameter_ps[7].xyz;
    r2.xyz = rp_parameter_ps[8].xyz * r2.xyz;
    r3.xyz = r2.yyy * r1.xyz;
    r2.xyw = r1.xyz * r2.xxx + r3.xyz;
    r1.xyz = r1.xyz * r2.zzz + r2.xyw;
    r0.xyz = injectedData.fxFilmGrain * r1.xyz + r0.xyz;
    r0.xyz = r0.xyz * rp_parameter_ps[0].xxx + rp_parameter_ps[0].yyy;
  }
  
  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;

  // final gamma conversion and paper white scaling
  float3 signs = sign(o0.rgb);
  o0.rgb = abs(o0.rgb);
  o0.rgb = (injectedData.toneMapGammaCorrection
                ? pow(o0.rgb, 2.2f)
                : renodx::color::bt709::from::SRGB(o0.rgb));
  o0.rgb *= signs;
  float3 colorBT2020 = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::from::BT2020(colorBT2020, injectedData.toneMapGameNits);

  return;
}
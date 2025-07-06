#include "./common.hlsl"
// ---- Created with 3Dmigoto v1.3.2 on Fri Apr 18 12:59:59 2025

cbuffer _Globals : register(b0)
{
  float4 g_TAA : packoffset(c0);
  float4 trackgenHeightScaleOffset : packoffset(c1);
  float4x4 prevRelativeViewProj : packoffset(c2);
  float3 prevEyePos : packoffset(c6);
  float4 renderSlice : packoffset(c7);
  float2 sampler0Dim : packoffset(c8);
  float4 sampler0IDim : packoffset(c9);
  float2 sampler1Dim : packoffset(c10);
  float2 sampler1IDim : packoffset(c10.z);
  float2 sampler2Dim : packoffset(c11);
  float2 sampler2IDim : packoffset(c11.z);
  float2 sampler3Dim : packoffset(c12);
  float2 sampler3IDim : packoffset(c12.z);
  float4x4 lensFlareParams : packoffset(c13);
  float4x4 lensFlareParams2 : packoffset(c17);
  float lensFlareParams3 : packoffset(c21);
  float2 godRaysIDim : packoffset(c21.y);
  float2 bloomIDim : packoffset(c22);
  float2 lensFlareIDim : packoffset(c22.z);
  float2 streakIDim : packoffset(c23);
  float2 streak2IDim : packoffset(c23.z);
  float2 streak3IDim : packoffset(c24);
  float4x4 streakXForm : packoffset(c25);
  float4x4 streakXFormI0 : packoffset(c29);
  float4x4 streakXFormI1 : packoffset(c33);
  float4x4 streakXFormI2 : packoffset(c37);
  float2 streakFactor : packoffset(c41);
  float4 streakFactor0 : packoffset(c42);
  float4 streakFactor1 : packoffset(c43);
  float4 streakFactor2 : packoffset(c44);
  float4 streakParams : packoffset(c45);
  float2 warpMapIDim : packoffset(c46);
  float4 distortionParams : packoffset(c47);
  float2 overlayMapIDim : packoffset(c48);
  float motionBlurVelocityMin : packoffset(c48.z);
  float motionBlurVelocityRcpRange : packoffset(c48.w);
  float exposureTime : packoffset(c49);
  float bokehEnabled : packoffset(c49.y);
  float bokehSamples : packoffset(c49.z);
  float bokehCocStrength : packoffset(c49.w);
  float bokehCocMin : packoffset(c50);
  float bokehCocMax : packoffset(c50.y);
  float4 bokehFocalParams : packoffset(c51);
  float vignetteAmount : packoffset(c52);
  float4 vignetteBlur : packoffset(c53);
  float vignetteSaturation : packoffset(c54);
  float4 vignetteColourTL : packoffset(c55);
  float4 vignetteColourTR : packoffset(c56);
  float4 vignetteColourBL : packoffset(c57);
  float4 vignetteColourBR : packoffset(c58);
  float4 vignetteParams : packoffset(c59);
  float4 vignetteParams1 : packoffset(c60);
  float4 vignetteParams2 : packoffset(c61);
  float3 spriteSunDirection : packoffset(c62);
  float4 lensdust_params0 : packoffset(c63);
  float4 lensdust_params1 : packoffset(c64);
  float4 lensdust_params2 : packoffset(c65);
  float4 lensdust_params3 : packoffset(c66);
  float4 lensdust_params4 : packoffset(c67);
  float4 lensdust_params5 : packoffset(c68);
  float4 lensdust_params6 : packoffset(c69);
  float luminanceMaxRange : packoffset(c70);
  float luminanceMinRange : packoffset(c70.y);
  float brightenSpeed : packoffset(c70.z);
  float darkenSpeed : packoffset(c70.w);
  float forceAdapt : packoffset(c71);
  float exposureCompensation : packoffset(c71.y);
  float4 colorParams : packoffset(c72);
  float4 colourFillParams : packoffset(c73);
  float blurEnabled : packoffset(c74);
  float bloomMixGlobal : packoffset(c74.y);
  float bloomPrevalence : packoffset(c74.z);
  float enabledBlendBloom : packoffset(c74.w);
  float enabledBlendLensFlare : packoffset(c75);
  float4 paletteWeight : packoffset(c76);
  float4 focalParams : packoffset(c77);
  float dofBlurScale : packoffset(c78);
  float dofEnabled : packoffset(c78.y);
}

cbuffer CameraParamsConstantBuffer : register(b3)
{
  float4x4 projection : packoffset(c0);
  float4x4 inverseProj : packoffset(c4);
  float4 eyePositionWS : packoffset(c8);
  float4x4 relativeViewProjection : packoffset(c9);
  row_major float3x4 relativeView : packoffset(c13);
  bool leftEye : packoffset(c16);
  bool padding[3] : packoffset(c17);
}

SamplerState g_pointClamped_s : register(s0);
SamplerState g_bilinearClamped_s : register(s3);
SamplerState sampler0Sampler_s : register(s4);
SamplerState bloomSampler_s : register(s5);
SamplerState lensFlareSampler_s : register(s6);
SamplerState overlayMapSampler_s : register(s7);
SamplerState bokehMapSampler_s : register(s8);
SamplerState dustMapSampler_s : register(s9);
SamplerState lensRainSampler_s : register(s10);
SamplerState lensMudMapSampler_s : register(s11);
SamplerState decodeLUTSampler_s : register(s12);
Texture2D<float4> sampler0 : register(t0);
Texture2D<float4> sampler1 : register(t1);
Texture2D<float4> bloom : register(t2);
Texture2D<float4> lensFlare : register(t3);
Texture2D<float4> overlayMap : register(t4);
Texture2D<float4> motionBlur : register(t5);
Texture2D<float4> bokehMap : register(t6);
Texture2D<float4> dustMap : register(t7);
Texture2D<float4> lensRain : register(t8);
Texture2D<float4> lensMudMap : register(t9);
Texture3D<float4> decodeLUT : register(t10);


// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  linear centroid float4 v1 : TEXCOORD0,
  linear centroid float4 v2 : TEXCOORD1,
  nointerpolation float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = sampler0.Sample(sampler0Sampler_s, v1.xy).xyz;
  r0.w = cmp(0 != blurEnabled);
  if (r0.w != 0) {
    r1.xyz = motionBlur.Sample(g_bilinearClamped_s, v1.xy).xyz;
    r0.w = sampler1.Sample(g_pointClamped_s, v1.xy).w;
    r1.w = r0.w * r0.w;
    r0.w = r0.w * r1.w + -motionBlurVelocityMin;
    r0.w = saturate(motionBlurVelocityRcpRange * r0.w);
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = r0.www * r1.xyz + r0.xyz;
  }
  r0.w = cmp(0 != bokehEnabled);
  if (r0.w != 0) {
    r1.xyz = bokehMap.Sample(bokehMapSampler_s, v1.xy).xyz;
    r0.w = saturate(0.5 * bokehCocStrength);
    r1.w = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.w = r1.w * r0.w;
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = r0.www * r1.xyz + r0.xyz;
  }
  r1.xyz = bloom.Sample(bloomSampler_s, v1.xy).xyz;
  r0.xyz = (r1.xyz * enabledBlendBloom) * CUSTOM_BLOOM + r0.xyz;
  r2.xyz = lensFlare.Sample(lensFlareSampler_s, v1.xy).xyz;
  r0.xyz = r2.xyz * enabledBlendLensFlare + r0.xyz;
  r0.xyz = v3.xxx * r0.xyz;

  float3 untonemapped = r0.rgb;
  float y_in = renodx::color::y::from::BT709(untonemapped);

  r0.w = dot(r0.xyz, float3(0.212656006,0.715157986,0.0721860006));
  r1.w = -0.00400000019 + r0.w;
  r1.w = max(0, r1.w);
  r2.xy = r1.ww * float2(0.275000006,0.219999999) + float2(0.0375000015,0.300000012);
  r2.xy = r1.ww * r2.xy + float2(0.00249999994,0.0599999987);
  r1.w = r2.x / r2.y;
  r1.w = -0.0416666679 + r1.w;
  r0.w = r1.w / r0.w;
  r0.xyz = (r0.xyz * r0.www); // r1.xyz = saturate(r1.xyz * r0.www);

  float3 tonemapped = r0.rgb;
  float y_out = renodx::color::y::from::BT709(tonemapped);
  float3 tonemapped_y = untonemapped * (y_out / y_in);

  r0.xyz = float3(0.18,0.18,0.18);
  r0.w = dot(r0.xyz, float3(0.212656006,0.715157986,0.0721860006));
  r1.w = -0.00400000019 + r0.w;
  r1.w = max(0, r1.w);
  r2.xy = r1.ww * float2(0.275000006,0.219999999) + float2(0.0375000015,0.300000012);
  r2.xy = r1.ww * r2.xy + float2(0.00249999994,0.0599999987);
  r1.w = r2.x / r2.y;
  r1.w = -0.0416666679 + r1.w;
  r0.w = r1.w / r0.w;
  r0.xyz = (r0.xyz * r0.www); // r1.xyz = saturate(r1.xyz * r0.www);
  float mid_gray = renodx::color::y::from::BT709(r0.xyz);

  r0.xyz = TonemappedUngraded(untonemapped, tonemapped, tonemapped_y, mid_gray);
  
  r0.w = dot(v2.xyz, v2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v2.xyz * r0.www;
  r3.xyz = dustMap.Sample(dustMapSampler_s, v1.zw).xyz;
  r0.w = dot(r2.xyz, relativeView._m20_m21_m22);
  r0.w = r0.w + r0.w;
  r2.xyz = relativeView._m20_m21_m22 * -r0.www + r2.xyz;
  r0.w = (dot(r2.xyz, lensdust_params2.xyz));
  r0.w = log2(r0.w);
  r0.w = lensdust_params0.y * r0.w;
  r0.w = exp2(r0.w);
  r0.w = lensdust_params0.z * r0.w;
  r1.xyz = lensdust_params1.www * r1.xyz;
  r1.xyz = lensdust_params3.xyz * r0.www + r1.xyz;
  r1.xyz = r1.xyz * v3.yyy + lensdust_params4.zzz;
  r0.w = lensdust_params1.y + -lensdust_params1.x;
  r1.xyz = saturate(r1.xyz * r0.www + lensdust_params1.xxx);
  r1.xyz = r3.xyz * r1.xyz;
  r1.xyz = lensdust_params5.xyz * r1.xyz;
  r0.w = cmp(0 != lensdust_params5.w);
  if (r0.w != 0) {
    r2.xyz = lensRain.Sample(lensRainSampler_s, v1.zw).xyz;
    r0.w = dot(r2.xyz, float3(1,1,1));
    r0.w = 1 + -r0.w;
    r3.xyz = r1.xyz * r0.www;
    r1.xyz = r2.xyz * lensdust_params5.www + r3.xyz;
  }
  r2.xyz = float3(1,1,1) + -r0.xyz;
  r3.xyz = float3(1,1,1) + -r1.xyz;
  r2.xyz = -r2.xyz * r3.xyz + float3(1,1,1);
  r0.w = 1 + -lensdust_params6.w;
  r1.w = r0.w * r0.w;
  r1.xyz = -r1.www * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = r2.xyz * lensdust_params6.www + r0.xyz;
  r0.w = cmp(0 < lensdust_params4.w);
  if (r0.w != 0) {
    r0.w = lensMudMap.Sample(lensMudMapSampler_s, v1.zw).x;
    r0.w = 1 + -r0.w;
    r0.w = -r0.w * lensdust_params4.w + 1;
    r1.xyz = lensdust_params6.xyz * lensdust_params6.www;
    r1.w = 1 + -r0.w;
    r2.xyz = r0.xyz * r0.www;
    r0.xyz = r1.xyz * r1.www + r2.xyz;
  }

  float3 ungraded = r0.rgb;
  float3 sdr_color = SDRColor(ungraded);
  if (RENODX_TONE_MAP_TYPE > 0) {
    r0.xyz = sdr_color;
  }

  // r0.xyz = log2(r0.yxz);
  // r0.xyz = float3(0.45449999,0.45449999,0.45449999) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  r0.xyz = renodx::color::gamma::EncodeSafe(r0.yxz);
  r0.xyz = r0.xyz * float3(0.96875,0.9375,0.9375) + float3(0.015625,0.03125,0.03125);
  r0.xyz = decodeLUT.Sample(decodeLUTSampler_s, r0.xyz).xyz;
  r0.xyz = saturate(r0.xyz);
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);

  r0.xyz = TonemappedGraded(ungraded, sdr_color, r0.rgb);
  float3 tonemapped_graded = r0.rgb;

  r1.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r2.x = dot(r1.xy, vignetteParams2.zw);
  r2.y = dot(r1.xy, vignetteParams2.xy);
  r1.xy = r2.xy * vignetteParams.zz + vignetteParams1.zw;
  r1.xy = vignetteParams1.xy * r1.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.y = 1;
  r0.w = dot(r1.xy, vignetteParams.xy);
  r1.xyz = vignetteColourTR.xyz + -vignetteColourTL.xyz;
  r1.xyz = v1.xxx * r1.xyz + vignetteColourTL.xyz;
  r2.xyz = vignetteColourBR.xyz + -vignetteColourBL.xyz;
  r2.xyz = v1.xxx * r2.xyz + vignetteColourBL.xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = v1.yyy * r2.xyz + r1.xyz;
  r0.w = saturate(vignetteAmount * r0.w);
  r0.w = log2(r0.w);
  r0.w = vignetteParams.w * r0.w;
  r0.w = exp2(r0.w);
  r1.xyz = r1.xyz + -r0.xyz;
  if (CUSTOM_VIGNETTE == 0) {
    r0.xyz = (r0.www * 0) * r1.xyz + r0.xyz;
  } else if (CUSTOM_VIGNETTE == 1) {
    r0.xyz = r0.www * r1.xyz + r0.xyz;
    r0.xyz = lerp(r0.xyz, tonemapped_graded, saturate(r0.xyz));
  } else if (CUSTOM_VIGNETTE == 2) {
    r0.xyz = r0.www * r1.xyz + r0.xyz;
  }
  r1.xyzw = overlayMap.Sample(overlayMapSampler_s, v1.xy).xyzw;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  r1.xyz = colourFillParams.xyz + -r0.xyz;
  o0.xyz = colourFillParams.www * r1.xyz + r0.xyz;
  o0.w = 0;
  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);

  o0.rgb = Tonemap(o0.rgb);
  return;
}
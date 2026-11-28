#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Nov 01 21:54:39 2026

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 PackedParameters : packoffset(c4);
  float2 MinMaxBlurClamp : packoffset(c5);
  uint OutputColorSpace : packoffset(c5.z);
  float4 SceneShadowsAndDesaturation : packoffset(c6);
  float4 SceneInverseHighLights : packoffset(c7);
  float4 SceneMidTones : packoffset(c8);
  float4 SceneScaledLuminanceWeights : packoffset(c9);
  float4 BloomColor : packoffset(c10);
  float4 BloomThreshold : packoffset(c11);
  float4 DOFParams : packoffset(c12);
  float4 OverlayColor : packoffset(c13);
  float4 VignetteParams : packoffset(c14);
  float4 LensDirt_Desat_Scale_Intensity : packoffset(c15);
  float WhiteScale : packoffset(c16);
  float4 DepthUVScale : packoffset(c17);
  float4 GammaColorScaleAndInverse : packoffset(c18);
  float4 GammaOverlayColor : packoffset(c19);
}

SamplerState SceneColorTexture_s : register(s0);
SamplerState BlurredImage_s : register(s1);
SamplerState LensDirtTexture_s : register(s2);
SamplerState ColorGradingLUT_s : register(s3);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> BlurredImage : register(t1);
Texture2D<float4> LensDirtTexture : register(t2);
Texture2D<float4> ColorGradingLUT : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float3 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * float2(2,2) + float2(-1,-1);
  r0.zw = LensDirt_Desat_Scale_Intensity.yy * r0.xy;
  r0.xy = r0.xy / VignetteParams.xx;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = r0.x * r0.x + -1;
  r0.x = saturate(VignetteParams.y * r0.x + 1);
  r0.yz = r0.zw * float2(0.5,0.5) + float2(0.5,0.5);
  r0.yzw = BlurredImage.Sample(BlurredImage_s, r0.yz).xyz;
  r1.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r0.wwyz;
  r2.x = dot(float3(0.100000001,0.300000012,0.600000024), r1.yzw);
  r2.xyzw = -r0.wwyz * float4(0.0625,0.0625,0.0625,0.0625) + r2.xxxx;
  r1.xyzw = LensDirt_Desat_Scale_Intensity.xxxx * r2.xyzw + r1.xyzw;
  r0.yzw = LensDirtTexture.Sample(LensDirtTexture_s, v0.xy).xyz;
  r1.xyzw = r0.wwyz * r1.xyzw;
  r1.xyzw = LensDirt_Desat_Scale_Intensity.zzzz * r1.xyzw;
  r0.yzw = BlurredImage.Sample(BlurredImage_s, v0.xy).xyz;
  r2.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r0.wwyz;
  r0.y = dot(r2.zwy, float3(0.298999995,0.587000012,0.114));
  r0.y = max(6.10351999e-005, r0.y);
  r2.xyzw = r2.xyzw / r0.yyyy;
  r0.y = -BloomThreshold.x + r0.y;
  r0.y = max(0, r0.y);
  r1.xyzw = r2.xyzw * r0.yyyy + r1.xyzw;
  r0.yzw = SceneColorTexture.Sample(SceneColorTexture_s, v0.xy).xyz;
  r1.xyzw = r1.xyzw * BloomColor.zzxy + r0.wwyz;
  r0.xyzw = r1.xyzw * r0.xxxx;
  r0.xyzw = v0.zzzz * r0.xyzw;
  if (GEARSRELOADED_CUSTOM_HDR_ENABLED && OutputColorSpace == 2) {
    o0.rgb = GearsReloadedToneMapPass(r0.zwy, OverlayColor, ColorGradingLUT, ColorGradingLUT_s);
    o0.a = dot(o0.rgb, float3(0.299f, 0.587f, 0.114f));
    return;
  }
  r1.xyzw = r0.yyzw * float4(0.335000008,0.335000008,0.335000008,0.335000008) + float4(0.509599984,0.509599984,0.509599984,0.509599984);
  r1.xyzw = r0.yyzw * r1.xyzw + float4(0.276899993,0.276899993,0.276899993,0.276899993);
  r2.xyzw = r0.yyzw * float4(0.335000008,0.335000008,0.335000008,0.335000008) + float4(0.783999979,0.783999979,0.783999979,0.783999979);
  r0.xyzw = r0.xyzw * r2.xyzw + float4(0.662999988,0.662999988,0.662999988,0.662999988);
  r0.xyzw = r1.xyzw / r0.xyzw;
  r0.xyzw = float4(-0.417647064,-0.417647064,-0.417647064,-0.417647064) + r0.xyzw;
  r1.xyzw = WhiteScale * r0.xyzw;
  r0.xyzw = -r0.yyzw * WhiteScale + OverlayColor.zzxy;
  r0.xyzw = OverlayColor.wwww * r0.xyzw + r1.xyzw;
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  r1.xyzw = float4(0.00999999978,0.00999999978,0.00999999978,0.00999999978) * r0.yyzw;
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = float4(0.454545468,0.454545468,0.454545468,0.454545468) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r0.xyzw = min(float4(1,1,1,1), r0.xyzw);
  r1.xyzw = log2(r1.xyzw);
  r1.xyzw = float4(0.159301758,0.159301758,0.159301758,0.159301758) * r1.xyzw;
  r1.xyzw = exp2(r1.xyzw);
  r2.xyzw = r1.xyzw * float4(18.6875,18.6875,18.6875,18.6875) + float4(1,1,1,1);
  r1.xyzw = r1.yyzw * float4(18.8515625,18.8515625,18.8515625,18.8515625) + float4(0.8359375,0.8359375,0.8359375,0.8359375);
  r2.xyzw = rcp(r2.xyzw);
  r1.xyzw = r2.xyzw * r1.xyzw;
  r1.xyzw = log2(r1.xyzw);
  r1.xyzw = float4(78.84375,78.84375,78.84375,78.84375) * r1.xyzw;
  r1.xyzw = exp2(r1.xyzw);
  r2.x = cmp(OutputColorSpace == 2);
  r0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;
  r1.xyw = float3(30.9999008,0.96875,0.0302734375) * r0.xwz;
  r0.x = floor(r1.x);
  r1.x = r0.x * 0.03125 + r1.w;
  r1.xyzw = float4(0.00048828125,0.015625,0.0317382813,0.015625) + r1.xyxy;
  r0.x = r0.y * 31 + -r0.x;
  r0.yzw = ColorGradingLUT.SampleLevel(ColorGradingLUT_s, r1.zw, 0).xyz;
  r1.xyz = ColorGradingLUT.SampleLevel(ColorGradingLUT_s, r1.xy, 0).xyz;
  r0.yzw = -r1.xyz + r0.yzw;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  r1.xyz = float3(1.04999995,1.04999995,1.04999995) * r0.xyz;
  r0.xyz = r2.xxx ? r1.xyz : r0.xyz;
  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
  return;
}
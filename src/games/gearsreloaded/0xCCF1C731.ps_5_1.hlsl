#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Nov 01 22:13:38 2026

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

cbuffer PSOffsetConstants : register(b2)
{
  float4 ScreenPositionScaleBias : packoffset(c0);
  float4 MinZ_MaxZRatio : packoffset(c1);
  float4 DiffuseOverrideParameter : packoffset(c2);
  float4 SpecularOverrideParameter : packoffset(c3);
  float4 CameraPositionPS : packoffset(c4);
  bool bSSREnabled : packoffset(c5);
  float2 MaterialAOScaleBias : packoffset(c5.y);
  float2 SuperResolutionJitter : packoffset(c6);
  float3 DummyPS : packoffset(c7);
}

SamplerState SceneDepthTexture_s : register(s0);
SamplerState SceneColorTexture_s : register(s1);
SamplerState BlurredImage_s : register(s2);
SamplerState LensDirtTexture_s : register(s3);
SamplerState DOFFarTexture_s : register(s4);
SamplerState DOFNearTexture_s : register(s5);
SamplerState ColorGradingLUT_s : register(s6);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> SceneDepthTexture : register(t1);
Texture2D<float4> BlurredImage : register(t2);
Texture2D<float4> LensDirtTexture : register(t3);
Texture2D<float4> DOFFarTexture : register(t4);
Texture2D<float4> DOFNearTexture : register(t5);
Texture2D<float4> ColorGradingLUT : register(t6);


// 3Dmigoto declarations
#define cmp -


void main(
  float3 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * float2(2,2) + float2(-1,-1);
  r1.xyz = SceneColorTexture.Sample(SceneColorTexture_s, v0.xy).xyz;
  r2.xyz = BlurredImage.Sample(BlurredImage_s, v0.xy).xyz;
  r2.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r2.zzxy;
  r0.z = dot(r2.zwy, float3(0.298999995,0.587000012,0.114));
  r0.z = max(6.10351999e-005, r0.z);
  r0.w = -BloomThreshold.x + r0.z;
  r0.w = max(0, r0.w);
  r2.xyzw = r2.xyzw / r0.zzzz;
  r3.xyz = LensDirtTexture.Sample(LensDirtTexture_s, v0.xy).xyz;
  r4.xy = LensDirt_Desat_Scale_Intensity.yy * r0.xy;
  r4.xy = r4.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r4.xyz = BlurredImage.Sample(BlurredImage_s, r4.xy).xyz;
  r5.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r4.zzxy;
  r0.z = dot(float3(0.100000001,0.300000012,0.600000024), r5.yzw);
  r4.xyzw = -r4.zzxy * float4(0.0625,0.0625,0.0625,0.0625) + r0.zzzz;
  r4.xyzw = LensDirt_Desat_Scale_Intensity.xxxx * r4.xyzw + r5.xyzw;
  r3.xyzw = r4.xyzw * r3.zzxy;
  r3.xyzw = LensDirt_Desat_Scale_Intensity.zzzz * r3.xyzw;
  r2.xyzw = r2.xyzw * r0.wwww + r3.xyzw;
  r0.z = cmp(0 < DOFParams.x);
  if (r0.z != 0) {
    r0.zw = DepthUVScale.xy * v0.xy + DepthUVScale.zw;
    r0.z = SceneDepthTexture.Sample(SceneDepthTexture_s, r0.zw).x;
    r0.z = r0.z * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
    r0.z = 1 / r0.z;
    r3.xy = cmp(PackedParameters.yz < r0.zz);
    r3.zw = cmp(r0.zz < PackedParameters.zy);
    r0.w = r3.z ? r3.x : 0;
    r1.w = PackedParameters.y + -r0.z;
    r3.xz = PackedParameters.yw + -PackedParameters.xz;
    r1.w = saturate(r1.w / r3.x);
    r1.w = MinMaxBlurClamp.x * -r1.w;
    r0.z = -PackedParameters.z + r0.z;
    r0.z = saturate(r0.z / r3.z);
    r0.z = MinMaxBlurClamp.y * r0.z;
    r0.z = r3.y ? r0.z : 0;
    r0.z = saturate(r3.w ? r1.w : r0.z);
    r0.z = r0.w ? 0 : r0.z;
    r3.xyz = DOFFarTexture.Sample(DOFFarTexture_s, v0.xy).xyz;
    r4.xyzw = DOFParams.zwzw * float4(-1.5,-1.5,1.5,1.5) + v0.xyxy;
    r5.xyzw = DOFNearTexture.Sample(DOFNearTexture_s, r4.xy).xyzw;
    r6.xyzw = DOFParams.zwzw * float4(-1.5,0,-1.5,1.5) + v0.xyxy;
    r7.xyzw = DOFNearTexture.Sample(DOFNearTexture_s, r6.xy).xyzw;
    r5.xyzw = r7.xyzw + r5.xyzw;
    r6.xyzw = DOFNearTexture.Sample(DOFNearTexture_s, r6.zw).xyzw;
    r5.xyzw = r6.xyzw + r5.xyzw;
    r6.xyzw = DOFParams.zwzw * float4(0,-1.5,0,1.5) + v0.xyxy;
    r7.xyzw = DOFNearTexture.Sample(DOFNearTexture_s, r6.xy).xyzw;
    r5.xyzw = r7.xyzw + r5.xyzw;
    r7.xyzw = DOFNearTexture.Sample(DOFNearTexture_s, v0.xy).xyzw;
    r5.xyzw = r7.xyzw + r5.xyzw;
    r6.xyzw = DOFNearTexture.Sample(DOFNearTexture_s, r6.zw).xyzw;
    r5.xyzw = r6.xyzw + r5.xyzw;
    r6.xyzw = DOFParams.zwzw * float4(1.5,-1.5,1.5,0) + v0.xyxy;
    r7.xyzw = DOFNearTexture.Sample(DOFNearTexture_s, r6.xy).xyzw;
    r5.xyzw = r7.xyzw + r5.xyzw;
    r6.xyzw = DOFNearTexture.Sample(DOFNearTexture_s, r6.zw).xyzw;
    r5.xyzw = r6.xyzw + r5.xyzw;
    r4.xyzw = DOFNearTexture.Sample(DOFNearTexture_s, r4.zw).xyzw;
    r4.xyzw = r5.xyzw + r4.xyzw;
    r5.xyz = float3(0.111111112,0.111111112,0.111111112) * r4.xyz;
    r0.w = cmp(DOFParams.y == 0.000000);
    r6.xy = float2(4,8) * r0.zz;
    r6.xy = min(float2(1,1), r6.xy);
    r0.z = -r4.w * 0.111111112 + 1;
    r3.xyz = r3.xyz + -r1.xyz;
    r6.xzw = r6.xxx * r3.xyz + r1.xyz;
    r5.xyz = r6.xzw * r0.zzz + r5.xyz;
    r3.xyz = r6.yyy * r3.xyz + r1.xyz;
    r0.z = 1 + -r0.z;
    r4.xyz = r4.xyz * float3(0.111111112,0.111111112,0.111111112) + -r3.xyz;
    r3.xyz = r0.zzz * r4.xyz + r3.xyz;
    r1.xyz = r0.www ? r5.xyz : r3.xyz;
  }
  r0.xy = r0.xy / VignetteParams.xx;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = r0.x * r0.x + -1;
  r0.x = saturate(VignetteParams.y * r0.x + 1);
  r1.xyzw = r2.xyzw * BloomColor.zzxy + r1.zzxy;
  r0.xyzw = r1.xyzw * r0.xxxx;
  r0.xyzw = v0.zzzz * r0.xyzw;
  if (GEARSRELOADED_CUSTOM_HDR_ENABLED && OutputColorSpace == 2) {
    o0.rgb = GearsReloadedToneMapPass(r0.zwx, OverlayColor, ColorGradingLUT, ColorGradingLUT_s);
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
  r1.x = cmp(OutputColorSpace == 2);
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  r2.xyzw = float4(0.00999999978,0.00999999978,0.00999999978,0.00999999978) * r0.yyzw;
  r2.xyzw = log2(r2.xyzw);
  r2.xyzw = float4(0.159301758,0.159301758,0.159301758,0.159301758) * r2.xyzw;
  r2.xyzw = exp2(r2.xyzw);
  r3.xyzw = r2.yyzw * float4(18.8515625,18.8515625,18.8515625,18.8515625) + float4(0.8359375,0.8359375,0.8359375,0.8359375);
  r2.xyzw = r2.xyzw * float4(18.6875,18.6875,18.6875,18.6875) + float4(1,1,1,1);
  r2.xyzw = rcp(r2.xyzw);
  r2.xyzw = r3.xyzw * r2.xyzw;
  r2.xyzw = log2(r2.xyzw);
  r2.xyzw = float4(78.84375,78.84375,78.84375,78.84375) * r2.xyzw;
  r2.xyzw = exp2(r2.xyzw);
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = float4(0.454545468,0.454545468,0.454545468,0.454545468) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r0.xyzw = min(float4(1,1,1,1), r0.xyzw);
  r0.xyzw = r1.xxxx ? r2.xyzw : r0.xyzw;
  r2.xyw = float3(30.9999008,0.96875,0.0302734375) * r0.xwz;
  r0.x = floor(r2.x);
  r0.y = r0.y * 31 + -r0.x;
  r2.x = r0.x * 0.03125 + r2.w;
  r2.xyzw = float4(0.00048828125,0.015625,0.0317382813,0.015625) + r2.xyxy;
  r0.xzw = ColorGradingLUT.SampleLevel(ColorGradingLUT_s, r2.xy, 0).xyz;
  r1.yzw = ColorGradingLUT.SampleLevel(ColorGradingLUT_s, r2.zw, 0).xyz;
  r1.yzw = r1.yzw + -r0.xzw;
  r0.xyz = r0.yyy * r1.yzw + r0.xzw;
  r1.yzw = float3(1.04999995,1.04999995,1.04999995) * r0.xyz;
  r0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
  return;
}
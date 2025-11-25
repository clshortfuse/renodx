#include "./shared.h"

cbuffer _Globals : register(b0){
  float4x4 LocalToWorld : packoffset(c0);
  float4x4 ScreenToWorldMatrix : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c8);
  float4 PackedParameters : packoffset(c9);
  float4 MinMaxBlurClamp : packoffset(c10);
  float4x4 InvViewProjectionMatrix : packoffset(c11);
  float3 CameraWorldPos : packoffset(c15);
  float3 ActorWorldPos : packoffset(c16);
  float4 ObjectWorldPositionAndRadius : packoffset(c17);
  float3 ObjectOrientation : packoffset(c18);
  float3 ObjectPostProjectionPosition : packoffset(c19);
  float3 ObjectNDCPosition : packoffset(c20);
  float4 ObjectMacroUVScales : packoffset(c21);
  float3 FoliageImpulseDirection : packoffset(c22);
  float4 FoliageNormalizedRotationAxisAndAngle : packoffset(c23);
  float4 WindDirectionAndSpeed : packoffset(c24);
  float3x3 LocalToWorldMatrix : packoffset(c25);
  float3x3 WorldToLocalMatrix : packoffset(c28);
  float3x3 WorldToViewMatrix : packoffset(c31);
  float3x3 ViewToWorldMatrix : packoffset(c34);
  float4 UniformPixelVector_0 : packoffset(c37);
  float4 UniformPixelVector_1 : packoffset(c38);
  float4 UniformPixelVector_2 : packoffset(c39);
  float4 UniformPixelVector_3 : packoffset(c40);
  float4 UniformPixelVector_4 : packoffset(c41);
  float4 UniformPixelScalars_0 : packoffset(c42);
  float4 UniformPixelScalars_1 : packoffset(c43);
  float4 UniformPixelScalars_2 : packoffset(c44);
  float4 UniformPixelScalars_3 : packoffset(c45);
  float4 UniformPixelScalars_4 : packoffset(c46);
  float4 UniformPixelScalars_5 : packoffset(c47);
  float3 TemporalAAParameters : packoffset(c48);
  float4x4 PreviousLocalToWorld : packoffset(c49);
  float LocalToWorldRotDeterminantFlip : packoffset(c53);
  float3x3 WorldToLocal : packoffset(c54);
  float4 LightmapCoordinateScaleBias : packoffset(c57);
  float4 ShadowmapCoordinateScaleBias : packoffset(c58);
  float4 LightColorAndFalloffExponent : packoffset(c59);
  float3 DistanceFieldParameters : packoffset(c60);
  float4x4 ScreenToShadowMatrix : packoffset(c61);
  float4 ShadowBufferAndTexelSize : packoffset(c65);
  float ShadowOverrideFactor : packoffset(c66);
  bool bReceiveDynamicShadows : packoffset(c66.y);
  bool bEnableDistanceShadowFading : packoffset(c66.z);
  float2 DistanceFadeParameters : packoffset(c67);
  float4 DeferredRenderingParameters : packoffset(c68);
  float2 TemporalAAParametersPS : packoffset(c69);
  float3 SpotDirection : packoffset(c70);
  float2 SpotAngles : packoffset(c71);
  float3 UpperSkyColor : packoffset(c72);
  float3 LowerSkyColor : packoffset(c73);
  float4 AmbientColorAndSkyFactor : packoffset(c74);
}
cbuffer PSOffsetConstants : register(b2){
  float4 ScreenPositionScaleBias : packoffset(c0);
  float4 MinZ_MaxZRatio : packoffset(c1);
  float NvStereoEnabled : packoffset(c2);
  float4 DiffuseOverrideParameter : packoffset(c3);
  float4 SpecularOverrideParameter : packoffset(c4);
  float4 CameraPositionPS : packoffset(c5);
  float4 ScreenAndTexelSize : packoffset(c6);
}
SamplerState SceneColorTextureSampler_s : register(s0);
SamplerState PixelTexture2D_0Sampler_s : register(s1);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> PixelTexture2D_0 : register(t1);

void main(
  float4 v0 : TEXCOORD10,
  float4 v1 : TEXCOORD11,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD6,
  float4 v5 : TEXCOORD5,
  uint v6 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = UniformPixelVector_1.xy + v3.xy;
  r0.xy = max(float2(0.005,0.005), r0.xy);
  r0.xy = min(float2(0.995,0.995), r0.xy);
  r0.xy = r0.xy * float2(2,-2) + float2(-1,1);
  r0.xy = r0.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r0.xyz = SceneColorTexture.Sample(SceneColorTextureSampler_s, r0.xy).xyz;
  r1.xy = UniformPixelVector_2.xy + v3.xy;
  r1.xy = max(float2(0.005,0.005), r1.xy);
  r1.xy = min(float2(0.995,0.995), r1.xy);
  r1.xy = r1.xy * float2(2,-2) + float2(-1,1);
  r1.xy = r1.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r1.xyz = SceneColorTexture.Sample(SceneColorTextureSampler_s, r1.xy).xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xy = v5.xy / v5.ww;
  r1.xy = r1.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r1.xyz = SceneColorTexture.Sample(SceneColorTextureSampler_s, r1.xy).xyz;
  r0.xyz = r0.xyz * float3(0.5,0.5,0.5) + -r1.xyz;
  r0.xyz = UniformPixelScalars_4.yyy * r0.xyz + r1.xyz;
  if(injectedData.toneMapType == 0.f){
  r1.xyz = max(float3(9.99999997e-07,9.99999997e-07,9.99999997e-07), abs(r0.xyz));
  r1.xyz = log2(r1.xyz);
  r1.xyz = UniformPixelScalars_4.zzz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  } else {
    r1.xyz = renodx::math::SignPow(r0.xyz, UniformPixelScalars_4.z);
  }
  r0.w = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r2.xyz = r0.www + -r1.xyz;
  r1.xyz = UniformPixelScalars_4.www * r2.xyz + r1.xyz;
  r0.w = UniformPixelScalars_4.y * -0.05 + 0.1;
  r1.xyz = r1.xyz + r0.www;
  r0.w = PixelTexture2D_0.SampleBias(PixelTexture2D_0Sampler_s, v3.xy, 0).x;
  r2.xyz = UniformPixelVector_4.xyz + -UniformPixelVector_3.xyz;
  r2.xyz = r0.www * r2.xyz + UniformPixelVector_3.xyz;
  r0.xyz = -r1.xyz * r2.xyz + r0.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r2.xy = v3.xy * float2(1,1.4) + float2(-0.5,-0.7);
  r0.w = dot(r2.xy, r2.xy);
  r0.w = saturate(UniformPixelScalars_5.x * r0.w);
  r0.w = -r0.w * r0.w + 1;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.xyz = UniformPixelVector_0.xyz + r0.xyz;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = max(float3(0,0,0), r0.xyz);
  }
  r0.xyz = r0.xyz != r0.xyz ? float3(0,0,0) : r0.xyz;
  o0.w = renodx::color::y::from::NTSC1953(r0.xyz);
  o0.xyz = r0.xyz;
  return;
}
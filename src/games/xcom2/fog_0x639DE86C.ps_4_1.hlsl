// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  2 18:22:22 2025

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4 DeferredRenderingParameters : packoffset(c6);
  float4 SharedFogParameter0 : packoffset(c7);
  float4 SharedFogParameter1 : packoffset(c8);
  float4 SharedFogParameter2 : packoffset(c9);
  float4 SharedFogParameter3 : packoffset(c10);
  float bUseExponentialHeightFog : packoffset(c11);
  float4 FogInScattering[4] : packoffset(c12);
  float4 FogMaxHeight : packoffset(c16);
  float4 AOScreenPositionScaleBias : packoffset(c17);
  float3x3 WorldToViewMatrix : packoffset(c18);
  float2 HalfSceneColorTexelSize : packoffset(c21);
  float4x4 ScreenToView : packoffset(c22);
  float4x4 ScreenToWorldOffset : packoffset(c26);
  float4 NoiseScale : packoffset(c30);
  float2 ProjectionScale : packoffset(c31);
  float4x4 ProjectionMatrix : packoffset(c32);
  float4 OcclusionCalcParameters : packoffset(c36);
  float HaloDistanceScale : packoffset(c37);
  float4 OcclusionRemapParameters : packoffset(c38);
  float4 OcclusionFadeoutParameters : packoffset(c39);
  float MaxRadiusTransform : packoffset(c40);
  float4x4 TranslatedWorldToView : packoffset(c41);
  float4x4 TranslatedWorldToClip : packoffset(c45);
  float4 ScreenPosToUV : packoffset(c49);
  float3 LevelVolumeDimensions : packoffset(c50);
  float3 LevelVolumePosition : packoffset(c51);
  float3 VoxelSizeXYZ : packoffset(c52);
  float3 CameraPosWS : packoffset(c53);
  float4 FilterParameters : packoffset(c54);
  float4 CustomParameters : packoffset(c55);
  float4 OcclusionColor : packoffset(c56);
  float3 HaveSeenFOWTint : packoffset(c57);
  float2 InvEncodePower : packoffset(c58);
  float3 CameraPosition : packoffset(c59);
}

cbuffer PSOffsetConstants : register(b2)
{
  float4 ScreenPositionScaleBias : packoffset(c0);
  float4 MinZ_MaxZRatio : packoffset(c1);
  float NvStereoEnabled : packoffset(c2);
  float4 DiffuseOverrideParameter : packoffset(c3);
  float4 SpecularOverrideParameter : packoffset(c4);
  float4 CameraPositionPS : packoffset(c5);
  float4 ScreenTexelSize : packoffset(c6);
  float4 ViewportPositionScaleBias : packoffset(c7);
  float4 TransLightingVolumeMin : packoffset(c8);
  float4 TransLightingVolumeInvSize : packoffset(c9);
  float2 NumMSAASamples : packoffset(c10);
}

SamplerState SceneDepthTexture_s : register(s0);
Texture2D<float4> SceneDepthTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float3 v2 : TEXCOORD2,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, v0.xy, 0).x;
  r0.y = r0.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.x = cmp(0.999000013 < r0.x);
  r0.y = 1 / r0.y;
  r0.x = r0.x ? 1000000 : r0.y;
  r0.xyz = v1.xyz * r0.xxx;
  r0.w = cmp(0.00999999978 < abs(r0.z));
  r0.w = r0.w ? r0.z : 0.00999999978;
  r1.x = -SharedFogParameter0.y * r0.w;
  r0.w = SharedFogParameter0.y * r0.w;
  r1.x = exp2(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x / r0.w;
  r1.x = dot(r0.xyz, r0.xyz);
  r1.y = sqrt(r1.x);
  r1.x = rsqrt(r1.x);
  r0.xyz = r1.xxx * r0.xyz;
  r0.x = dot(SharedFogParameter3.xyz, r0.xyz);
  r0.x = -r0.x * 0.499000013 + 0.5;
  r0.x = log2(r0.x);
  r0.x = SharedFogParameter0.z * r0.x;
  r0.x = exp2(r0.x);
  r0.y = -SharedFogParameter0.w + r1.y;
  r0.y = max(0, r0.y);
  r0.y = SharedFogParameter0.x * r0.y;
  r0.y = r0.y * r0.w;
  r0.y = exp2(-r0.y);
  r0.y = min(1, r0.y);
  r0.y = max(SharedFogParameter1.w, r0.y);
  r0.z = 1 + -r0.y;
  o0.w = r0.y;
  r1.xyz = -SharedFogParameter2.xyz + SharedFogParameter1.xyz;
  r0.xyw = r0.xxx * r1.xyz + SharedFogParameter2.xyz;
  o0.xyz = r0.xyw * r0.zzz;
  return;
}
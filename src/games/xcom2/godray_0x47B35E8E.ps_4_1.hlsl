// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  2 20:45:58 2025

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4x4 ScreenToWorld : packoffset(c6);
  float2 TextureSpaceBlurOrigin : packoffset(c10);
  float4 WorldSpaceBlurOriginAndRadius : packoffset(c11);
  float3 WorldSpaceSpotDirection : packoffset(c12);
  float2 SpotAngles : packoffset(c13);
  float4 WorldSpaceCameraPositionAndDistance : packoffset(c14);
  float4 UVMinMax : packoffset(c15);
  float4 AspectRatioAndInvAspectRatio : packoffset(c16);
  float4 LightShaftParameters : packoffset(c17);
  float4 BloomTintAndThreshold : packoffset(c18);
  float DistanceFade : packoffset(c19);
  float4 SampleOffsets[2] : packoffset(c20);
  float BlurPassIndex : packoffset(c22);
  float4 SourceTextureScaleBias : packoffset(c23);
  float4 SceneColorScaleBias : packoffset(c24);
  float BloomScreenBlendThreshold : packoffset(c25);
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
SamplerState SceneColorTexture_s : register(s1);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> SceneDepthTexture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float3 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = SceneColorTexture.Sample(SceneColorTexture_s, v0.xy).xyz;
  r1.xy = -SampleOffsets[0].zw + v0.xy;
  r2.xyz = SceneColorTexture.Sample(SceneColorTexture_s, r1.xy).xyz;
  r0.w = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, r1.xy, 0).x;
  r0.xyz = r2.xyz + r0.xyz;
  r1.xyzw = -SampleOffsets[1].xyzw + v0.xyxy;
  r2.xyz = SceneColorTexture.Sample(SceneColorTexture_s, r1.xy).xyz;
  r0.xyz = r2.xyz + r0.xyz;
  r2.xyz = SceneColorTexture.Sample(SceneColorTexture_s, r1.zw).xyz;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r2.xyz = LightShaftParameters.yyy * r0.xyz;
  r0.x = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.x = max(6.10351999e-05, r0.x);
  r2.xyz = r2.xyz / r0.xxx;
  r0.x = -BloomTintAndThreshold.w + r0.x;
  r0.x = max(0, r0.x);
  r0.xyz = r2.xyz * r0.xxx;
  r0.xyz = r0.xyz + r0.xyz;
  r2.x = r0.w * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.w = cmp(0.999000013 < r0.w);
  r2.x = 1 / r2.x;
  r2.y = r0.w ? 1000000 : r2.x;
  r0.w = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, r1.xy, 0).x;
  r1.x = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, r1.zw, 0).x;
  r1.y = r0.w * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.w = cmp(0.999000013 < r0.w);
  r1.y = 1 / r1.y;
  r2.z = r0.w ? 1000000 : r1.y;
  r0.w = r1.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.x = cmp(0.999000013 < r1.x);
  r0.w = 1 / r0.w;
  r2.w = r1.x ? 1000000 : r0.w;
  r0.w = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, v0.xy, 0).x;
  r1.x = r0.w * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.w = cmp(0.999000013 < r0.w);
  r1.x = 1 / r1.x;
  r2.x = r0.w ? 1000000 : r1.x;
  r0.w = 0.5 / LightShaftParameters.x;
  r1.xyzw = r2.xyzw + -r0.wwww;
  r2.xyzw = saturate(LightShaftParameters.xxxx * r2.xyzw);
  r0.w = dot(r2.xyzw, float4(0.25,0.25,0.25,0.25));
  r1.xyzw = saturate(LightShaftParameters.xxxx * r1.xyzw);
  r1.x = dot(r1.xyzw, float4(0.25,0.25,0.25,0.25));
  r0.xyz = r1.xxx * r0.xyz;
  r1.xy = -UVMinMax.xy + v0.xy;
  r1.xy = r1.xy / UVMinMax.zw;
  r1.zw = float2(1,1) + -r1.xy;
  r1.x = r1.x * r1.z;
  r1.x = r1.x * r1.y;
  r1.x = r1.x * r1.w;
  r1.x = -r1.x * 8 + 1;
  r1.x = r1.x * r1.x;
  r1.y = -r1.x * r1.x + 1;
  r1.x = r1.x * r1.x;
  o0.w = max(r1.x, r0.w);
  r0.xyz = r1.yyy * r0.xyz;
  r1.xy = -v0.xy * AspectRatioAndInvAspectRatio.zw + TextureSpaceBlurOrigin.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = 5 * r0.w;
  r0.w = min(1, r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r0.w * r0.w;
  r0.xyz = r0.www * r0.xyz;
  o0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  return;
}
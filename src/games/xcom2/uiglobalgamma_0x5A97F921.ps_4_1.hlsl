#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Oct  3 21:33:34 2025

cbuffer _Globals : register(b0)
{
  float4x4 LocalToWorld : packoffset(c0);
  float4x4 ScreenToWorldMatrix : packoffset(c4);
  float4 SpherePositionRadius : packoffset(c8);
  bool bDecompressSceneColor : packoffset(c9);
  float4 PackedParameters : packoffset(c10);
  float4 MinMaxBlurClamp : packoffset(c11);
  float4 CutoutParam : packoffset(c12);
  float4x4 InvViewProjectionMatrix : packoffset(c13);
  float3 CameraWorldPos : packoffset(c17);
  float3 CameraWorldDirection : packoffset(c18);
  float3 DirectionalLightWorldVector : packoffset(c19);
  float4 ObjectWorldPositionAndRadius : packoffset(c20);
  float3 ObjectOrientation : packoffset(c21);
  float3 ObjectPostProjectionPosition : packoffset(c22);
  float3 ObjectNDCPosition : packoffset(c23);
  float4 ObjectMacroUVScales : packoffset(c24);
  float4 ObjectBoxExtent : packoffset(c25);
  float4 WindDirectionAndSpeed : packoffset(c26);
  float SSSEnabled : packoffset(c27);
  bool bForceLPVBilinearSampling : packoffset(c27.y);
  float3x3 LocalToWorldMatrix : packoffset(c28);
  float4x4 WorldToLocalMatrix : packoffset(c31);
  float3x3 WorldToViewMatrix : packoffset(c35);
  float3x3 ViewToWorldMatrix : packoffset(c38);
  float3x3 WorldToProjMatrix : packoffset(c41);
  float4 UniformPixelVector_0 : packoffset(c44);
  float4 UniformPixelVector_1 : packoffset(c45);
  float4 UniformPixelVector_2 : packoffset(c46);
  float4 UniformPixelScalars_0 : packoffset(c47);
  float4 UniformPixelScalars_1 : packoffset(c48);
  float4 UniformPixelScalars_2 : packoffset(c49);
  float4 UniformPixelScalars_3 : packoffset(c50);
  float3 TemporalAAParameters : packoffset(c51);
  float MatInverseGamma : packoffset(c51.w);
  float4x4 PreviousLocalToWorld : packoffset(c52);
  float LocalToWorldRotDeterminantFlip : packoffset(c56);
  float3x3 WorldToLocal : packoffset(c57);
  float4 LightmapCoordinateScaleBias : packoffset(c60);
  float4 ShadowmapCoordinateScaleBias : packoffset(c61);
  float4 LightColorAndFalloffExponent : packoffset(c62);
  float3 DistanceFieldParameters : packoffset(c63);
  float4x4 ScreenToShadowMatrix : packoffset(c64);
  float4 ShadowBufferAndTexelSize : packoffset(c68);
  float ShadowOverrideFactor : packoffset(c69);
  bool bReceiveDynamicShadows : packoffset(c69.y);
  bool bEnableDistanceShadowFading : packoffset(c69.z);
  float2 DistanceFadeParameters : packoffset(c70);
  float4 FOWBorderSettings : packoffset(c71);
  float2 FOWBorderOpacity : packoffset(c72);
  bool bUseTranslucentFOW : packoffset(c72.z);
  float4 ExponentialFog : packoffset(c73);
  float3 OcclusionColor : packoffset(c74);
  float3 HaveSeenTintColor : packoffset(c75);
  float4 DeferredRenderingParameters : packoffset(c76);
  float2 TemporalAAParametersPS : packoffset(c77);
  bool bDynamicDirectionalLight : packoffset(c77.z);
  bool bDynamicSpotLight : packoffset(c77.w);
  float4 LightChannelMask : packoffset(c78);
  float3 SpotDirection : packoffset(c79);
  float2 SpotAngles : packoffset(c80);
  float3 UpperSkyColor : packoffset(c81);
  float3 LowerSkyColor : packoffset(c82);
  float4 AmbientColorAndSkyFactor : packoffset(c83);
}

cbuffer VSOffsetConstants : register(b1)
{
  float4x4 ViewProjectionMatrix : packoffset(c0);
  float4 CameraPositionVS : packoffset(c4);
  float4 PreViewTranslation : packoffset(c5);
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

SamplerState PixelTexture2D_0_s : register(s0);
SamplerState PixelTexture2D_1_s : register(s1);
SamplerState XComFOWVolumeTexture_s : register(s2);
Texture2D<float4> PixelTexture2D_0 : register(t0);
Texture2D<float4> PixelTexture2D_1 : register(t1);
Texture3D<float4> XComFOWVolumeTexture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD10,
  float4 v1 : TEXCOORD11,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD6,
  float4 v6 : TEXCOORD5,
  uint v7 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = ViewProjectionMatrix._m01_m11_m31 * v6.yyy;
  r0.xyz = ViewProjectionMatrix._m00_m10_m30 * v6.xxx + r0.xyz;
  r0.xyz = ViewProjectionMatrix._m02_m12_m32 * v6.zzz + r0.xyz;
  r0.xyz = ViewProjectionMatrix._m03_m13_m33 * v6.www + r0.xyz;
  r0.xy = r0.xy / r0.zz;
  r0.xy = r0.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r0.x = dot(r0.xy, float2(12.9897947,78.2329941));
  r0.x = 6.28318548 * r0.x;
  r0.x = sin(r0.x);
  r0.x = r0.x * 43758.543 + UniformPixelScalars_0.x;
  r0.x = frac(r0.x);
  r0.x = 1 + r0.x;
  r0.yz = v3.xy * float2(0.00999999978,0.100000001) + UniformPixelVector_2.xy;
  r0.y = PixelTexture2D_0.SampleBias(PixelTexture2D_0_s, r0.yz, 0).x;
  r0.y = r0.y * r0.y;
  r0.y = 25.1327419 * r0.y;
  r0.y = sin(r0.y);
  r0.x = r0.x * r0.y;
  r0.x = UniformPixelScalars_3.x * r0.x;
  r0.x = UniformPixelScalars_3.y * r0.x;
  r1.xz = float2(-0.00999999978,-0.0199999996) * r0.xx;
  r0.x = -0.0299999993 * r0.x;
  r2.xy = float2(1,1) + -UniformPixelVector_1.xy;
  r2.xy = float2(0.5,0.5) * r2.xy;
  r2.xy = v3.xy * UniformPixelVector_1.xy + r2.xy;
  r1.yw = float2(-0,-0);
  r1.xyzw = r2.xyxy + r1.xyzw;
  r1.xy = PixelTexture2D_1.SampleBias(PixelTexture2D_1_s, r1.xy, 0).xw;
  r3.yw = PixelTexture2D_1.SampleBias(PixelTexture2D_1_s, r1.zw, 0).yw;
  r3.x = r1.x;
  r1.x = r3.w + r1.y;
  r0.yw = float2(-0,0);
  r0.xy = r2.xy + r0.xy;
  r3.zw = PixelTexture2D_1.SampleBias(PixelTexture2D_1_s, r0.xy, 0).zw;
  r0.x = r3.w + r1.x;
  r0.x = saturate(0.333332986 * r0.x);
  r1.xyz = UniformPixelVector_0.xyz + r3.xyz;
  r0.y = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r2.xyz = HaveSeenTintColor.xyz * r0.yyy;
  r3.xyz = CameraWorldPos.xyz + v6.xyz;
  r3.xyw = -TransLightingVolumeMin.xyz + r3.xyz;
  r4.xy = cmp(CutoutParam.xy < r3.zz);
  r5.xyz = TransLightingVolumeInvSize.xyz * r3.xyw;
  r3.xyz = r3.xyw * TransLightingVolumeInvSize.xyz + float3(-0.5,-0.5,-0.5);
  r3.xyz = float3(-0.5,-0.5,-0.75) + abs(r3.xyz);
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r0.y = XComFOWVolumeTexture.Sample(XComFOWVolumeTexture_s, r5.xyz).x;
  r0.z = r0.y;
  r0.zw = -FOWBorderOpacity.xy + r0.zw;
  r1.w = r3.x + r3.y;
  r1.w = r1.w + r3.z;
  r3.xy = FOWBorderSettings.xz + -r1.ww;
  r1.w = cmp(0 < r1.w);
  r3.xy = saturate(FOWBorderSettings.yw * r3.xy);
  r3.z = 1 + -r3.y;
  r3.yw = r3.xz * r3.xz;
  r3.yw = r3.yw * r3.yw;
  r5.x = r3.x * r3.y;
  r5.z = -r3.z * r3.w + 1;
  r0.zw = r5.xz * r0.zw + FOWBorderOpacity.xy;
  r0.z = r0.z + r0.w;
  r0.y = r1.w ? r0.z : r0.y;
  r0.z = -0.800000012 + r0.y;
  r0.y = saturate(1.25 * r0.y);
  r3.z = 1 + -r0.y;
  r3.x = saturate(5 * r0.z);
  r0.y = 1 + -r3.x;
  r0.y = r0.y + -r3.z;
  r3.y = max(0, r0.y);
  r0.yzw = bUseTranslucentFOW ? r3.xyz : float3(1,0,0);
  r2.xyz = r2.xyz * r0.zzz;
  r1.xyz = r1.xyz * r0.yyy + r2.xyz;
  r1.xyz = OcclusionColor.xyz * r0.www + r1.xyz;
  r0.y = 1 + -r0.w;
  r0.x = r0.x * r0.y;
  r0.yzw = -ExponentialFog.xyz + r1.xyz;
  r0.yzw = ExponentialFog.www * r0.yzw + ExponentialFog.xyz;
  r0.yzw = r0.yzw * v4.www + v4.xyz;
  r0.yzw = log2(r0.yzw);
  r0.yzw = (1.0 / 1.2) * r0.yzw;  // Gamma correction: 1/1.2 ≈ 0.833333 for gamma 1.2
  o0.xyz = exp2(r0.yzw);
  r0.y = CutoutParam.w * CutoutParam.w;
  r0.y = r4.y ? r0.y : 1;
  r0.y = r4.x ? 0 : r0.y;
  o0.w = r0.x * r0.y;
  return;
}
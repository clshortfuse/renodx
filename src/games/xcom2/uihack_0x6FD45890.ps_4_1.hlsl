// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 31 03:24:55 2025

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
  float3 TemporalAAParameters : packoffset(c45);
  float MatInverseGamma : packoffset(c45.w);
  float4x4 PreviousLocalToWorld : packoffset(c46);
  float LocalToWorldRotDeterminantFlip : packoffset(c50);
  float3x3 WorldToLocal : packoffset(c51);
  float4 LightmapCoordinateScaleBias : packoffset(c54);
  float4 ShadowmapCoordinateScaleBias : packoffset(c55);
  float4 LightColorAndFalloffExponent : packoffset(c56);
  float3 DistanceFieldParameters : packoffset(c57);
  float4x4 ScreenToShadowMatrix : packoffset(c58);
  float4 ShadowBufferAndTexelSize : packoffset(c62);
  float ShadowOverrideFactor : packoffset(c63);
  bool bReceiveDynamicShadows : packoffset(c63.y);
  bool bEnableDistanceShadowFading : packoffset(c63.z);
  float2 DistanceFadeParameters : packoffset(c64);
  float4 FOWBorderSettings : packoffset(c65);
  float2 FOWBorderOpacity : packoffset(c66);
  bool bUseTranslucentFOW : packoffset(c66.z);
  float4 ExponentialFog : packoffset(c67);
  float3 OcclusionColor : packoffset(c68);
  float3 HaveSeenTintColor : packoffset(c69);
  float4 DeferredRenderingParameters : packoffset(c70);
  float2 TemporalAAParametersPS : packoffset(c71);
  bool bDynamicDirectionalLight : packoffset(c71.z);
  bool bDynamicSpotLight : packoffset(c71.w);
  float4 LightChannelMask : packoffset(c72);
  float3 SpotDirection : packoffset(c73);
  float2 SpotAngles : packoffset(c74);
  float3 UpperSkyColor : packoffset(c75);
  float3 LowerSkyColor : packoffset(c76);
  float4 AmbientColorAndSkyFactor : packoffset(c77);
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
SamplerState XComFOWVolumeTexture_s : register(s1);
Texture2D<float4> PixelTexture2D_0 : register(t0);
Texture3D<float4> XComFOWVolumeTexture : register(t1);


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
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = CameraWorldPos.xyz + v6.xyz;
  r0.xyw = -TransLightingVolumeMin.xyz + r0.xyz;
  r1.xy = cmp(CutoutParam.xy < r0.zz);
  r2.xyz = r0.xyw * TransLightingVolumeInvSize.xyz + float3(-0.5,-0.5,-0.5);
  r0.xyz = TransLightingVolumeInvSize.xyz * r0.xyw;
  r0.x = XComFOWVolumeTexture.Sample(XComFOWVolumeTexture_s, r0.xyz).x;
  r2.xyz = float3(-0.5,-0.5,-0.75) + abs(r2.xyz);
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r0.z = r2.x + r2.y;
  r0.z = r0.z + r2.z;
  r1.zw = FOWBorderSettings.xz + -r0.zz;
  r0.z = cmp(0 < r0.z);
  r2.xy = saturate(FOWBorderSettings.yw * r1.zw);
  r2.z = 1 + -r2.y;
  r1.zw = r2.xz * r2.xz;
  r1.zw = r1.zw * r1.zw;
  r3.x = r2.x * r1.z;
  r3.z = -r2.z * r1.w + 1;
  r0.y = 0;
  r0.yw = -FOWBorderOpacity.xy + r0.xy;
  r0.yw = r3.xz * r0.yw + FOWBorderOpacity.xy;
  r0.y = r0.y + r0.w;
  r0.x = r0.z ? r0.y : r0.x;
  r0.y = -0.800000012 + r0.x;
  r0.x = saturate(1.25 * r0.x);
  r2.z = 1 + -r0.x;
  r2.x = saturate(5 * r0.y);
  r0.x = 1 + -r2.x;
  r0.x = r0.x + -r2.z;
  r2.y = max(0, r0.x);
  r0.xyz = bUseTranslucentFOW ? r2.xyz : float3(1,0,0);
  r2.xyzw = PixelTexture2D_0.SampleBias(PixelTexture2D_0_s, v3.xy, 0).xyzw;
  r2.xyz = UniformPixelVector_0.xyz + r2.xyz;
  r0.w = saturate(dot(r2.xyz, float3(0.300000012,0.589999974,0.109999999)));
  r3.xyz = HaveSeenTintColor.xyz * r0.www;
  r3.xyz = r3.xyz * r0.yyy;
  r0.xyw = r2.xyz * r0.xxx + r3.xyz;
  r0.xyw = OcclusionColor.xyz * r0.zzz + r0.xyw;
  r0.z = 1 + -r0.z;
  r0.z = r2.w * r0.z;
  r0.xyw = -ExponentialFog.xyz + r0.xyw;
  r0.xyw = ExponentialFog.www * r0.xyw + ExponentialFog.xyz;
  r0.xyw = r0.xyw * v4.www + v4.xyz;
  r0.xyw = log2(r0.xyw);
  r0.yzw = (1.0 / 1.2) * r0.yzw;  // Gamma correction: 1/1.2 ≈ 0.833333 for gamma 1.2
  o0.xyz = exp2(r0.xyw);
  r0.x = CutoutParam.w * CutoutParam.w;
  r0.x = r1.y ? r0.x : 1;
  r0.x = r1.x ? 0 : r0.x;
  o0.w = r0.z * r0.x;
  return;
}
// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  2 19:33:10 2025

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
  float4 UniformPixelScalars_4 : packoffset(c51);
  float4 UniformPixelScalars_5 : packoffset(c52);
  float3 TemporalAAParameters : packoffset(c53);
  float4x4 PreviousLocalToWorld : packoffset(c54);
  float LocalToWorldRotDeterminantFlip : packoffset(c58);
  float3x3 WorldToLocal : packoffset(c59);
  float4 LightmapCoordinateScaleBias : packoffset(c62);
  float4 ShadowmapCoordinateScaleBias : packoffset(c63);
  float4 LightColorAndFalloffExponent : packoffset(c64);
  float3 DistanceFieldParameters : packoffset(c65);
  float4x4 ScreenToShadowMatrix : packoffset(c66);
  float4 ShadowBufferAndTexelSize : packoffset(c70);
  float ShadowOverrideFactor : packoffset(c71);
  bool bReceiveDynamicShadows : packoffset(c71.y);
  bool bEnableDistanceShadowFading : packoffset(c71.z);
  float2 DistanceFadeParameters : packoffset(c72);
  float4 FOWBorderSettings : packoffset(c73);
  float2 FOWBorderOpacity : packoffset(c74);
  bool bUseTranslucentFOW : packoffset(c74.z);
  float4 ExponentialFog : packoffset(c75);
  float3 OcclusionColor : packoffset(c76);
  float3 HaveSeenTintColor : packoffset(c77);
  float4 DeferredRenderingParameters : packoffset(c78);
  float2 TemporalAAParametersPS : packoffset(c79);
  bool bDynamicDirectionalLight : packoffset(c79.z);
  bool bDynamicSpotLight : packoffset(c79.w);
  float4 LightChannelMask : packoffset(c80);
  float3 SpotDirection : packoffset(c81);
  float2 SpotAngles : packoffset(c82);
  float3 UpperSkyColor : packoffset(c83);
  float3 LowerSkyColor : packoffset(c84);
  float4 AmbientColorAndSkyFactor : packoffset(c85);
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
SamplerState PixelTexture2D_2_s : register(s2);
SamplerState PixelTexture2D_3_s : register(s3);
SamplerState PixelTexture2D_4_s : register(s4);
SamplerState XComFOWVolumeTexture_s : register(s5);
SamplerState TransLightVolume_RedSH_s : register(s6);
SamplerState TransLightVolume_GreenSH_s : register(s7);
SamplerState TransLightVolume_BlueSH_s : register(s8);
Texture2D<float4> PixelTexture2D_0 : register(t0);
Texture2D<float4> PixelTexture2D_1 : register(t1);
Texture2D<float4> PixelTexture2D_2 : register(t2);
Texture2D<float4> PixelTexture2D_3 : register(t3);
Texture2D<float4> PixelTexture2D_4 : register(t4);
Texture3D<float4> TransLightVolume_RedSH : register(t5);
Texture3D<float4> TransLightVolume_GreenSH : register(t6);
Texture3D<float4> TransLightVolume_BlueSH : register(t7);
Texture3D<float4> XComFOWVolumeTexture : register(t8);


// 3Dmigoto declarations
#define cmp -


void main(
  linear float4 v0 : TEXCOORD10,
  linear float4 v1 : TEXCOORD11,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD6,
  float4 v6 : TEXCOORD7,
  float4 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = ViewProjectionMatrix._m01_m11_m31 * v7.yyy;
  r0.xyz = ViewProjectionMatrix._m00_m10_m30 * v7.xxx + r0.xyz;
  r0.xyz = ViewProjectionMatrix._m02_m12_m32 * v7.zzz + r0.xyz;
  r0.xyz = ViewProjectionMatrix._m03_m13_m33 * v7.www + r0.xyz;
  r0.xy = r0.xy / r0.zz;
  r0.xy = r0.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r0.x = dot(r0.xy, float2(12.9897947,78.2329941));
  r0.x = 6.28318548 * r0.x;
  r0.x = sin(r0.x);
  r0.x = r0.x * 43758.543 + UniformPixelScalars_0.y;
  r0.x = frac(r0.x);
  r0.x = r0.x * r0.x;
  r0.yzw = CameraWorldPos.xyz + v7.xyz;
  r1.x = 21 + r0.z;
  r1.y = r1.x / UniformPixelScalars_0.w;
  r1.x = r0.y / UniformPixelScalars_0.z;
  r1.zw = UniformPixelScalars_1.xx * r1.xy;
  r1.zw = float2(4,2.5) * r1.zw;
  r1.z = PixelTexture2D_0.SampleBias(PixelTexture2D_0_s, r1.zw, 0).x;
  r1.w = UniformPixelScalars_3.x + r1.z;
  r1.w = floor(r1.w);
  r2.x = 0.300000012 * r1.w;
  r2.yw = float2(0,0);
  r3.xyz = v3.xxy * float3(2,2,2) + r1.zzz;
  r1.z = UniformPixelScalars_1.y + r1.z;
  r2.xy = r3.yz + r2.xy;
  r1.w = PixelTexture2D_4.SampleBias(PixelTexture2D_4_s, r2.xy, 0).z;
  r0.x = r1.w * r0.x;
  r2.xy = float2(1000,500) * r1.xy;
  r1.xy = PixelTexture2D_2.SampleBias(PixelTexture2D_2_s, r1.xy, 0).xy;
  r4.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r1.x = PixelTexture2D_3.SampleBias(PixelTexture2D_3_s, r2.xy, 0).x;
  r0.x = r0.x * 0.5 + r1.x;
  r1.xyw = UniformPixelVector_2.www * UniformPixelVector_2.xyz;
  r3.yzw = float3(0.00999999978,0.00999999978,0.00999999978) * r1.xyw;
  r3.yzw = r0.xxx * r1.xyw + r3.yzw;
  r0.x = dot(r4.xy, r4.xy);
  r0.x = min(1, r0.x);
  r0.x = 1 + -r0.x;
  r4.z = sqrt(r0.x);
  r4.xyz = float3(2,2,1) * r4.xyz;
  r0.x = dot(v5.xyz, v5.xyz);
  r0.x = rsqrt(r0.x);
  r5.xyz = v5.xyz * r0.xxx;
  r0.x = -v5.z * r0.x + 1;
  r2.x = saturate(dot(r4.xyz, r5.xyz));
  r2.x = 1 + -r2.x;
  r2.x = r2.x * r2.x;
  r2.x = r2.x * 0.800000012 + 0.100000001;
  r3.yzw = r2.xxx * r1.xyw + r3.yzw;
  r2.x = UniformPixelScalars_1.z + r1.z;
  r1.z = floor(r1.z);
  r1.z = r1.z * 0.300000012 + r3.x;
  r2.x = floor(r2.x);
  r2.x = r2.x * 0.300000012 + r3.x;
  r1.z = -r2.x + r1.z;
  r2.xy = v3.xy * float2(60,20) + UniformPixelVector_1.xy;
  r4.xyz = PixelTexture2D_1.SampleBias(PixelTexture2D_1_s, r2.xy, 0).xyz;
  r4.xyz = r4.xyz * r1.zzz;
  r4.xyz = float3(6,6,6) * r4.xyz;
  r1.xyz = r4.xyz * r1.xyw + r3.yzw;
  r1.xyz = UniformPixelScalars_3.yyy * r1.xyz + UniformPixelVector_0.xyz;
  r1.xyz = DiffuseOverrideParameter.xyz * AmbientColorAndSkyFactor.xyz + r1.xyz;
  r1.w = dot(v1.xyz, v1.xyz);
  r1.w = rsqrt(r1.w);
  r3.xyz = v1.xyz * r1.www;
  r1.w = dot(v0.xyz, v0.xyz);
  r1.w = rsqrt(r1.w);
  r4.xyw = v0.xyz * r1.www;
  r1.w = r4.x * r3.y;
  r1.w = r3.x * r4.y + -r1.w;
  r4.z = r3.z;
  r4.y = v1.w * r1.w;
  r1.w = dot(r4.yzw, r4.yzw);
  r1.w = rsqrt(r1.w);
  r3.xyz = r4.yzw * r1.www;
  r3.yzw = float3(-0.511663854,0.511663854,-0.511663854) * r3.xyz;
  r4.xyz = -TransLightingVolumeMin.xyz + r0.yzw;
  r5.xyz = TransLightingVolumeInvSize.xyz * r4.xyz;
  r4.xyz = r4.xyz * TransLightingVolumeInvSize.xyz + float3(-0.5,-0.5,-0.5);
  r4.xyz = float3(-0.5,-0.5,-0.75) + abs(r4.xyz);
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r6.xyzw = TransLightVolume_RedSH.Sample(TransLightVolume_RedSH_s, r5.xyz).xyzw;
  r3.x = 0.354491025;
  r6.x = dot(r6.xyzw, r3.xyzw);
  r7.xyzw = TransLightVolume_GreenSH.Sample(TransLightVolume_GreenSH_s, r5.xyz).xyzw;
  r6.y = dot(r7.xyzw, r3.xyzw);
  r7.xyzw = TransLightVolume_BlueSH.Sample(TransLightVolume_BlueSH_s, r5.xyz).xyzw;
  r1.w = XComFOWVolumeTexture.Sample(XComFOWVolumeTexture_s, r5.xyz).x;
  r6.z = dot(r7.xyzw, r3.xyzw);
  r3.xyz = max(float3(0,0,0), r6.xyz);
  r1.xyz = DiffuseOverrideParameter.xyz * r3.xyz + r1.xyz;
  r2.x = saturate(dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999)));
  r3.xyz = HaveSeenTintColor.xyz * r2.xxx;
  r2.x = r4.x + r4.y;
  r2.x = r2.x + r4.z;
  r4.xy = FOWBorderSettings.xz + -r2.xx;
  r2.x = cmp(0 < r2.x);
  r4.xy = saturate(FOWBorderSettings.yw * r4.xy);
  r4.z = 1 + -r4.y;
  r4.yw = r4.xz * r4.xz;
  r4.yw = r4.yw * r4.yw;
  r5.x = r4.x * r4.y;
  r5.z = -r4.z * r4.w + 1;
  r2.z = r1.w;
  r2.yz = -FOWBorderOpacity.xy + r2.zw;
  r2.yz = r5.xz * r2.yz + FOWBorderOpacity.xy;
  r2.y = r2.y + r2.z;
  r1.w = r2.x ? r2.y : r1.w;
  r2.x = -0.800000012 + r1.w;
  r1.w = saturate(1.25 * r1.w);
  r4.z = 1 + -r1.w;
  r4.x = saturate(5 * r2.x);
  r1.w = 1 + -r4.x;
  r1.w = r1.w + -r4.z;
  r4.y = max(0, r1.w);
  r2.xyz = bUseTranslucentFOW ? r4.xyz : float3(1,0,0);
  r3.xyz = r3.xyz * r2.yyy;
  r1.xyz = r1.xyz * r2.xxx + r3.xyz;
  r1.xyz = OcclusionColor.xyz * r2.zzz + r1.xyz;
  r1.w = 1 + -r2.z;
  r1.xyz = -ExponentialFog.xyz + r1.xyz;
  r1.xyz = ExponentialFog.www * r1.xyz + ExponentialFog.xyz;
  o0.xyz = r1.xyz * v4.www + v4.xyz;
  r1.xy = UniformPixelScalars_5.xx * r0.yz;
  r1.xy = frac(r1.xy);
  r0.yz = UniformPixelScalars_5.xx * r0.yz + -r1.xy;
  r1.xy = cmp(CutoutParam.xy < r0.ww);
  r0.yz = r0.yz / UniformPixelScalars_5.xx;
  r0.yz = -CameraWorldPos.xy + r0.yz;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.y = r0.y * UniformPixelScalars_5.y + -60;
  r0.y = saturate(0.0500000007 * r0.y);
  r0.z = 1 + -ViewToWorldMatrix._m21;
  r0.w = abs(r0.z) * abs(r0.z);
  r0.w = abs(r0.z) * r0.w;
  r0.z = cmp(abs(r0.z) < 9.99999997e-07);
  r0.z = r0.z ? 0 : r0.w;
  r0.x = r0.x * r0.z;
  r0.y = -r0.x * 3 + r0.y;
  r0.x = 3 * r0.x;
  r0.x = saturate(UniformPixelScalars_5.w * r0.y + r0.x);
  r0.x = r0.x * r1.w;
  r0.y = CutoutParam.w * CutoutParam.w;
  r0.y = r1.y ? r0.y : 1;
  r0.y = r1.x ? 0 : r0.y;
  o0.w = r0.x * r0.y;
  return;
}
// ---- Created with 3Dmigoto v1.3.16 on Mon Nov 02 10:19:40 2026

cbuffer _Globals : register(b0)
{
  float4x4 InvViewProjectionMatrix : packoffset(c0);
  float3 CameraWorldPos : packoffset(c4);
  float4 UniformVector_0 : packoffset(c5);
  float4 UniformVector_1 : packoffset(c6);
  float4 UniformVector_2 : packoffset(c7);
  float UniformScalar_0 : packoffset(c8);
  float UniformScalar_1 : packoffset(c8.y);
  float UniformScalar_2 : packoffset(c8.z);
  float UniformScalar_3 : packoffset(c8.w);
  float UniformScalar_4 : packoffset(c9);
  float UniformScalar_5 : packoffset(c9.y);
  float UniformScalar_6 : packoffset(c9.z);
  float4x4 LocalToWorld : packoffset(c10);
  float4x4 PreviousLocalToWorld : packoffset(c14);
  float3x3 WorldToLocal : packoffset(c18);
  float4 ShadowCoordinateScaleBias : packoffset(c21);
  float MotionBlurMask : packoffset(c22) = {0};
  float3 UpperSkyColor : packoffset(c22.y);
  float3 LowerSkyColor : packoffset(c23);
  float4 AmbientColorAndSkyFactor : packoffset(c24);
}

SamplerState Texture2D_0_s : register(s0);
SamplerState Texture2D_1_s : register(s1);
Texture2D<float4> Texture2D_0 : register(t0);
Texture2D<float4> Texture2D_1 : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD4,
  float4 v3 : TEXCOORD5,
  float4 v4 : TEXCOORD6,
  uint v5 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = UniformScalar_3 * v1.xy + UniformVector_1.xy;
  r0.xyzw = Texture2D_1.Sample(Texture2D_1_s, r0.xy).xyzw;
  r0.x = UniformScalar_6 * r0.x;
  r1.xyzw = Texture2D_0.Sample(Texture2D_0_s, v1.xy).xyzw;
  r0.x = r1.w * r0.x;
  r0.xyz = r1.xyz * float3(0.5,0.5,0.5) + r0.xxx;
  o0.w = UniformVector_2.w * r1.w;
  r0.xyz = UniformVector_0.xyz + r0.xyz;
  o0.xyz = r0.xyz * v2.www + v2.xyz;
  // This reload/HUD material is composited after scene tonemapping.
  // Bound its RGB and blend alpha before the FP16 swapchain composition.
  o0 = saturate(o0);
  return;
}
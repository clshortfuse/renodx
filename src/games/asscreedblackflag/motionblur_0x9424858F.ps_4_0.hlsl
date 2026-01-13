#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Wed Nov 19 23:58:53 2025

cbuffer MotionBlurConstscb : register(b5)
{

  struct
  {
    float4x4 m_PrevWorldToScreen;
    float4 m_AspectRatioAndStrength;
  } g_MotionBlurConsts : packoffset(c0);

}

SamplerState Texture_s : register(s0);
SamplerState MotionVector_s : register(s2);
Texture2D<float4> Texture : register(t0);
Texture2D<float4> MotionVector : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = Texture.SampleLevel(Texture_s, v1.xy, 0).xyzw;

  float3 test = r0.xyz;

  r1.xyzw = MotionVector.SampleLevel(MotionVector_s, v1.xy, 0).xyzw;
  r1.zw = float2(9.99999975e-06,0) + r1.xy;
  r2.xyzw = float4(-0.497999996,-0.497999996,-0.497990012,-0.497999996) + r1.xyxy;
  r0.w = dot(r1.zw, r1.zw);
  r0.w = rsqrt(r0.w);
  r1.xy = r1.zw * r0.ww;
  r0.w = dot(r2.zw, r2.zw);
  r0.w = rsqrt(r0.w);
  r1.zw = r2.zw * r0.ww;
  r0.w = saturate(dot(r1.xy, r1.zw));
  r1.y = 1;
  r1.z = r2.y;
  r1.yz = g_MotionBlurConsts.m_AspectRatioAndStrength.ww * r1.yz;
  r1.x = r2.x * r1.y;
  r1.y = dot(r2.xy, r2.xy);
  r2.xyzw = r1.xzxz * float4(0.125,-0.125,0.25,-0.25) + v1.xyxy;
  r3.xyzw = Texture.SampleLevel(Texture_s, r2.xy, 0).xyzw;
  r2.xyzw = Texture.SampleLevel(Texture_s, r2.zw, 0).xyzw;
  r0.xyz = r3.xyz * r0.www + r0.xyz;
  r0.xyz = r2.xyz * r0.www + r0.xyz;
  r2.xyzw = r1.xzxz * float4(0.375,-0.375,0.5,-0.5) + v1.xyxy;
  r3.xyzw = Texture.SampleLevel(Texture_s, r2.xy, 0).xyzw;
  r2.xyzw = Texture.SampleLevel(Texture_s, r2.zw, 0).xyzw;
  r0.xyz = r3.xyz * r0.www + r0.xyz;
  r0.xyz = r2.xyz * r0.www + r0.xyz;
  r2.xyzw = r1.xzxz * float4(0.625,-0.625,0.75,-0.75) + v1.xyxy;
  r1.xz = r1.xz * float2(0.875,-0.875) + v1.xy;
  r3.xyzw = Texture.SampleLevel(Texture_s, r1.xz, 0).xyzw;
  r4.xyzw = Texture.SampleLevel(Texture_s, r2.xy, 0).xyzw;
  r2.xyzw = Texture.SampleLevel(Texture_s, r2.zw, 0).xyzw;
  r0.xyz = r4.xyz * r0.www + r0.xyz;
  r0.xyz = r2.xyz * r0.www + r0.xyz;
  r0.xyz = r3.xyz * r0.www + r0.xyz;
  r0.w = r0.w * 7 + 1;
  o0.xyz = r0.xyz / r0.www;
  r0.x = 0.001953125 * g_MotionBlurConsts.m_AspectRatioAndStrength.x;
  r0.x = cmp(r1.y < r0.x);
  o0.w = r0.x ? 1.000000 : 0;

  float3 outputColor = renodx::color::gamma::DecodeSafe(test.rgb);
  o0.rgb = CustomTonemap(outputColor, v1.xy);

  return;
}
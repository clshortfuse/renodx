// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 06 10:51:52 2025

#include "./common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);

SamplerState s5_s : register(s5);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

float IsBad(float v)
{
  return (v != v) || (abs(v) > 65504.f);
}

float3 FixNaN3(float3 c, float3 fallback)
{
  c.x = IsBad(c.x) ? fallback.x : c.x;
  c.y = IsBad(c.y) ? fallback.y : c.y;
  c.z = IsBad(c.z) ? fallback.z : c.z;
  return c;
}

float4 FixNaN4(float4 c, float4 fallback)
{
  c.x = IsBad(c.x) ? fallback.x : c.x;
  c.y = IsBad(c.y) ? fallback.y : c.y;
  c.z = IsBad(c.z) ? fallback.z : c.z;
  c.w = IsBad(c.w) ? fallback.w : c.w;
  return c;
}

float3 ClampHDRFiniteOnly(float3 c)
{
  c = FixNaN3(c, float3(0.f, 0.f, 0.f));
  return min(c, 65504.f);
}

float4 ClampHDRFiniteOnly(float4 c)
{
  c = FixNaN4(c, float4(0.f, 0.f, 0.f, 1.f));
  return min(c, 65504.f);
}

float3 ClampVideoSafe(float3 c)
{
  c = FixNaN3(c, float3(0.f, 0.f, 0.f));
  return max(c, 0.f);
}

float4 ClampVideoSafe(float4 c)
{
  c = FixNaN4(c, float4(0.f, 0.f, 0.f, 1.f));
  c.xyz = max(c.xyz, 0.f);
  c.w = max(c.w, 0.f);
  return c;
}

float SafeSampleX(Texture2D<float4> tex, SamplerState samp, float2 uv)
{
  float v = tex.Sample(samp, uv).x;
  return IsBad(v) ? 0.f : v;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  v2 = ClampHDRFiniteOnly(v2);

  r0.w = SafeSampleX(t6, s5_s, v1.xy);
  r1.y = SafeSampleX(t3, s2_s, v1.xy);
  r1.z = SafeSampleX(t5, s3_s, v1.xy);
  r1.x = SafeSampleX(t2, s0_s, v1.xy);
  r1.w = 1.f;

  r1 = ClampHDRFiniteOnly(r1);

  r0.y = dot(float4(1.f, -0.714139998f, -0.344139993f, 0.531215072f), r1.xyzw);
  r0.x = dot(float3(1.f, 1.40199995f, -0.703749001f), r1.xyw);
  r0.z = dot(float3(1.f, 1.77199996f, -0.889474511f), r1.xzw);

  r0 = ClampHDRFiniteOnly(r0);

  o0.xyzw = v2.xyzw * r0.xyzw;
  o0 = ClampVideoSafe(o0);

  // o0.xyz = PumboAutoHDR(o0.xyz);
  o0.xyz = renodx::draw::UpscaleVideoPass(o0.xyz);

  o0.xyz = ClampVideoSafe(o0.xyz);
  o0.w = IsBad(o0.w) ? 1.f : max(o0.w, 0.f);

  return;
}
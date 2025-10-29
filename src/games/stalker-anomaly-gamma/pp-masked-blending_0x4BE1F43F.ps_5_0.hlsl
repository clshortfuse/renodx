// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 17 20:17:30 2025

SamplerState smp_nofilter_s : register(s0);
SamplerState smp_base_s : register(s1);
Texture2D<float4> s_base : register(t0);
Texture2D<float4> s_position : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float w0 : FOG0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD1,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v2.xy / v2.ww;
  r0.x = s_position.Sample(smp_nofilter_s, r0.xy).z;
  r0.x = -v2.z + r0.x;
  r0.x = -0.100000001 + r0.x;
  r0.y = cmp(r0.x < -0.200000003);
  r0.x = saturate(1.29999995 * r0.x);
  r0.x = r0.y ? 1 : r0.x;
  r0.y = 1 + -r0.x;
  r0.z = cmp(0.5 < r0.x);
  r0.x = r0.z ? r0.y : r0.x;
  r0.x = min(1, r0.x);
  r0.x = r0.x * r0.x;
  r0.y = 0.5 * r0.x;
  r0.x = -r0.x * 0.5 + 1;
  r0.x = r0.z ? r0.x : r0.y;
  r1.xyzw = s_base.Sample(smp_base_s, v0.xy).xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  r0.y = r1.w * r0.x + -3.92156871e-05;
  r0.y = cmp(r0.y < 0);
  if (r0.y != 0) discard;
  r0.y = r1.w * r0.x;
  o0.xyz = r1.xyz * r0.xxx;
  r0.x = w0.x * w0.x;
  o0.w = r0.y * r0.x;
  return;
}
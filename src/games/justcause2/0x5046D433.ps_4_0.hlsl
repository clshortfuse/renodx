// ---- Created with 3Dmigoto v1.3.16 on Wed Sep 09 00:14:15 2026
#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[5];
}




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

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.y = r0.x * cb1[4].z + cb1[4].w;
  r0.y = 1 / r0.y;
  r1.xyz = cb1[1].xyw * v1.yyy;
  r1.xyz = v1.xxx * cb1[0].xyw + r1.xyz;
  r0.xzw = r0.xxx * cb1[2].xyw + r1.xyz;
  r0.xzw = cb1[3].xyw + r0.xzw;
  r0.xz = r0.xz / r0.ww;
  r0.xz = -v1.xy + r0.xz;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xy = r1.xy * float2(0.0625,0.0625) + float2(-0.03125,-0.03125);
  r0.y = saturate(r0.y * 0.00999999978 + 0.00588235306);
  r0.y = cmp(r1.z < r0.y);
  r0.xy = r0.yy ? r1.xy : r0.xz;
  r0.zw = cmp(float2(0,0) < r0.xy);
  r1.xy = saturate(float2(-0.00787401572,-0.00787401572) + r0.xy);
  r0.xy = saturate(float2(-0.00787401572,-0.00787401572) + -r0.xy);
  r0.xy = r0.zw ? r1.xy : -r0.xy;
  r0.xy = cb1[4].xx * r0.xy;
  r0.z = dot(r0.xy, r0.xy);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = cmp(9.99999994e-009 < r0.z);
  if (r0.w != 0) {
    r0.z = rsqrt(r0.z);
    r0.z = saturate(cb1[4].y * r0.z);
    r2.xy = r0.xy * r0.zz;
    r2.zw = r2.xy * float2(-3,-3) + v1.xy;
    r3.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
    r3.xyz = r3.xyz + r1.xyz;
    r2.zw = r2.xy * float2(-2,-2) + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
    r3.xyz = r4.xyz + r3.xyz;
    r2.zw = -r0.xy * r0.zz + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
    r3.xyz = r4.xyz + r3.xyz;
    r0.xy = r0.xy * r0.zz + v1.xy;
    r0.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r0.xyz = r3.xyz + r0.xyz;
    r2.zw = r2.xy * float2(2,2) + v1.xy;
    r3.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
    r0.xyz = r3.xyz + r0.xyz;
    r2.xy = r2.xy * float2(3,3) + v1.xy;
    r2.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r0.xyz = r2.xyz + r0.xyz;
    r1.xyz = float3(0.142857149,0.142857149,0.142857149) * r0.xyz;
  }
  o0.xyz = sqrt(r1.xyz);
  // Final scene output precedes the unmodified HUD composition.
  if (shader_injection.peak_white_nits >= 48.f && shader_injection.resource_upgrade != 0.f) {
    o0.xyz = Jc2FinalScene(r1.xyz);
  }
  o0.w = 1;
  return;
}

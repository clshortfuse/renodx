// Found in Lost Soul Aside
// UE 4.27 HDR10 Native HDR

#include "./composite.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Wed Feb 11 23:19:08 2026
Texture3D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[16];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyz = t1.Sample(s1_s, v0.xy).xyz;

  if (HandleUICompositing(r0, r1, o0, v0.xy, t1, s1_s)) {
    return;
  }

  r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r2.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  r0.xyz = rcp(r0.xyz);
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r0.xyz = t2.SampleLevel(s2_s, r0.xyz, 0).xyz;
  r0.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r1.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r1.xyz = -r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r1.xyz = r2.xyz / r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(10000, 10000, 10000) * r1.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r0.xyz = -r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r0.xyz = r2.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = cb0[15].zzz * r0.xyz;
  r1.w = cmp(0 < r0.w);
  r2.x = cmp(r0.w < 1);
  r1.w = r1.w ? r2.x : 0;
  if (r1.w != 0) {
    r1.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
    r1.w = r1.w / cb0[15].z;
    r1.w = 1 + r1.w;
    r1.w = 1 / r1.w;
    r1.w = r1.w * cb0[15].z + -1;
    r1.w = r0.w * r1.w + 1;
    r1.xyz = r1.xyz * r1.www;
  }
  r0.w = 1 + -r0.w;
  r0.xyz = float3(10000, 10000, 10000) * r0.xyz;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  r0.xyz = rcp(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;
  return;
}

// Sprawl Zero
// UE 5.7.4.0 HDR10 ini HDR

#include "./composite.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Mon Jun 22 16:49:13 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float4 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  float4 ui_color_gamma = r0.xyzw;

  r1.xyz = log2(r0.xyz);
  r1.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyzw = cmp(float4(0.0404499993, 0.0404499993, 0.0404499993, 0) < r0.xyzw);
  r3.xyz = abs(r0.xyz) * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r0.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = r2.xyz ? r3.xyz : r0.xyz;
  r0.xyz = cb0[2].xxx ? r0.xyz : r1.xyz;
  r1.x = dot(float3(0.627403915, 0.329283029, 0.0433130674), r0.xyz);
  r1.y = dot(float3(0.069097288, 0.919540405, 0.0113623152), r0.xyz);
  r1.z = dot(float3(0.0163914394, 0.0880133063, 0.895595253), r0.xyz);
  r0.xyz = cb0[1].www * r1.xyz;

  r1.xyz = t1.Sample(s1_s, v0.xy).xyz;
  float4 scene_color_pq = float4(r1.xyz, 1.f);

  if (HandleUICompositing(ui_color_gamma, scene_color_pq, o0, v0.xy, t1, s1_s)) {
    return;
  }

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
  r1.w = cmp(r0.w < 1);
  r1.w = r1.w ? r2.w : 0;
  if (r1.w != 0) {
    r1.w = dot(r1.xyz, float3(0.262699991, 0.677999973, 0.0593000017));
    r1.w = r1.w / cb0[1].z;
    r1.w = 1 + r1.w;
    r1.w = 1 / r1.w;
    r1.w = r1.w * cb0[1].z + -1;
    r1.w = r0.w * r1.w + 1;
    r1.xyz = r1.xyz * r1.www;
  }
  r1.w = 1 + -r0.w;
  r0.xyz = cb0[1].zzz * r0.xyz;
  r0.xyz = r1.xyz * r1.www + r0.xyz;
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
  o0.w = r0.w;
  return;
}

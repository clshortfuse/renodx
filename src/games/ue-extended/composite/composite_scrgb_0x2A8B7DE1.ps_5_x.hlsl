#include "./composite.hlsli"

// The August Before ini HDR (UE 5.4.4.0)

// ---- Created with 3Dmigoto v1.4.1 on Tue Jun 23 02:35:09 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
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
  float4 ui_color_gamma = r0.xyzw;

  r0.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r0.xyz);
  r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) < r0.xyz);
  r2.xyz = r0.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = r1.xyz ? r2.xyz : r0.xyz;
  r1.x = dot(float3(0.627403915, 0.329283029, 0.0433130674), r0.xyz);
  r1.y = dot(float3(0.069097288, 0.919540405, 0.0113623152), r0.xyz);
  r1.z = dot(float3(0.0163914394, 0.0880133063, 0.895595253), r0.xyz);
  r0.xyz = cb0[0].yyy * r1.xyz;

  r1.xyz = t1.Sample(s1_s, v0.xy).xyz;
  // The game's Native HDR is scRGB; so the sample is linear
  // Need to convert to swap colorspace to BT2020 + PQ Encode
  float4 scene_color_linear = float4(r1.xyz, 1.f);
  scene_color_linear.xyz = LinearSceneToPq(scene_color_linear.xyz);

  if (HandleUICompositing(ui_color_gamma, scene_color_linear, o0, v0.xy, t1,
                          s1_s, 1u)) {
    return;
  }

  r2.x = dot(float3(0.627403915, 0.329283029, 0.0433130674), r1.xyz);
  r2.y = dot(float3(0.069097288, 0.919540405, 0.0113623152), r1.xyz);
  r2.z = dot(float3(0.0163914394, 0.0880133063, 0.895595253), r1.xyz);
  r1.xyz = float3(80, 80, 80) * r2.xyz;
  r1.w = cmp(0 < r0.w);
  r2.x = cmp(r0.w < 1);
  r1.w = r1.w ? r2.x : 0;
  if (r1.w != 0) {
    r2.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.w = dot(r2.xyz, float3(0.262699991, 0.677999973, 0.0593000017));
    r1.w = r1.w / cb0[0].x;
    r1.w = 1 + r1.w;
    r1.w = 1 / r1.w;
    r1.w = r1.w * cb0[0].x + -1;
    r1.w = r0.w * r1.w + 1;
    r1.xyz = r2.xyz * r1.www;
  }
  r0.w = 1 + -r0.w;
  r0.xyz = cb0[0].xxx * r0.xyz;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  r0.xyz = float3(0.0125000002, 0.0125000002, 0.0125000002) * r0.xyz;
  o0.x = dot(float3(1.66049099, -0.58764112, -0.0728498623), r0.xyz);
  o0.y = dot(float3(-0.124550477, 1.13289988, -0.00834942237), r0.xyz);
  o0.z = dot(float3(-0.0181507636, -0.100578897, 1.11872971), r0.xyz);
  o0.w = 1;
  return;
}

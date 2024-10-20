// ---- Created with 3Dmigoto v1.3.16 on Fri Oct 18 20:10:00 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0 : TEXCOORD0,
                                     float4 v1 : SV_POSITION0,
                                                 out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 untonemapped;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  untonemapped = r0.rgb;

  r0.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r0.xyz);
  r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) < r0.xyz);
  r2.xyz = r0.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = r1.xyz ? r2.xyz : r0.xyz;
  r1.x = dot(float3(0.627488017, 0.329267114, 0.0433014743), r0.xyz);
  r1.y = dot(float3(0.069108218, 0.9195171, 0.0113595454), r0.xyz);
  r1.z = dot(float3(0.0163962338, 0.0880229846, 0.895499706), r0.xyz);
  r0.xyz = cb0[7].www * r1.xyz;
  r1.xyz = t1.Sample(s0_s, v0.xy).xyz;
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
  r1.w = cmp(0 < r0.w);
  r2.x = cmp(r0.w < 1);
  r1.w = r1.w ? r2.x : 0;
  if (r1.w != 0) {
    r1.w = dot(r1.xyz, float3(0.262699991, 0.677999973, 0.0593000017));
    r1.w = r1.w / cb0[7].z;
    r1.w = 1 + r1.w;
    r1.w = 1 / r1.w;
    r1.w = r1.w * cb0[7].z + -1;
    r1.w = r0.w * r1.w + 1;
    r1.xyz = r1.xyz * r1.www;
  }
  r0.w = 1 + -r0.w;
  r0.xyz = cb0[7].zzz * r0.xyz;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  o0.xyz = float3(0.0125000002, 0.0125000002, 0.0125000002) * r0.xyz;
  o0.w = 1;

  o0.rgb = untonemapped;
  return;
}
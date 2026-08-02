#include "./CompositeUIPixelShader.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sat Aug  1 15:30:17 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[11];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyz = t1.Sample(s1_s, v0.xy).xyz;

  if (ComposeUIAndSceneSCRGB(r1.xyz, r0.xyzw, o0, v0.xy)) {
    return;
  }

  r0.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r0.xyz);
  r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) < r0.xyz);
  r3.xyz = r0.xyz * float3(0.947867274,0.947867274,0.947867274) + float3(0.0521326996,0.0521326996,0.0521326996);
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r0.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  r0.xyz = r2.xyz ? r3.xyz : r0.xyz;
  r1.xyz = float3(3.125,3.125,3.125) * r1.xyz;
  r0.xyz = cb0[10].www * r0.xyz;
  r1.w = cmp(0 < r0.w);
  r2.x = cmp(r0.w < 1);
  r1.w = r1.w ? r2.x : 0;
  if (r1.w != 0) {
    r2.xyz = max(float3(0,0,0), r1.xyz);
    r1.w = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
    r1.w = r1.w / cb0[10].w;
    r1.w = 1 + r1.w;
    r1.w = 1 / r1.w;
    r1.w = r1.w * cb0[10].w + -1;
    r1.w = r0.w * r1.w + 1;
    r1.xyz = r2.xyz * r1.www;
  }
  r0.w = 1 + -r0.w;
  r0.xyz = float3(3.125,3.125,3.125) * r0.xyz;
  o0.xyz = r1.xyz * r0.www + r0.xyz;
  o0.w = 1;
  return;
}
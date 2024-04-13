// ---- Created with 3Dmigoto v1.3.16 on Wed Mar 27 10:12:27 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  linear noperspective float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.SampleLevel(s0_s, float2(0,0), 0).x;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r0.xyz = r1.xyz * r0.xxx;
  o0.w = r1.w;
  r0.xyz = float3(0.600000024,0.600000024,0.600000024) * r0.xyz;
  r1.xyz = cb0[0].xxx * r0.xyz + cb0[0].yyy;
  r1.xyz = r1.xyz * r0.xyz;
  r2.xyz = cb0[0].zzz * r0.xyz + cb0[0].www;
  r0.xyz = r0.xyz * r2.xyz + cb0[1].xxx;
  // o0.xyz = saturate(r1.xyz / r0.xyz);
  o0.xyz = (r1.xyz / r0.xyz);
  return;
}
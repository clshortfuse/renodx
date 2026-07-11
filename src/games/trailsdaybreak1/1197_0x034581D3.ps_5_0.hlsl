// ---- Created with 3Dmigoto v1.3.16 on Mon Oct 21 22:42:40 2024

cbuffer cb_local : register(b2)
{
  float alpha : packoffset(c0);
}

SamplerState samPoint_s : register(s0);
SamplerState samLinear_s : register(s1);
Texture2D<float4> colorTexture : register(t0);
Texture2D<float4> blurTexture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = blurTexture.SampleLevel(samLinear_s, v1.xy, 0).xyz;
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r2.xyzw = colorTexture.SampleLevel(samPoint_s, v1.xy, 0).xyzw;
  r3.xyz = float3(1,1,1) + -r2.xyz;
  r3.xyz = r3.xyz + r3.xyz;
  r1.xyz = -r3.xyz * r1.xyz + float3(1,1,1);
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r0.xyz * float3(2,2,2) + -r1.xyz;
  r3.xyz = cmp(float3(0.5,0.5,0.5) >= r2.xyz);
  r3.xyz = r3.xyz ? float3(1,1,1) : 0;
  r0.xyz = r3.xyz * r0.xyz + r1.xyz;
  r0.xyz = r0.xyz + -r2.xyz;
  o0.xyz = alpha * r0.xyz + r2.xyz;
  o0.w = r2.w;
  return;
}
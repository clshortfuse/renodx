// ---- Created with 3Dmigoto v1.4.1 on Sat Apr  5 00:33:15 2025
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
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v2.x;
  r0.y = cb0[6].w;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = abs(r0.y) + abs(r0.x);
  r0.x = saturate(r0.x * cb0[10].z + 0.300000012);
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = saturate(r1.xyzw * r0.xxxx);
  r0.y = 0.00999999978 + r1.w;
  r1.xyz = r1.xyz / r0.yyy;
  r2.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r0.xyzw = saturate(r2.xyzw * r0.xxxx);
  r2.x = 0.00999999978 + r0.w;
  r0.xyz = r0.xyz / r2.xxx;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = cb0[8].xyzw * r0.xyzw;
  o0.xyzw = r0.xyzw + r0.xyzw;


  o0 = saturate(o0);

  return;
}
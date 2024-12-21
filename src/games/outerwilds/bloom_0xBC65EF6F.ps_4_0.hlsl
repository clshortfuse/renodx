// ---- Created with 3Dmigoto v1.3.16 on Fri Dec 20 21:00:21 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[6];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[2].xy * cb0[4].zz + v1.xy;
  r0.xy = r0.xy * cb0[3].xy + cb0[3].zw;
  r1.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r0.xyz = r0.xyz * r1.xxx ;
  r1.xyz = cmp(r0.xyz >= float3(-65504,-65504,-65504));
  r2.xyz = cmp(float3(65504,65504,65504) >= r0.xyz);
  r1.xyz = r1.xyz ? r2.xyz : 0;
  r0.w = r1.y ? r1.x : 0;
  r0.w = r1.z ? r0.w : 0;
  r0.xyz = (int3)r0.xyz & (int3)r0.www;
  r0.xyz = min(float3(65504,65504,65504), r0.xyz);
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r1.x = -cb0[5].x + r0.w;
  r1.x = max(0, r1.x);
  r1.x = min(cb0[5].y, r1.x);
  r1.y = cb0[5].z * r1.x;
  r1.x = r1.y * r1.x;
  r1.y = -cb0[4].w + r0.w;
  r0.w = max(9.99999975e-06, r0.w);
  r1.x = max(r1.x, r1.y);
  r0.w = r1.x / r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = 0;
  return;
}
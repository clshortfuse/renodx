#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[31];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.yx);
  r0.xy = -cb0[20].yx + r0.xy;
  r0.xy = saturate(r0.xy / cb0[20].wz);
  r0.zw = cb0[7].yy * r0.xy;
  r1.x = 1 + -cb0[7].y;
  r0.xy = r0.yx * r1.xx + r0.zw;
  r0.xy = r0.xy * cb0[19].zw + cb0[19].xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = cb0[21].xyzw * r0.xyzw;
  r1.xyz = -r0.xyz * float3(2,2,2) + cb0[25].xyz;
  r0.xyzw = r0.xyzw + r0.xyzw;
  r0.xyz = cb0[25].www * r1.xyz + r0.xyz;
  r1.xyzw = t2.Sample(s2_s, v2.zw).xyzw;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = cb0[30].xyz * r1.xyz;
  r1.xyz = r1.xyz * float3(10,10,10) + -r0.xyz;
  r2.xyzw = t3.Sample(s3_s, v3.xy).xyzw;
  r1.w = cb0[30].w * r2.w;
  o0.xyz = r1.www * r1.xyz + r0.xyz;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r0.x = -1 + r1.w;
  r0.x = cb0[24].x * r0.x + 1;
  o0.w = r0.w * r0.x;

  o0 = ClampUI(o0);

  return;

}
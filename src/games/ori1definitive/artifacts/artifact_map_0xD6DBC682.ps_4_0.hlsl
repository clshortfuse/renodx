// ---- Created with 3Dmigoto v1.4.1 on Sat Apr  5 00:33:14 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[27];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
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
  r0.xyzw = r0.xyzw + r0.xyzw;
  r1.x = dot(r0.xyz, float3(0.0638099983,0.214560002,0.0216600001));
  r2.xyzw = t2.Sample(s2_s, v2.zw).xyzw;
  r3.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r1.zw = -r3.yw + r2.yw;
  r2.yz = cb0[26].xx * r1.zw + r3.yw;
  r1.y = r2.z * r0.w;
  r2.x = r2.y / r2.z;
  r0.xyzw = r0.xyzw * r2.xxxz + -r1.xxxy;
  o0.xyzw = r2.xxxx * r0.xyzw + r1.xxxy;

  o0 = saturate(o0);
  return;
}
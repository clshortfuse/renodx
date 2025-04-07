// ---- Created with 3Dmigoto v1.4.1 on Mon Apr  7 01:02:10 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[7];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1,1) / cb1[6].xy;
  r0.xy = cb0[3].xx * r0.xy;
  r0.z = 0;
  r1.xy = v1.xy * cb0[2].xy + cb0[2].zw;
  r2.xyzw = r1.xyxy + -r0.xzzy;
  r0.xyzw = r1.xyxy + r0.xzzy;
  r3.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s1_s, r2.zw).xyzw;
  r4.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r2.x = r4.w + r3.w;
  r3.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s1_s, r0.zw).xyzw;
  r0.x = r3.w + r2.x;
  r0.x = r0.x + r2.w;
  r0.x = saturate(r0.x + r0.w);
  r0.x = saturate(r0.x + -r4.x);
  r2.xyzw = r0.xxxx + -r1.xyzw;
  o0.xyzw = (r0.xxxx * r2.xyzw + r1.xyzw); // o0.xyzw = saturate(r0.xxxx * r2.xyzw + r1.xyzw);
  return;
}
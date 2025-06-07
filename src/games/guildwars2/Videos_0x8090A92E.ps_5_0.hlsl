#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s1_s, v0.xy).w;
  r0.xyzw = cb0[1].xyzw * r0.xxxx;
  r1.x = t0.Sample(s0_s, v0.xy).w;
  r0.xyzw = r1.xxxx * cb0[4].xyzw + r0.xyzw;
  r1.x = t2.Sample(s2_s, v0.xy).w;
  r0.xyzw = r1.xxxx * cb0[2].xyzw + r0.xyzw;
  r0.xyzw = cb0[3].xyzw + r0.xyzw;
  o0.xyzw = cb0[0].xyzw * r0.xyzw;
  o0 = saturate(o0);
  o0.rgb = InverseToneMap(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
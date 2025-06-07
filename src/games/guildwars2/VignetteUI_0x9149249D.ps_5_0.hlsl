#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.Sample(s1_s, v0.zw).xyz;
  r0.zw = float2(1,2) + -r0.zz;
  r0.xy = cb0[3].xy * r0.ww + -r0.xy;
  r0.z = saturate(r0.z);
  r0.z = 9.99999975e-05 + r0.z;
  r0.xy = saturate(r0.xy / r0.zz);
  r0.y = 1 + -r0.y;
  r0.x = r0.x * r0.y;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.w = r1.w * r0.x;
  r0.xyzw = cb0[0].xyzw * r1.xyzw;
  r1.x = cb0[0].w * r1.w + -cb0[1].x;
  if (r1.x < 0) discard;
  o0.xyzw = r0.xyzw;
  o0 = saturate(o0);
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
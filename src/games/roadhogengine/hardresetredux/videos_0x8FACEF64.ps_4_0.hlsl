#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
cbuffer cb1 : register(b1){
  float4 cb1[4];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cmp(v1.xy < cb1[3].xy);
  r0.xy = r0.xy ? float2(1,1) : 0;
  r0.x = dot(r0.xy, float2(1,1));
  r0.yz = cmp(cb1[3].zw < v1.xy);
  r0.yz = r0.yz ? float2(1,1) : 0;
  r0.y = dot(r0.yz, float2(1,1));
  r0.x = r0.x + r0.y;
  r0.x = min(1, r0.x);
  r1.xyzw = t2.Sample(s5_s, v1.xy).xyzw;
  r0.y = -0.5 + r1.x;
  r1.xyzw = t1.Sample(s5_s, v1.xy).xyzw;
  r0.z = -0.5 + r1.x;
  r1.xyzw = t0.Sample(s5_s, v1.xy).xyzw;
  r0.w = -0.0627449974 + r1.x;
  r1.x = 1.16400003 * r0.w;
  r1.yz = r0.zz * float2(-0.213,2.11500001) + r1.xx;
  r1.xy = r0.yy * float2(1.79299998,-0.533999979) + r1.xy;
  r0.yzw = cb1[2].xyz * r1.xyz;
  r1.xyz = cb1[2].www * r0.yzw;
  r2.x = 0;
  r2.w = cb1[2].w;
  r1.w = cb1[2].w;
  r2.xyzw = r2.xxxw + -r1.xyzw;
  o0.xyzw = r0.xxxx * r2.xyzw + r1.xyzw;
  //o0 = saturate(o0);
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
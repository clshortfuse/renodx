#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[23];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s2_s, v2.xy).xyzw;
  r0.x = -v3.x + r0.w;
  r0.y = v3.z + -r0.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r1.xyz = v1.xyz;
  r1.w = 1;
  r1.xyzw = cb0[3].xyzw * r1.xyzw;
  r1.xyzw = float4(2,2,2,1) * r1.xyzw;
  r0.xz = cb0[2].xy * cb1[0].yy + v6.xy;
  r2.xyzw = t1.Sample(s0_s, r0.xz).xyzw;
  r1.xyzw = r2.xyzw * r1.xyzw;
  r1.xyz = r1.xyz * r1.www;
  r0.xz = cb0[4].zw * cb1[0].yy + v6.zw;
  r2.xyzw = t2.Sample(s1_s, r0.xz).xyzw;
  r2.xyzw = cb0[5].xyzw * r2.xyzw;
  r2.xyz = r2.xyz * r2.www;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r0.x = cb0[22].w * cb0[6].x;
  r0.x = v3.y * r0.x;
  r0.z = min(1, r0.x);
  r0.x = 0.5 * r0.x;
  r0.z = sqrt(r0.z);
  r0.w = saturate(r0.y * v3.y + r0.x);
  r0.x = r0.y * v3.y + -r0.x;
  r0.y = r0.w * r0.z;
  r1.xyzw = r0.yyyy * r2.xyzw + r1.xyzw;
  r0.y = cb0[22].w * cb0[4].y;
  r0.z = v3.y * r0.y;
  r0.y = r0.y * v3.y + 1;
  r0.x = r0.z * 0.5 + r0.x;
  r0.x = saturate(r0.x / r0.y);
  r0.x = 1 + -r0.x;
  r0.xyzw = r1.xyzw * r0.xxxx;
  o0.xyzw = v1.wwww * r0.xyzw;
  o0.w = saturate(o0.w);
  if(injectedData.rolloffUI == 1.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  } else if(injectedData.rolloffUI == 2.f){
    o0.xyz = saturate(o0.xyz);
  }
  return;
}
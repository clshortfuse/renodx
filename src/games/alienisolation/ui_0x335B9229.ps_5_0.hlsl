#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 03:22:36 2024

cbuffer Constants : register(b0)
{
  float4 fsize : packoffset(c0);
  float4 texscale : packoffset(c1);
}

SamplerState sampler_tex_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0,0,0,0);
  r1.x = -fsize.x;
  while (true) {
    r1.z = cmp(fsize.x < r1.x);
    if (r1.z != 0) break;
    r2.xyzw = r0.xyzw;
    r1.y = -fsize.y;
    while (true) {
      r1.z = cmp(fsize.y < r1.y);
      if (r1.z != 0) break;
      r1.zw = r1.xy * texscale.xy + v2.xy;
      r3.xyzw = tex.SampleLevel(sampler_tex_s, r1.zw, 0).xyzw;
      r2.xyzw = r3.xyzw + r2.xyzw;
      r1.y = 1 + r1.y;
    }
    r0.xyzw = r2.xyzw;
    r1.x = 1 + r1.x;
  }
  r0.xyzw = fsize.wwww * r0.xyzw;
  r1.xyz = v1.xyz;
  r1.w = 1;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = v1.wwww * r0.xyzw;
  o0.xyzw = v0.xyzw * r0.wwww + r0.xyzw;

  o0 = UIScale(o0);
  return;
}
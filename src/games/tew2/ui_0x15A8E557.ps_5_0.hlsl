// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 16 22:01:36 2024
// UI, Font

#include "./shared.h"

cbuffer fblock : register(b0)
{
  float4 font480p : packoffset(c0);
  float4 font480prate : packoffset(c1);
}

SamplerState transmap_samp_state_s : register(s0);
Texture2D<float4> transmap_samp : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : TEXCOORD0,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v1.x >= 1);
  r0.yz = transmap_samp.Sample(transmap_samp_state_s, v1.xy, int2(0, 0)).xw;
  r0.x = r0.x ? r0.z : r0.y;
  r0.y = ddy_coarse(v1.y);
  r1.z = -r0.y * 0.25 + v1.y;
  r1.w = r0.y * 0.25 + v1.y;
  r0.y = ddx_coarse(v1.x);
  r1.x = -r0.y * 0.25 + v1.x;
  r2.x = r0.y * 0.25 + v1.x;
  r1.y = frac(r1.x);
  r0.y = transmap_samp.SampleBias(transmap_samp_state_s, r1.yz, -1).w;
  r3.z = transmap_samp.SampleBias(transmap_samp_state_s, r1.yw, -1).w;
  r0.z = r0.x + r0.y;
  r3.x = r0.z + r3.z;
  r0.z = max(r0.x, r0.y);
  r0.y = r3.z + r0.y;
  r3.y = max(r0.z, r3.z);
  r0.z = transmap_samp.SampleBias(transmap_samp_state_s, r1.xz, -1).x;
  r2.zw = r1.wz;
  r1.w = transmap_samp.SampleBias(transmap_samp_state_s, r1.xw, -1).x;
  r0.w = cmp(r1.x >= 1);
  r1.x = r0.x + r0.z;
  r0.x = max(r0.x, r0.z);
  r0.z = r1.w + r0.z;
  r0.y = r0.w ? r0.y : r0.z;
  r1.z = max(r0.x, r1.w);
  r1.y = r1.x + r1.w;
  r0.xzw = r0.www ? r3.xyz : r1.yzw;
  r0.w = r0.w + r0.w;
  r0.w = max(r0.z, r0.w);
  r2.y = frac(r2.x);
  r1.x = transmap_samp.SampleBias(transmap_samp_state_s, r2.yw, -1).w;
  r1.y = transmap_samp.SampleBias(transmap_samp_state_s, r2.yz, -1).w;
  r3.y = max(r1.x, r0.w);
  r0.w = transmap_samp.SampleBias(transmap_samp_state_s, r2.xz, -1).x;
  r1.z = transmap_samp.SampleBias(transmap_samp_state_s, r2.xw, -1).x;
  r1.w = cmp(r2.x >= 1);
  r0.x = r0.x + r0.w;
  r0.z = max(r0.z, r0.w);
  r0.w = r0.y + r0.w;
  r0.y = r1.y + r0.y;
  r3.x = r1.y + r1.x;
  r0.yw = r0.yw + r1.xz;
  r0.y = r1.w ? r0.y : r0.w;
  r0.y = 0.25 * r0.y;
  r1.y = max(r0.z, r1.z);
  r1.x = r0.x + r1.z;
  r0.xz = r1.ww ? r3.xy : r1.xy;
  r0.x = r0.x * 0.200000003 + -r0.z;
  r0.x = font480prate.x * r0.x + r0.z;
  r0.z = cmp(font480p.x < 0.5);
  r0.x = r0.z ? r0.y : r0.x;
  o0.w = v0.w * r0.x;
  o0.xyz = v0.xyz;
    
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
    o0.rgb *= injectedData.toneMapUINits / 80.f; //Added ui slider
  return;
}
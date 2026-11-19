#include "./shared.h"
#include "./rcas.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Wed Nov 18 14:50:47 2026

cbuffer cbUser : register(b10)
{
  float4 u_texture_info[3] : packoffset(c0);
}

SamplerState s_Source_sampler_s : register(s0);
SamplerState s_Velocity_sampler_s : register(s1);
Texture2D<float4> s_Source_NedSmpignorenametexture : register(t0);
Texture2D<float4> s_Velocity : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  // Game's velocity-adaptive sharpen is replaced by Lilium RCAS (custom_rcas).
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-0.5,-0.5,0.5,0.5) * u_texture_info[0].xyxy;
  r0.xyzw = v1.xyxy * u_texture_info[0].zwzw + r0.xyzw;
  r1.xyzw = s_Velocity.Gather(s_Velocity_sampler_s, r0.xy).xyzw;
  r0.xyzw = s_Velocity.Gather(s_Velocity_sampler_s, r0.zw).xyzw;
  r2.x = r1.x + r1.y;
  r2.x = r2.x + r1.z;
  r2.x = r2.x + r1.w;
  r1.xyzw = -r2.xxxx * float4(0.25,0.25,0.25,0.25) + r1.xyzw;
  r1.x = dot(r1.xyzw, r1.xyzw);
  r1.y = r0.x + r0.y;
  r1.y = r1.y + r0.z;
  r1.y = r1.y + r0.w;
  r0.xyzw = -r1.yyyy * float4(0.25,0.25,0.25,0.25) + r0.xyzw;
  r0.x = dot(r0.xyzw, r0.xyzw);
  r0.x = 0.25 * r0.x;
  r0.x = r1.x * 0.25 + r0.x;
  r0.x = r0.x * 0.5 + -u_texture_info[1].x;
  r0.x = r0.x / u_texture_info[1].z;
  r0.x = 1 + -r0.x;
  r0.xyz = saturate(r0.xxx);
  r0.w = cmp(0 != u_texture_info[1].w);
  if (r0.w != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  int2 pixel = int2(v0.xy);
  uint scene_width, scene_height;
  s_Source_NedSmpignorenametexture.GetDimensions(scene_width, scene_height);
  int2 scene_max = int2(scene_width, scene_height) - 1;
  float peak = max(RENODX_PEAK_WHITE_NITS / max(RENODX_GRAPHICS_WHITE_NITS, 1.f), 1e-6f);
  float encoding = RENODX_INTERMEDIATE_ENCODING;
  o0.xyz = max(0.f, ApplyLiliumRCAS(s_Source_NedSmpignorenametexture, pixel, scene_max, shader_injection.custom_rcas, peak, encoding));
  o0.w = saturate(s_Source_NedSmpignorenametexture.Load(int3(pixel, 0)).w);
  return;
}

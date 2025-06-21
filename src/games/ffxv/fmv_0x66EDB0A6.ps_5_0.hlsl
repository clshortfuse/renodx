// ---- Created with 3Dmigoto v1.3.16 on Thu Jun 19 13:11:25 2025
#include "shared.h"
cbuffer BinkCB_PS : register(b0)
{
  float4 g_crc : packoffset(c0);
  float4 g_cbc : packoffset(c1);
  float4 g_adj : packoffset(c2);
  float4 g_yscale : packoffset(c3);
  uint g_flag : packoffset(c4);
}

SamplerState g_sampler_s : register(s0);
Texture2D<float> g_texture_y : register(t0);
Texture2D<float> g_texture_cr : register(t1);
Texture2D<float> g_texture_cb : register(t2);
Texture2D<float> g_texture_alpha : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_texture_y.Sample(g_sampler_s, v1.xy).x;
  r0.y = g_texture_cr.Sample(g_sampler_s, w1.xy).x;
  r0.z = g_texture_cb.Sample(g_sampler_s, w1.xy).x;
  r0.w = g_texture_alpha.Sample(g_sampler_s, v1.xy).x;
  r1.xyz = g_crc.xyz * r0.yyy;
  r1.xyz = g_yscale.xyz * r0.xxx + r1.xyz;
  r0.xyz = g_cbc.xyz * r0.zzz + r1.xyz;
  r0.xyz = g_adj.xyz + r0.xyz;
  r1.xy = g_flag & int2(1,2);
  o0.w = r1.x ? r0.w : 1;
  if (r1.y != 0) {
    r1.xyzw = cmp(float4(0.0392800011,0.0392800011,0.0392800011,0.0392800011) >= r0.yzxy);
    r2.xyzw = float4(0.0773993805,0.0773993805,0.0773993805,0.0773993805) * r0.yzxy;
    r3.xyzw = float4(0.0549999997,0.0549999997,0.0549999997,0.0549999997) + r0.yzxy;
    r3.xyzw = float4(0.947867334,0.947867334,0.947867334,0.947867334) * r3.xyzw;
    r3.xyzw = log2(r3.xyzw);
    r3.xyzw = float4(2.4000001,2.4000001,2.4000001,2.4000001) * r3.xyzw;
    r3.xyzw = exp2(r3.xyzw);
    r1.xyzw = r1.xyzw ? r2.xyzw : r3.xyzw;
    r2.xy = float2(0.627399981,0.329299986) * r1.zw;
    r0.w = r2.x + r2.y;
    r0.w = r1.y * 0.0432999991 + r0.w;
    r2.xyz = float3(0.919499993,0.0164000001,0.0879999995) * r1.xzw;
    r1.x = r1.z * 0.0691 + r2.x;
    r1.x = r1.y * 0.0114000002 + r1.x;
    r1.z = r2.y + r2.z;
    r1.y = r1.y * 0.895600021 + r1.z;
    r1.z = cmp(0.00313080009 >= r0.w);
    r1.w = 12.9200001 * r0.w;
    r0.w = log2(r0.w);
    r0.w = 0.416666657 * r0.w;
    r0.w = exp2(r0.w);
    r0.w = r0.w * 1.05499995 + -0.0549999997;
    o0.x = r1.z ? r1.w : r0.w;
    r0.w = cmp(0.00313080009 >= r1.x);
    r1.z = 12.9200001 * r1.x;
    r1.x = log2(r1.x);
    r1.x = 0.416666657 * r1.x;
    r1.x = exp2(r1.x);
    r1.x = r1.x * 1.05499995 + -0.0549999997;
    o0.y = r0.w ? r1.z : r1.x;
    r0.w = cmp(0.00313080009 >= r1.y);
    r1.x = 12.9200001 * r1.y;
    r1.y = log2(r1.y);
    r1.y = 0.416666657 * r1.y;
    r1.y = exp2(r1.y);
    r1.y = r1.y * 1.05499995 + -0.0549999997;
    o0.z = r0.w ? r1.x : r1.y;
  } else {
    o0.xyz = r0.xyz;
  }

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);

    float videoPeak = min(RENODX_PEAK_WHITE_NITS, 400.f);

    float peak = videoPeak / (RENODX_DIFFUSE_WHITE_NITS / 203.f);
        
    // o0.rgb = renodx::color::gamma::Decode(o0.rgb, 2.4f);  // 2.4 for BT2446a
    o0.rgb = renodx::tonemap::inverse::bt2446a::BT709(o0.rgb, 100.f, videoPeak);
    o0.rgb /= videoPeak;                                                          // Normalize to 1.0f = peak;
    o0.rgb *= min(RENODX_PEAK_WHITE_NITS, 400.f) /
                  RENODX_DIFFUSE_WHITE_NITS;     // 1.f = game nits

    // Inverse AutoHDR?
  }

  return;
}
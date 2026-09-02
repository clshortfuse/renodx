#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Apr  1 22:15:40 2025
Texture3D<float4> t91 : register(t91);  // UI LUT

Texture2D<float4> t89 : register(t89);  // scene

Texture2D<float4> t88 : register(t88);  // UI

SamplerState s9_s : register(s9);

SamplerState s2_s : register(s2);

cbuffer cb5 : register(b5) {
  float4 cb5[6];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = floor(v0.xy);
  r0.xy = (uint2)r0.xy;
  r0.x = mad((int)r0.x, 0x0019660d, (int)r0.y);
  r0.y = (uint)cb5[5].x;
  r0.x = (int)r0.y + (int)r0.x;
  r0.y = (int)r0.x ^ 61;
  r0.x = (uint)r0.x >> 16;
  r0.x = (int)r0.x ^ (int)r0.y;
  r0.x = (int)r0.x * 9;
  r0.y = (uint)r0.x >> 4;
  r0.x = (int)r0.y ^ (int)r0.x;
  r0.x = (int)r0.x * 0x27d4eb2d;
  r0.y = (uint)r0.x >> 15;
  r0.x = (int)r0.y ^ (int)r0.x;
  r0.x = (uint)r0.x;
  r0.x = r0.x * 4.65661287e-10 + -1;
  r0.x = -r0.x * cb5[5].y + 1;
  r1.xyzw = t89.Sample(s2_s, v1.xy).xyzw;

  // Render
  float3 t89_color = r1.rgb;

  // Custom Dithering (broken decompile)
  // r0.xyz = r1.xyz * r0.xxx;
  r0.xyz = r1.xyz;
  r1.xyz = min(cb5[4].zzz, r0.xyz);
  r0.xyzw = t88.Sample(s2_s, v1.xy).xyzw;

  // UI
  float3 t88_color = r0.rgb;

  r2.x = max(1.0e-07, r0.w);
  r2.x = rcp(r2.x);
  r2.xyz = saturate(r2.xxx * r0.xyz);
  r2.xyz = t91.SampleLevel(s9_s, r2.xyz * 0.96875 + 0.015625, 0).xyz;

  // decode from pq, convert from bt2020 to bt709, encode in srgb, blend scene and ui, decode from srgb, divide by 80 for scrgb encoding and return
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float ui_alpha = r0.w;
    float scene_alpha = r1.w;
    float inverse_ui_alpha = 1.f - ui_alpha;

    float3 scene_bt2020 = renodx::color::pq::DecodeSafe(r1.rgb, 1.f);
    float3 ui_bt2020 = renodx::color::pq::DecodeSafe(r2.rgb, 1.f);

    float3 scene_bt709 = renodx::color::bt709::from::BT2020(scene_bt2020);
    float3 ui_bt709 = renodx::color::bt709::from::BT2020(ui_bt2020);
#if RENODX_GAME_GAMMA_CORRECTION
    float3 scene_srgb = renodx::color::gamma::EncodeSafe(scene_bt709);
    float3 ui_srgb = renodx::color::gamma::EncodeSafe(ui_bt709);
#else
    float3 scene_srgb = renodx::color::srgb::EncodeSafe(scene_bt709);
    float3 ui_srgb = renodx::color::srgb::EncodeSafe(ui_bt709);
#endif

    float3 blended_srgb = mad(scene_srgb, inverse_ui_alpha, ui_srgb * ui_alpha);

#if RENODX_GAME_GAMMA_CORRECTION
    float3 blended_bt709 = renodx::color::gamma::DecodeSafe(blended_srgb);
#else
    float3 blended_bt709 = renodx::color::srgb::DecodeSafe(blended_srgb);
#endif

    o0.w = mad(scene_alpha, inverse_ui_alpha, ui_alpha);
    o0.rgb = blended_bt709 / 80.f;
    return;
  }

  r0.xyz = r2.xyz * r0.www;
  r2.x = 1 + -r0.w;
  r0.xyzw = r2.xxxx * r1.xyzw + r0.xyzw;
  r0.xyz = log2(abs(r0.xyz));
  o0.w = r0.w;
  r0.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyz;
  r0.xyz = -r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r2.xyz = cmp(r1.xyz < float3(0, 0, 0));
  r1.xyz = r2.xyz ? float3(0, 0, 0) : r1.xyz;
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(10000, 10000, 10000) * r0.xyz;

  // BT2020 => XYZ
  r1.x = dot(r0.xyz, float3(0.636958182, 0.144616887, 0.168880954));
  r1.y = dot(r0.xyz, float3(0.26270026, 0.677998006, 0.0593017116));
  r1.z = dot(r0.yz, float2(0.0280726831, 1.06098497));

  // XYZ => BT709
  r0.x = dot(r1.xyz, float3(3.2409699, -1.5373832, -0.498610765));
  r0.y = dot(r1.xyz, float3(-0.969243586, 1.87596726, 0.0415550619));
  r0.z = dot(r1.xyz, float3(0.0556300581, -0.203976914, 1.05697179));
  o0.xyz = float3(0.0125000002, 0.0125000002, 0.0125000002) * r0.xyz;

  // output is in scrgb
  return;
}

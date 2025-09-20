#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Fri Sep 19 22:13:38 2025
Texture2D<float4> texture_ui : register(t1);

Texture2D<float4> texture_scene : register(t0);

SamplerState sampler_ui : register(s1);

SamplerState sampler_scene : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    linear noperspective float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(asint(cb0[0].y) == 1);
  r1.xyzw = texture_scene.SampleLevel(sampler_scene, v1.xy, 0).xyzw;

  float ui_brightness = cb0[0].x;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    ui_brightness = RENODX_GRAPHICS_WHITE_NITS;
  }

  // DCI-P3 -> BT.2020
  r2.x = dot(r1.xyz, float3(0.753832817, 0.19859764, 0.047569409));
  r2.y = dot(r1.xyz, float3(0.0457446352, 0.941777706, 0.0124797793));
  r2.z = dot(r1.xyz, float3(-0.00121037732, 0.0176011082, 0.983608127));
  r0.xyz = r0.xxx ? r2.xyz : r1.xyz;

  // BT.709 -> BT.2020
  r0.xyz = cb0[0].yyy ? r0.xyz
                      : renodx::color::bt2020::from::BT709(r1.rgb);

  r0.rgb = ApplyGammaCorrectionAndToneMap(r0.rgb);

  r1.xyz = r0.xyz / ui_brightness;
  r2.xyz = float3(1, 1, 1) + r1.xyz;
  r1.xyz = r1.xyz / r2.xyz;
  r1.xyz = r1.xyz * ui_brightness + -r0.xyz;

  r2.xyzw = texture_ui.SampleLevel(sampler_ui, v1.xy, 0).xyzw;

  if (RENODX_GAMMA_CORRECTION_UI != 0.f) {
    r2.xyz = renodx::color::correct::Gamma(r2.rgb);
  }

  r0.xyz = r2.www * r1.xyz + r0.xyz;  // tonemap ui background

  r0.rgb = renodx::color::gamma::Encode(r0.rgb);

  r1.rgb = renodx::color::bt2020::from::BT709(r2.rgb);

  r1.xyz = ui_brightness * r1.xyz;

  r1.rgb = renodx::color::gamma::EncodeSafe(r1.rgb);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r2.www * r1.xyz + r0.xyz;

  o0.rgb = renodx::color::gamma::DecodeSafe(r0.rgb);

  r0.x = 1 + -r2.w;
  o0.w = r1.w * r0.x + r2.w;
  return;
}

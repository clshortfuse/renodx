#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Oct 24 20:31:46 2026
// Final scene copy used instead of 0x29CCB91A when motion blur is disabled.
// Reads the post-upscaler color and writes the swapchain.

cbuffer _Globals : register(b0)
{
  float3 ColorScale : packoffset(c0);
  float4 OverlayColor : packoffset(c1);
  float InverseGamma : packoffset(c2);
}

SamplerState SceneColorTexture_s : register(s0);
Texture2D<float4> SceneColorTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // An unbound injection buffer keeps the exact original shader path.
  bool has_config = shader_injection.layout_version == GEARS_INJECTION_LAYOUT_VERSION
      && RENODX_PEAK_WHITE_NITS > 0.f
      && RENODX_DIFFUSE_WHITE_NITS > 0.f && RENODX_GRAPHICS_WHITE_NITS > 0.f;
  bool use_hdr = has_config && RENODX_TONE_MAP_TYPE != GEARS_TONE_MAP_VANILLA;
  bool linear_dlss = has_config && shader_injection.dlss_linear != 0.f;

  r0.xyzw = SceneColorTexture.Sample(SceneColorTexture_s, v0.xy).xyzw;
  // DLSS upscaling received linear light (dlss.hpp). Restore the game's gamma
  // domain before the color scale, fade and gamma, as 0x29CCB91A does per tap.
  [branch]
  if (linear_dlss) r0.xyz = renodx::color::gamma::EncodeSafe(r0.xyz, 2.2f);
  r1.xyz = ColorScale.xyz * r0.xyz;
  r0.xyz = -r0.xyz * ColorScale.xyz + OverlayColor.xyz;
  // Vanilla: saturate(OverlayColor.www * r0.xyz + r1.xyz).
  r0.xyz = use_hdr ? max(0.f, OverlayColor.www * r0.xyz + r1.xyz)
                   : saturate(OverlayColor.www * r0.xyz + r1.xyz);
  r0.xyz = max(float3(9.99999975e-005,9.99999975e-005,9.99999975e-005), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = InverseGamma * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  [branch]
  if (use_hdr && linear_dlss) {
    // DLSS reconstruction can overshoot the already mapped input. Limit the
    // brightest channel by scaling RGB together, matching 0x29CCB91A. The
    // proxy measures this composite against UI white.
    float encoded_peak = pow(RENODX_PEAK_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS, 1.f / 2.2f);
    float maximum = max(o0.x, max(o0.y, o0.z));
    o0.xyz *= min(1.f, encoded_peak / max(maximum, 1e-6f));
  }
  o0.w = 1;
  return;
}

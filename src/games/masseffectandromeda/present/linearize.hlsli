#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_LINEARIZE_HLSLI_
#define SRC_GAMES_MASSEFFECTANDROMEDA_LINEARIZE_HLSLI_

#include "../shared.h"

// Scene linearization for the HDR presents, shared by the present center and the RCAS taps so they
// can't drift. The lut3d present twins (MEA_PRESENT_LUT3D) apply a vanilla 32^3 calibration/filter
// LUT (t5, PQ space, coords *31/32 + 1/64) before the 1D output LUT linearize.
//   MEA_PRESENT_LUT3D  required axis, enforced here because this file both reads it and owns the t5
//                      declaration it gates. Defaulting it to 0 on a lut3d row would drop the
//                      calibration pass, never declare t5, and still compile clean.
#ifndef MEA_PRESENT_LUT3D
#error "Define MEA_PRESENT_LUT3D (0 = no vanilla calibration LUT, 1 = 32^3 calibration LUT at t5) before including linearize.hlsli."
#endif

#if MEA_PRESENT_LUT3D
Texture3D<float4> calibLutTexture : register(t5);
#endif

// Game's 1D output LUT: linearizes the PQ-encoded graded buffer to scene-linear (1.0 = diffuse white).
// Private to this file by intent - LinearizeScene is its only caller, and keeping it here is what makes
// "the center tap and the RCAS neighbors linearize identically" a property of one file.
float3 SampleOutputLut(Texture1D<float4> lut_tex, SamplerState lut_smp, float3 color) {
  return float3(
      lut_tex.SampleLevel(lut_smp, color.r, 0.f).r,
      lut_tex.SampleLevel(lut_smp, color.g, 0.f).r,
      lut_tex.SampleLevel(lut_smp, color.b, 0.f).r);
}

float3 LinearizeScene(Texture1D<float4> lut_tex, SamplerState lut_smp, float3 scaled_rgb) {
  scaled_rgb = max(0.f, scaled_rgb);
#if MEA_PRESENT_LUT3D
  scaled_rgb = calibLutTexture.SampleLevel(lut_smp, renodx::lut::CenterTexel(scaled_rgb, 32.f), 0.f).rgb;
#endif
  return SampleOutputLut(lut_tex, lut_smp, scaled_rgb);
}

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_LINEARIZE_HLSLI_

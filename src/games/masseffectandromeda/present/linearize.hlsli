#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_LINEARIZE_HLSLI_
#define SRC_GAMES_MASSEFFECTANDROMEDA_LINEARIZE_HLSLI_

// Scene linearization for the HDR presents, shared by the present center and the RCAS taps so they
// can't drift. The lut3d present twins (MEA_PRESENT_LUT3D) apply a vanilla 32^3 calibration/filter
// LUT (t5, PQ space, coords *31/32 + 1/64) before the 1D output LUT linearize.
// Requires shared.h (SampleOutputLut) first.

#ifndef MEA_PRESENT_LUT3D
#define MEA_PRESENT_LUT3D 0
#endif

#if MEA_PRESENT_LUT3D
Texture3D<float4> calibLutTexture : register(t5);
#endif

float3 LinearizeScene(Texture1D<float4> lut_tex, SamplerState lut_smp, float3 scaled_rgb) {
  scaled_rgb = max(0.f, scaled_rgb);
#if MEA_PRESENT_LUT3D
  scaled_rgb = calibLutTexture.SampleLevel(lut_smp, renodx::lut::CenterTexel(scaled_rgb, 32.f), 0.f).rgb;
#endif
  return SampleOutputLut(lut_tex, lut_smp, scaled_rgb);
}

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_LINEARIZE_HLSLI_

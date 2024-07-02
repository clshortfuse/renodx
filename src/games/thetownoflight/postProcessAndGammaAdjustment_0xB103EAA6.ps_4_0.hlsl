#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

static bool HDR = true;
static bool TonemapHDR = true;
static float PaperWhiteNits = renodx::color::bt2408::REFERENCE_WHITE;
static float PeakWhiteNits = 1000.0;

// Final shader before UI draws in, this can be used as tonemapping shader
void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0 = t0.Sample(s0_s, v1.xy).xyzw;

  // Some contrast adjustments:
  float3 r1 = cb0[7].xyz;
  r0.xyz = r0.xyz * cb0[6].xxx + -r1.xyz;
#if 1
  r0.xyz = r0.xyz * cb0[6].yyy + r1.xyz;
#else  // Vanilla: has unnecessary "sature()"
  r0.xyz = saturate(r0.xyz * cb0[6].yyy + r1.xyz);
#endif

#if 1  // User secondary gamma (applies in gamma space) (defaults to 1) (fixed to allow negative scRGB values just in case)
  o0.xyzw = float4(pow(abs(r0.xyz), cb0[6].zzz) * sign(r0.xyz), saturate(r0.w));
#else
  o0.xyzw = r0.xyzw;
#endif

  // Tonemapping might also help to fix some scenes that end burning through the UI, possibly because the scene (background) had extremely high values
  if (HDR && TonemapHDR) {
    const float paperWhite = PaperWhiteNits / renodx::color::srgb::REFERENCE_WHITE;
    float3 linearColor = pow(abs(o0.xyz), 2.2) * sign(o0.xyz);
    linearColor *= paperWhite;

    const float peakWhite = PeakWhiteNits / renodx::color::srgb::REFERENCE_WHITE;
    const float highlightsShoulderStart = paperWhite;  // Don't tonemap the "SDR" range (in luminance), we want to keep it looking as it used to look in SDR
    linearColor = renodx::tonemap::dice::BT709(linearColor, peakWhite, highlightsShoulderStart);

    linearColor /= paperWhite;
    o0.xyz = pow(abs(linearColor), 1.0 / 2.2) * sign(linearColor);
  }
  // Leave output in gamma space and with a paper white of 80 nits even for HDR so we can blend in the UI just like in SDR (in gamma space) and linearize with an extra pass added at the end.

  return;
}
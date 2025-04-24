#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f;  // 50%
static const float DEFAULT_CONTRAST = 1.f;    // 50%
static const float DEFAULT_GAMMA = 1.f;

struct OutputSignature {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

void PrepareLutInput(inout float3 lut_input_color, float mid_gray_luminance) {
  if (RENODX_TONE_MAP_TYPE) {
    lut_input_color = renodx::tonemap::dice::BT709(lut_input_color, CUSTOM_DICE_PEAK, mid_gray_luminance);
  } else {
    lut_input_color = saturate(lut_input_color);
  }
}

OutputSignature FinalizeLutTonemap(float3 linearColor) {
  OutputSignature output;

  output.SV_Target_1 = dot(linearColor.rgb, float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  linearColor = renodx::draw::RenderIntermediatePass(linearColor);

  output.SV_Target = float4(linearColor.rgb, 0.f);
  return output;
}

OutputSignature LutToneMap(float3 untonemapped, float3 lutOutput, float2 TEXCOORD) {
  lutOutput = renodx::color::srgb::DecodeSafe(lutOutput);
  float3 final = lutOutput;

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    final = saturate(final);

    final = renodx::draw::ToneMapPass(untonemapped.rgb, final);
  }

  /* if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    final = renodx::effects::ApplyFilmGrain(
        final,
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f,
        1.f);
  } */

  return FinalizeLutTonemap(final);
}

OutputSignature LutToneMap(float3 untonemapped, float3 lutOutput, float2 TEXCOORD, float3 mid_gray) {
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    float mid_gray_luminance = renodx::color::y::from::BT709(mid_gray);

    untonemapped = untonemapped * mid_gray_luminance / 0.18f;
  }

  return LutToneMap(untonemapped, lutOutput, TEXCOORD);
}

OutputSignature LutToneMap(float3 untonemapped, float3 lutOutput, float2 TEXCOORD, float mid_gray_luminance) {
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    untonemapped = untonemapped * mid_gray_luminance / 0.18f;
  }

  return LutToneMap(untonemapped, lutOutput, TEXCOORD);
}

#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f;  // 50%
static const float DEFAULT_CONTRAST = 1.f;    // 50%
static const float DEFAULT_GAMMA = 1.f;

struct OutputSignature {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

void PrepareLutInput(inout float3 lut_input_color, float mid_gray_luminance) {
  /* if (RENODX_TONE_MAP_TYPE) {
    lut_input_color = renodx::tonemap::dice::BT709(lut_input_color, CUSTOM_DICE_PEAK, mid_gray_luminance);
  } */
}

OutputSignature FinalizeLutTonemap(float3 linearColor) {
  OutputSignature output;

  output.SV_Target_1 = dot(linearColor.rgb, float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  linearColor = renodx::draw::RenderIntermediatePass(linearColor);

  output.SV_Target = float4(linearColor.rgb, 0.f);
  return output;
}

OutputSignature LutToneMap(float3 untonemapped, float3 lutOutput, float2 TEXCOORD, bool enable_film_grain = false) {
  lutOutput = renodx::color::srgb::DecodeSafe(lutOutput);
  float3 final = lutOutput;

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    final = saturate(final);

    final = renodx::draw::ToneMapPass(untonemapped.rgb, final);
  }

  if (CUSTOM_GRAIN_TYPE > 0.f && CUSTOM_GRAIN_STRENGTH > 0.f && enable_film_grain) {
    final = renodx::effects::ApplyFilmGrain(
        final,
        TEXCOORD.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }

  return FinalizeLutTonemap(final);
}

OutputSignature LutToneMap(float3 untonemapped, float3 lutOutput, float2 TEXCOORD, float3 mid_gray, bool enable_film_grain = false) {
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    float mid_gray_luminance = renodx::color::y::from::BT709(mid_gray);

    untonemapped = untonemapped * mid_gray_luminance / 0.18f;
  }

  return LutToneMap(untonemapped, lutOutput, TEXCOORD, enable_film_grain);
}

OutputSignature LutToneMap(float3 untonemapped, float3 lutOutput, float2 TEXCOORD, float mid_gray_luminance, bool enable_film_grain = false) {
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    untonemapped = untonemapped * mid_gray_luminance / 0.18f;
  }

  return LutToneMap(untonemapped, lutOutput, TEXCOORD, enable_film_grain);
}

// clang-format off
static struct UELutBuilderConfig {
  float3 untonemapped_ap1;
  float3 untonemapped_bt709;
  float3 tonemapped_bt709;
  float3 graded_bt709;
} RENODX_UE_CONFIG;
// clang-format on

void SetUntonemappedAP1(float3 color) {
  RENODX_UE_CONFIG.untonemapped_ap1 = color;
  RENODX_UE_CONFIG.untonemapped_bt709 = renodx::color::bt709::from::AP1(RENODX_UE_CONFIG.untonemapped_ap1);
  RENODX_UE_CONFIG.tonemapped_bt709 = abs(RENODX_UE_CONFIG.untonemapped_bt709);
}

void SetTonemappedBT709(inout float color_red, inout float color_green, inout float color_blue) {
  // if (RENODX_TONE_MAP_TYPE == 0.f) return;
  float3 color = float3(color_red, color_green, color_blue);
  RENODX_UE_CONFIG.tonemapped_bt709 = color;

  if (CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION != 0.f
      || CUSTOM_COLOR_GRADE_HUE_CORRECTION != 0.f
      || CUSTOM_COLOR_GRADE_SATURATION_CORRECTION != 0.f
      || CUSTOM_COLOR_GRADE_HUE_SHIFT != 0.f) {
    color = renodx::draw::ApplyPerChannelCorrection(
        RENODX_UE_CONFIG.untonemapped_bt709,
        float3(color_red, color_green, color_blue),
        CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION,
        CUSTOM_COLOR_GRADE_HUE_CORRECTION,
        CUSTOM_COLOR_GRADE_SATURATION_CORRECTION,
        CUSTOM_COLOR_GRADE_HUE_SHIFT);
  }

  color = abs(color);
  color_red = color.r;
  color_green = color.g;
  color_blue = color.b;
}

void SetTonemappedBT709(inout float3 color) {
  SetTonemappedBT709(color.r, color.g, color.b);
}

// Used by LUTs
void SetTonemappedAP1(inout float color_red, inout float color_green, inout float color_blue) {
  // if (RENODX_TONE_MAP_TYPE == 0.f) return;
  float3 color = float3(color_red, color_green, color_blue);
  float3 bt709_color = renodx::color::bt709::from::AP1(color);
  SetTonemappedBT709(bt709_color);

  color = renodx::color::ap1::from::BT709(bt709_color);
  color_red = color.r;
  color_green = color.g;
  color_blue = color.b;
}

void SetTonemappedAP1(inout float3 color) {
  SetTonemappedAP1(color.r, color.g, color.b);
}

void SetGradedBT709(inout float3 color) {
  RENODX_UE_CONFIG.graded_bt709 = color;
  RENODX_UE_CONFIG.graded_bt709 *= sign(RENODX_UE_CONFIG.tonemapped_bt709);
}


#ifndef SRC_SAINTSROW2022_TONEMAP_HLSLI_
#define SRC_SAINTSROW2022_TONEMAP_HLSLI_

#include "../common.hlsli"
#include "./customtest31.hlsli"

namespace renodx_custom {
namespace tonemap {
namespace aces {

renodx::tonemap::aces::ODTConfig CreateODTConfig(
    float min_y,
    float max_y,
    float mid_y,
    bool stable_peak_exp_shift = false,
    float exp_shift_max_reference = 1000.f,
    float exp_shift_min_reference = 0.0001f) {
  renodx::tonemap::aces::ODTConfig config = renodx::tonemap::aces::CreateODTConfig(min_y, max_y);

  if (mid_y != 4.8f) {
    renodx::tonemap::aces::ODTConfig exp_shift_config;

    // Derive exp-shift from a fixed reference curve so peak changes are stable.
    if (stable_peak_exp_shift) {
      exp_shift_config = renodx::tonemap::aces::CreateODTConfig(exp_shift_min_reference, exp_shift_max_reference);
    } else {
      exp_shift_config = config;
    }
    float exp_shift = log2(renodx::tonemap::aces::InvSSTS(mid_y, exp_shift_config)) - log2(0.18f);
    float shift_log10 = exp_shift * log10(2.f);

    config.y_min.x -= shift_log10;
    config.y_mid.x -= shift_log10;
    config.y_max.x -= shift_log10;
  }

  return config;
}

}  // namespace aces
}  // namespace tonemap
}  // namespace renodx_custom

// Vanilla HDR puts scene 0.18 at 16 nits regardless of paper white (Volition ODT, t21).
// Relative to game white: 16 / 160, the paper white the curve was measured at.
static const float MID_GRAY_OUT = 0.1f;

// RenoDX (Enhanced): PsychoV-31 on pre-RRT AP1, matched to the SDR path (ACES 1.0 RRT + 48-nit ODT, dim surround)
// shown on a gamma 2.2 display: the anchor sits on that curve with its log-log slope as cone, flare fits the toe from
// -4 to -1 stops and highlight contrast fits +1 to +3 through the shoulder at peak = white (see NOTES.md).
float3 ApplyPsychoVToneMap(float3 untonemapped_ap1, float peak_ratio, int target_gamut) {
  const float mid_gray_in = 0.2141f;
  const float mid_gray_out = 0.13486f;
  const float cone_response_exponent = 1.493f;
  const float highlight_contrast = 0.90f;
  const float flare = 0.98f;
  return renodx::tonemap::psychov::custom_psychotm_test31(
      renodx::color::bt709::from::AP1(untonemapped_ap1),
      peak_ratio,
      RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS,
      cone_response_exponent * RENODX_TONE_MAP_CONTRAST,
      0.10f * pow(flare, 10.f) + 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
      highlight_contrast * RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
      RENODX_TONE_MAP_CONTRAST_SHADOWS,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
      RENODX_TONE_MAP_DECHROMA,
      mid_gray_in,
      mid_gray_out,
      0.f,
      1.f,
      target_gamut,
      1.5f,  // Compression
      1.f,   // Mean-A2 shadow source weight
      0.5f,  // Mean-A2 midgray source weight
      0.f,   // Mean-A2 highlight source weight
      renodx::tonemap::psychov::PSYCHO30_SOURCE_BOUNDARY_AP1,
      1.f);
}

// stops: log2(AP1) + 9.72, i.e. the vanilla ACEScc-style signal x 17.52, without Scene brightness.
// Returns linear BT.709 relative to game (diffuse) white.
float3 ApplySaintsRowToneMap(float3 stops) {
  float3 untonemapped_ap1 = exp2(stops - 9.72f);

  [branch] if (RENODX_TONE_MAP_TYPE == 1.f) {
    return ApplyPsychoVToneMap(
        untonemapped_ap1,
        RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS,
        GAME_HDR_OUTPUT ? renodx::tonemap::psychov::CUSTOM_PSYCHO31_TARGET_GAMUT_BT2020
                        : renodx::tonemap::psychov::CUSTOM_PSYCHO31_TARGET_GAMUT_BT709);
  }

  // RenoDX (Vanilla+)
  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));
  untonemapped_ap1 = max(0, renodx::color::ap1::from::BT709(renodx::tonemap::psychov::custom_psychograde_test31(
                                renodx::color::bt709::from::AP1(untonemapped_ap1), RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS,
                                RENODX_TONE_MAP_CONTRAST, 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f), RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS, RENODX_TONE_MAP_CONTRAST_SHADOWS,
                                RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, RENODX_TONE_MAP_DECHROMA, 0.18f, 0.18f,
                                renodx::tonemap::psychov::PSYCHO30_SOURCE_BOUNDARY_AP1)));

  float aces_min = 0.0001f / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  // Literal mids and exp-shift references per mode, so the reference curve folds at compile time.
  [branch] if (RENODX_GAMMA_CORRECTION != 0.f) {  // Matches SDR
    // RenderIntermediatePass applies the 2.2 EOTF emulation next; pre-correct so min/peak still land on target.
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
    // SDR constants; they match the ACES 1.0 48-nit ODT on 2.2 within ~1% from -3 to +1 stops (see NOTES.md).
    const float ACES_MID = 8.f;
    const float ACES_DIFFUSE = ACES_MID / MID_GRAY_OUT;
    float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(
                                untonemapped_ap1,
                                renodx_custom::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, 28.f))
                            / ACES_DIFFUSE;
    // The vanilla SDR path (target below 500 nits) applies the ACES ODT desaturation.
    return renodx::color::bt709::from::AP1(mul(renodx::tonemap::aces::ODT_SAT_MAT, tonemapped_ap1));
  }

  // Matches HDR: vanilla HDR mids (0.18 at 16 nits).
  const float ACES_MID = 16.f;
  const float ACES_DIFFUSE = ACES_MID / MID_GRAY_OUT;
  return renodx::color::bt709::from::AP1(
      renodx::tonemap::aces::ODTToneMap(
          untonemapped_ap1,
          renodx_custom::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, 1000.f))
      / ACES_DIFFUSE);
}

// RenoDX path of the uber composite, material and HDR Bink video: applies the vanilla per-channel scale and returns
// the intermediate encoding, which in SDR are the swap chain's code values (see the SDR overrides in shared.h).
float3 ApplySaintsRowScene(float3 stops, float3 tint) {
  return renodx::draw::RenderIntermediatePass(ApplySaintsRowToneMap(stops) * tint);
}

// Measurement overlay (see NOTES.md); keep 0 for release builds.
#ifndef SR_DEBUG_MEASURE
#define SR_DEBUG_MEASURE 0
#endif

#if SR_DEBUG_MEASURE
// Neutral-gray table per stop around 0.18, relative to white: vanilla (t21 / paper white) and RenoDX
// (Enhanced) evaluated at the vanilla peak / paper white ratio. Each pixel evaluates only its own row.
float3 DrawMeasureOverlay(
    float3 color, float2 position, Texture2D<float4> odt_lut, SamplerState odt_sampler,
    float tone_map_mode, float4 tone_map_params, float paper_white, float2 sdr_range, float user_gain_log2) {
  static const float2 PANEL_MIN = float2(32.f, 32.f);
  static const float2 PANEL_MAX = float2(1180.f, 540.f);
  static const float2 ORIGIN = float2(48.f, 48.f);
  static const float LINE = 24.f;
  if (any(position < PANEL_MIN) || any(position > PANEL_MAX)) return color;

  int row = int(floor((position.y - ORIGIN.y) / LINE));
  renodx::canvas::Context context = renodx::canvas::CreateContext(
      position, float2(ORIGIN.x, ORIGIN.y + max(row, 0) * LINE), float2(16.f, 24.f), color, 1.f);
  renodx::canvas::SetColor(context, 0x101418, 0.9f, 1.f);
  renodx::canvas::FillRect(context, PANEL_MIN, PANEL_MAX);
  renodx::canvas::SetColor(context, 0xFFFFFF, 1.f, 1.f);

  if (row == 0) {
    renodx::canvas::DrawText(context, 'P', 'W');
    renodx::canvas::InsertSpace(context);
    renodx::canvas::DrawFloat(context, paper_white, 0.f, 1.f);
    renodx::canvas::InsertSpaces(context, 2.f);
    renodx::canvas::DrawText(context, 'P', 'k');
    renodx::canvas::InsertSpace(context);
    renodx::canvas::DrawFloat(context, tone_map_params.w, 0.f, 0.f);
    renodx::canvas::InsertSpaces(context, 2.f);
    renodx::canvas::DrawText(context, 'M', 'o', 'd', 'e');
    renodx::canvas::InsertSpace(context);
    renodx::canvas::DrawFloat(context, tone_map_mode, 0.f, 0.f);
  } else if (row == 1) {
    renodx::canvas::DrawText(context, 'T', 'M', 'P');
    [unroll] for (int i = 0; i < 4; ++i) {
      renodx::canvas::InsertSpaces(context, 2.f);
      renodx::canvas::DrawFloat(context, tone_map_params[i], 0.f, 4.f);
    }
  } else if (row == 2) {
    renodx::canvas::DrawText(context, 'S', 'd', 'r');
    renodx::canvas::InsertSpace(context);
    renodx::canvas::DrawFloat(context, sdr_range.x, 0.f, 4.f);
    renodx::canvas::InsertSpace(context);
    renodx::canvas::DrawFloat(context, sdr_range.y, 0.f, 4.f);
    renodx::canvas::InsertSpaces(context, 2.f);
    renodx::canvas::DrawText(context, 'G', 'a', 'i', 'n');
    renodx::canvas::InsertSpace(context);
    renodx::canvas::DrawFloat(context, user_gain_log2, 0.f, 4.f, false, true);
  } else if (row == 3) {
    renodx::canvas::DrawText(context, 'S', 't', 'o', 'p');
    renodx::canvas::InsertSpaces(context, 3.f);
    renodx::canvas::DrawText(context, 'V', 'a', 'n', 'i', 'l', 'l', 'a');
    renodx::canvas::InsertSpaces(context, 5.f);
    renodx::canvas::DrawText(context, 'E', 'n', 'h', 'a', 'n', 'c', 'e', 'd');
  } else if (row >= 4 && row <= 18) {
    int stop = row - 10;
    float x = 0.18f * exp2(float(stop));
    uint2 size;
    odt_lut.GetDimensions(size.x, size.y);
    float u = ((log2(x) + 17.47393035888672f) / 33.f) * ((size.x - 1.f) / size.x) + 0.5f / size.x;
    float vanilla = exp2(odt_lut.SampleLevel(odt_sampler, float2(u, 0.5f), 0.f).x * 3.321928024291992f) / paper_white;
    renodx::canvas::DrawFloat(context, float(stop), 2.f, 0.f, false, true);
    renodx::canvas::InsertSpaces(context, 4.f);
    renodx::canvas::DrawFloat(context, vanilla, 3.f, 5.f);
    renodx::canvas::InsertSpaces(context, 2.f);
    renodx::canvas::DrawFloat(
        context,
        renodx::color::y::from::BT709(ApplyPsychoVToneMap(
            x.xxx, tone_map_params.w / paper_white, renodx::tonemap::psychov::CUSTOM_PSYCHO31_TARGET_GAMUT_BT2020)),
        3.f, 5.f);
  }
  return renodx::canvas::GetOutput(context).rgb;
}
#endif

#endif  // SRC_SAINTSROW2022_TONEMAP_HLSLI_

#include "./shared.h"

static float3 g_untonemapped;
static float g_gamma;
static float3 g_pre_sat;
static float3 g_post_tonemap;

float3 VanillaHableTonemap(float3 color, float w = 1.f) {
  float3 temp1 = color * 0.22 + 0.023;
  temp1 = color * temp1 + 0.002;
  float3 temp2 = color * 0.22 + 0.3;
  color = color * temp2 + 0.06;
  color = temp1 / color;
  color = -0.0333 + color;
  return color * w;
}

void PreTonemap(inout float3 color, float hdrParams)
{
  g_untonemapped = color;

  float3 midgray = VanillaHableTonemap(float3(0.18,0.18,0.18), hdrParams);
  g_untonemapped *= midgray / 0.18f;

  [branch]
  if (RENODX_TONE_MAP_TYPE) {
    color = renodx::tonemap::dice::BT709(color, 5.f, 1.f);
  }
}

void PostTonemap(inout float3 color, float gamma)
{
  g_gamma = gamma;
  g_post_tonemap = color;
}

void PreSaturationScaleEx(inout float3 color, float gamma, float saturationScale)
{
  color = renodx::math::SignPow(g_post_tonemap, gamma);
  g_pre_sat = color;
}

void OutColorAdjustments(inout float4 o0, float saturationScale)
{
  [branch]
  if (CUSTOM_SAT_STRENGTH != 1.f) {
    o0.rgb = lerp(g_pre_sat, o0.rgb, CUSTOM_SAT_STRENGTH);
  }

  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);

  [branch]
  if (CUSTOM_SAT_BRIGHTNESS && CUSTOM_SAT_STRENGTH != 0.f) {
    g_pre_sat = renodx::color::srgb::DecodeSafe(g_pre_sat);
    o0.rgb = renodx::color::correct::Chrominance(g_pre_sat, o0.rgb, 1.f);
  }

  o0.rgb = saturate(o0.rgb);

  [branch]
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 sdr_color = o0.rgb;

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    draw_config.tone_map_hue_correction = 0.f;
    draw_config.tone_map_hue_shift = 0.f;

    g_untonemapped = renodx::math::SignPow(g_untonemapped, g_gamma);
    g_untonemapped = renodx::color::srgb::DecodeSafe(g_untonemapped);

    g_untonemapped = lerp(sdr_color, g_untonemapped, saturate(renodx::color::y::from::BT709(g_untonemapped)));

    o0.rgb = renodx::draw::ToneMapPass(g_untonemapped, draw_config);

    o0.rgb = renodx::color::correct::Hue(o0.rgb, sdr_color, RENODX_TONE_MAP_HUE_CORRECTION);
    o0.rgb = renodx::color::correct::Chrominance(o0.rgb, sdr_color, RENODX_TONE_MAP_HUE_SHIFT);
  }

  o0 = renodx::draw::RenderIntermediatePass(o0);
}
#include "./DICE.hlsli"
#include "./shared.h"

float3 HueCorrectAP1(float3 incorrect_color_ap1, float3 correct_color_ap1, float hue_correct_strength = 0.5f) {
  float3 incorrect_color_bt709 = renodx::color::bt709::from::AP1(incorrect_color_ap1);
  float3 correct_color_bt709 = renodx::color::bt709::from::AP1(correct_color_ap1);

  float3 corrected_color_bt709 = renodx::color::correct::Hue(incorrect_color_bt709, correct_color_bt709, hue_correct_strength, 2u);
  float3 corrected_color_ap1 = renodx::color::ap1::from::BT709(corrected_color_bt709);
  return corrected_color_ap1;
}

float3 HueChromaCorrectAP1(float3 incorrect_color_ap1, float3 correct_color_ap1) {
  float3 incorrect_bt709 = renodx::color::bt709::from::AP1(incorrect_color_ap1);
  float3 correct_bt709 = renodx::color::bt709::from::AP1(correct_color_ap1);

  float3 incorrect_jch = renodx::color::dtucs::jch::from::BT709(incorrect_bt709);
  float3 correct_jch = renodx::color::dtucs::jch::from::BT709(correct_bt709);

  incorrect_jch.yz = float2(correct_jch.y * 1.125f, correct_jch.z);  // boost chroma

  float3 corrected_bt709 = renodx::color::bt709::from::dtucs::JCH(incorrect_jch);

  return renodx::color::ap1::from::BT709(corrected_bt709);
}

float3 ApplyFrostbiteAP1(float3 untonemapped_ap1, float hdr_scale) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

  float3 tonemapped_bt709 = renodx::tonemap::frostbite::BT709(untonemapped_bt709, hdr_scale, min(1.f, 0.75f * hdr_scale), 0.5f, 1.f);
  float3 tonemapped_ap1 = renodx::color::ap1::from::BT709(tonemapped_bt709);
  return tonemapped_ap1;
}

float3 ApplySDRToneMap(float3 untonemapped_ap1) {
  const float hdr_max = 100.f;  // SDR = 100.f

  const float contrast = 1.25f;  // SDR = 1.25f
  const float shoulder = 0.13f;  // SDR = 0.13f?
  const float mid_in = 0.5f;     // SDR = 0.5f
  const float mid_out = 1.f;     // SDR = 1.0f
  const float offset = 0.f;      // SDR = 0.0f
  const float inv_ln2 = 1.f / log(2.f);

  float sdr_277 = abs(untonemapped_ap1.r * 0.00999999977648258209228515625f);
  float sdr_279 = hdr_max * 0.00999999977648258209228515625f;
  float sdr_290 = (sdr_279 - shoulder) * mid_in;
  float sdr_291 = sdr_290 / contrast;
  float sdr_292 = sdr_277 - shoulder;
  bool sdr_295 = shoulder > 9.9999997473787516355514526367188e-06f;
  float sdr_296 = sdr_277 / shoulder;
  float sdr_306 = sdr_279 - (sdr_290 + shoulder);
  float sdr_307 = (contrast * sdr_279) / sdr_306;
  float sdr_318 = clamp(sdr_296, 0.0f, 1.0f);
  float sdr_322 = (sdr_318 * sdr_318) * (3.0f - (sdr_318 * 2.0f));
  float sdr_324 = sdr_291 + shoulder;
  float sdr_326 = float(sdr_277 > sdr_324);
  float sdr_334 = abs(untonemapped_ap1.g * 0.00999999977648258209228515625f);
  float sdr_335 = sdr_334 - shoulder;
  float sdr_338 = sdr_334 / shoulder;
  float sdr_354 = clamp(sdr_338, 0.0f, 1.0f);
  float sdr_358 = (sdr_354 * sdr_354) * (3.0f - (sdr_354 * 2.0f));
  float sdr_361 = float(sdr_334 > sdr_324);
  float sdr_369 = abs(untonemapped_ap1.b * 0.00999999977648258209228515625f);
  float sdr_370 = sdr_369 - shoulder;
  float sdr_373 = sdr_369 / shoulder;
  float sdr_389 = clamp(sdr_373, 0.0f, 1.0f);
  float sdr_393 = (sdr_389 * sdr_389) * (3.0f - (sdr_389 * 2.0f));
  float sdr_396 = float(sdr_369 > sdr_324);
  float3 tonemapped;
  tonemapped.r = ((((sdr_322 - sdr_326) * ((sdr_292 * contrast) + shoulder)) + ((sdr_279 - (exp2((((-0.0f) - ((sdr_292 - sdr_291) * sdr_307)) / sdr_279) * inv_ln2) * sdr_306)) * sdr_326)) + ((1.0f - sdr_322) * (sdr_295 ? ((exp2(log2(abs(sdr_296)) * mid_out) * shoulder) + offset) : offset)));
  tonemapped.g = ((((sdr_358 - sdr_361) * ((sdr_335 * contrast) + shoulder)) + ((sdr_279 - (exp2((((-0.0f) - ((sdr_335 - sdr_291) * sdr_307)) / sdr_279) * inv_ln2) * sdr_306)) * sdr_361)) + ((1.0f - sdr_358) * (sdr_295 ? ((exp2(log2(abs(sdr_338)) * mid_out) * shoulder) + offset) : offset)));
  tonemapped.b = ((((sdr_393 - sdr_396) * ((sdr_370 * contrast) + shoulder)) + ((sdr_279 - (exp2((((-0.0f) - ((sdr_370 - sdr_291) * sdr_307)) / sdr_279) * inv_ln2) * sdr_306)) * sdr_396)) + ((1.0f - sdr_393) * (sdr_295 ? ((exp2(log2(abs(sdr_373)) * mid_out) * shoulder) + offset) : offset)));
  return tonemapped.rgb;
}

float3 GetSDRMidGrayRatio() {
  float3 mid_gray = renodx::color::y::from::AP1(ApplySDRToneMap(float3(0.18f, 0.18f, 0.18f)));
  return (mid_gray / 0.18f);
}

float3 ApplyBlendedToneMap(float3 untonemapped_ap1, float peak_nits, float diffuse_white) {
  float3 sdr_tonemap = ApplySDRToneMap(untonemapped_ap1);

  float hdr_scale = peak_nits / diffuse_white;
#if RENODX_GAME_GAMMA_CORRECTION
  hdr_scale = renodx::color::correct::GammaSafe(hdr_scale, true);
#endif

  float3 hdr_untonemapped = untonemapped_ap1 * GetSDRMidGrayRatio();
  float3 hdr_tonemap = renodx::color::ap1::from::BT709(renodx::color::correct::GammaSafe(applyDICE(renodx::color::correct::GammaSafe(renodx::color::bt709::from::AP1(hdr_untonemapped)), diffuse_white, peak_nits, 0.5f), true));

  float3 sdr_tonemap_by_lum = HueChromaCorrectAP1(sdr_tonemap, hdr_untonemapped);

  float sdr_lum = renodx::color::y::from::AP1(sdr_tonemap_by_lum);
  return lerp(sdr_tonemap_by_lum, hdr_tonemap, saturate(sdr_lum));
}

float3 ApplyBlendedToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits, float diffuse_white) {
  float3 tonemapped = ApplyBlendedToneMap(untonemapped_ap1, peak_nits, diffuse_white);
  tonemapped = renodx::color::bt709::from::AP1(tonemapped);
#if RENODX_GAME_GAMMA_CORRECTION
  tonemapped = renodx::color::correct::GammaSafe(tonemapped);  // apply sRGB -> 2.2 gamma correction
#endif
  tonemapped = renodx::color::bt2020::from::BT709(tonemapped);
  tonemapped = renodx::color::pq::EncodeSafe(tonemapped, diffuse_white);
  return tonemapped;
}

float3 ApplyBlendedACESToneMapEncodePQ(float3 untonemapped_ap1, float peak_nits, float diffuse_white_nits) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1) / 32.f;

  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / diffuse_white_nits;
  float aces_max = (peak_nits / diffuse_white_nits);

  float3 untonemapped_ap0 = mul(renodx::color::BT709_TO_AP0_MAT, untonemapped_bt709);
  float3 untonemapped_rrt_ap1 = renodx::tonemap::aces::RRT(untonemapped_ap0);
  float3 tonemapped_ap1 = renodx::tonemap::aces::ODT(untonemapped_rrt_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;

  float3 hue_corrected_ap1 = HueCorrectAP1(tonemapped_ap1, untonemapped_rrt_ap1);

  float3 blended_color_ap1 = lerp(hue_corrected_ap1, tonemapped_ap1, saturate(hue_corrected_ap1));

  float3 blended_color_bt2020 = renodx::color::bt2020::from::AP1(blended_color_ap1);
  return renodx::color::pq::EncodeSafe(blended_color_bt2020, diffuse_white_nits);
}

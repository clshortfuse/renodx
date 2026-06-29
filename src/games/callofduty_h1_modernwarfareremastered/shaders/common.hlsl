#include "../shared.h"

// // (Copied from: ff7rebirth)
// // AdvancedAutoHDR pass to generate some HDR brightess out of an SDR signal.
// // This is hue conserving and only really affects highlights.
// // "sdr_color" is meant to be in "SDR range", as in, a value of 1 matching SDR white (something between 80, 100, 203, 300 nits, or whatever else)
// // https://github.com/Filoppi/PumboAutoHDR
// float3 PumboAutoHDR(float3 sdr_color) {
//   const float shoulder_pow = CUSTOM_MOV_SHOULDERPOW;
//   const float SDRRatio = max(renodx::color::y::from::BT2020(sdr_color), 0.f);

//   // Limit AutoHDR brightness, it won't look good beyond a certain level.
//   // The paper white multiplier is applied later so we account for that.
//   float target_max_luminance = min(RENODX_PEAK_WHITE_NITS, pow(10.f, ((log10(RENODX_DIFFUSE_WHITE_NITS) - 0.03460730900256) / 0.757737096673107)));
//   target_max_luminance = lerp(1.f, target_max_luminance, .5f);

//   const float auto_HDR_max_white = max(target_max_luminance / RENODX_DIFFUSE_WHITE_NITS, 1.f);
//   const float auto_HDR_shoulder_ratio = 1.f - max(1.f - SDRRatio, 0.f);
//   const float auto_HDR_extra_ratio = pow(max(auto_HDR_shoulder_ratio, 0.f), shoulder_pow) * (auto_HDR_max_white - 1.f);
//   const float auto_HDR_total_ratio = SDRRatio + auto_HDR_extra_ratio;
//   return sdr_color * renodx::math::SafeDivision(auto_HDR_total_ratio, SDRRatio, 1);  // Fallback on a value of 1 in case of division by 0
// }

#define RHSC_E (50.f/41.f)
float3 ReinhardScalableCached(float3 x) {
  return (x * RHSC_E) / (x * RHSC_E + 1.f);
}

renodx::draw::Config BuildConfig() {
  return renodx::draw::BuildConfig();
}

// //https://github.com/ronja-tutorials/ShaderTutorials/blob/master/Assets/047_InverseInterpolationAndRemap/Interpolation.cginc
// float invLerp(float from, float to, float value) {
//   return (value - from) / (to - from);
// }
// float4 invLerp(float4 from, float4 to, float4 value) {
//   return (value - from) / (to - from);
// }
// float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
//   float rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }
// float4 remap(float4 origFrom, float4 origTo, float4 targetFrom, float4 targetTo, float4 value){
//   float4 rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }

// float Pack2Int_In() {

// }

// void Pack2Int_Out() {

// }

float Tonemap_GetY(float3 color) {
  return renodx::color::y::from::BT709(color);
}

void Tonemap_SaveBlacks( in float3 colorUntonemapped, inout float4 r0) {
  // if (CUSTOM_UPGRADETONEMAP_SAVEBLACKS == 0) return;
  if (Tonemap_GetY(r0.xyz) <= CUSTOM_UPGRADETONEMAP_SAVEBLACKS)
    r0.xyz = renodx::color::correct::Luminance(colorUntonemapped, Tonemap_GetY(colorUntonemapped), CUSTOM_UPGRADETONEMAP_SAVEBLACKS);
}

void Tonemap_UpgradeTonemap0(inout float3 colorUntonemapped, in float4 r0) {
  if (RENODX_TONE_MAP_TYPE == 0) return;

  //save blacks
  Tonemap_SaveBlacks(colorUntonemapped, r0);

  //blowout colorUntonemapped
  colorUntonemapped = CUSTOM_GRADE_CHROMA < 1 ? renodx::tonemap::frostbite::BT709(colorUntonemapped, 10000, 0.25f, CUSTOM_GRADE_CHROMA, 1.f) : colorUntonemapped;

  //CUSTOM_GRADE_CHROMA
  colorUntonemapped = renodx::tonemap::UpgradeToneMap(
    colorUntonemapped, r0.xyz, r0.xyz, 
    CUSTOM_GRADE_CHROMA, 0
  );
}

void ADSSights_Scale(inout float4 o0) {
  o0.xyz *= CUSTOM_ADSSIGHT_MULTIPLIER;
}

void Tonemap_BloomScale(inout float4 color) {
  color.xyz *= CUSTOM_BLOOM_MULTIPLIER; 
  color.w = 1;
}

float PreExposure_GetOffset(float4 v) {
  float result;
  // switch (CUSTOM_PREEXPOSURE_OFFSET_MODE) {
  //   case 0: result = v.x; break;
  //   case 1: result = v.y; break;
  //   default: result = v.z; break;
  // }
  result = max(v.y, v.z);
  result *= CUSTOM_PREEXPOSURE_OFFSET_MULTIPLIER;
  return result;
}

float PreExposure_GetAutoexposure(float4 v) {
  float result;
  // switch (CUSTOM_PREEXPOSURE_AUTO_MODE) {
  //   case 0: result = v.x; break;
  //   case 1: result = v.y; break;
  //   default: result = v.z; break;
  // }
  result = v.y;
  result *= CUSTOM_PREEXPOSURE_AUTO_MULTIPLIER;
  return result;
}

float Tonemap_CalculatePreExposureMultiplier(float4 thresholds, float4 autoexp/*, float4 v2*/) 
{
  //v0.xyz = high, mid, low thresholds
  //v1.xyz = high, mid, low multipliers
  //v2 = color corrections?

  float target;
  target = PreExposure_GetOffset(thresholds) + PreExposure_GetAutoexposure(autoexp);
  target *= CUSTOM_PREEXPOSURE_FINAL;
  return target;
}

// void Tonemap_PrepColorUntonemapped(inout float3 colorUntonemapped, inout float4 r0) {
//   colorUntonemapped = r0.xyz;
//   colorUntonemapped = renodx::color::correct::Luminance(colorUntonemapped, Tonemap_GetY(colorUntonemapped), r0.w);
//   // colorUntonemapped = max(float3(0,0,0), colorUntonemapped); //clamp
//   r0.w = 1; //reset
// }

void Tonemap_RecoverYFromW(inout float4 r0) {
  if (RENODX_TONE_MAP_TYPE == 0) return;
  
  r0.xyz = renodx::color::correct::Luminance(r0.xyz, Tonemap_GetY(r0.xyz), r0.w, 1); //correct
  r0.w = 1; //reset
}

static renodx::debug::graph::Config graph_config;

void Tonemap_Do(
    inout float4 r0,
    float3 colorUntonemapped,
    float3 colorTonemapped,
    float2 uv,
    Texture2D<float4> texColor
) {
  colorUntonemapped = max(colorUntonemapped, 0.f);
  colorTonemapped = max(colorTonemapped, 0.f);
  r0.xyz = max(r0.xyz, 0.f);

  if (RENODX_TONE_MAP_TYPE > 0) {
    if (CUSTOM_IS_CALIBRATION)
      graph_config = renodx::debug::graph::DrawStart(
          uv,
          colorUntonemapped,
          texColor,
          RENODX_PEAK_WHITE_NITS,
          RENODX_DIFFUSE_WHITE_NITS
      );

    colorTonemapped = renodx::color::srgb::DecodeSafe(colorTonemapped);
    colorTonemapped = max(colorTonemapped, 0.f);

    float3 colorSDRNeutral;
    colorSDRNeutral = max(colorUntonemapped, 0.f);
    colorSDRNeutral = ReinhardScalableCached(colorSDRNeutral);
    colorSDRNeutral = max(colorSDRNeutral, 0.f);

    colorSDRNeutral = lerp(colorTonemapped, colorSDRNeutral, CUSTOM_GRADE_LUMA);
    colorSDRNeutral = max(colorSDRNeutral, 0.f);

    r0.xyz = renodx::draw::ToneMapPass(
        max(colorUntonemapped, 0.f),
        max(colorTonemapped, 0.f),
        max(colorSDRNeutral, 0.f)
    );

    r0.xyz = max(r0.xyz, 0.f);

    if (CUSTOM_IS_CALIBRATION)
      r0.xyz = renodx::debug::graph::DrawEnd(r0.xyz, graph_config);
  } else {
    r0.xyz = max(r0.xyz, 0.f);
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.xyz = max(r0.xyz, 0.f);
    r0.xyz = saturate(r0.xyz);
  }

  r0.xyz = max(r0.xyz, 0.f);
  r0.xyz = renodx::draw::RenderIntermediatePass(r0.xyz);
  r0.xyz = max(r0.xyz, 0.f);
  r0.w = max(r0.w, 0.f);
}
#include "../shared.h"

#define SHORT_MAX 32768

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

// float Min(in float2 v) return min()

#define RHSC_E (50.f/41.f)
float3 ReinhardScalableCached(float3 x) {
  return (x * RHSC_E) / (x * RHSC_E + 1.f);
}

float4 Tonemap_DrawError(in float4 color) {
  return lerp(color, float4(0.5, 0, 0, 1), 0.75f);
}

float Sum3(in float3 v) {
  return (v.x + v.y + v.z);
}

// void ADSSights_Scale(inout float4 o0) {
//   o0.xyz *= CUSTOM_ADSSIGHT_MULTIPLIER;
// }

void Tonemap_BloomScale(inout float4 color) {
  color.xyz *= CUSTOM_BLOOM_MULTIPLIER;
  color.w = 1;
}

void Tonemap_BloomScale(inout float3 color) {
  color.xyz *= CUSTOM_BLOOM_MULTIPLIER;
}

float PreExposure_GetOffset(in float4 v) {
  float result;
  result = max(v.y, v.z);
  result *= CUSTOM_PREEXPOSURE_OFFSET_MULTIPLIER;
  return result;
}

float PreExposure_GetAutoexposure(in float4 v) {
  float result;
  result = v.y;
  result *= CUSTOM_PREEXPOSURE_AUTO_MULTIPLIER;
  return result;
}

float Tonemap_CalculatePreExposureMultiplier(in float3 v1, in float3 v2, in float3 v3)
{
  float target;

  target = 0;
  target += max(v1.y, v1.z) * CUSTOM_PREEXPOSURE_OFFSET_MULTIPLIER;
  target += max(v2.y, v2.z) * CUSTOM_PREEXPOSURE_AUTO_MULTIPLIER;

  float v1diff = (1 - v1.x);
  target += max(target, v1diff);
  target /= 2;

  target *= CUSTOM_PREEXPOSURE_FINAL;
  return target;
}

#define MINIMUM_Y 0.00001f
// static renodx::debug::graph::Config graph_config;
float3 Tonemap_Do(float3 colorUntonemapped, float3 colorTonemapped, /* float3 colorSDRNeutral, */ float2 uv, Texture2D<float4> texColor) {
  float3 result;

  //decode
  colorTonemapped = max((float3)0, colorTonemapped);
  colorTonemapped = renodx::color::srgb::Decode(colorTonemapped);

  //ToneMapPass?
  if (RENODX_TONE_MAP_TYPE > 0) {
    //sum of colorTonemapped (save blacks)
    // const float sumTonemapped = Sum3(colorTonemapped);

    //colorTonemapped color
    // colorTonemapped = uv.x < 0.5 ? renodx::color::bt709::from::BT2020(colorTonemapped) : colorTonemapped;
    // colorTonemapped = renodx::color::bt709::from::BT2020(colorTonemapped);

    //graph start
    // if (CUSTOM_TONEMAP_DEBUG == 1) graph_config = renodx::debug::graph::DrawStart(uv, colorUntonemapped, texColor, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS);

    //colorUntonemapped clamp
    {
      colorUntonemapped = max((float3)0, colorUntonemapped);
    }
    //colorUntonemapped Frostbite (for blowout)
    {
      colorUntonemapped = CUSTOM_GRADE_CHROMA < 1.f ? renodx::tonemap::frostbite::BT709(colorUntonemapped, SHORT_MAX, CUSTOM_FROSTBITE_A, CUSTOM_FROSTBITE_B, CUSTOM_FROSTBITE_C) : colorUntonemapped;
    }
    //colorUntonemapped Contrast
    {
      colorUntonemapped = renodx::color::grade::Contrast(colorUntonemapped, CUSTOM_PREEXPOSURE_CONTRAST);
    }
    //colorUntonemapped black floor raise (counteracts contrast to match vanilla)
    {
      colorUntonemapped += CUSTOM_BLACKFLOORRAISE; //(0.0019f / 1.5f)
    }

    //LUMA GRADE
    float3 colorSDRNeutral;
    {
      //save blacks
      if (CUSTOM_GRADE_LUMA < 1 && Sum3(colorTonemapped) < MINIMUM_Y) {
        colorTonemapped = renodx::color::grade::Saturation(colorUntonemapped, 0);
        colorTonemapped = renodx::color::correct::Luminance(colorTonemapped, renodx::color::y::from::BT709(colorTonemapped), MINIMUM_Y, 1);
      }

      //use colorUntonemapped
      colorSDRNeutral = ReinhardScalableCached(colorUntonemapped);

      //CUSTOM_GRADE_LUMA
      colorSDRNeutral = lerp(colorTonemapped, colorSDRNeutral, CUSTOM_GRADE_LUMA);
    }

    //CHROMA GRADE
    {
      colorTonemapped = CUSTOM_GRADE_CHROMA < 1.f ? renodx::tonemap::UpgradeToneMap(colorTonemapped, colorUntonemapped, colorUntonemapped, 1-CUSTOM_GRADE_CHROMA, 0) : colorTonemapped; //a bit inverted, but its ok
    }

    //film grain
    {
      colorUntonemapped = CUSTOM_EXTRA_FILMGRAIN > 0 ? renodx::effects::ApplyFilmGrainColored(colorUntonemapped, uv, RANDOM_SEED, CUSTOM_EXTRA_FILMGRAIN) : colorUntonemapped;
    }

    //ToneMapPass
    {
      // [branch]
      // if (CUSTOM_TONEMAP_DEBUG <= 1.f) {
        renodx::draw::Config config = renodx::draw::BuildConfig();
        result = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral, config);
      // } else if (CUSTOM_TONEMAP_DEBUG == 2.f) {
      //   [flatten]
      //   if (uv.x < 1/3.f) {
      //     result = colorUntonemapped;
      //   } else if (uv.x < 2/3.f) {
      //     result = colorSDRNeutral;
      //   } else {
      //     result = colorTonemapped;
      //   }
      // }
    }

    //graph end
    // if (CUSTOM_TONEMAP_DEBUG == 1) result = renodx::debug::graph::DrawEnd(result, graph_config);
  } else {
    //just decode original
    result = colorTonemapped;
    result = saturate(result); //emulate SDR 0-1.
  }

  //RenderIntermediatePass
  result = renodx::draw::RenderIntermediatePass(result);

  return result;
}

float3 Tonemap_DrawUnknown(in float3 color, in float2 v1) {
  if (!CUSTOM_TONEMAP_UNVERIFIED) return color;

  // const float size = 0.1f;
  // const float size1 = 1 - size;
  // if (
  //   (v1.x > size && v1.x < size1) ||
  //   (v1.y > size && v1.y < size1)
  // ) return color;
  float3 color1;
  if (v1.x < 1/3.f) color1 = float3(1,0,0);
  else if (v1.x < 2/3.f) color1 = float3(0,1,0);
  else if (v1.x < 3/3.f) color1 = float3(0,0,1);
  return lerp(color, color1, 0.5f);
}

float3 Tonemap2nd_Do(in float3 colorTonemapped, in SamplerState s0_s, in Texture2D<float4> t0, in float2 v1) {
  float colorUntonemapped = t0.Sample(s0_s, v1.xy).xyz;
  return renodx::tonemap::UpgradeToneMap(colorUntonemapped, ReinhardScalableCached(colorUntonemapped), colorTonemapped, 1, 0); //apply color grade as salvage double ToneMapPass()
}
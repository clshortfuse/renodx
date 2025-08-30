#include "./shared.h"

#define SDR_NORMALIZATION_MAX 32768.0 //1 / 3.05175781e-005
// #define SDR_NOMRALIZATION_TRADEOFF 0.15 //TODO to reshade var instead?

// (Copied from: ff7rebirth)
// AdvancedAutoHDR pass to generate some HDR brightess out of an SDR signal.
// This is hue conserving and only really affects highlights.
// "sdr_color" is meant to be in "SDR range", as in, a value of 1 matching SDR white (something between 80, 100, 203, 300 nits, or whatever else)
// https://github.com/Filoppi/PumboAutoHDR
float3 PumboAutoHDR(float3 sdr_color) {
  const float shoulder_pow = CUSTOM_MOV_SHOULDERPOW;
  const float SDRRatio = max(renodx::color::y::from::BT2020(sdr_color), 0.f);

  // Limit AutoHDR brightness, it won't look good beyond a certain level.
  // The paper white multiplier is applied later so we account for that.
  float target_max_luminance = min(RENODX_PEAK_WHITE_NITS, pow(10.f, ((log10(RENODX_DIFFUSE_WHITE_NITS) - 0.03460730900256) / 0.757737096673107)));
  target_max_luminance = lerp(1.f, target_max_luminance, .5f);

  const float auto_HDR_max_white = max(target_max_luminance / RENODX_DIFFUSE_WHITE_NITS, 1.f);
  const float auto_HDR_shoulder_ratio = 1.f - max(1.f - SDRRatio, 0.f);
  const float auto_HDR_extra_ratio = pow(max(auto_HDR_shoulder_ratio, 0.f), shoulder_pow) * (auto_HDR_max_white - 1.f);
  const float auto_HDR_total_ratio = SDRRatio + auto_HDR_extra_ratio;
  return sdr_color * renodx::math::SafeDivision(auto_HDR_total_ratio, SDRRatio, 1);  // Fallback on a value of 1 in case of division by 0
}

// float3 Shadows(in float3 color, in float shadows = 1.f, in float mid_gray = 0.18f) {
//   float y = renodx::color::y::from::BT709(color);
//   float yNew = renodx::color::grade::Shadows(color, shadows, mid_gray);
//   return renodx::color::correct::Luminance(color, y, yNew);
// }

// //https://github.com/ronja-tutorials/ShaderTutorials/blob/master/Assets/047_InverseInterpolationAndRemap/Interpolation.cginc
// float invLerp(float from, float to, float value) {
//   return (value - from) / (to - from);
// }
// float3 invLerp(float3 from, float3 to, float3 value) {
//   return (value - from) / (to - from);
// }
// float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
//   float rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }
// float3 remap(float3 origFrom, float3 origTo, float3 targetFrom, float3 targetTo, float3 value){
//   float3 rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }


float Sum3(in float3 v) {
  return (v.x + v.y + v.z);
}

// float Avg3(in float3 v) {
//   return Sum(v) / 3.f;
// }


float3 Tradeoff_LinearToTradeoffSpace(float3 color) {
  return CUSTOM_TRADEOFF_MODE == 0 ? renodx::color::srgb::EncodeSafe(color) : color;

  // if (CUSTOM_TRADEOFF_MODE == 0.f) return renodx::color::srgb::EncodeSafe(color);
  // else if (CUSTOM_TRADEOFF_MODE == 1.f) return renodx::color::gamma::EncodeSafe(color, CUSTOM_TRADEOFF_GAMMA_AMOUNT);
  // else if (CUSTOM_TRADEOFF_MODE == 2.f) return renodx::color::pq::EncodeSafe(color);
  // else return color;

  // switch (CUSTOM_TRADEOFF_MODE) {
  //   case 0.f: return renodx::color::srgb::EncodeSafe(color);
  //   case 1.f: return renodx::color::gamma::EncodeSafe(color, CUSTOM_TRADEOFF_GAMMA_AMOUNT);
  //   case 2.f: return renodx::color::pq::EncodeSafe(color);
  //   default: return color;
  // }
}

float3 Tradeoff_TradeoffSpaceToLinear(float3 color) {
  return CUSTOM_TRADEOFF_MODE == 0 ? renodx::color::srgb::DecodeSafe(color) : color;

  // if (CUSTOM_TRADEOFF_MODE == 0.f) return renodx::color::srgb::DecodeSafe(color);
  // else if (CUSTOM_TRADEOFF_MODE == 1.f) return renodx::color::gamma::DecodeSafe(color, CUSTOM_TRADEOFF_GAMMA_AMOUNT);
  // else if (CUSTOM_TRADEOFF_MODE == 2.f) return renodx::color::pq::DecodeSafe(color);
  // else return color;

  // switch (CUSTOM_TRADEOFF_MODE) {
  //   case 0.f: return renodx::color::srgb::DecodeSafe(color);
  //   case 1.f: return renodx::color::gamma::DecodeSafe(color, CUSTOM_TRADEOFF_GAMMA_AMOUNT);
  //   case 2.f: return renodx::color::pq::DecodeSafe(color);
  //   default: return color;
  // }
}

/*
* in: scaled tradeoff color space normalized up to SDR_NORMALIZATION_MAX
* out: linear for RenderImmediatePass
*/
float3 Tonemap_Tradeoff_Out(float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0) return color;

  //scale down from 32768
  if (CUSTOM_TRADEOFF_RATIO > 0) color /= SDR_NORMALIZATION_MAX * CUSTOM_TRADEOFF_RATIO;

  //to linear
  color = Tradeoff_TradeoffSpaceToLinear(color);

  //clamp NaNs & negatves
  color = max(color, float3(0,0,0));

  return color;
}

float3 Tonemap_Compressor(float3 colorUntonemapped) {
  return renodx::tonemap::dice::BT709(colorUntonemapped, 100 /* CUSTOM_DICE_MAXVAL */, CUSTOM_DICE_SHOULDERTHRESHOLD, CUSTOM_DICE_POWER);
}

void Tonemap_LUT(inout float3 color, in Texture3D<float3> lut, in SamplerState sampler1) {
  color = lut.Sample(sampler1, color);
  // color = renodx::lut::SampleTetrahedral(lut, color, 32);
}

#define MINIMUM_Y 0.000001f
static renodx::debug::graph::Config graph_config; //no warning of unused var if out here
/*
* in: linear untonemapped & tonemapped
* out: scaled tradeoff color space normalized up to SDR_NORMALIZATION_MAX
*/
float3 Tonemap_Tradeoff_In(float3 colorUntonemapped, float3 colorTonemapped, float2 uv, Texture2D<float4> texColor) {
  //ToneMapPass
  if (RENODX_TONE_MAP_TYPE != 0) {
    //sum of colorTonemapped (save blacks)
    const float sumTonemapped = Sum3(colorTonemapped);

    //colorTonemapped prepare 2
    {
      //scale down
      colorTonemapped /= SDR_NORMALIZATION_MAX;
    }
    
    //colorSDRNeutral prepare (The actual before-lut color is so messed up that it is way better to do this.)
    float3 colorSDRNeutral; 
    float3 colorSDRNeutralAfterReinhard;
    // colorSDRNeutral = colorTonemapped;
    {
      if (CUSTOM_TONEMAP_ISUSESDR == 0.f) {
        //use colorUntonemapped
        colorSDRNeutral = colorUntonemapped;

        //apply preexposure
        colorSDRNeutral *= CUSTOM_PREEXPOSURE;

        //apply min (save blacks)
        if (sumTonemapped >= MINIMUM_Y) colorSDRNeutral = max(colorSDRNeutral, (float3)MINIMUM_Y);

        //This helps preserve extreme highlights for UpgradeToneMap() that would be crushed if just doing saturate(colorSDRNeutral).
        colorSDRNeutral = renodx::tonemap::ReinhardScalable(colorSDRNeutral, 1, 0, 0.18f, 0.18f);
        colorSDRNeutralAfterReinhard = colorSDRNeutral;

        //CUSTOM_GRADE_LUMA
        colorSDRNeutral = lerp(colorTonemapped, colorSDRNeutral, CUSTOM_GRADE_LUMA);
      } else {
        colorSDRNeutral = float3(0,0,0);
      }
    }

    //colorTonemapped prepare 2
    {
      //map chroma of colorSDRNeutral to colorTonemapped
      if (CUSTOM_GRADE_CHROMA < 1) colorTonemapped = renodx::tonemap::UpgradeToneMap(colorTonemapped, colorSDRNeutralAfterReinhard, colorSDRNeutralAfterReinhard, 1-CUSTOM_GRADE_CHROMA, 0); //a bit inverted, but its ok
    }


    //colorUntonemapped prepare
    {
      //apply preexposure
      colorUntonemapped *= CUSTOM_PREEXPOSURE * CUSTOM_PREEXPOSURE_RATIO;

      //compressor
      colorUntonemapped = Tonemap_Compressor(colorUntonemapped);

      //apply min (save blacks)
      if (CUSTOM_TONEMAP_ISUSESDR == 0.f && sumTonemapped >= MINIMUM_Y) colorUntonemapped = max(colorUntonemapped, (float3)MINIMUM_Y);
    }
    
    //graph start
    if (CUSTOM_TONEMAP_DEBUG == 1.f) graph_config = renodx::debug::graph::DrawStart(uv, colorUntonemapped, texColor, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS);
    
    //ToneMapPass
    {
      [branch]
      if (CUSTOM_TONEMAP_DEBUG <= 1.f) {
        //config
        renodx::draw::Config config = renodx::draw::BuildConfig();
        // config.tone_map_highlight_saturation += 0.5f * 0.02f; 
        // config.tone_map_pass_autocorrection = 0;
        // config.per_channel_chrominance_correction = 1;

        //do
        colorTonemapped = CUSTOM_TONEMAP_ISUSESDR == 0.f ? 
          renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral, config) : 
          renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, config);  

        if (CUSTOM_TONEMAP_ISUSESDR == 0.f) colorTonemapped += CUSTOM_BLACKFLOORRAISE * (1-CUSTOM_GRADE_LUMA);
      }
      else if (CUSTOM_TONEMAP_DEBUG == 2.f) {
        [flatten]
        if (uv.x < 1/3.f) {
          colorTonemapped = colorUntonemapped;
        } else if (uv.x < 2/3.f) {
          colorTonemapped = colorSDRNeutral;
        } else {
          colorTonemapped = colorTonemapped;
        }
      }
    }

    //graph end
    if (CUSTOM_TONEMAP_DEBUG == 1.f) colorTonemapped = renodx::debug::graph::DrawEnd(colorTonemapped, graph_config);
  }
  
  //gatekeep: skip tradeoff
  if (RENODX_TONE_MAP_TYPE == 0) return colorTonemapped;

  //tradeoff
  {
    //to intermiedate colorspace
    colorTonemapped = Tradeoff_LinearToTradeoffSpace(colorTonemapped); //we do this before the next to not immediately clip the values

    //scale up to 32768
    if (CUSTOM_TRADEOFF_RATIO > 0) colorTonemapped *= SDR_NORMALIZATION_MAX * CUSTOM_TRADEOFF_RATIO;
  }

  return colorTonemapped;
}

#define BLOOM_SCALER 256 //0.00390625233 
float3 Bloom_UntonemappedAdd(in float3 colorUntonemapped, in float3 bloomBefore, in float3 bloomAfter, in float3 bloomColor) {
  //mask
  float3 bloomMask = bloomAfter - bloomBefore;
  {
    // const float a = CUSTOM_TONEMAP_ISUSESDR == 1.f ? 0.9f : 0.75f;
    // const float a = lerp(0.65f, 0.9f, CUSTOM_GRADE_LUMA);
    bloomMask *= 0.75f * CUSTOM_BLOOM_HDR_DODGE;
  }

  //color
  bloomColor -= bloomMask;

  // bloomColor = saturate(bloomColor);
  // bloomColor = renodx::tonemap::inverse::ReinhardScalable(bloomColor, 1.0125, 0, 0.5/* CUSTOM_BLOOM_HDR_POWER - 1 */, 0.18); //back up
  bloomColor = max((float3)0, bloomColor);

  bloomColor = CUSTOM_BLOOM_HDR_POWER > 1.f ? 
    renodx::color::grade::Contrast(bloomColor * 3.f, CUSTOM_BLOOM_HDR_POWER) / 3.f :
    bloomColor;
  bloomColor *= (/* 0.5f * */ CUSTOM_BLOOM_HDR);

  //add
  colorUntonemapped += bloomColor;
  
  return colorUntonemapped;
}

float3 Bloom_ScaledAfterSaturate(float3 color) {
  color.rgb *= CUSTOM_BLOOM_SDR;
  color.rgb = CUSTOM_BLOOM_SDR_SATURATION != 0 ? renodx::color::grade::Saturation(color.rgb, CUSTOM_BLOOM_SDR_SATURATION) : color.rgb;
  return color;
}

float3 Tradeoff_PrepareFullWidthFsfx(float3 color, float scale = 1, bool isDoColorSpace = true) {
  if (RENODX_TONE_MAP_TYPE == 0) return color; //Vanilla

  color /= SDR_NORMALIZATION_MAX; //scale down
  color = isDoColorSpace ? Tradeoff_LinearToTradeoffSpace(color) : color; //color space
  color = CUSTOM_TRADEOFF_RATIO > 0 ? color * (SDR_NORMALIZATION_MAX * CUSTOM_TRADEOFF_RATIO) : color; //scale up
  color *= scale;

  return color;
}


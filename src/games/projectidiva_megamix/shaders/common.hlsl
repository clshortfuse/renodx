#include "../shared.h"
#include "./drawbinary.hlsl"

#define SDR_NORMALIZATION_MAX 32768.0 //1 / 3.05175781e-005
#define RENODX_TONE_MAP_TYPE_IS_ON RENODX_TONE_MAP_TYPE > 0
#define TONEMAP_START_FLAT 5

// void Tonemap_Compressor(inout color) {
//   //y
//   float y = renodx::color::
// }

// void F(inout float4 color) {
//   saturate(color);
// }

// void F(inout float3 color) {
//   saturate(color);
// }

// void F(inout float2 color) {
//   saturate(color);
// }

// void F(inout float color) {
//   saturate(color);
// }

#define RHSC_E (50.f/41.f)
float3 ReinhardScalableCached(float3 x) {
  return (x * RHSC_E) / (x * RHSC_E + 1.f);
}

// float3 ReinhardScalableFaster(float3 x, in float exp = RHSC_E) {
//   return (x * exp) / (x * exp + 1.f);
// }

float Sum3(in float3 v) {
  return (v.x + v.y + v.z);
}

bool CheckBlack(in float v) {return v == 0;}
bool CheckBlack(in float2 v) {return v == (float2)0;}
bool CheckBlack(in float3 v) {return v == (float3)0;}
bool CheckBlack(in float4 v) {return v == (float4)0;}

bool CheckWhite(in float v) {return v == 1;}
bool CheckWhite(in float2 v) {return v == (float2)1;}
bool CheckWhite(in float3 v) {return v == (float3)1;}
bool CheckWhite(in float4 v) {return v == (float4)1;}

float4 Tonemap_BloomMultiplier(in float4 color) {
  return color * CUSTOM_BLOOM;
}

float3 Tonemap_BloomMultiplier(in float3 color) {
  return color * CUSTOM_BLOOM;
}

float3 Tonemap_ExposureComplex(in float3 colorTonemapped, in float v3) {
  const float exp = v3 * 7.f/* CUSTOM_PREEXPOSURE_COMPLEXFUDGE */; //TODO this is probably a curve.
  return colorTonemapped * exp;
}

// float3 Tonemap_ExposureComplexSimple(in float3 colorTonemapped, in float v3) {
//   const float exp = v3;
//   return colorTonemapped * exp;
// }

void Tonemap_SaveSprites(inout float3 colorUntonemapped, in float colorUntonemappedMask, in float3 colorVanilla, in float2 uv) {
  //gatekeep: was 3d rendered
  if (RENODX_TONE_MAP_TYPE == 0 || colorUntonemappedMask > 0 || (Sum3(colorUntonemapped) > 0.0005f && Sum3(colorVanilla) <= 0)) {
    // if (CUSTOM_BGSPRITES_DEBUG == 1) colorUntonemapped = (float3)0; //debug
    return;
  }

  // //debug
  // if (CUSTOM_BGSPRITES_DEBUG == 1) {
  //   const float size = 0.01f;
  //   const float sizeHalf = size/2.f;
  //   colorUntonemapped = ((uv.x % size < sizeHalf) && (uv.y % size > sizeHalf)) ? (float3)0.35f : (float3)0.1f; 
  //   return;
  // }

  // //y correct sprites (should only effect mov)
  // {
  //   float3 colorSpritesDecoded = /* renodx::color::gamma::DecodeSafe */(colorSprites);
  //   float colorSpritesDecodedY = renodx::color::y::from::BT709(colorSprites);

  //   //only if HDR range
  //   if (colorSpritesDecodedY > 1) {
  //     float3 r0Decoded = /* renodx::color::gamma::DecodeSafe */(r0.xyz);
  //     float r0DecodedY = renodx::color::y::from::BT709(r0Decoded);

  //     r0.xyz = renodx::color::correct::Luminance(r0Decoded, r0DecodedY, colorSpritesDecodedY, 1);
  //   }

  //   // r0.xyz = renodx::color::gamma::EncodeSafe(r0.xyz);
  // }

  //colorUntonemap save blacks
  colorUntonemapped = colorVanilla;
  // colorUntonemapped *= 1.2f;

  //inv
  if (CUSTOM_BGSPRITES_ISINVTONEMAP)
  {
    const float maxIn = 2.5f;
    // colorUntonemapped = renodx::color::gamma::DecodeSafe(colorUntonemapped);
    colorUntonemapped = min((float3)maxIn, colorUntonemapped);
    colorUntonemapped = renodx::tonemap::inverse::ReinhardScalable(colorUntonemapped, maxIn, 0, CUSTOM_BGSPRITES_EXPOSURE, 0.18f);
    // colorUntonemapped = renodx::color::gamma::EncodeSafe(colorUntonemapped);
  }
}

#define MINIMUM_Y 0.000001f
float3 Tonemap_Do(in float3 colorUntonemapped, in float3 colorTonemapped, in float2 uv, in Texture2D<float4> texColor) {
  if (RENODX_TONE_MAP_TYPE_IS_ON) {
    // //sum of colorTonemapped (save blacks)
    // const float sumTonemapped = Sum3(colorTonemapped);

    //decode (100% gamma 2.2)
    colorUntonemapped = max((float3)0, colorUntonemapped);
    colorUntonemapped = renodx::color::gamma::Decode(colorUntonemapped);

    colorTonemapped = max((float3)0, colorTonemapped);
    colorTonemapped = renodx::color::gamma::Decode(colorTonemapped);

    //inv
    if (
      CUSTOM_TONEMAP2ND_MODE != 1 && //not disabled
      (
        CUSTOM_TONEMAP2ND_MODE == 2 || //forced
        CALLBACK_TONEMAP_ISDRAWN >= TONEMAP_START_FLAT //flat
      )
    )
    {
      // colorTonemapped = saturate(colorTonemapped); //just in case
      float y = renodx::color::y::from::BT709(colorTonemapped);
      y = max(0, y);

      // float yDes = renodx::tonemap::inverse::ReinhardScalable(y, 1, 0, 0.4, 0.18); //this is weird on the colors

      float yDes = y * CUSTOM_TONEMAP2ND_INV_PREEXP;
      yDes = pow(yDes, CUSTOM_TONEMAP2ND_INV_POW); //bruh
      yDes *= CUSTOM_TONEMAP2ND_INV_EXP;

      colorUntonemapped = renodx::color::correct::Luminance(colorUntonemapped, y, yDes, 1);
    }

    //colorSDRNeutral prepare
    float3 colorSDRNeutral; 
    {
        //use colorUntonemapped
        colorSDRNeutral = colorUntonemapped;

        //apply preexposure
        colorSDRNeutral *= CUSTOM_PREEXPOSURE;

        // //apply min (save blacks)
        // if (sumTonemapped >= MINIMUM_Y) colorSDRNeutral = max(colorSDRNeutral, (float3)MINIMUM_Y);

        //This helps preserve extreme highlights for UpgradeToneMap() that would be crushed if just doing saturate(colorSDRNeutral).
        colorSDRNeutral = ReinhardScalableCached(colorSDRNeutral);

        //CUSTOM_GRADE_LUMA
        colorSDRNeutral = lerp(colorTonemapped, colorSDRNeutral, CUSTOM_GRADE_LUMA);
    }

    //colorTonemapped prepare
    {
      //map chroma of colorSDRNeutral to colorTonemapped
      if (CUSTOM_GRADE_CHROMA < 1) colorTonemapped = renodx::tonemap::UpgradeToneMap(colorTonemapped, colorUntonemapped, colorUntonemapped, 1-CUSTOM_GRADE_CHROMA, 0); //a bit inverted, but its ok
    }

    //colorUntonemapped prepare
    {
      //apply preexposure
      colorUntonemapped *= CUSTOM_PREEXPOSURE * CUSTOM_PREEXPOSURE_RATIO;

      //compressor
      // colorUntonemapped = renodx::tonemap::dice::BT709(colorUntonemapped, 100, 10, 0.1f);

      //apply min (save blacks)
      // if (sumTonemapped >= MINIMUM_Y) colorUntonemapped = max(colorUntonemapped, (float3)MINIMUM_Y);
    }
    
    //ToneMapPass()
    {
      // [branch]
      // if (CUSTOM_TONEMAP_DEBUG <= 1.f) {
        renodx::draw::Config config = renodx::draw::BuildConfig();
        config.tone_map_type = renodx::draw::TONE_MAP_TYPE_UNTONEMAPPED; //we will do it later, in final
        colorTonemapped = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral, config);
      // }
      // else if (CUSTOM_TONEMAP_DEBUG == 2.f) {
      //   [flatten]
      //   if (uv.x < 1/3.f) {
      //     colorTonemapped = colorUntonemapped;
      //   } else if (uv.x < 2/3.f) {
      //     colorTonemapped = colorSDRNeutral;
      //   } else {
      //     colorTonemapped = colorTonemapped;
      //   }
      // }
    }
  
    //encode for rest of shaders until RenderIntermediatePass
    colorTonemapped = renodx::color::gamma::Encode(colorTonemapped); //10000000% gamma 2.2
  }

  return colorTonemapped;
}

// static renodx::debug::graph::Config graph_config; //no warning of unused var if out here
float3 Final_Do(in float3 color, in float2 uv, in Texture2D<float4> texColor) {
  //decode
  color = max((float3)0, color);
  color = renodx::color::srgb::Decode(color); //100000% srgb

  if (RENODX_TONE_MAP_TYPE_IS_ON)
  {    
    //graph start
    // if (CUSTOM_TONEMAP_DEBUG == 1.f) graph_config = renodx::debug::graph::DrawStart(uv, color, texColor, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS);

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    renodx::tonemap::Config tone_map_config = renodx::tonemap::config::Create();
    {
      tone_map_config.peak_nits = draw_config.peak_white_nits;
      tone_map_config.game_nits = draw_config.diffuse_white_nits;
      tone_map_config.type = min(draw_config.tone_map_type, 3);
      tone_map_config.gamma_correction = draw_config.gamma_correction;
      tone_map_config.exposure = draw_config.tone_map_exposure;
      tone_map_config.highlights = draw_config.tone_map_highlights;
      tone_map_config.shadows = draw_config.tone_map_shadows;
      tone_map_config.contrast = draw_config.tone_map_contrast;
      tone_map_config.saturation = draw_config.tone_map_saturation;

      tone_map_config.reno_drt_highlights = 1.0f;
      tone_map_config.reno_drt_shadows = 1.0f;
      tone_map_config.reno_drt_contrast = 1.0f;
      tone_map_config.reno_drt_saturation = 1.0f;
      tone_map_config.reno_drt_blowout = -1.f * (draw_config.tone_map_highlight_saturation - 1.f);
      tone_map_config.reno_drt_dechroma = draw_config.tone_map_blowout;
      tone_map_config.reno_drt_flare = 0.10f * pow(draw_config.tone_map_flare, 10.f);
      tone_map_config.reno_drt_working_color_space = draw_config.tone_map_working_color_space;
      tone_map_config.reno_drt_per_channel = draw_config.tone_map_per_channel == 1.f;
      tone_map_config.reno_drt_hue_correction_method = draw_config.tone_map_hue_processor;
      tone_map_config.reno_drt_clamp_color_space = draw_config.tone_map_clamp_color_space;
      tone_map_config.reno_drt_clamp_peak = draw_config.tone_map_clamp_peak;
      tone_map_config.reno_drt_tone_map_method = draw_config.reno_drt_tone_map_method;
      tone_map_config.reno_drt_white_clip = draw_config.reno_drt_white_clip;
    }
    color = renodx::tonemap::config::Apply(color, tone_map_config);

    //graph end
    // if (CUSTOM_TONEMAP_DEBUG == 1.f) color = renodx::debug::graph::DrawEnd(color, graph_config);
  }

  color = renodx::draw::RenderIntermediatePass(color);

  return color;
}

float3 Mov_Do(in float3 color) {
  if (CALLBACK_TONEMAP_ISDRAWN == 0.f) { //if tonemap0
    // color = renodx::draw::EncodeColor(color, RENODX_INTERMEDIATE_ENCODING);
    // color = min((float3)(CUSTOM_MOV_MULTIPLIER * 80), color);
    // color = renodx::draw::DecodeColor(color, RENODX_INTERMEDIATE_ENCODING);
    
    // color.xyz;
    // if (RENODX_TONE_MAP_TYPE_IS_INV) color.xyz = renodx::draw::UpscaleVideoPass(color.xyz);
    // if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_MOV_ISUPSCALE) r0.xyz = renodx::tonemap::inverse::Reinhard(CUSTOM_MOV_MULTIPLIER);

    color.xyz *= CUSTOM_MOV_MULTIPLIER;
    color.xyz = saturate(color.xyz); //else, there is weird black
    color.xyz = CUSTOM_MOV_ISUPSCALE ? renodx::draw::UpscaleVideoPass(color.xyz) : color.xyz;
  }

  return color;
}

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
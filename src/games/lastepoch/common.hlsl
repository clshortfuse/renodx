#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen, bool colored) {
  float3 grainedColor;
  if (colored == true) {
    grainedColor = renodx::effects::ApplyFilmGrainColored(
        outputColor,
        screen,
        float3(
            injectedData.random_1,
            injectedData.random_2,
            injectedData.random_3),
        injectedData.fxFilmGrain * 0.01f,
        1.f);
  } else {
    grainedColor = renodx::effects::ApplyFilmGrain(
        outputColor,
        screen,
        injectedData.random_1,
        injectedData.fxFilmGrain * 0.03f,
        1.f);
  }
  return grainedColor;
}

// based on https://github.com/aliasIsolation/aliasIsolation/blob/master/data/shaders/chromaticAberration_ps.hlsl
float4 applyCA(Texture2D colorBuffer, SamplerState colorSampler, float2 texCoord, float2 screenSize, float intensity) {
float4 output;
float ca_amount = 0.018 * intensity;
float2 center_offset = texCoord - float2(0.5, 0.5);
ca_amount *= saturate(length(center_offset) * 2);
int num_colors = max(3, int(max(screenSize.x, screenSize.y) * 0.075 * sqrt(ca_amount)));
if (intensity == 0.f) {
  output = colorBuffer.Sample(colorSampler, texCoord);
} else {
  output.ga = colorBuffer.Sample(colorSampler, texCoord).ga; // unchanged green and alpha
  float offset = float(3 - num_colors * 0.5) * ca_amount / num_colors;
  float2 sampleUvR = float2(0.5, 0.5) + center_offset * (1 + offset);
  float2 sampleUvB = float2(0.5, 0.5) + center_offset * (1 - offset);
  output.r = colorBuffer.Sample(colorSampler, sampleUvR).r;
  output.b = colorBuffer.Sample(colorSampler, sampleUvB).b;
  }
return output;
}

// https://github.com/aliasIsolation/aliasIsolation/blob/master/data/shaders/sharpen_ps.hlsl
float4 applySharpen(Texture2D colorBuffer, SamplerState colorSampler, float2 texCoord, float intensity) {
  float4 output;
  uint screenWidth, screenHeight;
  colorBuffer.GetDimensions(screenWidth, screenHeight);
  const float2 texelSize = 1.0.xx / float2(screenWidth, screenHeight);
  float4 center = colorBuffer.SampleLevel(colorSampler, texCoord + float2(0,0) * texelSize, 0);
    if (intensity > 0.f)
      {
      float3 neighbors[4] =
          {
            colorBuffer.SampleLevel(colorSampler, texCoord + float2(1, 1) * texelSize, 0).xyz,
            colorBuffer.SampleLevel(colorSampler, texCoord + float2(-1, 1) * texelSize, 0).xyz,
            colorBuffer.SampleLevel(colorSampler, texCoord + float2(1, -1) * texelSize, 0).xyz,
            colorBuffer.SampleLevel(colorSampler, texCoord + float2(-1, -1) * texelSize, 0).xyz
          };
      float neighborDiff = 0;
      [unroll]
      for (uint i = 0; i < 4; ++i)
          {
        neighborDiff += renodx::color::y::from::BT709(abs(neighbors[i] - center));
      }
  
      float sharpening = (1 - saturate(2 * neighborDiff)) * intensity;
  
      float3 sharpened = float3(
                             0.0.xxx
                             + neighbors[0] * -sharpening
                             + neighbors[1] * -sharpening
                             + neighbors[2] * -sharpening
                             + neighbors[3] * -sharpening
                             + center * 5
      ) * 1.0 / (5.0 + sharpening * -4.0);
  
      output = float4(sharpened, center.w);
    }
      else
      {
      output = center;
    }
  return output;
  }

//-----SCALING-----//
float3 PostToneMapScale(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::correct::GammaSafe(color, true, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::correct::GammaSafe(color, true, 2.2f);
  } else {
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  }
  return color;
}

float3 InvertToneMapScale(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
    color *= injectedData.toneMapUINits / injectedData.toneMapGameNits;
    color = renodx::color::correct::GammaSafe(color, true, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
    color *= injectedData.toneMapUINits / injectedData.toneMapGameNits;
    color = renodx::color::correct::GammaSafe(color, true, 2.2f);
  } else {
    color *= injectedData.toneMapUINits / injectedData.toneMapGameNits;
  }
  return color;
}

float3 FinalizeOutput(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
  }
  color *= injectedData.toneMapUINits;
  if (injectedData.toneMapType == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
  } else {
    color = renodx::color::bt709::clamp::BT2020(color);
  }
  color /= 80.f;
  return color;
}

// logc c1000 custom encoding
static const float arri_a = renodx::color::arri::logc::c1000::PARAMS.a;
static const float arri_b = renodx::color::arri::logc::c1000::PARAMS.b;
static const float arri_c = renodx::color::arri::logc::c1000::PARAMS.c;
static const float arri_d = renodx::color::arri::logc::c1000::PARAMS.d;

float3 arriDecode(float3 color) {
  return (pow(10.f, (color - arri_d) / arri_c) - arri_b) / arri_a;
}

float3 lutShaper(float3 color, bool builder = false) {
  if (injectedData.colorGradeLUTShaper == 0.f) {
    color = builder ? arriDecode(color)
                    : saturate(renodx::color::arri::logc::c1000::Encode(color));
  } else {
    color = builder ? renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(color, 100.f))
                    : renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color), 100.f);
  }
  return color;
}

//-----TONEMAP-----//
static const float3x3 ACES_to_ACEScg_MAT = float3x3(
    1.4514393161f, -0.2365107469f, -0.2149285693f,
    -0.0765537734f, 1.1762296998f, -0.0996759264f,
    0.0083161484f, -0.0060324498f, 0.9977163014f);

static const float3x3 SRGB_to_ACES_MAT = float3x3(
    0.4397010, 0.3829780, 0.1773350,
    0.0897923, 0.8134230, 0.0967616,
    0.0175440, 0.1115440, 0.8707040);

static const float3x3 ACES_to_SRGB_MAT = float3x3(
    2.52169, -1.13413, -0.38756,
    -0.27648, 1.37272, -0.09624,
    -0.01538, -0.15298, 1.16835);

float3 RRT(float3 aces) {
  static const float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;

  // --- Glow module --- //
  // "Glow" module constants
  static const float RRT_GLOW_GAIN = 0.05;
  static const float RRT_GLOW_MID = 0.08;
  float saturation = renodx::tonemap::aces::Rgb2Saturation(aces);
  float yc_in = renodx::tonemap::aces::Rgb2Yc(aces);
  const float s = renodx::tonemap::aces::SigmoidShaper((saturation - 0.4) / 0.2);
  float added_glow = 1.0 + renodx::tonemap::aces::GlowFwd(yc_in, RRT_GLOW_GAIN * s, RRT_GLOW_MID);
  aces *= added_glow;

  // --- Red modifier --- //
  // Red modifier constants
  static const float RRT_RED_SCALE = 0.82;
  static const float RRT_RED_PIVOT = 0.03;
  static const float RRT_RED_HUE = 0.;
  static const float RRT_RED_WIDTH = 135.;
  float hue = renodx::tonemap::aces::Rgb2Hue(aces);
  const float centered_hue = renodx::tonemap::aces::CenterHue(hue, RRT_RED_HUE);
  float hue_weight;
  {
    // hueWeight = cubic_basis_shaper(centeredHue, RRT_RED_WIDTH);
    hue_weight = smoothstep(0.0, 1.0, 1.0 - abs(2.0 * centered_hue / RRT_RED_WIDTH));
    hue_weight *= hue_weight;
  }

  aces.r += hue_weight * saturation * (RRT_RED_PIVOT - aces.r) * (1. - RRT_RED_SCALE);

  // --- ACES to RGB rendering space --- //
  aces = clamp(aces, 0, 65535.0f);
  float3 rgb_pre = mul(ACES_to_ACEScg_MAT, aces);
  rgb_pre = clamp(rgb_pre, 0, 65504.0f);

  // --- Global desaturation --- //
  // rgbPre = mul( RRT_SAT_MAT, rgbPre);
  static const float RRT_SAT_FACTOR = 0.96f;
  rgb_pre = lerp(dot(rgb_pre, AP1_RGB2Y).xxx, rgb_pre, RRT_SAT_FACTOR);

  return rgb_pre;
}

float3 vanillaTonemap(float3 color) {
  static const float a = 278.5085;
  static const float b = 10.7772;
  static const float c = 293.6045;
  static const float d = 88.7122;
  static const float e = 80.6889;
  color = mul(SRGB_to_ACES_MAT, color);
  color = RRT(color);
  color = (color * (a * color + b)) / (color * (c * color + d) + e);
  color = mul(renodx::color::AP1_TO_XYZ_MAT, color);
  color = renodx::tonemap::aces::DarkToDim(color);
  color = mul(renodx::color::XYZ_TO_AP1_MAT, color);
  float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;
  color = lerp(dot(color, AP1_RGB2Y).rrr, color, 0.93);
  color = mul(renodx::color::AP1_TO_XYZ_MAT, color);
  color = mul(renodx::color::D60_TO_D65_MAT, color);
  color = mul(renodx::color::XYZ_TO_BT709_MAT, color);
  return color;
}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor;
  float midGray = vanillaTonemap(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaTonemap(untonemapped);
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, injectedData.toneMapType);
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_shadows = 1.06f;
  config.reno_drt_contrast = 1.6f;
  config.reno_drt_saturation = 0.92f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = (int)injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = (int)injectedData.toneMapColorSpace;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(hueCorrectionColor);
  } else {
    outputColor = untonemapped;
  }
return renodx::tonemap::config::Apply(outputColor, config);
}
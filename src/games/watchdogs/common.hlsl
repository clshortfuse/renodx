#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen, float intensity){
  float3 grainedColor = renodx::effects::ApplyFilmGrain(
      outputColor,
      screen,
      injectedData.random,
      intensity * 0.03f,
			1.f);
    return grainedColor;
}

float3 applyVignette(float3 inputColor, float2 screen, float slider) {
  static float intensity = 0.9f;  // internal
  static float roundness = 1.15f;  // parameters
  static float light = 0.15f;      // for now
  
	float Vintensity = intensity * min(1, slider);	// Slider below 1 to Vintensity
	float Vroundness = roundness * max(1, slider);	// Slider above 1 to Vroundness
	float2 Vcoord = screen - 0.5f;					// get screen center
	Vcoord *= Vintensity;
	float v = dot(Vcoord, Vcoord);
	v = saturate(1 - v);
	v = pow(v, Vroundness);
	float3 output = inputColor * min(1, v + light);
	return output;
}

// based on https://github.com/aliasIsolation/aliasIsolation/blob/master/data/shaders/chromaticAberration_ps.hlsl
float3 applyCA(Texture2D colorBuffer, SamplerState colorSampler, float2 texCoord, float intensity) {
float3 output;
uint screenWidth, screenHeight;
colorBuffer.GetDimensions(screenWidth, screenHeight);
float ca_amount = 0.018 * intensity;
float2 center_offset = texCoord - float2(0.5, 0.5);
ca_amount *= saturate(length(center_offset) * 2);
int num_colors = max(3, int(max(screenWidth, screenHeight) * 0.075 * sqrt(ca_amount)));
if (intensity == 0.f) {
  output = colorBuffer.Sample(colorSampler, texCoord).rgb;
} else {
  output.g = colorBuffer.Sample(colorSampler, texCoord).g; // unchanged green
  float offset = float(7 - num_colors * 0.5) * ca_amount / num_colors;
  float2 sampleUvR = float2(0.5, 0.5) + center_offset * (1 + offset);
  float2 sampleUvB = float2(0.5, 0.5) + center_offset * (1 - offset);
  output.r = colorBuffer.Sample(colorSampler, sampleUvR).r;
  output.b = colorBuffer.Sample(colorSampler, sampleUvB).b;
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
    color *= injectedData.toneMapUINits;
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
    color *= injectedData.toneMapUINits;
  } else {
    color *= injectedData.toneMapUINits;
  }
  if (injectedData.toneMapType == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
  } else if (injectedData.toneMapType != 1.f) {
    color = renodx::tonemap::ExponentialRollOff(color, injectedData.toneMapGameNits, max(injectedData.toneMapPeakNits, injectedData.toneMapGameNits + 1.f));
    color = renodx::color::bt709::clamp::BT2020(color);
  } else {
    color = renodx::color::bt709::clamp::BT2020(color);
  }
  color /= 80.f;
  return color;
}

float3 InverseToneMap(float3 color) {
  if (injectedData.toneMapType != 0.f && injectedData.has_loaded_title_menu == true) {
	float scaling = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
	float videoPeak = scaling * renodx::color::bt2408::REFERENCE_WHITE;
    videoPeak = renodx::color::correct::Gamma(videoPeak, false, 2.4f);
    scaling = renodx::color::correct::Gamma(scaling, false, 2.4f);
      if(injectedData.toneMapGammaCorrection == 2.f){
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.4f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.4f);
    } else if(injectedData.toneMapGammaCorrection == 1.f){
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.2f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.2f);
    }
    color = renodx::color::gamma::Decode(color, 2.4f);
    color = renodx::tonemap::inverse::bt2446a::BT709(color, renodx::color::bt709::REFERENCE_WHITE, videoPeak);
	color /= videoPeak;
	color *= scaling;
  color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {}
  color = renodx::color::srgb::Decode(color);
	return color;
}

//-----TONEMAP-----//
float UpgradeToneMapRatio(float ap1_color_hdr, float ap1_color_sdr, float ap1_post_process_color) {
  if (ap1_color_hdr < ap1_color_sdr) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return ap1_color_hdr / ap1_color_sdr;
  } else {
    float ap1_delta = ap1_color_hdr - ap1_color_sdr;
    ap1_delta = max(0, ap1_delta);  // Cleans up NaN
    const float ap1_new = ap1_post_process_color + ap1_delta;

    const bool ap1_valid = (ap1_post_process_color > 0);  // Cleans up NaN and ignore black
    return ap1_valid ? (ap1_new / ap1_post_process_color) : 0;
  }
}

float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  // float ratio = 1.f;

  float3 bt2020_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
  float3 bt2020_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
  float3 bt2020_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));

  float3 ratio = float3(
      UpgradeToneMapRatio(bt2020_hdr.r, bt2020_sdr.r, bt2020_post_process.r),
      UpgradeToneMapRatio(bt2020_hdr.g, bt2020_sdr.g, bt2020_post_process.g),
      UpgradeToneMapRatio(bt2020_hdr.b, bt2020_sdr.b, bt2020_post_process.b));

  float3 color_scaled = max(0, bt2020_post_process * ratio);
  color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
  float peak_correction = saturate(1.f - renodx::color::y::from::BT2020(bt2020_post_process));
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color, peak_correction);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 vanillaTonemap(float3 color, float A, float CB, float DE, float B, float DF, float mEF, float LW){
  float3 numerator = mad(color, mad(A, color, CB), DE);  // x * (a * x + c * b) + d * e
  float3 denominator = mad(color, mad(A, color, B), DF);    // x * (a * x + b) + d * f
  return (numerator / denominator + mEF) * LW;
}

float3 applyUserTonemap(float3 untonemapped, Texture3D lutTexture, SamplerState lutSampler, float4 Params0, float3 Params1){
		float3 outputColor;
		float midGray = vanillaTonemap(float3(0.18f,0.18f,0.18f),
		Params0.x, Params0.y, Params0.z, Params0.w, Params1.x, Params1.y, Params1.z).x;
		float3 hueCorrectionColor = vanillaTonemap(untonemapped,
		Params0.x, Params0.y, Params0.z, Params0.w, Params1.x, Params1.y, Params1.z);
		  renodx::tonemap::Config config = renodx::tonemap::config::Create();
			config.type = min(3, injectedData.toneMapType);
			config.peak_nits = 10000.f;
			config.game_nits = injectedData.toneMapGameNits;
			config.gamma_correction = injectedData.toneMapGammaCorrection;
			config.exposure = injectedData.colorGradeExposure;
			config.highlights = injectedData.colorGradeHighlights;
			config.shadows = injectedData.colorGradeShadows;
			config.contrast = injectedData.colorGradeContrast;
			config.saturation = injectedData.colorGradeSaturation;
			config.mid_gray_value = midGray;
			config.mid_gray_nits = midGray * 100;
      config.reno_drt_highlights = 1.1f;
      config.reno_drt_shadows = 1.03f;
      config.reno_drt_contrast = 1.15f;
			config.reno_drt_dechroma = injectedData.colorGradeDechroma;
			config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
			config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
      ? renodx::tonemap::config::hue_correction_type::INPUT
      : renodx::tonemap::config::hue_correction_type::CUSTOM;
			config.hue_correction_strength = injectedData.toneMapHueCorrection;
			config.hue_correction_color = lerp(untonemapped, hueCorrectionColor, injectedData.toneMapHueShift);
			config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
			config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
			config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
			config.reno_drt_blowout = injectedData.colorGradeBlowout;
      config.reno_drt_white_clip = injectedData.colorGradeClip;
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lutSampler;
  lut_config.strength = injectedData.colorGradeLUTStrength;
  lut_config.scaling = 0.f;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_0;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.size = 32;
  lut_config.tetrahedral = injectedData.colorGradeLUTSampling != 0.f;
				if(injectedData.toneMapType == 0.f){
			outputColor = saturate(hueCorrectionColor);
			} else {
      outputColor = untonemapped;
      }
return renodx::tonemap::config::Apply(outputColor, config, lut_config, lutTexture);
}
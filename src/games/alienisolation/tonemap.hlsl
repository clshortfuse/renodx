#include "./common.hlsl"
#include "./include/CBuffer_DefaultPSC.hlsl"
#include "./include/CBuffer_DefaultXSC.hlsl"
#include "./include/CBuffer_UbershaderXSC.hlsl"

// 3Dmigoto declarations
#define cmp -

float UpgradeToneMapRatio(float color_hdr, float color_sdr, float post_process_color) {
  [branch]
  if (color_hdr < color_sdr) {
    // If subtracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return color_hdr / color_sdr;
  } else {
    float delta = color_hdr - color_sdr;
    delta = max(0, delta);  // Cleans up NaN
    const float ap1_new = post_process_color + delta;

    const bool ap1_valid = (post_process_color > 0);  // Cleans up NaN and ignore black
    return ap1_valid ? (ap1_new / post_process_color) : 0;
  }
}

float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength, uint working_color_space = 2u, uint hue_processor = 2u) {
  // float ratio = 1.f;

  float3 working_hdr, working_sdr, working_post_process;

  [branch]
  if (working_color_space == 2u) {
    working_hdr = max(0, renodx::color::ap1::from::BT709(color_hdr));
    working_sdr = max(0, renodx::color::ap1::from::BT709(color_sdr));
    working_post_process = max(0, renodx::color::ap1::from::BT709(post_process_color));
  } else
    [branch] if (working_color_space == 1u) {
      working_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
      working_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
      working_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));
    }
  else {
    working_hdr = max(0, color_hdr);
    working_sdr = max(0, color_sdr);
    working_post_process = max(0, post_process_color);
  }

  float3 ratio = float3(
      UpgradeToneMapRatio(working_hdr.r, working_sdr.r, working_post_process.r),
      UpgradeToneMapRatio(working_hdr.g, working_sdr.g, working_post_process.g),
      UpgradeToneMapRatio(working_hdr.b, working_sdr.b, working_post_process.b));

  float3 color_scaled = max(0, working_post_process * ratio);

  [branch]
  if (working_color_space == 2u) {
    color_scaled = renodx::color::bt709::from::AP1(color_scaled);
  } else
    [branch] if (working_color_space == 1u) {
      color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
    }

  float peak_correction;
  [branch]
  if (working_color_space == 2u) {
    peak_correction = saturate(1.f - renodx::color::y::from::AP1(working_post_process));
  } else
    [branch] if (working_color_space == 1u) {
      peak_correction = saturate(1.f - renodx::color::y::from::BT2020(working_post_process));
    }
  else {
    peak_correction = saturate(1.f - renodx::color::y::from::BT709(working_post_process));
  }

  [branch]
  if (hue_processor == 2u) {
    color_scaled = renodx::color::correct::HuedtUCS(color_scaled, post_process_color, peak_correction);
  } else
    [branch] if (hue_processor == 1u) {
      color_scaled = renodx::color::correct::HueICtCp(color_scaled, post_process_color, peak_correction);
    }
  else {
    color_scaled = renodx::color::correct::HueOKLab(color_scaled, post_process_color, peak_correction);
  }
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 UpgradeToneMapPerceptual(float3 untonemapped, float3 tonemapped, float3 post_processed, float strength) {
  float3 lab_untonemapped = renodx::color::ictcp::from::BT709(untonemapped);
  float3 lab_tonemapped = renodx::color::ictcp::from::BT709(tonemapped);
  float3 lab_post_processed = renodx::color::ictcp::from::BT709(post_processed);

  float3 lch_untonemapped = renodx::color::oklch::from::OkLab(lab_untonemapped);
  float3 lch_tonemapped = renodx::color::oklch::from::OkLab(lab_tonemapped);
  float3 lch_post_processed = renodx::color::oklch::from::OkLab(lab_post_processed);

  float3 lch_upgraded = lch_untonemapped;
  lch_upgraded.xz *= renodx::math::DivideSafe(lch_post_processed.xz, lch_tonemapped.xz, 0.f);

  float3 lab_upgraded = renodx::color::oklab::from::OkLCh(lch_upgraded);

  float c_untonemapped = length(lab_untonemapped.yz);
  float c_tonemapped = length(lab_tonemapped.yz);
  float c_post_processed = length(lab_post_processed.yz);

  if (c_untonemapped > 0) {
    float new_chrominance = c_untonemapped;
    new_chrominance = min(max(c_untonemapped, 0.25f), c_untonemapped * (c_post_processed / c_tonemapped));
    if (new_chrominance > 0) {
      lab_upgraded.yz *= new_chrominance / c_untonemapped;
    }
  }

  float3 upgraded = renodx::color::bt709::from::ICtCp(lab_upgraded);
  return lerp(untonemapped, upgraded, strength);
}

float3 UpgradeToneMap(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  if (injectedData.colorGradeRestorationMethod == 1.f) {
    return UpgradeToneMapPerChannel(color_hdr, color_sdr, post_process_color, post_process_strength);
  } else if (injectedData.colorGradeRestorationMethod == 2.f) {
    return UpgradeToneMapPerceptual(color_hdr, color_sdr, post_process_color, post_process_strength);
  } else {
    return renodx::tonemap::UpgradeToneMap(color_hdr, color_sdr, post_process_color, post_process_strength);
  }
}

float3 applyFilmGrain(float3 input_color, Texture2D<float4> SamplerNoise_TEX,
                      SamplerState SamplerNoise_SMP_s, float4 v1) {
  float3 grained_color;
  if (injectedData.fxFilmGrainType == 0.f) {  // Noise
    float4 r0, r2;
    float3 r1, r3;
    r0.rgb = input_color;

    r1.xyz = SamplerNoise_TEX.Sample(SamplerNoise_SMP_s, v1.xy).xyz;
    r1.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
    r0.w = dot(float3(0.298999995, 0.587000012, 0.114), r0.xyz);
    r2.xyz = float3(0, 0.5, 1) + -r0.www;
    r2.xyz = saturate(rp_parameter_ps[7].xyz + -abs(r2.xyz));
    r2.xyz = r2.xyz / rp_parameter_ps[7].xyz;
    r2.xyz = rp_parameter_ps[8].xyz * r2.xyz;
    r3.xyz = r2.yyy * r1.xyz;
    r2.xyw = r1.xyz * r2.xxx + r3.xyz;
    r1.xyz = r1.xyz * r2.zzz + r2.xyw;
    r0.xyz = injectedData.fxFilmGrain * r1.xyz + r0.xyz;

    grained_color = r0.rgb;
  } else {  // Film Grain, applied in linear space
    float3 linear_color = renodx::color::gamma::DecodeSafe(input_color, 2.2f);
    if (injectedData.fxFilmGrainType == 1.f) {  // B&W
      float random_seed = SamplerNoise_TEX.Sample(SamplerNoise_SMP_s, v1.xy).y;
      grained_color = renodx::effects::ApplyFilmGrain(
          linear_color,
          v1.xy,        // Screen-space coordinates
          random_seed,  // Sample noise tex for random seed
          injectedData.fxFilmGrain * .02f);
    } else {  // Colored
      float3 random_seed = SamplerNoise_TEX.Sample(SamplerNoise_SMP_s, v1.xy).rgb;
      grained_color = renodx::effects::ApplyFilmGrainColored(
          linear_color,
          v1.xy,        // Screen-space coordinates
          random_seed,  // Sample noise tex for random seed
          injectedData.fxFilmGrain * .02f);
    }
    grained_color = renodx::color::gamma::EncodeSafe(grained_color, 2.2f);
  }
  return grained_color;
}

renodx::tonemap::config::DualToneMap ToneMap(float3 color, float vanilla_mid_gray) {
  color *= vanilla_mid_gray / 0.18f;  // high mid gray values break tonemapping
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 0.f;
  config.mid_gray_value = 0.18f;
  config.mid_gray_nits = 0.18f * 100.f;
  config.exposure = injectedData.colorGradeExposure;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.highlights = injectedData.colorGradeHighlights;
  config.saturation = injectedData.colorGradeSaturation;
  config.hue_correction_type = renodx::tonemap::config::hue_correction_type::INPUT;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;

  // RenoDRT Settings
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0;
  config.reno_drt_highlights = 1.2f;
  config.reno_drt_shadows = 0.8f;
  config.reno_drt_contrast = 0.84f;
  config.reno_drt_saturation = 1.f;
  config.reno_drt_blowout = -1.f * (injectedData.colorGradeHighlightSaturation - 1.f);
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.reno_drt_working_color_space = 0u;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;

  // ToneMap Blend
  if (injectedData.toneMapBlend) {
    config.exposure = 1.f;
    config.shadows = 1.f;
    config.contrast = 1.f;
    config.saturation = 1.f;
    config.reno_drt_flare = 0.f;
    config.reno_drt_blowout = -1.f * (injectedData.colorGradeHighlightSaturation - 1.f);
    config.reno_drt_dechroma = 0.f;
  }

  renodx::tonemap::Config sdr_config = config;
  sdr_config.reno_drt_highlights /= config.highlights;
  sdr_config.reno_drt_shadows /= config.shadows;
  sdr_config.reno_drt_contrast /= config.contrast;
  sdr_config.gamma_correction = 0;
  sdr_config.peak_nits = 100.f;
  sdr_config.game_nits = 100.f;

  renodx::tonemap::config::DualToneMap dual_tone_map = renodx::tonemap::config::ApplyToneMaps(color, config, sdr_config);
  dual_tone_map.color_sdr = dual_tone_map.color_sdr;

  return dual_tone_map;
}

float3 ToneMapBlend(float3 hdr_color, float3 sdr_color) {
  float3 negHDR = min(0, hdr_color);  // save WCG
  float3 blended_color = lerp(sdr_color, max(0, hdr_color), saturate(sdr_color));
  blended_color += negHDR;  // add back WCG

  return blended_color;
}

float3 ApplyVanillaTonemap(float3 untonemapped, float untonemapped_luminance, Texture2D<float4> SamplerToneMapCurve_TEX, SamplerState SamplerToneMapCurve_SMP_s) {
  float4 r0, r1, r2, r3, r4;

  // Luminance calculation
  r0.xyz = untonemapped;
  r0.w = untonemapped_luminance;
  r1.x = log2(r0.w);
  r1.x = r1.x * 0.693147182 + 12;
  r1.x = saturate(0.0625 * r1.x);
  r1.y = 0.25;

  // Sample tone map curve
  r1.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r1.xy, 0).x;
  r1.y = -r1.x * r1.x + 1;
  r2.xyz = max(float3(0, 0, 0), r0.xyz);
  r1.z = max(9.99999975e-005, r0.w);
  r2.xyz = r2.xyz / r1.zzz;
  r1.y = max(9.99999975e-006, r1.y);
  r2.xyz = log2(r2.xyz);
  r1.yzw = r2.xyz * r1.yyy;
  r1.yzw = exp2(r1.yzw);
  r2.xyz = r1.yzw * r1.xxx;
  r2.w = sqrt(r1.x);

  // Apply tone mapping based on debug parameters
  r3.x = cmp(ToneMappingDebugParams.y < r2.w);
  r2.w = cmp(r2.w < ToneMappingDebugParams.x);
  r4.xyzw = r2.wwww ? float4(0, 0, 1, 1) : 0;
  r3.xyzw = r3.xxxx ? float4(1, 0, 0, 1) : r4.xyzw;
  r2.w = ToneMappingDebugParams.z * r3.w;
  r1.xyz = -r1.yzw * r1.xxx + r3.xyz;
  r1.xyz = r2.www * r1.xyz + r2.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.693147182, 0.693147182, 0.693147182) + float3(12, 12, 12);

  // Saturate and sample the tone map curve for each channel
  r2.xyz = saturate(float3(0.0625, 0.0625, 0.0625) * r0.xyz);
  r2.w = 0.25;
  r0.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.xw, 0).x;
  r0.y = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.yw, 0).x;
  r0.z = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.zw, 0).x;

  // Adjust colors based on incorrect luminance formula (BT.601)
  r1.w = renodx::color::luma::from::BT601(r0.xyz);
  r1.w = sqrt(r1.w);
  r2.x = cmp(ToneMappingDebugParams.y < r1.w);
  r1.w = cmp(r1.w < ToneMappingDebugParams.x);
  r3.xyzw = r1.wwww ? float4(0, 0, 1, 1) : 0;
  r2.xyzw = r2.xxxx ? float4(1, 0, 0, 1) : r3.xyzw;
  r1.w = ToneMappingDebugParams.z * r2.w;
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r1.www * r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = ToneMappingDebugParams.www * r0.xyz + r1.xyz;

  return r0.xyz;
}

// debug stuff
// maybe has vignette?
float3 applyVignette(float3 tonemapped, float4 sv_position, float4 texcoord, float luminance) {
  float4 r0, r1, r2;
  r0.xyz = tonemapped;
  r0.w = luminance;

  // Light meter debug and vignette processing
  r1.xy = (uint2)sv_position.xy;
  uint4 uiDest;
  uiDest.xy = (uint2)r1.xy / int2(5, 5);  // Compute vignette grid
  r1.xy = uiDest.xy;
  r1.x = (int)r1.x + (int)r1.y;  // Sum the grid coordinates
  r1.x = (int)r1.x & 1;          // Create a checkerboard pattern for the vignette

  // Apply LightMeterDebugParams threshold checks
  r1.y = cmp(LightMeterDebugParams.y < r0.w);        // Check if brightness exceeds the threshold
  r0.w = cmp(r0.w < LightMeterDebugParams.x);        // Check if brightness is below a threshold
  r2.xyzw = r0.wwww ? float4(0, 0, 1, 1) : 0;        // Set blue if brightness is too low
  r2.xyzw = r1.yyyy ? float4(1, 0, 0, 1) : r2.xyzw;  // Set red if brightness is too high
  r0.w = LightMeterDebugParams.w * r2.w;             // Apply light meter multiplier

  // Final color adjustment based on debug/vignette
  r1.yzw = r2.xyz + -r0.xyz;
  r1.yzw = r0.www * r1.yzw + r0.xyz;
  r0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  r0.xyz = texcoord.zzz * r0.xyz;  // Use v1 (texcoord) for final adjustment

  r0.rgb = lerp(tonemapped, r0.rgb, injectedData.fxVignette);
  return r0.rgb;
}

// Function to apply the LUT based on input color
float3 ApplyLUT(float3 lutInputColor, Texture3D<float4> SamplerColourLUT_TEX, SamplerState SamplerColourLUT_SMP_s) {
  float4 r0, r1;
  float3 lutOutputColor;

  // Apply the LUT
  r1.xyz = sign(lutInputColor) * sqrt(abs(lutInputColor));                   // Take square root of the input color and preserve the sign
  r1.xyz = rp_parameter_ps[2].zzz + r1.xyz;                                  // Apply an offset from rp_parameter_ps
  r1.xyz = SamplerColourLUT_TEX.Sample(SamplerColourLUT_SMP_s, r1.xyz).xyz;  // Sample the LUT using the adjusted color
  r0.w = rp_parameter_ps[2].y * rp_parameter_ps[2].x;                        // Calculate a scaling factor

  // Apply adjustments to the LUT output
  r1.xyz = r1.xyz * r1.xyz + -lutInputColor;
  lutOutputColor = r0.w * r1.xyz + lutInputColor;

  lutOutputColor = lerp(lutInputColor, lutOutputColor, injectedData.colorGradeLUTStrength);
  return lutOutputColor;  // Return the adjusted color
}
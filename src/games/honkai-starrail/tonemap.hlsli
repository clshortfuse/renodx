#include "./common.hlsl"

cbuffer cb0 : register(b0) {
  float4 cb0[37];
}
#define cmp -

// somewhat similar to ACES, but shadows aren't darkened as much
float3 ApplyVanillaToneMap(float3 untonemapped_bt709) {
  float4 r0, r1, r2, r3, r4, r5;

  r0.rgb = untonemapped_bt709;

  r0.w = cmp(0.5 >= cb0[36].x);
  if (r0.w != 0) {
    r0.w = cmp(0.5 < cb0[35].z);
    if (r0.w != 0) {
      // BT.709 -> AP1
      r1.x = dot(float3(0.613189995, 0.339509994, 0.0473700017), r0.xyz);
      r1.y = dot(float3(0.0702100024, 0.916339993, 0.0134500004), r0.xyz);
      r1.z = dot(float3(0.0206199996, 0.109569997, 0.869610012), r0.xyz);
      r0.w = dot(r1.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
      r2.xyz = r1.xyz / r0.www;
      r2.xyz = float3(-1, -1, -1) + r2.xyz;
      r1.w = dot(r2.xyz, r2.xyz);
      r1.w = -4 * r1.w;
      r1.w = exp2(r1.w);
      r1.w = 1 + -r1.w;
      r0.w = r0.w * r0.w;
      r0.w = cb0[35].x * r0.w;
      r0.w = -4 * r0.w;
      r0.w = exp2(r0.w);
      r0.w = 1 + -r0.w;
      r0.w = r1.w * r0.w;
      r2.x = dot(float3(1.37041104, -0.329291195, -0.0636843145), r1.xyz);
      r2.y = dot(float3(-0.0834370106, 1.09708822, -0.0108630517), r1.xyz);
      r2.z = dot(float3(-0.0257899351, -0.0986270159, 1.20369244), r1.xyz);
      r2.xyz = r2.xyz + -r1.xyz;
      r0.xyz = r0.www * r2.xyz + r1.xyz;

      r0.w = cmp(0.5 < cb0[35].w);
      if (r0.w == 0) {
        r1.xyz = cb0[28].xxx * r0.xyz;
        r2.xyzw = cmp(r1.xxyy < cb0[28].yzyz);
        r3.xyzw = r2.yyyy ? cb0[31].xyzw : cb0[33].xyzw;
        r4.xyzw = r2.yyww ? cb0[32].xyxy : cb0[34].xyxy;
        r3.xyzw = r2.xxxx ? cb0[29].xyzw : r3.xyzw;
        r4.xyzw = r2.xxzz ? cb0[30].xyxy : r4.xyzw;
        r0.w = r0.x * cb0[28].x + -r3.x;
        r0.w = r0.w * r3.z;
        r1.x = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r4.y * r0.w;
        r0.w = r0.w * 0.693147182 + r4.x;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.x ? r0.w : 0;
        r3.x = r0.w * r3.w + r3.y;
        r5.xyzw = r2.wwww ? cb0[31].xyzw : cb0[33].xyzw;
        r5.xyzw = r2.zzzz ? cb0[29].xyzw : r5.xyzw;
        r0.w = r0.y * cb0[28].x + -r5.x;
        r0.w = r0.w * r5.z;
        r1.x = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r4.w * r0.w;
        r0.w = r0.w * 0.693147182 + r4.z;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.x ? r0.w : 0;
        r3.y = r0.w * r5.w + r5.y;
        r1.xy = cmp(r1.zz < cb0[28].yz);
        r4.xyzw = r1.yyyy ? cb0[31].xyzw : cb0[33].xyzw;
        r1.yz = r1.yy ? cb0[32].xy : cb0[34].xy;
        r4.xyzw = r1.xxxx ? cb0[29].xyzw : r4.xyzw;
        r1.yz = r1.xx ? cb0[30].xy : r1.yz;
        r0.w = r0.z * cb0[28].x + -r4.x;
        r0.w = r0.w * r4.z;
        r1.w = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r1.z * r0.w;
        r0.w = r0.w * 0.693147182 + r1.y;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.w ? r0.w : 0;
        r3.z = r0.w * r4.w + r4.y;
        r4.xyzw = r2.xxxx ? cb0[29].xyzw : cb0[31].xyzw;
        r5.xyzw = r2.xxzz ? cb0[30].xyxy : cb0[32].xyxy;
        r0.w = r0.x * cb0[28].x + -r4.x;
        r0.w = r0.w * r4.z;
        r1.y = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r5.y * r0.w;
        r0.w = r0.w * 0.693147182 + r5.x;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.y ? r0.w : 0;
        r0.w = r0.w * r4.w + r4.y;
        r0.w = r0.w / cb0[35].y;
        r1.yz = float2(-0.899999976, -0.699999988) + r0.ww;
        r1.w = cmp(0.200000003 >= abs(r1.y));
        r1.z = r1.z * r1.z;
        r1.z = r1.z * -1.171875 + r0.w;
        r2.x = cmp(0.200000003 < r1.y);
        r1.y = r1.y * 0.0625 + 0.899999976;
        r0.w = r2.x ? r1.y : r0.w;
        r0.w = r1.w ? r1.z : r0.w;
        r4.x = cb0[35].y * r0.w;
        r2.xyzw = r2.zzzz ? cb0[29].xyzw : cb0[31].xyzw;
        r0.w = r0.y * cb0[28].x + -r2.x;
        r0.w = r0.w * r2.z;
        r1.y = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r5.w * r0.w;
        r0.w = r0.w * 0.693147182 + r5.z;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.y ? r0.w : 0;
        r0.w = r0.w * r2.w + r2.y;
        r0.w = r0.w / cb0[35].y;
        r1.yz = float2(-0.899999976, -0.699999988) + r0.ww;
        r1.w = cmp(0.200000003 >= abs(r1.y));
        r1.z = r1.z * r1.z;
        r1.z = r1.z * -1.171875 + r0.w;
        r2.x = cmp(0.200000003 < r1.y);
        r1.y = r1.y * 0.0625 + 0.899999976;
        r0.w = r2.x ? r1.y : r0.w;
        r0.w = r1.w ? r1.z : r0.w;
        r4.y = cb0[35].y * r0.w;
        r2.xyzw = r1.xxxx ? cb0[29].xyzw : cb0[31].xyzw;
        r1.xy = r1.xx ? cb0[30].xy : cb0[32].xy;
        r0.w = r0.z * cb0[28].x + -r2.x;
        r0.w = r0.w * r2.z;
        r1.z = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r1.y * r0.w;
        r0.w = r0.w * 0.693147182 + r1.x;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.z ? r0.w : 0;
        r0.w = r0.w * r2.w + r2.y;
        r0.w = r0.w / cb0[35].y;
        r1.xy = float2(-0.899999976, -0.699999988) + r0.ww;
        r1.z = cmp(0.200000003 >= abs(r1.x));
        r1.y = r1.y * r1.y;
        r1.y = r1.y * -1.171875 + r0.w;
        r1.w = cmp(0.200000003 < r1.x);
        r1.x = r1.x * 0.0625 + 0.899999976;
        r0.w = r1.w ? r1.x : r0.w;
        r0.w = r1.z ? r1.y : r0.w;
        r4.z = cb0[35].y * r0.w;
        r0.w = dot(r4.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
        r1.x = dot(r3.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
        r1.y = cmp(r1.x < 9.99999997e-07);
        r0.w = r0.w / r1.x;
        r0.w = r1.y ? 0 : r0.w;
        r1.xyz = r3.xyz * r0.www;
        r0.x = dot(float3(1.70504999, -0.621789992, -0.0832599998), r1.xyz);
        r0.y = dot(float3(-0.130260006, 1.1408, -0.0105499998), r1.xyz);
        r0.z = dot(float3(-0.0240000002, -0.128969997, 1.15296996), r1.xyz);
      }
    } else {
      r1.xyz = cb0[28].xxx * r0.xyz;
      r2.xyzw = cmp(r1.xxyy < cb0[28].yzyz);
      r3.xyzw = r2.yyyy ? cb0[31].xyzw : cb0[33].xyzw;
      r4.xyzw = r2.yyww ? cb0[32].xyxy : cb0[34].xyxy;
      r3.xyzw = r2.xxxx ? cb0[29].xyzw : r3.xyzw;
      r4.xyzw = r2.xxzz ? cb0[30].xyxy : r4.xyzw;
      r0.w = r0.x * cb0[28].x + -r3.x;
      r0.w = r0.w * r3.z;
      r1.x = cmp(0 < r0.w);
      r0.w = log2(r0.w);
      r0.w = r4.y * r0.w;
      r0.w = r0.w * 0.693147182 + r4.x;
      r0.w = 1.44269502 * r0.w;
      r0.w = exp2(r0.w);
      r0.w = r1.x ? r0.w : 0;
      r0.x = r0.w * r3.w + r3.y;
      r3.xyzw = r2.wwww ? cb0[31].xyzw : cb0[33].xyzw;
      r2.xyzw = r2.zzzz ? cb0[29].xyzw : r3.xyzw;
      r0.w = r0.y * cb0[28].x + -r2.x;
      r0.w = r0.w * r2.z;
      r1.x = cmp(0 < r0.w);
      r0.w = log2(r0.w);
      r0.w = r4.w * r0.w;
      r0.w = r0.w * 0.693147182 + r4.z;
      r0.w = 1.44269502 * r0.w;
      r0.w = exp2(r0.w);
      r0.w = r1.x ? r0.w : 0;
      r0.y = r0.w * r2.w + r2.y;
      r1.xy = cmp(r1.zz < cb0[28].yz);
      r2.xyzw = r1.yyyy ? cb0[31].xyzw : cb0[33].xyzw;
      r1.yz = r1.yy ? cb0[32].xy : cb0[34].xy;
      r2.xyzw = r1.xxxx ? cb0[29].xyzw : r2.xyzw;
      r1.xy = r1.xx ? cb0[30].xy : r1.yz;
      r0.w = r0.z * cb0[28].x + -r2.x;
      r0.w = r0.w * r2.z;
      r1.z = cmp(0 < r0.w);
      r0.w = log2(r0.w);
      r0.w = r1.y * r0.w;
      r0.w = r0.w * 0.693147182 + r1.x;
      r0.w = 1.44269502 * r0.w;
      r0.w = exp2(r0.w);
      r0.w = r1.z ? r0.w : 0;
      r0.z = r0.w * r2.w + r2.y;
    }
  }

  float3 tonemapped_bt709 = r0.xyz;

  return tonemapped_bt709;
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  const float shadow_mask = mid_gray;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted / highlight_mask));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted / shadow_mask));

  const float y_final = y_shadowed * mid_gray;

  color *= (y > 0 ? (y_final / y) : 0);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(hue_reference_color);

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, config.hue_correction_strength);

      float chrominance_post_adjust = distance(perceptual_new.yz, 0);

      // Apply back previous chrominance
      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    }

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 ApplyVanillaPlus(float3 untonemapped, float3 vanilla) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = injectedData.colorGradeExposure;
  cg_config.highlights = injectedData.colorGradeHighlights;
  cg_config.shadows = injectedData.colorGradeShadows;
  cg_config.contrast = injectedData.colorGradeContrast;
  cg_config.flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  cg_config.saturation = injectedData.colorGradeSaturation;
  cg_config.dechroma = injectedData.colorGradeBlowout;
  cg_config.hue_correction_strength = injectedData.toneMapHueCorrection;
  // cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  float untonemapped_lum = renodx::color::y::from::BT709(untonemapped);

  const float mid_gray = renodx::color::y::from::BT709(ApplyVanillaToneMap(float3(0.18f, 0.18f, 0.18f)));

  // blend between vanilla and untonemapped with shifted midgray
  untonemapped *= mid_gray / 0.18f;
  untonemapped = lerp(vanilla, untonemapped, saturate(renodx::color::y::from::BT709(untonemapped)));

  untonemapped = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, untonemapped_lum, cg_config, mid_gray);
  float peak_white = renodx::color::correct::GammaSafe(injectedData.toneMapPeakNits / injectedData.toneMapGameNits, true);
  float3 tonemapped = renodx::tonemap::ExponentialRollOff(untonemapped, mid_gray, peak_white);
  tonemapped = ApplySaturationBlowoutHueCorrectionHighlightSaturation(tonemapped, untonemapped, untonemapped_lum, cg_config);

  return tonemapped;
}

float3 applyUserTonemap(float3 untonemapped, float3 vanilla) {
  if (injectedData.toneMapType == 5.f) {
    return ApplyVanillaPlus(untonemapped, vanilla);
  }
  float3 outputColor = untonemapped;
  float vanillaMidGray = renodx::tonemap::unity::BT709(0.18f).x;

  renodx::tonemap::Config config = renodx::tonemap::config::Create();

  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 1.f;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = vanillaMidGray;
  config.mid_gray_nits = vanillaMidGray * 100.f;
  config.reno_drt_contrast = 1.04f;
  config.reno_drt_saturation = 1.05f;
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.001 * pow(injectedData.colorGradeFlare, 2.3f);
  config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_color = vanilla;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;

  if (injectedData.toneMapType == 0.f) {
    return vanilla;
  }
  if (injectedData.toneMapType == 2.f) {  // Frostbite
    outputColor = applyFrostbite(outputColor, config);

  } else if (injectedData.toneMapType == 4.f) {  // DICE
    outputColor = applyDICE(outputColor, config);
  } else {
    outputColor = renodx::tonemap::config::Apply(outputColor, config);
  }

  outputColor = renodx::tonemap::UpgradeToneMap(outputColor, saturate(outputColor), vanilla, 1.f);

  return outputColor;
}

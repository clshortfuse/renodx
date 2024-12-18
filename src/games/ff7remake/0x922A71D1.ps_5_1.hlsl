
#include "./shared.h"

Texture3D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture3D<float4> t2 : register(t2);
Texture3D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);

cbuffer cb0 : register(b0) {
  float4 cb0[39];
}

cbuffer cb1 : register(b1) {
  float4 cb1[140];
}

float3 ACES_Inv(float3 x) {
  return (sqrt(-10127. * x * x + 13702. * x + 9.) + 59. * x - 3.) / (502. - 486. * x);  // thanks to https://www.wolframalpha.com/input?i=2.51y%5E2%2B.03y%3Dx%282.43y%5E2%2B.59y%2B.14%29+solve+for+y
}

float3 ACESFittedBT709(float3 color) {
  color *= 0.6f;
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;
  return clamp((color * (a * color + b)) / (color * (c * color + d) + e), 0.0f, 1.0f);
}

float3 ACESFilmRec2020(float3 x) {
  x *= 0.6;
  float a = 15.8f;
  float b = 2.12f;
  float c = 1.2f;
  float d = 5.92f;
  float e = 1.9f;
  return (x * (a * x + b)) / (x * (c * x + d) + e);
}

float3 InverseACESFilmRec2020(float3 x) {
  return (sqrt(16204.f * x * x + 59362.f * x + 2809.f) + 148.f * x - 53.f)
         / (709.f - 60.f * x);
}

float3 RgbAcesHdrSrgb(float3 x) {
  x = (x * (x * (x * (x * 2708.7142 + 6801.1525) + 1079.5474) + 1.1614649) - 0.00004139375) / (x * (x * (x * (x * 983.38937 + 4132.0662) + 2881.6522) + 128.35911) + 1.0);
  return max(x, 0.0);
}

float3 InverseRgbAcesHdrSrgb(float3 x) {
  return ((x * (x * (x * (x * 656274802933915927445504.f + 1647802125695286694117376.f)) + 261555743752080263741440.f)
           + 281402943271815151616.f)
          - 10028992768578456.f)
         / (x * (x * (x * (x * 238258309054553447727104.f + 1001128480485277385621504.f) + 698174702107400110866432.f) + 31099201835329399029760.f)
            + 242282778646014296064.f);
}

// 3Dmigoto declarations
#define cmp -

float3 RenoDRTSmoothClamp(float3 untonemapped) {
  renodx::tonemap::renodrt::Config renodrt_config =
      renodx::tonemap::renodrt::config::Create();
  renodrt_config.nits_peak = 100.f;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.05f;
  renodrt_config.saturation = 1.05f;
  renodrt_config.dechroma = 0.f;
  renodrt_config.flare = 0.f;
  renodrt_config.hue_correction_strength = 0.f;
  renodrt_config.tone_map_method =
      renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.working_color_space = 2u;

  return renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
}

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

  float3 ap1_hdr = max(0, renodx::color::ap1::from::BT709(color_hdr));
  float3 ap1_sdr = max(0, renodx::color::ap1::from::BT709(color_sdr));
  float3 ap1_post_process = max(0, renodx::color::ap1::from::BT709(post_process_color));

  float3 ratio = float3(
      UpgradeToneMapRatio(ap1_hdr.r, ap1_sdr.r, ap1_post_process.r),
      UpgradeToneMapRatio(ap1_hdr.g, ap1_sdr.g, ap1_post_process.g),
      UpgradeToneMapRatio(ap1_hdr.b, ap1_sdr.b, ap1_post_process.b));

  float3 color_scaled = ap1_post_process * ratio;
  color_scaled = renodx::color::bt709::from::AP1(color_scaled);
  // color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 ToneMap(float3 color) {
  color *= 1.5f;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 0;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;

  config.reno_drt_highlights = 1.00f;
  config.reno_drt_shadows = 1.0f;
  config.reno_drt_contrast = 2.0f;
  config.reno_drt_saturation = 3.0f * .73 * 2.f;
  config.reno_drt_dechroma = 2.f * 0.472f * 2.f * injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.f;

  config.reno_drt_hue_correction_method =
      renodx::tonemap::renodrt::config::hue_correction_method::ICTCP;

  config.hue_correction_type =
      renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = color;
  if (injectedData.toneMapHueCorrectionMethod == 1.f) {
    config.hue_correction_color = saturate(color);
  } else if (injectedData.toneMapHueCorrectionMethod == 2.f) {
    config.hue_correction_color = renodx::tonemap::uncharted2::BT709(color * 2.f);
  } else if (injectedData.toneMapHueCorrectionMethod == 3.f) {
    config.hue_correction_color = RenoDRTSmoothClamp(color);
  } else {
    config.hue_correction_type =
        renodx::tonemap::config::hue_correction_type::INPUT;
  }

  color = renodx::tonemap::config::Apply(color, config);

  if (injectedData.colorGradeColorSpace == 1.f) {
    // BT709 D65 => BT709 D93
    color = mul(float3x3(0.941922724f, -0.0795196890f, -0.0160709824f,
                         0.00374091602f, 1.01361334f, -0.00624059885f,
                         0.00760519271f, 0.0278747007f, 1.30704438f),
                color);
  } else if (injectedData.colorGradeColorSpace == 2.f) {
    // BT.709 D65 => BT.601 (NTSC-U)
    color = mul(float3x3(0.939542055f, 0.0501813553f, 0.0102765792f,
                         0.0177722238f, 0.965792834f, 0.0164349135f,
                         -0.00162159989f, -0.00436974968f, 1.00599133f),
                color);
  } else if (injectedData.colorGradeColorSpace == 3.f) {
    // BT.709 D65 => ARIB-TR-B09 D93 (NTSC-J)
    color = mul(float3x3(0.871554791f, -0.161164566f, -0.0151899587f,
                         0.0417598634f, 0.980491757f, -0.00258531118f,
                         0.00544220115f, 0.0462860465f, 1.73763155f),
                color);
  }

  return color;
}

void main(
    float4 v0: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11;
  uint4 bitmask, uiDest;
  uint levels;
  float4 fDest;

  // r0.xy = (cb0[34].xy < v0.xy);
  // r0.zw = (v0.xy < cb0[34].zw);
  // r0.xy = r0.zw ? r0.xy : 0;
  // r0.x = r0.y ? r0.x : 0;
  float3 color = 0;
  if ((cb0[34].x < v0.x && v0.x < cb0[34].z)
      && (cb0[34].y < v0.y && v0.y < cb0[34].w)) {
    int2 v0xy = asint(v0.xy);
    int2 cb034xy = asint(cb0[34].xy);
    r0.xy = (int2)v0.xy;
    r1.xy = asint(cb0[34].xy);
    r1.xy = (int2)(r0.xy) + -r1.xy;
    r1.xy = (int2)r1.xy;
    r1.xy = float2(0.5, 0.5) + int2(v0.xy - cb034xy);
    r1.zw = cb0[35].zw * r1.xy;
    r2.xy = cb0[35].xy * cb0[35].wz;
    r1.xy = r1.xy * cb0[35].zw + float2(-0.5, -0.5);
    r2.xy = float2(0.5625, 1.77777779) * r2.xy;
    r2.xy = min(float2(1, 1), r2.xy);
    r1.xy = r1.xy * r2.xy + float2(0.5, 0.5);
    r1.zw = r1.zw * cb0[31].xy + cb0[30].xy;
    r1.zw = cb0[0].zw * r1.zw;

    r2.xyz = t1.SampleLevel(s0_s, r1.zw, 0).xyz;
    float3 t1Sample = r2.xyz;

    // PQ to 100

    if (false) {
      r3.xyz = float3(0.00999999978, 0.00999999978, 0.00999999978) * r2.xyz;
      r3.xyz = max(float3(0, 0, 0), r3.xyz);
      r3.xyz = log2(r3.xyz);
      r3.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r3.xyz;
      r3.xyz = exp2(r3.xyz);
      r4.xyzw = r3.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
      r1.zw = rcp(r4.yw);
      r1.zw = r4.xz * r1.zw;
      r1.zw = log2(r1.zw);
      r1.zw = float2(78.84375, 78.84375) * r1.zw;
      r1.zw = exp2(r1.zw);
      r4.xy = min(float2(1, 1), r1.zw);
      r1.zw = r3.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
      r0.w = rcp(r1.w);
      r0.w = r1.z * r0.w;
      r0.w = log2(r0.w);
      r0.w = 78.84375 * r0.w;
      r0.w = exp2(r0.w);
      r4.z = min(1, r0.w);
    }

    r4.xyz = renodx::color::pq::Encode(t1Sample, 100.f);

    uint w, h, d;
    t2.GetDimensions(w, h, d);
    // r3.xyz = cmp((uint3)r3.xyz == uint3(32, 32, 32));
    // r0.w = r3.y ? r3.x : 0;
    // r0.w = r3.z ? r0.w : 0;
    r0.w = (w == 32 && h == 32 && d == 32) ? 32 : 0;
    r1.z = r0.w ? 31 : 0;
    r3.xy = r0.ww ? float2(0.03125, 0.015625) : float2(1, 0.5);
    r0.w = r3.x * r1.z;
    r3.xyz = r4.xyz * r0.www + r3.yyy;  // Texel Centering
    r3.xyz = t2.SampleLevel(s1_s, r3.xyz, 0).xyz;

    float3 t2Sample = r3.xyz;

    // Clip input to SDR
    r2.xyz = saturate(r2.xyz);
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(0.454545438, 0.454545438, 0.454545438) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    // Gamma 2.2
    // Custom piecewise shadow control?
    r4.xyz = cmp(r2.xyz < float3(0.100000001, 0.100000001, 0.100000001));
    r5.xyz = float3(0.699999988, 0.699999988, 0.699999988) * r2.xyz;
    r6.xyz = cmp(r2.xyz < float3(0.200000003, 0.200000003, 0.200000003));
    r7.xyz = r2.xyz * float3(0.899999976, 0.899999976, 0.899999976) + float3(-0.0199999996, -0.0199999996, -0.0199999996);
    r8.xyz = cmp(r2.xyz < float3(0.300000012, 0.300000012, 0.300000012));
    r9.xyz = r2.xyz * float3(1.10000002, 1.10000002, 1.10000002) + float3(-0.0599999987, -0.0599999987, -0.0599999987);
    r10.xyz = cmp(r2.xyz < float3(0.5, 0.5, 0.5));
    r11.xyz = r2.xyz * float3(1.14999998, 1.14999998, 1.14999998) + float3(-0.075000003, -0.075000003, -0.075000003);
    r2.xyz = r10.xyz ? r11.xyz : r2.xyz;
    r2.xyz = r8.xyz ? r9.xyz : r2.xyz;
    r2.xyz = r6.xyz ? r7.xyz : r2.xyz;
    r2.xyz = r4.xyz ? r5.xyz : r2.xyz;
    r0.w = cmp(0 < cb0[38].x);

    float3 clippedSDR = r2.xyz;
    float3 lut1Output = r3.xyz;

    // choose SDR, clipped, shadowed 2.2 based on cb[38].x OR PQ LUT output
    r2.xyz = r0.www ? r2.xyz : r3.xyz;
    // Unknown use of GetDimensions for resinfo_ from missing reflection info, need manual fix.
    //   resinfo_indexable(texture3d)(float,float,float,float)_uint r3.xyz, l(0), t3.xyzw
    // Example for texture2d type, uint return:
    t3.GetDimensions(w, h, d);
    // r3.xyz = uiDest.xyz;
    // state = 0, constZero.eType = 4, returnType = 2, texture.eType = 7, afImmediates[0] = 0.000000
    // r3.xyz = cmp((uint3)r3.xyz == uint3(32, 32, 32));
    // r0.w = r3.y ? r3.x : 0;
    // r0.w = r3.z ? r0.w : 0;
    r0.w = (w == 32 && h == 32 && d == 32) ? 32 : 0;
    r1.z = r0.w ? 31.000000 : 0;
    r3.xy = r0.ww ? float2(0.03125, 0.015625) : float2(1, 0.5);
    r0.w = r3.x * r1.z;
    r3.xyz = r2.xyz * r0.www + r3.yyy;  // Texel Centering

    // Sample LUT2 with selected output from before
    r3.xyz = t3.SampleLevel(s1_s, r3.xyz, 0).xyz;
    float3 t3Sample = r3.xyz;

    // LUT2 PQ output => Linear
    r3.xyz = saturate(r3.xyz);
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r4.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r3.xyz;
    r3.xyz = -r3.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
    r3.xyz = rcp(r3.xyz);
    r3.xyz = r4.xyz * r3.xyz;
    r3.xyz = max(float3(0, 0, 0), r3.xyz);
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = float3(10000, 10000, 10000) * r3.xyz;

    float3 lut2output = r3.xyz;

    // LUT1 PQ output => Linear
    r2.xyz = saturate(r2.xyz);
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r4.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r2.xyz;
    r2.xyz = -r2.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
    r2.xyz = rcp(r2.xyz);
    r2.xyz = r4.xyz * r2.xyz;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(10000, 10000, 10000) + -r3.xyz;

    // cb0[26].z = HDR Luminance / 10

    r2.xyz = cb0[26].zzz * r2.xyz + r3.xyz;
    r1.xyzw = t4.SampleLevel(s2_s, r1.xy, 0).xyzw;
    float4 t4sample = r1.xyzw;

    if (injectedData.toneMapType != 0) {
      float3 color = t1Sample;
      renodx::tonemap::Config aces_config = renodx::tonemap::config::Create();
      aces_config.peak_nits = 1000.f;
      aces_config.game_nits = 100.f;
      aces_config.mid_gray_nits = 18.f;
      aces_config.gamma_correction = 0;

      // float3 reference_aces = renodx::color::srgb::DecodeSafe(RgbAcesHdrSrgb(color));
      float3 reference_aces = renodx::tonemap::config::ApplyACES(t1Sample * 1.5f, aces_config);

      if (injectedData.colorGradeLUTStrength) {
        float3 graded_aces = renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(t2Sample, 100.f));

        float3 color_graded = UpgradeToneMapPerChannel(t1Sample, reference_aces, graded_aces * 100.f / 256.f, 1);

        float3 lut_color = color_graded;
        // lut_color = corrected;

        color = lerp(color, lut_color, injectedData.colorGradeLUTStrength);
      }
      color = ToneMap(color);

      color = renodx::color::bt2020::from::BT709(color);
      color = max(0, color);

      r2.xyz = color * injectedData.toneMapGameNits;
    }

    // BT2020 Y
    r0.w = dot(r2.xyz, float3(0.262699991, 0.677999973, 0.0593000017));

    {
      // r2.xyz = r2.xyz + -r0.www;
      // r2.xyz = cb0[25].xxx * r2.xyz + r0.www;
      r2.rgb = lerp(r0.w, r2.rgb, cb0[25].x);  // blend to grayscale
    }

    // cb0[26].w = HDR Brightness
    r3.xyz = cb0[26].www * r2.xyz;
    r3.xyz = cmp(float3(0, 0, 0) < r3.xyz);
    r3.xyz = r3.xyz ? cb0[26].xxx : 0;

    // scale up by cb0[26].www
    // if not 0, add cb0[26].xxx (black floor?)
    r2.xyz = r2.xyz * cb0[26].www + r3.xyz;

    r0.w = cb0[25].y * r1.w;  // multiply UI alpha

    r1.w = rcp(cb0[26].y);  // relative to ?

    r3.xyz = r2.xyz * r1.www + float3(1, 1, 1);

    r3.xyz = rcp(r3.xyz);
    // Reinhard (Render * inverse)

    r1.w = r0.w * r0.w;

    {
      // r4.xyz = float3(1, 1, 1) + -r3.xyz;
      // r3.xyz = r1.www * r4.xyz + r3.xyz;
      r3.xyz = lerp(r3.xyz, 1.f, r1.w);
      // Lerp to 1.f based on alpha^2?
    }

    r2.xyz = r3.xyz * r2.xyz;

    // Encode UI as SRGB
    r3.xyz = cmp(r1.xyz < float3(0.00313080009, 0.00313080009, 0.00313080009));
    r4.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r1.xyz = r3.xyz ? r4.xyz : r1.xyz;

    // Decode UI as 2.2
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r1.xyz;
    r1.xyz = exp2(r1.xyz);

    // BT709 => BT2020
    r3.x = dot(float3(0.627403915, 0.329282999, 0.0433131009), r1.xyz);
    r3.y = dot(float3(0.0690973029, 0.919540584, 0.0113623003), r1.xyz);
    r3.z = dot(float3(0.0163914002, 0.0880132988, 0.895595312), r1.xyz);

    // Invert back
    r1.xyz = cb0[26].yyy * r3.xyz;
    r1.xyz = r2.xyz * r0.www + r1.xyz;

    // Encode to PQ
    r1.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r1.xyz;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyzw = r1.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
    r1.xy = rcp(r2.yw);
    r1.xy = r2.xz * r1.xy;
    r1.xy = log2(r1.xy);
    r1.xy = float2(78.84375, 78.84375) * r1.xy;
    r1.xy = exp2(r1.xy);
    r1.xy = min(float2(1, 1), r1.xy);

    r1.zw = r1.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
    r0.w = rcp(r1.w);
    r0.w = r1.z * r0.w;
    r0.w = log2(r0.w);
    r0.w = 78.84375 * r0.w;
    r0.w = exp2(r0.w);
    r0.w = min(1, r0.w);

    color = float3(r1.x, r1.y, r0.w);

    // add grain/noise
    r0.z = asuint(cb1[139].z) << 3;
    r2.xyz = (int3)r0.xyz & int3(63, 63, 63);
    r2.w = 0;
    r0.x = t0.Load(r2.xyzw).x;
    float t0Sample = r0.x;
    r0.x = r0.x * 2 + -1;

    // r0.x = r0.x * 2 + -1;
    // r0.y = cmp(0 < r0.x);
    // r0.z = cmp(r0.x < 0);
    // r0.y = (int)-r0.y + (int)r0.z;
    // r0.y = (int)r0.y;
    // r0.x = 1 + -abs(r0.x);

    // Perform the initial comparisons
    bool condition1 = (0.0 < r0.x);  // lt r0.y, l(0.000000), r0.x
    bool condition2 = (r0.x < 0.0);  // lt r0.z, r0.x, l(0.000000)

    // Calculate y based on the conditions
    int y = (condition1 ? 1 : 0) - (condition2 ? 1 : 0);  // iadd r0.y, -r0.y, r0.z

    // Convert y to a float
    float result = float(y);  // itof r0.y, r0.y

    r0.y = result;

    r0.x = 1 + -abs(r0.x);
    r0.x = sqrt(r0.x);
    r0.x = 1 + -r0.x;
    r0.x = r0.y * r0.x;

    r0.yz = r1.xy * float2(2, 2) + float2(-1, -1);
    r0.yz = float2(-0.998044968, -0.998044968) + abs(r0.yz);
    r0.yz = cmp(r0.yz < float2(0, 0));
    r1.zw = r0.xx * float2(0.000977517106, 0.000977517106) + r1.xy;
    o0.xy = saturate(r0.yz ? r1.zw : r1.xy);

    r0.y = r0.w * 2 + -1;
    r0.y = -0.998044968 + abs(r0.y);
    r0.y = cmp(r0.y < 0);
    r0.x = r0.x * 0.000977517106 + r0.w;
    o0.z = saturate(r0.y ? r0.x : r0.w);

    o0.w = 1;

  } else {
    o0.xyzw = float4(0, 0, 0, 0);
  }
  return;
}

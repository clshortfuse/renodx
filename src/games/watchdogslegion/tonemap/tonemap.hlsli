#include "../common.hlsli"

/// Identity through anchor; then approaches peak monotonically and concave down.
/// The anchor join is C2 continuous. Requires anchor < peak and compression_strength >= 1.
#define APPLYANCHOREDCUBICSHOULDER_GENERATOR(T)                                                          \
  T ApplyAnchoredCubicShoulder(T color, T peak, T anchor, float compression_strength) {                  \
    T shoulder_range = peak - anchor;                                                                    \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                \
    T weighted_distance = compression_strength * distance_from_anchor;                                   \
    T response_numerator = distance_from_anchor * (shoulder_range + weighted_distance);                  \
    T response_denominator = mad(                                                                        \
        shoulder_range, shoulder_range, weighted_distance * (shoulder_range + distance_from_anchor));    \
    return mad(shoulder_range, response_numerator / response_denominator, color - distance_from_anchor); \
  }

/// Identity through anchor; reaches peak at clip, then remains flat.
/// Monotonic, concave down, and C2 when clip meets the calculated minimum.
#define APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(T)                                                                        \
  T ApplyAnchoredCubicShoulder(                                                                                             \
      T color, T peak, T anchor, float compression_strength, T clip) {                                                      \
    T shoulder_range = peak - anchor;                                                                                       \
    T distance_from_anchor = max(color - anchor, (T)0.f);                                                                   \
    T input_range = clip - anchor;                                                                                          \
    T clipped_distance = min(distance_from_anchor, input_range);                                                            \
    T clip_position = clipped_distance / input_range;                                                                       \
    T clip_position_squared = clip_position * clip_position;                                                                \
    T clip_position_cubed = clip_position_squared * clip_position;                                                          \
    T residual_weight = (T)1.f - clip_position_cubed * mad(clip_position, mad((T)6.f, clip_position, (T) - 15.f), (T)10.f); \
    T weighted_distance = compression_strength * clipped_distance;                                                          \
    T response_numerator = clipped_distance * (shoulder_range + weighted_distance);                                         \
    T remaining_distance = shoulder_range * mad(compression_strength - 1.f, clipped_distance, shoulder_range);              \
    T response_denominator = mad(residual_weight, remaining_distance, response_numerator);                                  \
    return mad(shoulder_range, response_numerator / response_denominator, color - distance_from_anchor);                    \
  }

APPLYANCHOREDCUBICSHOULDER_GENERATOR(float)
APPLYANCHOREDCUBICSHOULDER_GENERATOR(float3)
APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(float)
APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR(float3)
#undef APPLYANCHOREDCUBICSHOULDER_GENERATOR
#undef APPLYANCHOREDCUBICSHOULDER_CLIP_GENERATOR

float EncodeARRILUT(float color, float black_offset, float black_threshold, float black_range) {
  renodx::color::arri::logc::EncodingParams params = renodx::color::arri::logc::c1000::PARAMS;
  float encoded = (renodx::color::arri::logc::Encode(color, params, false) - 0.0928f) / (1.0f - 0.0928f);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    encoded = select((encoded < black_threshold), (saturate((encoded - black_offset) / black_range) * black_threshold), encoded);
  } else if (CUSTOM_REMOVE_BLACK_CLIP != 0.f) {
    encoded = select(encoded < 0.03170447f,
                     saturate((encoded + 0.03170447f) / 0.06340894f) * 0.03170447f, encoded);
  }
  return saturate(encoded);
}

float3 DecodeARRILUT(float3 color) {
  renodx::color::arri::logc::EncodingParams params = renodx::color::arri::logc::c1000::PARAMS;
  if (RENODX_TONE_MAP_TYPE != 0.f && CUSTOM_REMOVE_BLACK_CLIP != 0.f) {
    color = renodx::math::Select(color < 0.03170447f, 2.f * color - 0.03170447f, color);
  }
  float3 logc_color = color * 0.9072f + 0.0928f;
  return (pow(10.f, (logc_color - params.d) / params.c) - params.b) / params.a;
}

float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  color_hdr = max(0, color_hdr);
  color_sdr = max(0, color_sdr);
  post_process_color = max(0, post_process_color);

  float3 ratio = float3(
      renodx::draw::UpgradeToneMapRatio(color_hdr.r, color_sdr.r, post_process_color.r),
      renodx::draw::UpgradeToneMapRatio(color_hdr.g, color_sdr.g, post_process_color.g),
      renodx::draw::UpgradeToneMapRatio(color_hdr.b, color_sdr.b, post_process_color.b));

  float3 color_scaled = max(0, post_process_color * ratio);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

static const float3x3 ACESOutputMat = {
  { 1.60475f, -0.53108f, -0.07367f },
  { -0.10208f, 1.10813f, -0.00605f },
  { -0.00327f, -0.07276f, 1.07602f }
};
static const float3x3 ACESOutputMatInverse = renodx::math::Invert3x3(ACESOutputMat);

void ACESFittedAP1Extended(float3 color, out float3 color_sdr, out float3 color_hdr) {
  const float3x3 ACESInputMat = {
    { 0.59719f, 0.35458f, 0.04823f },
    { 0.07600f, 0.90834f, 0.01566f },
    { 0.02840f, 0.13383f, 0.83777f }
  };
  color = mul(ACESInputMat, color);
  float3 a = color * (color + 0.0245786f) - 0.000090537f;
  float3 b = color * (0.983729f * color + 0.4329510f) + 0.238081f;
  float3 fitted = a / b;
  color_sdr = saturate(mul(ACESOutputMat, fitted));
  // Tangent at the rational curve's positive inflection; no SDR white clamp.
  float3 extended = renodx::math::Select(color > 0.24908324f, 0.16727666f + 0.90512937f * (color - 0.24908324f), fitted);
  // extended = max(0, extended);
  color_hdr = mul(ACESOutputMat, extended);
  color_hdr = max(0, color_hdr);
}

float3 UpgradeBlendedLUT(
    uint3 voxel_index,
    uint last_voxel_index,
    float3 graded_sdr_bt709) {
  if (RENODX_TONE_MAP_TYPE != 1.f) return graded_sdr_bt709;
  if (last_voxel_index == 0u) return graded_sdr_bt709;

  float3 scene_bt709 = DecodeARRILUT(float3(voxel_index) / float(last_voxel_index));

  float3 neutral_sdr_bt709;
  float3 hdr_bt709;
  ACESFittedAP1Extended(scene_bt709, neutral_sdr_bt709, hdr_bt709);
  float3 neutral_sdr_fitted = max(0.f, mul(ACESOutputMatInverse, neutral_sdr_bt709));
  float3 hdr_fitted = max(0.f, mul(ACESOutputMatInverse, hdr_bt709));
  float3 graded_sdr_fitted = max(0.f, mul(ACESOutputMatInverse, graded_sdr_bt709));
  float3 upgraded_fitted = UpgradeToneMapPerChannel(hdr_fitted, neutral_sdr_fitted, graded_sdr_fitted, 1.f);
  return lerp(scene_bt709, mul(ACESOutputMat, upgraded_fitted), CUSTOM_LUT_STRENGTH);
}

float4 EncodeHDRLUT(float _113, float _114, float _115, float4 HDROutput_000, float HDROutput_064) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color = float3(_113, _114, _115);
    float clip = 53.21469f;

    if (RENODX_SDR_EOTF_EMULATION != 0.f) {
      color = renodx::color::correct::GammaSafe(color);
      clip = renodx::color::correct::GammaSafe(clip);
    }

    if (RENODX_TONE_MAP_TYPE == 1.f) {
      float3 saturation_source_ap1 = renodx::color::ap1::from::BT709(color);
      color = mul(ACESOutputMatInverse, color);
      color = ApplyAnchoredTonalGrading(
          color, 0.16727666f, 0.16727666f,
          RENODX_TONE_MAP_CONTRAST, 0.1f * pow(RENODX_TONE_MAP_FLARE, 10.f), RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS, RENODX_TONE_MAP_CONTRAST_SHADOWS,
          RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS);
      color = ApplyAnchoredCubicShoulder(color, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 0.16727666f, 1.f, clip);
      color = renodx::color::ap1::from::BT709(mul(ACESOutputMat, color));
      color = ApplyAnchoredSaturationGrading(
          color, saturation_source_ap1, 0.16727666f,
          RENODX_TONE_MAP_SATURATION, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, RENODX_TONE_MAP_DECHROMA);
      color = renodx::color::bt709::from::AP1(color);
    } else {
      color = saturate(color);
    }

    color = renodx::color::bt2020::from::BT709(color);
    color = renodx::color::pq::EncodeSafe(color, RENODX_DIFFUSE_WHITE_NITS);

    return float4(color, 0.f);
  }
  _113 = saturate(_113);
  _114 = saturate(_114);
  _115 = saturate(_115);
  float _116;
  float _148;
  float _149;
  float _155;
  float _161;
  float _162;
  float _163;
  float _179;
  float _186;
  float _193;
  float _206;
  float _219;

  _116 = dot(float3(_113, _114, _115), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
  _148 = select((_116 > 0.5f), (((_116 * HDROutput_000.y) / (HDROutput_000.y - _116)) + HDROutput_000.x), (_116 / (1.000100016593933f - _116)));
  _149 = _116 + 9.999999747378752e-05f;
  _155 = _148 * 0.75f;
  _161 = (((_113 / _149) * 0.75f) * _148) + (select((_113 > 0.5f), (((HDROutput_000.y * _113) / (HDROutput_000.y - _113)) + HDROutput_000.x), (_113 / (1.000100016593933f - _113))) * 0.25f);
  _162 = (_155 * (_114 / _149)) + (select((_114 > 0.5f), (((_114 * HDROutput_000.y) / (HDROutput_000.y - _114)) + HDROutput_000.x), (_114 / (1.000100016593933f - _114))) * 0.25f);
  _163 = (_155 * (_115 / _149)) + (select((_115 > 0.5f), (((_115 * HDROutput_000.y) / (HDROutput_000.y - _115)) + HDROutput_000.x), (_115 / (1.000100016593933f - _115))) * 0.25f);
  _179 = saturate(max(max(_161, _162), _163) + -1.0f);
  _186 = HDROutput_064 * 9.999999747378752e-05f;
  _193 = exp2(log2(abs(_186 * (((1.0f - _179) * mad(0.04331360012292862f, _163, mad(0.3292819857597351f, _162, (_161 * 0.627403974533081f)))) + (_179 * mad(0.047561999410390854f, _163, mad(0.19859300553798676f, _162, (_161 * 0.7538449764251709f))))))) * 0.1593017578125f);
  _206 = exp2(log2(abs(_186 * mad(0.012477199546992779f, _163, mad(0.9417769908905029f, _162, (_161 * 0.045745600014925f))))) * 0.1593017578125f);
  _219 = exp2(log2(abs(_186 * mad(0.9836069941520691f, _163, mad(0.017604099586606026f, _162, (_161 * -0.0012105499627068639f))))) * 0.1593017578125f);
  return float4(exp2(log2(abs(((_193 * 18.8515625f) + 0.8359375f) / ((_193 * 18.6875f) + 1.0f))) * 78.84375f),
                exp2(log2(abs(((_206 * 18.8515625f) + 0.8359375f) / ((_206 * 18.6875f) + 1.0f))) * 78.84375f),
                exp2(log2(abs(((_219 * 18.8515625f) + 0.8359375f) / ((_219 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f);
}

float3 ApplyVanillaPQNoise(float3 color, Texture2D<float4> noise_texture, float2 position, float noise_size, float noise_frequency) {
  if (CUSTOM_NOISE == 0.f) return color;
  float3 noise = noise_texture.Load(int3(int(frac(noise_frequency * position.x) * noise_size), int(frac(noise_frequency * position.y) * noise_size), 0)).rgb;
  return color + ((0.03125f - saturate(color) * 0.015625f) * (noise - 0.5f)) * CUSTOM_NOISE;
}

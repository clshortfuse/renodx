/*
 * Copyright (C) 2026 RenoDX contributors
 * SPDX-License-Identifier: MIT
 */

#include "./shared.h"

struct AutoExposureData {
  float engine_luminance_factor;
  float luminance_factor;
  float min_luminance_ldr;
  float max_luminance_ldr;
  float middle_grey_luminance_ldr;
  float ev;
  float f_stop;
  uint peak_histogram_value;
};

cbuffer PerViewCB : register(b1) {
  float4x4 view_matrix : packoffset(c6);
  float4 subpixel_offset : packoffset(c10);
  uint use_compressed_hdr_buffers : packoffset(c44.w);
  float2 resolution_scale : packoffset(c48.z);
};

cbuffer PerInstanceCB : register(b2) {
  float4 position_to_view_texture : packoffset(c0);
  float4 tone_map_parameters : packoffset(c1);
  float4 tone_map_coefficients_high : packoffset(c2);
  float4 tone_map_coefficients_low : packoffset(c3);
  float4 use_default_lens_dirt : packoffset(c4);
  float2 gamma_brightness : packoffset(c5);
  uint2 exposure_index : packoffset(c5.z);
  uint black_and_white_mode : packoffset(c6);
  float view_white_level : packoffset(c6.y);
  float lens_flare_streak_width : packoffset(c6.w);
  float lens_flare_streak_radius : packoffset(c7);
  float lens_flare_streak_opacity : packoffset(c7.y);
  float lens_flare_streak_offset : packoffset(c7.z);
  float lens_dirt_strength : packoffset(c7.w);
  float lens_dirt_blend_weight : packoffset(c8);
  uint bloom_enabled : packoffset(c8.y);
  float bloom_veil_strength : packoffset(c8.z);
};

SamplerState linear_clamp_sampler : register(s0);

Texture2D<float4> lens_dirt_to_texture : register(t0);
Texture2D<float4> lens_dirt_from_texture : register(t1);
Texture2D<float4> lens_flare_texture : register(t2);
Texture2D<float4> bloom_texture : register(t3);
Texture2D<float4> scene_texture : register(t4);
StructuredBuffer<AutoExposureData> auto_exposure_buffer : register(t5);

static const float3 BT709_LUMINANCE = float3(0.2126f, 0.7152f, 0.0722f);

float3 PreserveBlackAndWhite(float3 color) {
  return black_and_white_mode != 0u ? dot(color, BT709_LUMINANCE).xxx : color;
}

float ComputeStreakMask(float2 texture_coordinate) {
  float view_sine;
  float view_cosine;
  sincos(view_matrix._m02 + view_matrix._m21, view_sine, view_cosine);

  const float2 centered_coordinate = texture_coordinate - 0.5f;
  const float2 streak_coordinate = float2(
      dot(float2(view_cosine, -0.5f * view_sine), centered_coordinate),
      dot(float2(0.5f * view_sine, view_cosine), centered_coordinate));
  const float radius_squared = dot(streak_coordinate, streak_coordinate);

  const float2 absolute_coordinate = abs(streak_coordinate);
  const float smaller_axis = min(absolute_coordinate.x, absolute_coordinate.y);
  const float larger_axis = max(absolute_coordinate.x, absolute_coordinate.y);
  const float axis_ratio = smaller_axis / larger_axis;
  const float ratio_squared = axis_ratio * axis_ratio;

  float atan_polynomial = mad(0.0208350997f, ratio_squared, -0.0851330012f);
  atan_polynomial = mad(atan_polynomial, ratio_squared, 0.180141002f);
  atan_polynomial = mad(atan_polynomial, ratio_squared, -0.330299497f);
  atan_polynomial = mad(atan_polynomial, ratio_squared, 0.999866009f);

  float polar_angle = axis_ratio * atan_polynomial;
  if (absolute_coordinate.y < absolute_coordinate.x) {
    polar_angle = 1.57079637f - polar_angle;
  }
  if (streak_coordinate.y < 0.f) {
    polar_angle -= 3.141593f;
  }
  if (min(streak_coordinate.x, streak_coordinate.y) < 0.f
      && max(streak_coordinate.x, streak_coordinate.y) >= 0.f) {
    polar_angle = -polar_angle;
  }
  polar_angle += 3.14159274f;

  const float noise_position = polar_angle * 651.898621f;
  const float noise_cell = floor(noise_position);
  const float noise_low = frac(sin(noise_cell) * 43758.5469f);
  const float noise_high = frac(sin(noise_cell + 1.f) * 43758.5469f);
  const float angular_noise = lerp(noise_low, noise_high, frac(noise_position));

  const float streak_radius = mad(
      angular_noise,
      lens_flare_streak_offset,
      lens_flare_streak_radius);
  const float distance_from_streak = abs(radius_squared - streak_radius * streak_radius);
  const float streak_edge = saturate(
      (distance_from_streak - lens_flare_streak_width)
      / -lens_flare_streak_width);
  return streak_edge * streak_edge * (3.f - 2.f * streak_edge);
}

float3 ApplyVanillaToneCurve(float3 color) {
  const bool3 use_low_curve = color < tone_map_parameters.xxx;

  const float4 red_coefficients = use_low_curve.x
                                      ? tone_map_coefficients_low
                                      : tone_map_coefficients_high;
  const float4 green_coefficients = use_low_curve.y
                                        ? tone_map_coefficients_low
                                        : tone_map_coefficients_high;
  const float4 blue_coefficients = use_low_curve.z
                                       ? tone_map_coefficients_low
                                       : tone_map_coefficients_high;

  float3 mapped;
  mapped.r = mad(red_coefficients.x, color.r, red_coefficients.z)
             / mad(red_coefficients.y, color.r, red_coefficients.w);
  mapped.g = mad(green_coefficients.x, color.g, green_coefficients.z)
             / mad(green_coefficients.y, color.g, green_coefficients.w);
  mapped.b = mad(blue_coefficients.x, color.b, blue_coefficients.z)
             / mad(blue_coefficients.y, color.b, blue_coefficients.w);

  return mapped;
}

float3 ApplyGammaBrightness(float3 color) {
  return exp2(
      log2(saturate(color * gamma_brightness.y))
      * gamma_brightness.x);
}

void main(
    float4 interpolant : INTERP0,
    float4 pixel_position : SV_POSITION0,
    out float4 output_color : SV_TARGET0) {
  const uint2 pixel_coordinate = (uint2)pixel_position.xy;
  float3 scene_color = scene_texture.Load(int3(pixel_coordinate, 0)).rgb;

  const float exposure = view_white_level
                         * auto_exposure_buffer[exposure_index.y].engine_luminance_factor;
  if (use_compressed_hdr_buffers != 0u) {
    scene_color *= exposure;
  }

  if (bloom_enabled != 0u) {
    const float2 bloom_coordinate = resolution_scale * interpolant.xy;
    const float2 lens_dirt_coordinate = interpolant.xy + subpixel_offset.xy;

    float3 lens_dirt;
    if (use_default_lens_dirt.x > 0.f) {
      lens_dirt = lens_dirt_from_texture.SampleLevel(linear_clamp_sampler, lens_dirt_coordinate, 0.f).rgb;
    } else {
      const float3 dirt_from = lens_dirt_from_texture.SampleLevel(linear_clamp_sampler, lens_dirt_coordinate, 0.f).rgb;
      const float3 dirt_to = lens_dirt_to_texture.SampleLevel(linear_clamp_sampler, lens_dirt_coordinate, 0.f).rgb;
      lens_dirt = lerp(dirt_from, dirt_to, lens_dirt_blend_weight);
    }
    lens_dirt = PreserveBlackAndWhite(lens_dirt);
    lens_dirt *= DISHONORED2_LENS_DIRT_AMOUNT;

    if (bloom_veil_strength > 0.f) {
      float3 bloom = bloom_texture.SampleLevel(linear_clamp_sampler, bloom_coordinate, 0.f).rgb;
      if (use_compressed_hdr_buffers != 0u) {
        bloom *= exposure;
      }
      bloom *= bloom_veil_strength;
      bloom = PreserveBlackAndWhite(bloom);
      bloom *= 1.f + lens_dirt_strength * lens_dirt;
      scene_color += bloom * DISHONORED2_BLOOM_INTENSITY;
    }

    lens_dirt += ComputeStreakMask(interpolant.xy) * lens_flare_streak_opacity;

    const float2 inverse_resolution_scale = rcp(resolution_scale);
    const float2 lens_flare_coordinate = saturate(
        bloom_coordinate - position_to_view_texture.zw * inverse_resolution_scale);
    float3 lens_flare = lens_flare_texture.SampleLevel(linear_clamp_sampler, lens_flare_coordinate, 0.f).rgb;
    if (use_compressed_hdr_buffers != 0u) {
      lens_flare *= exposure;
    }
    lens_flare *= mad(lens_dirt, 0.8f, 0.2f);
    scene_color += PreserveBlackAndWhite(lens_flare);
  }

  const float3 untonemapped = max(scene_color, 0.f) * interpolant.z;
  float3 neutral_sdr = ApplyVanillaToneCurve(untonemapped);
  float3 graded_sdr = ApplyGammaBrightness(neutral_sdr);

  if (shader_injection.override_black_clip != 0.f
      && RENODX_TONE_MAP_TYPE != 0.f) {
    const float3 neutral_black = ApplyVanillaToneCurve(0.f);
    const float3 graded_black = ApplyGammaBrightness(neutral_black);
    neutral_sdr = Dishonored2RemoveBlackFloor(neutral_sdr, neutral_black);
    graded_sdr = Dishonored2RemoveBlackFloor(graded_sdr, graded_black);
  }

  float3 final_color = graded_sdr;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    final_color = renodx::draw::ToneMapPass(
        untonemapped,
        graded_sdr,
        neutral_sdr);
  }

  output_color = float4(renodx::draw::RenderIntermediatePass(final_color), 1.f);
}

#include "../../shared.h"

Texture2D<float4> current_color_texture : register(t0);

Texture2D<float4> previous_history_texture : register(t1);

Texture2D<float4> velocity_texture : register(t2);

Texture2D<float4> depth_texture : register(t3);

SamplerState linear_sampler : register(s0);

SamplerState point_sampler : register(s1);

RWTexture2D<float4> current_history_output : register(u0);

struct CurrentNeighborhood {
  float3 filtered_color;
  float3 clip_min;
  float3 clip_max;
};

struct CurrentTap {
  float2 offset;
  float weight;
  bool tight_bounds;
};

// Filters the current frame and builds broad/tight color bounds for history clipping.
CurrentNeighborhood BuildCurrentNeighborhood(float2 uv, float2 inv_screen_size) {
  static const float CURRENT_FILTER_EXPONENT = 2.29f;
  static const float CURRENT_DIAGONAL_WEIGHT = exp(-CURRENT_FILTER_EXPONENT * 2.f);  // 0.0102548962f
  static const float CURRENT_CARDINAL_WEIGHT = exp(-CURRENT_FILTER_EXPONENT);        // 0.101266459f
  static const float CURRENT_CENTER_WEIGHT = 1.f;
  static const float CURRENT_NORMALIZATION = 1.f / (CURRENT_CENTER_WEIGHT + 4.f * CURRENT_CARDINAL_WEIGHT + 4.f * CURRENT_DIAGONAL_WEIGHT);  // 0.691522062f
  static const float INITIAL_BOUNDS_MIN = 100000.f;
  static const float INITIAL_BOUNDS_MAX = -100000.f;

  // Current filter uses a full 3x3 pixel neighborhood.
  //  a b c
  //  d e f
  //  g h i
  //
  // Tight clipping bounds use the cross only.
  //    b
  //  d e f
  //    h
  static const CurrentTap CURRENT_TAPS[9] = {
    { float2(-1.f, -1.f), CURRENT_DIAGONAL_WEIGHT, false },
    { float2(0.f, -1.f), CURRENT_CARDINAL_WEIGHT, true },
    { float2(1.f, -1.f), CURRENT_DIAGONAL_WEIGHT, false },
    { float2(-1.f, 0.f), CURRENT_CARDINAL_WEIGHT, true },
    { float2(0.f, 0.f), CURRENT_CENTER_WEIGHT, true },
    { float2(1.f, 0.f), CURRENT_CARDINAL_WEIGHT, true },
    { float2(-1.f, 1.f), CURRENT_DIAGONAL_WEIGHT, false },
    { float2(0.f, 1.f), CURRENT_CARDINAL_WEIGHT, true },
    { float2(1.f, 1.f), CURRENT_DIAGONAL_WEIGHT, false },
  };

  float3 filtered_sum = 0.f.xxx;
  float3 broad_min = INITIAL_BOUNDS_MIN;
  float3 broad_max = INITIAL_BOUNDS_MAX;
  float3 tight_min = INITIAL_BOUNDS_MIN;
  float3 tight_max = INITIAL_BOUNDS_MAX;

  [unroll]
  for (uint i = 0u; i < 9u; ++i) {
    const CurrentTap tap = CURRENT_TAPS[i];
    const float3 sample_color = current_color_texture.SampleLevel(point_sampler, uv + tap.offset * inv_screen_size, 0).xyz;

    filtered_sum += sample_color * tap.weight;
    broad_min = min(sample_color, broad_min);
    broad_max = max(sample_color, broad_max);

    if (tap.tight_bounds) {
      tight_min = min(sample_color, tight_min);
      tight_max = max(sample_color, tight_max);
    }
  }

  CurrentNeighborhood neighborhood;
  neighborhood.filtered_color = filtered_sum * CURRENT_NORMALIZATION;
  neighborhood.clip_min = broad_min + 0.5f * (tight_min - broad_min);
  neighborhood.clip_max = broad_max + 0.5f * (tight_max - broad_max);
  return neighborhood;
}

// Chooses the velocity from the current pixel or diagonal neighbors using nearest-depth selection.
float2 SelectNearestVelocity(float2 uv, float2 inv_screen_size) {
  // Velocity search uses center plus diagonal neighbors.
  //  a   b
  //    e
  //  c   d
  static const float2 VELOCITY_OFFSETS[5] = {
    float2(0.f, 0.f),
    float2(1.f, 1.f),
    float2(-1.f, 1.f),
    float2(1.f, -1.f),
    float2(-1.f, -1.f),
  };

  float2 velocity = velocity_texture.SampleLevel(point_sampler, uv, 0).xy;
  float nearest_abs_depth = abs(depth_texture.SampleLevel(point_sampler, uv, 0).x);

  [unroll]
  for (uint i = 1u; i < 5u; ++i) {
    const float2 candidate_uv = uv + VELOCITY_OFFSETS[i] * inv_screen_size;
    const float candidate_abs_depth = abs(depth_texture.SampleLevel(point_sampler, candidate_uv, 0).x);

    if (candidate_abs_depth <= nearest_abs_depth) {
      velocity = velocity_texture.SampleLevel(point_sampler, candidate_uv, 0).xy;
      nearest_abs_depth = candidate_abs_depth;
    }
  }

  return velocity;
}

// Rejects reprojected history samples that land outside normalized screen UVs.
bool IsInsideScreen(float2 uv) {
  return all(abs(uv - 0.5f.xx) < 0.5f.xx);
}

// Samples previous history with a nine-tap optimized Catmull-Rom reconstruction.
float3 SampleHistoryCatmullRom(float2 uv, float2 screen_size, float2 inv_screen_size) {
  const float2 base_pixel = floor(uv * screen_size - 0.5f.xx);
  const float4 near_pixel = base_pixel.xyxy + float4(0.5f, 0.5f, -0.5f, -0.5f);
  const float2 offset = uv * screen_size - near_pixel.xy;
  const float2 offset_squared = offset * offset;
  const float2 offset_cubed = offset_squared * offset;

  const float2 negative_weight = offset_squared - 0.5f.xx * (offset_cubed + offset);
  const float2 center_weight = 1.f.xx + 1.5f.xx * offset_cubed - 2.5f.xx * offset_squared;
  const float2 positive_weight = 0.5f.xx * (offset_cubed - offset_squared);
  const float2 middle_offset_weight = 1.f.xx - negative_weight - center_weight - positive_weight;
  const float2 middle_weight = center_weight + middle_offset_weight;

  const float2 negative_uv = near_pixel.zw * inv_screen_size;
  const float2 middle_offset = renodx::math::DivideSafe(middle_offset_weight, middle_weight, 0.f.xx);
  const float2 middle_uv = (near_pixel.xy + middle_offset) * inv_screen_size;
  const float2 positive_uv = (base_pixel + 2.5f.xx) * inv_screen_size;

  float3 history_color = 0.f.xxx;

  const float3 sample_u = float3(negative_uv.x, middle_uv.x, positive_uv.x);
  const float3 sample_v = float3(negative_uv.y, middle_uv.y, positive_uv.y);
  const float3 weight_u = float3(negative_weight.x, middle_weight.x, positive_weight.x);
  const float3 weight_v = float3(negative_weight.y, middle_weight.y, positive_weight.y);

  [unroll]
  for (int y = 0; y < 3; ++y) {
    [unroll]
    for (int x = 0; x < 3; ++x) {
      history_color += previous_history_texture.SampleLevel(linear_sampler, float2(sample_u[x], sample_v[y]), 0).xyz * weight_u[x] * weight_v[y];
    }
  }

  return history_color;
}

// Clips reprojected history toward the filtered current color inside the neighborhood color box.
float3 ClipHistory(float3 history_color, float3 filtered_color, float3 clip_min, float3 clip_max) {
  const float3 history_delta = history_color - filtered_color;
  const float3 max_scale = renodx::math::DivideSafe(clip_max - filtered_color, history_delta);
  const float3 min_scale = renodx::math::DivideSafe(clip_min - filtered_color, history_delta);
  const float3 clip_scale_rgb = max(min_scale, max_scale);
  const float clip_scale = saturate(renodx::math::Min(clip_scale_rgb));

  return history_delta * clip_scale + filtered_color;
}

// Computes how much clipped history survives based on luma distance and subpixel velocity.
float ComputeHistoryBlend(float3 history_color, float3 clip_min, float3 clip_max, float2 velocity, float2 screen_size) {
  const float history_luma = renodx::color::yf::from::BT709(history_color);
  const float min_luma = renodx::color::yf::from::BT709(clip_min);
  const float max_luma = renodx::color::yf::from::BT709(clip_max);
  const float luma_range = max_luma - min_luma;
  const float luma_edge_factor = renodx::math::DivideSafe(
      min(abs(history_luma - min_luma), abs(history_luma - max_luma)),
      luma_range,
      0.f);

  float2 subpixel_weight = frac(abs(velocity) * screen_size);
  subpixel_weight = 0.5f.xx - abs(subpixel_weight - 0.5f.xx);

  return saturate(0.15f * luma_edge_factor * (1.f + subpixel_weight.x + subpixel_weight.y));
}

[numthreads(8, 8, 1)]
void main(uint3 dispatch_thread_id: SV_DispatchThreadID) {
  uint screen_width, screen_height;
  current_color_texture.GetDimensions(screen_width, screen_height);
  if (dispatch_thread_id.x >= screen_width || dispatch_thread_id.y >= screen_height) return;

  const float2 screen_size = float2(screen_width, screen_height);
  const float2 inv_screen_size = 1.0.xx / screen_size;

  const float2 uv = (float2(dispatch_thread_id.xy) + 0.5f.xx) / screen_size;

  const CurrentNeighborhood neighborhood = BuildCurrentNeighborhood(uv, inv_screen_size);
  const float2 velocity = SelectNearestVelocity(uv, inv_screen_size);
  const float2 history_uv = uv - velocity;
  const float3 history_color = IsInsideScreen(history_uv)
                                   ? SampleHistoryCatmullRom(history_uv, screen_size, inv_screen_size)
                                   : neighborhood.filtered_color;
  const float3 clipped_history = ClipHistory(
      history_color,
      neighborhood.filtered_color,
      neighborhood.clip_min, neighborhood.clip_max);
  const float blend = ComputeHistoryBlend(
      history_color,
      neighborhood.clip_min, neighborhood.clip_max,
      velocity,
      screen_size);

  const float3 resolved_color = max(0, lerp(clipped_history, neighborhood.filtered_color, blend));

  // Preserve the original compute output packing: RGBR
  current_history_output[dispatch_thread_id.xy] = float4(resolved_color, resolved_color.r);
  return;
}

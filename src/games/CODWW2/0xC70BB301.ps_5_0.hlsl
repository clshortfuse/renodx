// WWII temporal anti-aliasing resolve. Runs after the scene tone-map/LUT pass
// on the PQ Rec.2020 image (R10G10B10A2):
//   t2  current frame, t3/t8 history, t7 packed motion vectors (raw uint),
//   t4/t5/t6 R8 luma buffers, t9/t10 R8 masks,
//   u7  append list of pixels resolved later (flag 0x200000).
// It also applies the game's film grain at the end (o0 only; the o1/o2
// history copies stay grain-free). Noise: t0 (256x512 BC4), animated by
// cb3[32].x, strength cb3[32].w. Film Grain Type selects:
//   0 Vanilla: the game's grain, strength scaled by RENODX_FX_FILM_GRAIN
//     (1 = vanilla).
//   1 RenoDX: renodx::effects::ApplyFilmGrain (luminance, Bartleson
//     film-density graininess) on linear Rec.2020 relative to Game Brightness.
//   2 RenoDX Colored: renodx::effects::ApplyFilmGrainColored (per-channel
//     AP1 grain).
// The RenoDX types replace the game's grain and use the same slider
// (RENODX_FX_FILM_GRAIN * 0.03, as in other RenoDX mods).
// Hand-translated from DXBC; immediates are the exact bytecode values.
#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t9 : register(t9);
Texture2D<float4> t10 : register(t10);

SamplerState s0_s : register(s0);
SamplerState s2_s : register(s2);

RWStructuredBuffer<uint2> u7 : register(u7);

cbuffer cb3 : register(b3) {
  float4 cb3[33];
}

static const float3 kLuma709 = float3(0.2126f, 0.7152f, 0.0722f);

uint MinGatherBits(float2 uv) {
  uint4 g = asuint(t7.Gather(s0_s, uv));
  return min(min(min(g.z, g.y), g.w), g.x);
}

float2 DecodeMotion(uint bits) {
  return float2(bits & 1023u, (bits >> 10) & 1023u) * 0.001956947147846222f - 1.f;
}

// Min/max of an R8 buffer over two gathers at uv -/+ half a texel.
float2 GatherMinMax(Texture2D<float4> tex, float2 uv) {
  float4 a = tex.Gather(s0_s, uv - cb3[24].zw * 0.5f);
  float4 b = tex.Gather(s0_s, uv + cb3[24].zw * 0.5f);
  float mn = min(min(min(min(a.z, a.y), a.w), a.x), min(min(min(b.z, b.y), b.w), b.x));
  float mx = max(max(max(max(a.z, a.y), a.w), a.x), max(max(max(b.z, b.y), b.w), b.x));
  return float2(mn, mx);
}

float OutsideRange(float value, float2 range) {
  return max(saturate(value - range.y), saturate(range.x - value));
}

void main(
    float4 v0 : SV_POSITION0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_TARGET0,
    out float4 o1 : SV_TARGET1,
    out float4 o2 : SV_TARGET2) {
  // Closest/minimum motion vector over a 4x2 footprint.
  uint motion_bits = min(MinGatherBits(v1 + cb3[23].zw), MinGatherBits(v1 - cb3[23].zw));
  float2 motion = DecodeMotion(motion_bits);
  bool history_flag = (motion_bits & 0x00100000u) != 0u;

  uint center_bits = MinGatherBits(v1);
  float2 motion_delta = motion - DecodeMotion(center_bits);
  float velocity_weight = saturate(1.f - (max(abs(motion_delta.y), abs(motion_delta.x)) * 26.66666603088379f - 0.3333333432674408f)) * 0.5f + 0.5f;
  uint resolve_bits = motion_bits & (center_bits | 0xFFDFFFFFu);

  // Nonlinear motion decoding, in UV.
  float2 abs_motion = abs(motion);
  float2 far_part = saturate((abs_motion - 0.5f) * 2.f);
  float2 near_part = min(abs_motion * 2.f, 1.f) * float2(0.0015625000232830644f, 0.0027777778450399637f);
  float2 offset = far_part * far_part * float2(0.01927083358168602f, 0.034259259700775146f) + near_part;
  offset = (motion >= 0.f) ? offset : -offset;
  float2 prev_uv = v1 - offset;

  float mask = (1.f - t9.SampleLevel(s0_s, v1, 0).x) * (1.f - t10.SampleLevel(s0_s, prev_uv, 0).x) * velocity_weight;

  float3 current = t2.SampleLevel(s0_s, v1, 0).xyz;
  float3 history = t3.SampleLevel(s0_s, prev_uv, 0).xyz;
  float history_test = history_flag ? 1.f : 0.f;
  float history_blend = history_flag ? 0.5f : 0.f;

  float rejection;
  if (0.025f < dot(abs(current - history), kLuma709) * history_test) {
    float current_luma = dot(current, kLuma709);
    float history_luma = dot(history, kLuma709);
    float2 range5 = GatherMinMax(t5, v1 - offset * 2.f);
    float2 range6 = GatherMinMax(t6, prev_uv - offset * 2.f);
    float2 range4 = GatherMinMax(t4, prev_uv);
    float a = min(OutsideRange(current_luma, range4), OutsideRange(current_luma, range5));
    float b = min(OutsideRange(history_luma, range5), OutsideRange(history_luma, range6));
    rejection = saturate(1.f - (max(b, a) * 80.f - 1.f));
  } else {
    rejection = 1.f;
  }

  // 3x3 neighborhood of the current frame.
  float2 texel = cb3[24].zw;
  float3 left = t2.SampleLevel(s0_s, v1 + float2(-texel.x, 0.f), 0).xyz;
  float3 right = t2.SampleLevel(s0_s, v1 + float2(texel.x, 0.f), 0).xyz;
  float3 up = t2.SampleLevel(s0_s, v1 + float2(0.f, -texel.y), 0).xyz;
  float3 down = t2.SampleLevel(s0_s, v1 + float2(0.f, texel.y), 0).xyz;
  float3 neighborhood_min = min(min(current, left), min(down, min(right, up)));
  float3 neighborhood_max = max(max(current, left), max(down, max(right, up)));
  float3 c00 = t2.SampleLevel(s0_s, v1 - texel, 0).xyz;
  float3 c10 = t2.SampleLevel(s0_s, v1 + float2(texel.x, -texel.y), 0).xyz;
  float3 c11 = t2.SampleLevel(s0_s, v1 + texel, 0).xyz;
  float3 c01 = t2.SampleLevel(s0_s, v1 + float2(-texel.x, texel.y), 0).xyz;
  neighborhood_min = min(min(neighborhood_min, c00), min(c01, min(c10, c11)));
  neighborhood_max = max(max(neighborhood_max, c00), max(c01, max(c10, c11)));

  float3 clamped_history = min(neighborhood_max, max(history, neighborhood_min));
  float3 resolved_history = lerp(clamped_history, history, rejection);
  float3 color = lerp(current, resolved_history, history_blend);

  float3 history2 = t8.SampleLevel(s0_s, prev_uv, 0).xyz;
  float3 clamped_history2 = min(neighborhood_max, max(neighborhood_min, history2));
  bool defer = 0.025f < dot(abs(color - clamped_history2), kLuma709);
  uint resolve_flag = resolve_bits & 0x00200000u;
  defer = defer && (resolve_flag != 0u);

  uint index = 0u;
  if (defer) {
    index = u7.IncrementCounter();
  }
  uint count, stride;
  u7.GetDimensions(count, stride);
  defer = defer && (index < count);

  if (defer) {
    int2 pixel = int2(v1 * cb3[23].xy);
    uint packed = ((uint)(mask * 255.f) << 24) | ((uint)pixel.y << 12) | (uint)pixel.x;
    u7[index] = uint2(resolve_bits, packed);
  } else {
    float3 history_clamped = min(max(color, neighborhood_max), max(min(color, neighborhood_min), history2));
    float2 f = frac(cb3[23].xy * prev_uv - 0.5f);
    float3 horizontal = lerp(left, right, f.x);
    float3 vertical = lerp(up, down, f.y);
    float2 w = f * f - f;
    float4 sharpen = float4(horizontal, 0.6544999480247498f) * float4(w.xxx * 0.6544999480247498f, w.x)
                   + float4(vertical, 0.6544999480247498f) * float4(w.yyy * 0.6544999480247498f, w.y);
    float4 sum = float4((sharpen.w + 1.f) * history_clamped - color * sharpen.w, 1.f) + sharpen;
    float3 delta = sum.xyz / sum.w - color;

    float decay = exp2(max(cb3[4].x, 0.01666666753590107f) * -9.617968559265137f);
    float limit = (resolve_flag != 0u) ? mask * decay : 0.f;
    // Fast approximate reciprocal of |delta|, as in the original.
    float3 inv = asfloat(0x7EF311C2 - asint(abs(delta)));
    float3 weight = min(limit, saturate(1.f - inv * 0.0009775171056389809f));
    color = weight * delta + color;
  }

  if (RENODX_FX_FILM_GRAIN_TYPE >= 0.5f) {
    // RenoDX film grain on linear Rec.2020, 1.0 = Game Brightness.
    float strength = RENODX_FX_FILM_GRAIN * 0.03f;
    float seed = frac(cb3[32].x * 0.6180339887f);
    float diffuse_nits = max(RENODX_DIFFUSE_WHITE_NITS, 1.f);
    float3 linear_bt2020 = renodx::color::pq::Decode(saturate(color), diffuse_nits);
    float3 grained;
    if (RENODX_FX_FILM_GRAIN_TYPE < 1.5f) {
      grained = renodx::effects::ApplyFilmGrain(
          linear_bt2020, v1, seed, strength, 1.f, false, renodx::color::BT2020_TO_XYZ_MAT);
    } else {
      float3 bt709 = renodx::color::bt709::from::BT2020(linear_bt2020);
      grained = renodx::color::bt2020::from::BT709(
          renodx::effects::ApplyFilmGrainColored(bt709, v1, seed.xxx + float3(0.f, 0.1f, 0.2f), strength, 1.f));
    }
    float3 grained_pq = renodx::color::pq::Encode(max(grained, 0.f), diffuse_nits);
    o0 = float4(strength > 0.f ? grained_pq : color, 1.f);
    o1 = float4(color, 1.f);
    o2 = float4(color, 1.f);
    return;
  }

  // Film grain (vanilla).
  float2 grain_scale = float2(cb3[23].w * cb3[23].x * 1080.f, 1080.f);
  int frame = (int)cb3[32].x;
  bool2 flip = (uint2(frame >> 1, frame >> 2) & 1u) != 0u;
  float2 grain_uv = flip ? 1.f - v1 : v1;
  grain_uv = (grain_uv * grain_scale + cb3[32].x * float2(97.f, 256.f)) * float2(0.00390625f, 0.001953125f);
  float noise = t0.Sample(s2_s, grain_uv).x * 2.f - 1.f;
  float median = max(min(color.g, color.r), min(color.b, max(color.g, color.r)));
  noise = (noise - median * median * noise) * cb3[32].w * RENODX_FX_FILM_GRAIN;

  o0 = float4(color * noise + color, 1.f);
  o1 = float4(color, 1.f);
  o2 = float4(color, 1.f);
}

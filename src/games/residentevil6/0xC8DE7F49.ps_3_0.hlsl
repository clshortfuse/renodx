#include "./shared.h"

float4 CBToneMapFilter__packed0 : register(c1);
sampler2D current_log_map : register(s0);
sampler2D previous_log_map : register(s1);

float4 main() : COLOR0 {
  float current_sum = 0.f;
  float previous_sum = 0.f;
  [unroll]
  for (int y = 0; y < 4; ++y) {
    [unroll]
    for (int x = 0; x < 4; ++x) {
      float2 uv = float2(x, y) * 0.25f;
      current_sum += tex2D(current_log_map, uv).r;
      previous_sum += tex2D(previous_log_map, uv).r;
    }
  }
  float current = exp2(current_sum * -0.0901684389f);
  float previous = exp2(previous_sum * -0.0901684389f);
  bool current_valid = isfinite(current_sum) && isfinite(current);
  bool previous_valid = isfinite(previous_sum) && isfinite(previous);
  // A contaminated history must not keep exposure invalid after the current
  // scene has recovered. Valid samples retain the original adaptation equation.
  if (!current_valid) current = previous_valid ? previous : 1.f;
  if (!previous_valid) previous = current;
  return float4(lerp(current, previous, CBToneMapFilter__packed0.x) * CBToneMapFilter__packed0.y, 1.f, 1.f, 1.f);
}

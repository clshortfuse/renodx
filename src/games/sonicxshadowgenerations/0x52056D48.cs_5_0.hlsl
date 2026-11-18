#include "./shared.h"

// RenoDX: float4 port of packed-uint filter for upgraded RGBA16F target
cbuffer _Globals : register(b0)
{
  float4 u_filter_param[6] : packoffset(c0);
}

RWTexture2D<float4> rw_Output : register(u0);

// Match the SDR knots with monotone cubic segments and continuous slopes.
float ApplyCurve(float x) {
  float4 p = u_filter_param[4];
  float4 delta = p - float4(0.f, p.xyz);
  float end_tangent = clamp(delta.w, 0.f, 0.25f);
  if (x >= 1.f) return p.w + (x - 1.f) * (4.f * end_tangent);

  float3 left = delta.xyz;
  float3 right = delta.yzw;
  float3 joins = float3(
      left.x * right.x > 0.f ? 2.f * left.x * right.x / (left.x + right.x) : 0.f,
      left.y * right.y > 0.f ? 2.f * left.y * right.y / (left.y + right.y) : 0.f,
      left.z * right.z > 0.f ? 2.f * left.z * right.z / (left.z + right.z) : 0.f);
  float knots[5] = {0.f, p.x, p.y, p.z, p.w};
  float tangents[5] = {delta.x, joins.x, joins.y, joins.z, end_tangent};
  float s = x * 4.f;
  int segment = min((int)s, 3);
  float t = s - (float)segment;
  float t2 = t * t;
  return lerp(knots[segment], knots[segment + 1], t2 * (3.f - 2.f * t))
       + t * (1.f - t) * ((1.f - t) * tangents[segment] - t * tangents[segment + 1]);
}

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  if (!all(vThreadID.xy < (uint2)u_filter_param[5].xx)) return;

  float4 c = rw_Output[vThreadID.xy];
  // Apply one luminance-derived gain to all channels to preserve color ratios.
  float3 linear_color = renodx::draw::DecodeColor(c.rgb, RENODX_INTERMEDIATE_ENCODING);
  float luminance = max(0.f, renodx::color::y::from::BT709(linear_color));
  float encoded_luminance = pow(luminance, 1.f / 2.2f);
  float gain = encoded_luminance > 0.f ? ApplyCurve(encoded_luminance) / encoded_luminance : 1.f;
  float3 curved = c.rgb * gain;

  // Channel mix selected by u_filter_param[3].x, as in the original shader.
  float3x3 m = float3x3(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0);
  switch ((int)u_filter_param[3].x)
  {
    case 1:
      m = float3x3(0.56667, 0.43333, 0.0, 0.55833, 0.44167, 0.0, 0.0, 0.24167, 0.75833);
      break;
    case 2:
      // Normalize the red row so a neutral input stays neutral.
      m = float3x3(0.627 / 1.002, 0.375 / 1.002, 0.0, 0.7, 0.3, 0.0, 0.0, 0.3, 0.7);
      break;
    case 3:
      m = float3x3(0.95, 0.05, 0.0, 0.0, 0.43333, 0.56667, 0.0, 0.475, 0.525);
      break;
  }

  // The filter can also lift peak through its white offset or channel mix.
  // Scale RGB together in the gamma-encoded intermediate to preserve hue.
  float3 filtered = mul(m, curved);
  float3 display = renodx::color::bt2020::from::BT709(
      renodx::draw::DecodeColor(filtered, RENODX_INTERMEDIATE_ENCODING));
  float display_max = max(display.r, max(display.g, display.b));
  float peak = RENODX_PEAK_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  if (display_max > peak) {
    filtered *= pow(peak / display_max, 1.f / 2.2f);
  }
  // Alpha is forced to 1.0, matching the original's 0xff alpha byte.
  rw_Output[vThreadID.xy] = float4(filtered, 1.0);
}

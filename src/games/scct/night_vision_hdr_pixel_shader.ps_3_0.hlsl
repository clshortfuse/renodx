// Night Vision HDR image (ps_3_0). With the toggle on, the add-on draws night vision with this and
// night_vision_vertex_shader in place of the game's 0x4ADA0B05 (ps_1_1), which tints the 8-bit
// brightness in alpha: (t0.a + t1.a + t2.a) * c0 + t3.a * c1, then * 2 * (1 + c2), with ps_1_x's
// [-1, 1] clamps on constants and every result, so the image stays at or below white. t0-t2 are the
// game's glows (256, 128 and 64 texels square), t3 the full-size brightness with the grain.
// This draws the same image, then adds light by how far the glow alone (t1, t2), weighted up, would
// take it past white, soft-limited. The glow is smooth, so blown-out areas get brighter without the
// surface detail the game's white hides; the light is in the image's own colour at white, rather
// than the tint, which keeps the near-white hue night vision clips to.

sampler2D brightness_0 : register(s0);
sampler2D brightness_1 : register(s1);
sampler2D brightness_2 : register(s2);
sampler2D brightness_3 : register(s3);

float4 tint_brightness : register(c0);
float4 tint_extra : register(c1);
float4 tint_boost : register(c2);
float4 glow_sizes : register(c8);  // in texels, xy: s1, zw: s2
float4 peak_ratio : register(c9);  // x: Peak over Game Brightness

// The image is gamma-encoded; the excess and its limit are worked out in linear light.
static const float GAMMA = 2.2f;
// The glow's weight past white: at 1 it is what the game sums, which rarely reaches white alone.
static const float GLOW_STRENGTH = 2.f;
// The excess eases in over this much either side of white (linear), so its onset has no crease.
static const float EXCESS_KNEE = 0.25f;
// The excess is added as a layer of light, fading in with the game's image from this much of white
// (gamma), so darker objects in front of a light keep their shape.
static const float LAYER_FROM = 0.33f;
// R2 low-discrepancy dither (Roberts) over the pixel position against HDR10 banding: peak to peak
// DITHER_STRENGTH of the colour (linear), full once the layer adds 1 / DITHER_ONSET of white.
static const float2 DITHER_PATTERN = float2(0.7548776662f, 0.5698402910f);
static const float DITHER_STRENGTH = 0.018f;
static const float DITHER_ONSET = 16.f;

// Cubic B-spline upsampling from 4 bilinear taps (Sigg and Hadwiger, GPU Gems 2, ch. 20). The
// game's glows are tiny, and the boost amplifies the creases their bilinear upsampling leaves at
// every texel edge.
float CubicSample(sampler2D glow, float2 texcoord, float2 size) {
  const float2 position = texcoord * size - 0.5f;
  const float2 f = frac(position);
  const float2 f2 = f * f;
  const float2 f3 = f2 * f;
  const float2 w0 = (1.f - 3.f * f + 3.f * f2 - f3) / 6.f;
  const float2 w1 = (4.f - 6.f * f2 + 3.f * f3) / 6.f;
  const float2 w3 = f3 / 6.f;
  const float2 first_weight = w0 + w1;
  const float2 corner = position - f;
  const float2 first_tap = (corner - 0.5f + w1 / first_weight) / size;
  const float2 second_tap = (corner + 1.5f + w3 / (1.f - first_weight)) / size;
  return lerp(lerp(tex2D(glow, second_tap).a, tex2D(glow, float2(first_tap.x, second_tap.y)).a, first_weight.x),
              lerp(tex2D(glow, float2(second_tap.x, first_tap.y)).a, tex2D(glow, first_tap).a, first_weight.x),
              first_weight.y);
}

float4 main(float2 texcoord_0 : TEXCOORD0, float2 texcoord_1 : TEXCOORD1,
            float2 texcoord_2 : TEXCOORD2, float2 texcoord_3 : TEXCOORD3,
            float2 pixel_position : VPOS) : COLOR {
  const float4 c0 = clamp(tint_brightness, -1.f, 1.f);
  const float4 c1 = clamp(tint_extra, -1.f, 1.f);
  const float4 c2 = clamp(tint_boost, -1.f, 1.f);

  float brightness = clamp(tex2D(brightness_0, texcoord_0).a + tex2D(brightness_1, texcoord_1).a, -1.f, 1.f);
  brightness = clamp(brightness + tex2D(brightness_2, texcoord_2).a, -1.f, 1.f);
  float4 color = clamp(brightness * c0, -1.f, 1.f);
  color = clamp(tex2D(brightness_3, texcoord_3).a * c1 + color, -1.f, 1.f);
  color = saturate((color * c2 + color) * 2.f);

  const float smooth_glow_brightness = CubicSample(brightness_1, texcoord_1, glow_sizes.xy)
                                       + CubicSample(brightness_2, texcoord_2, glow_sizes.zw);
  const float3 glow = GLOW_STRENGTH * smooth_glow_brightness * c0.rgb * 2.f * (1.f + c2.rgb);
  const float glow_peak = max(0.f, max(glow.r, max(glow.g, glow.b)));
  const float past_white = pow(glow_peak, GAMMA) - 1.f;
  float excess = max(0.f, past_white);
  if (abs(past_white) < EXCESS_KNEE) {
    excess = (past_white + EXCESS_KNEE) * (past_white + EXCESS_KNEE) / (4.f * EXCESS_KNEE);
  }
  // At most what Peak leaves above white (linear): x / (1 + x / limit) approaches it without
  // reaching it, so the glow rolls off toward Peak instead of clipping flat there.
  const float limit = max(1e-3f, peak_ratio.x - 1.f);
  const float image_peak = max(color.r, max(color.g, color.b));
  const float added = excess / (1.f + excess / limit) * smoothstep(LAYER_FROM, 1.f, image_peak);
  const float3 image_white = pow(color.rgb / max(image_peak, 1e-4f), GAMMA);
  const float dither = frac(dot(pixel_position, DITHER_PATTERN)) - 0.5f;
  const float3 linear_color = (pow(color.rgb, GAMMA) + added * image_white)
                              * (1.f + dither * DITHER_STRENGTH * saturate(added * DITHER_ONSET));
  color.rgb = pow(max(0.f, linear_color), 1.f / GAMMA);
  return color;
}

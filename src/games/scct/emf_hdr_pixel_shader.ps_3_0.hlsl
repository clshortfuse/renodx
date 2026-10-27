// EMF HDR image (ps_3_0). With the toggle on, the add-on draws EMF with this and emf_vertex_shader
// in place of the game's 0x7CE55E3E (ps_1_1), which is `texbem`: it shifts its lookup of EMF's
// image (t3) by the wobble texture (t0, V8U8) through the bump-environment matrix, and shows it.
// That image is the game's 8-bit, 256-texel weighted sum of its EMF glow levels (0xCDFC48BC: the
// 256, 128, 64 and 32 texel levels, weighted 0.5, 1, 1, 0.5), so the sum clips at white.
// This draws the same image, then adds light by how far the levels' own sum, smoothed, goes past
// white, soft-limited toward Peak. Smoothed because past white the finer levels' surface detail
// shows as blotches the clip used to hide.

sampler2D wobble : register(s0);
sampler2D image : register(s3);
sampler2D level_0 : register(s4);
sampler2D level_1 : register(s5);
sampler2D level_2 : register(s6);
sampler2D level_3 : register(s7);

float4 level_weights[4] : register(c0);  // the game's, still set from its sum of the levels
float4 bump_matrix : register(c8);       // BUMPENVMAT00, 01, 10, 11 of stage 3
float4 peak_ratio : register(c9);        // x: Peak over Game Brightness
float4 level_sizes : register(c10);      // in texels, per level (square); the shader uses z and w

// The image is gamma-encoded; the excess and its limit are worked out in linear light.
static const float GAMMA = 2.2f;
// The excess eases in over this much either side of white (linear), so its onset has no crease.
static const float EXCESS_KNEE = 0.25f;
// R2 low-discrepancy dither (Roberts) over the pixel position against HDR10 banding: peak to peak
// DITHER_STRENGTH of the colour (linear), full once the layer adds 1 / DITHER_ONSET of white.
static const float2 DITHER_PATTERN = float2(0.7548776662f, 0.5698402910f);
static const float DITHER_STRENGTH = 0.018f;
static const float DITHER_ONSET = 16.f;
static const float SMOOTHING_WEIGHTS[4] = {0.125f, 0.375f, 0.375f, 0.125f};

// Cubic B-spline upsampling from 4 bilinear taps (Sigg and Hadwiger, GPU Gems 2, ch. 20). The
// coarsest level is tiny, and the excess amplifies the creases its bilinear upsampling leaves at
// every texel edge.
float3 CubicSample(sampler2D level, float2 texcoord, float size) {
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
  return lerp(lerp(tex2D(level, second_tap).rgb, tex2D(level, float2(first_tap.x, second_tap.y)).rgb, first_weight.x),
              lerp(tex2D(level, float2(second_tap.x, first_tap.y)).rgb, tex2D(level, first_tap).rgb, first_weight.x),
              first_weight.y);
}

float4 main(float2 texcoord_0 : TEXCOORD0, float2 texcoord_3 : TEXCOORD3, float2 pixel_position : VPOS) : COLOR {
  // texbem: u += M00 * du + M10 * dv, v += M01 * du + M11 * dv.
  const float2 offset = tex2D(wobble, texcoord_0).rg;
  const float2 texcoord = texcoord_3 + offset.x * bump_matrix.xy + offset.y * bump_matrix.zw;
  float4 color = saturate(tex2D(image, texcoord));

  // The finer levels carry the detail of the glowing surfaces, which past white shows as a cloudy
  // mottle the clip used to hide: they are smoothed to the coarsest level's scale first, with a
  // B-spline (1, 3, 3, 1) grid of 4 x 4 bilinear taps one 64-texel level texel apart.
  float3 fine_sum = 0.f;
  [unroll] for (int y = 0; y < 4; ++y) {
    [unroll] for (int x = 0; x < 4; ++x) {
      const float2 tap = texcoord + (float2(x, y) - 1.5f) / level_sizes.z;
      const float weight = SMOOTHING_WEIGHTS[x] * SMOOTHING_WEIGHTS[y];
      fine_sum += weight * (tex2D(level_0, tap).rgb * level_weights[0].rgb + tex2D(level_1, tap).rgb * level_weights[1].rgb + tex2D(level_2, tap).rgb * level_weights[2].rgb);
    }
  }
  const float3 levels_sum = fine_sum + CubicSample(level_3, texcoord, level_sizes.w) * level_weights[3].rgb;
  const float sum_peak = max(0.f, max(levels_sum.r, max(levels_sum.g, levels_sum.b)));
  const float past_white = pow(sum_peak, GAMMA) - 1.f;
  float excess = max(0.f, past_white);
  if (abs(past_white) < EXCESS_KNEE) {
    excess = (past_white + EXCESS_KNEE) * (past_white + EXCESS_KNEE) / (4.f * EXCESS_KNEE);
  }
  // At most what Peak leaves above white (linear): x / (1 + x / limit) approaches it without
  // reaching it, so the excess rolls off toward Peak instead of clipping flat there.
  const float limit = max(1e-3f, peak_ratio.x - 1.f);
  const float image_peak = max(color.r, max(color.g, color.b));
  // In the image's own colour at white, which keeps the hue the game clips to.
  const float added = excess / (1.f + excess / limit) * saturate(image_peak * 2.f - 1.f);
  const float3 image_white = pow(color.rgb / max(image_peak, 1e-4f), GAMMA);
  const float dither = frac(dot(pixel_position, DITHER_PATTERN)) - 0.5f;
  const float3 linear_color = (pow(color.rgb, GAMMA) + added * image_white)
                              * (1.f + dither * DITHER_STRENGTH * saturate(added * DITHER_ONSET));
  color.rgb = pow(max(0.f, linear_color), 1.f / GAMMA);
  return color;
}

// Control - DeferredLightFiltering SPECULAR temporal PRE-ACCUMULATOR.
// Role is Remedy's: this blob is deferredlight_filtering_specular__0.
// Replacement for 0x600347E7: firefly clamp + neighborhood-
// clamped TAA. Vanilla's clamp box widens to sigma*8 when the camera is
// still (the source of the stationary boil) and tightens to sigma*1 in
// motion. Runs BEFORE the spatial passes — the main temporal stage for the
// specular channel.
// TEMPORAL_WEIGHT: 0.6 = vanilla, 0.0 = firefly clamp only, no accumulation.

// Final config: vanilla-strength clamp. This stage is part of the game's
// energy calibration (min(lum, local mip avg) biases reflection brightness
// down, and the art was tuned against that bias) — NOT just despeckling.
#ifndef FIREFLY_CLAMP
#define FIREFLY_CLAMP 1.0
#endif

#ifndef TEMPORAL_WEIGHT
#define TEMPORAL_WEIGHT 0.0
#endif

cbuffer sys_constants : register(b0) {
  float2 g_vInvScreenRes : packoffset(c0.z);
  float4 g_vPrevViewToViewCol3 : packoffset(c37);
};

cbuffer deferredlight_filtering : register(b1) {
  uint g_uCameraCut : packoffset(c2.x);
};

SamplerState linear_clamp : register(s6, space1);
SamplerState linear_mip_clamp : register(s11, space1);
Texture2D<float4> linear_depth : register(t0);
Texture2D<float4> prev_linear_depth : register(t1);
Texture2D<float4> velocity_tex : register(t2);
Texture2D<float3> source : register(t3);
Texture2D<float3> history_tex : register(t4);
RWTexture2D<float3> target : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 id: SV_DispatchThreadID) {
  int2 p = int2(id.xy);
  float2 pix = (float2)p + 0.5;
  float2 uv = pix * g_vInvScreenRes;

  // firefly clamp: limit luminance to the mip-blurred local level
  const float3 kLum = float3(0.2126, 0.7152, 0.0722);
  float3 c = source[p];
  float3 c_blur = source.SampleLevel(linear_mip_clamp, uv, 2.5);
  float lum_b = dot(c_blur, kLum);
  float lum_c = dot(c, kLum);

  // FIREFLY_CLAMP is a log-domain strength: 0 = off (raw), 1 = vanilla hard
  // cap; 0.5 removes half the excess *stops*. Linear lerp is useless here --
  // outliers are orders of magnitude, so perceptual blending must be
  // geometric: out = lum * (cap/lum)^s.
  float3 c_clamped;
  {
    float cap = min(lum_b, lum_c);
    float ratio = (lum_c > 0.0) ? min(cap / lum_c, 1.0) : 1.0;
    c_clamped = c * pow(ratio, (float)FIREFLY_CLAMP);
  }
  float3 result = c_clamped;

  static const float kTemporalWeight = TEMPORAL_WEIGHT;
  if (kTemporalWeight > 0.0) {
    float conf = (1.0 - (float)g_uCameraCut) * kTemporalWeight;
    float2 prev_uv = pix * g_vInvScreenRes
                   + velocity_tex.SampleLevel(linear_clamp, uv, 0).xy;
    float cur_z = linear_depth.SampleLevel(linear_clamp, uv, 0).x;
    float prev_z = prev_linear_depth.SampleLevel(linear_clamp, prev_uv, 0).x
                 + g_vPrevViewToViewCol3.z;
    conf *= (abs(prev_z - cur_z) / abs(cur_z) <= 0.04) ? 1.0 : 0.0;

    float3 hist = history_tex.SampleLevel(linear_clamp, prev_uv, 0);

    // neighborhood mean/sigma over the 4-cross + center
    float3 cl = source[p + int2(-1, 0)];
    float3 cr = source[p + int2(1, 0)];
    float3 cd = source[p + int2(0, 1)];
    float3 cu = source[p + int2(0, -1)];
    float3 mu = (c + cl + cr + cd + cu) * 0.2;
    float3 m2 = (c * c + cl * cl + cr * cr + cd * cd + cu * cu) * 0.2;
    float3 sigma = sqrt(max(m2 - mu * mu, 0.0));

    // clamp box scale: 8x when still -> 1x in motion
    float motion = length(pix * g_vInvScreenRes - prev_uv);
    sigma *= 8.0 - 7.0 * min(200.0 * motion, 1.0);

    float3 hist_clamped = min(max(hist, mu - sigma), mu + sigma);
    result = lerp(c_clamped, hist_clamped, conf);
  }

  if (any(isnan(result))) result = 0.0;
  target[p] = result;
}

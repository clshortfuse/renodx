#include "./common.hlsli"

// Decompiled from vanilla 0x5F91F19E (DOF/motion blur pass, 1280x720 RGBA8 cloned to RGBA16F).
// Vanilla: 8-tap blur along velocity, depth-gated, alpha = blur amount.
// RenoDX: Improved (sg_motion_blur >= 1.5) outputs the velocity map instead: xy = velocity (UV), z = depth, w = vanilla alpha.
// The composites then blur the full-resolution source with that map (SGFullResMotionBlur).

cbuffer _Globals : register(b0)
{
  float4 g_ViewportSize : packoffset(c32);
  float g_BlurRate : packoffset(c105.x);
}

SamplerState sampColor_sampler_s : register(s0);
SamplerState sampVelocityMap_sampler_s : register(s1);
SamplerState sampZBuffer_sampler_s : register(s2);
Texture2D<float4> sampColor_NedSmpignorenametexture : register(t0);
Texture2D<float4> sampVelocityMap_NedSmpignorenametexture : register(t1);
Texture2D<float4> sampZBuffer_NedSmpignorenametexture : register(t2);

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float2 uv = v1.xy;
  float3 center_color = sampColor_NedSmpignorenametexture.Sample(sampColor_sampler_s, uv).xyz;
  float center_depth = sampZBuffer_NedSmpignorenametexture.Sample(sampZBuffer_sampler_s, uv).x;
  float depth_limit = center_depth - 0.01f;

  // Velocity packs two 8-bit channels per component; vanilla decodes them as R + G/255 and remaps to [-1, 1].
  float4 velocity_packed = sampVelocityMap_NedSmpignorenametexture.Sample(sampVelocityMap_sampler_s, uv);
  float2 velocity = float2(dot(velocity_packed.xy, float2(1.f, 0.003922f)), dot(velocity_packed.zw, float2(1.f, 0.003922f)));
  velocity = velocity * 2.f - 1.f;

  float3 color_sum = center_color;
  float tap_count = 1.f;
  [loop]
  for (int i = 1; i < 8; i++) {
    float2 tap_uv = uv + velocity * (float(i) * 0.142857f);
    float3 tap_color = sampColor_NedSmpignorenametexture.Sample(sampColor_sampler_s, tap_uv).xyz;
    float tap_depth = sampZBuffer_NedSmpignorenametexture.Sample(sampZBuffer_sampler_s, tap_uv).x;
    float keep = step(depth_limit, tap_depth);
    color_sum += tap_color * keep;
    tap_count += keep;
  }

  float blur_amount = min(tap_count - 1.f, 1.f) * g_BlurRate * saturate(dot(abs(velocity), g_ViewportSize.xy) * 0.125f);

  // RenoDX: Improved writes the velocity map for the composites. Vanilla color is not needed in that mode.
  if (shader_injection.sg_motion_blur >= 1.5f) {
    o0 = float4(velocity, center_depth, blur_amount);
    return;
  }

  o0.xyz = color_sum / tap_count;
  o0.w = blur_amount;
}

// 0x3CB9BFBB: auto-exposure metering pass. 3x3 box (1/3 texel spacing), per-tap
// log-luminance, averaged over 9 taps.

#include "./common.hlsli"  // RenoDX

cbuffer cb0 : register(b0)
{
  float4 g_ViewportSize : packoffset(c32);
  float4 g_MiddleGray_Scale_LuminanceLow_LuminanceHigh : packoffset(c105);
}

SamplerState sampDif0_sampler_s : register(s0);
Texture2D<float4> sampDif0_NedSmpignorenametexture : register(t0);

float LogLuma(float2 uv)
{
  float3 color = saturate(sampDif0_NedSmpignorenametexture.Sample(sampDif0_sampler_s, uv).xyz);
  float luma = dot(color, float3(0.212500006, 0.715399981, 0.0720999986));
  luma = max(g_MiddleGray_Scale_LuminanceLow_LuminanceHigh.z, luma);
  luma = min(g_MiddleGray_Scale_LuminanceLow_LuminanceHigh.w, luma);
  return log2(luma + 0.0001) * 0.693147182;
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float2 texel = g_ViewportSize.zw * (1.0 / 3.0);
  float2 uv = v1.xy;

  float sum = LogLuma(uv + texel * float2(-1, -1));
  sum += LogLuma(uv + texel * float2(0, -1));
  sum += LogLuma(uv + texel * float2(1, -1));
  sum += LogLuma(uv + texel * float2(-1, 0));
  sum += LogLuma(uv);
  sum += LogLuma(uv + texel * float2(1, 0));
  sum += LogLuma(uv + texel * float2(-1, 1));
  sum += LogLuma(uv + texel * float2(0, 1));
  sum += LogLuma(uv + texel * float2(1, 1));

  o0.xyz = sum * (1.0 / 9.0);
  // RenoDX: center-weighted metering (screen mean of w is 1), Custom mode only
  if (shader_injection.sg_auto_exposure == 2.f) {
    float2 d = uv - 0.5f;
    float w = lerp(1.f, 1.5f * (1.f - 2.f * dot(d, d)), shader_injection.sg_ae_center_weight);
    o0.xyz *= w;
  }
  o0.w = 1;
}

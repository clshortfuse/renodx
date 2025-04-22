#include "../shared.h"
// ---- Created with 3Dmigoto v1.4.1 on Sun Apr 20 14:50:07 2025

cbuffer CTemporalEffectsProvider : register(b0) {
  float4 QuadParams : packoffset(c0);
  float4x4 CurrentToPrevMatrix : packoffset(c1);
  float4 JitterParameters : packoffset(c5);
  float4 LinearDepthTextureSize : packoffset(c6);
  float4 SceneTextureSize : packoffset(c7);
  float4 FinalTextureSize : packoffset(c8);
  float4 SceneTextureScale : packoffset(c9);
  float4 TemporalParameters : packoffset(c10);
}

SamplerState Clamp_s : register(s0);
Texture2D<float4> SceneColorTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

// from Pumbo
// 0 None
// 1 Reduce saturation and increase brightness until luminance is >= 0
// 2 Clip negative colors (makes luminance >= 0)
// 3 Snap to black
void FixColorGradingLUTNegativeLuminance(inout float3 col, uint type = 1)
        {
  if (type <= 0) { return; }

  float luminance = renodx::color::y::from::BT709(col.xyz);
  if (luminance < -renodx::math::FLT_MIN)  // -asfloat(0x00800000): -1.175494351e-38f
  {
    if (type == 1)
                {
      // Make the color more "SDR" (less saturated, and thus less beyond Rec.709) until the luminance is not negative anymore (negative luminance means the color was beyond Rec.709 to begin with, unless all components were negative).
      // This is preferrable to simply clipping all negative colors or snapping to black, because it keeps some HDR colors, even if overall it's still "black", luminance wise.
      // This should work even in case "positiveLuminance" was <= 0, as it will simply make the color black.
      float3 positiveColor = max(col.xyz, 0.0);
      float3 negativeColor = min(col.xyz, 0.0);
      float positiveLuminance = renodx::color::y::from::BT709(positiveColor);
      float negativeLuminance = renodx::color::y::from::BT709(negativeColor);
#pragma warning(disable: 4008)
      float negativePositiveLuminanceRatio = positiveLuminance / -negativeLuminance;
#pragma warning(default: 4008)
      negativeColor.xyz *= negativePositiveLuminanceRatio;
      col.xyz = positiveColor + negativeColor;
    }
                else if (type == 2)
                {
      // This can break gradients as it snaps colors to brighter ones (it depends on how the displays clips HDR10 or scRGB invalid colors)
      col.xyz = max(col.xyz, 0.0);
    }
                else  // if (type >= 3)
    {
      col.xyz = 0.0;
    }
  }
}

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    uint v2: SV_IsFrontFace0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = SceneTextureSize.zwzw * float4(0.5, 0.5, -0.5, 0.5) + v1.xyxy;
  r1.xyz = SceneColorTexture.SampleLevel(Clamp_s, r0.zw, 0).xyz;
  r0.xyz = SceneColorTexture.SampleLevel(Clamp_s, r0.xy, 0).xyz;

  // if (RENODX_TONE_MAP_TYPE) {
  //   r1.xyz = renodx::color::bt709::clamp::BT2020(r1.xyz);
  //   r0.xyz = renodx::color::bt709::clamp::BT2020(r0.xyz);
  // }

  r1.xyz = float3(0.25, 0.25, 0.25) * r1.xyz;
  r0.xyz = r0.xyz * float3(0.25, 0.25, 0.25) + r1.xyz;
  r1.xyzw = SceneTextureSize.zwzw * float4(0.5, -0.5, -0.5, -0.5) + v1.xyxy;
  r2.xyz = SceneColorTexture.SampleLevel(Clamp_s, r1.xy, 0).xyz;

  r1.xyz = SceneColorTexture.SampleLevel(Clamp_s, r1.zw, 0).xyz;

  // if (RENODX_TONE_MAP_TYPE) {
  //   r1.xyz = renodx::color::bt709::clamp::BT2020(r1.xyz);
  //   r2.xyz = renodx::color::bt709::clamp::BT2020(r2.xyz);
  // }

  r0.xyz = r2.xyz * float3(0.25, 0.25, 0.25) + r0.xyz;
  r0.xyz = r1.xyz * float3(0.25, 0.25, 0.25) + r0.xyz;
  r1.xyz = SceneColorTexture.SampleLevel(Clamp_s, v1.xy, 0).xyz;

  // if (RENODX_TONE_MAP_TYPE) r1.xyz = renodx::color::bt709::clamp::BT2020(r1.xyz);

  r1.xyz = r1.xyz + -r0.xyz;
  r0.w = 1 + TemporalParameters.x;
  o0.xyz = r0.www * r1.xyz + r0.xyz;
  o0.w = 1;

  if (RENODX_TONE_MAP_TYPE == 2.f) {
    o0.rgb = min(o0.rgb, RENODX_PEAK_WHITE_NITS / 80.f);
    o0.rgb = renodx::color::bt709::clamp::BT2020(o0.rgb);
  }
  return;
}

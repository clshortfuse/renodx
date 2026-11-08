#include "./common.hlsl"

cbuffer _Globals : register(b0)
{
  float3 g_PreLutScale : packoffset(c128);
  float3 g_PreLutOffset : packoffset(c129);
  float g_Slice : packoffset(c131);
  bool g_AssassinFilterEnabled : packoffset(c132);
  float g_AssassinFilterDesaturateIntensity : packoffset(c133);
  float4 g_AssassinFilterTintOpacity : packoffset(c134);
  float4x4 g_ColourControl : packoffset(c183);
  float g_ColorBalance_R[16] : packoffset(c135);
  float g_ColorBalance_G[16] : packoffset(c151);
  float g_ColorBalance_B[16] : packoffset(c167);
}

SamplerState _sampler_FrameBuffer_s : register(s0);
SamplerState _sampler_ColorBalanceR_s : register(s5);
SamplerState _sampler_ColorBalanceG_s : register(s6);
SamplerState _sampler_ColorBalanceB_s : register(s7);

Texture2D _texture_FrameBuffer : register(t0);
Texture2D _texture_ColorBalanceR : register(t5);
Texture2D _texture_ColorBalanceG : register(t6);
Texture2D _texture_ColorBalanceB : register(t7);

float3 ApplyGameLUTAndGrade(float3 encoded) {
  float3 address = encoded * g_PreLutScale + g_PreLutOffset;
  // The game's cbuffer supplies the 16-cell half-texel scale/offset.
  // Keep its original samplers and packed 1D addressing.
  float4 balanced = float4(
      _texture_ColorBalanceR.SampleLevel(_sampler_ColorBalanceR_s, float2(address.r, 0.5f), 0).x,
      _texture_ColorBalanceG.SampleLevel(_sampler_ColorBalanceG_s, float2(address.g, 0.5f), 0).x,
      _texture_ColorBalanceB.SampleLevel(_sampler_ColorBalanceB_s, float2(address.b, 0.5f), 0).x,
      1.f);
  float3 color = saturate(float3(
      dot(balanced, g_ColourControl._m00_m10_m20_m30),
      dot(balanced, g_ColourControl._m01_m11_m21_m31),
      dot(balanced, g_ColourControl._m02_m12_m22_m32)));
  if (g_AssassinFilterEnabled) {
    float y = dot(color, float3(0.212599993f, 0.715200007f, 0.0722000003f));
    float3 desaturated = lerp(color, y.xxx, g_AssassinFilterDesaturateIntensity);
    float3 tinted = desaturated * g_AssassinFilterTintOpacity.rgb;
    float3 overlay = renodx::math::Select(
        color < 0.5f,
        2.f * tinted * color,
        1.f - 2.f * (1.f - color) * (1.f - tinted));
    color = lerp(color, overlay, g_AssassinFilterTintOpacity.a);
  }
  return color;
}

void main(float4 position : SV_Position0, float2 uv : TEXCOORD0, out float4 output : SV_Target0) {
  float3 encoded = _texture_FrameBuffer.Sample(_sampler_FrameBuffer_s, uv).rgb;
  if (!IsCustomHDRMode() || RENODX_PEAK_WHITE_NITS <= 0.f) {
    output = float4(ApplyGameLUTAndGrade(encoded), 0.f);
    return;
  }

  float3 color = max(renodx::color::srgb::DecodeSafe(encoded), 0.f);
  // Identity throughout SDR range. Normalize HDR highlights by their maximum
  // channel for the SDR LUT, then restore that range after the original grade.
  float range = max(1.f, max(color.r, max(color.g, color.b)));
  float3 neutral_sdr = color / range;
  float3 graded_sdr = renodx::color::srgb::DecodeSafe(
      ApplyGameLUTAndGrade(renodx::color::srgb::EncodeSafe(neutral_sdr)));
  color = lerp(color, graded_sdr * range, saturate(CUSTOM_GRADING_STRENGTH));
  color = PostTonemapSliders(max(color, 0.f));
  output = float4(renodx::draw::RenderIntermediatePass(color), 0.f);
}

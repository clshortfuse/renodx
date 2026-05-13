// ---- Created with 3Dmigoto v1.3.16 on Mon May 11 17:39:43 2026
#include ".././common.hlsli"

cbuffer _Globals : register(b0)
{
  float3 g_PreLutScale : packoffset(c0);
  float3 g_PreLutOffset : packoffset(c1);
}

SamplerState FrameBuffer_s : register(s0);
SamplerState ColorBalance3DTexture_s : register(s1);
Texture2D<float4> FrameBuffer : register(t0);
Texture3D<float4> ColorBalance3DTexture : register(t1);


// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 0;

  float3 input = FrameBuffer.Sample(FrameBuffer_s, v1.xy).rgb;

  // Vanilla rendered into SDR UNORM targets before this pass. When the scene is
  // upgraded to FP16, preset-off needs to reintroduce that lost clamp here,
  // before we reconstruct LUT input from the framebuffer sample.
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    input = saturate(input);
  }

  // LUT offsets and grading are combined, so we separate them
  // game always uses 16x16x16 LUTs
  float3 untonemapped_gamma = (((input * g_PreLutScale.xyz + g_PreLutOffset.xyz) - 0.03125) / 0.9375);

  float3 untonemapped = renodx::color::gamma::DecodeSafe(untonemapped_gamma);

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float3 graded_gamma = ColorBalance3DTexture.Sample(
        ColorBalance3DTexture_s,
        saturate(untonemapped_gamma * 0.9375 + 0.03125)).rgb;
    float3 graded_linear = renodx::color::gamma::DecodeSafe(max(0, graded_gamma));
    float3 vanilla_linear = lerp(untonemapped, graded_linear, RENODX_COLOR_GRADE_STRENGTH);
    o0.rgb = renodx::draw::RenderIntermediatePass(saturate(max(0, vanilla_linear)));
  } else {
    renodx::lut::Config lut_config = CreateLUTConfig(ColorBalance3DTexture_s);
    const float scale = ComputeMaxChCompressionScale(untonemapped);

    const float3 color_hdr = untonemapped;
    const float3 color_sdr = color_hdr * scale;
    const float3 color_sdr_graded = Sample(ColorBalance3DTexture, lut_config, color_sdr);

    float3 color_final = color_sdr_graded / scale;

    o0.xyz = renodx::color::gamma::EncodeSafe(color_final, 2.2f);
    o0.rgb = ToneMapAndRenderIntermediatePass(o0.rgb, v1.xy);
  }

  return;
}

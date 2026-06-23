// filter_blur_only.hlsl - blur additive blend (no LUT)
//
// Minimal post-process: fullColor + blur contribution only.

#include "../shared.h"
#include "../common.hlsli"
Texture2D<float4> g_textures2D[] : register(t0, space1);

cbuffer Globals : register(b0) {
  int fullColor_tex_t : packoffset(c116.x);
  int fullColor_tex : packoffset(c116.y);
  int blur_tex_t : packoffset(c117.x);
  int blur_tex : packoffset(c117.y);
};

SamplerState g_samplers[] : register(s0);

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_2 : TEXCOORD2
) : SV_Target {
  uint fullTexIdx = (uint)(fullColor_tex_t);
  uint fullSmpIdx = (uint)(fullColor_tex);
  float3 fullColor = g_textures2D[fullTexIdx].Sample(g_samplers[fullSmpIdx], TEXCOORD.xy).xyz;

  uint blurTexIdx = (uint)(blur_tex_t);
  uint blurSmpIdx = (uint)(blur_tex);
  float3 blurColor = g_textures2D[blurTexIdx].Sample(g_samplers[blurSmpIdx], TEXCOORD.zw).xyz;

  float3 result = fullColor + blurColor * (TEXCOORD_2.x * 0.5f) * CUSTOM_BLOOM;
  result *= TEXCOORD_2.z;

  if (RENODX_TONE_MAP_TYPE == 0) result = saturate(result);
  else result = ColourCorrect(result, saturate(result));
  result = renodx::color::srgb::DecodeSafe(result);
  result = ApplyColorGrade(result);
  result = DisplayMap(result);
  result = renodx::draw::RenderIntermediatePass(result);

  return float4(result, 1.0f);
}

// fullColor + blur blend + vignette (no LUT)

#include "../shared.h"
#include "../common.hlsli"

Texture2D<float4> g_textures2D[] : register(t0, space1);
SamplerState g_samplers[] : register(s0);

cbuffer Globals : register(b0) {
  int fullColor_tex_t : packoffset(c116.x);
  int fullColor_tex : packoffset(c116.y);
  int noiseTex_t : packoffset(c116.z);
  int noiseTex : packoffset(c116.w);
  float4 g_VigParams : packoffset(c117);
  float4 g_VigColour : packoffset(c118);
  float4 g_VigColourB : packoffset(c119);
  int blur_tex_t : packoffset(c120.x);
  int blur_tex : packoffset(c120.y);
};

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_2 : TEXCOORD2
) : SV_Target {
  // Sample textures
  float4 fullColor = g_textures2D[fullColor_tex_t].Sample(g_samplers[fullColor_tex], float2(TEXCOORD.x, TEXCOORD.y));
  float4 blurColor = g_textures2D[blur_tex_t].Sample(g_samplers[blur_tex], float2(TEXCOORD.z, TEXCOORD.w));

  // Blend fullColor + blur
  float3 result = fullColor.rgb + blurColor.rgb * (TEXCOORD_2.x * 0.5f);
  result *= TEXCOORD_2.z;

  // Vignette attenuation
  float vignY = 1.0f - TEXCOORD.y;
  float vignX = 1.0f - TEXCOORD.x;
  float vignFactor = vignX * TEXCOORD.x * TEXCOORD.y * vignY * g_VigParams.y;
  vignFactor = max(0.0f, vignFactor);
  float vigAttenuation = exp2(log2(vignFactor) * g_VigParams.x);
  vigAttenuation = saturate(vigAttenuation);

  // Vignette color blend
  float3 vigColorDelta = (g_VigColourB.xyz - g_VigColour.xyz) * TEXCOORD.y;
  float3 vigRgb = g_VigColour.xyz - result.xyz + vigColorDelta.xyz;
  
  float vigAlpha = (g_VigColourB.w - g_VigColour.w) * TEXCOORD.y + g_VigColour.w;
  float3 vigBlend = vigRgb * vigAlpha * CUSTOM_VIGNETTE;

  result.xyz = vigBlend + result.xyz - (vigBlend * vigAttenuation);

  if (RENODX_TONE_MAP_TYPE == 0) result = saturate(result);
  else result = ColourCorrect(result, saturate(result));
  result = renodx::color::srgb::DecodeSafe(result);
  result = ApplyColorGrade(result);
  result = DisplayMap(result);
  result = renodx::draw::RenderIntermediatePass(result);

  return float4(result, 1.0f);
}

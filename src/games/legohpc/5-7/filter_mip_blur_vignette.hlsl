// filter_mip_blur_vignette.hlsl - mip blend + blur + vignette (no LUT)

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
  int mipColor1_tex_t : packoffset(c153.x);
  int mipColor1_tex : packoffset(c153.y);
};

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_2 : TEXCOORD2,
  linear float4 TEXCOORD_3 : TEXCOORD3
) : SV_Target {
  // Sample textures
  float4 fullColor = g_textures2D[fullColor_tex_t].Sample(g_samplers[fullColor_tex], float2(TEXCOORD.x, TEXCOORD.y));
  float4 mipColor = g_textures2D[mipColor1_tex_t].Sample(g_samplers[mipColor1_tex], float2(TEXCOORD.z, TEXCOORD.w));
  float4 blurColor = g_textures2D[blur_tex_t].Sample(g_samplers[blur_tex], float2(TEXCOORD.z, TEXCOORD.w));

  // Blend: mip + (full - mip) * mip.w
  float3 scene = mipColor.xyz + (fullColor.xyz - mipColor.xyz) * mipColor.w;
  scene = lerp(fullColor.xyz, scene, CUSTOM_DOF);
  
  // Add blur blend
  scene += blurColor.xyz * (TEXCOORD_2.x * 0.5f) * CUSTOM_BLOOM;
  
  // Scale by TEXCOORD_2.z
  scene *= TEXCOORD_2.z;

  // Vignette attenuation
  float vignY = 1.0f - TEXCOORD.y;
  float vignX = 1.0f - TEXCOORD.x;
  float vignFactor = vignX * TEXCOORD.x * TEXCOORD.y * vignY * g_VigParams.y;
  vignFactor = max(0.0f, vignFactor);
  float vigAttenuation = exp2(log2(vignFactor) * g_VigParams.x);
  vigAttenuation = saturate(vigAttenuation);

  // Vignette color blend
  float vigAlpha = (g_VigColourB.w - g_VigColour.w) * TEXCOORD.y + g_VigColour.w;
  float3 vigColorDelta = (g_VigColourB.xyz - g_VigColour.xyz) * TEXCOORD.y;
  float3 vigRgb = g_VigColour.xyz - scene.xyz + vigColorDelta.xyz * CUSTOM_VIGNETTE;
  float3 vigBlend = vigRgb * vigAlpha;
  
  float3 result = vigBlend + scene.xyz - (vigBlend * vigAttenuation);

  if (RENODX_TONE_MAP_TYPE == 0) result = saturate(result);
  else result = ColourCorrect(result, saturate(result));
  result = renodx::color::srgb::DecodeSafe(result);
  result = ApplyColorGrade(result);
  result = DisplayMap(result);
  result = renodx::draw::RenderIntermediatePass(result);

  return float4(result, 1.0f);
}

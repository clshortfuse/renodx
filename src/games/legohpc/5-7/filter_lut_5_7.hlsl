// filter_lut_5_7.hlsl - master LUT filter for LEGOHPC 5-7 variants.
//
// Optional defines before include:
//   FILTER_VIGNETTE - enable vignette pass and vignette cbuffer layout.
//   FILTER_MIP_BLEND - blend mipColor1 over fullColor before blur/LUT.
//   FILTER_TEXCOORD3 - include TEXCOORD3 in pixel-shader signature.
#include "../shared.h"
#include "../common.hlsli"

Texture2D<float4> g_textures2D[] : register(t0, space1);
Texture3D<float4> g_textures3D[] : register(t0, space2);

cbuffer Globals : register(b0) {
  int fullColor_tex_t : packoffset(c116.x);
  int fullColor_tex : packoffset(c116.y);

#if defined(FILTER_VIGNETTE)
  float4 g_VigParams : packoffset(c117.x);
  float4 g_VigColour : packoffset(c118.x);
  float4 g_VigColourB : packoffset(c119.x);

  int blur_tex_t : packoffset(c120.x);
  int blur_tex : packoffset(c120.y);

#if defined(FILTER_MIP_BLEND)
  int mipColor1_tex_t : packoffset(c153.x);
  int mipColor1_tex : packoffset(c153.y);
#endif

  int cubeTex_t : packoffset(c158.z);
  int cubeTex : packoffset(c158.w);
#else
  int blur_tex_t : packoffset(c117.x);
  int blur_tex : packoffset(c117.y);

#if defined(FILTER_MIP_BLEND)
  int mipColor1_tex_t : packoffset(c150.x);
  int mipColor1_tex : packoffset(c150.y);
#endif

  int cubeTex_t : packoffset(c155.z);
  int cubeTex : packoffset(c155.w);
#endif
};

SamplerState g_samplers[] : register(s0);

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_2 : TEXCOORD2,
  linear float4 TEXCOORD_4 : TEXCOORD4,
  linear float4 TEXCOORD_5 : TEXCOORD5
#if defined(FILTER_TEXCOORD3)
  , linear float4 TEXCOORD_3 : TEXCOORD3
#endif
) : SV_Target {
  uint fullTexIdx = (uint)(fullColor_tex_t);
  uint fullSmpIdx = (uint)(fullColor_tex);
  float3 fullColor = g_textures2D[fullTexIdx].Sample(g_samplers[fullSmpIdx], TEXCOORD.xy).xyz;

#if defined(FILTER_MIP_BLEND)
  uint mipTexIdx = (uint)(mipColor1_tex_t);
  uint mipSmpIdx = (uint)(mipColor1_tex);
  float4 mipSample = g_textures2D[mipTexIdx].Sample(g_samplers[mipSmpIdx], TEXCOORD.zw);

  // Decompiled order: mip + ((full - mip) * mip.a)
  float3 scene = mipSample.xyz + ((fullColor - mipSample.xyz) * mipSample.w);
#else
  float3 scene = fullColor;
#endif

  uint blurTexIdx = (uint)(blur_tex_t);
  uint blurSmpIdx = (uint)(blur_tex);
  float3 blurColor = g_textures2D[blurTexIdx].Sample(g_samplers[blurSmpIdx], TEXCOORD.zw).xyz;
  scene += blurColor * (TEXCOORD_2.x * 0.5f) * CUSTOM_BLOOM;

  scene *= TEXCOORD_4.y;
  float3 lutInput = scene;
  float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(lutInput);
  lutInput *= scale;

  uint cubeTexIdx = (uint)(cubeTex_t);
  uint cubeSmpIdx = (uint)(cubeTex);
  float4 hdr = g_textures3D[cubeTexIdx].Sample(g_samplers[cubeSmpIdx], lutInput) / scale;
  float4 lutColor = g_textures3D[cubeTexIdx].Sample(g_samplers[cubeSmpIdx], scene);
  lutColor.xyz = lerp(saturate(scene.xyz), lutColor.xyz, LUT_STRENGTH);
  hdr.xyz = lerp(scene.xyz, hdr.xyz, LUT_STRENGTH);
  if (RENODX_TONE_MAP_TYPE != 0) lutColor.xyz = ColourCorrect(hdr.xyz, lutColor.xyz);

#if defined(FILTER_VIGNETTE)
  float invY = 1.0f - TEXCOORD.y;
  float invX = 1.0f - TEXCOORD.x;
  float vigBase = (invX * TEXCOORD.x) * (TEXCOORD.y * invY) * g_VigParams.y;
  float vigFactor = renodx::math::SafePow(vigBase, g_VigParams.x);
  float4 vigDelta = (g_VigColourB - g_VigColour) * TEXCOORD.y;
  float vigW = vigDelta.w + g_VigColour.w;
  float3 vigRgb = g_VigColour.xyz - lutColor.xyz + vigDelta.xyz;

  float3 vigMix = vigW * vigRgb * CUSTOM_VIGNETTE;
  lutColor.xyz = (lutColor.xyz + vigMix) - (vigMix * vigFactor);
#endif

  lutColor.xyz = renodx::color::srgb::DecodeSafe(lutColor.xyz);
  lutColor.xyz = ApplyColorGrade(lutColor.xyz);
  lutColor.xyz = DisplayMap(lutColor.xyz);
  lutColor.xyz = renodx::draw::RenderIntermediatePass(lutColor.xyz);

  return lutColor;
}

// filter_lut_5_7.hlsl - master LUT filter for LEGOHPC 5-7 variants.
//
// Optional defines before include:
//   FILTER_VIGNETTE - enable vignette pass and vignette cbuffer layout.
//   FILTER_MIP_BLEND - blend mipColor1 over fullColor before blur/LUT.
//   FILTER_LUT_ONLY - fullColor -> scale -> LUT path (no blur, mip, vignette, or final display mapping).
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

float4 ApplyLut(float3 scene) {
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

  return lutColor;
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_4: TEXCOORD4,
    linear float4 TEXCOORD_5: TEXCOORD5) : SV_Target {
  uint fullTexIdx = (uint)(fullColor_tex_t);
  uint fullSmpIdx = (uint)(fullColor_tex);
  float3 fullColor = g_textures2D[fullTexIdx].Sample(g_samplers[fullSmpIdx], TEXCOORD.xy).xyz * TEXCOORD_4.y;

  float4 color = ApplyLut(fullColor);
  color.xyz = renodx::color::srgb::DecodeSafe(color.xyz);
  color.xyz = ApplyColorGrade(color.xyz);
  color.xyz = DisplayMap(color.xyz);
  color.xyz = renodx::draw::RenderIntermediatePass(color.xyz);
  return color;
}

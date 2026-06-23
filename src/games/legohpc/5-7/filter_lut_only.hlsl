// filter_lut_only.hlsl - minimal LUT-only filter (no blur, mip, or vignette)

#include "../shared.h"
#include "../common.hlsli"

Texture2D<float4> g_textures2D[] : register(t0, space1);
Texture3D<float4> g_textures3D[] : register(t0, space2);

cbuffer Globals : register(b0) {
  int fullColor_tex_t : packoffset(c116.x);
  int fullColor_tex : packoffset(c116.y);
  int cubeTex_t : packoffset(c155.z);
  int cubeTex : packoffset(c155.w);
};

SamplerState g_samplers[] : register(s0);

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_4 : TEXCOORD4,
  linear float4 TEXCOORD_5 : TEXCOORD5
) : SV_Target {
  uint fullTexIdx = (uint)(fullColor_tex_t);
  uint fullSmpIdx = (uint)(fullColor_tex);
  float4 fullColor = g_textures2D[fullTexIdx].Sample(g_samplers[fullSmpIdx], TEXCOORD.xy);

  // Scale color by TEXCOORD_4.y
  float3 scene = fullColor.xyz * TEXCOORD_4.y;
  float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(scene);
  float3 lutInput = scene * scale;
  // Sample 3D LUT
  uint cubeTexIdx = (uint)(cubeTex_t);
  uint cubeSmpIdx = (uint)(cubeTex);
  float4 hdr = g_textures3D[cubeTexIdx].Sample(g_samplers[cubeSmpIdx], lutInput) / scale;
  float4 lutColor = g_textures3D[cubeTexIdx].Sample(g_samplers[cubeSmpIdx], scene);
  lutColor.xyz = lerp(saturate(scene.xyz), lutColor.xyz, LUT_STRENGTH);
  hdr.xyz = lerp(scene.xyz, hdr.xyz, LUT_STRENGTH);
  if (RENODX_TONE_MAP_TYPE != 0) lutColor.xyz = ColourCorrect(hdr.xyz, lutColor.xyz);

  return lutColor;
}

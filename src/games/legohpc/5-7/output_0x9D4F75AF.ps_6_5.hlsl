#include "../shared.h"
Texture2D<float4> g_textures2D[] : register(t0, space1);

cbuffer Globals : register(b0) {
  int texture0_t : packoffset(c000.x);
  int texture0 : packoffset(c000.y);
  float4 uniformColor : packoffset(c015.x);
};

SamplerState g_samplers[] : register(s0);

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  float4 TEXCOORD0_centroid : TEXCOORD0_centroid
) : SV_Target {
  float4 SV_Target;
  float4 scene;
  scene = g_textures2D[texture0_t].Sample(g_samplers[texture0], float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
  //SV_Target.xyz = renodx::math::SafePow(scene.xyz, uniformColor.xyz);
  SV_Target.xyz = renodx::draw::SwapChainPass(scene.xyz);
  SV_Target.w = 1.0f;
  return SV_Target;
}
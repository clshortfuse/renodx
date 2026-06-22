#include "../shared.h"

Texture2D<float4> g_textures2D[] : register(t0, space2);

cbuffer Globals : register(b0) {
  float4 viewProj[4] : packoffset(c004.x);
  float4 fog_params : packoffset(c008.x);
  float4 vs_view[4] : packoffset(c009.x);
  float4 worldCamPos : packoffset(c013.x);
  float4 vs_projection_params : packoffset(c014.x);
  float4 vs_inverse_projection_xy : packoffset(c015.x);
  float4 vs_frustum_params : packoffset(c016.x);
  float4 ps2ShineMtx[4] : packoffset(c017.x);
  float4 vs_screenSize : packoffset(c021.x);
  float4 uvOffset01 : packoffset(c022.x);
  float4 vs_layer0_diffuse : packoffset(c023.x);
  float bitangentFlip : packoffset(c024.x);
  float dappleLimit : packoffset(c024.y);
  float vtf_kOffset : packoffset(c024.z);
  float vtf_kHeight : packoffset(c024.w);
  float4 vs_incandescentGlow : packoffset(c025.x);
  float4 vs_ambientColor : packoffset(c026.x);
  float4 uvOffset23 : packoffset(c027.x);
  float4 fxAttributes : packoffset(c028.x);
  float4 wind_params : packoffset(c029.x);
  float4 vs_fresnel_params : packoffset(c030.x);
  float4 vs_lightParams[7] : packoffset(c031.x);
  float4 vs_lightColors[4] : packoffset(c038.x);
  float4 vs_sceneAmbientColor : packoffset(c042.x);
  float4 vs_lightColor0 : packoffset(c043.x);
  float4 vs_lightColor1 : packoffset(c044.x);
  float4 vs_lightColor2 : packoffset(c045.x);
  float4 vs_lightPosition0 : packoffset(c046.x);
  float4 vs_lightPosition1 : packoffset(c047.x);
  float4 vs_lightPosition2 : packoffset(c048.x);
  float4 lightRotationMtx[4] : packoffset(c049.x);
  float4 worldParams[4][3] : packoffset(c053.x);
  float4 world[4] : packoffset(c065.x);
  float4 worldViewProj[4] : packoffset(c069.x);
  float4 worldView[4] : packoffset(c073.x);
  float4 lightmapOffset : packoffset(c077.x);
  float4 kTint : packoffset(c078.x);
  float4 vs_lightingAdjust : packoffset(c079.x);
  float lodLimit : packoffset(c080.x);
  float2 vs_fastBlendWeights : packoffset(c080.y);
  float4 vs_viewportScaleBias : packoffset(c081.x);
  float prevSkinMatrixOffset : packoffset(c082.x);
  float4 blur_params : packoffset(c083.x);
  float4 prevViewProj[4] : packoffset(c084.x);
  float4 prevView[4] : packoffset(c088.x);
  float4 prevWorld[4] : packoffset(c092.x);
  float4 skinMatrix[4][44] : packoffset(c096.x);
  float4 offsetTable[8] : packoffset(c272.x);
  float4 vertexGroupStates[32] : packoffset(c280.x);
  float4 waterTable[32] : packoffset(c312.x);
  float4 fs_lightParams[7] : packoffset(c344.x);
  float4 fs_lightColors[3] : packoffset(c351.x);
  float4 lightColor0 : packoffset(c354.x);
  float4 lightColor1 : packoffset(c355.x);
  float4 lightColor2 : packoffset(c356.x);
  float4 lightPosition0 : packoffset(c357.x);
  float4 lightPosition1 : packoffset(c358.x);
  float4 lightPosition2 : packoffset(c359.x);
  float4 sceneAmbientColor : packoffset(c360.x);
  float4 specLightData[6] : packoffset(c361.x);
  float4 specLightColor0 : packoffset(c367.x);
  float4 specLightColor1 : packoffset(c368.x);
  float4 specLightColor2 : packoffset(c369.x);
  float4 specLightPosition0 : packoffset(c370.x);
  float4 specLightPosition1 : packoffset(c371.x);
  float4 specLightPosition2 : packoffset(c372.x);
  float4 fs_lightingAdjust : packoffset(c373.x);
  float4 fs_screenSize : packoffset(c374.x);
  float4 time : packoffset(c375.x);
  float4 exposure : packoffset(c376.x);
  float4 fog_color : packoffset(c377.x);
  float4 fs_projection_params : packoffset(c378.x);
  float4 fs_inverse_projection_xy : packoffset(c379.x);
  float4 fs_frustum_params : packoffset(c380.x);
  float4 fs_viewportScaleBias : packoffset(c381.x);
  float3 envRotation[3] : packoffset(c382.x);
  int layer0_sampler_t : packoffset(c384.w);
  int layer0_sampler : packoffset(c385.x);
  float4 projection[4] : packoffset(c386.x);
  float4 planeEq : packoffset(c390.x);
  float4 uniformColor : packoffset(c391.x);
  int glow_tex_t : packoffset(c392.x);
  int glow_tex : packoffset(c392.y);
  int stencilValues_tex_t : packoffset(c392.z);
  int stencilValues_tex : packoffset(c392.w);
  int diffuse1_tex_t : packoffset(c393.x);
  int diffuse1_tex : packoffset(c393.y);
  int depth_tex_t : packoffset(c393.z);
  int depth_tex : packoffset(c393.w);
  float layer0_sampler_lod : packoffset(c394.x);
  float threshold : packoffset(c394.y);
  float2 depth_modifiers : packoffset(c394.z);
  float4 mips[10] : packoffset(c395.x);
  int hiresdepth : packoffset(c003.x);
  float4 depth_threshold : packoffset(c405.x);
  int blur_tex_final_t : packoffset(c406.x);
  int blur_tex_final : packoffset(c406.y);
};

SamplerState g_samplers[] : register(s0, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  float4 TEXCOORD0_centroid : TEXCOORD0_centroid
) : SV_TARGET {
  uint textureIdx = (uint)(layer0_sampler_t);
  uint samplerIdx = (uint)(layer0_sampler);
  
  float4 sampledColor = g_textures2D[textureIdx].Sample(g_samplers[samplerIdx], TEXCOORD0_centroid.xy);
  float3 color = renodx::math::SafePow(sampledColor.rgb, exposure.x); // wcg :D
  color = renodx::draw::SwapChainPass(color);
  return float4(color, 1.0f);
}
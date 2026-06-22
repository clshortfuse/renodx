// filter_lut.hlsli — master noise-LUT post-process filter.
//
// Define before including to enable features:
//   FILTER_MIP_BLEND   — alpha-blend mipColor over layer color before LUT
//   FILTER_BLUR        — add half-weighted blur texture to scene color (requires TEXCOORD2)
//   FILTER_VIGNETTE    — apply screen-edge vignette after LUT
//                        NOTE: also selects the vignette cbuffer layout (different packoffsets)
//   FILTER_TEXCOORD3   — declare (unused) float3 TEXCOORD3 input to match vertex output signature

#include "../shared.h"
#include "../common.hlsli"

Texture2D<float4> g_textures2D[] : register(t0, space2);
Texture3D<float4> g_textures3D[] : register(t0, space3);

cbuffer Globals : register(b0) {
  float4 viewProj[4] : packoffset(c000.x);
  float4 fog_params : packoffset(c004.x);
  float4 vs_view[4] : packoffset(c005.x);
  float4 worldCamPos : packoffset(c009.x);
  float4 vs_projection_params : packoffset(c010.x);
  float4 vs_inverse_projection_xy : packoffset(c011.x);
  float4 vs_frustum_params : packoffset(c012.x);
  float4 ps2ShineMtx[4] : packoffset(c013.x);
  float4 vs_screenSize : packoffset(c017.x);
  float4 uvOffset01 : packoffset(c018.x);
  float4 vs_layer0_diffuse : packoffset(c019.x);
  float bitangentFlip : packoffset(c020.x);
  float dappleLimit : packoffset(c020.y);
  float vtf_kOffset : packoffset(c020.z);
  float vtf_kHeight : packoffset(c020.w);
  float4 vs_incandescentGlow : packoffset(c021.x);
  float4 vs_ambientColor : packoffset(c022.x);
  float4 uvOffset23 : packoffset(c023.x);
  float4 fxAttributes : packoffset(c024.x);
  float4 wind_params : packoffset(c025.x);
  float4 vs_fresnel_params : packoffset(c026.x);
  float4 vs_lightParams[7] : packoffset(c027.x);
  float4 vs_lightColors[4] : packoffset(c034.x);
  float4 vs_sceneAmbientColor : packoffset(c038.x);
  float4 vs_lightColor0 : packoffset(c039.x);
  float4 vs_lightColor1 : packoffset(c040.x);
  float4 vs_lightColor2 : packoffset(c041.x);
  float4 vs_lightPosition0 : packoffset(c042.x);
  float4 vs_lightPosition1 : packoffset(c043.x);
  float4 vs_lightPosition2 : packoffset(c044.x);
  float4 lightRotationMtx[4] : packoffset(c045.x);
  float4 worldParams[4][3] : packoffset(c049.x);
  float4 world[4] : packoffset(c061.x);
  float4 worldViewProj[4] : packoffset(c065.x);
  float4 worldView[4] : packoffset(c069.x);
  float4 lightmapOffset : packoffset(c073.x);
  float4 kTint : packoffset(c074.x);
  float4 vs_lightingAdjust : packoffset(c075.x);
  float lodLimit : packoffset(c076.x);
  float2 vs_fastBlendWeights : packoffset(c076.y);
  float4 vs_viewportScaleBias : packoffset(c077.x);
  float prevSkinMatrixOffset : packoffset(c078.x);
  float4 blur_params : packoffset(c079.x);
  float4 prevViewProj[4] : packoffset(c080.x);
  float4 prevView[4] : packoffset(c084.x);
  float4 prevWorld[4] : packoffset(c088.x);
  float4 skinMatrix[4][44] : packoffset(c092.x);
  float4 offsetTable[8] : packoffset(c268.x);
  float4 vertexGroupStates[32] : packoffset(c276.x);
  float4 waterTable[32] : packoffset(c308.x);
  float4 fs_lightParams[7] : packoffset(c340.x);
  float4 fs_lightColors[3] : packoffset(c347.x);
  float4 lightColor0 : packoffset(c350.x);
  float4 lightColor1 : packoffset(c351.x);
  float4 lightColor2 : packoffset(c352.x);
  float4 lightPosition0 : packoffset(c353.x);
  float4 lightPosition1 : packoffset(c354.x);
  float4 lightPosition2 : packoffset(c355.x);
  float4 sceneAmbientColor : packoffset(c356.x);
  float4 specLightData[6] : packoffset(c357.x);
  float4 specLightColor0 : packoffset(c363.x);
  float4 specLightColor1 : packoffset(c364.x);
  float4 specLightColor2 : packoffset(c365.x);
  float4 specLightPosition0 : packoffset(c366.x);
  float4 specLightPosition1 : packoffset(c367.x);
  float4 specLightPosition2 : packoffset(c368.x);
  float4 fs_lightingAdjust : packoffset(c369.x);
  float4 fs_screenSize : packoffset(c370.x);
  float4 time : packoffset(c371.x);
  float4 exposure : packoffset(c372.x);
  float4 fog_color : packoffset(c373.x);
  float4 fs_projection_params : packoffset(c374.x);
  float4 fs_inverse_projection_xy : packoffset(c375.x);
  float4 fs_frustum_params : packoffset(c376.x);
  float4 fs_viewportScaleBias : packoffset(c377.x);
  float3 envRotation[3] : packoffset(c378.x);
  int layer0_sampler_t : packoffset(c380.w);
  int layer0_sampler : packoffset(c381.x);
  float4 projection[4] : packoffset(c382.x);
  float4 planeEq : packoffset(c386.x);
  float4 uniformColor : packoffset(c387.x);
  // From c388 onward the layout differs between vignette and non-vignette variants.
  // The vignette variants insert g_VigParams/g_VigColour/g_VigColourB after noiseTex,
  // which shifts blur_tex, mipColor_tex, cubeTex and everything after them by +4 slots.
  int noiseTex_t : packoffset(c388.x);
  int noiseTex : packoffset(c388.y);
#if defined(FILTER_VIGNETTE)
  float4 g_VigParams : packoffset(c389.x);
  float4 g_VigColour : packoffset(c390.x);
  float4 g_VigColourB : packoffset(c391.x);
  int blur_tex_t : packoffset(c392.x);
  int blur_tex : packoffset(c392.y);
  float4 thresholdPass : packoffset(c393.x);
  float4 bloomFactors : packoffset(c394.x);
  float4 bloomRadian_params : packoffset(c395.x);
  float4 bloomRadian_params2 : packoffset(c396.x);
  float4 bloomRadian_params3 : packoffset(c397.x);
  int CoC_tex_t : packoffset(c398.x);
  int CoC_tex : packoffset(c398.y);
  int depth_tex_t : packoffset(c398.z);
  int depth_tex : packoffset(c398.w);
  int mipColor_tex_t : packoffset(c399.x);
  int mipColor_tex : packoffset(c399.y);
  float4 motion_mtx[4] : packoffset(c400.x);
  float4 dofParams : packoffset(c404.x);
  float4 CoCParams : packoffset(c405.x);
  int colourTex_t : packoffset(c406.x);
  int colourTex : packoffset(c406.y);
  int cubeTex_t : packoffset(c406.z);
  int cubeTex : packoffset(c406.w);
  float4 noiseOffset : packoffset(c407.x);
  float4 noiseParams : packoffset(c408.x);
  float4 noiseParams2 : packoffset(c409.x);
  float4 half_pixel_offsets : packoffset(c410.x);
  float4 filter_params : packoffset(c411.x);
#else
  int blur_tex_t : packoffset(c388.z);
  int blur_tex : packoffset(c388.w);
  float4 thresholdPass : packoffset(c389.x);
  float4 bloomFactors : packoffset(c390.x);
  float4 bloomRadian_params : packoffset(c391.x);
  float4 bloomRadian_params2 : packoffset(c392.x);
  float4 bloomRadian_params3 : packoffset(c393.x);
  int CoC_tex_t : packoffset(c394.x);
  int CoC_tex : packoffset(c394.y);
  int depth_tex_t : packoffset(c394.z);
  int depth_tex : packoffset(c394.w);
  int mipColor_tex_t : packoffset(c395.x);
  int mipColor_tex : packoffset(c395.y);
  float4 motion_mtx[4] : packoffset(c396.x);
  float4 dofParams : packoffset(c400.x);
  float4 CoCParams : packoffset(c401.x);
  int colourTex_t : packoffset(c402.x);
  int colourTex : packoffset(c402.y);
  int cubeTex_t : packoffset(c402.z);
  int cubeTex : packoffset(c402.w);
  float4 noiseOffset : packoffset(c403.x);
  float4 noiseParams : packoffset(c404.x);
  float4 noiseParams2 : packoffset(c405.x);
  float4 half_pixel_offsets : packoffset(c406.x);
  float4 filter_params : packoffset(c407.x);
#endif
};

SamplerState g_samplers[] : register(s0, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
#if defined(FILTER_BLUR)
  linear float4 TEXCOORD_2 : TEXCOORD2,
#endif
  linear float4 TEXCOORD_4 : TEXCOORD4,
  linear float4 TEXCOORD_5 : TEXCOORD5
#if defined(FILTER_TEXCOORD3)
  , linear float3 TEXCOORD_3 : TEXCOORD3
#endif
) : SV_Target {
  // --- Noise offset ---
  uint noiseTexIdx = (uint)(noiseTex_t);
  uint noiseSmpIdx = (uint)(noiseTex);
  float3 noiseA = g_textures2D[noiseTexIdx].Sample(g_samplers[noiseSmpIdx], TEXCOORD_5.zw).xyz;
  float3 noiseB = g_textures2D[noiseTexIdx].Sample(g_samplers[noiseSmpIdx], TEXCOORD_5.xy).xyz;
  float3 noiseDelta = (noiseA - noiseB) * TEXCOORD_4.z;
  float3 noiseOffset = (noiseB - 0.5f) + noiseDelta;

  // --- Base layer ---
  uint layerTexIdx = (uint)(layer0_sampler_t);
  uint layerSmpIdx = (uint)(layer0_sampler);
  float3 layerColor = g_textures2D[layerTexIdx].Sample(g_samplers[layerSmpIdx], TEXCOORD.xy).xyz;

  // --- Optional mipColor alpha-blend over layer ---
#if defined(FILTER_MIP_BLEND)
  uint mipTexIdx = (uint)(mipColor_tex_t);
  uint mipSmpIdx = (uint)(mipColor_tex);
  float4 mipSample = g_textures2D[mipTexIdx].Sample(g_samplers[mipSmpIdx], TEXCOORD.zw);
  float3 scene = layerColor + ((mipSample.xyz - layerColor) * mipSample.w);
#else
  float3 scene = layerColor;
#endif

  // --- Optional blur additive contribution ---
#if defined(FILTER_BLUR)
  uint blurTexIdx = (uint)(blur_tex_t);
  uint blurSmpIdx = (uint)(blur_tex);
  float3 blurColor = g_textures2D[blurTexIdx].Sample(g_samplers[blurSmpIdx], TEXCOORD.zw).xyz;
  scene += blurColor * (TEXCOORD_2.x * 0.5f) * CUSTOM_BLOOM;
#endif

  // --- Luma-weighted noise displacement into LUT coords ---
  float3 weightedColor = scene * TEXCOORD_4.y;
  float luma = dot(float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f), weightedColor);
  float noiseAmount = (1.0f - (luma * luma)) * TEXCOORD_4.w;
  scene = weightedColor + (noiseAmount * noiseOffset);
  float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(scene);
  float3 lutInput = scene * scale;

  // --- 3D LUT sample ---
  uint cubeTexIdx = (uint)(cubeTex_t);
  uint cubeSmpIdx = (uint)(cubeTex);
  float4 hdr = g_textures3D[cubeTexIdx].Sample(g_samplers[cubeSmpIdx], lutInput) / scale;
  float4 lutColor = g_textures3D[cubeTexIdx].Sample(g_samplers[cubeSmpIdx], scene);
  lutColor.xyz = lerp(saturate(scene.xyz), lutColor.xyz, LUT_STRENGTH);
  hdr.xyz = lerp(scene.xyz, hdr.xyz, LUT_STRENGTH);
  if (RENODX_TONE_MAP_TYPE != 0) lutColor.xyz = ColourCorrect(hdr.xyz, lutColor.xyz);
  
  

  // --- Optional screen-edge vignette ---
#if defined(FILTER_VIGNETTE)
  float invY = 1.0f - TEXCOORD.y;
  float invX = 1.0f - TEXCOORD.x;
  float vigBase = (invX * TEXCOORD.x) * (TEXCOORD.y * invY) * g_VigParams.y;
  float vigFactor = saturate(renodx::math::SafePow(vigBase, g_VigParams.x));

  float4 vigColorDelta = (g_VigColourB - g_VigColour) * TEXCOORD.y;
  float4 vigBlend = g_VigColour + vigColorDelta;
  float3 vigDelta = vigBlend.w * ((g_VigColour.xyz - lutColor.xyz) + vigColorDelta.xyz) * CUSTOM_VIGNETTE;
  lutColor.xyz = (lutColor.xyz + vigDelta) - (vigDelta * vigFactor);
#endif

  lutColor.xyz = renodx::color::srgb::DecodeSafe(lutColor.xyz);
  lutColor.xyz = ApplyColorGrade(lutColor.xyz);
  lutColor.xyz = DisplayMap(lutColor.xyz);
  lutColor.xyz = renodx::draw::RenderIntermediatePass(lutColor.xyz);

  return lutColor;
}
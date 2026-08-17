struct ShadowCascade {
  float4 eye2lightProjMtx[4];
  float4 MinRadiusSq;
  float4 MaxRadiusSq;
  float4 CascadeUVScale;
  float4 CascadeZScale;
  float4 CascadeZShift;
  float4 softShadowFixedSpread;
  float4 softShadowSpreadRatio;
  float4 noiseScale;
};

struct ShadowCube {
  float4 viewMtx[4];
  float4 projParams;
  float4 params;
  float4 params1;
};

struct ShadowGrid {
  float4 eye2lightProjMtx[4];
  float4 softShadowParams;
};

struct ShadowParallelLISPSM {
  float4 ZRangeMin;
  float4 ZRangeMax;
  float4 eye2shadowMapUVMtx0[4];
  float4 eye2shadowMapUVMtx1[4];
  float4 eye2shadowMapUVMtx2[4];
  float4 eye2shadowMapUVMtx3[4];
};

struct ShadowParallelOrtho {
  float4 ZRangeMin;
  float4 ZRangeMax;
  float4 eye2shadowMapUVMtx[4];
  float4 OrthoShiftU;
  float4 OrthoShiftV;
  float4 OrthoShiftZ;
  float4 OrthoScaleU;
  float4 OrthoScaleV;
  float4 OrthoScaleZ;
  float4 softShadowFixedSpread;
  float4 softShadowSpreadRatio;
  float4 noiseScale;
};

struct ShadowPointSpot {
  float4 eye2shadowMapUVMtx[4];
  float4 params;
  float4 light2UVScaleOffset;
  float4 softShadowParams;
  float4 softShadowParams1;
};

struct LightData {
  float4 posDirRadius;
  float4 color;
  float4 params1;
  float4 params2;
};

struct ShadowCommon {
  float4 shadowFactors;
  float4 lightDirPos;
  float4 params;
};


#include "../shared.h"
#include "../common.hlsli"

Texture2D<float4> g_textures2D[] : register(t0, space1);

Texture3D<float4> g_textures3D[] : register(t0, space2);

cbuffer $Globals : register(b0) {
  int texture0_t : packoffset(c021.x);
  int texture0 : packoffset(c021.y);
  int texture1_t : packoffset(c021.z);
  int texture1 : packoffset(c021.w);
  int texture2_t : packoffset(c022.x);
  int texture2 : packoffset(c022.y);
  int texture3_t : packoffset(c022.z);
  int texture3 : packoffset(c022.w);
  int texture4_t : packoffset(c023.x);
  int texture4 : packoffset(c023.y);
  int lightmap0_t : packoffset(c023.z);
  int lightmap0 : packoffset(c023.w);
  int lightmap1_t : packoffset(c024.x);
  int lightmap1 : packoffset(c024.y);
  int lightmap2_t : packoffset(c024.z);
  int lightmap2 : packoffset(c024.w);
  int sceneEnvmap_samplerCube_t : packoffset(c025.x);
  int sceneEnvmap_samplerCube : packoffset(c025.y);
  int perm_sampler_t : packoffset(c025.z);
  int perm_sampler : packoffset(c025.w);
  int permgrad_sampler_t : packoffset(c026.x);
  int permgrad_sampler : packoffset(c026.y);
  int texAnimMap_sampler_t : packoffset(c026.z);
  int texAnimMap_sampler : packoffset(c026.w);
  int texAnimCurves_sampler_t : packoffset(c027.x);
  int texAnimCurves_sampler : packoffset(c027.y);
  int layer0_sampler_t : packoffset(c027.z);
  int layer0_sampler : packoffset(c027.w);
  int layer1_sampler_t : packoffset(c028.x);
  int layer1_sampler : packoffset(c028.y);
  int layer2_sampler_t : packoffset(c028.z);
  int layer2_sampler : packoffset(c028.w);
  int layer3_sampler_t : packoffset(c029.x);
  int layer3_sampler : packoffset(c029.y);
  int specular_sampler_t : packoffset(c029.z);
  int specular_sampler : packoffset(c029.w);
  int specular2_sampler_t : packoffset(c030.x);
  int specular2_sampler : packoffset(c030.y);
  int surface_sampler_t : packoffset(c030.z);
  int surface_sampler : packoffset(c030.w);
  int surface2_sampler_t : packoffset(c031.x);
  int surface2_sampler : packoffset(c031.y);
  int ps2_shinemap_sampler_t : packoffset(c031.z);
  int ps2_shinemap_sampler : packoffset(c031.w);
  int vtfNormal_sampler_t : packoffset(c032.x);
  int vtfNormal_sampler : packoffset(c032.y);
  int backBuffer_sampler_t : packoffset(c032.z);
  int backBuffer_sampler : packoffset(c032.w);
  int diffenvmap_samplerCube_t : packoffset(c033.x);
  int diffenvmap_samplerCube : packoffset(c033.y);
  int envmap_samplerCube_t : packoffset(c033.z);
  int envmap_samplerCube : packoffset(c033.w);
  float4 halfPixelOffset : packoffset(c034.x);
  LightData g_Light : packoffset(c035.x);
  float4 g_SpotViewProj[4] : packoffset(c039.x);
  ShadowCommon g_ShadowCommon : packoffset(c043.x);
  ShadowParallelOrtho g_Parallel : packoffset(c046.x);
  ShadowParallelLISPSM g_LISPSM : packoffset(c061.x);
  ShadowCascade g_Cascade : packoffset(c079.x);
  ShadowGrid g_Grid : packoffset(c091.x);
  ShadowPointSpot g_SpotPoint : packoffset(c096.x);
  ShadowCube g_Cube : packoffset(c104.x);
  int g_SceneDepthTex_t : packoffset(c111.x);
  int g_SceneDepthTex : packoffset(c111.y);
  int g_NormalsTex_t : packoffset(c111.z);
  int g_NormalsTex : packoffset(c111.w);
  int g_LuminanceTex_t : packoffset(c112.x);
  int g_LuminanceTex : packoffset(c112.y);
  int g_AlbedoTex_t : packoffset(c112.z);
  int g_AlbedoTex : packoffset(c112.w);
  int g_LightingTex_t : packoffset(c113.x);
  int g_LightingTex : packoffset(c113.y);
  int g_ShadowMapTex_t : packoffset(c113.z);
  int g_ShadowMapTex : packoffset(c113.w);
  int g_ShadowMapTexPCF_t : packoffset(c114.x);
  int g_ShadowMapTexPCF : packoffset(c114.y);
  int g_ShadowMapCubeTex_t : packoffset(c114.z);
  int g_ShadowMapCubeTex : packoffset(c114.w);
  int g_SpotTex_t : packoffset(c115.x);
  int g_SpotTex : packoffset(c115.y);
  int g_NoiseTex_t : packoffset(c115.z);
  int g_NoiseTex : packoffset(c115.w);
  int fullColor_tex_t : packoffset(c116.x);
  int fullColor_tex : packoffset(c116.y);
  int noiseTex_t : packoffset(c116.z);
  int noiseTex : packoffset(c116.w);
  int blur_tex_t : packoffset(c117.x);
  int blur_tex : packoffset(c117.y);
  float4 thresholdPass : packoffset(c118.x);
  float4 bloomFactors : packoffset(c119.x);
  float4 bloomRadian_params : packoffset(c120.x);
  float4 bloomRadian_params2 : packoffset(c121.x);
  float4 bloomRadian_params3 : packoffset(c122.x);
  float4 planeEq : packoffset(c123.x);
  float4 uniformColor : packoffset(c124.x);
  int normalGlow_tex_t : packoffset(c125.x);
  int normalGlow_tex : packoffset(c125.y);
  float4 tint : packoffset(c126.x);
  float4 offsetWeights[13] : packoffset(c127.x);
  float4 scaleBias : packoffset(c140.x);
  float4 projParams : packoffset(c141.x);
  float4 blurParams1 : packoffset(c142.x);
  float4 blurParams2 : packoffset(c143.x);
  float4 tintColour : packoffset(c144.x);
  float4 blurWeights1 : packoffset(c145.x);
  float4 blurWeights2 : packoffset(c146.x);
  float4 guardScaleBias : packoffset(c147.x);
  int colour_tex_t : packoffset(c148.x);
  int colour_tex : packoffset(c148.y);
  int CoC1_tex_t : packoffset(c148.z);
  int CoC1_tex : packoffset(c148.w);
  int CoC2_tex_t : packoffset(c149.x);
  int CoC2_tex : packoffset(c149.y);
  int depth_tex_t : packoffset(c149.z);
  int depth_tex : packoffset(c149.w);
  int mipColor1_tex_t : packoffset(c150.x);
  int mipColor1_tex : packoffset(c150.y);
  int mipColor2_tex_t : packoffset(c150.z);
  int mipColor2_tex : packoffset(c150.w);
  int mipColor3_tex_t : packoffset(c151.x);
  int mipColor3_tex : packoffset(c151.y);
  int mipColor4_tex_t : packoffset(c151.z);
  int mipColor4_tex : packoffset(c151.w);
  float4 dofParams : packoffset(c152.x);
  float4 blurOffsets : packoffset(c153.x);
  float4 blurWeights : packoffset(c154.x);
  int colourTex_t : packoffset(c155.x);
  int colourTex : packoffset(c155.y);
  int cubeTex_t : packoffset(c155.z);
  int cubeTex : packoffset(c155.w);
  float4 noiseOffset : packoffset(c156.x);
  float4 noiseParams : packoffset(c157.x);
  float4 noiseParams2 : packoffset(c158.x);
  float4 half_pixel_offsets : packoffset(c020.x);
  float4 filter_params : packoffset(c000.x);
};

SamplerState g_samplers[] : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 ApplyLut(float3 scene) {
  float3 lutInput = scene;
  float scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(lutInput);
  lutInput *= scale;

  uint cubeTexIdx = (uint)(cubeTex_t);
  uint cubeSmpIdx = (uint)(cubeTex);
  float4 hdr = g_textures3D[cubeTexIdx].Sample(g_samplers[cubeSmpIdx], lutInput) / scale;
  float4 color = g_textures3D[cubeTexIdx].Sample(g_samplers[cubeSmpIdx], scene);
  color.xyz = lerp(saturate(scene.xyz), color.xyz, LUT_STRENGTH);
  hdr.xyz = lerp(scene.xyz, hdr.xyz, LUT_STRENGTH);
  if (RENODX_TONE_MAP_TYPE != 0) color.xyz = ColourCorrect(hdr.xyz, color.xyz);

  return color;
}

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_4 : TEXCOORD4,
  linear float4 TEXCOORD_5 : TEXCOORD5,
  linear float4 TEXCOORD_3 : TEXCOORD3
) : SV_Target {
  // Silence unused interpolants kept for signature compatibility.
  (void)SV_Position;
  (void)TEXCOORD_5;
  (void)TEXCOORD_3;

  uint fullColorTexIndex = (uint)fullColor_tex_t;
  uint fullColorSamplerIndex = (uint)fullColor_tex;
  float4 fullColor = g_textures2D[fullColorTexIndex].Sample(
    g_samplers[fullColorSamplerIndex],
    TEXCOORD.xy
  );

  uint mipColorTexIndex = (uint)mipColor1_tex_t;
  uint mipColorSamplerIndex = (uint)mipColor1_tex;
  float4 mipColor = g_textures2D[mipColorTexIndex].Sample(
    g_samplers[mipColorSamplerIndex],
    TEXCOORD.zw
  );

  // Keep the original blend math exactly: lerp(mipColor.rgb, fullColor.rgb, mipColor.a).
  float3 blendedColor = (fullColor.rgb - mipColor.rgb) * mipColor.a + mipColor.rgb;
  float3 color = lerp(fullColor.rgb, blendedColor, CUSTOM_DOF);
  color = ApplyLut(color * TEXCOORD_4.y).xyz;

  color.xyz = renodx::color::srgb::DecodeSafe(color.xyz);
  color.xyz = ApplyColorGrade(color.xyz);
  color.xyz = DisplayMap(color.xyz);
  color.xyz = renodx::draw::RenderIntermediatePass(color.xyz);

  return float4(color, 1.0);
}


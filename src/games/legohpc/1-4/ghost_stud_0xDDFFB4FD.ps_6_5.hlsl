#include "../shared.h"
struct ShadowCascade {
  float4 eye2lightProjMtx[4];
  float4 MinRadiusSq;
  float4 MaxRadiusSq;
  float4 CascadeUVScale;
  float4 CascadeZScale;
  float4 CascadeZShift;
  float4 softShadowBlockerRadius;
  float4 softShadowSpreadRatio;
  float4 noiseScale;
};

struct ShadowCube {
  float4 viewMtx[4];
  float4 projParams;
  float4 params;
};

struct ShadowDualParaboloid {
  float4 viewMtx[4];
  float4 params;
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
  float4 softShadowBlockerRadius;
  float4 softShadowSpreadRatio;
  float4 noiseScale;
};

struct ShadowPointSpot {
  float4 eye2shadowMapUVMtx[4];
  float4 params;
};

struct LightData {
  float4 posDirRadius;
  float4 color;
  float4 params1;
};

struct ShadowCommon {
  float4 shadowFactors;
  float4 lightDirPos;
  float4 params;
};


Texture2D<float4> g_textures2D[] : register(t0, space2);

cbuffer $Globals : register(b0) {
  float4 world[4] : packoffset(c000.x);
  float4 vs_view[4] : packoffset(c004.x);
  float4 viewProj[4] : packoffset(c008.x);
  float4 worldViewProj[4] : packoffset(c012.x);
  float4 worldView[4] : packoffset(c016.x);
  float4 ps2ShineMtx[4] : packoffset(c020.x);
  float4 lightRotationMtx[4] : packoffset(c024.x);
  float4 worldParams[4][3] : packoffset(c028.x);
  float4 prevViewProj[4] : packoffset(c040.x);
  float4 prevView[4] : packoffset(c044.x);
  float4 prevWorld[4] : packoffset(c048.x);
  float4 vs_lightParams[7] : packoffset(c052.x);
  float4 vs_lightColor0 : packoffset(c059.x);
  float4 vs_lightColor1 : packoffset(c060.x);
  float4 vs_lightColor2 : packoffset(c061.x);
  float4 vs_lightPosition0 : packoffset(c062.x);
  float4 vs_lightPosition1 : packoffset(c063.x);
  float4 vs_lightPosition2 : packoffset(c064.x);
  float4 vs_lightColors[4] : packoffset(c065.x);
  float4 kTint : packoffset(c069.x);
  float4 vs_screenSize : packoffset(c070.x);
  float4 uvOffset01 : packoffset(c071.x);
  float4 fog_params : packoffset(c072.x);
  float4 vs_projection_params : packoffset(c073.x);
  float4 vs_frustum_params : packoffset(c074.x);
  float4 vs_lightingAdjust : packoffset(c075.x);
  float4 offsetTable[8] : packoffset(c076.x);
  float4 vertexGroupStates[32] : packoffset(c084.x);
  float4 worldCamPos : packoffset(c116.x);
  float4 lightmapOffset : packoffset(c117.x);
  float4 vs_viewportScaleBias : packoffset(c118.x);
  float4 blur_params : packoffset(c119.x);
  float4 vs_inverse_projection_xy : packoffset(c120.x);
  float4 vs_sceneAmbientColor : packoffset(c121.x);
  float4 vs_incandescentGlow : packoffset(c122.x);
  float4 vs_ambientColor : packoffset(c123.x);
  float2 vs_fastBlendWeights : packoffset(c124.x);
  float prevSkinMatrixOffset : packoffset(c124.z);
  float4 sceneAmbientColor : packoffset(c125.x);
  float4 lightColor0 : packoffset(c126.x);
  float4 lightColor1 : packoffset(c127.x);
  float4 lightColor2 : packoffset(c128.x);
  float4 lightPosition0 : packoffset(c129.x);
  float4 lightPosition1 : packoffset(c130.x);
  float4 lightPosition2 : packoffset(c131.x);
  float4 specular_params : packoffset(c132.x);
  float4 fs_lightColors[3] : packoffset(c133.x);
  float4 fs_lightParams[7] : packoffset(c136.x);
  float4 layer0_diffuse : packoffset(c143.x);
  float4 fs_screenSize : packoffset(c144.x);
  float4 time : packoffset(c145.x);
  float4 fog_color : packoffset(c146.x);
  float4 fs_projection_params : packoffset(c147.x);
  float4 fs_frustum_params : packoffset(c148.x);
  float4 fs_lightingAdjust : packoffset(c149.x);
  float4 specLightColor0 : packoffset(c150.x);
  float4 specLightColor1 : packoffset(c151.x);
  float4 specLightColor2 : packoffset(c152.x);
  float4 specLightPosition0 : packoffset(c153.x);
  float4 specLightPosition1 : packoffset(c154.x);
  float4 specLightPosition2 : packoffset(c155.x);
  float4 specLightData[6] : packoffset(c156.x);
  float4 exposure : packoffset(c162.x);
  float4 fs_viewportScaleBias : packoffset(c163.x);
  float4 fs_inverse_projection_xy : packoffset(c164.x);
  int layer0_sampler_t : packoffset(c165.x);
  int layer0_sampler : packoffset(c165.y);
  float2 renderResolution : packoffset(c165.z);
  float g_isImposter : packoffset(c166.x);
  int g_ShadowMapTex_t : packoffset(c166.y);
  int g_ShadowMapTex : packoffset(c166.z);
  int g_ShadowMapCubeTex_t : packoffset(c166.w);
  int g_ShadowMapCubeTex : packoffset(c167.x);
  int g_SM1Lights_SceneTex_t : packoffset(c167.y);
  int g_SM1Lights_SceneTex : packoffset(c167.z);
  int g_SM1Lights_LightingTex_t : packoffset(c167.w);
  int g_SM1Lights_LightingTex : packoffset(c168.x);
  ShadowCommon g_ShadowCommon : packoffset(c169.x);
  ShadowParallelOrtho g_Parallel : packoffset(c172.x);
  ShadowParallelLISPSM g_LISPSM : packoffset(c187.x);
  ShadowCascade g_Cascade : packoffset(c205.x);
  ShadowGrid g_Grid : packoffset(c217.x);
  ShadowPointSpot g_SpotPoint : packoffset(c222.x);
  ShadowDualParaboloid g_DualParaboloid : packoffset(c227.x);
  ShadowCube g_Cube : packoffset(c232.x);
  ShadowCommon g_ShadowCommon1 : packoffset(c238.x);
  ShadowParallelOrtho g_Parallel1 : packoffset(c241.x);
  ShadowParallelLISPSM g_LISPSM1 : packoffset(c256.x);
  ShadowCascade g_Cascade1 : packoffset(c274.x);
  ShadowGrid g_Grid1 : packoffset(c286.x);
  ShadowPointSpot g_SpotPoint1 : packoffset(c291.x);
  ShadowDualParaboloid g_DualParaboloid1 : packoffset(c296.x);
  ShadowCube g_Cube1 : packoffset(c301.x);
  LightData g_Light : packoffset(c307.x);
  float4 g_SpotViewProj[4] : packoffset(c310.x);
  float4 g_LightCommon : packoffset(c314.x);
  LightData g_Light1 : packoffset(c315.x);
  float4 g_SpotViewProj1[4] : packoffset(c318.x);
};

SamplerState g_samplers[] : register(s0, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float2 SV_Target_3 : SV_Target3;
  float4 SV_Target_4 : SV_Target4;
};

OutputSignature main(
  precise noperspective float4 SV_Position : SV_Position,
  float4 COLOR : COLOR,
  float4 TEXCOORD0_centroid : TEXCOORD0_centroid,
  linear float4 POSITION_2 : POSITION2
) {
  float4 SV_Target;
  float2 SV_Target_3;
  float4 SV_Target_4;
  uint _22;
  uint _24;
  float4 _26;
  float _36;
  float _37;
  float _38;
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _67;
  float _68;
  float _69;
  float _70;
  _22 = (uint)(layer0_sampler_t) + 0u;
  _24 = (uint)(layer0_sampler) + 0u;
  _26 = g_textures2D[_22].Sample(g_samplers[_24], float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
  _36 = _26.x * COLOR.x;
  _37 = _36 * layer0_diffuse.x;
  _38 = _26.y * COLOR.y;
  _39 = _38 * layer0_diffuse.y;
  _40 = _26.z * COLOR.z;
  _41 = _40 * layer0_diffuse.z;
  _42 = _26.w * TEXCOORD0_centroid.z;
  _43 = _42 * layer0_diffuse.w;
  _44 = _37 - fog_color.x;
  _45 = _39 - fog_color.y;
  _46 = _41 - fog_color.z;
  _47 = _44 * TEXCOORD0_centroid.w;
  _48 = _45 * TEXCOORD0_centroid.w;
  _49 = _46 * TEXCOORD0_centroid.w;
  _50 = _47 + fog_color.x;
  _51 = _48 + fog_color.y;
  _52 = _49 + fog_color.z;
  _55 = _50 * exposure.y;
  _56 = _51 * exposure.y;
  _57 = _52 * exposure.y;
  _58 = POSITION_2.x / POSITION_2.w;
  _59 = POSITION_2.y / POSITION_2.w;
  _60 = _58 * 0.5f;
  _61 = _59 * 0.5f;
  _62 = _60 + 0.5f;
  _63 = 0.5f - _61;
  _67 = renderResolution.x * _62;
  _68 = renderResolution.y * _63;
  _69 = _67 - SV_Position.x;
  _70 = _68 - SV_Position.y;
  SV_Target_3.x = _69;
  SV_Target_3.y = _70;
  SV_Target_4.x = 0.8999999761581421f;
  SV_Target_4.y = 0.8999999761581421f;
  SV_Target_4.z = 0.8999999761581421f;
  SV_Target_4.w = 0.8999999761581421f;
  SV_Target.x = _55;
  SV_Target.y = _56;
  SV_Target.z = _57;
  SV_Target.w = _43;
  SV_Target.xyz *= STUD_STRENGTH;
  OutputSignature output_signature = { SV_Target, SV_Target_3, SV_Target_4 };
  return output_signature;
}
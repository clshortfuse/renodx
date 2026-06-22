#include "../shared.h"
Texture2D<float4> g_textures2D[] : register(t0, space1);

cbuffer $Globals : register(b0) {
  float4 halfPixelOffset : packoffset(c000.x);
  float4 dummy_variable : packoffset(c001.x);
  int texture0_t : packoffset(c002.x);
  int texture0 : packoffset(c002.y);
  int texture1_t : packoffset(c002.z);
  int texture1 : packoffset(c002.w);
  int texture2_t : packoffset(c003.x);
  int texture2 : packoffset(c003.y);
  int texture3_t : packoffset(c003.z);
  int texture3 : packoffset(c003.w);
  int texture4_t : packoffset(c004.x);
  int texture4 : packoffset(c004.y);
  int lightmap0_t : packoffset(c004.z);
  int lightmap0 : packoffset(c004.w);
  int lightmap1_t : packoffset(c005.x);
  int lightmap1 : packoffset(c005.y);
  int lightmap2_t : packoffset(c005.z);
  int lightmap2 : packoffset(c005.w);
  int sceneEnvmap_samplerCube_t : packoffset(c006.x);
  int sceneEnvmap_samplerCube : packoffset(c006.y);
  int perm_sampler_t : packoffset(c006.z);
  int perm_sampler : packoffset(c006.w);
  int permgrad_sampler_t : packoffset(c007.x);
  int permgrad_sampler : packoffset(c007.y);
  int texAnimMap_sampler_t : packoffset(c007.z);
  int texAnimMap_sampler : packoffset(c007.w);
  int texAnimCurves_sampler_t : packoffset(c008.x);
  int texAnimCurves_sampler : packoffset(c008.y);
  int layer0_sampler_t : packoffset(c008.z);
  int layer0_sampler : packoffset(c008.w);
  int layer1_sampler_t : packoffset(c009.x);
  int layer1_sampler : packoffset(c009.y);
  int layer2_sampler_t : packoffset(c009.z);
  int layer2_sampler : packoffset(c009.w);
  int layer3_sampler_t : packoffset(c010.x);
  int layer3_sampler : packoffset(c010.y);
  int specular_sampler_t : packoffset(c010.z);
  int specular_sampler : packoffset(c010.w);
  int specular2_sampler_t : packoffset(c011.x);
  int specular2_sampler : packoffset(c011.y);
  int surface_sampler_t : packoffset(c011.z);
  int surface_sampler : packoffset(c011.w);
  int surface2_sampler_t : packoffset(c012.x);
  int surface2_sampler : packoffset(c012.y);
  int ps2_shinemap_sampler_t : packoffset(c012.z);
  int ps2_shinemap_sampler : packoffset(c012.w);
  int vtfNormal_sampler_t : packoffset(c013.x);
  int vtfNormal_sampler : packoffset(c013.y);
  int backBuffer_sampler_t : packoffset(c013.z);
  int backBuffer_sampler : packoffset(c013.w);
  int diffenvmap_samplerCube_t : packoffset(c014.x);
  int diffenvmap_samplerCube : packoffset(c014.y);
  int envmap_samplerCube_t : packoffset(c014.z);
  int envmap_samplerCube : packoffset(c014.w);
};

cbuffer MaterialPS : register(b1) {
  float4 fs_layer0_diffuse : packoffset(c000.x);
  float4 fs_layer1_diffuse : packoffset(c001.x);
  float4 fs_layer2_diffuse : packoffset(c002.x);
  float4 fs_layer3_diffuse : packoffset(c003.x);
  float4 fs_specular_specular : packoffset(c004.x);
  float4 fs_specular2_specular : packoffset(c005.x);
  float4 fs_specular_params : packoffset(c006.x);
  float4 fs_surface_params : packoffset(c007.x);
  float4 fs_surface_params2 : packoffset(c008.x);
  float4 fs_incandescentGlow : packoffset(c009.x);
  float4 fs_rimLightColour : packoffset(c010.x);
  float4 fs_fresnel_params : packoffset(c011.x);
  float4 fs_ambientColor : packoffset(c012.x);
  float4 fs_envmap_params : packoffset(c013.x);
  float4 fs_diffenv_params : packoffset(c014.x);
  float4 fs_refraction_color : packoffset(c015.x);
  float4 fs_refraction_kIndex : packoffset(c016.x);
  float4 fs_lego_params : packoffset(c017.x);
  float4 fs_vtf_kNormal : packoffset(c018.x);
  float4 fs_carpaint_params : packoffset(c019.x);
  float4 fs_brdf_params : packoffset(c020.x);
  float4 fs_fractal_params : packoffset(c021.x);
  float4 fs_carpaint_tints0 : packoffset(c022.x);
  float4 fs_carpaint_tints1 : packoffset(c023.x);
  float4 fs_carpaint_tints2 : packoffset(c024.x);
  float4 fs_carpaint_tints3 : packoffset(c025.x);
  float4 fs_isImposter : packoffset(c026.x);
};

cbuffer MiscGroupPS : register(b3) {
  float4 fs_fog_color : packoffset(c000.x);
  float4 fs_lightingAdjust : packoffset(c001.x);
  float4 fs_envRotation0 : packoffset(c002.x);
  float4 fs_envRotation1 : packoffset(c003.x);
  float4 fs_envRotation2 : packoffset(c004.x);
  float4 fs_exposure : packoffset(c005.x);
  float4 fs_screenSize : packoffset(c006.x);
  float4 fs_time : packoffset(c007.x);
  float4 fs_misc_flags : packoffset(c008.x);
  float4 fs_fog_color2 : packoffset(c009.x);
};

SamplerState g_samplers[] : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float2 SV_Target_3 : SV_Target3;
  float2 SV_Target_4 : SV_Target4;
};

OutputSignature main(
  precise noperspective float4 SV_Position : SV_Position,
  float2 TEXCOORD0_centroid : TEXCOORD0_centroid,
  float COLOR0_centroid : COLOR0_centroid,
  linear float4 POSITION_2 : POSITION2
) {
  float4 SV_Target;
  float2 SV_Target_3;
  float2 SV_Target_4;
  uint _16;
  uint _18;
  float4 _20;
  float _30;
  float _31;
  float _32;
  float _33;
  float _34;
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
  float _53;
  float _54;
  float _55;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  bool _66;
  float _72;
  float _73;
  float _74;
  float _68;
  float _69;
  float _70;
  float _75;
  float _76;
  float _77;
  float _78;
  float _79;
  float _80;
  float _81;
  float _82;
  float _83;
  float _84;
  float _88;
  float _89;
  float _90;
  float _91;
  _16 = (uint)(layer0_sampler_t) + 0u;
  _18 = (uint)(layer0_sampler) + 0u;
  _20 = g_textures2D[_16].Sample(g_samplers[_18], float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
  _30 = fs_layer0_diffuse.x * _20.x;
  _31 = fs_layer0_diffuse.y * _20.y;
  _32 = fs_layer0_diffuse.z * _20.z;
  _33 = _20.w * COLOR0_centroid;
  _34 = _33 * fs_layer0_diffuse.w;
  _40 = _30 - fs_incandescentGlow.x;
  _41 = _31 - fs_incandescentGlow.y;
  _42 = _32 - fs_incandescentGlow.z;
  _43 = saturate(_40);
  _44 = saturate(_41);
  _45 = saturate(_42);
  _46 = dot(float3(_43, _44, _45), float3(1.0f, 1.0f, 1.0f));
  _47 = _30 * fs_incandescentGlow.w;
  _48 = _47 * _46;
  _49 = _31 * fs_incandescentGlow.w;
  _50 = _49 * _46;
  _51 = _32 * fs_incandescentGlow.w;
  _52 = _51 * _46;
  _53 = _48 + 1.0f;
  _54 = _50 + 1.0f;
  _55 = _52 + 1.0f;
  _58 = fs_exposure.y * _30;
  _59 = _58 * _53;
  _60 = fs_exposure.y * _31;
  _61 = _60 * _54;
  _62 = fs_exposure.y * _32;
  _63 = _62 * _55;
  _64 = max(_59, _61);
  _65 = max(_64, _63);
  _66 = (_65 > 1.0f);
  if (_66) {
    _68 = _59 / _65;
    _69 = _61 / _65;
    _70 = _63 / _65;
    _72 = _68;
    _73 = _69;
    _74 = _70;
  } else {
    _72 = _59;
    _73 = _61;
    _74 = _63;
  }
  _75 = saturate(_72);
  _76 = saturate(_73);
  _77 = saturate(_74);
  _78 = saturate(_34);
  _79 = POSITION_2.x / POSITION_2.w;
  _80 = POSITION_2.y / POSITION_2.w;
  _81 = _79 * 0.5f;
  _82 = _80 * 0.5f;
  _83 = _81 + 0.5f;
  _84 = 0.5f - _82;
  _88 = fs_screenSize.x * _83;
  _89 = fs_screenSize.y * _84;
  _90 = _88 - SV_Position.x;
  _91 = _89 - SV_Position.y;
  SV_Target_3.x = _90;
  SV_Target_3.y = _91;
  SV_Target_4.x = 0.8999999761581421f;
  SV_Target_4.y = 0.8999999761581421f;
  SV_Target.x = _75;
  SV_Target.y = _76;
  SV_Target.z = _77;
  SV_Target.w = _78;
  SV_Target.xyz *= STUD_STRENGTH;
  OutputSignature output_signature = { SV_Target, SV_Target_3, SV_Target_4 };
  return output_signature;
}
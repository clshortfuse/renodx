#include "./shared.h"

Texture2D<float4> t5_space1 : register(t5, space1);

cbuffer cb3 : register(b3) {
  int g_rage_dynamicsamplerindices_000 : packoffset(c000.x);
  int g_rage_dynamicsamplerindices_004 : packoffset(c000.y);
  int g_rage_dynamicsamplerindices_008 : packoffset(c000.z);
  int g_rage_dynamicsamplerindices_012 : packoffset(c000.w);
  int g_rage_dynamicsamplerindices_016 : packoffset(c001.x);
  int g_rage_dynamicsamplerindices_020 : packoffset(c001.y);
  int g_rage_dynamicsamplerindices_024 : packoffset(c001.z);
  int g_rage_dynamicsamplerindices_028 : packoffset(c001.w);
  int g_rage_dynamicsamplerindices_032 : packoffset(c002.x);
  int g_rage_dynamicsamplerindices_036 : packoffset(c002.y);
  int g_rage_dynamicsamplerindices_040 : packoffset(c002.z);
  int g_rage_dynamicsamplerindices_044 : packoffset(c002.w);
  int g_rage_dynamicsamplerindices_048 : packoffset(c003.x);
  int g_rage_dynamicsamplerindices_052 : packoffset(c003.y);
  int g_rage_dynamicsamplerindices_056 : packoffset(c003.z);
  int g_rage_dynamicsamplerindices_060 : packoffset(c003.w);
  int g_rage_dynamicsamplerindices_064 : packoffset(c004.x);
  int g_rage_dynamicsamplerindices_068 : packoffset(c004.y);
  int g_rage_dynamicsamplerindices_072 : packoffset(c004.z);
  int g_rage_dynamicsamplerindices_076 : packoffset(c004.w);
  int g_rage_dynamicsamplerindices_080 : packoffset(c005.x);
  int g_rage_dynamicsamplerindices_084 : packoffset(c005.y);
};

cbuffer cb5 : register(b5) {
  float4 misc_globals_000 : packoffset(c000.x);
  float misc_globals_016 : packoffset(c001.x);
  float misc_globals_020 : packoffset(c001.y);
  float misc_globals_024 : packoffset(c001.z);
  float misc_globals_028 : packoffset(c001.w);
  float4 misc_globals_032 : packoffset(c002.x);
  float4 misc_globals_048 : packoffset(c003.x);
  float4 misc_globals_064 : packoffset(c004.x);
  float4 misc_globals_080 : packoffset(c005.x);
  float4 misc_globals_096 : packoffset(c006.x);
  float4 misc_globals_112[4] : packoffset(c007.x);
  float4 misc_globals_176 : packoffset(c011.x);
  float4 misc_globals_192 : packoffset(c012.x);
  float4 misc_globals_208 : packoffset(c013.x);
  float4 misc_globals_224 : packoffset(c014.x);
  float4 misc_globals_240 : packoffset(c015.x);
  int4 misc_globals_256 : packoffset(c016.x);
  float4 misc_globals_272 : packoffset(c017.x);
  float4 misc_globals_288 : packoffset(c018.x);
  float misc_globals_304 : packoffset(c019.x);
  float misc_globals_308 : packoffset(c019.y);
  float4 misc_globals_320 : packoffset(c020.x);
  float4 misc_globals_336 : packoffset(c021.x);
  float misc_globals_352 : packoffset(c022.x);
  int misc_globals_356 : packoffset(c022.y);
  int misc_globals_360 : packoffset(c022.z);
  int2 misc_globals_368 : packoffset(c023.x);
  int2 misc_globals_376 : packoffset(c023.z);
  int misc_globals_384 : packoffset(c024.x);
  float misc_globals_388 : packoffset(c024.y);
  int misc_globals_392 : packoffset(c024.z);
  float misc_globals_396 : packoffset(c024.w);
  float2 misc_globals_400 : packoffset(c025.x);
  int misc_globals_408 : packoffset(c025.z);
};

cbuffer cb9_space1 : register(b9, space1) {
  float4 im_cbuffer_000 : packoffset(c000.x);
  float4 im_cbuffer_016 : packoffset(c001.x);
  float4 im_cbuffer_032 : packoffset(c002.x);
  float4 im_cbuffer_048 : packoffset(c003.x);
  float im_cbuffer_064 : packoffset(c004.x);
  float im_cbuffer_068 : packoffset(c004.y);
  float im_cbuffer_072 : packoffset(c004.z);
  float4 im_cbuffer_080 : packoffset(c005.x);
  float4 im_cbuffer_096 : packoffset(c006.x);
  float4 im_cbuffer_112 : packoffset(c007.x);
  float4 im_cbuffer_128 : packoffset(c008.x);
};

SamplerState s0_space2[] : register(s0, space2);

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    linear float3 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _14;
  float _17;
  float _25;
  float _26;
  _14 = t5_space1.Sample(s0_space2[((uint)(g_rage_dynamicsamplerindices_000) + 0u)], float2(TEXCOORD.x, TEXCOORD.y));
  _17 = select((_14.x < 0.003921568859368563f), 0.0f, 1.0f);
  _25 = _14.x * _14.x;
  _26 = _25 * _25;
  SV_Target.x = (((_26 * TEXCOORD_1.x) + (_17 * im_cbuffer_048.x)) * misc_globals_224.z);
  SV_Target.y = (((_26 * TEXCOORD_1.y) + (_17 * im_cbuffer_048.y)) * misc_globals_224.z);
  SV_Target.z = (((_26 * TEXCOORD_1.z) + (_17 * im_cbuffer_048.z)) * misc_globals_224.z);
  SV_Target.w = _17;
  SV_Target *= CUSTOM_CORONA;

  return SV_Target;
}

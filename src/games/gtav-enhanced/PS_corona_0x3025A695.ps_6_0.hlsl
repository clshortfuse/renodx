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
  float cb5_014z : packoffset(c014.z);
};

cbuffer cb9_space1 : register(b9, space1) {
  float cb9_space1_003x : packoffset(c003.x);
  float cb9_space1_003y : packoffset(c003.y);
  float cb9_space1_003z : packoffset(c003.z);
};

SamplerState s0_space2[] : register(s0, space2);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    linear float3 TEXCOORD_1: TEXCOORD1) : SV_Target {
  float4 SV_Target;
  float4 _14 = t5_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_000 + 0u)], float2(TEXCOORD.x, TEXCOORD.y));
  float _17 = select((_14.x < 0.003921568859368563f), 0.0f, 1.0f);
  float _25 = _14.x * _14.x;
  float _26 = _25 * _25;
  SV_Target.x = (((_26 * TEXCOORD_1.x) + (_17 * cb9_space1_003x)) * cb5_014z);
  SV_Target.y = (((_26 * TEXCOORD_1.y) + (_17 * cb9_space1_003y)) * cb5_014z);
  SV_Target.z = (((_26 * TEXCOORD_1.z) + (_17 * cb9_space1_003z)) * cb5_014z);
  SV_Target.w = _17;
  SV_Target *= CUSTOM_CORONA;
  return SV_Target;
}

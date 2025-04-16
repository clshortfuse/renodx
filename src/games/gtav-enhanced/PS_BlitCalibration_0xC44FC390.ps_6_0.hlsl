Texture2D<float4> t0 : register(t5, space1);

cbuffer cb0 : register(b3) {
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

cbuffer cb1 : register(b9, space1) {
  float cb1_002x : packoffset(c002.x);
};

SamplerState s0[] : register(s0, space2);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 COLOR : COLOR,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _11 = t0.Sample(s0[(g_rage_dynamicsamplerindices_000 + 0u)], float2(TEXCOORD.x, (1.0f - TEXCOORD.y)));
  // cb1_002x = Display Calibration, from 1.43 - 3.02
  float _27 = 1.0f / cb1_002x;
  SV_Target.x = exp2(log2(pow(_11.x, 2.200000047683716f)) * _27);
  SV_Target.y = exp2(log2(pow(_11.y, 2.200000047683716f)) * _27);
  SV_Target.z = exp2(log2(pow(_11.z, 2.200000047683716f)) * _27);
  SV_Target.w = float((bool)(bool)(_11.w > 0.0f));

  // Force default
  SV_Target.xyz = _11.rgb;
  return SV_Target;
}

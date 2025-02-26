
#include "./common.hlsl"

Texture2D<float4> HDR_TEX1 : register(t0, space2);

Texture2D<float4> HDR_TEX2 : register(t1, space2);

Texture2D<float4> HDR_TEX3 : register(t2, space2);

Texture2D<float4> HDR_TEX4 : register(t3, space2);

Texture3D<float4> HDR_TEX_TONEMAP_LUT : register(t7, space2);

cbuffer CB_COMMON_DYN : register(b1) {
  float CB_COMMON_DYN_029x : packoffset(c029.x);
  float CB_COMMON_DYN_029y : packoffset(c029.y);
};

cbuffer CB_PASS_HDR : register(b4) {
  float CB_PASS_HDR_000y : packoffset(c000.y);
  float CB_PASS_HDR_001x : packoffset(c001.x);
  float CB_PASS_HDR_004z : packoffset(c004.z);
  float CB_PASS_HDR_007y : packoffset(c007.y);
  float CB_PASS_HDR_007z : packoffset(c007.z);
  float CB_PASS_HDR_007w : packoffset(c007.w);
  float CB_PASS_HDR_008x : packoffset(c008.x);
  float CB_PASS_HDR_008z : packoffset(c008.z);
  float CB_PASS_HDR_008w : packoffset(c008.w);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    nointerpolation float TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _13 = HDR_TEX1.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float4 _21 = HDR_TEX2.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float4 _29 = HDR_TEX4.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _52 = (((((CB_PASS_HDR_007y) * ((_29.x) + -1.0f)) + 1.0f) * (min((_21.x), 64512.0f))) + (min((_13.x), 64512.0f))) * (CB_PASS_HDR_004z);
  float _53 = (((((CB_PASS_HDR_007y) * ((_29.y) + -1.0f)) + 1.0f) * (min((_21.y), 64512.0f))) + (min((_13.y), 64512.0f))) * (CB_PASS_HDR_004z);
  float _54 = (((((CB_PASS_HDR_007y) * ((_29.z) + -1.0f)) + 1.0f) * (min((_21.z), 64512.0f))) + (min((_13.z), 64512.0f))) * (CB_PASS_HDR_004z);
  float _82 = _52;
  float _83 = _53;
  float _84 = _54;
  float _167;
  if (!(((CB_PASS_HDR_000y) < 9.999999974752427e-07f))) {
    float _62 = (CB_PASS_HDR_001x) * (TEXCOORD_1);
    float _66 = sqrt((((TEXCOORD.w) * (TEXCOORD.w)) + ((TEXCOORD.z) * (TEXCOORD.z))));
    _82 = _52;
    _83 = _53;
    _84 = _54;
    if (((_66 > _62))) {
      float _70 = max(0.0f, (_66 - _62));
      float _73 = 1.0f / ((_70 * _70) + 1.0f);
      float _77 = ((CB_PASS_HDR_000y) * ((_73 * _73) + -1.0f)) + 1.0f;
      _82 = (_77 * _52);
      _83 = (_77 * _53);
      _84 = (_77 * _54);
    }
  }
  float3 untonemapped = float3(_82, _83, _84);
  float _92 = max(0.0f, ((exp2((-0.0f - ((CB_PASS_HDR_008w) * (CB_PASS_HDR_008z))))) * 0.18000000715255737f));
  float4 _118 = HDR_TEX_TONEMAP_LUT.Sample(PS_SAMPLERS[4], float3((((saturate(((CB_PASS_HDR_008w) + (((log2((_92 + _82))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f), (((saturate(((CB_PASS_HDR_008w) + (((log2((_92 + _83))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f), (((saturate(((CB_PASS_HDR_008w) + (((log2((_92 + _84))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f)));
  float _128 = ((frac(((sin((((TEXCOORD.y) * 543.3099975585938f) + (TEXCOORD.x)))) * 493013.0f))) * 2.0f) + -1.0f;

  float _131 = min((max((_128 * +0x7FF0000000000000), -1.0f)), 1.0f);
  float _138 = (_131 - ((sqrt((saturate((1.0f - (abs(_128))))))) * _131)) * 0.003921568859368563f;
  float _148 = (CB_COMMON_DYN_029x) - (CB_COMMON_DYN_029y);
  float _154 = (-0.0f - ((CB_COMMON_DYN_029y) * (CB_COMMON_DYN_029x))) / (_148 * ((((float4)(HDR_TEX3.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y))))).x) - ((CB_COMMON_DYN_029x) / _148)));
  _167 = 0.0f;
  if (((_154 < (CB_PASS_HDR_007z)))) {
    _167 = (1.0f - (saturate(((_154 - (CB_PASS_HDR_007w)) * (CB_PASS_HDR_008x)))));
  }

  
  SV_Target.x = (_138 + (_118.x));
  SV_Target.y = (_138 + (_118.y));
  SV_Target.z = (_138 + (_118.z));
  SV_Target.rgb = LutToneMap(untonemapped, SV_Target.rgb);

  SV_Target.w = _167;
  return SV_Target;
}

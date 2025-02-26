#include "./common.hlsl"

Texture2D<float4> HDR_TEX1 : register(t0, space2);

Texture2D<float4> HDR_TEX2 : register(t1, space2);

Texture2D<float4> HDR_TEX3 : register(t2, space2);

Texture3D<float4> HDR_TEX_TONEMAP_LUT : register(t7, space2);

cbuffer CB_COMMON_DYN : register(b1) {
  float CB_COMMON_DYN_029x : packoffset(c029.x);
  float CB_COMMON_DYN_029y : packoffset(c029.y);
};

cbuffer CB_PASS_HDR : register(b4) {
  float CB_PASS_HDR_000y : packoffset(c000.y);
  float CB_PASS_HDR_001x : packoffset(c001.x);
  float CB_PASS_HDR_004z : packoffset(c004.z);
  float CB_PASS_HDR_007z : packoffset(c007.z);
  float CB_PASS_HDR_007w : packoffset(c007.w);
  float CB_PASS_HDR_008x : packoffset(c008.x);
  float CB_PASS_HDR_008z : packoffset(c008.z);
  float CB_PASS_HDR_008w : packoffset(c008.w);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  nointerpolation float TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _12 = HDR_TEX1.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float4 _20 = HDR_TEX2.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _32 = (CB_PASS_HDR_004z) * ((min((_20.x), 64512.0f)) + (min((_12.x), 64512.0f)));
  float _33 = (CB_PASS_HDR_004z) * ((min((_20.y), 64512.0f)) + (min((_12.y), 64512.0f)));
  float _34 = (CB_PASS_HDR_004z) * ((min((_20.z), 64512.0f)) + (min((_12.z), 64512.0f)));
  float _62 = _32;
  float _63 = _33;
  float _64 = _34;
  float _147;
  if (!(((CB_PASS_HDR_000y) < 9.999999974752427e-07f))) {
    float _42 = (CB_PASS_HDR_001x) * (TEXCOORD_1);
    float _46 = sqrt((((TEXCOORD.w) * (TEXCOORD.w)) + ((TEXCOORD.z) * (TEXCOORD.z))));
    _62 = _32;
    _63 = _33;
    _64 = _34;
    if (((_46 > _42))) {
      float _50 = max(0.0f, (_46 - _42));
      float _53 = 1.0f / ((_50 * _50) + 1.0f);
      float _57 = ((CB_PASS_HDR_000y) * ((_53 * _53) + -1.0f)) + 1.0f;
      _62 = (_57 * _32);
      _63 = (_57 * _33);
      _64 = (_57 * _34);
    }
  }

  float3 untonemapped = float3(_62, _63, _64);

  float _72 = max(0.0f, ((exp2((-0.0f - ((CB_PASS_HDR_008w) * (CB_PASS_HDR_008z))))) * 0.18000000715255737f));
  float4 _98 = HDR_TEX_TONEMAP_LUT.Sample(PS_SAMPLERS[4], float3((((saturate(((CB_PASS_HDR_008w) + (((log2((_72 + _62))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f), (((saturate(((CB_PASS_HDR_008w) + (((log2((_72 + _63))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f), (((saturate(((CB_PASS_HDR_008w) + (((log2((_72 + _64))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f)));
  float _108 = ((frac(((sin((((TEXCOORD.y) * 543.3099975585938f) + (TEXCOORD.x)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _111 = min((max((_108 * +1.#INF), -1.0f)), 1.0f);
  float _118 = (_111 - ((sqrt((saturate((1.0f - (abs(_108))))))) * _111)) * 0.003921568859368563f;
  float _128 = (CB_COMMON_DYN_029x) - (CB_COMMON_DYN_029y);
  float _134 = (-0.0f - ((CB_COMMON_DYN_029y) * (CB_COMMON_DYN_029x))) / (_128 * ((((float4)(HDR_TEX3.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y))))).x) - ((CB_COMMON_DYN_029x) / _128)));
  _147 = 0.0f;
  if (((_134 < (CB_PASS_HDR_007z)))) {
    _147 = (1.0f - (saturate(((_134 - (CB_PASS_HDR_007w)) * (CB_PASS_HDR_008x)))));
  }


  SV_Target.x = (_118 + (_98.x));
  SV_Target.y = (_118 + (_98.y));
  SV_Target.z = (_118 + (_98.z));
  SV_Target.rgb = LutToneMap(untonemapped, SV_Target.rgb);
  SV_Target.w = _147;
  return SV_Target;
}

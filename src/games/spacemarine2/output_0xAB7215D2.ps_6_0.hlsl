Texture2D<float4> HDR_TEX1 : register(t0, space2);

Texture2D<float4> HDR_TEX2 : register(t1, space2);

Texture3D<float4> HDR_TEX_TONEMAP_LUT : register(t7, space2);

cbuffer CB_PASS_HDR : register(b4) {
  float CB_PASS_HDR_000y : packoffset(c000.y);
  float CB_PASS_HDR_001x : packoffset(c001.x);
  float CB_PASS_HDR_004z : packoffset(c004.z);
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
  float3 untonemapped;

  float4 _10 = HDR_TEX1.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  untonemapped = _10.rgb;

  float4 _18 = HDR_TEX2.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _30 = (CB_PASS_HDR_004z) * ((min((_18.x), 64512.0f)) + (min((_10.x), 64512.0f)));
  float _31 = (CB_PASS_HDR_004z) * ((min((_18.y), 64512.0f)) + (min((_10.y), 64512.0f)));
  float _32 = (CB_PASS_HDR_004z) * ((min((_18.z), 64512.0f)) + (min((_10.z), 64512.0f)));
  float _60 = _30;
  float _61 = _31;
  float _62 = _32;
  if (!(((CB_PASS_HDR_000y) < 9.999999974752427e-07f))) {
    float _40 = (CB_PASS_HDR_001x) * (TEXCOORD_1);
    float _44 = sqrt((((TEXCOORD.w) * (TEXCOORD.w)) + ((TEXCOORD.z) * (TEXCOORD.z))));
    _60 = _30;
    _61 = _31;
    _62 = _32;
    if (((_44 > _40))) {
      float _48 = max(0.0f, (_44 - _40));
      float _51 = 1.0f / ((_48 * _48) + 1.0f);
      float _55 = ((CB_PASS_HDR_000y) * ((_51 * _51) + -1.0f)) + 1.0f;
      _60 = (_55 * _30);
      _61 = (_55 * _31);
      _62 = (_55 * _32);
    }
  }
  float _70 = max(0.0f, ((exp2((-0.0f - ((CB_PASS_HDR_008w) * (CB_PASS_HDR_008z))))) * 0.18000000715255737f));
  float4 _96 = HDR_TEX_TONEMAP_LUT.Sample(PS_SAMPLERS[4], float3((((saturate(((CB_PASS_HDR_008w) + (((log2((_70 + _60))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f), (((saturate(((CB_PASS_HDR_008w) + (((log2((_70 + _61))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f), (((saturate(((CB_PASS_HDR_008w) + (((log2((_70 + _62))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f)));
  float _106 = ((frac(((sin((((TEXCOORD.y) * 543.3099975585938f) + (TEXCOORD.x)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _109 = min((max((_106 * +1.#INF), -1.0f)), 1.0f);
  float _116 = (_109 - ((sqrt((saturate((1.0f - (abs(_106))))))) * _109)) * 0.003921568859368563f;
  SV_Target.x = (_116 + (_96.x));
  SV_Target.y = (_116 + (_96.y));
  SV_Target.z = (_116 + (_96.z));
  SV_Target.w = 0.0f;
  SV_Target.rgb = float3(2, 2, 0);

  return SV_Target;
}

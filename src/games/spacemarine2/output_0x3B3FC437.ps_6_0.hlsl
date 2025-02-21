Texture2D<float4> HDR_TEX1 : register(t0, space2);

Texture2D<float4> HDR_TEX2 : register(t1, space2);

Texture2D<float4> HDR_TEX4 : register(t3, space2);

Texture3D<float4> HDR_TEX_TONEMAP_LUT : register(t7, space2);

cbuffer CB_PASS_HDR : register(b4) {
  float CB_PASS_HDR_000y : packoffset(c000.y);
  float CB_PASS_HDR_001x : packoffset(c001.x);
  float CB_PASS_HDR_004z : packoffset(c004.z);
  float CB_PASS_HDR_007y : packoffset(c007.y);
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
  float4 _11 = HDR_TEX1.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  untonemapped = _11.rgb;
  float4 _19 = HDR_TEX2.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float4 _27 = HDR_TEX4.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _50 = (((((CB_PASS_HDR_007y) * ((_27.x) + -1.0f)) + 1.0f) * (min((_19.x), 64512.0f))) + (min((_11.x), 64512.0f))) * (CB_PASS_HDR_004z);
  float _51 = (((((CB_PASS_HDR_007y) * ((_27.y) + -1.0f)) + 1.0f) * (min((_19.y), 64512.0f))) + (min((_11.y), 64512.0f))) * (CB_PASS_HDR_004z);
  float _52 = (((((CB_PASS_HDR_007y) * ((_27.z) + -1.0f)) + 1.0f) * (min((_19.z), 64512.0f))) + (min((_11.z), 64512.0f))) * (CB_PASS_HDR_004z);
  float _80 = _50;
  float _81 = _51;
  float _82 = _52;
  if (!(((CB_PASS_HDR_000y) < 9.999999974752427e-07f))) {
    float _60 = (CB_PASS_HDR_001x) * (TEXCOORD_1);
    float _64 = sqrt((((TEXCOORD.w) * (TEXCOORD.w)) + ((TEXCOORD.z) * (TEXCOORD.z))));
    _80 = _50;
    _81 = _51;
    _82 = _52;
    if (((_64 > _60))) {
      float _68 = max(0.0f, (_64 - _60));
      float _71 = 1.0f / ((_68 * _68) + 1.0f);
      float _75 = ((CB_PASS_HDR_000y) * ((_71 * _71) + -1.0f)) + 1.0f;
      _80 = (_75 * _50);
      _81 = (_75 * _51);
      _82 = (_75 * _52);
    }
  }
  float _90 = max(0.0f, ((exp2((-0.0f - ((CB_PASS_HDR_008w) * (CB_PASS_HDR_008z))))) * 0.18000000715255737f));
  float4 _116 = HDR_TEX_TONEMAP_LUT.Sample(PS_SAMPLERS[4], float3((((saturate(((CB_PASS_HDR_008w) + (((log2((_90 + _80))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f), (((saturate(((CB_PASS_HDR_008w) + (((log2((_90 + _81))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f), (((saturate(((CB_PASS_HDR_008w) + (((log2((_90 + _82))) + 2.473931074142456f) / (CB_PASS_HDR_008z))))) * 0.96875f) + 0.015625f)));
  float _126 = ((frac(((sin((((TEXCOORD.y) * 543.3099975585938f) + (TEXCOORD.x)))) * 493013.0f))) * 2.0f) + -1.0f;
  float _129 = min((max((_126 * +1.#INF), -1.0f)), 1.0f);
  float _136 = (_129 - ((sqrt((saturate((1.0f - (abs(_126))))))) * _129)) * 0.003921568859368563f;
  SV_Target.x = (_136 + (_116.x));
  SV_Target.y = (_136 + (_116.y));
  SV_Target.z = (_136 + (_116.z));
  SV_Target.w = 0.0f;

  SV_Target.rgb = float3(2, 2, 0);

  return SV_Target;
}

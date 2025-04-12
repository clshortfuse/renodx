Texture2D<float4> HDR_TEX1 : register(t0, space2);

Texture2D<float4> HDR_TEX2 : register(t1, space2);

cbuffer CB_PASS_HDR : register(b4) {
  float CB_PASS_HDR_006z : packoffset(c006.z);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _7 = HDR_TEX1.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float4 _13 = HDR_TEX2.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _18 = (_13.x) + (_7.x);
  float _19 = (_13.y) + (_7.y);
  float _20 = (_13.z) + (_7.z);
  float _21 = (_13.w) + (_7.w);
  float _24 = _18 * (CB_PASS_HDR_006z);
  float _25 = _19 * (CB_PASS_HDR_006z);
  float _26 = _20 * (CB_PASS_HDR_006z);
  float _27 = _21 * (CB_PASS_HDR_006z);
  SV_Target.x = _24;
  SV_Target.y = _25;
  SV_Target.z = _26;
  SV_Target.w = _27;
  return SV_Target;
}

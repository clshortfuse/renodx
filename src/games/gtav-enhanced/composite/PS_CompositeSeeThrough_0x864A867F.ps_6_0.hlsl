Texture2D<float4> t14_space1 : register(t14, space1);

Texture2D<float4> t17_space1 : register(t17, space1);

Texture2D<float4> t25_space1 : register(t25, space1);

cbuffer cb12_space1 : register(b12, space1) {
  float cb12_space1_015x : packoffset(c015.x);
  float cb12_space1_015y : packoffset(c015.y);
  float cb12_space1_048x : packoffset(c048.x);
  float cb12_space1_048y : packoffset(c048.y);
  float cb12_space1_048z : packoffset(c048.z);
  float cb12_space1_048w : packoffset(c048.w);
  float cb12_space1_049x : packoffset(c049.x);
  float cb12_space1_049y : packoffset(c049.y);
  float cb12_space1_049z : packoffset(c049.z);
  float cb12_space1_050x : packoffset(c050.x);
  float cb12_space1_050y : packoffset(c050.y);
  float cb12_space1_050z : packoffset(c050.z);
  float cb12_space1_051x : packoffset(c051.x);
  float cb12_space1_051y : packoffset(c051.y);
  float cb12_space1_051z : packoffset(c051.z);
  float cb12_space1_052x : packoffset(c052.x);
  float cb12_space1_052y : packoffset(c052.y);
  float cb12_space1_052z : packoffset(c052.z);
  float cb12_space1_069x : packoffset(c069.x);
  float cb12_space1_069y : packoffset(c069.y);
  float cb12_space1_072x : packoffset(c072.x);
  float cb12_space1_072y : packoffset(c072.y);
};

SamplerState s2_space1 : register(s2, space1);

SamplerState s8_space1 : register(s8, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _16 = TEXCOORD.x + -0.5f;
  float _17 = TEXCOORD.y + -0.5f;
  float _18 = (cb12_space1_072x / cb12_space1_072y) * _16;
  float _19 = dot(float2(_18, _17), float2(_18, _17));
  float _24 = (((sqrt(_19) * cb12_space1_069y) + cb12_space1_069x) * _19) + 1.0f;
  float _27 = (_24 * _16) + 0.5f;
  float _28 = (_24 * _17) + 0.5f;
  float4 _38 = t17_space1.Sample(s8_space1, float2(frac((_27 * 11.199999809265137f) + cb12_space1_015x), frac((_28 * 6.299999713897705f) + cb12_space1_015y)));
  float _40 = _38.y + -0.5f;
  float4 _47 = t25_space1.Sample(s2_space1, float2((_27 - cb12_space1_072x), (_28 - (cb12_space1_072y * 0.5f))));
  float4 _56 = t25_space1.Sample(s2_space1, float2(((cb12_space1_072x * 0.5f) + _27), (_28 - cb12_space1_072y)));
  float4 _65 = t25_space1.Sample(s2_space1, float2((_27 - (cb12_space1_072x * 0.5f)), (cb12_space1_072y + _28)));
  float4 _74 = t25_space1.Sample(s2_space1, float2((cb12_space1_072x + _27), ((cb12_space1_072y * 0.5f) + _28)));
  float4 _77 = t25_space1.Sample(s2_space1, float2(_27, _28));
  float _90 = ((((_56.x + _47.x) + _65.x) + _74.x) + (_77.x * 0.5f)) * 0.2222222238779068f;
  float _91 = ((((_56.z + _47.z) + _65.z) + _74.z) + (_77.z * 0.5f)) * 0.2222222238779068f;
  float4 _98 = t14_space1.Sample(s2_space1, float2((_27 - cb12_space1_072x), (_28 - (cb12_space1_072y * 0.5f))));
  float4 _106 = t14_space1.Sample(s2_space1, float2(((cb12_space1_072x * 0.5f) + _27), (_28 - cb12_space1_072y)));
  float4 _114 = t14_space1.Sample(s2_space1, float2((_27 - (cb12_space1_072x * 0.5f)), (cb12_space1_072y + _28)));
  float4 _122 = t14_space1.Sample(s2_space1, float2((cb12_space1_072x + _27), ((cb12_space1_072y * 0.5f) + _28)));
  float4 _124 = t14_space1.Sample(s2_space1, float2(_27, _28));
  float _139 = ((lerp(cb12_space1_048x, cb12_space1_048y, _91)) * _40) + _91;
  float _158 = 1.0f - (((((_106.y + _98.y) + _114.y) + _122.y) + (_124.y * 0.5f)) * 0.2222222238779068f);
  float _163 = (_158 - ((_158 * _40) * cb12_space1_048w)) * cb12_space1_048z;
  SV_Target.x = saturate((((_139 * (cb12_space1_050x - cb12_space1_049x)) + cb12_space1_049x) - _163) + ((lerp(cb12_space1_051x, cb12_space1_052x, _90)) * _90));
  SV_Target.y = saturate((((_139 * (cb12_space1_050y - cb12_space1_049y)) + cb12_space1_049y) - _163) + ((lerp(cb12_space1_051y, cb12_space1_052y, _90)) * _90));
  SV_Target.z = saturate((((_139 * (cb12_space1_050z - cb12_space1_049z)) + cb12_space1_049z) - _163) + ((lerp(cb12_space1_051z, cb12_space1_052z, _90)) * _90));
  SV_Target.w = 1.0f;
  return SV_Target;
}

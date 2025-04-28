Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

cbuffer cb0 : register(b0) {
  float cb0_009x : packoffset(c009.x);
  float cb0_009y : packoffset(c009.y);
  int cb0_012x : packoffset(c012.x);
  int cb0_012y : packoffset(c012.y);
  int cb0_012z : packoffset(c012.z);
  int cb0_012w : packoffset(c012.w);
  float cb0_013x : packoffset(c013.x);
  float cb0_014x : packoffset(c014.x);
  float cb0_014y : packoffset(c014.y);
  float cb0_014z : packoffset(c014.z);
  float cb0_014w : packoffset(c014.w);
  float cb0_015x : packoffset(c015.x);
  int cb0_018x : packoffset(c018.x);
};

SamplerState s0_space2 : register(s0, space2);

float4 main(
  linear float2 TEXCOORD0_centroid : TEXCOORD0_centroid,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) : SV_Target {
  float4 SV_Target;
  SV_Target.x = 0.0f;
  SV_Target.y = 0.0f;
  SV_Target.z = 0.0f;
  SV_Target.w = 0.0f;
  float _13 = cb0_009x * TEXCOORD0_centroid.x;
  float _14 = cb0_009y * TEXCOORD0_centroid.y;
  uint _15 = uint(_13);
  uint _16 = uint(_14);
  uint _19 = _16 + -1u;
  float4 _20 = t0.Load(int3(_15, _19, 0));
  uint _24 = _15 + -1u;
  float4 _25 = t0.Load(int3(_24, _16, 0));
  float4 _29 = t0.Load(int3(_15, _16, 0));
  uint _33 = _15 + 1u;
  float4 _34 = t0.Load(int3(_33, _16, 0));
  uint _38 = _16 + 1u;
  float4 _39 = t0.Load(int3(_15, _38, 0));
  float _43 = min(_29.y, _34.y);
  float _44 = min(_25.y, _43);
  float _45 = min(_20.y, _39.y);
  float _46 = min(_44, _45);
  float _47 = max(_29.y, _34.y);
  float _48 = max(_25.y, _47);
  float _49 = max(_20.y, _39.y);
  float _50 = max(_48, _49);
  int _51 = asint(_50);
  uint _52 = 2129690299u - _51;
  float _53 = asfloat(_52);
  float _54 = 1.0f - _50;
  float _55 = min(_46, _54);
  float _56 = _53 * _55;
  float _57 = saturate(_56);
  int _58 = asint(_57);
  int _59 = (uint)(_58) >> 1;
  uint _60 = _59 + 532432441u;
  float _61 = asfloat(_60);
  float _62 = asfloat(cb0_018x);
  float _63 = _61 * _62;
  float _64 = _63 * 4.0f;
  float _65 = _64 + 1.0f;
  int _66 = asint(_65);
  uint _67 = 2129764351u - _66;
  float _68 = asfloat(_67);
  float _69 = _68 * _65;
  float _70 = 2.0f - _69;
  float _71 = _70 * _68;
  float _72 = _25.x + _20.x;
  float _73 = _72 + _34.x;
  float _74 = _73 + _39.x;
  float _75 = _63 * _74;
  float _76 = _75 + _29.x;
  float _77 = _71 * _76;

  // float _78 = saturate(_77);
  float _78 = (_77);

  float _79 = _25.y + _20.y;
  float _80 = _79 + _34.y;
  float _81 = _80 + _39.y;
  float _82 = _63 * _81;
  float _83 = _82 + _29.y;
  float _84 = _71 * _83;

  // float _85 = saturate(_84);
  float _85 = (_84);

  float _86 = _25.z + _20.z;
  float _87 = _86 + _34.z;
  float _88 = _87 + _39.z;
  float _89 = _63 * _88;
  float _90 = _89 + _29.z;
  float _91 = _71 * _90;

  // float _92 = saturate(_91);
  float _92 = (_91);

  float _96 = cb0_014x * TEXCOORD0_centroid.x;
  float _97 = cb0_014y * TEXCOORD0_centroid.y;
  float _100 = _96 + cb0_014z;
  float _101 = _97 + cb0_014w;
  float4 _104 = t2.SampleLevel(s0_space2, float2(_100, _101), 0.0f);
  float _106 = _104.x + -0.5f;
  float _107 = _106 * cb0_015x;
  float _108 = _107 + 0.5f;
  float _109 = _108 * 2.0f;
  float _110 = _109 * _78;
  float _111 = _109 * _85;
  float _112 = _109 * _92;
  float _120 = float((uint)(int)(cb0_012z));
  float _121 = float((uint)(int)(cb0_012w));
  float _122 = _120 + SV_Position.x;
  float _123 = _121 + SV_Position.y;
  uint _124 = uint(_122);
  uint _125 = uint(_123);
  uint _126 = (int)(cb0_012x) + -1u;
  uint _127 = (int)(cb0_012y) + -1u;
  int _128 = _124 & _126;
  int _129 = _125 & _127;
  float4 _130 = t1.Load(int3(_128, _129, 0));
  float _134 = _130.x * 2.0f;
  float _135 = _130.y * 2.0f;
  float _136 = _130.z * 2.0f;
  float _137 = _134 + -1.0f;
  float _138 = _135 + -1.0f;
  float _139 = _136 + -1.0f;
  float _140 = _137 * cb0_013x;
  float _141 = _138 * cb0_013x;
  float _142 = _139 * cb0_013x;
  float _143 = _140 + _110;
  float _144 = _141 + _111;
  float _145 = _142 + _112;
  SV_Target.x = _143;
  SV_Target.y = _144;
  SV_Target.z = _145;
  SV_Target.w = 1.0f;
  return SV_Target;
}

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float cb0_000x : packoffset(c000.x);
  float cb0_000y : packoffset(c000.y);
  float cb0_001x : packoffset(c001.x);
  float cb0_001y : packoffset(c001.y);
  float cb0_001z : packoffset(c001.z);
  float cb0_001w : packoffset(c001.w);
  float cb0_002x : packoffset(c002.x);
  float cb0_002y : packoffset(c002.y);
  float cb0_002z : packoffset(c002.z);
  float cb0_003x : packoffset(c003.x);
  float cb0_003y : packoffset(c003.y);
  float cb0_003z : packoffset(c003.z);
  float cb0_003w : packoffset(c003.w);
};

SamplerState s0 : register(s0);

float4 main(
  noperspective float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _9 = cb0_003z * TEXCOORD.x;
  float _10 = cb0_003w * TEXCOORD.y;
  float _18 = min(cb0_002z, 1.0f) * 0.1428571492433548f;
  float _19 = _18 * (cb0_002x - _9);
  float _20 = _18 * (cb0_002y - _10);
  float _27 = cb0_002x - _9;
  float _28 = cb0_002y - _10;
  float _40 = saturate((sqrt((_27 * _27) + (_28 * _28)) - cb0_000x) / max(9.999999747378752e-06f, (1.0f - cb0_000y)));
  float _41 = cb0_003x * _9;
  float _42 = cb0_003y * _10;
  float4 _52 = t0.Sample(s0, float2(min(max(_41, cb0_001x), cb0_001z), min(max(_42, cb0_001y), cb0_001w)));
  float4 _66 = t0.Sample(s0, float2(min(max(((_40 * (cb0_003x * _19)) + _41), cb0_001x), cb0_001z), min(max(((_40 * (cb0_003y * _20)) + _42), cb0_001y), cb0_001w)));
  float4 _85 = t0.Sample(s0, float2(min(max(((_40 * (cb0_003x * (_19 * 2.0f))) + _41), cb0_001x), cb0_001z), min(max(((_40 * (cb0_003y * (_20 * 2.0f))) + _42), cb0_001y), cb0_001w)));
  float4 _104 = t0.Sample(s0, float2(min(max(((_40 * (cb0_003x * (_19 * 3.0f))) + _41), cb0_001x), cb0_001z), min(max(((_40 * (cb0_003y * (_20 * 3.0f))) + _42), cb0_001y), cb0_001w)));
  float4 _123 = t0.Sample(s0, float2(min(max(((_40 * (cb0_003x * (_19 * 4.0f))) + _41), cb0_001x), cb0_001z), min(max(((_40 * (cb0_003y * (_20 * 4.0f))) + _42), cb0_001y), cb0_001w)));
  float4 _142 = t0.Sample(s0, float2(min(max(((_40 * (cb0_003x * (_19 * 5.0f))) + _41), cb0_001x), cb0_001z), min(max(((_40 * (cb0_003y * (_20 * 5.0f))) + _42), cb0_001y), cb0_001w)));
  float4 _161 = t0.Sample(s0, float2(min(max(((_40 * (cb0_003x * (_19 * 6.0f))) + _41), cb0_001x), cb0_001z), min(max(((_40 * (cb0_003y * (_20 * 6.0f))) + _42), cb0_001y), cb0_001w)));
  SV_Target.x = (((((((_66.x + _52.x) + _85.x) + _104.x) + _123.x) + _142.x) + _161.x) * 0.1428571492433548f);
  SV_Target.y = (((((((_66.y + _52.y) + _85.y) + _104.y) + _123.y) + _142.y) + _161.y) * 0.1428571492433548f);
  SV_Target.z = (((((((_66.z + _52.z) + _85.z) + _104.z) + _123.z) + _142.z) + _161.z) * 0.1428571492433548f);
  SV_Target.w = 1.0f;
  return SV_Target;
}

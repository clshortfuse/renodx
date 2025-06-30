#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _8 = t1.Load(int3(0, 0, 0));
  float _25 = CustomPixelConsts_256.x * 11.199999809265137f;
  float _34 = CustomPixelConsts_256.x / (exp2(log2(max(min(max(_8.x, CustomPixelConsts_064.y), CustomPixelConsts_064.z), 9.999999747378752e-05f) / _25) * CustomPixelConsts_256.z) * _25);
  float4 _35 = t0.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _39 = _35.x * _34;
  float _40 = _35.y * _34;
  float _41 = _35.z * _34;

  float3 untonemapped = float3(_39, _40, _41);

  float _42;
  float _43;
  float _44;
  float _45;
  float _52;
  float _62;
  float _69;
  float _79;
  float _88;

  _42 = _39 * CustomPixelConsts_112.x;
  _43 = _40 * CustomPixelConsts_112.x;
  _44 = _41 * CustomPixelConsts_112.x;
  _45 = CustomPixelConsts_112.z * CustomPixelConsts_112.y;
  _52 = CustomPixelConsts_128.x * CustomPixelConsts_128.y;
  _62 = CustomPixelConsts_128.x * CustomPixelConsts_128.z;
  _69 = CustomPixelConsts_128.y / CustomPixelConsts_128.z;
  _79 = CustomPixelConsts_112.x * 11.199999809265137f;
  _88 = max(0.0f, (((((_79 + _45) * 11.199999809265137f) + _52) / (((_79 + CustomPixelConsts_112.y) * 11.199999809265137f) + _62)) - _69));
  SV_Target.x = ((max(0.0f, (((((_42 + _45) * _39) + _52) / (((_42 + CustomPixelConsts_112.y) * _39) + _62)) - _69)) * CustomPixelConsts_256.y) / _88);
  SV_Target.y = ((max(0.0f, (((((_43 + _45) * _40) + _52) / (((_43 + CustomPixelConsts_112.y) * _40) + _62)) - _69)) * CustomPixelConsts_256.y) / _88);
  SV_Target.z = ((max(0.0f, (((((_44 + _45) * _41) + _52) / (((_44 + CustomPixelConsts_112.y) * _41) + _62)) - _69)) * CustomPixelConsts_256.y) / _88);
  SV_Target.w = 1.0f;

  float3 tonemapped_bt709 = SV_Target.rgb;

  // get midgray

  _41 = 0.18;
  _44 = _41 * CustomPixelConsts_112.x;
  _45 = CustomPixelConsts_112.z * CustomPixelConsts_112.y;
  _52 = CustomPixelConsts_128.x * CustomPixelConsts_128.y;
  _62 = CustomPixelConsts_128.x * CustomPixelConsts_128.z;
  _69 = CustomPixelConsts_128.y / CustomPixelConsts_128.z;
  _79 = CustomPixelConsts_112.x * 11.199999809265137f;
  _88 = max(0.0f, (((((_79 + _45) * 11.199999809265137f) + _52) / (((_79 + CustomPixelConsts_112.y) * 11.199999809265137f) + _62)) - _69));
  float out_mid_gray = ((max(0.0f, (((((_44 + _45) * _41) + _52) / (((_44 + CustomPixelConsts_112.y) * _41) + _62)) - _69)) * CustomPixelConsts_256.y) / _88);

  SV_Target.rgb = CustomUpgradeToneMap(untonemapped, tonemapped_bt709, out_mid_gray);

  return SV_Target;
}

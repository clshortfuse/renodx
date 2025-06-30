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

  // Define variables at the start
  float _39, _40, _41, _42, _43, _44, _45, _52, _62, _69, _79, _88, _89, _90, _91;
  float _107, _116, _117, _118, _119, _120, _121, _122, _123, _130, _140, _147, _157, _166;

  // Set variable values
  _39 = _35.x * _34;
  _40 = _35.y * _34;
  _41 = _35.z * _34;

  float3 untonemapped_1 = float3(_39, _40, _41);

  _42 = _39 * CustomPixelConsts_112.x;
  _43 = _40 * CustomPixelConsts_112.x;
  _44 = _41 * CustomPixelConsts_112.x;
  _45 = CustomPixelConsts_112.z * CustomPixelConsts_112.y;
  _52 = CustomPixelConsts_128.x * CustomPixelConsts_128.y;
  _62 = CustomPixelConsts_128.x * CustomPixelConsts_128.z;
  _69 = CustomPixelConsts_128.y / CustomPixelConsts_128.z;
  _79 = CustomPixelConsts_112.x * 11.199999809265137f;
  _88 = max(0.0f, (((((_79 + _45) * 11.199999809265137f) + _52) / (((_79 + CustomPixelConsts_112.y) * 11.199999809265137f) + _62)) - _69));
  _89 = (max(0.0f, (((((_42 + _45) * _39) + _52) / (((_42 + CustomPixelConsts_112.y) * _39) + _62)) - _69)) * CustomPixelConsts_256.y) / _88;
  _90 = (max(0.0f, (((((_43 + _45) * _40) + _52) / (((_43 + CustomPixelConsts_112.y) * _40) + _62)) - _69)) * CustomPixelConsts_256.y) / _88;
  _91 = (max(0.0f, (((((_44 + _45) * _41) + _52) / (((_44 + CustomPixelConsts_112.y) * _41) + _62)) - _69)) * CustomPixelConsts_256.y) / _88;

  float3 tonemapped_bt709_1 = float3(_89, _90, _91);

  _107 = CustomPixelConsts_272.x * 11.199999809265137f;
  _116 = CustomPixelConsts_272.x / (exp2(log2(max(min(max(_8.x, CustomPixelConsts_144.y), CustomPixelConsts_144.z), 9.999999747378752e-05f) / _107) * CustomPixelConsts_272.z) * _107);
  _117 = _35.x * _116;
  _118 = _35.y * _116;
  _119 = _35.z * _116;

  float3 untonemapped_2 = float3(_117, _118, _119);

  _120 = _117 * CustomPixelConsts_176.x;
  _121 = _118 * CustomPixelConsts_176.x;
  _122 = _119 * CustomPixelConsts_176.x;
  _123 = CustomPixelConsts_176.z * CustomPixelConsts_176.y;
  _130 = CustomPixelConsts_192.x * CustomPixelConsts_192.y;
  _140 = CustomPixelConsts_192.x * CustomPixelConsts_192.z;
  _147 = CustomPixelConsts_192.y / CustomPixelConsts_192.z;
  _157 = CustomPixelConsts_176.x * 11.199999809265137f;
  _166 = max(0.0f, (((((_157 + _123) * 11.199999809265137f) + _130) / (((_157 + CustomPixelConsts_176.y) * 11.199999809265137f) + _140)) - _147));
  SV_Target.x = (max(0.0f, (((((_120 + _123) * _117) + _130) / (((_120 + CustomPixelConsts_176.y) * _117) + _140)) - _147)) * CustomPixelConsts_272.y) / _166;
  SV_Target.y = (max(0.0f, (((((_121 + _123) * _118) + _130) / (((_121 + CustomPixelConsts_176.y) * _118) + _140)) - _147)) * CustomPixelConsts_272.y) / _166;
  SV_Target.z = (max(0.0f, (((((_122 + _123) * _119) + _130) / (((_122 + CustomPixelConsts_176.y) * _119) + _140)) - _147)) * CustomPixelConsts_272.y) / _166;
  //SV_Target.z = ((CustomPixelConsts_208.x * (((max(0.0f, (((((_122 + _123) * _119) + _130) / (((_122 + CustomPixelConsts_176.y) * _119) + _140)) - _147)) * CustomPixelConsts_272.y) / _166) - _91)) + _91);
  SV_Target.w = 1.0f;

  float3 tonemapped_bt709_2 = SV_Target.rgb;
  float3 tonemapped_bt709 = lerp(tonemapped_bt709_1, tonemapped_bt709_2, CustomPixelConsts_208.x);

  // get midgray

  _39 = 0.18f;

  _42 = _39 * CustomPixelConsts_112.x;

  _45 = CustomPixelConsts_112.z * CustomPixelConsts_112.y;
  _52 = CustomPixelConsts_128.x * CustomPixelConsts_128.y;
  _62 = CustomPixelConsts_128.x * CustomPixelConsts_128.z;
  _69 = CustomPixelConsts_128.y / CustomPixelConsts_128.z;
  _79 = CustomPixelConsts_112.x * 11.199999809265137f;
  _88 = max(0.0f, (((((_79 + _45) * 11.199999809265137f) + _52) / (((_79 + CustomPixelConsts_112.y) * 11.199999809265137f) + _62)) - _69));
  _89 = (max(0.0f, (((((_42 + _45) * _39) + _52) / (((_42 + CustomPixelConsts_112.y) * _39) + _62)) - _69)) * CustomPixelConsts_256.y) / _88;

  float out_mid_gray_1 = _89;

  _117 = 0.18f;

  _120 = _117 * CustomPixelConsts_176.x;
  _123 = CustomPixelConsts_176.z * CustomPixelConsts_176.y;
  _130 = CustomPixelConsts_192.x * CustomPixelConsts_192.y;
  _140 = CustomPixelConsts_192.x * CustomPixelConsts_192.z;
  _147 = CustomPixelConsts_192.y / CustomPixelConsts_192.z;
  _157 = CustomPixelConsts_176.x * 11.199999809265137f;
  _166 = max(0.0f, (((((_157 + _123) * 11.199999809265137f) + _130) / (((_157 + CustomPixelConsts_176.y) * 11.199999809265137f) + _140)) - _147));
  float out_mid_gray_2 = (max(0.0f, (((((_120 + _123) * _117) + _130) / (((_120 + CustomPixelConsts_176.y) * _117) + _140)) - _147)) * CustomPixelConsts_272.y) / _166;

  float out_mid_gray = lerp(out_mid_gray_1, out_mid_gray_2, CustomPixelConsts_208.x);
  float3 untonemapped = lerp(untonemapped_1, untonemapped_2, CustomPixelConsts_208.x);

  SV_Target.rgb = CustomUpgradeToneMap(untonemapped, tonemapped_bt709, out_mid_gray);
  
  return SV_Target;
}

#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);
Texture3D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
cbuffer cb0 : register(b0) {
  float4 _PerCamera_000[4] : packoffset(c000.x);
  float4 _PerCamera_064[4] : packoffset(c004.x);
  float4 _PerCamera_128[4] : packoffset(c008.x);
  float4 _PerCamera_192[4] : packoffset(c012.x);
  float4 _PerCamera_256[4] : packoffset(c016.x);
  float4 _PerCamera_320[4] : packoffset(c020.x);
  float4 _PerCamera_384[4] : packoffset(c024.x);
  float4 _PerCamera_448[4] : packoffset(c028.x);
  float4 _PerCamera_512[4] : packoffset(c032.x);
  float4 _PerCamera_576[4] : packoffset(c036.x);
  float4 _PerCamera_640[4] : packoffset(c040.x);
  float4 _PerCamera_704[4] : packoffset(c044.x);
  float4 _PerCamera_768[4] : packoffset(c048.x);
  float4 _PerCamera_832[4] : packoffset(c052.x);
  float4 _PerCamera_896[4] : packoffset(c056.x);
  float4 _PerCamera_960[4] : packoffset(c060.x);
  float4 _PerCamera_1024[4] : packoffset(c064.x);
  float4 _PerCamera_1088[4] : packoffset(c068.x);
  float4 _PerCamera_1152[4] : packoffset(c072.x);
  float4 _PerCamera_1216 : packoffset(c076.x);
  float4 _PerCamera_1232 : packoffset(c077.x);
  float4 _PerCamera_1248 : packoffset(c078.x);
  float4 _PerCamera_1264 : packoffset(c079.x);
  float4 _PerCamera_1280 : packoffset(c080.x);
  float4 _PerCamera_1296 : packoffset(c081.x);
  int4 _PerCamera_1312 : packoffset(c082.x);
  float4 _PerCamera_1328 : packoffset(c083.x);
  float4 _PerCamera_1344 : packoffset(c084.x);
  float4 _PerCamera_1360 : packoffset(c085.x);
  float4 _PerCamera_1376 : packoffset(c086.x);
  float4 _PerCamera_1392 : packoffset(c087.x);
  float4 _PerCamera_1408 : packoffset(c088.x);
  float4 _PerCamera_1424[6] : packoffset(c089.x);
  float4 _PerCamera_1520 : packoffset(c095.x);
  float4 _PerCamera_1536 : packoffset(c096.x);
  float4 _PerCamera_1552 : packoffset(c097.x);
  float4 _PerCamera_1568 : packoffset(c098.x);
  float4 _PerCamera_1584 : packoffset(c099.x);
  float4 _PerCamera_1600 : packoffset(c100.x);
  int4 _PerCamera_1616 : packoffset(c101.x);
  float4 _PerCamera_1632 : packoffset(c102.x);
  int4 _PerCamera_1648 : packoffset(c103.x);
  float4 _PerCamera_1664 : packoffset(c104.x);
  float4 _PerCamera_1680 : packoffset(c105.x);
  float4 _PerCamera_1696 : packoffset(c106.x);
  float4 _PerCamera_1712 : packoffset(c107.x);
};
cbuffer cb1 : register(b1) {
  float4 _TonemappingCB_000 : packoffset(c000.x);
  float4 _TonemappingCB_016 : packoffset(c001.x);
  float4 _TonemappingCB_032 : packoffset(c002.x);
};
cbuffer cb2 : register(b2) {
  float4 _VignetteCB_000 : packoffset(c000.x);
  float4 _VignetteCB_016 : packoffset(c001.x);
};
SamplerState s0 : register(s0);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float SV_Target_1 : SV_Target1;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) {
  float4 SV_Target;
  float SV_Target_1;
  float _14 = _VignetteCB_016.z * _VignetteCB_016.y;
  float _25 = _VignetteCB_000.x * (1.4142135381698608f / sqrt((_14 * _14) + 1.0f)) * CUSTOM_VIGNETTE;
  float _26 = _25 * ((TEXCOORD.x * 2.0f) + -1.0f);
  float _29 = -0.0f - ((((TEXCOORD.y * 2.0f) + -1.0f) * _14) * _25);
  float _32 = 1.0f / (dot(float2(_26, _29), float2(_26, _29)) + 1.0f);
  float4 _34 = t0.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _41 = _PerCamera_1664.y * _34.x;
  float _42 = _PerCamera_1664.y * _34.y;
  float _43 = _PerCamera_1664.y * _34.z;
  if (!(_TonemappingCB_000.x > 0.0f)) {
    float _62 = exp2(log2(abs(_PerCamera_1664.x * _41)) * 0.45454999804496765f);
    float _63 = exp2(log2(abs(_PerCamera_1664.x * _42)) * 0.45454999804496765f);
    float _64 = exp2(log2(abs(_PerCamera_1664.x * _43)) * 0.45454999804496765f);
    SV_Target.x = _62;
    SV_Target.y = _63;
    SV_Target.z = _64;
    SV_Target.w = _34.w;
    SV_Target_1 = dot(float3(saturate(_62), saturate(_63), saturate(_64)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  } else {
    float4 _70 = t2.Load(int3(0, 0, 0));
    float4 _72 = t3.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f) * CUSTOM_BLOOM;
    float _81 = _70.x * (_32 * _32);
    float3 lutInput;
    if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
      lutInput = float3((saturate(((log2((_81 * ((_72.x * _PerCamera_1664.y) + _41)) + 0.002667719032615423f) + 2.473931074142456f) * 0.0714285746216774f) + 0.4340175986289978f)), (saturate(((log2((_81 * ((_72.y * _PerCamera_1664.y) + _42)) + 0.002667719032615423f) + 2.473931074142456f) * 0.0714285746216774f) + 0.4340175986289978f)), (saturate(((log2((_81 * ((_72.z * _PerCamera_1664.y) + _43)) + 0.002667719032615423f) + 2.473931074142456f) * 0.0714285746216774f) + 0.4340175986289978f)));
    } else {
      lutInput = lutShaper(float3(_81 * ((_72.x * _PerCamera_1664.y) + _41), _81 * ((_72.y * _PerCamera_1664.y) + _42), _81 * ((_72.z * _PerCamera_1664.y) + _43)));
    }
    float4 _111;
    if (CUSTOM_LUT_SAMPLE == 0.f) {
      _111 = t1.Sample(s0, lutInput * 0.96875f + 0.015625f);
    } else {
      _111.xyz = renodx::lut::SampleTetrahedral(t1, lutInput, 32u);
    }
    float _115 = _111.x * 1.0499999523162842f;
    float _116 = _111.y * 1.0499999523162842f;
    float _117 = _111.z * 1.0499999523162842f;
    float3 tonemapped = renodx::color::srgb::DecodeSafe(float3(_115, _116, _117));
    tonemapped = GradeAndDisplayMap(tonemapped);
    tonemapped = PostToneMapScale(tonemapped, true);
    _115 = tonemapped.x;
    _116 = tonemapped.y;
    _117 = tonemapped.z;
    SV_Target.x = _115;
    SV_Target.y = _116;
    SV_Target.z = _117;
    SV_Target.w = _34.w;
    SV_Target_1 = dot(float3(saturate(_115), saturate(_116), saturate(_117)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  }
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

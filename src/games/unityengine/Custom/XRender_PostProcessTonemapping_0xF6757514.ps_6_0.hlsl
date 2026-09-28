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
  float4 _10 = t0.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _17 = _PerCamera_1664.y * _10.x;
  float _18 = _PerCamera_1664.y * _10.y;
  float _19 = _PerCamera_1664.y * _10.z;
  if (!(_TonemappingCB_000.x > 0.0f)) {
    float _38 = exp2(log2(abs(_PerCamera_1664.x * _17)) * 0.45454999804496765f);
    float _39 = exp2(log2(abs(_PerCamera_1664.x * _18)) * 0.45454999804496765f);
    float _40 = exp2(log2(abs(_PerCamera_1664.x * _19)) * 0.45454999804496765f);
    SV_Target.x = _38;
    SV_Target.y = _39;
    SV_Target.z = _40;
    SV_Target.w = _10.w;
    SV_Target_1 = dot(float3(saturate(_38), saturate(_39), saturate(_40)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  } else {
    float4 _46 = t2.Load(int3(0, 0, 0));
    float4 _48 = t3.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f) * CUSTOM_BLOOM;
    float3 lutInput;
    if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
      lutInput = float3((saturate(((log2((((_48.x * _PerCamera_1664.y) + _17) * _46.x) + 0.002667719032615423f) + 2.473931074142456f) * 0.0714285746216774f) + 0.4340175986289978f)), (saturate(((log2((((_48.y * _PerCamera_1664.y) + _18) * _46.x) + 0.002667719032615423f) + 2.473931074142456f) * 0.0714285746216774f) + 0.4340175986289978f)), (saturate(((log2((((_48.z * _PerCamera_1664.y) + _19) * _46.x) + 0.002667719032615423f) + 2.473931074142456f) * 0.0714285746216774f) + 0.4340175986289978f)));
    } else {
      lutInput = lutShaper(float3(((_48.x * _PerCamera_1664.y) + _17) * _46.x, ((_48.y * _PerCamera_1664.y) + _18) * _46.x, ((_48.z * _PerCamera_1664.y) + _19) * _46.x));
    }
    float4 _86;
    if (CUSTOM_LUT_SAMPLE == 0.f) {
      _86 = t1.Sample(s0, lutInput * 0.96875f + 0.015625);
    } else {
      _86.xyz = renodx::lut::SampleTetrahedral(t1, lutInput, 32u);
    }
    float _90 = _86.x * 1.0499999523162842f;
    float _91 = _86.y * 1.0499999523162842f;
    float _92 = _86.z * 1.0499999523162842f;
    float3 tonemapped = renodx::color::srgb::DecodeSafe(float3(_90, _91, _92));
    tonemapped = GradeAndDisplayMap(tonemapped);
    tonemapped = PostToneMapScale(tonemapped, true);
    _90 = tonemapped.x;
    _91 = tonemapped.y;
    _92 = tonemapped.z;
    SV_Target.x = _90;
    SV_Target.y = _91;
    SV_Target.z = _92;
    SV_Target.w = _10.w;
    SV_Target_1 = dot(float3(saturate(_90), saturate(_91), saturate(_92)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  }
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

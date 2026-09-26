#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);
Texture3D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture3D<float4> t4 : register(t4);
Texture2D<float4> t5 : register(t5);
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
  float _ExposureCommonCB_000 : packoffset(c000.x);
  float _ExposureCommonCB_004 : packoffset(c000.y);
  float _ExposureCommonCB_008 : packoffset(c000.z);
  float _ExposureCommonCB_012 : packoffset(c000.w);
  float _ExposureCommonCB_016 : packoffset(c001.x);
  float _ExposureCommonCB_020 : packoffset(c001.y);
  float _ExposureCommonCB_024 : packoffset(c001.z);
  float _ExposureCommonCB_028 : packoffset(c001.w);
  float _ExposureCommonCB_032 : packoffset(c002.x);
  float _ExposureCommonCB_036 : packoffset(c002.y);
  float _ExposureCommonCB_040 : packoffset(c002.z);
  float _ExposureCommonCB_044 : packoffset(c002.w);
  float _ExposureCommonCB_048 : packoffset(c003.x);
  float _ExposureCommonCB_052 : packoffset(c003.y);
  float _ExposureCommonCB_056 : packoffset(c003.z);
  float _ExposureCommonCB_060 : packoffset(c003.w);
  float _ExposureCommonCB_064 : packoffset(c004.x);
  float _ExposureCommonCB_068 : packoffset(c004.y);
  float _ExposureCommonCB_072 : packoffset(c004.z);
  float _ExposureCommonCB_076 : packoffset(c004.w);
  float _ExposureCommonCB_080 : packoffset(c005.x);
  float _ExposureCommonCB_084 : packoffset(c005.y);
  float _ExposureCommonCB_088 : packoffset(c005.z);
  float _ExposureCommonCB_092 : packoffset(c005.w);
  int _ExposureCommonCB_096 : packoffset(c006.x);
  float _ExposureCommonCB_100 : packoffset(c006.y);
  float _ExposureCommonCB_104 : packoffset(c006.z);
  float _ExposureCommonCB_108 : packoffset(c006.w);
};
cbuffer cb3 : register(b3) {
  float _LocalExposureCommonCB_000 : packoffset(c000.x);
  float _LocalExposureCommonCB_004 : packoffset(c000.y);
  float _LocalExposureCommonCB_008 : packoffset(c000.z);
  float _LocalExposureCommonCB_012 : packoffset(c000.w);
  float _LocalExposureCommonCB_016 : packoffset(c001.x);
  float _LocalExposureCommonCB_020 : packoffset(c001.y);
  float2 _LocalExposureCommonCB_024 : packoffset(c001.z);
  float _LocalExposureCommonCB_032 : packoffset(c002.x);
  float _LocalExposureCommonCB_036 : packoffset(c002.y);
  float _LocalExposureCommonCB_040 : packoffset(c002.z);
  float _LocalExposureCommonCB_044 : packoffset(c002.w);
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
  float4 _14 = t0.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _21 = _PerCamera_1664.y * _14.x;
  float _22 = _PerCamera_1664.y * _14.y;
  float _23 = _PerCamera_1664.y * _14.z;
  float _111;
  if (!(_TonemappingCB_000.x > 0.0f)) {
    float _42 = exp2(log2(abs(_PerCamera_1664.x * _21)) * 0.45454999804496765f);
    float _43 = exp2(log2(abs(_PerCamera_1664.x * _22)) * 0.45454999804496765f);
    float _44 = exp2(log2(abs(_PerCamera_1664.x * _23)) * 0.45454999804496765f);
    SV_Target.x = _42;
    SV_Target.y = _43;
    SV_Target.z = _44;
    SV_Target.w = _14.w;
    SV_Target_1 = dot(float3(saturate(_42), saturate(_43), saturate(_44)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  } else {
    float4 _50 = t2.Load(int3(0, 0, 0));
    float _61 = log2(max(dot(float3((_PerCamera_1664.y * _14.x), (_PerCamera_1664.y * _14.y), (_PerCamera_1664.y * _14.z)), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f)), _ExposureCommonCB_048));
    float4 _80 = t4.SampleLevel(s0, float3((_LocalExposureCommonCB_024.x * TEXCOORD.x), (_LocalExposureCommonCB_024.y * TEXCOORD.y), ((((_ExposureCommonCB_040 * _61) + _ExposureCommonCB_044) * 0.96875f) + 0.015625f)), 0.0f);
    float4 _84 = t5.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
    float _87 = select((_80.y < 0.0010000000474974513f), _84.x, (_80.x / _80.y));
    float _90 = log2(_50.x);
    float _92 = (_87 + _90) + ((_84.x - _87) * _LocalExposureCommonCB_012);
    float _96 = _90 + _61;
    float _98 = _92 - log2((_50.w * 0.18000000715255737f) * _LocalExposureCommonCB_016);
    bool _99 = (_98 > 0.0f);
    do {
      if (_99) {
        _111 = max(0.0f, (_98 - _LocalExposureCommonCB_032));
      } else {
        _111 = min(0.0f, (_98 + _LocalExposureCommonCB_036));
      }
      float _118 = exp2((((_92 - _96) + ((_96 - _92) * _LocalExposureCommonCB_008)) - _111) + (_111 * select(_99, _LocalExposureCommonCB_000, _LocalExposureCommonCB_004)));
      float4 _122 = t3.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f) * CUSTOM_BLOOM;
      float3 lutInput;
      if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
        lutInput = float3(((saturate((log2((((_122.x * _PerCamera_1664.y) + (_118 * _21)) * _50.x) + 0.002667719032615423f) + 2.473931074142456f) * 0.0714285746216774f) + 0.4340175986289978f)), ((saturate((log2((((_122.y * _PerCamera_1664.y) + (_118 * _22)) * _50.x) + 0.002667719032615423f) + 2.473931074142456f) * 0.0714285746216774f) + 0.4340175986289978f)), ((saturate((log2((((_122.z * _PerCamera_1664.y) + (_118 * _23)) * _50.x) + 0.002667719032615423f) + 2.473931074142456f) * 0.0714285746216774f) + 0.4340175986289978f)));
      } else {
        lutInput = lutShaper(float3((((_122.x * _PerCamera_1664.y) + (_118 * _21)) * _50.x), (((_122.y * _PerCamera_1664.y) + (_118 * _22)) * _50.x), (((_122.z * _PerCamera_1664.y) + (_118 * _23)) * _50.x)));
      }
      float4 _159;
      if (CUSTOM_LUT_SAMPLE == 0.f) {
        _159 = t1.Sample(s0, lutInput * 0.96875f + 0.015625);
      } else {
        _159.xyz = renodx::lut::SampleTetrahedral(t1, lutInput, 32u);
      }
      float _163 = _159.x * 1.0499999523162842f;
      float _164 = _159.y * 1.0499999523162842f;
      float _165 = _159.z * 1.0499999523162842f;
      float3 tonemapped = renodx::color::srgb::DecodeSafe(float3(_163, _164, _165));
      tonemapped = GradeAndDisplayMap(tonemapped);
      tonemapped = PostToneMapScale(tonemapped, true);
      _163 = tonemapped.x;
      _164 = tonemapped.y;
      _165 = tonemapped.z;
      SV_Target.x = _163;
      SV_Target.y = _164;
      SV_Target.z = _165;
      SV_Target.w = _14.w;
      SV_Target_1 = dot(float3(saturate(_163), saturate(_164), saturate(_165)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    } while (false);
  }
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

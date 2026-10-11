#include "other.hlsli"

struct SCameraDistances {
  float SCameraDistances_000;
  float SCameraDistances_004;
  float SCameraDistances_008;
  float SCameraDistances_012;
};

struct SGlobalDebugValues {
  float SGlobalDebugValues_000;
  float SGlobalDebugValues_004;
  float SGlobalDebugValues_008;
  float SGlobalDebugValues_012;
};

struct SGlobalScalars {
  float SGlobalScalars_000;
  float SGlobalScalars_004;
  float SGlobalScalars_008;
};

struct SLCMFrustumPlanes {
  float4 SLCMFrustumPlanes_000[6];
};

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float4 Global_000 : packoffset(c000.x);
  float4 Global_016 : packoffset(c001.x);
  float4 Global_032 : packoffset(c002.x);
  float4 Global_048[29] : packoffset(c003.x);
  float4 Global_512[29] : packoffset(c032.x);
  float4 Global_976 : packoffset(c061.x);
  float4 Global_992 : packoffset(c062.x);
  float4 Global_1008 : packoffset(c063.x);
  float4 Global_1024[2] : packoffset(c064.x);
  SGlobalDebugValues Global_1056 : packoffset(c066.x);
  float3 Global_1072 : packoffset(c067.x);
  float Global_1084 : packoffset(c067.w);
  float3 Global_1088 : packoffset(c068.x);
  float Global_1100 : packoffset(c068.w);
  float3 Global_1104 : packoffset(c069.x);
  float Global_1116 : packoffset(c069.w);
  float3 Global_1120 : packoffset(c070.x);
  float Global_1132 : packoffset(c070.w);
  float3 Global_1136 : packoffset(c071.x);
  float Global_1148 : packoffset(c071.w);
  SGlobalScalars Global_1152 : packoffset(c072.x);
  float Global_1164 : packoffset(c072.w);
  float2 Global_1168 : packoffset(c073.x);
  float Global_1176 : packoffset(c073.z);
  float Global_1180 : packoffset(c073.w);
  float2 Global_1184 : packoffset(c074.x);
  float Global_1192 : packoffset(c074.z);
  float Global_1196 : packoffset(c074.w);
  float2 Global_1200 : packoffset(c075.x);
  float Global_1208 : packoffset(c075.z);
  float Global_1212 : packoffset(c075.w);
  float2 Global_1216 : packoffset(c076.x);
  float Global_1224 : packoffset(c076.z);
  float2 Global_1232 : packoffset(c077.x);
};

cbuffer cb1 : register(b1) {
  float cb1_092x : packoffset(c092.x);
  float cb1_092y : packoffset(c092.y);
  int cb1_845w : packoffset(c845.w);
};

cbuffer cb2 : register(b2) {
  float4 PostFxGeneric_000 : packoffset(c000.x);
  float4 PostFxGeneric_016 : packoffset(c001.x);
  float4 PostFxGeneric_032 : packoffset(c002.x);
  float4 PostFxGeneric_048 : packoffset(c003.x);
  float2 PostFxGeneric_064 : packoffset(c004.x);
  float PostFxGeneric_072 : packoffset(c004.z);
  float PostFxGeneric_076 : packoffset(c004.w);
  float PostFxGeneric_080 : packoffset(c005.x);
  float PostFxGeneric_084 : packoffset(c005.y);
  float PostFxGeneric_088 : packoffset(c005.z);
  float PostFxGeneric_092 : packoffset(c005.w);
  int PostFxGeneric_096 : packoffset(c006.x);
};

SamplerState s0 : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    linear float2 TEXCOORD0_centroid: TEXCOORD0_centroid,
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  int _17;
  float _101;
  float _102;
  float _103;
  float _135;
  float _136;
  float _137;
  float _138;
  float4 _21;
  float _42;
  float _43;
  float _50;
  float _55;
  float _59;
  float _62;
  float _63;
  float _64;
  float _65;
  int _80;
  float _85;
  float _86;
  bool _97;
  float _107;
  float _116;
  float _120;
  float _121;
  float _123;
  float _124;
  float _132;
  _17 = int(round(PostFxGeneric_080));
  if (_17 == 1) {
    _21 = t0.Sample(s0, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
#if 1  // custom code: run the effect in sRGB instead of PQ
    if (RENODX_TONE_MAP_TYPE != 0.f) {
      float3 color_linear_bt2020 = renodx::color::pq::DecodeSafe(_21.rgb, RENODX_DIFFUSE_WHITE_NITS);
      float3 color_linear_bt709 = renodx::color::bt709::from::BT2020(color_linear_bt2020);
      if (RENODX_SDR_EOTF_EMULATION != 0.f) {
        _21.rgb = renodx::color::gamma::EncodeSafe(color_linear_bt709, 2.2f);
      } else {
        _21.rgb = renodx::color::srgb::EncodeSafe(color_linear_bt709);
      }
    }
#endif
    _42 = TEXCOORD0_centroid.x + -0.5f;
    _43 = TEXCOORD0_centroid.y + -0.5f;
    _50 = saturate((sqrt((_43 * _43) + (_42 * _42)) - (1.0f - (saturate(((atan(PostFxGeneric_088 * sin((Global_1152.SGlobalScalars_000 * 3.140000104904175f) * PostFxGeneric_084)) + 1.5700000524520874f) * 0.3184713125228882f) * PostFxGeneric_092) * 0.5f))) * -2.0f);
    _55 = saturate((_50 * _50) * (3.0f - (_50 * 2.0f)));
    _59 = (((_55 * _55) + -1.0f) * 0.25f) + 1.0f;
    _62 = (_21.x * PostFxGeneric_000.x) * _59;
    _63 = (_21.y * PostFxGeneric_000.y) * _59;
    _64 = (_21.z * PostFxGeneric_000.z) * _59;
    _65 = dot(float3(_62, _63, _64), float3(0.3086000084877014f, 0.6093999743461609f, 0.0820000022649765f));
    _135 = (lerp(_62, _65, PostFxGeneric_076));
    _136 = (lerp(_63, _65, PostFxGeneric_076));
    _137 = (lerp(_64, _65, PostFxGeneric_076));
    _138 = PostFxGeneric_000.w;
  } else {
    if (_17 == 2) {
      _80 = int(round(PostFxGeneric_084));
      _85 = cb1_092x * TEXCOORD0_centroid.x;
      _86 = cb1_092y * TEXCOORD0_centroid.y;
      do {
        _101 = _86;
        _102 = PostFxGeneric_088;
        _103 = 0.0f;
        if (!(_80 == 1)) {
          if (_80 == 2) {
            _101 = _85;
            _102 = (cb1_092x - PostFxGeneric_088);
            _103 = cb1_092x;
          } else {
            if (_80 == 3) {
              _101 = _86;
              _102 = (cb1_092y - PostFxGeneric_088);
              _103 = cb1_092y;
            } else {
              _97 = (_80 == 4);
              _101 = select(_97, _85, 0.0f);
              _102 = select(_97, PostFxGeneric_088, 0.0f);
              _103 = 0.0f;
            }
          }
        }
        _107 = saturate((_101 - _102) / (_103 - _102));
        _116 = saturate((((_107 * _107) * 1.25f) * (3.0f - (_107 * 2.0f))) * PostFxGeneric_076);
        _120 = (_116 * _116) * (3.0f - (_116 * 2.0f));
        _121 = _120 * PostFxGeneric_000.x;
        _123 = _120 * PostFxGeneric_000.z;
        _124 = _120 * PostFxGeneric_000.w;
        if ((uint)((int)((uint)(cb1_845w) + (uint)(-1))) < (uint)2) {
          _132 = min(max((_121 + 0.20000000298023224f), 0.0f), 1.0f);
          _135 = _132;
          _136 = _132;
          _137 = (_123 * 0.25f);
          _138 = _124;
        } else {
          _135 = _121;
          _136 = (_120 * PostFxGeneric_000.y);
          _137 = _123;
          _138 = _124;
        }
      } while (false);
    } else {
      _135 = PostFxGeneric_000.x;
      _136 = PostFxGeneric_000.y;
      _137 = PostFxGeneric_000.z;
      _138 = PostFxGeneric_000.w;
    }
  }
  SV_Target.x = _135;
  SV_Target.y = _136;
  SV_Target.z = _137;
  SV_Target.w = _138;
#if 1  // custom code: restore game-brightness PQ output for the sampled-color mode
  if (RENODX_TONE_MAP_TYPE != 0.f && _17 == 1) {
    float3 color_linear_bt709;
    if (RENODX_SDR_EOTF_EMULATION != 0.f) {
      color_linear_bt709 = renodx::color::gamma::DecodeSafe(SV_Target.rgb, 2.2f);
    } else {
      color_linear_bt709 = renodx::color::srgb::DecodeSafe(SV_Target.rgb);
    }
    float3 color_linear_bt2020 = renodx::color::bt2020::from::BT709(color_linear_bt709);
    if (RENODX_TONE_MAP_TYPE == 2.f) {
      color_linear_bt2020 = saturate(color_linear_bt2020);
    } else {
      float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      color_linear_bt2020 = min(color_linear_bt2020, peak_ratio);
    }
    SV_Target.rgb = renodx::color::pq::EncodeSafe(color_linear_bt2020, RENODX_DIFFUSE_WHITE_NITS);
  }
#endif
  return SV_Target;
}

#include "other.hlsli"

struct SCameraDistances {
  float SCameraDistances_000;
  float SCameraDistances_004;
  float SCameraDistances_008;
  float SCameraDistances_012;
};

struct SLCMFrustumPlanes {
  float4 SLCMFrustumPlanes_000[6];
};

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

cbuffer cb0 : register(b0) {
  float cb0_092y : packoffset(c092.y);
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
  float cb0_836y : packoffset(c836.y);
  int cb0_847w : packoffset(c847.w);
};

cbuffer cb1 : register(b1) {
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

SamplerState s1 : register(s1);

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
  float4 _15;
  float4 _22;
  float _79;
  float _80;
  float _81;
  float _82;
  float _83;
  float _84;
  float _85;
  float _86;
  float _41;
  float _42;
  float4 _43;
  float _46;
  float4 _47;
  float4 _50;
  float4 _53;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float4 _64;
  float _67;
  float4 _68;
  float _71;
  float4 _72;
  float4 _75;
  float _99;
  float4 _100;
  float _109;
  float _110;
  _15 = t1.Sample(s0, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
#if 1  // custom code: composite the hacker effect in sRGB instead of PQ
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color_linear_bt2020 = renodx::color::pq::DecodeSafe(_15.rgb, RENODX_DIFFUSE_WHITE_NITS);
    float3 color_linear_bt709 = renodx::color::bt709::from::BT2020(color_linear_bt2020);
    if (RENODX_SDR_EOTF_EMULATION != 0.f) {
      _15.rgb = renodx::color::gamma::EncodeSafe(color_linear_bt709, 2.2f);
    } else {
      _15.rgb = renodx::color::srgb::EncodeSafe(color_linear_bt709);
    }
  }
#endif
  _22 = t0.Sample(s0, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y));
  [branch]
  if ((cb0_836y < 0.8999999761581421f) && (cb0_847w == 0)) {
    _41 = select(((int(cb0_092y * TEXCOORD0_centroid.y) & 1) != 0), cb0_092z, (-0.0f - cb0_092z)) + TEXCOORD0_centroid.x;
    _42 = cb0_092w + TEXCOORD0_centroid.y;
    _43 = t0.Sample(s0, float2(_41, _42));
    _46 = TEXCOORD0_centroid.y - cb0_092w;
    _47 = t0.Sample(s0, float2(_41, _46));
    _50 = t0.Sample(s0, float2(TEXCOORD0_centroid.x, _46));
    _53 = t0.Sample(s0, float2(TEXCOORD0_centroid.x, _42));
    _79 = _53.y;
    _80 = _53.z;
    _81 = _43.z;
    _82 = _43.y;
    _83 = _47.z;
    _84 = _47.y;
    _85 = _50.z;
    _86 = _50.y;
  } else {
    _59 = select((cb0_847w != 0), max(cb0_836y, 0.5f), 1.0f);
    _60 = _59 * cb0_092z;
    _61 = _59 * cb0_092w;
    _62 = _60 + TEXCOORD0_centroid.x;
    _63 = _61 + TEXCOORD0_centroid.y;
    _64 = t0.Sample(s0, float2(_62, _63));
    _67 = TEXCOORD0_centroid.y - _61;
    _68 = t0.Sample(s0, float2(_62, _67));
    _71 = TEXCOORD0_centroid.x - _60;
    _72 = t0.Sample(s0, float2(_71, _67));
    _75 = t0.Sample(s0, float2(_71, _63));
    _79 = _75.y;
    _80 = _75.z;
    _81 = _64.z;
    _82 = _64.y;
    _83 = _68.z;
    _84 = _68.y;
    _85 = _72.z;
    _86 = _72.y;
  }
  _99 = max(_22.y, max(_82, max(_84, max(_86, _79))));
  _100 = t2.Sample(s1, float2(max(_22.z, max(_81, max(_83, max(_85, _80)))), 0.5f));
  _109 = abs(ceil(_22.z) - ((((ceil(_83) + ceil(_81)) + ceil(_85)) + ceil(_80)) * 0.25f));
  _110 = _109 * _109;
  SV_Target.x = (((((PostFxGeneric_000.x * 5.0f) * _99) * _100.x) * _110) + _15.x);
  SV_Target.y = (((((PostFxGeneric_000.y * 5.0f) * _99) * _100.y) * _110) + _15.y);
  SV_Target.z = (((((PostFxGeneric_000.z * 5.0f) * _99) * _100.z) * _110) + _15.z);
  SV_Target.w = PostFxGeneric_000.w;
#if 1  // custom code: restore game-brightness PQ output
  if (RENODX_TONE_MAP_TYPE != 0.f) {
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

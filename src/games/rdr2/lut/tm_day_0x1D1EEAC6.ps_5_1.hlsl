#include "../common.hlsli"

struct anon_m {
  int4 _m0;
  float4 _m1;
  float4 _m2;
  float2 _m3;
  uint4 _m4;
  uint4 _m5;
  uint4 _m6;
  uint4 _m7;
  uint4 _m8;
  uint4 _m9;
  uint4 _m10;
  uint4 _m11;
  uint4 _m12;
  uint4 _m13;
  uint4 _m14;
  uint _m15;
};

cbuffer CB0_buf : register(b16, space0) {
  uint4 CB0_m[88] : packoffset(c0);
};

cbuffer CB1_buf : register(b20, space0) {
  uint4 CB1_m0 : packoffset(c0);
  uint2 CB1_m1 : packoffset(c1);
  float2 CB1_m2 : packoffset(c1.z);
  float4 CB1_m3 : packoffset(c2);
  float4 CB1_m4 : packoffset(c3);
};

ByteAddressBuffer T0 : register(t2, space0);
ByteAddressBuffer T1 : register(t3, space0);

SamplerState S0 : register(s0, space0);
SamplerState S1 : register(s1, space0);
SamplerState S2 : register(s2, space0);
SamplerState S3 : register(s8, space0);

Texture2DArray<float4> T2 : register(t25, space0);
Texture2D<float4> T3 : register(t44, space0);
Texture2D<float4> T4 : register(t77, space0);
Texture2D<float4> T5 : register(t78, space0);
Texture2D<float4> T6 : register(t81, space0);
Texture1D<float4> T7 : register(t89, space0);
Texture2D<float4> T8 : register(t90, space0);
Texture2D<float4> T9 : register(t94, space0);
Texture2D<float4> T10 : register(t95, space0);
Texture2D<float4> T11 : register(t100, space0);
Texture2D<float4> T12 : register(t101, space0);
Texture2D<float4> T13 : register(t106, space0);
Texture2D<float4> T14 : register(t107, space0);
Texture2D<float4> T15 : register(t109, space0);
Texture2D<float4> T16 : register(t110, space0);
Texture2D<float4> T17 : register(t111, space0);
Texture2D<float4> T18 : register(t113, space0);
Texture2D<float4> T19 : register(t114, space0);
Buffer<float4> T20 : register(t116, space0);
ByteAddressBuffer T21 : register(t118, space0);

static float4 gl_FragCoord;
static float4 TEXCOORD;
static float TEXCOORD1;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_POSITION;
  float4 TEXCOORD : TEXCOORD;
  float TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

float dp2_f32(float2 a, float2 b) {
  precise float _265 = a.x * b.x;
  return mad(a.y, b.y, _265);
}

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp3_f32(float3 a, float3 b) {
  precise float _240 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _240));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float2 _278 = float2(TEXCOORD.x, TEXCOORD.y);
  float4 _281 = T16.Sample(S0, _278);
  float _282 = _281.x;
  float _283 = _281.y;
  float2 _285 = float2(_282, _283);
  float _294 = asfloat(CB0_m[0u].w) + 1.0f;
  float _298 = asfloat(CB0_m[0u].z);
  float _299 = _298 / (_294 - T5.SampleLevel(S0, _285, 0.0f).x);
  float4 _303 = T8.Sample(S3, _285);
  float _311 = asfloat(T0.Load(16));
  float4 _327 = T19.SampleLevel(S0, float2(_282 * asfloat(CB0_m[82u].x), _283 * asfloat(CB0_m[82u].y)), 0.0f);
  float _330 = _327.z;
  float _500;
  float _501;
  float _502;
  float _503;
  if ((_330 >= 1.0f) && (_327.w < 2.0f)) {
    float4 _340 = T18.SampleLevel(S0, _285, 0.0f);
    float _345 = asfloat(CB0_m[20u].x);
    float2 _348 = float2(_340.x * _345, _340.y * _345);
    float _353 = asfloat(CB0_m[20u].z);
    float _354 = min(sqrt(dp2_f32(_348, _348)), _353);
    float _357 = min(_330, 2.0f);
    float _361 = min(_357 + 1.0f, 2.0f);
    int _362 = cvt_f32_i32(_361);
    float _369 = ((_327.x / _330) * _357) * asfloat(CB0_m[66u].x);
    float _370 = asfloat(CB0_m[66u].y) * (_357 * (_327.y / _330));
    float _372 = trunc(_361) - 0.5f;
    float _373 = _372 / _357;
    float _375;
    float _378;
    float _380;
    float _382;
    _375 = 0.0f;
    _378 = 0.0f;
    _380 = 0.0f;
    _382 = 0.0f;
    float _376;
    float _379;
    float _381;
    float _383;
    uint _385;
    uint _384 = 0u;
    for (;;) {
      int _388 = int(_384);
      if (_362 <= _388) {
        break;
      }
      float _392 = float(_388);
      float _395 = (_392 + 0.5f) / _372;
      float2 _398 = float2(mad(_369, _395, _282), mad(_395, _370, _283));
      float4 _400 = T18.SampleLevel(S0, _398, 0.0f);
      float2 _405 = float2(_345 * _400.x, _345 * _400.y);
      float _408 = min(_353, sqrt(dp2_f32(_405, _405)));
      float _414 = _298 / (_294 - T4.SampleLevel(S0, _398, 0.0f).x);
      float _419 = _414 - _299;
      float _424 = max(_392 - 0.5f, 0.0f);
      float _429 = clamp(mad(_354, _373, -_424), 0.0f, 1.0f);
      float _434 = (1.0f - clamp((1.0f - _408) * 8.0f, 0.0f, 1.0f)) * dp2_f32(float2(clamp(mad(_419, 1.0f, 0.5f), 0.0f, 1.0f), clamp(mad(_419, -1.0f, 0.5f), 0.0f, 1.0f)), float2(_429, clamp(mad(_373, _408, -_424), 0.0f, 1.0f)));
      float4 _438 = T9.SampleLevel(S1, _398, 0.0f);
      float2 _446 = float2(mad(-_369, _395, _282), mad(-_395, _370, _283));
      float4 _448 = T18.SampleLevel(S0, _446, 0.0f);
      float2 _453 = float2(_345 * _448.x, _345 * _448.y);
      float _456 = min(_353, sqrt(dp2_f32(_453, _453)));
      float _461 = _298 / (_294 - T4.SampleLevel(S0, _446, 0.0f).x);
      float _466 = _461 - _299;
      float _477 = (1.0f - clamp((1.0f - _456) * 8.0f, 0.0f, 1.0f)) * dp2_f32(float2(clamp(mad(_466, 1.0f, 0.5f), 0.0f, 1.0f), clamp(mad(_466, -1.0f, 0.5f), 0.0f, 1.0f)), float2(_429, clamp(mad(_373, _456, -_424), 0.0f, 1.0f)));
      float4 _479 = T9.SampleLevel(S1, _446, 0.0f);
      bool _483 = _414 > _461;
      bool _484 = _408 < _456;
      bool _485 = _483 && _484;
      float _486 = _485 ? _477 : _434;
      float _489 = (_485 || (_483 || _484)) ? _477 : _434;
      _383 = mad(_438.x, _486, mad(_479.x, _489, _382));
      _381 = mad(_438.y, _486, mad(_479.y, _489, _380));
      _379 = mad(_438.z, _486, mad(_479.z, _489, _378));
      _376 = _486 + (_489 + _375);
      _385 = _384 + 1u;
      _375 = _376;
      _378 = _379;
      _380 = _381;
      _382 = _383;
      _384 = _385;
      continue;
    }
    float _495 = float(_362 << int(1u));
    _500 = _378 / _495;
    _501 = _380 / _495;
    _502 = _382 / _495;
    _503 = _375 / _495;
  } else {
    _500 = 0.0f;
    _501 = 0.0f;
    _502 = 0.0f;
    _503 = 0.0f;
  }
  float _504 = 1.0f - _503;
  float4 _511 = T10.SampleLevel(S1, _285, 0.0f);
  float _516 = 1.0f - _511.w;
  float _517 = mad(mad(_504, _303.x * _311, _502), _516, _511.x);
  float _518 = mad(mad(_303.y * _311, _504, _501), _516, _511.y);
  float _519 = mad(mad(_504, _303.z * _311, _500), _516, _511.z);
  float4 _521 = T20.Load(0u);
  float _522 = _521.x;
  float _523 = _521.y;
  float _524 = _521.z;
  float4 _525 = T20.Load(1u);
  float _526 = _525.x;
  float _527 = _525.y;
  float _528 = _525.z;
  float _529 = _525.w;
  float4 _531 = T3.Load(int3(uint2(0u, 0u), 0u));
  float _532 = _531.x;
  bool _562;
  float _563;
  float _564;
  float _565;
  if (CB0_m[64u].x != 0u) {
    float4 _548 = T15.Sample(S3, _278);
    float _549 = _548.x;
    float _550 = _548.y;
    float _551 = _548.z;
    float _552 = _548.w;
    bool _554 = (_552 + 9.9999997473787516355514526367188e-05f) >= 1.0f;
    float _555 = 1.0f - _552;
    _562 = _554;
    _563 = _554 ? _551 : mad(_519, _555, _551);
    _564 = _554 ? _550 : mad(_518, _555, _550);
    _565 = _554 ? _549 : mad(_517, _555, _549);
  } else {
    _562 = false;
    _563 = _519;
    _564 = _518;
    _565 = _517;
  }
  float _569 = min(_532 * _565, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _570 = min(_532 * _564, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _571 = min(_532 * _563, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  bool _572 = !_562;
  float _734;
  float _735;
  float _736;
  float _737;
  if (_572) {
    float _652;
    if (CB0_m[73u].x != 0u) {
      float4 _585 = T6.Sample(S2, _285);
      float _600 = clamp(dp3_f32(float3(_532 * _585.x, _532 * _585.y, _532 * _585.z), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), asfloat(CB0_m[75u].z), asfloat(CB0_m[75u].w));
      float _625 = asfloat(CB0_m[69u].x);
      float _628 = asfloat(CB0_m[69u].y);
      float _629 = clamp(mad(_600, asfloat(CB0_m[75u].y), mad(log2(_600 + asfloat(CB0_m[75u].x)) * asfloat(CB0_m[73u].y), 0.693147182464599609375f, asfloat(CB0_m[73u].z)) - 10.0f) + asfloat(CB0_m[68u].w), _625, _628);
      _652 = exp2(mad(clamp(asfloat(CB0_m[73u].x), 0.0f, 1.0f), clamp(_625, mad(abs(_629) * asfloat(CB0_m[69u].z), float(int(((_629 < 0.0f) ? 4294967295u : 0u) + uint(_629 > 0.0f))), _629), _628) - TEXCOORD1, TEXCOORD1));
    } else {
      _652 = TEXCOORD.z;
    }
    float2 _668 = float2(TEXCOORD.x - asfloat(CB0_m[53u].x), TEXCOORD.y - asfloat(CB0_m[53u].y));
    float2 _682 = float2(dp2_f32(float2(asfloat(CB0_m[55u].x), asfloat(CB0_m[55u].y)), _668) * asfloat(CB0_m[53u].z), dp2_f32(float2(asfloat(CB0_m[55u].z), asfloat(CB0_m[55u].w)), _668) * asfloat(CB0_m[53u].w));
    float _692 = max((dp2_f32(_682, _682) - asfloat(CB0_m[56u].x)) * asfloat(CB0_m[56u].w), 0.0f);
    float _704 = (_692 < 1.0f) ? (1.0f - exp2(_692 * (-10.0f))) : ((((_692 - 1.0f) > 0.0f) ? exp2((_692 - 2.0f) * 10.0f) : 0.0f) + 0.9980499744415283203125f);
    float _718 = asfloat(CB0_m[54u].w);
    bool _728 = CB0_m[54u].w != 0u;
    _734 = _652;
    _735 = _728 ? mad(_704, mad(_718, _571 * asfloat(CB0_m[54u].z), -_571), _571) : _571;
    _736 = _728 ? mad(_704, mad(_718, _570 * asfloat(CB0_m[54u].y), -_570), _570) : _570;
    _737 = _728 ? mad(mad(_569 * asfloat(CB0_m[54u].x), _718, -_569), _704, _569) : _569;
  } else {
    _734 = TEXCOORD.z;
    _735 = _571;
    _736 = _570;
    _737 = _569;
  }
  float _747 = clamp(clamp(TEXCOORD.y * asfloat(CB0_m[60u].y), 0.0f, 1.0f) + asfloat(CB0_m[57u].w), 0.0f, 1.0f);
  float _762 = clamp(clamp(clamp(TEXCOORD.y - asfloat(CB0_m[59u].w), 0.0f, 1.0f) * asfloat(CB0_m[60u].x), 0.0f, 1.0f) - asfloat(CB0_m[58u].w), 0.0f, 1.0f);
  float _768 = asfloat(CB0_m[57u].x);
  float _769 = asfloat(CB0_m[57u].y);
  float _770 = asfloat(CB0_m[57u].z);
  float _776 = asfloat(CB0_m[59u].x);
  float _777 = asfloat(CB0_m[59u].y);
  float _778 = asfloat(CB0_m[59u].z);
  float _782 = mad(_747, _776 - _768, _768);
  float _783 = mad(_747, _777 - _769, _769);
  float _784 = mad(_747, _778 - _770, _770);
  float _805 = mad(TEXCOORD.y, mad(_762, asfloat(CB0_m[58u].x) - _776, _776) - _782, _782) * _737;
  float _806 = _736 * mad(TEXCOORD.y, mad(_762, asfloat(CB0_m[58u].y) - _777, _777) - _783, _783);
  float _807 = _735 * mad(TEXCOORD.y, mad(_762, asfloat(CB0_m[58u].z) - _778, _778) - _784, _784);
  float _815 = (CB1_m1.x != 0u) ? CB1_m3.z : _524;
  float _818 = _734 / CB1_m2.x;
  float _822 = max(_805 * _818, 0.0f);
  float _823 = max(_818 * _806, 0.0f);
  float _824 = max(_818 * _807, 0.0f);
  float _852 = max(_805 * _734, 0.0f);
  float _853 = max(_734 * _806, 0.0f);
  float _854 = max(_734 * _807, 0.0f);
  bool _881 = CB1_m0.w != 0u;

  float _882, _883, _884;
#if 0
  float3 untonemapped = float3(_852, _853, _854);
  float3 hdr_tonemap = untonemapped;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    _882 = _881 ? (CB1_m2.x * (((mad(_822, mad(_522, _822, _526), _527) / mad(_822, mad(_522, _822, _523), _528)) - _529) * _815)) : clamp(_524 * ((mad(_852, mad(_522, _852, _526), _527) / mad(_852, mad(_522, _852, _523), _528)) - _529), 0.0f, 1.0f);
    _883 = _881 ? (CB1_m2.x * (_815 * ((mad(mad(_522, _823, _526), _823, _527) / mad(mad(_522, _823, _523), _823, _528)) - _529))) : clamp(_524 * ((mad(mad(_522, _853, _526), _853, _527) / mad(mad(_522, _853, _523), _853, _528)) - _529), 0.0f, 1.0f);
    _884 = _881 ? (CB1_m2.x * (_815 * ((mad(mad(_522, _824, _526), _824, _527) / mad(mad(_522, _824, _523), _824, _528)) - _529))) : clamp(_524 * ((mad(mad(_522, _854, _526), _854, _527) / mad(mad(_522, _854, _523), _854, _528)) - _529), 0.0f, 1.0f);
  } else {
    _881 = false;  // use SDR tonemapper
    _882 = _881 ? (CB1_m2.x * (((mad(_822, mad(_522, _822, _526), _527) / mad(_822, mad(_522, _822, _523), _528)) - _529) * _815)) : _524 * ((mad(_852, mad(_522, _852, _526), _527) / mad(_852, mad(_522, _852, _523), _528)) - _529);
    _883 = _881 ? (CB1_m2.x * (_815 * ((mad(mad(_522, _823, _526), _823, _527) / mad(mad(_522, _823, _523), _823, _528)) - _529))) : _524 * ((mad(mad(_522, _853, _526), _853, _527) / mad(mad(_522, _853, _523), _853, _528)) - _529);
    _884 = _881 ? (CB1_m2.x * (_815 * ((mad(mad(_522, _824, _526), _824, _527) / mad(mad(_522, _824, _523), _824, _528)) - _529))) : _524 * ((mad(mad(_522, _854, _526), _854, _527) / mad(mad(_522, _854, _523), _854, _528)) - _529);

    float3 ch_tonemap = float3(_882, _883, _884);

    float3 mid_gray = _881 ? (CB1_m2.x * (_815 * ((mad(mad(_522, 0.18, _526), 0.18, _527) / mad(mad(_522, 0.18, _523), 0.18, _528)) - _529))) : _524 * ((mad(mad(_522, 0.18, _526), 0.18, _527) / mad(mad(_522, 0.18, _523), 0.18, _528)) - _529);
    float3 untonemapped_mid_gray_shifted = untonemapped * renodx::color::y::from::BT709(mid_gray) / 0.18f;

    if (RENODX_TONE_MAP_PER_CHANNEL) {
      hdr_tonemap = lerp(ch_tonemap, untonemapped_mid_gray_shifted, saturate(renodx::color::y::from::BT709(ch_tonemap)));
      hdr_tonemap = HueAndChrominanceOKLab(hdr_tonemap, ch_tonemap, untonemapped_mid_gray_shifted, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_BLOWOUT_RESTORATION);
    } else {
      float y_in = renodx::color::y::from::BT709(untonemapped);
      float y_out = _881 ? (CB1_m2.x * (_815 * ((mad(mad(_522, y_in, _526), y_in, _527) / mad(mad(_522, y_in, _523), y_in, _528)) - _529))) : _524 * ((mad(mad(_522, y_in, _526), y_in, _527) / mad(mad(_522, y_in, _523), y_in, _528)) - _529);
      float3 lum_tonemap = renodx::color::correct::Luminance(untonemapped, y_in, y_out, 1.f);

      // 0 - (midgray * 1.5): lum tonemap
      // (midgray * 1.5) - 1: ch tonemap
      //                  >1: untonemapped mid gray shifted
      lum_tonemap = lerp(lum_tonemap, ch_tonemap, saturate(renodx::color::y::from::BT709(lum_tonemap) / (mid_gray * 1.5f)));
      hdr_tonemap = lerp(lum_tonemap, untonemapped_mid_gray_shifted, saturate(renodx::color::y::from::BT709(lum_tonemap)));
      hdr_tonemap = HueAndChrominanceOKLab(hdr_tonemap, ch_tonemap, untonemapped_mid_gray_shifted, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_BLOWOUT_RESTORATION);
    }

    _882 = hdr_tonemap.r, _883 = hdr_tonemap.g, _884 = hdr_tonemap.b;
  }
#else
  ApplyToneMap(_881,
               float3(_852, _853, _854),
               float3(_822, _823, _824),
               _882, _883, _884,
               CB1_m2.x,
               _522, _523, _524,
               _526, _527, _528, _529,
               _815);

#endif
  float _957;
  float _958;
  float _959;
  if (_572) {
    float _954;
    float _955;
    float _956;
    if (CB0_m[50u].w != 0u) {
      float2 _907 = float2(TEXCOORD.x - asfloat(CB0_m[49u].x), TEXCOORD.y - asfloat(CB0_m[49u].y));
      float2 _921 = float2(dp2_f32(float2(asfloat(CB0_m[51u].x), asfloat(CB0_m[51u].y)), _907) * asfloat(CB0_m[49u].z), dp2_f32(float2(asfloat(CB0_m[51u].z), asfloat(CB0_m[51u].w)), _907) * asfloat(CB0_m[49u].w));
      float _939 = T7.Sample(S2, clamp((dp2_f32(_921, _921) - asfloat(CB0_m[52u].x)) * asfloat(CB0_m[52u].w), 0.0f, 1.0f)).w * asfloat(CB0_m[50u].w);
      _954 = mad(_939, asfloat(CB0_m[50u].z) - _884, _884);
      _955 = mad(_939, asfloat(CB0_m[50u].y) - _883, _883);
      _956 = mad(_939, asfloat(CB0_m[50u].x) - _882, _882);
    } else {
      _954 = _884;
      _955 = _883;
      _956 = _882;
    }
    _957 = _954;
    _958 = _955;
    _959 = _956;
  } else {
    _957 = _884;
    _958 = _883;
    _959 = _882;
  }
  bool _995 = _881 && (CB1_m0.z == 0u);
  // CB1_m4.x = 2.2f

  float _996, _997, _998;
#if 0
  _996 = _995 ? _959 : ((_959 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _959) : mad(exp2(log2(_959) * CB1_m4.x), CB1_m4.y, -CB1_m4.z));
  _997 = _995 ? _958 : ((_958 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _958) : mad(CB1_m4.y, exp2(CB1_m4.x * log2(_958)), -CB1_m4.z));
  _998 = _995 ? _957 : ((_957 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _957) : mad(CB1_m4.y, exp2(CB1_m4.x * log2(_957)), -CB1_m4.z));
#else
  EncodeForLUT(_995,
               _959, _958, _957,
               CB1_m3.w, CB1_m4.x, CB1_m4.y, CB1_m4.z,
               _996, _997, _998);
#endif

  float3 _999 = float3(_996, _997, _998);
  float _1004 = max(dp3_f32(float3(0.265399992465972900390625f, 0.67040002346038818359375f, 0.06419999897480010986328125f), _999), 0.0f);
  float _1010 = mad(((max(dp3_f32(float3(0.02480000071227550506591796875f, 0.1247999966144561767578125f, 0.85039997100830078125f), _999), 0.0f) + _1004) / max(dp3_f32(float3(0.514900028705596923828125f, 0.324400007724761962890625f, 0.1606999933719635009765625f), _999), 0.00999999977648258209228515625f)) + 1.0f, 1.33000004291534423828125f, -1.67999994754791259765625f) * _1004;
  float _1024 = asfloat(CB0_m[83u].w);
  float _1038 = clamp(mad(0.039999999105930328369140625f / (dp3_f32(float3(_517 * _532, _518 * _532, _519 * _532), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)) + 0.039999999105930328369140625f), asfloat(CB0_m[84u].x), asfloat(CB0_m[84u].y)), 0.0f, 1.0f);
  float _1042 = mad(_1038, clamp((_1010 * asfloat(CB0_m[83u].x)) * _1024, 0.0f, 1.0f) - _996, _996);
  float _1043 = mad(_1038, clamp(_1024 * (_1010 * asfloat(CB0_m[83u].y)), 0.0f, 1.0f) - _997, _997);
  float _1044 = mad(_1038, clamp(_1024 * (_1010 * asfloat(CB0_m[83u].z)), 0.0f, 1.0f) - _998, _998);
  float _1100;
  float _1101;
  float _1102;
  if (CB0_m[86u].w != 0u) {
    float _1054 = asfloat(CB0_m[87u].x);
    float _1055 = asfloat(CB0_m[87u].w);
    float _1070 = asfloat(CB0_m[86u].z);
    float4 _1089 = T17.Sample(S2, float2(((((TEXCOORD.x - 0.5f) * _1070) / mad(TEXCOORD.y, asfloat(CB0_m[87u].z) - _1055, _1055)) - asfloat(CB0_m[86u].x)) + 0.5f, (((_1070 * (TEXCOORD.y - 0.5f)) / mad(TEXCOORD.x, asfloat(CB0_m[87u].y) - _1054, _1054)) - asfloat(CB0_m[86u].y)) + 0.5f));
    float _1096 = asfloat(CB0_m[86u].w);
    _1100 = mad(_1089.x - _1042, _1096, _1042);
    _1101 = mad(_1096, _1089.y - _1043, _1043);
    _1102 = mad(_1096, _1089.z - _1044, _1044);
  } else {
    _1100 = _1042;
    _1101 = _1043;
    _1102 = _1044;
  }
  float _1290;
  float _1291;
  float _1292;
  if (_572) {  // use LUT
    float _1111 = max(max(max(_1101, _1102), _1100), 9.9999997473787516355514526367188e-05f);
    float _1122 = ((CB1_m1.y == 0u) && _995) ? 1.0f : (((CB1_m2.y < _1111) ? mad(_1111, CB1_m3.x, CB1_m3.y) : _1111) / _1111);

    float3 color_sdr, color_hdr;
    PrepareForLUT(_1100, _1101, _1102, color_sdr, color_hdr, _1122);

#if 1
    float _1123 = _1102 * _1122;
    float _1128 = floor(_1123 * 14.99989986419677734375f);
    float _1130 = mad(_1123, 15.0f, -_1128);
    float _1132 = (_1128 * 0.0625f) + ((_1100 * _1122) * 0.05859375f);
    float _1134 = mad(_1101 * _1122, 0.9375f, 0.03125f);
    float4 _1140 = T13.Sample(S2, float2(_1132 + 0.001953125f, _1134));
    float _1141 = _1140.x;
    float _1142 = _1140.y;
    float _1143 = _1140.z;
    float4 _1146 = T13.Sample(S2, float2(_1132 + 0.064453125f, _1134));
    float _1153 = mad(_1130, _1146.x - _1141, _1141);
    float _1154 = mad(_1130, _1146.y - _1142, _1142);
    float _1155 = mad(_1130, _1146.z - _1143, _1143);
#else
    float3 lut1 = renodx::lut::SampleTetrahedral(T13, float3(_1100, _1101, _1102), 16u);
    float _1153 = lut1.r, _1154 = lut1.g, _1155 = lut1.b;
#endif

    float _1284;
    float _1285;
    float _1286;
    if (int(T21.Load(0)) > 0) {
      float _1191 = clamp(asfloat(T21.Load4(32)).x + ((_299 < asfloat(T21.Load4(16)).z) ? clamp((_299 - asfloat(T21.Load4(16)).x) * asfloat(T21.Load4(16)).y, 0.0f, 1.0f) : (1.0f - clamp(asfloat(T21.Load4(16)).w * (_299 - asfloat(T21.Load4(16)).z), 0.0f, 1.0f))), 0.0f, 1.0f);
      float _1194 = floor(_1155 * 14.99989986419677734375f);
      float _1196 = mad(_1155, 15.0f, -_1194);
      float _1198 = (_1153 * 0.05859375f) + (_1194 * 0.0625f);
      float _1200 = mad(_1154, 0.9375f, 0.03125f);
      float4 _1205 = T11.Sample(S2, float2(_1198 + 0.001953125f, _1200));
      float _1206 = _1205.x;
      float _1207 = _1205.y;
      float _1208 = _1205.z;
      float4 _1211 = T11.Sample(S2, float2(_1198 + 0.064453125f, _1200));
      float _1224 = mad(_1191, mad(_1196, _1211.x - _1206, _1206) - _1153, _1153);
      float _1225 = mad(mad(_1211.y - _1207, _1196, _1207) - _1154, _1191, _1154);
      float _1226 = mad(mad(_1211.z - _1208, _1196, _1208) - _1155, _1191, _1155);
      float _1237 = clamp(asfloat(T21.Load2(48)).y + ((_299 < asfloat(T21.Load4(32)).w) ? clamp(asfloat(T21.Load4(32)).z * (_299 - asfloat(T21.Load4(32)).y), 0.0f, 1.0f) : (1.0f - clamp(asfloat(T21.Load2(48)).x * (_299 - asfloat(T21.Load4(32)).w), 0.0f, 1.0f))), 0.0f, 1.0f);
      float _1240 = floor(_1226 * 14.99989986419677734375f);
      float _1242 = mad(_1226, 15.0f, -_1240);
      float _1244 = (_1224 * 0.05859375f) + (_1240 * 0.0625f);
      float _1246 = mad(_1225, 0.9375f, 0.03125f);
      float4 _1251 = T12.Sample(S2, float2(_1244 + 0.001953125f, _1246));
      float _1252 = _1251.x;
      float _1253 = _1251.y;
      float _1254 = _1251.z;
      float4 _1257 = T12.Sample(S2, float2(_1244 + 0.064453125f, _1246));
      float _1280 = dp3_f32(float3(T14.Sample(S2, _285).xyz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      _1284 = mad((mad(_1257.z - _1254, _1242, _1254) - _1226) * _1237, _1280, _1226);
      _1285 = mad((mad(_1257.y - _1253, _1242, _1253) - _1225) * _1237, _1280, _1225);
      _1286 = mad(_1237 * (mad(_1242, _1257.x - _1252, _1252) - _1224), _1280, _1224);
    } else {
      _1284 = _1155;
      _1285 = _1154;
      _1286 = _1153;
    }

    _1290 = _1284 / _1122;
    _1291 = _1285 / _1122;
    _1292 = _1286 / _1122;

    UpgradeLUTOutput(color_hdr, color_sdr, _1292, _1291, _1290);
  } else {
    _1290 = _1102;
    _1291 = _1101;
    _1292 = _1100;
  }

  float _1294 = dp3_f32(float3(_1292, _1291, _1290), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _1296 = max(max(_1290, _1291), _1292);
  bool _1299 = CB0_m[41u].w != 0u;
  float _1333 = asfloat(CB0_m[42u].w);
  float _1345 = asfloat(CB0_m[39u].x);
  float _1346 = asfloat(CB0_m[39u].y);
  float _1347 = asfloat(CB0_m[39u].z);
  float _1379 = mad(T2.Load(int4(uint3(uint2(cvt_f32_u32(gl_FragCoord.x) & 63u, cvt_f32_u32(gl_FragCoord.y) & 63u), T1.Load(1840) & 31u), 0u)).x, 2.0f, -1.0f);
  // _881 = false;
  float _1392 = _881 ? (float(int(((_1379 < 0.0f) ? 4294967295u : 0u) + uint(_1379 > 0.0f))) * (1.0f - sqrt(1.0f - abs(_1379)))) : _1379;
  float _1393 = mad(mad(exp2(log2(clamp(((_1299 ? _1292 : _1296) - asfloat(CB0_m[42u].x)) * asfloat(CB0_m[41u].x), 0.0f, 1.0f)) * _1333), asfloat(CB0_m[40u].x) - _1345, _1345), _1392, _1292);
  float _1394 = mad(mad(asfloat(CB0_m[40u].y) - _1346, exp2(log2(clamp(((_1299 ? _1291 : _1296) - asfloat(CB0_m[42u].y)) * asfloat(CB0_m[41u].y), 0.0f, 1.0f)) * _1333), _1346), _1392, _1291);
  float _1395 = mad(mad(asfloat(CB0_m[40u].z) - _1347, exp2(log2(clamp(((_1299 ? _1290 : _1296) - asfloat(CB0_m[42u].z)) * asfloat(CB0_m[41u].z), 0.0f, 1.0f)) * _1333), _1347), _1392, _1290);
  SV_Target.x = _881 ? _1393 : (_1393);
  SV_Target.y = _881 ? _1394 : (_1394);
  SV_Target.z = _881 ? _1395 : (_1395);
  SV_Target.w = _881 ? _1294 : clamp(_1294, 0.0f, 1.0f);

  SV_Target.rgb = FinalizeTonemap(SV_Target.rgb);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  TEXCOORD1 = stage_input.TEXCOORD1;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}

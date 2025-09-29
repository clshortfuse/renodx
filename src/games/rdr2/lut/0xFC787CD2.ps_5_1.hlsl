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
ByteAddressBuffer T21 : register(t118, space0);
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
Texture2D<float4> T9 : register(t93, space0);
Texture2D<float4> T10 : register(t94, space0);
Texture2D<float4> T11 : register(t95, space0);
Texture2D<float4> T12 : register(t100, space0);
Texture2D<float4> T13 : register(t101, space0);
Texture2D<float4> T14 : register(t106, space0);
Texture2D<float4> T15 : register(t107, space0);
Texture2D<float4> T16 : register(t109, space0);
Texture2D<float4> T17 : register(t111, space0);
Texture2D<float4> T18 : register(t113, space0);
Texture2D<float4> T19 : register(t114, space0);
Buffer<float4> T20 : register(t116, space0);

static float4 gl_FragCoord;
static float4 TEXCOORD;
static float TEXCOORD1;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float4 TEXCOORD : TEXCOORD;
  float TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

float dp2_f32(float2 a, float2 b) {
  precise float _297 = a.x * b.x;
  return mad(a.y, b.y, _297);
}

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp3_f32(float3 a, float3 b) {
  precise float _272 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _272));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float2 _310 = float2(TEXCOORD.x, TEXCOORD.y);
  float _320 = asfloat(CB0_m[0u].w) + 1.0f;
  float _324 = asfloat(CB0_m[0u].z);
  float _325 = _324 / (_320 - T5.SampleLevel(S0, _310, 0.0f).x);
  float4 _329 = T8.Sample(S3, _310);
  float _337 = asfloat(T0.Load(16));
  float4 _353 = T19.SampleLevel(S0, float2(TEXCOORD.x * asfloat(CB0_m[82u].x), TEXCOORD.y * asfloat(CB0_m[82u].y)), 0.0f);
  float _356 = _353.z;
  float _526;
  float _527;
  float _528;
  float _529;
  if ((_356 >= 1.0f) && (_353.w < 2.0f)) {
    float4 _366 = T18.SampleLevel(S0, _310, 0.0f);
    float _371 = asfloat(CB0_m[20u].x);
    float2 _374 = float2(_366.x * _371, _366.y * _371);
    float _379 = asfloat(CB0_m[20u].z);
    float _380 = min(sqrt(dp2_f32(_374, _374)), _379);
    float _383 = min(_356, 2.0f);
    float _387 = min(_383 + 1.0f, 2.0f);
    int _388 = cvt_f32_i32(_387);
    float _395 = ((_353.x / _356) * _383) * asfloat(CB0_m[66u].x);
    float _396 = asfloat(CB0_m[66u].y) * (_383 * (_353.y / _356));
    float _398 = trunc(_387) - 0.5f;
    float _399 = _398 / _383;
    float _401;
    float _404;
    float _406;
    float _408;
    _401 = 0.0f;
    _404 = 0.0f;
    _406 = 0.0f;
    _408 = 0.0f;
    float _402;
    float _405;
    float _407;
    float _409;
    uint _411;
    uint _410 = 0u;
    for (;;) {
      int _414 = int(_410);
      if (_388 <= _414) {
        break;
      }
      float _418 = float(_414);
      float _421 = (_418 + 0.5f) / _398;
      float2 _424 = float2(mad(_395, _421, TEXCOORD.x), mad(_421, _396, TEXCOORD.y));
      float4 _426 = T18.SampleLevel(S0, _424, 0.0f);
      float2 _431 = float2(_371 * _426.x, _371 * _426.y);
      float _434 = min(_379, sqrt(dp2_f32(_431, _431)));
      float _440 = _324 / (_320 - T4.SampleLevel(S0, _424, 0.0f).x);
      float _445 = _440 - _325;
      float _450 = max(_418 - 0.5f, 0.0f);
      float _455 = clamp(mad(_380, _399, -_450), 0.0f, 1.0f);
      float _460 = (1.0f - clamp((1.0f - _434) * 8.0f, 0.0f, 1.0f)) * dp2_f32(float2(clamp(mad(_445, 1.0f, 0.5f), 0.0f, 1.0f), clamp(mad(_445, -1.0f, 0.5f), 0.0f, 1.0f)), float2(_455, clamp(mad(_399, _434, -_450), 0.0f, 1.0f)));
      float4 _464 = T10.SampleLevel(S1, _424, 0.0f);
      float2 _472 = float2(mad(-_395, _421, TEXCOORD.x), mad(-_421, _396, TEXCOORD.y));
      float4 _474 = T18.SampleLevel(S0, _472, 0.0f);
      float2 _479 = float2(_371 * _474.x, _371 * _474.y);
      float _482 = min(_379, sqrt(dp2_f32(_479, _479)));
      float _487 = _324 / (_320 - T4.SampleLevel(S0, _472, 0.0f).x);
      float _492 = _487 - _325;
      float _503 = (1.0f - clamp((1.0f - _482) * 8.0f, 0.0f, 1.0f)) * dp2_f32(float2(clamp(mad(_492, 1.0f, 0.5f), 0.0f, 1.0f), clamp(mad(_492, -1.0f, 0.5f), 0.0f, 1.0f)), float2(_455, clamp(mad(_399, _482, -_450), 0.0f, 1.0f)));
      float4 _505 = T10.SampleLevel(S1, _472, 0.0f);
      bool _509 = _440 > _487;
      bool _510 = _434 < _482;
      bool _511 = _509 && _510;
      float _512 = _511 ? _503 : _460;
      float _515 = (_511 || (_509 || _510)) ? _503 : _460;
      _409 = mad(_464.x, _512, mad(_505.x, _515, _408));
      _407 = mad(_464.y, _512, mad(_505.y, _515, _406));
      _405 = mad(_464.z, _512, mad(_505.z, _515, _404));
      _402 = (_515 + _401) + _512;
      _411 = _410 + 1u;
      _401 = _402;
      _404 = _405;
      _406 = _407;
      _408 = _409;
      _410 = _411;
      continue;
    }
    float _521 = float(_388 << int(1u));
    _526 = _404 / _521;
    _527 = _406 / _521;
    _528 = _408 / _521;
    _529 = _401 / _521;
  } else {
    _526 = 0.0f;
    _527 = 0.0f;
    _528 = 0.0f;
    _529 = 0.0f;
  }
  float _530 = 1.0f - _529;
  float4 _537 = T11.SampleLevel(S1, _310, 0.0f);
  float _542 = 1.0f - _537.w;
  float _543 = mad(mad(_530, _329.x * _337, _528), _542, _537.x);
  float _544 = mad(mad(_329.y * _337, _530, _527), _542, _537.y);
  float _545 = mad(mad(_530, _329.z * _337, _526), _542, _537.z);
  float4 _547 = T20.Load(0u);
  float _548 = _547.x;
  float _549 = _547.y;
  float _550 = _547.z;
  float4 _551 = T20.Load(1u);
  float _552 = _551.x;
  float _553 = _551.y;
  float _554 = _551.z;
  float _555 = _551.w;
  float4 _557 = T3.Load(int3(uint2(0u, 0u), 0u));
  float _558 = _557.x;
  float _563 = dp3_f32(float3(_543 * _558, _544 * _558, _545 * _558), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
  bool _588;
  float _589;
  float _590;
  float _591;
  if (CB0_m[64u].x != 0u) {
    float4 _574 = T16.Sample(S3, _310);
    float _575 = _574.x;
    float _576 = _574.y;
    float _577 = _574.z;
    float _578 = _574.w;
    bool _580 = (_578 + 9.9999997473787516355514526367188e-05f) >= 1.0f;
    float _581 = 1.0f - _578;
    _588 = _580;
    _589 = _580 ? _577 : mad(_545, _581, _577);
    _590 = _580 ? _576 : mad(_544, _581, _576);
    _591 = _580 ? _575 : mad(_543, _581, _575);
  } else {
    _588 = false;
    _589 = _545;
    _590 = _544;
    _591 = _543;
  }
  float _595 = min(_558 * _591, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _596 = min(_558 * _590, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _597 = min(_558 * _589, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  bool _598 = !_588;
  float _795;
  float _796;
  float _797;
  float _798;
  if (_598) {
    float _678;
    if (CB0_m[73u].x != 0u) {
      float4 _611 = T6.Sample(S2, _310);
      float _626 = clamp(dp3_f32(float3(_558 * _611.x, _558 * _611.y, _558 * _611.z), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), asfloat(CB0_m[75u].z), asfloat(CB0_m[75u].w));
      float _651 = asfloat(CB0_m[69u].x);
      float _654 = asfloat(CB0_m[69u].y);
      float _655 = clamp(mad(_626, asfloat(CB0_m[75u].y), mad(log2(_626 + asfloat(CB0_m[75u].x)) * asfloat(CB0_m[73u].y), 0.693147182464599609375f, asfloat(CB0_m[73u].z)) - 10.0f) + asfloat(CB0_m[68u].w), _651, _654);
      _678 = exp2(mad(clamp(asfloat(CB0_m[73u].x), 0.0f, 1.0f), clamp(_651, mad(abs(_655) * asfloat(CB0_m[69u].z), float(int(((_655 < 0.0f) ? 4294967295u : 0u) + uint(_655 > 0.0f))), _655), _654) - TEXCOORD1, TEXCOORD1));
    } else {
      _678 = TEXCOORD.z;
    }
    float _681 = asfloat(CB0_m[16u].w);
    float _704 = _563 * (T9.Sample(S2, float2(frac(mad(TEXCOORD.x * _681, 1.60000002384185791015625f, asfloat(CB0_m[16u].x))), frac(mad(TEXCOORD.y * _681, 0.89999997615814208984375f, asfloat(CB0_m[16u].y))))).w - 0.5f);
    float _707 = asfloat(CB0_m[16u].z);
    float _711 = max(_595 * 0.5f, mad(_704, _707, _595));
    float _712 = max(mad(_704, _707, _596), _596 * 0.5f);
    float _713 = max(mad(_704, _707, _597), _597 * 0.5f);
    float2 _729 = float2(TEXCOORD.x - asfloat(CB0_m[53u].x), TEXCOORD.y - asfloat(CB0_m[53u].y));
    float2 _743 = float2(dp2_f32(float2(asfloat(CB0_m[55u].x), asfloat(CB0_m[55u].y)), _729) * asfloat(CB0_m[53u].z), dp2_f32(float2(asfloat(CB0_m[55u].z), asfloat(CB0_m[55u].w)), _729) * asfloat(CB0_m[53u].w));
    float _753 = max((dp2_f32(_743, _743) - asfloat(CB0_m[56u].x)) * asfloat(CB0_m[56u].w) * CUSTOM_VIGNETTE, 0.0f);
    float _765 = (_753 < 1.0f) ? (1.0f - exp2(_753 * (-10.0f))) : ((((_753 - 1.0f) > 0.0f) ? exp2((_753 - 2.0f) * 10.0f) : 0.0f) + 0.9980499744415283203125f);
    float _779 = asfloat(CB0_m[54u].w);
    bool _789 = CB0_m[54u].w != 0u;
    _795 = _678;
    _796 = _789 ? mad(_765, mad(_779, asfloat(CB0_m[54u].z) * _713, -_713), _713) : _713;
    _797 = _789 ? mad(_765, mad(_779, asfloat(CB0_m[54u].y) * _712, -_712), _712) : _712;
    _798 = _789 ? mad(mad(_711 * asfloat(CB0_m[54u].x), _779, -_711), _765, _711) : _711;
  } else {
    _795 = TEXCOORD.z;
    _796 = _597;
    _797 = _596;
    _798 = _595;
  }
  float _808 = clamp(clamp(TEXCOORD.y * asfloat(CB0_m[60u].y), 0.0f, 1.0f) + asfloat(CB0_m[57u].w), 0.0f, 1.0f);
  float _823 = clamp(clamp(clamp(TEXCOORD.y - asfloat(CB0_m[59u].w), 0.0f, 1.0f) * asfloat(CB0_m[60u].x), 0.0f, 1.0f) - asfloat(CB0_m[58u].w), 0.0f, 1.0f);
  float _829 = asfloat(CB0_m[57u].x);
  float _830 = asfloat(CB0_m[57u].y);
  float _831 = asfloat(CB0_m[57u].z);
  float _837 = asfloat(CB0_m[59u].x);
  float _838 = asfloat(CB0_m[59u].y);
  float _839 = asfloat(CB0_m[59u].z);
  float _843 = mad(_808, _837 - _829, _829);
  float _844 = mad(_808, _838 - _830, _830);
  float _845 = mad(_808, _839 - _831, _831);
  float _866 = mad(TEXCOORD.y, mad(_823, asfloat(CB0_m[58u].x) - _837, _837) - _843, _843) * _798;
  float _867 = _797 * mad(TEXCOORD.y, mad(_823, asfloat(CB0_m[58u].y) - _838, _838) - _844, _844);
  float _868 = _796 * mad(TEXCOORD.y, mad(_823, asfloat(CB0_m[58u].z) - _839, _839) - _845, _845);
  float _876 = (CB1_m1.x != 0u) ? CB1_m3.z : _550;
  float _879 = _795 / CB1_m2.x;
  float _883 = max(_866 * _879, 0.0f);
  float _884 = max(_879 * _867, 0.0f);
  float _885 = max(_879 * _868, 0.0f);
  float _913 = max(_866 * _795, 0.0f);
  float _914 = max(_795 * _867, 0.0f);
  float _915 = max(_795 * _868, 0.0f);
  bool _942 = CB1_m0.w != 0u;
  float _943 = _942 ? ((((mad(_883, mad(_548, _883, _552), _553) / mad(_883, mad(_548, _883, _549), _554)) - _555) * _876) * CB1_m2.x) : clamp(_550 * ((mad(_913, mad(_548, _913, _552), _553) / mad(_913, mad(_548, _913, _549), _554)) - _555), 0.0f, 1.0f);
  float _944 = _942 ? (CB1_m2.x * (_876 * ((mad(mad(_548, _884, _552), _884, _553) / mad(mad(_548, _884, _549), _884, _554)) - _555))) : clamp(_550 * ((mad(mad(_548, _914, _552), _914, _553) / mad(mad(_548, _914, _549), _914, _554)) - _555), 0.0f, 1.0f);
  float _945 = _942 ? (CB1_m2.x * (_876 * ((mad(mad(_548, _885, _552), _885, _553) / mad(mad(_548, _885, _549), _885, _554)) - _555))) : clamp(_550 * ((mad(mad(_548, _915, _552), _915, _553) / mad(mad(_548, _915, _549), _915, _554)) - _555), 0.0f, 1.0f);
  float _1018;
  float _1019;
  float _1020;
  if (_598) {
    float _1015;
    float _1016;
    float _1017;
    if (CB0_m[50u].w != 0u) {
      float2 _968 = float2(TEXCOORD.x - asfloat(CB0_m[49u].x), TEXCOORD.y - asfloat(CB0_m[49u].y));
      float2 _982 = float2(dp2_f32(float2(asfloat(CB0_m[51u].x), asfloat(CB0_m[51u].y)), _968) * asfloat(CB0_m[49u].z), dp2_f32(float2(asfloat(CB0_m[51u].z), asfloat(CB0_m[51u].w)), _968) * asfloat(CB0_m[49u].w));
      float _1000 = T7.Sample(S2, clamp((dp2_f32(_982, _982) - asfloat(CB0_m[52u].x)) * asfloat(CB0_m[52u].w), 0.0f, 1.0f)).w * asfloat(CB0_m[50u].w);
      _1015 = mad(_1000, asfloat(CB0_m[50u].z) - _945, _945);
      _1016 = mad(_1000, asfloat(CB0_m[50u].y) - _944, _944);
      _1017 = mad(_1000, asfloat(CB0_m[50u].x) - _943, _943);
    } else {
      _1015 = _945;
      _1016 = _944;
      _1017 = _943;
    }
    _1018 = _1015;
    _1019 = _1016;
    _1020 = _1017;
  } else {
    _1018 = _945;
    _1019 = _944;
    _1020 = _943;
  }
  bool _1056 = _942 && (CB1_m0.z == 0u);
  float _1057 = _1056 ? _1020 : ((_1020 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _1020) : mad(exp2(log2(_1020) * CB1_m4.x), CB1_m4.y, -CB1_m4.z));
  float _1058 = _1056 ? _1019 : ((_1019 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _1019) : mad(exp2(log2(_1019) * CB1_m4.x), CB1_m4.y, -CB1_m4.z));
  float _1059 = _1056 ? _1018 : ((_1018 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _1018) : mad(exp2(log2(_1018) * CB1_m4.x), CB1_m4.y, -CB1_m4.z));
  float _1257;
  float _1258;
  float _1259;
  if (_598 && (CB0_m[19u].x != 0u)) {
    float _1068 = asfloat(CB0_m[17u].x);
    float _1069 = _1068 * 0.070000000298023223876953125f;
    float _1070 = _1068 * 0.10999999940395355224609375f;
    float _1071 = _1068 * 0.12999999523162841796875f;
    float _1072 = _1068 * 0.17000000178813934326171875f;
    float _1075 = asfloat(CB0_m[17u].w);
    float _1076 = TEXCOORD.x * _1075;
    float _1077 = TEXCOORD.y * _1075;
    float _1105 = _1068 * 0.189999997615814208984375f;
    float _1106 = _1068 * 0.23000000417232513427734375f;
    float _1107 = _1068 * 0.2899999916553497314453125f;
    float _1108 = _1068 * 0.310000002384185791015625f;
    float _1149 = clamp(mad(frac(sin(dp2_f32(float2(_1076 + _1108, _1108 + _1077), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f) + ((((frac(sin(dp2_f32(float2(_1076 + _1072, _1077 + _1072), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f) + ((frac(sin(dp2_f32(float2(_1076 + _1069, _1077 + _1069), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f) + frac(sin(dp2_f32(float2(_1076 + _1070, _1077 + _1070), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f)) + frac(sin(dp2_f32(float2(_1076 + _1071, _1077 + _1071), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f))) + frac(sin(dp2_f32(float2(_1076 + _1105, _1105 + _1077), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f)) + frac(sin(dp2_f32(float2(_1076 + _1106, _1106 + _1077), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f)) + frac(sin(dp2_f32(float2(_1076 + _1107, _1107 + _1077), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f)), 0.125f, asfloat(CB0_m[17u].z)), 0.0f, 1.0f);
    float _1151 = dp3_f32(float3(_1057, _1058, _1059), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _1159 = (CB0_m[18u].y != 0u) ? mad(_1149 * (_1151 * (_1151 * _1151)), -0.5f, _1149) : _1149;
    float _1163 = _1159 - 0.5f;
    float _1166 = asfloat(CB0_m[18u].x);
    bool _1176 = _1159 < 0.5f;
    float _1177 = _1159 + _1159;
    float _1178 = _1177 * _1057;
    float _1179 = _1177 * _1058;
    float _1180 = _1177 * _1059;
    float _1184 = mad(_1159, -2.0f, 1.0f);
    float _1194 = 1.0f - _1159;
    float _1198 = mad(_1159, 2.0f, -1.0f);
    float _1220 = _1194 + _1194;
    bool _1241 = CB0_m[19u].w != 0u;
    bool _1247 = CB0_m[19u].z != 0u;
    bool _1253 = CB0_m[18u].w != 0u;
    _1257 = _1253 ? (_1247 ? mad(_1166, (_1176 ? ((_1184 * (_1059 * _1059)) + _1180) : ((_1194 * (_1059 + _1059)) + (_1198 * sqrt(_1059)))) - _1059, _1059) : (_1241 ? mad(_1166, ((_1059 < 0.5f) ? _1180 : mad(-_1220, 1.0f - _1059, 1.0f)) - _1059, _1059) : clamp(max(mad(_1163, _1166, _1059), _1059 * 0.02500000037252902984619140625f), 0.0f, 1.0f))) : _1149;
    _1258 = _1253 ? (_1247 ? mad(_1166, (_1176 ? ((_1184 * (_1058 * _1058)) + _1179) : ((_1194 * (_1058 + _1058)) + (_1198 * sqrt(_1058)))) - _1058, _1058) : (_1241 ? mad(_1166, ((_1058 < 0.5f) ? _1179 : mad(-_1220, 1.0f - _1058, 1.0f)) - _1058, _1058) : clamp(max(mad(_1163, _1166, _1058), _1058 * 0.02500000037252902984619140625f), 0.0f, 1.0f))) : _1149;
    _1259 = _1253 ? (_1247 ? mad(_1166, (_1176 ? (_1178 + ((_1057 * _1057) * _1184)) : ((sqrt(_1057) * _1198) + ((_1057 + _1057) * _1194))) - _1057, _1057) : (_1241 ? mad(_1166, ((_1057 < 0.5f) ? _1178 : mad(-_1220, 1.0f - _1057, 1.0f)) - _1057, _1057) : clamp(max(mad(_1163, _1166, _1057), _1057 * 0.02500000037252902984619140625f), 0.0f, 1.0f))) : _1149;
  } else {
    _1257 = _1059;
    _1258 = _1058;
    _1259 = _1057;
  }
  float3 _1260 = float3(_1259, _1258, _1257);
  float _1265 = max(dp3_f32(float3(0.265399992465972900390625f, 0.67040002346038818359375f, 0.06419999897480010986328125f), _1260), 0.0f);
  float _1271 = mad(((max(dp3_f32(float3(0.02480000071227550506591796875f, 0.1247999966144561767578125f, 0.85039997100830078125f), _1260), 0.0f) + _1265) / max(dp3_f32(float3(0.514900028705596923828125f, 0.324400007724761962890625f, 0.1606999933719635009765625f), _1260), 0.00999999977648258209228515625f)) + 1.0f, 1.33000004291534423828125f, -1.67999994754791259765625f) * _1265;
  float _1285 = asfloat(CB0_m[83u].w);
  float _1299 = clamp(mad(0.039999999105930328369140625f / (_563 + 0.039999999105930328369140625f), asfloat(CB0_m[84u].x), asfloat(CB0_m[84u].y)), 0.0f, 1.0f);
  float _1303 = mad(_1299, clamp((_1271 * asfloat(CB0_m[83u].x)) * _1285, 0.0f, 1.0f) - _1259, _1259);
  float _1304 = mad(_1299, clamp(_1285 * (_1271 * asfloat(CB0_m[83u].y)), 0.0f, 1.0f) - _1258, _1258);
  float _1305 = mad(_1299, clamp(_1285 * (_1271 * asfloat(CB0_m[83u].z)), 0.0f, 1.0f) - _1257, _1257);
  float _1361;
  float _1362;
  float _1363;
  if (CB0_m[86u].w != 0u) {
    float _1315 = asfloat(CB0_m[87u].x);
    float _1316 = asfloat(CB0_m[87u].w);
    float _1331 = asfloat(CB0_m[86u].z);
    float4 _1350 = T17.Sample(S2, float2(((((TEXCOORD.x - 0.5f) * _1331) / mad(TEXCOORD.y, asfloat(CB0_m[87u].z) - _1316, _1316)) - asfloat(CB0_m[86u].x)) + 0.5f, ((((TEXCOORD.y - 0.5f) * _1331) / mad(TEXCOORD.x, asfloat(CB0_m[87u].y) - _1315, _1315)) - asfloat(CB0_m[86u].y)) + 0.5f));
    float _1357 = asfloat(CB0_m[86u].w);
    _1361 = mad(_1350.x - _1303, _1357, _1303);
    _1362 = mad(_1350.y - _1304, _1357, _1304);
    _1363 = mad(_1350.z - _1305, _1357, _1305);
  } else {
    _1361 = _1303;
    _1362 = _1304;
    _1363 = _1305;
  }
  float _1551;
  float _1552;
  float _1553;
  if (_598) {
    float _1372 = max(max(max(_1362, _1363), _1361), 9.9999997473787516355514526367188e-05f);
    float _1383 = ((CB1_m1.y == 0u) && _1056) ? 1.0f : (((CB1_m2.y < _1372) ? mad(CB1_m3.x, _1372, CB1_m3.y) : _1372) / _1372);
    float _1384 = _1363 * _1383;
    float _1389 = floor(_1384 * 14.99989986419677734375f);
    float _1391 = mad(_1384, 15.0f, -_1389);
    float _1393 = ((_1361 * _1383) * 0.05859375f) + (_1389 * 0.0625f);
    float _1395 = mad(_1362 * _1383, 0.9375f, 0.03125f);
    float4 _1401 = T14.Sample(S2, float2(_1393 + 0.001953125f, _1395));
    float _1402 = _1401.x;
    float _1403 = _1401.y;
    float _1404 = _1401.z;
    float4 _1407 = T14.Sample(S2, float2(_1393 + 0.064453125f, _1395));
    float _1414 = mad(_1391, _1407.x - _1402, _1402);
    float _1415 = mad(_1407.y - _1403, _1391, _1403);
    float _1416 = mad(_1407.z - _1404, _1391, _1404);
    float _1545;
    float _1546;
    float _1547;
    if (int(T21.Load(0)) > 0) {
      float _1452 = clamp(asfloat(T21.Load4(32)).x + ((_325 < asfloat(T21.Load4(16)).z) ? clamp(asfloat(T21.Load4(16)).y * (_325 - asfloat(T21.Load4(16)).x), 0.0f, 1.0f) : (1.0f - clamp((_325 - asfloat(T21.Load4(16)).z) * asfloat(T21.Load4(16)).w, 0.0f, 1.0f))), 0.0f, 1.0f);
      float _1455 = floor(_1416 * 14.99989986419677734375f);
      float _1457 = mad(_1416, 15.0f, -_1455);
      float _1459 = (_1414 * 0.05859375f) + (_1455 * 0.0625f);
      float _1461 = mad(_1415, 0.9375f, 0.03125f);
      float4 _1466 = T12.Sample(S2, float2(_1459 + 0.001953125f, _1461));
      float _1467 = _1466.x;
      float _1468 = _1466.y;
      float _1469 = _1466.z;
      float4 _1472 = T12.Sample(S2, float2(_1459 + 0.064453125f, _1461));
      float _1485 = mad(_1452, mad(_1457, _1472.x - _1467, _1467) - _1414, _1414);
      float _1486 = mad(mad(_1472.y - _1468, _1457, _1468) - _1415, _1452, _1415);
      float _1487 = mad(mad(_1472.z - _1469, _1457, _1469) - _1416, _1452, _1416);
      float _1498 = clamp(asfloat(T21.Load2(48)).y + ((_325 < asfloat(T21.Load4(32)).w) ? clamp(asfloat(T21.Load4(32)).z * (_325 - asfloat(T21.Load4(32)).y), 0.0f, 1.0f) : (1.0f - clamp((_325 - asfloat(T21.Load4(32)).w) * asfloat(T21.Load2(48)).x, 0.0f, 1.0f))), 0.0f, 1.0f);
      float _1501 = floor(_1487 * 14.99989986419677734375f);
      float _1503 = mad(_1487, 15.0f, -_1501);
      float _1505 = (_1485 * 0.05859375f) + (_1501 * 0.0625f);
      float _1507 = mad(_1486, 0.9375f, 0.03125f);
      float4 _1512 = T13.Sample(S2, float2(_1505 + 0.001953125f, _1507));
      float _1513 = _1512.x;
      float _1514 = _1512.y;
      float _1515 = _1512.z;
      float4 _1518 = T13.Sample(S2, float2(_1505 + 0.064453125f, _1507));
      float _1541 = dp3_f32(float3(T15.Sample(S2, _310).xyz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      _1545 = mad((mad(_1518.z - _1515, _1503, _1515) - _1487) * _1498, _1541, _1487);
      _1546 = mad((mad(_1518.y - _1514, _1503, _1514) - _1486) * _1498, _1541, _1486);
      _1547 = mad(_1498 * (mad(_1503, _1518.x - _1513, _1513) - _1485), _1541, _1485);
    } else {
      _1545 = _1416;
      _1546 = _1415;
      _1547 = _1414;
    }
    _1551 = _1545 / _1383;
    _1552 = _1546 / _1383;
    _1553 = _1547 / _1383;
  } else {
    _1551 = _1363;
    _1552 = _1362;
    _1553 = _1361;
  }
  float _1555 = dp3_f32(float3(_1553, _1552, _1551), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _1557 = max(max(_1551, _1552), _1553);
  bool _1560 = CB0_m[41u].w != 0u;
  float _1594 = asfloat(CB0_m[42u].w);
  float _1606 = asfloat(CB0_m[39u].x);
  float _1607 = asfloat(CB0_m[39u].y);
  float _1608 = asfloat(CB0_m[39u].z);
  float _1640 = mad(T2.Load(int4(uint3(uint2(cvt_f32_u32(gl_FragCoord.x) & 63u, cvt_f32_u32(gl_FragCoord.y) & 63u), T1.Load(1840) & 31u), 0u)).x, 2.0f, -1.0f);
  float _1653 = _942 ? (float(int(((_1640 < 0.0f) ? 4294967295u : 0u) + uint(_1640 > 0.0f))) * (1.0f - sqrt(1.0f - abs(_1640)))) : _1640;
  float _1654 = mad(mad(exp2(log2(clamp(((_1560 ? _1553 : _1557) - asfloat(CB0_m[42u].x)) * asfloat(CB0_m[41u].x), 0.0f, 1.0f)) * _1594), asfloat(CB0_m[40u].x) - _1606, _1606), _1653, _1553);
  float _1655 = mad(mad(asfloat(CB0_m[40u].y) - _1607, exp2(log2(clamp(((_1560 ? _1552 : _1557) - asfloat(CB0_m[42u].y)) * asfloat(CB0_m[41u].y), 0.0f, 1.0f)) * _1594), _1607), _1653, _1552);
  float _1656 = mad(mad(asfloat(CB0_m[40u].z) - _1608, exp2(log2(clamp(((_1560 ? _1551 : _1557) - asfloat(CB0_m[42u].z)) * asfloat(CB0_m[41u].z), 0.0f, 1.0f)) * _1594), _1608), _1653, _1551);
  SV_Target.x = _942 ? _1654 : clamp(_1654, 0.0f, 1.0f);
  SV_Target.y = _942 ? _1655 : clamp(_1655, 0.0f, 1.0f);
  SV_Target.z = _942 ? _1656 : clamp(_1656, 0.0f, 1.0f);
  SV_Target.w = _942 ? _1555 : clamp(_1555, 0.0f, 1.0f);
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

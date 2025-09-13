
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

SamplerState S0 : register(s0, space0);
SamplerState S1 : register(s1, space0);
SamplerState S2 : register(s2, space0);
SamplerState S3 : register(s8, space0);

ByteAddressBuffer T0 : register(t2, space0);
ByteAddressBuffer T1 : register(t3, space0);
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
Texture2D<float4> T16 : register(t111, space0);
Texture2D<float4> T17 : register(t113, space0);
Texture2D<float4> T18 : register(t114, space0);
Buffer<float4> T19 : register(t116, space0);
ByteAddressBuffer T20 : register(t118, space0);

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
  precise float _264 = a.x * b.x;
  return mad(a.y, b.y, _264);
}

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp3_f32(float3 a, float3 b) {
  precise float _239 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _239));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float2 _277 = float2(TEXCOORD.x, TEXCOORD.y);
  float _287 = asfloat(CB0_m[0u].w) + 1.0f;
  float _291 = asfloat(CB0_m[0u].z);
  float _292 = _291 / (_287 - T5.SampleLevel(S0, _277, 0.0f).x);
  float4 _296 = T8.Sample(S3, _277);
  float _304 = asfloat(T0.Load(16));
  float4 _320 = T18.SampleLevel(S0, float2(TEXCOORD.x * asfloat(CB0_m[82u].x), TEXCOORD.y * asfloat(CB0_m[82u].y)), 0.0f);
  float _323 = _320.z;
  float _493;
  float _494;
  float _495;
  float _496;
  if ((_323 >= 1.0f) && (_320.w < 2.0f)) {
    float4 _333 = T17.SampleLevel(S0, _277, 0.0f);
    float _338 = asfloat(CB0_m[20u].x);
    float2 _341 = float2(_333.x * _338, _333.y * _338);
    float _346 = asfloat(CB0_m[20u].z);
    float _347 = min(sqrt(dp2_f32(_341, _341)), _346);
    float _350 = min(_323, 2.0f);
    float _354 = min(_350 + 1.0f, 2.0f);
    int _355 = cvt_f32_i32(_354);
    float _362 = ((_320.x / _323) * _350) * asfloat(CB0_m[66u].x);
    float _363 = asfloat(CB0_m[66u].y) * (_350 * (_320.y / _323));
    float _365 = trunc(_354) - 0.5f;
    float _366 = _365 / _350;
    float _368;
    float _371;
    float _373;
    float _375;
    _368 = 0.0f;
    _371 = 0.0f;
    _373 = 0.0f;
    _375 = 0.0f;
    float _369;
    float _372;
    float _374;
    float _376;
    uint _378;
    uint _377 = 0u;
    for (;;) {
      int _381 = int(_377);
      if (_355 <= _381) {
        break;
      }
      float _385 = float(_381);
      float _388 = (_385 + 0.5f) / _365;
      float2 _391 = float2(mad(_362, _388, TEXCOORD.x), mad(_388, _363, TEXCOORD.y));
      float4 _393 = T17.SampleLevel(S0, _391, 0.0f);
      float2 _398 = float2(_338 * _393.x, _338 * _393.y);
      float _401 = min(_346, sqrt(dp2_f32(_398, _398)));
      float _407 = _291 / (_287 - T4.SampleLevel(S0, _391, 0.0f).x);
      float _412 = _407 - _292;
      float _417 = max(_385 - 0.5f, 0.0f);
      float _422 = clamp(mad(_347, _366, -_417), 0.0f, 1.0f);
      float _427 = (1.0f - clamp((1.0f - _401) * 8.0f, 0.0f, 1.0f)) * dp2_f32(float2(clamp(mad(_412, 1.0f, 0.5f), 0.0f, 1.0f), clamp(mad(_412, -1.0f, 0.5f), 0.0f, 1.0f)), float2(_422, clamp(mad(_366, _401, -_417), 0.0f, 1.0f)));
      float4 _431 = T9.SampleLevel(S1, _391, 0.0f);
      float2 _439 = float2(mad(-_362, _388, TEXCOORD.x), mad(-_388, _363, TEXCOORD.y));
      float4 _441 = T17.SampleLevel(S0, _439, 0.0f);
      float2 _446 = float2(_338 * _441.x, _338 * _441.y);
      float _449 = min(_346, sqrt(dp2_f32(_446, _446)));
      float _454 = _291 / (_287 - T4.SampleLevel(S0, _439, 0.0f).x);
      float _459 = _454 - _292;
      float _470 = (1.0f - clamp((1.0f - _449) * 8.0f, 0.0f, 1.0f)) * dp2_f32(float2(clamp(mad(_459, 1.0f, 0.5f), 0.0f, 1.0f), clamp(mad(_459, -1.0f, 0.5f), 0.0f, 1.0f)), float2(_422, clamp(mad(_366, _449, -_417), 0.0f, 1.0f)));
      float4 _472 = T9.SampleLevel(S1, _439, 0.0f);
      bool _476 = _407 > _454;
      bool _477 = _401 < _449;
      bool _478 = _476 && _477;
      float _479 = _478 ? _470 : _427;
      float _482 = ((_476 || _477) || _478) ? _470 : _427;
      _376 = mad(_431.x, _479, mad(_472.x, _482, _375));
      _374 = mad(_431.y, _479, mad(_472.y, _482, _373));
      _372 = mad(_431.z, _479, mad(_472.z, _482, _371));
      _369 = (_482 + _368) + _479;
      _378 = _377 + 1u;
      _368 = _369;
      _371 = _372;
      _373 = _374;
      _375 = _376;
      _377 = _378;
      continue;
    }
    float _488 = float(_355 << int(1u));
    _493 = _371 / _488;
    _494 = _373 / _488;
    _495 = _375 / _488;
    _496 = _368 / _488;
  } else {
    _493 = 0.0f;
    _494 = 0.0f;
    _495 = 0.0f;
    _496 = 0.0f;
  }
  float _497 = 1.0f - _496;
  float4 _504 = T10.SampleLevel(S1, _277, 0.0f);
  float _509 = 1.0f - _504.w;
  float _510 = mad(mad(_497, _296.x * _304, _495), _509, _504.x);
  float _511 = mad(mad(_296.y * _304, _497, _494), _509, _504.y);
  float _512 = mad(mad(_497, _296.z * _304, _493), _509, _504.z);
  float4 _514 = T19.Load(0u);
  float _515 = _514.x;
  float _516 = _514.y;
  float _517 = _514.z;
  float4 _518 = T19.Load(1u);
  float _519 = _518.x;
  float _520 = _518.y;
  float _521 = _518.z;
  float _522 = _518.w;
  float4 _524 = T3.Load(int3(uint2(0u, 0u), 0u));
  float _525 = _524.x;
  bool _555;
  float _556;
  float _557;
  float _558;
  if (CB0_m[64u].x != 0u) {
    float4 _541 = T15.Sample(S3, _277);
    float _542 = _541.x;
    float _543 = _541.y;
    float _544 = _541.z;
    float _545 = _541.w;
    bool _547 = (_545 + 9.9999997473787516355514526367188e-05f) >= 1.0f;
    float _548 = 1.0f - _545;
    _555 = _547;
    _556 = _547 ? _544 : mad(_512, _548, _544);
    _557 = _547 ? _543 : mad(_511, _548, _543);
    _558 = _547 ? _542 : mad(_510, _548, _542);
  } else {
    _555 = false;
    _556 = _512;
    _557 = _511;
    _558 = _510;
  }
  float _562 = min(_525 * _558, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _563 = min(_525 * _557, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _564 = min(_525 * _556, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  bool _565 = !_555;
  float _727;
  float _728;
  float _729;
  float _730;
  if (_565) {
    float _645;
    if (CB0_m[73u].x != 0u) {
      float4 _578 = T6.Sample(S2, _277);
      float _593 = clamp(dp3_f32(float3(_525 * _578.x, _525 * _578.y, _525 * _578.z), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), asfloat(CB0_m[75u].z), asfloat(CB0_m[75u].w));
      float _618 = asfloat(CB0_m[69u].x);
      float _621 = asfloat(CB0_m[69u].y);
      float _622 = clamp(mad(_593, asfloat(CB0_m[75u].y), mad(log2(_593 + asfloat(CB0_m[75u].x)) * asfloat(CB0_m[73u].y), 0.693147182464599609375f, asfloat(CB0_m[73u].z)) - 10.0f) + asfloat(CB0_m[68u].w), _618, _621);
      _645 = exp2(mad(clamp(asfloat(CB0_m[73u].x), 0.0f, 1.0f), clamp(_618, mad(abs(_622) * asfloat(CB0_m[69u].z), float(int(((_622 < 0.0f) ? 4294967295u : 0u) + uint(_622 > 0.0f))), _622), _621) - TEXCOORD1, TEXCOORD1));
    } else {
      _645 = TEXCOORD.z;
    }
    float2 _661 = float2(TEXCOORD.x - asfloat(CB0_m[53u].x), TEXCOORD.y - asfloat(CB0_m[53u].y));
    float2 _675 = float2(dp2_f32(float2(asfloat(CB0_m[55u].x), asfloat(CB0_m[55u].y)), _661) * asfloat(CB0_m[53u].z), dp2_f32(float2(asfloat(CB0_m[55u].z), asfloat(CB0_m[55u].w)), _661) * asfloat(CB0_m[53u].w));
    float _685 = max((dp2_f32(_675, _675) - asfloat(CB0_m[56u].x)) * asfloat(CB0_m[56u].w)  * CUSTOM_VIGNETTE, 0.0f);
    float _697 = (_685 < 1.0f) ? (1.0f - exp2(_685 * (-10.0f))) : ((((_685 - 1.0f) > 0.0f) ? exp2((_685 - 2.0f) * 10.0f) : 0.0f) + 0.9980499744415283203125f);
    float _711 = asfloat(CB0_m[54u].w);
    bool _721 = CB0_m[54u].w != 0u;
    _727 = _645;
    _728 = _721 ? mad(_697, mad(_711, asfloat(CB0_m[54u].z) * _564, -_564), _564) : _564;
    _729 = _721 ? mad(_697, mad(_711, asfloat(CB0_m[54u].y) * _563, -_563), _563) : _563;
    _730 = _721 ? mad(mad(asfloat(CB0_m[54u].x) * _562, _711, -_562), _697, _562) : _562;
  } else {
    _727 = TEXCOORD.z;
    _728 = _564;
    _729 = _563;
    _730 = _562;
  }
  float _740 = clamp(clamp(TEXCOORD.y * asfloat(CB0_m[60u].y), 0.0f, 1.0f) + asfloat(CB0_m[57u].w), 0.0f, 1.0f);
  float _755 = clamp(clamp(clamp(TEXCOORD.y - asfloat(CB0_m[59u].w), 0.0f, 1.0f) * asfloat(CB0_m[60u].x), 0.0f, 1.0f) - asfloat(CB0_m[58u].w), 0.0f, 1.0f);
  float _761 = asfloat(CB0_m[57u].x);
  float _762 = asfloat(CB0_m[57u].y);
  float _763 = asfloat(CB0_m[57u].z);
  float _769 = asfloat(CB0_m[59u].x);
  float _770 = asfloat(CB0_m[59u].y);
  float _771 = asfloat(CB0_m[59u].z);
  float _775 = mad(_740, _769 - _761, _761);
  float _776 = mad(_740, _770 - _762, _762);
  float _777 = mad(_740, _771 - _763, _763);
  float _798 = mad(TEXCOORD.y, mad(_755, asfloat(CB0_m[58u].x) - _769, _769) - _775, _775) * _730;
  float _799 = _729 * mad(TEXCOORD.y, mad(_755, asfloat(CB0_m[58u].y) - _770, _770) - _776, _776);
  float _800 = _728 * mad(TEXCOORD.y, mad(_755, asfloat(CB0_m[58u].z) - _771, _771) - _777, _777);
  float _808 = (CB1_m1.x != 0u) ? CB1_m3.z : _517;
  float _811 = _727 / CB1_m2.x;
  float _815 = max(_798 * _811, 0.0f);
  float _816 = max(_811 * _799, 0.0f);
  float _817 = max(_811 * _800, 0.0f);
  float _845 = max(_798 * _727, 0.0f);
  float _846 = max(_727 * _799, 0.0f);
  float _847 = max(_727 * _800, 0.0f);
  bool _874 = CB1_m0.w != 0u;

  float _875, _876, _877;
#if 0
  float3 untonemapped = float3(_845, _846, _847);
  float3 hdr_tonemap = untonemapped;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    _875 = _874 ? (CB1_m2.x * (((mad(_815, mad(_515, _815, _519), _520) / mad(_815, mad(_515, _815, _516), _521)) - _522) * _808)) : clamp(_517 * ((mad(_845, mad(_515, _845, _519), _520) / mad(_845, mad(_515, _845, _516), _521)) - _522), 0.0f, 1.0f);
    _876 = _874 ? (CB1_m2.x * (_808 * ((mad(mad(_515, _816, _519), _816, _520) / mad(mad(_515, _816, _516), _816, _521)) - _522))) : clamp(_517 * ((mad(mad(_515, _846, _519), _846, _520) / mad(mad(_515, _846, _516), _846, _521)) - _522), 0.0f, 1.0f);
    _877 = _874 ? (CB1_m2.x * (_808 * ((mad(mad(_515, _817, _519), _817, _520) / mad(mad(_515, _817, _516), _817, _521)) - _522))) : clamp(_517 * ((mad(mad(_515, _847, _519), _847, _520) / mad(mad(_515, _847, _516), _847, _521)) - _522), 0.0f, 1.0f);
  } else {
    _874 = false;  // use SDR tonemapper
    _875 = _874 ? (CB1_m2.x * (((mad(_815, mad(_515, _815, _519), _520) / mad(_815, mad(_515, _815, _516), _521)) - _522) * _808)) : _517 * ((mad(_845, mad(_515, _845, _519), _520) / mad(_845, mad(_515, _845, _516), _521)) - _522);
    _876 = _874 ? (CB1_m2.x * (_808 * ((mad(mad(_515, _816, _519), _816, _520) / mad(mad(_515, _816, _516), _816, _521)) - _522))) : _517 * ((mad(mad(_515, _846, _519), _846, _520) / mad(mad(_515, _846, _516), _846, _521)) - _522);
    _877 = _874 ? (CB1_m2.x * (_808 * ((mad(mad(_515, _817, _519), _817, _520) / mad(mad(_515, _817, _516), _817, _521)) - _522))) : _517 * ((mad(mad(_515, _847, _519), _847, _520) / mad(mad(_515, _847, _516), _847, _521)) - _522);

    float3 ch_tonemap = float3(_875, _876, _877);

    float mid_gray = _874 ? (CB1_m2.x * (_808 * ((mad(mad(_515, 0.18, _519), 0.18, _520) / mad(mad(_515, 0.18, _516), 0.18, _521)) - _522))) : _517 * ((mad(mad(_515, 0.18, _519), 0.18, _520) / mad(mad(_515, 0.18, _516), 0.18, _521)) - _522);
    float3 untonemapped_mid_gray_shifted = float3(_845, _846, _847) * mid_gray / 0.18f;

    if (RENODX_TONE_MAP_PER_CHANNEL) {
      hdr_tonemap = lerp(ch_tonemap, untonemapped_mid_gray_shifted, saturate(renodx::color::y::from::BT709(ch_tonemap)));
      hdr_tonemap = HueAndChrominanceOKLab(hdr_tonemap, ch_tonemap, untonemapped_mid_gray_shifted, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_BLOWOUT_RESTORATION);
    } else {
      float y_in = renodx::color::y::from::BT709(untonemapped);
      float y_out = _874 ? (CB1_m2.x * (_808 * ((mad(mad(_515, y_in, _519), y_in, _520) / mad(mad(_515, y_in, _516), y_in, _521)) - _522))) : _517 * ((mad(mad(_515, y_in, _519), y_in, _520) / mad(mad(_515, y_in, _516), y_in, _521)) - _522);
      float3 lum_tonemap = renodx::color::correct::Luminance(untonemapped, y_in, y_out, 1.f);

      // 0 - (midgray * 1.5): lum tonemap
      // (midgray * 1.5) - 1: ch tonemap
      //                  >1: untonemapped mid gray shifted
      lum_tonemap = lerp(lum_tonemap, ch_tonemap, saturate(renodx::color::y::from::BT709(lum_tonemap) / (mid_gray * 1.5f)));
      hdr_tonemap = lerp(lum_tonemap, untonemapped_mid_gray_shifted, saturate(renodx::color::y::from::BT709(lum_tonemap)));
      hdr_tonemap = HueAndChrominanceOKLab(hdr_tonemap, ch_tonemap, untonemapped_mid_gray_shifted, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_BLOWOUT_RESTORATION);
    }

    _875 = hdr_tonemap.r, _876 = hdr_tonemap.g, _877 = hdr_tonemap.b;
  }
#else
  ApplyToneMap(_874,
               float3(_845, _846, _847),
               float3(_815, _816, _817),
               _875, _876, _877,
               CB1_m2.x,
               _515, _516, _517,
               _519, _520, _521, _522,
               _808);
#endif
  float _950;
  float _951;
  float _952;
  if (_565) {
    float _947;
    float _948;
    float _949;
    if (CB0_m[50u].w != 0u) {
      float2 _900 = float2(TEXCOORD.x - asfloat(CB0_m[49u].x), TEXCOORD.y - asfloat(CB0_m[49u].y));
      float2 _914 = float2(dp2_f32(float2(asfloat(CB0_m[51u].x), asfloat(CB0_m[51u].y)), _900) * asfloat(CB0_m[49u].z), dp2_f32(float2(asfloat(CB0_m[51u].z), asfloat(CB0_m[51u].w)), _900) * asfloat(CB0_m[49u].w));
      float _932 = T7.Sample(S2, clamp((dp2_f32(_914, _914) - asfloat(CB0_m[52u].x)) * asfloat(CB0_m[52u].w), 0.0f, 1.0f)).w * asfloat(CB0_m[50u].w);
      _947 = mad(_932, asfloat(CB0_m[50u].z) - _877, _877);
      _948 = mad(_932, asfloat(CB0_m[50u].y) - _876, _876);
      _949 = mad(_932, asfloat(CB0_m[50u].x) - _875, _875);
    } else {
      _947 = _877;
      _948 = _876;
      _949 = _875;
    }
    _950 = _947;
    _951 = _948;
    _952 = _949;
  } else {
    _950 = _877;
    _951 = _876;
    _952 = _875;
  }
  bool _988 = _874 && (CB1_m0.z == 0u);
  float _989, _990, _991;
#if 0
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    _988 = false;
  }
  if (USE_SRGB_LUT_ENCODING) {
    _989 = _988 ? _952 : renodx::color::srgb::EncodeSafe(_952);
    _990 = _988 ? _951 : renodx::color::srgb::EncodeSafe(_951);
    _991 = _988 ? _950 : renodx::color::srgb::EncodeSafe(_950);
  } else {
    _989 = _988 ? _952 : ((_952 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _952) : mad(CB1_m4.y, exp2(log2(_952) * CB1_m4.x), -CB1_m4.z));
    _990 = _988 ? _951 : ((_951 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _951) : mad(CB1_m4.y, exp2(CB1_m4.x * log2(_951)), -CB1_m4.z));
    _991 = _988 ? _950 : ((_950 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _950) : mad(CB1_m4.y, exp2(CB1_m4.x * log2(_950)), -CB1_m4.z));
  }
#else
  EncodeForLUT(_988,
               _952, _951, _950,
               CB1_m3.w, CB1_m4.x, CB1_m4.y, CB1_m4.z,
               _989, _990, _991);
#endif

  float3 _992 = float3(_989, _990, _991);
  float _997 = max(dp3_f32(float3(0.265399992465972900390625f, 0.67040002346038818359375f, 0.06419999897480010986328125f), _992), 0.0f);
  float _1003 = mad(((max(dp3_f32(float3(0.02480000071227550506591796875f, 0.1247999966144561767578125f, 0.85039997100830078125f), _992), 0.0f) + _997) / max(dp3_f32(float3(0.514900028705596923828125f, 0.324400007724761962890625f, 0.1606999933719635009765625f), _992), 0.00999999977648258209228515625f)) + 1.0f, 1.33000004291534423828125f, -1.67999994754791259765625f) * _997;
  float _1017 = asfloat(CB0_m[83u].w);
  float _1031 = clamp(mad(0.039999999105930328369140625f / (dp3_f32(float3(_510 * _525, _511 * _525, _512 * _525), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)) + 0.039999999105930328369140625f), asfloat(CB0_m[84u].x), asfloat(CB0_m[84u].y)), 0.0f, 1.0f);
  float _1035 = mad(_1031, clamp((_1003 * asfloat(CB0_m[83u].x)) * _1017, 0.0f, 1.0f) - _989, _989);
  float _1036 = mad(_1031, clamp(_1017 * (_1003 * asfloat(CB0_m[83u].y)), 0.0f, 1.0f) - _990, _990);
  float _1037 = mad(_1031, clamp(_1017 * (_1003 * asfloat(CB0_m[83u].z)), 0.0f, 1.0f) - _991, _991);
  float _1093;
  float _1094;
  float _1095;
  if (CB0_m[86u].w != 0u) {
    float _1047 = asfloat(CB0_m[87u].x);
    float _1048 = asfloat(CB0_m[87u].w);
    float _1063 = asfloat(CB0_m[86u].z);
    float4 _1082 = T16.Sample(S2, float2(((((TEXCOORD.x - 0.5f) * _1063) / mad(TEXCOORD.y, asfloat(CB0_m[87u].z) - _1048, _1048)) - asfloat(CB0_m[86u].x)) + 0.5f, (((_1063 * (TEXCOORD.y - 0.5f)) / mad(TEXCOORD.x, asfloat(CB0_m[87u].y) - _1047, _1047)) - asfloat(CB0_m[86u].y)) + 0.5f));
    float _1089 = asfloat(CB0_m[86u].w);
    _1093 = mad(_1082.x - _1035, _1089, _1035);
    _1094 = mad(_1089, _1082.y - _1036, _1036);
    _1095 = mad(_1089, _1082.z - _1037, _1037);
  } else {
    _1093 = _1035;
    _1094 = _1036;
    _1095 = _1037;
  }
  float _1283;
  float _1284;
  float _1285;
  if (_565) {  // apply LUT
    float _1146, _1147, _1148;
    float _1104 = max(max(max(_1094, _1095), _1093), 9.9999997473787516355514526367188e-05f);
    float _1115 = ((CB1_m1.y == 0u) && _988) ? 1.0f : (((CB1_m2.y < _1104) ? mad(_1104, CB1_m3.x, CB1_m3.y) : _1104) / _1104);

    float3 color_sdr, color_hdr;
    PrepareForLUT(_1093, _1094, _1095, color_sdr, color_hdr, _1115);
#if 1
    float _1116 = _1095 * _1115;
    float _1121 = floor(_1116 * 14.99989986419677734375f);
    float _1123 = mad(_1116, 15.0f, -_1121);
    float _1125 = (_1121 * 0.0625f) + ((_1093 * _1115) * 0.05859375f);
    float _1127 = mad(_1094 * _1115, 0.9375f, 0.03125f);
    float4 _1133 = T13.Sample(S2, float2(_1125 + 0.001953125f, _1127));
    float _1134 = _1133.x;
    float _1135 = _1133.y;
    float _1136 = _1133.z;
    float4 _1139 = T13.Sample(S2, float2(_1125 + 0.064453125f, _1127));
    _1146 = mad(_1123, _1139.x - _1134, _1134);
    _1147 = mad(_1123, _1139.y - _1135, _1135);
    _1148 = mad(_1123, _1139.z - _1136, _1136);
#else
    float3 lut1 = renodx::lut::SampleTetrahedral(T13, color_sdr, 16u);
    _1146 = lut1.r, _1147 = lut1.g, _1148 = lut1.b;
#endif
    float _1277;
    float _1278;
    float _1279;
    if (int(T20.Load(0)) > 0) {
      float _1184 = clamp(asfloat(T20.Load4(32)).x + ((_292 < asfloat(T20.Load4(16)).z) ? clamp(asfloat(T20.Load4(16)).y * (_292 - asfloat(T20.Load4(16)).x), 0.0f, 1.0f) : (1.0f - clamp(asfloat(T20.Load4(16)).w * (_292 - asfloat(T20.Load4(16)).z), 0.0f, 1.0f))), 0.0f, 1.0f);
      float _1187 = floor(_1148 * 14.99989986419677734375f);
      float _1189 = mad(_1148, 15.0f, -_1187);
      float _1191 = (_1146 * 0.05859375f) + (_1187 * 0.0625f);
      float _1193 = mad(_1147, 0.9375f, 0.03125f);
      float4 _1198 = T11.Sample(S2, float2(_1191 + 0.001953125f, _1193));
      float _1199 = _1198.x;
      float _1200 = _1198.y;
      float _1201 = _1198.z;
      float4 _1204 = T11.Sample(S2, float2(_1191 + 0.064453125f, _1193));
      float _1217 = mad(_1184, mad(_1189, _1204.x - _1199, _1199) - _1146, _1146);
      float _1218 = mad(mad(_1204.y - _1200, _1189, _1200) - _1147, _1184, _1147);
      float _1219 = mad(mad(_1204.z - _1201, _1189, _1201) - _1148, _1184, _1148);
      float _1230 = clamp(asfloat(T20.Load2(48)).y + ((_292 < asfloat(T20.Load4(32)).w) ? clamp(asfloat(T20.Load4(32)).z * (_292 - asfloat(T20.Load4(32)).y), 0.0f, 1.0f) : (1.0f - clamp(asfloat(T20.Load2(48)).x * (_292 - asfloat(T20.Load4(32)).w), 0.0f, 1.0f))), 0.0f, 1.0f);
      float _1233 = floor(_1219 * 14.99989986419677734375f);
      float _1235 = mad(_1219, 15.0f, -_1233);
      float _1237 = (_1217 * 0.05859375f) + (_1233 * 0.0625f);
      float _1239 = mad(_1218, 0.9375f, 0.03125f);
      float4 _1244 = T12.Sample(S2, float2(_1237 + 0.001953125f, _1239));
      float _1245 = _1244.x;
      float _1246 = _1244.y;
      float _1247 = _1244.z;
      float4 _1250 = T12.Sample(S2, float2(_1237 + 0.064453125f, _1239));
      float _1273 = dp3_f32(float3(T14.Sample(S2, _277).xyz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      _1277 = mad((mad(_1250.z - _1247, _1235, _1247) - _1219) * _1230, _1273, _1219);
      _1278 = mad((mad(_1250.y - _1246, _1235, _1246) - _1218) * _1230, _1273, _1218);
      _1279 = mad(_1230 * (mad(_1235, _1250.x - _1245, _1245) - _1217), _1273, _1217);
    } else {
      _1277 = _1148;
      _1278 = _1147;
      _1279 = _1146;
    }
    _1283 = _1277 / _1115;
    _1284 = _1278 / _1115;
    _1285 = _1279 / _1115;

    UpgradeLUTOutput(color_hdr, color_sdr, _1285, _1284, _1283);
  } else {
    _1283 = _1095;
    _1284 = _1094;
    _1285 = _1093;
  }
  float _1287 = dp3_f32(float3(_1285, _1284, _1283), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _1289 = max(max(_1283, _1284), _1285);
  bool _1292 = CB0_m[41u].w != 0u;
  float _1326 = asfloat(CB0_m[42u].w);
  float _1338 = asfloat(CB0_m[39u].x);
  float _1339 = asfloat(CB0_m[39u].y);
  float _1340 = asfloat(CB0_m[39u].z);

  float _1372 = mad(T2.Load(int4(uint3(uint2(cvt_f32_u32(gl_FragCoord.x) & 63u, cvt_f32_u32(gl_FragCoord.y) & 63u), T1.Load(1840) & 31u), 0u)).x, 2.0f, -1.0f);
  float _1385 = _874 ? (float(int(((_1372 < 0.0f) ? 4294967295u : 0u) + uint(_1372 > 0.0f))) * (1.0f - sqrt(1.0f - abs(_1372)))) : _1372;
  float _1386 = mad(mad(exp2(log2(clamp(((_1292 ? _1285 : _1289) - asfloat(CB0_m[42u].x)) * asfloat(CB0_m[41u].x), 0.0f, 1.0f)) * _1326), asfloat(CB0_m[40u].x) - _1338, _1338), _1385, _1285);
  float _1387 = mad(mad(asfloat(CB0_m[40u].y) - _1339, exp2(log2(clamp(((_1292 ? _1284 : _1289) - asfloat(CB0_m[42u].y)) * asfloat(CB0_m[41u].y), 0.0f, 1.0f)) * _1326), _1339), _1385, _1284);
  float _1388 = mad(mad(asfloat(CB0_m[40u].z) - _1340, exp2(log2(clamp(((_1292 ? _1283 : _1289) - asfloat(CB0_m[42u].z)) * asfloat(CB0_m[41u].z), 0.0f, 1.0f)) * _1326), _1340), _1385, _1283);
  SV_Target.x = _874 ? _1386 : (_1386);
  SV_Target.y = _874 ? _1387 : (_1387);
  SV_Target.z = _874 ? _1388 : (_1388);
  SV_Target.w = _874 ? _1287 : clamp(_1287, 0.0f, 1.0f);

  SV_Target.rgb = FinalizeTonemap(SV_Target.rgb, TEXCOORD.xy);
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

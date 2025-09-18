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
ByteAddressBuffer T16 : register(t118, space0);
SamplerState S0 : register(s0, space0);
SamplerState S1 : register(s2, space0);
SamplerState S2 : register(s8, space0);
Texture2DArray<float4> T2 : register(t25, space0);
Texture2D<float4> T3 : register(t44, space0);
Texture2D<float4> T4 : register(t78, space0);
Texture2D<float4> T5 : register(t81, space0);
Texture1D<float4> T6 : register(t89, space0);
Texture2D<float4> T7 : register(t90, space0);
Texture2D<float4> T8 : register(t100, space0);
Texture2D<float4> T9 : register(t101, space0);
Texture2D<float4> T10 : register(t106, space0);
Texture2D<float4> T11 : register(t107, space0);
Texture2D<float4> T12 : register(t109, space0);
Texture2D<float4> T13 : register(t110, space0);
Texture2D<float4> T14 : register(t111, space0);
Buffer<float4> T15 : register(t116, space0);

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

float dp3_f32(float3 a, float3 b) {
  precise float _235 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _235));
}

float dp2_f32(float2 a, float2 b) {
  precise float _224 = a.x * b.x;
  return mad(a.y, b.y, _224);
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float2 _251 = float2(TEXCOORD.x, TEXCOORD.y);
  float4 _254 = T13.Sample(S0, _251);
  float2 _259 = float2(_254.xy);
  float4 _261 = T7.Sample(S2, _259);
  float _269 = asfloat(T0.Load(16));
  float _270 = _261.x * _269;
  float _271 = _261.y * _269;
  float _272 = _261.z * _269;
  float4 _274 = T15.Load(0u);
  float _275 = _274.x;
  float _276 = _274.y;
  float _277 = _274.z;
  float4 _278 = T15.Load(1u);
  float _279 = _278.x;
  float _280 = _278.y;
  float _281 = _278.z;
  float _282 = _278.w;
  float4 _284 = T3.Load(int3(uint2(0u, 0u), 0u));
  float _285 = _284.x;
  bool _317;
  float _318;
  float _319;
  float _320;
  if (CB0_m[64u].x != 0u) {
    float4 _303 = T12.Sample(S2, _251);
    float _304 = _303.x;
    float _305 = _303.y;
    float _306 = _303.z;
    float _307 = _303.w;
    bool _309 = (_307 + 9.9999997473787516355514526367188e-05f) >= 1.0f;
    float _310 = 1.0f - _307;
    _317 = _309;
    _318 = _309 ? _306 : mad(_310, _272, _306);
    _319 = _309 ? _305 : mad(_310, _271, _305);
    _320 = _309 ? _304 : mad(_310, _270, _304);
  } else {
    _317 = false;
    _318 = _272;
    _319 = _271;
    _320 = _270;
  }
  float _324 = min(_285 * _320, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _325 = min(_285 * _319, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _326 = min(_285 * _318, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  bool _327 = !_317;
  float _490;
  float _491;
  float _492;
  float _493;
  if (_327) {
    float _407;
    if (CB0_m[73u].x != 0u) {
      float4 _340 = T5.Sample(S1, _259);
      float _355 = clamp(dp3_f32(float3(_285 * _340.x, _285 * _340.y, _285 * _340.z), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), asfloat(CB0_m[75u].z), asfloat(CB0_m[75u].w));
      float _380 = asfloat(CB0_m[69u].x);
      float _383 = asfloat(CB0_m[69u].y);
      float _384 = clamp(mad(_355, asfloat(CB0_m[75u].y), mad(log2(_355 + asfloat(CB0_m[75u].x)) * asfloat(CB0_m[73u].y), 0.693147182464599609375f, asfloat(CB0_m[73u].z)) - 10.0f) + asfloat(CB0_m[68u].w), _380, _383);
      _407 = exp2(mad(clamp(asfloat(CB0_m[73u].x), 0.0f, 1.0f), clamp(_380, mad(abs(_384) * asfloat(CB0_m[69u].z), float(int(((_384 < 0.0f) ? 4294967295u : 0u) + uint(_384 > 0.0f))), _384), _383) - TEXCOORD1, TEXCOORD1));
    } else {
      _407 = TEXCOORD.z;
    }
    float2 _424 = float2(TEXCOORD.x - asfloat(CB0_m[53u].x), TEXCOORD.y - asfloat(CB0_m[53u].y));
    float2 _438 = float2(dp2_f32(float2(asfloat(CB0_m[55u].x), asfloat(CB0_m[55u].y)), _424) * asfloat(CB0_m[53u].z), dp2_f32(float2(asfloat(CB0_m[55u].z), asfloat(CB0_m[55u].w)), _424) * asfloat(CB0_m[53u].w));
    float _448 = max((dp2_f32(_438, _438) - asfloat(CB0_m[56u].x)) * asfloat(CB0_m[56u].w) * CUSTOM_VIGNETTE, 0.0f);
    float _460 = (_448 < 1.0f) ? (1.0f - exp2(_448 * (-10.0f))) : ((((_448 - 1.0f) > 0.0f) ? exp2((_448 - 2.0f) * 10.0f) : 0.0f) + 0.9980499744415283203125f);
    float _474 = asfloat(CB0_m[54u].w);
    bool _484 = CB0_m[54u].w != 0u;
    _490 = _407;
    _491 = _484 ? mad(_460, mad(_474, asfloat(CB0_m[54u].z) * _326, -_326), _326) : _326;
    _492 = _484 ? mad(mad(_474, asfloat(CB0_m[54u].y) * _325, -_325), _460, _325) : _325;
    _493 = _484 ? mad(mad(asfloat(CB0_m[54u].x) * _324, _474, -_324), _460, _324) : _324;
  } else {
    _490 = TEXCOORD.z;
    _491 = _326;
    _492 = _325;
    _493 = _324;
  }
  float _503 = clamp(clamp(TEXCOORD.y * asfloat(CB0_m[60u].y), 0.0f, 1.0f) + asfloat(CB0_m[57u].w), 0.0f, 1.0f);
  float _518 = clamp(clamp(clamp(TEXCOORD.y - asfloat(CB0_m[59u].w), 0.0f, 1.0f) * asfloat(CB0_m[60u].x), 0.0f, 1.0f) - asfloat(CB0_m[58u].w), 0.0f, 1.0f);
  float _524 = asfloat(CB0_m[57u].x);
  float _525 = asfloat(CB0_m[57u].y);
  float _526 = asfloat(CB0_m[57u].z);
  float _532 = asfloat(CB0_m[59u].x);
  float _533 = asfloat(CB0_m[59u].y);
  float _534 = asfloat(CB0_m[59u].z);
  float _538 = mad(_503, _532 - _524, _524);
  float _539 = mad(_533 - _525, _503, _525);
  float _540 = mad(_534 - _526, _503, _526);
  float _561 = mad(TEXCOORD.y, mad(_518, asfloat(CB0_m[58u].x) - _532, _532) - _538, _538) * _493;
  float _562 = _492 * mad(TEXCOORD.y, mad(_518, asfloat(CB0_m[58u].y) - _533, _533) - _539, _539);
  float _563 = _491 * mad(TEXCOORD.y, mad(_518, asfloat(CB0_m[58u].z) - _534, _534) - _540, _540);
  float _571 = (CB1_m1.x != 0u) ? CB1_m3.z : _277;
  float _574 = _490 / CB1_m2.x;
  float _578 = max(_561 * _574, 0.0f);
  float _579 = max(_574 * _562, 0.0f);
  float _580 = max(_574 * _563, 0.0f);
  float _608 = max(_561 * _490, 0.0f);
  float _609 = max(_490 * _562, 0.0f);
  float _610 = max(_490 * _563, 0.0f);
  bool _637 = CB1_m0.w != 0u;

  float _638, _639, _640;
#if 0
  _638 = _637 ? (CB1_m2.x * (((mad(_578, mad(_275, _578, _279), _280) / mad(_578, mad(_275, _578, _276), _281)) - _282) * _571)) : clamp(_277 * ((mad(_608, mad(_275, _608, _279), _280) / mad(_608, mad(_275, _608, _276), _281)) - _282), 0.0f, 1.0f);
  _639 = _637 ? (CB1_m2.x * (_571 * ((mad(mad(_275, _579, _279), _579, _280) / mad(mad(_275, _579, _276), _579, _281)) - _282))) : clamp(_277 * ((mad(mad(_275, _609, _279), _609, _280) / mad(mad(_275, _609, _276), _609, _281)) - _282), 0.0f, 1.0f);
  _640 = _637 ? (CB1_m2.x * (_571 * ((mad(mad(_275, _580, _279), _580, _280) / mad(mad(_275, _580, _276), _580, _281)) - _282))) : clamp(_277 * ((mad(mad(_275, _610, _279), _610, _280) / mad(mad(_275, _610, _276), _610, _281)) - _282), 0.0f, 1.0f);
#else
  ApplyToneMap(_637,
               float3(_608, _609, _610),
               float3(_578, _579, _580),
               _638, _639, _640,
               CB1_m2.x,
               _275, _276, _277,
               _279, _280, _281, _282,
               _571);

#endif
  float _713;
  float _714;
  float _715;
  if (_327) {
    float _710;
    float _711;
    float _712;
    if (CB0_m[50u].w != 0u) {
      float2 _663 = float2(TEXCOORD.x - asfloat(CB0_m[49u].x), TEXCOORD.y - asfloat(CB0_m[49u].y));
      float2 _677 = float2(dp2_f32(float2(asfloat(CB0_m[51u].x), asfloat(CB0_m[51u].y)), _663) * asfloat(CB0_m[49u].z), dp2_f32(float2(asfloat(CB0_m[51u].z), asfloat(CB0_m[51u].w)), _663) * asfloat(CB0_m[49u].w));
      float _695 = T6.Sample(S1, clamp((dp2_f32(_677, _677) - asfloat(CB0_m[52u].x)) * asfloat(CB0_m[52u].w), 0.0f, 1.0f)).w * asfloat(CB0_m[50u].w);
      _710 = mad(_695, asfloat(CB0_m[50u].z) - _640, _640);
      _711 = mad(_695, asfloat(CB0_m[50u].y) - _639, _639);
      _712 = mad(_695, asfloat(CB0_m[50u].x) - _638, _638);
    } else {
      _710 = _640;
      _711 = _639;
      _712 = _638;
    }
    _713 = _710;
    _714 = _711;
    _715 = _712;
  } else {
    _713 = _640;
    _714 = _639;
    _715 = _638;
  }
  bool _751 = _637 && (CB1_m0.z == 0u);

  float _752, _753, _754;
#if 0
  _752 = _751 ? _715 : ((_715 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _715) : mad(exp2(CB1_m4.x * log2(_715)), CB1_m4.y, -CB1_m4.z));
  _753 = _751 ? _714 : ((_714 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _714) : mad(CB1_m4.y, exp2(CB1_m4.x * log2(_714)), -CB1_m4.z));
  _754 = _751 ? _713 : ((_713 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _713) : mad(CB1_m4.y, exp2(CB1_m4.x * log2(_713)), -CB1_m4.z));
#else
  EncodeForLUT(_751,
               _715, _714, _713,
               CB1_m3.w, CB1_m4.x, CB1_m4.y, CB1_m4.z,
               _752, _753, _754);
#endif
  float3 _755 = float3(_752, _753, _754);
  float _760 = max(dp3_f32(float3(0.265399992465972900390625f, 0.67040002346038818359375f, 0.06419999897480010986328125f), _755), 0.0f);
  float _766 = mad(((max(dp3_f32(float3(0.02480000071227550506591796875f, 0.1247999966144561767578125f, 0.85039997100830078125f), _755), 0.0f) + _760) / max(dp3_f32(float3(0.514900028705596923828125f, 0.324400007724761962890625f, 0.1606999933719635009765625f), _755), 0.00999999977648258209228515625f)) + 1.0f, 1.33000004291534423828125f, -1.67999994754791259765625f) * _760;
  float _780 = asfloat(CB0_m[83u].w);
  float _794 = clamp(mad(0.039999999105930328369140625f / (dp3_f32(float3(_285 * _270, _285 * _271, _285 * _272), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)) + 0.039999999105930328369140625f), asfloat(CB0_m[84u].x), asfloat(CB0_m[84u].y)), 0.0f, 1.0f);
  float _798 = mad(_794, clamp((_766 * asfloat(CB0_m[83u].x)) * _780, 0.0f, 1.0f) - _752, _752);
  float _799 = mad(_794, clamp(_780 * (_766 * asfloat(CB0_m[83u].y)), 0.0f, 1.0f) - _753, _753);
  float _800 = mad(_794, clamp(_780 * (_766 * asfloat(CB0_m[83u].z)), 0.0f, 1.0f) - _754, _754);
  float _856;
  float _857;
  float _858;
  if (CB0_m[86u].w != 0u) {
    float _810 = asfloat(CB0_m[87u].x);
    float _811 = asfloat(CB0_m[87u].w);
    float _826 = asfloat(CB0_m[86u].z);
    float4 _845 = T14.Sample(S1, float2((((_826 * (TEXCOORD.x - 0.5f)) / mad(TEXCOORD.y, asfloat(CB0_m[87u].z) - _811, _811)) - asfloat(CB0_m[86u].x)) + 0.5f, (((_826 * (TEXCOORD.y - 0.5f)) / mad(TEXCOORD.x, asfloat(CB0_m[87u].y) - _810, _810)) - asfloat(CB0_m[86u].y)) + 0.5f));
    float _852 = asfloat(CB0_m[86u].w);
    _856 = mad(_845.x - _798, _852, _798);
    _857 = mad(_852, _845.y - _799, _799);
    _858 = mad(_852, _845.z - _800, _800);
  } else {
    _856 = _798;
    _857 = _799;
    _858 = _800;
  }
  float _1059;
  float _1060;
  float _1061;
  if (_327) {
    float _867 = max(max(max(_858, _857), _856), 9.9999997473787516355514526367188e-05f);
    float _878 = ((CB1_m1.y == 0u) && _751) ? 1.0f : (((_867 > CB1_m2.y) ? mad(_867, CB1_m3.x, CB1_m3.y) : _867) / _867);

#if 1
    float3 color_sdr, color_hdr;
    PrepareForLUT(_856, _857, _858, color_sdr, color_hdr, _878);
#endif

    float _879 = _858 * _878;
    float _884 = floor(_879 * 14.99989986419677734375f);
    float _886 = mad(_879, 15.0f, -_884);
    float _888 = (_884 * 0.0625f) + ((_856 * _878) * 0.05859375f);
    float _890 = mad(_857 * _878, 0.9375f, 0.03125f);
    float4 _896 = T10.Sample(S1, float2(_888 + 0.001953125f, _890));
    float _897 = _896.x;
    float _898 = _896.y;
    float _899 = _896.z;
    float4 _902 = T10.Sample(S1, float2(_888 + 0.064453125f, _890));
    float _909 = mad(_886, _902.x - _897, _897);
    float _910 = mad(_886, _902.y - _898, _898);
    float _911 = mad(_886, _902.z - _899, _899);
    float _1053;
    float _1054;
    float _1055;
    if (int(T16.Load(0)) > 0) {
      float _931 = asfloat(CB0_m[0u].z) / ((asfloat(CB0_m[0u].w) + 1.0f) - T4.SampleLevel(S0, _259, 0.0f).x);
      float _960 = clamp(asfloat(T16.Load4(32)).x + ((_931 < asfloat(T16.Load4(16)).z) ? clamp((_931 - asfloat(T16.Load4(16)).x) * asfloat(T16.Load4(16)).y, 0.0f, 1.0f) : (1.0f - clamp(asfloat(T16.Load4(16)).w * (_931 - asfloat(T16.Load4(16)).z), 0.0f, 1.0f))), 0.0f, 1.0f);
      float _963 = floor(_911 * 14.99989986419677734375f);
      float _965 = mad(_911, 15.0f, -_963);
      float _967 = (_963 * 0.0625f) + (_909 * 0.05859375f);
      float _969 = mad(_910, 0.9375f, 0.03125f);
      float4 _974 = T8.Sample(S1, float2(_967 + 0.001953125f, _969));
      float _975 = _974.x;
      float _976 = _974.y;
      float _977 = _974.z;
      float4 _980 = T8.Sample(S1, float2(_967 + 0.064453125f, _969));
      float _993 = mad(_960, mad(_965, _980.x - _975, _975) - _909, _909);
      float _994 = mad(_960, mad(_965, _980.y - _976, _976) - _910, _910);
      float _995 = mad(_960, mad(_965, _980.z - _977, _977) - _911, _911);
      float _1006 = clamp(((asfloat(T16.Load4(32)).w > _931) ? clamp(asfloat(T16.Load4(32)).z * (_931 - asfloat(T16.Load4(32)).y), 0.0f, 1.0f) : (1.0f - clamp((_931 - asfloat(T16.Load4(32)).w) * asfloat(T16.Load2(48)).x, 0.0f, 1.0f))) + asfloat(T16.Load2(48)).y, 0.0f, 1.0f);
      float _1009 = floor(_995 * 14.99989986419677734375f);
      float _1011 = mad(_995, 15.0f, -_1009);
      float _1013 = (_993 * 0.05859375f) + (_1009 * 0.0625f);
      float _1015 = mad(_994, 0.9375f, 0.03125f);
      float4 _1020 = T9.Sample(S1, float2(_1013 + 0.001953125f, _1015));
      float _1021 = _1020.x;
      float _1022 = _1020.y;
      float _1023 = _1020.z;
      float4 _1026 = T9.Sample(S1, float2(_1013 + 0.064453125f, _1015));
      float _1049 = dp3_f32(float3(T11.Sample(S1, _259).xyz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      _1053 = mad((mad(_1026.z - _1023, _1011, _1023) - _995) * _1006, _1049, _995);
      _1054 = mad((mad(_1026.y - _1022, _1011, _1022) - _994) * _1006, _1049, _994);
      _1055 = mad(_1006 * (mad(_1011, _1026.x - _1021, _1021) - _993), _1049, _993);
    } else {
      _1053 = _911;
      _1054 = _910;
      _1055 = _909;
    }
    _1059 = _1053 / _878;
    _1060 = _1054 / _878;
    _1061 = _1055 / _878;

#if 1
    UpgradeLUTOutput(color_hdr, color_sdr, _1061, _1060, _1059);
#endif

  } else {
    _1059 = _858;
    _1060 = _857;
    _1061 = _856;
  }
  float _1063 = dp3_f32(float3(_1061, _1060, _1059), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _1065 = max(max(_1059, _1060), _1061);
  bool _1068 = CB0_m[41u].w != 0u;
  float _1102 = asfloat(CB0_m[42u].w);
  float _1114 = asfloat(CB0_m[39u].x);
  float _1115 = asfloat(CB0_m[39u].y);
  float _1116 = asfloat(CB0_m[39u].z);
  float _1148 = mad(T2.Load(int4(uint3(uint2(cvt_f32_u32(gl_FragCoord.x) & 63u, cvt_f32_u32(gl_FragCoord.y) & 63u), T1.Load(1840) & 31u), 0u)).x, 2.0f, -1.0f);
  float _1161 = _637 ? (float(int(((_1148 < 0.0f) ? 4294967295u : 0u) + uint(_1148 > 0.0f))) * (1.0f - sqrt(1.0f - abs(_1148)))) : _1148;
  float _1162 = mad(mad(exp2(log2(clamp(((_1068 ? _1061 : _1065) - asfloat(CB0_m[42u].x)) * asfloat(CB0_m[41u].x), 0.0f, 1.0f)) * _1102), asfloat(CB0_m[40u].x) - _1114, _1114), _1161, _1061);
  float _1163 = mad(mad(asfloat(CB0_m[40u].y) - _1115, exp2(log2(clamp(((_1068 ? _1060 : _1065) - asfloat(CB0_m[42u].y)) * asfloat(CB0_m[41u].y), 0.0f, 1.0f)) * _1102), _1115), _1161, _1060);
  float _1164 = mad(mad(asfloat(CB0_m[40u].z) - _1116, exp2(log2(clamp(((_1068 ? _1059 : _1065) - asfloat(CB0_m[42u].z)) * asfloat(CB0_m[41u].z), 0.0f, 1.0f)) * _1102), _1116), _1161, _1059);
  SV_Target.x = _637 ? _1162 : (_1162);
  SV_Target.y = _637 ? _1163 : (_1163);
  SV_Target.z = _637 ? _1164 : (_1164);
  SV_Target.w = _637 ? _1063 : clamp(_1063, 0.0f, 1.0f);

#if 1
  SV_Target.rgb = FinalizeTonemap(SV_Target.rgb, TEXCOORD.xy);
#endif
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

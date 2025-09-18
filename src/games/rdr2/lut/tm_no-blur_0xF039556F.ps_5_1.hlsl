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
ByteAddressBuffer T15 : register(t118, space0);
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
Texture2D<float4> T13 : register(t111, space0);
Buffer<float4> T14 : register(t116, space0);

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
  precise float _234 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _234));
}

float dp2_f32(float2 a, float2 b) {
  precise float _223 = a.x * b.x;
  return mad(a.y, b.y, _223);
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float2 _250 = float2(TEXCOORD.x, TEXCOORD.y);
  float4 _253 = T7.Sample(S2, _250);
  float _261 = asfloat(T0.Load(16));
  float _262 = _253.x * _261;
  float _263 = _253.y * _261;
  float _264 = _253.z * _261;
  float4 _266 = T14.Load(0u);
  float _267 = _266.x;
  float _268 = _266.y;
  float _269 = _266.z;
  float4 _270 = T14.Load(1u);
  float _271 = _270.x;
  float _272 = _270.y;
  float _273 = _270.z;
  float _274 = _270.w;
  float4 _276 = T3.Load(int3(uint2(0u, 0u), 0u));
  float _277 = _276.x;
  bool _309;
  float _310;
  float _311;
  float _312;
  if (CB0_m[64u].x != 0u) {
    float4 _295 = T12.Sample(S2, _250);
    float _296 = _295.x;
    float _297 = _295.y;
    float _298 = _295.z;
    float _299 = _295.w;
    bool _301 = (_299 + 9.9999997473787516355514526367188e-05f) >= 1.0f;
    float _302 = 1.0f - _299;
    _309 = _301;
    _310 = _301 ? _298 : mad(_302, _264, _298);
    _311 = _301 ? _297 : mad(_302, _263, _297);
    _312 = _301 ? _296 : mad(_302, _262, _296);
  } else {
    _309 = false;
    _310 = _264;
    _311 = _263;
    _312 = _262;
  }
  float _316 = min(_277 * _312, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _317 = min(_277 * _311, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  float _318 = min(_277 * _310, (UNCLAMP_HIGHLIGHTS != 0.f) ? renodx::math::FLT32_MAX : 65504.0f);
  bool _319 = !_309;
  float _482;
  float _483;
  float _484;
  float _485;
  if (_319) {
    float _399;
    if (CB0_m[73u].x != 0u) {
      float4 _332 = T5.Sample(S1, _250);
      float _347 = clamp(dp3_f32(float3(_277 * _332.x, _277 * _332.y, _277 * _332.z), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), asfloat(CB0_m[75u].z), asfloat(CB0_m[75u].w));
      float _372 = asfloat(CB0_m[69u].x);
      float _375 = asfloat(CB0_m[69u].y);
      float _376 = clamp(mad(_347, asfloat(CB0_m[75u].y), mad(log2(_347 + asfloat(CB0_m[75u].x)) * asfloat(CB0_m[73u].y), 0.693147182464599609375f, asfloat(CB0_m[73u].z)) - 10.0f) + asfloat(CB0_m[68u].w), _372, _375);
      _399 = exp2(mad(clamp(asfloat(CB0_m[73u].x), 0.0f, 1.0f), clamp(_372, mad(abs(_376) * asfloat(CB0_m[69u].z), float(int(((_376 < 0.0f) ? 4294967295u : 0u) + uint(_376 > 0.0f))), _376), _375) - TEXCOORD1, TEXCOORD1));
    } else {
      _399 = TEXCOORD.z;
    }
    float2 _416 = float2(TEXCOORD.x - asfloat(CB0_m[53u].x), TEXCOORD.y - asfloat(CB0_m[53u].y));
    float2 _430 = float2(dp2_f32(float2(asfloat(CB0_m[55u].x), asfloat(CB0_m[55u].y)), _416) * asfloat(CB0_m[53u].z), dp2_f32(float2(asfloat(CB0_m[55u].z), asfloat(CB0_m[55u].w)), _416) * asfloat(CB0_m[53u].w));
    float _440 = max((dp2_f32(_430, _430) - asfloat(CB0_m[56u].x)) * asfloat(CB0_m[56u].w) * CUSTOM_VIGNETTE, 0.0f);
    float _452 = (_440 < 1.0f) ? (1.0f - exp2(_440 * (-10.0f))) : ((((_440 - 1.0f) > 0.0f) ? exp2((_440 - 2.0f) * 10.0f) : 0.0f) + 0.9980499744415283203125f);
    float _466 = asfloat(CB0_m[54u].w);
    bool _476 = CB0_m[54u].w != 0u;
    _482 = _399;
    _483 = _476 ? mad(mad(_466, asfloat(CB0_m[54u].z) * _318, -_318), _452, _318) : _318;
    _484 = _476 ? mad(mad(_466, asfloat(CB0_m[54u].y) * _317, -_317), _452, _317) : _317;
    _485 = _476 ? mad(mad(asfloat(CB0_m[54u].x) * _316, _466, -_316), _452, _316) : _316;
  } else {
    _482 = TEXCOORD.z;
    _483 = _318;
    _484 = _317;
    _485 = _316;
  }
  float _495 = clamp(clamp(TEXCOORD.y * asfloat(CB0_m[60u].y), 0.0f, 1.0f) + asfloat(CB0_m[57u].w), 0.0f, 1.0f);
  float _510 = clamp(clamp(clamp(TEXCOORD.y - asfloat(CB0_m[59u].w), 0.0f, 1.0f) * asfloat(CB0_m[60u].x), 0.0f, 1.0f) - asfloat(CB0_m[58u].w), 0.0f, 1.0f);
  float _516 = asfloat(CB0_m[57u].x);
  float _517 = asfloat(CB0_m[57u].y);
  float _518 = asfloat(CB0_m[57u].z);
  float _524 = asfloat(CB0_m[59u].x);
  float _525 = asfloat(CB0_m[59u].y);
  float _526 = asfloat(CB0_m[59u].z);
  float _530 = mad(_495, _524 - _516, _516);
  float _531 = mad(_495, _525 - _517, _517);
  float _532 = mad(_495, _526 - _518, _518);
  float _553 = mad(TEXCOORD.y, mad(_510, asfloat(CB0_m[58u].x) - _524, _524) - _530, _530) * _485;
  float _554 = _484 * mad(TEXCOORD.y, mad(_510, asfloat(CB0_m[58u].y) - _525, _525) - _531, _531);
  float _555 = _483 * mad(TEXCOORD.y, mad(_510, asfloat(CB0_m[58u].z) - _526, _526) - _532, _532);
  float _563 = (CB1_m1.x != 0u) ? CB1_m3.z : _269;
  float _566 = _482 / CB1_m2.x;
  float _570 = max(_553 * _566, 0.0f);
  float _571 = max(_566 * _554, 0.0f);
  float _572 = max(_566 * _555, 0.0f);
  float _600 = max(_553 * _482, 0.0f);
  float _601 = max(_482 * _554, 0.0f);
  float _602 = max(_482 * _555, 0.0f);
  bool _629 = CB1_m0.w != 0u;

  float _630, _631, _632;
#if 0
  _630 = _629 ? (CB1_m2.x * (((mad(_570, mad(_267, _570, _271), _272) / mad(_570, mad(_267, _570, _268), _273)) - _274) * _563)) : clamp(_269 * ((mad(_600, mad(_267, _600, _271), _272) / mad(_600, mad(_267, _600, _268), _273)) - _274), 0.0f, 1.0f);
  _631 = _629 ? (CB1_m2.x * (_563 * ((mad(mad(_267, _571, _271), _571, _272) / mad(mad(_267, _571, _268), _571, _273)) - _274))) : clamp(_269 * ((mad(mad(_267, _601, _271), _601, _272) / mad(mad(_267, _601, _268), _601, _273)) - _274), 0.0f, 1.0f);
  _632 = _629 ? (CB1_m2.x * (_563 * ((mad(mad(_267, _572, _271), _572, _272) / mad(mad(_267, _572, _268), _572, _273)) - _274))) : clamp(_269 * ((mad(mad(_267, _602, _271), _602, _272) / mad(mad(_267, _602, _268), _602, _273)) - _274), 0.0f, 1.0f);
#else
  ApplyToneMap(_629,
               float3(_600, _601, _602),
               float3(_570, _571, _572),
               _630, _631, _632,
               CB1_m2.x,
               _267, _268, _269,
               _271, _272, _273, _274,
               _563);

#endif
  float _705;
  float _706;
  float _707;
  if (_319) {
    float _702;
    float _703;
    float _704;
    if (CB0_m[50u].w != 0u) {
      float2 _655 = float2(TEXCOORD.x - asfloat(CB0_m[49u].x), TEXCOORD.y - asfloat(CB0_m[49u].y));
      float2 _669 = float2(dp2_f32(float2(asfloat(CB0_m[51u].x), asfloat(CB0_m[51u].y)), _655) * asfloat(CB0_m[49u].z), dp2_f32(float2(asfloat(CB0_m[51u].z), asfloat(CB0_m[51u].w)), _655) * asfloat(CB0_m[49u].w));
      float _687 = T6.Sample(S1, clamp((dp2_f32(_669, _669) - asfloat(CB0_m[52u].x)) * asfloat(CB0_m[52u].w), 0.0f, 1.0f)).w * asfloat(CB0_m[50u].w);
      _702 = mad(_687, asfloat(CB0_m[50u].z) - _632, _632);
      _703 = mad(_687, asfloat(CB0_m[50u].y) - _631, _631);
      _704 = mad(_687, asfloat(CB0_m[50u].x) - _630, _630);
    } else {
      _702 = _632;
      _703 = _631;
      _704 = _630;
    }
    _705 = _702;
    _706 = _703;
    _707 = _704;
  } else {
    _705 = _632;
    _706 = _631;
    _707 = _630;
  }
  bool _743 = _629 && (CB1_m0.z == 0u);

  float _744, _745, _746;
#if 0
  float _744 = _743 ? _707 : ((_707 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _707) : mad(exp2(CB1_m4.x * log2(_707)), CB1_m4.y, -CB1_m4.z));
  float _745 = _743 ? _706 : ((_706 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _706) : mad(CB1_m4.y, exp2(CB1_m4.x * log2(_706)), -CB1_m4.z));
  float _746 = _743 ? _705 : ((_705 < 0.003130800090730190277099609375f) ? (CB1_m3.w * _705) : mad(CB1_m4.y, exp2(CB1_m4.x * log2(_705)), -CB1_m4.z));
#else
  EncodeForLUT(_743,
               _707, _706, _705,
               CB1_m3.w, CB1_m4.x, CB1_m4.y, CB1_m4.z,
               _744, _745, _746);
#endif
  float3 _747 = float3(_744, _745, _746);
  float _752 = max(dp3_f32(float3(0.265399992465972900390625f, 0.67040002346038818359375f, 0.06419999897480010986328125f), _747), 0.0f);
  float _758 = mad(((max(dp3_f32(float3(0.02480000071227550506591796875f, 0.1247999966144561767578125f, 0.85039997100830078125f), _747), 0.0f) + _752) / max(dp3_f32(float3(0.514900028705596923828125f, 0.324400007724761962890625f, 0.1606999933719635009765625f), _747), 0.00999999977648258209228515625f)) + 1.0f, 1.33000004291534423828125f, -1.67999994754791259765625f) * _752;
  float _772 = asfloat(CB0_m[83u].w);
  float _786 = clamp(mad(0.039999999105930328369140625f / (dp3_f32(float3(_277 * _262, _277 * _263, _277 * _264), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)) + 0.039999999105930328369140625f), asfloat(CB0_m[84u].x), asfloat(CB0_m[84u].y)), 0.0f, 1.0f);
  float _790 = mad(_786, clamp((_758 * asfloat(CB0_m[83u].x)) * _772, 0.0f, 1.0f) - _744, _744);
  float _791 = mad(_786, clamp(_772 * (_758 * asfloat(CB0_m[83u].y)), 0.0f, 1.0f) - _745, _745);
  float _792 = mad(_786, clamp(_772 * (_758 * asfloat(CB0_m[83u].z)), 0.0f, 1.0f) - _746, _746);
  float _848;
  float _849;
  float _850;
  if (CB0_m[86u].w != 0u) {
    float _802 = asfloat(CB0_m[87u].x);
    float _803 = asfloat(CB0_m[87u].w);
    float _818 = asfloat(CB0_m[86u].z);
    float4 _837 = T13.Sample(S1, float2((((_818 * (TEXCOORD.x - 0.5f)) / mad(TEXCOORD.y, asfloat(CB0_m[87u].z) - _803, _803)) - asfloat(CB0_m[86u].x)) + 0.5f, (((_818 * (TEXCOORD.y - 0.5f)) / mad(TEXCOORD.x, asfloat(CB0_m[87u].y) - _802, _802)) - asfloat(CB0_m[86u].y)) + 0.5f));
    float _844 = asfloat(CB0_m[86u].w);
    _848 = mad(_837.x - _790, _844, _790);
    _849 = mad(_844, _837.y - _791, _791);
    _850 = mad(_844, _837.z - _792, _792);
  } else {
    _848 = _790;
    _849 = _791;
    _850 = _792;
  }
  float _1052;
  float _1053;
  float _1054;
  if (_319) {
    float _859 = max(max(max(_850, _849), _848), 9.9999997473787516355514526367188e-05f);
    float _870 = ((CB1_m1.y == 0u) && _743) ? 1.0f : (((_859 > CB1_m2.y) ? mad(_859, CB1_m3.x, CB1_m3.y) : _859) / _859);

#if 1
    float3 color_sdr, color_hdr;
    PrepareForLUT(_848, _849, _850, color_sdr, color_hdr, _870);
#endif

    float _871 = _850 * _870;
    float _876 = floor(_871 * 14.99989986419677734375f);
    float _878 = mad(_871, 15.0f, -_876);
    float _880 = (_876 * 0.0625f) + ((_848 * _870) * 0.05859375f);
    float _882 = mad(_849 * _870, 0.9375f, 0.03125f);
    float4 _888 = T10.Sample(S1, float2(_880 + 0.001953125f, _882));
    float _889 = _888.x;
    float _890 = _888.y;
    float _891 = _888.z;
    float4 _894 = T10.Sample(S1, float2(_880 + 0.064453125f, _882));
    float _901 = mad(_878, _894.x - _889, _889);
    float _902 = mad(_878, _894.y - _890, _890);
    float _903 = mad(_878, _894.z - _891, _891);
    float _1046;
    float _1047;
    float _1048;
    if (int(T15.Load(0)) > 0) {
      float _924 = asfloat(CB0_m[0u].z) / ((asfloat(CB0_m[0u].w) + 1.0f) - T4.SampleLevel(S0, _250, 0.0f).x);
      float _953 = clamp(((_924 < asfloat(T15.Load4(16)).z) ? clamp((_924 - asfloat(T15.Load4(16)).x) * asfloat(T15.Load4(16)).y, 0.0f, 1.0f) : (1.0f - clamp((_924 - asfloat(T15.Load4(16)).z) * asfloat(T15.Load4(16)).w, 0.0f, 1.0f))) + asfloat(T15.Load4(32)).x, 0.0f, 1.0f);
      float _956 = floor(_903 * 14.99989986419677734375f);
      float _958 = mad(_903, 15.0f, -_956);
      float _960 = (_901 * 0.05859375f) + (_956 * 0.0625f);
      float _962 = mad(_902, 0.9375f, 0.03125f);
      float4 _967 = T8.Sample(S1, float2(_960 + 0.001953125f, _962));
      float _968 = _967.x;
      float _969 = _967.y;
      float _970 = _967.z;
      float4 _973 = T8.Sample(S1, float2(_960 + 0.064453125f, _962));
      float _986 = mad(_953, mad(_958, _973.x - _968, _968) - _901, _901);
      float _987 = mad(mad(_973.y - _969, _958, _969) - _902, _953, _902);
      float _988 = mad(mad(_973.z - _970, _958, _970) - _903, _953, _903);
      float _999 = clamp(((asfloat(T15.Load4(32)).w > _924) ? clamp(asfloat(T15.Load4(32)).z * (_924 - asfloat(T15.Load4(32)).y), 0.0f, 1.0f) : (1.0f - clamp((_924 - asfloat(T15.Load4(32)).w) * asfloat(T15.Load2(48)).x, 0.0f, 1.0f))) + asfloat(T15.Load2(48)).y, 0.0f, 1.0f);
      float _1002 = floor(_988 * 14.99989986419677734375f);
      float _1004 = mad(_988, 15.0f, -_1002);
      float _1006 = (_986 * 0.05859375f) + (_1002 * 0.0625f);
      float _1008 = mad(_987, 0.9375f, 0.03125f);
      float4 _1013 = T9.Sample(S1, float2(_1006 + 0.001953125f, _1008));
      float _1014 = _1013.x;
      float _1015 = _1013.y;
      float _1016 = _1013.z;
      float4 _1019 = T9.Sample(S1, float2(_1006 + 0.064453125f, _1008));
      float _1042 = dp3_f32(float3(T11.Sample(S1, _250).xyz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      _1046 = mad((mad(_1019.z - _1016, _1004, _1016) - _988) * _999, _1042, _988);
      _1047 = mad((mad(_1019.y - _1015, _1004, _1015) - _987) * _999, _1042, _987);
      _1048 = mad(_999 * (mad(_1004, _1019.x - _1014, _1014) - _986), _1042, _986);
    } else {
      _1046 = _903;
      _1047 = _902;
      _1048 = _901;
    }
    _1052 = _1046 / _870;
    _1053 = _1047 / _870;
    _1054 = _1048 / _870;

#if 1
    UpgradeLUTOutput(color_hdr, color_sdr, _1054, _1053, _1052);
#endif

  } else {
    _1052 = _850;
    _1053 = _849;
    _1054 = _848;
  }
  float _1056 = dp3_f32(float3(_1054, _1053, _1052), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
  float _1058 = max(max(_1052, _1053), _1054);
  bool _1061 = CB0_m[41u].w != 0u;
  float _1095 = asfloat(CB0_m[42u].w);
  float _1107 = asfloat(CB0_m[39u].x);
  float _1108 = asfloat(CB0_m[39u].y);
  float _1109 = asfloat(CB0_m[39u].z);
  float _1141 = mad(T2.Load(int4(uint3(uint2(cvt_f32_u32(gl_FragCoord.x) & 63u, cvt_f32_u32(gl_FragCoord.y) & 63u), T1.Load(1840) & 31u), 0u)).x, 2.0f, -1.0f);
  float _1154 = _629 ? (float(int(((_1141 < 0.0f) ? 4294967295u : 0u) + uint(_1141 > 0.0f))) * (1.0f - sqrt(1.0f - abs(_1141)))) : _1141;
  float _1155 = mad(mad(exp2(log2(clamp(((_1061 ? _1054 : _1058) - asfloat(CB0_m[42u].x)) * asfloat(CB0_m[41u].x), 0.0f, 1.0f)) * _1095), asfloat(CB0_m[40u].x) - _1107, _1107), _1154, _1054);
  float _1156 = mad(mad(asfloat(CB0_m[40u].y) - _1108, exp2(log2(clamp(((_1061 ? _1053 : _1058) - asfloat(CB0_m[42u].y)) * asfloat(CB0_m[41u].y), 0.0f, 1.0f)) * _1095), _1108), _1154, _1053);
  float _1157 = mad(mad(asfloat(CB0_m[40u].z) - _1109, exp2(log2(clamp(((_1061 ? _1052 : _1058) - asfloat(CB0_m[42u].z)) * asfloat(CB0_m[41u].z), 0.0f, 1.0f)) * _1095), _1109), _1154, _1052);
  SV_Target.x = _629 ? _1155 : (_1155);
  SV_Target.y = _629 ? _1156 : (_1156);
  SV_Target.z = _629 ? _1157 : (_1157);
  SV_Target.w = _629 ? _1056 : clamp(_1056, 0.0f, 1.0f);

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

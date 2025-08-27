#include "../common.hlsli"

struct _660 {
  uint2 _m0;
  uint _m1;
};

static const float2 _47[6] = { 0.0f.xx, 0.0f.xx, 0.0f.xx, 0.0f.xx, 0.0f.xx, 0.0f.xx };
static const float3 _52[6] = { 0.0f.xxx, 0.0f.xxx, 0.0f.xxx, 0.0f.xxx, 0.0f.xxx, 0.0f.xxx };
static const float2 _179[10] = { (-1.0f).xx, float2(0.0f, -1.0f), float2(1.0f, -1.0f), float2(-1.0f, 0.0f), 0.0f.xx, float2(1.0f, 0.0f), float2(-1.0f, 1.0f), float2(0.0f, 1.0f), 1.0f.xx, 0.0f.xx };

cbuffer CB0_buf : register(b0, space8) {
  float4 CB0_m[20] : packoffset(c0);
};

SamplerState S0 : register(s0, space8);
SamplerState S1 : register(s1, space8);
SamplerState S2 : register(s2, space8);
Texture2D<float4> T0 : register(t0, space8);
Texture2D<float4> T1 : register(t1, space8);
Texture2D<float4> T2 : register(t2, space8);
Texture2D<float4> T3 : register(t3, space8);
Texture2D<float4> T4 : register(t4, space8);
Texture2D<float4> T5 : register(t5, space8);
Texture2D<float4> T6 : register(t6, space8);
Texture2D<float4> T7 : register(t7, space8);
Texture2D<float4> T8 : register(t8, space8);
Texture3D<float4> T9 : register(t9, space8);
RWBuffer<float4> U0 : register(u0, space8);

static float4 SV_POSITION;
static float2 TEXCOORD;
static float2 TEXCOORD1;
static float4 TEXCOORD2;
static float4 SV_TARGET;
static float SV_TARGET1;

struct SPIRV_Cross_Input {
  float4 SV_POSITION : SV_POSITION;
  float2 TEXCOORD : TEXCOORD;
  float2 TEXCOORD1 : TEXCOORD1;
  float4 TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output {
  float4 SV_TARGET : SV_Target0;
  float SV_TARGET1 : SV_Target1;
};

static float2 x0[6] = _47;
static float3 x1[6] = _52;

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param) {
  uint2 ret;
  Tex.GetDimensions(Level, ret.x, ret.y, Param);
  return ret;
}

float dp2_f32(float2 a, float2 b) {
  precise float _225 = a.x * b.x;
  return mad(a.y, b.y, _225);
}

float dp3_f32(float3 a, float3 b) {
  precise float _210 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _210));
}

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

void frag_main() {
  float _237 = mad(TEXCOORD.x, 2.0f, -1.0f);
  float _238 = mad(TEXCOORD.y, 2.0f, -1.0f);
  float2 _247 = float2(_237 * CB0_m[3u].y, CB0_m[3u].z * _238);
  bool _252 = CB0_m[3u].x != 0.0f;
  float _255 = log2(abs(_252 ? _237 : _238));
  float _271 = mad(CB0_m[2u].x, 2.0f, 1.0f);
  float _272 = mad(dp2_f32(_247, _247), CB0_m[2u].x, 1.0f) / _271;
  float _275 = mad(((exp2(CB0_m[2u].z * _255) + exp2(_255 * CB0_m[2u].w)) * CB0_m[2u].y) * 0.5f, 1.0f - _272, _272);
  float _276 = _275 * _237;
  float _277 = _275 * _238;
  float _278 = mad(_276, 0.5f, 0.5f);
  float _279 = mad(_277, 0.5f, 0.5f);
  float _288 = mad(TEXCOORD2.x, 2.0f, -1.0f);
  float _289 = mad(TEXCOORD2.y, 2.0f, -1.0f);
  float _290 = mad(TEXCOORD2.z, 2.0f, -1.0f);
  float _291 = mad(TEXCOORD2.w, 2.0f, -1.0f);
  float2 _296 = float2(_288 * CB0_m[3u].y, CB0_m[3u].z * _289);
  float _302 = log2(abs(_252 ? _288 : _289));
  float _303 = log2(abs(_252 ? _290 : _291));
  float _317 = mad(dp2_f32(_296, _296), CB0_m[2u].x, 1.0f) / _271;
  float _321 = mad(((exp2(CB0_m[2u].z * _302) + exp2(CB0_m[2u].w * _302)) * CB0_m[2u].y) * 0.5f, 1.0f - _317, _317);
  float _324 = mad(_288 * _321, 0.5f, 0.5f);
  float _325 = mad(_321 * _289, 0.5f, 0.5f);
  float2 _326 = float2(_290 * CB0_m[3u].y, CB0_m[3u].z * _291);
  float _329 = mad(dp2_f32(_326, _326), CB0_m[2u].x, 1.0f) / _271;
  float _331 = mad(1.0f - _329, ((exp2(CB0_m[2u].z * _303) + exp2(CB0_m[2u].w * _303)) * CB0_m[2u].y) * 0.5f, _329);
  float _334 = mad(_331 * _290, 0.5f, 0.5f);
  float _335 = mad(_331 * _291, 0.5f, 0.5f);
  float _346 = max(min(_278, CB0_m[17u].x), clamp(_278, CB0_m[17u].x, CB0_m[17u].z));
  float _347 = max(min(_279, CB0_m[17u].y), clamp(_279, CB0_m[17u].y, CB0_m[17u].w));
  float2 _362 = float2(_346, _347);
  float4 _365 = T2.Sample(S1, _362);
  float4 _373 = T3.Sample(S1, _362);
  float _379 = max(min(_324, CB0_m[17u].x), clamp(_324, CB0_m[17u].x, CB0_m[17u].z));
  float _380 = max(min(_325, CB0_m[17u].y), clamp(_325, CB0_m[17u].y, CB0_m[17u].w));
  float _385 = max(min(_334, CB0_m[17u].x), clamp(_334, CB0_m[17u].x, CB0_m[17u].z));
  float _386 = max(clamp(_335, CB0_m[17u].y, CB0_m[17u].w), min(_335, CB0_m[17u].y));
  float2 _387 = float2(_379, _380);
  float2 _391 = float2(_385, _386);
  float2 _399 = float2((_379 + _385) * 0.5f, (_380 + _386) * 0.5f);
  float4 _401 = T4.SampleLevel(S1, _399, 0.0f);
  float _402 = _401.x;
  float _403 = mad(_402, 1.0f, T4.SampleLevel(S1, _387, 0.0f).x);
  float2 _409 = float2((_346 + _385) * 0.5f, (_386 + _347) * 0.5f);
  float4 _411 = T4.SampleLevel(S1, _409, 0.0f);
  float _412 = _411.x;
  float _413 = mad(_412, 0.5f, mad(_402, 0.5f, T4.SampleLevel(S1, _391, 0.0f).x));
  float _414 = mad(_412, 1.0f, T4.Sample(S1, _362).x);
  float _415 = _403 * 0.5f;
  float _416 = _413 * 0.5f;
  float _417 = _414 * 0.5f;
  float4 _425 = T2.SampleLevel(S1, _399, 0.0f);
  float4 _431 = T2.SampleLevel(S1, _409, 0.0f);
  float4 _443 = T3.SampleLevel(S1, _399, 0.0f);
  float4 _449 = T3.SampleLevel(S1, _409, 0.0f);
  float2 _455 = float2(_278, _279);
  float4 _462 = T1.Sample(S0, _455);
  float2 _464 = float2(_324, _325);
  float2 _468 = float2(_334, _335);
  float _474 = (_324 + _334) * 0.5f;
  float _475 = (_325 + _335) * 0.5f;
  float2 _476 = float2(_474, _475);
  float4 _478 = T1.SampleLevel(S0, _476, 0.0f);
  float _479 = _478.x;
  float _480 = mad(_479, 1.0f, T1.SampleLevel(S0, _464, 0.0f).x);
  float _484 = (_278 + _334) * 0.5f;
  float _485 = (_279 + _335) * 0.5f;
  float2 _486 = float2(_484, _485);
  float4 _488 = T1.SampleLevel(S0, _486, 0.0f);
  float _489 = _488.x;
  float _490 = mad(_489, 0.5f, mad(_479, 0.5f, T1.SampleLevel(S0, _468, 0.0f).x));
  float _491 = mad(_489, 1.0f, _462.x);
  float4 _502 = T0.SampleLevel(S1, _476, 0.0f);
  float4 _508 = T0.SampleLevel(S1, _486, 0.0f);
  float _513 = mad(_502.x, 1.0f, T0.SampleLevel(S1, _464, 0.0f).x) * 0.5f;
  float _514 = mad(_508.y, 0.5f, mad(_502.y, 0.5f, T0.SampleLevel(S1, _468, 0.0f).y)) * 0.5f;
  float _515 = mad(_508.z, 1.0f, T0.Sample(S1, _455).z) * 0.5f;
  float _537 = _415 + (mad(_403, -0.5f, max(_415, clamp(_480 * (-0.125f), 0.0f, 1.0f))) * float(_403 > 0.0f));
  float _538 = (float(_413 > 0.0f) * mad(_413, -0.5f, max(clamp(_490 * (-0.125f), 0.0f, 1.0f), _416))) + _416;
  float _539 = (float(_414 > 0.0f) * mad(_414, -0.5f, max(clamp(_491 * (-0.125f), 0.0f, 1.0f), _417))) + _417;
  float _551 = min((abs(_480 * 0.5f) * CB0_m[19u].x) * 24.0f, 1.0f);
  float _552 = min((abs(_490 * 0.5f) * CB0_m[19u].x) * 24.0f, 1.0f);
  float _557 = clamp(_480 * 2.400000095367431640625f, 0.0f, 1.0f);
  float _558 = clamp(_490 * 2.400000095367431640625f, 0.0f, 1.0f);
  float _559 = clamp(_491 * 2.400000095367431640625f, 0.0f, 1.0f);
  float _563 = clamp(_480 * (-2.400000095367431640625f), 0.0f, 1.0f);
  float _564 = clamp(_490 * (-2.400000095367431640625f), 0.0f, 1.0f);
  float _565 = clamp(_491 * (-2.400000095367431640625f), 0.0f, 1.0f);
  float _587 = mad(clamp((mad(_480, 0.5f, _537) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), float(_537 > 0.0f) - _563, _563);
  float _588 = mad(clamp((mad(_490, 0.5f, _538) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), float(_538 > 0.0f) - _564, _564);
  float _589 = mad(clamp((mad(_491, 0.5f, _539) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), float(_539 > 0.0f) - _565, _565);
  x0[0u].x = _278;
  x0[0u].y = _279;
  x0[1u].x = _324;
  x0[1u].y = _325;
  x0[2u].x = _334;
  x0[2u].y = _335;
  x0[3u].x = _474;
  x0[3u].y = _475;
  x0[4u].x = _484;
  x0[4u].y = _485;
  x1[0u].z = _515;
  x1[1u].x = _513;
  x1[2u].y = _514;
  x1[3u].x = _513;
  x1[3u].y = _514;
  x1[4u].y = _514;
  x1[4u].z = _515;
  if (((((_587 < 1.0f) || (_588 < 1.0f)) || (_589 < 1.0f)) || (((_558 < 1.0f) || (_557 < 1.0f)) || (_559 < 1.0f))) && (((_551 > 0.0f) || (_552 > 0.0f)) || (min((abs(_491 * 0.5f) * CB0_m[19u].x) * 24.0f, 1.0f) > 0.0f))) {
    uint _649;
    uint _648 = 0u;
    for (;;) {
      if (int(_648) >= 5) {
        break;
      }
      uint _657;
      spvTextureSize(T0, 0u, _657);
      bool _658 = _657 > 0u;
      uint _659_dummy_parameter;
      _660 _661 = { spvTextureSize(T0, 0u, _659_dummy_parameter), 1u };
      float _668 = _551 / float(_658 ? _661._m0.x : 0u);
      float _669 = _552 / float(_658 ? _661._m0.y : 0u);
      uint _670 = min(_648, 5u);
      float _678;
      float _681;
      float _683;
      float _685;
      _678 = 0.0f;
      _681 = 0.0f;
      _683 = 0.0f;
      _685 = 0.0f;
      float _679;
      float _682;
      float _684;
      float _686;
      uint _688;
      uint _687 = 0u;
      for (;;) {
        if (_687 == 9u) {
          break;
        }
        uint _694 = min(_687, 9u);
        float _703 = mad(_668, _179[_694].x, x0[_670].x);
        float _704 = mad(_669, _179[_694].y, x0[_670].y);
        float4 _719 = T0.SampleLevel(S1, float2(max(min(_703, CB0_m[16u].x), clamp(_703, CB0_m[16u].x, CB0_m[16u].z)), max(clamp(_704, CB0_m[16u].y, CB0_m[16u].w), min(_704, CB0_m[16u].y))), 0.0f);
        float _720 = _719.x;
        float _728 = asfloat(2129859010u - asuint(dp3_f32(float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f), float3(_720, _719.yz)) + 0.5f));
        _686 = mad(_720, _728, _685);
        _684 = mad(_719.y, _728, _683);
        _682 = mad(_719.z, _728, _681);
        _679 = _728 + _678;
        _688 = _687 + 1u;
        _678 = _679;
        _681 = _682;
        _683 = _684;
        _685 = _686;
        _687 = _688;
        continue;
      }
      if (_648 < 5u) {
        x1[_648].x = _685 / _678;
        x1[_648].y = _683 / _678;
        x1[_648].z = _681 / _678;
      }
      _649 = _648 + 1u;
      _648 = _649;
      continue;
    }
  }
  float _759 = mad(x1[3u].x, 1.0f, x1[1u].x) * 0.5f;
  float _760 = mad(x1[4u].y, 0.5f, mad(x1[3u].y, 0.5f, x1[2u].y)) * 0.5f;
  float _761 = mad(x1[4u].z, 1.0f, x1[0u].z) * 0.5f;
  float _771 = _759 + (_557 * ((mad(_443.x, 1.0f, T3.SampleLevel(S1, _387, 0.0f).x) * 0.5f) - _759));
  float _772 = (_558 * ((mad(_449.y, 0.5f, mad(_443.y, 0.5f, T3.SampleLevel(S1, _391, 0.0f).y)) * 0.5f) - _760)) + _760;
  float _773 = (_559 * ((mad(_449.z, 1.0f, _373.z) * 0.5f) - _761)) + _761;
  float _780 = mad(_587, mad(mad(_425.x, 1.0f, T2.SampleLevel(S1, _387, 0.0f).x), 0.5f, -_771), _771);
  float _781 = mad(_588, mad(mad(_431.y, 0.5f, mad(_425.y, 0.5f, T2.SampleLevel(S1, _391, 0.0f).y)), 0.5f, -_772), _772);
  float _782 = mad(mad(mad(_431.z, 1.0f, _365.z), 0.5f, -_773), _589, _773);
  float2 _784 = float2(max(min(_278, CB0_m[18u].x), clamp(_278, CB0_m[18u].x, CB0_m[18u].z)), max(min(_279, CB0_m[18u].y), clamp(_279, CB0_m[18u].y, CB0_m[18u].w)));
  float4 _786 = T5.Sample(S1, _784);
  float4 _793 = T7.Sample(S1, _362);
  float _794 = _793.x;
  float _795 = _793.y;
  float _796 = _793.z;
  float4 _799 = T6.Sample(S1, _784);
  float _814;
  if (CB0_m[6u].w != 0.0f) {
    _814 = CB0_m[6u].w;
  } else {
    _814 = U0[2u].x;
  }
  float _819 = CB0_m[6u].y * CB0_m[6u].z;
  float _820 = _786.x / _819;
  float _821 = _786.y / _819;
  float _822 = _786.z / _819;
  float _825 = (_814 * 4.0f) / (_814 + 0.25f);
  float _829 = max(_814, 1.0000000031710768509710513471353e-30f);
  float _838 = 1.0f / ((_825 + _814) + 1.0f);
  float _854 = mad(_795 * _795, CB0_m[6u].x, (_838 * _781) + (mad(sqrt((_821 * _781) / _829), _825, _821) * _838));
  float _868 = (mad(_794 * _794, CB0_m[6u].x, (_838 * mad(_825, sqrt((_780 * _820) / _829), _820)) + (_780 * _838)) * CB0_m[15u].x) + (_854 * (CB0_m[15u].x - CB0_m[15u].y));
  float _869 = mad(_854, CB0_m[15u].y, 0.0f);
  float _870 = mad(mad(_796 * _796, CB0_m[6u].x, (_838 * _782) + (_838 * mad(sqrt((_822 * _782) / _829), _825, _822))), CB0_m[15u].z, 0.0f);
  float _894;
  float _895;
  float _896;
  if (CB0_m[4u].x > 0.0f) {
    float _876 = _786.w * CB0_m[4u].x;
    float _887 = T8.Sample(S2, float2(TEXCOORD1.x, TEXCOORD1.y)).y - 0.5f;
    _894 = max(mad(_876, _887, _870), 0.0f);
    _895 = max(mad(_876, _887, _869), 0.0f);
    _896 = max(mad(_876, _887, _868), 0.0f);
  } else {
    _894 = _870;
    _895 = _869;
    _896 = _868;
  }
  float2 _899 = float2(mad(_278, 2.0f, -1.0f), mad(_279, 2.0f, -1.0f));
  float _907 = clamp(mad(sqrt(dp2_f32(_899, _899)), CB0_m[4u].y, CB0_m[4u].z), 0.0f, 1.0f);
  float _908 = _907 * _907;
  float _911 = _908 * CB0_m[5u].w;
  float _913 = mad(-_908, CB0_m[5u].w, 1.0f);
  bool _933 = CB0_m[9u].x >= 0.0f;
  float _937 = _819 * max((_838 * (_911 * CB0_m[5u].x)) + (_913 * _896), 9.9999999747524270787835121154785e-07f);
  float _938 = _819 * max((_838 * (_911 * CB0_m[5u].y)) + (_913 * _895), 9.9999999747524270787835121154785e-07f);
  float _939 = _819 * max((_838 * (_911 * CB0_m[5u].z)) + (_913 * _894), 9.9999999747524270787835121154785e-07f);
  float _1015;
  float _1016;
  float _1017;
  if (CB0_m[8u].y >= 0.0f) {
    float _983;
    float _984;
    float _985;
    if (_279 < 0.20000000298023223876953125f) {
      float _951 = floor(mad(frac(mad(_276, 0.5f, 1.3333332538604736328125f)), 18.0f, 0.5f));
      float _970 = exp2(log2(clamp(mad(abs(mad(_951, 0.3333333432674407958984375f, -3.0f)), 1.0f, -1.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _971 = exp2(log2(clamp(mad(abs(mad(_951, 0.3333333432674407958984375f, -2.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _972 = exp2(log2(clamp(mad(abs(mad(_951, 0.3333333432674407958984375f, -4.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _974 = dp3_f32(float3(_970, _971, _972), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      float _979 = exp2(mad(_279, 100.0f, -10.0f));
      _983 = (_972 / _974) * _979;
      _984 = (_971 / _974) * _979;
      _985 = (_970 / _974) * _979;
    } else {
      _983 = _939;
      _984 = _938;
      _985 = _937;
    }
    float _1012;
    float _1013;
    float _1014;
    if (_279 > 0.800000011920928955078125f) {
      float _989 = mad(_277, 0.5f, -0.300000011920928955078125f);
      float _990 = _278 * 33.333332061767578125f;
      float _997;
      if (_989 > 0.0500000007450580596923828125f) {
        _997 = 0.0f;
      } else {
        _997 = _278;
      }
      float _1001;
      float _1002;
      float _1003;
      if (_989 > 0.100000001490116119384765625f) {
        _1001 = 0.0f;
        _1002 = _278;
        _1003 = 0.0f;
      } else {
        _1001 = _997;
        _1002 = _997;
        _1003 = _278;
      }
      float _1006;
      float _1007;
      float _1008;
      if (_989 > 0.1500000059604644775390625f) {
        _1006 = _278;
        _1007 = 0.0f;
        _1008 = 0.0f;
      } else {
        _1006 = _1001;
        _1007 = _1002;
        _1008 = _1003;
      }
      _1012 = _990 * _1006;
      _1013 = _990 * _1007;
      _1014 = _990 * _1008;
    } else {
      _1012 = _983;
      _1013 = _984;
      _1014 = _985;
    }
    _1015 = _1012;
    _1016 = _1013;
    _1017 = _1014;
  } else {
    _1015 = _939;
    _1016 = _938;
    _1017 = _937;
  }
  float _1053;
  float _1054;
  float _1055;

  float4 mHDRCompressionParam1 = CB0_m[12u];
  float4 mHDRCompressionParam2 = CB0_m[13u];
  float4 mHDRCompressionParam3 = CB0_m[14u];
  float4 mHDRCompressionControl = CB0_m[7u];
  float3 untonemapped = float3(_1015, _1016, _1017);
  float3 tonemapped;

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    mHDRCompressionParam2.z = 999.f;
    mHDRCompressionParam2.w = 999.f;
    mHDRCompressionParam1.x = 100.f;
  }
#endif

  if (mHDRCompressionControl.x > 0.5f) {
    _1053 = (mHDRCompressionParam2.z > _1015) ? mad(mHDRCompressionParam1.y, _1015, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _1015)));
    _1054 = (mHDRCompressionParam2.z > _1016) ? mad(mHDRCompressionParam1.y, _1016, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _1016)));
    _1055 = (mHDRCompressionParam2.z > _1017) ? mad(mHDRCompressionParam1.y, _1017, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _1017)));
  } else {
    _1053 = _1015;
    _1054 = _1016;
    _1055 = _1017;
  }

#if 1
  tonemapped = ToneMapForLUT(_1053, _1054, _1055);
#endif

  float _1078 = sqrt(mad((_799.x * CB0_m[0u].z) * CB0_m[1u].x, clamp(1.0f - _1055, 0.0f, 1.0f), _1055));
  float _1079 = sqrt(mad(clamp(1.0f - _1054, 0.0f, 1.0f), CB0_m[1u].y * (_799.y * CB0_m[0u].z), _1054));
  float _1080 = sqrt(mad(clamp(1.0f - _1053, 0.0f, 1.0f), CB0_m[1u].z * (_799.z * CB0_m[0u].z), _1053));
  float _1088 = mad(min(_1078, 1.0f), CB0_m[0u].x, CB0_m[0u].y);
  float _1089 = mad(CB0_m[0u].x, min(_1079, 1.0f), CB0_m[0u].y);
  float _1090 = mad(CB0_m[0u].x, min(_1080, 1.0f), CB0_m[0u].y);
  float _1113;
  float _1114;
  float _1115;
  if (!((_933 && (!(_1090 <= 1.0f))) || ((_933 && (!(_1088 <= 1.0f))) || ((!(_1089 <= 1.0f)) && _933)))) {
    float4 _1109 = T9.SampleLevel(S1, float3(_1088, _1089, _1090), 0.0f);
    _1113 = _1109.z;
    _1114 = _1109.y;
    _1115 = _1109.x;
  } else {
    _1113 = _1080;
    _1114 = _1079;
    _1115 = _1078;
  }
  float _1124 = clamp(mad(CB0_m[3u].w, _1115 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _1125 = clamp(mad(CB0_m[3u].w, _1114 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _1126 = clamp(mad(CB0_m[3u].w, _1113 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _1141 = (_1124 > 0.0f) ? exp2(CB0_m[11u].x * log2(_1124)) : 0.0f;
  float _1142 = (_1125 > 0.0f) ? exp2(CB0_m[11u].x * log2(_1125)) : 0.0f;
  float _1143 = (_1126 > 0.0f) ? exp2(CB0_m[11u].x * log2(_1126)) : 0.0f;
  float _1149 = min(mHDRCompressionParam1.x, _1141 * _1141);
  float _1150 = min(mHDRCompressionParam1.x, _1142 * _1142);
  float _1151 = min(mHDRCompressionParam1.x, _1143 * _1143);
  float _1185 = (mHDRCompressionParam2.w > _1149) ? ((_1149 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_1149 - mHDRCompressionParam2.y))));
  float _1186 = (mHDRCompressionParam2.w > _1150) ? ((_1150 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_1150 - mHDRCompressionParam2.y))));
  float _1187 = (mHDRCompressionParam2.w > _1151) ? ((_1151 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_1151 - mHDRCompressionParam2.y))));
  float _1219;
  float _1220;
  float _1221;
  if (mHDRCompressionControl.z != 5.0f) {
    _1219 = (mHDRCompressionParam2.z > _1187) ? mad(mHDRCompressionParam1.y, _1187, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _1187)));
    _1220 = (mHDRCompressionParam2.z > _1186) ? mad(mHDRCompressionParam1.y, _1186, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _1186)));
    _1221 = (mHDRCompressionParam2.z > _1185) ? mad(mHDRCompressionParam1.y, _1185, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _1185)));
  } else {
    _1219 = _1187;
    _1220 = _1186;
    _1221 = _1185;
  }
#if 1
  UpgradeToneMapApplyDisplayMapAndScale(untonemapped, tonemapped, _1219, _1220, _1221, CB0_m[14u].z);
#endif
  uint _1225 = uint(cvt_f32_i32(CB0_m[10u].w));
  float _1303;
  float _1304;
  float _1305;
  if (_1225 == 1u) {
    float _1235 = CB0_m[10u].x * log2(_1221);
    float _1236 = CB0_m[10u].x * log2(_1220);
    float _1237 = CB0_m[10u].x * log2(_1219);
    float _1238 = exp2(_1235);
    float _1239 = exp2(_1236);
    float _1240 = exp2(_1237);
    _1303 = (_1240 < 0.00310000008903443813323974609375f) ? (_1240 * 12.9200000762939453125f) : mad(exp2(_1237 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1304 = (_1239 < 0.00310000008903443813323974609375f) ? (_1239 * 12.9200000762939453125f) : mad(exp2(_1236 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1305 = (_1238 < 0.00310000008903443813323974609375f) ? (_1238 * 12.9200000762939453125f) : mad(exp2(_1235 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _1300;
    float _1301;
    float _1302;
    if (_1225 == 2u) {
      float3 _1262 = float3(_1221, _1220, _1219);
      float _1279 = exp2(CB0_m[10u].x * log2(CB0_m[10u].y * dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _1262)));
      float _1280 = exp2(CB0_m[10u].x * log2(CB0_m[10u].y * dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _1262)));
      float _1281 = exp2(CB0_m[10u].x * log2(CB0_m[10u].y * dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _1262)));
      _1300 = exp2(log2(mad(_1281, 18.8515625f, 0.8359375f) / mad(_1281, 18.6875f, 1.0f)) * 78.84375f);
      _1301 = exp2(log2(mad(_1280, 18.8515625f, 0.8359375f) / mad(_1280, 18.6875f, 1.0f)) * 78.84375f);
      _1302 = exp2(log2(mad(_1279, 18.8515625f, 0.8359375f) / mad(_1279, 18.6875f, 1.0f)) * 78.84375f);
    } else {
      _1300 = _1219;
      _1301 = _1220;
      _1302 = _1221;
    }
    _1303 = _1300;
    _1304 = _1301;
    _1305 = _1302;
  }
  SV_TARGET1 = dp3_f32(float3(_1305, _1304, _1303), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  SV_TARGET.x = _1305;
  SV_TARGET.y = _1304;
  SV_TARGET.z = _1303;
  SV_TARGET.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  TEXCOORD1 = stage_input.TEXCOORD1;
  TEXCOORD2 = stage_input.TEXCOORD2;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_TARGET = SV_TARGET;
  stage_output.SV_TARGET1 = SV_TARGET1;
  return stage_output;
}

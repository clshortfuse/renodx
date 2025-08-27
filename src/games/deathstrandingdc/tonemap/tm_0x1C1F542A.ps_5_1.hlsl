#include "../common.hlsli"

struct _564 {
  uint2 _m0;
  uint _m1;
};

static const float2 _47[5] = { 0.0f.xx, 0.0f.xx, 0.0f.xx, 0.0f.xx, 0.0f.xx };
static const float3 _52[5] = { 0.0f.xxx, 0.0f.xxx, 0.0f.xxx, 0.0f.xxx, 0.0f.xxx };
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

static float2 x0[5] = _47;
static float3 x1[5] = _52;

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
  float2 _247 = float2(_237 * CB0_m[3u].y, _238 * CB0_m[3u].z);
  bool _252 = CB0_m[3u].x != 0.0f;
  float _255 = log2(abs(_252 ? _237 : _238));
  float _271 = mad(CB0_m[2u].x, 2.0f, 1.0f);
  float _272 = mad(dp2_f32(_247, _247), CB0_m[2u].x, 1.0f) / _271;
  float _275 = mad(((exp2(_255 * CB0_m[2u].z) + exp2(_255 * CB0_m[2u].w)) * CB0_m[2u].y) * 0.5f, 1.0f - _272, _272);
  float _276 = _275 * _237;
  float _277 = _275 * _238;
  float _278 = mad(_276, 0.5f, 0.5f);
  float _279 = mad(_277, 0.5f, 0.5f);
  float _288 = mad(TEXCOORD2.x, 2.0f, -1.0f);
  float _289 = mad(TEXCOORD2.y, 2.0f, -1.0f);
  float _290 = mad(TEXCOORD2.z, 2.0f, -1.0f);
  float _291 = mad(TEXCOORD2.w, 2.0f, -1.0f);
  float2 _296 = float2(_288 * CB0_m[3u].y, _289 * CB0_m[3u].z);
  float _302 = log2(abs(_252 ? _288 : _289));
  float _303 = log2(abs(_252 ? _290 : _291));
  float _317 = mad(dp2_f32(_296, _296), CB0_m[2u].x, 1.0f) / _271;
  float _321 = mad(((exp2(_302 * CB0_m[2u].z) + exp2(CB0_m[2u].w * _302)) * CB0_m[2u].y) * 0.5f, 1.0f - _317, _317);
  float _324 = mad(_288 * _321, 0.5f, 0.5f);
  float _325 = mad(_321 * _289, 0.5f, 0.5f);
  float2 _326 = float2(_290 * CB0_m[3u].y, _291 * CB0_m[3u].z);
  float _329 = mad(dp2_f32(_326, _326), CB0_m[2u].x, 1.0f) / _271;
  float _331 = mad(1.0f - _329, ((exp2(CB0_m[2u].w * _303) + exp2(_303 * CB0_m[2u].z)) * CB0_m[2u].y) * 0.5f, _329);
  float _334 = mad(_331 * _290, 0.5f, 0.5f);
  float _335 = mad(_331 * _291, 0.5f, 0.5f);
  float2 _362 = float2(max(min(_278, CB0_m[17u].x), clamp(_278, CB0_m[17u].x, CB0_m[17u].z)), max(clamp(_279, CB0_m[17u].y, CB0_m[17u].w), min(_279, CB0_m[17u].y)));
  float4 _365 = T2.Sample(S1, _362);
  float4 _369 = T4.Sample(S1, _362);
  float _370 = _369.x;
  float4 _373 = T3.Sample(S1, _362);
  float2 _387 = float2(max(min(_324, CB0_m[17u].x), clamp(_324, CB0_m[17u].x, CB0_m[17u].z)), max(min(_325, CB0_m[17u].y), clamp(_325, CB0_m[17u].y, CB0_m[17u].w)));
  float4 _389 = T4.SampleLevel(S1, _387, 0.0f);
  float _390 = _389.x;
  float2 _391 = float2(max(min(_334, CB0_m[17u].x), clamp(_334, CB0_m[17u].x, CB0_m[17u].z)), max(min(_335, CB0_m[17u].y), clamp(_335, CB0_m[17u].y, CB0_m[17u].w)));
  float4 _393 = T4.SampleLevel(S1, _391, 0.0f);
  float _394 = _393.x;
  float2 _408 = float2(_278, _279);
  float4 _415 = T1.Sample(S0, _408);
  float _416 = _415.x;
  float2 _417 = float2(_324, _325);
  float4 _419 = T1.SampleLevel(S0, _417, 0.0f);
  float _420 = _419.x;
  float2 _421 = float2(_334, _335);
  float4 _423 = T1.SampleLevel(S0, _421, 0.0f);
  float _424 = _423.x;
  float _449 = mad(max(_390, clamp(_420 * (-0.25f), 0.0f, 1.0f)) - _390, float(_390 > 0.0f), _390);
  float _450 = mad(float(_394 > 0.0f), max(_394, clamp(_424 * (-0.25f), 0.0f, 1.0f)) - _394, _394);
  float _451 = mad(float(_370 > 0.0f), max(_370, clamp(_416 * (-0.25f), 0.0f, 1.0f)) - _370, _370);
  float _463 = min((abs(_420) * CB0_m[19u].x) * 24.0f, 1.0f);
  float _464 = min((abs(_424) * CB0_m[19u].x) * 24.0f, 1.0f);
  float _469 = clamp(_420 * 4.80000019073486328125f, 0.0f, 1.0f);
  float _470 = clamp(_424 * 4.80000019073486328125f, 0.0f, 1.0f);
  float _471 = clamp(_416 * 4.80000019073486328125f, 0.0f, 1.0f);
  float _475 = clamp(_420 * (-4.80000019073486328125f), 0.0f, 1.0f);
  float _476 = clamp(_424 * (-4.80000019073486328125f), 0.0f, 1.0f);
  float _477 = clamp(_416 * (-4.80000019073486328125f), 0.0f, 1.0f);
  float _499 = mad(clamp(((_420 + _449) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), float(_449 > 0.0f) - _475, _475);
  float _500 = mad(float(_450 > 0.0f) - _476, clamp(((_424 + _450) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), _476);
  float _501 = mad(clamp(((_416 + _451) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), float(_451 > 0.0f) - _477, _477);
  x0[0u].x = _278;
  x0[0u].y = _279;
  x0[1u].x = _324;
  x0[1u].y = _325;
  x0[2u].x = _334;
  x0[2u].y = _335;
  x0[3u].x = (_324 + _334) * 0.5f;
  x0[3u].y = (_335 + _325) * 0.5f;
  x1[0u].z = T0.Sample(S1, _408).z;
  x1[1u].x = T0.SampleLevel(S1, _417, 0.0f).x;
  x1[2u].y = T0.SampleLevel(S1, _421, 0.0f).y;
  if (((((_499 < 1.0f) || (_500 < 1.0f)) || (_501 < 1.0f)) || (((_469 < 1.0f) || (_470 < 1.0f)) || (_471 < 1.0f))) && (((_463 > 0.0f) || (_464 > 0.0f)) || (min((abs(_416) * CB0_m[19u].x) * 24.0f, 1.0f) > 0.0f))) {
    uint _553;
    uint _552 = 0u;
    for (;;) {
      if (int(_552) >= 3) {
        break;
      }
      uint _561;
      spvTextureSize(T0, 0u, _561);
      bool _562 = _561 > 0u;
      uint _563_dummy_parameter;
      _564 _565 = { spvTextureSize(T0, 0u, _563_dummy_parameter), 1u };
      float _572 = _463 / float(_562 ? _565._m0.x : 0u);
      float _573 = _464 / float(_562 ? _565._m0.y : 0u);
      uint _574 = min(_552, 4u);
      float _582;
      float _585;
      float _587;
      float _589;
      _582 = 0.0f;
      _585 = 0.0f;
      _587 = 0.0f;
      _589 = 0.0f;
      float _583;
      float _586;
      float _588;
      float _590;
      uint _592;
      uint _591 = 0u;
      for (;;) {
        if (_591 == 9u) {
          break;
        }
        uint _598 = min(_591, 9u);
        float _607 = mad(_572, _179[_598].x, x0[_574].x);
        float _608 = mad(_573, _179[_598].y, x0[_574].y);
        float4 _623 = T0.SampleLevel(S1, float2(max(min(_607, CB0_m[16u].x), clamp(_607, CB0_m[16u].x, CB0_m[16u].z)), max(clamp(_608, CB0_m[16u].y, CB0_m[16u].w), min(_608, CB0_m[16u].y))), 0.0f);
        float _624 = _623.x;
        float _632 = asfloat(2129859010u - asuint(dp3_f32(float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f), float3(_624, _623.yz)) + 0.5f));
        _590 = mad(_624, _632, _589);
        _588 = mad(_623.y, _632, _587);
        _586 = mad(_623.z, _632, _585);
        _583 = _632 + _582;
        _592 = _591 + 1u;
        _582 = _583;
        _585 = _586;
        _587 = _588;
        _589 = _590;
        _591 = _592;
        continue;
      }
      if (_552 < 4u) {
        x1[_552].x = _589 / _582;
        x1[_552].y = _587 / _582;
        x1[_552].z = _585 / _582;
      }
      _553 = _552 + 1u;
      _552 = _553;
      continue;
    }
  }
  float _654 = mad(_469, T3.SampleLevel(S1, _387, 0.0f).x - x1[1u].x, x1[1u].x);
  float _655 = mad(_470, T3.SampleLevel(S1, _391, 0.0f).y - x1[2u].y, x1[2u].y);
  float _656 = mad(_471, _373.z - x1[0u].z, x1[0u].z);
  float _660 = mad(_499, T2.SampleLevel(S1, _387, 0.0f).x - _654, _654);
  float _661 = mad(T2.SampleLevel(S1, _391, 0.0f).y - _655, _500, _655);
  float _662 = mad(_501, _365.z - _656, _656);
  float2 _664 = float2(max(min(CB0_m[18u].x, _278), clamp(CB0_m[18u].x, _278, CB0_m[18u].z)), max(min(_279, CB0_m[18u].y), clamp(_279, CB0_m[18u].y, CB0_m[18u].w)));
  float4 _666 = T5.Sample(S1, _664);
  float4 _673 = T7.Sample(S1, _362);
  float _674 = _673.x;
  float _675 = _673.y;
  float _676 = _673.z;
  float4 _679 = T6.Sample(S1, _664);
  float _694;
  if (CB0_m[6u].w != 0.0f) {
    _694 = CB0_m[6u].w;
  } else {
    _694 = U0[2u].x;
  }
  float _699 = CB0_m[6u].y * CB0_m[6u].z;
  float _700 = _666.x / _699;
  float _701 = _666.y / _699;
  float _702 = _666.z / _699;
  float _705 = (_694 * 4.0f) / (_694 + 0.25f);
  float _709 = max(_694, 1.0000000031710768509710513471353e-30f);
  float _718 = 1.0f / ((_705 + _694) + 1.0f);
  float _734 = mad(_675 * _675, CB0_m[6u].x, (_661 * _718) + (_718 * mad(sqrt((_701 * _661) / _709), _705, _701)));
  float _748 = (mad(_674 * _674, CB0_m[6u].x, (_718 * mad(_705, sqrt((_660 * _700) / _709), _700)) + (_660 * _718)) * CB0_m[15u].x) + ((CB0_m[15u].x - CB0_m[15u].y) * _734);
  float _749 = mad(_734, CB0_m[15u].y, 0.0f);
  float _750 = mad(mad(_676 * _676, CB0_m[6u].x, (_662 * _718) + (_718 * mad(sqrt((_662 * _702) / _709), _705, _702))), CB0_m[15u].z, 0.0f);
  float _774;
  float _775;
  float _776;
  if (CB0_m[4u].x > 0.0f) {
    float _756 = _666.w * CB0_m[4u].x;
    float _767 = T8.Sample(S2, float2(TEXCOORD1.x, TEXCOORD1.y)).y - 0.5f;
    _774 = max(mad(_756, _767, _750), 0.0f);
    _775 = max(mad(_756, _767, _749), 0.0f);
    _776 = max(mad(_756, _767, _748), 0.0f);
  } else {
    _774 = _750;
    _775 = _749;
    _776 = _748;
  }
  float2 _779 = float2(mad(_278, 2.0f, -1.0f), mad(_279, 2.0f, -1.0f));
  float _787 = clamp(mad(sqrt(dp2_f32(_779, _779)), CB0_m[4u].y, CB0_m[4u].z), 0.0f, 1.0f);
  float _788 = _787 * _787;
  float _791 = _788 * CB0_m[5u].w;
  float _793 = mad(-_788, CB0_m[5u].w, 1.0f);
  bool _813 = CB0_m[9u].x >= 0.0f;
  float _817 = _699 * max((_718 * (_791 * CB0_m[5u].x)) + (_793 * _776), 9.9999999747524270787835121154785e-07f);
  float _818 = _699 * max((_793 * _775) + (_718 * (_791 * CB0_m[5u].y)), 9.9999999747524270787835121154785e-07f);
  float _819 = _699 * max((_793 * _774) + (_718 * (_791 * CB0_m[5u].z)), 9.9999999747524270787835121154785e-07f);
  float _895;
  float _896;
  float _897;
  if (CB0_m[8u].y >= 0.0f) {
    float _863;
    float _864;
    float _865;
    if (_279 < 0.20000000298023223876953125f) {
      float _831 = floor(mad(frac(mad(_276, 0.5f, 1.3333332538604736328125f)), 18.0f, 0.5f));
      float _850 = exp2(log2(clamp(mad(abs(mad(_831, 0.3333333432674407958984375f, -3.0f)), 1.0f, -1.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _851 = exp2(log2(clamp(mad(abs(mad(_831, 0.3333333432674407958984375f, -2.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _852 = exp2(log2(clamp(mad(abs(mad(_831, 0.3333333432674407958984375f, -4.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _854 = dp3_f32(float3(_850, _851, _852), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      float _859 = exp2(mad(_279, 100.0f, -10.0f));
      _863 = (_852 / _854) * _859;
      _864 = (_851 / _854) * _859;
      _865 = (_850 / _854) * _859;
    } else {
      _863 = _819;
      _864 = _818;
      _865 = _817;
    }
    float _892;
    float _893;
    float _894;
    if (_279 > 0.800000011920928955078125f) {
      float _869 = mad(_277, 0.5f, -0.300000011920928955078125f);
      float _870 = _278 * 33.333332061767578125f;
      float _877;
      if (_869 > 0.0500000007450580596923828125f) {
        _877 = 0.0f;
      } else {
        _877 = _278;
      }
      float _881;
      float _882;
      float _883;
      if (_869 > 0.100000001490116119384765625f) {
        _881 = 0.0f;
        _882 = _278;
        _883 = 0.0f;
      } else {
        _881 = _877;
        _882 = _877;
        _883 = _278;
      }
      float _886;
      float _887;
      float _888;
      if (_869 > 0.1500000059604644775390625f) {
        _886 = _278;
        _887 = 0.0f;
        _888 = 0.0f;
      } else {
        _886 = _881;
        _887 = _882;
        _888 = _883;
      }
      _892 = _870 * _886;
      _893 = _870 * _887;
      _894 = _870 * _888;
    } else {
      _892 = _863;
      _893 = _864;
      _894 = _865;
    }
    _895 = _892;
    _896 = _893;
    _897 = _894;
  } else {
    _895 = _819;
    _896 = _818;
    _897 = _817;
  }
  float _933;
  float _934;
  float _935;

  float4 mHDRCompressionParam1 = CB0_m[12u];
  float4 mHDRCompressionParam2 = CB0_m[13u];
  float4 mHDRCompressionParam3 = CB0_m[14u];
  float4 mHDRCompressionControl = CB0_m[7u];

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    mHDRCompressionParam2.z = renodx::math::FLT32_MAX;
    mHDRCompressionParam2.w = renodx::math::FLT32_MAX;
    mHDRCompressionParam1.x = renodx::math::FLT32_MAX;
  }
#endif
  if (mHDRCompressionControl.x > 0.5f) {
    _933 = (mHDRCompressionParam2.z > _895) ? mad(mHDRCompressionParam1.y, _895, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _895)));
    _934 = (mHDRCompressionParam2.z > _896) ? mad(mHDRCompressionParam1.y, _896, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _896)));
    _935 = (mHDRCompressionParam2.z > _897) ? mad(mHDRCompressionParam1.y, _897, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _897)));
  } else {
    _933 = _895;
    _934 = _896;
    _935 = _897;
  }

#if 1  // account for flipped channels
  float3 untonemapped, tonemapped;
  tonemapped = ToneMapForLUT(_935, _934, _933, untonemapped);
#endif

  float _958 = sqrt(mad((_679.x * CB0_m[0u].z) * CB0_m[1u].x, clamp(1.0f - _935, 0.0f, 1.0f), _935));
  float _959 = sqrt(mad(clamp(1.0f - _934, 0.0f, 1.0f), CB0_m[1u].y * (_679.y * CB0_m[0u].z), _934));
  float _960 = sqrt(mad(clamp(1.0f - _933, 0.0f, 1.0f), CB0_m[1u].z * (_679.z * CB0_m[0u].z), _933));
  float _968 = mad(min(_958, 1.0f), CB0_m[0u].x, CB0_m[0u].y);
  float _969 = mad(CB0_m[0u].x, min(_959, 1.0f), CB0_m[0u].y);
  float _970 = mad(CB0_m[0u].x, min(_960, 1.0f), CB0_m[0u].y);
  float _993;
  float _994;
  float _995;
  if (!((_813 && (!(_970 <= 1.0f))) || ((_813 && (!(_968 <= 1.0f))) || (_813 && (!(_969 <= 1.0f)))))) {
    float4 _989 = T9.SampleLevel(S1, float3(_968, _969, _970), 0.0f);
    _993 = _989.z;
    _994 = _989.y;
    _995 = _989.x;
  } else {
    _993 = _960;
    _994 = _959;
    _995 = _958;
  }
  float _1004 = clamp(mad(CB0_m[3u].w, _995 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _1005 = clamp(mad(CB0_m[3u].w, _994 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _1006 = clamp(mad(CB0_m[3u].w, _993 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _1021 = (_1004 > 0.0f) ? exp2(CB0_m[11u].x * log2(_1004)) : 0.0f;
  float _1022 = (_1005 > 0.0f) ? exp2(CB0_m[11u].x * log2(_1005)) : 0.0f;
  float _1023 = (_1006 > 0.0f) ? exp2(CB0_m[11u].x * log2(_1006)) : 0.0f;
  float _1029 = min(mHDRCompressionParam1.x, _1021 * _1021);
  float _1030 = min(mHDRCompressionParam1.x, _1022 * _1022);
  float _1031 = min(mHDRCompressionParam1.x, _1023 * _1023);
  float _1065 = (mHDRCompressionParam2.w > _1029) ? ((_1029 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_1029 - mHDRCompressionParam2.y))));
  float _1066 = (mHDRCompressionParam2.w > _1030) ? ((_1030 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_1030 - mHDRCompressionParam2.y))));
  float _1067 = (mHDRCompressionParam2.w > _1031) ? ((_1031 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_1031 - mHDRCompressionParam2.y))));
  float _1099;
  float _1100;
  float _1101;
  if (mHDRCompressionControl.z != 5.0f) {
    _1099 = (mHDRCompressionParam2.z > _1067) ? mad(mHDRCompressionParam1.y, _1067, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _1067)));
    _1100 = (mHDRCompressionParam2.z > _1066) ? mad(mHDRCompressionParam1.y, _1066, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _1066)));
    _1101 = (mHDRCompressionParam2.z > _1065) ? mad(mHDRCompressionParam1.y, _1065, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _1065)));
  } else {
    _1099 = _1067;
    _1100 = _1066;
    _1101 = _1065;
  }
#if 1  // account for flipped channels
  UpgradeToneMapApplyDisplayMapAndScale(untonemapped, tonemapped, _1101, _1100, _1099);
#endif
  uint _1105 = uint(cvt_f32_i32(CB0_m[10u].w));
  float _1183;
  float _1184;
  float _1185;
  if (_1105 == 1u) {
    float _1115 = CB0_m[10u].x * log2(_1101);
    float _1116 = CB0_m[10u].x * log2(_1100);
    float _1117 = CB0_m[10u].x * log2(_1099);
    float _1118 = exp2(_1115);
    float _1119 = exp2(_1116);
    float _1120 = exp2(_1117);
    _1183 = (_1120 < 0.00310000008903443813323974609375f) ? (_1120 * 12.9200000762939453125f) : mad(exp2(_1117 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1184 = (_1119 < 0.00310000008903443813323974609375f) ? (_1119 * 12.9200000762939453125f) : mad(exp2(_1116 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1185 = (_1118 < 0.00310000008903443813323974609375f) ? (_1118 * 12.9200000762939453125f) : mad(exp2(_1115 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _1180;
    float _1181;
    float _1182;
    if (_1105 == 2u) {
      float3 _1142 = float3(_1101, _1100, _1099);
      float _1159 = exp2(CB0_m[10u].x * log2(CB0_m[10u].y * dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _1142)));
      float _1160 = exp2(CB0_m[10u].x * log2(CB0_m[10u].y * dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _1142)));
      float _1161 = exp2(CB0_m[10u].x * log2(CB0_m[10u].y * dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _1142)));
      _1180 = exp2(log2(mad(_1161, 18.8515625f, 0.8359375f) / mad(_1161, 18.6875f, 1.0f)) * 78.84375f);
      _1181 = exp2(log2(mad(_1160, 18.8515625f, 0.8359375f) / mad(_1160, 18.6875f, 1.0f)) * 78.84375f);
      _1182 = exp2(log2(mad(_1159, 18.8515625f, 0.8359375f) / mad(_1159, 18.6875f, 1.0f)) * 78.84375f);
    } else {
      _1180 = _1099;
      _1181 = _1100;
      _1182 = _1101;
    }
    _1183 = _1180;
    _1184 = _1181;
    _1185 = _1182;
  }
  SV_TARGET1 = dp3_f32(float3(_1185, _1184, _1183), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  SV_TARGET.x = _1185;
  SV_TARGET.y = _1184;
  SV_TARGET.z = _1183;
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

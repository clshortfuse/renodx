#include "../common.hlsli"

struct _475 {
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

float dp3_f32(float3 a, float3 b) {
  precise float _221 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _221));
}

float dp2_f32(float2 a, float2 b) {
  precise float _209 = a.x * b.x;
  return mad(a.y, b.y, _209);
}

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

void frag_main() {
  float2 _264 = float2(max(clamp(TEXCOORD.x, CB0_m[17u].x, CB0_m[17u].z), min(TEXCOORD.x, CB0_m[17u].x)), max(min(TEXCOORD.y, CB0_m[17u].y), clamp(TEXCOORD.y, CB0_m[17u].y, CB0_m[17u].w)));
  float4 _267 = T2.Sample(S1, _264);
  float4 _271 = T4.Sample(S1, _264);
  float _272 = _271.x;
  float4 _275 = T3.Sample(S1, _264);
  float2 _297 = float2(max(min(TEXCOORD2.x, CB0_m[17u].x), clamp(TEXCOORD2.x, CB0_m[17u].x, CB0_m[17u].z)), max(min(TEXCOORD2.y, CB0_m[17u].y), clamp(TEXCOORD2.y, CB0_m[17u].y, CB0_m[17u].w)));
  float4 _299 = T4.SampleLevel(S1, _297, 0.0f);
  float _300 = _299.x;
  float2 _301 = float2(max(min(TEXCOORD2.z, CB0_m[17u].x), clamp(TEXCOORD2.z, CB0_m[17u].x, CB0_m[17u].z)), max(min(TEXCOORD2.w, CB0_m[17u].y), clamp(TEXCOORD2.w, CB0_m[17u].y, CB0_m[17u].w)));
  float4 _303 = T4.SampleLevel(S1, _301, 0.0f);
  float _304 = _303.x;
  float2 _318 = float2(TEXCOORD.x, TEXCOORD.y);
  float4 _325 = T1.Sample(S0, _318);
  float _326 = _325.x;
  float2 _327 = float2(TEXCOORD2.x, TEXCOORD2.y);
  float4 _329 = T1.SampleLevel(S0, _327, 0.0f);
  float _330 = _329.x;
  float2 _331 = float2(TEXCOORD2.z, TEXCOORD2.w);
  float4 _333 = T1.SampleLevel(S0, _331, 0.0f);
  float _334 = _333.x;
  float _359 = mad(max(_300, clamp(_330 * (-0.25f), 0.0f, 1.0f)) - _300, float(_300 > 0.0f), _300);
  float _360 = mad(float(_304 > 0.0f), max(_304, clamp(_334 * (-0.25f), 0.0f, 1.0f)) - _304, _304);
  float _361 = mad(float(_272 > 0.0f), max(_272, clamp(_326 * (-0.25f), 0.0f, 1.0f)) - _272, _272);
  float _374 = min((abs(_330) * CB0_m[19u].x) * 24.0f, 1.0f);
  float _375 = min((abs(_334) * CB0_m[19u].x) * 24.0f, 1.0f);
  float _380 = clamp(_330 * 4.80000019073486328125f, 0.0f, 1.0f);
  float _381 = clamp(_334 * 4.80000019073486328125f, 0.0f, 1.0f);
  float _382 = clamp(_326 * 4.80000019073486328125f, 0.0f, 1.0f);
  float _386 = clamp(_330 * (-4.80000019073486328125f), 0.0f, 1.0f);
  float _387 = clamp(_334 * (-4.80000019073486328125f), 0.0f, 1.0f);
  float _388 = clamp(_326 * (-4.80000019073486328125f), 0.0f, 1.0f);
  float _410 = mad(clamp(((_330 + _359) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), float(_359 > 0.0f) - _386, _386);
  float _411 = mad(float(_360 > 0.0f) - _387, clamp(((_334 + _360) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), _387);
  float _412 = mad(clamp(((_326 + _361) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), float(_361 > 0.0f) - _388, _388);
  x0[0u].x = TEXCOORD.x;
  x0[0u].y = TEXCOORD.y;
  x0[1u].x = TEXCOORD2.x;
  x0[1u].y = TEXCOORD2.y;
  x0[2u].x = TEXCOORD2.z;
  x0[2u].y = TEXCOORD2.w;
  x0[3u].x = (TEXCOORD2.x + TEXCOORD2.z) * 0.5f;
  x0[3u].y = (TEXCOORD2.y + TEXCOORD2.w) * 0.5f;
  x1[0u].z = T0.Sample(S1, _318).z;
  x1[1u].x = T0.SampleLevel(S1, _327, 0.0f).x;
  x1[2u].y = T0.SampleLevel(S1, _331, 0.0f).y;
  if (((((_410 < 1.0f) || (_411 < 1.0f)) || (_412 < 1.0f)) || (((_380 < 1.0f) || (_381 < 1.0f)) || (_382 < 1.0f))) && ((min((abs(_326) * CB0_m[19u].x) * 24.0f, 1.0f) > 0.0f) || ((_374 > 0.0f) || (_375 > 0.0f)))) {
    uint _464;
    uint _463 = 0u;
    for (;;) {
      if (int(_463) >= 3) {
        break;
      }
      uint _472;
      spvTextureSize(T0, 0u, _472);
      bool _473 = _472 > 0u;
      uint _474_dummy_parameter;
      _475 _476 = { spvTextureSize(T0, 0u, _474_dummy_parameter), 1u };
      float _483 = _374 / float(_473 ? _476._m0.x : 0u);
      float _484 = _375 / float(_473 ? _476._m0.y : 0u);
      uint _485 = min(_463, 4u);
      float _493;
      float _496;
      float _498;
      float _500;
      _493 = 0.0f;
      _496 = 0.0f;
      _498 = 0.0f;
      _500 = 0.0f;
      float _494;
      float _497;
      float _499;
      float _501;
      uint _503;
      uint _502 = 0u;
      for (;;) {
        if (_502 == 9u) {
          break;
        }
        uint _509 = min(_502, 9u);
        float _518 = mad(_483, _179[_509].x, x0[_485].x);
        float _519 = mad(_484, _179[_509].y, x0[_485].y);
        float4 _534 = T0.SampleLevel(S1, float2(max(min(_518, CB0_m[16u].x), clamp(_518, CB0_m[16u].x, CB0_m[16u].z)), max(clamp(_519, CB0_m[16u].y, CB0_m[16u].w), min(_519, CB0_m[16u].y))), 0.0f);
        float _535 = _534.x;
        float _543 = asfloat(2129859010u - asuint(dp3_f32(float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f), float3(_535, _534.yz)) + 0.5f));
        _501 = mad(_535, _543, _500);
        _499 = mad(_534.y, _543, _498);
        _497 = mad(_534.z, _543, _496);
        _494 = _543 + _493;
        _503 = _502 + 1u;
        _493 = _494;
        _496 = _497;
        _498 = _499;
        _500 = _501;
        _502 = _503;
        continue;
      }
      if (_463 < 4u) {
        x1[_463].x = _500 / _493;
        x1[_463].y = _498 / _493;
        x1[_463].z = _496 / _493;
      }
      _464 = _463 + 1u;
      _463 = _464;
      continue;
    }
  }
  float _565 = mad(_380, T3.SampleLevel(S1, _297, 0.0f).x - x1[1u].x, x1[1u].x);
  float _566 = mad(_381, T3.SampleLevel(S1, _301, 0.0f).y - x1[2u].y, x1[2u].y);
  float _567 = mad(_382, _275.z - x1[0u].z, x1[0u].z);
  float _571 = mad(_410, T2.SampleLevel(S1, _297, 0.0f).x - _565, _565);
  float _572 = mad(T2.SampleLevel(S1, _301, 0.0f).y - _566, _411, _566);
  float _573 = mad(_412, _267.z - _567, _567);
  float2 _575 = float2(max(min(TEXCOORD.x, CB0_m[18u].x), clamp(TEXCOORD.x, CB0_m[18u].x, CB0_m[18u].z)), max(clamp(TEXCOORD.y, CB0_m[18u].y, CB0_m[18u].w), min(TEXCOORD.y, CB0_m[18u].y)));
  float4 _577 = T5.Sample(S1, _575);
  float4 _584 = T7.Sample(S1, _264);
  float _585 = _584.x;
  float _586 = _584.y;
  float _587 = _584.z;
  float4 _590 = T6.Sample(S1, _575);
  float _605;
  if (CB0_m[6u].w != 0.0f) {
    _605 = CB0_m[6u].w;
  } else {
    _605 = U0[2u].x;
  }
  float _610 = CB0_m[6u].y * CB0_m[6u].z;
  float _611 = _577.x / _610;
  float _612 = _577.y / _610;
  float _613 = _577.z / _610;
  float _616 = (_605 * 4.0f) / (_605 + 0.25f);
  float _620 = max(_605, 1.0000000031710768509710513471353e-30f);
  float _629 = 1.0f / ((_616 + _605) + 1.0f);
  float _645 = mad(_586 * _586, CB0_m[6u].x, (mad(sqrt((_612 * _572) / _620), _616, _612) * _629) + (_572 * _629));
  float _659 = (mad(_585 * _585, CB0_m[6u].x, (_629 * mad(_616, sqrt((_571 * _611) / _620), _611)) + (_571 * _629)) * CB0_m[15u].x) + (_645 * (CB0_m[15u].x - CB0_m[15u].y));
  float _660 = mad(CB0_m[15u].y, _645, 0.0f);
  float _661 = mad(mad(_587 * _587, CB0_m[6u].x, (_573 * _629) + (mad(sqrt((_613 * _573) / _620), _616, _613) * _629)), CB0_m[15u].z, 0.0f);
  float _685;
  float _686;
  float _687;
  if (CB0_m[4u].x > 0.0f) {
    float _667 = _577.w * CB0_m[4u].x;
    float _678 = T8.Sample(S2, float2(TEXCOORD1.x, TEXCOORD1.y)).y - 0.5f;
    _685 = max(mad(_667, _678, _661), 0.0f);
    _686 = max(mad(_667, _678, _660), 0.0f);
    _687 = max(mad(_667, _678, _659), 0.0f);
  } else {
    _685 = _661;
    _686 = _660;
    _687 = _659;
  }
  float2 _690 = float2(mad(TEXCOORD.x, 2.0f, -1.0f), mad(TEXCOORD.y, 2.0f, -1.0f));
  float _698 = clamp(mad(sqrt(dp2_f32(_690, _690)), CB0_m[4u].y, CB0_m[4u].z), 0.0f, 1.0f);
  float _699 = _698 * _698;
  float _702 = _699 * CB0_m[5u].w;
  float _704 = mad(-_699, CB0_m[5u].w, 1.0f);
  bool _724 = CB0_m[9u].x >= 0.0f;
  float _728 = _610 * max((_629 * (CB0_m[5u].x * _702)) + (_704 * _687), 9.9999999747524270787835121154785e-07f);
  float _729 = _610 * max((_704 * _686) + (_629 * (CB0_m[5u].y * _702)), 9.9999999747524270787835121154785e-07f);
  float _730 = _610 * max((_704 * _685) + (_629 * (CB0_m[5u].z * _702)), 9.9999999747524270787835121154785e-07f);
  float _806;
  float _807;
  float _808;
  if (CB0_m[8u].y >= 0.0f) {
    float _774;
    float _775;
    float _776;
    if (TEXCOORD.y < 0.20000000298023223876953125f) {
      float _742 = floor(mad(frac(TEXCOORD.x + 0.833333313465118408203125f), 18.0f, 0.5f));
      float _761 = exp2(log2(clamp(mad(abs(mad(_742, 0.3333333432674407958984375f, -3.0f)), 1.0f, -1.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _762 = exp2(log2(clamp(mad(abs(mad(_742, 0.3333333432674407958984375f, -2.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _763 = exp2(log2(clamp(mad(abs(mad(_742, 0.3333333432674407958984375f, -4.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _765 = dp3_f32(float3(_761, _762, _763), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      float _770 = exp2(mad(TEXCOORD.y, 100.0f, -10.0f));
      _774 = (_763 / _765) * _770;
      _775 = (_762 / _765) * _770;
      _776 = (_761 / _765) * _770;
    } else {
      _774 = _730;
      _775 = _729;
      _776 = _728;
    }
    float _803;
    float _804;
    float _805;
    if (TEXCOORD.y > 0.800000011920928955078125f) {
      float _780 = TEXCOORD.y - 0.800000011920928955078125f;
      float _781 = TEXCOORD.x * 33.333332061767578125f;
      float _788;
      if (_780 > 0.0500000007450580596923828125f) {
        _788 = 0.0f;
      } else {
        _788 = TEXCOORD.x;
      }
      float _792;
      float _793;
      float _794;
      if (_780 > 0.100000001490116119384765625f) {
        _792 = 0.0f;
        _793 = TEXCOORD.x;
        _794 = 0.0f;
      } else {
        _792 = _788;
        _793 = _788;
        _794 = TEXCOORD.x;
      }
      float _797;
      float _798;
      float _799;
      if (_780 > 0.1500000059604644775390625f) {
        _797 = TEXCOORD.x;
        _798 = 0.0f;
        _799 = 0.0f;
      } else {
        _797 = _792;
        _798 = _793;
        _799 = _794;
      }
      _803 = _781 * _797;
      _804 = _781 * _798;
      _805 = _781 * _799;
    } else {
      _803 = _774;
      _804 = _775;
      _805 = _776;
    }
    _806 = _803;
    _807 = _804;
    _808 = _805;
  } else {
    _806 = _730;
    _807 = _729;
    _808 = _728;
  }
  float _844;
  float _845;
  float _846;

  float4 mHDRCompressionParam1 = CB0_m[12u];
  float4 mHDRCompressionParam2 = CB0_m[13u];
  float4 mHDRCompressionParam3 = CB0_m[14u];
  float4 mHDRCompressionControl = CB0_m[7u];
  float3 untonemapped = float3(_806, _807, _808);
  float3 tonemapped;

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    mHDRCompressionParam2.z = 999.f;
    mHDRCompressionParam2.w = 999.f;
    mHDRCompressionParam1.x = 100.f;
  }
#endif

  if (mHDRCompressionControl.x > 0.5f) {
    _844 = (_806 < mHDRCompressionParam2.z) ? mad(mHDRCompressionParam1.y, _806, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _806)));
    _845 = (_807 < mHDRCompressionParam2.z) ? mad(mHDRCompressionParam1.y, _807, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _807)));
    _846 = (_808 < mHDRCompressionParam2.z) ? mad(mHDRCompressionParam1.y, _808, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _808)));
  } else {
    _844 = _806;
    _845 = _807;
    _846 = _808;
  }

#if 1
  tonemapped = ToneMapForLUT(_844, _845, _846);
#endif

  float _869 = sqrt(mad((_590.x * CB0_m[0u].z) * CB0_m[1u].x, clamp(1.0f - _846, 0.0f, 1.0f), _846));
  float _870 = sqrt(mad(clamp(1.0f - _845, 0.0f, 1.0f), CB0_m[1u].y * (_590.y * CB0_m[0u].z), _845));
  float _871 = sqrt(mad(clamp(1.0f - _844, 0.0f, 1.0f), CB0_m[1u].z * (_590.z * CB0_m[0u].z), _844));
  float _879 = mad(min(_869, 1.0f), CB0_m[0u].x, CB0_m[0u].y);
  float _880 = mad(CB0_m[0u].x, min(_870, 1.0f), CB0_m[0u].y);
  float _881 = mad(CB0_m[0u].x, min(_871, 1.0f), CB0_m[0u].y);
  float _904;
  float _905;
  float _906;
  if (!((_724 && (!(_881 <= 1.0f))) || ((_724 && (!(_879 <= 1.0f))) || (_724 && (!(_880 <= 1.0f)))))) {
    float4 _900 = T9.SampleLevel(S1, float3(_879, _880, _881), 0.0f);
    _904 = _900.z;
    _905 = _900.y;
    _906 = _900.x;
  } else {
    _904 = _871;
    _905 = _870;
    _906 = _869;
  }
  float _915 = clamp(mad(CB0_m[3u].w, _906 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _916 = clamp(mad(CB0_m[3u].w, _905 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _917 = clamp(mad(CB0_m[3u].w, _904 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _932 = (_915 > 0.0f) ? exp2(CB0_m[11u].x * log2(_915)) : 0.0f;
  float _933 = (_916 > 0.0f) ? exp2(CB0_m[11u].x * log2(_916)) : 0.0f;
  float _934 = (_917 > 0.0f) ? exp2(CB0_m[11u].x * log2(_917)) : 0.0f;
  float _940 = min(mHDRCompressionParam1.x, _932 * _932);
  float _941 = min(mHDRCompressionParam1.x, _933 * _933);
  float _942 = min(mHDRCompressionParam1.x, _934 * _934);
  float _976 = (mHDRCompressionParam2.w > _940) ? ((_940 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_940 - mHDRCompressionParam2.y))));
  float _977 = (mHDRCompressionParam2.w > _941) ? ((_941 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_941 - mHDRCompressionParam2.y))));
  float _978 = (mHDRCompressionParam2.w > _942) ? ((_942 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_942 - mHDRCompressionParam2.y))));
  float _1010;
  float _1011;
  float _1012;
  if (mHDRCompressionControl.z != 5.0f) {
    _1010 = (mHDRCompressionParam2.z > _978) ? mad(_978, mHDRCompressionParam1.y, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _978)));
    _1011 = (mHDRCompressionParam2.z > _977) ? mad(_977, mHDRCompressionParam1.y, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _977)));
    _1012 = (mHDRCompressionParam2.z > _976) ? mad(_976, mHDRCompressionParam1.y, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _976)));
  } else {
    _1010 = _978;
    _1011 = _977;
    _1012 = _976;
  }
#if 1
  UpgradeToneMapApplyDisplayMapAndScale(untonemapped, tonemapped, _1010, _1011, _1012, CB0_m[14u].z);
#endif
  uint _1016 = uint(cvt_f32_i32(CB0_m[10u].w));
  float _1094;
  float _1095;
  float _1096;
  if (_1016 == 1u) {
    float _1026 = CB0_m[10u].x * log2(_1012);
    float _1027 = log2(_1011) * CB0_m[10u].x;
    float _1028 = log2(_1010) * CB0_m[10u].x;
    float _1029 = exp2(_1026);
    float _1030 = exp2(_1027);
    float _1031 = exp2(_1028);
    _1094 = (_1031 < 0.00310000008903443813323974609375f) ? (_1031 * 12.9200000762939453125f) : mad(exp2(_1028 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1095 = (_1030 < 0.00310000008903443813323974609375f) ? (_1030 * 12.9200000762939453125f) : mad(exp2(_1027 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1096 = (_1029 < 0.00310000008903443813323974609375f) ? (_1029 * 12.9200000762939453125f) : mad(exp2(_1026 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _1091;
    float _1092;
    float _1093;
    if (_1016 == 2u) {
      float3 _1053 = float3(_1012, _1011, _1010);
      float _1070 = exp2(CB0_m[10u].x * log2(CB0_m[10u].y * dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _1053)));
      float _1071 = exp2(log2(CB0_m[10u].y * dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _1053)) * CB0_m[10u].x);
      float _1072 = exp2(log2(CB0_m[10u].y * dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _1053)) * CB0_m[10u].x);
      _1091 = exp2(log2(mad(_1072, 18.8515625f, 0.8359375f) / mad(_1072, 18.6875f, 1.0f)) * 78.84375f);
      _1092 = exp2(log2(mad(_1071, 18.8515625f, 0.8359375f) / mad(_1071, 18.6875f, 1.0f)) * 78.84375f);
      _1093 = exp2(log2(mad(_1070, 18.8515625f, 0.8359375f) / mad(_1070, 18.6875f, 1.0f)) * 78.84375f);
    } else {
      _1091 = _1010;
      _1092 = _1011;
      _1093 = _1012;
    }
    _1094 = _1091;
    _1095 = _1092;
    _1096 = _1093;
  }
  SV_TARGET1 = dp3_f32(float3(_1096, _1095, _1094), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  SV_TARGET.x = _1096;
  SV_TARGET.y = _1095;
  SV_TARGET.z = _1094;
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

#include "../common.hlsli"

struct _397 {
  uint2 _m0;
  uint _m1;
};

static const float2 _47[3] = { 0.0f.xx, 0.0f.xx, 0.0f.xx };
static const float3 _52[3] = { 0.0f.xxx, 0.0f.xxx, 0.0f.xxx };
static const float2 _178[10] = { (-1.0f).xx, float2(0.0f, -1.0f), float2(1.0f, -1.0f), float2(-1.0f, 0.0f), 0.0f.xx, float2(1.0f, 0.0f), float2(-1.0f, 1.0f), float2(0.0f, 1.0f), 1.0f.xx, 0.0f.xx };

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

static float2 x0[3] = _47;
static float3 x1[3] = _52;

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param) {
  uint2 ret;
  Tex.GetDimensions(Level, ret.x, ret.y, Param);
  return ret;
}

float dp2_f32(float2 a, float2 b) {
  precise float _224 = a.x * b.x;
  return mad(a.y, b.y, _224);
}

float dp3_f32(float3 a, float3 b) {
  precise float _209 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _209));
}

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

void frag_main() {
  float _236 = mad(TEXCOORD.x, 2.0f, -1.0f);
  float _237 = mad(TEXCOORD.y, 2.0f, -1.0f);
  float2 _246 = float2(_236 * CB0_m[3u].y, _237 * CB0_m[3u].z);
  float _254 = log2(abs((CB0_m[3u].x != 0.0f) ? _236 : _237));
  float _271 = mad(dp2_f32(_246, _246), CB0_m[2u].x, 1.0f) / mad(CB0_m[2u].x, 2.0f, 1.0f);
  float _274 = mad(((exp2(_254 * CB0_m[2u].z) + exp2(_254 * CB0_m[2u].w)) * CB0_m[2u].y) * 0.5f, 1.0f - _271, _271);
  float _275 = _274 * _236;
  float _276 = _274 * _237;
  float _277 = mad(_275, 0.5f, 0.5f);
  float _278 = mad(_276, 0.5f, 0.5f);
  float2 _305 = float2(max(min(_277, CB0_m[17u].x), clamp(_277, CB0_m[17u].x, CB0_m[17u].z)), max(min(_278, CB0_m[17u].y), clamp(_278, CB0_m[17u].y, CB0_m[17u].w)));
  float4 _308 = T2.Sample(S1, _305);
  float4 _314 = T4.Sample(S1, _305);
  float _315 = _314.x;
  float4 _318 = T3.Sample(S1, _305);
  float2 _323 = float2(_277, _278);
  float4 _325 = T0.Sample(S1, _323);
  float4 _332 = T1.Sample(S0, _323);
  float _333 = _332.x;
  float _338 = clamp(_333 * 4.80000019073486328125f, 0.0f, 1.0f);
  float _339 = clamp(_333 * (-4.80000019073486328125f), 0.0f, 1.0f);
  float _344 = mad(max(_315, clamp(_333 * (-0.25f), 0.0f, 1.0f)) - _315, float(_315 > 0.0f), _315);
  float _350 = min((abs(_333) * CB0_m[19u].x) * 24.0f, 1.0f);
  float _358 = mad(clamp(((_333 + _344) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), float(_344 > 0.0f) - _339, _339);
  x0[0u].x = _277;
  x0[0u].y = _278;
  x0[1u].x = TEXCOORD2.x;
  x0[1u].y = TEXCOORD2.y;
  x1[0u].x = _325.x;
  x1[0u].y = _325.y;
  x1[0u].z = _325.z;
  if (((_338 < 1.0f) || (_358 < 1.0f)) && (_350 > 0.0f)) {
    uint _386;
    uint _385 = 0u;
    for (;;) {
      if (int(_385) >= 1) {
        break;
      }
      uint _394;
      spvTextureSize(T0, 0u, _394);
      bool _395 = _394 > 0u;
      uint _396_dummy_parameter;
      _397 _398 = { spvTextureSize(T0, 0u, _396_dummy_parameter), 1u };
      float _405 = _350 / float(_395 ? _398._m0.x : 0u);
      float _406 = _350 / float(_395 ? _398._m0.y : 0u);
      uint _407 = min(_385, 2u);
      float _415;
      float _418;
      float _420;
      float _422;
      _415 = 0.0f;
      _418 = 0.0f;
      _420 = 0.0f;
      _422 = 0.0f;
      float _416;
      float _419;
      float _421;
      float _423;
      uint _425;
      uint _424 = 0u;
      for (;;) {
        if (_424 == 9u) {
          break;
        }
        uint _431 = min(_424, 9u);
        float _440 = mad(_405, _178[_431].x, x0[_407].x);
        float _441 = mad(_406, _178[_431].y, x0[_407].y);
        float4 _456 = T0.SampleLevel(S1, float2(max(min(_440, CB0_m[16u].x), clamp(_440, CB0_m[16u].x, CB0_m[16u].z)), max(clamp(CB0_m[16u].y, _441, CB0_m[16u].w), min(CB0_m[16u].y, _441))), 0.0f);
        float _457 = _456.x;
        float _465 = asfloat(2129859010u - asuint(dp3_f32(float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f), float3(_457, _456.yz)) + 0.5f));
        _423 = mad(_457, _465, _422);
        _421 = mad(_456.y, _465, _420);
        _419 = mad(_456.z, _465, _418);
        _416 = _465 + _415;
        _425 = _424 + 1u;
        _415 = _416;
        _418 = _419;
        _420 = _421;
        _422 = _423;
        _424 = _425;
        continue;
      }
      if (_385 < 2u) {
        x1[_385].x = _422 / _415;
        x1[_385].y = _420 / _415;
        x1[_385].z = _418 / _415;
      }
      _386 = _385 + 1u;
      _385 = _386;
      continue;
    }
  }
  float _487 = mad(_318.x - x1[0u].x, _338, x1[0u].x);
  float _488 = mad(_318.y - x1[0u].y, _338, x1[0u].y);
  float _489 = mad(_318.z - x1[0u].z, _338, x1[0u].z);
  float _493 = mad(_358, _308.x - _487, _487);
  float _494 = mad(_358, _308.y - _488, _488);
  float _495 = mad(_358, _308.z - _489, _489);
  float2 _497 = float2(max(min(_277, CB0_m[18u].x), clamp(_277, CB0_m[18u].x, CB0_m[18u].z)), max(clamp(_278, CB0_m[18u].y, CB0_m[18u].w), min(_278, CB0_m[18u].y)));
  float4 _499 = T5.Sample(S1, _497);
  float4 _506 = T7.Sample(S1, _305);
  float _507 = _506.x;
  float _508 = _506.y;
  float _509 = _506.z;
  float4 _512 = T6.Sample(S1, _497);
  float _527;
  if (CB0_m[6u].w != 0.0f) {
    _527 = CB0_m[6u].w;
  } else {
    _527 = U0[2u].x;
  }
  float _532 = CB0_m[6u].z * CB0_m[6u].y;
  float _533 = _499.x / _532;
  float _534 = _499.y / _532;
  float _535 = _499.z / _532;
  float _538 = (_527 * 4.0f) / (_527 + 0.25f);
  float _542 = max(_527, 1.0000000031710768509710513471353e-30f);
  float _551 = 1.0f / ((_538 + _527) + 1.0f);
  float _567 = mad(_508 * _508, CB0_m[6u].x, (mad(sqrt((_534 * _494) / _542), _538, _534) * _551) + (_494 * _551));
  float _581 = (mad(_507 * _507, CB0_m[6u].x, (_551 * mad(_538, sqrt((_493 * _533) / _542), _533)) + (_493 * _551)) * CB0_m[15u].x) + (_567 * (CB0_m[15u].x - CB0_m[15u].y));
  float _582 = mad(CB0_m[15u].y, _567, 0.0f);
  float _583 = mad(mad(_509 * _509, CB0_m[6u].x, (_495 * _551) + (mad(sqrt((_535 * _495) / _542), _538, _535) * _551)), CB0_m[15u].z, 0.0f);
  float _607;
  float _608;
  float _609;
  if (CB0_m[4u].x > 0.0f) {
    float _589 = _499.w * CB0_m[4u].x;
    float _600 = T8.Sample(S2, float2(TEXCOORD1.x, TEXCOORD1.y)).y - 0.5f;
    _607 = max(mad(_589, _600, _583), 0.0f);
    _608 = max(mad(_589, _600, _582), 0.0f);
    _609 = max(mad(_589, _600, _581), 0.0f);
  } else {
    _607 = _583;
    _608 = _582;
    _609 = _581;
  }
  float2 _612 = float2(mad(_277, 2.0f, -1.0f), mad(_278, 2.0f, -1.0f));
  float _620 = clamp(mad(sqrt(dp2_f32(_612, _612)), CB0_m[4u].y, CB0_m[4u].z), 0.0f, 1.0f);
  float _621 = _620 * _620;
  float _624 = _621 * CB0_m[5u].w;
  float _626 = mad(-_621, CB0_m[5u].w, 1.0f);
  bool _646 = CB0_m[9u].x >= 0.0f;
  float _650 = _532 * max((_551 * (CB0_m[5u].x * _624)) + (_626 * _609), 9.9999999747524270787835121154785e-07f);
  float _651 = _532 * max((_626 * _608) + ((CB0_m[5u].y * _624) * _551), 9.9999999747524270787835121154785e-07f);
  float _652 = _532 * max((_626 * _607) + ((CB0_m[5u].z * _624) * _551), 9.9999999747524270787835121154785e-07f);
  float _728;
  float _729;
  float _730;
  if (CB0_m[8u].y >= 0.0f) {
    float _696;
    float _697;
    float _698;
    if (_278 < 0.20000000298023223876953125f) {
      float _664 = floor(mad(frac(mad(_275, 0.5f, 1.3333332538604736328125f)), 18.0f, 0.5f));
      float _683 = exp2(log2(clamp(mad(abs(mad(_664, 0.3333333432674407958984375f, -3.0f)), 1.0f, -1.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _684 = exp2(log2(clamp(mad(abs(mad(_664, 0.3333333432674407958984375f, -2.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _685 = exp2(log2(clamp(mad(abs(mad(_664, 0.3333333432674407958984375f, -4.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _687 = dp3_f32(float3(_683, _684, _685), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      float _692 = exp2(mad(_278, 100.0f, -10.0f));
      _696 = (_685 / _687) * _692;
      _697 = _692 * (_684 / _687);
      _698 = (_683 / _687) * _692;
    } else {
      _696 = _652;
      _697 = _651;
      _698 = _650;
    }
    float _725;
    float _726;
    float _727;
    if (_278 > 0.800000011920928955078125f) {
      float _702 = mad(_276, 0.5f, -0.300000011920928955078125f);
      float _703 = _277 * 33.333332061767578125f;
      float _710;
      if (_702 > 0.0500000007450580596923828125f) {
        _710 = 0.0f;
      } else {
        _710 = _277;
      }
      float _714;
      float _715;
      float _716;
      if (_702 > 0.100000001490116119384765625f) {
        _714 = 0.0f;
        _715 = _277;
        _716 = 0.0f;
      } else {
        _714 = _710;
        _715 = _710;
        _716 = _277;
      }
      float _719;
      float _720;
      float _721;
      if (_702 > 0.1500000059604644775390625f) {
        _719 = _277;
        _720 = 0.0f;
        _721 = 0.0f;
      } else {
        _719 = _714;
        _720 = _715;
        _721 = _716;
      }
      _725 = _703 * _719;
      _726 = _703 * _720;
      _727 = _703 * _721;
    } else {
      _725 = _696;
      _726 = _697;
      _727 = _698;
    }
    _728 = _725;
    _729 = _726;
    _730 = _727;
  } else {
    _728 = _652;
    _729 = _651;
    _730 = _650;
  }
  float _766;
  float _767;
  float _768;

  float4 mHDRCompressionParam1 = CB0_m[12u];
  float4 mHDRCompressionParam2 = CB0_m[13u];
  float4 mHDRCompressionParam3 = CB0_m[14u];
  float4 mHDRCompressionControl = CB0_m[7u];
  float3 untonemapped = float3(_728, _729, _730);
  float3 tonemapped;

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    mHDRCompressionParam2.z = 999.f;
    mHDRCompressionParam2.w = 999.f;
    mHDRCompressionParam1.x = 100.f;
  }
#endif

  if (mHDRCompressionControl.x > 0.5f) {
    _766 = (mHDRCompressionParam2.z > _728) ? mad(mHDRCompressionParam1.y, _728, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (_728 + mHDRCompressionParam2.x)));
    _767 = (mHDRCompressionParam2.z > _729) ? mad(mHDRCompressionParam1.y, _729, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (_729 + mHDRCompressionParam2.x)));
    _768 = (mHDRCompressionParam2.z > _730) ? mad(mHDRCompressionParam1.y, _730, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (_730 + mHDRCompressionParam2.x)));
  } else {
    _766 = _728;
    _767 = _729;
    _768 = _730;
  }

#if 1
  tonemapped = ToneMapForLUT(_766, _767, _768);
#endif

  float _791 = sqrt(mad((_512.x * CB0_m[0u].z) * CB0_m[1u].x, clamp(1.0f - _768, 0.0f, 1.0f), _768));
  float _792 = sqrt(mad(clamp(1.0f - _767, 0.0f, 1.0f), CB0_m[1u].y * (_512.y * CB0_m[0u].z), _767));
  float _793 = sqrt(mad(clamp(1.0f - _766, 0.0f, 1.0f), CB0_m[1u].z * (_512.z * CB0_m[0u].z), _766));
  float _801 = mad(min(_791, 1.0f), CB0_m[0u].x, CB0_m[0u].y);
  float _802 = mad(CB0_m[0u].x, min(_792, 1.0f), CB0_m[0u].y);
  float _803 = mad(CB0_m[0u].x, min(_793, 1.0f), CB0_m[0u].y);
  float _826;
  float _827;
  float _828;
  if (!((_646 && (!(_803 <= 1.0f))) || ((_646 && (!(_801 <= 1.0f))) || (_646 && (!(_802 <= 1.0f)))))) {
    float4 _822 = T9.SampleLevel(S1, float3(_801, _802, _803), 0.0f);
    _826 = _822.z;
    _827 = _822.y;
    _828 = _822.x;
  } else {
    _826 = _793;
    _827 = _792;
    _828 = _791;
  }
  float _837 = clamp(mad(CB0_m[3u].w, _828 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _838 = clamp(mad(CB0_m[3u].w, _827 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _839 = clamp(mad(CB0_m[3u].w, _826 - 0.5f, 0.5f), 0.0f, 1.0f);
  float _854 = (_837 > 0.0f) ? exp2(CB0_m[11u].x * log2(_837)) : 0.0f;
  float _855 = (_838 > 0.0f) ? exp2(CB0_m[11u].x * log2(_838)) : 0.0f;
  float _856 = (_839 > 0.0f) ? exp2(CB0_m[11u].x * log2(_839)) : 0.0f;
  float _862 = min(_854 * _854, mHDRCompressionParam1.x);
  float _863 = min(_855 * _855, mHDRCompressionParam1.x);
  float _864 = min(_856 * _856, mHDRCompressionParam1.x);
  float _898 = (_862 < mHDRCompressionParam2.w) ? ((_862 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_862 - mHDRCompressionParam2.y))));
  float _899 = (mHDRCompressionParam2.w > _863) ? ((_863 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_863 - mHDRCompressionParam2.y))));
  float _900 = (mHDRCompressionParam2.w > _864) ? ((_864 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_864 - mHDRCompressionParam2.y))));
  float _932;
  float _933;
  float _934;
  if (mHDRCompressionControl.z != 5.0f) {
    _932 = (mHDRCompressionParam2.z > _900) ? mad(mHDRCompressionParam1.y, _900, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _900)));
    _933 = (mHDRCompressionParam2.z > _899) ? mad(mHDRCompressionParam1.y, _899, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _899)));
    _934 = (mHDRCompressionParam2.z > _898) ? mad(mHDRCompressionParam1.y, _898, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (mHDRCompressionParam3.y + _898)));
  } else {
    _932 = _900;
    _933 = _899;
    _934 = _898;
  }
#if 1
  UpgradeToneMapApplyDisplayMapAndScale(untonemapped, tonemapped, _932, _933, _934, CB0_m[14u].z);
#endif
  uint _938 = uint(cvt_f32_i32(CB0_m[10u].w));
  float _1016;
  float _1017;
  float _1018;
  if (_938 == 1u) {
    float _948 = CB0_m[10u].x * log2(_934);
    float _949 = log2(_933) * CB0_m[10u].x;
    float _950 = log2(_932) * CB0_m[10u].x;
    float _951 = exp2(_948);
    float _952 = exp2(_949);
    float _953 = exp2(_950);
    _1016 = (_953 < 0.00310000008903443813323974609375f) ? (_953 * 12.9200000762939453125f) : mad(exp2(_950 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1017 = (_952 < 0.00310000008903443813323974609375f) ? (_952 * 12.9200000762939453125f) : mad(exp2(_949 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1018 = (_951 < 0.00310000008903443813323974609375f) ? (_951 * 12.9200000762939453125f) : mad(exp2(_948 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _1013;
    float _1014;
    float _1015;
    if (_938 == 2u) {
      float3 _975 = float3(_934, _933, _932);
      float _992 = exp2(CB0_m[10u].x * log2(CB0_m[10u].y * dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _975)));
      float _993 = exp2(log2(CB0_m[10u].y * dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _975)) * CB0_m[10u].x);
      float _994 = exp2(log2(CB0_m[10u].y * dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _975)) * CB0_m[10u].x);
      _1013 = exp2(log2(mad(_994, 18.8515625f, 0.8359375f) / mad(_994, 18.6875f, 1.0f)) * 78.84375f);
      _1014 = exp2(log2(mad(_993, 18.8515625f, 0.8359375f) / mad(_993, 18.6875f, 1.0f)) * 78.84375f);
      _1015 = exp2(log2(mad(_992, 18.8515625f, 0.8359375f) / mad(_992, 18.6875f, 1.0f)) * 78.84375f);
    } else {
      _1013 = _932;
      _1014 = _933;
      _1015 = _934;
    }
    _1016 = _1013;
    _1017 = _1014;
    _1018 = _1015;
  }
  SV_TARGET1 = dp3_f32(float3(_1018, _1017, _1016), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  SV_TARGET.x = _1018;
  SV_TARGET.y = _1017;
  SV_TARGET.z = _1016;
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

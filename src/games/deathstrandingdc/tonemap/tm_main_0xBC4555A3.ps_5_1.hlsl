#include "../common.hlsli"

struct _353 {
  uint2 _m0;
  uint _m1;
};

static const float2 _47[3] = { 0.0f.xx, 0.0f.xx, 0.0f.xx };
static const float3 _52[3] = { 0.0f.xxx, 0.0f.xxx, 0.0f.xxx };
static const float2 _175[10] = { (-1.0f).xx, float2(0.0f, -1.0f), float2(1.0f, -1.0f), float2(-1.0f, 0.0f), 0.0f.xx, float2(1.0f, 0.0f), float2(-1.0f, 1.0f), float2(0.0f, 1.0f), 1.0f.xx, 0.0f.xx };

cbuffer CB0_buf : register(b0, space8) {
  float4 CB0_m[20] : packoffset(c0);
};

SamplerState S0 : register(s0, space8);
SamplerState S1 : register(s1, space8);
SamplerState S2 : register(s2, space8);
Texture2D<float4> SceneTexture : register(t0, space8);
Texture2D<float4> CoCTexture : register(t1, space8);
Texture2D<float4> NearDoFTexture : register(t2, space8);
Texture2D<float4> FarDoFTexture : register(t3, space8);
Texture2D<float4> DoFMaskTexture : register(t4, space8);
Texture2D<float4> BloomAndGrainWeightTexture : register(t5, space8);
Texture2D<float4> LightShaftTexture : register(t6, space8);
Texture2D<float4> FlareTexture : register(t7, space8);
Texture2D<float4> GrainTexture : register(t8, space8);
Texture3D<float4> Rgb3dLookupTexture : register(t9, space8);
RWBuffer<float4> U0 : register(u0, space8);

static float2 TEXCOORD0;
static float2 TEXCOORD1;
static float4 TEXCOORD2;
static float4 SV_TARGET0;
static float SV_TARGET1;

struct SPIRV_Cross_Input {
  float4 SV_POSITION0 : SV_POSITION0;
  float2 TEXCOORD0 : TEXCOORD0;
  float2 TEXCOORD1 : TEXCOORD1;
  float4 TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output {
  float4 SV_TARGET0 : SV_TARGET0;
  float SV_TARGET1 : SV_TARGET1;
};

static float2 x0[3] = _47;
static float3 x1[3] = _52;

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param) {
  uint2 ret;
  Tex.GetDimensions(Level, ret.x, ret.y, Param);
  return ret;
}

float dp3_f32(float3 a, float3 b) {
  precise float _217 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _217));
}

float dp2_f32(float2 a, float2 b) {
  precise float _205 = a.x * b.x;
  return mad(a.y, b.y, _205);
}

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

void frag_main() {
  float2 _260 = float2(max(clamp(TEXCOORD0.x, CB0_m[17u].x, CB0_m[17u].z), min(TEXCOORD0.x, CB0_m[17u].x)), max(min(TEXCOORD0.y, CB0_m[17u].y), clamp(TEXCOORD0.y, CB0_m[17u].y, CB0_m[17u].w)));
  float4 _263 = NearDoFTexture.Sample(S1, _260);
  float4 _269 = DoFMaskTexture.Sample(S1, _260);
  float _270 = _269.x;
  float4 _273 = FarDoFTexture.Sample(S1, _260);
  float2 _278 = float2(TEXCOORD0.x, TEXCOORD0.y);
  float4 _280 = SceneTexture.Sample(S1, _278);
  float4 _287 = CoCTexture.Sample(S0, _278);
  float _288 = _287.x;
  float _293 = clamp(_288 * 4.80000019073486328125f, 0.0f, 1.0f);
  float _294 = clamp(_288 * (-4.80000019073486328125f), 0.0f, 1.0f);
  float _299 = mad(max(_270, clamp(_288 * (-0.25f), 0.0f, 1.0f)) - _270, float(_270 > 0.0f), _270);
  float _306 = min((abs(_288) * CB0_m[19u].x) * 24.0f, 1.0f);
  float _314 = mad(clamp(((_288 + _299) - 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f), float(_299 > 0.0f) - _294, _294);
  x0[0u].x = TEXCOORD0.x;
  x0[0u].y = TEXCOORD0.y;
  x0[1u].x = TEXCOORD2.x;
  x0[1u].y = TEXCOORD2.y;
  x1[0u].x = _280.x;
  x1[0u].y = _280.y;
  x1[0u].z = _280.z;
  if (((_293 < 1.0f) || (_314 < 1.0f)) && (_306 > 0.0f)) {
    uint _342;
    uint _341 = 0u;
    for (;;) {
      if (int(_341) >= 1) {
        break;
      }
      uint _350;
      spvTextureSize(SceneTexture, 0u, _350);
      bool _351 = _350 > 0u;
      uint _352_dummy_parameter;
      _353 _354 = { spvTextureSize(SceneTexture, 0u, _352_dummy_parameter), 1u };
      float _361 = _306 / float(_351 ? _354._m0.x : 0u);
      float _362 = _306 / float(_351 ? _354._m0.y : 0u);
      uint _363 = min(_341, 2u);
      float _371;
      float _374;
      float _376;
      float _378;
      _371 = 0.0f;
      _374 = 0.0f;
      _376 = 0.0f;
      _378 = 0.0f;
      float _372;
      float _375;
      float _377;
      float _379;
      uint _381;
      uint _380 = 0u;
      for (;;) {
        if (_380 == 9u) {
          break;
        }
        uint _387 = min(_380, 9u);
        float _396 = mad(_361, _175[_387].x, x0[_363].x);
        float _397 = mad(_362, _175[_387].y, x0[_363].y);
        float4 _412 = SceneTexture.SampleLevel(S1, float2(max(min(_396, CB0_m[16u].x), clamp(_396, CB0_m[16u].x, CB0_m[16u].z)), max(min(_397, CB0_m[16u].y), clamp(_397, CB0_m[16u].y, CB0_m[16u].w))), 0.0f);
        float _413 = _412.x;
        float _421 = asfloat(2129859010u - asuint(dp3_f32(float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f), float3(_413, _412.yz)) + 0.5f));
        _379 = mad(_413, _421, _378);
        _377 = mad(_412.y, _421, _376);
        _375 = mad(_412.z, _421, _374);
        _372 = _421 + _371;
        _381 = _380 + 1u;
        _371 = _372;
        _374 = _375;
        _376 = _377;
        _378 = _379;
        _380 = _381;
        continue;
      }
      if (_341 < 2u) {
        x1[_341].x = _378 / _371;
        x1[_341].y = _376 / _371;
        x1[_341].z = _374 / _371;
      }
      _342 = _341 + 1u;
      _341 = _342;
      continue;
    }
  }
  float _443 = mad(_293, _273.x - x1[0u].x, x1[0u].x);
  float _444 = mad(_293, _273.y - x1[0u].y, x1[0u].y);
  float _445 = mad(_293, _273.z - x1[0u].z, x1[0u].z);
  float _449 = mad(_314, _263.x - _443, _443);
  float _450 = mad(_314, _263.y - _444, _444);
  float _451 = mad(_314, _263.z - _445, _445);
  float2 _453 = float2(max(min(TEXCOORD0.x, CB0_m[18u].x), clamp(TEXCOORD0.x, CB0_m[18u].x, CB0_m[18u].z)), max(clamp(TEXCOORD0.y, CB0_m[18u].y, CB0_m[18u].w), min(TEXCOORD0.y, CB0_m[18u].y)));
  float4 _455 = BloomAndGrainWeightTexture.Sample(S1, _453);
  float4 _462 = FlareTexture.Sample(S1, _260);
  float _463 = _462.x;
  float _464 = _462.y;
  float _465 = _462.z;
  float4 _468 = LightShaftTexture.Sample(S1, _453);
  float _483;
  if (CB0_m[6u].w != 0.0f) {
    _483 = CB0_m[6u].w;
  } else {
    _483 = U0[2u].x;
  }
  float _488 = CB0_m[6u].z * CB0_m[6u].y;
  float _489 = _455.x / _488;
  float _490 = _455.y / _488;
  float _491 = _455.z / _488;
  float _494 = (_483 * 4.0f) / (_483 + 0.25f);
  float _498 = max(_483, 1.0000000031710768509710513471353e-30f);
  float _507 = 1.0f / ((_494 + _483) + 1.0f);
  float _523 = mad(_464 * _464, CB0_m[6u].x, (_450 * _507) + (mad(sqrt((_490 * _450) / _498), _494, _490) * _507));
  float _537 = (mad(_463 * _463, CB0_m[6u].x, (_507 * mad(_494, sqrt((_449 * _489) / _498), _489)) + (_449 * _507)) * CB0_m[15u].x) + (_523 * (CB0_m[15u].x - CB0_m[15u].y));
  float _538 = mad(_523, CB0_m[15u].y, 0.0f);
  float _539 = mad(mad(_465 * _465, CB0_m[6u].x, (_451 * _507) + (mad(sqrt((_491 * _451) / _498), _494, _491) * _507)), CB0_m[15u].z, 0.0f);
  float _563;
  float _564;
  float _565;
  if (CB0_m[4u].x > 0.0f) {
    float _545 = _455.w * CB0_m[4u].x;
    float _556 = GrainTexture.Sample(S2, float2(TEXCOORD1.x, TEXCOORD1.y)).y - 0.5f;
    _563 = max(mad(_545, _556, _539), 0.0f);
    _564 = max(mad(_545, _556, _538), 0.0f);
    _565 = max(mad(_545, _556, _537), 0.0f);
  } else {
    _563 = _539;
    _564 = _538;
    _565 = _537;
  }
  float2 _568 = float2(mad(TEXCOORD0.x, 2.0f, -1.0f), mad(TEXCOORD0.y, 2.0f, -1.0f));
  float _576 = clamp(mad(sqrt(dp2_f32(_568, _568)), CB0_m[4u].y, CB0_m[4u].z), 0.0f, 1.0f);
  float _577 = _576 * _576;
  float _580 = _577 * CB0_m[5u].w;
  float _582 = mad(-_577, CB0_m[5u].w, 1.0f);
  bool _602 = CB0_m[9u].x >= 0.0f;
  float _606 = _488 * max((_507 * (_580 * CB0_m[5u].x)) + (_582 * _565), 9.9999999747524270787835121154785e-07f);
  float _607 = _488 * max((_582 * _564) + (_507 * (_580 * CB0_m[5u].y)), 9.9999999747524270787835121154785e-07f);
  float _608 = _488 * max((_582 * _563) + (_507 * (_580 * CB0_m[5u].z)), 9.9999999747524270787835121154785e-07f);
  float _684;
  float _685;
  float _686;
  if (CB0_m[8u].y >= 0.0f) {
    float _652;
    float _653;
    float _654;
    if (TEXCOORD0.y < 0.20000000298023223876953125f) {
      float _620 = floor(mad(frac(TEXCOORD0.x + 0.833333313465118408203125f), 18.0f, 0.5f));
      float _639 = exp2(log2(clamp(mad(abs(mad(_620, 0.3333333432674407958984375f, -3.0f)), 1.0f, -1.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _640 = exp2(log2(clamp(mad(abs(mad(_620, 0.3333333432674407958984375f, -2.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _641 = exp2(log2(clamp(mad(abs(mad(_620, 0.3333333432674407958984375f, -4.0f)), -1.0f, 2.0f), 0.0f, 1.0f)) * 2.400000095367431640625f);
      float _643 = dp3_f32(float3(_639, _640, _641), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      float _648 = exp2(mad(TEXCOORD0.y, 100.0f, -10.0f));
      _652 = _648 * (_641 / _643);
      _653 = (_640 / _643) * _648;
      _654 = (_639 / _643) * _648;
    } else {
      _652 = _608;
      _653 = _607;
      _654 = _606;
    }
    float _681;
    float _682;
    float _683;
    if (TEXCOORD0.y > 0.800000011920928955078125f) {
      float _658 = TEXCOORD0.y - 0.800000011920928955078125f;
      float _659 = TEXCOORD0.x * 33.333332061767578125f;
      float _666;
      if (_658 > 0.0500000007450580596923828125f) {
        _666 = 0.0f;
      } else {
        _666 = TEXCOORD0.x;
      }
      float _670;
      float _671;
      float _672;
      if (_658 > 0.100000001490116119384765625f) {
        _670 = 0.0f;
        _671 = TEXCOORD0.x;
        _672 = 0.0f;
      } else {
        _670 = _666;
        _671 = _666;
        _672 = TEXCOORD0.x;
      }
      float _675;
      float _676;
      float _677;
      if (_658 > 0.1500000059604644775390625f) {
        _675 = TEXCOORD0.x;
        _676 = 0.0f;
        _677 = 0.0f;
      } else {
        _675 = _670;
        _676 = _671;
        _677 = _672;
      }
      _681 = _659 * _675;
      _682 = _659 * _676;
      _683 = _659 * _677;
    } else {
      _681 = _652;
      _682 = _653;
      _683 = _654;
    }
    _684 = _681;
    _685 = _682;
    _686 = _683;
  } else {
    _684 = _608;
    _685 = _607;
    _686 = _606;
  }
  float _722;
  float _723;
  float _724;

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

  // some tonemapping stuff
  if (mHDRCompressionControl.x > 0.5f) {
    _722 = (_684 < mHDRCompressionParam2.z) ? mad(mHDRCompressionParam1.y, _684, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _684)));
    _723 = (_685 < mHDRCompressionParam2.z) ? mad(mHDRCompressionParam1.y, _685, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _685)));
    _724 = (_686 < mHDRCompressionParam2.z) ? mad(mHDRCompressionParam1.y, _686, mHDRCompressionParam1.z) : (mHDRCompressionParam2.y - (mHDRCompressionParam1.w / (mHDRCompressionParam2.x + _686)));
  } else {
    _722 = _684;
    _723 = _685;
    _724 = _686;
  }

#if 1  // account for flipped channels
  float3 untonemapped, tonemapped;
  tonemapped = ToneMapForLUT(_724, _723, _722, untonemapped);
#endif

  // add light shafts
  float _747 = sqrt(mad(CB0_m[1u].x * (_468.x * CB0_m[0u].z), clamp(1.0f - _724, 0.0f, 1.0f), _724));
  float _748 = sqrt(mad(clamp(1.0f - _723, 0.0f, 1.0f), CB0_m[1u].y * (_468.y * CB0_m[0u].z), _723));
  float _749 = sqrt(mad(clamp(1.0f - _722, 0.0f, 1.0f), CB0_m[1u].z * (_468.z * CB0_m[0u].z), _722));
  float _757 = mad(min(_747, 1.0f), CB0_m[0u].x, CB0_m[0u].y);
  float _758 = mad(CB0_m[0u].x, min(_748, 1.0f), CB0_m[0u].y);
  float _759 = mad(CB0_m[0u].x, min(_749, 1.0f), CB0_m[0u].y);
  float _782;
  float _783;
  float _784;

  // sample gamma 2 LUT
  if (!((_602 && (!(_759 <= 1.0f))) || ((_602 && (!(_757 <= 1.0f))) || (_602 && (!(_758 <= 1.0f)))))) {
    float4 _778 = Rgb3dLookupTexture.SampleLevel(S1, float3(_757, _758, _759), 0.0f);
    _782 = _778.z;
    _783 = _778.y;
    _784 = _778.x;
  } else {
    _782 = _749;
    _783 = _748;
    _784 = _747;
  }

  // contrast adjustment
  float _793 = saturate(mad(_784 - 0.5f, CB0_m[3u].w, 0.5f));
  float _794 = saturate(mad(CB0_m[3u].w, _783 - 0.5f, 0.5f));
  float _795 = saturate(mad(CB0_m[3u].w, _782 - 0.5f, 0.5f));
  float _810 = (_793 > 0.0f) ? exp2(log2(_793) * CB0_m[11u].x) : 0.0f;
  float _811 = (_794 > 0.0f) ? exp2(log2(_794) * CB0_m[11u].x) : 0.0f;
  float _812 = (_795 > 0.0f) ? exp2(log2(_795) * CB0_m[11u].x) : 0.0f;

  // clamp for some reason, back to linear
  float _818 = min(mHDRCompressionParam1.x, _810 * _810);
  float _819 = min(mHDRCompressionParam1.x, _811 * _811);
  float _820 = min(mHDRCompressionParam1.x, _812 * _812);

  // more tonemapping stuff
  float _854 = (_818 < mHDRCompressionParam2.w) ? ((_818 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_818 - mHDRCompressionParam2.y))));
  float _855 = (_819 < mHDRCompressionParam2.w) ? ((_819 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-((mHDRCompressionParam1.w / (_819 - mHDRCompressionParam2.y)) + mHDRCompressionParam2.x));
  float _856 = (_820 < mHDRCompressionParam2.w) ? ((_820 - mHDRCompressionParam1.z) / mHDRCompressionParam1.y) : (-(mHDRCompressionParam2.x + (mHDRCompressionParam1.w / (_820 - mHDRCompressionParam2.y))));
  float _888;
  float _889;
  float _890;

  // final highlight compression/tonemapping stuff
  if (mHDRCompressionControl.z != 5.0f) {
    _888 = (mHDRCompressionParam2.z > _856) ? mad(mHDRCompressionParam1.y, _856, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (_856 + mHDRCompressionParam3.y)));
    _889 = (mHDRCompressionParam2.z > _855) ? mad(mHDRCompressionParam1.y, _855, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (_855 + mHDRCompressionParam3.y)));
    _890 = (mHDRCompressionParam2.z > _854) ? mad(mHDRCompressionParam1.y, _854, mHDRCompressionParam1.z) : (mHDRCompressionParam3.z - (mHDRCompressionParam3.x / (_854 + mHDRCompressionParam3.y)));
  } else {
    _888 = _856;
    _889 = _855;
    _890 = _854;
  }

#if 1  // account for flipped channels
  UpgradeToneMapApplyDisplayMapAndScale(untonemapped, tonemapped, _890, _889, _888);
#endif
  uint _894 = uint(cvt_f32_i32(CB0_m[10u].w));
  float _972;
  float _973;
  float _974;
  if (_894 == 1u) {
    float _904 = CB0_m[10u].x * log2(_890);
    float _905 = CB0_m[10u].x * log2(_889);
    float _906 = CB0_m[10u].x * log2(_888);
    float _907 = exp2(_904);
    float _908 = exp2(_905);
    float _909 = exp2(_906);
    _972 = (_909 < 0.00310000008903443813323974609375f) ? (_909 * 12.9200000762939453125f) : mad(exp2(_906 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _973 = (_908 < 0.00310000008903443813323974609375f) ? (_908 * 12.9200000762939453125f) : mad(exp2(_905 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _974 = (_907 < 0.00310000008903443813323974609375f) ? (_907 * 12.9200000762939453125f) : mad(exp2(_904 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _969;
    float _970;
    float _971;
    if (_894 == 2u) {
      float3 _931 = float3(_890, _889, _888);
#if 1
      EncodePQ(_931, CB0_m[10u].x, CB0_m[10u].y, _969, _970, _971);
#else
      float _948 = exp2(CB0_m[10u].x * log2(CB0_m[10u].y * dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _931)));
      float _949 = exp2(log2(CB0_m[10u].y * dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _931)) * CB0_m[10u].x);
      float _950 = exp2(log2(CB0_m[10u].y * dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _931)) * CB0_m[10u].x);
      _969 = exp2(log2(mad(_950, 18.8515625f, 0.8359375f) / mad(_950, 18.6875f, 1.0f)) * 78.84375f);
      _970 = exp2(log2(mad(_949, 18.8515625f, 0.8359375f) / mad(_949, 18.6875f, 1.0f)) * 78.84375f);
      _971 = exp2(log2(mad(_948, 18.8515625f, 0.8359375f) / mad(_948, 18.6875f, 1.0f)) * 78.84375f);
#endif
    } else {
      _969 = _888;
      _970 = _889;
      _971 = _890;
    }
    _972 = _969;
    _973 = _970;
    _974 = _971;
  }
  SV_TARGET1 = dp3_f32(float3(_974, _973, _972), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  SV_TARGET0.x = _974;
  SV_TARGET0.y = _973;
  SV_TARGET0.z = _972;
  SV_TARGET0.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD0 = stage_input.TEXCOORD0;
  TEXCOORD1 = stage_input.TEXCOORD1;
  TEXCOORD2 = stage_input.TEXCOORD2;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_TARGET0 = SV_TARGET0;
  stage_output.SV_TARGET1 = SV_TARGET1;
  return stage_output;
}

#define LUTBUILDER_HASH 0x0654FE73

#include "./filmiclutbuilder.hlsli"

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

// cbuffer _RootShaderParameters : register(b0) {
//   float4 LUTWeights[2] : packoffset(c005.x);
//   float4 ACESMinMaxData : packoffset(c008.x);
//   float4 ACESMidData : packoffset(c009.x);
//   float4 ACESCoefsLow_0 : packoffset(c010.x);
//   float4 ACESCoefsHigh_0 : packoffset(c011.x);
//   float ACESCoefsLow_4 : packoffset(c012.x);
//   float ACESCoefsHigh_4 : packoffset(c012.y);
//   float ACESSceneColorMultiplier : packoffset(c012.z);
//   float ACESGamutCompression : packoffset(c012.w);
//   float4 OverlayColor : packoffset(c013.x);
//   float3 ColorScale : packoffset(c014.x);
//   float4 ColorSaturation : packoffset(c015.x);
//   float4 ColorContrast : packoffset(c016.x);
//   float4 ColorGamma : packoffset(c017.x);
//   float4 ColorGain : packoffset(c018.x);
//   float4 ColorOffset : packoffset(c019.x);
//   float4 ColorSaturationShadows : packoffset(c020.x);
//   float4 ColorContrastShadows : packoffset(c021.x);
//   float4 ColorGammaShadows : packoffset(c022.x);
//   float4 ColorGainShadows : packoffset(c023.x);
//   float4 ColorOffsetShadows : packoffset(c024.x);
//   float4 ColorSaturationMidtones : packoffset(c025.x);
//   float4 ColorContrastMidtones : packoffset(c026.x);
//   float4 ColorGammaMidtones : packoffset(c027.x);
//   float4 ColorGainMidtones : packoffset(c028.x);
//   float4 ColorOffsetMidtones : packoffset(c029.x);
//   float4 ColorSaturationHighlights : packoffset(c030.x);
//   float4 ColorContrastHighlights : packoffset(c031.x);
//   float4 ColorGammaHighlights : packoffset(c032.x);
//   float4 ColorGainHighlights : packoffset(c033.x);
//   float4 ColorOffsetHighlights : packoffset(c034.x);
//   float LUTSize : packoffset(c035.x);
//   float ColorCorrectionShadowsMax : packoffset(c035.w);
//   float ColorCorrectionHighlightsMin : packoffset(c036.x);
//   float ColorCorrectionHighlightsMax : packoffset(c036.y);
//   float BlueCorrection : packoffset(c036.z);
//   float ExpandGamut : packoffset(c036.w);
//   float ToneCurveAmount : packoffset(c037.x);
//   float FilmSlope : packoffset(c037.y);
//   float FilmToe : packoffset(c037.z);
//   float FilmShoulder : packoffset(c037.w);
//   float FilmBlackClip : packoffset(c038.x);
//   float FilmWhiteClip : packoffset(c038.y);
//   float3 MappingPolynomial : packoffset(c039.x);
//   float3 InverseGamma : packoffset(c040.x);
//   uint OutputDevice : packoffset(c040.w);
//   uint OutputGamut : packoffset(c041.x);
// };

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

SamplerState Samplers_1 : register(s0);

SamplerState Samplers_2 : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  float4 SV_Target;

#if 1
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;
#endif

  float _12[6];
  float _13[6];
  float _14[6];
  float _15[6];
  float _18 = 0.5f / LUTSize;
  float _23 = LUTSize + -1.0f;
  float _24 = (LUTSize * (TEXCOORD.x - _18)) / _23;
  float _25 = (LUTSize * (TEXCOORD.y - _18)) / _23;
  float _27 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _23;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _113;
  float _114;
  float _115;
  float _638;
  float _671;
  float _685;
  float _749;
  float _928;
  float _939;
  float _950;
  float _1152;
  float _1153;
  float _1154;
  float _1165;
  float _1176;
  float _1349;
  float _1364;
  float _1379;
  float _1387;
  float _1388;
  float _1389;
  float _1456;
  float _1489;
  float _1503;
  float _1542;
  float _1652;
  float _1726;
  float _1800;
  float _1879;
  float _1880;
  float _1881;
  float _2023;
  float _2038;
  float _2053;
  float _2061;
  float _2062;
  float _2063;
  float _2130;
  float _2163;
  float _2177;
  float _2216;
  float _2326;
  float _2400;
  float _2474;
  float _2553;
  float _2554;
  float _2555;
  float _2732;
  float _2733;
  float _2734;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _36 = (output_gamut == 4);
        _47 = select(_36, 1.0f, 1.705051064491272f);
        _48 = select(_36, 0.0f, -0.6217921376228333f);
        _49 = select(_36, 0.0f, -0.0832589864730835f);
        _50 = select(_36, 0.0f, -0.13025647401809692f);
        _51 = select(_36, 1.0f, 1.140804648399353f);
        _52 = select(_36, 0.0f, -0.010548308491706848f);
        _53 = select(_36, 0.0f, -0.024003351107239723f);
        _54 = select(_36, 0.0f, -0.1289689838886261f);
        _55 = select(_36, 1.0f, 1.1529725790023804f);
      } else {
        _47 = 0.6954522132873535f;
        _48 = 0.14067870378494263f;
        _49 = 0.16386906802654266f;
        _50 = 0.044794563204050064f;
        _51 = 0.8596711158752441f;
        _52 = 0.0955343171954155f;
        _53 = -0.005525882821530104f;
        _54 = 0.004025210160762072f;
        _55 = 1.0015007257461548f;
      }
    } else {
      _47 = 1.0258246660232544f;
      _48 = -0.020053181797266006f;
      _49 = -0.005771636962890625f;
      _50 = -0.002234415616840124f;
      _51 = 1.0045864582061768f;
      _52 = -0.002352118492126465f;
      _53 = -0.005013350863009691f;
      _54 = -0.025290070101618767f;
      _55 = 1.0303035974502563f;
    }
  } else {
    _47 = 1.3792141675949097f;
    _48 = -0.30886411666870117f;
    _49 = -0.0703500509262085f;
    _50 = -0.06933490186929703f;
    _51 = 1.08229660987854f;
    _52 = -0.012961871922016144f;
    _53 = -0.0021590073592960835f;
    _54 = -0.0454593189060688f;
    _55 = 1.0476183891296387f;
  }
  if ((uint)output_device > (uint)2) {
    float _66 = (pow(_24, 0.012683313339948654f));
    float _67 = (pow(_25, 0.012683313339948654f));
    float _68 = (pow(_27, 0.012683313339948654f));
    _113 = (exp2(log2(max(0.0f, (_66 + -0.8359375f)) / (18.8515625f - (_66 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _114 = (exp2(log2(max(0.0f, (_67 + -0.8359375f)) / (18.8515625f - (_67 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _115 = (exp2(log2(max(0.0f, (_68 + -0.8359375f)) / (18.8515625f - (_68 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _113 = ((exp2((_24 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _114 = ((exp2((_25 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _115 = ((exp2((_27 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f && output_device != 8u) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

#endif

  float _130 = mad((WorkingColorSpace.ToAP1[0].z), _115, mad((WorkingColorSpace.ToAP1[0].y), _114, ((WorkingColorSpace.ToAP1[0].x) * _113)));
  float _133 = mad((WorkingColorSpace.ToAP1[1].z), _115, mad((WorkingColorSpace.ToAP1[1].y), _114, ((WorkingColorSpace.ToAP1[1].x) * _113)));
  float _136 = mad((WorkingColorSpace.ToAP1[2].z), _115, mad((WorkingColorSpace.ToAP1[2].y), _114, ((WorkingColorSpace.ToAP1[2].x) * _113)));
  float _137 = dot(float3(_130, _133, _136), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _141 = (_130 / _137) + -1.0f;
  float _142 = (_133 / _137) + -1.0f;
  float _143 = (_136 / _137) + -1.0f;
  float _155 = (1.0f - exp2(((_137 * _137) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_141, _142, _143), float3(_141, _142, _143)) * -4.0f));
  float _171 = ((mad(-0.06368321925401688f, _136, mad(-0.3292922377586365f, _133, (_130 * 1.3704125881195068f))) - _130) * _155) + _130;
  float _172 = ((mad(-0.010861365124583244f, _136, mad(1.0970927476882935f, _133, (_130 * -0.08343357592821121f))) - _133) * _155) + _133;
  float _173 = ((mad(1.2036951780319214f, _136, mad(-0.09862580895423889f, _133, (_130 * -0.02579331398010254f))) - _136) * _155) + _136;
  float _174 = dot(float3(_171, _172, _173), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _188 = ColorOffset.w + ColorOffsetShadows.w;
  float _202 = ColorGain.w * ColorGainShadows.w;
  float _216 = ColorGamma.w * ColorGammaShadows.w;
  float _230 = ColorContrast.w * ColorContrastShadows.w;
  float _244 = ColorSaturation.w * ColorSaturationShadows.w;
  float _248 = _171 - _174;
  float _249 = _172 - _174;
  float _250 = _173 - _174;
  float _307 = saturate(_174 / ColorCorrectionShadowsMax);
  float _311 = (_307 * _307) * (3.0f - (_307 * 2.0f));
  float _312 = 1.0f - _311;
  float _321 = ColorOffset.w + ColorOffsetHighlights.w;
  float _330 = ColorGain.w * ColorGainHighlights.w;
  float _339 = ColorGamma.w * ColorGammaHighlights.w;
  float _348 = ColorContrast.w * ColorContrastHighlights.w;
  float _357 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _420 = saturate((_174 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _424 = (_420 * _420) * (3.0f - (_420 * 2.0f));
  float _433 = ColorOffset.w + ColorOffsetMidtones.w;
  float _442 = ColorGain.w * ColorGainMidtones.w;
  float _451 = ColorGamma.w * ColorGammaMidtones.w;
  float _460 = ColorContrast.w * ColorContrastMidtones.w;
  float _469 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _527 = _311 - _424;
  float _538 = ((_424 * (((ColorOffset.x + ColorOffsetHighlights.x) + _321) + (((ColorGain.x * ColorGainHighlights.x) * _330) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _348) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _357) * _248) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _339)))))) + (_312 * (((ColorOffset.x + ColorOffsetShadows.x) + _188) + (((ColorGain.x * ColorGainShadows.x) * _202) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _230) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _244) * _248) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _216))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _433) + (((ColorGain.x * ColorGainMidtones.x) * _442) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _460) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _469) * _248) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _451))))) * _527);
  float _540 = ((_424 * (((ColorOffset.y + ColorOffsetHighlights.y) + _321) + (((ColorGain.y * ColorGainHighlights.y) * _330) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _348) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _357) * _249) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _339)))))) + (_312 * (((ColorOffset.y + ColorOffsetShadows.y) + _188) + (((ColorGain.y * ColorGainShadows.y) * _202) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _230) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _244) * _249) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _216))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _433) + (((ColorGain.y * ColorGainMidtones.y) * _442) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _460) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _469) * _249) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _451))))) * _527);
  float _542 = ((_424 * (((ColorOffset.z + ColorOffsetHighlights.z) + _321) + (((ColorGain.z * ColorGainHighlights.z) * _330) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _348) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _357) * _250) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _339)))))) + (_312 * (((ColorOffset.z + ColorOffsetShadows.z) + _188) + (((ColorGain.z * ColorGainShadows.z) * _202) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _230) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _244) * _250) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _216))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _433) + (((ColorGain.z * ColorGainMidtones.z) * _442) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _460) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _469) * _250) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _451))))) * _527);

#if 1  // begin FilmToneMap with BlueCorrect
  float _900, _901, _902;
  ApplyFilmToneMapWithBlueCorrect(_538, _540, _542,
                                  _900, _901, _902);
#else
  float _578 = ((mad(0.061360642313957214f, _542, mad(-4.540197551250458e-09f, _540, (_538 * 0.9386394023895264f))) - _538) * BlueCorrection) + _538;
  float _579 = ((mad(0.169205904006958f, _542, mad(0.8307942152023315f, _540, (_538 * 6.775371730327606e-08f))) - _540) * BlueCorrection) + _540;
  float _580 = (mad(-2.3283064365386963e-10f, _540, (_538 * -9.313225746154785e-10f)) * BlueCorrection) + _542;
  float _583 = mad(0.16386905312538147f, _580, mad(0.14067868888378143f, _579, (_578 * 0.6954522132873535f)));
  float _586 = mad(0.0955343246459961f, _580, mad(0.8596711158752441f, _579, (_578 * 0.044794581830501556f)));
  float _589 = mad(1.0015007257461548f, _580, mad(0.004025210160762072f, _579, (_578 * -0.005525882821530104f)));
  float _593 = max(max(_583, _586), _589);
  float _598 = (max(_593, 1.000000013351432e-10f) - max(min(min(_583, _586), _589), 1.000000013351432e-10f)) / max(_593, 0.009999999776482582f);
  float _611 = ((_586 + _583) + _589) + (sqrt((((_589 - _586) * _589) + ((_586 - _583) * _586)) + ((_583 - _589) * _583)) * 1.75f);
  float _612 = _611 * 0.3333333432674408f;
  float _613 = _598 + -0.4000000059604645f;
  float _614 = _613 * 5.0f;
  float _618 = max((1.0f - abs(_613 * 2.5f)), 0.0f);
  float _629 = ((float((int)(((int)(uint)((bool)(_614 > 0.0f))) - ((int)(uint)((bool)(_614 < 0.0f))))) * (1.0f - (_618 * _618))) + 1.0f) * 0.02500000037252903f;
  if (!(_612 <= 0.0533333346247673f)) {
    if (!(_612 >= 0.1599999964237213f)) {
      _638 = (((0.23999999463558197f / _611) + -0.5f) * _629);
    } else {
      _638 = 0.0f;
    }
  } else {
    _638 = _629;
  }
  float _639 = _638 + 1.0f;
  float _640 = _639 * _583;
  float _641 = _639 * _586;
  float _642 = _639 * _589;
  if (!((bool)(_640 == _641) && (bool)(_641 == _642))) {
    float _649 = ((_640 * 2.0f) - _641) - _642;
    float _652 = ((_586 - _589) * 1.7320507764816284f) * _639;
    float _654 = atan(_652 / _649);
    bool _657 = (_649 < 0.0f);
    bool _658 = (_649 == 0.0f);
    bool _659 = (_652 >= 0.0f);
    bool _660 = (_652 < 0.0f);
    _671 = select((_659 && _658), 90.0f, select((_660 && _658), -90.0f, (select((_660 && _657), (_654 + -3.1415927410125732f), select((_659 && _657), (_654 + 3.1415927410125732f), _654)) * 57.2957763671875f)));
  } else {
    _671 = 0.0f;
  }
  float _676 = min(max(select((_671 < 0.0f), (_671 + 360.0f), _671), 0.0f), 360.0f);
  if (_676 < -180.0f) {
    _685 = (_676 + 360.0f);
  } else {
    if (_676 > 180.0f) {
      _685 = (_676 + -360.0f);
    } else {
      _685 = _676;
    }
  }
  float _689 = saturate(1.0f - abs(_685 * 0.014814814552664757f));
  float _693 = (_689 * _689) * (3.0f - (_689 * 2.0f));
  float _699 = ((_693 * _693) * ((_598 * 0.18000000715255737f) * (0.029999999329447746f - _640))) + _640;
  float _709 = max(0.0f, mad(-0.21492856740951538f, _642, mad(-0.2365107536315918f, _641, (_699 * 1.4514392614364624f))));
  float _710 = max(0.0f, mad(-0.09967592358589172f, _642, mad(1.17622971534729f, _641, (_699 * -0.07655377686023712f))));
  float _711 = max(0.0f, mad(0.9977163076400757f, _642, mad(-0.006032449658960104f, _641, (_699 * 0.008316148072481155f))));
  float _712 = dot(float3(_709, _710, _711), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _727 = (FilmBlackClip + 1.0f) - FilmToe;
  float _729 = FilmWhiteClip + 1.0f;
  float _731 = _729 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _749 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _740 = (FilmBlackClip + 0.18000000715255737f) / _727;
    _749 = (-0.7447274923324585f - ((log2(_740 / (2.0f - _740)) * 0.3465735912322998f) * (_727 / FilmSlope)));
  }
  float _752 = ((1.0f - FilmToe) / FilmSlope) - _749;
  float _754 = (FilmShoulder / FilmSlope) - _752;
  float _758 = lerp(_712, _709, 0.9599999785423279f);
  float _759 = lerp(_712, _710, 0.9599999785423279f);
  float _760 = lerp(_712, _711, 0.9599999785423279f);

#if 1
  float _900, _901, _902;
  ApplyFilmicToneMap(_758, _759, _760,
                     _578, _579, _580,
                     _900, _901, _902);
#else
  _758 = log2(_758) * 0.3010300099849701f;
  _759 = log2(_759) * 0.3010300099849701f;
  _760 = log2(_760) * 0.3010300099849701f;
  float _764 = FilmSlope * (_758 + _752);
  float _765 = FilmSlope * (_759 + _752);
  float _766 = FilmSlope * (_760 + _752);
  float _767 = _727 * 2.0f;
  float _769 = (FilmSlope * -2.0f) / _727;
  float _770 = _758 - _749;
  float _771 = _759 - _749;
  float _772 = _760 - _749;
  float _791 = _731 * 2.0f;
  float _793 = (FilmSlope * 2.0f) / _731;
  float _818 = select((_758 < _749), ((_767 / (exp2((_770 * 1.4426950216293335f) * _769) + 1.0f)) - FilmBlackClip), _764);
  float _819 = select((_759 < _749), ((_767 / (exp2((_771 * 1.4426950216293335f) * _769) + 1.0f)) - FilmBlackClip), _765);
  float _820 = select((_760 < _749), ((_767 / (exp2((_772 * 1.4426950216293335f) * _769) + 1.0f)) - FilmBlackClip), _766);
  float _827 = _754 - _749;
  float _831 = saturate(_770 / _827);
  float _832 = saturate(_771 / _827);
  float _833 = saturate(_772 / _827);
  bool _834 = (_754 < _749);
  float _838 = select(_834, (1.0f - _831), _831);
  float _839 = select(_834, (1.0f - _832), _832);
  float _840 = select(_834, (1.0f - _833), _833);
  float _859 = (((_838 * _838) * (select((_758 > _754), (_729 - (_791 / (exp2(((_758 - _754) * 1.4426950216293335f) * _793) + 1.0f))), _764) - _818)) * (3.0f - (_838 * 2.0f))) + _818;
  float _860 = (((_839 * _839) * (select((_759 > _754), (_729 - (_791 / (exp2(((_759 - _754) * 1.4426950216293335f) * _793) + 1.0f))), _765) - _819)) * (3.0f - (_839 * 2.0f))) + _819;
  float _861 = (((_840 * _840) * (select((_760 > _754), (_729 - (_791 / (exp2(((_760 - _754) * 1.4426950216293335f) * _793) + 1.0f))), _766) - _820)) * (3.0f - (_840 * 2.0f))) + _820;
  float _862 = dot(float3(_859, _860, _861), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _882 = (ToneCurveAmount * (max(0.0f, (lerp(_862, _859, 0.9300000071525574f))) - _578)) + _578;
  float _883 = (ToneCurveAmount * (max(0.0f, (lerp(_862, _860, 0.9300000071525574f))) - _579)) + _579;
  float _884 = (ToneCurveAmount * (max(0.0f, (lerp(_862, _861, 0.9300000071525574f))) - _580)) + _580;
  float _900 = ((mad(-0.06537103652954102f, _884, mad(1.451815478503704e-06f, _883, (_882 * 1.065374732017517f))) - _882) * BlueCorrection) + _882;
  float _901 = ((mad(-0.20366770029067993f, _884, mad(1.2036634683609009f, _883, (_882 * -2.57161445915699e-07f))) - _883) * BlueCorrection) + _883;
  float _902 = ((mad(0.9999996423721313f, _884, mad(2.0954757928848267e-08f, _883, (_882 * 1.862645149230957e-08f))) - _884) * BlueCorrection) + _884;
#endif

#endif  // end FilmToneMap with BlueCorrect

  // remove saturate()
  float _915 = mad((WorkingColorSpace.FromAP1[0].z), _902, mad((WorkingColorSpace.FromAP1[0].y), _901, ((WorkingColorSpace.FromAP1[0].x) * _900)));
  float _916 = mad((WorkingColorSpace.FromAP1[1].z), _902, mad((WorkingColorSpace.FromAP1[1].y), _901, ((WorkingColorSpace.FromAP1[1].x) * _900)));
  float _917 = mad((WorkingColorSpace.FromAP1[2].z), _902, mad((WorkingColorSpace.FromAP1[2].y), _901, ((WorkingColorSpace.FromAP1[2].x) * _900)));

#if 1
  float _1047, _1048, _1049;
  Sample2LUTsUpgradeToneMap(float3(_915, _916, _917), Samplers_1, Samplers_2, Textures_1, Textures_2, _1047, _1048, _1049);
#else

  _928 = renodx::color::srgb::EncodeSafe(_915);
  _939 = renodx::color::srgb::EncodeSafe(_916);
  _950 = renodx::color::srgb::EncodeSafe(_917);
  float _954 = (_939 * 0.9375f) + 0.03125f;
  float _961 = _950 * 15.0f;
  float _962 = floor(_961);
  float _963 = _961 - _962;
  float _965 = (_962 + ((_928 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _968 = Textures_1.Sample(Samplers_1, float2(_965, _954));
  float _972 = _965 + 0.0625f;
  float4 _975 = Textures_1.Sample(Samplers_1, float2(_972, _954));
  float4 _998 = Textures_2.Sample(Samplers_2, float2(_965, _954));
  float4 _1004 = Textures_2.Sample(Samplers_2, float2(_972, _954));
  float _1023 = ((((lerp(_968.x, _975.x, _963)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _928)) + ((lerp(_998.x, _1004.x, _963)) * (LUTWeights[0].z)));
  float _1024 = ((((lerp(_968.y, _975.y, _963)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _939)) + ((lerp(_998.y, _1004.y, _963)) * (LUTWeights[0].z)));
  float _1025 = ((((lerp(_968.z, _975.z, _963)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _950)) + ((lerp(_998.z, _1004.z, _963)) * (LUTWeights[0].z)));
  _1023 = max(6.103519990574569e-05f, _1023);
  _1024 = max(6.103519990574569e-05f, _1024);
  _1025 = max(6.103519990574569e-05f, _1025);
  // float _1047 = select((_1023 > 0.040449999272823334f), exp2(log2((_1023 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1023 * 0.07739938050508499f));
  // float _1048 = select((_1024 > 0.040449999272823334f), exp2(log2((_1024 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1024 * 0.07739938050508499f));
  // float _1049 = select((_1025 > 0.040449999272823334f), exp2(log2((_1025 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1025 * 0.07739938050508499f));
  float _1047 = renodx::color::srgb::DecodeSafe(_1023);
  float _1048 = renodx::color::srgb::DecodeSafe(_1024);
  float _1049 = renodx::color::srgb::DecodeSafe(_1025);
#endif
  float _1075 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1047)) * _1047) + MappingPolynomial.z);
  float _1076 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1048)) * _1048) + MappingPolynomial.z);
  float _1077 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1049)) * _1049) + MappingPolynomial.z);
  float _1084 = ((OverlayColor.x - _1075) * OverlayColor.w) + _1075;
  float _1085 = ((OverlayColor.y - _1076) * OverlayColor.w) + _1076;
  float _1086 = ((OverlayColor.z - _1077) * OverlayColor.w) + _1077;

#if 1
  if (GenerateOutput(_1084, _1085, _1086, SV_Target, OutputDevice)) {
    return SV_Target;
  }
#endif

  float _1087 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _542, mad((WorkingColorSpace.FromAP1[0].y), _540, (_538 * (WorkingColorSpace.FromAP1[0].x))));
  float _1088 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _542, mad((WorkingColorSpace.FromAP1[1].y), _540, ((WorkingColorSpace.FromAP1[1].x) * _538)));
  float _1089 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _542, mad((WorkingColorSpace.FromAP1[2].y), _540, ((WorkingColorSpace.FromAP1[2].x) * _538)));
  float _1096 = ((OverlayColor.x - _1087) * OverlayColor.w) + _1087;
  float _1097 = ((OverlayColor.y - _1088) * OverlayColor.w) + _1088;
  float _1098 = ((OverlayColor.z - _1089) * OverlayColor.w) + _1089;
  float _1110 = exp2(log2(max(0.0f, _1084)) * InverseGamma.y);
  float _1111 = exp2(log2(max(0.0f, _1085)) * InverseGamma.y);
  float _1112 = exp2(log2(max(0.0f, _1086)) * InverseGamma.y);
  [branch]
  if (output_device == 0) {
    do {
      if (WorkingColorSpace.bIsSRGB == 0) {
        float _1135 = mad((WorkingColorSpace.ToAP1[0].z), _1112, mad((WorkingColorSpace.ToAP1[0].y), _1111, ((WorkingColorSpace.ToAP1[0].x) * _1110)));
        float _1138 = mad((WorkingColorSpace.ToAP1[1].z), _1112, mad((WorkingColorSpace.ToAP1[1].y), _1111, ((WorkingColorSpace.ToAP1[1].x) * _1110)));
        float _1141 = mad((WorkingColorSpace.ToAP1[2].z), _1112, mad((WorkingColorSpace.ToAP1[2].y), _1111, ((WorkingColorSpace.ToAP1[2].x) * _1110)));
        _1152 = mad(_49, _1141, mad(_48, _1138, (_1135 * _47)));
        _1153 = mad(_52, _1141, mad(_51, _1138, (_1135 * _50)));
        _1154 = mad(_55, _1141, mad(_54, _1138, (_1135 * _53)));
      } else {
        _1152 = _1110;
        _1153 = _1111;
        _1154 = _1112;
      }
      do {
        if (_1152 < 0.0031306699384003878f) {
          _1165 = (_1152 * 12.920000076293945f);
        } else {
          _1165 = (((pow(_1152, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1153 < 0.0031306699384003878f) {
            _1176 = (_1153 * 12.920000076293945f);
          } else {
            _1176 = (((pow(_1153, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1154 < 0.0031306699384003878f) {
            _2732 = _1165;
            _2733 = _1176;
            _2734 = (_1154 * 12.920000076293945f);
          } else {
            _2732 = _1165;
            _2733 = _1176;
            _2734 = (((pow(_1154, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1203 = mad((WorkingColorSpace.ToAP1[0].z), _1112, mad((WorkingColorSpace.ToAP1[0].y), _1111, ((WorkingColorSpace.ToAP1[0].x) * _1110)));
      float _1206 = mad((WorkingColorSpace.ToAP1[1].z), _1112, mad((WorkingColorSpace.ToAP1[1].y), _1111, ((WorkingColorSpace.ToAP1[1].x) * _1110)));
      float _1209 = mad((WorkingColorSpace.ToAP1[2].z), _1112, mad((WorkingColorSpace.ToAP1[2].y), _1111, ((WorkingColorSpace.ToAP1[2].x) * _1110)));
      float _1219 = max(6.103519990574569e-05f, mad(_49, _1209, mad(_48, _1206, (_1203 * _47))));
      float _1220 = max(6.103519990574569e-05f, mad(_52, _1209, mad(_51, _1206, (_1203 * _50))));
      float _1221 = max(6.103519990574569e-05f, mad(_55, _1209, mad(_54, _1206, (_1203 * _53))));
      _2732 = min((_1219 * 4.5f), ((exp2(log2(max(_1219, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2733 = min((_1220 * 4.5f), ((exp2(log2(max(_1220, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2734 = min((_1221 * 4.5f), ((exp2(log2(max(_1221, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
        _14[0] = ACESCoefsLow_0.x;
        _14[1] = ACESCoefsLow_0.y;
        _14[2] = ACESCoefsLow_0.z;
        _14[3] = ACESCoefsLow_0.w;
        _14[4] = ACESCoefsLow_4;
        _14[5] = ACESCoefsLow_4;
        _15[0] = ACESCoefsHigh_0.x;
        _15[1] = ACESCoefsHigh_0.y;
        _15[2] = ACESCoefsHigh_0.z;
        _15[3] = ACESCoefsHigh_0.w;
        _15[4] = ACESCoefsHigh_4;
        _15[5] = ACESCoefsHigh_4;
        float _1297 = ACESSceneColorMultiplier * _1096;
        float _1298 = ACESSceneColorMultiplier * _1097;
        float _1299 = ACESSceneColorMultiplier * _1098;
        float _1302 = mad((WorkingColorSpace.ToAP0[0].z), _1299, mad((WorkingColorSpace.ToAP0[0].y), _1298, ((WorkingColorSpace.ToAP0[0].x) * _1297)));
        float _1305 = mad((WorkingColorSpace.ToAP0[1].z), _1299, mad((WorkingColorSpace.ToAP0[1].y), _1298, ((WorkingColorSpace.ToAP0[1].x) * _1297)));
        float _1308 = mad((WorkingColorSpace.ToAP0[2].z), _1299, mad((WorkingColorSpace.ToAP0[2].y), _1298, ((WorkingColorSpace.ToAP0[2].x) * _1297)));
        float _1311 = mad(-0.21492856740951538f, _1308, mad(-0.2365107536315918f, _1305, (_1302 * 1.4514392614364624f)));
        float _1314 = mad(-0.09967592358589172f, _1308, mad(1.17622971534729f, _1305, (_1302 * -0.07655377686023712f)));
        float _1317 = mad(0.9977163076400757f, _1308, mad(-0.006032449658960104f, _1305, (_1302 * 0.008316148072481155f)));
        float _1319 = max(_1311, max(_1314, _1317));
        do {
          if (!(_1319 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1302 < 0.0f) || (bool)(_1305 < 0.0f))) || (bool)(_1308 < 0.0f))) {
              float _1329 = abs(_1319);
              float _1330 = (_1319 - _1311) / _1329;
              float _1332 = (_1319 - _1314) / _1329;
              float _1334 = (_1319 - _1317) / _1329;
              do {
                if (!(_1330 < 0.8149999976158142f)) {
                  float _1337 = _1330 + -0.8149999976158142f;
                  _1349 = ((_1337 / exp2(log2(exp2(log2(_1337 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1349 = _1330;
                }
                do {
                  if (!(_1332 < 0.8029999732971191f)) {
                    float _1352 = _1332 + -0.8029999732971191f;
                    _1364 = ((_1352 / exp2(log2(exp2(log2(_1352 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1364 = _1332;
                  }
                  do {
                    if (!(_1334 < 0.8799999952316284f)) {
                      float _1367 = _1334 + -0.8799999952316284f;
                      _1379 = ((_1367 / exp2(log2(exp2(log2(_1367 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1379 = _1334;
                    }
                    _1387 = (_1319 - (_1329 * _1349));
                    _1388 = (_1319 - (_1329 * _1364));
                    _1389 = (_1319 - (_1329 * _1379));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1387 = _1311;
              _1388 = _1314;
              _1389 = _1317;
            }
          } else {
            _1387 = _1311;
            _1388 = _1314;
            _1389 = _1317;
          }
          float _1405 = ((mad(0.16386906802654266f, _1389, mad(0.14067870378494263f, _1388, (_1387 * 0.6954522132873535f))) - _1302) * ACESGamutCompression) + _1302;
          float _1406 = ((mad(0.0955343171954155f, _1389, mad(0.8596711158752441f, _1388, (_1387 * 0.044794563204050064f))) - _1305) * ACESGamutCompression) + _1305;
          float _1407 = ((mad(1.0015007257461548f, _1389, mad(0.004025210160762072f, _1388, (_1387 * -0.005525882821530104f))) - _1308) * ACESGamutCompression) + _1308;
          float _1411 = max(max(_1405, _1406), _1407);
          float _1416 = (max(_1411, 1.000000013351432e-10f) - max(min(min(_1405, _1406), _1407), 1.000000013351432e-10f)) / max(_1411, 0.009999999776482582f);
          float _1429 = ((_1406 + _1405) + _1407) + (sqrt((((_1407 - _1406) * _1407) + ((_1406 - _1405) * _1406)) + ((_1405 - _1407) * _1405)) * 1.75f);
          float _1430 = _1429 * 0.3333333432674408f;
          float _1431 = _1416 + -0.4000000059604645f;
          float _1432 = _1431 * 5.0f;
          float _1436 = max((1.0f - abs(_1431 * 2.5f)), 0.0f);
          float _1447 = ((float((int)(((int)(uint)((bool)(_1432 > 0.0f))) - ((int)(uint)((bool)(_1432 < 0.0f))))) * (1.0f - (_1436 * _1436))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1430 <= 0.0533333346247673f)) {
              if (!(_1430 >= 0.1599999964237213f)) {
                _1456 = (((0.23999999463558197f / _1429) + -0.5f) * _1447);
              } else {
                _1456 = 0.0f;
              }
            } else {
              _1456 = _1447;
            }
            float _1457 = _1456 + 1.0f;
            float _1458 = _1457 * _1405;
            float _1459 = _1457 * _1406;
            float _1460 = _1457 * _1407;
            do {
              if (!((bool)(_1458 == _1459) && (bool)(_1459 == _1460))) {
                float _1467 = ((_1458 * 2.0f) - _1459) - _1460;
                float _1470 = ((_1406 - _1407) * 1.7320507764816284f) * _1457;
                float _1472 = atan(_1470 / _1467);
                bool _1475 = (_1467 < 0.0f);
                bool _1476 = (_1467 == 0.0f);
                bool _1477 = (_1470 >= 0.0f);
                bool _1478 = (_1470 < 0.0f);
                _1489 = select((_1477 && _1476), 90.0f, select((_1478 && _1476), -90.0f, (select((_1478 && _1475), (_1472 + -3.1415927410125732f), select((_1477 && _1475), (_1472 + 3.1415927410125732f), _1472)) * 57.2957763671875f)));
              } else {
                _1489 = 0.0f;
              }
              float _1494 = min(max(select((_1489 < 0.0f), (_1489 + 360.0f), _1489), 0.0f), 360.0f);
              do {
                if (_1494 < -180.0f) {
                  _1503 = (_1494 + 360.0f);
                } else {
                  if (_1494 > 180.0f) {
                    _1503 = (_1494 + -360.0f);
                  } else {
                    _1503 = _1494;
                  }
                }
                do {
                  if ((bool)(_1503 > -67.5f) && (bool)(_1503 < 67.5f)) {
                    float _1509 = (_1503 + 67.5f) * 0.029629629105329514f;
                    int _1510 = int(_1509);
                    float _1512 = _1509 - float((int)(_1510));
                    float _1513 = _1512 * _1512;
                    float _1514 = _1513 * _1512;
                    if (_1510 == 3) {
                      _1542 = (((0.1666666716337204f - (_1512 * 0.5f)) + (_1513 * 0.5f)) - (_1514 * 0.1666666716337204f));
                    } else {
                      if (_1510 == 2) {
                        _1542 = ((0.6666666865348816f - _1513) + (_1514 * 0.5f));
                      } else {
                        if (_1510 == 1) {
                          _1542 = (((_1514 * -0.5f) + 0.1666666716337204f) + ((_1513 + _1512) * 0.5f));
                        } else {
                          _1542 = select((_1510 == 0), (_1514 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1542 = 0.0f;
                  }
                  float _1551 = min(max(((((_1416 * 0.27000001072883606f) * (0.029999999329447746f - _1458)) * _1542) + _1458), 0.0f), 65535.0f);
                  float _1552 = min(max(_1459, 0.0f), 65535.0f);
                  float _1553 = min(max(_1460, 0.0f), 65535.0f);
                  float _1566 = min(max(mad(-0.21492856740951538f, _1553, mad(-0.2365107536315918f, _1552, (_1551 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1567 = min(max(mad(-0.09967592358589172f, _1553, mad(1.17622971534729f, _1552, (_1551 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1568 = min(max(mad(0.9977163076400757f, _1553, mad(-0.006032449658960104f, _1552, (_1551 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1569 = dot(float3(_1566, _1567, _1568), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1580 = log2(max((lerp(_1569, _1566, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1581 = _1580 * 0.3010300099849701f;
                  float _1582 = log2(ACESMinMaxData.x);
                  float _1583 = _1582 * 0.3010300099849701f;
                  do {
                    if (!(!(_1581 <= _1583))) {
                      _1652 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1590 = log2(ACESMidData.x);
                      float _1591 = _1590 * 0.3010300099849701f;
                      if ((bool)(_1581 > _1583) && (bool)(_1581 < _1591)) {
                        float _1599 = ((_1580 - _1582) * 0.9030900001525879f) / ((_1590 - _1582) * 0.3010300099849701f);
                        int _1600 = int(_1599);
                        float _1602 = _1599 - float((int)(_1600));
                        float _1604 = _14[_1600];
                        float _1607 = _14[(_1600 + 1)];
                        float _1612 = _1604 * 0.5f;
                        _1652 = dot(float3((_1602 * _1602), _1602, 1.0f), float3(mad((_14[(_1600 + 2)]), 0.5f, mad(_1607, -1.0f, _1612)), (_1607 - _1604), mad(_1607, 0.5f, _1612)));
                      } else {
                        do {
                          if (!(!(_1581 >= _1591))) {
                            float _1621 = log2(ACESMinMaxData.z);
                            if (_1581 < (_1621 * 0.3010300099849701f)) {
                              float _1629 = ((_1580 - _1590) * 0.9030900001525879f) / ((_1621 - _1590) * 0.3010300099849701f);
                              int _1630 = int(_1629);
                              float _1632 = _1629 - float((int)(_1630));
                              float _1634 = _15[_1630];
                              float _1637 = _15[(_1630 + 1)];
                              float _1642 = _1634 * 0.5f;
                              _1652 = dot(float3((_1632 * _1632), _1632, 1.0f), float3(mad((_15[(_1630 + 2)]), 0.5f, mad(_1637, -1.0f, _1642)), (_1637 - _1634), mad(_1637, 0.5f, _1642)));
                              break;
                            }
                          }
                          _1652 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1656 = log2(max((lerp(_1569, _1567, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1657 = _1656 * 0.3010300099849701f;
                    do {
                      if (!(!(_1657 <= _1583))) {
                        _1726 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1664 = log2(ACESMidData.x);
                        float _1665 = _1664 * 0.3010300099849701f;
                        if ((bool)(_1657 > _1583) && (bool)(_1657 < _1665)) {
                          float _1673 = ((_1656 - _1582) * 0.9030900001525879f) / ((_1664 - _1582) * 0.3010300099849701f);
                          int _1674 = int(_1673);
                          float _1676 = _1673 - float((int)(_1674));
                          float _1678 = _14[_1674];
                          float _1681 = _14[(_1674 + 1)];
                          float _1686 = _1678 * 0.5f;
                          _1726 = dot(float3((_1676 * _1676), _1676, 1.0f), float3(mad((_14[(_1674 + 2)]), 0.5f, mad(_1681, -1.0f, _1686)), (_1681 - _1678), mad(_1681, 0.5f, _1686)));
                        } else {
                          do {
                            if (!(!(_1657 >= _1665))) {
                              float _1695 = log2(ACESMinMaxData.z);
                              if (_1657 < (_1695 * 0.3010300099849701f)) {
                                float _1703 = ((_1656 - _1664) * 0.9030900001525879f) / ((_1695 - _1664) * 0.3010300099849701f);
                                int _1704 = int(_1703);
                                float _1706 = _1703 - float((int)(_1704));
                                float _1708 = _15[_1704];
                                float _1711 = _15[(_1704 + 1)];
                                float _1716 = _1708 * 0.5f;
                                _1726 = dot(float3((_1706 * _1706), _1706, 1.0f), float3(mad((_15[(_1704 + 2)]), 0.5f, mad(_1711, -1.0f, _1716)), (_1711 - _1708), mad(_1711, 0.5f, _1716)));
                                break;
                              }
                            }
                            _1726 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1730 = log2(max((lerp(_1569, _1568, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1731 = _1730 * 0.3010300099849701f;
                      do {
                        if (!(!(_1731 <= _1583))) {
                          _1800 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1738 = log2(ACESMidData.x);
                          float _1739 = _1738 * 0.3010300099849701f;
                          if ((bool)(_1731 > _1583) && (bool)(_1731 < _1739)) {
                            float _1747 = ((_1730 - _1582) * 0.9030900001525879f) / ((_1738 - _1582) * 0.3010300099849701f);
                            int _1748 = int(_1747);
                            float _1750 = _1747 - float((int)(_1748));
                            float _1752 = _14[_1748];
                            float _1755 = _14[(_1748 + 1)];
                            float _1760 = _1752 * 0.5f;
                            _1800 = dot(float3((_1750 * _1750), _1750, 1.0f), float3(mad((_14[(_1748 + 2)]), 0.5f, mad(_1755, -1.0f, _1760)), (_1755 - _1752), mad(_1755, 0.5f, _1760)));
                          } else {
                            do {
                              if (!(!(_1731 >= _1739))) {
                                float _1769 = log2(ACESMinMaxData.z);
                                if (_1731 < (_1769 * 0.3010300099849701f)) {
                                  float _1777 = ((_1730 - _1738) * 0.9030900001525879f) / ((_1769 - _1738) * 0.3010300099849701f);
                                  int _1778 = int(_1777);
                                  float _1780 = _1777 - float((int)(_1778));
                                  float _1782 = _15[_1778];
                                  float _1785 = _15[(_1778 + 1)];
                                  float _1790 = _1782 * 0.5f;
                                  _1800 = dot(float3((_1780 * _1780), _1780, 1.0f), float3(mad((_15[(_1778 + 2)]), 0.5f, mad(_1785, -1.0f, _1790)), (_1785 - _1782), mad(_1785, 0.5f, _1790)));
                                  break;
                                }
                              }
                              _1800 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1804 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1805 = (exp2(_1652 * 3.321928024291992f) - ACESMinMaxData.y) / _1804;
                        float _1807 = (exp2(_1726 * 3.321928024291992f) - ACESMinMaxData.y) / _1804;
                        float _1809 = (exp2(_1800 * 3.321928024291992f) - ACESMinMaxData.y) / _1804;
                        float _1812 = mad(0.15618768334388733f, _1809, mad(0.13400420546531677f, _1807, (_1805 * 0.6624541878700256f)));
                        float _1815 = mad(0.053689517080783844f, _1809, mad(0.6740817427635193f, _1807, (_1805 * 0.2722287178039551f)));
                        float _1818 = mad(1.0103391408920288f, _1809, mad(0.00406073359772563f, _1807, (_1805 * -0.005574649665504694f)));
                        float _1831 = min(max(mad(-0.23642469942569733f, _1818, mad(-0.32480329275131226f, _1815, (_1812 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1832 = min(max(mad(0.016756348311901093f, _1818, mad(1.6153316497802734f, _1815, (_1812 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1833 = min(max(mad(0.9883948564529419f, _1818, mad(-0.008284442126750946f, _1815, (_1812 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1836 = mad(0.15618768334388733f, _1833, mad(0.13400420546531677f, _1832, (_1831 * 0.6624541878700256f)));
                        float _1839 = mad(0.053689517080783844f, _1833, mad(0.6740817427635193f, _1832, (_1831 * 0.2722287178039551f)));
                        float _1842 = mad(1.0103391408920288f, _1833, mad(0.00406073359772563f, _1832, (_1831 * -0.005574649665504694f)));
                        float _1864 = min(max((min(max(mad(-0.23642469942569733f, _1842, mad(-0.32480329275131226f, _1839, (_1836 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1865 = min(max((min(max(mad(0.016756348311901093f, _1842, mad(1.6153316497802734f, _1839, (_1836 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1866 = min(max((min(max(mad(0.9883948564529419f, _1842, mad(-0.008284442126750946f, _1839, (_1836 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 5)) {
                            _1879 = mad(_49, _1866, mad(_48, _1865, (_1864 * _47)));
                            _1880 = mad(_52, _1866, mad(_51, _1865, (_1864 * _50)));
                            _1881 = mad(_55, _1866, mad(_54, _1865, (_1864 * _53)));
                          } else {
                            _1879 = _1864;
                            _1880 = _1865;
                            _1881 = _1866;
                          }
                          float _1891 = exp2(log2(_1879 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1892 = exp2(log2(_1880 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1893 = exp2(log2(_1881 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2732 = exp2(log2((1.0f / ((_1891 * 18.6875f) + 1.0f)) * ((_1891 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2733 = exp2(log2((1.0f / ((_1892 * 18.6875f) + 1.0f)) * ((_1892 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2734 = exp2(log2((1.0f / ((_1893 * 18.6875f) + 1.0f)) * ((_1893 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((output_device & -3) == 4) {
          _12[0] = ACESCoefsLow_0.x;
          _12[1] = ACESCoefsLow_0.y;
          _12[2] = ACESCoefsLow_0.z;
          _12[3] = ACESCoefsLow_0.w;
          _12[4] = ACESCoefsLow_4;
          _12[5] = ACESCoefsLow_4;
          _13[0] = ACESCoefsHigh_0.x;
          _13[1] = ACESCoefsHigh_0.y;
          _13[2] = ACESCoefsHigh_0.z;
          _13[3] = ACESCoefsHigh_0.w;
          _13[4] = ACESCoefsHigh_4;
          _13[5] = ACESCoefsHigh_4;
          float _1971 = ACESSceneColorMultiplier * _1096;
          float _1972 = ACESSceneColorMultiplier * _1097;
          float _1973 = ACESSceneColorMultiplier * _1098;
          float _1976 = mad((WorkingColorSpace.ToAP0[0].z), _1973, mad((WorkingColorSpace.ToAP0[0].y), _1972, ((WorkingColorSpace.ToAP0[0].x) * _1971)));
          float _1979 = mad((WorkingColorSpace.ToAP0[1].z), _1973, mad((WorkingColorSpace.ToAP0[1].y), _1972, ((WorkingColorSpace.ToAP0[1].x) * _1971)));
          float _1982 = mad((WorkingColorSpace.ToAP0[2].z), _1973, mad((WorkingColorSpace.ToAP0[2].y), _1972, ((WorkingColorSpace.ToAP0[2].x) * _1971)));
          float _1985 = mad(-0.21492856740951538f, _1982, mad(-0.2365107536315918f, _1979, (_1976 * 1.4514392614364624f)));
          float _1988 = mad(-0.09967592358589172f, _1982, mad(1.17622971534729f, _1979, (_1976 * -0.07655377686023712f)));
          float _1991 = mad(0.9977163076400757f, _1982, mad(-0.006032449658960104f, _1979, (_1976 * 0.008316148072481155f)));
          float _1993 = max(_1985, max(_1988, _1991));
          do {
            if (!(_1993 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1976 < 0.0f) || (bool)(_1979 < 0.0f))) || (bool)(_1982 < 0.0f))) {
                float _2003 = abs(_1993);
                float _2004 = (_1993 - _1985) / _2003;
                float _2006 = (_1993 - _1988) / _2003;
                float _2008 = (_1993 - _1991) / _2003;
                do {
                  if (!(_2004 < 0.8149999976158142f)) {
                    float _2011 = _2004 + -0.8149999976158142f;
                    _2023 = ((_2011 / exp2(log2(exp2(log2(_2011 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2023 = _2004;
                  }
                  do {
                    if (!(_2006 < 0.8029999732971191f)) {
                      float _2026 = _2006 + -0.8029999732971191f;
                      _2038 = ((_2026 / exp2(log2(exp2(log2(_2026 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2038 = _2006;
                    }
                    do {
                      if (!(_2008 < 0.8799999952316284f)) {
                        float _2041 = _2008 + -0.8799999952316284f;
                        _2053 = ((_2041 / exp2(log2(exp2(log2(_2041 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2053 = _2008;
                      }
                      _2061 = (_1993 - (_2003 * _2023));
                      _2062 = (_1993 - (_2003 * _2038));
                      _2063 = (_1993 - (_2003 * _2053));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2061 = _1985;
                _2062 = _1988;
                _2063 = _1991;
              }
            } else {
              _2061 = _1985;
              _2062 = _1988;
              _2063 = _1991;
            }
            float _2079 = ((mad(0.16386906802654266f, _2063, mad(0.14067870378494263f, _2062, (_2061 * 0.6954522132873535f))) - _1976) * ACESGamutCompression) + _1976;
            float _2080 = ((mad(0.0955343171954155f, _2063, mad(0.8596711158752441f, _2062, (_2061 * 0.044794563204050064f))) - _1979) * ACESGamutCompression) + _1979;
            float _2081 = ((mad(1.0015007257461548f, _2063, mad(0.004025210160762072f, _2062, (_2061 * -0.005525882821530104f))) - _1982) * ACESGamutCompression) + _1982;
            float _2085 = max(max(_2079, _2080), _2081);
            float _2090 = (max(_2085, 1.000000013351432e-10f) - max(min(min(_2079, _2080), _2081), 1.000000013351432e-10f)) / max(_2085, 0.009999999776482582f);
            float _2103 = ((_2080 + _2079) + _2081) + (sqrt((((_2081 - _2080) * _2081) + ((_2080 - _2079) * _2080)) + ((_2079 - _2081) * _2079)) * 1.75f);
            float _2104 = _2103 * 0.3333333432674408f;
            float _2105 = _2090 + -0.4000000059604645f;
            float _2106 = _2105 * 5.0f;
            float _2110 = max((1.0f - abs(_2105 * 2.5f)), 0.0f);
            float _2121 = ((float((int)(((int)(uint)((bool)(_2106 > 0.0f))) - ((int)(uint)((bool)(_2106 < 0.0f))))) * (1.0f - (_2110 * _2110))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2104 <= 0.0533333346247673f)) {
                if (!(_2104 >= 0.1599999964237213f)) {
                  _2130 = (((0.23999999463558197f / _2103) + -0.5f) * _2121);
                } else {
                  _2130 = 0.0f;
                }
              } else {
                _2130 = _2121;
              }
              float _2131 = _2130 + 1.0f;
              float _2132 = _2131 * _2079;
              float _2133 = _2131 * _2080;
              float _2134 = _2131 * _2081;
              do {
                if (!((bool)(_2132 == _2133) && (bool)(_2133 == _2134))) {
                  float _2141 = ((_2132 * 2.0f) - _2133) - _2134;
                  float _2144 = ((_2080 - _2081) * 1.7320507764816284f) * _2131;
                  float _2146 = atan(_2144 / _2141);
                  bool _2149 = (_2141 < 0.0f);
                  bool _2150 = (_2141 == 0.0f);
                  bool _2151 = (_2144 >= 0.0f);
                  bool _2152 = (_2144 < 0.0f);
                  _2163 = select((_2151 && _2150), 90.0f, select((_2152 && _2150), -90.0f, (select((_2152 && _2149), (_2146 + -3.1415927410125732f), select((_2151 && _2149), (_2146 + 3.1415927410125732f), _2146)) * 57.2957763671875f)));
                } else {
                  _2163 = 0.0f;
                }
                float _2168 = min(max(select((_2163 < 0.0f), (_2163 + 360.0f), _2163), 0.0f), 360.0f);
                do {
                  if (_2168 < -180.0f) {
                    _2177 = (_2168 + 360.0f);
                  } else {
                    if (_2168 > 180.0f) {
                      _2177 = (_2168 + -360.0f);
                    } else {
                      _2177 = _2168;
                    }
                  }
                  do {
                    if ((bool)(_2177 > -67.5f) && (bool)(_2177 < 67.5f)) {
                      float _2183 = (_2177 + 67.5f) * 0.029629629105329514f;
                      int _2184 = int(_2183);
                      float _2186 = _2183 - float((int)(_2184));
                      float _2187 = _2186 * _2186;
                      float _2188 = _2187 * _2186;
                      if (_2184 == 3) {
                        _2216 = (((0.1666666716337204f - (_2186 * 0.5f)) + (_2187 * 0.5f)) - (_2188 * 0.1666666716337204f));
                      } else {
                        if (_2184 == 2) {
                          _2216 = ((0.6666666865348816f - _2187) + (_2188 * 0.5f));
                        } else {
                          if (_2184 == 1) {
                            _2216 = (((_2188 * -0.5f) + 0.1666666716337204f) + ((_2187 + _2186) * 0.5f));
                          } else {
                            _2216 = select((_2184 == 0), (_2188 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2216 = 0.0f;
                    }
                    float _2225 = min(max(((((_2090 * 0.27000001072883606f) * (0.029999999329447746f - _2132)) * _2216) + _2132), 0.0f), 65535.0f);
                    float _2226 = min(max(_2133, 0.0f), 65535.0f);
                    float _2227 = min(max(_2134, 0.0f), 65535.0f);
                    float _2240 = min(max(mad(-0.21492856740951538f, _2227, mad(-0.2365107536315918f, _2226, (_2225 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2241 = min(max(mad(-0.09967592358589172f, _2227, mad(1.17622971534729f, _2226, (_2225 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2242 = min(max(mad(0.9977163076400757f, _2227, mad(-0.006032449658960104f, _2226, (_2225 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2243 = dot(float3(_2240, _2241, _2242), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2254 = log2(max((lerp(_2243, _2240, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2255 = _2254 * 0.3010300099849701f;
                    float _2256 = log2(ACESMinMaxData.x);
                    float _2257 = _2256 * 0.3010300099849701f;
                    do {
                      if (!(!(_2255 <= _2257))) {
                        _2326 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2264 = log2(ACESMidData.x);
                        float _2265 = _2264 * 0.3010300099849701f;
                        if ((bool)(_2255 > _2257) && (bool)(_2255 < _2265)) {
                          float _2273 = ((_2254 - _2256) * 0.9030900001525879f) / ((_2264 - _2256) * 0.3010300099849701f);
                          int _2274 = int(_2273);
                          float _2276 = _2273 - float((int)(_2274));
                          float _2278 = _12[_2274];
                          float _2281 = _12[(_2274 + 1)];
                          float _2286 = _2278 * 0.5f;
                          _2326 = dot(float3((_2276 * _2276), _2276, 1.0f), float3(mad((_12[(_2274 + 2)]), 0.5f, mad(_2281, -1.0f, _2286)), (_2281 - _2278), mad(_2281, 0.5f, _2286)));
                        } else {
                          do {
                            if (!(!(_2255 >= _2265))) {
                              float _2295 = log2(ACESMinMaxData.z);
                              if (_2255 < (_2295 * 0.3010300099849701f)) {
                                float _2303 = ((_2254 - _2264) * 0.9030900001525879f) / ((_2295 - _2264) * 0.3010300099849701f);
                                int _2304 = int(_2303);
                                float _2306 = _2303 - float((int)(_2304));
                                float _2308 = _13[_2304];
                                float _2311 = _13[(_2304 + 1)];
                                float _2316 = _2308 * 0.5f;
                                _2326 = dot(float3((_2306 * _2306), _2306, 1.0f), float3(mad((_13[(_2304 + 2)]), 0.5f, mad(_2311, -1.0f, _2316)), (_2311 - _2308), mad(_2311, 0.5f, _2316)));
                                break;
                              }
                            }
                            _2326 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2330 = log2(max((lerp(_2243, _2241, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2331 = _2330 * 0.3010300099849701f;
                      do {
                        if (!(!(_2331 <= _2257))) {
                          _2400 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2338 = log2(ACESMidData.x);
                          float _2339 = _2338 * 0.3010300099849701f;
                          if ((bool)(_2331 > _2257) && (bool)(_2331 < _2339)) {
                            float _2347 = ((_2330 - _2256) * 0.9030900001525879f) / ((_2338 - _2256) * 0.3010300099849701f);
                            int _2348 = int(_2347);
                            float _2350 = _2347 - float((int)(_2348));
                            float _2352 = _12[_2348];
                            float _2355 = _12[(_2348 + 1)];
                            float _2360 = _2352 * 0.5f;
                            _2400 = dot(float3((_2350 * _2350), _2350, 1.0f), float3(mad((_12[(_2348 + 2)]), 0.5f, mad(_2355, -1.0f, _2360)), (_2355 - _2352), mad(_2355, 0.5f, _2360)));
                          } else {
                            do {
                              if (!(!(_2331 >= _2339))) {
                                float _2369 = log2(ACESMinMaxData.z);
                                if (_2331 < (_2369 * 0.3010300099849701f)) {
                                  float _2377 = ((_2330 - _2338) * 0.9030900001525879f) / ((_2369 - _2338) * 0.3010300099849701f);
                                  int _2378 = int(_2377);
                                  float _2380 = _2377 - float((int)(_2378));
                                  float _2382 = _13[_2378];
                                  float _2385 = _13[(_2378 + 1)];
                                  float _2390 = _2382 * 0.5f;
                                  _2400 = dot(float3((_2380 * _2380), _2380, 1.0f), float3(mad((_13[(_2378 + 2)]), 0.5f, mad(_2385, -1.0f, _2390)), (_2385 - _2382), mad(_2385, 0.5f, _2390)));
                                  break;
                                }
                              }
                              _2400 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2404 = log2(max((lerp(_2243, _2242, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2405 = _2404 * 0.3010300099849701f;
                        do {
                          if (!(!(_2405 <= _2257))) {
                            _2474 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2412 = log2(ACESMidData.x);
                            float _2413 = _2412 * 0.3010300099849701f;
                            if ((bool)(_2405 > _2257) && (bool)(_2405 < _2413)) {
                              float _2421 = ((_2404 - _2256) * 0.9030900001525879f) / ((_2412 - _2256) * 0.3010300099849701f);
                              int _2422 = int(_2421);
                              float _2424 = _2421 - float((int)(_2422));
                              float _2426 = _12[_2422];
                              float _2429 = _12[(_2422 + 1)];
                              float _2434 = _2426 * 0.5f;
                              _2474 = dot(float3((_2424 * _2424), _2424, 1.0f), float3(mad((_12[(_2422 + 2)]), 0.5f, mad(_2429, -1.0f, _2434)), (_2429 - _2426), mad(_2429, 0.5f, _2434)));
                            } else {
                              do {
                                if (!(!(_2405 >= _2413))) {
                                  float _2443 = log2(ACESMinMaxData.z);
                                  if (_2405 < (_2443 * 0.3010300099849701f)) {
                                    float _2451 = ((_2404 - _2412) * 0.9030900001525879f) / ((_2443 - _2412) * 0.3010300099849701f);
                                    int _2452 = int(_2451);
                                    float _2454 = _2451 - float((int)(_2452));
                                    float _2456 = _13[_2452];
                                    float _2459 = _13[(_2452 + 1)];
                                    float _2464 = _2456 * 0.5f;
                                    _2474 = dot(float3((_2454 * _2454), _2454, 1.0f), float3(mad((_13[(_2452 + 2)]), 0.5f, mad(_2459, -1.0f, _2464)), (_2459 - _2456), mad(_2459, 0.5f, _2464)));
                                    break;
                                  }
                                }
                                _2474 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2478 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2479 = (exp2(_2326 * 3.321928024291992f) - ACESMinMaxData.y) / _2478;
                          float _2481 = (exp2(_2400 * 3.321928024291992f) - ACESMinMaxData.y) / _2478;
                          float _2483 = (exp2(_2474 * 3.321928024291992f) - ACESMinMaxData.y) / _2478;
                          float _2486 = mad(0.15618768334388733f, _2483, mad(0.13400420546531677f, _2481, (_2479 * 0.6624541878700256f)));
                          float _2489 = mad(0.053689517080783844f, _2483, mad(0.6740817427635193f, _2481, (_2479 * 0.2722287178039551f)));
                          float _2492 = mad(1.0103391408920288f, _2483, mad(0.00406073359772563f, _2481, (_2479 * -0.005574649665504694f)));
                          float _2505 = min(max(mad(-0.23642469942569733f, _2492, mad(-0.32480329275131226f, _2489, (_2486 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2506 = min(max(mad(0.016756348311901093f, _2492, mad(1.6153316497802734f, _2489, (_2486 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2507 = min(max(mad(0.9883948564529419f, _2492, mad(-0.008284442126750946f, _2489, (_2486 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2510 = mad(0.15618768334388733f, _2507, mad(0.13400420546531677f, _2506, (_2505 * 0.6624541878700256f)));
                          float _2513 = mad(0.053689517080783844f, _2507, mad(0.6740817427635193f, _2506, (_2505 * 0.2722287178039551f)));
                          float _2516 = mad(1.0103391408920288f, _2507, mad(0.00406073359772563f, _2506, (_2505 * -0.005574649665504694f)));
                          float _2538 = min(max((min(max(mad(-0.23642469942569733f, _2516, mad(-0.32480329275131226f, _2513, (_2510 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2539 = min(max((min(max(mad(0.016756348311901093f, _2516, mad(1.6153316497802734f, _2513, (_2510 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2540 = min(max((min(max(mad(0.9883948564529419f, _2516, mad(-0.008284442126750946f, _2513, (_2510 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(output_device == 6)) {
                              _2553 = mad(_49, _2540, mad(_48, _2539, (_2538 * _47)));
                              _2554 = mad(_52, _2540, mad(_51, _2539, (_2538 * _50)));
                              _2555 = mad(_55, _2540, mad(_54, _2539, (_2538 * _53)));
                            } else {
                              _2553 = _2538;
                              _2554 = _2539;
                              _2555 = _2540;
                            }
                            float _2565 = exp2(log2(_2553 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2566 = exp2(log2(_2554 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2567 = exp2(log2(_2555 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2732 = exp2(log2((1.0f / ((_2565 * 18.6875f) + 1.0f)) * ((_2565 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2733 = exp2(log2((1.0f / ((_2566 * 18.6875f) + 1.0f)) * ((_2566 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2734 = exp2(log2((1.0f / ((_2567 * 18.6875f) + 1.0f)) * ((_2567 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (output_device == 7) {
            float _2612 = mad((WorkingColorSpace.ToAP1[0].z), _1098, mad((WorkingColorSpace.ToAP1[0].y), _1097, ((WorkingColorSpace.ToAP1[0].x) * _1096)));
            float _2615 = mad((WorkingColorSpace.ToAP1[1].z), _1098, mad((WorkingColorSpace.ToAP1[1].y), _1097, ((WorkingColorSpace.ToAP1[1].x) * _1096)));
            float _2618 = mad((WorkingColorSpace.ToAP1[2].z), _1098, mad((WorkingColorSpace.ToAP1[2].y), _1097, ((WorkingColorSpace.ToAP1[2].x) * _1096)));
            float _2637 = exp2(log2(mad(_49, _2618, mad(_48, _2615, (_2612 * _47))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2638 = exp2(log2(mad(_52, _2618, mad(_51, _2615, (_2612 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2639 = exp2(log2(mad(_55, _2618, mad(_54, _2615, (_2612 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2732 = exp2(log2((1.0f / ((_2637 * 18.6875f) + 1.0f)) * ((_2637 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2733 = exp2(log2((1.0f / ((_2638 * 18.6875f) + 1.0f)) * ((_2638 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2734 = exp2(log2((1.0f / ((_2639 * 18.6875f) + 1.0f)) * ((_2639 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2686 = mad((WorkingColorSpace.ToAP1[0].z), _1086, mad((WorkingColorSpace.ToAP1[0].y), _1085, ((WorkingColorSpace.ToAP1[0].x) * _1084)));
                float _2689 = mad((WorkingColorSpace.ToAP1[1].z), _1086, mad((WorkingColorSpace.ToAP1[1].y), _1085, ((WorkingColorSpace.ToAP1[1].x) * _1084)));
                float _2692 = mad((WorkingColorSpace.ToAP1[2].z), _1086, mad((WorkingColorSpace.ToAP1[2].y), _1085, ((WorkingColorSpace.ToAP1[2].x) * _1084)));
                _2732 = mad(_49, _2692, mad(_48, _2689, (_2686 * _47)));
                _2733 = mad(_52, _2692, mad(_51, _2689, (_2686 * _50)));
                _2734 = mad(_55, _2692, mad(_54, _2689, (_2686 * _53)));
              } else {
                float _2705 = mad((WorkingColorSpace.ToAP1[0].z), _1112, mad((WorkingColorSpace.ToAP1[0].y), _1111, ((WorkingColorSpace.ToAP1[0].x) * _1110)));
                float _2708 = mad((WorkingColorSpace.ToAP1[1].z), _1112, mad((WorkingColorSpace.ToAP1[1].y), _1111, ((WorkingColorSpace.ToAP1[1].x) * _1110)));
                float _2711 = mad((WorkingColorSpace.ToAP1[2].z), _1112, mad((WorkingColorSpace.ToAP1[2].y), _1111, ((WorkingColorSpace.ToAP1[2].x) * _1110)));
                _2732 = exp2(log2(mad(_49, _2711, mad(_48, _2708, (_2705 * _47)))) * InverseGamma.z);
                _2733 = exp2(log2(mad(_52, _2711, mad(_51, _2708, (_2705 * _50)))) * InverseGamma.z);
                _2734 = exp2(log2(mad(_55, _2711, mad(_54, _2708, (_2705 * _53)))) * InverseGamma.z);
              }
            } else {
              _2732 = _1096;
              _2733 = _1097;
              _2734 = _1098;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2732 * 0.9523810148239136f);
  SV_Target.y = (_2733 * 0.9523810148239136f);
  SV_Target.z = (_2734 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

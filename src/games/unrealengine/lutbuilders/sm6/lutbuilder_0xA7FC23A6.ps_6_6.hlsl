#include "../../common.hlsl"

// Found in Ready or Not

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

cbuffer _RootShaderParameters : register(b0) {
  float4 LUTWeights[2] : packoffset(c005.x);
  float4 ACESMinMaxData : packoffset(c008.x);
  float4 ACESMidData : packoffset(c009.x);
  float4 ACESCoefsLow_0 : packoffset(c010.x);
  float4 ACESCoefsHigh_0 : packoffset(c011.x);
  float ACESCoefsLow_4 : packoffset(c012.x);
  float ACESCoefsHigh_4 : packoffset(c012.y);
  float ACESSceneColorMultiplier : packoffset(c012.z);
  float4 OverlayColor : packoffset(c013.x);
  float3 ColorScale : packoffset(c014.x);
  float4 ColorSaturation : packoffset(c015.x);
  float4 ColorContrast : packoffset(c016.x);
  float4 ColorGamma : packoffset(c017.x);
  float4 ColorGain : packoffset(c018.x);
  float4 ColorOffset : packoffset(c019.x);
  float4 ColorSaturationShadows : packoffset(c020.x);
  float4 ColorContrastShadows : packoffset(c021.x);
  float4 ColorGammaShadows : packoffset(c022.x);
  float4 ColorGainShadows : packoffset(c023.x);
  float4 ColorOffsetShadows : packoffset(c024.x);
  float4 ColorSaturationMidtones : packoffset(c025.x);
  float4 ColorContrastMidtones : packoffset(c026.x);
  float4 ColorGammaMidtones : packoffset(c027.x);
  float4 ColorGainMidtones : packoffset(c028.x);
  float4 ColorOffsetMidtones : packoffset(c029.x);
  float4 ColorSaturationHighlights : packoffset(c030.x);
  float4 ColorContrastHighlights : packoffset(c031.x);
  float4 ColorGammaHighlights : packoffset(c032.x);
  float4 ColorGainHighlights : packoffset(c033.x);
  float4 ColorOffsetHighlights : packoffset(c034.x);
  float LUTSize : packoffset(c035.x);
  float WhiteTemp : packoffset(c035.y);
  float WhiteTint : packoffset(c035.z);
  float ColorCorrectionShadowsMax : packoffset(c035.w);
  float ColorCorrectionHighlightsMin : packoffset(c036.x);
  float ColorCorrectionHighlightsMax : packoffset(c036.y);
  float BlueCorrection : packoffset(c036.z);
  float ExpandGamut : packoffset(c036.w);
  float ToneCurveAmount : packoffset(c037.x);
  float FilmSlope : packoffset(c037.y);
  float FilmToe : packoffset(c037.z);
  float FilmShoulder : packoffset(c037.w);
  float FilmBlackClip : packoffset(c038.x);
  float FilmWhiteClip : packoffset(c038.y);
  uint bUseMobileTonemapper : packoffset(c038.z);
  uint bIsTemperatureWhiteBalance : packoffset(c038.w);
  float3 MappingPolynomial : packoffset(c039.x);
  float3 InverseGamma : packoffset(c040.x);
  uint OutputDevice : packoffset(c040.w);
  uint OutputGamut : packoffset(c041.x);
  float OutputMaxLuminance : packoffset(c041.y);
};

cbuffer UniformBufferConstants_WorkingColorSpace : register(b1) {
  float4 WorkingColorSpace_ToXYZ[4] : packoffset(c000.x);
  float4 WorkingColorSpace_FromXYZ[4] : packoffset(c004.x);
  float4 WorkingColorSpace_ToAP1[4] : packoffset(c008.x);
  float4 WorkingColorSpace_FromAP1[4] : packoffset(c012.x);
  float4 WorkingColorSpace_ToAP0[4] : packoffset(c016.x);
  uint WorkingColorSpace_bIsSRGB : packoffset(c020.x);
};

SamplerState Samplers_1 : register(s0);

SamplerState Samplers_2 : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _14 = 0.5f / LUTSize;
  float _19 = LUTSize + -1.0f;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _568;
  float _601;
  float _615;
  float _679;
  float _870;
  float _881;
  float _892;
  float _1078;
  float _1079;
  float _1080;
  float _1091;
  float _1102;
  float _1113;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _32 = ((uint)(OutputGamut) == 4);
        _43 = select(_32, 1.0f, 1.705051064491272f);
        _44 = select(_32, 0.0f, -0.6217921376228333f);
        _45 = select(_32, 0.0f, -0.0832589864730835f);
        _46 = select(_32, 0.0f, -0.13025647401809692f);
        _47 = select(_32, 1.0f, 1.140804648399353f);
        _48 = select(_32, 0.0f, -0.010548308491706848f);
        _49 = select(_32, 0.0f, -0.024003351107239723f);
        _50 = select(_32, 0.0f, -0.1289689838886261f);
        _51 = select(_32, 1.0f, 1.1529725790023804f);
      } else {
        _43 = 0.6954522132873535f;
        _44 = 0.14067870378494263f;
        _45 = 0.16386906802654266f;
        _46 = 0.044794563204050064f;
        _47 = 0.8596711158752441f;
        _48 = 0.0955343171954155f;
        _49 = -0.005525882821530104f;
        _50 = 0.004025210160762072f;
        _51 = 1.0015007257461548f;
      }
    } else {
      _43 = 1.0258246660232544f;
      _44 = -0.020053181797266006f;
      _45 = -0.005771636962890625f;
      _46 = -0.002234415616840124f;
      _47 = 1.0045864582061768f;
      _48 = -0.002352118492126465f;
      _49 = -0.005013350863009691f;
      _50 = -0.025290070101618767f;
      _51 = 1.0303035974502563f;
    }
  } else {
    _43 = 1.3792141675949097f;
    _44 = -0.30886411666870117f;
    _45 = -0.0703500509262085f;
    _46 = -0.06933490186929703f;
    _47 = 1.08229660987854f;
    _48 = -0.012961871922016144f;
    _49 = -0.0021590073592960835f;
    _50 = -0.0454593189060688f;
    _51 = 1.0476183891296387f;
  }
  float _64 = (exp2((((LUTSize * (TEXCOORD.x - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _65 = (exp2((((LUTSize * (TEXCOORD.y - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _66 = (exp2(((float((uint)SV_RenderTargetArrayIndex) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _81 = mad((WorkingColorSpace_ToAP1[0].z), _66, mad((WorkingColorSpace_ToAP1[0].y), _65, ((WorkingColorSpace_ToAP1[0].x) * _64)));
  float _84 = mad((WorkingColorSpace_ToAP1[1].z), _66, mad((WorkingColorSpace_ToAP1[1].y), _65, ((WorkingColorSpace_ToAP1[1].x) * _64)));
  float _87 = mad((WorkingColorSpace_ToAP1[2].z), _66, mad((WorkingColorSpace_ToAP1[2].y), _65, ((WorkingColorSpace_ToAP1[2].x) * _64)));
  float _88 = dot(float3(_81, _84, _87), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _92 = (_81 / _88) + -1.0f;
  float _93 = (_84 / _88) + -1.0f;
  float _94 = (_87 / _88) + -1.0f;
  float _106 = (1.0f - exp2(((_88 * _88) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_92, _93, _94), float3(_92, _93, _94)) * -4.0f));
  float _122 = ((mad(-0.06368321925401688f, _87, mad(-0.3292922377586365f, _84, (_81 * 1.3704125881195068f))) - _81) * _106) + _81;
  float _123 = ((mad(-0.010861365124583244f, _87, mad(1.0970927476882935f, _84, (_81 * -0.08343357592821121f))) - _84) * _106) + _84;
  float _124 = ((mad(1.2036951780319214f, _87, mad(-0.09862580895423889f, _84, (_81 * -0.02579331398010254f))) - _87) * _106) + _87;
  float _125 = dot(float3(_122, _123, _124), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _139 = ColorOffset.w + ColorOffsetShadows.w;
  float _153 = ColorGain.w * ColorGainShadows.w;
  float _167 = ColorGamma.w * ColorGammaShadows.w;
  float _181 = ColorContrast.w * ColorContrastShadows.w;
  float _195 = ColorSaturation.w * ColorSaturationShadows.w;
  float _199 = _122 - _125;
  float _200 = _123 - _125;
  float _201 = _124 - _125;
  float _258 = saturate(_125 / ColorCorrectionShadowsMax);
  float _262 = (_258 * _258) * (3.0f - (_258 * 2.0f));
  float _263 = 1.0f - _262;
  float _272 = ColorOffset.w + ColorOffsetHighlights.w;
  float _281 = ColorGain.w * ColorGainHighlights.w;
  float _290 = ColorGamma.w * ColorGammaHighlights.w;
  float _299 = ColorContrast.w * ColorContrastHighlights.w;
  float _308 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _371 = saturate((_125 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _375 = (_371 * _371) * (3.0f - (_371 * 2.0f));
  float _384 = ColorOffset.w + ColorOffsetMidtones.w;
  float _393 = ColorGain.w * ColorGainMidtones.w;
  float _402 = ColorGamma.w * ColorGammaMidtones.w;
  float _411 = ColorContrast.w * ColorContrastMidtones.w;
  float _420 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _478 = _262 - _375;
  float _489 = ((_375 * (((ColorOffset.x + ColorOffsetHighlights.x) + _272) + (((ColorGain.x * ColorGainHighlights.x) * _281) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _299) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _308) * _199) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _290)))))) + (_263 * (((ColorOffset.x + ColorOffsetShadows.x) + _139) + (((ColorGain.x * ColorGainShadows.x) * _153) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _181) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _195) * _199) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _167))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _384) + (((ColorGain.x * ColorGainMidtones.x) * _393) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _411) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _420) * _199) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _402))))) * _478);
  float _491 = ((_375 * (((ColorOffset.y + ColorOffsetHighlights.y) + _272) + (((ColorGain.y * ColorGainHighlights.y) * _281) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _299) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _308) * _200) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _290)))))) + (_263 * (((ColorOffset.y + ColorOffsetShadows.y) + _139) + (((ColorGain.y * ColorGainShadows.y) * _153) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _181) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _195) * _200) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _167))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _384) + (((ColorGain.y * ColorGainMidtones.y) * _393) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _411) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _420) * _200) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _402))))) * _478);
  float _493 = ((_375 * (((ColorOffset.z + ColorOffsetHighlights.z) + _272) + (((ColorGain.z * ColorGainHighlights.z) * _281) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _299) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _308) * _201) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _290)))))) + (_263 * (((ColorOffset.z + ColorOffsetShadows.z) + _139) + (((ColorGain.z * ColorGainShadows.z) * _153) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _181) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _195) * _201) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _167))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _384) + (((ColorGain.z * ColorGainMidtones.z) * _393) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _411) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _420) * _201) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _402))))) * _478);

  SetUntonemappedAP1(float3(_489, _491, _493));

  float _508 = ((mad(0.061360642313957214f, _493, mad(-4.540197551250458e-09f, _491, (_489 * 0.9386394023895264f))) - _489) * BlueCorrection) + _489;
  float _509 = ((mad(0.169205904006958f, _493, mad(0.8307942152023315f, _491, (_489 * 6.775371730327606e-08f))) - _491) * BlueCorrection) + _491;
  float _510 = (mad(-2.3283064365386963e-10f, _491, (_489 * -9.313225746154785e-10f)) * BlueCorrection) + _493;
  float _513 = mad(0.16386905312538147f, _510, mad(0.14067868888378143f, _509, (_508 * 0.6954522132873535f)));
  float _516 = mad(0.0955343246459961f, _510, mad(0.8596711158752441f, _509, (_508 * 0.044794581830501556f)));
  float _519 = mad(1.0015007257461548f, _510, mad(0.004025210160762072f, _509, (_508 * -0.005525882821530104f)));
  float _523 = max(max(_513, _516), _519);
  float _528 = (max(_523, 1.000000013351432e-10f) - max(min(min(_513, _516), _519), 1.000000013351432e-10f)) / max(_523, 0.009999999776482582f);
  float _541 = ((_516 + _513) + _519) + (sqrt((((_519 - _516) * _519) + ((_516 - _513) * _516)) + ((_513 - _519) * _513)) * 1.75f);
  float _542 = _541 * 0.3333333432674408f;
  float _543 = _528 + -0.4000000059604645f;
  float _544 = _543 * 5.0f;
  float _548 = max((1.0f - abs(_543 * 2.5f)), 0.0f);
  float _559 = ((float(((int)(uint)((bool)(_544 > 0.0f))) - ((int)(uint)((bool)(_544 < 0.0f)))) * (1.0f - (_548 * _548))) + 1.0f) * 0.02500000037252903f;
  if (!(_542 <= 0.0533333346247673f)) {
    if (!(_542 >= 0.1599999964237213f)) {
      _568 = (((0.23999999463558197f / _541) + -0.5f) * _559);
    } else {
      _568 = 0.0f;
    }
  } else {
    _568 = _559;
  }
  float _569 = _568 + 1.0f;
  float _570 = _569 * _513;
  float _571 = _569 * _516;
  float _572 = _569 * _519;
  if (!((bool)(_570 == _571) && (bool)(_571 == _572))) {
    float _579 = ((_570 * 2.0f) - _571) - _572;
    float _582 = ((_516 - _519) * 1.7320507764816284f) * _569;
    float _584 = atan(_582 / _579);
    bool _587 = (_579 < 0.0f);
    bool _588 = (_579 == 0.0f);
    bool _589 = (_582 >= 0.0f);
    bool _590 = (_582 < 0.0f);
    _601 = select((_589 && _588), 90.0f, select((_590 && _588), -90.0f, (select((_590 && _587), (_584 + -3.1415927410125732f), select((_589 && _587), (_584 + 3.1415927410125732f), _584)) * 57.2957763671875f)));
  } else {
    _601 = 0.0f;
  }
  float _606 = min(max(select((_601 < 0.0f), (_601 + 360.0f), _601), 0.0f), 360.0f);
  if (_606 < -180.0f) {
    _615 = (_606 + 360.0f);
  } else {
    if (_606 > 180.0f) {
      _615 = (_606 + -360.0f);
    } else {
      _615 = _606;
    }
  }
  float _619 = saturate(1.0f - abs(_615 * 0.014814814552664757f));
  float _623 = (_619 * _619) * (3.0f - (_619 * 2.0f));
  float _629 = ((_623 * _623) * ((_528 * 0.18000000715255737f) * (0.029999999329447746f - _570))) + _570;
  float _639 = max(0.0f, mad(-0.21492856740951538f, _572, mad(-0.2365107536315918f, _571, (_629 * 1.4514392614364624f))));
  float _640 = max(0.0f, mad(-0.09967592358589172f, _572, mad(1.17622971534729f, _571, (_629 * -0.07655377686023712f))));
  float _641 = max(0.0f, mad(0.9977163076400757f, _572, mad(-0.006032449658960104f, _571, (_629 * 0.008316148072481155f))));
  float _642 = dot(float3(_639, _640, _641), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _657 = (FilmBlackClip + 1.0f) - FilmToe;
  float _659 = FilmWhiteClip + 1.0f;
  float _661 = _659 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _679 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _670 = (FilmBlackClip + 0.18000000715255737f) / _657;
    _679 = (-0.7447274923324585f - ((log2(_670 / (2.0f - _670)) * 0.3465735912322998f) * (_657 / FilmSlope)));
  }
  float _682 = ((1.0f - FilmToe) / FilmSlope) - _679;
  float _684 = (FilmShoulder / FilmSlope) - _682;
  float _688 = log2(lerp(_642, _639, 0.9599999785423279f)) * 0.3010300099849701f;
  float _689 = log2(lerp(_642, _640, 0.9599999785423279f)) * 0.3010300099849701f;
  float _690 = log2(lerp(_642, _641, 0.9599999785423279f)) * 0.3010300099849701f;
  float _694 = FilmSlope * (_688 + _682);
  float _695 = FilmSlope * (_689 + _682);
  float _696 = FilmSlope * (_690 + _682);
  float _697 = _657 * 2.0f;
  float _699 = (FilmSlope * -2.0f) / _657;
  float _700 = _688 - _679;
  float _701 = _689 - _679;
  float _702 = _690 - _679;
  float _721 = _661 * 2.0f;
  float _723 = (FilmSlope * 2.0f) / _661;
  float _748 = select((_688 < _679), ((_697 / (exp2((_700 * 1.4426950216293335f) * _699) + 1.0f)) - FilmBlackClip), _694);
  float _749 = select((_689 < _679), ((_697 / (exp2((_701 * 1.4426950216293335f) * _699) + 1.0f)) - FilmBlackClip), _695);
  float _750 = select((_690 < _679), ((_697 / (exp2((_702 * 1.4426950216293335f) * _699) + 1.0f)) - FilmBlackClip), _696);
  float _757 = _684 - _679;
  float _761 = saturate(_700 / _757);
  float _762 = saturate(_701 / _757);
  float _763 = saturate(_702 / _757);
  bool _764 = (_684 < _679);
  float _768 = select(_764, (1.0f - _761), _761);
  float _769 = select(_764, (1.0f - _762), _762);
  float _770 = select(_764, (1.0f - _763), _763);
  float _789 = (((_768 * _768) * (select((_688 > _684), (_659 - (_721 / (exp2(((_688 - _684) * 1.4426950216293335f) * _723) + 1.0f))), _694) - _748)) * (3.0f - (_768 * 2.0f))) + _748;
  float _790 = (((_769 * _769) * (select((_689 > _684), (_659 - (_721 / (exp2(((_689 - _684) * 1.4426950216293335f) * _723) + 1.0f))), _695) - _749)) * (3.0f - (_769 * 2.0f))) + _749;
  float _791 = (((_770 * _770) * (select((_690 > _684), (_659 - (_721 / (exp2(((_690 - _684) * 1.4426950216293335f) * _723) + 1.0f))), _696) - _750)) * (3.0f - (_770 * 2.0f))) + _750;
  float _792 = dot(float3(_789, _790, _791), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _812 = (ToneCurveAmount * (max(0.0f, (lerp(_792, _789, 0.9300000071525574f))) - _508)) + _508;
  float _813 = (ToneCurveAmount * (max(0.0f, (lerp(_792, _790, 0.9300000071525574f))) - _509)) + _509;
  float _814 = (ToneCurveAmount * (max(0.0f, (lerp(_792, _791, 0.9300000071525574f))) - _510)) + _510;
  float _830 = ((mad(-0.06537103652954102f, _814, mad(1.451815478503704e-06f, _813, (_812 * 1.065374732017517f))) - _812) * BlueCorrection) + _812;
  float _831 = ((mad(-0.20366770029067993f, _814, mad(1.2036634683609009f, _813, (_812 * -2.57161445915699e-07f))) - _813) * BlueCorrection) + _813;
  float _832 = ((mad(0.9999996423721313f, _814, mad(2.0954757928848267e-08f, _813, (_812 * 1.862645149230957e-08f))) - _814) * BlueCorrection) + _814;

  SetTonemappedAP1(_830, _831, _832);

  float _857 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _832, mad((WorkingColorSpace_FromAP1[0].y), _831, ((WorkingColorSpace_FromAP1[0].x) * _830)))));
  float _858 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _832, mad((WorkingColorSpace_FromAP1[1].y), _831, ((WorkingColorSpace_FromAP1[1].x) * _830)))));
  float _859 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _832, mad((WorkingColorSpace_FromAP1[2].y), _831, ((WorkingColorSpace_FromAP1[2].x) * _830)))));
  if (_857 < 0.0031306699384003878f) {
    _870 = (_857 * 12.920000076293945f);
  } else {
    _870 = (((pow(_857, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_858 < 0.0031306699384003878f) {
    _881 = (_858 * 12.920000076293945f);
  } else {
    _881 = (((pow(_858, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_859 < 0.0031306699384003878f) {
    _892 = (_859 * 12.920000076293945f);
  } else {
    _892 = (((pow(_859, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _896 = (_881 * 0.9375f) + 0.03125f;
  float _903 = _892 * 15.0f;
  float _904 = floor(_903);
  float _905 = _903 - _904;
  float _907 = (_904 + ((_870 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _910 = Textures_1.Sample(Samplers_1, float2(_907, _896));
  float _914 = _907 + 0.0625f;
  float4 _917 = Textures_1.Sample(Samplers_1, float2(_914, _896));
  float4 _940 = Textures_2.Sample(Samplers_2, float2(_907, _896));
  float4 _946 = Textures_2.Sample(Samplers_2, float2(_914, _896));
  float _965 = max(6.103519990574569e-05f, ((((lerp(_910.x, _917.x, _905)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _870)) + ((lerp(_940.x, _946.x, _905)) * (LUTWeights[0].z))));
  float _966 = max(6.103519990574569e-05f, ((((lerp(_910.y, _917.y, _905)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _881)) + ((lerp(_940.y, _946.y, _905)) * (LUTWeights[0].z))));
  float _967 = max(6.103519990574569e-05f, ((((lerp(_910.z, _917.z, _905)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _892)) + ((lerp(_940.z, _946.z, _905)) * (LUTWeights[0].z))));
  float _989 = select((_965 > 0.040449999272823334f), exp2(log2((_965 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_965 * 0.07739938050508499f));
  float _990 = select((_966 > 0.040449999272823334f), exp2(log2((_966 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_966 * 0.07739938050508499f));
  float _991 = select((_967 > 0.040449999272823334f), exp2(log2((_967 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_967 * 0.07739938050508499f));
  float _1017 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _989)) * _989) + MappingPolynomial.z);
  float _1018 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _990)) * _990) + MappingPolynomial.z);
  float _1019 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _991)) * _991) + MappingPolynomial.z);
  float _1040 = exp2(log2(max(0.0f, (lerp(_1017, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1041 = exp2(log2(max(0.0f, (lerp(_1018, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1042 = exp2(log2(max(0.0f, (lerp(_1019, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1040, _1041, _1042));
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1061 = mad((WorkingColorSpace_ToAP1[0].z), _1042, mad((WorkingColorSpace_ToAP1[0].y), _1041, ((WorkingColorSpace_ToAP1[0].x) * _1040)));
    float _1064 = mad((WorkingColorSpace_ToAP1[1].z), _1042, mad((WorkingColorSpace_ToAP1[1].y), _1041, ((WorkingColorSpace_ToAP1[1].x) * _1040)));
    float _1067 = mad((WorkingColorSpace_ToAP1[2].z), _1042, mad((WorkingColorSpace_ToAP1[2].y), _1041, ((WorkingColorSpace_ToAP1[2].x) * _1040)));
    _1078 = mad(_45, _1067, mad(_44, _1064, (_1061 * _43)));
    _1079 = mad(_48, _1067, mad(_47, _1064, (_1061 * _46)));
    _1080 = mad(_51, _1067, mad(_50, _1064, (_1061 * _49)));
  } else {
    _1078 = _1040;
    _1079 = _1041;
    _1080 = _1042;
  }
  if (_1078 < 0.0031306699384003878f) {
    _1091 = (_1078 * 12.920000076293945f);
  } else {
    _1091 = (((pow(_1078, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1079 < 0.0031306699384003878f) {
    _1102 = (_1079 * 12.920000076293945f);
  } else {
    _1102 = (((pow(_1079, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1080 < 0.0031306699384003878f) {
    _1113 = (_1080 * 12.920000076293945f);
  } else {
    _1113 = (((pow(_1080, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1091 * 0.9523810148239136f);
  SV_Target.y = (_1102 * 0.9523810148239136f);
  SV_Target.z = (_1113 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

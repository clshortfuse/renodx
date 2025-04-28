#include "../../common.hlsl"

// Found in Ready or Not

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

Texture2D<float4> Textures_3 : register(t2);

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

SamplerState Samplers_3 : register(s2);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _16 = 0.5f / LUTSize;
  float _21 = LUTSize + -1.0f;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _570;
  float _603;
  float _617;
  float _681;
  float _872;
  float _883;
  float _894;
  float _1109;
  float _1110;
  float _1111;
  float _1122;
  float _1133;
  float _1144;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _34 = ((uint)(OutputGamut) == 4);
        _45 = select(_34, 1.0f, 1.705051064491272f);
        _46 = select(_34, 0.0f, -0.6217921376228333f);
        _47 = select(_34, 0.0f, -0.0832589864730835f);
        _48 = select(_34, 0.0f, -0.13025647401809692f);
        _49 = select(_34, 1.0f, 1.140804648399353f);
        _50 = select(_34, 0.0f, -0.010548308491706848f);
        _51 = select(_34, 0.0f, -0.024003351107239723f);
        _52 = select(_34, 0.0f, -0.1289689838886261f);
        _53 = select(_34, 1.0f, 1.1529725790023804f);
      } else {
        _45 = 0.6954522132873535f;
        _46 = 0.14067870378494263f;
        _47 = 0.16386906802654266f;
        _48 = 0.044794563204050064f;
        _49 = 0.8596711158752441f;
        _50 = 0.0955343171954155f;
        _51 = -0.005525882821530104f;
        _52 = 0.004025210160762072f;
        _53 = 1.0015007257461548f;
      }
    } else {
      _45 = 1.0258246660232544f;
      _46 = -0.020053181797266006f;
      _47 = -0.005771636962890625f;
      _48 = -0.002234415616840124f;
      _49 = 1.0045864582061768f;
      _50 = -0.002352118492126465f;
      _51 = -0.005013350863009691f;
      _52 = -0.025290070101618767f;
      _53 = 1.0303035974502563f;
    }
  } else {
    _45 = 1.3792141675949097f;
    _46 = -0.30886411666870117f;
    _47 = -0.0703500509262085f;
    _48 = -0.06933490186929703f;
    _49 = 1.08229660987854f;
    _50 = -0.012961871922016144f;
    _51 = -0.0021590073592960835f;
    _52 = -0.0454593189060688f;
    _53 = 1.0476183891296387f;
  }
  float _66 = (exp2((((LUTSize * (TEXCOORD.x - _16)) / _21) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _67 = (exp2((((LUTSize * (TEXCOORD.y - _16)) / _21) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _68 = (exp2(((float((uint)SV_RenderTargetArrayIndex) / _21) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _83 = mad((WorkingColorSpace_ToAP1[0].z), _68, mad((WorkingColorSpace_ToAP1[0].y), _67, ((WorkingColorSpace_ToAP1[0].x) * _66)));
  float _86 = mad((WorkingColorSpace_ToAP1[1].z), _68, mad((WorkingColorSpace_ToAP1[1].y), _67, ((WorkingColorSpace_ToAP1[1].x) * _66)));
  float _89 = mad((WorkingColorSpace_ToAP1[2].z), _68, mad((WorkingColorSpace_ToAP1[2].y), _67, ((WorkingColorSpace_ToAP1[2].x) * _66)));
  float _90 = dot(float3(_83, _86, _89), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_83, _86, _89));

  float _94 = (_83 / _90) + -1.0f;
  float _95 = (_86 / _90) + -1.0f;
  float _96 = (_89 / _90) + -1.0f;
  float _108 = (1.0f - exp2(((_90 * _90) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_94, _95, _96), float3(_94, _95, _96)) * -4.0f));
  float _124 = ((mad(-0.06368321925401688f, _89, mad(-0.3292922377586365f, _86, (_83 * 1.3704125881195068f))) - _83) * _108) + _83;
  float _125 = ((mad(-0.010861365124583244f, _89, mad(1.0970927476882935f, _86, (_83 * -0.08343357592821121f))) - _86) * _108) + _86;
  float _126 = ((mad(1.2036951780319214f, _89, mad(-0.09862580895423889f, _86, (_83 * -0.02579331398010254f))) - _89) * _108) + _89;
  float _127 = dot(float3(_124, _125, _126), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _141 = ColorOffset.w + ColorOffsetShadows.w;
  float _155 = ColorGain.w * ColorGainShadows.w;
  float _169 = ColorGamma.w * ColorGammaShadows.w;
  float _183 = ColorContrast.w * ColorContrastShadows.w;
  float _197 = ColorSaturation.w * ColorSaturationShadows.w;
  float _201 = _124 - _127;
  float _202 = _125 - _127;
  float _203 = _126 - _127;
  float _260 = saturate(_127 / ColorCorrectionShadowsMax);
  float _264 = (_260 * _260) * (3.0f - (_260 * 2.0f));
  float _265 = 1.0f - _264;
  float _274 = ColorOffset.w + ColorOffsetHighlights.w;
  float _283 = ColorGain.w * ColorGainHighlights.w;
  float _292 = ColorGamma.w * ColorGammaHighlights.w;
  float _301 = ColorContrast.w * ColorContrastHighlights.w;
  float _310 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _373 = saturate((_127 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _377 = (_373 * _373) * (3.0f - (_373 * 2.0f));
  float _386 = ColorOffset.w + ColorOffsetMidtones.w;
  float _395 = ColorGain.w * ColorGainMidtones.w;
  float _404 = ColorGamma.w * ColorGammaMidtones.w;
  float _413 = ColorContrast.w * ColorContrastMidtones.w;
  float _422 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _480 = _264 - _377;
  float _491 = ((_377 * (((ColorOffset.x + ColorOffsetHighlights.x) + _274) + (((ColorGain.x * ColorGainHighlights.x) * _283) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _301) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _310) * _201) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _292)))))) + (_265 * (((ColorOffset.x + ColorOffsetShadows.x) + _141) + (((ColorGain.x * ColorGainShadows.x) * _155) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _183) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _197) * _201) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _169))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _386) + (((ColorGain.x * ColorGainMidtones.x) * _395) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _413) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _422) * _201) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _404))))) * _480);
  float _493 = ((_377 * (((ColorOffset.y + ColorOffsetHighlights.y) + _274) + (((ColorGain.y * ColorGainHighlights.y) * _283) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _301) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _310) * _202) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _292)))))) + (_265 * (((ColorOffset.y + ColorOffsetShadows.y) + _141) + (((ColorGain.y * ColorGainShadows.y) * _155) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _183) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _197) * _202) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _169))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _386) + (((ColorGain.y * ColorGainMidtones.y) * _395) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _413) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _422) * _202) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _404))))) * _480);
  float _495 = ((_377 * (((ColorOffset.z + ColorOffsetHighlights.z) + _274) + (((ColorGain.z * ColorGainHighlights.z) * _283) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _301) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _310) * _203) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _292)))))) + (_265 * (((ColorOffset.z + ColorOffsetShadows.z) + _141) + (((ColorGain.z * ColorGainShadows.z) * _155) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _183) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _197) * _203) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _169))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _386) + (((ColorGain.z * ColorGainMidtones.z) * _395) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _413) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _422) * _203) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _404))))) * _480);

  SetUntonemappedAP1(float3(_491, _493, _495));

  float _510 = ((mad(0.061360642313957214f, _495, mad(-4.540197551250458e-09f, _493, (_491 * 0.9386394023895264f))) - _491) * BlueCorrection) + _491;
  float _511 = ((mad(0.169205904006958f, _495, mad(0.8307942152023315f, _493, (_491 * 6.775371730327606e-08f))) - _493) * BlueCorrection) + _493;
  float _512 = (mad(-2.3283064365386963e-10f, _493, (_491 * -9.313225746154785e-10f)) * BlueCorrection) + _495;
  float _515 = mad(0.16386905312538147f, _512, mad(0.14067868888378143f, _511, (_510 * 0.6954522132873535f)));
  float _518 = mad(0.0955343246459961f, _512, mad(0.8596711158752441f, _511, (_510 * 0.044794581830501556f)));
  float _521 = mad(1.0015007257461548f, _512, mad(0.004025210160762072f, _511, (_510 * -0.005525882821530104f)));
  float _525 = max(max(_515, _518), _521);
  float _530 = (max(_525, 1.000000013351432e-10f) - max(min(min(_515, _518), _521), 1.000000013351432e-10f)) / max(_525, 0.009999999776482582f);
  float _543 = ((_518 + _515) + _521) + (sqrt((((_521 - _518) * _521) + ((_518 - _515) * _518)) + ((_515 - _521) * _515)) * 1.75f);
  float _544 = _543 * 0.3333333432674408f;
  float _545 = _530 + -0.4000000059604645f;
  float _546 = _545 * 5.0f;
  float _550 = max((1.0f - abs(_545 * 2.5f)), 0.0f);
  float _561 = ((float(((int)(uint)((bool)(_546 > 0.0f))) - ((int)(uint)((bool)(_546 < 0.0f)))) * (1.0f - (_550 * _550))) + 1.0f) * 0.02500000037252903f;
  if (!(_544 <= 0.0533333346247673f)) {
    if (!(_544 >= 0.1599999964237213f)) {
      _570 = (((0.23999999463558197f / _543) + -0.5f) * _561);
    } else {
      _570 = 0.0f;
    }
  } else {
    _570 = _561;
  }
  float _571 = _570 + 1.0f;
  float _572 = _571 * _515;
  float _573 = _571 * _518;
  float _574 = _571 * _521;
  if (!((bool)(_572 == _573) && (bool)(_573 == _574))) {
    float _581 = ((_572 * 2.0f) - _573) - _574;
    float _584 = ((_518 - _521) * 1.7320507764816284f) * _571;
    float _586 = atan(_584 / _581);
    bool _589 = (_581 < 0.0f);
    bool _590 = (_581 == 0.0f);
    bool _591 = (_584 >= 0.0f);
    bool _592 = (_584 < 0.0f);
    _603 = select((_591 && _590), 90.0f, select((_592 && _590), -90.0f, (select((_592 && _589), (_586 + -3.1415927410125732f), select((_591 && _589), (_586 + 3.1415927410125732f), _586)) * 57.2957763671875f)));
  } else {
    _603 = 0.0f;
  }
  float _608 = min(max(select((_603 < 0.0f), (_603 + 360.0f), _603), 0.0f), 360.0f);
  if (_608 < -180.0f) {
    _617 = (_608 + 360.0f);
  } else {
    if (_608 > 180.0f) {
      _617 = (_608 + -360.0f);
    } else {
      _617 = _608;
    }
  }
  float _621 = saturate(1.0f - abs(_617 * 0.014814814552664757f));
  float _625 = (_621 * _621) * (3.0f - (_621 * 2.0f));
  float _631 = ((_625 * _625) * ((_530 * 0.18000000715255737f) * (0.029999999329447746f - _572))) + _572;
  float _641 = max(0.0f, mad(-0.21492856740951538f, _574, mad(-0.2365107536315918f, _573, (_631 * 1.4514392614364624f))));
  float _642 = max(0.0f, mad(-0.09967592358589172f, _574, mad(1.17622971534729f, _573, (_631 * -0.07655377686023712f))));
  float _643 = max(0.0f, mad(0.9977163076400757f, _574, mad(-0.006032449658960104f, _573, (_631 * 0.008316148072481155f))));
  float _644 = dot(float3(_641, _642, _643), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _659 = (FilmBlackClip + 1.0f) - FilmToe;
  float _661 = FilmWhiteClip + 1.0f;
  float _663 = _661 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _681 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _672 = (FilmBlackClip + 0.18000000715255737f) / _659;
    _681 = (-0.7447274923324585f - ((log2(_672 / (2.0f - _672)) * 0.3465735912322998f) * (_659 / FilmSlope)));
  }
  float _684 = ((1.0f - FilmToe) / FilmSlope) - _681;
  float _686 = (FilmShoulder / FilmSlope) - _684;
  float _690 = log2(lerp(_644, _641, 0.9599999785423279f)) * 0.3010300099849701f;
  float _691 = log2(lerp(_644, _642, 0.9599999785423279f)) * 0.3010300099849701f;
  float _692 = log2(lerp(_644, _643, 0.9599999785423279f)) * 0.3010300099849701f;
  float _696 = FilmSlope * (_690 + _684);
  float _697 = FilmSlope * (_691 + _684);
  float _698 = FilmSlope * (_692 + _684);
  float _699 = _659 * 2.0f;
  float _701 = (FilmSlope * -2.0f) / _659;
  float _702 = _690 - _681;
  float _703 = _691 - _681;
  float _704 = _692 - _681;
  float _723 = _663 * 2.0f;
  float _725 = (FilmSlope * 2.0f) / _663;
  float _750 = select((_690 < _681), ((_699 / (exp2((_702 * 1.4426950216293335f) * _701) + 1.0f)) - FilmBlackClip), _696);
  float _751 = select((_691 < _681), ((_699 / (exp2((_703 * 1.4426950216293335f) * _701) + 1.0f)) - FilmBlackClip), _697);
  float _752 = select((_692 < _681), ((_699 / (exp2((_704 * 1.4426950216293335f) * _701) + 1.0f)) - FilmBlackClip), _698);
  float _759 = _686 - _681;
  float _763 = saturate(_702 / _759);
  float _764 = saturate(_703 / _759);
  float _765 = saturate(_704 / _759);
  bool _766 = (_686 < _681);
  float _770 = select(_766, (1.0f - _763), _763);
  float _771 = select(_766, (1.0f - _764), _764);
  float _772 = select(_766, (1.0f - _765), _765);
  float _791 = (((_770 * _770) * (select((_690 > _686), (_661 - (_723 / (exp2(((_690 - _686) * 1.4426950216293335f) * _725) + 1.0f))), _696) - _750)) * (3.0f - (_770 * 2.0f))) + _750;
  float _792 = (((_771 * _771) * (select((_691 > _686), (_661 - (_723 / (exp2(((_691 - _686) * 1.4426950216293335f) * _725) + 1.0f))), _697) - _751)) * (3.0f - (_771 * 2.0f))) + _751;
  float _793 = (((_772 * _772) * (select((_692 > _686), (_661 - (_723 / (exp2(((_692 - _686) * 1.4426950216293335f) * _725) + 1.0f))), _698) - _752)) * (3.0f - (_772 * 2.0f))) + _752;
  float _794 = dot(float3(_791, _792, _793), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _814 = (ToneCurveAmount * (max(0.0f, (lerp(_794, _791, 0.9300000071525574f))) - _510)) + _510;
  float _815 = (ToneCurveAmount * (max(0.0f, (lerp(_794, _792, 0.9300000071525574f))) - _511)) + _511;
  float _816 = (ToneCurveAmount * (max(0.0f, (lerp(_794, _793, 0.9300000071525574f))) - _512)) + _512;
  float _832 = ((mad(-0.06537103652954102f, _816, mad(1.451815478503704e-06f, _815, (_814 * 1.065374732017517f))) - _814) * BlueCorrection) + _814;
  float _833 = ((mad(-0.20366770029067993f, _816, mad(1.2036634683609009f, _815, (_814 * -2.57161445915699e-07f))) - _815) * BlueCorrection) + _815;
  float _834 = ((mad(0.9999996423721313f, _816, mad(2.0954757928848267e-08f, _815, (_814 * 1.862645149230957e-08f))) - _816) * BlueCorrection) + _816;

  SetTonemappedAP1(_832, _833, _834);

  float _859 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _834, mad((WorkingColorSpace_FromAP1[0].y), _833, ((WorkingColorSpace_FromAP1[0].x) * _832)))));
  float _860 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _834, mad((WorkingColorSpace_FromAP1[1].y), _833, ((WorkingColorSpace_FromAP1[1].x) * _832)))));
  float _861 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _834, mad((WorkingColorSpace_FromAP1[2].y), _833, ((WorkingColorSpace_FromAP1[2].x) * _832)))));
  if (_859 < 0.0031306699384003878f) {
    _872 = (_859 * 12.920000076293945f);
  } else {
    _872 = (((pow(_859, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_860 < 0.0031306699384003878f) {
    _883 = (_860 * 12.920000076293945f);
  } else {
    _883 = (((pow(_860, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_861 < 0.0031306699384003878f) {
    _894 = (_861 * 12.920000076293945f);
  } else {
    _894 = (((pow(_861, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _898 = (_883 * 0.9375f) + 0.03125f;
  float _905 = _894 * 15.0f;
  float _906 = floor(_905);
  float _907 = _905 - _906;
  float _909 = (_906 + ((_872 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _912 = Textures_1.Sample(Samplers_1, float2(_909, _898));
  float _916 = _909 + 0.0625f;
  float4 _919 = Textures_1.Sample(Samplers_1, float2(_916, _898));
  float4 _942 = Textures_2.Sample(Samplers_2, float2(_909, _898));
  float4 _948 = Textures_2.Sample(Samplers_2, float2(_916, _898));
  float4 _971 = Textures_3.Sample(Samplers_3, float2(_909, _898));
  float4 _977 = Textures_3.Sample(Samplers_3, float2(_916, _898));
  float _996 = max(6.103519990574569e-05f, (((((lerp(_912.x, _919.x, _907)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _872)) + ((lerp(_942.x, _948.x, _907)) * (LUTWeights[0].z))) + ((lerp(_971.x, _977.x, _907)) * (LUTWeights[0].w))));
  float _997 = max(6.103519990574569e-05f, (((((lerp(_912.y, _919.y, _907)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _883)) + ((lerp(_942.y, _948.y, _907)) * (LUTWeights[0].z))) + ((lerp(_971.y, _977.y, _907)) * (LUTWeights[0].w))));
  float _998 = max(6.103519990574569e-05f, (((((lerp(_912.z, _919.z, _907)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _894)) + ((lerp(_942.z, _948.z, _907)) * (LUTWeights[0].z))) + ((lerp(_971.z, _977.z, _907)) * (LUTWeights[0].w))));
  float _1020 = select((_996 > 0.040449999272823334f), exp2(log2((_996 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_996 * 0.07739938050508499f));
  float _1021 = select((_997 > 0.040449999272823334f), exp2(log2((_997 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_997 * 0.07739938050508499f));
  float _1022 = select((_998 > 0.040449999272823334f), exp2(log2((_998 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_998 * 0.07739938050508499f));
  float _1048 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1020)) * _1020) + MappingPolynomial.z);
  float _1049 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1021)) * _1021) + MappingPolynomial.z);
  float _1050 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1022)) * _1022) + MappingPolynomial.z);
  float _1071 = exp2(log2(max(0.0f, (lerp(_1048, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1072 = exp2(log2(max(0.0f, (lerp(_1049, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1073 = exp2(log2(max(0.0f, (lerp(_1050, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1071, _1072, _1073));
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1092 = mad((WorkingColorSpace_ToAP1[0].z), _1073, mad((WorkingColorSpace_ToAP1[0].y), _1072, ((WorkingColorSpace_ToAP1[0].x) * _1071)));
    float _1095 = mad((WorkingColorSpace_ToAP1[1].z), _1073, mad((WorkingColorSpace_ToAP1[1].y), _1072, ((WorkingColorSpace_ToAP1[1].x) * _1071)));
    float _1098 = mad((WorkingColorSpace_ToAP1[2].z), _1073, mad((WorkingColorSpace_ToAP1[2].y), _1072, ((WorkingColorSpace_ToAP1[2].x) * _1071)));
    _1109 = mad(_47, _1098, mad(_46, _1095, (_1092 * _45)));
    _1110 = mad(_50, _1098, mad(_49, _1095, (_1092 * _48)));
    _1111 = mad(_53, _1098, mad(_52, _1095, (_1092 * _51)));
  } else {
    _1109 = _1071;
    _1110 = _1072;
    _1111 = _1073;
  }
  if (_1109 < 0.0031306699384003878f) {
    _1122 = (_1109 * 12.920000076293945f);
  } else {
    _1122 = (((pow(_1109, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1110 < 0.0031306699384003878f) {
    _1133 = (_1110 * 12.920000076293945f);
  } else {
    _1133 = (((pow(_1110, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1111 < 0.0031306699384003878f) {
    _1144 = (_1111 * 12.920000076293945f);
  } else {
    _1144 = (((pow(_1111, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1122 * 0.9523810148239136f);
  SV_Target.y = (_1133 * 0.9523810148239136f);
  SV_Target.z = (_1144 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

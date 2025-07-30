// Found in Grounded 2

#include "../../common.hlsl"

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};


cbuffer _RootShaderParameters : register(b0) {
  float4 ACESMinMaxData : packoffset(c008.x);
  float4 ACESMidData : packoffset(c009.x);
  float4 ACESCoefsLow_0 : packoffset(c010.x);
  float4 ACESCoefsHigh_0 : packoffset(c011.x);
  float ACESCoefsLow_4 : packoffset(c012.x);
  float ACESCoefsHigh_4 : packoffset(c012.y);
  float ACESSceneColorMultiplier : packoffset(c012.z);
  float ACESGamutCompression : packoffset(c012.w);
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
  float HDRGamma : packoffset(c039.x);
  float HDRContrastBlendMin : packoffset(c039.y);
  float HDRContrastBlendMax : packoffset(c039.z);
  float MaxBrightnessOfTV2084 : packoffset(c039.w);
  float3 MappingPolynomial : packoffset(c040.x);
  float3 InverseGamma : packoffset(c041.x);
  uint OutputGamut : packoffset(c042.x);
};

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _10 = 0.5f / LUTSize;
  float _15 = LUTSize + -1.0f;
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _564;
  float _597;
  float _611;
  float _675;
  float _927;
  float _928;
  float _929;
  float _940;
  float _951;
  float _962;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _28 = (OutputGamut == 4);
        _39 = select(_28, 1.0f, 1.705051064491272f);
        _40 = select(_28, 0.0f, -0.6217921376228333f);
        _41 = select(_28, 0.0f, -0.0832589864730835f);
        _42 = select(_28, 0.0f, -0.13025647401809692f);
        _43 = select(_28, 1.0f, 1.140804648399353f);
        _44 = select(_28, 0.0f, -0.010548308491706848f);
        _45 = select(_28, 0.0f, -0.024003351107239723f);
        _46 = select(_28, 0.0f, -0.1289689838886261f);
        _47 = select(_28, 1.0f, 1.1529725790023804f);
      } else {
        _39 = 0.6954522132873535f;
        _40 = 0.14067870378494263f;
        _41 = 0.16386906802654266f;
        _42 = 0.044794563204050064f;
        _43 = 0.8596711158752441f;
        _44 = 0.0955343171954155f;
        _45 = -0.005525882821530104f;
        _46 = 0.004025210160762072f;
        _47 = 1.0015007257461548f;
      }
    } else {
      _39 = 1.0258246660232544f;
      _40 = -0.020053181797266006f;
      _41 = -0.005771636962890625f;
      _42 = -0.002234415616840124f;
      _43 = 1.0045864582061768f;
      _44 = -0.002352118492126465f;
      _45 = -0.005013350863009691f;
      _46 = -0.025290070101618767f;
      _47 = 1.0303035974502563f;
    }
  } else {
    _39 = 1.3792141675949097f;
    _40 = -0.30886411666870117f;
    _41 = -0.0703500509262085f;
    _42 = -0.06933490186929703f;
    _43 = 1.08229660987854f;
    _44 = -0.012961871922016144f;
    _45 = -0.0021590073592960835f;
    _46 = -0.0454593189060688f;
    _47 = 1.0476183891296387f;
  }
  float _60 = (exp2((((LUTSize * (TEXCOORD.x - _10)) / _15) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _61 = (exp2((((LUTSize * (TEXCOORD.y - _10)) / _15) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _62 = (exp2(((float((uint)(int)(SV_RenderTargetArrayIndex)) / _15) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _77 = mad((WorkingColorSpace.ToAP1[0].z), _62, mad((WorkingColorSpace.ToAP1[0].y), _61, ((WorkingColorSpace.ToAP1[0].x) * _60)));
  float _80 = mad((WorkingColorSpace.ToAP1[1].z), _62, mad((WorkingColorSpace.ToAP1[1].y), _61, ((WorkingColorSpace.ToAP1[1].x) * _60)));
  float _83 = mad((WorkingColorSpace.ToAP1[2].z), _62, mad((WorkingColorSpace.ToAP1[2].y), _61, ((WorkingColorSpace.ToAP1[2].x) * _60)));
  float _84 = dot(float3(_77, _80, _83), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_77, _80, _83));

  float _88 = (_77 / _84) + -1.0f;
  float _89 = (_80 / _84) + -1.0f;
  float _90 = (_83 / _84) + -1.0f;
  float _102 = (1.0f - exp2(((_84 * _84) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_88, _89, _90), float3(_88, _89, _90)) * -4.0f));
  float _118 = ((mad(-0.06368321925401688f, _83, mad(-0.3292922377586365f, _80, (_77 * 1.3704125881195068f))) - _77) * _102) + _77;
  float _119 = ((mad(-0.010861365124583244f, _83, mad(1.0970927476882935f, _80, (_77 * -0.08343357592821121f))) - _80) * _102) + _80;
  float _120 = ((mad(1.2036951780319214f, _83, mad(-0.09862580895423889f, _80, (_77 * -0.02579331398010254f))) - _83) * _102) + _83;
  float _121 = dot(float3(_118, _119, _120), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _135 = ColorOffset.w + ColorOffsetShadows.w;
  float _149 = ColorGain.w * ColorGainShadows.w;
  float _163 = ColorGamma.w * ColorGammaShadows.w;
  float _177 = ColorContrast.w * ColorContrastShadows.w;
  float _191 = ColorSaturation.w * ColorSaturationShadows.w;
  float _195 = _118 - _121;
  float _196 = _119 - _121;
  float _197 = _120 - _121;
  float _254 = saturate(_121 / ColorCorrectionShadowsMax);
  float _258 = (_254 * _254) * (3.0f - (_254 * 2.0f));
  float _259 = 1.0f - _258;
  float _268 = ColorOffset.w + ColorOffsetHighlights.w;
  float _277 = ColorGain.w * ColorGainHighlights.w;
  float _286 = ColorGamma.w * ColorGammaHighlights.w;
  float _295 = ColorContrast.w * ColorContrastHighlights.w;
  float _304 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _367 = saturate((_121 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _371 = (_367 * _367) * (3.0f - (_367 * 2.0f));
  float _380 = ColorOffset.w + ColorOffsetMidtones.w;
  float _389 = ColorGain.w * ColorGainMidtones.w;
  float _398 = ColorGamma.w * ColorGammaMidtones.w;
  float _407 = ColorContrast.w * ColorContrastMidtones.w;
  float _416 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _474 = _258 - _371;
  float _485 = ((_371 * (((ColorOffset.x + ColorOffsetHighlights.x) + _268) + (((ColorGain.x * ColorGainHighlights.x) * _277) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _295) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _304) * _195) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _286)))))) + (_259 * (((ColorOffset.x + ColorOffsetShadows.x) + _135) + (((ColorGain.x * ColorGainShadows.x) * _149) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _177) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _191) * _195) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _163))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _380) + (((ColorGain.x * ColorGainMidtones.x) * _389) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _407) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _416) * _195) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _398))))) * _474);
  float _487 = ((_371 * (((ColorOffset.y + ColorOffsetHighlights.y) + _268) + (((ColorGain.y * ColorGainHighlights.y) * _277) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _295) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _304) * _196) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _286)))))) + (_259 * (((ColorOffset.y + ColorOffsetShadows.y) + _135) + (((ColorGain.y * ColorGainShadows.y) * _149) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _177) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _191) * _196) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _163))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _380) + (((ColorGain.y * ColorGainMidtones.y) * _389) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _407) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _416) * _196) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _398))))) * _474);
  float _489 = ((_371 * (((ColorOffset.z + ColorOffsetHighlights.z) + _268) + (((ColorGain.z * ColorGainHighlights.z) * _277) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _295) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _304) * _197) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _286)))))) + (_259 * (((ColorOffset.z + ColorOffsetShadows.z) + _135) + (((ColorGain.z * ColorGainShadows.z) * _149) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _177) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _191) * _197) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _163))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _380) + (((ColorGain.z * ColorGainMidtones.z) * _389) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _407) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _416) * _197) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _398))))) * _474);
  
  SetUntonemappedAP1(float3(_485, _487, _489));
  
  float _504 = ((mad(0.061360642313957214f, _489, mad(-4.540197551250458e-09f, _487, (_485 * 0.9386394023895264f))) - _485) * BlueCorrection) + _485;
  float _505 = ((mad(0.169205904006958f, _489, mad(0.8307942152023315f, _487, (_485 * 6.775371730327606e-08f))) - _487) * BlueCorrection) + _487;
  float _506 = (mad(-2.3283064365386963e-10f, _487, (_485 * -9.313225746154785e-10f)) * BlueCorrection) + _489;
  float _509 = mad(0.16386905312538147f, _506, mad(0.14067868888378143f, _505, (_504 * 0.6954522132873535f)));
  float _512 = mad(0.0955343246459961f, _506, mad(0.8596711158752441f, _505, (_504 * 0.044794581830501556f)));
  float _515 = mad(1.0015007257461548f, _506, mad(0.004025210160762072f, _505, (_504 * -0.005525882821530104f)));
  float _519 = max(max(_509, _512), _515);
  float _524 = (max(_519, 1.000000013351432e-10f) - max(min(min(_509, _512), _515), 1.000000013351432e-10f)) / max(_519, 0.009999999776482582f);
  float _537 = ((_512 + _509) + _515) + (sqrt((((_515 - _512) * _515) + ((_512 - _509) * _512)) + ((_509 - _515) * _509)) * 1.75f);
  float _538 = _537 * 0.3333333432674408f;
  float _539 = _524 + -0.4000000059604645f;
  float _540 = _539 * 5.0f;
  float _544 = max((1.0f - abs(_539 * 2.5f)), 0.0f);
  float _555 = ((float((int)(((int)(uint)((bool)(_540 > 0.0f))) - ((int)(uint)((bool)(_540 < 0.0f))))) * (1.0f - (_544 * _544))) + 1.0f) * 0.02500000037252903f;
  if (!(_538 <= 0.0533333346247673f)) {
    if (!(_538 >= 0.1599999964237213f)) {
      _564 = (((0.23999999463558197f / _537) + -0.5f) * _555);
    } else {
      _564 = 0.0f;
    }
  } else {
    _564 = _555;
  }
  float _565 = _564 + 1.0f;
  float _566 = _565 * _509;
  float _567 = _565 * _512;
  float _568 = _565 * _515;
  if (!((bool)(_566 == _567) && (bool)(_567 == _568))) {
    float _575 = ((_566 * 2.0f) - _567) - _568;
    float _578 = ((_512 - _515) * 1.7320507764816284f) * _565;
    float _580 = atan(_578 / _575);
    bool _583 = (_575 < 0.0f);
    bool _584 = (_575 == 0.0f);
    bool _585 = (_578 >= 0.0f);
    bool _586 = (_578 < 0.0f);
    _597 = select((_585 && _584), 90.0f, select((_586 && _584), -90.0f, (select((_586 && _583), (_580 + -3.1415927410125732f), select((_585 && _583), (_580 + 3.1415927410125732f), _580)) * 57.2957763671875f)));
  } else {
    _597 = 0.0f;
  }
  float _602 = min(max(select((_597 < 0.0f), (_597 + 360.0f), _597), 0.0f), 360.0f);
  if (_602 < -180.0f) {
    _611 = (_602 + 360.0f);
  } else {
    if (_602 > 180.0f) {
      _611 = (_602 + -360.0f);
    } else {
      _611 = _602;
    }
  }
  float _615 = saturate(1.0f - abs(_611 * 0.014814814552664757f));
  float _619 = (_615 * _615) * (3.0f - (_615 * 2.0f));
  float _625 = ((_619 * _619) * ((_524 * 0.18000000715255737f) * (0.029999999329447746f - _566))) + _566;
  float _635 = max(0.0f, mad(-0.21492856740951538f, _568, mad(-0.2365107536315918f, _567, (_625 * 1.4514392614364624f))));
  float _636 = max(0.0f, mad(-0.09967592358589172f, _568, mad(1.17622971534729f, _567, (_625 * -0.07655377686023712f))));
  float _637 = max(0.0f, mad(0.9977163076400757f, _568, mad(-0.006032449658960104f, _567, (_625 * 0.008316148072481155f))));
  float _638 = dot(float3(_635, _636, _637), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _653 = (FilmBlackClip + 1.0f) - FilmToe;
  float _655 = FilmWhiteClip + 1.0f;
  float _657 = _655 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _675 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _666 = (FilmBlackClip + 0.18000000715255737f) / _653;
    _675 = (-0.7447274923324585f - ((log2(_666 / (2.0f - _666)) * 0.3465735912322998f) * (_653 / FilmSlope)));
  }
  float _678 = ((1.0f - FilmToe) / FilmSlope) - _675;
  float _680 = (FilmShoulder / FilmSlope) - _678;
  float _684 = log2(lerp(_638, _635, 0.9599999785423279f)) * 0.3010300099849701f;
  float _685 = log2(lerp(_638, _636, 0.9599999785423279f)) * 0.3010300099849701f;
  float _686 = log2(lerp(_638, _637, 0.9599999785423279f)) * 0.3010300099849701f;
  float _690 = FilmSlope * (_684 + _678);
  float _691 = FilmSlope * (_685 + _678);
  float _692 = FilmSlope * (_686 + _678);
  float _693 = _653 * 2.0f;
  float _695 = (FilmSlope * -2.0f) / _653;
  float _696 = _684 - _675;
  float _697 = _685 - _675;
  float _698 = _686 - _675;
  float _717 = _657 * 2.0f;
  float _719 = (FilmSlope * 2.0f) / _657;
  float _744 = select((_684 < _675), ((_693 / (exp2((_696 * 1.4426950216293335f) * _695) + 1.0f)) - FilmBlackClip), _690);
  float _745 = select((_685 < _675), ((_693 / (exp2((_697 * 1.4426950216293335f) * _695) + 1.0f)) - FilmBlackClip), _691);
  float _746 = select((_686 < _675), ((_693 / (exp2((_698 * 1.4426950216293335f) * _695) + 1.0f)) - FilmBlackClip), _692);
  float _753 = _680 - _675;
  float _757 = saturate(_696 / _753);
  float _758 = saturate(_697 / _753);
  float _759 = saturate(_698 / _753);
  bool _760 = (_680 < _675);
  float _764 = select(_760, (1.0f - _757), _757);
  float _765 = select(_760, (1.0f - _758), _758);
  float _766 = select(_760, (1.0f - _759), _759);
  float _785 = (((_764 * _764) * (select((_684 > _680), (_655 - (_717 / (exp2(((_684 - _680) * 1.4426950216293335f) * _719) + 1.0f))), _690) - _744)) * (3.0f - (_764 * 2.0f))) + _744;
  float _786 = (((_765 * _765) * (select((_685 > _680), (_655 - (_717 / (exp2(((_685 - _680) * 1.4426950216293335f) * _719) + 1.0f))), _691) - _745)) * (3.0f - (_765 * 2.0f))) + _745;
  float _787 = (((_766 * _766) * (select((_686 > _680), (_655 - (_717 / (exp2(((_686 - _680) * 1.4426950216293335f) * _719) + 1.0f))), _692) - _746)) * (3.0f - (_766 * 2.0f))) + _746;
  float _788 = dot(float3(_785, _786, _787), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _808 = (ToneCurveAmount * (max(0.0f, (lerp(_788, _785, 0.9300000071525574f))) - _504)) + _504;
  float _809 = (ToneCurveAmount * (max(0.0f, (lerp(_788, _786, 0.9300000071525574f))) - _505)) + _505;
  float _810 = (ToneCurveAmount * (max(0.0f, (lerp(_788, _787, 0.9300000071525574f))) - _506)) + _506;
  float _826 = ((mad(-0.06537103652954102f, _810, mad(1.451815478503704e-06f, _809, (_808 * 1.065374732017517f))) - _808) * BlueCorrection) + _808;
  float _827 = ((mad(-0.20366770029067993f, _810, mad(1.2036634683609009f, _809, (_808 * -2.57161445915699e-07f))) - _809) * BlueCorrection) + _809;
  float _828 = ((mad(0.9999996423721313f, _810, mad(2.0954757928848267e-08f, _809, (_808 * 1.862645149230957e-08f))) - _810) * BlueCorrection) + _810;
  
  SetTonemappedAP1(_826, _827, _828);
  
  float _850 = max(0.0f, mad((WorkingColorSpace.FromAP1[0].z), _828, mad((WorkingColorSpace.FromAP1[0].y), _827, ((WorkingColorSpace.FromAP1[0].x) * _826))));
  float _851 = max(0.0f, mad((WorkingColorSpace.FromAP1[1].z), _828, mad((WorkingColorSpace.FromAP1[1].y), _827, ((WorkingColorSpace.FromAP1[1].x) * _826))));
  float _852 = max(0.0f, mad((WorkingColorSpace.FromAP1[2].z), _828, mad((WorkingColorSpace.FromAP1[2].y), _827, ((WorkingColorSpace.FromAP1[2].x) * _826))));
  float _878 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _850)) * _850) + MappingPolynomial.z);
  float _879 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _851)) * _851) + MappingPolynomial.z);
  float _880 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _852)) * _852) + MappingPolynomial.z);
  float _901 = exp2(log2(max(0.0f, (lerp(_878, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _902 = exp2(log2(max(0.0f, (lerp(_879, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _903 = exp2(log2(max(0.0f, (lerp(_880, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_901, _902, _903));
  }


  if (WorkingColorSpace.bIsSRGB == 0) {
    float _910 = mad((WorkingColorSpace.ToAP1[0].z), _903, mad((WorkingColorSpace.ToAP1[0].y), _902, ((WorkingColorSpace.ToAP1[0].x) * _901)));
    float _913 = mad((WorkingColorSpace.ToAP1[1].z), _903, mad((WorkingColorSpace.ToAP1[1].y), _902, ((WorkingColorSpace.ToAP1[1].x) * _901)));
    float _916 = mad((WorkingColorSpace.ToAP1[2].z), _903, mad((WorkingColorSpace.ToAP1[2].y), _902, ((WorkingColorSpace.ToAP1[2].x) * _901)));
    _927 = mad(_41, _916, mad(_40, _913, (_910 * _39)));
    _928 = mad(_44, _916, mad(_43, _913, (_910 * _42)));
    _929 = mad(_47, _916, mad(_46, _913, (_910 * _45)));
  } else {
    _927 = _901;
    _928 = _902;
    _929 = _903;
  }
  if (_927 < 0.0031306699384003878f) {
    _940 = (_927 * 12.920000076293945f);
  } else {
    _940 = (((pow(_927, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_928 < 0.0031306699384003878f) {
    _951 = (_928 * 12.920000076293945f);
  } else {
    _951 = (((pow(_928, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_929 < 0.0031306699384003878f) {
    _962 = (_929 * 12.920000076293945f);
  } else {
    _962 = (((pow(_929, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_940 * 0.9523810148239136f);
  SV_Target.y = (_951 * 0.9523810148239136f);
  SV_Target.z = (_962 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

#include "../../common.hlsl"

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
  float _567;
  float _600;
  float _614;
  float _678;
  float _930;
  float _931;
  float _932;
  float _943;
  float _954;
  float _965;
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
  float _77 = mad((WorkingColorSpace_ToAP1[0].z), _62, mad((WorkingColorSpace_ToAP1[0].y), _61, ((WorkingColorSpace_ToAP1[0].x) * _60)));
  float _80 = mad((WorkingColorSpace_ToAP1[1].z), _62, mad((WorkingColorSpace_ToAP1[1].y), _61, ((WorkingColorSpace_ToAP1[1].x) * _60)));
  float _83 = mad((WorkingColorSpace_ToAP1[2].z), _62, mad((WorkingColorSpace_ToAP1[2].y), _61, ((WorkingColorSpace_ToAP1[2].x) * _60)));
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
  float _383 = ColorOffset.w + ColorOffsetMidtones.w;
  float _392 = ColorGain.w * ColorGainMidtones.w;
  float _401 = ColorGamma.w * ColorGammaMidtones.w;
  float _410 = ColorContrast.w * ColorContrastMidtones.w;
  float _419 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _477 = _258 - _371;
  float _488 = ((_371 * min(1e+05f, (((ColorOffset.x + ColorOffsetHighlights.x) + _268) + (((ColorGain.x * ColorGainHighlights.x) * _277) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _295) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _304) * _195) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _286))))))) + (_259 * (((ColorOffset.x + ColorOffsetShadows.x) + _135) + (((ColorGain.x * ColorGainShadows.x) * _149) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _177) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _191) * _195) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _163))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _383) + (((ColorGain.x * ColorGainMidtones.x) * _392) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _410) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _419) * _195) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _401))))) * _477);
  float _490 = ((_371 * min(1e+05f, (((ColorOffset.y + ColorOffsetHighlights.y) + _268) + (((ColorGain.y * ColorGainHighlights.y) * _277) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _295) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _304) * _196) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _286))))))) + (_259 * (((ColorOffset.y + ColorOffsetShadows.y) + _135) + (((ColorGain.y * ColorGainShadows.y) * _149) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _177) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _191) * _196) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _163))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _383) + (((ColorGain.y * ColorGainMidtones.y) * _392) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _410) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _419) * _196) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _401))))) * _477);
  float _492 = ((min(1e+05f, (((ColorOffset.z + ColorOffsetHighlights.z) + _268) + (((ColorGain.z * ColorGainHighlights.z) * _277) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _295) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _304) * _197) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _286)))))) * _371) + (_259 * (((ColorOffset.z + ColorOffsetShadows.z) + _135) + (((ColorGain.z * ColorGainShadows.z) * _149) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _177) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _191) * _197) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _163))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _383) + (((ColorGain.z * ColorGainMidtones.z) * _392) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _410) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _419) * _197) + _121)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _401))))) * _477);

  SetUntonemappedAP1(float3(_488, _490, _492));

  float _507 = ((mad(0.061360642313957214f, _492, mad(-4.540197551250458e-09f, _490, (_488 * 0.9386394023895264f))) - _488) * BlueCorrection) + _488;
  float _508 = ((mad(0.169205904006958f, _492, mad(0.8307942152023315f, _490, (_488 * 6.775371730327606e-08f))) - _490) * BlueCorrection) + _490;
  float _509 = (mad(-2.3283064365386963e-10f, _490, (_488 * -9.313225746154785e-10f)) * BlueCorrection) + _492;
  float _512 = mad(0.16386905312538147f, _509, mad(0.14067868888378143f, _508, (_507 * 0.6954522132873535f)));
  float _515 = mad(0.0955343246459961f, _509, mad(0.8596711158752441f, _508, (_507 * 0.044794581830501556f)));
  float _518 = mad(1.0015007257461548f, _509, mad(0.004025210160762072f, _508, (_507 * -0.005525882821530104f)));
  float _522 = max(max(_512, _515), _518);
  float _527 = (max(_522, 1.000000013351432e-10f) - max(min(min(_512, _515), _518), 1.000000013351432e-10f)) / max(_522, 0.009999999776482582f);
  float _540 = ((_515 + _512) + _518) + (sqrt((((_518 - _515) * _518) + ((_515 - _512) * _515)) + ((_512 - _518) * _512)) * 1.75f);
  float _541 = _540 * 0.3333333432674408f;
  float _542 = _527 + -0.4000000059604645f;
  float _543 = _542 * 5.0f;
  float _547 = max((1.0f - abs(_542 * 2.5f)), 0.0f);
  float _558 = ((float((int)(((int)(uint)((bool)(_543 > 0.0f))) - ((int)(uint)((bool)(_543 < 0.0f))))) * (1.0f - (_547 * _547))) + 1.0f) * 0.02500000037252903f;
  if (!(_541 <= 0.0533333346247673f)) {
    if (!(_541 >= 0.1599999964237213f)) {
      _567 = (((0.23999999463558197f / _540) + -0.5f) * _558);
    } else {
      _567 = 0.0f;
    }
  } else {
    _567 = _558;
  }
  float _568 = _567 + 1.0f;
  float _569 = _568 * _512;
  float _570 = _568 * _515;
  float _571 = _568 * _518;
  if (!((bool)(_569 == _570) && (bool)(_570 == _571))) {
    float _578 = ((_569 * 2.0f) - _570) - _571;
    float _581 = ((_515 - _518) * 1.7320507764816284f) * _568;
    float _583 = atan(_581 / _578);
    bool _586 = (_578 < 0.0f);
    bool _587 = (_578 == 0.0f);
    bool _588 = (_581 >= 0.0f);
    bool _589 = (_581 < 0.0f);
    _600 = select((_588 && _587), 90.0f, select((_589 && _587), -90.0f, (select((_589 && _586), (_583 + -3.1415927410125732f), select((_588 && _586), (_583 + 3.1415927410125732f), _583)) * 57.2957763671875f)));
  } else {
    _600 = 0.0f;
  }
  float _605 = min(max(select((_600 < 0.0f), (_600 + 360.0f), _600), 0.0f), 360.0f);
  if (_605 < -180.0f) {
    _614 = (_605 + 360.0f);
  } else {
    if (_605 > 180.0f) {
      _614 = (_605 + -360.0f);
    } else {
      _614 = _605;
    }
  }
  float _618 = saturate(1.0f - abs(_614 * 0.014814814552664757f));
  float _622 = (_618 * _618) * (3.0f - (_618 * 2.0f));
  float _628 = ((_622 * _622) * ((_527 * 0.18000000715255737f) * (0.029999999329447746f - _569))) + _569;
  float _638 = max(0.0f, mad(-0.21492856740951538f, _571, mad(-0.2365107536315918f, _570, (_628 * 1.4514392614364624f))));
  float _639 = max(0.0f, mad(-0.09967592358589172f, _571, mad(1.17622971534729f, _570, (_628 * -0.07655377686023712f))));
  float _640 = max(0.0f, mad(0.9977163076400757f, _571, mad(-0.006032449658960104f, _570, (_628 * 0.008316148072481155f))));
  float _641 = dot(float3(_638, _639, _640), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _656 = (FilmBlackClip + 1.0f) - FilmToe;
  float _658 = FilmWhiteClip + 1.0f;
  float _660 = _658 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _678 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _669 = (FilmBlackClip + 0.18000000715255737f) / _656;
    _678 = (-0.7447274923324585f - ((log2(_669 / (2.0f - _669)) * 0.3465735912322998f) * (_656 / FilmSlope)));
  }
  float _681 = ((1.0f - FilmToe) / FilmSlope) - _678;
  float _683 = (FilmShoulder / FilmSlope) - _681;
  float _687 = log2(lerp(_641, _638, 0.9599999785423279f)) * 0.3010300099849701f;
  float _688 = log2(lerp(_641, _639, 0.9599999785423279f)) * 0.3010300099849701f;
  float _689 = log2(lerp(_641, _640, 0.9599999785423279f)) * 0.3010300099849701f;
  float _693 = FilmSlope * (_687 + _681);
  float _694 = FilmSlope * (_688 + _681);
  float _695 = FilmSlope * (_689 + _681);
  float _696 = _656 * 2.0f;
  float _698 = (FilmSlope * -2.0f) / _656;
  float _699 = _687 - _678;
  float _700 = _688 - _678;
  float _701 = _689 - _678;
  float _720 = _660 * 2.0f;
  float _722 = (FilmSlope * 2.0f) / _660;
  float _747 = select((_687 < _678), ((_696 / (exp2((_699 * 1.4426950216293335f) * _698) + 1.0f)) - FilmBlackClip), _693);
  float _748 = select((_688 < _678), ((_696 / (exp2((_700 * 1.4426950216293335f) * _698) + 1.0f)) - FilmBlackClip), _694);
  float _749 = select((_689 < _678), ((_696 / (exp2((_701 * 1.4426950216293335f) * _698) + 1.0f)) - FilmBlackClip), _695);
  float _756 = _683 - _678;
  float _760 = saturate(_699 / _756);
  float _761 = saturate(_700 / _756);
  float _762 = saturate(_701 / _756);
  bool _763 = (_683 < _678);
  float _767 = select(_763, (1.0f - _760), _760);
  float _768 = select(_763, (1.0f - _761), _761);
  float _769 = select(_763, (1.0f - _762), _762);
  float _788 = (((_767 * _767) * (select((_687 > _683), (_658 - (_720 / (exp2(((_687 - _683) * 1.4426950216293335f) * _722) + 1.0f))), _693) - _747)) * (3.0f - (_767 * 2.0f))) + _747;
  float _789 = (((_768 * _768) * (select((_688 > _683), (_658 - (_720 / (exp2(((_688 - _683) * 1.4426950216293335f) * _722) + 1.0f))), _694) - _748)) * (3.0f - (_768 * 2.0f))) + _748;
  float _790 = (((_769 * _769) * (select((_689 > _683), (_658 - (_720 / (exp2(((_689 - _683) * 1.4426950216293335f) * _722) + 1.0f))), _695) - _749)) * (3.0f - (_769 * 2.0f))) + _749;
  float _791 = dot(float3(_788, _789, _790), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _811 = (ToneCurveAmount * (max(0.0f, (lerp(_791, _788, 0.9300000071525574f))) - _507)) + _507;
  float _812 = (ToneCurveAmount * (max(0.0f, (lerp(_791, _789, 0.9300000071525574f))) - _508)) + _508;
  float _813 = (ToneCurveAmount * (max(0.0f, (lerp(_791, _790, 0.9300000071525574f))) - _509)) + _509;
  float _829 = ((mad(-0.06537103652954102f, _813, mad(1.451815478503704e-06f, _812, (_811 * 1.065374732017517f))) - _811) * BlueCorrection) + _811;
  float _830 = ((mad(-0.20366770029067993f, _813, mad(1.2036634683609009f, _812, (_811 * -2.57161445915699e-07f))) - _812) * BlueCorrection) + _812;
  float _831 = ((mad(0.9999996423721313f, _813, mad(2.0954757928848267e-08f, _812, (_811 * 1.862645149230957e-08f))) - _813) * BlueCorrection) + _813;

  SetTonemappedAP1(_829, _830, _831);

  float _853 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _831, mad((WorkingColorSpace_FromAP1[0].y), _830, ((WorkingColorSpace_FromAP1[0].x) * _829))));
  float _854 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _831, mad((WorkingColorSpace_FromAP1[1].y), _830, ((WorkingColorSpace_FromAP1[1].x) * _829))));
  float _855 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _831, mad((WorkingColorSpace_FromAP1[2].y), _830, ((WorkingColorSpace_FromAP1[2].x) * _829))));
  float _881 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _853)) * _853) + MappingPolynomial.z);
  float _882 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _854)) * _854) + MappingPolynomial.z);
  float _883 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _855)) * _855) + MappingPolynomial.z);
  float _904 = exp2(log2(max(0.0f, (lerp(_881, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _905 = exp2(log2(max(0.0f, (lerp(_882, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _906 = exp2(log2(max(0.0f, (lerp(_883, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_904, _905, _906));
  }

  if (WorkingColorSpace_bIsSRGB == 0) {
    float _913 = mad((WorkingColorSpace_ToAP1[0].z), _906, mad((WorkingColorSpace_ToAP1[0].y), _905, ((WorkingColorSpace_ToAP1[0].x) * _904)));
    float _916 = mad((WorkingColorSpace_ToAP1[1].z), _906, mad((WorkingColorSpace_ToAP1[1].y), _905, ((WorkingColorSpace_ToAP1[1].x) * _904)));
    float _919 = mad((WorkingColorSpace_ToAP1[2].z), _906, mad((WorkingColorSpace_ToAP1[2].y), _905, ((WorkingColorSpace_ToAP1[2].x) * _904)));
    _930 = mad(_41, _919, mad(_40, _916, (_913 * _39)));
    _931 = mad(_44, _919, mad(_43, _916, (_913 * _42)));
    _932 = mad(_47, _919, mad(_46, _916, (_913 * _45)));
  } else {
    _930 = _904;
    _931 = _905;
    _932 = _906;
  }
  if (_930 < 0.0031306699384003878f) {
    _943 = (_930 * 12.920000076293945f);
  } else {
    _943 = (((pow(_930, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_931 < 0.0031306699384003878f) {
    _954 = (_931 * 12.920000076293945f);
  } else {
    _954 = (((pow(_931, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_932 < 0.0031306699384003878f) {
    _965 = (_932 * 12.920000076293945f);
  } else {
    _965 = (((pow(_932, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_943 * 0.9523810148239136f);
  SV_Target.y = (_954 * 0.9523810148239136f);
  SV_Target.z = (_965 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);
  
  return SV_Target;
}

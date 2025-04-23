#include "../common.hlsl"

Texture2D<float4> Textures_1 : register(t0);

RWTexture3D<float4> RWOutputTexture : register(u0);

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
  float2 OutputExtentInverse : packoffset(c042.x);
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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _11[6];
  float _12[6];
  float _13[6];
  float _14[6];
  float _26 = 0.5f / LUTSize;
  float _31 = LUTSize + -1.0f;
  float _32 = (LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _26)) / _31;
  float _33 = (LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _26)) / _31;
  float _35 = float((uint)SV_DispatchThreadID.z) / _31;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _121;
  float _122;
  float _123;
  float _646;
  float _679;
  float _693;
  float _757;
  float _936;
  float _947;
  float _958;
  float _1129;
  float _1130;
  float _1131;
  float _1142;
  float _1153;
  float _1333;
  float _1366;
  float _1380;
  float _1419;
  float _1529;
  float _1603;
  float _1677;
  float _1756;
  float _1757;
  float _1758;
  float _1907;
  float _1940;
  float _1954;
  float _1993;
  float _2103;
  float _2177;
  float _2251;
  float _2330;
  float _2331;
  float _2332;
  float _2509;
  float _2510;
  float _2511;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _44 = ((uint)(OutputGamut) == 4);
        _55 = select(_44, 1.0f, 1.705051064491272f);
        _56 = select(_44, 0.0f, -0.6217921376228333f);
        _57 = select(_44, 0.0f, -0.0832589864730835f);
        _58 = select(_44, 0.0f, -0.13025647401809692f);
        _59 = select(_44, 1.0f, 1.140804648399353f);
        _60 = select(_44, 0.0f, -0.010548308491706848f);
        _61 = select(_44, 0.0f, -0.024003351107239723f);
        _62 = select(_44, 0.0f, -0.1289689838886261f);
        _63 = select(_44, 1.0f, 1.1529725790023804f);
      } else {
        _55 = 0.6954522132873535f;
        _56 = 0.14067870378494263f;
        _57 = 0.16386906802654266f;
        _58 = 0.044794563204050064f;
        _59 = 0.8596711158752441f;
        _60 = 0.0955343171954155f;
        _61 = -0.005525882821530104f;
        _62 = 0.004025210160762072f;
        _63 = 1.0015007257461548f;
      }
    } else {
      _55 = 1.0258246660232544f;
      _56 = -0.020053181797266006f;
      _57 = -0.005771636962890625f;
      _58 = -0.002234415616840124f;
      _59 = 1.0045864582061768f;
      _60 = -0.002352118492126465f;
      _61 = -0.005013350863009691f;
      _62 = -0.025290070101618767f;
      _63 = 1.0303035974502563f;
    }
  } else {
    _55 = 1.3792141675949097f;
    _56 = -0.30886411666870117f;
    _57 = -0.0703500509262085f;
    _58 = -0.06933490186929703f;
    _59 = 1.08229660987854f;
    _60 = -0.012961871922016144f;
    _61 = -0.0021590073592960835f;
    _62 = -0.0454593189060688f;
    _63 = 1.0476183891296387f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _74 = (pow(_32, 0.012683313339948654f));
    float _75 = (pow(_33, 0.012683313339948654f));
    float _76 = (pow(_35, 0.012683313339948654f));
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _122 = (exp2(log2(max(0.0f, (_75 + -0.8359375f)) / (18.8515625f - (_75 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _123 = (exp2(log2(max(0.0f, (_76 + -0.8359375f)) / (18.8515625f - (_76 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _121 = ((exp2((_32 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _122 = ((exp2((_33 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _123 = ((exp2((_35 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _138 = mad((WorkingColorSpace_ToAP1[0].z), _123, mad((WorkingColorSpace_ToAP1[0].y), _122, ((WorkingColorSpace_ToAP1[0].x) * _121)));
  float _141 = mad((WorkingColorSpace_ToAP1[1].z), _123, mad((WorkingColorSpace_ToAP1[1].y), _122, ((WorkingColorSpace_ToAP1[1].x) * _121)));
  float _144 = mad((WorkingColorSpace_ToAP1[2].z), _123, mad((WorkingColorSpace_ToAP1[2].y), _122, ((WorkingColorSpace_ToAP1[2].x) * _121)));
  float _145 = dot(float3(_138, _141, _144), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUntonemappedAP1(float3(_138, _141, _144));

  float _149 = (_138 / _145) + -1.0f;
  float _150 = (_141 / _145) + -1.0f;
  float _151 = (_144 / _145) + -1.0f;
  float _163 = (1.0f - exp2(((_145 * _145) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_149, _150, _151), float3(_149, _150, _151)) * -4.0f));
  float _179 = ((mad(-0.06368321925401688f, _144, mad(-0.3292922377586365f, _141, (_138 * 1.3704125881195068f))) - _138) * _163) + _138;
  float _180 = ((mad(-0.010861365124583244f, _144, mad(1.0970927476882935f, _141, (_138 * -0.08343357592821121f))) - _141) * _163) + _141;
  float _181 = ((mad(1.2036951780319214f, _144, mad(-0.09862580895423889f, _141, (_138 * -0.02579331398010254f))) - _144) * _163) + _144;
  float _182 = dot(float3(_179, _180, _181), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _196 = ColorOffset.w + ColorOffsetShadows.w;
  float _210 = ColorGain.w * ColorGainShadows.w;
  float _224 = ColorGamma.w * ColorGammaShadows.w;
  float _238 = ColorContrast.w * ColorContrastShadows.w;
  float _252 = ColorSaturation.w * ColorSaturationShadows.w;
  float _256 = _179 - _182;
  float _257 = _180 - _182;
  float _258 = _181 - _182;
  float _315 = saturate(_182 / ColorCorrectionShadowsMax);
  float _319 = (_315 * _315) * (3.0f - (_315 * 2.0f));
  float _320 = 1.0f - _319;
  float _329 = ColorOffset.w + ColorOffsetHighlights.w;
  float _338 = ColorGain.w * ColorGainHighlights.w;
  float _347 = ColorGamma.w * ColorGammaHighlights.w;
  float _356 = ColorContrast.w * ColorContrastHighlights.w;
  float _365 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _428 = saturate((_182 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _432 = (_428 * _428) * (3.0f - (_428 * 2.0f));
  float _441 = ColorOffset.w + ColorOffsetMidtones.w;
  float _450 = ColorGain.w * ColorGainMidtones.w;
  float _459 = ColorGamma.w * ColorGammaMidtones.w;
  float _468 = ColorContrast.w * ColorContrastMidtones.w;
  float _477 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _535 = _319 - _432;
  float _546 = ((_432 * (((ColorOffset.x + ColorOffsetHighlights.x) + _329) + (((ColorGain.x * ColorGainHighlights.x) * _338) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _356) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _365) * _256) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _347)))))) + (_320 * (((ColorOffset.x + ColorOffsetShadows.x) + _196) + (((ColorGain.x * ColorGainShadows.x) * _210) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _238) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _252) * _256) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _224))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _441) + (((ColorGain.x * ColorGainMidtones.x) * _450) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _468) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _477) * _256) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _459))))) * _535);
  float _548 = ((_432 * (((ColorOffset.y + ColorOffsetHighlights.y) + _329) + (((ColorGain.y * ColorGainHighlights.y) * _338) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _356) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _365) * _257) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _347)))))) + (_320 * (((ColorOffset.y + ColorOffsetShadows.y) + _196) + (((ColorGain.y * ColorGainShadows.y) * _210) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _238) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _252) * _257) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _224))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _441) + (((ColorGain.y * ColorGainMidtones.y) * _450) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _468) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _477) * _257) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _459))))) * _535);
  float _550 = ((_432 * (((ColorOffset.z + ColorOffsetHighlights.z) + _329) + (((ColorGain.z * ColorGainHighlights.z) * _338) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _356) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _365) * _258) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _347)))))) + (_320 * (((ColorOffset.z + ColorOffsetShadows.z) + _196) + (((ColorGain.z * ColorGainShadows.z) * _210) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _238) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _252) * _258) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _224))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _441) + (((ColorGain.z * ColorGainMidtones.z) * _450) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _468) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _477) * _258) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _459))))) * _535);
  float _586 = ((mad(0.061360642313957214f, _550, mad(-4.540197551250458e-09f, _548, (_546 * 0.9386394023895264f))) - _546) * BlueCorrection) + _546;
  float _587 = ((mad(0.169205904006958f, _550, mad(0.8307942152023315f, _548, (_546 * 6.775371730327606e-08f))) - _548) * BlueCorrection) + _548;
  float _588 = (mad(-2.3283064365386963e-10f, _548, (_546 * -9.313225746154785e-10f)) * BlueCorrection) + _550;
  float _591 = mad(0.16386905312538147f, _588, mad(0.14067868888378143f, _587, (_586 * 0.6954522132873535f)));
  float _594 = mad(0.0955343246459961f, _588, mad(0.8596711158752441f, _587, (_586 * 0.044794581830501556f)));
  float _597 = mad(1.0015007257461548f, _588, mad(0.004025210160762072f, _587, (_586 * -0.005525882821530104f)));
  float _601 = max(max(_591, _594), _597);
  float _606 = (max(_601, 1.000000013351432e-10f) - max(min(min(_591, _594), _597), 1.000000013351432e-10f)) / max(_601, 0.009999999776482582f);
  float _619 = ((_594 + _591) + _597) + (sqrt((((_597 - _594) * _597) + ((_594 - _591) * _594)) + ((_591 - _597) * _591)) * 1.75f);
  float _620 = _619 * 0.3333333432674408f;
  float _621 = _606 + -0.4000000059604645f;
  float _622 = _621 * 5.0f;
  float _626 = max((1.0f - abs(_621 * 2.5f)), 0.0f);
  float _637 = ((float(((int)(uint)((bool)(_622 > 0.0f))) - ((int)(uint)((bool)(_622 < 0.0f)))) * (1.0f - (_626 * _626))) + 1.0f) * 0.02500000037252903f;
  if (!(_620 <= 0.0533333346247673f)) {
    if (!(_620 >= 0.1599999964237213f)) {
      _646 = (((0.23999999463558197f / _619) + -0.5f) * _637);
    } else {
      _646 = 0.0f;
    }
  } else {
    _646 = _637;
  }
  float _647 = _646 + 1.0f;
  float _648 = _647 * _591;
  float _649 = _647 * _594;
  float _650 = _647 * _597;
  if (!((bool)(_648 == _649) && (bool)(_649 == _650))) {
    float _657 = ((_648 * 2.0f) - _649) - _650;
    float _660 = ((_594 - _597) * 1.7320507764816284f) * _647;
    float _662 = atan(_660 / _657);
    bool _665 = (_657 < 0.0f);
    bool _666 = (_657 == 0.0f);
    bool _667 = (_660 >= 0.0f);
    bool _668 = (_660 < 0.0f);
    _679 = select((_667 && _666), 90.0f, select((_668 && _666), -90.0f, (select((_668 && _665), (_662 + -3.1415927410125732f), select((_667 && _665), (_662 + 3.1415927410125732f), _662)) * 57.2957763671875f)));
  } else {
    _679 = 0.0f;
  }
  float _684 = min(max(select((_679 < 0.0f), (_679 + 360.0f), _679), 0.0f), 360.0f);
  if (_684 < -180.0f) {
    _693 = (_684 + 360.0f);
  } else {
    if (_684 > 180.0f) {
      _693 = (_684 + -360.0f);
    } else {
      _693 = _684;
    }
  }
  float _697 = saturate(1.0f - abs(_693 * 0.014814814552664757f));
  float _701 = (_697 * _697) * (3.0f - (_697 * 2.0f));
  float _707 = ((_701 * _701) * ((_606 * 0.18000000715255737f) * (0.029999999329447746f - _648))) + _648;
  float _717 = max(0.0f, mad(-0.21492856740951538f, _650, mad(-0.2365107536315918f, _649, (_707 * 1.4514392614364624f))));
  float _718 = max(0.0f, mad(-0.09967592358589172f, _650, mad(1.17622971534729f, _649, (_707 * -0.07655377686023712f))));
  float _719 = max(0.0f, mad(0.9977163076400757f, _650, mad(-0.006032449658960104f, _649, (_707 * 0.008316148072481155f))));
  float _720 = dot(float3(_717, _718, _719), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _735 = (FilmBlackClip + 1.0f) - FilmToe;
  float _737 = FilmWhiteClip + 1.0f;
  float _739 = _737 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _757 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _748 = (FilmBlackClip + 0.18000000715255737f) / _735;
    _757 = (-0.7447274923324585f - ((log2(_748 / (2.0f - _748)) * 0.3465735912322998f) * (_735 / FilmSlope)));
  }
  float _760 = ((1.0f - FilmToe) / FilmSlope) - _757;
  float _762 = (FilmShoulder / FilmSlope) - _760;
  float _766 = log2(lerp(_720, _717, 0.9599999785423279f)) * 0.3010300099849701f;
  float _767 = log2(lerp(_720, _718, 0.9599999785423279f)) * 0.3010300099849701f;
  float _768 = log2(lerp(_720, _719, 0.9599999785423279f)) * 0.3010300099849701f;
  float _772 = FilmSlope * (_766 + _760);
  float _773 = FilmSlope * (_767 + _760);
  float _774 = FilmSlope * (_768 + _760);
  float _775 = _735 * 2.0f;
  float _777 = (FilmSlope * -2.0f) / _735;
  float _778 = _766 - _757;
  float _779 = _767 - _757;
  float _780 = _768 - _757;
  float _799 = _739 * 2.0f;
  float _801 = (FilmSlope * 2.0f) / _739;
  float _826 = select((_766 < _757), ((_775 / (exp2((_778 * 1.4426950216293335f) * _777) + 1.0f)) - FilmBlackClip), _772);
  float _827 = select((_767 < _757), ((_775 / (exp2((_779 * 1.4426950216293335f) * _777) + 1.0f)) - FilmBlackClip), _773);
  float _828 = select((_768 < _757), ((_775 / (exp2((_780 * 1.4426950216293335f) * _777) + 1.0f)) - FilmBlackClip), _774);
  float _835 = _762 - _757;
  float _839 = saturate(_778 / _835);
  float _840 = saturate(_779 / _835);
  float _841 = saturate(_780 / _835);
  bool _842 = (_762 < _757);
  float _846 = select(_842, (1.0f - _839), _839);
  float _847 = select(_842, (1.0f - _840), _840);
  float _848 = select(_842, (1.0f - _841), _841);
  float _867 = (((_846 * _846) * (select((_766 > _762), (_737 - (_799 / (exp2(((_766 - _762) * 1.4426950216293335f) * _801) + 1.0f))), _772) - _826)) * (3.0f - (_846 * 2.0f))) + _826;
  float _868 = (((_847 * _847) * (select((_767 > _762), (_737 - (_799 / (exp2(((_767 - _762) * 1.4426950216293335f) * _801) + 1.0f))), _773) - _827)) * (3.0f - (_847 * 2.0f))) + _827;
  float _869 = (((_848 * _848) * (select((_768 > _762), (_737 - (_799 / (exp2(((_768 - _762) * 1.4426950216293335f) * _801) + 1.0f))), _774) - _828)) * (3.0f - (_848 * 2.0f))) + _828;
  float _870 = dot(float3(_867, _868, _869), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _890 = (ToneCurveAmount * (max(0.0f, (lerp(_870, _867, 0.9300000071525574f))) - _586)) + _586;
  float _891 = (ToneCurveAmount * (max(0.0f, (lerp(_870, _868, 0.9300000071525574f))) - _587)) + _587;
  float _892 = (ToneCurveAmount * (max(0.0f, (lerp(_870, _869, 0.9300000071525574f))) - _588)) + _588;
  float _908 = ((mad(-0.06537103652954102f, _892, mad(1.451815478503704e-06f, _891, (_890 * 1.065374732017517f))) - _890) * BlueCorrection) + _890;
  float _909 = ((mad(-0.20366770029067993f, _892, mad(1.2036634683609009f, _891, (_890 * -2.57161445915699e-07f))) - _891) * BlueCorrection) + _891;
  float _910 = ((mad(0.9999996423721313f, _892, mad(2.0954757928848267e-08f, _891, (_890 * 1.862645149230957e-08f))) - _892) * BlueCorrection) + _892;

  SetTonemappedAP1(_908, _909, _910);

  float _923 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _910, mad((WorkingColorSpace_FromAP1[0].y), _909, ((WorkingColorSpace_FromAP1[0].x) * _908)))));
  float _924 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _910, mad((WorkingColorSpace_FromAP1[1].y), _909, ((WorkingColorSpace_FromAP1[1].x) * _908)))));
  float _925 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _910, mad((WorkingColorSpace_FromAP1[2].y), _909, ((WorkingColorSpace_FromAP1[2].x) * _908)))));
  if (_923 < 0.0031306699384003878f) {
    _936 = (_923 * 12.920000076293945f);
  } else {
    _936 = (((pow(_923, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_924 < 0.0031306699384003878f) {
    _947 = (_924 * 12.920000076293945f);
  } else {
    _947 = (((pow(_924, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_925 < 0.0031306699384003878f) {
    _958 = (_925 * 12.920000076293945f);
  } else {
    _958 = (((pow(_925, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _962 = (_947 * 0.9375f) + 0.03125f;
  float _969 = _958 * 15.0f;
  float _970 = floor(_969);
  float _971 = _969 - _970;
  float _973 = (((_936 * 0.9375f) + 0.03125f) + _970) * 0.0625f;
  float4 _976 = Textures_1.SampleLevel(Samplers_1, float2(_973, _962), 0.0f);
  float4 _981 = Textures_1.SampleLevel(Samplers_1, float2((_973 + 0.0625f), _962), 0.0f);
  float _1000 = max(6.103519990574569e-05f, (((lerp(_976.x, _981.x, _971)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _936)));
  float _1001 = max(6.103519990574569e-05f, (((lerp(_976.y, _981.y, _971)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _947)));
  float _1002 = max(6.103519990574569e-05f, (((lerp(_976.z, _981.z, _971)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _958)));
  float _1024 = select((_1000 > 0.040449999272823334f), exp2(log2((_1000 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1000 * 0.07739938050508499f));
  float _1025 = select((_1001 > 0.040449999272823334f), exp2(log2((_1001 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1001 * 0.07739938050508499f));
  float _1026 = select((_1002 > 0.040449999272823334f), exp2(log2((_1002 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1002 * 0.07739938050508499f));
  float _1052 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1024)) * _1024) + MappingPolynomial.z);
  float _1053 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1025)) * _1025) + MappingPolynomial.z);
  float _1054 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1026)) * _1026) + MappingPolynomial.z);
  float _1061 = ((OverlayColor.x - _1052) * OverlayColor.w) + _1052;
  float _1062 = ((OverlayColor.y - _1053) * OverlayColor.w) + _1053;
  float _1063 = ((OverlayColor.z - _1054) * OverlayColor.w) + _1054;
  float _1064 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _550, mad((WorkingColorSpace_FromAP1[0].y), _548, (_546 * (WorkingColorSpace_FromAP1[0].x))));
  float _1065 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _550, mad((WorkingColorSpace_FromAP1[1].y), _548, ((WorkingColorSpace_FromAP1[1].x) * _546)));
  float _1066 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _550, mad((WorkingColorSpace_FromAP1[2].y), _548, ((WorkingColorSpace_FromAP1[2].x) * _546)));
  float _1073 = ((OverlayColor.x - _1064) * OverlayColor.w) + _1064;
  float _1074 = ((OverlayColor.y - _1065) * OverlayColor.w) + _1065;
  float _1075 = ((OverlayColor.z - _1066) * OverlayColor.w) + _1066;
  float _1087 = exp2(log2(max(0.0f, _1061)) * InverseGamma.y);
  float _1088 = exp2(log2(max(0.0f, _1062)) * InverseGamma.y);
  float _1089 = exp2(log2(max(0.0f, _1063)) * InverseGamma.y);

if (CUSTOM_PROCESSING_MODE == 0.f && RENODX_TONE_MAP_TYPE != 0.f) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1087, _1088, _1089));
    return;
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1112 = mad((WorkingColorSpace_ToAP1[0].z), _1089, mad((WorkingColorSpace_ToAP1[0].y), _1088, ((WorkingColorSpace_ToAP1[0].x) * _1087)));
        float _1115 = mad((WorkingColorSpace_ToAP1[1].z), _1089, mad((WorkingColorSpace_ToAP1[1].y), _1088, ((WorkingColorSpace_ToAP1[1].x) * _1087)));
        float _1118 = mad((WorkingColorSpace_ToAP1[2].z), _1089, mad((WorkingColorSpace_ToAP1[2].y), _1088, ((WorkingColorSpace_ToAP1[2].x) * _1087)));
        _1129 = mad(_57, _1118, mad(_56, _1115, (_1112 * _55)));
        _1130 = mad(_60, _1118, mad(_59, _1115, (_1112 * _58)));
        _1131 = mad(_63, _1118, mad(_62, _1115, (_1112 * _61)));
      } else {
        _1129 = _1087;
        _1130 = _1088;
        _1131 = _1089;
      }
      do {
        if (_1129 < 0.0031306699384003878f) {
          _1142 = (_1129 * 12.920000076293945f);
        } else {
          _1142 = (((pow(_1129, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1130 < 0.0031306699384003878f) {
            _1153 = (_1130 * 12.920000076293945f);
          } else {
            _1153 = (((pow(_1130, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1131 < 0.0031306699384003878f) {
            _2509 = _1142;
            _2510 = _1153;
            _2511 = (_1131 * 12.920000076293945f);
          } else {
            _2509 = _1142;
            _2510 = _1153;
            _2511 = (((pow(_1131, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1180 = mad((WorkingColorSpace_ToAP1[0].z), _1089, mad((WorkingColorSpace_ToAP1[0].y), _1088, ((WorkingColorSpace_ToAP1[0].x) * _1087)));
      float _1183 = mad((WorkingColorSpace_ToAP1[1].z), _1089, mad((WorkingColorSpace_ToAP1[1].y), _1088, ((WorkingColorSpace_ToAP1[1].x) * _1087)));
      float _1186 = mad((WorkingColorSpace_ToAP1[2].z), _1089, mad((WorkingColorSpace_ToAP1[2].y), _1088, ((WorkingColorSpace_ToAP1[2].x) * _1087)));
      float _1196 = max(6.103519990574569e-05f, mad(_57, _1186, mad(_56, _1183, (_1180 * _55))));
      float _1197 = max(6.103519990574569e-05f, mad(_60, _1186, mad(_59, _1183, (_1180 * _58))));
      float _1198 = max(6.103519990574569e-05f, mad(_63, _1186, mad(_62, _1183, (_1180 * _61))));
      _2509 = min((_1196 * 4.5f), ((exp2(log2(max(_1196, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2510 = min((_1197 * 4.5f), ((exp2(log2(max(_1197, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2511 = min((_1198 * 4.5f), ((exp2(log2(max(_1198, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        _13[0] = ACESCoefsLow_0.x;
        _13[1] = ACESCoefsLow_0.y;
        _13[2] = ACESCoefsLow_0.z;
        _13[3] = ACESCoefsLow_0.w;
        _13[4] = ACESCoefsLow_4;
        _13[5] = ACESCoefsLow_4;
        _14[0] = ACESCoefsHigh_0.x;
        _14[1] = ACESCoefsHigh_0.y;
        _14[2] = ACESCoefsHigh_0.z;
        _14[3] = ACESCoefsHigh_0.w;
        _14[4] = ACESCoefsHigh_4;
        _14[5] = ACESCoefsHigh_4;
        float _1273 = ACESSceneColorMultiplier * _1073;
        float _1274 = ACESSceneColorMultiplier * _1074;
        float _1275 = ACESSceneColorMultiplier * _1075;
        float _1278 = mad((WorkingColorSpace_ToAP0[0].z), _1275, mad((WorkingColorSpace_ToAP0[0].y), _1274, ((WorkingColorSpace_ToAP0[0].x) * _1273)));
        float _1281 = mad((WorkingColorSpace_ToAP0[1].z), _1275, mad((WorkingColorSpace_ToAP0[1].y), _1274, ((WorkingColorSpace_ToAP0[1].x) * _1273)));
        float _1284 = mad((WorkingColorSpace_ToAP0[2].z), _1275, mad((WorkingColorSpace_ToAP0[2].y), _1274, ((WorkingColorSpace_ToAP0[2].x) * _1273)));
        float _1288 = max(max(_1278, _1281), _1284);
        float _1293 = (max(_1288, 1.000000013351432e-10f) - max(min(min(_1278, _1281), _1284), 1.000000013351432e-10f)) / max(_1288, 0.009999999776482582f);
        float _1306 = ((_1281 + _1278) + _1284) + (sqrt((((_1284 - _1281) * _1284) + ((_1281 - _1278) * _1281)) + ((_1278 - _1284) * _1278)) * 1.75f);
        float _1307 = _1306 * 0.3333333432674408f;
        float _1308 = _1293 + -0.4000000059604645f;
        float _1309 = _1308 * 5.0f;
        float _1313 = max((1.0f - abs(_1308 * 2.5f)), 0.0f);
        float _1324 = ((float(((int)(uint)((bool)(_1309 > 0.0f))) - ((int)(uint)((bool)(_1309 < 0.0f)))) * (1.0f - (_1313 * _1313))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1307 <= 0.0533333346247673f)) {
            if (!(_1307 >= 0.1599999964237213f)) {
              _1333 = (((0.23999999463558197f / _1306) + -0.5f) * _1324);
            } else {
              _1333 = 0.0f;
            }
          } else {
            _1333 = _1324;
          }
          float _1334 = _1333 + 1.0f;
          float _1335 = _1334 * _1278;
          float _1336 = _1334 * _1281;
          float _1337 = _1334 * _1284;
          do {
            if (!((bool)(_1335 == _1336) && (bool)(_1336 == _1337))) {
              float _1344 = ((_1335 * 2.0f) - _1336) - _1337;
              float _1347 = ((_1281 - _1284) * 1.7320507764816284f) * _1334;
              float _1349 = atan(_1347 / _1344);
              bool _1352 = (_1344 < 0.0f);
              bool _1353 = (_1344 == 0.0f);
              bool _1354 = (_1347 >= 0.0f);
              bool _1355 = (_1347 < 0.0f);
              _1366 = select((_1354 && _1353), 90.0f, select((_1355 && _1353), -90.0f, (select((_1355 && _1352), (_1349 + -3.1415927410125732f), select((_1354 && _1352), (_1349 + 3.1415927410125732f), _1349)) * 57.2957763671875f)));
            } else {
              _1366 = 0.0f;
            }
            float _1371 = min(max(select((_1366 < 0.0f), (_1366 + 360.0f), _1366), 0.0f), 360.0f);
            do {
              if (_1371 < -180.0f) {
                _1380 = (_1371 + 360.0f);
              } else {
                if (_1371 > 180.0f) {
                  _1380 = (_1371 + -360.0f);
                } else {
                  _1380 = _1371;
                }
              }
              do {
                if ((bool)(_1380 > -67.5f) && (bool)(_1380 < 67.5f)) {
                  float _1386 = (_1380 + 67.5f) * 0.029629629105329514f;
                  int _1387 = int(_1386);
                  float _1389 = _1386 - float(_1387);
                  float _1390 = _1389 * _1389;
                  float _1391 = _1390 * _1389;
                  if (_1387 == 3) {
                    _1419 = (((0.1666666716337204f - (_1389 * 0.5f)) + (_1390 * 0.5f)) - (_1391 * 0.1666666716337204f));
                  } else {
                    if (_1387 == 2) {
                      _1419 = ((0.6666666865348816f - _1390) + (_1391 * 0.5f));
                    } else {
                      if (_1387 == 1) {
                        _1419 = (((_1391 * -0.5f) + 0.1666666716337204f) + ((_1390 + _1389) * 0.5f));
                      } else {
                        _1419 = select((_1387 == 0), (_1391 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1419 = 0.0f;
                }
                float _1428 = min(max(((((_1293 * 0.27000001072883606f) * (0.029999999329447746f - _1335)) * _1419) + _1335), 0.0f), 65535.0f);
                float _1429 = min(max(_1336, 0.0f), 65535.0f);
                float _1430 = min(max(_1337, 0.0f), 65535.0f);
                float _1443 = min(max(mad(-0.21492856740951538f, _1430, mad(-0.2365107536315918f, _1429, (_1428 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1444 = min(max(mad(-0.09967592358589172f, _1430, mad(1.17622971534729f, _1429, (_1428 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1445 = min(max(mad(0.9977163076400757f, _1430, mad(-0.006032449658960104f, _1429, (_1428 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1446 = dot(float3(_1443, _1444, _1445), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1457 = log2(max((lerp(_1446, _1443, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1458 = _1457 * 0.3010300099849701f;
                float _1459 = log2(ACESMinMaxData.x);
                float _1460 = _1459 * 0.3010300099849701f;
                do {
                  if (!(!(_1458 <= _1460))) {
                    _1529 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1467 = log2(ACESMidData.x);
                    float _1468 = _1467 * 0.3010300099849701f;
                    if ((bool)(_1458 > _1460) && (bool)(_1458 < _1468)) {
                      float _1476 = ((_1457 - _1459) * 0.9030900001525879f) / ((_1467 - _1459) * 0.3010300099849701f);
                      int _1477 = int(_1476);
                      float _1479 = _1476 - float(_1477);
                      float _1481 = _13[_1477];
                      float _1484 = _13[(_1477 + 1)];
                      float _1489 = _1481 * 0.5f;
                      _1529 = dot(float3((_1479 * _1479), _1479, 1.0f), float3(mad((_13[(_1477 + 2)]), 0.5f, mad(_1484, -1.0f, _1489)), (_1484 - _1481), mad(_1484, 0.5f, _1489)));
                    } else {
                      do {
                        if (!(!(_1458 >= _1468))) {
                          float _1498 = log2(ACESMinMaxData.z);
                          if (_1458 < (_1498 * 0.3010300099849701f)) {
                            float _1506 = ((_1457 - _1467) * 0.9030900001525879f) / ((_1498 - _1467) * 0.3010300099849701f);
                            int _1507 = int(_1506);
                            float _1509 = _1506 - float(_1507);
                            float _1511 = _14[_1507];
                            float _1514 = _14[(_1507 + 1)];
                            float _1519 = _1511 * 0.5f;
                            _1529 = dot(float3((_1509 * _1509), _1509, 1.0f), float3(mad((_14[(_1507 + 2)]), 0.5f, mad(_1514, -1.0f, _1519)), (_1514 - _1511), mad(_1514, 0.5f, _1519)));
                            break;
                          }
                        }
                        _1529 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1533 = log2(max((lerp(_1446, _1444, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1534 = _1533 * 0.3010300099849701f;
                  do {
                    if (!(!(_1534 <= _1460))) {
                      _1603 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1541 = log2(ACESMidData.x);
                      float _1542 = _1541 * 0.3010300099849701f;
                      if ((bool)(_1534 > _1460) && (bool)(_1534 < _1542)) {
                        float _1550 = ((_1533 - _1459) * 0.9030900001525879f) / ((_1541 - _1459) * 0.3010300099849701f);
                        int _1551 = int(_1550);
                        float _1553 = _1550 - float(_1551);
                        float _1555 = _13[_1551];
                        float _1558 = _13[(_1551 + 1)];
                        float _1563 = _1555 * 0.5f;
                        _1603 = dot(float3((_1553 * _1553), _1553, 1.0f), float3(mad((_13[(_1551 + 2)]), 0.5f, mad(_1558, -1.0f, _1563)), (_1558 - _1555), mad(_1558, 0.5f, _1563)));
                      } else {
                        do {
                          if (!(!(_1534 >= _1542))) {
                            float _1572 = log2(ACESMinMaxData.z);
                            if (_1534 < (_1572 * 0.3010300099849701f)) {
                              float _1580 = ((_1533 - _1541) * 0.9030900001525879f) / ((_1572 - _1541) * 0.3010300099849701f);
                              int _1581 = int(_1580);
                              float _1583 = _1580 - float(_1581);
                              float _1585 = _14[_1581];
                              float _1588 = _14[(_1581 + 1)];
                              float _1593 = _1585 * 0.5f;
                              _1603 = dot(float3((_1583 * _1583), _1583, 1.0f), float3(mad((_14[(_1581 + 2)]), 0.5f, mad(_1588, -1.0f, _1593)), (_1588 - _1585), mad(_1588, 0.5f, _1593)));
                              break;
                            }
                          }
                          _1603 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1607 = log2(max((lerp(_1446, _1445, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1608 = _1607 * 0.3010300099849701f;
                    do {
                      if (!(!(_1608 <= _1460))) {
                        _1677 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1615 = log2(ACESMidData.x);
                        float _1616 = _1615 * 0.3010300099849701f;
                        if ((bool)(_1608 > _1460) && (bool)(_1608 < _1616)) {
                          float _1624 = ((_1607 - _1459) * 0.9030900001525879f) / ((_1615 - _1459) * 0.3010300099849701f);
                          int _1625 = int(_1624);
                          float _1627 = _1624 - float(_1625);
                          float _1629 = _13[_1625];
                          float _1632 = _13[(_1625 + 1)];
                          float _1637 = _1629 * 0.5f;
                          _1677 = dot(float3((_1627 * _1627), _1627, 1.0f), float3(mad((_13[(_1625 + 2)]), 0.5f, mad(_1632, -1.0f, _1637)), (_1632 - _1629), mad(_1632, 0.5f, _1637)));
                        } else {
                          do {
                            if (!(!(_1608 >= _1616))) {
                              float _1646 = log2(ACESMinMaxData.z);
                              if (_1608 < (_1646 * 0.3010300099849701f)) {
                                float _1654 = ((_1607 - _1615) * 0.9030900001525879f) / ((_1646 - _1615) * 0.3010300099849701f);
                                int _1655 = int(_1654);
                                float _1657 = _1654 - float(_1655);
                                float _1659 = _14[_1655];
                                float _1662 = _14[(_1655 + 1)];
                                float _1667 = _1659 * 0.5f;
                                _1677 = dot(float3((_1657 * _1657), _1657, 1.0f), float3(mad((_14[(_1655 + 2)]), 0.5f, mad(_1662, -1.0f, _1667)), (_1662 - _1659), mad(_1662, 0.5f, _1667)));
                                break;
                              }
                            }
                            _1677 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1681 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1682 = (exp2(_1529 * 3.321928024291992f) - ACESMinMaxData.y) / _1681;
                      float _1684 = (exp2(_1603 * 3.321928024291992f) - ACESMinMaxData.y) / _1681;
                      float _1686 = (exp2(_1677 * 3.321928024291992f) - ACESMinMaxData.y) / _1681;
                      float _1689 = mad(0.15618768334388733f, _1686, mad(0.13400420546531677f, _1684, (_1682 * 0.6624541878700256f)));
                      float _1692 = mad(0.053689517080783844f, _1686, mad(0.6740817427635193f, _1684, (_1682 * 0.2722287178039551f)));
                      float _1695 = mad(1.0103391408920288f, _1686, mad(0.00406073359772563f, _1684, (_1682 * -0.005574649665504694f)));
                      float _1708 = min(max(mad(-0.23642469942569733f, _1695, mad(-0.32480329275131226f, _1692, (_1689 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1709 = min(max(mad(0.016756348311901093f, _1695, mad(1.6153316497802734f, _1692, (_1689 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1710 = min(max(mad(0.9883948564529419f, _1695, mad(-0.008284442126750946f, _1692, (_1689 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1713 = mad(0.15618768334388733f, _1710, mad(0.13400420546531677f, _1709, (_1708 * 0.6624541878700256f)));
                      float _1716 = mad(0.053689517080783844f, _1710, mad(0.6740817427635193f, _1709, (_1708 * 0.2722287178039551f)));
                      float _1719 = mad(1.0103391408920288f, _1710, mad(0.00406073359772563f, _1709, (_1708 * -0.005574649665504694f)));
                      float _1741 = min(max((min(max(mad(-0.23642469942569733f, _1719, mad(-0.32480329275131226f, _1716, (_1713 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1742 = min(max((min(max(mad(0.016756348311901093f, _1719, mad(1.6153316497802734f, _1716, (_1713 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1743 = min(max((min(max(mad(0.9883948564529419f, _1719, mad(-0.008284442126750946f, _1716, (_1713 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(OutputDevice) == 5)) {
                          _1756 = mad(_57, _1743, mad(_56, _1742, (_1741 * _55)));
                          _1757 = mad(_60, _1743, mad(_59, _1742, (_1741 * _58)));
                          _1758 = mad(_63, _1743, mad(_62, _1742, (_1741 * _61)));
                        } else {
                          _1756 = _1741;
                          _1757 = _1742;
                          _1758 = _1743;
                        }
                        float _1768 = exp2(log2(_1756 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1769 = exp2(log2(_1757 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1770 = exp2(log2(_1758 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2509 = exp2(log2((1.0f / ((_1768 * 18.6875f) + 1.0f)) * ((_1768 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2510 = exp2(log2((1.0f / ((_1769 * 18.6875f) + 1.0f)) * ((_1769 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2511 = exp2(log2((1.0f / ((_1770 * 18.6875f) + 1.0f)) * ((_1770 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if (((uint)(OutputDevice) & -3) == 4) {
          _11[0] = ACESCoefsLow_0.x;
          _11[1] = ACESCoefsLow_0.y;
          _11[2] = ACESCoefsLow_0.z;
          _11[3] = ACESCoefsLow_0.w;
          _11[4] = ACESCoefsLow_4;
          _11[5] = ACESCoefsLow_4;
          _12[0] = ACESCoefsHigh_0.x;
          _12[1] = ACESCoefsHigh_0.y;
          _12[2] = ACESCoefsHigh_0.z;
          _12[3] = ACESCoefsHigh_0.w;
          _12[4] = ACESCoefsHigh_4;
          _12[5] = ACESCoefsHigh_4;
          float _1847 = ACESSceneColorMultiplier * _1073;
          float _1848 = ACESSceneColorMultiplier * _1074;
          float _1849 = ACESSceneColorMultiplier * _1075;
          float _1852 = mad((WorkingColorSpace_ToAP0[0].z), _1849, mad((WorkingColorSpace_ToAP0[0].y), _1848, ((WorkingColorSpace_ToAP0[0].x) * _1847)));
          float _1855 = mad((WorkingColorSpace_ToAP0[1].z), _1849, mad((WorkingColorSpace_ToAP0[1].y), _1848, ((WorkingColorSpace_ToAP0[1].x) * _1847)));
          float _1858 = mad((WorkingColorSpace_ToAP0[2].z), _1849, mad((WorkingColorSpace_ToAP0[2].y), _1848, ((WorkingColorSpace_ToAP0[2].x) * _1847)));
          float _1862 = max(max(_1852, _1855), _1858);
          float _1867 = (max(_1862, 1.000000013351432e-10f) - max(min(min(_1852, _1855), _1858), 1.000000013351432e-10f)) / max(_1862, 0.009999999776482582f);
          float _1880 = ((_1855 + _1852) + _1858) + (sqrt((((_1858 - _1855) * _1858) + ((_1855 - _1852) * _1855)) + ((_1852 - _1858) * _1852)) * 1.75f);
          float _1881 = _1880 * 0.3333333432674408f;
          float _1882 = _1867 + -0.4000000059604645f;
          float _1883 = _1882 * 5.0f;
          float _1887 = max((1.0f - abs(_1882 * 2.5f)), 0.0f);
          float _1898 = ((float(((int)(uint)((bool)(_1883 > 0.0f))) - ((int)(uint)((bool)(_1883 < 0.0f)))) * (1.0f - (_1887 * _1887))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1881 <= 0.0533333346247673f)) {
              if (!(_1881 >= 0.1599999964237213f)) {
                _1907 = (((0.23999999463558197f / _1880) + -0.5f) * _1898);
              } else {
                _1907 = 0.0f;
              }
            } else {
              _1907 = _1898;
            }
            float _1908 = _1907 + 1.0f;
            float _1909 = _1908 * _1852;
            float _1910 = _1908 * _1855;
            float _1911 = _1908 * _1858;
            do {
              if (!((bool)(_1909 == _1910) && (bool)(_1910 == _1911))) {
                float _1918 = ((_1909 * 2.0f) - _1910) - _1911;
                float _1921 = ((_1855 - _1858) * 1.7320507764816284f) * _1908;
                float _1923 = atan(_1921 / _1918);
                bool _1926 = (_1918 < 0.0f);
                bool _1927 = (_1918 == 0.0f);
                bool _1928 = (_1921 >= 0.0f);
                bool _1929 = (_1921 < 0.0f);
                _1940 = select((_1928 && _1927), 90.0f, select((_1929 && _1927), -90.0f, (select((_1929 && _1926), (_1923 + -3.1415927410125732f), select((_1928 && _1926), (_1923 + 3.1415927410125732f), _1923)) * 57.2957763671875f)));
              } else {
                _1940 = 0.0f;
              }
              float _1945 = min(max(select((_1940 < 0.0f), (_1940 + 360.0f), _1940), 0.0f), 360.0f);
              do {
                if (_1945 < -180.0f) {
                  _1954 = (_1945 + 360.0f);
                } else {
                  if (_1945 > 180.0f) {
                    _1954 = (_1945 + -360.0f);
                  } else {
                    _1954 = _1945;
                  }
                }
                do {
                  if ((bool)(_1954 > -67.5f) && (bool)(_1954 < 67.5f)) {
                    float _1960 = (_1954 + 67.5f) * 0.029629629105329514f;
                    int _1961 = int(_1960);
                    float _1963 = _1960 - float(_1961);
                    float _1964 = _1963 * _1963;
                    float _1965 = _1964 * _1963;
                    if (_1961 == 3) {
                      _1993 = (((0.1666666716337204f - (_1963 * 0.5f)) + (_1964 * 0.5f)) - (_1965 * 0.1666666716337204f));
                    } else {
                      if (_1961 == 2) {
                        _1993 = ((0.6666666865348816f - _1964) + (_1965 * 0.5f));
                      } else {
                        if (_1961 == 1) {
                          _1993 = (((_1965 * -0.5f) + 0.1666666716337204f) + ((_1964 + _1963) * 0.5f));
                        } else {
                          _1993 = select((_1961 == 0), (_1965 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1993 = 0.0f;
                  }
                  float _2002 = min(max(((((_1867 * 0.27000001072883606f) * (0.029999999329447746f - _1909)) * _1993) + _1909), 0.0f), 65535.0f);
                  float _2003 = min(max(_1910, 0.0f), 65535.0f);
                  float _2004 = min(max(_1911, 0.0f), 65535.0f);
                  float _2017 = min(max(mad(-0.21492856740951538f, _2004, mad(-0.2365107536315918f, _2003, (_2002 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2018 = min(max(mad(-0.09967592358589172f, _2004, mad(1.17622971534729f, _2003, (_2002 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2019 = min(max(mad(0.9977163076400757f, _2004, mad(-0.006032449658960104f, _2003, (_2002 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2020 = dot(float3(_2017, _2018, _2019), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2031 = log2(max((lerp(_2020, _2017, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2032 = _2031 * 0.3010300099849701f;
                  float _2033 = log2(ACESMinMaxData.x);
                  float _2034 = _2033 * 0.3010300099849701f;
                  do {
                    if (!(!(_2032 <= _2034))) {
                      _2103 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2041 = log2(ACESMidData.x);
                      float _2042 = _2041 * 0.3010300099849701f;
                      if ((bool)(_2032 > _2034) && (bool)(_2032 < _2042)) {
                        float _2050 = ((_2031 - _2033) * 0.9030900001525879f) / ((_2041 - _2033) * 0.3010300099849701f);
                        int _2051 = int(_2050);
                        float _2053 = _2050 - float(_2051);
                        float _2055 = _11[_2051];
                        float _2058 = _11[(_2051 + 1)];
                        float _2063 = _2055 * 0.5f;
                        _2103 = dot(float3((_2053 * _2053), _2053, 1.0f), float3(mad((_11[(_2051 + 2)]), 0.5f, mad(_2058, -1.0f, _2063)), (_2058 - _2055), mad(_2058, 0.5f, _2063)));
                      } else {
                        do {
                          if (!(!(_2032 >= _2042))) {
                            float _2072 = log2(ACESMinMaxData.z);
                            if (_2032 < (_2072 * 0.3010300099849701f)) {
                              float _2080 = ((_2031 - _2041) * 0.9030900001525879f) / ((_2072 - _2041) * 0.3010300099849701f);
                              int _2081 = int(_2080);
                              float _2083 = _2080 - float(_2081);
                              float _2085 = _12[_2081];
                              float _2088 = _12[(_2081 + 1)];
                              float _2093 = _2085 * 0.5f;
                              _2103 = dot(float3((_2083 * _2083), _2083, 1.0f), float3(mad((_12[(_2081 + 2)]), 0.5f, mad(_2088, -1.0f, _2093)), (_2088 - _2085), mad(_2088, 0.5f, _2093)));
                              break;
                            }
                          }
                          _2103 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2107 = log2(max((lerp(_2020, _2018, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2108 = _2107 * 0.3010300099849701f;
                    do {
                      if (!(!(_2108 <= _2034))) {
                        _2177 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2115 = log2(ACESMidData.x);
                        float _2116 = _2115 * 0.3010300099849701f;
                        if ((bool)(_2108 > _2034) && (bool)(_2108 < _2116)) {
                          float _2124 = ((_2107 - _2033) * 0.9030900001525879f) / ((_2115 - _2033) * 0.3010300099849701f);
                          int _2125 = int(_2124);
                          float _2127 = _2124 - float(_2125);
                          float _2129 = _11[_2125];
                          float _2132 = _11[(_2125 + 1)];
                          float _2137 = _2129 * 0.5f;
                          _2177 = dot(float3((_2127 * _2127), _2127, 1.0f), float3(mad((_11[(_2125 + 2)]), 0.5f, mad(_2132, -1.0f, _2137)), (_2132 - _2129), mad(_2132, 0.5f, _2137)));
                        } else {
                          do {
                            if (!(!(_2108 >= _2116))) {
                              float _2146 = log2(ACESMinMaxData.z);
                              if (_2108 < (_2146 * 0.3010300099849701f)) {
                                float _2154 = ((_2107 - _2115) * 0.9030900001525879f) / ((_2146 - _2115) * 0.3010300099849701f);
                                int _2155 = int(_2154);
                                float _2157 = _2154 - float(_2155);
                                float _2159 = _12[_2155];
                                float _2162 = _12[(_2155 + 1)];
                                float _2167 = _2159 * 0.5f;
                                _2177 = dot(float3((_2157 * _2157), _2157, 1.0f), float3(mad((_12[(_2155 + 2)]), 0.5f, mad(_2162, -1.0f, _2167)), (_2162 - _2159), mad(_2162, 0.5f, _2167)));
                                break;
                              }
                            }
                            _2177 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2181 = log2(max((lerp(_2020, _2019, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2182 = _2181 * 0.3010300099849701f;
                      do {
                        if (!(!(_2182 <= _2034))) {
                          _2251 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2189 = log2(ACESMidData.x);
                          float _2190 = _2189 * 0.3010300099849701f;
                          if ((bool)(_2182 > _2034) && (bool)(_2182 < _2190)) {
                            float _2198 = ((_2181 - _2033) * 0.9030900001525879f) / ((_2189 - _2033) * 0.3010300099849701f);
                            int _2199 = int(_2198);
                            float _2201 = _2198 - float(_2199);
                            float _2203 = _11[_2199];
                            float _2206 = _11[(_2199 + 1)];
                            float _2211 = _2203 * 0.5f;
                            _2251 = dot(float3((_2201 * _2201), _2201, 1.0f), float3(mad((_11[(_2199 + 2)]), 0.5f, mad(_2206, -1.0f, _2211)), (_2206 - _2203), mad(_2206, 0.5f, _2211)));
                          } else {
                            do {
                              if (!(!(_2182 >= _2190))) {
                                float _2220 = log2(ACESMinMaxData.z);
                                if (_2182 < (_2220 * 0.3010300099849701f)) {
                                  float _2228 = ((_2181 - _2189) * 0.9030900001525879f) / ((_2220 - _2189) * 0.3010300099849701f);
                                  int _2229 = int(_2228);
                                  float _2231 = _2228 - float(_2229);
                                  float _2233 = _12[_2229];
                                  float _2236 = _12[(_2229 + 1)];
                                  float _2241 = _2233 * 0.5f;
                                  _2251 = dot(float3((_2231 * _2231), _2231, 1.0f), float3(mad((_12[(_2229 + 2)]), 0.5f, mad(_2236, -1.0f, _2241)), (_2236 - _2233), mad(_2236, 0.5f, _2241)));
                                  break;
                                }
                              }
                              _2251 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2255 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2256 = (exp2(_2103 * 3.321928024291992f) - ACESMinMaxData.y) / _2255;
                        float _2258 = (exp2(_2177 * 3.321928024291992f) - ACESMinMaxData.y) / _2255;
                        float _2260 = (exp2(_2251 * 3.321928024291992f) - ACESMinMaxData.y) / _2255;
                        float _2263 = mad(0.15618768334388733f, _2260, mad(0.13400420546531677f, _2258, (_2256 * 0.6624541878700256f)));
                        float _2266 = mad(0.053689517080783844f, _2260, mad(0.6740817427635193f, _2258, (_2256 * 0.2722287178039551f)));
                        float _2269 = mad(1.0103391408920288f, _2260, mad(0.00406073359772563f, _2258, (_2256 * -0.005574649665504694f)));
                        float _2282 = min(max(mad(-0.23642469942569733f, _2269, mad(-0.32480329275131226f, _2266, (_2263 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2283 = min(max(mad(0.016756348311901093f, _2269, mad(1.6153316497802734f, _2266, (_2263 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2284 = min(max(mad(0.9883948564529419f, _2269, mad(-0.008284442126750946f, _2266, (_2263 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2287 = mad(0.15618768334388733f, _2284, mad(0.13400420546531677f, _2283, (_2282 * 0.6624541878700256f)));
                        float _2290 = mad(0.053689517080783844f, _2284, mad(0.6740817427635193f, _2283, (_2282 * 0.2722287178039551f)));
                        float _2293 = mad(1.0103391408920288f, _2284, mad(0.00406073359772563f, _2283, (_2282 * -0.005574649665504694f)));
                        float _2315 = min(max((min(max(mad(-0.23642469942569733f, _2293, mad(-0.32480329275131226f, _2290, (_2287 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2316 = min(max((min(max(mad(0.016756348311901093f, _2293, mad(1.6153316497802734f, _2290, (_2287 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2317 = min(max((min(max(mad(0.9883948564529419f, _2293, mad(-0.008284442126750946f, _2290, (_2287 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 6)) {
                            _2330 = mad(_57, _2317, mad(_56, _2316, (_2315 * _55)));
                            _2331 = mad(_60, _2317, mad(_59, _2316, (_2315 * _58)));
                            _2332 = mad(_63, _2317, mad(_62, _2316, (_2315 * _61)));
                          } else {
                            _2330 = _2315;
                            _2331 = _2316;
                            _2332 = _2317;
                          }
                          float _2342 = exp2(log2(_2330 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2343 = exp2(log2(_2331 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2344 = exp2(log2(_2332 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2509 = exp2(log2((1.0f / ((_2342 * 18.6875f) + 1.0f)) * ((_2342 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2510 = exp2(log2((1.0f / ((_2343 * 18.6875f) + 1.0f)) * ((_2343 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2511 = exp2(log2((1.0f / ((_2344 * 18.6875f) + 1.0f)) * ((_2344 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if ((uint)(OutputDevice) == 7) {
            float _2389 = mad((WorkingColorSpace_ToAP1[0].z), _1075, mad((WorkingColorSpace_ToAP1[0].y), _1074, ((WorkingColorSpace_ToAP1[0].x) * _1073)));
            float _2392 = mad((WorkingColorSpace_ToAP1[1].z), _1075, mad((WorkingColorSpace_ToAP1[1].y), _1074, ((WorkingColorSpace_ToAP1[1].x) * _1073)));
            float _2395 = mad((WorkingColorSpace_ToAP1[2].z), _1075, mad((WorkingColorSpace_ToAP1[2].y), _1074, ((WorkingColorSpace_ToAP1[2].x) * _1073)));
            float _2414 = exp2(log2(mad(_57, _2395, mad(_56, _2392, (_2389 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2415 = exp2(log2(mad(_60, _2395, mad(_59, _2392, (_2389 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2416 = exp2(log2(mad(_63, _2395, mad(_62, _2392, (_2389 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2509 = exp2(log2((1.0f / ((_2414 * 18.6875f) + 1.0f)) * ((_2414 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2510 = exp2(log2((1.0f / ((_2415 * 18.6875f) + 1.0f)) * ((_2415 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2511 = exp2(log2((1.0f / ((_2416 * 18.6875f) + 1.0f)) * ((_2416 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2463 = mad((WorkingColorSpace_ToAP1[0].z), _1063, mad((WorkingColorSpace_ToAP1[0].y), _1062, ((WorkingColorSpace_ToAP1[0].x) * _1061)));
                float _2466 = mad((WorkingColorSpace_ToAP1[1].z), _1063, mad((WorkingColorSpace_ToAP1[1].y), _1062, ((WorkingColorSpace_ToAP1[1].x) * _1061)));
                float _2469 = mad((WorkingColorSpace_ToAP1[2].z), _1063, mad((WorkingColorSpace_ToAP1[2].y), _1062, ((WorkingColorSpace_ToAP1[2].x) * _1061)));
                _2509 = mad(_57, _2469, mad(_56, _2466, (_2463 * _55)));
                _2510 = mad(_60, _2469, mad(_59, _2466, (_2463 * _58)));
                _2511 = mad(_63, _2469, mad(_62, _2466, (_2463 * _61)));
              } else {
                float _2482 = mad((WorkingColorSpace_ToAP1[0].z), _1089, mad((WorkingColorSpace_ToAP1[0].y), _1088, ((WorkingColorSpace_ToAP1[0].x) * _1087)));
                float _2485 = mad((WorkingColorSpace_ToAP1[1].z), _1089, mad((WorkingColorSpace_ToAP1[1].y), _1088, ((WorkingColorSpace_ToAP1[1].x) * _1087)));
                float _2488 = mad((WorkingColorSpace_ToAP1[2].z), _1089, mad((WorkingColorSpace_ToAP1[2].y), _1088, ((WorkingColorSpace_ToAP1[2].x) * _1087)));
                _2509 = exp2(log2(mad(_57, _2488, mad(_56, _2485, (_2482 * _55)))) * InverseGamma.z);
                _2510 = exp2(log2(mad(_60, _2488, mad(_59, _2485, (_2482 * _58)))) * InverseGamma.z);
                _2511 = exp2(log2(mad(_63, _2488, mad(_62, _2485, (_2482 * _61)))) * InverseGamma.z);
              }
            } else {
              _2509 = _1073;
              _2510 = _1074;
              _2511 = _1075;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2509 * 0.9523810148239136f), (_2510 * 0.9523810148239136f), (_2511 * 0.9523810148239136f), 0.0f);
}

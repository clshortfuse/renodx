#include "../common.hlsl"

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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _9[6];
  float _10[6];
  float _11[6];
  float _12[6];
  float _24 = 0.5f / LUTSize;
  float _29 = LUTSize + -1.0f;
  float _30 = (LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _24)) / _29;
  float _31 = (LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _24)) / _29;
  float _33 = float((uint)SV_DispatchThreadID.z) / _29;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _119;
  float _120;
  float _121;
  float _644;
  float _677;
  float _691;
  float _755;
  float _1023;
  float _1024;
  float _1025;
  float _1036;
  float _1047;
  float _1227;
  float _1260;
  float _1274;
  float _1313;
  float _1423;
  float _1497;
  float _1571;
  float _1650;
  float _1651;
  float _1652;
  float _1801;
  float _1834;
  float _1848;
  float _1887;
  float _1997;
  float _2071;
  float _2145;
  float _2224;
  float _2225;
  float _2226;
  float _2403;
  float _2404;
  float _2405;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _42 = ((uint)(OutputGamut) == 4);
        _53 = select(_42, 1.0f, 1.705051064491272f);
        _54 = select(_42, 0.0f, -0.6217921376228333f);
        _55 = select(_42, 0.0f, -0.0832589864730835f);
        _56 = select(_42, 0.0f, -0.13025647401809692f);
        _57 = select(_42, 1.0f, 1.140804648399353f);
        _58 = select(_42, 0.0f, -0.010548308491706848f);
        _59 = select(_42, 0.0f, -0.024003351107239723f);
        _60 = select(_42, 0.0f, -0.1289689838886261f);
        _61 = select(_42, 1.0f, 1.1529725790023804f);
      } else {
        _53 = 0.6954522132873535f;
        _54 = 0.14067870378494263f;
        _55 = 0.16386906802654266f;
        _56 = 0.044794563204050064f;
        _57 = 0.8596711158752441f;
        _58 = 0.0955343171954155f;
        _59 = -0.005525882821530104f;
        _60 = 0.004025210160762072f;
        _61 = 1.0015007257461548f;
      }
    } else {
      _53 = 1.0258246660232544f;
      _54 = -0.020053181797266006f;
      _55 = -0.005771636962890625f;
      _56 = -0.002234415616840124f;
      _57 = 1.0045864582061768f;
      _58 = -0.002352118492126465f;
      _59 = -0.005013350863009691f;
      _60 = -0.025290070101618767f;
      _61 = 1.0303035974502563f;
    }
  } else {
    _53 = 1.3792141675949097f;
    _54 = -0.30886411666870117f;
    _55 = -0.0703500509262085f;
    _56 = -0.06933490186929703f;
    _57 = 1.08229660987854f;
    _58 = -0.012961871922016144f;
    _59 = -0.0021590073592960835f;
    _60 = -0.0454593189060688f;
    _61 = 1.0476183891296387f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _72 = (pow(_30, 0.012683313339948654f));
    float _73 = (pow(_31, 0.012683313339948654f));
    float _74 = (pow(_33, 0.012683313339948654f));
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _119 = ((exp2((_30 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _120 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _121 = ((exp2((_33 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _136 = mad((WorkingColorSpace_ToAP1[0].z), _121, mad((WorkingColorSpace_ToAP1[0].y), _120, ((WorkingColorSpace_ToAP1[0].x) * _119)));
  float _139 = mad((WorkingColorSpace_ToAP1[1].z), _121, mad((WorkingColorSpace_ToAP1[1].y), _120, ((WorkingColorSpace_ToAP1[1].x) * _119)));
  float _142 = mad((WorkingColorSpace_ToAP1[2].z), _121, mad((WorkingColorSpace_ToAP1[2].y), _120, ((WorkingColorSpace_ToAP1[2].x) * _119)));
  float _143 = dot(float3(_136, _139, _142), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_136, _139, _142));

  float _147 = (_136 / _143) + -1.0f;
  float _148 = (_139 / _143) + -1.0f;
  float _149 = (_142 / _143) + -1.0f;
  float _161 = (1.0f - exp2(((_143 * _143) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_147, _148, _149), float3(_147, _148, _149)) * -4.0f));
  float _177 = ((mad(-0.06368321925401688f, _142, mad(-0.3292922377586365f, _139, (_136 * 1.3704125881195068f))) - _136) * _161) + _136;
  float _178 = ((mad(-0.010861365124583244f, _142, mad(1.0970927476882935f, _139, (_136 * -0.08343357592821121f))) - _139) * _161) + _139;
  float _179 = ((mad(1.2036951780319214f, _142, mad(-0.09862580895423889f, _139, (_136 * -0.02579331398010254f))) - _142) * _161) + _142;
  float _180 = dot(float3(_177, _178, _179), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _194 = ColorOffset.w + ColorOffsetShadows.w;
  float _208 = ColorGain.w * ColorGainShadows.w;
  float _222 = ColorGamma.w * ColorGammaShadows.w;
  float _236 = ColorContrast.w * ColorContrastShadows.w;
  float _250 = ColorSaturation.w * ColorSaturationShadows.w;
  float _254 = _177 - _180;
  float _255 = _178 - _180;
  float _256 = _179 - _180;
  float _313 = saturate(_180 / ColorCorrectionShadowsMax);
  float _317 = (_313 * _313) * (3.0f - (_313 * 2.0f));
  float _318 = 1.0f - _317;
  float _327 = ColorOffset.w + ColorOffsetHighlights.w;
  float _336 = ColorGain.w * ColorGainHighlights.w;
  float _345 = ColorGamma.w * ColorGammaHighlights.w;
  float _354 = ColorContrast.w * ColorContrastHighlights.w;
  float _363 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _426 = saturate((_180 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _430 = (_426 * _426) * (3.0f - (_426 * 2.0f));
  float _439 = ColorOffset.w + ColorOffsetMidtones.w;
  float _448 = ColorGain.w * ColorGainMidtones.w;
  float _457 = ColorGamma.w * ColorGammaMidtones.w;
  float _466 = ColorContrast.w * ColorContrastMidtones.w;
  float _475 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _533 = _317 - _430;
  float _544 = ((_430 * (((ColorOffset.x + ColorOffsetHighlights.x) + _327) + (((ColorGain.x * ColorGainHighlights.x) * _336) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _354) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _363) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _345)))))) + (_318 * (((ColorOffset.x + ColorOffsetShadows.x) + _194) + (((ColorGain.x * ColorGainShadows.x) * _208) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _236) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _250) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _222))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _439) + (((ColorGain.x * ColorGainMidtones.x) * _448) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _466) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _475) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _457))))) * _533);
  float _546 = ((_430 * (((ColorOffset.y + ColorOffsetHighlights.y) + _327) + (((ColorGain.y * ColorGainHighlights.y) * _336) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _354) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _363) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _345)))))) + (_318 * (((ColorOffset.y + ColorOffsetShadows.y) + _194) + (((ColorGain.y * ColorGainShadows.y) * _208) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _236) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _250) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _222))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _439) + (((ColorGain.y * ColorGainMidtones.y) * _448) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _466) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _475) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _457))))) * _533);
  float _548 = ((_430 * (((ColorOffset.z + ColorOffsetHighlights.z) + _327) + (((ColorGain.z * ColorGainHighlights.z) * _336) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _354) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _363) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _345)))))) + (_318 * (((ColorOffset.z + ColorOffsetShadows.z) + _194) + (((ColorGain.z * ColorGainShadows.z) * _208) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _236) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _250) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _222))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _439) + (((ColorGain.z * ColorGainMidtones.z) * _448) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _466) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _475) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _457))))) * _533);

  SetUntonemappedAP1(float3(_544, _546, _548));

  float _584 = ((mad(0.061360642313957214f, _548, mad(-4.540197551250458e-09f, _546, (_544 * 0.9386394023895264f))) - _544) * BlueCorrection) + _544;
  float _585 = ((mad(0.169205904006958f, _548, mad(0.8307942152023315f, _546, (_544 * 6.775371730327606e-08f))) - _546) * BlueCorrection) + _546;
  float _586 = (mad(-2.3283064365386963e-10f, _546, (_544 * -9.313225746154785e-10f)) * BlueCorrection) + _548;
  float _589 = mad(0.16386905312538147f, _586, mad(0.14067868888378143f, _585, (_584 * 0.6954522132873535f)));
  float _592 = mad(0.0955343246459961f, _586, mad(0.8596711158752441f, _585, (_584 * 0.044794581830501556f)));
  float _595 = mad(1.0015007257461548f, _586, mad(0.004025210160762072f, _585, (_584 * -0.005525882821530104f)));
  float _599 = max(max(_589, _592), _595);
  float _604 = (max(_599, 1.000000013351432e-10f) - max(min(min(_589, _592), _595), 1.000000013351432e-10f)) / max(_599, 0.009999999776482582f);
  float _617 = ((_592 + _589) + _595) + (sqrt((((_595 - _592) * _595) + ((_592 - _589) * _592)) + ((_589 - _595) * _589)) * 1.75f);
  float _618 = _617 * 0.3333333432674408f;
  float _619 = _604 + -0.4000000059604645f;
  float _620 = _619 * 5.0f;
  float _624 = max((1.0f - abs(_619 * 2.5f)), 0.0f);
  float _635 = ((float(((int)(uint)((bool)(_620 > 0.0f))) - ((int)(uint)((bool)(_620 < 0.0f)))) * (1.0f - (_624 * _624))) + 1.0f) * 0.02500000037252903f;
  if (!(_618 <= 0.0533333346247673f)) {
    if (!(_618 >= 0.1599999964237213f)) {
      _644 = (((0.23999999463558197f / _617) + -0.5f) * _635);
    } else {
      _644 = 0.0f;
    }
  } else {
    _644 = _635;
  }
  float _645 = _644 + 1.0f;
  float _646 = _645 * _589;
  float _647 = _645 * _592;
  float _648 = _645 * _595;
  if (!((bool)(_646 == _647) && (bool)(_647 == _648))) {
    float _655 = ((_646 * 2.0f) - _647) - _648;
    float _658 = ((_592 - _595) * 1.7320507764816284f) * _645;
    float _660 = atan(_658 / _655);
    bool _663 = (_655 < 0.0f);
    bool _664 = (_655 == 0.0f);
    bool _665 = (_658 >= 0.0f);
    bool _666 = (_658 < 0.0f);
    _677 = select((_665 && _664), 90.0f, select((_666 && _664), -90.0f, (select((_666 && _663), (_660 + -3.1415927410125732f), select((_665 && _663), (_660 + 3.1415927410125732f), _660)) * 57.2957763671875f)));
  } else {
    _677 = 0.0f;
  }
  float _682 = min(max(select((_677 < 0.0f), (_677 + 360.0f), _677), 0.0f), 360.0f);
  if (_682 < -180.0f) {
    _691 = (_682 + 360.0f);
  } else {
    if (_682 > 180.0f) {
      _691 = (_682 + -360.0f);
    } else {
      _691 = _682;
    }
  }
  float _695 = saturate(1.0f - abs(_691 * 0.014814814552664757f));
  float _699 = (_695 * _695) * (3.0f - (_695 * 2.0f));
  float _705 = ((_699 * _699) * ((_604 * 0.18000000715255737f) * (0.029999999329447746f - _646))) + _646;
  float _715 = max(0.0f, mad(-0.21492856740951538f, _648, mad(-0.2365107536315918f, _647, (_705 * 1.4514392614364624f))));
  float _716 = max(0.0f, mad(-0.09967592358589172f, _648, mad(1.17622971534729f, _647, (_705 * -0.07655377686023712f))));
  float _717 = max(0.0f, mad(0.9977163076400757f, _648, mad(-0.006032449658960104f, _647, (_705 * 0.008316148072481155f))));
  float _718 = dot(float3(_715, _716, _717), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _733 = (FilmBlackClip + 1.0f) - FilmToe;
  float _735 = FilmWhiteClip + 1.0f;
  float _737 = _735 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _755 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _746 = (FilmBlackClip + 0.18000000715255737f) / _733;
    _755 = (-0.7447274923324585f - ((log2(_746 / (2.0f - _746)) * 0.3465735912322998f) * (_733 / FilmSlope)));
  }
  float _758 = ((1.0f - FilmToe) / FilmSlope) - _755;
  float _760 = (FilmShoulder / FilmSlope) - _758;
  float _764 = log2(lerp(_718, _715, 0.9599999785423279f)) * 0.3010300099849701f;
  float _765 = log2(lerp(_718, _716, 0.9599999785423279f)) * 0.3010300099849701f;
  float _766 = log2(lerp(_718, _717, 0.9599999785423279f)) * 0.3010300099849701f;
  float _770 = FilmSlope * (_764 + _758);
  float _771 = FilmSlope * (_765 + _758);
  float _772 = FilmSlope * (_766 + _758);
  float _773 = _733 * 2.0f;
  float _775 = (FilmSlope * -2.0f) / _733;
  float _776 = _764 - _755;
  float _777 = _765 - _755;
  float _778 = _766 - _755;
  float _797 = _737 * 2.0f;
  float _799 = (FilmSlope * 2.0f) / _737;
  float _824 = select((_764 < _755), ((_773 / (exp2((_776 * 1.4426950216293335f) * _775) + 1.0f)) - FilmBlackClip), _770);
  float _825 = select((_765 < _755), ((_773 / (exp2((_777 * 1.4426950216293335f) * _775) + 1.0f)) - FilmBlackClip), _771);
  float _826 = select((_766 < _755), ((_773 / (exp2((_778 * 1.4426950216293335f) * _775) + 1.0f)) - FilmBlackClip), _772);
  float _833 = _760 - _755;
  float _837 = saturate(_776 / _833);
  float _838 = saturate(_777 / _833);
  float _839 = saturate(_778 / _833);
  bool _840 = (_760 < _755);
  float _844 = select(_840, (1.0f - _837), _837);
  float _845 = select(_840, (1.0f - _838), _838);
  float _846 = select(_840, (1.0f - _839), _839);
  float _865 = (((_844 * _844) * (select((_764 > _760), (_735 - (_797 / (exp2(((_764 - _760) * 1.4426950216293335f) * _799) + 1.0f))), _770) - _824)) * (3.0f - (_844 * 2.0f))) + _824;
  float _866 = (((_845 * _845) * (select((_765 > _760), (_735 - (_797 / (exp2(((_765 - _760) * 1.4426950216293335f) * _799) + 1.0f))), _771) - _825)) * (3.0f - (_845 * 2.0f))) + _825;
  float _867 = (((_846 * _846) * (select((_766 > _760), (_735 - (_797 / (exp2(((_766 - _760) * 1.4426950216293335f) * _799) + 1.0f))), _772) - _826)) * (3.0f - (_846 * 2.0f))) + _826;
  float _868 = dot(float3(_865, _866, _867), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _888 = (ToneCurveAmount * (max(0.0f, (lerp(_868, _865, 0.9300000071525574f))) - _584)) + _584;
  float _889 = (ToneCurveAmount * (max(0.0f, (lerp(_868, _866, 0.9300000071525574f))) - _585)) + _585;
  float _890 = (ToneCurveAmount * (max(0.0f, (lerp(_868, _867, 0.9300000071525574f))) - _586)) + _586;
  float _906 = ((mad(-0.06537103652954102f, _890, mad(1.451815478503704e-06f, _889, (_888 * 1.065374732017517f))) - _888) * BlueCorrection) + _888;
  float _907 = ((mad(-0.20366770029067993f, _890, mad(1.2036634683609009f, _889, (_888 * -2.57161445915699e-07f))) - _889) * BlueCorrection) + _889;
  float _908 = ((mad(0.9999996423721313f, _890, mad(2.0954757928848267e-08f, _889, (_888 * 1.862645149230957e-08f))) - _890) * BlueCorrection) + _890;

  SetTonemappedAP1(_906, _907, _908);

  float _918 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _908, mad((WorkingColorSpace_FromAP1[0].y), _907, ((WorkingColorSpace_FromAP1[0].x) * _906))));
  float _919 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _908, mad((WorkingColorSpace_FromAP1[1].y), _907, ((WorkingColorSpace_FromAP1[1].x) * _906))));
  float _920 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _908, mad((WorkingColorSpace_FromAP1[2].y), _907, ((WorkingColorSpace_FromAP1[2].x) * _906))));
  float _946 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _918)) * _918) + MappingPolynomial.z);
  float _947 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _919)) * _919) + MappingPolynomial.z);
  float _948 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _920)) * _920) + MappingPolynomial.z);
  float _955 = ((OverlayColor.x - _946) * OverlayColor.w) + _946;
  float _956 = ((OverlayColor.y - _947) * OverlayColor.w) + _947;
  float _957 = ((OverlayColor.z - _948) * OverlayColor.w) + _948;
  float _958 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _548, mad((WorkingColorSpace_FromAP1[0].y), _546, (_544 * (WorkingColorSpace_FromAP1[0].x))));
  float _959 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _548, mad((WorkingColorSpace_FromAP1[1].y), _546, ((WorkingColorSpace_FromAP1[1].x) * _544)));
  float _960 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _548, mad((WorkingColorSpace_FromAP1[2].y), _546, ((WorkingColorSpace_FromAP1[2].x) * _544)));
  float _967 = ((OverlayColor.x - _958) * OverlayColor.w) + _958;
  float _968 = ((OverlayColor.y - _959) * OverlayColor.w) + _959;
  float _969 = ((OverlayColor.z - _960) * OverlayColor.w) + _960;
  float _981 = exp2(log2(max(0.0f, _955)) * InverseGamma.y);
  float _982 = exp2(log2(max(0.0f, _956)) * InverseGamma.y);
  float _983 = exp2(log2(max(0.0f, _957)) * InverseGamma.y);

  if (true) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_981, _982, _983), OutputDevice);
    return;
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1006 = mad((WorkingColorSpace_ToAP1[0].z), _983, mad((WorkingColorSpace_ToAP1[0].y), _982, ((WorkingColorSpace_ToAP1[0].x) * _981)));
        float _1009 = mad((WorkingColorSpace_ToAP1[1].z), _983, mad((WorkingColorSpace_ToAP1[1].y), _982, ((WorkingColorSpace_ToAP1[1].x) * _981)));
        float _1012 = mad((WorkingColorSpace_ToAP1[2].z), _983, mad((WorkingColorSpace_ToAP1[2].y), _982, ((WorkingColorSpace_ToAP1[2].x) * _981)));
        _1023 = mad(_55, _1012, mad(_54, _1009, (_1006 * _53)));
        _1024 = mad(_58, _1012, mad(_57, _1009, (_1006 * _56)));
        _1025 = mad(_61, _1012, mad(_60, _1009, (_1006 * _59)));
      } else {
        _1023 = _981;
        _1024 = _982;
        _1025 = _983;
      }
      do {
        if (_1023 < 0.0031306699384003878f) {
          _1036 = (_1023 * 12.920000076293945f);
        } else {
          _1036 = (((pow(_1023, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1024 < 0.0031306699384003878f) {
            _1047 = (_1024 * 12.920000076293945f);
          } else {
            _1047 = (((pow(_1024, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1025 < 0.0031306699384003878f) {
            _2403 = _1036;
            _2404 = _1047;
            _2405 = (_1025 * 12.920000076293945f);
          } else {
            _2403 = _1036;
            _2404 = _1047;
            _2405 = (((pow(_1025, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1074 = mad((WorkingColorSpace_ToAP1[0].z), _983, mad((WorkingColorSpace_ToAP1[0].y), _982, ((WorkingColorSpace_ToAP1[0].x) * _981)));
      float _1077 = mad((WorkingColorSpace_ToAP1[1].z), _983, mad((WorkingColorSpace_ToAP1[1].y), _982, ((WorkingColorSpace_ToAP1[1].x) * _981)));
      float _1080 = mad((WorkingColorSpace_ToAP1[2].z), _983, mad((WorkingColorSpace_ToAP1[2].y), _982, ((WorkingColorSpace_ToAP1[2].x) * _981)));
      float _1090 = max(6.103519990574569e-05f, mad(_55, _1080, mad(_54, _1077, (_1074 * _53))));
      float _1091 = max(6.103519990574569e-05f, mad(_58, _1080, mad(_57, _1077, (_1074 * _56))));
      float _1092 = max(6.103519990574569e-05f, mad(_61, _1080, mad(_60, _1077, (_1074 * _59))));
      _2403 = min((_1090 * 4.5f), ((exp2(log2(max(_1090, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2404 = min((_1091 * 4.5f), ((exp2(log2(max(_1091, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2405 = min((_1092 * 4.5f), ((exp2(log2(max(_1092, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
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
        float _1167 = ACESSceneColorMultiplier * _967;
        float _1168 = ACESSceneColorMultiplier * _968;
        float _1169 = ACESSceneColorMultiplier * _969;
        float _1172 = mad((WorkingColorSpace_ToAP0[0].z), _1169, mad((WorkingColorSpace_ToAP0[0].y), _1168, ((WorkingColorSpace_ToAP0[0].x) * _1167)));
        float _1175 = mad((WorkingColorSpace_ToAP0[1].z), _1169, mad((WorkingColorSpace_ToAP0[1].y), _1168, ((WorkingColorSpace_ToAP0[1].x) * _1167)));
        float _1178 = mad((WorkingColorSpace_ToAP0[2].z), _1169, mad((WorkingColorSpace_ToAP0[2].y), _1168, ((WorkingColorSpace_ToAP0[2].x) * _1167)));
        float _1182 = max(max(_1172, _1175), _1178);
        float _1187 = (max(_1182, 1.000000013351432e-10f) - max(min(min(_1172, _1175), _1178), 1.000000013351432e-10f)) / max(_1182, 0.009999999776482582f);
        float _1200 = ((_1175 + _1172) + _1178) + (sqrt((((_1178 - _1175) * _1178) + ((_1175 - _1172) * _1175)) + ((_1172 - _1178) * _1172)) * 1.75f);
        float _1201 = _1200 * 0.3333333432674408f;
        float _1202 = _1187 + -0.4000000059604645f;
        float _1203 = _1202 * 5.0f;
        float _1207 = max((1.0f - abs(_1202 * 2.5f)), 0.0f);
        float _1218 = ((float(((int)(uint)((bool)(_1203 > 0.0f))) - ((int)(uint)((bool)(_1203 < 0.0f)))) * (1.0f - (_1207 * _1207))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1201 <= 0.0533333346247673f)) {
            if (!(_1201 >= 0.1599999964237213f)) {
              _1227 = (((0.23999999463558197f / _1200) + -0.5f) * _1218);
            } else {
              _1227 = 0.0f;
            }
          } else {
            _1227 = _1218;
          }
          float _1228 = _1227 + 1.0f;
          float _1229 = _1228 * _1172;
          float _1230 = _1228 * _1175;
          float _1231 = _1228 * _1178;
          do {
            if (!((bool)(_1229 == _1230) && (bool)(_1230 == _1231))) {
              float _1238 = ((_1229 * 2.0f) - _1230) - _1231;
              float _1241 = ((_1175 - _1178) * 1.7320507764816284f) * _1228;
              float _1243 = atan(_1241 / _1238);
              bool _1246 = (_1238 < 0.0f);
              bool _1247 = (_1238 == 0.0f);
              bool _1248 = (_1241 >= 0.0f);
              bool _1249 = (_1241 < 0.0f);
              _1260 = select((_1248 && _1247), 90.0f, select((_1249 && _1247), -90.0f, (select((_1249 && _1246), (_1243 + -3.1415927410125732f), select((_1248 && _1246), (_1243 + 3.1415927410125732f), _1243)) * 57.2957763671875f)));
            } else {
              _1260 = 0.0f;
            }
            float _1265 = min(max(select((_1260 < 0.0f), (_1260 + 360.0f), _1260), 0.0f), 360.0f);
            do {
              if (_1265 < -180.0f) {
                _1274 = (_1265 + 360.0f);
              } else {
                if (_1265 > 180.0f) {
                  _1274 = (_1265 + -360.0f);
                } else {
                  _1274 = _1265;
                }
              }
              do {
                if ((bool)(_1274 > -67.5f) && (bool)(_1274 < 67.5f)) {
                  float _1280 = (_1274 + 67.5f) * 0.029629629105329514f;
                  int _1281 = int(_1280);
                  float _1283 = _1280 - float(_1281);
                  float _1284 = _1283 * _1283;
                  float _1285 = _1284 * _1283;
                  if (_1281 == 3) {
                    _1313 = (((0.1666666716337204f - (_1283 * 0.5f)) + (_1284 * 0.5f)) - (_1285 * 0.1666666716337204f));
                  } else {
                    if (_1281 == 2) {
                      _1313 = ((0.6666666865348816f - _1284) + (_1285 * 0.5f));
                    } else {
                      if (_1281 == 1) {
                        _1313 = (((_1285 * -0.5f) + 0.1666666716337204f) + ((_1284 + _1283) * 0.5f));
                      } else {
                        _1313 = select((_1281 == 0), (_1285 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1313 = 0.0f;
                }
                float _1322 = min(max(((((_1187 * 0.27000001072883606f) * (0.029999999329447746f - _1229)) * _1313) + _1229), 0.0f), 65535.0f);
                float _1323 = min(max(_1230, 0.0f), 65535.0f);
                float _1324 = min(max(_1231, 0.0f), 65535.0f);
                float _1337 = min(max(mad(-0.21492856740951538f, _1324, mad(-0.2365107536315918f, _1323, (_1322 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1338 = min(max(mad(-0.09967592358589172f, _1324, mad(1.17622971534729f, _1323, (_1322 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1339 = min(max(mad(0.9977163076400757f, _1324, mad(-0.006032449658960104f, _1323, (_1322 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1340 = dot(float3(_1337, _1338, _1339), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1351 = log2(max((lerp(_1340, _1337, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1352 = _1351 * 0.3010300099849701f;
                float _1353 = log2(ACESMinMaxData.x);
                float _1354 = _1353 * 0.3010300099849701f;
                do {
                  if (!(!(_1352 <= _1354))) {
                    _1423 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1361 = log2(ACESMidData.x);
                    float _1362 = _1361 * 0.3010300099849701f;
                    if ((bool)(_1352 > _1354) && (bool)(_1352 < _1362)) {
                      float _1370 = ((_1351 - _1353) * 0.9030900001525879f) / ((_1361 - _1353) * 0.3010300099849701f);
                      int _1371 = int(_1370);
                      float _1373 = _1370 - float(_1371);
                      float _1375 = _11[_1371];
                      float _1378 = _11[(_1371 + 1)];
                      float _1383 = _1375 * 0.5f;
                      _1423 = dot(float3((_1373 * _1373), _1373, 1.0f), float3(mad((_11[(_1371 + 2)]), 0.5f, mad(_1378, -1.0f, _1383)), (_1378 - _1375), mad(_1378, 0.5f, _1383)));
                    } else {
                      do {
                        if (!(!(_1352 >= _1362))) {
                          float _1392 = log2(ACESMinMaxData.z);
                          if (_1352 < (_1392 * 0.3010300099849701f)) {
                            float _1400 = ((_1351 - _1361) * 0.9030900001525879f) / ((_1392 - _1361) * 0.3010300099849701f);
                            int _1401 = int(_1400);
                            float _1403 = _1400 - float(_1401);
                            float _1405 = _12[_1401];
                            float _1408 = _12[(_1401 + 1)];
                            float _1413 = _1405 * 0.5f;
                            _1423 = dot(float3((_1403 * _1403), _1403, 1.0f), float3(mad((_12[(_1401 + 2)]), 0.5f, mad(_1408, -1.0f, _1413)), (_1408 - _1405), mad(_1408, 0.5f, _1413)));
                            break;
                          }
                        }
                        _1423 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1427 = log2(max((lerp(_1340, _1338, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1428 = _1427 * 0.3010300099849701f;
                  do {
                    if (!(!(_1428 <= _1354))) {
                      _1497 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1435 = log2(ACESMidData.x);
                      float _1436 = _1435 * 0.3010300099849701f;
                      if ((bool)(_1428 > _1354) && (bool)(_1428 < _1436)) {
                        float _1444 = ((_1427 - _1353) * 0.9030900001525879f) / ((_1435 - _1353) * 0.3010300099849701f);
                        int _1445 = int(_1444);
                        float _1447 = _1444 - float(_1445);
                        float _1449 = _11[_1445];
                        float _1452 = _11[(_1445 + 1)];
                        float _1457 = _1449 * 0.5f;
                        _1497 = dot(float3((_1447 * _1447), _1447, 1.0f), float3(mad((_11[(_1445 + 2)]), 0.5f, mad(_1452, -1.0f, _1457)), (_1452 - _1449), mad(_1452, 0.5f, _1457)));
                      } else {
                        do {
                          if (!(!(_1428 >= _1436))) {
                            float _1466 = log2(ACESMinMaxData.z);
                            if (_1428 < (_1466 * 0.3010300099849701f)) {
                              float _1474 = ((_1427 - _1435) * 0.9030900001525879f) / ((_1466 - _1435) * 0.3010300099849701f);
                              int _1475 = int(_1474);
                              float _1477 = _1474 - float(_1475);
                              float _1479 = _12[_1475];
                              float _1482 = _12[(_1475 + 1)];
                              float _1487 = _1479 * 0.5f;
                              _1497 = dot(float3((_1477 * _1477), _1477, 1.0f), float3(mad((_12[(_1475 + 2)]), 0.5f, mad(_1482, -1.0f, _1487)), (_1482 - _1479), mad(_1482, 0.5f, _1487)));
                              break;
                            }
                          }
                          _1497 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1501 = log2(max((lerp(_1340, _1339, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1502 = _1501 * 0.3010300099849701f;
                    do {
                      if (!(!(_1502 <= _1354))) {
                        _1571 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1509 = log2(ACESMidData.x);
                        float _1510 = _1509 * 0.3010300099849701f;
                        if ((bool)(_1502 > _1354) && (bool)(_1502 < _1510)) {
                          float _1518 = ((_1501 - _1353) * 0.9030900001525879f) / ((_1509 - _1353) * 0.3010300099849701f);
                          int _1519 = int(_1518);
                          float _1521 = _1518 - float(_1519);
                          float _1523 = _11[_1519];
                          float _1526 = _11[(_1519 + 1)];
                          float _1531 = _1523 * 0.5f;
                          _1571 = dot(float3((_1521 * _1521), _1521, 1.0f), float3(mad((_11[(_1519 + 2)]), 0.5f, mad(_1526, -1.0f, _1531)), (_1526 - _1523), mad(_1526, 0.5f, _1531)));
                        } else {
                          do {
                            if (!(!(_1502 >= _1510))) {
                              float _1540 = log2(ACESMinMaxData.z);
                              if (_1502 < (_1540 * 0.3010300099849701f)) {
                                float _1548 = ((_1501 - _1509) * 0.9030900001525879f) / ((_1540 - _1509) * 0.3010300099849701f);
                                int _1549 = int(_1548);
                                float _1551 = _1548 - float(_1549);
                                float _1553 = _12[_1549];
                                float _1556 = _12[(_1549 + 1)];
                                float _1561 = _1553 * 0.5f;
                                _1571 = dot(float3((_1551 * _1551), _1551, 1.0f), float3(mad((_12[(_1549 + 2)]), 0.5f, mad(_1556, -1.0f, _1561)), (_1556 - _1553), mad(_1556, 0.5f, _1561)));
                                break;
                              }
                            }
                            _1571 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1575 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1576 = (exp2(_1423 * 3.321928024291992f) - ACESMinMaxData.y) / _1575;
                      float _1578 = (exp2(_1497 * 3.321928024291992f) - ACESMinMaxData.y) / _1575;
                      float _1580 = (exp2(_1571 * 3.321928024291992f) - ACESMinMaxData.y) / _1575;
                      float _1583 = mad(0.15618768334388733f, _1580, mad(0.13400420546531677f, _1578, (_1576 * 0.6624541878700256f)));
                      float _1586 = mad(0.053689517080783844f, _1580, mad(0.6740817427635193f, _1578, (_1576 * 0.2722287178039551f)));
                      float _1589 = mad(1.0103391408920288f, _1580, mad(0.00406073359772563f, _1578, (_1576 * -0.005574649665504694f)));
                      float _1602 = min(max(mad(-0.23642469942569733f, _1589, mad(-0.32480329275131226f, _1586, (_1583 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1603 = min(max(mad(0.016756348311901093f, _1589, mad(1.6153316497802734f, _1586, (_1583 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1604 = min(max(mad(0.9883948564529419f, _1589, mad(-0.008284442126750946f, _1586, (_1583 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1607 = mad(0.15618768334388733f, _1604, mad(0.13400420546531677f, _1603, (_1602 * 0.6624541878700256f)));
                      float _1610 = mad(0.053689517080783844f, _1604, mad(0.6740817427635193f, _1603, (_1602 * 0.2722287178039551f)));
                      float _1613 = mad(1.0103391408920288f, _1604, mad(0.00406073359772563f, _1603, (_1602 * -0.005574649665504694f)));
                      float _1635 = min(max((min(max(mad(-0.23642469942569733f, _1613, mad(-0.32480329275131226f, _1610, (_1607 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1636 = min(max((min(max(mad(0.016756348311901093f, _1613, mad(1.6153316497802734f, _1610, (_1607 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1637 = min(max((min(max(mad(0.9883948564529419f, _1613, mad(-0.008284442126750946f, _1610, (_1607 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(OutputDevice) == 5)) {
                          _1650 = mad(_55, _1637, mad(_54, _1636, (_1635 * _53)));
                          _1651 = mad(_58, _1637, mad(_57, _1636, (_1635 * _56)));
                          _1652 = mad(_61, _1637, mad(_60, _1636, (_1635 * _59)));
                        } else {
                          _1650 = _1635;
                          _1651 = _1636;
                          _1652 = _1637;
                        }
                        float _1662 = exp2(log2(_1650 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1663 = exp2(log2(_1651 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1664 = exp2(log2(_1652 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2403 = exp2(log2((1.0f / ((_1662 * 18.6875f) + 1.0f)) * ((_1662 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2404 = exp2(log2((1.0f / ((_1663 * 18.6875f) + 1.0f)) * ((_1663 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2405 = exp2(log2((1.0f / ((_1664 * 18.6875f) + 1.0f)) * ((_1664 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          _9[0] = ACESCoefsLow_0.x;
          _9[1] = ACESCoefsLow_0.y;
          _9[2] = ACESCoefsLow_0.z;
          _9[3] = ACESCoefsLow_0.w;
          _9[4] = ACESCoefsLow_4;
          _9[5] = ACESCoefsLow_4;
          _10[0] = ACESCoefsHigh_0.x;
          _10[1] = ACESCoefsHigh_0.y;
          _10[2] = ACESCoefsHigh_0.z;
          _10[3] = ACESCoefsHigh_0.w;
          _10[4] = ACESCoefsHigh_4;
          _10[5] = ACESCoefsHigh_4;
          float _1741 = ACESSceneColorMultiplier * _967;
          float _1742 = ACESSceneColorMultiplier * _968;
          float _1743 = ACESSceneColorMultiplier * _969;
          float _1746 = mad((WorkingColorSpace_ToAP0[0].z), _1743, mad((WorkingColorSpace_ToAP0[0].y), _1742, ((WorkingColorSpace_ToAP0[0].x) * _1741)));
          float _1749 = mad((WorkingColorSpace_ToAP0[1].z), _1743, mad((WorkingColorSpace_ToAP0[1].y), _1742, ((WorkingColorSpace_ToAP0[1].x) * _1741)));
          float _1752 = mad((WorkingColorSpace_ToAP0[2].z), _1743, mad((WorkingColorSpace_ToAP0[2].y), _1742, ((WorkingColorSpace_ToAP0[2].x) * _1741)));
          float _1756 = max(max(_1746, _1749), _1752);
          float _1761 = (max(_1756, 1.000000013351432e-10f) - max(min(min(_1746, _1749), _1752), 1.000000013351432e-10f)) / max(_1756, 0.009999999776482582f);
          float _1774 = ((_1749 + _1746) + _1752) + (sqrt((((_1752 - _1749) * _1752) + ((_1749 - _1746) * _1749)) + ((_1746 - _1752) * _1746)) * 1.75f);
          float _1775 = _1774 * 0.3333333432674408f;
          float _1776 = _1761 + -0.4000000059604645f;
          float _1777 = _1776 * 5.0f;
          float _1781 = max((1.0f - abs(_1776 * 2.5f)), 0.0f);
          float _1792 = ((float(((int)(uint)((bool)(_1777 > 0.0f))) - ((int)(uint)((bool)(_1777 < 0.0f)))) * (1.0f - (_1781 * _1781))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1775 <= 0.0533333346247673f)) {
              if (!(_1775 >= 0.1599999964237213f)) {
                _1801 = (((0.23999999463558197f / _1774) + -0.5f) * _1792);
              } else {
                _1801 = 0.0f;
              }
            } else {
              _1801 = _1792;
            }
            float _1802 = _1801 + 1.0f;
            float _1803 = _1802 * _1746;
            float _1804 = _1802 * _1749;
            float _1805 = _1802 * _1752;
            do {
              if (!((bool)(_1803 == _1804) && (bool)(_1804 == _1805))) {
                float _1812 = ((_1803 * 2.0f) - _1804) - _1805;
                float _1815 = ((_1749 - _1752) * 1.7320507764816284f) * _1802;
                float _1817 = atan(_1815 / _1812);
                bool _1820 = (_1812 < 0.0f);
                bool _1821 = (_1812 == 0.0f);
                bool _1822 = (_1815 >= 0.0f);
                bool _1823 = (_1815 < 0.0f);
                _1834 = select((_1822 && _1821), 90.0f, select((_1823 && _1821), -90.0f, (select((_1823 && _1820), (_1817 + -3.1415927410125732f), select((_1822 && _1820), (_1817 + 3.1415927410125732f), _1817)) * 57.2957763671875f)));
              } else {
                _1834 = 0.0f;
              }
              float _1839 = min(max(select((_1834 < 0.0f), (_1834 + 360.0f), _1834), 0.0f), 360.0f);
              do {
                if (_1839 < -180.0f) {
                  _1848 = (_1839 + 360.0f);
                } else {
                  if (_1839 > 180.0f) {
                    _1848 = (_1839 + -360.0f);
                  } else {
                    _1848 = _1839;
                  }
                }
                do {
                  if ((bool)(_1848 > -67.5f) && (bool)(_1848 < 67.5f)) {
                    float _1854 = (_1848 + 67.5f) * 0.029629629105329514f;
                    int _1855 = int(_1854);
                    float _1857 = _1854 - float(_1855);
                    float _1858 = _1857 * _1857;
                    float _1859 = _1858 * _1857;
                    if (_1855 == 3) {
                      _1887 = (((0.1666666716337204f - (_1857 * 0.5f)) + (_1858 * 0.5f)) - (_1859 * 0.1666666716337204f));
                    } else {
                      if (_1855 == 2) {
                        _1887 = ((0.6666666865348816f - _1858) + (_1859 * 0.5f));
                      } else {
                        if (_1855 == 1) {
                          _1887 = (((_1859 * -0.5f) + 0.1666666716337204f) + ((_1858 + _1857) * 0.5f));
                        } else {
                          _1887 = select((_1855 == 0), (_1859 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1887 = 0.0f;
                  }
                  float _1896 = min(max(((((_1761 * 0.27000001072883606f) * (0.029999999329447746f - _1803)) * _1887) + _1803), 0.0f), 65535.0f);
                  float _1897 = min(max(_1804, 0.0f), 65535.0f);
                  float _1898 = min(max(_1805, 0.0f), 65535.0f);
                  float _1911 = min(max(mad(-0.21492856740951538f, _1898, mad(-0.2365107536315918f, _1897, (_1896 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1912 = min(max(mad(-0.09967592358589172f, _1898, mad(1.17622971534729f, _1897, (_1896 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1913 = min(max(mad(0.9977163076400757f, _1898, mad(-0.006032449658960104f, _1897, (_1896 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1914 = dot(float3(_1911, _1912, _1913), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1925 = log2(max((lerp(_1914, _1911, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1926 = _1925 * 0.3010300099849701f;
                  float _1927 = log2(ACESMinMaxData.x);
                  float _1928 = _1927 * 0.3010300099849701f;
                  do {
                    if (!(!(_1926 <= _1928))) {
                      _1997 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1935 = log2(ACESMidData.x);
                      float _1936 = _1935 * 0.3010300099849701f;
                      if ((bool)(_1926 > _1928) && (bool)(_1926 < _1936)) {
                        float _1944 = ((_1925 - _1927) * 0.9030900001525879f) / ((_1935 - _1927) * 0.3010300099849701f);
                        int _1945 = int(_1944);
                        float _1947 = _1944 - float(_1945);
                        float _1949 = _9[_1945];
                        float _1952 = _9[(_1945 + 1)];
                        float _1957 = _1949 * 0.5f;
                        _1997 = dot(float3((_1947 * _1947), _1947, 1.0f), float3(mad((_9[(_1945 + 2)]), 0.5f, mad(_1952, -1.0f, _1957)), (_1952 - _1949), mad(_1952, 0.5f, _1957)));
                      } else {
                        do {
                          if (!(!(_1926 >= _1936))) {
                            float _1966 = log2(ACESMinMaxData.z);
                            if (_1926 < (_1966 * 0.3010300099849701f)) {
                              float _1974 = ((_1925 - _1935) * 0.9030900001525879f) / ((_1966 - _1935) * 0.3010300099849701f);
                              int _1975 = int(_1974);
                              float _1977 = _1974 - float(_1975);
                              float _1979 = _10[_1975];
                              float _1982 = _10[(_1975 + 1)];
                              float _1987 = _1979 * 0.5f;
                              _1997 = dot(float3((_1977 * _1977), _1977, 1.0f), float3(mad((_10[(_1975 + 2)]), 0.5f, mad(_1982, -1.0f, _1987)), (_1982 - _1979), mad(_1982, 0.5f, _1987)));
                              break;
                            }
                          }
                          _1997 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2001 = log2(max((lerp(_1914, _1912, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2002 = _2001 * 0.3010300099849701f;
                    do {
                      if (!(!(_2002 <= _1928))) {
                        _2071 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2009 = log2(ACESMidData.x);
                        float _2010 = _2009 * 0.3010300099849701f;
                        if ((bool)(_2002 > _1928) && (bool)(_2002 < _2010)) {
                          float _2018 = ((_2001 - _1927) * 0.9030900001525879f) / ((_2009 - _1927) * 0.3010300099849701f);
                          int _2019 = int(_2018);
                          float _2021 = _2018 - float(_2019);
                          float _2023 = _9[_2019];
                          float _2026 = _9[(_2019 + 1)];
                          float _2031 = _2023 * 0.5f;
                          _2071 = dot(float3((_2021 * _2021), _2021, 1.0f), float3(mad((_9[(_2019 + 2)]), 0.5f, mad(_2026, -1.0f, _2031)), (_2026 - _2023), mad(_2026, 0.5f, _2031)));
                        } else {
                          do {
                            if (!(!(_2002 >= _2010))) {
                              float _2040 = log2(ACESMinMaxData.z);
                              if (_2002 < (_2040 * 0.3010300099849701f)) {
                                float _2048 = ((_2001 - _2009) * 0.9030900001525879f) / ((_2040 - _2009) * 0.3010300099849701f);
                                int _2049 = int(_2048);
                                float _2051 = _2048 - float(_2049);
                                float _2053 = _10[_2049];
                                float _2056 = _10[(_2049 + 1)];
                                float _2061 = _2053 * 0.5f;
                                _2071 = dot(float3((_2051 * _2051), _2051, 1.0f), float3(mad((_10[(_2049 + 2)]), 0.5f, mad(_2056, -1.0f, _2061)), (_2056 - _2053), mad(_2056, 0.5f, _2061)));
                                break;
                              }
                            }
                            _2071 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2075 = log2(max((lerp(_1914, _1913, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2076 = _2075 * 0.3010300099849701f;
                      do {
                        if (!(!(_2076 <= _1928))) {
                          _2145 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2083 = log2(ACESMidData.x);
                          float _2084 = _2083 * 0.3010300099849701f;
                          if ((bool)(_2076 > _1928) && (bool)(_2076 < _2084)) {
                            float _2092 = ((_2075 - _1927) * 0.9030900001525879f) / ((_2083 - _1927) * 0.3010300099849701f);
                            int _2093 = int(_2092);
                            float _2095 = _2092 - float(_2093);
                            float _2097 = _9[_2093];
                            float _2100 = _9[(_2093 + 1)];
                            float _2105 = _2097 * 0.5f;
                            _2145 = dot(float3((_2095 * _2095), _2095, 1.0f), float3(mad((_9[(_2093 + 2)]), 0.5f, mad(_2100, -1.0f, _2105)), (_2100 - _2097), mad(_2100, 0.5f, _2105)));
                          } else {
                            do {
                              if (!(!(_2076 >= _2084))) {
                                float _2114 = log2(ACESMinMaxData.z);
                                if (_2076 < (_2114 * 0.3010300099849701f)) {
                                  float _2122 = ((_2075 - _2083) * 0.9030900001525879f) / ((_2114 - _2083) * 0.3010300099849701f);
                                  int _2123 = int(_2122);
                                  float _2125 = _2122 - float(_2123);
                                  float _2127 = _10[_2123];
                                  float _2130 = _10[(_2123 + 1)];
                                  float _2135 = _2127 * 0.5f;
                                  _2145 = dot(float3((_2125 * _2125), _2125, 1.0f), float3(mad((_10[(_2123 + 2)]), 0.5f, mad(_2130, -1.0f, _2135)), (_2130 - _2127), mad(_2130, 0.5f, _2135)));
                                  break;
                                }
                              }
                              _2145 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2149 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2150 = (exp2(_1997 * 3.321928024291992f) - ACESMinMaxData.y) / _2149;
                        float _2152 = (exp2(_2071 * 3.321928024291992f) - ACESMinMaxData.y) / _2149;
                        float _2154 = (exp2(_2145 * 3.321928024291992f) - ACESMinMaxData.y) / _2149;
                        float _2157 = mad(0.15618768334388733f, _2154, mad(0.13400420546531677f, _2152, (_2150 * 0.6624541878700256f)));
                        float _2160 = mad(0.053689517080783844f, _2154, mad(0.6740817427635193f, _2152, (_2150 * 0.2722287178039551f)));
                        float _2163 = mad(1.0103391408920288f, _2154, mad(0.00406073359772563f, _2152, (_2150 * -0.005574649665504694f)));
                        float _2176 = min(max(mad(-0.23642469942569733f, _2163, mad(-0.32480329275131226f, _2160, (_2157 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2177 = min(max(mad(0.016756348311901093f, _2163, mad(1.6153316497802734f, _2160, (_2157 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2178 = min(max(mad(0.9883948564529419f, _2163, mad(-0.008284442126750946f, _2160, (_2157 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2181 = mad(0.15618768334388733f, _2178, mad(0.13400420546531677f, _2177, (_2176 * 0.6624541878700256f)));
                        float _2184 = mad(0.053689517080783844f, _2178, mad(0.6740817427635193f, _2177, (_2176 * 0.2722287178039551f)));
                        float _2187 = mad(1.0103391408920288f, _2178, mad(0.00406073359772563f, _2177, (_2176 * -0.005574649665504694f)));
                        float _2209 = min(max((min(max(mad(-0.23642469942569733f, _2187, mad(-0.32480329275131226f, _2184, (_2181 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2210 = min(max((min(max(mad(0.016756348311901093f, _2187, mad(1.6153316497802734f, _2184, (_2181 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2211 = min(max((min(max(mad(0.9883948564529419f, _2187, mad(-0.008284442126750946f, _2184, (_2181 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 6)) {
                            _2224 = mad(_55, _2211, mad(_54, _2210, (_2209 * _53)));
                            _2225 = mad(_58, _2211, mad(_57, _2210, (_2209 * _56)));
                            _2226 = mad(_61, _2211, mad(_60, _2210, (_2209 * _59)));
                          } else {
                            _2224 = _2209;
                            _2225 = _2210;
                            _2226 = _2211;
                          }
                          float _2236 = exp2(log2(_2224 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2237 = exp2(log2(_2225 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2238 = exp2(log2(_2226 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2403 = exp2(log2((1.0f / ((_2236 * 18.6875f) + 1.0f)) * ((_2236 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2404 = exp2(log2((1.0f / ((_2237 * 18.6875f) + 1.0f)) * ((_2237 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2405 = exp2(log2((1.0f / ((_2238 * 18.6875f) + 1.0f)) * ((_2238 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2283 = mad((WorkingColorSpace_ToAP1[0].z), _969, mad((WorkingColorSpace_ToAP1[0].y), _968, ((WorkingColorSpace_ToAP1[0].x) * _967)));
            float _2286 = mad((WorkingColorSpace_ToAP1[1].z), _969, mad((WorkingColorSpace_ToAP1[1].y), _968, ((WorkingColorSpace_ToAP1[1].x) * _967)));
            float _2289 = mad((WorkingColorSpace_ToAP1[2].z), _969, mad((WorkingColorSpace_ToAP1[2].y), _968, ((WorkingColorSpace_ToAP1[2].x) * _967)));
            float _2308 = exp2(log2(mad(_55, _2289, mad(_54, _2286, (_2283 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2309 = exp2(log2(mad(_58, _2289, mad(_57, _2286, (_2283 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2310 = exp2(log2(mad(_61, _2289, mad(_60, _2286, (_2283 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2403 = exp2(log2((1.0f / ((_2308 * 18.6875f) + 1.0f)) * ((_2308 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2404 = exp2(log2((1.0f / ((_2309 * 18.6875f) + 1.0f)) * ((_2309 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2405 = exp2(log2((1.0f / ((_2310 * 18.6875f) + 1.0f)) * ((_2310 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2357 = mad((WorkingColorSpace_ToAP1[0].z), _957, mad((WorkingColorSpace_ToAP1[0].y), _956, ((WorkingColorSpace_ToAP1[0].x) * _955)));
                float _2360 = mad((WorkingColorSpace_ToAP1[1].z), _957, mad((WorkingColorSpace_ToAP1[1].y), _956, ((WorkingColorSpace_ToAP1[1].x) * _955)));
                float _2363 = mad((WorkingColorSpace_ToAP1[2].z), _957, mad((WorkingColorSpace_ToAP1[2].y), _956, ((WorkingColorSpace_ToAP1[2].x) * _955)));
                _2403 = mad(_55, _2363, mad(_54, _2360, (_2357 * _53)));
                _2404 = mad(_58, _2363, mad(_57, _2360, (_2357 * _56)));
                _2405 = mad(_61, _2363, mad(_60, _2360, (_2357 * _59)));
              } else {
                float _2376 = mad((WorkingColorSpace_ToAP1[0].z), _983, mad((WorkingColorSpace_ToAP1[0].y), _982, ((WorkingColorSpace_ToAP1[0].x) * _981)));
                float _2379 = mad((WorkingColorSpace_ToAP1[1].z), _983, mad((WorkingColorSpace_ToAP1[1].y), _982, ((WorkingColorSpace_ToAP1[1].x) * _981)));
                float _2382 = mad((WorkingColorSpace_ToAP1[2].z), _983, mad((WorkingColorSpace_ToAP1[2].y), _982, ((WorkingColorSpace_ToAP1[2].x) * _981)));
                _2403 = exp2(log2(mad(_55, _2382, mad(_54, _2379, (_2376 * _53)))) * InverseGamma.z);
                _2404 = exp2(log2(mad(_58, _2382, mad(_57, _2379, (_2376 * _56)))) * InverseGamma.z);
                _2405 = exp2(log2(mad(_61, _2382, mad(_60, _2379, (_2376 * _59)))) * InverseGamma.z);
              }
            } else {
              _2403 = _967;
              _2404 = _968;
              _2405 = _969;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2403 * 0.9523810148239136f), (_2404 * 0.9523810148239136f), (_2405 * 0.9523810148239136f), 0.0f);
}

#include "./filmiclutbuilder.hlsl"

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};

RWTexture3D<float4> RWOutputTexture : register(u0);

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;
  bool is_hdr = (output_device >= 3u && output_device <= 6u);

  float4 SV_Target;

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
  float _1220;
  float _1235;
  float _1250;
  float _1258;
  float _1259;
  float _1260;
  float _1327;
  float _1360;
  float _1374;
  float _1413;
  float _1523;
  float _1597;
  float _1671;
  float _1750;
  float _1751;
  float _1752;
  float _1894;
  float _1909;
  float _1924;
  float _1932;
  float _1933;
  float _1934;
  float _2001;
  float _2034;
  float _2048;
  float _2087;
  float _2197;
  float _2271;
  float _2345;
  float _2424;
  float _2425;
  float _2426;
  float _2603;
  float _2604;
  float _2605;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _42 = (OutputGamut == 4);
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
  if ((uint)OutputDevice > (uint)2) {
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
  float _136 = mad((WorkingColorSpace.ToAP1[0].z), _121, mad((WorkingColorSpace.ToAP1[0].y), _120, ((WorkingColorSpace.ToAP1[0].x) * _119)));
  float _139 = mad((WorkingColorSpace.ToAP1[1].z), _121, mad((WorkingColorSpace.ToAP1[1].y), _120, ((WorkingColorSpace.ToAP1[1].x) * _119)));
  float _142 = mad((WorkingColorSpace.ToAP1[2].z), _121, mad((WorkingColorSpace.ToAP1[2].y), _120, ((WorkingColorSpace.ToAP1[2].x) * _119)));
  float _143 = dot(float3(_136, _139, _142), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
  float _635 = ((float((int)(((int)(uint)((bool)(_620 > 0.0f))) - ((int)(uint)((bool)(_620 < 0.0f))))) * (1.0f - (_624 * _624))) + 1.0f) * 0.02500000037252903f;
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
  float3 lerpColor = lerp(_718, float3(_715, _716, _717), 0.9599999785423279f);

#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _584, _585, _586);
  float _906 = lerpColor.r, _907 = lerpColor.g, _908 = lerpColor.b;
#else

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
#endif
  // remove max
  float _918 = mad((WorkingColorSpace.FromAP1[0].z), _908, mad((WorkingColorSpace.FromAP1[0].y), _907, ((WorkingColorSpace.FromAP1[0].x) * _906)));
  float _919 = mad((WorkingColorSpace.FromAP1[1].z), _908, mad((WorkingColorSpace.FromAP1[1].y), _907, ((WorkingColorSpace.FromAP1[1].x) * _906)));
  float _920 = mad((WorkingColorSpace.FromAP1[2].z), _908, mad((WorkingColorSpace.FromAP1[2].y), _907, ((WorkingColorSpace.FromAP1[2].x) * _906)));
  float _946 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _918)) * _918) + MappingPolynomial.z);
  float _947 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _919)) * _919) + MappingPolynomial.z);
  float _948 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _920)) * _920) + MappingPolynomial.z);
  float _955 = ((OverlayColor.x - _946) * OverlayColor.w) + _946;
  float _956 = ((OverlayColor.y - _947) * OverlayColor.w) + _947;
  float _957 = ((OverlayColor.z - _948) * OverlayColor.w) + _948;
  float _958 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _548, mad((WorkingColorSpace.FromAP1[0].y), _546, (_544 * (WorkingColorSpace.FromAP1[0].x))));
  float _959 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _548, mad((WorkingColorSpace.FromAP1[1].y), _546, ((WorkingColorSpace.FromAP1[1].x) * _544)));
  float _960 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _548, mad((WorkingColorSpace.FromAP1[2].y), _546, ((WorkingColorSpace.FromAP1[2].x) * _544)));
  float _967 = ((OverlayColor.x - _958) * OverlayColor.w) + _958;
  float _968 = ((OverlayColor.y - _959) * OverlayColor.w) + _959;
  float _969 = ((OverlayColor.z - _960) * OverlayColor.w) + _960;
  float _981 = exp2(log2(max(0.0f, _955)) * InverseGamma.y);
  float _982 = exp2(log2(max(0.0f, _956)) * InverseGamma.y);
  float _983 = exp2(log2(max(0.0f, _957)) * InverseGamma.y);

  if (GenerateOutput(_981, _982, _983, SV_Target, is_hdr)) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = SV_Target;
    return;
  }
  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace.bIsSRGB == 0) {
        float _1006 = mad((WorkingColorSpace.ToAP1[0].z), _983, mad((WorkingColorSpace.ToAP1[0].y), _982, ((WorkingColorSpace.ToAP1[0].x) * _981)));
        float _1009 = mad((WorkingColorSpace.ToAP1[1].z), _983, mad((WorkingColorSpace.ToAP1[1].y), _982, ((WorkingColorSpace.ToAP1[1].x) * _981)));
        float _1012 = mad((WorkingColorSpace.ToAP1[2].z), _983, mad((WorkingColorSpace.ToAP1[2].y), _982, ((WorkingColorSpace.ToAP1[2].x) * _981)));
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
            _2603 = _1036;
            _2604 = _1047;
            _2605 = (_1025 * 12.920000076293945f);
          } else {
            _2603 = _1036;
            _2604 = _1047;
            _2605 = (((pow(_1025, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1074 = mad((WorkingColorSpace.ToAP1[0].z), _983, mad((WorkingColorSpace.ToAP1[0].y), _982, ((WorkingColorSpace.ToAP1[0].x) * _981)));
      float _1077 = mad((WorkingColorSpace.ToAP1[1].z), _983, mad((WorkingColorSpace.ToAP1[1].y), _982, ((WorkingColorSpace.ToAP1[1].x) * _981)));
      float _1080 = mad((WorkingColorSpace.ToAP1[2].z), _983, mad((WorkingColorSpace.ToAP1[2].y), _982, ((WorkingColorSpace.ToAP1[2].x) * _981)));
      float _1090 = max(6.103519990574569e-05f, mad(_55, _1080, mad(_54, _1077, (_1074 * _53))));
      float _1091 = max(6.103519990574569e-05f, mad(_58, _1080, mad(_57, _1077, (_1074 * _56))));
      float _1092 = max(6.103519990574569e-05f, mad(_61, _1080, mad(_60, _1077, (_1074 * _59))));
      _2603 = min((_1090 * 4.5f), ((exp2(log2(max(_1090, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2604 = min((_1091 * 4.5f), ((exp2(log2(max(_1091, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2605 = min((_1092 * 4.5f), ((exp2(log2(max(_1092, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1168 = ACESSceneColorMultiplier * _967;
        float _1169 = ACESSceneColorMultiplier * _968;
        float _1170 = ACESSceneColorMultiplier * _969;
        float _1173 = mad((WorkingColorSpace.ToAP0[0].z), _1170, mad((WorkingColorSpace.ToAP0[0].y), _1169, ((WorkingColorSpace.ToAP0[0].x) * _1168)));
        float _1176 = mad((WorkingColorSpace.ToAP0[1].z), _1170, mad((WorkingColorSpace.ToAP0[1].y), _1169, ((WorkingColorSpace.ToAP0[1].x) * _1168)));
        float _1179 = mad((WorkingColorSpace.ToAP0[2].z), _1170, mad((WorkingColorSpace.ToAP0[2].y), _1169, ((WorkingColorSpace.ToAP0[2].x) * _1168)));
        float _1182 = mad(-0.21492856740951538f, _1179, mad(-0.2365107536315918f, _1176, (_1173 * 1.4514392614364624f)));
        float _1185 = mad(-0.09967592358589172f, _1179, mad(1.17622971534729f, _1176, (_1173 * -0.07655377686023712f)));
        float _1188 = mad(0.9977163076400757f, _1179, mad(-0.006032449658960104f, _1176, (_1173 * 0.008316148072481155f)));
        float _1190 = max(_1182, max(_1185, _1188));
        do {
          if (!(_1190 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1173 < 0.0f) || (bool)(_1176 < 0.0f))) || (bool)(_1179 < 0.0f))) {
              float _1200 = abs(_1190);
              float _1201 = (_1190 - _1182) / _1200;
              float _1203 = (_1190 - _1185) / _1200;
              float _1205 = (_1190 - _1188) / _1200;
              do {
                if (!(_1201 < 0.8149999976158142f)) {
                  float _1208 = _1201 + -0.8149999976158142f;
                  _1220 = ((_1208 / exp2(log2(exp2(log2(_1208 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1220 = _1201;
                }
                do {
                  if (!(_1203 < 0.8029999732971191f)) {
                    float _1223 = _1203 + -0.8029999732971191f;
                    _1235 = ((_1223 / exp2(log2(exp2(log2(_1223 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1235 = _1203;
                  }
                  do {
                    if (!(_1205 < 0.8799999952316284f)) {
                      float _1238 = _1205 + -0.8799999952316284f;
                      _1250 = ((_1238 / exp2(log2(exp2(log2(_1238 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1250 = _1205;
                    }
                    _1258 = (_1190 - (_1200 * _1220));
                    _1259 = (_1190 - (_1200 * _1235));
                    _1260 = (_1190 - (_1200 * _1250));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1258 = _1182;
              _1259 = _1185;
              _1260 = _1188;
            }
          } else {
            _1258 = _1182;
            _1259 = _1185;
            _1260 = _1188;
          }
          float _1276 = ((mad(0.16386906802654266f, _1260, mad(0.14067870378494263f, _1259, (_1258 * 0.6954522132873535f))) - _1173) * ACESGamutCompression) + _1173;
          float _1277 = ((mad(0.0955343171954155f, _1260, mad(0.8596711158752441f, _1259, (_1258 * 0.044794563204050064f))) - _1176) * ACESGamutCompression) + _1176;
          float _1278 = ((mad(1.0015007257461548f, _1260, mad(0.004025210160762072f, _1259, (_1258 * -0.005525882821530104f))) - _1179) * ACESGamutCompression) + _1179;
          float _1282 = max(max(_1276, _1277), _1278);
          float _1287 = (max(_1282, 1.000000013351432e-10f) - max(min(min(_1276, _1277), _1278), 1.000000013351432e-10f)) / max(_1282, 0.009999999776482582f);
          float _1300 = ((_1277 + _1276) + _1278) + (sqrt((((_1278 - _1277) * _1278) + ((_1277 - _1276) * _1277)) + ((_1276 - _1278) * _1276)) * 1.75f);
          float _1301 = _1300 * 0.3333333432674408f;
          float _1302 = _1287 + -0.4000000059604645f;
          float _1303 = _1302 * 5.0f;
          float _1307 = max((1.0f - abs(_1302 * 2.5f)), 0.0f);
          float _1318 = ((float((int)(((int)(uint)((bool)(_1303 > 0.0f))) - ((int)(uint)((bool)(_1303 < 0.0f))))) * (1.0f - (_1307 * _1307))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1301 <= 0.0533333346247673f)) {
              if (!(_1301 >= 0.1599999964237213f)) {
                _1327 = (((0.23999999463558197f / _1300) + -0.5f) * _1318);
              } else {
                _1327 = 0.0f;
              }
            } else {
              _1327 = _1318;
            }
            float _1328 = _1327 + 1.0f;
            float _1329 = _1328 * _1276;
            float _1330 = _1328 * _1277;
            float _1331 = _1328 * _1278;
            do {
              if (!((bool)(_1329 == _1330) && (bool)(_1330 == _1331))) {
                float _1338 = ((_1329 * 2.0f) - _1330) - _1331;
                float _1341 = ((_1277 - _1278) * 1.7320507764816284f) * _1328;
                float _1343 = atan(_1341 / _1338);
                bool _1346 = (_1338 < 0.0f);
                bool _1347 = (_1338 == 0.0f);
                bool _1348 = (_1341 >= 0.0f);
                bool _1349 = (_1341 < 0.0f);
                _1360 = select((_1348 && _1347), 90.0f, select((_1349 && _1347), -90.0f, (select((_1349 && _1346), (_1343 + -3.1415927410125732f), select((_1348 && _1346), (_1343 + 3.1415927410125732f), _1343)) * 57.2957763671875f)));
              } else {
                _1360 = 0.0f;
              }
              float _1365 = min(max(select((_1360 < 0.0f), (_1360 + 360.0f), _1360), 0.0f), 360.0f);
              do {
                if (_1365 < -180.0f) {
                  _1374 = (_1365 + 360.0f);
                } else {
                  if (_1365 > 180.0f) {
                    _1374 = (_1365 + -360.0f);
                  } else {
                    _1374 = _1365;
                  }
                }
                do {
                  if ((bool)(_1374 > -67.5f) && (bool)(_1374 < 67.5f)) {
                    float _1380 = (_1374 + 67.5f) * 0.029629629105329514f;
                    int _1381 = int(_1380);
                    float _1383 = _1380 - float((int)(_1381));
                    float _1384 = _1383 * _1383;
                    float _1385 = _1384 * _1383;
                    if (_1381 == 3) {
                      _1413 = (((0.1666666716337204f - (_1383 * 0.5f)) + (_1384 * 0.5f)) - (_1385 * 0.1666666716337204f));
                    } else {
                      if (_1381 == 2) {
                        _1413 = ((0.6666666865348816f - _1384) + (_1385 * 0.5f));
                      } else {
                        if (_1381 == 1) {
                          _1413 = (((_1385 * -0.5f) + 0.1666666716337204f) + ((_1384 + _1383) * 0.5f));
                        } else {
                          _1413 = select((_1381 == 0), (_1385 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1413 = 0.0f;
                  }
                  float _1422 = min(max(((((_1287 * 0.27000001072883606f) * (0.029999999329447746f - _1329)) * _1413) + _1329), 0.0f), 65535.0f);
                  float _1423 = min(max(_1330, 0.0f), 65535.0f);
                  float _1424 = min(max(_1331, 0.0f), 65535.0f);
                  float _1437 = min(max(mad(-0.21492856740951538f, _1424, mad(-0.2365107536315918f, _1423, (_1422 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1438 = min(max(mad(-0.09967592358589172f, _1424, mad(1.17622971534729f, _1423, (_1422 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1439 = min(max(mad(0.9977163076400757f, _1424, mad(-0.006032449658960104f, _1423, (_1422 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1440 = dot(float3(_1437, _1438, _1439), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1451 = log2(max((lerp(_1440, _1437, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1452 = _1451 * 0.3010300099849701f;
                  float _1453 = log2(ACESMinMaxData.x);
                  float _1454 = _1453 * 0.3010300099849701f;
                  do {
                    if (!(!(_1452 <= _1454))) {
                      _1523 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1461 = log2(ACESMidData.x);
                      float _1462 = _1461 * 0.3010300099849701f;
                      if ((bool)(_1452 > _1454) && (bool)(_1452 < _1462)) {
                        float _1470 = ((_1451 - _1453) * 0.9030900001525879f) / ((_1461 - _1453) * 0.3010300099849701f);
                        int _1471 = int(_1470);
                        float _1473 = _1470 - float((int)(_1471));
                        float _1475 = _11[_1471];
                        float _1478 = _11[(_1471 + 1)];
                        float _1483 = _1475 * 0.5f;
                        _1523 = dot(float3((_1473 * _1473), _1473, 1.0f), float3(mad((_11[(_1471 + 2)]), 0.5f, mad(_1478, -1.0f, _1483)), (_1478 - _1475), mad(_1478, 0.5f, _1483)));
                      } else {
                        do {
                          if (!(!(_1452 >= _1462))) {
                            float _1492 = log2(ACESMinMaxData.z);
                            if (_1452 < (_1492 * 0.3010300099849701f)) {
                              float _1500 = ((_1451 - _1461) * 0.9030900001525879f) / ((_1492 - _1461) * 0.3010300099849701f);
                              int _1501 = int(_1500);
                              float _1503 = _1500 - float((int)(_1501));
                              float _1505 = _12[_1501];
                              float _1508 = _12[(_1501 + 1)];
                              float _1513 = _1505 * 0.5f;
                              _1523 = dot(float3((_1503 * _1503), _1503, 1.0f), float3(mad((_12[(_1501 + 2)]), 0.5f, mad(_1508, -1.0f, _1513)), (_1508 - _1505), mad(_1508, 0.5f, _1513)));
                              break;
                            }
                          }
                          _1523 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1527 = log2(max((lerp(_1440, _1438, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1528 = _1527 * 0.3010300099849701f;
                    do {
                      if (!(!(_1528 <= _1454))) {
                        _1597 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1535 = log2(ACESMidData.x);
                        float _1536 = _1535 * 0.3010300099849701f;
                        if ((bool)(_1528 > _1454) && (bool)(_1528 < _1536)) {
                          float _1544 = ((_1527 - _1453) * 0.9030900001525879f) / ((_1535 - _1453) * 0.3010300099849701f);
                          int _1545 = int(_1544);
                          float _1547 = _1544 - float((int)(_1545));
                          float _1549 = _11[_1545];
                          float _1552 = _11[(_1545 + 1)];
                          float _1557 = _1549 * 0.5f;
                          _1597 = dot(float3((_1547 * _1547), _1547, 1.0f), float3(mad((_11[(_1545 + 2)]), 0.5f, mad(_1552, -1.0f, _1557)), (_1552 - _1549), mad(_1552, 0.5f, _1557)));
                        } else {
                          do {
                            if (!(!(_1528 >= _1536))) {
                              float _1566 = log2(ACESMinMaxData.z);
                              if (_1528 < (_1566 * 0.3010300099849701f)) {
                                float _1574 = ((_1527 - _1535) * 0.9030900001525879f) / ((_1566 - _1535) * 0.3010300099849701f);
                                int _1575 = int(_1574);
                                float _1577 = _1574 - float((int)(_1575));
                                float _1579 = _12[_1575];
                                float _1582 = _12[(_1575 + 1)];
                                float _1587 = _1579 * 0.5f;
                                _1597 = dot(float3((_1577 * _1577), _1577, 1.0f), float3(mad((_12[(_1575 + 2)]), 0.5f, mad(_1582, -1.0f, _1587)), (_1582 - _1579), mad(_1582, 0.5f, _1587)));
                                break;
                              }
                            }
                            _1597 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1601 = log2(max((lerp(_1440, _1439, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1602 = _1601 * 0.3010300099849701f;
                      do {
                        if (!(!(_1602 <= _1454))) {
                          _1671 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1609 = log2(ACESMidData.x);
                          float _1610 = _1609 * 0.3010300099849701f;
                          if ((bool)(_1602 > _1454) && (bool)(_1602 < _1610)) {
                            float _1618 = ((_1601 - _1453) * 0.9030900001525879f) / ((_1609 - _1453) * 0.3010300099849701f);
                            int _1619 = int(_1618);
                            float _1621 = _1618 - float((int)(_1619));
                            float _1623 = _11[_1619];
                            float _1626 = _11[(_1619 + 1)];
                            float _1631 = _1623 * 0.5f;
                            _1671 = dot(float3((_1621 * _1621), _1621, 1.0f), float3(mad((_11[(_1619 + 2)]), 0.5f, mad(_1626, -1.0f, _1631)), (_1626 - _1623), mad(_1626, 0.5f, _1631)));
                          } else {
                            do {
                              if (!(!(_1602 >= _1610))) {
                                float _1640 = log2(ACESMinMaxData.z);
                                if (_1602 < (_1640 * 0.3010300099849701f)) {
                                  float _1648 = ((_1601 - _1609) * 0.9030900001525879f) / ((_1640 - _1609) * 0.3010300099849701f);
                                  int _1649 = int(_1648);
                                  float _1651 = _1648 - float((int)(_1649));
                                  float _1653 = _12[_1649];
                                  float _1656 = _12[(_1649 + 1)];
                                  float _1661 = _1653 * 0.5f;
                                  _1671 = dot(float3((_1651 * _1651), _1651, 1.0f), float3(mad((_12[(_1649 + 2)]), 0.5f, mad(_1656, -1.0f, _1661)), (_1656 - _1653), mad(_1656, 0.5f, _1661)));
                                  break;
                                }
                              }
                              _1671 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1675 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1676 = (exp2(_1523 * 3.321928024291992f) - ACESMinMaxData.y) / _1675;
                        float _1678 = (exp2(_1597 * 3.321928024291992f) - ACESMinMaxData.y) / _1675;
                        float _1680 = (exp2(_1671 * 3.321928024291992f) - ACESMinMaxData.y) / _1675;
                        float _1683 = mad(0.15618768334388733f, _1680, mad(0.13400420546531677f, _1678, (_1676 * 0.6624541878700256f)));
                        float _1686 = mad(0.053689517080783844f, _1680, mad(0.6740817427635193f, _1678, (_1676 * 0.2722287178039551f)));
                        float _1689 = mad(1.0103391408920288f, _1680, mad(0.00406073359772563f, _1678, (_1676 * -0.005574649665504694f)));
                        float _1702 = min(max(mad(-0.23642469942569733f, _1689, mad(-0.32480329275131226f, _1686, (_1683 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1703 = min(max(mad(0.016756348311901093f, _1689, mad(1.6153316497802734f, _1686, (_1683 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1704 = min(max(mad(0.9883948564529419f, _1689, mad(-0.008284442126750946f, _1686, (_1683 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1707 = mad(0.15618768334388733f, _1704, mad(0.13400420546531677f, _1703, (_1702 * 0.6624541878700256f)));
                        float _1710 = mad(0.053689517080783844f, _1704, mad(0.6740817427635193f, _1703, (_1702 * 0.2722287178039551f)));
                        float _1713 = mad(1.0103391408920288f, _1704, mad(0.00406073359772563f, _1703, (_1702 * -0.005574649665504694f)));
                        float _1735 = min(max((min(max(mad(-0.23642469942569733f, _1713, mad(-0.32480329275131226f, _1710, (_1707 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1736 = min(max((min(max(mad(0.016756348311901093f, _1713, mad(1.6153316497802734f, _1710, (_1707 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1737 = min(max((min(max(mad(0.9883948564529419f, _1713, mad(-0.008284442126750946f, _1710, (_1707 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 5)) {
                            _1750 = mad(_55, _1737, mad(_54, _1736, (_1735 * _53)));
                            _1751 = mad(_58, _1737, mad(_57, _1736, (_1735 * _56)));
                            _1752 = mad(_61, _1737, mad(_60, _1736, (_1735 * _59)));
                          } else {
                            _1750 = _1735;
                            _1751 = _1736;
                            _1752 = _1737;
                          }
                          float _1762 = exp2(log2(_1750 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1763 = exp2(log2(_1751 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1764 = exp2(log2(_1752 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2603 = exp2(log2((1.0f / ((_1762 * 18.6875f) + 1.0f)) * ((_1762 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2604 = exp2(log2((1.0f / ((_1763 * 18.6875f) + 1.0f)) * ((_1763 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2605 = exp2(log2((1.0f / ((_1764 * 18.6875f) + 1.0f)) * ((_1764 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
        if ((OutputDevice & -3) == 4) {
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
          float _1842 = ACESSceneColorMultiplier * _967;
          float _1843 = ACESSceneColorMultiplier * _968;
          float _1844 = ACESSceneColorMultiplier * _969;
          float _1847 = mad((WorkingColorSpace.ToAP0[0].z), _1844, mad((WorkingColorSpace.ToAP0[0].y), _1843, ((WorkingColorSpace.ToAP0[0].x) * _1842)));
          float _1850 = mad((WorkingColorSpace.ToAP0[1].z), _1844, mad((WorkingColorSpace.ToAP0[1].y), _1843, ((WorkingColorSpace.ToAP0[1].x) * _1842)));
          float _1853 = mad((WorkingColorSpace.ToAP0[2].z), _1844, mad((WorkingColorSpace.ToAP0[2].y), _1843, ((WorkingColorSpace.ToAP0[2].x) * _1842)));
          float _1856 = mad(-0.21492856740951538f, _1853, mad(-0.2365107536315918f, _1850, (_1847 * 1.4514392614364624f)));
          float _1859 = mad(-0.09967592358589172f, _1853, mad(1.17622971534729f, _1850, (_1847 * -0.07655377686023712f)));
          float _1862 = mad(0.9977163076400757f, _1853, mad(-0.006032449658960104f, _1850, (_1847 * 0.008316148072481155f)));
          float _1864 = max(_1856, max(_1859, _1862));
          do {
            if (!(_1864 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1847 < 0.0f) || (bool)(_1850 < 0.0f))) || (bool)(_1853 < 0.0f))) {
                float _1874 = abs(_1864);
                float _1875 = (_1864 - _1856) / _1874;
                float _1877 = (_1864 - _1859) / _1874;
                float _1879 = (_1864 - _1862) / _1874;
                do {
                  if (!(_1875 < 0.8149999976158142f)) {
                    float _1882 = _1875 + -0.8149999976158142f;
                    _1894 = ((_1882 / exp2(log2(exp2(log2(_1882 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _1894 = _1875;
                  }
                  do {
                    if (!(_1877 < 0.8029999732971191f)) {
                      float _1897 = _1877 + -0.8029999732971191f;
                      _1909 = ((_1897 / exp2(log2(exp2(log2(_1897 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _1909 = _1877;
                    }
                    do {
                      if (!(_1879 < 0.8799999952316284f)) {
                        float _1912 = _1879 + -0.8799999952316284f;
                        _1924 = ((_1912 / exp2(log2(exp2(log2(_1912 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _1924 = _1879;
                      }
                      _1932 = (_1864 - (_1874 * _1894));
                      _1933 = (_1864 - (_1874 * _1909));
                      _1934 = (_1864 - (_1874 * _1924));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _1932 = _1856;
                _1933 = _1859;
                _1934 = _1862;
              }
            } else {
              _1932 = _1856;
              _1933 = _1859;
              _1934 = _1862;
            }
            float _1950 = ((mad(0.16386906802654266f, _1934, mad(0.14067870378494263f, _1933, (_1932 * 0.6954522132873535f))) - _1847) * ACESGamutCompression) + _1847;
            float _1951 = ((mad(0.0955343171954155f, _1934, mad(0.8596711158752441f, _1933, (_1932 * 0.044794563204050064f))) - _1850) * ACESGamutCompression) + _1850;
            float _1952 = ((mad(1.0015007257461548f, _1934, mad(0.004025210160762072f, _1933, (_1932 * -0.005525882821530104f))) - _1853) * ACESGamutCompression) + _1853;
            float _1956 = max(max(_1950, _1951), _1952);
            float _1961 = (max(_1956, 1.000000013351432e-10f) - max(min(min(_1950, _1951), _1952), 1.000000013351432e-10f)) / max(_1956, 0.009999999776482582f);
            float _1974 = ((_1951 + _1950) + _1952) + (sqrt((((_1952 - _1951) * _1952) + ((_1951 - _1950) * _1951)) + ((_1950 - _1952) * _1950)) * 1.75f);
            float _1975 = _1974 * 0.3333333432674408f;
            float _1976 = _1961 + -0.4000000059604645f;
            float _1977 = _1976 * 5.0f;
            float _1981 = max((1.0f - abs(_1976 * 2.5f)), 0.0f);
            float _1992 = ((float((int)(((int)(uint)((bool)(_1977 > 0.0f))) - ((int)(uint)((bool)(_1977 < 0.0f))))) * (1.0f - (_1981 * _1981))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_1975 <= 0.0533333346247673f)) {
                if (!(_1975 >= 0.1599999964237213f)) {
                  _2001 = (((0.23999999463558197f / _1974) + -0.5f) * _1992);
                } else {
                  _2001 = 0.0f;
                }
              } else {
                _2001 = _1992;
              }
              float _2002 = _2001 + 1.0f;
              float _2003 = _2002 * _1950;
              float _2004 = _2002 * _1951;
              float _2005 = _2002 * _1952;
              do {
                if (!((bool)(_2003 == _2004) && (bool)(_2004 == _2005))) {
                  float _2012 = ((_2003 * 2.0f) - _2004) - _2005;
                  float _2015 = ((_1951 - _1952) * 1.7320507764816284f) * _2002;
                  float _2017 = atan(_2015 / _2012);
                  bool _2020 = (_2012 < 0.0f);
                  bool _2021 = (_2012 == 0.0f);
                  bool _2022 = (_2015 >= 0.0f);
                  bool _2023 = (_2015 < 0.0f);
                  _2034 = select((_2022 && _2021), 90.0f, select((_2023 && _2021), -90.0f, (select((_2023 && _2020), (_2017 + -3.1415927410125732f), select((_2022 && _2020), (_2017 + 3.1415927410125732f), _2017)) * 57.2957763671875f)));
                } else {
                  _2034 = 0.0f;
                }
                float _2039 = min(max(select((_2034 < 0.0f), (_2034 + 360.0f), _2034), 0.0f), 360.0f);
                do {
                  if (_2039 < -180.0f) {
                    _2048 = (_2039 + 360.0f);
                  } else {
                    if (_2039 > 180.0f) {
                      _2048 = (_2039 + -360.0f);
                    } else {
                      _2048 = _2039;
                    }
                  }
                  do {
                    if ((bool)(_2048 > -67.5f) && (bool)(_2048 < 67.5f)) {
                      float _2054 = (_2048 + 67.5f) * 0.029629629105329514f;
                      int _2055 = int(_2054);
                      float _2057 = _2054 - float((int)(_2055));
                      float _2058 = _2057 * _2057;
                      float _2059 = _2058 * _2057;
                      if (_2055 == 3) {
                        _2087 = (((0.1666666716337204f - (_2057 * 0.5f)) + (_2058 * 0.5f)) - (_2059 * 0.1666666716337204f));
                      } else {
                        if (_2055 == 2) {
                          _2087 = ((0.6666666865348816f - _2058) + (_2059 * 0.5f));
                        } else {
                          if (_2055 == 1) {
                            _2087 = (((_2059 * -0.5f) + 0.1666666716337204f) + ((_2058 + _2057) * 0.5f));
                          } else {
                            _2087 = select((_2055 == 0), (_2059 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2087 = 0.0f;
                    }
                    float _2096 = min(max(((((_1961 * 0.27000001072883606f) * (0.029999999329447746f - _2003)) * _2087) + _2003), 0.0f), 65535.0f);
                    float _2097 = min(max(_2004, 0.0f), 65535.0f);
                    float _2098 = min(max(_2005, 0.0f), 65535.0f);
                    float _2111 = min(max(mad(-0.21492856740951538f, _2098, mad(-0.2365107536315918f, _2097, (_2096 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2112 = min(max(mad(-0.09967592358589172f, _2098, mad(1.17622971534729f, _2097, (_2096 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2113 = min(max(mad(0.9977163076400757f, _2098, mad(-0.006032449658960104f, _2097, (_2096 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2114 = dot(float3(_2111, _2112, _2113), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2125 = log2(max((lerp(_2114, _2111, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2126 = _2125 * 0.3010300099849701f;
                    float _2127 = log2(ACESMinMaxData.x);
                    float _2128 = _2127 * 0.3010300099849701f;
                    do {
                      if (!(!(_2126 <= _2128))) {
                        _2197 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2135 = log2(ACESMidData.x);
                        float _2136 = _2135 * 0.3010300099849701f;
                        if ((bool)(_2126 > _2128) && (bool)(_2126 < _2136)) {
                          float _2144 = ((_2125 - _2127) * 0.9030900001525879f) / ((_2135 - _2127) * 0.3010300099849701f);
                          int _2145 = int(_2144);
                          float _2147 = _2144 - float((int)(_2145));
                          float _2149 = _9[_2145];
                          float _2152 = _9[(_2145 + 1)];
                          float _2157 = _2149 * 0.5f;
                          _2197 = dot(float3((_2147 * _2147), _2147, 1.0f), float3(mad((_9[(_2145 + 2)]), 0.5f, mad(_2152, -1.0f, _2157)), (_2152 - _2149), mad(_2152, 0.5f, _2157)));
                        } else {
                          do {
                            if (!(!(_2126 >= _2136))) {
                              float _2166 = log2(ACESMinMaxData.z);
                              if (_2126 < (_2166 * 0.3010300099849701f)) {
                                float _2174 = ((_2125 - _2135) * 0.9030900001525879f) / ((_2166 - _2135) * 0.3010300099849701f);
                                int _2175 = int(_2174);
                                float _2177 = _2174 - float((int)(_2175));
                                float _2179 = _10[_2175];
                                float _2182 = _10[(_2175 + 1)];
                                float _2187 = _2179 * 0.5f;
                                _2197 = dot(float3((_2177 * _2177), _2177, 1.0f), float3(mad((_10[(_2175 + 2)]), 0.5f, mad(_2182, -1.0f, _2187)), (_2182 - _2179), mad(_2182, 0.5f, _2187)));
                                break;
                              }
                            }
                            _2197 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2201 = log2(max((lerp(_2114, _2112, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2202 = _2201 * 0.3010300099849701f;
                      do {
                        if (!(!(_2202 <= _2128))) {
                          _2271 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2209 = log2(ACESMidData.x);
                          float _2210 = _2209 * 0.3010300099849701f;
                          if ((bool)(_2202 > _2128) && (bool)(_2202 < _2210)) {
                            float _2218 = ((_2201 - _2127) * 0.9030900001525879f) / ((_2209 - _2127) * 0.3010300099849701f);
                            int _2219 = int(_2218);
                            float _2221 = _2218 - float((int)(_2219));
                            float _2223 = _9[_2219];
                            float _2226 = _9[(_2219 + 1)];
                            float _2231 = _2223 * 0.5f;
                            _2271 = dot(float3((_2221 * _2221), _2221, 1.0f), float3(mad((_9[(_2219 + 2)]), 0.5f, mad(_2226, -1.0f, _2231)), (_2226 - _2223), mad(_2226, 0.5f, _2231)));
                          } else {
                            do {
                              if (!(!(_2202 >= _2210))) {
                                float _2240 = log2(ACESMinMaxData.z);
                                if (_2202 < (_2240 * 0.3010300099849701f)) {
                                  float _2248 = ((_2201 - _2209) * 0.9030900001525879f) / ((_2240 - _2209) * 0.3010300099849701f);
                                  int _2249 = int(_2248);
                                  float _2251 = _2248 - float((int)(_2249));
                                  float _2253 = _10[_2249];
                                  float _2256 = _10[(_2249 + 1)];
                                  float _2261 = _2253 * 0.5f;
                                  _2271 = dot(float3((_2251 * _2251), _2251, 1.0f), float3(mad((_10[(_2249 + 2)]), 0.5f, mad(_2256, -1.0f, _2261)), (_2256 - _2253), mad(_2256, 0.5f, _2261)));
                                  break;
                                }
                              }
                              _2271 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2275 = log2(max((lerp(_2114, _2113, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2276 = _2275 * 0.3010300099849701f;
                        do {
                          if (!(!(_2276 <= _2128))) {
                            _2345 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2283 = log2(ACESMidData.x);
                            float _2284 = _2283 * 0.3010300099849701f;
                            if ((bool)(_2276 > _2128) && (bool)(_2276 < _2284)) {
                              float _2292 = ((_2275 - _2127) * 0.9030900001525879f) / ((_2283 - _2127) * 0.3010300099849701f);
                              int _2293 = int(_2292);
                              float _2295 = _2292 - float((int)(_2293));
                              float _2297 = _9[_2293];
                              float _2300 = _9[(_2293 + 1)];
                              float _2305 = _2297 * 0.5f;
                              _2345 = dot(float3((_2295 * _2295), _2295, 1.0f), float3(mad((_9[(_2293 + 2)]), 0.5f, mad(_2300, -1.0f, _2305)), (_2300 - _2297), mad(_2300, 0.5f, _2305)));
                            } else {
                              do {
                                if (!(!(_2276 >= _2284))) {
                                  float _2314 = log2(ACESMinMaxData.z);
                                  if (_2276 < (_2314 * 0.3010300099849701f)) {
                                    float _2322 = ((_2275 - _2283) * 0.9030900001525879f) / ((_2314 - _2283) * 0.3010300099849701f);
                                    int _2323 = int(_2322);
                                    float _2325 = _2322 - float((int)(_2323));
                                    float _2327 = _10[_2323];
                                    float _2330 = _10[(_2323 + 1)];
                                    float _2335 = _2327 * 0.5f;
                                    _2345 = dot(float3((_2325 * _2325), _2325, 1.0f), float3(mad((_10[(_2323 + 2)]), 0.5f, mad(_2330, -1.0f, _2335)), (_2330 - _2327), mad(_2330, 0.5f, _2335)));
                                    break;
                                  }
                                }
                                _2345 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2349 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2350 = (exp2(_2197 * 3.321928024291992f) - ACESMinMaxData.y) / _2349;
                          float _2352 = (exp2(_2271 * 3.321928024291992f) - ACESMinMaxData.y) / _2349;
                          float _2354 = (exp2(_2345 * 3.321928024291992f) - ACESMinMaxData.y) / _2349;
                          float _2357 = mad(0.15618768334388733f, _2354, mad(0.13400420546531677f, _2352, (_2350 * 0.6624541878700256f)));
                          float _2360 = mad(0.053689517080783844f, _2354, mad(0.6740817427635193f, _2352, (_2350 * 0.2722287178039551f)));
                          float _2363 = mad(1.0103391408920288f, _2354, mad(0.00406073359772563f, _2352, (_2350 * -0.005574649665504694f)));
                          float _2376 = min(max(mad(-0.23642469942569733f, _2363, mad(-0.32480329275131226f, _2360, (_2357 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2377 = min(max(mad(0.016756348311901093f, _2363, mad(1.6153316497802734f, _2360, (_2357 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2378 = min(max(mad(0.9883948564529419f, _2363, mad(-0.008284442126750946f, _2360, (_2357 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2381 = mad(0.15618768334388733f, _2378, mad(0.13400420546531677f, _2377, (_2376 * 0.6624541878700256f)));
                          float _2384 = mad(0.053689517080783844f, _2378, mad(0.6740817427635193f, _2377, (_2376 * 0.2722287178039551f)));
                          float _2387 = mad(1.0103391408920288f, _2378, mad(0.00406073359772563f, _2377, (_2376 * -0.005574649665504694f)));
                          float _2409 = min(max((min(max(mad(-0.23642469942569733f, _2387, mad(-0.32480329275131226f, _2384, (_2381 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2410 = min(max((min(max(mad(0.016756348311901093f, _2387, mad(1.6153316497802734f, _2384, (_2381 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2411 = min(max((min(max(mad(0.9883948564529419f, _2387, mad(-0.008284442126750946f, _2384, (_2381 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(OutputDevice == 6)) {
                              _2424 = mad(_55, _2411, mad(_54, _2410, (_2409 * _53)));
                              _2425 = mad(_58, _2411, mad(_57, _2410, (_2409 * _56)));
                              _2426 = mad(_61, _2411, mad(_60, _2410, (_2409 * _59)));
                            } else {
                              _2424 = _2409;
                              _2425 = _2410;
                              _2426 = _2411;
                            }
                            float _2436 = exp2(log2(_2424 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2437 = exp2(log2(_2425 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2438 = exp2(log2(_2426 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2603 = exp2(log2((1.0f / ((_2436 * 18.6875f) + 1.0f)) * ((_2436 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2604 = exp2(log2((1.0f / ((_2437 * 18.6875f) + 1.0f)) * ((_2437 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2605 = exp2(log2((1.0f / ((_2438 * 18.6875f) + 1.0f)) * ((_2438 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          if (OutputDevice == 7) {
            float _2483 = mad((WorkingColorSpace.ToAP1[0].z), _969, mad((WorkingColorSpace.ToAP1[0].y), _968, ((WorkingColorSpace.ToAP1[0].x) * _967)));
            float _2486 = mad((WorkingColorSpace.ToAP1[1].z), _969, mad((WorkingColorSpace.ToAP1[1].y), _968, ((WorkingColorSpace.ToAP1[1].x) * _967)));
            float _2489 = mad((WorkingColorSpace.ToAP1[2].z), _969, mad((WorkingColorSpace.ToAP1[2].y), _968, ((WorkingColorSpace.ToAP1[2].x) * _967)));
            float _2508 = exp2(log2(mad(_55, _2489, mad(_54, _2486, (_2483 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2509 = exp2(log2(mad(_58, _2489, mad(_57, _2486, (_2483 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2510 = exp2(log2(mad(_61, _2489, mad(_60, _2486, (_2483 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2603 = exp2(log2((1.0f / ((_2508 * 18.6875f) + 1.0f)) * ((_2508 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2604 = exp2(log2((1.0f / ((_2509 * 18.6875f) + 1.0f)) * ((_2509 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2605 = exp2(log2((1.0f / ((_2510 * 18.6875f) + 1.0f)) * ((_2510 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2557 = mad((WorkingColorSpace.ToAP1[0].z), _957, mad((WorkingColorSpace.ToAP1[0].y), _956, ((WorkingColorSpace.ToAP1[0].x) * _955)));
                float _2560 = mad((WorkingColorSpace.ToAP1[1].z), _957, mad((WorkingColorSpace.ToAP1[1].y), _956, ((WorkingColorSpace.ToAP1[1].x) * _955)));
                float _2563 = mad((WorkingColorSpace.ToAP1[2].z), _957, mad((WorkingColorSpace.ToAP1[2].y), _956, ((WorkingColorSpace.ToAP1[2].x) * _955)));
                _2603 = mad(_55, _2563, mad(_54, _2560, (_2557 * _53)));
                _2604 = mad(_58, _2563, mad(_57, _2560, (_2557 * _56)));
                _2605 = mad(_61, _2563, mad(_60, _2560, (_2557 * _59)));
              } else {
                float _2576 = mad((WorkingColorSpace.ToAP1[0].z), _983, mad((WorkingColorSpace.ToAP1[0].y), _982, ((WorkingColorSpace.ToAP1[0].x) * _981)));
                float _2579 = mad((WorkingColorSpace.ToAP1[1].z), _983, mad((WorkingColorSpace.ToAP1[1].y), _982, ((WorkingColorSpace.ToAP1[1].x) * _981)));
                float _2582 = mad((WorkingColorSpace.ToAP1[2].z), _983, mad((WorkingColorSpace.ToAP1[2].y), _982, ((WorkingColorSpace.ToAP1[2].x) * _981)));
                _2603 = exp2(log2(mad(_55, _2582, mad(_54, _2579, (_2576 * _53)))) * InverseGamma.z);
                _2604 = exp2(log2(mad(_58, _2582, mad(_57, _2579, (_2576 * _56)))) * InverseGamma.z);
                _2605 = exp2(log2(mad(_61, _2582, mad(_60, _2579, (_2576 * _59)))) * InverseGamma.z);
              }
            } else {
              _2603 = _967;
              _2604 = _968;
              _2605 = _969;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2603 * 0.9523810148239136f), (_2604 * 0.9523810148239136f), (_2605 * 0.9523810148239136f), 0.0f);
}

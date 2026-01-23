// Clair Obscur: Expedition 33
#include "./filmiclutbuilder.hlsl"

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;
  bool is_hdr = (output_device >= 3u && output_device <= 6u);

  float4 SV_Target;
  float _8[6];
  float _9[6];
  float _10[6];
  float _11[6];
  float _14 = 0.5f / LUTSize;
  float _19 = LUTSize + -1.0f;
  float _20 = (LUTSize * (TEXCOORD.x - _14)) / _19;
  float _21 = (LUTSize * (TEXCOORD.y - _14)) / _19;
  float _23 = float((uint)SV_RenderTargetArrayIndex) / _19;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _109;
  float _110;
  float _111;
  float _634;
  float _667;
  float _681;
  float _745;
  float _1013;
  float _1014;
  float _1015;
  float _1026;
  float _1037;
  float _1210;
  float _1225;
  float _1240;
  float _1248;
  float _1249;
  float _1250;
  float _1317;
  float _1350;
  float _1364;
  float _1403;
  float _1513;
  float _1587;
  float _1661;
  float _1740;
  float _1741;
  float _1742;
  float _1884;
  float _1899;
  float _1914;
  float _1922;
  float _1923;
  float _1924;
  float _1991;
  float _2024;
  float _2038;
  float _2077;
  float _2187;
  float _2261;
  float _2335;
  float _2414;
  float _2415;
  float _2416;
  float _2593;
  float _2594;
  float _2595;
  if (!((uint)(output_gamut) == 1)) {
    if (!((uint)(output_gamut) == 2)) {
      if (!((uint)(output_gamut) == 3)) {
        bool _32 = ((uint)(output_gamut) == 4);
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
  if ((uint)(uint)(output_device) > (uint)2) {
    float _62 = (pow(_20, 0.012683313339948654f));
    float _63 = (pow(_21, 0.012683313339948654f));
    float _64 = (pow(_23, 0.012683313339948654f));
    _109 = (exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _110 = (exp2(log2(max(0.0f, (_63 + -0.8359375f)) / (18.8515625f - (_63 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _111 = (exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _109 = ((exp2((_20 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _110 = ((exp2((_21 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _111 = ((exp2((_23 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  float _126 = mad((WorkingColorSpace.ToAP1[0].z), _111, mad((WorkingColorSpace.ToAP1[0].y), _110, ((WorkingColorSpace.ToAP1[0].x) * _109)));
  float _129 = mad((WorkingColorSpace.ToAP1[1].z), _111, mad((WorkingColorSpace.ToAP1[1].y), _110, ((WorkingColorSpace.ToAP1[1].x) * _109)));
  float _132 = mad((WorkingColorSpace.ToAP1[2].z), _111, mad((WorkingColorSpace.ToAP1[2].y), _110, ((WorkingColorSpace.ToAP1[2].x) * _109)));

  // SetUngradedAP1(_126, _129, _132);

  float _133 = dot(float3(_126, _129, _132), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _137 = (_126 / _133) + -1.0f;
  float _138 = (_129 / _133) + -1.0f;
  float _139 = (_132 / _133) + -1.0f;
  float _151 = (1.0f - exp2(((_133 * _133) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_137, _138, _139), float3(_137, _138, _139)) * -4.0f));
  float _167 = ((mad(-0.06368321925401688f, _132, mad(-0.3292922377586365f, _129, (_126 * 1.3704125881195068f))) - _126) * _151) + _126;
  float _168 = ((mad(-0.010861365124583244f, _132, mad(1.0970927476882935f, _129, (_126 * -0.08343357592821121f))) - _129) * _151) + _129;
  float _169 = ((mad(1.2036951780319214f, _132, mad(-0.09862580895423889f, _129, (_126 * -0.02579331398010254f))) - _132) * _151) + _132;
  float _170 = dot(float3(_167, _168, _169), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _184 = ColorOffset.w + ColorOffsetShadows.w;
  float _198 = ColorGain.w * ColorGainShadows.w;
  float _212 = ColorGamma.w * ColorGammaShadows.w;
  float _226 = ColorContrast.w * ColorContrastShadows.w;
  float _240 = ColorSaturation.w * ColorSaturationShadows.w;
  float _244 = _167 - _170;
  float _245 = _168 - _170;
  float _246 = _169 - _170;
  float _303 = saturate(_170 / ColorCorrectionShadowsMax);
  float _307 = (_303 * _303) * (3.0f - (_303 * 2.0f));
  float _308 = 1.0f - _307;
  float _317 = ColorOffset.w + ColorOffsetHighlights.w;
  float _326 = ColorGain.w * ColorGainHighlights.w;
  float _335 = ColorGamma.w * ColorGammaHighlights.w;
  float _344 = ColorContrast.w * ColorContrastHighlights.w;
  float _353 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _416 = saturate((_170 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _420 = (_416 * _416) * (3.0f - (_416 * 2.0f));
  float _429 = ColorOffset.w + ColorOffsetMidtones.w;
  float _438 = ColorGain.w * ColorGainMidtones.w;
  float _447 = ColorGamma.w * ColorGammaMidtones.w;
  float _456 = ColorContrast.w * ColorContrastMidtones.w;
  float _465 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _523 = _307 - _420;
  float _534 = ((_420 * (((ColorOffset.x + ColorOffsetHighlights.x) + _317) + (((ColorGain.x * ColorGainHighlights.x) * _326) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _344) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _353) * _244) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _335)))))) + (_308 * (((ColorOffset.x + ColorOffsetShadows.x) + _184) + (((ColorGain.x * ColorGainShadows.x) * _198) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _226) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _240) * _244) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _212))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _429) + (((ColorGain.x * ColorGainMidtones.x) * _438) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _456) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _465) * _244) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _447))))) * _523);
  float _536 = ((_420 * (((ColorOffset.y + ColorOffsetHighlights.y) + _317) + (((ColorGain.y * ColorGainHighlights.y) * _326) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _344) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _353) * _245) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _335)))))) + (_308 * (((ColorOffset.y + ColorOffsetShadows.y) + _184) + (((ColorGain.y * ColorGainShadows.y) * _198) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _226) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _240) * _245) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _212))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _429) + (((ColorGain.y * ColorGainMidtones.y) * _438) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _456) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _465) * _245) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _447))))) * _523);
  float _538 = ((_420 * (((ColorOffset.z + ColorOffsetHighlights.z) + _317) + (((ColorGain.z * ColorGainHighlights.z) * _326) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _344) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _353) * _246) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _335)))))) + (_308 * (((ColorOffset.z + ColorOffsetShadows.z) + _184) + (((ColorGain.z * ColorGainShadows.z) * _198) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _226) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _240) * _246) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _212))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _429) + (((ColorGain.z * ColorGainMidtones.z) * _438) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _456) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _465) * _246) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _447))))) * _523);

  // Will cause issues with grayscale scenes if moved above
  // SetUntonemappedAP1(_534, _536, _538);
#if 1  // begin FilmToneMap with BlueCorrect
  float _896, _897, _898;
  ApplyFilmToneMapWithBlueCorrect(_534, _536, _538,
                                  _896, _897, _898);
#else

  float _574 = ((mad(0.061360642313957214f, _538, mad(-4.540197551250458e-09f, _536, (_534 * 0.9386394023895264f))) - _534) * BlueCorrection) + _534;
  float _575 = ((mad(0.169205904006958f, _538, mad(0.8307942152023315f, _536, (_534 * 6.775371730327606e-08f))) - _536) * BlueCorrection) + _536;
  float _576 = (mad(-2.3283064365386963e-10f, _536, (_534 * -9.313225746154785e-10f)) * BlueCorrection) + _538;
  float _579 = mad(0.16386905312538147f, _576, mad(0.14067868888378143f, _575, (_574 * 0.6954522132873535f)));
  float _582 = mad(0.0955343246459961f, _576, mad(0.8596711158752441f, _575, (_574 * 0.044794581830501556f)));
  float _585 = mad(1.0015007257461548f, _576, mad(0.004025210160762072f, _575, (_574 * -0.005525882821530104f)));
  float _589 = max(max(_579, _582), _585);
  float _594 = (max(_589, 1.000000013351432e-10f) - max(min(min(_579, _582), _585), 1.000000013351432e-10f)) / max(_589, 0.009999999776482582f);
  float _607 = ((_582 + _579) + _585) + (sqrt((((_585 - _582) * _585) + ((_582 - _579) * _582)) + ((_579 - _585) * _579)) * 1.75f);
  float _608 = _607 * 0.3333333432674408f;
  float _609 = _594 + -0.4000000059604645f;
  float _610 = _609 * 5.0f;
  float _614 = max((1.0f - abs(_609 * 2.5f)), 0.0f);
  float _625 = ((float(((int)(uint)((bool)(_610 > 0.0f))) - ((int)(uint)((bool)(_610 < 0.0f)))) * (1.0f - (_614 * _614))) + 1.0f) * 0.02500000037252903f;
  if (!(_608 <= 0.0533333346247673f)) {
    if (!(_608 >= 0.1599999964237213f)) {
      _634 = (((0.23999999463558197f / _607) + -0.5f) * _625);
    } else {
      _634 = 0.0f;
    }
  } else {
    _634 = _625;
  }
  float _635 = _634 + 1.0f;
  float _636 = _635 * _579;
  float _637 = _635 * _582;
  float _638 = _635 * _585;
  if (!((bool)(_636 == _637) && (bool)(_637 == _638))) {
    float _645 = ((_636 * 2.0f) - _637) - _638;
    float _648 = ((_582 - _585) * 1.7320507764816284f) * _635;
    float _650 = atan(_648 / _645);
    bool _653 = (_645 < 0.0f);
    bool _654 = (_645 == 0.0f);
    bool _655 = (_648 >= 0.0f);
    bool _656 = (_648 < 0.0f);
    _667 = select((_655 && _654), 90.0f, select((_656 && _654), -90.0f, (select((_656 && _653), (_650 + -3.1415927410125732f), select((_655 && _653), (_650 + 3.1415927410125732f), _650)) * 57.2957763671875f)));
  } else {
    _667 = 0.0f;
  }
  float _672 = min(max(select((_667 < 0.0f), (_667 + 360.0f), _667), 0.0f), 360.0f);
  if (_672 < -180.0f) {
    _681 = (_672 + 360.0f);
  } else {
    if (_672 > 180.0f) {
      _681 = (_672 + -360.0f);
    } else {
      _681 = _672;
    }
  }
  float _685 = saturate(1.0f - abs(_681 * 0.014814814552664757f));
  float _689 = (_685 * _685) * (3.0f - (_685 * 2.0f));
  float _695 = ((_689 * _689) * ((_594 * 0.18000000715255737f) * (0.029999999329447746f - _636))) + _636;
  float _705 = max(0.0f, mad(-0.21492856740951538f, _638, mad(-0.2365107536315918f, _637, (_695 * 1.4514392614364624f))));
  float _706 = max(0.0f, mad(-0.09967592358589172f, _638, mad(1.17622971534729f, _637, (_695 * -0.07655377686023712f))));
  float _707 = max(0.0f, mad(0.9977163076400757f, _638, mad(-0.006032449658960104f, _637, (_695 * 0.008316148072481155f))));
  float _708 = dot(float3(_705, _706, _707), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _723 = (FilmBlackClip + 1.0f) - FilmToe;
  float _725 = FilmWhiteClip + 1.0f;
  float _727 = _725 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _745 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _736 = (FilmBlackClip + 0.18000000715255737f) / _723;
    _745 = (-0.7447274923324585f - ((log2(_736 / (2.0f - _736)) * 0.3465735912322998f) * (_723 / FilmSlope)));
  }
  float _748 = ((1.0f - FilmToe) / FilmSlope) - _745;
  float _750 = (FilmShoulder / FilmSlope) - _748;
  float3 lerpColor = lerp(_708, float3(_705, _706, _707), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _574, _575, _576);
  float _896 = lerpColor.r, _897 = lerpColor.g, _898 = lerpColor.b;
#else
  float _754 = log2(lerp(_708, _705, 0.9599999785423279f)) * 0.3010300099849701f;
  float _755 = log2(lerp(_708, _706, 0.9599999785423279f)) * 0.3010300099849701f;
  float _756 = log2(lerp(_708, _707, 0.9599999785423279f)) * 0.3010300099849701f;
  float _760 = FilmSlope * (_754 + _748);
  float _761 = FilmSlope * (_755 + _748);
  float _762 = FilmSlope * (_756 + _748);
  float _763 = _723 * 2.0f;
  float _765 = (FilmSlope * -2.0f) / _723;
  float _766 = _754 - _745;
  float _767 = _755 - _745;
  float _768 = _756 - _745;
  float _787 = _727 * 2.0f;
  float _789 = (FilmSlope * 2.0f) / _727;
  float _814 = select((_754 < _745), ((_763 / (exp2((_766 * 1.4426950216293335f) * _765) + 1.0f)) - FilmBlackClip), _760);
  float _815 = select((_755 < _745), ((_763 / (exp2((_767 * 1.4426950216293335f) * _765) + 1.0f)) - FilmBlackClip), _761);
  float _816 = select((_756 < _745), ((_763 / (exp2((_768 * 1.4426950216293335f) * _765) + 1.0f)) - FilmBlackClip), _762);
  float _823 = _750 - _745;
  float _827 = saturate(_766 / _823);
  float _828 = saturate(_767 / _823);
  float _829 = saturate(_768 / _823);
  bool _830 = (_750 < _745);
  float _834 = select(_830, (1.0f - _827), _827);
  float _835 = select(_830, (1.0f - _828), _828);
  float _836 = select(_830, (1.0f - _829), _829);
  float _855 = (((_834 * _834) * (select((_754 > _750), (_725 - (_787 / (exp2(((_754 - _750) * 1.4426950216293335f) * _789) + 1.0f))), _760) - _814)) * (3.0f - (_834 * 2.0f))) + _814;
  float _856 = (((_835 * _835) * (select((_755 > _750), (_725 - (_787 / (exp2(((_755 - _750) * 1.4426950216293335f) * _789) + 1.0f))), _761) - _815)) * (3.0f - (_835 * 2.0f))) + _815;
  float _857 = (((_836 * _836) * (select((_756 > _750), (_725 - (_787 / (exp2(((_756 - _750) * 1.4426950216293335f) * _789) + 1.0f))), _762) - _816)) * (3.0f - (_836 * 2.0f))) + _816;
  float _858 = dot(float3(_855, _856, _857), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _878 = (ToneCurveAmount * (max(0.0f, (lerp(_858, _855, 0.9300000071525574f))) - _574)) + _574;
  float _879 = (ToneCurveAmount * (max(0.0f, (lerp(_858, _856, 0.9300000071525574f))) - _575)) + _575;
  float _880 = (ToneCurveAmount * (max(0.0f, (lerp(_858, _857, 0.9300000071525574f))) - _576)) + _576;
  float _896 = ((mad(-0.06537103652954102f, _880, mad(1.451815478503704e-06f, _879, (_878 * 1.065374732017517f))) - _878) * BlueCorrection) + _878;
  float _897 = ((mad(-0.20366770029067993f, _880, mad(1.2036634683609009f, _879, (_878 * -2.57161445915699e-07f))) - _879) * BlueCorrection) + _879;
  float _898 = ((mad(0.9999996423721313f, _880, mad(2.0954757928848267e-08f, _879, (_878 * 1.862645149230957e-08f))) - _880) * BlueCorrection) + _880;
#endif

#endif

  // SetTonemappedAP1(_896, _897, _898);

  float _908 = max(0.0f, mad((WorkingColorSpace.FromAP1[0].z), _898, mad((WorkingColorSpace.FromAP1[0].y), _897, ((WorkingColorSpace.FromAP1[0].x) * _896))));
  float _909 = max(0.0f, mad((WorkingColorSpace.FromAP1[1].z), _898, mad((WorkingColorSpace.FromAP1[1].y), _897, ((WorkingColorSpace.FromAP1[1].x) * _896))));
  float _910 = max(0.0f, mad((WorkingColorSpace.FromAP1[2].z), _898, mad((WorkingColorSpace.FromAP1[2].y), _897, ((WorkingColorSpace.FromAP1[2].x) * _896))));
  float _936 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _908)) * _908) + MappingPolynomial.z);
  float _937 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _909)) * _909) + MappingPolynomial.z);
  float _938 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _910)) * _910) + MappingPolynomial.z);
  float _945 = ((OverlayColor.x - _936) * OverlayColor.w) + _936;
  float _946 = ((OverlayColor.y - _937) * OverlayColor.w) + _937;
  float _947 = ((OverlayColor.z - _938) * OverlayColor.w) + _938;

  if (GenerateOutput(_945, _946, _947, SV_Target, is_hdr)) {
    return SV_Target;
  }

  float _948 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _538, mad((WorkingColorSpace.FromAP1[0].y), _536, (_534 * (WorkingColorSpace.FromAP1[0].x))));
  float _949 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _538, mad((WorkingColorSpace.FromAP1[1].y), _536, ((WorkingColorSpace.FromAP1[1].x) * _534)));
  float _950 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _538, mad((WorkingColorSpace.FromAP1[2].y), _536, ((WorkingColorSpace.FromAP1[2].x) * _534)));
  float _957 = ((OverlayColor.x - _948) * OverlayColor.w) + _948;
  float _958 = ((OverlayColor.y - _949) * OverlayColor.w) + _949;
  float _959 = ((OverlayColor.z - _950) * OverlayColor.w) + _950;
  float _971 = exp2(log2(max(0.0f, _945)) * InverseGamma.y);
  float _972 = exp2(log2(max(0.0f, _946)) * InverseGamma.y);
  float _973 = exp2(log2(max(0.0f, _947)) * InverseGamma.y);

  [branch]
  if ((uint)(output_device) == 0) {
    do {
      if ((uint)(WorkingColorSpace.bIsSRGB) == 0) {
        float _996 = mad((WorkingColorSpace.ToAP1[0].z), _973, mad((WorkingColorSpace.ToAP1[0].y), _972, ((WorkingColorSpace.ToAP1[0].x) * _971)));
        float _999 = mad((WorkingColorSpace.ToAP1[1].z), _973, mad((WorkingColorSpace.ToAP1[1].y), _972, ((WorkingColorSpace.ToAP1[1].x) * _971)));
        float _1002 = mad((WorkingColorSpace.ToAP1[2].z), _973, mad((WorkingColorSpace.ToAP1[2].y), _972, ((WorkingColorSpace.ToAP1[2].x) * _971)));
        _1013 = mad(_45, _1002, mad(_44, _999, (_996 * _43)));
        _1014 = mad(_48, _1002, mad(_47, _999, (_996 * _46)));
        _1015 = mad(_51, _1002, mad(_50, _999, (_996 * _49)));
      } else {
        _1013 = _971;
        _1014 = _972;
        _1015 = _973;
      }
      do {
        if (_1013 < 0.0031306699384003878f) {
          _1026 = (_1013 * 12.920000076293945f);
        } else {
          _1026 = (((pow(_1013, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1014 < 0.0031306699384003878f) {
            _1037 = (_1014 * 12.920000076293945f);
          } else {
            _1037 = (((pow(_1014, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1015 < 0.0031306699384003878f) {
            _2593 = _1026;
            _2594 = _1037;
            _2595 = (_1015 * 12.920000076293945f);
          } else {
            _2593 = _1026;
            _2594 = _1037;
            _2595 = (((pow(_1015, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(output_device) == 1) {
      float _1064 = mad((WorkingColorSpace.ToAP1[0].z), _973, mad((WorkingColorSpace.ToAP1[0].y), _972, ((WorkingColorSpace.ToAP1[0].x) * _971)));
      float _1067 = mad((WorkingColorSpace.ToAP1[1].z), _973, mad((WorkingColorSpace.ToAP1[1].y), _972, ((WorkingColorSpace.ToAP1[1].x) * _971)));
      float _1070 = mad((WorkingColorSpace.ToAP1[2].z), _973, mad((WorkingColorSpace.ToAP1[2].y), _972, ((WorkingColorSpace.ToAP1[2].x) * _971)));
      float _1080 = max(6.103519990574569e-05f, mad(_45, _1070, mad(_44, _1067, (_1064 * _43))));
      float _1081 = max(6.103519990574569e-05f, mad(_48, _1070, mad(_47, _1067, (_1064 * _46))));
      float _1082 = max(6.103519990574569e-05f, mad(_51, _1070, mad(_50, _1067, (_1064 * _49))));
      _2593 = min((_1080 * 4.5f), ((exp2(log2(max(_1080, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2594 = min((_1081 * 4.5f), ((exp2(log2(max(_1081, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2595 = min((_1082 * 4.5f), ((exp2(log2(max(_1082, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(output_device) == 3) || (bool)((uint)(output_device) == 5)) {
        _10[0] = ACESCoefsLow_0.x;
        _10[1] = ACESCoefsLow_0.y;
        _10[2] = ACESCoefsLow_0.z;
        _10[3] = ACESCoefsLow_0.w;
        _10[4] = ACESCoefsLow_4;
        _10[5] = ACESCoefsLow_4;
        _11[0] = ACESCoefsHigh_0.x;
        _11[1] = ACESCoefsHigh_0.y;
        _11[2] = ACESCoefsHigh_0.z;
        _11[3] = ACESCoefsHigh_0.w;
        _11[4] = ACESCoefsHigh_4;
        _11[5] = ACESCoefsHigh_4;
        float _1158 = ACESSceneColorMultiplier * _957;
        float _1159 = ACESSceneColorMultiplier * _958;
        float _1160 = ACESSceneColorMultiplier * _959;
        float _1163 = mad((WorkingColorSpace.ToAP0[0].z), _1160, mad((WorkingColorSpace.ToAP0[0].y), _1159, ((WorkingColorSpace.ToAP0[0].x) * _1158)));
        float _1166 = mad((WorkingColorSpace.ToAP0[1].z), _1160, mad((WorkingColorSpace.ToAP0[1].y), _1159, ((WorkingColorSpace.ToAP0[1].x) * _1158)));
        float _1169 = mad((WorkingColorSpace.ToAP0[2].z), _1160, mad((WorkingColorSpace.ToAP0[2].y), _1159, ((WorkingColorSpace.ToAP0[2].x) * _1158)));
        float _1172 = mad(-0.21492856740951538f, _1169, mad(-0.2365107536315918f, _1166, (_1163 * 1.4514392614364624f)));
        float _1175 = mad(-0.09967592358589172f, _1169, mad(1.17622971534729f, _1166, (_1163 * -0.07655377686023712f)));
        float _1178 = mad(0.9977163076400757f, _1169, mad(-0.006032449658960104f, _1166, (_1163 * 0.008316148072481155f)));
        float _1180 = max(_1172, max(_1175, _1178));
        do {
          if (!(_1180 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1163 < 0.0f) || (bool)(_1166 < 0.0f))) || (bool)(_1169 < 0.0f))) {
              float _1190 = abs(_1180);
              float _1191 = (_1180 - _1172) / _1190;
              float _1193 = (_1180 - _1175) / _1190;
              float _1195 = (_1180 - _1178) / _1190;
              do {
                if (!(_1191 < 0.8149999976158142f)) {
                  float _1198 = _1191 + -0.8149999976158142f;
                  _1210 = ((_1198 / exp2(log2(exp2(log2(_1198 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1210 = _1191;
                }
                do {
                  if (!(_1193 < 0.8029999732971191f)) {
                    float _1213 = _1193 + -0.8029999732971191f;
                    _1225 = ((_1213 / exp2(log2(exp2(log2(_1213 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1225 = _1193;
                  }
                  do {
                    if (!(_1195 < 0.8799999952316284f)) {
                      float _1228 = _1195 + -0.8799999952316284f;
                      _1240 = ((_1228 / exp2(log2(exp2(log2(_1228 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1240 = _1195;
                    }
                    _1248 = (_1180 - (_1190 * _1210));
                    _1249 = (_1180 - (_1190 * _1225));
                    _1250 = (_1180 - (_1190 * _1240));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1248 = _1172;
              _1249 = _1175;
              _1250 = _1178;
            }
          } else {
            _1248 = _1172;
            _1249 = _1175;
            _1250 = _1178;
          }
          float _1266 = ((mad(0.16386906802654266f, _1250, mad(0.14067870378494263f, _1249, (_1248 * 0.6954522132873535f))) - _1163) * ACESGamutCompression) + _1163;
          float _1267 = ((mad(0.0955343171954155f, _1250, mad(0.8596711158752441f, _1249, (_1248 * 0.044794563204050064f))) - _1166) * ACESGamutCompression) + _1166;
          float _1268 = ((mad(1.0015007257461548f, _1250, mad(0.004025210160762072f, _1249, (_1248 * -0.005525882821530104f))) - _1169) * ACESGamutCompression) + _1169;
          float _1272 = max(max(_1266, _1267), _1268);
          float _1277 = (max(_1272, 1.000000013351432e-10f) - max(min(min(_1266, _1267), _1268), 1.000000013351432e-10f)) / max(_1272, 0.009999999776482582f);
          float _1290 = ((_1267 + _1266) + _1268) + (sqrt((((_1268 - _1267) * _1268) + ((_1267 - _1266) * _1267)) + ((_1266 - _1268) * _1266)) * 1.75f);
          float _1291 = _1290 * 0.3333333432674408f;
          float _1292 = _1277 + -0.4000000059604645f;
          float _1293 = _1292 * 5.0f;
          float _1297 = max((1.0f - abs(_1292 * 2.5f)), 0.0f);
          float _1308 = ((float(((int)(uint)((bool)(_1293 > 0.0f))) - ((int)(uint)((bool)(_1293 < 0.0f)))) * (1.0f - (_1297 * _1297))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1291 <= 0.0533333346247673f)) {
              if (!(_1291 >= 0.1599999964237213f)) {
                _1317 = (((0.23999999463558197f / _1290) + -0.5f) * _1308);
              } else {
                _1317 = 0.0f;
              }
            } else {
              _1317 = _1308;
            }
            float _1318 = _1317 + 1.0f;
            float _1319 = _1318 * _1266;
            float _1320 = _1318 * _1267;
            float _1321 = _1318 * _1268;
            do {
              if (!((bool)(_1319 == _1320) && (bool)(_1320 == _1321))) {
                float _1328 = ((_1319 * 2.0f) - _1320) - _1321;
                float _1331 = ((_1267 - _1268) * 1.7320507764816284f) * _1318;
                float _1333 = atan(_1331 / _1328);
                bool _1336 = (_1328 < 0.0f);
                bool _1337 = (_1328 == 0.0f);
                bool _1338 = (_1331 >= 0.0f);
                bool _1339 = (_1331 < 0.0f);
                _1350 = select((_1338 && _1337), 90.0f, select((_1339 && _1337), -90.0f, (select((_1339 && _1336), (_1333 + -3.1415927410125732f), select((_1338 && _1336), (_1333 + 3.1415927410125732f), _1333)) * 57.2957763671875f)));
              } else {
                _1350 = 0.0f;
              }
              float _1355 = min(max(select((_1350 < 0.0f), (_1350 + 360.0f), _1350), 0.0f), 360.0f);
              do {
                if (_1355 < -180.0f) {
                  _1364 = (_1355 + 360.0f);
                } else {
                  if (_1355 > 180.0f) {
                    _1364 = (_1355 + -360.0f);
                  } else {
                    _1364 = _1355;
                  }
                }
                do {
                  if ((bool)(_1364 > -67.5f) && (bool)(_1364 < 67.5f)) {
                    float _1370 = (_1364 + 67.5f) * 0.029629629105329514f;
                    int _1371 = int(_1370);
                    float _1373 = _1370 - float(_1371);
                    float _1374 = _1373 * _1373;
                    float _1375 = _1374 * _1373;
                    if (_1371 == 3) {
                      _1403 = (((0.1666666716337204f - (_1373 * 0.5f)) + (_1374 * 0.5f)) - (_1375 * 0.1666666716337204f));
                    } else {
                      if (_1371 == 2) {
                        _1403 = ((0.6666666865348816f - _1374) + (_1375 * 0.5f));
                      } else {
                        if (_1371 == 1) {
                          _1403 = (((_1375 * -0.5f) + 0.1666666716337204f) + ((_1374 + _1373) * 0.5f));
                        } else {
                          _1403 = select((_1371 == 0), (_1375 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1403 = 0.0f;
                  }
                  float _1412 = min(max(((((_1277 * 0.27000001072883606f) * (0.029999999329447746f - _1319)) * _1403) + _1319), 0.0f), 65535.0f);
                  float _1413 = min(max(_1320, 0.0f), 65535.0f);
                  float _1414 = min(max(_1321, 0.0f), 65535.0f);
                  float _1427 = min(max(mad(-0.21492856740951538f, _1414, mad(-0.2365107536315918f, _1413, (_1412 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1428 = min(max(mad(-0.09967592358589172f, _1414, mad(1.17622971534729f, _1413, (_1412 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1429 = min(max(mad(0.9977163076400757f, _1414, mad(-0.006032449658960104f, _1413, (_1412 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1430 = dot(float3(_1427, _1428, _1429), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1441 = log2(max((lerp(_1430, _1427, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1442 = _1441 * 0.3010300099849701f;
                  float _1443 = log2(ACESMinMaxData.x);
                  float _1444 = _1443 * 0.3010300099849701f;
                  do {
                    if (!(!(_1442 <= _1444))) {
                      _1513 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1451 = log2(ACESMidData.x);
                      float _1452 = _1451 * 0.3010300099849701f;
                      if ((bool)(_1442 > _1444) && (bool)(_1442 < _1452)) {
                        float _1460 = ((_1441 - _1443) * 0.9030900001525879f) / ((_1451 - _1443) * 0.3010300099849701f);
                        int _1461 = int(_1460);
                        float _1463 = _1460 - float(_1461);
                        float _1465 = _10[_1461];
                        float _1468 = _10[(_1461 + 1)];
                        float _1473 = _1465 * 0.5f;
                        _1513 = dot(float3((_1463 * _1463), _1463, 1.0f), float3(mad((_10[(_1461 + 2)]), 0.5f, mad(_1468, -1.0f, _1473)), (_1468 - _1465), mad(_1468, 0.5f, _1473)));
                      } else {
                        do {
                          if (!(!(_1442 >= _1452))) {
                            float _1482 = log2(ACESMinMaxData.z);
                            if (_1442 < (_1482 * 0.3010300099849701f)) {
                              float _1490 = ((_1441 - _1451) * 0.9030900001525879f) / ((_1482 - _1451) * 0.3010300099849701f);
                              int _1491 = int(_1490);
                              float _1493 = _1490 - float(_1491);
                              float _1495 = _11[_1491];
                              float _1498 = _11[(_1491 + 1)];
                              float _1503 = _1495 * 0.5f;
                              _1513 = dot(float3((_1493 * _1493), _1493, 1.0f), float3(mad((_11[(_1491 + 2)]), 0.5f, mad(_1498, -1.0f, _1503)), (_1498 - _1495), mad(_1498, 0.5f, _1503)));
                              break;
                            }
                          }
                          _1513 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1517 = log2(max((lerp(_1430, _1428, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1518 = _1517 * 0.3010300099849701f;
                    do {
                      if (!(!(_1518 <= _1444))) {
                        _1587 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1525 = log2(ACESMidData.x);
                        float _1526 = _1525 * 0.3010300099849701f;
                        if ((bool)(_1518 > _1444) && (bool)(_1518 < _1526)) {
                          float _1534 = ((_1517 - _1443) * 0.9030900001525879f) / ((_1525 - _1443) * 0.3010300099849701f);
                          int _1535 = int(_1534);
                          float _1537 = _1534 - float(_1535);
                          float _1539 = _10[_1535];
                          float _1542 = _10[(_1535 + 1)];
                          float _1547 = _1539 * 0.5f;
                          _1587 = dot(float3((_1537 * _1537), _1537, 1.0f), float3(mad((_10[(_1535 + 2)]), 0.5f, mad(_1542, -1.0f, _1547)), (_1542 - _1539), mad(_1542, 0.5f, _1547)));
                        } else {
                          do {
                            if (!(!(_1518 >= _1526))) {
                              float _1556 = log2(ACESMinMaxData.z);
                              if (_1518 < (_1556 * 0.3010300099849701f)) {
                                float _1564 = ((_1517 - _1525) * 0.9030900001525879f) / ((_1556 - _1525) * 0.3010300099849701f);
                                int _1565 = int(_1564);
                                float _1567 = _1564 - float(_1565);
                                float _1569 = _11[_1565];
                                float _1572 = _11[(_1565 + 1)];
                                float _1577 = _1569 * 0.5f;
                                _1587 = dot(float3((_1567 * _1567), _1567, 1.0f), float3(mad((_11[(_1565 + 2)]), 0.5f, mad(_1572, -1.0f, _1577)), (_1572 - _1569), mad(_1572, 0.5f, _1577)));
                                break;
                              }
                            }
                            _1587 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1591 = log2(max((lerp(_1430, _1429, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1592 = _1591 * 0.3010300099849701f;
                      do {
                        if (!(!(_1592 <= _1444))) {
                          _1661 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1599 = log2(ACESMidData.x);
                          float _1600 = _1599 * 0.3010300099849701f;
                          if ((bool)(_1592 > _1444) && (bool)(_1592 < _1600)) {
                            float _1608 = ((_1591 - _1443) * 0.9030900001525879f) / ((_1599 - _1443) * 0.3010300099849701f);
                            int _1609 = int(_1608);
                            float _1611 = _1608 - float(_1609);
                            float _1613 = _10[_1609];
                            float _1616 = _10[(_1609 + 1)];
                            float _1621 = _1613 * 0.5f;
                            _1661 = dot(float3((_1611 * _1611), _1611, 1.0f), float3(mad((_10[(_1609 + 2)]), 0.5f, mad(_1616, -1.0f, _1621)), (_1616 - _1613), mad(_1616, 0.5f, _1621)));
                          } else {
                            do {
                              if (!(!(_1592 >= _1600))) {
                                float _1630 = log2(ACESMinMaxData.z);
                                if (_1592 < (_1630 * 0.3010300099849701f)) {
                                  float _1638 = ((_1591 - _1599) * 0.9030900001525879f) / ((_1630 - _1599) * 0.3010300099849701f);
                                  int _1639 = int(_1638);
                                  float _1641 = _1638 - float(_1639);
                                  float _1643 = _11[_1639];
                                  float _1646 = _11[(_1639 + 1)];
                                  float _1651 = _1643 * 0.5f;
                                  _1661 = dot(float3((_1641 * _1641), _1641, 1.0f), float3(mad((_11[(_1639 + 2)]), 0.5f, mad(_1646, -1.0f, _1651)), (_1646 - _1643), mad(_1646, 0.5f, _1651)));
                                  break;
                                }
                              }
                              _1661 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1665 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1666 = (exp2(_1513 * 3.321928024291992f) - ACESMinMaxData.y) / _1665;
                        float _1668 = (exp2(_1587 * 3.321928024291992f) - ACESMinMaxData.y) / _1665;
                        float _1670 = (exp2(_1661 * 3.321928024291992f) - ACESMinMaxData.y) / _1665;
                        float _1673 = mad(0.15618768334388733f, _1670, mad(0.13400420546531677f, _1668, (_1666 * 0.6624541878700256f)));
                        float _1676 = mad(0.053689517080783844f, _1670, mad(0.6740817427635193f, _1668, (_1666 * 0.2722287178039551f)));
                        float _1679 = mad(1.0103391408920288f, _1670, mad(0.00406073359772563f, _1668, (_1666 * -0.005574649665504694f)));
                        float _1692 = min(max(mad(-0.23642469942569733f, _1679, mad(-0.32480329275131226f, _1676, (_1673 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1693 = min(max(mad(0.016756348311901093f, _1679, mad(1.6153316497802734f, _1676, (_1673 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1694 = min(max(mad(0.9883948564529419f, _1679, mad(-0.008284442126750946f, _1676, (_1673 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1697 = mad(0.15618768334388733f, _1694, mad(0.13400420546531677f, _1693, (_1692 * 0.6624541878700256f)));
                        float _1700 = mad(0.053689517080783844f, _1694, mad(0.6740817427635193f, _1693, (_1692 * 0.2722287178039551f)));
                        float _1703 = mad(1.0103391408920288f, _1694, mad(0.00406073359772563f, _1693, (_1692 * -0.005574649665504694f)));
                        float _1725 = min(max((min(max(mad(-0.23642469942569733f, _1703, mad(-0.32480329275131226f, _1700, (_1697 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1726 = min(max((min(max(mad(0.016756348311901093f, _1703, mad(1.6153316497802734f, _1700, (_1697 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1727 = min(max((min(max(mad(0.9883948564529419f, _1703, mad(-0.008284442126750946f, _1700, (_1697 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(output_device) == 5)) {
                            _1740 = mad(_45, _1727, mad(_44, _1726, (_1725 * _43)));
                            _1741 = mad(_48, _1727, mad(_47, _1726, (_1725 * _46)));
                            _1742 = mad(_51, _1727, mad(_50, _1726, (_1725 * _49)));
                          } else {
                            _1740 = _1725;
                            _1741 = _1726;
                            _1742 = _1727;
                          }
                          float _1752 = exp2(log2(_1740 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1753 = exp2(log2(_1741 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1754 = exp2(log2(_1742 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2593 = exp2(log2((1.0f / ((_1752 * 18.6875f) + 1.0f)) * ((_1752 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2594 = exp2(log2((1.0f / ((_1753 * 18.6875f) + 1.0f)) * ((_1753 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2595 = exp2(log2((1.0f / ((_1754 * 18.6875f) + 1.0f)) * ((_1754 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
        if (((uint)(output_device) & -3) == 4) {
          _8[0] = ACESCoefsLow_0.x;
          _8[1] = ACESCoefsLow_0.y;
          _8[2] = ACESCoefsLow_0.z;
          _8[3] = ACESCoefsLow_0.w;
          _8[4] = ACESCoefsLow_4;
          _8[5] = ACESCoefsLow_4;
          _9[0] = ACESCoefsHigh_0.x;
          _9[1] = ACESCoefsHigh_0.y;
          _9[2] = ACESCoefsHigh_0.z;
          _9[3] = ACESCoefsHigh_0.w;
          _9[4] = ACESCoefsHigh_4;
          _9[5] = ACESCoefsHigh_4;
          float _1832 = ACESSceneColorMultiplier * _957;
          float _1833 = ACESSceneColorMultiplier * _958;
          float _1834 = ACESSceneColorMultiplier * _959;
          float _1837 = mad((WorkingColorSpace.ToAP0[0].z), _1834, mad((WorkingColorSpace.ToAP0[0].y), _1833, ((WorkingColorSpace.ToAP0[0].x) * _1832)));
          float _1840 = mad((WorkingColorSpace.ToAP0[1].z), _1834, mad((WorkingColorSpace.ToAP0[1].y), _1833, ((WorkingColorSpace.ToAP0[1].x) * _1832)));
          float _1843 = mad((WorkingColorSpace.ToAP0[2].z), _1834, mad((WorkingColorSpace.ToAP0[2].y), _1833, ((WorkingColorSpace.ToAP0[2].x) * _1832)));
          float _1846 = mad(-0.21492856740951538f, _1843, mad(-0.2365107536315918f, _1840, (_1837 * 1.4514392614364624f)));
          float _1849 = mad(-0.09967592358589172f, _1843, mad(1.17622971534729f, _1840, (_1837 * -0.07655377686023712f)));
          float _1852 = mad(0.9977163076400757f, _1843, mad(-0.006032449658960104f, _1840, (_1837 * 0.008316148072481155f)));
          float _1854 = max(_1846, max(_1849, _1852));
          do {
            if (!(_1854 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1837 < 0.0f) || (bool)(_1840 < 0.0f))) || (bool)(_1843 < 0.0f))) {
                float _1864 = abs(_1854);
                float _1865 = (_1854 - _1846) / _1864;
                float _1867 = (_1854 - _1849) / _1864;
                float _1869 = (_1854 - _1852) / _1864;
                do {
                  if (!(_1865 < 0.8149999976158142f)) {
                    float _1872 = _1865 + -0.8149999976158142f;
                    _1884 = ((_1872 / exp2(log2(exp2(log2(_1872 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _1884 = _1865;
                  }
                  do {
                    if (!(_1867 < 0.8029999732971191f)) {
                      float _1887 = _1867 + -0.8029999732971191f;
                      _1899 = ((_1887 / exp2(log2(exp2(log2(_1887 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _1899 = _1867;
                    }
                    do {
                      if (!(_1869 < 0.8799999952316284f)) {
                        float _1902 = _1869 + -0.8799999952316284f;
                        _1914 = ((_1902 / exp2(log2(exp2(log2(_1902 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _1914 = _1869;
                      }
                      _1922 = (_1854 - (_1864 * _1884));
                      _1923 = (_1854 - (_1864 * _1899));
                      _1924 = (_1854 - (_1864 * _1914));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _1922 = _1846;
                _1923 = _1849;
                _1924 = _1852;
              }
            } else {
              _1922 = _1846;
              _1923 = _1849;
              _1924 = _1852;
            }
            float _1940 = ((mad(0.16386906802654266f, _1924, mad(0.14067870378494263f, _1923, (_1922 * 0.6954522132873535f))) - _1837) * ACESGamutCompression) + _1837;
            float _1941 = ((mad(0.0955343171954155f, _1924, mad(0.8596711158752441f, _1923, (_1922 * 0.044794563204050064f))) - _1840) * ACESGamutCompression) + _1840;
            float _1942 = ((mad(1.0015007257461548f, _1924, mad(0.004025210160762072f, _1923, (_1922 * -0.005525882821530104f))) - _1843) * ACESGamutCompression) + _1843;
            float _1946 = max(max(_1940, _1941), _1942);
            float _1951 = (max(_1946, 1.000000013351432e-10f) - max(min(min(_1940, _1941), _1942), 1.000000013351432e-10f)) / max(_1946, 0.009999999776482582f);
            float _1964 = ((_1941 + _1940) + _1942) + (sqrt((((_1942 - _1941) * _1942) + ((_1941 - _1940) * _1941)) + ((_1940 - _1942) * _1940)) * 1.75f);
            float _1965 = _1964 * 0.3333333432674408f;
            float _1966 = _1951 + -0.4000000059604645f;
            float _1967 = _1966 * 5.0f;
            float _1971 = max((1.0f - abs(_1966 * 2.5f)), 0.0f);
            float _1982 = ((float(((int)(uint)((bool)(_1967 > 0.0f))) - ((int)(uint)((bool)(_1967 < 0.0f)))) * (1.0f - (_1971 * _1971))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_1965 <= 0.0533333346247673f)) {
                if (!(_1965 >= 0.1599999964237213f)) {
                  _1991 = (((0.23999999463558197f / _1964) + -0.5f) * _1982);
                } else {
                  _1991 = 0.0f;
                }
              } else {
                _1991 = _1982;
              }
              float _1992 = _1991 + 1.0f;
              float _1993 = _1992 * _1940;
              float _1994 = _1992 * _1941;
              float _1995 = _1992 * _1942;
              do {
                if (!((bool)(_1993 == _1994) && (bool)(_1994 == _1995))) {
                  float _2002 = ((_1993 * 2.0f) - _1994) - _1995;
                  float _2005 = ((_1941 - _1942) * 1.7320507764816284f) * _1992;
                  float _2007 = atan(_2005 / _2002);
                  bool _2010 = (_2002 < 0.0f);
                  bool _2011 = (_2002 == 0.0f);
                  bool _2012 = (_2005 >= 0.0f);
                  bool _2013 = (_2005 < 0.0f);
                  _2024 = select((_2012 && _2011), 90.0f, select((_2013 && _2011), -90.0f, (select((_2013 && _2010), (_2007 + -3.1415927410125732f), select((_2012 && _2010), (_2007 + 3.1415927410125732f), _2007)) * 57.2957763671875f)));
                } else {
                  _2024 = 0.0f;
                }
                float _2029 = min(max(select((_2024 < 0.0f), (_2024 + 360.0f), _2024), 0.0f), 360.0f);
                do {
                  if (_2029 < -180.0f) {
                    _2038 = (_2029 + 360.0f);
                  } else {
                    if (_2029 > 180.0f) {
                      _2038 = (_2029 + -360.0f);
                    } else {
                      _2038 = _2029;
                    }
                  }
                  do {
                    if ((bool)(_2038 > -67.5f) && (bool)(_2038 < 67.5f)) {
                      float _2044 = (_2038 + 67.5f) * 0.029629629105329514f;
                      int _2045 = int(_2044);
                      float _2047 = _2044 - float(_2045);
                      float _2048 = _2047 * _2047;
                      float _2049 = _2048 * _2047;
                      if (_2045 == 3) {
                        _2077 = (((0.1666666716337204f - (_2047 * 0.5f)) + (_2048 * 0.5f)) - (_2049 * 0.1666666716337204f));
                      } else {
                        if (_2045 == 2) {
                          _2077 = ((0.6666666865348816f - _2048) + (_2049 * 0.5f));
                        } else {
                          if (_2045 == 1) {
                            _2077 = (((_2049 * -0.5f) + 0.1666666716337204f) + ((_2048 + _2047) * 0.5f));
                          } else {
                            _2077 = select((_2045 == 0), (_2049 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2077 = 0.0f;
                    }
                    float _2086 = min(max(((((_1951 * 0.27000001072883606f) * (0.029999999329447746f - _1993)) * _2077) + _1993), 0.0f), 65535.0f);
                    float _2087 = min(max(_1994, 0.0f), 65535.0f);
                    float _2088 = min(max(_1995, 0.0f), 65535.0f);
                    float _2101 = min(max(mad(-0.21492856740951538f, _2088, mad(-0.2365107536315918f, _2087, (_2086 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2102 = min(max(mad(-0.09967592358589172f, _2088, mad(1.17622971534729f, _2087, (_2086 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2103 = min(max(mad(0.9977163076400757f, _2088, mad(-0.006032449658960104f, _2087, (_2086 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2104 = dot(float3(_2101, _2102, _2103), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2115 = log2(max((lerp(_2104, _2101, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2116 = _2115 * 0.3010300099849701f;
                    float _2117 = log2(ACESMinMaxData.x);
                    float _2118 = _2117 * 0.3010300099849701f;
                    do {
                      if (!(!(_2116 <= _2118))) {
                        _2187 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2125 = log2(ACESMidData.x);
                        float _2126 = _2125 * 0.3010300099849701f;
                        if ((bool)(_2116 > _2118) && (bool)(_2116 < _2126)) {
                          float _2134 = ((_2115 - _2117) * 0.9030900001525879f) / ((_2125 - _2117) * 0.3010300099849701f);
                          int _2135 = int(_2134);
                          float _2137 = _2134 - float(_2135);
                          float _2139 = _8[_2135];
                          float _2142 = _8[(_2135 + 1)];
                          float _2147 = _2139 * 0.5f;
                          _2187 = dot(float3((_2137 * _2137), _2137, 1.0f), float3(mad((_8[(_2135 + 2)]), 0.5f, mad(_2142, -1.0f, _2147)), (_2142 - _2139), mad(_2142, 0.5f, _2147)));
                        } else {
                          do {
                            if (!(!(_2116 >= _2126))) {
                              float _2156 = log2(ACESMinMaxData.z);
                              if (_2116 < (_2156 * 0.3010300099849701f)) {
                                float _2164 = ((_2115 - _2125) * 0.9030900001525879f) / ((_2156 - _2125) * 0.3010300099849701f);
                                int _2165 = int(_2164);
                                float _2167 = _2164 - float(_2165);
                                float _2169 = _9[_2165];
                                float _2172 = _9[(_2165 + 1)];
                                float _2177 = _2169 * 0.5f;
                                _2187 = dot(float3((_2167 * _2167), _2167, 1.0f), float3(mad((_9[(_2165 + 2)]), 0.5f, mad(_2172, -1.0f, _2177)), (_2172 - _2169), mad(_2172, 0.5f, _2177)));
                                break;
                              }
                            }
                            _2187 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2191 = log2(max((lerp(_2104, _2102, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2192 = _2191 * 0.3010300099849701f;
                      do {
                        if (!(!(_2192 <= _2118))) {
                          _2261 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2199 = log2(ACESMidData.x);
                          float _2200 = _2199 * 0.3010300099849701f;
                          if ((bool)(_2192 > _2118) && (bool)(_2192 < _2200)) {
                            float _2208 = ((_2191 - _2117) * 0.9030900001525879f) / ((_2199 - _2117) * 0.3010300099849701f);
                            int _2209 = int(_2208);
                            float _2211 = _2208 - float(_2209);
                            float _2213 = _8[_2209];
                            float _2216 = _8[(_2209 + 1)];
                            float _2221 = _2213 * 0.5f;
                            _2261 = dot(float3((_2211 * _2211), _2211, 1.0f), float3(mad((_8[(_2209 + 2)]), 0.5f, mad(_2216, -1.0f, _2221)), (_2216 - _2213), mad(_2216, 0.5f, _2221)));
                          } else {
                            do {
                              if (!(!(_2192 >= _2200))) {
                                float _2230 = log2(ACESMinMaxData.z);
                                if (_2192 < (_2230 * 0.3010300099849701f)) {
                                  float _2238 = ((_2191 - _2199) * 0.9030900001525879f) / ((_2230 - _2199) * 0.3010300099849701f);
                                  int _2239 = int(_2238);
                                  float _2241 = _2238 - float(_2239);
                                  float _2243 = _9[_2239];
                                  float _2246 = _9[(_2239 + 1)];
                                  float _2251 = _2243 * 0.5f;
                                  _2261 = dot(float3((_2241 * _2241), _2241, 1.0f), float3(mad((_9[(_2239 + 2)]), 0.5f, mad(_2246, -1.0f, _2251)), (_2246 - _2243), mad(_2246, 0.5f, _2251)));
                                  break;
                                }
                              }
                              _2261 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2265 = log2(max((lerp(_2104, _2103, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2266 = _2265 * 0.3010300099849701f;
                        do {
                          if (!(!(_2266 <= _2118))) {
                            _2335 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2273 = log2(ACESMidData.x);
                            float _2274 = _2273 * 0.3010300099849701f;
                            if ((bool)(_2266 > _2118) && (bool)(_2266 < _2274)) {
                              float _2282 = ((_2265 - _2117) * 0.9030900001525879f) / ((_2273 - _2117) * 0.3010300099849701f);
                              int _2283 = int(_2282);
                              float _2285 = _2282 - float(_2283);
                              float _2287 = _8[_2283];
                              float _2290 = _8[(_2283 + 1)];
                              float _2295 = _2287 * 0.5f;
                              _2335 = dot(float3((_2285 * _2285), _2285, 1.0f), float3(mad((_8[(_2283 + 2)]), 0.5f, mad(_2290, -1.0f, _2295)), (_2290 - _2287), mad(_2290, 0.5f, _2295)));
                            } else {
                              do {
                                if (!(!(_2266 >= _2274))) {
                                  float _2304 = log2(ACESMinMaxData.z);
                                  if (_2266 < (_2304 * 0.3010300099849701f)) {
                                    float _2312 = ((_2265 - _2273) * 0.9030900001525879f) / ((_2304 - _2273) * 0.3010300099849701f);
                                    int _2313 = int(_2312);
                                    float _2315 = _2312 - float(_2313);
                                    float _2317 = _9[_2313];
                                    float _2320 = _9[(_2313 + 1)];
                                    float _2325 = _2317 * 0.5f;
                                    _2335 = dot(float3((_2315 * _2315), _2315, 1.0f), float3(mad((_9[(_2313 + 2)]), 0.5f, mad(_2320, -1.0f, _2325)), (_2320 - _2317), mad(_2320, 0.5f, _2325)));
                                    break;
                                  }
                                }
                                _2335 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2339 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2340 = (exp2(_2187 * 3.321928024291992f) - ACESMinMaxData.y) / _2339;
                          float _2342 = (exp2(_2261 * 3.321928024291992f) - ACESMinMaxData.y) / _2339;
                          float _2344 = (exp2(_2335 * 3.321928024291992f) - ACESMinMaxData.y) / _2339;
                          float _2347 = mad(0.15618768334388733f, _2344, mad(0.13400420546531677f, _2342, (_2340 * 0.6624541878700256f)));
                          float _2350 = mad(0.053689517080783844f, _2344, mad(0.6740817427635193f, _2342, (_2340 * 0.2722287178039551f)));
                          float _2353 = mad(1.0103391408920288f, _2344, mad(0.00406073359772563f, _2342, (_2340 * -0.005574649665504694f)));
                          float _2366 = min(max(mad(-0.23642469942569733f, _2353, mad(-0.32480329275131226f, _2350, (_2347 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2367 = min(max(mad(0.016756348311901093f, _2353, mad(1.6153316497802734f, _2350, (_2347 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2368 = min(max(mad(0.9883948564529419f, _2353, mad(-0.008284442126750946f, _2350, (_2347 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2371 = mad(0.15618768334388733f, _2368, mad(0.13400420546531677f, _2367, (_2366 * 0.6624541878700256f)));
                          float _2374 = mad(0.053689517080783844f, _2368, mad(0.6740817427635193f, _2367, (_2366 * 0.2722287178039551f)));
                          float _2377 = mad(1.0103391408920288f, _2368, mad(0.00406073359772563f, _2367, (_2366 * -0.005574649665504694f)));
                          float _2399 = min(max((min(max(mad(-0.23642469942569733f, _2377, mad(-0.32480329275131226f, _2374, (_2371 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2400 = min(max((min(max(mad(0.016756348311901093f, _2377, mad(1.6153316497802734f, _2374, (_2371 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2401 = min(max((min(max(mad(0.9883948564529419f, _2377, mad(-0.008284442126750946f, _2374, (_2371 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!((uint)(output_device) == 6)) {
                              _2414 = mad(_45, _2401, mad(_44, _2400, (_2399 * _43)));
                              _2415 = mad(_48, _2401, mad(_47, _2400, (_2399 * _46)));
                              _2416 = mad(_51, _2401, mad(_50, _2400, (_2399 * _49)));
                            } else {
                              _2414 = _2399;
                              _2415 = _2400;
                              _2416 = _2401;
                            }
                            float _2426 = exp2(log2(_2414 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2427 = exp2(log2(_2415 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2428 = exp2(log2(_2416 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2593 = exp2(log2((1.0f / ((_2426 * 18.6875f) + 1.0f)) * ((_2426 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2594 = exp2(log2((1.0f / ((_2427 * 18.6875f) + 1.0f)) * ((_2427 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2595 = exp2(log2((1.0f / ((_2428 * 18.6875f) + 1.0f)) * ((_2428 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          if ((uint)(output_device) == 7) {
            float _2473 = mad((WorkingColorSpace.ToAP1[0].z), _959, mad((WorkingColorSpace.ToAP1[0].y), _958, ((WorkingColorSpace.ToAP1[0].x) * _957)));
            float _2476 = mad((WorkingColorSpace.ToAP1[1].z), _959, mad((WorkingColorSpace.ToAP1[1].y), _958, ((WorkingColorSpace.ToAP1[1].x) * _957)));
            float _2479 = mad((WorkingColorSpace.ToAP1[2].z), _959, mad((WorkingColorSpace.ToAP1[2].y), _958, ((WorkingColorSpace.ToAP1[2].x) * _957)));
            float _2498 = exp2(log2(mad(_45, _2479, mad(_44, _2476, (_2473 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2499 = exp2(log2(mad(_48, _2479, mad(_47, _2476, (_2473 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2500 = exp2(log2(mad(_51, _2479, mad(_50, _2476, (_2473 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2593 = exp2(log2((1.0f / ((_2498 * 18.6875f) + 1.0f)) * ((_2498 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2594 = exp2(log2((1.0f / ((_2499 * 18.6875f) + 1.0f)) * ((_2499 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2595 = exp2(log2((1.0f / ((_2500 * 18.6875f) + 1.0f)) * ((_2500 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(output_device) == 8)) {
              if ((uint)(output_device) == 9) {
                float _2547 = mad((WorkingColorSpace.ToAP1[0].z), _947, mad((WorkingColorSpace.ToAP1[0].y), _946, ((WorkingColorSpace.ToAP1[0].x) * _945)));
                float _2550 = mad((WorkingColorSpace.ToAP1[1].z), _947, mad((WorkingColorSpace.ToAP1[1].y), _946, ((WorkingColorSpace.ToAP1[1].x) * _945)));
                float _2553 = mad((WorkingColorSpace.ToAP1[2].z), _947, mad((WorkingColorSpace.ToAP1[2].y), _946, ((WorkingColorSpace.ToAP1[2].x) * _945)));
                _2593 = mad(_45, _2553, mad(_44, _2550, (_2547 * _43)));
                _2594 = mad(_48, _2553, mad(_47, _2550, (_2547 * _46)));
                _2595 = mad(_51, _2553, mad(_50, _2550, (_2547 * _49)));
              } else {
                float _2566 = mad((WorkingColorSpace.ToAP1[0].z), _973, mad((WorkingColorSpace.ToAP1[0].y), _972, ((WorkingColorSpace.ToAP1[0].x) * _971)));
                float _2569 = mad((WorkingColorSpace.ToAP1[1].z), _973, mad((WorkingColorSpace.ToAP1[1].y), _972, ((WorkingColorSpace.ToAP1[1].x) * _971)));
                float _2572 = mad((WorkingColorSpace.ToAP1[2].z), _973, mad((WorkingColorSpace.ToAP1[2].y), _972, ((WorkingColorSpace.ToAP1[2].x) * _971)));
                _2593 = exp2(log2(mad(_45, _2572, mad(_44, _2569, (_2566 * _43)))) * InverseGamma.z);
                _2594 = exp2(log2(mad(_48, _2572, mad(_47, _2569, (_2566 * _46)))) * InverseGamma.z);
                _2595 = exp2(log2(mad(_51, _2572, mad(_50, _2569, (_2566 * _49)))) * InverseGamma.z);
              }
            } else {
              _2593 = _957;
              _2594 = _958;
              _2595 = _959;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2593 * 0.9523810148239136f);
  SV_Target.y = (_2594 * 0.9523810148239136f);
  SV_Target.z = (_2595 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

#include "../filmiclutbuilder.hlsli"

cbuffer UniformBufferConstants_WorkingColorSpace : register(b1) {
  float4 WorkingColorSpace_ToXYZ[4] : packoffset(c000.x);
  float4 WorkingColorSpace_FromXYZ[4] : packoffset(c004.x);
  float4 WorkingColorSpace_ToAP1[4] : packoffset(c008.x);
  float4 WorkingColorSpace_FromAP1[4] : packoffset(c012.x);
  float4 WorkingColorSpace_ToAP0[4] : packoffset(c016.x);
  uint WorkingColorSpace_bIsSRGB : packoffset(c020.x);
};

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;

  float4 output_color;

  float4 SV_Target;
  float _8[6];
  float _9[6];
  float _10[6];
  float _11[6];
  float _14 = 0.5f / LUTSize;
  float _19 = LUTSize + -1.0f;
  float _20 = (LUTSize * (TEXCOORD.x - _14)) / _19;
  float _21 = (LUTSize * (TEXCOORD.y - _14)) / _19;
  float _23 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _19;
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
  float _1217;
  float _1250;
  float _1264;
  float _1303;
  float _1413;
  float _1487;
  float _1561;
  float _1640;
  float _1641;
  float _1642;
  float _1791;
  float _1824;
  float _1838;
  float _1877;
  float _1987;
  float _2061;
  float _2135;
  float _2214;
  float _2215;
  float _2216;
  float _2393;
  float _2394;
  float _2395;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _32 = (output_gamut == 4);
        _43 = select(_32, 1.0f, 1.7050515413284302f);
        _44 = select(_32, 0.0f, -0.6217905879020691f);
        _45 = select(_32, 0.0f, -0.0832584798336029f);
        _46 = select(_32, 0.0f, -0.13025718927383423f);
        _47 = select(_32, 1.0f, 1.1408027410507202f);
        _48 = select(_32, 0.0f, -0.010548528283834457f);
        _49 = select(_32, 0.0f, -0.024003278464078903f);
        _50 = select(_32, 0.0f, -0.1289687603712082f);
        _51 = select(_32, 1.0f, 1.152971863746643f);
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
      _43 = 1.02579927444458f;
      _44 = -0.020052503794431686f;
      _45 = -0.0057713985443115234f;
      _46 = -0.0022350111976265907f;
      _47 = 1.0045825242996216f;
      _48 = -0.002352306619286537f;
      _49 = -0.005014004185795784f;
      _50 = -0.025293385609984398f;
      _51 = 1.0304402112960815f;
    }
  } else {
    _43 = 1.379158854484558f;
    _44 = -0.3088507056236267f;
    _45 = -0.07034677267074585f;
    _46 = -0.06933528929948807f;
    _47 = 1.0822921991348267f;
    _48 = -0.012962047010660172f;
    _49 = -0.002159259282052517f;
    _50 = -0.045465391129255295f;
    _51 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
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

  float _126 = mad((WorkingColorSpace_ToAP1[0].z), _111, mad((WorkingColorSpace_ToAP1[0].y), _110, ((WorkingColorSpace_ToAP1[0].x) * _109)));
  float _129 = mad((WorkingColorSpace_ToAP1[1].z), _111, mad((WorkingColorSpace_ToAP1[1].y), _110, ((WorkingColorSpace_ToAP1[1].x) * _109)));
  float _132 = mad((WorkingColorSpace_ToAP1[2].z), _111, mad((WorkingColorSpace_ToAP1[2].y), _110, ((WorkingColorSpace_ToAP1[2].x) * _109)));
  float _133 = dot(float3(_126, _129, _132), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _137 = (_126 / _133) + -1.0f;
  float _138 = (_129 / _133) + -1.0f;
  float _139 = (_132 / _133) + -1.0f;
  float _151 = (1.0f - exp2(((_133 * _133) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_137, _138, _139), float3(_137, _138, _139)) * -4.0f));
  float _167 = ((mad(-0.06368283927440643f, _132, mad(-0.32929131388664246f, _129, (_126 * 1.370412826538086f))) - _126) * _151) + _126;
  float _168 = ((mad(-0.010861567221581936f, _132, mad(1.0970908403396606f, _129, (_126 * -0.08343426138162613f))) - _129) * _151) + _129;
  float _169 = ((mad(1.203694462776184f, _132, mad(-0.09862564504146576f, _129, (_126 * -0.02579325996339321f))) - _132) * _151) + _132;
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
  float _625 = ((float((int)(((int)(uint)((bool)(_610 > 0.0f))) - ((int)(uint)((bool)(_610 < 0.0f))))) * (1.0f - (_614 * _614))) + 1.0f) * 0.02500000037252903f;
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
  // AP1_RGB2Y
  float _708 = dot(float3(_705, _706, _707), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _754 = lerp(_708, _705, 0.9599999785423279f);
  float _755 = lerp(_708, _706, 0.9599999785423279f);
  float _756 = lerp(_708, _707, 0.9599999785423279f);
  // END RRT
#if 1
  ApplyFilmicToneMap(_754, _755, _756, _574, _575, _576);
  float _896 = _754, _897 = _755, _898 = _756;

#else

  _754 = log2(_754) * 0.3010300099849701f;
  _755 = log2(_755) * 0.3010300099849701f;
  _756 = log2(_756) * 0.3010300099849701f;
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
  // moved lines up
  // float _754 = log2(lerp(_708, _705, 0.9599999785423279f)) * 0.3010300099849701f;
  // float _755 = log2(lerp(_708, _706, 0.9599999785423279f)) * 0.3010300099849701f;
  // float _756 = log2(lerp(_708, _707, 0.9599999785423279f)) * 0.3010300099849701f;
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

  float _908 = mad((WorkingColorSpace_FromAP1[0].z), _898, mad((WorkingColorSpace_FromAP1[0].y), _897, ((WorkingColorSpace_FromAP1[0].x) * _896)));
  float _909 = mad((WorkingColorSpace_FromAP1[1].z), _898, mad((WorkingColorSpace_FromAP1[1].y), _897, ((WorkingColorSpace_FromAP1[1].x) * _896)));
  float _910 = mad((WorkingColorSpace_FromAP1[2].z), _898, mad((WorkingColorSpace_FromAP1[2].y), _897, ((WorkingColorSpace_FromAP1[2].x) * _896)));
  //
  // _908 = max(0.0f, _908);
  // _909 = max(0.0f, _909);
  // _910 = max(0.0f, _910);

  float _936 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _908)) * _908) + MappingPolynomial.z);
  float _937 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _909)) * _909) + MappingPolynomial.z);
  float _938 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _910)) * _910) + MappingPolynomial.z);
  float _945 = ((OverlayColor.x - _936) * OverlayColor.w) + _936;
  float _946 = ((OverlayColor.y - _937) * OverlayColor.w) + _937;
  float _947 = ((OverlayColor.z - _938) * OverlayColor.w) + _938;

  if (GenerateOutput(_945, _946, _947, SV_Target)) {
    return SV_Target;
  }

  // skipped lines
  float _948 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _538, mad((WorkingColorSpace_FromAP1[0].y), _536, (_534 * (WorkingColorSpace_FromAP1[0].x))));
  float _949 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _538, mad((WorkingColorSpace_FromAP1[1].y), _536, ((WorkingColorSpace_FromAP1[1].x) * _534)));
  float _950 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _538, mad((WorkingColorSpace_FromAP1[2].y), _536, ((WorkingColorSpace_FromAP1[2].x) * _534)));
  float _957 = ((OverlayColor.x - _948) * OverlayColor.w) + _948;
  float _958 = ((OverlayColor.y - _949) * OverlayColor.w) + _949;
  float _959 = ((OverlayColor.z - _950) * OverlayColor.w) + _950;

  float _971 = exp2(log2(max(0.0f, _945)) * InverseGamma.y);
  float _972 = exp2(log2(max(0.0f, _946)) * InverseGamma.y);
  float _973 = exp2(log2(max(0.0f, _947)) * InverseGamma.y);

  [branch]
  if (output_device == 0) {
    do {
      if (WorkingColorSpace_bIsSRGB == 0) {
        float _996 = mad((WorkingColorSpace_ToAP1[0].z), _973, mad((WorkingColorSpace_ToAP1[0].y), _972, ((WorkingColorSpace_ToAP1[0].x) * _971)));
        float _999 = mad((WorkingColorSpace_ToAP1[1].z), _973, mad((WorkingColorSpace_ToAP1[1].y), _972, ((WorkingColorSpace_ToAP1[1].x) * _971)));
        float _1002 = mad((WorkingColorSpace_ToAP1[2].z), _973, mad((WorkingColorSpace_ToAP1[2].y), _972, ((WorkingColorSpace_ToAP1[2].x) * _971)));
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
            _2393 = _1026;
            _2394 = _1037;
            _2395 = (_1015 * 12.920000076293945f);
          } else {
            _2393 = _1026;
            _2394 = _1037;
            _2395 = (((pow(_1015, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1064 = mad((WorkingColorSpace_ToAP1[0].z), _973, mad((WorkingColorSpace_ToAP1[0].y), _972, ((WorkingColorSpace_ToAP1[0].x) * _971)));
      float _1067 = mad((WorkingColorSpace_ToAP1[1].z), _973, mad((WorkingColorSpace_ToAP1[1].y), _972, ((WorkingColorSpace_ToAP1[1].x) * _971)));
      float _1070 = mad((WorkingColorSpace_ToAP1[2].z), _973, mad((WorkingColorSpace_ToAP1[2].y), _972, ((WorkingColorSpace_ToAP1[2].x) * _971)));
      float _1080 = max(6.103519990574569e-05f, mad(_45, _1070, mad(_44, _1067, (_1064 * _43))));
      float _1081 = max(6.103519990574569e-05f, mad(_48, _1070, mad(_47, _1067, (_1064 * _46))));
      float _1082 = max(6.103519990574569e-05f, mad(_51, _1070, mad(_50, _1067, (_1064 * _49))));
      _2393 = min((_1080 * 4.5f), ((exp2(log2(max(_1080, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2394 = min((_1081 * 4.5f), ((exp2(log2(max(_1081, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2395 = min((_1082 * 4.5f), ((exp2(log2(max(_1082, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
        float _1157 = ACESSceneColorMultiplier * _957;
        float _1158 = ACESSceneColorMultiplier * _958;
        float _1159 = ACESSceneColorMultiplier * _959;
        float _1162 = mad((WorkingColorSpace_ToAP0[0].z), _1159, mad((WorkingColorSpace_ToAP0[0].y), _1158, ((WorkingColorSpace_ToAP0[0].x) * _1157)));
        float _1165 = mad((WorkingColorSpace_ToAP0[1].z), _1159, mad((WorkingColorSpace_ToAP0[1].y), _1158, ((WorkingColorSpace_ToAP0[1].x) * _1157)));
        float _1168 = mad((WorkingColorSpace_ToAP0[2].z), _1159, mad((WorkingColorSpace_ToAP0[2].y), _1158, ((WorkingColorSpace_ToAP0[2].x) * _1157)));
        float _1172 = max(max(_1162, _1165), _1168);
        float _1177 = (max(_1172, 1.000000013351432e-10f) - max(min(min(_1162, _1165), _1168), 1.000000013351432e-10f)) / max(_1172, 0.009999999776482582f);
        float _1190 = ((_1165 + _1162) + _1168) + (sqrt((((_1168 - _1165) * _1168) + ((_1165 - _1162) * _1165)) + ((_1162 - _1168) * _1162)) * 1.75f);
        float _1191 = _1190 * 0.3333333432674408f;
        float _1192 = _1177 + -0.4000000059604645f;
        float _1193 = _1192 * 5.0f;
        float _1197 = max((1.0f - abs(_1192 * 2.5f)), 0.0f);
        float _1208 = ((float((int)(((int)(uint)((bool)(_1193 > 0.0f))) - ((int)(uint)((bool)(_1193 < 0.0f))))) * (1.0f - (_1197 * _1197))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1191 <= 0.0533333346247673f)) {
            if (!(_1191 >= 0.1599999964237213f)) {
              _1217 = (((0.23999999463558197f / _1190) + -0.5f) * _1208);
            } else {
              _1217 = 0.0f;
            }
          } else {
            _1217 = _1208;
          }
          float _1218 = _1217 + 1.0f;
          float _1219 = _1218 * _1162;
          float _1220 = _1218 * _1165;
          float _1221 = _1218 * _1168;
          do {
            if (!((bool)(_1219 == _1220) && (bool)(_1220 == _1221))) {
              float _1228 = ((_1219 * 2.0f) - _1220) - _1221;
              float _1231 = ((_1165 - _1168) * 1.7320507764816284f) * _1218;
              float _1233 = atan(_1231 / _1228);
              bool _1236 = (_1228 < 0.0f);
              bool _1237 = (_1228 == 0.0f);
              bool _1238 = (_1231 >= 0.0f);
              bool _1239 = (_1231 < 0.0f);
              _1250 = select((_1238 && _1237), 90.0f, select((_1239 && _1237), -90.0f, (select((_1239 && _1236), (_1233 + -3.1415927410125732f), select((_1238 && _1236), (_1233 + 3.1415927410125732f), _1233)) * 57.2957763671875f)));
            } else {
              _1250 = 0.0f;
            }
            float _1255 = min(max(select((_1250 < 0.0f), (_1250 + 360.0f), _1250), 0.0f), 360.0f);
            do {
              if (_1255 < -180.0f) {
                _1264 = (_1255 + 360.0f);
              } else {
                if (_1255 > 180.0f) {
                  _1264 = (_1255 + -360.0f);
                } else {
                  _1264 = _1255;
                }
              }
              do {
                if ((bool)(_1264 > -67.5f) && (bool)(_1264 < 67.5f)) {
                  float _1270 = (_1264 + 67.5f) * 0.029629629105329514f;
                  int _1271 = int(_1270);
                  float _1273 = _1270 - float((int)(_1271));
                  float _1274 = _1273 * _1273;
                  float _1275 = _1274 * _1273;
                  if (_1271 == 3) {
                    _1303 = (((0.1666666716337204f - (_1273 * 0.5f)) + (_1274 * 0.5f)) - (_1275 * 0.1666666716337204f));
                  } else {
                    if (_1271 == 2) {
                      _1303 = ((0.6666666865348816f - _1274) + (_1275 * 0.5f));
                    } else {
                      if (_1271 == 1) {
                        _1303 = (((_1275 * -0.5f) + 0.1666666716337204f) + ((_1274 + _1273) * 0.5f));
                      } else {
                        _1303 = select((_1271 == 0), (_1275 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1303 = 0.0f;
                }
                float _1312 = min(max(((((_1177 * 0.27000001072883606f) * (0.029999999329447746f - _1219)) * _1303) + _1219), 0.0f), 65535.0f);
                float _1313 = min(max(_1220, 0.0f), 65535.0f);
                float _1314 = min(max(_1221, 0.0f), 65535.0f);
                float _1327 = min(max(mad(-0.21492856740951538f, _1314, mad(-0.2365107536315918f, _1313, (_1312 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1328 = min(max(mad(-0.09967592358589172f, _1314, mad(1.17622971534729f, _1313, (_1312 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1329 = min(max(mad(0.9977163076400757f, _1314, mad(-0.006032449658960104f, _1313, (_1312 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1330 = dot(float3(_1327, _1328, _1329), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1341 = log2(max((lerp(_1330, _1327, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1342 = _1341 * 0.3010300099849701f;
                float _1343 = log2(ACESMinMaxData.x);
                float _1344 = _1343 * 0.3010300099849701f;
                do {
                  if (!(!(_1342 <= _1344))) {
                    _1413 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1351 = log2(ACESMidData.x);
                    float _1352 = _1351 * 0.3010300099849701f;
                    if ((bool)(_1342 > _1344) && (bool)(_1342 < _1352)) {
                      float _1360 = ((_1341 - _1343) * 0.9030900001525879f) / ((_1351 - _1343) * 0.3010300099849701f);
                      int _1361 = int(_1360);
                      float _1363 = _1360 - float((int)(_1361));
                      float _1365 = _10[_1361];
                      float _1368 = _10[(_1361 + 1)];
                      float _1373 = _1365 * 0.5f;
                      _1413 = dot(float3((_1363 * _1363), _1363, 1.0f), float3(mad((_10[(_1361 + 2)]), 0.5f, mad(_1368, -1.0f, _1373)), (_1368 - _1365), mad(_1368, 0.5f, _1373)));
                    } else {
                      do {
                        if (!(!(_1342 >= _1352))) {
                          float _1382 = log2(ACESMinMaxData.z);
                          if (_1342 < (_1382 * 0.3010300099849701f)) {
                            float _1390 = ((_1341 - _1351) * 0.9030900001525879f) / ((_1382 - _1351) * 0.3010300099849701f);
                            int _1391 = int(_1390);
                            float _1393 = _1390 - float((int)(_1391));
                            float _1395 = _11[_1391];
                            float _1398 = _11[(_1391 + 1)];
                            float _1403 = _1395 * 0.5f;
                            _1413 = dot(float3((_1393 * _1393), _1393, 1.0f), float3(mad((_11[(_1391 + 2)]), 0.5f, mad(_1398, -1.0f, _1403)), (_1398 - _1395), mad(_1398, 0.5f, _1403)));
                            break;
                          }
                        }
                        _1413 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1417 = log2(max((lerp(_1330, _1328, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1418 = _1417 * 0.3010300099849701f;
                  do {
                    if (!(!(_1418 <= _1344))) {
                      _1487 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1425 = log2(ACESMidData.x);
                      float _1426 = _1425 * 0.3010300099849701f;
                      if ((bool)(_1418 > _1344) && (bool)(_1418 < _1426)) {
                        float _1434 = ((_1417 - _1343) * 0.9030900001525879f) / ((_1425 - _1343) * 0.3010300099849701f);
                        int _1435 = int(_1434);
                        float _1437 = _1434 - float((int)(_1435));
                        float _1439 = _10[_1435];
                        float _1442 = _10[(_1435 + 1)];
                        float _1447 = _1439 * 0.5f;
                        _1487 = dot(float3((_1437 * _1437), _1437, 1.0f), float3(mad((_10[(_1435 + 2)]), 0.5f, mad(_1442, -1.0f, _1447)), (_1442 - _1439), mad(_1442, 0.5f, _1447)));
                      } else {
                        do {
                          if (!(!(_1418 >= _1426))) {
                            float _1456 = log2(ACESMinMaxData.z);
                            if (_1418 < (_1456 * 0.3010300099849701f)) {
                              float _1464 = ((_1417 - _1425) * 0.9030900001525879f) / ((_1456 - _1425) * 0.3010300099849701f);
                              int _1465 = int(_1464);
                              float _1467 = _1464 - float((int)(_1465));
                              float _1469 = _11[_1465];
                              float _1472 = _11[(_1465 + 1)];
                              float _1477 = _1469 * 0.5f;
                              _1487 = dot(float3((_1467 * _1467), _1467, 1.0f), float3(mad((_11[(_1465 + 2)]), 0.5f, mad(_1472, -1.0f, _1477)), (_1472 - _1469), mad(_1472, 0.5f, _1477)));
                              break;
                            }
                          }
                          _1487 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1491 = log2(max((lerp(_1330, _1329, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1492 = _1491 * 0.3010300099849701f;
                    do {
                      if (!(!(_1492 <= _1344))) {
                        _1561 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1499 = log2(ACESMidData.x);
                        float _1500 = _1499 * 0.3010300099849701f;
                        if ((bool)(_1492 > _1344) && (bool)(_1492 < _1500)) {
                          float _1508 = ((_1491 - _1343) * 0.9030900001525879f) / ((_1499 - _1343) * 0.3010300099849701f);
                          int _1509 = int(_1508);
                          float _1511 = _1508 - float((int)(_1509));
                          float _1513 = _10[_1509];
                          float _1516 = _10[(_1509 + 1)];
                          float _1521 = _1513 * 0.5f;
                          _1561 = dot(float3((_1511 * _1511), _1511, 1.0f), float3(mad((_10[(_1509 + 2)]), 0.5f, mad(_1516, -1.0f, _1521)), (_1516 - _1513), mad(_1516, 0.5f, _1521)));
                        } else {
                          do {
                            if (!(!(_1492 >= _1500))) {
                              float _1530 = log2(ACESMinMaxData.z);
                              if (_1492 < (_1530 * 0.3010300099849701f)) {
                                float _1538 = ((_1491 - _1499) * 0.9030900001525879f) / ((_1530 - _1499) * 0.3010300099849701f);
                                int _1539 = int(_1538);
                                float _1541 = _1538 - float((int)(_1539));
                                float _1543 = _11[_1539];
                                float _1546 = _11[(_1539 + 1)];
                                float _1551 = _1543 * 0.5f;
                                _1561 = dot(float3((_1541 * _1541), _1541, 1.0f), float3(mad((_11[(_1539 + 2)]), 0.5f, mad(_1546, -1.0f, _1551)), (_1546 - _1543), mad(_1546, 0.5f, _1551)));
                                break;
                              }
                            }
                            _1561 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1565 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1566 = (exp2(_1413 * 3.321928024291992f) - ACESMinMaxData.y) / _1565;
                      float _1568 = (exp2(_1487 * 3.321928024291992f) - ACESMinMaxData.y) / _1565;
                      float _1570 = (exp2(_1561 * 3.321928024291992f) - ACESMinMaxData.y) / _1565;
                      float _1573 = mad(0.15618768334388733f, _1570, mad(0.13400420546531677f, _1568, (_1566 * 0.6624541878700256f)));
                      float _1576 = mad(0.053689517080783844f, _1570, mad(0.6740817427635193f, _1568, (_1566 * 0.2722287178039551f)));
                      float _1579 = mad(1.0103391408920288f, _1570, mad(0.00406073359772563f, _1568, (_1566 * -0.005574649665504694f)));
                      float _1592 = min(max(mad(-0.23642469942569733f, _1579, mad(-0.32480329275131226f, _1576, (_1573 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1593 = min(max(mad(0.016756348311901093f, _1579, mad(1.6153316497802734f, _1576, (_1573 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1594 = min(max(mad(0.9883948564529419f, _1579, mad(-0.008284442126750946f, _1576, (_1573 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1597 = mad(0.15618768334388733f, _1594, mad(0.13400420546531677f, _1593, (_1592 * 0.6624541878700256f)));
                      float _1600 = mad(0.053689517080783844f, _1594, mad(0.6740817427635193f, _1593, (_1592 * 0.2722287178039551f)));
                      float _1603 = mad(1.0103391408920288f, _1594, mad(0.00406073359772563f, _1593, (_1592 * -0.005574649665504694f)));
                      float _1625 = min(max((min(max(mad(-0.23642469942569733f, _1603, mad(-0.32480329275131226f, _1600, (_1597 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1626 = min(max((min(max(mad(0.016756348311901093f, _1603, mad(1.6153316497802734f, _1600, (_1597 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1627 = min(max((min(max(mad(0.9883948564529419f, _1603, mad(-0.008284442126750946f, _1600, (_1597 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _1640 = mad(_45, _1627, mad(_44, _1626, (_1625 * _43)));
                          _1641 = mad(_48, _1627, mad(_47, _1626, (_1625 * _46)));
                          _1642 = mad(_51, _1627, mad(_50, _1626, (_1625 * _49)));
                        } else {
                          _1640 = _1625;
                          _1641 = _1626;
                          _1642 = _1627;
                        }
                        float _1652 = exp2(log2(_1640 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1653 = exp2(log2(_1641 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1654 = exp2(log2(_1642 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2393 = exp2(log2((1.0f / ((_1652 * 18.6875f) + 1.0f)) * ((_1652 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2394 = exp2(log2((1.0f / ((_1653 * 18.6875f) + 1.0f)) * ((_1653 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2395 = exp2(log2((1.0f / ((_1654 * 18.6875f) + 1.0f)) * ((_1654 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1731 = ACESSceneColorMultiplier * _957;
          float _1732 = ACESSceneColorMultiplier * _958;
          float _1733 = ACESSceneColorMultiplier * _959;
          float _1736 = mad((WorkingColorSpace_ToAP0[0].z), _1733, mad((WorkingColorSpace_ToAP0[0].y), _1732, ((WorkingColorSpace_ToAP0[0].x) * _1731)));
          float _1739 = mad((WorkingColorSpace_ToAP0[1].z), _1733, mad((WorkingColorSpace_ToAP0[1].y), _1732, ((WorkingColorSpace_ToAP0[1].x) * _1731)));
          float _1742 = mad((WorkingColorSpace_ToAP0[2].z), _1733, mad((WorkingColorSpace_ToAP0[2].y), _1732, ((WorkingColorSpace_ToAP0[2].x) * _1731)));
          float _1746 = max(max(_1736, _1739), _1742);
          float _1751 = (max(_1746, 1.000000013351432e-10f) - max(min(min(_1736, _1739), _1742), 1.000000013351432e-10f)) / max(_1746, 0.009999999776482582f);
          float _1764 = ((_1739 + _1736) + _1742) + (sqrt((((_1742 - _1739) * _1742) + ((_1739 - _1736) * _1739)) + ((_1736 - _1742) * _1736)) * 1.75f);
          float _1765 = _1764 * 0.3333333432674408f;
          float _1766 = _1751 + -0.4000000059604645f;
          float _1767 = _1766 * 5.0f;
          float _1771 = max((1.0f - abs(_1766 * 2.5f)), 0.0f);
          float _1782 = ((float((int)(((int)(uint)((bool)(_1767 > 0.0f))) - ((int)(uint)((bool)(_1767 < 0.0f))))) * (1.0f - (_1771 * _1771))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1765 <= 0.0533333346247673f)) {
              if (!(_1765 >= 0.1599999964237213f)) {
                _1791 = (((0.23999999463558197f / _1764) + -0.5f) * _1782);
              } else {
                _1791 = 0.0f;
              }
            } else {
              _1791 = _1782;
            }
            float _1792 = _1791 + 1.0f;
            float _1793 = _1792 * _1736;
            float _1794 = _1792 * _1739;
            float _1795 = _1792 * _1742;
            do {
              if (!((bool)(_1793 == _1794) && (bool)(_1794 == _1795))) {
                float _1802 = ((_1793 * 2.0f) - _1794) - _1795;
                float _1805 = ((_1739 - _1742) * 1.7320507764816284f) * _1792;
                float _1807 = atan(_1805 / _1802);
                bool _1810 = (_1802 < 0.0f);
                bool _1811 = (_1802 == 0.0f);
                bool _1812 = (_1805 >= 0.0f);
                bool _1813 = (_1805 < 0.0f);
                _1824 = select((_1812 && _1811), 90.0f, select((_1813 && _1811), -90.0f, (select((_1813 && _1810), (_1807 + -3.1415927410125732f), select((_1812 && _1810), (_1807 + 3.1415927410125732f), _1807)) * 57.2957763671875f)));
              } else {
                _1824 = 0.0f;
              }
              float _1829 = min(max(select((_1824 < 0.0f), (_1824 + 360.0f), _1824), 0.0f), 360.0f);
              do {
                if (_1829 < -180.0f) {
                  _1838 = (_1829 + 360.0f);
                } else {
                  if (_1829 > 180.0f) {
                    _1838 = (_1829 + -360.0f);
                  } else {
                    _1838 = _1829;
                  }
                }
                do {
                  if ((bool)(_1838 > -67.5f) && (bool)(_1838 < 67.5f)) {
                    float _1844 = (_1838 + 67.5f) * 0.029629629105329514f;
                    int _1845 = int(_1844);
                    float _1847 = _1844 - float((int)(_1845));
                    float _1848 = _1847 * _1847;
                    float _1849 = _1848 * _1847;
                    if (_1845 == 3) {
                      _1877 = (((0.1666666716337204f - (_1847 * 0.5f)) + (_1848 * 0.5f)) - (_1849 * 0.1666666716337204f));
                    } else {
                      if (_1845 == 2) {
                        _1877 = ((0.6666666865348816f - _1848) + (_1849 * 0.5f));
                      } else {
                        if (_1845 == 1) {
                          _1877 = (((_1849 * -0.5f) + 0.1666666716337204f) + ((_1848 + _1847) * 0.5f));
                        } else {
                          _1877 = select((_1845 == 0), (_1849 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1877 = 0.0f;
                  }
                  float _1886 = min(max(((((_1751 * 0.27000001072883606f) * (0.029999999329447746f - _1793)) * _1877) + _1793), 0.0f), 65535.0f);
                  float _1887 = min(max(_1794, 0.0f), 65535.0f);
                  float _1888 = min(max(_1795, 0.0f), 65535.0f);
                  float _1901 = min(max(mad(-0.21492856740951538f, _1888, mad(-0.2365107536315918f, _1887, (_1886 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1902 = min(max(mad(-0.09967592358589172f, _1888, mad(1.17622971534729f, _1887, (_1886 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1903 = min(max(mad(0.9977163076400757f, _1888, mad(-0.006032449658960104f, _1887, (_1886 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1904 = dot(float3(_1901, _1902, _1903), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1915 = log2(max((lerp(_1904, _1901, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1916 = _1915 * 0.3010300099849701f;
                  float _1917 = log2(ACESMinMaxData.x);
                  float _1918 = _1917 * 0.3010300099849701f;
                  do {
                    if (!(!(_1916 <= _1918))) {
                      _1987 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1925 = log2(ACESMidData.x);
                      float _1926 = _1925 * 0.3010300099849701f;
                      if ((bool)(_1916 > _1918) && (bool)(_1916 < _1926)) {
                        float _1934 = ((_1915 - _1917) * 0.9030900001525879f) / ((_1925 - _1917) * 0.3010300099849701f);
                        int _1935 = int(_1934);
                        float _1937 = _1934 - float((int)(_1935));
                        float _1939 = _8[_1935];
                        float _1942 = _8[(_1935 + 1)];
                        float _1947 = _1939 * 0.5f;
                        _1987 = dot(float3((_1937 * _1937), _1937, 1.0f), float3(mad((_8[(_1935 + 2)]), 0.5f, mad(_1942, -1.0f, _1947)), (_1942 - _1939), mad(_1942, 0.5f, _1947)));
                      } else {
                        do {
                          if (!(!(_1916 >= _1926))) {
                            float _1956 = log2(ACESMinMaxData.z);
                            if (_1916 < (_1956 * 0.3010300099849701f)) {
                              float _1964 = ((_1915 - _1925) * 0.9030900001525879f) / ((_1956 - _1925) * 0.3010300099849701f);
                              int _1965 = int(_1964);
                              float _1967 = _1964 - float((int)(_1965));
                              float _1969 = _9[_1965];
                              float _1972 = _9[(_1965 + 1)];
                              float _1977 = _1969 * 0.5f;
                              _1987 = dot(float3((_1967 * _1967), _1967, 1.0f), float3(mad((_9[(_1965 + 2)]), 0.5f, mad(_1972, -1.0f, _1977)), (_1972 - _1969), mad(_1972, 0.5f, _1977)));
                              break;
                            }
                          }
                          _1987 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1991 = log2(max((lerp(_1904, _1902, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1992 = _1991 * 0.3010300099849701f;
                    do {
                      if (!(!(_1992 <= _1918))) {
                        _2061 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1999 = log2(ACESMidData.x);
                        float _2000 = _1999 * 0.3010300099849701f;
                        if ((bool)(_1992 > _1918) && (bool)(_1992 < _2000)) {
                          float _2008 = ((_1991 - _1917) * 0.9030900001525879f) / ((_1999 - _1917) * 0.3010300099849701f);
                          int _2009 = int(_2008);
                          float _2011 = _2008 - float((int)(_2009));
                          float _2013 = _8[_2009];
                          float _2016 = _8[(_2009 + 1)];
                          float _2021 = _2013 * 0.5f;
                          _2061 = dot(float3((_2011 * _2011), _2011, 1.0f), float3(mad((_8[(_2009 + 2)]), 0.5f, mad(_2016, -1.0f, _2021)), (_2016 - _2013), mad(_2016, 0.5f, _2021)));
                        } else {
                          do {
                            if (!(!(_1992 >= _2000))) {
                              float _2030 = log2(ACESMinMaxData.z);
                              if (_1992 < (_2030 * 0.3010300099849701f)) {
                                float _2038 = ((_1991 - _1999) * 0.9030900001525879f) / ((_2030 - _1999) * 0.3010300099849701f);
                                int _2039 = int(_2038);
                                float _2041 = _2038 - float((int)(_2039));
                                float _2043 = _9[_2039];
                                float _2046 = _9[(_2039 + 1)];
                                float _2051 = _2043 * 0.5f;
                                _2061 = dot(float3((_2041 * _2041), _2041, 1.0f), float3(mad((_9[(_2039 + 2)]), 0.5f, mad(_2046, -1.0f, _2051)), (_2046 - _2043), mad(_2046, 0.5f, _2051)));
                                break;
                              }
                            }
                            _2061 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2065 = log2(max((lerp(_1904, _1903, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2066 = _2065 * 0.3010300099849701f;
                      do {
                        if (!(!(_2066 <= _1918))) {
                          _2135 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2073 = log2(ACESMidData.x);
                          float _2074 = _2073 * 0.3010300099849701f;
                          if ((bool)(_2066 > _1918) && (bool)(_2066 < _2074)) {
                            float _2082 = ((_2065 - _1917) * 0.9030900001525879f) / ((_2073 - _1917) * 0.3010300099849701f);
                            int _2083 = int(_2082);
                            float _2085 = _2082 - float((int)(_2083));
                            float _2087 = _8[_2083];
                            float _2090 = _8[(_2083 + 1)];
                            float _2095 = _2087 * 0.5f;
                            _2135 = dot(float3((_2085 * _2085), _2085, 1.0f), float3(mad((_8[(_2083 + 2)]), 0.5f, mad(_2090, -1.0f, _2095)), (_2090 - _2087), mad(_2090, 0.5f, _2095)));
                          } else {
                            do {
                              if (!(!(_2066 >= _2074))) {
                                float _2104 = log2(ACESMinMaxData.z);
                                if (_2066 < (_2104 * 0.3010300099849701f)) {
                                  float _2112 = ((_2065 - _2073) * 0.9030900001525879f) / ((_2104 - _2073) * 0.3010300099849701f);
                                  int _2113 = int(_2112);
                                  float _2115 = _2112 - float((int)(_2113));
                                  float _2117 = _9[_2113];
                                  float _2120 = _9[(_2113 + 1)];
                                  float _2125 = _2117 * 0.5f;
                                  _2135 = dot(float3((_2115 * _2115), _2115, 1.0f), float3(mad((_9[(_2113 + 2)]), 0.5f, mad(_2120, -1.0f, _2125)), (_2120 - _2117), mad(_2120, 0.5f, _2125)));
                                  break;
                                }
                              }
                              _2135 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2139 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2140 = (exp2(_1987 * 3.321928024291992f) - ACESMinMaxData.y) / _2139;
                        float _2142 = (exp2(_2061 * 3.321928024291992f) - ACESMinMaxData.y) / _2139;
                        float _2144 = (exp2(_2135 * 3.321928024291992f) - ACESMinMaxData.y) / _2139;
                        float _2147 = mad(0.15618768334388733f, _2144, mad(0.13400420546531677f, _2142, (_2140 * 0.6624541878700256f)));
                        float _2150 = mad(0.053689517080783844f, _2144, mad(0.6740817427635193f, _2142, (_2140 * 0.2722287178039551f)));
                        float _2153 = mad(1.0103391408920288f, _2144, mad(0.00406073359772563f, _2142, (_2140 * -0.005574649665504694f)));
                        float _2166 = min(max(mad(-0.23642469942569733f, _2153, mad(-0.32480329275131226f, _2150, (_2147 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2167 = min(max(mad(0.016756348311901093f, _2153, mad(1.6153316497802734f, _2150, (_2147 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2168 = min(max(mad(0.9883948564529419f, _2153, mad(-0.008284442126750946f, _2150, (_2147 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2171 = mad(0.15618768334388733f, _2168, mad(0.13400420546531677f, _2167, (_2166 * 0.6624541878700256f)));
                        float _2174 = mad(0.053689517080783844f, _2168, mad(0.6740817427635193f, _2167, (_2166 * 0.2722287178039551f)));
                        float _2177 = mad(1.0103391408920288f, _2168, mad(0.00406073359772563f, _2167, (_2166 * -0.005574649665504694f)));
                        float _2199 = min(max((min(max(mad(-0.23642469942569733f, _2177, mad(-0.32480329275131226f, _2174, (_2171 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2200 = min(max((min(max(mad(0.016756348311901093f, _2177, mad(1.6153316497802734f, _2174, (_2171 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2201 = min(max((min(max(mad(0.9883948564529419f, _2177, mad(-0.008284442126750946f, _2174, (_2171 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2214 = mad(_45, _2201, mad(_44, _2200, (_2199 * _43)));
                            _2215 = mad(_48, _2201, mad(_47, _2200, (_2199 * _46)));
                            _2216 = mad(_51, _2201, mad(_50, _2200, (_2199 * _49)));
                          } else {
                            _2214 = _2199;
                            _2215 = _2200;
                            _2216 = _2201;
                          }
                          float _2226 = exp2(log2(_2214 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2227 = exp2(log2(_2215 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2228 = exp2(log2(_2216 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2393 = exp2(log2((1.0f / ((_2226 * 18.6875f) + 1.0f)) * ((_2226 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2394 = exp2(log2((1.0f / ((_2227 * 18.6875f) + 1.0f)) * ((_2227 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2395 = exp2(log2((1.0f / ((_2228 * 18.6875f) + 1.0f)) * ((_2228 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2273 = mad((WorkingColorSpace_ToAP1[0].z), _959, mad((WorkingColorSpace_ToAP1[0].y), _958, ((WorkingColorSpace_ToAP1[0].x) * _957)));
            float _2276 = mad((WorkingColorSpace_ToAP1[1].z), _959, mad((WorkingColorSpace_ToAP1[1].y), _958, ((WorkingColorSpace_ToAP1[1].x) * _957)));
            float _2279 = mad((WorkingColorSpace_ToAP1[2].z), _959, mad((WorkingColorSpace_ToAP1[2].y), _958, ((WorkingColorSpace_ToAP1[2].x) * _957)));
            float _2298 = exp2(log2(mad(_45, _2279, mad(_44, _2276, (_2273 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2299 = exp2(log2(mad(_48, _2279, mad(_47, _2276, (_2273 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2300 = exp2(log2(mad(_51, _2279, mad(_50, _2276, (_2273 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2393 = exp2(log2((1.0f / ((_2298 * 18.6875f) + 1.0f)) * ((_2298 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2394 = exp2(log2((1.0f / ((_2299 * 18.6875f) + 1.0f)) * ((_2299 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2395 = exp2(log2((1.0f / ((_2300 * 18.6875f) + 1.0f)) * ((_2300 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2347 = mad((WorkingColorSpace_ToAP1[0].z), _947, mad((WorkingColorSpace_ToAP1[0].y), _946, ((WorkingColorSpace_ToAP1[0].x) * _945)));
                float _2350 = mad((WorkingColorSpace_ToAP1[1].z), _947, mad((WorkingColorSpace_ToAP1[1].y), _946, ((WorkingColorSpace_ToAP1[1].x) * _945)));
                float _2353 = mad((WorkingColorSpace_ToAP1[2].z), _947, mad((WorkingColorSpace_ToAP1[2].y), _946, ((WorkingColorSpace_ToAP1[2].x) * _945)));
                _2393 = mad(_45, _2353, mad(_44, _2350, (_2347 * _43)));
                _2394 = mad(_48, _2353, mad(_47, _2350, (_2347 * _46)));
                _2395 = mad(_51, _2353, mad(_50, _2350, (_2347 * _49)));
              } else {
                float _2366 = mad((WorkingColorSpace_ToAP1[0].z), _973, mad((WorkingColorSpace_ToAP1[0].y), _972, ((WorkingColorSpace_ToAP1[0].x) * _971)));
                float _2369 = mad((WorkingColorSpace_ToAP1[1].z), _973, mad((WorkingColorSpace_ToAP1[1].y), _972, ((WorkingColorSpace_ToAP1[1].x) * _971)));
                float _2372 = mad((WorkingColorSpace_ToAP1[2].z), _973, mad((WorkingColorSpace_ToAP1[2].y), _972, ((WorkingColorSpace_ToAP1[2].x) * _971)));
                _2393 = exp2(log2(mad(_45, _2372, mad(_44, _2369, (_2366 * _43)))) * InverseGamma.z);
                _2394 = exp2(log2(mad(_48, _2372, mad(_47, _2369, (_2366 * _46)))) * InverseGamma.z);
                _2395 = exp2(log2(mad(_51, _2372, mad(_50, _2369, (_2366 * _49)))) * InverseGamma.z);
              }
            } else {
              _2393 = _957;
              _2394 = _958;
              _2395 = _959;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2393 * 0.9523810148239136f);
  SV_Target.y = (_2394 * 0.9523810148239136f);
  SV_Target.z = (_2395 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

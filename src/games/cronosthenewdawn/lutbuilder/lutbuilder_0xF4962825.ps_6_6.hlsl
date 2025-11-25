#include "./filmiclutbuilder.hlsli"

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  int WorkingColorSpace_320 : packoffset(c020.x);
};

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _8[6];
  float _9[6];
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _14[6];
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _19[6];
  float _22 = 0.5f / LUTSize;
  float _27 = LUTSize + -1.0f;
  float _28 = (LUTSize * (TEXCOORD.x - _22)) / _27;
  float _29 = (LUTSize * (TEXCOORD.y - _22)) / _27;
  float _31 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _27;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _117;
  float _118;
  float _119;
  float _642;
  float _675;
  float _689;
  float _753;
  float _1021;
  float _1022;
  float _1023;
  float _1034;
  float _1045;
  float _1218;
  float _1233;
  float _1248;
  float _1256;
  float _1257;
  float _1258;
  float _1325;
  float _1358;
  float _1372;
  float _1411;
  float _1533;
  float _1619;
  float _1693;
  float _1772;
  float _1773;
  float _1774;
  float _1904;
  float _1919;
  float _1934;
  float _1942;
  float _1943;
  float _1944;
  float _2011;
  float _2044;
  float _2058;
  float _2097;
  float _2219;
  float _2305;
  float _2391;
  float _2470;
  float _2471;
  float _2472;
  float _2649;
  float _2650;
  float _2651;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _40 = (OutputGamut == 4);
        _51 = select(_40, 1.0f, 1.705051064491272f);
        _52 = select(_40, 0.0f, -0.6217921376228333f);
        _53 = select(_40, 0.0f, -0.0832589864730835f);
        _54 = select(_40, 0.0f, -0.13025647401809692f);
        _55 = select(_40, 1.0f, 1.140804648399353f);
        _56 = select(_40, 0.0f, -0.010548308491706848f);
        _57 = select(_40, 0.0f, -0.024003351107239723f);
        _58 = select(_40, 0.0f, -0.1289689838886261f);
        _59 = select(_40, 1.0f, 1.1529725790023804f);
      } else {
        _51 = 0.6954522132873535f;
        _52 = 0.14067870378494263f;
        _53 = 0.16386906802654266f;
        _54 = 0.044794563204050064f;
        _55 = 0.8596711158752441f;
        _56 = 0.0955343171954155f;
        _57 = -0.005525882821530104f;
        _58 = 0.004025210160762072f;
        _59 = 1.0015007257461548f;
      }
    } else {
      _51 = 1.0258246660232544f;
      _52 = -0.020053181797266006f;
      _53 = -0.005771636962890625f;
      _54 = -0.002234415616840124f;
      _55 = 1.0045864582061768f;
      _56 = -0.002352118492126465f;
      _57 = -0.005013350863009691f;
      _58 = -0.025290070101618767f;
      _59 = 1.0303035974502563f;
    }
  } else {
    _51 = 1.3792141675949097f;
    _52 = -0.30886411666870117f;
    _53 = -0.0703500509262085f;
    _54 = -0.06933490186929703f;
    _55 = 1.08229660987854f;
    _56 = -0.012961871922016144f;
    _57 = -0.0021590073592960835f;
    _58 = -0.0454593189060688f;
    _59 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)OutputDevice > (uint)2) {
    float _70 = (pow(_28, 0.012683313339948654f));
    float _71 = (pow(_29, 0.012683313339948654f));
    float _72 = (pow(_31, 0.012683313339948654f));
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _117 = ((exp2((_28 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _118 = ((exp2((_29 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _119 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _134 = mad((WorkingColorSpace_128[0].z), _119, mad((WorkingColorSpace_128[0].y), _118, ((WorkingColorSpace_128[0].x) * _117)));
  float _137 = mad((WorkingColorSpace_128[1].z), _119, mad((WorkingColorSpace_128[1].y), _118, ((WorkingColorSpace_128[1].x) * _117)));
  float _140 = mad((WorkingColorSpace_128[2].z), _119, mad((WorkingColorSpace_128[2].y), _118, ((WorkingColorSpace_128[2].x) * _117)));
  float _141 = dot(float3(_134, _137, _140), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _145 = (_134 / _141) + -1.0f;
  float _146 = (_137 / _141) + -1.0f;
  float _147 = (_140 / _141) + -1.0f;
  float _159 = (1.0f - exp2(((_141 * _141) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_145, _146, _147), float3(_145, _146, _147)) * -4.0f));
  float _175 = ((mad(-0.06368321925401688f, _140, mad(-0.3292922377586365f, _137, (_134 * 1.3704125881195068f))) - _134) * _159) + _134;
  float _176 = ((mad(-0.010861365124583244f, _140, mad(1.0970927476882935f, _137, (_134 * -0.08343357592821121f))) - _137) * _159) + _137;
  float _177 = ((mad(1.2036951780319214f, _140, mad(-0.09862580895423889f, _137, (_134 * -0.02579331398010254f))) - _140) * _159) + _140;
  float _178 = dot(float3(_175, _176, _177), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float3 WorkingColor = float3(_175, _176, _177);
  WorkingColor = ApplyColorCorrection(WorkingColor,
    ColorSaturation,
    ColorContrast,
    ColorGamma,
    ColorGain,
    ColorOffset,
    ColorSaturationShadows,
    ColorContrastShadows,
    ColorGammaShadows,
    ColorGainShadows,
    ColorOffsetShadows,
    ColorSaturationHighlights,
    ColorContrastHighlights,
    ColorGammaHighlights,
    ColorGainHighlights,
    ColorOffsetHighlights,
    ColorSaturationMidtones,
    ColorContrastMidtones,
    ColorGammaMidtones,
    ColorGainMidtones,
    ColorOffsetMidtones,
    ColorCorrectionShadowsMax,
    ColorCorrectionHighlightsMin,
    ColorCorrectionHighlightsMax);

  float _582 = ((mad(0.061360642313957214f, WorkingColor.b, mad(-4.540197551250458e-09f, WorkingColor.g, (WorkingColor.r * 0.9386394023895264f))) - WorkingColor.r) * BlueCorrection) + WorkingColor.r;
  float _583 = ((mad(0.169205904006958f, WorkingColor.b, mad(0.8307942152023315f, WorkingColor.g, (WorkingColor.r * 6.775371730327606e-08f))) - WorkingColor.g) * BlueCorrection) + WorkingColor.g;
  float _584 = (mad(-2.3283064365386963e-10f, WorkingColor.g, (WorkingColor.r * -9.313225746154785e-10f)) * BlueCorrection) + WorkingColor.b;
  float _587 = mad(0.16386905312538147f, _584, mad(0.14067868888378143f, _583, (_582 * 0.6954522132873535f)));
  float _590 = mad(0.0955343246459961f, _584, mad(0.8596711158752441f, _583, (_582 * 0.044794581830501556f)));
  float _593 = mad(1.0015007257461548f, _584, mad(0.004025210160762072f, _583, (_582 * -0.005525882821530104f)));
  float _597 = max(max(_587, _590), _593);
  float _602 = (max(_597, 1.000000013351432e-10f) - max(min(min(_587, _590), _593), 1.000000013351432e-10f)) / max(_597, 0.009999999776482582f);
  float _615 = ((_590 + _587) + _593) + (sqrt((((_593 - _590) * _593) + ((_590 - _587) * _590)) + ((_587 - _593) * _587)) * 1.75f);
  float _616 = _615 * 0.3333333432674408f;
  float _617 = _602 + -0.4000000059604645f;
  float _618 = _617 * 5.0f;
  float _622 = max((1.0f - abs(_617 * 2.5f)), 0.0f);
  float _633 = ((float((int)(((int)(uint)((bool)(_618 > 0.0f))) - ((int)(uint)((bool)(_618 < 0.0f))))) * (1.0f - (_622 * _622))) + 1.0f) * 0.02500000037252903f;
  if (!(_616 <= 0.0533333346247673f)) {
    if (!(_616 >= 0.1599999964237213f)) {
      _642 = (((0.23999999463558197f / _615) + -0.5f) * _633);
    } else {
      _642 = 0.0f;
    }
  } else {
    _642 = _633;
  }
  float _643 = _642 + 1.0f;
  float _644 = _643 * _587;
  float _645 = _643 * _590;
  float _646 = _643 * _593;
  if (!((bool)(_644 == _645) && (bool)(_645 == _646))) {
    float _653 = ((_644 * 2.0f) - _645) - _646;
    float _656 = ((_590 - _593) * 1.7320507764816284f) * _643;
    float _658 = atan(_656 / _653);
    bool _661 = (_653 < 0.0f);
    bool _662 = (_653 == 0.0f);
    bool _663 = (_656 >= 0.0f);
    bool _664 = (_656 < 0.0f);
    _675 = select((_663 && _662), 90.0f, select((_664 && _662), -90.0f, (select((_664 && _661), (_658 + -3.1415927410125732f), select((_663 && _661), (_658 + 3.1415927410125732f), _658)) * 57.2957763671875f)));
  } else {
    _675 = 0.0f;
  }
  float _680 = min(max(select((_675 < 0.0f), (_675 + 360.0f), _675), 0.0f), 360.0f);
  if (_680 < -180.0f) {
    _689 = (_680 + 360.0f);
  } else {
    if (_680 > 180.0f) {
      _689 = (_680 + -360.0f);
    } else {
      _689 = _680;
    }
  }
  float _693 = saturate(1.0f - abs(_689 * 0.014814814552664757f));
  float _697 = (_693 * _693) * (3.0f - (_693 * 2.0f));
  float _703 = ((_697 * _697) * ((_602 * 0.18000000715255737f) * (0.029999999329447746f - _644))) + _644;
  float _713 = max(0.0f, mad(-0.21492856740951538f, _646, mad(-0.2365107536315918f, _645, (_703 * 1.4514392614364624f))));
  float _714 = max(0.0f, mad(-0.09967592358589172f, _646, mad(1.17622971534729f, _645, (_703 * -0.07655377686023712f))));
  float _715 = max(0.0f, mad(0.9977163076400757f, _646, mad(-0.006032449658960104f, _645, (_703 * 0.008316148072481155f))));
  float _716 = dot(float3(_713, _714, _715), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _731 = (FilmBlackClip + 1.0f) - FilmToe;
  float _733 = FilmWhiteClip + 1.0f;
  float _735 = _733 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _753 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _744 = (FilmBlackClip + 0.18000000715255737f) / _731;
    _753 = (-0.7447274923324585f - ((log2(_744 / (2.0f - _744)) * 0.3465735912322998f) * (_731 / FilmSlope)));
  }
  float _756 = ((1.0f - FilmToe) / FilmSlope) - _753;
  float _758 = (FilmShoulder / FilmSlope) - _756;

  float _904, _905, _906;
  if (is_hdr) {
    float3 lerpColor = lerp(_716, float3(_713, _714, _715), 0.9599999785423279f);
    ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b,
                       _582, _583, _584,
                       _904, _905, _906);
  } else {
  float _762 = log2(lerp(_716, _713, 0.9599999785423279f)) * 0.3010300099849701f;
  float _763 = log2(lerp(_716, _714, 0.9599999785423279f)) * 0.3010300099849701f;
  float _764 = log2(lerp(_716, _715, 0.9599999785423279f)) * 0.3010300099849701f;
  float _768 = FilmSlope * (_762 + _756);
  float _769 = FilmSlope * (_763 + _756);
  float _770 = FilmSlope * (_764 + _756);
  float _771 = _731 * 2.0f;
  float _773 = (FilmSlope * -2.0f) / _731;
  float _774 = _762 - _753;
  float _775 = _763 - _753;
  float _776 = _764 - _753;
  float _795 = _735 * 2.0f;
  float _797 = (FilmSlope * 2.0f) / _735;
  float _822 = select((_762 < _753), ((_771 / (exp2((_774 * 1.4426950216293335f) * _773) + 1.0f)) - FilmBlackClip), _768);
  float _823 = select((_763 < _753), ((_771 / (exp2((_775 * 1.4426950216293335f) * _773) + 1.0f)) - FilmBlackClip), _769);
  float _824 = select((_764 < _753), ((_771 / (exp2((_776 * 1.4426950216293335f) * _773) + 1.0f)) - FilmBlackClip), _770);
  float _831 = _758 - _753;
  float _835 = saturate(_774 / _831);
  float _836 = saturate(_775 / _831);
  float _837 = saturate(_776 / _831);
  bool _838 = (_758 < _753);
  float _842 = select(_838, (1.0f - _835), _835);
  float _843 = select(_838, (1.0f - _836), _836);
  float _844 = select(_838, (1.0f - _837), _837);
  float _863 = (((_842 * _842) * (select((_762 > _758), (_733 - (_795 / (exp2(((_762 - _758) * 1.4426950216293335f) * _797) + 1.0f))), _768) - _822)) * (3.0f - (_842 * 2.0f))) + _822;
  float _864 = (((_843 * _843) * (select((_763 > _758), (_733 - (_795 / (exp2(((_763 - _758) * 1.4426950216293335f) * _797) + 1.0f))), _769) - _823)) * (3.0f - (_843 * 2.0f))) + _823;
  float _865 = (((_844 * _844) * (select((_764 > _758), (_733 - (_795 / (exp2(((_764 - _758) * 1.4426950216293335f) * _797) + 1.0f))), _770) - _824)) * (3.0f - (_844 * 2.0f))) + _824;
  float _866 = dot(float3(_863, _864, _865), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _886 = (ToneCurveAmount * (max(0.0f, (lerp(_866, _863, 0.9300000071525574f))) - _582)) + _582;
  float _887 = (ToneCurveAmount * (max(0.0f, (lerp(_866, _864, 0.9300000071525574f))) - _583)) + _583;
  float _888 = (ToneCurveAmount * (max(0.0f, (lerp(_866, _865, 0.9300000071525574f))) - _584)) + _584;
  _904 = ((mad(-0.06537103652954102f, _888, mad(1.451815478503704e-06f, _887, (_886 * 1.065374732017517f))) - _886) * BlueCorrection) + _886;
  _905 = ((mad(-0.20366770029067993f, _888, mad(1.2036634683609009f, _887, (_886 * -2.57161445915699e-07f))) - _887) * BlueCorrection) + _887;
  _906 = ((mad(0.9999996423721313f, _888, mad(2.0954757928848267e-08f, _887, (_886 * 1.862645149230957e-08f))) - _888) * BlueCorrection) + _888;
  }
  float _916 = mad((WorkingColorSpace_192[0].z), _906, mad((WorkingColorSpace_192[0].y), _905, ((WorkingColorSpace_192[0].x) * _904)));
  float _917 = mad((WorkingColorSpace_192[1].z), _906, mad((WorkingColorSpace_192[1].y), _905, ((WorkingColorSpace_192[1].x) * _904)));
  float _918 = mad((WorkingColorSpace_192[2].z), _906, mad((WorkingColorSpace_192[2].y), _905, ((WorkingColorSpace_192[2].x) * _904)));
  if (!is_hdr) {
    _916 = max(0.0f, _916);
    _917 = max(0.0f, _917);
    _918 = max(0.0f, _918);
  }
  float _944 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _916)) * _916) + MappingPolynomial.z);
  float _945 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _917)) * _917) + MappingPolynomial.z);
  float _946 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _918)) * _918) + MappingPolynomial.z);
  float _953 = ((OverlayColor.x - _944) * OverlayColor.w) + _944;
  float _954 = ((OverlayColor.y - _945) * OverlayColor.w) + _945;
  float _955 = ((OverlayColor.z - _946) * OverlayColor.w) + _946;

  if (GenerateOutput(_953, _954, _955, SV_Target)) {
    return SV_Target;
  }

  float _956 = ColorScale.x * mad((WorkingColorSpace_192[0].z), WorkingColor.b, mad((WorkingColorSpace_192[0].y), WorkingColor.g, (WorkingColor.r * (WorkingColorSpace_192[0].x))));
  float _957 = ColorScale.y * mad((WorkingColorSpace_192[1].z), WorkingColor.b, mad((WorkingColorSpace_192[1].y), WorkingColor.g, ((WorkingColorSpace_192[1].x) * WorkingColor.r)));
  float _958 = ColorScale.z * mad((WorkingColorSpace_192[2].z), WorkingColor.b, mad((WorkingColorSpace_192[2].y), WorkingColor.g, ((WorkingColorSpace_192[2].x) * WorkingColor.r)));
  float _965 = ((OverlayColor.x - _956) * OverlayColor.w) + _956;
  float _966 = ((OverlayColor.y - _957) * OverlayColor.w) + _957;
  float _967 = ((OverlayColor.z - _958) * OverlayColor.w) + _958;
  float _979 = exp2(log2(max(0.0f, _953)) * InverseGamma.y);
  float _980 = exp2(log2(max(0.0f, _954)) * InverseGamma.y);
  float _981 = exp2(log2(max(0.0f, _955)) * InverseGamma.y);
  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1004 = mad((WorkingColorSpace_128[0].z), _981, mad((WorkingColorSpace_128[0].y), _980, ((WorkingColorSpace_128[0].x) * _979)));
        float _1007 = mad((WorkingColorSpace_128[1].z), _981, mad((WorkingColorSpace_128[1].y), _980, ((WorkingColorSpace_128[1].x) * _979)));
        float _1010 = mad((WorkingColorSpace_128[2].z), _981, mad((WorkingColorSpace_128[2].y), _980, ((WorkingColorSpace_128[2].x) * _979)));
        _1021 = mad(_53, _1010, mad(_52, _1007, (_1004 * _51)));
        _1022 = mad(_56, _1010, mad(_55, _1007, (_1004 * _54)));
        _1023 = mad(_59, _1010, mad(_58, _1007, (_1004 * _57)));
      } else {
        _1021 = _979;
        _1022 = _980;
        _1023 = _981;
      }
      do {
        if (_1021 < 0.0031306699384003878f) {
          _1034 = (_1021 * 12.920000076293945f);
        } else {
          _1034 = (((pow(_1021, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1022 < 0.0031306699384003878f) {
            _1045 = (_1022 * 12.920000076293945f);
          } else {
            _1045 = (((pow(_1022, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1023 < 0.0031306699384003878f) {
            _2649 = _1034;
            _2650 = _1045;
            _2651 = (_1023 * 12.920000076293945f);
          } else {
            _2649 = _1034;
            _2650 = _1045;
            _2651 = (((pow(_1023, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1072 = mad((WorkingColorSpace_128[0].z), _981, mad((WorkingColorSpace_128[0].y), _980, ((WorkingColorSpace_128[0].x) * _979)));
      float _1075 = mad((WorkingColorSpace_128[1].z), _981, mad((WorkingColorSpace_128[1].y), _980, ((WorkingColorSpace_128[1].x) * _979)));
      float _1078 = mad((WorkingColorSpace_128[2].z), _981, mad((WorkingColorSpace_128[2].y), _980, ((WorkingColorSpace_128[2].x) * _979)));
      float _1088 = max(6.103519990574569e-05f, mad(_53, _1078, mad(_52, _1075, (_1072 * _51))));
      float _1089 = max(6.103519990574569e-05f, mad(_56, _1078, mad(_55, _1075, (_1072 * _54))));
      float _1090 = max(6.103519990574569e-05f, mad(_59, _1078, mad(_58, _1075, (_1072 * _57))));
      _2649 = min((_1088 * 4.5f), ((exp2(log2(max(_1088, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2650 = min((_1089 * 4.5f), ((exp2(log2(max(_1089, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2651 = min((_1090 * 4.5f), ((exp2(log2(max(_1090, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1166 = ACESSceneColorMultiplier * _965;
        float _1167 = ACESSceneColorMultiplier * _966;
        float _1168 = ACESSceneColorMultiplier * _967;
        float _1171 = mad((WorkingColorSpace_256[0].z), _1168, mad((WorkingColorSpace_256[0].y), _1167, ((WorkingColorSpace_256[0].x) * _1166)));
        float _1174 = mad((WorkingColorSpace_256[1].z), _1168, mad((WorkingColorSpace_256[1].y), _1167, ((WorkingColorSpace_256[1].x) * _1166)));
        float _1177 = mad((WorkingColorSpace_256[2].z), _1168, mad((WorkingColorSpace_256[2].y), _1167, ((WorkingColorSpace_256[2].x) * _1166)));
        float _1180 = mad(-0.21492856740951538f, _1177, mad(-0.2365107536315918f, _1174, (_1171 * 1.4514392614364624f)));
        float _1183 = mad(-0.09967592358589172f, _1177, mad(1.17622971534729f, _1174, (_1171 * -0.07655377686023712f)));
        float _1186 = mad(0.9977163076400757f, _1177, mad(-0.006032449658960104f, _1174, (_1171 * 0.008316148072481155f)));
        float _1188 = max(_1180, max(_1183, _1186));
        do {
          if (!(_1188 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1171 < 0.0f) || (bool)(_1174 < 0.0f))) || (bool)(_1177 < 0.0f))) {
              float _1198 = abs(_1188);
              float _1199 = (_1188 - _1180) / _1198;
              float _1201 = (_1188 - _1183) / _1198;
              float _1203 = (_1188 - _1186) / _1198;
              do {
                if (!(_1199 < 0.8149999976158142f)) {
                  float _1206 = _1199 + -0.8149999976158142f;
                  _1218 = ((_1206 / exp2(log2(exp2(log2(_1206 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1218 = _1199;
                }
                do {
                  if (!(_1201 < 0.8029999732971191f)) {
                    float _1221 = _1201 + -0.8029999732971191f;
                    _1233 = ((_1221 / exp2(log2(exp2(log2(_1221 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1233 = _1201;
                  }
                  do {
                    if (!(_1203 < 0.8799999952316284f)) {
                      float _1236 = _1203 + -0.8799999952316284f;
                      _1248 = ((_1236 / exp2(log2(exp2(log2(_1236 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1248 = _1203;
                    }
                    _1256 = (_1188 - (_1198 * _1218));
                    _1257 = (_1188 - (_1198 * _1233));
                    _1258 = (_1188 - (_1198 * _1248));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1256 = _1180;
              _1257 = _1183;
              _1258 = _1186;
            }
          } else {
            _1256 = _1180;
            _1257 = _1183;
            _1258 = _1186;
          }
          float _1274 = ((mad(0.16386906802654266f, _1258, mad(0.14067870378494263f, _1257, (_1256 * 0.6954522132873535f))) - _1171) * ACESGamutCompression) + _1171;
          float _1275 = ((mad(0.0955343171954155f, _1258, mad(0.8596711158752441f, _1257, (_1256 * 0.044794563204050064f))) - _1174) * ACESGamutCompression) + _1174;
          float _1276 = ((mad(1.0015007257461548f, _1258, mad(0.004025210160762072f, _1257, (_1256 * -0.005525882821530104f))) - _1177) * ACESGamutCompression) + _1177;
          float _1280 = max(max(_1274, _1275), _1276);
          float _1285 = (max(_1280, 1.000000013351432e-10f) - max(min(min(_1274, _1275), _1276), 1.000000013351432e-10f)) / max(_1280, 0.009999999776482582f);
          float _1298 = ((_1275 + _1274) + _1276) + (sqrt((((_1276 - _1275) * _1276) + ((_1275 - _1274) * _1275)) + ((_1274 - _1276) * _1274)) * 1.75f);
          float _1299 = _1298 * 0.3333333432674408f;
          float _1300 = _1285 + -0.4000000059604645f;
          float _1301 = _1300 * 5.0f;
          float _1305 = max((1.0f - abs(_1300 * 2.5f)), 0.0f);
          float _1316 = ((float((int)(((int)(uint)((bool)(_1301 > 0.0f))) - ((int)(uint)((bool)(_1301 < 0.0f))))) * (1.0f - (_1305 * _1305))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1299 <= 0.0533333346247673f)) {
              if (!(_1299 >= 0.1599999964237213f)) {
                _1325 = (((0.23999999463558197f / _1298) + -0.5f) * _1316);
              } else {
                _1325 = 0.0f;
              }
            } else {
              _1325 = _1316;
            }
            float _1326 = _1325 + 1.0f;
            float _1327 = _1326 * _1274;
            float _1328 = _1326 * _1275;
            float _1329 = _1326 * _1276;
            do {
              if (!((bool)(_1327 == _1328) && (bool)(_1328 == _1329))) {
                float _1336 = ((_1327 * 2.0f) - _1328) - _1329;
                float _1339 = ((_1275 - _1276) * 1.7320507764816284f) * _1326;
                float _1341 = atan(_1339 / _1336);
                bool _1344 = (_1336 < 0.0f);
                bool _1345 = (_1336 == 0.0f);
                bool _1346 = (_1339 >= 0.0f);
                bool _1347 = (_1339 < 0.0f);
                _1358 = select((_1346 && _1345), 90.0f, select((_1347 && _1345), -90.0f, (select((_1347 && _1344), (_1341 + -3.1415927410125732f), select((_1346 && _1344), (_1341 + 3.1415927410125732f), _1341)) * 57.2957763671875f)));
              } else {
                _1358 = 0.0f;
              }
              float _1363 = min(max(select((_1358 < 0.0f), (_1358 + 360.0f), _1358), 0.0f), 360.0f);
              do {
                if (_1363 < -180.0f) {
                  _1372 = (_1363 + 360.0f);
                } else {
                  if (_1363 > 180.0f) {
                    _1372 = (_1363 + -360.0f);
                  } else {
                    _1372 = _1363;
                  }
                }
                do {
                  if ((bool)(_1372 > -67.5f) && (bool)(_1372 < 67.5f)) {
                    float _1378 = (_1372 + 67.5f) * 0.029629629105329514f;
                    int _1379 = int(_1378);
                    float _1381 = _1378 - float((int)(_1379));
                    float _1382 = _1381 * _1381;
                    float _1383 = _1382 * _1381;
                    if (_1379 == 3) {
                      _1411 = (((0.1666666716337204f - (_1381 * 0.5f)) + (_1382 * 0.5f)) - (_1383 * 0.1666666716337204f));
                    } else {
                      if (_1379 == 2) {
                        _1411 = ((0.6666666865348816f - _1382) + (_1383 * 0.5f));
                      } else {
                        if (_1379 == 1) {
                          _1411 = (((_1383 * -0.5f) + 0.1666666716337204f) + ((_1382 + _1381) * 0.5f));
                        } else {
                          _1411 = select((_1379 == 0), (_1383 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1411 = 0.0f;
                  }
                  float _1420 = min(max(((((_1285 * 0.27000001072883606f) * (0.029999999329447746f - _1327)) * _1411) + _1327), 0.0f), 65535.0f);
                  float _1421 = min(max(_1328, 0.0f), 65535.0f);
                  float _1422 = min(max(_1329, 0.0f), 65535.0f);
                  float _1435 = min(max(mad(-0.21492856740951538f, _1422, mad(-0.2365107536315918f, _1421, (_1420 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1436 = min(max(mad(-0.09967592358589172f, _1422, mad(1.17622971534729f, _1421, (_1420 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1437 = min(max(mad(0.9977163076400757f, _1422, mad(-0.006032449658960104f, _1421, (_1420 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1438 = dot(float3(_1435, _1436, _1437), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  _16[0] = ACESCoefsLow_0.x;
                  _16[1] = ACESCoefsLow_0.y;
                  _16[2] = ACESCoefsLow_0.z;
                  _16[3] = ACESCoefsLow_0.w;
                  _16[4] = ACESCoefsLow_4;
                  _16[5] = ACESCoefsLow_4;
                  _17[0] = ACESCoefsHigh_0.x;
                  _17[1] = ACESCoefsHigh_0.y;
                  _17[2] = ACESCoefsHigh_0.z;
                  _17[3] = ACESCoefsHigh_0.w;
                  _17[4] = ACESCoefsHigh_4;
                  _17[5] = ACESCoefsHigh_4;
                  float _1461 = log2(max((lerp(_1438, _1435, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1462 = _1461 * 0.3010300099849701f;
                  float _1463 = log2(ACESMinMaxData.x);
                  float _1464 = _1463 * 0.3010300099849701f;
                  do {
                    if (!(!(_1462 <= _1464))) {
                      _1533 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1471 = log2(ACESMidData.x);
                      float _1472 = _1471 * 0.3010300099849701f;
                      if ((bool)(_1462 > _1464) && (bool)(_1462 < _1472)) {
                        float _1480 = ((_1461 - _1463) * 0.9030900001525879f) / ((_1471 - _1463) * 0.3010300099849701f);
                        int _1481 = int(_1480);
                        float _1483 = _1480 - float((int)(_1481));
                        float _1485 = _16[_1481];
                        float _1488 = _16[(_1481 + 1)];
                        float _1493 = _1485 * 0.5f;
                        _1533 = dot(float3((_1483 * _1483), _1483, 1.0f), float3(mad((_16[(_1481 + 2)]), 0.5f, mad(_1488, -1.0f, _1493)), (_1488 - _1485), mad(_1488, 0.5f, _1493)));
                      } else {
                        do {
                          if (!(!(_1462 >= _1472))) {
                            float _1502 = log2(ACESMinMaxData.z);
                            if (_1462 < (_1502 * 0.3010300099849701f)) {
                              float _1510 = ((_1461 - _1471) * 0.9030900001525879f) / ((_1502 - _1471) * 0.3010300099849701f);
                              int _1511 = int(_1510);
                              float _1513 = _1510 - float((int)(_1511));
                              float _1515 = _17[_1511];
                              float _1518 = _17[(_1511 + 1)];
                              float _1523 = _1515 * 0.5f;
                              _1533 = dot(float3((_1513 * _1513), _1513, 1.0f), float3(mad((_17[(_1511 + 2)]), 0.5f, mad(_1518, -1.0f, _1523)), (_1518 - _1515), mad(_1518, 0.5f, _1523)));
                              break;
                            }
                          }
                          _1533 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _18[0] = ACESCoefsLow_0.x;
                    _18[1] = ACESCoefsLow_0.y;
                    _18[2] = ACESCoefsLow_0.z;
                    _18[3] = ACESCoefsLow_0.w;
                    _18[4] = ACESCoefsLow_4;
                    _18[5] = ACESCoefsLow_4;
                    _19[0] = ACESCoefsHigh_0.x;
                    _19[1] = ACESCoefsHigh_0.y;
                    _19[2] = ACESCoefsHigh_0.z;
                    _19[3] = ACESCoefsHigh_0.w;
                    _19[4] = ACESCoefsHigh_4;
                    _19[5] = ACESCoefsHigh_4;
                    float _1549 = log2(max((lerp(_1438, _1436, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1550 = _1549 * 0.3010300099849701f;
                    do {
                      if (!(!(_1550 <= _1464))) {
                        _1619 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1557 = log2(ACESMidData.x);
                        float _1558 = _1557 * 0.3010300099849701f;
                        if ((bool)(_1550 > _1464) && (bool)(_1550 < _1558)) {
                          float _1566 = ((_1549 - _1463) * 0.9030900001525879f) / ((_1557 - _1463) * 0.3010300099849701f);
                          int _1567 = int(_1566);
                          float _1569 = _1566 - float((int)(_1567));
                          float _1571 = _18[_1567];
                          float _1574 = _18[(_1567 + 1)];
                          float _1579 = _1571 * 0.5f;
                          _1619 = dot(float3((_1569 * _1569), _1569, 1.0f), float3(mad((_18[(_1567 + 2)]), 0.5f, mad(_1574, -1.0f, _1579)), (_1574 - _1571), mad(_1574, 0.5f, _1579)));
                        } else {
                          do {
                            if (!(!(_1550 >= _1558))) {
                              float _1588 = log2(ACESMinMaxData.z);
                              if (_1550 < (_1588 * 0.3010300099849701f)) {
                                float _1596 = ((_1549 - _1557) * 0.9030900001525879f) / ((_1588 - _1557) * 0.3010300099849701f);
                                int _1597 = int(_1596);
                                float _1599 = _1596 - float((int)(_1597));
                                float _1601 = _19[_1597];
                                float _1604 = _19[(_1597 + 1)];
                                float _1609 = _1601 * 0.5f;
                                _1619 = dot(float3((_1599 * _1599), _1599, 1.0f), float3(mad((_19[(_1597 + 2)]), 0.5f, mad(_1604, -1.0f, _1609)), (_1604 - _1601), mad(_1604, 0.5f, _1609)));
                                break;
                              }
                            }
                            _1619 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1623 = log2(max((lerp(_1438, _1437, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1624 = _1623 * 0.3010300099849701f;
                      do {
                        if (!(!(_1624 <= _1464))) {
                          _1693 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1631 = log2(ACESMidData.x);
                          float _1632 = _1631 * 0.3010300099849701f;
                          if ((bool)(_1624 > _1464) && (bool)(_1624 < _1632)) {
                            float _1640 = ((_1623 - _1463) * 0.9030900001525879f) / ((_1631 - _1463) * 0.3010300099849701f);
                            int _1641 = int(_1640);
                            float _1643 = _1640 - float((int)(_1641));
                            float _1645 = _8[_1641];
                            float _1648 = _8[(_1641 + 1)];
                            float _1653 = _1645 * 0.5f;
                            _1693 = dot(float3((_1643 * _1643), _1643, 1.0f), float3(mad((_8[(_1641 + 2)]), 0.5f, mad(_1648, -1.0f, _1653)), (_1648 - _1645), mad(_1648, 0.5f, _1653)));
                          } else {
                            do {
                              if (!(!(_1624 >= _1632))) {
                                float _1662 = log2(ACESMinMaxData.z);
                                if (_1624 < (_1662 * 0.3010300099849701f)) {
                                  float _1670 = ((_1623 - _1631) * 0.9030900001525879f) / ((_1662 - _1631) * 0.3010300099849701f);
                                  int _1671 = int(_1670);
                                  float _1673 = _1670 - float((int)(_1671));
                                  float _1675 = _9[_1671];
                                  float _1678 = _9[(_1671 + 1)];
                                  float _1683 = _1675 * 0.5f;
                                  _1693 = dot(float3((_1673 * _1673), _1673, 1.0f), float3(mad((_9[(_1671 + 2)]), 0.5f, mad(_1678, -1.0f, _1683)), (_1678 - _1675), mad(_1678, 0.5f, _1683)));
                                  break;
                                }
                              }
                              _1693 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1697 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1698 = (exp2(_1533 * 3.321928024291992f) - ACESMinMaxData.y) / _1697;
                        float _1700 = (exp2(_1619 * 3.321928024291992f) - ACESMinMaxData.y) / _1697;
                        float _1702 = (exp2(_1693 * 3.321928024291992f) - ACESMinMaxData.y) / _1697;
                        float _1705 = mad(0.15618768334388733f, _1702, mad(0.13400420546531677f, _1700, (_1698 * 0.6624541878700256f)));
                        float _1708 = mad(0.053689517080783844f, _1702, mad(0.6740817427635193f, _1700, (_1698 * 0.2722287178039551f)));
                        float _1711 = mad(1.0103391408920288f, _1702, mad(0.00406073359772563f, _1700, (_1698 * -0.005574649665504694f)));
                        float _1724 = min(max(mad(-0.23642469942569733f, _1711, mad(-0.32480329275131226f, _1708, (_1705 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1725 = min(max(mad(0.016756348311901093f, _1711, mad(1.6153316497802734f, _1708, (_1705 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1726 = min(max(mad(0.9883948564529419f, _1711, mad(-0.008284442126750946f, _1708, (_1705 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1729 = mad(0.15618768334388733f, _1726, mad(0.13400420546531677f, _1725, (_1724 * 0.6624541878700256f)));
                        float _1732 = mad(0.053689517080783844f, _1726, mad(0.6740817427635193f, _1725, (_1724 * 0.2722287178039551f)));
                        float _1735 = mad(1.0103391408920288f, _1726, mad(0.00406073359772563f, _1725, (_1724 * -0.005574649665504694f)));
                        float _1757 = min(max((min(max(mad(-0.23642469942569733f, _1735, mad(-0.32480329275131226f, _1732, (_1729 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1758 = min(max((min(max(mad(0.016756348311901093f, _1735, mad(1.6153316497802734f, _1732, (_1729 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1759 = min(max((min(max(mad(0.9883948564529419f, _1735, mad(-0.008284442126750946f, _1732, (_1729 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 5)) {
                            _1772 = mad(_53, _1759, mad(_52, _1758, (_1757 * _51)));
                            _1773 = mad(_56, _1759, mad(_55, _1758, (_1757 * _54)));
                            _1774 = mad(_59, _1759, mad(_58, _1758, (_1757 * _57)));
                          } else {
                            _1772 = _1757;
                            _1773 = _1758;
                            _1774 = _1759;
                          }
                          float _1784 = exp2(log2(_1772 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1785 = exp2(log2(_1773 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1786 = exp2(log2(_1774 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2649 = exp2(log2((1.0f / ((_1784 * 18.6875f) + 1.0f)) * ((_1784 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2650 = exp2(log2((1.0f / ((_1785 * 18.6875f) + 1.0f)) * ((_1785 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2651 = exp2(log2((1.0f / ((_1786 * 18.6875f) + 1.0f)) * ((_1786 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1852 = ACESSceneColorMultiplier * _965;
          float _1853 = ACESSceneColorMultiplier * _966;
          float _1854 = ACESSceneColorMultiplier * _967;
          float _1857 = mad((WorkingColorSpace_256[0].z), _1854, mad((WorkingColorSpace_256[0].y), _1853, ((WorkingColorSpace_256[0].x) * _1852)));
          float _1860 = mad((WorkingColorSpace_256[1].z), _1854, mad((WorkingColorSpace_256[1].y), _1853, ((WorkingColorSpace_256[1].x) * _1852)));
          float _1863 = mad((WorkingColorSpace_256[2].z), _1854, mad((WorkingColorSpace_256[2].y), _1853, ((WorkingColorSpace_256[2].x) * _1852)));
          float _1866 = mad(-0.21492856740951538f, _1863, mad(-0.2365107536315918f, _1860, (_1857 * 1.4514392614364624f)));
          float _1869 = mad(-0.09967592358589172f, _1863, mad(1.17622971534729f, _1860, (_1857 * -0.07655377686023712f)));
          float _1872 = mad(0.9977163076400757f, _1863, mad(-0.006032449658960104f, _1860, (_1857 * 0.008316148072481155f)));
          float _1874 = max(_1866, max(_1869, _1872));
          do {
            if (!(_1874 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1857 < 0.0f) || (bool)(_1860 < 0.0f))) || (bool)(_1863 < 0.0f))) {
                float _1884 = abs(_1874);
                float _1885 = (_1874 - _1866) / _1884;
                float _1887 = (_1874 - _1869) / _1884;
                float _1889 = (_1874 - _1872) / _1884;
                do {
                  if (!(_1885 < 0.8149999976158142f)) {
                    float _1892 = _1885 + -0.8149999976158142f;
                    _1904 = ((_1892 / exp2(log2(exp2(log2(_1892 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _1904 = _1885;
                  }
                  do {
                    if (!(_1887 < 0.8029999732971191f)) {
                      float _1907 = _1887 + -0.8029999732971191f;
                      _1919 = ((_1907 / exp2(log2(exp2(log2(_1907 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _1919 = _1887;
                    }
                    do {
                      if (!(_1889 < 0.8799999952316284f)) {
                        float _1922 = _1889 + -0.8799999952316284f;
                        _1934 = ((_1922 / exp2(log2(exp2(log2(_1922 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _1934 = _1889;
                      }
                      _1942 = (_1874 - (_1884 * _1904));
                      _1943 = (_1874 - (_1884 * _1919));
                      _1944 = (_1874 - (_1884 * _1934));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _1942 = _1866;
                _1943 = _1869;
                _1944 = _1872;
              }
            } else {
              _1942 = _1866;
              _1943 = _1869;
              _1944 = _1872;
            }
            float _1960 = ((mad(0.16386906802654266f, _1944, mad(0.14067870378494263f, _1943, (_1942 * 0.6954522132873535f))) - _1857) * ACESGamutCompression) + _1857;
            float _1961 = ((mad(0.0955343171954155f, _1944, mad(0.8596711158752441f, _1943, (_1942 * 0.044794563204050064f))) - _1860) * ACESGamutCompression) + _1860;
            float _1962 = ((mad(1.0015007257461548f, _1944, mad(0.004025210160762072f, _1943, (_1942 * -0.005525882821530104f))) - _1863) * ACESGamutCompression) + _1863;
            float _1966 = max(max(_1960, _1961), _1962);
            float _1971 = (max(_1966, 1.000000013351432e-10f) - max(min(min(_1960, _1961), _1962), 1.000000013351432e-10f)) / max(_1966, 0.009999999776482582f);
            float _1984 = ((_1961 + _1960) + _1962) + (sqrt((((_1962 - _1961) * _1962) + ((_1961 - _1960) * _1961)) + ((_1960 - _1962) * _1960)) * 1.75f);
            float _1985 = _1984 * 0.3333333432674408f;
            float _1986 = _1971 + -0.4000000059604645f;
            float _1987 = _1986 * 5.0f;
            float _1991 = max((1.0f - abs(_1986 * 2.5f)), 0.0f);
            float _2002 = ((float((int)(((int)(uint)((bool)(_1987 > 0.0f))) - ((int)(uint)((bool)(_1987 < 0.0f))))) * (1.0f - (_1991 * _1991))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_1985 <= 0.0533333346247673f)) {
                if (!(_1985 >= 0.1599999964237213f)) {
                  _2011 = (((0.23999999463558197f / _1984) + -0.5f) * _2002);
                } else {
                  _2011 = 0.0f;
                }
              } else {
                _2011 = _2002;
              }
              float _2012 = _2011 + 1.0f;
              float _2013 = _2012 * _1960;
              float _2014 = _2012 * _1961;
              float _2015 = _2012 * _1962;
              do {
                if (!((bool)(_2013 == _2014) && (bool)(_2014 == _2015))) {
                  float _2022 = ((_2013 * 2.0f) - _2014) - _2015;
                  float _2025 = ((_1961 - _1962) * 1.7320507764816284f) * _2012;
                  float _2027 = atan(_2025 / _2022);
                  bool _2030 = (_2022 < 0.0f);
                  bool _2031 = (_2022 == 0.0f);
                  bool _2032 = (_2025 >= 0.0f);
                  bool _2033 = (_2025 < 0.0f);
                  _2044 = select((_2032 && _2031), 90.0f, select((_2033 && _2031), -90.0f, (select((_2033 && _2030), (_2027 + -3.1415927410125732f), select((_2032 && _2030), (_2027 + 3.1415927410125732f), _2027)) * 57.2957763671875f)));
                } else {
                  _2044 = 0.0f;
                }
                float _2049 = min(max(select((_2044 < 0.0f), (_2044 + 360.0f), _2044), 0.0f), 360.0f);
                do {
                  if (_2049 < -180.0f) {
                    _2058 = (_2049 + 360.0f);
                  } else {
                    if (_2049 > 180.0f) {
                      _2058 = (_2049 + -360.0f);
                    } else {
                      _2058 = _2049;
                    }
                  }
                  do {
                    if ((bool)(_2058 > -67.5f) && (bool)(_2058 < 67.5f)) {
                      float _2064 = (_2058 + 67.5f) * 0.029629629105329514f;
                      int _2065 = int(_2064);
                      float _2067 = _2064 - float((int)(_2065));
                      float _2068 = _2067 * _2067;
                      float _2069 = _2068 * _2067;
                      if (_2065 == 3) {
                        _2097 = (((0.1666666716337204f - (_2067 * 0.5f)) + (_2068 * 0.5f)) - (_2069 * 0.1666666716337204f));
                      } else {
                        if (_2065 == 2) {
                          _2097 = ((0.6666666865348816f - _2068) + (_2069 * 0.5f));
                        } else {
                          if (_2065 == 1) {
                            _2097 = (((_2069 * -0.5f) + 0.1666666716337204f) + ((_2068 + _2067) * 0.5f));
                          } else {
                            _2097 = select((_2065 == 0), (_2069 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2097 = 0.0f;
                    }
                    float _2106 = min(max(((((_1971 * 0.27000001072883606f) * (0.029999999329447746f - _2013)) * _2097) + _2013), 0.0f), 65535.0f);
                    float _2107 = min(max(_2014, 0.0f), 65535.0f);
                    float _2108 = min(max(_2015, 0.0f), 65535.0f);
                    float _2121 = min(max(mad(-0.21492856740951538f, _2108, mad(-0.2365107536315918f, _2107, (_2106 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2122 = min(max(mad(-0.09967592358589172f, _2108, mad(1.17622971534729f, _2107, (_2106 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2123 = min(max(mad(0.9977163076400757f, _2108, mad(-0.006032449658960104f, _2107, (_2106 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2124 = dot(float3(_2121, _2122, _2123), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2147 = log2(max((lerp(_2124, _2121, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2148 = _2147 * 0.3010300099849701f;
                    float _2149 = log2(ACESMinMaxData.x);
                    float _2150 = _2149 * 0.3010300099849701f;
                    do {
                      if (!(!(_2148 <= _2150))) {
                        _2219 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2157 = log2(ACESMidData.x);
                        float _2158 = _2157 * 0.3010300099849701f;
                        if ((bool)(_2148 > _2150) && (bool)(_2148 < _2158)) {
                          float _2166 = ((_2147 - _2149) * 0.9030900001525879f) / ((_2157 - _2149) * 0.3010300099849701f);
                          int _2167 = int(_2166);
                          float _2169 = _2166 - float((int)(_2167));
                          float _2171 = _14[_2167];
                          float _2174 = _14[(_2167 + 1)];
                          float _2179 = _2171 * 0.5f;
                          _2219 = dot(float3((_2169 * _2169), _2169, 1.0f), float3(mad((_14[(_2167 + 2)]), 0.5f, mad(_2174, -1.0f, _2179)), (_2174 - _2171), mad(_2174, 0.5f, _2179)));
                        } else {
                          do {
                            if (!(!(_2148 >= _2158))) {
                              float _2188 = log2(ACESMinMaxData.z);
                              if (_2148 < (_2188 * 0.3010300099849701f)) {
                                float _2196 = ((_2147 - _2157) * 0.9030900001525879f) / ((_2188 - _2157) * 0.3010300099849701f);
                                int _2197 = int(_2196);
                                float _2199 = _2196 - float((int)(_2197));
                                float _2201 = _15[_2197];
                                float _2204 = _15[(_2197 + 1)];
                                float _2209 = _2201 * 0.5f;
                                _2219 = dot(float3((_2199 * _2199), _2199, 1.0f), float3(mad((_15[(_2197 + 2)]), 0.5f, mad(_2204, -1.0f, _2209)), (_2204 - _2201), mad(_2204, 0.5f, _2209)));
                                break;
                              }
                            }
                            _2219 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
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
                      float _2235 = log2(max((lerp(_2124, _2122, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2236 = _2235 * 0.3010300099849701f;
                      do {
                        if (!(!(_2236 <= _2150))) {
                          _2305 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2243 = log2(ACESMidData.x);
                          float _2244 = _2243 * 0.3010300099849701f;
                          if ((bool)(_2236 > _2150) && (bool)(_2236 < _2244)) {
                            float _2252 = ((_2235 - _2149) * 0.9030900001525879f) / ((_2243 - _2149) * 0.3010300099849701f);
                            int _2253 = int(_2252);
                            float _2255 = _2252 - float((int)(_2253));
                            float _2257 = _10[_2253];
                            float _2260 = _10[(_2253 + 1)];
                            float _2265 = _2257 * 0.5f;
                            _2305 = dot(float3((_2255 * _2255), _2255, 1.0f), float3(mad((_10[(_2253 + 2)]), 0.5f, mad(_2260, -1.0f, _2265)), (_2260 - _2257), mad(_2260, 0.5f, _2265)));
                          } else {
                            do {
                              if (!(!(_2236 >= _2244))) {
                                float _2274 = log2(ACESMinMaxData.z);
                                if (_2236 < (_2274 * 0.3010300099849701f)) {
                                  float _2282 = ((_2235 - _2243) * 0.9030900001525879f) / ((_2274 - _2243) * 0.3010300099849701f);
                                  int _2283 = int(_2282);
                                  float _2285 = _2282 - float((int)(_2283));
                                  float _2287 = _11[_2283];
                                  float _2290 = _11[(_2283 + 1)];
                                  float _2295 = _2287 * 0.5f;
                                  _2305 = dot(float3((_2285 * _2285), _2285, 1.0f), float3(mad((_11[(_2283 + 2)]), 0.5f, mad(_2290, -1.0f, _2295)), (_2290 - _2287), mad(_2290, 0.5f, _2295)));
                                  break;
                                }
                              }
                              _2305 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
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
                        float _2321 = log2(max((lerp(_2124, _2123, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2322 = _2321 * 0.3010300099849701f;
                        do {
                          if (!(!(_2322 <= _2150))) {
                            _2391 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2329 = log2(ACESMidData.x);
                            float _2330 = _2329 * 0.3010300099849701f;
                            if ((bool)(_2322 > _2150) && (bool)(_2322 < _2330)) {
                              float _2338 = ((_2321 - _2149) * 0.9030900001525879f) / ((_2329 - _2149) * 0.3010300099849701f);
                              int _2339 = int(_2338);
                              float _2341 = _2338 - float((int)(_2339));
                              float _2343 = _12[_2339];
                              float _2346 = _12[(_2339 + 1)];
                              float _2351 = _2343 * 0.5f;
                              _2391 = dot(float3((_2341 * _2341), _2341, 1.0f), float3(mad((_12[(_2339 + 2)]), 0.5f, mad(_2346, -1.0f, _2351)), (_2346 - _2343), mad(_2346, 0.5f, _2351)));
                            } else {
                              do {
                                if (!(!(_2322 >= _2330))) {
                                  float _2360 = log2(ACESMinMaxData.z);
                                  if (_2322 < (_2360 * 0.3010300099849701f)) {
                                    float _2368 = ((_2321 - _2329) * 0.9030900001525879f) / ((_2360 - _2329) * 0.3010300099849701f);
                                    int _2369 = int(_2368);
                                    float _2371 = _2368 - float((int)(_2369));
                                    float _2373 = _13[_2369];
                                    float _2376 = _13[(_2369 + 1)];
                                    float _2381 = _2373 * 0.5f;
                                    _2391 = dot(float3((_2371 * _2371), _2371, 1.0f), float3(mad((_13[(_2369 + 2)]), 0.5f, mad(_2376, -1.0f, _2381)), (_2376 - _2373), mad(_2376, 0.5f, _2381)));
                                    break;
                                  }
                                }
                                _2391 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2395 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2396 = (exp2(_2219 * 3.321928024291992f) - ACESMinMaxData.y) / _2395;
                          float _2398 = (exp2(_2305 * 3.321928024291992f) - ACESMinMaxData.y) / _2395;
                          float _2400 = (exp2(_2391 * 3.321928024291992f) - ACESMinMaxData.y) / _2395;
                          float _2403 = mad(0.15618768334388733f, _2400, mad(0.13400420546531677f, _2398, (_2396 * 0.6624541878700256f)));
                          float _2406 = mad(0.053689517080783844f, _2400, mad(0.6740817427635193f, _2398, (_2396 * 0.2722287178039551f)));
                          float _2409 = mad(1.0103391408920288f, _2400, mad(0.00406073359772563f, _2398, (_2396 * -0.005574649665504694f)));
                          float _2422 = min(max(mad(-0.23642469942569733f, _2409, mad(-0.32480329275131226f, _2406, (_2403 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2423 = min(max(mad(0.016756348311901093f, _2409, mad(1.6153316497802734f, _2406, (_2403 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2424 = min(max(mad(0.9883948564529419f, _2409, mad(-0.008284442126750946f, _2406, (_2403 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2427 = mad(0.15618768334388733f, _2424, mad(0.13400420546531677f, _2423, (_2422 * 0.6624541878700256f)));
                          float _2430 = mad(0.053689517080783844f, _2424, mad(0.6740817427635193f, _2423, (_2422 * 0.2722287178039551f)));
                          float _2433 = mad(1.0103391408920288f, _2424, mad(0.00406073359772563f, _2423, (_2422 * -0.005574649665504694f)));
                          float _2455 = min(max((min(max(mad(-0.23642469942569733f, _2433, mad(-0.32480329275131226f, _2430, (_2427 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2456 = min(max((min(max(mad(0.016756348311901093f, _2433, mad(1.6153316497802734f, _2430, (_2427 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2457 = min(max((min(max(mad(0.9883948564529419f, _2433, mad(-0.008284442126750946f, _2430, (_2427 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(OutputDevice == 6)) {
                              _2470 = mad(_53, _2457, mad(_52, _2456, (_2455 * _51)));
                              _2471 = mad(_56, _2457, mad(_55, _2456, (_2455 * _54)));
                              _2472 = mad(_59, _2457, mad(_58, _2456, (_2455 * _57)));
                            } else {
                              _2470 = _2455;
                              _2471 = _2456;
                              _2472 = _2457;
                            }
                            float _2482 = exp2(log2(_2470 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2483 = exp2(log2(_2471 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2484 = exp2(log2(_2472 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2649 = exp2(log2((1.0f / ((_2482 * 18.6875f) + 1.0f)) * ((_2482 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2650 = exp2(log2((1.0f / ((_2483 * 18.6875f) + 1.0f)) * ((_2483 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2651 = exp2(log2((1.0f / ((_2484 * 18.6875f) + 1.0f)) * ((_2484 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2529 = mad((WorkingColorSpace_128[0].z), _967, mad((WorkingColorSpace_128[0].y), _966, ((WorkingColorSpace_128[0].x) * _965)));
            float _2532 = mad((WorkingColorSpace_128[1].z), _967, mad((WorkingColorSpace_128[1].y), _966, ((WorkingColorSpace_128[1].x) * _965)));
            float _2535 = mad((WorkingColorSpace_128[2].z), _967, mad((WorkingColorSpace_128[2].y), _966, ((WorkingColorSpace_128[2].x) * _965)));
            float _2554 = exp2(log2(mad(_53, _2535, mad(_52, _2532, (_2529 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2555 = exp2(log2(mad(_56, _2535, mad(_55, _2532, (_2529 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2556 = exp2(log2(mad(_59, _2535, mad(_58, _2532, (_2529 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2649 = exp2(log2((1.0f / ((_2554 * 18.6875f) + 1.0f)) * ((_2554 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2650 = exp2(log2((1.0f / ((_2555 * 18.6875f) + 1.0f)) * ((_2555 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2651 = exp2(log2((1.0f / ((_2556 * 18.6875f) + 1.0f)) * ((_2556 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2603 = mad((WorkingColorSpace_128[0].z), _955, mad((WorkingColorSpace_128[0].y), _954, ((WorkingColorSpace_128[0].x) * _953)));
                float _2606 = mad((WorkingColorSpace_128[1].z), _955, mad((WorkingColorSpace_128[1].y), _954, ((WorkingColorSpace_128[1].x) * _953)));
                float _2609 = mad((WorkingColorSpace_128[2].z), _955, mad((WorkingColorSpace_128[2].y), _954, ((WorkingColorSpace_128[2].x) * _953)));
                _2649 = mad(_53, _2609, mad(_52, _2606, (_2603 * _51)));
                _2650 = mad(_56, _2609, mad(_55, _2606, (_2603 * _54)));
                _2651 = mad(_59, _2609, mad(_58, _2606, (_2603 * _57)));
              } else {
                float _2622 = mad((WorkingColorSpace_128[0].z), _981, mad((WorkingColorSpace_128[0].y), _980, ((WorkingColorSpace_128[0].x) * _979)));
                float _2625 = mad((WorkingColorSpace_128[1].z), _981, mad((WorkingColorSpace_128[1].y), _980, ((WorkingColorSpace_128[1].x) * _979)));
                float _2628 = mad((WorkingColorSpace_128[2].z), _981, mad((WorkingColorSpace_128[2].y), _980, ((WorkingColorSpace_128[2].x) * _979)));
                _2649 = exp2(log2(mad(_53, _2628, mad(_52, _2625, (_2622 * _51)))) * InverseGamma.z);
                _2650 = exp2(log2(mad(_56, _2628, mad(_55, _2625, (_2622 * _54)))) * InverseGamma.z);
                _2651 = exp2(log2(mad(_59, _2628, mad(_58, _2625, (_2622 * _57)))) * InverseGamma.z);
              }
            } else {
              _2649 = _965;
              _2650 = _966;
              _2651 = _967;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2649 * 0.9523810148239136f);
  SV_Target.y = (_2650 * 0.9523810148239136f);
  SV_Target.z = (_2651 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

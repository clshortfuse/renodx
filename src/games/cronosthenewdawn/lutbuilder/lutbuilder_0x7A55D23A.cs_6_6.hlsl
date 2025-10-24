#include "./filmiclutbuilder.hlsli"

RWTexture3D<float4> u0 : register(u0);

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  int WorkingColorSpace_320 : packoffset(c020.x);
};

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
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
  float _20[6];
  float _32 = 0.5f / LUTSize;
  float _37 = LUTSize + -1.0f;
  float _38 = (LUTSize * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _32)) / _37;
  float _39 = (LUTSize * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _32)) / _37;
  float _41 = float((uint)SV_DispatchThreadID.z) / _37;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _127;
  float _128;
  float _129;
  float _652;
  float _685;
  float _699;
  float _763;
  float _1031;
  float _1032;
  float _1033;
  float _1044;
  float _1055;
  float _1228;
  float _1243;
  float _1258;
  float _1266;
  float _1267;
  float _1268;
  float _1335;
  float _1368;
  float _1382;
  float _1421;
  float _1543;
  float _1629;
  float _1703;
  float _1782;
  float _1783;
  float _1784;
  float _1914;
  float _1929;
  float _1944;
  float _1952;
  float _1953;
  float _1954;
  float _2021;
  float _2054;
  float _2068;
  float _2107;
  float _2229;
  float _2315;
  float _2401;
  float _2480;
  float _2481;
  float _2482;
  float _2659;
  float _2660;
  float _2661;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _50 = (OutputGamut == 4);
        _61 = select(_50, 1.0f, 1.705051064491272f);
        _62 = select(_50, 0.0f, -0.6217921376228333f);
        _63 = select(_50, 0.0f, -0.0832589864730835f);
        _64 = select(_50, 0.0f, -0.13025647401809692f);
        _65 = select(_50, 1.0f, 1.140804648399353f);
        _66 = select(_50, 0.0f, -0.010548308491706848f);
        _67 = select(_50, 0.0f, -0.024003351107239723f);
        _68 = select(_50, 0.0f, -0.1289689838886261f);
        _69 = select(_50, 1.0f, 1.1529725790023804f);
      } else {
        _61 = 0.6954522132873535f;
        _62 = 0.14067870378494263f;
        _63 = 0.16386906802654266f;
        _64 = 0.044794563204050064f;
        _65 = 0.8596711158752441f;
        _66 = 0.0955343171954155f;
        _67 = -0.005525882821530104f;
        _68 = 0.004025210160762072f;
        _69 = 1.0015007257461548f;
      }
    } else {
      _61 = 1.0258246660232544f;
      _62 = -0.020053181797266006f;
      _63 = -0.005771636962890625f;
      _64 = -0.002234415616840124f;
      _65 = 1.0045864582061768f;
      _66 = -0.002352118492126465f;
      _67 = -0.005013350863009691f;
      _68 = -0.025290070101618767f;
      _69 = 1.0303035974502563f;
    }
  } else {
    _61 = 1.3792141675949097f;
    _62 = -0.30886411666870117f;
    _63 = -0.0703500509262085f;
    _64 = -0.06933490186929703f;
    _65 = 1.08229660987854f;
    _66 = -0.012961871922016144f;
    _67 = -0.0021590073592960835f;
    _68 = -0.0454593189060688f;
    _69 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)OutputDevice > (uint)2) {
    float _80 = (pow(_38, 0.012683313339948654f));
    float _81 = (pow(_39, 0.012683313339948654f));
    float _82 = (pow(_41, 0.012683313339948654f));
    _127 = (exp2(log2(max(0.0f, (_80 + -0.8359375f)) / (18.8515625f - (_80 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _128 = (exp2(log2(max(0.0f, (_81 + -0.8359375f)) / (18.8515625f - (_81 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _129 = (exp2(log2(max(0.0f, (_82 + -0.8359375f)) / (18.8515625f - (_82 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _127 = ((exp2((_38 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _128 = ((exp2((_39 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _129 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _144 = mad((WorkingColorSpace_128[0].z), _129, mad((WorkingColorSpace_128[0].y), _128, ((WorkingColorSpace_128[0].x) * _127)));
  float _147 = mad((WorkingColorSpace_128[1].z), _129, mad((WorkingColorSpace_128[1].y), _128, ((WorkingColorSpace_128[1].x) * _127)));
  float _150 = mad((WorkingColorSpace_128[2].z), _129, mad((WorkingColorSpace_128[2].y), _128, ((WorkingColorSpace_128[2].x) * _127)));
  float _151 = dot(float3(_144, _147, _150), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _155 = (_144 / _151) + -1.0f;
  float _156 = (_147 / _151) + -1.0f;
  float _157 = (_150 / _151) + -1.0f;
  float _169 = (1.0f - exp2(((_151 * _151) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_155, _156, _157), float3(_155, _156, _157)) * -4.0f));
  float _185 = ((mad(-0.06368321925401688f, _150, mad(-0.3292922377586365f, _147, (_144 * 1.3704125881195068f))) - _144) * _169) + _144;
  float _186 = ((mad(-0.010861365124583244f, _150, mad(1.0970927476882935f, _147, (_144 * -0.08343357592821121f))) - _147) * _169) + _147;
  float _187 = ((mad(1.2036951780319214f, _150, mad(-0.09862580895423889f, _147, (_144 * -0.02579331398010254f))) - _150) * _169) + _150;
  float _188 = dot(float3(_185, _186, _187), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float3 WorkingColor = float3(_185, _186, _187);
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

  float _592 = ((mad(0.061360642313957214f, WorkingColor.b, mad(-4.540197551250458e-09f, WorkingColor.g, (WorkingColor.r * 0.9386394023895264f))) - WorkingColor.r) * BlueCorrection) + WorkingColor.r;
  float _593 = ((mad(0.169205904006958f, WorkingColor.b, mad(0.8307942152023315f, WorkingColor.g, (WorkingColor.r * 6.775371730327606e-08f))) - WorkingColor.g) * BlueCorrection) + WorkingColor.g;
  float _594 = (mad(-2.3283064365386963e-10f, WorkingColor.g, (WorkingColor.r * -9.313225746154785e-10f)) * BlueCorrection) + WorkingColor.b;
  float _597 = mad(0.16386905312538147f, _594, mad(0.14067868888378143f, _593, (_592 * 0.6954522132873535f)));
  float _600 = mad(0.0955343246459961f, _594, mad(0.8596711158752441f, _593, (_592 * 0.044794581830501556f)));
  float _603 = mad(1.0015007257461548f, _594, mad(0.004025210160762072f, _593, (_592 * -0.005525882821530104f)));
  float _607 = max(max(_597, _600), _603);
  float _612 = (max(_607, 1.000000013351432e-10f) - max(min(min(_597, _600), _603), 1.000000013351432e-10f)) / max(_607, 0.009999999776482582f);
  float _625 = ((_600 + _597) + _603) + (sqrt((((_603 - _600) * _603) + ((_600 - _597) * _600)) + ((_597 - _603) * _597)) * 1.75f);
  float _626 = _625 * 0.3333333432674408f;
  float _627 = _612 + -0.4000000059604645f;
  float _628 = _627 * 5.0f;
  float _632 = max((1.0f - abs(_627 * 2.5f)), 0.0f);
  float _643 = ((float((int)(((int)(uint)((bool)(_628 > 0.0f))) - ((int)(uint)((bool)(_628 < 0.0f))))) * (1.0f - (_632 * _632))) + 1.0f) * 0.02500000037252903f;
  if (!(_626 <= 0.0533333346247673f)) {
    if (!(_626 >= 0.1599999964237213f)) {
      _652 = (((0.23999999463558197f / _625) + -0.5f) * _643);
    } else {
      _652 = 0.0f;
    }
  } else {
    _652 = _643;
  }
  float _653 = _652 + 1.0f;
  float _654 = _653 * _597;
  float _655 = _653 * _600;
  float _656 = _653 * _603;
  if (!((bool)(_654 == _655) && (bool)(_655 == _656))) {
    float _663 = ((_654 * 2.0f) - _655) - _656;
    float _666 = ((_600 - _603) * 1.7320507764816284f) * _653;
    float _668 = atan(_666 / _663);
    bool _671 = (_663 < 0.0f);
    bool _672 = (_663 == 0.0f);
    bool _673 = (_666 >= 0.0f);
    bool _674 = (_666 < 0.0f);
    _685 = select((_673 && _672), 90.0f, select((_674 && _672), -90.0f, (select((_674 && _671), (_668 + -3.1415927410125732f), select((_673 && _671), (_668 + 3.1415927410125732f), _668)) * 57.2957763671875f)));
  } else {
    _685 = 0.0f;
  }
  float _690 = min(max(select((_685 < 0.0f), (_685 + 360.0f), _685), 0.0f), 360.0f);
  if (_690 < -180.0f) {
    _699 = (_690 + 360.0f);
  } else {
    if (_690 > 180.0f) {
      _699 = (_690 + -360.0f);
    } else {
      _699 = _690;
    }
  }
  float _703 = saturate(1.0f - abs(_699 * 0.014814814552664757f));
  float _707 = (_703 * _703) * (3.0f - (_703 * 2.0f));
  float _713 = ((_707 * _707) * ((_612 * 0.18000000715255737f) * (0.029999999329447746f - _654))) + _654;
  float _723 = max(0.0f, mad(-0.21492856740951538f, _656, mad(-0.2365107536315918f, _655, (_713 * 1.4514392614364624f))));
  float _724 = max(0.0f, mad(-0.09967592358589172f, _656, mad(1.17622971534729f, _655, (_713 * -0.07655377686023712f))));
  float _725 = max(0.0f, mad(0.9977163076400757f, _656, mad(-0.006032449658960104f, _655, (_713 * 0.008316148072481155f))));
  float _726 = dot(float3(_723, _724, _725), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _741 = (FilmBlackClip + 1.0f) - FilmToe;
  float _743 = FilmWhiteClip + 1.0f;
  float _745 = _743 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _763 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _754 = (FilmBlackClip + 0.18000000715255737f) / _741;
    _763 = (-0.7447274923324585f - ((log2(_754 / (2.0f - _754)) * 0.3465735912322998f) * (_741 / FilmSlope)));
  }
  float _766 = ((1.0f - FilmToe) / FilmSlope) - _763;
  float _768 = (FilmShoulder / FilmSlope) - _766;

  float _914, _915, _916;
  if (is_hdr) {
    float3 lerpColor = lerp(_726, float3(_723, _724, _725), 0.9599999785423279f);
    ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b,
                       _592, _593, _594,
                       _914, _915, _916);
  } else {
  float _772 = log2(lerp(_726, _723, 0.9599999785423279f)) * 0.3010300099849701f;
  float _773 = log2(lerp(_726, _724, 0.9599999785423279f)) * 0.3010300099849701f;
  float _774 = log2(lerp(_726, _725, 0.9599999785423279f)) * 0.3010300099849701f;
  float _778 = FilmSlope * (_772 + _766);
  float _779 = FilmSlope * (_773 + _766);
  float _780 = FilmSlope * (_774 + _766);
  float _781 = _741 * 2.0f;
  float _783 = (FilmSlope * -2.0f) / _741;
  float _784 = _772 - _763;
  float _785 = _773 - _763;
  float _786 = _774 - _763;
  float _805 = _745 * 2.0f;
  float _807 = (FilmSlope * 2.0f) / _745;
  float _832 = select((_772 < _763), ((_781 / (exp2((_784 * 1.4426950216293335f) * _783) + 1.0f)) - FilmBlackClip), _778);
  float _833 = select((_773 < _763), ((_781 / (exp2((_785 * 1.4426950216293335f) * _783) + 1.0f)) - FilmBlackClip), _779);
  float _834 = select((_774 < _763), ((_781 / (exp2((_786 * 1.4426950216293335f) * _783) + 1.0f)) - FilmBlackClip), _780);
  float _841 = _768 - _763;
  float _845 = saturate(_784 / _841);
  float _846 = saturate(_785 / _841);
  float _847 = saturate(_786 / _841);
  bool _848 = (_768 < _763);
  float _852 = select(_848, (1.0f - _845), _845);
  float _853 = select(_848, (1.0f - _846), _846);
  float _854 = select(_848, (1.0f - _847), _847);
  float _873 = (((_852 * _852) * (select((_772 > _768), (_743 - (_805 / (exp2(((_772 - _768) * 1.4426950216293335f) * _807) + 1.0f))), _778) - _832)) * (3.0f - (_852 * 2.0f))) + _832;
  float _874 = (((_853 * _853) * (select((_773 > _768), (_743 - (_805 / (exp2(((_773 - _768) * 1.4426950216293335f) * _807) + 1.0f))), _779) - _833)) * (3.0f - (_853 * 2.0f))) + _833;
  float _875 = (((_854 * _854) * (select((_774 > _768), (_743 - (_805 / (exp2(((_774 - _768) * 1.4426950216293335f) * _807) + 1.0f))), _780) - _834)) * (3.0f - (_854 * 2.0f))) + _834;
  float _876 = dot(float3(_873, _874, _875), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _896 = (ToneCurveAmount * (max(0.0f, (lerp(_876, _873, 0.9300000071525574f))) - _592)) + _592;
  float _897 = (ToneCurveAmount * (max(0.0f, (lerp(_876, _874, 0.9300000071525574f))) - _593)) + _593;
  float _898 = (ToneCurveAmount * (max(0.0f, (lerp(_876, _875, 0.9300000071525574f))) - _594)) + _594;
  _914 = ((mad(-0.06537103652954102f, _898, mad(1.451815478503704e-06f, _897, (_896 * 1.065374732017517f))) - _896) * BlueCorrection) + _896;
  _915 = ((mad(-0.20366770029067993f, _898, mad(1.2036634683609009f, _897, (_896 * -2.57161445915699e-07f))) - _897) * BlueCorrection) + _897;
  _916 = ((mad(0.9999996423721313f, _898, mad(2.0954757928848267e-08f, _897, (_896 * 1.862645149230957e-08f))) - _898) * BlueCorrection) + _898;
  }
  float _926 = mad((WorkingColorSpace_192[0].z), _916, mad((WorkingColorSpace_192[0].y), _915, ((WorkingColorSpace_192[0].x) * _914)));
  float _927 = mad((WorkingColorSpace_192[1].z), _916, mad((WorkingColorSpace_192[1].y), _915, ((WorkingColorSpace_192[1].x) * _914)));
  float _928 = mad((WorkingColorSpace_192[2].z), _916, mad((WorkingColorSpace_192[2].y), _915, ((WorkingColorSpace_192[2].x) * _914)));
  if (!is_hdr) {
    _926 = max(0.0f, _926);
    _927 = max(0.0f, _927);
    _928 = max(0.0f, _928);
  }
  float _954 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _926)) * _926) + MappingPolynomial.z);
  float _955 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _927)) * _927) + MappingPolynomial.z);
  float _956 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _928)) * _928) + MappingPolynomial.z);
  float _963 = ((OverlayColor.x - _954) * OverlayColor.w) + _954;
  float _964 = ((OverlayColor.y - _955) * OverlayColor.w) + _955;
  float _965 = ((OverlayColor.z - _956) * OverlayColor.w) + _956;

  if (GenerateOutput(_963, _964, _965, u0[SV_DispatchThreadID])) {
    return;
  }

  float _966 = ColorScale.x * mad((WorkingColorSpace_192[0].z), WorkingColor.b, mad((WorkingColorSpace_192[0].y), WorkingColor.g, (WorkingColor.r * (WorkingColorSpace_192[0].x))));
  float _967 = ColorScale.y * mad((WorkingColorSpace_192[1].z), WorkingColor.b, mad((WorkingColorSpace_192[1].y), WorkingColor.g, ((WorkingColorSpace_192[1].x) * WorkingColor.r)));
  float _968 = ColorScale.z * mad((WorkingColorSpace_192[2].z), WorkingColor.b, mad((WorkingColorSpace_192[2].y), WorkingColor.g, ((WorkingColorSpace_192[2].x) * WorkingColor.r)));
  float _975 = ((OverlayColor.x - _966) * OverlayColor.w) + _966;
  float _976 = ((OverlayColor.y - _967) * OverlayColor.w) + _967;
  float _977 = ((OverlayColor.z - _968) * OverlayColor.w) + _968;
  float _989 = exp2(log2(max(0.0f, _963)) * InverseGamma.y);
  float _990 = exp2(log2(max(0.0f, _964)) * InverseGamma.y);
  float _991 = exp2(log2(max(0.0f, _965)) * InverseGamma.y);
  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1014 = mad((WorkingColorSpace_128[0].z), _991, mad((WorkingColorSpace_128[0].y), _990, ((WorkingColorSpace_128[0].x) * _989)));
        float _1017 = mad((WorkingColorSpace_128[1].z), _991, mad((WorkingColorSpace_128[1].y), _990, ((WorkingColorSpace_128[1].x) * _989)));
        float _1020 = mad((WorkingColorSpace_128[2].z), _991, mad((WorkingColorSpace_128[2].y), _990, ((WorkingColorSpace_128[2].x) * _989)));
        _1031 = mad(_63, _1020, mad(_62, _1017, (_1014 * _61)));
        _1032 = mad(_66, _1020, mad(_65, _1017, (_1014 * _64)));
        _1033 = mad(_69, _1020, mad(_68, _1017, (_1014 * _67)));
      } else {
        _1031 = _989;
        _1032 = _990;
        _1033 = _991;
      }
      do {
        if (_1031 < 0.0031306699384003878f) {
          _1044 = (_1031 * 12.920000076293945f);
        } else {
          _1044 = (((pow(_1031, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1032 < 0.0031306699384003878f) {
            _1055 = (_1032 * 12.920000076293945f);
          } else {
            _1055 = (((pow(_1032, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1033 < 0.0031306699384003878f) {
            _2659 = _1044;
            _2660 = _1055;
            _2661 = (_1033 * 12.920000076293945f);
          } else {
            _2659 = _1044;
            _2660 = _1055;
            _2661 = (((pow(_1033, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1082 = mad((WorkingColorSpace_128[0].z), _991, mad((WorkingColorSpace_128[0].y), _990, ((WorkingColorSpace_128[0].x) * _989)));
      float _1085 = mad((WorkingColorSpace_128[1].z), _991, mad((WorkingColorSpace_128[1].y), _990, ((WorkingColorSpace_128[1].x) * _989)));
      float _1088 = mad((WorkingColorSpace_128[2].z), _991, mad((WorkingColorSpace_128[2].y), _990, ((WorkingColorSpace_128[2].x) * _989)));
      float _1098 = max(6.103519990574569e-05f, mad(_63, _1088, mad(_62, _1085, (_1082 * _61))));
      float _1099 = max(6.103519990574569e-05f, mad(_66, _1088, mad(_65, _1085, (_1082 * _64))));
      float _1100 = max(6.103519990574569e-05f, mad(_69, _1088, mad(_68, _1085, (_1082 * _67))));
      _2659 = min((_1098 * 4.5f), ((exp2(log2(max(_1098, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2660 = min((_1099 * 4.5f), ((exp2(log2(max(_1099, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2661 = min((_1100 * 4.5f), ((exp2(log2(max(_1100, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1176 = ACESSceneColorMultiplier * _975;
        float _1177 = ACESSceneColorMultiplier * _976;
        float _1178 = ACESSceneColorMultiplier * _977;
        float _1181 = mad((WorkingColorSpace_256[0].z), _1178, mad((WorkingColorSpace_256[0].y), _1177, ((WorkingColorSpace_256[0].x) * _1176)));
        float _1184 = mad((WorkingColorSpace_256[1].z), _1178, mad((WorkingColorSpace_256[1].y), _1177, ((WorkingColorSpace_256[1].x) * _1176)));
        float _1187 = mad((WorkingColorSpace_256[2].z), _1178, mad((WorkingColorSpace_256[2].y), _1177, ((WorkingColorSpace_256[2].x) * _1176)));
        float _1190 = mad(-0.21492856740951538f, _1187, mad(-0.2365107536315918f, _1184, (_1181 * 1.4514392614364624f)));
        float _1193 = mad(-0.09967592358589172f, _1187, mad(1.17622971534729f, _1184, (_1181 * -0.07655377686023712f)));
        float _1196 = mad(0.9977163076400757f, _1187, mad(-0.006032449658960104f, _1184, (_1181 * 0.008316148072481155f)));
        float _1198 = max(_1190, max(_1193, _1196));
        do {
          if (!(_1198 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1181 < 0.0f) || (bool)(_1184 < 0.0f))) || (bool)(_1187 < 0.0f))) {
              float _1208 = abs(_1198);
              float _1209 = (_1198 - _1190) / _1208;
              float _1211 = (_1198 - _1193) / _1208;
              float _1213 = (_1198 - _1196) / _1208;
              do {
                if (!(_1209 < 0.8149999976158142f)) {
                  float _1216 = _1209 + -0.8149999976158142f;
                  _1228 = ((_1216 / exp2(log2(exp2(log2(_1216 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1228 = _1209;
                }
                do {
                  if (!(_1211 < 0.8029999732971191f)) {
                    float _1231 = _1211 + -0.8029999732971191f;
                    _1243 = ((_1231 / exp2(log2(exp2(log2(_1231 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1243 = _1211;
                  }
                  do {
                    if (!(_1213 < 0.8799999952316284f)) {
                      float _1246 = _1213 + -0.8799999952316284f;
                      _1258 = ((_1246 / exp2(log2(exp2(log2(_1246 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1258 = _1213;
                    }
                    _1266 = (_1198 - (_1208 * _1228));
                    _1267 = (_1198 - (_1208 * _1243));
                    _1268 = (_1198 - (_1208 * _1258));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1266 = _1190;
              _1267 = _1193;
              _1268 = _1196;
            }
          } else {
            _1266 = _1190;
            _1267 = _1193;
            _1268 = _1196;
          }
          float _1284 = ((mad(0.16386906802654266f, _1268, mad(0.14067870378494263f, _1267, (_1266 * 0.6954522132873535f))) - _1181) * ACESGamutCompression) + _1181;
          float _1285 = ((mad(0.0955343171954155f, _1268, mad(0.8596711158752441f, _1267, (_1266 * 0.044794563204050064f))) - _1184) * ACESGamutCompression) + _1184;
          float _1286 = ((mad(1.0015007257461548f, _1268, mad(0.004025210160762072f, _1267, (_1266 * -0.005525882821530104f))) - _1187) * ACESGamutCompression) + _1187;
          float _1290 = max(max(_1284, _1285), _1286);
          float _1295 = (max(_1290, 1.000000013351432e-10f) - max(min(min(_1284, _1285), _1286), 1.000000013351432e-10f)) / max(_1290, 0.009999999776482582f);
          float _1308 = ((_1285 + _1284) + _1286) + (sqrt((((_1286 - _1285) * _1286) + ((_1285 - _1284) * _1285)) + ((_1284 - _1286) * _1284)) * 1.75f);
          float _1309 = _1308 * 0.3333333432674408f;
          float _1310 = _1295 + -0.4000000059604645f;
          float _1311 = _1310 * 5.0f;
          float _1315 = max((1.0f - abs(_1310 * 2.5f)), 0.0f);
          float _1326 = ((float((int)(((int)(uint)((bool)(_1311 > 0.0f))) - ((int)(uint)((bool)(_1311 < 0.0f))))) * (1.0f - (_1315 * _1315))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1309 <= 0.0533333346247673f)) {
              if (!(_1309 >= 0.1599999964237213f)) {
                _1335 = (((0.23999999463558197f / _1308) + -0.5f) * _1326);
              } else {
                _1335 = 0.0f;
              }
            } else {
              _1335 = _1326;
            }
            float _1336 = _1335 + 1.0f;
            float _1337 = _1336 * _1284;
            float _1338 = _1336 * _1285;
            float _1339 = _1336 * _1286;
            do {
              if (!((bool)(_1337 == _1338) && (bool)(_1338 == _1339))) {
                float _1346 = ((_1337 * 2.0f) - _1338) - _1339;
                float _1349 = ((_1285 - _1286) * 1.7320507764816284f) * _1336;
                float _1351 = atan(_1349 / _1346);
                bool _1354 = (_1346 < 0.0f);
                bool _1355 = (_1346 == 0.0f);
                bool _1356 = (_1349 >= 0.0f);
                bool _1357 = (_1349 < 0.0f);
                _1368 = select((_1356 && _1355), 90.0f, select((_1357 && _1355), -90.0f, (select((_1357 && _1354), (_1351 + -3.1415927410125732f), select((_1356 && _1354), (_1351 + 3.1415927410125732f), _1351)) * 57.2957763671875f)));
              } else {
                _1368 = 0.0f;
              }
              float _1373 = min(max(select((_1368 < 0.0f), (_1368 + 360.0f), _1368), 0.0f), 360.0f);
              do {
                if (_1373 < -180.0f) {
                  _1382 = (_1373 + 360.0f);
                } else {
                  if (_1373 > 180.0f) {
                    _1382 = (_1373 + -360.0f);
                  } else {
                    _1382 = _1373;
                  }
                }
                do {
                  if ((bool)(_1382 > -67.5f) && (bool)(_1382 < 67.5f)) {
                    float _1388 = (_1382 + 67.5f) * 0.029629629105329514f;
                    int _1389 = int(_1388);
                    float _1391 = _1388 - float((int)(_1389));
                    float _1392 = _1391 * _1391;
                    float _1393 = _1392 * _1391;
                    if (_1389 == 3) {
                      _1421 = (((0.1666666716337204f - (_1391 * 0.5f)) + (_1392 * 0.5f)) - (_1393 * 0.1666666716337204f));
                    } else {
                      if (_1389 == 2) {
                        _1421 = ((0.6666666865348816f - _1392) + (_1393 * 0.5f));
                      } else {
                        if (_1389 == 1) {
                          _1421 = (((_1393 * -0.5f) + 0.1666666716337204f) + ((_1392 + _1391) * 0.5f));
                        } else {
                          _1421 = select((_1389 == 0), (_1393 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1421 = 0.0f;
                  }
                  float _1430 = min(max(((((_1295 * 0.27000001072883606f) * (0.029999999329447746f - _1337)) * _1421) + _1337), 0.0f), 65535.0f);
                  float _1431 = min(max(_1338, 0.0f), 65535.0f);
                  float _1432 = min(max(_1339, 0.0f), 65535.0f);
                  float _1445 = min(max(mad(-0.21492856740951538f, _1432, mad(-0.2365107536315918f, _1431, (_1430 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1446 = min(max(mad(-0.09967592358589172f, _1432, mad(1.17622971534729f, _1431, (_1430 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1447 = min(max(mad(0.9977163076400757f, _1432, mad(-0.006032449658960104f, _1431, (_1430 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1448 = dot(float3(_1445, _1446, _1447), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  _17[0] = ACESCoefsLow_0.x;
                  _17[1] = ACESCoefsLow_0.y;
                  _17[2] = ACESCoefsLow_0.z;
                  _17[3] = ACESCoefsLow_0.w;
                  _17[4] = ACESCoefsLow_4;
                  _17[5] = ACESCoefsLow_4;
                  _18[0] = ACESCoefsHigh_0.x;
                  _18[1] = ACESCoefsHigh_0.y;
                  _18[2] = ACESCoefsHigh_0.z;
                  _18[3] = ACESCoefsHigh_0.w;
                  _18[4] = ACESCoefsHigh_4;
                  _18[5] = ACESCoefsHigh_4;
                  float _1471 = log2(max((lerp(_1448, _1445, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1472 = _1471 * 0.3010300099849701f;
                  float _1473 = log2(ACESMinMaxData.x);
                  float _1474 = _1473 * 0.3010300099849701f;
                  do {
                    if (!(!(_1472 <= _1474))) {
                      _1543 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1481 = log2(ACESMidData.x);
                      float _1482 = _1481 * 0.3010300099849701f;
                      if ((bool)(_1472 > _1474) && (bool)(_1472 < _1482)) {
                        float _1490 = ((_1471 - _1473) * 0.9030900001525879f) / ((_1481 - _1473) * 0.3010300099849701f);
                        int _1491 = int(_1490);
                        float _1493 = _1490 - float((int)(_1491));
                        float _1495 = _17[_1491];
                        float _1498 = _17[(_1491 + 1)];
                        float _1503 = _1495 * 0.5f;
                        _1543 = dot(float3((_1493 * _1493), _1493, 1.0f), float3(mad((_17[(_1491 + 2)]), 0.5f, mad(_1498, -1.0f, _1503)), (_1498 - _1495), mad(_1498, 0.5f, _1503)));
                      } else {
                        do {
                          if (!(!(_1472 >= _1482))) {
                            float _1512 = log2(ACESMinMaxData.z);
                            if (_1472 < (_1512 * 0.3010300099849701f)) {
                              float _1520 = ((_1471 - _1481) * 0.9030900001525879f) / ((_1512 - _1481) * 0.3010300099849701f);
                              int _1521 = int(_1520);
                              float _1523 = _1520 - float((int)(_1521));
                              float _1525 = _18[_1521];
                              float _1528 = _18[(_1521 + 1)];
                              float _1533 = _1525 * 0.5f;
                              _1543 = dot(float3((_1523 * _1523), _1523, 1.0f), float3(mad((_18[(_1521 + 2)]), 0.5f, mad(_1528, -1.0f, _1533)), (_1528 - _1525), mad(_1528, 0.5f, _1533)));
                              break;
                            }
                          }
                          _1543 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _19[0] = ACESCoefsLow_0.x;
                    _19[1] = ACESCoefsLow_0.y;
                    _19[2] = ACESCoefsLow_0.z;
                    _19[3] = ACESCoefsLow_0.w;
                    _19[4] = ACESCoefsLow_4;
                    _19[5] = ACESCoefsLow_4;
                    _20[0] = ACESCoefsHigh_0.x;
                    _20[1] = ACESCoefsHigh_0.y;
                    _20[2] = ACESCoefsHigh_0.z;
                    _20[3] = ACESCoefsHigh_0.w;
                    _20[4] = ACESCoefsHigh_4;
                    _20[5] = ACESCoefsHigh_4;
                    float _1559 = log2(max((lerp(_1448, _1446, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1560 = _1559 * 0.3010300099849701f;
                    do {
                      if (!(!(_1560 <= _1474))) {
                        _1629 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1567 = log2(ACESMidData.x);
                        float _1568 = _1567 * 0.3010300099849701f;
                        if ((bool)(_1560 > _1474) && (bool)(_1560 < _1568)) {
                          float _1576 = ((_1559 - _1473) * 0.9030900001525879f) / ((_1567 - _1473) * 0.3010300099849701f);
                          int _1577 = int(_1576);
                          float _1579 = _1576 - float((int)(_1577));
                          float _1581 = _19[_1577];
                          float _1584 = _19[(_1577 + 1)];
                          float _1589 = _1581 * 0.5f;
                          _1629 = dot(float3((_1579 * _1579), _1579, 1.0f), float3(mad((_19[(_1577 + 2)]), 0.5f, mad(_1584, -1.0f, _1589)), (_1584 - _1581), mad(_1584, 0.5f, _1589)));
                        } else {
                          do {
                            if (!(!(_1560 >= _1568))) {
                              float _1598 = log2(ACESMinMaxData.z);
                              if (_1560 < (_1598 * 0.3010300099849701f)) {
                                float _1606 = ((_1559 - _1567) * 0.9030900001525879f) / ((_1598 - _1567) * 0.3010300099849701f);
                                int _1607 = int(_1606);
                                float _1609 = _1606 - float((int)(_1607));
                                float _1611 = _20[_1607];
                                float _1614 = _20[(_1607 + 1)];
                                float _1619 = _1611 * 0.5f;
                                _1629 = dot(float3((_1609 * _1609), _1609, 1.0f), float3(mad((_20[(_1607 + 2)]), 0.5f, mad(_1614, -1.0f, _1619)), (_1614 - _1611), mad(_1614, 0.5f, _1619)));
                                break;
                              }
                            }
                            _1629 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1633 = log2(max((lerp(_1448, _1447, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1634 = _1633 * 0.3010300099849701f;
                      do {
                        if (!(!(_1634 <= _1474))) {
                          _1703 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1641 = log2(ACESMidData.x);
                          float _1642 = _1641 * 0.3010300099849701f;
                          if ((bool)(_1634 > _1474) && (bool)(_1634 < _1642)) {
                            float _1650 = ((_1633 - _1473) * 0.9030900001525879f) / ((_1641 - _1473) * 0.3010300099849701f);
                            int _1651 = int(_1650);
                            float _1653 = _1650 - float((int)(_1651));
                            float _1655 = _9[_1651];
                            float _1658 = _9[(_1651 + 1)];
                            float _1663 = _1655 * 0.5f;
                            _1703 = dot(float3((_1653 * _1653), _1653, 1.0f), float3(mad((_9[(_1651 + 2)]), 0.5f, mad(_1658, -1.0f, _1663)), (_1658 - _1655), mad(_1658, 0.5f, _1663)));
                          } else {
                            do {
                              if (!(!(_1634 >= _1642))) {
                                float _1672 = log2(ACESMinMaxData.z);
                                if (_1634 < (_1672 * 0.3010300099849701f)) {
                                  float _1680 = ((_1633 - _1641) * 0.9030900001525879f) / ((_1672 - _1641) * 0.3010300099849701f);
                                  int _1681 = int(_1680);
                                  float _1683 = _1680 - float((int)(_1681));
                                  float _1685 = _10[_1681];
                                  float _1688 = _10[(_1681 + 1)];
                                  float _1693 = _1685 * 0.5f;
                                  _1703 = dot(float3((_1683 * _1683), _1683, 1.0f), float3(mad((_10[(_1681 + 2)]), 0.5f, mad(_1688, -1.0f, _1693)), (_1688 - _1685), mad(_1688, 0.5f, _1693)));
                                  break;
                                }
                              }
                              _1703 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1707 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1708 = (exp2(_1543 * 3.321928024291992f) - ACESMinMaxData.y) / _1707;
                        float _1710 = (exp2(_1629 * 3.321928024291992f) - ACESMinMaxData.y) / _1707;
                        float _1712 = (exp2(_1703 * 3.321928024291992f) - ACESMinMaxData.y) / _1707;
                        float _1715 = mad(0.15618768334388733f, _1712, mad(0.13400420546531677f, _1710, (_1708 * 0.6624541878700256f)));
                        float _1718 = mad(0.053689517080783844f, _1712, mad(0.6740817427635193f, _1710, (_1708 * 0.2722287178039551f)));
                        float _1721 = mad(1.0103391408920288f, _1712, mad(0.00406073359772563f, _1710, (_1708 * -0.005574649665504694f)));
                        float _1734 = min(max(mad(-0.23642469942569733f, _1721, mad(-0.32480329275131226f, _1718, (_1715 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1735 = min(max(mad(0.016756348311901093f, _1721, mad(1.6153316497802734f, _1718, (_1715 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1736 = min(max(mad(0.9883948564529419f, _1721, mad(-0.008284442126750946f, _1718, (_1715 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1739 = mad(0.15618768334388733f, _1736, mad(0.13400420546531677f, _1735, (_1734 * 0.6624541878700256f)));
                        float _1742 = mad(0.053689517080783844f, _1736, mad(0.6740817427635193f, _1735, (_1734 * 0.2722287178039551f)));
                        float _1745 = mad(1.0103391408920288f, _1736, mad(0.00406073359772563f, _1735, (_1734 * -0.005574649665504694f)));
                        float _1767 = min(max((min(max(mad(-0.23642469942569733f, _1745, mad(-0.32480329275131226f, _1742, (_1739 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1768 = min(max((min(max(mad(0.016756348311901093f, _1745, mad(1.6153316497802734f, _1742, (_1739 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1769 = min(max((min(max(mad(0.9883948564529419f, _1745, mad(-0.008284442126750946f, _1742, (_1739 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 5)) {
                            _1782 = mad(_63, _1769, mad(_62, _1768, (_1767 * _61)));
                            _1783 = mad(_66, _1769, mad(_65, _1768, (_1767 * _64)));
                            _1784 = mad(_69, _1769, mad(_68, _1768, (_1767 * _67)));
                          } else {
                            _1782 = _1767;
                            _1783 = _1768;
                            _1784 = _1769;
                          }
                          float _1794 = exp2(log2(_1782 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1795 = exp2(log2(_1783 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1796 = exp2(log2(_1784 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2659 = exp2(log2((1.0f / ((_1794 * 18.6875f) + 1.0f)) * ((_1794 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2660 = exp2(log2((1.0f / ((_1795 * 18.6875f) + 1.0f)) * ((_1795 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2661 = exp2(log2((1.0f / ((_1796 * 18.6875f) + 1.0f)) * ((_1796 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1862 = ACESSceneColorMultiplier * _975;
          float _1863 = ACESSceneColorMultiplier * _976;
          float _1864 = ACESSceneColorMultiplier * _977;
          float _1867 = mad((WorkingColorSpace_256[0].z), _1864, mad((WorkingColorSpace_256[0].y), _1863, ((WorkingColorSpace_256[0].x) * _1862)));
          float _1870 = mad((WorkingColorSpace_256[1].z), _1864, mad((WorkingColorSpace_256[1].y), _1863, ((WorkingColorSpace_256[1].x) * _1862)));
          float _1873 = mad((WorkingColorSpace_256[2].z), _1864, mad((WorkingColorSpace_256[2].y), _1863, ((WorkingColorSpace_256[2].x) * _1862)));
          float _1876 = mad(-0.21492856740951538f, _1873, mad(-0.2365107536315918f, _1870, (_1867 * 1.4514392614364624f)));
          float _1879 = mad(-0.09967592358589172f, _1873, mad(1.17622971534729f, _1870, (_1867 * -0.07655377686023712f)));
          float _1882 = mad(0.9977163076400757f, _1873, mad(-0.006032449658960104f, _1870, (_1867 * 0.008316148072481155f)));
          float _1884 = max(_1876, max(_1879, _1882));
          do {
            if (!(_1884 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1867 < 0.0f) || (bool)(_1870 < 0.0f))) || (bool)(_1873 < 0.0f))) {
                float _1894 = abs(_1884);
                float _1895 = (_1884 - _1876) / _1894;
                float _1897 = (_1884 - _1879) / _1894;
                float _1899 = (_1884 - _1882) / _1894;
                do {
                  if (!(_1895 < 0.8149999976158142f)) {
                    float _1902 = _1895 + -0.8149999976158142f;
                    _1914 = ((_1902 / exp2(log2(exp2(log2(_1902 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _1914 = _1895;
                  }
                  do {
                    if (!(_1897 < 0.8029999732971191f)) {
                      float _1917 = _1897 + -0.8029999732971191f;
                      _1929 = ((_1917 / exp2(log2(exp2(log2(_1917 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _1929 = _1897;
                    }
                    do {
                      if (!(_1899 < 0.8799999952316284f)) {
                        float _1932 = _1899 + -0.8799999952316284f;
                        _1944 = ((_1932 / exp2(log2(exp2(log2(_1932 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _1944 = _1899;
                      }
                      _1952 = (_1884 - (_1894 * _1914));
                      _1953 = (_1884 - (_1894 * _1929));
                      _1954 = (_1884 - (_1894 * _1944));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _1952 = _1876;
                _1953 = _1879;
                _1954 = _1882;
              }
            } else {
              _1952 = _1876;
              _1953 = _1879;
              _1954 = _1882;
            }
            float _1970 = ((mad(0.16386906802654266f, _1954, mad(0.14067870378494263f, _1953, (_1952 * 0.6954522132873535f))) - _1867) * ACESGamutCompression) + _1867;
            float _1971 = ((mad(0.0955343171954155f, _1954, mad(0.8596711158752441f, _1953, (_1952 * 0.044794563204050064f))) - _1870) * ACESGamutCompression) + _1870;
            float _1972 = ((mad(1.0015007257461548f, _1954, mad(0.004025210160762072f, _1953, (_1952 * -0.005525882821530104f))) - _1873) * ACESGamutCompression) + _1873;
            float _1976 = max(max(_1970, _1971), _1972);
            float _1981 = (max(_1976, 1.000000013351432e-10f) - max(min(min(_1970, _1971), _1972), 1.000000013351432e-10f)) / max(_1976, 0.009999999776482582f);
            float _1994 = ((_1971 + _1970) + _1972) + (sqrt((((_1972 - _1971) * _1972) + ((_1971 - _1970) * _1971)) + ((_1970 - _1972) * _1970)) * 1.75f);
            float _1995 = _1994 * 0.3333333432674408f;
            float _1996 = _1981 + -0.4000000059604645f;
            float _1997 = _1996 * 5.0f;
            float _2001 = max((1.0f - abs(_1996 * 2.5f)), 0.0f);
            float _2012 = ((float((int)(((int)(uint)((bool)(_1997 > 0.0f))) - ((int)(uint)((bool)(_1997 < 0.0f))))) * (1.0f - (_2001 * _2001))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_1995 <= 0.0533333346247673f)) {
                if (!(_1995 >= 0.1599999964237213f)) {
                  _2021 = (((0.23999999463558197f / _1994) + -0.5f) * _2012);
                } else {
                  _2021 = 0.0f;
                }
              } else {
                _2021 = _2012;
              }
              float _2022 = _2021 + 1.0f;
              float _2023 = _2022 * _1970;
              float _2024 = _2022 * _1971;
              float _2025 = _2022 * _1972;
              do {
                if (!((bool)(_2023 == _2024) && (bool)(_2024 == _2025))) {
                  float _2032 = ((_2023 * 2.0f) - _2024) - _2025;
                  float _2035 = ((_1971 - _1972) * 1.7320507764816284f) * _2022;
                  float _2037 = atan(_2035 / _2032);
                  bool _2040 = (_2032 < 0.0f);
                  bool _2041 = (_2032 == 0.0f);
                  bool _2042 = (_2035 >= 0.0f);
                  bool _2043 = (_2035 < 0.0f);
                  _2054 = select((_2042 && _2041), 90.0f, select((_2043 && _2041), -90.0f, (select((_2043 && _2040), (_2037 + -3.1415927410125732f), select((_2042 && _2040), (_2037 + 3.1415927410125732f), _2037)) * 57.2957763671875f)));
                } else {
                  _2054 = 0.0f;
                }
                float _2059 = min(max(select((_2054 < 0.0f), (_2054 + 360.0f), _2054), 0.0f), 360.0f);
                do {
                  if (_2059 < -180.0f) {
                    _2068 = (_2059 + 360.0f);
                  } else {
                    if (_2059 > 180.0f) {
                      _2068 = (_2059 + -360.0f);
                    } else {
                      _2068 = _2059;
                    }
                  }
                  do {
                    if ((bool)(_2068 > -67.5f) && (bool)(_2068 < 67.5f)) {
                      float _2074 = (_2068 + 67.5f) * 0.029629629105329514f;
                      int _2075 = int(_2074);
                      float _2077 = _2074 - float((int)(_2075));
                      float _2078 = _2077 * _2077;
                      float _2079 = _2078 * _2077;
                      if (_2075 == 3) {
                        _2107 = (((0.1666666716337204f - (_2077 * 0.5f)) + (_2078 * 0.5f)) - (_2079 * 0.1666666716337204f));
                      } else {
                        if (_2075 == 2) {
                          _2107 = ((0.6666666865348816f - _2078) + (_2079 * 0.5f));
                        } else {
                          if (_2075 == 1) {
                            _2107 = (((_2079 * -0.5f) + 0.1666666716337204f) + ((_2078 + _2077) * 0.5f));
                          } else {
                            _2107 = select((_2075 == 0), (_2079 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2107 = 0.0f;
                    }
                    float _2116 = min(max(((((_1981 * 0.27000001072883606f) * (0.029999999329447746f - _2023)) * _2107) + _2023), 0.0f), 65535.0f);
                    float _2117 = min(max(_2024, 0.0f), 65535.0f);
                    float _2118 = min(max(_2025, 0.0f), 65535.0f);
                    float _2131 = min(max(mad(-0.21492856740951538f, _2118, mad(-0.2365107536315918f, _2117, (_2116 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2132 = min(max(mad(-0.09967592358589172f, _2118, mad(1.17622971534729f, _2117, (_2116 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2133 = min(max(mad(0.9977163076400757f, _2118, mad(-0.006032449658960104f, _2117, (_2116 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2134 = dot(float3(_2131, _2132, _2133), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    _15[0] = ACESCoefsLow_0.x;
                    _15[1] = ACESCoefsLow_0.y;
                    _15[2] = ACESCoefsLow_0.z;
                    _15[3] = ACESCoefsLow_0.w;
                    _15[4] = ACESCoefsLow_4;
                    _15[5] = ACESCoefsLow_4;
                    _16[0] = ACESCoefsHigh_0.x;
                    _16[1] = ACESCoefsHigh_0.y;
                    _16[2] = ACESCoefsHigh_0.z;
                    _16[3] = ACESCoefsHigh_0.w;
                    _16[4] = ACESCoefsHigh_4;
                    _16[5] = ACESCoefsHigh_4;
                    float _2157 = log2(max((lerp(_2134, _2131, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2158 = _2157 * 0.3010300099849701f;
                    float _2159 = log2(ACESMinMaxData.x);
                    float _2160 = _2159 * 0.3010300099849701f;
                    do {
                      if (!(!(_2158 <= _2160))) {
                        _2229 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2167 = log2(ACESMidData.x);
                        float _2168 = _2167 * 0.3010300099849701f;
                        if ((bool)(_2158 > _2160) && (bool)(_2158 < _2168)) {
                          float _2176 = ((_2157 - _2159) * 0.9030900001525879f) / ((_2167 - _2159) * 0.3010300099849701f);
                          int _2177 = int(_2176);
                          float _2179 = _2176 - float((int)(_2177));
                          float _2181 = _15[_2177];
                          float _2184 = _15[(_2177 + 1)];
                          float _2189 = _2181 * 0.5f;
                          _2229 = dot(float3((_2179 * _2179), _2179, 1.0f), float3(mad((_15[(_2177 + 2)]), 0.5f, mad(_2184, -1.0f, _2189)), (_2184 - _2181), mad(_2184, 0.5f, _2189)));
                        } else {
                          do {
                            if (!(!(_2158 >= _2168))) {
                              float _2198 = log2(ACESMinMaxData.z);
                              if (_2158 < (_2198 * 0.3010300099849701f)) {
                                float _2206 = ((_2157 - _2167) * 0.9030900001525879f) / ((_2198 - _2167) * 0.3010300099849701f);
                                int _2207 = int(_2206);
                                float _2209 = _2206 - float((int)(_2207));
                                float _2211 = _16[_2207];
                                float _2214 = _16[(_2207 + 1)];
                                float _2219 = _2211 * 0.5f;
                                _2229 = dot(float3((_2209 * _2209), _2209, 1.0f), float3(mad((_16[(_2207 + 2)]), 0.5f, mad(_2214, -1.0f, _2219)), (_2214 - _2211), mad(_2214, 0.5f, _2219)));
                                break;
                              }
                            }
                            _2229 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
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
                      float _2245 = log2(max((lerp(_2134, _2132, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2246 = _2245 * 0.3010300099849701f;
                      do {
                        if (!(!(_2246 <= _2160))) {
                          _2315 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2253 = log2(ACESMidData.x);
                          float _2254 = _2253 * 0.3010300099849701f;
                          if ((bool)(_2246 > _2160) && (bool)(_2246 < _2254)) {
                            float _2262 = ((_2245 - _2159) * 0.9030900001525879f) / ((_2253 - _2159) * 0.3010300099849701f);
                            int _2263 = int(_2262);
                            float _2265 = _2262 - float((int)(_2263));
                            float _2267 = _11[_2263];
                            float _2270 = _11[(_2263 + 1)];
                            float _2275 = _2267 * 0.5f;
                            _2315 = dot(float3((_2265 * _2265), _2265, 1.0f), float3(mad((_11[(_2263 + 2)]), 0.5f, mad(_2270, -1.0f, _2275)), (_2270 - _2267), mad(_2270, 0.5f, _2275)));
                          } else {
                            do {
                              if (!(!(_2246 >= _2254))) {
                                float _2284 = log2(ACESMinMaxData.z);
                                if (_2246 < (_2284 * 0.3010300099849701f)) {
                                  float _2292 = ((_2245 - _2253) * 0.9030900001525879f) / ((_2284 - _2253) * 0.3010300099849701f);
                                  int _2293 = int(_2292);
                                  float _2295 = _2292 - float((int)(_2293));
                                  float _2297 = _12[_2293];
                                  float _2300 = _12[(_2293 + 1)];
                                  float _2305 = _2297 * 0.5f;
                                  _2315 = dot(float3((_2295 * _2295), _2295, 1.0f), float3(mad((_12[(_2293 + 2)]), 0.5f, mad(_2300, -1.0f, _2305)), (_2300 - _2297), mad(_2300, 0.5f, _2305)));
                                  break;
                                }
                              }
                              _2315 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
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
                        float _2331 = log2(max((lerp(_2134, _2133, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2332 = _2331 * 0.3010300099849701f;
                        do {
                          if (!(!(_2332 <= _2160))) {
                            _2401 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2339 = log2(ACESMidData.x);
                            float _2340 = _2339 * 0.3010300099849701f;
                            if ((bool)(_2332 > _2160) && (bool)(_2332 < _2340)) {
                              float _2348 = ((_2331 - _2159) * 0.9030900001525879f) / ((_2339 - _2159) * 0.3010300099849701f);
                              int _2349 = int(_2348);
                              float _2351 = _2348 - float((int)(_2349));
                              float _2353 = _13[_2349];
                              float _2356 = _13[(_2349 + 1)];
                              float _2361 = _2353 * 0.5f;
                              _2401 = dot(float3((_2351 * _2351), _2351, 1.0f), float3(mad((_13[(_2349 + 2)]), 0.5f, mad(_2356, -1.0f, _2361)), (_2356 - _2353), mad(_2356, 0.5f, _2361)));
                            } else {
                              do {
                                if (!(!(_2332 >= _2340))) {
                                  float _2370 = log2(ACESMinMaxData.z);
                                  if (_2332 < (_2370 * 0.3010300099849701f)) {
                                    float _2378 = ((_2331 - _2339) * 0.9030900001525879f) / ((_2370 - _2339) * 0.3010300099849701f);
                                    int _2379 = int(_2378);
                                    float _2381 = _2378 - float((int)(_2379));
                                    float _2383 = _14[_2379];
                                    float _2386 = _14[(_2379 + 1)];
                                    float _2391 = _2383 * 0.5f;
                                    _2401 = dot(float3((_2381 * _2381), _2381, 1.0f), float3(mad((_14[(_2379 + 2)]), 0.5f, mad(_2386, -1.0f, _2391)), (_2386 - _2383), mad(_2386, 0.5f, _2391)));
                                    break;
                                  }
                                }
                                _2401 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2405 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2406 = (exp2(_2229 * 3.321928024291992f) - ACESMinMaxData.y) / _2405;
                          float _2408 = (exp2(_2315 * 3.321928024291992f) - ACESMinMaxData.y) / _2405;
                          float _2410 = (exp2(_2401 * 3.321928024291992f) - ACESMinMaxData.y) / _2405;
                          float _2413 = mad(0.15618768334388733f, _2410, mad(0.13400420546531677f, _2408, (_2406 * 0.6624541878700256f)));
                          float _2416 = mad(0.053689517080783844f, _2410, mad(0.6740817427635193f, _2408, (_2406 * 0.2722287178039551f)));
                          float _2419 = mad(1.0103391408920288f, _2410, mad(0.00406073359772563f, _2408, (_2406 * -0.005574649665504694f)));
                          float _2432 = min(max(mad(-0.23642469942569733f, _2419, mad(-0.32480329275131226f, _2416, (_2413 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2433 = min(max(mad(0.016756348311901093f, _2419, mad(1.6153316497802734f, _2416, (_2413 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2434 = min(max(mad(0.9883948564529419f, _2419, mad(-0.008284442126750946f, _2416, (_2413 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2437 = mad(0.15618768334388733f, _2434, mad(0.13400420546531677f, _2433, (_2432 * 0.6624541878700256f)));
                          float _2440 = mad(0.053689517080783844f, _2434, mad(0.6740817427635193f, _2433, (_2432 * 0.2722287178039551f)));
                          float _2443 = mad(1.0103391408920288f, _2434, mad(0.00406073359772563f, _2433, (_2432 * -0.005574649665504694f)));
                          float _2465 = min(max((min(max(mad(-0.23642469942569733f, _2443, mad(-0.32480329275131226f, _2440, (_2437 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2466 = min(max((min(max(mad(0.016756348311901093f, _2443, mad(1.6153316497802734f, _2440, (_2437 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2467 = min(max((min(max(mad(0.9883948564529419f, _2443, mad(-0.008284442126750946f, _2440, (_2437 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(OutputDevice == 6)) {
                              _2480 = mad(_63, _2467, mad(_62, _2466, (_2465 * _61)));
                              _2481 = mad(_66, _2467, mad(_65, _2466, (_2465 * _64)));
                              _2482 = mad(_69, _2467, mad(_68, _2466, (_2465 * _67)));
                            } else {
                              _2480 = _2465;
                              _2481 = _2466;
                              _2482 = _2467;
                            }
                            float _2492 = exp2(log2(_2480 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2493 = exp2(log2(_2481 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2494 = exp2(log2(_2482 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2659 = exp2(log2((1.0f / ((_2492 * 18.6875f) + 1.0f)) * ((_2492 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2660 = exp2(log2((1.0f / ((_2493 * 18.6875f) + 1.0f)) * ((_2493 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2661 = exp2(log2((1.0f / ((_2494 * 18.6875f) + 1.0f)) * ((_2494 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2539 = mad((WorkingColorSpace_128[0].z), _977, mad((WorkingColorSpace_128[0].y), _976, ((WorkingColorSpace_128[0].x) * _975)));
            float _2542 = mad((WorkingColorSpace_128[1].z), _977, mad((WorkingColorSpace_128[1].y), _976, ((WorkingColorSpace_128[1].x) * _975)));
            float _2545 = mad((WorkingColorSpace_128[2].z), _977, mad((WorkingColorSpace_128[2].y), _976, ((WorkingColorSpace_128[2].x) * _975)));
            float _2564 = exp2(log2(mad(_63, _2545, mad(_62, _2542, (_2539 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2565 = exp2(log2(mad(_66, _2545, mad(_65, _2542, (_2539 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2566 = exp2(log2(mad(_69, _2545, mad(_68, _2542, (_2539 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2659 = exp2(log2((1.0f / ((_2564 * 18.6875f) + 1.0f)) * ((_2564 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2660 = exp2(log2((1.0f / ((_2565 * 18.6875f) + 1.0f)) * ((_2565 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2661 = exp2(log2((1.0f / ((_2566 * 18.6875f) + 1.0f)) * ((_2566 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2613 = mad((WorkingColorSpace_128[0].z), _965, mad((WorkingColorSpace_128[0].y), _964, ((WorkingColorSpace_128[0].x) * _963)));
                float _2616 = mad((WorkingColorSpace_128[1].z), _965, mad((WorkingColorSpace_128[1].y), _964, ((WorkingColorSpace_128[1].x) * _963)));
                float _2619 = mad((WorkingColorSpace_128[2].z), _965, mad((WorkingColorSpace_128[2].y), _964, ((WorkingColorSpace_128[2].x) * _963)));
                _2659 = mad(_63, _2619, mad(_62, _2616, (_2613 * _61)));
                _2660 = mad(_66, _2619, mad(_65, _2616, (_2613 * _64)));
                _2661 = mad(_69, _2619, mad(_68, _2616, (_2613 * _67)));
              } else {
                float _2632 = mad((WorkingColorSpace_128[0].z), _991, mad((WorkingColorSpace_128[0].y), _990, ((WorkingColorSpace_128[0].x) * _989)));
                float _2635 = mad((WorkingColorSpace_128[1].z), _991, mad((WorkingColorSpace_128[1].y), _990, ((WorkingColorSpace_128[1].x) * _989)));
                float _2638 = mad((WorkingColorSpace_128[2].z), _991, mad((WorkingColorSpace_128[2].y), _990, ((WorkingColorSpace_128[2].x) * _989)));
                _2659 = exp2(log2(mad(_63, _2638, mad(_62, _2635, (_2632 * _61)))) * InverseGamma.z);
                _2660 = exp2(log2(mad(_66, _2638, mad(_65, _2635, (_2632 * _64)))) * InverseGamma.z);
                _2661 = exp2(log2(mad(_69, _2638, mad(_68, _2635, (_2632 * _67)))) * InverseGamma.z);
              }
            } else {
              _2659 = _975;
              _2660 = _976;
              _2661 = _977;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2659 * 0.9523810148239136f), (_2660 * 0.9523810148239136f), (_2661 * 0.9523810148239136f), 0.0f);
}

#include "./filmiclutbuilder.hlsl"

Texture2D<float4> Textures_1 : register(t0);

cbuffer UniformBufferConstants_WorkingColorSpace : register(b1) {
  float4 WorkingColorSpace_ToXYZ[4] : packoffset(c000.x);
  float4 WorkingColorSpace_FromXYZ[4] : packoffset(c004.x);
  float4 WorkingColorSpace_ToAP1[4] : packoffset(c008.x);
  float4 WorkingColorSpace_FromAP1[4] : packoffset(c012.x);
  float4 WorkingColorSpace_ToAP0[4] : packoffset(c016.x);
  uint WorkingColorSpace_bIsSRGB : packoffset(c020.x);
};

SamplerState Samplers_1 : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex
) : SV_Target {
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;

  float4 output_color;

  float4 SV_Target;
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _16 = 0.5f / LUTSize;
  float _21 = LUTSize + -1.0f;
  float _22 = (LUTSize * (TEXCOORD.x - _16)) / _21;
  float _23 = (LUTSize * (TEXCOORD.y - _16)) / _21;
  float _25 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _21;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _111;
  float _112;
  float _113;
  float _636;
  float _669;
  float _683;
  float _747;
  float _926;
  float _937;
  float _948;
  float _1146;
  float _1147;
  float _1148;
  float _1159;
  float _1170;
  float _1350;
  float _1383;
  float _1397;
  float _1436;
  float _1546;
  float _1620;
  float _1694;
  float _1773;
  float _1774;
  float _1775;
  float _1924;
  float _1957;
  float _1971;
  float _2010;
  float _2120;
  float _2194;
  float _2268;
  float _2347;
  float _2348;
  float _2349;
  float _2526;
  float _2527;
  float _2528;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _34 = (OutputGamut == 4);
        _45 = select(_34, 1.0f, 1.7050515413284302f);
        _46 = select(_34, 0.0f, -0.6217905879020691f);
        _47 = select(_34, 0.0f, -0.0832584798336029f);
        _48 = select(_34, 0.0f, -0.13025718927383423f);
        _49 = select(_34, 1.0f, 1.1408027410507202f);
        _50 = select(_34, 0.0f, -0.010548528283834457f);
        _51 = select(_34, 0.0f, -0.024003278464078903f);
        _52 = select(_34, 0.0f, -0.1289687603712082f);
        _53 = select(_34, 1.0f, 1.152971863746643f);
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
      _45 = 1.02579927444458f;
      _46 = -0.020052503794431686f;
      _47 = -0.0057713985443115234f;
      _48 = -0.0022350111976265907f;
      _49 = 1.0045825242996216f;
      _50 = -0.002352306619286537f;
      _51 = -0.005014004185795784f;
      _52 = -0.025293385609984398f;
      _53 = 1.0304402112960815f;
    }
  } else {
    _45 = 1.379158854484558f;
    _46 = -0.3088507056236267f;
    _47 = -0.07034677267074585f;
    _48 = -0.06933528929948807f;
    _49 = 1.0822921991348267f;
    _50 = -0.012962047010660172f;
    _51 = -0.002159259282052517f;
    _52 = -0.045465391129255295f;
    _53 = 1.0477596521377563f;
  }
  if ((uint)OutputDevice > (uint)2) {
    float _64 = (pow(_22, 0.012683313339948654f));
    float _65 = (pow(_23, 0.012683313339948654f));
    float _66 = (pow(_25, 0.012683313339948654f));
    _111 = (exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _112 = (exp2(log2(max(0.0f, (_65 + -0.8359375f)) / (18.8515625f - (_65 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _113 = (exp2(log2(max(0.0f, (_66 + -0.8359375f)) / (18.8515625f - (_66 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _111 = ((exp2((_22 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _112 = ((exp2((_23 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _113 = ((exp2((_25 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  float _128 = mad((WorkingColorSpace_ToAP1[0].z), _113, mad((WorkingColorSpace_ToAP1[0].y), _112, ((WorkingColorSpace_ToAP1[0].x) * _111)));
  float _131 = mad((WorkingColorSpace_ToAP1[1].z), _113, mad((WorkingColorSpace_ToAP1[1].y), _112, ((WorkingColorSpace_ToAP1[1].x) * _111)));
  float _134 = mad((WorkingColorSpace_ToAP1[2].z), _113, mad((WorkingColorSpace_ToAP1[2].y), _112, ((WorkingColorSpace_ToAP1[2].x) * _111)));
  float _135 = dot(float3(_128, _131, _134), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _139 = (_128 / _135) + -1.0f;
  float _140 = (_131 / _135) + -1.0f;
  float _141 = (_134 / _135) + -1.0f;
  float _153 = (1.0f - exp2(((_135 * _135) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_139, _140, _141), float3(_139, _140, _141)) * -4.0f));
  float _169 = ((mad(-0.06368283927440643f, _134, mad(-0.32929131388664246f, _131, (_128 * 1.370412826538086f))) - _128) * _153) + _128;
  float _170 = ((mad(-0.010861567221581936f, _134, mad(1.0970908403396606f, _131, (_128 * -0.08343426138162613f))) - _131) * _153) + _131;
  float _171 = ((mad(1.203694462776184f, _134, mad(-0.09862564504146576f, _131, (_128 * -0.02579325996339321f))) - _134) * _153) + _134;
  float _172 = dot(float3(_169, _170, _171), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _186 = ColorOffset.w + ColorOffsetShadows.w;
  float _200 = ColorGain.w * ColorGainShadows.w;
  float _214 = ColorGamma.w * ColorGammaShadows.w;
  float _228 = ColorContrast.w * ColorContrastShadows.w;
  float _242 = ColorSaturation.w * ColorSaturationShadows.w;
  float _246 = _169 - _172;
  float _247 = _170 - _172;
  float _248 = _171 - _172;
  float _305 = saturate(_172 / ColorCorrectionShadowsMax);
  float _309 = (_305 * _305) * (3.0f - (_305 * 2.0f));
  float _310 = 1.0f - _309;
  float _319 = ColorOffset.w + ColorOffsetHighlights.w;
  float _328 = ColorGain.w * ColorGainHighlights.w;
  float _337 = ColorGamma.w * ColorGammaHighlights.w;
  float _346 = ColorContrast.w * ColorContrastHighlights.w;
  float _355 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _418 = saturate((_172 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _422 = (_418 * _418) * (3.0f - (_418 * 2.0f));
  float _431 = ColorOffset.w + ColorOffsetMidtones.w;
  float _440 = ColorGain.w * ColorGainMidtones.w;
  float _449 = ColorGamma.w * ColorGammaMidtones.w;
  float _458 = ColorContrast.w * ColorContrastMidtones.w;
  float _467 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _525 = _309 - _422;
  float _536 = ((_422 * (((ColorOffset.x + ColorOffsetHighlights.x) + _319) + (((ColorGain.x * ColorGainHighlights.x) * _328) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _346) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _355) * _246) + _172)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _337)))))) + (_310 * (((ColorOffset.x + ColorOffsetShadows.x) + _186) + (((ColorGain.x * ColorGainShadows.x) * _200) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _228) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _242) * _246) + _172)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _214))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _431) + (((ColorGain.x * ColorGainMidtones.x) * _440) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _458) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _467) * _246) + _172)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _449))))) * _525);
  float _538 = ((_422 * (((ColorOffset.y + ColorOffsetHighlights.y) + _319) + (((ColorGain.y * ColorGainHighlights.y) * _328) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _346) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _355) * _247) + _172)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _337)))))) + (_310 * (((ColorOffset.y + ColorOffsetShadows.y) + _186) + (((ColorGain.y * ColorGainShadows.y) * _200) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _228) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _242) * _247) + _172)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _214))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _431) + (((ColorGain.y * ColorGainMidtones.y) * _440) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _458) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _467) * _247) + _172)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _449))))) * _525);
  float _540 = ((_422 * (((ColorOffset.z + ColorOffsetHighlights.z) + _319) + (((ColorGain.z * ColorGainHighlights.z) * _328) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _346) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _355) * _248) + _172)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _337)))))) + (_310 * (((ColorOffset.z + ColorOffsetShadows.z) + _186) + (((ColorGain.z * ColorGainShadows.z) * _200) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _228) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _242) * _248) + _172)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _214))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _431) + (((ColorGain.z * ColorGainMidtones.z) * _440) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _458) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _467) * _248) + _172)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _449))))) * _525);
  float _576 = ((mad(0.061360642313957214f, _540, mad(-4.540197551250458e-09f, _538, (_536 * 0.9386394023895264f))) - _536) * BlueCorrection) + _536;
  float _577 = ((mad(0.169205904006958f, _540, mad(0.8307942152023315f, _538, (_536 * 6.775371730327606e-08f))) - _538) * BlueCorrection) + _538;
  float _578 = (mad(-2.3283064365386963e-10f, _538, (_536 * -9.313225746154785e-10f)) * BlueCorrection) + _540;
  float _581 = mad(0.16386905312538147f, _578, mad(0.14067868888378143f, _577, (_576 * 0.6954522132873535f)));
  float _584 = mad(0.0955343246459961f, _578, mad(0.8596711158752441f, _577, (_576 * 0.044794581830501556f)));
  float _587 = mad(1.0015007257461548f, _578, mad(0.004025210160762072f, _577, (_576 * -0.005525882821530104f)));
  float _591 = max(max(_581, _584), _587);
  float _596 = (max(_591, 1.000000013351432e-10f) - max(min(min(_581, _584), _587), 1.000000013351432e-10f)) / max(_591, 0.009999999776482582f);
  float _609 = ((_584 + _581) + _587) + (sqrt((((_587 - _584) * _587) + ((_584 - _581) * _584)) + ((_581 - _587) * _581)) * 1.75f);
  float _610 = _609 * 0.3333333432674408f;
  float _611 = _596 + -0.4000000059604645f;
  float _612 = _611 * 5.0f;
  float _616 = max((1.0f - abs(_611 * 2.5f)), 0.0f);
  float _627 = ((float((int)(((int)(uint)((bool)(_612 > 0.0f))) - ((int)(uint)((bool)(_612 < 0.0f))))) * (1.0f - (_616 * _616))) + 1.0f) * 0.02500000037252903f;
  if (!(_610 <= 0.0533333346247673f)) {
    if (!(_610 >= 0.1599999964237213f)) {
      _636 = (((0.23999999463558197f / _609) + -0.5f) * _627);
    } else {
      _636 = 0.0f;
    }
  } else {
    _636 = _627;
  }
  float _637 = _636 + 1.0f;
  float _638 = _637 * _581;
  float _639 = _637 * _584;
  float _640 = _637 * _587;
  if (!((bool)(_638 == _639) && (bool)(_639 == _640))) {
    float _647 = ((_638 * 2.0f) - _639) - _640;
    float _650 = ((_584 - _587) * 1.7320507764816284f) * _637;
    float _652 = atan(_650 / _647);
    bool _655 = (_647 < 0.0f);
    bool _656 = (_647 == 0.0f);
    bool _657 = (_650 >= 0.0f);
    bool _658 = (_650 < 0.0f);
    _669 = select((_657 && _656), 90.0f, select((_658 && _656), -90.0f, (select((_658 && _655), (_652 + -3.1415927410125732f), select((_657 && _655), (_652 + 3.1415927410125732f), _652)) * 57.2957763671875f)));
  } else {
    _669 = 0.0f;
  }
  float _674 = min(max(select((_669 < 0.0f), (_669 + 360.0f), _669), 0.0f), 360.0f);
  if (_674 < -180.0f) {
    _683 = (_674 + 360.0f);
  } else {
    if (_674 > 180.0f) {
      _683 = (_674 + -360.0f);
    } else {
      _683 = _674;
    }
  }
  float _687 = saturate(1.0f - abs(_683 * 0.014814814552664757f));
  float _691 = (_687 * _687) * (3.0f - (_687 * 2.0f));
  float _697 = ((_691 * _691) * ((_596 * 0.18000000715255737f) * (0.029999999329447746f - _638))) + _638;
  float _707 = max(0.0f, mad(-0.21492856740951538f, _640, mad(-0.2365107536315918f, _639, (_697 * 1.4514392614364624f))));
  float _708 = max(0.0f, mad(-0.09967592358589172f, _640, mad(1.17622971534729f, _639, (_697 * -0.07655377686023712f))));
  float _709 = max(0.0f, mad(0.9977163076400757f, _640, mad(-0.006032449658960104f, _639, (_697 * 0.008316148072481155f))));
  float _710 = dot(float3(_707, _708, _709), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float _756 = lerp(_710, _707, 0.9599999785423279f);
  float _757 = lerp(_710, _708, 0.9599999785423279f);
  float _758 = lerp(_710, _709, 0.9599999785423279f);

#if 1
  ApplyFilmicToneMap(_756, _757, _758, _576, _577, _578);
  float _898 = _756, _899 = _757, _900 = _758;
#else
  float _725 = (FilmBlackClip + 1.0f) - FilmToe;
  float _727 = FilmWhiteClip + 1.0f;
  float _729 = _727 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _747 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _738 = (FilmBlackClip + 0.18000000715255737f) / _725;
    _747 = (-0.7447274923324585f - ((log2(_738 / (2.0f - _738)) * 0.3465735912322998f) * (_725 / FilmSlope)));
  }
  float _750 = ((1.0f - FilmToe) / FilmSlope) - _747;
  float _752 = (FilmShoulder / FilmSlope) - _750;
  _756 = log2(_756) * 0.3010300099849701f;
  _757 = log2(_757) * 0.3010300099849701f;
  _758 = log2(_758) * 0.3010300099849701f;
  float _762 = FilmSlope * (_756 + _750);
  float _763 = FilmSlope * (_757 + _750);
  float _764 = FilmSlope * (_758 + _750);
  float _765 = _725 * 2.0f;
  float _767 = (FilmSlope * -2.0f) / _725;
  float _768 = _756 - _747;
  float _769 = _757 - _747;
  float _770 = _758 - _747;
  float _789 = _729 * 2.0f;
  float _791 = (FilmSlope * 2.0f) / _729;
  float _816 = select((_756 < _747), ((_765 / (exp2((_768 * 1.4426950216293335f) * _767) + 1.0f)) - FilmBlackClip), _762);
  float _817 = select((_757 < _747), ((_765 / (exp2((_769 * 1.4426950216293335f) * _767) + 1.0f)) - FilmBlackClip), _763);
  float _818 = select((_758 < _747), ((_765 / (exp2((_770 * 1.4426950216293335f) * _767) + 1.0f)) - FilmBlackClip), _764);
  float _825 = _752 - _747;
  float _829 = saturate(_768 / _825);
  float _830 = saturate(_769 / _825);
  float _831 = saturate(_770 / _825);
  bool _832 = (_752 < _747);
  float _836 = select(_832, (1.0f - _829), _829);
  float _837 = select(_832, (1.0f - _830), _830);
  float _838 = select(_832, (1.0f - _831), _831);
  float _857 = (((_836 * _836) * (select((_756 > _752), (_727 - (_789 / (exp2(((_756 - _752) * 1.4426950216293335f) * _791) + 1.0f))), _762) - _816)) * (3.0f - (_836 * 2.0f))) + _816;
  float _858 = (((_837 * _837) * (select((_757 > _752), (_727 - (_789 / (exp2(((_757 - _752) * 1.4426950216293335f) * _791) + 1.0f))), _763) - _817)) * (3.0f - (_837 * 2.0f))) + _817;
  float _859 = (((_838 * _838) * (select((_758 > _752), (_727 - (_789 / (exp2(((_758 - _752) * 1.4426950216293335f) * _791) + 1.0f))), _764) - _818)) * (3.0f - (_838 * 2.0f))) + _818;
  float _860 = dot(float3(_857, _858, _859), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _880 = (ToneCurveAmount * (max(0.0f, (lerp(_860, _857, 0.9300000071525574f))) - _576)) + _576;
  float _881 = (ToneCurveAmount * (max(0.0f, (lerp(_860, _858, 0.9300000071525574f))) - _577)) + _577;
  float _882 = (ToneCurveAmount * (max(0.0f, (lerp(_860, _859, 0.9300000071525574f))) - _578)) + _578;
  float _898 = ((mad(-0.06537103652954102f, _882, mad(1.451815478503704e-06f, _881, (_880 * 1.065374732017517f))) - _880) * BlueCorrection) + _880;
  float _899 = ((mad(-0.20366770029067993f, _882, mad(1.2036634683609009f, _881, (_880 * -2.57161445915699e-07f))) - _881) * BlueCorrection) + _881;
  float _900 = ((mad(0.9999996423721313f, _882, mad(2.0954757928848267e-08f, _881, (_880 * 1.862645149230957e-08f))) - _882) * BlueCorrection) + _882;
#endif

  // Remove saturate and max
  float _913 = mad((WorkingColorSpace_FromAP1[0].z), _900, mad((WorkingColorSpace_FromAP1[0].y), _899, ((WorkingColorSpace_FromAP1[0].x) * _898)));
  float _914 = mad((WorkingColorSpace_FromAP1[1].z), _900, mad((WorkingColorSpace_FromAP1[1].y), _899, ((WorkingColorSpace_FromAP1[1].x) * _898)));
  float _915 = mad((WorkingColorSpace_FromAP1[2].z), _900, mad((WorkingColorSpace_FromAP1[2].y), _899, ((WorkingColorSpace_FromAP1[2].x) * _898)));
  
  /* if (_913 < 0.0031306699384003878f) {
    _926 = (_913 * 12.920000076293945f);
  } else {
    _926 = (((pow(_913, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_914 < 0.0031306699384003878f) {
    _937 = (_914 * 12.920000076293945f);
  } else {
    _937 = (((pow(_914, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_915 < 0.0031306699384003878f) {
    _948 = (_915 * 12.920000076293945f);
  } else {
    _948 = (((pow(_915, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _952 = (_937 * 0.9375f) + 0.03125f;
  float _959 = _948 * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((_926 * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  float4 _966 = Textures_1.Sample(Samplers_1, float2(_963, _952));
  float4 _973 = Textures_1.Sample(Samplers_1, float2((_963 + 0.0625f), _952));
  float _992 = max(6.103519990574569e-05f, (((lerp(_966.x, _973.x, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _926)));
  float _993 = max(6.103519990574569e-05f, (((lerp(_966.y, _973.y, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _937)));
  float _994 = max(6.103519990574569e-05f, (((lerp(_966.z, _973.z, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _948)));
  float _1016 = select((_992 > 0.040449999272823334f), exp2(log2((_992 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_992 * 0.07739938050508499f));
  float _1017 = select((_993 > 0.040449999272823334f), exp2(log2((_993 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_993 * 0.07739938050508499f));
  float _1018 = select((_994 > 0.040449999272823334f), exp2(log2((_994 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_994 * 0.07739938050508499f));
  */

  float3 untonemapped = float3(_913, _914, _915);
  float _1016;
  float _1017;
  float _1018;
  SampleLUTUpgradeToneMap(untonemapped, Samplers_1, Textures_1, _1016, _1017, _1018);

  float _1044 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1016)) * _1016) + MappingPolynomial.z);
  float _1045 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1017)) * _1017) + MappingPolynomial.z);
  float _1046 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1018)) * _1018) + MappingPolynomial.z);
  float _1053 = ((OverlayColor.x - _1044) * OverlayColor.w) + _1044;
  float _1054 = ((OverlayColor.y - _1045) * OverlayColor.w) + _1045;
  float _1055 = ((OverlayColor.z - _1046) * OverlayColor.w) + _1046;

  if (GenerateOutput(_1053, _1054, _1055, SV_Target)) {
    return SV_Target;
  }
  
  float _1056 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _540, mad((WorkingColorSpace_FromAP1[0].y), _538, (_536 * (WorkingColorSpace_FromAP1[0].x))));
  float _1057 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _540, mad((WorkingColorSpace_FromAP1[1].y), _538, ((WorkingColorSpace_FromAP1[1].x) * _536)));
  float _1058 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _540, mad((WorkingColorSpace_FromAP1[2].y), _538, ((WorkingColorSpace_FromAP1[2].x) * _536)));
  float _1065 = ((OverlayColor.x - _1056) * OverlayColor.w) + _1056;
  float _1066 = ((OverlayColor.y - _1057) * OverlayColor.w) + _1057;
  float _1067 = ((OverlayColor.z - _1058) * OverlayColor.w) + _1058;
  float _1079 = exp2(log2(max(0.0f, _1053)) * InverseGamma.y);
  float _1080 = exp2(log2(max(0.0f, _1054)) * InverseGamma.y);
  float _1081 = exp2(log2(max(0.0f, _1055)) * InverseGamma.y);
  [branch]
  if (OutputDevice == 0) {
    float _1087 = max(dot(float3(_1079, _1080, _1081), float3(0.2126390039920807f, 0.7151690125465393f, 0.0721919983625412f)), 9.999999747378752e-05f);
    float _1107 = ((select((_1087 < PolarisToneCurveCoef1.z), 0.0f, 1.0f) * ((PolarisToneCurveCoef0.y - _1087) + ((-0.0f - PolarisToneCurveCoef1.x) / (PolarisToneCurveCoef0.x + _1087)))) + _1087) * PolarisToneCurveCoef1.y;
    float _1108 = _1107 * (_1079 / _1087);
    float _1109 = _1107 * (_1080 / _1087);
    float _1110 = _1107 * (_1081 / _1087);
    do {
      if (WorkingColorSpace_bIsSRGB == 0) {
        float _1129 = mad((WorkingColorSpace_ToAP1[0].z), _1110, mad((WorkingColorSpace_ToAP1[0].y), _1109, ((WorkingColorSpace_ToAP1[0].x) * _1108)));
        float _1132 = mad((WorkingColorSpace_ToAP1[1].z), _1110, mad((WorkingColorSpace_ToAP1[1].y), _1109, ((WorkingColorSpace_ToAP1[1].x) * _1108)));
        float _1135 = mad((WorkingColorSpace_ToAP1[2].z), _1110, mad((WorkingColorSpace_ToAP1[2].y), _1109, ((WorkingColorSpace_ToAP1[2].x) * _1108)));
        _1146 = mad(_47, _1135, mad(_46, _1132, (_1129 * _45)));
        _1147 = mad(_50, _1135, mad(_49, _1132, (_1129 * _48)));
        _1148 = mad(_53, _1135, mad(_52, _1132, (_1129 * _51)));
      } else {
        _1146 = _1108;
        _1147 = _1109;
        _1148 = _1110;
      }
      do {
        if (_1146 < 0.0031306699384003878f) {
          _1159 = (_1146 * 12.920000076293945f);
        } else {
          _1159 = (((pow(_1146, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1147 < 0.0031306699384003878f) {
            _1170 = (_1147 * 12.920000076293945f);
          } else {
            _1170 = (((pow(_1147, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1148 < 0.0031306699384003878f) {
            _2526 = _1159;
            _2527 = _1170;
            _2528 = (_1148 * 12.920000076293945f);
          } else {
            _2526 = _1159;
            _2527 = _1170;
            _2528 = (((pow(_1148, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1197 = mad((WorkingColorSpace_ToAP1[0].z), _1081, mad((WorkingColorSpace_ToAP1[0].y), _1080, ((WorkingColorSpace_ToAP1[0].x) * _1079)));
      float _1200 = mad((WorkingColorSpace_ToAP1[1].z), _1081, mad((WorkingColorSpace_ToAP1[1].y), _1080, ((WorkingColorSpace_ToAP1[1].x) * _1079)));
      float _1203 = mad((WorkingColorSpace_ToAP1[2].z), _1081, mad((WorkingColorSpace_ToAP1[2].y), _1080, ((WorkingColorSpace_ToAP1[2].x) * _1079)));
      float _1213 = max(6.103519990574569e-05f, mad(_47, _1203, mad(_46, _1200, (_1197 * _45))));
      float _1214 = max(6.103519990574569e-05f, mad(_50, _1203, mad(_49, _1200, (_1197 * _48))));
      float _1215 = max(6.103519990574569e-05f, mad(_53, _1203, mad(_52, _1200, (_1197 * _51))));
      _2526 = min((_1213 * 4.5f), ((exp2(log2(max(_1213, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2527 = min((_1214 * 4.5f), ((exp2(log2(max(_1214, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2528 = min((_1215 * 4.5f), ((exp2(log2(max(_1215, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1290 = ACESSceneColorMultiplier * _1065;
        float _1291 = ACESSceneColorMultiplier * _1066;
        float _1292 = ACESSceneColorMultiplier * _1067;
        float _1295 = mad((WorkingColorSpace_ToAP0[0].z), _1292, mad((WorkingColorSpace_ToAP0[0].y), _1291, ((WorkingColorSpace_ToAP0[0].x) * _1290)));
        float _1298 = mad((WorkingColorSpace_ToAP0[1].z), _1292, mad((WorkingColorSpace_ToAP0[1].y), _1291, ((WorkingColorSpace_ToAP0[1].x) * _1290)));
        float _1301 = mad((WorkingColorSpace_ToAP0[2].z), _1292, mad((WorkingColorSpace_ToAP0[2].y), _1291, ((WorkingColorSpace_ToAP0[2].x) * _1290)));
        float _1305 = max(max(_1295, _1298), _1301);
        float _1310 = (max(_1305, 1.000000013351432e-10f) - max(min(min(_1295, _1298), _1301), 1.000000013351432e-10f)) / max(_1305, 0.009999999776482582f);
        float _1323 = ((_1298 + _1295) + _1301) + (sqrt((((_1301 - _1298) * _1301) + ((_1298 - _1295) * _1298)) + ((_1295 - _1301) * _1295)) * 1.75f);
        float _1324 = _1323 * 0.3333333432674408f;
        float _1325 = _1310 + -0.4000000059604645f;
        float _1326 = _1325 * 5.0f;
        float _1330 = max((1.0f - abs(_1325 * 2.5f)), 0.0f);
        float _1341 = ((float((int)(((int)(uint)((bool)(_1326 > 0.0f))) - ((int)(uint)((bool)(_1326 < 0.0f))))) * (1.0f - (_1330 * _1330))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1324 <= 0.0533333346247673f)) {
            if (!(_1324 >= 0.1599999964237213f)) {
              _1350 = (((0.23999999463558197f / _1323) + -0.5f) * _1341);
            } else {
              _1350 = 0.0f;
            }
          } else {
            _1350 = _1341;
          }
          float _1351 = _1350 + 1.0f;
          float _1352 = _1351 * _1295;
          float _1353 = _1351 * _1298;
          float _1354 = _1351 * _1301;
          do {
            if (!((bool)(_1352 == _1353) && (bool)(_1353 == _1354))) {
              float _1361 = ((_1352 * 2.0f) - _1353) - _1354;
              float _1364 = ((_1298 - _1301) * 1.7320507764816284f) * _1351;
              float _1366 = atan(_1364 / _1361);
              bool _1369 = (_1361 < 0.0f);
              bool _1370 = (_1361 == 0.0f);
              bool _1371 = (_1364 >= 0.0f);
              bool _1372 = (_1364 < 0.0f);
              _1383 = select((_1371 && _1370), 90.0f, select((_1372 && _1370), -90.0f, (select((_1372 && _1369), (_1366 + -3.1415927410125732f), select((_1371 && _1369), (_1366 + 3.1415927410125732f), _1366)) * 57.2957763671875f)));
            } else {
              _1383 = 0.0f;
            }
            float _1388 = min(max(select((_1383 < 0.0f), (_1383 + 360.0f), _1383), 0.0f), 360.0f);
            do {
              if (_1388 < -180.0f) {
                _1397 = (_1388 + 360.0f);
              } else {
                if (_1388 > 180.0f) {
                  _1397 = (_1388 + -360.0f);
                } else {
                  _1397 = _1388;
                }
              }
              do {
                if ((bool)(_1397 > -67.5f) && (bool)(_1397 < 67.5f)) {
                  float _1403 = (_1397 + 67.5f) * 0.029629629105329514f;
                  int _1404 = int(_1403);
                  float _1406 = _1403 - float((int)(_1404));
                  float _1407 = _1406 * _1406;
                  float _1408 = _1407 * _1406;
                  if (_1404 == 3) {
                    _1436 = (((0.1666666716337204f - (_1406 * 0.5f)) + (_1407 * 0.5f)) - (_1408 * 0.1666666716337204f));
                  } else {
                    if (_1404 == 2) {
                      _1436 = ((0.6666666865348816f - _1407) + (_1408 * 0.5f));
                    } else {
                      if (_1404 == 1) {
                        _1436 = (((_1408 * -0.5f) + 0.1666666716337204f) + ((_1407 + _1406) * 0.5f));
                      } else {
                        _1436 = select((_1404 == 0), (_1408 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1436 = 0.0f;
                }
                float _1445 = min(max(((((_1310 * 0.27000001072883606f) * (0.029999999329447746f - _1352)) * _1436) + _1352), 0.0f), 65535.0f);
                float _1446 = min(max(_1353, 0.0f), 65535.0f);
                float _1447 = min(max(_1354, 0.0f), 65535.0f);
                float _1460 = min(max(mad(-0.21492856740951538f, _1447, mad(-0.2365107536315918f, _1446, (_1445 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1461 = min(max(mad(-0.09967592358589172f, _1447, mad(1.17622971534729f, _1446, (_1445 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1462 = min(max(mad(0.9977163076400757f, _1447, mad(-0.006032449658960104f, _1446, (_1445 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1463 = dot(float3(_1460, _1461, _1462), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1474 = log2(max((lerp(_1463, _1460, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1475 = _1474 * 0.3010300099849701f;
                float _1476 = log2(ACESMinMaxData.x);
                float _1477 = _1476 * 0.3010300099849701f;
                do {
                  if (!(!(_1475 <= _1477))) {
                    _1546 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1484 = log2(ACESMidData.x);
                    float _1485 = _1484 * 0.3010300099849701f;
                    if ((bool)(_1475 > _1477) && (bool)(_1475 < _1485)) {
                      float _1493 = ((_1474 - _1476) * 0.9030900001525879f) / ((_1484 - _1476) * 0.3010300099849701f);
                      int _1494 = int(_1493);
                      float _1496 = _1493 - float((int)(_1494));
                      float _1498 = _12[_1494];
                      float _1501 = _12[(_1494 + 1)];
                      float _1506 = _1498 * 0.5f;
                      _1546 = dot(float3((_1496 * _1496), _1496, 1.0f), float3(mad((_12[(_1494 + 2)]), 0.5f, mad(_1501, -1.0f, _1506)), (_1501 - _1498), mad(_1501, 0.5f, _1506)));
                    } else {
                      do {
                        if (!(!(_1475 >= _1485))) {
                          float _1515 = log2(ACESMinMaxData.z);
                          if (_1475 < (_1515 * 0.3010300099849701f)) {
                            float _1523 = ((_1474 - _1484) * 0.9030900001525879f) / ((_1515 - _1484) * 0.3010300099849701f);
                            int _1524 = int(_1523);
                            float _1526 = _1523 - float((int)(_1524));
                            float _1528 = _13[_1524];
                            float _1531 = _13[(_1524 + 1)];
                            float _1536 = _1528 * 0.5f;
                            _1546 = dot(float3((_1526 * _1526), _1526, 1.0f), float3(mad((_13[(_1524 + 2)]), 0.5f, mad(_1531, -1.0f, _1536)), (_1531 - _1528), mad(_1531, 0.5f, _1536)));
                            break;
                          }
                        }
                        _1546 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1550 = log2(max((lerp(_1463, _1461, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1551 = _1550 * 0.3010300099849701f;
                  do {
                    if (!(!(_1551 <= _1477))) {
                      _1620 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1558 = log2(ACESMidData.x);
                      float _1559 = _1558 * 0.3010300099849701f;
                      if ((bool)(_1551 > _1477) && (bool)(_1551 < _1559)) {
                        float _1567 = ((_1550 - _1476) * 0.9030900001525879f) / ((_1558 - _1476) * 0.3010300099849701f);
                        int _1568 = int(_1567);
                        float _1570 = _1567 - float((int)(_1568));
                        float _1572 = _12[_1568];
                        float _1575 = _12[(_1568 + 1)];
                        float _1580 = _1572 * 0.5f;
                        _1620 = dot(float3((_1570 * _1570), _1570, 1.0f), float3(mad((_12[(_1568 + 2)]), 0.5f, mad(_1575, -1.0f, _1580)), (_1575 - _1572), mad(_1575, 0.5f, _1580)));
                      } else {
                        do {
                          if (!(!(_1551 >= _1559))) {
                            float _1589 = log2(ACESMinMaxData.z);
                            if (_1551 < (_1589 * 0.3010300099849701f)) {
                              float _1597 = ((_1550 - _1558) * 0.9030900001525879f) / ((_1589 - _1558) * 0.3010300099849701f);
                              int _1598 = int(_1597);
                              float _1600 = _1597 - float((int)(_1598));
                              float _1602 = _13[_1598];
                              float _1605 = _13[(_1598 + 1)];
                              float _1610 = _1602 * 0.5f;
                              _1620 = dot(float3((_1600 * _1600), _1600, 1.0f), float3(mad((_13[(_1598 + 2)]), 0.5f, mad(_1605, -1.0f, _1610)), (_1605 - _1602), mad(_1605, 0.5f, _1610)));
                              break;
                            }
                          }
                          _1620 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1624 = log2(max((lerp(_1463, _1462, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1625 = _1624 * 0.3010300099849701f;
                    do {
                      if (!(!(_1625 <= _1477))) {
                        _1694 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1632 = log2(ACESMidData.x);
                        float _1633 = _1632 * 0.3010300099849701f;
                        if ((bool)(_1625 > _1477) && (bool)(_1625 < _1633)) {
                          float _1641 = ((_1624 - _1476) * 0.9030900001525879f) / ((_1632 - _1476) * 0.3010300099849701f);
                          int _1642 = int(_1641);
                          float _1644 = _1641 - float((int)(_1642));
                          float _1646 = _12[_1642];
                          float _1649 = _12[(_1642 + 1)];
                          float _1654 = _1646 * 0.5f;
                          _1694 = dot(float3((_1644 * _1644), _1644, 1.0f), float3(mad((_12[(_1642 + 2)]), 0.5f, mad(_1649, -1.0f, _1654)), (_1649 - _1646), mad(_1649, 0.5f, _1654)));
                        } else {
                          do {
                            if (!(!(_1625 >= _1633))) {
                              float _1663 = log2(ACESMinMaxData.z);
                              if (_1625 < (_1663 * 0.3010300099849701f)) {
                                float _1671 = ((_1624 - _1632) * 0.9030900001525879f) / ((_1663 - _1632) * 0.3010300099849701f);
                                int _1672 = int(_1671);
                                float _1674 = _1671 - float((int)(_1672));
                                float _1676 = _13[_1672];
                                float _1679 = _13[(_1672 + 1)];
                                float _1684 = _1676 * 0.5f;
                                _1694 = dot(float3((_1674 * _1674), _1674, 1.0f), float3(mad((_13[(_1672 + 2)]), 0.5f, mad(_1679, -1.0f, _1684)), (_1679 - _1676), mad(_1679, 0.5f, _1684)));
                                break;
                              }
                            }
                            _1694 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1698 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1699 = (exp2(_1546 * 3.321928024291992f) - ACESMinMaxData.y) / _1698;
                      float _1701 = (exp2(_1620 * 3.321928024291992f) - ACESMinMaxData.y) / _1698;
                      float _1703 = (exp2(_1694 * 3.321928024291992f) - ACESMinMaxData.y) / _1698;
                      float _1706 = mad(0.15618768334388733f, _1703, mad(0.13400420546531677f, _1701, (_1699 * 0.6624541878700256f)));
                      float _1709 = mad(0.053689517080783844f, _1703, mad(0.6740817427635193f, _1701, (_1699 * 0.2722287178039551f)));
                      float _1712 = mad(1.0103391408920288f, _1703, mad(0.00406073359772563f, _1701, (_1699 * -0.005574649665504694f)));
                      float _1725 = min(max(mad(-0.23642469942569733f, _1712, mad(-0.32480329275131226f, _1709, (_1706 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1726 = min(max(mad(0.016756348311901093f, _1712, mad(1.6153316497802734f, _1709, (_1706 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1727 = min(max(mad(0.9883948564529419f, _1712, mad(-0.008284442126750946f, _1709, (_1706 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1730 = mad(0.15618768334388733f, _1727, mad(0.13400420546531677f, _1726, (_1725 * 0.6624541878700256f)));
                      float _1733 = mad(0.053689517080783844f, _1727, mad(0.6740817427635193f, _1726, (_1725 * 0.2722287178039551f)));
                      float _1736 = mad(1.0103391408920288f, _1727, mad(0.00406073359772563f, _1726, (_1725 * -0.005574649665504694f)));
                      float _1758 = min(max((min(max(mad(-0.23642469942569733f, _1736, mad(-0.32480329275131226f, _1733, (_1730 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1759 = min(max((min(max(mad(0.016756348311901093f, _1736, mad(1.6153316497802734f, _1733, (_1730 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1760 = min(max((min(max(mad(0.9883948564529419f, _1736, mad(-0.008284442126750946f, _1733, (_1730 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!(OutputDevice == 5)) {
                          _1773 = mad(_47, _1760, mad(_46, _1759, (_1758 * _45)));
                          _1774 = mad(_50, _1760, mad(_49, _1759, (_1758 * _48)));
                          _1775 = mad(_53, _1760, mad(_52, _1759, (_1758 * _51)));
                        } else {
                          _1773 = _1758;
                          _1774 = _1759;
                          _1775 = _1760;
                        }
                        float _1785 = exp2(log2(_1773 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1786 = exp2(log2(_1774 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1787 = exp2(log2(_1775 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2526 = exp2(log2((1.0f / ((_1785 * 18.6875f) + 1.0f)) * ((_1785 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2527 = exp2(log2((1.0f / ((_1786 * 18.6875f) + 1.0f)) * ((_1786 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2528 = exp2(log2((1.0f / ((_1787 * 18.6875f) + 1.0f)) * ((_1787 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1864 = ACESSceneColorMultiplier * _1065;
          float _1865 = ACESSceneColorMultiplier * _1066;
          float _1866 = ACESSceneColorMultiplier * _1067;
          float _1869 = mad((WorkingColorSpace_ToAP0[0].z), _1866, mad((WorkingColorSpace_ToAP0[0].y), _1865, ((WorkingColorSpace_ToAP0[0].x) * _1864)));
          float _1872 = mad((WorkingColorSpace_ToAP0[1].z), _1866, mad((WorkingColorSpace_ToAP0[1].y), _1865, ((WorkingColorSpace_ToAP0[1].x) * _1864)));
          float _1875 = mad((WorkingColorSpace_ToAP0[2].z), _1866, mad((WorkingColorSpace_ToAP0[2].y), _1865, ((WorkingColorSpace_ToAP0[2].x) * _1864)));
          float _1879 = max(max(_1869, _1872), _1875);
          float _1884 = (max(_1879, 1.000000013351432e-10f) - max(min(min(_1869, _1872), _1875), 1.000000013351432e-10f)) / max(_1879, 0.009999999776482582f);
          float _1897 = ((_1872 + _1869) + _1875) + (sqrt((((_1875 - _1872) * _1875) + ((_1872 - _1869) * _1872)) + ((_1869 - _1875) * _1869)) * 1.75f);
          float _1898 = _1897 * 0.3333333432674408f;
          float _1899 = _1884 + -0.4000000059604645f;
          float _1900 = _1899 * 5.0f;
          float _1904 = max((1.0f - abs(_1899 * 2.5f)), 0.0f);
          float _1915 = ((float((int)(((int)(uint)((bool)(_1900 > 0.0f))) - ((int)(uint)((bool)(_1900 < 0.0f))))) * (1.0f - (_1904 * _1904))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1898 <= 0.0533333346247673f)) {
              if (!(_1898 >= 0.1599999964237213f)) {
                _1924 = (((0.23999999463558197f / _1897) + -0.5f) * _1915);
              } else {
                _1924 = 0.0f;
              }
            } else {
              _1924 = _1915;
            }
            float _1925 = _1924 + 1.0f;
            float _1926 = _1925 * _1869;
            float _1927 = _1925 * _1872;
            float _1928 = _1925 * _1875;
            do {
              if (!((bool)(_1926 == _1927) && (bool)(_1927 == _1928))) {
                float _1935 = ((_1926 * 2.0f) - _1927) - _1928;
                float _1938 = ((_1872 - _1875) * 1.7320507764816284f) * _1925;
                float _1940 = atan(_1938 / _1935);
                bool _1943 = (_1935 < 0.0f);
                bool _1944 = (_1935 == 0.0f);
                bool _1945 = (_1938 >= 0.0f);
                bool _1946 = (_1938 < 0.0f);
                _1957 = select((_1945 && _1944), 90.0f, select((_1946 && _1944), -90.0f, (select((_1946 && _1943), (_1940 + -3.1415927410125732f), select((_1945 && _1943), (_1940 + 3.1415927410125732f), _1940)) * 57.2957763671875f)));
              } else {
                _1957 = 0.0f;
              }
              float _1962 = min(max(select((_1957 < 0.0f), (_1957 + 360.0f), _1957), 0.0f), 360.0f);
              do {
                if (_1962 < -180.0f) {
                  _1971 = (_1962 + 360.0f);
                } else {
                  if (_1962 > 180.0f) {
                    _1971 = (_1962 + -360.0f);
                  } else {
                    _1971 = _1962;
                  }
                }
                do {
                  if ((bool)(_1971 > -67.5f) && (bool)(_1971 < 67.5f)) {
                    float _1977 = (_1971 + 67.5f) * 0.029629629105329514f;
                    int _1978 = int(_1977);
                    float _1980 = _1977 - float((int)(_1978));
                    float _1981 = _1980 * _1980;
                    float _1982 = _1981 * _1980;
                    if (_1978 == 3) {
                      _2010 = (((0.1666666716337204f - (_1980 * 0.5f)) + (_1981 * 0.5f)) - (_1982 * 0.1666666716337204f));
                    } else {
                      if (_1978 == 2) {
                        _2010 = ((0.6666666865348816f - _1981) + (_1982 * 0.5f));
                      } else {
                        if (_1978 == 1) {
                          _2010 = (((_1982 * -0.5f) + 0.1666666716337204f) + ((_1981 + _1980) * 0.5f));
                        } else {
                          _2010 = select((_1978 == 0), (_1982 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2010 = 0.0f;
                  }
                  float _2019 = min(max(((((_1884 * 0.27000001072883606f) * (0.029999999329447746f - _1926)) * _2010) + _1926), 0.0f), 65535.0f);
                  float _2020 = min(max(_1927, 0.0f), 65535.0f);
                  float _2021 = min(max(_1928, 0.0f), 65535.0f);
                  float _2034 = min(max(mad(-0.21492856740951538f, _2021, mad(-0.2365107536315918f, _2020, (_2019 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2035 = min(max(mad(-0.09967592358589172f, _2021, mad(1.17622971534729f, _2020, (_2019 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2036 = min(max(mad(0.9977163076400757f, _2021, mad(-0.006032449658960104f, _2020, (_2019 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2037 = dot(float3(_2034, _2035, _2036), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2048 = log2(max((lerp(_2037, _2034, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2049 = _2048 * 0.3010300099849701f;
                  float _2050 = log2(ACESMinMaxData.x);
                  float _2051 = _2050 * 0.3010300099849701f;
                  do {
                    if (!(!(_2049 <= _2051))) {
                      _2120 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2058 = log2(ACESMidData.x);
                      float _2059 = _2058 * 0.3010300099849701f;
                      if ((bool)(_2049 > _2051) && (bool)(_2049 < _2059)) {
                        float _2067 = ((_2048 - _2050) * 0.9030900001525879f) / ((_2058 - _2050) * 0.3010300099849701f);
                        int _2068 = int(_2067);
                        float _2070 = _2067 - float((int)(_2068));
                        float _2072 = _10[_2068];
                        float _2075 = _10[(_2068 + 1)];
                        float _2080 = _2072 * 0.5f;
                        _2120 = dot(float3((_2070 * _2070), _2070, 1.0f), float3(mad((_10[(_2068 + 2)]), 0.5f, mad(_2075, -1.0f, _2080)), (_2075 - _2072), mad(_2075, 0.5f, _2080)));
                      } else {
                        do {
                          if (!(!(_2049 >= _2059))) {
                            float _2089 = log2(ACESMinMaxData.z);
                            if (_2049 < (_2089 * 0.3010300099849701f)) {
                              float _2097 = ((_2048 - _2058) * 0.9030900001525879f) / ((_2089 - _2058) * 0.3010300099849701f);
                              int _2098 = int(_2097);
                              float _2100 = _2097 - float((int)(_2098));
                              float _2102 = _11[_2098];
                              float _2105 = _11[(_2098 + 1)];
                              float _2110 = _2102 * 0.5f;
                              _2120 = dot(float3((_2100 * _2100), _2100, 1.0f), float3(mad((_11[(_2098 + 2)]), 0.5f, mad(_2105, -1.0f, _2110)), (_2105 - _2102), mad(_2105, 0.5f, _2110)));
                              break;
                            }
                          }
                          _2120 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2124 = log2(max((lerp(_2037, _2035, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2125 = _2124 * 0.3010300099849701f;
                    do {
                      if (!(!(_2125 <= _2051))) {
                        _2194 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2132 = log2(ACESMidData.x);
                        float _2133 = _2132 * 0.3010300099849701f;
                        if ((bool)(_2125 > _2051) && (bool)(_2125 < _2133)) {
                          float _2141 = ((_2124 - _2050) * 0.9030900001525879f) / ((_2132 - _2050) * 0.3010300099849701f);
                          int _2142 = int(_2141);
                          float _2144 = _2141 - float((int)(_2142));
                          float _2146 = _10[_2142];
                          float _2149 = _10[(_2142 + 1)];
                          float _2154 = _2146 * 0.5f;
                          _2194 = dot(float3((_2144 * _2144), _2144, 1.0f), float3(mad((_10[(_2142 + 2)]), 0.5f, mad(_2149, -1.0f, _2154)), (_2149 - _2146), mad(_2149, 0.5f, _2154)));
                        } else {
                          do {
                            if (!(!(_2125 >= _2133))) {
                              float _2163 = log2(ACESMinMaxData.z);
                              if (_2125 < (_2163 * 0.3010300099849701f)) {
                                float _2171 = ((_2124 - _2132) * 0.9030900001525879f) / ((_2163 - _2132) * 0.3010300099849701f);
                                int _2172 = int(_2171);
                                float _2174 = _2171 - float((int)(_2172));
                                float _2176 = _11[_2172];
                                float _2179 = _11[(_2172 + 1)];
                                float _2184 = _2176 * 0.5f;
                                _2194 = dot(float3((_2174 * _2174), _2174, 1.0f), float3(mad((_11[(_2172 + 2)]), 0.5f, mad(_2179, -1.0f, _2184)), (_2179 - _2176), mad(_2179, 0.5f, _2184)));
                                break;
                              }
                            }
                            _2194 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2198 = log2(max((lerp(_2037, _2036, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2199 = _2198 * 0.3010300099849701f;
                      do {
                        if (!(!(_2199 <= _2051))) {
                          _2268 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2206 = log2(ACESMidData.x);
                          float _2207 = _2206 * 0.3010300099849701f;
                          if ((bool)(_2199 > _2051) && (bool)(_2199 < _2207)) {
                            float _2215 = ((_2198 - _2050) * 0.9030900001525879f) / ((_2206 - _2050) * 0.3010300099849701f);
                            int _2216 = int(_2215);
                            float _2218 = _2215 - float((int)(_2216));
                            float _2220 = _10[_2216];
                            float _2223 = _10[(_2216 + 1)];
                            float _2228 = _2220 * 0.5f;
                            _2268 = dot(float3((_2218 * _2218), _2218, 1.0f), float3(mad((_10[(_2216 + 2)]), 0.5f, mad(_2223, -1.0f, _2228)), (_2223 - _2220), mad(_2223, 0.5f, _2228)));
                          } else {
                            do {
                              if (!(!(_2199 >= _2207))) {
                                float _2237 = log2(ACESMinMaxData.z);
                                if (_2199 < (_2237 * 0.3010300099849701f)) {
                                  float _2245 = ((_2198 - _2206) * 0.9030900001525879f) / ((_2237 - _2206) * 0.3010300099849701f);
                                  int _2246 = int(_2245);
                                  float _2248 = _2245 - float((int)(_2246));
                                  float _2250 = _11[_2246];
                                  float _2253 = _11[(_2246 + 1)];
                                  float _2258 = _2250 * 0.5f;
                                  _2268 = dot(float3((_2248 * _2248), _2248, 1.0f), float3(mad((_11[(_2246 + 2)]), 0.5f, mad(_2253, -1.0f, _2258)), (_2253 - _2250), mad(_2253, 0.5f, _2258)));
                                  break;
                                }
                              }
                              _2268 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2272 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2273 = (exp2(_2120 * 3.321928024291992f) - ACESMinMaxData.y) / _2272;
                        float _2275 = (exp2(_2194 * 3.321928024291992f) - ACESMinMaxData.y) / _2272;
                        float _2277 = (exp2(_2268 * 3.321928024291992f) - ACESMinMaxData.y) / _2272;
                        float _2280 = mad(0.15618768334388733f, _2277, mad(0.13400420546531677f, _2275, (_2273 * 0.6624541878700256f)));
                        float _2283 = mad(0.053689517080783844f, _2277, mad(0.6740817427635193f, _2275, (_2273 * 0.2722287178039551f)));
                        float _2286 = mad(1.0103391408920288f, _2277, mad(0.00406073359772563f, _2275, (_2273 * -0.005574649665504694f)));
                        float _2299 = min(max(mad(-0.23642469942569733f, _2286, mad(-0.32480329275131226f, _2283, (_2280 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2300 = min(max(mad(0.016756348311901093f, _2286, mad(1.6153316497802734f, _2283, (_2280 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2301 = min(max(mad(0.9883948564529419f, _2286, mad(-0.008284442126750946f, _2283, (_2280 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2304 = mad(0.15618768334388733f, _2301, mad(0.13400420546531677f, _2300, (_2299 * 0.6624541878700256f)));
                        float _2307 = mad(0.053689517080783844f, _2301, mad(0.6740817427635193f, _2300, (_2299 * 0.2722287178039551f)));
                        float _2310 = mad(1.0103391408920288f, _2301, mad(0.00406073359772563f, _2300, (_2299 * -0.005574649665504694f)));
                        float _2332 = min(max((min(max(mad(-0.23642469942569733f, _2310, mad(-0.32480329275131226f, _2307, (_2304 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2333 = min(max((min(max(mad(0.016756348311901093f, _2310, mad(1.6153316497802734f, _2307, (_2304 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2334 = min(max((min(max(mad(0.9883948564529419f, _2310, mad(-0.008284442126750946f, _2307, (_2304 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 6)) {
                            _2347 = mad(_47, _2334, mad(_46, _2333, (_2332 * _45)));
                            _2348 = mad(_50, _2334, mad(_49, _2333, (_2332 * _48)));
                            _2349 = mad(_53, _2334, mad(_52, _2333, (_2332 * _51)));
                          } else {
                            _2347 = _2332;
                            _2348 = _2333;
                            _2349 = _2334;
                          }
                          float _2359 = exp2(log2(_2347 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2360 = exp2(log2(_2348 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2361 = exp2(log2(_2349 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2526 = exp2(log2((1.0f / ((_2359 * 18.6875f) + 1.0f)) * ((_2359 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2527 = exp2(log2((1.0f / ((_2360 * 18.6875f) + 1.0f)) * ((_2360 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2528 = exp2(log2((1.0f / ((_2361 * 18.6875f) + 1.0f)) * ((_2361 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2406 = mad((WorkingColorSpace_ToAP1[0].z), _1067, mad((WorkingColorSpace_ToAP1[0].y), _1066, ((WorkingColorSpace_ToAP1[0].x) * _1065)));
            float _2409 = mad((WorkingColorSpace_ToAP1[1].z), _1067, mad((WorkingColorSpace_ToAP1[1].y), _1066, ((WorkingColorSpace_ToAP1[1].x) * _1065)));
            float _2412 = mad((WorkingColorSpace_ToAP1[2].z), _1067, mad((WorkingColorSpace_ToAP1[2].y), _1066, ((WorkingColorSpace_ToAP1[2].x) * _1065)));
            float _2431 = exp2(log2(mad(_47, _2412, mad(_46, _2409, (_2406 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2432 = exp2(log2(mad(_50, _2412, mad(_49, _2409, (_2406 * _48))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2433 = exp2(log2(mad(_53, _2412, mad(_52, _2409, (_2406 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2526 = exp2(log2((1.0f / ((_2431 * 18.6875f) + 1.0f)) * ((_2431 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2527 = exp2(log2((1.0f / ((_2432 * 18.6875f) + 1.0f)) * ((_2432 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2528 = exp2(log2((1.0f / ((_2433 * 18.6875f) + 1.0f)) * ((_2433 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2480 = mad((WorkingColorSpace_ToAP1[0].z), _1055, mad((WorkingColorSpace_ToAP1[0].y), _1054, ((WorkingColorSpace_ToAP1[0].x) * _1053)));
                float _2483 = mad((WorkingColorSpace_ToAP1[1].z), _1055, mad((WorkingColorSpace_ToAP1[1].y), _1054, ((WorkingColorSpace_ToAP1[1].x) * _1053)));
                float _2486 = mad((WorkingColorSpace_ToAP1[2].z), _1055, mad((WorkingColorSpace_ToAP1[2].y), _1054, ((WorkingColorSpace_ToAP1[2].x) * _1053)));
                _2526 = mad(_47, _2486, mad(_46, _2483, (_2480 * _45)));
                _2527 = mad(_50, _2486, mad(_49, _2483, (_2480 * _48)));
                _2528 = mad(_53, _2486, mad(_52, _2483, (_2480 * _51)));
              } else {
                float _2499 = mad((WorkingColorSpace_ToAP1[0].z), _1081, mad((WorkingColorSpace_ToAP1[0].y), _1080, ((WorkingColorSpace_ToAP1[0].x) * _1079)));
                float _2502 = mad((WorkingColorSpace_ToAP1[1].z), _1081, mad((WorkingColorSpace_ToAP1[1].y), _1080, ((WorkingColorSpace_ToAP1[1].x) * _1079)));
                float _2505 = mad((WorkingColorSpace_ToAP1[2].z), _1081, mad((WorkingColorSpace_ToAP1[2].y), _1080, ((WorkingColorSpace_ToAP1[2].x) * _1079)));
                _2526 = exp2(log2(mad(_47, _2505, mad(_46, _2502, (_2499 * _45)))) * InverseGamma.z);
                _2527 = exp2(log2(mad(_50, _2505, mad(_49, _2502, (_2499 * _48)))) * InverseGamma.z);
                _2528 = exp2(log2(mad(_53, _2505, mad(_52, _2502, (_2499 * _51)))) * InverseGamma.z);
              }
            } else {
              _2526 = _1065;
              _2527 = _1066;
              _2528 = _1067;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2526 * 0.9523810148239136f);
  SV_Target.y = (_2527 * 0.9523810148239136f);
  SV_Target.z = (_2528 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

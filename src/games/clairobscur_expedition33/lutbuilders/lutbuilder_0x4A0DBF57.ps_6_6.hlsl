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

Texture2D<float4> Textures_1 : register(t0);

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

SamplerState Samplers_1 : register(s0);

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
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _16 = 0.5f / LUTSize;
  float _21 = LUTSize + -1.0f;
  float _22 = (LUTSize * (TEXCOORD.x - _16)) / _21;
  float _23 = (LUTSize * (TEXCOORD.y - _16)) / _21;
  float _25 = float((uint)SV_RenderTargetArrayIndex) / _21;
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
  float _1121;
  float _1122;
  float _1123;
  float _1134;
  float _1145;
  float _1318;
  float _1333;
  float _1348;
  float _1356;
  float _1357;
  float _1358;
  float _1425;
  float _1458;
  float _1472;
  float _1511;
  float _1621;
  float _1695;
  float _1769;
  float _1848;
  float _1849;
  float _1850;
  float _1992;
  float _2007;
  float _2022;
  float _2030;
  float _2031;
  float _2032;
  float _2099;
  float _2132;
  float _2146;
  float _2185;
  float _2295;
  float _2369;
  float _2443;
  float _2522;
  float _2523;
  float _2524;
  float _2701;
  float _2702;
  float _2703;
  if (!((uint)(output_gamut) == 1)) {
    if (!((uint)(output_gamut) == 2)) {
      if (!((uint)(output_gamut) == 3)) {
        bool _34 = ((uint)(output_gamut) == 4);
        _45 = select(_34, 1.0f, 1.705051064491272f);
        _46 = select(_34, 0.0f, -0.6217921376228333f);
        _47 = select(_34, 0.0f, -0.0832589864730835f);
        _48 = select(_34, 0.0f, -0.13025647401809692f);
        _49 = select(_34, 1.0f, 1.140804648399353f);
        _50 = select(_34, 0.0f, -0.010548308491706848f);
        _51 = select(_34, 0.0f, -0.024003351107239723f);
        _52 = select(_34, 0.0f, -0.1289689838886261f);
        _53 = select(_34, 1.0f, 1.1529725790023804f);
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
      _45 = 1.0258246660232544f;
      _46 = -0.020053181797266006f;
      _47 = -0.005771636962890625f;
      _48 = -0.002234415616840124f;
      _49 = 1.0045864582061768f;
      _50 = -0.002352118492126465f;
      _51 = -0.005013350863009691f;
      _52 = -0.025290070101618767f;
      _53 = 1.0303035974502563f;
    }
  } else {
    _45 = 1.3792141675949097f;
    _46 = -0.30886411666870117f;
    _47 = -0.0703500509262085f;
    _48 = -0.06933490186929703f;
    _49 = 1.08229660987854f;
    _50 = -0.012961871922016144f;
    _51 = -0.0021590073592960835f;
    _52 = -0.0454593189060688f;
    _53 = 1.0476183891296387f;
  }
  if ((uint)(uint)(output_device) > (uint)2) {
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

  float _128 = mad((WorkingColorSpace.ToAP1[0].z), _113, mad((WorkingColorSpace.ToAP1[0].y), _112, ((WorkingColorSpace.ToAP1[0].x) * _111)));
  float _131 = mad((WorkingColorSpace.ToAP1[1].z), _113, mad((WorkingColorSpace.ToAP1[1].y), _112, ((WorkingColorSpace.ToAP1[1].x) * _111)));
  float _134 = mad((WorkingColorSpace.ToAP1[2].z), _113, mad((WorkingColorSpace.ToAP1[2].y), _112, ((WorkingColorSpace.ToAP1[2].x) * _111)));

  float _135 = dot(float3(_128, _131, _134), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _139 = (_128 / _135) + -1.0f;
  float _140 = (_131 / _135) + -1.0f;
  float _141 = (_134 / _135) + -1.0f;
  float _153 = (1.0f - exp2(((_135 * _135) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_139, _140, _141), float3(_139, _140, _141)) * -4.0f));
  float _169 = ((mad(-0.06368321925401688f, _134, mad(-0.3292922377586365f, _131, (_128 * 1.3704125881195068f))) - _128) * _153) + _128;
  float _170 = ((mad(-0.010861365124583244f, _134, mad(1.0970927476882935f, _131, (_128 * -0.08343357592821121f))) - _131) * _153) + _131;
  float _171 = ((mad(1.2036951780319214f, _134, mad(-0.09862580895423889f, _131, (_128 * -0.02579331398010254f))) - _134) * _153) + _134;
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
#if 1  // begin FilmToneMap with BlueCorrect
  float _898, _899, _900;
  ApplyFilmToneMapWithBlueCorrect(_536, _538, _540,
                                  _898, _899, _900);
#else
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
  float _627 = ((float(((int)(uint)((bool)(_612 > 0.0f))) - ((int)(uint)((bool)(_612 < 0.0f)))) * (1.0f - (_616 * _616))) + 1.0f) * 0.02500000037252903f;
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
  float3 lerpColor = lerp(_710, float3(_707, _708, _709), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _576, _577, _578);
  float _898 = lerpColor.r, _899 = lerpColor.g, _900 = lerpColor.b;
#else
  float _756 = log2(lerp(_710, _707, 0.9599999785423279f)) * 0.3010300099849701f;
  float _757 = log2(lerp(_710, _708, 0.9599999785423279f)) * 0.3010300099849701f;
  float _758 = log2(lerp(_710, _709, 0.9599999785423279f)) * 0.3010300099849701f;
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

#endif
  // SetTonemappedAP1(_898, _899, _900);

  float _913 = mad((WorkingColorSpace.FromAP1[0].z), _900, mad((WorkingColorSpace.FromAP1[0].y), _899, ((WorkingColorSpace.FromAP1[0].x) * _898)));
  float _914 = mad((WorkingColorSpace.FromAP1[1].z), _900, mad((WorkingColorSpace.FromAP1[1].y), _899, ((WorkingColorSpace.FromAP1[1].x) * _898)));
  float _915 = mad((WorkingColorSpace.FromAP1[2].z), _900, mad((WorkingColorSpace.FromAP1[2].y), _899, ((WorkingColorSpace.FromAP1[2].x) * _898)));

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
  float _1018 = select((_994 > 0.040449999272823334f), exp2(log2((_994 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_994 * 0.07739938050508499f)); */

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

  if (GenerateOutput(_1053, _1054, _1055, SV_Target, is_hdr)) {
    return SV_Target;
  }

  float _1056 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _540, mad((WorkingColorSpace.FromAP1[0].y), _538, (_536 * (WorkingColorSpace.FromAP1[0].x))));
  float _1057 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _540, mad((WorkingColorSpace.FromAP1[1].y), _538, ((WorkingColorSpace.FromAP1[1].x) * _536)));
  float _1058 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _540, mad((WorkingColorSpace.FromAP1[2].y), _538, ((WorkingColorSpace.FromAP1[2].x) * _536)));
  float _1065 = ((OverlayColor.x - _1056) * OverlayColor.w) + _1056;
  float _1066 = ((OverlayColor.y - _1057) * OverlayColor.w) + _1057;
  float _1067 = ((OverlayColor.z - _1058) * OverlayColor.w) + _1058;
  float _1079 = exp2(log2(max(0.0f, _1053)) * InverseGamma.y);
  float _1080 = exp2(log2(max(0.0f, _1054)) * InverseGamma.y);
  float _1081 = exp2(log2(max(0.0f, _1055)) * InverseGamma.y);

  [branch]
  if ((uint)(output_device) == 0) {
    do {
      if ((uint)(WorkingColorSpace.bIsSRGB) == 0) {
        float _1104 = mad((WorkingColorSpace.ToAP1[0].z), _1081, mad((WorkingColorSpace.ToAP1[0].y), _1080, ((WorkingColorSpace.ToAP1[0].x) * _1079)));
        float _1107 = mad((WorkingColorSpace.ToAP1[1].z), _1081, mad((WorkingColorSpace.ToAP1[1].y), _1080, ((WorkingColorSpace.ToAP1[1].x) * _1079)));
        float _1110 = mad((WorkingColorSpace.ToAP1[2].z), _1081, mad((WorkingColorSpace.ToAP1[2].y), _1080, ((WorkingColorSpace.ToAP1[2].x) * _1079)));
        _1121 = mad(_47, _1110, mad(_46, _1107, (_1104 * _45)));
        _1122 = mad(_50, _1110, mad(_49, _1107, (_1104 * _48)));
        _1123 = mad(_53, _1110, mad(_52, _1107, (_1104 * _51)));
      } else {
        _1121 = _1079;
        _1122 = _1080;
        _1123 = _1081;
      }
      do {
        if (_1121 < 0.0031306699384003878f) {
          _1134 = (_1121 * 12.920000076293945f);
        } else {
          _1134 = (((pow(_1121, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1122 < 0.0031306699384003878f) {
            _1145 = (_1122 * 12.920000076293945f);
          } else {
            _1145 = (((pow(_1122, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1123 < 0.0031306699384003878f) {
            _2701 = _1134;
            _2702 = _1145;
            _2703 = (_1123 * 12.920000076293945f);
          } else {
            _2701 = _1134;
            _2702 = _1145;
            _2703 = (((pow(_1123, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(output_device) == 1) {
      float _1172 = mad((WorkingColorSpace.ToAP1[0].z), _1081, mad((WorkingColorSpace.ToAP1[0].y), _1080, ((WorkingColorSpace.ToAP1[0].x) * _1079)));
      float _1175 = mad((WorkingColorSpace.ToAP1[1].z), _1081, mad((WorkingColorSpace.ToAP1[1].y), _1080, ((WorkingColorSpace.ToAP1[1].x) * _1079)));
      float _1178 = mad((WorkingColorSpace.ToAP1[2].z), _1081, mad((WorkingColorSpace.ToAP1[2].y), _1080, ((WorkingColorSpace.ToAP1[2].x) * _1079)));
      float _1188 = max(6.103519990574569e-05f, mad(_47, _1178, mad(_46, _1175, (_1172 * _45))));
      float _1189 = max(6.103519990574569e-05f, mad(_50, _1178, mad(_49, _1175, (_1172 * _48))));
      float _1190 = max(6.103519990574569e-05f, mad(_53, _1178, mad(_52, _1175, (_1172 * _51))));
      _2701 = min((_1188 * 4.5f), ((exp2(log2(max(_1188, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2702 = min((_1189 * 4.5f), ((exp2(log2(max(_1189, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2703 = min((_1190 * 4.5f), ((exp2(log2(max(_1190, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(output_device) == 3) || (bool)((uint)(output_device) == 5)) {
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
        float _1266 = ACESSceneColorMultiplier * _1065;
        float _1267 = ACESSceneColorMultiplier * _1066;
        float _1268 = ACESSceneColorMultiplier * _1067;
        float _1271 = mad((WorkingColorSpace.ToAP0[0].z), _1268, mad((WorkingColorSpace.ToAP0[0].y), _1267, ((WorkingColorSpace.ToAP0[0].x) * _1266)));
        float _1274 = mad((WorkingColorSpace.ToAP0[1].z), _1268, mad((WorkingColorSpace.ToAP0[1].y), _1267, ((WorkingColorSpace.ToAP0[1].x) * _1266)));
        float _1277 = mad((WorkingColorSpace.ToAP0[2].z), _1268, mad((WorkingColorSpace.ToAP0[2].y), _1267, ((WorkingColorSpace.ToAP0[2].x) * _1266)));
        float _1280 = mad(-0.21492856740951538f, _1277, mad(-0.2365107536315918f, _1274, (_1271 * 1.4514392614364624f)));
        float _1283 = mad(-0.09967592358589172f, _1277, mad(1.17622971534729f, _1274, (_1271 * -0.07655377686023712f)));
        float _1286 = mad(0.9977163076400757f, _1277, mad(-0.006032449658960104f, _1274, (_1271 * 0.008316148072481155f)));
        float _1288 = max(_1280, max(_1283, _1286));
        do {
          if (!(_1288 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1271 < 0.0f) || (bool)(_1274 < 0.0f))) || (bool)(_1277 < 0.0f))) {
              float _1298 = abs(_1288);
              float _1299 = (_1288 - _1280) / _1298;
              float _1301 = (_1288 - _1283) / _1298;
              float _1303 = (_1288 - _1286) / _1298;
              do {
                if (!(_1299 < 0.8149999976158142f)) {
                  float _1306 = _1299 + -0.8149999976158142f;
                  _1318 = ((_1306 / exp2(log2(exp2(log2(_1306 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1318 = _1299;
                }
                do {
                  if (!(_1301 < 0.8029999732971191f)) {
                    float _1321 = _1301 + -0.8029999732971191f;
                    _1333 = ((_1321 / exp2(log2(exp2(log2(_1321 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1333 = _1301;
                  }
                  do {
                    if (!(_1303 < 0.8799999952316284f)) {
                      float _1336 = _1303 + -0.8799999952316284f;
                      _1348 = ((_1336 / exp2(log2(exp2(log2(_1336 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1348 = _1303;
                    }
                    _1356 = (_1288 - (_1298 * _1318));
                    _1357 = (_1288 - (_1298 * _1333));
                    _1358 = (_1288 - (_1298 * _1348));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1356 = _1280;
              _1357 = _1283;
              _1358 = _1286;
            }
          } else {
            _1356 = _1280;
            _1357 = _1283;
            _1358 = _1286;
          }
          float _1374 = ((mad(0.16386906802654266f, _1358, mad(0.14067870378494263f, _1357, (_1356 * 0.6954522132873535f))) - _1271) * ACESGamutCompression) + _1271;
          float _1375 = ((mad(0.0955343171954155f, _1358, mad(0.8596711158752441f, _1357, (_1356 * 0.044794563204050064f))) - _1274) * ACESGamutCompression) + _1274;
          float _1376 = ((mad(1.0015007257461548f, _1358, mad(0.004025210160762072f, _1357, (_1356 * -0.005525882821530104f))) - _1277) * ACESGamutCompression) + _1277;
          float _1380 = max(max(_1374, _1375), _1376);
          float _1385 = (max(_1380, 1.000000013351432e-10f) - max(min(min(_1374, _1375), _1376), 1.000000013351432e-10f)) / max(_1380, 0.009999999776482582f);
          float _1398 = ((_1375 + _1374) + _1376) + (sqrt((((_1376 - _1375) * _1376) + ((_1375 - _1374) * _1375)) + ((_1374 - _1376) * _1374)) * 1.75f);
          float _1399 = _1398 * 0.3333333432674408f;
          float _1400 = _1385 + -0.4000000059604645f;
          float _1401 = _1400 * 5.0f;
          float _1405 = max((1.0f - abs(_1400 * 2.5f)), 0.0f);
          float _1416 = ((float(((int)(uint)((bool)(_1401 > 0.0f))) - ((int)(uint)((bool)(_1401 < 0.0f)))) * (1.0f - (_1405 * _1405))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1399 <= 0.0533333346247673f)) {
              if (!(_1399 >= 0.1599999964237213f)) {
                _1425 = (((0.23999999463558197f / _1398) + -0.5f) * _1416);
              } else {
                _1425 = 0.0f;
              }
            } else {
              _1425 = _1416;
            }
            float _1426 = _1425 + 1.0f;
            float _1427 = _1426 * _1374;
            float _1428 = _1426 * _1375;
            float _1429 = _1426 * _1376;
            do {
              if (!((bool)(_1427 == _1428) && (bool)(_1428 == _1429))) {
                float _1436 = ((_1427 * 2.0f) - _1428) - _1429;
                float _1439 = ((_1375 - _1376) * 1.7320507764816284f) * _1426;
                float _1441 = atan(_1439 / _1436);
                bool _1444 = (_1436 < 0.0f);
                bool _1445 = (_1436 == 0.0f);
                bool _1446 = (_1439 >= 0.0f);
                bool _1447 = (_1439 < 0.0f);
                _1458 = select((_1446 && _1445), 90.0f, select((_1447 && _1445), -90.0f, (select((_1447 && _1444), (_1441 + -3.1415927410125732f), select((_1446 && _1444), (_1441 + 3.1415927410125732f), _1441)) * 57.2957763671875f)));
              } else {
                _1458 = 0.0f;
              }
              float _1463 = min(max(select((_1458 < 0.0f), (_1458 + 360.0f), _1458), 0.0f), 360.0f);
              do {
                if (_1463 < -180.0f) {
                  _1472 = (_1463 + 360.0f);
                } else {
                  if (_1463 > 180.0f) {
                    _1472 = (_1463 + -360.0f);
                  } else {
                    _1472 = _1463;
                  }
                }
                do {
                  if ((bool)(_1472 > -67.5f) && (bool)(_1472 < 67.5f)) {
                    float _1478 = (_1472 + 67.5f) * 0.029629629105329514f;
                    int _1479 = int(_1478);
                    float _1481 = _1478 - float(_1479);
                    float _1482 = _1481 * _1481;
                    float _1483 = _1482 * _1481;
                    if (_1479 == 3) {
                      _1511 = (((0.1666666716337204f - (_1481 * 0.5f)) + (_1482 * 0.5f)) - (_1483 * 0.1666666716337204f));
                    } else {
                      if (_1479 == 2) {
                        _1511 = ((0.6666666865348816f - _1482) + (_1483 * 0.5f));
                      } else {
                        if (_1479 == 1) {
                          _1511 = (((_1483 * -0.5f) + 0.1666666716337204f) + ((_1482 + _1481) * 0.5f));
                        } else {
                          _1511 = select((_1479 == 0), (_1483 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1511 = 0.0f;
                  }
                  float _1520 = min(max(((((_1385 * 0.27000001072883606f) * (0.029999999329447746f - _1427)) * _1511) + _1427), 0.0f), 65535.0f);
                  float _1521 = min(max(_1428, 0.0f), 65535.0f);
                  float _1522 = min(max(_1429, 0.0f), 65535.0f);
                  float _1535 = min(max(mad(-0.21492856740951538f, _1522, mad(-0.2365107536315918f, _1521, (_1520 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1536 = min(max(mad(-0.09967592358589172f, _1522, mad(1.17622971534729f, _1521, (_1520 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1537 = min(max(mad(0.9977163076400757f, _1522, mad(-0.006032449658960104f, _1521, (_1520 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1538 = dot(float3(_1535, _1536, _1537), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1549 = log2(max((lerp(_1538, _1535, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1550 = _1549 * 0.3010300099849701f;
                  float _1551 = log2(ACESMinMaxData.x);
                  float _1552 = _1551 * 0.3010300099849701f;
                  do {
                    if (!(!(_1550 <= _1552))) {
                      _1621 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1559 = log2(ACESMidData.x);
                      float _1560 = _1559 * 0.3010300099849701f;
                      if ((bool)(_1550 > _1552) && (bool)(_1550 < _1560)) {
                        float _1568 = ((_1549 - _1551) * 0.9030900001525879f) / ((_1559 - _1551) * 0.3010300099849701f);
                        int _1569 = int(_1568);
                        float _1571 = _1568 - float(_1569);
                        float _1573 = _12[_1569];
                        float _1576 = _12[(_1569 + 1)];
                        float _1581 = _1573 * 0.5f;
                        _1621 = dot(float3((_1571 * _1571), _1571, 1.0f), float3(mad((_12[(_1569 + 2)]), 0.5f, mad(_1576, -1.0f, _1581)), (_1576 - _1573), mad(_1576, 0.5f, _1581)));
                      } else {
                        do {
                          if (!(!(_1550 >= _1560))) {
                            float _1590 = log2(ACESMinMaxData.z);
                            if (_1550 < (_1590 * 0.3010300099849701f)) {
                              float _1598 = ((_1549 - _1559) * 0.9030900001525879f) / ((_1590 - _1559) * 0.3010300099849701f);
                              int _1599 = int(_1598);
                              float _1601 = _1598 - float(_1599);
                              float _1603 = _13[_1599];
                              float _1606 = _13[(_1599 + 1)];
                              float _1611 = _1603 * 0.5f;
                              _1621 = dot(float3((_1601 * _1601), _1601, 1.0f), float3(mad((_13[(_1599 + 2)]), 0.5f, mad(_1606, -1.0f, _1611)), (_1606 - _1603), mad(_1606, 0.5f, _1611)));
                              break;
                            }
                          }
                          _1621 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1625 = log2(max((lerp(_1538, _1536, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1626 = _1625 * 0.3010300099849701f;
                    do {
                      if (!(!(_1626 <= _1552))) {
                        _1695 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1633 = log2(ACESMidData.x);
                        float _1634 = _1633 * 0.3010300099849701f;
                        if ((bool)(_1626 > _1552) && (bool)(_1626 < _1634)) {
                          float _1642 = ((_1625 - _1551) * 0.9030900001525879f) / ((_1633 - _1551) * 0.3010300099849701f);
                          int _1643 = int(_1642);
                          float _1645 = _1642 - float(_1643);
                          float _1647 = _12[_1643];
                          float _1650 = _12[(_1643 + 1)];
                          float _1655 = _1647 * 0.5f;
                          _1695 = dot(float3((_1645 * _1645), _1645, 1.0f), float3(mad((_12[(_1643 + 2)]), 0.5f, mad(_1650, -1.0f, _1655)), (_1650 - _1647), mad(_1650, 0.5f, _1655)));
                        } else {
                          do {
                            if (!(!(_1626 >= _1634))) {
                              float _1664 = log2(ACESMinMaxData.z);
                              if (_1626 < (_1664 * 0.3010300099849701f)) {
                                float _1672 = ((_1625 - _1633) * 0.9030900001525879f) / ((_1664 - _1633) * 0.3010300099849701f);
                                int _1673 = int(_1672);
                                float _1675 = _1672 - float(_1673);
                                float _1677 = _13[_1673];
                                float _1680 = _13[(_1673 + 1)];
                                float _1685 = _1677 * 0.5f;
                                _1695 = dot(float3((_1675 * _1675), _1675, 1.0f), float3(mad((_13[(_1673 + 2)]), 0.5f, mad(_1680, -1.0f, _1685)), (_1680 - _1677), mad(_1680, 0.5f, _1685)));
                                break;
                              }
                            }
                            _1695 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1699 = log2(max((lerp(_1538, _1537, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1700 = _1699 * 0.3010300099849701f;
                      do {
                        if (!(!(_1700 <= _1552))) {
                          _1769 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1707 = log2(ACESMidData.x);
                          float _1708 = _1707 * 0.3010300099849701f;
                          if ((bool)(_1700 > _1552) && (bool)(_1700 < _1708)) {
                            float _1716 = ((_1699 - _1551) * 0.9030900001525879f) / ((_1707 - _1551) * 0.3010300099849701f);
                            int _1717 = int(_1716);
                            float _1719 = _1716 - float(_1717);
                            float _1721 = _12[_1717];
                            float _1724 = _12[(_1717 + 1)];
                            float _1729 = _1721 * 0.5f;
                            _1769 = dot(float3((_1719 * _1719), _1719, 1.0f), float3(mad((_12[(_1717 + 2)]), 0.5f, mad(_1724, -1.0f, _1729)), (_1724 - _1721), mad(_1724, 0.5f, _1729)));
                          } else {
                            do {
                              if (!(!(_1700 >= _1708))) {
                                float _1738 = log2(ACESMinMaxData.z);
                                if (_1700 < (_1738 * 0.3010300099849701f)) {
                                  float _1746 = ((_1699 - _1707) * 0.9030900001525879f) / ((_1738 - _1707) * 0.3010300099849701f);
                                  int _1747 = int(_1746);
                                  float _1749 = _1746 - float(_1747);
                                  float _1751 = _13[_1747];
                                  float _1754 = _13[(_1747 + 1)];
                                  float _1759 = _1751 * 0.5f;
                                  _1769 = dot(float3((_1749 * _1749), _1749, 1.0f), float3(mad((_13[(_1747 + 2)]), 0.5f, mad(_1754, -1.0f, _1759)), (_1754 - _1751), mad(_1754, 0.5f, _1759)));
                                  break;
                                }
                              }
                              _1769 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1773 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1774 = (exp2(_1621 * 3.321928024291992f) - ACESMinMaxData.y) / _1773;
                        float _1776 = (exp2(_1695 * 3.321928024291992f) - ACESMinMaxData.y) / _1773;
                        float _1778 = (exp2(_1769 * 3.321928024291992f) - ACESMinMaxData.y) / _1773;
                        float _1781 = mad(0.15618768334388733f, _1778, mad(0.13400420546531677f, _1776, (_1774 * 0.6624541878700256f)));
                        float _1784 = mad(0.053689517080783844f, _1778, mad(0.6740817427635193f, _1776, (_1774 * 0.2722287178039551f)));
                        float _1787 = mad(1.0103391408920288f, _1778, mad(0.00406073359772563f, _1776, (_1774 * -0.005574649665504694f)));
                        float _1800 = min(max(mad(-0.23642469942569733f, _1787, mad(-0.32480329275131226f, _1784, (_1781 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1801 = min(max(mad(0.016756348311901093f, _1787, mad(1.6153316497802734f, _1784, (_1781 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1802 = min(max(mad(0.9883948564529419f, _1787, mad(-0.008284442126750946f, _1784, (_1781 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1805 = mad(0.15618768334388733f, _1802, mad(0.13400420546531677f, _1801, (_1800 * 0.6624541878700256f)));
                        float _1808 = mad(0.053689517080783844f, _1802, mad(0.6740817427635193f, _1801, (_1800 * 0.2722287178039551f)));
                        float _1811 = mad(1.0103391408920288f, _1802, mad(0.00406073359772563f, _1801, (_1800 * -0.005574649665504694f)));
                        float _1833 = min(max((min(max(mad(-0.23642469942569733f, _1811, mad(-0.32480329275131226f, _1808, (_1805 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1834 = min(max((min(max(mad(0.016756348311901093f, _1811, mad(1.6153316497802734f, _1808, (_1805 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1835 = min(max((min(max(mad(0.9883948564529419f, _1811, mad(-0.008284442126750946f, _1808, (_1805 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(output_device) == 5)) {
                            _1848 = mad(_47, _1835, mad(_46, _1834, (_1833 * _45)));
                            _1849 = mad(_50, _1835, mad(_49, _1834, (_1833 * _48)));
                            _1850 = mad(_53, _1835, mad(_52, _1834, (_1833 * _51)));
                          } else {
                            _1848 = _1833;
                            _1849 = _1834;
                            _1850 = _1835;
                          }
                          float _1860 = exp2(log2(_1848 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1861 = exp2(log2(_1849 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1862 = exp2(log2(_1850 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2701 = exp2(log2((1.0f / ((_1860 * 18.6875f) + 1.0f)) * ((_1860 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2702 = exp2(log2((1.0f / ((_1861 * 18.6875f) + 1.0f)) * ((_1861 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2703 = exp2(log2((1.0f / ((_1862 * 18.6875f) + 1.0f)) * ((_1862 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1940 = ACESSceneColorMultiplier * _1065;
          float _1941 = ACESSceneColorMultiplier * _1066;
          float _1942 = ACESSceneColorMultiplier * _1067;
          float _1945 = mad((WorkingColorSpace.ToAP0[0].z), _1942, mad((WorkingColorSpace.ToAP0[0].y), _1941, ((WorkingColorSpace.ToAP0[0].x) * _1940)));
          float _1948 = mad((WorkingColorSpace.ToAP0[1].z), _1942, mad((WorkingColorSpace.ToAP0[1].y), _1941, ((WorkingColorSpace.ToAP0[1].x) * _1940)));
          float _1951 = mad((WorkingColorSpace.ToAP0[2].z), _1942, mad((WorkingColorSpace.ToAP0[2].y), _1941, ((WorkingColorSpace.ToAP0[2].x) * _1940)));
          float _1954 = mad(-0.21492856740951538f, _1951, mad(-0.2365107536315918f, _1948, (_1945 * 1.4514392614364624f)));
          float _1957 = mad(-0.09967592358589172f, _1951, mad(1.17622971534729f, _1948, (_1945 * -0.07655377686023712f)));
          float _1960 = mad(0.9977163076400757f, _1951, mad(-0.006032449658960104f, _1948, (_1945 * 0.008316148072481155f)));
          float _1962 = max(_1954, max(_1957, _1960));
          do {
            if (!(_1962 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1945 < 0.0f) || (bool)(_1948 < 0.0f))) || (bool)(_1951 < 0.0f))) {
                float _1972 = abs(_1962);
                float _1973 = (_1962 - _1954) / _1972;
                float _1975 = (_1962 - _1957) / _1972;
                float _1977 = (_1962 - _1960) / _1972;
                do {
                  if (!(_1973 < 0.8149999976158142f)) {
                    float _1980 = _1973 + -0.8149999976158142f;
                    _1992 = ((_1980 / exp2(log2(exp2(log2(_1980 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _1992 = _1973;
                  }
                  do {
                    if (!(_1975 < 0.8029999732971191f)) {
                      float _1995 = _1975 + -0.8029999732971191f;
                      _2007 = ((_1995 / exp2(log2(exp2(log2(_1995 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2007 = _1975;
                    }
                    do {
                      if (!(_1977 < 0.8799999952316284f)) {
                        float _2010 = _1977 + -0.8799999952316284f;
                        _2022 = ((_2010 / exp2(log2(exp2(log2(_2010 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2022 = _1977;
                      }
                      _2030 = (_1962 - (_1972 * _1992));
                      _2031 = (_1962 - (_1972 * _2007));
                      _2032 = (_1962 - (_1972 * _2022));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2030 = _1954;
                _2031 = _1957;
                _2032 = _1960;
              }
            } else {
              _2030 = _1954;
              _2031 = _1957;
              _2032 = _1960;
            }
            float _2048 = ((mad(0.16386906802654266f, _2032, mad(0.14067870378494263f, _2031, (_2030 * 0.6954522132873535f))) - _1945) * ACESGamutCompression) + _1945;
            float _2049 = ((mad(0.0955343171954155f, _2032, mad(0.8596711158752441f, _2031, (_2030 * 0.044794563204050064f))) - _1948) * ACESGamutCompression) + _1948;
            float _2050 = ((mad(1.0015007257461548f, _2032, mad(0.004025210160762072f, _2031, (_2030 * -0.005525882821530104f))) - _1951) * ACESGamutCompression) + _1951;
            float _2054 = max(max(_2048, _2049), _2050);
            float _2059 = (max(_2054, 1.000000013351432e-10f) - max(min(min(_2048, _2049), _2050), 1.000000013351432e-10f)) / max(_2054, 0.009999999776482582f);
            float _2072 = ((_2049 + _2048) + _2050) + (sqrt((((_2050 - _2049) * _2050) + ((_2049 - _2048) * _2049)) + ((_2048 - _2050) * _2048)) * 1.75f);
            float _2073 = _2072 * 0.3333333432674408f;
            float _2074 = _2059 + -0.4000000059604645f;
            float _2075 = _2074 * 5.0f;
            float _2079 = max((1.0f - abs(_2074 * 2.5f)), 0.0f);
            float _2090 = ((float(((int)(uint)((bool)(_2075 > 0.0f))) - ((int)(uint)((bool)(_2075 < 0.0f)))) * (1.0f - (_2079 * _2079))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2073 <= 0.0533333346247673f)) {
                if (!(_2073 >= 0.1599999964237213f)) {
                  _2099 = (((0.23999999463558197f / _2072) + -0.5f) * _2090);
                } else {
                  _2099 = 0.0f;
                }
              } else {
                _2099 = _2090;
              }
              float _2100 = _2099 + 1.0f;
              float _2101 = _2100 * _2048;
              float _2102 = _2100 * _2049;
              float _2103 = _2100 * _2050;
              do {
                if (!((bool)(_2101 == _2102) && (bool)(_2102 == _2103))) {
                  float _2110 = ((_2101 * 2.0f) - _2102) - _2103;
                  float _2113 = ((_2049 - _2050) * 1.7320507764816284f) * _2100;
                  float _2115 = atan(_2113 / _2110);
                  bool _2118 = (_2110 < 0.0f);
                  bool _2119 = (_2110 == 0.0f);
                  bool _2120 = (_2113 >= 0.0f);
                  bool _2121 = (_2113 < 0.0f);
                  _2132 = select((_2120 && _2119), 90.0f, select((_2121 && _2119), -90.0f, (select((_2121 && _2118), (_2115 + -3.1415927410125732f), select((_2120 && _2118), (_2115 + 3.1415927410125732f), _2115)) * 57.2957763671875f)));
                } else {
                  _2132 = 0.0f;
                }
                float _2137 = min(max(select((_2132 < 0.0f), (_2132 + 360.0f), _2132), 0.0f), 360.0f);
                do {
                  if (_2137 < -180.0f) {
                    _2146 = (_2137 + 360.0f);
                  } else {
                    if (_2137 > 180.0f) {
                      _2146 = (_2137 + -360.0f);
                    } else {
                      _2146 = _2137;
                    }
                  }
                  do {
                    if ((bool)(_2146 > -67.5f) && (bool)(_2146 < 67.5f)) {
                      float _2152 = (_2146 + 67.5f) * 0.029629629105329514f;
                      int _2153 = int(_2152);
                      float _2155 = _2152 - float(_2153);
                      float _2156 = _2155 * _2155;
                      float _2157 = _2156 * _2155;
                      if (_2153 == 3) {
                        _2185 = (((0.1666666716337204f - (_2155 * 0.5f)) + (_2156 * 0.5f)) - (_2157 * 0.1666666716337204f));
                      } else {
                        if (_2153 == 2) {
                          _2185 = ((0.6666666865348816f - _2156) + (_2157 * 0.5f));
                        } else {
                          if (_2153 == 1) {
                            _2185 = (((_2157 * -0.5f) + 0.1666666716337204f) + ((_2156 + _2155) * 0.5f));
                          } else {
                            _2185 = select((_2153 == 0), (_2157 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2185 = 0.0f;
                    }
                    float _2194 = min(max(((((_2059 * 0.27000001072883606f) * (0.029999999329447746f - _2101)) * _2185) + _2101), 0.0f), 65535.0f);
                    float _2195 = min(max(_2102, 0.0f), 65535.0f);
                    float _2196 = min(max(_2103, 0.0f), 65535.0f);
                    float _2209 = min(max(mad(-0.21492856740951538f, _2196, mad(-0.2365107536315918f, _2195, (_2194 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2210 = min(max(mad(-0.09967592358589172f, _2196, mad(1.17622971534729f, _2195, (_2194 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2211 = min(max(mad(0.9977163076400757f, _2196, mad(-0.006032449658960104f, _2195, (_2194 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2212 = dot(float3(_2209, _2210, _2211), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2223 = log2(max((lerp(_2212, _2209, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2224 = _2223 * 0.3010300099849701f;
                    float _2225 = log2(ACESMinMaxData.x);
                    float _2226 = _2225 * 0.3010300099849701f;
                    do {
                      if (!(!(_2224 <= _2226))) {
                        _2295 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2233 = log2(ACESMidData.x);
                        float _2234 = _2233 * 0.3010300099849701f;
                        if ((bool)(_2224 > _2226) && (bool)(_2224 < _2234)) {
                          float _2242 = ((_2223 - _2225) * 0.9030900001525879f) / ((_2233 - _2225) * 0.3010300099849701f);
                          int _2243 = int(_2242);
                          float _2245 = _2242 - float(_2243);
                          float _2247 = _10[_2243];
                          float _2250 = _10[(_2243 + 1)];
                          float _2255 = _2247 * 0.5f;
                          _2295 = dot(float3((_2245 * _2245), _2245, 1.0f), float3(mad((_10[(_2243 + 2)]), 0.5f, mad(_2250, -1.0f, _2255)), (_2250 - _2247), mad(_2250, 0.5f, _2255)));
                        } else {
                          do {
                            if (!(!(_2224 >= _2234))) {
                              float _2264 = log2(ACESMinMaxData.z);
                              if (_2224 < (_2264 * 0.3010300099849701f)) {
                                float _2272 = ((_2223 - _2233) * 0.9030900001525879f) / ((_2264 - _2233) * 0.3010300099849701f);
                                int _2273 = int(_2272);
                                float _2275 = _2272 - float(_2273);
                                float _2277 = _11[_2273];
                                float _2280 = _11[(_2273 + 1)];
                                float _2285 = _2277 * 0.5f;
                                _2295 = dot(float3((_2275 * _2275), _2275, 1.0f), float3(mad((_11[(_2273 + 2)]), 0.5f, mad(_2280, -1.0f, _2285)), (_2280 - _2277), mad(_2280, 0.5f, _2285)));
                                break;
                              }
                            }
                            _2295 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2299 = log2(max((lerp(_2212, _2210, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2300 = _2299 * 0.3010300099849701f;
                      do {
                        if (!(!(_2300 <= _2226))) {
                          _2369 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2307 = log2(ACESMidData.x);
                          float _2308 = _2307 * 0.3010300099849701f;
                          if ((bool)(_2300 > _2226) && (bool)(_2300 < _2308)) {
                            float _2316 = ((_2299 - _2225) * 0.9030900001525879f) / ((_2307 - _2225) * 0.3010300099849701f);
                            int _2317 = int(_2316);
                            float _2319 = _2316 - float(_2317);
                            float _2321 = _10[_2317];
                            float _2324 = _10[(_2317 + 1)];
                            float _2329 = _2321 * 0.5f;
                            _2369 = dot(float3((_2319 * _2319), _2319, 1.0f), float3(mad((_10[(_2317 + 2)]), 0.5f, mad(_2324, -1.0f, _2329)), (_2324 - _2321), mad(_2324, 0.5f, _2329)));
                          } else {
                            do {
                              if (!(!(_2300 >= _2308))) {
                                float _2338 = log2(ACESMinMaxData.z);
                                if (_2300 < (_2338 * 0.3010300099849701f)) {
                                  float _2346 = ((_2299 - _2307) * 0.9030900001525879f) / ((_2338 - _2307) * 0.3010300099849701f);
                                  int _2347 = int(_2346);
                                  float _2349 = _2346 - float(_2347);
                                  float _2351 = _11[_2347];
                                  float _2354 = _11[(_2347 + 1)];
                                  float _2359 = _2351 * 0.5f;
                                  _2369 = dot(float3((_2349 * _2349), _2349, 1.0f), float3(mad((_11[(_2347 + 2)]), 0.5f, mad(_2354, -1.0f, _2359)), (_2354 - _2351), mad(_2354, 0.5f, _2359)));
                                  break;
                                }
                              }
                              _2369 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2373 = log2(max((lerp(_2212, _2211, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2374 = _2373 * 0.3010300099849701f;
                        do {
                          if (!(!(_2374 <= _2226))) {
                            _2443 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2381 = log2(ACESMidData.x);
                            float _2382 = _2381 * 0.3010300099849701f;
                            if ((bool)(_2374 > _2226) && (bool)(_2374 < _2382)) {
                              float _2390 = ((_2373 - _2225) * 0.9030900001525879f) / ((_2381 - _2225) * 0.3010300099849701f);
                              int _2391 = int(_2390);
                              float _2393 = _2390 - float(_2391);
                              float _2395 = _10[_2391];
                              float _2398 = _10[(_2391 + 1)];
                              float _2403 = _2395 * 0.5f;
                              _2443 = dot(float3((_2393 * _2393), _2393, 1.0f), float3(mad((_10[(_2391 + 2)]), 0.5f, mad(_2398, -1.0f, _2403)), (_2398 - _2395), mad(_2398, 0.5f, _2403)));
                            } else {
                              do {
                                if (!(!(_2374 >= _2382))) {
                                  float _2412 = log2(ACESMinMaxData.z);
                                  if (_2374 < (_2412 * 0.3010300099849701f)) {
                                    float _2420 = ((_2373 - _2381) * 0.9030900001525879f) / ((_2412 - _2381) * 0.3010300099849701f);
                                    int _2421 = int(_2420);
                                    float _2423 = _2420 - float(_2421);
                                    float _2425 = _11[_2421];
                                    float _2428 = _11[(_2421 + 1)];
                                    float _2433 = _2425 * 0.5f;
                                    _2443 = dot(float3((_2423 * _2423), _2423, 1.0f), float3(mad((_11[(_2421 + 2)]), 0.5f, mad(_2428, -1.0f, _2433)), (_2428 - _2425), mad(_2428, 0.5f, _2433)));
                                    break;
                                  }
                                }
                                _2443 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2447 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2448 = (exp2(_2295 * 3.321928024291992f) - ACESMinMaxData.y) / _2447;
                          float _2450 = (exp2(_2369 * 3.321928024291992f) - ACESMinMaxData.y) / _2447;
                          float _2452 = (exp2(_2443 * 3.321928024291992f) - ACESMinMaxData.y) / _2447;
                          float _2455 = mad(0.15618768334388733f, _2452, mad(0.13400420546531677f, _2450, (_2448 * 0.6624541878700256f)));
                          float _2458 = mad(0.053689517080783844f, _2452, mad(0.6740817427635193f, _2450, (_2448 * 0.2722287178039551f)));
                          float _2461 = mad(1.0103391408920288f, _2452, mad(0.00406073359772563f, _2450, (_2448 * -0.005574649665504694f)));
                          float _2474 = min(max(mad(-0.23642469942569733f, _2461, mad(-0.32480329275131226f, _2458, (_2455 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2475 = min(max(mad(0.016756348311901093f, _2461, mad(1.6153316497802734f, _2458, (_2455 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2476 = min(max(mad(0.9883948564529419f, _2461, mad(-0.008284442126750946f, _2458, (_2455 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2479 = mad(0.15618768334388733f, _2476, mad(0.13400420546531677f, _2475, (_2474 * 0.6624541878700256f)));
                          float _2482 = mad(0.053689517080783844f, _2476, mad(0.6740817427635193f, _2475, (_2474 * 0.2722287178039551f)));
                          float _2485 = mad(1.0103391408920288f, _2476, mad(0.00406073359772563f, _2475, (_2474 * -0.005574649665504694f)));
                          float _2507 = min(max((min(max(mad(-0.23642469942569733f, _2485, mad(-0.32480329275131226f, _2482, (_2479 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2508 = min(max((min(max(mad(0.016756348311901093f, _2485, mad(1.6153316497802734f, _2482, (_2479 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2509 = min(max((min(max(mad(0.9883948564529419f, _2485, mad(-0.008284442126750946f, _2482, (_2479 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!((uint)(output_device) == 6)) {
                              _2522 = mad(_47, _2509, mad(_46, _2508, (_2507 * _45)));
                              _2523 = mad(_50, _2509, mad(_49, _2508, (_2507 * _48)));
                              _2524 = mad(_53, _2509, mad(_52, _2508, (_2507 * _51)));
                            } else {
                              _2522 = _2507;
                              _2523 = _2508;
                              _2524 = _2509;
                            }
                            float _2534 = exp2(log2(_2522 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2535 = exp2(log2(_2523 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2536 = exp2(log2(_2524 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2701 = exp2(log2((1.0f / ((_2534 * 18.6875f) + 1.0f)) * ((_2534 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2702 = exp2(log2((1.0f / ((_2535 * 18.6875f) + 1.0f)) * ((_2535 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2703 = exp2(log2((1.0f / ((_2536 * 18.6875f) + 1.0f)) * ((_2536 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2581 = mad((WorkingColorSpace.ToAP1[0].z), _1067, mad((WorkingColorSpace.ToAP1[0].y), _1066, ((WorkingColorSpace.ToAP1[0].x) * _1065)));
            float _2584 = mad((WorkingColorSpace.ToAP1[1].z), _1067, mad((WorkingColorSpace.ToAP1[1].y), _1066, ((WorkingColorSpace.ToAP1[1].x) * _1065)));
            float _2587 = mad((WorkingColorSpace.ToAP1[2].z), _1067, mad((WorkingColorSpace.ToAP1[2].y), _1066, ((WorkingColorSpace.ToAP1[2].x) * _1065)));
            float _2606 = exp2(log2(mad(_47, _2587, mad(_46, _2584, (_2581 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2607 = exp2(log2(mad(_50, _2587, mad(_49, _2584, (_2581 * _48))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2608 = exp2(log2(mad(_53, _2587, mad(_52, _2584, (_2581 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2701 = exp2(log2((1.0f / ((_2606 * 18.6875f) + 1.0f)) * ((_2606 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2702 = exp2(log2((1.0f / ((_2607 * 18.6875f) + 1.0f)) * ((_2607 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2703 = exp2(log2((1.0f / ((_2608 * 18.6875f) + 1.0f)) * ((_2608 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(output_device) == 8)) {
              if ((uint)(output_device) == 9) {
                float _2655 = mad((WorkingColorSpace.ToAP1[0].z), _1055, mad((WorkingColorSpace.ToAP1[0].y), _1054, ((WorkingColorSpace.ToAP1[0].x) * _1053)));
                float _2658 = mad((WorkingColorSpace.ToAP1[1].z), _1055, mad((WorkingColorSpace.ToAP1[1].y), _1054, ((WorkingColorSpace.ToAP1[1].x) * _1053)));
                float _2661 = mad((WorkingColorSpace.ToAP1[2].z), _1055, mad((WorkingColorSpace.ToAP1[2].y), _1054, ((WorkingColorSpace.ToAP1[2].x) * _1053)));
                _2701 = mad(_47, _2661, mad(_46, _2658, (_2655 * _45)));
                _2702 = mad(_50, _2661, mad(_49, _2658, (_2655 * _48)));
                _2703 = mad(_53, _2661, mad(_52, _2658, (_2655 * _51)));
              } else {
                float _2674 = mad((WorkingColorSpace.ToAP1[0].z), _1081, mad((WorkingColorSpace.ToAP1[0].y), _1080, ((WorkingColorSpace.ToAP1[0].x) * _1079)));
                float _2677 = mad((WorkingColorSpace.ToAP1[1].z), _1081, mad((WorkingColorSpace.ToAP1[1].y), _1080, ((WorkingColorSpace.ToAP1[1].x) * _1079)));
                float _2680 = mad((WorkingColorSpace.ToAP1[2].z), _1081, mad((WorkingColorSpace.ToAP1[2].y), _1080, ((WorkingColorSpace.ToAP1[2].x) * _1079)));
                _2701 = exp2(log2(mad(_47, _2680, mad(_46, _2677, (_2674 * _45)))) * InverseGamma.z);
                _2702 = exp2(log2(mad(_50, _2680, mad(_49, _2677, (_2674 * _48)))) * InverseGamma.z);
                _2703 = exp2(log2(mad(_53, _2680, mad(_52, _2677, (_2674 * _51)))) * InverseGamma.z);
              }
            } else {
              _2701 = _1065;
              _2702 = _1066;
              _2703 = _1067;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2701 * 0.9523810148239136f);
  SV_Target.y = (_2702 * 0.9523810148239136f);
  SV_Target.z = (_2703 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

#include "../../common.hlsl"

Texture2D<float4> Textures_1 : register(t0);

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

SamplerState Samplers_1 : register(s0);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _12 = 0.5f / LUTSize;
  float _17 = LUTSize + -1.0f;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _569;
  float _602;
  float _616;
  float _680;
  float _871;
  float _882;
  float _893;
  float _1050;
  float _1051;
  float _1052;
  float _1063;
  float _1074;
  float _1085;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _30 = (OutputGamut == 4);
        _41 = select(_30, 1.0f, 1.705051064491272f);
        _42 = select(_30, 0.0f, -0.6217921376228333f);
        _43 = select(_30, 0.0f, -0.0832589864730835f);
        _44 = select(_30, 0.0f, -0.13025647401809692f);
        _45 = select(_30, 1.0f, 1.140804648399353f);
        _46 = select(_30, 0.0f, -0.010548308491706848f);
        _47 = select(_30, 0.0f, -0.024003351107239723f);
        _48 = select(_30, 0.0f, -0.1289689838886261f);
        _49 = select(_30, 1.0f, 1.1529725790023804f);
      } else {
        _41 = 0.6954522132873535f;
        _42 = 0.14067870378494263f;
        _43 = 0.16386906802654266f;
        _44 = 0.044794563204050064f;
        _45 = 0.8596711158752441f;
        _46 = 0.0955343171954155f;
        _47 = -0.005525882821530104f;
        _48 = 0.004025210160762072f;
        _49 = 1.0015007257461548f;
      }
    } else {
      _41 = 1.0258246660232544f;
      _42 = -0.020053181797266006f;
      _43 = -0.005771636962890625f;
      _44 = -0.002234415616840124f;
      _45 = 1.0045864582061768f;
      _46 = -0.002352118492126465f;
      _47 = -0.005013350863009691f;
      _48 = -0.025290070101618767f;
      _49 = 1.0303035974502563f;
    }
  } else {
    _41 = 1.3792141675949097f;
    _42 = -0.30886411666870117f;
    _43 = -0.0703500509262085f;
    _44 = -0.06933490186929703f;
    _45 = 1.08229660987854f;
    _46 = -0.012961871922016144f;
    _47 = -0.0021590073592960835f;
    _48 = -0.0454593189060688f;
    _49 = 1.0476183891296387f;
  }
  float _62 = (exp2((((LUTSize * (TEXCOORD.x - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _63 = (exp2((((LUTSize * (TEXCOORD.y - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _64 = (exp2(((float((uint)(int)(SV_RenderTargetArrayIndex)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _79 = mad((WorkingColorSpace_ToAP1[0].z), _64, mad((WorkingColorSpace_ToAP1[0].y), _63, ((WorkingColorSpace_ToAP1[0].x) * _62)));
  float _82 = mad((WorkingColorSpace_ToAP1[1].z), _64, mad((WorkingColorSpace_ToAP1[1].y), _63, ((WorkingColorSpace_ToAP1[1].x) * _62)));
  float _85 = mad((WorkingColorSpace_ToAP1[2].z), _64, mad((WorkingColorSpace_ToAP1[2].y), _63, ((WorkingColorSpace_ToAP1[2].x) * _62)));
  float _86 = dot(float3(_79, _82, _85), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_79, _82, _85));

  float _90 = (_79 / _86) + -1.0f;
  float _91 = (_82 / _86) + -1.0f;
  float _92 = (_85 / _86) + -1.0f;
  float _104 = (1.0f - exp2(((_86 * _86) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_90, _91, _92), float3(_90, _91, _92)) * -4.0f));
  float _120 = ((mad(-0.06368321925401688f, _85, mad(-0.3292922377586365f, _82, (_79 * 1.3704125881195068f))) - _79) * _104) + _79;
  float _121 = ((mad(-0.010861365124583244f, _85, mad(1.0970927476882935f, _82, (_79 * -0.08343357592821121f))) - _82) * _104) + _82;
  float _122 = ((mad(1.2036951780319214f, _85, mad(-0.09862580895423889f, _82, (_79 * -0.02579331398010254f))) - _85) * _104) + _85;
  float _123 = dot(float3(_120, _121, _122), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _137 = ColorOffset.w + ColorOffsetShadows.w;
  float _151 = ColorGain.w * ColorGainShadows.w;
  float _165 = ColorGamma.w * ColorGammaShadows.w;
  float _179 = ColorContrast.w * ColorContrastShadows.w;
  float _193 = ColorSaturation.w * ColorSaturationShadows.w;
  float _197 = _120 - _123;
  float _198 = _121 - _123;
  float _199 = _122 - _123;
  float _256 = saturate(_123 / ColorCorrectionShadowsMax);
  float _260 = (_256 * _256) * (3.0f - (_256 * 2.0f));
  float _261 = 1.0f - _260;
  float _270 = ColorOffset.w + ColorOffsetHighlights.w;
  float _279 = ColorGain.w * ColorGainHighlights.w;
  float _288 = ColorGamma.w * ColorGammaHighlights.w;
  float _297 = ColorContrast.w * ColorContrastHighlights.w;
  float _306 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _369 = saturate((_123 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _373 = (_369 * _369) * (3.0f - (_369 * 2.0f));
  float _385 = ColorOffset.w + ColorOffsetMidtones.w;
  float _394 = ColorGain.w * ColorGainMidtones.w;
  float _403 = ColorGamma.w * ColorGammaMidtones.w;
  float _412 = ColorContrast.w * ColorContrastMidtones.w;
  float _421 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _479 = _260 - _373;
  float _490 = ((_373 * min(1e+05f, (((ColorOffset.x + ColorOffsetHighlights.x) + _270) + (((ColorGain.x * ColorGainHighlights.x) * _279) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _297) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _306) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _288))))))) + (_261 * (((ColorOffset.x + ColorOffsetShadows.x) + _137) + (((ColorGain.x * ColorGainShadows.x) * _151) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _179) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _193) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _165))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _385) + (((ColorGain.x * ColorGainMidtones.x) * _394) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _412) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _421) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _403))))) * _479);
  float _492 = ((_373 * min(1e+05f, (((ColorOffset.y + ColorOffsetHighlights.y) + _270) + (((ColorGain.y * ColorGainHighlights.y) * _279) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _297) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _306) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _288))))))) + (_261 * (((ColorOffset.y + ColorOffsetShadows.y) + _137) + (((ColorGain.y * ColorGainShadows.y) * _151) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _179) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _193) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _165))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _385) + (((ColorGain.y * ColorGainMidtones.y) * _394) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _412) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _421) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _403))))) * _479);
  float _494 = ((min(1e+05f, (((ColorOffset.z + ColorOffsetHighlights.z) + _270) + (((ColorGain.z * ColorGainHighlights.z) * _279) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _297) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _306) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _288)))))) * _373) + (_261 * (((ColorOffset.z + ColorOffsetShadows.z) + _137) + (((ColorGain.z * ColorGainShadows.z) * _151) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _179) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _193) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _165))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _385) + (((ColorGain.z * ColorGainMidtones.z) * _394) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _412) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _421) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _403))))) * _479);

  SetUntonemappedAP1(float3(_490, _492, _494));

  float _509 = ((mad(0.061360642313957214f, _494, mad(-4.540197551250458e-09f, _492, (_490 * 0.9386394023895264f))) - _490) * BlueCorrection) + _490;
  float _510 = ((mad(0.169205904006958f, _494, mad(0.8307942152023315f, _492, (_490 * 6.775371730327606e-08f))) - _492) * BlueCorrection) + _492;
  float _511 = (mad(-2.3283064365386963e-10f, _492, (_490 * -9.313225746154785e-10f)) * BlueCorrection) + _494;
  float _514 = mad(0.16386905312538147f, _511, mad(0.14067868888378143f, _510, (_509 * 0.6954522132873535f)));
  float _517 = mad(0.0955343246459961f, _511, mad(0.8596711158752441f, _510, (_509 * 0.044794581830501556f)));
  float _520 = mad(1.0015007257461548f, _511, mad(0.004025210160762072f, _510, (_509 * -0.005525882821530104f)));
  float _524 = max(max(_514, _517), _520);
  float _529 = (max(_524, 1.000000013351432e-10f) - max(min(min(_514, _517), _520), 1.000000013351432e-10f)) / max(_524, 0.009999999776482582f);
  float _542 = ((_517 + _514) + _520) + (sqrt((((_520 - _517) * _520) + ((_517 - _514) * _517)) + ((_514 - _520) * _514)) * 1.75f);
  float _543 = _542 * 0.3333333432674408f;
  float _544 = _529 + -0.4000000059604645f;
  float _545 = _544 * 5.0f;
  float _549 = max((1.0f - abs(_544 * 2.5f)), 0.0f);
  float _560 = ((float((int)(((int)(uint)((bool)(_545 > 0.0f))) - ((int)(uint)((bool)(_545 < 0.0f))))) * (1.0f - (_549 * _549))) + 1.0f) * 0.02500000037252903f;
  if (!(_543 <= 0.0533333346247673f)) {
    if (!(_543 >= 0.1599999964237213f)) {
      _569 = (((0.23999999463558197f / _542) + -0.5f) * _560);
    } else {
      _569 = 0.0f;
    }
  } else {
    _569 = _560;
  }
  float _570 = _569 + 1.0f;
  float _571 = _570 * _514;
  float _572 = _570 * _517;
  float _573 = _570 * _520;
  if (!((bool)(_571 == _572) && (bool)(_572 == _573))) {
    float _580 = ((_571 * 2.0f) - _572) - _573;
    float _583 = ((_517 - _520) * 1.7320507764816284f) * _570;
    float _585 = atan(_583 / _580);
    bool _588 = (_580 < 0.0f);
    bool _589 = (_580 == 0.0f);
    bool _590 = (_583 >= 0.0f);
    bool _591 = (_583 < 0.0f);
    _602 = select((_590 && _589), 90.0f, select((_591 && _589), -90.0f, (select((_591 && _588), (_585 + -3.1415927410125732f), select((_590 && _588), (_585 + 3.1415927410125732f), _585)) * 57.2957763671875f)));
  } else {
    _602 = 0.0f;
  }
  float _607 = min(max(select((_602 < 0.0f), (_602 + 360.0f), _602), 0.0f), 360.0f);
  if (_607 < -180.0f) {
    _616 = (_607 + 360.0f);
  } else {
    if (_607 > 180.0f) {
      _616 = (_607 + -360.0f);
    } else {
      _616 = _607;
    }
  }
  float _620 = saturate(1.0f - abs(_616 * 0.014814814552664757f));
  float _624 = (_620 * _620) * (3.0f - (_620 * 2.0f));
  float _630 = ((_624 * _624) * ((_529 * 0.18000000715255737f) * (0.029999999329447746f - _571))) + _571;
  float _640 = max(0.0f, mad(-0.21492856740951538f, _573, mad(-0.2365107536315918f, _572, (_630 * 1.4514392614364624f))));
  float _641 = max(0.0f, mad(-0.09967592358589172f, _573, mad(1.17622971534729f, _572, (_630 * -0.07655377686023712f))));
  float _642 = max(0.0f, mad(0.9977163076400757f, _573, mad(-0.006032449658960104f, _572, (_630 * 0.008316148072481155f))));
  float _643 = dot(float3(_640, _641, _642), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _658 = (FilmBlackClip + 1.0f) - FilmToe;
  float _660 = FilmWhiteClip + 1.0f;
  float _662 = _660 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _680 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _671 = (FilmBlackClip + 0.18000000715255737f) / _658;
    _680 = (-0.7447274923324585f - ((log2(_671 / (2.0f - _671)) * 0.3465735912322998f) * (_658 / FilmSlope)));
  }
  float _683 = ((1.0f - FilmToe) / FilmSlope) - _680;
  float _685 = (FilmShoulder / FilmSlope) - _683;
  float _689 = log2(lerp(_643, _640, 0.9599999785423279f)) * 0.3010300099849701f;
  float _690 = log2(lerp(_643, _641, 0.9599999785423279f)) * 0.3010300099849701f;
  float _691 = log2(lerp(_643, _642, 0.9599999785423279f)) * 0.3010300099849701f;
  float _695 = FilmSlope * (_689 + _683);
  float _696 = FilmSlope * (_690 + _683);
  float _697 = FilmSlope * (_691 + _683);
  float _698 = _658 * 2.0f;
  float _700 = (FilmSlope * -2.0f) / _658;
  float _701 = _689 - _680;
  float _702 = _690 - _680;
  float _703 = _691 - _680;
  float _722 = _662 * 2.0f;
  float _724 = (FilmSlope * 2.0f) / _662;
  float _749 = select((_689 < _680), ((_698 / (exp2((_701 * 1.4426950216293335f) * _700) + 1.0f)) - FilmBlackClip), _695);
  float _750 = select((_690 < _680), ((_698 / (exp2((_702 * 1.4426950216293335f) * _700) + 1.0f)) - FilmBlackClip), _696);
  float _751 = select((_691 < _680), ((_698 / (exp2((_703 * 1.4426950216293335f) * _700) + 1.0f)) - FilmBlackClip), _697);
  float _758 = _685 - _680;
  float _762 = saturate(_701 / _758);
  float _763 = saturate(_702 / _758);
  float _764 = saturate(_703 / _758);
  bool _765 = (_685 < _680);
  float _769 = select(_765, (1.0f - _762), _762);
  float _770 = select(_765, (1.0f - _763), _763);
  float _771 = select(_765, (1.0f - _764), _764);
  float _790 = (((_769 * _769) * (select((_689 > _685), (_660 - (_722 / (exp2(((_689 - _685) * 1.4426950216293335f) * _724) + 1.0f))), _695) - _749)) * (3.0f - (_769 * 2.0f))) + _749;
  float _791 = (((_770 * _770) * (select((_690 > _685), (_660 - (_722 / (exp2(((_690 - _685) * 1.4426950216293335f) * _724) + 1.0f))), _696) - _750)) * (3.0f - (_770 * 2.0f))) + _750;
  float _792 = (((_771 * _771) * (select((_691 > _685), (_660 - (_722 / (exp2(((_691 - _685) * 1.4426950216293335f) * _724) + 1.0f))), _697) - _751)) * (3.0f - (_771 * 2.0f))) + _751;
  float _793 = dot(float3(_790, _791, _792), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _813 = (ToneCurveAmount * (max(0.0f, (lerp(_793, _790, 0.9300000071525574f))) - _509)) + _509;
  float _814 = (ToneCurveAmount * (max(0.0f, (lerp(_793, _791, 0.9300000071525574f))) - _510)) + _510;
  float _815 = (ToneCurveAmount * (max(0.0f, (lerp(_793, _792, 0.9300000071525574f))) - _511)) + _511;
  float _831 = ((mad(-0.06537103652954102f, _815, mad(1.451815478503704e-06f, _814, (_813 * 1.065374732017517f))) - _813) * BlueCorrection) + _813;
  float _832 = ((mad(-0.20366770029067993f, _815, mad(1.2036634683609009f, _814, (_813 * -2.57161445915699e-07f))) - _814) * BlueCorrection) + _814;
  float _833 = ((mad(0.9999996423721313f, _815, mad(2.0954757928848267e-08f, _814, (_813 * 1.862645149230957e-08f))) - _815) * BlueCorrection) + _815;

  SetTonemappedAP1(_831, _832, _833);

  float _858 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _833, mad((WorkingColorSpace_FromAP1[0].y), _832, ((WorkingColorSpace_FromAP1[0].x) * _831)))));
  float _859 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _833, mad((WorkingColorSpace_FromAP1[1].y), _832, ((WorkingColorSpace_FromAP1[1].x) * _831)))));
  float _860 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _833, mad((WorkingColorSpace_FromAP1[2].y), _832, ((WorkingColorSpace_FromAP1[2].x) * _831)))));
  if (_858 < 0.0031306699384003878f) {
    _871 = (_858 * 12.920000076293945f);
  } else {
    _871 = (((pow(_858, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_859 < 0.0031306699384003878f) {
    _882 = (_859 * 12.920000076293945f);
  } else {
    _882 = (((pow(_859, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_860 < 0.0031306699384003878f) {
    _893 = (_860 * 12.920000076293945f);
  } else {
    _893 = (((pow(_860, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _897 = (_882 * 0.9375f) + 0.03125f;
  float _904 = _893 * 15.0f;
  float _905 = floor(_904);
  float _906 = _904 - _905;
  float _908 = (((_871 * 0.9375f) + 0.03125f) + _905) * 0.0625f;
  float4 _911 = Textures_1.Sample(Samplers_1, float2(_908, _897));
  float4 _918 = Textures_1.Sample(Samplers_1, float2((_908 + 0.0625f), _897));
  float _937 = max(6.103519990574569e-05f, (((lerp(_911.x, _918.x, _906)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _871)));
  float _938 = max(6.103519990574569e-05f, (((lerp(_911.y, _918.y, _906)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _882)));
  float _939 = max(6.103519990574569e-05f, (((lerp(_911.z, _918.z, _906)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _893)));
  float _961 = select((_937 > 0.040449999272823334f), exp2(log2((_937 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_937 * 0.07739938050508499f));
  float _962 = select((_938 > 0.040449999272823334f), exp2(log2((_938 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_938 * 0.07739938050508499f));
  float _963 = select((_939 > 0.040449999272823334f), exp2(log2((_939 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_939 * 0.07739938050508499f));
  float _989 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _961)) * _961) + MappingPolynomial.z);
  float _990 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _962)) * _962) + MappingPolynomial.z);
  float _991 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _963)) * _963) + MappingPolynomial.z);
  float _1012 = exp2(log2(max(0.0f, (lerp(_989, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1013 = exp2(log2(max(0.0f, (lerp(_990, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1014 = exp2(log2(max(0.0f, (lerp(_991, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1012, _1013, _1014), OutputDevice);
  }

  if (WorkingColorSpace_bIsSRGB == 0) {
    float _1033 = mad((WorkingColorSpace_ToAP1[0].z), _1014, mad((WorkingColorSpace_ToAP1[0].y), _1013, ((WorkingColorSpace_ToAP1[0].x) * _1012)));
    float _1036 = mad((WorkingColorSpace_ToAP1[1].z), _1014, mad((WorkingColorSpace_ToAP1[1].y), _1013, ((WorkingColorSpace_ToAP1[1].x) * _1012)));
    float _1039 = mad((WorkingColorSpace_ToAP1[2].z), _1014, mad((WorkingColorSpace_ToAP1[2].y), _1013, ((WorkingColorSpace_ToAP1[2].x) * _1012)));
    _1050 = mad(_43, _1039, mad(_42, _1036, (_1033 * _41)));
    _1051 = mad(_46, _1039, mad(_45, _1036, (_1033 * _44)));
    _1052 = mad(_49, _1039, mad(_48, _1036, (_1033 * _47)));
  } else {
    _1050 = _1012;
    _1051 = _1013;
    _1052 = _1014;
  }
  if (_1050 < 0.0031306699384003878f) {
    _1063 = (_1050 * 12.920000076293945f);
  } else {
    _1063 = (((pow(_1050, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1051 < 0.0031306699384003878f) {
    _1074 = (_1051 * 12.920000076293945f);
  } else {
    _1074 = (((pow(_1051, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1052 < 0.0031306699384003878f) {
    _1085 = (_1052 * 12.920000076293945f);
  } else {
    _1085 = (((pow(_1052, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1063 * 0.9523810148239136f);
  SV_Target.y = (_1074 * 0.9523810148239136f);
  SV_Target.z = (_1085 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

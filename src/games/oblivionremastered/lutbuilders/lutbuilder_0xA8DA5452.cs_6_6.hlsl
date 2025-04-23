Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

Texture2D<float4> Textures_3 : register(t2);

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

SamplerState Samplers_2 : register(s1);

SamplerState Samplers_3 : register(s2);

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _30 = 0.5f / LUTSize;
  float _35 = LUTSize + -1.0f;
  float _36 = (LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _30)) / _35;
  float _37 = (LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _30)) / _35;
  float _39 = float((uint)SV_DispatchThreadID.z) / _35;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _125;
  float _126;
  float _127;
  float _650;
  float _683;
  float _697;
  float _761;
  float _940;
  float _951;
  float _962;
  float _1185;
  float _1186;
  float _1187;
  float _1198;
  float _1209;
  float _1389;
  float _1422;
  float _1436;
  float _1475;
  float _1585;
  float _1659;
  float _1733;
  float _1812;
  float _1813;
  float _1814;
  float _1963;
  float _1996;
  float _2010;
  float _2049;
  float _2159;
  float _2233;
  float _2307;
  float _2386;
  float _2387;
  float _2388;
  float _2565;
  float _2566;
  float _2567;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _48 = ((uint)(OutputGamut) == 4);
        _59 = select(_48, 1.0f, 1.705051064491272f);
        _60 = select(_48, 0.0f, -0.6217921376228333f);
        _61 = select(_48, 0.0f, -0.0832589864730835f);
        _62 = select(_48, 0.0f, -0.13025647401809692f);
        _63 = select(_48, 1.0f, 1.140804648399353f);
        _64 = select(_48, 0.0f, -0.010548308491706848f);
        _65 = select(_48, 0.0f, -0.024003351107239723f);
        _66 = select(_48, 0.0f, -0.1289689838886261f);
        _67 = select(_48, 1.0f, 1.1529725790023804f);
      } else {
        _59 = 0.6954522132873535f;
        _60 = 0.14067870378494263f;
        _61 = 0.16386906802654266f;
        _62 = 0.044794563204050064f;
        _63 = 0.8596711158752441f;
        _64 = 0.0955343171954155f;
        _65 = -0.005525882821530104f;
        _66 = 0.004025210160762072f;
        _67 = 1.0015007257461548f;
      }
    } else {
      _59 = 1.0258246660232544f;
      _60 = -0.020053181797266006f;
      _61 = -0.005771636962890625f;
      _62 = -0.002234415616840124f;
      _63 = 1.0045864582061768f;
      _64 = -0.002352118492126465f;
      _65 = -0.005013350863009691f;
      _66 = -0.025290070101618767f;
      _67 = 1.0303035974502563f;
    }
  } else {
    _59 = 1.3792141675949097f;
    _60 = -0.30886411666870117f;
    _61 = -0.0703500509262085f;
    _62 = -0.06933490186929703f;
    _63 = 1.08229660987854f;
    _64 = -0.012961871922016144f;
    _65 = -0.0021590073592960835f;
    _66 = -0.0454593189060688f;
    _67 = 1.0476183891296387f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _78 = (pow(_36, 0.012683313339948654f));
    float _79 = (pow(_37, 0.012683313339948654f));
    float _80 = (pow(_39, 0.012683313339948654f));
    _125 = (exp2(log2(max(0.0f, (_78 + -0.8359375f)) / (18.8515625f - (_78 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _126 = (exp2(log2(max(0.0f, (_79 + -0.8359375f)) / (18.8515625f - (_79 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _127 = (exp2(log2(max(0.0f, (_80 + -0.8359375f)) / (18.8515625f - (_80 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _125 = ((exp2((_36 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _126 = ((exp2((_37 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _127 = ((exp2((_39 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _142 = mad((WorkingColorSpace_ToAP1[0].z), _127, mad((WorkingColorSpace_ToAP1[0].y), _126, ((WorkingColorSpace_ToAP1[0].x) * _125)));
  float _145 = mad((WorkingColorSpace_ToAP1[1].z), _127, mad((WorkingColorSpace_ToAP1[1].y), _126, ((WorkingColorSpace_ToAP1[1].x) * _125)));
  float _148 = mad((WorkingColorSpace_ToAP1[2].z), _127, mad((WorkingColorSpace_ToAP1[2].y), _126, ((WorkingColorSpace_ToAP1[2].x) * _125)));
  float _149 = dot(float3(_142, _145, _148), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _153 = (_142 / _149) + -1.0f;
  float _154 = (_145 / _149) + -1.0f;
  float _155 = (_148 / _149) + -1.0f;
  float _167 = (1.0f - exp2(((_149 * _149) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_153, _154, _155), float3(_153, _154, _155)) * -4.0f));
  float _183 = ((mad(-0.06368321925401688f, _148, mad(-0.3292922377586365f, _145, (_142 * 1.3704125881195068f))) - _142) * _167) + _142;
  float _184 = ((mad(-0.010861365124583244f, _148, mad(1.0970927476882935f, _145, (_142 * -0.08343357592821121f))) - _145) * _167) + _145;
  float _185 = ((mad(1.2036951780319214f, _148, mad(-0.09862580895423889f, _145, (_142 * -0.02579331398010254f))) - _148) * _167) + _148;
  float _186 = dot(float3(_183, _184, _185), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _200 = ColorOffset.w + ColorOffsetShadows.w;
  float _214 = ColorGain.w * ColorGainShadows.w;
  float _228 = ColorGamma.w * ColorGammaShadows.w;
  float _242 = ColorContrast.w * ColorContrastShadows.w;
  float _256 = ColorSaturation.w * ColorSaturationShadows.w;
  float _260 = _183 - _186;
  float _261 = _184 - _186;
  float _262 = _185 - _186;
  float _319 = saturate(_186 / ColorCorrectionShadowsMax);
  float _323 = (_319 * _319) * (3.0f - (_319 * 2.0f));
  float _324 = 1.0f - _323;
  float _333 = ColorOffset.w + ColorOffsetHighlights.w;
  float _342 = ColorGain.w * ColorGainHighlights.w;
  float _351 = ColorGamma.w * ColorGammaHighlights.w;
  float _360 = ColorContrast.w * ColorContrastHighlights.w;
  float _369 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _432 = saturate((_186 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _436 = (_432 * _432) * (3.0f - (_432 * 2.0f));
  float _445 = ColorOffset.w + ColorOffsetMidtones.w;
  float _454 = ColorGain.w * ColorGainMidtones.w;
  float _463 = ColorGamma.w * ColorGammaMidtones.w;
  float _472 = ColorContrast.w * ColorContrastMidtones.w;
  float _481 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _539 = _323 - _436;
  float _550 = ((_436 * (((ColorOffset.x + ColorOffsetHighlights.x) + _333) + (((ColorGain.x * ColorGainHighlights.x) * _342) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _360) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _369) * _260) + _186)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _351)))))) + (_324 * (((ColorOffset.x + ColorOffsetShadows.x) + _200) + (((ColorGain.x * ColorGainShadows.x) * _214) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _242) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _256) * _260) + _186)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _228))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _445) + (((ColorGain.x * ColorGainMidtones.x) * _454) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _472) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _481) * _260) + _186)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _463))))) * _539);
  float _552 = ((_436 * (((ColorOffset.y + ColorOffsetHighlights.y) + _333) + (((ColorGain.y * ColorGainHighlights.y) * _342) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _360) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _369) * _261) + _186)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _351)))))) + (_324 * (((ColorOffset.y + ColorOffsetShadows.y) + _200) + (((ColorGain.y * ColorGainShadows.y) * _214) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _242) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _256) * _261) + _186)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _228))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _445) + (((ColorGain.y * ColorGainMidtones.y) * _454) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _472) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _481) * _261) + _186)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _463))))) * _539);
  float _554 = ((_436 * (((ColorOffset.z + ColorOffsetHighlights.z) + _333) + (((ColorGain.z * ColorGainHighlights.z) * _342) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _360) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _369) * _262) + _186)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _351)))))) + (_324 * (((ColorOffset.z + ColorOffsetShadows.z) + _200) + (((ColorGain.z * ColorGainShadows.z) * _214) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _242) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _256) * _262) + _186)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _228))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _445) + (((ColorGain.z * ColorGainMidtones.z) * _454) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _472) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _481) * _262) + _186)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _463))))) * _539);
  float _590 = ((mad(0.061360642313957214f, _554, mad(-4.540197551250458e-09f, _552, (_550 * 0.9386394023895264f))) - _550) * BlueCorrection) + _550;
  float _591 = ((mad(0.169205904006958f, _554, mad(0.8307942152023315f, _552, (_550 * 6.775371730327606e-08f))) - _552) * BlueCorrection) + _552;
  float _592 = (mad(-2.3283064365386963e-10f, _552, (_550 * -9.313225746154785e-10f)) * BlueCorrection) + _554;
  float _595 = mad(0.16386905312538147f, _592, mad(0.14067868888378143f, _591, (_590 * 0.6954522132873535f)));
  float _598 = mad(0.0955343246459961f, _592, mad(0.8596711158752441f, _591, (_590 * 0.044794581830501556f)));
  float _601 = mad(1.0015007257461548f, _592, mad(0.004025210160762072f, _591, (_590 * -0.005525882821530104f)));
  float _605 = max(max(_595, _598), _601);
  float _610 = (max(_605, 1.000000013351432e-10f) - max(min(min(_595, _598), _601), 1.000000013351432e-10f)) / max(_605, 0.009999999776482582f);
  float _623 = ((_598 + _595) + _601) + (sqrt((((_601 - _598) * _601) + ((_598 - _595) * _598)) + ((_595 - _601) * _595)) * 1.75f);
  float _624 = _623 * 0.3333333432674408f;
  float _625 = _610 + -0.4000000059604645f;
  float _626 = _625 * 5.0f;
  float _630 = max((1.0f - abs(_625 * 2.5f)), 0.0f);
  float _641 = ((float(((int)(uint)((bool)(_626 > 0.0f))) - ((int)(uint)((bool)(_626 < 0.0f)))) * (1.0f - (_630 * _630))) + 1.0f) * 0.02500000037252903f;
  if (!(_624 <= 0.0533333346247673f)) {
    if (!(_624 >= 0.1599999964237213f)) {
      _650 = (((0.23999999463558197f / _623) + -0.5f) * _641);
    } else {
      _650 = 0.0f;
    }
  } else {
    _650 = _641;
  }
  float _651 = _650 + 1.0f;
  float _652 = _651 * _595;
  float _653 = _651 * _598;
  float _654 = _651 * _601;
  if (!((bool)(_652 == _653) && (bool)(_653 == _654))) {
    float _661 = ((_652 * 2.0f) - _653) - _654;
    float _664 = ((_598 - _601) * 1.7320507764816284f) * _651;
    float _666 = atan(_664 / _661);
    bool _669 = (_661 < 0.0f);
    bool _670 = (_661 == 0.0f);
    bool _671 = (_664 >= 0.0f);
    bool _672 = (_664 < 0.0f);
    _683 = select((_671 && _670), 90.0f, select((_672 && _670), -90.0f, (select((_672 && _669), (_666 + -3.1415927410125732f), select((_671 && _669), (_666 + 3.1415927410125732f), _666)) * 57.2957763671875f)));
  } else {
    _683 = 0.0f;
  }
  float _688 = min(max(select((_683 < 0.0f), (_683 + 360.0f), _683), 0.0f), 360.0f);
  if (_688 < -180.0f) {
    _697 = (_688 + 360.0f);
  } else {
    if (_688 > 180.0f) {
      _697 = (_688 + -360.0f);
    } else {
      _697 = _688;
    }
  }
  float _701 = saturate(1.0f - abs(_697 * 0.014814814552664757f));
  float _705 = (_701 * _701) * (3.0f - (_701 * 2.0f));
  float _711 = ((_705 * _705) * ((_610 * 0.18000000715255737f) * (0.029999999329447746f - _652))) + _652;
  float _721 = max(0.0f, mad(-0.21492856740951538f, _654, mad(-0.2365107536315918f, _653, (_711 * 1.4514392614364624f))));
  float _722 = max(0.0f, mad(-0.09967592358589172f, _654, mad(1.17622971534729f, _653, (_711 * -0.07655377686023712f))));
  float _723 = max(0.0f, mad(0.9977163076400757f, _654, mad(-0.006032449658960104f, _653, (_711 * 0.008316148072481155f))));
  float _724 = dot(float3(_721, _722, _723), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _739 = (FilmBlackClip + 1.0f) - FilmToe;
  float _741 = FilmWhiteClip + 1.0f;
  float _743 = _741 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _761 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _752 = (FilmBlackClip + 0.18000000715255737f) / _739;
    _761 = (-0.7447274923324585f - ((log2(_752 / (2.0f - _752)) * 0.3465735912322998f) * (_739 / FilmSlope)));
  }
  float _764 = ((1.0f - FilmToe) / FilmSlope) - _761;
  float _766 = (FilmShoulder / FilmSlope) - _764;
  float _770 = log2(lerp(_724, _721, 0.9599999785423279f)) * 0.3010300099849701f;
  float _771 = log2(lerp(_724, _722, 0.9599999785423279f)) * 0.3010300099849701f;
  float _772 = log2(lerp(_724, _723, 0.9599999785423279f)) * 0.3010300099849701f;
  float _776 = FilmSlope * (_770 + _764);
  float _777 = FilmSlope * (_771 + _764);
  float _778 = FilmSlope * (_772 + _764);
  float _779 = _739 * 2.0f;
  float _781 = (FilmSlope * -2.0f) / _739;
  float _782 = _770 - _761;
  float _783 = _771 - _761;
  float _784 = _772 - _761;
  float _803 = _743 * 2.0f;
  float _805 = (FilmSlope * 2.0f) / _743;
  float _830 = select((_770 < _761), ((_779 / (exp2((_782 * 1.4426950216293335f) * _781) + 1.0f)) - FilmBlackClip), _776);
  float _831 = select((_771 < _761), ((_779 / (exp2((_783 * 1.4426950216293335f) * _781) + 1.0f)) - FilmBlackClip), _777);
  float _832 = select((_772 < _761), ((_779 / (exp2((_784 * 1.4426950216293335f) * _781) + 1.0f)) - FilmBlackClip), _778);
  float _839 = _766 - _761;
  float _843 = saturate(_782 / _839);
  float _844 = saturate(_783 / _839);
  float _845 = saturate(_784 / _839);
  bool _846 = (_766 < _761);
  float _850 = select(_846, (1.0f - _843), _843);
  float _851 = select(_846, (1.0f - _844), _844);
  float _852 = select(_846, (1.0f - _845), _845);
  float _871 = (((_850 * _850) * (select((_770 > _766), (_741 - (_803 / (exp2(((_770 - _766) * 1.4426950216293335f) * _805) + 1.0f))), _776) - _830)) * (3.0f - (_850 * 2.0f))) + _830;
  float _872 = (((_851 * _851) * (select((_771 > _766), (_741 - (_803 / (exp2(((_771 - _766) * 1.4426950216293335f) * _805) + 1.0f))), _777) - _831)) * (3.0f - (_851 * 2.0f))) + _831;
  float _873 = (((_852 * _852) * (select((_772 > _766), (_741 - (_803 / (exp2(((_772 - _766) * 1.4426950216293335f) * _805) + 1.0f))), _778) - _832)) * (3.0f - (_852 * 2.0f))) + _832;
  float _874 = dot(float3(_871, _872, _873), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _894 = (ToneCurveAmount * (max(0.0f, (lerp(_874, _871, 0.9300000071525574f))) - _590)) + _590;
  float _895 = (ToneCurveAmount * (max(0.0f, (lerp(_874, _872, 0.9300000071525574f))) - _591)) + _591;
  float _896 = (ToneCurveAmount * (max(0.0f, (lerp(_874, _873, 0.9300000071525574f))) - _592)) + _592;
  float _912 = ((mad(-0.06537103652954102f, _896, mad(1.451815478503704e-06f, _895, (_894 * 1.065374732017517f))) - _894) * BlueCorrection) + _894;
  float _913 = ((mad(-0.20366770029067993f, _896, mad(1.2036634683609009f, _895, (_894 * -2.57161445915699e-07f))) - _895) * BlueCorrection) + _895;
  float _914 = ((mad(0.9999996423721313f, _896, mad(2.0954757928848267e-08f, _895, (_894 * 1.862645149230957e-08f))) - _896) * BlueCorrection) + _896;
  float _927 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _914, mad((WorkingColorSpace_FromAP1[0].y), _913, ((WorkingColorSpace_FromAP1[0].x) * _912)))));
  float _928 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _914, mad((WorkingColorSpace_FromAP1[1].y), _913, ((WorkingColorSpace_FromAP1[1].x) * _912)))));
  float _929 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _914, mad((WorkingColorSpace_FromAP1[2].y), _913, ((WorkingColorSpace_FromAP1[2].x) * _912)))));
  if (_927 < 0.0031306699384003878f) {
    _940 = (_927 * 12.920000076293945f);
  } else {
    _940 = (((pow(_927, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_928 < 0.0031306699384003878f) {
    _951 = (_928 * 12.920000076293945f);
  } else {
    _951 = (((pow(_928, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_929 < 0.0031306699384003878f) {
    _962 = (_929 * 12.920000076293945f);
  } else {
    _962 = (((pow(_929, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _966 = (_951 * 0.9375f) + 0.03125f;
  float _973 = _962 * 15.0f;
  float _974 = floor(_973);
  float _975 = _973 - _974;
  float _977 = (_974 + ((_940 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _980 = Textures_1.SampleLevel(Samplers_1, float2(_977, _966), 0.0f);
  float _984 = _977 + 0.0625f;
  float4 _985 = Textures_1.SampleLevel(Samplers_1, float2(_984, _966), 0.0f);
  float4 _1007 = Textures_2.SampleLevel(Samplers_2, float2(_977, _966), 0.0f);
  float4 _1011 = Textures_2.SampleLevel(Samplers_2, float2(_984, _966), 0.0f);
  float4 _1033 = Textures_3.SampleLevel(Samplers_3, float2(_977, _966), 0.0f);
  float4 _1037 = Textures_3.SampleLevel(Samplers_3, float2(_984, _966), 0.0f);
  float _1056 = max(6.103519990574569e-05f, (((((lerp(_980.x, _985.x, _975)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _940)) + ((lerp(_1007.x, _1011.x, _975)) * (LUTWeights[0].z))) + ((lerp(_1033.x, _1037.x, _975)) * (LUTWeights[0].w))));
  float _1057 = max(6.103519990574569e-05f, (((((lerp(_980.y, _985.y, _975)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _951)) + ((lerp(_1007.y, _1011.y, _975)) * (LUTWeights[0].z))) + ((lerp(_1033.y, _1037.y, _975)) * (LUTWeights[0].w))));
  float _1058 = max(6.103519990574569e-05f, (((((lerp(_980.z, _985.z, _975)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _962)) + ((lerp(_1007.z, _1011.z, _975)) * (LUTWeights[0].z))) + ((lerp(_1033.z, _1037.z, _975)) * (LUTWeights[0].w))));
  float _1080 = select((_1056 > 0.040449999272823334f), exp2(log2((_1056 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1056 * 0.07739938050508499f));
  float _1081 = select((_1057 > 0.040449999272823334f), exp2(log2((_1057 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1057 * 0.07739938050508499f));
  float _1082 = select((_1058 > 0.040449999272823334f), exp2(log2((_1058 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1058 * 0.07739938050508499f));
  float _1108 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1080)) * _1080) + MappingPolynomial.z);
  float _1109 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1081)) * _1081) + MappingPolynomial.z);
  float _1110 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1082)) * _1082) + MappingPolynomial.z);
  float _1117 = ((OverlayColor.x - _1108) * OverlayColor.w) + _1108;
  float _1118 = ((OverlayColor.y - _1109) * OverlayColor.w) + _1109;
  float _1119 = ((OverlayColor.z - _1110) * OverlayColor.w) + _1110;
  float _1120 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _554, mad((WorkingColorSpace_FromAP1[0].y), _552, (_550 * (WorkingColorSpace_FromAP1[0].x))));
  float _1121 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _554, mad((WorkingColorSpace_FromAP1[1].y), _552, ((WorkingColorSpace_FromAP1[1].x) * _550)));
  float _1122 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _554, mad((WorkingColorSpace_FromAP1[2].y), _552, ((WorkingColorSpace_FromAP1[2].x) * _550)));
  float _1129 = ((OverlayColor.x - _1120) * OverlayColor.w) + _1120;
  float _1130 = ((OverlayColor.y - _1121) * OverlayColor.w) + _1121;
  float _1131 = ((OverlayColor.z - _1122) * OverlayColor.w) + _1122;
  float _1143 = exp2(log2(max(0.0f, _1117)) * InverseGamma.y);
  float _1144 = exp2(log2(max(0.0f, _1118)) * InverseGamma.y);
  float _1145 = exp2(log2(max(0.0f, _1119)) * InverseGamma.y);
  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1168 = mad((WorkingColorSpace_ToAP1[0].z), _1145, mad((WorkingColorSpace_ToAP1[0].y), _1144, ((WorkingColorSpace_ToAP1[0].x) * _1143)));
        float _1171 = mad((WorkingColorSpace_ToAP1[1].z), _1145, mad((WorkingColorSpace_ToAP1[1].y), _1144, ((WorkingColorSpace_ToAP1[1].x) * _1143)));
        float _1174 = mad((WorkingColorSpace_ToAP1[2].z), _1145, mad((WorkingColorSpace_ToAP1[2].y), _1144, ((WorkingColorSpace_ToAP1[2].x) * _1143)));
        _1185 = mad(_61, _1174, mad(_60, _1171, (_1168 * _59)));
        _1186 = mad(_64, _1174, mad(_63, _1171, (_1168 * _62)));
        _1187 = mad(_67, _1174, mad(_66, _1171, (_1168 * _65)));
      } else {
        _1185 = _1143;
        _1186 = _1144;
        _1187 = _1145;
      }
      do {
        if (_1185 < 0.0031306699384003878f) {
          _1198 = (_1185 * 12.920000076293945f);
        } else {
          _1198 = (((pow(_1185, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1186 < 0.0031306699384003878f) {
            _1209 = (_1186 * 12.920000076293945f);
          } else {
            _1209 = (((pow(_1186, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1187 < 0.0031306699384003878f) {
            _2565 = _1198;
            _2566 = _1209;
            _2567 = (_1187 * 12.920000076293945f);
          } else {
            _2565 = _1198;
            _2566 = _1209;
            _2567 = (((pow(_1187, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1236 = mad((WorkingColorSpace_ToAP1[0].z), _1145, mad((WorkingColorSpace_ToAP1[0].y), _1144, ((WorkingColorSpace_ToAP1[0].x) * _1143)));
      float _1239 = mad((WorkingColorSpace_ToAP1[1].z), _1145, mad((WorkingColorSpace_ToAP1[1].y), _1144, ((WorkingColorSpace_ToAP1[1].x) * _1143)));
      float _1242 = mad((WorkingColorSpace_ToAP1[2].z), _1145, mad((WorkingColorSpace_ToAP1[2].y), _1144, ((WorkingColorSpace_ToAP1[2].x) * _1143)));
      float _1252 = max(6.103519990574569e-05f, mad(_61, _1242, mad(_60, _1239, (_1236 * _59))));
      float _1253 = max(6.103519990574569e-05f, mad(_64, _1242, mad(_63, _1239, (_1236 * _62))));
      float _1254 = max(6.103519990574569e-05f, mad(_67, _1242, mad(_66, _1239, (_1236 * _65))));
      _2565 = min((_1252 * 4.5f), ((exp2(log2(max(_1252, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2566 = min((_1253 * 4.5f), ((exp2(log2(max(_1253, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2567 = min((_1254 * 4.5f), ((exp2(log2(max(_1254, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
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
        float _1329 = ACESSceneColorMultiplier * _1129;
        float _1330 = ACESSceneColorMultiplier * _1130;
        float _1331 = ACESSceneColorMultiplier * _1131;
        float _1334 = mad((WorkingColorSpace_ToAP0[0].z), _1331, mad((WorkingColorSpace_ToAP0[0].y), _1330, ((WorkingColorSpace_ToAP0[0].x) * _1329)));
        float _1337 = mad((WorkingColorSpace_ToAP0[1].z), _1331, mad((WorkingColorSpace_ToAP0[1].y), _1330, ((WorkingColorSpace_ToAP0[1].x) * _1329)));
        float _1340 = mad((WorkingColorSpace_ToAP0[2].z), _1331, mad((WorkingColorSpace_ToAP0[2].y), _1330, ((WorkingColorSpace_ToAP0[2].x) * _1329)));
        float _1344 = max(max(_1334, _1337), _1340);
        float _1349 = (max(_1344, 1.000000013351432e-10f) - max(min(min(_1334, _1337), _1340), 1.000000013351432e-10f)) / max(_1344, 0.009999999776482582f);
        float _1362 = ((_1337 + _1334) + _1340) + (sqrt((((_1340 - _1337) * _1340) + ((_1337 - _1334) * _1337)) + ((_1334 - _1340) * _1334)) * 1.75f);
        float _1363 = _1362 * 0.3333333432674408f;
        float _1364 = _1349 + -0.4000000059604645f;
        float _1365 = _1364 * 5.0f;
        float _1369 = max((1.0f - abs(_1364 * 2.5f)), 0.0f);
        float _1380 = ((float(((int)(uint)((bool)(_1365 > 0.0f))) - ((int)(uint)((bool)(_1365 < 0.0f)))) * (1.0f - (_1369 * _1369))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1363 <= 0.0533333346247673f)) {
            if (!(_1363 >= 0.1599999964237213f)) {
              _1389 = (((0.23999999463558197f / _1362) + -0.5f) * _1380);
            } else {
              _1389 = 0.0f;
            }
          } else {
            _1389 = _1380;
          }
          float _1390 = _1389 + 1.0f;
          float _1391 = _1390 * _1334;
          float _1392 = _1390 * _1337;
          float _1393 = _1390 * _1340;
          do {
            if (!((bool)(_1391 == _1392) && (bool)(_1392 == _1393))) {
              float _1400 = ((_1391 * 2.0f) - _1392) - _1393;
              float _1403 = ((_1337 - _1340) * 1.7320507764816284f) * _1390;
              float _1405 = atan(_1403 / _1400);
              bool _1408 = (_1400 < 0.0f);
              bool _1409 = (_1400 == 0.0f);
              bool _1410 = (_1403 >= 0.0f);
              bool _1411 = (_1403 < 0.0f);
              _1422 = select((_1410 && _1409), 90.0f, select((_1411 && _1409), -90.0f, (select((_1411 && _1408), (_1405 + -3.1415927410125732f), select((_1410 && _1408), (_1405 + 3.1415927410125732f), _1405)) * 57.2957763671875f)));
            } else {
              _1422 = 0.0f;
            }
            float _1427 = min(max(select((_1422 < 0.0f), (_1422 + 360.0f), _1422), 0.0f), 360.0f);
            do {
              if (_1427 < -180.0f) {
                _1436 = (_1427 + 360.0f);
              } else {
                if (_1427 > 180.0f) {
                  _1436 = (_1427 + -360.0f);
                } else {
                  _1436 = _1427;
                }
              }
              do {
                if ((bool)(_1436 > -67.5f) && (bool)(_1436 < 67.5f)) {
                  float _1442 = (_1436 + 67.5f) * 0.029629629105329514f;
                  int _1443 = int(_1442);
                  float _1445 = _1442 - float(_1443);
                  float _1446 = _1445 * _1445;
                  float _1447 = _1446 * _1445;
                  if (_1443 == 3) {
                    _1475 = (((0.1666666716337204f - (_1445 * 0.5f)) + (_1446 * 0.5f)) - (_1447 * 0.1666666716337204f));
                  } else {
                    if (_1443 == 2) {
                      _1475 = ((0.6666666865348816f - _1446) + (_1447 * 0.5f));
                    } else {
                      if (_1443 == 1) {
                        _1475 = (((_1447 * -0.5f) + 0.1666666716337204f) + ((_1446 + _1445) * 0.5f));
                      } else {
                        _1475 = select((_1443 == 0), (_1447 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1475 = 0.0f;
                }
                float _1484 = min(max(((((_1349 * 0.27000001072883606f) * (0.029999999329447746f - _1391)) * _1475) + _1391), 0.0f), 65535.0f);
                float _1485 = min(max(_1392, 0.0f), 65535.0f);
                float _1486 = min(max(_1393, 0.0f), 65535.0f);
                float _1499 = min(max(mad(-0.21492856740951538f, _1486, mad(-0.2365107536315918f, _1485, (_1484 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1500 = min(max(mad(-0.09967592358589172f, _1486, mad(1.17622971534729f, _1485, (_1484 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1501 = min(max(mad(0.9977163076400757f, _1486, mad(-0.006032449658960104f, _1485, (_1484 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1502 = dot(float3(_1499, _1500, _1501), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1513 = log2(max((lerp(_1502, _1499, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1514 = _1513 * 0.3010300099849701f;
                float _1515 = log2(ACESMinMaxData.x);
                float _1516 = _1515 * 0.3010300099849701f;
                do {
                  if (!(!(_1514 <= _1516))) {
                    _1585 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1523 = log2(ACESMidData.x);
                    float _1524 = _1523 * 0.3010300099849701f;
                    if ((bool)(_1514 > _1516) && (bool)(_1514 < _1524)) {
                      float _1532 = ((_1513 - _1515) * 0.9030900001525879f) / ((_1523 - _1515) * 0.3010300099849701f);
                      int _1533 = int(_1532);
                      float _1535 = _1532 - float(_1533);
                      float _1537 = _17[_1533];
                      float _1540 = _17[(_1533 + 1)];
                      float _1545 = _1537 * 0.5f;
                      _1585 = dot(float3((_1535 * _1535), _1535, 1.0f), float3(mad((_17[(_1533 + 2)]), 0.5f, mad(_1540, -1.0f, _1545)), (_1540 - _1537), mad(_1540, 0.5f, _1545)));
                    } else {
                      do {
                        if (!(!(_1514 >= _1524))) {
                          float _1554 = log2(ACESMinMaxData.z);
                          if (_1514 < (_1554 * 0.3010300099849701f)) {
                            float _1562 = ((_1513 - _1523) * 0.9030900001525879f) / ((_1554 - _1523) * 0.3010300099849701f);
                            int _1563 = int(_1562);
                            float _1565 = _1562 - float(_1563);
                            float _1567 = _18[_1563];
                            float _1570 = _18[(_1563 + 1)];
                            float _1575 = _1567 * 0.5f;
                            _1585 = dot(float3((_1565 * _1565), _1565, 1.0f), float3(mad((_18[(_1563 + 2)]), 0.5f, mad(_1570, -1.0f, _1575)), (_1570 - _1567), mad(_1570, 0.5f, _1575)));
                            break;
                          }
                        }
                        _1585 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1589 = log2(max((lerp(_1502, _1500, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1590 = _1589 * 0.3010300099849701f;
                  do {
                    if (!(!(_1590 <= _1516))) {
                      _1659 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1597 = log2(ACESMidData.x);
                      float _1598 = _1597 * 0.3010300099849701f;
                      if ((bool)(_1590 > _1516) && (bool)(_1590 < _1598)) {
                        float _1606 = ((_1589 - _1515) * 0.9030900001525879f) / ((_1597 - _1515) * 0.3010300099849701f);
                        int _1607 = int(_1606);
                        float _1609 = _1606 - float(_1607);
                        float _1611 = _17[_1607];
                        float _1614 = _17[(_1607 + 1)];
                        float _1619 = _1611 * 0.5f;
                        _1659 = dot(float3((_1609 * _1609), _1609, 1.0f), float3(mad((_17[(_1607 + 2)]), 0.5f, mad(_1614, -1.0f, _1619)), (_1614 - _1611), mad(_1614, 0.5f, _1619)));
                      } else {
                        do {
                          if (!(!(_1590 >= _1598))) {
                            float _1628 = log2(ACESMinMaxData.z);
                            if (_1590 < (_1628 * 0.3010300099849701f)) {
                              float _1636 = ((_1589 - _1597) * 0.9030900001525879f) / ((_1628 - _1597) * 0.3010300099849701f);
                              int _1637 = int(_1636);
                              float _1639 = _1636 - float(_1637);
                              float _1641 = _18[_1637];
                              float _1644 = _18[(_1637 + 1)];
                              float _1649 = _1641 * 0.5f;
                              _1659 = dot(float3((_1639 * _1639), _1639, 1.0f), float3(mad((_18[(_1637 + 2)]), 0.5f, mad(_1644, -1.0f, _1649)), (_1644 - _1641), mad(_1644, 0.5f, _1649)));
                              break;
                            }
                          }
                          _1659 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1663 = log2(max((lerp(_1502, _1501, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1664 = _1663 * 0.3010300099849701f;
                    do {
                      if (!(!(_1664 <= _1516))) {
                        _1733 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1671 = log2(ACESMidData.x);
                        float _1672 = _1671 * 0.3010300099849701f;
                        if ((bool)(_1664 > _1516) && (bool)(_1664 < _1672)) {
                          float _1680 = ((_1663 - _1515) * 0.9030900001525879f) / ((_1671 - _1515) * 0.3010300099849701f);
                          int _1681 = int(_1680);
                          float _1683 = _1680 - float(_1681);
                          float _1685 = _17[_1681];
                          float _1688 = _17[(_1681 + 1)];
                          float _1693 = _1685 * 0.5f;
                          _1733 = dot(float3((_1683 * _1683), _1683, 1.0f), float3(mad((_17[(_1681 + 2)]), 0.5f, mad(_1688, -1.0f, _1693)), (_1688 - _1685), mad(_1688, 0.5f, _1693)));
                        } else {
                          do {
                            if (!(!(_1664 >= _1672))) {
                              float _1702 = log2(ACESMinMaxData.z);
                              if (_1664 < (_1702 * 0.3010300099849701f)) {
                                float _1710 = ((_1663 - _1671) * 0.9030900001525879f) / ((_1702 - _1671) * 0.3010300099849701f);
                                int _1711 = int(_1710);
                                float _1713 = _1710 - float(_1711);
                                float _1715 = _18[_1711];
                                float _1718 = _18[(_1711 + 1)];
                                float _1723 = _1715 * 0.5f;
                                _1733 = dot(float3((_1713 * _1713), _1713, 1.0f), float3(mad((_18[(_1711 + 2)]), 0.5f, mad(_1718, -1.0f, _1723)), (_1718 - _1715), mad(_1718, 0.5f, _1723)));
                                break;
                              }
                            }
                            _1733 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1737 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1738 = (exp2(_1585 * 3.321928024291992f) - ACESMinMaxData.y) / _1737;
                      float _1740 = (exp2(_1659 * 3.321928024291992f) - ACESMinMaxData.y) / _1737;
                      float _1742 = (exp2(_1733 * 3.321928024291992f) - ACESMinMaxData.y) / _1737;
                      float _1745 = mad(0.15618768334388733f, _1742, mad(0.13400420546531677f, _1740, (_1738 * 0.6624541878700256f)));
                      float _1748 = mad(0.053689517080783844f, _1742, mad(0.6740817427635193f, _1740, (_1738 * 0.2722287178039551f)));
                      float _1751 = mad(1.0103391408920288f, _1742, mad(0.00406073359772563f, _1740, (_1738 * -0.005574649665504694f)));
                      float _1764 = min(max(mad(-0.23642469942569733f, _1751, mad(-0.32480329275131226f, _1748, (_1745 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1765 = min(max(mad(0.016756348311901093f, _1751, mad(1.6153316497802734f, _1748, (_1745 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1766 = min(max(mad(0.9883948564529419f, _1751, mad(-0.008284442126750946f, _1748, (_1745 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1769 = mad(0.15618768334388733f, _1766, mad(0.13400420546531677f, _1765, (_1764 * 0.6624541878700256f)));
                      float _1772 = mad(0.053689517080783844f, _1766, mad(0.6740817427635193f, _1765, (_1764 * 0.2722287178039551f)));
                      float _1775 = mad(1.0103391408920288f, _1766, mad(0.00406073359772563f, _1765, (_1764 * -0.005574649665504694f)));
                      float _1797 = min(max((min(max(mad(-0.23642469942569733f, _1775, mad(-0.32480329275131226f, _1772, (_1769 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1798 = min(max((min(max(mad(0.016756348311901093f, _1775, mad(1.6153316497802734f, _1772, (_1769 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1799 = min(max((min(max(mad(0.9883948564529419f, _1775, mad(-0.008284442126750946f, _1772, (_1769 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(OutputDevice) == 5)) {
                          _1812 = mad(_61, _1799, mad(_60, _1798, (_1797 * _59)));
                          _1813 = mad(_64, _1799, mad(_63, _1798, (_1797 * _62)));
                          _1814 = mad(_67, _1799, mad(_66, _1798, (_1797 * _65)));
                        } else {
                          _1812 = _1797;
                          _1813 = _1798;
                          _1814 = _1799;
                        }
                        float _1824 = exp2(log2(_1812 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1825 = exp2(log2(_1813 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1826 = exp2(log2(_1814 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2565 = exp2(log2((1.0f / ((_1824 * 18.6875f) + 1.0f)) * ((_1824 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2566 = exp2(log2((1.0f / ((_1825 * 18.6875f) + 1.0f)) * ((_1825 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2567 = exp2(log2((1.0f / ((_1826 * 18.6875f) + 1.0f)) * ((_1826 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1903 = ACESSceneColorMultiplier * _1129;
          float _1904 = ACESSceneColorMultiplier * _1130;
          float _1905 = ACESSceneColorMultiplier * _1131;
          float _1908 = mad((WorkingColorSpace_ToAP0[0].z), _1905, mad((WorkingColorSpace_ToAP0[0].y), _1904, ((WorkingColorSpace_ToAP0[0].x) * _1903)));
          float _1911 = mad((WorkingColorSpace_ToAP0[1].z), _1905, mad((WorkingColorSpace_ToAP0[1].y), _1904, ((WorkingColorSpace_ToAP0[1].x) * _1903)));
          float _1914 = mad((WorkingColorSpace_ToAP0[2].z), _1905, mad((WorkingColorSpace_ToAP0[2].y), _1904, ((WorkingColorSpace_ToAP0[2].x) * _1903)));
          float _1918 = max(max(_1908, _1911), _1914);
          float _1923 = (max(_1918, 1.000000013351432e-10f) - max(min(min(_1908, _1911), _1914), 1.000000013351432e-10f)) / max(_1918, 0.009999999776482582f);
          float _1936 = ((_1911 + _1908) + _1914) + (sqrt((((_1914 - _1911) * _1914) + ((_1911 - _1908) * _1911)) + ((_1908 - _1914) * _1908)) * 1.75f);
          float _1937 = _1936 * 0.3333333432674408f;
          float _1938 = _1923 + -0.4000000059604645f;
          float _1939 = _1938 * 5.0f;
          float _1943 = max((1.0f - abs(_1938 * 2.5f)), 0.0f);
          float _1954 = ((float(((int)(uint)((bool)(_1939 > 0.0f))) - ((int)(uint)((bool)(_1939 < 0.0f)))) * (1.0f - (_1943 * _1943))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1937 <= 0.0533333346247673f)) {
              if (!(_1937 >= 0.1599999964237213f)) {
                _1963 = (((0.23999999463558197f / _1936) + -0.5f) * _1954);
              } else {
                _1963 = 0.0f;
              }
            } else {
              _1963 = _1954;
            }
            float _1964 = _1963 + 1.0f;
            float _1965 = _1964 * _1908;
            float _1966 = _1964 * _1911;
            float _1967 = _1964 * _1914;
            do {
              if (!((bool)(_1965 == _1966) && (bool)(_1966 == _1967))) {
                float _1974 = ((_1965 * 2.0f) - _1966) - _1967;
                float _1977 = ((_1911 - _1914) * 1.7320507764816284f) * _1964;
                float _1979 = atan(_1977 / _1974);
                bool _1982 = (_1974 < 0.0f);
                bool _1983 = (_1974 == 0.0f);
                bool _1984 = (_1977 >= 0.0f);
                bool _1985 = (_1977 < 0.0f);
                _1996 = select((_1984 && _1983), 90.0f, select((_1985 && _1983), -90.0f, (select((_1985 && _1982), (_1979 + -3.1415927410125732f), select((_1984 && _1982), (_1979 + 3.1415927410125732f), _1979)) * 57.2957763671875f)));
              } else {
                _1996 = 0.0f;
              }
              float _2001 = min(max(select((_1996 < 0.0f), (_1996 + 360.0f), _1996), 0.0f), 360.0f);
              do {
                if (_2001 < -180.0f) {
                  _2010 = (_2001 + 360.0f);
                } else {
                  if (_2001 > 180.0f) {
                    _2010 = (_2001 + -360.0f);
                  } else {
                    _2010 = _2001;
                  }
                }
                do {
                  if ((bool)(_2010 > -67.5f) && (bool)(_2010 < 67.5f)) {
                    float _2016 = (_2010 + 67.5f) * 0.029629629105329514f;
                    int _2017 = int(_2016);
                    float _2019 = _2016 - float(_2017);
                    float _2020 = _2019 * _2019;
                    float _2021 = _2020 * _2019;
                    if (_2017 == 3) {
                      _2049 = (((0.1666666716337204f - (_2019 * 0.5f)) + (_2020 * 0.5f)) - (_2021 * 0.1666666716337204f));
                    } else {
                      if (_2017 == 2) {
                        _2049 = ((0.6666666865348816f - _2020) + (_2021 * 0.5f));
                      } else {
                        if (_2017 == 1) {
                          _2049 = (((_2021 * -0.5f) + 0.1666666716337204f) + ((_2020 + _2019) * 0.5f));
                        } else {
                          _2049 = select((_2017 == 0), (_2021 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2049 = 0.0f;
                  }
                  float _2058 = min(max(((((_1923 * 0.27000001072883606f) * (0.029999999329447746f - _1965)) * _2049) + _1965), 0.0f), 65535.0f);
                  float _2059 = min(max(_1966, 0.0f), 65535.0f);
                  float _2060 = min(max(_1967, 0.0f), 65535.0f);
                  float _2073 = min(max(mad(-0.21492856740951538f, _2060, mad(-0.2365107536315918f, _2059, (_2058 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2074 = min(max(mad(-0.09967592358589172f, _2060, mad(1.17622971534729f, _2059, (_2058 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2075 = min(max(mad(0.9977163076400757f, _2060, mad(-0.006032449658960104f, _2059, (_2058 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2076 = dot(float3(_2073, _2074, _2075), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2087 = log2(max((lerp(_2076, _2073, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2088 = _2087 * 0.3010300099849701f;
                  float _2089 = log2(ACESMinMaxData.x);
                  float _2090 = _2089 * 0.3010300099849701f;
                  do {
                    if (!(!(_2088 <= _2090))) {
                      _2159 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2097 = log2(ACESMidData.x);
                      float _2098 = _2097 * 0.3010300099849701f;
                      if ((bool)(_2088 > _2090) && (bool)(_2088 < _2098)) {
                        float _2106 = ((_2087 - _2089) * 0.9030900001525879f) / ((_2097 - _2089) * 0.3010300099849701f);
                        int _2107 = int(_2106);
                        float _2109 = _2106 - float(_2107);
                        float _2111 = _15[_2107];
                        float _2114 = _15[(_2107 + 1)];
                        float _2119 = _2111 * 0.5f;
                        _2159 = dot(float3((_2109 * _2109), _2109, 1.0f), float3(mad((_15[(_2107 + 2)]), 0.5f, mad(_2114, -1.0f, _2119)), (_2114 - _2111), mad(_2114, 0.5f, _2119)));
                      } else {
                        do {
                          if (!(!(_2088 >= _2098))) {
                            float _2128 = log2(ACESMinMaxData.z);
                            if (_2088 < (_2128 * 0.3010300099849701f)) {
                              float _2136 = ((_2087 - _2097) * 0.9030900001525879f) / ((_2128 - _2097) * 0.3010300099849701f);
                              int _2137 = int(_2136);
                              float _2139 = _2136 - float(_2137);
                              float _2141 = _16[_2137];
                              float _2144 = _16[(_2137 + 1)];
                              float _2149 = _2141 * 0.5f;
                              _2159 = dot(float3((_2139 * _2139), _2139, 1.0f), float3(mad((_16[(_2137 + 2)]), 0.5f, mad(_2144, -1.0f, _2149)), (_2144 - _2141), mad(_2144, 0.5f, _2149)));
                              break;
                            }
                          }
                          _2159 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2163 = log2(max((lerp(_2076, _2074, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2164 = _2163 * 0.3010300099849701f;
                    do {
                      if (!(!(_2164 <= _2090))) {
                        _2233 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2171 = log2(ACESMidData.x);
                        float _2172 = _2171 * 0.3010300099849701f;
                        if ((bool)(_2164 > _2090) && (bool)(_2164 < _2172)) {
                          float _2180 = ((_2163 - _2089) * 0.9030900001525879f) / ((_2171 - _2089) * 0.3010300099849701f);
                          int _2181 = int(_2180);
                          float _2183 = _2180 - float(_2181);
                          float _2185 = _15[_2181];
                          float _2188 = _15[(_2181 + 1)];
                          float _2193 = _2185 * 0.5f;
                          _2233 = dot(float3((_2183 * _2183), _2183, 1.0f), float3(mad((_15[(_2181 + 2)]), 0.5f, mad(_2188, -1.0f, _2193)), (_2188 - _2185), mad(_2188, 0.5f, _2193)));
                        } else {
                          do {
                            if (!(!(_2164 >= _2172))) {
                              float _2202 = log2(ACESMinMaxData.z);
                              if (_2164 < (_2202 * 0.3010300099849701f)) {
                                float _2210 = ((_2163 - _2171) * 0.9030900001525879f) / ((_2202 - _2171) * 0.3010300099849701f);
                                int _2211 = int(_2210);
                                float _2213 = _2210 - float(_2211);
                                float _2215 = _16[_2211];
                                float _2218 = _16[(_2211 + 1)];
                                float _2223 = _2215 * 0.5f;
                                _2233 = dot(float3((_2213 * _2213), _2213, 1.0f), float3(mad((_16[(_2211 + 2)]), 0.5f, mad(_2218, -1.0f, _2223)), (_2218 - _2215), mad(_2218, 0.5f, _2223)));
                                break;
                              }
                            }
                            _2233 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2237 = log2(max((lerp(_2076, _2075, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2238 = _2237 * 0.3010300099849701f;
                      do {
                        if (!(!(_2238 <= _2090))) {
                          _2307 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2245 = log2(ACESMidData.x);
                          float _2246 = _2245 * 0.3010300099849701f;
                          if ((bool)(_2238 > _2090) && (bool)(_2238 < _2246)) {
                            float _2254 = ((_2237 - _2089) * 0.9030900001525879f) / ((_2245 - _2089) * 0.3010300099849701f);
                            int _2255 = int(_2254);
                            float _2257 = _2254 - float(_2255);
                            float _2259 = _15[_2255];
                            float _2262 = _15[(_2255 + 1)];
                            float _2267 = _2259 * 0.5f;
                            _2307 = dot(float3((_2257 * _2257), _2257, 1.0f), float3(mad((_15[(_2255 + 2)]), 0.5f, mad(_2262, -1.0f, _2267)), (_2262 - _2259), mad(_2262, 0.5f, _2267)));
                          } else {
                            do {
                              if (!(!(_2238 >= _2246))) {
                                float _2276 = log2(ACESMinMaxData.z);
                                if (_2238 < (_2276 * 0.3010300099849701f)) {
                                  float _2284 = ((_2237 - _2245) * 0.9030900001525879f) / ((_2276 - _2245) * 0.3010300099849701f);
                                  int _2285 = int(_2284);
                                  float _2287 = _2284 - float(_2285);
                                  float _2289 = _16[_2285];
                                  float _2292 = _16[(_2285 + 1)];
                                  float _2297 = _2289 * 0.5f;
                                  _2307 = dot(float3((_2287 * _2287), _2287, 1.0f), float3(mad((_16[(_2285 + 2)]), 0.5f, mad(_2292, -1.0f, _2297)), (_2292 - _2289), mad(_2292, 0.5f, _2297)));
                                  break;
                                }
                              }
                              _2307 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2311 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2312 = (exp2(_2159 * 3.321928024291992f) - ACESMinMaxData.y) / _2311;
                        float _2314 = (exp2(_2233 * 3.321928024291992f) - ACESMinMaxData.y) / _2311;
                        float _2316 = (exp2(_2307 * 3.321928024291992f) - ACESMinMaxData.y) / _2311;
                        float _2319 = mad(0.15618768334388733f, _2316, mad(0.13400420546531677f, _2314, (_2312 * 0.6624541878700256f)));
                        float _2322 = mad(0.053689517080783844f, _2316, mad(0.6740817427635193f, _2314, (_2312 * 0.2722287178039551f)));
                        float _2325 = mad(1.0103391408920288f, _2316, mad(0.00406073359772563f, _2314, (_2312 * -0.005574649665504694f)));
                        float _2338 = min(max(mad(-0.23642469942569733f, _2325, mad(-0.32480329275131226f, _2322, (_2319 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2339 = min(max(mad(0.016756348311901093f, _2325, mad(1.6153316497802734f, _2322, (_2319 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2340 = min(max(mad(0.9883948564529419f, _2325, mad(-0.008284442126750946f, _2322, (_2319 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2343 = mad(0.15618768334388733f, _2340, mad(0.13400420546531677f, _2339, (_2338 * 0.6624541878700256f)));
                        float _2346 = mad(0.053689517080783844f, _2340, mad(0.6740817427635193f, _2339, (_2338 * 0.2722287178039551f)));
                        float _2349 = mad(1.0103391408920288f, _2340, mad(0.00406073359772563f, _2339, (_2338 * -0.005574649665504694f)));
                        float _2371 = min(max((min(max(mad(-0.23642469942569733f, _2349, mad(-0.32480329275131226f, _2346, (_2343 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2372 = min(max((min(max(mad(0.016756348311901093f, _2349, mad(1.6153316497802734f, _2346, (_2343 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2373 = min(max((min(max(mad(0.9883948564529419f, _2349, mad(-0.008284442126750946f, _2346, (_2343 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 6)) {
                            _2386 = mad(_61, _2373, mad(_60, _2372, (_2371 * _59)));
                            _2387 = mad(_64, _2373, mad(_63, _2372, (_2371 * _62)));
                            _2388 = mad(_67, _2373, mad(_66, _2372, (_2371 * _65)));
                          } else {
                            _2386 = _2371;
                            _2387 = _2372;
                            _2388 = _2373;
                          }
                          float _2398 = exp2(log2(_2386 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2399 = exp2(log2(_2387 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2400 = exp2(log2(_2388 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2565 = exp2(log2((1.0f / ((_2398 * 18.6875f) + 1.0f)) * ((_2398 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2566 = exp2(log2((1.0f / ((_2399 * 18.6875f) + 1.0f)) * ((_2399 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2567 = exp2(log2((1.0f / ((_2400 * 18.6875f) + 1.0f)) * ((_2400 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2445 = mad((WorkingColorSpace_ToAP1[0].z), _1131, mad((WorkingColorSpace_ToAP1[0].y), _1130, ((WorkingColorSpace_ToAP1[0].x) * _1129)));
            float _2448 = mad((WorkingColorSpace_ToAP1[1].z), _1131, mad((WorkingColorSpace_ToAP1[1].y), _1130, ((WorkingColorSpace_ToAP1[1].x) * _1129)));
            float _2451 = mad((WorkingColorSpace_ToAP1[2].z), _1131, mad((WorkingColorSpace_ToAP1[2].y), _1130, ((WorkingColorSpace_ToAP1[2].x) * _1129)));
            float _2470 = exp2(log2(mad(_61, _2451, mad(_60, _2448, (_2445 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2471 = exp2(log2(mad(_64, _2451, mad(_63, _2448, (_2445 * _62))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2472 = exp2(log2(mad(_67, _2451, mad(_66, _2448, (_2445 * _65))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2565 = exp2(log2((1.0f / ((_2470 * 18.6875f) + 1.0f)) * ((_2470 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2566 = exp2(log2((1.0f / ((_2471 * 18.6875f) + 1.0f)) * ((_2471 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2567 = exp2(log2((1.0f / ((_2472 * 18.6875f) + 1.0f)) * ((_2472 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2519 = mad((WorkingColorSpace_ToAP1[0].z), _1119, mad((WorkingColorSpace_ToAP1[0].y), _1118, ((WorkingColorSpace_ToAP1[0].x) * _1117)));
                float _2522 = mad((WorkingColorSpace_ToAP1[1].z), _1119, mad((WorkingColorSpace_ToAP1[1].y), _1118, ((WorkingColorSpace_ToAP1[1].x) * _1117)));
                float _2525 = mad((WorkingColorSpace_ToAP1[2].z), _1119, mad((WorkingColorSpace_ToAP1[2].y), _1118, ((WorkingColorSpace_ToAP1[2].x) * _1117)));
                _2565 = mad(_61, _2525, mad(_60, _2522, (_2519 * _59)));
                _2566 = mad(_64, _2525, mad(_63, _2522, (_2519 * _62)));
                _2567 = mad(_67, _2525, mad(_66, _2522, (_2519 * _65)));
              } else {
                float _2538 = mad((WorkingColorSpace_ToAP1[0].z), _1145, mad((WorkingColorSpace_ToAP1[0].y), _1144, ((WorkingColorSpace_ToAP1[0].x) * _1143)));
                float _2541 = mad((WorkingColorSpace_ToAP1[1].z), _1145, mad((WorkingColorSpace_ToAP1[1].y), _1144, ((WorkingColorSpace_ToAP1[1].x) * _1143)));
                float _2544 = mad((WorkingColorSpace_ToAP1[2].z), _1145, mad((WorkingColorSpace_ToAP1[2].y), _1144, ((WorkingColorSpace_ToAP1[2].x) * _1143)));
                _2565 = exp2(log2(mad(_61, _2544, mad(_60, _2541, (_2538 * _59)))) * InverseGamma.z);
                _2566 = exp2(log2(mad(_64, _2544, mad(_63, _2541, (_2538 * _62)))) * InverseGamma.z);
                _2567 = exp2(log2(mad(_67, _2544, mad(_66, _2541, (_2538 * _65)))) * InverseGamma.z);
              }
            } else {
              _2565 = _1129;
              _2566 = _1130;
              _2567 = _1131;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2565 * 0.9523810148239136f), (_2566 * 0.9523810148239136f), (_2567 * 0.9523810148239136f), 0.0f);
}

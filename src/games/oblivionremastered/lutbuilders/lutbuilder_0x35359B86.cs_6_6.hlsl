#include "../common.hlsl"

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

Texture2D<float4> Textures_3 : register(t2);

Texture2D<float4> Textures_4 : register(t3);

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

SamplerState Samplers_4 : register(s3);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _32 = 0.5f / LUTSize;
  float _37 = LUTSize + -1.0f;
  float _38 = (LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _32)) / _37;
  float _39 = (LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _32)) / _37;
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
  float _942;
  float _953;
  float _964;
  float _1214;
  float _1215;
  float _1216;
  float _1227;
  float _1238;
  float _1418;
  float _1451;
  float _1465;
  float _1504;
  float _1614;
  float _1688;
  float _1762;
  float _1841;
  float _1842;
  float _1843;
  float _1992;
  float _2025;
  float _2039;
  float _2078;
  float _2188;
  float _2262;
  float _2336;
  float _2415;
  float _2416;
  float _2417;
  float _2594;
  float _2595;
  float _2596;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _50 = ((uint)(OutputGamut) == 4);
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
  if ((uint)(uint)(OutputDevice) > (uint)2) {
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
  float _144 = mad((WorkingColorSpace_ToAP1[0].z), _129, mad((WorkingColorSpace_ToAP1[0].y), _128, ((WorkingColorSpace_ToAP1[0].x) * _127)));
  float _147 = mad((WorkingColorSpace_ToAP1[1].z), _129, mad((WorkingColorSpace_ToAP1[1].y), _128, ((WorkingColorSpace_ToAP1[1].x) * _127)));
  float _150 = mad((WorkingColorSpace_ToAP1[2].z), _129, mad((WorkingColorSpace_ToAP1[2].y), _128, ((WorkingColorSpace_ToAP1[2].x) * _127)));
  float _151 = dot(float3(_144, _147, _150), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _155 = (_144 / _151) + -1.0f;
  float _156 = (_147 / _151) + -1.0f;
  float _157 = (_150 / _151) + -1.0f;
  float _169 = (1.0f - exp2(((_151 * _151) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_155, _156, _157), float3(_155, _156, _157)) * -4.0f));
  float _185 = ((mad(-0.06368321925401688f, _150, mad(-0.3292922377586365f, _147, (_144 * 1.3704125881195068f))) - _144) * _169) + _144;
  float _186 = ((mad(-0.010861365124583244f, _150, mad(1.0970927476882935f, _147, (_144 * -0.08343357592821121f))) - _147) * _169) + _147;
  float _187 = ((mad(1.2036951780319214f, _150, mad(-0.09862580895423889f, _147, (_144 * -0.02579331398010254f))) - _150) * _169) + _150;
  float _188 = dot(float3(_185, _186, _187), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUntonemappedAP1(float3(_185, _186, _187));

  float _202 = ColorOffset.w + ColorOffsetShadows.w;
  float _216 = ColorGain.w * ColorGainShadows.w;
  float _230 = ColorGamma.w * ColorGammaShadows.w;
  float _244 = ColorContrast.w * ColorContrastShadows.w;
  float _258 = ColorSaturation.w * ColorSaturationShadows.w;
  float _262 = _185 - _188;
  float _263 = _186 - _188;
  float _264 = _187 - _188;
  float _321 = saturate(_188 / ColorCorrectionShadowsMax);
  float _325 = (_321 * _321) * (3.0f - (_321 * 2.0f));
  float _326 = 1.0f - _325;
  float _335 = ColorOffset.w + ColorOffsetHighlights.w;
  float _344 = ColorGain.w * ColorGainHighlights.w;
  float _353 = ColorGamma.w * ColorGammaHighlights.w;
  float _362 = ColorContrast.w * ColorContrastHighlights.w;
  float _371 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _434 = saturate((_188 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _438 = (_434 * _434) * (3.0f - (_434 * 2.0f));
  float _447 = ColorOffset.w + ColorOffsetMidtones.w;
  float _456 = ColorGain.w * ColorGainMidtones.w;
  float _465 = ColorGamma.w * ColorGammaMidtones.w;
  float _474 = ColorContrast.w * ColorContrastMidtones.w;
  float _483 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _541 = _325 - _438;
  float _552 = ((_438 * (((ColorOffset.x + ColorOffsetHighlights.x) + _335) + (((ColorGain.x * ColorGainHighlights.x) * _344) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _362) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _371) * _262) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _353)))))) + (_326 * (((ColorOffset.x + ColorOffsetShadows.x) + _202) + (((ColorGain.x * ColorGainShadows.x) * _216) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _244) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _258) * _262) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _230))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _447) + (((ColorGain.x * ColorGainMidtones.x) * _456) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _474) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _483) * _262) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _465))))) * _541);
  float _554 = ((_438 * (((ColorOffset.y + ColorOffsetHighlights.y) + _335) + (((ColorGain.y * ColorGainHighlights.y) * _344) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _362) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _371) * _263) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _353)))))) + (_326 * (((ColorOffset.y + ColorOffsetShadows.y) + _202) + (((ColorGain.y * ColorGainShadows.y) * _216) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _244) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _258) * _263) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _230))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _447) + (((ColorGain.y * ColorGainMidtones.y) * _456) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _474) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _483) * _263) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _465))))) * _541);
  float _556 = ((_438 * (((ColorOffset.z + ColorOffsetHighlights.z) + _335) + (((ColorGain.z * ColorGainHighlights.z) * _344) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _362) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _371) * _264) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _353)))))) + (_326 * (((ColorOffset.z + ColorOffsetShadows.z) + _202) + (((ColorGain.z * ColorGainShadows.z) * _216) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _244) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _258) * _264) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _230))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _447) + (((ColorGain.z * ColorGainMidtones.z) * _456) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _474) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _483) * _264) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _465))))) * _541);
  float _592 = ((mad(0.061360642313957214f, _556, mad(-4.540197551250458e-09f, _554, (_552 * 0.9386394023895264f))) - _552) * BlueCorrection) + _552;
  float _593 = ((mad(0.169205904006958f, _556, mad(0.8307942152023315f, _554, (_552 * 6.775371730327606e-08f))) - _554) * BlueCorrection) + _554;
  float _594 = (mad(-2.3283064365386963e-10f, _554, (_552 * -9.313225746154785e-10f)) * BlueCorrection) + _556;
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
  float _643 = ((float(((int)(uint)((bool)(_628 > 0.0f))) - ((int)(uint)((bool)(_628 < 0.0f)))) * (1.0f - (_632 * _632))) + 1.0f) * 0.02500000037252903f;
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
  float _914 = ((mad(-0.06537103652954102f, _898, mad(1.451815478503704e-06f, _897, (_896 * 1.065374732017517f))) - _896) * BlueCorrection) + _896;
  float _915 = ((mad(-0.20366770029067993f, _898, mad(1.2036634683609009f, _897, (_896 * -2.57161445915699e-07f))) - _897) * BlueCorrection) + _897;
  float _916 = ((mad(0.9999996423721313f, _898, mad(2.0954757928848267e-08f, _897, (_896 * 1.862645149230957e-08f))) - _898) * BlueCorrection) + _898;
  float _929 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _916, mad((WorkingColorSpace_FromAP1[0].y), _915, ((WorkingColorSpace_FromAP1[0].x) * _914)))));
  float _930 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _916, mad((WorkingColorSpace_FromAP1[1].y), _915, ((WorkingColorSpace_FromAP1[1].x) * _914)))));
  float _931 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _916, mad((WorkingColorSpace_FromAP1[2].y), _915, ((WorkingColorSpace_FromAP1[2].x) * _914)))));

  SetTonemappedAP1(_929, _930, _931);

  if (_929 < 0.0031306699384003878f) {
    _942 = (_929 * 12.920000076293945f);
  } else {
    _942 = (((pow(_929, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_930 < 0.0031306699384003878f) {
    _953 = (_930 * 12.920000076293945f);
  } else {
    _953 = (((pow(_930, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_931 < 0.0031306699384003878f) {
    _964 = (_931 * 12.920000076293945f);
  } else {
    _964 = (((pow(_931, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _968 = (_953 * 0.9375f) + 0.03125f;
  float _975 = _964 * 15.0f;
  float _976 = floor(_975);
  float _977 = _975 - _976;
  float _979 = (_976 + ((_942 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _982 = Textures_1.SampleLevel(Samplers_1, float2(_979, _968), 0.0f);
  float _986 = _979 + 0.0625f;
  float4 _987 = Textures_1.SampleLevel(Samplers_1, float2(_986, _968), 0.0f);
  float4 _1009 = Textures_2.SampleLevel(Samplers_2, float2(_979, _968), 0.0f);
  float4 _1013 = Textures_2.SampleLevel(Samplers_2, float2(_986, _968), 0.0f);
  float4 _1035 = Textures_3.SampleLevel(Samplers_3, float2(_979, _968), 0.0f);
  float4 _1039 = Textures_3.SampleLevel(Samplers_3, float2(_986, _968), 0.0f);
  float4 _1062 = Textures_4.SampleLevel(Samplers_4, float2(_979, _968), 0.0f);
  float4 _1066 = Textures_4.SampleLevel(Samplers_4, float2(_986, _968), 0.0f);
  float _1085 = max(6.103519990574569e-05f, ((((((lerp(_982.x, _987.x, _977)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _942)) + ((lerp(_1009.x, _1013.x, _977)) * (LUTWeights[0].z))) + ((lerp(_1035.x, _1039.x, _977)) * (LUTWeights[0].w))) + ((lerp(_1062.x, _1066.x, _977)) * (LUTWeights[1].x))));
  float _1086 = max(6.103519990574569e-05f, ((((((lerp(_982.y, _987.y, _977)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _953)) + ((lerp(_1009.y, _1013.y, _977)) * (LUTWeights[0].z))) + ((lerp(_1035.y, _1039.y, _977)) * (LUTWeights[0].w))) + ((lerp(_1062.y, _1066.y, _977)) * (LUTWeights[1].x))));
  float _1087 = max(6.103519990574569e-05f, ((((((lerp(_982.z, _987.z, _977)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _964)) + ((lerp(_1009.z, _1013.z, _977)) * (LUTWeights[0].z))) + ((lerp(_1035.z, _1039.z, _977)) * (LUTWeights[0].w))) + ((lerp(_1062.z, _1066.z, _977)) * (LUTWeights[1].x))));
  float _1109 = select((_1085 > 0.040449999272823334f), exp2(log2((_1085 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1085 * 0.07739938050508499f));
  float _1110 = select((_1086 > 0.040449999272823334f), exp2(log2((_1086 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1086 * 0.07739938050508499f));
  float _1111 = select((_1087 > 0.040449999272823334f), exp2(log2((_1087 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1087 * 0.07739938050508499f));
  float _1137 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1109)) * _1109) + MappingPolynomial.z);
  float _1138 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1110)) * _1110) + MappingPolynomial.z);
  float _1139 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1111)) * _1111) + MappingPolynomial.z);
  float _1146 = ((OverlayColor.x - _1137) * OverlayColor.w) + _1137;
  float _1147 = ((OverlayColor.y - _1138) * OverlayColor.w) + _1138;
  float _1148 = ((OverlayColor.z - _1139) * OverlayColor.w) + _1139;
  float _1149 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _556, mad((WorkingColorSpace_FromAP1[0].y), _554, (_552 * (WorkingColorSpace_FromAP1[0].x))));
  float _1150 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _556, mad((WorkingColorSpace_FromAP1[1].y), _554, ((WorkingColorSpace_FromAP1[1].x) * _552)));
  float _1151 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _556, mad((WorkingColorSpace_FromAP1[2].y), _554, ((WorkingColorSpace_FromAP1[2].x) * _552)));
  float _1158 = ((OverlayColor.x - _1149) * OverlayColor.w) + _1149;
  float _1159 = ((OverlayColor.y - _1150) * OverlayColor.w) + _1150;
  float _1160 = ((OverlayColor.z - _1151) * OverlayColor.w) + _1151;
  float _1172 = exp2(log2(max(0.0f, _1146)) * InverseGamma.y);
  float _1173 = exp2(log2(max(0.0f, _1147)) * InverseGamma.y);
  float _1174 = exp2(log2(max(0.0f, _1148)) * InverseGamma.y);

  if (CUSTOM_PROCESSING_MODE == 0.f && RENODX_TONE_MAP_TYPE != 0.f) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1172, _1173, _1174), OutputDevice);
    return;
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1197 = mad((WorkingColorSpace_ToAP1[0].z), _1174, mad((WorkingColorSpace_ToAP1[0].y), _1173, ((WorkingColorSpace_ToAP1[0].x) * _1172)));
        float _1200 = mad((WorkingColorSpace_ToAP1[1].z), _1174, mad((WorkingColorSpace_ToAP1[1].y), _1173, ((WorkingColorSpace_ToAP1[1].x) * _1172)));
        float _1203 = mad((WorkingColorSpace_ToAP1[2].z), _1174, mad((WorkingColorSpace_ToAP1[2].y), _1173, ((WorkingColorSpace_ToAP1[2].x) * _1172)));
        _1214 = mad(_63, _1203, mad(_62, _1200, (_1197 * _61)));
        _1215 = mad(_66, _1203, mad(_65, _1200, (_1197 * _64)));
        _1216 = mad(_69, _1203, mad(_68, _1200, (_1197 * _67)));
      } else {
        _1214 = _1172;
        _1215 = _1173;
        _1216 = _1174;
      }
      do {
        if (_1214 < 0.0031306699384003878f) {
          _1227 = (_1214 * 12.920000076293945f);
        } else {
          _1227 = (((pow(_1214, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1215 < 0.0031306699384003878f) {
            _1238 = (_1215 * 12.920000076293945f);
          } else {
            _1238 = (((pow(_1215, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1216 < 0.0031306699384003878f) {
            _2594 = _1227;
            _2595 = _1238;
            _2596 = (_1216 * 12.920000076293945f);
          } else {
            _2594 = _1227;
            _2595 = _1238;
            _2596 = (((pow(_1216, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1265 = mad((WorkingColorSpace_ToAP1[0].z), _1174, mad((WorkingColorSpace_ToAP1[0].y), _1173, ((WorkingColorSpace_ToAP1[0].x) * _1172)));
      float _1268 = mad((WorkingColorSpace_ToAP1[1].z), _1174, mad((WorkingColorSpace_ToAP1[1].y), _1173, ((WorkingColorSpace_ToAP1[1].x) * _1172)));
      float _1271 = mad((WorkingColorSpace_ToAP1[2].z), _1174, mad((WorkingColorSpace_ToAP1[2].y), _1173, ((WorkingColorSpace_ToAP1[2].x) * _1172)));
      float _1281 = max(6.103519990574569e-05f, mad(_63, _1271, mad(_62, _1268, (_1265 * _61))));
      float _1282 = max(6.103519990574569e-05f, mad(_66, _1271, mad(_65, _1268, (_1265 * _64))));
      float _1283 = max(6.103519990574569e-05f, mad(_69, _1271, mad(_68, _1268, (_1265 * _67))));
      _2594 = min((_1281 * 4.5f), ((exp2(log2(max(_1281, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2595 = min((_1282 * 4.5f), ((exp2(log2(max(_1282, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2596 = min((_1283 * 4.5f), ((exp2(log2(max(_1283, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
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
        float _1358 = ACESSceneColorMultiplier * _1158;
        float _1359 = ACESSceneColorMultiplier * _1159;
        float _1360 = ACESSceneColorMultiplier * _1160;
        float _1363 = mad((WorkingColorSpace_ToAP0[0].z), _1360, mad((WorkingColorSpace_ToAP0[0].y), _1359, ((WorkingColorSpace_ToAP0[0].x) * _1358)));
        float _1366 = mad((WorkingColorSpace_ToAP0[1].z), _1360, mad((WorkingColorSpace_ToAP0[1].y), _1359, ((WorkingColorSpace_ToAP0[1].x) * _1358)));
        float _1369 = mad((WorkingColorSpace_ToAP0[2].z), _1360, mad((WorkingColorSpace_ToAP0[2].y), _1359, ((WorkingColorSpace_ToAP0[2].x) * _1358)));
        float _1373 = max(max(_1363, _1366), _1369);
        float _1378 = (max(_1373, 1.000000013351432e-10f) - max(min(min(_1363, _1366), _1369), 1.000000013351432e-10f)) / max(_1373, 0.009999999776482582f);
        float _1391 = ((_1366 + _1363) + _1369) + (sqrt((((_1369 - _1366) * _1369) + ((_1366 - _1363) * _1366)) + ((_1363 - _1369) * _1363)) * 1.75f);
        float _1392 = _1391 * 0.3333333432674408f;
        float _1393 = _1378 + -0.4000000059604645f;
        float _1394 = _1393 * 5.0f;
        float _1398 = max((1.0f - abs(_1393 * 2.5f)), 0.0f);
        float _1409 = ((float(((int)(uint)((bool)(_1394 > 0.0f))) - ((int)(uint)((bool)(_1394 < 0.0f)))) * (1.0f - (_1398 * _1398))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1392 <= 0.0533333346247673f)) {
            if (!(_1392 >= 0.1599999964237213f)) {
              _1418 = (((0.23999999463558197f / _1391) + -0.5f) * _1409);
            } else {
              _1418 = 0.0f;
            }
          } else {
            _1418 = _1409;
          }
          float _1419 = _1418 + 1.0f;
          float _1420 = _1419 * _1363;
          float _1421 = _1419 * _1366;
          float _1422 = _1419 * _1369;
          do {
            if (!((bool)(_1420 == _1421) && (bool)(_1421 == _1422))) {
              float _1429 = ((_1420 * 2.0f) - _1421) - _1422;
              float _1432 = ((_1366 - _1369) * 1.7320507764816284f) * _1419;
              float _1434 = atan(_1432 / _1429);
              bool _1437 = (_1429 < 0.0f);
              bool _1438 = (_1429 == 0.0f);
              bool _1439 = (_1432 >= 0.0f);
              bool _1440 = (_1432 < 0.0f);
              _1451 = select((_1439 && _1438), 90.0f, select((_1440 && _1438), -90.0f, (select((_1440 && _1437), (_1434 + -3.1415927410125732f), select((_1439 && _1437), (_1434 + 3.1415927410125732f), _1434)) * 57.2957763671875f)));
            } else {
              _1451 = 0.0f;
            }
            float _1456 = min(max(select((_1451 < 0.0f), (_1451 + 360.0f), _1451), 0.0f), 360.0f);
            do {
              if (_1456 < -180.0f) {
                _1465 = (_1456 + 360.0f);
              } else {
                if (_1456 > 180.0f) {
                  _1465 = (_1456 + -360.0f);
                } else {
                  _1465 = _1456;
                }
              }
              do {
                if ((bool)(_1465 > -67.5f) && (bool)(_1465 < 67.5f)) {
                  float _1471 = (_1465 + 67.5f) * 0.029629629105329514f;
                  int _1472 = int(_1471);
                  float _1474 = _1471 - float(_1472);
                  float _1475 = _1474 * _1474;
                  float _1476 = _1475 * _1474;
                  if (_1472 == 3) {
                    _1504 = (((0.1666666716337204f - (_1474 * 0.5f)) + (_1475 * 0.5f)) - (_1476 * 0.1666666716337204f));
                  } else {
                    if (_1472 == 2) {
                      _1504 = ((0.6666666865348816f - _1475) + (_1476 * 0.5f));
                    } else {
                      if (_1472 == 1) {
                        _1504 = (((_1476 * -0.5f) + 0.1666666716337204f) + ((_1475 + _1474) * 0.5f));
                      } else {
                        _1504 = select((_1472 == 0), (_1476 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1504 = 0.0f;
                }
                float _1513 = min(max(((((_1378 * 0.27000001072883606f) * (0.029999999329447746f - _1420)) * _1504) + _1420), 0.0f), 65535.0f);
                float _1514 = min(max(_1421, 0.0f), 65535.0f);
                float _1515 = min(max(_1422, 0.0f), 65535.0f);
                float _1528 = min(max(mad(-0.21492856740951538f, _1515, mad(-0.2365107536315918f, _1514, (_1513 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1529 = min(max(mad(-0.09967592358589172f, _1515, mad(1.17622971534729f, _1514, (_1513 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1530 = min(max(mad(0.9977163076400757f, _1515, mad(-0.006032449658960104f, _1514, (_1513 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1531 = dot(float3(_1528, _1529, _1530), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1542 = log2(max((lerp(_1531, _1528, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1543 = _1542 * 0.3010300099849701f;
                float _1544 = log2(ACESMinMaxData.x);
                float _1545 = _1544 * 0.3010300099849701f;
                do {
                  if (!(!(_1543 <= _1545))) {
                    _1614 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1552 = log2(ACESMidData.x);
                    float _1553 = _1552 * 0.3010300099849701f;
                    if ((bool)(_1543 > _1545) && (bool)(_1543 < _1553)) {
                      float _1561 = ((_1542 - _1544) * 0.9030900001525879f) / ((_1552 - _1544) * 0.3010300099849701f);
                      int _1562 = int(_1561);
                      float _1564 = _1561 - float(_1562);
                      float _1566 = _19[_1562];
                      float _1569 = _19[(_1562 + 1)];
                      float _1574 = _1566 * 0.5f;
                      _1614 = dot(float3((_1564 * _1564), _1564, 1.0f), float3(mad((_19[(_1562 + 2)]), 0.5f, mad(_1569, -1.0f, _1574)), (_1569 - _1566), mad(_1569, 0.5f, _1574)));
                    } else {
                      do {
                        if (!(!(_1543 >= _1553))) {
                          float _1583 = log2(ACESMinMaxData.z);
                          if (_1543 < (_1583 * 0.3010300099849701f)) {
                            float _1591 = ((_1542 - _1552) * 0.9030900001525879f) / ((_1583 - _1552) * 0.3010300099849701f);
                            int _1592 = int(_1591);
                            float _1594 = _1591 - float(_1592);
                            float _1596 = _20[_1592];
                            float _1599 = _20[(_1592 + 1)];
                            float _1604 = _1596 * 0.5f;
                            _1614 = dot(float3((_1594 * _1594), _1594, 1.0f), float3(mad((_20[(_1592 + 2)]), 0.5f, mad(_1599, -1.0f, _1604)), (_1599 - _1596), mad(_1599, 0.5f, _1604)));
                            break;
                          }
                        }
                        _1614 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1618 = log2(max((lerp(_1531, _1529, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1619 = _1618 * 0.3010300099849701f;
                  do {
                    if (!(!(_1619 <= _1545))) {
                      _1688 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1626 = log2(ACESMidData.x);
                      float _1627 = _1626 * 0.3010300099849701f;
                      if ((bool)(_1619 > _1545) && (bool)(_1619 < _1627)) {
                        float _1635 = ((_1618 - _1544) * 0.9030900001525879f) / ((_1626 - _1544) * 0.3010300099849701f);
                        int _1636 = int(_1635);
                        float _1638 = _1635 - float(_1636);
                        float _1640 = _19[_1636];
                        float _1643 = _19[(_1636 + 1)];
                        float _1648 = _1640 * 0.5f;
                        _1688 = dot(float3((_1638 * _1638), _1638, 1.0f), float3(mad((_19[(_1636 + 2)]), 0.5f, mad(_1643, -1.0f, _1648)), (_1643 - _1640), mad(_1643, 0.5f, _1648)));
                      } else {
                        do {
                          if (!(!(_1619 >= _1627))) {
                            float _1657 = log2(ACESMinMaxData.z);
                            if (_1619 < (_1657 * 0.3010300099849701f)) {
                              float _1665 = ((_1618 - _1626) * 0.9030900001525879f) / ((_1657 - _1626) * 0.3010300099849701f);
                              int _1666 = int(_1665);
                              float _1668 = _1665 - float(_1666);
                              float _1670 = _20[_1666];
                              float _1673 = _20[(_1666 + 1)];
                              float _1678 = _1670 * 0.5f;
                              _1688 = dot(float3((_1668 * _1668), _1668, 1.0f), float3(mad((_20[(_1666 + 2)]), 0.5f, mad(_1673, -1.0f, _1678)), (_1673 - _1670), mad(_1673, 0.5f, _1678)));
                              break;
                            }
                          }
                          _1688 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1692 = log2(max((lerp(_1531, _1530, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1693 = _1692 * 0.3010300099849701f;
                    do {
                      if (!(!(_1693 <= _1545))) {
                        _1762 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1700 = log2(ACESMidData.x);
                        float _1701 = _1700 * 0.3010300099849701f;
                        if ((bool)(_1693 > _1545) && (bool)(_1693 < _1701)) {
                          float _1709 = ((_1692 - _1544) * 0.9030900001525879f) / ((_1700 - _1544) * 0.3010300099849701f);
                          int _1710 = int(_1709);
                          float _1712 = _1709 - float(_1710);
                          float _1714 = _19[_1710];
                          float _1717 = _19[(_1710 + 1)];
                          float _1722 = _1714 * 0.5f;
                          _1762 = dot(float3((_1712 * _1712), _1712, 1.0f), float3(mad((_19[(_1710 + 2)]), 0.5f, mad(_1717, -1.0f, _1722)), (_1717 - _1714), mad(_1717, 0.5f, _1722)));
                        } else {
                          do {
                            if (!(!(_1693 >= _1701))) {
                              float _1731 = log2(ACESMinMaxData.z);
                              if (_1693 < (_1731 * 0.3010300099849701f)) {
                                float _1739 = ((_1692 - _1700) * 0.9030900001525879f) / ((_1731 - _1700) * 0.3010300099849701f);
                                int _1740 = int(_1739);
                                float _1742 = _1739 - float(_1740);
                                float _1744 = _20[_1740];
                                float _1747 = _20[(_1740 + 1)];
                                float _1752 = _1744 * 0.5f;
                                _1762 = dot(float3((_1742 * _1742), _1742, 1.0f), float3(mad((_20[(_1740 + 2)]), 0.5f, mad(_1747, -1.0f, _1752)), (_1747 - _1744), mad(_1747, 0.5f, _1752)));
                                break;
                              }
                            }
                            _1762 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1766 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1767 = (exp2(_1614 * 3.321928024291992f) - ACESMinMaxData.y) / _1766;
                      float _1769 = (exp2(_1688 * 3.321928024291992f) - ACESMinMaxData.y) / _1766;
                      float _1771 = (exp2(_1762 * 3.321928024291992f) - ACESMinMaxData.y) / _1766;
                      float _1774 = mad(0.15618768334388733f, _1771, mad(0.13400420546531677f, _1769, (_1767 * 0.6624541878700256f)));
                      float _1777 = mad(0.053689517080783844f, _1771, mad(0.6740817427635193f, _1769, (_1767 * 0.2722287178039551f)));
                      float _1780 = mad(1.0103391408920288f, _1771, mad(0.00406073359772563f, _1769, (_1767 * -0.005574649665504694f)));
                      float _1793 = min(max(mad(-0.23642469942569733f, _1780, mad(-0.32480329275131226f, _1777, (_1774 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1794 = min(max(mad(0.016756348311901093f, _1780, mad(1.6153316497802734f, _1777, (_1774 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1795 = min(max(mad(0.9883948564529419f, _1780, mad(-0.008284442126750946f, _1777, (_1774 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1798 = mad(0.15618768334388733f, _1795, mad(0.13400420546531677f, _1794, (_1793 * 0.6624541878700256f)));
                      float _1801 = mad(0.053689517080783844f, _1795, mad(0.6740817427635193f, _1794, (_1793 * 0.2722287178039551f)));
                      float _1804 = mad(1.0103391408920288f, _1795, mad(0.00406073359772563f, _1794, (_1793 * -0.005574649665504694f)));
                      float _1826 = min(max((min(max(mad(-0.23642469942569733f, _1804, mad(-0.32480329275131226f, _1801, (_1798 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1827 = min(max((min(max(mad(0.016756348311901093f, _1804, mad(1.6153316497802734f, _1801, (_1798 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1828 = min(max((min(max(mad(0.9883948564529419f, _1804, mad(-0.008284442126750946f, _1801, (_1798 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(OutputDevice) == 5)) {
                          _1841 = mad(_63, _1828, mad(_62, _1827, (_1826 * _61)));
                          _1842 = mad(_66, _1828, mad(_65, _1827, (_1826 * _64)));
                          _1843 = mad(_69, _1828, mad(_68, _1827, (_1826 * _67)));
                        } else {
                          _1841 = _1826;
                          _1842 = _1827;
                          _1843 = _1828;
                        }
                        float _1853 = exp2(log2(_1841 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1854 = exp2(log2(_1842 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1855 = exp2(log2(_1843 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2594 = exp2(log2((1.0f / ((_1853 * 18.6875f) + 1.0f)) * ((_1853 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2595 = exp2(log2((1.0f / ((_1854 * 18.6875f) + 1.0f)) * ((_1854 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2596 = exp2(log2((1.0f / ((_1855 * 18.6875f) + 1.0f)) * ((_1855 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1932 = ACESSceneColorMultiplier * _1158;
          float _1933 = ACESSceneColorMultiplier * _1159;
          float _1934 = ACESSceneColorMultiplier * _1160;
          float _1937 = mad((WorkingColorSpace_ToAP0[0].z), _1934, mad((WorkingColorSpace_ToAP0[0].y), _1933, ((WorkingColorSpace_ToAP0[0].x) * _1932)));
          float _1940 = mad((WorkingColorSpace_ToAP0[1].z), _1934, mad((WorkingColorSpace_ToAP0[1].y), _1933, ((WorkingColorSpace_ToAP0[1].x) * _1932)));
          float _1943 = mad((WorkingColorSpace_ToAP0[2].z), _1934, mad((WorkingColorSpace_ToAP0[2].y), _1933, ((WorkingColorSpace_ToAP0[2].x) * _1932)));
          float _1947 = max(max(_1937, _1940), _1943);
          float _1952 = (max(_1947, 1.000000013351432e-10f) - max(min(min(_1937, _1940), _1943), 1.000000013351432e-10f)) / max(_1947, 0.009999999776482582f);
          float _1965 = ((_1940 + _1937) + _1943) + (sqrt((((_1943 - _1940) * _1943) + ((_1940 - _1937) * _1940)) + ((_1937 - _1943) * _1937)) * 1.75f);
          float _1966 = _1965 * 0.3333333432674408f;
          float _1967 = _1952 + -0.4000000059604645f;
          float _1968 = _1967 * 5.0f;
          float _1972 = max((1.0f - abs(_1967 * 2.5f)), 0.0f);
          float _1983 = ((float(((int)(uint)((bool)(_1968 > 0.0f))) - ((int)(uint)((bool)(_1968 < 0.0f)))) * (1.0f - (_1972 * _1972))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1966 <= 0.0533333346247673f)) {
              if (!(_1966 >= 0.1599999964237213f)) {
                _1992 = (((0.23999999463558197f / _1965) + -0.5f) * _1983);
              } else {
                _1992 = 0.0f;
              }
            } else {
              _1992 = _1983;
            }
            float _1993 = _1992 + 1.0f;
            float _1994 = _1993 * _1937;
            float _1995 = _1993 * _1940;
            float _1996 = _1993 * _1943;
            do {
              if (!((bool)(_1994 == _1995) && (bool)(_1995 == _1996))) {
                float _2003 = ((_1994 * 2.0f) - _1995) - _1996;
                float _2006 = ((_1940 - _1943) * 1.7320507764816284f) * _1993;
                float _2008 = atan(_2006 / _2003);
                bool _2011 = (_2003 < 0.0f);
                bool _2012 = (_2003 == 0.0f);
                bool _2013 = (_2006 >= 0.0f);
                bool _2014 = (_2006 < 0.0f);
                _2025 = select((_2013 && _2012), 90.0f, select((_2014 && _2012), -90.0f, (select((_2014 && _2011), (_2008 + -3.1415927410125732f), select((_2013 && _2011), (_2008 + 3.1415927410125732f), _2008)) * 57.2957763671875f)));
              } else {
                _2025 = 0.0f;
              }
              float _2030 = min(max(select((_2025 < 0.0f), (_2025 + 360.0f), _2025), 0.0f), 360.0f);
              do {
                if (_2030 < -180.0f) {
                  _2039 = (_2030 + 360.0f);
                } else {
                  if (_2030 > 180.0f) {
                    _2039 = (_2030 + -360.0f);
                  } else {
                    _2039 = _2030;
                  }
                }
                do {
                  if ((bool)(_2039 > -67.5f) && (bool)(_2039 < 67.5f)) {
                    float _2045 = (_2039 + 67.5f) * 0.029629629105329514f;
                    int _2046 = int(_2045);
                    float _2048 = _2045 - float(_2046);
                    float _2049 = _2048 * _2048;
                    float _2050 = _2049 * _2048;
                    if (_2046 == 3) {
                      _2078 = (((0.1666666716337204f - (_2048 * 0.5f)) + (_2049 * 0.5f)) - (_2050 * 0.1666666716337204f));
                    } else {
                      if (_2046 == 2) {
                        _2078 = ((0.6666666865348816f - _2049) + (_2050 * 0.5f));
                      } else {
                        if (_2046 == 1) {
                          _2078 = (((_2050 * -0.5f) + 0.1666666716337204f) + ((_2049 + _2048) * 0.5f));
                        } else {
                          _2078 = select((_2046 == 0), (_2050 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2078 = 0.0f;
                  }
                  float _2087 = min(max(((((_1952 * 0.27000001072883606f) * (0.029999999329447746f - _1994)) * _2078) + _1994), 0.0f), 65535.0f);
                  float _2088 = min(max(_1995, 0.0f), 65535.0f);
                  float _2089 = min(max(_1996, 0.0f), 65535.0f);
                  float _2102 = min(max(mad(-0.21492856740951538f, _2089, mad(-0.2365107536315918f, _2088, (_2087 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2103 = min(max(mad(-0.09967592358589172f, _2089, mad(1.17622971534729f, _2088, (_2087 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2104 = min(max(mad(0.9977163076400757f, _2089, mad(-0.006032449658960104f, _2088, (_2087 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2105 = dot(float3(_2102, _2103, _2104), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2116 = log2(max((lerp(_2105, _2102, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2117 = _2116 * 0.3010300099849701f;
                  float _2118 = log2(ACESMinMaxData.x);
                  float _2119 = _2118 * 0.3010300099849701f;
                  do {
                    if (!(!(_2117 <= _2119))) {
                      _2188 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2126 = log2(ACESMidData.x);
                      float _2127 = _2126 * 0.3010300099849701f;
                      if ((bool)(_2117 > _2119) && (bool)(_2117 < _2127)) {
                        float _2135 = ((_2116 - _2118) * 0.9030900001525879f) / ((_2126 - _2118) * 0.3010300099849701f);
                        int _2136 = int(_2135);
                        float _2138 = _2135 - float(_2136);
                        float _2140 = _17[_2136];
                        float _2143 = _17[(_2136 + 1)];
                        float _2148 = _2140 * 0.5f;
                        _2188 = dot(float3((_2138 * _2138), _2138, 1.0f), float3(mad((_17[(_2136 + 2)]), 0.5f, mad(_2143, -1.0f, _2148)), (_2143 - _2140), mad(_2143, 0.5f, _2148)));
                      } else {
                        do {
                          if (!(!(_2117 >= _2127))) {
                            float _2157 = log2(ACESMinMaxData.z);
                            if (_2117 < (_2157 * 0.3010300099849701f)) {
                              float _2165 = ((_2116 - _2126) * 0.9030900001525879f) / ((_2157 - _2126) * 0.3010300099849701f);
                              int _2166 = int(_2165);
                              float _2168 = _2165 - float(_2166);
                              float _2170 = _18[_2166];
                              float _2173 = _18[(_2166 + 1)];
                              float _2178 = _2170 * 0.5f;
                              _2188 = dot(float3((_2168 * _2168), _2168, 1.0f), float3(mad((_18[(_2166 + 2)]), 0.5f, mad(_2173, -1.0f, _2178)), (_2173 - _2170), mad(_2173, 0.5f, _2178)));
                              break;
                            }
                          }
                          _2188 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2192 = log2(max((lerp(_2105, _2103, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2193 = _2192 * 0.3010300099849701f;
                    do {
                      if (!(!(_2193 <= _2119))) {
                        _2262 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2200 = log2(ACESMidData.x);
                        float _2201 = _2200 * 0.3010300099849701f;
                        if ((bool)(_2193 > _2119) && (bool)(_2193 < _2201)) {
                          float _2209 = ((_2192 - _2118) * 0.9030900001525879f) / ((_2200 - _2118) * 0.3010300099849701f);
                          int _2210 = int(_2209);
                          float _2212 = _2209 - float(_2210);
                          float _2214 = _17[_2210];
                          float _2217 = _17[(_2210 + 1)];
                          float _2222 = _2214 * 0.5f;
                          _2262 = dot(float3((_2212 * _2212), _2212, 1.0f), float3(mad((_17[(_2210 + 2)]), 0.5f, mad(_2217, -1.0f, _2222)), (_2217 - _2214), mad(_2217, 0.5f, _2222)));
                        } else {
                          do {
                            if (!(!(_2193 >= _2201))) {
                              float _2231 = log2(ACESMinMaxData.z);
                              if (_2193 < (_2231 * 0.3010300099849701f)) {
                                float _2239 = ((_2192 - _2200) * 0.9030900001525879f) / ((_2231 - _2200) * 0.3010300099849701f);
                                int _2240 = int(_2239);
                                float _2242 = _2239 - float(_2240);
                                float _2244 = _18[_2240];
                                float _2247 = _18[(_2240 + 1)];
                                float _2252 = _2244 * 0.5f;
                                _2262 = dot(float3((_2242 * _2242), _2242, 1.0f), float3(mad((_18[(_2240 + 2)]), 0.5f, mad(_2247, -1.0f, _2252)), (_2247 - _2244), mad(_2247, 0.5f, _2252)));
                                break;
                              }
                            }
                            _2262 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2266 = log2(max((lerp(_2105, _2104, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2267 = _2266 * 0.3010300099849701f;
                      do {
                        if (!(!(_2267 <= _2119))) {
                          _2336 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2274 = log2(ACESMidData.x);
                          float _2275 = _2274 * 0.3010300099849701f;
                          if ((bool)(_2267 > _2119) && (bool)(_2267 < _2275)) {
                            float _2283 = ((_2266 - _2118) * 0.9030900001525879f) / ((_2274 - _2118) * 0.3010300099849701f);
                            int _2284 = int(_2283);
                            float _2286 = _2283 - float(_2284);
                            float _2288 = _17[_2284];
                            float _2291 = _17[(_2284 + 1)];
                            float _2296 = _2288 * 0.5f;
                            _2336 = dot(float3((_2286 * _2286), _2286, 1.0f), float3(mad((_17[(_2284 + 2)]), 0.5f, mad(_2291, -1.0f, _2296)), (_2291 - _2288), mad(_2291, 0.5f, _2296)));
                          } else {
                            do {
                              if (!(!(_2267 >= _2275))) {
                                float _2305 = log2(ACESMinMaxData.z);
                                if (_2267 < (_2305 * 0.3010300099849701f)) {
                                  float _2313 = ((_2266 - _2274) * 0.9030900001525879f) / ((_2305 - _2274) * 0.3010300099849701f);
                                  int _2314 = int(_2313);
                                  float _2316 = _2313 - float(_2314);
                                  float _2318 = _18[_2314];
                                  float _2321 = _18[(_2314 + 1)];
                                  float _2326 = _2318 * 0.5f;
                                  _2336 = dot(float3((_2316 * _2316), _2316, 1.0f), float3(mad((_18[(_2314 + 2)]), 0.5f, mad(_2321, -1.0f, _2326)), (_2321 - _2318), mad(_2321, 0.5f, _2326)));
                                  break;
                                }
                              }
                              _2336 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2340 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2341 = (exp2(_2188 * 3.321928024291992f) - ACESMinMaxData.y) / _2340;
                        float _2343 = (exp2(_2262 * 3.321928024291992f) - ACESMinMaxData.y) / _2340;
                        float _2345 = (exp2(_2336 * 3.321928024291992f) - ACESMinMaxData.y) / _2340;
                        float _2348 = mad(0.15618768334388733f, _2345, mad(0.13400420546531677f, _2343, (_2341 * 0.6624541878700256f)));
                        float _2351 = mad(0.053689517080783844f, _2345, mad(0.6740817427635193f, _2343, (_2341 * 0.2722287178039551f)));
                        float _2354 = mad(1.0103391408920288f, _2345, mad(0.00406073359772563f, _2343, (_2341 * -0.005574649665504694f)));
                        float _2367 = min(max(mad(-0.23642469942569733f, _2354, mad(-0.32480329275131226f, _2351, (_2348 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2368 = min(max(mad(0.016756348311901093f, _2354, mad(1.6153316497802734f, _2351, (_2348 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2369 = min(max(mad(0.9883948564529419f, _2354, mad(-0.008284442126750946f, _2351, (_2348 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2372 = mad(0.15618768334388733f, _2369, mad(0.13400420546531677f, _2368, (_2367 * 0.6624541878700256f)));
                        float _2375 = mad(0.053689517080783844f, _2369, mad(0.6740817427635193f, _2368, (_2367 * 0.2722287178039551f)));
                        float _2378 = mad(1.0103391408920288f, _2369, mad(0.00406073359772563f, _2368, (_2367 * -0.005574649665504694f)));
                        float _2400 = min(max((min(max(mad(-0.23642469942569733f, _2378, mad(-0.32480329275131226f, _2375, (_2372 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2401 = min(max((min(max(mad(0.016756348311901093f, _2378, mad(1.6153316497802734f, _2375, (_2372 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2402 = min(max((min(max(mad(0.9883948564529419f, _2378, mad(-0.008284442126750946f, _2375, (_2372 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 6)) {
                            _2415 = mad(_63, _2402, mad(_62, _2401, (_2400 * _61)));
                            _2416 = mad(_66, _2402, mad(_65, _2401, (_2400 * _64)));
                            _2417 = mad(_69, _2402, mad(_68, _2401, (_2400 * _67)));
                          } else {
                            _2415 = _2400;
                            _2416 = _2401;
                            _2417 = _2402;
                          }
                          float _2427 = exp2(log2(_2415 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2428 = exp2(log2(_2416 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2429 = exp2(log2(_2417 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2594 = exp2(log2((1.0f / ((_2427 * 18.6875f) + 1.0f)) * ((_2427 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2595 = exp2(log2((1.0f / ((_2428 * 18.6875f) + 1.0f)) * ((_2428 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2596 = exp2(log2((1.0f / ((_2429 * 18.6875f) + 1.0f)) * ((_2429 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2474 = mad((WorkingColorSpace_ToAP1[0].z), _1160, mad((WorkingColorSpace_ToAP1[0].y), _1159, ((WorkingColorSpace_ToAP1[0].x) * _1158)));
            float _2477 = mad((WorkingColorSpace_ToAP1[1].z), _1160, mad((WorkingColorSpace_ToAP1[1].y), _1159, ((WorkingColorSpace_ToAP1[1].x) * _1158)));
            float _2480 = mad((WorkingColorSpace_ToAP1[2].z), _1160, mad((WorkingColorSpace_ToAP1[2].y), _1159, ((WorkingColorSpace_ToAP1[2].x) * _1158)));
            float _2499 = exp2(log2(mad(_63, _2480, mad(_62, _2477, (_2474 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2500 = exp2(log2(mad(_66, _2480, mad(_65, _2477, (_2474 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2501 = exp2(log2(mad(_69, _2480, mad(_68, _2477, (_2474 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2594 = exp2(log2((1.0f / ((_2499 * 18.6875f) + 1.0f)) * ((_2499 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2595 = exp2(log2((1.0f / ((_2500 * 18.6875f) + 1.0f)) * ((_2500 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2596 = exp2(log2((1.0f / ((_2501 * 18.6875f) + 1.0f)) * ((_2501 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2548 = mad((WorkingColorSpace_ToAP1[0].z), _1148, mad((WorkingColorSpace_ToAP1[0].y), _1147, ((WorkingColorSpace_ToAP1[0].x) * _1146)));
                float _2551 = mad((WorkingColorSpace_ToAP1[1].z), _1148, mad((WorkingColorSpace_ToAP1[1].y), _1147, ((WorkingColorSpace_ToAP1[1].x) * _1146)));
                float _2554 = mad((WorkingColorSpace_ToAP1[2].z), _1148, mad((WorkingColorSpace_ToAP1[2].y), _1147, ((WorkingColorSpace_ToAP1[2].x) * _1146)));
                _2594 = mad(_63, _2554, mad(_62, _2551, (_2548 * _61)));
                _2595 = mad(_66, _2554, mad(_65, _2551, (_2548 * _64)));
                _2596 = mad(_69, _2554, mad(_68, _2551, (_2548 * _67)));
              } else {
                float _2567 = mad((WorkingColorSpace_ToAP1[0].z), _1174, mad((WorkingColorSpace_ToAP1[0].y), _1173, ((WorkingColorSpace_ToAP1[0].x) * _1172)));
                float _2570 = mad((WorkingColorSpace_ToAP1[1].z), _1174, mad((WorkingColorSpace_ToAP1[1].y), _1173, ((WorkingColorSpace_ToAP1[1].x) * _1172)));
                float _2573 = mad((WorkingColorSpace_ToAP1[2].z), _1174, mad((WorkingColorSpace_ToAP1[2].y), _1173, ((WorkingColorSpace_ToAP1[2].x) * _1172)));
                _2594 = exp2(log2(mad(_63, _2573, mad(_62, _2570, (_2567 * _61)))) * InverseGamma.z);
                _2595 = exp2(log2(mad(_66, _2573, mad(_65, _2570, (_2567 * _64)))) * InverseGamma.z);
                _2596 = exp2(log2(mad(_69, _2573, mad(_68, _2570, (_2567 * _67)))) * InverseGamma.z);
              }
            } else {
              _2594 = _1158;
              _2595 = _1159;
              _2596 = _1160;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2594 * 0.9523810148239136f), (_2595 * 0.9523810148239136f), (_2596 * 0.9523810148239136f), 0.0f);
}

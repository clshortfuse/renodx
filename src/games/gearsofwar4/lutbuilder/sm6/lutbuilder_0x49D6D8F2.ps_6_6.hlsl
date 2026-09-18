// Split Fiction (UE 5.4.4)

#include "../lutbuilderoutput.hlsli"

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};


cbuffer _RootShaderParameters : register(b0) {
  float4 ACESMinMaxData : packoffset(c008.x);
  float4 ACESMidData : packoffset(c009.x);
  float4 ACESCoefsLow_0 : packoffset(c010.x);
  float4 ACESCoefsHigh_0 : packoffset(c011.x);
  float ACESCoefsLow_4 : packoffset(c012.x);
  float ACESCoefsHigh_4 : packoffset(c012.y);
  float ACESSceneColorMultiplier : packoffset(c012.z);
  float ACESGamutCompression : packoffset(c012.w);
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
  float3 MappingPolynomial : packoffset(c039.x);
  float3 InverseGamma : packoffset(c040.x);
  uint OutputDevice : packoffset(c040.w);
  uint OutputGamut : packoffset(c041.x);
};

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
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
  float _1207;
  float _1222;
  float _1237;
  float _1245;
  float _1246;
  float _1247;
  float _1314;
  float _1347;
  float _1361;
  float _1400;
  float _1510;
  float _1584;
  float _1658;
  float _1737;
  float _1738;
  float _1739;
  float _1881;
  float _1896;
  float _1911;
  float _1919;
  float _1920;
  float _1921;
  float _1988;
  float _2021;
  float _2035;
  float _2074;
  float _2184;
  float _2258;
  float _2332;
  float _2411;
  float _2412;
  float _2413;
  float _2590;
  float _2591;
  float _2592;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _32 = ((uint)(OutputGamut) == 4);
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
  if ((uint)(uint)(OutputDevice) > (uint)2) {
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
  float _126 = mad((WorkingColorSpace.ToAP1[0].z), _111, mad((WorkingColorSpace.ToAP1[0].y), _110, ((WorkingColorSpace.ToAP1[0].x) * _109)));
  float _129 = mad((WorkingColorSpace.ToAP1[1].z), _111, mad((WorkingColorSpace.ToAP1[1].y), _110, ((WorkingColorSpace.ToAP1[1].x) * _109)));
  float _132 = mad((WorkingColorSpace.ToAP1[2].z), _111, mad((WorkingColorSpace.ToAP1[2].y), _110, ((WorkingColorSpace.ToAP1[2].x) * _109)));
  float _133 = dot(float3(_126, _129, _132), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _137 = (_126 / _133) + -1.0f;
  float _138 = (_129 / _133) + -1.0f;
  float _139 = (_132 / _133) + -1.0f;
  // float _151 = (1.0f - exp2(((_133 * _133) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_137, _138, _139), float3(_137, _138, _139)) * -4.0f));
  float _151 = (1.0f - exp2(((_133 * _133) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_137, _138, _139), float3(_137, _138, _139)) * -4.0f));
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

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = FilmBlackClip;
  cb_config.ue_filmtoe = FilmToe;
  cb_config.ue_filmshoulder = FilmShoulder;
  cb_config.ue_filmslope = FilmSlope;
  cb_config.ue_filmwhiteclip = FilmWhiteClip;
  cb_config.ue_tonecurveammount = ToneCurveAmount;
  cb_config.ue_mappingpolynomial = MappingPolynomial;
  cb_config.ue_overlaycolor = OverlayColor;
  cb_config.ue_bluecorrection = BlueCorrection;
  cb_config.ue_colorscale = ColorScale;

  SV_Target = ProcessLutbuilder(float3(_534, _536, _538), cb_config, SV_Target, OutputDevice);
  return SV_Target;
  
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

  // Removed max(0,)
  float _908 = mad((WorkingColorSpace.FromAP1[0].z), _898, mad((WorkingColorSpace.FromAP1[0].y), _897, ((WorkingColorSpace.FromAP1[0].x) * _896)));
  float _909 = mad((WorkingColorSpace.FromAP1[1].z), _898, mad((WorkingColorSpace.FromAP1[1].y), _897, ((WorkingColorSpace.FromAP1[1].x) * _896)));
  float _910 = mad((WorkingColorSpace.FromAP1[2].z), _898, mad((WorkingColorSpace.FromAP1[2].y), _897, ((WorkingColorSpace.FromAP1[2].x) * _896)));
  float _936 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _908)) * _908) + MappingPolynomial.z);
  float _937 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _909)) * _909) + MappingPolynomial.z);
  float _938 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _910)) * _910) + MappingPolynomial.z);
  float _945 = ((OverlayColor.x - _936) * OverlayColor.w) + _936;
  float _946 = ((OverlayColor.y - _937) * OverlayColor.w) + _937;
  float _947 = ((OverlayColor.z - _938) * OverlayColor.w) + _938;
  
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
  if ((uint)(OutputDevice) == 0) {
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
            _2590 = _1026;
            _2591 = _1037;
            _2592 = (_1015 * 12.920000076293945f);
          } else {
            _2590 = _1026;
            _2591 = _1037;
            _2592 = (((pow(_1015, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1064 = mad((WorkingColorSpace.ToAP1[0].z), _973, mad((WorkingColorSpace.ToAP1[0].y), _972, ((WorkingColorSpace.ToAP1[0].x) * _971)));
      float _1067 = mad((WorkingColorSpace.ToAP1[1].z), _973, mad((WorkingColorSpace.ToAP1[1].y), _972, ((WorkingColorSpace.ToAP1[1].x) * _971)));
      float _1070 = mad((WorkingColorSpace.ToAP1[2].z), _973, mad((WorkingColorSpace.ToAP1[2].y), _972, ((WorkingColorSpace.ToAP1[2].x) * _971)));
      float _1073 = mad(_45, _1070, mad(_44, _1067, (_1064 * _43)));
      float _1076 = mad(_48, _1070, mad(_47, _1067, (_1064 * _46)));
      float _1079 = mad(_51, _1070, mad(_50, _1067, (_1064 * _49)));
      _2590 = min((_1073 * 4.5f), ((exp2(log2(max(_1073, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2591 = min((_1076 * 4.5f), ((exp2(log2(max(_1076, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2592 = min((_1079 * 4.5f), ((exp2(log2(max(_1079, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
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
        float _1155 = ACESSceneColorMultiplier * _957;
        float _1156 = ACESSceneColorMultiplier * _958;
        float _1157 = ACESSceneColorMultiplier * _959;
        float _1160 = mad((WorkingColorSpace.ToAP0[0].z), _1157, mad((WorkingColorSpace.ToAP0[0].y), _1156, ((WorkingColorSpace.ToAP0[0].x) * _1155)));
        float _1163 = mad((WorkingColorSpace.ToAP0[1].z), _1157, mad((WorkingColorSpace.ToAP0[1].y), _1156, ((WorkingColorSpace.ToAP0[1].x) * _1155)));
        float _1166 = mad((WorkingColorSpace.ToAP0[2].z), _1157, mad((WorkingColorSpace.ToAP0[2].y), _1156, ((WorkingColorSpace.ToAP0[2].x) * _1155)));
        float _1169 = mad(-0.21492856740951538f, _1166, mad(-0.2365107536315918f, _1163, (_1160 * 1.4514392614364624f)));
        float _1172 = mad(-0.09967592358589172f, _1166, mad(1.17622971534729f, _1163, (_1160 * -0.07655377686023712f)));
        float _1175 = mad(0.9977163076400757f, _1166, mad(-0.006032449658960104f, _1163, (_1160 * 0.008316148072481155f)));
        float _1177 = max(_1169, max(_1172, _1175));
        do {
          if (!(_1177 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1160 < 0.0f) || (bool)(_1163 < 0.0f))) || (bool)(_1166 < 0.0f))) {
              float _1187 = abs(_1177);
              float _1188 = (_1177 - _1169) / _1187;
              float _1190 = (_1177 - _1172) / _1187;
              float _1192 = (_1177 - _1175) / _1187;
              do {
                if (!(_1188 < 0.8149999976158142f)) {
                  float _1195 = _1188 + -0.8149999976158142f;
                  _1207 = ((_1195 / exp2(log2(exp2(log2(_1195 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1207 = _1188;
                }
                do {
                  if (!(_1190 < 0.8029999732971191f)) {
                    float _1210 = _1190 + -0.8029999732971191f;
                    _1222 = ((_1210 / exp2(log2(exp2(log2(_1210 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1222 = _1190;
                  }
                  do {
                    if (!(_1192 < 0.8799999952316284f)) {
                      float _1225 = _1192 + -0.8799999952316284f;
                      _1237 = ((_1225 / exp2(log2(exp2(log2(_1225 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1237 = _1192;
                    }
                    _1245 = (_1177 - (_1187 * _1207));
                    _1246 = (_1177 - (_1187 * _1222));
                    _1247 = (_1177 - (_1187 * _1237));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1245 = _1169;
              _1246 = _1172;
              _1247 = _1175;
            }
          } else {
            _1245 = _1169;
            _1246 = _1172;
            _1247 = _1175;
          }
          float _1263 = ((mad(0.16386906802654266f, _1247, mad(0.14067870378494263f, _1246, (_1245 * 0.6954522132873535f))) - _1160) * ACESGamutCompression) + _1160;
          float _1264 = ((mad(0.0955343171954155f, _1247, mad(0.8596711158752441f, _1246, (_1245 * 0.044794563204050064f))) - _1163) * ACESGamutCompression) + _1163;
          float _1265 = ((mad(1.0015007257461548f, _1247, mad(0.004025210160762072f, _1246, (_1245 * -0.005525882821530104f))) - _1166) * ACESGamutCompression) + _1166;
          float _1269 = max(max(_1263, _1264), _1265);
          float _1274 = (max(_1269, 1.000000013351432e-10f) - max(min(min(_1263, _1264), _1265), 1.000000013351432e-10f)) / max(_1269, 0.009999999776482582f);
          float _1287 = ((_1264 + _1263) + _1265) + (sqrt((((_1265 - _1264) * _1265) + ((_1264 - _1263) * _1264)) + ((_1263 - _1265) * _1263)) * 1.75f);
          float _1288 = _1287 * 0.3333333432674408f;
          float _1289 = _1274 + -0.4000000059604645f;
          float _1290 = _1289 * 5.0f;
          float _1294 = max((1.0f - abs(_1289 * 2.5f)), 0.0f);
          float _1305 = ((float(((int)(uint)((bool)(_1290 > 0.0f))) - ((int)(uint)((bool)(_1290 < 0.0f)))) * (1.0f - (_1294 * _1294))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1288 <= 0.0533333346247673f)) {
              if (!(_1288 >= 0.1599999964237213f)) {
                _1314 = (((0.23999999463558197f / _1287) + -0.5f) * _1305);
              } else {
                _1314 = 0.0f;
              }
            } else {
              _1314 = _1305;
            }
            float _1315 = _1314 + 1.0f;
            float _1316 = _1315 * _1263;
            float _1317 = _1315 * _1264;
            float _1318 = _1315 * _1265;
            do {
              if (!((bool)(_1316 == _1317) && (bool)(_1317 == _1318))) {
                float _1325 = ((_1316 * 2.0f) - _1317) - _1318;
                float _1328 = ((_1264 - _1265) * 1.7320507764816284f) * _1315;
                float _1330 = atan(_1328 / _1325);
                bool _1333 = (_1325 < 0.0f);
                bool _1334 = (_1325 == 0.0f);
                bool _1335 = (_1328 >= 0.0f);
                bool _1336 = (_1328 < 0.0f);
                _1347 = select((_1335 && _1334), 90.0f, select((_1336 && _1334), -90.0f, (select((_1336 && _1333), (_1330 + -3.1415927410125732f), select((_1335 && _1333), (_1330 + 3.1415927410125732f), _1330)) * 57.2957763671875f)));
              } else {
                _1347 = 0.0f;
              }
              float _1352 = min(max(select((_1347 < 0.0f), (_1347 + 360.0f), _1347), 0.0f), 360.0f);
              do {
                if (_1352 < -180.0f) {
                  _1361 = (_1352 + 360.0f);
                } else {
                  if (_1352 > 180.0f) {
                    _1361 = (_1352 + -360.0f);
                  } else {
                    _1361 = _1352;
                  }
                }
                do {
                  if ((bool)(_1361 > -67.5f) && (bool)(_1361 < 67.5f)) {
                    float _1367 = (_1361 + 67.5f) * 0.029629629105329514f;
                    int _1368 = int(_1367);
                    float _1370 = _1367 - float(_1368);
                    float _1371 = _1370 * _1370;
                    float _1372 = _1371 * _1370;
                    if (_1368 == 3) {
                      _1400 = (((0.1666666716337204f - (_1370 * 0.5f)) + (_1371 * 0.5f)) - (_1372 * 0.1666666716337204f));
                    } else {
                      if (_1368 == 2) {
                        _1400 = ((0.6666666865348816f - _1371) + (_1372 * 0.5f));
                      } else {
                        if (_1368 == 1) {
                          _1400 = (((_1372 * -0.5f) + 0.1666666716337204f) + ((_1371 + _1370) * 0.5f));
                        } else {
                          _1400 = select((_1368 == 0), (_1372 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1400 = 0.0f;
                  }
                  float _1409 = min(max(((((_1274 * 0.27000001072883606f) * (0.029999999329447746f - _1316)) * _1400) + _1316), 0.0f), 65535.0f);
                  float _1410 = min(max(_1317, 0.0f), 65535.0f);
                  float _1411 = min(max(_1318, 0.0f), 65535.0f);
                  float _1424 = min(max(mad(-0.21492856740951538f, _1411, mad(-0.2365107536315918f, _1410, (_1409 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1425 = min(max(mad(-0.09967592358589172f, _1411, mad(1.17622971534729f, _1410, (_1409 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1426 = min(max(mad(0.9977163076400757f, _1411, mad(-0.006032449658960104f, _1410, (_1409 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1427 = dot(float3(_1424, _1425, _1426), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1438 = log2(max((lerp(_1427, _1424, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1439 = _1438 * 0.3010300099849701f;
                  float _1440 = log2(ACESMinMaxData.x);
                  float _1441 = _1440 * 0.3010300099849701f;
                  do {
                    if (!(!(_1439 <= _1441))) {
                      _1510 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1448 = log2(ACESMidData.x);
                      float _1449 = _1448 * 0.3010300099849701f;
                      if ((bool)(_1439 > _1441) && (bool)(_1439 < _1449)) {
                        float _1457 = ((_1438 - _1440) * 0.9030900001525879f) / ((_1448 - _1440) * 0.3010300099849701f);
                        int _1458 = int(_1457);
                        float _1460 = _1457 - float(_1458);
                        float _1462 = _10[_1458];
                        float _1465 = _10[(_1458 + 1)];
                        float _1470 = _1462 * 0.5f;
                        _1510 = dot(float3((_1460 * _1460), _1460, 1.0f), float3(mad((_10[(_1458 + 2)]), 0.5f, mad(_1465, -1.0f, _1470)), (_1465 - _1462), mad(_1465, 0.5f, _1470)));
                      } else {
                        do {
                          if (!(!(_1439 >= _1449))) {
                            float _1479 = log2(ACESMinMaxData.z);
                            if (_1439 < (_1479 * 0.3010300099849701f)) {
                              float _1487 = ((_1438 - _1448) * 0.9030900001525879f) / ((_1479 - _1448) * 0.3010300099849701f);
                              int _1488 = int(_1487);
                              float _1490 = _1487 - float(_1488);
                              float _1492 = _11[_1488];
                              float _1495 = _11[(_1488 + 1)];
                              float _1500 = _1492 * 0.5f;
                              _1510 = dot(float3((_1490 * _1490), _1490, 1.0f), float3(mad((_11[(_1488 + 2)]), 0.5f, mad(_1495, -1.0f, _1500)), (_1495 - _1492), mad(_1495, 0.5f, _1500)));
                              break;
                            }
                          }
                          _1510 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1514 = log2(max((lerp(_1427, _1425, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1515 = _1514 * 0.3010300099849701f;
                    do {
                      if (!(!(_1515 <= _1441))) {
                        _1584 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1522 = log2(ACESMidData.x);
                        float _1523 = _1522 * 0.3010300099849701f;
                        if ((bool)(_1515 > _1441) && (bool)(_1515 < _1523)) {
                          float _1531 = ((_1514 - _1440) * 0.9030900001525879f) / ((_1522 - _1440) * 0.3010300099849701f);
                          int _1532 = int(_1531);
                          float _1534 = _1531 - float(_1532);
                          float _1536 = _10[_1532];
                          float _1539 = _10[(_1532 + 1)];
                          float _1544 = _1536 * 0.5f;
                          _1584 = dot(float3((_1534 * _1534), _1534, 1.0f), float3(mad((_10[(_1532 + 2)]), 0.5f, mad(_1539, -1.0f, _1544)), (_1539 - _1536), mad(_1539, 0.5f, _1544)));
                        } else {
                          do {
                            if (!(!(_1515 >= _1523))) {
                              float _1553 = log2(ACESMinMaxData.z);
                              if (_1515 < (_1553 * 0.3010300099849701f)) {
                                float _1561 = ((_1514 - _1522) * 0.9030900001525879f) / ((_1553 - _1522) * 0.3010300099849701f);
                                int _1562 = int(_1561);
                                float _1564 = _1561 - float(_1562);
                                float _1566 = _11[_1562];
                                float _1569 = _11[(_1562 + 1)];
                                float _1574 = _1566 * 0.5f;
                                _1584 = dot(float3((_1564 * _1564), _1564, 1.0f), float3(mad((_11[(_1562 + 2)]), 0.5f, mad(_1569, -1.0f, _1574)), (_1569 - _1566), mad(_1569, 0.5f, _1574)));
                                break;
                              }
                            }
                            _1584 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1588 = log2(max((lerp(_1427, _1426, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1589 = _1588 * 0.3010300099849701f;
                      do {
                        if (!(!(_1589 <= _1441))) {
                          _1658 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1596 = log2(ACESMidData.x);
                          float _1597 = _1596 * 0.3010300099849701f;
                          if ((bool)(_1589 > _1441) && (bool)(_1589 < _1597)) {
                            float _1605 = ((_1588 - _1440) * 0.9030900001525879f) / ((_1596 - _1440) * 0.3010300099849701f);
                            int _1606 = int(_1605);
                            float _1608 = _1605 - float(_1606);
                            float _1610 = _10[_1606];
                            float _1613 = _10[(_1606 + 1)];
                            float _1618 = _1610 * 0.5f;
                            _1658 = dot(float3((_1608 * _1608), _1608, 1.0f), float3(mad((_10[(_1606 + 2)]), 0.5f, mad(_1613, -1.0f, _1618)), (_1613 - _1610), mad(_1613, 0.5f, _1618)));
                          } else {
                            do {
                              if (!(!(_1589 >= _1597))) {
                                float _1627 = log2(ACESMinMaxData.z);
                                if (_1589 < (_1627 * 0.3010300099849701f)) {
                                  float _1635 = ((_1588 - _1596) * 0.9030900001525879f) / ((_1627 - _1596) * 0.3010300099849701f);
                                  int _1636 = int(_1635);
                                  float _1638 = _1635 - float(_1636);
                                  float _1640 = _11[_1636];
                                  float _1643 = _11[(_1636 + 1)];
                                  float _1648 = _1640 * 0.5f;
                                  _1658 = dot(float3((_1638 * _1638), _1638, 1.0f), float3(mad((_11[(_1636 + 2)]), 0.5f, mad(_1643, -1.0f, _1648)), (_1643 - _1640), mad(_1643, 0.5f, _1648)));
                                  break;
                                }
                              }
                              _1658 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1662 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1663 = (exp2(_1510 * 3.321928024291992f) - ACESMinMaxData.y) / _1662;
                        float _1665 = (exp2(_1584 * 3.321928024291992f) - ACESMinMaxData.y) / _1662;
                        float _1667 = (exp2(_1658 * 3.321928024291992f) - ACESMinMaxData.y) / _1662;
                        float _1670 = mad(0.15618768334388733f, _1667, mad(0.13400420546531677f, _1665, (_1663 * 0.6624541878700256f)));
                        float _1673 = mad(0.053689517080783844f, _1667, mad(0.6740817427635193f, _1665, (_1663 * 0.2722287178039551f)));
                        float _1676 = mad(1.0103391408920288f, _1667, mad(0.00406073359772563f, _1665, (_1663 * -0.005574649665504694f)));
                        float _1689 = min(max(mad(-0.23642469942569733f, _1676, mad(-0.32480329275131226f, _1673, (_1670 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1690 = min(max(mad(0.016756348311901093f, _1676, mad(1.6153316497802734f, _1673, (_1670 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1691 = min(max(mad(0.9883948564529419f, _1676, mad(-0.008284442126750946f, _1673, (_1670 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1694 = mad(0.15618768334388733f, _1691, mad(0.13400420546531677f, _1690, (_1689 * 0.6624541878700256f)));
                        float _1697 = mad(0.053689517080783844f, _1691, mad(0.6740817427635193f, _1690, (_1689 * 0.2722287178039551f)));
                        float _1700 = mad(1.0103391408920288f, _1691, mad(0.00406073359772563f, _1690, (_1689 * -0.005574649665504694f)));
                        float _1722 = min(max((min(max(mad(-0.23642469942569733f, _1700, mad(-0.32480329275131226f, _1697, (_1694 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1723 = min(max((min(max(mad(0.016756348311901093f, _1700, mad(1.6153316497802734f, _1697, (_1694 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1724 = min(max((min(max(mad(0.9883948564529419f, _1700, mad(-0.008284442126750946f, _1697, (_1694 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 5)) {
                            _1737 = mad(_45, _1724, mad(_44, _1723, (_1722 * _43)));
                            _1738 = mad(_48, _1724, mad(_47, _1723, (_1722 * _46)));
                            _1739 = mad(_51, _1724, mad(_50, _1723, (_1722 * _49)));
                          } else {
                            _1737 = _1722;
                            _1738 = _1723;
                            _1739 = _1724;
                          }
                          float _1749 = exp2(log2(_1737 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1750 = exp2(log2(_1738 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1751 = exp2(log2(_1739 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2590 = exp2(log2((1.0f / ((_1749 * 18.6875f) + 1.0f)) * ((_1749 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2591 = exp2(log2((1.0f / ((_1750 * 18.6875f) + 1.0f)) * ((_1750 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2592 = exp2(log2((1.0f / ((_1751 * 18.6875f) + 1.0f)) * ((_1751 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
        if (((uint)(OutputDevice) & -3) == 4) {
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
          float _1829 = ACESSceneColorMultiplier * _957;
          float _1830 = ACESSceneColorMultiplier * _958;
          float _1831 = ACESSceneColorMultiplier * _959;
          float _1834 = mad((WorkingColorSpace.ToAP0[0].z), _1831, mad((WorkingColorSpace.ToAP0[0].y), _1830, ((WorkingColorSpace.ToAP0[0].x) * _1829)));
          float _1837 = mad((WorkingColorSpace.ToAP0[1].z), _1831, mad((WorkingColorSpace.ToAP0[1].y), _1830, ((WorkingColorSpace.ToAP0[1].x) * _1829)));
          float _1840 = mad((WorkingColorSpace.ToAP0[2].z), _1831, mad((WorkingColorSpace.ToAP0[2].y), _1830, ((WorkingColorSpace.ToAP0[2].x) * _1829)));
          float _1843 = mad(-0.21492856740951538f, _1840, mad(-0.2365107536315918f, _1837, (_1834 * 1.4514392614364624f)));
          float _1846 = mad(-0.09967592358589172f, _1840, mad(1.17622971534729f, _1837, (_1834 * -0.07655377686023712f)));
          float _1849 = mad(0.9977163076400757f, _1840, mad(-0.006032449658960104f, _1837, (_1834 * 0.008316148072481155f)));
          float _1851 = max(_1843, max(_1846, _1849));
          do {
            if (!(_1851 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1834 < 0.0f) || (bool)(_1837 < 0.0f))) || (bool)(_1840 < 0.0f))) {
                float _1861 = abs(_1851);
                float _1862 = (_1851 - _1843) / _1861;
                float _1864 = (_1851 - _1846) / _1861;
                float _1866 = (_1851 - _1849) / _1861;
                do {
                  if (!(_1862 < 0.8149999976158142f)) {
                    float _1869 = _1862 + -0.8149999976158142f;
                    _1881 = ((_1869 / exp2(log2(exp2(log2(_1869 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _1881 = _1862;
                  }
                  do {
                    if (!(_1864 < 0.8029999732971191f)) {
                      float _1884 = _1864 + -0.8029999732971191f;
                      _1896 = ((_1884 / exp2(log2(exp2(log2(_1884 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _1896 = _1864;
                    }
                    do {
                      if (!(_1866 < 0.8799999952316284f)) {
                        float _1899 = _1866 + -0.8799999952316284f;
                        _1911 = ((_1899 / exp2(log2(exp2(log2(_1899 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _1911 = _1866;
                      }
                      _1919 = (_1851 - (_1861 * _1881));
                      _1920 = (_1851 - (_1861 * _1896));
                      _1921 = (_1851 - (_1861 * _1911));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _1919 = _1843;
                _1920 = _1846;
                _1921 = _1849;
              }
            } else {
              _1919 = _1843;
              _1920 = _1846;
              _1921 = _1849;
            }
            float _1937 = ((mad(0.16386906802654266f, _1921, mad(0.14067870378494263f, _1920, (_1919 * 0.6954522132873535f))) - _1834) * ACESGamutCompression) + _1834;
            float _1938 = ((mad(0.0955343171954155f, _1921, mad(0.8596711158752441f, _1920, (_1919 * 0.044794563204050064f))) - _1837) * ACESGamutCompression) + _1837;
            float _1939 = ((mad(1.0015007257461548f, _1921, mad(0.004025210160762072f, _1920, (_1919 * -0.005525882821530104f))) - _1840) * ACESGamutCompression) + _1840;
            float _1943 = max(max(_1937, _1938), _1939);
            float _1948 = (max(_1943, 1.000000013351432e-10f) - max(min(min(_1937, _1938), _1939), 1.000000013351432e-10f)) / max(_1943, 0.009999999776482582f);
            float _1961 = ((_1938 + _1937) + _1939) + (sqrt((((_1939 - _1938) * _1939) + ((_1938 - _1937) * _1938)) + ((_1937 - _1939) * _1937)) * 1.75f);
            float _1962 = _1961 * 0.3333333432674408f;
            float _1963 = _1948 + -0.4000000059604645f;
            float _1964 = _1963 * 5.0f;
            float _1968 = max((1.0f - abs(_1963 * 2.5f)), 0.0f);
            float _1979 = ((float(((int)(uint)((bool)(_1964 > 0.0f))) - ((int)(uint)((bool)(_1964 < 0.0f)))) * (1.0f - (_1968 * _1968))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_1962 <= 0.0533333346247673f)) {
                if (!(_1962 >= 0.1599999964237213f)) {
                  _1988 = (((0.23999999463558197f / _1961) + -0.5f) * _1979);
                } else {
                  _1988 = 0.0f;
                }
              } else {
                _1988 = _1979;
              }
              float _1989 = _1988 + 1.0f;
              float _1990 = _1989 * _1937;
              float _1991 = _1989 * _1938;
              float _1992 = _1989 * _1939;
              do {
                if (!((bool)(_1990 == _1991) && (bool)(_1991 == _1992))) {
                  float _1999 = ((_1990 * 2.0f) - _1991) - _1992;
                  float _2002 = ((_1938 - _1939) * 1.7320507764816284f) * _1989;
                  float _2004 = atan(_2002 / _1999);
                  bool _2007 = (_1999 < 0.0f);
                  bool _2008 = (_1999 == 0.0f);
                  bool _2009 = (_2002 >= 0.0f);
                  bool _2010 = (_2002 < 0.0f);
                  _2021 = select((_2009 && _2008), 90.0f, select((_2010 && _2008), -90.0f, (select((_2010 && _2007), (_2004 + -3.1415927410125732f), select((_2009 && _2007), (_2004 + 3.1415927410125732f), _2004)) * 57.2957763671875f)));
                } else {
                  _2021 = 0.0f;
                }
                float _2026 = min(max(select((_2021 < 0.0f), (_2021 + 360.0f), _2021), 0.0f), 360.0f);
                do {
                  if (_2026 < -180.0f) {
                    _2035 = (_2026 + 360.0f);
                  } else {
                    if (_2026 > 180.0f) {
                      _2035 = (_2026 + -360.0f);
                    } else {
                      _2035 = _2026;
                    }
                  }
                  do {
                    if ((bool)(_2035 > -67.5f) && (bool)(_2035 < 67.5f)) {
                      float _2041 = (_2035 + 67.5f) * 0.029629629105329514f;
                      int _2042 = int(_2041);
                      float _2044 = _2041 - float(_2042);
                      float _2045 = _2044 * _2044;
                      float _2046 = _2045 * _2044;
                      if (_2042 == 3) {
                        _2074 = (((0.1666666716337204f - (_2044 * 0.5f)) + (_2045 * 0.5f)) - (_2046 * 0.1666666716337204f));
                      } else {
                        if (_2042 == 2) {
                          _2074 = ((0.6666666865348816f - _2045) + (_2046 * 0.5f));
                        } else {
                          if (_2042 == 1) {
                            _2074 = (((_2046 * -0.5f) + 0.1666666716337204f) + ((_2045 + _2044) * 0.5f));
                          } else {
                            _2074 = select((_2042 == 0), (_2046 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2074 = 0.0f;
                    }
                    float _2083 = min(max(((((_1948 * 0.27000001072883606f) * (0.029999999329447746f - _1990)) * _2074) + _1990), 0.0f), 65535.0f);
                    float _2084 = min(max(_1991, 0.0f), 65535.0f);
                    float _2085 = min(max(_1992, 0.0f), 65535.0f);
                    float _2098 = min(max(mad(-0.21492856740951538f, _2085, mad(-0.2365107536315918f, _2084, (_2083 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2099 = min(max(mad(-0.09967592358589172f, _2085, mad(1.17622971534729f, _2084, (_2083 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2100 = min(max(mad(0.9977163076400757f, _2085, mad(-0.006032449658960104f, _2084, (_2083 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2101 = dot(float3(_2098, _2099, _2100), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2112 = log2(max((lerp(_2101, _2098, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2113 = _2112 * 0.3010300099849701f;
                    float _2114 = log2(ACESMinMaxData.x);
                    float _2115 = _2114 * 0.3010300099849701f;
                    do {
                      if (!(!(_2113 <= _2115))) {
                        _2184 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2122 = log2(ACESMidData.x);
                        float _2123 = _2122 * 0.3010300099849701f;
                        if ((bool)(_2113 > _2115) && (bool)(_2113 < _2123)) {
                          float _2131 = ((_2112 - _2114) * 0.9030900001525879f) / ((_2122 - _2114) * 0.3010300099849701f);
                          int _2132 = int(_2131);
                          float _2134 = _2131 - float(_2132);
                          float _2136 = _8[_2132];
                          float _2139 = _8[(_2132 + 1)];
                          float _2144 = _2136 * 0.5f;
                          _2184 = dot(float3((_2134 * _2134), _2134, 1.0f), float3(mad((_8[(_2132 + 2)]), 0.5f, mad(_2139, -1.0f, _2144)), (_2139 - _2136), mad(_2139, 0.5f, _2144)));
                        } else {
                          do {
                            if (!(!(_2113 >= _2123))) {
                              float _2153 = log2(ACESMinMaxData.z);
                              if (_2113 < (_2153 * 0.3010300099849701f)) {
                                float _2161 = ((_2112 - _2122) * 0.9030900001525879f) / ((_2153 - _2122) * 0.3010300099849701f);
                                int _2162 = int(_2161);
                                float _2164 = _2161 - float(_2162);
                                float _2166 = _9[_2162];
                                float _2169 = _9[(_2162 + 1)];
                                float _2174 = _2166 * 0.5f;
                                _2184 = dot(float3((_2164 * _2164), _2164, 1.0f), float3(mad((_9[(_2162 + 2)]), 0.5f, mad(_2169, -1.0f, _2174)), (_2169 - _2166), mad(_2169, 0.5f, _2174)));
                                break;
                              }
                            }
                            _2184 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2188 = log2(max((lerp(_2101, _2099, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2189 = _2188 * 0.3010300099849701f;
                      do {
                        if (!(!(_2189 <= _2115))) {
                          _2258 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2196 = log2(ACESMidData.x);
                          float _2197 = _2196 * 0.3010300099849701f;
                          if ((bool)(_2189 > _2115) && (bool)(_2189 < _2197)) {
                            float _2205 = ((_2188 - _2114) * 0.9030900001525879f) / ((_2196 - _2114) * 0.3010300099849701f);
                            int _2206 = int(_2205);
                            float _2208 = _2205 - float(_2206);
                            float _2210 = _8[_2206];
                            float _2213 = _8[(_2206 + 1)];
                            float _2218 = _2210 * 0.5f;
                            _2258 = dot(float3((_2208 * _2208), _2208, 1.0f), float3(mad((_8[(_2206 + 2)]), 0.5f, mad(_2213, -1.0f, _2218)), (_2213 - _2210), mad(_2213, 0.5f, _2218)));
                          } else {
                            do {
                              if (!(!(_2189 >= _2197))) {
                                float _2227 = log2(ACESMinMaxData.z);
                                if (_2189 < (_2227 * 0.3010300099849701f)) {
                                  float _2235 = ((_2188 - _2196) * 0.9030900001525879f) / ((_2227 - _2196) * 0.3010300099849701f);
                                  int _2236 = int(_2235);
                                  float _2238 = _2235 - float(_2236);
                                  float _2240 = _9[_2236];
                                  float _2243 = _9[(_2236 + 1)];
                                  float _2248 = _2240 * 0.5f;
                                  _2258 = dot(float3((_2238 * _2238), _2238, 1.0f), float3(mad((_9[(_2236 + 2)]), 0.5f, mad(_2243, -1.0f, _2248)), (_2243 - _2240), mad(_2243, 0.5f, _2248)));
                                  break;
                                }
                              }
                              _2258 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2262 = log2(max((lerp(_2101, _2100, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2263 = _2262 * 0.3010300099849701f;
                        do {
                          if (!(!(_2263 <= _2115))) {
                            _2332 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2270 = log2(ACESMidData.x);
                            float _2271 = _2270 * 0.3010300099849701f;
                            if ((bool)(_2263 > _2115) && (bool)(_2263 < _2271)) {
                              float _2279 = ((_2262 - _2114) * 0.9030900001525879f) / ((_2270 - _2114) * 0.3010300099849701f);
                              int _2280 = int(_2279);
                              float _2282 = _2279 - float(_2280);
                              float _2284 = _8[_2280];
                              float _2287 = _8[(_2280 + 1)];
                              float _2292 = _2284 * 0.5f;
                              _2332 = dot(float3((_2282 * _2282), _2282, 1.0f), float3(mad((_8[(_2280 + 2)]), 0.5f, mad(_2287, -1.0f, _2292)), (_2287 - _2284), mad(_2287, 0.5f, _2292)));
                            } else {
                              do {
                                if (!(!(_2263 >= _2271))) {
                                  float _2301 = log2(ACESMinMaxData.z);
                                  if (_2263 < (_2301 * 0.3010300099849701f)) {
                                    float _2309 = ((_2262 - _2270) * 0.9030900001525879f) / ((_2301 - _2270) * 0.3010300099849701f);
                                    int _2310 = int(_2309);
                                    float _2312 = _2309 - float(_2310);
                                    float _2314 = _9[_2310];
                                    float _2317 = _9[(_2310 + 1)];
                                    float _2322 = _2314 * 0.5f;
                                    _2332 = dot(float3((_2312 * _2312), _2312, 1.0f), float3(mad((_9[(_2310 + 2)]), 0.5f, mad(_2317, -1.0f, _2322)), (_2317 - _2314), mad(_2317, 0.5f, _2322)));
                                    break;
                                  }
                                }
                                _2332 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2336 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2337 = (exp2(_2184 * 3.321928024291992f) - ACESMinMaxData.y) / _2336;
                          float _2339 = (exp2(_2258 * 3.321928024291992f) - ACESMinMaxData.y) / _2336;
                          float _2341 = (exp2(_2332 * 3.321928024291992f) - ACESMinMaxData.y) / _2336;
                          float _2344 = mad(0.15618768334388733f, _2341, mad(0.13400420546531677f, _2339, (_2337 * 0.6624541878700256f)));
                          float _2347 = mad(0.053689517080783844f, _2341, mad(0.6740817427635193f, _2339, (_2337 * 0.2722287178039551f)));
                          float _2350 = mad(1.0103391408920288f, _2341, mad(0.00406073359772563f, _2339, (_2337 * -0.005574649665504694f)));
                          float _2363 = min(max(mad(-0.23642469942569733f, _2350, mad(-0.32480329275131226f, _2347, (_2344 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2364 = min(max(mad(0.016756348311901093f, _2350, mad(1.6153316497802734f, _2347, (_2344 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2365 = min(max(mad(0.9883948564529419f, _2350, mad(-0.008284442126750946f, _2347, (_2344 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2368 = mad(0.15618768334388733f, _2365, mad(0.13400420546531677f, _2364, (_2363 * 0.6624541878700256f)));
                          float _2371 = mad(0.053689517080783844f, _2365, mad(0.6740817427635193f, _2364, (_2363 * 0.2722287178039551f)));
                          float _2374 = mad(1.0103391408920288f, _2365, mad(0.00406073359772563f, _2364, (_2363 * -0.005574649665504694f)));
                          float _2396 = min(max((min(max(mad(-0.23642469942569733f, _2374, mad(-0.32480329275131226f, _2371, (_2368 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2397 = min(max((min(max(mad(0.016756348311901093f, _2374, mad(1.6153316497802734f, _2371, (_2368 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2398 = min(max((min(max(mad(0.9883948564529419f, _2374, mad(-0.008284442126750946f, _2371, (_2368 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!((uint)(OutputDevice) == 6)) {
                              _2411 = mad(_45, _2398, mad(_44, _2397, (_2396 * _43)));
                              _2412 = mad(_48, _2398, mad(_47, _2397, (_2396 * _46)));
                              _2413 = mad(_51, _2398, mad(_50, _2397, (_2396 * _49)));
                            } else {
                              _2411 = _2396;
                              _2412 = _2397;
                              _2413 = _2398;
                            }
                            float _2423 = exp2(log2(_2411 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2424 = exp2(log2(_2412 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2425 = exp2(log2(_2413 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2590 = exp2(log2((1.0f / ((_2423 * 18.6875f) + 1.0f)) * ((_2423 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2591 = exp2(log2((1.0f / ((_2424 * 18.6875f) + 1.0f)) * ((_2424 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2592 = exp2(log2((1.0f / ((_2425 * 18.6875f) + 1.0f)) * ((_2425 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          if ((uint)(OutputDevice) == 7) {
            float _2470 = mad((WorkingColorSpace.ToAP1[0].z), _959, mad((WorkingColorSpace.ToAP1[0].y), _958, ((WorkingColorSpace.ToAP1[0].x) * _957)));
            float _2473 = mad((WorkingColorSpace.ToAP1[1].z), _959, mad((WorkingColorSpace.ToAP1[1].y), _958, ((WorkingColorSpace.ToAP1[1].x) * _957)));
            float _2476 = mad((WorkingColorSpace.ToAP1[2].z), _959, mad((WorkingColorSpace.ToAP1[2].y), _958, ((WorkingColorSpace.ToAP1[2].x) * _957)));
            float _2495 = exp2(log2(mad(_45, _2476, mad(_44, _2473, (_2470 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2496 = exp2(log2(mad(_48, _2476, mad(_47, _2473, (_2470 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2497 = exp2(log2(mad(_51, _2476, mad(_50, _2473, (_2470 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2590 = exp2(log2((1.0f / ((_2495 * 18.6875f) + 1.0f)) * ((_2495 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2591 = exp2(log2((1.0f / ((_2496 * 18.6875f) + 1.0f)) * ((_2496 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2592 = exp2(log2((1.0f / ((_2497 * 18.6875f) + 1.0f)) * ((_2497 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2544 = mad((WorkingColorSpace.ToAP1[0].z), _947, mad((WorkingColorSpace.ToAP1[0].y), _946, ((WorkingColorSpace.ToAP1[0].x) * _945)));
                float _2547 = mad((WorkingColorSpace.ToAP1[1].z), _947, mad((WorkingColorSpace.ToAP1[1].y), _946, ((WorkingColorSpace.ToAP1[1].x) * _945)));
                float _2550 = mad((WorkingColorSpace.ToAP1[2].z), _947, mad((WorkingColorSpace.ToAP1[2].y), _946, ((WorkingColorSpace.ToAP1[2].x) * _945)));
                _2590 = mad(_45, _2550, mad(_44, _2547, (_2544 * _43)));
                _2591 = mad(_48, _2550, mad(_47, _2547, (_2544 * _46)));
                _2592 = mad(_51, _2550, mad(_50, _2547, (_2544 * _49)));
              } else {
                float _2563 = mad((WorkingColorSpace.ToAP1[0].z), _973, mad((WorkingColorSpace.ToAP1[0].y), _972, ((WorkingColorSpace.ToAP1[0].x) * _971)));
                float _2566 = mad((WorkingColorSpace.ToAP1[1].z), _973, mad((WorkingColorSpace.ToAP1[1].y), _972, ((WorkingColorSpace.ToAP1[1].x) * _971)));
                float _2569 = mad((WorkingColorSpace.ToAP1[2].z), _973, mad((WorkingColorSpace.ToAP1[2].y), _972, ((WorkingColorSpace.ToAP1[2].x) * _971)));
                _2590 = exp2(log2(mad(_45, _2569, mad(_44, _2566, (_2563 * _43)))) * InverseGamma.z);
                _2591 = exp2(log2(mad(_48, _2569, mad(_47, _2566, (_2563 * _46)))) * InverseGamma.z);
                _2592 = exp2(log2(mad(_51, _2569, mad(_50, _2566, (_2563 * _49)))) * InverseGamma.z);
              }
            } else {
              _2590 = _957;
              _2591 = _958;
              _2592 = _959;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2590 * 0.9523810148239136f);
  SV_Target.y = (_2591 * 0.9523810148239136f);
  SV_Target.z = (_2592 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

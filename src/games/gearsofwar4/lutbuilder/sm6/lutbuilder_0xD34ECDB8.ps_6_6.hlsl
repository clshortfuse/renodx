// Found in REANIMAL

#include "../lutbuilderoutput.hlsli"

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};

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

SamplerState Samplers_1 : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
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
  float _21[6];
  float _24 = 0.5f / LUTSize;
  float _29 = LUTSize + -1.0f;
  float _30 = (LUTSize * (TEXCOORD.x - _24)) / _29;
  float _31 = (LUTSize * (TEXCOORD.y - _24)) / _29;
  float _33 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _29;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _119;
  float _120;
  float _121;
  float _644;
  float _677;
  float _691;
  float _755;
  float _934;
  float _945;
  float _956;
  float _1129;
  float _1130;
  float _1131;
  float _1142;
  float _1153;
  float _1326;
  float _1341;
  float _1356;
  float _1364;
  float _1365;
  float _1366;
  float _1433;
  float _1466;
  float _1480;
  float _1519;
  float _1641;
  float _1727;
  float _1801;
  float _1880;
  float _1881;
  float _1882;
  float _2012;
  float _2027;
  float _2042;
  float _2050;
  float _2051;
  float _2052;
  float _2119;
  float _2152;
  float _2166;
  float _2205;
  float _2327;
  float _2413;
  float _2499;
  float _2578;
  float _2579;
  float _2580;
  float _2757;
  float _2758;
  float _2759;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _42 = (OutputGamut == 4);
        _53 = select(_42, 1.0f, 1.705051064491272f);
        _54 = select(_42, 0.0f, -0.6217921376228333f);
        _55 = select(_42, 0.0f, -0.0832589864730835f);
        _56 = select(_42, 0.0f, -0.13025647401809692f);
        _57 = select(_42, 1.0f, 1.140804648399353f);
        _58 = select(_42, 0.0f, -0.010548308491706848f);
        _59 = select(_42, 0.0f, -0.024003351107239723f);
        _60 = select(_42, 0.0f, -0.1289689838886261f);
        _61 = select(_42, 1.0f, 1.1529725790023804f);
      } else {
        _53 = 0.6954522132873535f;
        _54 = 0.14067870378494263f;
        _55 = 0.16386906802654266f;
        _56 = 0.044794563204050064f;
        _57 = 0.8596711158752441f;
        _58 = 0.0955343171954155f;
        _59 = -0.005525882821530104f;
        _60 = 0.004025210160762072f;
        _61 = 1.0015007257461548f;
      }
    } else {
      _53 = 1.0258246660232544f;
      _54 = -0.020053181797266006f;
      _55 = -0.005771636962890625f;
      _56 = -0.002234415616840124f;
      _57 = 1.0045864582061768f;
      _58 = -0.002352118492126465f;
      _59 = -0.005013350863009691f;
      _60 = -0.025290070101618767f;
      _61 = 1.0303035974502563f;
    }
  } else {
    _53 = 1.3792141675949097f;
    _54 = -0.30886411666870117f;
    _55 = -0.0703500509262085f;
    _56 = -0.06933490186929703f;
    _57 = 1.08229660987854f;
    _58 = -0.012961871922016144f;
    _59 = -0.0021590073592960835f;
    _60 = -0.0454593189060688f;
    _61 = 1.0476183891296387f;
  }
  if ((uint)OutputDevice > (uint)2) {
    float _72 = (pow(_30, 0.012683313339948654f));
    float _73 = (pow(_31, 0.012683313339948654f));
    float _74 = (pow(_33, 0.012683313339948654f));
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _119 = ((exp2((_30 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _120 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _121 = ((exp2((_33 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _136 = mad((WorkingColorSpace.ToAP1[0].z), _121, mad((WorkingColorSpace.ToAP1[0].y), _120, ((WorkingColorSpace.ToAP1[0].x) * _119)));
  float _139 = mad((WorkingColorSpace.ToAP1[1].z), _121, mad((WorkingColorSpace.ToAP1[1].y), _120, ((WorkingColorSpace.ToAP1[1].x) * _119)));
  float _142 = mad((WorkingColorSpace.ToAP1[2].z), _121, mad((WorkingColorSpace.ToAP1[2].y), _120, ((WorkingColorSpace.ToAP1[2].x) * _119)));
  float _143 = dot(float3(_136, _139, _142), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _147 = (_136 / _143) + -1.0f;
  float _148 = (_139 / _143) + -1.0f;
  float _149 = (_142 / _143) + -1.0f;
  // float _161 = (1.0f - exp2(((_143 * _143) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_147, _148, _149), float3(_147, _148, _149)) * -4.0f));
  float _161 = (1.0f - exp2(((_143 * _143) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_147, _148, _149), float3(_147, _148, _149)) * -4.0f));

  float _177 = ((mad(-0.06368321925401688f, _142, mad(-0.3292922377586365f, _139, (_136 * 1.3704125881195068f))) - _136) * _161) + _136;
  float _178 = ((mad(-0.010861365124583244f, _142, mad(1.0970927476882935f, _139, (_136 * -0.08343357592821121f))) - _139) * _161) + _139;
  float _179 = ((mad(1.2036951780319214f, _142, mad(-0.09862580895423889f, _139, (_136 * -0.02579331398010254f))) - _142) * _161) + _142;
  float _180 = dot(float3(_177, _178, _179), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _194 = ColorOffset.w + ColorOffsetShadows.w;
  float _208 = ColorGain.w * ColorGainShadows.w;
  float _222 = ColorGamma.w * ColorGammaShadows.w;
  float _236 = ColorContrast.w * ColorContrastShadows.w;
  float _250 = ColorSaturation.w * ColorSaturationShadows.w;
  float _254 = _177 - _180;
  float _255 = _178 - _180;
  float _256 = _179 - _180;
  float _313 = saturate(_180 / ColorCorrectionShadowsMax);
  float _317 = (_313 * _313) * (3.0f - (_313 * 2.0f));
  float _318 = 1.0f - _317;
  float _327 = ColorOffset.w + ColorOffsetHighlights.w;
  float _336 = ColorGain.w * ColorGainHighlights.w;
  float _345 = ColorGamma.w * ColorGammaHighlights.w;
  float _354 = ColorContrast.w * ColorContrastHighlights.w;
  float _363 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _426 = saturate((_180 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _430 = (_426 * _426) * (3.0f - (_426 * 2.0f));
  float _439 = ColorOffset.w + ColorOffsetMidtones.w;
  float _448 = ColorGain.w * ColorGainMidtones.w;
  float _457 = ColorGamma.w * ColorGammaMidtones.w;
  float _466 = ColorContrast.w * ColorContrastMidtones.w;
  float _475 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _533 = _317 - _430;
  float _544 = ((_430 * (((ColorOffset.x + ColorOffsetHighlights.x) + _327) + (((ColorGain.x * ColorGainHighlights.x) * _336) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _354) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _363) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _345)))))) + (_318 * (((ColorOffset.x + ColorOffsetShadows.x) + _194) + (((ColorGain.x * ColorGainShadows.x) * _208) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _236) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _250) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _222))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _439) + (((ColorGain.x * ColorGainMidtones.x) * _448) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _466) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _475) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _457))))) * _533);
  float _546 = ((_430 * (((ColorOffset.y + ColorOffsetHighlights.y) + _327) + (((ColorGain.y * ColorGainHighlights.y) * _336) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _354) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _363) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _345)))))) + (_318 * (((ColorOffset.y + ColorOffsetShadows.y) + _194) + (((ColorGain.y * ColorGainShadows.y) * _208) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _236) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _250) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _222))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _439) + (((ColorGain.y * ColorGainMidtones.y) * _448) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _466) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _475) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _457))))) * _533);
  float _548 = ((_430 * (((ColorOffset.z + ColorOffsetHighlights.z) + _327) + (((ColorGain.z * ColorGainHighlights.z) * _336) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _354) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _363) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _345)))))) + (_318 * (((ColorOffset.z + ColorOffsetShadows.z) + _194) + (((ColorGain.z * ColorGainShadows.z) * _208) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _236) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _250) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _222))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _439) + (((ColorGain.z * ColorGainMidtones.z) * _448) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _466) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _475) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _457))))) * _533);

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
  cb_config.ue_lutweights = LUTWeights;

  SV_Target = ProcessLutbuilder(float3(_544, _546, _548), Samplers_1, Textures_1, cb_config, SV_Target, OutputDevice);
  return SV_Target;

  float _584 = ((mad(0.061360642313957214f, _548, mad(-4.540197551250458e-09f, _546, (_544 * 0.9386394023895264f))) - _544) * BlueCorrection) + _544;
  float _585 = ((mad(0.169205904006958f, _548, mad(0.8307942152023315f, _546, (_544 * 6.775371730327606e-08f))) - _546) * BlueCorrection) + _546;
  float _586 = (mad(-2.3283064365386963e-10f, _546, (_544 * -9.313225746154785e-10f)) * BlueCorrection) + _548;
  float _589 = mad(0.16386905312538147f, _586, mad(0.14067868888378143f, _585, (_584 * 0.6954522132873535f)));
  float _592 = mad(0.0955343246459961f, _586, mad(0.8596711158752441f, _585, (_584 * 0.044794581830501556f)));
  float _595 = mad(1.0015007257461548f, _586, mad(0.004025210160762072f, _585, (_584 * -0.005525882821530104f)));
  float _599 = max(max(_589, _592), _595);
  float _604 = (max(_599, 1.000000013351432e-10f) - max(min(min(_589, _592), _595), 1.000000013351432e-10f)) / max(_599, 0.009999999776482582f);
  float _617 = ((_592 + _589) + _595) + (sqrt((((_595 - _592) * _595) + ((_592 - _589) * _592)) + ((_589 - _595) * _589)) * 1.75f);
  float _618 = _617 * 0.3333333432674408f;
  float _619 = _604 + -0.4000000059604645f;
  float _620 = _619 * 5.0f;
  float _624 = max((1.0f - abs(_619 * 2.5f)), 0.0f);
  float _635 = ((float((int)(((int)(uint)((bool)(_620 > 0.0f))) - ((int)(uint)((bool)(_620 < 0.0f))))) * (1.0f - (_624 * _624))) + 1.0f) * 0.02500000037252903f;
  if (!(_618 <= 0.0533333346247673f)) {
    if (!(_618 >= 0.1599999964237213f)) {
      _644 = (((0.23999999463558197f / _617) + -0.5f) * _635);
    } else {
      _644 = 0.0f;
    }
  } else {
    _644 = _635;
  }
  float _645 = _644 + 1.0f;
  float _646 = _645 * _589;
  float _647 = _645 * _592;
  float _648 = _645 * _595;
  if (!((bool)(_646 == _647) && (bool)(_647 == _648))) {
    float _655 = ((_646 * 2.0f) - _647) - _648;
    float _658 = ((_592 - _595) * 1.7320507764816284f) * _645;
    float _660 = atan(_658 / _655);
    bool _663 = (_655 < 0.0f);
    bool _664 = (_655 == 0.0f);
    bool _665 = (_658 >= 0.0f);
    bool _666 = (_658 < 0.0f);
    _677 = select((_665 && _664), 90.0f, select((_666 && _664), -90.0f, (select((_666 && _663), (_660 + -3.1415927410125732f), select((_665 && _663), (_660 + 3.1415927410125732f), _660)) * 57.2957763671875f)));
  } else {
    _677 = 0.0f;
  }
  float _682 = min(max(select((_677 < 0.0f), (_677 + 360.0f), _677), 0.0f), 360.0f);
  if (_682 < -180.0f) {
    _691 = (_682 + 360.0f);
  } else {
    if (_682 > 180.0f) {
      _691 = (_682 + -360.0f);
    } else {
      _691 = _682;
    }
  }
  float _695 = saturate(1.0f - abs(_691 * 0.014814814552664757f));
  float _699 = (_695 * _695) * (3.0f - (_695 * 2.0f));
  float _705 = ((_699 * _699) * ((_604 * 0.18000000715255737f) * (0.029999999329447746f - _646))) + _646;
  float _715 = max(0.0f, mad(-0.21492856740951538f, _648, mad(-0.2365107536315918f, _647, (_705 * 1.4514392614364624f))));
  float _716 = max(0.0f, mad(-0.09967592358589172f, _648, mad(1.17622971534729f, _647, (_705 * -0.07655377686023712f))));
  float _717 = max(0.0f, mad(0.9977163076400757f, _648, mad(-0.006032449658960104f, _647, (_705 * 0.008316148072481155f))));
  float _718 = dot(float3(_715, _716, _717), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _733 = (FilmBlackClip + 1.0f) - FilmToe;
  float _735 = FilmWhiteClip + 1.0f;
  float _737 = _735 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _755 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _746 = (FilmBlackClip + 0.18000000715255737f) / _733;
    _755 = (-0.7447274923324585f - ((log2(_746 / (2.0f - _746)) * 0.3465735912322998f) * (_733 / FilmSlope)));
  }
  float _758 = ((1.0f - FilmToe) / FilmSlope) - _755;
  float _760 = (FilmShoulder / FilmSlope) - _758;
  float _764 = log2(lerp(_718, _715, 0.9599999785423279f)) * 0.3010300099849701f;
  float _765 = log2(lerp(_718, _716, 0.9599999785423279f)) * 0.3010300099849701f;
  float _766 = log2(lerp(_718, _717, 0.9599999785423279f)) * 0.3010300099849701f;
  float _770 = FilmSlope * (_764 + _758);
  float _771 = FilmSlope * (_765 + _758);
  float _772 = FilmSlope * (_766 + _758);
  float _773 = _733 * 2.0f;
  float _775 = (FilmSlope * -2.0f) / _733;
  float _776 = _764 - _755;
  float _777 = _765 - _755;
  float _778 = _766 - _755;
  float _797 = _737 * 2.0f;
  float _799 = (FilmSlope * 2.0f) / _737;
  float _824 = select((_764 < _755), ((_773 / (exp2((_776 * 1.4426950216293335f) * _775) + 1.0f)) - FilmBlackClip), _770);
  float _825 = select((_765 < _755), ((_773 / (exp2((_777 * 1.4426950216293335f) * _775) + 1.0f)) - FilmBlackClip), _771);
  float _826 = select((_766 < _755), ((_773 / (exp2((_778 * 1.4426950216293335f) * _775) + 1.0f)) - FilmBlackClip), _772);
  float _833 = _760 - _755;
  float _837 = saturate(_776 / _833);
  float _838 = saturate(_777 / _833);
  float _839 = saturate(_778 / _833);
  bool _840 = (_760 < _755);
  float _844 = select(_840, (1.0f - _837), _837);
  float _845 = select(_840, (1.0f - _838), _838);
  float _846 = select(_840, (1.0f - _839), _839);
  float _865 = (((_844 * _844) * (select((_764 > _760), (_735 - (_797 / (exp2(((_764 - _760) * 1.4426950216293335f) * _799) + 1.0f))), _770) - _824)) * (3.0f - (_844 * 2.0f))) + _824;
  float _866 = (((_845 * _845) * (select((_765 > _760), (_735 - (_797 / (exp2(((_765 - _760) * 1.4426950216293335f) * _799) + 1.0f))), _771) - _825)) * (3.0f - (_845 * 2.0f))) + _825;
  float _867 = (((_846 * _846) * (select((_766 > _760), (_735 - (_797 / (exp2(((_766 - _760) * 1.4426950216293335f) * _799) + 1.0f))), _772) - _826)) * (3.0f - (_846 * 2.0f))) + _826;
  float _868 = dot(float3(_865, _866, _867), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _888 = (ToneCurveAmount * (max(0.0f, (lerp(_868, _865, 0.9300000071525574f))) - _584)) + _584;
  float _889 = (ToneCurveAmount * (max(0.0f, (lerp(_868, _866, 0.9300000071525574f))) - _585)) + _585;
  float _890 = (ToneCurveAmount * (max(0.0f, (lerp(_868, _867, 0.9300000071525574f))) - _586)) + _586;
  float _906 = ((mad(-0.06537103652954102f, _890, mad(1.451815478503704e-06f, _889, (_888 * 1.065374732017517f))) - _888) * BlueCorrection) + _888;
  float _907 = ((mad(-0.20366770029067993f, _890, mad(1.2036634683609009f, _889, (_888 * -2.57161445915699e-07f))) - _889) * BlueCorrection) + _889;
  float _908 = ((mad(0.9999996423721313f, _890, mad(2.0954757928848267e-08f, _889, (_888 * 1.862645149230957e-08f))) - _890) * BlueCorrection) + _890;
  float _921 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[0].z), _908, mad((WorkingColorSpace.FromAP1[0].y), _907, ((WorkingColorSpace.FromAP1[0].x) * _906)))));
  float _922 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[1].z), _908, mad((WorkingColorSpace.FromAP1[1].y), _907, ((WorkingColorSpace.FromAP1[1].x) * _906)))));
  float _923 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[2].z), _908, mad((WorkingColorSpace.FromAP1[2].y), _907, ((WorkingColorSpace.FromAP1[2].x) * _906)))));
  if (_921 < 0.0031306699384003878f) {
    _934 = (_921 * 12.920000076293945f);
  } else {
    _934 = (((pow(_921, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_922 < 0.0031306699384003878f) {
    _945 = (_922 * 12.920000076293945f);
  } else {
    _945 = (((pow(_922, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_923 < 0.0031306699384003878f) {
    _956 = (_923 * 12.920000076293945f);
  } else {
    _956 = (((pow(_923, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _960 = (_945 * 0.9375f) + 0.03125f;
  float _967 = _956 * 15.0f;
  float _968 = floor(_967);
  float _969 = _967 - _968;
  float _971 = (((_934 * 0.9375f) + 0.03125f) + _968) * 0.0625f;
  float4 _974 = Textures_1.Sample(Samplers_1, float2(_971, _960));
  float4 _981 = Textures_1.Sample(Samplers_1, float2((_971 + 0.0625f), _960));
  float _1000 = max(6.103519990574569e-05f, (((lerp(_974.x, _981.x, _969)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _934)));
  float _1001 = max(6.103519990574569e-05f, (((lerp(_974.y, _981.y, _969)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _945)));
  float _1002 = max(6.103519990574569e-05f, (((lerp(_974.z, _981.z, _969)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _956)));
  float _1024 = select((_1000 > 0.040449999272823334f), exp2(log2((_1000 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1000 * 0.07739938050508499f));
  float _1025 = select((_1001 > 0.040449999272823334f), exp2(log2((_1001 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1001 * 0.07739938050508499f));
  float _1026 = select((_1002 > 0.040449999272823334f), exp2(log2((_1002 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1002 * 0.07739938050508499f));
  float _1052 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1024)) * _1024) + MappingPolynomial.z);
  float _1053 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1025)) * _1025) + MappingPolynomial.z);
  float _1054 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1026)) * _1026) + MappingPolynomial.z);
  float _1061 = ((OverlayColor.x - _1052) * OverlayColor.w) + _1052;
  float _1062 = ((OverlayColor.y - _1053) * OverlayColor.w) + _1053;
  float _1063 = ((OverlayColor.z - _1054) * OverlayColor.w) + _1054;
  float _1064 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _548, mad((WorkingColorSpace.FromAP1[0].y), _546, (_544 * (WorkingColorSpace.FromAP1[0].x))));
  float _1065 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _548, mad((WorkingColorSpace.FromAP1[1].y), _546, ((WorkingColorSpace.FromAP1[1].x) * _544)));
  float _1066 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _548, mad((WorkingColorSpace.FromAP1[2].y), _546, ((WorkingColorSpace.FromAP1[2].x) * _544)));
  float _1073 = ((OverlayColor.x - _1064) * OverlayColor.w) + _1064;
  float _1074 = ((OverlayColor.y - _1065) * OverlayColor.w) + _1065;
  float _1075 = ((OverlayColor.z - _1066) * OverlayColor.w) + _1066;
  float _1087 = exp2(log2(max(0.0f, _1061)) * InverseGamma.y);
  float _1088 = exp2(log2(max(0.0f, _1062)) * InverseGamma.y);
  float _1089 = exp2(log2(max(0.0f, _1063)) * InverseGamma.y);
  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace.bIsSRGB == 0) {
        float _1112 = mad((WorkingColorSpace.ToAP1[0].z), _1089, mad((WorkingColorSpace.ToAP1[0].y), _1088, ((WorkingColorSpace.ToAP1[0].x) * _1087)));
        float _1115 = mad((WorkingColorSpace.ToAP1[1].z), _1089, mad((WorkingColorSpace.ToAP1[1].y), _1088, ((WorkingColorSpace.ToAP1[1].x) * _1087)));
        float _1118 = mad((WorkingColorSpace.ToAP1[2].z), _1089, mad((WorkingColorSpace.ToAP1[2].y), _1088, ((WorkingColorSpace.ToAP1[2].x) * _1087)));
        _1129 = mad(_55, _1118, mad(_54, _1115, (_1112 * _53)));
        _1130 = mad(_58, _1118, mad(_57, _1115, (_1112 * _56)));
        _1131 = mad(_61, _1118, mad(_60, _1115, (_1112 * _59)));
      } else {
        _1129 = _1087;
        _1130 = _1088;
        _1131 = _1089;
      }
      do {
        if (_1129 < 0.0031306699384003878f) {
          _1142 = (_1129 * 12.920000076293945f);
        } else {
          _1142 = (((pow(_1129, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1130 < 0.0031306699384003878f) {
            _1153 = (_1130 * 12.920000076293945f);
          } else {
            _1153 = (((pow(_1130, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1131 < 0.0031306699384003878f) {
            _2757 = _1142;
            _2758 = _1153;
            _2759 = (_1131 * 12.920000076293945f);
          } else {
            _2757 = _1142;
            _2758 = _1153;
            _2759 = (((pow(_1131, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1180 = mad((WorkingColorSpace.ToAP1[0].z), _1089, mad((WorkingColorSpace.ToAP1[0].y), _1088, ((WorkingColorSpace.ToAP1[0].x) * _1087)));
      float _1183 = mad((WorkingColorSpace.ToAP1[1].z), _1089, mad((WorkingColorSpace.ToAP1[1].y), _1088, ((WorkingColorSpace.ToAP1[1].x) * _1087)));
      float _1186 = mad((WorkingColorSpace.ToAP1[2].z), _1089, mad((WorkingColorSpace.ToAP1[2].y), _1088, ((WorkingColorSpace.ToAP1[2].x) * _1087)));
      float _1196 = max(6.103519990574569e-05f, mad(_55, _1186, mad(_54, _1183, (_1180 * _53))));
      float _1197 = max(6.103519990574569e-05f, mad(_58, _1186, mad(_57, _1183, (_1180 * _56))));
      float _1198 = max(6.103519990574569e-05f, mad(_61, _1186, mad(_60, _1183, (_1180 * _59))));
      _2757 = min((_1196 * 4.5f), ((exp2(log2(max(_1196, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2758 = min((_1197 * 4.5f), ((exp2(log2(max(_1197, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2759 = min((_1198 * 4.5f), ((exp2(log2(max(_1198, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1274 = ACESSceneColorMultiplier * _1073;
        float _1275 = ACESSceneColorMultiplier * _1074;
        float _1276 = ACESSceneColorMultiplier * _1075;
        float _1279 = mad((WorkingColorSpace.ToAP0[0].z), _1276, mad((WorkingColorSpace.ToAP0[0].y), _1275, ((WorkingColorSpace.ToAP0[0].x) * _1274)));
        float _1282 = mad((WorkingColorSpace.ToAP0[1].z), _1276, mad((WorkingColorSpace.ToAP0[1].y), _1275, ((WorkingColorSpace.ToAP0[1].x) * _1274)));
        float _1285 = mad((WorkingColorSpace.ToAP0[2].z), _1276, mad((WorkingColorSpace.ToAP0[2].y), _1275, ((WorkingColorSpace.ToAP0[2].x) * _1274)));
        float _1288 = mad(-0.21492856740951538f, _1285, mad(-0.2365107536315918f, _1282, (_1279 * 1.4514392614364624f)));
        float _1291 = mad(-0.09967592358589172f, _1285, mad(1.17622971534729f, _1282, (_1279 * -0.07655377686023712f)));
        float _1294 = mad(0.9977163076400757f, _1285, mad(-0.006032449658960104f, _1282, (_1279 * 0.008316148072481155f)));
        float _1296 = max(_1288, max(_1291, _1294));
        do {
          if (!(_1296 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1279 < 0.0f) || (bool)(_1282 < 0.0f))) || (bool)(_1285 < 0.0f))) {
              float _1306 = abs(_1296);
              float _1307 = (_1296 - _1288) / _1306;
              float _1309 = (_1296 - _1291) / _1306;
              float _1311 = (_1296 - _1294) / _1306;
              do {
                if (!(_1307 < 0.8149999976158142f)) {
                  float _1314 = _1307 + -0.8149999976158142f;
                  _1326 = ((_1314 / exp2(log2(exp2(log2(_1314 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1326 = _1307;
                }
                do {
                  if (!(_1309 < 0.8029999732971191f)) {
                    float _1329 = _1309 + -0.8029999732971191f;
                    _1341 = ((_1329 / exp2(log2(exp2(log2(_1329 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1341 = _1309;
                  }
                  do {
                    if (!(_1311 < 0.8799999952316284f)) {
                      float _1344 = _1311 + -0.8799999952316284f;
                      _1356 = ((_1344 / exp2(log2(exp2(log2(_1344 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1356 = _1311;
                    }
                    _1364 = (_1296 - (_1306 * _1326));
                    _1365 = (_1296 - (_1306 * _1341));
                    _1366 = (_1296 - (_1306 * _1356));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1364 = _1288;
              _1365 = _1291;
              _1366 = _1294;
            }
          } else {
            _1364 = _1288;
            _1365 = _1291;
            _1366 = _1294;
          }
          float _1382 = ((mad(0.16386906802654266f, _1366, mad(0.14067870378494263f, _1365, (_1364 * 0.6954522132873535f))) - _1279) * ACESGamutCompression) + _1279;
          float _1383 = ((mad(0.0955343171954155f, _1366, mad(0.8596711158752441f, _1365, (_1364 * 0.044794563204050064f))) - _1282) * ACESGamutCompression) + _1282;
          float _1384 = ((mad(1.0015007257461548f, _1366, mad(0.004025210160762072f, _1365, (_1364 * -0.005525882821530104f))) - _1285) * ACESGamutCompression) + _1285;
          float _1388 = max(max(_1382, _1383), _1384);
          float _1393 = (max(_1388, 1.000000013351432e-10f) - max(min(min(_1382, _1383), _1384), 1.000000013351432e-10f)) / max(_1388, 0.009999999776482582f);
          float _1406 = ((_1383 + _1382) + _1384) + (sqrt((((_1384 - _1383) * _1384) + ((_1383 - _1382) * _1383)) + ((_1382 - _1384) * _1382)) * 1.75f);
          float _1407 = _1406 * 0.3333333432674408f;
          float _1408 = _1393 + -0.4000000059604645f;
          float _1409 = _1408 * 5.0f;
          float _1413 = max((1.0f - abs(_1408 * 2.5f)), 0.0f);
          float _1424 = ((float((int)(((int)(uint)((bool)(_1409 > 0.0f))) - ((int)(uint)((bool)(_1409 < 0.0f))))) * (1.0f - (_1413 * _1413))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1407 <= 0.0533333346247673f)) {
              if (!(_1407 >= 0.1599999964237213f)) {
                _1433 = (((0.23999999463558197f / _1406) + -0.5f) * _1424);
              } else {
                _1433 = 0.0f;
              }
            } else {
              _1433 = _1424;
            }
            float _1434 = _1433 + 1.0f;
            float _1435 = _1434 * _1382;
            float _1436 = _1434 * _1383;
            float _1437 = _1434 * _1384;
            do {
              if (!((bool)(_1435 == _1436) && (bool)(_1436 == _1437))) {
                float _1444 = ((_1435 * 2.0f) - _1436) - _1437;
                float _1447 = ((_1383 - _1384) * 1.7320507764816284f) * _1434;
                float _1449 = atan(_1447 / _1444);
                bool _1452 = (_1444 < 0.0f);
                bool _1453 = (_1444 == 0.0f);
                bool _1454 = (_1447 >= 0.0f);
                bool _1455 = (_1447 < 0.0f);
                _1466 = select((_1454 && _1453), 90.0f, select((_1455 && _1453), -90.0f, (select((_1455 && _1452), (_1449 + -3.1415927410125732f), select((_1454 && _1452), (_1449 + 3.1415927410125732f), _1449)) * 57.2957763671875f)));
              } else {
                _1466 = 0.0f;
              }
              float _1471 = min(max(select((_1466 < 0.0f), (_1466 + 360.0f), _1466), 0.0f), 360.0f);
              do {
                if (_1471 < -180.0f) {
                  _1480 = (_1471 + 360.0f);
                } else {
                  if (_1471 > 180.0f) {
                    _1480 = (_1471 + -360.0f);
                  } else {
                    _1480 = _1471;
                  }
                }
                do {
                  if ((bool)(_1480 > -67.5f) && (bool)(_1480 < 67.5f)) {
                    float _1486 = (_1480 + 67.5f) * 0.029629629105329514f;
                    int _1487 = int(_1486);
                    float _1489 = _1486 - float((int)(_1487));
                    float _1490 = _1489 * _1489;
                    float _1491 = _1490 * _1489;
                    if (_1487 == 3) {
                      _1519 = (((0.1666666716337204f - (_1489 * 0.5f)) + (_1490 * 0.5f)) - (_1491 * 0.1666666716337204f));
                    } else {
                      if (_1487 == 2) {
                        _1519 = ((0.6666666865348816f - _1490) + (_1491 * 0.5f));
                      } else {
                        if (_1487 == 1) {
                          _1519 = (((_1491 * -0.5f) + 0.1666666716337204f) + ((_1490 + _1489) * 0.5f));
                        } else {
                          _1519 = select((_1487 == 0), (_1491 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1519 = 0.0f;
                  }
                  float _1528 = min(max(((((_1393 * 0.27000001072883606f) * (0.029999999329447746f - _1435)) * _1519) + _1435), 0.0f), 65535.0f);
                  float _1529 = min(max(_1436, 0.0f), 65535.0f);
                  float _1530 = min(max(_1437, 0.0f), 65535.0f);
                  float _1543 = min(max(mad(-0.21492856740951538f, _1530, mad(-0.2365107536315918f, _1529, (_1528 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1544 = min(max(mad(-0.09967592358589172f, _1530, mad(1.17622971534729f, _1529, (_1528 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1545 = min(max(mad(0.9977163076400757f, _1530, mad(-0.006032449658960104f, _1529, (_1528 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1546 = dot(float3(_1543, _1544, _1545), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1569 = log2(max((lerp(_1546, _1543, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1570 = _1569 * 0.3010300099849701f;
                  float _1571 = log2(ACESMinMaxData.x);
                  float _1572 = _1571 * 0.3010300099849701f;
                  do {
                    if (!(!(_1570 <= _1572))) {
                      _1641 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1579 = log2(ACESMidData.x);
                      float _1580 = _1579 * 0.3010300099849701f;
                      if ((bool)(_1570 > _1572) && (bool)(_1570 < _1580)) {
                        float _1588 = ((_1569 - _1571) * 0.9030900001525879f) / ((_1579 - _1571) * 0.3010300099849701f);
                        int _1589 = int(_1588);
                        float _1591 = _1588 - float((int)(_1589));
                        float _1593 = _18[_1589];
                        float _1596 = _18[(_1589 + 1)];
                        float _1601 = _1593 * 0.5f;
                        _1641 = dot(float3((_1591 * _1591), _1591, 1.0f), float3(mad((_18[(_1589 + 2)]), 0.5f, mad(_1596, -1.0f, _1601)), (_1596 - _1593), mad(_1596, 0.5f, _1601)));
                      } else {
                        do {
                          if (!(!(_1570 >= _1580))) {
                            float _1610 = log2(ACESMinMaxData.z);
                            if (_1570 < (_1610 * 0.3010300099849701f)) {
                              float _1618 = ((_1569 - _1579) * 0.9030900001525879f) / ((_1610 - _1579) * 0.3010300099849701f);
                              int _1619 = int(_1618);
                              float _1621 = _1618 - float((int)(_1619));
                              float _1623 = _19[_1619];
                              float _1626 = _19[(_1619 + 1)];
                              float _1631 = _1623 * 0.5f;
                              _1641 = dot(float3((_1621 * _1621), _1621, 1.0f), float3(mad((_19[(_1619 + 2)]), 0.5f, mad(_1626, -1.0f, _1631)), (_1626 - _1623), mad(_1626, 0.5f, _1631)));
                              break;
                            }
                          }
                          _1641 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _20[0] = ACESCoefsLow_0.x;
                    _20[1] = ACESCoefsLow_0.y;
                    _20[2] = ACESCoefsLow_0.z;
                    _20[3] = ACESCoefsLow_0.w;
                    _20[4] = ACESCoefsLow_4;
                    _20[5] = ACESCoefsLow_4;
                    _21[0] = ACESCoefsHigh_0.x;
                    _21[1] = ACESCoefsHigh_0.y;
                    _21[2] = ACESCoefsHigh_0.z;
                    _21[3] = ACESCoefsHigh_0.w;
                    _21[4] = ACESCoefsHigh_4;
                    _21[5] = ACESCoefsHigh_4;
                    float _1657 = log2(max((lerp(_1546, _1544, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1658 = _1657 * 0.3010300099849701f;
                    do {
                      if (!(!(_1658 <= _1572))) {
                        _1727 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1665 = log2(ACESMidData.x);
                        float _1666 = _1665 * 0.3010300099849701f;
                        if ((bool)(_1658 > _1572) && (bool)(_1658 < _1666)) {
                          float _1674 = ((_1657 - _1571) * 0.9030900001525879f) / ((_1665 - _1571) * 0.3010300099849701f);
                          int _1675 = int(_1674);
                          float _1677 = _1674 - float((int)(_1675));
                          float _1679 = _20[_1675];
                          float _1682 = _20[(_1675 + 1)];
                          float _1687 = _1679 * 0.5f;
                          _1727 = dot(float3((_1677 * _1677), _1677, 1.0f), float3(mad((_20[(_1675 + 2)]), 0.5f, mad(_1682, -1.0f, _1687)), (_1682 - _1679), mad(_1682, 0.5f, _1687)));
                        } else {
                          do {
                            if (!(!(_1658 >= _1666))) {
                              float _1696 = log2(ACESMinMaxData.z);
                              if (_1658 < (_1696 * 0.3010300099849701f)) {
                                float _1704 = ((_1657 - _1665) * 0.9030900001525879f) / ((_1696 - _1665) * 0.3010300099849701f);
                                int _1705 = int(_1704);
                                float _1707 = _1704 - float((int)(_1705));
                                float _1709 = _21[_1705];
                                float _1712 = _21[(_1705 + 1)];
                                float _1717 = _1709 * 0.5f;
                                _1727 = dot(float3((_1707 * _1707), _1707, 1.0f), float3(mad((_21[(_1705 + 2)]), 0.5f, mad(_1712, -1.0f, _1717)), (_1712 - _1709), mad(_1712, 0.5f, _1717)));
                                break;
                              }
                            }
                            _1727 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1731 = log2(max((lerp(_1546, _1545, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1732 = _1731 * 0.3010300099849701f;
                      do {
                        if (!(!(_1732 <= _1572))) {
                          _1801 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1739 = log2(ACESMidData.x);
                          float _1740 = _1739 * 0.3010300099849701f;
                          if ((bool)(_1732 > _1572) && (bool)(_1732 < _1740)) {
                            float _1748 = ((_1731 - _1571) * 0.9030900001525879f) / ((_1739 - _1571) * 0.3010300099849701f);
                            int _1749 = int(_1748);
                            float _1751 = _1748 - float((int)(_1749));
                            float _1753 = _10[_1749];
                            float _1756 = _10[(_1749 + 1)];
                            float _1761 = _1753 * 0.5f;
                            _1801 = dot(float3((_1751 * _1751), _1751, 1.0f), float3(mad((_10[(_1749 + 2)]), 0.5f, mad(_1756, -1.0f, _1761)), (_1756 - _1753), mad(_1756, 0.5f, _1761)));
                          } else {
                            do {
                              if (!(!(_1732 >= _1740))) {
                                float _1770 = log2(ACESMinMaxData.z);
                                if (_1732 < (_1770 * 0.3010300099849701f)) {
                                  float _1778 = ((_1731 - _1739) * 0.9030900001525879f) / ((_1770 - _1739) * 0.3010300099849701f);
                                  int _1779 = int(_1778);
                                  float _1781 = _1778 - float((int)(_1779));
                                  float _1783 = _11[_1779];
                                  float _1786 = _11[(_1779 + 1)];
                                  float _1791 = _1783 * 0.5f;
                                  _1801 = dot(float3((_1781 * _1781), _1781, 1.0f), float3(mad((_11[(_1779 + 2)]), 0.5f, mad(_1786, -1.0f, _1791)), (_1786 - _1783), mad(_1786, 0.5f, _1791)));
                                  break;
                                }
                              }
                              _1801 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1805 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1806 = (exp2(_1641 * 3.321928024291992f) - ACESMinMaxData.y) / _1805;
                        float _1808 = (exp2(_1727 * 3.321928024291992f) - ACESMinMaxData.y) / _1805;
                        float _1810 = (exp2(_1801 * 3.321928024291992f) - ACESMinMaxData.y) / _1805;
                        float _1813 = mad(0.15618768334388733f, _1810, mad(0.13400420546531677f, _1808, (_1806 * 0.6624541878700256f)));
                        float _1816 = mad(0.053689517080783844f, _1810, mad(0.6740817427635193f, _1808, (_1806 * 0.2722287178039551f)));
                        float _1819 = mad(1.0103391408920288f, _1810, mad(0.00406073359772563f, _1808, (_1806 * -0.005574649665504694f)));
                        float _1832 = min(max(mad(-0.23642469942569733f, _1819, mad(-0.32480329275131226f, _1816, (_1813 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1833 = min(max(mad(0.016756348311901093f, _1819, mad(1.6153316497802734f, _1816, (_1813 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1834 = min(max(mad(0.9883948564529419f, _1819, mad(-0.008284442126750946f, _1816, (_1813 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1837 = mad(0.15618768334388733f, _1834, mad(0.13400420546531677f, _1833, (_1832 * 0.6624541878700256f)));
                        float _1840 = mad(0.053689517080783844f, _1834, mad(0.6740817427635193f, _1833, (_1832 * 0.2722287178039551f)));
                        float _1843 = mad(1.0103391408920288f, _1834, mad(0.00406073359772563f, _1833, (_1832 * -0.005574649665504694f)));
                        float _1865 = min(max((min(max(mad(-0.23642469942569733f, _1843, mad(-0.32480329275131226f, _1840, (_1837 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1866 = min(max((min(max(mad(0.016756348311901093f, _1843, mad(1.6153316497802734f, _1840, (_1837 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1867 = min(max((min(max(mad(0.9883948564529419f, _1843, mad(-0.008284442126750946f, _1840, (_1837 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 5)) {
                            _1880 = mad(_55, _1867, mad(_54, _1866, (_1865 * _53)));
                            _1881 = mad(_58, _1867, mad(_57, _1866, (_1865 * _56)));
                            _1882 = mad(_61, _1867, mad(_60, _1866, (_1865 * _59)));
                          } else {
                            _1880 = _1865;
                            _1881 = _1866;
                            _1882 = _1867;
                          }
                          float _1892 = exp2(log2(_1880 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1893 = exp2(log2(_1881 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1894 = exp2(log2(_1882 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2757 = exp2(log2((1.0f / ((_1892 * 18.6875f) + 1.0f)) * ((_1892 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2758 = exp2(log2((1.0f / ((_1893 * 18.6875f) + 1.0f)) * ((_1893 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2759 = exp2(log2((1.0f / ((_1894 * 18.6875f) + 1.0f)) * ((_1894 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1960 = ACESSceneColorMultiplier * _1073;
          float _1961 = ACESSceneColorMultiplier * _1074;
          float _1962 = ACESSceneColorMultiplier * _1075;
          float _1965 = mad((WorkingColorSpace.ToAP0[0].z), _1962, mad((WorkingColorSpace.ToAP0[0].y), _1961, ((WorkingColorSpace.ToAP0[0].x) * _1960)));
          float _1968 = mad((WorkingColorSpace.ToAP0[1].z), _1962, mad((WorkingColorSpace.ToAP0[1].y), _1961, ((WorkingColorSpace.ToAP0[1].x) * _1960)));
          float _1971 = mad((WorkingColorSpace.ToAP0[2].z), _1962, mad((WorkingColorSpace.ToAP0[2].y), _1961, ((WorkingColorSpace.ToAP0[2].x) * _1960)));
          float _1974 = mad(-0.21492856740951538f, _1971, mad(-0.2365107536315918f, _1968, (_1965 * 1.4514392614364624f)));
          float _1977 = mad(-0.09967592358589172f, _1971, mad(1.17622971534729f, _1968, (_1965 * -0.07655377686023712f)));
          float _1980 = mad(0.9977163076400757f, _1971, mad(-0.006032449658960104f, _1968, (_1965 * 0.008316148072481155f)));
          float _1982 = max(_1974, max(_1977, _1980));
          do {
            if (!(_1982 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1965 < 0.0f) || (bool)(_1968 < 0.0f))) || (bool)(_1971 < 0.0f))) {
                float _1992 = abs(_1982);
                float _1993 = (_1982 - _1974) / _1992;
                float _1995 = (_1982 - _1977) / _1992;
                float _1997 = (_1982 - _1980) / _1992;
                do {
                  if (!(_1993 < 0.8149999976158142f)) {
                    float _2000 = _1993 + -0.8149999976158142f;
                    _2012 = ((_2000 / exp2(log2(exp2(log2(_2000 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2012 = _1993;
                  }
                  do {
                    if (!(_1995 < 0.8029999732971191f)) {
                      float _2015 = _1995 + -0.8029999732971191f;
                      _2027 = ((_2015 / exp2(log2(exp2(log2(_2015 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2027 = _1995;
                    }
                    do {
                      if (!(_1997 < 0.8799999952316284f)) {
                        float _2030 = _1997 + -0.8799999952316284f;
                        _2042 = ((_2030 / exp2(log2(exp2(log2(_2030 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2042 = _1997;
                      }
                      _2050 = (_1982 - (_1992 * _2012));
                      _2051 = (_1982 - (_1992 * _2027));
                      _2052 = (_1982 - (_1992 * _2042));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2050 = _1974;
                _2051 = _1977;
                _2052 = _1980;
              }
            } else {
              _2050 = _1974;
              _2051 = _1977;
              _2052 = _1980;
            }
            float _2068 = ((mad(0.16386906802654266f, _2052, mad(0.14067870378494263f, _2051, (_2050 * 0.6954522132873535f))) - _1965) * ACESGamutCompression) + _1965;
            float _2069 = ((mad(0.0955343171954155f, _2052, mad(0.8596711158752441f, _2051, (_2050 * 0.044794563204050064f))) - _1968) * ACESGamutCompression) + _1968;
            float _2070 = ((mad(1.0015007257461548f, _2052, mad(0.004025210160762072f, _2051, (_2050 * -0.005525882821530104f))) - _1971) * ACESGamutCompression) + _1971;
            float _2074 = max(max(_2068, _2069), _2070);
            float _2079 = (max(_2074, 1.000000013351432e-10f) - max(min(min(_2068, _2069), _2070), 1.000000013351432e-10f)) / max(_2074, 0.009999999776482582f);
            float _2092 = ((_2069 + _2068) + _2070) + (sqrt((((_2070 - _2069) * _2070) + ((_2069 - _2068) * _2069)) + ((_2068 - _2070) * _2068)) * 1.75f);
            float _2093 = _2092 * 0.3333333432674408f;
            float _2094 = _2079 + -0.4000000059604645f;
            float _2095 = _2094 * 5.0f;
            float _2099 = max((1.0f - abs(_2094 * 2.5f)), 0.0f);
            float _2110 = ((float((int)(((int)(uint)((bool)(_2095 > 0.0f))) - ((int)(uint)((bool)(_2095 < 0.0f))))) * (1.0f - (_2099 * _2099))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2093 <= 0.0533333346247673f)) {
                if (!(_2093 >= 0.1599999964237213f)) {
                  _2119 = (((0.23999999463558197f / _2092) + -0.5f) * _2110);
                } else {
                  _2119 = 0.0f;
                }
              } else {
                _2119 = _2110;
              }
              float _2120 = _2119 + 1.0f;
              float _2121 = _2120 * _2068;
              float _2122 = _2120 * _2069;
              float _2123 = _2120 * _2070;
              do {
                if (!((bool)(_2121 == _2122) && (bool)(_2122 == _2123))) {
                  float _2130 = ((_2121 * 2.0f) - _2122) - _2123;
                  float _2133 = ((_2069 - _2070) * 1.7320507764816284f) * _2120;
                  float _2135 = atan(_2133 / _2130);
                  bool _2138 = (_2130 < 0.0f);
                  bool _2139 = (_2130 == 0.0f);
                  bool _2140 = (_2133 >= 0.0f);
                  bool _2141 = (_2133 < 0.0f);
                  _2152 = select((_2140 && _2139), 90.0f, select((_2141 && _2139), -90.0f, (select((_2141 && _2138), (_2135 + -3.1415927410125732f), select((_2140 && _2138), (_2135 + 3.1415927410125732f), _2135)) * 57.2957763671875f)));
                } else {
                  _2152 = 0.0f;
                }
                float _2157 = min(max(select((_2152 < 0.0f), (_2152 + 360.0f), _2152), 0.0f), 360.0f);
                do {
                  if (_2157 < -180.0f) {
                    _2166 = (_2157 + 360.0f);
                  } else {
                    if (_2157 > 180.0f) {
                      _2166 = (_2157 + -360.0f);
                    } else {
                      _2166 = _2157;
                    }
                  }
                  do {
                    if ((bool)(_2166 > -67.5f) && (bool)(_2166 < 67.5f)) {
                      float _2172 = (_2166 + 67.5f) * 0.029629629105329514f;
                      int _2173 = int(_2172);
                      float _2175 = _2172 - float((int)(_2173));
                      float _2176 = _2175 * _2175;
                      float _2177 = _2176 * _2175;
                      if (_2173 == 3) {
                        _2205 = (((0.1666666716337204f - (_2175 * 0.5f)) + (_2176 * 0.5f)) - (_2177 * 0.1666666716337204f));
                      } else {
                        if (_2173 == 2) {
                          _2205 = ((0.6666666865348816f - _2176) + (_2177 * 0.5f));
                        } else {
                          if (_2173 == 1) {
                            _2205 = (((_2177 * -0.5f) + 0.1666666716337204f) + ((_2176 + _2175) * 0.5f));
                          } else {
                            _2205 = select((_2173 == 0), (_2177 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2205 = 0.0f;
                    }
                    float _2214 = min(max(((((_2079 * 0.27000001072883606f) * (0.029999999329447746f - _2121)) * _2205) + _2121), 0.0f), 65535.0f);
                    float _2215 = min(max(_2122, 0.0f), 65535.0f);
                    float _2216 = min(max(_2123, 0.0f), 65535.0f);
                    float _2229 = min(max(mad(-0.21492856740951538f, _2216, mad(-0.2365107536315918f, _2215, (_2214 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2230 = min(max(mad(-0.09967592358589172f, _2216, mad(1.17622971534729f, _2215, (_2214 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2231 = min(max(mad(0.9977163076400757f, _2216, mad(-0.006032449658960104f, _2215, (_2214 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2232 = dot(float3(_2229, _2230, _2231), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2255 = log2(max((lerp(_2232, _2229, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2256 = _2255 * 0.3010300099849701f;
                    float _2257 = log2(ACESMinMaxData.x);
                    float _2258 = _2257 * 0.3010300099849701f;
                    do {
                      if (!(!(_2256 <= _2258))) {
                        _2327 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2265 = log2(ACESMidData.x);
                        float _2266 = _2265 * 0.3010300099849701f;
                        if ((bool)(_2256 > _2258) && (bool)(_2256 < _2266)) {
                          float _2274 = ((_2255 - _2257) * 0.9030900001525879f) / ((_2265 - _2257) * 0.3010300099849701f);
                          int _2275 = int(_2274);
                          float _2277 = _2274 - float((int)(_2275));
                          float _2279 = _16[_2275];
                          float _2282 = _16[(_2275 + 1)];
                          float _2287 = _2279 * 0.5f;
                          _2327 = dot(float3((_2277 * _2277), _2277, 1.0f), float3(mad((_16[(_2275 + 2)]), 0.5f, mad(_2282, -1.0f, _2287)), (_2282 - _2279), mad(_2282, 0.5f, _2287)));
                        } else {
                          do {
                            if (!(!(_2256 >= _2266))) {
                              float _2296 = log2(ACESMinMaxData.z);
                              if (_2256 < (_2296 * 0.3010300099849701f)) {
                                float _2304 = ((_2255 - _2265) * 0.9030900001525879f) / ((_2296 - _2265) * 0.3010300099849701f);
                                int _2305 = int(_2304);
                                float _2307 = _2304 - float((int)(_2305));
                                float _2309 = _17[_2305];
                                float _2312 = _17[(_2305 + 1)];
                                float _2317 = _2309 * 0.5f;
                                _2327 = dot(float3((_2307 * _2307), _2307, 1.0f), float3(mad((_17[(_2305 + 2)]), 0.5f, mad(_2312, -1.0f, _2317)), (_2312 - _2309), mad(_2312, 0.5f, _2317)));
                                break;
                              }
                            }
                            _2327 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
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
                      float _2343 = log2(max((lerp(_2232, _2230, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2344 = _2343 * 0.3010300099849701f;
                      do {
                        if (!(!(_2344 <= _2258))) {
                          _2413 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2351 = log2(ACESMidData.x);
                          float _2352 = _2351 * 0.3010300099849701f;
                          if ((bool)(_2344 > _2258) && (bool)(_2344 < _2352)) {
                            float _2360 = ((_2343 - _2257) * 0.9030900001525879f) / ((_2351 - _2257) * 0.3010300099849701f);
                            int _2361 = int(_2360);
                            float _2363 = _2360 - float((int)(_2361));
                            float _2365 = _12[_2361];
                            float _2368 = _12[(_2361 + 1)];
                            float _2373 = _2365 * 0.5f;
                            _2413 = dot(float3((_2363 * _2363), _2363, 1.0f), float3(mad((_12[(_2361 + 2)]), 0.5f, mad(_2368, -1.0f, _2373)), (_2368 - _2365), mad(_2368, 0.5f, _2373)));
                          } else {
                            do {
                              if (!(!(_2344 >= _2352))) {
                                float _2382 = log2(ACESMinMaxData.z);
                                if (_2344 < (_2382 * 0.3010300099849701f)) {
                                  float _2390 = ((_2343 - _2351) * 0.9030900001525879f) / ((_2382 - _2351) * 0.3010300099849701f);
                                  int _2391 = int(_2390);
                                  float _2393 = _2390 - float((int)(_2391));
                                  float _2395 = _13[_2391];
                                  float _2398 = _13[(_2391 + 1)];
                                  float _2403 = _2395 * 0.5f;
                                  _2413 = dot(float3((_2393 * _2393), _2393, 1.0f), float3(mad((_13[(_2391 + 2)]), 0.5f, mad(_2398, -1.0f, _2403)), (_2398 - _2395), mad(_2398, 0.5f, _2403)));
                                  break;
                                }
                              }
                              _2413 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
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
                        float _2429 = log2(max((lerp(_2232, _2231, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2430 = _2429 * 0.3010300099849701f;
                        do {
                          if (!(!(_2430 <= _2258))) {
                            _2499 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2437 = log2(ACESMidData.x);
                            float _2438 = _2437 * 0.3010300099849701f;
                            if ((bool)(_2430 > _2258) && (bool)(_2430 < _2438)) {
                              float _2446 = ((_2429 - _2257) * 0.9030900001525879f) / ((_2437 - _2257) * 0.3010300099849701f);
                              int _2447 = int(_2446);
                              float _2449 = _2446 - float((int)(_2447));
                              float _2451 = _14[_2447];
                              float _2454 = _14[(_2447 + 1)];
                              float _2459 = _2451 * 0.5f;
                              _2499 = dot(float3((_2449 * _2449), _2449, 1.0f), float3(mad((_14[(_2447 + 2)]), 0.5f, mad(_2454, -1.0f, _2459)), (_2454 - _2451), mad(_2454, 0.5f, _2459)));
                            } else {
                              do {
                                if (!(!(_2430 >= _2438))) {
                                  float _2468 = log2(ACESMinMaxData.z);
                                  if (_2430 < (_2468 * 0.3010300099849701f)) {
                                    float _2476 = ((_2429 - _2437) * 0.9030900001525879f) / ((_2468 - _2437) * 0.3010300099849701f);
                                    int _2477 = int(_2476);
                                    float _2479 = _2476 - float((int)(_2477));
                                    float _2481 = _15[_2477];
                                    float _2484 = _15[(_2477 + 1)];
                                    float _2489 = _2481 * 0.5f;
                                    _2499 = dot(float3((_2479 * _2479), _2479, 1.0f), float3(mad((_15[(_2477 + 2)]), 0.5f, mad(_2484, -1.0f, _2489)), (_2484 - _2481), mad(_2484, 0.5f, _2489)));
                                    break;
                                  }
                                }
                                _2499 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2503 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2504 = (exp2(_2327 * 3.321928024291992f) - ACESMinMaxData.y) / _2503;
                          float _2506 = (exp2(_2413 * 3.321928024291992f) - ACESMinMaxData.y) / _2503;
                          float _2508 = (exp2(_2499 * 3.321928024291992f) - ACESMinMaxData.y) / _2503;
                          float _2511 = mad(0.15618768334388733f, _2508, mad(0.13400420546531677f, _2506, (_2504 * 0.6624541878700256f)));
                          float _2514 = mad(0.053689517080783844f, _2508, mad(0.6740817427635193f, _2506, (_2504 * 0.2722287178039551f)));
                          float _2517 = mad(1.0103391408920288f, _2508, mad(0.00406073359772563f, _2506, (_2504 * -0.005574649665504694f)));
                          float _2530 = min(max(mad(-0.23642469942569733f, _2517, mad(-0.32480329275131226f, _2514, (_2511 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2531 = min(max(mad(0.016756348311901093f, _2517, mad(1.6153316497802734f, _2514, (_2511 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2532 = min(max(mad(0.9883948564529419f, _2517, mad(-0.008284442126750946f, _2514, (_2511 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2535 = mad(0.15618768334388733f, _2532, mad(0.13400420546531677f, _2531, (_2530 * 0.6624541878700256f)));
                          float _2538 = mad(0.053689517080783844f, _2532, mad(0.6740817427635193f, _2531, (_2530 * 0.2722287178039551f)));
                          float _2541 = mad(1.0103391408920288f, _2532, mad(0.00406073359772563f, _2531, (_2530 * -0.005574649665504694f)));
                          float _2563 = min(max((min(max(mad(-0.23642469942569733f, _2541, mad(-0.32480329275131226f, _2538, (_2535 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2564 = min(max((min(max(mad(0.016756348311901093f, _2541, mad(1.6153316497802734f, _2538, (_2535 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2565 = min(max((min(max(mad(0.9883948564529419f, _2541, mad(-0.008284442126750946f, _2538, (_2535 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(OutputDevice == 6)) {
                              _2578 = mad(_55, _2565, mad(_54, _2564, (_2563 * _53)));
                              _2579 = mad(_58, _2565, mad(_57, _2564, (_2563 * _56)));
                              _2580 = mad(_61, _2565, mad(_60, _2564, (_2563 * _59)));
                            } else {
                              _2578 = _2563;
                              _2579 = _2564;
                              _2580 = _2565;
                            }
                            float _2590 = exp2(log2(_2578 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2591 = exp2(log2(_2579 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2592 = exp2(log2(_2580 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2757 = exp2(log2((1.0f / ((_2590 * 18.6875f) + 1.0f)) * ((_2590 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2758 = exp2(log2((1.0f / ((_2591 * 18.6875f) + 1.0f)) * ((_2591 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2759 = exp2(log2((1.0f / ((_2592 * 18.6875f) + 1.0f)) * ((_2592 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2637 = mad((WorkingColorSpace.ToAP1[0].z), _1075, mad((WorkingColorSpace.ToAP1[0].y), _1074, ((WorkingColorSpace.ToAP1[0].x) * _1073)));
            float _2640 = mad((WorkingColorSpace.ToAP1[1].z), _1075, mad((WorkingColorSpace.ToAP1[1].y), _1074, ((WorkingColorSpace.ToAP1[1].x) * _1073)));
            float _2643 = mad((WorkingColorSpace.ToAP1[2].z), _1075, mad((WorkingColorSpace.ToAP1[2].y), _1074, ((WorkingColorSpace.ToAP1[2].x) * _1073)));
            float _2662 = exp2(log2(mad(_55, _2643, mad(_54, _2640, (_2637 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2663 = exp2(log2(mad(_58, _2643, mad(_57, _2640, (_2637 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2664 = exp2(log2(mad(_61, _2643, mad(_60, _2640, (_2637 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2757 = exp2(log2((1.0f / ((_2662 * 18.6875f) + 1.0f)) * ((_2662 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2758 = exp2(log2((1.0f / ((_2663 * 18.6875f) + 1.0f)) * ((_2663 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2759 = exp2(log2((1.0f / ((_2664 * 18.6875f) + 1.0f)) * ((_2664 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2711 = mad((WorkingColorSpace.ToAP1[0].z), _1063, mad((WorkingColorSpace.ToAP1[0].y), _1062, ((WorkingColorSpace.ToAP1[0].x) * _1061)));
                float _2714 = mad((WorkingColorSpace.ToAP1[1].z), _1063, mad((WorkingColorSpace.ToAP1[1].y), _1062, ((WorkingColorSpace.ToAP1[1].x) * _1061)));
                float _2717 = mad((WorkingColorSpace.ToAP1[2].z), _1063, mad((WorkingColorSpace.ToAP1[2].y), _1062, ((WorkingColorSpace.ToAP1[2].x) * _1061)));
                _2757 = mad(_55, _2717, mad(_54, _2714, (_2711 * _53)));
                _2758 = mad(_58, _2717, mad(_57, _2714, (_2711 * _56)));
                _2759 = mad(_61, _2717, mad(_60, _2714, (_2711 * _59)));
              } else {
                float _2730 = mad((WorkingColorSpace.ToAP1[0].z), _1089, mad((WorkingColorSpace.ToAP1[0].y), _1088, ((WorkingColorSpace.ToAP1[0].x) * _1087)));
                float _2733 = mad((WorkingColorSpace.ToAP1[1].z), _1089, mad((WorkingColorSpace.ToAP1[1].y), _1088, ((WorkingColorSpace.ToAP1[1].x) * _1087)));
                float _2736 = mad((WorkingColorSpace.ToAP1[2].z), _1089, mad((WorkingColorSpace.ToAP1[2].y), _1088, ((WorkingColorSpace.ToAP1[2].x) * _1087)));
                _2757 = exp2(log2(mad(_55, _2736, mad(_54, _2733, (_2730 * _53)))) * InverseGamma.z);
                _2758 = exp2(log2(mad(_58, _2736, mad(_57, _2733, (_2730 * _56)))) * InverseGamma.z);
                _2759 = exp2(log2(mad(_61, _2736, mad(_60, _2733, (_2730 * _59)))) * InverseGamma.z);
              }
            } else {
              _2757 = _1073;
              _2758 = _1074;
              _2759 = _1075;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2757 * 0.9523810148239136f);
  SV_Target.y = (_2758 * 0.9523810148239136f);
  SV_Target.z = (_2759 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

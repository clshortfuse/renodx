#include "../common.hlsl"

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
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _26 = 0.5f / LUTSize;
  float _31 = LUTSize + -1.0f;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _580;
  float _613;
  float _627;
  float _691;
  float _882;
  float _893;
  float _904;
  float _1099;
  float _1100;
  float _1101;
  float _1112;
  float _1123;
  float _1134;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _44 = ((uint)(OutputGamut) == 4);
        _55 = select(_44, 1.0f, 1.705051064491272f);
        _56 = select(_44, 0.0f, -0.6217921376228333f);
        _57 = select(_44, 0.0f, -0.0832589864730835f);
        _58 = select(_44, 0.0f, -0.13025647401809692f);
        _59 = select(_44, 1.0f, 1.140804648399353f);
        _60 = select(_44, 0.0f, -0.010548308491706848f);
        _61 = select(_44, 0.0f, -0.024003351107239723f);
        _62 = select(_44, 0.0f, -0.1289689838886261f);
        _63 = select(_44, 1.0f, 1.1529725790023804f);
      } else {
        _55 = 0.6954522132873535f;
        _56 = 0.14067870378494263f;
        _57 = 0.16386906802654266f;
        _58 = 0.044794563204050064f;
        _59 = 0.8596711158752441f;
        _60 = 0.0955343171954155f;
        _61 = -0.005525882821530104f;
        _62 = 0.004025210160762072f;
        _63 = 1.0015007257461548f;
      }
    } else {
      _55 = 1.0258246660232544f;
      _56 = -0.020053181797266006f;
      _57 = -0.005771636962890625f;
      _58 = -0.002234415616840124f;
      _59 = 1.0045864582061768f;
      _60 = -0.002352118492126465f;
      _61 = -0.005013350863009691f;
      _62 = -0.025290070101618767f;
      _63 = 1.0303035974502563f;
    }
  } else {
    _55 = 1.3792141675949097f;
    _56 = -0.30886411666870117f;
    _57 = -0.0703500509262085f;
    _58 = -0.06933490186929703f;
    _59 = 1.08229660987854f;
    _60 = -0.012961871922016144f;
    _61 = -0.0021590073592960835f;
    _62 = -0.0454593189060688f;
    _63 = 1.0476183891296387f;
  }
  float _76 = (exp2((((LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _26)) / _31) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _77 = (exp2((((LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _26)) / _31) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _78 = (exp2(((float((uint)SV_DispatchThreadID.z) / _31) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _93 = mad((WorkingColorSpace_ToAP1[0].z), _78, mad((WorkingColorSpace_ToAP1[0].y), _77, ((WorkingColorSpace_ToAP1[0].x) * _76)));
  float _96 = mad((WorkingColorSpace_ToAP1[1].z), _78, mad((WorkingColorSpace_ToAP1[1].y), _77, ((WorkingColorSpace_ToAP1[1].x) * _76)));
  float _99 = mad((WorkingColorSpace_ToAP1[2].z), _78, mad((WorkingColorSpace_ToAP1[2].y), _77, ((WorkingColorSpace_ToAP1[2].x) * _76)));
  float _100 = dot(float3(_93, _96, _99), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUntonemappedAP1(float3(_93, _96, _99));

  float _104 = (_93 / _100) + -1.0f;
  float _105 = (_96 / _100) + -1.0f;
  float _106 = (_99 / _100) + -1.0f;
  float _118 = (1.0f - exp2(((_100 * _100) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_104, _105, _106), float3(_104, _105, _106)) * -4.0f));
  float _134 = ((mad(-0.06368321925401688f, _99, mad(-0.3292922377586365f, _96, (_93 * 1.3704125881195068f))) - _93) * _118) + _93;
  float _135 = ((mad(-0.010861365124583244f, _99, mad(1.0970927476882935f, _96, (_93 * -0.08343357592821121f))) - _96) * _118) + _96;
  float _136 = ((mad(1.2036951780319214f, _99, mad(-0.09862580895423889f, _96, (_93 * -0.02579331398010254f))) - _99) * _118) + _99;
  float _137 = dot(float3(_134, _135, _136), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _151 = ColorOffset.w + ColorOffsetShadows.w;
  float _165 = ColorGain.w * ColorGainShadows.w;
  float _179 = ColorGamma.w * ColorGammaShadows.w;
  float _193 = ColorContrast.w * ColorContrastShadows.w;
  float _207 = ColorSaturation.w * ColorSaturationShadows.w;
  float _211 = _134 - _137;
  float _212 = _135 - _137;
  float _213 = _136 - _137;
  float _270 = saturate(_137 / ColorCorrectionShadowsMax);
  float _274 = (_270 * _270) * (3.0f - (_270 * 2.0f));
  float _275 = 1.0f - _274;
  float _284 = ColorOffset.w + ColorOffsetHighlights.w;
  float _293 = ColorGain.w * ColorGainHighlights.w;
  float _302 = ColorGamma.w * ColorGammaHighlights.w;
  float _311 = ColorContrast.w * ColorContrastHighlights.w;
  float _320 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _383 = saturate((_137 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _387 = (_383 * _383) * (3.0f - (_383 * 2.0f));
  float _396 = ColorOffset.w + ColorOffsetMidtones.w;
  float _405 = ColorGain.w * ColorGainMidtones.w;
  float _414 = ColorGamma.w * ColorGammaMidtones.w;
  float _423 = ColorContrast.w * ColorContrastMidtones.w;
  float _432 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _490 = _274 - _387;
  float _501 = ((_387 * (((ColorOffset.x + ColorOffsetHighlights.x) + _284) + (((ColorGain.x * ColorGainHighlights.x) * _293) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _311) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _320) * _211) + _137)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _302)))))) + (_275 * (((ColorOffset.x + ColorOffsetShadows.x) + _151) + (((ColorGain.x * ColorGainShadows.x) * _165) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _193) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _207) * _211) + _137)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _179))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _396) + (((ColorGain.x * ColorGainMidtones.x) * _405) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _423) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _432) * _211) + _137)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _414))))) * _490);
  float _503 = ((_387 * (((ColorOffset.y + ColorOffsetHighlights.y) + _284) + (((ColorGain.y * ColorGainHighlights.y) * _293) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _311) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _320) * _212) + _137)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _302)))))) + (_275 * (((ColorOffset.y + ColorOffsetShadows.y) + _151) + (((ColorGain.y * ColorGainShadows.y) * _165) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _193) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _207) * _212) + _137)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _179))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _396) + (((ColorGain.y * ColorGainMidtones.y) * _405) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _423) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _432) * _212) + _137)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _414))))) * _490);
  float _505 = ((_387 * (((ColorOffset.z + ColorOffsetHighlights.z) + _284) + (((ColorGain.z * ColorGainHighlights.z) * _293) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _311) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _320) * _213) + _137)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _302)))))) + (_275 * (((ColorOffset.z + ColorOffsetShadows.z) + _151) + (((ColorGain.z * ColorGainShadows.z) * _165) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _193) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _207) * _213) + _137)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _179))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _396) + (((ColorGain.z * ColorGainMidtones.z) * _405) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _423) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _432) * _213) + _137)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _414))))) * _490);
  float _520 = ((mad(0.061360642313957214f, _505, mad(-4.540197551250458e-09f, _503, (_501 * 0.9386394023895264f))) - _501) * BlueCorrection) + _501;
  float _521 = ((mad(0.169205904006958f, _505, mad(0.8307942152023315f, _503, (_501 * 6.775371730327606e-08f))) - _503) * BlueCorrection) + _503;
  float _522 = (mad(-2.3283064365386963e-10f, _503, (_501 * -9.313225746154785e-10f)) * BlueCorrection) + _505;
  float _525 = mad(0.16386905312538147f, _522, mad(0.14067868888378143f, _521, (_520 * 0.6954522132873535f)));
  float _528 = mad(0.0955343246459961f, _522, mad(0.8596711158752441f, _521, (_520 * 0.044794581830501556f)));
  float _531 = mad(1.0015007257461548f, _522, mad(0.004025210160762072f, _521, (_520 * -0.005525882821530104f)));
  float _535 = max(max(_525, _528), _531);
  float _540 = (max(_535, 1.000000013351432e-10f) - max(min(min(_525, _528), _531), 1.000000013351432e-10f)) / max(_535, 0.009999999776482582f);
  float _553 = ((_528 + _525) + _531) + (sqrt((((_531 - _528) * _531) + ((_528 - _525) * _528)) + ((_525 - _531) * _525)) * 1.75f);
  float _554 = _553 * 0.3333333432674408f;
  float _555 = _540 + -0.4000000059604645f;
  float _556 = _555 * 5.0f;
  float _560 = max((1.0f - abs(_555 * 2.5f)), 0.0f);
  float _571 = ((float(((int)(uint)((bool)(_556 > 0.0f))) - ((int)(uint)((bool)(_556 < 0.0f)))) * (1.0f - (_560 * _560))) + 1.0f) * 0.02500000037252903f;
  if (!(_554 <= 0.0533333346247673f)) {
    if (!(_554 >= 0.1599999964237213f)) {
      _580 = (((0.23999999463558197f / _553) + -0.5f) * _571);
    } else {
      _580 = 0.0f;
    }
  } else {
    _580 = _571;
  }
  float _581 = _580 + 1.0f;
  float _582 = _581 * _525;
  float _583 = _581 * _528;
  float _584 = _581 * _531;
  if (!((bool)(_582 == _583) && (bool)(_583 == _584))) {
    float _591 = ((_582 * 2.0f) - _583) - _584;
    float _594 = ((_528 - _531) * 1.7320507764816284f) * _581;
    float _596 = atan(_594 / _591);
    bool _599 = (_591 < 0.0f);
    bool _600 = (_591 == 0.0f);
    bool _601 = (_594 >= 0.0f);
    bool _602 = (_594 < 0.0f);
    _613 = select((_601 && _600), 90.0f, select((_602 && _600), -90.0f, (select((_602 && _599), (_596 + -3.1415927410125732f), select((_601 && _599), (_596 + 3.1415927410125732f), _596)) * 57.2957763671875f)));
  } else {
    _613 = 0.0f;
  }
  float _618 = min(max(select((_613 < 0.0f), (_613 + 360.0f), _613), 0.0f), 360.0f);
  if (_618 < -180.0f) {
    _627 = (_618 + 360.0f);
  } else {
    if (_618 > 180.0f) {
      _627 = (_618 + -360.0f);
    } else {
      _627 = _618;
    }
  }
  float _631 = saturate(1.0f - abs(_627 * 0.014814814552664757f));
  float _635 = (_631 * _631) * (3.0f - (_631 * 2.0f));
  float _641 = ((_635 * _635) * ((_540 * 0.18000000715255737f) * (0.029999999329447746f - _582))) + _582;
  float _651 = max(0.0f, mad(-0.21492856740951538f, _584, mad(-0.2365107536315918f, _583, (_641 * 1.4514392614364624f))));
  float _652 = max(0.0f, mad(-0.09967592358589172f, _584, mad(1.17622971534729f, _583, (_641 * -0.07655377686023712f))));
  float _653 = max(0.0f, mad(0.9977163076400757f, _584, mad(-0.006032449658960104f, _583, (_641 * 0.008316148072481155f))));
  float _654 = dot(float3(_651, _652, _653), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _669 = (FilmBlackClip + 1.0f) - FilmToe;
  float _671 = FilmWhiteClip + 1.0f;
  float _673 = _671 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _691 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _682 = (FilmBlackClip + 0.18000000715255737f) / _669;
    _691 = (-0.7447274923324585f - ((log2(_682 / (2.0f - _682)) * 0.3465735912322998f) * (_669 / FilmSlope)));
  }
  float _694 = ((1.0f - FilmToe) / FilmSlope) - _691;
  float _696 = (FilmShoulder / FilmSlope) - _694;
  float _700 = log2(lerp(_654, _651, 0.9599999785423279f)) * 0.3010300099849701f;
  float _701 = log2(lerp(_654, _652, 0.9599999785423279f)) * 0.3010300099849701f;
  float _702 = log2(lerp(_654, _653, 0.9599999785423279f)) * 0.3010300099849701f;
  float _706 = FilmSlope * (_700 + _694);
  float _707 = FilmSlope * (_701 + _694);
  float _708 = FilmSlope * (_702 + _694);
  float _709 = _669 * 2.0f;
  float _711 = (FilmSlope * -2.0f) / _669;
  float _712 = _700 - _691;
  float _713 = _701 - _691;
  float _714 = _702 - _691;
  float _733 = _673 * 2.0f;
  float _735 = (FilmSlope * 2.0f) / _673;
  float _760 = select((_700 < _691), ((_709 / (exp2((_712 * 1.4426950216293335f) * _711) + 1.0f)) - FilmBlackClip), _706);
  float _761 = select((_701 < _691), ((_709 / (exp2((_713 * 1.4426950216293335f) * _711) + 1.0f)) - FilmBlackClip), _707);
  float _762 = select((_702 < _691), ((_709 / (exp2((_714 * 1.4426950216293335f) * _711) + 1.0f)) - FilmBlackClip), _708);
  float _769 = _696 - _691;
  float _773 = saturate(_712 / _769);
  float _774 = saturate(_713 / _769);
  float _775 = saturate(_714 / _769);
  bool _776 = (_696 < _691);
  float _780 = select(_776, (1.0f - _773), _773);
  float _781 = select(_776, (1.0f - _774), _774);
  float _782 = select(_776, (1.0f - _775), _775);
  float _801 = (((_780 * _780) * (select((_700 > _696), (_671 - (_733 / (exp2(((_700 - _696) * 1.4426950216293335f) * _735) + 1.0f))), _706) - _760)) * (3.0f - (_780 * 2.0f))) + _760;
  float _802 = (((_781 * _781) * (select((_701 > _696), (_671 - (_733 / (exp2(((_701 - _696) * 1.4426950216293335f) * _735) + 1.0f))), _707) - _761)) * (3.0f - (_781 * 2.0f))) + _761;
  float _803 = (((_782 * _782) * (select((_702 > _696), (_671 - (_733 / (exp2(((_702 - _696) * 1.4426950216293335f) * _735) + 1.0f))), _708) - _762)) * (3.0f - (_782 * 2.0f))) + _762;
  float _804 = dot(float3(_801, _802, _803), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _824 = (ToneCurveAmount * (max(0.0f, (lerp(_804, _801, 0.9300000071525574f))) - _520)) + _520;
  float _825 = (ToneCurveAmount * (max(0.0f, (lerp(_804, _802, 0.9300000071525574f))) - _521)) + _521;
  float _826 = (ToneCurveAmount * (max(0.0f, (lerp(_804, _803, 0.9300000071525574f))) - _522)) + _522;
  float _842 = ((mad(-0.06537103652954102f, _826, mad(1.451815478503704e-06f, _825, (_824 * 1.065374732017517f))) - _824) * BlueCorrection) + _824;
  float _843 = ((mad(-0.20366770029067993f, _826, mad(1.2036634683609009f, _825, (_824 * -2.57161445915699e-07f))) - _825) * BlueCorrection) + _825;
  float _844 = ((mad(0.9999996423721313f, _826, mad(2.0954757928848267e-08f, _825, (_824 * 1.862645149230957e-08f))) - _826) * BlueCorrection) + _826;

  SetTonemappedAP1(_842, _843, _844);

  float _869 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _844, mad((WorkingColorSpace_FromAP1[0].y), _843, ((WorkingColorSpace_FromAP1[0].x) * _842)))));
  float _870 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _844, mad((WorkingColorSpace_FromAP1[1].y), _843, ((WorkingColorSpace_FromAP1[1].x) * _842)))));
  float _871 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _844, mad((WorkingColorSpace_FromAP1[2].y), _843, ((WorkingColorSpace_FromAP1[2].x) * _842)))));
  if (_869 < 0.0031306699384003878f) {
    _882 = (_869 * 12.920000076293945f);
  } else {
    _882 = (((pow(_869, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_870 < 0.0031306699384003878f) {
    _893 = (_870 * 12.920000076293945f);
  } else {
    _893 = (((pow(_870, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_871 < 0.0031306699384003878f) {
    _904 = (_871 * 12.920000076293945f);
  } else {
    _904 = (((pow(_871, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _908 = (_893 * 0.9375f) + 0.03125f;
  float _915 = _904 * 15.0f;
  float _916 = floor(_915);
  float _917 = _915 - _916;
  float _919 = (_916 + ((_882 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _922 = Textures_1.SampleLevel(Samplers_1, float2(_919, _908), 0.0f);
  float _926 = _919 + 0.0625f;
  float4 _927 = Textures_1.SampleLevel(Samplers_1, float2(_926, _908), 0.0f);
  float4 _949 = Textures_2.SampleLevel(Samplers_2, float2(_919, _908), 0.0f);
  float4 _953 = Textures_2.SampleLevel(Samplers_2, float2(_926, _908), 0.0f);
  float4 _975 = Textures_3.SampleLevel(Samplers_3, float2(_919, _908), 0.0f);
  float4 _979 = Textures_3.SampleLevel(Samplers_3, float2(_926, _908), 0.0f);
  float _998 = max(6.103519990574569e-05f, (((((lerp(_922.x, _927.x, _917)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _882)) + ((lerp(_949.x, _953.x, _917)) * (LUTWeights[0].z))) + ((lerp(_975.x, _979.x, _917)) * (LUTWeights[0].w))));
  float _999 = max(6.103519990574569e-05f, (((((lerp(_922.y, _927.y, _917)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _893)) + ((lerp(_949.y, _953.y, _917)) * (LUTWeights[0].z))) + ((lerp(_975.y, _979.y, _917)) * (LUTWeights[0].w))));
  float _1000 = max(6.103519990574569e-05f, (((((lerp(_922.z, _927.z, _917)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _904)) + ((lerp(_949.z, _953.z, _917)) * (LUTWeights[0].z))) + ((lerp(_975.z, _979.z, _917)) * (LUTWeights[0].w))));
  float _1022 = select((_998 > 0.040449999272823334f), exp2(log2((_998 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_998 * 0.07739938050508499f));
  float _1023 = select((_999 > 0.040449999272823334f), exp2(log2((_999 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_999 * 0.07739938050508499f));
  float _1024 = select((_1000 > 0.040449999272823334f), exp2(log2((_1000 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1000 * 0.07739938050508499f));
  float _1050 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1022)) * _1022) + MappingPolynomial.z);
  float _1051 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1023)) * _1023) + MappingPolynomial.z);
  float _1052 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1024)) * _1024) + MappingPolynomial.z);
  float _1073 = exp2(log2(max(0.0f, (lerp(_1050, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1074 = exp2(log2(max(0.0f, (lerp(_1051, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1075 = exp2(log2(max(0.0f, (lerp(_1052, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (CUSTOM_PROCESSING_MODE == 0.f && RENODX_TONE_MAP_TYPE != 0.f) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1073, _1074, _1075));
    return;
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1082 = mad((WorkingColorSpace_ToAP1[0].z), _1075, mad((WorkingColorSpace_ToAP1[0].y), _1074, ((WorkingColorSpace_ToAP1[0].x) * _1073)));
    float _1085 = mad((WorkingColorSpace_ToAP1[1].z), _1075, mad((WorkingColorSpace_ToAP1[1].y), _1074, ((WorkingColorSpace_ToAP1[1].x) * _1073)));
    float _1088 = mad((WorkingColorSpace_ToAP1[2].z), _1075, mad((WorkingColorSpace_ToAP1[2].y), _1074, ((WorkingColorSpace_ToAP1[2].x) * _1073)));
    _1099 = mad(_57, _1088, mad(_56, _1085, (_1082 * _55)));
    _1100 = mad(_60, _1088, mad(_59, _1085, (_1082 * _58)));
    _1101 = mad(_63, _1088, mad(_62, _1085, (_1082 * _61)));
  } else {
    _1099 = _1073;
    _1100 = _1074;
    _1101 = _1075;
  }
  if (_1099 < 0.0031306699384003878f) {
    _1112 = (_1099 * 12.920000076293945f);
  } else {
    _1112 = (((pow(_1099, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1100 < 0.0031306699384003878f) {
    _1123 = (_1100 * 12.920000076293945f);
  } else {
    _1123 = (((pow(_1100, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1101 < 0.0031306699384003878f) {
    _1134 = (_1101 * 12.920000076293945f);
  } else {
    _1134 = (((pow(_1101, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1112 * 0.9523810148239136f), (_1123 * 0.9523810148239136f), (_1134 * 0.9523810148239136f), 0.0f);
}

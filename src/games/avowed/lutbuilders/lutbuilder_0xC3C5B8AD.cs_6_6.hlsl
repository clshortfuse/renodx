#include "../common.hlsl"

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _24 = 0.5f / LUTSize;
  float _29 = LUTSize + -1.0f;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _578;
  float _611;
  float _625;
  float _689;
  float _880;
  float _891;
  float _902;
  float _1071;
  float _1072;
  float _1073;
  float _1084;
  float _1095;
  float _1106;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _42 = ((uint)(OutputGamut) == 4);
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
  float _74 = (exp2((((LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _24)) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _75 = (exp2((((LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _24)) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _76 = (exp2(((float((uint)SV_DispatchThreadID.z) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _91 = mad((WorkingColorSpace_ToAP1[0].z), _76, mad((WorkingColorSpace_ToAP1[0].y), _75, ((WorkingColorSpace_ToAP1[0].x) * _74)));
  float _94 = mad((WorkingColorSpace_ToAP1[1].z), _76, mad((WorkingColorSpace_ToAP1[1].y), _75, ((WorkingColorSpace_ToAP1[1].x) * _74)));
  float _97 = mad((WorkingColorSpace_ToAP1[2].z), _76, mad((WorkingColorSpace_ToAP1[2].y), _75, ((WorkingColorSpace_ToAP1[2].x) * _74)));
  float _98 = dot(float3(_91, _94, _97), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_91, _94, _97));

  float _102 = (_91 / _98) + -1.0f;
  float _103 = (_94 / _98) + -1.0f;
  float _104 = (_97 / _98) + -1.0f;
  float _116 = (1.0f - exp2(((_98 * _98) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_102, _103, _104), float3(_102, _103, _104)) * -4.0f));
  float _132 = ((mad(-0.06368321925401688f, _97, mad(-0.3292922377586365f, _94, (_91 * 1.3704125881195068f))) - _91) * _116) + _91;
  float _133 = ((mad(-0.010861365124583244f, _97, mad(1.0970927476882935f, _94, (_91 * -0.08343357592821121f))) - _94) * _116) + _94;
  float _134 = ((mad(1.2036951780319214f, _97, mad(-0.09862580895423889f, _94, (_91 * -0.02579331398010254f))) - _97) * _116) + _97;
  float _135 = dot(float3(_132, _133, _134), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _149 = ColorOffset.w + ColorOffsetShadows.w;
  float _163 = ColorGain.w * ColorGainShadows.w;
  float _177 = ColorGamma.w * ColorGammaShadows.w;
  float _191 = ColorContrast.w * ColorContrastShadows.w;
  float _205 = ColorSaturation.w * ColorSaturationShadows.w;
  float _209 = _132 - _135;
  float _210 = _133 - _135;
  float _211 = _134 - _135;
  float _268 = saturate(_135 / ColorCorrectionShadowsMax);
  float _272 = (_268 * _268) * (3.0f - (_268 * 2.0f));
  float _273 = 1.0f - _272;
  float _282 = ColorOffset.w + ColorOffsetHighlights.w;
  float _291 = ColorGain.w * ColorGainHighlights.w;
  float _300 = ColorGamma.w * ColorGammaHighlights.w;
  float _309 = ColorContrast.w * ColorContrastHighlights.w;
  float _318 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _381 = saturate((_135 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _385 = (_381 * _381) * (3.0f - (_381 * 2.0f));
  float _394 = ColorOffset.w + ColorOffsetMidtones.w;
  float _403 = ColorGain.w * ColorGainMidtones.w;
  float _412 = ColorGamma.w * ColorGammaMidtones.w;
  float _421 = ColorContrast.w * ColorContrastMidtones.w;
  float _430 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _488 = _272 - _385;
  float _499 = ((_385 * (((ColorOffset.x + ColorOffsetHighlights.x) + _282) + (((ColorGain.x * ColorGainHighlights.x) * _291) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _309) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _318) * _209) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _300)))))) + (_273 * (((ColorOffset.x + ColorOffsetShadows.x) + _149) + (((ColorGain.x * ColorGainShadows.x) * _163) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _191) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _205) * _209) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _177))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _394) + (((ColorGain.x * ColorGainMidtones.x) * _403) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _421) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _430) * _209) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _412))))) * _488);
  float _501 = ((_385 * (((ColorOffset.y + ColorOffsetHighlights.y) + _282) + (((ColorGain.y * ColorGainHighlights.y) * _291) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _309) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _318) * _210) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _300)))))) + (_273 * (((ColorOffset.y + ColorOffsetShadows.y) + _149) + (((ColorGain.y * ColorGainShadows.y) * _163) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _191) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _205) * _210) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _177))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _394) + (((ColorGain.y * ColorGainMidtones.y) * _403) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _421) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _430) * _210) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _412))))) * _488);
  float _503 = ((_385 * (((ColorOffset.z + ColorOffsetHighlights.z) + _282) + (((ColorGain.z * ColorGainHighlights.z) * _291) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _309) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _318) * _211) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _300)))))) + (_273 * (((ColorOffset.z + ColorOffsetShadows.z) + _149) + (((ColorGain.z * ColorGainShadows.z) * _163) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _191) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _205) * _211) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _177))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _394) + (((ColorGain.z * ColorGainMidtones.z) * _403) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _421) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _430) * _211) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _412))))) * _488);

  SetUntonemappedAP1(float3(_499, _501, _503));

  float _518 = ((mad(0.061360642313957214f, _503, mad(-4.540197551250458e-09f, _501, (_499 * 0.9386394023895264f))) - _499) * BlueCorrection) + _499;
  float _519 = ((mad(0.169205904006958f, _503, mad(0.8307942152023315f, _501, (_499 * 6.775371730327606e-08f))) - _501) * BlueCorrection) + _501;
  float _520 = (mad(-2.3283064365386963e-10f, _501, (_499 * -9.313225746154785e-10f)) * BlueCorrection) + _503;
  float _523 = mad(0.16386905312538147f, _520, mad(0.14067868888378143f, _519, (_518 * 0.6954522132873535f)));
  float _526 = mad(0.0955343246459961f, _520, mad(0.8596711158752441f, _519, (_518 * 0.044794581830501556f)));
  float _529 = mad(1.0015007257461548f, _520, mad(0.004025210160762072f, _519, (_518 * -0.005525882821530104f)));
  float _533 = max(max(_523, _526), _529);
  float _538 = (max(_533, 1.000000013351432e-10f) - max(min(min(_523, _526), _529), 1.000000013351432e-10f)) / max(_533, 0.009999999776482582f);
  float _551 = ((_526 + _523) + _529) + (sqrt((((_529 - _526) * _529) + ((_526 - _523) * _526)) + ((_523 - _529) * _523)) * 1.75f);
  float _552 = _551 * 0.3333333432674408f;
  float _553 = _538 + -0.4000000059604645f;
  float _554 = _553 * 5.0f;
  float _558 = max((1.0f - abs(_553 * 2.5f)), 0.0f);
  float _569 = ((float(((int)(uint)((bool)(_554 > 0.0f))) - ((int)(uint)((bool)(_554 < 0.0f)))) * (1.0f - (_558 * _558))) + 1.0f) * 0.02500000037252903f;
  if (!(_552 <= 0.0533333346247673f)) {
    if (!(_552 >= 0.1599999964237213f)) {
      _578 = (((0.23999999463558197f / _551) + -0.5f) * _569);
    } else {
      _578 = 0.0f;
    }
  } else {
    _578 = _569;
  }
  float _579 = _578 + 1.0f;
  float _580 = _579 * _523;
  float _581 = _579 * _526;
  float _582 = _579 * _529;
  if (!((bool)(_580 == _581) && (bool)(_581 == _582))) {
    float _589 = ((_580 * 2.0f) - _581) - _582;
    float _592 = ((_526 - _529) * 1.7320507764816284f) * _579;
    float _594 = atan(_592 / _589);
    bool _597 = (_589 < 0.0f);
    bool _598 = (_589 == 0.0f);
    bool _599 = (_592 >= 0.0f);
    bool _600 = (_592 < 0.0f);
    _611 = select((_599 && _598), 90.0f, select((_600 && _598), -90.0f, (select((_600 && _597), (_594 + -3.1415927410125732f), select((_599 && _597), (_594 + 3.1415927410125732f), _594)) * 57.2957763671875f)));
  } else {
    _611 = 0.0f;
  }
  float _616 = min(max(select((_611 < 0.0f), (_611 + 360.0f), _611), 0.0f), 360.0f);
  if (_616 < -180.0f) {
    _625 = (_616 + 360.0f);
  } else {
    if (_616 > 180.0f) {
      _625 = (_616 + -360.0f);
    } else {
      _625 = _616;
    }
  }
  float _629 = saturate(1.0f - abs(_625 * 0.014814814552664757f));
  float _633 = (_629 * _629) * (3.0f - (_629 * 2.0f));
  float _639 = ((_633 * _633) * ((_538 * 0.18000000715255737f) * (0.029999999329447746f - _580))) + _580;
  float _649 = max(0.0f, mad(-0.21492856740951538f, _582, mad(-0.2365107536315918f, _581, (_639 * 1.4514392614364624f))));
  float _650 = max(0.0f, mad(-0.09967592358589172f, _582, mad(1.17622971534729f, _581, (_639 * -0.07655377686023712f))));
  float _651 = max(0.0f, mad(0.9977163076400757f, _582, mad(-0.006032449658960104f, _581, (_639 * 0.008316148072481155f))));
  float _652 = dot(float3(_649, _650, _651), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _667 = (FilmBlackClip + 1.0f) - FilmToe;
  float _669 = FilmWhiteClip + 1.0f;
  float _671 = _669 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _689 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _680 = (FilmBlackClip + 0.18000000715255737f) / _667;
    _689 = (-0.7447274923324585f - ((log2(_680 / (2.0f - _680)) * 0.3465735912322998f) * (_667 / FilmSlope)));
  }
  float _692 = ((1.0f - FilmToe) / FilmSlope) - _689;
  float _694 = (FilmShoulder / FilmSlope) - _692;
  float _698 = log2(lerp(_652, _649, 0.9599999785423279f)) * 0.3010300099849701f;
  float _699 = log2(lerp(_652, _650, 0.9599999785423279f)) * 0.3010300099849701f;
  float _700 = log2(lerp(_652, _651, 0.9599999785423279f)) * 0.3010300099849701f;
  float _704 = FilmSlope * (_698 + _692);
  float _705 = FilmSlope * (_699 + _692);
  float _706 = FilmSlope * (_700 + _692);
  float _707 = _667 * 2.0f;
  float _709 = (FilmSlope * -2.0f) / _667;
  float _710 = _698 - _689;
  float _711 = _699 - _689;
  float _712 = _700 - _689;
  float _731 = _671 * 2.0f;
  float _733 = (FilmSlope * 2.0f) / _671;
  float _758 = select((_698 < _689), ((_707 / (exp2((_710 * 1.4426950216293335f) * _709) + 1.0f)) - FilmBlackClip), _704);
  float _759 = select((_699 < _689), ((_707 / (exp2((_711 * 1.4426950216293335f) * _709) + 1.0f)) - FilmBlackClip), _705);
  float _760 = select((_700 < _689), ((_707 / (exp2((_712 * 1.4426950216293335f) * _709) + 1.0f)) - FilmBlackClip), _706);
  float _767 = _694 - _689;
  float _771 = saturate(_710 / _767);
  float _772 = saturate(_711 / _767);
  float _773 = saturate(_712 / _767);
  bool _774 = (_694 < _689);
  float _778 = select(_774, (1.0f - _771), _771);
  float _779 = select(_774, (1.0f - _772), _772);
  float _780 = select(_774, (1.0f - _773), _773);
  float _799 = (((_778 * _778) * (select((_698 > _694), (_669 - (_731 / (exp2(((_698 - _694) * 1.4426950216293335f) * _733) + 1.0f))), _704) - _758)) * (3.0f - (_778 * 2.0f))) + _758;
  float _800 = (((_779 * _779) * (select((_699 > _694), (_669 - (_731 / (exp2(((_699 - _694) * 1.4426950216293335f) * _733) + 1.0f))), _705) - _759)) * (3.0f - (_779 * 2.0f))) + _759;
  float _801 = (((_780 * _780) * (select((_700 > _694), (_669 - (_731 / (exp2(((_700 - _694) * 1.4426950216293335f) * _733) + 1.0f))), _706) - _760)) * (3.0f - (_780 * 2.0f))) + _760;
  float _802 = dot(float3(_799, _800, _801), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _822 = (ToneCurveAmount * (max(0.0f, (lerp(_802, _799, 0.9300000071525574f))) - _518)) + _518;
  float _823 = (ToneCurveAmount * (max(0.0f, (lerp(_802, _800, 0.9300000071525574f))) - _519)) + _519;
  float _824 = (ToneCurveAmount * (max(0.0f, (lerp(_802, _801, 0.9300000071525574f))) - _520)) + _520;
  float _840 = ((mad(-0.06537103652954102f, _824, mad(1.451815478503704e-06f, _823, (_822 * 1.065374732017517f))) - _822) * BlueCorrection) + _822;
  float _841 = ((mad(-0.20366770029067993f, _824, mad(1.2036634683609009f, _823, (_822 * -2.57161445915699e-07f))) - _823) * BlueCorrection) + _823;
  float _842 = ((mad(0.9999996423721313f, _824, mad(2.0954757928848267e-08f, _823, (_822 * 1.862645149230957e-08f))) - _824) * BlueCorrection) + _824;

  SetTonemappedAP1(_840, _841, _842);

  float _867 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _842, mad((WorkingColorSpace_FromAP1[0].y), _841, ((WorkingColorSpace_FromAP1[0].x) * _840)))));
  float _868 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _842, mad((WorkingColorSpace_FromAP1[1].y), _841, ((WorkingColorSpace_FromAP1[1].x) * _840)))));
  float _869 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _842, mad((WorkingColorSpace_FromAP1[2].y), _841, ((WorkingColorSpace_FromAP1[2].x) * _840)))));
  if (_867 < 0.0031306699384003878f) {
    _880 = (_867 * 12.920000076293945f);
  } else {
    _880 = (((pow(_867, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_868 < 0.0031306699384003878f) {
    _891 = (_868 * 12.920000076293945f);
  } else {
    _891 = (((pow(_868, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_869 < 0.0031306699384003878f) {
    _902 = (_869 * 12.920000076293945f);
  } else {
    _902 = (((pow(_869, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _906 = (_891 * 0.9375f) + 0.03125f;
  float _913 = _902 * 15.0f;
  float _914 = floor(_913);
  float _915 = _913 - _914;
  float _917 = (_914 + ((_880 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _920 = Textures_1.SampleLevel(Samplers_1, float2(_917, _906), 0.0f);
  float _924 = _917 + 0.0625f;
  float4 _925 = Textures_1.SampleLevel(Samplers_1, float2(_924, _906), 0.0f);
  float4 _947 = Textures_2.SampleLevel(Samplers_2, float2(_917, _906), 0.0f);
  float4 _951 = Textures_2.SampleLevel(Samplers_2, float2(_924, _906), 0.0f);
  float _970 = max(6.103519990574569e-05f, ((((lerp(_920.x, _925.x, _915)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _880)) + ((lerp(_947.x, _951.x, _915)) * (LUTWeights[0].z))));
  float _971 = max(6.103519990574569e-05f, ((((lerp(_920.y, _925.y, _915)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _891)) + ((lerp(_947.y, _951.y, _915)) * (LUTWeights[0].z))));
  float _972 = max(6.103519990574569e-05f, ((((lerp(_920.z, _925.z, _915)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _902)) + ((lerp(_947.z, _951.z, _915)) * (LUTWeights[0].z))));
  float _994 = select((_970 > 0.040449999272823334f), exp2(log2((_970 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_970 * 0.07739938050508499f));
  float _995 = select((_971 > 0.040449999272823334f), exp2(log2((_971 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_971 * 0.07739938050508499f));
  float _996 = select((_972 > 0.040449999272823334f), exp2(log2((_972 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_972 * 0.07739938050508499f));
  float _1022 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _994)) * _994) + MappingPolynomial.z);
  float _1023 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _995)) * _995) + MappingPolynomial.z);
  float _1024 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _996)) * _996) + MappingPolynomial.z);
  float _1045 = exp2(log2(max(0.0f, (lerp(_1022, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1046 = exp2(log2(max(0.0f, (lerp(_1023, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1047 = exp2(log2(max(0.0f, (lerp(_1024, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1045, _1046, _1047), OutputDevice);
    return;
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1054 = mad((WorkingColorSpace_ToAP1[0].z), _1047, mad((WorkingColorSpace_ToAP1[0].y), _1046, ((WorkingColorSpace_ToAP1[0].x) * _1045)));
    float _1057 = mad((WorkingColorSpace_ToAP1[1].z), _1047, mad((WorkingColorSpace_ToAP1[1].y), _1046, ((WorkingColorSpace_ToAP1[1].x) * _1045)));
    float _1060 = mad((WorkingColorSpace_ToAP1[2].z), _1047, mad((WorkingColorSpace_ToAP1[2].y), _1046, ((WorkingColorSpace_ToAP1[2].x) * _1045)));
    _1071 = mad(_55, _1060, mad(_54, _1057, (_1054 * _53)));
    _1072 = mad(_58, _1060, mad(_57, _1057, (_1054 * _56)));
    _1073 = mad(_61, _1060, mad(_60, _1057, (_1054 * _59)));
  } else {
    _1071 = _1045;
    _1072 = _1046;
    _1073 = _1047;
  }
  if (_1071 < 0.0031306699384003878f) {
    _1084 = (_1071 * 12.920000076293945f);
  } else {
    _1084 = (((pow(_1071, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1072 < 0.0031306699384003878f) {
    _1095 = (_1072 * 12.920000076293945f);
  } else {
    _1095 = (((pow(_1072, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1073 < 0.0031306699384003878f) {
    _1106 = (_1073 * 12.920000076293945f);
  } else {
    _1106 = (((pow(_1073, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1084 * 0.9523810148239136f), (_1095 * 0.9523810148239136f), (_1106 * 0.9523810148239136f), 0.0f);
}

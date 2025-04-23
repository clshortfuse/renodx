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
  float _28 = 0.5f / LUTSize;
  float _33 = LUTSize + -1.0f;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _582;
  float _615;
  float _629;
  float _693;
  float _884;
  float _895;
  float _906;
  float _1128;
  float _1129;
  float _1130;
  float _1141;
  float _1152;
  float _1163;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _46 = ((uint)(OutputGamut) == 4);
        _57 = select(_46, 1.0f, 1.705051064491272f);
        _58 = select(_46, 0.0f, -0.6217921376228333f);
        _59 = select(_46, 0.0f, -0.0832589864730835f);
        _60 = select(_46, 0.0f, -0.13025647401809692f);
        _61 = select(_46, 1.0f, 1.140804648399353f);
        _62 = select(_46, 0.0f, -0.010548308491706848f);
        _63 = select(_46, 0.0f, -0.024003351107239723f);
        _64 = select(_46, 0.0f, -0.1289689838886261f);
        _65 = select(_46, 1.0f, 1.1529725790023804f);
      } else {
        _57 = 0.6954522132873535f;
        _58 = 0.14067870378494263f;
        _59 = 0.16386906802654266f;
        _60 = 0.044794563204050064f;
        _61 = 0.8596711158752441f;
        _62 = 0.0955343171954155f;
        _63 = -0.005525882821530104f;
        _64 = 0.004025210160762072f;
        _65 = 1.0015007257461548f;
      }
    } else {
      _57 = 1.0258246660232544f;
      _58 = -0.020053181797266006f;
      _59 = -0.005771636962890625f;
      _60 = -0.002234415616840124f;
      _61 = 1.0045864582061768f;
      _62 = -0.002352118492126465f;
      _63 = -0.005013350863009691f;
      _64 = -0.025290070101618767f;
      _65 = 1.0303035974502563f;
    }
  } else {
    _57 = 1.3792141675949097f;
    _58 = -0.30886411666870117f;
    _59 = -0.0703500509262085f;
    _60 = -0.06933490186929703f;
    _61 = 1.08229660987854f;
    _62 = -0.012961871922016144f;
    _63 = -0.0021590073592960835f;
    _64 = -0.0454593189060688f;
    _65 = 1.0476183891296387f;
  }
  float _78 = (exp2((((LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _28)) / _33) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _79 = (exp2((((LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _28)) / _33) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _80 = (exp2(((float((uint)SV_DispatchThreadID.z) / _33) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _95 = mad((WorkingColorSpace_ToAP1[0].z), _80, mad((WorkingColorSpace_ToAP1[0].y), _79, ((WorkingColorSpace_ToAP1[0].x) * _78)));
  float _98 = mad((WorkingColorSpace_ToAP1[1].z), _80, mad((WorkingColorSpace_ToAP1[1].y), _79, ((WorkingColorSpace_ToAP1[1].x) * _78)));
  float _101 = mad((WorkingColorSpace_ToAP1[2].z), _80, mad((WorkingColorSpace_ToAP1[2].y), _79, ((WorkingColorSpace_ToAP1[2].x) * _78)));
  float _102 = dot(float3(_95, _98, _101), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _106 = (_95 / _102) + -1.0f;
  float _107 = (_98 / _102) + -1.0f;
  float _108 = (_101 / _102) + -1.0f;
  float _120 = (1.0f - exp2(((_102 * _102) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_106, _107, _108), float3(_106, _107, _108)) * -4.0f));
  float _136 = ((mad(-0.06368321925401688f, _101, mad(-0.3292922377586365f, _98, (_95 * 1.3704125881195068f))) - _95) * _120) + _95;
  float _137 = ((mad(-0.010861365124583244f, _101, mad(1.0970927476882935f, _98, (_95 * -0.08343357592821121f))) - _98) * _120) + _98;
  float _138 = ((mad(1.2036951780319214f, _101, mad(-0.09862580895423889f, _98, (_95 * -0.02579331398010254f))) - _101) * _120) + _101;
  float _139 = dot(float3(_136, _137, _138), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUntonemappedAP1(float3(_136, _137, _138));

  float _153 = ColorOffset.w + ColorOffsetShadows.w;
  float _167 = ColorGain.w * ColorGainShadows.w;
  float _181 = ColorGamma.w * ColorGammaShadows.w;
  float _195 = ColorContrast.w * ColorContrastShadows.w;
  float _209 = ColorSaturation.w * ColorSaturationShadows.w;
  float _213 = _136 - _139;
  float _214 = _137 - _139;
  float _215 = _138 - _139;
  float _272 = saturate(_139 / ColorCorrectionShadowsMax);
  float _276 = (_272 * _272) * (3.0f - (_272 * 2.0f));
  float _277 = 1.0f - _276;
  float _286 = ColorOffset.w + ColorOffsetHighlights.w;
  float _295 = ColorGain.w * ColorGainHighlights.w;
  float _304 = ColorGamma.w * ColorGammaHighlights.w;
  float _313 = ColorContrast.w * ColorContrastHighlights.w;
  float _322 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _385 = saturate((_139 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _389 = (_385 * _385) * (3.0f - (_385 * 2.0f));
  float _398 = ColorOffset.w + ColorOffsetMidtones.w;
  float _407 = ColorGain.w * ColorGainMidtones.w;
  float _416 = ColorGamma.w * ColorGammaMidtones.w;
  float _425 = ColorContrast.w * ColorContrastMidtones.w;
  float _434 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _492 = _276 - _389;
  float _503 = ((_389 * (((ColorOffset.x + ColorOffsetHighlights.x) + _286) + (((ColorGain.x * ColorGainHighlights.x) * _295) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _313) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _322) * _213) + _139)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _304)))))) + (_277 * (((ColorOffset.x + ColorOffsetShadows.x) + _153) + (((ColorGain.x * ColorGainShadows.x) * _167) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _195) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _209) * _213) + _139)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _181))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _398) + (((ColorGain.x * ColorGainMidtones.x) * _407) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _425) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _434) * _213) + _139)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _416))))) * _492);
  float _505 = ((_389 * (((ColorOffset.y + ColorOffsetHighlights.y) + _286) + (((ColorGain.y * ColorGainHighlights.y) * _295) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _313) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _322) * _214) + _139)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _304)))))) + (_277 * (((ColorOffset.y + ColorOffsetShadows.y) + _153) + (((ColorGain.y * ColorGainShadows.y) * _167) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _195) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _209) * _214) + _139)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _181))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _398) + (((ColorGain.y * ColorGainMidtones.y) * _407) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _425) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _434) * _214) + _139)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _416))))) * _492);
  float _507 = ((_389 * (((ColorOffset.z + ColorOffsetHighlights.z) + _286) + (((ColorGain.z * ColorGainHighlights.z) * _295) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _313) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _322) * _215) + _139)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _304)))))) + (_277 * (((ColorOffset.z + ColorOffsetShadows.z) + _153) + (((ColorGain.z * ColorGainShadows.z) * _167) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _195) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _209) * _215) + _139)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _181))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _398) + (((ColorGain.z * ColorGainMidtones.z) * _407) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _425) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _434) * _215) + _139)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _416))))) * _492);
  float _522 = ((mad(0.061360642313957214f, _507, mad(-4.540197551250458e-09f, _505, (_503 * 0.9386394023895264f))) - _503) * BlueCorrection) + _503;
  float _523 = ((mad(0.169205904006958f, _507, mad(0.8307942152023315f, _505, (_503 * 6.775371730327606e-08f))) - _505) * BlueCorrection) + _505;
  float _524 = (mad(-2.3283064365386963e-10f, _505, (_503 * -9.313225746154785e-10f)) * BlueCorrection) + _507;
  float _527 = mad(0.16386905312538147f, _524, mad(0.14067868888378143f, _523, (_522 * 0.6954522132873535f)));
  float _530 = mad(0.0955343246459961f, _524, mad(0.8596711158752441f, _523, (_522 * 0.044794581830501556f)));
  float _533 = mad(1.0015007257461548f, _524, mad(0.004025210160762072f, _523, (_522 * -0.005525882821530104f)));
  float _537 = max(max(_527, _530), _533);
  float _542 = (max(_537, 1.000000013351432e-10f) - max(min(min(_527, _530), _533), 1.000000013351432e-10f)) / max(_537, 0.009999999776482582f);
  float _555 = ((_530 + _527) + _533) + (sqrt((((_533 - _530) * _533) + ((_530 - _527) * _530)) + ((_527 - _533) * _527)) * 1.75f);
  float _556 = _555 * 0.3333333432674408f;
  float _557 = _542 + -0.4000000059604645f;
  float _558 = _557 * 5.0f;
  float _562 = max((1.0f - abs(_557 * 2.5f)), 0.0f);
  float _573 = ((float(((int)(uint)((bool)(_558 > 0.0f))) - ((int)(uint)((bool)(_558 < 0.0f)))) * (1.0f - (_562 * _562))) + 1.0f) * 0.02500000037252903f;
  if (!(_556 <= 0.0533333346247673f)) {
    if (!(_556 >= 0.1599999964237213f)) {
      _582 = (((0.23999999463558197f / _555) + -0.5f) * _573);
    } else {
      _582 = 0.0f;
    }
  } else {
    _582 = _573;
  }
  float _583 = _582 + 1.0f;
  float _584 = _583 * _527;
  float _585 = _583 * _530;
  float _586 = _583 * _533;
  if (!((bool)(_584 == _585) && (bool)(_585 == _586))) {
    float _593 = ((_584 * 2.0f) - _585) - _586;
    float _596 = ((_530 - _533) * 1.7320507764816284f) * _583;
    float _598 = atan(_596 / _593);
    bool _601 = (_593 < 0.0f);
    bool _602 = (_593 == 0.0f);
    bool _603 = (_596 >= 0.0f);
    bool _604 = (_596 < 0.0f);
    _615 = select((_603 && _602), 90.0f, select((_604 && _602), -90.0f, (select((_604 && _601), (_598 + -3.1415927410125732f), select((_603 && _601), (_598 + 3.1415927410125732f), _598)) * 57.2957763671875f)));
  } else {
    _615 = 0.0f;
  }
  float _620 = min(max(select((_615 < 0.0f), (_615 + 360.0f), _615), 0.0f), 360.0f);
  if (_620 < -180.0f) {
    _629 = (_620 + 360.0f);
  } else {
    if (_620 > 180.0f) {
      _629 = (_620 + -360.0f);
    } else {
      _629 = _620;
    }
  }
  float _633 = saturate(1.0f - abs(_629 * 0.014814814552664757f));
  float _637 = (_633 * _633) * (3.0f - (_633 * 2.0f));
  float _643 = ((_637 * _637) * ((_542 * 0.18000000715255737f) * (0.029999999329447746f - _584))) + _584;
  float _653 = max(0.0f, mad(-0.21492856740951538f, _586, mad(-0.2365107536315918f, _585, (_643 * 1.4514392614364624f))));
  float _654 = max(0.0f, mad(-0.09967592358589172f, _586, mad(1.17622971534729f, _585, (_643 * -0.07655377686023712f))));
  float _655 = max(0.0f, mad(0.9977163076400757f, _586, mad(-0.006032449658960104f, _585, (_643 * 0.008316148072481155f))));
  float _656 = dot(float3(_653, _654, _655), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _671 = (FilmBlackClip + 1.0f) - FilmToe;
  float _673 = FilmWhiteClip + 1.0f;
  float _675 = _673 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _693 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _684 = (FilmBlackClip + 0.18000000715255737f) / _671;
    _693 = (-0.7447274923324585f - ((log2(_684 / (2.0f - _684)) * 0.3465735912322998f) * (_671 / FilmSlope)));
  }
  float _696 = ((1.0f - FilmToe) / FilmSlope) - _693;
  float _698 = (FilmShoulder / FilmSlope) - _696;
  float _702 = log2(lerp(_656, _653, 0.9599999785423279f)) * 0.3010300099849701f;
  float _703 = log2(lerp(_656, _654, 0.9599999785423279f)) * 0.3010300099849701f;
  float _704 = log2(lerp(_656, _655, 0.9599999785423279f)) * 0.3010300099849701f;
  float _708 = FilmSlope * (_702 + _696);
  float _709 = FilmSlope * (_703 + _696);
  float _710 = FilmSlope * (_704 + _696);
  float _711 = _671 * 2.0f;
  float _713 = (FilmSlope * -2.0f) / _671;
  float _714 = _702 - _693;
  float _715 = _703 - _693;
  float _716 = _704 - _693;
  float _735 = _675 * 2.0f;
  float _737 = (FilmSlope * 2.0f) / _675;
  float _762 = select((_702 < _693), ((_711 / (exp2((_714 * 1.4426950216293335f) * _713) + 1.0f)) - FilmBlackClip), _708);
  float _763 = select((_703 < _693), ((_711 / (exp2((_715 * 1.4426950216293335f) * _713) + 1.0f)) - FilmBlackClip), _709);
  float _764 = select((_704 < _693), ((_711 / (exp2((_716 * 1.4426950216293335f) * _713) + 1.0f)) - FilmBlackClip), _710);
  float _771 = _698 - _693;
  float _775 = saturate(_714 / _771);
  float _776 = saturate(_715 / _771);
  float _777 = saturate(_716 / _771);
  bool _778 = (_698 < _693);
  float _782 = select(_778, (1.0f - _775), _775);
  float _783 = select(_778, (1.0f - _776), _776);
  float _784 = select(_778, (1.0f - _777), _777);
  float _803 = (((_782 * _782) * (select((_702 > _698), (_673 - (_735 / (exp2(((_702 - _698) * 1.4426950216293335f) * _737) + 1.0f))), _708) - _762)) * (3.0f - (_782 * 2.0f))) + _762;
  float _804 = (((_783 * _783) * (select((_703 > _698), (_673 - (_735 / (exp2(((_703 - _698) * 1.4426950216293335f) * _737) + 1.0f))), _709) - _763)) * (3.0f - (_783 * 2.0f))) + _763;
  float _805 = (((_784 * _784) * (select((_704 > _698), (_673 - (_735 / (exp2(((_704 - _698) * 1.4426950216293335f) * _737) + 1.0f))), _710) - _764)) * (3.0f - (_784 * 2.0f))) + _764;
  float _806 = dot(float3(_803, _804, _805), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _826 = (ToneCurveAmount * (max(0.0f, (lerp(_806, _803, 0.9300000071525574f))) - _522)) + _522;
  float _827 = (ToneCurveAmount * (max(0.0f, (lerp(_806, _804, 0.9300000071525574f))) - _523)) + _523;
  float _828 = (ToneCurveAmount * (max(0.0f, (lerp(_806, _805, 0.9300000071525574f))) - _524)) + _524;
  float _844 = ((mad(-0.06537103652954102f, _828, mad(1.451815478503704e-06f, _827, (_826 * 1.065374732017517f))) - _826) * BlueCorrection) + _826;
  float _845 = ((mad(-0.20366770029067993f, _828, mad(1.2036634683609009f, _827, (_826 * -2.57161445915699e-07f))) - _827) * BlueCorrection) + _827;
  float _846 = ((mad(0.9999996423721313f, _828, mad(2.0954757928848267e-08f, _827, (_826 * 1.862645149230957e-08f))) - _828) * BlueCorrection) + _828;

  SetTonemappedAP1(_844, _845, _846);

  float _871 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _846, mad((WorkingColorSpace_FromAP1[0].y), _845, ((WorkingColorSpace_FromAP1[0].x) * _844)))));
  float _872 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _846, mad((WorkingColorSpace_FromAP1[1].y), _845, ((WorkingColorSpace_FromAP1[1].x) * _844)))));
  float _873 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _846, mad((WorkingColorSpace_FromAP1[2].y), _845, ((WorkingColorSpace_FromAP1[2].x) * _844)))));
  if (_871 < 0.0031306699384003878f) {
    _884 = (_871 * 12.920000076293945f);
  } else {
    _884 = (((pow(_871, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_872 < 0.0031306699384003878f) {
    _895 = (_872 * 12.920000076293945f);
  } else {
    _895 = (((pow(_872, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_873 < 0.0031306699384003878f) {
    _906 = (_873 * 12.920000076293945f);
  } else {
    _906 = (((pow(_873, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _910 = (_895 * 0.9375f) + 0.03125f;
  float _917 = _906 * 15.0f;
  float _918 = floor(_917);
  float _919 = _917 - _918;
  float _921 = (_918 + ((_884 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _924 = Textures_1.SampleLevel(Samplers_1, float2(_921, _910), 0.0f);
  float _928 = _921 + 0.0625f;
  float4 _929 = Textures_1.SampleLevel(Samplers_1, float2(_928, _910), 0.0f);
  float4 _951 = Textures_2.SampleLevel(Samplers_2, float2(_921, _910), 0.0f);
  float4 _955 = Textures_2.SampleLevel(Samplers_2, float2(_928, _910), 0.0f);
  float4 _977 = Textures_3.SampleLevel(Samplers_3, float2(_921, _910), 0.0f);
  float4 _981 = Textures_3.SampleLevel(Samplers_3, float2(_928, _910), 0.0f);
  float4 _1004 = Textures_4.SampleLevel(Samplers_4, float2(_921, _910), 0.0f);
  float4 _1008 = Textures_4.SampleLevel(Samplers_4, float2(_928, _910), 0.0f);
  float _1027 = max(6.103519990574569e-05f, ((((((lerp(_924.x, _929.x, _919)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _884)) + ((lerp(_951.x, _955.x, _919)) * (LUTWeights[0].z))) + ((lerp(_977.x, _981.x, _919)) * (LUTWeights[0].w))) + ((lerp(_1004.x, _1008.x, _919)) * (LUTWeights[1].x))));
  float _1028 = max(6.103519990574569e-05f, ((((((lerp(_924.y, _929.y, _919)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _895)) + ((lerp(_951.y, _955.y, _919)) * (LUTWeights[0].z))) + ((lerp(_977.y, _981.y, _919)) * (LUTWeights[0].w))) + ((lerp(_1004.y, _1008.y, _919)) * (LUTWeights[1].x))));
  float _1029 = max(6.103519990574569e-05f, ((((((lerp(_924.z, _929.z, _919)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _906)) + ((lerp(_951.z, _955.z, _919)) * (LUTWeights[0].z))) + ((lerp(_977.z, _981.z, _919)) * (LUTWeights[0].w))) + ((lerp(_1004.z, _1008.z, _919)) * (LUTWeights[1].x))));
  float _1051 = select((_1027 > 0.040449999272823334f), exp2(log2((_1027 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1027 * 0.07739938050508499f));
  float _1052 = select((_1028 > 0.040449999272823334f), exp2(log2((_1028 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1028 * 0.07739938050508499f));
  float _1053 = select((_1029 > 0.040449999272823334f), exp2(log2((_1029 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1029 * 0.07739938050508499f));
  float _1079 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1051)) * _1051) + MappingPolynomial.z);
  float _1080 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1052)) * _1052) + MappingPolynomial.z);
  float _1081 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1053)) * _1053) + MappingPolynomial.z);
  float _1102 = exp2(log2(max(0.0f, (lerp(_1079, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1103 = exp2(log2(max(0.0f, (lerp(_1080, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1104 = exp2(log2(max(0.0f, (lerp(_1081, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (CUSTOM_PROCESSING_MODE == 0.f && RENODX_TONE_MAP_TYPE != 0.f) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1102, _1103, _1104), OutputDevice);
    return;
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1111 = mad((WorkingColorSpace_ToAP1[0].z), _1104, mad((WorkingColorSpace_ToAP1[0].y), _1103, ((WorkingColorSpace_ToAP1[0].x) * _1102)));
    float _1114 = mad((WorkingColorSpace_ToAP1[1].z), _1104, mad((WorkingColorSpace_ToAP1[1].y), _1103, ((WorkingColorSpace_ToAP1[1].x) * _1102)));
    float _1117 = mad((WorkingColorSpace_ToAP1[2].z), _1104, mad((WorkingColorSpace_ToAP1[2].y), _1103, ((WorkingColorSpace_ToAP1[2].x) * _1102)));
    _1128 = mad(_59, _1117, mad(_58, _1114, (_1111 * _57)));
    _1129 = mad(_62, _1117, mad(_61, _1114, (_1111 * _60)));
    _1130 = mad(_65, _1117, mad(_64, _1114, (_1111 * _63)));
  } else {
    _1128 = _1102;
    _1129 = _1103;
    _1130 = _1104;
  }
  if (_1128 < 0.0031306699384003878f) {
    _1141 = (_1128 * 12.920000076293945f);
  } else {
    _1141 = (((pow(_1128, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1129 < 0.0031306699384003878f) {
    _1152 = (_1129 * 12.920000076293945f);
  } else {
    _1152 = (((pow(_1129, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1130 < 0.0031306699384003878f) {
    _1163 = (_1130 * 12.920000076293945f);
  } else {
    _1163 = (((pow(_1130, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1141 * 0.9523810148239136f), (_1152 * 0.9523810148239136f), (_1163 * 0.9523810148239136f), 0.0f);
}

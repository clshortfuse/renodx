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
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _13[6];
  float _14[6];
  float _15[6];
  float _16[6];
  float _28 = 0.5f / LUTSize;
  float _33 = LUTSize + -1.0f;
  float _34 = (LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _28)) / _33;
  float _35 = (LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _28)) / _33;
  float _37 = float((uint)SV_DispatchThreadID.z) / _33;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _123;
  float _124;
  float _125;
  float _648;
  float _681;
  float _695;
  float _759;
  float _938;
  float _949;
  float _960;
  float _1157;
  float _1158;
  float _1159;
  float _1170;
  float _1181;
  float _1361;
  float _1394;
  float _1408;
  float _1447;
  float _1557;
  float _1631;
  float _1705;
  float _1784;
  float _1785;
  float _1786;
  float _1935;
  float _1968;
  float _1982;
  float _2021;
  float _2131;
  float _2205;
  float _2279;
  float _2358;
  float _2359;
  float _2360;
  float _2537;
  float _2538;
  float _2539;
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
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _76 = (pow(_34, 0.012683313339948654f));
    float _77 = (pow(_35, 0.012683313339948654f));
    float _78 = (pow(_37, 0.012683313339948654f));
    _123 = (exp2(log2(max(0.0f, (_76 + -0.8359375f)) / (18.8515625f - (_76 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _124 = (exp2(log2(max(0.0f, (_77 + -0.8359375f)) / (18.8515625f - (_77 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _125 = (exp2(log2(max(0.0f, (_78 + -0.8359375f)) / (18.8515625f - (_78 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _123 = ((exp2((_34 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _124 = ((exp2((_35 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _125 = ((exp2((_37 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _140 = mad((WorkingColorSpace_ToAP1[0].z), _125, mad((WorkingColorSpace_ToAP1[0].y), _124, ((WorkingColorSpace_ToAP1[0].x) * _123)));
  float _143 = mad((WorkingColorSpace_ToAP1[1].z), _125, mad((WorkingColorSpace_ToAP1[1].y), _124, ((WorkingColorSpace_ToAP1[1].x) * _123)));
  float _146 = mad((WorkingColorSpace_ToAP1[2].z), _125, mad((WorkingColorSpace_ToAP1[2].y), _124, ((WorkingColorSpace_ToAP1[2].x) * _123)));
  float _147 = dot(float3(_140, _143, _146), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _151 = (_140 / _147) + -1.0f;
  float _152 = (_143 / _147) + -1.0f;
  float _153 = (_146 / _147) + -1.0f;
  float _165 = (1.0f - exp2(((_147 * _147) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_151, _152, _153), float3(_151, _152, _153)) * -4.0f));
  float _181 = ((mad(-0.06368321925401688f, _146, mad(-0.3292922377586365f, _143, (_140 * 1.3704125881195068f))) - _140) * _165) + _140;
  float _182 = ((mad(-0.010861365124583244f, _146, mad(1.0970927476882935f, _143, (_140 * -0.08343357592821121f))) - _143) * _165) + _143;
  float _183 = ((mad(1.2036951780319214f, _146, mad(-0.09862580895423889f, _143, (_140 * -0.02579331398010254f))) - _146) * _165) + _146;
  float _184 = dot(float3(_181, _182, _183), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _198 = ColorOffset.w + ColorOffsetShadows.w;
  float _212 = ColorGain.w * ColorGainShadows.w;
  float _226 = ColorGamma.w * ColorGammaShadows.w;
  float _240 = ColorContrast.w * ColorContrastShadows.w;
  float _254 = ColorSaturation.w * ColorSaturationShadows.w;
  float _258 = _181 - _184;
  float _259 = _182 - _184;
  float _260 = _183 - _184;
  float _317 = saturate(_184 / ColorCorrectionShadowsMax);
  float _321 = (_317 * _317) * (3.0f - (_317 * 2.0f));
  float _322 = 1.0f - _321;
  float _331 = ColorOffset.w + ColorOffsetHighlights.w;
  float _340 = ColorGain.w * ColorGainHighlights.w;
  float _349 = ColorGamma.w * ColorGammaHighlights.w;
  float _358 = ColorContrast.w * ColorContrastHighlights.w;
  float _367 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _430 = saturate((_184 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _434 = (_430 * _430) * (3.0f - (_430 * 2.0f));
  float _443 = ColorOffset.w + ColorOffsetMidtones.w;
  float _452 = ColorGain.w * ColorGainMidtones.w;
  float _461 = ColorGamma.w * ColorGammaMidtones.w;
  float _470 = ColorContrast.w * ColorContrastMidtones.w;
  float _479 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _537 = _321 - _434;
  float _548 = ((_434 * (((ColorOffset.x + ColorOffsetHighlights.x) + _331) + (((ColorGain.x * ColorGainHighlights.x) * _340) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _358) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _367) * _258) + _184)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _349)))))) + (_322 * (((ColorOffset.x + ColorOffsetShadows.x) + _198) + (((ColorGain.x * ColorGainShadows.x) * _212) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _240) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _254) * _258) + _184)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _226))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _443) + (((ColorGain.x * ColorGainMidtones.x) * _452) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _470) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _479) * _258) + _184)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _461))))) * _537);
  float _550 = ((_434 * (((ColorOffset.y + ColorOffsetHighlights.y) + _331) + (((ColorGain.y * ColorGainHighlights.y) * _340) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _358) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _367) * _259) + _184)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _349)))))) + (_322 * (((ColorOffset.y + ColorOffsetShadows.y) + _198) + (((ColorGain.y * ColorGainShadows.y) * _212) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _240) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _254) * _259) + _184)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _226))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _443) + (((ColorGain.y * ColorGainMidtones.y) * _452) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _470) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _479) * _259) + _184)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _461))))) * _537);
  float _552 = ((_434 * (((ColorOffset.z + ColorOffsetHighlights.z) + _331) + (((ColorGain.z * ColorGainHighlights.z) * _340) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _358) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _367) * _260) + _184)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _349)))))) + (_322 * (((ColorOffset.z + ColorOffsetShadows.z) + _198) + (((ColorGain.z * ColorGainShadows.z) * _212) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _240) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _254) * _260) + _184)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _226))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _443) + (((ColorGain.z * ColorGainMidtones.z) * _452) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _470) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _479) * _260) + _184)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _461))))) * _537);
  float _588 = ((mad(0.061360642313957214f, _552, mad(-4.540197551250458e-09f, _550, (_548 * 0.9386394023895264f))) - _548) * BlueCorrection) + _548;
  float _589 = ((mad(0.169205904006958f, _552, mad(0.8307942152023315f, _550, (_548 * 6.775371730327606e-08f))) - _550) * BlueCorrection) + _550;
  float _590 = (mad(-2.3283064365386963e-10f, _550, (_548 * -9.313225746154785e-10f)) * BlueCorrection) + _552;
  float _593 = mad(0.16386905312538147f, _590, mad(0.14067868888378143f, _589, (_588 * 0.6954522132873535f)));
  float _596 = mad(0.0955343246459961f, _590, mad(0.8596711158752441f, _589, (_588 * 0.044794581830501556f)));
  float _599 = mad(1.0015007257461548f, _590, mad(0.004025210160762072f, _589, (_588 * -0.005525882821530104f)));
  float _603 = max(max(_593, _596), _599);
  float _608 = (max(_603, 1.000000013351432e-10f) - max(min(min(_593, _596), _599), 1.000000013351432e-10f)) / max(_603, 0.009999999776482582f);
  float _621 = ((_596 + _593) + _599) + (sqrt((((_599 - _596) * _599) + ((_596 - _593) * _596)) + ((_593 - _599) * _593)) * 1.75f);
  float _622 = _621 * 0.3333333432674408f;
  float _623 = _608 + -0.4000000059604645f;
  float _624 = _623 * 5.0f;
  float _628 = max((1.0f - abs(_623 * 2.5f)), 0.0f);
  float _639 = ((float(((int)(uint)((bool)(_624 > 0.0f))) - ((int)(uint)((bool)(_624 < 0.0f)))) * (1.0f - (_628 * _628))) + 1.0f) * 0.02500000037252903f;
  if (!(_622 <= 0.0533333346247673f)) {
    if (!(_622 >= 0.1599999964237213f)) {
      _648 = (((0.23999999463558197f / _621) + -0.5f) * _639);
    } else {
      _648 = 0.0f;
    }
  } else {
    _648 = _639;
  }
  float _649 = _648 + 1.0f;
  float _650 = _649 * _593;
  float _651 = _649 * _596;
  float _652 = _649 * _599;
  if (!((bool)(_650 == _651) && (bool)(_651 == _652))) {
    float _659 = ((_650 * 2.0f) - _651) - _652;
    float _662 = ((_596 - _599) * 1.7320507764816284f) * _649;
    float _664 = atan(_662 / _659);
    bool _667 = (_659 < 0.0f);
    bool _668 = (_659 == 0.0f);
    bool _669 = (_662 >= 0.0f);
    bool _670 = (_662 < 0.0f);
    _681 = select((_669 && _668), 90.0f, select((_670 && _668), -90.0f, (select((_670 && _667), (_664 + -3.1415927410125732f), select((_669 && _667), (_664 + 3.1415927410125732f), _664)) * 57.2957763671875f)));
  } else {
    _681 = 0.0f;
  }
  float _686 = min(max(select((_681 < 0.0f), (_681 + 360.0f), _681), 0.0f), 360.0f);
  if (_686 < -180.0f) {
    _695 = (_686 + 360.0f);
  } else {
    if (_686 > 180.0f) {
      _695 = (_686 + -360.0f);
    } else {
      _695 = _686;
    }
  }
  float _699 = saturate(1.0f - abs(_695 * 0.014814814552664757f));
  float _703 = (_699 * _699) * (3.0f - (_699 * 2.0f));
  float _709 = ((_703 * _703) * ((_608 * 0.18000000715255737f) * (0.029999999329447746f - _650))) + _650;
  float _719 = max(0.0f, mad(-0.21492856740951538f, _652, mad(-0.2365107536315918f, _651, (_709 * 1.4514392614364624f))));
  float _720 = max(0.0f, mad(-0.09967592358589172f, _652, mad(1.17622971534729f, _651, (_709 * -0.07655377686023712f))));
  float _721 = max(0.0f, mad(0.9977163076400757f, _652, mad(-0.006032449658960104f, _651, (_709 * 0.008316148072481155f))));
  float _722 = dot(float3(_719, _720, _721), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _737 = (FilmBlackClip + 1.0f) - FilmToe;
  float _739 = FilmWhiteClip + 1.0f;
  float _741 = _739 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _759 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _750 = (FilmBlackClip + 0.18000000715255737f) / _737;
    _759 = (-0.7447274923324585f - ((log2(_750 / (2.0f - _750)) * 0.3465735912322998f) * (_737 / FilmSlope)));
  }
  float _762 = ((1.0f - FilmToe) / FilmSlope) - _759;
  float _764 = (FilmShoulder / FilmSlope) - _762;
  float _768 = log2(lerp(_722, _719, 0.9599999785423279f)) * 0.3010300099849701f;
  float _769 = log2(lerp(_722, _720, 0.9599999785423279f)) * 0.3010300099849701f;
  float _770 = log2(lerp(_722, _721, 0.9599999785423279f)) * 0.3010300099849701f;
  float _774 = FilmSlope * (_768 + _762);
  float _775 = FilmSlope * (_769 + _762);
  float _776 = FilmSlope * (_770 + _762);
  float _777 = _737 * 2.0f;
  float _779 = (FilmSlope * -2.0f) / _737;
  float _780 = _768 - _759;
  float _781 = _769 - _759;
  float _782 = _770 - _759;
  float _801 = _741 * 2.0f;
  float _803 = (FilmSlope * 2.0f) / _741;
  float _828 = select((_768 < _759), ((_777 / (exp2((_780 * 1.4426950216293335f) * _779) + 1.0f)) - FilmBlackClip), _774);
  float _829 = select((_769 < _759), ((_777 / (exp2((_781 * 1.4426950216293335f) * _779) + 1.0f)) - FilmBlackClip), _775);
  float _830 = select((_770 < _759), ((_777 / (exp2((_782 * 1.4426950216293335f) * _779) + 1.0f)) - FilmBlackClip), _776);
  float _837 = _764 - _759;
  float _841 = saturate(_780 / _837);
  float _842 = saturate(_781 / _837);
  float _843 = saturate(_782 / _837);
  bool _844 = (_764 < _759);
  float _848 = select(_844, (1.0f - _841), _841);
  float _849 = select(_844, (1.0f - _842), _842);
  float _850 = select(_844, (1.0f - _843), _843);
  float _869 = (((_848 * _848) * (select((_768 > _764), (_739 - (_801 / (exp2(((_768 - _764) * 1.4426950216293335f) * _803) + 1.0f))), _774) - _828)) * (3.0f - (_848 * 2.0f))) + _828;
  float _870 = (((_849 * _849) * (select((_769 > _764), (_739 - (_801 / (exp2(((_769 - _764) * 1.4426950216293335f) * _803) + 1.0f))), _775) - _829)) * (3.0f - (_849 * 2.0f))) + _829;
  float _871 = (((_850 * _850) * (select((_770 > _764), (_739 - (_801 / (exp2(((_770 - _764) * 1.4426950216293335f) * _803) + 1.0f))), _776) - _830)) * (3.0f - (_850 * 2.0f))) + _830;
  float _872 = dot(float3(_869, _870, _871), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _892 = (ToneCurveAmount * (max(0.0f, (lerp(_872, _869, 0.9300000071525574f))) - _588)) + _588;
  float _893 = (ToneCurveAmount * (max(0.0f, (lerp(_872, _870, 0.9300000071525574f))) - _589)) + _589;
  float _894 = (ToneCurveAmount * (max(0.0f, (lerp(_872, _871, 0.9300000071525574f))) - _590)) + _590;
  float _910 = ((mad(-0.06537103652954102f, _894, mad(1.451815478503704e-06f, _893, (_892 * 1.065374732017517f))) - _892) * BlueCorrection) + _892;
  float _911 = ((mad(-0.20366770029067993f, _894, mad(1.2036634683609009f, _893, (_892 * -2.57161445915699e-07f))) - _893) * BlueCorrection) + _893;
  float _912 = ((mad(0.9999996423721313f, _894, mad(2.0954757928848267e-08f, _893, (_892 * 1.862645149230957e-08f))) - _894) * BlueCorrection) + _894;
  float _925 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _912, mad((WorkingColorSpace_FromAP1[0].y), _911, ((WorkingColorSpace_FromAP1[0].x) * _910)))));
  float _926 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _912, mad((WorkingColorSpace_FromAP1[1].y), _911, ((WorkingColorSpace_FromAP1[1].x) * _910)))));
  float _927 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _912, mad((WorkingColorSpace_FromAP1[2].y), _911, ((WorkingColorSpace_FromAP1[2].x) * _910)))));
  if (_925 < 0.0031306699384003878f) {
    _938 = (_925 * 12.920000076293945f);
  } else {
    _938 = (((pow(_925, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_926 < 0.0031306699384003878f) {
    _949 = (_926 * 12.920000076293945f);
  } else {
    _949 = (((pow(_926, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_927 < 0.0031306699384003878f) {
    _960 = (_927 * 12.920000076293945f);
  } else {
    _960 = (((pow(_927, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _964 = (_949 * 0.9375f) + 0.03125f;
  float _971 = _960 * 15.0f;
  float _972 = floor(_971);
  float _973 = _971 - _972;
  float _975 = (_972 + ((_938 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _978 = Textures_1.SampleLevel(Samplers_1, float2(_975, _964), 0.0f);
  float _982 = _975 + 0.0625f;
  float4 _983 = Textures_1.SampleLevel(Samplers_1, float2(_982, _964), 0.0f);
  float4 _1005 = Textures_2.SampleLevel(Samplers_2, float2(_975, _964), 0.0f);
  float4 _1009 = Textures_2.SampleLevel(Samplers_2, float2(_982, _964), 0.0f);
  float _1028 = max(6.103519990574569e-05f, ((((lerp(_978.x, _983.x, _973)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _938)) + ((lerp(_1005.x, _1009.x, _973)) * (LUTWeights[0].z))));
  float _1029 = max(6.103519990574569e-05f, ((((lerp(_978.y, _983.y, _973)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _949)) + ((lerp(_1005.y, _1009.y, _973)) * (LUTWeights[0].z))));
  float _1030 = max(6.103519990574569e-05f, ((((lerp(_978.z, _983.z, _973)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _960)) + ((lerp(_1005.z, _1009.z, _973)) * (LUTWeights[0].z))));
  float _1052 = select((_1028 > 0.040449999272823334f), exp2(log2((_1028 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1028 * 0.07739938050508499f));
  float _1053 = select((_1029 > 0.040449999272823334f), exp2(log2((_1029 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1029 * 0.07739938050508499f));
  float _1054 = select((_1030 > 0.040449999272823334f), exp2(log2((_1030 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1030 * 0.07739938050508499f));
  float _1080 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1052)) * _1052) + MappingPolynomial.z);
  float _1081 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1053)) * _1053) + MappingPolynomial.z);
  float _1082 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1054)) * _1054) + MappingPolynomial.z);
  float _1089 = ((OverlayColor.x - _1080) * OverlayColor.w) + _1080;
  float _1090 = ((OverlayColor.y - _1081) * OverlayColor.w) + _1081;
  float _1091 = ((OverlayColor.z - _1082) * OverlayColor.w) + _1082;
  float _1092 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _552, mad((WorkingColorSpace_FromAP1[0].y), _550, (_548 * (WorkingColorSpace_FromAP1[0].x))));
  float _1093 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _552, mad((WorkingColorSpace_FromAP1[1].y), _550, ((WorkingColorSpace_FromAP1[1].x) * _548)));
  float _1094 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _552, mad((WorkingColorSpace_FromAP1[2].y), _550, ((WorkingColorSpace_FromAP1[2].x) * _548)));
  float _1101 = ((OverlayColor.x - _1092) * OverlayColor.w) + _1092;
  float _1102 = ((OverlayColor.y - _1093) * OverlayColor.w) + _1093;
  float _1103 = ((OverlayColor.z - _1094) * OverlayColor.w) + _1094;
  float _1115 = exp2(log2(max(0.0f, _1089)) * InverseGamma.y);
  float _1116 = exp2(log2(max(0.0f, _1090)) * InverseGamma.y);
  float _1117 = exp2(log2(max(0.0f, _1091)) * InverseGamma.y);
  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1140 = mad((WorkingColorSpace_ToAP1[0].z), _1117, mad((WorkingColorSpace_ToAP1[0].y), _1116, ((WorkingColorSpace_ToAP1[0].x) * _1115)));
        float _1143 = mad((WorkingColorSpace_ToAP1[1].z), _1117, mad((WorkingColorSpace_ToAP1[1].y), _1116, ((WorkingColorSpace_ToAP1[1].x) * _1115)));
        float _1146 = mad((WorkingColorSpace_ToAP1[2].z), _1117, mad((WorkingColorSpace_ToAP1[2].y), _1116, ((WorkingColorSpace_ToAP1[2].x) * _1115)));
        _1157 = mad(_59, _1146, mad(_58, _1143, (_1140 * _57)));
        _1158 = mad(_62, _1146, mad(_61, _1143, (_1140 * _60)));
        _1159 = mad(_65, _1146, mad(_64, _1143, (_1140 * _63)));
      } else {
        _1157 = _1115;
        _1158 = _1116;
        _1159 = _1117;
      }
      do {
        if (_1157 < 0.0031306699384003878f) {
          _1170 = (_1157 * 12.920000076293945f);
        } else {
          _1170 = (((pow(_1157, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1158 < 0.0031306699384003878f) {
            _1181 = (_1158 * 12.920000076293945f);
          } else {
            _1181 = (((pow(_1158, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1159 < 0.0031306699384003878f) {
            _2537 = _1170;
            _2538 = _1181;
            _2539 = (_1159 * 12.920000076293945f);
          } else {
            _2537 = _1170;
            _2538 = _1181;
            _2539 = (((pow(_1159, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1208 = mad((WorkingColorSpace_ToAP1[0].z), _1117, mad((WorkingColorSpace_ToAP1[0].y), _1116, ((WorkingColorSpace_ToAP1[0].x) * _1115)));
      float _1211 = mad((WorkingColorSpace_ToAP1[1].z), _1117, mad((WorkingColorSpace_ToAP1[1].y), _1116, ((WorkingColorSpace_ToAP1[1].x) * _1115)));
      float _1214 = mad((WorkingColorSpace_ToAP1[2].z), _1117, mad((WorkingColorSpace_ToAP1[2].y), _1116, ((WorkingColorSpace_ToAP1[2].x) * _1115)));
      float _1224 = max(6.103519990574569e-05f, mad(_59, _1214, mad(_58, _1211, (_1208 * _57))));
      float _1225 = max(6.103519990574569e-05f, mad(_62, _1214, mad(_61, _1211, (_1208 * _60))));
      float _1226 = max(6.103519990574569e-05f, mad(_65, _1214, mad(_64, _1211, (_1208 * _63))));
      _2537 = min((_1224 * 4.5f), ((exp2(log2(max(_1224, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2538 = min((_1225 * 4.5f), ((exp2(log2(max(_1225, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2539 = min((_1226 * 4.5f), ((exp2(log2(max(_1226, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
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
        float _1301 = ACESSceneColorMultiplier * _1101;
        float _1302 = ACESSceneColorMultiplier * _1102;
        float _1303 = ACESSceneColorMultiplier * _1103;
        float _1306 = mad((WorkingColorSpace_ToAP0[0].z), _1303, mad((WorkingColorSpace_ToAP0[0].y), _1302, ((WorkingColorSpace_ToAP0[0].x) * _1301)));
        float _1309 = mad((WorkingColorSpace_ToAP0[1].z), _1303, mad((WorkingColorSpace_ToAP0[1].y), _1302, ((WorkingColorSpace_ToAP0[1].x) * _1301)));
        float _1312 = mad((WorkingColorSpace_ToAP0[2].z), _1303, mad((WorkingColorSpace_ToAP0[2].y), _1302, ((WorkingColorSpace_ToAP0[2].x) * _1301)));
        float _1316 = max(max(_1306, _1309), _1312);
        float _1321 = (max(_1316, 1.000000013351432e-10f) - max(min(min(_1306, _1309), _1312), 1.000000013351432e-10f)) / max(_1316, 0.009999999776482582f);
        float _1334 = ((_1309 + _1306) + _1312) + (sqrt((((_1312 - _1309) * _1312) + ((_1309 - _1306) * _1309)) + ((_1306 - _1312) * _1306)) * 1.75f);
        float _1335 = _1334 * 0.3333333432674408f;
        float _1336 = _1321 + -0.4000000059604645f;
        float _1337 = _1336 * 5.0f;
        float _1341 = max((1.0f - abs(_1336 * 2.5f)), 0.0f);
        float _1352 = ((float(((int)(uint)((bool)(_1337 > 0.0f))) - ((int)(uint)((bool)(_1337 < 0.0f)))) * (1.0f - (_1341 * _1341))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1335 <= 0.0533333346247673f)) {
            if (!(_1335 >= 0.1599999964237213f)) {
              _1361 = (((0.23999999463558197f / _1334) + -0.5f) * _1352);
            } else {
              _1361 = 0.0f;
            }
          } else {
            _1361 = _1352;
          }
          float _1362 = _1361 + 1.0f;
          float _1363 = _1362 * _1306;
          float _1364 = _1362 * _1309;
          float _1365 = _1362 * _1312;
          do {
            if (!((bool)(_1363 == _1364) && (bool)(_1364 == _1365))) {
              float _1372 = ((_1363 * 2.0f) - _1364) - _1365;
              float _1375 = ((_1309 - _1312) * 1.7320507764816284f) * _1362;
              float _1377 = atan(_1375 / _1372);
              bool _1380 = (_1372 < 0.0f);
              bool _1381 = (_1372 == 0.0f);
              bool _1382 = (_1375 >= 0.0f);
              bool _1383 = (_1375 < 0.0f);
              _1394 = select((_1382 && _1381), 90.0f, select((_1383 && _1381), -90.0f, (select((_1383 && _1380), (_1377 + -3.1415927410125732f), select((_1382 && _1380), (_1377 + 3.1415927410125732f), _1377)) * 57.2957763671875f)));
            } else {
              _1394 = 0.0f;
            }
            float _1399 = min(max(select((_1394 < 0.0f), (_1394 + 360.0f), _1394), 0.0f), 360.0f);
            do {
              if (_1399 < -180.0f) {
                _1408 = (_1399 + 360.0f);
              } else {
                if (_1399 > 180.0f) {
                  _1408 = (_1399 + -360.0f);
                } else {
                  _1408 = _1399;
                }
              }
              do {
                if ((bool)(_1408 > -67.5f) && (bool)(_1408 < 67.5f)) {
                  float _1414 = (_1408 + 67.5f) * 0.029629629105329514f;
                  int _1415 = int(_1414);
                  float _1417 = _1414 - float(_1415);
                  float _1418 = _1417 * _1417;
                  float _1419 = _1418 * _1417;
                  if (_1415 == 3) {
                    _1447 = (((0.1666666716337204f - (_1417 * 0.5f)) + (_1418 * 0.5f)) - (_1419 * 0.1666666716337204f));
                  } else {
                    if (_1415 == 2) {
                      _1447 = ((0.6666666865348816f - _1418) + (_1419 * 0.5f));
                    } else {
                      if (_1415 == 1) {
                        _1447 = (((_1419 * -0.5f) + 0.1666666716337204f) + ((_1418 + _1417) * 0.5f));
                      } else {
                        _1447 = select((_1415 == 0), (_1419 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1447 = 0.0f;
                }
                float _1456 = min(max(((((_1321 * 0.27000001072883606f) * (0.029999999329447746f - _1363)) * _1447) + _1363), 0.0f), 65535.0f);
                float _1457 = min(max(_1364, 0.0f), 65535.0f);
                float _1458 = min(max(_1365, 0.0f), 65535.0f);
                float _1471 = min(max(mad(-0.21492856740951538f, _1458, mad(-0.2365107536315918f, _1457, (_1456 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1472 = min(max(mad(-0.09967592358589172f, _1458, mad(1.17622971534729f, _1457, (_1456 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1473 = min(max(mad(0.9977163076400757f, _1458, mad(-0.006032449658960104f, _1457, (_1456 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1474 = dot(float3(_1471, _1472, _1473), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1485 = log2(max((lerp(_1474, _1471, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1486 = _1485 * 0.3010300099849701f;
                float _1487 = log2(ACESMinMaxData.x);
                float _1488 = _1487 * 0.3010300099849701f;
                do {
                  if (!(!(_1486 <= _1488))) {
                    _1557 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1495 = log2(ACESMidData.x);
                    float _1496 = _1495 * 0.3010300099849701f;
                    if ((bool)(_1486 > _1488) && (bool)(_1486 < _1496)) {
                      float _1504 = ((_1485 - _1487) * 0.9030900001525879f) / ((_1495 - _1487) * 0.3010300099849701f);
                      int _1505 = int(_1504);
                      float _1507 = _1504 - float(_1505);
                      float _1509 = _15[_1505];
                      float _1512 = _15[(_1505 + 1)];
                      float _1517 = _1509 * 0.5f;
                      _1557 = dot(float3((_1507 * _1507), _1507, 1.0f), float3(mad((_15[(_1505 + 2)]), 0.5f, mad(_1512, -1.0f, _1517)), (_1512 - _1509), mad(_1512, 0.5f, _1517)));
                    } else {
                      do {
                        if (!(!(_1486 >= _1496))) {
                          float _1526 = log2(ACESMinMaxData.z);
                          if (_1486 < (_1526 * 0.3010300099849701f)) {
                            float _1534 = ((_1485 - _1495) * 0.9030900001525879f) / ((_1526 - _1495) * 0.3010300099849701f);
                            int _1535 = int(_1534);
                            float _1537 = _1534 - float(_1535);
                            float _1539 = _16[_1535];
                            float _1542 = _16[(_1535 + 1)];
                            float _1547 = _1539 * 0.5f;
                            _1557 = dot(float3((_1537 * _1537), _1537, 1.0f), float3(mad((_16[(_1535 + 2)]), 0.5f, mad(_1542, -1.0f, _1547)), (_1542 - _1539), mad(_1542, 0.5f, _1547)));
                            break;
                          }
                        }
                        _1557 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1561 = log2(max((lerp(_1474, _1472, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1562 = _1561 * 0.3010300099849701f;
                  do {
                    if (!(!(_1562 <= _1488))) {
                      _1631 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1569 = log2(ACESMidData.x);
                      float _1570 = _1569 * 0.3010300099849701f;
                      if ((bool)(_1562 > _1488) && (bool)(_1562 < _1570)) {
                        float _1578 = ((_1561 - _1487) * 0.9030900001525879f) / ((_1569 - _1487) * 0.3010300099849701f);
                        int _1579 = int(_1578);
                        float _1581 = _1578 - float(_1579);
                        float _1583 = _15[_1579];
                        float _1586 = _15[(_1579 + 1)];
                        float _1591 = _1583 * 0.5f;
                        _1631 = dot(float3((_1581 * _1581), _1581, 1.0f), float3(mad((_15[(_1579 + 2)]), 0.5f, mad(_1586, -1.0f, _1591)), (_1586 - _1583), mad(_1586, 0.5f, _1591)));
                      } else {
                        do {
                          if (!(!(_1562 >= _1570))) {
                            float _1600 = log2(ACESMinMaxData.z);
                            if (_1562 < (_1600 * 0.3010300099849701f)) {
                              float _1608 = ((_1561 - _1569) * 0.9030900001525879f) / ((_1600 - _1569) * 0.3010300099849701f);
                              int _1609 = int(_1608);
                              float _1611 = _1608 - float(_1609);
                              float _1613 = _16[_1609];
                              float _1616 = _16[(_1609 + 1)];
                              float _1621 = _1613 * 0.5f;
                              _1631 = dot(float3((_1611 * _1611), _1611, 1.0f), float3(mad((_16[(_1609 + 2)]), 0.5f, mad(_1616, -1.0f, _1621)), (_1616 - _1613), mad(_1616, 0.5f, _1621)));
                              break;
                            }
                          }
                          _1631 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1635 = log2(max((lerp(_1474, _1473, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1636 = _1635 * 0.3010300099849701f;
                    do {
                      if (!(!(_1636 <= _1488))) {
                        _1705 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1643 = log2(ACESMidData.x);
                        float _1644 = _1643 * 0.3010300099849701f;
                        if ((bool)(_1636 > _1488) && (bool)(_1636 < _1644)) {
                          float _1652 = ((_1635 - _1487) * 0.9030900001525879f) / ((_1643 - _1487) * 0.3010300099849701f);
                          int _1653 = int(_1652);
                          float _1655 = _1652 - float(_1653);
                          float _1657 = _15[_1653];
                          float _1660 = _15[(_1653 + 1)];
                          float _1665 = _1657 * 0.5f;
                          _1705 = dot(float3((_1655 * _1655), _1655, 1.0f), float3(mad((_15[(_1653 + 2)]), 0.5f, mad(_1660, -1.0f, _1665)), (_1660 - _1657), mad(_1660, 0.5f, _1665)));
                        } else {
                          do {
                            if (!(!(_1636 >= _1644))) {
                              float _1674 = log2(ACESMinMaxData.z);
                              if (_1636 < (_1674 * 0.3010300099849701f)) {
                                float _1682 = ((_1635 - _1643) * 0.9030900001525879f) / ((_1674 - _1643) * 0.3010300099849701f);
                                int _1683 = int(_1682);
                                float _1685 = _1682 - float(_1683);
                                float _1687 = _16[_1683];
                                float _1690 = _16[(_1683 + 1)];
                                float _1695 = _1687 * 0.5f;
                                _1705 = dot(float3((_1685 * _1685), _1685, 1.0f), float3(mad((_16[(_1683 + 2)]), 0.5f, mad(_1690, -1.0f, _1695)), (_1690 - _1687), mad(_1690, 0.5f, _1695)));
                                break;
                              }
                            }
                            _1705 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1709 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1710 = (exp2(_1557 * 3.321928024291992f) - ACESMinMaxData.y) / _1709;
                      float _1712 = (exp2(_1631 * 3.321928024291992f) - ACESMinMaxData.y) / _1709;
                      float _1714 = (exp2(_1705 * 3.321928024291992f) - ACESMinMaxData.y) / _1709;
                      float _1717 = mad(0.15618768334388733f, _1714, mad(0.13400420546531677f, _1712, (_1710 * 0.6624541878700256f)));
                      float _1720 = mad(0.053689517080783844f, _1714, mad(0.6740817427635193f, _1712, (_1710 * 0.2722287178039551f)));
                      float _1723 = mad(1.0103391408920288f, _1714, mad(0.00406073359772563f, _1712, (_1710 * -0.005574649665504694f)));
                      float _1736 = min(max(mad(-0.23642469942569733f, _1723, mad(-0.32480329275131226f, _1720, (_1717 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1737 = min(max(mad(0.016756348311901093f, _1723, mad(1.6153316497802734f, _1720, (_1717 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1738 = min(max(mad(0.9883948564529419f, _1723, mad(-0.008284442126750946f, _1720, (_1717 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1741 = mad(0.15618768334388733f, _1738, mad(0.13400420546531677f, _1737, (_1736 * 0.6624541878700256f)));
                      float _1744 = mad(0.053689517080783844f, _1738, mad(0.6740817427635193f, _1737, (_1736 * 0.2722287178039551f)));
                      float _1747 = mad(1.0103391408920288f, _1738, mad(0.00406073359772563f, _1737, (_1736 * -0.005574649665504694f)));
                      float _1769 = min(max((min(max(mad(-0.23642469942569733f, _1747, mad(-0.32480329275131226f, _1744, (_1741 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1770 = min(max((min(max(mad(0.016756348311901093f, _1747, mad(1.6153316497802734f, _1744, (_1741 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1771 = min(max((min(max(mad(0.9883948564529419f, _1747, mad(-0.008284442126750946f, _1744, (_1741 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(OutputDevice) == 5)) {
                          _1784 = mad(_59, _1771, mad(_58, _1770, (_1769 * _57)));
                          _1785 = mad(_62, _1771, mad(_61, _1770, (_1769 * _60)));
                          _1786 = mad(_65, _1771, mad(_64, _1770, (_1769 * _63)));
                        } else {
                          _1784 = _1769;
                          _1785 = _1770;
                          _1786 = _1771;
                        }
                        float _1796 = exp2(log2(_1784 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1797 = exp2(log2(_1785 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1798 = exp2(log2(_1786 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2537 = exp2(log2((1.0f / ((_1796 * 18.6875f) + 1.0f)) * ((_1796 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2538 = exp2(log2((1.0f / ((_1797 * 18.6875f) + 1.0f)) * ((_1797 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2539 = exp2(log2((1.0f / ((_1798 * 18.6875f) + 1.0f)) * ((_1798 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          _13[0] = ACESCoefsLow_0.x;
          _13[1] = ACESCoefsLow_0.y;
          _13[2] = ACESCoefsLow_0.z;
          _13[3] = ACESCoefsLow_0.w;
          _13[4] = ACESCoefsLow_4;
          _13[5] = ACESCoefsLow_4;
          _14[0] = ACESCoefsHigh_0.x;
          _14[1] = ACESCoefsHigh_0.y;
          _14[2] = ACESCoefsHigh_0.z;
          _14[3] = ACESCoefsHigh_0.w;
          _14[4] = ACESCoefsHigh_4;
          _14[5] = ACESCoefsHigh_4;
          float _1875 = ACESSceneColorMultiplier * _1101;
          float _1876 = ACESSceneColorMultiplier * _1102;
          float _1877 = ACESSceneColorMultiplier * _1103;
          float _1880 = mad((WorkingColorSpace_ToAP0[0].z), _1877, mad((WorkingColorSpace_ToAP0[0].y), _1876, ((WorkingColorSpace_ToAP0[0].x) * _1875)));
          float _1883 = mad((WorkingColorSpace_ToAP0[1].z), _1877, mad((WorkingColorSpace_ToAP0[1].y), _1876, ((WorkingColorSpace_ToAP0[1].x) * _1875)));
          float _1886 = mad((WorkingColorSpace_ToAP0[2].z), _1877, mad((WorkingColorSpace_ToAP0[2].y), _1876, ((WorkingColorSpace_ToAP0[2].x) * _1875)));
          float _1890 = max(max(_1880, _1883), _1886);
          float _1895 = (max(_1890, 1.000000013351432e-10f) - max(min(min(_1880, _1883), _1886), 1.000000013351432e-10f)) / max(_1890, 0.009999999776482582f);
          float _1908 = ((_1883 + _1880) + _1886) + (sqrt((((_1886 - _1883) * _1886) + ((_1883 - _1880) * _1883)) + ((_1880 - _1886) * _1880)) * 1.75f);
          float _1909 = _1908 * 0.3333333432674408f;
          float _1910 = _1895 + -0.4000000059604645f;
          float _1911 = _1910 * 5.0f;
          float _1915 = max((1.0f - abs(_1910 * 2.5f)), 0.0f);
          float _1926 = ((float(((int)(uint)((bool)(_1911 > 0.0f))) - ((int)(uint)((bool)(_1911 < 0.0f)))) * (1.0f - (_1915 * _1915))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1909 <= 0.0533333346247673f)) {
              if (!(_1909 >= 0.1599999964237213f)) {
                _1935 = (((0.23999999463558197f / _1908) + -0.5f) * _1926);
              } else {
                _1935 = 0.0f;
              }
            } else {
              _1935 = _1926;
            }
            float _1936 = _1935 + 1.0f;
            float _1937 = _1936 * _1880;
            float _1938 = _1936 * _1883;
            float _1939 = _1936 * _1886;
            do {
              if (!((bool)(_1937 == _1938) && (bool)(_1938 == _1939))) {
                float _1946 = ((_1937 * 2.0f) - _1938) - _1939;
                float _1949 = ((_1883 - _1886) * 1.7320507764816284f) * _1936;
                float _1951 = atan(_1949 / _1946);
                bool _1954 = (_1946 < 0.0f);
                bool _1955 = (_1946 == 0.0f);
                bool _1956 = (_1949 >= 0.0f);
                bool _1957 = (_1949 < 0.0f);
                _1968 = select((_1956 && _1955), 90.0f, select((_1957 && _1955), -90.0f, (select((_1957 && _1954), (_1951 + -3.1415927410125732f), select((_1956 && _1954), (_1951 + 3.1415927410125732f), _1951)) * 57.2957763671875f)));
              } else {
                _1968 = 0.0f;
              }
              float _1973 = min(max(select((_1968 < 0.0f), (_1968 + 360.0f), _1968), 0.0f), 360.0f);
              do {
                if (_1973 < -180.0f) {
                  _1982 = (_1973 + 360.0f);
                } else {
                  if (_1973 > 180.0f) {
                    _1982 = (_1973 + -360.0f);
                  } else {
                    _1982 = _1973;
                  }
                }
                do {
                  if ((bool)(_1982 > -67.5f) && (bool)(_1982 < 67.5f)) {
                    float _1988 = (_1982 + 67.5f) * 0.029629629105329514f;
                    int _1989 = int(_1988);
                    float _1991 = _1988 - float(_1989);
                    float _1992 = _1991 * _1991;
                    float _1993 = _1992 * _1991;
                    if (_1989 == 3) {
                      _2021 = (((0.1666666716337204f - (_1991 * 0.5f)) + (_1992 * 0.5f)) - (_1993 * 0.1666666716337204f));
                    } else {
                      if (_1989 == 2) {
                        _2021 = ((0.6666666865348816f - _1992) + (_1993 * 0.5f));
                      } else {
                        if (_1989 == 1) {
                          _2021 = (((_1993 * -0.5f) + 0.1666666716337204f) + ((_1992 + _1991) * 0.5f));
                        } else {
                          _2021 = select((_1989 == 0), (_1993 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2021 = 0.0f;
                  }
                  float _2030 = min(max(((((_1895 * 0.27000001072883606f) * (0.029999999329447746f - _1937)) * _2021) + _1937), 0.0f), 65535.0f);
                  float _2031 = min(max(_1938, 0.0f), 65535.0f);
                  float _2032 = min(max(_1939, 0.0f), 65535.0f);
                  float _2045 = min(max(mad(-0.21492856740951538f, _2032, mad(-0.2365107536315918f, _2031, (_2030 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2046 = min(max(mad(-0.09967592358589172f, _2032, mad(1.17622971534729f, _2031, (_2030 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2047 = min(max(mad(0.9977163076400757f, _2032, mad(-0.006032449658960104f, _2031, (_2030 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2048 = dot(float3(_2045, _2046, _2047), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2059 = log2(max((lerp(_2048, _2045, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2060 = _2059 * 0.3010300099849701f;
                  float _2061 = log2(ACESMinMaxData.x);
                  float _2062 = _2061 * 0.3010300099849701f;
                  do {
                    if (!(!(_2060 <= _2062))) {
                      _2131 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2069 = log2(ACESMidData.x);
                      float _2070 = _2069 * 0.3010300099849701f;
                      if ((bool)(_2060 > _2062) && (bool)(_2060 < _2070)) {
                        float _2078 = ((_2059 - _2061) * 0.9030900001525879f) / ((_2069 - _2061) * 0.3010300099849701f);
                        int _2079 = int(_2078);
                        float _2081 = _2078 - float(_2079);
                        float _2083 = _13[_2079];
                        float _2086 = _13[(_2079 + 1)];
                        float _2091 = _2083 * 0.5f;
                        _2131 = dot(float3((_2081 * _2081), _2081, 1.0f), float3(mad((_13[(_2079 + 2)]), 0.5f, mad(_2086, -1.0f, _2091)), (_2086 - _2083), mad(_2086, 0.5f, _2091)));
                      } else {
                        do {
                          if (!(!(_2060 >= _2070))) {
                            float _2100 = log2(ACESMinMaxData.z);
                            if (_2060 < (_2100 * 0.3010300099849701f)) {
                              float _2108 = ((_2059 - _2069) * 0.9030900001525879f) / ((_2100 - _2069) * 0.3010300099849701f);
                              int _2109 = int(_2108);
                              float _2111 = _2108 - float(_2109);
                              float _2113 = _14[_2109];
                              float _2116 = _14[(_2109 + 1)];
                              float _2121 = _2113 * 0.5f;
                              _2131 = dot(float3((_2111 * _2111), _2111, 1.0f), float3(mad((_14[(_2109 + 2)]), 0.5f, mad(_2116, -1.0f, _2121)), (_2116 - _2113), mad(_2116, 0.5f, _2121)));
                              break;
                            }
                          }
                          _2131 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2135 = log2(max((lerp(_2048, _2046, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2136 = _2135 * 0.3010300099849701f;
                    do {
                      if (!(!(_2136 <= _2062))) {
                        _2205 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2143 = log2(ACESMidData.x);
                        float _2144 = _2143 * 0.3010300099849701f;
                        if ((bool)(_2136 > _2062) && (bool)(_2136 < _2144)) {
                          float _2152 = ((_2135 - _2061) * 0.9030900001525879f) / ((_2143 - _2061) * 0.3010300099849701f);
                          int _2153 = int(_2152);
                          float _2155 = _2152 - float(_2153);
                          float _2157 = _13[_2153];
                          float _2160 = _13[(_2153 + 1)];
                          float _2165 = _2157 * 0.5f;
                          _2205 = dot(float3((_2155 * _2155), _2155, 1.0f), float3(mad((_13[(_2153 + 2)]), 0.5f, mad(_2160, -1.0f, _2165)), (_2160 - _2157), mad(_2160, 0.5f, _2165)));
                        } else {
                          do {
                            if (!(!(_2136 >= _2144))) {
                              float _2174 = log2(ACESMinMaxData.z);
                              if (_2136 < (_2174 * 0.3010300099849701f)) {
                                float _2182 = ((_2135 - _2143) * 0.9030900001525879f) / ((_2174 - _2143) * 0.3010300099849701f);
                                int _2183 = int(_2182);
                                float _2185 = _2182 - float(_2183);
                                float _2187 = _14[_2183];
                                float _2190 = _14[(_2183 + 1)];
                                float _2195 = _2187 * 0.5f;
                                _2205 = dot(float3((_2185 * _2185), _2185, 1.0f), float3(mad((_14[(_2183 + 2)]), 0.5f, mad(_2190, -1.0f, _2195)), (_2190 - _2187), mad(_2190, 0.5f, _2195)));
                                break;
                              }
                            }
                            _2205 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2209 = log2(max((lerp(_2048, _2047, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2210 = _2209 * 0.3010300099849701f;
                      do {
                        if (!(!(_2210 <= _2062))) {
                          _2279 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2217 = log2(ACESMidData.x);
                          float _2218 = _2217 * 0.3010300099849701f;
                          if ((bool)(_2210 > _2062) && (bool)(_2210 < _2218)) {
                            float _2226 = ((_2209 - _2061) * 0.9030900001525879f) / ((_2217 - _2061) * 0.3010300099849701f);
                            int _2227 = int(_2226);
                            float _2229 = _2226 - float(_2227);
                            float _2231 = _13[_2227];
                            float _2234 = _13[(_2227 + 1)];
                            float _2239 = _2231 * 0.5f;
                            _2279 = dot(float3((_2229 * _2229), _2229, 1.0f), float3(mad((_13[(_2227 + 2)]), 0.5f, mad(_2234, -1.0f, _2239)), (_2234 - _2231), mad(_2234, 0.5f, _2239)));
                          } else {
                            do {
                              if (!(!(_2210 >= _2218))) {
                                float _2248 = log2(ACESMinMaxData.z);
                                if (_2210 < (_2248 * 0.3010300099849701f)) {
                                  float _2256 = ((_2209 - _2217) * 0.9030900001525879f) / ((_2248 - _2217) * 0.3010300099849701f);
                                  int _2257 = int(_2256);
                                  float _2259 = _2256 - float(_2257);
                                  float _2261 = _14[_2257];
                                  float _2264 = _14[(_2257 + 1)];
                                  float _2269 = _2261 * 0.5f;
                                  _2279 = dot(float3((_2259 * _2259), _2259, 1.0f), float3(mad((_14[(_2257 + 2)]), 0.5f, mad(_2264, -1.0f, _2269)), (_2264 - _2261), mad(_2264, 0.5f, _2269)));
                                  break;
                                }
                              }
                              _2279 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2283 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2284 = (exp2(_2131 * 3.321928024291992f) - ACESMinMaxData.y) / _2283;
                        float _2286 = (exp2(_2205 * 3.321928024291992f) - ACESMinMaxData.y) / _2283;
                        float _2288 = (exp2(_2279 * 3.321928024291992f) - ACESMinMaxData.y) / _2283;
                        float _2291 = mad(0.15618768334388733f, _2288, mad(0.13400420546531677f, _2286, (_2284 * 0.6624541878700256f)));
                        float _2294 = mad(0.053689517080783844f, _2288, mad(0.6740817427635193f, _2286, (_2284 * 0.2722287178039551f)));
                        float _2297 = mad(1.0103391408920288f, _2288, mad(0.00406073359772563f, _2286, (_2284 * -0.005574649665504694f)));
                        float _2310 = min(max(mad(-0.23642469942569733f, _2297, mad(-0.32480329275131226f, _2294, (_2291 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2311 = min(max(mad(0.016756348311901093f, _2297, mad(1.6153316497802734f, _2294, (_2291 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2312 = min(max(mad(0.9883948564529419f, _2297, mad(-0.008284442126750946f, _2294, (_2291 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2315 = mad(0.15618768334388733f, _2312, mad(0.13400420546531677f, _2311, (_2310 * 0.6624541878700256f)));
                        float _2318 = mad(0.053689517080783844f, _2312, mad(0.6740817427635193f, _2311, (_2310 * 0.2722287178039551f)));
                        float _2321 = mad(1.0103391408920288f, _2312, mad(0.00406073359772563f, _2311, (_2310 * -0.005574649665504694f)));
                        float _2343 = min(max((min(max(mad(-0.23642469942569733f, _2321, mad(-0.32480329275131226f, _2318, (_2315 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2344 = min(max((min(max(mad(0.016756348311901093f, _2321, mad(1.6153316497802734f, _2318, (_2315 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2345 = min(max((min(max(mad(0.9883948564529419f, _2321, mad(-0.008284442126750946f, _2318, (_2315 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 6)) {
                            _2358 = mad(_59, _2345, mad(_58, _2344, (_2343 * _57)));
                            _2359 = mad(_62, _2345, mad(_61, _2344, (_2343 * _60)));
                            _2360 = mad(_65, _2345, mad(_64, _2344, (_2343 * _63)));
                          } else {
                            _2358 = _2343;
                            _2359 = _2344;
                            _2360 = _2345;
                          }
                          float _2370 = exp2(log2(_2358 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2371 = exp2(log2(_2359 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2372 = exp2(log2(_2360 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2537 = exp2(log2((1.0f / ((_2370 * 18.6875f) + 1.0f)) * ((_2370 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2538 = exp2(log2((1.0f / ((_2371 * 18.6875f) + 1.0f)) * ((_2371 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2539 = exp2(log2((1.0f / ((_2372 * 18.6875f) + 1.0f)) * ((_2372 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2417 = mad((WorkingColorSpace_ToAP1[0].z), _1103, mad((WorkingColorSpace_ToAP1[0].y), _1102, ((WorkingColorSpace_ToAP1[0].x) * _1101)));
            float _2420 = mad((WorkingColorSpace_ToAP1[1].z), _1103, mad((WorkingColorSpace_ToAP1[1].y), _1102, ((WorkingColorSpace_ToAP1[1].x) * _1101)));
            float _2423 = mad((WorkingColorSpace_ToAP1[2].z), _1103, mad((WorkingColorSpace_ToAP1[2].y), _1102, ((WorkingColorSpace_ToAP1[2].x) * _1101)));
            float _2442 = exp2(log2(mad(_59, _2423, mad(_58, _2420, (_2417 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2443 = exp2(log2(mad(_62, _2423, mad(_61, _2420, (_2417 * _60))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2444 = exp2(log2(mad(_65, _2423, mad(_64, _2420, (_2417 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2537 = exp2(log2((1.0f / ((_2442 * 18.6875f) + 1.0f)) * ((_2442 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2538 = exp2(log2((1.0f / ((_2443 * 18.6875f) + 1.0f)) * ((_2443 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2539 = exp2(log2((1.0f / ((_2444 * 18.6875f) + 1.0f)) * ((_2444 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2491 = mad((WorkingColorSpace_ToAP1[0].z), _1091, mad((WorkingColorSpace_ToAP1[0].y), _1090, ((WorkingColorSpace_ToAP1[0].x) * _1089)));
                float _2494 = mad((WorkingColorSpace_ToAP1[1].z), _1091, mad((WorkingColorSpace_ToAP1[1].y), _1090, ((WorkingColorSpace_ToAP1[1].x) * _1089)));
                float _2497 = mad((WorkingColorSpace_ToAP1[2].z), _1091, mad((WorkingColorSpace_ToAP1[2].y), _1090, ((WorkingColorSpace_ToAP1[2].x) * _1089)));
                _2537 = mad(_59, _2497, mad(_58, _2494, (_2491 * _57)));
                _2538 = mad(_62, _2497, mad(_61, _2494, (_2491 * _60)));
                _2539 = mad(_65, _2497, mad(_64, _2494, (_2491 * _63)));
              } else {
                float _2510 = mad((WorkingColorSpace_ToAP1[0].z), _1117, mad((WorkingColorSpace_ToAP1[0].y), _1116, ((WorkingColorSpace_ToAP1[0].x) * _1115)));
                float _2513 = mad((WorkingColorSpace_ToAP1[1].z), _1117, mad((WorkingColorSpace_ToAP1[1].y), _1116, ((WorkingColorSpace_ToAP1[1].x) * _1115)));
                float _2516 = mad((WorkingColorSpace_ToAP1[2].z), _1117, mad((WorkingColorSpace_ToAP1[2].y), _1116, ((WorkingColorSpace_ToAP1[2].x) * _1115)));
                _2537 = exp2(log2(mad(_59, _2516, mad(_58, _2513, (_2510 * _57)))) * InverseGamma.z);
                _2538 = exp2(log2(mad(_62, _2516, mad(_61, _2513, (_2510 * _60)))) * InverseGamma.z);
                _2539 = exp2(log2(mad(_65, _2516, mad(_64, _2513, (_2510 * _63)))) * InverseGamma.z);
              }
            } else {
              _2537 = _1101;
              _2538 = _1102;
              _2539 = _1103;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2537 * 0.9523810148239136f), (_2538 * 0.9523810148239136f), (_2539 * 0.9523810148239136f), 0.0f);
}

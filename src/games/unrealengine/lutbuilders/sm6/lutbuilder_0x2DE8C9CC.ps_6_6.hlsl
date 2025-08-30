#include "../../common.hlsl"

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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _10 = 0.5f / LUTSize;
  float _15 = LUTSize + -1.0f;
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _110;
  float _820;
  float _853;
  float _867;
  float _931;
  float _1183;
  float _1184;
  float _1185;
  float _1196;
  float _1207;
  float _1218;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _28 = (OutputGamut == 4);
        _39 = select(_28, 1.0f, 1.705051064491272f);
        _40 = select(_28, 0.0f, -0.6217921376228333f);
        _41 = select(_28, 0.0f, -0.0832589864730835f);
        _42 = select(_28, 0.0f, -0.13025647401809692f);
        _43 = select(_28, 1.0f, 1.140804648399353f);
        _44 = select(_28, 0.0f, -0.010548308491706848f);
        _45 = select(_28, 0.0f, -0.024003351107239723f);
        _46 = select(_28, 0.0f, -0.1289689838886261f);
        _47 = select(_28, 1.0f, 1.1529725790023804f);
      } else {
        _39 = 0.6954522132873535f;
        _40 = 0.14067870378494263f;
        _41 = 0.16386906802654266f;
        _42 = 0.044794563204050064f;
        _43 = 0.8596711158752441f;
        _44 = 0.0955343171954155f;
        _45 = -0.005525882821530104f;
        _46 = 0.004025210160762072f;
        _47 = 1.0015007257461548f;
      }
    } else {
      _39 = 1.0258246660232544f;
      _40 = -0.020053181797266006f;
      _41 = -0.005771636962890625f;
      _42 = -0.002234415616840124f;
      _43 = 1.0045864582061768f;
      _44 = -0.002352118492126465f;
      _45 = -0.005013350863009691f;
      _46 = -0.025290070101618767f;
      _47 = 1.0303035974502563f;
    }
  } else {
    _39 = 1.3792141675949097f;
    _40 = -0.30886411666870117f;
    _41 = -0.0703500509262085f;
    _42 = -0.06933490186929703f;
    _43 = 1.08229660987854f;
    _44 = -0.012961871922016144f;
    _45 = -0.0021590073592960835f;
    _46 = -0.0454593189060688f;
    _47 = 1.0476183891296387f;
  }
  float _60 = (exp2((((LUTSize * (TEXCOORD.x - _10)) / _15) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _61 = (exp2((((LUTSize * (TEXCOORD.y - _10)) / _15) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _62 = (exp2(((float((uint)(int)(SV_RenderTargetArrayIndex)) / _15) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _89 = (bIsTemperatureWhiteBalance != 0);
  float _93 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _110 = (((((2967800.0f - (_93 * 4607000064.0f)) * _93) + 99.11000061035156f) * _93) + 0.24406300485134125f);
  } else {
    _110 = (((((1901800.0f - (_93 * 2006400000.0f)) * _93) + 247.47999572753906f) * _93) + 0.23703999817371368f);
  }
  float _124 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _131 = WhiteTemp * WhiteTemp;
  float _134 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_131 * 1.6145605741257896e-07f));
  float _139 = ((_124 * 2.0f) + 4.0f) - (_134 * 8.0f);
  float _140 = (_124 * 3.0f) / _139;
  float _142 = (_134 * 2.0f) / _139;
  bool _143 = (WhiteTemp < 4000.0f);
  float _152 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _154 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_131 * 1.5317699909210205f)) / (_152 * _152);
  float _161 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _131;
  float _163 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_131 * 308.60699462890625f)) / (_161 * _161);
  float _165 = rsqrt(dot(float2(_154, _163), float2(_154, _163)));
  float _166 = WhiteTint * 0.05000000074505806f;
  float _169 = ((_166 * _163) * _165) + _124;
  float _172 = _134 - ((_166 * _154) * _165);
  float _177 = (4.0f - (_172 * 8.0f)) + (_169 * 2.0f);
  float _183 = (((_169 * 3.0f) / _177) - _140) + select(_143, _140, _110);
  float _184 = (((_172 * 2.0f) / _177) - _142) + select(_143, _142, (((_110 * 2.869999885559082f) + -0.2750000059604645f) - ((_110 * _110) * 3.0f)));
  float _185 = select(_89, _183, 0.3127000033855438f);
  float _186 = select(_89, _184, 0.32899999618530273f);
  float _187 = select(_89, 0.3127000033855438f, _183);
  float _188 = select(_89, 0.32899999618530273f, _184);
  float _189 = max(_186, 1.000000013351432e-10f);
  float _190 = _185 / _189;
  float _193 = ((1.0f - _185) - _186) / _189;
  float _194 = max(_188, 1.000000013351432e-10f);
  float _195 = _187 / _194;
  float _198 = ((1.0f - _187) - _188) / _194;
  float _217 = mad(-0.16140000522136688f, _198, ((_195 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _193, ((_190 * 0.8950999975204468f) + 0.266400009393692f));
  float _218 = mad(0.03669999912381172f, _198, (1.7135000228881836f - (_195 * 0.7501999735832214f))) / mad(0.03669999912381172f, _193, (1.7135000228881836f - (_190 * 0.7501999735832214f)));
  float _219 = mad(1.0296000242233276f, _198, ((_195 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _193, ((_190 * 0.03889999911189079f) + -0.06849999725818634f));
  float _220 = mad(_218, -0.7501999735832214f, 0.0f);
  float _221 = mad(_218, 1.7135000228881836f, 0.0f);
  float _222 = mad(_218, 0.03669999912381172f, -0.0f);
  float _223 = mad(_219, 0.03889999911189079f, 0.0f);
  float _224 = mad(_219, -0.06849999725818634f, 0.0f);
  float _225 = mad(_219, 1.0296000242233276f, 0.0f);
  float _228 = mad(0.1599626988172531f, _223, mad(-0.1470542997121811f, _220, (_217 * 0.883457362651825f)));
  float _231 = mad(0.1599626988172531f, _224, mad(-0.1470542997121811f, _221, (_217 * 0.26293492317199707f)));
  float _234 = mad(0.1599626988172531f, _225, mad(-0.1470542997121811f, _222, (_217 * -0.15930065512657166f)));
  float _237 = mad(0.04929120093584061f, _223, mad(0.5183603167533875f, _220, (_217 * 0.38695648312568665f)));
  float _240 = mad(0.04929120093584061f, _224, mad(0.5183603167533875f, _221, (_217 * 0.11516613513231277f)));
  float _243 = mad(0.04929120093584061f, _225, mad(0.5183603167533875f, _222, (_217 * -0.0697740763425827f)));
  float _246 = mad(0.9684867262840271f, _223, mad(0.04004279896616936f, _220, (_217 * -0.007634039502590895f)));
  float _249 = mad(0.9684867262840271f, _224, mad(0.04004279896616936f, _221, (_217 * -0.0022720457054674625f)));
  float _252 = mad(0.9684867262840271f, _225, mad(0.04004279896616936f, _222, (_217 * 0.0013765322510153055f)));
  float _255 = mad(_234, (WorkingColorSpace_ToXYZ[2].x), mad(_231, (WorkingColorSpace_ToXYZ[1].x), (_228 * (WorkingColorSpace_ToXYZ[0].x))));
  float _258 = mad(_234, (WorkingColorSpace_ToXYZ[2].y), mad(_231, (WorkingColorSpace_ToXYZ[1].y), (_228 * (WorkingColorSpace_ToXYZ[0].y))));
  float _261 = mad(_234, (WorkingColorSpace_ToXYZ[2].z), mad(_231, (WorkingColorSpace_ToXYZ[1].z), (_228 * (WorkingColorSpace_ToXYZ[0].z))));
  float _264 = mad(_243, (WorkingColorSpace_ToXYZ[2].x), mad(_240, (WorkingColorSpace_ToXYZ[1].x), (_237 * (WorkingColorSpace_ToXYZ[0].x))));
  float _267 = mad(_243, (WorkingColorSpace_ToXYZ[2].y), mad(_240, (WorkingColorSpace_ToXYZ[1].y), (_237 * (WorkingColorSpace_ToXYZ[0].y))));
  float _270 = mad(_243, (WorkingColorSpace_ToXYZ[2].z), mad(_240, (WorkingColorSpace_ToXYZ[1].z), (_237 * (WorkingColorSpace_ToXYZ[0].z))));
  float _273 = mad(_252, (WorkingColorSpace_ToXYZ[2].x), mad(_249, (WorkingColorSpace_ToXYZ[1].x), (_246 * (WorkingColorSpace_ToXYZ[0].x))));
  float _276 = mad(_252, (WorkingColorSpace_ToXYZ[2].y), mad(_249, (WorkingColorSpace_ToXYZ[1].y), (_246 * (WorkingColorSpace_ToXYZ[0].y))));
  float _279 = mad(_252, (WorkingColorSpace_ToXYZ[2].z), mad(_249, (WorkingColorSpace_ToXYZ[1].z), (_246 * (WorkingColorSpace_ToXYZ[0].z))));
  float _309 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _279, mad((WorkingColorSpace_FromXYZ[0].y), _270, (_261 * (WorkingColorSpace_FromXYZ[0].x)))), _62, mad(mad((WorkingColorSpace_FromXYZ[0].z), _276, mad((WorkingColorSpace_FromXYZ[0].y), _267, (_258 * (WorkingColorSpace_FromXYZ[0].x)))), _61, (mad((WorkingColorSpace_FromXYZ[0].z), _273, mad((WorkingColorSpace_FromXYZ[0].y), _264, (_255 * (WorkingColorSpace_FromXYZ[0].x)))) * _60)));
  float _312 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _279, mad((WorkingColorSpace_FromXYZ[1].y), _270, (_261 * (WorkingColorSpace_FromXYZ[1].x)))), _62, mad(mad((WorkingColorSpace_FromXYZ[1].z), _276, mad((WorkingColorSpace_FromXYZ[1].y), _267, (_258 * (WorkingColorSpace_FromXYZ[1].x)))), _61, (mad((WorkingColorSpace_FromXYZ[1].z), _273, mad((WorkingColorSpace_FromXYZ[1].y), _264, (_255 * (WorkingColorSpace_FromXYZ[1].x)))) * _60)));
  float _315 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _279, mad((WorkingColorSpace_FromXYZ[2].y), _270, (_261 * (WorkingColorSpace_FromXYZ[2].x)))), _62, mad(mad((WorkingColorSpace_FromXYZ[2].z), _276, mad((WorkingColorSpace_FromXYZ[2].y), _267, (_258 * (WorkingColorSpace_FromXYZ[2].x)))), _61, (mad((WorkingColorSpace_FromXYZ[2].z), _273, mad((WorkingColorSpace_FromXYZ[2].y), _264, (_255 * (WorkingColorSpace_FromXYZ[2].x)))) * _60)));
  float _330 = mad((WorkingColorSpace_ToAP1[0].z), _315, mad((WorkingColorSpace_ToAP1[0].y), _312, ((WorkingColorSpace_ToAP1[0].x) * _309)));
  float _333 = mad((WorkingColorSpace_ToAP1[1].z), _315, mad((WorkingColorSpace_ToAP1[1].y), _312, ((WorkingColorSpace_ToAP1[1].x) * _309)));
  float _336 = mad((WorkingColorSpace_ToAP1[2].z), _315, mad((WorkingColorSpace_ToAP1[2].y), _312, ((WorkingColorSpace_ToAP1[2].x) * _309)));
  float _337 = dot(float3(_330, _333, _336), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_330, _333, _336));

  float _341 = (_330 / _337) + -1.0f;
  float _342 = (_333 / _337) + -1.0f;
  float _343 = (_336 / _337) + -1.0f;
  float _355 = (1.0f - exp2(((_337 * _337) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_341, _342, _343), float3(_341, _342, _343)) * -4.0f));
  float _371 = ((mad(-0.06368321925401688f, _336, mad(-0.3292922377586365f, _333, (_330 * 1.3704125881195068f))) - _330) * _355) + _330;
  float _372 = ((mad(-0.010861365124583244f, _336, mad(1.0970927476882935f, _333, (_330 * -0.08343357592821121f))) - _333) * _355) + _333;
  float _373 = ((mad(1.2036951780319214f, _336, mad(-0.09862580895423889f, _333, (_330 * -0.02579331398010254f))) - _336) * _355) + _336;
  float _374 = dot(float3(_371, _372, _373), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _388 = ColorOffset.w + ColorOffsetShadows.w;
  float _402 = ColorGain.w * ColorGainShadows.w;
  float _416 = ColorGamma.w * ColorGammaShadows.w;
  float _430 = ColorContrast.w * ColorContrastShadows.w;
  float _444 = ColorSaturation.w * ColorSaturationShadows.w;
  float _448 = _371 - _374;
  float _449 = _372 - _374;
  float _450 = _373 - _374;
  float _507 = saturate(_374 / ColorCorrectionShadowsMax);
  float _511 = (_507 * _507) * (3.0f - (_507 * 2.0f));
  float _512 = 1.0f - _511;
  float _521 = ColorOffset.w + ColorOffsetHighlights.w;
  float _530 = ColorGain.w * ColorGainHighlights.w;
  float _539 = ColorGamma.w * ColorGammaHighlights.w;
  float _548 = ColorContrast.w * ColorContrastHighlights.w;
  float _557 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _620 = saturate((_374 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _624 = (_620 * _620) * (3.0f - (_620 * 2.0f));
  float _636 = ColorOffset.w + ColorOffsetMidtones.w;
  float _645 = ColorGain.w * ColorGainMidtones.w;
  float _654 = ColorGamma.w * ColorGammaMidtones.w;
  float _663 = ColorContrast.w * ColorContrastMidtones.w;
  float _672 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _730 = _511 - _624;
  float _741 = ((_624 * min(1e+05f, (((ColorOffset.x + ColorOffsetHighlights.x) + _521) + (((ColorGain.x * ColorGainHighlights.x) * _530) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _548) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _557) * _448) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _539))))))) + (_512 * (((ColorOffset.x + ColorOffsetShadows.x) + _388) + (((ColorGain.x * ColorGainShadows.x) * _402) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _430) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _444) * _448) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _416))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _636) + (((ColorGain.x * ColorGainMidtones.x) * _645) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _663) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _672) * _448) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _654))))) * _730);
  float _743 = ((_624 * min(1e+05f, (((ColorOffset.y + ColorOffsetHighlights.y) + _521) + (((ColorGain.y * ColorGainHighlights.y) * _530) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _548) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _557) * _449) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _539))))))) + (_512 * (((ColorOffset.y + ColorOffsetShadows.y) + _388) + (((ColorGain.y * ColorGainShadows.y) * _402) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _430) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _444) * _449) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _416))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _636) + (((ColorGain.y * ColorGainMidtones.y) * _645) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _663) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _672) * _449) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _654))))) * _730);
  float _745 = ((min(1e+05f, (((ColorOffset.z + ColorOffsetHighlights.z) + _521) + (((ColorGain.z * ColorGainHighlights.z) * _530) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _548) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _557) * _450) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _539)))))) * _624) + (_512 * (((ColorOffset.z + ColorOffsetShadows.z) + _388) + (((ColorGain.z * ColorGainShadows.z) * _402) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _430) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _444) * _450) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _416))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _636) + (((ColorGain.z * ColorGainMidtones.z) * _645) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _663) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _672) * _450) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _654))))) * _730);

  SetUntonemappedAP1(float3(_741, _743, _745));

  float _760 = ((mad(0.061360642313957214f, _745, mad(-4.540197551250458e-09f, _743, (_741 * 0.9386394023895264f))) - _741) * BlueCorrection) + _741;
  float _761 = ((mad(0.169205904006958f, _745, mad(0.8307942152023315f, _743, (_741 * 6.775371730327606e-08f))) - _743) * BlueCorrection) + _743;
  float _762 = (mad(-2.3283064365386963e-10f, _743, (_741 * -9.313225746154785e-10f)) * BlueCorrection) + _745;
  float _765 = mad(0.16386905312538147f, _762, mad(0.14067868888378143f, _761, (_760 * 0.6954522132873535f)));
  float _768 = mad(0.0955343246459961f, _762, mad(0.8596711158752441f, _761, (_760 * 0.044794581830501556f)));
  float _771 = mad(1.0015007257461548f, _762, mad(0.004025210160762072f, _761, (_760 * -0.005525882821530104f)));
  float _775 = max(max(_765, _768), _771);
  float _780 = (max(_775, 1.000000013351432e-10f) - max(min(min(_765, _768), _771), 1.000000013351432e-10f)) / max(_775, 0.009999999776482582f);
  float _793 = ((_768 + _765) + _771) + (sqrt((((_771 - _768) * _771) + ((_768 - _765) * _768)) + ((_765 - _771) * _765)) * 1.75f);
  float _794 = _793 * 0.3333333432674408f;
  float _795 = _780 + -0.4000000059604645f;
  float _796 = _795 * 5.0f;
  float _800 = max((1.0f - abs(_795 * 2.5f)), 0.0f);
  float _811 = ((float((int)(((int)(uint)((bool)(_796 > 0.0f))) - ((int)(uint)((bool)(_796 < 0.0f))))) * (1.0f - (_800 * _800))) + 1.0f) * 0.02500000037252903f;
  if (!(_794 <= 0.0533333346247673f)) {
    if (!(_794 >= 0.1599999964237213f)) {
      _820 = (((0.23999999463558197f / _793) + -0.5f) * _811);
    } else {
      _820 = 0.0f;
    }
  } else {
    _820 = _811;
  }
  float _821 = _820 + 1.0f;
  float _822 = _821 * _765;
  float _823 = _821 * _768;
  float _824 = _821 * _771;
  if (!((bool)(_822 == _823) && (bool)(_823 == _824))) {
    float _831 = ((_822 * 2.0f) - _823) - _824;
    float _834 = ((_768 - _771) * 1.7320507764816284f) * _821;
    float _836 = atan(_834 / _831);
    bool _839 = (_831 < 0.0f);
    bool _840 = (_831 == 0.0f);
    bool _841 = (_834 >= 0.0f);
    bool _842 = (_834 < 0.0f);
    _853 = select((_841 && _840), 90.0f, select((_842 && _840), -90.0f, (select((_842 && _839), (_836 + -3.1415927410125732f), select((_841 && _839), (_836 + 3.1415927410125732f), _836)) * 57.2957763671875f)));
  } else {
    _853 = 0.0f;
  }
  float _858 = min(max(select((_853 < 0.0f), (_853 + 360.0f), _853), 0.0f), 360.0f);
  if (_858 < -180.0f) {
    _867 = (_858 + 360.0f);
  } else {
    if (_858 > 180.0f) {
      _867 = (_858 + -360.0f);
    } else {
      _867 = _858;
    }
  }
  float _871 = saturate(1.0f - abs(_867 * 0.014814814552664757f));
  float _875 = (_871 * _871) * (3.0f - (_871 * 2.0f));
  float _881 = ((_875 * _875) * ((_780 * 0.18000000715255737f) * (0.029999999329447746f - _822))) + _822;
  float _891 = max(0.0f, mad(-0.21492856740951538f, _824, mad(-0.2365107536315918f, _823, (_881 * 1.4514392614364624f))));
  float _892 = max(0.0f, mad(-0.09967592358589172f, _824, mad(1.17622971534729f, _823, (_881 * -0.07655377686023712f))));
  float _893 = max(0.0f, mad(0.9977163076400757f, _824, mad(-0.006032449658960104f, _823, (_881 * 0.008316148072481155f))));
  float _894 = dot(float3(_891, _892, _893), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _909 = (FilmBlackClip + 1.0f) - FilmToe;
  float _911 = FilmWhiteClip + 1.0f;
  float _913 = _911 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _931 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _922 = (FilmBlackClip + 0.18000000715255737f) / _909;
    _931 = (-0.7447274923324585f - ((log2(_922 / (2.0f - _922)) * 0.3465735912322998f) * (_909 / FilmSlope)));
  }
  float _934 = ((1.0f - FilmToe) / FilmSlope) - _931;
  float _936 = (FilmShoulder / FilmSlope) - _934;
  float _940 = log2(lerp(_894, _891, 0.9599999785423279f)) * 0.3010300099849701f;
  float _941 = log2(lerp(_894, _892, 0.9599999785423279f)) * 0.3010300099849701f;
  float _942 = log2(lerp(_894, _893, 0.9599999785423279f)) * 0.3010300099849701f;
  float _946 = FilmSlope * (_940 + _934);
  float _947 = FilmSlope * (_941 + _934);
  float _948 = FilmSlope * (_942 + _934);
  float _949 = _909 * 2.0f;
  float _951 = (FilmSlope * -2.0f) / _909;
  float _952 = _940 - _931;
  float _953 = _941 - _931;
  float _954 = _942 - _931;
  float _973 = _913 * 2.0f;
  float _975 = (FilmSlope * 2.0f) / _913;
  float _1000 = select((_940 < _931), ((_949 / (exp2((_952 * 1.4426950216293335f) * _951) + 1.0f)) - FilmBlackClip), _946);
  float _1001 = select((_941 < _931), ((_949 / (exp2((_953 * 1.4426950216293335f) * _951) + 1.0f)) - FilmBlackClip), _947);
  float _1002 = select((_942 < _931), ((_949 / (exp2((_954 * 1.4426950216293335f) * _951) + 1.0f)) - FilmBlackClip), _948);
  float _1009 = _936 - _931;
  float _1013 = saturate(_952 / _1009);
  float _1014 = saturate(_953 / _1009);
  float _1015 = saturate(_954 / _1009);
  bool _1016 = (_936 < _931);
  float _1020 = select(_1016, (1.0f - _1013), _1013);
  float _1021 = select(_1016, (1.0f - _1014), _1014);
  float _1022 = select(_1016, (1.0f - _1015), _1015);
  float _1041 = (((_1020 * _1020) * (select((_940 > _936), (_911 - (_973 / (exp2(((_940 - _936) * 1.4426950216293335f) * _975) + 1.0f))), _946) - _1000)) * (3.0f - (_1020 * 2.0f))) + _1000;
  float _1042 = (((_1021 * _1021) * (select((_941 > _936), (_911 - (_973 / (exp2(((_941 - _936) * 1.4426950216293335f) * _975) + 1.0f))), _947) - _1001)) * (3.0f - (_1021 * 2.0f))) + _1001;
  float _1043 = (((_1022 * _1022) * (select((_942 > _936), (_911 - (_973 / (exp2(((_942 - _936) * 1.4426950216293335f) * _975) + 1.0f))), _948) - _1002)) * (3.0f - (_1022 * 2.0f))) + _1002;
  float _1044 = dot(float3(_1041, _1042, _1043), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1064 = (ToneCurveAmount * (max(0.0f, (lerp(_1044, _1041, 0.9300000071525574f))) - _760)) + _760;
  float _1065 = (ToneCurveAmount * (max(0.0f, (lerp(_1044, _1042, 0.9300000071525574f))) - _761)) + _761;
  float _1066 = (ToneCurveAmount * (max(0.0f, (lerp(_1044, _1043, 0.9300000071525574f))) - _762)) + _762;
  float _1082 = ((mad(-0.06537103652954102f, _1066, mad(1.451815478503704e-06f, _1065, (_1064 * 1.065374732017517f))) - _1064) * BlueCorrection) + _1064;
  float _1083 = ((mad(-0.20366770029067993f, _1066, mad(1.2036634683609009f, _1065, (_1064 * -2.57161445915699e-07f))) - _1065) * BlueCorrection) + _1065;
  float _1084 = ((mad(0.9999996423721313f, _1066, mad(2.0954757928848267e-08f, _1065, (_1064 * 1.862645149230957e-08f))) - _1066) * BlueCorrection) + _1066;

  SetTonemappedAP1(_1082, _1083, _1084);

  float _1106 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1084, mad((WorkingColorSpace_FromAP1[0].y), _1083, ((WorkingColorSpace_FromAP1[0].x) * _1082))));
  float _1107 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1084, mad((WorkingColorSpace_FromAP1[1].y), _1083, ((WorkingColorSpace_FromAP1[1].x) * _1082))));
  float _1108 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1084, mad((WorkingColorSpace_FromAP1[2].y), _1083, ((WorkingColorSpace_FromAP1[2].x) * _1082))));
  float _1134 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1106)) * _1106) + MappingPolynomial.z);
  float _1135 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1107)) * _1107) + MappingPolynomial.z);
  float _1136 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1108)) * _1108) + MappingPolynomial.z);
  float _1157 = exp2(log2(max(0.0f, (lerp(_1134, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1158 = exp2(log2(max(0.0f, (lerp(_1135, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1159 = exp2(log2(max(0.0f, (lerp(_1136, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1157, _1158, _1159), OutputDevice);
  }

  if (WorkingColorSpace_bIsSRGB == 0) {
    float _1166 = mad((WorkingColorSpace_ToAP1[0].z), _1159, mad((WorkingColorSpace_ToAP1[0].y), _1158, ((WorkingColorSpace_ToAP1[0].x) * _1157)));
    float _1169 = mad((WorkingColorSpace_ToAP1[1].z), _1159, mad((WorkingColorSpace_ToAP1[1].y), _1158, ((WorkingColorSpace_ToAP1[1].x) * _1157)));
    float _1172 = mad((WorkingColorSpace_ToAP1[2].z), _1159, mad((WorkingColorSpace_ToAP1[2].y), _1158, ((WorkingColorSpace_ToAP1[2].x) * _1157)));
    _1183 = mad(_41, _1172, mad(_40, _1169, (_1166 * _39)));
    _1184 = mad(_44, _1172, mad(_43, _1169, (_1166 * _42)));
    _1185 = mad(_47, _1172, mad(_46, _1169, (_1166 * _45)));
  } else {
    _1183 = _1157;
    _1184 = _1158;
    _1185 = _1159;
  }
  if (_1183 < 0.0031306699384003878f) {
    _1196 = (_1183 * 12.920000076293945f);
  } else {
    _1196 = (((pow(_1183, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1184 < 0.0031306699384003878f) {
    _1207 = (_1184 * 12.920000076293945f);
  } else {
    _1207 = (((pow(_1184, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1185 < 0.0031306699384003878f) {
    _1218 = (_1185 * 12.920000076293945f);
  } else {
    _1218 = (((pow(_1185, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1196 * 0.9523810148239136f);
  SV_Target.y = (_1207 * 0.9523810148239136f);
  SV_Target.z = (_1218 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

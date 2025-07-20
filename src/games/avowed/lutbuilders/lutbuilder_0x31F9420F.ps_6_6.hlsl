#include "../common.hlsl"

// Found in Ready or Not

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

Texture2D<float4> Textures_3 : register(t2);

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

SamplerState Samplers_2 : register(s1);

SamplerState Samplers_3 : register(s2);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _16 = 0.5f / LUTSize;
  float _21 = LUTSize + -1.0f;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _116;
  float _823;
  float _856;
  float _870;
  float _934;
  float _1125;
  float _1136;
  float _1147;
  float _1362;
  float _1363;
  float _1364;
  float _1375;
  float _1386;
  float _1397;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _34 = ((uint)(OutputGamut) == 4);
        _45 = select(_34, 1.0f, 1.705051064491272f);
        _46 = select(_34, 0.0f, -0.6217921376228333f);
        _47 = select(_34, 0.0f, -0.0832589864730835f);
        _48 = select(_34, 0.0f, -0.13025647401809692f);
        _49 = select(_34, 1.0f, 1.140804648399353f);
        _50 = select(_34, 0.0f, -0.010548308491706848f);
        _51 = select(_34, 0.0f, -0.024003351107239723f);
        _52 = select(_34, 0.0f, -0.1289689838886261f);
        _53 = select(_34, 1.0f, 1.1529725790023804f);
      } else {
        _45 = 0.6954522132873535f;
        _46 = 0.14067870378494263f;
        _47 = 0.16386906802654266f;
        _48 = 0.044794563204050064f;
        _49 = 0.8596711158752441f;
        _50 = 0.0955343171954155f;
        _51 = -0.005525882821530104f;
        _52 = 0.004025210160762072f;
        _53 = 1.0015007257461548f;
      }
    } else {
      _45 = 1.0258246660232544f;
      _46 = -0.020053181797266006f;
      _47 = -0.005771636962890625f;
      _48 = -0.002234415616840124f;
      _49 = 1.0045864582061768f;
      _50 = -0.002352118492126465f;
      _51 = -0.005013350863009691f;
      _52 = -0.025290070101618767f;
      _53 = 1.0303035974502563f;
    }
  } else {
    _45 = 1.3792141675949097f;
    _46 = -0.30886411666870117f;
    _47 = -0.0703500509262085f;
    _48 = -0.06933490186929703f;
    _49 = 1.08229660987854f;
    _50 = -0.012961871922016144f;
    _51 = -0.0021590073592960835f;
    _52 = -0.0454593189060688f;
    _53 = 1.0476183891296387f;
  }
  float _66 = (exp2((((LUTSize * (TEXCOORD.x - _16)) / _21) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _67 = (exp2((((LUTSize * (TEXCOORD.y - _16)) / _21) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _68 = (exp2(((float((uint)SV_RenderTargetArrayIndex) / _21) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _95 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _99 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _116 = (((((2967800.0f - (_99 * 4607000064.0f)) * _99) + 99.11000061035156f) * _99) + 0.24406300485134125f);
  } else {
    _116 = (((((1901800.0f - (_99 * 2006400000.0f)) * _99) + 247.47999572753906f) * _99) + 0.23703999817371368f);
  }
  float _130 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _137 = WhiteTemp * WhiteTemp;
  float _140 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_137 * 1.6145605741257896e-07f));
  float _145 = ((_130 * 2.0f) + 4.0f) - (_140 * 8.0f);
  float _146 = (_130 * 3.0f) / _145;
  float _148 = (_140 * 2.0f) / _145;
  bool _149 = (WhiteTemp < 4000.0f);
  float _158 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _160 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_137 * 1.5317699909210205f)) / (_158 * _158);
  float _167 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _137;
  float _169 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_137 * 308.60699462890625f)) / (_167 * _167);
  float _171 = rsqrt(dot(float2(_160, _169), float2(_160, _169)));
  float _172 = WhiteTint * 0.05000000074505806f;
  float _175 = ((_172 * _169) * _171) + _130;
  float _178 = _140 - ((_172 * _160) * _171);
  float _183 = (4.0f - (_178 * 8.0f)) + (_175 * 2.0f);
  float _189 = (((_175 * 3.0f) / _183) - _146) + select(_149, _146, _116);
  float _190 = (((_178 * 2.0f) / _183) - _148) + select(_149, _148, (((_116 * 2.869999885559082f) + -0.2750000059604645f) - ((_116 * _116) * 3.0f)));
  float _191 = select(_95, _189, 0.3127000033855438f);
  float _192 = select(_95, _190, 0.32899999618530273f);
  float _193 = select(_95, 0.3127000033855438f, _189);
  float _194 = select(_95, 0.32899999618530273f, _190);
  float _195 = max(_192, 1.000000013351432e-10f);
  float _196 = _191 / _195;
  float _199 = ((1.0f - _191) - _192) / _195;
  float _200 = max(_194, 1.000000013351432e-10f);
  float _201 = _193 / _200;
  float _204 = ((1.0f - _193) - _194) / _200;
  float _223 = mad(-0.16140000522136688f, _204, ((_201 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _199, ((_196 * 0.8950999975204468f) + 0.266400009393692f));
  float _224 = mad(0.03669999912381172f, _204, (1.7135000228881836f - (_201 * 0.7501999735832214f))) / mad(0.03669999912381172f, _199, (1.7135000228881836f - (_196 * 0.7501999735832214f)));
  float _225 = mad(1.0296000242233276f, _204, ((_201 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _199, ((_196 * 0.03889999911189079f) + -0.06849999725818634f));
  float _226 = mad(_224, -0.7501999735832214f, 0.0f);
  float _227 = mad(_224, 1.7135000228881836f, 0.0f);
  float _228 = mad(_224, 0.03669999912381172f, -0.0f);
  float _229 = mad(_225, 0.03889999911189079f, 0.0f);
  float _230 = mad(_225, -0.06849999725818634f, 0.0f);
  float _231 = mad(_225, 1.0296000242233276f, 0.0f);
  float _234 = mad(0.1599626988172531f, _229, mad(-0.1470542997121811f, _226, (_223 * 0.883457362651825f)));
  float _237 = mad(0.1599626988172531f, _230, mad(-0.1470542997121811f, _227, (_223 * 0.26293492317199707f)));
  float _240 = mad(0.1599626988172531f, _231, mad(-0.1470542997121811f, _228, (_223 * -0.15930065512657166f)));
  float _243 = mad(0.04929120093584061f, _229, mad(0.5183603167533875f, _226, (_223 * 0.38695648312568665f)));
  float _246 = mad(0.04929120093584061f, _230, mad(0.5183603167533875f, _227, (_223 * 0.11516613513231277f)));
  float _249 = mad(0.04929120093584061f, _231, mad(0.5183603167533875f, _228, (_223 * -0.0697740763425827f)));
  float _252 = mad(0.9684867262840271f, _229, mad(0.04004279896616936f, _226, (_223 * -0.007634039502590895f)));
  float _255 = mad(0.9684867262840271f, _230, mad(0.04004279896616936f, _227, (_223 * -0.0022720457054674625f)));
  float _258 = mad(0.9684867262840271f, _231, mad(0.04004279896616936f, _228, (_223 * 0.0013765322510153055f)));
  float _261 = mad(_240, (WorkingColorSpace_ToXYZ[2].x), mad(_237, (WorkingColorSpace_ToXYZ[1].x), (_234 * (WorkingColorSpace_ToXYZ[0].x))));
  float _264 = mad(_240, (WorkingColorSpace_ToXYZ[2].y), mad(_237, (WorkingColorSpace_ToXYZ[1].y), (_234 * (WorkingColorSpace_ToXYZ[0].y))));
  float _267 = mad(_240, (WorkingColorSpace_ToXYZ[2].z), mad(_237, (WorkingColorSpace_ToXYZ[1].z), (_234 * (WorkingColorSpace_ToXYZ[0].z))));
  float _270 = mad(_249, (WorkingColorSpace_ToXYZ[2].x), mad(_246, (WorkingColorSpace_ToXYZ[1].x), (_243 * (WorkingColorSpace_ToXYZ[0].x))));
  float _273 = mad(_249, (WorkingColorSpace_ToXYZ[2].y), mad(_246, (WorkingColorSpace_ToXYZ[1].y), (_243 * (WorkingColorSpace_ToXYZ[0].y))));
  float _276 = mad(_249, (WorkingColorSpace_ToXYZ[2].z), mad(_246, (WorkingColorSpace_ToXYZ[1].z), (_243 * (WorkingColorSpace_ToXYZ[0].z))));
  float _279 = mad(_258, (WorkingColorSpace_ToXYZ[2].x), mad(_255, (WorkingColorSpace_ToXYZ[1].x), (_252 * (WorkingColorSpace_ToXYZ[0].x))));
  float _282 = mad(_258, (WorkingColorSpace_ToXYZ[2].y), mad(_255, (WorkingColorSpace_ToXYZ[1].y), (_252 * (WorkingColorSpace_ToXYZ[0].y))));
  float _285 = mad(_258, (WorkingColorSpace_ToXYZ[2].z), mad(_255, (WorkingColorSpace_ToXYZ[1].z), (_252 * (WorkingColorSpace_ToXYZ[0].z))));
  float _315 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _285, mad((WorkingColorSpace_FromXYZ[0].y), _276, (_267 * (WorkingColorSpace_FromXYZ[0].x)))), _68, mad(mad((WorkingColorSpace_FromXYZ[0].z), _282, mad((WorkingColorSpace_FromXYZ[0].y), _273, (_264 * (WorkingColorSpace_FromXYZ[0].x)))), _67, (mad((WorkingColorSpace_FromXYZ[0].z), _279, mad((WorkingColorSpace_FromXYZ[0].y), _270, (_261 * (WorkingColorSpace_FromXYZ[0].x)))) * _66)));
  float _318 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _285, mad((WorkingColorSpace_FromXYZ[1].y), _276, (_267 * (WorkingColorSpace_FromXYZ[1].x)))), _68, mad(mad((WorkingColorSpace_FromXYZ[1].z), _282, mad((WorkingColorSpace_FromXYZ[1].y), _273, (_264 * (WorkingColorSpace_FromXYZ[1].x)))), _67, (mad((WorkingColorSpace_FromXYZ[1].z), _279, mad((WorkingColorSpace_FromXYZ[1].y), _270, (_261 * (WorkingColorSpace_FromXYZ[1].x)))) * _66)));
  float _321 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _285, mad((WorkingColorSpace_FromXYZ[2].y), _276, (_267 * (WorkingColorSpace_FromXYZ[2].x)))), _68, mad(mad((WorkingColorSpace_FromXYZ[2].z), _282, mad((WorkingColorSpace_FromXYZ[2].y), _273, (_264 * (WorkingColorSpace_FromXYZ[2].x)))), _67, (mad((WorkingColorSpace_FromXYZ[2].z), _279, mad((WorkingColorSpace_FromXYZ[2].y), _270, (_261 * (WorkingColorSpace_FromXYZ[2].x)))) * _66)));
  float _336 = mad((WorkingColorSpace_ToAP1[0].z), _321, mad((WorkingColorSpace_ToAP1[0].y), _318, ((WorkingColorSpace_ToAP1[0].x) * _315)));
  float _339 = mad((WorkingColorSpace_ToAP1[1].z), _321, mad((WorkingColorSpace_ToAP1[1].y), _318, ((WorkingColorSpace_ToAP1[1].x) * _315)));
  float _342 = mad((WorkingColorSpace_ToAP1[2].z), _321, mad((WorkingColorSpace_ToAP1[2].y), _318, ((WorkingColorSpace_ToAP1[2].x) * _315)));
  float _343 = dot(float3(_336, _339, _342), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_336, _339, _342));

  float _347 = (_336 / _343) + -1.0f;
  float _348 = (_339 / _343) + -1.0f;
  float _349 = (_342 / _343) + -1.0f;
  float _361 = (1.0f - exp2(((_343 * _343) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_347, _348, _349), float3(_347, _348, _349)) * -4.0f));
  float _377 = ((mad(-0.06368321925401688f, _342, mad(-0.3292922377586365f, _339, (_336 * 1.3704125881195068f))) - _336) * _361) + _336;
  float _378 = ((mad(-0.010861365124583244f, _342, mad(1.0970927476882935f, _339, (_336 * -0.08343357592821121f))) - _339) * _361) + _339;
  float _379 = ((mad(1.2036951780319214f, _342, mad(-0.09862580895423889f, _339, (_336 * -0.02579331398010254f))) - _342) * _361) + _342;
  float _380 = dot(float3(_377, _378, _379), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _394 = ColorOffset.w + ColorOffsetShadows.w;
  float _408 = ColorGain.w * ColorGainShadows.w;
  float _422 = ColorGamma.w * ColorGammaShadows.w;
  float _436 = ColorContrast.w * ColorContrastShadows.w;
  float _450 = ColorSaturation.w * ColorSaturationShadows.w;
  float _454 = _377 - _380;
  float _455 = _378 - _380;
  float _456 = _379 - _380;
  float _513 = saturate(_380 / ColorCorrectionShadowsMax);
  float _517 = (_513 * _513) * (3.0f - (_513 * 2.0f));
  float _518 = 1.0f - _517;
  float _527 = ColorOffset.w + ColorOffsetHighlights.w;
  float _536 = ColorGain.w * ColorGainHighlights.w;
  float _545 = ColorGamma.w * ColorGammaHighlights.w;
  float _554 = ColorContrast.w * ColorContrastHighlights.w;
  float _563 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _626 = saturate((_380 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _630 = (_626 * _626) * (3.0f - (_626 * 2.0f));
  float _639 = ColorOffset.w + ColorOffsetMidtones.w;
  float _648 = ColorGain.w * ColorGainMidtones.w;
  float _657 = ColorGamma.w * ColorGammaMidtones.w;
  float _666 = ColorContrast.w * ColorContrastMidtones.w;
  float _675 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _733 = _517 - _630;
  float _744 = ((_630 * (((ColorOffset.x + ColorOffsetHighlights.x) + _527) + (((ColorGain.x * ColorGainHighlights.x) * _536) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _554) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _563) * _454) + _380)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _545)))))) + (_518 * (((ColorOffset.x + ColorOffsetShadows.x) + _394) + (((ColorGain.x * ColorGainShadows.x) * _408) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _436) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _450) * _454) + _380)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _422))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _639) + (((ColorGain.x * ColorGainMidtones.x) * _648) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _666) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _675) * _454) + _380)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _657))))) * _733);
  float _746 = ((_630 * (((ColorOffset.y + ColorOffsetHighlights.y) + _527) + (((ColorGain.y * ColorGainHighlights.y) * _536) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _554) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _563) * _455) + _380)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _545)))))) + (_518 * (((ColorOffset.y + ColorOffsetShadows.y) + _394) + (((ColorGain.y * ColorGainShadows.y) * _408) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _436) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _450) * _455) + _380)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _422))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _639) + (((ColorGain.y * ColorGainMidtones.y) * _648) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _666) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _675) * _455) + _380)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _657))))) * _733);
  float _748 = ((_630 * (((ColorOffset.z + ColorOffsetHighlights.z) + _527) + (((ColorGain.z * ColorGainHighlights.z) * _536) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _554) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _563) * _456) + _380)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _545)))))) + (_518 * (((ColorOffset.z + ColorOffsetShadows.z) + _394) + (((ColorGain.z * ColorGainShadows.z) * _408) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _436) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _450) * _456) + _380)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _422))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _639) + (((ColorGain.z * ColorGainMidtones.z) * _648) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _666) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _675) * _456) + _380)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _657))))) * _733);

  SetUntonemappedAP1(float3(_744, _746, _748));

  float _763 = ((mad(0.061360642313957214f, _748, mad(-4.540197551250458e-09f, _746, (_744 * 0.9386394023895264f))) - _744) * BlueCorrection) + _744;
  float _764 = ((mad(0.169205904006958f, _748, mad(0.8307942152023315f, _746, (_744 * 6.775371730327606e-08f))) - _746) * BlueCorrection) + _746;
  float _765 = (mad(-2.3283064365386963e-10f, _746, (_744 * -9.313225746154785e-10f)) * BlueCorrection) + _748;
  float _768 = mad(0.16386905312538147f, _765, mad(0.14067868888378143f, _764, (_763 * 0.6954522132873535f)));
  float _771 = mad(0.0955343246459961f, _765, mad(0.8596711158752441f, _764, (_763 * 0.044794581830501556f)));
  float _774 = mad(1.0015007257461548f, _765, mad(0.004025210160762072f, _764, (_763 * -0.005525882821530104f)));
  float _778 = max(max(_768, _771), _774);
  float _783 = (max(_778, 1.000000013351432e-10f) - max(min(min(_768, _771), _774), 1.000000013351432e-10f)) / max(_778, 0.009999999776482582f);
  float _796 = ((_771 + _768) + _774) + (sqrt((((_774 - _771) * _774) + ((_771 - _768) * _771)) + ((_768 - _774) * _768)) * 1.75f);
  float _797 = _796 * 0.3333333432674408f;
  float _798 = _783 + -0.4000000059604645f;
  float _799 = _798 * 5.0f;
  float _803 = max((1.0f - abs(_798 * 2.5f)), 0.0f);
  float _814 = ((float(((int)(uint)((bool)(_799 > 0.0f))) - ((int)(uint)((bool)(_799 < 0.0f)))) * (1.0f - (_803 * _803))) + 1.0f) * 0.02500000037252903f;
  if (!(_797 <= 0.0533333346247673f)) {
    if (!(_797 >= 0.1599999964237213f)) {
      _823 = (((0.23999999463558197f / _796) + -0.5f) * _814);
    } else {
      _823 = 0.0f;
    }
  } else {
    _823 = _814;
  }
  float _824 = _823 + 1.0f;
  float _825 = _824 * _768;
  float _826 = _824 * _771;
  float _827 = _824 * _774;
  if (!((bool)(_825 == _826) && (bool)(_826 == _827))) {
    float _834 = ((_825 * 2.0f) - _826) - _827;
    float _837 = ((_771 - _774) * 1.7320507764816284f) * _824;
    float _839 = atan(_837 / _834);
    bool _842 = (_834 < 0.0f);
    bool _843 = (_834 == 0.0f);
    bool _844 = (_837 >= 0.0f);
    bool _845 = (_837 < 0.0f);
    _856 = select((_844 && _843), 90.0f, select((_845 && _843), -90.0f, (select((_845 && _842), (_839 + -3.1415927410125732f), select((_844 && _842), (_839 + 3.1415927410125732f), _839)) * 57.2957763671875f)));
  } else {
    _856 = 0.0f;
  }
  float _861 = min(max(select((_856 < 0.0f), (_856 + 360.0f), _856), 0.0f), 360.0f);
  if (_861 < -180.0f) {
    _870 = (_861 + 360.0f);
  } else {
    if (_861 > 180.0f) {
      _870 = (_861 + -360.0f);
    } else {
      _870 = _861;
    }
  }
  float _874 = saturate(1.0f - abs(_870 * 0.014814814552664757f));
  float _878 = (_874 * _874) * (3.0f - (_874 * 2.0f));
  float _884 = ((_878 * _878) * ((_783 * 0.18000000715255737f) * (0.029999999329447746f - _825))) + _825;
  float _894 = max(0.0f, mad(-0.21492856740951538f, _827, mad(-0.2365107536315918f, _826, (_884 * 1.4514392614364624f))));
  float _895 = max(0.0f, mad(-0.09967592358589172f, _827, mad(1.17622971534729f, _826, (_884 * -0.07655377686023712f))));
  float _896 = max(0.0f, mad(0.9977163076400757f, _827, mad(-0.006032449658960104f, _826, (_884 * 0.008316148072481155f))));
  float _897 = dot(float3(_894, _895, _896), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _912 = (FilmBlackClip + 1.0f) - FilmToe;
  float _914 = FilmWhiteClip + 1.0f;
  float _916 = _914 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _934 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _925 = (FilmBlackClip + 0.18000000715255737f) / _912;
    _934 = (-0.7447274923324585f - ((log2(_925 / (2.0f - _925)) * 0.3465735912322998f) * (_912 / FilmSlope)));
  }
  float _937 = ((1.0f - FilmToe) / FilmSlope) - _934;
  float _939 = (FilmShoulder / FilmSlope) - _937;
  float _943 = log2(lerp(_897, _894, 0.9599999785423279f)) * 0.3010300099849701f;
  float _944 = log2(lerp(_897, _895, 0.9599999785423279f)) * 0.3010300099849701f;
  float _945 = log2(lerp(_897, _896, 0.9599999785423279f)) * 0.3010300099849701f;
  float _949 = FilmSlope * (_943 + _937);
  float _950 = FilmSlope * (_944 + _937);
  float _951 = FilmSlope * (_945 + _937);
  float _952 = _912 * 2.0f;
  float _954 = (FilmSlope * -2.0f) / _912;
  float _955 = _943 - _934;
  float _956 = _944 - _934;
  float _957 = _945 - _934;
  float _976 = _916 * 2.0f;
  float _978 = (FilmSlope * 2.0f) / _916;
  float _1003 = select((_943 < _934), ((_952 / (exp2((_955 * 1.4426950216293335f) * _954) + 1.0f)) - FilmBlackClip), _949);
  float _1004 = select((_944 < _934), ((_952 / (exp2((_956 * 1.4426950216293335f) * _954) + 1.0f)) - FilmBlackClip), _950);
  float _1005 = select((_945 < _934), ((_952 / (exp2((_957 * 1.4426950216293335f) * _954) + 1.0f)) - FilmBlackClip), _951);
  float _1012 = _939 - _934;
  float _1016 = saturate(_955 / _1012);
  float _1017 = saturate(_956 / _1012);
  float _1018 = saturate(_957 / _1012);
  bool _1019 = (_939 < _934);
  float _1023 = select(_1019, (1.0f - _1016), _1016);
  float _1024 = select(_1019, (1.0f - _1017), _1017);
  float _1025 = select(_1019, (1.0f - _1018), _1018);
  float _1044 = (((_1023 * _1023) * (select((_943 > _939), (_914 - (_976 / (exp2(((_943 - _939) * 1.4426950216293335f) * _978) + 1.0f))), _949) - _1003)) * (3.0f - (_1023 * 2.0f))) + _1003;
  float _1045 = (((_1024 * _1024) * (select((_944 > _939), (_914 - (_976 / (exp2(((_944 - _939) * 1.4426950216293335f) * _978) + 1.0f))), _950) - _1004)) * (3.0f - (_1024 * 2.0f))) + _1004;
  float _1046 = (((_1025 * _1025) * (select((_945 > _939), (_914 - (_976 / (exp2(((_945 - _939) * 1.4426950216293335f) * _978) + 1.0f))), _951) - _1005)) * (3.0f - (_1025 * 2.0f))) + _1005;
  float _1047 = dot(float3(_1044, _1045, _1046), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1067 = (ToneCurveAmount * (max(0.0f, (lerp(_1047, _1044, 0.9300000071525574f))) - _763)) + _763;
  float _1068 = (ToneCurveAmount * (max(0.0f, (lerp(_1047, _1045, 0.9300000071525574f))) - _764)) + _764;
  float _1069 = (ToneCurveAmount * (max(0.0f, (lerp(_1047, _1046, 0.9300000071525574f))) - _765)) + _765;
  float _1085 = ((mad(-0.06537103652954102f, _1069, mad(1.451815478503704e-06f, _1068, (_1067 * 1.065374732017517f))) - _1067) * BlueCorrection) + _1067;
  float _1086 = ((mad(-0.20366770029067993f, _1069, mad(1.2036634683609009f, _1068, (_1067 * -2.57161445915699e-07f))) - _1068) * BlueCorrection) + _1068;
  float _1087 = ((mad(0.9999996423721313f, _1069, mad(2.0954757928848267e-08f, _1068, (_1067 * 1.862645149230957e-08f))) - _1069) * BlueCorrection) + _1069;

  SetTonemappedAP1(_1085, _1086, _1087);

  float _1112 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1087, mad((WorkingColorSpace_FromAP1[0].y), _1086, ((WorkingColorSpace_FromAP1[0].x) * _1085)))));
  float _1113 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1087, mad((WorkingColorSpace_FromAP1[1].y), _1086, ((WorkingColorSpace_FromAP1[1].x) * _1085)))));
  float _1114 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1087, mad((WorkingColorSpace_FromAP1[2].y), _1086, ((WorkingColorSpace_FromAP1[2].x) * _1085)))));
  if (_1112 < 0.0031306699384003878f) {
    _1125 = (_1112 * 12.920000076293945f);
  } else {
    _1125 = (((pow(_1112, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1113 < 0.0031306699384003878f) {
    _1136 = (_1113 * 12.920000076293945f);
  } else {
    _1136 = (((pow(_1113, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1114 < 0.0031306699384003878f) {
    _1147 = (_1114 * 12.920000076293945f);
  } else {
    _1147 = (((pow(_1114, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1151 = (_1136 * 0.9375f) + 0.03125f;
  float _1158 = _1147 * 15.0f;
  float _1159 = floor(_1158);
  float _1160 = _1158 - _1159;
  float _1162 = (_1159 + ((_1125 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1165 = Textures_1.Sample(Samplers_1, float2(_1162, _1151));
  float _1169 = _1162 + 0.0625f;
  float4 _1172 = Textures_1.Sample(Samplers_1, float2(_1169, _1151));
  float4 _1195 = Textures_2.Sample(Samplers_2, float2(_1162, _1151));
  float4 _1201 = Textures_2.Sample(Samplers_2, float2(_1169, _1151));
  float4 _1224 = Textures_3.Sample(Samplers_3, float2(_1162, _1151));
  float4 _1230 = Textures_3.Sample(Samplers_3, float2(_1169, _1151));
  float _1249 = max(6.103519990574569e-05f, (((((lerp(_1165.x, _1172.x, _1160)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1125)) + ((lerp(_1195.x, _1201.x, _1160)) * (LUTWeights[0].z))) + ((lerp(_1224.x, _1230.x, _1160)) * (LUTWeights[0].w))));
  float _1250 = max(6.103519990574569e-05f, (((((lerp(_1165.y, _1172.y, _1160)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1136)) + ((lerp(_1195.y, _1201.y, _1160)) * (LUTWeights[0].z))) + ((lerp(_1224.y, _1230.y, _1160)) * (LUTWeights[0].w))));
  float _1251 = max(6.103519990574569e-05f, (((((lerp(_1165.z, _1172.z, _1160)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1147)) + ((lerp(_1195.z, _1201.z, _1160)) * (LUTWeights[0].z))) + ((lerp(_1224.z, _1230.z, _1160)) * (LUTWeights[0].w))));
  float _1273 = select((_1249 > 0.040449999272823334f), exp2(log2((_1249 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1249 * 0.07739938050508499f));
  float _1274 = select((_1250 > 0.040449999272823334f), exp2(log2((_1250 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1250 * 0.07739938050508499f));
  float _1275 = select((_1251 > 0.040449999272823334f), exp2(log2((_1251 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1251 * 0.07739938050508499f));
  float _1301 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1273)) * _1273) + MappingPolynomial.z);
  float _1302 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1274)) * _1274) + MappingPolynomial.z);
  float _1303 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1275)) * _1275) + MappingPolynomial.z);
  float _1324 = exp2(log2(max(0.0f, (lerp(_1301, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1325 = exp2(log2(max(0.0f, (lerp(_1302, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1326 = exp2(log2(max(0.0f, (lerp(_1303, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (true) {
    return GenerateOutput(float3(_1324, _1325, _1326), OutputDevice);
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1345 = mad((WorkingColorSpace_ToAP1[0].z), _1326, mad((WorkingColorSpace_ToAP1[0].y), _1325, ((WorkingColorSpace_ToAP1[0].x) * _1324)));
    float _1348 = mad((WorkingColorSpace_ToAP1[1].z), _1326, mad((WorkingColorSpace_ToAP1[1].y), _1325, ((WorkingColorSpace_ToAP1[1].x) * _1324)));
    float _1351 = mad((WorkingColorSpace_ToAP1[2].z), _1326, mad((WorkingColorSpace_ToAP1[2].y), _1325, ((WorkingColorSpace_ToAP1[2].x) * _1324)));
    _1362 = mad(_47, _1351, mad(_46, _1348, (_1345 * _45)));
    _1363 = mad(_50, _1351, mad(_49, _1348, (_1345 * _48)));
    _1364 = mad(_53, _1351, mad(_52, _1348, (_1345 * _51)));
  } else {
    _1362 = _1324;
    _1363 = _1325;
    _1364 = _1326;
  }
  if (_1362 < 0.0031306699384003878f) {
    _1375 = (_1362 * 12.920000076293945f);
  } else {
    _1375 = (((pow(_1362, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1363 < 0.0031306699384003878f) {
    _1386 = (_1363 * 12.920000076293945f);
  } else {
    _1386 = (((pow(_1363, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1364 < 0.0031306699384003878f) {
    _1397 = (_1364 * 12.920000076293945f);
  } else {
    _1397 = (((pow(_1364, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1375 * 0.9523810148239136f);
  SV_Target.y = (_1386 * 0.9523810148239136f);
  SV_Target.z = (_1397 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

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
  float _173;
  float _901;
  float _934;
  float _948;
  float _1012;
  float _1191;
  float _1202;
  float _1213;
  float _1410;
  float _1411;
  float _1412;
  float _1423;
  float _1434;
  float _1614;
  float _1647;
  float _1661;
  float _1700;
  float _1810;
  float _1884;
  float _1958;
  float _2037;
  float _2038;
  float _2039;
  float _2188;
  float _2221;
  float _2235;
  float _2274;
  float _2384;
  float _2458;
  float _2532;
  float _2611;
  float _2612;
  float _2613;
  float _2790;
  float _2791;
  float _2792;
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
  bool _152 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _156 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _173 = (((((2967800.0f - (_156 * 4607000064.0f)) * _156) + 99.11000061035156f) * _156) + 0.24406300485134125f);
  } else {
    _173 = (((((1901800.0f - (_156 * 2006400000.0f)) * _156) + 247.47999572753906f) * _156) + 0.23703999817371368f);
  }
  float _187 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _194 = WhiteTemp * WhiteTemp;
  float _197 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_194 * 1.6145605741257896e-07f));
  float _202 = ((_187 * 2.0f) + 4.0f) - (_197 * 8.0f);
  float _203 = (_187 * 3.0f) / _202;
  float _205 = (_197 * 2.0f) / _202;
  bool _206 = (WhiteTemp < 4000.0f);
  float _215 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _217 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_194 * 1.5317699909210205f)) / (_215 * _215);
  float _224 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _194;
  float _226 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_194 * 308.60699462890625f)) / (_224 * _224);
  float _228 = rsqrt(dot(float2(_217, _226), float2(_217, _226)));
  float _229 = WhiteTint * 0.05000000074505806f;
  float _232 = ((_229 * _226) * _228) + _187;
  float _235 = _197 - ((_229 * _217) * _228);
  float _240 = (4.0f - (_235 * 8.0f)) + (_232 * 2.0f);
  float _246 = (((_232 * 3.0f) / _240) - _203) + select(_206, _203, _173);
  float _247 = (((_235 * 2.0f) / _240) - _205) + select(_206, _205, (((_173 * 2.869999885559082f) + -0.2750000059604645f) - ((_173 * _173) * 3.0f)));
  float _248 = select(_152, _246, 0.3127000033855438f);
  float _249 = select(_152, _247, 0.32899999618530273f);
  float _250 = select(_152, 0.3127000033855438f, _246);
  float _251 = select(_152, 0.32899999618530273f, _247);
  float _252 = max(_249, 1.000000013351432e-10f);
  float _253 = _248 / _252;
  float _256 = ((1.0f - _248) - _249) / _252;
  float _257 = max(_251, 1.000000013351432e-10f);
  float _258 = _250 / _257;
  float _261 = ((1.0f - _250) - _251) / _257;
  float _280 = mad(-0.16140000522136688f, _261, ((_258 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _256, ((_253 * 0.8950999975204468f) + 0.266400009393692f));
  float _281 = mad(0.03669999912381172f, _261, (1.7135000228881836f - (_258 * 0.7501999735832214f))) / mad(0.03669999912381172f, _256, (1.7135000228881836f - (_253 * 0.7501999735832214f)));
  float _282 = mad(1.0296000242233276f, _261, ((_258 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _256, ((_253 * 0.03889999911189079f) + -0.06849999725818634f));
  float _283 = mad(_281, -0.7501999735832214f, 0.0f);
  float _284 = mad(_281, 1.7135000228881836f, 0.0f);
  float _285 = mad(_281, 0.03669999912381172f, -0.0f);
  float _286 = mad(_282, 0.03889999911189079f, 0.0f);
  float _287 = mad(_282, -0.06849999725818634f, 0.0f);
  float _288 = mad(_282, 1.0296000242233276f, 0.0f);
  float _291 = mad(0.1599626988172531f, _286, mad(-0.1470542997121811f, _283, (_280 * 0.883457362651825f)));
  float _294 = mad(0.1599626988172531f, _287, mad(-0.1470542997121811f, _284, (_280 * 0.26293492317199707f)));
  float _297 = mad(0.1599626988172531f, _288, mad(-0.1470542997121811f, _285, (_280 * -0.15930065512657166f)));
  float _300 = mad(0.04929120093584061f, _286, mad(0.5183603167533875f, _283, (_280 * 0.38695648312568665f)));
  float _303 = mad(0.04929120093584061f, _287, mad(0.5183603167533875f, _284, (_280 * 0.11516613513231277f)));
  float _306 = mad(0.04929120093584061f, _288, mad(0.5183603167533875f, _285, (_280 * -0.0697740763425827f)));
  float _309 = mad(0.9684867262840271f, _286, mad(0.04004279896616936f, _283, (_280 * -0.007634039502590895f)));
  float _312 = mad(0.9684867262840271f, _287, mad(0.04004279896616936f, _284, (_280 * -0.0022720457054674625f)));
  float _315 = mad(0.9684867262840271f, _288, mad(0.04004279896616936f, _285, (_280 * 0.0013765322510153055f)));
  float _318 = mad(_297, (WorkingColorSpace_ToXYZ[2].x), mad(_294, (WorkingColorSpace_ToXYZ[1].x), (_291 * (WorkingColorSpace_ToXYZ[0].x))));
  float _321 = mad(_297, (WorkingColorSpace_ToXYZ[2].y), mad(_294, (WorkingColorSpace_ToXYZ[1].y), (_291 * (WorkingColorSpace_ToXYZ[0].y))));
  float _324 = mad(_297, (WorkingColorSpace_ToXYZ[2].z), mad(_294, (WorkingColorSpace_ToXYZ[1].z), (_291 * (WorkingColorSpace_ToXYZ[0].z))));
  float _327 = mad(_306, (WorkingColorSpace_ToXYZ[2].x), mad(_303, (WorkingColorSpace_ToXYZ[1].x), (_300 * (WorkingColorSpace_ToXYZ[0].x))));
  float _330 = mad(_306, (WorkingColorSpace_ToXYZ[2].y), mad(_303, (WorkingColorSpace_ToXYZ[1].y), (_300 * (WorkingColorSpace_ToXYZ[0].y))));
  float _333 = mad(_306, (WorkingColorSpace_ToXYZ[2].z), mad(_303, (WorkingColorSpace_ToXYZ[1].z), (_300 * (WorkingColorSpace_ToXYZ[0].z))));
  float _336 = mad(_315, (WorkingColorSpace_ToXYZ[2].x), mad(_312, (WorkingColorSpace_ToXYZ[1].x), (_309 * (WorkingColorSpace_ToXYZ[0].x))));
  float _339 = mad(_315, (WorkingColorSpace_ToXYZ[2].y), mad(_312, (WorkingColorSpace_ToXYZ[1].y), (_309 * (WorkingColorSpace_ToXYZ[0].y))));
  float _342 = mad(_315, (WorkingColorSpace_ToXYZ[2].z), mad(_312, (WorkingColorSpace_ToXYZ[1].z), (_309 * (WorkingColorSpace_ToXYZ[0].z))));
  float _372 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _342, mad((WorkingColorSpace_FromXYZ[0].y), _333, (_324 * (WorkingColorSpace_FromXYZ[0].x)))), _125, mad(mad((WorkingColorSpace_FromXYZ[0].z), _339, mad((WorkingColorSpace_FromXYZ[0].y), _330, (_321 * (WorkingColorSpace_FromXYZ[0].x)))), _124, (mad((WorkingColorSpace_FromXYZ[0].z), _336, mad((WorkingColorSpace_FromXYZ[0].y), _327, (_318 * (WorkingColorSpace_FromXYZ[0].x)))) * _123)));
  float _375 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _342, mad((WorkingColorSpace_FromXYZ[1].y), _333, (_324 * (WorkingColorSpace_FromXYZ[1].x)))), _125, mad(mad((WorkingColorSpace_FromXYZ[1].z), _339, mad((WorkingColorSpace_FromXYZ[1].y), _330, (_321 * (WorkingColorSpace_FromXYZ[1].x)))), _124, (mad((WorkingColorSpace_FromXYZ[1].z), _336, mad((WorkingColorSpace_FromXYZ[1].y), _327, (_318 * (WorkingColorSpace_FromXYZ[1].x)))) * _123)));
  float _378 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _342, mad((WorkingColorSpace_FromXYZ[2].y), _333, (_324 * (WorkingColorSpace_FromXYZ[2].x)))), _125, mad(mad((WorkingColorSpace_FromXYZ[2].z), _339, mad((WorkingColorSpace_FromXYZ[2].y), _330, (_321 * (WorkingColorSpace_FromXYZ[2].x)))), _124, (mad((WorkingColorSpace_FromXYZ[2].z), _336, mad((WorkingColorSpace_FromXYZ[2].y), _327, (_318 * (WorkingColorSpace_FromXYZ[2].x)))) * _123)));
  float _393 = mad((WorkingColorSpace_ToAP1[0].z), _378, mad((WorkingColorSpace_ToAP1[0].y), _375, ((WorkingColorSpace_ToAP1[0].x) * _372)));
  float _396 = mad((WorkingColorSpace_ToAP1[1].z), _378, mad((WorkingColorSpace_ToAP1[1].y), _375, ((WorkingColorSpace_ToAP1[1].x) * _372)));
  float _399 = mad((WorkingColorSpace_ToAP1[2].z), _378, mad((WorkingColorSpace_ToAP1[2].y), _375, ((WorkingColorSpace_ToAP1[2].x) * _372)));
  float _400 = dot(float3(_393, _396, _399), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_393, _396, _399));

  float _404 = (_393 / _400) + -1.0f;
  float _405 = (_396 / _400) + -1.0f;
  float _406 = (_399 / _400) + -1.0f;
  float _418 = (1.0f - exp2(((_400 * _400) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_404, _405, _406), float3(_404, _405, _406)) * -4.0f));
  float _434 = ((mad(-0.06368321925401688f, _399, mad(-0.3292922377586365f, _396, (_393 * 1.3704125881195068f))) - _393) * _418) + _393;
  float _435 = ((mad(-0.010861365124583244f, _399, mad(1.0970927476882935f, _396, (_393 * -0.08343357592821121f))) - _396) * _418) + _396;
  float _436 = ((mad(1.2036951780319214f, _399, mad(-0.09862580895423889f, _396, (_393 * -0.02579331398010254f))) - _399) * _418) + _399;
  float _437 = dot(float3(_434, _435, _436), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _451 = ColorOffset.w + ColorOffsetShadows.w;
  float _465 = ColorGain.w * ColorGainShadows.w;
  float _479 = ColorGamma.w * ColorGammaShadows.w;
  float _493 = ColorContrast.w * ColorContrastShadows.w;
  float _507 = ColorSaturation.w * ColorSaturationShadows.w;
  float _511 = _434 - _437;
  float _512 = _435 - _437;
  float _513 = _436 - _437;
  float _570 = saturate(_437 / ColorCorrectionShadowsMax);
  float _574 = (_570 * _570) * (3.0f - (_570 * 2.0f));
  float _575 = 1.0f - _574;
  float _584 = ColorOffset.w + ColorOffsetHighlights.w;
  float _593 = ColorGain.w * ColorGainHighlights.w;
  float _602 = ColorGamma.w * ColorGammaHighlights.w;
  float _611 = ColorContrast.w * ColorContrastHighlights.w;
  float _620 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _683 = saturate((_437 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _687 = (_683 * _683) * (3.0f - (_683 * 2.0f));
  float _696 = ColorOffset.w + ColorOffsetMidtones.w;
  float _705 = ColorGain.w * ColorGainMidtones.w;
  float _714 = ColorGamma.w * ColorGammaMidtones.w;
  float _723 = ColorContrast.w * ColorContrastMidtones.w;
  float _732 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _790 = _574 - _687;
  float _801 = ((_687 * (((ColorOffset.x + ColorOffsetHighlights.x) + _584) + (((ColorGain.x * ColorGainHighlights.x) * _593) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _611) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _620) * _511) + _437)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _602)))))) + (_575 * (((ColorOffset.x + ColorOffsetShadows.x) + _451) + (((ColorGain.x * ColorGainShadows.x) * _465) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _493) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _507) * _511) + _437)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _479))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _696) + (((ColorGain.x * ColorGainMidtones.x) * _705) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _723) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _732) * _511) + _437)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _714))))) * _790);
  float _803 = ((_687 * (((ColorOffset.y + ColorOffsetHighlights.y) + _584) + (((ColorGain.y * ColorGainHighlights.y) * _593) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _611) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _620) * _512) + _437)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _602)))))) + (_575 * (((ColorOffset.y + ColorOffsetShadows.y) + _451) + (((ColorGain.y * ColorGainShadows.y) * _465) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _493) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _507) * _512) + _437)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _479))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _696) + (((ColorGain.y * ColorGainMidtones.y) * _705) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _723) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _732) * _512) + _437)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _714))))) * _790);
  float _805 = ((_687 * (((ColorOffset.z + ColorOffsetHighlights.z) + _584) + (((ColorGain.z * ColorGainHighlights.z) * _593) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _611) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _620) * _513) + _437)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _602)))))) + (_575 * (((ColorOffset.z + ColorOffsetShadows.z) + _451) + (((ColorGain.z * ColorGainShadows.z) * _465) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _493) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _507) * _513) + _437)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _479))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _696) + (((ColorGain.z * ColorGainMidtones.z) * _705) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _723) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _732) * _513) + _437)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _714))))) * _790);

  SetUntonemappedAP1(float3(_801, _803, _805));

  float _841 = ((mad(0.061360642313957214f, _805, mad(-4.540197551250458e-09f, _803, (_801 * 0.9386394023895264f))) - _801) * BlueCorrection) + _801;
  float _842 = ((mad(0.169205904006958f, _805, mad(0.8307942152023315f, _803, (_801 * 6.775371730327606e-08f))) - _803) * BlueCorrection) + _803;
  float _843 = (mad(-2.3283064365386963e-10f, _803, (_801 * -9.313225746154785e-10f)) * BlueCorrection) + _805;
  float _846 = mad(0.16386905312538147f, _843, mad(0.14067868888378143f, _842, (_841 * 0.6954522132873535f)));
  float _849 = mad(0.0955343246459961f, _843, mad(0.8596711158752441f, _842, (_841 * 0.044794581830501556f)));
  float _852 = mad(1.0015007257461548f, _843, mad(0.004025210160762072f, _842, (_841 * -0.005525882821530104f)));
  float _856 = max(max(_846, _849), _852);
  float _861 = (max(_856, 1.000000013351432e-10f) - max(min(min(_846, _849), _852), 1.000000013351432e-10f)) / max(_856, 0.009999999776482582f);
  float _874 = ((_849 + _846) + _852) + (sqrt((((_852 - _849) * _852) + ((_849 - _846) * _849)) + ((_846 - _852) * _846)) * 1.75f);
  float _875 = _874 * 0.3333333432674408f;
  float _876 = _861 + -0.4000000059604645f;
  float _877 = _876 * 5.0f;
  float _881 = max((1.0f - abs(_876 * 2.5f)), 0.0f);
  float _892 = ((float(((int)(uint)((bool)(_877 > 0.0f))) - ((int)(uint)((bool)(_877 < 0.0f)))) * (1.0f - (_881 * _881))) + 1.0f) * 0.02500000037252903f;
  if (!(_875 <= 0.0533333346247673f)) {
    if (!(_875 >= 0.1599999964237213f)) {
      _901 = (((0.23999999463558197f / _874) + -0.5f) * _892);
    } else {
      _901 = 0.0f;
    }
  } else {
    _901 = _892;
  }
  float _902 = _901 + 1.0f;
  float _903 = _902 * _846;
  float _904 = _902 * _849;
  float _905 = _902 * _852;
  if (!((bool)(_903 == _904) && (bool)(_904 == _905))) {
    float _912 = ((_903 * 2.0f) - _904) - _905;
    float _915 = ((_849 - _852) * 1.7320507764816284f) * _902;
    float _917 = atan(_915 / _912);
    bool _920 = (_912 < 0.0f);
    bool _921 = (_912 == 0.0f);
    bool _922 = (_915 >= 0.0f);
    bool _923 = (_915 < 0.0f);
    _934 = select((_922 && _921), 90.0f, select((_923 && _921), -90.0f, (select((_923 && _920), (_917 + -3.1415927410125732f), select((_922 && _920), (_917 + 3.1415927410125732f), _917)) * 57.2957763671875f)));
  } else {
    _934 = 0.0f;
  }
  float _939 = min(max(select((_934 < 0.0f), (_934 + 360.0f), _934), 0.0f), 360.0f);
  if (_939 < -180.0f) {
    _948 = (_939 + 360.0f);
  } else {
    if (_939 > 180.0f) {
      _948 = (_939 + -360.0f);
    } else {
      _948 = _939;
    }
  }
  float _952 = saturate(1.0f - abs(_948 * 0.014814814552664757f));
  float _956 = (_952 * _952) * (3.0f - (_952 * 2.0f));
  float _962 = ((_956 * _956) * ((_861 * 0.18000000715255737f) * (0.029999999329447746f - _903))) + _903;
  float _972 = max(0.0f, mad(-0.21492856740951538f, _905, mad(-0.2365107536315918f, _904, (_962 * 1.4514392614364624f))));
  float _973 = max(0.0f, mad(-0.09967592358589172f, _905, mad(1.17622971534729f, _904, (_962 * -0.07655377686023712f))));
  float _974 = max(0.0f, mad(0.9977163076400757f, _905, mad(-0.006032449658960104f, _904, (_962 * 0.008316148072481155f))));
  float _975 = dot(float3(_972, _973, _974), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _990 = (FilmBlackClip + 1.0f) - FilmToe;
  float _992 = FilmWhiteClip + 1.0f;
  float _994 = _992 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1012 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _1003 = (FilmBlackClip + 0.18000000715255737f) / _990;
    _1012 = (-0.7447274923324585f - ((log2(_1003 / (2.0f - _1003)) * 0.3465735912322998f) * (_990 / FilmSlope)));
  }
  float _1015 = ((1.0f - FilmToe) / FilmSlope) - _1012;
  float _1017 = (FilmShoulder / FilmSlope) - _1015;
  float _1021 = log2(lerp(_975, _972, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1022 = log2(lerp(_975, _973, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1023 = log2(lerp(_975, _974, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1027 = FilmSlope * (_1021 + _1015);
  float _1028 = FilmSlope * (_1022 + _1015);
  float _1029 = FilmSlope * (_1023 + _1015);
  float _1030 = _990 * 2.0f;
  float _1032 = (FilmSlope * -2.0f) / _990;
  float _1033 = _1021 - _1012;
  float _1034 = _1022 - _1012;
  float _1035 = _1023 - _1012;
  float _1054 = _994 * 2.0f;
  float _1056 = (FilmSlope * 2.0f) / _994;
  float _1081 = select((_1021 < _1012), ((_1030 / (exp2((_1033 * 1.4426950216293335f) * _1032) + 1.0f)) - FilmBlackClip), _1027);
  float _1082 = select((_1022 < _1012), ((_1030 / (exp2((_1034 * 1.4426950216293335f) * _1032) + 1.0f)) - FilmBlackClip), _1028);
  float _1083 = select((_1023 < _1012), ((_1030 / (exp2((_1035 * 1.4426950216293335f) * _1032) + 1.0f)) - FilmBlackClip), _1029);
  float _1090 = _1017 - _1012;
  float _1094 = saturate(_1033 / _1090);
  float _1095 = saturate(_1034 / _1090);
  float _1096 = saturate(_1035 / _1090);
  bool _1097 = (_1017 < _1012);
  float _1101 = select(_1097, (1.0f - _1094), _1094);
  float _1102 = select(_1097, (1.0f - _1095), _1095);
  float _1103 = select(_1097, (1.0f - _1096), _1096);
  float _1122 = (((_1101 * _1101) * (select((_1021 > _1017), (_992 - (_1054 / (exp2(((_1021 - _1017) * 1.4426950216293335f) * _1056) + 1.0f))), _1027) - _1081)) * (3.0f - (_1101 * 2.0f))) + _1081;
  float _1123 = (((_1102 * _1102) * (select((_1022 > _1017), (_992 - (_1054 / (exp2(((_1022 - _1017) * 1.4426950216293335f) * _1056) + 1.0f))), _1028) - _1082)) * (3.0f - (_1102 * 2.0f))) + _1082;
  float _1124 = (((_1103 * _1103) * (select((_1023 > _1017), (_992 - (_1054 / (exp2(((_1023 - _1017) * 1.4426950216293335f) * _1056) + 1.0f))), _1029) - _1083)) * (3.0f - (_1103 * 2.0f))) + _1083;
  float _1125 = dot(float3(_1122, _1123, _1124), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1145 = (ToneCurveAmount * (max(0.0f, (lerp(_1125, _1122, 0.9300000071525574f))) - _841)) + _841;
  float _1146 = (ToneCurveAmount * (max(0.0f, (lerp(_1125, _1123, 0.9300000071525574f))) - _842)) + _842;
  float _1147 = (ToneCurveAmount * (max(0.0f, (lerp(_1125, _1124, 0.9300000071525574f))) - _843)) + _843;
  float _1163 = ((mad(-0.06537103652954102f, _1147, mad(1.451815478503704e-06f, _1146, (_1145 * 1.065374732017517f))) - _1145) * BlueCorrection) + _1145;
  float _1164 = ((mad(-0.20366770029067993f, _1147, mad(1.2036634683609009f, _1146, (_1145 * -2.57161445915699e-07f))) - _1146) * BlueCorrection) + _1146;
  float _1165 = ((mad(0.9999996423721313f, _1147, mad(2.0954757928848267e-08f, _1146, (_1145 * 1.862645149230957e-08f))) - _1147) * BlueCorrection) + _1147;

  SetTonemappedAP1(_1163, _1164, _1165);

  float _1178 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1165, mad((WorkingColorSpace_FromAP1[0].y), _1164, ((WorkingColorSpace_FromAP1[0].x) * _1163)))));
  float _1179 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1165, mad((WorkingColorSpace_FromAP1[1].y), _1164, ((WorkingColorSpace_FromAP1[1].x) * _1163)))));
  float _1180 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1165, mad((WorkingColorSpace_FromAP1[2].y), _1164, ((WorkingColorSpace_FromAP1[2].x) * _1163)))));
  if (_1178 < 0.0031306699384003878f) {
    _1191 = (_1178 * 12.920000076293945f);
  } else {
    _1191 = (((pow(_1178, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1179 < 0.0031306699384003878f) {
    _1202 = (_1179 * 12.920000076293945f);
  } else {
    _1202 = (((pow(_1179, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1180 < 0.0031306699384003878f) {
    _1213 = (_1180 * 12.920000076293945f);
  } else {
    _1213 = (((pow(_1180, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1217 = (_1202 * 0.9375f) + 0.03125f;
  float _1224 = _1213 * 15.0f;
  float _1225 = floor(_1224);
  float _1226 = _1224 - _1225;
  float _1228 = (_1225 + ((_1191 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1231 = Textures_1.SampleLevel(Samplers_1, float2(_1228, _1217), 0.0f);
  float _1235 = _1228 + 0.0625f;
  float4 _1236 = Textures_1.SampleLevel(Samplers_1, float2(_1235, _1217), 0.0f);
  float4 _1258 = Textures_2.SampleLevel(Samplers_2, float2(_1228, _1217), 0.0f);
  float4 _1262 = Textures_2.SampleLevel(Samplers_2, float2(_1235, _1217), 0.0f);
  float _1281 = max(6.103519990574569e-05f, ((((lerp(_1231.x, _1236.x, _1226)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1191)) + ((lerp(_1258.x, _1262.x, _1226)) * (LUTWeights[0].z))));
  float _1282 = max(6.103519990574569e-05f, ((((lerp(_1231.y, _1236.y, _1226)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1202)) + ((lerp(_1258.y, _1262.y, _1226)) * (LUTWeights[0].z))));
  float _1283 = max(6.103519990574569e-05f, ((((lerp(_1231.z, _1236.z, _1226)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1213)) + ((lerp(_1258.z, _1262.z, _1226)) * (LUTWeights[0].z))));
  float _1305 = select((_1281 > 0.040449999272823334f), exp2(log2((_1281 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1281 * 0.07739938050508499f));
  float _1306 = select((_1282 > 0.040449999272823334f), exp2(log2((_1282 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1282 * 0.07739938050508499f));
  float _1307 = select((_1283 > 0.040449999272823334f), exp2(log2((_1283 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1283 * 0.07739938050508499f));
  float _1333 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1305)) * _1305) + MappingPolynomial.z);
  float _1334 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1306)) * _1306) + MappingPolynomial.z);
  float _1335 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1307)) * _1307) + MappingPolynomial.z);
  float _1342 = ((OverlayColor.x - _1333) * OverlayColor.w) + _1333;
  float _1343 = ((OverlayColor.y - _1334) * OverlayColor.w) + _1334;
  float _1344 = ((OverlayColor.z - _1335) * OverlayColor.w) + _1335;
  float _1345 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _805, mad((WorkingColorSpace_FromAP1[0].y), _803, (_801 * (WorkingColorSpace_FromAP1[0].x))));
  float _1346 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _805, mad((WorkingColorSpace_FromAP1[1].y), _803, ((WorkingColorSpace_FromAP1[1].x) * _801)));
  float _1347 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _805, mad((WorkingColorSpace_FromAP1[2].y), _803, ((WorkingColorSpace_FromAP1[2].x) * _801)));
  float _1354 = ((OverlayColor.x - _1345) * OverlayColor.w) + _1345;
  float _1355 = ((OverlayColor.y - _1346) * OverlayColor.w) + _1346;
  float _1356 = ((OverlayColor.z - _1347) * OverlayColor.w) + _1347;
  float _1368 = exp2(log2(max(0.0f, _1342)) * InverseGamma.y);
  float _1369 = exp2(log2(max(0.0f, _1343)) * InverseGamma.y);
  float _1370 = exp2(log2(max(0.0f, _1344)) * InverseGamma.y);

  if (true) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1368, _1369, _1370), OutputDevice);
    return;
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1393 = mad((WorkingColorSpace_ToAP1[0].z), _1370, mad((WorkingColorSpace_ToAP1[0].y), _1369, ((WorkingColorSpace_ToAP1[0].x) * _1368)));
        float _1396 = mad((WorkingColorSpace_ToAP1[1].z), _1370, mad((WorkingColorSpace_ToAP1[1].y), _1369, ((WorkingColorSpace_ToAP1[1].x) * _1368)));
        float _1399 = mad((WorkingColorSpace_ToAP1[2].z), _1370, mad((WorkingColorSpace_ToAP1[2].y), _1369, ((WorkingColorSpace_ToAP1[2].x) * _1368)));
        _1410 = mad(_59, _1399, mad(_58, _1396, (_1393 * _57)));
        _1411 = mad(_62, _1399, mad(_61, _1396, (_1393 * _60)));
        _1412 = mad(_65, _1399, mad(_64, _1396, (_1393 * _63)));
      } else {
        _1410 = _1368;
        _1411 = _1369;
        _1412 = _1370;
      }
      do {
        if (_1410 < 0.0031306699384003878f) {
          _1423 = (_1410 * 12.920000076293945f);
        } else {
          _1423 = (((pow(_1410, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1411 < 0.0031306699384003878f) {
            _1434 = (_1411 * 12.920000076293945f);
          } else {
            _1434 = (((pow(_1411, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1412 < 0.0031306699384003878f) {
            _2790 = _1423;
            _2791 = _1434;
            _2792 = (_1412 * 12.920000076293945f);
          } else {
            _2790 = _1423;
            _2791 = _1434;
            _2792 = (((pow(_1412, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1461 = mad((WorkingColorSpace_ToAP1[0].z), _1370, mad((WorkingColorSpace_ToAP1[0].y), _1369, ((WorkingColorSpace_ToAP1[0].x) * _1368)));
      float _1464 = mad((WorkingColorSpace_ToAP1[1].z), _1370, mad((WorkingColorSpace_ToAP1[1].y), _1369, ((WorkingColorSpace_ToAP1[1].x) * _1368)));
      float _1467 = mad((WorkingColorSpace_ToAP1[2].z), _1370, mad((WorkingColorSpace_ToAP1[2].y), _1369, ((WorkingColorSpace_ToAP1[2].x) * _1368)));
      float _1477 = max(6.103519990574569e-05f, mad(_59, _1467, mad(_58, _1464, (_1461 * _57))));
      float _1478 = max(6.103519990574569e-05f, mad(_62, _1467, mad(_61, _1464, (_1461 * _60))));
      float _1479 = max(6.103519990574569e-05f, mad(_65, _1467, mad(_64, _1464, (_1461 * _63))));
      _2790 = min((_1477 * 4.5f), ((exp2(log2(max(_1477, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2791 = min((_1478 * 4.5f), ((exp2(log2(max(_1478, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2792 = min((_1479 * 4.5f), ((exp2(log2(max(_1479, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        float _1554 = ACESSceneColorMultiplier * _1354;
        float _1555 = ACESSceneColorMultiplier * _1355;
        float _1556 = ACESSceneColorMultiplier * _1356;
        float _1559 = mad((WorkingColorSpace_ToAP0[0].z), _1556, mad((WorkingColorSpace_ToAP0[0].y), _1555, ((WorkingColorSpace_ToAP0[0].x) * _1554)));
        float _1562 = mad((WorkingColorSpace_ToAP0[1].z), _1556, mad((WorkingColorSpace_ToAP0[1].y), _1555, ((WorkingColorSpace_ToAP0[1].x) * _1554)));
        float _1565 = mad((WorkingColorSpace_ToAP0[2].z), _1556, mad((WorkingColorSpace_ToAP0[2].y), _1555, ((WorkingColorSpace_ToAP0[2].x) * _1554)));
        float _1569 = max(max(_1559, _1562), _1565);
        float _1574 = (max(_1569, 1.000000013351432e-10f) - max(min(min(_1559, _1562), _1565), 1.000000013351432e-10f)) / max(_1569, 0.009999999776482582f);
        float _1587 = ((_1562 + _1559) + _1565) + (sqrt((((_1565 - _1562) * _1565) + ((_1562 - _1559) * _1562)) + ((_1559 - _1565) * _1559)) * 1.75f);
        float _1588 = _1587 * 0.3333333432674408f;
        float _1589 = _1574 + -0.4000000059604645f;
        float _1590 = _1589 * 5.0f;
        float _1594 = max((1.0f - abs(_1589 * 2.5f)), 0.0f);
        float _1605 = ((float(((int)(uint)((bool)(_1590 > 0.0f))) - ((int)(uint)((bool)(_1590 < 0.0f)))) * (1.0f - (_1594 * _1594))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1588 <= 0.0533333346247673f)) {
            if (!(_1588 >= 0.1599999964237213f)) {
              _1614 = (((0.23999999463558197f / _1587) + -0.5f) * _1605);
            } else {
              _1614 = 0.0f;
            }
          } else {
            _1614 = _1605;
          }
          float _1615 = _1614 + 1.0f;
          float _1616 = _1615 * _1559;
          float _1617 = _1615 * _1562;
          float _1618 = _1615 * _1565;
          do {
            if (!((bool)(_1616 == _1617) && (bool)(_1617 == _1618))) {
              float _1625 = ((_1616 * 2.0f) - _1617) - _1618;
              float _1628 = ((_1562 - _1565) * 1.7320507764816284f) * _1615;
              float _1630 = atan(_1628 / _1625);
              bool _1633 = (_1625 < 0.0f);
              bool _1634 = (_1625 == 0.0f);
              bool _1635 = (_1628 >= 0.0f);
              bool _1636 = (_1628 < 0.0f);
              _1647 = select((_1635 && _1634), 90.0f, select((_1636 && _1634), -90.0f, (select((_1636 && _1633), (_1630 + -3.1415927410125732f), select((_1635 && _1633), (_1630 + 3.1415927410125732f), _1630)) * 57.2957763671875f)));
            } else {
              _1647 = 0.0f;
            }
            float _1652 = min(max(select((_1647 < 0.0f), (_1647 + 360.0f), _1647), 0.0f), 360.0f);
            do {
              if (_1652 < -180.0f) {
                _1661 = (_1652 + 360.0f);
              } else {
                if (_1652 > 180.0f) {
                  _1661 = (_1652 + -360.0f);
                } else {
                  _1661 = _1652;
                }
              }
              do {
                if ((bool)(_1661 > -67.5f) && (bool)(_1661 < 67.5f)) {
                  float _1667 = (_1661 + 67.5f) * 0.029629629105329514f;
                  int _1668 = int(_1667);
                  float _1670 = _1667 - float(_1668);
                  float _1671 = _1670 * _1670;
                  float _1672 = _1671 * _1670;
                  if (_1668 == 3) {
                    _1700 = (((0.1666666716337204f - (_1670 * 0.5f)) + (_1671 * 0.5f)) - (_1672 * 0.1666666716337204f));
                  } else {
                    if (_1668 == 2) {
                      _1700 = ((0.6666666865348816f - _1671) + (_1672 * 0.5f));
                    } else {
                      if (_1668 == 1) {
                        _1700 = (((_1672 * -0.5f) + 0.1666666716337204f) + ((_1671 + _1670) * 0.5f));
                      } else {
                        _1700 = select((_1668 == 0), (_1672 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1700 = 0.0f;
                }
                float _1709 = min(max(((((_1574 * 0.27000001072883606f) * (0.029999999329447746f - _1616)) * _1700) + _1616), 0.0f), 65535.0f);
                float _1710 = min(max(_1617, 0.0f), 65535.0f);
                float _1711 = min(max(_1618, 0.0f), 65535.0f);
                float _1724 = min(max(mad(-0.21492856740951538f, _1711, mad(-0.2365107536315918f, _1710, (_1709 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1725 = min(max(mad(-0.09967592358589172f, _1711, mad(1.17622971534729f, _1710, (_1709 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1726 = min(max(mad(0.9977163076400757f, _1711, mad(-0.006032449658960104f, _1710, (_1709 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1727 = dot(float3(_1724, _1725, _1726), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1738 = log2(max((lerp(_1727, _1724, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1739 = _1738 * 0.3010300099849701f;
                float _1740 = log2(ACESMinMaxData.x);
                float _1741 = _1740 * 0.3010300099849701f;
                do {
                  if (!(!(_1739 <= _1741))) {
                    _1810 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1748 = log2(ACESMidData.x);
                    float _1749 = _1748 * 0.3010300099849701f;
                    if ((bool)(_1739 > _1741) && (bool)(_1739 < _1749)) {
                      float _1757 = ((_1738 - _1740) * 0.9030900001525879f) / ((_1748 - _1740) * 0.3010300099849701f);
                      int _1758 = int(_1757);
                      float _1760 = _1757 - float(_1758);
                      float _1762 = _15[_1758];
                      float _1765 = _15[(_1758 + 1)];
                      float _1770 = _1762 * 0.5f;
                      _1810 = dot(float3((_1760 * _1760), _1760, 1.0f), float3(mad((_15[(_1758 + 2)]), 0.5f, mad(_1765, -1.0f, _1770)), (_1765 - _1762), mad(_1765, 0.5f, _1770)));
                    } else {
                      do {
                        if (!(!(_1739 >= _1749))) {
                          float _1779 = log2(ACESMinMaxData.z);
                          if (_1739 < (_1779 * 0.3010300099849701f)) {
                            float _1787 = ((_1738 - _1748) * 0.9030900001525879f) / ((_1779 - _1748) * 0.3010300099849701f);
                            int _1788 = int(_1787);
                            float _1790 = _1787 - float(_1788);
                            float _1792 = _16[_1788];
                            float _1795 = _16[(_1788 + 1)];
                            float _1800 = _1792 * 0.5f;
                            _1810 = dot(float3((_1790 * _1790), _1790, 1.0f), float3(mad((_16[(_1788 + 2)]), 0.5f, mad(_1795, -1.0f, _1800)), (_1795 - _1792), mad(_1795, 0.5f, _1800)));
                            break;
                          }
                        }
                        _1810 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1814 = log2(max((lerp(_1727, _1725, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1815 = _1814 * 0.3010300099849701f;
                  do {
                    if (!(!(_1815 <= _1741))) {
                      _1884 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1822 = log2(ACESMidData.x);
                      float _1823 = _1822 * 0.3010300099849701f;
                      if ((bool)(_1815 > _1741) && (bool)(_1815 < _1823)) {
                        float _1831 = ((_1814 - _1740) * 0.9030900001525879f) / ((_1822 - _1740) * 0.3010300099849701f);
                        int _1832 = int(_1831);
                        float _1834 = _1831 - float(_1832);
                        float _1836 = _15[_1832];
                        float _1839 = _15[(_1832 + 1)];
                        float _1844 = _1836 * 0.5f;
                        _1884 = dot(float3((_1834 * _1834), _1834, 1.0f), float3(mad((_15[(_1832 + 2)]), 0.5f, mad(_1839, -1.0f, _1844)), (_1839 - _1836), mad(_1839, 0.5f, _1844)));
                      } else {
                        do {
                          if (!(!(_1815 >= _1823))) {
                            float _1853 = log2(ACESMinMaxData.z);
                            if (_1815 < (_1853 * 0.3010300099849701f)) {
                              float _1861 = ((_1814 - _1822) * 0.9030900001525879f) / ((_1853 - _1822) * 0.3010300099849701f);
                              int _1862 = int(_1861);
                              float _1864 = _1861 - float(_1862);
                              float _1866 = _16[_1862];
                              float _1869 = _16[(_1862 + 1)];
                              float _1874 = _1866 * 0.5f;
                              _1884 = dot(float3((_1864 * _1864), _1864, 1.0f), float3(mad((_16[(_1862 + 2)]), 0.5f, mad(_1869, -1.0f, _1874)), (_1869 - _1866), mad(_1869, 0.5f, _1874)));
                              break;
                            }
                          }
                          _1884 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1888 = log2(max((lerp(_1727, _1726, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1889 = _1888 * 0.3010300099849701f;
                    do {
                      if (!(!(_1889 <= _1741))) {
                        _1958 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1896 = log2(ACESMidData.x);
                        float _1897 = _1896 * 0.3010300099849701f;
                        if ((bool)(_1889 > _1741) && (bool)(_1889 < _1897)) {
                          float _1905 = ((_1888 - _1740) * 0.9030900001525879f) / ((_1896 - _1740) * 0.3010300099849701f);
                          int _1906 = int(_1905);
                          float _1908 = _1905 - float(_1906);
                          float _1910 = _15[_1906];
                          float _1913 = _15[(_1906 + 1)];
                          float _1918 = _1910 * 0.5f;
                          _1958 = dot(float3((_1908 * _1908), _1908, 1.0f), float3(mad((_15[(_1906 + 2)]), 0.5f, mad(_1913, -1.0f, _1918)), (_1913 - _1910), mad(_1913, 0.5f, _1918)));
                        } else {
                          do {
                            if (!(!(_1889 >= _1897))) {
                              float _1927 = log2(ACESMinMaxData.z);
                              if (_1889 < (_1927 * 0.3010300099849701f)) {
                                float _1935 = ((_1888 - _1896) * 0.9030900001525879f) / ((_1927 - _1896) * 0.3010300099849701f);
                                int _1936 = int(_1935);
                                float _1938 = _1935 - float(_1936);
                                float _1940 = _16[_1936];
                                float _1943 = _16[(_1936 + 1)];
                                float _1948 = _1940 * 0.5f;
                                _1958 = dot(float3((_1938 * _1938), _1938, 1.0f), float3(mad((_16[(_1936 + 2)]), 0.5f, mad(_1943, -1.0f, _1948)), (_1943 - _1940), mad(_1943, 0.5f, _1948)));
                                break;
                              }
                            }
                            _1958 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1962 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1963 = (exp2(_1810 * 3.321928024291992f) - ACESMinMaxData.y) / _1962;
                      float _1965 = (exp2(_1884 * 3.321928024291992f) - ACESMinMaxData.y) / _1962;
                      float _1967 = (exp2(_1958 * 3.321928024291992f) - ACESMinMaxData.y) / _1962;
                      float _1970 = mad(0.15618768334388733f, _1967, mad(0.13400420546531677f, _1965, (_1963 * 0.6624541878700256f)));
                      float _1973 = mad(0.053689517080783844f, _1967, mad(0.6740817427635193f, _1965, (_1963 * 0.2722287178039551f)));
                      float _1976 = mad(1.0103391408920288f, _1967, mad(0.00406073359772563f, _1965, (_1963 * -0.005574649665504694f)));
                      float _1989 = min(max(mad(-0.23642469942569733f, _1976, mad(-0.32480329275131226f, _1973, (_1970 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1990 = min(max(mad(0.016756348311901093f, _1976, mad(1.6153316497802734f, _1973, (_1970 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1991 = min(max(mad(0.9883948564529419f, _1976, mad(-0.008284442126750946f, _1973, (_1970 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1994 = mad(0.15618768334388733f, _1991, mad(0.13400420546531677f, _1990, (_1989 * 0.6624541878700256f)));
                      float _1997 = mad(0.053689517080783844f, _1991, mad(0.6740817427635193f, _1990, (_1989 * 0.2722287178039551f)));
                      float _2000 = mad(1.0103391408920288f, _1991, mad(0.00406073359772563f, _1990, (_1989 * -0.005574649665504694f)));
                      float _2022 = min(max((min(max(mad(-0.23642469942569733f, _2000, mad(-0.32480329275131226f, _1997, (_1994 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2023 = min(max((min(max(mad(0.016756348311901093f, _2000, mad(1.6153316497802734f, _1997, (_1994 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2024 = min(max((min(max(mad(0.9883948564529419f, _2000, mad(-0.008284442126750946f, _1997, (_1994 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(OutputDevice) == 5)) {
                          _2037 = mad(_59, _2024, mad(_58, _2023, (_2022 * _57)));
                          _2038 = mad(_62, _2024, mad(_61, _2023, (_2022 * _60)));
                          _2039 = mad(_65, _2024, mad(_64, _2023, (_2022 * _63)));
                        } else {
                          _2037 = _2022;
                          _2038 = _2023;
                          _2039 = _2024;
                        }
                        float _2049 = exp2(log2(_2037 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2050 = exp2(log2(_2038 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2051 = exp2(log2(_2039 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2790 = exp2(log2((1.0f / ((_2049 * 18.6875f) + 1.0f)) * ((_2049 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2791 = exp2(log2((1.0f / ((_2050 * 18.6875f) + 1.0f)) * ((_2050 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2792 = exp2(log2((1.0f / ((_2051 * 18.6875f) + 1.0f)) * ((_2051 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2128 = ACESSceneColorMultiplier * _1354;
          float _2129 = ACESSceneColorMultiplier * _1355;
          float _2130 = ACESSceneColorMultiplier * _1356;
          float _2133 = mad((WorkingColorSpace_ToAP0[0].z), _2130, mad((WorkingColorSpace_ToAP0[0].y), _2129, ((WorkingColorSpace_ToAP0[0].x) * _2128)));
          float _2136 = mad((WorkingColorSpace_ToAP0[1].z), _2130, mad((WorkingColorSpace_ToAP0[1].y), _2129, ((WorkingColorSpace_ToAP0[1].x) * _2128)));
          float _2139 = mad((WorkingColorSpace_ToAP0[2].z), _2130, mad((WorkingColorSpace_ToAP0[2].y), _2129, ((WorkingColorSpace_ToAP0[2].x) * _2128)));
          float _2143 = max(max(_2133, _2136), _2139);
          float _2148 = (max(_2143, 1.000000013351432e-10f) - max(min(min(_2133, _2136), _2139), 1.000000013351432e-10f)) / max(_2143, 0.009999999776482582f);
          float _2161 = ((_2136 + _2133) + _2139) + (sqrt((((_2139 - _2136) * _2139) + ((_2136 - _2133) * _2136)) + ((_2133 - _2139) * _2133)) * 1.75f);
          float _2162 = _2161 * 0.3333333432674408f;
          float _2163 = _2148 + -0.4000000059604645f;
          float _2164 = _2163 * 5.0f;
          float _2168 = max((1.0f - abs(_2163 * 2.5f)), 0.0f);
          float _2179 = ((float(((int)(uint)((bool)(_2164 > 0.0f))) - ((int)(uint)((bool)(_2164 < 0.0f)))) * (1.0f - (_2168 * _2168))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2162 <= 0.0533333346247673f)) {
              if (!(_2162 >= 0.1599999964237213f)) {
                _2188 = (((0.23999999463558197f / _2161) + -0.5f) * _2179);
              } else {
                _2188 = 0.0f;
              }
            } else {
              _2188 = _2179;
            }
            float _2189 = _2188 + 1.0f;
            float _2190 = _2189 * _2133;
            float _2191 = _2189 * _2136;
            float _2192 = _2189 * _2139;
            do {
              if (!((bool)(_2190 == _2191) && (bool)(_2191 == _2192))) {
                float _2199 = ((_2190 * 2.0f) - _2191) - _2192;
                float _2202 = ((_2136 - _2139) * 1.7320507764816284f) * _2189;
                float _2204 = atan(_2202 / _2199);
                bool _2207 = (_2199 < 0.0f);
                bool _2208 = (_2199 == 0.0f);
                bool _2209 = (_2202 >= 0.0f);
                bool _2210 = (_2202 < 0.0f);
                _2221 = select((_2209 && _2208), 90.0f, select((_2210 && _2208), -90.0f, (select((_2210 && _2207), (_2204 + -3.1415927410125732f), select((_2209 && _2207), (_2204 + 3.1415927410125732f), _2204)) * 57.2957763671875f)));
              } else {
                _2221 = 0.0f;
              }
              float _2226 = min(max(select((_2221 < 0.0f), (_2221 + 360.0f), _2221), 0.0f), 360.0f);
              do {
                if (_2226 < -180.0f) {
                  _2235 = (_2226 + 360.0f);
                } else {
                  if (_2226 > 180.0f) {
                    _2235 = (_2226 + -360.0f);
                  } else {
                    _2235 = _2226;
                  }
                }
                do {
                  if ((bool)(_2235 > -67.5f) && (bool)(_2235 < 67.5f)) {
                    float _2241 = (_2235 + 67.5f) * 0.029629629105329514f;
                    int _2242 = int(_2241);
                    float _2244 = _2241 - float(_2242);
                    float _2245 = _2244 * _2244;
                    float _2246 = _2245 * _2244;
                    if (_2242 == 3) {
                      _2274 = (((0.1666666716337204f - (_2244 * 0.5f)) + (_2245 * 0.5f)) - (_2246 * 0.1666666716337204f));
                    } else {
                      if (_2242 == 2) {
                        _2274 = ((0.6666666865348816f - _2245) + (_2246 * 0.5f));
                      } else {
                        if (_2242 == 1) {
                          _2274 = (((_2246 * -0.5f) + 0.1666666716337204f) + ((_2245 + _2244) * 0.5f));
                        } else {
                          _2274 = select((_2242 == 0), (_2246 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2274 = 0.0f;
                  }
                  float _2283 = min(max(((((_2148 * 0.27000001072883606f) * (0.029999999329447746f - _2190)) * _2274) + _2190), 0.0f), 65535.0f);
                  float _2284 = min(max(_2191, 0.0f), 65535.0f);
                  float _2285 = min(max(_2192, 0.0f), 65535.0f);
                  float _2298 = min(max(mad(-0.21492856740951538f, _2285, mad(-0.2365107536315918f, _2284, (_2283 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2299 = min(max(mad(-0.09967592358589172f, _2285, mad(1.17622971534729f, _2284, (_2283 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2300 = min(max(mad(0.9977163076400757f, _2285, mad(-0.006032449658960104f, _2284, (_2283 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2301 = dot(float3(_2298, _2299, _2300), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2312 = log2(max((lerp(_2301, _2298, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2313 = _2312 * 0.3010300099849701f;
                  float _2314 = log2(ACESMinMaxData.x);
                  float _2315 = _2314 * 0.3010300099849701f;
                  do {
                    if (!(!(_2313 <= _2315))) {
                      _2384 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2322 = log2(ACESMidData.x);
                      float _2323 = _2322 * 0.3010300099849701f;
                      if ((bool)(_2313 > _2315) && (bool)(_2313 < _2323)) {
                        float _2331 = ((_2312 - _2314) * 0.9030900001525879f) / ((_2322 - _2314) * 0.3010300099849701f);
                        int _2332 = int(_2331);
                        float _2334 = _2331 - float(_2332);
                        float _2336 = _13[_2332];
                        float _2339 = _13[(_2332 + 1)];
                        float _2344 = _2336 * 0.5f;
                        _2384 = dot(float3((_2334 * _2334), _2334, 1.0f), float3(mad((_13[(_2332 + 2)]), 0.5f, mad(_2339, -1.0f, _2344)), (_2339 - _2336), mad(_2339, 0.5f, _2344)));
                      } else {
                        do {
                          if (!(!(_2313 >= _2323))) {
                            float _2353 = log2(ACESMinMaxData.z);
                            if (_2313 < (_2353 * 0.3010300099849701f)) {
                              float _2361 = ((_2312 - _2322) * 0.9030900001525879f) / ((_2353 - _2322) * 0.3010300099849701f);
                              int _2362 = int(_2361);
                              float _2364 = _2361 - float(_2362);
                              float _2366 = _14[_2362];
                              float _2369 = _14[(_2362 + 1)];
                              float _2374 = _2366 * 0.5f;
                              _2384 = dot(float3((_2364 * _2364), _2364, 1.0f), float3(mad((_14[(_2362 + 2)]), 0.5f, mad(_2369, -1.0f, _2374)), (_2369 - _2366), mad(_2369, 0.5f, _2374)));
                              break;
                            }
                          }
                          _2384 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2388 = log2(max((lerp(_2301, _2299, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2389 = _2388 * 0.3010300099849701f;
                    do {
                      if (!(!(_2389 <= _2315))) {
                        _2458 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2396 = log2(ACESMidData.x);
                        float _2397 = _2396 * 0.3010300099849701f;
                        if ((bool)(_2389 > _2315) && (bool)(_2389 < _2397)) {
                          float _2405 = ((_2388 - _2314) * 0.9030900001525879f) / ((_2396 - _2314) * 0.3010300099849701f);
                          int _2406 = int(_2405);
                          float _2408 = _2405 - float(_2406);
                          float _2410 = _13[_2406];
                          float _2413 = _13[(_2406 + 1)];
                          float _2418 = _2410 * 0.5f;
                          _2458 = dot(float3((_2408 * _2408), _2408, 1.0f), float3(mad((_13[(_2406 + 2)]), 0.5f, mad(_2413, -1.0f, _2418)), (_2413 - _2410), mad(_2413, 0.5f, _2418)));
                        } else {
                          do {
                            if (!(!(_2389 >= _2397))) {
                              float _2427 = log2(ACESMinMaxData.z);
                              if (_2389 < (_2427 * 0.3010300099849701f)) {
                                float _2435 = ((_2388 - _2396) * 0.9030900001525879f) / ((_2427 - _2396) * 0.3010300099849701f);
                                int _2436 = int(_2435);
                                float _2438 = _2435 - float(_2436);
                                float _2440 = _14[_2436];
                                float _2443 = _14[(_2436 + 1)];
                                float _2448 = _2440 * 0.5f;
                                _2458 = dot(float3((_2438 * _2438), _2438, 1.0f), float3(mad((_14[(_2436 + 2)]), 0.5f, mad(_2443, -1.0f, _2448)), (_2443 - _2440), mad(_2443, 0.5f, _2448)));
                                break;
                              }
                            }
                            _2458 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2462 = log2(max((lerp(_2301, _2300, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2463 = _2462 * 0.3010300099849701f;
                      do {
                        if (!(!(_2463 <= _2315))) {
                          _2532 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2470 = log2(ACESMidData.x);
                          float _2471 = _2470 * 0.3010300099849701f;
                          if ((bool)(_2463 > _2315) && (bool)(_2463 < _2471)) {
                            float _2479 = ((_2462 - _2314) * 0.9030900001525879f) / ((_2470 - _2314) * 0.3010300099849701f);
                            int _2480 = int(_2479);
                            float _2482 = _2479 - float(_2480);
                            float _2484 = _13[_2480];
                            float _2487 = _13[(_2480 + 1)];
                            float _2492 = _2484 * 0.5f;
                            _2532 = dot(float3((_2482 * _2482), _2482, 1.0f), float3(mad((_13[(_2480 + 2)]), 0.5f, mad(_2487, -1.0f, _2492)), (_2487 - _2484), mad(_2487, 0.5f, _2492)));
                          } else {
                            do {
                              if (!(!(_2463 >= _2471))) {
                                float _2501 = log2(ACESMinMaxData.z);
                                if (_2463 < (_2501 * 0.3010300099849701f)) {
                                  float _2509 = ((_2462 - _2470) * 0.9030900001525879f) / ((_2501 - _2470) * 0.3010300099849701f);
                                  int _2510 = int(_2509);
                                  float _2512 = _2509 - float(_2510);
                                  float _2514 = _14[_2510];
                                  float _2517 = _14[(_2510 + 1)];
                                  float _2522 = _2514 * 0.5f;
                                  _2532 = dot(float3((_2512 * _2512), _2512, 1.0f), float3(mad((_14[(_2510 + 2)]), 0.5f, mad(_2517, -1.0f, _2522)), (_2517 - _2514), mad(_2517, 0.5f, _2522)));
                                  break;
                                }
                              }
                              _2532 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2536 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2537 = (exp2(_2384 * 3.321928024291992f) - ACESMinMaxData.y) / _2536;
                        float _2539 = (exp2(_2458 * 3.321928024291992f) - ACESMinMaxData.y) / _2536;
                        float _2541 = (exp2(_2532 * 3.321928024291992f) - ACESMinMaxData.y) / _2536;
                        float _2544 = mad(0.15618768334388733f, _2541, mad(0.13400420546531677f, _2539, (_2537 * 0.6624541878700256f)));
                        float _2547 = mad(0.053689517080783844f, _2541, mad(0.6740817427635193f, _2539, (_2537 * 0.2722287178039551f)));
                        float _2550 = mad(1.0103391408920288f, _2541, mad(0.00406073359772563f, _2539, (_2537 * -0.005574649665504694f)));
                        float _2563 = min(max(mad(-0.23642469942569733f, _2550, mad(-0.32480329275131226f, _2547, (_2544 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2564 = min(max(mad(0.016756348311901093f, _2550, mad(1.6153316497802734f, _2547, (_2544 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2565 = min(max(mad(0.9883948564529419f, _2550, mad(-0.008284442126750946f, _2547, (_2544 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2568 = mad(0.15618768334388733f, _2565, mad(0.13400420546531677f, _2564, (_2563 * 0.6624541878700256f)));
                        float _2571 = mad(0.053689517080783844f, _2565, mad(0.6740817427635193f, _2564, (_2563 * 0.2722287178039551f)));
                        float _2574 = mad(1.0103391408920288f, _2565, mad(0.00406073359772563f, _2564, (_2563 * -0.005574649665504694f)));
                        float _2596 = min(max((min(max(mad(-0.23642469942569733f, _2574, mad(-0.32480329275131226f, _2571, (_2568 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2597 = min(max((min(max(mad(0.016756348311901093f, _2574, mad(1.6153316497802734f, _2571, (_2568 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2598 = min(max((min(max(mad(0.9883948564529419f, _2574, mad(-0.008284442126750946f, _2571, (_2568 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 6)) {
                            _2611 = mad(_59, _2598, mad(_58, _2597, (_2596 * _57)));
                            _2612 = mad(_62, _2598, mad(_61, _2597, (_2596 * _60)));
                            _2613 = mad(_65, _2598, mad(_64, _2597, (_2596 * _63)));
                          } else {
                            _2611 = _2596;
                            _2612 = _2597;
                            _2613 = _2598;
                          }
                          float _2623 = exp2(log2(_2611 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2624 = exp2(log2(_2612 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2625 = exp2(log2(_2613 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2790 = exp2(log2((1.0f / ((_2623 * 18.6875f) + 1.0f)) * ((_2623 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2791 = exp2(log2((1.0f / ((_2624 * 18.6875f) + 1.0f)) * ((_2624 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2792 = exp2(log2((1.0f / ((_2625 * 18.6875f) + 1.0f)) * ((_2625 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2670 = mad((WorkingColorSpace_ToAP1[0].z), _1356, mad((WorkingColorSpace_ToAP1[0].y), _1355, ((WorkingColorSpace_ToAP1[0].x) * _1354)));
            float _2673 = mad((WorkingColorSpace_ToAP1[1].z), _1356, mad((WorkingColorSpace_ToAP1[1].y), _1355, ((WorkingColorSpace_ToAP1[1].x) * _1354)));
            float _2676 = mad((WorkingColorSpace_ToAP1[2].z), _1356, mad((WorkingColorSpace_ToAP1[2].y), _1355, ((WorkingColorSpace_ToAP1[2].x) * _1354)));
            float _2695 = exp2(log2(mad(_59, _2676, mad(_58, _2673, (_2670 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2696 = exp2(log2(mad(_62, _2676, mad(_61, _2673, (_2670 * _60))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2697 = exp2(log2(mad(_65, _2676, mad(_64, _2673, (_2670 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2790 = exp2(log2((1.0f / ((_2695 * 18.6875f) + 1.0f)) * ((_2695 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2791 = exp2(log2((1.0f / ((_2696 * 18.6875f) + 1.0f)) * ((_2696 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2792 = exp2(log2((1.0f / ((_2697 * 18.6875f) + 1.0f)) * ((_2697 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2744 = mad((WorkingColorSpace_ToAP1[0].z), _1344, mad((WorkingColorSpace_ToAP1[0].y), _1343, ((WorkingColorSpace_ToAP1[0].x) * _1342)));
                float _2747 = mad((WorkingColorSpace_ToAP1[1].z), _1344, mad((WorkingColorSpace_ToAP1[1].y), _1343, ((WorkingColorSpace_ToAP1[1].x) * _1342)));
                float _2750 = mad((WorkingColorSpace_ToAP1[2].z), _1344, mad((WorkingColorSpace_ToAP1[2].y), _1343, ((WorkingColorSpace_ToAP1[2].x) * _1342)));
                _2790 = mad(_59, _2750, mad(_58, _2747, (_2744 * _57)));
                _2791 = mad(_62, _2750, mad(_61, _2747, (_2744 * _60)));
                _2792 = mad(_65, _2750, mad(_64, _2747, (_2744 * _63)));
              } else {
                float _2763 = mad((WorkingColorSpace_ToAP1[0].z), _1370, mad((WorkingColorSpace_ToAP1[0].y), _1369, ((WorkingColorSpace_ToAP1[0].x) * _1368)));
                float _2766 = mad((WorkingColorSpace_ToAP1[1].z), _1370, mad((WorkingColorSpace_ToAP1[1].y), _1369, ((WorkingColorSpace_ToAP1[1].x) * _1368)));
                float _2769 = mad((WorkingColorSpace_ToAP1[2].z), _1370, mad((WorkingColorSpace_ToAP1[2].y), _1369, ((WorkingColorSpace_ToAP1[2].x) * _1368)));
                _2790 = exp2(log2(mad(_59, _2769, mad(_58, _2766, (_2763 * _57)))) * InverseGamma.z);
                _2791 = exp2(log2(mad(_62, _2769, mad(_61, _2766, (_2763 * _60)))) * InverseGamma.z);
                _2792 = exp2(log2(mad(_65, _2769, mad(_64, _2766, (_2763 * _63)))) * InverseGamma.z);
              }
            } else {
              _2790 = _1354;
              _2791 = _1355;
              _2792 = _1356;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2790 * 0.9523810148239136f), (_2791 * 0.9523810148239136f), (_2792 * 0.9523810148239136f), 0.0f);
}

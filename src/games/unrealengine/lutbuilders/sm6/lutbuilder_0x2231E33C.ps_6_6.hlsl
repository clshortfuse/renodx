#include "../../common.hlsl"

// REANIMAL demo

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
  uint bIsTemperatureWhiteBalance : packoffset(c038.w);
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
  float _12[6];
  float _13[6];
  float _14[6];
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _19[6];
  float _22 = 0.5f / LUTSize;
  float _27 = LUTSize + -1.0f;
  float _28 = (LUTSize * (TEXCOORD.x - _22)) / _27;
  float _29 = (LUTSize * (TEXCOORD.y - _22)) / _27;
  float _31 = float((uint)SV_RenderTargetArrayIndex) / _27;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _117;
  float _118;
  float _119;
  float _167;
  float _895;
  float _928;
  float _942;
  float _1006;
  float _1274;
  float _1275;
  float _1276;
  float _1287;
  float _1298;
  float _1471;
  float _1486;
  float _1501;
  float _1509;
  float _1510;
  float _1511;
  float _1578;
  float _1611;
  float _1625;
  float _1664;
  float _1786;
  float _1872;
  float _1946;
  float _2025;
  float _2026;
  float _2027;
  float _2157;
  float _2172;
  float _2187;
  float _2195;
  float _2196;
  float _2197;
  float _2264;
  float _2297;
  float _2311;
  float _2350;
  float _2472;
  float _2558;
  float _2644;
  float _2723;
  float _2724;
  float _2725;
  float _2902;
  float _2903;
  float _2904;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _40 = ((uint)(OutputGamut) == 4);
        _51 = select(_40, 1.0f, 1.705051064491272f);
        _52 = select(_40, 0.0f, -0.6217921376228333f);
        _53 = select(_40, 0.0f, -0.0832589864730835f);
        _54 = select(_40, 0.0f, -0.13025647401809692f);
        _55 = select(_40, 1.0f, 1.140804648399353f);
        _56 = select(_40, 0.0f, -0.010548308491706848f);
        _57 = select(_40, 0.0f, -0.024003351107239723f);
        _58 = select(_40, 0.0f, -0.1289689838886261f);
        _59 = select(_40, 1.0f, 1.1529725790023804f);
      } else {
        _51 = 0.6954522132873535f;
        _52 = 0.14067870378494263f;
        _53 = 0.16386906802654266f;
        _54 = 0.044794563204050064f;
        _55 = 0.8596711158752441f;
        _56 = 0.0955343171954155f;
        _57 = -0.005525882821530104f;
        _58 = 0.004025210160762072f;
        _59 = 1.0015007257461548f;
      }
    } else {
      _51 = 1.0258246660232544f;
      _52 = -0.020053181797266006f;
      _53 = -0.005771636962890625f;
      _54 = -0.002234415616840124f;
      _55 = 1.0045864582061768f;
      _56 = -0.002352118492126465f;
      _57 = -0.005013350863009691f;
      _58 = -0.025290070101618767f;
      _59 = 1.0303035974502563f;
    }
  } else {
    _51 = 1.3792141675949097f;
    _52 = -0.30886411666870117f;
    _53 = -0.0703500509262085f;
    _54 = -0.06933490186929703f;
    _55 = 1.08229660987854f;
    _56 = -0.012961871922016144f;
    _57 = -0.0021590073592960835f;
    _58 = -0.0454593189060688f;
    _59 = 1.0476183891296387f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _70 = (pow(_28, 0.012683313339948654f));
    float _71 = (pow(_29, 0.012683313339948654f));
    float _72 = (pow(_31, 0.012683313339948654f));
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _117 = ((exp2((_28 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _118 = ((exp2((_29 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _119 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _146 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _150 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _167 = (((((2967800.0f - (_150 * 4607000064.0f)) * _150) + 99.11000061035156f) * _150) + 0.24406300485134125f);
  } else {
    _167 = (((((1901800.0f - (_150 * 2006400000.0f)) * _150) + 247.47999572753906f) * _150) + 0.23703999817371368f);
  }
  float _181 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _188 = WhiteTemp * WhiteTemp;
  float _191 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_188 * 1.6145605741257896e-07f));
  float _196 = ((_181 * 2.0f) + 4.0f) - (_191 * 8.0f);
  float _197 = (_181 * 3.0f) / _196;
  float _199 = (_191 * 2.0f) / _196;
  bool _200 = (WhiteTemp < 4000.0f);
  float _209 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _211 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_188 * 1.5317699909210205f)) / (_209 * _209);
  float _218 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _188;
  float _220 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_188 * 308.60699462890625f)) / (_218 * _218);
  float _222 = rsqrt(dot(float2(_211, _220), float2(_211, _220)));
  float _223 = WhiteTint * 0.05000000074505806f;
  float _226 = ((_223 * _220) * _222) + _181;
  float _229 = _191 - ((_223 * _211) * _222);
  float _234 = (4.0f - (_229 * 8.0f)) + (_226 * 2.0f);
  float _240 = (((_226 * 3.0f) / _234) - _197) + select(_200, _197, _167);
  float _241 = (((_229 * 2.0f) / _234) - _199) + select(_200, _199, (((_167 * 2.869999885559082f) + -0.2750000059604645f) - ((_167 * _167) * 3.0f)));
  float _242 = select(_146, _240, 0.3127000033855438f);
  float _243 = select(_146, _241, 0.32899999618530273f);
  float _244 = select(_146, 0.3127000033855438f, _240);
  float _245 = select(_146, 0.32899999618530273f, _241);
  float _246 = max(_243, 1.000000013351432e-10f);
  float _247 = _242 / _246;
  float _250 = ((1.0f - _242) - _243) / _246;
  float _251 = max(_245, 1.000000013351432e-10f);
  float _252 = _244 / _251;
  float _255 = ((1.0f - _244) - _245) / _251;
  float _274 = mad(-0.16140000522136688f, _255, ((_252 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _250, ((_247 * 0.8950999975204468f) + 0.266400009393692f));
  float _275 = mad(0.03669999912381172f, _255, (1.7135000228881836f - (_252 * 0.7501999735832214f))) / mad(0.03669999912381172f, _250, (1.7135000228881836f - (_247 * 0.7501999735832214f)));
  float _276 = mad(1.0296000242233276f, _255, ((_252 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _250, ((_247 * 0.03889999911189079f) + -0.06849999725818634f));
  float _277 = mad(_275, -0.7501999735832214f, 0.0f);
  float _278 = mad(_275, 1.7135000228881836f, 0.0f);
  float _279 = mad(_275, 0.03669999912381172f, -0.0f);
  float _280 = mad(_276, 0.03889999911189079f, 0.0f);
  float _281 = mad(_276, -0.06849999725818634f, 0.0f);
  float _282 = mad(_276, 1.0296000242233276f, 0.0f);
  float _285 = mad(0.1599626988172531f, _280, mad(-0.1470542997121811f, _277, (_274 * 0.883457362651825f)));
  float _288 = mad(0.1599626988172531f, _281, mad(-0.1470542997121811f, _278, (_274 * 0.26293492317199707f)));
  float _291 = mad(0.1599626988172531f, _282, mad(-0.1470542997121811f, _279, (_274 * -0.15930065512657166f)));
  float _294 = mad(0.04929120093584061f, _280, mad(0.5183603167533875f, _277, (_274 * 0.38695648312568665f)));
  float _297 = mad(0.04929120093584061f, _281, mad(0.5183603167533875f, _278, (_274 * 0.11516613513231277f)));
  float _300 = mad(0.04929120093584061f, _282, mad(0.5183603167533875f, _279, (_274 * -0.0697740763425827f)));
  float _303 = mad(0.9684867262840271f, _280, mad(0.04004279896616936f, _277, (_274 * -0.007634039502590895f)));
  float _306 = mad(0.9684867262840271f, _281, mad(0.04004279896616936f, _278, (_274 * -0.0022720457054674625f)));
  float _309 = mad(0.9684867262840271f, _282, mad(0.04004279896616936f, _279, (_274 * 0.0013765322510153055f)));
  float _312 = mad(_291, (WorkingColorSpace.ToXYZ[2].x), mad(_288, (WorkingColorSpace.ToXYZ[1].x), (_285 * (WorkingColorSpace.ToXYZ[0].x))));
  float _315 = mad(_291, (WorkingColorSpace.ToXYZ[2].y), mad(_288, (WorkingColorSpace.ToXYZ[1].y), (_285 * (WorkingColorSpace.ToXYZ[0].y))));
  float _318 = mad(_291, (WorkingColorSpace.ToXYZ[2].z), mad(_288, (WorkingColorSpace.ToXYZ[1].z), (_285 * (WorkingColorSpace.ToXYZ[0].z))));
  float _321 = mad(_300, (WorkingColorSpace.ToXYZ[2].x), mad(_297, (WorkingColorSpace.ToXYZ[1].x), (_294 * (WorkingColorSpace.ToXYZ[0].x))));
  float _324 = mad(_300, (WorkingColorSpace.ToXYZ[2].y), mad(_297, (WorkingColorSpace.ToXYZ[1].y), (_294 * (WorkingColorSpace.ToXYZ[0].y))));
  float _327 = mad(_300, (WorkingColorSpace.ToXYZ[2].z), mad(_297, (WorkingColorSpace.ToXYZ[1].z), (_294 * (WorkingColorSpace.ToXYZ[0].z))));
  float _330 = mad(_309, (WorkingColorSpace.ToXYZ[2].x), mad(_306, (WorkingColorSpace.ToXYZ[1].x), (_303 * (WorkingColorSpace.ToXYZ[0].x))));
  float _333 = mad(_309, (WorkingColorSpace.ToXYZ[2].y), mad(_306, (WorkingColorSpace.ToXYZ[1].y), (_303 * (WorkingColorSpace.ToXYZ[0].y))));
  float _336 = mad(_309, (WorkingColorSpace.ToXYZ[2].z), mad(_306, (WorkingColorSpace.ToXYZ[1].z), (_303 * (WorkingColorSpace.ToXYZ[0].z))));
  float _366 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _336, mad((WorkingColorSpace.FromXYZ[0].y), _327, (_318 * (WorkingColorSpace.FromXYZ[0].x)))), _119, mad(mad((WorkingColorSpace.FromXYZ[0].z), _333, mad((WorkingColorSpace.FromXYZ[0].y), _324, (_315 * (WorkingColorSpace.FromXYZ[0].x)))), _118, (mad((WorkingColorSpace.FromXYZ[0].z), _330, mad((WorkingColorSpace.FromXYZ[0].y), _321, (_312 * (WorkingColorSpace.FromXYZ[0].x)))) * _117)));
  float _369 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _336, mad((WorkingColorSpace.FromXYZ[1].y), _327, (_318 * (WorkingColorSpace.FromXYZ[1].x)))), _119, mad(mad((WorkingColorSpace.FromXYZ[1].z), _333, mad((WorkingColorSpace.FromXYZ[1].y), _324, (_315 * (WorkingColorSpace.FromXYZ[1].x)))), _118, (mad((WorkingColorSpace.FromXYZ[1].z), _330, mad((WorkingColorSpace.FromXYZ[1].y), _321, (_312 * (WorkingColorSpace.FromXYZ[1].x)))) * _117)));
  float _372 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _336, mad((WorkingColorSpace.FromXYZ[2].y), _327, (_318 * (WorkingColorSpace.FromXYZ[2].x)))), _119, mad(mad((WorkingColorSpace.FromXYZ[2].z), _333, mad((WorkingColorSpace.FromXYZ[2].y), _324, (_315 * (WorkingColorSpace.FromXYZ[2].x)))), _118, (mad((WorkingColorSpace.FromXYZ[2].z), _330, mad((WorkingColorSpace.FromXYZ[2].y), _321, (_312 * (WorkingColorSpace.FromXYZ[2].x)))) * _117)));
  float _387 = mad((WorkingColorSpace.ToAP1[0].z), _372, mad((WorkingColorSpace.ToAP1[0].y), _369, ((WorkingColorSpace.ToAP1[0].x) * _366)));
  float _390 = mad((WorkingColorSpace.ToAP1[1].z), _372, mad((WorkingColorSpace.ToAP1[1].y), _369, ((WorkingColorSpace.ToAP1[1].x) * _366)));
  float _393 = mad((WorkingColorSpace.ToAP1[2].z), _372, mad((WorkingColorSpace.ToAP1[2].y), _369, ((WorkingColorSpace.ToAP1[2].x) * _366)));
  float _394 = dot(float3(_387, _390, _393), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  
  SetUngradedAP1(float3(_387, _390, _393));
  
  float _398 = (_387 / _394) + -1.0f;
  float _399 = (_390 / _394) + -1.0f;
  float _400 = (_393 / _394) + -1.0f;
  float _412 = (1.0f - exp2(((_394 * _394) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_398, _399, _400), float3(_398, _399, _400)) * -4.0f));
  float _428 = ((mad(-0.06368321925401688f, _393, mad(-0.3292922377586365f, _390, (_387 * 1.3704125881195068f))) - _387) * _412) + _387;
  float _429 = ((mad(-0.010861365124583244f, _393, mad(1.0970927476882935f, _390, (_387 * -0.08343357592821121f))) - _390) * _412) + _390;
  float _430 = ((mad(1.2036951780319214f, _393, mad(-0.09862580895423889f, _390, (_387 * -0.02579331398010254f))) - _393) * _412) + _393;
  float _431 = dot(float3(_428, _429, _430), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _445 = ColorOffset.w + ColorOffsetShadows.w;
  float _459 = ColorGain.w * ColorGainShadows.w;
  float _473 = ColorGamma.w * ColorGammaShadows.w;
  float _487 = ColorContrast.w * ColorContrastShadows.w;
  float _501 = ColorSaturation.w * ColorSaturationShadows.w;
  float _505 = _428 - _431;
  float _506 = _429 - _431;
  float _507 = _430 - _431;
  float _564 = saturate(_431 / ColorCorrectionShadowsMax);
  float _568 = (_564 * _564) * (3.0f - (_564 * 2.0f));
  float _569 = 1.0f - _568;
  float _578 = ColorOffset.w + ColorOffsetHighlights.w;
  float _587 = ColorGain.w * ColorGainHighlights.w;
  float _596 = ColorGamma.w * ColorGammaHighlights.w;
  float _605 = ColorContrast.w * ColorContrastHighlights.w;
  float _614 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _677 = saturate((_431 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _681 = (_677 * _677) * (3.0f - (_677 * 2.0f));
  float _690 = ColorOffset.w + ColorOffsetMidtones.w;
  float _699 = ColorGain.w * ColorGainMidtones.w;
  float _708 = ColorGamma.w * ColorGammaMidtones.w;
  float _717 = ColorContrast.w * ColorContrastMidtones.w;
  float _726 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _784 = _568 - _681;
  float _795 = ((_681 * (((ColorOffset.x + ColorOffsetHighlights.x) + _578) + (((ColorGain.x * ColorGainHighlights.x) * _587) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _605) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _614) * _505) + _431)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _596)))))) + (_569 * (((ColorOffset.x + ColorOffsetShadows.x) + _445) + (((ColorGain.x * ColorGainShadows.x) * _459) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _487) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _501) * _505) + _431)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _473))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _690) + (((ColorGain.x * ColorGainMidtones.x) * _699) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _717) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _726) * _505) + _431)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _708))))) * _784);
  float _797 = ((_681 * (((ColorOffset.y + ColorOffsetHighlights.y) + _578) + (((ColorGain.y * ColorGainHighlights.y) * _587) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _605) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _614) * _506) + _431)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _596)))))) + (_569 * (((ColorOffset.y + ColorOffsetShadows.y) + _445) + (((ColorGain.y * ColorGainShadows.y) * _459) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _487) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _501) * _506) + _431)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _473))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _690) + (((ColorGain.y * ColorGainMidtones.y) * _699) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _717) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _726) * _506) + _431)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _708))))) * _784);
  float _799 = ((_681 * (((ColorOffset.z + ColorOffsetHighlights.z) + _578) + (((ColorGain.z * ColorGainHighlights.z) * _587) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _605) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _614) * _507) + _431)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _596)))))) + (_569 * (((ColorOffset.z + ColorOffsetShadows.z) + _445) + (((ColorGain.z * ColorGainShadows.z) * _459) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _487) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _501) * _507) + _431)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _473))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _690) + (((ColorGain.z * ColorGainMidtones.z) * _699) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _717) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _726) * _507) + _431)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _708))))) * _784);
  
  SetUntonemappedAP1(float3(_795, _797, _799));
  
  float _835 = ((mad(0.061360642313957214f, _799, mad(-4.540197551250458e-09f, _797, (_795 * 0.9386394023895264f))) - _795) * BlueCorrection) + _795;
  float _836 = ((mad(0.169205904006958f, _799, mad(0.8307942152023315f, _797, (_795 * 6.775371730327606e-08f))) - _797) * BlueCorrection) + _797;
  float _837 = (mad(-2.3283064365386963e-10f, _797, (_795 * -9.313225746154785e-10f)) * BlueCorrection) + _799;
  float _840 = mad(0.16386905312538147f, _837, mad(0.14067868888378143f, _836, (_835 * 0.6954522132873535f)));
  float _843 = mad(0.0955343246459961f, _837, mad(0.8596711158752441f, _836, (_835 * 0.044794581830501556f)));
  float _846 = mad(1.0015007257461548f, _837, mad(0.004025210160762072f, _836, (_835 * -0.005525882821530104f)));
  float _850 = max(max(_840, _843), _846);
  float _855 = (max(_850, 1.000000013351432e-10f) - max(min(min(_840, _843), _846), 1.000000013351432e-10f)) / max(_850, 0.009999999776482582f);
  float _868 = ((_843 + _840) + _846) + (sqrt((((_846 - _843) * _846) + ((_843 - _840) * _843)) + ((_840 - _846) * _840)) * 1.75f);
  float _869 = _868 * 0.3333333432674408f;
  float _870 = _855 + -0.4000000059604645f;
  float _871 = _870 * 5.0f;
  float _875 = max((1.0f - abs(_870 * 2.5f)), 0.0f);
  float _886 = ((float(((int)(uint)((bool)(_871 > 0.0f))) - ((int)(uint)((bool)(_871 < 0.0f)))) * (1.0f - (_875 * _875))) + 1.0f) * 0.02500000037252903f;
  if (!(_869 <= 0.0533333346247673f)) {
    if (!(_869 >= 0.1599999964237213f)) {
      _895 = (((0.23999999463558197f / _868) + -0.5f) * _886);
    } else {
      _895 = 0.0f;
    }
  } else {
    _895 = _886;
  }
  float _896 = _895 + 1.0f;
  float _897 = _896 * _840;
  float _898 = _896 * _843;
  float _899 = _896 * _846;
  if (!((bool)(_897 == _898) && (bool)(_898 == _899))) {
    float _906 = ((_897 * 2.0f) - _898) - _899;
    float _909 = ((_843 - _846) * 1.7320507764816284f) * _896;
    float _911 = atan(_909 / _906);
    bool _914 = (_906 < 0.0f);
    bool _915 = (_906 == 0.0f);
    bool _916 = (_909 >= 0.0f);
    bool _917 = (_909 < 0.0f);
    _928 = select((_916 && _915), 90.0f, select((_917 && _915), -90.0f, (select((_917 && _914), (_911 + -3.1415927410125732f), select((_916 && _914), (_911 + 3.1415927410125732f), _911)) * 57.2957763671875f)));
  } else {
    _928 = 0.0f;
  }
  float _933 = min(max(select((_928 < 0.0f), (_928 + 360.0f), _928), 0.0f), 360.0f);
  if (_933 < -180.0f) {
    _942 = (_933 + 360.0f);
  } else {
    if (_933 > 180.0f) {
      _942 = (_933 + -360.0f);
    } else {
      _942 = _933;
    }
  }
  float _946 = saturate(1.0f - abs(_942 * 0.014814814552664757f));
  float _950 = (_946 * _946) * (3.0f - (_946 * 2.0f));
  float _956 = ((_950 * _950) * ((_855 * 0.18000000715255737f) * (0.029999999329447746f - _897))) + _897;
  float _966 = max(0.0f, mad(-0.21492856740951538f, _899, mad(-0.2365107536315918f, _898, (_956 * 1.4514392614364624f))));
  float _967 = max(0.0f, mad(-0.09967592358589172f, _899, mad(1.17622971534729f, _898, (_956 * -0.07655377686023712f))));
  float _968 = max(0.0f, mad(0.9977163076400757f, _899, mad(-0.006032449658960104f, _898, (_956 * 0.008316148072481155f))));
  float _969 = dot(float3(_966, _967, _968), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _984 = (FilmBlackClip + 1.0f) - FilmToe;
  float _986 = FilmWhiteClip + 1.0f;
  float _988 = _986 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1006 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _997 = (FilmBlackClip + 0.18000000715255737f) / _984;
    _1006 = (-0.7447274923324585f - ((log2(_997 / (2.0f - _997)) * 0.3465735912322998f) * (_984 / FilmSlope)));
  }
  float _1009 = ((1.0f - FilmToe) / FilmSlope) - _1006;
  float _1011 = (FilmShoulder / FilmSlope) - _1009;
  float _1015 = log2(lerp(_969, _966, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1016 = log2(lerp(_969, _967, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1017 = log2(lerp(_969, _968, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1021 = FilmSlope * (_1015 + _1009);
  float _1022 = FilmSlope * (_1016 + _1009);
  float _1023 = FilmSlope * (_1017 + _1009);
  float _1024 = _984 * 2.0f;
  float _1026 = (FilmSlope * -2.0f) / _984;
  float _1027 = _1015 - _1006;
  float _1028 = _1016 - _1006;
  float _1029 = _1017 - _1006;
  float _1048 = _988 * 2.0f;
  float _1050 = (FilmSlope * 2.0f) / _988;
  float _1075 = select((_1015 < _1006), ((_1024 / (exp2((_1027 * 1.4426950216293335f) * _1026) + 1.0f)) - FilmBlackClip), _1021);
  float _1076 = select((_1016 < _1006), ((_1024 / (exp2((_1028 * 1.4426950216293335f) * _1026) + 1.0f)) - FilmBlackClip), _1022);
  float _1077 = select((_1017 < _1006), ((_1024 / (exp2((_1029 * 1.4426950216293335f) * _1026) + 1.0f)) - FilmBlackClip), _1023);
  float _1084 = _1011 - _1006;
  float _1088 = saturate(_1027 / _1084);
  float _1089 = saturate(_1028 / _1084);
  float _1090 = saturate(_1029 / _1084);
  bool _1091 = (_1011 < _1006);
  float _1095 = select(_1091, (1.0f - _1088), _1088);
  float _1096 = select(_1091, (1.0f - _1089), _1089);
  float _1097 = select(_1091, (1.0f - _1090), _1090);
  float _1116 = (((_1095 * _1095) * (select((_1015 > _1011), (_986 - (_1048 / (exp2(((_1015 - _1011) * 1.4426950216293335f) * _1050) + 1.0f))), _1021) - _1075)) * (3.0f - (_1095 * 2.0f))) + _1075;
  float _1117 = (((_1096 * _1096) * (select((_1016 > _1011), (_986 - (_1048 / (exp2(((_1016 - _1011) * 1.4426950216293335f) * _1050) + 1.0f))), _1022) - _1076)) * (3.0f - (_1096 * 2.0f))) + _1076;
  float _1118 = (((_1097 * _1097) * (select((_1017 > _1011), (_986 - (_1048 / (exp2(((_1017 - _1011) * 1.4426950216293335f) * _1050) + 1.0f))), _1023) - _1077)) * (3.0f - (_1097 * 2.0f))) + _1077;
  float _1119 = dot(float3(_1116, _1117, _1118), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1139 = (ToneCurveAmount * (max(0.0f, (lerp(_1119, _1116, 0.9300000071525574f))) - _835)) + _835;
  float _1140 = (ToneCurveAmount * (max(0.0f, (lerp(_1119, _1117, 0.9300000071525574f))) - _836)) + _836;
  float _1141 = (ToneCurveAmount * (max(0.0f, (lerp(_1119, _1118, 0.9300000071525574f))) - _837)) + _837;
  float _1157 = ((mad(-0.06537103652954102f, _1141, mad(1.451815478503704e-06f, _1140, (_1139 * 1.065374732017517f))) - _1139) * BlueCorrection) + _1139;
  float _1158 = ((mad(-0.20366770029067993f, _1141, mad(1.2036634683609009f, _1140, (_1139 * -2.57161445915699e-07f))) - _1140) * BlueCorrection) + _1140;
  float _1159 = ((mad(0.9999996423721313f, _1141, mad(2.0954757928848267e-08f, _1140, (_1139 * 1.862645149230957e-08f))) - _1141) * BlueCorrection) + _1141;
  
  SetTonemappedAP1(_1157, _1158, _1159);
  
  float _1169 = max(0.0f, mad((WorkingColorSpace.FromAP1[0].z), _1159, mad((WorkingColorSpace.FromAP1[0].y), _1158, ((WorkingColorSpace.FromAP1[0].x) * _1157))));
  float _1170 = max(0.0f, mad((WorkingColorSpace.FromAP1[1].z), _1159, mad((WorkingColorSpace.FromAP1[1].y), _1158, ((WorkingColorSpace.FromAP1[1].x) * _1157))));
  float _1171 = max(0.0f, mad((WorkingColorSpace.FromAP1[2].z), _1159, mad((WorkingColorSpace.FromAP1[2].y), _1158, ((WorkingColorSpace.FromAP1[2].x) * _1157))));
  float _1197 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1169)) * _1169) + MappingPolynomial.z);
  float _1198 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1170)) * _1170) + MappingPolynomial.z);
  float _1199 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1171)) * _1171) + MappingPolynomial.z);
  float _1206 = ((OverlayColor.x - _1197) * OverlayColor.w) + _1197;
  float _1207 = ((OverlayColor.y - _1198) * OverlayColor.w) + _1198;
  float _1208 = ((OverlayColor.z - _1199) * OverlayColor.w) + _1199;
  float _1209 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _799, mad((WorkingColorSpace.FromAP1[0].y), _797, (_795 * (WorkingColorSpace.FromAP1[0].x))));
  float _1210 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _799, mad((WorkingColorSpace.FromAP1[1].y), _797, ((WorkingColorSpace.FromAP1[1].x) * _795)));
  float _1211 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _799, mad((WorkingColorSpace.FromAP1[2].y), _797, ((WorkingColorSpace.FromAP1[2].x) * _795)));
  float _1218 = ((OverlayColor.x - _1209) * OverlayColor.w) + _1209;
  float _1219 = ((OverlayColor.y - _1210) * OverlayColor.w) + _1210;
  float _1220 = ((OverlayColor.z - _1211) * OverlayColor.w) + _1211;
  float _1232 = exp2(log2(max(0.0f, _1206)) * InverseGamma.y);
  float _1233 = exp2(log2(max(0.0f, _1207)) * InverseGamma.y);
  float _1234 = exp2(log2(max(0.0f, _1208)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1232, _1233, _1234));
  }
  
  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace.bIsSRGB) == 0) {
        float _1257 = mad((WorkingColorSpace.ToAP1[0].z), _1234, mad((WorkingColorSpace.ToAP1[0].y), _1233, ((WorkingColorSpace.ToAP1[0].x) * _1232)));
        float _1260 = mad((WorkingColorSpace.ToAP1[1].z), _1234, mad((WorkingColorSpace.ToAP1[1].y), _1233, ((WorkingColorSpace.ToAP1[1].x) * _1232)));
        float _1263 = mad((WorkingColorSpace.ToAP1[2].z), _1234, mad((WorkingColorSpace.ToAP1[2].y), _1233, ((WorkingColorSpace.ToAP1[2].x) * _1232)));
        _1274 = mad(_53, _1263, mad(_52, _1260, (_1257 * _51)));
        _1275 = mad(_56, _1263, mad(_55, _1260, (_1257 * _54)));
        _1276 = mad(_59, _1263, mad(_58, _1260, (_1257 * _57)));
      } else {
        _1274 = _1232;
        _1275 = _1233;
        _1276 = _1234;
      }
      do {
        if (_1274 < 0.0031306699384003878f) {
          _1287 = (_1274 * 12.920000076293945f);
        } else {
          _1287 = (((pow(_1274, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1275 < 0.0031306699384003878f) {
            _1298 = (_1275 * 12.920000076293945f);
          } else {
            _1298 = (((pow(_1275, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1276 < 0.0031306699384003878f) {
            _2902 = _1287;
            _2903 = _1298;
            _2904 = (_1276 * 12.920000076293945f);
          } else {
            _2902 = _1287;
            _2903 = _1298;
            _2904 = (((pow(_1276, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1325 = mad((WorkingColorSpace.ToAP1[0].z), _1234, mad((WorkingColorSpace.ToAP1[0].y), _1233, ((WorkingColorSpace.ToAP1[0].x) * _1232)));
      float _1328 = mad((WorkingColorSpace.ToAP1[1].z), _1234, mad((WorkingColorSpace.ToAP1[1].y), _1233, ((WorkingColorSpace.ToAP1[1].x) * _1232)));
      float _1331 = mad((WorkingColorSpace.ToAP1[2].z), _1234, mad((WorkingColorSpace.ToAP1[2].y), _1233, ((WorkingColorSpace.ToAP1[2].x) * _1232)));
      float _1341 = max(6.103519990574569e-05f, mad(_53, _1331, mad(_52, _1328, (_1325 * _51))));
      float _1342 = max(6.103519990574569e-05f, mad(_56, _1331, mad(_55, _1328, (_1325 * _54))));
      float _1343 = max(6.103519990574569e-05f, mad(_59, _1331, mad(_58, _1328, (_1325 * _57))));
      _2902 = min((_1341 * 4.5f), ((exp2(log2(max(_1341, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2903 = min((_1342 * 4.5f), ((exp2(log2(max(_1342, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2904 = min((_1343 * 4.5f), ((exp2(log2(max(_1343, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
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
        float _1419 = ACESSceneColorMultiplier * _1218;
        float _1420 = ACESSceneColorMultiplier * _1219;
        float _1421 = ACESSceneColorMultiplier * _1220;
        float _1424 = mad((WorkingColorSpace.ToAP0[0].z), _1421, mad((WorkingColorSpace.ToAP0[0].y), _1420, ((WorkingColorSpace.ToAP0[0].x) * _1419)));
        float _1427 = mad((WorkingColorSpace.ToAP0[1].z), _1421, mad((WorkingColorSpace.ToAP0[1].y), _1420, ((WorkingColorSpace.ToAP0[1].x) * _1419)));
        float _1430 = mad((WorkingColorSpace.ToAP0[2].z), _1421, mad((WorkingColorSpace.ToAP0[2].y), _1420, ((WorkingColorSpace.ToAP0[2].x) * _1419)));
        float _1433 = mad(-0.21492856740951538f, _1430, mad(-0.2365107536315918f, _1427, (_1424 * 1.4514392614364624f)));
        float _1436 = mad(-0.09967592358589172f, _1430, mad(1.17622971534729f, _1427, (_1424 * -0.07655377686023712f)));
        float _1439 = mad(0.9977163076400757f, _1430, mad(-0.006032449658960104f, _1427, (_1424 * 0.008316148072481155f)));
        float _1441 = max(_1433, max(_1436, _1439));
        do {
          if (!(_1441 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1424 < 0.0f) || (bool)(_1427 < 0.0f))) || (bool)(_1430 < 0.0f))) {
              float _1451 = abs(_1441);
              float _1452 = (_1441 - _1433) / _1451;
              float _1454 = (_1441 - _1436) / _1451;
              float _1456 = (_1441 - _1439) / _1451;
              do {
                if (!(_1452 < 0.8149999976158142f)) {
                  float _1459 = _1452 + -0.8149999976158142f;
                  _1471 = ((_1459 / exp2(log2(exp2(log2(_1459 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1471 = _1452;
                }
                do {
                  if (!(_1454 < 0.8029999732971191f)) {
                    float _1474 = _1454 + -0.8029999732971191f;
                    _1486 = ((_1474 / exp2(log2(exp2(log2(_1474 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1486 = _1454;
                  }
                  do {
                    if (!(_1456 < 0.8799999952316284f)) {
                      float _1489 = _1456 + -0.8799999952316284f;
                      _1501 = ((_1489 / exp2(log2(exp2(log2(_1489 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1501 = _1456;
                    }
                    _1509 = (_1441 - (_1451 * _1471));
                    _1510 = (_1441 - (_1451 * _1486));
                    _1511 = (_1441 - (_1451 * _1501));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1509 = _1433;
              _1510 = _1436;
              _1511 = _1439;
            }
          } else {
            _1509 = _1433;
            _1510 = _1436;
            _1511 = _1439;
          }
          float _1527 = ((mad(0.16386906802654266f, _1511, mad(0.14067870378494263f, _1510, (_1509 * 0.6954522132873535f))) - _1424) * ACESGamutCompression) + _1424;
          float _1528 = ((mad(0.0955343171954155f, _1511, mad(0.8596711158752441f, _1510, (_1509 * 0.044794563204050064f))) - _1427) * ACESGamutCompression) + _1427;
          float _1529 = ((mad(1.0015007257461548f, _1511, mad(0.004025210160762072f, _1510, (_1509 * -0.005525882821530104f))) - _1430) * ACESGamutCompression) + _1430;
          float _1533 = max(max(_1527, _1528), _1529);
          float _1538 = (max(_1533, 1.000000013351432e-10f) - max(min(min(_1527, _1528), _1529), 1.000000013351432e-10f)) / max(_1533, 0.009999999776482582f);
          float _1551 = ((_1528 + _1527) + _1529) + (sqrt((((_1529 - _1528) * _1529) + ((_1528 - _1527) * _1528)) + ((_1527 - _1529) * _1527)) * 1.75f);
          float _1552 = _1551 * 0.3333333432674408f;
          float _1553 = _1538 + -0.4000000059604645f;
          float _1554 = _1553 * 5.0f;
          float _1558 = max((1.0f - abs(_1553 * 2.5f)), 0.0f);
          float _1569 = ((float(((int)(uint)((bool)(_1554 > 0.0f))) - ((int)(uint)((bool)(_1554 < 0.0f)))) * (1.0f - (_1558 * _1558))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1552 <= 0.0533333346247673f)) {
              if (!(_1552 >= 0.1599999964237213f)) {
                _1578 = (((0.23999999463558197f / _1551) + -0.5f) * _1569);
              } else {
                _1578 = 0.0f;
              }
            } else {
              _1578 = _1569;
            }
            float _1579 = _1578 + 1.0f;
            float _1580 = _1579 * _1527;
            float _1581 = _1579 * _1528;
            float _1582 = _1579 * _1529;
            do {
              if (!((bool)(_1580 == _1581) && (bool)(_1581 == _1582))) {
                float _1589 = ((_1580 * 2.0f) - _1581) - _1582;
                float _1592 = ((_1528 - _1529) * 1.7320507764816284f) * _1579;
                float _1594 = atan(_1592 / _1589);
                bool _1597 = (_1589 < 0.0f);
                bool _1598 = (_1589 == 0.0f);
                bool _1599 = (_1592 >= 0.0f);
                bool _1600 = (_1592 < 0.0f);
                _1611 = select((_1599 && _1598), 90.0f, select((_1600 && _1598), -90.0f, (select((_1600 && _1597), (_1594 + -3.1415927410125732f), select((_1599 && _1597), (_1594 + 3.1415927410125732f), _1594)) * 57.2957763671875f)));
              } else {
                _1611 = 0.0f;
              }
              float _1616 = min(max(select((_1611 < 0.0f), (_1611 + 360.0f), _1611), 0.0f), 360.0f);
              do {
                if (_1616 < -180.0f) {
                  _1625 = (_1616 + 360.0f);
                } else {
                  if (_1616 > 180.0f) {
                    _1625 = (_1616 + -360.0f);
                  } else {
                    _1625 = _1616;
                  }
                }
                do {
                  if ((bool)(_1625 > -67.5f) && (bool)(_1625 < 67.5f)) {
                    float _1631 = (_1625 + 67.5f) * 0.029629629105329514f;
                    int _1632 = int(_1631);
                    float _1634 = _1631 - float(_1632);
                    float _1635 = _1634 * _1634;
                    float _1636 = _1635 * _1634;
                    if (_1632 == 3) {
                      _1664 = (((0.1666666716337204f - (_1634 * 0.5f)) + (_1635 * 0.5f)) - (_1636 * 0.1666666716337204f));
                    } else {
                      if (_1632 == 2) {
                        _1664 = ((0.6666666865348816f - _1635) + (_1636 * 0.5f));
                      } else {
                        if (_1632 == 1) {
                          _1664 = (((_1636 * -0.5f) + 0.1666666716337204f) + ((_1635 + _1634) * 0.5f));
                        } else {
                          _1664 = select((_1632 == 0), (_1636 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1664 = 0.0f;
                  }
                  float _1673 = min(max(((((_1538 * 0.27000001072883606f) * (0.029999999329447746f - _1580)) * _1664) + _1580), 0.0f), 65535.0f);
                  float _1674 = min(max(_1581, 0.0f), 65535.0f);
                  float _1675 = min(max(_1582, 0.0f), 65535.0f);
                  float _1688 = min(max(mad(-0.21492856740951538f, _1675, mad(-0.2365107536315918f, _1674, (_1673 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1689 = min(max(mad(-0.09967592358589172f, _1675, mad(1.17622971534729f, _1674, (_1673 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1690 = min(max(mad(0.9977163076400757f, _1675, mad(-0.006032449658960104f, _1674, (_1673 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1691 = dot(float3(_1688, _1689, _1690), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1714 = log2(max((lerp(_1691, _1688, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1715 = _1714 * 0.3010300099849701f;
                  float _1716 = log2(ACESMinMaxData.x);
                  float _1717 = _1716 * 0.3010300099849701f;
                  do {
                    if (!(!(_1715 <= _1717))) {
                      _1786 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1724 = log2(ACESMidData.x);
                      float _1725 = _1724 * 0.3010300099849701f;
                      if ((bool)(_1715 > _1717) && (bool)(_1715 < _1725)) {
                        float _1733 = ((_1714 - _1716) * 0.9030900001525879f) / ((_1724 - _1716) * 0.3010300099849701f);
                        int _1734 = int(_1733);
                        float _1736 = _1733 - float(_1734);
                        float _1738 = _16[_1734];
                        float _1741 = _16[(_1734 + 1)];
                        float _1746 = _1738 * 0.5f;
                        _1786 = dot(float3((_1736 * _1736), _1736, 1.0f), float3(mad((_16[(_1734 + 2)]), 0.5f, mad(_1741, -1.0f, _1746)), (_1741 - _1738), mad(_1741, 0.5f, _1746)));
                      } else {
                        do {
                          if (!(!(_1715 >= _1725))) {
                            float _1755 = log2(ACESMinMaxData.z);
                            if (_1715 < (_1755 * 0.3010300099849701f)) {
                              float _1763 = ((_1714 - _1724) * 0.9030900001525879f) / ((_1755 - _1724) * 0.3010300099849701f);
                              int _1764 = int(_1763);
                              float _1766 = _1763 - float(_1764);
                              float _1768 = _17[_1764];
                              float _1771 = _17[(_1764 + 1)];
                              float _1776 = _1768 * 0.5f;
                              _1786 = dot(float3((_1766 * _1766), _1766, 1.0f), float3(mad((_17[(_1764 + 2)]), 0.5f, mad(_1771, -1.0f, _1776)), (_1771 - _1768), mad(_1771, 0.5f, _1776)));
                              break;
                            }
                          }
                          _1786 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
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
                    float _1802 = log2(max((lerp(_1691, _1689, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1803 = _1802 * 0.3010300099849701f;
                    do {
                      if (!(!(_1803 <= _1717))) {
                        _1872 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1810 = log2(ACESMidData.x);
                        float _1811 = _1810 * 0.3010300099849701f;
                        if ((bool)(_1803 > _1717) && (bool)(_1803 < _1811)) {
                          float _1819 = ((_1802 - _1716) * 0.9030900001525879f) / ((_1810 - _1716) * 0.3010300099849701f);
                          int _1820 = int(_1819);
                          float _1822 = _1819 - float(_1820);
                          float _1824 = _18[_1820];
                          float _1827 = _18[(_1820 + 1)];
                          float _1832 = _1824 * 0.5f;
                          _1872 = dot(float3((_1822 * _1822), _1822, 1.0f), float3(mad((_18[(_1820 + 2)]), 0.5f, mad(_1827, -1.0f, _1832)), (_1827 - _1824), mad(_1827, 0.5f, _1832)));
                        } else {
                          do {
                            if (!(!(_1803 >= _1811))) {
                              float _1841 = log2(ACESMinMaxData.z);
                              if (_1803 < (_1841 * 0.3010300099849701f)) {
                                float _1849 = ((_1802 - _1810) * 0.9030900001525879f) / ((_1841 - _1810) * 0.3010300099849701f);
                                int _1850 = int(_1849);
                                float _1852 = _1849 - float(_1850);
                                float _1854 = _19[_1850];
                                float _1857 = _19[(_1850 + 1)];
                                float _1862 = _1854 * 0.5f;
                                _1872 = dot(float3((_1852 * _1852), _1852, 1.0f), float3(mad((_19[(_1850 + 2)]), 0.5f, mad(_1857, -1.0f, _1862)), (_1857 - _1854), mad(_1857, 0.5f, _1862)));
                                break;
                              }
                            }
                            _1872 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1876 = log2(max((lerp(_1691, _1690, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1877 = _1876 * 0.3010300099849701f;
                      do {
                        if (!(!(_1877 <= _1717))) {
                          _1946 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1884 = log2(ACESMidData.x);
                          float _1885 = _1884 * 0.3010300099849701f;
                          if ((bool)(_1877 > _1717) && (bool)(_1877 < _1885)) {
                            float _1893 = ((_1876 - _1716) * 0.9030900001525879f) / ((_1884 - _1716) * 0.3010300099849701f);
                            int _1894 = int(_1893);
                            float _1896 = _1893 - float(_1894);
                            float _1898 = _8[_1894];
                            float _1901 = _8[(_1894 + 1)];
                            float _1906 = _1898 * 0.5f;
                            _1946 = dot(float3((_1896 * _1896), _1896, 1.0f), float3(mad((_8[(_1894 + 2)]), 0.5f, mad(_1901, -1.0f, _1906)), (_1901 - _1898), mad(_1901, 0.5f, _1906)));
                          } else {
                            do {
                              if (!(!(_1877 >= _1885))) {
                                float _1915 = log2(ACESMinMaxData.z);
                                if (_1877 < (_1915 * 0.3010300099849701f)) {
                                  float _1923 = ((_1876 - _1884) * 0.9030900001525879f) / ((_1915 - _1884) * 0.3010300099849701f);
                                  int _1924 = int(_1923);
                                  float _1926 = _1923 - float(_1924);
                                  float _1928 = _9[_1924];
                                  float _1931 = _9[(_1924 + 1)];
                                  float _1936 = _1928 * 0.5f;
                                  _1946 = dot(float3((_1926 * _1926), _1926, 1.0f), float3(mad((_9[(_1924 + 2)]), 0.5f, mad(_1931, -1.0f, _1936)), (_1931 - _1928), mad(_1931, 0.5f, _1936)));
                                  break;
                                }
                              }
                              _1946 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1950 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1951 = (exp2(_1786 * 3.321928024291992f) - ACESMinMaxData.y) / _1950;
                        float _1953 = (exp2(_1872 * 3.321928024291992f) - ACESMinMaxData.y) / _1950;
                        float _1955 = (exp2(_1946 * 3.321928024291992f) - ACESMinMaxData.y) / _1950;
                        float _1958 = mad(0.15618768334388733f, _1955, mad(0.13400420546531677f, _1953, (_1951 * 0.6624541878700256f)));
                        float _1961 = mad(0.053689517080783844f, _1955, mad(0.6740817427635193f, _1953, (_1951 * 0.2722287178039551f)));
                        float _1964 = mad(1.0103391408920288f, _1955, mad(0.00406073359772563f, _1953, (_1951 * -0.005574649665504694f)));
                        float _1977 = min(max(mad(-0.23642469942569733f, _1964, mad(-0.32480329275131226f, _1961, (_1958 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1978 = min(max(mad(0.016756348311901093f, _1964, mad(1.6153316497802734f, _1961, (_1958 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1979 = min(max(mad(0.9883948564529419f, _1964, mad(-0.008284442126750946f, _1961, (_1958 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1982 = mad(0.15618768334388733f, _1979, mad(0.13400420546531677f, _1978, (_1977 * 0.6624541878700256f)));
                        float _1985 = mad(0.053689517080783844f, _1979, mad(0.6740817427635193f, _1978, (_1977 * 0.2722287178039551f)));
                        float _1988 = mad(1.0103391408920288f, _1979, mad(0.00406073359772563f, _1978, (_1977 * -0.005574649665504694f)));
                        float _2010 = min(max((min(max(mad(-0.23642469942569733f, _1988, mad(-0.32480329275131226f, _1985, (_1982 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2011 = min(max((min(max(mad(0.016756348311901093f, _1988, mad(1.6153316497802734f, _1985, (_1982 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2012 = min(max((min(max(mad(0.9883948564529419f, _1988, mad(-0.008284442126750946f, _1985, (_1982 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 5)) {
                            _2025 = mad(_53, _2012, mad(_52, _2011, (_2010 * _51)));
                            _2026 = mad(_56, _2012, mad(_55, _2011, (_2010 * _54)));
                            _2027 = mad(_59, _2012, mad(_58, _2011, (_2010 * _57)));
                          } else {
                            _2025 = _2010;
                            _2026 = _2011;
                            _2027 = _2012;
                          }
                          float _2037 = exp2(log2(_2025 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2038 = exp2(log2(_2026 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2039 = exp2(log2(_2027 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2902 = exp2(log2((1.0f / ((_2037 * 18.6875f) + 1.0f)) * ((_2037 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2903 = exp2(log2((1.0f / ((_2038 * 18.6875f) + 1.0f)) * ((_2038 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2904 = exp2(log2((1.0f / ((_2039 * 18.6875f) + 1.0f)) * ((_2039 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2105 = ACESSceneColorMultiplier * _1218;
          float _2106 = ACESSceneColorMultiplier * _1219;
          float _2107 = ACESSceneColorMultiplier * _1220;
          float _2110 = mad((WorkingColorSpace.ToAP0[0].z), _2107, mad((WorkingColorSpace.ToAP0[0].y), _2106, ((WorkingColorSpace.ToAP0[0].x) * _2105)));
          float _2113 = mad((WorkingColorSpace.ToAP0[1].z), _2107, mad((WorkingColorSpace.ToAP0[1].y), _2106, ((WorkingColorSpace.ToAP0[1].x) * _2105)));
          float _2116 = mad((WorkingColorSpace.ToAP0[2].z), _2107, mad((WorkingColorSpace.ToAP0[2].y), _2106, ((WorkingColorSpace.ToAP0[2].x) * _2105)));
          float _2119 = mad(-0.21492856740951538f, _2116, mad(-0.2365107536315918f, _2113, (_2110 * 1.4514392614364624f)));
          float _2122 = mad(-0.09967592358589172f, _2116, mad(1.17622971534729f, _2113, (_2110 * -0.07655377686023712f)));
          float _2125 = mad(0.9977163076400757f, _2116, mad(-0.006032449658960104f, _2113, (_2110 * 0.008316148072481155f)));
          float _2127 = max(_2119, max(_2122, _2125));
          do {
            if (!(_2127 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2110 < 0.0f) || (bool)(_2113 < 0.0f))) || (bool)(_2116 < 0.0f))) {
                float _2137 = abs(_2127);
                float _2138 = (_2127 - _2119) / _2137;
                float _2140 = (_2127 - _2122) / _2137;
                float _2142 = (_2127 - _2125) / _2137;
                do {
                  if (!(_2138 < 0.8149999976158142f)) {
                    float _2145 = _2138 + -0.8149999976158142f;
                    _2157 = ((_2145 / exp2(log2(exp2(log2(_2145 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2157 = _2138;
                  }
                  do {
                    if (!(_2140 < 0.8029999732971191f)) {
                      float _2160 = _2140 + -0.8029999732971191f;
                      _2172 = ((_2160 / exp2(log2(exp2(log2(_2160 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2172 = _2140;
                    }
                    do {
                      if (!(_2142 < 0.8799999952316284f)) {
                        float _2175 = _2142 + -0.8799999952316284f;
                        _2187 = ((_2175 / exp2(log2(exp2(log2(_2175 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2187 = _2142;
                      }
                      _2195 = (_2127 - (_2137 * _2157));
                      _2196 = (_2127 - (_2137 * _2172));
                      _2197 = (_2127 - (_2137 * _2187));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2195 = _2119;
                _2196 = _2122;
                _2197 = _2125;
              }
            } else {
              _2195 = _2119;
              _2196 = _2122;
              _2197 = _2125;
            }
            float _2213 = ((mad(0.16386906802654266f, _2197, mad(0.14067870378494263f, _2196, (_2195 * 0.6954522132873535f))) - _2110) * ACESGamutCompression) + _2110;
            float _2214 = ((mad(0.0955343171954155f, _2197, mad(0.8596711158752441f, _2196, (_2195 * 0.044794563204050064f))) - _2113) * ACESGamutCompression) + _2113;
            float _2215 = ((mad(1.0015007257461548f, _2197, mad(0.004025210160762072f, _2196, (_2195 * -0.005525882821530104f))) - _2116) * ACESGamutCompression) + _2116;
            float _2219 = max(max(_2213, _2214), _2215);
            float _2224 = (max(_2219, 1.000000013351432e-10f) - max(min(min(_2213, _2214), _2215), 1.000000013351432e-10f)) / max(_2219, 0.009999999776482582f);
            float _2237 = ((_2214 + _2213) + _2215) + (sqrt((((_2215 - _2214) * _2215) + ((_2214 - _2213) * _2214)) + ((_2213 - _2215) * _2213)) * 1.75f);
            float _2238 = _2237 * 0.3333333432674408f;
            float _2239 = _2224 + -0.4000000059604645f;
            float _2240 = _2239 * 5.0f;
            float _2244 = max((1.0f - abs(_2239 * 2.5f)), 0.0f);
            float _2255 = ((float(((int)(uint)((bool)(_2240 > 0.0f))) - ((int)(uint)((bool)(_2240 < 0.0f)))) * (1.0f - (_2244 * _2244))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2238 <= 0.0533333346247673f)) {
                if (!(_2238 >= 0.1599999964237213f)) {
                  _2264 = (((0.23999999463558197f / _2237) + -0.5f) * _2255);
                } else {
                  _2264 = 0.0f;
                }
              } else {
                _2264 = _2255;
              }
              float _2265 = _2264 + 1.0f;
              float _2266 = _2265 * _2213;
              float _2267 = _2265 * _2214;
              float _2268 = _2265 * _2215;
              do {
                if (!((bool)(_2266 == _2267) && (bool)(_2267 == _2268))) {
                  float _2275 = ((_2266 * 2.0f) - _2267) - _2268;
                  float _2278 = ((_2214 - _2215) * 1.7320507764816284f) * _2265;
                  float _2280 = atan(_2278 / _2275);
                  bool _2283 = (_2275 < 0.0f);
                  bool _2284 = (_2275 == 0.0f);
                  bool _2285 = (_2278 >= 0.0f);
                  bool _2286 = (_2278 < 0.0f);
                  _2297 = select((_2285 && _2284), 90.0f, select((_2286 && _2284), -90.0f, (select((_2286 && _2283), (_2280 + -3.1415927410125732f), select((_2285 && _2283), (_2280 + 3.1415927410125732f), _2280)) * 57.2957763671875f)));
                } else {
                  _2297 = 0.0f;
                }
                float _2302 = min(max(select((_2297 < 0.0f), (_2297 + 360.0f), _2297), 0.0f), 360.0f);
                do {
                  if (_2302 < -180.0f) {
                    _2311 = (_2302 + 360.0f);
                  } else {
                    if (_2302 > 180.0f) {
                      _2311 = (_2302 + -360.0f);
                    } else {
                      _2311 = _2302;
                    }
                  }
                  do {
                    if ((bool)(_2311 > -67.5f) && (bool)(_2311 < 67.5f)) {
                      float _2317 = (_2311 + 67.5f) * 0.029629629105329514f;
                      int _2318 = int(_2317);
                      float _2320 = _2317 - float(_2318);
                      float _2321 = _2320 * _2320;
                      float _2322 = _2321 * _2320;
                      if (_2318 == 3) {
                        _2350 = (((0.1666666716337204f - (_2320 * 0.5f)) + (_2321 * 0.5f)) - (_2322 * 0.1666666716337204f));
                      } else {
                        if (_2318 == 2) {
                          _2350 = ((0.6666666865348816f - _2321) + (_2322 * 0.5f));
                        } else {
                          if (_2318 == 1) {
                            _2350 = (((_2322 * -0.5f) + 0.1666666716337204f) + ((_2321 + _2320) * 0.5f));
                          } else {
                            _2350 = select((_2318 == 0), (_2322 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2350 = 0.0f;
                    }
                    float _2359 = min(max(((((_2224 * 0.27000001072883606f) * (0.029999999329447746f - _2266)) * _2350) + _2266), 0.0f), 65535.0f);
                    float _2360 = min(max(_2267, 0.0f), 65535.0f);
                    float _2361 = min(max(_2268, 0.0f), 65535.0f);
                    float _2374 = min(max(mad(-0.21492856740951538f, _2361, mad(-0.2365107536315918f, _2360, (_2359 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2375 = min(max(mad(-0.09967592358589172f, _2361, mad(1.17622971534729f, _2360, (_2359 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2376 = min(max(mad(0.9977163076400757f, _2361, mad(-0.006032449658960104f, _2360, (_2359 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2377 = dot(float3(_2374, _2375, _2376), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2400 = log2(max((lerp(_2377, _2374, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2401 = _2400 * 0.3010300099849701f;
                    float _2402 = log2(ACESMinMaxData.x);
                    float _2403 = _2402 * 0.3010300099849701f;
                    do {
                      if (!(!(_2401 <= _2403))) {
                        _2472 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2410 = log2(ACESMidData.x);
                        float _2411 = _2410 * 0.3010300099849701f;
                        if ((bool)(_2401 > _2403) && (bool)(_2401 < _2411)) {
                          float _2419 = ((_2400 - _2402) * 0.9030900001525879f) / ((_2410 - _2402) * 0.3010300099849701f);
                          int _2420 = int(_2419);
                          float _2422 = _2419 - float(_2420);
                          float _2424 = _14[_2420];
                          float _2427 = _14[(_2420 + 1)];
                          float _2432 = _2424 * 0.5f;
                          _2472 = dot(float3((_2422 * _2422), _2422, 1.0f), float3(mad((_14[(_2420 + 2)]), 0.5f, mad(_2427, -1.0f, _2432)), (_2427 - _2424), mad(_2427, 0.5f, _2432)));
                        } else {
                          do {
                            if (!(!(_2401 >= _2411))) {
                              float _2441 = log2(ACESMinMaxData.z);
                              if (_2401 < (_2441 * 0.3010300099849701f)) {
                                float _2449 = ((_2400 - _2410) * 0.9030900001525879f) / ((_2441 - _2410) * 0.3010300099849701f);
                                int _2450 = int(_2449);
                                float _2452 = _2449 - float(_2450);
                                float _2454 = _15[_2450];
                                float _2457 = _15[(_2450 + 1)];
                                float _2462 = _2454 * 0.5f;
                                _2472 = dot(float3((_2452 * _2452), _2452, 1.0f), float3(mad((_15[(_2450 + 2)]), 0.5f, mad(_2457, -1.0f, _2462)), (_2457 - _2454), mad(_2457, 0.5f, _2462)));
                                break;
                              }
                            }
                            _2472 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
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
                      float _2488 = log2(max((lerp(_2377, _2375, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2489 = _2488 * 0.3010300099849701f;
                      do {
                        if (!(!(_2489 <= _2403))) {
                          _2558 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2496 = log2(ACESMidData.x);
                          float _2497 = _2496 * 0.3010300099849701f;
                          if ((bool)(_2489 > _2403) && (bool)(_2489 < _2497)) {
                            float _2505 = ((_2488 - _2402) * 0.9030900001525879f) / ((_2496 - _2402) * 0.3010300099849701f);
                            int _2506 = int(_2505);
                            float _2508 = _2505 - float(_2506);
                            float _2510 = _10[_2506];
                            float _2513 = _10[(_2506 + 1)];
                            float _2518 = _2510 * 0.5f;
                            _2558 = dot(float3((_2508 * _2508), _2508, 1.0f), float3(mad((_10[(_2506 + 2)]), 0.5f, mad(_2513, -1.0f, _2518)), (_2513 - _2510), mad(_2513, 0.5f, _2518)));
                          } else {
                            do {
                              if (!(!(_2489 >= _2497))) {
                                float _2527 = log2(ACESMinMaxData.z);
                                if (_2489 < (_2527 * 0.3010300099849701f)) {
                                  float _2535 = ((_2488 - _2496) * 0.9030900001525879f) / ((_2527 - _2496) * 0.3010300099849701f);
                                  int _2536 = int(_2535);
                                  float _2538 = _2535 - float(_2536);
                                  float _2540 = _11[_2536];
                                  float _2543 = _11[(_2536 + 1)];
                                  float _2548 = _2540 * 0.5f;
                                  _2558 = dot(float3((_2538 * _2538), _2538, 1.0f), float3(mad((_11[(_2536 + 2)]), 0.5f, mad(_2543, -1.0f, _2548)), (_2543 - _2540), mad(_2543, 0.5f, _2548)));
                                  break;
                                }
                              }
                              _2558 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
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
                        float _2574 = log2(max((lerp(_2377, _2376, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2575 = _2574 * 0.3010300099849701f;
                        do {
                          if (!(!(_2575 <= _2403))) {
                            _2644 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2582 = log2(ACESMidData.x);
                            float _2583 = _2582 * 0.3010300099849701f;
                            if ((bool)(_2575 > _2403) && (bool)(_2575 < _2583)) {
                              float _2591 = ((_2574 - _2402) * 0.9030900001525879f) / ((_2582 - _2402) * 0.3010300099849701f);
                              int _2592 = int(_2591);
                              float _2594 = _2591 - float(_2592);
                              float _2596 = _12[_2592];
                              float _2599 = _12[(_2592 + 1)];
                              float _2604 = _2596 * 0.5f;
                              _2644 = dot(float3((_2594 * _2594), _2594, 1.0f), float3(mad((_12[(_2592 + 2)]), 0.5f, mad(_2599, -1.0f, _2604)), (_2599 - _2596), mad(_2599, 0.5f, _2604)));
                            } else {
                              do {
                                if (!(!(_2575 >= _2583))) {
                                  float _2613 = log2(ACESMinMaxData.z);
                                  if (_2575 < (_2613 * 0.3010300099849701f)) {
                                    float _2621 = ((_2574 - _2582) * 0.9030900001525879f) / ((_2613 - _2582) * 0.3010300099849701f);
                                    int _2622 = int(_2621);
                                    float _2624 = _2621 - float(_2622);
                                    float _2626 = _13[_2622];
                                    float _2629 = _13[(_2622 + 1)];
                                    float _2634 = _2626 * 0.5f;
                                    _2644 = dot(float3((_2624 * _2624), _2624, 1.0f), float3(mad((_13[(_2622 + 2)]), 0.5f, mad(_2629, -1.0f, _2634)), (_2629 - _2626), mad(_2629, 0.5f, _2634)));
                                    break;
                                  }
                                }
                                _2644 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2648 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2649 = (exp2(_2472 * 3.321928024291992f) - ACESMinMaxData.y) / _2648;
                          float _2651 = (exp2(_2558 * 3.321928024291992f) - ACESMinMaxData.y) / _2648;
                          float _2653 = (exp2(_2644 * 3.321928024291992f) - ACESMinMaxData.y) / _2648;
                          float _2656 = mad(0.15618768334388733f, _2653, mad(0.13400420546531677f, _2651, (_2649 * 0.6624541878700256f)));
                          float _2659 = mad(0.053689517080783844f, _2653, mad(0.6740817427635193f, _2651, (_2649 * 0.2722287178039551f)));
                          float _2662 = mad(1.0103391408920288f, _2653, mad(0.00406073359772563f, _2651, (_2649 * -0.005574649665504694f)));
                          float _2675 = min(max(mad(-0.23642469942569733f, _2662, mad(-0.32480329275131226f, _2659, (_2656 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2676 = min(max(mad(0.016756348311901093f, _2662, mad(1.6153316497802734f, _2659, (_2656 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2677 = min(max(mad(0.9883948564529419f, _2662, mad(-0.008284442126750946f, _2659, (_2656 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2680 = mad(0.15618768334388733f, _2677, mad(0.13400420546531677f, _2676, (_2675 * 0.6624541878700256f)));
                          float _2683 = mad(0.053689517080783844f, _2677, mad(0.6740817427635193f, _2676, (_2675 * 0.2722287178039551f)));
                          float _2686 = mad(1.0103391408920288f, _2677, mad(0.00406073359772563f, _2676, (_2675 * -0.005574649665504694f)));
                          float _2708 = min(max((min(max(mad(-0.23642469942569733f, _2686, mad(-0.32480329275131226f, _2683, (_2680 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2709 = min(max((min(max(mad(0.016756348311901093f, _2686, mad(1.6153316497802734f, _2683, (_2680 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2710 = min(max((min(max(mad(0.9883948564529419f, _2686, mad(-0.008284442126750946f, _2683, (_2680 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!((uint)(OutputDevice) == 6)) {
                              _2723 = mad(_53, _2710, mad(_52, _2709, (_2708 * _51)));
                              _2724 = mad(_56, _2710, mad(_55, _2709, (_2708 * _54)));
                              _2725 = mad(_59, _2710, mad(_58, _2709, (_2708 * _57)));
                            } else {
                              _2723 = _2708;
                              _2724 = _2709;
                              _2725 = _2710;
                            }
                            float _2735 = exp2(log2(_2723 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2736 = exp2(log2(_2724 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2737 = exp2(log2(_2725 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2902 = exp2(log2((1.0f / ((_2735 * 18.6875f) + 1.0f)) * ((_2735 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2903 = exp2(log2((1.0f / ((_2736 * 18.6875f) + 1.0f)) * ((_2736 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2904 = exp2(log2((1.0f / ((_2737 * 18.6875f) + 1.0f)) * ((_2737 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2782 = mad((WorkingColorSpace.ToAP1[0].z), _1220, mad((WorkingColorSpace.ToAP1[0].y), _1219, ((WorkingColorSpace.ToAP1[0].x) * _1218)));
            float _2785 = mad((WorkingColorSpace.ToAP1[1].z), _1220, mad((WorkingColorSpace.ToAP1[1].y), _1219, ((WorkingColorSpace.ToAP1[1].x) * _1218)));
            float _2788 = mad((WorkingColorSpace.ToAP1[2].z), _1220, mad((WorkingColorSpace.ToAP1[2].y), _1219, ((WorkingColorSpace.ToAP1[2].x) * _1218)));
            float _2807 = exp2(log2(mad(_53, _2788, mad(_52, _2785, (_2782 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2808 = exp2(log2(mad(_56, _2788, mad(_55, _2785, (_2782 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2809 = exp2(log2(mad(_59, _2788, mad(_58, _2785, (_2782 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2902 = exp2(log2((1.0f / ((_2807 * 18.6875f) + 1.0f)) * ((_2807 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2903 = exp2(log2((1.0f / ((_2808 * 18.6875f) + 1.0f)) * ((_2808 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2904 = exp2(log2((1.0f / ((_2809 * 18.6875f) + 1.0f)) * ((_2809 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2856 = mad((WorkingColorSpace.ToAP1[0].z), _1208, mad((WorkingColorSpace.ToAP1[0].y), _1207, ((WorkingColorSpace.ToAP1[0].x) * _1206)));
                float _2859 = mad((WorkingColorSpace.ToAP1[1].z), _1208, mad((WorkingColorSpace.ToAP1[1].y), _1207, ((WorkingColorSpace.ToAP1[1].x) * _1206)));
                float _2862 = mad((WorkingColorSpace.ToAP1[2].z), _1208, mad((WorkingColorSpace.ToAP1[2].y), _1207, ((WorkingColorSpace.ToAP1[2].x) * _1206)));
                _2902 = mad(_53, _2862, mad(_52, _2859, (_2856 * _51)));
                _2903 = mad(_56, _2862, mad(_55, _2859, (_2856 * _54)));
                _2904 = mad(_59, _2862, mad(_58, _2859, (_2856 * _57)));
              } else {
                float _2875 = mad((WorkingColorSpace.ToAP1[0].z), _1234, mad((WorkingColorSpace.ToAP1[0].y), _1233, ((WorkingColorSpace.ToAP1[0].x) * _1232)));
                float _2878 = mad((WorkingColorSpace.ToAP1[1].z), _1234, mad((WorkingColorSpace.ToAP1[1].y), _1233, ((WorkingColorSpace.ToAP1[1].x) * _1232)));
                float _2881 = mad((WorkingColorSpace.ToAP1[2].z), _1234, mad((WorkingColorSpace.ToAP1[2].y), _1233, ((WorkingColorSpace.ToAP1[2].x) * _1232)));
                _2902 = exp2(log2(mad(_53, _2881, mad(_52, _2878, (_2875 * _51)))) * InverseGamma.z);
                _2903 = exp2(log2(mad(_56, _2881, mad(_55, _2878, (_2875 * _54)))) * InverseGamma.z);
                _2904 = exp2(log2(mad(_59, _2881, mad(_58, _2878, (_2875 * _57)))) * InverseGamma.z);
              }
            } else {
              _2902 = _1218;
              _2903 = _1219;
              _2904 = _1220;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2902 * 0.9523810148239136f);
  SV_Target.y = (_2903 * 0.9523810148239136f);
  SV_Target.z = (_2904 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);
  
  return SV_Target;
}

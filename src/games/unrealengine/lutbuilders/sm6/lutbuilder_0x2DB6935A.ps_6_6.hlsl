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

SamplerState Samplers_1 : register(s0);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
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
  float _23 = 0.5f / LUTSize;
  float _28 = LUTSize + -1.0f;
  float _29 = (LUTSize * (TEXCOORD.x - _23)) / _28;
  float _30 = (LUTSize * (TEXCOORD.y - _23)) / _28;
  float _32 = float((uint)SV_RenderTargetArrayIndex) / _28;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _118;
  float _119;
  float _120;
  float _168;
  float _896;
  float _929;
  float _943;
  float _1007;
  float _1186;
  float _1197;
  float _1208;
  float _1381;
  float _1382;
  float _1383;
  float _1394;
  float _1405;
  float _1578;
  float _1593;
  float _1608;
  float _1616;
  float _1617;
  float _1618;
  float _1685;
  float _1718;
  float _1732;
  float _1771;
  float _1887;
  float _1973;
  float _2047;
  float _2126;
  float _2127;
  float _2128;
  float _2258;
  float _2273;
  float _2288;
  float _2296;
  float _2297;
  float _2298;
  float _2365;
  float _2398;
  float _2412;
  float _2451;
  float _2573;
  float _2659;
  float _2745;
  float _2824;
  float _2825;
  float _2826;
  float _3003;
  float _3004;
  float _3005;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _41 = ((uint)(OutputGamut) == 4);
        _52 = select(_41, 1.0f, 1.705051064491272f);
        _53 = select(_41, 0.0f, -0.6217921376228333f);
        _54 = select(_41, 0.0f, -0.0832589864730835f);
        _55 = select(_41, 0.0f, -0.13025647401809692f);
        _56 = select(_41, 1.0f, 1.140804648399353f);
        _57 = select(_41, 0.0f, -0.010548308491706848f);
        _58 = select(_41, 0.0f, -0.024003351107239723f);
        _59 = select(_41, 0.0f, -0.1289689838886261f);
        _60 = select(_41, 1.0f, 1.1529725790023804f);
      } else {
        _52 = 0.6954522132873535f;
        _53 = 0.14067870378494263f;
        _54 = 0.16386906802654266f;
        _55 = 0.044794563204050064f;
        _56 = 0.8596711158752441f;
        _57 = 0.0955343171954155f;
        _58 = -0.005525882821530104f;
        _59 = 0.004025210160762072f;
        _60 = 1.0015007257461548f;
      }
    } else {
      _52 = 1.0258246660232544f;
      _53 = -0.020053181797266006f;
      _54 = -0.005771636962890625f;
      _55 = -0.002234415616840124f;
      _56 = 1.0045864582061768f;
      _57 = -0.002352118492126465f;
      _58 = -0.005013350863009691f;
      _59 = -0.025290070101618767f;
      _60 = 1.0303035974502563f;
    }
  } else {
    _52 = 1.3792141675949097f;
    _53 = -0.30886411666870117f;
    _54 = -0.0703500509262085f;
    _55 = -0.06933490186929703f;
    _56 = 1.08229660987854f;
    _57 = -0.012961871922016144f;
    _58 = -0.0021590073592960835f;
    _59 = -0.0454593189060688f;
    _60 = 1.0476183891296387f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _71 = (pow(_29, 0.012683313339948654f));
    float _72 = (pow(_30, 0.012683313339948654f));
    float _73 = (pow(_32, 0.012683313339948654f));
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _118 = ((exp2((_29 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _119 = ((exp2((_30 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _120 = ((exp2((_32 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _147 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _151 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _168 = (((((2967800.0f - (_151 * 4607000064.0f)) * _151) + 99.11000061035156f) * _151) + 0.24406300485134125f);
  } else {
    _168 = (((((1901800.0f - (_151 * 2006400000.0f)) * _151) + 247.47999572753906f) * _151) + 0.23703999817371368f);
  }
  float _182 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _189 = WhiteTemp * WhiteTemp;
  float _192 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_189 * 1.6145605741257896e-07f));
  float _197 = ((_182 * 2.0f) + 4.0f) - (_192 * 8.0f);
  float _198 = (_182 * 3.0f) / _197;
  float _200 = (_192 * 2.0f) / _197;
  bool _201 = (WhiteTemp < 4000.0f);
  float _210 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _212 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_189 * 1.5317699909210205f)) / (_210 * _210);
  float _219 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _189;
  float _221 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_189 * 308.60699462890625f)) / (_219 * _219);
  float _223 = rsqrt(dot(float2(_212, _221), float2(_212, _221)));
  float _224 = WhiteTint * 0.05000000074505806f;
  float _227 = ((_224 * _221) * _223) + _182;
  float _230 = _192 - ((_224 * _212) * _223);
  float _235 = (4.0f - (_230 * 8.0f)) + (_227 * 2.0f);
  float _241 = (((_227 * 3.0f) / _235) - _198) + select(_201, _198, _168);
  float _242 = (((_230 * 2.0f) / _235) - _200) + select(_201, _200, (((_168 * 2.869999885559082f) + -0.2750000059604645f) - ((_168 * _168) * 3.0f)));
  float _243 = select(_147, _241, 0.3127000033855438f);
  float _244 = select(_147, _242, 0.32899999618530273f);
  float _245 = select(_147, 0.3127000033855438f, _241);
  float _246 = select(_147, 0.32899999618530273f, _242);
  float _247 = max(_244, 1.000000013351432e-10f);
  float _248 = _243 / _247;
  float _251 = ((1.0f - _243) - _244) / _247;
  float _252 = max(_246, 1.000000013351432e-10f);
  float _253 = _245 / _252;
  float _256 = ((1.0f - _245) - _246) / _252;
  float _275 = mad(-0.16140000522136688f, _256, ((_253 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _251, ((_248 * 0.8950999975204468f) + 0.266400009393692f));
  float _276 = mad(0.03669999912381172f, _256, (1.7135000228881836f - (_253 * 0.7501999735832214f))) / mad(0.03669999912381172f, _251, (1.7135000228881836f - (_248 * 0.7501999735832214f)));
  float _277 = mad(1.0296000242233276f, _256, ((_253 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _251, ((_248 * 0.03889999911189079f) + -0.06849999725818634f));
  float _278 = mad(_276, -0.7501999735832214f, 0.0f);
  float _279 = mad(_276, 1.7135000228881836f, 0.0f);
  float _280 = mad(_276, 0.03669999912381172f, -0.0f);
  float _281 = mad(_277, 0.03889999911189079f, 0.0f);
  float _282 = mad(_277, -0.06849999725818634f, 0.0f);
  float _283 = mad(_277, 1.0296000242233276f, 0.0f);
  float _286 = mad(0.1599626988172531f, _281, mad(-0.1470542997121811f, _278, (_275 * 0.883457362651825f)));
  float _289 = mad(0.1599626988172531f, _282, mad(-0.1470542997121811f, _279, (_275 * 0.26293492317199707f)));
  float _292 = mad(0.1599626988172531f, _283, mad(-0.1470542997121811f, _280, (_275 * -0.15930065512657166f)));
  float _295 = mad(0.04929120093584061f, _281, mad(0.5183603167533875f, _278, (_275 * 0.38695648312568665f)));
  float _298 = mad(0.04929120093584061f, _282, mad(0.5183603167533875f, _279, (_275 * 0.11516613513231277f)));
  float _301 = mad(0.04929120093584061f, _283, mad(0.5183603167533875f, _280, (_275 * -0.0697740763425827f)));
  float _304 = mad(0.9684867262840271f, _281, mad(0.04004279896616936f, _278, (_275 * -0.007634039502590895f)));
  float _307 = mad(0.9684867262840271f, _282, mad(0.04004279896616936f, _279, (_275 * -0.0022720457054674625f)));
  float _310 = mad(0.9684867262840271f, _283, mad(0.04004279896616936f, _280, (_275 * 0.0013765322510153055f)));
  float _313 = mad(_292, (WorkingColorSpace.ToXYZ[2].x), mad(_289, (WorkingColorSpace.ToXYZ[1].x), (_286 * (WorkingColorSpace.ToXYZ[0].x))));
  float _316 = mad(_292, (WorkingColorSpace.ToXYZ[2].y), mad(_289, (WorkingColorSpace.ToXYZ[1].y), (_286 * (WorkingColorSpace.ToXYZ[0].y))));
  float _319 = mad(_292, (WorkingColorSpace.ToXYZ[2].z), mad(_289, (WorkingColorSpace.ToXYZ[1].z), (_286 * (WorkingColorSpace.ToXYZ[0].z))));
  float _322 = mad(_301, (WorkingColorSpace.ToXYZ[2].x), mad(_298, (WorkingColorSpace.ToXYZ[1].x), (_295 * (WorkingColorSpace.ToXYZ[0].x))));
  float _325 = mad(_301, (WorkingColorSpace.ToXYZ[2].y), mad(_298, (WorkingColorSpace.ToXYZ[1].y), (_295 * (WorkingColorSpace.ToXYZ[0].y))));
  float _328 = mad(_301, (WorkingColorSpace.ToXYZ[2].z), mad(_298, (WorkingColorSpace.ToXYZ[1].z), (_295 * (WorkingColorSpace.ToXYZ[0].z))));
  float _331 = mad(_310, (WorkingColorSpace.ToXYZ[2].x), mad(_307, (WorkingColorSpace.ToXYZ[1].x), (_304 * (WorkingColorSpace.ToXYZ[0].x))));
  float _334 = mad(_310, (WorkingColorSpace.ToXYZ[2].y), mad(_307, (WorkingColorSpace.ToXYZ[1].y), (_304 * (WorkingColorSpace.ToXYZ[0].y))));
  float _337 = mad(_310, (WorkingColorSpace.ToXYZ[2].z), mad(_307, (WorkingColorSpace.ToXYZ[1].z), (_304 * (WorkingColorSpace.ToXYZ[0].z))));
  float _367 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _337, mad((WorkingColorSpace.FromXYZ[0].y), _328, (_319 * (WorkingColorSpace.FromXYZ[0].x)))), _120, mad(mad((WorkingColorSpace.FromXYZ[0].z), _334, mad((WorkingColorSpace.FromXYZ[0].y), _325, (_316 * (WorkingColorSpace.FromXYZ[0].x)))), _119, (mad((WorkingColorSpace.FromXYZ[0].z), _331, mad((WorkingColorSpace.FromXYZ[0].y), _322, (_313 * (WorkingColorSpace.FromXYZ[0].x)))) * _118)));
  float _370 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _337, mad((WorkingColorSpace.FromXYZ[1].y), _328, (_319 * (WorkingColorSpace.FromXYZ[1].x)))), _120, mad(mad((WorkingColorSpace.FromXYZ[1].z), _334, mad((WorkingColorSpace.FromXYZ[1].y), _325, (_316 * (WorkingColorSpace.FromXYZ[1].x)))), _119, (mad((WorkingColorSpace.FromXYZ[1].z), _331, mad((WorkingColorSpace.FromXYZ[1].y), _322, (_313 * (WorkingColorSpace.FromXYZ[1].x)))) * _118)));
  float _373 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _337, mad((WorkingColorSpace.FromXYZ[2].y), _328, (_319 * (WorkingColorSpace.FromXYZ[2].x)))), _120, mad(mad((WorkingColorSpace.FromXYZ[2].z), _334, mad((WorkingColorSpace.FromXYZ[2].y), _325, (_316 * (WorkingColorSpace.FromXYZ[2].x)))), _119, (mad((WorkingColorSpace.FromXYZ[2].z), _331, mad((WorkingColorSpace.FromXYZ[2].y), _322, (_313 * (WorkingColorSpace.FromXYZ[2].x)))) * _118)));
  float _388 = mad((WorkingColorSpace.ToAP1[0].z), _373, mad((WorkingColorSpace.ToAP1[0].y), _370, ((WorkingColorSpace.ToAP1[0].x) * _367)));
  float _391 = mad((WorkingColorSpace.ToAP1[1].z), _373, mad((WorkingColorSpace.ToAP1[1].y), _370, ((WorkingColorSpace.ToAP1[1].x) * _367)));
  float _394 = mad((WorkingColorSpace.ToAP1[2].z), _373, mad((WorkingColorSpace.ToAP1[2].y), _370, ((WorkingColorSpace.ToAP1[2].x) * _367)));
  float _395 = dot(float3(_388, _391, _394), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_388, _391, _394));

  float _399 = (_388 / _395) + -1.0f;
  float _400 = (_391 / _395) + -1.0f;
  float _401 = (_394 / _395) + -1.0f;
  float _413 = (1.0f - exp2(((_395 * _395) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_399, _400, _401), float3(_399, _400, _401)) * -4.0f));
  float _429 = ((mad(-0.06368321925401688f, _394, mad(-0.3292922377586365f, _391, (_388 * 1.3704125881195068f))) - _388) * _413) + _388;
  float _430 = ((mad(-0.010861365124583244f, _394, mad(1.0970927476882935f, _391, (_388 * -0.08343357592821121f))) - _391) * _413) + _391;
  float _431 = ((mad(1.2036951780319214f, _394, mad(-0.09862580895423889f, _391, (_388 * -0.02579331398010254f))) - _394) * _413) + _394;
  float _432 = dot(float3(_429, _430, _431), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _446 = ColorOffset.w + ColorOffsetShadows.w;
  float _460 = ColorGain.w * ColorGainShadows.w;
  float _474 = ColorGamma.w * ColorGammaShadows.w;
  float _488 = ColorContrast.w * ColorContrastShadows.w;
  float _502 = ColorSaturation.w * ColorSaturationShadows.w;
  float _506 = _429 - _432;
  float _507 = _430 - _432;
  float _508 = _431 - _432;
  float _565 = saturate(_432 / ColorCorrectionShadowsMax);
  float _569 = (_565 * _565) * (3.0f - (_565 * 2.0f));
  float _570 = 1.0f - _569;
  float _579 = ColorOffset.w + ColorOffsetHighlights.w;
  float _588 = ColorGain.w * ColorGainHighlights.w;
  float _597 = ColorGamma.w * ColorGammaHighlights.w;
  float _606 = ColorContrast.w * ColorContrastHighlights.w;
  float _615 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _678 = saturate((_432 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _682 = (_678 * _678) * (3.0f - (_678 * 2.0f));
  float _691 = ColorOffset.w + ColorOffsetMidtones.w;
  float _700 = ColorGain.w * ColorGainMidtones.w;
  float _709 = ColorGamma.w * ColorGammaMidtones.w;
  float _718 = ColorContrast.w * ColorContrastMidtones.w;
  float _727 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _785 = _569 - _682;
  float _796 = ((_682 * (((ColorOffset.x + ColorOffsetHighlights.x) + _579) + (((ColorGain.x * ColorGainHighlights.x) * _588) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _606) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _615) * _506) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _597)))))) + (_570 * (((ColorOffset.x + ColorOffsetShadows.x) + _446) + (((ColorGain.x * ColorGainShadows.x) * _460) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _488) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _502) * _506) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _474))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _691) + (((ColorGain.x * ColorGainMidtones.x) * _700) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _718) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _727) * _506) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _709))))) * _785);
  float _798 = ((_682 * (((ColorOffset.y + ColorOffsetHighlights.y) + _579) + (((ColorGain.y * ColorGainHighlights.y) * _588) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _606) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _615) * _507) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _597)))))) + (_570 * (((ColorOffset.y + ColorOffsetShadows.y) + _446) + (((ColorGain.y * ColorGainShadows.y) * _460) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _488) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _502) * _507) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _474))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _691) + (((ColorGain.y * ColorGainMidtones.y) * _700) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _718) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _727) * _507) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _709))))) * _785);
  float _800 = ((_682 * (((ColorOffset.z + ColorOffsetHighlights.z) + _579) + (((ColorGain.z * ColorGainHighlights.z) * _588) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _606) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _615) * _508) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _597)))))) + (_570 * (((ColorOffset.z + ColorOffsetShadows.z) + _446) + (((ColorGain.z * ColorGainShadows.z) * _460) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _488) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _502) * _508) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _474))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _691) + (((ColorGain.z * ColorGainMidtones.z) * _700) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _718) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _727) * _508) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _709))))) * _785);
  
  SetUntonemappedAP1(float3(_796, _798, _800));
  
  float _836 = ((mad(0.061360642313957214f, _800, mad(-4.540197551250458e-09f, _798, (_796 * 0.9386394023895264f))) - _796) * BlueCorrection) + _796;
  float _837 = ((mad(0.169205904006958f, _800, mad(0.8307942152023315f, _798, (_796 * 6.775371730327606e-08f))) - _798) * BlueCorrection) + _798;
  float _838 = (mad(-2.3283064365386963e-10f, _798, (_796 * -9.313225746154785e-10f)) * BlueCorrection) + _800;
  float _841 = mad(0.16386905312538147f, _838, mad(0.14067868888378143f, _837, (_836 * 0.6954522132873535f)));
  float _844 = mad(0.0955343246459961f, _838, mad(0.8596711158752441f, _837, (_836 * 0.044794581830501556f)));
  float _847 = mad(1.0015007257461548f, _838, mad(0.004025210160762072f, _837, (_836 * -0.005525882821530104f)));
  float _851 = max(max(_841, _844), _847);
  float _856 = (max(_851, 1.000000013351432e-10f) - max(min(min(_841, _844), _847), 1.000000013351432e-10f)) / max(_851, 0.009999999776482582f);
  float _869 = ((_844 + _841) + _847) + (sqrt((((_847 - _844) * _847) + ((_844 - _841) * _844)) + ((_841 - _847) * _841)) * 1.75f);
  float _870 = _869 * 0.3333333432674408f;
  float _871 = _856 + -0.4000000059604645f;
  float _872 = _871 * 5.0f;
  float _876 = max((1.0f - abs(_871 * 2.5f)), 0.0f);
  float _887 = ((float(((int)(uint)((bool)(_872 > 0.0f))) - ((int)(uint)((bool)(_872 < 0.0f)))) * (1.0f - (_876 * _876))) + 1.0f) * 0.02500000037252903f;
  if (!(_870 <= 0.0533333346247673f)) {
    if (!(_870 >= 0.1599999964237213f)) {
      _896 = (((0.23999999463558197f / _869) + -0.5f) * _887);
    } else {
      _896 = 0.0f;
    }
  } else {
    _896 = _887;
  }
  float _897 = _896 + 1.0f;
  float _898 = _897 * _841;
  float _899 = _897 * _844;
  float _900 = _897 * _847;
  if (!((bool)(_898 == _899) && (bool)(_899 == _900))) {
    float _907 = ((_898 * 2.0f) - _899) - _900;
    float _910 = ((_844 - _847) * 1.7320507764816284f) * _897;
    float _912 = atan(_910 / _907);
    bool _915 = (_907 < 0.0f);
    bool _916 = (_907 == 0.0f);
    bool _917 = (_910 >= 0.0f);
    bool _918 = (_910 < 0.0f);
    _929 = select((_917 && _916), 90.0f, select((_918 && _916), -90.0f, (select((_918 && _915), (_912 + -3.1415927410125732f), select((_917 && _915), (_912 + 3.1415927410125732f), _912)) * 57.2957763671875f)));
  } else {
    _929 = 0.0f;
  }
  float _934 = min(max(select((_929 < 0.0f), (_929 + 360.0f), _929), 0.0f), 360.0f);
  if (_934 < -180.0f) {
    _943 = (_934 + 360.0f);
  } else {
    if (_934 > 180.0f) {
      _943 = (_934 + -360.0f);
    } else {
      _943 = _934;
    }
  }
  float _947 = saturate(1.0f - abs(_943 * 0.014814814552664757f));
  float _951 = (_947 * _947) * (3.0f - (_947 * 2.0f));
  float _957 = ((_951 * _951) * ((_856 * 0.18000000715255737f) * (0.029999999329447746f - _898))) + _898;
  float _967 = max(0.0f, mad(-0.21492856740951538f, _900, mad(-0.2365107536315918f, _899, (_957 * 1.4514392614364624f))));
  float _968 = max(0.0f, mad(-0.09967592358589172f, _900, mad(1.17622971534729f, _899, (_957 * -0.07655377686023712f))));
  float _969 = max(0.0f, mad(0.9977163076400757f, _900, mad(-0.006032449658960104f, _899, (_957 * 0.008316148072481155f))));
  float _970 = dot(float3(_967, _968, _969), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _985 = (FilmBlackClip + 1.0f) - FilmToe;
  float _987 = FilmWhiteClip + 1.0f;
  float _989 = _987 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1007 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _998 = (FilmBlackClip + 0.18000000715255737f) / _985;
    _1007 = (-0.7447274923324585f - ((log2(_998 / (2.0f - _998)) * 0.3465735912322998f) * (_985 / FilmSlope)));
  }
  float _1010 = ((1.0f - FilmToe) / FilmSlope) - _1007;
  float _1012 = (FilmShoulder / FilmSlope) - _1010;
  float _1016 = log2(lerp(_970, _967, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1017 = log2(lerp(_970, _968, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1018 = log2(lerp(_970, _969, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1022 = FilmSlope * (_1016 + _1010);
  float _1023 = FilmSlope * (_1017 + _1010);
  float _1024 = FilmSlope * (_1018 + _1010);
  float _1025 = _985 * 2.0f;
  float _1027 = (FilmSlope * -2.0f) / _985;
  float _1028 = _1016 - _1007;
  float _1029 = _1017 - _1007;
  float _1030 = _1018 - _1007;
  float _1049 = _989 * 2.0f;
  float _1051 = (FilmSlope * 2.0f) / _989;
  float _1076 = select((_1016 < _1007), ((_1025 / (exp2((_1028 * 1.4426950216293335f) * _1027) + 1.0f)) - FilmBlackClip), _1022);
  float _1077 = select((_1017 < _1007), ((_1025 / (exp2((_1029 * 1.4426950216293335f) * _1027) + 1.0f)) - FilmBlackClip), _1023);
  float _1078 = select((_1018 < _1007), ((_1025 / (exp2((_1030 * 1.4426950216293335f) * _1027) + 1.0f)) - FilmBlackClip), _1024);
  float _1085 = _1012 - _1007;
  float _1089 = saturate(_1028 / _1085);
  float _1090 = saturate(_1029 / _1085);
  float _1091 = saturate(_1030 / _1085);
  bool _1092 = (_1012 < _1007);
  float _1096 = select(_1092, (1.0f - _1089), _1089);
  float _1097 = select(_1092, (1.0f - _1090), _1090);
  float _1098 = select(_1092, (1.0f - _1091), _1091);
  float _1117 = (((_1096 * _1096) * (select((_1016 > _1012), (_987 - (_1049 / (exp2(((_1016 - _1012) * 1.4426950216293335f) * _1051) + 1.0f))), _1022) - _1076)) * (3.0f - (_1096 * 2.0f))) + _1076;
  float _1118 = (((_1097 * _1097) * (select((_1017 > _1012), (_987 - (_1049 / (exp2(((_1017 - _1012) * 1.4426950216293335f) * _1051) + 1.0f))), _1023) - _1077)) * (3.0f - (_1097 * 2.0f))) + _1077;
  float _1119 = (((_1098 * _1098) * (select((_1018 > _1012), (_987 - (_1049 / (exp2(((_1018 - _1012) * 1.4426950216293335f) * _1051) + 1.0f))), _1024) - _1078)) * (3.0f - (_1098 * 2.0f))) + _1078;
  float _1120 = dot(float3(_1117, _1118, _1119), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1140 = (ToneCurveAmount * (max(0.0f, (lerp(_1120, _1117, 0.9300000071525574f))) - _836)) + _836;
  float _1141 = (ToneCurveAmount * (max(0.0f, (lerp(_1120, _1118, 0.9300000071525574f))) - _837)) + _837;
  float _1142 = (ToneCurveAmount * (max(0.0f, (lerp(_1120, _1119, 0.9300000071525574f))) - _838)) + _838;
  float _1158 = ((mad(-0.06537103652954102f, _1142, mad(1.451815478503704e-06f, _1141, (_1140 * 1.065374732017517f))) - _1140) * BlueCorrection) + _1140;
  float _1159 = ((mad(-0.20366770029067993f, _1142, mad(1.2036634683609009f, _1141, (_1140 * -2.57161445915699e-07f))) - _1141) * BlueCorrection) + _1141;
  float _1160 = ((mad(0.9999996423721313f, _1142, mad(2.0954757928848267e-08f, _1141, (_1140 * 1.862645149230957e-08f))) - _1142) * BlueCorrection) + _1142;
  
  SetTonemappedAP1(_1158, _1159, _1160);
  
  float _1173 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[0].z), _1160, mad((WorkingColorSpace.FromAP1[0].y), _1159, ((WorkingColorSpace.FromAP1[0].x) * _1158)))));
  float _1174 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[1].z), _1160, mad((WorkingColorSpace.FromAP1[1].y), _1159, ((WorkingColorSpace.FromAP1[1].x) * _1158)))));
  float _1175 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[2].z), _1160, mad((WorkingColorSpace.FromAP1[2].y), _1159, ((WorkingColorSpace.FromAP1[2].x) * _1158)))));
  if (_1173 < 0.0031306699384003878f) {
    _1186 = (_1173 * 12.920000076293945f);
  } else {
    _1186 = (((pow(_1173, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1174 < 0.0031306699384003878f) {
    _1197 = (_1174 * 12.920000076293945f);
  } else {
    _1197 = (((pow(_1174, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1175 < 0.0031306699384003878f) {
    _1208 = (_1175 * 12.920000076293945f);
  } else {
    _1208 = (((pow(_1175, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1212 = (_1197 * 0.9375f) + 0.03125f;
  float _1219 = _1208 * 15.0f;
  float _1220 = floor(_1219);
  float _1221 = _1219 - _1220;
  float _1223 = (((_1186 * 0.9375f) + 0.03125f) + _1220) * 0.0625f;
  float4 _1226 = Textures_1.Sample(Samplers_1, float2(_1223, _1212));
  float4 _1233 = Textures_1.Sample(Samplers_1, float2((_1223 + 0.0625f), _1212));
  float _1252 = max(6.103519990574569e-05f, (((lerp(_1226.x, _1233.x, _1221)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1186)));
  float _1253 = max(6.103519990574569e-05f, (((lerp(_1226.y, _1233.y, _1221)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1197)));
  float _1254 = max(6.103519990574569e-05f, (((lerp(_1226.z, _1233.z, _1221)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1208)));
  float _1276 = select((_1252 > 0.040449999272823334f), exp2(log2((_1252 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1252 * 0.07739938050508499f));
  float _1277 = select((_1253 > 0.040449999272823334f), exp2(log2((_1253 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1253 * 0.07739938050508499f));
  float _1278 = select((_1254 > 0.040449999272823334f), exp2(log2((_1254 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1254 * 0.07739938050508499f));
  float _1304 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1276)) * _1276) + MappingPolynomial.z);
  float _1305 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1277)) * _1277) + MappingPolynomial.z);
  float _1306 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1278)) * _1278) + MappingPolynomial.z);
  float _1313 = ((OverlayColor.x - _1304) * OverlayColor.w) + _1304;
  float _1314 = ((OverlayColor.y - _1305) * OverlayColor.w) + _1305;
  float _1315 = ((OverlayColor.z - _1306) * OverlayColor.w) + _1306;
  float _1316 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _800, mad((WorkingColorSpace.FromAP1[0].y), _798, (_796 * (WorkingColorSpace.FromAP1[0].x))));
  float _1317 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _800, mad((WorkingColorSpace.FromAP1[1].y), _798, ((WorkingColorSpace.FromAP1[1].x) * _796)));
  float _1318 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _800, mad((WorkingColorSpace.FromAP1[2].y), _798, ((WorkingColorSpace.FromAP1[2].x) * _796)));
  float _1325 = ((OverlayColor.x - _1316) * OverlayColor.w) + _1316;
  float _1326 = ((OverlayColor.y - _1317) * OverlayColor.w) + _1317;
  float _1327 = ((OverlayColor.z - _1318) * OverlayColor.w) + _1318;
  float _1339 = exp2(log2(max(0.0f, _1313)) * InverseGamma.y);
  float _1340 = exp2(log2(max(0.0f, _1314)) * InverseGamma.y);
  float _1341 = exp2(log2(max(0.0f, _1315)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1339, _1340, _1341));
  }
  
  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace.bIsSRGB) == 0) {
        float _1364 = mad((WorkingColorSpace.ToAP1[0].z), _1341, mad((WorkingColorSpace.ToAP1[0].y), _1340, ((WorkingColorSpace.ToAP1[0].x) * _1339)));
        float _1367 = mad((WorkingColorSpace.ToAP1[1].z), _1341, mad((WorkingColorSpace.ToAP1[1].y), _1340, ((WorkingColorSpace.ToAP1[1].x) * _1339)));
        float _1370 = mad((WorkingColorSpace.ToAP1[2].z), _1341, mad((WorkingColorSpace.ToAP1[2].y), _1340, ((WorkingColorSpace.ToAP1[2].x) * _1339)));
        _1381 = mad(_54, _1370, mad(_53, _1367, (_1364 * _52)));
        _1382 = mad(_57, _1370, mad(_56, _1367, (_1364 * _55)));
        _1383 = mad(_60, _1370, mad(_59, _1367, (_1364 * _58)));
      } else {
        _1381 = _1339;
        _1382 = _1340;
        _1383 = _1341;
      }
      do {
        if (_1381 < 0.0031306699384003878f) {
          _1394 = (_1381 * 12.920000076293945f);
        } else {
          _1394 = (((pow(_1381, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1382 < 0.0031306699384003878f) {
            _1405 = (_1382 * 12.920000076293945f);
          } else {
            _1405 = (((pow(_1382, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1383 < 0.0031306699384003878f) {
            _3003 = _1394;
            _3004 = _1405;
            _3005 = (_1383 * 12.920000076293945f);
          } else {
            _3003 = _1394;
            _3004 = _1405;
            _3005 = (((pow(_1383, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1432 = mad((WorkingColorSpace.ToAP1[0].z), _1341, mad((WorkingColorSpace.ToAP1[0].y), _1340, ((WorkingColorSpace.ToAP1[0].x) * _1339)));
      float _1435 = mad((WorkingColorSpace.ToAP1[1].z), _1341, mad((WorkingColorSpace.ToAP1[1].y), _1340, ((WorkingColorSpace.ToAP1[1].x) * _1339)));
      float _1438 = mad((WorkingColorSpace.ToAP1[2].z), _1341, mad((WorkingColorSpace.ToAP1[2].y), _1340, ((WorkingColorSpace.ToAP1[2].x) * _1339)));
      float _1448 = max(6.103519990574569e-05f, mad(_54, _1438, mad(_53, _1435, (_1432 * _52))));
      float _1449 = max(6.103519990574569e-05f, mad(_57, _1438, mad(_56, _1435, (_1432 * _55))));
      float _1450 = max(6.103519990574569e-05f, mad(_60, _1438, mad(_59, _1435, (_1432 * _58))));
      _3003 = min((_1448 * 4.5f), ((exp2(log2(max(_1448, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3004 = min((_1449 * 4.5f), ((exp2(log2(max(_1449, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3005 = min((_1450 * 4.5f), ((exp2(log2(max(_1450, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        float _1526 = ACESSceneColorMultiplier * _1325;
        float _1527 = ACESSceneColorMultiplier * _1326;
        float _1528 = ACESSceneColorMultiplier * _1327;
        float _1531 = mad((WorkingColorSpace.ToAP0[0].z), _1528, mad((WorkingColorSpace.ToAP0[0].y), _1527, ((WorkingColorSpace.ToAP0[0].x) * _1526)));
        float _1534 = mad((WorkingColorSpace.ToAP0[1].z), _1528, mad((WorkingColorSpace.ToAP0[1].y), _1527, ((WorkingColorSpace.ToAP0[1].x) * _1526)));
        float _1537 = mad((WorkingColorSpace.ToAP0[2].z), _1528, mad((WorkingColorSpace.ToAP0[2].y), _1527, ((WorkingColorSpace.ToAP0[2].x) * _1526)));
        float _1540 = mad(-0.21492856740951538f, _1537, mad(-0.2365107536315918f, _1534, (_1531 * 1.4514392614364624f)));
        float _1543 = mad(-0.09967592358589172f, _1537, mad(1.17622971534729f, _1534, (_1531 * -0.07655377686023712f)));
        float _1546 = mad(0.9977163076400757f, _1537, mad(-0.006032449658960104f, _1534, (_1531 * 0.008316148072481155f)));
        float _1548 = max(_1540, max(_1543, _1546));
        do {
          if (!(_1548 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1531 < 0.0f) || (bool)(_1534 < 0.0f))) || (bool)(_1537 < 0.0f))) {
              float _1558 = abs(_1548);
              float _1559 = (_1548 - _1540) / _1558;
              float _1561 = (_1548 - _1543) / _1558;
              float _1563 = (_1548 - _1546) / _1558;
              do {
                if (!(_1559 < 0.8149999976158142f)) {
                  float _1566 = _1559 + -0.8149999976158142f;
                  _1578 = ((_1566 / exp2(log2(exp2(log2(_1566 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1578 = _1559;
                }
                do {
                  if (!(_1561 < 0.8029999732971191f)) {
                    float _1581 = _1561 + -0.8029999732971191f;
                    _1593 = ((_1581 / exp2(log2(exp2(log2(_1581 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1593 = _1561;
                  }
                  do {
                    if (!(_1563 < 0.8799999952316284f)) {
                      float _1596 = _1563 + -0.8799999952316284f;
                      _1608 = ((_1596 / exp2(log2(exp2(log2(_1596 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1608 = _1563;
                    }
                    _1616 = (_1548 - (_1558 * _1578));
                    _1617 = (_1548 - (_1558 * _1593));
                    _1618 = (_1548 - (_1558 * _1608));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1616 = _1540;
              _1617 = _1543;
              _1618 = _1546;
            }
          } else {
            _1616 = _1540;
            _1617 = _1543;
            _1618 = _1546;
          }
          float _1634 = ((mad(0.16386906802654266f, _1618, mad(0.14067870378494263f, _1617, (_1616 * 0.6954522132873535f))) - _1531) * ACESGamutCompression) + _1531;
          float _1635 = ((mad(0.0955343171954155f, _1618, mad(0.8596711158752441f, _1617, (_1616 * 0.044794563204050064f))) - _1534) * ACESGamutCompression) + _1534;
          float _1636 = ((mad(1.0015007257461548f, _1618, mad(0.004025210160762072f, _1617, (_1616 * -0.005525882821530104f))) - _1537) * ACESGamutCompression) + _1537;
          float _1640 = max(max(_1634, _1635), _1636);
          float _1645 = (max(_1640, 1.000000013351432e-10f) - max(min(min(_1634, _1635), _1636), 1.000000013351432e-10f)) / max(_1640, 0.009999999776482582f);
          float _1658 = ((_1635 + _1634) + _1636) + (sqrt((((_1636 - _1635) * _1636) + ((_1635 - _1634) * _1635)) + ((_1634 - _1636) * _1634)) * 1.75f);
          float _1659 = _1658 * 0.3333333432674408f;
          float _1660 = _1645 + -0.4000000059604645f;
          float _1661 = _1660 * 5.0f;
          float _1665 = max((1.0f - abs(_1660 * 2.5f)), 0.0f);
          float _1676 = ((float(((int)(uint)((bool)(_1661 > 0.0f))) - ((int)(uint)((bool)(_1661 < 0.0f)))) * (1.0f - (_1665 * _1665))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1659 <= 0.0533333346247673f)) {
              if (!(_1659 >= 0.1599999964237213f)) {
                _1685 = (((0.23999999463558197f / _1658) + -0.5f) * _1676);
              } else {
                _1685 = 0.0f;
              }
            } else {
              _1685 = _1676;
            }
            float _1686 = _1685 + 1.0f;
            float _1687 = _1686 * _1634;
            float _1688 = _1686 * _1635;
            float _1689 = _1686 * _1636;
            do {
              if (!((bool)(_1687 == _1688) && (bool)(_1688 == _1689))) {
                float _1696 = ((_1687 * 2.0f) - _1688) - _1689;
                float _1699 = ((_1635 - _1636) * 1.7320507764816284f) * _1686;
                float _1701 = atan(_1699 / _1696);
                bool _1704 = (_1696 < 0.0f);
                bool _1705 = (_1696 == 0.0f);
                bool _1706 = (_1699 >= 0.0f);
                bool _1707 = (_1699 < 0.0f);
                _1718 = select((_1706 && _1705), 90.0f, select((_1707 && _1705), -90.0f, (select((_1707 && _1704), (_1701 + -3.1415927410125732f), select((_1706 && _1704), (_1701 + 3.1415927410125732f), _1701)) * 57.2957763671875f)));
              } else {
                _1718 = 0.0f;
              }
              float _1723 = min(max(select((_1718 < 0.0f), (_1718 + 360.0f), _1718), 0.0f), 360.0f);
              do {
                if (_1723 < -180.0f) {
                  _1732 = (_1723 + 360.0f);
                } else {
                  if (_1723 > 180.0f) {
                    _1732 = (_1723 + -360.0f);
                  } else {
                    _1732 = _1723;
                  }
                }
                do {
                  if ((bool)(_1732 > -67.5f) && (bool)(_1732 < 67.5f)) {
                    float _1738 = (_1732 + 67.5f) * 0.029629629105329514f;
                    int _1739 = int(_1738);
                    float _1741 = _1738 - float(_1739);
                    float _1742 = _1741 * _1741;
                    float _1743 = _1742 * _1741;
                    if (_1739 == 3) {
                      _1771 = (((0.1666666716337204f - (_1741 * 0.5f)) + (_1742 * 0.5f)) - (_1743 * 0.1666666716337204f));
                    } else {
                      if (_1739 == 2) {
                        _1771 = ((0.6666666865348816f - _1742) + (_1743 * 0.5f));
                      } else {
                        if (_1739 == 1) {
                          _1771 = (((_1743 * -0.5f) + 0.1666666716337204f) + ((_1742 + _1741) * 0.5f));
                        } else {
                          _1771 = select((_1739 == 0), (_1743 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1771 = 0.0f;
                  }
                  float _1780 = min(max(((((_1645 * 0.27000001072883606f) * (0.029999999329447746f - _1687)) * _1771) + _1687), 0.0f), 65535.0f);
                  float _1781 = min(max(_1688, 0.0f), 65535.0f);
                  float _1782 = min(max(_1689, 0.0f), 65535.0f);
                  float _1795 = min(max(mad(-0.21492856740951538f, _1782, mad(-0.2365107536315918f, _1781, (_1780 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1796 = min(max(mad(-0.09967592358589172f, _1782, mad(1.17622971534729f, _1781, (_1780 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1797 = min(max(mad(0.9977163076400757f, _1782, mad(-0.006032449658960104f, _1781, (_1780 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1798 = dot(float3(_1795, _1796, _1797), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  _18[0] = ACESCoefsLow_0.x;
                  _18[1] = ACESCoefsLow_0.y;
                  _18[2] = ACESCoefsLow_0.z;
                  _18[3] = ACESCoefsLow_0.w;
                  _18[4] = ACESCoefsLow_4;
                  _18[5] = ACESCoefsLow_4;
                  float _1815 = log2(max((lerp(_1798, _1795, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1816 = _1815 * 0.3010300099849701f;
                  float _1817 = log2(ACESMinMaxData.x);
                  float _1818 = _1817 * 0.3010300099849701f;
                  do {
                    if (!(!(_1816 <= _1818))) {
                      _1887 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1825 = log2(ACESMidData.x);
                      float _1826 = _1825 * 0.3010300099849701f;
                      if ((bool)(_1816 > _1818) && (bool)(_1816 < _1826)) {
                        float _1834 = ((_1815 - _1817) * 0.9030900001525879f) / ((_1825 - _1817) * 0.3010300099849701f);
                        int _1835 = int(_1834);
                        float _1837 = _1834 - float(_1835);
                        float _1839 = _18[_1835];
                        float _1842 = _18[(_1835 + 1)];
                        float _1847 = _1839 * 0.5f;
                        _1887 = dot(float3((_1837 * _1837), _1837, 1.0f), float3(mad((_18[(_1835 + 2)]), 0.5f, mad(_1842, -1.0f, _1847)), (_1842 - _1839), mad(_1842, 0.5f, _1847)));
                      } else {
                        do {
                          if (!(!(_1816 >= _1826))) {
                            float _1856 = log2(ACESMinMaxData.z);
                            if (_1816 < (_1856 * 0.3010300099849701f)) {
                              float _1864 = ((_1815 - _1825) * 0.9030900001525879f) / ((_1856 - _1825) * 0.3010300099849701f);
                              int _1865 = int(_1864);
                              float _1867 = _1864 - float(_1865);
                              float _1869 = _11[_1865];
                              float _1872 = _11[(_1865 + 1)];
                              float _1877 = _1869 * 0.5f;
                              _1887 = dot(float3((_1867 * _1867), _1867, 1.0f), float3(mad((_11[(_1865 + 2)]), 0.5f, mad(_1872, -1.0f, _1877)), (_1872 - _1869), mad(_1872, 0.5f, _1877)));
                              break;
                            }
                          }
                          _1887 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _19[0] = ACESCoefsLow_0.x;
                    _19[1] = ACESCoefsLow_0.y;
                    _19[2] = ACESCoefsLow_0.z;
                    _19[3] = ACESCoefsLow_0.w;
                    _19[4] = ACESCoefsLow_4;
                    _19[5] = ACESCoefsLow_4;
                    _20[0] = ACESCoefsHigh_0.x;
                    _20[1] = ACESCoefsHigh_0.y;
                    _20[2] = ACESCoefsHigh_0.z;
                    _20[3] = ACESCoefsHigh_0.w;
                    _20[4] = ACESCoefsHigh_4;
                    _20[5] = ACESCoefsHigh_4;
                    float _1903 = log2(max((lerp(_1798, _1796, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1904 = _1903 * 0.3010300099849701f;
                    do {
                      if (!(!(_1904 <= _1818))) {
                        _1973 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1911 = log2(ACESMidData.x);
                        float _1912 = _1911 * 0.3010300099849701f;
                        if ((bool)(_1904 > _1818) && (bool)(_1904 < _1912)) {
                          float _1920 = ((_1903 - _1817) * 0.9030900001525879f) / ((_1911 - _1817) * 0.3010300099849701f);
                          int _1921 = int(_1920);
                          float _1923 = _1920 - float(_1921);
                          float _1925 = _19[_1921];
                          float _1928 = _19[(_1921 + 1)];
                          float _1933 = _1925 * 0.5f;
                          _1973 = dot(float3((_1923 * _1923), _1923, 1.0f), float3(mad((_19[(_1921 + 2)]), 0.5f, mad(_1928, -1.0f, _1933)), (_1928 - _1925), mad(_1928, 0.5f, _1933)));
                        } else {
                          do {
                            if (!(!(_1904 >= _1912))) {
                              float _1942 = log2(ACESMinMaxData.z);
                              if (_1904 < (_1942 * 0.3010300099849701f)) {
                                float _1950 = ((_1903 - _1911) * 0.9030900001525879f) / ((_1942 - _1911) * 0.3010300099849701f);
                                int _1951 = int(_1950);
                                float _1953 = _1950 - float(_1951);
                                float _1955 = _20[_1951];
                                float _1958 = _20[(_1951 + 1)];
                                float _1963 = _1955 * 0.5f;
                                _1973 = dot(float3((_1953 * _1953), _1953, 1.0f), float3(mad((_20[(_1951 + 2)]), 0.5f, mad(_1958, -1.0f, _1963)), (_1958 - _1955), mad(_1958, 0.5f, _1963)));
                                break;
                              }
                            }
                            _1973 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1977 = log2(max((lerp(_1798, _1797, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1978 = _1977 * 0.3010300099849701f;
                      do {
                        if (!(!(_1978 <= _1818))) {
                          _2047 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1985 = log2(ACESMidData.x);
                          float _1986 = _1985 * 0.3010300099849701f;
                          if ((bool)(_1978 > _1818) && (bool)(_1978 < _1986)) {
                            float _1994 = ((_1977 - _1817) * 0.9030900001525879f) / ((_1985 - _1817) * 0.3010300099849701f);
                            int _1995 = int(_1994);
                            float _1997 = _1994 - float(_1995);
                            float _1999 = _10[_1995];
                            float _2002 = _10[(_1995 + 1)];
                            float _2007 = _1999 * 0.5f;
                            _2047 = dot(float3((_1997 * _1997), _1997, 1.0f), float3(mad((_10[(_1995 + 2)]), 0.5f, mad(_2002, -1.0f, _2007)), (_2002 - _1999), mad(_2002, 0.5f, _2007)));
                          } else {
                            do {
                              if (!(!(_1978 >= _1986))) {
                                float _2016 = log2(ACESMinMaxData.z);
                                if (_1978 < (_2016 * 0.3010300099849701f)) {
                                  float _2024 = ((_1977 - _1985) * 0.9030900001525879f) / ((_2016 - _1985) * 0.3010300099849701f);
                                  int _2025 = int(_2024);
                                  float _2027 = _2024 - float(_2025);
                                  float _2029 = _11[_2025];
                                  float _2032 = _11[(_2025 + 1)];
                                  float _2037 = _2029 * 0.5f;
                                  _2047 = dot(float3((_2027 * _2027), _2027, 1.0f), float3(mad((_11[(_2025 + 2)]), 0.5f, mad(_2032, -1.0f, _2037)), (_2032 - _2029), mad(_2032, 0.5f, _2037)));
                                  break;
                                }
                              }
                              _2047 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2051 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2052 = (exp2(_1887 * 3.321928024291992f) - ACESMinMaxData.y) / _2051;
                        float _2054 = (exp2(_1973 * 3.321928024291992f) - ACESMinMaxData.y) / _2051;
                        float _2056 = (exp2(_2047 * 3.321928024291992f) - ACESMinMaxData.y) / _2051;
                        float _2059 = mad(0.15618768334388733f, _2056, mad(0.13400420546531677f, _2054, (_2052 * 0.6624541878700256f)));
                        float _2062 = mad(0.053689517080783844f, _2056, mad(0.6740817427635193f, _2054, (_2052 * 0.2722287178039551f)));
                        float _2065 = mad(1.0103391408920288f, _2056, mad(0.00406073359772563f, _2054, (_2052 * -0.005574649665504694f)));
                        float _2078 = min(max(mad(-0.23642469942569733f, _2065, mad(-0.32480329275131226f, _2062, (_2059 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2079 = min(max(mad(0.016756348311901093f, _2065, mad(1.6153316497802734f, _2062, (_2059 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2080 = min(max(mad(0.9883948564529419f, _2065, mad(-0.008284442126750946f, _2062, (_2059 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2083 = mad(0.15618768334388733f, _2080, mad(0.13400420546531677f, _2079, (_2078 * 0.6624541878700256f)));
                        float _2086 = mad(0.053689517080783844f, _2080, mad(0.6740817427635193f, _2079, (_2078 * 0.2722287178039551f)));
                        float _2089 = mad(1.0103391408920288f, _2080, mad(0.00406073359772563f, _2079, (_2078 * -0.005574649665504694f)));
                        float _2111 = min(max((min(max(mad(-0.23642469942569733f, _2089, mad(-0.32480329275131226f, _2086, (_2083 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2112 = min(max((min(max(mad(0.016756348311901093f, _2089, mad(1.6153316497802734f, _2086, (_2083 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2113 = min(max((min(max(mad(0.9883948564529419f, _2089, mad(-0.008284442126750946f, _2086, (_2083 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 5)) {
                            _2126 = mad(_54, _2113, mad(_53, _2112, (_2111 * _52)));
                            _2127 = mad(_57, _2113, mad(_56, _2112, (_2111 * _55)));
                            _2128 = mad(_60, _2113, mad(_59, _2112, (_2111 * _58)));
                          } else {
                            _2126 = _2111;
                            _2127 = _2112;
                            _2128 = _2113;
                          }
                          float _2138 = exp2(log2(_2126 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2139 = exp2(log2(_2127 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2140 = exp2(log2(_2128 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _3003 = exp2(log2((1.0f / ((_2138 * 18.6875f) + 1.0f)) * ((_2138 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3004 = exp2(log2((1.0f / ((_2139 * 18.6875f) + 1.0f)) * ((_2139 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3005 = exp2(log2((1.0f / ((_2140 * 18.6875f) + 1.0f)) * ((_2140 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2206 = ACESSceneColorMultiplier * _1325;
          float _2207 = ACESSceneColorMultiplier * _1326;
          float _2208 = ACESSceneColorMultiplier * _1327;
          float _2211 = mad((WorkingColorSpace.ToAP0[0].z), _2208, mad((WorkingColorSpace.ToAP0[0].y), _2207, ((WorkingColorSpace.ToAP0[0].x) * _2206)));
          float _2214 = mad((WorkingColorSpace.ToAP0[1].z), _2208, mad((WorkingColorSpace.ToAP0[1].y), _2207, ((WorkingColorSpace.ToAP0[1].x) * _2206)));
          float _2217 = mad((WorkingColorSpace.ToAP0[2].z), _2208, mad((WorkingColorSpace.ToAP0[2].y), _2207, ((WorkingColorSpace.ToAP0[2].x) * _2206)));
          float _2220 = mad(-0.21492856740951538f, _2217, mad(-0.2365107536315918f, _2214, (_2211 * 1.4514392614364624f)));
          float _2223 = mad(-0.09967592358589172f, _2217, mad(1.17622971534729f, _2214, (_2211 * -0.07655377686023712f)));
          float _2226 = mad(0.9977163076400757f, _2217, mad(-0.006032449658960104f, _2214, (_2211 * 0.008316148072481155f)));
          float _2228 = max(_2220, max(_2223, _2226));
          do {
            if (!(_2228 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2211 < 0.0f) || (bool)(_2214 < 0.0f))) || (bool)(_2217 < 0.0f))) {
                float _2238 = abs(_2228);
                float _2239 = (_2228 - _2220) / _2238;
                float _2241 = (_2228 - _2223) / _2238;
                float _2243 = (_2228 - _2226) / _2238;
                do {
                  if (!(_2239 < 0.8149999976158142f)) {
                    float _2246 = _2239 + -0.8149999976158142f;
                    _2258 = ((_2246 / exp2(log2(exp2(log2(_2246 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2258 = _2239;
                  }
                  do {
                    if (!(_2241 < 0.8029999732971191f)) {
                      float _2261 = _2241 + -0.8029999732971191f;
                      _2273 = ((_2261 / exp2(log2(exp2(log2(_2261 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2273 = _2241;
                    }
                    do {
                      if (!(_2243 < 0.8799999952316284f)) {
                        float _2276 = _2243 + -0.8799999952316284f;
                        _2288 = ((_2276 / exp2(log2(exp2(log2(_2276 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2288 = _2243;
                      }
                      _2296 = (_2228 - (_2238 * _2258));
                      _2297 = (_2228 - (_2238 * _2273));
                      _2298 = (_2228 - (_2238 * _2288));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2296 = _2220;
                _2297 = _2223;
                _2298 = _2226;
              }
            } else {
              _2296 = _2220;
              _2297 = _2223;
              _2298 = _2226;
            }
            float _2314 = ((mad(0.16386906802654266f, _2298, mad(0.14067870378494263f, _2297, (_2296 * 0.6954522132873535f))) - _2211) * ACESGamutCompression) + _2211;
            float _2315 = ((mad(0.0955343171954155f, _2298, mad(0.8596711158752441f, _2297, (_2296 * 0.044794563204050064f))) - _2214) * ACESGamutCompression) + _2214;
            float _2316 = ((mad(1.0015007257461548f, _2298, mad(0.004025210160762072f, _2297, (_2296 * -0.005525882821530104f))) - _2217) * ACESGamutCompression) + _2217;
            float _2320 = max(max(_2314, _2315), _2316);
            float _2325 = (max(_2320, 1.000000013351432e-10f) - max(min(min(_2314, _2315), _2316), 1.000000013351432e-10f)) / max(_2320, 0.009999999776482582f);
            float _2338 = ((_2315 + _2314) + _2316) + (sqrt((((_2316 - _2315) * _2316) + ((_2315 - _2314) * _2315)) + ((_2314 - _2316) * _2314)) * 1.75f);
            float _2339 = _2338 * 0.3333333432674408f;
            float _2340 = _2325 + -0.4000000059604645f;
            float _2341 = _2340 * 5.0f;
            float _2345 = max((1.0f - abs(_2340 * 2.5f)), 0.0f);
            float _2356 = ((float(((int)(uint)((bool)(_2341 > 0.0f))) - ((int)(uint)((bool)(_2341 < 0.0f)))) * (1.0f - (_2345 * _2345))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2339 <= 0.0533333346247673f)) {
                if (!(_2339 >= 0.1599999964237213f)) {
                  _2365 = (((0.23999999463558197f / _2338) + -0.5f) * _2356);
                } else {
                  _2365 = 0.0f;
                }
              } else {
                _2365 = _2356;
              }
              float _2366 = _2365 + 1.0f;
              float _2367 = _2366 * _2314;
              float _2368 = _2366 * _2315;
              float _2369 = _2366 * _2316;
              do {
                if (!((bool)(_2367 == _2368) && (bool)(_2368 == _2369))) {
                  float _2376 = ((_2367 * 2.0f) - _2368) - _2369;
                  float _2379 = ((_2315 - _2316) * 1.7320507764816284f) * _2366;
                  float _2381 = atan(_2379 / _2376);
                  bool _2384 = (_2376 < 0.0f);
                  bool _2385 = (_2376 == 0.0f);
                  bool _2386 = (_2379 >= 0.0f);
                  bool _2387 = (_2379 < 0.0f);
                  _2398 = select((_2386 && _2385), 90.0f, select((_2387 && _2385), -90.0f, (select((_2387 && _2384), (_2381 + -3.1415927410125732f), select((_2386 && _2384), (_2381 + 3.1415927410125732f), _2381)) * 57.2957763671875f)));
                } else {
                  _2398 = 0.0f;
                }
                float _2403 = min(max(select((_2398 < 0.0f), (_2398 + 360.0f), _2398), 0.0f), 360.0f);
                do {
                  if (_2403 < -180.0f) {
                    _2412 = (_2403 + 360.0f);
                  } else {
                    if (_2403 > 180.0f) {
                      _2412 = (_2403 + -360.0f);
                    } else {
                      _2412 = _2403;
                    }
                  }
                  do {
                    if ((bool)(_2412 > -67.5f) && (bool)(_2412 < 67.5f)) {
                      float _2418 = (_2412 + 67.5f) * 0.029629629105329514f;
                      int _2419 = int(_2418);
                      float _2421 = _2418 - float(_2419);
                      float _2422 = _2421 * _2421;
                      float _2423 = _2422 * _2421;
                      if (_2419 == 3) {
                        _2451 = (((0.1666666716337204f - (_2421 * 0.5f)) + (_2422 * 0.5f)) - (_2423 * 0.1666666716337204f));
                      } else {
                        if (_2419 == 2) {
                          _2451 = ((0.6666666865348816f - _2422) + (_2423 * 0.5f));
                        } else {
                          if (_2419 == 1) {
                            _2451 = (((_2423 * -0.5f) + 0.1666666716337204f) + ((_2422 + _2421) * 0.5f));
                          } else {
                            _2451 = select((_2419 == 0), (_2423 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2451 = 0.0f;
                    }
                    float _2460 = min(max(((((_2325 * 0.27000001072883606f) * (0.029999999329447746f - _2367)) * _2451) + _2367), 0.0f), 65535.0f);
                    float _2461 = min(max(_2368, 0.0f), 65535.0f);
                    float _2462 = min(max(_2369, 0.0f), 65535.0f);
                    float _2475 = min(max(mad(-0.21492856740951538f, _2462, mad(-0.2365107536315918f, _2461, (_2460 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2476 = min(max(mad(-0.09967592358589172f, _2462, mad(1.17622971534729f, _2461, (_2460 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2477 = min(max(mad(0.9977163076400757f, _2462, mad(-0.006032449658960104f, _2461, (_2460 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2478 = dot(float3(_2475, _2476, _2477), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2501 = log2(max((lerp(_2478, _2475, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2502 = _2501 * 0.3010300099849701f;
                    float _2503 = log2(ACESMinMaxData.x);
                    float _2504 = _2503 * 0.3010300099849701f;
                    do {
                      if (!(!(_2502 <= _2504))) {
                        _2573 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2511 = log2(ACESMidData.x);
                        float _2512 = _2511 * 0.3010300099849701f;
                        if ((bool)(_2502 > _2504) && (bool)(_2502 < _2512)) {
                          float _2520 = ((_2501 - _2503) * 0.9030900001525879f) / ((_2511 - _2503) * 0.3010300099849701f);
                          int _2521 = int(_2520);
                          float _2523 = _2520 - float(_2521);
                          float _2525 = _16[_2521];
                          float _2528 = _16[(_2521 + 1)];
                          float _2533 = _2525 * 0.5f;
                          _2573 = dot(float3((_2523 * _2523), _2523, 1.0f), float3(mad((_16[(_2521 + 2)]), 0.5f, mad(_2528, -1.0f, _2533)), (_2528 - _2525), mad(_2528, 0.5f, _2533)));
                        } else {
                          do {
                            if (!(!(_2502 >= _2512))) {
                              float _2542 = log2(ACESMinMaxData.z);
                              if (_2502 < (_2542 * 0.3010300099849701f)) {
                                float _2550 = ((_2501 - _2511) * 0.9030900001525879f) / ((_2542 - _2511) * 0.3010300099849701f);
                                int _2551 = int(_2550);
                                float _2553 = _2550 - float(_2551);
                                float _2555 = _17[_2551];
                                float _2558 = _17[(_2551 + 1)];
                                float _2563 = _2555 * 0.5f;
                                _2573 = dot(float3((_2553 * _2553), _2553, 1.0f), float3(mad((_17[(_2551 + 2)]), 0.5f, mad(_2558, -1.0f, _2563)), (_2558 - _2555), mad(_2558, 0.5f, _2563)));
                                break;
                              }
                            }
                            _2573 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
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
                      float _2589 = log2(max((lerp(_2478, _2476, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2590 = _2589 * 0.3010300099849701f;
                      do {
                        if (!(!(_2590 <= _2504))) {
                          _2659 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2597 = log2(ACESMidData.x);
                          float _2598 = _2597 * 0.3010300099849701f;
                          if ((bool)(_2590 > _2504) && (bool)(_2590 < _2598)) {
                            float _2606 = ((_2589 - _2503) * 0.9030900001525879f) / ((_2597 - _2503) * 0.3010300099849701f);
                            int _2607 = int(_2606);
                            float _2609 = _2606 - float(_2607);
                            float _2611 = _12[_2607];
                            float _2614 = _12[(_2607 + 1)];
                            float _2619 = _2611 * 0.5f;
                            _2659 = dot(float3((_2609 * _2609), _2609, 1.0f), float3(mad((_12[(_2607 + 2)]), 0.5f, mad(_2614, -1.0f, _2619)), (_2614 - _2611), mad(_2614, 0.5f, _2619)));
                          } else {
                            do {
                              if (!(!(_2590 >= _2598))) {
                                float _2628 = log2(ACESMinMaxData.z);
                                if (_2590 < (_2628 * 0.3010300099849701f)) {
                                  float _2636 = ((_2589 - _2597) * 0.9030900001525879f) / ((_2628 - _2597) * 0.3010300099849701f);
                                  int _2637 = int(_2636);
                                  float _2639 = _2636 - float(_2637);
                                  float _2641 = _13[_2637];
                                  float _2644 = _13[(_2637 + 1)];
                                  float _2649 = _2641 * 0.5f;
                                  _2659 = dot(float3((_2639 * _2639), _2639, 1.0f), float3(mad((_13[(_2637 + 2)]), 0.5f, mad(_2644, -1.0f, _2649)), (_2644 - _2641), mad(_2644, 0.5f, _2649)));
                                  break;
                                }
                              }
                              _2659 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
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
                        float _2675 = log2(max((lerp(_2478, _2477, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2676 = _2675 * 0.3010300099849701f;
                        do {
                          if (!(!(_2676 <= _2504))) {
                            _2745 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2683 = log2(ACESMidData.x);
                            float _2684 = _2683 * 0.3010300099849701f;
                            if ((bool)(_2676 > _2504) && (bool)(_2676 < _2684)) {
                              float _2692 = ((_2675 - _2503) * 0.9030900001525879f) / ((_2683 - _2503) * 0.3010300099849701f);
                              int _2693 = int(_2692);
                              float _2695 = _2692 - float(_2693);
                              float _2697 = _14[_2693];
                              float _2700 = _14[(_2693 + 1)];
                              float _2705 = _2697 * 0.5f;
                              _2745 = dot(float3((_2695 * _2695), _2695, 1.0f), float3(mad((_14[(_2693 + 2)]), 0.5f, mad(_2700, -1.0f, _2705)), (_2700 - _2697), mad(_2700, 0.5f, _2705)));
                            } else {
                              do {
                                if (!(!(_2676 >= _2684))) {
                                  float _2714 = log2(ACESMinMaxData.z);
                                  if (_2676 < (_2714 * 0.3010300099849701f)) {
                                    float _2722 = ((_2675 - _2683) * 0.9030900001525879f) / ((_2714 - _2683) * 0.3010300099849701f);
                                    int _2723 = int(_2722);
                                    float _2725 = _2722 - float(_2723);
                                    float _2727 = _15[_2723];
                                    float _2730 = _15[(_2723 + 1)];
                                    float _2735 = _2727 * 0.5f;
                                    _2745 = dot(float3((_2725 * _2725), _2725, 1.0f), float3(mad((_15[(_2723 + 2)]), 0.5f, mad(_2730, -1.0f, _2735)), (_2730 - _2727), mad(_2730, 0.5f, _2735)));
                                    break;
                                  }
                                }
                                _2745 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2749 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2750 = (exp2(_2573 * 3.321928024291992f) - ACESMinMaxData.y) / _2749;
                          float _2752 = (exp2(_2659 * 3.321928024291992f) - ACESMinMaxData.y) / _2749;
                          float _2754 = (exp2(_2745 * 3.321928024291992f) - ACESMinMaxData.y) / _2749;
                          float _2757 = mad(0.15618768334388733f, _2754, mad(0.13400420546531677f, _2752, (_2750 * 0.6624541878700256f)));
                          float _2760 = mad(0.053689517080783844f, _2754, mad(0.6740817427635193f, _2752, (_2750 * 0.2722287178039551f)));
                          float _2763 = mad(1.0103391408920288f, _2754, mad(0.00406073359772563f, _2752, (_2750 * -0.005574649665504694f)));
                          float _2776 = min(max(mad(-0.23642469942569733f, _2763, mad(-0.32480329275131226f, _2760, (_2757 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2777 = min(max(mad(0.016756348311901093f, _2763, mad(1.6153316497802734f, _2760, (_2757 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2778 = min(max(mad(0.9883948564529419f, _2763, mad(-0.008284442126750946f, _2760, (_2757 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2781 = mad(0.15618768334388733f, _2778, mad(0.13400420546531677f, _2777, (_2776 * 0.6624541878700256f)));
                          float _2784 = mad(0.053689517080783844f, _2778, mad(0.6740817427635193f, _2777, (_2776 * 0.2722287178039551f)));
                          float _2787 = mad(1.0103391408920288f, _2778, mad(0.00406073359772563f, _2777, (_2776 * -0.005574649665504694f)));
                          float _2809 = min(max((min(max(mad(-0.23642469942569733f, _2787, mad(-0.32480329275131226f, _2784, (_2781 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2810 = min(max((min(max(mad(0.016756348311901093f, _2787, mad(1.6153316497802734f, _2784, (_2781 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2811 = min(max((min(max(mad(0.9883948564529419f, _2787, mad(-0.008284442126750946f, _2784, (_2781 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!((uint)(OutputDevice) == 6)) {
                              _2824 = mad(_54, _2811, mad(_53, _2810, (_2809 * _52)));
                              _2825 = mad(_57, _2811, mad(_56, _2810, (_2809 * _55)));
                              _2826 = mad(_60, _2811, mad(_59, _2810, (_2809 * _58)));
                            } else {
                              _2824 = _2809;
                              _2825 = _2810;
                              _2826 = _2811;
                            }
                            float _2836 = exp2(log2(_2824 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2837 = exp2(log2(_2825 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2838 = exp2(log2(_2826 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _3003 = exp2(log2((1.0f / ((_2836 * 18.6875f) + 1.0f)) * ((_2836 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3004 = exp2(log2((1.0f / ((_2837 * 18.6875f) + 1.0f)) * ((_2837 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3005 = exp2(log2((1.0f / ((_2838 * 18.6875f) + 1.0f)) * ((_2838 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2883 = mad((WorkingColorSpace.ToAP1[0].z), _1327, mad((WorkingColorSpace.ToAP1[0].y), _1326, ((WorkingColorSpace.ToAP1[0].x) * _1325)));
            float _2886 = mad((WorkingColorSpace.ToAP1[1].z), _1327, mad((WorkingColorSpace.ToAP1[1].y), _1326, ((WorkingColorSpace.ToAP1[1].x) * _1325)));
            float _2889 = mad((WorkingColorSpace.ToAP1[2].z), _1327, mad((WorkingColorSpace.ToAP1[2].y), _1326, ((WorkingColorSpace.ToAP1[2].x) * _1325)));
            float _2908 = exp2(log2(mad(_54, _2889, mad(_53, _2886, (_2883 * _52))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2909 = exp2(log2(mad(_57, _2889, mad(_56, _2886, (_2883 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2910 = exp2(log2(mad(_60, _2889, mad(_59, _2886, (_2883 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3003 = exp2(log2((1.0f / ((_2908 * 18.6875f) + 1.0f)) * ((_2908 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3004 = exp2(log2((1.0f / ((_2909 * 18.6875f) + 1.0f)) * ((_2909 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3005 = exp2(log2((1.0f / ((_2910 * 18.6875f) + 1.0f)) * ((_2910 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2957 = mad((WorkingColorSpace.ToAP1[0].z), _1315, mad((WorkingColorSpace.ToAP1[0].y), _1314, ((WorkingColorSpace.ToAP1[0].x) * _1313)));
                float _2960 = mad((WorkingColorSpace.ToAP1[1].z), _1315, mad((WorkingColorSpace.ToAP1[1].y), _1314, ((WorkingColorSpace.ToAP1[1].x) * _1313)));
                float _2963 = mad((WorkingColorSpace.ToAP1[2].z), _1315, mad((WorkingColorSpace.ToAP1[2].y), _1314, ((WorkingColorSpace.ToAP1[2].x) * _1313)));
                _3003 = mad(_54, _2963, mad(_53, _2960, (_2957 * _52)));
                _3004 = mad(_57, _2963, mad(_56, _2960, (_2957 * _55)));
                _3005 = mad(_60, _2963, mad(_59, _2960, (_2957 * _58)));
              } else {
                float _2976 = mad((WorkingColorSpace.ToAP1[0].z), _1341, mad((WorkingColorSpace.ToAP1[0].y), _1340, ((WorkingColorSpace.ToAP1[0].x) * _1339)));
                float _2979 = mad((WorkingColorSpace.ToAP1[1].z), _1341, mad((WorkingColorSpace.ToAP1[1].y), _1340, ((WorkingColorSpace.ToAP1[1].x) * _1339)));
                float _2982 = mad((WorkingColorSpace.ToAP1[2].z), _1341, mad((WorkingColorSpace.ToAP1[2].y), _1340, ((WorkingColorSpace.ToAP1[2].x) * _1339)));
                _3003 = exp2(log2(mad(_54, _2982, mad(_53, _2979, (_2976 * _52)))) * InverseGamma.z);
                _3004 = exp2(log2(mad(_57, _2982, mad(_56, _2979, (_2976 * _55)))) * InverseGamma.z);
                _3005 = exp2(log2(mad(_60, _2982, mad(_59, _2979, (_2976 * _58)))) * InverseGamma.z);
              }
            } else {
              _3003 = _1325;
              _3004 = _1326;
              _3005 = _1327;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_3003 * 0.9523810148239136f);
  SV_Target.y = (_3004 * 0.9523810148239136f);
  SV_Target.z = (_3005 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

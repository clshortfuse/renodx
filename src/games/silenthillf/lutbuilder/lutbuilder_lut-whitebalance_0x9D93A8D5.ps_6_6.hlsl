#define LUTBUILDER_HASH 0x9D93A8D5

#include "./filmiclutbuilder.hlsli"

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};

Texture2D<float4> Textures_1 : register(t0);

// cbuffer _RootShaderParameters : register(b0) {
//   float4 LUTWeights[2] : packoffset(c005.x);
//   float4 ACESMinMaxData : packoffset(c008.x);
//   float4 ACESMidData : packoffset(c009.x);
//   float4 ACESCoefsLow_0 : packoffset(c010.x);
//   float4 ACESCoefsHigh_0 : packoffset(c011.x);
//   float ACESCoefsLow_4 : packoffset(c012.x);
//   float ACESCoefsHigh_4 : packoffset(c012.y);
//   float ACESSceneColorMultiplier : packoffset(c012.z);
//   float ACESGamutCompression : packoffset(c012.w);
//   float4 OverlayColor : packoffset(c013.x);
//   float3 ColorScale : packoffset(c014.x);
//   float4 ColorSaturation : packoffset(c015.x);
//   float4 ColorContrast : packoffset(c016.x);
//   float4 ColorGamma : packoffset(c017.x);
//   float4 ColorGain : packoffset(c018.x);
//   float4 ColorOffset : packoffset(c019.x);
//   float4 ColorSaturationShadows : packoffset(c020.x);
//   float4 ColorContrastShadows : packoffset(c021.x);
//   float4 ColorGammaShadows : packoffset(c022.x);
//   float4 ColorGainShadows : packoffset(c023.x);
//   float4 ColorOffsetShadows : packoffset(c024.x);
//   float4 ColorSaturationMidtones : packoffset(c025.x);
//   float4 ColorContrastMidtones : packoffset(c026.x);
//   float4 ColorGammaMidtones : packoffset(c027.x);
//   float4 ColorGainMidtones : packoffset(c028.x);
//   float4 ColorOffsetMidtones : packoffset(c029.x);
//   float4 ColorSaturationHighlights : packoffset(c030.x);
//   float4 ColorContrastHighlights : packoffset(c031.x);
//   float4 ColorGammaHighlights : packoffset(c032.x);
//   float4 ColorGainHighlights : packoffset(c033.x);
//   float4 ColorOffsetHighlights : packoffset(c034.x);
//   float LUTSize : packoffset(c035.x);
//   float WhiteTemp : packoffset(c035.y);
//   float WhiteTint : packoffset(c035.z);
//   float ColorCorrectionShadowsMax : packoffset(c035.w);
//   float ColorCorrectionHighlightsMin : packoffset(c036.x);
//   float ColorCorrectionHighlightsMax : packoffset(c036.y);
//   float BlueCorrection : packoffset(c036.z);
//   float ExpandGamut : packoffset(c036.w);
//   float ToneCurveAmount : packoffset(c037.x);
//   float FilmSlope : packoffset(c037.y);
//   float FilmToe : packoffset(c037.z);
//   float FilmShoulder : packoffset(c037.w);
//   float FilmBlackClip : packoffset(c038.x);
//   float FilmWhiteClip : packoffset(c038.y);
//   uint bIsTemperatureWhiteBalance : packoffset(c038.w);
//   float3 MappingPolynomial : packoffset(c039.x);
//   float3 InverseGamma : packoffset(c040.x);
//   uint OutputDevice : packoffset(c040.w);
//   uint OutputGamut : packoffset(c041.x);
// };

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

SamplerState Samplers_1 : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  float4 SV_Target;

#if 1
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;
#endif

  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _16 = 0.5f / LUTSize;
  float _21 = LUTSize + -1.0f;
  float _22 = (LUTSize * (TEXCOORD.x - _16)) / _21;
  float _23 = (LUTSize * (TEXCOORD.y - _16)) / _21;
  float _25 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _21;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _111;
  float _112;
  float _113;
  float _161;
  float _889;
  float _922;
  float _936;
  float _1000;
  float _1179;
  float _1190;
  float _1201;
  float _1374;
  float _1375;
  float _1376;
  float _1387;
  float _1398;
  float _1571;
  float _1586;
  float _1601;
  float _1609;
  float _1610;
  float _1611;
  float _1678;
  float _1711;
  float _1725;
  float _1764;
  float _1874;
  float _1948;
  float _2022;
  float _2101;
  float _2102;
  float _2103;
  float _2245;
  float _2260;
  float _2275;
  float _2283;
  float _2284;
  float _2285;
  float _2352;
  float _2385;
  float _2399;
  float _2438;
  float _2548;
  float _2622;
  float _2696;
  float _2775;
  float _2776;
  float _2777;
  float _2954;
  float _2955;
  float _2956;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _34 = (output_gamut == 4);
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
  if ((uint)OutputDevice > (uint)2) {
    float _64 = (pow(_22, 0.012683313339948654f));
    float _65 = (pow(_23, 0.012683313339948654f));
    float _66 = (pow(_25, 0.012683313339948654f));
    _111 = (exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _112 = (exp2(log2(max(0.0f, (_65 + -0.8359375f)) / (18.8515625f - (_65 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _113 = (exp2(log2(max(0.0f, (_66 + -0.8359375f)) / (18.8515625f - (_66 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _111 = ((exp2((_22 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _112 = ((exp2((_23 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _113 = ((exp2((_25 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f && output_device != 8u) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }
#endif

  bool _140 = (bIsTemperatureWhiteBalance != 0);
  float _144 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _161 = (((((2967800.0f - (_144 * 4607000064.0f)) * _144) + 99.11000061035156f) * _144) + 0.24406300485134125f);
  } else {
    _161 = (((((1901800.0f - (_144 * 2006400000.0f)) * _144) + 247.47999572753906f) * _144) + 0.23703999817371368f);
  }
  float _175 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _182 = WhiteTemp * WhiteTemp;
  float _185 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_182 * 1.6145605741257896e-07f));
  float _190 = ((_175 * 2.0f) + 4.0f) - (_185 * 8.0f);
  float _191 = (_175 * 3.0f) / _190;
  float _193 = (_185 * 2.0f) / _190;
  bool _194 = (WhiteTemp < 4000.0f);
  float _203 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _205 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_182 * 1.5317699909210205f)) / (_203 * _203);
  float _212 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _182;
  float _214 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_182 * 308.60699462890625f)) / (_212 * _212);
  float _216 = rsqrt(dot(float2(_205, _214), float2(_205, _214)));
  float _217 = WhiteTint * 0.05000000074505806f;
  float _220 = ((_217 * _214) * _216) + _175;
  float _223 = _185 - ((_217 * _205) * _216);
  float _228 = (4.0f - (_223 * 8.0f)) + (_220 * 2.0f);
  float _234 = (((_220 * 3.0f) / _228) - _191) + select(_194, _191, _161);
  float _235 = (((_223 * 2.0f) / _228) - _193) + select(_194, _193, (((_161 * 2.869999885559082f) + -0.2750000059604645f) - ((_161 * _161) * 3.0f)));
  float _236 = select(_140, _234, 0.3127000033855438f);
  float _237 = select(_140, _235, 0.32899999618530273f);
  float _238 = select(_140, 0.3127000033855438f, _234);
  float _239 = select(_140, 0.32899999618530273f, _235);
  float _240 = max(_237, 1.000000013351432e-10f);
  float _241 = _236 / _240;
  float _244 = ((1.0f - _236) - _237) / _240;
  float _245 = max(_239, 1.000000013351432e-10f);
  float _246 = _238 / _245;
  float _249 = ((1.0f - _238) - _239) / _245;
  float _268 = mad(-0.16140000522136688f, _249, ((_246 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _244, ((_241 * 0.8950999975204468f) + 0.266400009393692f));
  float _269 = mad(0.03669999912381172f, _249, (1.7135000228881836f - (_246 * 0.7501999735832214f))) / mad(0.03669999912381172f, _244, (1.7135000228881836f - (_241 * 0.7501999735832214f)));
  float _270 = mad(1.0296000242233276f, _249, ((_246 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _244, ((_241 * 0.03889999911189079f) + -0.06849999725818634f));
  float _271 = mad(_269, -0.7501999735832214f, 0.0f);
  float _272 = mad(_269, 1.7135000228881836f, 0.0f);
  float _273 = mad(_269, 0.03669999912381172f, -0.0f);
  float _274 = mad(_270, 0.03889999911189079f, 0.0f);
  float _275 = mad(_270, -0.06849999725818634f, 0.0f);
  float _276 = mad(_270, 1.0296000242233276f, 0.0f);
  float _279 = mad(0.1599626988172531f, _274, mad(-0.1470542997121811f, _271, (_268 * 0.883457362651825f)));
  float _282 = mad(0.1599626988172531f, _275, mad(-0.1470542997121811f, _272, (_268 * 0.26293492317199707f)));
  float _285 = mad(0.1599626988172531f, _276, mad(-0.1470542997121811f, _273, (_268 * -0.15930065512657166f)));
  float _288 = mad(0.04929120093584061f, _274, mad(0.5183603167533875f, _271, (_268 * 0.38695648312568665f)));
  float _291 = mad(0.04929120093584061f, _275, mad(0.5183603167533875f, _272, (_268 * 0.11516613513231277f)));
  float _294 = mad(0.04929120093584061f, _276, mad(0.5183603167533875f, _273, (_268 * -0.0697740763425827f)));
  float _297 = mad(0.9684867262840271f, _274, mad(0.04004279896616936f, _271, (_268 * -0.007634039502590895f)));
  float _300 = mad(0.9684867262840271f, _275, mad(0.04004279896616936f, _272, (_268 * -0.0022720457054674625f)));
  float _303 = mad(0.9684867262840271f, _276, mad(0.04004279896616936f, _273, (_268 * 0.0013765322510153055f)));
  float _306 = mad(_285, (WorkingColorSpace.ToXYZ[2].x), mad(_282, (WorkingColorSpace.ToXYZ[1].x), (_279 * (WorkingColorSpace.ToXYZ[0].x))));
  float _309 = mad(_285, (WorkingColorSpace.ToXYZ[2].y), mad(_282, (WorkingColorSpace.ToXYZ[1].y), (_279 * (WorkingColorSpace.ToXYZ[0].y))));
  float _312 = mad(_285, (WorkingColorSpace.ToXYZ[2].z), mad(_282, (WorkingColorSpace.ToXYZ[1].z), (_279 * (WorkingColorSpace.ToXYZ[0].z))));
  float _315 = mad(_294, (WorkingColorSpace.ToXYZ[2].x), mad(_291, (WorkingColorSpace.ToXYZ[1].x), (_288 * (WorkingColorSpace.ToXYZ[0].x))));
  float _318 = mad(_294, (WorkingColorSpace.ToXYZ[2].y), mad(_291, (WorkingColorSpace.ToXYZ[1].y), (_288 * (WorkingColorSpace.ToXYZ[0].y))));
  float _321 = mad(_294, (WorkingColorSpace.ToXYZ[2].z), mad(_291, (WorkingColorSpace.ToXYZ[1].z), (_288 * (WorkingColorSpace.ToXYZ[0].z))));
  float _324 = mad(_303, (WorkingColorSpace.ToXYZ[2].x), mad(_300, (WorkingColorSpace.ToXYZ[1].x), (_297 * (WorkingColorSpace.ToXYZ[0].x))));
  float _327 = mad(_303, (WorkingColorSpace.ToXYZ[2].y), mad(_300, (WorkingColorSpace.ToXYZ[1].y), (_297 * (WorkingColorSpace.ToXYZ[0].y))));
  float _330 = mad(_303, (WorkingColorSpace.ToXYZ[2].z), mad(_300, (WorkingColorSpace.ToXYZ[1].z), (_297 * (WorkingColorSpace.ToXYZ[0].z))));
  float _360 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _330, mad((WorkingColorSpace.FromXYZ[0].y), _321, (_312 * (WorkingColorSpace.FromXYZ[0].x)))), _113, mad(mad((WorkingColorSpace.FromXYZ[0].z), _327, mad((WorkingColorSpace.FromXYZ[0].y), _318, (_309 * (WorkingColorSpace.FromXYZ[0].x)))), _112, (mad((WorkingColorSpace.FromXYZ[0].z), _324, mad((WorkingColorSpace.FromXYZ[0].y), _315, (_306 * (WorkingColorSpace.FromXYZ[0].x)))) * _111)));
  float _363 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _330, mad((WorkingColorSpace.FromXYZ[1].y), _321, (_312 * (WorkingColorSpace.FromXYZ[1].x)))), _113, mad(mad((WorkingColorSpace.FromXYZ[1].z), _327, mad((WorkingColorSpace.FromXYZ[1].y), _318, (_309 * (WorkingColorSpace.FromXYZ[1].x)))), _112, (mad((WorkingColorSpace.FromXYZ[1].z), _324, mad((WorkingColorSpace.FromXYZ[1].y), _315, (_306 * (WorkingColorSpace.FromXYZ[1].x)))) * _111)));
  float _366 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _330, mad((WorkingColorSpace.FromXYZ[2].y), _321, (_312 * (WorkingColorSpace.FromXYZ[2].x)))), _113, mad(mad((WorkingColorSpace.FromXYZ[2].z), _327, mad((WorkingColorSpace.FromXYZ[2].y), _318, (_309 * (WorkingColorSpace.FromXYZ[2].x)))), _112, (mad((WorkingColorSpace.FromXYZ[2].z), _324, mad((WorkingColorSpace.FromXYZ[2].y), _315, (_306 * (WorkingColorSpace.FromXYZ[2].x)))) * _111)));
  float _381 = mad((WorkingColorSpace.ToAP1[0].z), _366, mad((WorkingColorSpace.ToAP1[0].y), _363, ((WorkingColorSpace.ToAP1[0].x) * _360)));
  float _384 = mad((WorkingColorSpace.ToAP1[1].z), _366, mad((WorkingColorSpace.ToAP1[1].y), _363, ((WorkingColorSpace.ToAP1[1].x) * _360)));
  float _387 = mad((WorkingColorSpace.ToAP1[2].z), _366, mad((WorkingColorSpace.ToAP1[2].y), _363, ((WorkingColorSpace.ToAP1[2].x) * _360)));
  float _388 = dot(float3(_381, _384, _387), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _392 = (_381 / _388) + -1.0f;
  float _393 = (_384 / _388) + -1.0f;
  float _394 = (_387 / _388) + -1.0f;
  float _406 = (1.0f - exp2(((_388 * _388) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_392, _393, _394), float3(_392, _393, _394)) * -4.0f));
  float _422 = ((mad(-0.06368321925401688f, _387, mad(-0.3292922377586365f, _384, (_381 * 1.3704125881195068f))) - _381) * _406) + _381;
  float _423 = ((mad(-0.010861365124583244f, _387, mad(1.0970927476882935f, _384, (_381 * -0.08343357592821121f))) - _384) * _406) + _384;
  float _424 = ((mad(1.2036951780319214f, _387, mad(-0.09862580895423889f, _384, (_381 * -0.02579331398010254f))) - _387) * _406) + _387;
  float _425 = dot(float3(_422, _423, _424), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _439 = ColorOffset.w + ColorOffsetShadows.w;
  float _453 = ColorGain.w * ColorGainShadows.w;
  float _467 = ColorGamma.w * ColorGammaShadows.w;
  float _481 = ColorContrast.w * ColorContrastShadows.w;
  float _495 = ColorSaturation.w * ColorSaturationShadows.w;
  float _499 = _422 - _425;
  float _500 = _423 - _425;
  float _501 = _424 - _425;
  float _558 = saturate(_425 / ColorCorrectionShadowsMax);
  float _562 = (_558 * _558) * (3.0f - (_558 * 2.0f));
  float _563 = 1.0f - _562;
  float _572 = ColorOffset.w + ColorOffsetHighlights.w;
  float _581 = ColorGain.w * ColorGainHighlights.w;
  float _590 = ColorGamma.w * ColorGammaHighlights.w;
  float _599 = ColorContrast.w * ColorContrastHighlights.w;
  float _608 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _671 = saturate((_425 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _675 = (_671 * _671) * (3.0f - (_671 * 2.0f));
  float _684 = ColorOffset.w + ColorOffsetMidtones.w;
  float _693 = ColorGain.w * ColorGainMidtones.w;
  float _702 = ColorGamma.w * ColorGammaMidtones.w;
  float _711 = ColorContrast.w * ColorContrastMidtones.w;
  float _720 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _778 = _562 - _675;
  float _789 = ((_675 * (((ColorOffset.x + ColorOffsetHighlights.x) + _572) + (((ColorGain.x * ColorGainHighlights.x) * _581) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _599) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _608) * _499) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _590)))))) + (_563 * (((ColorOffset.x + ColorOffsetShadows.x) + _439) + (((ColorGain.x * ColorGainShadows.x) * _453) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _481) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _495) * _499) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _467))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _684) + (((ColorGain.x * ColorGainMidtones.x) * _693) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _711) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _720) * _499) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _702))))) * _778);
  float _791 = ((_675 * (((ColorOffset.y + ColorOffsetHighlights.y) + _572) + (((ColorGain.y * ColorGainHighlights.y) * _581) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _599) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _608) * _500) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _590)))))) + (_563 * (((ColorOffset.y + ColorOffsetShadows.y) + _439) + (((ColorGain.y * ColorGainShadows.y) * _453) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _481) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _495) * _500) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _467))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _684) + (((ColorGain.y * ColorGainMidtones.y) * _693) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _711) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _720) * _500) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _702))))) * _778);
  float _793 = ((_675 * (((ColorOffset.z + ColorOffsetHighlights.z) + _572) + (((ColorGain.z * ColorGainHighlights.z) * _581) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _599) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _608) * _501) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _590)))))) + (_563 * (((ColorOffset.z + ColorOffsetShadows.z) + _439) + (((ColorGain.z * ColorGainShadows.z) * _453) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _481) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _495) * _501) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _467))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _684) + (((ColorGain.z * ColorGainMidtones.z) * _693) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _711) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _720) * _501) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _702))))) * _778);

#if 1  // begin FilmToneMap with BlueCorrect
  float _1151, _1152, _1153;
  ApplyFilmToneMapWithBlueCorrect(_789, _791, _793,
                                  _1151, _1152, _1153);
#else
  float _829 = ((mad(0.061360642313957214f, _793, mad(-4.540197551250458e-09f, _791, (_789 * 0.9386394023895264f))) - _789) * BlueCorrection) + _789;
  float _830 = ((mad(0.169205904006958f, _793, mad(0.8307942152023315f, _791, (_789 * 6.775371730327606e-08f))) - _791) * BlueCorrection) + _791;
  float _831 = (mad(-2.3283064365386963e-10f, _791, (_789 * -9.313225746154785e-10f)) * BlueCorrection) + _793;
  float _834 = mad(0.16386905312538147f, _831, mad(0.14067868888378143f, _830, (_829 * 0.6954522132873535f)));
  float _837 = mad(0.0955343246459961f, _831, mad(0.8596711158752441f, _830, (_829 * 0.044794581830501556f)));
  float _840 = mad(1.0015007257461548f, _831, mad(0.004025210160762072f, _830, (_829 * -0.005525882821530104f)));
  float _844 = max(max(_834, _837), _840);
  float _849 = (max(_844, 1.000000013351432e-10f) - max(min(min(_834, _837), _840), 1.000000013351432e-10f)) / max(_844, 0.009999999776482582f);
  float _862 = ((_837 + _834) + _840) + (sqrt((((_840 - _837) * _840) + ((_837 - _834) * _837)) + ((_834 - _840) * _834)) * 1.75f);
  float _863 = _862 * 0.3333333432674408f;
  float _864 = _849 + -0.4000000059604645f;
  float _865 = _864 * 5.0f;
  float _869 = max((1.0f - abs(_864 * 2.5f)), 0.0f);
  float _880 = ((float((int)(((int)(uint)((bool)(_865 > 0.0f))) - ((int)(uint)((bool)(_865 < 0.0f))))) * (1.0f - (_869 * _869))) + 1.0f) * 0.02500000037252903f;
  if (!(_863 <= 0.0533333346247673f)) {
    if (!(_863 >= 0.1599999964237213f)) {
      _889 = (((0.23999999463558197f / _862) + -0.5f) * _880);
    } else {
      _889 = 0.0f;
    }
  } else {
    _889 = _880;
  }
  float _890 = _889 + 1.0f;
  float _891 = _890 * _834;
  float _892 = _890 * _837;
  float _893 = _890 * _840;
  if (!((bool)(_891 == _892) && (bool)(_892 == _893))) {
    float _900 = ((_891 * 2.0f) - _892) - _893;
    float _903 = ((_837 - _840) * 1.7320507764816284f) * _890;
    float _905 = atan(_903 / _900);
    bool _908 = (_900 < 0.0f);
    bool _909 = (_900 == 0.0f);
    bool _910 = (_903 >= 0.0f);
    bool _911 = (_903 < 0.0f);
    _922 = select((_910 && _909), 90.0f, select((_911 && _909), -90.0f, (select((_911 && _908), (_905 + -3.1415927410125732f), select((_910 && _908), (_905 + 3.1415927410125732f), _905)) * 57.2957763671875f)));
  } else {
    _922 = 0.0f;
  }
  float _927 = min(max(select((_922 < 0.0f), (_922 + 360.0f), _922), 0.0f), 360.0f);
  if (_927 < -180.0f) {
    _936 = (_927 + 360.0f);
  } else {
    if (_927 > 180.0f) {
      _936 = (_927 + -360.0f);
    } else {
      _936 = _927;
    }
  }
  float _940 = saturate(1.0f - abs(_936 * 0.014814814552664757f));
  float _944 = (_940 * _940) * (3.0f - (_940 * 2.0f));
  float _950 = ((_944 * _944) * ((_849 * 0.18000000715255737f) * (0.029999999329447746f - _891))) + _891;
  float _960 = max(0.0f, mad(-0.21492856740951538f, _893, mad(-0.2365107536315918f, _892, (_950 * 1.4514392614364624f))));
  float _961 = max(0.0f, mad(-0.09967592358589172f, _893, mad(1.17622971534729f, _892, (_950 * -0.07655377686023712f))));
  float _962 = max(0.0f, mad(0.9977163076400757f, _893, mad(-0.006032449658960104f, _892, (_950 * 0.008316148072481155f))));
  float _963 = dot(float3(_960, _961, _962), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _978 = (FilmBlackClip + 1.0f) - FilmToe;
  float _980 = FilmWhiteClip + 1.0f;
  float _982 = _980 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1000 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _991 = (FilmBlackClip + 0.18000000715255737f) / _978;
    _1000 = (-0.7447274923324585f - ((log2(_991 / (2.0f - _991)) * 0.3465735912322998f) * (_978 / FilmSlope)));
  }
  float _1003 = ((1.0f - FilmToe) / FilmSlope) - _1000;
  float _1005 = (FilmShoulder / FilmSlope) - _1003;
  float _1009 = lerp(_963, _960, 0.9599999785423279f);
  float _1010 = lerp(_963, _961, 0.9599999785423279f);
  float _1011 = lerp(_963, _962, 0.9599999785423279f);

#if 1
  float _1151, _1152, _1153;
  ApplyFilmicToneMap(_1009, _1010, _1011,
                     _829, _830, _831,
                     _1151, _1152, _1153);
#else

  _1009 = log2(_1009) * 0.3010300099849701f;
  _1010 = log2(_1010) * 0.3010300099849701f;
  _1011 = log2(_1011) * 0.3010300099849701f;
  float _1015 = FilmSlope * (_1009 + _1003);
  float _1016 = FilmSlope * (_1010 + _1003);
  float _1017 = FilmSlope * (_1011 + _1003);
  float _1018 = _978 * 2.0f;
  float _1020 = (FilmSlope * -2.0f) / _978;
  float _1021 = _1009 - _1000;
  float _1022 = _1010 - _1000;
  float _1023 = _1011 - _1000;
  float _1042 = _982 * 2.0f;
  float _1044 = (FilmSlope * 2.0f) / _982;
  float _1069 = select((_1009 < _1000), ((_1018 / (exp2((_1021 * 1.4426950216293335f) * _1020) + 1.0f)) - FilmBlackClip), _1015);
  float _1070 = select((_1010 < _1000), ((_1018 / (exp2((_1022 * 1.4426950216293335f) * _1020) + 1.0f)) - FilmBlackClip), _1016);
  float _1071 = select((_1011 < _1000), ((_1018 / (exp2((_1023 * 1.4426950216293335f) * _1020) + 1.0f)) - FilmBlackClip), _1017);
  float _1078 = _1005 - _1000;
  float _1082 = saturate(_1021 / _1078);
  float _1083 = saturate(_1022 / _1078);
  float _1084 = saturate(_1023 / _1078);
  bool _1085 = (_1005 < _1000);
  float _1089 = select(_1085, (1.0f - _1082), _1082);
  float _1090 = select(_1085, (1.0f - _1083), _1083);
  float _1091 = select(_1085, (1.0f - _1084), _1084);
  float _1110 = (((_1089 * _1089) * (select((_1009 > _1005), (_980 - (_1042 / (exp2(((_1009 - _1005) * 1.4426950216293335f) * _1044) + 1.0f))), _1015) - _1069)) * (3.0f - (_1089 * 2.0f))) + _1069;
  float _1111 = (((_1090 * _1090) * (select((_1010 > _1005), (_980 - (_1042 / (exp2(((_1010 - _1005) * 1.4426950216293335f) * _1044) + 1.0f))), _1016) - _1070)) * (3.0f - (_1090 * 2.0f))) + _1070;
  float _1112 = (((_1091 * _1091) * (select((_1011 > _1005), (_980 - (_1042 / (exp2(((_1011 - _1005) * 1.4426950216293335f) * _1044) + 1.0f))), _1017) - _1071)) * (3.0f - (_1091 * 2.0f))) + _1071;
  float _1113 = dot(float3(_1110, _1111, _1112), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1133 = (ToneCurveAmount * (max(0.0f, (lerp(_1113, _1110, 0.9300000071525574f))) - _829)) + _829;
  float _1134 = (ToneCurveAmount * (max(0.0f, (lerp(_1113, _1111, 0.9300000071525574f))) - _830)) + _830;
  float _1135 = (ToneCurveAmount * (max(0.0f, (lerp(_1113, _1112, 0.9300000071525574f))) - _831)) + _831;
  float _1151 = ((mad(-0.06537103652954102f, _1135, mad(1.451815478503704e-06f, _1134, (_1133 * 1.065374732017517f))) - _1133) * BlueCorrection) + _1133;
  float _1152 = ((mad(-0.20366770029067993f, _1135, mad(1.2036634683609009f, _1134, (_1133 * -2.57161445915699e-07f))) - _1134) * BlueCorrection) + _1134;
  float _1153 = ((mad(0.9999996423721313f, _1135, mad(2.0954757928848267e-08f, _1134, (_1133 * 1.862645149230957e-08f))) - _1135) * BlueCorrection) + _1135;
#endif
#endif  // end FilmToneMap with BlueCorrect

  float _1166 = mad((WorkingColorSpace.FromAP1[0].z), _1153, mad((WorkingColorSpace.FromAP1[0].y), _1152, ((WorkingColorSpace.FromAP1[0].x) * _1151)));
  float _1167 = mad((WorkingColorSpace.FromAP1[1].z), _1153, mad((WorkingColorSpace.FromAP1[1].y), _1152, ((WorkingColorSpace.FromAP1[1].x) * _1151)));
  float _1168 = mad((WorkingColorSpace.FromAP1[2].z), _1153, mad((WorkingColorSpace.FromAP1[2].y), _1152, ((WorkingColorSpace.FromAP1[2].x) * _1151)));

#if 1
  float _1269, _1270, _1271;
  SampleLUTUpgradeToneMap(float3(_1166, _1167, _1168), Samplers_1, Textures_1, _1269, _1270, _1271);
#else
  _1179 = renodx::color::srgb::Encode(saturate(_1166));
  _1190 = renodx::color::srgb::Encode(saturate(_1167));
  _1201 = renodx::color::srgb::Encode(saturate(_1168));
  float _1205 = (_1190 * 0.9375f) + 0.03125f;
  float _1212 = _1201 * 15.0f;
  float _1213 = floor(_1212);
  float _1214 = _1212 - _1213;
  float _1216 = (((_1179 * 0.9375f) + 0.03125f) + _1213) * 0.0625f;
  float4 _1219 = Textures_1.Sample(Samplers_1, float2(_1216, _1205));
  float4 _1226 = Textures_1.Sample(Samplers_1, float2((_1216 + 0.0625f), _1205));
  float _1245 = max(6.103519990574569e-05f, (((lerp(_1219.x, _1226.x, _1214)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1179)));
  float _1246 = max(6.103519990574569e-05f, (((lerp(_1219.y, _1226.y, _1214)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1190)));
  float _1247 = max(6.103519990574569e-05f, (((lerp(_1219.z, _1226.z, _1214)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1201)));
  float _1269 = select((_1245 > 0.040449999272823334f), exp2(log2((_1245 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1245 * 0.07739938050508499f));
  float _1270 = select((_1246 > 0.040449999272823334f), exp2(log2((_1246 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1246 * 0.07739938050508499f));
  float _1271 = select((_1247 > 0.040449999272823334f), exp2(log2((_1247 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1247 * 0.07739938050508499f));
#endif

  float _1297 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1269)) * _1269) + MappingPolynomial.z);
  float _1298 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1270)) * _1270) + MappingPolynomial.z);
  float _1299 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1271)) * _1271) + MappingPolynomial.z);
  float _1306 = ((OverlayColor.x - _1297) * OverlayColor.w) + _1297;
  float _1307 = ((OverlayColor.y - _1298) * OverlayColor.w) + _1298;
  float _1308 = ((OverlayColor.z - _1299) * OverlayColor.w) + _1299;

#if 1
  if (GenerateOutput(_1306, _1307, _1308, SV_Target, OutputDevice)) {
    return SV_Target;
  }
#endif

  float _1309 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _793, mad((WorkingColorSpace.FromAP1[0].y), _791, (_789 * (WorkingColorSpace.FromAP1[0].x))));
  float _1310 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _793, mad((WorkingColorSpace.FromAP1[1].y), _791, ((WorkingColorSpace.FromAP1[1].x) * _789)));
  float _1311 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _793, mad((WorkingColorSpace.FromAP1[2].y), _791, ((WorkingColorSpace.FromAP1[2].x) * _789)));
  float _1318 = ((OverlayColor.x - _1309) * OverlayColor.w) + _1309;
  float _1319 = ((OverlayColor.y - _1310) * OverlayColor.w) + _1310;
  float _1320 = ((OverlayColor.z - _1311) * OverlayColor.w) + _1311;
  float _1332 = exp2(log2(max(0.0f, _1306)) * InverseGamma.y);
  float _1333 = exp2(log2(max(0.0f, _1307)) * InverseGamma.y);
  float _1334 = exp2(log2(max(0.0f, _1308)) * InverseGamma.y);
  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace.bIsSRGB == 0) {
        float _1357 = mad((WorkingColorSpace.ToAP1[0].z), _1334, mad((WorkingColorSpace.ToAP1[0].y), _1333, ((WorkingColorSpace.ToAP1[0].x) * _1332)));
        float _1360 = mad((WorkingColorSpace.ToAP1[1].z), _1334, mad((WorkingColorSpace.ToAP1[1].y), _1333, ((WorkingColorSpace.ToAP1[1].x) * _1332)));
        float _1363 = mad((WorkingColorSpace.ToAP1[2].z), _1334, mad((WorkingColorSpace.ToAP1[2].y), _1333, ((WorkingColorSpace.ToAP1[2].x) * _1332)));
        _1374 = mad(_47, _1363, mad(_46, _1360, (_1357 * _45)));
        _1375 = mad(_50, _1363, mad(_49, _1360, (_1357 * _48)));
        _1376 = mad(_53, _1363, mad(_52, _1360, (_1357 * _51)));
      } else {
        _1374 = _1332;
        _1375 = _1333;
        _1376 = _1334;
      }
      do {
        if (_1374 < 0.0031306699384003878f) {
          _1387 = (_1374 * 12.920000076293945f);
        } else {
          _1387 = (((pow(_1374, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1375 < 0.0031306699384003878f) {
            _1398 = (_1375 * 12.920000076293945f);
          } else {
            _1398 = (((pow(_1375, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1376 < 0.0031306699384003878f) {
            _2954 = _1387;
            _2955 = _1398;
            _2956 = (_1376 * 12.920000076293945f);
          } else {
            _2954 = _1387;
            _2955 = _1398;
            _2956 = (((pow(_1376, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1425 = mad((WorkingColorSpace.ToAP1[0].z), _1334, mad((WorkingColorSpace.ToAP1[0].y), _1333, ((WorkingColorSpace.ToAP1[0].x) * _1332)));
      float _1428 = mad((WorkingColorSpace.ToAP1[1].z), _1334, mad((WorkingColorSpace.ToAP1[1].y), _1333, ((WorkingColorSpace.ToAP1[1].x) * _1332)));
      float _1431 = mad((WorkingColorSpace.ToAP1[2].z), _1334, mad((WorkingColorSpace.ToAP1[2].y), _1333, ((WorkingColorSpace.ToAP1[2].x) * _1332)));
      float _1441 = max(6.103519990574569e-05f, mad(_47, _1431, mad(_46, _1428, (_1425 * _45))));
      float _1442 = max(6.103519990574569e-05f, mad(_50, _1431, mad(_49, _1428, (_1425 * _48))));
      float _1443 = max(6.103519990574569e-05f, mad(_53, _1431, mad(_52, _1428, (_1425 * _51))));
      _2954 = min((_1441 * 4.5f), ((exp2(log2(max(_1441, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2955 = min((_1442 * 4.5f), ((exp2(log2(max(_1442, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2956 = min((_1443 * 4.5f), ((exp2(log2(max(_1443, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1519 = ACESSceneColorMultiplier * _1318;
        float _1520 = ACESSceneColorMultiplier * _1319;
        float _1521 = ACESSceneColorMultiplier * _1320;
        float _1524 = mad((WorkingColorSpace.ToAP0[0].z), _1521, mad((WorkingColorSpace.ToAP0[0].y), _1520, ((WorkingColorSpace.ToAP0[0].x) * _1519)));
        float _1527 = mad((WorkingColorSpace.ToAP0[1].z), _1521, mad((WorkingColorSpace.ToAP0[1].y), _1520, ((WorkingColorSpace.ToAP0[1].x) * _1519)));
        float _1530 = mad((WorkingColorSpace.ToAP0[2].z), _1521, mad((WorkingColorSpace.ToAP0[2].y), _1520, ((WorkingColorSpace.ToAP0[2].x) * _1519)));
        float _1533 = mad(-0.21492856740951538f, _1530, mad(-0.2365107536315918f, _1527, (_1524 * 1.4514392614364624f)));
        float _1536 = mad(-0.09967592358589172f, _1530, mad(1.17622971534729f, _1527, (_1524 * -0.07655377686023712f)));
        float _1539 = mad(0.9977163076400757f, _1530, mad(-0.006032449658960104f, _1527, (_1524 * 0.008316148072481155f)));
        float _1541 = max(_1533, max(_1536, _1539));
        do {
          if (!(_1541 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1524 < 0.0f) || (bool)(_1527 < 0.0f))) || (bool)(_1530 < 0.0f))) {
              float _1551 = abs(_1541);
              float _1552 = (_1541 - _1533) / _1551;
              float _1554 = (_1541 - _1536) / _1551;
              float _1556 = (_1541 - _1539) / _1551;
              do {
                if (!(_1552 < 0.8149999976158142f)) {
                  float _1559 = _1552 + -0.8149999976158142f;
                  _1571 = ((_1559 / exp2(log2(exp2(log2(_1559 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1571 = _1552;
                }
                do {
                  if (!(_1554 < 0.8029999732971191f)) {
                    float _1574 = _1554 + -0.8029999732971191f;
                    _1586 = ((_1574 / exp2(log2(exp2(log2(_1574 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1586 = _1554;
                  }
                  do {
                    if (!(_1556 < 0.8799999952316284f)) {
                      float _1589 = _1556 + -0.8799999952316284f;
                      _1601 = ((_1589 / exp2(log2(exp2(log2(_1589 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1601 = _1556;
                    }
                    _1609 = (_1541 - (_1551 * _1571));
                    _1610 = (_1541 - (_1551 * _1586));
                    _1611 = (_1541 - (_1551 * _1601));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1609 = _1533;
              _1610 = _1536;
              _1611 = _1539;
            }
          } else {
            _1609 = _1533;
            _1610 = _1536;
            _1611 = _1539;
          }
          float _1627 = ((mad(0.16386906802654266f, _1611, mad(0.14067870378494263f, _1610, (_1609 * 0.6954522132873535f))) - _1524) * ACESGamutCompression) + _1524;
          float _1628 = ((mad(0.0955343171954155f, _1611, mad(0.8596711158752441f, _1610, (_1609 * 0.044794563204050064f))) - _1527) * ACESGamutCompression) + _1527;
          float _1629 = ((mad(1.0015007257461548f, _1611, mad(0.004025210160762072f, _1610, (_1609 * -0.005525882821530104f))) - _1530) * ACESGamutCompression) + _1530;
          float _1633 = max(max(_1627, _1628), _1629);
          float _1638 = (max(_1633, 1.000000013351432e-10f) - max(min(min(_1627, _1628), _1629), 1.000000013351432e-10f)) / max(_1633, 0.009999999776482582f);
          float _1651 = ((_1628 + _1627) + _1629) + (sqrt((((_1629 - _1628) * _1629) + ((_1628 - _1627) * _1628)) + ((_1627 - _1629) * _1627)) * 1.75f);
          float _1652 = _1651 * 0.3333333432674408f;
          float _1653 = _1638 + -0.4000000059604645f;
          float _1654 = _1653 * 5.0f;
          float _1658 = max((1.0f - abs(_1653 * 2.5f)), 0.0f);
          float _1669 = ((float((int)(((int)(uint)((bool)(_1654 > 0.0f))) - ((int)(uint)((bool)(_1654 < 0.0f))))) * (1.0f - (_1658 * _1658))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1652 <= 0.0533333346247673f)) {
              if (!(_1652 >= 0.1599999964237213f)) {
                _1678 = (((0.23999999463558197f / _1651) + -0.5f) * _1669);
              } else {
                _1678 = 0.0f;
              }
            } else {
              _1678 = _1669;
            }
            float _1679 = _1678 + 1.0f;
            float _1680 = _1679 * _1627;
            float _1681 = _1679 * _1628;
            float _1682 = _1679 * _1629;
            do {
              if (!((bool)(_1680 == _1681) && (bool)(_1681 == _1682))) {
                float _1689 = ((_1680 * 2.0f) - _1681) - _1682;
                float _1692 = ((_1628 - _1629) * 1.7320507764816284f) * _1679;
                float _1694 = atan(_1692 / _1689);
                bool _1697 = (_1689 < 0.0f);
                bool _1698 = (_1689 == 0.0f);
                bool _1699 = (_1692 >= 0.0f);
                bool _1700 = (_1692 < 0.0f);
                _1711 = select((_1699 && _1698), 90.0f, select((_1700 && _1698), -90.0f, (select((_1700 && _1697), (_1694 + -3.1415927410125732f), select((_1699 && _1697), (_1694 + 3.1415927410125732f), _1694)) * 57.2957763671875f)));
              } else {
                _1711 = 0.0f;
              }
              float _1716 = min(max(select((_1711 < 0.0f), (_1711 + 360.0f), _1711), 0.0f), 360.0f);
              do {
                if (_1716 < -180.0f) {
                  _1725 = (_1716 + 360.0f);
                } else {
                  if (_1716 > 180.0f) {
                    _1725 = (_1716 + -360.0f);
                  } else {
                    _1725 = _1716;
                  }
                }
                do {
                  if ((bool)(_1725 > -67.5f) && (bool)(_1725 < 67.5f)) {
                    float _1731 = (_1725 + 67.5f) * 0.029629629105329514f;
                    int _1732 = int(_1731);
                    float _1734 = _1731 - float((int)(_1732));
                    float _1735 = _1734 * _1734;
                    float _1736 = _1735 * _1734;
                    if (_1732 == 3) {
                      _1764 = (((0.1666666716337204f - (_1734 * 0.5f)) + (_1735 * 0.5f)) - (_1736 * 0.1666666716337204f));
                    } else {
                      if (_1732 == 2) {
                        _1764 = ((0.6666666865348816f - _1735) + (_1736 * 0.5f));
                      } else {
                        if (_1732 == 1) {
                          _1764 = (((_1736 * -0.5f) + 0.1666666716337204f) + ((_1735 + _1734) * 0.5f));
                        } else {
                          _1764 = select((_1732 == 0), (_1736 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1764 = 0.0f;
                  }
                  float _1773 = min(max(((((_1638 * 0.27000001072883606f) * (0.029999999329447746f - _1680)) * _1764) + _1680), 0.0f), 65535.0f);
                  float _1774 = min(max(_1681, 0.0f), 65535.0f);
                  float _1775 = min(max(_1682, 0.0f), 65535.0f);
                  float _1788 = min(max(mad(-0.21492856740951538f, _1775, mad(-0.2365107536315918f, _1774, (_1773 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1789 = min(max(mad(-0.09967592358589172f, _1775, mad(1.17622971534729f, _1774, (_1773 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1790 = min(max(mad(0.9977163076400757f, _1775, mad(-0.006032449658960104f, _1774, (_1773 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1791 = dot(float3(_1788, _1789, _1790), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1802 = log2(max((lerp(_1791, _1788, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1803 = _1802 * 0.3010300099849701f;
                  float _1804 = log2(ACESMinMaxData.x);
                  float _1805 = _1804 * 0.3010300099849701f;
                  do {
                    if (!(!(_1803 <= _1805))) {
                      _1874 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1812 = log2(ACESMidData.x);
                      float _1813 = _1812 * 0.3010300099849701f;
                      if ((bool)(_1803 > _1805) && (bool)(_1803 < _1813)) {
                        float _1821 = ((_1802 - _1804) * 0.9030900001525879f) / ((_1812 - _1804) * 0.3010300099849701f);
                        int _1822 = int(_1821);
                        float _1824 = _1821 - float((int)(_1822));
                        float _1826 = _12[_1822];
                        float _1829 = _12[(_1822 + 1)];
                        float _1834 = _1826 * 0.5f;
                        _1874 = dot(float3((_1824 * _1824), _1824, 1.0f), float3(mad((_12[(_1822 + 2)]), 0.5f, mad(_1829, -1.0f, _1834)), (_1829 - _1826), mad(_1829, 0.5f, _1834)));
                      } else {
                        do {
                          if (!(!(_1803 >= _1813))) {
                            float _1843 = log2(ACESMinMaxData.z);
                            if (_1803 < (_1843 * 0.3010300099849701f)) {
                              float _1851 = ((_1802 - _1812) * 0.9030900001525879f) / ((_1843 - _1812) * 0.3010300099849701f);
                              int _1852 = int(_1851);
                              float _1854 = _1851 - float((int)(_1852));
                              float _1856 = _13[_1852];
                              float _1859 = _13[(_1852 + 1)];
                              float _1864 = _1856 * 0.5f;
                              _1874 = dot(float3((_1854 * _1854), _1854, 1.0f), float3(mad((_13[(_1852 + 2)]), 0.5f, mad(_1859, -1.0f, _1864)), (_1859 - _1856), mad(_1859, 0.5f, _1864)));
                              break;
                            }
                          }
                          _1874 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1878 = log2(max((lerp(_1791, _1789, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1879 = _1878 * 0.3010300099849701f;
                    do {
                      if (!(!(_1879 <= _1805))) {
                        _1948 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1886 = log2(ACESMidData.x);
                        float _1887 = _1886 * 0.3010300099849701f;
                        if ((bool)(_1879 > _1805) && (bool)(_1879 < _1887)) {
                          float _1895 = ((_1878 - _1804) * 0.9030900001525879f) / ((_1886 - _1804) * 0.3010300099849701f);
                          int _1896 = int(_1895);
                          float _1898 = _1895 - float((int)(_1896));
                          float _1900 = _12[_1896];
                          float _1903 = _12[(_1896 + 1)];
                          float _1908 = _1900 * 0.5f;
                          _1948 = dot(float3((_1898 * _1898), _1898, 1.0f), float3(mad((_12[(_1896 + 2)]), 0.5f, mad(_1903, -1.0f, _1908)), (_1903 - _1900), mad(_1903, 0.5f, _1908)));
                        } else {
                          do {
                            if (!(!(_1879 >= _1887))) {
                              float _1917 = log2(ACESMinMaxData.z);
                              if (_1879 < (_1917 * 0.3010300099849701f)) {
                                float _1925 = ((_1878 - _1886) * 0.9030900001525879f) / ((_1917 - _1886) * 0.3010300099849701f);
                                int _1926 = int(_1925);
                                float _1928 = _1925 - float((int)(_1926));
                                float _1930 = _13[_1926];
                                float _1933 = _13[(_1926 + 1)];
                                float _1938 = _1930 * 0.5f;
                                _1948 = dot(float3((_1928 * _1928), _1928, 1.0f), float3(mad((_13[(_1926 + 2)]), 0.5f, mad(_1933, -1.0f, _1938)), (_1933 - _1930), mad(_1933, 0.5f, _1938)));
                                break;
                              }
                            }
                            _1948 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1952 = log2(max((lerp(_1791, _1790, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1953 = _1952 * 0.3010300099849701f;
                      do {
                        if (!(!(_1953 <= _1805))) {
                          _2022 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1960 = log2(ACESMidData.x);
                          float _1961 = _1960 * 0.3010300099849701f;
                          if ((bool)(_1953 > _1805) && (bool)(_1953 < _1961)) {
                            float _1969 = ((_1952 - _1804) * 0.9030900001525879f) / ((_1960 - _1804) * 0.3010300099849701f);
                            int _1970 = int(_1969);
                            float _1972 = _1969 - float((int)(_1970));
                            float _1974 = _12[_1970];
                            float _1977 = _12[(_1970 + 1)];
                            float _1982 = _1974 * 0.5f;
                            _2022 = dot(float3((_1972 * _1972), _1972, 1.0f), float3(mad((_12[(_1970 + 2)]), 0.5f, mad(_1977, -1.0f, _1982)), (_1977 - _1974), mad(_1977, 0.5f, _1982)));
                          } else {
                            do {
                              if (!(!(_1953 >= _1961))) {
                                float _1991 = log2(ACESMinMaxData.z);
                                if (_1953 < (_1991 * 0.3010300099849701f)) {
                                  float _1999 = ((_1952 - _1960) * 0.9030900001525879f) / ((_1991 - _1960) * 0.3010300099849701f);
                                  int _2000 = int(_1999);
                                  float _2002 = _1999 - float((int)(_2000));
                                  float _2004 = _13[_2000];
                                  float _2007 = _13[(_2000 + 1)];
                                  float _2012 = _2004 * 0.5f;
                                  _2022 = dot(float3((_2002 * _2002), _2002, 1.0f), float3(mad((_13[(_2000 + 2)]), 0.5f, mad(_2007, -1.0f, _2012)), (_2007 - _2004), mad(_2007, 0.5f, _2012)));
                                  break;
                                }
                              }
                              _2022 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2026 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2027 = (exp2(_1874 * 3.321928024291992f) - ACESMinMaxData.y) / _2026;
                        float _2029 = (exp2(_1948 * 3.321928024291992f) - ACESMinMaxData.y) / _2026;
                        float _2031 = (exp2(_2022 * 3.321928024291992f) - ACESMinMaxData.y) / _2026;
                        float _2034 = mad(0.15618768334388733f, _2031, mad(0.13400420546531677f, _2029, (_2027 * 0.6624541878700256f)));
                        float _2037 = mad(0.053689517080783844f, _2031, mad(0.6740817427635193f, _2029, (_2027 * 0.2722287178039551f)));
                        float _2040 = mad(1.0103391408920288f, _2031, mad(0.00406073359772563f, _2029, (_2027 * -0.005574649665504694f)));
                        float _2053 = min(max(mad(-0.23642469942569733f, _2040, mad(-0.32480329275131226f, _2037, (_2034 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2054 = min(max(mad(0.016756348311901093f, _2040, mad(1.6153316497802734f, _2037, (_2034 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2055 = min(max(mad(0.9883948564529419f, _2040, mad(-0.008284442126750946f, _2037, (_2034 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2058 = mad(0.15618768334388733f, _2055, mad(0.13400420546531677f, _2054, (_2053 * 0.6624541878700256f)));
                        float _2061 = mad(0.053689517080783844f, _2055, mad(0.6740817427635193f, _2054, (_2053 * 0.2722287178039551f)));
                        float _2064 = mad(1.0103391408920288f, _2055, mad(0.00406073359772563f, _2054, (_2053 * -0.005574649665504694f)));
                        float _2086 = min(max((min(max(mad(-0.23642469942569733f, _2064, mad(-0.32480329275131226f, _2061, (_2058 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2087 = min(max((min(max(mad(0.016756348311901093f, _2064, mad(1.6153316497802734f, _2061, (_2058 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2088 = min(max((min(max(mad(0.9883948564529419f, _2064, mad(-0.008284442126750946f, _2061, (_2058 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 5)) {
                            _2101 = mad(_47, _2088, mad(_46, _2087, (_2086 * _45)));
                            _2102 = mad(_50, _2088, mad(_49, _2087, (_2086 * _48)));
                            _2103 = mad(_53, _2088, mad(_52, _2087, (_2086 * _51)));
                          } else {
                            _2101 = _2086;
                            _2102 = _2087;
                            _2103 = _2088;
                          }
                          float _2113 = exp2(log2(_2101 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2114 = exp2(log2(_2102 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2115 = exp2(log2(_2103 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2954 = exp2(log2((1.0f / ((_2113 * 18.6875f) + 1.0f)) * ((_2113 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2955 = exp2(log2((1.0f / ((_2114 * 18.6875f) + 1.0f)) * ((_2114 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2956 = exp2(log2((1.0f / ((_2115 * 18.6875f) + 1.0f)) * ((_2115 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2193 = ACESSceneColorMultiplier * _1318;
          float _2194 = ACESSceneColorMultiplier * _1319;
          float _2195 = ACESSceneColorMultiplier * _1320;
          float _2198 = mad((WorkingColorSpace.ToAP0[0].z), _2195, mad((WorkingColorSpace.ToAP0[0].y), _2194, ((WorkingColorSpace.ToAP0[0].x) * _2193)));
          float _2201 = mad((WorkingColorSpace.ToAP0[1].z), _2195, mad((WorkingColorSpace.ToAP0[1].y), _2194, ((WorkingColorSpace.ToAP0[1].x) * _2193)));
          float _2204 = mad((WorkingColorSpace.ToAP0[2].z), _2195, mad((WorkingColorSpace.ToAP0[2].y), _2194, ((WorkingColorSpace.ToAP0[2].x) * _2193)));
          float _2207 = mad(-0.21492856740951538f, _2204, mad(-0.2365107536315918f, _2201, (_2198 * 1.4514392614364624f)));
          float _2210 = mad(-0.09967592358589172f, _2204, mad(1.17622971534729f, _2201, (_2198 * -0.07655377686023712f)));
          float _2213 = mad(0.9977163076400757f, _2204, mad(-0.006032449658960104f, _2201, (_2198 * 0.008316148072481155f)));
          float _2215 = max(_2207, max(_2210, _2213));
          do {
            if (!(_2215 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2198 < 0.0f) || (bool)(_2201 < 0.0f))) || (bool)(_2204 < 0.0f))) {
                float _2225 = abs(_2215);
                float _2226 = (_2215 - _2207) / _2225;
                float _2228 = (_2215 - _2210) / _2225;
                float _2230 = (_2215 - _2213) / _2225;
                do {
                  if (!(_2226 < 0.8149999976158142f)) {
                    float _2233 = _2226 + -0.8149999976158142f;
                    _2245 = ((_2233 / exp2(log2(exp2(log2(_2233 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2245 = _2226;
                  }
                  do {
                    if (!(_2228 < 0.8029999732971191f)) {
                      float _2248 = _2228 + -0.8029999732971191f;
                      _2260 = ((_2248 / exp2(log2(exp2(log2(_2248 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2260 = _2228;
                    }
                    do {
                      if (!(_2230 < 0.8799999952316284f)) {
                        float _2263 = _2230 + -0.8799999952316284f;
                        _2275 = ((_2263 / exp2(log2(exp2(log2(_2263 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2275 = _2230;
                      }
                      _2283 = (_2215 - (_2225 * _2245));
                      _2284 = (_2215 - (_2225 * _2260));
                      _2285 = (_2215 - (_2225 * _2275));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2283 = _2207;
                _2284 = _2210;
                _2285 = _2213;
              }
            } else {
              _2283 = _2207;
              _2284 = _2210;
              _2285 = _2213;
            }
            float _2301 = ((mad(0.16386906802654266f, _2285, mad(0.14067870378494263f, _2284, (_2283 * 0.6954522132873535f))) - _2198) * ACESGamutCompression) + _2198;
            float _2302 = ((mad(0.0955343171954155f, _2285, mad(0.8596711158752441f, _2284, (_2283 * 0.044794563204050064f))) - _2201) * ACESGamutCompression) + _2201;
            float _2303 = ((mad(1.0015007257461548f, _2285, mad(0.004025210160762072f, _2284, (_2283 * -0.005525882821530104f))) - _2204) * ACESGamutCompression) + _2204;
            float _2307 = max(max(_2301, _2302), _2303);
            float _2312 = (max(_2307, 1.000000013351432e-10f) - max(min(min(_2301, _2302), _2303), 1.000000013351432e-10f)) / max(_2307, 0.009999999776482582f);
            float _2325 = ((_2302 + _2301) + _2303) + (sqrt((((_2303 - _2302) * _2303) + ((_2302 - _2301) * _2302)) + ((_2301 - _2303) * _2301)) * 1.75f);
            float _2326 = _2325 * 0.3333333432674408f;
            float _2327 = _2312 + -0.4000000059604645f;
            float _2328 = _2327 * 5.0f;
            float _2332 = max((1.0f - abs(_2327 * 2.5f)), 0.0f);
            float _2343 = ((float((int)(((int)(uint)((bool)(_2328 > 0.0f))) - ((int)(uint)((bool)(_2328 < 0.0f))))) * (1.0f - (_2332 * _2332))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2326 <= 0.0533333346247673f)) {
                if (!(_2326 >= 0.1599999964237213f)) {
                  _2352 = (((0.23999999463558197f / _2325) + -0.5f) * _2343);
                } else {
                  _2352 = 0.0f;
                }
              } else {
                _2352 = _2343;
              }
              float _2353 = _2352 + 1.0f;
              float _2354 = _2353 * _2301;
              float _2355 = _2353 * _2302;
              float _2356 = _2353 * _2303;
              do {
                if (!((bool)(_2354 == _2355) && (bool)(_2355 == _2356))) {
                  float _2363 = ((_2354 * 2.0f) - _2355) - _2356;
                  float _2366 = ((_2302 - _2303) * 1.7320507764816284f) * _2353;
                  float _2368 = atan(_2366 / _2363);
                  bool _2371 = (_2363 < 0.0f);
                  bool _2372 = (_2363 == 0.0f);
                  bool _2373 = (_2366 >= 0.0f);
                  bool _2374 = (_2366 < 0.0f);
                  _2385 = select((_2373 && _2372), 90.0f, select((_2374 && _2372), -90.0f, (select((_2374 && _2371), (_2368 + -3.1415927410125732f), select((_2373 && _2371), (_2368 + 3.1415927410125732f), _2368)) * 57.2957763671875f)));
                } else {
                  _2385 = 0.0f;
                }
                float _2390 = min(max(select((_2385 < 0.0f), (_2385 + 360.0f), _2385), 0.0f), 360.0f);
                do {
                  if (_2390 < -180.0f) {
                    _2399 = (_2390 + 360.0f);
                  } else {
                    if (_2390 > 180.0f) {
                      _2399 = (_2390 + -360.0f);
                    } else {
                      _2399 = _2390;
                    }
                  }
                  do {
                    if ((bool)(_2399 > -67.5f) && (bool)(_2399 < 67.5f)) {
                      float _2405 = (_2399 + 67.5f) * 0.029629629105329514f;
                      int _2406 = int(_2405);
                      float _2408 = _2405 - float((int)(_2406));
                      float _2409 = _2408 * _2408;
                      float _2410 = _2409 * _2408;
                      if (_2406 == 3) {
                        _2438 = (((0.1666666716337204f - (_2408 * 0.5f)) + (_2409 * 0.5f)) - (_2410 * 0.1666666716337204f));
                      } else {
                        if (_2406 == 2) {
                          _2438 = ((0.6666666865348816f - _2409) + (_2410 * 0.5f));
                        } else {
                          if (_2406 == 1) {
                            _2438 = (((_2410 * -0.5f) + 0.1666666716337204f) + ((_2409 + _2408) * 0.5f));
                          } else {
                            _2438 = select((_2406 == 0), (_2410 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2438 = 0.0f;
                    }
                    float _2447 = min(max(((((_2312 * 0.27000001072883606f) * (0.029999999329447746f - _2354)) * _2438) + _2354), 0.0f), 65535.0f);
                    float _2448 = min(max(_2355, 0.0f), 65535.0f);
                    float _2449 = min(max(_2356, 0.0f), 65535.0f);
                    float _2462 = min(max(mad(-0.21492856740951538f, _2449, mad(-0.2365107536315918f, _2448, (_2447 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2463 = min(max(mad(-0.09967592358589172f, _2449, mad(1.17622971534729f, _2448, (_2447 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2464 = min(max(mad(0.9977163076400757f, _2449, mad(-0.006032449658960104f, _2448, (_2447 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2465 = dot(float3(_2462, _2463, _2464), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2476 = log2(max((lerp(_2465, _2462, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2477 = _2476 * 0.3010300099849701f;
                    float _2478 = log2(ACESMinMaxData.x);
                    float _2479 = _2478 * 0.3010300099849701f;
                    do {
                      if (!(!(_2477 <= _2479))) {
                        _2548 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2486 = log2(ACESMidData.x);
                        float _2487 = _2486 * 0.3010300099849701f;
                        if ((bool)(_2477 > _2479) && (bool)(_2477 < _2487)) {
                          float _2495 = ((_2476 - _2478) * 0.9030900001525879f) / ((_2486 - _2478) * 0.3010300099849701f);
                          int _2496 = int(_2495);
                          float _2498 = _2495 - float((int)(_2496));
                          float _2500 = _10[_2496];
                          float _2503 = _10[(_2496 + 1)];
                          float _2508 = _2500 * 0.5f;
                          _2548 = dot(float3((_2498 * _2498), _2498, 1.0f), float3(mad((_10[(_2496 + 2)]), 0.5f, mad(_2503, -1.0f, _2508)), (_2503 - _2500), mad(_2503, 0.5f, _2508)));
                        } else {
                          do {
                            if (!(!(_2477 >= _2487))) {
                              float _2517 = log2(ACESMinMaxData.z);
                              if (_2477 < (_2517 * 0.3010300099849701f)) {
                                float _2525 = ((_2476 - _2486) * 0.9030900001525879f) / ((_2517 - _2486) * 0.3010300099849701f);
                                int _2526 = int(_2525);
                                float _2528 = _2525 - float((int)(_2526));
                                float _2530 = _11[_2526];
                                float _2533 = _11[(_2526 + 1)];
                                float _2538 = _2530 * 0.5f;
                                _2548 = dot(float3((_2528 * _2528), _2528, 1.0f), float3(mad((_11[(_2526 + 2)]), 0.5f, mad(_2533, -1.0f, _2538)), (_2533 - _2530), mad(_2533, 0.5f, _2538)));
                                break;
                              }
                            }
                            _2548 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2552 = log2(max((lerp(_2465, _2463, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2553 = _2552 * 0.3010300099849701f;
                      do {
                        if (!(!(_2553 <= _2479))) {
                          _2622 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2560 = log2(ACESMidData.x);
                          float _2561 = _2560 * 0.3010300099849701f;
                          if ((bool)(_2553 > _2479) && (bool)(_2553 < _2561)) {
                            float _2569 = ((_2552 - _2478) * 0.9030900001525879f) / ((_2560 - _2478) * 0.3010300099849701f);
                            int _2570 = int(_2569);
                            float _2572 = _2569 - float((int)(_2570));
                            float _2574 = _10[_2570];
                            float _2577 = _10[(_2570 + 1)];
                            float _2582 = _2574 * 0.5f;
                            _2622 = dot(float3((_2572 * _2572), _2572, 1.0f), float3(mad((_10[(_2570 + 2)]), 0.5f, mad(_2577, -1.0f, _2582)), (_2577 - _2574), mad(_2577, 0.5f, _2582)));
                          } else {
                            do {
                              if (!(!(_2553 >= _2561))) {
                                float _2591 = log2(ACESMinMaxData.z);
                                if (_2553 < (_2591 * 0.3010300099849701f)) {
                                  float _2599 = ((_2552 - _2560) * 0.9030900001525879f) / ((_2591 - _2560) * 0.3010300099849701f);
                                  int _2600 = int(_2599);
                                  float _2602 = _2599 - float((int)(_2600));
                                  float _2604 = _11[_2600];
                                  float _2607 = _11[(_2600 + 1)];
                                  float _2612 = _2604 * 0.5f;
                                  _2622 = dot(float3((_2602 * _2602), _2602, 1.0f), float3(mad((_11[(_2600 + 2)]), 0.5f, mad(_2607, -1.0f, _2612)), (_2607 - _2604), mad(_2607, 0.5f, _2612)));
                                  break;
                                }
                              }
                              _2622 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2626 = log2(max((lerp(_2465, _2464, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2627 = _2626 * 0.3010300099849701f;
                        do {
                          if (!(!(_2627 <= _2479))) {
                            _2696 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2634 = log2(ACESMidData.x);
                            float _2635 = _2634 * 0.3010300099849701f;
                            if ((bool)(_2627 > _2479) && (bool)(_2627 < _2635)) {
                              float _2643 = ((_2626 - _2478) * 0.9030900001525879f) / ((_2634 - _2478) * 0.3010300099849701f);
                              int _2644 = int(_2643);
                              float _2646 = _2643 - float((int)(_2644));
                              float _2648 = _10[_2644];
                              float _2651 = _10[(_2644 + 1)];
                              float _2656 = _2648 * 0.5f;
                              _2696 = dot(float3((_2646 * _2646), _2646, 1.0f), float3(mad((_10[(_2644 + 2)]), 0.5f, mad(_2651, -1.0f, _2656)), (_2651 - _2648), mad(_2651, 0.5f, _2656)));
                            } else {
                              do {
                                if (!(!(_2627 >= _2635))) {
                                  float _2665 = log2(ACESMinMaxData.z);
                                  if (_2627 < (_2665 * 0.3010300099849701f)) {
                                    float _2673 = ((_2626 - _2634) * 0.9030900001525879f) / ((_2665 - _2634) * 0.3010300099849701f);
                                    int _2674 = int(_2673);
                                    float _2676 = _2673 - float((int)(_2674));
                                    float _2678 = _11[_2674];
                                    float _2681 = _11[(_2674 + 1)];
                                    float _2686 = _2678 * 0.5f;
                                    _2696 = dot(float3((_2676 * _2676), _2676, 1.0f), float3(mad((_11[(_2674 + 2)]), 0.5f, mad(_2681, -1.0f, _2686)), (_2681 - _2678), mad(_2681, 0.5f, _2686)));
                                    break;
                                  }
                                }
                                _2696 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2700 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2701 = (exp2(_2548 * 3.321928024291992f) - ACESMinMaxData.y) / _2700;
                          float _2703 = (exp2(_2622 * 3.321928024291992f) - ACESMinMaxData.y) / _2700;
                          float _2705 = (exp2(_2696 * 3.321928024291992f) - ACESMinMaxData.y) / _2700;
                          float _2708 = mad(0.15618768334388733f, _2705, mad(0.13400420546531677f, _2703, (_2701 * 0.6624541878700256f)));
                          float _2711 = mad(0.053689517080783844f, _2705, mad(0.6740817427635193f, _2703, (_2701 * 0.2722287178039551f)));
                          float _2714 = mad(1.0103391408920288f, _2705, mad(0.00406073359772563f, _2703, (_2701 * -0.005574649665504694f)));
                          float _2727 = min(max(mad(-0.23642469942569733f, _2714, mad(-0.32480329275131226f, _2711, (_2708 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2728 = min(max(mad(0.016756348311901093f, _2714, mad(1.6153316497802734f, _2711, (_2708 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2729 = min(max(mad(0.9883948564529419f, _2714, mad(-0.008284442126750946f, _2711, (_2708 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2732 = mad(0.15618768334388733f, _2729, mad(0.13400420546531677f, _2728, (_2727 * 0.6624541878700256f)));
                          float _2735 = mad(0.053689517080783844f, _2729, mad(0.6740817427635193f, _2728, (_2727 * 0.2722287178039551f)));
                          float _2738 = mad(1.0103391408920288f, _2729, mad(0.00406073359772563f, _2728, (_2727 * -0.005574649665504694f)));
                          float _2760 = min(max((min(max(mad(-0.23642469942569733f, _2738, mad(-0.32480329275131226f, _2735, (_2732 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2761 = min(max((min(max(mad(0.016756348311901093f, _2738, mad(1.6153316497802734f, _2735, (_2732 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2762 = min(max((min(max(mad(0.9883948564529419f, _2738, mad(-0.008284442126750946f, _2735, (_2732 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(OutputDevice == 6)) {
                              _2775 = mad(_47, _2762, mad(_46, _2761, (_2760 * _45)));
                              _2776 = mad(_50, _2762, mad(_49, _2761, (_2760 * _48)));
                              _2777 = mad(_53, _2762, mad(_52, _2761, (_2760 * _51)));
                            } else {
                              _2775 = _2760;
                              _2776 = _2761;
                              _2777 = _2762;
                            }
                            float _2787 = exp2(log2(_2775 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2788 = exp2(log2(_2776 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2789 = exp2(log2(_2777 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2954 = exp2(log2((1.0f / ((_2787 * 18.6875f) + 1.0f)) * ((_2787 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2955 = exp2(log2((1.0f / ((_2788 * 18.6875f) + 1.0f)) * ((_2788 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2956 = exp2(log2((1.0f / ((_2789 * 18.6875f) + 1.0f)) * ((_2789 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2834 = mad((WorkingColorSpace.ToAP1[0].z), _1320, mad((WorkingColorSpace.ToAP1[0].y), _1319, ((WorkingColorSpace.ToAP1[0].x) * _1318)));
            float _2837 = mad((WorkingColorSpace.ToAP1[1].z), _1320, mad((WorkingColorSpace.ToAP1[1].y), _1319, ((WorkingColorSpace.ToAP1[1].x) * _1318)));
            float _2840 = mad((WorkingColorSpace.ToAP1[2].z), _1320, mad((WorkingColorSpace.ToAP1[2].y), _1319, ((WorkingColorSpace.ToAP1[2].x) * _1318)));
            float _2859 = exp2(log2(mad(_47, _2840, mad(_46, _2837, (_2834 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2860 = exp2(log2(mad(_50, _2840, mad(_49, _2837, (_2834 * _48))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2861 = exp2(log2(mad(_53, _2840, mad(_52, _2837, (_2834 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2954 = exp2(log2((1.0f / ((_2859 * 18.6875f) + 1.0f)) * ((_2859 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2955 = exp2(log2((1.0f / ((_2860 * 18.6875f) + 1.0f)) * ((_2860 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2956 = exp2(log2((1.0f / ((_2861 * 18.6875f) + 1.0f)) * ((_2861 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2908 = mad((WorkingColorSpace.ToAP1[0].z), _1308, mad((WorkingColorSpace.ToAP1[0].y), _1307, ((WorkingColorSpace.ToAP1[0].x) * _1306)));
                float _2911 = mad((WorkingColorSpace.ToAP1[1].z), _1308, mad((WorkingColorSpace.ToAP1[1].y), _1307, ((WorkingColorSpace.ToAP1[1].x) * _1306)));
                float _2914 = mad((WorkingColorSpace.ToAP1[2].z), _1308, mad((WorkingColorSpace.ToAP1[2].y), _1307, ((WorkingColorSpace.ToAP1[2].x) * _1306)));
                _2954 = mad(_47, _2914, mad(_46, _2911, (_2908 * _45)));
                _2955 = mad(_50, _2914, mad(_49, _2911, (_2908 * _48)));
                _2956 = mad(_53, _2914, mad(_52, _2911, (_2908 * _51)));
              } else {
                float _2927 = mad((WorkingColorSpace.ToAP1[0].z), _1334, mad((WorkingColorSpace.ToAP1[0].y), _1333, ((WorkingColorSpace.ToAP1[0].x) * _1332)));
                float _2930 = mad((WorkingColorSpace.ToAP1[1].z), _1334, mad((WorkingColorSpace.ToAP1[1].y), _1333, ((WorkingColorSpace.ToAP1[1].x) * _1332)));
                float _2933 = mad((WorkingColorSpace.ToAP1[2].z), _1334, mad((WorkingColorSpace.ToAP1[2].y), _1333, ((WorkingColorSpace.ToAP1[2].x) * _1332)));
                _2954 = exp2(log2(mad(_47, _2933, mad(_46, _2930, (_2927 * _45)))) * InverseGamma.z);
                _2955 = exp2(log2(mad(_50, _2933, mad(_49, _2930, (_2927 * _48)))) * InverseGamma.z);
                _2956 = exp2(log2(mad(_53, _2933, mad(_52, _2930, (_2927 * _51)))) * InverseGamma.z);
              }
            } else {
              _2954 = _1318;
              _2955 = _1319;
              _2956 = _1320;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2954 * 0.9523810148239136f);
  SV_Target.y = (_2955 * 0.9523810148239136f);
  SV_Target.z = (_2956 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

#define LUTBUILDER_HASH 0xF87C0AD7

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

Texture2D<float4> Textures_2 : register(t1);

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

SamplerState Samplers_2 : register(s1);

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

  float _12[6];
  float _13[6];
  float _14[6];
  float _15[6];
  float _18 = 0.5f / LUTSize;
  float _23 = LUTSize + -1.0f;
  float _24 = (LUTSize * (TEXCOORD.x - _18)) / _23;
  float _25 = (LUTSize * (TEXCOORD.y - _18)) / _23;
  float _27 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _23;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _113;
  float _114;
  float _115;
  float _163;
  float _891;
  float _924;
  float _938;
  float _1002;
  float _1181;
  float _1192;
  float _1203;
  float _1405;
  float _1406;
  float _1407;
  float _1418;
  float _1429;
  float _1602;
  float _1617;
  float _1632;
  float _1640;
  float _1641;
  float _1642;
  float _1709;
  float _1742;
  float _1756;
  float _1795;
  float _1905;
  float _1979;
  float _2053;
  float _2132;
  float _2133;
  float _2134;
  float _2276;
  float _2291;
  float _2306;
  float _2314;
  float _2315;
  float _2316;
  float _2383;
  float _2416;
  float _2430;
  float _2469;
  float _2579;
  float _2653;
  float _2727;
  float _2806;
  float _2807;
  float _2808;
  float _2985;
  float _2986;
  float _2987;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _36 = (output_gamut == 4);
        _47 = select(_36, 1.0f, 1.705051064491272f);
        _48 = select(_36, 0.0f, -0.6217921376228333f);
        _49 = select(_36, 0.0f, -0.0832589864730835f);
        _50 = select(_36, 0.0f, -0.13025647401809692f);
        _51 = select(_36, 1.0f, 1.140804648399353f);
        _52 = select(_36, 0.0f, -0.010548308491706848f);
        _53 = select(_36, 0.0f, -0.024003351107239723f);
        _54 = select(_36, 0.0f, -0.1289689838886261f);
        _55 = select(_36, 1.0f, 1.1529725790023804f);
      } else {
        _47 = 0.6954522132873535f;
        _48 = 0.14067870378494263f;
        _49 = 0.16386906802654266f;
        _50 = 0.044794563204050064f;
        _51 = 0.8596711158752441f;
        _52 = 0.0955343171954155f;
        _53 = -0.005525882821530104f;
        _54 = 0.004025210160762072f;
        _55 = 1.0015007257461548f;
      }
    } else {
      _47 = 1.0258246660232544f;
      _48 = -0.020053181797266006f;
      _49 = -0.005771636962890625f;
      _50 = -0.002234415616840124f;
      _51 = 1.0045864582061768f;
      _52 = -0.002352118492126465f;
      _53 = -0.005013350863009691f;
      _54 = -0.025290070101618767f;
      _55 = 1.0303035974502563f;
    }
  } else {
    _47 = 1.3792141675949097f;
    _48 = -0.30886411666870117f;
    _49 = -0.0703500509262085f;
    _50 = -0.06933490186929703f;
    _51 = 1.08229660987854f;
    _52 = -0.012961871922016144f;
    _53 = -0.0021590073592960835f;
    _54 = -0.0454593189060688f;
    _55 = 1.0476183891296387f;
  }
  if ((uint)output_device > (uint)2) {
    float _66 = (pow(_24, 0.012683313339948654f));
    float _67 = (pow(_25, 0.012683313339948654f));
    float _68 = (pow(_27, 0.012683313339948654f));
    _113 = (exp2(log2(max(0.0f, (_66 + -0.8359375f)) / (18.8515625f - (_66 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _114 = (exp2(log2(max(0.0f, (_67 + -0.8359375f)) / (18.8515625f - (_67 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _115 = (exp2(log2(max(0.0f, (_68 + -0.8359375f)) / (18.8515625f - (_68 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _113 = ((exp2((_24 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _114 = ((exp2((_25 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _115 = ((exp2((_27 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f && output_device != 8u) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }
#endif

  bool _142 = (bIsTemperatureWhiteBalance != 0);
  float _146 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _163 = (((((2967800.0f - (_146 * 4607000064.0f)) * _146) + 99.11000061035156f) * _146) + 0.24406300485134125f);
  } else {
    _163 = (((((1901800.0f - (_146 * 2006400000.0f)) * _146) + 247.47999572753906f) * _146) + 0.23703999817371368f);
  }
  float _177 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _184 = WhiteTemp * WhiteTemp;
  float _187 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_184 * 1.6145605741257896e-07f));
  float _192 = ((_177 * 2.0f) + 4.0f) - (_187 * 8.0f);
  float _193 = (_177 * 3.0f) / _192;
  float _195 = (_187 * 2.0f) / _192;
  bool _196 = (WhiteTemp < 4000.0f);
  float _205 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _207 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_184 * 1.5317699909210205f)) / (_205 * _205);
  float _214 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _184;
  float _216 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_184 * 308.60699462890625f)) / (_214 * _214);
  float _218 = rsqrt(dot(float2(_207, _216), float2(_207, _216)));
  float _219 = WhiteTint * 0.05000000074505806f;
  float _222 = ((_219 * _216) * _218) + _177;
  float _225 = _187 - ((_219 * _207) * _218);
  float _230 = (4.0f - (_225 * 8.0f)) + (_222 * 2.0f);
  float _236 = (((_222 * 3.0f) / _230) - _193) + select(_196, _193, _163);
  float _237 = (((_225 * 2.0f) / _230) - _195) + select(_196, _195, (((_163 * 2.869999885559082f) + -0.2750000059604645f) - ((_163 * _163) * 3.0f)));
  float _238 = select(_142, _236, 0.3127000033855438f);
  float _239 = select(_142, _237, 0.32899999618530273f);
  float _240 = select(_142, 0.3127000033855438f, _236);
  float _241 = select(_142, 0.32899999618530273f, _237);
  float _242 = max(_239, 1.000000013351432e-10f);
  float _243 = _238 / _242;
  float _246 = ((1.0f - _238) - _239) / _242;
  float _247 = max(_241, 1.000000013351432e-10f);
  float _248 = _240 / _247;
  float _251 = ((1.0f - _240) - _241) / _247;
  float _270 = mad(-0.16140000522136688f, _251, ((_248 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _246, ((_243 * 0.8950999975204468f) + 0.266400009393692f));
  float _271 = mad(0.03669999912381172f, _251, (1.7135000228881836f - (_248 * 0.7501999735832214f))) / mad(0.03669999912381172f, _246, (1.7135000228881836f - (_243 * 0.7501999735832214f)));
  float _272 = mad(1.0296000242233276f, _251, ((_248 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _246, ((_243 * 0.03889999911189079f) + -0.06849999725818634f));
  float _273 = mad(_271, -0.7501999735832214f, 0.0f);
  float _274 = mad(_271, 1.7135000228881836f, 0.0f);
  float _275 = mad(_271, 0.03669999912381172f, -0.0f);
  float _276 = mad(_272, 0.03889999911189079f, 0.0f);
  float _277 = mad(_272, -0.06849999725818634f, 0.0f);
  float _278 = mad(_272, 1.0296000242233276f, 0.0f);
  float _281 = mad(0.1599626988172531f, _276, mad(-0.1470542997121811f, _273, (_270 * 0.883457362651825f)));
  float _284 = mad(0.1599626988172531f, _277, mad(-0.1470542997121811f, _274, (_270 * 0.26293492317199707f)));
  float _287 = mad(0.1599626988172531f, _278, mad(-0.1470542997121811f, _275, (_270 * -0.15930065512657166f)));
  float _290 = mad(0.04929120093584061f, _276, mad(0.5183603167533875f, _273, (_270 * 0.38695648312568665f)));
  float _293 = mad(0.04929120093584061f, _277, mad(0.5183603167533875f, _274, (_270 * 0.11516613513231277f)));
  float _296 = mad(0.04929120093584061f, _278, mad(0.5183603167533875f, _275, (_270 * -0.0697740763425827f)));
  float _299 = mad(0.9684867262840271f, _276, mad(0.04004279896616936f, _273, (_270 * -0.007634039502590895f)));
  float _302 = mad(0.9684867262840271f, _277, mad(0.04004279896616936f, _274, (_270 * -0.0022720457054674625f)));
  float _305 = mad(0.9684867262840271f, _278, mad(0.04004279896616936f, _275, (_270 * 0.0013765322510153055f)));
  float _308 = mad(_287, (WorkingColorSpace.ToXYZ[2].x), mad(_284, (WorkingColorSpace.ToXYZ[1].x), (_281 * (WorkingColorSpace.ToXYZ[0].x))));
  float _311 = mad(_287, (WorkingColorSpace.ToXYZ[2].y), mad(_284, (WorkingColorSpace.ToXYZ[1].y), (_281 * (WorkingColorSpace.ToXYZ[0].y))));
  float _314 = mad(_287, (WorkingColorSpace.ToXYZ[2].z), mad(_284, (WorkingColorSpace.ToXYZ[1].z), (_281 * (WorkingColorSpace.ToXYZ[0].z))));
  float _317 = mad(_296, (WorkingColorSpace.ToXYZ[2].x), mad(_293, (WorkingColorSpace.ToXYZ[1].x), (_290 * (WorkingColorSpace.ToXYZ[0].x))));
  float _320 = mad(_296, (WorkingColorSpace.ToXYZ[2].y), mad(_293, (WorkingColorSpace.ToXYZ[1].y), (_290 * (WorkingColorSpace.ToXYZ[0].y))));
  float _323 = mad(_296, (WorkingColorSpace.ToXYZ[2].z), mad(_293, (WorkingColorSpace.ToXYZ[1].z), (_290 * (WorkingColorSpace.ToXYZ[0].z))));
  float _326 = mad(_305, (WorkingColorSpace.ToXYZ[2].x), mad(_302, (WorkingColorSpace.ToXYZ[1].x), (_299 * (WorkingColorSpace.ToXYZ[0].x))));
  float _329 = mad(_305, (WorkingColorSpace.ToXYZ[2].y), mad(_302, (WorkingColorSpace.ToXYZ[1].y), (_299 * (WorkingColorSpace.ToXYZ[0].y))));
  float _332 = mad(_305, (WorkingColorSpace.ToXYZ[2].z), mad(_302, (WorkingColorSpace.ToXYZ[1].z), (_299 * (WorkingColorSpace.ToXYZ[0].z))));
  float _362 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _332, mad((WorkingColorSpace.FromXYZ[0].y), _323, (_314 * (WorkingColorSpace.FromXYZ[0].x)))), _115, mad(mad((WorkingColorSpace.FromXYZ[0].z), _329, mad((WorkingColorSpace.FromXYZ[0].y), _320, (_311 * (WorkingColorSpace.FromXYZ[0].x)))), _114, (mad((WorkingColorSpace.FromXYZ[0].z), _326, mad((WorkingColorSpace.FromXYZ[0].y), _317, (_308 * (WorkingColorSpace.FromXYZ[0].x)))) * _113)));
  float _365 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _332, mad((WorkingColorSpace.FromXYZ[1].y), _323, (_314 * (WorkingColorSpace.FromXYZ[1].x)))), _115, mad(mad((WorkingColorSpace.FromXYZ[1].z), _329, mad((WorkingColorSpace.FromXYZ[1].y), _320, (_311 * (WorkingColorSpace.FromXYZ[1].x)))), _114, (mad((WorkingColorSpace.FromXYZ[1].z), _326, mad((WorkingColorSpace.FromXYZ[1].y), _317, (_308 * (WorkingColorSpace.FromXYZ[1].x)))) * _113)));
  float _368 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _332, mad((WorkingColorSpace.FromXYZ[2].y), _323, (_314 * (WorkingColorSpace.FromXYZ[2].x)))), _115, mad(mad((WorkingColorSpace.FromXYZ[2].z), _329, mad((WorkingColorSpace.FromXYZ[2].y), _320, (_311 * (WorkingColorSpace.FromXYZ[2].x)))), _114, (mad((WorkingColorSpace.FromXYZ[2].z), _326, mad((WorkingColorSpace.FromXYZ[2].y), _317, (_308 * (WorkingColorSpace.FromXYZ[2].x)))) * _113)));
  float _383 = mad((WorkingColorSpace.ToAP1[0].z), _368, mad((WorkingColorSpace.ToAP1[0].y), _365, ((WorkingColorSpace.ToAP1[0].x) * _362)));
  float _386 = mad((WorkingColorSpace.ToAP1[1].z), _368, mad((WorkingColorSpace.ToAP1[1].y), _365, ((WorkingColorSpace.ToAP1[1].x) * _362)));
  float _389 = mad((WorkingColorSpace.ToAP1[2].z), _368, mad((WorkingColorSpace.ToAP1[2].y), _365, ((WorkingColorSpace.ToAP1[2].x) * _362)));
  float _390 = dot(float3(_383, _386, _389), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _394 = (_383 / _390) + -1.0f;
  float _395 = (_386 / _390) + -1.0f;
  float _396 = (_389 / _390) + -1.0f;
  float _408 = (1.0f - exp2(((_390 * _390) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_394, _395, _396), float3(_394, _395, _396)) * -4.0f));
  float _424 = ((mad(-0.06368321925401688f, _389, mad(-0.3292922377586365f, _386, (_383 * 1.3704125881195068f))) - _383) * _408) + _383;
  float _425 = ((mad(-0.010861365124583244f, _389, mad(1.0970927476882935f, _386, (_383 * -0.08343357592821121f))) - _386) * _408) + _386;
  float _426 = ((mad(1.2036951780319214f, _389, mad(-0.09862580895423889f, _386, (_383 * -0.02579331398010254f))) - _389) * _408) + _389;
  float _427 = dot(float3(_424, _425, _426), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _441 = ColorOffset.w + ColorOffsetShadows.w;
  float _455 = ColorGain.w * ColorGainShadows.w;
  float _469 = ColorGamma.w * ColorGammaShadows.w;
  float _483 = ColorContrast.w * ColorContrastShadows.w;
  float _497 = ColorSaturation.w * ColorSaturationShadows.w;
  float _501 = _424 - _427;
  float _502 = _425 - _427;
  float _503 = _426 - _427;
  float _560 = saturate(_427 / ColorCorrectionShadowsMax);
  float _564 = (_560 * _560) * (3.0f - (_560 * 2.0f));
  float _565 = 1.0f - _564;
  float _574 = ColorOffset.w + ColorOffsetHighlights.w;
  float _583 = ColorGain.w * ColorGainHighlights.w;
  float _592 = ColorGamma.w * ColorGammaHighlights.w;
  float _601 = ColorContrast.w * ColorContrastHighlights.w;
  float _610 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _673 = saturate((_427 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _677 = (_673 * _673) * (3.0f - (_673 * 2.0f));
  float _686 = ColorOffset.w + ColorOffsetMidtones.w;
  float _695 = ColorGain.w * ColorGainMidtones.w;
  float _704 = ColorGamma.w * ColorGammaMidtones.w;
  float _713 = ColorContrast.w * ColorContrastMidtones.w;
  float _722 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _780 = _564 - _677;
  float _791 = ((_677 * (((ColorOffset.x + ColorOffsetHighlights.x) + _574) + (((ColorGain.x * ColorGainHighlights.x) * _583) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _601) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _610) * _501) + _427)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _592)))))) + (_565 * (((ColorOffset.x + ColorOffsetShadows.x) + _441) + (((ColorGain.x * ColorGainShadows.x) * _455) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _483) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _497) * _501) + _427)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _469))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _686) + (((ColorGain.x * ColorGainMidtones.x) * _695) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _713) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _722) * _501) + _427)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _704))))) * _780);
  float _793 = ((_677 * (((ColorOffset.y + ColorOffsetHighlights.y) + _574) + (((ColorGain.y * ColorGainHighlights.y) * _583) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _601) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _610) * _502) + _427)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _592)))))) + (_565 * (((ColorOffset.y + ColorOffsetShadows.y) + _441) + (((ColorGain.y * ColorGainShadows.y) * _455) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _483) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _497) * _502) + _427)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _469))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _686) + (((ColorGain.y * ColorGainMidtones.y) * _695) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _713) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _722) * _502) + _427)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _704))))) * _780);
  float _795 = ((_677 * (((ColorOffset.z + ColorOffsetHighlights.z) + _574) + (((ColorGain.z * ColorGainHighlights.z) * _583) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _601) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _610) * _503) + _427)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _592)))))) + (_565 * (((ColorOffset.z + ColorOffsetShadows.z) + _441) + (((ColorGain.z * ColorGainShadows.z) * _455) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _483) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _497) * _503) + _427)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _469))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _686) + (((ColorGain.z * ColorGainMidtones.z) * _695) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _713) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _722) * _503) + _427)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _704))))) * _780);
  float _831 = ((mad(0.061360642313957214f, _795, mad(-4.540197551250458e-09f, _793, (_791 * 0.9386394023895264f))) - _791) * BlueCorrection) + _791;
  float _832 = ((mad(0.169205904006958f, _795, mad(0.8307942152023315f, _793, (_791 * 6.775371730327606e-08f))) - _793) * BlueCorrection) + _793;
  float _833 = (mad(-2.3283064365386963e-10f, _793, (_791 * -9.313225746154785e-10f)) * BlueCorrection) + _795;
  float _836 = mad(0.16386905312538147f, _833, mad(0.14067868888378143f, _832, (_831 * 0.6954522132873535f)));
  float _839 = mad(0.0955343246459961f, _833, mad(0.8596711158752441f, _832, (_831 * 0.044794581830501556f)));
  float _842 = mad(1.0015007257461548f, _833, mad(0.004025210160762072f, _832, (_831 * -0.005525882821530104f)));
  float _846 = max(max(_836, _839), _842);
  float _851 = (max(_846, 1.000000013351432e-10f) - max(min(min(_836, _839), _842), 1.000000013351432e-10f)) / max(_846, 0.009999999776482582f);
  float _864 = ((_839 + _836) + _842) + (sqrt((((_842 - _839) * _842) + ((_839 - _836) * _839)) + ((_836 - _842) * _836)) * 1.75f);
  float _865 = _864 * 0.3333333432674408f;
  float _866 = _851 + -0.4000000059604645f;
  float _867 = _866 * 5.0f;
  float _871 = max((1.0f - abs(_866 * 2.5f)), 0.0f);
  float _882 = ((float((int)(((int)(uint)((bool)(_867 > 0.0f))) - ((int)(uint)((bool)(_867 < 0.0f))))) * (1.0f - (_871 * _871))) + 1.0f) * 0.02500000037252903f;
  if (!(_865 <= 0.0533333346247673f)) {
    if (!(_865 >= 0.1599999964237213f)) {
      _891 = (((0.23999999463558197f / _864) + -0.5f) * _882);
    } else {
      _891 = 0.0f;
    }
  } else {
    _891 = _882;
  }
  float _892 = _891 + 1.0f;
  float _893 = _892 * _836;
  float _894 = _892 * _839;
  float _895 = _892 * _842;
  if (!((bool)(_893 == _894) && (bool)(_894 == _895))) {
    float _902 = ((_893 * 2.0f) - _894) - _895;
    float _905 = ((_839 - _842) * 1.7320507764816284f) * _892;
    float _907 = atan(_905 / _902);
    bool _910 = (_902 < 0.0f);
    bool _911 = (_902 == 0.0f);
    bool _912 = (_905 >= 0.0f);
    bool _913 = (_905 < 0.0f);
    _924 = select((_912 && _911), 90.0f, select((_913 && _911), -90.0f, (select((_913 && _910), (_907 + -3.1415927410125732f), select((_912 && _910), (_907 + 3.1415927410125732f), _907)) * 57.2957763671875f)));
  } else {
    _924 = 0.0f;
  }
  float _929 = min(max(select((_924 < 0.0f), (_924 + 360.0f), _924), 0.0f), 360.0f);
  if (_929 < -180.0f) {
    _938 = (_929 + 360.0f);
  } else {
    if (_929 > 180.0f) {
      _938 = (_929 + -360.0f);
    } else {
      _938 = _929;
    }
  }
  float _942 = saturate(1.0f - abs(_938 * 0.014814814552664757f));
  float _946 = (_942 * _942) * (3.0f - (_942 * 2.0f));
  float _952 = ((_946 * _946) * ((_851 * 0.18000000715255737f) * (0.029999999329447746f - _893))) + _893;
  float _962 = max(0.0f, mad(-0.21492856740951538f, _895, mad(-0.2365107536315918f, _894, (_952 * 1.4514392614364624f))));
  float _963 = max(0.0f, mad(-0.09967592358589172f, _895, mad(1.17622971534729f, _894, (_952 * -0.07655377686023712f))));
  float _964 = max(0.0f, mad(0.9977163076400757f, _895, mad(-0.006032449658960104f, _894, (_952 * 0.008316148072481155f))));
  float _965 = dot(float3(_962, _963, _964), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _980 = (FilmBlackClip + 1.0f) - FilmToe;
  float _982 = FilmWhiteClip + 1.0f;
  float _984 = _982 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1002 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _993 = (FilmBlackClip + 0.18000000715255737f) / _980;
    _1002 = (-0.7447274923324585f - ((log2(_993 / (2.0f - _993)) * 0.3465735912322998f) * (_980 / FilmSlope)));
  }
  float _1005 = ((1.0f - FilmToe) / FilmSlope) - _1002;
  float _1007 = (FilmShoulder / FilmSlope) - _1005;
  float _1011 = lerp(_965, _962, 0.9599999785423279f);
  float _1012 = lerp(_965, _963, 0.9599999785423279f);
  float _1013 = lerp(_965, _964, 0.9599999785423279f);

#if 1
  float _1153, _1154, _1155;
  ApplyFilmicToneMap(_1011, _1012, _1013,
                     _831, _832, _833,
                     _1153, _1154, _1155);
#else

  _1011 = log2(_1011) * 0.3010300099849701f;
  _1012 = log2(_1012) * 0.3010300099849701f;
  _1013 = log2(_1013) * 0.3010300099849701f;
  float _1017 = FilmSlope * (_1011 + _1005);
  float _1018 = FilmSlope * (_1012 + _1005);
  float _1019 = FilmSlope * (_1013 + _1005);
  float _1020 = _980 * 2.0f;
  float _1022 = (FilmSlope * -2.0f) / _980;
  float _1023 = _1011 - _1002;
  float _1024 = _1012 - _1002;
  float _1025 = _1013 - _1002;
  float _1044 = _984 * 2.0f;
  float _1046 = (FilmSlope * 2.0f) / _984;
  float _1071 = select((_1011 < _1002), ((_1020 / (exp2((_1023 * 1.4426950216293335f) * _1022) + 1.0f)) - FilmBlackClip), _1017);
  float _1072 = select((_1012 < _1002), ((_1020 / (exp2((_1024 * 1.4426950216293335f) * _1022) + 1.0f)) - FilmBlackClip), _1018);
  float _1073 = select((_1013 < _1002), ((_1020 / (exp2((_1025 * 1.4426950216293335f) * _1022) + 1.0f)) - FilmBlackClip), _1019);
  float _1080 = _1007 - _1002;
  float _1084 = saturate(_1023 / _1080);
  float _1085 = saturate(_1024 / _1080);
  float _1086 = saturate(_1025 / _1080);
  bool _1087 = (_1007 < _1002);
  float _1091 = select(_1087, (1.0f - _1084), _1084);
  float _1092 = select(_1087, (1.0f - _1085), _1085);
  float _1093 = select(_1087, (1.0f - _1086), _1086);
  float _1112 = (((_1091 * _1091) * (select((_1011 > _1007), (_982 - (_1044 / (exp2(((_1011 - _1007) * 1.4426950216293335f) * _1046) + 1.0f))), _1017) - _1071)) * (3.0f - (_1091 * 2.0f))) + _1071;
  float _1113 = (((_1092 * _1092) * (select((_1012 > _1007), (_982 - (_1044 / (exp2(((_1012 - _1007) * 1.4426950216293335f) * _1046) + 1.0f))), _1018) - _1072)) * (3.0f - (_1092 * 2.0f))) + _1072;
  float _1114 = (((_1093 * _1093) * (select((_1013 > _1007), (_982 - (_1044 / (exp2(((_1013 - _1007) * 1.4426950216293335f) * _1046) + 1.0f))), _1019) - _1073)) * (3.0f - (_1093 * 2.0f))) + _1073;
  float _1115 = dot(float3(_1112, _1113, _1114), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1135 = (ToneCurveAmount * (max(0.0f, (lerp(_1115, _1112, 0.9300000071525574f))) - _831)) + _831;
  float _1136 = (ToneCurveAmount * (max(0.0f, (lerp(_1115, _1113, 0.9300000071525574f))) - _832)) + _832;
  float _1137 = (ToneCurveAmount * (max(0.0f, (lerp(_1115, _1114, 0.9300000071525574f))) - _833)) + _833;
  float _1153 = ((mad(-0.06537103652954102f, _1137, mad(1.451815478503704e-06f, _1136, (_1135 * 1.065374732017517f))) - _1135) * BlueCorrection) + _1135;
  float _1154 = ((mad(-0.20366770029067993f, _1137, mad(1.2036634683609009f, _1136, (_1135 * -2.57161445915699e-07f))) - _1136) * BlueCorrection) + _1136;
  float _1155 = ((mad(0.9999996423721313f, _1137, mad(2.0954757928848267e-08f, _1136, (_1135 * 1.862645149230957e-08f))) - _1137) * BlueCorrection) + _1137;
#endif

  // remove saturate()
  float _1168 = mad((WorkingColorSpace.FromAP1[0].z), _1155, mad((WorkingColorSpace.FromAP1[0].y), _1154, ((WorkingColorSpace.FromAP1[0].x) * _1153)));
  float _1169 = mad((WorkingColorSpace.FromAP1[1].z), _1155, mad((WorkingColorSpace.FromAP1[1].y), _1154, ((WorkingColorSpace.FromAP1[1].x) * _1153)));
  float _1170 = mad((WorkingColorSpace.FromAP1[2].z), _1155, mad((WorkingColorSpace.FromAP1[2].y), _1154, ((WorkingColorSpace.FromAP1[2].x) * _1153)));

#if 1
  float _1300, _1301, _1302;
  Sample2LUTsUpgradeToneMap(float3(_1168, _1169, _1170), Samplers_1, Samplers_2, Textures_1, Textures_2, _1300, _1301, _1302);

#else
  if (_1168 < 0.0031306699384003878f) {
    _1181 = (_1168 * 12.920000076293945f);
  } else {
    _1181 = (((pow(_1168, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1169 < 0.0031306699384003878f) {
    _1192 = (_1169 * 12.920000076293945f);
  } else {
    _1192 = (((pow(_1169, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1170 < 0.0031306699384003878f) {
    _1203 = (_1170 * 12.920000076293945f);
  } else {
    _1203 = (((pow(_1170, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1207 = (_1192 * 0.9375f) + 0.03125f;
  float _1214 = _1203 * 15.0f;
  float _1215 = floor(_1214);
  float _1216 = _1214 - _1215;
  float _1218 = (_1215 + ((_1181 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1221 = Textures_1.Sample(Samplers_1, float2(_1218, _1207));
  float _1225 = _1218 + 0.0625f;
  float4 _1228 = Textures_1.Sample(Samplers_1, float2(_1225, _1207));
  float4 _1251 = Textures_2.Sample(Samplers_2, float2(_1218, _1207));
  float4 _1257 = Textures_2.Sample(Samplers_2, float2(_1225, _1207));
  float _1276 = max(6.103519990574569e-05f, ((((lerp(_1221.x, _1228.x, _1216)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1181)) + ((lerp(_1251.x, _1257.x, _1216)) * (LUTWeights[0].z))));
  float _1277 = max(6.103519990574569e-05f, ((((lerp(_1221.y, _1228.y, _1216)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1192)) + ((lerp(_1251.y, _1257.y, _1216)) * (LUTWeights[0].z))));
  float _1278 = max(6.103519990574569e-05f, ((((lerp(_1221.z, _1228.z, _1216)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1203)) + ((lerp(_1251.z, _1257.z, _1216)) * (LUTWeights[0].z))));
  float _1300 = select((_1276 > 0.040449999272823334f), exp2(log2((_1276 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1276 * 0.07739938050508499f));
  float _1301 = select((_1277 > 0.040449999272823334f), exp2(log2((_1277 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1277 * 0.07739938050508499f));
  float _1302 = select((_1278 > 0.040449999272823334f), exp2(log2((_1278 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1278 * 0.07739938050508499f));
#endif
  float _1328 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1300)) * _1300) + MappingPolynomial.z);
  float _1329 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1301)) * _1301) + MappingPolynomial.z);
  float _1330 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1302)) * _1302) + MappingPolynomial.z);
  float _1337 = ((OverlayColor.x - _1328) * OverlayColor.w) + _1328;
  float _1338 = ((OverlayColor.y - _1329) * OverlayColor.w) + _1329;
  float _1339 = ((OverlayColor.z - _1330) * OverlayColor.w) + _1330;

#if 1
  if (GenerateOutput(_1337, _1338, _1339, SV_Target, OutputDevice)) {
    return SV_Target;
  }
#endif

  float _1340 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _795, mad((WorkingColorSpace.FromAP1[0].y), _793, (_791 * (WorkingColorSpace.FromAP1[0].x))));
  float _1341 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _795, mad((WorkingColorSpace.FromAP1[1].y), _793, ((WorkingColorSpace.FromAP1[1].x) * _791)));
  float _1342 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _795, mad((WorkingColorSpace.FromAP1[2].y), _793, ((WorkingColorSpace.FromAP1[2].x) * _791)));
  float _1349 = ((OverlayColor.x - _1340) * OverlayColor.w) + _1340;
  float _1350 = ((OverlayColor.y - _1341) * OverlayColor.w) + _1341;
  float _1351 = ((OverlayColor.z - _1342) * OverlayColor.w) + _1342;
  float _1363 = exp2(log2(max(0.0f, _1337)) * InverseGamma.y);
  float _1364 = exp2(log2(max(0.0f, _1338)) * InverseGamma.y);
  float _1365 = exp2(log2(max(0.0f, _1339)) * InverseGamma.y);
  [branch]
  if (output_device == 0) {
    do {
      if (WorkingColorSpace.bIsSRGB == 0) {
        float _1388 = mad((WorkingColorSpace.ToAP1[0].z), _1365, mad((WorkingColorSpace.ToAP1[0].y), _1364, ((WorkingColorSpace.ToAP1[0].x) * _1363)));
        float _1391 = mad((WorkingColorSpace.ToAP1[1].z), _1365, mad((WorkingColorSpace.ToAP1[1].y), _1364, ((WorkingColorSpace.ToAP1[1].x) * _1363)));
        float _1394 = mad((WorkingColorSpace.ToAP1[2].z), _1365, mad((WorkingColorSpace.ToAP1[2].y), _1364, ((WorkingColorSpace.ToAP1[2].x) * _1363)));
        _1405 = mad(_49, _1394, mad(_48, _1391, (_1388 * _47)));
        _1406 = mad(_52, _1394, mad(_51, _1391, (_1388 * _50)));
        _1407 = mad(_55, _1394, mad(_54, _1391, (_1388 * _53)));
      } else {
        _1405 = _1363;
        _1406 = _1364;
        _1407 = _1365;
      }
      do {
        if (_1405 < 0.0031306699384003878f) {
          _1418 = (_1405 * 12.920000076293945f);
        } else {
          _1418 = (((pow(_1405, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1406 < 0.0031306699384003878f) {
            _1429 = (_1406 * 12.920000076293945f);
          } else {
            _1429 = (((pow(_1406, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1407 < 0.0031306699384003878f) {
            _2985 = _1418;
            _2986 = _1429;
            _2987 = (_1407 * 12.920000076293945f);
          } else {
            _2985 = _1418;
            _2986 = _1429;
            _2987 = (((pow(_1407, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1456 = mad((WorkingColorSpace.ToAP1[0].z), _1365, mad((WorkingColorSpace.ToAP1[0].y), _1364, ((WorkingColorSpace.ToAP1[0].x) * _1363)));
      float _1459 = mad((WorkingColorSpace.ToAP1[1].z), _1365, mad((WorkingColorSpace.ToAP1[1].y), _1364, ((WorkingColorSpace.ToAP1[1].x) * _1363)));
      float _1462 = mad((WorkingColorSpace.ToAP1[2].z), _1365, mad((WorkingColorSpace.ToAP1[2].y), _1364, ((WorkingColorSpace.ToAP1[2].x) * _1363)));
      float _1472 = max(6.103519990574569e-05f, mad(_49, _1462, mad(_48, _1459, (_1456 * _47))));
      float _1473 = max(6.103519990574569e-05f, mad(_52, _1462, mad(_51, _1459, (_1456 * _50))));
      float _1474 = max(6.103519990574569e-05f, mad(_55, _1462, mad(_54, _1459, (_1456 * _53))));
      _2985 = min((_1472 * 4.5f), ((exp2(log2(max(_1472, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2986 = min((_1473 * 4.5f), ((exp2(log2(max(_1473, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2987 = min((_1474 * 4.5f), ((exp2(log2(max(_1474, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
        float _1550 = ACESSceneColorMultiplier * _1349;
        float _1551 = ACESSceneColorMultiplier * _1350;
        float _1552 = ACESSceneColorMultiplier * _1351;
        float _1555 = mad((WorkingColorSpace.ToAP0[0].z), _1552, mad((WorkingColorSpace.ToAP0[0].y), _1551, ((WorkingColorSpace.ToAP0[0].x) * _1550)));
        float _1558 = mad((WorkingColorSpace.ToAP0[1].z), _1552, mad((WorkingColorSpace.ToAP0[1].y), _1551, ((WorkingColorSpace.ToAP0[1].x) * _1550)));
        float _1561 = mad((WorkingColorSpace.ToAP0[2].z), _1552, mad((WorkingColorSpace.ToAP0[2].y), _1551, ((WorkingColorSpace.ToAP0[2].x) * _1550)));
        float _1564 = mad(-0.21492856740951538f, _1561, mad(-0.2365107536315918f, _1558, (_1555 * 1.4514392614364624f)));
        float _1567 = mad(-0.09967592358589172f, _1561, mad(1.17622971534729f, _1558, (_1555 * -0.07655377686023712f)));
        float _1570 = mad(0.9977163076400757f, _1561, mad(-0.006032449658960104f, _1558, (_1555 * 0.008316148072481155f)));
        float _1572 = max(_1564, max(_1567, _1570));
        do {
          if (!(_1572 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1555 < 0.0f) || (bool)(_1558 < 0.0f))) || (bool)(_1561 < 0.0f))) {
              float _1582 = abs(_1572);
              float _1583 = (_1572 - _1564) / _1582;
              float _1585 = (_1572 - _1567) / _1582;
              float _1587 = (_1572 - _1570) / _1582;
              do {
                if (!(_1583 < 0.8149999976158142f)) {
                  float _1590 = _1583 + -0.8149999976158142f;
                  _1602 = ((_1590 / exp2(log2(exp2(log2(_1590 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1602 = _1583;
                }
                do {
                  if (!(_1585 < 0.8029999732971191f)) {
                    float _1605 = _1585 + -0.8029999732971191f;
                    _1617 = ((_1605 / exp2(log2(exp2(log2(_1605 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1617 = _1585;
                  }
                  do {
                    if (!(_1587 < 0.8799999952316284f)) {
                      float _1620 = _1587 + -0.8799999952316284f;
                      _1632 = ((_1620 / exp2(log2(exp2(log2(_1620 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1632 = _1587;
                    }
                    _1640 = (_1572 - (_1582 * _1602));
                    _1641 = (_1572 - (_1582 * _1617));
                    _1642 = (_1572 - (_1582 * _1632));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1640 = _1564;
              _1641 = _1567;
              _1642 = _1570;
            }
          } else {
            _1640 = _1564;
            _1641 = _1567;
            _1642 = _1570;
          }
          float _1658 = ((mad(0.16386906802654266f, _1642, mad(0.14067870378494263f, _1641, (_1640 * 0.6954522132873535f))) - _1555) * ACESGamutCompression) + _1555;
          float _1659 = ((mad(0.0955343171954155f, _1642, mad(0.8596711158752441f, _1641, (_1640 * 0.044794563204050064f))) - _1558) * ACESGamutCompression) + _1558;
          float _1660 = ((mad(1.0015007257461548f, _1642, mad(0.004025210160762072f, _1641, (_1640 * -0.005525882821530104f))) - _1561) * ACESGamutCompression) + _1561;
          float _1664 = max(max(_1658, _1659), _1660);
          float _1669 = (max(_1664, 1.000000013351432e-10f) - max(min(min(_1658, _1659), _1660), 1.000000013351432e-10f)) / max(_1664, 0.009999999776482582f);
          float _1682 = ((_1659 + _1658) + _1660) + (sqrt((((_1660 - _1659) * _1660) + ((_1659 - _1658) * _1659)) + ((_1658 - _1660) * _1658)) * 1.75f);
          float _1683 = _1682 * 0.3333333432674408f;
          float _1684 = _1669 + -0.4000000059604645f;
          float _1685 = _1684 * 5.0f;
          float _1689 = max((1.0f - abs(_1684 * 2.5f)), 0.0f);
          float _1700 = ((float((int)(((int)(uint)((bool)(_1685 > 0.0f))) - ((int)(uint)((bool)(_1685 < 0.0f))))) * (1.0f - (_1689 * _1689))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1683 <= 0.0533333346247673f)) {
              if (!(_1683 >= 0.1599999964237213f)) {
                _1709 = (((0.23999999463558197f / _1682) + -0.5f) * _1700);
              } else {
                _1709 = 0.0f;
              }
            } else {
              _1709 = _1700;
            }
            float _1710 = _1709 + 1.0f;
            float _1711 = _1710 * _1658;
            float _1712 = _1710 * _1659;
            float _1713 = _1710 * _1660;
            do {
              if (!((bool)(_1711 == _1712) && (bool)(_1712 == _1713))) {
                float _1720 = ((_1711 * 2.0f) - _1712) - _1713;
                float _1723 = ((_1659 - _1660) * 1.7320507764816284f) * _1710;
                float _1725 = atan(_1723 / _1720);
                bool _1728 = (_1720 < 0.0f);
                bool _1729 = (_1720 == 0.0f);
                bool _1730 = (_1723 >= 0.0f);
                bool _1731 = (_1723 < 0.0f);
                _1742 = select((_1730 && _1729), 90.0f, select((_1731 && _1729), -90.0f, (select((_1731 && _1728), (_1725 + -3.1415927410125732f), select((_1730 && _1728), (_1725 + 3.1415927410125732f), _1725)) * 57.2957763671875f)));
              } else {
                _1742 = 0.0f;
              }
              float _1747 = min(max(select((_1742 < 0.0f), (_1742 + 360.0f), _1742), 0.0f), 360.0f);
              do {
                if (_1747 < -180.0f) {
                  _1756 = (_1747 + 360.0f);
                } else {
                  if (_1747 > 180.0f) {
                    _1756 = (_1747 + -360.0f);
                  } else {
                    _1756 = _1747;
                  }
                }
                do {
                  if ((bool)(_1756 > -67.5f) && (bool)(_1756 < 67.5f)) {
                    float _1762 = (_1756 + 67.5f) * 0.029629629105329514f;
                    int _1763 = int(_1762);
                    float _1765 = _1762 - float((int)(_1763));
                    float _1766 = _1765 * _1765;
                    float _1767 = _1766 * _1765;
                    if (_1763 == 3) {
                      _1795 = (((0.1666666716337204f - (_1765 * 0.5f)) + (_1766 * 0.5f)) - (_1767 * 0.1666666716337204f));
                    } else {
                      if (_1763 == 2) {
                        _1795 = ((0.6666666865348816f - _1766) + (_1767 * 0.5f));
                      } else {
                        if (_1763 == 1) {
                          _1795 = (((_1767 * -0.5f) + 0.1666666716337204f) + ((_1766 + _1765) * 0.5f));
                        } else {
                          _1795 = select((_1763 == 0), (_1767 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1795 = 0.0f;
                  }
                  float _1804 = min(max(((((_1669 * 0.27000001072883606f) * (0.029999999329447746f - _1711)) * _1795) + _1711), 0.0f), 65535.0f);
                  float _1805 = min(max(_1712, 0.0f), 65535.0f);
                  float _1806 = min(max(_1713, 0.0f), 65535.0f);
                  float _1819 = min(max(mad(-0.21492856740951538f, _1806, mad(-0.2365107536315918f, _1805, (_1804 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1820 = min(max(mad(-0.09967592358589172f, _1806, mad(1.17622971534729f, _1805, (_1804 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1821 = min(max(mad(0.9977163076400757f, _1806, mad(-0.006032449658960104f, _1805, (_1804 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1822 = dot(float3(_1819, _1820, _1821), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1833 = log2(max((lerp(_1822, _1819, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1834 = _1833 * 0.3010300099849701f;
                  float _1835 = log2(ACESMinMaxData.x);
                  float _1836 = _1835 * 0.3010300099849701f;
                  do {
                    if (!(!(_1834 <= _1836))) {
                      _1905 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1843 = log2(ACESMidData.x);
                      float _1844 = _1843 * 0.3010300099849701f;
                      if ((bool)(_1834 > _1836) && (bool)(_1834 < _1844)) {
                        float _1852 = ((_1833 - _1835) * 0.9030900001525879f) / ((_1843 - _1835) * 0.3010300099849701f);
                        int _1853 = int(_1852);
                        float _1855 = _1852 - float((int)(_1853));
                        float _1857 = _14[_1853];
                        float _1860 = _14[(_1853 + 1)];
                        float _1865 = _1857 * 0.5f;
                        _1905 = dot(float3((_1855 * _1855), _1855, 1.0f), float3(mad((_14[(_1853 + 2)]), 0.5f, mad(_1860, -1.0f, _1865)), (_1860 - _1857), mad(_1860, 0.5f, _1865)));
                      } else {
                        do {
                          if (!(!(_1834 >= _1844))) {
                            float _1874 = log2(ACESMinMaxData.z);
                            if (_1834 < (_1874 * 0.3010300099849701f)) {
                              float _1882 = ((_1833 - _1843) * 0.9030900001525879f) / ((_1874 - _1843) * 0.3010300099849701f);
                              int _1883 = int(_1882);
                              float _1885 = _1882 - float((int)(_1883));
                              float _1887 = _15[_1883];
                              float _1890 = _15[(_1883 + 1)];
                              float _1895 = _1887 * 0.5f;
                              _1905 = dot(float3((_1885 * _1885), _1885, 1.0f), float3(mad((_15[(_1883 + 2)]), 0.5f, mad(_1890, -1.0f, _1895)), (_1890 - _1887), mad(_1890, 0.5f, _1895)));
                              break;
                            }
                          }
                          _1905 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1909 = log2(max((lerp(_1822, _1820, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1910 = _1909 * 0.3010300099849701f;
                    do {
                      if (!(!(_1910 <= _1836))) {
                        _1979 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1917 = log2(ACESMidData.x);
                        float _1918 = _1917 * 0.3010300099849701f;
                        if ((bool)(_1910 > _1836) && (bool)(_1910 < _1918)) {
                          float _1926 = ((_1909 - _1835) * 0.9030900001525879f) / ((_1917 - _1835) * 0.3010300099849701f);
                          int _1927 = int(_1926);
                          float _1929 = _1926 - float((int)(_1927));
                          float _1931 = _14[_1927];
                          float _1934 = _14[(_1927 + 1)];
                          float _1939 = _1931 * 0.5f;
                          _1979 = dot(float3((_1929 * _1929), _1929, 1.0f), float3(mad((_14[(_1927 + 2)]), 0.5f, mad(_1934, -1.0f, _1939)), (_1934 - _1931), mad(_1934, 0.5f, _1939)));
                        } else {
                          do {
                            if (!(!(_1910 >= _1918))) {
                              float _1948 = log2(ACESMinMaxData.z);
                              if (_1910 < (_1948 * 0.3010300099849701f)) {
                                float _1956 = ((_1909 - _1917) * 0.9030900001525879f) / ((_1948 - _1917) * 0.3010300099849701f);
                                int _1957 = int(_1956);
                                float _1959 = _1956 - float((int)(_1957));
                                float _1961 = _15[_1957];
                                float _1964 = _15[(_1957 + 1)];
                                float _1969 = _1961 * 0.5f;
                                _1979 = dot(float3((_1959 * _1959), _1959, 1.0f), float3(mad((_15[(_1957 + 2)]), 0.5f, mad(_1964, -1.0f, _1969)), (_1964 - _1961), mad(_1964, 0.5f, _1969)));
                                break;
                              }
                            }
                            _1979 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1983 = log2(max((lerp(_1822, _1821, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1984 = _1983 * 0.3010300099849701f;
                      do {
                        if (!(!(_1984 <= _1836))) {
                          _2053 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1991 = log2(ACESMidData.x);
                          float _1992 = _1991 * 0.3010300099849701f;
                          if ((bool)(_1984 > _1836) && (bool)(_1984 < _1992)) {
                            float _2000 = ((_1983 - _1835) * 0.9030900001525879f) / ((_1991 - _1835) * 0.3010300099849701f);
                            int _2001 = int(_2000);
                            float _2003 = _2000 - float((int)(_2001));
                            float _2005 = _14[_2001];
                            float _2008 = _14[(_2001 + 1)];
                            float _2013 = _2005 * 0.5f;
                            _2053 = dot(float3((_2003 * _2003), _2003, 1.0f), float3(mad((_14[(_2001 + 2)]), 0.5f, mad(_2008, -1.0f, _2013)), (_2008 - _2005), mad(_2008, 0.5f, _2013)));
                          } else {
                            do {
                              if (!(!(_1984 >= _1992))) {
                                float _2022 = log2(ACESMinMaxData.z);
                                if (_1984 < (_2022 * 0.3010300099849701f)) {
                                  float _2030 = ((_1983 - _1991) * 0.9030900001525879f) / ((_2022 - _1991) * 0.3010300099849701f);
                                  int _2031 = int(_2030);
                                  float _2033 = _2030 - float((int)(_2031));
                                  float _2035 = _15[_2031];
                                  float _2038 = _15[(_2031 + 1)];
                                  float _2043 = _2035 * 0.5f;
                                  _2053 = dot(float3((_2033 * _2033), _2033, 1.0f), float3(mad((_15[(_2031 + 2)]), 0.5f, mad(_2038, -1.0f, _2043)), (_2038 - _2035), mad(_2038, 0.5f, _2043)));
                                  break;
                                }
                              }
                              _2053 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2057 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2058 = (exp2(_1905 * 3.321928024291992f) - ACESMinMaxData.y) / _2057;
                        float _2060 = (exp2(_1979 * 3.321928024291992f) - ACESMinMaxData.y) / _2057;
                        float _2062 = (exp2(_2053 * 3.321928024291992f) - ACESMinMaxData.y) / _2057;
                        float _2065 = mad(0.15618768334388733f, _2062, mad(0.13400420546531677f, _2060, (_2058 * 0.6624541878700256f)));
                        float _2068 = mad(0.053689517080783844f, _2062, mad(0.6740817427635193f, _2060, (_2058 * 0.2722287178039551f)));
                        float _2071 = mad(1.0103391408920288f, _2062, mad(0.00406073359772563f, _2060, (_2058 * -0.005574649665504694f)));
                        float _2084 = min(max(mad(-0.23642469942569733f, _2071, mad(-0.32480329275131226f, _2068, (_2065 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2085 = min(max(mad(0.016756348311901093f, _2071, mad(1.6153316497802734f, _2068, (_2065 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2086 = min(max(mad(0.9883948564529419f, _2071, mad(-0.008284442126750946f, _2068, (_2065 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2089 = mad(0.15618768334388733f, _2086, mad(0.13400420546531677f, _2085, (_2084 * 0.6624541878700256f)));
                        float _2092 = mad(0.053689517080783844f, _2086, mad(0.6740817427635193f, _2085, (_2084 * 0.2722287178039551f)));
                        float _2095 = mad(1.0103391408920288f, _2086, mad(0.00406073359772563f, _2085, (_2084 * -0.005574649665504694f)));
                        float _2117 = min(max((min(max(mad(-0.23642469942569733f, _2095, mad(-0.32480329275131226f, _2092, (_2089 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2118 = min(max((min(max(mad(0.016756348311901093f, _2095, mad(1.6153316497802734f, _2092, (_2089 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2119 = min(max((min(max(mad(0.9883948564529419f, _2095, mad(-0.008284442126750946f, _2092, (_2089 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 5)) {
                            _2132 = mad(_49, _2119, mad(_48, _2118, (_2117 * _47)));
                            _2133 = mad(_52, _2119, mad(_51, _2118, (_2117 * _50)));
                            _2134 = mad(_55, _2119, mad(_54, _2118, (_2117 * _53)));
                          } else {
                            _2132 = _2117;
                            _2133 = _2118;
                            _2134 = _2119;
                          }
                          float _2144 = exp2(log2(_2132 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2145 = exp2(log2(_2133 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2146 = exp2(log2(_2134 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2985 = exp2(log2((1.0f / ((_2144 * 18.6875f) + 1.0f)) * ((_2144 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2986 = exp2(log2((1.0f / ((_2145 * 18.6875f) + 1.0f)) * ((_2145 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2987 = exp2(log2((1.0f / ((_2146 * 18.6875f) + 1.0f)) * ((_2146 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
        if ((output_device & -3) == 4) {
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
          float _2224 = ACESSceneColorMultiplier * _1349;
          float _2225 = ACESSceneColorMultiplier * _1350;
          float _2226 = ACESSceneColorMultiplier * _1351;
          float _2229 = mad((WorkingColorSpace.ToAP0[0].z), _2226, mad((WorkingColorSpace.ToAP0[0].y), _2225, ((WorkingColorSpace.ToAP0[0].x) * _2224)));
          float _2232 = mad((WorkingColorSpace.ToAP0[1].z), _2226, mad((WorkingColorSpace.ToAP0[1].y), _2225, ((WorkingColorSpace.ToAP0[1].x) * _2224)));
          float _2235 = mad((WorkingColorSpace.ToAP0[2].z), _2226, mad((WorkingColorSpace.ToAP0[2].y), _2225, ((WorkingColorSpace.ToAP0[2].x) * _2224)));
          float _2238 = mad(-0.21492856740951538f, _2235, mad(-0.2365107536315918f, _2232, (_2229 * 1.4514392614364624f)));
          float _2241 = mad(-0.09967592358589172f, _2235, mad(1.17622971534729f, _2232, (_2229 * -0.07655377686023712f)));
          float _2244 = mad(0.9977163076400757f, _2235, mad(-0.006032449658960104f, _2232, (_2229 * 0.008316148072481155f)));
          float _2246 = max(_2238, max(_2241, _2244));
          do {
            if (!(_2246 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2229 < 0.0f) || (bool)(_2232 < 0.0f))) || (bool)(_2235 < 0.0f))) {
                float _2256 = abs(_2246);
                float _2257 = (_2246 - _2238) / _2256;
                float _2259 = (_2246 - _2241) / _2256;
                float _2261 = (_2246 - _2244) / _2256;
                do {
                  if (!(_2257 < 0.8149999976158142f)) {
                    float _2264 = _2257 + -0.8149999976158142f;
                    _2276 = ((_2264 / exp2(log2(exp2(log2(_2264 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2276 = _2257;
                  }
                  do {
                    if (!(_2259 < 0.8029999732971191f)) {
                      float _2279 = _2259 + -0.8029999732971191f;
                      _2291 = ((_2279 / exp2(log2(exp2(log2(_2279 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2291 = _2259;
                    }
                    do {
                      if (!(_2261 < 0.8799999952316284f)) {
                        float _2294 = _2261 + -0.8799999952316284f;
                        _2306 = ((_2294 / exp2(log2(exp2(log2(_2294 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2306 = _2261;
                      }
                      _2314 = (_2246 - (_2256 * _2276));
                      _2315 = (_2246 - (_2256 * _2291));
                      _2316 = (_2246 - (_2256 * _2306));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2314 = _2238;
                _2315 = _2241;
                _2316 = _2244;
              }
            } else {
              _2314 = _2238;
              _2315 = _2241;
              _2316 = _2244;
            }
            float _2332 = ((mad(0.16386906802654266f, _2316, mad(0.14067870378494263f, _2315, (_2314 * 0.6954522132873535f))) - _2229) * ACESGamutCompression) + _2229;
            float _2333 = ((mad(0.0955343171954155f, _2316, mad(0.8596711158752441f, _2315, (_2314 * 0.044794563204050064f))) - _2232) * ACESGamutCompression) + _2232;
            float _2334 = ((mad(1.0015007257461548f, _2316, mad(0.004025210160762072f, _2315, (_2314 * -0.005525882821530104f))) - _2235) * ACESGamutCompression) + _2235;
            float _2338 = max(max(_2332, _2333), _2334);
            float _2343 = (max(_2338, 1.000000013351432e-10f) - max(min(min(_2332, _2333), _2334), 1.000000013351432e-10f)) / max(_2338, 0.009999999776482582f);
            float _2356 = ((_2333 + _2332) + _2334) + (sqrt((((_2334 - _2333) * _2334) + ((_2333 - _2332) * _2333)) + ((_2332 - _2334) * _2332)) * 1.75f);
            float _2357 = _2356 * 0.3333333432674408f;
            float _2358 = _2343 + -0.4000000059604645f;
            float _2359 = _2358 * 5.0f;
            float _2363 = max((1.0f - abs(_2358 * 2.5f)), 0.0f);
            float _2374 = ((float((int)(((int)(uint)((bool)(_2359 > 0.0f))) - ((int)(uint)((bool)(_2359 < 0.0f))))) * (1.0f - (_2363 * _2363))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2357 <= 0.0533333346247673f)) {
                if (!(_2357 >= 0.1599999964237213f)) {
                  _2383 = (((0.23999999463558197f / _2356) + -0.5f) * _2374);
                } else {
                  _2383 = 0.0f;
                }
              } else {
                _2383 = _2374;
              }
              float _2384 = _2383 + 1.0f;
              float _2385 = _2384 * _2332;
              float _2386 = _2384 * _2333;
              float _2387 = _2384 * _2334;
              do {
                if (!((bool)(_2385 == _2386) && (bool)(_2386 == _2387))) {
                  float _2394 = ((_2385 * 2.0f) - _2386) - _2387;
                  float _2397 = ((_2333 - _2334) * 1.7320507764816284f) * _2384;
                  float _2399 = atan(_2397 / _2394);
                  bool _2402 = (_2394 < 0.0f);
                  bool _2403 = (_2394 == 0.0f);
                  bool _2404 = (_2397 >= 0.0f);
                  bool _2405 = (_2397 < 0.0f);
                  _2416 = select((_2404 && _2403), 90.0f, select((_2405 && _2403), -90.0f, (select((_2405 && _2402), (_2399 + -3.1415927410125732f), select((_2404 && _2402), (_2399 + 3.1415927410125732f), _2399)) * 57.2957763671875f)));
                } else {
                  _2416 = 0.0f;
                }
                float _2421 = min(max(select((_2416 < 0.0f), (_2416 + 360.0f), _2416), 0.0f), 360.0f);
                do {
                  if (_2421 < -180.0f) {
                    _2430 = (_2421 + 360.0f);
                  } else {
                    if (_2421 > 180.0f) {
                      _2430 = (_2421 + -360.0f);
                    } else {
                      _2430 = _2421;
                    }
                  }
                  do {
                    if ((bool)(_2430 > -67.5f) && (bool)(_2430 < 67.5f)) {
                      float _2436 = (_2430 + 67.5f) * 0.029629629105329514f;
                      int _2437 = int(_2436);
                      float _2439 = _2436 - float((int)(_2437));
                      float _2440 = _2439 * _2439;
                      float _2441 = _2440 * _2439;
                      if (_2437 == 3) {
                        _2469 = (((0.1666666716337204f - (_2439 * 0.5f)) + (_2440 * 0.5f)) - (_2441 * 0.1666666716337204f));
                      } else {
                        if (_2437 == 2) {
                          _2469 = ((0.6666666865348816f - _2440) + (_2441 * 0.5f));
                        } else {
                          if (_2437 == 1) {
                            _2469 = (((_2441 * -0.5f) + 0.1666666716337204f) + ((_2440 + _2439) * 0.5f));
                          } else {
                            _2469 = select((_2437 == 0), (_2441 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2469 = 0.0f;
                    }
                    float _2478 = min(max(((((_2343 * 0.27000001072883606f) * (0.029999999329447746f - _2385)) * _2469) + _2385), 0.0f), 65535.0f);
                    float _2479 = min(max(_2386, 0.0f), 65535.0f);
                    float _2480 = min(max(_2387, 0.0f), 65535.0f);
                    float _2493 = min(max(mad(-0.21492856740951538f, _2480, mad(-0.2365107536315918f, _2479, (_2478 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2494 = min(max(mad(-0.09967592358589172f, _2480, mad(1.17622971534729f, _2479, (_2478 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2495 = min(max(mad(0.9977163076400757f, _2480, mad(-0.006032449658960104f, _2479, (_2478 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2496 = dot(float3(_2493, _2494, _2495), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2507 = log2(max((lerp(_2496, _2493, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2508 = _2507 * 0.3010300099849701f;
                    float _2509 = log2(ACESMinMaxData.x);
                    float _2510 = _2509 * 0.3010300099849701f;
                    do {
                      if (!(!(_2508 <= _2510))) {
                        _2579 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2517 = log2(ACESMidData.x);
                        float _2518 = _2517 * 0.3010300099849701f;
                        if ((bool)(_2508 > _2510) && (bool)(_2508 < _2518)) {
                          float _2526 = ((_2507 - _2509) * 0.9030900001525879f) / ((_2517 - _2509) * 0.3010300099849701f);
                          int _2527 = int(_2526);
                          float _2529 = _2526 - float((int)(_2527));
                          float _2531 = _12[_2527];
                          float _2534 = _12[(_2527 + 1)];
                          float _2539 = _2531 * 0.5f;
                          _2579 = dot(float3((_2529 * _2529), _2529, 1.0f), float3(mad((_12[(_2527 + 2)]), 0.5f, mad(_2534, -1.0f, _2539)), (_2534 - _2531), mad(_2534, 0.5f, _2539)));
                        } else {
                          do {
                            if (!(!(_2508 >= _2518))) {
                              float _2548 = log2(ACESMinMaxData.z);
                              if (_2508 < (_2548 * 0.3010300099849701f)) {
                                float _2556 = ((_2507 - _2517) * 0.9030900001525879f) / ((_2548 - _2517) * 0.3010300099849701f);
                                int _2557 = int(_2556);
                                float _2559 = _2556 - float((int)(_2557));
                                float _2561 = _13[_2557];
                                float _2564 = _13[(_2557 + 1)];
                                float _2569 = _2561 * 0.5f;
                                _2579 = dot(float3((_2559 * _2559), _2559, 1.0f), float3(mad((_13[(_2557 + 2)]), 0.5f, mad(_2564, -1.0f, _2569)), (_2564 - _2561), mad(_2564, 0.5f, _2569)));
                                break;
                              }
                            }
                            _2579 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2583 = log2(max((lerp(_2496, _2494, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2584 = _2583 * 0.3010300099849701f;
                      do {
                        if (!(!(_2584 <= _2510))) {
                          _2653 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2591 = log2(ACESMidData.x);
                          float _2592 = _2591 * 0.3010300099849701f;
                          if ((bool)(_2584 > _2510) && (bool)(_2584 < _2592)) {
                            float _2600 = ((_2583 - _2509) * 0.9030900001525879f) / ((_2591 - _2509) * 0.3010300099849701f);
                            int _2601 = int(_2600);
                            float _2603 = _2600 - float((int)(_2601));
                            float _2605 = _12[_2601];
                            float _2608 = _12[(_2601 + 1)];
                            float _2613 = _2605 * 0.5f;
                            _2653 = dot(float3((_2603 * _2603), _2603, 1.0f), float3(mad((_12[(_2601 + 2)]), 0.5f, mad(_2608, -1.0f, _2613)), (_2608 - _2605), mad(_2608, 0.5f, _2613)));
                          } else {
                            do {
                              if (!(!(_2584 >= _2592))) {
                                float _2622 = log2(ACESMinMaxData.z);
                                if (_2584 < (_2622 * 0.3010300099849701f)) {
                                  float _2630 = ((_2583 - _2591) * 0.9030900001525879f) / ((_2622 - _2591) * 0.3010300099849701f);
                                  int _2631 = int(_2630);
                                  float _2633 = _2630 - float((int)(_2631));
                                  float _2635 = _13[_2631];
                                  float _2638 = _13[(_2631 + 1)];
                                  float _2643 = _2635 * 0.5f;
                                  _2653 = dot(float3((_2633 * _2633), _2633, 1.0f), float3(mad((_13[(_2631 + 2)]), 0.5f, mad(_2638, -1.0f, _2643)), (_2638 - _2635), mad(_2638, 0.5f, _2643)));
                                  break;
                                }
                              }
                              _2653 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2657 = log2(max((lerp(_2496, _2495, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2658 = _2657 * 0.3010300099849701f;
                        do {
                          if (!(!(_2658 <= _2510))) {
                            _2727 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2665 = log2(ACESMidData.x);
                            float _2666 = _2665 * 0.3010300099849701f;
                            if ((bool)(_2658 > _2510) && (bool)(_2658 < _2666)) {
                              float _2674 = ((_2657 - _2509) * 0.9030900001525879f) / ((_2665 - _2509) * 0.3010300099849701f);
                              int _2675 = int(_2674);
                              float _2677 = _2674 - float((int)(_2675));
                              float _2679 = _12[_2675];
                              float _2682 = _12[(_2675 + 1)];
                              float _2687 = _2679 * 0.5f;
                              _2727 = dot(float3((_2677 * _2677), _2677, 1.0f), float3(mad((_12[(_2675 + 2)]), 0.5f, mad(_2682, -1.0f, _2687)), (_2682 - _2679), mad(_2682, 0.5f, _2687)));
                            } else {
                              do {
                                if (!(!(_2658 >= _2666))) {
                                  float _2696 = log2(ACESMinMaxData.z);
                                  if (_2658 < (_2696 * 0.3010300099849701f)) {
                                    float _2704 = ((_2657 - _2665) * 0.9030900001525879f) / ((_2696 - _2665) * 0.3010300099849701f);
                                    int _2705 = int(_2704);
                                    float _2707 = _2704 - float((int)(_2705));
                                    float _2709 = _13[_2705];
                                    float _2712 = _13[(_2705 + 1)];
                                    float _2717 = _2709 * 0.5f;
                                    _2727 = dot(float3((_2707 * _2707), _2707, 1.0f), float3(mad((_13[(_2705 + 2)]), 0.5f, mad(_2712, -1.0f, _2717)), (_2712 - _2709), mad(_2712, 0.5f, _2717)));
                                    break;
                                  }
                                }
                                _2727 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2731 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2732 = (exp2(_2579 * 3.321928024291992f) - ACESMinMaxData.y) / _2731;
                          float _2734 = (exp2(_2653 * 3.321928024291992f) - ACESMinMaxData.y) / _2731;
                          float _2736 = (exp2(_2727 * 3.321928024291992f) - ACESMinMaxData.y) / _2731;
                          float _2739 = mad(0.15618768334388733f, _2736, mad(0.13400420546531677f, _2734, (_2732 * 0.6624541878700256f)));
                          float _2742 = mad(0.053689517080783844f, _2736, mad(0.6740817427635193f, _2734, (_2732 * 0.2722287178039551f)));
                          float _2745 = mad(1.0103391408920288f, _2736, mad(0.00406073359772563f, _2734, (_2732 * -0.005574649665504694f)));
                          float _2758 = min(max(mad(-0.23642469942569733f, _2745, mad(-0.32480329275131226f, _2742, (_2739 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2759 = min(max(mad(0.016756348311901093f, _2745, mad(1.6153316497802734f, _2742, (_2739 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2760 = min(max(mad(0.9883948564529419f, _2745, mad(-0.008284442126750946f, _2742, (_2739 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2763 = mad(0.15618768334388733f, _2760, mad(0.13400420546531677f, _2759, (_2758 * 0.6624541878700256f)));
                          float _2766 = mad(0.053689517080783844f, _2760, mad(0.6740817427635193f, _2759, (_2758 * 0.2722287178039551f)));
                          float _2769 = mad(1.0103391408920288f, _2760, mad(0.00406073359772563f, _2759, (_2758 * -0.005574649665504694f)));
                          float _2791 = min(max((min(max(mad(-0.23642469942569733f, _2769, mad(-0.32480329275131226f, _2766, (_2763 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2792 = min(max((min(max(mad(0.016756348311901093f, _2769, mad(1.6153316497802734f, _2766, (_2763 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2793 = min(max((min(max(mad(0.9883948564529419f, _2769, mad(-0.008284442126750946f, _2766, (_2763 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(output_device == 6)) {
                              _2806 = mad(_49, _2793, mad(_48, _2792, (_2791 * _47)));
                              _2807 = mad(_52, _2793, mad(_51, _2792, (_2791 * _50)));
                              _2808 = mad(_55, _2793, mad(_54, _2792, (_2791 * _53)));
                            } else {
                              _2806 = _2791;
                              _2807 = _2792;
                              _2808 = _2793;
                            }
                            float _2818 = exp2(log2(_2806 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2819 = exp2(log2(_2807 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2820 = exp2(log2(_2808 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2985 = exp2(log2((1.0f / ((_2818 * 18.6875f) + 1.0f)) * ((_2818 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2986 = exp2(log2((1.0f / ((_2819 * 18.6875f) + 1.0f)) * ((_2819 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2987 = exp2(log2((1.0f / ((_2820 * 18.6875f) + 1.0f)) * ((_2820 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          if (output_device == 7) {
            float _2865 = mad((WorkingColorSpace.ToAP1[0].z), _1351, mad((WorkingColorSpace.ToAP1[0].y), _1350, ((WorkingColorSpace.ToAP1[0].x) * _1349)));
            float _2868 = mad((WorkingColorSpace.ToAP1[1].z), _1351, mad((WorkingColorSpace.ToAP1[1].y), _1350, ((WorkingColorSpace.ToAP1[1].x) * _1349)));
            float _2871 = mad((WorkingColorSpace.ToAP1[2].z), _1351, mad((WorkingColorSpace.ToAP1[2].y), _1350, ((WorkingColorSpace.ToAP1[2].x) * _1349)));
            float _2890 = exp2(log2(mad(_49, _2871, mad(_48, _2868, (_2865 * _47))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2891 = exp2(log2(mad(_52, _2871, mad(_51, _2868, (_2865 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2892 = exp2(log2(mad(_55, _2871, mad(_54, _2868, (_2865 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2985 = exp2(log2((1.0f / ((_2890 * 18.6875f) + 1.0f)) * ((_2890 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2986 = exp2(log2((1.0f / ((_2891 * 18.6875f) + 1.0f)) * ((_2891 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2987 = exp2(log2((1.0f / ((_2892 * 18.6875f) + 1.0f)) * ((_2892 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2939 = mad((WorkingColorSpace.ToAP1[0].z), _1339, mad((WorkingColorSpace.ToAP1[0].y), _1338, ((WorkingColorSpace.ToAP1[0].x) * _1337)));
                float _2942 = mad((WorkingColorSpace.ToAP1[1].z), _1339, mad((WorkingColorSpace.ToAP1[1].y), _1338, ((WorkingColorSpace.ToAP1[1].x) * _1337)));
                float _2945 = mad((WorkingColorSpace.ToAP1[2].z), _1339, mad((WorkingColorSpace.ToAP1[2].y), _1338, ((WorkingColorSpace.ToAP1[2].x) * _1337)));
                _2985 = mad(_49, _2945, mad(_48, _2942, (_2939 * _47)));
                _2986 = mad(_52, _2945, mad(_51, _2942, (_2939 * _50)));
                _2987 = mad(_55, _2945, mad(_54, _2942, (_2939 * _53)));
              } else {
                float _2958 = mad((WorkingColorSpace.ToAP1[0].z), _1365, mad((WorkingColorSpace.ToAP1[0].y), _1364, ((WorkingColorSpace.ToAP1[0].x) * _1363)));
                float _2961 = mad((WorkingColorSpace.ToAP1[1].z), _1365, mad((WorkingColorSpace.ToAP1[1].y), _1364, ((WorkingColorSpace.ToAP1[1].x) * _1363)));
                float _2964 = mad((WorkingColorSpace.ToAP1[2].z), _1365, mad((WorkingColorSpace.ToAP1[2].y), _1364, ((WorkingColorSpace.ToAP1[2].x) * _1363)));
                _2985 = exp2(log2(mad(_49, _2964, mad(_48, _2961, (_2958 * _47)))) * InverseGamma.z);
                _2986 = exp2(log2(mad(_52, _2964, mad(_51, _2961, (_2958 * _50)))) * InverseGamma.z);
                _2987 = exp2(log2(mad(_55, _2964, mad(_54, _2961, (_2958 * _53)))) * InverseGamma.z);
              }
            } else {
              _2985 = _1349;
              _2986 = _1350;
              _2987 = _1351;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2985 * 0.9523810148239136f);
  SV_Target.y = (_2986 * 0.9523810148239136f);
  SV_Target.z = (_2987 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

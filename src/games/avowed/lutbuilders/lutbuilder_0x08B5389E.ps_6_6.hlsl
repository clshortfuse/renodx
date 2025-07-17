// Karma - The Dark World

#include "../common.hlsl"

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
  float _14 = 0.5f / LUTSize;
  float _19 = LUTSize + -1.0f;
  float _20 = (LUTSize * (TEXCOORD.x - _14)) / _19;
  float _21 = (LUTSize * (TEXCOORD.y - _14)) / _19;
  float _23 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _19;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _109;
  float _110;
  float _111;
  float _159;
  float _887;
  float _920;
  float _934;
  float _998;
  float _1266;
  float _1267;
  float _1268;
  float _1279;
  float _1290;
  float _1463;
  float _1478;
  float _1493;
  float _1501;
  float _1502;
  float _1503;
  float _1570;
  float _1603;
  float _1617;
  float _1656;
  float _1766;
  float _1840;
  float _1914;
  float _1993;
  float _1994;
  float _1995;
  float _2137;
  float _2152;
  float _2167;
  float _2175;
  float _2176;
  float _2177;
  float _2244;
  float _2277;
  float _2291;
  float _2330;
  float _2440;
  float _2514;
  float _2588;
  float _2667;
  float _2668;
  float _2669;
  float _2846;
  float _2847;
  float _2848;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _32 = (OutputGamut == 4);
        _43 = select(_32, 1.0f, 1.705051064491272f);
        _44 = select(_32, 0.0f, -0.6217921376228333f);
        _45 = select(_32, 0.0f, -0.0832589864730835f);
        _46 = select(_32, 0.0f, -0.13025647401809692f);
        _47 = select(_32, 1.0f, 1.140804648399353f);
        _48 = select(_32, 0.0f, -0.010548308491706848f);
        _49 = select(_32, 0.0f, -0.024003351107239723f);
        _50 = select(_32, 0.0f, -0.1289689838886261f);
        _51 = select(_32, 1.0f, 1.1529725790023804f);
      } else {
        _43 = 0.6954522132873535f;
        _44 = 0.14067870378494263f;
        _45 = 0.16386906802654266f;
        _46 = 0.044794563204050064f;
        _47 = 0.8596711158752441f;
        _48 = 0.0955343171954155f;
        _49 = -0.005525882821530104f;
        _50 = 0.004025210160762072f;
        _51 = 1.0015007257461548f;
      }
    } else {
      _43 = 1.0258246660232544f;
      _44 = -0.020053181797266006f;
      _45 = -0.005771636962890625f;
      _46 = -0.002234415616840124f;
      _47 = 1.0045864582061768f;
      _48 = -0.002352118492126465f;
      _49 = -0.005013350863009691f;
      _50 = -0.025290070101618767f;
      _51 = 1.0303035974502563f;
    }
  } else {
    _43 = 1.3792141675949097f;
    _44 = -0.30886411666870117f;
    _45 = -0.0703500509262085f;
    _46 = -0.06933490186929703f;
    _47 = 1.08229660987854f;
    _48 = -0.012961871922016144f;
    _49 = -0.0021590073592960835f;
    _50 = -0.0454593189060688f;
    _51 = 1.0476183891296387f;
  }
  if ((uint)OutputDevice > (uint)2) {
    float _62 = (pow(_20, 0.012683313339948654f));
    float _63 = (pow(_21, 0.012683313339948654f));
    float _64 = (pow(_23, 0.012683313339948654f));
    _109 = (exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _110 = (exp2(log2(max(0.0f, (_63 + -0.8359375f)) / (18.8515625f - (_63 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _111 = (exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _109 = ((exp2((_20 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _110 = ((exp2((_21 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _111 = ((exp2((_23 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _138 = (bIsTemperatureWhiteBalance != 0);
  float _142 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _159 = (((((2967800.0f - (_142 * 4607000064.0f)) * _142) + 99.11000061035156f) * _142) + 0.24406300485134125f);
  } else {
    _159 = (((((1901800.0f - (_142 * 2006400000.0f)) * _142) + 247.47999572753906f) * _142) + 0.23703999817371368f);
  }
  float _173 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _180 = WhiteTemp * WhiteTemp;
  float _183 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_180 * 1.6145605741257896e-07f));
  float _188 = ((_173 * 2.0f) + 4.0f) - (_183 * 8.0f);
  float _189 = (_173 * 3.0f) / _188;
  float _191 = (_183 * 2.0f) / _188;
  bool _192 = (WhiteTemp < 4000.0f);
  float _201 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _203 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_180 * 1.5317699909210205f)) / (_201 * _201);
  float _210 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _180;
  float _212 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_180 * 308.60699462890625f)) / (_210 * _210);
  float _214 = rsqrt(dot(float2(_203, _212), float2(_203, _212)));
  float _215 = WhiteTint * 0.05000000074505806f;
  float _218 = ((_215 * _212) * _214) + _173;
  float _221 = _183 - ((_215 * _203) * _214);
  float _226 = (4.0f - (_221 * 8.0f)) + (_218 * 2.0f);
  float _232 = (((_218 * 3.0f) / _226) - _189) + select(_192, _189, _159);
  float _233 = (((_221 * 2.0f) / _226) - _191) + select(_192, _191, (((_159 * 2.869999885559082f) + -0.2750000059604645f) - ((_159 * _159) * 3.0f)));
  float _234 = select(_138, _232, 0.3127000033855438f);
  float _235 = select(_138, _233, 0.32899999618530273f);
  float _236 = select(_138, 0.3127000033855438f, _232);
  float _237 = select(_138, 0.32899999618530273f, _233);
  float _238 = max(_235, 1.000000013351432e-10f);
  float _239 = _234 / _238;
  float _242 = ((1.0f - _234) - _235) / _238;
  float _243 = max(_237, 1.000000013351432e-10f);
  float _244 = _236 / _243;
  float _247 = ((1.0f - _236) - _237) / _243;
  float _266 = mad(-0.16140000522136688f, _247, ((_244 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _242, ((_239 * 0.8950999975204468f) + 0.266400009393692f));
  float _267 = mad(0.03669999912381172f, _247, (1.7135000228881836f - (_244 * 0.7501999735832214f))) / mad(0.03669999912381172f, _242, (1.7135000228881836f - (_239 * 0.7501999735832214f)));
  float _268 = mad(1.0296000242233276f, _247, ((_244 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _242, ((_239 * 0.03889999911189079f) + -0.06849999725818634f));
  float _269 = mad(_267, -0.7501999735832214f, 0.0f);
  float _270 = mad(_267, 1.7135000228881836f, 0.0f);
  float _271 = mad(_267, 0.03669999912381172f, -0.0f);
  float _272 = mad(_268, 0.03889999911189079f, 0.0f);
  float _273 = mad(_268, -0.06849999725818634f, 0.0f);
  float _274 = mad(_268, 1.0296000242233276f, 0.0f);
  float _277 = mad(0.1599626988172531f, _272, mad(-0.1470542997121811f, _269, (_266 * 0.883457362651825f)));
  float _280 = mad(0.1599626988172531f, _273, mad(-0.1470542997121811f, _270, (_266 * 0.26293492317199707f)));
  float _283 = mad(0.1599626988172531f, _274, mad(-0.1470542997121811f, _271, (_266 * -0.15930065512657166f)));
  float _286 = mad(0.04929120093584061f, _272, mad(0.5183603167533875f, _269, (_266 * 0.38695648312568665f)));
  float _289 = mad(0.04929120093584061f, _273, mad(0.5183603167533875f, _270, (_266 * 0.11516613513231277f)));
  float _292 = mad(0.04929120093584061f, _274, mad(0.5183603167533875f, _271, (_266 * -0.0697740763425827f)));
  float _295 = mad(0.9684867262840271f, _272, mad(0.04004279896616936f, _269, (_266 * -0.007634039502590895f)));
  float _298 = mad(0.9684867262840271f, _273, mad(0.04004279896616936f, _270, (_266 * -0.0022720457054674625f)));
  float _301 = mad(0.9684867262840271f, _274, mad(0.04004279896616936f, _271, (_266 * 0.0013765322510153055f)));
  float _304 = mad(_283, (WorkingColorSpace.ToXYZ[2].x), mad(_280, (WorkingColorSpace.ToXYZ[1].x), (_277 * (WorkingColorSpace.ToXYZ[0].x))));
  float _307 = mad(_283, (WorkingColorSpace.ToXYZ[2].y), mad(_280, (WorkingColorSpace.ToXYZ[1].y), (_277 * (WorkingColorSpace.ToXYZ[0].y))));
  float _310 = mad(_283, (WorkingColorSpace.ToXYZ[2].z), mad(_280, (WorkingColorSpace.ToXYZ[1].z), (_277 * (WorkingColorSpace.ToXYZ[0].z))));
  float _313 = mad(_292, (WorkingColorSpace.ToXYZ[2].x), mad(_289, (WorkingColorSpace.ToXYZ[1].x), (_286 * (WorkingColorSpace.ToXYZ[0].x))));
  float _316 = mad(_292, (WorkingColorSpace.ToXYZ[2].y), mad(_289, (WorkingColorSpace.ToXYZ[1].y), (_286 * (WorkingColorSpace.ToXYZ[0].y))));
  float _319 = mad(_292, (WorkingColorSpace.ToXYZ[2].z), mad(_289, (WorkingColorSpace.ToXYZ[1].z), (_286 * (WorkingColorSpace.ToXYZ[0].z))));
  float _322 = mad(_301, (WorkingColorSpace.ToXYZ[2].x), mad(_298, (WorkingColorSpace.ToXYZ[1].x), (_295 * (WorkingColorSpace.ToXYZ[0].x))));
  float _325 = mad(_301, (WorkingColorSpace.ToXYZ[2].y), mad(_298, (WorkingColorSpace.ToXYZ[1].y), (_295 * (WorkingColorSpace.ToXYZ[0].y))));
  float _328 = mad(_301, (WorkingColorSpace.ToXYZ[2].z), mad(_298, (WorkingColorSpace.ToXYZ[1].z), (_295 * (WorkingColorSpace.ToXYZ[0].z))));
  float _358 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _328, mad((WorkingColorSpace.FromXYZ[0].y), _319, (_310 * (WorkingColorSpace.FromXYZ[0].x)))), _111, mad(mad((WorkingColorSpace.FromXYZ[0].z), _325, mad((WorkingColorSpace.FromXYZ[0].y), _316, (_307 * (WorkingColorSpace.FromXYZ[0].x)))), _110, (mad((WorkingColorSpace.FromXYZ[0].z), _322, mad((WorkingColorSpace.FromXYZ[0].y), _313, (_304 * (WorkingColorSpace.FromXYZ[0].x)))) * _109)));
  float _361 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _328, mad((WorkingColorSpace.FromXYZ[1].y), _319, (_310 * (WorkingColorSpace.FromXYZ[1].x)))), _111, mad(mad((WorkingColorSpace.FromXYZ[1].z), _325, mad((WorkingColorSpace.FromXYZ[1].y), _316, (_307 * (WorkingColorSpace.FromXYZ[1].x)))), _110, (mad((WorkingColorSpace.FromXYZ[1].z), _322, mad((WorkingColorSpace.FromXYZ[1].y), _313, (_304 * (WorkingColorSpace.FromXYZ[1].x)))) * _109)));
  float _364 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _328, mad((WorkingColorSpace.FromXYZ[2].y), _319, (_310 * (WorkingColorSpace.FromXYZ[2].x)))), _111, mad(mad((WorkingColorSpace.FromXYZ[2].z), _325, mad((WorkingColorSpace.FromXYZ[2].y), _316, (_307 * (WorkingColorSpace.FromXYZ[2].x)))), _110, (mad((WorkingColorSpace.FromXYZ[2].z), _322, mad((WorkingColorSpace.FromXYZ[2].y), _313, (_304 * (WorkingColorSpace.FromXYZ[2].x)))) * _109)));
  float _379 = mad((WorkingColorSpace.ToAP1[0].z), _364, mad((WorkingColorSpace.ToAP1[0].y), _361, ((WorkingColorSpace.ToAP1[0].x) * _358)));
  float _382 = mad((WorkingColorSpace.ToAP1[1].z), _364, mad((WorkingColorSpace.ToAP1[1].y), _361, ((WorkingColorSpace.ToAP1[1].x) * _358)));
  float _385 = mad((WorkingColorSpace.ToAP1[2].z), _364, mad((WorkingColorSpace.ToAP1[2].y), _361, ((WorkingColorSpace.ToAP1[2].x) * _358)));
  float _386 = dot(float3(_379, _382, _385), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_379, _382, _385));

  float _390 = (_379 / _386) + -1.0f;
  float _391 = (_382 / _386) + -1.0f;
  float _392 = (_385 / _386) + -1.0f;
  float _404 = (1.0f - exp2(((_386 * _386) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_390, _391, _392), float3(_390, _391, _392)) * -4.0f));
  float _420 = ((mad(-0.06368321925401688f, _385, mad(-0.3292922377586365f, _382, (_379 * 1.3704125881195068f))) - _379) * _404) + _379;
  float _421 = ((mad(-0.010861365124583244f, _385, mad(1.0970927476882935f, _382, (_379 * -0.08343357592821121f))) - _382) * _404) + _382;
  float _422 = ((mad(1.2036951780319214f, _385, mad(-0.09862580895423889f, _382, (_379 * -0.02579331398010254f))) - _385) * _404) + _385;
  float _423 = dot(float3(_420, _421, _422), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _437 = ColorOffset.w + ColorOffsetShadows.w;
  float _451 = ColorGain.w * ColorGainShadows.w;
  float _465 = ColorGamma.w * ColorGammaShadows.w;
  float _479 = ColorContrast.w * ColorContrastShadows.w;
  float _493 = ColorSaturation.w * ColorSaturationShadows.w;
  float _497 = _420 - _423;
  float _498 = _421 - _423;
  float _499 = _422 - _423;
  float _556 = saturate(_423 / ColorCorrectionShadowsMax);
  float _560 = (_556 * _556) * (3.0f - (_556 * 2.0f));
  float _561 = 1.0f - _560;
  float _570 = ColorOffset.w + ColorOffsetHighlights.w;
  float _579 = ColorGain.w * ColorGainHighlights.w;
  float _588 = ColorGamma.w * ColorGammaHighlights.w;
  float _597 = ColorContrast.w * ColorContrastHighlights.w;
  float _606 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _669 = saturate((_423 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _673 = (_669 * _669) * (3.0f - (_669 * 2.0f));
  float _682 = ColorOffset.w + ColorOffsetMidtones.w;
  float _691 = ColorGain.w * ColorGainMidtones.w;
  float _700 = ColorGamma.w * ColorGammaMidtones.w;
  float _709 = ColorContrast.w * ColorContrastMidtones.w;
  float _718 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _776 = _560 - _673;
  float _787 = ((_673 * (((ColorOffset.x + ColorOffsetHighlights.x) + _570) + (((ColorGain.x * ColorGainHighlights.x) * _579) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _597) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _606) * _497) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _588)))))) + (_561 * (((ColorOffset.x + ColorOffsetShadows.x) + _437) + (((ColorGain.x * ColorGainShadows.x) * _451) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _479) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _493) * _497) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _465))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _682) + (((ColorGain.x * ColorGainMidtones.x) * _691) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _709) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _718) * _497) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _700))))) * _776);
  float _789 = ((_673 * (((ColorOffset.y + ColorOffsetHighlights.y) + _570) + (((ColorGain.y * ColorGainHighlights.y) * _579) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _597) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _606) * _498) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _588)))))) + (_561 * (((ColorOffset.y + ColorOffsetShadows.y) + _437) + (((ColorGain.y * ColorGainShadows.y) * _451) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _479) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _493) * _498) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _465))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _682) + (((ColorGain.y * ColorGainMidtones.y) * _691) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _709) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _718) * _498) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _700))))) * _776);
  float _791 = ((_673 * (((ColorOffset.z + ColorOffsetHighlights.z) + _570) + (((ColorGain.z * ColorGainHighlights.z) * _579) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _597) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _606) * _499) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _588)))))) + (_561 * (((ColorOffset.z + ColorOffsetShadows.z) + _437) + (((ColorGain.z * ColorGainShadows.z) * _451) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _479) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _493) * _499) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _465))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _682) + (((ColorGain.z * ColorGainMidtones.z) * _691) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _709) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _718) * _499) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _700))))) * _776);

  SetUntonemappedAP1(float3(_787, _789, _791));

  float _827 = ((mad(0.061360642313957214f, _791, mad(-4.540197551250458e-09f, _789, (_787 * 0.9386394023895264f))) - _787) * BlueCorrection) + _787;
  float _828 = ((mad(0.169205904006958f, _791, mad(0.8307942152023315f, _789, (_787 * 6.775371730327606e-08f))) - _789) * BlueCorrection) + _789;
  float _829 = (mad(-2.3283064365386963e-10f, _789, (_787 * -9.313225746154785e-10f)) * BlueCorrection) + _791;
  float _832 = mad(0.16386905312538147f, _829, mad(0.14067868888378143f, _828, (_827 * 0.6954522132873535f)));
  float _835 = mad(0.0955343246459961f, _829, mad(0.8596711158752441f, _828, (_827 * 0.044794581830501556f)));
  float _838 = mad(1.0015007257461548f, _829, mad(0.004025210160762072f, _828, (_827 * -0.005525882821530104f)));
  float _842 = max(max(_832, _835), _838);
  float _847 = (max(_842, 1.000000013351432e-10f) - max(min(min(_832, _835), _838), 1.000000013351432e-10f)) / max(_842, 0.009999999776482582f);
  float _860 = ((_835 + _832) + _838) + (sqrt((((_838 - _835) * _838) + ((_835 - _832) * _835)) + ((_832 - _838) * _832)) * 1.75f);
  float _861 = _860 * 0.3333333432674408f;
  float _862 = _847 + -0.4000000059604645f;
  float _863 = _862 * 5.0f;
  float _867 = max((1.0f - abs(_862 * 2.5f)), 0.0f);
  float _878 = ((float(((int)(uint)((bool)(_863 > 0.0f))) - ((int)(uint)((bool)(_863 < 0.0f)))) * (1.0f - (_867 * _867))) + 1.0f) * 0.02500000037252903f;
  if (!(_861 <= 0.0533333346247673f)) {
    if (!(_861 >= 0.1599999964237213f)) {
      _887 = (((0.23999999463558197f / _860) + -0.5f) * _878);
    } else {
      _887 = 0.0f;
    }
  } else {
    _887 = _878;
  }
  float _888 = _887 + 1.0f;
  float _889 = _888 * _832;
  float _890 = _888 * _835;
  float _891 = _888 * _838;
  if (!((bool)(_889 == _890) && (bool)(_890 == _891))) {
    float _898 = ((_889 * 2.0f) - _890) - _891;
    float _901 = ((_835 - _838) * 1.7320507764816284f) * _888;
    float _903 = atan(_901 / _898);
    bool _906 = (_898 < 0.0f);
    bool _907 = (_898 == 0.0f);
    bool _908 = (_901 >= 0.0f);
    bool _909 = (_901 < 0.0f);
    _920 = select((_908 && _907), 90.0f, select((_909 && _907), -90.0f, (select((_909 && _906), (_903 + -3.1415927410125732f), select((_908 && _906), (_903 + 3.1415927410125732f), _903)) * 57.2957763671875f)));
  } else {
    _920 = 0.0f;
  }
  float _925 = min(max(select((_920 < 0.0f), (_920 + 360.0f), _920), 0.0f), 360.0f);
  if (_925 < -180.0f) {
    _934 = (_925 + 360.0f);
  } else {
    if (_925 > 180.0f) {
      _934 = (_925 + -360.0f);
    } else {
      _934 = _925;
    }
  }
  float _938 = saturate(1.0f - abs(_934 * 0.014814814552664757f));
  float _942 = (_938 * _938) * (3.0f - (_938 * 2.0f));
  float _948 = ((_942 * _942) * ((_847 * 0.18000000715255737f) * (0.029999999329447746f - _889))) + _889;
  float _958 = max(0.0f, mad(-0.21492856740951538f, _891, mad(-0.2365107536315918f, _890, (_948 * 1.4514392614364624f))));
  float _959 = max(0.0f, mad(-0.09967592358589172f, _891, mad(1.17622971534729f, _890, (_948 * -0.07655377686023712f))));
  float _960 = max(0.0f, mad(0.9977163076400757f, _891, mad(-0.006032449658960104f, _890, (_948 * 0.008316148072481155f))));
  float _961 = dot(float3(_958, _959, _960), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _976 = (FilmBlackClip + 1.0f) - FilmToe;
  float _978 = FilmWhiteClip + 1.0f;
  float _980 = _978 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _998 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _989 = (FilmBlackClip + 0.18000000715255737f) / _976;
    _998 = (-0.7447274923324585f - ((log2(_989 / (2.0f - _989)) * 0.3465735912322998f) * (_976 / FilmSlope)));
  }
  float _1001 = ((1.0f - FilmToe) / FilmSlope) - _998;
  float _1003 = (FilmShoulder / FilmSlope) - _1001;
  float _1007 = log2(lerp(_961, _958, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1008 = log2(lerp(_961, _959, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1009 = log2(lerp(_961, _960, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1013 = FilmSlope * (_1007 + _1001);
  float _1014 = FilmSlope * (_1008 + _1001);
  float _1015 = FilmSlope * (_1009 + _1001);
  float _1016 = _976 * 2.0f;
  float _1018 = (FilmSlope * -2.0f) / _976;
  float _1019 = _1007 - _998;
  float _1020 = _1008 - _998;
  float _1021 = _1009 - _998;
  float _1040 = _980 * 2.0f;
  float _1042 = (FilmSlope * 2.0f) / _980;
  float _1067 = select((_1007 < _998), ((_1016 / (exp2((_1019 * 1.4426950216293335f) * _1018) + 1.0f)) - FilmBlackClip), _1013);
  float _1068 = select((_1008 < _998), ((_1016 / (exp2((_1020 * 1.4426950216293335f) * _1018) + 1.0f)) - FilmBlackClip), _1014);
  float _1069 = select((_1009 < _998), ((_1016 / (exp2((_1021 * 1.4426950216293335f) * _1018) + 1.0f)) - FilmBlackClip), _1015);
  float _1076 = _1003 - _998;
  float _1080 = saturate(_1019 / _1076);
  float _1081 = saturate(_1020 / _1076);
  float _1082 = saturate(_1021 / _1076);
  bool _1083 = (_1003 < _998);
  float _1087 = select(_1083, (1.0f - _1080), _1080);
  float _1088 = select(_1083, (1.0f - _1081), _1081);
  float _1089 = select(_1083, (1.0f - _1082), _1082);
  float _1108 = (((_1087 * _1087) * (select((_1007 > _1003), (_978 - (_1040 / (exp2(((_1007 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1013) - _1067)) * (3.0f - (_1087 * 2.0f))) + _1067;
  float _1109 = (((_1088 * _1088) * (select((_1008 > _1003), (_978 - (_1040 / (exp2(((_1008 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1014) - _1068)) * (3.0f - (_1088 * 2.0f))) + _1068;
  float _1110 = (((_1089 * _1089) * (select((_1009 > _1003), (_978 - (_1040 / (exp2(((_1009 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1015) - _1069)) * (3.0f - (_1089 * 2.0f))) + _1069;
  float _1111 = dot(float3(_1108, _1109, _1110), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1131 = (ToneCurveAmount * (max(0.0f, (lerp(_1111, _1108, 0.9300000071525574f))) - _827)) + _827;
  float _1132 = (ToneCurveAmount * (max(0.0f, (lerp(_1111, _1109, 0.9300000071525574f))) - _828)) + _828;
  float _1133 = (ToneCurveAmount * (max(0.0f, (lerp(_1111, _1110, 0.9300000071525574f))) - _829)) + _829;
  float _1149 = ((mad(-0.06537103652954102f, _1133, mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))) - _1131) * BlueCorrection) + _1131;
  float _1150 = ((mad(-0.20366770029067993f, _1133, mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))) - _1132) * BlueCorrection) + _1132;
  float _1151 = ((mad(0.9999996423721313f, _1133, mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))) - _1133) * BlueCorrection) + _1133;

  SetTonemappedAP1(_1149, _1150, _1151);

  float _1161 = max(0.0f, mad((WorkingColorSpace.FromAP1[0].z), _1151, mad((WorkingColorSpace.FromAP1[0].y), _1150, ((WorkingColorSpace.FromAP1[0].x) * _1149))));
  float _1162 = max(0.0f, mad((WorkingColorSpace.FromAP1[1].z), _1151, mad((WorkingColorSpace.FromAP1[1].y), _1150, ((WorkingColorSpace.FromAP1[1].x) * _1149))));
  float _1163 = max(0.0f, mad((WorkingColorSpace.FromAP1[2].z), _1151, mad((WorkingColorSpace.FromAP1[2].y), _1150, ((WorkingColorSpace.FromAP1[2].x) * _1149))));
  float _1189 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1161)) * _1161) + MappingPolynomial.z);
  float _1190 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1162)) * _1162) + MappingPolynomial.z);
  float _1191 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1163)) * _1163) + MappingPolynomial.z);
  float _1198 = ((OverlayColor.x - _1189) * OverlayColor.w) + _1189;
  float _1199 = ((OverlayColor.y - _1190) * OverlayColor.w) + _1190;
  float _1200 = ((OverlayColor.z - _1191) * OverlayColor.w) + _1191;
  float _1201 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _791, mad((WorkingColorSpace.FromAP1[0].y), _789, (_787 * (WorkingColorSpace.FromAP1[0].x))));
  float _1202 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _791, mad((WorkingColorSpace.FromAP1[1].y), _789, ((WorkingColorSpace.FromAP1[1].x) * _787)));
  float _1203 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _791, mad((WorkingColorSpace.FromAP1[2].y), _789, ((WorkingColorSpace.FromAP1[2].x) * _787)));
  float _1210 = ((OverlayColor.x - _1201) * OverlayColor.w) + _1201;
  float _1211 = ((OverlayColor.y - _1202) * OverlayColor.w) + _1202;
  float _1212 = ((OverlayColor.z - _1203) * OverlayColor.w) + _1203;
  float _1224 = exp2(log2(max(0.0f, _1198)) * InverseGamma.y);
  float _1225 = exp2(log2(max(0.0f, _1199)) * InverseGamma.y);
  float _1226 = exp2(log2(max(0.0f, _1200)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1224, _1225, _1226), OutputDevice);
  }

  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace.bIsSRGB == 0) {
        float _1249 = mad((WorkingColorSpace.ToAP1[0].z), _1226, mad((WorkingColorSpace.ToAP1[0].y), _1225, ((WorkingColorSpace.ToAP1[0].x) * _1224)));
        float _1252 = mad((WorkingColorSpace.ToAP1[1].z), _1226, mad((WorkingColorSpace.ToAP1[1].y), _1225, ((WorkingColorSpace.ToAP1[1].x) * _1224)));
        float _1255 = mad((WorkingColorSpace.ToAP1[2].z), _1226, mad((WorkingColorSpace.ToAP1[2].y), _1225, ((WorkingColorSpace.ToAP1[2].x) * _1224)));
        _1266 = mad(_45, _1255, mad(_44, _1252, (_1249 * _43)));
        _1267 = mad(_48, _1255, mad(_47, _1252, (_1249 * _46)));
        _1268 = mad(_51, _1255, mad(_50, _1252, (_1249 * _49)));
      } else {
        _1266 = _1224;
        _1267 = _1225;
        _1268 = _1226;
      }
      do {
        if (_1266 < 0.0031306699384003878f) {
          _1279 = (_1266 * 12.920000076293945f);
        } else {
          _1279 = (((pow(_1266, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1267 < 0.0031306699384003878f) {
            _1290 = (_1267 * 12.920000076293945f);
          } else {
            _1290 = (((pow(_1267, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1268 < 0.0031306699384003878f) {
            _2846 = _1279;
            _2847 = _1290;
            _2848 = (_1268 * 12.920000076293945f);
          } else {
            _2846 = _1279;
            _2847 = _1290;
            _2848 = (((pow(_1268, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1317 = mad((WorkingColorSpace.ToAP1[0].z), _1226, mad((WorkingColorSpace.ToAP1[0].y), _1225, ((WorkingColorSpace.ToAP1[0].x) * _1224)));
      float _1320 = mad((WorkingColorSpace.ToAP1[1].z), _1226, mad((WorkingColorSpace.ToAP1[1].y), _1225, ((WorkingColorSpace.ToAP1[1].x) * _1224)));
      float _1323 = mad((WorkingColorSpace.ToAP1[2].z), _1226, mad((WorkingColorSpace.ToAP1[2].y), _1225, ((WorkingColorSpace.ToAP1[2].x) * _1224)));
      float _1333 = max(6.103519990574569e-05f, mad(_45, _1323, mad(_44, _1320, (_1317 * _43))));
      float _1334 = max(6.103519990574569e-05f, mad(_48, _1323, mad(_47, _1320, (_1317 * _46))));
      float _1335 = max(6.103519990574569e-05f, mad(_51, _1323, mad(_50, _1320, (_1317 * _49))));
      _2846 = min((_1333 * 4.5f), ((exp2(log2(max(_1333, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2847 = min((_1334 * 4.5f), ((exp2(log2(max(_1334, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2848 = min((_1335 * 4.5f), ((exp2(log2(max(_1335, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1411 = ACESSceneColorMultiplier * _1210;
        float _1412 = ACESSceneColorMultiplier * _1211;
        float _1413 = ACESSceneColorMultiplier * _1212;
        float _1416 = mad((WorkingColorSpace.ToAP0[0].z), _1413, mad((WorkingColorSpace.ToAP0[0].y), _1412, ((WorkingColorSpace.ToAP0[0].x) * _1411)));
        float _1419 = mad((WorkingColorSpace.ToAP0[1].z), _1413, mad((WorkingColorSpace.ToAP0[1].y), _1412, ((WorkingColorSpace.ToAP0[1].x) * _1411)));
        float _1422 = mad((WorkingColorSpace.ToAP0[2].z), _1413, mad((WorkingColorSpace.ToAP0[2].y), _1412, ((WorkingColorSpace.ToAP0[2].x) * _1411)));
        float _1425 = mad(-0.21492856740951538f, _1422, mad(-0.2365107536315918f, _1419, (_1416 * 1.4514392614364624f)));
        float _1428 = mad(-0.09967592358589172f, _1422, mad(1.17622971534729f, _1419, (_1416 * -0.07655377686023712f)));
        float _1431 = mad(0.9977163076400757f, _1422, mad(-0.006032449658960104f, _1419, (_1416 * 0.008316148072481155f)));
        float _1433 = max(_1425, max(_1428, _1431));
        do {
          if (!(_1433 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1416 < 0.0f) || (bool)(_1419 < 0.0f))) || (bool)(_1422 < 0.0f))) {
              float _1443 = abs(_1433);
              float _1444 = (_1433 - _1425) / _1443;
              float _1446 = (_1433 - _1428) / _1443;
              float _1448 = (_1433 - _1431) / _1443;
              do {
                if (!(_1444 < 0.8149999976158142f)) {
                  float _1451 = _1444 + -0.8149999976158142f;
                  _1463 = ((_1451 / exp2(log2(exp2(log2(_1451 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1463 = _1444;
                }
                do {
                  if (!(_1446 < 0.8029999732971191f)) {
                    float _1466 = _1446 + -0.8029999732971191f;
                    _1478 = ((_1466 / exp2(log2(exp2(log2(_1466 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1478 = _1446;
                  }
                  do {
                    if (!(_1448 < 0.8799999952316284f)) {
                      float _1481 = _1448 + -0.8799999952316284f;
                      _1493 = ((_1481 / exp2(log2(exp2(log2(_1481 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1493 = _1448;
                    }
                    _1501 = (_1433 - (_1443 * _1463));
                    _1502 = (_1433 - (_1443 * _1478));
                    _1503 = (_1433 - (_1443 * _1493));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1501 = _1425;
              _1502 = _1428;
              _1503 = _1431;
            }
          } else {
            _1501 = _1425;
            _1502 = _1428;
            _1503 = _1431;
          }
          float _1519 = ((mad(0.16386906802654266f, _1503, mad(0.14067870378494263f, _1502, (_1501 * 0.6954522132873535f))) - _1416) * ACESGamutCompression) + _1416;
          float _1520 = ((mad(0.0955343171954155f, _1503, mad(0.8596711158752441f, _1502, (_1501 * 0.044794563204050064f))) - _1419) * ACESGamutCompression) + _1419;
          float _1521 = ((mad(1.0015007257461548f, _1503, mad(0.004025210160762072f, _1502, (_1501 * -0.005525882821530104f))) - _1422) * ACESGamutCompression) + _1422;
          float _1525 = max(max(_1519, _1520), _1521);
          float _1530 = (max(_1525, 1.000000013351432e-10f) - max(min(min(_1519, _1520), _1521), 1.000000013351432e-10f)) / max(_1525, 0.009999999776482582f);
          float _1543 = ((_1520 + _1519) + _1521) + (sqrt((((_1521 - _1520) * _1521) + ((_1520 - _1519) * _1520)) + ((_1519 - _1521) * _1519)) * 1.75f);
          float _1544 = _1543 * 0.3333333432674408f;
          float _1545 = _1530 + -0.4000000059604645f;
          float _1546 = _1545 * 5.0f;
          float _1550 = max((1.0f - abs(_1545 * 2.5f)), 0.0f);
          float _1561 = ((float(((int)(uint)((bool)(_1546 > 0.0f))) - ((int)(uint)((bool)(_1546 < 0.0f)))) * (1.0f - (_1550 * _1550))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1544 <= 0.0533333346247673f)) {
              if (!(_1544 >= 0.1599999964237213f)) {
                _1570 = (((0.23999999463558197f / _1543) + -0.5f) * _1561);
              } else {
                _1570 = 0.0f;
              }
            } else {
              _1570 = _1561;
            }
            float _1571 = _1570 + 1.0f;
            float _1572 = _1571 * _1519;
            float _1573 = _1571 * _1520;
            float _1574 = _1571 * _1521;
            do {
              if (!((bool)(_1572 == _1573) && (bool)(_1573 == _1574))) {
                float _1581 = ((_1572 * 2.0f) - _1573) - _1574;
                float _1584 = ((_1520 - _1521) * 1.7320507764816284f) * _1571;
                float _1586 = atan(_1584 / _1581);
                bool _1589 = (_1581 < 0.0f);
                bool _1590 = (_1581 == 0.0f);
                bool _1591 = (_1584 >= 0.0f);
                bool _1592 = (_1584 < 0.0f);
                _1603 = select((_1591 && _1590), 90.0f, select((_1592 && _1590), -90.0f, (select((_1592 && _1589), (_1586 + -3.1415927410125732f), select((_1591 && _1589), (_1586 + 3.1415927410125732f), _1586)) * 57.2957763671875f)));
              } else {
                _1603 = 0.0f;
              }
              float _1608 = min(max(select((_1603 < 0.0f), (_1603 + 360.0f), _1603), 0.0f), 360.0f);
              do {
                if (_1608 < -180.0f) {
                  _1617 = (_1608 + 360.0f);
                } else {
                  if (_1608 > 180.0f) {
                    _1617 = (_1608 + -360.0f);
                  } else {
                    _1617 = _1608;
                  }
                }
                do {
                  if ((bool)(_1617 > -67.5f) && (bool)(_1617 < 67.5f)) {
                    float _1623 = (_1617 + 67.5f) * 0.029629629105329514f;
                    int _1624 = int(_1623);
                    float _1626 = _1623 - float(_1624);
                    float _1627 = _1626 * _1626;
                    float _1628 = _1627 * _1626;
                    if (_1624 == 3) {
                      _1656 = (((0.1666666716337204f - (_1626 * 0.5f)) + (_1627 * 0.5f)) - (_1628 * 0.1666666716337204f));
                    } else {
                      if (_1624 == 2) {
                        _1656 = ((0.6666666865348816f - _1627) + (_1628 * 0.5f));
                      } else {
                        if (_1624 == 1) {
                          _1656 = (((_1628 * -0.5f) + 0.1666666716337204f) + ((_1627 + _1626) * 0.5f));
                        } else {
                          _1656 = select((_1624 == 0), (_1628 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1656 = 0.0f;
                  }
                  float _1665 = min(max(((((_1530 * 0.27000001072883606f) * (0.029999999329447746f - _1572)) * _1656) + _1572), 0.0f), 65535.0f);
                  float _1666 = min(max(_1573, 0.0f), 65535.0f);
                  float _1667 = min(max(_1574, 0.0f), 65535.0f);
                  float _1680 = min(max(mad(-0.21492856740951538f, _1667, mad(-0.2365107536315918f, _1666, (_1665 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1681 = min(max(mad(-0.09967592358589172f, _1667, mad(1.17622971534729f, _1666, (_1665 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1682 = min(max(mad(0.9977163076400757f, _1667, mad(-0.006032449658960104f, _1666, (_1665 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1683 = dot(float3(_1680, _1681, _1682), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1694 = log2(max((lerp(_1683, _1680, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1695 = _1694 * 0.3010300099849701f;
                  float _1696 = log2(ACESMinMaxData.x);
                  float _1697 = _1696 * 0.3010300099849701f;
                  do {
                    if (!(!(_1695 <= _1697))) {
                      _1766 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1704 = log2(ACESMidData.x);
                      float _1705 = _1704 * 0.3010300099849701f;
                      if ((bool)(_1695 > _1697) && (bool)(_1695 < _1705)) {
                        float _1713 = ((_1694 - _1696) * 0.9030900001525879f) / ((_1704 - _1696) * 0.3010300099849701f);
                        int _1714 = int(_1713);
                        float _1716 = _1713 - float(_1714);
                        float _1718 = _10[_1714];
                        float _1721 = _10[(_1714 + 1)];
                        float _1726 = _1718 * 0.5f;
                        _1766 = dot(float3((_1716 * _1716), _1716, 1.0f), float3(mad((_10[(_1714 + 2)]), 0.5f, mad(_1721, -1.0f, _1726)), (_1721 - _1718), mad(_1721, 0.5f, _1726)));
                      } else {
                        do {
                          if (!(!(_1695 >= _1705))) {
                            float _1735 = log2(ACESMinMaxData.z);
                            if (_1695 < (_1735 * 0.3010300099849701f)) {
                              float _1743 = ((_1694 - _1704) * 0.9030900001525879f) / ((_1735 - _1704) * 0.3010300099849701f);
                              int _1744 = int(_1743);
                              float _1746 = _1743 - float(_1744);
                              float _1748 = _11[_1744];
                              float _1751 = _11[(_1744 + 1)];
                              float _1756 = _1748 * 0.5f;
                              _1766 = dot(float3((_1746 * _1746), _1746, 1.0f), float3(mad((_11[(_1744 + 2)]), 0.5f, mad(_1751, -1.0f, _1756)), (_1751 - _1748), mad(_1751, 0.5f, _1756)));
                              break;
                            }
                          }
                          _1766 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1770 = log2(max((lerp(_1683, _1681, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1771 = _1770 * 0.3010300099849701f;
                    do {
                      if (!(!(_1771 <= _1697))) {
                        _1840 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1778 = log2(ACESMidData.x);
                        float _1779 = _1778 * 0.3010300099849701f;
                        if ((bool)(_1771 > _1697) && (bool)(_1771 < _1779)) {
                          float _1787 = ((_1770 - _1696) * 0.9030900001525879f) / ((_1778 - _1696) * 0.3010300099849701f);
                          int _1788 = int(_1787);
                          float _1790 = _1787 - float(_1788);
                          float _1792 = _10[_1788];
                          float _1795 = _10[(_1788 + 1)];
                          float _1800 = _1792 * 0.5f;
                          _1840 = dot(float3((_1790 * _1790), _1790, 1.0f), float3(mad((_10[(_1788 + 2)]), 0.5f, mad(_1795, -1.0f, _1800)), (_1795 - _1792), mad(_1795, 0.5f, _1800)));
                        } else {
                          do {
                            if (!(!(_1771 >= _1779))) {
                              float _1809 = log2(ACESMinMaxData.z);
                              if (_1771 < (_1809 * 0.3010300099849701f)) {
                                float _1817 = ((_1770 - _1778) * 0.9030900001525879f) / ((_1809 - _1778) * 0.3010300099849701f);
                                int _1818 = int(_1817);
                                float _1820 = _1817 - float(_1818);
                                float _1822 = _11[_1818];
                                float _1825 = _11[(_1818 + 1)];
                                float _1830 = _1822 * 0.5f;
                                _1840 = dot(float3((_1820 * _1820), _1820, 1.0f), float3(mad((_11[(_1818 + 2)]), 0.5f, mad(_1825, -1.0f, _1830)), (_1825 - _1822), mad(_1825, 0.5f, _1830)));
                                break;
                              }
                            }
                            _1840 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1844 = log2(max((lerp(_1683, _1682, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1845 = _1844 * 0.3010300099849701f;
                      do {
                        if (!(!(_1845 <= _1697))) {
                          _1914 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1852 = log2(ACESMidData.x);
                          float _1853 = _1852 * 0.3010300099849701f;
                          if ((bool)(_1845 > _1697) && (bool)(_1845 < _1853)) {
                            float _1861 = ((_1844 - _1696) * 0.9030900001525879f) / ((_1852 - _1696) * 0.3010300099849701f);
                            int _1862 = int(_1861);
                            float _1864 = _1861 - float(_1862);
                            float _1866 = _10[_1862];
                            float _1869 = _10[(_1862 + 1)];
                            float _1874 = _1866 * 0.5f;
                            _1914 = dot(float3((_1864 * _1864), _1864, 1.0f), float3(mad((_10[(_1862 + 2)]), 0.5f, mad(_1869, -1.0f, _1874)), (_1869 - _1866), mad(_1869, 0.5f, _1874)));
                          } else {
                            do {
                              if (!(!(_1845 >= _1853))) {
                                float _1883 = log2(ACESMinMaxData.z);
                                if (_1845 < (_1883 * 0.3010300099849701f)) {
                                  float _1891 = ((_1844 - _1852) * 0.9030900001525879f) / ((_1883 - _1852) * 0.3010300099849701f);
                                  int _1892 = int(_1891);
                                  float _1894 = _1891 - float(_1892);
                                  float _1896 = _11[_1892];
                                  float _1899 = _11[(_1892 + 1)];
                                  float _1904 = _1896 * 0.5f;
                                  _1914 = dot(float3((_1894 * _1894), _1894, 1.0f), float3(mad((_11[(_1892 + 2)]), 0.5f, mad(_1899, -1.0f, _1904)), (_1899 - _1896), mad(_1899, 0.5f, _1904)));
                                  break;
                                }
                              }
                              _1914 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1918 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1919 = (exp2(_1766 * 3.321928024291992f) - ACESMinMaxData.y) / _1918;
                        float _1921 = (exp2(_1840 * 3.321928024291992f) - ACESMinMaxData.y) / _1918;
                        float _1923 = (exp2(_1914 * 3.321928024291992f) - ACESMinMaxData.y) / _1918;
                        float _1926 = mad(0.15618768334388733f, _1923, mad(0.13400420546531677f, _1921, (_1919 * 0.6624541878700256f)));
                        float _1929 = mad(0.053689517080783844f, _1923, mad(0.6740817427635193f, _1921, (_1919 * 0.2722287178039551f)));
                        float _1932 = mad(1.0103391408920288f, _1923, mad(0.00406073359772563f, _1921, (_1919 * -0.005574649665504694f)));
                        float _1945 = min(max(mad(-0.23642469942569733f, _1932, mad(-0.32480329275131226f, _1929, (_1926 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1946 = min(max(mad(0.016756348311901093f, _1932, mad(1.6153316497802734f, _1929, (_1926 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1947 = min(max(mad(0.9883948564529419f, _1932, mad(-0.008284442126750946f, _1929, (_1926 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1950 = mad(0.15618768334388733f, _1947, mad(0.13400420546531677f, _1946, (_1945 * 0.6624541878700256f)));
                        float _1953 = mad(0.053689517080783844f, _1947, mad(0.6740817427635193f, _1946, (_1945 * 0.2722287178039551f)));
                        float _1956 = mad(1.0103391408920288f, _1947, mad(0.00406073359772563f, _1946, (_1945 * -0.005574649665504694f)));
                        float _1978 = min(max((min(max(mad(-0.23642469942569733f, _1956, mad(-0.32480329275131226f, _1953, (_1950 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1979 = min(max((min(max(mad(0.016756348311901093f, _1956, mad(1.6153316497802734f, _1953, (_1950 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1980 = min(max((min(max(mad(0.9883948564529419f, _1956, mad(-0.008284442126750946f, _1953, (_1950 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 5)) {
                            _1993 = mad(_45, _1980, mad(_44, _1979, (_1978 * _43)));
                            _1994 = mad(_48, _1980, mad(_47, _1979, (_1978 * _46)));
                            _1995 = mad(_51, _1980, mad(_50, _1979, (_1978 * _49)));
                          } else {
                            _1993 = _1978;
                            _1994 = _1979;
                            _1995 = _1980;
                          }
                          float _2005 = exp2(log2(_1993 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2006 = exp2(log2(_1994 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2007 = exp2(log2(_1995 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2846 = exp2(log2((1.0f / ((_2005 * 18.6875f) + 1.0f)) * ((_2005 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2847 = exp2(log2((1.0f / ((_2006 * 18.6875f) + 1.0f)) * ((_2006 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2848 = exp2(log2((1.0f / ((_2007 * 18.6875f) + 1.0f)) * ((_2007 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2085 = ACESSceneColorMultiplier * _1210;
          float _2086 = ACESSceneColorMultiplier * _1211;
          float _2087 = ACESSceneColorMultiplier * _1212;
          float _2090 = mad((WorkingColorSpace.ToAP0[0].z), _2087, mad((WorkingColorSpace.ToAP0[0].y), _2086, ((WorkingColorSpace.ToAP0[0].x) * _2085)));
          float _2093 = mad((WorkingColorSpace.ToAP0[1].z), _2087, mad((WorkingColorSpace.ToAP0[1].y), _2086, ((WorkingColorSpace.ToAP0[1].x) * _2085)));
          float _2096 = mad((WorkingColorSpace.ToAP0[2].z), _2087, mad((WorkingColorSpace.ToAP0[2].y), _2086, ((WorkingColorSpace.ToAP0[2].x) * _2085)));
          float _2099 = mad(-0.21492856740951538f, _2096, mad(-0.2365107536315918f, _2093, (_2090 * 1.4514392614364624f)));
          float _2102 = mad(-0.09967592358589172f, _2096, mad(1.17622971534729f, _2093, (_2090 * -0.07655377686023712f)));
          float _2105 = mad(0.9977163076400757f, _2096, mad(-0.006032449658960104f, _2093, (_2090 * 0.008316148072481155f)));
          float _2107 = max(_2099, max(_2102, _2105));
          do {
            if (!(_2107 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2090 < 0.0f) || (bool)(_2093 < 0.0f))) || (bool)(_2096 < 0.0f))) {
                float _2117 = abs(_2107);
                float _2118 = (_2107 - _2099) / _2117;
                float _2120 = (_2107 - _2102) / _2117;
                float _2122 = (_2107 - _2105) / _2117;
                do {
                  if (!(_2118 < 0.8149999976158142f)) {
                    float _2125 = _2118 + -0.8149999976158142f;
                    _2137 = ((_2125 / exp2(log2(exp2(log2(_2125 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2137 = _2118;
                  }
                  do {
                    if (!(_2120 < 0.8029999732971191f)) {
                      float _2140 = _2120 + -0.8029999732971191f;
                      _2152 = ((_2140 / exp2(log2(exp2(log2(_2140 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2152 = _2120;
                    }
                    do {
                      if (!(_2122 < 0.8799999952316284f)) {
                        float _2155 = _2122 + -0.8799999952316284f;
                        _2167 = ((_2155 / exp2(log2(exp2(log2(_2155 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2167 = _2122;
                      }
                      _2175 = (_2107 - (_2117 * _2137));
                      _2176 = (_2107 - (_2117 * _2152));
                      _2177 = (_2107 - (_2117 * _2167));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2175 = _2099;
                _2176 = _2102;
                _2177 = _2105;
              }
            } else {
              _2175 = _2099;
              _2176 = _2102;
              _2177 = _2105;
            }
            float _2193 = ((mad(0.16386906802654266f, _2177, mad(0.14067870378494263f, _2176, (_2175 * 0.6954522132873535f))) - _2090) * ACESGamutCompression) + _2090;
            float _2194 = ((mad(0.0955343171954155f, _2177, mad(0.8596711158752441f, _2176, (_2175 * 0.044794563204050064f))) - _2093) * ACESGamutCompression) + _2093;
            float _2195 = ((mad(1.0015007257461548f, _2177, mad(0.004025210160762072f, _2176, (_2175 * -0.005525882821530104f))) - _2096) * ACESGamutCompression) + _2096;
            float _2199 = max(max(_2193, _2194), _2195);
            float _2204 = (max(_2199, 1.000000013351432e-10f) - max(min(min(_2193, _2194), _2195), 1.000000013351432e-10f)) / max(_2199, 0.009999999776482582f);
            float _2217 = ((_2194 + _2193) + _2195) + (sqrt((((_2195 - _2194) * _2195) + ((_2194 - _2193) * _2194)) + ((_2193 - _2195) * _2193)) * 1.75f);
            float _2218 = _2217 * 0.3333333432674408f;
            float _2219 = _2204 + -0.4000000059604645f;
            float _2220 = _2219 * 5.0f;
            float _2224 = max((1.0f - abs(_2219 * 2.5f)), 0.0f);
            float _2235 = ((float(((int)(uint)((bool)(_2220 > 0.0f))) - ((int)(uint)((bool)(_2220 < 0.0f)))) * (1.0f - (_2224 * _2224))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2218 <= 0.0533333346247673f)) {
                if (!(_2218 >= 0.1599999964237213f)) {
                  _2244 = (((0.23999999463558197f / _2217) + -0.5f) * _2235);
                } else {
                  _2244 = 0.0f;
                }
              } else {
                _2244 = _2235;
              }
              float _2245 = _2244 + 1.0f;
              float _2246 = _2245 * _2193;
              float _2247 = _2245 * _2194;
              float _2248 = _2245 * _2195;
              do {
                if (!((bool)(_2246 == _2247) && (bool)(_2247 == _2248))) {
                  float _2255 = ((_2246 * 2.0f) - _2247) - _2248;
                  float _2258 = ((_2194 - _2195) * 1.7320507764816284f) * _2245;
                  float _2260 = atan(_2258 / _2255);
                  bool _2263 = (_2255 < 0.0f);
                  bool _2264 = (_2255 == 0.0f);
                  bool _2265 = (_2258 >= 0.0f);
                  bool _2266 = (_2258 < 0.0f);
                  _2277 = select((_2265 && _2264), 90.0f, select((_2266 && _2264), -90.0f, (select((_2266 && _2263), (_2260 + -3.1415927410125732f), select((_2265 && _2263), (_2260 + 3.1415927410125732f), _2260)) * 57.2957763671875f)));
                } else {
                  _2277 = 0.0f;
                }
                float _2282 = min(max(select((_2277 < 0.0f), (_2277 + 360.0f), _2277), 0.0f), 360.0f);
                do {
                  if (_2282 < -180.0f) {
                    _2291 = (_2282 + 360.0f);
                  } else {
                    if (_2282 > 180.0f) {
                      _2291 = (_2282 + -360.0f);
                    } else {
                      _2291 = _2282;
                    }
                  }
                  do {
                    if ((bool)(_2291 > -67.5f) && (bool)(_2291 < 67.5f)) {
                      float _2297 = (_2291 + 67.5f) * 0.029629629105329514f;
                      int _2298 = int(_2297);
                      float _2300 = _2297 - float(_2298);
                      float _2301 = _2300 * _2300;
                      float _2302 = _2301 * _2300;
                      if (_2298 == 3) {
                        _2330 = (((0.1666666716337204f - (_2300 * 0.5f)) + (_2301 * 0.5f)) - (_2302 * 0.1666666716337204f));
                      } else {
                        if (_2298 == 2) {
                          _2330 = ((0.6666666865348816f - _2301) + (_2302 * 0.5f));
                        } else {
                          if (_2298 == 1) {
                            _2330 = (((_2302 * -0.5f) + 0.1666666716337204f) + ((_2301 + _2300) * 0.5f));
                          } else {
                            _2330 = select((_2298 == 0), (_2302 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2330 = 0.0f;
                    }
                    float _2339 = min(max(((((_2204 * 0.27000001072883606f) * (0.029999999329447746f - _2246)) * _2330) + _2246), 0.0f), 65535.0f);
                    float _2340 = min(max(_2247, 0.0f), 65535.0f);
                    float _2341 = min(max(_2248, 0.0f), 65535.0f);
                    float _2354 = min(max(mad(-0.21492856740951538f, _2341, mad(-0.2365107536315918f, _2340, (_2339 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2355 = min(max(mad(-0.09967592358589172f, _2341, mad(1.17622971534729f, _2340, (_2339 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2356 = min(max(mad(0.9977163076400757f, _2341, mad(-0.006032449658960104f, _2340, (_2339 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2357 = dot(float3(_2354, _2355, _2356), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2368 = log2(max((lerp(_2357, _2354, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2369 = _2368 * 0.3010300099849701f;
                    float _2370 = log2(ACESMinMaxData.x);
                    float _2371 = _2370 * 0.3010300099849701f;
                    do {
                      if (!(!(_2369 <= _2371))) {
                        _2440 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2378 = log2(ACESMidData.x);
                        float _2379 = _2378 * 0.3010300099849701f;
                        if ((bool)(_2369 > _2371) && (bool)(_2369 < _2379)) {
                          float _2387 = ((_2368 - _2370) * 0.9030900001525879f) / ((_2378 - _2370) * 0.3010300099849701f);
                          int _2388 = int(_2387);
                          float _2390 = _2387 - float(_2388);
                          float _2392 = _8[_2388];
                          float _2395 = _8[(_2388 + 1)];
                          float _2400 = _2392 * 0.5f;
                          _2440 = dot(float3((_2390 * _2390), _2390, 1.0f), float3(mad((_8[(_2388 + 2)]), 0.5f, mad(_2395, -1.0f, _2400)), (_2395 - _2392), mad(_2395, 0.5f, _2400)));
                        } else {
                          do {
                            if (!(!(_2369 >= _2379))) {
                              float _2409 = log2(ACESMinMaxData.z);
                              if (_2369 < (_2409 * 0.3010300099849701f)) {
                                float _2417 = ((_2368 - _2378) * 0.9030900001525879f) / ((_2409 - _2378) * 0.3010300099849701f);
                                int _2418 = int(_2417);
                                float _2420 = _2417 - float(_2418);
                                float _2422 = _9[_2418];
                                float _2425 = _9[(_2418 + 1)];
                                float _2430 = _2422 * 0.5f;
                                _2440 = dot(float3((_2420 * _2420), _2420, 1.0f), float3(mad((_9[(_2418 + 2)]), 0.5f, mad(_2425, -1.0f, _2430)), (_2425 - _2422), mad(_2425, 0.5f, _2430)));
                                break;
                              }
                            }
                            _2440 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2444 = log2(max((lerp(_2357, _2355, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2445 = _2444 * 0.3010300099849701f;
                      do {
                        if (!(!(_2445 <= _2371))) {
                          _2514 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2452 = log2(ACESMidData.x);
                          float _2453 = _2452 * 0.3010300099849701f;
                          if ((bool)(_2445 > _2371) && (bool)(_2445 < _2453)) {
                            float _2461 = ((_2444 - _2370) * 0.9030900001525879f) / ((_2452 - _2370) * 0.3010300099849701f);
                            int _2462 = int(_2461);
                            float _2464 = _2461 - float(_2462);
                            float _2466 = _8[_2462];
                            float _2469 = _8[(_2462 + 1)];
                            float _2474 = _2466 * 0.5f;
                            _2514 = dot(float3((_2464 * _2464), _2464, 1.0f), float3(mad((_8[(_2462 + 2)]), 0.5f, mad(_2469, -1.0f, _2474)), (_2469 - _2466), mad(_2469, 0.5f, _2474)));
                          } else {
                            do {
                              if (!(!(_2445 >= _2453))) {
                                float _2483 = log2(ACESMinMaxData.z);
                                if (_2445 < (_2483 * 0.3010300099849701f)) {
                                  float _2491 = ((_2444 - _2452) * 0.9030900001525879f) / ((_2483 - _2452) * 0.3010300099849701f);
                                  int _2492 = int(_2491);
                                  float _2494 = _2491 - float(_2492);
                                  float _2496 = _9[_2492];
                                  float _2499 = _9[(_2492 + 1)];
                                  float _2504 = _2496 * 0.5f;
                                  _2514 = dot(float3((_2494 * _2494), _2494, 1.0f), float3(mad((_9[(_2492 + 2)]), 0.5f, mad(_2499, -1.0f, _2504)), (_2499 - _2496), mad(_2499, 0.5f, _2504)));
                                  break;
                                }
                              }
                              _2514 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2518 = log2(max((lerp(_2357, _2356, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2519 = _2518 * 0.3010300099849701f;
                        do {
                          if (!(!(_2519 <= _2371))) {
                            _2588 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2526 = log2(ACESMidData.x);
                            float _2527 = _2526 * 0.3010300099849701f;
                            if ((bool)(_2519 > _2371) && (bool)(_2519 < _2527)) {
                              float _2535 = ((_2518 - _2370) * 0.9030900001525879f) / ((_2526 - _2370) * 0.3010300099849701f);
                              int _2536 = int(_2535);
                              float _2538 = _2535 - float(_2536);
                              float _2540 = _8[_2536];
                              float _2543 = _8[(_2536 + 1)];
                              float _2548 = _2540 * 0.5f;
                              _2588 = dot(float3((_2538 * _2538), _2538, 1.0f), float3(mad((_8[(_2536 + 2)]), 0.5f, mad(_2543, -1.0f, _2548)), (_2543 - _2540), mad(_2543, 0.5f, _2548)));
                            } else {
                              do {
                                if (!(!(_2519 >= _2527))) {
                                  float _2557 = log2(ACESMinMaxData.z);
                                  if (_2519 < (_2557 * 0.3010300099849701f)) {
                                    float _2565 = ((_2518 - _2526) * 0.9030900001525879f) / ((_2557 - _2526) * 0.3010300099849701f);
                                    int _2566 = int(_2565);
                                    float _2568 = _2565 - float(_2566);
                                    float _2570 = _9[_2566];
                                    float _2573 = _9[(_2566 + 1)];
                                    float _2578 = _2570 * 0.5f;
                                    _2588 = dot(float3((_2568 * _2568), _2568, 1.0f), float3(mad((_9[(_2566 + 2)]), 0.5f, mad(_2573, -1.0f, _2578)), (_2573 - _2570), mad(_2573, 0.5f, _2578)));
                                    break;
                                  }
                                }
                                _2588 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2592 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2593 = (exp2(_2440 * 3.321928024291992f) - ACESMinMaxData.y) / _2592;
                          float _2595 = (exp2(_2514 * 3.321928024291992f) - ACESMinMaxData.y) / _2592;
                          float _2597 = (exp2(_2588 * 3.321928024291992f) - ACESMinMaxData.y) / _2592;
                          float _2600 = mad(0.15618768334388733f, _2597, mad(0.13400420546531677f, _2595, (_2593 * 0.6624541878700256f)));
                          float _2603 = mad(0.053689517080783844f, _2597, mad(0.6740817427635193f, _2595, (_2593 * 0.2722287178039551f)));
                          float _2606 = mad(1.0103391408920288f, _2597, mad(0.00406073359772563f, _2595, (_2593 * -0.005574649665504694f)));
                          float _2619 = min(max(mad(-0.23642469942569733f, _2606, mad(-0.32480329275131226f, _2603, (_2600 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2620 = min(max(mad(0.016756348311901093f, _2606, mad(1.6153316497802734f, _2603, (_2600 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2621 = min(max(mad(0.9883948564529419f, _2606, mad(-0.008284442126750946f, _2603, (_2600 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2624 = mad(0.15618768334388733f, _2621, mad(0.13400420546531677f, _2620, (_2619 * 0.6624541878700256f)));
                          float _2627 = mad(0.053689517080783844f, _2621, mad(0.6740817427635193f, _2620, (_2619 * 0.2722287178039551f)));
                          float _2630 = mad(1.0103391408920288f, _2621, mad(0.00406073359772563f, _2620, (_2619 * -0.005574649665504694f)));
                          float _2652 = min(max((min(max(mad(-0.23642469942569733f, _2630, mad(-0.32480329275131226f, _2627, (_2624 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2653 = min(max((min(max(mad(0.016756348311901093f, _2630, mad(1.6153316497802734f, _2627, (_2624 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2654 = min(max((min(max(mad(0.9883948564529419f, _2630, mad(-0.008284442126750946f, _2627, (_2624 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(OutputDevice == 6)) {
                              _2667 = mad(_45, _2654, mad(_44, _2653, (_2652 * _43)));
                              _2668 = mad(_48, _2654, mad(_47, _2653, (_2652 * _46)));
                              _2669 = mad(_51, _2654, mad(_50, _2653, (_2652 * _49)));
                            } else {
                              _2667 = _2652;
                              _2668 = _2653;
                              _2669 = _2654;
                            }
                            float _2679 = exp2(log2(_2667 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2680 = exp2(log2(_2668 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2681 = exp2(log2(_2669 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2846 = exp2(log2((1.0f / ((_2679 * 18.6875f) + 1.0f)) * ((_2679 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2847 = exp2(log2((1.0f / ((_2680 * 18.6875f) + 1.0f)) * ((_2680 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2848 = exp2(log2((1.0f / ((_2681 * 18.6875f) + 1.0f)) * ((_2681 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2726 = mad((WorkingColorSpace.ToAP1[0].z), _1212, mad((WorkingColorSpace.ToAP1[0].y), _1211, ((WorkingColorSpace.ToAP1[0].x) * _1210)));
            float _2729 = mad((WorkingColorSpace.ToAP1[1].z), _1212, mad((WorkingColorSpace.ToAP1[1].y), _1211, ((WorkingColorSpace.ToAP1[1].x) * _1210)));
            float _2732 = mad((WorkingColorSpace.ToAP1[2].z), _1212, mad((WorkingColorSpace.ToAP1[2].y), _1211, ((WorkingColorSpace.ToAP1[2].x) * _1210)));
            float _2751 = exp2(log2(mad(_45, _2732, mad(_44, _2729, (_2726 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2752 = exp2(log2(mad(_48, _2732, mad(_47, _2729, (_2726 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2753 = exp2(log2(mad(_51, _2732, mad(_50, _2729, (_2726 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2846 = exp2(log2((1.0f / ((_2751 * 18.6875f) + 1.0f)) * ((_2751 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2847 = exp2(log2((1.0f / ((_2752 * 18.6875f) + 1.0f)) * ((_2752 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2848 = exp2(log2((1.0f / ((_2753 * 18.6875f) + 1.0f)) * ((_2753 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2800 = mad((WorkingColorSpace.ToAP1[0].z), _1200, mad((WorkingColorSpace.ToAP1[0].y), _1199, ((WorkingColorSpace.ToAP1[0].x) * _1198)));
                float _2803 = mad((WorkingColorSpace.ToAP1[1].z), _1200, mad((WorkingColorSpace.ToAP1[1].y), _1199, ((WorkingColorSpace.ToAP1[1].x) * _1198)));
                float _2806 = mad((WorkingColorSpace.ToAP1[2].z), _1200, mad((WorkingColorSpace.ToAP1[2].y), _1199, ((WorkingColorSpace.ToAP1[2].x) * _1198)));
                _2846 = mad(_45, _2806, mad(_44, _2803, (_2800 * _43)));
                _2847 = mad(_48, _2806, mad(_47, _2803, (_2800 * _46)));
                _2848 = mad(_51, _2806, mad(_50, _2803, (_2800 * _49)));
              } else {
                float _2819 = mad((WorkingColorSpace.ToAP1[0].z), _1226, mad((WorkingColorSpace.ToAP1[0].y), _1225, ((WorkingColorSpace.ToAP1[0].x) * _1224)));
                float _2822 = mad((WorkingColorSpace.ToAP1[1].z), _1226, mad((WorkingColorSpace.ToAP1[1].y), _1225, ((WorkingColorSpace.ToAP1[1].x) * _1224)));
                float _2825 = mad((WorkingColorSpace.ToAP1[2].z), _1226, mad((WorkingColorSpace.ToAP1[2].y), _1225, ((WorkingColorSpace.ToAP1[2].x) * _1224)));
                _2846 = exp2(log2(mad(_45, _2825, mad(_44, _2822, (_2819 * _43)))) * InverseGamma.z);
                _2847 = exp2(log2(mad(_48, _2825, mad(_47, _2822, (_2819 * _46)))) * InverseGamma.z);
                _2848 = exp2(log2(mad(_51, _2825, mad(_50, _2822, (_2819 * _49)))) * InverseGamma.z);
              }
            } else {
              _2846 = _1210;
              _2847 = _1211;
              _2848 = _1212;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2846 * 0.9523810148239136f);
  SV_Target.y = (_2847 * 0.9523810148239136f);
  SV_Target.z = (_2848 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

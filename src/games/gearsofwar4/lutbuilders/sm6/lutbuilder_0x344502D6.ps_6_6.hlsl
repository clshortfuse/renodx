// Found in Until Dawn

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
  float OutputMinLum : packoffset(c042.x);
  float OutputMaxLum : packoffset(c042.y);
  float OutputSceneGamma : packoffset(c042.z);
  float UCPExposureAdjust : packoffset(c042.w);
  uint SDROutputTransfer : packoffset(c043.x);
  float UCPGradeShadowCutoff : packoffset(c043.y);
  float UCPGradeShadowGamma : packoffset(c043.z);
  uint UCPSDRDisplayMapVersion : packoffset(c043.w);
};

cbuffer UniformBufferConstants_WorkingColorSpace : register(b1) {
  float4 WorkingColorSpace_ToXYZ[4] : packoffset(c000.x);
  float4 WorkingColorSpace_FromXYZ[4] : packoffset(c004.x);
  float4 WorkingColorSpace_ToAP1[4] : packoffset(c008.x);
  float4 WorkingColorSpace_FromAP1[4] : packoffset(c012.x);
  float4 WorkingColorSpace_ToAP0[4] : packoffset(c016.x);
  uint WorkingColorSpace_bIsSRGB : packoffset(c020.x);
};

static const float _global_0[6] = { -4.0f, -4.0f, -3.157376527786255f, -0.48524999618530273f, 1.8477325439453125f, 1.8477325439453125f };
static const float _global_1[6] = { -0.718548059463501f, 2.08103084564209f, 3.668123960494995f, 4.0f, 4.0f, 4.0f };

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
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
  float _1470;
  float _1503;
  float _1517;
  float _1556;
  float _1666;
  float _1740;
  float _1814;
  float _1893;
  float _1894;
  float _1895;
  float _2044;
  float _2077;
  float _2091;
  float _2130;
  float _2240;
  float _2314;
  float _2388;
  float _2467;
  float _2468;
  float _2469;
  float _2637;
  float _2706;
  float _2739;
  float _2753;
  float _2792;
  float _2884;
  float _2942;
  float _3000;
  float _3054;
  float _3066;
  float _3078;
  float _3098;
  float _3137;
  float _3192;
  float _3203;
  float _3214;
  float _3215;
  float _3216;
  float _3251;
  float _3320;
  float _3353;
  float _3367;
  float _3406;
  float _3498;
  float _3556;
  float _3614;
  float _3736;
  float _3890;
  float _3891;
  float _3892;
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
  float _304 = mad(_283, (WorkingColorSpace_ToXYZ[2].x), mad(_280, (WorkingColorSpace_ToXYZ[1].x), (_277 * (WorkingColorSpace_ToXYZ[0].x))));
  float _307 = mad(_283, (WorkingColorSpace_ToXYZ[2].y), mad(_280, (WorkingColorSpace_ToXYZ[1].y), (_277 * (WorkingColorSpace_ToXYZ[0].y))));
  float _310 = mad(_283, (WorkingColorSpace_ToXYZ[2].z), mad(_280, (WorkingColorSpace_ToXYZ[1].z), (_277 * (WorkingColorSpace_ToXYZ[0].z))));
  float _313 = mad(_292, (WorkingColorSpace_ToXYZ[2].x), mad(_289, (WorkingColorSpace_ToXYZ[1].x), (_286 * (WorkingColorSpace_ToXYZ[0].x))));
  float _316 = mad(_292, (WorkingColorSpace_ToXYZ[2].y), mad(_289, (WorkingColorSpace_ToXYZ[1].y), (_286 * (WorkingColorSpace_ToXYZ[0].y))));
  float _319 = mad(_292, (WorkingColorSpace_ToXYZ[2].z), mad(_289, (WorkingColorSpace_ToXYZ[1].z), (_286 * (WorkingColorSpace_ToXYZ[0].z))));
  float _322 = mad(_301, (WorkingColorSpace_ToXYZ[2].x), mad(_298, (WorkingColorSpace_ToXYZ[1].x), (_295 * (WorkingColorSpace_ToXYZ[0].x))));
  float _325 = mad(_301, (WorkingColorSpace_ToXYZ[2].y), mad(_298, (WorkingColorSpace_ToXYZ[1].y), (_295 * (WorkingColorSpace_ToXYZ[0].y))));
  float _328 = mad(_301, (WorkingColorSpace_ToXYZ[2].z), mad(_298, (WorkingColorSpace_ToXYZ[1].z), (_295 * (WorkingColorSpace_ToXYZ[0].z))));
  float _358 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _328, mad((WorkingColorSpace_FromXYZ[0].y), _319, (_310 * (WorkingColorSpace_FromXYZ[0].x)))), _111, mad(mad((WorkingColorSpace_FromXYZ[0].z), _325, mad((WorkingColorSpace_FromXYZ[0].y), _316, (_307 * (WorkingColorSpace_FromXYZ[0].x)))), _110, (mad((WorkingColorSpace_FromXYZ[0].z), _322, mad((WorkingColorSpace_FromXYZ[0].y), _313, (_304 * (WorkingColorSpace_FromXYZ[0].x)))) * _109)));
  float _361 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _328, mad((WorkingColorSpace_FromXYZ[1].y), _319, (_310 * (WorkingColorSpace_FromXYZ[1].x)))), _111, mad(mad((WorkingColorSpace_FromXYZ[1].z), _325, mad((WorkingColorSpace_FromXYZ[1].y), _316, (_307 * (WorkingColorSpace_FromXYZ[1].x)))), _110, (mad((WorkingColorSpace_FromXYZ[1].z), _322, mad((WorkingColorSpace_FromXYZ[1].y), _313, (_304 * (WorkingColorSpace_FromXYZ[1].x)))) * _109)));
  float _364 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _328, mad((WorkingColorSpace_FromXYZ[2].y), _319, (_310 * (WorkingColorSpace_FromXYZ[2].x)))), _111, mad(mad((WorkingColorSpace_FromXYZ[2].z), _325, mad((WorkingColorSpace_FromXYZ[2].y), _316, (_307 * (WorkingColorSpace_FromXYZ[2].x)))), _110, (mad((WorkingColorSpace_FromXYZ[2].z), _322, mad((WorkingColorSpace_FromXYZ[2].y), _313, (_304 * (WorkingColorSpace_FromXYZ[2].x)))) * _109)));
  float _379 = mad((WorkingColorSpace_ToAP1[0].z), _364, mad((WorkingColorSpace_ToAP1[0].y), _361, ((WorkingColorSpace_ToAP1[0].x) * _358)));
  float _382 = mad((WorkingColorSpace_ToAP1[1].z), _364, mad((WorkingColorSpace_ToAP1[1].y), _361, ((WorkingColorSpace_ToAP1[1].x) * _358)));
  float _385 = mad((WorkingColorSpace_ToAP1[2].z), _364, mad((WorkingColorSpace_ToAP1[2].y), _361, ((WorkingColorSpace_ToAP1[2].x) * _358)));
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
  float _878 = ((float((int)(((int)(uint)((bool)(_863 > 0.0f))) - ((int)(uint)((bool)(_863 < 0.0f))))) * (1.0f - (_867 * _867))) + 1.0f) * 0.02500000037252903f;
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

  float _1161 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1151, mad((WorkingColorSpace_FromAP1[0].y), _1150, ((WorkingColorSpace_FromAP1[0].x) * _1149))));
  float _1162 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1151, mad((WorkingColorSpace_FromAP1[1].y), _1150, ((WorkingColorSpace_FromAP1[1].x) * _1149))));
  float _1163 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1151, mad((WorkingColorSpace_FromAP1[2].y), _1150, ((WorkingColorSpace_FromAP1[2].x) * _1149))));
  float _1189 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1161)) * _1161) + MappingPolynomial.z);
  float _1190 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1162)) * _1162) + MappingPolynomial.z);
  float _1191 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1163)) * _1163) + MappingPolynomial.z);
  float _1198 = ((OverlayColor.x - _1189) * OverlayColor.w) + _1189;
  float _1199 = ((OverlayColor.y - _1190) * OverlayColor.w) + _1190;
  float _1200 = ((OverlayColor.z - _1191) * OverlayColor.w) + _1191;
  float _1201 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _791, mad((WorkingColorSpace_FromAP1[0].y), _789, (_787 * (WorkingColorSpace_FromAP1[0].x))));
  float _1202 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _791, mad((WorkingColorSpace_FromAP1[1].y), _789, ((WorkingColorSpace_FromAP1[1].x) * _787)));
  float _1203 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _791, mad((WorkingColorSpace_FromAP1[2].y), _789, ((WorkingColorSpace_FromAP1[2].x) * _787)));
  float _1210 = ((OverlayColor.x - _1201) * OverlayColor.w) + _1201;
  float _1211 = ((OverlayColor.y - _1202) * OverlayColor.w) + _1202;
  float _1212 = ((OverlayColor.z - _1203) * OverlayColor.w) + _1203;
  float _1224 = exp2(log2(max(0.0f, _1198)) * InverseGamma.y);
  float _1225 = exp2(log2(max(0.0f, _1199)) * InverseGamma.y);
  float _1226 = exp2(log2(max(0.0f, _1200)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return GenerateOutput(float3(_1224, _1225, _1226), OutputDevice);
  }

  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace_bIsSRGB == 0) {
        float _1249 = mad((WorkingColorSpace_ToAP1[0].z), _1226, mad((WorkingColorSpace_ToAP1[0].y), _1225, ((WorkingColorSpace_ToAP1[0].x) * _1224)));
        float _1252 = mad((WorkingColorSpace_ToAP1[1].z), _1226, mad((WorkingColorSpace_ToAP1[1].y), _1225, ((WorkingColorSpace_ToAP1[1].x) * _1224)));
        float _1255 = mad((WorkingColorSpace_ToAP1[2].z), _1226, mad((WorkingColorSpace_ToAP1[2].y), _1225, ((WorkingColorSpace_ToAP1[2].x) * _1224)));
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
            _3890 = _1279;
            _3891 = _1290;
            _3892 = (_1268 * 12.920000076293945f);
          } else {
            _3890 = _1279;
            _3891 = _1290;
            _3892 = (((pow(_1268, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1317 = mad((WorkingColorSpace_ToAP1[0].z), _1226, mad((WorkingColorSpace_ToAP1[0].y), _1225, ((WorkingColorSpace_ToAP1[0].x) * _1224)));
      float _1320 = mad((WorkingColorSpace_ToAP1[1].z), _1226, mad((WorkingColorSpace_ToAP1[1].y), _1225, ((WorkingColorSpace_ToAP1[1].x) * _1224)));
      float _1323 = mad((WorkingColorSpace_ToAP1[2].z), _1226, mad((WorkingColorSpace_ToAP1[2].y), _1225, ((WorkingColorSpace_ToAP1[2].x) * _1224)));
      float _1333 = max(6.103519990574569e-05f, mad(_45, _1323, mad(_44, _1320, (_1317 * _43))));
      float _1334 = max(6.103519990574569e-05f, mad(_48, _1323, mad(_47, _1320, (_1317 * _46))));
      float _1335 = max(6.103519990574569e-05f, mad(_51, _1323, mad(_50, _1320, (_1317 * _49))));
      _3890 = min((_1333 * 4.5f), ((exp2(log2(max(_1333, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3891 = min((_1334 * 4.5f), ((exp2(log2(max(_1334, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3892 = min((_1335 * 4.5f), ((exp2(log2(max(_1335, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        float _1410 = ACESSceneColorMultiplier * _1210;
        float _1411 = ACESSceneColorMultiplier * _1211;
        float _1412 = ACESSceneColorMultiplier * _1212;
        float _1415 = mad((WorkingColorSpace_ToAP0[0].z), _1412, mad((WorkingColorSpace_ToAP0[0].y), _1411, ((WorkingColorSpace_ToAP0[0].x) * _1410)));
        float _1418 = mad((WorkingColorSpace_ToAP0[1].z), _1412, mad((WorkingColorSpace_ToAP0[1].y), _1411, ((WorkingColorSpace_ToAP0[1].x) * _1410)));
        float _1421 = mad((WorkingColorSpace_ToAP0[2].z), _1412, mad((WorkingColorSpace_ToAP0[2].y), _1411, ((WorkingColorSpace_ToAP0[2].x) * _1410)));
        float _1425 = max(max(_1415, _1418), _1421);
        float _1430 = (max(_1425, 1.000000013351432e-10f) - max(min(min(_1415, _1418), _1421), 1.000000013351432e-10f)) / max(_1425, 0.009999999776482582f);
        float _1443 = ((_1418 + _1415) + _1421) + (sqrt((((_1421 - _1418) * _1421) + ((_1418 - _1415) * _1418)) + ((_1415 - _1421) * _1415)) * 1.75f);
        float _1444 = _1443 * 0.3333333432674408f;
        float _1445 = _1430 + -0.4000000059604645f;
        float _1446 = _1445 * 5.0f;
        float _1450 = max((1.0f - abs(_1445 * 2.5f)), 0.0f);
        float _1461 = ((float((int)(((int)(uint)((bool)(_1446 > 0.0f))) - ((int)(uint)((bool)(_1446 < 0.0f))))) * (1.0f - (_1450 * _1450))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1444 <= 0.0533333346247673f)) {
            if (!(_1444 >= 0.1599999964237213f)) {
              _1470 = (((0.23999999463558197f / _1443) + -0.5f) * _1461);
            } else {
              _1470 = 0.0f;
            }
          } else {
            _1470 = _1461;
          }
          float _1471 = _1470 + 1.0f;
          float _1472 = _1471 * _1415;
          float _1473 = _1471 * _1418;
          float _1474 = _1471 * _1421;
          do {
            if (!((bool)(_1472 == _1473) && (bool)(_1473 == _1474))) {
              float _1481 = ((_1472 * 2.0f) - _1473) - _1474;
              float _1484 = ((_1418 - _1421) * 1.7320507764816284f) * _1471;
              float _1486 = atan(_1484 / _1481);
              bool _1489 = (_1481 < 0.0f);
              bool _1490 = (_1481 == 0.0f);
              bool _1491 = (_1484 >= 0.0f);
              bool _1492 = (_1484 < 0.0f);
              _1503 = select((_1491 && _1490), 90.0f, select((_1492 && _1490), -90.0f, (select((_1492 && _1489), (_1486 + -3.1415927410125732f), select((_1491 && _1489), (_1486 + 3.1415927410125732f), _1486)) * 57.2957763671875f)));
            } else {
              _1503 = 0.0f;
            }
            float _1508 = min(max(select((_1503 < 0.0f), (_1503 + 360.0f), _1503), 0.0f), 360.0f);
            do {
              if (_1508 < -180.0f) {
                _1517 = (_1508 + 360.0f);
              } else {
                if (_1508 > 180.0f) {
                  _1517 = (_1508 + -360.0f);
                } else {
                  _1517 = _1508;
                }
              }
              do {
                if ((bool)(_1517 > -67.5f) && (bool)(_1517 < 67.5f)) {
                  float _1523 = (_1517 + 67.5f) * 0.029629629105329514f;
                  int _1524 = int(_1523);
                  float _1526 = _1523 - float((int)(_1524));
                  float _1527 = _1526 * _1526;
                  float _1528 = _1527 * _1526;
                  if (_1524 == 3) {
                    _1556 = (((0.1666666716337204f - (_1526 * 0.5f)) + (_1527 * 0.5f)) - (_1528 * 0.1666666716337204f));
                  } else {
                    if (_1524 == 2) {
                      _1556 = ((0.6666666865348816f - _1527) + (_1528 * 0.5f));
                    } else {
                      if (_1524 == 1) {
                        _1556 = (((_1528 * -0.5f) + 0.1666666716337204f) + ((_1527 + _1526) * 0.5f));
                      } else {
                        _1556 = select((_1524 == 0), (_1528 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1556 = 0.0f;
                }
                float _1565 = min(max(((((_1430 * 0.27000001072883606f) * (0.029999999329447746f - _1472)) * _1556) + _1472), 0.0f), 65535.0f);
                float _1566 = min(max(_1473, 0.0f), 65535.0f);
                float _1567 = min(max(_1474, 0.0f), 65535.0f);
                float _1580 = min(max(mad(-0.21492856740951538f, _1567, mad(-0.2365107536315918f, _1566, (_1565 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1581 = min(max(mad(-0.09967592358589172f, _1567, mad(1.17622971534729f, _1566, (_1565 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1582 = min(max(mad(0.9977163076400757f, _1567, mad(-0.006032449658960104f, _1566, (_1565 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1583 = dot(float3(_1580, _1581, _1582), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1594 = log2(max((lerp(_1583, _1580, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1595 = _1594 * 0.3010300099849701f;
                float _1596 = log2(ACESMinMaxData.x);
                float _1597 = _1596 * 0.3010300099849701f;
                do {
                  if (!(!(_1595 <= _1597))) {
                    _1666 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1604 = log2(ACESMidData.x);
                    float _1605 = _1604 * 0.3010300099849701f;
                    if ((bool)(_1595 > _1597) && (bool)(_1595 < _1605)) {
                      float _1613 = ((_1594 - _1596) * 0.9030900001525879f) / ((_1604 - _1596) * 0.3010300099849701f);
                      int _1614 = int(_1613);
                      float _1616 = _1613 - float((int)(_1614));
                      float _1618 = _10[_1614];
                      float _1621 = _10[(_1614 + 1)];
                      float _1626 = _1618 * 0.5f;
                      _1666 = dot(float3((_1616 * _1616), _1616, 1.0f), float3(mad((_10[(_1614 + 2)]), 0.5f, mad(_1621, -1.0f, _1626)), (_1621 - _1618), mad(_1621, 0.5f, _1626)));
                    } else {
                      do {
                        if (!(!(_1595 >= _1605))) {
                          float _1635 = log2(ACESMinMaxData.z);
                          if (_1595 < (_1635 * 0.3010300099849701f)) {
                            float _1643 = ((_1594 - _1604) * 0.9030900001525879f) / ((_1635 - _1604) * 0.3010300099849701f);
                            int _1644 = int(_1643);
                            float _1646 = _1643 - float((int)(_1644));
                            float _1648 = _11[_1644];
                            float _1651 = _11[(_1644 + 1)];
                            float _1656 = _1648 * 0.5f;
                            _1666 = dot(float3((_1646 * _1646), _1646, 1.0f), float3(mad((_11[(_1644 + 2)]), 0.5f, mad(_1651, -1.0f, _1656)), (_1651 - _1648), mad(_1651, 0.5f, _1656)));
                            break;
                          }
                        }
                        _1666 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1670 = log2(max((lerp(_1583, _1581, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1671 = _1670 * 0.3010300099849701f;
                  do {
                    if (!(!(_1671 <= _1597))) {
                      _1740 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1678 = log2(ACESMidData.x);
                      float _1679 = _1678 * 0.3010300099849701f;
                      if ((bool)(_1671 > _1597) && (bool)(_1671 < _1679)) {
                        float _1687 = ((_1670 - _1596) * 0.9030900001525879f) / ((_1678 - _1596) * 0.3010300099849701f);
                        int _1688 = int(_1687);
                        float _1690 = _1687 - float((int)(_1688));
                        float _1692 = _10[_1688];
                        float _1695 = _10[(_1688 + 1)];
                        float _1700 = _1692 * 0.5f;
                        _1740 = dot(float3((_1690 * _1690), _1690, 1.0f), float3(mad((_10[(_1688 + 2)]), 0.5f, mad(_1695, -1.0f, _1700)), (_1695 - _1692), mad(_1695, 0.5f, _1700)));
                      } else {
                        do {
                          if (!(!(_1671 >= _1679))) {
                            float _1709 = log2(ACESMinMaxData.z);
                            if (_1671 < (_1709 * 0.3010300099849701f)) {
                              float _1717 = ((_1670 - _1678) * 0.9030900001525879f) / ((_1709 - _1678) * 0.3010300099849701f);
                              int _1718 = int(_1717);
                              float _1720 = _1717 - float((int)(_1718));
                              float _1722 = _11[_1718];
                              float _1725 = _11[(_1718 + 1)];
                              float _1730 = _1722 * 0.5f;
                              _1740 = dot(float3((_1720 * _1720), _1720, 1.0f), float3(mad((_11[(_1718 + 2)]), 0.5f, mad(_1725, -1.0f, _1730)), (_1725 - _1722), mad(_1725, 0.5f, _1730)));
                              break;
                            }
                          }
                          _1740 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1744 = log2(max((lerp(_1583, _1582, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1745 = _1744 * 0.3010300099849701f;
                    do {
                      if (!(!(_1745 <= _1597))) {
                        _1814 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1752 = log2(ACESMidData.x);
                        float _1753 = _1752 * 0.3010300099849701f;
                        if ((bool)(_1745 > _1597) && (bool)(_1745 < _1753)) {
                          float _1761 = ((_1744 - _1596) * 0.9030900001525879f) / ((_1752 - _1596) * 0.3010300099849701f);
                          int _1762 = int(_1761);
                          float _1764 = _1761 - float((int)(_1762));
                          float _1766 = _10[_1762];
                          float _1769 = _10[(_1762 + 1)];
                          float _1774 = _1766 * 0.5f;
                          _1814 = dot(float3((_1764 * _1764), _1764, 1.0f), float3(mad((_10[(_1762 + 2)]), 0.5f, mad(_1769, -1.0f, _1774)), (_1769 - _1766), mad(_1769, 0.5f, _1774)));
                        } else {
                          do {
                            if (!(!(_1745 >= _1753))) {
                              float _1783 = log2(ACESMinMaxData.z);
                              if (_1745 < (_1783 * 0.3010300099849701f)) {
                                float _1791 = ((_1744 - _1752) * 0.9030900001525879f) / ((_1783 - _1752) * 0.3010300099849701f);
                                int _1792 = int(_1791);
                                float _1794 = _1791 - float((int)(_1792));
                                float _1796 = _11[_1792];
                                float _1799 = _11[(_1792 + 1)];
                                float _1804 = _1796 * 0.5f;
                                _1814 = dot(float3((_1794 * _1794), _1794, 1.0f), float3(mad((_11[(_1792 + 2)]), 0.5f, mad(_1799, -1.0f, _1804)), (_1799 - _1796), mad(_1799, 0.5f, _1804)));
                                break;
                              }
                            }
                            _1814 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1818 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1819 = (exp2(_1666 * 3.321928024291992f) - ACESMinMaxData.y) / _1818;
                      float _1821 = (exp2(_1740 * 3.321928024291992f) - ACESMinMaxData.y) / _1818;
                      float _1823 = (exp2(_1814 * 3.321928024291992f) - ACESMinMaxData.y) / _1818;
                      float _1826 = mad(0.15618768334388733f, _1823, mad(0.13400420546531677f, _1821, (_1819 * 0.6624541878700256f)));
                      float _1829 = mad(0.053689517080783844f, _1823, mad(0.6740817427635193f, _1821, (_1819 * 0.2722287178039551f)));
                      float _1832 = mad(1.0103391408920288f, _1823, mad(0.00406073359772563f, _1821, (_1819 * -0.005574649665504694f)));
                      float _1845 = min(max(mad(-0.23642469942569733f, _1832, mad(-0.32480329275131226f, _1829, (_1826 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1846 = min(max(mad(0.016756348311901093f, _1832, mad(1.6153316497802734f, _1829, (_1826 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1847 = min(max(mad(0.9883948564529419f, _1832, mad(-0.008284442126750946f, _1829, (_1826 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1850 = mad(0.15618768334388733f, _1847, mad(0.13400420546531677f, _1846, (_1845 * 0.6624541878700256f)));
                      float _1853 = mad(0.053689517080783844f, _1847, mad(0.6740817427635193f, _1846, (_1845 * 0.2722287178039551f)));
                      float _1856 = mad(1.0103391408920288f, _1847, mad(0.00406073359772563f, _1846, (_1845 * -0.005574649665504694f)));
                      float _1878 = min(max((min(max(mad(-0.23642469942569733f, _1856, mad(-0.32480329275131226f, _1853, (_1850 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1879 = min(max((min(max(mad(0.016756348311901093f, _1856, mad(1.6153316497802734f, _1853, (_1850 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1880 = min(max((min(max(mad(0.9883948564529419f, _1856, mad(-0.008284442126750946f, _1853, (_1850 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!(OutputDevice == 5)) {
                          _1893 = mad(_45, _1880, mad(_44, _1879, (_1878 * _43)));
                          _1894 = mad(_48, _1880, mad(_47, _1879, (_1878 * _46)));
                          _1895 = mad(_51, _1880, mad(_50, _1879, (_1878 * _49)));
                        } else {
                          _1893 = _1878;
                          _1894 = _1879;
                          _1895 = _1880;
                        }
                        float _1905 = exp2(log2(_1893 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1906 = exp2(log2(_1894 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1907 = exp2(log2(_1895 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _3890 = exp2(log2((1.0f / ((_1905 * 18.6875f) + 1.0f)) * ((_1905 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _3891 = exp2(log2((1.0f / ((_1906 * 18.6875f) + 1.0f)) * ((_1906 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _3892 = exp2(log2((1.0f / ((_1907 * 18.6875f) + 1.0f)) * ((_1907 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1984 = ACESSceneColorMultiplier * _1210;
          float _1985 = ACESSceneColorMultiplier * _1211;
          float _1986 = ACESSceneColorMultiplier * _1212;
          float _1989 = mad((WorkingColorSpace_ToAP0[0].z), _1986, mad((WorkingColorSpace_ToAP0[0].y), _1985, ((WorkingColorSpace_ToAP0[0].x) * _1984)));
          float _1992 = mad((WorkingColorSpace_ToAP0[1].z), _1986, mad((WorkingColorSpace_ToAP0[1].y), _1985, ((WorkingColorSpace_ToAP0[1].x) * _1984)));
          float _1995 = mad((WorkingColorSpace_ToAP0[2].z), _1986, mad((WorkingColorSpace_ToAP0[2].y), _1985, ((WorkingColorSpace_ToAP0[2].x) * _1984)));
          float _1999 = max(max(_1989, _1992), _1995);
          float _2004 = (max(_1999, 1.000000013351432e-10f) - max(min(min(_1989, _1992), _1995), 1.000000013351432e-10f)) / max(_1999, 0.009999999776482582f);
          float _2017 = ((_1992 + _1989) + _1995) + (sqrt((((_1995 - _1992) * _1995) + ((_1992 - _1989) * _1992)) + ((_1989 - _1995) * _1989)) * 1.75f);
          float _2018 = _2017 * 0.3333333432674408f;
          float _2019 = _2004 + -0.4000000059604645f;
          float _2020 = _2019 * 5.0f;
          float _2024 = max((1.0f - abs(_2019 * 2.5f)), 0.0f);
          float _2035 = ((float((int)(((int)(uint)((bool)(_2020 > 0.0f))) - ((int)(uint)((bool)(_2020 < 0.0f))))) * (1.0f - (_2024 * _2024))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2018 <= 0.0533333346247673f)) {
              if (!(_2018 >= 0.1599999964237213f)) {
                _2044 = (((0.23999999463558197f / _2017) + -0.5f) * _2035);
              } else {
                _2044 = 0.0f;
              }
            } else {
              _2044 = _2035;
            }
            float _2045 = _2044 + 1.0f;
            float _2046 = _2045 * _1989;
            float _2047 = _2045 * _1992;
            float _2048 = _2045 * _1995;
            do {
              if (!((bool)(_2046 == _2047) && (bool)(_2047 == _2048))) {
                float _2055 = ((_2046 * 2.0f) - _2047) - _2048;
                float _2058 = ((_1992 - _1995) * 1.7320507764816284f) * _2045;
                float _2060 = atan(_2058 / _2055);
                bool _2063 = (_2055 < 0.0f);
                bool _2064 = (_2055 == 0.0f);
                bool _2065 = (_2058 >= 0.0f);
                bool _2066 = (_2058 < 0.0f);
                _2077 = select((_2065 && _2064), 90.0f, select((_2066 && _2064), -90.0f, (select((_2066 && _2063), (_2060 + -3.1415927410125732f), select((_2065 && _2063), (_2060 + 3.1415927410125732f), _2060)) * 57.2957763671875f)));
              } else {
                _2077 = 0.0f;
              }
              float _2082 = min(max(select((_2077 < 0.0f), (_2077 + 360.0f), _2077), 0.0f), 360.0f);
              do {
                if (_2082 < -180.0f) {
                  _2091 = (_2082 + 360.0f);
                } else {
                  if (_2082 > 180.0f) {
                    _2091 = (_2082 + -360.0f);
                  } else {
                    _2091 = _2082;
                  }
                }
                do {
                  if ((bool)(_2091 > -67.5f) && (bool)(_2091 < 67.5f)) {
                    float _2097 = (_2091 + 67.5f) * 0.029629629105329514f;
                    int _2098 = int(_2097);
                    float _2100 = _2097 - float((int)(_2098));
                    float _2101 = _2100 * _2100;
                    float _2102 = _2101 * _2100;
                    if (_2098 == 3) {
                      _2130 = (((0.1666666716337204f - (_2100 * 0.5f)) + (_2101 * 0.5f)) - (_2102 * 0.1666666716337204f));
                    } else {
                      if (_2098 == 2) {
                        _2130 = ((0.6666666865348816f - _2101) + (_2102 * 0.5f));
                      } else {
                        if (_2098 == 1) {
                          _2130 = (((_2102 * -0.5f) + 0.1666666716337204f) + ((_2101 + _2100) * 0.5f));
                        } else {
                          _2130 = select((_2098 == 0), (_2102 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2130 = 0.0f;
                  }
                  float _2139 = min(max(((((_2004 * 0.27000001072883606f) * (0.029999999329447746f - _2046)) * _2130) + _2046), 0.0f), 65535.0f);
                  float _2140 = min(max(_2047, 0.0f), 65535.0f);
                  float _2141 = min(max(_2048, 0.0f), 65535.0f);
                  float _2154 = min(max(mad(-0.21492856740951538f, _2141, mad(-0.2365107536315918f, _2140, (_2139 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2155 = min(max(mad(-0.09967592358589172f, _2141, mad(1.17622971534729f, _2140, (_2139 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2156 = min(max(mad(0.9977163076400757f, _2141, mad(-0.006032449658960104f, _2140, (_2139 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2157 = dot(float3(_2154, _2155, _2156), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2168 = log2(max((lerp(_2157, _2154, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2169 = _2168 * 0.3010300099849701f;
                  float _2170 = log2(ACESMinMaxData.x);
                  float _2171 = _2170 * 0.3010300099849701f;
                  do {
                    if (!(!(_2169 <= _2171))) {
                      _2240 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2178 = log2(ACESMidData.x);
                      float _2179 = _2178 * 0.3010300099849701f;
                      if ((bool)(_2169 > _2171) && (bool)(_2169 < _2179)) {
                        float _2187 = ((_2168 - _2170) * 0.9030900001525879f) / ((_2178 - _2170) * 0.3010300099849701f);
                        int _2188 = int(_2187);
                        float _2190 = _2187 - float((int)(_2188));
                        float _2192 = _8[_2188];
                        float _2195 = _8[(_2188 + 1)];
                        float _2200 = _2192 * 0.5f;
                        _2240 = dot(float3((_2190 * _2190), _2190, 1.0f), float3(mad((_8[(_2188 + 2)]), 0.5f, mad(_2195, -1.0f, _2200)), (_2195 - _2192), mad(_2195, 0.5f, _2200)));
                      } else {
                        do {
                          if (!(!(_2169 >= _2179))) {
                            float _2209 = log2(ACESMinMaxData.z);
                            if (_2169 < (_2209 * 0.3010300099849701f)) {
                              float _2217 = ((_2168 - _2178) * 0.9030900001525879f) / ((_2209 - _2178) * 0.3010300099849701f);
                              int _2218 = int(_2217);
                              float _2220 = _2217 - float((int)(_2218));
                              float _2222 = _9[_2218];
                              float _2225 = _9[(_2218 + 1)];
                              float _2230 = _2222 * 0.5f;
                              _2240 = dot(float3((_2220 * _2220), _2220, 1.0f), float3(mad((_9[(_2218 + 2)]), 0.5f, mad(_2225, -1.0f, _2230)), (_2225 - _2222), mad(_2225, 0.5f, _2230)));
                              break;
                            }
                          }
                          _2240 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2244 = log2(max((lerp(_2157, _2155, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2245 = _2244 * 0.3010300099849701f;
                    do {
                      if (!(!(_2245 <= _2171))) {
                        _2314 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2252 = log2(ACESMidData.x);
                        float _2253 = _2252 * 0.3010300099849701f;
                        if ((bool)(_2245 > _2171) && (bool)(_2245 < _2253)) {
                          float _2261 = ((_2244 - _2170) * 0.9030900001525879f) / ((_2252 - _2170) * 0.3010300099849701f);
                          int _2262 = int(_2261);
                          float _2264 = _2261 - float((int)(_2262));
                          float _2266 = _8[_2262];
                          float _2269 = _8[(_2262 + 1)];
                          float _2274 = _2266 * 0.5f;
                          _2314 = dot(float3((_2264 * _2264), _2264, 1.0f), float3(mad((_8[(_2262 + 2)]), 0.5f, mad(_2269, -1.0f, _2274)), (_2269 - _2266), mad(_2269, 0.5f, _2274)));
                        } else {
                          do {
                            if (!(!(_2245 >= _2253))) {
                              float _2283 = log2(ACESMinMaxData.z);
                              if (_2245 < (_2283 * 0.3010300099849701f)) {
                                float _2291 = ((_2244 - _2252) * 0.9030900001525879f) / ((_2283 - _2252) * 0.3010300099849701f);
                                int _2292 = int(_2291);
                                float _2294 = _2291 - float((int)(_2292));
                                float _2296 = _9[_2292];
                                float _2299 = _9[(_2292 + 1)];
                                float _2304 = _2296 * 0.5f;
                                _2314 = dot(float3((_2294 * _2294), _2294, 1.0f), float3(mad((_9[(_2292 + 2)]), 0.5f, mad(_2299, -1.0f, _2304)), (_2299 - _2296), mad(_2299, 0.5f, _2304)));
                                break;
                              }
                            }
                            _2314 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2318 = log2(max((lerp(_2157, _2156, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2319 = _2318 * 0.3010300099849701f;
                      do {
                        if (!(!(_2319 <= _2171))) {
                          _2388 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2326 = log2(ACESMidData.x);
                          float _2327 = _2326 * 0.3010300099849701f;
                          if ((bool)(_2319 > _2171) && (bool)(_2319 < _2327)) {
                            float _2335 = ((_2318 - _2170) * 0.9030900001525879f) / ((_2326 - _2170) * 0.3010300099849701f);
                            int _2336 = int(_2335);
                            float _2338 = _2335 - float((int)(_2336));
                            float _2340 = _8[_2336];
                            float _2343 = _8[(_2336 + 1)];
                            float _2348 = _2340 * 0.5f;
                            _2388 = dot(float3((_2338 * _2338), _2338, 1.0f), float3(mad((_8[(_2336 + 2)]), 0.5f, mad(_2343, -1.0f, _2348)), (_2343 - _2340), mad(_2343, 0.5f, _2348)));
                          } else {
                            do {
                              if (!(!(_2319 >= _2327))) {
                                float _2357 = log2(ACESMinMaxData.z);
                                if (_2319 < (_2357 * 0.3010300099849701f)) {
                                  float _2365 = ((_2318 - _2326) * 0.9030900001525879f) / ((_2357 - _2326) * 0.3010300099849701f);
                                  int _2366 = int(_2365);
                                  float _2368 = _2365 - float((int)(_2366));
                                  float _2370 = _9[_2366];
                                  float _2373 = _9[(_2366 + 1)];
                                  float _2378 = _2370 * 0.5f;
                                  _2388 = dot(float3((_2368 * _2368), _2368, 1.0f), float3(mad((_9[(_2366 + 2)]), 0.5f, mad(_2373, -1.0f, _2378)), (_2373 - _2370), mad(_2373, 0.5f, _2378)));
                                  break;
                                }
                              }
                              _2388 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2392 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2393 = (exp2(_2240 * 3.321928024291992f) - ACESMinMaxData.y) / _2392;
                        float _2395 = (exp2(_2314 * 3.321928024291992f) - ACESMinMaxData.y) / _2392;
                        float _2397 = (exp2(_2388 * 3.321928024291992f) - ACESMinMaxData.y) / _2392;
                        float _2400 = mad(0.15618768334388733f, _2397, mad(0.13400420546531677f, _2395, (_2393 * 0.6624541878700256f)));
                        float _2403 = mad(0.053689517080783844f, _2397, mad(0.6740817427635193f, _2395, (_2393 * 0.2722287178039551f)));
                        float _2406 = mad(1.0103391408920288f, _2397, mad(0.00406073359772563f, _2395, (_2393 * -0.005574649665504694f)));
                        float _2419 = min(max(mad(-0.23642469942569733f, _2406, mad(-0.32480329275131226f, _2403, (_2400 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2420 = min(max(mad(0.016756348311901093f, _2406, mad(1.6153316497802734f, _2403, (_2400 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2421 = min(max(mad(0.9883948564529419f, _2406, mad(-0.008284442126750946f, _2403, (_2400 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2424 = mad(0.15618768334388733f, _2421, mad(0.13400420546531677f, _2420, (_2419 * 0.6624541878700256f)));
                        float _2427 = mad(0.053689517080783844f, _2421, mad(0.6740817427635193f, _2420, (_2419 * 0.2722287178039551f)));
                        float _2430 = mad(1.0103391408920288f, _2421, mad(0.00406073359772563f, _2420, (_2419 * -0.005574649665504694f)));
                        float _2452 = min(max((min(max(mad(-0.23642469942569733f, _2430, mad(-0.32480329275131226f, _2427, (_2424 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2453 = min(max((min(max(mad(0.016756348311901093f, _2430, mad(1.6153316497802734f, _2427, (_2424 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2454 = min(max((min(max(mad(0.9883948564529419f, _2430, mad(-0.008284442126750946f, _2427, (_2424 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 6)) {
                            _2467 = mad(_45, _2454, mad(_44, _2453, (_2452 * _43)));
                            _2468 = mad(_48, _2454, mad(_47, _2453, (_2452 * _46)));
                            _2469 = mad(_51, _2454, mad(_50, _2453, (_2452 * _49)));
                          } else {
                            _2467 = _2452;
                            _2468 = _2453;
                            _2469 = _2454;
                          }
                          float _2479 = exp2(log2(_2467 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2480 = exp2(log2(_2468 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2481 = exp2(log2(_2469 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _3890 = exp2(log2((1.0f / ((_2479 * 18.6875f) + 1.0f)) * ((_2479 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3891 = exp2(log2((1.0f / ((_2480 * 18.6875f) + 1.0f)) * ((_2480 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3892 = exp2(log2((1.0f / ((_2481 * 18.6875f) + 1.0f)) * ((_2481 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2526 = mad((WorkingColorSpace_ToAP1[0].z), _1212, mad((WorkingColorSpace_ToAP1[0].y), _1211, ((WorkingColorSpace_ToAP1[0].x) * _1210)));
            float _2529 = mad((WorkingColorSpace_ToAP1[1].z), _1212, mad((WorkingColorSpace_ToAP1[1].y), _1211, ((WorkingColorSpace_ToAP1[1].x) * _1210)));
            float _2532 = mad((WorkingColorSpace_ToAP1[2].z), _1212, mad((WorkingColorSpace_ToAP1[2].y), _1211, ((WorkingColorSpace_ToAP1[2].x) * _1210)));
            float _2551 = exp2(log2(mad(_45, _2532, mad(_44, _2529, (_2526 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2552 = exp2(log2(mad(_48, _2532, mad(_47, _2529, (_2526 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2553 = exp2(log2(mad(_51, _2532, mad(_50, _2529, (_2526 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3890 = exp2(log2((1.0f / ((_2551 * 18.6875f) + 1.0f)) * ((_2551 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3891 = exp2(log2((1.0f / ((_2552 * 18.6875f) + 1.0f)) * ((_2552 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3892 = exp2(log2((1.0f / ((_2553 * 18.6875f) + 1.0f)) * ((_2553 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2600 = mad((WorkingColorSpace_ToAP1[0].z), _1200, mad((WorkingColorSpace_ToAP1[0].y), _1199, ((WorkingColorSpace_ToAP1[0].x) * _1198)));
                float _2603 = mad((WorkingColorSpace_ToAP1[1].z), _1200, mad((WorkingColorSpace_ToAP1[1].y), _1199, ((WorkingColorSpace_ToAP1[1].x) * _1198)));
                float _2606 = mad((WorkingColorSpace_ToAP1[2].z), _1200, mad((WorkingColorSpace_ToAP1[2].y), _1199, ((WorkingColorSpace_ToAP1[2].x) * _1198)));
                _3890 = mad(_45, _2606, mad(_44, _2603, (_2600 * _43)));
                _3891 = mad(_48, _2606, mad(_47, _2603, (_2600 * _46)));
                _3892 = mad(_51, _2606, mad(_50, _2603, (_2600 * _49)));
              } else {
                if (OutputDevice == 10) {
                  float _2621 = dot(float3(_1210, _1211, _1212), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                  do {
                    if (!((bool)(_2621 > UCPGradeShadowCutoff) || (bool)(_2621 < 0.0f))) {
                      float _2628 = saturate(_2621 / UCPGradeShadowCutoff);
                      float _2631 = (pow(_2628, UCPGradeShadowGamma));
                      _2637 = ((lerp(_2631, _2628, _2628)) * UCPGradeShadowCutoff);
                    } else {
                      _2637 = _2621;
                    }
                    float _2646 = UCPExposureAdjust * ((_2637 * _1210) / _2621);
                    float _2647 = UCPExposureAdjust * ((_2637 * _1211) / _2621);
                    float _2648 = UCPExposureAdjust * ((_2637 * _1212) / _2621);
                    float _2651 = mad(0.177378311753273f, _2648, mad(0.38298869132995605f, _2647, (_2646 * 0.43963295221328735f)));
                    float _2654 = mad(0.09678413718938828f, _2648, mad(0.8134394288063049f, _2647, (_2646 * 0.08977644890546799f)));
                    float _2657 = mad(0.8709122538566589f, _2648, mad(0.11154655367136002f, _2647, (_2646 * 0.017541170120239258f)));
                    float _2661 = max(max(_2651, _2654), _2657);
                    float _2666 = (max(_2661, 1.000000013351432e-10f) - max(min(min(_2651, _2654), _2657), 1.000000013351432e-10f)) / max(_2661, 0.009999999776482582f);
                    float _2679 = ((_2654 + _2651) + _2657) + (sqrt((((_2657 - _2654) * _2657) + ((_2654 - _2651) * _2654)) + ((_2651 - _2657) * _2651)) * 1.75f);
                    float _2680 = _2679 * 0.3333333432674408f;
                    float _2681 = _2666 + -0.4000000059604645f;
                    float _2682 = _2681 * 5.0f;
                    float _2686 = max((1.0f - abs(_2681 * 2.5f)), 0.0f);
                    float _2697 = ((float((int)(((int)(uint)((bool)(_2682 > 0.0f))) - ((int)(uint)((bool)(_2682 < 0.0f))))) * (1.0f - (_2686 * _2686))) + 1.0f) * 0.02500000037252903f;
                    do {
                      if (!(_2680 <= 0.0533333346247673f)) {
                        if (!(_2680 >= 0.1599999964237213f)) {
                          _2706 = (((0.23999999463558197f / _2679) + -0.5f) * _2697);
                        } else {
                          _2706 = 0.0f;
                        }
                      } else {
                        _2706 = _2697;
                      }
                      float _2707 = _2706 + 1.0f;
                      float _2708 = _2707 * _2651;
                      float _2709 = _2707 * _2654;
                      float _2710 = _2707 * _2657;
                      do {
                        if (!((bool)(_2708 == _2709) && (bool)(_2709 == _2710))) {
                          float _2717 = ((_2708 * 2.0f) - _2709) - _2710;
                          float _2720 = ((_2654 - _2657) * 1.7320507764816284f) * _2707;
                          float _2722 = atan(_2720 / _2717);
                          bool _2725 = (_2717 < 0.0f);
                          bool _2726 = (_2717 == 0.0f);
                          bool _2727 = (_2720 >= 0.0f);
                          bool _2728 = (_2720 < 0.0f);
                          _2739 = select((_2727 && _2726), 90.0f, select((_2728 && _2726), -90.0f, (select((_2728 && _2725), (_2722 + -3.1415927410125732f), select((_2727 && _2725), (_2722 + 3.1415927410125732f), _2722)) * 57.2957763671875f)));
                        } else {
                          _2739 = 0.0f;
                        }
                        float _2744 = min(max(select((_2739 < 0.0f), (_2739 + 360.0f), _2739), 0.0f), 360.0f);
                        do {
                          if (_2744 < -180.0f) {
                            _2753 = (_2744 + 360.0f);
                          } else {
                            if (_2744 > 180.0f) {
                              _2753 = (_2744 + -360.0f);
                            } else {
                              _2753 = _2744;
                            }
                          }
                          do {
                            if ((bool)(_2753 > -67.5f) && (bool)(_2753 < 67.5f)) {
                              float _2759 = (_2753 + 67.5f) * 0.029629629105329514f;
                              int _2760 = int(_2759);
                              float _2762 = _2759 - float((int)(_2760));
                              float _2763 = _2762 * _2762;
                              float _2764 = _2763 * _2762;
                              if (_2760 == 3) {
                                _2792 = (((0.1666666716337204f - (_2762 * 0.5f)) + (_2763 * 0.5f)) - (_2764 * 0.1666666716337204f));
                              } else {
                                if (_2760 == 2) {
                                  _2792 = ((0.6666666865348816f - _2763) + (_2764 * 0.5f));
                                } else {
                                  if (_2760 == 1) {
                                    _2792 = (((_2764 * -0.5f) + 0.1666666716337204f) + ((_2763 + _2762) * 0.5f));
                                  } else {
                                    _2792 = select((_2760 == 0), (_2764 * 0.1666666716337204f), 0.0f);
                                  }
                                }
                              }
                            } else {
                              _2792 = 0.0f;
                            }
                            float _2801 = min(max(((((_2666 * 0.27000001072883606f) * (0.029999999329447746f - _2708)) * _2792) + _2708), 0.0f), 65535.0f);
                            float _2802 = min(max(_2709, 0.0f), 65535.0f);
                            float _2803 = min(max(_2710, 0.0f), 65535.0f);
                            float _2816 = min(max(mad(-0.21492856740951538f, _2803, mad(-0.2365107536315918f, _2802, (_2801 * 1.4514392614364624f))), 0.0f), 65504.0f);
                            float _2817 = min(max(mad(-0.09967592358589172f, _2803, mad(1.17622971534729f, _2802, (_2801 * -0.07655377686023712f))), 0.0f), 65504.0f);
                            float _2818 = min(max(mad(0.9977163076400757f, _2803, mad(-0.006032449658960104f, _2802, (_2801 * 0.008316148072481155f))), 0.0f), 65504.0f);
                            float _2819 = dot(float3(_2816, _2817, _2818), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                            float _2830 = log2(max((lerp(_2819, _2816, 0.9599999785423279f)), 1.000000013351432e-10f));
                            float _2831 = _2830 * 0.3010300099849701f;
                            do {
                              if (!(_2831 <= -5.2601776123046875f)) {
                                if ((bool)(_2831 > -5.2601776123046875f) && (bool)(_2831 < -0.7447274923324585f)) {
                                  float _2839 = (_2830 * 0.19999998807907104f) + 3.494786262512207f;
                                  int _2840 = int(_2839);
                                  float _2842 = _2839 - float((int)(_2840));
                                  float _2844 = _global_0[_2840];
                                  float _2847 = _global_0[(_2840 + 1)];
                                  float _2852 = _2844 * 0.5f;
                                  _2884 = dot(float3((_2842 * _2842), _2842, 1.0f), float3(mad((_global_0[(_2840 + 2)]), 0.5f, mad(_2847, -1.0f, _2852)), (_2847 - _2844), mad(_2847, 0.5f, _2852)));
                                } else {
                                  if ((bool)(_2831 >= -0.7447274923324585f) && (bool)(_2831 < 4.673812389373779f)) {
                                    float _2864 = (_2830 * 0.1666666567325592f) + 0.4123218357563019f;
                                    int _2865 = int(_2864);
                                    float _2867 = _2864 - float((int)(_2865));
                                    float _2869 = _global_1[_2865];
                                    float _2872 = _global_1[(_2865 + 1)];
                                    float _2877 = _2869 * 0.5f;
                                    _2884 = dot(float3((_2867 * _2867), _2867, 1.0f), float3(mad((_global_1[(_2865 + 2)]), 0.5f, mad(_2872, -1.0f, _2877)), (_2872 - _2869), mad(_2872, 0.5f, _2877)));
                                  } else {
                                    _2884 = 4.0f;
                                  }
                                }
                              } else {
                                _2884 = -4.0f;
                              }
                              float _2886 = exp2(_2884 * 3.321928024291992f);
                              float _2888 = log2(max((lerp(_2819, _2817, 0.9599999785423279f)), 1.000000013351432e-10f));
                              float _2889 = _2888 * 0.3010300099849701f;
                              do {
                                if (!(_2889 <= -5.2601776123046875f)) {
                                  if ((bool)(_2889 > -5.2601776123046875f) && (bool)(_2889 < -0.7447274923324585f)) {
                                    float _2897 = (_2888 * 0.19999998807907104f) + 3.494786262512207f;
                                    int _2898 = int(_2897);
                                    float _2900 = _2897 - float((int)(_2898));
                                    float _2902 = _global_0[_2898];
                                    float _2905 = _global_0[(_2898 + 1)];
                                    float _2910 = _2902 * 0.5f;
                                    _2942 = dot(float3((_2900 * _2900), _2900, 1.0f), float3(mad((_global_0[(_2898 + 2)]), 0.5f, mad(_2905, -1.0f, _2910)), (_2905 - _2902), mad(_2905, 0.5f, _2910)));
                                  } else {
                                    if ((bool)(_2889 >= -0.7447274923324585f) && (bool)(_2889 < 4.673812389373779f)) {
                                      float _2922 = (_2888 * 0.1666666567325592f) + 0.4123218357563019f;
                                      int _2923 = int(_2922);
                                      float _2925 = _2922 - float((int)(_2923));
                                      float _2927 = _global_1[_2923];
                                      float _2930 = _global_1[(_2923 + 1)];
                                      float _2935 = _2927 * 0.5f;
                                      _2942 = dot(float3((_2925 * _2925), _2925, 1.0f), float3(mad((_global_1[(_2923 + 2)]), 0.5f, mad(_2930, -1.0f, _2935)), (_2930 - _2927), mad(_2930, 0.5f, _2935)));
                                    } else {
                                      _2942 = 4.0f;
                                    }
                                  }
                                } else {
                                  _2942 = -4.0f;
                                }
                                float _2944 = exp2(_2942 * 3.321928024291992f);
                                float _2946 = log2(max((lerp(_2819, _2818, 0.9599999785423279f)), 1.000000013351432e-10f));
                                float _2947 = _2946 * 0.3010300099849701f;
                                do {
                                  if (!(_2947 <= -5.2601776123046875f)) {
                                    if ((bool)(_2947 > -5.2601776123046875f) && (bool)(_2947 < -0.7447274923324585f)) {
                                      float _2955 = (_2946 * 0.19999998807907104f) + 3.494786262512207f;
                                      int _2956 = int(_2955);
                                      float _2958 = _2955 - float((int)(_2956));
                                      float _2960 = _global_0[_2956];
                                      float _2963 = _global_0[(_2956 + 1)];
                                      float _2968 = _2960 * 0.5f;
                                      _3000 = dot(float3((_2958 * _2958), _2958, 1.0f), float3(mad((_global_0[(_2956 + 2)]), 0.5f, mad(_2963, -1.0f, _2968)), (_2963 - _2960), mad(_2963, 0.5f, _2968)));
                                    } else {
                                      if ((bool)(_2947 >= -0.7447274923324585f) && (bool)(_2947 < 4.673812389373779f)) {
                                        float _2980 = (_2946 * 0.1666666567325592f) + 0.4123218357563019f;
                                        int _2981 = int(_2980);
                                        float _2983 = _2980 - float((int)(_2981));
                                        float _2985 = _global_1[_2981];
                                        float _2988 = _global_1[(_2981 + 1)];
                                        float _2993 = _2985 * 0.5f;
                                        _3000 = dot(float3((_2983 * _2983), _2983, 1.0f), float3(mad((_global_1[(_2981 + 2)]), 0.5f, mad(_2988, -1.0f, _2993)), (_2988 - _2985), mad(_2988, 0.5f, _2993)));
                                      } else {
                                        _3000 = 4.0f;
                                      }
                                    }
                                  } else {
                                    _3000 = -4.0f;
                                  }
                                  float _3002 = exp2(_3000 * 3.321928024291992f);
                                  float _3005 = mad(0.16386906802654266f, _3002, mad(0.14067870378494263f, _2944, (_2886 * 0.6954522132873535f)));
                                  float _3008 = mad(0.0955343171954155f, _3002, mad(0.8596711158752441f, _2944, (_2886 * 0.044794563204050064f)));
                                  float _3011 = mad(1.0015007257461548f, _3002, mad(0.004025210160762072f, _2944, (_2886 * -0.005525882821530104f)));
                                  bool _3036 = (UCPSDRDisplayMapVersion == 0);
                                  float _3039 = select(_3036, 0.15000000596046448f, 0.4000000059604645f);
                                  float _3040 = exp2(log2(mad(-0.22423863410949707f, _3011, mad(-0.2661709189414978f, _3008, (_3005 * 1.49040949344635f))) * 9.999999747378752e-05f) * OutputSceneGamma) * 33.333335876464844f;
                                  float _3041 = exp2(log2(mad(-0.10199961066246033f, _3011, mad(1.1821670532226562f, _3008, (_3005 * -0.0801674947142601f))) * 9.999999747378752e-05f) * OutputSceneGamma) * 33.333335876464844f;
                                  float _3042 = exp2(log2(mad(1.0315489768981934f, _3011, mad(-0.0347764752805233f, _3008, (_3005 * 0.003227631561458111f))) * 9.999999747378752e-05f) * OutputSceneGamma) * 33.333335876464844f;
                                  do {
                                    if (!(_3040 < _3039)) {
                                      float _3046 = 1.0f - _3039;
                                      _3054 = (((1.0f - exp2(((_3040 - _3039) / _3046) * -1.4426950216293335f)) * _3046) + _3039);
                                    } else {
                                      _3054 = _3040;
                                    }
                                    do {
                                      if (!(_3041 < _3039)) {
                                        float _3058 = 1.0f - _3039;
                                        _3066 = (((1.0f - exp2(((_3041 - _3039) / _3058) * -1.4426950216293335f)) * _3058) + _3039);
                                      } else {
                                        _3066 = _3041;
                                      }
                                      do {
                                        if (!(_3042 < _3039)) {
                                          float _3070 = 1.0f - _3039;
                                          _3078 = (((1.0f - exp2(((_3042 - _3039) / _3070) * -1.4426950216293335f)) * _3070) + _3039);
                                        } else {
                                          _3078 = _3042;
                                        }
                                        float _3079 = dot(float3(_3040, _3041, _3042), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f));
                                        float _3080 = dot(float3(_3054, _3066, _3078), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f));
                                        float _3084 = (_3080 * _3040) / _3079;
                                        float _3085 = (_3080 * _3041) / _3079;
                                        float _3086 = (_3080 * _3042) / _3079;
                                        float _3087 = dot(float3(_3084, _3085, _3086), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f));
                                        float _3088 = _3079 * select(_3036, 0.20000000298023224f, 0.4000000059604645f);
                                        do {
                                          if (!(_3088 < 0.5f)) {
                                            _3098 = (((1.0f - exp2((_3088 + -0.5f) * -2.885390043258667f)) * 0.5f) + 0.5f);
                                          } else {
                                            _3098 = _3088;
                                          }
                                          float _3104 = mad(-0.07280000299215317f, _3086, mad(-0.5875999927520752f, _3085, (_3084 * 1.6605000495910645f)));
                                          float _3107 = mad(-0.008299999870359898f, _3086, mad(1.1328999996185303f, _3085, (_3084 * -0.12460000067949295f)));
                                          float _3110 = mad(1.1187000274658203f, _3086, mad(-0.1005999967455864f, _3085, (_3084 * -0.018200000748038292f)));
                                          do {
                                            if (!(_3087 >= 1.0f)) {
                                              if (!(_3087 <= 0.0f)) {
                                                float _3121 = _3104 - _3087;
                                                float _3122 = _3107 - _3087;
                                                float _3123 = _3110 - _3087;
                                                _3137 = (max(max(select((_3121 > 0.0f), ((max(_3104, 1.0f) + -1.0f) / _3121), 0.0f), select((_3122 > 0.0f), ((max(_3107, 1.0f) + -1.0f) / _3122), 0.0f)), select((_3123 > 0.0f), ((max(_3110, 1.0f) + -1.0f) / _3123), 0.0f)) * 0.5f);
                                              } else {
                                                _3137 = 0.0f;
                                              }
                                            } else {
                                              _3137 = 0.5f;
                                            }
                                            float _3138 = max((((_3098 * 1.100000023841858f) + -0.10000000149011612f) * select(_3036, 0.800000011920929f, 0.8500000238418579f)), _3137);
                                            float _3145 = (_3138 * (_3087 - _3084)) + _3084;
                                            float _3146 = (_3138 * (_3087 - _3085)) + _3085;
                                            float _3147 = (_3138 * (_3087 - _3086)) + _3086;
                                            float _3150 = mad(-0.07280000299215317f, _3147, mad(-0.5875999927520752f, _3146, (_3145 * 1.6605000495910645f)));
                                            float _3153 = mad(-0.008299999870359898f, _3147, mad(1.1328999996185303f, _3146, (_3145 * -0.12460000067949295f)));
                                            float _3156 = mad(1.1187000274658203f, _3147, mad(-0.1005999967455864f, _3146, (_3145 * -0.018200000748038292f)));
                                            do {
                                              if (SDROutputTransfer == 0) {
                                                _3214 = (pow(_3150, 0.4166666567325592f));
                                                _3215 = (pow(_3153, 0.4166666567325592f));
                                                _3216 = (pow(_3156, 0.4166666567325592f));
                                              } else {
                                                if (SDROutputTransfer == 1) {
                                                  _3214 = (pow(_3150, 0.45454543828964233f));
                                                  _3215 = (pow(_3153, 0.45454543828964233f));
                                                  _3216 = (pow(_3156, 0.45454543828964233f));
                                                } else {
                                                  do {
                                                    if (!(!(_3150 <= 0.0031308000907301903f))) {
                                                      _3192 = (_3150 * 12.920000076293945f);
                                                    } else {
                                                      _3192 = (((pow(_3150, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                                    }
                                                    do {
                                                      if (!(!(_3153 <= 0.0031308000907301903f))) {
                                                        _3203 = (_3153 * 12.920000076293945f);
                                                      } else {
                                                        _3203 = (((pow(_3153, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                                      }
                                                      if (!(!(_3156 <= 0.0031308000907301903f))) {
                                                        _3214 = _3192;
                                                        _3215 = _3203;
                                                        _3216 = (_3156 * 12.920000076293945f);
                                                      } else {
                                                        _3214 = _3192;
                                                        _3215 = _3203;
                                                        _3216 = (((pow(_3156, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                                                      }
                                                    } while (false);
                                                  } while (false);
                                                }
                                              }
                                              float _3219 = OutputMaxLum - OutputMinLum;
                                              _3890 = saturate((_3219 * _3214) + OutputMinLum);
                                              _3891 = saturate((_3219 * _3215) + OutputMinLum);
                                              _3892 = saturate((_3219 * _3216) + OutputMinLum);
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
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
                  if ((uint)((uint)((int)(OutputDevice) + -11u)) < (uint)2) {
                    float _3235 = dot(float3(_1210, _1211, _1212), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                    do {
                      if (!((bool)(_3235 > UCPGradeShadowCutoff) || (bool)(_3235 < 0.0f))) {
                        float _3242 = saturate(_3235 / UCPGradeShadowCutoff);
                        float _3245 = (pow(_3242, UCPGradeShadowGamma));
                        _3251 = ((lerp(_3245, _3242, _3242)) * UCPGradeShadowCutoff);
                      } else {
                        _3251 = _3235;
                      }
                      float _3260 = UCPExposureAdjust * ((_3251 * _1210) / _3235);
                      float _3261 = UCPExposureAdjust * ((_3251 * _1211) / _3235);
                      float _3262 = UCPExposureAdjust * ((_3251 * _1212) / _3235);
                      float _3265 = mad(0.177378311753273f, _3262, mad(0.38298869132995605f, _3261, (_3260 * 0.43963295221328735f)));
                      float _3268 = mad(0.09678413718938828f, _3262, mad(0.8134394288063049f, _3261, (_3260 * 0.08977644890546799f)));
                      float _3271 = mad(0.8709122538566589f, _3262, mad(0.11154655367136002f, _3261, (_3260 * 0.017541170120239258f)));
                      float _3275 = max(max(_3265, _3268), _3271);
                      float _3280 = (max(_3275, 1.000000013351432e-10f) - max(min(min(_3265, _3268), _3271), 1.000000013351432e-10f)) / max(_3275, 0.009999999776482582f);
                      float _3293 = ((_3268 + _3265) + _3271) + (sqrt((((_3271 - _3268) * _3271) + ((_3268 - _3265) * _3268)) + ((_3265 - _3271) * _3265)) * 1.75f);
                      float _3294 = _3293 * 0.3333333432674408f;
                      float _3295 = _3280 + -0.4000000059604645f;
                      float _3296 = _3295 * 5.0f;
                      float _3300 = max((1.0f - abs(_3295 * 2.5f)), 0.0f);
                      float _3311 = ((float((int)(((int)(uint)((bool)(_3296 > 0.0f))) - ((int)(uint)((bool)(_3296 < 0.0f))))) * (1.0f - (_3300 * _3300))) + 1.0f) * 0.02500000037252903f;
                      do {
                        if (!(_3294 <= 0.0533333346247673f)) {
                          if (!(_3294 >= 0.1599999964237213f)) {
                            _3320 = (((0.23999999463558197f / _3293) + -0.5f) * _3311);
                          } else {
                            _3320 = 0.0f;
                          }
                        } else {
                          _3320 = _3311;
                        }
                        float _3321 = _3320 + 1.0f;
                        float _3322 = _3321 * _3265;
                        float _3323 = _3321 * _3268;
                        float _3324 = _3321 * _3271;
                        do {
                          if (!((bool)(_3322 == _3323) && (bool)(_3323 == _3324))) {
                            float _3331 = ((_3322 * 2.0f) - _3323) - _3324;
                            float _3334 = ((_3268 - _3271) * 1.7320507764816284f) * _3321;
                            float _3336 = atan(_3334 / _3331);
                            bool _3339 = (_3331 < 0.0f);
                            bool _3340 = (_3331 == 0.0f);
                            bool _3341 = (_3334 >= 0.0f);
                            bool _3342 = (_3334 < 0.0f);
                            _3353 = select((_3341 && _3340), 90.0f, select((_3342 && _3340), -90.0f, (select((_3342 && _3339), (_3336 + -3.1415927410125732f), select((_3341 && _3339), (_3336 + 3.1415927410125732f), _3336)) * 57.2957763671875f)));
                          } else {
                            _3353 = 0.0f;
                          }
                          float _3358 = min(max(select((_3353 < 0.0f), (_3353 + 360.0f), _3353), 0.0f), 360.0f);
                          do {
                            if (_3358 < -180.0f) {
                              _3367 = (_3358 + 360.0f);
                            } else {
                              if (_3358 > 180.0f) {
                                _3367 = (_3358 + -360.0f);
                              } else {
                                _3367 = _3358;
                              }
                            }
                            do {
                              if ((bool)(_3367 > -67.5f) && (bool)(_3367 < 67.5f)) {
                                float _3373 = (_3367 + 67.5f) * 0.029629629105329514f;
                                int _3374 = int(_3373);
                                float _3376 = _3373 - float((int)(_3374));
                                float _3377 = _3376 * _3376;
                                float _3378 = _3377 * _3376;
                                if (_3374 == 3) {
                                  _3406 = (((0.1666666716337204f - (_3376 * 0.5f)) + (_3377 * 0.5f)) - (_3378 * 0.1666666716337204f));
                                } else {
                                  if (_3374 == 2) {
                                    _3406 = ((0.6666666865348816f - _3377) + (_3378 * 0.5f));
                                  } else {
                                    if (_3374 == 1) {
                                      _3406 = (((_3378 * -0.5f) + 0.1666666716337204f) + ((_3377 + _3376) * 0.5f));
                                    } else {
                                      _3406 = select((_3374 == 0), (_3378 * 0.1666666716337204f), 0.0f);
                                    }
                                  }
                                }
                              } else {
                                _3406 = 0.0f;
                              }
                              float _3415 = min(max(((((_3280 * 0.27000001072883606f) * (0.029999999329447746f - _3322)) * _3406) + _3322), 0.0f), 65535.0f);
                              float _3416 = min(max(_3323, 0.0f), 65535.0f);
                              float _3417 = min(max(_3324, 0.0f), 65535.0f);
                              float _3430 = min(max(mad(-0.21492856740951538f, _3417, mad(-0.2365107536315918f, _3416, (_3415 * 1.4514392614364624f))), 0.0f), 65504.0f);
                              float _3431 = min(max(mad(-0.09967592358589172f, _3417, mad(1.17622971534729f, _3416, (_3415 * -0.07655377686023712f))), 0.0f), 65504.0f);
                              float _3432 = min(max(mad(0.9977163076400757f, _3417, mad(-0.006032449658960104f, _3416, (_3415 * 0.008316148072481155f))), 0.0f), 65504.0f);
                              float _3433 = dot(float3(_3430, _3431, _3432), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                              float _3444 = log2(max((lerp(_3433, _3430, 0.9599999785423279f)), 1.000000013351432e-10f));
                              float _3445 = _3444 * 0.3010300099849701f;
                              do {
                                if (!(_3445 <= -5.2601776123046875f)) {
                                  if ((bool)(_3445 > -5.2601776123046875f) && (bool)(_3445 < -0.7447274923324585f)) {
                                    float _3453 = (_3444 * 0.19999998807907104f) + 3.494786262512207f;
                                    int _3454 = int(_3453);
                                    float _3456 = _3453 - float((int)(_3454));
                                    float _3458 = _global_0[_3454];
                                    float _3461 = _global_0[(_3454 + 1)];
                                    float _3466 = _3458 * 0.5f;
                                    _3498 = dot(float3((_3456 * _3456), _3456, 1.0f), float3(mad((_global_0[(_3454 + 2)]), 0.5f, mad(_3461, -1.0f, _3466)), (_3461 - _3458), mad(_3461, 0.5f, _3466)));
                                  } else {
                                    if ((bool)(_3445 >= -0.7447274923324585f) && (bool)(_3445 < 4.673812389373779f)) {
                                      float _3478 = (_3444 * 0.1666666567325592f) + 0.4123218357563019f;
                                      int _3479 = int(_3478);
                                      float _3481 = _3478 - float((int)(_3479));
                                      float _3483 = _global_1[_3479];
                                      float _3486 = _global_1[(_3479 + 1)];
                                      float _3491 = _3483 * 0.5f;
                                      _3498 = dot(float3((_3481 * _3481), _3481, 1.0f), float3(mad((_global_1[(_3479 + 2)]), 0.5f, mad(_3486, -1.0f, _3491)), (_3486 - _3483), mad(_3486, 0.5f, _3491)));
                                    } else {
                                      _3498 = 4.0f;
                                    }
                                  }
                                } else {
                                  _3498 = -4.0f;
                                }
                                float _3500 = exp2(_3498 * 3.321928024291992f);
                                float _3502 = log2(max((lerp(_3433, _3431, 0.9599999785423279f)), 1.000000013351432e-10f));
                                float _3503 = _3502 * 0.3010300099849701f;
                                do {
                                  if (!(_3503 <= -5.2601776123046875f)) {
                                    if ((bool)(_3503 > -5.2601776123046875f) && (bool)(_3503 < -0.7447274923324585f)) {
                                      float _3511 = (_3502 * 0.19999998807907104f) + 3.494786262512207f;
                                      int _3512 = int(_3511);
                                      float _3514 = _3511 - float((int)(_3512));
                                      float _3516 = _global_0[_3512];
                                      float _3519 = _global_0[(_3512 + 1)];
                                      float _3524 = _3516 * 0.5f;
                                      _3556 = dot(float3((_3514 * _3514), _3514, 1.0f), float3(mad((_global_0[(_3512 + 2)]), 0.5f, mad(_3519, -1.0f, _3524)), (_3519 - _3516), mad(_3519, 0.5f, _3524)));
                                    } else {
                                      if ((bool)(_3503 >= -0.7447274923324585f) && (bool)(_3503 < 4.673812389373779f)) {
                                        float _3536 = (_3502 * 0.1666666567325592f) + 0.4123218357563019f;
                                        int _3537 = int(_3536);
                                        float _3539 = _3536 - float((int)(_3537));
                                        float _3541 = _global_1[_3537];
                                        float _3544 = _global_1[(_3537 + 1)];
                                        float _3549 = _3541 * 0.5f;
                                        _3556 = dot(float3((_3539 * _3539), _3539, 1.0f), float3(mad((_global_1[(_3537 + 2)]), 0.5f, mad(_3544, -1.0f, _3549)), (_3544 - _3541), mad(_3544, 0.5f, _3549)));
                                      } else {
                                        _3556 = 4.0f;
                                      }
                                    }
                                  } else {
                                    _3556 = -4.0f;
                                  }
                                  float _3558 = exp2(_3556 * 3.321928024291992f);
                                  float _3560 = log2(max((lerp(_3433, _3432, 0.9599999785423279f)), 1.000000013351432e-10f));
                                  float _3561 = _3560 * 0.3010300099849701f;
                                  do {
                                    if (!(_3561 <= -5.2601776123046875f)) {
                                      if ((bool)(_3561 > -5.2601776123046875f) && (bool)(_3561 < -0.7447274923324585f)) {
                                        float _3569 = (_3560 * 0.19999998807907104f) + 3.494786262512207f;
                                        int _3570 = int(_3569);
                                        float _3572 = _3569 - float((int)(_3570));
                                        float _3574 = _global_0[_3570];
                                        float _3577 = _global_0[(_3570 + 1)];
                                        float _3582 = _3574 * 0.5f;
                                        _3614 = dot(float3((_3572 * _3572), _3572, 1.0f), float3(mad((_global_0[(_3570 + 2)]), 0.5f, mad(_3577, -1.0f, _3582)), (_3577 - _3574), mad(_3577, 0.5f, _3582)));
                                      } else {
                                        if ((bool)(_3561 >= -0.7447274923324585f) && (bool)(_3561 < 4.673812389373779f)) {
                                          float _3594 = (_3560 * 0.1666666567325592f) + 0.4123218357563019f;
                                          int _3595 = int(_3594);
                                          float _3597 = _3594 - float((int)(_3595));
                                          float _3599 = _global_1[_3595];
                                          float _3602 = _global_1[(_3595 + 1)];
                                          float _3607 = _3599 * 0.5f;
                                          _3614 = dot(float3((_3597 * _3597), _3597, 1.0f), float3(mad((_global_1[(_3595 + 2)]), 0.5f, mad(_3602, -1.0f, _3607)), (_3602 - _3599), mad(_3602, 0.5f, _3607)));
                                        } else {
                                          _3614 = 4.0f;
                                        }
                                      }
                                    } else {
                                      _3614 = -4.0f;
                                    }
                                    float _3616 = exp2(_3614 * 3.321928024291992f);
                                    float _3619 = mad(0.16386906802654266f, _3616, mad(0.14067870378494263f, _3558, (_3500 * 0.6954522132873535f)));
                                    float _3622 = mad(0.0955343171954155f, _3616, mad(0.8596711158752441f, _3558, (_3500 * 0.044794563204050064f)));
                                    float _3625 = mad(1.0015007257461548f, _3616, mad(0.004025210160762072f, _3558, (_3500 * -0.005525882821530104f)));
                                    float _3645 = exp2(log2(mad(-0.22423863410949707f, _3625, mad(-0.2661709189414978f, _3622, (_3619 * 1.49040949344635f))) * 9.999999747378752e-05f) * OutputSceneGamma);
                                    float _3648 = exp2(log2(mad(-0.10199961066246033f, _3625, mad(1.1821670532226562f, _3622, (_3619 * -0.0801674947142601f))) * 9.999999747378752e-05f) * OutputSceneGamma) * 10000.0f;
                                    float _3649 = exp2(log2(mad(1.0315489768981934f, _3625, mad(-0.0347764752805233f, _3622, (_3619 * 0.003227631561458111f))) * 9.999999747378752e-05f) * OutputSceneGamma) * 10000.0f;
                                    float _3673 = exp2(log2(saturate(mad(0.06400000303983688f, _3649, mad(0.5238999724388123f, _3648, (_3645 * 4121.0f))) * 9.999999747378752e-05f)) * 0.1593017578125f);
                                    float _3674 = exp2(log2(saturate(mad(0.1128000020980835f, _3649, mad(0.7204999923706055f, _3648, (_3645 * 1667.0f))) * 9.999999747378752e-05f)) * 0.1593017578125f);
                                    float _3675 = exp2(log2(saturate(mad(0.9003999829292297f, _3649, mad(0.07540000230073929f, _3648, (_3645 * 242.0f))) * 9.999999747378752e-05f)) * 0.1593017578125f);
                                    float _3697 = exp2(log2(((_3673 * 18.8515625f) + 0.8359375f) / ((_3673 * 18.6875f) + 1.0f)) * 78.84375f);
                                    float _3698 = exp2(log2(((_3674 * 18.8515625f) + 0.8359375f) / ((_3674 * 18.6875f) + 1.0f)) * 78.84375f);
                                    float _3699 = exp2(log2(((_3675 * 18.8515625f) + 0.8359375f) / ((_3675 * 18.6875f) + 1.0f)) * 78.84375f);
                                    float _3701 = (_3698 + _3697) * 0.5f;
                                    float _3712 = OutputMaxLum * 1.5f;
                                    float _3713 = _3712 + -0.5f;
                                    float _3714 = saturate(_3701);
                                    do {
                                      if (_3714 > _3713) {
                                        float _3718 = 1.5f - _3712;
                                        float _3719 = (_3714 - _3713) / _3718;
                                        float _3720 = _3719 * _3719;
                                        float _3722 = (_3720 * _3719) * 2.0f;
                                        float _3723 = _3720 * 3.0f;
                                        _3736 = ((((_3723 - _3722) * OutputMaxLum) + (((_3720 * (_3719 + -2.0f)) + _3719) * _3718)) + (((1.0f - _3723) + _3722) * _3713));
                                      } else {
                                        _3736 = _3714;
                                      }
                                      float _3737 = saturate(_3736);
                                      float _3738 = 1.0f - _3737;
                                      float _3739 = _3738 * _3738;
                                      float _3742 = ((_3739 * _3739) * OutputMinLum) + _3737;
                                      float _3745 = min(1.0f, (_3742 / max(_3701, 1.0000000116860974e-07f)));
                                      float _3746 = _3745 * _3745;
                                      float _3747 = _3746 * (((_3697 * 1.613800048828125f) - (_3698 * 3.323499917984009f)) + (_3699 * 1.7096999883651733f));
                                      float _3748 = _3746 * (((_3697 * 4.378200054168701f) - (_3698 * 4.24560022354126f)) - (_3699 * 0.13259999454021454f));
                                      float _3749 = _3747 * 0.00860000029206276f;
                                      float _3751 = _3748 * 0.11100000143051147f;
                                      float _3768 = exp2(log2(saturate((_3749 + _3742) + _3751)) * 0.012683313339948654f);
                                      float _3769 = exp2(log2(saturate((_3742 - _3749) - _3751)) * 0.012683313339948654f);
                                      float _3770 = exp2(log2(saturate(((_3747 * 0.5600000023841858f) + _3742) - (_3748 * 0.3206000030040741f))) * 0.012683313339948654f);
                                      float _3795 = exp2(log2(max(0.0f, ((-0.0f - (_3768 + -0.8359375f)) / ((_3768 * 18.6875f) + -18.8515625f)))) * 6.277394771575928f);
                                      float _3798 = exp2(log2(max(0.0f, ((-0.0f - (_3769 + -0.8359375f)) / ((_3769 * 18.6875f) + -18.8515625f)))) * 6.277394771575928f) * 10000.0f;
                                      float _3799 = exp2(log2(max(0.0f, ((-0.0f - (_3770 + -0.8359375f)) / ((_3770 * 18.6875f) + -18.8515625f)))) * 6.277394771575928f) * 10000.0f;
                                      float _3818 = exp2(log2(mad(0.0697999969124794f, _3799, mad(-2.506500005722046f, _3798, (_3795 * 34366.0f))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                      float _3819 = exp2(log2(mad(-0.1923000067472458f, _3799, mad(1.9836000204086304f, _3798, (_3795 * -7913.0f))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                      float _3820 = exp2(log2(mad(1.124899983406067f, _3799, mad(-0.09889999777078629f, _3798, (_3795 * -259.0f))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                      _3890 = exp2(log2((1.0f / ((_3818 * 18.6875f) + 1.0f)) * ((_3818 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                      _3891 = exp2(log2((1.0f / ((_3819 * 18.6875f) + 1.0f)) * ((_3819 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                      _3892 = exp2(log2((1.0f / ((_3820 * 18.6875f) + 1.0f)) * ((_3820 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
                    float _3863 = mad((WorkingColorSpace_ToAP1[0].z), _1226, mad((WorkingColorSpace_ToAP1[0].y), _1225, ((WorkingColorSpace_ToAP1[0].x) * _1224)));
                    float _3866 = mad((WorkingColorSpace_ToAP1[1].z), _1226, mad((WorkingColorSpace_ToAP1[1].y), _1225, ((WorkingColorSpace_ToAP1[1].x) * _1224)));
                    float _3869 = mad((WorkingColorSpace_ToAP1[2].z), _1226, mad((WorkingColorSpace_ToAP1[2].y), _1225, ((WorkingColorSpace_ToAP1[2].x) * _1224)));
                    _3890 = exp2(log2(mad(_45, _3869, mad(_44, _3866, (_3863 * _43)))) * InverseGamma.z);
                    _3891 = exp2(log2(mad(_48, _3869, mad(_47, _3866, (_3863 * _46)))) * InverseGamma.z);
                    _3892 = exp2(log2(mad(_51, _3869, mad(_50, _3866, (_3863 * _49)))) * InverseGamma.z);
                  }
                }
              }
            } else {
              _3890 = _1210;
              _3891 = _1211;
              _3892 = _1212;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_3890 * 0.9523810148239136f);
  SV_Target.y = (_3891 * 0.9523810148239136f);
  SV_Target.z = (_3892 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

#include "../../common.hlsl"

// Found in Slitterhead

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

cbuffer _RootShaderParameters : register(b0) {
  float4 LUTWeights[2] : packoffset(c005.x);
  float4 ACESMinMaxData : packoffset(c008.x);
  float4 ACESMidData : packoffset(c009.x);
  float4 ACESCoefsLow_0 : packoffset(c010.x);
  float4 ACESCoefsHigh_0 : packoffset(c011.x);
  float ACESCoefsLow_4 : packoffset(c012.x);
  float ACESCoefsHigh_4 : packoffset(c012.y);
  float ACESSceneColorMultiplier : packoffset(c012.z);
  float3 HyperbolaToe : packoffset(c013.x);
  float2 HyperbolaMid : packoffset(c014.x);
  float3 HyperbolaShoulder : packoffset(c015.x);
  float4 HyperbolaThreshold : packoffset(c016.x);
  float2 HyperbolaMultiplier : packoffset(c017.x);
  float4 OverlayColor : packoffset(c018.x);
  float3 ColorScale : packoffset(c019.x);
  float4 ColorSaturation : packoffset(c020.x);
  float4 ColorContrast : packoffset(c021.x);
  float4 ColorGamma : packoffset(c022.x);
  float4 ColorGain : packoffset(c023.x);
  float4 ColorOffset : packoffset(c024.x);
  float4 ColorSaturationShadows : packoffset(c025.x);
  float4 ColorContrastShadows : packoffset(c026.x);
  float4 ColorGammaShadows : packoffset(c027.x);
  float4 ColorGainShadows : packoffset(c028.x);
  float4 ColorOffsetShadows : packoffset(c029.x);
  float4 ColorSaturationMidtones : packoffset(c030.x);
  float4 ColorContrastMidtones : packoffset(c031.x);
  float4 ColorGammaMidtones : packoffset(c032.x);
  float4 ColorGainMidtones : packoffset(c033.x);
  float4 ColorOffsetMidtones : packoffset(c034.x);
  float4 ColorSaturationHighlights : packoffset(c035.x);
  float4 ColorContrastHighlights : packoffset(c036.x);
  float4 ColorGammaHighlights : packoffset(c037.x);
  float4 ColorGainHighlights : packoffset(c038.x);
  float4 ColorOffsetHighlights : packoffset(c039.x);
  float LUTSize : packoffset(c040.x);
  float WhiteTemp : packoffset(c040.y);
  float WhiteTint : packoffset(c040.z);
  float ColorCorrectionShadowsMax : packoffset(c040.w);
  float ColorCorrectionHighlightsMin : packoffset(c041.x);
  float ColorCorrectionHighlightsMax : packoffset(c041.y);
  float BlueCorrection : packoffset(c041.z);
  float ExpandGamut : packoffset(c041.w);
  float ToneCurveAmount : packoffset(c042.x);
  float FilmSlope : packoffset(c042.y);
  float FilmToe : packoffset(c042.z);
  float FilmShoulder : packoffset(c042.w);
  float FilmBlackClip : packoffset(c043.x);
  float FilmWhiteClip : packoffset(c043.y);
  uint bUseMobileTonemapper : packoffset(c043.z);
  uint bIsTemperatureWhiteBalance : packoffset(c043.w);
  float3 MappingPolynomial : packoffset(c044.x);
  float3 InverseGamma : packoffset(c045.x);
  uint OutputDevice : packoffset(c045.w);
  uint OutputGamut : packoffset(c046.x);
  float OutputMaxLuminance : packoffset(c046.y);
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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _14 = 0.5f / LUTSize;
  float _19 = LUTSize + -1.0f;
  float _20 = (LUTSize * (TEXCOORD.x - _14)) / _19;
  float _21 = (LUTSize * (TEXCOORD.y - _14)) / _19;
  float _23 = float((uint)SV_RenderTargetArrayIndex) / _19;
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
  float _1181;
  float _1182;
  float _1183;
  float _1194;
  float _1205;
  float _1318;
  float _1319;
  float _1320;
  float _1402;
  float _1403;
  float _1404;
  float _1581;
  float _1582;
  float _1583;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _32 = ((uint)(OutputGamut) == 4);
        _43 = select(_32, 1.0f, 1.7050515413284302f);
        _44 = select(_32, 0.0f, -0.6217905879020691f);
        _45 = select(_32, 0.0f, -0.0832584798336029f);
        _46 = select(_32, 0.0f, -0.13025718927383423f);
        _47 = select(_32, 1.0f, 1.1408027410507202f);
        _48 = select(_32, 0.0f, -0.010548528283834457f);
        _49 = select(_32, 0.0f, -0.024003278464078903f);
        _50 = select(_32, 0.0f, -0.1289687603712082f);
        _51 = select(_32, 1.0f, 1.152971863746643f);
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
      _43 = 1.02579927444458f;
      _44 = -0.020052503794431686f;
      _45 = -0.0057713985443115234f;
      _46 = -0.0022350111976265907f;
      _47 = 1.0045825242996216f;
      _48 = -0.002352306619286537f;
      _49 = -0.005014004185795784f;
      _50 = -0.025293385609984398f;
      _51 = 1.0304402112960815f;
    }
  } else {
    _43 = 1.379158854484558f;
    _44 = -0.3088507056236267f;
    _45 = -0.07034677267074585f;
    _46 = -0.06933528929948807f;
    _47 = 1.0822921991348267f;
    _48 = -0.012962047010660172f;
    _49 = -0.002159259282052517f;
    _50 = -0.045465391129255295f;
    _51 = 1.0477596521377563f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
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
  bool _138 = ((uint)(bIsTemperatureWhiteBalance) != 0);
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
  float _420 = ((mad(-0.06368283927440643f, _385, mad(-0.32929131388664246f, _382, (_379 * 1.370412826538086f))) - _379) * _404) + _379;
  float _421 = ((mad(-0.010861567221581936f, _385, mad(1.0970908403396606f, _382, (_379 * -0.08343426138162613f))) - _382) * _404) + _382;
  float _422 = ((mad(1.203694462776184f, _385, mad(-0.09862564504146576f, _382, (_379 * -0.02579325996339321f))) - _385) * _404) + _385;
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
  float _792 = max((((_673 * (((ColorOffset.x + ColorOffsetHighlights.x) + _570) + (((ColorGain.x * ColorGainHighlights.x) * _579) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _597) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _606) * _497) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _588)))))) + (_561 * (((ColorOffset.x + ColorOffsetShadows.x) + _437) + (((ColorGain.x * ColorGainShadows.x) * _451) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _479) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _493) * _497) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _465))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _682) + (((ColorGain.x * ColorGainMidtones.x) * _691) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _709) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _718) * _497) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _700))))) * _776)), 9.999999974752427e-07f);
  float _793 = max((((_673 * (((ColorOffset.y + ColorOffsetHighlights.y) + _570) + (((ColorGain.y * ColorGainHighlights.y) * _579) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _597) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _606) * _498) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _588)))))) + (_561 * (((ColorOffset.y + ColorOffsetShadows.y) + _437) + (((ColorGain.y * ColorGainShadows.y) * _451) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _479) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _493) * _498) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _465))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _682) + (((ColorGain.y * ColorGainMidtones.y) * _691) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _709) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _718) * _498) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _700))))) * _776)), 9.999999974752427e-07f);
  float _794 = max((((_673 * (((ColorOffset.z + ColorOffsetHighlights.z) + _570) + (((ColorGain.z * ColorGainHighlights.z) * _579) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _597) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _606) * _499) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _588)))))) + (_561 * (((ColorOffset.z + ColorOffsetShadows.z) + _437) + (((ColorGain.z * ColorGainShadows.z) * _451) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _479) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _493) * _499) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _465))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _682) + (((ColorGain.z * ColorGainMidtones.z) * _691) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _709) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _718) * _499) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _700))))) * _776)), 9.999999974752427e-07f);
  float _813 = (log2(_792) + 9.720000267028809f) * 0.05707762390375137f;
  float _814 = (log2(_793) + 9.720000267028809f) * 0.05707762390375137f;
  float _815 = (log2(_794) + 9.720000267028809f) * 0.05707762390375137f;
  float _822 = ((((_792 * 10.540237426757812f) + 0.072905533015728f) - _813) * select((_792 > 0.0078125f), 0.0f, 1.0f)) + _813;
  float _823 = ((((_793 * 10.540237426757812f) + 0.072905533015728f) - _814) * select((_793 > 0.0078125f), 0.0f, 1.0f)) + _814;
  float _824 = ((((_794 * 10.540237426757812f) + 0.072905533015728f) - _815) * select((_794 > 0.0078125f), 0.0f, 1.0f)) + _815;
  float _828 = (_823 * 0.9375f) + 0.03125f;
  float _835 = _824 * 15.0f;
  float _836 = floor(_835);
  float _837 = _835 - _836;
  float _839 = (((_822 * 0.9375f) + 0.03125f) + _836) * 0.0625f;
  float4 _842 = Textures_1.Sample(Samplers_1, float2(_839, _828));
  float _846 = _839 + 0.0625f;
  float4 _849 = Textures_1.Sample(Samplers_1, float2(_846, _828));
  float4 _872 = Textures_2.Sample(Samplers_2, float2(_839, _828));
  float4 _878 = Textures_2.Sample(Samplers_2, float2(_846, _828));
  float _894 = (((lerp(_842.x, _849.x, _837)) * (LUTWeights[0].y)) + (_822 * (LUTWeights[0].x))) + ((lerp(_872.x, _878.x, _837)) * (LUTWeights[0].z));
  float _895 = (((lerp(_842.y, _849.y, _837)) * (LUTWeights[0].y)) + (_823 * (LUTWeights[0].x))) + ((lerp(_872.y, _878.y, _837)) * (LUTWeights[0].z));
  float _896 = (((lerp(_842.z, _849.z, _837)) * (LUTWeights[0].y)) + (_824 * (LUTWeights[0].x))) + ((lerp(_872.z, _878.z, _837)) * (LUTWeights[0].z));
  float _915 = exp2((_894 * 17.520000457763672f) + -9.720000267028809f);
  float _916 = exp2((_895 * 17.520000457763672f) + -9.720000267028809f);
  float _917 = exp2((_896 * 17.520000457763672f) + -9.720000267028809f);
  float _924 = ((((_894 + -0.072905533015728f) * 0.09487452358007431f) - _915) * select((_894 > 0.155251145362854f), 0.0f, 1.0f)) + _915;
  float _925 = ((((_895 + -0.072905533015728f) * 0.09487452358007431f) - _916) * select((_895 > 0.155251145362854f), 0.0f, 1.0f)) + _916;
  float _926 = ((((_896 + -0.072905533015728f) * 0.09487452358007431f) - _917) * select((_896 > 0.155251145362854f), 0.0f, 1.0f)) + _917;

  SetUntonemappedAP1(float3(_924, _925, _926));

  float _963 = ((mad(0.061360642313957214f, _926, mad(-4.540197551250458e-09f, _925, (_924 * 0.9386394023895264f))) - _924) * BlueCorrection) + _924;
  float _964 = ((mad(0.169205904006958f, _926, mad(0.8307942152023315f, _925, (_924 * 6.775371730327606e-08f))) - _925) * BlueCorrection) + _925;
  float _965 = (mad(-2.3283064365386963e-10f, _925, (_924 * -9.313225746154785e-10f)) * BlueCorrection) + _926;
  float _980 = dot(float3(_963, _964, _965), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _987 = ((_963 - _980) * 0.9599999785423279f) + _980;
  float _988 = ((_964 - _980) * 0.9599999785423279f) + _980;
  float _989 = ((_965 - _980) * 0.9599999785423279f) + _980;
  float _990 = -0.0f - HyperbolaToe.x;
  float _1006 = -0.0f - HyperbolaShoulder.x;
  float _1025 = select((_987 < HyperbolaThreshold.x), ((_990 / (_987 + HyperbolaToe.y)) + HyperbolaToe.z), select((_987 < HyperbolaThreshold.y), ((_987 * HyperbolaMid.x) + HyperbolaMid.y), ((_1006 / (_987 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _1026 = select((_988 < HyperbolaThreshold.x), ((_990 / (_988 + HyperbolaToe.y)) + HyperbolaToe.z), select((_988 < HyperbolaThreshold.y), ((_988 * HyperbolaMid.x) + HyperbolaMid.y), ((_1006 / (_988 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _1027 = select((_989 < HyperbolaThreshold.x), ((_990 / (_989 + HyperbolaToe.y)) + HyperbolaToe.z), select((_989 < HyperbolaThreshold.y), ((_989 * HyperbolaMid.x) + HyperbolaMid.y), ((_1006 / (_989 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _1028 = dot(float3(_1025, _1026, _1027), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1046 = (((_1028 - _963) + ((_1025 - _1028) * 0.9300000071525574f)) * ToneCurveAmount) + _963;
  float _1047 = (((_1028 - _964) + ((_1026 - _1028) * 0.9300000071525574f)) * ToneCurveAmount) + _964;
  float _1048 = (((_1028 - _965) + ((_1027 - _1028) * 0.9300000071525574f)) * ToneCurveAmount) + _965;
  float _1064 = ((mad(-0.06537103652954102f, _1048, mad(1.451815478503704e-06f, _1047, (_1046 * 1.065374732017517f))) - _1046) * BlueCorrection) + _1046;
  float _1065 = ((mad(-0.20366770029067993f, _1048, mad(1.2036634683609009f, _1047, (_1046 * -2.57161445915699e-07f))) - _1047) * BlueCorrection) + _1047;
  float _1066 = ((mad(0.9999996423721313f, _1048, mad(2.0954757928848267e-08f, _1047, (_1046 * 1.862645149230957e-08f))) - _1048) * BlueCorrection) + _1048;

  SetTonemappedAP1(_1064, _1065, _1066);

  float _1076 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1066, mad((WorkingColorSpace_FromAP1[0].y), _1065, ((WorkingColorSpace_FromAP1[0].x) * _1064))));
  float _1077 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1066, mad((WorkingColorSpace_FromAP1[1].y), _1065, ((WorkingColorSpace_FromAP1[1].x) * _1064))));
  float _1078 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1066, mad((WorkingColorSpace_FromAP1[2].y), _1065, ((WorkingColorSpace_FromAP1[2].x) * _1064))));
  float _1104 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1076)) * _1076) + MappingPolynomial.z);
  float _1105 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1077)) * _1077) + MappingPolynomial.z);
  float _1106 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1078)) * _1078) + MappingPolynomial.z);
  float _1113 = ((OverlayColor.x - _1104) * OverlayColor.w) + _1104;
  float _1114 = ((OverlayColor.y - _1105) * OverlayColor.w) + _1105;
  float _1115 = ((OverlayColor.z - _1106) * OverlayColor.w) + _1106;
  float _1116 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _926, mad((WorkingColorSpace_FromAP1[0].y), _925, (_924 * (WorkingColorSpace_FromAP1[0].x))));
  float _1117 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _926, mad((WorkingColorSpace_FromAP1[1].y), _925, (_924 * (WorkingColorSpace_FromAP1[1].x))));
  float _1118 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _926, mad((WorkingColorSpace_FromAP1[2].y), _925, (_924 * (WorkingColorSpace_FromAP1[2].x))));
  float _1125 = ((OverlayColor.x - _1116) * OverlayColor.w) + _1116;
  float _1126 = ((OverlayColor.y - _1117) * OverlayColor.w) + _1117;
  float _1127 = ((OverlayColor.z - _1118) * OverlayColor.w) + _1118;
  float _1139 = exp2(log2(max(0.0f, _1113)) * InverseGamma.y);
  float _1140 = exp2(log2(max(0.0f, _1114)) * InverseGamma.y);
  float _1141 = exp2(log2(max(0.0f, _1115)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1139, _1140, _1141), OutputDevice);
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1164 = mad((WorkingColorSpace_ToAP1[0].z), _1141, mad((WorkingColorSpace_ToAP1[0].y), _1140, ((WorkingColorSpace_ToAP1[0].x) * _1139)));
        float _1167 = mad((WorkingColorSpace_ToAP1[1].z), _1141, mad((WorkingColorSpace_ToAP1[1].y), _1140, ((WorkingColorSpace_ToAP1[1].x) * _1139)));
        float _1170 = mad((WorkingColorSpace_ToAP1[2].z), _1141, mad((WorkingColorSpace_ToAP1[2].y), _1140, ((WorkingColorSpace_ToAP1[2].x) * _1139)));
        _1181 = mad(_45, _1170, mad(_44, _1167, (_1164 * _43)));
        _1182 = mad(_48, _1170, mad(_47, _1167, (_1164 * _46)));
        _1183 = mad(_51, _1170, mad(_50, _1167, (_1164 * _49)));
      } else {
        _1181 = _1139;
        _1182 = _1140;
        _1183 = _1141;
      }
      do {
        if (_1181 < 0.0031306699384003878f) {
          _1194 = (_1181 * 12.920000076293945f);
        } else {
          _1194 = (((pow(_1181, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1182 < 0.0031306699384003878f) {
            _1205 = (_1182 * 12.920000076293945f);
          } else {
            _1205 = (((pow(_1182, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1183 < 0.0031306699384003878f) {
            _1581 = _1194;
            _1582 = _1205;
            _1583 = (_1183 * 12.920000076293945f);
          } else {
            _1581 = _1194;
            _1582 = _1205;
            _1583 = (((pow(_1183, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1232 = mad((WorkingColorSpace_ToAP1[0].z), _1141, mad((WorkingColorSpace_ToAP1[0].y), _1140, ((WorkingColorSpace_ToAP1[0].x) * _1139)));
      float _1235 = mad((WorkingColorSpace_ToAP1[1].z), _1141, mad((WorkingColorSpace_ToAP1[1].y), _1140, ((WorkingColorSpace_ToAP1[1].x) * _1139)));
      float _1238 = mad((WorkingColorSpace_ToAP1[2].z), _1141, mad((WorkingColorSpace_ToAP1[2].y), _1140, ((WorkingColorSpace_ToAP1[2].x) * _1139)));
      float _1248 = max(6.103519990574569e-05f, mad(_45, _1238, mad(_44, _1235, (_1232 * _43))));
      float _1249 = max(6.103519990574569e-05f, mad(_48, _1238, mad(_47, _1235, (_1232 * _46))));
      float _1250 = max(6.103519990574569e-05f, mad(_51, _1238, mad(_50, _1235, (_1232 * _49))));
      _1581 = min((_1248 * 4.5f), ((exp2(log2(max(_1248, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1582 = min((_1249 * 4.5f), ((exp2(log2(max(_1249, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1583 = min((_1250 * 4.5f), ((exp2(log2(max(_1250, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        float _1282 = HyperbolaMultiplier.x * _1113;
        float _1283 = HyperbolaMultiplier.x * _1114;
        float _1284 = HyperbolaMultiplier.x * _1115;
        float _1299 = mad((WorkingColorSpace_ToAP1[0].z), _1284, mad((WorkingColorSpace_ToAP1[0].y), _1283, ((WorkingColorSpace_ToAP1[0].x) * _1282)));
        float _1302 = mad((WorkingColorSpace_ToAP1[1].z), _1284, mad((WorkingColorSpace_ToAP1[1].y), _1283, ((WorkingColorSpace_ToAP1[1].x) * _1282)));
        float _1305 = mad((WorkingColorSpace_ToAP1[2].z), _1284, mad((WorkingColorSpace_ToAP1[2].y), _1283, ((WorkingColorSpace_ToAP1[2].x) * _1282)));
        do {
          if (!((uint)(OutputDevice) == 5)) {
            _1318 = mad(_45, _1305, mad(_44, _1302, (_1299 * _43)));
            _1319 = mad(_48, _1305, mad(_47, _1302, (_1299 * _46)));
            _1320 = mad(_51, _1305, mad(_50, _1302, (_1299 * _49)));
          } else {
            _1318 = _1299;
            _1319 = _1302;
            _1320 = _1305;
          }
          float _1330 = exp2(log2(_1318 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1331 = exp2(log2(_1319 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1332 = exp2(log2(_1320 * 9.999999747378752e-05f) * 0.1593017578125f);
          _1581 = exp2(log2((1.0f / ((_1330 * 18.6875f) + 1.0f)) * ((_1330 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1582 = exp2(log2((1.0f / ((_1331 * 18.6875f) + 1.0f)) * ((_1331 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1583 = exp2(log2((1.0f / ((_1332 * 18.6875f) + 1.0f)) * ((_1332 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        } while (false);
      } else {
        if (((uint)(OutputDevice) & -3) == 4) {
          float _1366 = HyperbolaMultiplier.x * _1113;
          float _1367 = HyperbolaMultiplier.x * _1114;
          float _1368 = HyperbolaMultiplier.x * _1115;
          float _1383 = mad((WorkingColorSpace_ToAP1[0].z), _1368, mad((WorkingColorSpace_ToAP1[0].y), _1367, ((WorkingColorSpace_ToAP1[0].x) * _1366)));
          float _1386 = mad((WorkingColorSpace_ToAP1[1].z), _1368, mad((WorkingColorSpace_ToAP1[1].y), _1367, ((WorkingColorSpace_ToAP1[1].x) * _1366)));
          float _1389 = mad((WorkingColorSpace_ToAP1[2].z), _1368, mad((WorkingColorSpace_ToAP1[2].y), _1367, ((WorkingColorSpace_ToAP1[2].x) * _1366)));
          do {
            if (!((uint)(OutputDevice) == 6)) {
              _1402 = mad(_45, _1389, mad(_44, _1386, (_1383 * _43)));
              _1403 = mad(_48, _1389, mad(_47, _1386, (_1383 * _46)));
              _1404 = mad(_51, _1389, mad(_50, _1386, (_1383 * _49)));
            } else {
              _1402 = _1383;
              _1403 = _1386;
              _1404 = _1389;
            }
            float _1414 = exp2(log2(_1402 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1415 = exp2(log2(_1403 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1416 = exp2(log2(_1404 * 9.999999747378752e-05f) * 0.1593017578125f);
            _1581 = exp2(log2((1.0f / ((_1414 * 18.6875f) + 1.0f)) * ((_1414 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1582 = exp2(log2((1.0f / ((_1415 * 18.6875f) + 1.0f)) * ((_1415 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1583 = exp2(log2((1.0f / ((_1416 * 18.6875f) + 1.0f)) * ((_1416 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } while (false);
        } else {
          if ((uint)(OutputDevice) == 7) {
            float _1461 = mad((WorkingColorSpace_ToAP1[0].z), _1127, mad((WorkingColorSpace_ToAP1[0].y), _1126, ((WorkingColorSpace_ToAP1[0].x) * _1125)));
            float _1464 = mad((WorkingColorSpace_ToAP1[1].z), _1127, mad((WorkingColorSpace_ToAP1[1].y), _1126, ((WorkingColorSpace_ToAP1[1].x) * _1125)));
            float _1467 = mad((WorkingColorSpace_ToAP1[2].z), _1127, mad((WorkingColorSpace_ToAP1[2].y), _1126, ((WorkingColorSpace_ToAP1[2].x) * _1125)));
            float _1486 = exp2(log2(mad(_45, _1467, mad(_44, _1464, (_1461 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1487 = exp2(log2(mad(_48, _1467, mad(_47, _1464, (_1461 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1488 = exp2(log2(mad(_51, _1467, mad(_50, _1464, (_1461 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _1581 = exp2(log2((1.0f / ((_1486 * 18.6875f) + 1.0f)) * ((_1486 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1582 = exp2(log2((1.0f / ((_1487 * 18.6875f) + 1.0f)) * ((_1487 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1583 = exp2(log2((1.0f / ((_1488 * 18.6875f) + 1.0f)) * ((_1488 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _1535 = mad((WorkingColorSpace_ToAP1[0].z), _1115, mad((WorkingColorSpace_ToAP1[0].y), _1114, ((WorkingColorSpace_ToAP1[0].x) * _1113)));
                float _1538 = mad((WorkingColorSpace_ToAP1[1].z), _1115, mad((WorkingColorSpace_ToAP1[1].y), _1114, ((WorkingColorSpace_ToAP1[1].x) * _1113)));
                float _1541 = mad((WorkingColorSpace_ToAP1[2].z), _1115, mad((WorkingColorSpace_ToAP1[2].y), _1114, ((WorkingColorSpace_ToAP1[2].x) * _1113)));
                _1581 = mad(_45, _1541, mad(_44, _1538, (_1535 * _43)));
                _1582 = mad(_48, _1541, mad(_47, _1538, (_1535 * _46)));
                _1583 = mad(_51, _1541, mad(_50, _1538, (_1535 * _49)));
              } else {
                float _1554 = mad((WorkingColorSpace_ToAP1[0].z), _1141, mad((WorkingColorSpace_ToAP1[0].y), _1140, ((WorkingColorSpace_ToAP1[0].x) * _1139)));
                float _1557 = mad((WorkingColorSpace_ToAP1[1].z), _1141, mad((WorkingColorSpace_ToAP1[1].y), _1140, ((WorkingColorSpace_ToAP1[1].x) * _1139)));
                float _1560 = mad((WorkingColorSpace_ToAP1[2].z), _1141, mad((WorkingColorSpace_ToAP1[2].y), _1140, ((WorkingColorSpace_ToAP1[2].x) * _1139)));
                _1581 = exp2(log2(mad(_45, _1560, mad(_44, _1557, (_1554 * _43)))) * InverseGamma.z);
                _1582 = exp2(log2(mad(_48, _1560, mad(_47, _1557, (_1554 * _46)))) * InverseGamma.z);
                _1583 = exp2(log2(mad(_51, _1560, mad(_50, _1557, (_1554 * _49)))) * InverseGamma.z);
              }
            } else {
              _1581 = _1125;
              _1582 = _1126;
              _1583 = _1127;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_1581 * 0.9523810148239136f);
  SV_Target.y = (_1582 * 0.9523810148239136f);
  SV_Target.z = (_1583 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

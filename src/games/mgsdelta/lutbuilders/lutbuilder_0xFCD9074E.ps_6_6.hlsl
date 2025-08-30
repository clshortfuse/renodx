#include "./filmiclutbuilder.hlsl"

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
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;
  bool is_hdr = (output_device >= 3u && output_device <= 6u);

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
  float _112;
  float _113;
  float _114;
  float _162;
  float _792;
  float _858;
  float _1222;
  float _1314;
  float _1347;
  float _1361;
  float _1425;
  float _1676;
  float _1709;
  float _1723;
  float _1894;
  float _1927;
  float _1941;
  float _1992;
  float _2274;
  float _2275;
  float _2276;
  float _2287;
  float _2298;
  float _2466;
  float _2499;
  float _2513;
  float _2552;
  float _2662;
  float _2736;
  float _2810;
  float _2915;
  float _2916;
  float _2917;
  float _2928;
  float _2929;
  float _2930;
  float _3079;
  float _3112;
  float _3126;
  float _3165;
  float _3275;
  float _3349;
  float _3423;
  float _3528;
  float _3529;
  float _3530;
  float _3541;
  float _3542;
  float _3543;
  float _3696;
  float _3697;
  float _3698;
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
    float _89 = exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 100.0f;
    float _90 = exp2(log2(max(0.0f, (_63 + -0.8359375f)) / (18.8515625f - (_63 * 18.6875f))) * 6.277394771575928f) * 100.0f;
    float _91 = exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 100.0f;
    _109 = _89;
    _110 = _90;
    _111 = _91;
    _112 = _89;
    _113 = _90;
    _114 = _91;
  } else {
    _109 = ((exp2((_20 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _110 = ((exp2((_21 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _111 = ((exp2((_23 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _112 = 0.0f;
    _113 = 0.0f;
    _114 = 0.0f;
  }

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  bool _141 = (bIsTemperatureWhiteBalance != 0);
  float _145 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _162 = (((((2967800.0f - (_145 * 4607000064.0f)) * _145) + 99.11000061035156f) * _145) + 0.24406300485134125f);
  } else {
    _162 = (((((1901800.0f - (_145 * 2006400000.0f)) * _145) + 247.47999572753906f) * _145) + 0.23703999817371368f);
  }
  float _176 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _183 = WhiteTemp * WhiteTemp;
  float _186 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_183 * 1.6145605741257896e-07f));
  float _191 = ((_176 * 2.0f) + 4.0f) - (_186 * 8.0f);
  float _192 = (_176 * 3.0f) / _191;
  float _194 = (_186 * 2.0f) / _191;
  bool _195 = (WhiteTemp < 4000.0f);
  float _204 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _206 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_183 * 1.5317699909210205f)) / (_204 * _204);
  float _213 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _183;
  float _215 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_183 * 308.60699462890625f)) / (_213 * _213);
  float _217 = rsqrt(dot(float2(_206, _215), float2(_206, _215)));
  float _218 = WhiteTint * 0.05000000074505806f;
  float _221 = ((_218 * _215) * _217) + _176;
  float _224 = _186 - ((_218 * _206) * _217);
  float _229 = (4.0f - (_224 * 8.0f)) + (_221 * 2.0f);
  float _235 = (((_221 * 3.0f) / _229) - _192) + select(_195, _192, _162);
  float _236 = (((_224 * 2.0f) / _229) - _194) + select(_195, _194, (((_162 * 2.869999885559082f) + -0.2750000059604645f) - ((_162 * _162) * 3.0f)));
  float _237 = select(_141, _235, 0.3127000033855438f);
  float _238 = select(_141, _236, 0.32899999618530273f);
  float _239 = select(_141, 0.3127000033855438f, _235);
  float _240 = select(_141, 0.32899999618530273f, _236);
  float _241 = max(_238, 1.000000013351432e-10f);
  float _242 = _237 / _241;
  float _245 = ((1.0f - _237) - _238) / _241;
  float _246 = max(_240, 1.000000013351432e-10f);
  float _247 = _239 / _246;
  float _250 = ((1.0f - _239) - _240) / _246;
  float _269 = mad(-0.16140000522136688f, _250, ((_247 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _245, ((_242 * 0.8950999975204468f) + 0.266400009393692f));
  float _270 = mad(0.03669999912381172f, _250, (1.7135000228881836f - (_247 * 0.7501999735832214f))) / mad(0.03669999912381172f, _245, (1.7135000228881836f - (_242 * 0.7501999735832214f)));
  float _271 = mad(1.0296000242233276f, _250, ((_247 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _245, ((_242 * 0.03889999911189079f) + -0.06849999725818634f));
  float _272 = mad(_270, -0.7501999735832214f, 0.0f);
  float _273 = mad(_270, 1.7135000228881836f, 0.0f);
  float _274 = mad(_270, 0.03669999912381172f, -0.0f);
  float _275 = mad(_271, 0.03889999911189079f, 0.0f);
  float _276 = mad(_271, -0.06849999725818634f, 0.0f);
  float _277 = mad(_271, 1.0296000242233276f, 0.0f);
  float _280 = mad(0.1599626988172531f, _275, mad(-0.1470542997121811f, _272, (_269 * 0.883457362651825f)));
  float _283 = mad(0.1599626988172531f, _276, mad(-0.1470542997121811f, _273, (_269 * 0.26293492317199707f)));
  float _286 = mad(0.1599626988172531f, _277, mad(-0.1470542997121811f, _274, (_269 * -0.15930065512657166f)));
  float _289 = mad(0.04929120093584061f, _275, mad(0.5183603167533875f, _272, (_269 * 0.38695648312568665f)));
  float _292 = mad(0.04929120093584061f, _276, mad(0.5183603167533875f, _273, (_269 * 0.11516613513231277f)));
  float _295 = mad(0.04929120093584061f, _277, mad(0.5183603167533875f, _274, (_269 * -0.0697740763425827f)));
  float _298 = mad(0.9684867262840271f, _275, mad(0.04004279896616936f, _272, (_269 * -0.007634039502590895f)));
  float _301 = mad(0.9684867262840271f, _276, mad(0.04004279896616936f, _273, (_269 * -0.0022720457054674625f)));
  float _304 = mad(0.9684867262840271f, _277, mad(0.04004279896616936f, _274, (_269 * 0.0013765322510153055f)));
  float _307 = mad(_286, (WorkingColorSpace_ToXYZ[2].x), mad(_283, (WorkingColorSpace_ToXYZ[1].x), (_280 * (WorkingColorSpace_ToXYZ[0].x))));
  float _310 = mad(_286, (WorkingColorSpace_ToXYZ[2].y), mad(_283, (WorkingColorSpace_ToXYZ[1].y), (_280 * (WorkingColorSpace_ToXYZ[0].y))));
  float _313 = mad(_286, (WorkingColorSpace_ToXYZ[2].z), mad(_283, (WorkingColorSpace_ToXYZ[1].z), (_280 * (WorkingColorSpace_ToXYZ[0].z))));
  float _316 = mad(_295, (WorkingColorSpace_ToXYZ[2].x), mad(_292, (WorkingColorSpace_ToXYZ[1].x), (_289 * (WorkingColorSpace_ToXYZ[0].x))));
  float _319 = mad(_295, (WorkingColorSpace_ToXYZ[2].y), mad(_292, (WorkingColorSpace_ToXYZ[1].y), (_289 * (WorkingColorSpace_ToXYZ[0].y))));
  float _322 = mad(_295, (WorkingColorSpace_ToXYZ[2].z), mad(_292, (WorkingColorSpace_ToXYZ[1].z), (_289 * (WorkingColorSpace_ToXYZ[0].z))));
  float _325 = mad(_304, (WorkingColorSpace_ToXYZ[2].x), mad(_301, (WorkingColorSpace_ToXYZ[1].x), (_298 * (WorkingColorSpace_ToXYZ[0].x))));
  float _328 = mad(_304, (WorkingColorSpace_ToXYZ[2].y), mad(_301, (WorkingColorSpace_ToXYZ[1].y), (_298 * (WorkingColorSpace_ToXYZ[0].y))));
  float _331 = mad(_304, (WorkingColorSpace_ToXYZ[2].z), mad(_301, (WorkingColorSpace_ToXYZ[1].z), (_298 * (WorkingColorSpace_ToXYZ[0].z))));
  float _361 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _331, mad((WorkingColorSpace_FromXYZ[0].y), _322, (_313 * (WorkingColorSpace_FromXYZ[0].x)))), _111, mad(mad((WorkingColorSpace_FromXYZ[0].z), _328, mad((WorkingColorSpace_FromXYZ[0].y), _319, (_310 * (WorkingColorSpace_FromXYZ[0].x)))), _110, (mad((WorkingColorSpace_FromXYZ[0].z), _325, mad((WorkingColorSpace_FromXYZ[0].y), _316, (_307 * (WorkingColorSpace_FromXYZ[0].x)))) * _109)));
  float _364 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _331, mad((WorkingColorSpace_FromXYZ[1].y), _322, (_313 * (WorkingColorSpace_FromXYZ[1].x)))), _111, mad(mad((WorkingColorSpace_FromXYZ[1].z), _328, mad((WorkingColorSpace_FromXYZ[1].y), _319, (_310 * (WorkingColorSpace_FromXYZ[1].x)))), _110, (mad((WorkingColorSpace_FromXYZ[1].z), _325, mad((WorkingColorSpace_FromXYZ[1].y), _316, (_307 * (WorkingColorSpace_FromXYZ[1].x)))) * _109)));
  float _367 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _331, mad((WorkingColorSpace_FromXYZ[2].y), _322, (_313 * (WorkingColorSpace_FromXYZ[2].x)))), _111, mad(mad((WorkingColorSpace_FromXYZ[2].z), _328, mad((WorkingColorSpace_FromXYZ[2].y), _319, (_310 * (WorkingColorSpace_FromXYZ[2].x)))), _110, (mad((WorkingColorSpace_FromXYZ[2].z), _325, mad((WorkingColorSpace_FromXYZ[2].y), _316, (_307 * (WorkingColorSpace_FromXYZ[2].x)))) * _109)));
  float _382 = mad((WorkingColorSpace_ToAP1[0].z), _367, mad((WorkingColorSpace_ToAP1[0].y), _364, ((WorkingColorSpace_ToAP1[0].x) * _361)));
  float _385 = mad((WorkingColorSpace_ToAP1[1].z), _367, mad((WorkingColorSpace_ToAP1[1].y), _364, ((WorkingColorSpace_ToAP1[1].x) * _361)));
  float _388 = mad((WorkingColorSpace_ToAP1[2].z), _367, mad((WorkingColorSpace_ToAP1[2].y), _364, ((WorkingColorSpace_ToAP1[2].x) * _361)));
  float _389 = dot(float3(_382, _385, _388), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _393 = (_382 / _389) + -1.0f;
  float _394 = (_385 / _389) + -1.0f;
  float _395 = (_388 / _389) + -1.0f;
  float _407 = (1.0f - exp2(((_389 * _389) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_393, _394, _395), float3(_393, _394, _395)) * -4.0f));
  float _423 = ((mad(-0.06368321925401688f, _388, mad(-0.3292922377586365f, _385, (_382 * 1.3704125881195068f))) - _382) * _407) + _382;
  float _424 = ((mad(-0.010861365124583244f, _388, mad(1.0970927476882935f, _385, (_382 * -0.08343357592821121f))) - _385) * _407) + _385;
  float _425 = ((mad(1.2036951780319214f, _388, mad(-0.09862580895423889f, _385, (_382 * -0.02579331398010254f))) - _388) * _407) + _388;
  float _426 = dot(float3(_423, _424, _425), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _440 = ColorOffset.w + ColorOffsetShadows.w;
  float _454 = ColorGain.w * ColorGainShadows.w;
  float _468 = ColorGamma.w * ColorGammaShadows.w;
  float _482 = ColorContrast.w * ColorContrastShadows.w;
  float _496 = ColorSaturation.w * ColorSaturationShadows.w;
  float _497 = (ColorSaturation.x * ColorSaturationShadows.x) * _496;
  float _498 = (ColorSaturation.y * ColorSaturationShadows.y) * _496;
  float _499 = (ColorSaturation.z * ColorSaturationShadows.z) * _496;
  float _500 = _423 - _426;
  float _501 = _424 - _426;
  float _502 = _425 - _426;
  float _512 = (ColorContrast.x * ColorContrastShadows.x) * _482;
  float _513 = (ColorContrast.y * ColorContrastShadows.y) * _482;
  float _514 = (ColorContrast.z * ColorContrastShadows.z) * _482;
  float _533 = 1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _468);
  float _534 = 1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _468);
  float _535 = 1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _468);
  float _545 = (ColorGain.x * ColorGainShadows.x) * _454;
  float _546 = (ColorGain.y * ColorGainShadows.y) * _454;
  float _547 = (ColorGain.z * ColorGainShadows.z) * _454;
  float _551 = (ColorOffset.x + ColorOffsetShadows.x) + _440;
  float _552 = (ColorOffset.y + ColorOffsetShadows.y) + _440;
  float _553 = (ColorOffset.z + ColorOffsetShadows.z) + _440;
  float _554 = _551 + (_545 * exp2(log2(exp2(_512 * log2(max(0.0f, ((_497 * _500) + _426)) * 5.55555534362793f)) * 0.18000000715255737f) * _533));
  float _555 = _552 + (_546 * exp2(log2(exp2(_513 * log2(max(0.0f, ((_498 * _501) + _426)) * 5.55555534362793f)) * 0.18000000715255737f) * _534));
  float _556 = _553 + (_547 * exp2(log2(exp2(_514 * log2(max(0.0f, ((_499 * _502) + _426)) * 5.55555534362793f)) * 0.18000000715255737f) * _535));
  float _559 = saturate(_426 / ColorCorrectionShadowsMax);
  float _563 = (_559 * _559) * (3.0f - (_559 * 2.0f));
  float _564 = 1.0f - _563;
  float _573 = ColorOffset.w + ColorOffsetHighlights.w;
  float _582 = ColorGain.w * ColorGainHighlights.w;
  float _591 = ColorGamma.w * ColorGammaHighlights.w;
  float _600 = ColorContrast.w * ColorContrastHighlights.w;
  float _609 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _610 = (ColorSaturation.x * ColorSaturationHighlights.x) * _609;
  float _611 = (ColorSaturation.y * ColorSaturationHighlights.y) * _609;
  float _612 = (ColorSaturation.z * ColorSaturationHighlights.z) * _609;
  float _622 = (ColorContrast.x * ColorContrastHighlights.x) * _600;
  float _623 = (ColorContrast.y * ColorContrastHighlights.y) * _600;
  float _624 = (ColorContrast.z * ColorContrastHighlights.z) * _600;
  float _643 = 1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _591);
  float _644 = 1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _591);
  float _645 = 1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _591);
  float _655 = (ColorGain.x * ColorGainHighlights.x) * _582;
  float _656 = (ColorGain.y * ColorGainHighlights.y) * _582;
  float _657 = (ColorGain.z * ColorGainHighlights.z) * _582;
  float _661 = (ColorOffset.x + ColorOffsetHighlights.x) + _573;
  float _662 = (ColorOffset.y + ColorOffsetHighlights.y) + _573;
  float _663 = (ColorOffset.z + ColorOffsetHighlights.z) + _573;
  float _669 = ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin;
  float _672 = saturate((_426 - ColorCorrectionHighlightsMin) / _669);
  float _676 = (_672 * _672) * (3.0f - (_672 * 2.0f));
  float _688 = ColorOffset.w + ColorOffsetMidtones.w;
  float _697 = ColorGain.w * ColorGainMidtones.w;
  float _706 = ColorGamma.w * ColorGammaMidtones.w;
  float _715 = ColorContrast.w * ColorContrastMidtones.w;
  float _724 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _725 = (ColorSaturation.x * ColorSaturationMidtones.x) * _724;
  float _726 = (ColorSaturation.y * ColorSaturationMidtones.y) * _724;
  float _727 = (ColorSaturation.z * ColorSaturationMidtones.z) * _724;
  float _737 = (ColorContrast.x * ColorContrastMidtones.x) * _715;
  float _738 = (ColorContrast.y * ColorContrastMidtones.y) * _715;
  float _739 = (ColorContrast.z * ColorContrastMidtones.z) * _715;
  float _758 = 1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _706);
  float _759 = 1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _706);
  float _760 = 1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _706);
  float _770 = (ColorGain.x * ColorGainMidtones.x) * _697;
  float _771 = (ColorGain.y * ColorGainMidtones.y) * _697;
  float _772 = (ColorGain.z * ColorGainMidtones.z) * _697;
  float _776 = (ColorOffset.x + ColorOffsetMidtones.x) + _688;
  float _777 = (ColorOffset.y + ColorOffsetMidtones.y) + _688;
  float _778 = (ColorOffset.z + ColorOffsetMidtones.z) + _688;
  float _779 = _776 + (_770 * exp2(log2(exp2(_737 * log2(max(0.0f, ((_725 * _500) + _426)) * 5.55555534362793f)) * 0.18000000715255737f) * _758));
  float _780 = _777 + (_771 * exp2(log2(exp2(_738 * log2(max(0.0f, ((_726 * _501) + _426)) * 5.55555534362793f)) * 0.18000000715255737f) * _759));
  float _781 = _778 + (_772 * exp2(log2(exp2(_739 * log2(max(0.0f, ((_727 * _502) + _426)) * 5.55555534362793f)) * 0.18000000715255737f) * _760));
  if ((bool)(_564 > 0.5f) && (bool)(dot(float3(_779, _780, _781), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)) < dot(float3(_554, _555, _556), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)))) {
    _792 = (_564 - (_564 * (0.6000000238418579f - _563)));
  } else {
    _792 = _564;
  }
  float _794 = (1.0f - _792) - _676;
  float _805 = ((_792 * _554) + (_676 * min(1e+05f, (_661 + (_655 * exp2(log2(exp2(_622 * log2(max(0.0f, ((_610 * _500) + _426)) * 5.55555534362793f)) * 0.18000000715255737f) * _643)))))) + (_794 * _779);
  float _807 = ((_792 * _555) + (_676 * min(1e+05f, (_662 + (_656 * exp2(log2(exp2(_623 * log2(max(0.0f, ((_611 * _501) + _426)) * 5.55555534362793f)) * 0.18000000715255737f) * _644)))))) + (_794 * _780);
  float _809 = ((_792 * _556) + (min(1e+05f, (_663 + (_657 * exp2(log2(exp2(_624 * log2(max(0.0f, ((_612 * _502) + _426)) * 5.55555534362793f)) * 0.18000000715255737f) * _645)))) * _676)) + (_794 * _781);
  /* bool _836 = (bIsTemperatureWhiteBalance != 0);
  float _841 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _858 = (((((2967800.0f - (_841 * 4607000064.0f)) * _841) + 99.11000061035156f) * _841) + 0.24406300485134125f);
  } else {
    _858 = (((((1901800.0f - (_841 * 2006400000.0f)) * _841) + 247.47999572753906f) * _841) + 0.23703999817371368f);
  }
  float _872 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _879 = WhiteTemp * WhiteTemp;
  float _882 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_879 * 1.6145605741257896e-07f));
  float _887 = ((_872 * 2.0f) + 4.0f) - (_882 * 8.0f);
  float _888 = (_872 * 3.0f) / _887;
  float _890 = (_882 * 2.0f) / _887;
  bool _891 = (WhiteTemp < 4000.0f);
  float _900 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _902 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_879 * 1.5317699909210205f)) / (_900 * _900);
  float _909 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _879;
  float _911 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_879 * 308.60699462890625f)) / (_909 * _909);
  float _913 = rsqrt(dot(float2(_902, _911), float2(_902, _911)));
  float _914 = WhiteTint * 0.05000000074505806f;
  float _917 = ((_914 * _911) * _913) + _872;
  float _920 = _882 - ((_914 * _902) * _913);
  float _925 = (4.0f - (_920 * 8.0f)) + (_917 * 2.0f);
  float _931 = (((_917 * 3.0f) / _925) - _888) + select(_891, _888, _858);
  float _932 = (((_920 * 2.0f) / _925) - _890) + select(_891, _890, (((_858 * 2.869999885559082f) + -0.2750000059604645f) - ((_858 * _858) * 3.0f)));
  float _933 = select(_836, _931, 0.3127000033855438f);
  float _934 = select(_836, _932, 0.32899999618530273f);
  float _935 = select(_836, 0.3127000033855438f, _931);
  float _936 = select(_836, 0.32899999618530273f, _932);
  float _937 = max(_934, 1.000000013351432e-10f);
  float _938 = _933 / _937;
  float _941 = ((1.0f - _933) - _934) / _937;
  float _942 = max(_936, 1.000000013351432e-10f);
  float _943 = _935 / _942;
  float _946 = ((1.0f - _935) - _936) / _942;
  float _965 = mad(-0.16140000522136688f, _946, ((_943 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _941, ((_938 * 0.8950999975204468f) + 0.266400009393692f));
  float _966 = mad(0.03669999912381172f, _946, (1.7135000228881836f - (_943 * 0.7501999735832214f))) / mad(0.03669999912381172f, _941, (1.7135000228881836f - (_938 * 0.7501999735832214f)));
  float _967 = mad(1.0296000242233276f, _946, ((_943 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _941, ((_938 * 0.03889999911189079f) + -0.06849999725818634f));
  float _968 = mad(_966, -0.7501999735832214f, 0.0f);
  float _969 = mad(_966, 1.7135000228881836f, 0.0f);
  float _970 = mad(_966, 0.03669999912381172f, -0.0f);
  float _971 = mad(_967, 0.03889999911189079f, 0.0f);
  float _972 = mad(_967, -0.06849999725818634f, 0.0f);
  float _973 = mad(_967, 1.0296000242233276f, 0.0f);
  float _976 = mad(0.1599626988172531f, _971, mad(-0.1470542997121811f, _968, (_965 * 0.883457362651825f)));
  float _979 = mad(0.1599626988172531f, _972, mad(-0.1470542997121811f, _969, (_965 * 0.26293492317199707f)));
  float _982 = mad(0.1599626988172531f, _973, mad(-0.1470542997121811f, _970, (_965 * -0.15930065512657166f)));
  float _985 = mad(0.04929120093584061f, _971, mad(0.5183603167533875f, _968, (_965 * 0.38695648312568665f)));
  float _988 = mad(0.04929120093584061f, _972, mad(0.5183603167533875f, _969, (_965 * 0.11516613513231277f)));
  float _991 = mad(0.04929120093584061f, _973, mad(0.5183603167533875f, _970, (_965 * -0.0697740763425827f)));
  float _994 = mad(0.9684867262840271f, _971, mad(0.04004279896616936f, _968, (_965 * -0.007634039502590895f)));
  float _997 = mad(0.9684867262840271f, _972, mad(0.04004279896616936f, _969, (_965 * -0.0022720457054674625f)));
  float _1000 = mad(0.9684867262840271f, _973, mad(0.04004279896616936f, _970, (_965 * 0.0013765322510153055f)));
  float _1003 = mad(_982, (WorkingColorSpace_ToXYZ[2].x), mad(_979, (WorkingColorSpace_ToXYZ[1].x), (_976 * (WorkingColorSpace_ToXYZ[0].x))));
  float _1006 = mad(_982, (WorkingColorSpace_ToXYZ[2].y), mad(_979, (WorkingColorSpace_ToXYZ[1].y), (_976 * (WorkingColorSpace_ToXYZ[0].y))));
  float _1009 = mad(_982, (WorkingColorSpace_ToXYZ[2].z), mad(_979, (WorkingColorSpace_ToXYZ[1].z), (_976 * (WorkingColorSpace_ToXYZ[0].z))));
  float _1012 = mad(_991, (WorkingColorSpace_ToXYZ[2].x), mad(_988, (WorkingColorSpace_ToXYZ[1].x), (_985 * (WorkingColorSpace_ToXYZ[0].x))));
  float _1015 = mad(_991, (WorkingColorSpace_ToXYZ[2].y), mad(_988, (WorkingColorSpace_ToXYZ[1].y), (_985 * (WorkingColorSpace_ToXYZ[0].y))));
  float _1018 = mad(_991, (WorkingColorSpace_ToXYZ[2].z), mad(_988, (WorkingColorSpace_ToXYZ[1].z), (_985 * (WorkingColorSpace_ToXYZ[0].z))));
  float _1021 = mad(_1000, (WorkingColorSpace_ToXYZ[2].x), mad(_997, (WorkingColorSpace_ToXYZ[1].x), (_994 * (WorkingColorSpace_ToXYZ[0].x))));
  float _1024 = mad(_1000, (WorkingColorSpace_ToXYZ[2].y), mad(_997, (WorkingColorSpace_ToXYZ[1].y), (_994 * (WorkingColorSpace_ToXYZ[0].y))));
  float _1027 = mad(_1000, (WorkingColorSpace_ToXYZ[2].z), mad(_997, (WorkingColorSpace_ToXYZ[1].z), (_994 * (WorkingColorSpace_ToXYZ[0].z))));
  float _1057 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _1027, mad((WorkingColorSpace_FromXYZ[0].y), _1018, (_1009 * (WorkingColorSpace_FromXYZ[0].x)))), _114, mad(mad((WorkingColorSpace_FromXYZ[0].z), _1024, mad((WorkingColorSpace_FromXYZ[0].y), _1015, (_1006 * (WorkingColorSpace_FromXYZ[0].x)))), _113, (mad((WorkingColorSpace_FromXYZ[0].z), _1021, mad((WorkingColorSpace_FromXYZ[0].y), _1012, (_1003 * (WorkingColorSpace_FromXYZ[0].x)))) * _112)));
  float _1060 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _1027, mad((WorkingColorSpace_FromXYZ[1].y), _1018, (_1009 * (WorkingColorSpace_FromXYZ[1].x)))), _114, mad(mad((WorkingColorSpace_FromXYZ[1].z), _1024, mad((WorkingColorSpace_FromXYZ[1].y), _1015, (_1006 * (WorkingColorSpace_FromXYZ[1].x)))), _113, (mad((WorkingColorSpace_FromXYZ[1].z), _1021, mad((WorkingColorSpace_FromXYZ[1].y), _1012, (_1003 * (WorkingColorSpace_FromXYZ[1].x)))) * _112)));
  float _1063 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _1027, mad((WorkingColorSpace_FromXYZ[2].y), _1018, (_1009 * (WorkingColorSpace_FromXYZ[2].x)))), _114, mad(mad((WorkingColorSpace_FromXYZ[2].z), _1024, mad((WorkingColorSpace_FromXYZ[2].y), _1015, (_1006 * (WorkingColorSpace_FromXYZ[2].x)))), _113, (mad((WorkingColorSpace_FromXYZ[2].z), _1021, mad((WorkingColorSpace_FromXYZ[2].y), _1012, (_1003 * (WorkingColorSpace_FromXYZ[2].x)))) * _112)));
  float _1066 = mad((WorkingColorSpace_ToAP1[0].z), _1063, mad((WorkingColorSpace_ToAP1[0].y), _1060, ((WorkingColorSpace_ToAP1[0].x) * _1057)));
  float _1069 = mad((WorkingColorSpace_ToAP1[1].z), _1063, mad((WorkingColorSpace_ToAP1[1].y), _1060, ((WorkingColorSpace_ToAP1[1].x) * _1057)));
  float _1072 = mad((WorkingColorSpace_ToAP1[2].z), _1063, mad((WorkingColorSpace_ToAP1[2].y), _1060, ((WorkingColorSpace_ToAP1[2].x) * _1057)));
  float _1073 = dot(float3(_1066, _1069, _1072), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1074 = _1066 - _1073;
  float _1075 = _1069 - _1073;
  float _1076 = _1072 - _1073;
  float _1113 = _551 + (_545 * exp2(log2(exp2(_512 * log2(max(0.0f, ((_497 * _1074) + _1073)) * 5.55555534362793f)) * 0.18000000715255737f) * _533));
  float _1114 = _552 + (_546 * exp2(log2(exp2(_513 * log2(max(0.0f, ((_498 * _1075) + _1073)) * 5.55555534362793f)) * 0.18000000715255737f) * _534));
  float _1115 = _553 + (_547 * exp2(log2(exp2(_514 * log2(max(0.0f, ((_499 * _1076) + _1073)) * 5.55555534362793f)) * 0.18000000715255737f) * _535));
  float _1118 = saturate(_1073 / ColorCorrectionShadowsMax);
  float _1122 = (_1118 * _1118) * (3.0f - (_1118 * 2.0f));
  float _1123 = 1.0f - _1122;
  float _1165 = saturate((_1073 - ColorCorrectionHighlightsMin) / _669);
  float _1169 = (_1165 * _1165) * (3.0f - (_1165 * 2.0f));
  float _1209 = _776 + (_770 * exp2(log2(exp2(_737 * log2(max(0.0f, ((_725 * _1074) + _1073)) * 5.55555534362793f)) * 0.18000000715255737f) * _758));
  float _1210 = _777 + (_771 * exp2(log2(exp2(_738 * log2(max(0.0f, ((_726 * _1075) + _1073)) * 5.55555534362793f)) * 0.18000000715255737f) * _759));
  float _1211 = _778 + (_772 * exp2(log2(exp2(_739 * log2(max(0.0f, ((_727 * _1076) + _1073)) * 5.55555534362793f)) * 0.18000000715255737f) * _760));
  if ((bool)(_1123 > 0.5f) && (bool)(dot(float3(_1209, _1210, _1211), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)) < dot(float3(_1113, _1114, _1115), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)))) {
    _1222 = (_1123 - (_1123 * (0.6000000238418579f - _1122)));
  } else {
    _1222 = _1123;
  }
  float _1224 = (1.0f - _1222) - _1169;
  float _1235 = ((_1222 * _1113) + (_1169 * min(1e+05f, (_661 + (_655 * exp2(log2(exp2(_622 * log2(max(0.0f, ((_610 * _1074) + _1073)) * 5.55555534362793f)) * 0.18000000715255737f) * _643)))))) + (_1224 * _1209);
  float _1237 = ((_1222 * _1114) + (_1169 * min(1e+05f, (_662 + (_656 * exp2(log2(exp2(_623 * log2(max(0.0f, ((_611 * _1075) + _1073)) * 5.55555534362793f)) * 0.18000000715255737f) * _644)))))) + (_1224 * _1210);
  float _1239 = ((_1222 * _1115) + (min(1e+05f, (_663 + (_657 * exp2(log2(exp2(_624 * log2(max(0.0f, ((_612 * _1076) + _1073)) * 5.55555534362793f)) * 0.18000000715255737f) * _645)))) * _1169)) + (_1224 * _1211); */
  float _1254 = ((mad(0.061360642313957214f, _809, mad(-4.540197551250458e-09f, _807, (_805 * 0.9386394023895264f))) - _805) * BlueCorrection) + _805;
  float _1255 = ((mad(0.169205904006958f, _809, mad(0.8307942152023315f, _807, (_805 * 6.775371730327606e-08f))) - _807) * BlueCorrection) + _807;
  float _1256 = (mad(-2.3283064365386963e-10f, _807, (_805 * -9.313225746154785e-10f)) * BlueCorrection) + _809;
  float _1259 = mad(0.16386905312538147f, _1256, mad(0.14067868888378143f, _1255, (_1254 * 0.6954522132873535f)));
  float _1262 = mad(0.0955343246459961f, _1256, mad(0.8596711158752441f, _1255, (_1254 * 0.044794581830501556f)));
  float _1265 = mad(1.0015007257461548f, _1256, mad(0.004025210160762072f, _1255, (_1254 * -0.005525882821530104f)));
  float _1269 = max(max(_1259, _1262), _1265);
  float _1274 = (max(_1269, 1.000000013351432e-10f) - max(min(min(_1259, _1262), _1265), 1.000000013351432e-10f)) / max(_1269, 0.009999999776482582f);
  float _1287 = ((_1262 + _1259) + _1265) + (sqrt((((_1265 - _1262) * _1265) + ((_1262 - _1259) * _1262)) + ((_1259 - _1265) * _1259)) * 1.75f);
  float _1288 = _1287 * 0.3333333432674408f;
  float _1289 = _1274 + -0.4000000059604645f;
  float _1290 = _1289 * 5.0f;
  float _1294 = max((1.0f - abs(_1289 * 2.5f)), 0.0f);
  float _1305 = ((float((int)(((int)(uint)((bool)(_1290 > 0.0f))) - ((int)(uint)((bool)(_1290 < 0.0f))))) * (1.0f - (_1294 * _1294))) + 1.0f) * 0.02500000037252903f;
  if (!(_1288 <= 0.0533333346247673f)) {
    if (!(_1288 >= 0.1599999964237213f)) {
      _1314 = (((0.23999999463558197f / _1287) + -0.5f) * _1305);
    } else {
      _1314 = 0.0f;
    }
  } else {
    _1314 = _1305;
  }
  float _1315 = _1314 + 1.0f;
  float _1316 = _1315 * _1259;
  float _1317 = _1315 * _1262;
  float _1318 = _1315 * _1265;
  if (!((bool)(_1316 == _1317) && (bool)(_1317 == _1318))) {
    float _1325 = ((_1316 * 2.0f) - _1317) - _1318;
    float _1328 = ((_1262 - _1265) * 1.7320507764816284f) * _1315;
    float _1330 = atan(_1328 / _1325);
    bool _1333 = (_1325 < 0.0f);
    bool _1334 = (_1325 == 0.0f);
    bool _1335 = (_1328 >= 0.0f);
    bool _1336 = (_1328 < 0.0f);
    _1347 = select((_1335 && _1334), 90.0f, select((_1336 && _1334), -90.0f, (select((_1336 && _1333), (_1330 + -3.1415927410125732f), select((_1335 && _1333), (_1330 + 3.1415927410125732f), _1330)) * 57.2957763671875f)));
  } else {
    _1347 = 0.0f;
  }
  float _1352 = min(max(select((_1347 < 0.0f), (_1347 + 360.0f), _1347), 0.0f), 360.0f);
  if (_1352 < -180.0f) {
    _1361 = (_1352 + 360.0f);
  } else {
    if (_1352 > 180.0f) {
      _1361 = (_1352 + -360.0f);
    } else {
      _1361 = _1352;
    }
  }
  float _1365 = saturate(1.0f - abs(_1361 * 0.014814814552664757f));
  float _1369 = (_1365 * _1365) * (3.0f - (_1365 * 2.0f));
  float _1375 = ((_1369 * _1369) * ((_1274 * 0.18000000715255737f) * (0.029999999329447746f - _1316))) + _1316;
  float _1385 = max(0.0f, mad(-0.21492856740951538f, _1318, mad(-0.2365107536315918f, _1317, (_1375 * 1.4514392614364624f))));
  float _1386 = max(0.0f, mad(-0.09967592358589172f, _1318, mad(1.17622971534729f, _1317, (_1375 * -0.07655377686023712f))));
  float _1387 = max(0.0f, mad(0.9977163076400757f, _1318, mad(-0.006032449658960104f, _1317, (_1375 * 0.008316148072481155f))));
  float _1388 = dot(float3(_1385, _1386, _1387), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float3 lerpColor = lerp(_1388, float3(_1385, _1386, _1387), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _1254, _1255, _1256);
  float _1576 = lerpColor.r, _1577 = lerpColor.g, _1578 = lerpColor.b;
#else
  float _1403 = (FilmBlackClip + 1.0f) - FilmToe;
  float _1405 = FilmWhiteClip + 1.0f;
  float _1407 = _1405 - FilmShoulder;
  bool _1408 = (FilmToe > 0.800000011920929f);
  if (_1408) {
    _1425 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _1416 = (FilmBlackClip + 0.18000000715255737f) / _1403;
    _1425 = (-0.7447274923324585f - ((log2(_1416 / (2.0f - _1416)) * 0.3465735912322998f) * (_1403 / FilmSlope)));
  }
  float _1427 = (1.0f - FilmToe) / FilmSlope;
  float _1428 = _1427 - _1425;
  float _1429 = FilmShoulder / FilmSlope;
  float _1430 = _1429 - _1428;
  float _1434 = log2(lerp(_1388, _1385, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1435 = log2(lerp(_1388, _1386, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1436 = log2(lerp(_1388, _1387, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1440 = FilmSlope * (_1434 + _1428);
  float _1441 = FilmSlope * (_1435 + _1428);
  float _1442 = FilmSlope * (_1436 + _1428);
  float _1443 = _1403 * 2.0f;
  float _1445 = (FilmSlope * -2.0f) / _1403;
  float _1446 = _1434 - _1425;
  float _1447 = _1435 - _1425;
  float _1448 = _1436 - _1425;
  float _1467 = _1407 * 2.0f;
  float _1469 = (FilmSlope * 2.0f) / _1407;
  float _1494 = select((_1434 < _1425), ((_1443 / (exp2((_1446 * 1.4426950216293335f) * _1445) + 1.0f)) - FilmBlackClip), _1440);
  float _1495 = select((_1435 < _1425), ((_1443 / (exp2((_1447 * 1.4426950216293335f) * _1445) + 1.0f)) - FilmBlackClip), _1441);
  float _1496 = select((_1436 < _1425), ((_1443 / (exp2((_1448 * 1.4426950216293335f) * _1445) + 1.0f)) - FilmBlackClip), _1442);
  float _1503 = _1430 - _1425;
  float _1507 = saturate(_1446 / _1503);
  float _1508 = saturate(_1447 / _1503);
  float _1509 = saturate(_1448 / _1503);
  bool _1510 = (_1430 < _1425);
  float _1514 = select(_1510, (1.0f - _1507), _1507);
  float _1515 = select(_1510, (1.0f - _1508), _1508);
  float _1516 = select(_1510, (1.0f - _1509), _1509);
  float _1535 = (((_1514 * _1514) * (select((_1434 > _1430), (_1405 - (_1467 / (exp2(((_1434 - _1430) * 1.4426950216293335f) * _1469) + 1.0f))), _1440) - _1494)) * (3.0f - (_1514 * 2.0f))) + _1494;
  float _1536 = (((_1515 * _1515) * (select((_1435 > _1430), (_1405 - (_1467 / (exp2(((_1435 - _1430) * 1.4426950216293335f) * _1469) + 1.0f))), _1441) - _1495)) * (3.0f - (_1515 * 2.0f))) + _1495;
  float _1537 = (((_1516 * _1516) * (select((_1436 > _1430), (_1405 - (_1467 / (exp2(((_1436 - _1430) * 1.4426950216293335f) * _1469) + 1.0f))), _1442) - _1496)) * (3.0f - (_1516 * 2.0f))) + _1496;
  float _1538 = dot(float3(_1535, _1536, _1537), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1558 = (ToneCurveAmount * (max(0.0f, (lerp(_1538, _1535, 0.9300000071525574f))) - _1254)) + _1254;
  float _1559 = (ToneCurveAmount * (max(0.0f, (lerp(_1538, _1536, 0.9300000071525574f))) - _1255)) + _1255;
  float _1560 = (ToneCurveAmount * (max(0.0f, (lerp(_1538, _1537, 0.9300000071525574f))) - _1256)) + _1256;
  float _1576 = ((mad(-0.06537103652954102f, _1560, mad(1.451815478503704e-06f, _1559, (_1558 * 1.065374732017517f))) - _1558) * BlueCorrection) + _1558;
  float _1577 = ((mad(-0.20366770029067993f, _1560, mad(1.2036634683609009f, _1559, (_1558 * -2.57161445915699e-07f))) - _1559) * BlueCorrection) + _1559;
  float _1578 = ((mad(0.9999996423721313f, _1560, mad(2.0954757928848267e-08f, _1559, (_1558 * 1.862645149230957e-08f))) - _1560) * BlueCorrection) + _1560;
#endif
  float _1600 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1578, mad((WorkingColorSpace_FromAP1[0].y), _1577, ((WorkingColorSpace_FromAP1[0].x) * _1576))));
  float _1601 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1578, mad((WorkingColorSpace_FromAP1[1].y), _1577, ((WorkingColorSpace_FromAP1[1].x) * _1576))));
  float _1602 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1578, mad((WorkingColorSpace_FromAP1[2].y), _1577, ((WorkingColorSpace_FromAP1[2].x) * _1576))));
  /* float _1616 = ((mad(0.061360642313957214f, _1239, mad(-4.540197551250458e-09f, _1237, (_1235 * 0.9386394023895264f))) - _1235) * BlueCorrection) + _1235;
  float _1617 = ((mad(0.169205904006958f, _1239, mad(0.8307942152023315f, _1237, (_1235 * 6.775371730327606e-08f))) - _1237) * BlueCorrection) + _1237;
  float _1618 = (mad(-2.3283064365386963e-10f, _1237, (_1235 * -9.313225746154785e-10f)) * BlueCorrection) + _1239;
  float _1621 = mad(0.16386905312538147f, _1618, mad(0.14067868888378143f, _1617, (_1616 * 0.6954522132873535f)));
  float _1624 = mad(0.0955343246459961f, _1618, mad(0.8596711158752441f, _1617, (_1616 * 0.044794581830501556f)));
  float _1627 = mad(1.0015007257461548f, _1618, mad(0.004025210160762072f, _1617, (_1616 * -0.005525882821530104f)));
  float _1631 = max(max(_1621, _1624), _1627);
  float _1636 = (max(_1631, 1.000000013351432e-10f) - max(min(min(_1621, _1624), _1627), 1.000000013351432e-10f)) / max(_1631, 0.009999999776482582f);
  float _1649 = ((_1624 + _1621) + _1627) + (sqrt((((_1627 - _1624) * _1627) + ((_1624 - _1621) * _1624)) + ((_1621 - _1627) * _1621)) * 1.75f);
  float _1650 = _1649 * 0.3333333432674408f;
  float _1651 = _1636 + -0.4000000059604645f;
  float _1652 = _1651 * 5.0f;
  float _1656 = max((1.0f - abs(_1651 * 2.5f)), 0.0f);
  float _1667 = ((float((int)(((int)(uint)((bool)(_1652 > 0.0f))) - ((int)(uint)((bool)(_1652 < 0.0f))))) * (1.0f - (_1656 * _1656))) + 1.0f) * 0.02500000037252903f;
  bool _1668 = !(_1650 <= 0.0533333346247673f);
  if (_1668) {
    if (!(_1650 >= 0.1599999964237213f)) {
      _1676 = (((0.23999999463558197f / _1649) + -0.5f) * _1667);
    } else {
      _1676 = 0.0f;
    }
  } else {
    _1676 = _1667;
  }
  float _1677 = _1676 + 1.0f;
  float _1678 = _1677 * _1621;
  float _1679 = _1677 * _1624;
  float _1680 = _1677 * _1627;
  if (!((bool)(_1678 == _1679) && (bool)(_1679 == _1680))) {
    float _1687 = ((_1678 * 2.0f) - _1679) - _1680;
    float _1690 = ((_1624 - _1627) * 1.7320507764816284f) * _1677;
    float _1692 = atan(_1690 / _1687);
    bool _1695 = (_1687 < 0.0f);
    bool _1696 = (_1687 == 0.0f);
    bool _1697 = (_1690 >= 0.0f);
    bool _1698 = (_1690 < 0.0f);
    _1709 = select((_1697 && _1696), 90.0f, select((_1698 && _1696), -90.0f, (select((_1698 && _1695), (_1692 + -3.1415927410125732f), select((_1697 && _1695), (_1692 + 3.1415927410125732f), _1692)) * 57.2957763671875f)));
  } else {
    _1709 = 0.0f;
  }
  float _1714 = min(max(select((_1709 < 0.0f), (_1709 + 360.0f), _1709), 0.0f), 360.0f);
  if (_1714 < -180.0f) {
    _1723 = (_1714 + 360.0f);
  } else {
    if (_1714 > 180.0f) {
      _1723 = (_1714 + -360.0f);
    } else {
      _1723 = _1714;
    }
  }
  float _1727 = saturate(1.0f - abs(_1723 * 0.014814814552664757f));
  float _1731 = (_1727 * _1727) * (3.0f - (_1727 * 2.0f));
  float _1733 = _1636 * 0.18000000715255737f;
  float _1737 = ((_1731 * _1731) * (_1733 * (0.029999999329447746f - _1678))) + _1678;
  float _1747 = max(0.0f, mad(-0.21492856740951538f, _1680, mad(-0.2365107536315918f, _1679, (_1737 * 1.4514392614364624f))));
  float _1748 = max(0.0f, mad(-0.09967592358589172f, _1680, mad(1.17622971534729f, _1679, (_1737 * -0.07655377686023712f))));
  float _1749 = max(0.0f, mad(0.9977163076400757f, _1680, mad(-0.006032449658960104f, _1679, (_1737 * 0.008316148072481155f))));
  float _1750 = dot(float3(_1747, _1748, _1749), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1760 = log2(lerp(_1750, _1747, 0.9599999785423279f));
  float _1761 = log2(lerp(_1750, _1748, 0.9599999785423279f));
  float _1762 = log2(lerp(_1750, _1749, 0.9599999785423279f));
  float _1763 = _1760 * 0.3010300099849701f;
  float _1764 = _1761 * 0.3010300099849701f;
  float _1765 = _1762 * 0.3010300099849701f;
  float _1767 = (_1760 * 0.2649064064025879f) + 0.7934439778327942f;
  float _1769 = (_1761 * 0.2649064064025879f) + 0.7934439778327942f;
  float _1771 = (_1762 * 0.2649064064025879f) + 0.7934439778327942f;
  float _1808 = select((_1763 < -0.39027726650238037f), (0.8999999761581421f / (exp2(-2.202155351638794f - (_1760 * 1.6985740661621094f)) + 1.0f)), _1767);
  float _1809 = select((_1764 < -0.39027726650238037f), (0.8999999761581421f / (exp2(-2.202155351638794f - (_1761 * 1.6985740661621094f)) + 1.0f)), _1769);
  float _1810 = select((_1765 < -0.39027726650238037f), (0.8999999761581421f / (exp2(-2.202155351638794f - (_1762 * 1.6985740661621094f)) + 1.0f)), _1771);
  float _1826 = 1.0f - saturate(-1.8075997829437256f - (_1760 * 1.3942440748214722f));
  float _1827 = 1.0f - saturate(-1.8075997829437256f - (_1761 * 1.3942440748214722f));
  float _1828 = 1.0f - saturate(-1.8075997829437256f - (_1762 * 1.3942440748214722f));
  float _1847 = (((_1826 * _1826) * (select((_1763 > -0.6061863899230957f), (1.0399999618530273f - (1.559999942779541f / (exp2((_1760 * 0.9799466133117676f) + 1.9733258485794067f) + 1.0f))), _1767) - _1808)) * (3.0f - (_1826 * 2.0f))) + _1808;
  float _1848 = (((_1827 * _1827) * (select((_1764 > -0.6061863899230957f), (1.0399999618530273f - (1.559999942779541f / (exp2((_1761 * 0.9799466133117676f) + 1.9733258485794067f) + 1.0f))), _1769) - _1809)) * (3.0f - (_1827 * 2.0f))) + _1809;
  float _1849 = (((_1828 * _1828) * (select((_1765 > -0.6061863899230957f), (1.0399999618530273f - (1.559999942779541f / (exp2((_1762 * 0.9799466133117676f) + 1.9733258485794067f) + 1.0f))), _1771) - _1810)) * (3.0f - (_1828 * 2.0f))) + _1810;
  float _1850 = dot(float3(_1847, _1848, _1849), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1869 = (ToneCurveAmount * (max(0.0f, (lerp(_1850, _1847, 0.9300000071525574f))) - _1616)) + _1616;
  float _1870 = (ToneCurveAmount * (max(0.0f, (lerp(_1850, _1848, 0.9300000071525574f))) - _1617)) + _1617;
  float _1871 = (ToneCurveAmount * (max(0.0f, (lerp(_1850, _1849, 0.9300000071525574f))) - _1618)) + _1618;
  if (_1668) {
    if (!(_1650 >= 0.1599999964237213f)) {
      _1894 = (((0.23999999463558197f / _1649) + -0.5f) * _1667);
    } else {
      _1894 = 0.0f;
    }
  } else {
    _1894 = _1667;
  }
  float _1895 = _1894 + 1.0f;
  float _1896 = _1895 * _1621;
  float _1897 = _1895 * _1624;
  float _1898 = _1895 * _1627;
  if (!((bool)(_1896 == _1897) && (bool)(_1897 == _1898))) {
    float _1905 = ((_1896 * 2.0f) - _1897) - _1898;
    float _1908 = ((_1624 - _1627) * 1.7320507764816284f) * _1895;
    float _1910 = atan(_1908 / _1905);
    bool _1913 = (_1905 < 0.0f);
    bool _1914 = (_1905 == 0.0f);
    bool _1915 = (_1908 >= 0.0f);
    bool _1916 = (_1908 < 0.0f);
    _1927 = select((_1915 && _1914), 90.0f, select((_1916 && _1914), -90.0f, (select((_1916 && _1913), (_1910 + -3.1415927410125732f), select((_1915 && _1913), (_1910 + 3.1415927410125732f), _1910)) * 57.2957763671875f)));
  } else {
    _1927 = 0.0f;
  }
  float _1932 = min(max(select((_1927 < 0.0f), (_1927 + 360.0f), _1927), 0.0f), 360.0f);
  if (_1932 < -180.0f) {
    _1941 = (_1932 + 360.0f);
  } else {
    if (_1932 > 180.0f) {
      _1941 = (_1932 + -360.0f);
    } else {
      _1941 = _1932;
    }
  }
  float _1945 = saturate(1.0f - abs(_1941 * 0.014814814552664757f));
  float _1949 = (_1945 * _1945) * (3.0f - (_1945 * 2.0f));
  float _1954 = ((_1949 * _1949) * (_1733 * (0.029999999329447746f - _1896))) + _1896;
  float _1964 = max(0.0f, mad(-0.21492856740951538f, _1898, mad(-0.2365107536315918f, _1897, (_1954 * 1.4514392614364624f))));
  float _1965 = max(0.0f, mad(-0.09967592358589172f, _1898, mad(1.17622971534729f, _1897, (_1954 * -0.07655377686023712f))));
  float _1966 = max(0.0f, mad(0.9977163076400757f, _1898, mad(-0.006032449658960104f, _1897, (_1954 * 0.008316148072481155f))));
  float _1967 = dot(float3(_1964, _1965, _1966), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  if (_1408) {
    _1992 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _1983 = (FilmBlackClip + 0.18000000715255737f) / _1403;
    _1992 = (-0.7447274923324585f - ((log2(_1983 / (2.0f - _1983)) * 0.3465735912322998f) * (_1403 / FilmSlope)));
  }
  float _1993 = _1427 - _1992;
  float _1994 = _1429 - _1993;
  float _1998 = log2(lerp(_1967, _1964, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1999 = log2(lerp(_1967, _1965, 0.9599999785423279f)) * 0.3010300099849701f;
  float _2000 = log2(lerp(_1967, _1966, 0.9599999785423279f)) * 0.3010300099849701f;
  float _2004 = FilmSlope * (_1998 + _1993);
  float _2005 = FilmSlope * (_1999 + _1993);
  float _2006 = FilmSlope * (_2000 + _1993);
  float _2007 = _1998 - _1992;
  float _2008 = _1999 - _1992;
  float _2009 = _2000 - _1992;
  float _2052 = select((_1998 < _1992), ((_1443 / (exp2((_2007 * 1.4426950216293335f) * _1445) + 1.0f)) - FilmBlackClip), _2004);
  float _2053 = select((_1999 < _1992), ((_1443 / (exp2((_2008 * 1.4426950216293335f) * _1445) + 1.0f)) - FilmBlackClip), _2005);
  float _2054 = select((_2000 < _1992), ((_1443 / (exp2((_2009 * 1.4426950216293335f) * _1445) + 1.0f)) - FilmBlackClip), _2006);
  float _2061 = _1994 - _1992;
  float _2065 = saturate(_2007 / _2061);
  float _2066 = saturate(_2008 / _2061);
  float _2067 = saturate(_2009 / _2061);
  bool _2068 = (_1994 < _1992);
  float _2072 = select(_2068, (1.0f - _2065), _2065);
  float _2073 = select(_2068, (1.0f - _2066), _2066);
  float _2074 = select(_2068, (1.0f - _2067), _2067);
  float _2093 = (((_2072 * _2072) * (select((_1998 > _1994), (_1405 - (_1467 / (exp2(((_1998 - _1994) * 1.4426950216293335f) * _1469) + 1.0f))), _2004) - _2052)) * (3.0f - (_2072 * 2.0f))) + _2052;
  float _2094 = (((_2073 * _2073) * (select((_1999 > _1994), (_1405 - (_1467 / (exp2(((_1999 - _1994) * 1.4426950216293335f) * _1469) + 1.0f))), _2005) - _2053)) * (3.0f - (_2073 * 2.0f))) + _2053;
  float _2095 = (((_2074 * _2074) * (select((_2000 > _1994), (_1405 - (_1467 / (exp2(((_2000 - _1994) * 1.4426950216293335f) * _1469) + 1.0f))), _2006) - _2054)) * (3.0f - (_2074 * 2.0f))) + _2054;
  float _2096 = dot(float3(_2093, _2094, _2095), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _2115 = (ToneCurveAmount * (max(0.0f, (lerp(_2096, _2093, 0.9300000071525574f))) - _1616)) + _1616;
  float _2116 = (ToneCurveAmount * (max(0.0f, (lerp(_2096, _2094, 0.9300000071525574f))) - _1617)) + _1617;
  float _2117 = (ToneCurveAmount * (max(0.0f, (lerp(_2096, _2095, 0.9300000071525574f))) - _1618)) + _1618;
  float _2133 = ((mad(-0.06537103652954102f, _2117, mad(1.451815478503704e-06f, _2116, (_2115 * 1.065374732017517f))) - _2115) * BlueCorrection) + _2115;
  float _2134 = ((mad(-0.20366770029067993f, _2117, mad(1.2036634683609009f, _2116, (_2115 * -2.57161445915699e-07f))) - _2116) * BlueCorrection) + _2116;
  float _2135 = ((mad(0.9999996423721313f, _2117, mad(2.0954757928848267e-08f, _2116, (_2115 * 1.862645149230957e-08f))) - _2117) * BlueCorrection) + _2117;
  float _2138 = ((_805 - _1869) - ((mad(-0.06537103652954102f, _1871, mad(1.451815478503704e-06f, _1870, (_1869 * 1.065374732017517f))) - _1869) * BlueCorrection)) + _2133;
  float _2141 = ((_807 - _1870) - ((mad(-0.20366770029067993f, _1871, mad(1.2036634683609009f, _1870, (_1869 * -2.57161445915699e-07f))) - _1870) * BlueCorrection)) + _2134;
  float _2144 = ((_809 - _1871) - ((mad(0.9999996423721313f, _1871, mad(2.0954757928848267e-08f, _1870, (_1869 * 1.862645149230957e-08f))) - _1871) * BlueCorrection)) + _2135; */
  float _2179 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1600)) * _1600) + MappingPolynomial.z);
  float _2180 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1601)) * _1601) + MappingPolynomial.z);
  float _2181 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1602)) * _1602) + MappingPolynomial.z);
  float _2188 = ((OverlayColor.x - _2179) * OverlayColor.w) + _2179;
  float _2189 = ((OverlayColor.y - _2180) * OverlayColor.w) + _2180;
  float _2190 = ((OverlayColor.z - _2181) * OverlayColor.w) + _2181;

  if (GenerateOutput(_2188, _2189, _2190, SV_Target, is_hdr)) {
    return SV_Target;
  }

  /* float _2191 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _2144, mad((WorkingColorSpace_FromAP1[0].y), _2141, ((WorkingColorSpace_FromAP1[0].x) * _2138)));
  float _2192 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _2144, mad((WorkingColorSpace_FromAP1[1].y), _2141, ((WorkingColorSpace_FromAP1[1].x) * _2138)));
  float _2193 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _2144, mad((WorkingColorSpace_FromAP1[2].y), _2141, ((WorkingColorSpace_FromAP1[2].x) * _2138)));
  float _2200 = ((OverlayColor.x - _2191) * OverlayColor.w) + _2191;
  float _2201 = ((OverlayColor.y - _2192) * OverlayColor.w) + _2192;
  float _2202 = ((OverlayColor.z - _2193) * OverlayColor.w) + _2193;
  float _2212 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _2135, mad((WorkingColorSpace_FromAP1[0].y), _2134, ((WorkingColorSpace_FromAP1[0].x) * _2133)));
  float _2213 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _2135, mad((WorkingColorSpace_FromAP1[1].y), _2134, ((WorkingColorSpace_FromAP1[1].x) * _2133)));
  float _2214 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _2135, mad((WorkingColorSpace_FromAP1[2].y), _2134, ((WorkingColorSpace_FromAP1[2].x) * _2133)));
  float _2221 = ((OverlayColor.x - _2212) * OverlayColor.w) + _2212;
  float _2222 = ((OverlayColor.y - _2213) * OverlayColor.w) + _2213;
  float _2223 = ((OverlayColor.z - _2214) * OverlayColor.w) + _2214;
  float _2226 = mad((WorkingColorSpace_ToAP1[0].z), _2223, mad((WorkingColorSpace_ToAP1[0].y), _2222, (_2221 * (WorkingColorSpace_ToAP1[0].x))));
  float _2229 = mad((WorkingColorSpace_ToAP1[1].z), _2223, mad((WorkingColorSpace_ToAP1[1].y), _2222, (_2221 * (WorkingColorSpace_ToAP1[1].x))));
  float _2232 = mad((WorkingColorSpace_ToAP1[2].z), _2223, mad((WorkingColorSpace_ToAP1[2].y), _2222, (_2221 * (WorkingColorSpace_ToAP1[2].x)))); */
  float _2244 = exp2(log2(max(0.0f, _2188)) * InverseGamma.y);
  float _2245 = exp2(log2(max(0.0f, _2189)) * InverseGamma.y);
  float _2246 = exp2(log2(max(0.0f, _2190)) * InverseGamma.y);
  /* [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace_bIsSRGB == 0) {
        float _2257 = mad((WorkingColorSpace_ToAP1[0].z), _2246, mad((WorkingColorSpace_ToAP1[0].y), _2245, ((WorkingColorSpace_ToAP1[0].x) * _2244)));
        float _2260 = mad((WorkingColorSpace_ToAP1[1].z), _2246, mad((WorkingColorSpace_ToAP1[1].y), _2245, ((WorkingColorSpace_ToAP1[1].x) * _2244)));
        float _2263 = mad((WorkingColorSpace_ToAP1[2].z), _2246, mad((WorkingColorSpace_ToAP1[2].y), _2245, ((WorkingColorSpace_ToAP1[2].x) * _2244)));
        _2274 = mad(_45, _2263, mad(_44, _2260, (_2257 * _43)));
        _2275 = mad(_48, _2263, mad(_47, _2260, (_2257 * _46)));
        _2276 = mad(_51, _2263, mad(_50, _2260, (_2257 * _49)));
      } else {
        _2274 = _2244;
        _2275 = _2245;
        _2276 = _2246;
      }
      do {
        if (_2274 < 0.0031306699384003878f) {
          _2287 = (_2274 * 12.920000076293945f);
        } else {
          _2287 = (((pow(_2274, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_2275 < 0.0031306699384003878f) {
            _2298 = (_2275 * 12.920000076293945f);
          } else {
            _2298 = (((pow(_2275, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_2276 < 0.0031306699384003878f) {
            _3696 = _2287;
            _3697 = _2298;
            _3698 = (_2276 * 12.920000076293945f);
          } else {
            _3696 = _2287;
            _3697 = _2298;
            _3698 = (((pow(_2276, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _2313 = mad((WorkingColorSpace_ToAP1[0].z), _2246, mad((WorkingColorSpace_ToAP1[0].y), _2245, ((WorkingColorSpace_ToAP1[0].x) * _2244)));
      float _2316 = mad((WorkingColorSpace_ToAP1[1].z), _2246, mad((WorkingColorSpace_ToAP1[1].y), _2245, ((WorkingColorSpace_ToAP1[1].x) * _2244)));
      float _2319 = mad((WorkingColorSpace_ToAP1[2].z), _2246, mad((WorkingColorSpace_ToAP1[2].y), _2245, ((WorkingColorSpace_ToAP1[2].x) * _2244)));
      float _2329 = max(6.103519990574569e-05f, mad(_45, _2319, mad(_44, _2316, (_2313 * _43))));
      float _2330 = max(6.103519990574569e-05f, mad(_48, _2319, mad(_47, _2316, (_2313 * _46))));
      float _2331 = max(6.103519990574569e-05f, mad(_51, _2319, mad(_50, _2316, (_2313 * _49))));
      _3696 = min((_2329 * 4.5f), ((exp2(log2(max(_2329, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3697 = min((_2330 * 4.5f), ((exp2(log2(max(_2330, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3698 = min((_2331 * 4.5f), ((exp2(log2(max(_2331, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        float _2406 = ACESSceneColorMultiplier * _2200;
        float _2407 = ACESSceneColorMultiplier * _2201;
        float _2408 = ACESSceneColorMultiplier * _2202;
        float _2411 = mad((WorkingColorSpace_ToAP0[0].z), _2408, mad((WorkingColorSpace_ToAP0[0].y), _2407, ((WorkingColorSpace_ToAP0[0].x) * _2406)));
        float _2414 = mad((WorkingColorSpace_ToAP0[1].z), _2408, mad((WorkingColorSpace_ToAP0[1].y), _2407, ((WorkingColorSpace_ToAP0[1].x) * _2406)));
        float _2417 = mad((WorkingColorSpace_ToAP0[2].z), _2408, mad((WorkingColorSpace_ToAP0[2].y), _2407, ((WorkingColorSpace_ToAP0[2].x) * _2406)));
        float _2421 = max(max(_2411, _2414), _2417);
        float _2426 = (max(_2421, 1.000000013351432e-10f) - max(min(min(_2411, _2414), _2417), 1.000000013351432e-10f)) / max(_2421, 0.009999999776482582f);
        float _2439 = ((_2414 + _2411) + _2417) + (sqrt((((_2417 - _2414) * _2417) + ((_2414 - _2411) * _2414)) + ((_2411 - _2417) * _2411)) * 1.75f);
        float _2440 = _2439 * 0.3333333432674408f;
        float _2441 = _2426 + -0.4000000059604645f;
        float _2442 = _2441 * 5.0f;
        float _2446 = max((1.0f - abs(_2441 * 2.5f)), 0.0f);
        float _2457 = ((float((int)(((int)(uint)((bool)(_2442 > 0.0f))) - ((int)(uint)((bool)(_2442 < 0.0f))))) * (1.0f - (_2446 * _2446))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_2440 <= 0.0533333346247673f)) {
            if (!(_2440 >= 0.1599999964237213f)) {
              _2466 = (((0.23999999463558197f / _2439) + -0.5f) * _2457);
            } else {
              _2466 = 0.0f;
            }
          } else {
            _2466 = _2457;
          }
          float _2467 = _2466 + 1.0f;
          float _2468 = _2467 * _2411;
          float _2469 = _2467 * _2414;
          float _2470 = _2467 * _2417;
          do {
            if (!((bool)(_2468 == _2469) && (bool)(_2469 == _2470))) {
              float _2477 = ((_2468 * 2.0f) - _2469) - _2470;
              float _2480 = ((_2414 - _2417) * 1.7320507764816284f) * _2467;
              float _2482 = atan(_2480 / _2477);
              bool _2485 = (_2477 < 0.0f);
              bool _2486 = (_2477 == 0.0f);
              bool _2487 = (_2480 >= 0.0f);
              bool _2488 = (_2480 < 0.0f);
              _2499 = select((_2487 && _2486), 90.0f, select((_2488 && _2486), -90.0f, (select((_2488 && _2485), (_2482 + -3.1415927410125732f), select((_2487 && _2485), (_2482 + 3.1415927410125732f), _2482)) * 57.2957763671875f)));
            } else {
              _2499 = 0.0f;
            }
            float _2504 = min(max(select((_2499 < 0.0f), (_2499 + 360.0f), _2499), 0.0f), 360.0f);
            do {
              if (_2504 < -180.0f) {
                _2513 = (_2504 + 360.0f);
              } else {
                if (_2504 > 180.0f) {
                  _2513 = (_2504 + -360.0f);
                } else {
                  _2513 = _2504;
                }
              }
              do {
                if ((bool)(_2513 > -67.5f) && (bool)(_2513 < 67.5f)) {
                  float _2519 = (_2513 + 67.5f) * 0.029629629105329514f;
                  int _2520 = int(_2519);
                  float _2522 = _2519 - float((int)(_2520));
                  float _2523 = _2522 * _2522;
                  float _2524 = _2523 * _2522;
                  if (_2520 == 3) {
                    _2552 = (((0.1666666716337204f - (_2522 * 0.5f)) + (_2523 * 0.5f)) - (_2524 * 0.1666666716337204f));
                  } else {
                    if (_2520 == 2) {
                      _2552 = ((0.6666666865348816f - _2523) + (_2524 * 0.5f));
                    } else {
                      if (_2520 == 1) {
                        _2552 = (((_2524 * -0.5f) + 0.1666666716337204f) + ((_2523 + _2522) * 0.5f));
                      } else {
                        _2552 = select((_2520 == 0), (_2524 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _2552 = 0.0f;
                }
                float _2561 = min(max(((((_2426 * 0.27000001072883606f) * (0.029999999329447746f - _2468)) * _2552) + _2468), 0.0f), 65535.0f);
                float _2562 = min(max(_2469, 0.0f), 65535.0f);
                float _2563 = min(max(_2470, 0.0f), 65535.0f);
                float _2576 = min(max(mad(-0.21492856740951538f, _2563, mad(-0.2365107536315918f, _2562, (_2561 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _2577 = min(max(mad(-0.09967592358589172f, _2563, mad(1.17622971534729f, _2562, (_2561 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _2578 = min(max(mad(0.9977163076400757f, _2563, mad(-0.006032449658960104f, _2562, (_2561 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _2579 = dot(float3(_2576, _2577, _2578), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _2590 = log2(max((lerp(_2579, _2576, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _2591 = _2590 * 0.3010300099849701f;
                float _2592 = log2(ACESMinMaxData.x);
                float _2593 = _2592 * 0.3010300099849701f;
                do {
                  if (!(!(_2591 <= _2593))) {
                    _2662 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _2600 = log2(ACESMidData.x);
                    float _2601 = _2600 * 0.3010300099849701f;
                    if ((bool)(_2591 > _2593) && (bool)(_2591 < _2601)) {
                      float _2609 = ((_2590 - _2592) * 0.9030900001525879f) / ((_2600 - _2592) * 0.3010300099849701f);
                      int _2610 = int(_2609);
                      float _2612 = _2609 - float((int)(_2610));
                      float _2614 = _10[_2610];
                      float _2617 = _10[(_2610 + 1)];
                      float _2622 = _2614 * 0.5f;
                      _2662 = dot(float3((_2612 * _2612), _2612, 1.0f), float3(mad((_10[(_2610 + 2)]), 0.5f, mad(_2617, -1.0f, _2622)), (_2617 - _2614), mad(_2617, 0.5f, _2622)));
                    } else {
                      do {
                        if (!(!(_2591 >= _2601))) {
                          float _2631 = log2(ACESMinMaxData.z);
                          if (_2591 < (_2631 * 0.3010300099849701f)) {
                            float _2639 = ((_2590 - _2600) * 0.9030900001525879f) / ((_2631 - _2600) * 0.3010300099849701f);
                            int _2640 = int(_2639);
                            float _2642 = _2639 - float((int)(_2640));
                            float _2644 = _11[_2640];
                            float _2647 = _11[(_2640 + 1)];
                            float _2652 = _2644 * 0.5f;
                            _2662 = dot(float3((_2642 * _2642), _2642, 1.0f), float3(mad((_11[(_2640 + 2)]), 0.5f, mad(_2647, -1.0f, _2652)), (_2647 - _2644), mad(_2647, 0.5f, _2652)));
                            break;
                          }
                        }
                        _2662 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _2666 = log2(max((lerp(_2579, _2577, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2667 = _2666 * 0.3010300099849701f;
                  do {
                    if (!(!(_2667 <= _2593))) {
                      _2736 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2674 = log2(ACESMidData.x);
                      float _2675 = _2674 * 0.3010300099849701f;
                      if ((bool)(_2667 > _2593) && (bool)(_2667 < _2675)) {
                        float _2683 = ((_2666 - _2592) * 0.9030900001525879f) / ((_2674 - _2592) * 0.3010300099849701f);
                        int _2684 = int(_2683);
                        float _2686 = _2683 - float((int)(_2684));
                        float _2688 = _10[_2684];
                        float _2691 = _10[(_2684 + 1)];
                        float _2696 = _2688 * 0.5f;
                        _2736 = dot(float3((_2686 * _2686), _2686, 1.0f), float3(mad((_10[(_2684 + 2)]), 0.5f, mad(_2691, -1.0f, _2696)), (_2691 - _2688), mad(_2691, 0.5f, _2696)));
                      } else {
                        do {
                          if (!(!(_2667 >= _2675))) {
                            float _2705 = log2(ACESMinMaxData.z);
                            if (_2667 < (_2705 * 0.3010300099849701f)) {
                              float _2713 = ((_2666 - _2674) * 0.9030900001525879f) / ((_2705 - _2674) * 0.3010300099849701f);
                              int _2714 = int(_2713);
                              float _2716 = _2713 - float((int)(_2714));
                              float _2718 = _11[_2714];
                              float _2721 = _11[(_2714 + 1)];
                              float _2726 = _2718 * 0.5f;
                              _2736 = dot(float3((_2716 * _2716), _2716, 1.0f), float3(mad((_11[(_2714 + 2)]), 0.5f, mad(_2721, -1.0f, _2726)), (_2721 - _2718), mad(_2721, 0.5f, _2726)));
                              break;
                            }
                          }
                          _2736 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2740 = log2(max((lerp(_2579, _2578, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2741 = _2740 * 0.3010300099849701f;
                    do {
                      if (!(!(_2741 <= _2593))) {
                        _2810 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2748 = log2(ACESMidData.x);
                        float _2749 = _2748 * 0.3010300099849701f;
                        if ((bool)(_2741 > _2593) && (bool)(_2741 < _2749)) {
                          float _2757 = ((_2740 - _2592) * 0.9030900001525879f) / ((_2748 - _2592) * 0.3010300099849701f);
                          int _2758 = int(_2757);
                          float _2760 = _2757 - float((int)(_2758));
                          float _2762 = _10[_2758];
                          float _2765 = _10[(_2758 + 1)];
                          float _2770 = _2762 * 0.5f;
                          _2810 = dot(float3((_2760 * _2760), _2760, 1.0f), float3(mad((_10[(_2758 + 2)]), 0.5f, mad(_2765, -1.0f, _2770)), (_2765 - _2762), mad(_2765, 0.5f, _2770)));
                        } else {
                          do {
                            if (!(!(_2741 >= _2749))) {
                              float _2779 = log2(ACESMinMaxData.z);
                              if (_2741 < (_2779 * 0.3010300099849701f)) {
                                float _2787 = ((_2740 - _2748) * 0.9030900001525879f) / ((_2779 - _2748) * 0.3010300099849701f);
                                int _2788 = int(_2787);
                                float _2790 = _2787 - float((int)(_2788));
                                float _2792 = _11[_2788];
                                float _2795 = _11[(_2788 + 1)];
                                float _2800 = _2792 * 0.5f;
                                _2810 = dot(float3((_2790 * _2790), _2790, 1.0f), float3(mad((_11[(_2788 + 2)]), 0.5f, mad(_2795, -1.0f, _2800)), (_2795 - _2792), mad(_2795, 0.5f, _2800)));
                                break;
                              }
                            }
                            _2810 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2814 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _2815 = (exp2(_2662 * 3.321928024291992f) - ACESMinMaxData.y) / _2814;
                      float _2817 = (exp2(_2736 * 3.321928024291992f) - ACESMinMaxData.y) / _2814;
                      float _2819 = (exp2(_2810 * 3.321928024291992f) - ACESMinMaxData.y) / _2814;
                      float _2822 = mad(0.15618768334388733f, _2819, mad(0.13400420546531677f, _2817, (_2815 * 0.6624541878700256f)));
                      float _2825 = mad(0.053689517080783844f, _2819, mad(0.6740817427635193f, _2817, (_2815 * 0.2722287178039551f)));
                      float _2828 = mad(1.0103391408920288f, _2819, mad(0.00406073359772563f, _2817, (_2815 * -0.005574649665504694f)));
                      float _2841 = min(max(mad(-0.23642469942569733f, _2828, mad(-0.32480329275131226f, _2825, (_2822 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _2842 = min(max(mad(0.016756348311901093f, _2828, mad(1.6153316497802734f, _2825, (_2822 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _2843 = min(max(mad(0.9883948564529419f, _2828, mad(-0.008284442126750946f, _2825, (_2822 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _2846 = mad(0.15618768334388733f, _2843, mad(0.13400420546531677f, _2842, (_2841 * 0.6624541878700256f)));
                      float _2849 = mad(0.053689517080783844f, _2843, mad(0.6740817427635193f, _2842, (_2841 * 0.2722287178039551f)));
                      float _2852 = mad(1.0103391408920288f, _2843, mad(0.00406073359772563f, _2842, (_2841 * -0.005574649665504694f)));
                      float _2874 = min(max((min(max(mad(-0.23642469942569733f, _2852, mad(-0.32480329275131226f, _2849, (_2846 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2875 = min(max((min(max(mad(0.016756348311901093f, _2852, mad(1.6153316497802734f, _2849, (_2846 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2876 = min(max((min(max(mad(0.9883948564529419f, _2852, mad(-0.008284442126750946f, _2849, (_2846 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!(OutputDevice == 5)) {
                          float _2879 = dot(float3(_2874, _2875, _2876), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                          float _2880 = _2226 * 300.0f;
                          float _2881 = _2229 * 300.0f;
                          float _2882 = _2232 * 300.0f;
                          do {
                            [branch]
                            if (!(_2879 < 1.0f)) {
                              if (_2879 < 5.0f) {
                                float _2888 = (_2879 + -1.0f) * 0.25f;
                                _2915 = ((_2888 * (_2880 - _2874)) + _2874);
                                _2916 = ((_2888 * (_2881 - _2875)) + _2875);
                                _2917 = ((_2888 * (_2882 - _2876)) + _2876);
                              } else {
                                if (!(_2879 < 50.0f)) {
                                  if (_2879 < 150.0f) {
                                    float _2904 = (_2879 + -50.0f) * 0.009999999776482582f;
                                    _2915 = ((_2904 * (_2874 - _2880)) + _2880);
                                    _2916 = ((_2904 * (_2875 - _2881)) + _2881);
                                    _2917 = ((_2904 * (_2876 - _2882)) + _2882);
                                  } else {
                                    _2915 = _2874;
                                    _2916 = _2875;
                                    _2917 = _2876;
                                  }
                                } else {
                                  _2915 = _2880;
                                  _2916 = _2881;
                                  _2917 = _2882;
                                }
                              }
                            } else {
                              _2915 = _2874;
                              _2916 = _2875;
                              _2917 = _2876;
                            }
                            _2928 = mad(_45, _2917, mad(_44, _2916, (_2915 * _43)));
                            _2929 = mad(_48, _2917, mad(_47, _2916, (_2915 * _46)));
                            _2930 = mad(_51, _2917, mad(_50, _2916, (_2915 * _49)));
                          } while (false);
                        } else {
                          _2928 = _2874;
                          _2929 = _2875;
                          _2930 = _2876;
                        }
                        float _2940 = exp2(log2(_2928 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2941 = exp2(log2(_2929 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2942 = exp2(log2(_2930 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _3696 = exp2(log2((1.0f / ((_2940 * 18.6875f) + 1.0f)) * ((_2940 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _3697 = exp2(log2((1.0f / ((_2941 * 18.6875f) + 1.0f)) * ((_2941 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _3698 = exp2(log2((1.0f / ((_2942 * 18.6875f) + 1.0f)) * ((_2942 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _3019 = ACESSceneColorMultiplier * _2200;
          float _3020 = ACESSceneColorMultiplier * _2201;
          float _3021 = ACESSceneColorMultiplier * _2202;
          float _3024 = mad((WorkingColorSpace_ToAP0[0].z), _3021, mad((WorkingColorSpace_ToAP0[0].y), _3020, ((WorkingColorSpace_ToAP0[0].x) * _3019)));
          float _3027 = mad((WorkingColorSpace_ToAP0[1].z), _3021, mad((WorkingColorSpace_ToAP0[1].y), _3020, ((WorkingColorSpace_ToAP0[1].x) * _3019)));
          float _3030 = mad((WorkingColorSpace_ToAP0[2].z), _3021, mad((WorkingColorSpace_ToAP0[2].y), _3020, ((WorkingColorSpace_ToAP0[2].x) * _3019)));
          float _3034 = max(max(_3024, _3027), _3030);
          float _3039 = (max(_3034, 1.000000013351432e-10f) - max(min(min(_3024, _3027), _3030), 1.000000013351432e-10f)) / max(_3034, 0.009999999776482582f);
          float _3052 = ((_3027 + _3024) + _3030) + (sqrt((((_3030 - _3027) * _3030) + ((_3027 - _3024) * _3027)) + ((_3024 - _3030) * _3024)) * 1.75f);
          float _3053 = _3052 * 0.3333333432674408f;
          float _3054 = _3039 + -0.4000000059604645f;
          float _3055 = _3054 * 5.0f;
          float _3059 = max((1.0f - abs(_3054 * 2.5f)), 0.0f);
          float _3070 = ((float((int)(((int)(uint)((bool)(_3055 > 0.0f))) - ((int)(uint)((bool)(_3055 < 0.0f))))) * (1.0f - (_3059 * _3059))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_3053 <= 0.0533333346247673f)) {
              if (!(_3053 >= 0.1599999964237213f)) {
                _3079 = (((0.23999999463558197f / _3052) + -0.5f) * _3070);
              } else {
                _3079 = 0.0f;
              }
            } else {
              _3079 = _3070;
            }
            float _3080 = _3079 + 1.0f;
            float _3081 = _3080 * _3024;
            float _3082 = _3080 * _3027;
            float _3083 = _3080 * _3030;
            do {
              if (!((bool)(_3081 == _3082) && (bool)(_3082 == _3083))) {
                float _3090 = ((_3081 * 2.0f) - _3082) - _3083;
                float _3093 = ((_3027 - _3030) * 1.7320507764816284f) * _3080;
                float _3095 = atan(_3093 / _3090);
                bool _3098 = (_3090 < 0.0f);
                bool _3099 = (_3090 == 0.0f);
                bool _3100 = (_3093 >= 0.0f);
                bool _3101 = (_3093 < 0.0f);
                _3112 = select((_3100 && _3099), 90.0f, select((_3101 && _3099), -90.0f, (select((_3101 && _3098), (_3095 + -3.1415927410125732f), select((_3100 && _3098), (_3095 + 3.1415927410125732f), _3095)) * 57.2957763671875f)));
              } else {
                _3112 = 0.0f;
              }
              float _3117 = min(max(select((_3112 < 0.0f), (_3112 + 360.0f), _3112), 0.0f), 360.0f);
              do {
                if (_3117 < -180.0f) {
                  _3126 = (_3117 + 360.0f);
                } else {
                  if (_3117 > 180.0f) {
                    _3126 = (_3117 + -360.0f);
                  } else {
                    _3126 = _3117;
                  }
                }
                do {
                  if ((bool)(_3126 > -67.5f) && (bool)(_3126 < 67.5f)) {
                    float _3132 = (_3126 + 67.5f) * 0.029629629105329514f;
                    int _3133 = int(_3132);
                    float _3135 = _3132 - float((int)(_3133));
                    float _3136 = _3135 * _3135;
                    float _3137 = _3136 * _3135;
                    if (_3133 == 3) {
                      _3165 = (((0.1666666716337204f - (_3135 * 0.5f)) + (_3136 * 0.5f)) - (_3137 * 0.1666666716337204f));
                    } else {
                      if (_3133 == 2) {
                        _3165 = ((0.6666666865348816f - _3136) + (_3137 * 0.5f));
                      } else {
                        if (_3133 == 1) {
                          _3165 = (((_3137 * -0.5f) + 0.1666666716337204f) + ((_3136 + _3135) * 0.5f));
                        } else {
                          _3165 = select((_3133 == 0), (_3137 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _3165 = 0.0f;
                  }
                  float _3174 = min(max(((((_3039 * 0.27000001072883606f) * (0.029999999329447746f - _3081)) * _3165) + _3081), 0.0f), 65535.0f);
                  float _3175 = min(max(_3082, 0.0f), 65535.0f);
                  float _3176 = min(max(_3083, 0.0f), 65535.0f);
                  float _3189 = min(max(mad(-0.21492856740951538f, _3176, mad(-0.2365107536315918f, _3175, (_3174 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _3190 = min(max(mad(-0.09967592358589172f, _3176, mad(1.17622971534729f, _3175, (_3174 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _3191 = min(max(mad(0.9977163076400757f, _3176, mad(-0.006032449658960104f, _3175, (_3174 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _3192 = dot(float3(_3189, _3190, _3191), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _3203 = log2(max((lerp(_3192, _3189, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _3204 = _3203 * 0.3010300099849701f;
                  float _3205 = log2(ACESMinMaxData.x);
                  float _3206 = _3205 * 0.3010300099849701f;
                  do {
                    if (!(!(_3204 <= _3206))) {
                      _3275 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _3213 = log2(ACESMidData.x);
                      float _3214 = _3213 * 0.3010300099849701f;
                      if ((bool)(_3204 > _3206) && (bool)(_3204 < _3214)) {
                        float _3222 = ((_3203 - _3205) * 0.9030900001525879f) / ((_3213 - _3205) * 0.3010300099849701f);
                        int _3223 = int(_3222);
                        float _3225 = _3222 - float((int)(_3223));
                        float _3227 = _8[_3223];
                        float _3230 = _8[(_3223 + 1)];
                        float _3235 = _3227 * 0.5f;
                        _3275 = dot(float3((_3225 * _3225), _3225, 1.0f), float3(mad((_8[(_3223 + 2)]), 0.5f, mad(_3230, -1.0f, _3235)), (_3230 - _3227), mad(_3230, 0.5f, _3235)));
                      } else {
                        do {
                          if (!(!(_3204 >= _3214))) {
                            float _3244 = log2(ACESMinMaxData.z);
                            if (_3204 < (_3244 * 0.3010300099849701f)) {
                              float _3252 = ((_3203 - _3213) * 0.9030900001525879f) / ((_3244 - _3213) * 0.3010300099849701f);
                              int _3253 = int(_3252);
                              float _3255 = _3252 - float((int)(_3253));
                              float _3257 = _9[_3253];
                              float _3260 = _9[(_3253 + 1)];
                              float _3265 = _3257 * 0.5f;
                              _3275 = dot(float3((_3255 * _3255), _3255, 1.0f), float3(mad((_9[(_3253 + 2)]), 0.5f, mad(_3260, -1.0f, _3265)), (_3260 - _3257), mad(_3260, 0.5f, _3265)));
                              break;
                            }
                          }
                          _3275 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _3279 = log2(max((lerp(_3192, _3190, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _3280 = _3279 * 0.3010300099849701f;
                    do {
                      if (!(!(_3280 <= _3206))) {
                        _3349 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _3287 = log2(ACESMidData.x);
                        float _3288 = _3287 * 0.3010300099849701f;
                        if ((bool)(_3280 > _3206) && (bool)(_3280 < _3288)) {
                          float _3296 = ((_3279 - _3205) * 0.9030900001525879f) / ((_3287 - _3205) * 0.3010300099849701f);
                          int _3297 = int(_3296);
                          float _3299 = _3296 - float((int)(_3297));
                          float _3301 = _8[_3297];
                          float _3304 = _8[(_3297 + 1)];
                          float _3309 = _3301 * 0.5f;
                          _3349 = dot(float3((_3299 * _3299), _3299, 1.0f), float3(mad((_8[(_3297 + 2)]), 0.5f, mad(_3304, -1.0f, _3309)), (_3304 - _3301), mad(_3304, 0.5f, _3309)));
                        } else {
                          do {
                            if (!(!(_3280 >= _3288))) {
                              float _3318 = log2(ACESMinMaxData.z);
                              if (_3280 < (_3318 * 0.3010300099849701f)) {
                                float _3326 = ((_3279 - _3287) * 0.9030900001525879f) / ((_3318 - _3287) * 0.3010300099849701f);
                                int _3327 = int(_3326);
                                float _3329 = _3326 - float((int)(_3327));
                                float _3331 = _9[_3327];
                                float _3334 = _9[(_3327 + 1)];
                                float _3339 = _3331 * 0.5f;
                                _3349 = dot(float3((_3329 * _3329), _3329, 1.0f), float3(mad((_9[(_3327 + 2)]), 0.5f, mad(_3334, -1.0f, _3339)), (_3334 - _3331), mad(_3334, 0.5f, _3339)));
                                break;
                              }
                            }
                            _3349 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _3353 = log2(max((lerp(_3192, _3191, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _3354 = _3353 * 0.3010300099849701f;
                      do {
                        if (!(!(_3354 <= _3206))) {
                          _3423 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _3361 = log2(ACESMidData.x);
                          float _3362 = _3361 * 0.3010300099849701f;
                          if ((bool)(_3354 > _3206) && (bool)(_3354 < _3362)) {
                            float _3370 = ((_3353 - _3205) * 0.9030900001525879f) / ((_3361 - _3205) * 0.3010300099849701f);
                            int _3371 = int(_3370);
                            float _3373 = _3370 - float((int)(_3371));
                            float _3375 = _8[_3371];
                            float _3378 = _8[(_3371 + 1)];
                            float _3383 = _3375 * 0.5f;
                            _3423 = dot(float3((_3373 * _3373), _3373, 1.0f), float3(mad((_8[(_3371 + 2)]), 0.5f, mad(_3378, -1.0f, _3383)), (_3378 - _3375), mad(_3378, 0.5f, _3383)));
                          } else {
                            do {
                              if (!(!(_3354 >= _3362))) {
                                float _3392 = log2(ACESMinMaxData.z);
                                if (_3354 < (_3392 * 0.3010300099849701f)) {
                                  float _3400 = ((_3353 - _3361) * 0.9030900001525879f) / ((_3392 - _3361) * 0.3010300099849701f);
                                  int _3401 = int(_3400);
                                  float _3403 = _3400 - float((int)(_3401));
                                  float _3405 = _9[_3401];
                                  float _3408 = _9[(_3401 + 1)];
                                  float _3413 = _3405 * 0.5f;
                                  _3423 = dot(float3((_3403 * _3403), _3403, 1.0f), float3(mad((_9[(_3401 + 2)]), 0.5f, mad(_3408, -1.0f, _3413)), (_3408 - _3405), mad(_3408, 0.5f, _3413)));
                                  break;
                                }
                              }
                              _3423 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _3427 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _3428 = (exp2(_3275 * 3.321928024291992f) - ACESMinMaxData.y) / _3427;
                        float _3430 = (exp2(_3349 * 3.321928024291992f) - ACESMinMaxData.y) / _3427;
                        float _3432 = (exp2(_3423 * 3.321928024291992f) - ACESMinMaxData.y) / _3427;
                        float _3435 = mad(0.15618768334388733f, _3432, mad(0.13400420546531677f, _3430, (_3428 * 0.6624541878700256f)));
                        float _3438 = mad(0.053689517080783844f, _3432, mad(0.6740817427635193f, _3430, (_3428 * 0.2722287178039551f)));
                        float _3441 = mad(1.0103391408920288f, _3432, mad(0.00406073359772563f, _3430, (_3428 * -0.005574649665504694f)));
                        float _3454 = min(max(mad(-0.23642469942569733f, _3441, mad(-0.32480329275131226f, _3438, (_3435 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _3455 = min(max(mad(0.016756348311901093f, _3441, mad(1.6153316497802734f, _3438, (_3435 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _3456 = min(max(mad(0.9883948564529419f, _3441, mad(-0.008284442126750946f, _3438, (_3435 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _3459 = mad(0.15618768334388733f, _3456, mad(0.13400420546531677f, _3455, (_3454 * 0.6624541878700256f)));
                        float _3462 = mad(0.053689517080783844f, _3456, mad(0.6740817427635193f, _3455, (_3454 * 0.2722287178039551f)));
                        float _3465 = mad(1.0103391408920288f, _3456, mad(0.00406073359772563f, _3455, (_3454 * -0.005574649665504694f)));
                        float _3487 = min(max((min(max(mad(-0.23642469942569733f, _3465, mad(-0.32480329275131226f, _3462, (_3459 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _3488 = min(max((min(max(mad(0.016756348311901093f, _3465, mad(1.6153316497802734f, _3462, (_3459 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _3489 = min(max((min(max(mad(0.9883948564529419f, _3465, mad(-0.008284442126750946f, _3462, (_3459 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 6)) {
                            float _3492 = dot(float3(_3487, _3488, _3489), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                            float _3493 = _2226 * 300.0f;
                            float _3494 = _2229 * 300.0f;
                            float _3495 = _2232 * 300.0f;
                            do {
                              [branch]
                              if (!(_3492 < 1.0f)) {
                                if (_3492 < 5.0f) {
                                  float _3501 = (_3492 + -1.0f) * 0.25f;
                                  _3528 = ((_3501 * (_3493 - _3487)) + _3487);
                                  _3529 = ((_3501 * (_3494 - _3488)) + _3488);
                                  _3530 = ((_3501 * (_3495 - _3489)) + _3489);
                                } else {
                                  if (!(_3492 < 50.0f)) {
                                    if (_3492 < 150.0f) {
                                      float _3517 = (_3492 + -50.0f) * 0.009999999776482582f;
                                      _3528 = ((_3517 * (_3487 - _3493)) + _3493);
                                      _3529 = ((_3517 * (_3488 - _3494)) + _3494);
                                      _3530 = ((_3517 * (_3489 - _3495)) + _3495);
                                    } else {
                                      _3528 = _3487;
                                      _3529 = _3488;
                                      _3530 = _3489;
                                    }
                                  } else {
                                    _3528 = _3493;
                                    _3529 = _3494;
                                    _3530 = _3495;
                                  }
                                }
                              } else {
                                _3528 = _3487;
                                _3529 = _3488;
                                _3530 = _3489;
                              }
                              _3541 = mad(_45, _3530, mad(_44, _3529, (_3528 * _43)));
                              _3542 = mad(_48, _3530, mad(_47, _3529, (_3528 * _46)));
                              _3543 = mad(_51, _3530, mad(_50, _3529, (_3528 * _49)));
                            } while (false);
                          } else {
                            _3541 = _3487;
                            _3542 = _3488;
                            _3543 = _3489;
                          }
                          float _3553 = exp2(log2(_3541 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _3554 = exp2(log2(_3542 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _3555 = exp2(log2(_3543 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _3696 = exp2(log2((1.0f / ((_3553 * 18.6875f) + 1.0f)) * ((_3553 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3697 = exp2(log2((1.0f / ((_3554 * 18.6875f) + 1.0f)) * ((_3554 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3698 = exp2(log2((1.0f / ((_3555 * 18.6875f) + 1.0f)) * ((_3555 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _3588 = mad((WorkingColorSpace_ToAP1[0].z), _2202, mad((WorkingColorSpace_ToAP1[0].y), _2201, ((WorkingColorSpace_ToAP1[0].x) * _2200)));
            float _3591 = mad((WorkingColorSpace_ToAP1[1].z), _2202, mad((WorkingColorSpace_ToAP1[1].y), _2201, ((WorkingColorSpace_ToAP1[1].x) * _2200)));
            float _3594 = mad((WorkingColorSpace_ToAP1[2].z), _2202, mad((WorkingColorSpace_ToAP1[2].y), _2201, ((WorkingColorSpace_ToAP1[2].x) * _2200)));
            float _3613 = exp2(log2(mad(_45, _3594, mad(_44, _3591, (_3588 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _3614 = exp2(log2(mad(_48, _3594, mad(_47, _3591, (_3588 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _3615 = exp2(log2(mad(_51, _3594, mad(_50, _3591, (_3588 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3696 = exp2(log2((1.0f / ((_3613 * 18.6875f) + 1.0f)) * ((_3613 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3697 = exp2(log2((1.0f / ((_3614 * 18.6875f) + 1.0f)) * ((_3614 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3698 = exp2(log2((1.0f / ((_3615 * 18.6875f) + 1.0f)) * ((_3615 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _3650 = mad((WorkingColorSpace_ToAP1[0].z), _2190, mad((WorkingColorSpace_ToAP1[0].y), _2189, ((WorkingColorSpace_ToAP1[0].x) * _2188)));
                float _3653 = mad((WorkingColorSpace_ToAP1[1].z), _2190, mad((WorkingColorSpace_ToAP1[1].y), _2189, ((WorkingColorSpace_ToAP1[1].x) * _2188)));
                float _3656 = mad((WorkingColorSpace_ToAP1[2].z), _2190, mad((WorkingColorSpace_ToAP1[2].y), _2189, ((WorkingColorSpace_ToAP1[2].x) * _2188)));
                _3696 = mad(_45, _3656, mad(_44, _3653, (_3650 * _43)));
                _3697 = mad(_48, _3656, mad(_47, _3653, (_3650 * _46)));
                _3698 = mad(_51, _3656, mad(_50, _3653, (_3650 * _49)));
              } else {
                float _3669 = mad((WorkingColorSpace_ToAP1[0].z), _2246, mad((WorkingColorSpace_ToAP1[0].y), _2245, ((WorkingColorSpace_ToAP1[0].x) * _2244)));
                float _3672 = mad((WorkingColorSpace_ToAP1[1].z), _2246, mad((WorkingColorSpace_ToAP1[1].y), _2245, ((WorkingColorSpace_ToAP1[1].x) * _2244)));
                float _3675 = mad((WorkingColorSpace_ToAP1[2].z), _2246, mad((WorkingColorSpace_ToAP1[2].y), _2245, ((WorkingColorSpace_ToAP1[2].x) * _2244)));
                _3696 = exp2(log2(mad(_45, _3675, mad(_44, _3672, (_3669 * _43)))) * InverseGamma.z);
                _3697 = exp2(log2(mad(_48, _3675, mad(_47, _3672, (_3669 * _46)))) * InverseGamma.z);
                _3698 = exp2(log2(mad(_51, _3675, mad(_50, _3672, (_3669 * _49)))) * InverseGamma.z);
              }
            } else {
              _3696 = _2200;
              _3697 = _2201;
              _3698 = _2202;
            }
          }
        }
      }
    }
  }

  SV_Target.x = (_3696 * 0.9523810148239136f);
  SV_Target.y = (_3697 * 0.9523810148239136f);
  SV_Target.z = (_3698 * 0.9523810148239136f);
  */
  SV_Target.rgb = float3(0, 0, 0);
  SV_Target.w = 0.0f;
  return SV_Target;
}

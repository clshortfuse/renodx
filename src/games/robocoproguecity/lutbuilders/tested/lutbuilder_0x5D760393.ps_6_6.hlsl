#include "../filmiclutbuilder.hlsli"

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
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;

  float4 output_color;

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
  float _2646;
  float _2647;
  float _2648;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _32 = (output_gamut == 4);
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

  // if HDR is enabled, lutbuilder uses PQ as shaper
  if ((uint)output_device > (uint)2) {
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

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
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
  float _390 = (_379 / _386) + -1.0f;
  float _391 = (_382 / _386) + -1.0f;
  float _392 = (_385 / _386) + -1.0f;
  float _404 = (1.0f - exp2(((_386 * _386) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_390, _391, _392), float3(_390, _391, _392)) * -4.0f));
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
  float _787 = ((_673 * (((ColorOffset.x + ColorOffsetHighlights.x) + _570) + (((ColorGain.x * ColorGainHighlights.x) * _579) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _597) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _606) * _497) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _588)))))) + (_561 * (((ColorOffset.x + ColorOffsetShadows.x) + _437) + (((ColorGain.x * ColorGainShadows.x) * _451) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _479) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _493) * _497) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _465))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _682) + (((ColorGain.x * ColorGainMidtones.x) * _691) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _709) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _718) * _497) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _700))))) * _776);
  float _789 = ((_673 * (((ColorOffset.y + ColorOffsetHighlights.y) + _570) + (((ColorGain.y * ColorGainHighlights.y) * _579) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _597) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _606) * _498) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _588)))))) + (_561 * (((ColorOffset.y + ColorOffsetShadows.y) + _437) + (((ColorGain.y * ColorGainShadows.y) * _451) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _479) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _493) * _498) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _465))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _682) + (((ColorGain.y * ColorGainMidtones.y) * _691) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _709) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _718) * _498) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _700))))) * _776);
  float _791 = ((_673 * (((ColorOffset.z + ColorOffsetHighlights.z) + _570) + (((ColorGain.z * ColorGainHighlights.z) * _579) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _597) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _606) * _499) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _588)))))) + (_561 * (((ColorOffset.z + ColorOffsetShadows.z) + _437) + (((ColorGain.z * ColorGainShadows.z) * _451) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _479) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _493) * _499) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _465))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _682) + (((ColorGain.z * ColorGainMidtones.z) * _691) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _709) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _718) * _499) + _423)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _700))))) * _776);
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
  // AP1_RGB2Y
  float _1007 = lerp(_961, _958, 0.9599999785423279f);
  float _1008 = lerp(_961, _959, 0.9599999785423279f);
  float _1009 = lerp(_961, _960, 0.9599999785423279f);
  // END RRT

  // ApplyFilmicToneMap(float3(_1007, _1008, _1009));
#if 1
  ApplyFilmicToneMap(_1007, _1008, _1009, _827, _828, _829);
  float _1149 = _1007, _1150 = _1008, _1151 = _1009;
#else
  _1007 = log2(_1007) * 0.3010300099849701f;
  _1008 = log2(_1008) * 0.3010300099849701f;
  _1009 = log2(_1009) * 0.3010300099849701f;
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
#endif

  float _1161 = mad((WorkingColorSpace_FromAP1[0].z), _1151, mad((WorkingColorSpace_FromAP1[0].y), _1150, ((WorkingColorSpace_FromAP1[0].x) * _1149)));
  float _1162 = mad((WorkingColorSpace_FromAP1[1].z), _1151, mad((WorkingColorSpace_FromAP1[1].y), _1150, ((WorkingColorSpace_FromAP1[1].x) * _1149)));
  float _1163 = mad((WorkingColorSpace_FromAP1[2].z), _1151, mad((WorkingColorSpace_FromAP1[2].y), _1150, ((WorkingColorSpace_FromAP1[2].x) * _1149)));
  // _1161 = max(0, _1161);
  // _1162 = max(0, _1162);
  // _1163 = max(0, _1163);
  float _1189 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1161)) * _1161) + MappingPolynomial.z);
  float _1190 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1162)) * _1162) + MappingPolynomial.z);
  float _1191 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1163)) * _1163) + MappingPolynomial.z);
  float _1198 = ((OverlayColor.x - _1189) * OverlayColor.w) + _1189;
  float _1199 = ((OverlayColor.y - _1190) * OverlayColor.w) + _1190;
  float _1200 = ((OverlayColor.z - _1191) * OverlayColor.w) + _1191;

  if (GenerateOutput(_1198, _1199, _1200, SV_Target)) {
    return SV_Target;
  }

  // these lines get skipped anyway
  float _1201 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _791, mad((WorkingColorSpace_FromAP1[0].y), _789, (_787 * (WorkingColorSpace_FromAP1[0].x))));
  float _1202 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _791, mad((WorkingColorSpace_FromAP1[1].y), _789, ((WorkingColorSpace_FromAP1[1].x) * _787)));
  float _1203 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _791, mad((WorkingColorSpace_FromAP1[2].y), _789, ((WorkingColorSpace_FromAP1[2].x) * _787)));
  float _1210 = ((OverlayColor.x - _1201) * OverlayColor.w) + _1201;
  float _1211 = ((OverlayColor.y - _1202) * OverlayColor.w) + _1202;
  float _1212 = ((OverlayColor.z - _1203) * OverlayColor.w) + _1203;

  float _1224 = renodx::math::SignPow((_1198), InverseGamma.y);
  float _1225 = renodx::math::SignPow((_1199), InverseGamma.y);
  float _1226 = renodx::math::SignPow((_1200), InverseGamma.y);

  [branch]
  if (output_device == 0) {
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
        // if (_1266 < 0.0031306699384003878f) {
        //   _1279 = (_1266 * 12.920000076293945f);
        // } else {
        //   _1279 = (((pow(_1266, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        // }
        // do {
        //   if (_1267 < 0.0031306699384003878f) {
        //     _1290 = (_1267 * 12.920000076293945f);
        //   } else {
        //     _1290 = (((pow(_1267, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        //   }
        //   if (_1268 < 0.0031306699384003878f) {
        //     _2646 = _1279;
        //     _2647 = _1290;
        //     _2648 = (_1268 * 12.920000076293945f);
        //   } else {
        //     _2646 = _1279;
        //     _2647 = _1290;
        //     _2648 = (((pow(_1268, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        //   }
        // } while (false);
        float3 _1266_1267_1268 = float3(_1266, _1267, _1268);
        _1266_1267_1268 = renodx::color::srgb::EncodeSafe(_1266_1267_1268);
        _2646 = _1266_1267_1268.r, _2647 = _1266_1267_1268.g, _2648 = _1266_1267_1268.b;
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1317 = mad((WorkingColorSpace_ToAP1[0].z), _1226, mad((WorkingColorSpace_ToAP1[0].y), _1225, ((WorkingColorSpace_ToAP1[0].x) * _1224)));
      float _1320 = mad((WorkingColorSpace_ToAP1[1].z), _1226, mad((WorkingColorSpace_ToAP1[1].y), _1225, ((WorkingColorSpace_ToAP1[1].x) * _1224)));
      float _1323 = mad((WorkingColorSpace_ToAP1[2].z), _1226, mad((WorkingColorSpace_ToAP1[2].y), _1225, ((WorkingColorSpace_ToAP1[2].x) * _1224)));
      float _1333 = max(6.103519990574569e-05f, mad(_45, _1323, mad(_44, _1320, (_1317 * _43))));
      float _1334 = max(6.103519990574569e-05f, mad(_48, _1323, mad(_47, _1320, (_1317 * _46))));
      float _1335 = max(6.103519990574569e-05f, mad(_51, _1323, mad(_50, _1320, (_1317 * _49))));
      _2646 = min((_1333 * 4.5f), ((exp2(log2(max(_1333, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2647 = min((_1334 * 4.5f), ((exp2(log2(max(_1334, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2648 = min((_1335 * 4.5f), ((exp2(log2(max(_1335, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
                        if (!(output_device == 5)) {
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
                        _2646 = exp2(log2((1.0f / ((_1905 * 18.6875f) + 1.0f)) * ((_1905 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2647 = exp2(log2((1.0f / ((_1906 * 18.6875f) + 1.0f)) * ((_1906 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2648 = exp2(log2((1.0f / ((_1907 * 18.6875f) + 1.0f)) * ((_1907 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
                          if (!(output_device == 6)) {
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
                          _2646 = exp2(log2((1.0f / ((_2479 * 18.6875f) + 1.0f)) * ((_2479 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2647 = exp2(log2((1.0f / ((_2480 * 18.6875f) + 1.0f)) * ((_2480 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2648 = exp2(log2((1.0f / ((_2481 * 18.6875f) + 1.0f)) * ((_2481 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2526 = mad((WorkingColorSpace_ToAP1[0].z), _1212, mad((WorkingColorSpace_ToAP1[0].y), _1211, ((WorkingColorSpace_ToAP1[0].x) * _1210)));
            float _2529 = mad((WorkingColorSpace_ToAP1[1].z), _1212, mad((WorkingColorSpace_ToAP1[1].y), _1211, ((WorkingColorSpace_ToAP1[1].x) * _1210)));
            float _2532 = mad((WorkingColorSpace_ToAP1[2].z), _1212, mad((WorkingColorSpace_ToAP1[2].y), _1211, ((WorkingColorSpace_ToAP1[2].x) * _1210)));
            float _2551 = exp2(log2(mad(_45, _2532, mad(_44, _2529, (_2526 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2552 = exp2(log2(mad(_48, _2532, mad(_47, _2529, (_2526 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2553 = exp2(log2(mad(_51, _2532, mad(_50, _2529, (_2526 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2646 = exp2(log2((1.0f / ((_2551 * 18.6875f) + 1.0f)) * ((_2551 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2647 = exp2(log2((1.0f / ((_2552 * 18.6875f) + 1.0f)) * ((_2552 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2648 = exp2(log2((1.0f / ((_2553 * 18.6875f) + 1.0f)) * ((_2553 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2600 = mad((WorkingColorSpace_ToAP1[0].z), _1200, mad((WorkingColorSpace_ToAP1[0].y), _1199, ((WorkingColorSpace_ToAP1[0].x) * _1198)));
                float _2603 = mad((WorkingColorSpace_ToAP1[1].z), _1200, mad((WorkingColorSpace_ToAP1[1].y), _1199, ((WorkingColorSpace_ToAP1[1].x) * _1198)));
                float _2606 = mad((WorkingColorSpace_ToAP1[2].z), _1200, mad((WorkingColorSpace_ToAP1[2].y), _1199, ((WorkingColorSpace_ToAP1[2].x) * _1198)));
                _2646 = mad(_45, _2606, mad(_44, _2603, (_2600 * _43)));
                _2647 = mad(_48, _2606, mad(_47, _2603, (_2600 * _46)));
                _2648 = mad(_51, _2606, mad(_50, _2603, (_2600 * _49)));
              } else {
                float _2619 = mad((WorkingColorSpace_ToAP1[0].z), _1226, mad((WorkingColorSpace_ToAP1[0].y), _1225, ((WorkingColorSpace_ToAP1[0].x) * _1224)));
                float _2622 = mad((WorkingColorSpace_ToAP1[1].z), _1226, mad((WorkingColorSpace_ToAP1[1].y), _1225, ((WorkingColorSpace_ToAP1[1].x) * _1224)));
                float _2625 = mad((WorkingColorSpace_ToAP1[2].z), _1226, mad((WorkingColorSpace_ToAP1[2].y), _1225, ((WorkingColorSpace_ToAP1[2].x) * _1224)));
                _2646 = exp2(log2(mad(_45, _2625, mad(_44, _2622, (_2619 * _43)))) * InverseGamma.z);
                _2647 = exp2(log2(mad(_48, _2625, mad(_47, _2622, (_2619 * _46)))) * InverseGamma.z);
                _2648 = exp2(log2(mad(_51, _2625, mad(_50, _2622, (_2619 * _49)))) * InverseGamma.z);
              }
            } else {
              _2646 = _1210;
              _2647 = _1211;
              _2648 = _1212;
            }
          }
        }
      }
    }
  }

  output_color.rgb = float3(_2646, _2647, _2648);
  // if (OutputDevice != 0u && OutputGamut != 0u && RENODX_TONE_MAP_TYPE != 0.f) {
  //   // output_color.rgb = renodx::color::gamma::DecodeSafe(output_color.rgb, 2.2f);
  //   output_color.rgb = renodx::color::srgb::DecodeSafe(output_color.rgb);
  //   output_color.rgb = renodx::color::bt2020::from::BT709(output_color.rgb);
  //   output_color.rgb = renodx::color::pq::EncodeSafe(output_color.rgb, RENODX_DIFFUSE_WHITE_NITS);
  // }

  SV_Target.x = (output_color.r / 1.05f);
  SV_Target.y = (output_color.g / 1.05f);
  SV_Target.z = (output_color.b / 1.05f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

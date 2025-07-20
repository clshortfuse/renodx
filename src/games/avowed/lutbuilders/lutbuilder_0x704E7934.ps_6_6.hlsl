#include "../common.hlsl"

// Found in Slitterhead

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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _12 = 0.5f / LUTSize;
  float _17 = LUTSize + -1.0f;
  float _18 = (LUTSize * (TEXCOORD.x - _12)) / _17;
  float _19 = (LUTSize * (TEXCOORD.y - _12)) / _17;
  float _21 = float((uint)SV_RenderTargetArrayIndex) / _17;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _107;
  float _108;
  float _109;
  float _157;
  float _1150;
  float _1151;
  float _1152;
  float _1163;
  float _1174;
  float _1287;
  float _1288;
  float _1289;
  float _1371;
  float _1372;
  float _1373;
  float _1550;
  float _1551;
  float _1552;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _30 = ((uint)(OutputGamut) == 4);
        _41 = select(_30, 1.0f, 1.7050515413284302f);
        _42 = select(_30, 0.0f, -0.6217905879020691f);
        _43 = select(_30, 0.0f, -0.0832584798336029f);
        _44 = select(_30, 0.0f, -0.13025718927383423f);
        _45 = select(_30, 1.0f, 1.1408027410507202f);
        _46 = select(_30, 0.0f, -0.010548528283834457f);
        _47 = select(_30, 0.0f, -0.024003278464078903f);
        _48 = select(_30, 0.0f, -0.1289687603712082f);
        _49 = select(_30, 1.0f, 1.152971863746643f);
      } else {
        _41 = 0.6954522132873535f;
        _42 = 0.14067870378494263f;
        _43 = 0.16386906802654266f;
        _44 = 0.044794563204050064f;
        _45 = 0.8596711158752441f;
        _46 = 0.0955343171954155f;
        _47 = -0.005525882821530104f;
        _48 = 0.004025210160762072f;
        _49 = 1.0015007257461548f;
      }
    } else {
      _41 = 1.02579927444458f;
      _42 = -0.020052503794431686f;
      _43 = -0.0057713985443115234f;
      _44 = -0.0022350111976265907f;
      _45 = 1.0045825242996216f;
      _46 = -0.002352306619286537f;
      _47 = -0.005014004185795784f;
      _48 = -0.025293385609984398f;
      _49 = 1.0304402112960815f;
    }
  } else {
    _41 = 1.379158854484558f;
    _42 = -0.3088507056236267f;
    _43 = -0.07034677267074585f;
    _44 = -0.06933528929948807f;
    _45 = 1.0822921991348267f;
    _46 = -0.012962047010660172f;
    _47 = -0.002159259282052517f;
    _48 = -0.045465391129255295f;
    _49 = 1.0477596521377563f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _60 = (pow(_18, 0.012683313339948654f));
    float _61 = (pow(_19, 0.012683313339948654f));
    float _62 = (pow(_21, 0.012683313339948654f));
    _107 = (exp2(log2(max(0.0f, (_60 + -0.8359375f)) / (18.8515625f - (_60 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _108 = (exp2(log2(max(0.0f, (_61 + -0.8359375f)) / (18.8515625f - (_61 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _109 = (exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _107 = ((exp2((_18 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _108 = ((exp2((_19 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _109 = ((exp2((_21 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _136 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _140 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _157 = (((((2967800.0f - (_140 * 4607000064.0f)) * _140) + 99.11000061035156f) * _140) + 0.24406300485134125f);
  } else {
    _157 = (((((1901800.0f - (_140 * 2006400000.0f)) * _140) + 247.47999572753906f) * _140) + 0.23703999817371368f);
  }
  float _171 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _178 = WhiteTemp * WhiteTemp;
  float _181 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_178 * 1.6145605741257896e-07f));
  float _186 = ((_171 * 2.0f) + 4.0f) - (_181 * 8.0f);
  float _187 = (_171 * 3.0f) / _186;
  float _189 = (_181 * 2.0f) / _186;
  bool _190 = (WhiteTemp < 4000.0f);
  float _199 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _201 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_178 * 1.5317699909210205f)) / (_199 * _199);
  float _208 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _178;
  float _210 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_178 * 308.60699462890625f)) / (_208 * _208);
  float _212 = rsqrt(dot(float2(_201, _210), float2(_201, _210)));
  float _213 = WhiteTint * 0.05000000074505806f;
  float _216 = ((_213 * _210) * _212) + _171;
  float _219 = _181 - ((_213 * _201) * _212);
  float _224 = (4.0f - (_219 * 8.0f)) + (_216 * 2.0f);
  float _230 = (((_216 * 3.0f) / _224) - _187) + select(_190, _187, _157);
  float _231 = (((_219 * 2.0f) / _224) - _189) + select(_190, _189, (((_157 * 2.869999885559082f) + -0.2750000059604645f) - ((_157 * _157) * 3.0f)));
  float _232 = select(_136, _230, 0.3127000033855438f);
  float _233 = select(_136, _231, 0.32899999618530273f);
  float _234 = select(_136, 0.3127000033855438f, _230);
  float _235 = select(_136, 0.32899999618530273f, _231);
  float _236 = max(_233, 1.000000013351432e-10f);
  float _237 = _232 / _236;
  float _240 = ((1.0f - _232) - _233) / _236;
  float _241 = max(_235, 1.000000013351432e-10f);
  float _242 = _234 / _241;
  float _245 = ((1.0f - _234) - _235) / _241;
  float _264 = mad(-0.16140000522136688f, _245, ((_242 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _240, ((_237 * 0.8950999975204468f) + 0.266400009393692f));
  float _265 = mad(0.03669999912381172f, _245, (1.7135000228881836f - (_242 * 0.7501999735832214f))) / mad(0.03669999912381172f, _240, (1.7135000228881836f - (_237 * 0.7501999735832214f)));
  float _266 = mad(1.0296000242233276f, _245, ((_242 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _240, ((_237 * 0.03889999911189079f) + -0.06849999725818634f));
  float _267 = mad(_265, -0.7501999735832214f, 0.0f);
  float _268 = mad(_265, 1.7135000228881836f, 0.0f);
  float _269 = mad(_265, 0.03669999912381172f, -0.0f);
  float _270 = mad(_266, 0.03889999911189079f, 0.0f);
  float _271 = mad(_266, -0.06849999725818634f, 0.0f);
  float _272 = mad(_266, 1.0296000242233276f, 0.0f);
  float _275 = mad(0.1599626988172531f, _270, mad(-0.1470542997121811f, _267, (_264 * 0.883457362651825f)));
  float _278 = mad(0.1599626988172531f, _271, mad(-0.1470542997121811f, _268, (_264 * 0.26293492317199707f)));
  float _281 = mad(0.1599626988172531f, _272, mad(-0.1470542997121811f, _269, (_264 * -0.15930065512657166f)));
  float _284 = mad(0.04929120093584061f, _270, mad(0.5183603167533875f, _267, (_264 * 0.38695648312568665f)));
  float _287 = mad(0.04929120093584061f, _271, mad(0.5183603167533875f, _268, (_264 * 0.11516613513231277f)));
  float _290 = mad(0.04929120093584061f, _272, mad(0.5183603167533875f, _269, (_264 * -0.0697740763425827f)));
  float _293 = mad(0.9684867262840271f, _270, mad(0.04004279896616936f, _267, (_264 * -0.007634039502590895f)));
  float _296 = mad(0.9684867262840271f, _271, mad(0.04004279896616936f, _268, (_264 * -0.0022720457054674625f)));
  float _299 = mad(0.9684867262840271f, _272, mad(0.04004279896616936f, _269, (_264 * 0.0013765322510153055f)));
  float _302 = mad(_281, (WorkingColorSpace_ToXYZ[2].x), mad(_278, (WorkingColorSpace_ToXYZ[1].x), (_275 * (WorkingColorSpace_ToXYZ[0].x))));
  float _305 = mad(_281, (WorkingColorSpace_ToXYZ[2].y), mad(_278, (WorkingColorSpace_ToXYZ[1].y), (_275 * (WorkingColorSpace_ToXYZ[0].y))));
  float _308 = mad(_281, (WorkingColorSpace_ToXYZ[2].z), mad(_278, (WorkingColorSpace_ToXYZ[1].z), (_275 * (WorkingColorSpace_ToXYZ[0].z))));
  float _311 = mad(_290, (WorkingColorSpace_ToXYZ[2].x), mad(_287, (WorkingColorSpace_ToXYZ[1].x), (_284 * (WorkingColorSpace_ToXYZ[0].x))));
  float _314 = mad(_290, (WorkingColorSpace_ToXYZ[2].y), mad(_287, (WorkingColorSpace_ToXYZ[1].y), (_284 * (WorkingColorSpace_ToXYZ[0].y))));
  float _317 = mad(_290, (WorkingColorSpace_ToXYZ[2].z), mad(_287, (WorkingColorSpace_ToXYZ[1].z), (_284 * (WorkingColorSpace_ToXYZ[0].z))));
  float _320 = mad(_299, (WorkingColorSpace_ToXYZ[2].x), mad(_296, (WorkingColorSpace_ToXYZ[1].x), (_293 * (WorkingColorSpace_ToXYZ[0].x))));
  float _323 = mad(_299, (WorkingColorSpace_ToXYZ[2].y), mad(_296, (WorkingColorSpace_ToXYZ[1].y), (_293 * (WorkingColorSpace_ToXYZ[0].y))));
  float _326 = mad(_299, (WorkingColorSpace_ToXYZ[2].z), mad(_296, (WorkingColorSpace_ToXYZ[1].z), (_293 * (WorkingColorSpace_ToXYZ[0].z))));
  float _356 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _326, mad((WorkingColorSpace_FromXYZ[0].y), _317, (_308 * (WorkingColorSpace_FromXYZ[0].x)))), _109, mad(mad((WorkingColorSpace_FromXYZ[0].z), _323, mad((WorkingColorSpace_FromXYZ[0].y), _314, (_305 * (WorkingColorSpace_FromXYZ[0].x)))), _108, (mad((WorkingColorSpace_FromXYZ[0].z), _320, mad((WorkingColorSpace_FromXYZ[0].y), _311, (_302 * (WorkingColorSpace_FromXYZ[0].x)))) * _107)));
  float _359 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _326, mad((WorkingColorSpace_FromXYZ[1].y), _317, (_308 * (WorkingColorSpace_FromXYZ[1].x)))), _109, mad(mad((WorkingColorSpace_FromXYZ[1].z), _323, mad((WorkingColorSpace_FromXYZ[1].y), _314, (_305 * (WorkingColorSpace_FromXYZ[1].x)))), _108, (mad((WorkingColorSpace_FromXYZ[1].z), _320, mad((WorkingColorSpace_FromXYZ[1].y), _311, (_302 * (WorkingColorSpace_FromXYZ[1].x)))) * _107)));
  float _362 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _326, mad((WorkingColorSpace_FromXYZ[2].y), _317, (_308 * (WorkingColorSpace_FromXYZ[2].x)))), _109, mad(mad((WorkingColorSpace_FromXYZ[2].z), _323, mad((WorkingColorSpace_FromXYZ[2].y), _314, (_305 * (WorkingColorSpace_FromXYZ[2].x)))), _108, (mad((WorkingColorSpace_FromXYZ[2].z), _320, mad((WorkingColorSpace_FromXYZ[2].y), _311, (_302 * (WorkingColorSpace_FromXYZ[2].x)))) * _107)));
  float _377 = mad((WorkingColorSpace_ToAP1[0].z), _362, mad((WorkingColorSpace_ToAP1[0].y), _359, ((WorkingColorSpace_ToAP1[0].x) * _356)));
  float _380 = mad((WorkingColorSpace_ToAP1[1].z), _362, mad((WorkingColorSpace_ToAP1[1].y), _359, ((WorkingColorSpace_ToAP1[1].x) * _356)));
  float _383 = mad((WorkingColorSpace_ToAP1[2].z), _362, mad((WorkingColorSpace_ToAP1[2].y), _359, ((WorkingColorSpace_ToAP1[2].x) * _356)));
  float _384 = dot(float3(_377, _380, _383), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_377, _380, _383));

  float _388 = (_377 / _384) + -1.0f;
  float _389 = (_380 / _384) + -1.0f;
  float _390 = (_383 / _384) + -1.0f;
  float _402 = (1.0f - exp2(((_384 * _384) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_388, _389, _390), float3(_388, _389, _390)) * -4.0f));
  float _418 = ((mad(-0.06368283927440643f, _383, mad(-0.32929131388664246f, _380, (_377 * 1.370412826538086f))) - _377) * _402) + _377;
  float _419 = ((mad(-0.010861567221581936f, _383, mad(1.0970908403396606f, _380, (_377 * -0.08343426138162613f))) - _380) * _402) + _380;
  float _420 = ((mad(1.203694462776184f, _383, mad(-0.09862564504146576f, _380, (_377 * -0.02579325996339321f))) - _383) * _402) + _383;
  float _421 = dot(float3(_418, _419, _420), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _435 = ColorOffset.w + ColorOffsetShadows.w;
  float _449 = ColorGain.w * ColorGainShadows.w;
  float _463 = ColorGamma.w * ColorGammaShadows.w;
  float _477 = ColorContrast.w * ColorContrastShadows.w;
  float _491 = ColorSaturation.w * ColorSaturationShadows.w;
  float _495 = _418 - _421;
  float _496 = _419 - _421;
  float _497 = _420 - _421;
  float _554 = saturate(_421 / ColorCorrectionShadowsMax);
  float _558 = (_554 * _554) * (3.0f - (_554 * 2.0f));
  float _559 = 1.0f - _558;
  float _568 = ColorOffset.w + ColorOffsetHighlights.w;
  float _577 = ColorGain.w * ColorGainHighlights.w;
  float _586 = ColorGamma.w * ColorGammaHighlights.w;
  float _595 = ColorContrast.w * ColorContrastHighlights.w;
  float _604 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _667 = saturate((_421 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _671 = (_667 * _667) * (3.0f - (_667 * 2.0f));
  float _680 = ColorOffset.w + ColorOffsetMidtones.w;
  float _689 = ColorGain.w * ColorGainMidtones.w;
  float _698 = ColorGamma.w * ColorGammaMidtones.w;
  float _707 = ColorContrast.w * ColorContrastMidtones.w;
  float _716 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _774 = _558 - _671;
  float _790 = max((((_671 * (((ColorOffset.x + ColorOffsetHighlights.x) + _568) + (((ColorGain.x * ColorGainHighlights.x) * _577) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _595) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _604) * _495) + _421)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _586)))))) + (_559 * (((ColorOffset.x + ColorOffsetShadows.x) + _435) + (((ColorGain.x * ColorGainShadows.x) * _449) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _477) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _491) * _495) + _421)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _463))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _680) + (((ColorGain.x * ColorGainMidtones.x) * _689) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _707) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _716) * _495) + _421)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _698))))) * _774)), 9.999999974752427e-07f);
  float _791 = max((((_671 * (((ColorOffset.y + ColorOffsetHighlights.y) + _568) + (((ColorGain.y * ColorGainHighlights.y) * _577) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _595) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _604) * _496) + _421)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _586)))))) + (_559 * (((ColorOffset.y + ColorOffsetShadows.y) + _435) + (((ColorGain.y * ColorGainShadows.y) * _449) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _477) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _491) * _496) + _421)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _463))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _680) + (((ColorGain.y * ColorGainMidtones.y) * _689) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _707) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _716) * _496) + _421)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _698))))) * _774)), 9.999999974752427e-07f);
  float _792 = max((((_671 * (((ColorOffset.z + ColorOffsetHighlights.z) + _568) + (((ColorGain.z * ColorGainHighlights.z) * _577) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _595) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _604) * _497) + _421)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _586)))))) + (_559 * (((ColorOffset.z + ColorOffsetShadows.z) + _435) + (((ColorGain.z * ColorGainShadows.z) * _449) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _477) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _491) * _497) + _421)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _463))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _680) + (((ColorGain.z * ColorGainMidtones.z) * _689) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _707) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _716) * _497) + _421)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _698))))) * _774)), 9.999999974752427e-07f);
  float _811 = (log2(_790) + 9.720000267028809f) * 0.05707762390375137f;
  float _812 = (log2(_791) + 9.720000267028809f) * 0.05707762390375137f;
  float _813 = (log2(_792) + 9.720000267028809f) * 0.05707762390375137f;
  float _820 = ((((_790 * 10.540237426757812f) + 0.072905533015728f) - _811) * select((_790 > 0.0078125f), 0.0f, 1.0f)) + _811;
  float _821 = ((((_791 * 10.540237426757812f) + 0.072905533015728f) - _812) * select((_791 > 0.0078125f), 0.0f, 1.0f)) + _812;
  float _822 = ((((_792 * 10.540237426757812f) + 0.072905533015728f) - _813) * select((_792 > 0.0078125f), 0.0f, 1.0f)) + _813;
  float _825 = (_821 * 0.9375f) + 0.03125f;
  float _832 = _822 * 15.0f;
  float _833 = floor(_832);
  float _834 = _832 - _833;
  float _837 = ((_833 + 0.03125f) + (_820 * 0.9375f)) * 0.0625f;
  float4 _840 = Textures_1.Sample(Samplers_1, float2(_837, _825));
  float4 _847 = Textures_1.Sample(Samplers_1, float2((_837 + 0.0625f), _825));
  float _863 = ((lerp(_840.x, _847.x, _834)) * (LUTWeights[0].y)) + (_820 * (LUTWeights[0].x));
  float _864 = ((lerp(_840.y, _847.y, _834)) * (LUTWeights[0].y)) + (_821 * (LUTWeights[0].x));
  float _865 = ((lerp(_840.z, _847.z, _834)) * (LUTWeights[0].y)) + (_822 * (LUTWeights[0].x));
  float _884 = exp2((_863 * 17.520000457763672f) + -9.720000267028809f);
  float _885 = exp2((_864 * 17.520000457763672f) + -9.720000267028809f);
  float _886 = exp2((_865 * 17.520000457763672f) + -9.720000267028809f);
  float _893 = ((((_863 + -0.072905533015728f) * 0.09487452358007431f) - _884) * select((_863 > 0.155251145362854f), 0.0f, 1.0f)) + _884;
  float _894 = ((((_864 + -0.072905533015728f) * 0.09487452358007431f) - _885) * select((_864 > 0.155251145362854f), 0.0f, 1.0f)) + _885;
  float _895 = ((((_865 + -0.072905533015728f) * 0.09487452358007431f) - _886) * select((_865 > 0.155251145362854f), 0.0f, 1.0f)) + _886;

  SetUntonemappedAP1(float3(_893, _894, _895));

  float _932 = ((mad(0.061360642313957214f, _895, mad(-4.540197551250458e-09f, _894, (_893 * 0.9386394023895264f))) - _893) * BlueCorrection) + _893;
  float _933 = ((mad(0.169205904006958f, _895, mad(0.8307942152023315f, _894, (_893 * 6.775371730327606e-08f))) - _894) * BlueCorrection) + _894;
  float _934 = (mad(-2.3283064365386963e-10f, _894, (_893 * -9.313225746154785e-10f)) * BlueCorrection) + _895;
  float _949 = dot(float3(_932, _933, _934), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _956 = ((_932 - _949) * 0.9599999785423279f) + _949;
  float _957 = ((_933 - _949) * 0.9599999785423279f) + _949;
  float _958 = ((_934 - _949) * 0.9599999785423279f) + _949;
  float _959 = -0.0f - HyperbolaToe.x;
  float _975 = -0.0f - HyperbolaShoulder.x;
  float _994 = select((_956 < HyperbolaThreshold.x), ((_959 / (_956 + HyperbolaToe.y)) + HyperbolaToe.z), select((_956 < HyperbolaThreshold.y), ((_956 * HyperbolaMid.x) + HyperbolaMid.y), ((_975 / (_956 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _995 = select((_957 < HyperbolaThreshold.x), ((_959 / (_957 + HyperbolaToe.y)) + HyperbolaToe.z), select((_957 < HyperbolaThreshold.y), ((_957 * HyperbolaMid.x) + HyperbolaMid.y), ((_975 / (_957 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _996 = select((_958 < HyperbolaThreshold.x), ((_959 / (_958 + HyperbolaToe.y)) + HyperbolaToe.z), select((_958 < HyperbolaThreshold.y), ((_958 * HyperbolaMid.x) + HyperbolaMid.y), ((_975 / (_958 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _997 = dot(float3(_994, _995, _996), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1015 = (((_997 - _932) + ((_994 - _997) * 0.9300000071525574f)) * ToneCurveAmount) + _932;
  float _1016 = (((_997 - _933) + ((_995 - _997) * 0.9300000071525574f)) * ToneCurveAmount) + _933;
  float _1017 = (((_997 - _934) + ((_996 - _997) * 0.9300000071525574f)) * ToneCurveAmount) + _934;
  float _1033 = ((mad(-0.06537103652954102f, _1017, mad(1.451815478503704e-06f, _1016, (_1015 * 1.065374732017517f))) - _1015) * BlueCorrection) + _1015;
  float _1034 = ((mad(-0.20366770029067993f, _1017, mad(1.2036634683609009f, _1016, (_1015 * -2.57161445915699e-07f))) - _1016) * BlueCorrection) + _1016;
  float _1035 = ((mad(0.9999996423721313f, _1017, mad(2.0954757928848267e-08f, _1016, (_1015 * 1.862645149230957e-08f))) - _1017) * BlueCorrection) + _1017;

  SetTonemappedAP1(_1033, _1034, _1035);

  float _1045 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1035, mad((WorkingColorSpace_FromAP1[0].y), _1034, ((WorkingColorSpace_FromAP1[0].x) * _1033))));
  float _1046 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1035, mad((WorkingColorSpace_FromAP1[1].y), _1034, ((WorkingColorSpace_FromAP1[1].x) * _1033))));
  float _1047 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1035, mad((WorkingColorSpace_FromAP1[2].y), _1034, ((WorkingColorSpace_FromAP1[2].x) * _1033))));
  float _1073 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1045)) * _1045) + MappingPolynomial.z);
  float _1074 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1046)) * _1046) + MappingPolynomial.z);
  float _1075 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1047)) * _1047) + MappingPolynomial.z);
  float _1082 = ((OverlayColor.x - _1073) * OverlayColor.w) + _1073;
  float _1083 = ((OverlayColor.y - _1074) * OverlayColor.w) + _1074;
  float _1084 = ((OverlayColor.z - _1075) * OverlayColor.w) + _1075;
  float _1085 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _895, mad((WorkingColorSpace_FromAP1[0].y), _894, (_893 * (WorkingColorSpace_FromAP1[0].x))));
  float _1086 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _895, mad((WorkingColorSpace_FromAP1[1].y), _894, (_893 * (WorkingColorSpace_FromAP1[1].x))));
  float _1087 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _895, mad((WorkingColorSpace_FromAP1[2].y), _894, (_893 * (WorkingColorSpace_FromAP1[2].x))));
  float _1094 = ((OverlayColor.x - _1085) * OverlayColor.w) + _1085;
  float _1095 = ((OverlayColor.y - _1086) * OverlayColor.w) + _1086;
  float _1096 = ((OverlayColor.z - _1087) * OverlayColor.w) + _1087;
  float _1108 = exp2(log2(max(0.0f, _1082)) * InverseGamma.y);
  float _1109 = exp2(log2(max(0.0f, _1083)) * InverseGamma.y);
  float _1110 = exp2(log2(max(0.0f, _1084)) * InverseGamma.y);

  if (true) {
    return GenerateOutput(float3(_1108, _1109, _1110), OutputDevice);
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1133 = mad((WorkingColorSpace_ToAP1[0].z), _1110, mad((WorkingColorSpace_ToAP1[0].y), _1109, ((WorkingColorSpace_ToAP1[0].x) * _1108)));
        float _1136 = mad((WorkingColorSpace_ToAP1[1].z), _1110, mad((WorkingColorSpace_ToAP1[1].y), _1109, ((WorkingColorSpace_ToAP1[1].x) * _1108)));
        float _1139 = mad((WorkingColorSpace_ToAP1[2].z), _1110, mad((WorkingColorSpace_ToAP1[2].y), _1109, ((WorkingColorSpace_ToAP1[2].x) * _1108)));
        _1150 = mad(_43, _1139, mad(_42, _1136, (_1133 * _41)));
        _1151 = mad(_46, _1139, mad(_45, _1136, (_1133 * _44)));
        _1152 = mad(_49, _1139, mad(_48, _1136, (_1133 * _47)));
      } else {
        _1150 = _1108;
        _1151 = _1109;
        _1152 = _1110;
      }
      do {
        if (_1150 < 0.0031306699384003878f) {
          _1163 = (_1150 * 12.920000076293945f);
        } else {
          _1163 = (((pow(_1150, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1151 < 0.0031306699384003878f) {
            _1174 = (_1151 * 12.920000076293945f);
          } else {
            _1174 = (((pow(_1151, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1152 < 0.0031306699384003878f) {
            _1550 = _1163;
            _1551 = _1174;
            _1552 = (_1152 * 12.920000076293945f);
          } else {
            _1550 = _1163;
            _1551 = _1174;
            _1552 = (((pow(_1152, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1201 = mad((WorkingColorSpace_ToAP1[0].z), _1110, mad((WorkingColorSpace_ToAP1[0].y), _1109, ((WorkingColorSpace_ToAP1[0].x) * _1108)));
      float _1204 = mad((WorkingColorSpace_ToAP1[1].z), _1110, mad((WorkingColorSpace_ToAP1[1].y), _1109, ((WorkingColorSpace_ToAP1[1].x) * _1108)));
      float _1207 = mad((WorkingColorSpace_ToAP1[2].z), _1110, mad((WorkingColorSpace_ToAP1[2].y), _1109, ((WorkingColorSpace_ToAP1[2].x) * _1108)));
      float _1217 = max(6.103519990574569e-05f, mad(_43, _1207, mad(_42, _1204, (_1201 * _41))));
      float _1218 = max(6.103519990574569e-05f, mad(_46, _1207, mad(_45, _1204, (_1201 * _44))));
      float _1219 = max(6.103519990574569e-05f, mad(_49, _1207, mad(_48, _1204, (_1201 * _47))));
      _1550 = min((_1217 * 4.5f), ((exp2(log2(max(_1217, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1551 = min((_1218 * 4.5f), ((exp2(log2(max(_1218, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1552 = min((_1219 * 4.5f), ((exp2(log2(max(_1219, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        float _1251 = HyperbolaMultiplier.x * _1082;
        float _1252 = HyperbolaMultiplier.x * _1083;
        float _1253 = HyperbolaMultiplier.x * _1084;
        float _1268 = mad((WorkingColorSpace_ToAP1[0].z), _1253, mad((WorkingColorSpace_ToAP1[0].y), _1252, ((WorkingColorSpace_ToAP1[0].x) * _1251)));
        float _1271 = mad((WorkingColorSpace_ToAP1[1].z), _1253, mad((WorkingColorSpace_ToAP1[1].y), _1252, ((WorkingColorSpace_ToAP1[1].x) * _1251)));
        float _1274 = mad((WorkingColorSpace_ToAP1[2].z), _1253, mad((WorkingColorSpace_ToAP1[2].y), _1252, ((WorkingColorSpace_ToAP1[2].x) * _1251)));
        do {
          if (!((uint)(OutputDevice) == 5)) {
            _1287 = mad(_43, _1274, mad(_42, _1271, (_1268 * _41)));
            _1288 = mad(_46, _1274, mad(_45, _1271, (_1268 * _44)));
            _1289 = mad(_49, _1274, mad(_48, _1271, (_1268 * _47)));
          } else {
            _1287 = _1268;
            _1288 = _1271;
            _1289 = _1274;
          }
          float _1299 = exp2(log2(_1287 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1300 = exp2(log2(_1288 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1301 = exp2(log2(_1289 * 9.999999747378752e-05f) * 0.1593017578125f);
          _1550 = exp2(log2((1.0f / ((_1299 * 18.6875f) + 1.0f)) * ((_1299 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1551 = exp2(log2((1.0f / ((_1300 * 18.6875f) + 1.0f)) * ((_1300 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1552 = exp2(log2((1.0f / ((_1301 * 18.6875f) + 1.0f)) * ((_1301 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        } while (false);
      } else {
        if (((uint)(OutputDevice) & -3) == 4) {
          float _1335 = HyperbolaMultiplier.x * _1082;
          float _1336 = HyperbolaMultiplier.x * _1083;
          float _1337 = HyperbolaMultiplier.x * _1084;
          float _1352 = mad((WorkingColorSpace_ToAP1[0].z), _1337, mad((WorkingColorSpace_ToAP1[0].y), _1336, ((WorkingColorSpace_ToAP1[0].x) * _1335)));
          float _1355 = mad((WorkingColorSpace_ToAP1[1].z), _1337, mad((WorkingColorSpace_ToAP1[1].y), _1336, ((WorkingColorSpace_ToAP1[1].x) * _1335)));
          float _1358 = mad((WorkingColorSpace_ToAP1[2].z), _1337, mad((WorkingColorSpace_ToAP1[2].y), _1336, ((WorkingColorSpace_ToAP1[2].x) * _1335)));
          do {
            if (!((uint)(OutputDevice) == 6)) {
              _1371 = mad(_43, _1358, mad(_42, _1355, (_1352 * _41)));
              _1372 = mad(_46, _1358, mad(_45, _1355, (_1352 * _44)));
              _1373 = mad(_49, _1358, mad(_48, _1355, (_1352 * _47)));
            } else {
              _1371 = _1352;
              _1372 = _1355;
              _1373 = _1358;
            }
            float _1383 = exp2(log2(_1371 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1384 = exp2(log2(_1372 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1385 = exp2(log2(_1373 * 9.999999747378752e-05f) * 0.1593017578125f);
            _1550 = exp2(log2((1.0f / ((_1383 * 18.6875f) + 1.0f)) * ((_1383 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1551 = exp2(log2((1.0f / ((_1384 * 18.6875f) + 1.0f)) * ((_1384 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1552 = exp2(log2((1.0f / ((_1385 * 18.6875f) + 1.0f)) * ((_1385 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } while (false);
        } else {
          if ((uint)(OutputDevice) == 7) {
            float _1430 = mad((WorkingColorSpace_ToAP1[0].z), _1096, mad((WorkingColorSpace_ToAP1[0].y), _1095, ((WorkingColorSpace_ToAP1[0].x) * _1094)));
            float _1433 = mad((WorkingColorSpace_ToAP1[1].z), _1096, mad((WorkingColorSpace_ToAP1[1].y), _1095, ((WorkingColorSpace_ToAP1[1].x) * _1094)));
            float _1436 = mad((WorkingColorSpace_ToAP1[2].z), _1096, mad((WorkingColorSpace_ToAP1[2].y), _1095, ((WorkingColorSpace_ToAP1[2].x) * _1094)));
            float _1455 = exp2(log2(mad(_43, _1436, mad(_42, _1433, (_1430 * _41))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1456 = exp2(log2(mad(_46, _1436, mad(_45, _1433, (_1430 * _44))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1457 = exp2(log2(mad(_49, _1436, mad(_48, _1433, (_1430 * _47))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _1550 = exp2(log2((1.0f / ((_1455 * 18.6875f) + 1.0f)) * ((_1455 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1551 = exp2(log2((1.0f / ((_1456 * 18.6875f) + 1.0f)) * ((_1456 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1552 = exp2(log2((1.0f / ((_1457 * 18.6875f) + 1.0f)) * ((_1457 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _1504 = mad((WorkingColorSpace_ToAP1[0].z), _1084, mad((WorkingColorSpace_ToAP1[0].y), _1083, ((WorkingColorSpace_ToAP1[0].x) * _1082)));
                float _1507 = mad((WorkingColorSpace_ToAP1[1].z), _1084, mad((WorkingColorSpace_ToAP1[1].y), _1083, ((WorkingColorSpace_ToAP1[1].x) * _1082)));
                float _1510 = mad((WorkingColorSpace_ToAP1[2].z), _1084, mad((WorkingColorSpace_ToAP1[2].y), _1083, ((WorkingColorSpace_ToAP1[2].x) * _1082)));
                _1550 = mad(_43, _1510, mad(_42, _1507, (_1504 * _41)));
                _1551 = mad(_46, _1510, mad(_45, _1507, (_1504 * _44)));
                _1552 = mad(_49, _1510, mad(_48, _1507, (_1504 * _47)));
              } else {
                float _1523 = mad((WorkingColorSpace_ToAP1[0].z), _1110, mad((WorkingColorSpace_ToAP1[0].y), _1109, ((WorkingColorSpace_ToAP1[0].x) * _1108)));
                float _1526 = mad((WorkingColorSpace_ToAP1[1].z), _1110, mad((WorkingColorSpace_ToAP1[1].y), _1109, ((WorkingColorSpace_ToAP1[1].x) * _1108)));
                float _1529 = mad((WorkingColorSpace_ToAP1[2].z), _1110, mad((WorkingColorSpace_ToAP1[2].y), _1109, ((WorkingColorSpace_ToAP1[2].x) * _1108)));
                _1550 = exp2(log2(mad(_43, _1529, mad(_42, _1526, (_1523 * _41)))) * InverseGamma.z);
                _1551 = exp2(log2(mad(_46, _1529, mad(_45, _1526, (_1523 * _44)))) * InverseGamma.z);
                _1552 = exp2(log2(mad(_49, _1529, mad(_48, _1526, (_1523 * _47)))) * InverseGamma.z);
              }
            } else {
              _1550 = _1094;
              _1551 = _1095;
              _1552 = _1096;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_1550 * 0.9523810148239136f);
  SV_Target.y = (_1551 * 0.9523810148239136f);
  SV_Target.z = (_1552 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

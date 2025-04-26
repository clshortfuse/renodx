#include "../../common.hlsl"

// Found in Slitterhead

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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _10 = 0.5f / LUTSize;
  float _15 = LUTSize + -1.0f;
  float _16 = (LUTSize * (TEXCOORD.x - _10)) / _15;
  float _17 = (LUTSize * (TEXCOORD.y - _10)) / _15;
  float _19 = float((uint)SV_RenderTargetArrayIndex) / _15;
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _105;
  float _106;
  float _107;
  float _155;
  float _1043;
  float _1044;
  float _1045;
  float _1056;
  float _1067;
  float _1180;
  float _1181;
  float _1182;
  float _1264;
  float _1265;
  float _1266;
  float _1443;
  float _1444;
  float _1445;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _28 = ((uint)(OutputGamut) == 4);
        _39 = select(_28, 1.0f, 1.7050515413284302f);
        _40 = select(_28, 0.0f, -0.6217905879020691f);
        _41 = select(_28, 0.0f, -0.0832584798336029f);
        _42 = select(_28, 0.0f, -0.13025718927383423f);
        _43 = select(_28, 1.0f, 1.1408027410507202f);
        _44 = select(_28, 0.0f, -0.010548528283834457f);
        _45 = select(_28, 0.0f, -0.024003278464078903f);
        _46 = select(_28, 0.0f, -0.1289687603712082f);
        _47 = select(_28, 1.0f, 1.152971863746643f);
      } else {
        _39 = 0.6954522132873535f;
        _40 = 0.14067870378494263f;
        _41 = 0.16386906802654266f;
        _42 = 0.044794563204050064f;
        _43 = 0.8596711158752441f;
        _44 = 0.0955343171954155f;
        _45 = -0.005525882821530104f;
        _46 = 0.004025210160762072f;
        _47 = 1.0015007257461548f;
      }
    } else {
      _39 = 1.02579927444458f;
      _40 = -0.020052503794431686f;
      _41 = -0.0057713985443115234f;
      _42 = -0.0022350111976265907f;
      _43 = 1.0045825242996216f;
      _44 = -0.002352306619286537f;
      _45 = -0.005014004185795784f;
      _46 = -0.025293385609984398f;
      _47 = 1.0304402112960815f;
    }
  } else {
    _39 = 1.379158854484558f;
    _40 = -0.3088507056236267f;
    _41 = -0.07034677267074585f;
    _42 = -0.06933528929948807f;
    _43 = 1.0822921991348267f;
    _44 = -0.012962047010660172f;
    _45 = -0.002159259282052517f;
    _46 = -0.045465391129255295f;
    _47 = 1.0477596521377563f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _58 = (pow(_16, 0.012683313339948654f));
    float _59 = (pow(_17, 0.012683313339948654f));
    float _60 = (pow(_19, 0.012683313339948654f));
    _105 = (exp2(log2(max(0.0f, (_58 + -0.8359375f)) / (18.8515625f - (_58 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _106 = (exp2(log2(max(0.0f, (_59 + -0.8359375f)) / (18.8515625f - (_59 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _107 = (exp2(log2(max(0.0f, (_60 + -0.8359375f)) / (18.8515625f - (_60 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _105 = ((exp2((_16 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _106 = ((exp2((_17 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _107 = ((exp2((_19 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _134 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _138 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _155 = (((((2967800.0f - (_138 * 4607000064.0f)) * _138) + 99.11000061035156f) * _138) + 0.24406300485134125f);
  } else {
    _155 = (((((1901800.0f - (_138 * 2006400000.0f)) * _138) + 247.47999572753906f) * _138) + 0.23703999817371368f);
  }
  float _169 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _176 = WhiteTemp * WhiteTemp;
  float _179 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_176 * 1.6145605741257896e-07f));
  float _184 = ((_169 * 2.0f) + 4.0f) - (_179 * 8.0f);
  float _185 = (_169 * 3.0f) / _184;
  float _187 = (_179 * 2.0f) / _184;
  bool _188 = (WhiteTemp < 4000.0f);
  float _197 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _199 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_176 * 1.5317699909210205f)) / (_197 * _197);
  float _206 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _176;
  float _208 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_176 * 308.60699462890625f)) / (_206 * _206);
  float _210 = rsqrt(dot(float2(_199, _208), float2(_199, _208)));
  float _211 = WhiteTint * 0.05000000074505806f;
  float _214 = ((_211 * _208) * _210) + _169;
  float _217 = _179 - ((_211 * _199) * _210);
  float _222 = (4.0f - (_217 * 8.0f)) + (_214 * 2.0f);
  float _228 = (((_214 * 3.0f) / _222) - _185) + select(_188, _185, _155);
  float _229 = (((_217 * 2.0f) / _222) - _187) + select(_188, _187, (((_155 * 2.869999885559082f) + -0.2750000059604645f) - ((_155 * _155) * 3.0f)));
  float _230 = select(_134, _228, 0.3127000033855438f);
  float _231 = select(_134, _229, 0.32899999618530273f);
  float _232 = select(_134, 0.3127000033855438f, _228);
  float _233 = select(_134, 0.32899999618530273f, _229);
  float _234 = max(_231, 1.000000013351432e-10f);
  float _235 = _230 / _234;
  float _238 = ((1.0f - _230) - _231) / _234;
  float _239 = max(_233, 1.000000013351432e-10f);
  float _240 = _232 / _239;
  float _243 = ((1.0f - _232) - _233) / _239;
  float _262 = mad(-0.16140000522136688f, _243, ((_240 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _238, ((_235 * 0.8950999975204468f) + 0.266400009393692f));
  float _263 = mad(0.03669999912381172f, _243, (1.7135000228881836f - (_240 * 0.7501999735832214f))) / mad(0.03669999912381172f, _238, (1.7135000228881836f - (_235 * 0.7501999735832214f)));
  float _264 = mad(1.0296000242233276f, _243, ((_240 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _238, ((_235 * 0.03889999911189079f) + -0.06849999725818634f));
  float _265 = mad(_263, -0.7501999735832214f, 0.0f);
  float _266 = mad(_263, 1.7135000228881836f, 0.0f);
  float _267 = mad(_263, 0.03669999912381172f, -0.0f);
  float _268 = mad(_264, 0.03889999911189079f, 0.0f);
  float _269 = mad(_264, -0.06849999725818634f, 0.0f);
  float _270 = mad(_264, 1.0296000242233276f, 0.0f);
  float _273 = mad(0.1599626988172531f, _268, mad(-0.1470542997121811f, _265, (_262 * 0.883457362651825f)));
  float _276 = mad(0.1599626988172531f, _269, mad(-0.1470542997121811f, _266, (_262 * 0.26293492317199707f)));
  float _279 = mad(0.1599626988172531f, _270, mad(-0.1470542997121811f, _267, (_262 * -0.15930065512657166f)));
  float _282 = mad(0.04929120093584061f, _268, mad(0.5183603167533875f, _265, (_262 * 0.38695648312568665f)));
  float _285 = mad(0.04929120093584061f, _269, mad(0.5183603167533875f, _266, (_262 * 0.11516613513231277f)));
  float _288 = mad(0.04929120093584061f, _270, mad(0.5183603167533875f, _267, (_262 * -0.0697740763425827f)));
  float _291 = mad(0.9684867262840271f, _268, mad(0.04004279896616936f, _265, (_262 * -0.007634039502590895f)));
  float _294 = mad(0.9684867262840271f, _269, mad(0.04004279896616936f, _266, (_262 * -0.0022720457054674625f)));
  float _297 = mad(0.9684867262840271f, _270, mad(0.04004279896616936f, _267, (_262 * 0.0013765322510153055f)));
  float _300 = mad(_279, (WorkingColorSpace_ToXYZ[2].x), mad(_276, (WorkingColorSpace_ToXYZ[1].x), (_273 * (WorkingColorSpace_ToXYZ[0].x))));
  float _303 = mad(_279, (WorkingColorSpace_ToXYZ[2].y), mad(_276, (WorkingColorSpace_ToXYZ[1].y), (_273 * (WorkingColorSpace_ToXYZ[0].y))));
  float _306 = mad(_279, (WorkingColorSpace_ToXYZ[2].z), mad(_276, (WorkingColorSpace_ToXYZ[1].z), (_273 * (WorkingColorSpace_ToXYZ[0].z))));
  float _309 = mad(_288, (WorkingColorSpace_ToXYZ[2].x), mad(_285, (WorkingColorSpace_ToXYZ[1].x), (_282 * (WorkingColorSpace_ToXYZ[0].x))));
  float _312 = mad(_288, (WorkingColorSpace_ToXYZ[2].y), mad(_285, (WorkingColorSpace_ToXYZ[1].y), (_282 * (WorkingColorSpace_ToXYZ[0].y))));
  float _315 = mad(_288, (WorkingColorSpace_ToXYZ[2].z), mad(_285, (WorkingColorSpace_ToXYZ[1].z), (_282 * (WorkingColorSpace_ToXYZ[0].z))));
  float _318 = mad(_297, (WorkingColorSpace_ToXYZ[2].x), mad(_294, (WorkingColorSpace_ToXYZ[1].x), (_291 * (WorkingColorSpace_ToXYZ[0].x))));
  float _321 = mad(_297, (WorkingColorSpace_ToXYZ[2].y), mad(_294, (WorkingColorSpace_ToXYZ[1].y), (_291 * (WorkingColorSpace_ToXYZ[0].y))));
  float _324 = mad(_297, (WorkingColorSpace_ToXYZ[2].z), mad(_294, (WorkingColorSpace_ToXYZ[1].z), (_291 * (WorkingColorSpace_ToXYZ[0].z))));
  float _354 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _324, mad((WorkingColorSpace_FromXYZ[0].y), _315, (_306 * (WorkingColorSpace_FromXYZ[0].x)))), _107, mad(mad((WorkingColorSpace_FromXYZ[0].z), _321, mad((WorkingColorSpace_FromXYZ[0].y), _312, (_303 * (WorkingColorSpace_FromXYZ[0].x)))), _106, (mad((WorkingColorSpace_FromXYZ[0].z), _318, mad((WorkingColorSpace_FromXYZ[0].y), _309, (_300 * (WorkingColorSpace_FromXYZ[0].x)))) * _105)));
  float _357 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _324, mad((WorkingColorSpace_FromXYZ[1].y), _315, (_306 * (WorkingColorSpace_FromXYZ[1].x)))), _107, mad(mad((WorkingColorSpace_FromXYZ[1].z), _321, mad((WorkingColorSpace_FromXYZ[1].y), _312, (_303 * (WorkingColorSpace_FromXYZ[1].x)))), _106, (mad((WorkingColorSpace_FromXYZ[1].z), _318, mad((WorkingColorSpace_FromXYZ[1].y), _309, (_300 * (WorkingColorSpace_FromXYZ[1].x)))) * _105)));
  float _360 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _324, mad((WorkingColorSpace_FromXYZ[2].y), _315, (_306 * (WorkingColorSpace_FromXYZ[2].x)))), _107, mad(mad((WorkingColorSpace_FromXYZ[2].z), _321, mad((WorkingColorSpace_FromXYZ[2].y), _312, (_303 * (WorkingColorSpace_FromXYZ[2].x)))), _106, (mad((WorkingColorSpace_FromXYZ[2].z), _318, mad((WorkingColorSpace_FromXYZ[2].y), _309, (_300 * (WorkingColorSpace_FromXYZ[2].x)))) * _105)));
  float _375 = mad((WorkingColorSpace_ToAP1[0].z), _360, mad((WorkingColorSpace_ToAP1[0].y), _357, ((WorkingColorSpace_ToAP1[0].x) * _354)));
  float _378 = mad((WorkingColorSpace_ToAP1[1].z), _360, mad((WorkingColorSpace_ToAP1[1].y), _357, ((WorkingColorSpace_ToAP1[1].x) * _354)));
  float _381 = mad((WorkingColorSpace_ToAP1[2].z), _360, mad((WorkingColorSpace_ToAP1[2].y), _357, ((WorkingColorSpace_ToAP1[2].x) * _354)));
  float _382 = dot(float3(_375, _378, _381), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUntonemappedAP1(float3(_375, _378, _381));

  float _386 = (_375 / _382) + -1.0f;
  float _387 = (_378 / _382) + -1.0f;
  float _388 = (_381 / _382) + -1.0f;
  float _400 = (1.0f - exp2(((_382 * _382) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_386, _387, _388), float3(_386, _387, _388)) * -4.0f));
  float _416 = ((mad(-0.06368283927440643f, _381, mad(-0.32929131388664246f, _378, (_375 * 1.370412826538086f))) - _375) * _400) + _375;
  float _417 = ((mad(-0.010861567221581936f, _381, mad(1.0970908403396606f, _378, (_375 * -0.08343426138162613f))) - _378) * _400) + _378;
  float _418 = ((mad(1.203694462776184f, _381, mad(-0.09862564504146576f, _378, (_375 * -0.02579325996339321f))) - _381) * _400) + _381;
  float _419 = dot(float3(_416, _417, _418), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _433 = ColorOffset.w + ColorOffsetShadows.w;
  float _447 = ColorGain.w * ColorGainShadows.w;
  float _461 = ColorGamma.w * ColorGammaShadows.w;
  float _475 = ColorContrast.w * ColorContrastShadows.w;
  float _489 = ColorSaturation.w * ColorSaturationShadows.w;
  float _493 = _416 - _419;
  float _494 = _417 - _419;
  float _495 = _418 - _419;
  float _552 = saturate(_419 / ColorCorrectionShadowsMax);
  float _556 = (_552 * _552) * (3.0f - (_552 * 2.0f));
  float _557 = 1.0f - _556;
  float _566 = ColorOffset.w + ColorOffsetHighlights.w;
  float _575 = ColorGain.w * ColorGainHighlights.w;
  float _584 = ColorGamma.w * ColorGammaHighlights.w;
  float _593 = ColorContrast.w * ColorContrastHighlights.w;
  float _602 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _665 = saturate((_419 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _669 = (_665 * _665) * (3.0f - (_665 * 2.0f));
  float _678 = ColorOffset.w + ColorOffsetMidtones.w;
  float _687 = ColorGain.w * ColorGainMidtones.w;
  float _696 = ColorGamma.w * ColorGammaMidtones.w;
  float _705 = ColorContrast.w * ColorContrastMidtones.w;
  float _714 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _772 = _556 - _669;
  float _783 = ((_669 * (((ColorOffset.x + ColorOffsetHighlights.x) + _566) + (((ColorGain.x * ColorGainHighlights.x) * _575) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _593) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _602) * _493) + _419)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _584)))))) + (_557 * (((ColorOffset.x + ColorOffsetShadows.x) + _433) + (((ColorGain.x * ColorGainShadows.x) * _447) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _475) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _489) * _493) + _419)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _461))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _678) + (((ColorGain.x * ColorGainMidtones.x) * _687) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _705) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _714) * _493) + _419)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _696))))) * _772);
  float _785 = ((_669 * (((ColorOffset.y + ColorOffsetHighlights.y) + _566) + (((ColorGain.y * ColorGainHighlights.y) * _575) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _593) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _602) * _494) + _419)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _584)))))) + (_557 * (((ColorOffset.y + ColorOffsetShadows.y) + _433) + (((ColorGain.y * ColorGainShadows.y) * _447) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _475) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _489) * _494) + _419)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _461))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _678) + (((ColorGain.y * ColorGainMidtones.y) * _687) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _705) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _714) * _494) + _419)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _696))))) * _772);
  float _787 = ((_669 * (((ColorOffset.z + ColorOffsetHighlights.z) + _566) + (((ColorGain.z * ColorGainHighlights.z) * _575) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _593) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _602) * _495) + _419)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _584)))))) + (_557 * (((ColorOffset.z + ColorOffsetShadows.z) + _433) + (((ColorGain.z * ColorGainShadows.z) * _447) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _475) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _489) * _495) + _419)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _461))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _678) + (((ColorGain.z * ColorGainMidtones.z) * _687) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _705) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _714) * _495) + _419)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _696))))) * _772);
  float _823 = ((mad(0.061360642313957214f, _787, mad(-4.540197551250458e-09f, _785, (_783 * 0.9386394023895264f))) - _783) * BlueCorrection) + _783;
  float _824 = ((mad(0.169205904006958f, _787, mad(0.8307942152023315f, _785, (_783 * 6.775371730327606e-08f))) - _785) * BlueCorrection) + _785;
  float _825 = (mad(-2.3283064365386963e-10f, _785, (_783 * -9.313225746154785e-10f)) * BlueCorrection) + _787;
  float _840 = dot(float3(_823, _824, _825), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _847 = ((_823 - _840) * 0.9599999785423279f) + _840;
  float _848 = ((_824 - _840) * 0.9599999785423279f) + _840;
  float _849 = ((_825 - _840) * 0.9599999785423279f) + _840;
  float _850 = -0.0f - HyperbolaToe.x;
  float _866 = -0.0f - HyperbolaShoulder.x;
  float _885 = select((_847 < HyperbolaThreshold.x), ((_850 / (_847 + HyperbolaToe.y)) + HyperbolaToe.z), select((_847 < HyperbolaThreshold.y), ((_847 * HyperbolaMid.x) + HyperbolaMid.y), ((_866 / (_847 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _886 = select((_848 < HyperbolaThreshold.x), ((_850 / (_848 + HyperbolaToe.y)) + HyperbolaToe.z), select((_848 < HyperbolaThreshold.y), ((_848 * HyperbolaMid.x) + HyperbolaMid.y), ((_866 / (_848 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _887 = select((_849 < HyperbolaThreshold.x), ((_850 / (_849 + HyperbolaToe.y)) + HyperbolaToe.z), select((_849 < HyperbolaThreshold.y), ((_849 * HyperbolaMid.x) + HyperbolaMid.y), ((_866 / (_849 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _888 = dot(float3(_885, _886, _887), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _906 = (((_888 - _823) + ((_885 - _888) * 0.9300000071525574f)) * ToneCurveAmount) + _823;
  float _907 = (((_888 - _824) + ((_886 - _888) * 0.9300000071525574f)) * ToneCurveAmount) + _824;
  float _908 = (((_888 - _825) + ((_887 - _888) * 0.9300000071525574f)) * ToneCurveAmount) + _825;
  float _926 = ((mad(-0.06537103652954102f, _908, mad(1.451815478503704e-06f, _907, (_906 * 1.065374732017517f))) - _906) * BlueCorrection) + _906;
  float _927 = ((mad(-0.20366770029067993f, _908, mad(1.2036634683609009f, _907, (_906 * -2.57161445915699e-07f))) - _907) * BlueCorrection) + _907;
  float _928 = ((mad(0.9999996423721313f, _908, mad(2.0954757928848267e-08f, _907, (_906 * 1.862645149230957e-08f))) - _908) * BlueCorrection) + _908;

  SetTonemappedAP1(_926, _927, _928);

  float _938 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _928, mad((WorkingColorSpace_FromAP1[0].y), _927, ((WorkingColorSpace_FromAP1[0].x) * _926))));
  float _939 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _928, mad((WorkingColorSpace_FromAP1[1].y), _927, ((WorkingColorSpace_FromAP1[1].x) * _926))));
  float _940 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _928, mad((WorkingColorSpace_FromAP1[2].y), _927, ((WorkingColorSpace_FromAP1[2].x) * _926))));
  float _966 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _938)) * _938) + MappingPolynomial.z);
  float _967 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _939)) * _939) + MappingPolynomial.z);
  float _968 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _940)) * _940) + MappingPolynomial.z);
  float _975 = ((OverlayColor.x - _966) * OverlayColor.w) + _966;
  float _976 = ((OverlayColor.y - _967) * OverlayColor.w) + _967;
  float _977 = ((OverlayColor.z - _968) * OverlayColor.w) + _968;
  float _978 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _787, mad((WorkingColorSpace_FromAP1[0].y), _785, (_783 * (WorkingColorSpace_FromAP1[0].x))));
  float _979 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _787, mad((WorkingColorSpace_FromAP1[1].y), _785, ((WorkingColorSpace_FromAP1[1].x) * _783)));
  float _980 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _787, mad((WorkingColorSpace_FromAP1[2].y), _785, ((WorkingColorSpace_FromAP1[2].x) * _783)));
  float _987 = ((OverlayColor.x - _978) * OverlayColor.w) + _978;
  float _988 = ((OverlayColor.y - _979) * OverlayColor.w) + _979;
  float _989 = ((OverlayColor.z - _980) * OverlayColor.w) + _980;
  float _1001 = exp2(log2(max(0.0f, _975)) * InverseGamma.y);
  float _1002 = exp2(log2(max(0.0f, _976)) * InverseGamma.y);
  float _1003 = exp2(log2(max(0.0f, _977)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1001, _1002, _1003));
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1026 = mad((WorkingColorSpace_ToAP1[0].z), _1003, mad((WorkingColorSpace_ToAP1[0].y), _1002, ((WorkingColorSpace_ToAP1[0].x) * _1001)));
        float _1029 = mad((WorkingColorSpace_ToAP1[1].z), _1003, mad((WorkingColorSpace_ToAP1[1].y), _1002, ((WorkingColorSpace_ToAP1[1].x) * _1001)));
        float _1032 = mad((WorkingColorSpace_ToAP1[2].z), _1003, mad((WorkingColorSpace_ToAP1[2].y), _1002, ((WorkingColorSpace_ToAP1[2].x) * _1001)));
        _1043 = mad(_41, _1032, mad(_40, _1029, (_1026 * _39)));
        _1044 = mad(_44, _1032, mad(_43, _1029, (_1026 * _42)));
        _1045 = mad(_47, _1032, mad(_46, _1029, (_1026 * _45)));
      } else {
        _1043 = _1001;
        _1044 = _1002;
        _1045 = _1003;
      }
      do {
        if (_1043 < 0.0031306699384003878f) {
          _1056 = (_1043 * 12.920000076293945f);
        } else {
          _1056 = (((pow(_1043, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1044 < 0.0031306699384003878f) {
            _1067 = (_1044 * 12.920000076293945f);
          } else {
            _1067 = (((pow(_1044, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1045 < 0.0031306699384003878f) {
            _1443 = _1056;
            _1444 = _1067;
            _1445 = (_1045 * 12.920000076293945f);
          } else {
            _1443 = _1056;
            _1444 = _1067;
            _1445 = (((pow(_1045, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1094 = mad((WorkingColorSpace_ToAP1[0].z), _1003, mad((WorkingColorSpace_ToAP1[0].y), _1002, ((WorkingColorSpace_ToAP1[0].x) * _1001)));
      float _1097 = mad((WorkingColorSpace_ToAP1[1].z), _1003, mad((WorkingColorSpace_ToAP1[1].y), _1002, ((WorkingColorSpace_ToAP1[1].x) * _1001)));
      float _1100 = mad((WorkingColorSpace_ToAP1[2].z), _1003, mad((WorkingColorSpace_ToAP1[2].y), _1002, ((WorkingColorSpace_ToAP1[2].x) * _1001)));
      float _1110 = max(6.103519990574569e-05f, mad(_41, _1100, mad(_40, _1097, (_1094 * _39))));
      float _1111 = max(6.103519990574569e-05f, mad(_44, _1100, mad(_43, _1097, (_1094 * _42))));
      float _1112 = max(6.103519990574569e-05f, mad(_47, _1100, mad(_46, _1097, (_1094 * _45))));
      _1443 = min((_1110 * 4.5f), ((exp2(log2(max(_1110, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1444 = min((_1111 * 4.5f), ((exp2(log2(max(_1111, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1445 = min((_1112 * 4.5f), ((exp2(log2(max(_1112, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        float _1144 = HyperbolaMultiplier.x * _975;
        float _1145 = HyperbolaMultiplier.x * _976;
        float _1146 = HyperbolaMultiplier.x * _977;
        float _1161 = mad((WorkingColorSpace_ToAP1[0].z), _1146, mad((WorkingColorSpace_ToAP1[0].y), _1145, ((WorkingColorSpace_ToAP1[0].x) * _1144)));
        float _1164 = mad((WorkingColorSpace_ToAP1[1].z), _1146, mad((WorkingColorSpace_ToAP1[1].y), _1145, ((WorkingColorSpace_ToAP1[1].x) * _1144)));
        float _1167 = mad((WorkingColorSpace_ToAP1[2].z), _1146, mad((WorkingColorSpace_ToAP1[2].y), _1145, ((WorkingColorSpace_ToAP1[2].x) * _1144)));
        do {
          if (!((uint)(OutputDevice) == 5)) {
            _1180 = mad(_41, _1167, mad(_40, _1164, (_1161 * _39)));
            _1181 = mad(_44, _1167, mad(_43, _1164, (_1161 * _42)));
            _1182 = mad(_47, _1167, mad(_46, _1164, (_1161 * _45)));
          } else {
            _1180 = _1161;
            _1181 = _1164;
            _1182 = _1167;
          }
          float _1192 = exp2(log2(_1180 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1193 = exp2(log2(_1181 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1194 = exp2(log2(_1182 * 9.999999747378752e-05f) * 0.1593017578125f);
          _1443 = exp2(log2((1.0f / ((_1192 * 18.6875f) + 1.0f)) * ((_1192 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1444 = exp2(log2((1.0f / ((_1193 * 18.6875f) + 1.0f)) * ((_1193 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1445 = exp2(log2((1.0f / ((_1194 * 18.6875f) + 1.0f)) * ((_1194 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        } while (false);
      } else {
        if (((uint)(OutputDevice) & -3) == 4) {
          float _1228 = HyperbolaMultiplier.x * _975;
          float _1229 = HyperbolaMultiplier.x * _976;
          float _1230 = HyperbolaMultiplier.x * _977;
          float _1245 = mad((WorkingColorSpace_ToAP1[0].z), _1230, mad((WorkingColorSpace_ToAP1[0].y), _1229, ((WorkingColorSpace_ToAP1[0].x) * _1228)));
          float _1248 = mad((WorkingColorSpace_ToAP1[1].z), _1230, mad((WorkingColorSpace_ToAP1[1].y), _1229, ((WorkingColorSpace_ToAP1[1].x) * _1228)));
          float _1251 = mad((WorkingColorSpace_ToAP1[2].z), _1230, mad((WorkingColorSpace_ToAP1[2].y), _1229, ((WorkingColorSpace_ToAP1[2].x) * _1228)));
          do {
            if (!((uint)(OutputDevice) == 6)) {
              _1264 = mad(_41, _1251, mad(_40, _1248, (_1245 * _39)));
              _1265 = mad(_44, _1251, mad(_43, _1248, (_1245 * _42)));
              _1266 = mad(_47, _1251, mad(_46, _1248, (_1245 * _45)));
            } else {
              _1264 = _1245;
              _1265 = _1248;
              _1266 = _1251;
            }
            float _1276 = exp2(log2(_1264 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1277 = exp2(log2(_1265 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1278 = exp2(log2(_1266 * 9.999999747378752e-05f) * 0.1593017578125f);
            _1443 = exp2(log2((1.0f / ((_1276 * 18.6875f) + 1.0f)) * ((_1276 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1444 = exp2(log2((1.0f / ((_1277 * 18.6875f) + 1.0f)) * ((_1277 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1445 = exp2(log2((1.0f / ((_1278 * 18.6875f) + 1.0f)) * ((_1278 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } while (false);
        } else {
          if ((uint)(OutputDevice) == 7) {
            float _1323 = mad((WorkingColorSpace_ToAP1[0].z), _989, mad((WorkingColorSpace_ToAP1[0].y), _988, ((WorkingColorSpace_ToAP1[0].x) * _987)));
            float _1326 = mad((WorkingColorSpace_ToAP1[1].z), _989, mad((WorkingColorSpace_ToAP1[1].y), _988, ((WorkingColorSpace_ToAP1[1].x) * _987)));
            float _1329 = mad((WorkingColorSpace_ToAP1[2].z), _989, mad((WorkingColorSpace_ToAP1[2].y), _988, ((WorkingColorSpace_ToAP1[2].x) * _987)));
            float _1348 = exp2(log2(mad(_41, _1329, mad(_40, _1326, (_1323 * _39))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1349 = exp2(log2(mad(_44, _1329, mad(_43, _1326, (_1323 * _42))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1350 = exp2(log2(mad(_47, _1329, mad(_46, _1326, (_1323 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _1443 = exp2(log2((1.0f / ((_1348 * 18.6875f) + 1.0f)) * ((_1348 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1444 = exp2(log2((1.0f / ((_1349 * 18.6875f) + 1.0f)) * ((_1349 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1445 = exp2(log2((1.0f / ((_1350 * 18.6875f) + 1.0f)) * ((_1350 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _1397 = mad((WorkingColorSpace_ToAP1[0].z), _977, mad((WorkingColorSpace_ToAP1[0].y), _976, ((WorkingColorSpace_ToAP1[0].x) * _975)));
                float _1400 = mad((WorkingColorSpace_ToAP1[1].z), _977, mad((WorkingColorSpace_ToAP1[1].y), _976, ((WorkingColorSpace_ToAP1[1].x) * _975)));
                float _1403 = mad((WorkingColorSpace_ToAP1[2].z), _977, mad((WorkingColorSpace_ToAP1[2].y), _976, ((WorkingColorSpace_ToAP1[2].x) * _975)));
                _1443 = mad(_41, _1403, mad(_40, _1400, (_1397 * _39)));
                _1444 = mad(_44, _1403, mad(_43, _1400, (_1397 * _42)));
                _1445 = mad(_47, _1403, mad(_46, _1400, (_1397 * _45)));
              } else {
                float _1416 = mad((WorkingColorSpace_ToAP1[0].z), _1003, mad((WorkingColorSpace_ToAP1[0].y), _1002, ((WorkingColorSpace_ToAP1[0].x) * _1001)));
                float _1419 = mad((WorkingColorSpace_ToAP1[1].z), _1003, mad((WorkingColorSpace_ToAP1[1].y), _1002, ((WorkingColorSpace_ToAP1[1].x) * _1001)));
                float _1422 = mad((WorkingColorSpace_ToAP1[2].z), _1003, mad((WorkingColorSpace_ToAP1[2].y), _1002, ((WorkingColorSpace_ToAP1[2].x) * _1001)));
                _1443 = exp2(log2(mad(_41, _1422, mad(_40, _1419, (_1416 * _39)))) * InverseGamma.z);
                _1444 = exp2(log2(mad(_44, _1422, mad(_43, _1419, (_1416 * _42)))) * InverseGamma.z);
                _1445 = exp2(log2(mad(_47, _1422, mad(_46, _1419, (_1416 * _45)))) * InverseGamma.z);
              }
            } else {
              _1443 = _987;
              _1444 = _988;
              _1445 = _989;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_1443 * 0.9523810148239136f);
  SV_Target.y = (_1444 * 0.9523810148239136f);
  SV_Target.z = (_1445 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

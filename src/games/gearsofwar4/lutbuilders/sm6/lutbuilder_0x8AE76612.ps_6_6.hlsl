// Found in Ready or Not

#include "../../common.hlsl"

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
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _114;
  float _821;
  float _854;
  float _868;
  float _932;
  float _1123;
  float _1134;
  float _1145;
  float _1331;
  float _1332;
  float _1333;
  float _1344;
  float _1355;
  float _1366;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _32 = ((uint)(OutputGamut) == 4);
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
  float _64 = (exp2((((LUTSize * (TEXCOORD.x - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _65 = (exp2((((LUTSize * (TEXCOORD.y - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _66 = (exp2(((float((uint)SV_RenderTargetArrayIndex) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _93 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _97 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _114 = (((((2967800.0f - (_97 * 4607000064.0f)) * _97) + 99.11000061035156f) * _97) + 0.24406300485134125f);
  } else {
    _114 = (((((1901800.0f - (_97 * 2006400000.0f)) * _97) + 247.47999572753906f) * _97) + 0.23703999817371368f);
  }
  float _128 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _135 = WhiteTemp * WhiteTemp;
  float _138 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_135 * 1.6145605741257896e-07f));
  float _143 = ((_128 * 2.0f) + 4.0f) - (_138 * 8.0f);
  float _144 = (_128 * 3.0f) / _143;
  float _146 = (_138 * 2.0f) / _143;
  bool _147 = (WhiteTemp < 4000.0f);
  float _156 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _158 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_135 * 1.5317699909210205f)) / (_156 * _156);
  float _165 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _135;
  float _167 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_135 * 308.60699462890625f)) / (_165 * _165);
  float _169 = rsqrt(dot(float2(_158, _167), float2(_158, _167)));
  float _170 = WhiteTint * 0.05000000074505806f;
  float _173 = ((_170 * _167) * _169) + _128;
  float _176 = _138 - ((_170 * _158) * _169);
  float _181 = (4.0f - (_176 * 8.0f)) + (_173 * 2.0f);
  float _187 = (((_173 * 3.0f) / _181) - _144) + select(_147, _144, _114);
  float _188 = (((_176 * 2.0f) / _181) - _146) + select(_147, _146, (((_114 * 2.869999885559082f) + -0.2750000059604645f) - ((_114 * _114) * 3.0f)));
  float _189 = select(_93, _187, 0.3127000033855438f);
  float _190 = select(_93, _188, 0.32899999618530273f);
  float _191 = select(_93, 0.3127000033855438f, _187);
  float _192 = select(_93, 0.32899999618530273f, _188);
  float _193 = max(_190, 1.000000013351432e-10f);
  float _194 = _189 / _193;
  float _197 = ((1.0f - _189) - _190) / _193;
  float _198 = max(_192, 1.000000013351432e-10f);
  float _199 = _191 / _198;
  float _202 = ((1.0f - _191) - _192) / _198;
  float _221 = mad(-0.16140000522136688f, _202, ((_199 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _197, ((_194 * 0.8950999975204468f) + 0.266400009393692f));
  float _222 = mad(0.03669999912381172f, _202, (1.7135000228881836f - (_199 * 0.7501999735832214f))) / mad(0.03669999912381172f, _197, (1.7135000228881836f - (_194 * 0.7501999735832214f)));
  float _223 = mad(1.0296000242233276f, _202, ((_199 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _197, ((_194 * 0.03889999911189079f) + -0.06849999725818634f));
  float _224 = mad(_222, -0.7501999735832214f, 0.0f);
  float _225 = mad(_222, 1.7135000228881836f, 0.0f);
  float _226 = mad(_222, 0.03669999912381172f, -0.0f);
  float _227 = mad(_223, 0.03889999911189079f, 0.0f);
  float _228 = mad(_223, -0.06849999725818634f, 0.0f);
  float _229 = mad(_223, 1.0296000242233276f, 0.0f);
  float _232 = mad(0.1599626988172531f, _227, mad(-0.1470542997121811f, _224, (_221 * 0.883457362651825f)));
  float _235 = mad(0.1599626988172531f, _228, mad(-0.1470542997121811f, _225, (_221 * 0.26293492317199707f)));
  float _238 = mad(0.1599626988172531f, _229, mad(-0.1470542997121811f, _226, (_221 * -0.15930065512657166f)));
  float _241 = mad(0.04929120093584061f, _227, mad(0.5183603167533875f, _224, (_221 * 0.38695648312568665f)));
  float _244 = mad(0.04929120093584061f, _228, mad(0.5183603167533875f, _225, (_221 * 0.11516613513231277f)));
  float _247 = mad(0.04929120093584061f, _229, mad(0.5183603167533875f, _226, (_221 * -0.0697740763425827f)));
  float _250 = mad(0.9684867262840271f, _227, mad(0.04004279896616936f, _224, (_221 * -0.007634039502590895f)));
  float _253 = mad(0.9684867262840271f, _228, mad(0.04004279896616936f, _225, (_221 * -0.0022720457054674625f)));
  float _256 = mad(0.9684867262840271f, _229, mad(0.04004279896616936f, _226, (_221 * 0.0013765322510153055f)));
  float _259 = mad(_238, (WorkingColorSpace_ToXYZ[2].x), mad(_235, (WorkingColorSpace_ToXYZ[1].x), (_232 * (WorkingColorSpace_ToXYZ[0].x))));
  float _262 = mad(_238, (WorkingColorSpace_ToXYZ[2].y), mad(_235, (WorkingColorSpace_ToXYZ[1].y), (_232 * (WorkingColorSpace_ToXYZ[0].y))));
  float _265 = mad(_238, (WorkingColorSpace_ToXYZ[2].z), mad(_235, (WorkingColorSpace_ToXYZ[1].z), (_232 * (WorkingColorSpace_ToXYZ[0].z))));
  float _268 = mad(_247, (WorkingColorSpace_ToXYZ[2].x), mad(_244, (WorkingColorSpace_ToXYZ[1].x), (_241 * (WorkingColorSpace_ToXYZ[0].x))));
  float _271 = mad(_247, (WorkingColorSpace_ToXYZ[2].y), mad(_244, (WorkingColorSpace_ToXYZ[1].y), (_241 * (WorkingColorSpace_ToXYZ[0].y))));
  float _274 = mad(_247, (WorkingColorSpace_ToXYZ[2].z), mad(_244, (WorkingColorSpace_ToXYZ[1].z), (_241 * (WorkingColorSpace_ToXYZ[0].z))));
  float _277 = mad(_256, (WorkingColorSpace_ToXYZ[2].x), mad(_253, (WorkingColorSpace_ToXYZ[1].x), (_250 * (WorkingColorSpace_ToXYZ[0].x))));
  float _280 = mad(_256, (WorkingColorSpace_ToXYZ[2].y), mad(_253, (WorkingColorSpace_ToXYZ[1].y), (_250 * (WorkingColorSpace_ToXYZ[0].y))));
  float _283 = mad(_256, (WorkingColorSpace_ToXYZ[2].z), mad(_253, (WorkingColorSpace_ToXYZ[1].z), (_250 * (WorkingColorSpace_ToXYZ[0].z))));
  float _313 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _283, mad((WorkingColorSpace_FromXYZ[0].y), _274, (_265 * (WorkingColorSpace_FromXYZ[0].x)))), _66, mad(mad((WorkingColorSpace_FromXYZ[0].z), _280, mad((WorkingColorSpace_FromXYZ[0].y), _271, (_262 * (WorkingColorSpace_FromXYZ[0].x)))), _65, (mad((WorkingColorSpace_FromXYZ[0].z), _277, mad((WorkingColorSpace_FromXYZ[0].y), _268, (_259 * (WorkingColorSpace_FromXYZ[0].x)))) * _64)));
  float _316 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _283, mad((WorkingColorSpace_FromXYZ[1].y), _274, (_265 * (WorkingColorSpace_FromXYZ[1].x)))), _66, mad(mad((WorkingColorSpace_FromXYZ[1].z), _280, mad((WorkingColorSpace_FromXYZ[1].y), _271, (_262 * (WorkingColorSpace_FromXYZ[1].x)))), _65, (mad((WorkingColorSpace_FromXYZ[1].z), _277, mad((WorkingColorSpace_FromXYZ[1].y), _268, (_259 * (WorkingColorSpace_FromXYZ[1].x)))) * _64)));
  float _319 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _283, mad((WorkingColorSpace_FromXYZ[2].y), _274, (_265 * (WorkingColorSpace_FromXYZ[2].x)))), _66, mad(mad((WorkingColorSpace_FromXYZ[2].z), _280, mad((WorkingColorSpace_FromXYZ[2].y), _271, (_262 * (WorkingColorSpace_FromXYZ[2].x)))), _65, (mad((WorkingColorSpace_FromXYZ[2].z), _277, mad((WorkingColorSpace_FromXYZ[2].y), _268, (_259 * (WorkingColorSpace_FromXYZ[2].x)))) * _64)));
  float _334 = mad((WorkingColorSpace_ToAP1[0].z), _319, mad((WorkingColorSpace_ToAP1[0].y), _316, ((WorkingColorSpace_ToAP1[0].x) * _313)));
  float _337 = mad((WorkingColorSpace_ToAP1[1].z), _319, mad((WorkingColorSpace_ToAP1[1].y), _316, ((WorkingColorSpace_ToAP1[1].x) * _313)));
  float _340 = mad((WorkingColorSpace_ToAP1[2].z), _319, mad((WorkingColorSpace_ToAP1[2].y), _316, ((WorkingColorSpace_ToAP1[2].x) * _313)));
  float _341 = dot(float3(_334, _337, _340), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_334, _337, _340));

  float _345 = (_334 / _341) + -1.0f;
  float _346 = (_337 / _341) + -1.0f;
  float _347 = (_340 / _341) + -1.0f;
  float _359 = (1.0f - exp2(((_341 * _341) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_345, _346, _347), float3(_345, _346, _347)) * -4.0f));
  float _375 = ((mad(-0.06368321925401688f, _340, mad(-0.3292922377586365f, _337, (_334 * 1.3704125881195068f))) - _334) * _359) + _334;
  float _376 = ((mad(-0.010861365124583244f, _340, mad(1.0970927476882935f, _337, (_334 * -0.08343357592821121f))) - _337) * _359) + _337;
  float _377 = ((mad(1.2036951780319214f, _340, mad(-0.09862580895423889f, _337, (_334 * -0.02579331398010254f))) - _340) * _359) + _340;
  float _378 = dot(float3(_375, _376, _377), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _392 = ColorOffset.w + ColorOffsetShadows.w;
  float _406 = ColorGain.w * ColorGainShadows.w;
  float _420 = ColorGamma.w * ColorGammaShadows.w;
  float _434 = ColorContrast.w * ColorContrastShadows.w;
  float _448 = ColorSaturation.w * ColorSaturationShadows.w;
  float _452 = _375 - _378;
  float _453 = _376 - _378;
  float _454 = _377 - _378;
  float _511 = saturate(_378 / ColorCorrectionShadowsMax);
  float _515 = (_511 * _511) * (3.0f - (_511 * 2.0f));
  float _516 = 1.0f - _515;
  float _525 = ColorOffset.w + ColorOffsetHighlights.w;
  float _534 = ColorGain.w * ColorGainHighlights.w;
  float _543 = ColorGamma.w * ColorGammaHighlights.w;
  float _552 = ColorContrast.w * ColorContrastHighlights.w;
  float _561 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _624 = saturate((_378 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _628 = (_624 * _624) * (3.0f - (_624 * 2.0f));
  float _637 = ColorOffset.w + ColorOffsetMidtones.w;
  float _646 = ColorGain.w * ColorGainMidtones.w;
  float _655 = ColorGamma.w * ColorGammaMidtones.w;
  float _664 = ColorContrast.w * ColorContrastMidtones.w;
  float _673 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _731 = _515 - _628;
  float _742 = ((_628 * (((ColorOffset.x + ColorOffsetHighlights.x) + _525) + (((ColorGain.x * ColorGainHighlights.x) * _534) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _552) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _561) * _452) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _543)))))) + (_516 * (((ColorOffset.x + ColorOffsetShadows.x) + _392) + (((ColorGain.x * ColorGainShadows.x) * _406) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _434) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _448) * _452) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _420))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _637) + (((ColorGain.x * ColorGainMidtones.x) * _646) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _664) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _673) * _452) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _655))))) * _731);
  float _744 = ((_628 * (((ColorOffset.y + ColorOffsetHighlights.y) + _525) + (((ColorGain.y * ColorGainHighlights.y) * _534) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _552) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _561) * _453) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _543)))))) + (_516 * (((ColorOffset.y + ColorOffsetShadows.y) + _392) + (((ColorGain.y * ColorGainShadows.y) * _406) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _434) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _448) * _453) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _420))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _637) + (((ColorGain.y * ColorGainMidtones.y) * _646) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _664) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _673) * _453) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _655))))) * _731);
  float _746 = ((_628 * (((ColorOffset.z + ColorOffsetHighlights.z) + _525) + (((ColorGain.z * ColorGainHighlights.z) * _534) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _552) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _561) * _454) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _543)))))) + (_516 * (((ColorOffset.z + ColorOffsetShadows.z) + _392) + (((ColorGain.z * ColorGainShadows.z) * _406) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _434) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _448) * _454) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _420))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _637) + (((ColorGain.z * ColorGainMidtones.z) * _646) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _664) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _673) * _454) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _655))))) * _731);

  SetUntonemappedAP1(float3(_742, _744, _746));

  float _761 = ((mad(0.061360642313957214f, _746, mad(-4.540197551250458e-09f, _744, (_742 * 0.9386394023895264f))) - _742) * BlueCorrection) + _742;
  float _762 = ((mad(0.169205904006958f, _746, mad(0.8307942152023315f, _744, (_742 * 6.775371730327606e-08f))) - _744) * BlueCorrection) + _744;
  float _763 = (mad(-2.3283064365386963e-10f, _744, (_742 * -9.313225746154785e-10f)) * BlueCorrection) + _746;
  float _766 = mad(0.16386905312538147f, _763, mad(0.14067868888378143f, _762, (_761 * 0.6954522132873535f)));
  float _769 = mad(0.0955343246459961f, _763, mad(0.8596711158752441f, _762, (_761 * 0.044794581830501556f)));
  float _772 = mad(1.0015007257461548f, _763, mad(0.004025210160762072f, _762, (_761 * -0.005525882821530104f)));
  float _776 = max(max(_766, _769), _772);
  float _781 = (max(_776, 1.000000013351432e-10f) - max(min(min(_766, _769), _772), 1.000000013351432e-10f)) / max(_776, 0.009999999776482582f);
  float _794 = ((_769 + _766) + _772) + (sqrt((((_772 - _769) * _772) + ((_769 - _766) * _769)) + ((_766 - _772) * _766)) * 1.75f);
  float _795 = _794 * 0.3333333432674408f;
  float _796 = _781 + -0.4000000059604645f;
  float _797 = _796 * 5.0f;
  float _801 = max((1.0f - abs(_796 * 2.5f)), 0.0f);
  float _812 = ((float(((int)(uint)((bool)(_797 > 0.0f))) - ((int)(uint)((bool)(_797 < 0.0f)))) * (1.0f - (_801 * _801))) + 1.0f) * 0.02500000037252903f;
  if (!(_795 <= 0.0533333346247673f)) {
    if (!(_795 >= 0.1599999964237213f)) {
      _821 = (((0.23999999463558197f / _794) + -0.5f) * _812);
    } else {
      _821 = 0.0f;
    }
  } else {
    _821 = _812;
  }
  float _822 = _821 + 1.0f;
  float _823 = _822 * _766;
  float _824 = _822 * _769;
  float _825 = _822 * _772;
  if (!((bool)(_823 == _824) && (bool)(_824 == _825))) {
    float _832 = ((_823 * 2.0f) - _824) - _825;
    float _835 = ((_769 - _772) * 1.7320507764816284f) * _822;
    float _837 = atan(_835 / _832);
    bool _840 = (_832 < 0.0f);
    bool _841 = (_832 == 0.0f);
    bool _842 = (_835 >= 0.0f);
    bool _843 = (_835 < 0.0f);
    _854 = select((_842 && _841), 90.0f, select((_843 && _841), -90.0f, (select((_843 && _840), (_837 + -3.1415927410125732f), select((_842 && _840), (_837 + 3.1415927410125732f), _837)) * 57.2957763671875f)));
  } else {
    _854 = 0.0f;
  }
  float _859 = min(max(select((_854 < 0.0f), (_854 + 360.0f), _854), 0.0f), 360.0f);
  if (_859 < -180.0f) {
    _868 = (_859 + 360.0f);
  } else {
    if (_859 > 180.0f) {
      _868 = (_859 + -360.0f);
    } else {
      _868 = _859;
    }
  }
  float _872 = saturate(1.0f - abs(_868 * 0.014814814552664757f));
  float _876 = (_872 * _872) * (3.0f - (_872 * 2.0f));
  float _882 = ((_876 * _876) * ((_781 * 0.18000000715255737f) * (0.029999999329447746f - _823))) + _823;
  float _892 = max(0.0f, mad(-0.21492856740951538f, _825, mad(-0.2365107536315918f, _824, (_882 * 1.4514392614364624f))));
  float _893 = max(0.0f, mad(-0.09967592358589172f, _825, mad(1.17622971534729f, _824, (_882 * -0.07655377686023712f))));
  float _894 = max(0.0f, mad(0.9977163076400757f, _825, mad(-0.006032449658960104f, _824, (_882 * 0.008316148072481155f))));
  float _895 = dot(float3(_892, _893, _894), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _910 = (FilmBlackClip + 1.0f) - FilmToe;
  float _912 = FilmWhiteClip + 1.0f;
  float _914 = _912 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _932 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _923 = (FilmBlackClip + 0.18000000715255737f) / _910;
    _932 = (-0.7447274923324585f - ((log2(_923 / (2.0f - _923)) * 0.3465735912322998f) * (_910 / FilmSlope)));
  }
  float _935 = ((1.0f - FilmToe) / FilmSlope) - _932;
  float _937 = (FilmShoulder / FilmSlope) - _935;
  float _941 = log2(lerp(_895, _892, 0.9599999785423279f)) * 0.3010300099849701f;
  float _942 = log2(lerp(_895, _893, 0.9599999785423279f)) * 0.3010300099849701f;
  float _943 = log2(lerp(_895, _894, 0.9599999785423279f)) * 0.3010300099849701f;
  float _947 = FilmSlope * (_941 + _935);
  float _948 = FilmSlope * (_942 + _935);
  float _949 = FilmSlope * (_943 + _935);
  float _950 = _910 * 2.0f;
  float _952 = (FilmSlope * -2.0f) / _910;
  float _953 = _941 - _932;
  float _954 = _942 - _932;
  float _955 = _943 - _932;
  float _974 = _914 * 2.0f;
  float _976 = (FilmSlope * 2.0f) / _914;
  float _1001 = select((_941 < _932), ((_950 / (exp2((_953 * 1.4426950216293335f) * _952) + 1.0f)) - FilmBlackClip), _947);
  float _1002 = select((_942 < _932), ((_950 / (exp2((_954 * 1.4426950216293335f) * _952) + 1.0f)) - FilmBlackClip), _948);
  float _1003 = select((_943 < _932), ((_950 / (exp2((_955 * 1.4426950216293335f) * _952) + 1.0f)) - FilmBlackClip), _949);
  float _1010 = _937 - _932;
  float _1014 = saturate(_953 / _1010);
  float _1015 = saturate(_954 / _1010);
  float _1016 = saturate(_955 / _1010);
  bool _1017 = (_937 < _932);
  float _1021 = select(_1017, (1.0f - _1014), _1014);
  float _1022 = select(_1017, (1.0f - _1015), _1015);
  float _1023 = select(_1017, (1.0f - _1016), _1016);
  float _1042 = (((_1021 * _1021) * (select((_941 > _937), (_912 - (_974 / (exp2(((_941 - _937) * 1.4426950216293335f) * _976) + 1.0f))), _947) - _1001)) * (3.0f - (_1021 * 2.0f))) + _1001;
  float _1043 = (((_1022 * _1022) * (select((_942 > _937), (_912 - (_974 / (exp2(((_942 - _937) * 1.4426950216293335f) * _976) + 1.0f))), _948) - _1002)) * (3.0f - (_1022 * 2.0f))) + _1002;
  float _1044 = (((_1023 * _1023) * (select((_943 > _937), (_912 - (_974 / (exp2(((_943 - _937) * 1.4426950216293335f) * _976) + 1.0f))), _949) - _1003)) * (3.0f - (_1023 * 2.0f))) + _1003;
  float _1045 = dot(float3(_1042, _1043, _1044), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1065 = (ToneCurveAmount * (max(0.0f, (lerp(_1045, _1042, 0.9300000071525574f))) - _761)) + _761;
  float _1066 = (ToneCurveAmount * (max(0.0f, (lerp(_1045, _1043, 0.9300000071525574f))) - _762)) + _762;
  float _1067 = (ToneCurveAmount * (max(0.0f, (lerp(_1045, _1044, 0.9300000071525574f))) - _763)) + _763;
  float _1083 = ((mad(-0.06537103652954102f, _1067, mad(1.451815478503704e-06f, _1066, (_1065 * 1.065374732017517f))) - _1065) * BlueCorrection) + _1065;
  float _1084 = ((mad(-0.20366770029067993f, _1067, mad(1.2036634683609009f, _1066, (_1065 * -2.57161445915699e-07f))) - _1066) * BlueCorrection) + _1066;
  float _1085 = ((mad(0.9999996423721313f, _1067, mad(2.0954757928848267e-08f, _1066, (_1065 * 1.862645149230957e-08f))) - _1067) * BlueCorrection) + _1067;

  SetTonemappedAP1(_1083, _1084, _1085);

  float _1110 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1085, mad((WorkingColorSpace_FromAP1[0].y), _1084, ((WorkingColorSpace_FromAP1[0].x) * _1083)))));
  float _1111 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1085, mad((WorkingColorSpace_FromAP1[1].y), _1084, ((WorkingColorSpace_FromAP1[1].x) * _1083)))));
  float _1112 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1085, mad((WorkingColorSpace_FromAP1[2].y), _1084, ((WorkingColorSpace_FromAP1[2].x) * _1083)))));
  if (_1110 < 0.0031306699384003878f) {
    _1123 = (_1110 * 12.920000076293945f);
  } else {
    _1123 = (((pow(_1110, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1111 < 0.0031306699384003878f) {
    _1134 = (_1111 * 12.920000076293945f);
  } else {
    _1134 = (((pow(_1111, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1112 < 0.0031306699384003878f) {
    _1145 = (_1112 * 12.920000076293945f);
  } else {
    _1145 = (((pow(_1112, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1149 = (_1134 * 0.9375f) + 0.03125f;
  float _1156 = _1145 * 15.0f;
  float _1157 = floor(_1156);
  float _1158 = _1156 - _1157;
  float _1160 = (_1157 + ((_1123 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1163 = Textures_1.Sample(Samplers_1, float2(_1160, _1149));
  float _1167 = _1160 + 0.0625f;
  float4 _1170 = Textures_1.Sample(Samplers_1, float2(_1167, _1149));
  float4 _1193 = Textures_2.Sample(Samplers_2, float2(_1160, _1149));
  float4 _1199 = Textures_2.Sample(Samplers_2, float2(_1167, _1149));
  float _1218 = max(6.103519990574569e-05f, ((((lerp(_1163.x, _1170.x, _1158)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1123)) + ((lerp(_1193.x, _1199.x, _1158)) * (LUTWeights[0].z))));
  float _1219 = max(6.103519990574569e-05f, ((((lerp(_1163.y, _1170.y, _1158)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1134)) + ((lerp(_1193.y, _1199.y, _1158)) * (LUTWeights[0].z))));
  float _1220 = max(6.103519990574569e-05f, ((((lerp(_1163.z, _1170.z, _1158)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1145)) + ((lerp(_1193.z, _1199.z, _1158)) * (LUTWeights[0].z))));
  float _1242 = select((_1218 > 0.040449999272823334f), exp2(log2((_1218 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1218 * 0.07739938050508499f));
  float _1243 = select((_1219 > 0.040449999272823334f), exp2(log2((_1219 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1219 * 0.07739938050508499f));
  float _1244 = select((_1220 > 0.040449999272823334f), exp2(log2((_1220 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1220 * 0.07739938050508499f));
  float _1270 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1242)) * _1242) + MappingPolynomial.z);
  float _1271 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1243)) * _1243) + MappingPolynomial.z);
  float _1272 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1244)) * _1244) + MappingPolynomial.z);
  float _1293 = exp2(log2(max(0.0f, (lerp(_1270, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1294 = exp2(log2(max(0.0f, (lerp(_1271, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1295 = exp2(log2(max(0.0f, (lerp(_1272, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1293, _1294, _1295), OutputDevice);
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1314 = mad((WorkingColorSpace_ToAP1[0].z), _1295, mad((WorkingColorSpace_ToAP1[0].y), _1294, ((WorkingColorSpace_ToAP1[0].x) * _1293)));
    float _1317 = mad((WorkingColorSpace_ToAP1[1].z), _1295, mad((WorkingColorSpace_ToAP1[1].y), _1294, ((WorkingColorSpace_ToAP1[1].x) * _1293)));
    float _1320 = mad((WorkingColorSpace_ToAP1[2].z), _1295, mad((WorkingColorSpace_ToAP1[2].y), _1294, ((WorkingColorSpace_ToAP1[2].x) * _1293)));
    _1331 = mad(_45, _1320, mad(_44, _1317, (_1314 * _43)));
    _1332 = mad(_48, _1320, mad(_47, _1317, (_1314 * _46)));
    _1333 = mad(_51, _1320, mad(_50, _1317, (_1314 * _49)));
  } else {
    _1331 = _1293;
    _1332 = _1294;
    _1333 = _1295;
  }
  if (_1331 < 0.0031306699384003878f) {
    _1344 = (_1331 * 12.920000076293945f);
  } else {
    _1344 = (((pow(_1331, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1332 < 0.0031306699384003878f) {
    _1355 = (_1332 * 12.920000076293945f);
  } else {
    _1355 = (((pow(_1332, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1333 < 0.0031306699384003878f) {
    _1366 = (_1333 * 12.920000076293945f);
  } else {
    _1366 = (((pow(_1333, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1344 * 0.9523810148239136f);
  SV_Target.y = (_1355 * 0.9523810148239136f);
  SV_Target.z = (_1366 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

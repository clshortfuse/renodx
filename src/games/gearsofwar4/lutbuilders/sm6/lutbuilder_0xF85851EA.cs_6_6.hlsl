#include "../../common.hlsl"

// found in outer worlds 2

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};


Texture2D<float4> Textures_1 : register(t0);

RWTexture3D<float4> RWOutputTexture : register(u0);

cbuffer _RootShaderParameters : register(b0) {
  float4 LUTWeights[2] : packoffset(c005.x);
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
  float2 OutputExtentInverse : packoffset(c042.x);
};

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

SamplerState Samplers_1 : register(s0);

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _22 = 0.5f / LUTSize;
  float _27 = LUTSize + -1.0f;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _122;
  float _829;
  float _862;
  float _876;
  float _940;
  float _1131;
  float _1142;
  float _1153;
  float _1296;
  float _1297;
  float _1298;
  float _1309;
  float _1320;
  float _1331;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _40 = (OutputGamut == 4);
        _51 = select(_40, 1.0f, 1.705051064491272f);
        _52 = select(_40, 0.0f, -0.6217921376228333f);
        _53 = select(_40, 0.0f, -0.0832589864730835f);
        _54 = select(_40, 0.0f, -0.13025647401809692f);
        _55 = select(_40, 1.0f, 1.140804648399353f);
        _56 = select(_40, 0.0f, -0.010548308491706848f);
        _57 = select(_40, 0.0f, -0.024003351107239723f);
        _58 = select(_40, 0.0f, -0.1289689838886261f);
        _59 = select(_40, 1.0f, 1.1529725790023804f);
      } else {
        _51 = 0.6954522132873535f;
        _52 = 0.14067870378494263f;
        _53 = 0.16386906802654266f;
        _54 = 0.044794563204050064f;
        _55 = 0.8596711158752441f;
        _56 = 0.0955343171954155f;
        _57 = -0.005525882821530104f;
        _58 = 0.004025210160762072f;
        _59 = 1.0015007257461548f;
      }
    } else {
      _51 = 1.0258246660232544f;
      _52 = -0.020053181797266006f;
      _53 = -0.005771636962890625f;
      _54 = -0.002234415616840124f;
      _55 = 1.0045864582061768f;
      _56 = -0.002352118492126465f;
      _57 = -0.005013350863009691f;
      _58 = -0.025290070101618767f;
      _59 = 1.0303035974502563f;
    }
  } else {
    _51 = 1.3792141675949097f;
    _52 = -0.30886411666870117f;
    _53 = -0.0703500509262085f;
    _54 = -0.06933490186929703f;
    _55 = 1.08229660987854f;
    _56 = -0.012961871922016144f;
    _57 = -0.0021590073592960835f;
    _58 = -0.0454593189060688f;
    _59 = 1.0476183891296387f;
  }
  float _72 = (exp2((((LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _22)) / _27) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _73 = (exp2((((LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _22)) / _27) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _74 = (exp2(((float((uint)SV_DispatchThreadID.z) / _27) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _101 = (bIsTemperatureWhiteBalance != 0);
  float _105 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _122 = (((((2967800.0f - (_105 * 4607000064.0f)) * _105) + 99.11000061035156f) * _105) + 0.24406300485134125f);
  } else {
    _122 = (((((1901800.0f - (_105 * 2006400000.0f)) * _105) + 247.47999572753906f) * _105) + 0.23703999817371368f);
  }
  float _136 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _143 = WhiteTemp * WhiteTemp;
  float _146 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_143 * 1.6145605741257896e-07f));
  float _151 = ((_136 * 2.0f) + 4.0f) - (_146 * 8.0f);
  float _152 = (_136 * 3.0f) / _151;
  float _154 = (_146 * 2.0f) / _151;
  bool _155 = (WhiteTemp < 4000.0f);
  float _164 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _166 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_143 * 1.5317699909210205f)) / (_164 * _164);
  float _173 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _143;
  float _175 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_143 * 308.60699462890625f)) / (_173 * _173);
  float _177 = rsqrt(dot(float2(_166, _175), float2(_166, _175)));
  float _178 = WhiteTint * 0.05000000074505806f;
  float _181 = ((_178 * _175) * _177) + _136;
  float _184 = _146 - ((_178 * _166) * _177);
  float _189 = (4.0f - (_184 * 8.0f)) + (_181 * 2.0f);
  float _195 = (((_181 * 3.0f) / _189) - _152) + select(_155, _152, _122);
  float _196 = (((_184 * 2.0f) / _189) - _154) + select(_155, _154, (((_122 * 2.869999885559082f) + -0.2750000059604645f) - ((_122 * _122) * 3.0f)));
  float _197 = select(_101, _195, 0.3127000033855438f);
  float _198 = select(_101, _196, 0.32899999618530273f);
  float _199 = select(_101, 0.3127000033855438f, _195);
  float _200 = select(_101, 0.32899999618530273f, _196);
  float _201 = max(_198, 1.000000013351432e-10f);
  float _202 = _197 / _201;
  float _205 = ((1.0f - _197) - _198) / _201;
  float _206 = max(_200, 1.000000013351432e-10f);
  float _207 = _199 / _206;
  float _210 = ((1.0f - _199) - _200) / _206;
  float _229 = mad(-0.16140000522136688f, _210, ((_207 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _205, ((_202 * 0.8950999975204468f) + 0.266400009393692f));
  float _230 = mad(0.03669999912381172f, _210, (1.7135000228881836f - (_207 * 0.7501999735832214f))) / mad(0.03669999912381172f, _205, (1.7135000228881836f - (_202 * 0.7501999735832214f)));
  float _231 = mad(1.0296000242233276f, _210, ((_207 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _205, ((_202 * 0.03889999911189079f) + -0.06849999725818634f));
  float _232 = mad(_230, -0.7501999735832214f, 0.0f);
  float _233 = mad(_230, 1.7135000228881836f, 0.0f);
  float _234 = mad(_230, 0.03669999912381172f, -0.0f);
  float _235 = mad(_231, 0.03889999911189079f, 0.0f);
  float _236 = mad(_231, -0.06849999725818634f, 0.0f);
  float _237 = mad(_231, 1.0296000242233276f, 0.0f);
  float _240 = mad(0.1599626988172531f, _235, mad(-0.1470542997121811f, _232, (_229 * 0.883457362651825f)));
  float _243 = mad(0.1599626988172531f, _236, mad(-0.1470542997121811f, _233, (_229 * 0.26293492317199707f)));
  float _246 = mad(0.1599626988172531f, _237, mad(-0.1470542997121811f, _234, (_229 * -0.15930065512657166f)));
  float _249 = mad(0.04929120093584061f, _235, mad(0.5183603167533875f, _232, (_229 * 0.38695648312568665f)));
  float _252 = mad(0.04929120093584061f, _236, mad(0.5183603167533875f, _233, (_229 * 0.11516613513231277f)));
  float _255 = mad(0.04929120093584061f, _237, mad(0.5183603167533875f, _234, (_229 * -0.0697740763425827f)));
  float _258 = mad(0.9684867262840271f, _235, mad(0.04004279896616936f, _232, (_229 * -0.007634039502590895f)));
  float _261 = mad(0.9684867262840271f, _236, mad(0.04004279896616936f, _233, (_229 * -0.0022720457054674625f)));
  float _264 = mad(0.9684867262840271f, _237, mad(0.04004279896616936f, _234, (_229 * 0.0013765322510153055f)));
  float _267 = mad(_246, (WorkingColorSpace.ToXYZ[2].x), mad(_243, (WorkingColorSpace.ToXYZ[1].x), (_240 * (WorkingColorSpace.ToXYZ[0].x))));
  float _270 = mad(_246, (WorkingColorSpace.ToXYZ[2].y), mad(_243, (WorkingColorSpace.ToXYZ[1].y), (_240 * (WorkingColorSpace.ToXYZ[0].y))));
  float _273 = mad(_246, (WorkingColorSpace.ToXYZ[2].z), mad(_243, (WorkingColorSpace.ToXYZ[1].z), (_240 * (WorkingColorSpace.ToXYZ[0].z))));
  float _276 = mad(_255, (WorkingColorSpace.ToXYZ[2].x), mad(_252, (WorkingColorSpace.ToXYZ[1].x), (_249 * (WorkingColorSpace.ToXYZ[0].x))));
  float _279 = mad(_255, (WorkingColorSpace.ToXYZ[2].y), mad(_252, (WorkingColorSpace.ToXYZ[1].y), (_249 * (WorkingColorSpace.ToXYZ[0].y))));
  float _282 = mad(_255, (WorkingColorSpace.ToXYZ[2].z), mad(_252, (WorkingColorSpace.ToXYZ[1].z), (_249 * (WorkingColorSpace.ToXYZ[0].z))));
  float _285 = mad(_264, (WorkingColorSpace.ToXYZ[2].x), mad(_261, (WorkingColorSpace.ToXYZ[1].x), (_258 * (WorkingColorSpace.ToXYZ[0].x))));
  float _288 = mad(_264, (WorkingColorSpace.ToXYZ[2].y), mad(_261, (WorkingColorSpace.ToXYZ[1].y), (_258 * (WorkingColorSpace.ToXYZ[0].y))));
  float _291 = mad(_264, (WorkingColorSpace.ToXYZ[2].z), mad(_261, (WorkingColorSpace.ToXYZ[1].z), (_258 * (WorkingColorSpace.ToXYZ[0].z))));
  float _321 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _291, mad((WorkingColorSpace.FromXYZ[0].y), _282, (_273 * (WorkingColorSpace.FromXYZ[0].x)))), _74, mad(mad((WorkingColorSpace.FromXYZ[0].z), _288, mad((WorkingColorSpace.FromXYZ[0].y), _279, (_270 * (WorkingColorSpace.FromXYZ[0].x)))), _73, (mad((WorkingColorSpace.FromXYZ[0].z), _285, mad((WorkingColorSpace.FromXYZ[0].y), _276, (_267 * (WorkingColorSpace.FromXYZ[0].x)))) * _72)));
  float _324 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _291, mad((WorkingColorSpace.FromXYZ[1].y), _282, (_273 * (WorkingColorSpace.FromXYZ[1].x)))), _74, mad(mad((WorkingColorSpace.FromXYZ[1].z), _288, mad((WorkingColorSpace.FromXYZ[1].y), _279, (_270 * (WorkingColorSpace.FromXYZ[1].x)))), _73, (mad((WorkingColorSpace.FromXYZ[1].z), _285, mad((WorkingColorSpace.FromXYZ[1].y), _276, (_267 * (WorkingColorSpace.FromXYZ[1].x)))) * _72)));
  float _327 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _291, mad((WorkingColorSpace.FromXYZ[2].y), _282, (_273 * (WorkingColorSpace.FromXYZ[2].x)))), _74, mad(mad((WorkingColorSpace.FromXYZ[2].z), _288, mad((WorkingColorSpace.FromXYZ[2].y), _279, (_270 * (WorkingColorSpace.FromXYZ[2].x)))), _73, (mad((WorkingColorSpace.FromXYZ[2].z), _285, mad((WorkingColorSpace.FromXYZ[2].y), _276, (_267 * (WorkingColorSpace.FromXYZ[2].x)))) * _72)));
  float _342 = mad((WorkingColorSpace.ToAP1[0].z), _327, mad((WorkingColorSpace.ToAP1[0].y), _324, ((WorkingColorSpace.ToAP1[0].x) * _321)));
  float _345 = mad((WorkingColorSpace.ToAP1[1].z), _327, mad((WorkingColorSpace.ToAP1[1].y), _324, ((WorkingColorSpace.ToAP1[1].x) * _321)));
  float _348 = mad((WorkingColorSpace.ToAP1[2].z), _327, mad((WorkingColorSpace.ToAP1[2].y), _324, ((WorkingColorSpace.ToAP1[2].x) * _321)));
  float _349 = dot(float3(_342, _345, _348), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_342, _345, _348));

  float _353 = (_342 / _349) + -1.0f;
  float _354 = (_345 / _349) + -1.0f;
  float _355 = (_348 / _349) + -1.0f;
  float _367 = (1.0f - exp2(((_349 * _349) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_353, _354, _355), float3(_353, _354, _355)) * -4.0f));
  float _383 = ((mad(-0.06368321925401688f, _348, mad(-0.3292922377586365f, _345, (_342 * 1.3704125881195068f))) - _342) * _367) + _342;
  float _384 = ((mad(-0.010861365124583244f, _348, mad(1.0970927476882935f, _345, (_342 * -0.08343357592821121f))) - _345) * _367) + _345;
  float _385 = ((mad(1.2036951780319214f, _348, mad(-0.09862580895423889f, _345, (_342 * -0.02579331398010254f))) - _348) * _367) + _348;
  float _386 = dot(float3(_383, _384, _385), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _400 = ColorOffset.w + ColorOffsetShadows.w;
  float _414 = ColorGain.w * ColorGainShadows.w;
  float _428 = ColorGamma.w * ColorGammaShadows.w;
  float _442 = ColorContrast.w * ColorContrastShadows.w;
  float _456 = ColorSaturation.w * ColorSaturationShadows.w;
  float _460 = _383 - _386;
  float _461 = _384 - _386;
  float _462 = _385 - _386;
  float _519 = saturate(_386 / ColorCorrectionShadowsMax);
  float _523 = (_519 * _519) * (3.0f - (_519 * 2.0f));
  float _524 = 1.0f - _523;
  float _533 = ColorOffset.w + ColorOffsetHighlights.w;
  float _542 = ColorGain.w * ColorGainHighlights.w;
  float _551 = ColorGamma.w * ColorGammaHighlights.w;
  float _560 = ColorContrast.w * ColorContrastHighlights.w;
  float _569 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _632 = saturate((_386 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _636 = (_632 * _632) * (3.0f - (_632 * 2.0f));
  float _645 = ColorOffset.w + ColorOffsetMidtones.w;
  float _654 = ColorGain.w * ColorGainMidtones.w;
  float _663 = ColorGamma.w * ColorGammaMidtones.w;
  float _672 = ColorContrast.w * ColorContrastMidtones.w;
  float _681 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _739 = _523 - _636;
  float _750 = ((_636 * (((ColorOffset.x + ColorOffsetHighlights.x) + _533) + (((ColorGain.x * ColorGainHighlights.x) * _542) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _560) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _569) * _460) + _386)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _551)))))) + (_524 * (((ColorOffset.x + ColorOffsetShadows.x) + _400) + (((ColorGain.x * ColorGainShadows.x) * _414) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _442) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _456) * _460) + _386)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _428))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _645) + (((ColorGain.x * ColorGainMidtones.x) * _654) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _672) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _681) * _460) + _386)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _663))))) * _739);
  float _752 = ((_636 * (((ColorOffset.y + ColorOffsetHighlights.y) + _533) + (((ColorGain.y * ColorGainHighlights.y) * _542) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _560) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _569) * _461) + _386)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _551)))))) + (_524 * (((ColorOffset.y + ColorOffsetShadows.y) + _400) + (((ColorGain.y * ColorGainShadows.y) * _414) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _442) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _456) * _461) + _386)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _428))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _645) + (((ColorGain.y * ColorGainMidtones.y) * _654) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _672) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _681) * _461) + _386)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _663))))) * _739);
  float _754 = ((_636 * (((ColorOffset.z + ColorOffsetHighlights.z) + _533) + (((ColorGain.z * ColorGainHighlights.z) * _542) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _560) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _569) * _462) + _386)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _551)))))) + (_524 * (((ColorOffset.z + ColorOffsetShadows.z) + _400) + (((ColorGain.z * ColorGainShadows.z) * _414) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _442) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _456) * _462) + _386)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _428))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _645) + (((ColorGain.z * ColorGainMidtones.z) * _654) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _672) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _681) * _462) + _386)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _663))))) * _739);

  SetUntonemappedAP1(float3(_750, _752, _754));

  float _769 = ((mad(0.061360642313957214f, _754, mad(-4.540197551250458e-09f, _752, (_750 * 0.9386394023895264f))) - _750) * BlueCorrection) + _750;
  float _770 = ((mad(0.169205904006958f, _754, mad(0.8307942152023315f, _752, (_750 * 6.775371730327606e-08f))) - _752) * BlueCorrection) + _752;
  float _771 = (mad(-2.3283064365386963e-10f, _752, (_750 * -9.313225746154785e-10f)) * BlueCorrection) + _754;
  float _774 = mad(0.16386905312538147f, _771, mad(0.14067868888378143f, _770, (_769 * 0.6954522132873535f)));
  float _777 = mad(0.0955343246459961f, _771, mad(0.8596711158752441f, _770, (_769 * 0.044794581830501556f)));
  float _780 = mad(1.0015007257461548f, _771, mad(0.004025210160762072f, _770, (_769 * -0.005525882821530104f)));
  float _784 = max(max(_774, _777), _780);
  float _789 = (max(_784, 1.000000013351432e-10f) - max(min(min(_774, _777), _780), 1.000000013351432e-10f)) / max(_784, 0.009999999776482582f);
  float _802 = ((_777 + _774) + _780) + (sqrt((((_780 - _777) * _780) + ((_777 - _774) * _777)) + ((_774 - _780) * _774)) * 1.75f);
  float _803 = _802 * 0.3333333432674408f;
  float _804 = _789 + -0.4000000059604645f;
  float _805 = _804 * 5.0f;
  float _809 = max((1.0f - abs(_804 * 2.5f)), 0.0f);
  float _820 = ((float((int)(((int)(uint)((bool)(_805 > 0.0f))) - ((int)(uint)((bool)(_805 < 0.0f))))) * (1.0f - (_809 * _809))) + 1.0f) * 0.02500000037252903f;
  if (!(_803 <= 0.0533333346247673f)) {
    if (!(_803 >= 0.1599999964237213f)) {
      _829 = (((0.23999999463558197f / _802) + -0.5f) * _820);
    } else {
      _829 = 0.0f;
    }
  } else {
    _829 = _820;
  }
  float _830 = _829 + 1.0f;
  float _831 = _830 * _774;
  float _832 = _830 * _777;
  float _833 = _830 * _780;
  if (!((bool)(_831 == _832) && (bool)(_832 == _833))) {
    float _840 = ((_831 * 2.0f) - _832) - _833;
    float _843 = ((_777 - _780) * 1.7320507764816284f) * _830;
    float _845 = atan(_843 / _840);
    bool _848 = (_840 < 0.0f);
    bool _849 = (_840 == 0.0f);
    bool _850 = (_843 >= 0.0f);
    bool _851 = (_843 < 0.0f);
    _862 = select((_850 && _849), 90.0f, select((_851 && _849), -90.0f, (select((_851 && _848), (_845 + -3.1415927410125732f), select((_850 && _848), (_845 + 3.1415927410125732f), _845)) * 57.2957763671875f)));
  } else {
    _862 = 0.0f;
  }
  float _867 = min(max(select((_862 < 0.0f), (_862 + 360.0f), _862), 0.0f), 360.0f);
  if (_867 < -180.0f) {
    _876 = (_867 + 360.0f);
  } else {
    if (_867 > 180.0f) {
      _876 = (_867 + -360.0f);
    } else {
      _876 = _867;
    }
  }
  float _880 = saturate(1.0f - abs(_876 * 0.014814814552664757f));
  float _884 = (_880 * _880) * (3.0f - (_880 * 2.0f));
  float _890 = ((_884 * _884) * ((_789 * 0.18000000715255737f) * (0.029999999329447746f - _831))) + _831;
  float _900 = max(0.0f, mad(-0.21492856740951538f, _833, mad(-0.2365107536315918f, _832, (_890 * 1.4514392614364624f))));
  float _901 = max(0.0f, mad(-0.09967592358589172f, _833, mad(1.17622971534729f, _832, (_890 * -0.07655377686023712f))));
  float _902 = max(0.0f, mad(0.9977163076400757f, _833, mad(-0.006032449658960104f, _832, (_890 * 0.008316148072481155f))));
  float _903 = dot(float3(_900, _901, _902), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _918 = (FilmBlackClip + 1.0f) - FilmToe;
  float _920 = FilmWhiteClip + 1.0f;
  float _922 = _920 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _940 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _931 = (FilmBlackClip + 0.18000000715255737f) / _918;
    _940 = (-0.7447274923324585f - ((log2(_931 / (2.0f - _931)) * 0.3465735912322998f) * (_918 / FilmSlope)));
  }
  float _943 = ((1.0f - FilmToe) / FilmSlope) - _940;
  float _945 = (FilmShoulder / FilmSlope) - _943;
  float _949 = log2(lerp(_903, _900, 0.9599999785423279f)) * 0.3010300099849701f;
  float _950 = log2(lerp(_903, _901, 0.9599999785423279f)) * 0.3010300099849701f;
  float _951 = log2(lerp(_903, _902, 0.9599999785423279f)) * 0.3010300099849701f;
  float _955 = FilmSlope * (_949 + _943);
  float _956 = FilmSlope * (_950 + _943);
  float _957 = FilmSlope * (_951 + _943);
  float _958 = _918 * 2.0f;
  float _960 = (FilmSlope * -2.0f) / _918;
  float _961 = _949 - _940;
  float _962 = _950 - _940;
  float _963 = _951 - _940;
  float _982 = _922 * 2.0f;
  float _984 = (FilmSlope * 2.0f) / _922;
  float _1009 = select((_949 < _940), ((_958 / (exp2((_961 * 1.4426950216293335f) * _960) + 1.0f)) - FilmBlackClip), _955);
  float _1010 = select((_950 < _940), ((_958 / (exp2((_962 * 1.4426950216293335f) * _960) + 1.0f)) - FilmBlackClip), _956);
  float _1011 = select((_951 < _940), ((_958 / (exp2((_963 * 1.4426950216293335f) * _960) + 1.0f)) - FilmBlackClip), _957);
  float _1018 = _945 - _940;
  float _1022 = saturate(_961 / _1018);
  float _1023 = saturate(_962 / _1018);
  float _1024 = saturate(_963 / _1018);
  bool _1025 = (_945 < _940);
  float _1029 = select(_1025, (1.0f - _1022), _1022);
  float _1030 = select(_1025, (1.0f - _1023), _1023);
  float _1031 = select(_1025, (1.0f - _1024), _1024);
  float _1050 = (((_1029 * _1029) * (select((_949 > _945), (_920 - (_982 / (exp2(((_949 - _945) * 1.4426950216293335f) * _984) + 1.0f))), _955) - _1009)) * (3.0f - (_1029 * 2.0f))) + _1009;
  float _1051 = (((_1030 * _1030) * (select((_950 > _945), (_920 - (_982 / (exp2(((_950 - _945) * 1.4426950216293335f) * _984) + 1.0f))), _956) - _1010)) * (3.0f - (_1030 * 2.0f))) + _1010;
  float _1052 = (((_1031 * _1031) * (select((_951 > _945), (_920 - (_982 / (exp2(((_951 - _945) * 1.4426950216293335f) * _984) + 1.0f))), _957) - _1011)) * (3.0f - (_1031 * 2.0f))) + _1011;
  float _1053 = dot(float3(_1050, _1051, _1052), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1073 = (ToneCurveAmount * (max(0.0f, (lerp(_1053, _1050, 0.9300000071525574f))) - _769)) + _769;
  float _1074 = (ToneCurveAmount * (max(0.0f, (lerp(_1053, _1051, 0.9300000071525574f))) - _770)) + _770;
  float _1075 = (ToneCurveAmount * (max(0.0f, (lerp(_1053, _1052, 0.9300000071525574f))) - _771)) + _771;
  float _1091 = ((mad(-0.06537103652954102f, _1075, mad(1.451815478503704e-06f, _1074, (_1073 * 1.065374732017517f))) - _1073) * BlueCorrection) + _1073;
  float _1092 = ((mad(-0.20366770029067993f, _1075, mad(1.2036634683609009f, _1074, (_1073 * -2.57161445915699e-07f))) - _1074) * BlueCorrection) + _1074;
  float _1093 = ((mad(0.9999996423721313f, _1075, mad(2.0954757928848267e-08f, _1074, (_1073 * 1.862645149230957e-08f))) - _1075) * BlueCorrection) + _1075;

  SetTonemappedAP1(_1091, _1092, _1093);

  float _1118 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[0].z), _1093, mad((WorkingColorSpace.FromAP1[0].y), _1092, ((WorkingColorSpace.FromAP1[0].x) * _1091)))));
  float _1119 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[1].z), _1093, mad((WorkingColorSpace.FromAP1[1].y), _1092, ((WorkingColorSpace.FromAP1[1].x) * _1091)))));
  float _1120 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[2].z), _1093, mad((WorkingColorSpace.FromAP1[2].y), _1092, ((WorkingColorSpace.FromAP1[2].x) * _1091)))));
  if (_1118 < 0.0031306699384003878f) {
    _1131 = (_1118 * 12.920000076293945f);
  } else {
    _1131 = (((pow(_1118, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1119 < 0.0031306699384003878f) {
    _1142 = (_1119 * 12.920000076293945f);
  } else {
    _1142 = (((pow(_1119, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1120 < 0.0031306699384003878f) {
    _1153 = (_1120 * 12.920000076293945f);
  } else {
    _1153 = (((pow(_1120, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1157 = (_1142 * 0.9375f) + 0.03125f;
  float _1164 = _1153 * 15.0f;
  float _1165 = floor(_1164);
  float _1166 = _1164 - _1165;
  float _1168 = (((_1131 * 0.9375f) + 0.03125f) + _1165) * 0.0625f;
  float4 _1171 = Textures_1.SampleLevel(Samplers_1, float2(_1168, _1157), 0.0f);
  float4 _1176 = Textures_1.SampleLevel(Samplers_1, float2((_1168 + 0.0625f), _1157), 0.0f);
  float _1195 = max(6.103519990574569e-05f, (((lerp(_1171.x, _1176.x, _1166)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1131)));
  float _1196 = max(6.103519990574569e-05f, (((lerp(_1171.y, _1176.y, _1166)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1142)));
  float _1197 = max(6.103519990574569e-05f, (((lerp(_1171.z, _1176.z, _1166)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1153)));
  float _1219 = select((_1195 > 0.040449999272823334f), exp2(log2((_1195 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1195 * 0.07739938050508499f));
  float _1220 = select((_1196 > 0.040449999272823334f), exp2(log2((_1196 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1196 * 0.07739938050508499f));
  float _1221 = select((_1197 > 0.040449999272823334f), exp2(log2((_1197 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1197 * 0.07739938050508499f));
  float _1247 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1219)) * _1219) + MappingPolynomial.z);
  float _1248 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1220)) * _1220) + MappingPolynomial.z);
  float _1249 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1221)) * _1221) + MappingPolynomial.z);
  float _1270 = exp2(log2(max(0.0f, (lerp(_1247, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1271 = exp2(log2(max(0.0f, (lerp(_1248, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1272 = exp2(log2(max(0.0f, (lerp(_1249, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    // return GenerateOutput(float3(_123, _456, _789));
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = GenerateOutput(float3(_1270, _1271, _1272), OutputDevice);
    return;
  }

  if (WorkingColorSpace.bIsSRGB == 0) {
    float _1279 = mad((WorkingColorSpace.ToAP1[0].z), _1272, mad((WorkingColorSpace.ToAP1[0].y), _1271, ((WorkingColorSpace.ToAP1[0].x) * _1270)));
    float _1282 = mad((WorkingColorSpace.ToAP1[1].z), _1272, mad((WorkingColorSpace.ToAP1[1].y), _1271, ((WorkingColorSpace.ToAP1[1].x) * _1270)));
    float _1285 = mad((WorkingColorSpace.ToAP1[2].z), _1272, mad((WorkingColorSpace.ToAP1[2].y), _1271, ((WorkingColorSpace.ToAP1[2].x) * _1270)));
    _1296 = mad(_53, _1285, mad(_52, _1282, (_1279 * _51)));
    _1297 = mad(_56, _1285, mad(_55, _1282, (_1279 * _54)));
    _1298 = mad(_59, _1285, mad(_58, _1282, (_1279 * _57)));
  } else {
    _1296 = _1270;
    _1297 = _1271;
    _1298 = _1272;
  }
  if (_1296 < 0.0031306699384003878f) {
    _1309 = (_1296 * 12.920000076293945f);
  } else {
    _1309 = (((pow(_1296, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1297 < 0.0031306699384003878f) {
    _1320 = (_1297 * 12.920000076293945f);
  } else {
    _1320 = (((pow(_1297, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1298 < 0.0031306699384003878f) {
    _1331 = (_1298 * 12.920000076293945f);
  } else {
    _1331 = (((pow(_1298, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1309 * 0.9523810148239136f), (_1320 * 0.9523810148239136f), (_1331 * 0.9523810148239136f), 0.0f);
}

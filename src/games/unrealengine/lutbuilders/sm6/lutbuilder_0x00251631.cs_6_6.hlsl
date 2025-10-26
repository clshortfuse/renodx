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


RWTexture3D<float4> RWOutputTexture : register(u0);

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
  float2 OutputExtentInverse : packoffset(c042.x);
};

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _20 = 0.5f / LUTSize;
  float _25 = LUTSize + -1.0f;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _120;
  float _827;
  float _860;
  float _874;
  float _938;
  float _1190;
  float _1191;
  float _1192;
  float _1203;
  float _1214;
  float _1225;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _38 = (OutputGamut == 4);
        _49 = select(_38, 1.0f, 1.705051064491272f);
        _50 = select(_38, 0.0f, -0.6217921376228333f);
        _51 = select(_38, 0.0f, -0.0832589864730835f);
        _52 = select(_38, 0.0f, -0.13025647401809692f);
        _53 = select(_38, 1.0f, 1.140804648399353f);
        _54 = select(_38, 0.0f, -0.010548308491706848f);
        _55 = select(_38, 0.0f, -0.024003351107239723f);
        _56 = select(_38, 0.0f, -0.1289689838886261f);
        _57 = select(_38, 1.0f, 1.1529725790023804f);
      } else {
        _49 = 0.6954522132873535f;
        _50 = 0.14067870378494263f;
        _51 = 0.16386906802654266f;
        _52 = 0.044794563204050064f;
        _53 = 0.8596711158752441f;
        _54 = 0.0955343171954155f;
        _55 = -0.005525882821530104f;
        _56 = 0.004025210160762072f;
        _57 = 1.0015007257461548f;
      }
    } else {
      _49 = 1.0258246660232544f;
      _50 = -0.020053181797266006f;
      _51 = -0.005771636962890625f;
      _52 = -0.002234415616840124f;
      _53 = 1.0045864582061768f;
      _54 = -0.002352118492126465f;
      _55 = -0.005013350863009691f;
      _56 = -0.025290070101618767f;
      _57 = 1.0303035974502563f;
    }
  } else {
    _49 = 1.3792141675949097f;
    _50 = -0.30886411666870117f;
    _51 = -0.0703500509262085f;
    _52 = -0.06933490186929703f;
    _53 = 1.08229660987854f;
    _54 = -0.012961871922016144f;
    _55 = -0.0021590073592960835f;
    _56 = -0.0454593189060688f;
    _57 = 1.0476183891296387f;
  }
  float _70 = (exp2((((LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _71 = (exp2((((LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _72 = (exp2(((float((uint)SV_DispatchThreadID.z) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _99 = (bIsTemperatureWhiteBalance != 0);
  float _103 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _120 = (((((2967800.0f - (_103 * 4607000064.0f)) * _103) + 99.11000061035156f) * _103) + 0.24406300485134125f);
  } else {
    _120 = (((((1901800.0f - (_103 * 2006400000.0f)) * _103) + 247.47999572753906f) * _103) + 0.23703999817371368f);
  }
  float _134 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _141 = WhiteTemp * WhiteTemp;
  float _144 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_141 * 1.6145605741257896e-07f));
  float _149 = ((_134 * 2.0f) + 4.0f) - (_144 * 8.0f);
  float _150 = (_134 * 3.0f) / _149;
  float _152 = (_144 * 2.0f) / _149;
  bool _153 = (WhiteTemp < 4000.0f);
  float _162 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _164 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_141 * 1.5317699909210205f)) / (_162 * _162);
  float _171 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _141;
  float _173 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_141 * 308.60699462890625f)) / (_171 * _171);
  float _175 = rsqrt(dot(float2(_164, _173), float2(_164, _173)));
  float _176 = WhiteTint * 0.05000000074505806f;
  float _179 = ((_176 * _173) * _175) + _134;
  float _182 = _144 - ((_176 * _164) * _175);
  float _187 = (4.0f - (_182 * 8.0f)) + (_179 * 2.0f);
  float _193 = (((_179 * 3.0f) / _187) - _150) + select(_153, _150, _120);
  float _194 = (((_182 * 2.0f) / _187) - _152) + select(_153, _152, (((_120 * 2.869999885559082f) + -0.2750000059604645f) - ((_120 * _120) * 3.0f)));
  float _195 = select(_99, _193, 0.3127000033855438f);
  float _196 = select(_99, _194, 0.32899999618530273f);
  float _197 = select(_99, 0.3127000033855438f, _193);
  float _198 = select(_99, 0.32899999618530273f, _194);
  float _199 = max(_196, 1.000000013351432e-10f);
  float _200 = _195 / _199;
  float _203 = ((1.0f - _195) - _196) / _199;
  float _204 = max(_198, 1.000000013351432e-10f);
  float _205 = _197 / _204;
  float _208 = ((1.0f - _197) - _198) / _204;
  float _227 = mad(-0.16140000522136688f, _208, ((_205 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _203, ((_200 * 0.8950999975204468f) + 0.266400009393692f));
  float _228 = mad(0.03669999912381172f, _208, (1.7135000228881836f - (_205 * 0.7501999735832214f))) / mad(0.03669999912381172f, _203, (1.7135000228881836f - (_200 * 0.7501999735832214f)));
  float _229 = mad(1.0296000242233276f, _208, ((_205 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _203, ((_200 * 0.03889999911189079f) + -0.06849999725818634f));
  float _230 = mad(_228, -0.7501999735832214f, 0.0f);
  float _231 = mad(_228, 1.7135000228881836f, 0.0f);
  float _232 = mad(_228, 0.03669999912381172f, -0.0f);
  float _233 = mad(_229, 0.03889999911189079f, 0.0f);
  float _234 = mad(_229, -0.06849999725818634f, 0.0f);
  float _235 = mad(_229, 1.0296000242233276f, 0.0f);
  float _238 = mad(0.1599626988172531f, _233, mad(-0.1470542997121811f, _230, (_227 * 0.883457362651825f)));
  float _241 = mad(0.1599626988172531f, _234, mad(-0.1470542997121811f, _231, (_227 * 0.26293492317199707f)));
  float _244 = mad(0.1599626988172531f, _235, mad(-0.1470542997121811f, _232, (_227 * -0.15930065512657166f)));
  float _247 = mad(0.04929120093584061f, _233, mad(0.5183603167533875f, _230, (_227 * 0.38695648312568665f)));
  float _250 = mad(0.04929120093584061f, _234, mad(0.5183603167533875f, _231, (_227 * 0.11516613513231277f)));
  float _253 = mad(0.04929120093584061f, _235, mad(0.5183603167533875f, _232, (_227 * -0.0697740763425827f)));
  float _256 = mad(0.9684867262840271f, _233, mad(0.04004279896616936f, _230, (_227 * -0.007634039502590895f)));
  float _259 = mad(0.9684867262840271f, _234, mad(0.04004279896616936f, _231, (_227 * -0.0022720457054674625f)));
  float _262 = mad(0.9684867262840271f, _235, mad(0.04004279896616936f, _232, (_227 * 0.0013765322510153055f)));
  float _265 = mad(_244, (WorkingColorSpace.ToXYZ[2].x), mad(_241, (WorkingColorSpace.ToXYZ[1].x), (_238 * (WorkingColorSpace.ToXYZ[0].x))));
  float _268 = mad(_244, (WorkingColorSpace.ToXYZ[2].y), mad(_241, (WorkingColorSpace.ToXYZ[1].y), (_238 * (WorkingColorSpace.ToXYZ[0].y))));
  float _271 = mad(_244, (WorkingColorSpace.ToXYZ[2].z), mad(_241, (WorkingColorSpace.ToXYZ[1].z), (_238 * (WorkingColorSpace.ToXYZ[0].z))));
  float _274 = mad(_253, (WorkingColorSpace.ToXYZ[2].x), mad(_250, (WorkingColorSpace.ToXYZ[1].x), (_247 * (WorkingColorSpace.ToXYZ[0].x))));
  float _277 = mad(_253, (WorkingColorSpace.ToXYZ[2].y), mad(_250, (WorkingColorSpace.ToXYZ[1].y), (_247 * (WorkingColorSpace.ToXYZ[0].y))));
  float _280 = mad(_253, (WorkingColorSpace.ToXYZ[2].z), mad(_250, (WorkingColorSpace.ToXYZ[1].z), (_247 * (WorkingColorSpace.ToXYZ[0].z))));
  float _283 = mad(_262, (WorkingColorSpace.ToXYZ[2].x), mad(_259, (WorkingColorSpace.ToXYZ[1].x), (_256 * (WorkingColorSpace.ToXYZ[0].x))));
  float _286 = mad(_262, (WorkingColorSpace.ToXYZ[2].y), mad(_259, (WorkingColorSpace.ToXYZ[1].y), (_256 * (WorkingColorSpace.ToXYZ[0].y))));
  float _289 = mad(_262, (WorkingColorSpace.ToXYZ[2].z), mad(_259, (WorkingColorSpace.ToXYZ[1].z), (_256 * (WorkingColorSpace.ToXYZ[0].z))));
  float _319 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _289, mad((WorkingColorSpace.FromXYZ[0].y), _280, (_271 * (WorkingColorSpace.FromXYZ[0].x)))), _72, mad(mad((WorkingColorSpace.FromXYZ[0].z), _286, mad((WorkingColorSpace.FromXYZ[0].y), _277, (_268 * (WorkingColorSpace.FromXYZ[0].x)))), _71, (mad((WorkingColorSpace.FromXYZ[0].z), _283, mad((WorkingColorSpace.FromXYZ[0].y), _274, (_265 * (WorkingColorSpace.FromXYZ[0].x)))) * _70)));
  float _322 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _289, mad((WorkingColorSpace.FromXYZ[1].y), _280, (_271 * (WorkingColorSpace.FromXYZ[1].x)))), _72, mad(mad((WorkingColorSpace.FromXYZ[1].z), _286, mad((WorkingColorSpace.FromXYZ[1].y), _277, (_268 * (WorkingColorSpace.FromXYZ[1].x)))), _71, (mad((WorkingColorSpace.FromXYZ[1].z), _283, mad((WorkingColorSpace.FromXYZ[1].y), _274, (_265 * (WorkingColorSpace.FromXYZ[1].x)))) * _70)));
  float _325 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _289, mad((WorkingColorSpace.FromXYZ[2].y), _280, (_271 * (WorkingColorSpace.FromXYZ[2].x)))), _72, mad(mad((WorkingColorSpace.FromXYZ[2].z), _286, mad((WorkingColorSpace.FromXYZ[2].y), _277, (_268 * (WorkingColorSpace.FromXYZ[2].x)))), _71, (mad((WorkingColorSpace.FromXYZ[2].z), _283, mad((WorkingColorSpace.FromXYZ[2].y), _274, (_265 * (WorkingColorSpace.FromXYZ[2].x)))) * _70)));
  float _340 = mad((WorkingColorSpace.ToAP1[0].z), _325, mad((WorkingColorSpace.ToAP1[0].y), _322, ((WorkingColorSpace.ToAP1[0].x) * _319)));
  float _343 = mad((WorkingColorSpace.ToAP1[1].z), _325, mad((WorkingColorSpace.ToAP1[1].y), _322, ((WorkingColorSpace.ToAP1[1].x) * _319)));
  float _346 = mad((WorkingColorSpace.ToAP1[2].z), _325, mad((WorkingColorSpace.ToAP1[2].y), _322, ((WorkingColorSpace.ToAP1[2].x) * _319)));
  float _347 = dot(float3(_340, _343, _346), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  
  SetUngradedAP1(float3(_340, _343, _346));

  float _351 = (_340 / _347) + -1.0f;
  float _352 = (_343 / _347) + -1.0f;
  float _353 = (_346 / _347) + -1.0f;
  float _365 = (1.0f - exp2(((_347 * _347) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_351, _352, _353), float3(_351, _352, _353)) * -4.0f));
  float _381 = ((mad(-0.06368321925401688f, _346, mad(-0.3292922377586365f, _343, (_340 * 1.3704125881195068f))) - _340) * _365) + _340;
  float _382 = ((mad(-0.010861365124583244f, _346, mad(1.0970927476882935f, _343, (_340 * -0.08343357592821121f))) - _343) * _365) + _343;
  float _383 = ((mad(1.2036951780319214f, _346, mad(-0.09862580895423889f, _343, (_340 * -0.02579331398010254f))) - _346) * _365) + _346;
  float _384 = dot(float3(_381, _382, _383), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _398 = ColorOffset.w + ColorOffsetShadows.w;
  float _412 = ColorGain.w * ColorGainShadows.w;
  float _426 = ColorGamma.w * ColorGammaShadows.w;
  float _440 = ColorContrast.w * ColorContrastShadows.w;
  float _454 = ColorSaturation.w * ColorSaturationShadows.w;
  float _458 = _381 - _384;
  float _459 = _382 - _384;
  float _460 = _383 - _384;
  float _517 = saturate(_384 / ColorCorrectionShadowsMax);
  float _521 = (_517 * _517) * (3.0f - (_517 * 2.0f));
  float _522 = 1.0f - _521;
  float _531 = ColorOffset.w + ColorOffsetHighlights.w;
  float _540 = ColorGain.w * ColorGainHighlights.w;
  float _549 = ColorGamma.w * ColorGammaHighlights.w;
  float _558 = ColorContrast.w * ColorContrastHighlights.w;
  float _567 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _630 = saturate((_384 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _634 = (_630 * _630) * (3.0f - (_630 * 2.0f));
  float _643 = ColorOffset.w + ColorOffsetMidtones.w;
  float _652 = ColorGain.w * ColorGainMidtones.w;
  float _661 = ColorGamma.w * ColorGammaMidtones.w;
  float _670 = ColorContrast.w * ColorContrastMidtones.w;
  float _679 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _737 = _521 - _634;
  float _748 = ((_634 * (((ColorOffset.x + ColorOffsetHighlights.x) + _531) + (((ColorGain.x * ColorGainHighlights.x) * _540) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _558) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _567) * _458) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _549)))))) + (_522 * (((ColorOffset.x + ColorOffsetShadows.x) + _398) + (((ColorGain.x * ColorGainShadows.x) * _412) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _440) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _454) * _458) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _426))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _643) + (((ColorGain.x * ColorGainMidtones.x) * _652) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _670) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _679) * _458) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _661))))) * _737);
  float _750 = ((_634 * (((ColorOffset.y + ColorOffsetHighlights.y) + _531) + (((ColorGain.y * ColorGainHighlights.y) * _540) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _558) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _567) * _459) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _549)))))) + (_522 * (((ColorOffset.y + ColorOffsetShadows.y) + _398) + (((ColorGain.y * ColorGainShadows.y) * _412) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _440) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _454) * _459) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _426))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _643) + (((ColorGain.y * ColorGainMidtones.y) * _652) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _670) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _679) * _459) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _661))))) * _737);
  float _752 = ((_634 * (((ColorOffset.z + ColorOffsetHighlights.z) + _531) + (((ColorGain.z * ColorGainHighlights.z) * _540) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _558) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _567) * _460) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _549)))))) + (_522 * (((ColorOffset.z + ColorOffsetShadows.z) + _398) + (((ColorGain.z * ColorGainShadows.z) * _412) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _440) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _454) * _460) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _426))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _643) + (((ColorGain.z * ColorGainMidtones.z) * _652) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _670) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _679) * _460) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _661))))) * _737);

  SetUntonemappedAP1(float3(_748, _750, _752));

  float _767 = ((mad(0.061360642313957214f, _752, mad(-4.540197551250458e-09f, _750, (_748 * 0.9386394023895264f))) - _748) * BlueCorrection) + _748;
  float _768 = ((mad(0.169205904006958f, _752, mad(0.8307942152023315f, _750, (_748 * 6.775371730327606e-08f))) - _750) * BlueCorrection) + _750;
  float _769 = (mad(-2.3283064365386963e-10f, _750, (_748 * -9.313225746154785e-10f)) * BlueCorrection) + _752;
  float _772 = mad(0.16386905312538147f, _769, mad(0.14067868888378143f, _768, (_767 * 0.6954522132873535f)));
  float _775 = mad(0.0955343246459961f, _769, mad(0.8596711158752441f, _768, (_767 * 0.044794581830501556f)));
  float _778 = mad(1.0015007257461548f, _769, mad(0.004025210160762072f, _768, (_767 * -0.005525882821530104f)));
  float _782 = max(max(_772, _775), _778);
  float _787 = (max(_782, 1.000000013351432e-10f) - max(min(min(_772, _775), _778), 1.000000013351432e-10f)) / max(_782, 0.009999999776482582f);
  float _800 = ((_775 + _772) + _778) + (sqrt((((_778 - _775) * _778) + ((_775 - _772) * _775)) + ((_772 - _778) * _772)) * 1.75f);
  float _801 = _800 * 0.3333333432674408f;
  float _802 = _787 + -0.4000000059604645f;
  float _803 = _802 * 5.0f;
  float _807 = max((1.0f - abs(_802 * 2.5f)), 0.0f);
  float _818 = ((float((int)(((int)(uint)((bool)(_803 > 0.0f))) - ((int)(uint)((bool)(_803 < 0.0f))))) * (1.0f - (_807 * _807))) + 1.0f) * 0.02500000037252903f;
  if (!(_801 <= 0.0533333346247673f)) {
    if (!(_801 >= 0.1599999964237213f)) {
      _827 = (((0.23999999463558197f / _800) + -0.5f) * _818);
    } else {
      _827 = 0.0f;
    }
  } else {
    _827 = _818;
  }
  float _828 = _827 + 1.0f;
  float _829 = _828 * _772;
  float _830 = _828 * _775;
  float _831 = _828 * _778;
  if (!((bool)(_829 == _830) && (bool)(_830 == _831))) {
    float _838 = ((_829 * 2.0f) - _830) - _831;
    float _841 = ((_775 - _778) * 1.7320507764816284f) * _828;
    float _843 = atan(_841 / _838);
    bool _846 = (_838 < 0.0f);
    bool _847 = (_838 == 0.0f);
    bool _848 = (_841 >= 0.0f);
    bool _849 = (_841 < 0.0f);
    _860 = select((_848 && _847), 90.0f, select((_849 && _847), -90.0f, (select((_849 && _846), (_843 + -3.1415927410125732f), select((_848 && _846), (_843 + 3.1415927410125732f), _843)) * 57.2957763671875f)));
  } else {
    _860 = 0.0f;
  }
  float _865 = min(max(select((_860 < 0.0f), (_860 + 360.0f), _860), 0.0f), 360.0f);
  if (_865 < -180.0f) {
    _874 = (_865 + 360.0f);
  } else {
    if (_865 > 180.0f) {
      _874 = (_865 + -360.0f);
    } else {
      _874 = _865;
    }
  }
  float _878 = saturate(1.0f - abs(_874 * 0.014814814552664757f));
  float _882 = (_878 * _878) * (3.0f - (_878 * 2.0f));
  float _888 = ((_882 * _882) * ((_787 * 0.18000000715255737f) * (0.029999999329447746f - _829))) + _829;
  float _898 = max(0.0f, mad(-0.21492856740951538f, _831, mad(-0.2365107536315918f, _830, (_888 * 1.4514392614364624f))));
  float _899 = max(0.0f, mad(-0.09967592358589172f, _831, mad(1.17622971534729f, _830, (_888 * -0.07655377686023712f))));
  float _900 = max(0.0f, mad(0.9977163076400757f, _831, mad(-0.006032449658960104f, _830, (_888 * 0.008316148072481155f))));
  float _901 = dot(float3(_898, _899, _900), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _916 = (FilmBlackClip + 1.0f) - FilmToe;
  float _918 = FilmWhiteClip + 1.0f;
  float _920 = _918 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _938 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _929 = (FilmBlackClip + 0.18000000715255737f) / _916;
    _938 = (-0.7447274923324585f - ((log2(_929 / (2.0f - _929)) * 0.3465735912322998f) * (_916 / FilmSlope)));
  }
  float _941 = ((1.0f - FilmToe) / FilmSlope) - _938;
  float _943 = (FilmShoulder / FilmSlope) - _941;
  float _947 = log2(lerp(_901, _898, 0.9599999785423279f)) * 0.3010300099849701f;
  float _948 = log2(lerp(_901, _899, 0.9599999785423279f)) * 0.3010300099849701f;
  float _949 = log2(lerp(_901, _900, 0.9599999785423279f)) * 0.3010300099849701f;
  float _953 = FilmSlope * (_947 + _941);
  float _954 = FilmSlope * (_948 + _941);
  float _955 = FilmSlope * (_949 + _941);
  float _956 = _916 * 2.0f;
  float _958 = (FilmSlope * -2.0f) / _916;
  float _959 = _947 - _938;
  float _960 = _948 - _938;
  float _961 = _949 - _938;
  float _980 = _920 * 2.0f;
  float _982 = (FilmSlope * 2.0f) / _920;
  float _1007 = select((_947 < _938), ((_956 / (exp2((_959 * 1.4426950216293335f) * _958) + 1.0f)) - FilmBlackClip), _953);
  float _1008 = select((_948 < _938), ((_956 / (exp2((_960 * 1.4426950216293335f) * _958) + 1.0f)) - FilmBlackClip), _954);
  float _1009 = select((_949 < _938), ((_956 / (exp2((_961 * 1.4426950216293335f) * _958) + 1.0f)) - FilmBlackClip), _955);
  float _1016 = _943 - _938;
  float _1020 = saturate(_959 / _1016);
  float _1021 = saturate(_960 / _1016);
  float _1022 = saturate(_961 / _1016);
  bool _1023 = (_943 < _938);
  float _1027 = select(_1023, (1.0f - _1020), _1020);
  float _1028 = select(_1023, (1.0f - _1021), _1021);
  float _1029 = select(_1023, (1.0f - _1022), _1022);
  float _1048 = (((_1027 * _1027) * (select((_947 > _943), (_918 - (_980 / (exp2(((_947 - _943) * 1.4426950216293335f) * _982) + 1.0f))), _953) - _1007)) * (3.0f - (_1027 * 2.0f))) + _1007;
  float _1049 = (((_1028 * _1028) * (select((_948 > _943), (_918 - (_980 / (exp2(((_948 - _943) * 1.4426950216293335f) * _982) + 1.0f))), _954) - _1008)) * (3.0f - (_1028 * 2.0f))) + _1008;
  float _1050 = (((_1029 * _1029) * (select((_949 > _943), (_918 - (_980 / (exp2(((_949 - _943) * 1.4426950216293335f) * _982) + 1.0f))), _955) - _1009)) * (3.0f - (_1029 * 2.0f))) + _1009;
  float _1051 = dot(float3(_1048, _1049, _1050), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1071 = (ToneCurveAmount * (max(0.0f, (lerp(_1051, _1048, 0.9300000071525574f))) - _767)) + _767;
  float _1072 = (ToneCurveAmount * (max(0.0f, (lerp(_1051, _1049, 0.9300000071525574f))) - _768)) + _768;
  float _1073 = (ToneCurveAmount * (max(0.0f, (lerp(_1051, _1050, 0.9300000071525574f))) - _769)) + _769;
  float _1089 = ((mad(-0.06537103652954102f, _1073, mad(1.451815478503704e-06f, _1072, (_1071 * 1.065374732017517f))) - _1071) * BlueCorrection) + _1071;
  float _1090 = ((mad(-0.20366770029067993f, _1073, mad(1.2036634683609009f, _1072, (_1071 * -2.57161445915699e-07f))) - _1072) * BlueCorrection) + _1072;
  float _1091 = ((mad(0.9999996423721313f, _1073, mad(2.0954757928848267e-08f, _1072, (_1071 * 1.862645149230957e-08f))) - _1073) * BlueCorrection) + _1073;
  
  SetTonemappedAP1(_1089, _1090, _1091);

  float _1113 = max(0.0f, mad((WorkingColorSpace.FromAP1[0].z), _1091, mad((WorkingColorSpace.FromAP1[0].y), _1090, ((WorkingColorSpace.FromAP1[0].x) * _1089))));
  float _1114 = max(0.0f, mad((WorkingColorSpace.FromAP1[1].z), _1091, mad((WorkingColorSpace.FromAP1[1].y), _1090, ((WorkingColorSpace.FromAP1[1].x) * _1089))));
  float _1115 = max(0.0f, mad((WorkingColorSpace.FromAP1[2].z), _1091, mad((WorkingColorSpace.FromAP1[2].y), _1090, ((WorkingColorSpace.FromAP1[2].x) * _1089))));
  float _1141 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1113)) * _1113) + MappingPolynomial.z);
  float _1142 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1114)) * _1114) + MappingPolynomial.z);
  float _1143 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1115)) * _1115) + MappingPolynomial.z);
  float _1164 = exp2(log2(max(0.0f, (lerp(_1141, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1165 = exp2(log2(max(0.0f, (lerp(_1142, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1166 = exp2(log2(max(0.0f, (lerp(_1143, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);
  
  if (RENODX_TONE_MAP_TYPE != 0) {
    // return GenerateOutput(float3(_123, _456, _789));
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = GenerateOutput(float3(_1164, _1165, _1166), OutputDevice);
    return;
  }

  if (WorkingColorSpace.bIsSRGB == 0) {
    float _1173 = mad((WorkingColorSpace.ToAP1[0].z), _1166, mad((WorkingColorSpace.ToAP1[0].y), _1165, ((WorkingColorSpace.ToAP1[0].x) * _1164)));
    float _1176 = mad((WorkingColorSpace.ToAP1[1].z), _1166, mad((WorkingColorSpace.ToAP1[1].y), _1165, ((WorkingColorSpace.ToAP1[1].x) * _1164)));
    float _1179 = mad((WorkingColorSpace.ToAP1[2].z), _1166, mad((WorkingColorSpace.ToAP1[2].y), _1165, ((WorkingColorSpace.ToAP1[2].x) * _1164)));
    _1190 = mad(_51, _1179, mad(_50, _1176, (_1173 * _49)));
    _1191 = mad(_54, _1179, mad(_53, _1176, (_1173 * _52)));
    _1192 = mad(_57, _1179, mad(_56, _1176, (_1173 * _55)));
  } else {
    _1190 = _1164;
    _1191 = _1165;
    _1192 = _1166;
  }
  if (_1190 < 0.0031306699384003878f) {
    _1203 = (_1190 * 12.920000076293945f);
  } else {
    _1203 = (((pow(_1190, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1191 < 0.0031306699384003878f) {
    _1214 = (_1191 * 12.920000076293945f);
  } else {
    _1214 = (((pow(_1191, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1192 < 0.0031306699384003878f) {
    _1225 = (_1192 * 12.920000076293945f);
  } else {
    _1225 = (((pow(_1192, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1203 * 0.9523810148239136f), (_1214 * 0.9523810148239136f), (_1225 * 0.9523810148239136f), 0.0f);
}

#include "../common.hlsl"

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

Texture2D<float4> Textures_3 : register(t2);

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
  float2 OutputExtentInverse : packoffset(c042.x);
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

SamplerState Samplers_3 : register(s2);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _26 = 0.5f / LUTSize;
  float _31 = LUTSize + -1.0f;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _126;
  float _833;
  float _866;
  float _880;
  float _944;
  float _1135;
  float _1146;
  float _1157;
  float _1352;
  float _1353;
  float _1354;
  float _1365;
  float _1376;
  float _1387;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _44 = ((uint)(OutputGamut) == 4);
        _55 = select(_44, 1.0f, 1.705051064491272f);
        _56 = select(_44, 0.0f, -0.6217921376228333f);
        _57 = select(_44, 0.0f, -0.0832589864730835f);
        _58 = select(_44, 0.0f, -0.13025647401809692f);
        _59 = select(_44, 1.0f, 1.140804648399353f);
        _60 = select(_44, 0.0f, -0.010548308491706848f);
        _61 = select(_44, 0.0f, -0.024003351107239723f);
        _62 = select(_44, 0.0f, -0.1289689838886261f);
        _63 = select(_44, 1.0f, 1.1529725790023804f);
      } else {
        _55 = 0.6954522132873535f;
        _56 = 0.14067870378494263f;
        _57 = 0.16386906802654266f;
        _58 = 0.044794563204050064f;
        _59 = 0.8596711158752441f;
        _60 = 0.0955343171954155f;
        _61 = -0.005525882821530104f;
        _62 = 0.004025210160762072f;
        _63 = 1.0015007257461548f;
      }
    } else {
      _55 = 1.0258246660232544f;
      _56 = -0.020053181797266006f;
      _57 = -0.005771636962890625f;
      _58 = -0.002234415616840124f;
      _59 = 1.0045864582061768f;
      _60 = -0.002352118492126465f;
      _61 = -0.005013350863009691f;
      _62 = -0.025290070101618767f;
      _63 = 1.0303035974502563f;
    }
  } else {
    _55 = 1.3792141675949097f;
    _56 = -0.30886411666870117f;
    _57 = -0.0703500509262085f;
    _58 = -0.06933490186929703f;
    _59 = 1.08229660987854f;
    _60 = -0.012961871922016144f;
    _61 = -0.0021590073592960835f;
    _62 = -0.0454593189060688f;
    _63 = 1.0476183891296387f;
  }
  float _76 = (exp2((((LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _26)) / _31) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _77 = (exp2((((LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _26)) / _31) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _78 = (exp2(((float((uint)SV_DispatchThreadID.z) / _31) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _105 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _109 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _126 = (((((2967800.0f - (_109 * 4607000064.0f)) * _109) + 99.11000061035156f) * _109) + 0.24406300485134125f);
  } else {
    _126 = (((((1901800.0f - (_109 * 2006400000.0f)) * _109) + 247.47999572753906f) * _109) + 0.23703999817371368f);
  }
  float _140 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _147 = WhiteTemp * WhiteTemp;
  float _150 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_147 * 1.6145605741257896e-07f));
  float _155 = ((_140 * 2.0f) + 4.0f) - (_150 * 8.0f);
  float _156 = (_140 * 3.0f) / _155;
  float _158 = (_150 * 2.0f) / _155;
  bool _159 = (WhiteTemp < 4000.0f);
  float _168 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _170 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_147 * 1.5317699909210205f)) / (_168 * _168);
  float _177 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _147;
  float _179 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_147 * 308.60699462890625f)) / (_177 * _177);
  float _181 = rsqrt(dot(float2(_170, _179), float2(_170, _179)));
  float _182 = WhiteTint * 0.05000000074505806f;
  float _185 = ((_182 * _179) * _181) + _140;
  float _188 = _150 - ((_182 * _170) * _181);
  float _193 = (4.0f - (_188 * 8.0f)) + (_185 * 2.0f);
  float _199 = (((_185 * 3.0f) / _193) - _156) + select(_159, _156, _126);
  float _200 = (((_188 * 2.0f) / _193) - _158) + select(_159, _158, (((_126 * 2.869999885559082f) + -0.2750000059604645f) - ((_126 * _126) * 3.0f)));
  float _201 = select(_105, _199, 0.3127000033855438f);
  float _202 = select(_105, _200, 0.32899999618530273f);
  float _203 = select(_105, 0.3127000033855438f, _199);
  float _204 = select(_105, 0.32899999618530273f, _200);
  float _205 = max(_202, 1.000000013351432e-10f);
  float _206 = _201 / _205;
  float _209 = ((1.0f - _201) - _202) / _205;
  float _210 = max(_204, 1.000000013351432e-10f);
  float _211 = _203 / _210;
  float _214 = ((1.0f - _203) - _204) / _210;
  float _233 = mad(-0.16140000522136688f, _214, ((_211 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _209, ((_206 * 0.8950999975204468f) + 0.266400009393692f));
  float _234 = mad(0.03669999912381172f, _214, (1.7135000228881836f - (_211 * 0.7501999735832214f))) / mad(0.03669999912381172f, _209, (1.7135000228881836f - (_206 * 0.7501999735832214f)));
  float _235 = mad(1.0296000242233276f, _214, ((_211 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _209, ((_206 * 0.03889999911189079f) + -0.06849999725818634f));
  float _236 = mad(_234, -0.7501999735832214f, 0.0f);
  float _237 = mad(_234, 1.7135000228881836f, 0.0f);
  float _238 = mad(_234, 0.03669999912381172f, -0.0f);
  float _239 = mad(_235, 0.03889999911189079f, 0.0f);
  float _240 = mad(_235, -0.06849999725818634f, 0.0f);
  float _241 = mad(_235, 1.0296000242233276f, 0.0f);
  float _244 = mad(0.1599626988172531f, _239, mad(-0.1470542997121811f, _236, (_233 * 0.883457362651825f)));
  float _247 = mad(0.1599626988172531f, _240, mad(-0.1470542997121811f, _237, (_233 * 0.26293492317199707f)));
  float _250 = mad(0.1599626988172531f, _241, mad(-0.1470542997121811f, _238, (_233 * -0.15930065512657166f)));
  float _253 = mad(0.04929120093584061f, _239, mad(0.5183603167533875f, _236, (_233 * 0.38695648312568665f)));
  float _256 = mad(0.04929120093584061f, _240, mad(0.5183603167533875f, _237, (_233 * 0.11516613513231277f)));
  float _259 = mad(0.04929120093584061f, _241, mad(0.5183603167533875f, _238, (_233 * -0.0697740763425827f)));
  float _262 = mad(0.9684867262840271f, _239, mad(0.04004279896616936f, _236, (_233 * -0.007634039502590895f)));
  float _265 = mad(0.9684867262840271f, _240, mad(0.04004279896616936f, _237, (_233 * -0.0022720457054674625f)));
  float _268 = mad(0.9684867262840271f, _241, mad(0.04004279896616936f, _238, (_233 * 0.0013765322510153055f)));
  float _271 = mad(_250, (WorkingColorSpace_ToXYZ[2].x), mad(_247, (WorkingColorSpace_ToXYZ[1].x), (_244 * (WorkingColorSpace_ToXYZ[0].x))));
  float _274 = mad(_250, (WorkingColorSpace_ToXYZ[2].y), mad(_247, (WorkingColorSpace_ToXYZ[1].y), (_244 * (WorkingColorSpace_ToXYZ[0].y))));
  float _277 = mad(_250, (WorkingColorSpace_ToXYZ[2].z), mad(_247, (WorkingColorSpace_ToXYZ[1].z), (_244 * (WorkingColorSpace_ToXYZ[0].z))));
  float _280 = mad(_259, (WorkingColorSpace_ToXYZ[2].x), mad(_256, (WorkingColorSpace_ToXYZ[1].x), (_253 * (WorkingColorSpace_ToXYZ[0].x))));
  float _283 = mad(_259, (WorkingColorSpace_ToXYZ[2].y), mad(_256, (WorkingColorSpace_ToXYZ[1].y), (_253 * (WorkingColorSpace_ToXYZ[0].y))));
  float _286 = mad(_259, (WorkingColorSpace_ToXYZ[2].z), mad(_256, (WorkingColorSpace_ToXYZ[1].z), (_253 * (WorkingColorSpace_ToXYZ[0].z))));
  float _289 = mad(_268, (WorkingColorSpace_ToXYZ[2].x), mad(_265, (WorkingColorSpace_ToXYZ[1].x), (_262 * (WorkingColorSpace_ToXYZ[0].x))));
  float _292 = mad(_268, (WorkingColorSpace_ToXYZ[2].y), mad(_265, (WorkingColorSpace_ToXYZ[1].y), (_262 * (WorkingColorSpace_ToXYZ[0].y))));
  float _295 = mad(_268, (WorkingColorSpace_ToXYZ[2].z), mad(_265, (WorkingColorSpace_ToXYZ[1].z), (_262 * (WorkingColorSpace_ToXYZ[0].z))));
  float _325 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _295, mad((WorkingColorSpace_FromXYZ[0].y), _286, (_277 * (WorkingColorSpace_FromXYZ[0].x)))), _78, mad(mad((WorkingColorSpace_FromXYZ[0].z), _292, mad((WorkingColorSpace_FromXYZ[0].y), _283, (_274 * (WorkingColorSpace_FromXYZ[0].x)))), _77, (mad((WorkingColorSpace_FromXYZ[0].z), _289, mad((WorkingColorSpace_FromXYZ[0].y), _280, (_271 * (WorkingColorSpace_FromXYZ[0].x)))) * _76)));
  float _328 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _295, mad((WorkingColorSpace_FromXYZ[1].y), _286, (_277 * (WorkingColorSpace_FromXYZ[1].x)))), _78, mad(mad((WorkingColorSpace_FromXYZ[1].z), _292, mad((WorkingColorSpace_FromXYZ[1].y), _283, (_274 * (WorkingColorSpace_FromXYZ[1].x)))), _77, (mad((WorkingColorSpace_FromXYZ[1].z), _289, mad((WorkingColorSpace_FromXYZ[1].y), _280, (_271 * (WorkingColorSpace_FromXYZ[1].x)))) * _76)));
  float _331 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _295, mad((WorkingColorSpace_FromXYZ[2].y), _286, (_277 * (WorkingColorSpace_FromXYZ[2].x)))), _78, mad(mad((WorkingColorSpace_FromXYZ[2].z), _292, mad((WorkingColorSpace_FromXYZ[2].y), _283, (_274 * (WorkingColorSpace_FromXYZ[2].x)))), _77, (mad((WorkingColorSpace_FromXYZ[2].z), _289, mad((WorkingColorSpace_FromXYZ[2].y), _280, (_271 * (WorkingColorSpace_FromXYZ[2].x)))) * _76)));
  float _346 = mad((WorkingColorSpace_ToAP1[0].z), _331, mad((WorkingColorSpace_ToAP1[0].y), _328, ((WorkingColorSpace_ToAP1[0].x) * _325)));
  float _349 = mad((WorkingColorSpace_ToAP1[1].z), _331, mad((WorkingColorSpace_ToAP1[1].y), _328, ((WorkingColorSpace_ToAP1[1].x) * _325)));
  float _352 = mad((WorkingColorSpace_ToAP1[2].z), _331, mad((WorkingColorSpace_ToAP1[2].y), _328, ((WorkingColorSpace_ToAP1[2].x) * _325)));
  float _353 = dot(float3(_346, _349, _352), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_346, _349, _352));

  float _357 = (_346 / _353) + -1.0f;
  float _358 = (_349 / _353) + -1.0f;
  float _359 = (_352 / _353) + -1.0f;
  float _371 = (1.0f - exp2(((_353 * _353) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_357, _358, _359), float3(_357, _358, _359)) * -4.0f));
  float _387 = ((mad(-0.06368321925401688f, _352, mad(-0.3292922377586365f, _349, (_346 * 1.3704125881195068f))) - _346) * _371) + _346;
  float _388 = ((mad(-0.010861365124583244f, _352, mad(1.0970927476882935f, _349, (_346 * -0.08343357592821121f))) - _349) * _371) + _349;
  float _389 = ((mad(1.2036951780319214f, _352, mad(-0.09862580895423889f, _349, (_346 * -0.02579331398010254f))) - _352) * _371) + _352;
  float _390 = dot(float3(_387, _388, _389), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _404 = ColorOffset.w + ColorOffsetShadows.w;
  float _418 = ColorGain.w * ColorGainShadows.w;
  float _432 = ColorGamma.w * ColorGammaShadows.w;
  float _446 = ColorContrast.w * ColorContrastShadows.w;
  float _460 = ColorSaturation.w * ColorSaturationShadows.w;
  float _464 = _387 - _390;
  float _465 = _388 - _390;
  float _466 = _389 - _390;
  float _523 = saturate(_390 / ColorCorrectionShadowsMax);
  float _527 = (_523 * _523) * (3.0f - (_523 * 2.0f));
  float _528 = 1.0f - _527;
  float _537 = ColorOffset.w + ColorOffsetHighlights.w;
  float _546 = ColorGain.w * ColorGainHighlights.w;
  float _555 = ColorGamma.w * ColorGammaHighlights.w;
  float _564 = ColorContrast.w * ColorContrastHighlights.w;
  float _573 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _636 = saturate((_390 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _640 = (_636 * _636) * (3.0f - (_636 * 2.0f));
  float _649 = ColorOffset.w + ColorOffsetMidtones.w;
  float _658 = ColorGain.w * ColorGainMidtones.w;
  float _667 = ColorGamma.w * ColorGammaMidtones.w;
  float _676 = ColorContrast.w * ColorContrastMidtones.w;
  float _685 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _743 = _527 - _640;
  float _754 = ((_640 * (((ColorOffset.x + ColorOffsetHighlights.x) + _537) + (((ColorGain.x * ColorGainHighlights.x) * _546) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _564) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _573) * _464) + _390)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _555)))))) + (_528 * (((ColorOffset.x + ColorOffsetShadows.x) + _404) + (((ColorGain.x * ColorGainShadows.x) * _418) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _446) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _460) * _464) + _390)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _432))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _649) + (((ColorGain.x * ColorGainMidtones.x) * _658) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _676) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _685) * _464) + _390)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _667))))) * _743);
  float _756 = ((_640 * (((ColorOffset.y + ColorOffsetHighlights.y) + _537) + (((ColorGain.y * ColorGainHighlights.y) * _546) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _564) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _573) * _465) + _390)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _555)))))) + (_528 * (((ColorOffset.y + ColorOffsetShadows.y) + _404) + (((ColorGain.y * ColorGainShadows.y) * _418) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _446) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _460) * _465) + _390)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _432))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _649) + (((ColorGain.y * ColorGainMidtones.y) * _658) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _676) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _685) * _465) + _390)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _667))))) * _743);
  float _758 = ((_640 * (((ColorOffset.z + ColorOffsetHighlights.z) + _537) + (((ColorGain.z * ColorGainHighlights.z) * _546) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _564) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _573) * _466) + _390)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _555)))))) + (_528 * (((ColorOffset.z + ColorOffsetShadows.z) + _404) + (((ColorGain.z * ColorGainShadows.z) * _418) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _446) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _460) * _466) + _390)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _432))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _649) + (((ColorGain.z * ColorGainMidtones.z) * _658) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _676) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _685) * _466) + _390)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _667))))) * _743);

  SetUntonemappedAP1(float3(_754, _756, _758));

  float _773 = ((mad(0.061360642313957214f, _758, mad(-4.540197551250458e-09f, _756, (_754 * 0.9386394023895264f))) - _754) * BlueCorrection) + _754;
  float _774 = ((mad(0.169205904006958f, _758, mad(0.8307942152023315f, _756, (_754 * 6.775371730327606e-08f))) - _756) * BlueCorrection) + _756;
  float _775 = (mad(-2.3283064365386963e-10f, _756, (_754 * -9.313225746154785e-10f)) * BlueCorrection) + _758;
  float _778 = mad(0.16386905312538147f, _775, mad(0.14067868888378143f, _774, (_773 * 0.6954522132873535f)));
  float _781 = mad(0.0955343246459961f, _775, mad(0.8596711158752441f, _774, (_773 * 0.044794581830501556f)));
  float _784 = mad(1.0015007257461548f, _775, mad(0.004025210160762072f, _774, (_773 * -0.005525882821530104f)));
  float _788 = max(max(_778, _781), _784);
  float _793 = (max(_788, 1.000000013351432e-10f) - max(min(min(_778, _781), _784), 1.000000013351432e-10f)) / max(_788, 0.009999999776482582f);
  float _806 = ((_781 + _778) + _784) + (sqrt((((_784 - _781) * _784) + ((_781 - _778) * _781)) + ((_778 - _784) * _778)) * 1.75f);
  float _807 = _806 * 0.3333333432674408f;
  float _808 = _793 + -0.4000000059604645f;
  float _809 = _808 * 5.0f;
  float _813 = max((1.0f - abs(_808 * 2.5f)), 0.0f);
  float _824 = ((float(((int)(uint)((bool)(_809 > 0.0f))) - ((int)(uint)((bool)(_809 < 0.0f)))) * (1.0f - (_813 * _813))) + 1.0f) * 0.02500000037252903f;
  if (!(_807 <= 0.0533333346247673f)) {
    if (!(_807 >= 0.1599999964237213f)) {
      _833 = (((0.23999999463558197f / _806) + -0.5f) * _824);
    } else {
      _833 = 0.0f;
    }
  } else {
    _833 = _824;
  }
  float _834 = _833 + 1.0f;
  float _835 = _834 * _778;
  float _836 = _834 * _781;
  float _837 = _834 * _784;
  if (!((bool)(_835 == _836) && (bool)(_836 == _837))) {
    float _844 = ((_835 * 2.0f) - _836) - _837;
    float _847 = ((_781 - _784) * 1.7320507764816284f) * _834;
    float _849 = atan(_847 / _844);
    bool _852 = (_844 < 0.0f);
    bool _853 = (_844 == 0.0f);
    bool _854 = (_847 >= 0.0f);
    bool _855 = (_847 < 0.0f);
    _866 = select((_854 && _853), 90.0f, select((_855 && _853), -90.0f, (select((_855 && _852), (_849 + -3.1415927410125732f), select((_854 && _852), (_849 + 3.1415927410125732f), _849)) * 57.2957763671875f)));
  } else {
    _866 = 0.0f;
  }
  float _871 = min(max(select((_866 < 0.0f), (_866 + 360.0f), _866), 0.0f), 360.0f);
  if (_871 < -180.0f) {
    _880 = (_871 + 360.0f);
  } else {
    if (_871 > 180.0f) {
      _880 = (_871 + -360.0f);
    } else {
      _880 = _871;
    }
  }
  float _884 = saturate(1.0f - abs(_880 * 0.014814814552664757f));
  float _888 = (_884 * _884) * (3.0f - (_884 * 2.0f));
  float _894 = ((_888 * _888) * ((_793 * 0.18000000715255737f) * (0.029999999329447746f - _835))) + _835;
  float _904 = max(0.0f, mad(-0.21492856740951538f, _837, mad(-0.2365107536315918f, _836, (_894 * 1.4514392614364624f))));
  float _905 = max(0.0f, mad(-0.09967592358589172f, _837, mad(1.17622971534729f, _836, (_894 * -0.07655377686023712f))));
  float _906 = max(0.0f, mad(0.9977163076400757f, _837, mad(-0.006032449658960104f, _836, (_894 * 0.008316148072481155f))));
  float _907 = dot(float3(_904, _905, _906), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _922 = (FilmBlackClip + 1.0f) - FilmToe;
  float _924 = FilmWhiteClip + 1.0f;
  float _926 = _924 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _944 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _935 = (FilmBlackClip + 0.18000000715255737f) / _922;
    _944 = (-0.7447274923324585f - ((log2(_935 / (2.0f - _935)) * 0.3465735912322998f) * (_922 / FilmSlope)));
  }
  float _947 = ((1.0f - FilmToe) / FilmSlope) - _944;
  float _949 = (FilmShoulder / FilmSlope) - _947;
  float _953 = log2(lerp(_907, _904, 0.9599999785423279f)) * 0.3010300099849701f;
  float _954 = log2(lerp(_907, _905, 0.9599999785423279f)) * 0.3010300099849701f;
  float _955 = log2(lerp(_907, _906, 0.9599999785423279f)) * 0.3010300099849701f;
  float _959 = FilmSlope * (_953 + _947);
  float _960 = FilmSlope * (_954 + _947);
  float _961 = FilmSlope * (_955 + _947);
  float _962 = _922 * 2.0f;
  float _964 = (FilmSlope * -2.0f) / _922;
  float _965 = _953 - _944;
  float _966 = _954 - _944;
  float _967 = _955 - _944;
  float _986 = _926 * 2.0f;
  float _988 = (FilmSlope * 2.0f) / _926;
  float _1013 = select((_953 < _944), ((_962 / (exp2((_965 * 1.4426950216293335f) * _964) + 1.0f)) - FilmBlackClip), _959);
  float _1014 = select((_954 < _944), ((_962 / (exp2((_966 * 1.4426950216293335f) * _964) + 1.0f)) - FilmBlackClip), _960);
  float _1015 = select((_955 < _944), ((_962 / (exp2((_967 * 1.4426950216293335f) * _964) + 1.0f)) - FilmBlackClip), _961);
  float _1022 = _949 - _944;
  float _1026 = saturate(_965 / _1022);
  float _1027 = saturate(_966 / _1022);
  float _1028 = saturate(_967 / _1022);
  bool _1029 = (_949 < _944);
  float _1033 = select(_1029, (1.0f - _1026), _1026);
  float _1034 = select(_1029, (1.0f - _1027), _1027);
  float _1035 = select(_1029, (1.0f - _1028), _1028);
  float _1054 = (((_1033 * _1033) * (select((_953 > _949), (_924 - (_986 / (exp2(((_953 - _949) * 1.4426950216293335f) * _988) + 1.0f))), _959) - _1013)) * (3.0f - (_1033 * 2.0f))) + _1013;
  float _1055 = (((_1034 * _1034) * (select((_954 > _949), (_924 - (_986 / (exp2(((_954 - _949) * 1.4426950216293335f) * _988) + 1.0f))), _960) - _1014)) * (3.0f - (_1034 * 2.0f))) + _1014;
  float _1056 = (((_1035 * _1035) * (select((_955 > _949), (_924 - (_986 / (exp2(((_955 - _949) * 1.4426950216293335f) * _988) + 1.0f))), _961) - _1015)) * (3.0f - (_1035 * 2.0f))) + _1015;
  float _1057 = dot(float3(_1054, _1055, _1056), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1077 = (ToneCurveAmount * (max(0.0f, (lerp(_1057, _1054, 0.9300000071525574f))) - _773)) + _773;
  float _1078 = (ToneCurveAmount * (max(0.0f, (lerp(_1057, _1055, 0.9300000071525574f))) - _774)) + _774;
  float _1079 = (ToneCurveAmount * (max(0.0f, (lerp(_1057, _1056, 0.9300000071525574f))) - _775)) + _775;
  float _1095 = ((mad(-0.06537103652954102f, _1079, mad(1.451815478503704e-06f, _1078, (_1077 * 1.065374732017517f))) - _1077) * BlueCorrection) + _1077;
  float _1096 = ((mad(-0.20366770029067993f, _1079, mad(1.2036634683609009f, _1078, (_1077 * -2.57161445915699e-07f))) - _1078) * BlueCorrection) + _1078;
  float _1097 = ((mad(0.9999996423721313f, _1079, mad(2.0954757928848267e-08f, _1078, (_1077 * 1.862645149230957e-08f))) - _1079) * BlueCorrection) + _1079;

  SetTonemappedAP1(_1095, _1096, _1097);

  float _1122 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1097, mad((WorkingColorSpace_FromAP1[0].y), _1096, ((WorkingColorSpace_FromAP1[0].x) * _1095)))));
  float _1123 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1097, mad((WorkingColorSpace_FromAP1[1].y), _1096, ((WorkingColorSpace_FromAP1[1].x) * _1095)))));
  float _1124 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1097, mad((WorkingColorSpace_FromAP1[2].y), _1096, ((WorkingColorSpace_FromAP1[2].x) * _1095)))));
  if (_1122 < 0.0031306699384003878f) {
    _1135 = (_1122 * 12.920000076293945f);
  } else {
    _1135 = (((pow(_1122, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1123 < 0.0031306699384003878f) {
    _1146 = (_1123 * 12.920000076293945f);
  } else {
    _1146 = (((pow(_1123, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1124 < 0.0031306699384003878f) {
    _1157 = (_1124 * 12.920000076293945f);
  } else {
    _1157 = (((pow(_1124, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1161 = (_1146 * 0.9375f) + 0.03125f;
  float _1168 = _1157 * 15.0f;
  float _1169 = floor(_1168);
  float _1170 = _1168 - _1169;
  float _1172 = (_1169 + ((_1135 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1175 = Textures_1.SampleLevel(Samplers_1, float2(_1172, _1161), 0.0f);
  float _1179 = _1172 + 0.0625f;
  float4 _1180 = Textures_1.SampleLevel(Samplers_1, float2(_1179, _1161), 0.0f);
  float4 _1202 = Textures_2.SampleLevel(Samplers_2, float2(_1172, _1161), 0.0f);
  float4 _1206 = Textures_2.SampleLevel(Samplers_2, float2(_1179, _1161), 0.0f);
  float4 _1228 = Textures_3.SampleLevel(Samplers_3, float2(_1172, _1161), 0.0f);
  float4 _1232 = Textures_3.SampleLevel(Samplers_3, float2(_1179, _1161), 0.0f);
  float _1251 = max(6.103519990574569e-05f, (((((lerp(_1175.x, _1180.x, _1170)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1135)) + ((lerp(_1202.x, _1206.x, _1170)) * (LUTWeights[0].z))) + ((lerp(_1228.x, _1232.x, _1170)) * (LUTWeights[0].w))));
  float _1252 = max(6.103519990574569e-05f, (((((lerp(_1175.y, _1180.y, _1170)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1146)) + ((lerp(_1202.y, _1206.y, _1170)) * (LUTWeights[0].z))) + ((lerp(_1228.y, _1232.y, _1170)) * (LUTWeights[0].w))));
  float _1253 = max(6.103519990574569e-05f, (((((lerp(_1175.z, _1180.z, _1170)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1157)) + ((lerp(_1202.z, _1206.z, _1170)) * (LUTWeights[0].z))) + ((lerp(_1228.z, _1232.z, _1170)) * (LUTWeights[0].w))));
  float _1275 = select((_1251 > 0.040449999272823334f), exp2(log2((_1251 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1251 * 0.07739938050508499f));
  float _1276 = select((_1252 > 0.040449999272823334f), exp2(log2((_1252 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1252 * 0.07739938050508499f));
  float _1277 = select((_1253 > 0.040449999272823334f), exp2(log2((_1253 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1253 * 0.07739938050508499f));
  float _1303 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1275)) * _1275) + MappingPolynomial.z);
  float _1304 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1276)) * _1276) + MappingPolynomial.z);
  float _1305 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1277)) * _1277) + MappingPolynomial.z);
  float _1326 = exp2(log2(max(0.0f, (lerp(_1303, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1327 = exp2(log2(max(0.0f, (lerp(_1304, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1328 = exp2(log2(max(0.0f, (lerp(_1305, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (true) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1326, _1327, _1328), OutputDevice);
    return;
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1335 = mad((WorkingColorSpace_ToAP1[0].z), _1328, mad((WorkingColorSpace_ToAP1[0].y), _1327, ((WorkingColorSpace_ToAP1[0].x) * _1326)));
    float _1338 = mad((WorkingColorSpace_ToAP1[1].z), _1328, mad((WorkingColorSpace_ToAP1[1].y), _1327, ((WorkingColorSpace_ToAP1[1].x) * _1326)));
    float _1341 = mad((WorkingColorSpace_ToAP1[2].z), _1328, mad((WorkingColorSpace_ToAP1[2].y), _1327, ((WorkingColorSpace_ToAP1[2].x) * _1326)));
    _1352 = mad(_57, _1341, mad(_56, _1338, (_1335 * _55)));
    _1353 = mad(_60, _1341, mad(_59, _1338, (_1335 * _58)));
    _1354 = mad(_63, _1341, mad(_62, _1338, (_1335 * _61)));
  } else {
    _1352 = _1326;
    _1353 = _1327;
    _1354 = _1328;
  }
  if (_1352 < 0.0031306699384003878f) {
    _1365 = (_1352 * 12.920000076293945f);
  } else {
    _1365 = (((pow(_1352, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1353 < 0.0031306699384003878f) {
    _1376 = (_1353 * 12.920000076293945f);
  } else {
    _1376 = (((pow(_1353, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1354 < 0.0031306699384003878f) {
    _1387 = (_1354 * 12.920000076293945f);
  } else {
    _1387 = (((pow(_1354, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1365 * 0.9523810148239136f), (_1376 * 0.9523810148239136f), (_1387 * 0.9523810148239136f), 0.0f);
}

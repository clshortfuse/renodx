#include "../common.hlsl"

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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _11[6];
  float _12[6];
  float _13[6];
  float _14[6];
  float _26 = 0.5f / LUTSize;
  float _31 = LUTSize + -1.0f;
  float _32 = (LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _26)) / _31;
  float _33 = (LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _26)) / _31;
  float _35 = float((uint)SV_DispatchThreadID.z) / _31;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _121;
  float _122;
  float _123;
  float _171;
  float _899;
  float _932;
  float _946;
  float _1010;
  float _1189;
  float _1200;
  float _1211;
  float _1382;
  float _1383;
  float _1384;
  float _1395;
  float _1406;
  float _1586;
  float _1619;
  float _1633;
  float _1672;
  float _1782;
  float _1856;
  float _1930;
  float _2009;
  float _2010;
  float _2011;
  float _2160;
  float _2193;
  float _2207;
  float _2246;
  float _2356;
  float _2430;
  float _2504;
  float _2583;
  float _2584;
  float _2585;
  float _2762;
  float _2763;
  float _2764;
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
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _74 = (pow(_32, 0.012683313339948654f));
    float _75 = (pow(_33, 0.012683313339948654f));
    float _76 = (pow(_35, 0.012683313339948654f));
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _122 = (exp2(log2(max(0.0f, (_75 + -0.8359375f)) / (18.8515625f - (_75 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _123 = (exp2(log2(max(0.0f, (_76 + -0.8359375f)) / (18.8515625f - (_76 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _121 = ((exp2((_32 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _122 = ((exp2((_33 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _123 = ((exp2((_35 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _150 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _154 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _171 = (((((2967800.0f - (_154 * 4607000064.0f)) * _154) + 99.11000061035156f) * _154) + 0.24406300485134125f);
  } else {
    _171 = (((((1901800.0f - (_154 * 2006400000.0f)) * _154) + 247.47999572753906f) * _154) + 0.23703999817371368f);
  }
  float _185 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _192 = WhiteTemp * WhiteTemp;
  float _195 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_192 * 1.6145605741257896e-07f));
  float _200 = ((_185 * 2.0f) + 4.0f) - (_195 * 8.0f);
  float _201 = (_185 * 3.0f) / _200;
  float _203 = (_195 * 2.0f) / _200;
  bool _204 = (WhiteTemp < 4000.0f);
  float _213 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _215 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_192 * 1.5317699909210205f)) / (_213 * _213);
  float _222 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _192;
  float _224 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_192 * 308.60699462890625f)) / (_222 * _222);
  float _226 = rsqrt(dot(float2(_215, _224), float2(_215, _224)));
  float _227 = WhiteTint * 0.05000000074505806f;
  float _230 = ((_227 * _224) * _226) + _185;
  float _233 = _195 - ((_227 * _215) * _226);
  float _238 = (4.0f - (_233 * 8.0f)) + (_230 * 2.0f);
  float _244 = (((_230 * 3.0f) / _238) - _201) + select(_204, _201, _171);
  float _245 = (((_233 * 2.0f) / _238) - _203) + select(_204, _203, (((_171 * 2.869999885559082f) + -0.2750000059604645f) - ((_171 * _171) * 3.0f)));
  float _246 = select(_150, _244, 0.3127000033855438f);
  float _247 = select(_150, _245, 0.32899999618530273f);
  float _248 = select(_150, 0.3127000033855438f, _244);
  float _249 = select(_150, 0.32899999618530273f, _245);
  float _250 = max(_247, 1.000000013351432e-10f);
  float _251 = _246 / _250;
  float _254 = ((1.0f - _246) - _247) / _250;
  float _255 = max(_249, 1.000000013351432e-10f);
  float _256 = _248 / _255;
  float _259 = ((1.0f - _248) - _249) / _255;
  float _278 = mad(-0.16140000522136688f, _259, ((_256 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _254, ((_251 * 0.8950999975204468f) + 0.266400009393692f));
  float _279 = mad(0.03669999912381172f, _259, (1.7135000228881836f - (_256 * 0.7501999735832214f))) / mad(0.03669999912381172f, _254, (1.7135000228881836f - (_251 * 0.7501999735832214f)));
  float _280 = mad(1.0296000242233276f, _259, ((_256 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _254, ((_251 * 0.03889999911189079f) + -0.06849999725818634f));
  float _281 = mad(_279, -0.7501999735832214f, 0.0f);
  float _282 = mad(_279, 1.7135000228881836f, 0.0f);
  float _283 = mad(_279, 0.03669999912381172f, -0.0f);
  float _284 = mad(_280, 0.03889999911189079f, 0.0f);
  float _285 = mad(_280, -0.06849999725818634f, 0.0f);
  float _286 = mad(_280, 1.0296000242233276f, 0.0f);
  float _289 = mad(0.1599626988172531f, _284, mad(-0.1470542997121811f, _281, (_278 * 0.883457362651825f)));
  float _292 = mad(0.1599626988172531f, _285, mad(-0.1470542997121811f, _282, (_278 * 0.26293492317199707f)));
  float _295 = mad(0.1599626988172531f, _286, mad(-0.1470542997121811f, _283, (_278 * -0.15930065512657166f)));
  float _298 = mad(0.04929120093584061f, _284, mad(0.5183603167533875f, _281, (_278 * 0.38695648312568665f)));
  float _301 = mad(0.04929120093584061f, _285, mad(0.5183603167533875f, _282, (_278 * 0.11516613513231277f)));
  float _304 = mad(0.04929120093584061f, _286, mad(0.5183603167533875f, _283, (_278 * -0.0697740763425827f)));
  float _307 = mad(0.9684867262840271f, _284, mad(0.04004279896616936f, _281, (_278 * -0.007634039502590895f)));
  float _310 = mad(0.9684867262840271f, _285, mad(0.04004279896616936f, _282, (_278 * -0.0022720457054674625f)));
  float _313 = mad(0.9684867262840271f, _286, mad(0.04004279896616936f, _283, (_278 * 0.0013765322510153055f)));
  float _316 = mad(_295, (WorkingColorSpace_ToXYZ[2].x), mad(_292, (WorkingColorSpace_ToXYZ[1].x), (_289 * (WorkingColorSpace_ToXYZ[0].x))));
  float _319 = mad(_295, (WorkingColorSpace_ToXYZ[2].y), mad(_292, (WorkingColorSpace_ToXYZ[1].y), (_289 * (WorkingColorSpace_ToXYZ[0].y))));
  float _322 = mad(_295, (WorkingColorSpace_ToXYZ[2].z), mad(_292, (WorkingColorSpace_ToXYZ[1].z), (_289 * (WorkingColorSpace_ToXYZ[0].z))));
  float _325 = mad(_304, (WorkingColorSpace_ToXYZ[2].x), mad(_301, (WorkingColorSpace_ToXYZ[1].x), (_298 * (WorkingColorSpace_ToXYZ[0].x))));
  float _328 = mad(_304, (WorkingColorSpace_ToXYZ[2].y), mad(_301, (WorkingColorSpace_ToXYZ[1].y), (_298 * (WorkingColorSpace_ToXYZ[0].y))));
  float _331 = mad(_304, (WorkingColorSpace_ToXYZ[2].z), mad(_301, (WorkingColorSpace_ToXYZ[1].z), (_298 * (WorkingColorSpace_ToXYZ[0].z))));
  float _334 = mad(_313, (WorkingColorSpace_ToXYZ[2].x), mad(_310, (WorkingColorSpace_ToXYZ[1].x), (_307 * (WorkingColorSpace_ToXYZ[0].x))));
  float _337 = mad(_313, (WorkingColorSpace_ToXYZ[2].y), mad(_310, (WorkingColorSpace_ToXYZ[1].y), (_307 * (WorkingColorSpace_ToXYZ[0].y))));
  float _340 = mad(_313, (WorkingColorSpace_ToXYZ[2].z), mad(_310, (WorkingColorSpace_ToXYZ[1].z), (_307 * (WorkingColorSpace_ToXYZ[0].z))));
  float _370 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _340, mad((WorkingColorSpace_FromXYZ[0].y), _331, (_322 * (WorkingColorSpace_FromXYZ[0].x)))), _123, mad(mad((WorkingColorSpace_FromXYZ[0].z), _337, mad((WorkingColorSpace_FromXYZ[0].y), _328, (_319 * (WorkingColorSpace_FromXYZ[0].x)))), _122, (mad((WorkingColorSpace_FromXYZ[0].z), _334, mad((WorkingColorSpace_FromXYZ[0].y), _325, (_316 * (WorkingColorSpace_FromXYZ[0].x)))) * _121)));
  float _373 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _340, mad((WorkingColorSpace_FromXYZ[1].y), _331, (_322 * (WorkingColorSpace_FromXYZ[1].x)))), _123, mad(mad((WorkingColorSpace_FromXYZ[1].z), _337, mad((WorkingColorSpace_FromXYZ[1].y), _328, (_319 * (WorkingColorSpace_FromXYZ[1].x)))), _122, (mad((WorkingColorSpace_FromXYZ[1].z), _334, mad((WorkingColorSpace_FromXYZ[1].y), _325, (_316 * (WorkingColorSpace_FromXYZ[1].x)))) * _121)));
  float _376 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _340, mad((WorkingColorSpace_FromXYZ[2].y), _331, (_322 * (WorkingColorSpace_FromXYZ[2].x)))), _123, mad(mad((WorkingColorSpace_FromXYZ[2].z), _337, mad((WorkingColorSpace_FromXYZ[2].y), _328, (_319 * (WorkingColorSpace_FromXYZ[2].x)))), _122, (mad((WorkingColorSpace_FromXYZ[2].z), _334, mad((WorkingColorSpace_FromXYZ[2].y), _325, (_316 * (WorkingColorSpace_FromXYZ[2].x)))) * _121)));
  float _391 = mad((WorkingColorSpace_ToAP1[0].z), _376, mad((WorkingColorSpace_ToAP1[0].y), _373, ((WorkingColorSpace_ToAP1[0].x) * _370)));
  float _394 = mad((WorkingColorSpace_ToAP1[1].z), _376, mad((WorkingColorSpace_ToAP1[1].y), _373, ((WorkingColorSpace_ToAP1[1].x) * _370)));
  float _397 = mad((WorkingColorSpace_ToAP1[2].z), _376, mad((WorkingColorSpace_ToAP1[2].y), _373, ((WorkingColorSpace_ToAP1[2].x) * _370)));
  float _398 = dot(float3(_391, _394, _397), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_391, _394, _397));

  float _402 = (_391 / _398) + -1.0f;
  float _403 = (_394 / _398) + -1.0f;
  float _404 = (_397 / _398) + -1.0f;
  float _416 = (1.0f - exp2(((_398 * _398) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_402, _403, _404), float3(_402, _403, _404)) * -4.0f));
  float _432 = ((mad(-0.06368321925401688f, _397, mad(-0.3292922377586365f, _394, (_391 * 1.3704125881195068f))) - _391) * _416) + _391;
  float _433 = ((mad(-0.010861365124583244f, _397, mad(1.0970927476882935f, _394, (_391 * -0.08343357592821121f))) - _394) * _416) + _394;
  float _434 = ((mad(1.2036951780319214f, _397, mad(-0.09862580895423889f, _394, (_391 * -0.02579331398010254f))) - _397) * _416) + _397;
  float _435 = dot(float3(_432, _433, _434), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _449 = ColorOffset.w + ColorOffsetShadows.w;
  float _463 = ColorGain.w * ColorGainShadows.w;
  float _477 = ColorGamma.w * ColorGammaShadows.w;
  float _491 = ColorContrast.w * ColorContrastShadows.w;
  float _505 = ColorSaturation.w * ColorSaturationShadows.w;
  float _509 = _432 - _435;
  float _510 = _433 - _435;
  float _511 = _434 - _435;
  float _568 = saturate(_435 / ColorCorrectionShadowsMax);
  float _572 = (_568 * _568) * (3.0f - (_568 * 2.0f));
  float _573 = 1.0f - _572;
  float _582 = ColorOffset.w + ColorOffsetHighlights.w;
  float _591 = ColorGain.w * ColorGainHighlights.w;
  float _600 = ColorGamma.w * ColorGammaHighlights.w;
  float _609 = ColorContrast.w * ColorContrastHighlights.w;
  float _618 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _681 = saturate((_435 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _685 = (_681 * _681) * (3.0f - (_681 * 2.0f));
  float _694 = ColorOffset.w + ColorOffsetMidtones.w;
  float _703 = ColorGain.w * ColorGainMidtones.w;
  float _712 = ColorGamma.w * ColorGammaMidtones.w;
  float _721 = ColorContrast.w * ColorContrastMidtones.w;
  float _730 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _788 = _572 - _685;
  float _799 = ((_685 * (((ColorOffset.x + ColorOffsetHighlights.x) + _582) + (((ColorGain.x * ColorGainHighlights.x) * _591) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _609) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _618) * _509) + _435)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _600)))))) + (_573 * (((ColorOffset.x + ColorOffsetShadows.x) + _449) + (((ColorGain.x * ColorGainShadows.x) * _463) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _491) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _505) * _509) + _435)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _477))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _694) + (((ColorGain.x * ColorGainMidtones.x) * _703) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _721) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _730) * _509) + _435)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _712))))) * _788);
  float _801 = ((_685 * (((ColorOffset.y + ColorOffsetHighlights.y) + _582) + (((ColorGain.y * ColorGainHighlights.y) * _591) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _609) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _618) * _510) + _435)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _600)))))) + (_573 * (((ColorOffset.y + ColorOffsetShadows.y) + _449) + (((ColorGain.y * ColorGainShadows.y) * _463) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _491) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _505) * _510) + _435)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _477))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _694) + (((ColorGain.y * ColorGainMidtones.y) * _703) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _721) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _730) * _510) + _435)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _712))))) * _788);
  float _803 = ((_685 * (((ColorOffset.z + ColorOffsetHighlights.z) + _582) + (((ColorGain.z * ColorGainHighlights.z) * _591) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _609) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _618) * _511) + _435)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _600)))))) + (_573 * (((ColorOffset.z + ColorOffsetShadows.z) + _449) + (((ColorGain.z * ColorGainShadows.z) * _463) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _491) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _505) * _511) + _435)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _477))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _694) + (((ColorGain.z * ColorGainMidtones.z) * _703) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _721) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _730) * _511) + _435)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _712))))) * _788);

  SetUntonemappedAP1(float3(_799, _801, _803));

  float _839 = ((mad(0.061360642313957214f, _803, mad(-4.540197551250458e-09f, _801, (_799 * 0.9386394023895264f))) - _799) * BlueCorrection) + _799;
  float _840 = ((mad(0.169205904006958f, _803, mad(0.8307942152023315f, _801, (_799 * 6.775371730327606e-08f))) - _801) * BlueCorrection) + _801;
  float _841 = (mad(-2.3283064365386963e-10f, _801, (_799 * -9.313225746154785e-10f)) * BlueCorrection) + _803;
  float _844 = mad(0.16386905312538147f, _841, mad(0.14067868888378143f, _840, (_839 * 0.6954522132873535f)));
  float _847 = mad(0.0955343246459961f, _841, mad(0.8596711158752441f, _840, (_839 * 0.044794581830501556f)));
  float _850 = mad(1.0015007257461548f, _841, mad(0.004025210160762072f, _840, (_839 * -0.005525882821530104f)));
  float _854 = max(max(_844, _847), _850);
  float _859 = (max(_854, 1.000000013351432e-10f) - max(min(min(_844, _847), _850), 1.000000013351432e-10f)) / max(_854, 0.009999999776482582f);
  float _872 = ((_847 + _844) + _850) + (sqrt((((_850 - _847) * _850) + ((_847 - _844) * _847)) + ((_844 - _850) * _844)) * 1.75f);
  float _873 = _872 * 0.3333333432674408f;
  float _874 = _859 + -0.4000000059604645f;
  float _875 = _874 * 5.0f;
  float _879 = max((1.0f - abs(_874 * 2.5f)), 0.0f);
  float _890 = ((float(((int)(uint)((bool)(_875 > 0.0f))) - ((int)(uint)((bool)(_875 < 0.0f)))) * (1.0f - (_879 * _879))) + 1.0f) * 0.02500000037252903f;
  if (!(_873 <= 0.0533333346247673f)) {
    if (!(_873 >= 0.1599999964237213f)) {
      _899 = (((0.23999999463558197f / _872) + -0.5f) * _890);
    } else {
      _899 = 0.0f;
    }
  } else {
    _899 = _890;
  }
  float _900 = _899 + 1.0f;
  float _901 = _900 * _844;
  float _902 = _900 * _847;
  float _903 = _900 * _850;
  if (!((bool)(_901 == _902) && (bool)(_902 == _903))) {
    float _910 = ((_901 * 2.0f) - _902) - _903;
    float _913 = ((_847 - _850) * 1.7320507764816284f) * _900;
    float _915 = atan(_913 / _910);
    bool _918 = (_910 < 0.0f);
    bool _919 = (_910 == 0.0f);
    bool _920 = (_913 >= 0.0f);
    bool _921 = (_913 < 0.0f);
    _932 = select((_920 && _919), 90.0f, select((_921 && _919), -90.0f, (select((_921 && _918), (_915 + -3.1415927410125732f), select((_920 && _918), (_915 + 3.1415927410125732f), _915)) * 57.2957763671875f)));
  } else {
    _932 = 0.0f;
  }
  float _937 = min(max(select((_932 < 0.0f), (_932 + 360.0f), _932), 0.0f), 360.0f);
  if (_937 < -180.0f) {
    _946 = (_937 + 360.0f);
  } else {
    if (_937 > 180.0f) {
      _946 = (_937 + -360.0f);
    } else {
      _946 = _937;
    }
  }
  float _950 = saturate(1.0f - abs(_946 * 0.014814814552664757f));
  float _954 = (_950 * _950) * (3.0f - (_950 * 2.0f));
  float _960 = ((_954 * _954) * ((_859 * 0.18000000715255737f) * (0.029999999329447746f - _901))) + _901;
  float _970 = max(0.0f, mad(-0.21492856740951538f, _903, mad(-0.2365107536315918f, _902, (_960 * 1.4514392614364624f))));
  float _971 = max(0.0f, mad(-0.09967592358589172f, _903, mad(1.17622971534729f, _902, (_960 * -0.07655377686023712f))));
  float _972 = max(0.0f, mad(0.9977163076400757f, _903, mad(-0.006032449658960104f, _902, (_960 * 0.008316148072481155f))));
  float _973 = dot(float3(_970, _971, _972), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _988 = (FilmBlackClip + 1.0f) - FilmToe;
  float _990 = FilmWhiteClip + 1.0f;
  float _992 = _990 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1010 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _1001 = (FilmBlackClip + 0.18000000715255737f) / _988;
    _1010 = (-0.7447274923324585f - ((log2(_1001 / (2.0f - _1001)) * 0.3465735912322998f) * (_988 / FilmSlope)));
  }
  float _1013 = ((1.0f - FilmToe) / FilmSlope) - _1010;
  float _1015 = (FilmShoulder / FilmSlope) - _1013;
  float _1019 = log2(lerp(_973, _970, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1020 = log2(lerp(_973, _971, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1021 = log2(lerp(_973, _972, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1025 = FilmSlope * (_1019 + _1013);
  float _1026 = FilmSlope * (_1020 + _1013);
  float _1027 = FilmSlope * (_1021 + _1013);
  float _1028 = _988 * 2.0f;
  float _1030 = (FilmSlope * -2.0f) / _988;
  float _1031 = _1019 - _1010;
  float _1032 = _1020 - _1010;
  float _1033 = _1021 - _1010;
  float _1052 = _992 * 2.0f;
  float _1054 = (FilmSlope * 2.0f) / _992;
  float _1079 = select((_1019 < _1010), ((_1028 / (exp2((_1031 * 1.4426950216293335f) * _1030) + 1.0f)) - FilmBlackClip), _1025);
  float _1080 = select((_1020 < _1010), ((_1028 / (exp2((_1032 * 1.4426950216293335f) * _1030) + 1.0f)) - FilmBlackClip), _1026);
  float _1081 = select((_1021 < _1010), ((_1028 / (exp2((_1033 * 1.4426950216293335f) * _1030) + 1.0f)) - FilmBlackClip), _1027);
  float _1088 = _1015 - _1010;
  float _1092 = saturate(_1031 / _1088);
  float _1093 = saturate(_1032 / _1088);
  float _1094 = saturate(_1033 / _1088);
  bool _1095 = (_1015 < _1010);
  float _1099 = select(_1095, (1.0f - _1092), _1092);
  float _1100 = select(_1095, (1.0f - _1093), _1093);
  float _1101 = select(_1095, (1.0f - _1094), _1094);
  float _1120 = (((_1099 * _1099) * (select((_1019 > _1015), (_990 - (_1052 / (exp2(((_1019 - _1015) * 1.4426950216293335f) * _1054) + 1.0f))), _1025) - _1079)) * (3.0f - (_1099 * 2.0f))) + _1079;
  float _1121 = (((_1100 * _1100) * (select((_1020 > _1015), (_990 - (_1052 / (exp2(((_1020 - _1015) * 1.4426950216293335f) * _1054) + 1.0f))), _1026) - _1080)) * (3.0f - (_1100 * 2.0f))) + _1080;
  float _1122 = (((_1101 * _1101) * (select((_1021 > _1015), (_990 - (_1052 / (exp2(((_1021 - _1015) * 1.4426950216293335f) * _1054) + 1.0f))), _1027) - _1081)) * (3.0f - (_1101 * 2.0f))) + _1081;
  float _1123 = dot(float3(_1120, _1121, _1122), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1143 = (ToneCurveAmount * (max(0.0f, (lerp(_1123, _1120, 0.9300000071525574f))) - _839)) + _839;
  float _1144 = (ToneCurveAmount * (max(0.0f, (lerp(_1123, _1121, 0.9300000071525574f))) - _840)) + _840;
  float _1145 = (ToneCurveAmount * (max(0.0f, (lerp(_1123, _1122, 0.9300000071525574f))) - _841)) + _841;
  float _1161 = ((mad(-0.06537103652954102f, _1145, mad(1.451815478503704e-06f, _1144, (_1143 * 1.065374732017517f))) - _1143) * BlueCorrection) + _1143;
  float _1162 = ((mad(-0.20366770029067993f, _1145, mad(1.2036634683609009f, _1144, (_1143 * -2.57161445915699e-07f))) - _1144) * BlueCorrection) + _1144;
  float _1163 = ((mad(0.9999996423721313f, _1145, mad(2.0954757928848267e-08f, _1144, (_1143 * 1.862645149230957e-08f))) - _1145) * BlueCorrection) + _1145;

  SetTonemappedAP1(_1161, _1162, _1163);

  float _1176 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1163, mad((WorkingColorSpace_FromAP1[0].y), _1162, ((WorkingColorSpace_FromAP1[0].x) * _1161)))));
  float _1177 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1163, mad((WorkingColorSpace_FromAP1[1].y), _1162, ((WorkingColorSpace_FromAP1[1].x) * _1161)))));
  float _1178 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1163, mad((WorkingColorSpace_FromAP1[2].y), _1162, ((WorkingColorSpace_FromAP1[2].x) * _1161)))));
  if (_1176 < 0.0031306699384003878f) {
    _1189 = (_1176 * 12.920000076293945f);
  } else {
    _1189 = (((pow(_1176, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1177 < 0.0031306699384003878f) {
    _1200 = (_1177 * 12.920000076293945f);
  } else {
    _1200 = (((pow(_1177, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1178 < 0.0031306699384003878f) {
    _1211 = (_1178 * 12.920000076293945f);
  } else {
    _1211 = (((pow(_1178, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1215 = (_1200 * 0.9375f) + 0.03125f;
  float _1222 = _1211 * 15.0f;
  float _1223 = floor(_1222);
  float _1224 = _1222 - _1223;
  float _1226 = (((_1189 * 0.9375f) + 0.03125f) + _1223) * 0.0625f;
  float4 _1229 = Textures_1.SampleLevel(Samplers_1, float2(_1226, _1215), 0.0f);
  float4 _1234 = Textures_1.SampleLevel(Samplers_1, float2((_1226 + 0.0625f), _1215), 0.0f);
  float _1253 = max(6.103519990574569e-05f, (((lerp(_1229.x, _1234.x, _1224)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1189)));
  float _1254 = max(6.103519990574569e-05f, (((lerp(_1229.y, _1234.y, _1224)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1200)));
  float _1255 = max(6.103519990574569e-05f, (((lerp(_1229.z, _1234.z, _1224)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1211)));
  float _1277 = select((_1253 > 0.040449999272823334f), exp2(log2((_1253 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1253 * 0.07739938050508499f));
  float _1278 = select((_1254 > 0.040449999272823334f), exp2(log2((_1254 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1254 * 0.07739938050508499f));
  float _1279 = select((_1255 > 0.040449999272823334f), exp2(log2((_1255 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1255 * 0.07739938050508499f));
  float _1305 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1277)) * _1277) + MappingPolynomial.z);
  float _1306 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1278)) * _1278) + MappingPolynomial.z);
  float _1307 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1279)) * _1279) + MappingPolynomial.z);
  float _1314 = ((OverlayColor.x - _1305) * OverlayColor.w) + _1305;
  float _1315 = ((OverlayColor.y - _1306) * OverlayColor.w) + _1306;
  float _1316 = ((OverlayColor.z - _1307) * OverlayColor.w) + _1307;
  float _1317 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _803, mad((WorkingColorSpace_FromAP1[0].y), _801, (_799 * (WorkingColorSpace_FromAP1[0].x))));
  float _1318 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _803, mad((WorkingColorSpace_FromAP1[1].y), _801, ((WorkingColorSpace_FromAP1[1].x) * _799)));
  float _1319 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _803, mad((WorkingColorSpace_FromAP1[2].y), _801, ((WorkingColorSpace_FromAP1[2].x) * _799)));
  float _1326 = ((OverlayColor.x - _1317) * OverlayColor.w) + _1317;
  float _1327 = ((OverlayColor.y - _1318) * OverlayColor.w) + _1318;
  float _1328 = ((OverlayColor.z - _1319) * OverlayColor.w) + _1319;
  float _1340 = exp2(log2(max(0.0f, _1314)) * InverseGamma.y);
  float _1341 = exp2(log2(max(0.0f, _1315)) * InverseGamma.y);
  float _1342 = exp2(log2(max(0.0f, _1316)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1340, _1341, _1342), OutputDevice);
    return;
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1365 = mad((WorkingColorSpace_ToAP1[0].z), _1342, mad((WorkingColorSpace_ToAP1[0].y), _1341, ((WorkingColorSpace_ToAP1[0].x) * _1340)));
        float _1368 = mad((WorkingColorSpace_ToAP1[1].z), _1342, mad((WorkingColorSpace_ToAP1[1].y), _1341, ((WorkingColorSpace_ToAP1[1].x) * _1340)));
        float _1371 = mad((WorkingColorSpace_ToAP1[2].z), _1342, mad((WorkingColorSpace_ToAP1[2].y), _1341, ((WorkingColorSpace_ToAP1[2].x) * _1340)));
        _1382 = mad(_57, _1371, mad(_56, _1368, (_1365 * _55)));
        _1383 = mad(_60, _1371, mad(_59, _1368, (_1365 * _58)));
        _1384 = mad(_63, _1371, mad(_62, _1368, (_1365 * _61)));
      } else {
        _1382 = _1340;
        _1383 = _1341;
        _1384 = _1342;
      }
      do {
        if (_1382 < 0.0031306699384003878f) {
          _1395 = (_1382 * 12.920000076293945f);
        } else {
          _1395 = (((pow(_1382, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1383 < 0.0031306699384003878f) {
            _1406 = (_1383 * 12.920000076293945f);
          } else {
            _1406 = (((pow(_1383, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1384 < 0.0031306699384003878f) {
            _2762 = _1395;
            _2763 = _1406;
            _2764 = (_1384 * 12.920000076293945f);
          } else {
            _2762 = _1395;
            _2763 = _1406;
            _2764 = (((pow(_1384, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1433 = mad((WorkingColorSpace_ToAP1[0].z), _1342, mad((WorkingColorSpace_ToAP1[0].y), _1341, ((WorkingColorSpace_ToAP1[0].x) * _1340)));
      float _1436 = mad((WorkingColorSpace_ToAP1[1].z), _1342, mad((WorkingColorSpace_ToAP1[1].y), _1341, ((WorkingColorSpace_ToAP1[1].x) * _1340)));
      float _1439 = mad((WorkingColorSpace_ToAP1[2].z), _1342, mad((WorkingColorSpace_ToAP1[2].y), _1341, ((WorkingColorSpace_ToAP1[2].x) * _1340)));
      float _1449 = max(6.103519990574569e-05f, mad(_57, _1439, mad(_56, _1436, (_1433 * _55))));
      float _1450 = max(6.103519990574569e-05f, mad(_60, _1439, mad(_59, _1436, (_1433 * _58))));
      float _1451 = max(6.103519990574569e-05f, mad(_63, _1439, mad(_62, _1436, (_1433 * _61))));
      _2762 = min((_1449 * 4.5f), ((exp2(log2(max(_1449, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2763 = min((_1450 * 4.5f), ((exp2(log2(max(_1450, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2764 = min((_1451 * 4.5f), ((exp2(log2(max(_1451, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        _13[0] = ACESCoefsLow_0.x;
        _13[1] = ACESCoefsLow_0.y;
        _13[2] = ACESCoefsLow_0.z;
        _13[3] = ACESCoefsLow_0.w;
        _13[4] = ACESCoefsLow_4;
        _13[5] = ACESCoefsLow_4;
        _14[0] = ACESCoefsHigh_0.x;
        _14[1] = ACESCoefsHigh_0.y;
        _14[2] = ACESCoefsHigh_0.z;
        _14[3] = ACESCoefsHigh_0.w;
        _14[4] = ACESCoefsHigh_4;
        _14[5] = ACESCoefsHigh_4;
        float _1526 = ACESSceneColorMultiplier * _1326;
        float _1527 = ACESSceneColorMultiplier * _1327;
        float _1528 = ACESSceneColorMultiplier * _1328;
        float _1531 = mad((WorkingColorSpace_ToAP0[0].z), _1528, mad((WorkingColorSpace_ToAP0[0].y), _1527, ((WorkingColorSpace_ToAP0[0].x) * _1526)));
        float _1534 = mad((WorkingColorSpace_ToAP0[1].z), _1528, mad((WorkingColorSpace_ToAP0[1].y), _1527, ((WorkingColorSpace_ToAP0[1].x) * _1526)));
        float _1537 = mad((WorkingColorSpace_ToAP0[2].z), _1528, mad((WorkingColorSpace_ToAP0[2].y), _1527, ((WorkingColorSpace_ToAP0[2].x) * _1526)));
        float _1541 = max(max(_1531, _1534), _1537);
        float _1546 = (max(_1541, 1.000000013351432e-10f) - max(min(min(_1531, _1534), _1537), 1.000000013351432e-10f)) / max(_1541, 0.009999999776482582f);
        float _1559 = ((_1534 + _1531) + _1537) + (sqrt((((_1537 - _1534) * _1537) + ((_1534 - _1531) * _1534)) + ((_1531 - _1537) * _1531)) * 1.75f);
        float _1560 = _1559 * 0.3333333432674408f;
        float _1561 = _1546 + -0.4000000059604645f;
        float _1562 = _1561 * 5.0f;
        float _1566 = max((1.0f - abs(_1561 * 2.5f)), 0.0f);
        float _1577 = ((float(((int)(uint)((bool)(_1562 > 0.0f))) - ((int)(uint)((bool)(_1562 < 0.0f)))) * (1.0f - (_1566 * _1566))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1560 <= 0.0533333346247673f)) {
            if (!(_1560 >= 0.1599999964237213f)) {
              _1586 = (((0.23999999463558197f / _1559) + -0.5f) * _1577);
            } else {
              _1586 = 0.0f;
            }
          } else {
            _1586 = _1577;
          }
          float _1587 = _1586 + 1.0f;
          float _1588 = _1587 * _1531;
          float _1589 = _1587 * _1534;
          float _1590 = _1587 * _1537;
          do {
            if (!((bool)(_1588 == _1589) && (bool)(_1589 == _1590))) {
              float _1597 = ((_1588 * 2.0f) - _1589) - _1590;
              float _1600 = ((_1534 - _1537) * 1.7320507764816284f) * _1587;
              float _1602 = atan(_1600 / _1597);
              bool _1605 = (_1597 < 0.0f);
              bool _1606 = (_1597 == 0.0f);
              bool _1607 = (_1600 >= 0.0f);
              bool _1608 = (_1600 < 0.0f);
              _1619 = select((_1607 && _1606), 90.0f, select((_1608 && _1606), -90.0f, (select((_1608 && _1605), (_1602 + -3.1415927410125732f), select((_1607 && _1605), (_1602 + 3.1415927410125732f), _1602)) * 57.2957763671875f)));
            } else {
              _1619 = 0.0f;
            }
            float _1624 = min(max(select((_1619 < 0.0f), (_1619 + 360.0f), _1619), 0.0f), 360.0f);
            do {
              if (_1624 < -180.0f) {
                _1633 = (_1624 + 360.0f);
              } else {
                if (_1624 > 180.0f) {
                  _1633 = (_1624 + -360.0f);
                } else {
                  _1633 = _1624;
                }
              }
              do {
                if ((bool)(_1633 > -67.5f) && (bool)(_1633 < 67.5f)) {
                  float _1639 = (_1633 + 67.5f) * 0.029629629105329514f;
                  int _1640 = int(_1639);
                  float _1642 = _1639 - float(_1640);
                  float _1643 = _1642 * _1642;
                  float _1644 = _1643 * _1642;
                  if (_1640 == 3) {
                    _1672 = (((0.1666666716337204f - (_1642 * 0.5f)) + (_1643 * 0.5f)) - (_1644 * 0.1666666716337204f));
                  } else {
                    if (_1640 == 2) {
                      _1672 = ((0.6666666865348816f - _1643) + (_1644 * 0.5f));
                    } else {
                      if (_1640 == 1) {
                        _1672 = (((_1644 * -0.5f) + 0.1666666716337204f) + ((_1643 + _1642) * 0.5f));
                      } else {
                        _1672 = select((_1640 == 0), (_1644 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1672 = 0.0f;
                }
                float _1681 = min(max(((((_1546 * 0.27000001072883606f) * (0.029999999329447746f - _1588)) * _1672) + _1588), 0.0f), 65535.0f);
                float _1682 = min(max(_1589, 0.0f), 65535.0f);
                float _1683 = min(max(_1590, 0.0f), 65535.0f);
                float _1696 = min(max(mad(-0.21492856740951538f, _1683, mad(-0.2365107536315918f, _1682, (_1681 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1697 = min(max(mad(-0.09967592358589172f, _1683, mad(1.17622971534729f, _1682, (_1681 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1698 = min(max(mad(0.9977163076400757f, _1683, mad(-0.006032449658960104f, _1682, (_1681 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1699 = dot(float3(_1696, _1697, _1698), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1710 = log2(max((lerp(_1699, _1696, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1711 = _1710 * 0.3010300099849701f;
                float _1712 = log2(ACESMinMaxData.x);
                float _1713 = _1712 * 0.3010300099849701f;
                do {
                  if (!(!(_1711 <= _1713))) {
                    _1782 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1720 = log2(ACESMidData.x);
                    float _1721 = _1720 * 0.3010300099849701f;
                    if ((bool)(_1711 > _1713) && (bool)(_1711 < _1721)) {
                      float _1729 = ((_1710 - _1712) * 0.9030900001525879f) / ((_1720 - _1712) * 0.3010300099849701f);
                      int _1730 = int(_1729);
                      float _1732 = _1729 - float(_1730);
                      float _1734 = _13[_1730];
                      float _1737 = _13[(_1730 + 1)];
                      float _1742 = _1734 * 0.5f;
                      _1782 = dot(float3((_1732 * _1732), _1732, 1.0f), float3(mad((_13[(_1730 + 2)]), 0.5f, mad(_1737, -1.0f, _1742)), (_1737 - _1734), mad(_1737, 0.5f, _1742)));
                    } else {
                      do {
                        if (!(!(_1711 >= _1721))) {
                          float _1751 = log2(ACESMinMaxData.z);
                          if (_1711 < (_1751 * 0.3010300099849701f)) {
                            float _1759 = ((_1710 - _1720) * 0.9030900001525879f) / ((_1751 - _1720) * 0.3010300099849701f);
                            int _1760 = int(_1759);
                            float _1762 = _1759 - float(_1760);
                            float _1764 = _14[_1760];
                            float _1767 = _14[(_1760 + 1)];
                            float _1772 = _1764 * 0.5f;
                            _1782 = dot(float3((_1762 * _1762), _1762, 1.0f), float3(mad((_14[(_1760 + 2)]), 0.5f, mad(_1767, -1.0f, _1772)), (_1767 - _1764), mad(_1767, 0.5f, _1772)));
                            break;
                          }
                        }
                        _1782 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1786 = log2(max((lerp(_1699, _1697, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1787 = _1786 * 0.3010300099849701f;
                  do {
                    if (!(!(_1787 <= _1713))) {
                      _1856 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1794 = log2(ACESMidData.x);
                      float _1795 = _1794 * 0.3010300099849701f;
                      if ((bool)(_1787 > _1713) && (bool)(_1787 < _1795)) {
                        float _1803 = ((_1786 - _1712) * 0.9030900001525879f) / ((_1794 - _1712) * 0.3010300099849701f);
                        int _1804 = int(_1803);
                        float _1806 = _1803 - float(_1804);
                        float _1808 = _13[_1804];
                        float _1811 = _13[(_1804 + 1)];
                        float _1816 = _1808 * 0.5f;
                        _1856 = dot(float3((_1806 * _1806), _1806, 1.0f), float3(mad((_13[(_1804 + 2)]), 0.5f, mad(_1811, -1.0f, _1816)), (_1811 - _1808), mad(_1811, 0.5f, _1816)));
                      } else {
                        do {
                          if (!(!(_1787 >= _1795))) {
                            float _1825 = log2(ACESMinMaxData.z);
                            if (_1787 < (_1825 * 0.3010300099849701f)) {
                              float _1833 = ((_1786 - _1794) * 0.9030900001525879f) / ((_1825 - _1794) * 0.3010300099849701f);
                              int _1834 = int(_1833);
                              float _1836 = _1833 - float(_1834);
                              float _1838 = _14[_1834];
                              float _1841 = _14[(_1834 + 1)];
                              float _1846 = _1838 * 0.5f;
                              _1856 = dot(float3((_1836 * _1836), _1836, 1.0f), float3(mad((_14[(_1834 + 2)]), 0.5f, mad(_1841, -1.0f, _1846)), (_1841 - _1838), mad(_1841, 0.5f, _1846)));
                              break;
                            }
                          }
                          _1856 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1860 = log2(max((lerp(_1699, _1698, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1861 = _1860 * 0.3010300099849701f;
                    do {
                      if (!(!(_1861 <= _1713))) {
                        _1930 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1868 = log2(ACESMidData.x);
                        float _1869 = _1868 * 0.3010300099849701f;
                        if ((bool)(_1861 > _1713) && (bool)(_1861 < _1869)) {
                          float _1877 = ((_1860 - _1712) * 0.9030900001525879f) / ((_1868 - _1712) * 0.3010300099849701f);
                          int _1878 = int(_1877);
                          float _1880 = _1877 - float(_1878);
                          float _1882 = _13[_1878];
                          float _1885 = _13[(_1878 + 1)];
                          float _1890 = _1882 * 0.5f;
                          _1930 = dot(float3((_1880 * _1880), _1880, 1.0f), float3(mad((_13[(_1878 + 2)]), 0.5f, mad(_1885, -1.0f, _1890)), (_1885 - _1882), mad(_1885, 0.5f, _1890)));
                        } else {
                          do {
                            if (!(!(_1861 >= _1869))) {
                              float _1899 = log2(ACESMinMaxData.z);
                              if (_1861 < (_1899 * 0.3010300099849701f)) {
                                float _1907 = ((_1860 - _1868) * 0.9030900001525879f) / ((_1899 - _1868) * 0.3010300099849701f);
                                int _1908 = int(_1907);
                                float _1910 = _1907 - float(_1908);
                                float _1912 = _14[_1908];
                                float _1915 = _14[(_1908 + 1)];
                                float _1920 = _1912 * 0.5f;
                                _1930 = dot(float3((_1910 * _1910), _1910, 1.0f), float3(mad((_14[(_1908 + 2)]), 0.5f, mad(_1915, -1.0f, _1920)), (_1915 - _1912), mad(_1915, 0.5f, _1920)));
                                break;
                              }
                            }
                            _1930 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1934 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1935 = (exp2(_1782 * 3.321928024291992f) - ACESMinMaxData.y) / _1934;
                      float _1937 = (exp2(_1856 * 3.321928024291992f) - ACESMinMaxData.y) / _1934;
                      float _1939 = (exp2(_1930 * 3.321928024291992f) - ACESMinMaxData.y) / _1934;
                      float _1942 = mad(0.15618768334388733f, _1939, mad(0.13400420546531677f, _1937, (_1935 * 0.6624541878700256f)));
                      float _1945 = mad(0.053689517080783844f, _1939, mad(0.6740817427635193f, _1937, (_1935 * 0.2722287178039551f)));
                      float _1948 = mad(1.0103391408920288f, _1939, mad(0.00406073359772563f, _1937, (_1935 * -0.005574649665504694f)));
                      float _1961 = min(max(mad(-0.23642469942569733f, _1948, mad(-0.32480329275131226f, _1945, (_1942 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1962 = min(max(mad(0.016756348311901093f, _1948, mad(1.6153316497802734f, _1945, (_1942 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1963 = min(max(mad(0.9883948564529419f, _1948, mad(-0.008284442126750946f, _1945, (_1942 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1966 = mad(0.15618768334388733f, _1963, mad(0.13400420546531677f, _1962, (_1961 * 0.6624541878700256f)));
                      float _1969 = mad(0.053689517080783844f, _1963, mad(0.6740817427635193f, _1962, (_1961 * 0.2722287178039551f)));
                      float _1972 = mad(1.0103391408920288f, _1963, mad(0.00406073359772563f, _1962, (_1961 * -0.005574649665504694f)));
                      float _1994 = min(max((min(max(mad(-0.23642469942569733f, _1972, mad(-0.32480329275131226f, _1969, (_1966 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1995 = min(max((min(max(mad(0.016756348311901093f, _1972, mad(1.6153316497802734f, _1969, (_1966 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1996 = min(max((min(max(mad(0.9883948564529419f, _1972, mad(-0.008284442126750946f, _1969, (_1966 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(OutputDevice) == 5)) {
                          _2009 = mad(_57, _1996, mad(_56, _1995, (_1994 * _55)));
                          _2010 = mad(_60, _1996, mad(_59, _1995, (_1994 * _58)));
                          _2011 = mad(_63, _1996, mad(_62, _1995, (_1994 * _61)));
                        } else {
                          _2009 = _1994;
                          _2010 = _1995;
                          _2011 = _1996;
                        }
                        float _2021 = exp2(log2(_2009 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2022 = exp2(log2(_2010 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2023 = exp2(log2(_2011 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2762 = exp2(log2((1.0f / ((_2021 * 18.6875f) + 1.0f)) * ((_2021 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2763 = exp2(log2((1.0f / ((_2022 * 18.6875f) + 1.0f)) * ((_2022 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2764 = exp2(log2((1.0f / ((_2023 * 18.6875f) + 1.0f)) * ((_2023 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if (((uint)(OutputDevice) & -3) == 4) {
          _11[0] = ACESCoefsLow_0.x;
          _11[1] = ACESCoefsLow_0.y;
          _11[2] = ACESCoefsLow_0.z;
          _11[3] = ACESCoefsLow_0.w;
          _11[4] = ACESCoefsLow_4;
          _11[5] = ACESCoefsLow_4;
          _12[0] = ACESCoefsHigh_0.x;
          _12[1] = ACESCoefsHigh_0.y;
          _12[2] = ACESCoefsHigh_0.z;
          _12[3] = ACESCoefsHigh_0.w;
          _12[4] = ACESCoefsHigh_4;
          _12[5] = ACESCoefsHigh_4;
          float _2100 = ACESSceneColorMultiplier * _1326;
          float _2101 = ACESSceneColorMultiplier * _1327;
          float _2102 = ACESSceneColorMultiplier * _1328;
          float _2105 = mad((WorkingColorSpace_ToAP0[0].z), _2102, mad((WorkingColorSpace_ToAP0[0].y), _2101, ((WorkingColorSpace_ToAP0[0].x) * _2100)));
          float _2108 = mad((WorkingColorSpace_ToAP0[1].z), _2102, mad((WorkingColorSpace_ToAP0[1].y), _2101, ((WorkingColorSpace_ToAP0[1].x) * _2100)));
          float _2111 = mad((WorkingColorSpace_ToAP0[2].z), _2102, mad((WorkingColorSpace_ToAP0[2].y), _2101, ((WorkingColorSpace_ToAP0[2].x) * _2100)));
          float _2115 = max(max(_2105, _2108), _2111);
          float _2120 = (max(_2115, 1.000000013351432e-10f) - max(min(min(_2105, _2108), _2111), 1.000000013351432e-10f)) / max(_2115, 0.009999999776482582f);
          float _2133 = ((_2108 + _2105) + _2111) + (sqrt((((_2111 - _2108) * _2111) + ((_2108 - _2105) * _2108)) + ((_2105 - _2111) * _2105)) * 1.75f);
          float _2134 = _2133 * 0.3333333432674408f;
          float _2135 = _2120 + -0.4000000059604645f;
          float _2136 = _2135 * 5.0f;
          float _2140 = max((1.0f - abs(_2135 * 2.5f)), 0.0f);
          float _2151 = ((float(((int)(uint)((bool)(_2136 > 0.0f))) - ((int)(uint)((bool)(_2136 < 0.0f)))) * (1.0f - (_2140 * _2140))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2134 <= 0.0533333346247673f)) {
              if (!(_2134 >= 0.1599999964237213f)) {
                _2160 = (((0.23999999463558197f / _2133) + -0.5f) * _2151);
              } else {
                _2160 = 0.0f;
              }
            } else {
              _2160 = _2151;
            }
            float _2161 = _2160 + 1.0f;
            float _2162 = _2161 * _2105;
            float _2163 = _2161 * _2108;
            float _2164 = _2161 * _2111;
            do {
              if (!((bool)(_2162 == _2163) && (bool)(_2163 == _2164))) {
                float _2171 = ((_2162 * 2.0f) - _2163) - _2164;
                float _2174 = ((_2108 - _2111) * 1.7320507764816284f) * _2161;
                float _2176 = atan(_2174 / _2171);
                bool _2179 = (_2171 < 0.0f);
                bool _2180 = (_2171 == 0.0f);
                bool _2181 = (_2174 >= 0.0f);
                bool _2182 = (_2174 < 0.0f);
                _2193 = select((_2181 && _2180), 90.0f, select((_2182 && _2180), -90.0f, (select((_2182 && _2179), (_2176 + -3.1415927410125732f), select((_2181 && _2179), (_2176 + 3.1415927410125732f), _2176)) * 57.2957763671875f)));
              } else {
                _2193 = 0.0f;
              }
              float _2198 = min(max(select((_2193 < 0.0f), (_2193 + 360.0f), _2193), 0.0f), 360.0f);
              do {
                if (_2198 < -180.0f) {
                  _2207 = (_2198 + 360.0f);
                } else {
                  if (_2198 > 180.0f) {
                    _2207 = (_2198 + -360.0f);
                  } else {
                    _2207 = _2198;
                  }
                }
                do {
                  if ((bool)(_2207 > -67.5f) && (bool)(_2207 < 67.5f)) {
                    float _2213 = (_2207 + 67.5f) * 0.029629629105329514f;
                    int _2214 = int(_2213);
                    float _2216 = _2213 - float(_2214);
                    float _2217 = _2216 * _2216;
                    float _2218 = _2217 * _2216;
                    if (_2214 == 3) {
                      _2246 = (((0.1666666716337204f - (_2216 * 0.5f)) + (_2217 * 0.5f)) - (_2218 * 0.1666666716337204f));
                    } else {
                      if (_2214 == 2) {
                        _2246 = ((0.6666666865348816f - _2217) + (_2218 * 0.5f));
                      } else {
                        if (_2214 == 1) {
                          _2246 = (((_2218 * -0.5f) + 0.1666666716337204f) + ((_2217 + _2216) * 0.5f));
                        } else {
                          _2246 = select((_2214 == 0), (_2218 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2246 = 0.0f;
                  }
                  float _2255 = min(max(((((_2120 * 0.27000001072883606f) * (0.029999999329447746f - _2162)) * _2246) + _2162), 0.0f), 65535.0f);
                  float _2256 = min(max(_2163, 0.0f), 65535.0f);
                  float _2257 = min(max(_2164, 0.0f), 65535.0f);
                  float _2270 = min(max(mad(-0.21492856740951538f, _2257, mad(-0.2365107536315918f, _2256, (_2255 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2271 = min(max(mad(-0.09967592358589172f, _2257, mad(1.17622971534729f, _2256, (_2255 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2272 = min(max(mad(0.9977163076400757f, _2257, mad(-0.006032449658960104f, _2256, (_2255 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2273 = dot(float3(_2270, _2271, _2272), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2284 = log2(max((lerp(_2273, _2270, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2285 = _2284 * 0.3010300099849701f;
                  float _2286 = log2(ACESMinMaxData.x);
                  float _2287 = _2286 * 0.3010300099849701f;
                  do {
                    if (!(!(_2285 <= _2287))) {
                      _2356 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2294 = log2(ACESMidData.x);
                      float _2295 = _2294 * 0.3010300099849701f;
                      if ((bool)(_2285 > _2287) && (bool)(_2285 < _2295)) {
                        float _2303 = ((_2284 - _2286) * 0.9030900001525879f) / ((_2294 - _2286) * 0.3010300099849701f);
                        int _2304 = int(_2303);
                        float _2306 = _2303 - float(_2304);
                        float _2308 = _11[_2304];
                        float _2311 = _11[(_2304 + 1)];
                        float _2316 = _2308 * 0.5f;
                        _2356 = dot(float3((_2306 * _2306), _2306, 1.0f), float3(mad((_11[(_2304 + 2)]), 0.5f, mad(_2311, -1.0f, _2316)), (_2311 - _2308), mad(_2311, 0.5f, _2316)));
                      } else {
                        do {
                          if (!(!(_2285 >= _2295))) {
                            float _2325 = log2(ACESMinMaxData.z);
                            if (_2285 < (_2325 * 0.3010300099849701f)) {
                              float _2333 = ((_2284 - _2294) * 0.9030900001525879f) / ((_2325 - _2294) * 0.3010300099849701f);
                              int _2334 = int(_2333);
                              float _2336 = _2333 - float(_2334);
                              float _2338 = _12[_2334];
                              float _2341 = _12[(_2334 + 1)];
                              float _2346 = _2338 * 0.5f;
                              _2356 = dot(float3((_2336 * _2336), _2336, 1.0f), float3(mad((_12[(_2334 + 2)]), 0.5f, mad(_2341, -1.0f, _2346)), (_2341 - _2338), mad(_2341, 0.5f, _2346)));
                              break;
                            }
                          }
                          _2356 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2360 = log2(max((lerp(_2273, _2271, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2361 = _2360 * 0.3010300099849701f;
                    do {
                      if (!(!(_2361 <= _2287))) {
                        _2430 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2368 = log2(ACESMidData.x);
                        float _2369 = _2368 * 0.3010300099849701f;
                        if ((bool)(_2361 > _2287) && (bool)(_2361 < _2369)) {
                          float _2377 = ((_2360 - _2286) * 0.9030900001525879f) / ((_2368 - _2286) * 0.3010300099849701f);
                          int _2378 = int(_2377);
                          float _2380 = _2377 - float(_2378);
                          float _2382 = _11[_2378];
                          float _2385 = _11[(_2378 + 1)];
                          float _2390 = _2382 * 0.5f;
                          _2430 = dot(float3((_2380 * _2380), _2380, 1.0f), float3(mad((_11[(_2378 + 2)]), 0.5f, mad(_2385, -1.0f, _2390)), (_2385 - _2382), mad(_2385, 0.5f, _2390)));
                        } else {
                          do {
                            if (!(!(_2361 >= _2369))) {
                              float _2399 = log2(ACESMinMaxData.z);
                              if (_2361 < (_2399 * 0.3010300099849701f)) {
                                float _2407 = ((_2360 - _2368) * 0.9030900001525879f) / ((_2399 - _2368) * 0.3010300099849701f);
                                int _2408 = int(_2407);
                                float _2410 = _2407 - float(_2408);
                                float _2412 = _12[_2408];
                                float _2415 = _12[(_2408 + 1)];
                                float _2420 = _2412 * 0.5f;
                                _2430 = dot(float3((_2410 * _2410), _2410, 1.0f), float3(mad((_12[(_2408 + 2)]), 0.5f, mad(_2415, -1.0f, _2420)), (_2415 - _2412), mad(_2415, 0.5f, _2420)));
                                break;
                              }
                            }
                            _2430 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2434 = log2(max((lerp(_2273, _2272, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2435 = _2434 * 0.3010300099849701f;
                      do {
                        if (!(!(_2435 <= _2287))) {
                          _2504 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2442 = log2(ACESMidData.x);
                          float _2443 = _2442 * 0.3010300099849701f;
                          if ((bool)(_2435 > _2287) && (bool)(_2435 < _2443)) {
                            float _2451 = ((_2434 - _2286) * 0.9030900001525879f) / ((_2442 - _2286) * 0.3010300099849701f);
                            int _2452 = int(_2451);
                            float _2454 = _2451 - float(_2452);
                            float _2456 = _11[_2452];
                            float _2459 = _11[(_2452 + 1)];
                            float _2464 = _2456 * 0.5f;
                            _2504 = dot(float3((_2454 * _2454), _2454, 1.0f), float3(mad((_11[(_2452 + 2)]), 0.5f, mad(_2459, -1.0f, _2464)), (_2459 - _2456), mad(_2459, 0.5f, _2464)));
                          } else {
                            do {
                              if (!(!(_2435 >= _2443))) {
                                float _2473 = log2(ACESMinMaxData.z);
                                if (_2435 < (_2473 * 0.3010300099849701f)) {
                                  float _2481 = ((_2434 - _2442) * 0.9030900001525879f) / ((_2473 - _2442) * 0.3010300099849701f);
                                  int _2482 = int(_2481);
                                  float _2484 = _2481 - float(_2482);
                                  float _2486 = _12[_2482];
                                  float _2489 = _12[(_2482 + 1)];
                                  float _2494 = _2486 * 0.5f;
                                  _2504 = dot(float3((_2484 * _2484), _2484, 1.0f), float3(mad((_12[(_2482 + 2)]), 0.5f, mad(_2489, -1.0f, _2494)), (_2489 - _2486), mad(_2489, 0.5f, _2494)));
                                  break;
                                }
                              }
                              _2504 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2508 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2509 = (exp2(_2356 * 3.321928024291992f) - ACESMinMaxData.y) / _2508;
                        float _2511 = (exp2(_2430 * 3.321928024291992f) - ACESMinMaxData.y) / _2508;
                        float _2513 = (exp2(_2504 * 3.321928024291992f) - ACESMinMaxData.y) / _2508;
                        float _2516 = mad(0.15618768334388733f, _2513, mad(0.13400420546531677f, _2511, (_2509 * 0.6624541878700256f)));
                        float _2519 = mad(0.053689517080783844f, _2513, mad(0.6740817427635193f, _2511, (_2509 * 0.2722287178039551f)));
                        float _2522 = mad(1.0103391408920288f, _2513, mad(0.00406073359772563f, _2511, (_2509 * -0.005574649665504694f)));
                        float _2535 = min(max(mad(-0.23642469942569733f, _2522, mad(-0.32480329275131226f, _2519, (_2516 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2536 = min(max(mad(0.016756348311901093f, _2522, mad(1.6153316497802734f, _2519, (_2516 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2537 = min(max(mad(0.9883948564529419f, _2522, mad(-0.008284442126750946f, _2519, (_2516 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2540 = mad(0.15618768334388733f, _2537, mad(0.13400420546531677f, _2536, (_2535 * 0.6624541878700256f)));
                        float _2543 = mad(0.053689517080783844f, _2537, mad(0.6740817427635193f, _2536, (_2535 * 0.2722287178039551f)));
                        float _2546 = mad(1.0103391408920288f, _2537, mad(0.00406073359772563f, _2536, (_2535 * -0.005574649665504694f)));
                        float _2568 = min(max((min(max(mad(-0.23642469942569733f, _2546, mad(-0.32480329275131226f, _2543, (_2540 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2569 = min(max((min(max(mad(0.016756348311901093f, _2546, mad(1.6153316497802734f, _2543, (_2540 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2570 = min(max((min(max(mad(0.9883948564529419f, _2546, mad(-0.008284442126750946f, _2543, (_2540 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 6)) {
                            _2583 = mad(_57, _2570, mad(_56, _2569, (_2568 * _55)));
                            _2584 = mad(_60, _2570, mad(_59, _2569, (_2568 * _58)));
                            _2585 = mad(_63, _2570, mad(_62, _2569, (_2568 * _61)));
                          } else {
                            _2583 = _2568;
                            _2584 = _2569;
                            _2585 = _2570;
                          }
                          float _2595 = exp2(log2(_2583 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2596 = exp2(log2(_2584 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2597 = exp2(log2(_2585 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2762 = exp2(log2((1.0f / ((_2595 * 18.6875f) + 1.0f)) * ((_2595 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2763 = exp2(log2((1.0f / ((_2596 * 18.6875f) + 1.0f)) * ((_2596 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2764 = exp2(log2((1.0f / ((_2597 * 18.6875f) + 1.0f)) * ((_2597 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if ((uint)(OutputDevice) == 7) {
            float _2642 = mad((WorkingColorSpace_ToAP1[0].z), _1328, mad((WorkingColorSpace_ToAP1[0].y), _1327, ((WorkingColorSpace_ToAP1[0].x) * _1326)));
            float _2645 = mad((WorkingColorSpace_ToAP1[1].z), _1328, mad((WorkingColorSpace_ToAP1[1].y), _1327, ((WorkingColorSpace_ToAP1[1].x) * _1326)));
            float _2648 = mad((WorkingColorSpace_ToAP1[2].z), _1328, mad((WorkingColorSpace_ToAP1[2].y), _1327, ((WorkingColorSpace_ToAP1[2].x) * _1326)));
            float _2667 = exp2(log2(mad(_57, _2648, mad(_56, _2645, (_2642 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2668 = exp2(log2(mad(_60, _2648, mad(_59, _2645, (_2642 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2669 = exp2(log2(mad(_63, _2648, mad(_62, _2645, (_2642 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2762 = exp2(log2((1.0f / ((_2667 * 18.6875f) + 1.0f)) * ((_2667 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2763 = exp2(log2((1.0f / ((_2668 * 18.6875f) + 1.0f)) * ((_2668 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2764 = exp2(log2((1.0f / ((_2669 * 18.6875f) + 1.0f)) * ((_2669 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2716 = mad((WorkingColorSpace_ToAP1[0].z), _1316, mad((WorkingColorSpace_ToAP1[0].y), _1315, ((WorkingColorSpace_ToAP1[0].x) * _1314)));
                float _2719 = mad((WorkingColorSpace_ToAP1[1].z), _1316, mad((WorkingColorSpace_ToAP1[1].y), _1315, ((WorkingColorSpace_ToAP1[1].x) * _1314)));
                float _2722 = mad((WorkingColorSpace_ToAP1[2].z), _1316, mad((WorkingColorSpace_ToAP1[2].y), _1315, ((WorkingColorSpace_ToAP1[2].x) * _1314)));
                _2762 = mad(_57, _2722, mad(_56, _2719, (_2716 * _55)));
                _2763 = mad(_60, _2722, mad(_59, _2719, (_2716 * _58)));
                _2764 = mad(_63, _2722, mad(_62, _2719, (_2716 * _61)));
              } else {
                float _2735 = mad((WorkingColorSpace_ToAP1[0].z), _1342, mad((WorkingColorSpace_ToAP1[0].y), _1341, ((WorkingColorSpace_ToAP1[0].x) * _1340)));
                float _2738 = mad((WorkingColorSpace_ToAP1[1].z), _1342, mad((WorkingColorSpace_ToAP1[1].y), _1341, ((WorkingColorSpace_ToAP1[1].x) * _1340)));
                float _2741 = mad((WorkingColorSpace_ToAP1[2].z), _1342, mad((WorkingColorSpace_ToAP1[2].y), _1341, ((WorkingColorSpace_ToAP1[2].x) * _1340)));
                _2762 = exp2(log2(mad(_57, _2741, mad(_56, _2738, (_2735 * _55)))) * InverseGamma.z);
                _2763 = exp2(log2(mad(_60, _2741, mad(_59, _2738, (_2735 * _58)))) * InverseGamma.z);
                _2764 = exp2(log2(mad(_63, _2741, mad(_62, _2738, (_2735 * _61)))) * InverseGamma.z);
              }
            } else {
              _2762 = _1326;
              _2763 = _1327;
              _2764 = _1328;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2762 * 0.9523810148239136f), (_2763 * 0.9523810148239136f), (_2764 * 0.9523810148239136f), 0.0f);
}

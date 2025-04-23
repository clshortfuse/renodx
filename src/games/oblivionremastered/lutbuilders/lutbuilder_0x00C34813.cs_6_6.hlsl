#include "../common.hlsl"

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _24 = 0.5f / LUTSize;
  float _29 = LUTSize + -1.0f;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _124;
  float _831;
  float _864;
  float _878;
  float _942;
  float _1133;
  float _1144;
  float _1155;
  float _1324;
  float _1325;
  float _1326;
  float _1337;
  float _1348;
  float _1359;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _42 = ((uint)(OutputGamut) == 4);
        _53 = select(_42, 1.0f, 1.705051064491272f);
        _54 = select(_42, 0.0f, -0.6217921376228333f);
        _55 = select(_42, 0.0f, -0.0832589864730835f);
        _56 = select(_42, 0.0f, -0.13025647401809692f);
        _57 = select(_42, 1.0f, 1.140804648399353f);
        _58 = select(_42, 0.0f, -0.010548308491706848f);
        _59 = select(_42, 0.0f, -0.024003351107239723f);
        _60 = select(_42, 0.0f, -0.1289689838886261f);
        _61 = select(_42, 1.0f, 1.1529725790023804f);
      } else {
        _53 = 0.6954522132873535f;
        _54 = 0.14067870378494263f;
        _55 = 0.16386906802654266f;
        _56 = 0.044794563204050064f;
        _57 = 0.8596711158752441f;
        _58 = 0.0955343171954155f;
        _59 = -0.005525882821530104f;
        _60 = 0.004025210160762072f;
        _61 = 1.0015007257461548f;
      }
    } else {
      _53 = 1.0258246660232544f;
      _54 = -0.020053181797266006f;
      _55 = -0.005771636962890625f;
      _56 = -0.002234415616840124f;
      _57 = 1.0045864582061768f;
      _58 = -0.002352118492126465f;
      _59 = -0.005013350863009691f;
      _60 = -0.025290070101618767f;
      _61 = 1.0303035974502563f;
    }
  } else {
    _53 = 1.3792141675949097f;
    _54 = -0.30886411666870117f;
    _55 = -0.0703500509262085f;
    _56 = -0.06933490186929703f;
    _57 = 1.08229660987854f;
    _58 = -0.012961871922016144f;
    _59 = -0.0021590073592960835f;
    _60 = -0.0454593189060688f;
    _61 = 1.0476183891296387f;
  }
  float _74 = (exp2((((LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _24)) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _75 = (exp2((((LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _24)) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _76 = (exp2(((float((uint)SV_DispatchThreadID.z) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _103 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _107 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _124 = (((((2967800.0f - (_107 * 4607000064.0f)) * _107) + 99.11000061035156f) * _107) + 0.24406300485134125f);
  } else {
    _124 = (((((1901800.0f - (_107 * 2006400000.0f)) * _107) + 247.47999572753906f) * _107) + 0.23703999817371368f);
  }
  float _138 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _145 = WhiteTemp * WhiteTemp;
  float _148 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_145 * 1.6145605741257896e-07f));
  float _153 = ((_138 * 2.0f) + 4.0f) - (_148 * 8.0f);
  float _154 = (_138 * 3.0f) / _153;
  float _156 = (_148 * 2.0f) / _153;
  bool _157 = (WhiteTemp < 4000.0f);
  float _166 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _168 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_145 * 1.5317699909210205f)) / (_166 * _166);
  float _175 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _145;
  float _177 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_145 * 308.60699462890625f)) / (_175 * _175);
  float _179 = rsqrt(dot(float2(_168, _177), float2(_168, _177)));
  float _180 = WhiteTint * 0.05000000074505806f;
  float _183 = ((_180 * _177) * _179) + _138;
  float _186 = _148 - ((_180 * _168) * _179);
  float _191 = (4.0f - (_186 * 8.0f)) + (_183 * 2.0f);
  float _197 = (((_183 * 3.0f) / _191) - _154) + select(_157, _154, _124);
  float _198 = (((_186 * 2.0f) / _191) - _156) + select(_157, _156, (((_124 * 2.869999885559082f) + -0.2750000059604645f) - ((_124 * _124) * 3.0f)));
  float _199 = select(_103, _197, 0.3127000033855438f);
  float _200 = select(_103, _198, 0.32899999618530273f);
  float _201 = select(_103, 0.3127000033855438f, _197);
  float _202 = select(_103, 0.32899999618530273f, _198);
  float _203 = max(_200, 1.000000013351432e-10f);
  float _204 = _199 / _203;
  float _207 = ((1.0f - _199) - _200) / _203;
  float _208 = max(_202, 1.000000013351432e-10f);
  float _209 = _201 / _208;
  float _212 = ((1.0f - _201) - _202) / _208;
  float _231 = mad(-0.16140000522136688f, _212, ((_209 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _207, ((_204 * 0.8950999975204468f) + 0.266400009393692f));
  float _232 = mad(0.03669999912381172f, _212, (1.7135000228881836f - (_209 * 0.7501999735832214f))) / mad(0.03669999912381172f, _207, (1.7135000228881836f - (_204 * 0.7501999735832214f)));
  float _233 = mad(1.0296000242233276f, _212, ((_209 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _207, ((_204 * 0.03889999911189079f) + -0.06849999725818634f));
  float _234 = mad(_232, -0.7501999735832214f, 0.0f);
  float _235 = mad(_232, 1.7135000228881836f, 0.0f);
  float _236 = mad(_232, 0.03669999912381172f, -0.0f);
  float _237 = mad(_233, 0.03889999911189079f, 0.0f);
  float _238 = mad(_233, -0.06849999725818634f, 0.0f);
  float _239 = mad(_233, 1.0296000242233276f, 0.0f);
  float _242 = mad(0.1599626988172531f, _237, mad(-0.1470542997121811f, _234, (_231 * 0.883457362651825f)));
  float _245 = mad(0.1599626988172531f, _238, mad(-0.1470542997121811f, _235, (_231 * 0.26293492317199707f)));
  float _248 = mad(0.1599626988172531f, _239, mad(-0.1470542997121811f, _236, (_231 * -0.15930065512657166f)));
  float _251 = mad(0.04929120093584061f, _237, mad(0.5183603167533875f, _234, (_231 * 0.38695648312568665f)));
  float _254 = mad(0.04929120093584061f, _238, mad(0.5183603167533875f, _235, (_231 * 0.11516613513231277f)));
  float _257 = mad(0.04929120093584061f, _239, mad(0.5183603167533875f, _236, (_231 * -0.0697740763425827f)));
  float _260 = mad(0.9684867262840271f, _237, mad(0.04004279896616936f, _234, (_231 * -0.007634039502590895f)));
  float _263 = mad(0.9684867262840271f, _238, mad(0.04004279896616936f, _235, (_231 * -0.0022720457054674625f)));
  float _266 = mad(0.9684867262840271f, _239, mad(0.04004279896616936f, _236, (_231 * 0.0013765322510153055f)));
  float _269 = mad(_248, (WorkingColorSpace_ToXYZ[2].x), mad(_245, (WorkingColorSpace_ToXYZ[1].x), (_242 * (WorkingColorSpace_ToXYZ[0].x))));
  float _272 = mad(_248, (WorkingColorSpace_ToXYZ[2].y), mad(_245, (WorkingColorSpace_ToXYZ[1].y), (_242 * (WorkingColorSpace_ToXYZ[0].y))));
  float _275 = mad(_248, (WorkingColorSpace_ToXYZ[2].z), mad(_245, (WorkingColorSpace_ToXYZ[1].z), (_242 * (WorkingColorSpace_ToXYZ[0].z))));
  float _278 = mad(_257, (WorkingColorSpace_ToXYZ[2].x), mad(_254, (WorkingColorSpace_ToXYZ[1].x), (_251 * (WorkingColorSpace_ToXYZ[0].x))));
  float _281 = mad(_257, (WorkingColorSpace_ToXYZ[2].y), mad(_254, (WorkingColorSpace_ToXYZ[1].y), (_251 * (WorkingColorSpace_ToXYZ[0].y))));
  float _284 = mad(_257, (WorkingColorSpace_ToXYZ[2].z), mad(_254, (WorkingColorSpace_ToXYZ[1].z), (_251 * (WorkingColorSpace_ToXYZ[0].z))));
  float _287 = mad(_266, (WorkingColorSpace_ToXYZ[2].x), mad(_263, (WorkingColorSpace_ToXYZ[1].x), (_260 * (WorkingColorSpace_ToXYZ[0].x))));
  float _290 = mad(_266, (WorkingColorSpace_ToXYZ[2].y), mad(_263, (WorkingColorSpace_ToXYZ[1].y), (_260 * (WorkingColorSpace_ToXYZ[0].y))));
  float _293 = mad(_266, (WorkingColorSpace_ToXYZ[2].z), mad(_263, (WorkingColorSpace_ToXYZ[1].z), (_260 * (WorkingColorSpace_ToXYZ[0].z))));
  float _323 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _293, mad((WorkingColorSpace_FromXYZ[0].y), _284, (_275 * (WorkingColorSpace_FromXYZ[0].x)))), _76, mad(mad((WorkingColorSpace_FromXYZ[0].z), _290, mad((WorkingColorSpace_FromXYZ[0].y), _281, (_272 * (WorkingColorSpace_FromXYZ[0].x)))), _75, (mad((WorkingColorSpace_FromXYZ[0].z), _287, mad((WorkingColorSpace_FromXYZ[0].y), _278, (_269 * (WorkingColorSpace_FromXYZ[0].x)))) * _74)));
  float _326 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _293, mad((WorkingColorSpace_FromXYZ[1].y), _284, (_275 * (WorkingColorSpace_FromXYZ[1].x)))), _76, mad(mad((WorkingColorSpace_FromXYZ[1].z), _290, mad((WorkingColorSpace_FromXYZ[1].y), _281, (_272 * (WorkingColorSpace_FromXYZ[1].x)))), _75, (mad((WorkingColorSpace_FromXYZ[1].z), _287, mad((WorkingColorSpace_FromXYZ[1].y), _278, (_269 * (WorkingColorSpace_FromXYZ[1].x)))) * _74)));
  float _329 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _293, mad((WorkingColorSpace_FromXYZ[2].y), _284, (_275 * (WorkingColorSpace_FromXYZ[2].x)))), _76, mad(mad((WorkingColorSpace_FromXYZ[2].z), _290, mad((WorkingColorSpace_FromXYZ[2].y), _281, (_272 * (WorkingColorSpace_FromXYZ[2].x)))), _75, (mad((WorkingColorSpace_FromXYZ[2].z), _287, mad((WorkingColorSpace_FromXYZ[2].y), _278, (_269 * (WorkingColorSpace_FromXYZ[2].x)))) * _74)));
  float _344 = mad((WorkingColorSpace_ToAP1[0].z), _329, mad((WorkingColorSpace_ToAP1[0].y), _326, ((WorkingColorSpace_ToAP1[0].x) * _323)));
  float _347 = mad((WorkingColorSpace_ToAP1[1].z), _329, mad((WorkingColorSpace_ToAP1[1].y), _326, ((WorkingColorSpace_ToAP1[1].x) * _323)));
  float _350 = mad((WorkingColorSpace_ToAP1[2].z), _329, mad((WorkingColorSpace_ToAP1[2].y), _326, ((WorkingColorSpace_ToAP1[2].x) * _323)));
  float _351 = dot(float3(_344, _347, _350), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUntonemappedAP1(float3(_344, _347, _350));

  float _355 = (_344 / _351) + -1.0f;
  float _356 = (_347 / _351) + -1.0f;
  float _357 = (_350 / _351) + -1.0f;
  float _369 = (1.0f - exp2(((_351 * _351) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_355, _356, _357), float3(_355, _356, _357)) * -4.0f));
  float _385 = ((mad(-0.06368321925401688f, _350, mad(-0.3292922377586365f, _347, (_344 * 1.3704125881195068f))) - _344) * _369) + _344;
  float _386 = ((mad(-0.010861365124583244f, _350, mad(1.0970927476882935f, _347, (_344 * -0.08343357592821121f))) - _347) * _369) + _347;
  float _387 = ((mad(1.2036951780319214f, _350, mad(-0.09862580895423889f, _347, (_344 * -0.02579331398010254f))) - _350) * _369) + _350;
  float _388 = dot(float3(_385, _386, _387), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _402 = ColorOffset.w + ColorOffsetShadows.w;
  float _416 = ColorGain.w * ColorGainShadows.w;
  float _430 = ColorGamma.w * ColorGammaShadows.w;
  float _444 = ColorContrast.w * ColorContrastShadows.w;
  float _458 = ColorSaturation.w * ColorSaturationShadows.w;
  float _462 = _385 - _388;
  float _463 = _386 - _388;
  float _464 = _387 - _388;
  float _521 = saturate(_388 / ColorCorrectionShadowsMax);
  float _525 = (_521 * _521) * (3.0f - (_521 * 2.0f));
  float _526 = 1.0f - _525;
  float _535 = ColorOffset.w + ColorOffsetHighlights.w;
  float _544 = ColorGain.w * ColorGainHighlights.w;
  float _553 = ColorGamma.w * ColorGammaHighlights.w;
  float _562 = ColorContrast.w * ColorContrastHighlights.w;
  float _571 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _634 = saturate((_388 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _638 = (_634 * _634) * (3.0f - (_634 * 2.0f));
  float _647 = ColorOffset.w + ColorOffsetMidtones.w;
  float _656 = ColorGain.w * ColorGainMidtones.w;
  float _665 = ColorGamma.w * ColorGammaMidtones.w;
  float _674 = ColorContrast.w * ColorContrastMidtones.w;
  float _683 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _741 = _525 - _638;
  float _752 = ((_638 * (((ColorOffset.x + ColorOffsetHighlights.x) + _535) + (((ColorGain.x * ColorGainHighlights.x) * _544) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _562) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _571) * _462) + _388)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _553)))))) + (_526 * (((ColorOffset.x + ColorOffsetShadows.x) + _402) + (((ColorGain.x * ColorGainShadows.x) * _416) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _444) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _458) * _462) + _388)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _430))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _647) + (((ColorGain.x * ColorGainMidtones.x) * _656) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _674) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _683) * _462) + _388)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _665))))) * _741);
  float _754 = ((_638 * (((ColorOffset.y + ColorOffsetHighlights.y) + _535) + (((ColorGain.y * ColorGainHighlights.y) * _544) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _562) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _571) * _463) + _388)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _553)))))) + (_526 * (((ColorOffset.y + ColorOffsetShadows.y) + _402) + (((ColorGain.y * ColorGainShadows.y) * _416) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _444) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _458) * _463) + _388)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _430))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _647) + (((ColorGain.y * ColorGainMidtones.y) * _656) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _674) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _683) * _463) + _388)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _665))))) * _741);
  float _756 = ((_638 * (((ColorOffset.z + ColorOffsetHighlights.z) + _535) + (((ColorGain.z * ColorGainHighlights.z) * _544) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _562) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _571) * _464) + _388)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _553)))))) + (_526 * (((ColorOffset.z + ColorOffsetShadows.z) + _402) + (((ColorGain.z * ColorGainShadows.z) * _416) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _444) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _458) * _464) + _388)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _430))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _647) + (((ColorGain.z * ColorGainMidtones.z) * _656) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _674) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _683) * _464) + _388)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _665))))) * _741);
  float _771 = ((mad(0.061360642313957214f, _756, mad(-4.540197551250458e-09f, _754, (_752 * 0.9386394023895264f))) - _752) * BlueCorrection) + _752;
  float _772 = ((mad(0.169205904006958f, _756, mad(0.8307942152023315f, _754, (_752 * 6.775371730327606e-08f))) - _754) * BlueCorrection) + _754;
  float _773 = (mad(-2.3283064365386963e-10f, _754, (_752 * -9.313225746154785e-10f)) * BlueCorrection) + _756;
  float _776 = mad(0.16386905312538147f, _773, mad(0.14067868888378143f, _772, (_771 * 0.6954522132873535f)));
  float _779 = mad(0.0955343246459961f, _773, mad(0.8596711158752441f, _772, (_771 * 0.044794581830501556f)));
  float _782 = mad(1.0015007257461548f, _773, mad(0.004025210160762072f, _772, (_771 * -0.005525882821530104f)));
  float _786 = max(max(_776, _779), _782);
  float _791 = (max(_786, 1.000000013351432e-10f) - max(min(min(_776, _779), _782), 1.000000013351432e-10f)) / max(_786, 0.009999999776482582f);
  float _804 = ((_779 + _776) + _782) + (sqrt((((_782 - _779) * _782) + ((_779 - _776) * _779)) + ((_776 - _782) * _776)) * 1.75f);
  float _805 = _804 * 0.3333333432674408f;
  float _806 = _791 + -0.4000000059604645f;
  float _807 = _806 * 5.0f;
  float _811 = max((1.0f - abs(_806 * 2.5f)), 0.0f);
  float _822 = ((float(((int)(uint)((bool)(_807 > 0.0f))) - ((int)(uint)((bool)(_807 < 0.0f)))) * (1.0f - (_811 * _811))) + 1.0f) * 0.02500000037252903f;
  if (!(_805 <= 0.0533333346247673f)) {
    if (!(_805 >= 0.1599999964237213f)) {
      _831 = (((0.23999999463558197f / _804) + -0.5f) * _822);
    } else {
      _831 = 0.0f;
    }
  } else {
    _831 = _822;
  }
  float _832 = _831 + 1.0f;
  float _833 = _832 * _776;
  float _834 = _832 * _779;
  float _835 = _832 * _782;
  if (!((bool)(_833 == _834) && (bool)(_834 == _835))) {
    float _842 = ((_833 * 2.0f) - _834) - _835;
    float _845 = ((_779 - _782) * 1.7320507764816284f) * _832;
    float _847 = atan(_845 / _842);
    bool _850 = (_842 < 0.0f);
    bool _851 = (_842 == 0.0f);
    bool _852 = (_845 >= 0.0f);
    bool _853 = (_845 < 0.0f);
    _864 = select((_852 && _851), 90.0f, select((_853 && _851), -90.0f, (select((_853 && _850), (_847 + -3.1415927410125732f), select((_852 && _850), (_847 + 3.1415927410125732f), _847)) * 57.2957763671875f)));
  } else {
    _864 = 0.0f;
  }
  float _869 = min(max(select((_864 < 0.0f), (_864 + 360.0f), _864), 0.0f), 360.0f);
  if (_869 < -180.0f) {
    _878 = (_869 + 360.0f);
  } else {
    if (_869 > 180.0f) {
      _878 = (_869 + -360.0f);
    } else {
      _878 = _869;
    }
  }
  float _882 = saturate(1.0f - abs(_878 * 0.014814814552664757f));
  float _886 = (_882 * _882) * (3.0f - (_882 * 2.0f));
  float _892 = ((_886 * _886) * ((_791 * 0.18000000715255737f) * (0.029999999329447746f - _833))) + _833;
  float _902 = max(0.0f, mad(-0.21492856740951538f, _835, mad(-0.2365107536315918f, _834, (_892 * 1.4514392614364624f))));
  float _903 = max(0.0f, mad(-0.09967592358589172f, _835, mad(1.17622971534729f, _834, (_892 * -0.07655377686023712f))));
  float _904 = max(0.0f, mad(0.9977163076400757f, _835, mad(-0.006032449658960104f, _834, (_892 * 0.008316148072481155f))));
  float _905 = dot(float3(_902, _903, _904), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _920 = (FilmBlackClip + 1.0f) - FilmToe;
  float _922 = FilmWhiteClip + 1.0f;
  float _924 = _922 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _942 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _933 = (FilmBlackClip + 0.18000000715255737f) / _920;
    _942 = (-0.7447274923324585f - ((log2(_933 / (2.0f - _933)) * 0.3465735912322998f) * (_920 / FilmSlope)));
  }
  float _945 = ((1.0f - FilmToe) / FilmSlope) - _942;
  float _947 = (FilmShoulder / FilmSlope) - _945;
  float _951 = log2(lerp(_905, _902, 0.9599999785423279f)) * 0.3010300099849701f;
  float _952 = log2(lerp(_905, _903, 0.9599999785423279f)) * 0.3010300099849701f;
  float _953 = log2(lerp(_905, _904, 0.9599999785423279f)) * 0.3010300099849701f;
  float _957 = FilmSlope * (_951 + _945);
  float _958 = FilmSlope * (_952 + _945);
  float _959 = FilmSlope * (_953 + _945);
  float _960 = _920 * 2.0f;
  float _962 = (FilmSlope * -2.0f) / _920;
  float _963 = _951 - _942;
  float _964 = _952 - _942;
  float _965 = _953 - _942;
  float _984 = _924 * 2.0f;
  float _986 = (FilmSlope * 2.0f) / _924;
  float _1011 = select((_951 < _942), ((_960 / (exp2((_963 * 1.4426950216293335f) * _962) + 1.0f)) - FilmBlackClip), _957);
  float _1012 = select((_952 < _942), ((_960 / (exp2((_964 * 1.4426950216293335f) * _962) + 1.0f)) - FilmBlackClip), _958);
  float _1013 = select((_953 < _942), ((_960 / (exp2((_965 * 1.4426950216293335f) * _962) + 1.0f)) - FilmBlackClip), _959);
  float _1020 = _947 - _942;
  float _1024 = saturate(_963 / _1020);
  float _1025 = saturate(_964 / _1020);
  float _1026 = saturate(_965 / _1020);
  bool _1027 = (_947 < _942);
  float _1031 = select(_1027, (1.0f - _1024), _1024);
  float _1032 = select(_1027, (1.0f - _1025), _1025);
  float _1033 = select(_1027, (1.0f - _1026), _1026);
  float _1052 = (((_1031 * _1031) * (select((_951 > _947), (_922 - (_984 / (exp2(((_951 - _947) * 1.4426950216293335f) * _986) + 1.0f))), _957) - _1011)) * (3.0f - (_1031 * 2.0f))) + _1011;
  float _1053 = (((_1032 * _1032) * (select((_952 > _947), (_922 - (_984 / (exp2(((_952 - _947) * 1.4426950216293335f) * _986) + 1.0f))), _958) - _1012)) * (3.0f - (_1032 * 2.0f))) + _1012;
  float _1054 = (((_1033 * _1033) * (select((_953 > _947), (_922 - (_984 / (exp2(((_953 - _947) * 1.4426950216293335f) * _986) + 1.0f))), _959) - _1013)) * (3.0f - (_1033 * 2.0f))) + _1013;
  float _1055 = dot(float3(_1052, _1053, _1054), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1075 = (ToneCurveAmount * (max(0.0f, (lerp(_1055, _1052, 0.9300000071525574f))) - _771)) + _771;
  float _1076 = (ToneCurveAmount * (max(0.0f, (lerp(_1055, _1053, 0.9300000071525574f))) - _772)) + _772;
  float _1077 = (ToneCurveAmount * (max(0.0f, (lerp(_1055, _1054, 0.9300000071525574f))) - _773)) + _773;
  float _1093 = ((mad(-0.06537103652954102f, _1077, mad(1.451815478503704e-06f, _1076, (_1075 * 1.065374732017517f))) - _1075) * BlueCorrection) + _1075;
  float _1094 = ((mad(-0.20366770029067993f, _1077, mad(1.2036634683609009f, _1076, (_1075 * -2.57161445915699e-07f))) - _1076) * BlueCorrection) + _1076;
  float _1095 = ((mad(0.9999996423721313f, _1077, mad(2.0954757928848267e-08f, _1076, (_1075 * 1.862645149230957e-08f))) - _1077) * BlueCorrection) + _1077;

  SetTonemappedAP1(_1093, _1094, _1095);

  float _1120 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1095, mad((WorkingColorSpace_FromAP1[0].y), _1094, ((WorkingColorSpace_FromAP1[0].x) * _1093)))));
  float _1121 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1095, mad((WorkingColorSpace_FromAP1[1].y), _1094, ((WorkingColorSpace_FromAP1[1].x) * _1093)))));
  float _1122 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1095, mad((WorkingColorSpace_FromAP1[2].y), _1094, ((WorkingColorSpace_FromAP1[2].x) * _1093)))));
  if (_1120 < 0.0031306699384003878f) {
    _1133 = (_1120 * 12.920000076293945f);
  } else {
    _1133 = (((pow(_1120, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1121 < 0.0031306699384003878f) {
    _1144 = (_1121 * 12.920000076293945f);
  } else {
    _1144 = (((pow(_1121, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1122 < 0.0031306699384003878f) {
    _1155 = (_1122 * 12.920000076293945f);
  } else {
    _1155 = (((pow(_1122, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1159 = (_1144 * 0.9375f) + 0.03125f;
  float _1166 = _1155 * 15.0f;
  float _1167 = floor(_1166);
  float _1168 = _1166 - _1167;
  float _1170 = (_1167 + ((_1133 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1173 = Textures_1.SampleLevel(Samplers_1, float2(_1170, _1159), 0.0f);
  float _1177 = _1170 + 0.0625f;
  float4 _1178 = Textures_1.SampleLevel(Samplers_1, float2(_1177, _1159), 0.0f);
  float4 _1200 = Textures_2.SampleLevel(Samplers_2, float2(_1170, _1159), 0.0f);
  float4 _1204 = Textures_2.SampleLevel(Samplers_2, float2(_1177, _1159), 0.0f);
  float _1223 = max(6.103519990574569e-05f, ((((lerp(_1173.x, _1178.x, _1168)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1133)) + ((lerp(_1200.x, _1204.x, _1168)) * (LUTWeights[0].z))));
  float _1224 = max(6.103519990574569e-05f, ((((lerp(_1173.y, _1178.y, _1168)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1144)) + ((lerp(_1200.y, _1204.y, _1168)) * (LUTWeights[0].z))));
  float _1225 = max(6.103519990574569e-05f, ((((lerp(_1173.z, _1178.z, _1168)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1155)) + ((lerp(_1200.z, _1204.z, _1168)) * (LUTWeights[0].z))));
  float _1247 = select((_1223 > 0.040449999272823334f), exp2(log2((_1223 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1223 * 0.07739938050508499f));
  float _1248 = select((_1224 > 0.040449999272823334f), exp2(log2((_1224 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1224 * 0.07739938050508499f));
  float _1249 = select((_1225 > 0.040449999272823334f), exp2(log2((_1225 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1225 * 0.07739938050508499f));
  float _1275 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1247)) * _1247) + MappingPolynomial.z);
  float _1276 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1248)) * _1248) + MappingPolynomial.z);
  float _1277 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1249)) * _1249) + MappingPolynomial.z);
  float _1298 = exp2(log2(max(0.0f, (lerp(_1275, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1299 = exp2(log2(max(0.0f, (lerp(_1276, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1300 = exp2(log2(max(0.0f, (lerp(_1277, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (CUSTOM_PROCESSING_MODE == 0.f && RENODX_TONE_MAP_TYPE != 0.f) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1298, _1299, _1300));
    return;
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1307 = mad((WorkingColorSpace_ToAP1[0].z), _1300, mad((WorkingColorSpace_ToAP1[0].y), _1299, ((WorkingColorSpace_ToAP1[0].x) * _1298)));
    float _1310 = mad((WorkingColorSpace_ToAP1[1].z), _1300, mad((WorkingColorSpace_ToAP1[1].y), _1299, ((WorkingColorSpace_ToAP1[1].x) * _1298)));
    float _1313 = mad((WorkingColorSpace_ToAP1[2].z), _1300, mad((WorkingColorSpace_ToAP1[2].y), _1299, ((WorkingColorSpace_ToAP1[2].x) * _1298)));
    _1324 = mad(_55, _1313, mad(_54, _1310, (_1307 * _53)));
    _1325 = mad(_58, _1313, mad(_57, _1310, (_1307 * _56)));
    _1326 = mad(_61, _1313, mad(_60, _1310, (_1307 * _59)));
  } else {
    _1324 = _1298;
    _1325 = _1299;
    _1326 = _1300;
  }
  if (_1324 < 0.0031306699384003878f) {
    _1337 = (_1324 * 12.920000076293945f);
  } else {
    _1337 = (((pow(_1324, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1325 < 0.0031306699384003878f) {
    _1348 = (_1325 * 12.920000076293945f);
  } else {
    _1348 = (((pow(_1325, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1326 < 0.0031306699384003878f) {
    _1359 = (_1326 * 12.920000076293945f);
  } else {
    _1359 = (((pow(_1326, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1337 * 0.9523810148239136f), (_1348 * 0.9523810148239136f), (_1359 * 0.9523810148239136f), 0.0f);
}

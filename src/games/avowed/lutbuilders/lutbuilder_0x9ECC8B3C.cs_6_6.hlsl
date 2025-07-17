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
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _30 = 0.5f / LUTSize;
  float _35 = LUTSize + -1.0f;
  float _36 = (LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _30)) / _35;
  float _37 = (LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _30)) / _35;
  float _39 = float((uint)SV_DispatchThreadID.z) / _35;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _125;
  float _126;
  float _127;
  float _175;
  float _903;
  float _936;
  float _950;
  float _1014;
  float _1193;
  float _1204;
  float _1215;
  float _1438;
  float _1439;
  float _1440;
  float _1451;
  float _1462;
  float _1642;
  float _1675;
  float _1689;
  float _1728;
  float _1838;
  float _1912;
  float _1986;
  float _2065;
  float _2066;
  float _2067;
  float _2216;
  float _2249;
  float _2263;
  float _2302;
  float _2412;
  float _2486;
  float _2560;
  float _2639;
  float _2640;
  float _2641;
  float _2818;
  float _2819;
  float _2820;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _48 = ((uint)(OutputGamut) == 4);
        _59 = select(_48, 1.0f, 1.705051064491272f);
        _60 = select(_48, 0.0f, -0.6217921376228333f);
        _61 = select(_48, 0.0f, -0.0832589864730835f);
        _62 = select(_48, 0.0f, -0.13025647401809692f);
        _63 = select(_48, 1.0f, 1.140804648399353f);
        _64 = select(_48, 0.0f, -0.010548308491706848f);
        _65 = select(_48, 0.0f, -0.024003351107239723f);
        _66 = select(_48, 0.0f, -0.1289689838886261f);
        _67 = select(_48, 1.0f, 1.1529725790023804f);
      } else {
        _59 = 0.6954522132873535f;
        _60 = 0.14067870378494263f;
        _61 = 0.16386906802654266f;
        _62 = 0.044794563204050064f;
        _63 = 0.8596711158752441f;
        _64 = 0.0955343171954155f;
        _65 = -0.005525882821530104f;
        _66 = 0.004025210160762072f;
        _67 = 1.0015007257461548f;
      }
    } else {
      _59 = 1.0258246660232544f;
      _60 = -0.020053181797266006f;
      _61 = -0.005771636962890625f;
      _62 = -0.002234415616840124f;
      _63 = 1.0045864582061768f;
      _64 = -0.002352118492126465f;
      _65 = -0.005013350863009691f;
      _66 = -0.025290070101618767f;
      _67 = 1.0303035974502563f;
    }
  } else {
    _59 = 1.3792141675949097f;
    _60 = -0.30886411666870117f;
    _61 = -0.0703500509262085f;
    _62 = -0.06933490186929703f;
    _63 = 1.08229660987854f;
    _64 = -0.012961871922016144f;
    _65 = -0.0021590073592960835f;
    _66 = -0.0454593189060688f;
    _67 = 1.0476183891296387f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _78 = (pow(_36, 0.012683313339948654f));
    float _79 = (pow(_37, 0.012683313339948654f));
    float _80 = (pow(_39, 0.012683313339948654f));
    _125 = (exp2(log2(max(0.0f, (_78 + -0.8359375f)) / (18.8515625f - (_78 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _126 = (exp2(log2(max(0.0f, (_79 + -0.8359375f)) / (18.8515625f - (_79 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _127 = (exp2(log2(max(0.0f, (_80 + -0.8359375f)) / (18.8515625f - (_80 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _125 = ((exp2((_36 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _126 = ((exp2((_37 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _127 = ((exp2((_39 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _154 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _158 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _175 = (((((2967800.0f - (_158 * 4607000064.0f)) * _158) + 99.11000061035156f) * _158) + 0.24406300485134125f);
  } else {
    _175 = (((((1901800.0f - (_158 * 2006400000.0f)) * _158) + 247.47999572753906f) * _158) + 0.23703999817371368f);
  }
  float _189 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _196 = WhiteTemp * WhiteTemp;
  float _199 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_196 * 1.6145605741257896e-07f));
  float _204 = ((_189 * 2.0f) + 4.0f) - (_199 * 8.0f);
  float _205 = (_189 * 3.0f) / _204;
  float _207 = (_199 * 2.0f) / _204;
  bool _208 = (WhiteTemp < 4000.0f);
  float _217 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _219 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_196 * 1.5317699909210205f)) / (_217 * _217);
  float _226 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _196;
  float _228 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_196 * 308.60699462890625f)) / (_226 * _226);
  float _230 = rsqrt(dot(float2(_219, _228), float2(_219, _228)));
  float _231 = WhiteTint * 0.05000000074505806f;
  float _234 = ((_231 * _228) * _230) + _189;
  float _237 = _199 - ((_231 * _219) * _230);
  float _242 = (4.0f - (_237 * 8.0f)) + (_234 * 2.0f);
  float _248 = (((_234 * 3.0f) / _242) - _205) + select(_208, _205, _175);
  float _249 = (((_237 * 2.0f) / _242) - _207) + select(_208, _207, (((_175 * 2.869999885559082f) + -0.2750000059604645f) - ((_175 * _175) * 3.0f)));
  float _250 = select(_154, _248, 0.3127000033855438f);
  float _251 = select(_154, _249, 0.32899999618530273f);
  float _252 = select(_154, 0.3127000033855438f, _248);
  float _253 = select(_154, 0.32899999618530273f, _249);
  float _254 = max(_251, 1.000000013351432e-10f);
  float _255 = _250 / _254;
  float _258 = ((1.0f - _250) - _251) / _254;
  float _259 = max(_253, 1.000000013351432e-10f);
  float _260 = _252 / _259;
  float _263 = ((1.0f - _252) - _253) / _259;
  float _282 = mad(-0.16140000522136688f, _263, ((_260 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _258, ((_255 * 0.8950999975204468f) + 0.266400009393692f));
  float _283 = mad(0.03669999912381172f, _263, (1.7135000228881836f - (_260 * 0.7501999735832214f))) / mad(0.03669999912381172f, _258, (1.7135000228881836f - (_255 * 0.7501999735832214f)));
  float _284 = mad(1.0296000242233276f, _263, ((_260 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _258, ((_255 * 0.03889999911189079f) + -0.06849999725818634f));
  float _285 = mad(_283, -0.7501999735832214f, 0.0f);
  float _286 = mad(_283, 1.7135000228881836f, 0.0f);
  float _287 = mad(_283, 0.03669999912381172f, -0.0f);
  float _288 = mad(_284, 0.03889999911189079f, 0.0f);
  float _289 = mad(_284, -0.06849999725818634f, 0.0f);
  float _290 = mad(_284, 1.0296000242233276f, 0.0f);
  float _293 = mad(0.1599626988172531f, _288, mad(-0.1470542997121811f, _285, (_282 * 0.883457362651825f)));
  float _296 = mad(0.1599626988172531f, _289, mad(-0.1470542997121811f, _286, (_282 * 0.26293492317199707f)));
  float _299 = mad(0.1599626988172531f, _290, mad(-0.1470542997121811f, _287, (_282 * -0.15930065512657166f)));
  float _302 = mad(0.04929120093584061f, _288, mad(0.5183603167533875f, _285, (_282 * 0.38695648312568665f)));
  float _305 = mad(0.04929120093584061f, _289, mad(0.5183603167533875f, _286, (_282 * 0.11516613513231277f)));
  float _308 = mad(0.04929120093584061f, _290, mad(0.5183603167533875f, _287, (_282 * -0.0697740763425827f)));
  float _311 = mad(0.9684867262840271f, _288, mad(0.04004279896616936f, _285, (_282 * -0.007634039502590895f)));
  float _314 = mad(0.9684867262840271f, _289, mad(0.04004279896616936f, _286, (_282 * -0.0022720457054674625f)));
  float _317 = mad(0.9684867262840271f, _290, mad(0.04004279896616936f, _287, (_282 * 0.0013765322510153055f)));
  float _320 = mad(_299, (WorkingColorSpace_ToXYZ[2].x), mad(_296, (WorkingColorSpace_ToXYZ[1].x), (_293 * (WorkingColorSpace_ToXYZ[0].x))));
  float _323 = mad(_299, (WorkingColorSpace_ToXYZ[2].y), mad(_296, (WorkingColorSpace_ToXYZ[1].y), (_293 * (WorkingColorSpace_ToXYZ[0].y))));
  float _326 = mad(_299, (WorkingColorSpace_ToXYZ[2].z), mad(_296, (WorkingColorSpace_ToXYZ[1].z), (_293 * (WorkingColorSpace_ToXYZ[0].z))));
  float _329 = mad(_308, (WorkingColorSpace_ToXYZ[2].x), mad(_305, (WorkingColorSpace_ToXYZ[1].x), (_302 * (WorkingColorSpace_ToXYZ[0].x))));
  float _332 = mad(_308, (WorkingColorSpace_ToXYZ[2].y), mad(_305, (WorkingColorSpace_ToXYZ[1].y), (_302 * (WorkingColorSpace_ToXYZ[0].y))));
  float _335 = mad(_308, (WorkingColorSpace_ToXYZ[2].z), mad(_305, (WorkingColorSpace_ToXYZ[1].z), (_302 * (WorkingColorSpace_ToXYZ[0].z))));
  float _338 = mad(_317, (WorkingColorSpace_ToXYZ[2].x), mad(_314, (WorkingColorSpace_ToXYZ[1].x), (_311 * (WorkingColorSpace_ToXYZ[0].x))));
  float _341 = mad(_317, (WorkingColorSpace_ToXYZ[2].y), mad(_314, (WorkingColorSpace_ToXYZ[1].y), (_311 * (WorkingColorSpace_ToXYZ[0].y))));
  float _344 = mad(_317, (WorkingColorSpace_ToXYZ[2].z), mad(_314, (WorkingColorSpace_ToXYZ[1].z), (_311 * (WorkingColorSpace_ToXYZ[0].z))));
  float _374 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _344, mad((WorkingColorSpace_FromXYZ[0].y), _335, (_326 * (WorkingColorSpace_FromXYZ[0].x)))), _127, mad(mad((WorkingColorSpace_FromXYZ[0].z), _341, mad((WorkingColorSpace_FromXYZ[0].y), _332, (_323 * (WorkingColorSpace_FromXYZ[0].x)))), _126, (mad((WorkingColorSpace_FromXYZ[0].z), _338, mad((WorkingColorSpace_FromXYZ[0].y), _329, (_320 * (WorkingColorSpace_FromXYZ[0].x)))) * _125)));
  float _377 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _344, mad((WorkingColorSpace_FromXYZ[1].y), _335, (_326 * (WorkingColorSpace_FromXYZ[1].x)))), _127, mad(mad((WorkingColorSpace_FromXYZ[1].z), _341, mad((WorkingColorSpace_FromXYZ[1].y), _332, (_323 * (WorkingColorSpace_FromXYZ[1].x)))), _126, (mad((WorkingColorSpace_FromXYZ[1].z), _338, mad((WorkingColorSpace_FromXYZ[1].y), _329, (_320 * (WorkingColorSpace_FromXYZ[1].x)))) * _125)));
  float _380 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _344, mad((WorkingColorSpace_FromXYZ[2].y), _335, (_326 * (WorkingColorSpace_FromXYZ[2].x)))), _127, mad(mad((WorkingColorSpace_FromXYZ[2].z), _341, mad((WorkingColorSpace_FromXYZ[2].y), _332, (_323 * (WorkingColorSpace_FromXYZ[2].x)))), _126, (mad((WorkingColorSpace_FromXYZ[2].z), _338, mad((WorkingColorSpace_FromXYZ[2].y), _329, (_320 * (WorkingColorSpace_FromXYZ[2].x)))) * _125)));
  float _395 = mad((WorkingColorSpace_ToAP1[0].z), _380, mad((WorkingColorSpace_ToAP1[0].y), _377, ((WorkingColorSpace_ToAP1[0].x) * _374)));
  float _398 = mad((WorkingColorSpace_ToAP1[1].z), _380, mad((WorkingColorSpace_ToAP1[1].y), _377, ((WorkingColorSpace_ToAP1[1].x) * _374)));
  float _401 = mad((WorkingColorSpace_ToAP1[2].z), _380, mad((WorkingColorSpace_ToAP1[2].y), _377, ((WorkingColorSpace_ToAP1[2].x) * _374)));
  float _402 = dot(float3(_395, _398, _401), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_395, _398, _401));

  float _406 = (_395 / _402) + -1.0f;
  float _407 = (_398 / _402) + -1.0f;
  float _408 = (_401 / _402) + -1.0f;
  float _420 = (1.0f - exp2(((_402 * _402) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_406, _407, _408), float3(_406, _407, _408)) * -4.0f));
  float _436 = ((mad(-0.06368321925401688f, _401, mad(-0.3292922377586365f, _398, (_395 * 1.3704125881195068f))) - _395) * _420) + _395;
  float _437 = ((mad(-0.010861365124583244f, _401, mad(1.0970927476882935f, _398, (_395 * -0.08343357592821121f))) - _398) * _420) + _398;
  float _438 = ((mad(1.2036951780319214f, _401, mad(-0.09862580895423889f, _398, (_395 * -0.02579331398010254f))) - _401) * _420) + _401;
  float _439 = dot(float3(_436, _437, _438), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _453 = ColorOffset.w + ColorOffsetShadows.w;
  float _467 = ColorGain.w * ColorGainShadows.w;
  float _481 = ColorGamma.w * ColorGammaShadows.w;
  float _495 = ColorContrast.w * ColorContrastShadows.w;
  float _509 = ColorSaturation.w * ColorSaturationShadows.w;
  float _513 = _436 - _439;
  float _514 = _437 - _439;
  float _515 = _438 - _439;
  float _572 = saturate(_439 / ColorCorrectionShadowsMax);
  float _576 = (_572 * _572) * (3.0f - (_572 * 2.0f));
  float _577 = 1.0f - _576;
  float _586 = ColorOffset.w + ColorOffsetHighlights.w;
  float _595 = ColorGain.w * ColorGainHighlights.w;
  float _604 = ColorGamma.w * ColorGammaHighlights.w;
  float _613 = ColorContrast.w * ColorContrastHighlights.w;
  float _622 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _685 = saturate((_439 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _689 = (_685 * _685) * (3.0f - (_685 * 2.0f));
  float _698 = ColorOffset.w + ColorOffsetMidtones.w;
  float _707 = ColorGain.w * ColorGainMidtones.w;
  float _716 = ColorGamma.w * ColorGammaMidtones.w;
  float _725 = ColorContrast.w * ColorContrastMidtones.w;
  float _734 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _792 = _576 - _689;
  float _803 = ((_689 * (((ColorOffset.x + ColorOffsetHighlights.x) + _586) + (((ColorGain.x * ColorGainHighlights.x) * _595) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _613) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _622) * _513) + _439)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _604)))))) + (_577 * (((ColorOffset.x + ColorOffsetShadows.x) + _453) + (((ColorGain.x * ColorGainShadows.x) * _467) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _495) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _509) * _513) + _439)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _481))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _698) + (((ColorGain.x * ColorGainMidtones.x) * _707) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _725) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _734) * _513) + _439)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _716))))) * _792);
  float _805 = ((_689 * (((ColorOffset.y + ColorOffsetHighlights.y) + _586) + (((ColorGain.y * ColorGainHighlights.y) * _595) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _613) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _622) * _514) + _439)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _604)))))) + (_577 * (((ColorOffset.y + ColorOffsetShadows.y) + _453) + (((ColorGain.y * ColorGainShadows.y) * _467) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _495) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _509) * _514) + _439)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _481))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _698) + (((ColorGain.y * ColorGainMidtones.y) * _707) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _725) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _734) * _514) + _439)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _716))))) * _792);
  float _807 = ((_689 * (((ColorOffset.z + ColorOffsetHighlights.z) + _586) + (((ColorGain.z * ColorGainHighlights.z) * _595) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _613) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _622) * _515) + _439)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _604)))))) + (_577 * (((ColorOffset.z + ColorOffsetShadows.z) + _453) + (((ColorGain.z * ColorGainShadows.z) * _467) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _495) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _509) * _515) + _439)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _481))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _698) + (((ColorGain.z * ColorGainMidtones.z) * _707) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _725) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _734) * _515) + _439)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _716))))) * _792);

  SetUntonemappedAP1(float3(_803, _805, _807));

  float _843 = ((mad(0.061360642313957214f, _807, mad(-4.540197551250458e-09f, _805, (_803 * 0.9386394023895264f))) - _803) * BlueCorrection) + _803;
  float _844 = ((mad(0.169205904006958f, _807, mad(0.8307942152023315f, _805, (_803 * 6.775371730327606e-08f))) - _805) * BlueCorrection) + _805;
  float _845 = (mad(-2.3283064365386963e-10f, _805, (_803 * -9.313225746154785e-10f)) * BlueCorrection) + _807;
  float _848 = mad(0.16386905312538147f, _845, mad(0.14067868888378143f, _844, (_843 * 0.6954522132873535f)));
  float _851 = mad(0.0955343246459961f, _845, mad(0.8596711158752441f, _844, (_843 * 0.044794581830501556f)));
  float _854 = mad(1.0015007257461548f, _845, mad(0.004025210160762072f, _844, (_843 * -0.005525882821530104f)));
  float _858 = max(max(_848, _851), _854);
  float _863 = (max(_858, 1.000000013351432e-10f) - max(min(min(_848, _851), _854), 1.000000013351432e-10f)) / max(_858, 0.009999999776482582f);
  float _876 = ((_851 + _848) + _854) + (sqrt((((_854 - _851) * _854) + ((_851 - _848) * _851)) + ((_848 - _854) * _848)) * 1.75f);
  float _877 = _876 * 0.3333333432674408f;
  float _878 = _863 + -0.4000000059604645f;
  float _879 = _878 * 5.0f;
  float _883 = max((1.0f - abs(_878 * 2.5f)), 0.0f);
  float _894 = ((float(((int)(uint)((bool)(_879 > 0.0f))) - ((int)(uint)((bool)(_879 < 0.0f)))) * (1.0f - (_883 * _883))) + 1.0f) * 0.02500000037252903f;
  if (!(_877 <= 0.0533333346247673f)) {
    if (!(_877 >= 0.1599999964237213f)) {
      _903 = (((0.23999999463558197f / _876) + -0.5f) * _894);
    } else {
      _903 = 0.0f;
    }
  } else {
    _903 = _894;
  }
  float _904 = _903 + 1.0f;
  float _905 = _904 * _848;
  float _906 = _904 * _851;
  float _907 = _904 * _854;
  if (!((bool)(_905 == _906) && (bool)(_906 == _907))) {
    float _914 = ((_905 * 2.0f) - _906) - _907;
    float _917 = ((_851 - _854) * 1.7320507764816284f) * _904;
    float _919 = atan(_917 / _914);
    bool _922 = (_914 < 0.0f);
    bool _923 = (_914 == 0.0f);
    bool _924 = (_917 >= 0.0f);
    bool _925 = (_917 < 0.0f);
    _936 = select((_924 && _923), 90.0f, select((_925 && _923), -90.0f, (select((_925 && _922), (_919 + -3.1415927410125732f), select((_924 && _922), (_919 + 3.1415927410125732f), _919)) * 57.2957763671875f)));
  } else {
    _936 = 0.0f;
  }
  float _941 = min(max(select((_936 < 0.0f), (_936 + 360.0f), _936), 0.0f), 360.0f);
  if (_941 < -180.0f) {
    _950 = (_941 + 360.0f);
  } else {
    if (_941 > 180.0f) {
      _950 = (_941 + -360.0f);
    } else {
      _950 = _941;
    }
  }
  float _954 = saturate(1.0f - abs(_950 * 0.014814814552664757f));
  float _958 = (_954 * _954) * (3.0f - (_954 * 2.0f));
  float _964 = ((_958 * _958) * ((_863 * 0.18000000715255737f) * (0.029999999329447746f - _905))) + _905;
  float _974 = max(0.0f, mad(-0.21492856740951538f, _907, mad(-0.2365107536315918f, _906, (_964 * 1.4514392614364624f))));
  float _975 = max(0.0f, mad(-0.09967592358589172f, _907, mad(1.17622971534729f, _906, (_964 * -0.07655377686023712f))));
  float _976 = max(0.0f, mad(0.9977163076400757f, _907, mad(-0.006032449658960104f, _906, (_964 * 0.008316148072481155f))));
  float _977 = dot(float3(_974, _975, _976), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _992 = (FilmBlackClip + 1.0f) - FilmToe;
  float _994 = FilmWhiteClip + 1.0f;
  float _996 = _994 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1014 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _1005 = (FilmBlackClip + 0.18000000715255737f) / _992;
    _1014 = (-0.7447274923324585f - ((log2(_1005 / (2.0f - _1005)) * 0.3465735912322998f) * (_992 / FilmSlope)));
  }
  float _1017 = ((1.0f - FilmToe) / FilmSlope) - _1014;
  float _1019 = (FilmShoulder / FilmSlope) - _1017;
  float _1023 = log2(lerp(_977, _974, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1024 = log2(lerp(_977, _975, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1025 = log2(lerp(_977, _976, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1029 = FilmSlope * (_1023 + _1017);
  float _1030 = FilmSlope * (_1024 + _1017);
  float _1031 = FilmSlope * (_1025 + _1017);
  float _1032 = _992 * 2.0f;
  float _1034 = (FilmSlope * -2.0f) / _992;
  float _1035 = _1023 - _1014;
  float _1036 = _1024 - _1014;
  float _1037 = _1025 - _1014;
  float _1056 = _996 * 2.0f;
  float _1058 = (FilmSlope * 2.0f) / _996;
  float _1083 = select((_1023 < _1014), ((_1032 / (exp2((_1035 * 1.4426950216293335f) * _1034) + 1.0f)) - FilmBlackClip), _1029);
  float _1084 = select((_1024 < _1014), ((_1032 / (exp2((_1036 * 1.4426950216293335f) * _1034) + 1.0f)) - FilmBlackClip), _1030);
  float _1085 = select((_1025 < _1014), ((_1032 / (exp2((_1037 * 1.4426950216293335f) * _1034) + 1.0f)) - FilmBlackClip), _1031);
  float _1092 = _1019 - _1014;
  float _1096 = saturate(_1035 / _1092);
  float _1097 = saturate(_1036 / _1092);
  float _1098 = saturate(_1037 / _1092);
  bool _1099 = (_1019 < _1014);
  float _1103 = select(_1099, (1.0f - _1096), _1096);
  float _1104 = select(_1099, (1.0f - _1097), _1097);
  float _1105 = select(_1099, (1.0f - _1098), _1098);
  float _1124 = (((_1103 * _1103) * (select((_1023 > _1019), (_994 - (_1056 / (exp2(((_1023 - _1019) * 1.4426950216293335f) * _1058) + 1.0f))), _1029) - _1083)) * (3.0f - (_1103 * 2.0f))) + _1083;
  float _1125 = (((_1104 * _1104) * (select((_1024 > _1019), (_994 - (_1056 / (exp2(((_1024 - _1019) * 1.4426950216293335f) * _1058) + 1.0f))), _1030) - _1084)) * (3.0f - (_1104 * 2.0f))) + _1084;
  float _1126 = (((_1105 * _1105) * (select((_1025 > _1019), (_994 - (_1056 / (exp2(((_1025 - _1019) * 1.4426950216293335f) * _1058) + 1.0f))), _1031) - _1085)) * (3.0f - (_1105 * 2.0f))) + _1085;
  float _1127 = dot(float3(_1124, _1125, _1126), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1147 = (ToneCurveAmount * (max(0.0f, (lerp(_1127, _1124, 0.9300000071525574f))) - _843)) + _843;
  float _1148 = (ToneCurveAmount * (max(0.0f, (lerp(_1127, _1125, 0.9300000071525574f))) - _844)) + _844;
  float _1149 = (ToneCurveAmount * (max(0.0f, (lerp(_1127, _1126, 0.9300000071525574f))) - _845)) + _845;
  float _1165 = ((mad(-0.06537103652954102f, _1149, mad(1.451815478503704e-06f, _1148, (_1147 * 1.065374732017517f))) - _1147) * BlueCorrection) + _1147;
  float _1166 = ((mad(-0.20366770029067993f, _1149, mad(1.2036634683609009f, _1148, (_1147 * -2.57161445915699e-07f))) - _1148) * BlueCorrection) + _1148;
  float _1167 = ((mad(0.9999996423721313f, _1149, mad(2.0954757928848267e-08f, _1148, (_1147 * 1.862645149230957e-08f))) - _1149) * BlueCorrection) + _1149;

  SetTonemappedAP1(_1165, _1166, _1167);

  float _1180 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1167, mad((WorkingColorSpace_FromAP1[0].y), _1166, ((WorkingColorSpace_FromAP1[0].x) * _1165)))));
  float _1181 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1167, mad((WorkingColorSpace_FromAP1[1].y), _1166, ((WorkingColorSpace_FromAP1[1].x) * _1165)))));
  float _1182 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1167, mad((WorkingColorSpace_FromAP1[2].y), _1166, ((WorkingColorSpace_FromAP1[2].x) * _1165)))));
  if (_1180 < 0.0031306699384003878f) {
    _1193 = (_1180 * 12.920000076293945f);
  } else {
    _1193 = (((pow(_1180, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1181 < 0.0031306699384003878f) {
    _1204 = (_1181 * 12.920000076293945f);
  } else {
    _1204 = (((pow(_1181, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1182 < 0.0031306699384003878f) {
    _1215 = (_1182 * 12.920000076293945f);
  } else {
    _1215 = (((pow(_1182, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1219 = (_1204 * 0.9375f) + 0.03125f;
  float _1226 = _1215 * 15.0f;
  float _1227 = floor(_1226);
  float _1228 = _1226 - _1227;
  float _1230 = (_1227 + ((_1193 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1233 = Textures_1.SampleLevel(Samplers_1, float2(_1230, _1219), 0.0f);
  float _1237 = _1230 + 0.0625f;
  float4 _1238 = Textures_1.SampleLevel(Samplers_1, float2(_1237, _1219), 0.0f);
  float4 _1260 = Textures_2.SampleLevel(Samplers_2, float2(_1230, _1219), 0.0f);
  float4 _1264 = Textures_2.SampleLevel(Samplers_2, float2(_1237, _1219), 0.0f);
  float4 _1286 = Textures_3.SampleLevel(Samplers_3, float2(_1230, _1219), 0.0f);
  float4 _1290 = Textures_3.SampleLevel(Samplers_3, float2(_1237, _1219), 0.0f);
  float _1309 = max(6.103519990574569e-05f, (((((lerp(_1233.x, _1238.x, _1228)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1193)) + ((lerp(_1260.x, _1264.x, _1228)) * (LUTWeights[0].z))) + ((lerp(_1286.x, _1290.x, _1228)) * (LUTWeights[0].w))));
  float _1310 = max(6.103519990574569e-05f, (((((lerp(_1233.y, _1238.y, _1228)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1204)) + ((lerp(_1260.y, _1264.y, _1228)) * (LUTWeights[0].z))) + ((lerp(_1286.y, _1290.y, _1228)) * (LUTWeights[0].w))));
  float _1311 = max(6.103519990574569e-05f, (((((lerp(_1233.z, _1238.z, _1228)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1215)) + ((lerp(_1260.z, _1264.z, _1228)) * (LUTWeights[0].z))) + ((lerp(_1286.z, _1290.z, _1228)) * (LUTWeights[0].w))));
  float _1333 = select((_1309 > 0.040449999272823334f), exp2(log2((_1309 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1309 * 0.07739938050508499f));
  float _1334 = select((_1310 > 0.040449999272823334f), exp2(log2((_1310 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1310 * 0.07739938050508499f));
  float _1335 = select((_1311 > 0.040449999272823334f), exp2(log2((_1311 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1311 * 0.07739938050508499f));
  float _1361 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1333)) * _1333) + MappingPolynomial.z);
  float _1362 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1334)) * _1334) + MappingPolynomial.z);
  float _1363 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1335)) * _1335) + MappingPolynomial.z);
  float _1370 = ((OverlayColor.x - _1361) * OverlayColor.w) + _1361;
  float _1371 = ((OverlayColor.y - _1362) * OverlayColor.w) + _1362;
  float _1372 = ((OverlayColor.z - _1363) * OverlayColor.w) + _1363;
  float _1373 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _807, mad((WorkingColorSpace_FromAP1[0].y), _805, (_803 * (WorkingColorSpace_FromAP1[0].x))));
  float _1374 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _807, mad((WorkingColorSpace_FromAP1[1].y), _805, ((WorkingColorSpace_FromAP1[1].x) * _803)));
  float _1375 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _807, mad((WorkingColorSpace_FromAP1[2].y), _805, ((WorkingColorSpace_FromAP1[2].x) * _803)));
  float _1382 = ((OverlayColor.x - _1373) * OverlayColor.w) + _1373;
  float _1383 = ((OverlayColor.y - _1374) * OverlayColor.w) + _1374;
  float _1384 = ((OverlayColor.z - _1375) * OverlayColor.w) + _1375;
  float _1396 = exp2(log2(max(0.0f, _1370)) * InverseGamma.y);
  float _1397 = exp2(log2(max(0.0f, _1371)) * InverseGamma.y);
  float _1398 = exp2(log2(max(0.0f, _1372)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1396, _1397, _1398), OutputDevice);
    return;
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1421 = mad((WorkingColorSpace_ToAP1[0].z), _1398, mad((WorkingColorSpace_ToAP1[0].y), _1397, ((WorkingColorSpace_ToAP1[0].x) * _1396)));
        float _1424 = mad((WorkingColorSpace_ToAP1[1].z), _1398, mad((WorkingColorSpace_ToAP1[1].y), _1397, ((WorkingColorSpace_ToAP1[1].x) * _1396)));
        float _1427 = mad((WorkingColorSpace_ToAP1[2].z), _1398, mad((WorkingColorSpace_ToAP1[2].y), _1397, ((WorkingColorSpace_ToAP1[2].x) * _1396)));
        _1438 = mad(_61, _1427, mad(_60, _1424, (_1421 * _59)));
        _1439 = mad(_64, _1427, mad(_63, _1424, (_1421 * _62)));
        _1440 = mad(_67, _1427, mad(_66, _1424, (_1421 * _65)));
      } else {
        _1438 = _1396;
        _1439 = _1397;
        _1440 = _1398;
      }
      do {
        if (_1438 < 0.0031306699384003878f) {
          _1451 = (_1438 * 12.920000076293945f);
        } else {
          _1451 = (((pow(_1438, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1439 < 0.0031306699384003878f) {
            _1462 = (_1439 * 12.920000076293945f);
          } else {
            _1462 = (((pow(_1439, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1440 < 0.0031306699384003878f) {
            _2818 = _1451;
            _2819 = _1462;
            _2820 = (_1440 * 12.920000076293945f);
          } else {
            _2818 = _1451;
            _2819 = _1462;
            _2820 = (((pow(_1440, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1489 = mad((WorkingColorSpace_ToAP1[0].z), _1398, mad((WorkingColorSpace_ToAP1[0].y), _1397, ((WorkingColorSpace_ToAP1[0].x) * _1396)));
      float _1492 = mad((WorkingColorSpace_ToAP1[1].z), _1398, mad((WorkingColorSpace_ToAP1[1].y), _1397, ((WorkingColorSpace_ToAP1[1].x) * _1396)));
      float _1495 = mad((WorkingColorSpace_ToAP1[2].z), _1398, mad((WorkingColorSpace_ToAP1[2].y), _1397, ((WorkingColorSpace_ToAP1[2].x) * _1396)));
      float _1505 = max(6.103519990574569e-05f, mad(_61, _1495, mad(_60, _1492, (_1489 * _59))));
      float _1506 = max(6.103519990574569e-05f, mad(_64, _1495, mad(_63, _1492, (_1489 * _62))));
      float _1507 = max(6.103519990574569e-05f, mad(_67, _1495, mad(_66, _1492, (_1489 * _65))));
      _2818 = min((_1505 * 4.5f), ((exp2(log2(max(_1505, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2819 = min((_1506 * 4.5f), ((exp2(log2(max(_1506, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2820 = min((_1507 * 4.5f), ((exp2(log2(max(_1507, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        _17[0] = ACESCoefsLow_0.x;
        _17[1] = ACESCoefsLow_0.y;
        _17[2] = ACESCoefsLow_0.z;
        _17[3] = ACESCoefsLow_0.w;
        _17[4] = ACESCoefsLow_4;
        _17[5] = ACESCoefsLow_4;
        _18[0] = ACESCoefsHigh_0.x;
        _18[1] = ACESCoefsHigh_0.y;
        _18[2] = ACESCoefsHigh_0.z;
        _18[3] = ACESCoefsHigh_0.w;
        _18[4] = ACESCoefsHigh_4;
        _18[5] = ACESCoefsHigh_4;
        float _1582 = ACESSceneColorMultiplier * _1382;
        float _1583 = ACESSceneColorMultiplier * _1383;
        float _1584 = ACESSceneColorMultiplier * _1384;
        float _1587 = mad((WorkingColorSpace_ToAP0[0].z), _1584, mad((WorkingColorSpace_ToAP0[0].y), _1583, ((WorkingColorSpace_ToAP0[0].x) * _1582)));
        float _1590 = mad((WorkingColorSpace_ToAP0[1].z), _1584, mad((WorkingColorSpace_ToAP0[1].y), _1583, ((WorkingColorSpace_ToAP0[1].x) * _1582)));
        float _1593 = mad((WorkingColorSpace_ToAP0[2].z), _1584, mad((WorkingColorSpace_ToAP0[2].y), _1583, ((WorkingColorSpace_ToAP0[2].x) * _1582)));
        float _1597 = max(max(_1587, _1590), _1593);
        float _1602 = (max(_1597, 1.000000013351432e-10f) - max(min(min(_1587, _1590), _1593), 1.000000013351432e-10f)) / max(_1597, 0.009999999776482582f);
        float _1615 = ((_1590 + _1587) + _1593) + (sqrt((((_1593 - _1590) * _1593) + ((_1590 - _1587) * _1590)) + ((_1587 - _1593) * _1587)) * 1.75f);
        float _1616 = _1615 * 0.3333333432674408f;
        float _1617 = _1602 + -0.4000000059604645f;
        float _1618 = _1617 * 5.0f;
        float _1622 = max((1.0f - abs(_1617 * 2.5f)), 0.0f);
        float _1633 = ((float(((int)(uint)((bool)(_1618 > 0.0f))) - ((int)(uint)((bool)(_1618 < 0.0f)))) * (1.0f - (_1622 * _1622))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1616 <= 0.0533333346247673f)) {
            if (!(_1616 >= 0.1599999964237213f)) {
              _1642 = (((0.23999999463558197f / _1615) + -0.5f) * _1633);
            } else {
              _1642 = 0.0f;
            }
          } else {
            _1642 = _1633;
          }
          float _1643 = _1642 + 1.0f;
          float _1644 = _1643 * _1587;
          float _1645 = _1643 * _1590;
          float _1646 = _1643 * _1593;
          do {
            if (!((bool)(_1644 == _1645) && (bool)(_1645 == _1646))) {
              float _1653 = ((_1644 * 2.0f) - _1645) - _1646;
              float _1656 = ((_1590 - _1593) * 1.7320507764816284f) * _1643;
              float _1658 = atan(_1656 / _1653);
              bool _1661 = (_1653 < 0.0f);
              bool _1662 = (_1653 == 0.0f);
              bool _1663 = (_1656 >= 0.0f);
              bool _1664 = (_1656 < 0.0f);
              _1675 = select((_1663 && _1662), 90.0f, select((_1664 && _1662), -90.0f, (select((_1664 && _1661), (_1658 + -3.1415927410125732f), select((_1663 && _1661), (_1658 + 3.1415927410125732f), _1658)) * 57.2957763671875f)));
            } else {
              _1675 = 0.0f;
            }
            float _1680 = min(max(select((_1675 < 0.0f), (_1675 + 360.0f), _1675), 0.0f), 360.0f);
            do {
              if (_1680 < -180.0f) {
                _1689 = (_1680 + 360.0f);
              } else {
                if (_1680 > 180.0f) {
                  _1689 = (_1680 + -360.0f);
                } else {
                  _1689 = _1680;
                }
              }
              do {
                if ((bool)(_1689 > -67.5f) && (bool)(_1689 < 67.5f)) {
                  float _1695 = (_1689 + 67.5f) * 0.029629629105329514f;
                  int _1696 = int(_1695);
                  float _1698 = _1695 - float(_1696);
                  float _1699 = _1698 * _1698;
                  float _1700 = _1699 * _1698;
                  if (_1696 == 3) {
                    _1728 = (((0.1666666716337204f - (_1698 * 0.5f)) + (_1699 * 0.5f)) - (_1700 * 0.1666666716337204f));
                  } else {
                    if (_1696 == 2) {
                      _1728 = ((0.6666666865348816f - _1699) + (_1700 * 0.5f));
                    } else {
                      if (_1696 == 1) {
                        _1728 = (((_1700 * -0.5f) + 0.1666666716337204f) + ((_1699 + _1698) * 0.5f));
                      } else {
                        _1728 = select((_1696 == 0), (_1700 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1728 = 0.0f;
                }
                float _1737 = min(max(((((_1602 * 0.27000001072883606f) * (0.029999999329447746f - _1644)) * _1728) + _1644), 0.0f), 65535.0f);
                float _1738 = min(max(_1645, 0.0f), 65535.0f);
                float _1739 = min(max(_1646, 0.0f), 65535.0f);
                float _1752 = min(max(mad(-0.21492856740951538f, _1739, mad(-0.2365107536315918f, _1738, (_1737 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1753 = min(max(mad(-0.09967592358589172f, _1739, mad(1.17622971534729f, _1738, (_1737 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1754 = min(max(mad(0.9977163076400757f, _1739, mad(-0.006032449658960104f, _1738, (_1737 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1755 = dot(float3(_1752, _1753, _1754), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1766 = log2(max((lerp(_1755, _1752, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1767 = _1766 * 0.3010300099849701f;
                float _1768 = log2(ACESMinMaxData.x);
                float _1769 = _1768 * 0.3010300099849701f;
                do {
                  if (!(!(_1767 <= _1769))) {
                    _1838 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1776 = log2(ACESMidData.x);
                    float _1777 = _1776 * 0.3010300099849701f;
                    if ((bool)(_1767 > _1769) && (bool)(_1767 < _1777)) {
                      float _1785 = ((_1766 - _1768) * 0.9030900001525879f) / ((_1776 - _1768) * 0.3010300099849701f);
                      int _1786 = int(_1785);
                      float _1788 = _1785 - float(_1786);
                      float _1790 = _17[_1786];
                      float _1793 = _17[(_1786 + 1)];
                      float _1798 = _1790 * 0.5f;
                      _1838 = dot(float3((_1788 * _1788), _1788, 1.0f), float3(mad((_17[(_1786 + 2)]), 0.5f, mad(_1793, -1.0f, _1798)), (_1793 - _1790), mad(_1793, 0.5f, _1798)));
                    } else {
                      do {
                        if (!(!(_1767 >= _1777))) {
                          float _1807 = log2(ACESMinMaxData.z);
                          if (_1767 < (_1807 * 0.3010300099849701f)) {
                            float _1815 = ((_1766 - _1776) * 0.9030900001525879f) / ((_1807 - _1776) * 0.3010300099849701f);
                            int _1816 = int(_1815);
                            float _1818 = _1815 - float(_1816);
                            float _1820 = _18[_1816];
                            float _1823 = _18[(_1816 + 1)];
                            float _1828 = _1820 * 0.5f;
                            _1838 = dot(float3((_1818 * _1818), _1818, 1.0f), float3(mad((_18[(_1816 + 2)]), 0.5f, mad(_1823, -1.0f, _1828)), (_1823 - _1820), mad(_1823, 0.5f, _1828)));
                            break;
                          }
                        }
                        _1838 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1842 = log2(max((lerp(_1755, _1753, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1843 = _1842 * 0.3010300099849701f;
                  do {
                    if (!(!(_1843 <= _1769))) {
                      _1912 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1850 = log2(ACESMidData.x);
                      float _1851 = _1850 * 0.3010300099849701f;
                      if ((bool)(_1843 > _1769) && (bool)(_1843 < _1851)) {
                        float _1859 = ((_1842 - _1768) * 0.9030900001525879f) / ((_1850 - _1768) * 0.3010300099849701f);
                        int _1860 = int(_1859);
                        float _1862 = _1859 - float(_1860);
                        float _1864 = _17[_1860];
                        float _1867 = _17[(_1860 + 1)];
                        float _1872 = _1864 * 0.5f;
                        _1912 = dot(float3((_1862 * _1862), _1862, 1.0f), float3(mad((_17[(_1860 + 2)]), 0.5f, mad(_1867, -1.0f, _1872)), (_1867 - _1864), mad(_1867, 0.5f, _1872)));
                      } else {
                        do {
                          if (!(!(_1843 >= _1851))) {
                            float _1881 = log2(ACESMinMaxData.z);
                            if (_1843 < (_1881 * 0.3010300099849701f)) {
                              float _1889 = ((_1842 - _1850) * 0.9030900001525879f) / ((_1881 - _1850) * 0.3010300099849701f);
                              int _1890 = int(_1889);
                              float _1892 = _1889 - float(_1890);
                              float _1894 = _18[_1890];
                              float _1897 = _18[(_1890 + 1)];
                              float _1902 = _1894 * 0.5f;
                              _1912 = dot(float3((_1892 * _1892), _1892, 1.0f), float3(mad((_18[(_1890 + 2)]), 0.5f, mad(_1897, -1.0f, _1902)), (_1897 - _1894), mad(_1897, 0.5f, _1902)));
                              break;
                            }
                          }
                          _1912 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1916 = log2(max((lerp(_1755, _1754, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1917 = _1916 * 0.3010300099849701f;
                    do {
                      if (!(!(_1917 <= _1769))) {
                        _1986 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1924 = log2(ACESMidData.x);
                        float _1925 = _1924 * 0.3010300099849701f;
                        if ((bool)(_1917 > _1769) && (bool)(_1917 < _1925)) {
                          float _1933 = ((_1916 - _1768) * 0.9030900001525879f) / ((_1924 - _1768) * 0.3010300099849701f);
                          int _1934 = int(_1933);
                          float _1936 = _1933 - float(_1934);
                          float _1938 = _17[_1934];
                          float _1941 = _17[(_1934 + 1)];
                          float _1946 = _1938 * 0.5f;
                          _1986 = dot(float3((_1936 * _1936), _1936, 1.0f), float3(mad((_17[(_1934 + 2)]), 0.5f, mad(_1941, -1.0f, _1946)), (_1941 - _1938), mad(_1941, 0.5f, _1946)));
                        } else {
                          do {
                            if (!(!(_1917 >= _1925))) {
                              float _1955 = log2(ACESMinMaxData.z);
                              if (_1917 < (_1955 * 0.3010300099849701f)) {
                                float _1963 = ((_1916 - _1924) * 0.9030900001525879f) / ((_1955 - _1924) * 0.3010300099849701f);
                                int _1964 = int(_1963);
                                float _1966 = _1963 - float(_1964);
                                float _1968 = _18[_1964];
                                float _1971 = _18[(_1964 + 1)];
                                float _1976 = _1968 * 0.5f;
                                _1986 = dot(float3((_1966 * _1966), _1966, 1.0f), float3(mad((_18[(_1964 + 2)]), 0.5f, mad(_1971, -1.0f, _1976)), (_1971 - _1968), mad(_1971, 0.5f, _1976)));
                                break;
                              }
                            }
                            _1986 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1990 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1991 = (exp2(_1838 * 3.321928024291992f) - ACESMinMaxData.y) / _1990;
                      float _1993 = (exp2(_1912 * 3.321928024291992f) - ACESMinMaxData.y) / _1990;
                      float _1995 = (exp2(_1986 * 3.321928024291992f) - ACESMinMaxData.y) / _1990;
                      float _1998 = mad(0.15618768334388733f, _1995, mad(0.13400420546531677f, _1993, (_1991 * 0.6624541878700256f)));
                      float _2001 = mad(0.053689517080783844f, _1995, mad(0.6740817427635193f, _1993, (_1991 * 0.2722287178039551f)));
                      float _2004 = mad(1.0103391408920288f, _1995, mad(0.00406073359772563f, _1993, (_1991 * -0.005574649665504694f)));
                      float _2017 = min(max(mad(-0.23642469942569733f, _2004, mad(-0.32480329275131226f, _2001, (_1998 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _2018 = min(max(mad(0.016756348311901093f, _2004, mad(1.6153316497802734f, _2001, (_1998 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _2019 = min(max(mad(0.9883948564529419f, _2004, mad(-0.008284442126750946f, _2001, (_1998 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _2022 = mad(0.15618768334388733f, _2019, mad(0.13400420546531677f, _2018, (_2017 * 0.6624541878700256f)));
                      float _2025 = mad(0.053689517080783844f, _2019, mad(0.6740817427635193f, _2018, (_2017 * 0.2722287178039551f)));
                      float _2028 = mad(1.0103391408920288f, _2019, mad(0.00406073359772563f, _2018, (_2017 * -0.005574649665504694f)));
                      float _2050 = min(max((min(max(mad(-0.23642469942569733f, _2028, mad(-0.32480329275131226f, _2025, (_2022 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2051 = min(max((min(max(mad(0.016756348311901093f, _2028, mad(1.6153316497802734f, _2025, (_2022 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2052 = min(max((min(max(mad(0.9883948564529419f, _2028, mad(-0.008284442126750946f, _2025, (_2022 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(OutputDevice) == 5)) {
                          _2065 = mad(_61, _2052, mad(_60, _2051, (_2050 * _59)));
                          _2066 = mad(_64, _2052, mad(_63, _2051, (_2050 * _62)));
                          _2067 = mad(_67, _2052, mad(_66, _2051, (_2050 * _65)));
                        } else {
                          _2065 = _2050;
                          _2066 = _2051;
                          _2067 = _2052;
                        }
                        float _2077 = exp2(log2(_2065 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2078 = exp2(log2(_2066 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2079 = exp2(log2(_2067 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2818 = exp2(log2((1.0f / ((_2077 * 18.6875f) + 1.0f)) * ((_2077 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2819 = exp2(log2((1.0f / ((_2078 * 18.6875f) + 1.0f)) * ((_2078 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2820 = exp2(log2((1.0f / ((_2079 * 18.6875f) + 1.0f)) * ((_2079 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          _15[0] = ACESCoefsLow_0.x;
          _15[1] = ACESCoefsLow_0.y;
          _15[2] = ACESCoefsLow_0.z;
          _15[3] = ACESCoefsLow_0.w;
          _15[4] = ACESCoefsLow_4;
          _15[5] = ACESCoefsLow_4;
          _16[0] = ACESCoefsHigh_0.x;
          _16[1] = ACESCoefsHigh_0.y;
          _16[2] = ACESCoefsHigh_0.z;
          _16[3] = ACESCoefsHigh_0.w;
          _16[4] = ACESCoefsHigh_4;
          _16[5] = ACESCoefsHigh_4;
          float _2156 = ACESSceneColorMultiplier * _1382;
          float _2157 = ACESSceneColorMultiplier * _1383;
          float _2158 = ACESSceneColorMultiplier * _1384;
          float _2161 = mad((WorkingColorSpace_ToAP0[0].z), _2158, mad((WorkingColorSpace_ToAP0[0].y), _2157, ((WorkingColorSpace_ToAP0[0].x) * _2156)));
          float _2164 = mad((WorkingColorSpace_ToAP0[1].z), _2158, mad((WorkingColorSpace_ToAP0[1].y), _2157, ((WorkingColorSpace_ToAP0[1].x) * _2156)));
          float _2167 = mad((WorkingColorSpace_ToAP0[2].z), _2158, mad((WorkingColorSpace_ToAP0[2].y), _2157, ((WorkingColorSpace_ToAP0[2].x) * _2156)));
          float _2171 = max(max(_2161, _2164), _2167);
          float _2176 = (max(_2171, 1.000000013351432e-10f) - max(min(min(_2161, _2164), _2167), 1.000000013351432e-10f)) / max(_2171, 0.009999999776482582f);
          float _2189 = ((_2164 + _2161) + _2167) + (sqrt((((_2167 - _2164) * _2167) + ((_2164 - _2161) * _2164)) + ((_2161 - _2167) * _2161)) * 1.75f);
          float _2190 = _2189 * 0.3333333432674408f;
          float _2191 = _2176 + -0.4000000059604645f;
          float _2192 = _2191 * 5.0f;
          float _2196 = max((1.0f - abs(_2191 * 2.5f)), 0.0f);
          float _2207 = ((float(((int)(uint)((bool)(_2192 > 0.0f))) - ((int)(uint)((bool)(_2192 < 0.0f)))) * (1.0f - (_2196 * _2196))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2190 <= 0.0533333346247673f)) {
              if (!(_2190 >= 0.1599999964237213f)) {
                _2216 = (((0.23999999463558197f / _2189) + -0.5f) * _2207);
              } else {
                _2216 = 0.0f;
              }
            } else {
              _2216 = _2207;
            }
            float _2217 = _2216 + 1.0f;
            float _2218 = _2217 * _2161;
            float _2219 = _2217 * _2164;
            float _2220 = _2217 * _2167;
            do {
              if (!((bool)(_2218 == _2219) && (bool)(_2219 == _2220))) {
                float _2227 = ((_2218 * 2.0f) - _2219) - _2220;
                float _2230 = ((_2164 - _2167) * 1.7320507764816284f) * _2217;
                float _2232 = atan(_2230 / _2227);
                bool _2235 = (_2227 < 0.0f);
                bool _2236 = (_2227 == 0.0f);
                bool _2237 = (_2230 >= 0.0f);
                bool _2238 = (_2230 < 0.0f);
                _2249 = select((_2237 && _2236), 90.0f, select((_2238 && _2236), -90.0f, (select((_2238 && _2235), (_2232 + -3.1415927410125732f), select((_2237 && _2235), (_2232 + 3.1415927410125732f), _2232)) * 57.2957763671875f)));
              } else {
                _2249 = 0.0f;
              }
              float _2254 = min(max(select((_2249 < 0.0f), (_2249 + 360.0f), _2249), 0.0f), 360.0f);
              do {
                if (_2254 < -180.0f) {
                  _2263 = (_2254 + 360.0f);
                } else {
                  if (_2254 > 180.0f) {
                    _2263 = (_2254 + -360.0f);
                  } else {
                    _2263 = _2254;
                  }
                }
                do {
                  if ((bool)(_2263 > -67.5f) && (bool)(_2263 < 67.5f)) {
                    float _2269 = (_2263 + 67.5f) * 0.029629629105329514f;
                    int _2270 = int(_2269);
                    float _2272 = _2269 - float(_2270);
                    float _2273 = _2272 * _2272;
                    float _2274 = _2273 * _2272;
                    if (_2270 == 3) {
                      _2302 = (((0.1666666716337204f - (_2272 * 0.5f)) + (_2273 * 0.5f)) - (_2274 * 0.1666666716337204f));
                    } else {
                      if (_2270 == 2) {
                        _2302 = ((0.6666666865348816f - _2273) + (_2274 * 0.5f));
                      } else {
                        if (_2270 == 1) {
                          _2302 = (((_2274 * -0.5f) + 0.1666666716337204f) + ((_2273 + _2272) * 0.5f));
                        } else {
                          _2302 = select((_2270 == 0), (_2274 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2302 = 0.0f;
                  }
                  float _2311 = min(max(((((_2176 * 0.27000001072883606f) * (0.029999999329447746f - _2218)) * _2302) + _2218), 0.0f), 65535.0f);
                  float _2312 = min(max(_2219, 0.0f), 65535.0f);
                  float _2313 = min(max(_2220, 0.0f), 65535.0f);
                  float _2326 = min(max(mad(-0.21492856740951538f, _2313, mad(-0.2365107536315918f, _2312, (_2311 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2327 = min(max(mad(-0.09967592358589172f, _2313, mad(1.17622971534729f, _2312, (_2311 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2328 = min(max(mad(0.9977163076400757f, _2313, mad(-0.006032449658960104f, _2312, (_2311 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2329 = dot(float3(_2326, _2327, _2328), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2340 = log2(max((lerp(_2329, _2326, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2341 = _2340 * 0.3010300099849701f;
                  float _2342 = log2(ACESMinMaxData.x);
                  float _2343 = _2342 * 0.3010300099849701f;
                  do {
                    if (!(!(_2341 <= _2343))) {
                      _2412 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2350 = log2(ACESMidData.x);
                      float _2351 = _2350 * 0.3010300099849701f;
                      if ((bool)(_2341 > _2343) && (bool)(_2341 < _2351)) {
                        float _2359 = ((_2340 - _2342) * 0.9030900001525879f) / ((_2350 - _2342) * 0.3010300099849701f);
                        int _2360 = int(_2359);
                        float _2362 = _2359 - float(_2360);
                        float _2364 = _15[_2360];
                        float _2367 = _15[(_2360 + 1)];
                        float _2372 = _2364 * 0.5f;
                        _2412 = dot(float3((_2362 * _2362), _2362, 1.0f), float3(mad((_15[(_2360 + 2)]), 0.5f, mad(_2367, -1.0f, _2372)), (_2367 - _2364), mad(_2367, 0.5f, _2372)));
                      } else {
                        do {
                          if (!(!(_2341 >= _2351))) {
                            float _2381 = log2(ACESMinMaxData.z);
                            if (_2341 < (_2381 * 0.3010300099849701f)) {
                              float _2389 = ((_2340 - _2350) * 0.9030900001525879f) / ((_2381 - _2350) * 0.3010300099849701f);
                              int _2390 = int(_2389);
                              float _2392 = _2389 - float(_2390);
                              float _2394 = _16[_2390];
                              float _2397 = _16[(_2390 + 1)];
                              float _2402 = _2394 * 0.5f;
                              _2412 = dot(float3((_2392 * _2392), _2392, 1.0f), float3(mad((_16[(_2390 + 2)]), 0.5f, mad(_2397, -1.0f, _2402)), (_2397 - _2394), mad(_2397, 0.5f, _2402)));
                              break;
                            }
                          }
                          _2412 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2416 = log2(max((lerp(_2329, _2327, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2417 = _2416 * 0.3010300099849701f;
                    do {
                      if (!(!(_2417 <= _2343))) {
                        _2486 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2424 = log2(ACESMidData.x);
                        float _2425 = _2424 * 0.3010300099849701f;
                        if ((bool)(_2417 > _2343) && (bool)(_2417 < _2425)) {
                          float _2433 = ((_2416 - _2342) * 0.9030900001525879f) / ((_2424 - _2342) * 0.3010300099849701f);
                          int _2434 = int(_2433);
                          float _2436 = _2433 - float(_2434);
                          float _2438 = _15[_2434];
                          float _2441 = _15[(_2434 + 1)];
                          float _2446 = _2438 * 0.5f;
                          _2486 = dot(float3((_2436 * _2436), _2436, 1.0f), float3(mad((_15[(_2434 + 2)]), 0.5f, mad(_2441, -1.0f, _2446)), (_2441 - _2438), mad(_2441, 0.5f, _2446)));
                        } else {
                          do {
                            if (!(!(_2417 >= _2425))) {
                              float _2455 = log2(ACESMinMaxData.z);
                              if (_2417 < (_2455 * 0.3010300099849701f)) {
                                float _2463 = ((_2416 - _2424) * 0.9030900001525879f) / ((_2455 - _2424) * 0.3010300099849701f);
                                int _2464 = int(_2463);
                                float _2466 = _2463 - float(_2464);
                                float _2468 = _16[_2464];
                                float _2471 = _16[(_2464 + 1)];
                                float _2476 = _2468 * 0.5f;
                                _2486 = dot(float3((_2466 * _2466), _2466, 1.0f), float3(mad((_16[(_2464 + 2)]), 0.5f, mad(_2471, -1.0f, _2476)), (_2471 - _2468), mad(_2471, 0.5f, _2476)));
                                break;
                              }
                            }
                            _2486 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2490 = log2(max((lerp(_2329, _2328, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2491 = _2490 * 0.3010300099849701f;
                      do {
                        if (!(!(_2491 <= _2343))) {
                          _2560 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2498 = log2(ACESMidData.x);
                          float _2499 = _2498 * 0.3010300099849701f;
                          if ((bool)(_2491 > _2343) && (bool)(_2491 < _2499)) {
                            float _2507 = ((_2490 - _2342) * 0.9030900001525879f) / ((_2498 - _2342) * 0.3010300099849701f);
                            int _2508 = int(_2507);
                            float _2510 = _2507 - float(_2508);
                            float _2512 = _15[_2508];
                            float _2515 = _15[(_2508 + 1)];
                            float _2520 = _2512 * 0.5f;
                            _2560 = dot(float3((_2510 * _2510), _2510, 1.0f), float3(mad((_15[(_2508 + 2)]), 0.5f, mad(_2515, -1.0f, _2520)), (_2515 - _2512), mad(_2515, 0.5f, _2520)));
                          } else {
                            do {
                              if (!(!(_2491 >= _2499))) {
                                float _2529 = log2(ACESMinMaxData.z);
                                if (_2491 < (_2529 * 0.3010300099849701f)) {
                                  float _2537 = ((_2490 - _2498) * 0.9030900001525879f) / ((_2529 - _2498) * 0.3010300099849701f);
                                  int _2538 = int(_2537);
                                  float _2540 = _2537 - float(_2538);
                                  float _2542 = _16[_2538];
                                  float _2545 = _16[(_2538 + 1)];
                                  float _2550 = _2542 * 0.5f;
                                  _2560 = dot(float3((_2540 * _2540), _2540, 1.0f), float3(mad((_16[(_2538 + 2)]), 0.5f, mad(_2545, -1.0f, _2550)), (_2545 - _2542), mad(_2545, 0.5f, _2550)));
                                  break;
                                }
                              }
                              _2560 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2564 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2565 = (exp2(_2412 * 3.321928024291992f) - ACESMinMaxData.y) / _2564;
                        float _2567 = (exp2(_2486 * 3.321928024291992f) - ACESMinMaxData.y) / _2564;
                        float _2569 = (exp2(_2560 * 3.321928024291992f) - ACESMinMaxData.y) / _2564;
                        float _2572 = mad(0.15618768334388733f, _2569, mad(0.13400420546531677f, _2567, (_2565 * 0.6624541878700256f)));
                        float _2575 = mad(0.053689517080783844f, _2569, mad(0.6740817427635193f, _2567, (_2565 * 0.2722287178039551f)));
                        float _2578 = mad(1.0103391408920288f, _2569, mad(0.00406073359772563f, _2567, (_2565 * -0.005574649665504694f)));
                        float _2591 = min(max(mad(-0.23642469942569733f, _2578, mad(-0.32480329275131226f, _2575, (_2572 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2592 = min(max(mad(0.016756348311901093f, _2578, mad(1.6153316497802734f, _2575, (_2572 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2593 = min(max(mad(0.9883948564529419f, _2578, mad(-0.008284442126750946f, _2575, (_2572 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2596 = mad(0.15618768334388733f, _2593, mad(0.13400420546531677f, _2592, (_2591 * 0.6624541878700256f)));
                        float _2599 = mad(0.053689517080783844f, _2593, mad(0.6740817427635193f, _2592, (_2591 * 0.2722287178039551f)));
                        float _2602 = mad(1.0103391408920288f, _2593, mad(0.00406073359772563f, _2592, (_2591 * -0.005574649665504694f)));
                        float _2624 = min(max((min(max(mad(-0.23642469942569733f, _2602, mad(-0.32480329275131226f, _2599, (_2596 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2625 = min(max((min(max(mad(0.016756348311901093f, _2602, mad(1.6153316497802734f, _2599, (_2596 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2626 = min(max((min(max(mad(0.9883948564529419f, _2602, mad(-0.008284442126750946f, _2599, (_2596 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 6)) {
                            _2639 = mad(_61, _2626, mad(_60, _2625, (_2624 * _59)));
                            _2640 = mad(_64, _2626, mad(_63, _2625, (_2624 * _62)));
                            _2641 = mad(_67, _2626, mad(_66, _2625, (_2624 * _65)));
                          } else {
                            _2639 = _2624;
                            _2640 = _2625;
                            _2641 = _2626;
                          }
                          float _2651 = exp2(log2(_2639 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2652 = exp2(log2(_2640 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2653 = exp2(log2(_2641 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2818 = exp2(log2((1.0f / ((_2651 * 18.6875f) + 1.0f)) * ((_2651 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2819 = exp2(log2((1.0f / ((_2652 * 18.6875f) + 1.0f)) * ((_2652 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2820 = exp2(log2((1.0f / ((_2653 * 18.6875f) + 1.0f)) * ((_2653 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2698 = mad((WorkingColorSpace_ToAP1[0].z), _1384, mad((WorkingColorSpace_ToAP1[0].y), _1383, ((WorkingColorSpace_ToAP1[0].x) * _1382)));
            float _2701 = mad((WorkingColorSpace_ToAP1[1].z), _1384, mad((WorkingColorSpace_ToAP1[1].y), _1383, ((WorkingColorSpace_ToAP1[1].x) * _1382)));
            float _2704 = mad((WorkingColorSpace_ToAP1[2].z), _1384, mad((WorkingColorSpace_ToAP1[2].y), _1383, ((WorkingColorSpace_ToAP1[2].x) * _1382)));
            float _2723 = exp2(log2(mad(_61, _2704, mad(_60, _2701, (_2698 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2724 = exp2(log2(mad(_64, _2704, mad(_63, _2701, (_2698 * _62))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2725 = exp2(log2(mad(_67, _2704, mad(_66, _2701, (_2698 * _65))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2818 = exp2(log2((1.0f / ((_2723 * 18.6875f) + 1.0f)) * ((_2723 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2819 = exp2(log2((1.0f / ((_2724 * 18.6875f) + 1.0f)) * ((_2724 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2820 = exp2(log2((1.0f / ((_2725 * 18.6875f) + 1.0f)) * ((_2725 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2772 = mad((WorkingColorSpace_ToAP1[0].z), _1372, mad((WorkingColorSpace_ToAP1[0].y), _1371, ((WorkingColorSpace_ToAP1[0].x) * _1370)));
                float _2775 = mad((WorkingColorSpace_ToAP1[1].z), _1372, mad((WorkingColorSpace_ToAP1[1].y), _1371, ((WorkingColorSpace_ToAP1[1].x) * _1370)));
                float _2778 = mad((WorkingColorSpace_ToAP1[2].z), _1372, mad((WorkingColorSpace_ToAP1[2].y), _1371, ((WorkingColorSpace_ToAP1[2].x) * _1370)));
                _2818 = mad(_61, _2778, mad(_60, _2775, (_2772 * _59)));
                _2819 = mad(_64, _2778, mad(_63, _2775, (_2772 * _62)));
                _2820 = mad(_67, _2778, mad(_66, _2775, (_2772 * _65)));
              } else {
                float _2791 = mad((WorkingColorSpace_ToAP1[0].z), _1398, mad((WorkingColorSpace_ToAP1[0].y), _1397, ((WorkingColorSpace_ToAP1[0].x) * _1396)));
                float _2794 = mad((WorkingColorSpace_ToAP1[1].z), _1398, mad((WorkingColorSpace_ToAP1[1].y), _1397, ((WorkingColorSpace_ToAP1[1].x) * _1396)));
                float _2797 = mad((WorkingColorSpace_ToAP1[2].z), _1398, mad((WorkingColorSpace_ToAP1[2].y), _1397, ((WorkingColorSpace_ToAP1[2].x) * _1396)));
                _2818 = exp2(log2(mad(_61, _2797, mad(_60, _2794, (_2791 * _59)))) * InverseGamma.z);
                _2819 = exp2(log2(mad(_64, _2797, mad(_63, _2794, (_2791 * _62)))) * InverseGamma.z);
                _2820 = exp2(log2(mad(_67, _2797, mad(_66, _2794, (_2791 * _65)))) * InverseGamma.z);
              }
            } else {
              _2818 = _1382;
              _2819 = _1383;
              _2820 = _1384;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2818 * 0.9523810148239136f), (_2819 * 0.9523810148239136f), (_2820 * 0.9523810148239136f), 0.0f);
}

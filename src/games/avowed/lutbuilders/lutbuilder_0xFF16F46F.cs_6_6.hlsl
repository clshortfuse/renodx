#include "../common.hlsl"

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

Texture2D<float4> Textures_3 : register(t2);

Texture2D<float4> Textures_4 : register(t3);

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

SamplerState Samplers_4 : register(s3);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _32 = 0.5f / LUTSize;
  float _37 = LUTSize + -1.0f;
  float _38 = (LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _32)) / _37;
  float _39 = (LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _32)) / _37;
  float _41 = float((uint)SV_DispatchThreadID.z) / _37;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _127;
  float _128;
  float _129;
  float _177;
  float _905;
  float _938;
  float _952;
  float _1016;
  float _1195;
  float _1206;
  float _1217;
  float _1467;
  float _1468;
  float _1469;
  float _1480;
  float _1491;
  float _1671;
  float _1704;
  float _1718;
  float _1757;
  float _1867;
  float _1941;
  float _2015;
  float _2094;
  float _2095;
  float _2096;
  float _2245;
  float _2278;
  float _2292;
  float _2331;
  float _2441;
  float _2515;
  float _2589;
  float _2668;
  float _2669;
  float _2670;
  float _2847;
  float _2848;
  float _2849;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _50 = ((uint)(OutputGamut) == 4);
        _61 = select(_50, 1.0f, 1.705051064491272f);
        _62 = select(_50, 0.0f, -0.6217921376228333f);
        _63 = select(_50, 0.0f, -0.0832589864730835f);
        _64 = select(_50, 0.0f, -0.13025647401809692f);
        _65 = select(_50, 1.0f, 1.140804648399353f);
        _66 = select(_50, 0.0f, -0.010548308491706848f);
        _67 = select(_50, 0.0f, -0.024003351107239723f);
        _68 = select(_50, 0.0f, -0.1289689838886261f);
        _69 = select(_50, 1.0f, 1.1529725790023804f);
      } else {
        _61 = 0.6954522132873535f;
        _62 = 0.14067870378494263f;
        _63 = 0.16386906802654266f;
        _64 = 0.044794563204050064f;
        _65 = 0.8596711158752441f;
        _66 = 0.0955343171954155f;
        _67 = -0.005525882821530104f;
        _68 = 0.004025210160762072f;
        _69 = 1.0015007257461548f;
      }
    } else {
      _61 = 1.0258246660232544f;
      _62 = -0.020053181797266006f;
      _63 = -0.005771636962890625f;
      _64 = -0.002234415616840124f;
      _65 = 1.0045864582061768f;
      _66 = -0.002352118492126465f;
      _67 = -0.005013350863009691f;
      _68 = -0.025290070101618767f;
      _69 = 1.0303035974502563f;
    }
  } else {
    _61 = 1.3792141675949097f;
    _62 = -0.30886411666870117f;
    _63 = -0.0703500509262085f;
    _64 = -0.06933490186929703f;
    _65 = 1.08229660987854f;
    _66 = -0.012961871922016144f;
    _67 = -0.0021590073592960835f;
    _68 = -0.0454593189060688f;
    _69 = 1.0476183891296387f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _80 = (pow(_38, 0.012683313339948654f));
    float _81 = (pow(_39, 0.012683313339948654f));
    float _82 = (pow(_41, 0.012683313339948654f));
    _127 = (exp2(log2(max(0.0f, (_80 + -0.8359375f)) / (18.8515625f - (_80 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _128 = (exp2(log2(max(0.0f, (_81 + -0.8359375f)) / (18.8515625f - (_81 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _129 = (exp2(log2(max(0.0f, (_82 + -0.8359375f)) / (18.8515625f - (_82 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _127 = ((exp2((_38 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _128 = ((exp2((_39 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _129 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _156 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _160 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _177 = (((((2967800.0f - (_160 * 4607000064.0f)) * _160) + 99.11000061035156f) * _160) + 0.24406300485134125f);
  } else {
    _177 = (((((1901800.0f - (_160 * 2006400000.0f)) * _160) + 247.47999572753906f) * _160) + 0.23703999817371368f);
  }
  float _191 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _198 = WhiteTemp * WhiteTemp;
  float _201 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_198 * 1.6145605741257896e-07f));
  float _206 = ((_191 * 2.0f) + 4.0f) - (_201 * 8.0f);
  float _207 = (_191 * 3.0f) / _206;
  float _209 = (_201 * 2.0f) / _206;
  bool _210 = (WhiteTemp < 4000.0f);
  float _219 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _221 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_198 * 1.5317699909210205f)) / (_219 * _219);
  float _228 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _198;
  float _230 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_198 * 308.60699462890625f)) / (_228 * _228);
  float _232 = rsqrt(dot(float2(_221, _230), float2(_221, _230)));
  float _233 = WhiteTint * 0.05000000074505806f;
  float _236 = ((_233 * _230) * _232) + _191;
  float _239 = _201 - ((_233 * _221) * _232);
  float _244 = (4.0f - (_239 * 8.0f)) + (_236 * 2.0f);
  float _250 = (((_236 * 3.0f) / _244) - _207) + select(_210, _207, _177);
  float _251 = (((_239 * 2.0f) / _244) - _209) + select(_210, _209, (((_177 * 2.869999885559082f) + -0.2750000059604645f) - ((_177 * _177) * 3.0f)));
  float _252 = select(_156, _250, 0.3127000033855438f);
  float _253 = select(_156, _251, 0.32899999618530273f);
  float _254 = select(_156, 0.3127000033855438f, _250);
  float _255 = select(_156, 0.32899999618530273f, _251);
  float _256 = max(_253, 1.000000013351432e-10f);
  float _257 = _252 / _256;
  float _260 = ((1.0f - _252) - _253) / _256;
  float _261 = max(_255, 1.000000013351432e-10f);
  float _262 = _254 / _261;
  float _265 = ((1.0f - _254) - _255) / _261;
  float _284 = mad(-0.16140000522136688f, _265, ((_262 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _260, ((_257 * 0.8950999975204468f) + 0.266400009393692f));
  float _285 = mad(0.03669999912381172f, _265, (1.7135000228881836f - (_262 * 0.7501999735832214f))) / mad(0.03669999912381172f, _260, (1.7135000228881836f - (_257 * 0.7501999735832214f)));
  float _286 = mad(1.0296000242233276f, _265, ((_262 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _260, ((_257 * 0.03889999911189079f) + -0.06849999725818634f));
  float _287 = mad(_285, -0.7501999735832214f, 0.0f);
  float _288 = mad(_285, 1.7135000228881836f, 0.0f);
  float _289 = mad(_285, 0.03669999912381172f, -0.0f);
  float _290 = mad(_286, 0.03889999911189079f, 0.0f);
  float _291 = mad(_286, -0.06849999725818634f, 0.0f);
  float _292 = mad(_286, 1.0296000242233276f, 0.0f);
  float _295 = mad(0.1599626988172531f, _290, mad(-0.1470542997121811f, _287, (_284 * 0.883457362651825f)));
  float _298 = mad(0.1599626988172531f, _291, mad(-0.1470542997121811f, _288, (_284 * 0.26293492317199707f)));
  float _301 = mad(0.1599626988172531f, _292, mad(-0.1470542997121811f, _289, (_284 * -0.15930065512657166f)));
  float _304 = mad(0.04929120093584061f, _290, mad(0.5183603167533875f, _287, (_284 * 0.38695648312568665f)));
  float _307 = mad(0.04929120093584061f, _291, mad(0.5183603167533875f, _288, (_284 * 0.11516613513231277f)));
  float _310 = mad(0.04929120093584061f, _292, mad(0.5183603167533875f, _289, (_284 * -0.0697740763425827f)));
  float _313 = mad(0.9684867262840271f, _290, mad(0.04004279896616936f, _287, (_284 * -0.007634039502590895f)));
  float _316 = mad(0.9684867262840271f, _291, mad(0.04004279896616936f, _288, (_284 * -0.0022720457054674625f)));
  float _319 = mad(0.9684867262840271f, _292, mad(0.04004279896616936f, _289, (_284 * 0.0013765322510153055f)));
  float _322 = mad(_301, (WorkingColorSpace_ToXYZ[2].x), mad(_298, (WorkingColorSpace_ToXYZ[1].x), (_295 * (WorkingColorSpace_ToXYZ[0].x))));
  float _325 = mad(_301, (WorkingColorSpace_ToXYZ[2].y), mad(_298, (WorkingColorSpace_ToXYZ[1].y), (_295 * (WorkingColorSpace_ToXYZ[0].y))));
  float _328 = mad(_301, (WorkingColorSpace_ToXYZ[2].z), mad(_298, (WorkingColorSpace_ToXYZ[1].z), (_295 * (WorkingColorSpace_ToXYZ[0].z))));
  float _331 = mad(_310, (WorkingColorSpace_ToXYZ[2].x), mad(_307, (WorkingColorSpace_ToXYZ[1].x), (_304 * (WorkingColorSpace_ToXYZ[0].x))));
  float _334 = mad(_310, (WorkingColorSpace_ToXYZ[2].y), mad(_307, (WorkingColorSpace_ToXYZ[1].y), (_304 * (WorkingColorSpace_ToXYZ[0].y))));
  float _337 = mad(_310, (WorkingColorSpace_ToXYZ[2].z), mad(_307, (WorkingColorSpace_ToXYZ[1].z), (_304 * (WorkingColorSpace_ToXYZ[0].z))));
  float _340 = mad(_319, (WorkingColorSpace_ToXYZ[2].x), mad(_316, (WorkingColorSpace_ToXYZ[1].x), (_313 * (WorkingColorSpace_ToXYZ[0].x))));
  float _343 = mad(_319, (WorkingColorSpace_ToXYZ[2].y), mad(_316, (WorkingColorSpace_ToXYZ[1].y), (_313 * (WorkingColorSpace_ToXYZ[0].y))));
  float _346 = mad(_319, (WorkingColorSpace_ToXYZ[2].z), mad(_316, (WorkingColorSpace_ToXYZ[1].z), (_313 * (WorkingColorSpace_ToXYZ[0].z))));
  float _376 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _346, mad((WorkingColorSpace_FromXYZ[0].y), _337, (_328 * (WorkingColorSpace_FromXYZ[0].x)))), _129, mad(mad((WorkingColorSpace_FromXYZ[0].z), _343, mad((WorkingColorSpace_FromXYZ[0].y), _334, (_325 * (WorkingColorSpace_FromXYZ[0].x)))), _128, (mad((WorkingColorSpace_FromXYZ[0].z), _340, mad((WorkingColorSpace_FromXYZ[0].y), _331, (_322 * (WorkingColorSpace_FromXYZ[0].x)))) * _127)));
  float _379 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _346, mad((WorkingColorSpace_FromXYZ[1].y), _337, (_328 * (WorkingColorSpace_FromXYZ[1].x)))), _129, mad(mad((WorkingColorSpace_FromXYZ[1].z), _343, mad((WorkingColorSpace_FromXYZ[1].y), _334, (_325 * (WorkingColorSpace_FromXYZ[1].x)))), _128, (mad((WorkingColorSpace_FromXYZ[1].z), _340, mad((WorkingColorSpace_FromXYZ[1].y), _331, (_322 * (WorkingColorSpace_FromXYZ[1].x)))) * _127)));
  float _382 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _346, mad((WorkingColorSpace_FromXYZ[2].y), _337, (_328 * (WorkingColorSpace_FromXYZ[2].x)))), _129, mad(mad((WorkingColorSpace_FromXYZ[2].z), _343, mad((WorkingColorSpace_FromXYZ[2].y), _334, (_325 * (WorkingColorSpace_FromXYZ[2].x)))), _128, (mad((WorkingColorSpace_FromXYZ[2].z), _340, mad((WorkingColorSpace_FromXYZ[2].y), _331, (_322 * (WorkingColorSpace_FromXYZ[2].x)))) * _127)));
  float _397 = mad((WorkingColorSpace_ToAP1[0].z), _382, mad((WorkingColorSpace_ToAP1[0].y), _379, ((WorkingColorSpace_ToAP1[0].x) * _376)));
  float _400 = mad((WorkingColorSpace_ToAP1[1].z), _382, mad((WorkingColorSpace_ToAP1[1].y), _379, ((WorkingColorSpace_ToAP1[1].x) * _376)));
  float _403 = mad((WorkingColorSpace_ToAP1[2].z), _382, mad((WorkingColorSpace_ToAP1[2].y), _379, ((WorkingColorSpace_ToAP1[2].x) * _376)));
  float _404 = dot(float3(_397, _400, _403), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_397, _400, _403));

  float _408 = (_397 / _404) + -1.0f;
  float _409 = (_400 / _404) + -1.0f;
  float _410 = (_403 / _404) + -1.0f;
  float _422 = (1.0f - exp2(((_404 * _404) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_408, _409, _410), float3(_408, _409, _410)) * -4.0f));
  float _438 = ((mad(-0.06368321925401688f, _403, mad(-0.3292922377586365f, _400, (_397 * 1.3704125881195068f))) - _397) * _422) + _397;
  float _439 = ((mad(-0.010861365124583244f, _403, mad(1.0970927476882935f, _400, (_397 * -0.08343357592821121f))) - _400) * _422) + _400;
  float _440 = ((mad(1.2036951780319214f, _403, mad(-0.09862580895423889f, _400, (_397 * -0.02579331398010254f))) - _403) * _422) + _403;
  float _441 = dot(float3(_438, _439, _440), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _455 = ColorOffset.w + ColorOffsetShadows.w;
  float _469 = ColorGain.w * ColorGainShadows.w;
  float _483 = ColorGamma.w * ColorGammaShadows.w;
  float _497 = ColorContrast.w * ColorContrastShadows.w;
  float _511 = ColorSaturation.w * ColorSaturationShadows.w;
  float _515 = _438 - _441;
  float _516 = _439 - _441;
  float _517 = _440 - _441;
  float _574 = saturate(_441 / ColorCorrectionShadowsMax);
  float _578 = (_574 * _574) * (3.0f - (_574 * 2.0f));
  float _579 = 1.0f - _578;
  float _588 = ColorOffset.w + ColorOffsetHighlights.w;
  float _597 = ColorGain.w * ColorGainHighlights.w;
  float _606 = ColorGamma.w * ColorGammaHighlights.w;
  float _615 = ColorContrast.w * ColorContrastHighlights.w;
  float _624 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _687 = saturate((_441 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _691 = (_687 * _687) * (3.0f - (_687 * 2.0f));
  float _700 = ColorOffset.w + ColorOffsetMidtones.w;
  float _709 = ColorGain.w * ColorGainMidtones.w;
  float _718 = ColorGamma.w * ColorGammaMidtones.w;
  float _727 = ColorContrast.w * ColorContrastMidtones.w;
  float _736 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _794 = _578 - _691;
  float _805 = ((_691 * (((ColorOffset.x + ColorOffsetHighlights.x) + _588) + (((ColorGain.x * ColorGainHighlights.x) * _597) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _615) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _624) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _606)))))) + (_579 * (((ColorOffset.x + ColorOffsetShadows.x) + _455) + (((ColorGain.x * ColorGainShadows.x) * _469) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _497) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _511) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _483))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _700) + (((ColorGain.x * ColorGainMidtones.x) * _709) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _727) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _736) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _718))))) * _794);
  float _807 = ((_691 * (((ColorOffset.y + ColorOffsetHighlights.y) + _588) + (((ColorGain.y * ColorGainHighlights.y) * _597) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _615) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _624) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _606)))))) + (_579 * (((ColorOffset.y + ColorOffsetShadows.y) + _455) + (((ColorGain.y * ColorGainShadows.y) * _469) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _497) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _511) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _483))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _700) + (((ColorGain.y * ColorGainMidtones.y) * _709) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _727) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _736) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _718))))) * _794);
  float _809 = ((_691 * (((ColorOffset.z + ColorOffsetHighlights.z) + _588) + (((ColorGain.z * ColorGainHighlights.z) * _597) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _615) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _624) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _606)))))) + (_579 * (((ColorOffset.z + ColorOffsetShadows.z) + _455) + (((ColorGain.z * ColorGainShadows.z) * _469) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _497) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _511) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _483))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _700) + (((ColorGain.z * ColorGainMidtones.z) * _709) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _727) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _736) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _718))))) * _794);

  SetUntonemappedAP1(float3(_805, _807, _809));

  float _845 = ((mad(0.061360642313957214f, _809, mad(-4.540197551250458e-09f, _807, (_805 * 0.9386394023895264f))) - _805) * BlueCorrection) + _805;
  float _846 = ((mad(0.169205904006958f, _809, mad(0.8307942152023315f, _807, (_805 * 6.775371730327606e-08f))) - _807) * BlueCorrection) + _807;
  float _847 = (mad(-2.3283064365386963e-10f, _807, (_805 * -9.313225746154785e-10f)) * BlueCorrection) + _809;
  float _850 = mad(0.16386905312538147f, _847, mad(0.14067868888378143f, _846, (_845 * 0.6954522132873535f)));
  float _853 = mad(0.0955343246459961f, _847, mad(0.8596711158752441f, _846, (_845 * 0.044794581830501556f)));
  float _856 = mad(1.0015007257461548f, _847, mad(0.004025210160762072f, _846, (_845 * -0.005525882821530104f)));
  float _860 = max(max(_850, _853), _856);
  float _865 = (max(_860, 1.000000013351432e-10f) - max(min(min(_850, _853), _856), 1.000000013351432e-10f)) / max(_860, 0.009999999776482582f);
  float _878 = ((_853 + _850) + _856) + (sqrt((((_856 - _853) * _856) + ((_853 - _850) * _853)) + ((_850 - _856) * _850)) * 1.75f);
  float _879 = _878 * 0.3333333432674408f;
  float _880 = _865 + -0.4000000059604645f;
  float _881 = _880 * 5.0f;
  float _885 = max((1.0f - abs(_880 * 2.5f)), 0.0f);
  float _896 = ((float(((int)(uint)((bool)(_881 > 0.0f))) - ((int)(uint)((bool)(_881 < 0.0f)))) * (1.0f - (_885 * _885))) + 1.0f) * 0.02500000037252903f;
  if (!(_879 <= 0.0533333346247673f)) {
    if (!(_879 >= 0.1599999964237213f)) {
      _905 = (((0.23999999463558197f / _878) + -0.5f) * _896);
    } else {
      _905 = 0.0f;
    }
  } else {
    _905 = _896;
  }
  float _906 = _905 + 1.0f;
  float _907 = _906 * _850;
  float _908 = _906 * _853;
  float _909 = _906 * _856;
  if (!((bool)(_907 == _908) && (bool)(_908 == _909))) {
    float _916 = ((_907 * 2.0f) - _908) - _909;
    float _919 = ((_853 - _856) * 1.7320507764816284f) * _906;
    float _921 = atan(_919 / _916);
    bool _924 = (_916 < 0.0f);
    bool _925 = (_916 == 0.0f);
    bool _926 = (_919 >= 0.0f);
    bool _927 = (_919 < 0.0f);
    _938 = select((_926 && _925), 90.0f, select((_927 && _925), -90.0f, (select((_927 && _924), (_921 + -3.1415927410125732f), select((_926 && _924), (_921 + 3.1415927410125732f), _921)) * 57.2957763671875f)));
  } else {
    _938 = 0.0f;
  }
  float _943 = min(max(select((_938 < 0.0f), (_938 + 360.0f), _938), 0.0f), 360.0f);
  if (_943 < -180.0f) {
    _952 = (_943 + 360.0f);
  } else {
    if (_943 > 180.0f) {
      _952 = (_943 + -360.0f);
    } else {
      _952 = _943;
    }
  }
  float _956 = saturate(1.0f - abs(_952 * 0.014814814552664757f));
  float _960 = (_956 * _956) * (3.0f - (_956 * 2.0f));
  float _966 = ((_960 * _960) * ((_865 * 0.18000000715255737f) * (0.029999999329447746f - _907))) + _907;
  float _976 = max(0.0f, mad(-0.21492856740951538f, _909, mad(-0.2365107536315918f, _908, (_966 * 1.4514392614364624f))));
  float _977 = max(0.0f, mad(-0.09967592358589172f, _909, mad(1.17622971534729f, _908, (_966 * -0.07655377686023712f))));
  float _978 = max(0.0f, mad(0.9977163076400757f, _909, mad(-0.006032449658960104f, _908, (_966 * 0.008316148072481155f))));
  float _979 = dot(float3(_976, _977, _978), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _994 = (FilmBlackClip + 1.0f) - FilmToe;
  float _996 = FilmWhiteClip + 1.0f;
  float _998 = _996 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1016 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _1007 = (FilmBlackClip + 0.18000000715255737f) / _994;
    _1016 = (-0.7447274923324585f - ((log2(_1007 / (2.0f - _1007)) * 0.3465735912322998f) * (_994 / FilmSlope)));
  }
  float _1019 = ((1.0f - FilmToe) / FilmSlope) - _1016;
  float _1021 = (FilmShoulder / FilmSlope) - _1019;
  float _1025 = log2(lerp(_979, _976, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1026 = log2(lerp(_979, _977, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1027 = log2(lerp(_979, _978, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1031 = FilmSlope * (_1025 + _1019);
  float _1032 = FilmSlope * (_1026 + _1019);
  float _1033 = FilmSlope * (_1027 + _1019);
  float _1034 = _994 * 2.0f;
  float _1036 = (FilmSlope * -2.0f) / _994;
  float _1037 = _1025 - _1016;
  float _1038 = _1026 - _1016;
  float _1039 = _1027 - _1016;
  float _1058 = _998 * 2.0f;
  float _1060 = (FilmSlope * 2.0f) / _998;
  float _1085 = select((_1025 < _1016), ((_1034 / (exp2((_1037 * 1.4426950216293335f) * _1036) + 1.0f)) - FilmBlackClip), _1031);
  float _1086 = select((_1026 < _1016), ((_1034 / (exp2((_1038 * 1.4426950216293335f) * _1036) + 1.0f)) - FilmBlackClip), _1032);
  float _1087 = select((_1027 < _1016), ((_1034 / (exp2((_1039 * 1.4426950216293335f) * _1036) + 1.0f)) - FilmBlackClip), _1033);
  float _1094 = _1021 - _1016;
  float _1098 = saturate(_1037 / _1094);
  float _1099 = saturate(_1038 / _1094);
  float _1100 = saturate(_1039 / _1094);
  bool _1101 = (_1021 < _1016);
  float _1105 = select(_1101, (1.0f - _1098), _1098);
  float _1106 = select(_1101, (1.0f - _1099), _1099);
  float _1107 = select(_1101, (1.0f - _1100), _1100);
  float _1126 = (((_1105 * _1105) * (select((_1025 > _1021), (_996 - (_1058 / (exp2(((_1025 - _1021) * 1.4426950216293335f) * _1060) + 1.0f))), _1031) - _1085)) * (3.0f - (_1105 * 2.0f))) + _1085;
  float _1127 = (((_1106 * _1106) * (select((_1026 > _1021), (_996 - (_1058 / (exp2(((_1026 - _1021) * 1.4426950216293335f) * _1060) + 1.0f))), _1032) - _1086)) * (3.0f - (_1106 * 2.0f))) + _1086;
  float _1128 = (((_1107 * _1107) * (select((_1027 > _1021), (_996 - (_1058 / (exp2(((_1027 - _1021) * 1.4426950216293335f) * _1060) + 1.0f))), _1033) - _1087)) * (3.0f - (_1107 * 2.0f))) + _1087;
  float _1129 = dot(float3(_1126, _1127, _1128), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1149 = (ToneCurveAmount * (max(0.0f, (lerp(_1129, _1126, 0.9300000071525574f))) - _845)) + _845;
  float _1150 = (ToneCurveAmount * (max(0.0f, (lerp(_1129, _1127, 0.9300000071525574f))) - _846)) + _846;
  float _1151 = (ToneCurveAmount * (max(0.0f, (lerp(_1129, _1128, 0.9300000071525574f))) - _847)) + _847;
  float _1167 = ((mad(-0.06537103652954102f, _1151, mad(1.451815478503704e-06f, _1150, (_1149 * 1.065374732017517f))) - _1149) * BlueCorrection) + _1149;
  float _1168 = ((mad(-0.20366770029067993f, _1151, mad(1.2036634683609009f, _1150, (_1149 * -2.57161445915699e-07f))) - _1150) * BlueCorrection) + _1150;
  float _1169 = ((mad(0.9999996423721313f, _1151, mad(2.0954757928848267e-08f, _1150, (_1149 * 1.862645149230957e-08f))) - _1151) * BlueCorrection) + _1151;

  SetTonemappedAP1(_1167, _1168, _1169);

  float _1182 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1169, mad((WorkingColorSpace_FromAP1[0].y), _1168, ((WorkingColorSpace_FromAP1[0].x) * _1167)))));
  float _1183 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1169, mad((WorkingColorSpace_FromAP1[1].y), _1168, ((WorkingColorSpace_FromAP1[1].x) * _1167)))));
  float _1184 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1169, mad((WorkingColorSpace_FromAP1[2].y), _1168, ((WorkingColorSpace_FromAP1[2].x) * _1167)))));
  if (_1182 < 0.0031306699384003878f) {
    _1195 = (_1182 * 12.920000076293945f);
  } else {
    _1195 = (((pow(_1182, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1183 < 0.0031306699384003878f) {
    _1206 = (_1183 * 12.920000076293945f);
  } else {
    _1206 = (((pow(_1183, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1184 < 0.0031306699384003878f) {
    _1217 = (_1184 * 12.920000076293945f);
  } else {
    _1217 = (((pow(_1184, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1221 = (_1206 * 0.9375f) + 0.03125f;
  float _1228 = _1217 * 15.0f;
  float _1229 = floor(_1228);
  float _1230 = _1228 - _1229;
  float _1232 = (_1229 + ((_1195 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1235 = Textures_1.SampleLevel(Samplers_1, float2(_1232, _1221), 0.0f);
  float _1239 = _1232 + 0.0625f;
  float4 _1240 = Textures_1.SampleLevel(Samplers_1, float2(_1239, _1221), 0.0f);
  float4 _1262 = Textures_2.SampleLevel(Samplers_2, float2(_1232, _1221), 0.0f);
  float4 _1266 = Textures_2.SampleLevel(Samplers_2, float2(_1239, _1221), 0.0f);
  float4 _1288 = Textures_3.SampleLevel(Samplers_3, float2(_1232, _1221), 0.0f);
  float4 _1292 = Textures_3.SampleLevel(Samplers_3, float2(_1239, _1221), 0.0f);
  float4 _1315 = Textures_4.SampleLevel(Samplers_4, float2(_1232, _1221), 0.0f);
  float4 _1319 = Textures_4.SampleLevel(Samplers_4, float2(_1239, _1221), 0.0f);
  float _1338 = max(6.103519990574569e-05f, ((((((lerp(_1235.x, _1240.x, _1230)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1195)) + ((lerp(_1262.x, _1266.x, _1230)) * (LUTWeights[0].z))) + ((lerp(_1288.x, _1292.x, _1230)) * (LUTWeights[0].w))) + ((lerp(_1315.x, _1319.x, _1230)) * (LUTWeights[1].x))));
  float _1339 = max(6.103519990574569e-05f, ((((((lerp(_1235.y, _1240.y, _1230)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1206)) + ((lerp(_1262.y, _1266.y, _1230)) * (LUTWeights[0].z))) + ((lerp(_1288.y, _1292.y, _1230)) * (LUTWeights[0].w))) + ((lerp(_1315.y, _1319.y, _1230)) * (LUTWeights[1].x))));
  float _1340 = max(6.103519990574569e-05f, ((((((lerp(_1235.z, _1240.z, _1230)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1217)) + ((lerp(_1262.z, _1266.z, _1230)) * (LUTWeights[0].z))) + ((lerp(_1288.z, _1292.z, _1230)) * (LUTWeights[0].w))) + ((lerp(_1315.z, _1319.z, _1230)) * (LUTWeights[1].x))));
  float _1362 = select((_1338 > 0.040449999272823334f), exp2(log2((_1338 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1338 * 0.07739938050508499f));
  float _1363 = select((_1339 > 0.040449999272823334f), exp2(log2((_1339 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1339 * 0.07739938050508499f));
  float _1364 = select((_1340 > 0.040449999272823334f), exp2(log2((_1340 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1340 * 0.07739938050508499f));
  float _1390 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1362)) * _1362) + MappingPolynomial.z);
  float _1391 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1363)) * _1363) + MappingPolynomial.z);
  float _1392 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1364)) * _1364) + MappingPolynomial.z);
  float _1399 = ((OverlayColor.x - _1390) * OverlayColor.w) + _1390;
  float _1400 = ((OverlayColor.y - _1391) * OverlayColor.w) + _1391;
  float _1401 = ((OverlayColor.z - _1392) * OverlayColor.w) + _1392;
  float _1402 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _809, mad((WorkingColorSpace_FromAP1[0].y), _807, (_805 * (WorkingColorSpace_FromAP1[0].x))));
  float _1403 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _809, mad((WorkingColorSpace_FromAP1[1].y), _807, ((WorkingColorSpace_FromAP1[1].x) * _805)));
  float _1404 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _809, mad((WorkingColorSpace_FromAP1[2].y), _807, ((WorkingColorSpace_FromAP1[2].x) * _805)));
  float _1411 = ((OverlayColor.x - _1402) * OverlayColor.w) + _1402;
  float _1412 = ((OverlayColor.y - _1403) * OverlayColor.w) + _1403;
  float _1413 = ((OverlayColor.z - _1404) * OverlayColor.w) + _1404;
  float _1425 = exp2(log2(max(0.0f, _1399)) * InverseGamma.y);
  float _1426 = exp2(log2(max(0.0f, _1400)) * InverseGamma.y);
  float _1427 = exp2(log2(max(0.0f, _1401)) * InverseGamma.y);

  if (true) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1425, _1426, _1427), OutputDevice);
    return;
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _1450 = mad((WorkingColorSpace_ToAP1[0].z), _1427, mad((WorkingColorSpace_ToAP1[0].y), _1426, ((WorkingColorSpace_ToAP1[0].x) * _1425)));
        float _1453 = mad((WorkingColorSpace_ToAP1[1].z), _1427, mad((WorkingColorSpace_ToAP1[1].y), _1426, ((WorkingColorSpace_ToAP1[1].x) * _1425)));
        float _1456 = mad((WorkingColorSpace_ToAP1[2].z), _1427, mad((WorkingColorSpace_ToAP1[2].y), _1426, ((WorkingColorSpace_ToAP1[2].x) * _1425)));
        _1467 = mad(_63, _1456, mad(_62, _1453, (_1450 * _61)));
        _1468 = mad(_66, _1456, mad(_65, _1453, (_1450 * _64)));
        _1469 = mad(_69, _1456, mad(_68, _1453, (_1450 * _67)));
      } else {
        _1467 = _1425;
        _1468 = _1426;
        _1469 = _1427;
      }
      do {
        if (_1467 < 0.0031306699384003878f) {
          _1480 = (_1467 * 12.920000076293945f);
        } else {
          _1480 = (((pow(_1467, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1468 < 0.0031306699384003878f) {
            _1491 = (_1468 * 12.920000076293945f);
          } else {
            _1491 = (((pow(_1468, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1469 < 0.0031306699384003878f) {
            _2847 = _1480;
            _2848 = _1491;
            _2849 = (_1469 * 12.920000076293945f);
          } else {
            _2847 = _1480;
            _2848 = _1491;
            _2849 = (((pow(_1469, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _1518 = mad((WorkingColorSpace_ToAP1[0].z), _1427, mad((WorkingColorSpace_ToAP1[0].y), _1426, ((WorkingColorSpace_ToAP1[0].x) * _1425)));
      float _1521 = mad((WorkingColorSpace_ToAP1[1].z), _1427, mad((WorkingColorSpace_ToAP1[1].y), _1426, ((WorkingColorSpace_ToAP1[1].x) * _1425)));
      float _1524 = mad((WorkingColorSpace_ToAP1[2].z), _1427, mad((WorkingColorSpace_ToAP1[2].y), _1426, ((WorkingColorSpace_ToAP1[2].x) * _1425)));
      float _1534 = max(6.103519990574569e-05f, mad(_63, _1524, mad(_62, _1521, (_1518 * _61))));
      float _1535 = max(6.103519990574569e-05f, mad(_66, _1524, mad(_65, _1521, (_1518 * _64))));
      float _1536 = max(6.103519990574569e-05f, mad(_69, _1524, mad(_68, _1521, (_1518 * _67))));
      _2847 = min((_1534 * 4.5f), ((exp2(log2(max(_1534, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2848 = min((_1535 * 4.5f), ((exp2(log2(max(_1535, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2849 = min((_1536 * 4.5f), ((exp2(log2(max(_1536, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        _19[0] = ACESCoefsLow_0.x;
        _19[1] = ACESCoefsLow_0.y;
        _19[2] = ACESCoefsLow_0.z;
        _19[3] = ACESCoefsLow_0.w;
        _19[4] = ACESCoefsLow_4;
        _19[5] = ACESCoefsLow_4;
        _20[0] = ACESCoefsHigh_0.x;
        _20[1] = ACESCoefsHigh_0.y;
        _20[2] = ACESCoefsHigh_0.z;
        _20[3] = ACESCoefsHigh_0.w;
        _20[4] = ACESCoefsHigh_4;
        _20[5] = ACESCoefsHigh_4;
        float _1611 = ACESSceneColorMultiplier * _1411;
        float _1612 = ACESSceneColorMultiplier * _1412;
        float _1613 = ACESSceneColorMultiplier * _1413;
        float _1616 = mad((WorkingColorSpace_ToAP0[0].z), _1613, mad((WorkingColorSpace_ToAP0[0].y), _1612, ((WorkingColorSpace_ToAP0[0].x) * _1611)));
        float _1619 = mad((WorkingColorSpace_ToAP0[1].z), _1613, mad((WorkingColorSpace_ToAP0[1].y), _1612, ((WorkingColorSpace_ToAP0[1].x) * _1611)));
        float _1622 = mad((WorkingColorSpace_ToAP0[2].z), _1613, mad((WorkingColorSpace_ToAP0[2].y), _1612, ((WorkingColorSpace_ToAP0[2].x) * _1611)));
        float _1626 = max(max(_1616, _1619), _1622);
        float _1631 = (max(_1626, 1.000000013351432e-10f) - max(min(min(_1616, _1619), _1622), 1.000000013351432e-10f)) / max(_1626, 0.009999999776482582f);
        float _1644 = ((_1619 + _1616) + _1622) + (sqrt((((_1622 - _1619) * _1622) + ((_1619 - _1616) * _1619)) + ((_1616 - _1622) * _1616)) * 1.75f);
        float _1645 = _1644 * 0.3333333432674408f;
        float _1646 = _1631 + -0.4000000059604645f;
        float _1647 = _1646 * 5.0f;
        float _1651 = max((1.0f - abs(_1646 * 2.5f)), 0.0f);
        float _1662 = ((float(((int)(uint)((bool)(_1647 > 0.0f))) - ((int)(uint)((bool)(_1647 < 0.0f)))) * (1.0f - (_1651 * _1651))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1645 <= 0.0533333346247673f)) {
            if (!(_1645 >= 0.1599999964237213f)) {
              _1671 = (((0.23999999463558197f / _1644) + -0.5f) * _1662);
            } else {
              _1671 = 0.0f;
            }
          } else {
            _1671 = _1662;
          }
          float _1672 = _1671 + 1.0f;
          float _1673 = _1672 * _1616;
          float _1674 = _1672 * _1619;
          float _1675 = _1672 * _1622;
          do {
            if (!((bool)(_1673 == _1674) && (bool)(_1674 == _1675))) {
              float _1682 = ((_1673 * 2.0f) - _1674) - _1675;
              float _1685 = ((_1619 - _1622) * 1.7320507764816284f) * _1672;
              float _1687 = atan(_1685 / _1682);
              bool _1690 = (_1682 < 0.0f);
              bool _1691 = (_1682 == 0.0f);
              bool _1692 = (_1685 >= 0.0f);
              bool _1693 = (_1685 < 0.0f);
              _1704 = select((_1692 && _1691), 90.0f, select((_1693 && _1691), -90.0f, (select((_1693 && _1690), (_1687 + -3.1415927410125732f), select((_1692 && _1690), (_1687 + 3.1415927410125732f), _1687)) * 57.2957763671875f)));
            } else {
              _1704 = 0.0f;
            }
            float _1709 = min(max(select((_1704 < 0.0f), (_1704 + 360.0f), _1704), 0.0f), 360.0f);
            do {
              if (_1709 < -180.0f) {
                _1718 = (_1709 + 360.0f);
              } else {
                if (_1709 > 180.0f) {
                  _1718 = (_1709 + -360.0f);
                } else {
                  _1718 = _1709;
                }
              }
              do {
                if ((bool)(_1718 > -67.5f) && (bool)(_1718 < 67.5f)) {
                  float _1724 = (_1718 + 67.5f) * 0.029629629105329514f;
                  int _1725 = int(_1724);
                  float _1727 = _1724 - float(_1725);
                  float _1728 = _1727 * _1727;
                  float _1729 = _1728 * _1727;
                  if (_1725 == 3) {
                    _1757 = (((0.1666666716337204f - (_1727 * 0.5f)) + (_1728 * 0.5f)) - (_1729 * 0.1666666716337204f));
                  } else {
                    if (_1725 == 2) {
                      _1757 = ((0.6666666865348816f - _1728) + (_1729 * 0.5f));
                    } else {
                      if (_1725 == 1) {
                        _1757 = (((_1729 * -0.5f) + 0.1666666716337204f) + ((_1728 + _1727) * 0.5f));
                      } else {
                        _1757 = select((_1725 == 0), (_1729 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1757 = 0.0f;
                }
                float _1766 = min(max(((((_1631 * 0.27000001072883606f) * (0.029999999329447746f - _1673)) * _1757) + _1673), 0.0f), 65535.0f);
                float _1767 = min(max(_1674, 0.0f), 65535.0f);
                float _1768 = min(max(_1675, 0.0f), 65535.0f);
                float _1781 = min(max(mad(-0.21492856740951538f, _1768, mad(-0.2365107536315918f, _1767, (_1766 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1782 = min(max(mad(-0.09967592358589172f, _1768, mad(1.17622971534729f, _1767, (_1766 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1783 = min(max(mad(0.9977163076400757f, _1768, mad(-0.006032449658960104f, _1767, (_1766 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1784 = dot(float3(_1781, _1782, _1783), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1795 = log2(max((lerp(_1784, _1781, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1796 = _1795 * 0.3010300099849701f;
                float _1797 = log2(ACESMinMaxData.x);
                float _1798 = _1797 * 0.3010300099849701f;
                do {
                  if (!(!(_1796 <= _1798))) {
                    _1867 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1805 = log2(ACESMidData.x);
                    float _1806 = _1805 * 0.3010300099849701f;
                    if ((bool)(_1796 > _1798) && (bool)(_1796 < _1806)) {
                      float _1814 = ((_1795 - _1797) * 0.9030900001525879f) / ((_1805 - _1797) * 0.3010300099849701f);
                      int _1815 = int(_1814);
                      float _1817 = _1814 - float(_1815);
                      float _1819 = _19[_1815];
                      float _1822 = _19[(_1815 + 1)];
                      float _1827 = _1819 * 0.5f;
                      _1867 = dot(float3((_1817 * _1817), _1817, 1.0f), float3(mad((_19[(_1815 + 2)]), 0.5f, mad(_1822, -1.0f, _1827)), (_1822 - _1819), mad(_1822, 0.5f, _1827)));
                    } else {
                      do {
                        if (!(!(_1796 >= _1806))) {
                          float _1836 = log2(ACESMinMaxData.z);
                          if (_1796 < (_1836 * 0.3010300099849701f)) {
                            float _1844 = ((_1795 - _1805) * 0.9030900001525879f) / ((_1836 - _1805) * 0.3010300099849701f);
                            int _1845 = int(_1844);
                            float _1847 = _1844 - float(_1845);
                            float _1849 = _20[_1845];
                            float _1852 = _20[(_1845 + 1)];
                            float _1857 = _1849 * 0.5f;
                            _1867 = dot(float3((_1847 * _1847), _1847, 1.0f), float3(mad((_20[(_1845 + 2)]), 0.5f, mad(_1852, -1.0f, _1857)), (_1852 - _1849), mad(_1852, 0.5f, _1857)));
                            break;
                          }
                        }
                        _1867 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1871 = log2(max((lerp(_1784, _1782, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1872 = _1871 * 0.3010300099849701f;
                  do {
                    if (!(!(_1872 <= _1798))) {
                      _1941 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1879 = log2(ACESMidData.x);
                      float _1880 = _1879 * 0.3010300099849701f;
                      if ((bool)(_1872 > _1798) && (bool)(_1872 < _1880)) {
                        float _1888 = ((_1871 - _1797) * 0.9030900001525879f) / ((_1879 - _1797) * 0.3010300099849701f);
                        int _1889 = int(_1888);
                        float _1891 = _1888 - float(_1889);
                        float _1893 = _19[_1889];
                        float _1896 = _19[(_1889 + 1)];
                        float _1901 = _1893 * 0.5f;
                        _1941 = dot(float3((_1891 * _1891), _1891, 1.0f), float3(mad((_19[(_1889 + 2)]), 0.5f, mad(_1896, -1.0f, _1901)), (_1896 - _1893), mad(_1896, 0.5f, _1901)));
                      } else {
                        do {
                          if (!(!(_1872 >= _1880))) {
                            float _1910 = log2(ACESMinMaxData.z);
                            if (_1872 < (_1910 * 0.3010300099849701f)) {
                              float _1918 = ((_1871 - _1879) * 0.9030900001525879f) / ((_1910 - _1879) * 0.3010300099849701f);
                              int _1919 = int(_1918);
                              float _1921 = _1918 - float(_1919);
                              float _1923 = _20[_1919];
                              float _1926 = _20[(_1919 + 1)];
                              float _1931 = _1923 * 0.5f;
                              _1941 = dot(float3((_1921 * _1921), _1921, 1.0f), float3(mad((_20[(_1919 + 2)]), 0.5f, mad(_1926, -1.0f, _1931)), (_1926 - _1923), mad(_1926, 0.5f, _1931)));
                              break;
                            }
                          }
                          _1941 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1945 = log2(max((lerp(_1784, _1783, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1946 = _1945 * 0.3010300099849701f;
                    do {
                      if (!(!(_1946 <= _1798))) {
                        _2015 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1953 = log2(ACESMidData.x);
                        float _1954 = _1953 * 0.3010300099849701f;
                        if ((bool)(_1946 > _1798) && (bool)(_1946 < _1954)) {
                          float _1962 = ((_1945 - _1797) * 0.9030900001525879f) / ((_1953 - _1797) * 0.3010300099849701f);
                          int _1963 = int(_1962);
                          float _1965 = _1962 - float(_1963);
                          float _1967 = _19[_1963];
                          float _1970 = _19[(_1963 + 1)];
                          float _1975 = _1967 * 0.5f;
                          _2015 = dot(float3((_1965 * _1965), _1965, 1.0f), float3(mad((_19[(_1963 + 2)]), 0.5f, mad(_1970, -1.0f, _1975)), (_1970 - _1967), mad(_1970, 0.5f, _1975)));
                        } else {
                          do {
                            if (!(!(_1946 >= _1954))) {
                              float _1984 = log2(ACESMinMaxData.z);
                              if (_1946 < (_1984 * 0.3010300099849701f)) {
                                float _1992 = ((_1945 - _1953) * 0.9030900001525879f) / ((_1984 - _1953) * 0.3010300099849701f);
                                int _1993 = int(_1992);
                                float _1995 = _1992 - float(_1993);
                                float _1997 = _20[_1993];
                                float _2000 = _20[(_1993 + 1)];
                                float _2005 = _1997 * 0.5f;
                                _2015 = dot(float3((_1995 * _1995), _1995, 1.0f), float3(mad((_20[(_1993 + 2)]), 0.5f, mad(_2000, -1.0f, _2005)), (_2000 - _1997), mad(_2000, 0.5f, _2005)));
                                break;
                              }
                            }
                            _2015 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2019 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _2020 = (exp2(_1867 * 3.321928024291992f) - ACESMinMaxData.y) / _2019;
                      float _2022 = (exp2(_1941 * 3.321928024291992f) - ACESMinMaxData.y) / _2019;
                      float _2024 = (exp2(_2015 * 3.321928024291992f) - ACESMinMaxData.y) / _2019;
                      float _2027 = mad(0.15618768334388733f, _2024, mad(0.13400420546531677f, _2022, (_2020 * 0.6624541878700256f)));
                      float _2030 = mad(0.053689517080783844f, _2024, mad(0.6740817427635193f, _2022, (_2020 * 0.2722287178039551f)));
                      float _2033 = mad(1.0103391408920288f, _2024, mad(0.00406073359772563f, _2022, (_2020 * -0.005574649665504694f)));
                      float _2046 = min(max(mad(-0.23642469942569733f, _2033, mad(-0.32480329275131226f, _2030, (_2027 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _2047 = min(max(mad(0.016756348311901093f, _2033, mad(1.6153316497802734f, _2030, (_2027 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _2048 = min(max(mad(0.9883948564529419f, _2033, mad(-0.008284442126750946f, _2030, (_2027 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _2051 = mad(0.15618768334388733f, _2048, mad(0.13400420546531677f, _2047, (_2046 * 0.6624541878700256f)));
                      float _2054 = mad(0.053689517080783844f, _2048, mad(0.6740817427635193f, _2047, (_2046 * 0.2722287178039551f)));
                      float _2057 = mad(1.0103391408920288f, _2048, mad(0.00406073359772563f, _2047, (_2046 * -0.005574649665504694f)));
                      float _2079 = min(max((min(max(mad(-0.23642469942569733f, _2057, mad(-0.32480329275131226f, _2054, (_2051 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2080 = min(max((min(max(mad(0.016756348311901093f, _2057, mad(1.6153316497802734f, _2054, (_2051 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2081 = min(max((min(max(mad(0.9883948564529419f, _2057, mad(-0.008284442126750946f, _2054, (_2051 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(OutputDevice) == 5)) {
                          _2094 = mad(_63, _2081, mad(_62, _2080, (_2079 * _61)));
                          _2095 = mad(_66, _2081, mad(_65, _2080, (_2079 * _64)));
                          _2096 = mad(_69, _2081, mad(_68, _2080, (_2079 * _67)));
                        } else {
                          _2094 = _2079;
                          _2095 = _2080;
                          _2096 = _2081;
                        }
                        float _2106 = exp2(log2(_2094 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2107 = exp2(log2(_2095 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2108 = exp2(log2(_2096 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2847 = exp2(log2((1.0f / ((_2106 * 18.6875f) + 1.0f)) * ((_2106 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2848 = exp2(log2((1.0f / ((_2107 * 18.6875f) + 1.0f)) * ((_2107 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2849 = exp2(log2((1.0f / ((_2108 * 18.6875f) + 1.0f)) * ((_2108 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2185 = ACESSceneColorMultiplier * _1411;
          float _2186 = ACESSceneColorMultiplier * _1412;
          float _2187 = ACESSceneColorMultiplier * _1413;
          float _2190 = mad((WorkingColorSpace_ToAP0[0].z), _2187, mad((WorkingColorSpace_ToAP0[0].y), _2186, ((WorkingColorSpace_ToAP0[0].x) * _2185)));
          float _2193 = mad((WorkingColorSpace_ToAP0[1].z), _2187, mad((WorkingColorSpace_ToAP0[1].y), _2186, ((WorkingColorSpace_ToAP0[1].x) * _2185)));
          float _2196 = mad((WorkingColorSpace_ToAP0[2].z), _2187, mad((WorkingColorSpace_ToAP0[2].y), _2186, ((WorkingColorSpace_ToAP0[2].x) * _2185)));
          float _2200 = max(max(_2190, _2193), _2196);
          float _2205 = (max(_2200, 1.000000013351432e-10f) - max(min(min(_2190, _2193), _2196), 1.000000013351432e-10f)) / max(_2200, 0.009999999776482582f);
          float _2218 = ((_2193 + _2190) + _2196) + (sqrt((((_2196 - _2193) * _2196) + ((_2193 - _2190) * _2193)) + ((_2190 - _2196) * _2190)) * 1.75f);
          float _2219 = _2218 * 0.3333333432674408f;
          float _2220 = _2205 + -0.4000000059604645f;
          float _2221 = _2220 * 5.0f;
          float _2225 = max((1.0f - abs(_2220 * 2.5f)), 0.0f);
          float _2236 = ((float(((int)(uint)((bool)(_2221 > 0.0f))) - ((int)(uint)((bool)(_2221 < 0.0f)))) * (1.0f - (_2225 * _2225))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2219 <= 0.0533333346247673f)) {
              if (!(_2219 >= 0.1599999964237213f)) {
                _2245 = (((0.23999999463558197f / _2218) + -0.5f) * _2236);
              } else {
                _2245 = 0.0f;
              }
            } else {
              _2245 = _2236;
            }
            float _2246 = _2245 + 1.0f;
            float _2247 = _2246 * _2190;
            float _2248 = _2246 * _2193;
            float _2249 = _2246 * _2196;
            do {
              if (!((bool)(_2247 == _2248) && (bool)(_2248 == _2249))) {
                float _2256 = ((_2247 * 2.0f) - _2248) - _2249;
                float _2259 = ((_2193 - _2196) * 1.7320507764816284f) * _2246;
                float _2261 = atan(_2259 / _2256);
                bool _2264 = (_2256 < 0.0f);
                bool _2265 = (_2256 == 0.0f);
                bool _2266 = (_2259 >= 0.0f);
                bool _2267 = (_2259 < 0.0f);
                _2278 = select((_2266 && _2265), 90.0f, select((_2267 && _2265), -90.0f, (select((_2267 && _2264), (_2261 + -3.1415927410125732f), select((_2266 && _2264), (_2261 + 3.1415927410125732f), _2261)) * 57.2957763671875f)));
              } else {
                _2278 = 0.0f;
              }
              float _2283 = min(max(select((_2278 < 0.0f), (_2278 + 360.0f), _2278), 0.0f), 360.0f);
              do {
                if (_2283 < -180.0f) {
                  _2292 = (_2283 + 360.0f);
                } else {
                  if (_2283 > 180.0f) {
                    _2292 = (_2283 + -360.0f);
                  } else {
                    _2292 = _2283;
                  }
                }
                do {
                  if ((bool)(_2292 > -67.5f) && (bool)(_2292 < 67.5f)) {
                    float _2298 = (_2292 + 67.5f) * 0.029629629105329514f;
                    int _2299 = int(_2298);
                    float _2301 = _2298 - float(_2299);
                    float _2302 = _2301 * _2301;
                    float _2303 = _2302 * _2301;
                    if (_2299 == 3) {
                      _2331 = (((0.1666666716337204f - (_2301 * 0.5f)) + (_2302 * 0.5f)) - (_2303 * 0.1666666716337204f));
                    } else {
                      if (_2299 == 2) {
                        _2331 = ((0.6666666865348816f - _2302) + (_2303 * 0.5f));
                      } else {
                        if (_2299 == 1) {
                          _2331 = (((_2303 * -0.5f) + 0.1666666716337204f) + ((_2302 + _2301) * 0.5f));
                        } else {
                          _2331 = select((_2299 == 0), (_2303 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2331 = 0.0f;
                  }
                  float _2340 = min(max(((((_2205 * 0.27000001072883606f) * (0.029999999329447746f - _2247)) * _2331) + _2247), 0.0f), 65535.0f);
                  float _2341 = min(max(_2248, 0.0f), 65535.0f);
                  float _2342 = min(max(_2249, 0.0f), 65535.0f);
                  float _2355 = min(max(mad(-0.21492856740951538f, _2342, mad(-0.2365107536315918f, _2341, (_2340 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2356 = min(max(mad(-0.09967592358589172f, _2342, mad(1.17622971534729f, _2341, (_2340 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2357 = min(max(mad(0.9977163076400757f, _2342, mad(-0.006032449658960104f, _2341, (_2340 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2358 = dot(float3(_2355, _2356, _2357), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2369 = log2(max((lerp(_2358, _2355, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2370 = _2369 * 0.3010300099849701f;
                  float _2371 = log2(ACESMinMaxData.x);
                  float _2372 = _2371 * 0.3010300099849701f;
                  do {
                    if (!(!(_2370 <= _2372))) {
                      _2441 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2379 = log2(ACESMidData.x);
                      float _2380 = _2379 * 0.3010300099849701f;
                      if ((bool)(_2370 > _2372) && (bool)(_2370 < _2380)) {
                        float _2388 = ((_2369 - _2371) * 0.9030900001525879f) / ((_2379 - _2371) * 0.3010300099849701f);
                        int _2389 = int(_2388);
                        float _2391 = _2388 - float(_2389);
                        float _2393 = _17[_2389];
                        float _2396 = _17[(_2389 + 1)];
                        float _2401 = _2393 * 0.5f;
                        _2441 = dot(float3((_2391 * _2391), _2391, 1.0f), float3(mad((_17[(_2389 + 2)]), 0.5f, mad(_2396, -1.0f, _2401)), (_2396 - _2393), mad(_2396, 0.5f, _2401)));
                      } else {
                        do {
                          if (!(!(_2370 >= _2380))) {
                            float _2410 = log2(ACESMinMaxData.z);
                            if (_2370 < (_2410 * 0.3010300099849701f)) {
                              float _2418 = ((_2369 - _2379) * 0.9030900001525879f) / ((_2410 - _2379) * 0.3010300099849701f);
                              int _2419 = int(_2418);
                              float _2421 = _2418 - float(_2419);
                              float _2423 = _18[_2419];
                              float _2426 = _18[(_2419 + 1)];
                              float _2431 = _2423 * 0.5f;
                              _2441 = dot(float3((_2421 * _2421), _2421, 1.0f), float3(mad((_18[(_2419 + 2)]), 0.5f, mad(_2426, -1.0f, _2431)), (_2426 - _2423), mad(_2426, 0.5f, _2431)));
                              break;
                            }
                          }
                          _2441 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2445 = log2(max((lerp(_2358, _2356, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2446 = _2445 * 0.3010300099849701f;
                    do {
                      if (!(!(_2446 <= _2372))) {
                        _2515 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2453 = log2(ACESMidData.x);
                        float _2454 = _2453 * 0.3010300099849701f;
                        if ((bool)(_2446 > _2372) && (bool)(_2446 < _2454)) {
                          float _2462 = ((_2445 - _2371) * 0.9030900001525879f) / ((_2453 - _2371) * 0.3010300099849701f);
                          int _2463 = int(_2462);
                          float _2465 = _2462 - float(_2463);
                          float _2467 = _17[_2463];
                          float _2470 = _17[(_2463 + 1)];
                          float _2475 = _2467 * 0.5f;
                          _2515 = dot(float3((_2465 * _2465), _2465, 1.0f), float3(mad((_17[(_2463 + 2)]), 0.5f, mad(_2470, -1.0f, _2475)), (_2470 - _2467), mad(_2470, 0.5f, _2475)));
                        } else {
                          do {
                            if (!(!(_2446 >= _2454))) {
                              float _2484 = log2(ACESMinMaxData.z);
                              if (_2446 < (_2484 * 0.3010300099849701f)) {
                                float _2492 = ((_2445 - _2453) * 0.9030900001525879f) / ((_2484 - _2453) * 0.3010300099849701f);
                                int _2493 = int(_2492);
                                float _2495 = _2492 - float(_2493);
                                float _2497 = _18[_2493];
                                float _2500 = _18[(_2493 + 1)];
                                float _2505 = _2497 * 0.5f;
                                _2515 = dot(float3((_2495 * _2495), _2495, 1.0f), float3(mad((_18[(_2493 + 2)]), 0.5f, mad(_2500, -1.0f, _2505)), (_2500 - _2497), mad(_2500, 0.5f, _2505)));
                                break;
                              }
                            }
                            _2515 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2519 = log2(max((lerp(_2358, _2357, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2520 = _2519 * 0.3010300099849701f;
                      do {
                        if (!(!(_2520 <= _2372))) {
                          _2589 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2527 = log2(ACESMidData.x);
                          float _2528 = _2527 * 0.3010300099849701f;
                          if ((bool)(_2520 > _2372) && (bool)(_2520 < _2528)) {
                            float _2536 = ((_2519 - _2371) * 0.9030900001525879f) / ((_2527 - _2371) * 0.3010300099849701f);
                            int _2537 = int(_2536);
                            float _2539 = _2536 - float(_2537);
                            float _2541 = _17[_2537];
                            float _2544 = _17[(_2537 + 1)];
                            float _2549 = _2541 * 0.5f;
                            _2589 = dot(float3((_2539 * _2539), _2539, 1.0f), float3(mad((_17[(_2537 + 2)]), 0.5f, mad(_2544, -1.0f, _2549)), (_2544 - _2541), mad(_2544, 0.5f, _2549)));
                          } else {
                            do {
                              if (!(!(_2520 >= _2528))) {
                                float _2558 = log2(ACESMinMaxData.z);
                                if (_2520 < (_2558 * 0.3010300099849701f)) {
                                  float _2566 = ((_2519 - _2527) * 0.9030900001525879f) / ((_2558 - _2527) * 0.3010300099849701f);
                                  int _2567 = int(_2566);
                                  float _2569 = _2566 - float(_2567);
                                  float _2571 = _18[_2567];
                                  float _2574 = _18[(_2567 + 1)];
                                  float _2579 = _2571 * 0.5f;
                                  _2589 = dot(float3((_2569 * _2569), _2569, 1.0f), float3(mad((_18[(_2567 + 2)]), 0.5f, mad(_2574, -1.0f, _2579)), (_2574 - _2571), mad(_2574, 0.5f, _2579)));
                                  break;
                                }
                              }
                              _2589 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2593 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2594 = (exp2(_2441 * 3.321928024291992f) - ACESMinMaxData.y) / _2593;
                        float _2596 = (exp2(_2515 * 3.321928024291992f) - ACESMinMaxData.y) / _2593;
                        float _2598 = (exp2(_2589 * 3.321928024291992f) - ACESMinMaxData.y) / _2593;
                        float _2601 = mad(0.15618768334388733f, _2598, mad(0.13400420546531677f, _2596, (_2594 * 0.6624541878700256f)));
                        float _2604 = mad(0.053689517080783844f, _2598, mad(0.6740817427635193f, _2596, (_2594 * 0.2722287178039551f)));
                        float _2607 = mad(1.0103391408920288f, _2598, mad(0.00406073359772563f, _2596, (_2594 * -0.005574649665504694f)));
                        float _2620 = min(max(mad(-0.23642469942569733f, _2607, mad(-0.32480329275131226f, _2604, (_2601 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2621 = min(max(mad(0.016756348311901093f, _2607, mad(1.6153316497802734f, _2604, (_2601 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2622 = min(max(mad(0.9883948564529419f, _2607, mad(-0.008284442126750946f, _2604, (_2601 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2625 = mad(0.15618768334388733f, _2622, mad(0.13400420546531677f, _2621, (_2620 * 0.6624541878700256f)));
                        float _2628 = mad(0.053689517080783844f, _2622, mad(0.6740817427635193f, _2621, (_2620 * 0.2722287178039551f)));
                        float _2631 = mad(1.0103391408920288f, _2622, mad(0.00406073359772563f, _2621, (_2620 * -0.005574649665504694f)));
                        float _2653 = min(max((min(max(mad(-0.23642469942569733f, _2631, mad(-0.32480329275131226f, _2628, (_2625 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2654 = min(max((min(max(mad(0.016756348311901093f, _2631, mad(1.6153316497802734f, _2628, (_2625 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2655 = min(max((min(max(mad(0.9883948564529419f, _2631, mad(-0.008284442126750946f, _2628, (_2625 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(OutputDevice) == 6)) {
                            _2668 = mad(_63, _2655, mad(_62, _2654, (_2653 * _61)));
                            _2669 = mad(_66, _2655, mad(_65, _2654, (_2653 * _64)));
                            _2670 = mad(_69, _2655, mad(_68, _2654, (_2653 * _67)));
                          } else {
                            _2668 = _2653;
                            _2669 = _2654;
                            _2670 = _2655;
                          }
                          float _2680 = exp2(log2(_2668 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2681 = exp2(log2(_2669 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2682 = exp2(log2(_2670 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2847 = exp2(log2((1.0f / ((_2680 * 18.6875f) + 1.0f)) * ((_2680 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2848 = exp2(log2((1.0f / ((_2681 * 18.6875f) + 1.0f)) * ((_2681 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2849 = exp2(log2((1.0f / ((_2682 * 18.6875f) + 1.0f)) * ((_2682 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2727 = mad((WorkingColorSpace_ToAP1[0].z), _1413, mad((WorkingColorSpace_ToAP1[0].y), _1412, ((WorkingColorSpace_ToAP1[0].x) * _1411)));
            float _2730 = mad((WorkingColorSpace_ToAP1[1].z), _1413, mad((WorkingColorSpace_ToAP1[1].y), _1412, ((WorkingColorSpace_ToAP1[1].x) * _1411)));
            float _2733 = mad((WorkingColorSpace_ToAP1[2].z), _1413, mad((WorkingColorSpace_ToAP1[2].y), _1412, ((WorkingColorSpace_ToAP1[2].x) * _1411)));
            float _2752 = exp2(log2(mad(_63, _2733, mad(_62, _2730, (_2727 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2753 = exp2(log2(mad(_66, _2733, mad(_65, _2730, (_2727 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2754 = exp2(log2(mad(_69, _2733, mad(_68, _2730, (_2727 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2847 = exp2(log2((1.0f / ((_2752 * 18.6875f) + 1.0f)) * ((_2752 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2848 = exp2(log2((1.0f / ((_2753 * 18.6875f) + 1.0f)) * ((_2753 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2849 = exp2(log2((1.0f / ((_2754 * 18.6875f) + 1.0f)) * ((_2754 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _2801 = mad((WorkingColorSpace_ToAP1[0].z), _1401, mad((WorkingColorSpace_ToAP1[0].y), _1400, ((WorkingColorSpace_ToAP1[0].x) * _1399)));
                float _2804 = mad((WorkingColorSpace_ToAP1[1].z), _1401, mad((WorkingColorSpace_ToAP1[1].y), _1400, ((WorkingColorSpace_ToAP1[1].x) * _1399)));
                float _2807 = mad((WorkingColorSpace_ToAP1[2].z), _1401, mad((WorkingColorSpace_ToAP1[2].y), _1400, ((WorkingColorSpace_ToAP1[2].x) * _1399)));
                _2847 = mad(_63, _2807, mad(_62, _2804, (_2801 * _61)));
                _2848 = mad(_66, _2807, mad(_65, _2804, (_2801 * _64)));
                _2849 = mad(_69, _2807, mad(_68, _2804, (_2801 * _67)));
              } else {
                float _2820 = mad((WorkingColorSpace_ToAP1[0].z), _1427, mad((WorkingColorSpace_ToAP1[0].y), _1426, ((WorkingColorSpace_ToAP1[0].x) * _1425)));
                float _2823 = mad((WorkingColorSpace_ToAP1[1].z), _1427, mad((WorkingColorSpace_ToAP1[1].y), _1426, ((WorkingColorSpace_ToAP1[1].x) * _1425)));
                float _2826 = mad((WorkingColorSpace_ToAP1[2].z), _1427, mad((WorkingColorSpace_ToAP1[2].y), _1426, ((WorkingColorSpace_ToAP1[2].x) * _1425)));
                _2847 = exp2(log2(mad(_63, _2826, mad(_62, _2823, (_2820 * _61)))) * InverseGamma.z);
                _2848 = exp2(log2(mad(_66, _2826, mad(_65, _2823, (_2820 * _64)))) * InverseGamma.z);
                _2849 = exp2(log2(mad(_69, _2826, mad(_68, _2823, (_2820 * _67)))) * InverseGamma.z);
              }
            } else {
              _2847 = _1411;
              _2848 = _1412;
              _2849 = _1413;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2847 * 0.9523810148239136f), (_2848 * 0.9523810148239136f), (_2849 * 0.9523810148239136f), 0.0f);
}

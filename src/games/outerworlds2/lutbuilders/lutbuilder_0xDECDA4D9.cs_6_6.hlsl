#include "./filmiclutbuilder.hlsl"

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};

RWTexture3D<float4> RWOutputTexture : register(u0);

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;
  bool is_hdr = (output_device >= 3u && output_device <= 6u);

  float4 SV_Target;

  float _9[6];
  float _10[6];
  float _11[6];
  float _12[6];
  float _24 = 0.5f / LUTSize;
  float _29 = LUTSize + -1.0f;
  float _30 = (LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _24)) / _29;
  float _31 = (LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _24)) / _29;
  float _33 = float((uint)SV_DispatchThreadID.z) / _29;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _119;
  float _120;
  float _121;
  float _169;
  float _897;
  float _930;
  float _944;
  float _1008;
  float _1276;
  float _1277;
  float _1278;
  float _1289;
  float _1300;
  float _1473;
  float _1488;
  float _1503;
  float _1511;
  float _1512;
  float _1513;
  float _1580;
  float _1613;
  float _1627;
  float _1666;
  float _1776;
  float _1850;
  float _1924;
  float _2003;
  float _2004;
  float _2005;
  float _2147;
  float _2162;
  float _2177;
  float _2185;
  float _2186;
  float _2187;
  float _2254;
  float _2287;
  float _2301;
  float _2340;
  float _2450;
  float _2524;
  float _2598;
  float _2677;
  float _2678;
  float _2679;
  float _2856;
  float _2857;
  float _2858;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _42 = (OutputGamut == 4);
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
  if ((uint)OutputDevice > (uint)2) {
    float _72 = (pow(_30, 0.012683313339948654f));
    float _73 = (pow(_31, 0.012683313339948654f));
    float _74 = (pow(_33, 0.012683313339948654f));
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _119 = ((exp2((_30 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _120 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _121 = ((exp2((_33 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _148 = (bIsTemperatureWhiteBalance != 0);
  float _152 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _169 = (((((2967800.0f - (_152 * 4607000064.0f)) * _152) + 99.11000061035156f) * _152) + 0.24406300485134125f);
  } else {
    _169 = (((((1901800.0f - (_152 * 2006400000.0f)) * _152) + 247.47999572753906f) * _152) + 0.23703999817371368f);
  }
  float _183 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _190 = WhiteTemp * WhiteTemp;
  float _193 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_190 * 1.6145605741257896e-07f));
  float _198 = ((_183 * 2.0f) + 4.0f) - (_193 * 8.0f);
  float _199 = (_183 * 3.0f) / _198;
  float _201 = (_193 * 2.0f) / _198;
  bool _202 = (WhiteTemp < 4000.0f);
  float _211 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _213 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_190 * 1.5317699909210205f)) / (_211 * _211);
  float _220 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _190;
  float _222 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_190 * 308.60699462890625f)) / (_220 * _220);
  float _224 = rsqrt(dot(float2(_213, _222), float2(_213, _222)));
  float _225 = WhiteTint * 0.05000000074505806f;
  float _228 = ((_225 * _222) * _224) + _183;
  float _231 = _193 - ((_225 * _213) * _224);
  float _236 = (4.0f - (_231 * 8.0f)) + (_228 * 2.0f);
  float _242 = (((_228 * 3.0f) / _236) - _199) + select(_202, _199, _169);
  float _243 = (((_231 * 2.0f) / _236) - _201) + select(_202, _201, (((_169 * 2.869999885559082f) + -0.2750000059604645f) - ((_169 * _169) * 3.0f)));
  float _244 = select(_148, _242, 0.3127000033855438f);
  float _245 = select(_148, _243, 0.32899999618530273f);
  float _246 = select(_148, 0.3127000033855438f, _242);
  float _247 = select(_148, 0.32899999618530273f, _243);
  float _248 = max(_245, 1.000000013351432e-10f);
  float _249 = _244 / _248;
  float _252 = ((1.0f - _244) - _245) / _248;
  float _253 = max(_247, 1.000000013351432e-10f);
  float _254 = _246 / _253;
  float _257 = ((1.0f - _246) - _247) / _253;
  float _276 = mad(-0.16140000522136688f, _257, ((_254 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _252, ((_249 * 0.8950999975204468f) + 0.266400009393692f));
  float _277 = mad(0.03669999912381172f, _257, (1.7135000228881836f - (_254 * 0.7501999735832214f))) / mad(0.03669999912381172f, _252, (1.7135000228881836f - (_249 * 0.7501999735832214f)));
  float _278 = mad(1.0296000242233276f, _257, ((_254 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _252, ((_249 * 0.03889999911189079f) + -0.06849999725818634f));
  float _279 = mad(_277, -0.7501999735832214f, 0.0f);
  float _280 = mad(_277, 1.7135000228881836f, 0.0f);
  float _281 = mad(_277, 0.03669999912381172f, -0.0f);
  float _282 = mad(_278, 0.03889999911189079f, 0.0f);
  float _283 = mad(_278, -0.06849999725818634f, 0.0f);
  float _284 = mad(_278, 1.0296000242233276f, 0.0f);
  float _287 = mad(0.1599626988172531f, _282, mad(-0.1470542997121811f, _279, (_276 * 0.883457362651825f)));
  float _290 = mad(0.1599626988172531f, _283, mad(-0.1470542997121811f, _280, (_276 * 0.26293492317199707f)));
  float _293 = mad(0.1599626988172531f, _284, mad(-0.1470542997121811f, _281, (_276 * -0.15930065512657166f)));
  float _296 = mad(0.04929120093584061f, _282, mad(0.5183603167533875f, _279, (_276 * 0.38695648312568665f)));
  float _299 = mad(0.04929120093584061f, _283, mad(0.5183603167533875f, _280, (_276 * 0.11516613513231277f)));
  float _302 = mad(0.04929120093584061f, _284, mad(0.5183603167533875f, _281, (_276 * -0.0697740763425827f)));
  float _305 = mad(0.9684867262840271f, _282, mad(0.04004279896616936f, _279, (_276 * -0.007634039502590895f)));
  float _308 = mad(0.9684867262840271f, _283, mad(0.04004279896616936f, _280, (_276 * -0.0022720457054674625f)));
  float _311 = mad(0.9684867262840271f, _284, mad(0.04004279896616936f, _281, (_276 * 0.0013765322510153055f)));
  float _314 = mad(_293, (WorkingColorSpace.ToXYZ[2].x), mad(_290, (WorkingColorSpace.ToXYZ[1].x), (_287 * (WorkingColorSpace.ToXYZ[0].x))));
  float _317 = mad(_293, (WorkingColorSpace.ToXYZ[2].y), mad(_290, (WorkingColorSpace.ToXYZ[1].y), (_287 * (WorkingColorSpace.ToXYZ[0].y))));
  float _320 = mad(_293, (WorkingColorSpace.ToXYZ[2].z), mad(_290, (WorkingColorSpace.ToXYZ[1].z), (_287 * (WorkingColorSpace.ToXYZ[0].z))));
  float _323 = mad(_302, (WorkingColorSpace.ToXYZ[2].x), mad(_299, (WorkingColorSpace.ToXYZ[1].x), (_296 * (WorkingColorSpace.ToXYZ[0].x))));
  float _326 = mad(_302, (WorkingColorSpace.ToXYZ[2].y), mad(_299, (WorkingColorSpace.ToXYZ[1].y), (_296 * (WorkingColorSpace.ToXYZ[0].y))));
  float _329 = mad(_302, (WorkingColorSpace.ToXYZ[2].z), mad(_299, (WorkingColorSpace.ToXYZ[1].z), (_296 * (WorkingColorSpace.ToXYZ[0].z))));
  float _332 = mad(_311, (WorkingColorSpace.ToXYZ[2].x), mad(_308, (WorkingColorSpace.ToXYZ[1].x), (_305 * (WorkingColorSpace.ToXYZ[0].x))));
  float _335 = mad(_311, (WorkingColorSpace.ToXYZ[2].y), mad(_308, (WorkingColorSpace.ToXYZ[1].y), (_305 * (WorkingColorSpace.ToXYZ[0].y))));
  float _338 = mad(_311, (WorkingColorSpace.ToXYZ[2].z), mad(_308, (WorkingColorSpace.ToXYZ[1].z), (_305 * (WorkingColorSpace.ToXYZ[0].z))));
  float _368 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _338, mad((WorkingColorSpace.FromXYZ[0].y), _329, (_320 * (WorkingColorSpace.FromXYZ[0].x)))), _121, mad(mad((WorkingColorSpace.FromXYZ[0].z), _335, mad((WorkingColorSpace.FromXYZ[0].y), _326, (_317 * (WorkingColorSpace.FromXYZ[0].x)))), _120, (mad((WorkingColorSpace.FromXYZ[0].z), _332, mad((WorkingColorSpace.FromXYZ[0].y), _323, (_314 * (WorkingColorSpace.FromXYZ[0].x)))) * _119)));
  float _371 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _338, mad((WorkingColorSpace.FromXYZ[1].y), _329, (_320 * (WorkingColorSpace.FromXYZ[1].x)))), _121, mad(mad((WorkingColorSpace.FromXYZ[1].z), _335, mad((WorkingColorSpace.FromXYZ[1].y), _326, (_317 * (WorkingColorSpace.FromXYZ[1].x)))), _120, (mad((WorkingColorSpace.FromXYZ[1].z), _332, mad((WorkingColorSpace.FromXYZ[1].y), _323, (_314 * (WorkingColorSpace.FromXYZ[1].x)))) * _119)));
  float _374 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _338, mad((WorkingColorSpace.FromXYZ[2].y), _329, (_320 * (WorkingColorSpace.FromXYZ[2].x)))), _121, mad(mad((WorkingColorSpace.FromXYZ[2].z), _335, mad((WorkingColorSpace.FromXYZ[2].y), _326, (_317 * (WorkingColorSpace.FromXYZ[2].x)))), _120, (mad((WorkingColorSpace.FromXYZ[2].z), _332, mad((WorkingColorSpace.FromXYZ[2].y), _323, (_314 * (WorkingColorSpace.FromXYZ[2].x)))) * _119)));
  float _389 = mad((WorkingColorSpace.ToAP1[0].z), _374, mad((WorkingColorSpace.ToAP1[0].y), _371, ((WorkingColorSpace.ToAP1[0].x) * _368)));
  float _392 = mad((WorkingColorSpace.ToAP1[1].z), _374, mad((WorkingColorSpace.ToAP1[1].y), _371, ((WorkingColorSpace.ToAP1[1].x) * _368)));
  float _395 = mad((WorkingColorSpace.ToAP1[2].z), _374, mad((WorkingColorSpace.ToAP1[2].y), _371, ((WorkingColorSpace.ToAP1[2].x) * _368)));
  float _396 = dot(float3(_389, _392, _395), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _400 = (_389 / _396) + -1.0f;
  float _401 = (_392 / _396) + -1.0f;
  float _402 = (_395 / _396) + -1.0f;
  float _414 = (1.0f - exp2(((_396 * _396) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_400, _401, _402), float3(_400, _401, _402)) * -4.0f));
  float _430 = ((mad(-0.06368321925401688f, _395, mad(-0.3292922377586365f, _392, (_389 * 1.3704125881195068f))) - _389) * _414) + _389;
  float _431 = ((mad(-0.010861365124583244f, _395, mad(1.0970927476882935f, _392, (_389 * -0.08343357592821121f))) - _392) * _414) + _392;
  float _432 = ((mad(1.2036951780319214f, _395, mad(-0.09862580895423889f, _392, (_389 * -0.02579331398010254f))) - _395) * _414) + _395;
  float _433 = dot(float3(_430, _431, _432), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _447 = ColorOffset.w + ColorOffsetShadows.w;
  float _461 = ColorGain.w * ColorGainShadows.w;
  float _475 = ColorGamma.w * ColorGammaShadows.w;
  float _489 = ColorContrast.w * ColorContrastShadows.w;
  float _503 = ColorSaturation.w * ColorSaturationShadows.w;
  float _507 = _430 - _433;
  float _508 = _431 - _433;
  float _509 = _432 - _433;
  float _566 = saturate(_433 / ColorCorrectionShadowsMax);
  float _570 = (_566 * _566) * (3.0f - (_566 * 2.0f));
  float _571 = 1.0f - _570;
  float _580 = ColorOffset.w + ColorOffsetHighlights.w;
  float _589 = ColorGain.w * ColorGainHighlights.w;
  float _598 = ColorGamma.w * ColorGammaHighlights.w;
  float _607 = ColorContrast.w * ColorContrastHighlights.w;
  float _616 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _679 = saturate((_433 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _683 = (_679 * _679) * (3.0f - (_679 * 2.0f));
  float _692 = ColorOffset.w + ColorOffsetMidtones.w;
  float _701 = ColorGain.w * ColorGainMidtones.w;
  float _710 = ColorGamma.w * ColorGammaMidtones.w;
  float _719 = ColorContrast.w * ColorContrastMidtones.w;
  float _728 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _786 = _570 - _683;
  float _797 = ((_683 * (((ColorOffset.x + ColorOffsetHighlights.x) + _580) + (((ColorGain.x * ColorGainHighlights.x) * _589) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _607) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _616) * _507) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _598)))))) + (_571 * (((ColorOffset.x + ColorOffsetShadows.x) + _447) + (((ColorGain.x * ColorGainShadows.x) * _461) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _489) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _503) * _507) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _475))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _692) + (((ColorGain.x * ColorGainMidtones.x) * _701) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _719) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _728) * _507) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _710))))) * _786);
  float _799 = ((_683 * (((ColorOffset.y + ColorOffsetHighlights.y) + _580) + (((ColorGain.y * ColorGainHighlights.y) * _589) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _607) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _616) * _508) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _598)))))) + (_571 * (((ColorOffset.y + ColorOffsetShadows.y) + _447) + (((ColorGain.y * ColorGainShadows.y) * _461) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _489) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _503) * _508) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _475))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _692) + (((ColorGain.y * ColorGainMidtones.y) * _701) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _719) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _728) * _508) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _710))))) * _786);
  float _801 = ((_683 * (((ColorOffset.z + ColorOffsetHighlights.z) + _580) + (((ColorGain.z * ColorGainHighlights.z) * _589) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _607) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _616) * _509) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _598)))))) + (_571 * (((ColorOffset.z + ColorOffsetShadows.z) + _447) + (((ColorGain.z * ColorGainShadows.z) * _461) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _489) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _503) * _509) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _475))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _692) + (((ColorGain.z * ColorGainMidtones.z) * _701) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _719) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _728) * _509) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _710))))) * _786);
  float _837 = ((mad(0.061360642313957214f, _801, mad(-4.540197551250458e-09f, _799, (_797 * 0.9386394023895264f))) - _797) * BlueCorrection) + _797;
  float _838 = ((mad(0.169205904006958f, _801, mad(0.8307942152023315f, _799, (_797 * 6.775371730327606e-08f))) - _799) * BlueCorrection) + _799;
  float _839 = (mad(-2.3283064365386963e-10f, _799, (_797 * -9.313225746154785e-10f)) * BlueCorrection) + _801;
  float _842 = mad(0.16386905312538147f, _839, mad(0.14067868888378143f, _838, (_837 * 0.6954522132873535f)));
  float _845 = mad(0.0955343246459961f, _839, mad(0.8596711158752441f, _838, (_837 * 0.044794581830501556f)));
  float _848 = mad(1.0015007257461548f, _839, mad(0.004025210160762072f, _838, (_837 * -0.005525882821530104f)));
  float _852 = max(max(_842, _845), _848);
  float _857 = (max(_852, 1.000000013351432e-10f) - max(min(min(_842, _845), _848), 1.000000013351432e-10f)) / max(_852, 0.009999999776482582f);
  float _870 = ((_845 + _842) + _848) + (sqrt((((_848 - _845) * _848) + ((_845 - _842) * _845)) + ((_842 - _848) * _842)) * 1.75f);
  float _871 = _870 * 0.3333333432674408f;
  float _872 = _857 + -0.4000000059604645f;
  float _873 = _872 * 5.0f;
  float _877 = max((1.0f - abs(_872 * 2.5f)), 0.0f);
  float _888 = ((float((int)(((int)(uint)((bool)(_873 > 0.0f))) - ((int)(uint)((bool)(_873 < 0.0f))))) * (1.0f - (_877 * _877))) + 1.0f) * 0.02500000037252903f;
  if (!(_871 <= 0.0533333346247673f)) {
    if (!(_871 >= 0.1599999964237213f)) {
      _897 = (((0.23999999463558197f / _870) + -0.5f) * _888);
    } else {
      _897 = 0.0f;
    }
  } else {
    _897 = _888;
  }
  float _898 = _897 + 1.0f;
  float _899 = _898 * _842;
  float _900 = _898 * _845;
  float _901 = _898 * _848;
  if (!((bool)(_899 == _900) && (bool)(_900 == _901))) {
    float _908 = ((_899 * 2.0f) - _900) - _901;
    float _911 = ((_845 - _848) * 1.7320507764816284f) * _898;
    float _913 = atan(_911 / _908);
    bool _916 = (_908 < 0.0f);
    bool _917 = (_908 == 0.0f);
    bool _918 = (_911 >= 0.0f);
    bool _919 = (_911 < 0.0f);
    _930 = select((_918 && _917), 90.0f, select((_919 && _917), -90.0f, (select((_919 && _916), (_913 + -3.1415927410125732f), select((_918 && _916), (_913 + 3.1415927410125732f), _913)) * 57.2957763671875f)));
  } else {
    _930 = 0.0f;
  }
  float _935 = min(max(select((_930 < 0.0f), (_930 + 360.0f), _930), 0.0f), 360.0f);
  if (_935 < -180.0f) {
    _944 = (_935 + 360.0f);
  } else {
    if (_935 > 180.0f) {
      _944 = (_935 + -360.0f);
    } else {
      _944 = _935;
    }
  }
  float _948 = saturate(1.0f - abs(_944 * 0.014814814552664757f));
  float _952 = (_948 * _948) * (3.0f - (_948 * 2.0f));
  float _958 = ((_952 * _952) * ((_857 * 0.18000000715255737f) * (0.029999999329447746f - _899))) + _899;
  float _968 = max(0.0f, mad(-0.21492856740951538f, _901, mad(-0.2365107536315918f, _900, (_958 * 1.4514392614364624f))));
  float _969 = max(0.0f, mad(-0.09967592358589172f, _901, mad(1.17622971534729f, _900, (_958 * -0.07655377686023712f))));
  float _970 = max(0.0f, mad(0.9977163076400757f, _901, mad(-0.006032449658960104f, _900, (_958 * 0.008316148072481155f))));
  float _971 = dot(float3(_968, _969, _970), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float3 lerpColor = lerp(_971, float3(_968, _969, _970), 0.9599999785423279f);

#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _837, _838, _839);
  float _1159 = lerpColor.r, _1160 = lerpColor.g, _1161 = lerpColor.b;
#else
  float _986 = (FilmBlackClip + 1.0f) - FilmToe;
  float _988 = FilmWhiteClip + 1.0f;
  float _990 = _988 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1008 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _999 = (FilmBlackClip + 0.18000000715255737f) / _986;
    _1008 = (-0.7447274923324585f - ((log2(_999 / (2.0f - _999)) * 0.3465735912322998f) * (_986 / FilmSlope)));
  }
  float _1011 = ((1.0f - FilmToe) / FilmSlope) - _1008;
  float _1013 = (FilmShoulder / FilmSlope) - _1011;
  float _1017 = log2(lerp(_971, _968, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1018 = log2(lerp(_971, _969, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1019 = log2(lerp(_971, _970, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1023 = FilmSlope * (_1017 + _1011);
  float _1024 = FilmSlope * (_1018 + _1011);
  float _1025 = FilmSlope * (_1019 + _1011);
  float _1026 = _986 * 2.0f;
  float _1028 = (FilmSlope * -2.0f) / _986;
  float _1029 = _1017 - _1008;
  float _1030 = _1018 - _1008;
  float _1031 = _1019 - _1008;
  float _1050 = _990 * 2.0f;
  float _1052 = (FilmSlope * 2.0f) / _990;
  float _1077 = select((_1017 < _1008), ((_1026 / (exp2((_1029 * 1.4426950216293335f) * _1028) + 1.0f)) - FilmBlackClip), _1023);
  float _1078 = select((_1018 < _1008), ((_1026 / (exp2((_1030 * 1.4426950216293335f) * _1028) + 1.0f)) - FilmBlackClip), _1024);
  float _1079 = select((_1019 < _1008), ((_1026 / (exp2((_1031 * 1.4426950216293335f) * _1028) + 1.0f)) - FilmBlackClip), _1025);
  float _1086 = _1013 - _1008;
  float _1090 = saturate(_1029 / _1086);
  float _1091 = saturate(_1030 / _1086);
  float _1092 = saturate(_1031 / _1086);
  bool _1093 = (_1013 < _1008);
  float _1097 = select(_1093, (1.0f - _1090), _1090);
  float _1098 = select(_1093, (1.0f - _1091), _1091);
  float _1099 = select(_1093, (1.0f - _1092), _1092);
  float _1118 = (((_1097 * _1097) * (select((_1017 > _1013), (_988 - (_1050 / (exp2(((_1017 - _1013) * 1.4426950216293335f) * _1052) + 1.0f))), _1023) - _1077)) * (3.0f - (_1097 * 2.0f))) + _1077;
  float _1119 = (((_1098 * _1098) * (select((_1018 > _1013), (_988 - (_1050 / (exp2(((_1018 - _1013) * 1.4426950216293335f) * _1052) + 1.0f))), _1024) - _1078)) * (3.0f - (_1098 * 2.0f))) + _1078;
  float _1120 = (((_1099 * _1099) * (select((_1019 > _1013), (_988 - (_1050 / (exp2(((_1019 - _1013) * 1.4426950216293335f) * _1052) + 1.0f))), _1025) - _1079)) * (3.0f - (_1099 * 2.0f))) + _1079;
  float _1121 = dot(float3(_1118, _1119, _1120), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1141 = (ToneCurveAmount * (max(0.0f, (lerp(_1121, _1118, 0.9300000071525574f))) - _837)) + _837;
  float _1142 = (ToneCurveAmount * (max(0.0f, (lerp(_1121, _1119, 0.9300000071525574f))) - _838)) + _838;
  float _1143 = (ToneCurveAmount * (max(0.0f, (lerp(_1121, _1120, 0.9300000071525574f))) - _839)) + _839;
  float _1159 = ((mad(-0.06537103652954102f, _1143, mad(1.451815478503704e-06f, _1142, (_1141 * 1.065374732017517f))) - _1141) * BlueCorrection) + _1141;
  float _1160 = ((mad(-0.20366770029067993f, _1143, mad(1.2036634683609009f, _1142, (_1141 * -2.57161445915699e-07f))) - _1142) * BlueCorrection) + _1142;
  float _1161 = ((mad(0.9999996423721313f, _1143, mad(2.0954757928848267e-08f, _1142, (_1141 * 1.862645149230957e-08f))) - _1143) * BlueCorrection) + _1143;
#endif

  // remove max
  float _1171 = mad((WorkingColorSpace.FromAP1[0].z), _1161, mad((WorkingColorSpace.FromAP1[0].y), _1160, ((WorkingColorSpace.FromAP1[0].x) * _1159)));
  float _1172 = mad((WorkingColorSpace.FromAP1[1].z), _1161, mad((WorkingColorSpace.FromAP1[1].y), _1160, ((WorkingColorSpace.FromAP1[1].x) * _1159)));
  float _1173 = mad((WorkingColorSpace.FromAP1[2].z), _1161, mad((WorkingColorSpace.FromAP1[2].y), _1160, ((WorkingColorSpace.FromAP1[2].x) * _1159)));
  float _1199 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1171)) * _1171) + MappingPolynomial.z);
  float _1200 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1172)) * _1172) + MappingPolynomial.z);
  float _1201 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1173)) * _1173) + MappingPolynomial.z);
  float _1208 = ((OverlayColor.x - _1199) * OverlayColor.w) + _1199;
  float _1209 = ((OverlayColor.y - _1200) * OverlayColor.w) + _1200;
  float _1210 = ((OverlayColor.z - _1201) * OverlayColor.w) + _1201;
  float _1211 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _801, mad((WorkingColorSpace.FromAP1[0].y), _799, (_797 * (WorkingColorSpace.FromAP1[0].x))));
  float _1212 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _801, mad((WorkingColorSpace.FromAP1[1].y), _799, ((WorkingColorSpace.FromAP1[1].x) * _797)));
  float _1213 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _801, mad((WorkingColorSpace.FromAP1[2].y), _799, ((WorkingColorSpace.FromAP1[2].x) * _797)));
  float _1220 = ((OverlayColor.x - _1211) * OverlayColor.w) + _1211;
  float _1221 = ((OverlayColor.y - _1212) * OverlayColor.w) + _1212;
  float _1222 = ((OverlayColor.z - _1213) * OverlayColor.w) + _1213;
  float _1234 = exp2(log2(max(0.0f, _1208)) * InverseGamma.y);
  float _1235 = exp2(log2(max(0.0f, _1209)) * InverseGamma.y);
  float _1236 = exp2(log2(max(0.0f, _1210)) * InverseGamma.y);

  if (GenerateOutput(_1234, _1235, _1236, SV_Target, is_hdr)) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = SV_Target;
    return;
  }

  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace.bIsSRGB == 0) {
        float _1259 = mad((WorkingColorSpace.ToAP1[0].z), _1236, mad((WorkingColorSpace.ToAP1[0].y), _1235, ((WorkingColorSpace.ToAP1[0].x) * _1234)));
        float _1262 = mad((WorkingColorSpace.ToAP1[1].z), _1236, mad((WorkingColorSpace.ToAP1[1].y), _1235, ((WorkingColorSpace.ToAP1[1].x) * _1234)));
        float _1265 = mad((WorkingColorSpace.ToAP1[2].z), _1236, mad((WorkingColorSpace.ToAP1[2].y), _1235, ((WorkingColorSpace.ToAP1[2].x) * _1234)));
        _1276 = mad(_55, _1265, mad(_54, _1262, (_1259 * _53)));
        _1277 = mad(_58, _1265, mad(_57, _1262, (_1259 * _56)));
        _1278 = mad(_61, _1265, mad(_60, _1262, (_1259 * _59)));
      } else {
        _1276 = _1234;
        _1277 = _1235;
        _1278 = _1236;
      }
      do {
        if (_1276 < 0.0031306699384003878f) {
          _1289 = (_1276 * 12.920000076293945f);
        } else {
          _1289 = (((pow(_1276, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1277 < 0.0031306699384003878f) {
            _1300 = (_1277 * 12.920000076293945f);
          } else {
            _1300 = (((pow(_1277, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1278 < 0.0031306699384003878f) {
            _2856 = _1289;
            _2857 = _1300;
            _2858 = (_1278 * 12.920000076293945f);
          } else {
            _2856 = _1289;
            _2857 = _1300;
            _2858 = (((pow(_1278, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1327 = mad((WorkingColorSpace.ToAP1[0].z), _1236, mad((WorkingColorSpace.ToAP1[0].y), _1235, ((WorkingColorSpace.ToAP1[0].x) * _1234)));
      float _1330 = mad((WorkingColorSpace.ToAP1[1].z), _1236, mad((WorkingColorSpace.ToAP1[1].y), _1235, ((WorkingColorSpace.ToAP1[1].x) * _1234)));
      float _1333 = mad((WorkingColorSpace.ToAP1[2].z), _1236, mad((WorkingColorSpace.ToAP1[2].y), _1235, ((WorkingColorSpace.ToAP1[2].x) * _1234)));
      float _1343 = max(6.103519990574569e-05f, mad(_55, _1333, mad(_54, _1330, (_1327 * _53))));
      float _1344 = max(6.103519990574569e-05f, mad(_58, _1333, mad(_57, _1330, (_1327 * _56))));
      float _1345 = max(6.103519990574569e-05f, mad(_61, _1333, mad(_60, _1330, (_1327 * _59))));
      _2856 = min((_1343 * 4.5f), ((exp2(log2(max(_1343, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2857 = min((_1344 * 4.5f), ((exp2(log2(max(_1344, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2858 = min((_1345 * 4.5f), ((exp2(log2(max(_1345, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1421 = ACESSceneColorMultiplier * _1220;
        float _1422 = ACESSceneColorMultiplier * _1221;
        float _1423 = ACESSceneColorMultiplier * _1222;
        float _1426 = mad((WorkingColorSpace.ToAP0[0].z), _1423, mad((WorkingColorSpace.ToAP0[0].y), _1422, ((WorkingColorSpace.ToAP0[0].x) * _1421)));
        float _1429 = mad((WorkingColorSpace.ToAP0[1].z), _1423, mad((WorkingColorSpace.ToAP0[1].y), _1422, ((WorkingColorSpace.ToAP0[1].x) * _1421)));
        float _1432 = mad((WorkingColorSpace.ToAP0[2].z), _1423, mad((WorkingColorSpace.ToAP0[2].y), _1422, ((WorkingColorSpace.ToAP0[2].x) * _1421)));
        float _1435 = mad(-0.21492856740951538f, _1432, mad(-0.2365107536315918f, _1429, (_1426 * 1.4514392614364624f)));
        float _1438 = mad(-0.09967592358589172f, _1432, mad(1.17622971534729f, _1429, (_1426 * -0.07655377686023712f)));
        float _1441 = mad(0.9977163076400757f, _1432, mad(-0.006032449658960104f, _1429, (_1426 * 0.008316148072481155f)));
        float _1443 = max(_1435, max(_1438, _1441));
        do {
          if (!(_1443 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1426 < 0.0f) || (bool)(_1429 < 0.0f))) || (bool)(_1432 < 0.0f))) {
              float _1453 = abs(_1443);
              float _1454 = (_1443 - _1435) / _1453;
              float _1456 = (_1443 - _1438) / _1453;
              float _1458 = (_1443 - _1441) / _1453;
              do {
                if (!(_1454 < 0.8149999976158142f)) {
                  float _1461 = _1454 + -0.8149999976158142f;
                  _1473 = ((_1461 / exp2(log2(exp2(log2(_1461 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1473 = _1454;
                }
                do {
                  if (!(_1456 < 0.8029999732971191f)) {
                    float _1476 = _1456 + -0.8029999732971191f;
                    _1488 = ((_1476 / exp2(log2(exp2(log2(_1476 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1488 = _1456;
                  }
                  do {
                    if (!(_1458 < 0.8799999952316284f)) {
                      float _1491 = _1458 + -0.8799999952316284f;
                      _1503 = ((_1491 / exp2(log2(exp2(log2(_1491 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1503 = _1458;
                    }
                    _1511 = (_1443 - (_1453 * _1473));
                    _1512 = (_1443 - (_1453 * _1488));
                    _1513 = (_1443 - (_1453 * _1503));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1511 = _1435;
              _1512 = _1438;
              _1513 = _1441;
            }
          } else {
            _1511 = _1435;
            _1512 = _1438;
            _1513 = _1441;
          }
          float _1529 = ((mad(0.16386906802654266f, _1513, mad(0.14067870378494263f, _1512, (_1511 * 0.6954522132873535f))) - _1426) * ACESGamutCompression) + _1426;
          float _1530 = ((mad(0.0955343171954155f, _1513, mad(0.8596711158752441f, _1512, (_1511 * 0.044794563204050064f))) - _1429) * ACESGamutCompression) + _1429;
          float _1531 = ((mad(1.0015007257461548f, _1513, mad(0.004025210160762072f, _1512, (_1511 * -0.005525882821530104f))) - _1432) * ACESGamutCompression) + _1432;
          float _1535 = max(max(_1529, _1530), _1531);
          float _1540 = (max(_1535, 1.000000013351432e-10f) - max(min(min(_1529, _1530), _1531), 1.000000013351432e-10f)) / max(_1535, 0.009999999776482582f);
          float _1553 = ((_1530 + _1529) + _1531) + (sqrt((((_1531 - _1530) * _1531) + ((_1530 - _1529) * _1530)) + ((_1529 - _1531) * _1529)) * 1.75f);
          float _1554 = _1553 * 0.3333333432674408f;
          float _1555 = _1540 + -0.4000000059604645f;
          float _1556 = _1555 * 5.0f;
          float _1560 = max((1.0f - abs(_1555 * 2.5f)), 0.0f);
          float _1571 = ((float((int)(((int)(uint)((bool)(_1556 > 0.0f))) - ((int)(uint)((bool)(_1556 < 0.0f))))) * (1.0f - (_1560 * _1560))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1554 <= 0.0533333346247673f)) {
              if (!(_1554 >= 0.1599999964237213f)) {
                _1580 = (((0.23999999463558197f / _1553) + -0.5f) * _1571);
              } else {
                _1580 = 0.0f;
              }
            } else {
              _1580 = _1571;
            }
            float _1581 = _1580 + 1.0f;
            float _1582 = _1581 * _1529;
            float _1583 = _1581 * _1530;
            float _1584 = _1581 * _1531;
            do {
              if (!((bool)(_1582 == _1583) && (bool)(_1583 == _1584))) {
                float _1591 = ((_1582 * 2.0f) - _1583) - _1584;
                float _1594 = ((_1530 - _1531) * 1.7320507764816284f) * _1581;
                float _1596 = atan(_1594 / _1591);
                bool _1599 = (_1591 < 0.0f);
                bool _1600 = (_1591 == 0.0f);
                bool _1601 = (_1594 >= 0.0f);
                bool _1602 = (_1594 < 0.0f);
                _1613 = select((_1601 && _1600), 90.0f, select((_1602 && _1600), -90.0f, (select((_1602 && _1599), (_1596 + -3.1415927410125732f), select((_1601 && _1599), (_1596 + 3.1415927410125732f), _1596)) * 57.2957763671875f)));
              } else {
                _1613 = 0.0f;
              }
              float _1618 = min(max(select((_1613 < 0.0f), (_1613 + 360.0f), _1613), 0.0f), 360.0f);
              do {
                if (_1618 < -180.0f) {
                  _1627 = (_1618 + 360.0f);
                } else {
                  if (_1618 > 180.0f) {
                    _1627 = (_1618 + -360.0f);
                  } else {
                    _1627 = _1618;
                  }
                }
                do {
                  if ((bool)(_1627 > -67.5f) && (bool)(_1627 < 67.5f)) {
                    float _1633 = (_1627 + 67.5f) * 0.029629629105329514f;
                    int _1634 = int(_1633);
                    float _1636 = _1633 - float((int)(_1634));
                    float _1637 = _1636 * _1636;
                    float _1638 = _1637 * _1636;
                    if (_1634 == 3) {
                      _1666 = (((0.1666666716337204f - (_1636 * 0.5f)) + (_1637 * 0.5f)) - (_1638 * 0.1666666716337204f));
                    } else {
                      if (_1634 == 2) {
                        _1666 = ((0.6666666865348816f - _1637) + (_1638 * 0.5f));
                      } else {
                        if (_1634 == 1) {
                          _1666 = (((_1638 * -0.5f) + 0.1666666716337204f) + ((_1637 + _1636) * 0.5f));
                        } else {
                          _1666 = select((_1634 == 0), (_1638 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1666 = 0.0f;
                  }
                  float _1675 = min(max(((((_1540 * 0.27000001072883606f) * (0.029999999329447746f - _1582)) * _1666) + _1582), 0.0f), 65535.0f);
                  float _1676 = min(max(_1583, 0.0f), 65535.0f);
                  float _1677 = min(max(_1584, 0.0f), 65535.0f);
                  float _1690 = min(max(mad(-0.21492856740951538f, _1677, mad(-0.2365107536315918f, _1676, (_1675 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1691 = min(max(mad(-0.09967592358589172f, _1677, mad(1.17622971534729f, _1676, (_1675 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1692 = min(max(mad(0.9977163076400757f, _1677, mad(-0.006032449658960104f, _1676, (_1675 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1693 = dot(float3(_1690, _1691, _1692), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1704 = log2(max((lerp(_1693, _1690, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1705 = _1704 * 0.3010300099849701f;
                  float _1706 = log2(ACESMinMaxData.x);
                  float _1707 = _1706 * 0.3010300099849701f;
                  do {
                    if (!(!(_1705 <= _1707))) {
                      _1776 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1714 = log2(ACESMidData.x);
                      float _1715 = _1714 * 0.3010300099849701f;
                      if ((bool)(_1705 > _1707) && (bool)(_1705 < _1715)) {
                        float _1723 = ((_1704 - _1706) * 0.9030900001525879f) / ((_1714 - _1706) * 0.3010300099849701f);
                        int _1724 = int(_1723);
                        float _1726 = _1723 - float((int)(_1724));
                        float _1728 = _11[_1724];
                        float _1731 = _11[(_1724 + 1)];
                        float _1736 = _1728 * 0.5f;
                        _1776 = dot(float3((_1726 * _1726), _1726, 1.0f), float3(mad((_11[(_1724 + 2)]), 0.5f, mad(_1731, -1.0f, _1736)), (_1731 - _1728), mad(_1731, 0.5f, _1736)));
                      } else {
                        do {
                          if (!(!(_1705 >= _1715))) {
                            float _1745 = log2(ACESMinMaxData.z);
                            if (_1705 < (_1745 * 0.3010300099849701f)) {
                              float _1753 = ((_1704 - _1714) * 0.9030900001525879f) / ((_1745 - _1714) * 0.3010300099849701f);
                              int _1754 = int(_1753);
                              float _1756 = _1753 - float((int)(_1754));
                              float _1758 = _12[_1754];
                              float _1761 = _12[(_1754 + 1)];
                              float _1766 = _1758 * 0.5f;
                              _1776 = dot(float3((_1756 * _1756), _1756, 1.0f), float3(mad((_12[(_1754 + 2)]), 0.5f, mad(_1761, -1.0f, _1766)), (_1761 - _1758), mad(_1761, 0.5f, _1766)));
                              break;
                            }
                          }
                          _1776 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1780 = log2(max((lerp(_1693, _1691, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1781 = _1780 * 0.3010300099849701f;
                    do {
                      if (!(!(_1781 <= _1707))) {
                        _1850 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1788 = log2(ACESMidData.x);
                        float _1789 = _1788 * 0.3010300099849701f;
                        if ((bool)(_1781 > _1707) && (bool)(_1781 < _1789)) {
                          float _1797 = ((_1780 - _1706) * 0.9030900001525879f) / ((_1788 - _1706) * 0.3010300099849701f);
                          int _1798 = int(_1797);
                          float _1800 = _1797 - float((int)(_1798));
                          float _1802 = _11[_1798];
                          float _1805 = _11[(_1798 + 1)];
                          float _1810 = _1802 * 0.5f;
                          _1850 = dot(float3((_1800 * _1800), _1800, 1.0f), float3(mad((_11[(_1798 + 2)]), 0.5f, mad(_1805, -1.0f, _1810)), (_1805 - _1802), mad(_1805, 0.5f, _1810)));
                        } else {
                          do {
                            if (!(!(_1781 >= _1789))) {
                              float _1819 = log2(ACESMinMaxData.z);
                              if (_1781 < (_1819 * 0.3010300099849701f)) {
                                float _1827 = ((_1780 - _1788) * 0.9030900001525879f) / ((_1819 - _1788) * 0.3010300099849701f);
                                int _1828 = int(_1827);
                                float _1830 = _1827 - float((int)(_1828));
                                float _1832 = _12[_1828];
                                float _1835 = _12[(_1828 + 1)];
                                float _1840 = _1832 * 0.5f;
                                _1850 = dot(float3((_1830 * _1830), _1830, 1.0f), float3(mad((_12[(_1828 + 2)]), 0.5f, mad(_1835, -1.0f, _1840)), (_1835 - _1832), mad(_1835, 0.5f, _1840)));
                                break;
                              }
                            }
                            _1850 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1854 = log2(max((lerp(_1693, _1692, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1855 = _1854 * 0.3010300099849701f;
                      do {
                        if (!(!(_1855 <= _1707))) {
                          _1924 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1862 = log2(ACESMidData.x);
                          float _1863 = _1862 * 0.3010300099849701f;
                          if ((bool)(_1855 > _1707) && (bool)(_1855 < _1863)) {
                            float _1871 = ((_1854 - _1706) * 0.9030900001525879f) / ((_1862 - _1706) * 0.3010300099849701f);
                            int _1872 = int(_1871);
                            float _1874 = _1871 - float((int)(_1872));
                            float _1876 = _11[_1872];
                            float _1879 = _11[(_1872 + 1)];
                            float _1884 = _1876 * 0.5f;
                            _1924 = dot(float3((_1874 * _1874), _1874, 1.0f), float3(mad((_11[(_1872 + 2)]), 0.5f, mad(_1879, -1.0f, _1884)), (_1879 - _1876), mad(_1879, 0.5f, _1884)));
                          } else {
                            do {
                              if (!(!(_1855 >= _1863))) {
                                float _1893 = log2(ACESMinMaxData.z);
                                if (_1855 < (_1893 * 0.3010300099849701f)) {
                                  float _1901 = ((_1854 - _1862) * 0.9030900001525879f) / ((_1893 - _1862) * 0.3010300099849701f);
                                  int _1902 = int(_1901);
                                  float _1904 = _1901 - float((int)(_1902));
                                  float _1906 = _12[_1902];
                                  float _1909 = _12[(_1902 + 1)];
                                  float _1914 = _1906 * 0.5f;
                                  _1924 = dot(float3((_1904 * _1904), _1904, 1.0f), float3(mad((_12[(_1902 + 2)]), 0.5f, mad(_1909, -1.0f, _1914)), (_1909 - _1906), mad(_1909, 0.5f, _1914)));
                                  break;
                                }
                              }
                              _1924 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1928 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1929 = (exp2(_1776 * 3.321928024291992f) - ACESMinMaxData.y) / _1928;
                        float _1931 = (exp2(_1850 * 3.321928024291992f) - ACESMinMaxData.y) / _1928;
                        float _1933 = (exp2(_1924 * 3.321928024291992f) - ACESMinMaxData.y) / _1928;
                        float _1936 = mad(0.15618768334388733f, _1933, mad(0.13400420546531677f, _1931, (_1929 * 0.6624541878700256f)));
                        float _1939 = mad(0.053689517080783844f, _1933, mad(0.6740817427635193f, _1931, (_1929 * 0.2722287178039551f)));
                        float _1942 = mad(1.0103391408920288f, _1933, mad(0.00406073359772563f, _1931, (_1929 * -0.005574649665504694f)));
                        float _1955 = min(max(mad(-0.23642469942569733f, _1942, mad(-0.32480329275131226f, _1939, (_1936 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1956 = min(max(mad(0.016756348311901093f, _1942, mad(1.6153316497802734f, _1939, (_1936 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1957 = min(max(mad(0.9883948564529419f, _1942, mad(-0.008284442126750946f, _1939, (_1936 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1960 = mad(0.15618768334388733f, _1957, mad(0.13400420546531677f, _1956, (_1955 * 0.6624541878700256f)));
                        float _1963 = mad(0.053689517080783844f, _1957, mad(0.6740817427635193f, _1956, (_1955 * 0.2722287178039551f)));
                        float _1966 = mad(1.0103391408920288f, _1957, mad(0.00406073359772563f, _1956, (_1955 * -0.005574649665504694f)));
                        float _1988 = min(max((min(max(mad(-0.23642469942569733f, _1966, mad(-0.32480329275131226f, _1963, (_1960 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1989 = min(max((min(max(mad(0.016756348311901093f, _1966, mad(1.6153316497802734f, _1963, (_1960 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _1990 = min(max((min(max(mad(0.9883948564529419f, _1966, mad(-0.008284442126750946f, _1963, (_1960 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 5)) {
                            _2003 = mad(_55, _1990, mad(_54, _1989, (_1988 * _53)));
                            _2004 = mad(_58, _1990, mad(_57, _1989, (_1988 * _56)));
                            _2005 = mad(_61, _1990, mad(_60, _1989, (_1988 * _59)));
                          } else {
                            _2003 = _1988;
                            _2004 = _1989;
                            _2005 = _1990;
                          }
                          float _2015 = exp2(log2(_2003 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2016 = exp2(log2(_2004 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2017 = exp2(log2(_2005 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2856 = exp2(log2((1.0f / ((_2015 * 18.6875f) + 1.0f)) * ((_2015 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2857 = exp2(log2((1.0f / ((_2016 * 18.6875f) + 1.0f)) * ((_2016 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2858 = exp2(log2((1.0f / ((_2017 * 18.6875f) + 1.0f)) * ((_2017 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((OutputDevice & -3) == 4) {
          _9[0] = ACESCoefsLow_0.x;
          _9[1] = ACESCoefsLow_0.y;
          _9[2] = ACESCoefsLow_0.z;
          _9[3] = ACESCoefsLow_0.w;
          _9[4] = ACESCoefsLow_4;
          _9[5] = ACESCoefsLow_4;
          _10[0] = ACESCoefsHigh_0.x;
          _10[1] = ACESCoefsHigh_0.y;
          _10[2] = ACESCoefsHigh_0.z;
          _10[3] = ACESCoefsHigh_0.w;
          _10[4] = ACESCoefsHigh_4;
          _10[5] = ACESCoefsHigh_4;
          float _2095 = ACESSceneColorMultiplier * _1220;
          float _2096 = ACESSceneColorMultiplier * _1221;
          float _2097 = ACESSceneColorMultiplier * _1222;
          float _2100 = mad((WorkingColorSpace.ToAP0[0].z), _2097, mad((WorkingColorSpace.ToAP0[0].y), _2096, ((WorkingColorSpace.ToAP0[0].x) * _2095)));
          float _2103 = mad((WorkingColorSpace.ToAP0[1].z), _2097, mad((WorkingColorSpace.ToAP0[1].y), _2096, ((WorkingColorSpace.ToAP0[1].x) * _2095)));
          float _2106 = mad((WorkingColorSpace.ToAP0[2].z), _2097, mad((WorkingColorSpace.ToAP0[2].y), _2096, ((WorkingColorSpace.ToAP0[2].x) * _2095)));
          float _2109 = mad(-0.21492856740951538f, _2106, mad(-0.2365107536315918f, _2103, (_2100 * 1.4514392614364624f)));
          float _2112 = mad(-0.09967592358589172f, _2106, mad(1.17622971534729f, _2103, (_2100 * -0.07655377686023712f)));
          float _2115 = mad(0.9977163076400757f, _2106, mad(-0.006032449658960104f, _2103, (_2100 * 0.008316148072481155f)));
          float _2117 = max(_2109, max(_2112, _2115));
          do {
            if (!(_2117 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2100 < 0.0f) || (bool)(_2103 < 0.0f))) || (bool)(_2106 < 0.0f))) {
                float _2127 = abs(_2117);
                float _2128 = (_2117 - _2109) / _2127;
                float _2130 = (_2117 - _2112) / _2127;
                float _2132 = (_2117 - _2115) / _2127;
                do {
                  if (!(_2128 < 0.8149999976158142f)) {
                    float _2135 = _2128 + -0.8149999976158142f;
                    _2147 = ((_2135 / exp2(log2(exp2(log2(_2135 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2147 = _2128;
                  }
                  do {
                    if (!(_2130 < 0.8029999732971191f)) {
                      float _2150 = _2130 + -0.8029999732971191f;
                      _2162 = ((_2150 / exp2(log2(exp2(log2(_2150 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2162 = _2130;
                    }
                    do {
                      if (!(_2132 < 0.8799999952316284f)) {
                        float _2165 = _2132 + -0.8799999952316284f;
                        _2177 = ((_2165 / exp2(log2(exp2(log2(_2165 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2177 = _2132;
                      }
                      _2185 = (_2117 - (_2127 * _2147));
                      _2186 = (_2117 - (_2127 * _2162));
                      _2187 = (_2117 - (_2127 * _2177));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2185 = _2109;
                _2186 = _2112;
                _2187 = _2115;
              }
            } else {
              _2185 = _2109;
              _2186 = _2112;
              _2187 = _2115;
            }
            float _2203 = ((mad(0.16386906802654266f, _2187, mad(0.14067870378494263f, _2186, (_2185 * 0.6954522132873535f))) - _2100) * ACESGamutCompression) + _2100;
            float _2204 = ((mad(0.0955343171954155f, _2187, mad(0.8596711158752441f, _2186, (_2185 * 0.044794563204050064f))) - _2103) * ACESGamutCompression) + _2103;
            float _2205 = ((mad(1.0015007257461548f, _2187, mad(0.004025210160762072f, _2186, (_2185 * -0.005525882821530104f))) - _2106) * ACESGamutCompression) + _2106;
            float _2209 = max(max(_2203, _2204), _2205);
            float _2214 = (max(_2209, 1.000000013351432e-10f) - max(min(min(_2203, _2204), _2205), 1.000000013351432e-10f)) / max(_2209, 0.009999999776482582f);
            float _2227 = ((_2204 + _2203) + _2205) + (sqrt((((_2205 - _2204) * _2205) + ((_2204 - _2203) * _2204)) + ((_2203 - _2205) * _2203)) * 1.75f);
            float _2228 = _2227 * 0.3333333432674408f;
            float _2229 = _2214 + -0.4000000059604645f;
            float _2230 = _2229 * 5.0f;
            float _2234 = max((1.0f - abs(_2229 * 2.5f)), 0.0f);
            float _2245 = ((float((int)(((int)(uint)((bool)(_2230 > 0.0f))) - ((int)(uint)((bool)(_2230 < 0.0f))))) * (1.0f - (_2234 * _2234))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2228 <= 0.0533333346247673f)) {
                if (!(_2228 >= 0.1599999964237213f)) {
                  _2254 = (((0.23999999463558197f / _2227) + -0.5f) * _2245);
                } else {
                  _2254 = 0.0f;
                }
              } else {
                _2254 = _2245;
              }
              float _2255 = _2254 + 1.0f;
              float _2256 = _2255 * _2203;
              float _2257 = _2255 * _2204;
              float _2258 = _2255 * _2205;
              do {
                if (!((bool)(_2256 == _2257) && (bool)(_2257 == _2258))) {
                  float _2265 = ((_2256 * 2.0f) - _2257) - _2258;
                  float _2268 = ((_2204 - _2205) * 1.7320507764816284f) * _2255;
                  float _2270 = atan(_2268 / _2265);
                  bool _2273 = (_2265 < 0.0f);
                  bool _2274 = (_2265 == 0.0f);
                  bool _2275 = (_2268 >= 0.0f);
                  bool _2276 = (_2268 < 0.0f);
                  _2287 = select((_2275 && _2274), 90.0f, select((_2276 && _2274), -90.0f, (select((_2276 && _2273), (_2270 + -3.1415927410125732f), select((_2275 && _2273), (_2270 + 3.1415927410125732f), _2270)) * 57.2957763671875f)));
                } else {
                  _2287 = 0.0f;
                }
                float _2292 = min(max(select((_2287 < 0.0f), (_2287 + 360.0f), _2287), 0.0f), 360.0f);
                do {
                  if (_2292 < -180.0f) {
                    _2301 = (_2292 + 360.0f);
                  } else {
                    if (_2292 > 180.0f) {
                      _2301 = (_2292 + -360.0f);
                    } else {
                      _2301 = _2292;
                    }
                  }
                  do {
                    if ((bool)(_2301 > -67.5f) && (bool)(_2301 < 67.5f)) {
                      float _2307 = (_2301 + 67.5f) * 0.029629629105329514f;
                      int _2308 = int(_2307);
                      float _2310 = _2307 - float((int)(_2308));
                      float _2311 = _2310 * _2310;
                      float _2312 = _2311 * _2310;
                      if (_2308 == 3) {
                        _2340 = (((0.1666666716337204f - (_2310 * 0.5f)) + (_2311 * 0.5f)) - (_2312 * 0.1666666716337204f));
                      } else {
                        if (_2308 == 2) {
                          _2340 = ((0.6666666865348816f - _2311) + (_2312 * 0.5f));
                        } else {
                          if (_2308 == 1) {
                            _2340 = (((_2312 * -0.5f) + 0.1666666716337204f) + ((_2311 + _2310) * 0.5f));
                          } else {
                            _2340 = select((_2308 == 0), (_2312 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2340 = 0.0f;
                    }
                    float _2349 = min(max(((((_2214 * 0.27000001072883606f) * (0.029999999329447746f - _2256)) * _2340) + _2256), 0.0f), 65535.0f);
                    float _2350 = min(max(_2257, 0.0f), 65535.0f);
                    float _2351 = min(max(_2258, 0.0f), 65535.0f);
                    float _2364 = min(max(mad(-0.21492856740951538f, _2351, mad(-0.2365107536315918f, _2350, (_2349 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2365 = min(max(mad(-0.09967592358589172f, _2351, mad(1.17622971534729f, _2350, (_2349 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2366 = min(max(mad(0.9977163076400757f, _2351, mad(-0.006032449658960104f, _2350, (_2349 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2367 = dot(float3(_2364, _2365, _2366), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2378 = log2(max((lerp(_2367, _2364, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2379 = _2378 * 0.3010300099849701f;
                    float _2380 = log2(ACESMinMaxData.x);
                    float _2381 = _2380 * 0.3010300099849701f;
                    do {
                      if (!(!(_2379 <= _2381))) {
                        _2450 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2388 = log2(ACESMidData.x);
                        float _2389 = _2388 * 0.3010300099849701f;
                        if ((bool)(_2379 > _2381) && (bool)(_2379 < _2389)) {
                          float _2397 = ((_2378 - _2380) * 0.9030900001525879f) / ((_2388 - _2380) * 0.3010300099849701f);
                          int _2398 = int(_2397);
                          float _2400 = _2397 - float((int)(_2398));
                          float _2402 = _9[_2398];
                          float _2405 = _9[(_2398 + 1)];
                          float _2410 = _2402 * 0.5f;
                          _2450 = dot(float3((_2400 * _2400), _2400, 1.0f), float3(mad((_9[(_2398 + 2)]), 0.5f, mad(_2405, -1.0f, _2410)), (_2405 - _2402), mad(_2405, 0.5f, _2410)));
                        } else {
                          do {
                            if (!(!(_2379 >= _2389))) {
                              float _2419 = log2(ACESMinMaxData.z);
                              if (_2379 < (_2419 * 0.3010300099849701f)) {
                                float _2427 = ((_2378 - _2388) * 0.9030900001525879f) / ((_2419 - _2388) * 0.3010300099849701f);
                                int _2428 = int(_2427);
                                float _2430 = _2427 - float((int)(_2428));
                                float _2432 = _10[_2428];
                                float _2435 = _10[(_2428 + 1)];
                                float _2440 = _2432 * 0.5f;
                                _2450 = dot(float3((_2430 * _2430), _2430, 1.0f), float3(mad((_10[(_2428 + 2)]), 0.5f, mad(_2435, -1.0f, _2440)), (_2435 - _2432), mad(_2435, 0.5f, _2440)));
                                break;
                              }
                            }
                            _2450 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2454 = log2(max((lerp(_2367, _2365, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2455 = _2454 * 0.3010300099849701f;
                      do {
                        if (!(!(_2455 <= _2381))) {
                          _2524 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2462 = log2(ACESMidData.x);
                          float _2463 = _2462 * 0.3010300099849701f;
                          if ((bool)(_2455 > _2381) && (bool)(_2455 < _2463)) {
                            float _2471 = ((_2454 - _2380) * 0.9030900001525879f) / ((_2462 - _2380) * 0.3010300099849701f);
                            int _2472 = int(_2471);
                            float _2474 = _2471 - float((int)(_2472));
                            float _2476 = _9[_2472];
                            float _2479 = _9[(_2472 + 1)];
                            float _2484 = _2476 * 0.5f;
                            _2524 = dot(float3((_2474 * _2474), _2474, 1.0f), float3(mad((_9[(_2472 + 2)]), 0.5f, mad(_2479, -1.0f, _2484)), (_2479 - _2476), mad(_2479, 0.5f, _2484)));
                          } else {
                            do {
                              if (!(!(_2455 >= _2463))) {
                                float _2493 = log2(ACESMinMaxData.z);
                                if (_2455 < (_2493 * 0.3010300099849701f)) {
                                  float _2501 = ((_2454 - _2462) * 0.9030900001525879f) / ((_2493 - _2462) * 0.3010300099849701f);
                                  int _2502 = int(_2501);
                                  float _2504 = _2501 - float((int)(_2502));
                                  float _2506 = _10[_2502];
                                  float _2509 = _10[(_2502 + 1)];
                                  float _2514 = _2506 * 0.5f;
                                  _2524 = dot(float3((_2504 * _2504), _2504, 1.0f), float3(mad((_10[(_2502 + 2)]), 0.5f, mad(_2509, -1.0f, _2514)), (_2509 - _2506), mad(_2509, 0.5f, _2514)));
                                  break;
                                }
                              }
                              _2524 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2528 = log2(max((lerp(_2367, _2366, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2529 = _2528 * 0.3010300099849701f;
                        do {
                          if (!(!(_2529 <= _2381))) {
                            _2598 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2536 = log2(ACESMidData.x);
                            float _2537 = _2536 * 0.3010300099849701f;
                            if ((bool)(_2529 > _2381) && (bool)(_2529 < _2537)) {
                              float _2545 = ((_2528 - _2380) * 0.9030900001525879f) / ((_2536 - _2380) * 0.3010300099849701f);
                              int _2546 = int(_2545);
                              float _2548 = _2545 - float((int)(_2546));
                              float _2550 = _9[_2546];
                              float _2553 = _9[(_2546 + 1)];
                              float _2558 = _2550 * 0.5f;
                              _2598 = dot(float3((_2548 * _2548), _2548, 1.0f), float3(mad((_9[(_2546 + 2)]), 0.5f, mad(_2553, -1.0f, _2558)), (_2553 - _2550), mad(_2553, 0.5f, _2558)));
                            } else {
                              do {
                                if (!(!(_2529 >= _2537))) {
                                  float _2567 = log2(ACESMinMaxData.z);
                                  if (_2529 < (_2567 * 0.3010300099849701f)) {
                                    float _2575 = ((_2528 - _2536) * 0.9030900001525879f) / ((_2567 - _2536) * 0.3010300099849701f);
                                    int _2576 = int(_2575);
                                    float _2578 = _2575 - float((int)(_2576));
                                    float _2580 = _10[_2576];
                                    float _2583 = _10[(_2576 + 1)];
                                    float _2588 = _2580 * 0.5f;
                                    _2598 = dot(float3((_2578 * _2578), _2578, 1.0f), float3(mad((_10[(_2576 + 2)]), 0.5f, mad(_2583, -1.0f, _2588)), (_2583 - _2580), mad(_2583, 0.5f, _2588)));
                                    break;
                                  }
                                }
                                _2598 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2602 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2603 = (exp2(_2450 * 3.321928024291992f) - ACESMinMaxData.y) / _2602;
                          float _2605 = (exp2(_2524 * 3.321928024291992f) - ACESMinMaxData.y) / _2602;
                          float _2607 = (exp2(_2598 * 3.321928024291992f) - ACESMinMaxData.y) / _2602;
                          float _2610 = mad(0.15618768334388733f, _2607, mad(0.13400420546531677f, _2605, (_2603 * 0.6624541878700256f)));
                          float _2613 = mad(0.053689517080783844f, _2607, mad(0.6740817427635193f, _2605, (_2603 * 0.2722287178039551f)));
                          float _2616 = mad(1.0103391408920288f, _2607, mad(0.00406073359772563f, _2605, (_2603 * -0.005574649665504694f)));
                          float _2629 = min(max(mad(-0.23642469942569733f, _2616, mad(-0.32480329275131226f, _2613, (_2610 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2630 = min(max(mad(0.016756348311901093f, _2616, mad(1.6153316497802734f, _2613, (_2610 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2631 = min(max(mad(0.9883948564529419f, _2616, mad(-0.008284442126750946f, _2613, (_2610 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2634 = mad(0.15618768334388733f, _2631, mad(0.13400420546531677f, _2630, (_2629 * 0.6624541878700256f)));
                          float _2637 = mad(0.053689517080783844f, _2631, mad(0.6740817427635193f, _2630, (_2629 * 0.2722287178039551f)));
                          float _2640 = mad(1.0103391408920288f, _2631, mad(0.00406073359772563f, _2630, (_2629 * -0.005574649665504694f)));
                          float _2662 = min(max((min(max(mad(-0.23642469942569733f, _2640, mad(-0.32480329275131226f, _2637, (_2634 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2663 = min(max((min(max(mad(0.016756348311901093f, _2640, mad(1.6153316497802734f, _2637, (_2634 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2664 = min(max((min(max(mad(0.9883948564529419f, _2640, mad(-0.008284442126750946f, _2637, (_2634 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(OutputDevice == 6)) {
                              _2677 = mad(_55, _2664, mad(_54, _2663, (_2662 * _53)));
                              _2678 = mad(_58, _2664, mad(_57, _2663, (_2662 * _56)));
                              _2679 = mad(_61, _2664, mad(_60, _2663, (_2662 * _59)));
                            } else {
                              _2677 = _2662;
                              _2678 = _2663;
                              _2679 = _2664;
                            }
                            float _2689 = exp2(log2(_2677 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2690 = exp2(log2(_2678 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2691 = exp2(log2(_2679 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2856 = exp2(log2((1.0f / ((_2689 * 18.6875f) + 1.0f)) * ((_2689 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2857 = exp2(log2((1.0f / ((_2690 * 18.6875f) + 1.0f)) * ((_2690 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2858 = exp2(log2((1.0f / ((_2691 * 18.6875f) + 1.0f)) * ((_2691 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (OutputDevice == 7) {
            float _2736 = mad((WorkingColorSpace.ToAP1[0].z), _1222, mad((WorkingColorSpace.ToAP1[0].y), _1221, ((WorkingColorSpace.ToAP1[0].x) * _1220)));
            float _2739 = mad((WorkingColorSpace.ToAP1[1].z), _1222, mad((WorkingColorSpace.ToAP1[1].y), _1221, ((WorkingColorSpace.ToAP1[1].x) * _1220)));
            float _2742 = mad((WorkingColorSpace.ToAP1[2].z), _1222, mad((WorkingColorSpace.ToAP1[2].y), _1221, ((WorkingColorSpace.ToAP1[2].x) * _1220)));
            float _2761 = exp2(log2(mad(_55, _2742, mad(_54, _2739, (_2736 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2762 = exp2(log2(mad(_58, _2742, mad(_57, _2739, (_2736 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2763 = exp2(log2(mad(_61, _2742, mad(_60, _2739, (_2736 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2856 = exp2(log2((1.0f / ((_2761 * 18.6875f) + 1.0f)) * ((_2761 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2857 = exp2(log2((1.0f / ((_2762 * 18.6875f) + 1.0f)) * ((_2762 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2858 = exp2(log2((1.0f / ((_2763 * 18.6875f) + 1.0f)) * ((_2763 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2810 = mad((WorkingColorSpace.ToAP1[0].z), _1210, mad((WorkingColorSpace.ToAP1[0].y), _1209, ((WorkingColorSpace.ToAP1[0].x) * _1208)));
                float _2813 = mad((WorkingColorSpace.ToAP1[1].z), _1210, mad((WorkingColorSpace.ToAP1[1].y), _1209, ((WorkingColorSpace.ToAP1[1].x) * _1208)));
                float _2816 = mad((WorkingColorSpace.ToAP1[2].z), _1210, mad((WorkingColorSpace.ToAP1[2].y), _1209, ((WorkingColorSpace.ToAP1[2].x) * _1208)));
                _2856 = mad(_55, _2816, mad(_54, _2813, (_2810 * _53)));
                _2857 = mad(_58, _2816, mad(_57, _2813, (_2810 * _56)));
                _2858 = mad(_61, _2816, mad(_60, _2813, (_2810 * _59)));
              } else {
                float _2829 = mad((WorkingColorSpace.ToAP1[0].z), _1236, mad((WorkingColorSpace.ToAP1[0].y), _1235, ((WorkingColorSpace.ToAP1[0].x) * _1234)));
                float _2832 = mad((WorkingColorSpace.ToAP1[1].z), _1236, mad((WorkingColorSpace.ToAP1[1].y), _1235, ((WorkingColorSpace.ToAP1[1].x) * _1234)));
                float _2835 = mad((WorkingColorSpace.ToAP1[2].z), _1236, mad((WorkingColorSpace.ToAP1[2].y), _1235, ((WorkingColorSpace.ToAP1[2].x) * _1234)));
                _2856 = exp2(log2(mad(_55, _2835, mad(_54, _2832, (_2829 * _53)))) * InverseGamma.z);
                _2857 = exp2(log2(mad(_58, _2835, mad(_57, _2832, (_2829 * _56)))) * InverseGamma.z);
                _2858 = exp2(log2(mad(_61, _2835, mad(_60, _2832, (_2829 * _59)))) * InverseGamma.z);
              }
            } else {
              _2856 = _1220;
              _2857 = _1221;
              _2858 = _1222;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2856 * 0.9523810148239136f), (_2857 * 0.9523810148239136f), (_2858 * 0.9523810148239136f), 0.0f);
}

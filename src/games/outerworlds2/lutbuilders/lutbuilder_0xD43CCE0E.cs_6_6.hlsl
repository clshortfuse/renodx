#include "./filmiclutbuilder.hlsl"

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

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

SamplerState Samplers_1 : register(s0);

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
  float _1579;
  float _1594;
  float _1609;
  float _1617;
  float _1618;
  float _1619;
  float _1686;
  float _1719;
  float _1733;
  float _1772;
  float _1882;
  float _1956;
  float _2030;
  float _2109;
  float _2110;
  float _2111;
  float _2253;
  float _2268;
  float _2283;
  float _2291;
  float _2292;
  float _2293;
  float _2360;
  float _2393;
  float _2407;
  float _2446;
  float _2556;
  float _2630;
  float _2704;
  float _2783;
  float _2784;
  float _2785;
  float _2962;
  float _2963;
  float _2964;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _44 = (OutputGamut == 4);
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
  if ((uint)OutputDevice > (uint)2) {
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
  bool _150 = (bIsTemperatureWhiteBalance != 0);
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
  float _316 = mad(_295, (WorkingColorSpace.ToXYZ[2].x), mad(_292, (WorkingColorSpace.ToXYZ[1].x), (_289 * (WorkingColorSpace.ToXYZ[0].x))));
  float _319 = mad(_295, (WorkingColorSpace.ToXYZ[2].y), mad(_292, (WorkingColorSpace.ToXYZ[1].y), (_289 * (WorkingColorSpace.ToXYZ[0].y))));
  float _322 = mad(_295, (WorkingColorSpace.ToXYZ[2].z), mad(_292, (WorkingColorSpace.ToXYZ[1].z), (_289 * (WorkingColorSpace.ToXYZ[0].z))));
  float _325 = mad(_304, (WorkingColorSpace.ToXYZ[2].x), mad(_301, (WorkingColorSpace.ToXYZ[1].x), (_298 * (WorkingColorSpace.ToXYZ[0].x))));
  float _328 = mad(_304, (WorkingColorSpace.ToXYZ[2].y), mad(_301, (WorkingColorSpace.ToXYZ[1].y), (_298 * (WorkingColorSpace.ToXYZ[0].y))));
  float _331 = mad(_304, (WorkingColorSpace.ToXYZ[2].z), mad(_301, (WorkingColorSpace.ToXYZ[1].z), (_298 * (WorkingColorSpace.ToXYZ[0].z))));
  float _334 = mad(_313, (WorkingColorSpace.ToXYZ[2].x), mad(_310, (WorkingColorSpace.ToXYZ[1].x), (_307 * (WorkingColorSpace.ToXYZ[0].x))));
  float _337 = mad(_313, (WorkingColorSpace.ToXYZ[2].y), mad(_310, (WorkingColorSpace.ToXYZ[1].y), (_307 * (WorkingColorSpace.ToXYZ[0].y))));
  float _340 = mad(_313, (WorkingColorSpace.ToXYZ[2].z), mad(_310, (WorkingColorSpace.ToXYZ[1].z), (_307 * (WorkingColorSpace.ToXYZ[0].z))));
  float _370 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _340, mad((WorkingColorSpace.FromXYZ[0].y), _331, (_322 * (WorkingColorSpace.FromXYZ[0].x)))), _123, mad(mad((WorkingColorSpace.FromXYZ[0].z), _337, mad((WorkingColorSpace.FromXYZ[0].y), _328, (_319 * (WorkingColorSpace.FromXYZ[0].x)))), _122, (mad((WorkingColorSpace.FromXYZ[0].z), _334, mad((WorkingColorSpace.FromXYZ[0].y), _325, (_316 * (WorkingColorSpace.FromXYZ[0].x)))) * _121)));
  float _373 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _340, mad((WorkingColorSpace.FromXYZ[1].y), _331, (_322 * (WorkingColorSpace.FromXYZ[1].x)))), _123, mad(mad((WorkingColorSpace.FromXYZ[1].z), _337, mad((WorkingColorSpace.FromXYZ[1].y), _328, (_319 * (WorkingColorSpace.FromXYZ[1].x)))), _122, (mad((WorkingColorSpace.FromXYZ[1].z), _334, mad((WorkingColorSpace.FromXYZ[1].y), _325, (_316 * (WorkingColorSpace.FromXYZ[1].x)))) * _121)));
  float _376 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _340, mad((WorkingColorSpace.FromXYZ[2].y), _331, (_322 * (WorkingColorSpace.FromXYZ[2].x)))), _123, mad(mad((WorkingColorSpace.FromXYZ[2].z), _337, mad((WorkingColorSpace.FromXYZ[2].y), _328, (_319 * (WorkingColorSpace.FromXYZ[2].x)))), _122, (mad((WorkingColorSpace.FromXYZ[2].z), _334, mad((WorkingColorSpace.FromXYZ[2].y), _325, (_316 * (WorkingColorSpace.FromXYZ[2].x)))) * _121)));
  float _391 = mad((WorkingColorSpace.ToAP1[0].z), _376, mad((WorkingColorSpace.ToAP1[0].y), _373, ((WorkingColorSpace.ToAP1[0].x) * _370)));
  float _394 = mad((WorkingColorSpace.ToAP1[1].z), _376, mad((WorkingColorSpace.ToAP1[1].y), _373, ((WorkingColorSpace.ToAP1[1].x) * _370)));
  float _397 = mad((WorkingColorSpace.ToAP1[2].z), _376, mad((WorkingColorSpace.ToAP1[2].y), _373, ((WorkingColorSpace.ToAP1[2].x) * _370)));
  float _398 = dot(float3(_391, _394, _397), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
  float _890 = ((float((int)(((int)(uint)((bool)(_875 > 0.0f))) - ((int)(uint)((bool)(_875 < 0.0f))))) * (1.0f - (_879 * _879))) + 1.0f) * 0.02500000037252903f;
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

  float3 lerpColor = lerp(_973, float3(_970, _971, _972), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _839, _840, _841);
  float _1161 = lerpColor.r, _1162 = lerpColor.g, _1163 = lerpColor.b;
#else
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
#endif

  // remove saturate and max
  float _1176 = mad((WorkingColorSpace.FromAP1[0].z), _1163, mad((WorkingColorSpace.FromAP1[0].y), _1162, ((WorkingColorSpace.FromAP1[0].x) * _1161)));
  float _1177 = mad((WorkingColorSpace.FromAP1[1].z), _1163, mad((WorkingColorSpace.FromAP1[1].y), _1162, ((WorkingColorSpace.FromAP1[1].x) * _1161)));
  float _1178 = mad((WorkingColorSpace.FromAP1[2].z), _1163, mad((WorkingColorSpace.FromAP1[2].y), _1162, ((WorkingColorSpace.FromAP1[2].x) * _1161)));

#if 1
  float _1277, _1278, _1279;
  SampleLUTUpgradeToneMap(float3(_1176, _1177, _1178), Samplers_1, Textures_1, _1277, _1278, _1279);
#else
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
#endif
  float _1305 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1277)) * _1277) + MappingPolynomial.z);
  float _1306 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1278)) * _1278) + MappingPolynomial.z);
  float _1307 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1279)) * _1279) + MappingPolynomial.z);
  float _1314 = ((OverlayColor.x - _1305) * OverlayColor.w) + _1305;
  float _1315 = ((OverlayColor.y - _1306) * OverlayColor.w) + _1306;
  float _1316 = ((OverlayColor.z - _1307) * OverlayColor.w) + _1307;
  float _1317 = ColorScale.x * mad((WorkingColorSpace.FromAP1[0].z), _803, mad((WorkingColorSpace.FromAP1[0].y), _801, (_799 * (WorkingColorSpace.FromAP1[0].x))));
  float _1318 = ColorScale.y * mad((WorkingColorSpace.FromAP1[1].z), _803, mad((WorkingColorSpace.FromAP1[1].y), _801, ((WorkingColorSpace.FromAP1[1].x) * _799)));
  float _1319 = ColorScale.z * mad((WorkingColorSpace.FromAP1[2].z), _803, mad((WorkingColorSpace.FromAP1[2].y), _801, ((WorkingColorSpace.FromAP1[2].x) * _799)));
  float _1326 = ((OverlayColor.x - _1317) * OverlayColor.w) + _1317;
  float _1327 = ((OverlayColor.y - _1318) * OverlayColor.w) + _1318;
  float _1328 = ((OverlayColor.z - _1319) * OverlayColor.w) + _1319;
  float _1340 = exp2(log2(max(0.0f, _1314)) * InverseGamma.y);
  float _1341 = exp2(log2(max(0.0f, _1315)) * InverseGamma.y);
  float _1342 = exp2(log2(max(0.0f, _1316)) * InverseGamma.y);

  if (GenerateOutput(_1340, _1341, _1342, SV_Target, is_hdr)) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = SV_Target;
    return;
  }
  
  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace.bIsSRGB == 0) {
        float _1365 = mad((WorkingColorSpace.ToAP1[0].z), _1342, mad((WorkingColorSpace.ToAP1[0].y), _1341, ((WorkingColorSpace.ToAP1[0].x) * _1340)));
        float _1368 = mad((WorkingColorSpace.ToAP1[1].z), _1342, mad((WorkingColorSpace.ToAP1[1].y), _1341, ((WorkingColorSpace.ToAP1[1].x) * _1340)));
        float _1371 = mad((WorkingColorSpace.ToAP1[2].z), _1342, mad((WorkingColorSpace.ToAP1[2].y), _1341, ((WorkingColorSpace.ToAP1[2].x) * _1340)));
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
            _2962 = _1395;
            _2963 = _1406;
            _2964 = (_1384 * 12.920000076293945f);
          } else {
            _2962 = _1395;
            _2963 = _1406;
            _2964 = (((pow(_1384, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1433 = mad((WorkingColorSpace.ToAP1[0].z), _1342, mad((WorkingColorSpace.ToAP1[0].y), _1341, ((WorkingColorSpace.ToAP1[0].x) * _1340)));
      float _1436 = mad((WorkingColorSpace.ToAP1[1].z), _1342, mad((WorkingColorSpace.ToAP1[1].y), _1341, ((WorkingColorSpace.ToAP1[1].x) * _1340)));
      float _1439 = mad((WorkingColorSpace.ToAP1[2].z), _1342, mad((WorkingColorSpace.ToAP1[2].y), _1341, ((WorkingColorSpace.ToAP1[2].x) * _1340)));
      float _1449 = max(6.103519990574569e-05f, mad(_57, _1439, mad(_56, _1436, (_1433 * _55))));
      float _1450 = max(6.103519990574569e-05f, mad(_60, _1439, mad(_59, _1436, (_1433 * _58))));
      float _1451 = max(6.103519990574569e-05f, mad(_63, _1439, mad(_62, _1436, (_1433 * _61))));
      _2962 = min((_1449 * 4.5f), ((exp2(log2(max(_1449, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2963 = min((_1450 * 4.5f), ((exp2(log2(max(_1450, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2964 = min((_1451 * 4.5f), ((exp2(log2(max(_1451, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1527 = ACESSceneColorMultiplier * _1326;
        float _1528 = ACESSceneColorMultiplier * _1327;
        float _1529 = ACESSceneColorMultiplier * _1328;
        float _1532 = mad((WorkingColorSpace.ToAP0[0].z), _1529, mad((WorkingColorSpace.ToAP0[0].y), _1528, ((WorkingColorSpace.ToAP0[0].x) * _1527)));
        float _1535 = mad((WorkingColorSpace.ToAP0[1].z), _1529, mad((WorkingColorSpace.ToAP0[1].y), _1528, ((WorkingColorSpace.ToAP0[1].x) * _1527)));
        float _1538 = mad((WorkingColorSpace.ToAP0[2].z), _1529, mad((WorkingColorSpace.ToAP0[2].y), _1528, ((WorkingColorSpace.ToAP0[2].x) * _1527)));
        float _1541 = mad(-0.21492856740951538f, _1538, mad(-0.2365107536315918f, _1535, (_1532 * 1.4514392614364624f)));
        float _1544 = mad(-0.09967592358589172f, _1538, mad(1.17622971534729f, _1535, (_1532 * -0.07655377686023712f)));
        float _1547 = mad(0.9977163076400757f, _1538, mad(-0.006032449658960104f, _1535, (_1532 * 0.008316148072481155f)));
        float _1549 = max(_1541, max(_1544, _1547));
        do {
          if (!(_1549 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1532 < 0.0f) || (bool)(_1535 < 0.0f))) || (bool)(_1538 < 0.0f))) {
              float _1559 = abs(_1549);
              float _1560 = (_1549 - _1541) / _1559;
              float _1562 = (_1549 - _1544) / _1559;
              float _1564 = (_1549 - _1547) / _1559;
              do {
                if (!(_1560 < 0.8149999976158142f)) {
                  float _1567 = _1560 + -0.8149999976158142f;
                  _1579 = ((_1567 / exp2(log2(exp2(log2(_1567 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1579 = _1560;
                }
                do {
                  if (!(_1562 < 0.8029999732971191f)) {
                    float _1582 = _1562 + -0.8029999732971191f;
                    _1594 = ((_1582 / exp2(log2(exp2(log2(_1582 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1594 = _1562;
                  }
                  do {
                    if (!(_1564 < 0.8799999952316284f)) {
                      float _1597 = _1564 + -0.8799999952316284f;
                      _1609 = ((_1597 / exp2(log2(exp2(log2(_1597 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1609 = _1564;
                    }
                    _1617 = (_1549 - (_1559 * _1579));
                    _1618 = (_1549 - (_1559 * _1594));
                    _1619 = (_1549 - (_1559 * _1609));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1617 = _1541;
              _1618 = _1544;
              _1619 = _1547;
            }
          } else {
            _1617 = _1541;
            _1618 = _1544;
            _1619 = _1547;
          }
          float _1635 = ((mad(0.16386906802654266f, _1619, mad(0.14067870378494263f, _1618, (_1617 * 0.6954522132873535f))) - _1532) * ACESGamutCompression) + _1532;
          float _1636 = ((mad(0.0955343171954155f, _1619, mad(0.8596711158752441f, _1618, (_1617 * 0.044794563204050064f))) - _1535) * ACESGamutCompression) + _1535;
          float _1637 = ((mad(1.0015007257461548f, _1619, mad(0.004025210160762072f, _1618, (_1617 * -0.005525882821530104f))) - _1538) * ACESGamutCompression) + _1538;
          float _1641 = max(max(_1635, _1636), _1637);
          float _1646 = (max(_1641, 1.000000013351432e-10f) - max(min(min(_1635, _1636), _1637), 1.000000013351432e-10f)) / max(_1641, 0.009999999776482582f);
          float _1659 = ((_1636 + _1635) + _1637) + (sqrt((((_1637 - _1636) * _1637) + ((_1636 - _1635) * _1636)) + ((_1635 - _1637) * _1635)) * 1.75f);
          float _1660 = _1659 * 0.3333333432674408f;
          float _1661 = _1646 + -0.4000000059604645f;
          float _1662 = _1661 * 5.0f;
          float _1666 = max((1.0f - abs(_1661 * 2.5f)), 0.0f);
          float _1677 = ((float((int)(((int)(uint)((bool)(_1662 > 0.0f))) - ((int)(uint)((bool)(_1662 < 0.0f))))) * (1.0f - (_1666 * _1666))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1660 <= 0.0533333346247673f)) {
              if (!(_1660 >= 0.1599999964237213f)) {
                _1686 = (((0.23999999463558197f / _1659) + -0.5f) * _1677);
              } else {
                _1686 = 0.0f;
              }
            } else {
              _1686 = _1677;
            }
            float _1687 = _1686 + 1.0f;
            float _1688 = _1687 * _1635;
            float _1689 = _1687 * _1636;
            float _1690 = _1687 * _1637;
            do {
              if (!((bool)(_1688 == _1689) && (bool)(_1689 == _1690))) {
                float _1697 = ((_1688 * 2.0f) - _1689) - _1690;
                float _1700 = ((_1636 - _1637) * 1.7320507764816284f) * _1687;
                float _1702 = atan(_1700 / _1697);
                bool _1705 = (_1697 < 0.0f);
                bool _1706 = (_1697 == 0.0f);
                bool _1707 = (_1700 >= 0.0f);
                bool _1708 = (_1700 < 0.0f);
                _1719 = select((_1707 && _1706), 90.0f, select((_1708 && _1706), -90.0f, (select((_1708 && _1705), (_1702 + -3.1415927410125732f), select((_1707 && _1705), (_1702 + 3.1415927410125732f), _1702)) * 57.2957763671875f)));
              } else {
                _1719 = 0.0f;
              }
              float _1724 = min(max(select((_1719 < 0.0f), (_1719 + 360.0f), _1719), 0.0f), 360.0f);
              do {
                if (_1724 < -180.0f) {
                  _1733 = (_1724 + 360.0f);
                } else {
                  if (_1724 > 180.0f) {
                    _1733 = (_1724 + -360.0f);
                  } else {
                    _1733 = _1724;
                  }
                }
                do {
                  if ((bool)(_1733 > -67.5f) && (bool)(_1733 < 67.5f)) {
                    float _1739 = (_1733 + 67.5f) * 0.029629629105329514f;
                    int _1740 = int(_1739);
                    float _1742 = _1739 - float((int)(_1740));
                    float _1743 = _1742 * _1742;
                    float _1744 = _1743 * _1742;
                    if (_1740 == 3) {
                      _1772 = (((0.1666666716337204f - (_1742 * 0.5f)) + (_1743 * 0.5f)) - (_1744 * 0.1666666716337204f));
                    } else {
                      if (_1740 == 2) {
                        _1772 = ((0.6666666865348816f - _1743) + (_1744 * 0.5f));
                      } else {
                        if (_1740 == 1) {
                          _1772 = (((_1744 * -0.5f) + 0.1666666716337204f) + ((_1743 + _1742) * 0.5f));
                        } else {
                          _1772 = select((_1740 == 0), (_1744 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1772 = 0.0f;
                  }
                  float _1781 = min(max(((((_1646 * 0.27000001072883606f) * (0.029999999329447746f - _1688)) * _1772) + _1688), 0.0f), 65535.0f);
                  float _1782 = min(max(_1689, 0.0f), 65535.0f);
                  float _1783 = min(max(_1690, 0.0f), 65535.0f);
                  float _1796 = min(max(mad(-0.21492856740951538f, _1783, mad(-0.2365107536315918f, _1782, (_1781 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1797 = min(max(mad(-0.09967592358589172f, _1783, mad(1.17622971534729f, _1782, (_1781 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1798 = min(max(mad(0.9977163076400757f, _1783, mad(-0.006032449658960104f, _1782, (_1781 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1799 = dot(float3(_1796, _1797, _1798), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1810 = log2(max((lerp(_1799, _1796, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1811 = _1810 * 0.3010300099849701f;
                  float _1812 = log2(ACESMinMaxData.x);
                  float _1813 = _1812 * 0.3010300099849701f;
                  do {
                    if (!(!(_1811 <= _1813))) {
                      _1882 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1820 = log2(ACESMidData.x);
                      float _1821 = _1820 * 0.3010300099849701f;
                      if ((bool)(_1811 > _1813) && (bool)(_1811 < _1821)) {
                        float _1829 = ((_1810 - _1812) * 0.9030900001525879f) / ((_1820 - _1812) * 0.3010300099849701f);
                        int _1830 = int(_1829);
                        float _1832 = _1829 - float((int)(_1830));
                        float _1834 = _13[_1830];
                        float _1837 = _13[(_1830 + 1)];
                        float _1842 = _1834 * 0.5f;
                        _1882 = dot(float3((_1832 * _1832), _1832, 1.0f), float3(mad((_13[(_1830 + 2)]), 0.5f, mad(_1837, -1.0f, _1842)), (_1837 - _1834), mad(_1837, 0.5f, _1842)));
                      } else {
                        do {
                          if (!(!(_1811 >= _1821))) {
                            float _1851 = log2(ACESMinMaxData.z);
                            if (_1811 < (_1851 * 0.3010300099849701f)) {
                              float _1859 = ((_1810 - _1820) * 0.9030900001525879f) / ((_1851 - _1820) * 0.3010300099849701f);
                              int _1860 = int(_1859);
                              float _1862 = _1859 - float((int)(_1860));
                              float _1864 = _14[_1860];
                              float _1867 = _14[(_1860 + 1)];
                              float _1872 = _1864 * 0.5f;
                              _1882 = dot(float3((_1862 * _1862), _1862, 1.0f), float3(mad((_14[(_1860 + 2)]), 0.5f, mad(_1867, -1.0f, _1872)), (_1867 - _1864), mad(_1867, 0.5f, _1872)));
                              break;
                            }
                          }
                          _1882 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1886 = log2(max((lerp(_1799, _1797, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1887 = _1886 * 0.3010300099849701f;
                    do {
                      if (!(!(_1887 <= _1813))) {
                        _1956 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1894 = log2(ACESMidData.x);
                        float _1895 = _1894 * 0.3010300099849701f;
                        if ((bool)(_1887 > _1813) && (bool)(_1887 < _1895)) {
                          float _1903 = ((_1886 - _1812) * 0.9030900001525879f) / ((_1894 - _1812) * 0.3010300099849701f);
                          int _1904 = int(_1903);
                          float _1906 = _1903 - float((int)(_1904));
                          float _1908 = _13[_1904];
                          float _1911 = _13[(_1904 + 1)];
                          float _1916 = _1908 * 0.5f;
                          _1956 = dot(float3((_1906 * _1906), _1906, 1.0f), float3(mad((_13[(_1904 + 2)]), 0.5f, mad(_1911, -1.0f, _1916)), (_1911 - _1908), mad(_1911, 0.5f, _1916)));
                        } else {
                          do {
                            if (!(!(_1887 >= _1895))) {
                              float _1925 = log2(ACESMinMaxData.z);
                              if (_1887 < (_1925 * 0.3010300099849701f)) {
                                float _1933 = ((_1886 - _1894) * 0.9030900001525879f) / ((_1925 - _1894) * 0.3010300099849701f);
                                int _1934 = int(_1933);
                                float _1936 = _1933 - float((int)(_1934));
                                float _1938 = _14[_1934];
                                float _1941 = _14[(_1934 + 1)];
                                float _1946 = _1938 * 0.5f;
                                _1956 = dot(float3((_1936 * _1936), _1936, 1.0f), float3(mad((_14[(_1934 + 2)]), 0.5f, mad(_1941, -1.0f, _1946)), (_1941 - _1938), mad(_1941, 0.5f, _1946)));
                                break;
                              }
                            }
                            _1956 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1960 = log2(max((lerp(_1799, _1798, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1961 = _1960 * 0.3010300099849701f;
                      do {
                        if (!(!(_1961 <= _1813))) {
                          _2030 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1968 = log2(ACESMidData.x);
                          float _1969 = _1968 * 0.3010300099849701f;
                          if ((bool)(_1961 > _1813) && (bool)(_1961 < _1969)) {
                            float _1977 = ((_1960 - _1812) * 0.9030900001525879f) / ((_1968 - _1812) * 0.3010300099849701f);
                            int _1978 = int(_1977);
                            float _1980 = _1977 - float((int)(_1978));
                            float _1982 = _13[_1978];
                            float _1985 = _13[(_1978 + 1)];
                            float _1990 = _1982 * 0.5f;
                            _2030 = dot(float3((_1980 * _1980), _1980, 1.0f), float3(mad((_13[(_1978 + 2)]), 0.5f, mad(_1985, -1.0f, _1990)), (_1985 - _1982), mad(_1985, 0.5f, _1990)));
                          } else {
                            do {
                              if (!(!(_1961 >= _1969))) {
                                float _1999 = log2(ACESMinMaxData.z);
                                if (_1961 < (_1999 * 0.3010300099849701f)) {
                                  float _2007 = ((_1960 - _1968) * 0.9030900001525879f) / ((_1999 - _1968) * 0.3010300099849701f);
                                  int _2008 = int(_2007);
                                  float _2010 = _2007 - float((int)(_2008));
                                  float _2012 = _14[_2008];
                                  float _2015 = _14[(_2008 + 1)];
                                  float _2020 = _2012 * 0.5f;
                                  _2030 = dot(float3((_2010 * _2010), _2010, 1.0f), float3(mad((_14[(_2008 + 2)]), 0.5f, mad(_2015, -1.0f, _2020)), (_2015 - _2012), mad(_2015, 0.5f, _2020)));
                                  break;
                                }
                              }
                              _2030 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2034 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2035 = (exp2(_1882 * 3.321928024291992f) - ACESMinMaxData.y) / _2034;
                        float _2037 = (exp2(_1956 * 3.321928024291992f) - ACESMinMaxData.y) / _2034;
                        float _2039 = (exp2(_2030 * 3.321928024291992f) - ACESMinMaxData.y) / _2034;
                        float _2042 = mad(0.15618768334388733f, _2039, mad(0.13400420546531677f, _2037, (_2035 * 0.6624541878700256f)));
                        float _2045 = mad(0.053689517080783844f, _2039, mad(0.6740817427635193f, _2037, (_2035 * 0.2722287178039551f)));
                        float _2048 = mad(1.0103391408920288f, _2039, mad(0.00406073359772563f, _2037, (_2035 * -0.005574649665504694f)));
                        float _2061 = min(max(mad(-0.23642469942569733f, _2048, mad(-0.32480329275131226f, _2045, (_2042 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2062 = min(max(mad(0.016756348311901093f, _2048, mad(1.6153316497802734f, _2045, (_2042 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2063 = min(max(mad(0.9883948564529419f, _2048, mad(-0.008284442126750946f, _2045, (_2042 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2066 = mad(0.15618768334388733f, _2063, mad(0.13400420546531677f, _2062, (_2061 * 0.6624541878700256f)));
                        float _2069 = mad(0.053689517080783844f, _2063, mad(0.6740817427635193f, _2062, (_2061 * 0.2722287178039551f)));
                        float _2072 = mad(1.0103391408920288f, _2063, mad(0.00406073359772563f, _2062, (_2061 * -0.005574649665504694f)));
                        float _2094 = min(max((min(max(mad(-0.23642469942569733f, _2072, mad(-0.32480329275131226f, _2069, (_2066 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2095 = min(max((min(max(mad(0.016756348311901093f, _2072, mad(1.6153316497802734f, _2069, (_2066 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2096 = min(max((min(max(mad(0.9883948564529419f, _2072, mad(-0.008284442126750946f, _2069, (_2066 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 5)) {
                            _2109 = mad(_57, _2096, mad(_56, _2095, (_2094 * _55)));
                            _2110 = mad(_60, _2096, mad(_59, _2095, (_2094 * _58)));
                            _2111 = mad(_63, _2096, mad(_62, _2095, (_2094 * _61)));
                          } else {
                            _2109 = _2094;
                            _2110 = _2095;
                            _2111 = _2096;
                          }
                          float _2121 = exp2(log2(_2109 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2122 = exp2(log2(_2110 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2123 = exp2(log2(_2111 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2962 = exp2(log2((1.0f / ((_2121 * 18.6875f) + 1.0f)) * ((_2121 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2963 = exp2(log2((1.0f / ((_2122 * 18.6875f) + 1.0f)) * ((_2122 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2964 = exp2(log2((1.0f / ((_2123 * 18.6875f) + 1.0f)) * ((_2123 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2201 = ACESSceneColorMultiplier * _1326;
          float _2202 = ACESSceneColorMultiplier * _1327;
          float _2203 = ACESSceneColorMultiplier * _1328;
          float _2206 = mad((WorkingColorSpace.ToAP0[0].z), _2203, mad((WorkingColorSpace.ToAP0[0].y), _2202, ((WorkingColorSpace.ToAP0[0].x) * _2201)));
          float _2209 = mad((WorkingColorSpace.ToAP0[1].z), _2203, mad((WorkingColorSpace.ToAP0[1].y), _2202, ((WorkingColorSpace.ToAP0[1].x) * _2201)));
          float _2212 = mad((WorkingColorSpace.ToAP0[2].z), _2203, mad((WorkingColorSpace.ToAP0[2].y), _2202, ((WorkingColorSpace.ToAP0[2].x) * _2201)));
          float _2215 = mad(-0.21492856740951538f, _2212, mad(-0.2365107536315918f, _2209, (_2206 * 1.4514392614364624f)));
          float _2218 = mad(-0.09967592358589172f, _2212, mad(1.17622971534729f, _2209, (_2206 * -0.07655377686023712f)));
          float _2221 = mad(0.9977163076400757f, _2212, mad(-0.006032449658960104f, _2209, (_2206 * 0.008316148072481155f)));
          float _2223 = max(_2215, max(_2218, _2221));
          do {
            if (!(_2223 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2206 < 0.0f) || (bool)(_2209 < 0.0f))) || (bool)(_2212 < 0.0f))) {
                float _2233 = abs(_2223);
                float _2234 = (_2223 - _2215) / _2233;
                float _2236 = (_2223 - _2218) / _2233;
                float _2238 = (_2223 - _2221) / _2233;
                do {
                  if (!(_2234 < 0.8149999976158142f)) {
                    float _2241 = _2234 + -0.8149999976158142f;
                    _2253 = ((_2241 / exp2(log2(exp2(log2(_2241 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2253 = _2234;
                  }
                  do {
                    if (!(_2236 < 0.8029999732971191f)) {
                      float _2256 = _2236 + -0.8029999732971191f;
                      _2268 = ((_2256 / exp2(log2(exp2(log2(_2256 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2268 = _2236;
                    }
                    do {
                      if (!(_2238 < 0.8799999952316284f)) {
                        float _2271 = _2238 + -0.8799999952316284f;
                        _2283 = ((_2271 / exp2(log2(exp2(log2(_2271 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2283 = _2238;
                      }
                      _2291 = (_2223 - (_2233 * _2253));
                      _2292 = (_2223 - (_2233 * _2268));
                      _2293 = (_2223 - (_2233 * _2283));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2291 = _2215;
                _2292 = _2218;
                _2293 = _2221;
              }
            } else {
              _2291 = _2215;
              _2292 = _2218;
              _2293 = _2221;
            }
            float _2309 = ((mad(0.16386906802654266f, _2293, mad(0.14067870378494263f, _2292, (_2291 * 0.6954522132873535f))) - _2206) * ACESGamutCompression) + _2206;
            float _2310 = ((mad(0.0955343171954155f, _2293, mad(0.8596711158752441f, _2292, (_2291 * 0.044794563204050064f))) - _2209) * ACESGamutCompression) + _2209;
            float _2311 = ((mad(1.0015007257461548f, _2293, mad(0.004025210160762072f, _2292, (_2291 * -0.005525882821530104f))) - _2212) * ACESGamutCompression) + _2212;
            float _2315 = max(max(_2309, _2310), _2311);
            float _2320 = (max(_2315, 1.000000013351432e-10f) - max(min(min(_2309, _2310), _2311), 1.000000013351432e-10f)) / max(_2315, 0.009999999776482582f);
            float _2333 = ((_2310 + _2309) + _2311) + (sqrt((((_2311 - _2310) * _2311) + ((_2310 - _2309) * _2310)) + ((_2309 - _2311) * _2309)) * 1.75f);
            float _2334 = _2333 * 0.3333333432674408f;
            float _2335 = _2320 + -0.4000000059604645f;
            float _2336 = _2335 * 5.0f;
            float _2340 = max((1.0f - abs(_2335 * 2.5f)), 0.0f);
            float _2351 = ((float((int)(((int)(uint)((bool)(_2336 > 0.0f))) - ((int)(uint)((bool)(_2336 < 0.0f))))) * (1.0f - (_2340 * _2340))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2334 <= 0.0533333346247673f)) {
                if (!(_2334 >= 0.1599999964237213f)) {
                  _2360 = (((0.23999999463558197f / _2333) + -0.5f) * _2351);
                } else {
                  _2360 = 0.0f;
                }
              } else {
                _2360 = _2351;
              }
              float _2361 = _2360 + 1.0f;
              float _2362 = _2361 * _2309;
              float _2363 = _2361 * _2310;
              float _2364 = _2361 * _2311;
              do {
                if (!((bool)(_2362 == _2363) && (bool)(_2363 == _2364))) {
                  float _2371 = ((_2362 * 2.0f) - _2363) - _2364;
                  float _2374 = ((_2310 - _2311) * 1.7320507764816284f) * _2361;
                  float _2376 = atan(_2374 / _2371);
                  bool _2379 = (_2371 < 0.0f);
                  bool _2380 = (_2371 == 0.0f);
                  bool _2381 = (_2374 >= 0.0f);
                  bool _2382 = (_2374 < 0.0f);
                  _2393 = select((_2381 && _2380), 90.0f, select((_2382 && _2380), -90.0f, (select((_2382 && _2379), (_2376 + -3.1415927410125732f), select((_2381 && _2379), (_2376 + 3.1415927410125732f), _2376)) * 57.2957763671875f)));
                } else {
                  _2393 = 0.0f;
                }
                float _2398 = min(max(select((_2393 < 0.0f), (_2393 + 360.0f), _2393), 0.0f), 360.0f);
                do {
                  if (_2398 < -180.0f) {
                    _2407 = (_2398 + 360.0f);
                  } else {
                    if (_2398 > 180.0f) {
                      _2407 = (_2398 + -360.0f);
                    } else {
                      _2407 = _2398;
                    }
                  }
                  do {
                    if ((bool)(_2407 > -67.5f) && (bool)(_2407 < 67.5f)) {
                      float _2413 = (_2407 + 67.5f) * 0.029629629105329514f;
                      int _2414 = int(_2413);
                      float _2416 = _2413 - float((int)(_2414));
                      float _2417 = _2416 * _2416;
                      float _2418 = _2417 * _2416;
                      if (_2414 == 3) {
                        _2446 = (((0.1666666716337204f - (_2416 * 0.5f)) + (_2417 * 0.5f)) - (_2418 * 0.1666666716337204f));
                      } else {
                        if (_2414 == 2) {
                          _2446 = ((0.6666666865348816f - _2417) + (_2418 * 0.5f));
                        } else {
                          if (_2414 == 1) {
                            _2446 = (((_2418 * -0.5f) + 0.1666666716337204f) + ((_2417 + _2416) * 0.5f));
                          } else {
                            _2446 = select((_2414 == 0), (_2418 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2446 = 0.0f;
                    }
                    float _2455 = min(max(((((_2320 * 0.27000001072883606f) * (0.029999999329447746f - _2362)) * _2446) + _2362), 0.0f), 65535.0f);
                    float _2456 = min(max(_2363, 0.0f), 65535.0f);
                    float _2457 = min(max(_2364, 0.0f), 65535.0f);
                    float _2470 = min(max(mad(-0.21492856740951538f, _2457, mad(-0.2365107536315918f, _2456, (_2455 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2471 = min(max(mad(-0.09967592358589172f, _2457, mad(1.17622971534729f, _2456, (_2455 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2472 = min(max(mad(0.9977163076400757f, _2457, mad(-0.006032449658960104f, _2456, (_2455 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2473 = dot(float3(_2470, _2471, _2472), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    float _2484 = log2(max((lerp(_2473, _2470, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2485 = _2484 * 0.3010300099849701f;
                    float _2486 = log2(ACESMinMaxData.x);
                    float _2487 = _2486 * 0.3010300099849701f;
                    do {
                      if (!(!(_2485 <= _2487))) {
                        _2556 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2494 = log2(ACESMidData.x);
                        float _2495 = _2494 * 0.3010300099849701f;
                        if ((bool)(_2485 > _2487) && (bool)(_2485 < _2495)) {
                          float _2503 = ((_2484 - _2486) * 0.9030900001525879f) / ((_2494 - _2486) * 0.3010300099849701f);
                          int _2504 = int(_2503);
                          float _2506 = _2503 - float((int)(_2504));
                          float _2508 = _11[_2504];
                          float _2511 = _11[(_2504 + 1)];
                          float _2516 = _2508 * 0.5f;
                          _2556 = dot(float3((_2506 * _2506), _2506, 1.0f), float3(mad((_11[(_2504 + 2)]), 0.5f, mad(_2511, -1.0f, _2516)), (_2511 - _2508), mad(_2511, 0.5f, _2516)));
                        } else {
                          do {
                            if (!(!(_2485 >= _2495))) {
                              float _2525 = log2(ACESMinMaxData.z);
                              if (_2485 < (_2525 * 0.3010300099849701f)) {
                                float _2533 = ((_2484 - _2494) * 0.9030900001525879f) / ((_2525 - _2494) * 0.3010300099849701f);
                                int _2534 = int(_2533);
                                float _2536 = _2533 - float((int)(_2534));
                                float _2538 = _12[_2534];
                                float _2541 = _12[(_2534 + 1)];
                                float _2546 = _2538 * 0.5f;
                                _2556 = dot(float3((_2536 * _2536), _2536, 1.0f), float3(mad((_12[(_2534 + 2)]), 0.5f, mad(_2541, -1.0f, _2546)), (_2541 - _2538), mad(_2541, 0.5f, _2546)));
                                break;
                              }
                            }
                            _2556 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2560 = log2(max((lerp(_2473, _2471, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2561 = _2560 * 0.3010300099849701f;
                      do {
                        if (!(!(_2561 <= _2487))) {
                          _2630 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2568 = log2(ACESMidData.x);
                          float _2569 = _2568 * 0.3010300099849701f;
                          if ((bool)(_2561 > _2487) && (bool)(_2561 < _2569)) {
                            float _2577 = ((_2560 - _2486) * 0.9030900001525879f) / ((_2568 - _2486) * 0.3010300099849701f);
                            int _2578 = int(_2577);
                            float _2580 = _2577 - float((int)(_2578));
                            float _2582 = _11[_2578];
                            float _2585 = _11[(_2578 + 1)];
                            float _2590 = _2582 * 0.5f;
                            _2630 = dot(float3((_2580 * _2580), _2580, 1.0f), float3(mad((_11[(_2578 + 2)]), 0.5f, mad(_2585, -1.0f, _2590)), (_2585 - _2582), mad(_2585, 0.5f, _2590)));
                          } else {
                            do {
                              if (!(!(_2561 >= _2569))) {
                                float _2599 = log2(ACESMinMaxData.z);
                                if (_2561 < (_2599 * 0.3010300099849701f)) {
                                  float _2607 = ((_2560 - _2568) * 0.9030900001525879f) / ((_2599 - _2568) * 0.3010300099849701f);
                                  int _2608 = int(_2607);
                                  float _2610 = _2607 - float((int)(_2608));
                                  float _2612 = _12[_2608];
                                  float _2615 = _12[(_2608 + 1)];
                                  float _2620 = _2612 * 0.5f;
                                  _2630 = dot(float3((_2610 * _2610), _2610, 1.0f), float3(mad((_12[(_2608 + 2)]), 0.5f, mad(_2615, -1.0f, _2620)), (_2615 - _2612), mad(_2615, 0.5f, _2620)));
                                  break;
                                }
                              }
                              _2630 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2634 = log2(max((lerp(_2473, _2472, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2635 = _2634 * 0.3010300099849701f;
                        do {
                          if (!(!(_2635 <= _2487))) {
                            _2704 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2642 = log2(ACESMidData.x);
                            float _2643 = _2642 * 0.3010300099849701f;
                            if ((bool)(_2635 > _2487) && (bool)(_2635 < _2643)) {
                              float _2651 = ((_2634 - _2486) * 0.9030900001525879f) / ((_2642 - _2486) * 0.3010300099849701f);
                              int _2652 = int(_2651);
                              float _2654 = _2651 - float((int)(_2652));
                              float _2656 = _11[_2652];
                              float _2659 = _11[(_2652 + 1)];
                              float _2664 = _2656 * 0.5f;
                              _2704 = dot(float3((_2654 * _2654), _2654, 1.0f), float3(mad((_11[(_2652 + 2)]), 0.5f, mad(_2659, -1.0f, _2664)), (_2659 - _2656), mad(_2659, 0.5f, _2664)));
                            } else {
                              do {
                                if (!(!(_2635 >= _2643))) {
                                  float _2673 = log2(ACESMinMaxData.z);
                                  if (_2635 < (_2673 * 0.3010300099849701f)) {
                                    float _2681 = ((_2634 - _2642) * 0.9030900001525879f) / ((_2673 - _2642) * 0.3010300099849701f);
                                    int _2682 = int(_2681);
                                    float _2684 = _2681 - float((int)(_2682));
                                    float _2686 = _12[_2682];
                                    float _2689 = _12[(_2682 + 1)];
                                    float _2694 = _2686 * 0.5f;
                                    _2704 = dot(float3((_2684 * _2684), _2684, 1.0f), float3(mad((_12[(_2682 + 2)]), 0.5f, mad(_2689, -1.0f, _2694)), (_2689 - _2686), mad(_2689, 0.5f, _2694)));
                                    break;
                                  }
                                }
                                _2704 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2708 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2709 = (exp2(_2556 * 3.321928024291992f) - ACESMinMaxData.y) / _2708;
                          float _2711 = (exp2(_2630 * 3.321928024291992f) - ACESMinMaxData.y) / _2708;
                          float _2713 = (exp2(_2704 * 3.321928024291992f) - ACESMinMaxData.y) / _2708;
                          float _2716 = mad(0.15618768334388733f, _2713, mad(0.13400420546531677f, _2711, (_2709 * 0.6624541878700256f)));
                          float _2719 = mad(0.053689517080783844f, _2713, mad(0.6740817427635193f, _2711, (_2709 * 0.2722287178039551f)));
                          float _2722 = mad(1.0103391408920288f, _2713, mad(0.00406073359772563f, _2711, (_2709 * -0.005574649665504694f)));
                          float _2735 = min(max(mad(-0.23642469942569733f, _2722, mad(-0.32480329275131226f, _2719, (_2716 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2736 = min(max(mad(0.016756348311901093f, _2722, mad(1.6153316497802734f, _2719, (_2716 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2737 = min(max(mad(0.9883948564529419f, _2722, mad(-0.008284442126750946f, _2719, (_2716 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2740 = mad(0.15618768334388733f, _2737, mad(0.13400420546531677f, _2736, (_2735 * 0.6624541878700256f)));
                          float _2743 = mad(0.053689517080783844f, _2737, mad(0.6740817427635193f, _2736, (_2735 * 0.2722287178039551f)));
                          float _2746 = mad(1.0103391408920288f, _2737, mad(0.00406073359772563f, _2736, (_2735 * -0.005574649665504694f)));
                          float _2768 = min(max((min(max(mad(-0.23642469942569733f, _2746, mad(-0.32480329275131226f, _2743, (_2740 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2769 = min(max((min(max(mad(0.016756348311901093f, _2746, mad(1.6153316497802734f, _2743, (_2740 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2770 = min(max((min(max(mad(0.9883948564529419f, _2746, mad(-0.008284442126750946f, _2743, (_2740 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(OutputDevice == 6)) {
                              _2783 = mad(_57, _2770, mad(_56, _2769, (_2768 * _55)));
                              _2784 = mad(_60, _2770, mad(_59, _2769, (_2768 * _58)));
                              _2785 = mad(_63, _2770, mad(_62, _2769, (_2768 * _61)));
                            } else {
                              _2783 = _2768;
                              _2784 = _2769;
                              _2785 = _2770;
                            }
                            float _2795 = exp2(log2(_2783 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2796 = exp2(log2(_2784 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2797 = exp2(log2(_2785 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2962 = exp2(log2((1.0f / ((_2795 * 18.6875f) + 1.0f)) * ((_2795 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2963 = exp2(log2((1.0f / ((_2796 * 18.6875f) + 1.0f)) * ((_2796 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2964 = exp2(log2((1.0f / ((_2797 * 18.6875f) + 1.0f)) * ((_2797 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2842 = mad((WorkingColorSpace.ToAP1[0].z), _1328, mad((WorkingColorSpace.ToAP1[0].y), _1327, ((WorkingColorSpace.ToAP1[0].x) * _1326)));
            float _2845 = mad((WorkingColorSpace.ToAP1[1].z), _1328, mad((WorkingColorSpace.ToAP1[1].y), _1327, ((WorkingColorSpace.ToAP1[1].x) * _1326)));
            float _2848 = mad((WorkingColorSpace.ToAP1[2].z), _1328, mad((WorkingColorSpace.ToAP1[2].y), _1327, ((WorkingColorSpace.ToAP1[2].x) * _1326)));
            float _2867 = exp2(log2(mad(_57, _2848, mad(_56, _2845, (_2842 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2868 = exp2(log2(mad(_60, _2848, mad(_59, _2845, (_2842 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2869 = exp2(log2(mad(_63, _2848, mad(_62, _2845, (_2842 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2962 = exp2(log2((1.0f / ((_2867 * 18.6875f) + 1.0f)) * ((_2867 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2963 = exp2(log2((1.0f / ((_2868 * 18.6875f) + 1.0f)) * ((_2868 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2964 = exp2(log2((1.0f / ((_2869 * 18.6875f) + 1.0f)) * ((_2869 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2916 = mad((WorkingColorSpace.ToAP1[0].z), _1316, mad((WorkingColorSpace.ToAP1[0].y), _1315, ((WorkingColorSpace.ToAP1[0].x) * _1314)));
                float _2919 = mad((WorkingColorSpace.ToAP1[1].z), _1316, mad((WorkingColorSpace.ToAP1[1].y), _1315, ((WorkingColorSpace.ToAP1[1].x) * _1314)));
                float _2922 = mad((WorkingColorSpace.ToAP1[2].z), _1316, mad((WorkingColorSpace.ToAP1[2].y), _1315, ((WorkingColorSpace.ToAP1[2].x) * _1314)));
                _2962 = mad(_57, _2922, mad(_56, _2919, (_2916 * _55)));
                _2963 = mad(_60, _2922, mad(_59, _2919, (_2916 * _58)));
                _2964 = mad(_63, _2922, mad(_62, _2919, (_2916 * _61)));
              } else {
                float _2935 = mad((WorkingColorSpace.ToAP1[0].z), _1342, mad((WorkingColorSpace.ToAP1[0].y), _1341, ((WorkingColorSpace.ToAP1[0].x) * _1340)));
                float _2938 = mad((WorkingColorSpace.ToAP1[1].z), _1342, mad((WorkingColorSpace.ToAP1[1].y), _1341, ((WorkingColorSpace.ToAP1[1].x) * _1340)));
                float _2941 = mad((WorkingColorSpace.ToAP1[2].z), _1342, mad((WorkingColorSpace.ToAP1[2].y), _1341, ((WorkingColorSpace.ToAP1[2].x) * _1340)));
                _2962 = exp2(log2(mad(_57, _2941, mad(_56, _2938, (_2935 * _55)))) * InverseGamma.z);
                _2963 = exp2(log2(mad(_60, _2941, mad(_59, _2938, (_2935 * _58)))) * InverseGamma.z);
                _2964 = exp2(log2(mad(_63, _2941, mad(_62, _2938, (_2935 * _61)))) * InverseGamma.z);
              }
            } else {
              _2962 = _1326;
              _2963 = _1327;
              _2964 = _1328;
            }
          }
        }
      }
    }
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2962 * 0.9523810148239136f), (_2963 * 0.9523810148239136f), (_2964 * 0.9523810148239136f), 0.0f);
}

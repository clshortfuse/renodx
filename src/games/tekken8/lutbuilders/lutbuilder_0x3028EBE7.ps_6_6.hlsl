#include "./filmiclutbuilder.hlsl"

Texture2D<float4> Textures_1 : register(t0);

cbuffer UniformBufferConstants_WorkingColorSpace : register(b1) {
  float4 WorkingColorSpace_ToXYZ[4] : packoffset(c000.x);
  float4 WorkingColorSpace_FromXYZ[4] : packoffset(c004.x);
  float4 WorkingColorSpace_ToAP1[4] : packoffset(c008.x);
  float4 WorkingColorSpace_FromAP1[4] : packoffset(c012.x);
  float4 WorkingColorSpace_ToAP0[4] : packoffset(c016.x);
  uint WorkingColorSpace_bIsSRGB : packoffset(c020.x);
};

SamplerState Samplers_1 : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;

  float4 output_color;

  float4 SV_Target;
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _16 = 0.5f / LUTSize;
  float _21 = LUTSize + -1.0f;
  float _22 = (LUTSize * (TEXCOORD.x - _16)) / _21;
  float _23 = (LUTSize * (TEXCOORD.y - _16)) / _21;
  float _25 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _21;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _111;
  float _112;
  float _113;
  float _161;
  float _889;
  float _922;
  float _936;
  float _1000;
  float _1179;
  float _1190;
  float _1201;
  float _1399;
  float _1400;
  float _1401;
  float _1412;
  float _1423;
  float _1603;
  float _1636;
  float _1650;
  float _1689;
  float _1799;
  float _1873;
  float _1947;
  float _2026;
  float _2027;
  float _2028;
  float _2177;
  float _2210;
  float _2224;
  float _2263;
  float _2373;
  float _2447;
  float _2521;
  float _2600;
  float _2601;
  float _2602;
  float _2779;
  float _2780;
  float _2781;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _34 = (OutputGamut == 4);
        _45 = select(_34, 1.0f, 1.7050515413284302f);
        _46 = select(_34, 0.0f, -0.6217905879020691f);
        _47 = select(_34, 0.0f, -0.0832584798336029f);
        _48 = select(_34, 0.0f, -0.13025718927383423f);
        _49 = select(_34, 1.0f, 1.1408027410507202f);
        _50 = select(_34, 0.0f, -0.010548528283834457f);
        _51 = select(_34, 0.0f, -0.024003278464078903f);
        _52 = select(_34, 0.0f, -0.1289687603712082f);
        _53 = select(_34, 1.0f, 1.152971863746643f);
      } else {
        _45 = 0.6954522132873535f;
        _46 = 0.14067870378494263f;
        _47 = 0.16386906802654266f;
        _48 = 0.044794563204050064f;
        _49 = 0.8596711158752441f;
        _50 = 0.0955343171954155f;
        _51 = -0.005525882821530104f;
        _52 = 0.004025210160762072f;
        _53 = 1.0015007257461548f;
      }
    } else {
      _45 = 1.02579927444458f;
      _46 = -0.020052503794431686f;
      _47 = -0.0057713985443115234f;
      _48 = -0.0022350111976265907f;
      _49 = 1.0045825242996216f;
      _50 = -0.002352306619286537f;
      _51 = -0.005014004185795784f;
      _52 = -0.025293385609984398f;
      _53 = 1.0304402112960815f;
    }
  } else {
    _45 = 1.379158854484558f;
    _46 = -0.3088507056236267f;
    _47 = -0.07034677267074585f;
    _48 = -0.06933528929948807f;
    _49 = 1.0822921991348267f;
    _50 = -0.012962047010660172f;
    _51 = -0.002159259282052517f;
    _52 = -0.045465391129255295f;
    _53 = 1.0477596521377563f;
  }
  if ((uint)OutputDevice > (uint)2) {
    float _64 = (pow(_22, 0.012683313339948654f));
    float _65 = (pow(_23, 0.012683313339948654f));
    float _66 = (pow(_25, 0.012683313339948654f));
    _111 = (exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _112 = (exp2(log2(max(0.0f, (_65 + -0.8359375f)) / (18.8515625f - (_65 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _113 = (exp2(log2(max(0.0f, (_66 + -0.8359375f)) / (18.8515625f - (_66 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _111 = ((exp2((_22 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _112 = ((exp2((_23 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _113 = ((exp2((_25 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  bool _140 = (bIsTemperatureWhiteBalance != 0);
  float _144 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _161 = (((((2967800.0f - (_144 * 4607000064.0f)) * _144) + 99.11000061035156f) * _144) + 0.24406300485134125f);
  } else {
    _161 = (((((1901800.0f - (_144 * 2006400000.0f)) * _144) + 247.47999572753906f) * _144) + 0.23703999817371368f);
  }
  float _175 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _182 = WhiteTemp * WhiteTemp;
  float _185 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_182 * 1.6145605741257896e-07f));
  float _190 = ((_175 * 2.0f) + 4.0f) - (_185 * 8.0f);
  float _191 = (_175 * 3.0f) / _190;
  float _193 = (_185 * 2.0f) / _190;
  bool _194 = (WhiteTemp < 4000.0f);
  float _203 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _205 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_182 * 1.5317699909210205f)) / (_203 * _203);
  float _212 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _182;
  float _214 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_182 * 308.60699462890625f)) / (_212 * _212);
  float _216 = rsqrt(dot(float2(_205, _214), float2(_205, _214)));
  float _217 = WhiteTint * 0.05000000074505806f;
  float _220 = ((_217 * _214) * _216) + _175;
  float _223 = _185 - ((_217 * _205) * _216);
  float _228 = (4.0f - (_223 * 8.0f)) + (_220 * 2.0f);
  float _234 = (((_220 * 3.0f) / _228) - _191) + select(_194, _191, _161);
  float _235 = (((_223 * 2.0f) / _228) - _193) + select(_194, _193, (((_161 * 2.869999885559082f) + -0.2750000059604645f) - ((_161 * _161) * 3.0f)));
  float _236 = select(_140, _234, 0.3127000033855438f);
  float _237 = select(_140, _235, 0.32899999618530273f);
  float _238 = select(_140, 0.3127000033855438f, _234);
  float _239 = select(_140, 0.32899999618530273f, _235);
  float _240 = max(_237, 1.000000013351432e-10f);
  float _241 = _236 / _240;
  float _244 = ((1.0f - _236) - _237) / _240;
  float _245 = max(_239, 1.000000013351432e-10f);
  float _246 = _238 / _245;
  float _249 = ((1.0f - _238) - _239) / _245;
  float _268 = mad(-0.16140000522136688f, _249, ((_246 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _244, ((_241 * 0.8950999975204468f) + 0.266400009393692f));
  float _269 = mad(0.03669999912381172f, _249, (1.7135000228881836f - (_246 * 0.7501999735832214f))) / mad(0.03669999912381172f, _244, (1.7135000228881836f - (_241 * 0.7501999735832214f)));
  float _270 = mad(1.0296000242233276f, _249, ((_246 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _244, ((_241 * 0.03889999911189079f) + -0.06849999725818634f));
  float _271 = mad(_269, -0.7501999735832214f, 0.0f);
  float _272 = mad(_269, 1.7135000228881836f, 0.0f);
  float _273 = mad(_269, 0.03669999912381172f, -0.0f);
  float _274 = mad(_270, 0.03889999911189079f, 0.0f);
  float _275 = mad(_270, -0.06849999725818634f, 0.0f);
  float _276 = mad(_270, 1.0296000242233276f, 0.0f);
  float _279 = mad(0.1599626988172531f, _274, mad(-0.1470542997121811f, _271, (_268 * 0.883457362651825f)));
  float _282 = mad(0.1599626988172531f, _275, mad(-0.1470542997121811f, _272, (_268 * 0.26293492317199707f)));
  float _285 = mad(0.1599626988172531f, _276, mad(-0.1470542997121811f, _273, (_268 * -0.15930065512657166f)));
  float _288 = mad(0.04929120093584061f, _274, mad(0.5183603167533875f, _271, (_268 * 0.38695648312568665f)));
  float _291 = mad(0.04929120093584061f, _275, mad(0.5183603167533875f, _272, (_268 * 0.11516613513231277f)));
  float _294 = mad(0.04929120093584061f, _276, mad(0.5183603167533875f, _273, (_268 * -0.0697740763425827f)));
  float _297 = mad(0.9684867262840271f, _274, mad(0.04004279896616936f, _271, (_268 * -0.007634039502590895f)));
  float _300 = mad(0.9684867262840271f, _275, mad(0.04004279896616936f, _272, (_268 * -0.0022720457054674625f)));
  float _303 = mad(0.9684867262840271f, _276, mad(0.04004279896616936f, _273, (_268 * 0.0013765322510153055f)));
  float _306 = mad(_285, (WorkingColorSpace_ToXYZ[2].x), mad(_282, (WorkingColorSpace_ToXYZ[1].x), (_279 * (WorkingColorSpace_ToXYZ[0].x))));
  float _309 = mad(_285, (WorkingColorSpace_ToXYZ[2].y), mad(_282, (WorkingColorSpace_ToXYZ[1].y), (_279 * (WorkingColorSpace_ToXYZ[0].y))));
  float _312 = mad(_285, (WorkingColorSpace_ToXYZ[2].z), mad(_282, (WorkingColorSpace_ToXYZ[1].z), (_279 * (WorkingColorSpace_ToXYZ[0].z))));
  float _315 = mad(_294, (WorkingColorSpace_ToXYZ[2].x), mad(_291, (WorkingColorSpace_ToXYZ[1].x), (_288 * (WorkingColorSpace_ToXYZ[0].x))));
  float _318 = mad(_294, (WorkingColorSpace_ToXYZ[2].y), mad(_291, (WorkingColorSpace_ToXYZ[1].y), (_288 * (WorkingColorSpace_ToXYZ[0].y))));
  float _321 = mad(_294, (WorkingColorSpace_ToXYZ[2].z), mad(_291, (WorkingColorSpace_ToXYZ[1].z), (_288 * (WorkingColorSpace_ToXYZ[0].z))));
  float _324 = mad(_303, (WorkingColorSpace_ToXYZ[2].x), mad(_300, (WorkingColorSpace_ToXYZ[1].x), (_297 * (WorkingColorSpace_ToXYZ[0].x))));
  float _327 = mad(_303, (WorkingColorSpace_ToXYZ[2].y), mad(_300, (WorkingColorSpace_ToXYZ[1].y), (_297 * (WorkingColorSpace_ToXYZ[0].y))));
  float _330 = mad(_303, (WorkingColorSpace_ToXYZ[2].z), mad(_300, (WorkingColorSpace_ToXYZ[1].z), (_297 * (WorkingColorSpace_ToXYZ[0].z))));
  float _360 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _330, mad((WorkingColorSpace_FromXYZ[0].y), _321, (_312 * (WorkingColorSpace_FromXYZ[0].x)))), _113, mad(mad((WorkingColorSpace_FromXYZ[0].z), _327, mad((WorkingColorSpace_FromXYZ[0].y), _318, (_309 * (WorkingColorSpace_FromXYZ[0].x)))), _112, (mad((WorkingColorSpace_FromXYZ[0].z), _324, mad((WorkingColorSpace_FromXYZ[0].y), _315, (_306 * (WorkingColorSpace_FromXYZ[0].x)))) * _111)));
  float _363 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _330, mad((WorkingColorSpace_FromXYZ[1].y), _321, (_312 * (WorkingColorSpace_FromXYZ[1].x)))), _113, mad(mad((WorkingColorSpace_FromXYZ[1].z), _327, mad((WorkingColorSpace_FromXYZ[1].y), _318, (_309 * (WorkingColorSpace_FromXYZ[1].x)))), _112, (mad((WorkingColorSpace_FromXYZ[1].z), _324, mad((WorkingColorSpace_FromXYZ[1].y), _315, (_306 * (WorkingColorSpace_FromXYZ[1].x)))) * _111)));
  float _366 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _330, mad((WorkingColorSpace_FromXYZ[2].y), _321, (_312 * (WorkingColorSpace_FromXYZ[2].x)))), _113, mad(mad((WorkingColorSpace_FromXYZ[2].z), _327, mad((WorkingColorSpace_FromXYZ[2].y), _318, (_309 * (WorkingColorSpace_FromXYZ[2].x)))), _112, (mad((WorkingColorSpace_FromXYZ[2].z), _324, mad((WorkingColorSpace_FromXYZ[2].y), _315, (_306 * (WorkingColorSpace_FromXYZ[2].x)))) * _111)));
  float _381 = mad((WorkingColorSpace_ToAP1[0].z), _366, mad((WorkingColorSpace_ToAP1[0].y), _363, ((WorkingColorSpace_ToAP1[0].x) * _360)));
  float _384 = mad((WorkingColorSpace_ToAP1[1].z), _366, mad((WorkingColorSpace_ToAP1[1].y), _363, ((WorkingColorSpace_ToAP1[1].x) * _360)));
  float _387 = mad((WorkingColorSpace_ToAP1[2].z), _366, mad((WorkingColorSpace_ToAP1[2].y), _363, ((WorkingColorSpace_ToAP1[2].x) * _360)));
  float _388 = dot(float3(_381, _384, _387), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _392 = (_381 / _388) + -1.0f;
  float _393 = (_384 / _388) + -1.0f;
  float _394 = (_387 / _388) + -1.0f;
  float _406 = (1.0f - exp2(((_388 * _388) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_392, _393, _394), float3(_392, _393, _394)) * -4.0f));
  float _422 = ((mad(-0.06368283927440643f, _387, mad(-0.32929131388664246f, _384, (_381 * 1.370412826538086f))) - _381) * _406) + _381;
  float _423 = ((mad(-0.010861567221581936f, _387, mad(1.0970908403396606f, _384, (_381 * -0.08343426138162613f))) - _384) * _406) + _384;
  float _424 = ((mad(1.203694462776184f, _387, mad(-0.09862564504146576f, _384, (_381 * -0.02579325996339321f))) - _387) * _406) + _387;
  float _425 = dot(float3(_422, _423, _424), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _439 = ColorOffset.w + ColorOffsetShadows.w;
  float _453 = ColorGain.w * ColorGainShadows.w;
  float _467 = ColorGamma.w * ColorGammaShadows.w;
  float _481 = ColorContrast.w * ColorContrastShadows.w;
  float _495 = ColorSaturation.w * ColorSaturationShadows.w;
  float _499 = _422 - _425;
  float _500 = _423 - _425;
  float _501 = _424 - _425;
  float _558 = saturate(_425 / ColorCorrectionShadowsMax);
  float _562 = (_558 * _558) * (3.0f - (_558 * 2.0f));
  float _563 = 1.0f - _562;
  float _572 = ColorOffset.w + ColorOffsetHighlights.w;
  float _581 = ColorGain.w * ColorGainHighlights.w;
  float _590 = ColorGamma.w * ColorGammaHighlights.w;
  float _599 = ColorContrast.w * ColorContrastHighlights.w;
  float _608 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _671 = saturate((_425 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _675 = (_671 * _671) * (3.0f - (_671 * 2.0f));
  float _684 = ColorOffset.w + ColorOffsetMidtones.w;
  float _693 = ColorGain.w * ColorGainMidtones.w;
  float _702 = ColorGamma.w * ColorGammaMidtones.w;
  float _711 = ColorContrast.w * ColorContrastMidtones.w;
  float _720 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _778 = _562 - _675;
  float _789 = ((_675 * (((ColorOffset.x + ColorOffsetHighlights.x) + _572) + (((ColorGain.x * ColorGainHighlights.x) * _581) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _599) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _608) * _499) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _590)))))) + (_563 * (((ColorOffset.x + ColorOffsetShadows.x) + _439) + (((ColorGain.x * ColorGainShadows.x) * _453) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _481) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _495) * _499) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _467))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _684) + (((ColorGain.x * ColorGainMidtones.x) * _693) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _711) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _720) * _499) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _702))))) * _778);
  float _791 = ((_675 * (((ColorOffset.y + ColorOffsetHighlights.y) + _572) + (((ColorGain.y * ColorGainHighlights.y) * _581) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _599) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _608) * _500) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _590)))))) + (_563 * (((ColorOffset.y + ColorOffsetShadows.y) + _439) + (((ColorGain.y * ColorGainShadows.y) * _453) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _481) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _495) * _500) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _467))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _684) + (((ColorGain.y * ColorGainMidtones.y) * _693) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _711) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _720) * _500) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _702))))) * _778);
  float _793 = ((_675 * (((ColorOffset.z + ColorOffsetHighlights.z) + _572) + (((ColorGain.z * ColorGainHighlights.z) * _581) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _599) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _608) * _501) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _590)))))) + (_563 * (((ColorOffset.z + ColorOffsetShadows.z) + _439) + (((ColorGain.z * ColorGainShadows.z) * _453) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _481) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _495) * _501) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _467))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _684) + (((ColorGain.z * ColorGainMidtones.z) * _693) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _711) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _720) * _501) + _425)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _702))))) * _778);
  float _829 = ((mad(0.061360642313957214f, _793, mad(-4.540197551250458e-09f, _791, (_789 * 0.9386394023895264f))) - _789) * BlueCorrection) + _789;
  float _830 = ((mad(0.169205904006958f, _793, mad(0.8307942152023315f, _791, (_789 * 6.775371730327606e-08f))) - _791) * BlueCorrection) + _791;
  float _831 = (mad(-2.3283064365386963e-10f, _791, (_789 * -9.313225746154785e-10f)) * BlueCorrection) + _793;
  float _834 = mad(0.16386905312538147f, _831, mad(0.14067868888378143f, _830, (_829 * 0.6954522132873535f)));
  float _837 = mad(0.0955343246459961f, _831, mad(0.8596711158752441f, _830, (_829 * 0.044794581830501556f)));
  float _840 = mad(1.0015007257461548f, _831, mad(0.004025210160762072f, _830, (_829 * -0.005525882821530104f)));
  float _844 = max(max(_834, _837), _840);
  float _849 = (max(_844, 1.000000013351432e-10f) - max(min(min(_834, _837), _840), 1.000000013351432e-10f)) / max(_844, 0.009999999776482582f);
  float _862 = ((_837 + _834) + _840) + (sqrt((((_840 - _837) * _840) + ((_837 - _834) * _837)) + ((_834 - _840) * _834)) * 1.75f);
  float _863 = _862 * 0.3333333432674408f;
  float _864 = _849 + -0.4000000059604645f;
  float _865 = _864 * 5.0f;
  float _869 = max((1.0f - abs(_864 * 2.5f)), 0.0f);
  float _880 = ((float((int)(((int)(uint)((bool)(_865 > 0.0f))) - ((int)(uint)((bool)(_865 < 0.0f))))) * (1.0f - (_869 * _869))) + 1.0f) * 0.02500000037252903f;
  if (!(_863 <= 0.0533333346247673f)) {
    if (!(_863 >= 0.1599999964237213f)) {
      _889 = (((0.23999999463558197f / _862) + -0.5f) * _880);
    } else {
      _889 = 0.0f;
    }
  } else {
    _889 = _880;
  }
  float _890 = _889 + 1.0f;
  float _891 = _890 * _834;
  float _892 = _890 * _837;
  float _893 = _890 * _840;
  if (!((bool)(_891 == _892) && (bool)(_892 == _893))) {
    float _900 = ((_891 * 2.0f) - _892) - _893;
    float _903 = ((_837 - _840) * 1.7320507764816284f) * _890;
    float _905 = atan(_903 / _900);
    bool _908 = (_900 < 0.0f);
    bool _909 = (_900 == 0.0f);
    bool _910 = (_903 >= 0.0f);
    bool _911 = (_903 < 0.0f);
    _922 = select((_910 && _909), 90.0f, select((_911 && _909), -90.0f, (select((_911 && _908), (_905 + -3.1415927410125732f), select((_910 && _908), (_905 + 3.1415927410125732f), _905)) * 57.2957763671875f)));
  } else {
    _922 = 0.0f;
  }
  float _927 = min(max(select((_922 < 0.0f), (_922 + 360.0f), _922), 0.0f), 360.0f);
  if (_927 < -180.0f) {
    _936 = (_927 + 360.0f);
  } else {
    if (_927 > 180.0f) {
      _936 = (_927 + -360.0f);
    } else {
      _936 = _927;
    }
  }
  float _940 = saturate(1.0f - abs(_936 * 0.014814814552664757f));
  float _944 = (_940 * _940) * (3.0f - (_940 * 2.0f));
  float _950 = ((_944 * _944) * ((_849 * 0.18000000715255737f) * (0.029999999329447746f - _891))) + _891;
  float _960 = max(0.0f, mad(-0.21492856740951538f, _893, mad(-0.2365107536315918f, _892, (_950 * 1.4514392614364624f))));
  float _961 = max(0.0f, mad(-0.09967592358589172f, _893, mad(1.17622971534729f, _892, (_950 * -0.07655377686023712f))));
  float _962 = max(0.0f, mad(0.9977163076400757f, _893, mad(-0.006032449658960104f, _892, (_950 * 0.008316148072481155f))));
  float _963 = dot(float3(_960, _961, _962), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float _1009 = lerp(_963, _960, 0.9599999785423279f);
  float _1010 = lerp(_963, _961, 0.9599999785423279f);
  float _1011 = lerp(_963, _962, 0.9599999785423279f);

#if 1
  ApplyFilmicToneMap(_1009, _1010, _1011, _829, _830, _831);
  float _1151 = _1009, _1152 = _1010, _1153 = _1011;
#else
  float _978 = (FilmBlackClip + 1.0f) - FilmToe;
  float _980 = FilmWhiteClip + 1.0f;
  float _982 = _980 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1000 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _991 = (FilmBlackClip + 0.18000000715255737f) / _978;
    _1000 = (-0.7447274923324585f - ((log2(_991 / (2.0f - _991)) * 0.3465735912322998f) * (_978 / FilmSlope)));
  }
  float _1003 = ((1.0f - FilmToe) / FilmSlope) - _1000;
  float _1005 = (FilmShoulder / FilmSlope) - _1003;
  _1009 = log2(lerp(_963, _960, 0.9599999785423279f)) * 0.3010300099849701f;
  _1010 = log2(lerp(_963, _961, 0.9599999785423279f)) * 0.3010300099849701f;
  _1011 = log2(lerp(_963, _962, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1015 = FilmSlope * (_1009 + _1003);
  float _1016 = FilmSlope * (_1010 + _1003);
  float _1017 = FilmSlope * (_1011 + _1003);
  float _1018 = _978 * 2.0f;
  float _1020 = (FilmSlope * -2.0f) / _978;
  float _1021 = _1009 - _1000;
  float _1022 = _1010 - _1000;
  float _1023 = _1011 - _1000;
  float _1042 = _982 * 2.0f;
  float _1044 = (FilmSlope * 2.0f) / _982;
  float _1069 = select((_1009 < _1000), ((_1018 / (exp2((_1021 * 1.4426950216293335f) * _1020) + 1.0f)) - FilmBlackClip), _1015);
  float _1070 = select((_1010 < _1000), ((_1018 / (exp2((_1022 * 1.4426950216293335f) * _1020) + 1.0f)) - FilmBlackClip), _1016);
  float _1071 = select((_1011 < _1000), ((_1018 / (exp2((_1023 * 1.4426950216293335f) * _1020) + 1.0f)) - FilmBlackClip), _1017);
  float _1078 = _1005 - _1000;
  float _1082 = saturate(_1021 / _1078);
  float _1083 = saturate(_1022 / _1078);
  float _1084 = saturate(_1023 / _1078);
  bool _1085 = (_1005 < _1000);
  float _1089 = select(_1085, (1.0f - _1082), _1082);
  float _1090 = select(_1085, (1.0f - _1083), _1083);
  float _1091 = select(_1085, (1.0f - _1084), _1084);
  float _1110 = (((_1089 * _1089) * (select((_1009 > _1005), (_980 - (_1042 / (exp2(((_1009 - _1005) * 1.4426950216293335f) * _1044) + 1.0f))), _1015) - _1069)) * (3.0f - (_1089 * 2.0f))) + _1069;
  float _1111 = (((_1090 * _1090) * (select((_1010 > _1005), (_980 - (_1042 / (exp2(((_1010 - _1005) * 1.4426950216293335f) * _1044) + 1.0f))), _1016) - _1070)) * (3.0f - (_1090 * 2.0f))) + _1070;
  float _1112 = (((_1091 * _1091) * (select((_1011 > _1005), (_980 - (_1042 / (exp2(((_1011 - _1005) * 1.4426950216293335f) * _1044) + 1.0f))), _1017) - _1071)) * (3.0f - (_1091 * 2.0f))) + _1071;
  float _1113 = dot(float3(_1110, _1111, _1112), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1133 = (ToneCurveAmount * (max(0.0f, (lerp(_1113, _1110, 0.9300000071525574f))) - _829)) + _829;
  float _1134 = (ToneCurveAmount * (max(0.0f, (lerp(_1113, _1111, 0.9300000071525574f))) - _830)) + _830;
  float _1135 = (ToneCurveAmount * (max(0.0f, (lerp(_1113, _1112, 0.9300000071525574f))) - _831)) + _831;
  float _1151 = ((mad(-0.06537103652954102f, _1135, mad(1.451815478503704e-06f, _1134, (_1133 * 1.065374732017517f))) - _1133) * BlueCorrection) + _1133;
  float _1152 = ((mad(-0.20366770029067993f, _1135, mad(1.2036634683609009f, _1134, (_1133 * -2.57161445915699e-07f))) - _1134) * BlueCorrection) + _1134;
  float _1153 = ((mad(0.9999996423721313f, _1135, mad(2.0954757928848267e-08f, _1134, (_1133 * 1.862645149230957e-08f))) - _1135) * BlueCorrection) + _1135;
#endif
  // Remove saturate and max
  float _1166 = mad((WorkingColorSpace_FromAP1[0].z), _1153, mad((WorkingColorSpace_FromAP1[0].y), _1152, ((WorkingColorSpace_FromAP1[0].x) * _1151)));
  float _1167 = mad((WorkingColorSpace_FromAP1[1].z), _1153, mad((WorkingColorSpace_FromAP1[1].y), _1152, ((WorkingColorSpace_FromAP1[1].x) * _1151)));
  float _1168 = mad((WorkingColorSpace_FromAP1[2].z), _1153, mad((WorkingColorSpace_FromAP1[2].y), _1152, ((WorkingColorSpace_FromAP1[2].x) * _1151)));
  
  /*
  if (_1166 < 0.0031306699384003878f) {
    _1179 = (_1166 * 12.920000076293945f);
  } else {
    _1179 = (((pow(_1166, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1167 < 0.0031306699384003878f) {
    _1190 = (_1167 * 12.920000076293945f);
  } else {
    _1190 = (((pow(_1167, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1168 < 0.0031306699384003878f) {
    _1201 = (_1168 * 12.920000076293945f);
  } else {
    _1201 = (((pow(_1168, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1205 = (_1190 * 0.9375f) + 0.03125f;
  float _1212 = _1201 * 15.0f;
  float _1213 = floor(_1212);
  float _1214 = _1212 - _1213;
  float _1216 = (((_1179 * 0.9375f) + 0.03125f) + _1213) * 0.0625f;
  float4 _1219 = Textures_1.Sample(Samplers_1, float2(_1216, _1205));
  float4 _1226 = Textures_1.Sample(Samplers_1, float2((_1216 + 0.0625f), _1205));
  float _1245 = max(6.103519990574569e-05f, (((lerp(_1219.x, _1226.x, _1214)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1179)));
  float _1246 = max(6.103519990574569e-05f, (((lerp(_1219.y, _1226.y, _1214)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1190)));
  float _1247 = max(6.103519990574569e-05f, (((lerp(_1219.z, _1226.z, _1214)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1201)));
  float _1269 = select((_1245 > 0.040449999272823334f), exp2(log2((_1245 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1245 * 0.07739938050508499f));
  float _1270 = select((_1246 > 0.040449999272823334f), exp2(log2((_1246 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1246 * 0.07739938050508499f));
  float _1271 = select((_1247 > 0.040449999272823334f), exp2(log2((_1247 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1247 * 0.07739938050508499f));
  */

  float3 untonemapped = float3(_1166, _1167, _1168);
  float _1269;
  float _1270;
  float _1271;
  SampleLUTUpgradeToneMap(untonemapped, Samplers_1, Textures_1, _1269, _1270, _1271);

  float _1297 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1269)) * _1269) + MappingPolynomial.z);
  float _1298 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1270)) * _1270) + MappingPolynomial.z);
  float _1299 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1271)) * _1271) + MappingPolynomial.z);
  float _1306 = ((OverlayColor.x - _1297) * OverlayColor.w) + _1297;
  float _1307 = ((OverlayColor.y - _1298) * OverlayColor.w) + _1298;
  float _1308 = ((OverlayColor.z - _1299) * OverlayColor.w) + _1299;

  if (GenerateOutput(_1306, _1307, _1308, SV_Target)) {
    return SV_Target;
  }

  float _1309 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _793, mad((WorkingColorSpace_FromAP1[0].y), _791, (_789 * (WorkingColorSpace_FromAP1[0].x))));
  float _1310 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _793, mad((WorkingColorSpace_FromAP1[1].y), _791, ((WorkingColorSpace_FromAP1[1].x) * _789)));
  float _1311 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _793, mad((WorkingColorSpace_FromAP1[2].y), _791, ((WorkingColorSpace_FromAP1[2].x) * _789)));
  float _1318 = ((OverlayColor.x - _1309) * OverlayColor.w) + _1309;
  float _1319 = ((OverlayColor.y - _1310) * OverlayColor.w) + _1310;
  float _1320 = ((OverlayColor.z - _1311) * OverlayColor.w) + _1311;
  float _1332 = exp2(log2(max(0.0f, _1306)) * InverseGamma.y);
  float _1333 = exp2(log2(max(0.0f, _1307)) * InverseGamma.y);
  float _1334 = exp2(log2(max(0.0f, _1308)) * InverseGamma.y);
  [branch]
  if (OutputDevice == 0) {
    float _1340 = max(dot(float3(_1332, _1333, _1334), float3(0.2126390039920807f, 0.7151690125465393f, 0.0721919983625412f)), 9.999999747378752e-05f);
    float _1360 = ((select((_1340 < PolarisToneCurveCoef1.z), 0.0f, 1.0f) * ((PolarisToneCurveCoef0.y - _1340) + ((-0.0f - PolarisToneCurveCoef1.x) / (PolarisToneCurveCoef0.x + _1340)))) + _1340) * PolarisToneCurveCoef1.y;
    float _1361 = _1360 * (_1332 / _1340);
    float _1362 = _1360 * (_1333 / _1340);
    float _1363 = _1360 * (_1334 / _1340);
    do {
      if (WorkingColorSpace_bIsSRGB == 0) {
        float _1382 = mad((WorkingColorSpace_ToAP1[0].z), _1363, mad((WorkingColorSpace_ToAP1[0].y), _1362, ((WorkingColorSpace_ToAP1[0].x) * _1361)));
        float _1385 = mad((WorkingColorSpace_ToAP1[1].z), _1363, mad((WorkingColorSpace_ToAP1[1].y), _1362, ((WorkingColorSpace_ToAP1[1].x) * _1361)));
        float _1388 = mad((WorkingColorSpace_ToAP1[2].z), _1363, mad((WorkingColorSpace_ToAP1[2].y), _1362, ((WorkingColorSpace_ToAP1[2].x) * _1361)));
        _1399 = mad(_47, _1388, mad(_46, _1385, (_1382 * _45)));
        _1400 = mad(_50, _1388, mad(_49, _1385, (_1382 * _48)));
        _1401 = mad(_53, _1388, mad(_52, _1385, (_1382 * _51)));
      } else {
        _1399 = _1361;
        _1400 = _1362;
        _1401 = _1363;
      }
      do {
        if (_1399 < 0.0031306699384003878f) {
          _1412 = (_1399 * 12.920000076293945f);
        } else {
          _1412 = (((pow(_1399, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1400 < 0.0031306699384003878f) {
            _1423 = (_1400 * 12.920000076293945f);
          } else {
            _1423 = (((pow(_1400, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1401 < 0.0031306699384003878f) {
            _2779 = _1412;
            _2780 = _1423;
            _2781 = (_1401 * 12.920000076293945f);
          } else {
            _2779 = _1412;
            _2780 = _1423;
            _2781 = (((pow(_1401, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1450 = mad((WorkingColorSpace_ToAP1[0].z), _1334, mad((WorkingColorSpace_ToAP1[0].y), _1333, ((WorkingColorSpace_ToAP1[0].x) * _1332)));
      float _1453 = mad((WorkingColorSpace_ToAP1[1].z), _1334, mad((WorkingColorSpace_ToAP1[1].y), _1333, ((WorkingColorSpace_ToAP1[1].x) * _1332)));
      float _1456 = mad((WorkingColorSpace_ToAP1[2].z), _1334, mad((WorkingColorSpace_ToAP1[2].y), _1333, ((WorkingColorSpace_ToAP1[2].x) * _1332)));
      float _1466 = max(6.103519990574569e-05f, mad(_47, _1456, mad(_46, _1453, (_1450 * _45))));
      float _1467 = max(6.103519990574569e-05f, mad(_50, _1456, mad(_49, _1453, (_1450 * _48))));
      float _1468 = max(6.103519990574569e-05f, mad(_53, _1456, mad(_52, _1453, (_1450 * _51))));
      _2779 = min((_1466 * 4.5f), ((exp2(log2(max(_1466, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2780 = min((_1467 * 4.5f), ((exp2(log2(max(_1467, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2781 = min((_1468 * 4.5f), ((exp2(log2(max(_1468, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
        _12[0] = ACESCoefsLow_0.x;
        _12[1] = ACESCoefsLow_0.y;
        _12[2] = ACESCoefsLow_0.z;
        _12[3] = ACESCoefsLow_0.w;
        _12[4] = ACESCoefsLow_4;
        _12[5] = ACESCoefsLow_4;
        _13[0] = ACESCoefsHigh_0.x;
        _13[1] = ACESCoefsHigh_0.y;
        _13[2] = ACESCoefsHigh_0.z;
        _13[3] = ACESCoefsHigh_0.w;
        _13[4] = ACESCoefsHigh_4;
        _13[5] = ACESCoefsHigh_4;
        float _1543 = ACESSceneColorMultiplier * _1318;
        float _1544 = ACESSceneColorMultiplier * _1319;
        float _1545 = ACESSceneColorMultiplier * _1320;
        float _1548 = mad((WorkingColorSpace_ToAP0[0].z), _1545, mad((WorkingColorSpace_ToAP0[0].y), _1544, ((WorkingColorSpace_ToAP0[0].x) * _1543)));
        float _1551 = mad((WorkingColorSpace_ToAP0[1].z), _1545, mad((WorkingColorSpace_ToAP0[1].y), _1544, ((WorkingColorSpace_ToAP0[1].x) * _1543)));
        float _1554 = mad((WorkingColorSpace_ToAP0[2].z), _1545, mad((WorkingColorSpace_ToAP0[2].y), _1544, ((WorkingColorSpace_ToAP0[2].x) * _1543)));
        float _1558 = max(max(_1548, _1551), _1554);
        float _1563 = (max(_1558, 1.000000013351432e-10f) - max(min(min(_1548, _1551), _1554), 1.000000013351432e-10f)) / max(_1558, 0.009999999776482582f);
        float _1576 = ((_1551 + _1548) + _1554) + (sqrt((((_1554 - _1551) * _1554) + ((_1551 - _1548) * _1551)) + ((_1548 - _1554) * _1548)) * 1.75f);
        float _1577 = _1576 * 0.3333333432674408f;
        float _1578 = _1563 + -0.4000000059604645f;
        float _1579 = _1578 * 5.0f;
        float _1583 = max((1.0f - abs(_1578 * 2.5f)), 0.0f);
        float _1594 = ((float((int)(((int)(uint)((bool)(_1579 > 0.0f))) - ((int)(uint)((bool)(_1579 < 0.0f))))) * (1.0f - (_1583 * _1583))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1577 <= 0.0533333346247673f)) {
            if (!(_1577 >= 0.1599999964237213f)) {
              _1603 = (((0.23999999463558197f / _1576) + -0.5f) * _1594);
            } else {
              _1603 = 0.0f;
            }
          } else {
            _1603 = _1594;
          }
          float _1604 = _1603 + 1.0f;
          float _1605 = _1604 * _1548;
          float _1606 = _1604 * _1551;
          float _1607 = _1604 * _1554;
          do {
            if (!((bool)(_1605 == _1606) && (bool)(_1606 == _1607))) {
              float _1614 = ((_1605 * 2.0f) - _1606) - _1607;
              float _1617 = ((_1551 - _1554) * 1.7320507764816284f) * _1604;
              float _1619 = atan(_1617 / _1614);
              bool _1622 = (_1614 < 0.0f);
              bool _1623 = (_1614 == 0.0f);
              bool _1624 = (_1617 >= 0.0f);
              bool _1625 = (_1617 < 0.0f);
              _1636 = select((_1624 && _1623), 90.0f, select((_1625 && _1623), -90.0f, (select((_1625 && _1622), (_1619 + -3.1415927410125732f), select((_1624 && _1622), (_1619 + 3.1415927410125732f), _1619)) * 57.2957763671875f)));
            } else {
              _1636 = 0.0f;
            }
            float _1641 = min(max(select((_1636 < 0.0f), (_1636 + 360.0f), _1636), 0.0f), 360.0f);
            do {
              if (_1641 < -180.0f) {
                _1650 = (_1641 + 360.0f);
              } else {
                if (_1641 > 180.0f) {
                  _1650 = (_1641 + -360.0f);
                } else {
                  _1650 = _1641;
                }
              }
              do {
                if ((bool)(_1650 > -67.5f) && (bool)(_1650 < 67.5f)) {
                  float _1656 = (_1650 + 67.5f) * 0.029629629105329514f;
                  int _1657 = int(_1656);
                  float _1659 = _1656 - float((int)(_1657));
                  float _1660 = _1659 * _1659;
                  float _1661 = _1660 * _1659;
                  if (_1657 == 3) {
                    _1689 = (((0.1666666716337204f - (_1659 * 0.5f)) + (_1660 * 0.5f)) - (_1661 * 0.1666666716337204f));
                  } else {
                    if (_1657 == 2) {
                      _1689 = ((0.6666666865348816f - _1660) + (_1661 * 0.5f));
                    } else {
                      if (_1657 == 1) {
                        _1689 = (((_1661 * -0.5f) + 0.1666666716337204f) + ((_1660 + _1659) * 0.5f));
                      } else {
                        _1689 = select((_1657 == 0), (_1661 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1689 = 0.0f;
                }
                float _1698 = min(max(((((_1563 * 0.27000001072883606f) * (0.029999999329447746f - _1605)) * _1689) + _1605), 0.0f), 65535.0f);
                float _1699 = min(max(_1606, 0.0f), 65535.0f);
                float _1700 = min(max(_1607, 0.0f), 65535.0f);
                float _1713 = min(max(mad(-0.21492856740951538f, _1700, mad(-0.2365107536315918f, _1699, (_1698 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1714 = min(max(mad(-0.09967592358589172f, _1700, mad(1.17622971534729f, _1699, (_1698 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1715 = min(max(mad(0.9977163076400757f, _1700, mad(-0.006032449658960104f, _1699, (_1698 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1716 = dot(float3(_1713, _1714, _1715), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1727 = log2(max((lerp(_1716, _1713, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1728 = _1727 * 0.3010300099849701f;
                float _1729 = log2(ACESMinMaxData.x);
                float _1730 = _1729 * 0.3010300099849701f;
                do {
                  if (!(!(_1728 <= _1730))) {
                    _1799 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1737 = log2(ACESMidData.x);
                    float _1738 = _1737 * 0.3010300099849701f;
                    if ((bool)(_1728 > _1730) && (bool)(_1728 < _1738)) {
                      float _1746 = ((_1727 - _1729) * 0.9030900001525879f) / ((_1737 - _1729) * 0.3010300099849701f);
                      int _1747 = int(_1746);
                      float _1749 = _1746 - float((int)(_1747));
                      float _1751 = _12[_1747];
                      float _1754 = _12[(_1747 + 1)];
                      float _1759 = _1751 * 0.5f;
                      _1799 = dot(float3((_1749 * _1749), _1749, 1.0f), float3(mad((_12[(_1747 + 2)]), 0.5f, mad(_1754, -1.0f, _1759)), (_1754 - _1751), mad(_1754, 0.5f, _1759)));
                    } else {
                      do {
                        if (!(!(_1728 >= _1738))) {
                          float _1768 = log2(ACESMinMaxData.z);
                          if (_1728 < (_1768 * 0.3010300099849701f)) {
                            float _1776 = ((_1727 - _1737) * 0.9030900001525879f) / ((_1768 - _1737) * 0.3010300099849701f);
                            int _1777 = int(_1776);
                            float _1779 = _1776 - float((int)(_1777));
                            float _1781 = _13[_1777];
                            float _1784 = _13[(_1777 + 1)];
                            float _1789 = _1781 * 0.5f;
                            _1799 = dot(float3((_1779 * _1779), _1779, 1.0f), float3(mad((_13[(_1777 + 2)]), 0.5f, mad(_1784, -1.0f, _1789)), (_1784 - _1781), mad(_1784, 0.5f, _1789)));
                            break;
                          }
                        }
                        _1799 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1803 = log2(max((lerp(_1716, _1714, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1804 = _1803 * 0.3010300099849701f;
                  do {
                    if (!(!(_1804 <= _1730))) {
                      _1873 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1811 = log2(ACESMidData.x);
                      float _1812 = _1811 * 0.3010300099849701f;
                      if ((bool)(_1804 > _1730) && (bool)(_1804 < _1812)) {
                        float _1820 = ((_1803 - _1729) * 0.9030900001525879f) / ((_1811 - _1729) * 0.3010300099849701f);
                        int _1821 = int(_1820);
                        float _1823 = _1820 - float((int)(_1821));
                        float _1825 = _12[_1821];
                        float _1828 = _12[(_1821 + 1)];
                        float _1833 = _1825 * 0.5f;
                        _1873 = dot(float3((_1823 * _1823), _1823, 1.0f), float3(mad((_12[(_1821 + 2)]), 0.5f, mad(_1828, -1.0f, _1833)), (_1828 - _1825), mad(_1828, 0.5f, _1833)));
                      } else {
                        do {
                          if (!(!(_1804 >= _1812))) {
                            float _1842 = log2(ACESMinMaxData.z);
                            if (_1804 < (_1842 * 0.3010300099849701f)) {
                              float _1850 = ((_1803 - _1811) * 0.9030900001525879f) / ((_1842 - _1811) * 0.3010300099849701f);
                              int _1851 = int(_1850);
                              float _1853 = _1850 - float((int)(_1851));
                              float _1855 = _13[_1851];
                              float _1858 = _13[(_1851 + 1)];
                              float _1863 = _1855 * 0.5f;
                              _1873 = dot(float3((_1853 * _1853), _1853, 1.0f), float3(mad((_13[(_1851 + 2)]), 0.5f, mad(_1858, -1.0f, _1863)), (_1858 - _1855), mad(_1858, 0.5f, _1863)));
                              break;
                            }
                          }
                          _1873 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1877 = log2(max((lerp(_1716, _1715, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1878 = _1877 * 0.3010300099849701f;
                    do {
                      if (!(!(_1878 <= _1730))) {
                        _1947 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1885 = log2(ACESMidData.x);
                        float _1886 = _1885 * 0.3010300099849701f;
                        if ((bool)(_1878 > _1730) && (bool)(_1878 < _1886)) {
                          float _1894 = ((_1877 - _1729) * 0.9030900001525879f) / ((_1885 - _1729) * 0.3010300099849701f);
                          int _1895 = int(_1894);
                          float _1897 = _1894 - float((int)(_1895));
                          float _1899 = _12[_1895];
                          float _1902 = _12[(_1895 + 1)];
                          float _1907 = _1899 * 0.5f;
                          _1947 = dot(float3((_1897 * _1897), _1897, 1.0f), float3(mad((_12[(_1895 + 2)]), 0.5f, mad(_1902, -1.0f, _1907)), (_1902 - _1899), mad(_1902, 0.5f, _1907)));
                        } else {
                          do {
                            if (!(!(_1878 >= _1886))) {
                              float _1916 = log2(ACESMinMaxData.z);
                              if (_1878 < (_1916 * 0.3010300099849701f)) {
                                float _1924 = ((_1877 - _1885) * 0.9030900001525879f) / ((_1916 - _1885) * 0.3010300099849701f);
                                int _1925 = int(_1924);
                                float _1927 = _1924 - float((int)(_1925));
                                float _1929 = _13[_1925];
                                float _1932 = _13[(_1925 + 1)];
                                float _1937 = _1929 * 0.5f;
                                _1947 = dot(float3((_1927 * _1927), _1927, 1.0f), float3(mad((_13[(_1925 + 2)]), 0.5f, mad(_1932, -1.0f, _1937)), (_1932 - _1929), mad(_1932, 0.5f, _1937)));
                                break;
                              }
                            }
                            _1947 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1951 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1952 = (exp2(_1799 * 3.321928024291992f) - ACESMinMaxData.y) / _1951;
                      float _1954 = (exp2(_1873 * 3.321928024291992f) - ACESMinMaxData.y) / _1951;
                      float _1956 = (exp2(_1947 * 3.321928024291992f) - ACESMinMaxData.y) / _1951;
                      float _1959 = mad(0.15618768334388733f, _1956, mad(0.13400420546531677f, _1954, (_1952 * 0.6624541878700256f)));
                      float _1962 = mad(0.053689517080783844f, _1956, mad(0.6740817427635193f, _1954, (_1952 * 0.2722287178039551f)));
                      float _1965 = mad(1.0103391408920288f, _1956, mad(0.00406073359772563f, _1954, (_1952 * -0.005574649665504694f)));
                      float _1978 = min(max(mad(-0.23642469942569733f, _1965, mad(-0.32480329275131226f, _1962, (_1959 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1979 = min(max(mad(0.016756348311901093f, _1965, mad(1.6153316497802734f, _1962, (_1959 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1980 = min(max(mad(0.9883948564529419f, _1965, mad(-0.008284442126750946f, _1962, (_1959 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1983 = mad(0.15618768334388733f, _1980, mad(0.13400420546531677f, _1979, (_1978 * 0.6624541878700256f)));
                      float _1986 = mad(0.053689517080783844f, _1980, mad(0.6740817427635193f, _1979, (_1978 * 0.2722287178039551f)));
                      float _1989 = mad(1.0103391408920288f, _1980, mad(0.00406073359772563f, _1979, (_1978 * -0.005574649665504694f)));
                      float _2011 = min(max((min(max(mad(-0.23642469942569733f, _1989, mad(-0.32480329275131226f, _1986, (_1983 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2012 = min(max((min(max(mad(0.016756348311901093f, _1989, mad(1.6153316497802734f, _1986, (_1983 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2013 = min(max((min(max(mad(0.9883948564529419f, _1989, mad(-0.008284442126750946f, _1986, (_1983 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!(OutputDevice == 5)) {
                          _2026 = mad(_47, _2013, mad(_46, _2012, (_2011 * _45)));
                          _2027 = mad(_50, _2013, mad(_49, _2012, (_2011 * _48)));
                          _2028 = mad(_53, _2013, mad(_52, _2012, (_2011 * _51)));
                        } else {
                          _2026 = _2011;
                          _2027 = _2012;
                          _2028 = _2013;
                        }
                        float _2038 = exp2(log2(_2026 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2039 = exp2(log2(_2027 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2040 = exp2(log2(_2028 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2779 = exp2(log2((1.0f / ((_2038 * 18.6875f) + 1.0f)) * ((_2038 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2780 = exp2(log2((1.0f / ((_2039 * 18.6875f) + 1.0f)) * ((_2039 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2781 = exp2(log2((1.0f / ((_2040 * 18.6875f) + 1.0f)) * ((_2040 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          _10[0] = ACESCoefsLow_0.x;
          _10[1] = ACESCoefsLow_0.y;
          _10[2] = ACESCoefsLow_0.z;
          _10[3] = ACESCoefsLow_0.w;
          _10[4] = ACESCoefsLow_4;
          _10[5] = ACESCoefsLow_4;
          _11[0] = ACESCoefsHigh_0.x;
          _11[1] = ACESCoefsHigh_0.y;
          _11[2] = ACESCoefsHigh_0.z;
          _11[3] = ACESCoefsHigh_0.w;
          _11[4] = ACESCoefsHigh_4;
          _11[5] = ACESCoefsHigh_4;
          float _2117 = ACESSceneColorMultiplier * _1318;
          float _2118 = ACESSceneColorMultiplier * _1319;
          float _2119 = ACESSceneColorMultiplier * _1320;
          float _2122 = mad((WorkingColorSpace_ToAP0[0].z), _2119, mad((WorkingColorSpace_ToAP0[0].y), _2118, ((WorkingColorSpace_ToAP0[0].x) * _2117)));
          float _2125 = mad((WorkingColorSpace_ToAP0[1].z), _2119, mad((WorkingColorSpace_ToAP0[1].y), _2118, ((WorkingColorSpace_ToAP0[1].x) * _2117)));
          float _2128 = mad((WorkingColorSpace_ToAP0[2].z), _2119, mad((WorkingColorSpace_ToAP0[2].y), _2118, ((WorkingColorSpace_ToAP0[2].x) * _2117)));
          float _2132 = max(max(_2122, _2125), _2128);
          float _2137 = (max(_2132, 1.000000013351432e-10f) - max(min(min(_2122, _2125), _2128), 1.000000013351432e-10f)) / max(_2132, 0.009999999776482582f);
          float _2150 = ((_2125 + _2122) + _2128) + (sqrt((((_2128 - _2125) * _2128) + ((_2125 - _2122) * _2125)) + ((_2122 - _2128) * _2122)) * 1.75f);
          float _2151 = _2150 * 0.3333333432674408f;
          float _2152 = _2137 + -0.4000000059604645f;
          float _2153 = _2152 * 5.0f;
          float _2157 = max((1.0f - abs(_2152 * 2.5f)), 0.0f);
          float _2168 = ((float((int)(((int)(uint)((bool)(_2153 > 0.0f))) - ((int)(uint)((bool)(_2153 < 0.0f))))) * (1.0f - (_2157 * _2157))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2151 <= 0.0533333346247673f)) {
              if (!(_2151 >= 0.1599999964237213f)) {
                _2177 = (((0.23999999463558197f / _2150) + -0.5f) * _2168);
              } else {
                _2177 = 0.0f;
              }
            } else {
              _2177 = _2168;
            }
            float _2178 = _2177 + 1.0f;
            float _2179 = _2178 * _2122;
            float _2180 = _2178 * _2125;
            float _2181 = _2178 * _2128;
            do {
              if (!((bool)(_2179 == _2180) && (bool)(_2180 == _2181))) {
                float _2188 = ((_2179 * 2.0f) - _2180) - _2181;
                float _2191 = ((_2125 - _2128) * 1.7320507764816284f) * _2178;
                float _2193 = atan(_2191 / _2188);
                bool _2196 = (_2188 < 0.0f);
                bool _2197 = (_2188 == 0.0f);
                bool _2198 = (_2191 >= 0.0f);
                bool _2199 = (_2191 < 0.0f);
                _2210 = select((_2198 && _2197), 90.0f, select((_2199 && _2197), -90.0f, (select((_2199 && _2196), (_2193 + -3.1415927410125732f), select((_2198 && _2196), (_2193 + 3.1415927410125732f), _2193)) * 57.2957763671875f)));
              } else {
                _2210 = 0.0f;
              }
              float _2215 = min(max(select((_2210 < 0.0f), (_2210 + 360.0f), _2210), 0.0f), 360.0f);
              do {
                if (_2215 < -180.0f) {
                  _2224 = (_2215 + 360.0f);
                } else {
                  if (_2215 > 180.0f) {
                    _2224 = (_2215 + -360.0f);
                  } else {
                    _2224 = _2215;
                  }
                }
                do {
                  if ((bool)(_2224 > -67.5f) && (bool)(_2224 < 67.5f)) {
                    float _2230 = (_2224 + 67.5f) * 0.029629629105329514f;
                    int _2231 = int(_2230);
                    float _2233 = _2230 - float((int)(_2231));
                    float _2234 = _2233 * _2233;
                    float _2235 = _2234 * _2233;
                    if (_2231 == 3) {
                      _2263 = (((0.1666666716337204f - (_2233 * 0.5f)) + (_2234 * 0.5f)) - (_2235 * 0.1666666716337204f));
                    } else {
                      if (_2231 == 2) {
                        _2263 = ((0.6666666865348816f - _2234) + (_2235 * 0.5f));
                      } else {
                        if (_2231 == 1) {
                          _2263 = (((_2235 * -0.5f) + 0.1666666716337204f) + ((_2234 + _2233) * 0.5f));
                        } else {
                          _2263 = select((_2231 == 0), (_2235 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2263 = 0.0f;
                  }
                  float _2272 = min(max(((((_2137 * 0.27000001072883606f) * (0.029999999329447746f - _2179)) * _2263) + _2179), 0.0f), 65535.0f);
                  float _2273 = min(max(_2180, 0.0f), 65535.0f);
                  float _2274 = min(max(_2181, 0.0f), 65535.0f);
                  float _2287 = min(max(mad(-0.21492856740951538f, _2274, mad(-0.2365107536315918f, _2273, (_2272 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2288 = min(max(mad(-0.09967592358589172f, _2274, mad(1.17622971534729f, _2273, (_2272 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2289 = min(max(mad(0.9977163076400757f, _2274, mad(-0.006032449658960104f, _2273, (_2272 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2290 = dot(float3(_2287, _2288, _2289), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2301 = log2(max((lerp(_2290, _2287, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2302 = _2301 * 0.3010300099849701f;
                  float _2303 = log2(ACESMinMaxData.x);
                  float _2304 = _2303 * 0.3010300099849701f;
                  do {
                    if (!(!(_2302 <= _2304))) {
                      _2373 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2311 = log2(ACESMidData.x);
                      float _2312 = _2311 * 0.3010300099849701f;
                      if ((bool)(_2302 > _2304) && (bool)(_2302 < _2312)) {
                        float _2320 = ((_2301 - _2303) * 0.9030900001525879f) / ((_2311 - _2303) * 0.3010300099849701f);
                        int _2321 = int(_2320);
                        float _2323 = _2320 - float((int)(_2321));
                        float _2325 = _10[_2321];
                        float _2328 = _10[(_2321 + 1)];
                        float _2333 = _2325 * 0.5f;
                        _2373 = dot(float3((_2323 * _2323), _2323, 1.0f), float3(mad((_10[(_2321 + 2)]), 0.5f, mad(_2328, -1.0f, _2333)), (_2328 - _2325), mad(_2328, 0.5f, _2333)));
                      } else {
                        do {
                          if (!(!(_2302 >= _2312))) {
                            float _2342 = log2(ACESMinMaxData.z);
                            if (_2302 < (_2342 * 0.3010300099849701f)) {
                              float _2350 = ((_2301 - _2311) * 0.9030900001525879f) / ((_2342 - _2311) * 0.3010300099849701f);
                              int _2351 = int(_2350);
                              float _2353 = _2350 - float((int)(_2351));
                              float _2355 = _11[_2351];
                              float _2358 = _11[(_2351 + 1)];
                              float _2363 = _2355 * 0.5f;
                              _2373 = dot(float3((_2353 * _2353), _2353, 1.0f), float3(mad((_11[(_2351 + 2)]), 0.5f, mad(_2358, -1.0f, _2363)), (_2358 - _2355), mad(_2358, 0.5f, _2363)));
                              break;
                            }
                          }
                          _2373 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2377 = log2(max((lerp(_2290, _2288, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2378 = _2377 * 0.3010300099849701f;
                    do {
                      if (!(!(_2378 <= _2304))) {
                        _2447 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2385 = log2(ACESMidData.x);
                        float _2386 = _2385 * 0.3010300099849701f;
                        if ((bool)(_2378 > _2304) && (bool)(_2378 < _2386)) {
                          float _2394 = ((_2377 - _2303) * 0.9030900001525879f) / ((_2385 - _2303) * 0.3010300099849701f);
                          int _2395 = int(_2394);
                          float _2397 = _2394 - float((int)(_2395));
                          float _2399 = _10[_2395];
                          float _2402 = _10[(_2395 + 1)];
                          float _2407 = _2399 * 0.5f;
                          _2447 = dot(float3((_2397 * _2397), _2397, 1.0f), float3(mad((_10[(_2395 + 2)]), 0.5f, mad(_2402, -1.0f, _2407)), (_2402 - _2399), mad(_2402, 0.5f, _2407)));
                        } else {
                          do {
                            if (!(!(_2378 >= _2386))) {
                              float _2416 = log2(ACESMinMaxData.z);
                              if (_2378 < (_2416 * 0.3010300099849701f)) {
                                float _2424 = ((_2377 - _2385) * 0.9030900001525879f) / ((_2416 - _2385) * 0.3010300099849701f);
                                int _2425 = int(_2424);
                                float _2427 = _2424 - float((int)(_2425));
                                float _2429 = _11[_2425];
                                float _2432 = _11[(_2425 + 1)];
                                float _2437 = _2429 * 0.5f;
                                _2447 = dot(float3((_2427 * _2427), _2427, 1.0f), float3(mad((_11[(_2425 + 2)]), 0.5f, mad(_2432, -1.0f, _2437)), (_2432 - _2429), mad(_2432, 0.5f, _2437)));
                                break;
                              }
                            }
                            _2447 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2451 = log2(max((lerp(_2290, _2289, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2452 = _2451 * 0.3010300099849701f;
                      do {
                        if (!(!(_2452 <= _2304))) {
                          _2521 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2459 = log2(ACESMidData.x);
                          float _2460 = _2459 * 0.3010300099849701f;
                          if ((bool)(_2452 > _2304) && (bool)(_2452 < _2460)) {
                            float _2468 = ((_2451 - _2303) * 0.9030900001525879f) / ((_2459 - _2303) * 0.3010300099849701f);
                            int _2469 = int(_2468);
                            float _2471 = _2468 - float((int)(_2469));
                            float _2473 = _10[_2469];
                            float _2476 = _10[(_2469 + 1)];
                            float _2481 = _2473 * 0.5f;
                            _2521 = dot(float3((_2471 * _2471), _2471, 1.0f), float3(mad((_10[(_2469 + 2)]), 0.5f, mad(_2476, -1.0f, _2481)), (_2476 - _2473), mad(_2476, 0.5f, _2481)));
                          } else {
                            do {
                              if (!(!(_2452 >= _2460))) {
                                float _2490 = log2(ACESMinMaxData.z);
                                if (_2452 < (_2490 * 0.3010300099849701f)) {
                                  float _2498 = ((_2451 - _2459) * 0.9030900001525879f) / ((_2490 - _2459) * 0.3010300099849701f);
                                  int _2499 = int(_2498);
                                  float _2501 = _2498 - float((int)(_2499));
                                  float _2503 = _11[_2499];
                                  float _2506 = _11[(_2499 + 1)];
                                  float _2511 = _2503 * 0.5f;
                                  _2521 = dot(float3((_2501 * _2501), _2501, 1.0f), float3(mad((_11[(_2499 + 2)]), 0.5f, mad(_2506, -1.0f, _2511)), (_2506 - _2503), mad(_2506, 0.5f, _2511)));
                                  break;
                                }
                              }
                              _2521 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2525 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2526 = (exp2(_2373 * 3.321928024291992f) - ACESMinMaxData.y) / _2525;
                        float _2528 = (exp2(_2447 * 3.321928024291992f) - ACESMinMaxData.y) / _2525;
                        float _2530 = (exp2(_2521 * 3.321928024291992f) - ACESMinMaxData.y) / _2525;
                        float _2533 = mad(0.15618768334388733f, _2530, mad(0.13400420546531677f, _2528, (_2526 * 0.6624541878700256f)));
                        float _2536 = mad(0.053689517080783844f, _2530, mad(0.6740817427635193f, _2528, (_2526 * 0.2722287178039551f)));
                        float _2539 = mad(1.0103391408920288f, _2530, mad(0.00406073359772563f, _2528, (_2526 * -0.005574649665504694f)));
                        float _2552 = min(max(mad(-0.23642469942569733f, _2539, mad(-0.32480329275131226f, _2536, (_2533 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2553 = min(max(mad(0.016756348311901093f, _2539, mad(1.6153316497802734f, _2536, (_2533 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2554 = min(max(mad(0.9883948564529419f, _2539, mad(-0.008284442126750946f, _2536, (_2533 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2557 = mad(0.15618768334388733f, _2554, mad(0.13400420546531677f, _2553, (_2552 * 0.6624541878700256f)));
                        float _2560 = mad(0.053689517080783844f, _2554, mad(0.6740817427635193f, _2553, (_2552 * 0.2722287178039551f)));
                        float _2563 = mad(1.0103391408920288f, _2554, mad(0.00406073359772563f, _2553, (_2552 * -0.005574649665504694f)));
                        float _2585 = min(max((min(max(mad(-0.23642469942569733f, _2563, mad(-0.32480329275131226f, _2560, (_2557 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2586 = min(max((min(max(mad(0.016756348311901093f, _2563, mad(1.6153316497802734f, _2560, (_2557 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2587 = min(max((min(max(mad(0.9883948564529419f, _2563, mad(-0.008284442126750946f, _2560, (_2557 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 6)) {
                            _2600 = mad(_47, _2587, mad(_46, _2586, (_2585 * _45)));
                            _2601 = mad(_50, _2587, mad(_49, _2586, (_2585 * _48)));
                            _2602 = mad(_53, _2587, mad(_52, _2586, (_2585 * _51)));
                          } else {
                            _2600 = _2585;
                            _2601 = _2586;
                            _2602 = _2587;
                          }
                          float _2612 = exp2(log2(_2600 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2613 = exp2(log2(_2601 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2614 = exp2(log2(_2602 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2779 = exp2(log2((1.0f / ((_2612 * 18.6875f) + 1.0f)) * ((_2612 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2780 = exp2(log2((1.0f / ((_2613 * 18.6875f) + 1.0f)) * ((_2613 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2781 = exp2(log2((1.0f / ((_2614 * 18.6875f) + 1.0f)) * ((_2614 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2659 = mad((WorkingColorSpace_ToAP1[0].z), _1320, mad((WorkingColorSpace_ToAP1[0].y), _1319, ((WorkingColorSpace_ToAP1[0].x) * _1318)));
            float _2662 = mad((WorkingColorSpace_ToAP1[1].z), _1320, mad((WorkingColorSpace_ToAP1[1].y), _1319, ((WorkingColorSpace_ToAP1[1].x) * _1318)));
            float _2665 = mad((WorkingColorSpace_ToAP1[2].z), _1320, mad((WorkingColorSpace_ToAP1[2].y), _1319, ((WorkingColorSpace_ToAP1[2].x) * _1318)));
            float _2684 = exp2(log2(mad(_47, _2665, mad(_46, _2662, (_2659 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2685 = exp2(log2(mad(_50, _2665, mad(_49, _2662, (_2659 * _48))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2686 = exp2(log2(mad(_53, _2665, mad(_52, _2662, (_2659 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2779 = exp2(log2((1.0f / ((_2684 * 18.6875f) + 1.0f)) * ((_2684 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2780 = exp2(log2((1.0f / ((_2685 * 18.6875f) + 1.0f)) * ((_2685 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2781 = exp2(log2((1.0f / ((_2686 * 18.6875f) + 1.0f)) * ((_2686 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2733 = mad((WorkingColorSpace_ToAP1[0].z), _1308, mad((WorkingColorSpace_ToAP1[0].y), _1307, ((WorkingColorSpace_ToAP1[0].x) * _1306)));
                float _2736 = mad((WorkingColorSpace_ToAP1[1].z), _1308, mad((WorkingColorSpace_ToAP1[1].y), _1307, ((WorkingColorSpace_ToAP1[1].x) * _1306)));
                float _2739 = mad((WorkingColorSpace_ToAP1[2].z), _1308, mad((WorkingColorSpace_ToAP1[2].y), _1307, ((WorkingColorSpace_ToAP1[2].x) * _1306)));
                _2779 = mad(_47, _2739, mad(_46, _2736, (_2733 * _45)));
                _2780 = mad(_50, _2739, mad(_49, _2736, (_2733 * _48)));
                _2781 = mad(_53, _2739, mad(_52, _2736, (_2733 * _51)));
              } else {
                float _2752 = mad((WorkingColorSpace_ToAP1[0].z), _1334, mad((WorkingColorSpace_ToAP1[0].y), _1333, ((WorkingColorSpace_ToAP1[0].x) * _1332)));
                float _2755 = mad((WorkingColorSpace_ToAP1[1].z), _1334, mad((WorkingColorSpace_ToAP1[1].y), _1333, ((WorkingColorSpace_ToAP1[1].x) * _1332)));
                float _2758 = mad((WorkingColorSpace_ToAP1[2].z), _1334, mad((WorkingColorSpace_ToAP1[2].y), _1333, ((WorkingColorSpace_ToAP1[2].x) * _1332)));
                _2779 = exp2(log2(mad(_47, _2758, mad(_46, _2755, (_2752 * _45)))) * InverseGamma.z);
                _2780 = exp2(log2(mad(_50, _2758, mad(_49, _2755, (_2752 * _48)))) * InverseGamma.z);
                _2781 = exp2(log2(mad(_53, _2758, mad(_52, _2755, (_2752 * _51)))) * InverseGamma.z);
              }
            } else {
              _2779 = _1318;
              _2780 = _1319;
              _2781 = _1320;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2779 * 0.9523810148239136f);
  SV_Target.y = (_2780 * 0.9523810148239136f);
  SV_Target.z = (_2781 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

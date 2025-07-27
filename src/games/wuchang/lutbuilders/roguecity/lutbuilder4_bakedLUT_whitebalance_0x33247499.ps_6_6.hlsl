#include "../filmiclutbuilder.hlsli"

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
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
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
  float _1374;
  float _1375;
  float _1376;
  float _1387;
  float _1398;
  float _1578;
  float _1611;
  float _1625;
  float _1664;
  float _1774;
  float _1848;
  float _1922;
  float _2001;
  float _2002;
  float _2003;
  float _2152;
  float _2185;
  float _2199;
  float _2238;
  float _2348;
  float _2422;
  float _2496;
  float _2575;
  float _2576;
  float _2577;
  float _2754;
  float _2755;
  float _2756;
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
  // AP1_RGB2Y
  float _963 = dot(float3(_960, _961, _962), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1009 = lerp(_963, _960, 0.9599999785423279f);
  float _1010 = lerp(_963, _961, 0.9599999785423279f);
  float _1011 = lerp(_963, _962, 0.9599999785423279f);
  // END RRT

#if 1
  ApplyFilmicToneMap(_1009, _1010, _1011, _829, _830, _831);
  float _1151 = _1009, _1152 = _1010, _1153 = _1011;
#else

  _1009 = log2(_1009) * 0.3010300099849701f;
  _1010 = log2(_1010) * 0.3010300099849701f;
  _1011 = log2(_1011) * 0.3010300099849701f;

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
  // float _1009 = log2(lerp(_963, _960, 0.9599999785423279f)) * 0.3010300099849701f;
  // float _1010 = log2(lerp(_963, _961, 0.9599999785423279f)) * 0.3010300099849701f;
  // float _1011 = log2(lerp(_963, _962, 0.9599999785423279f)) * 0.3010300099849701f;
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

  float _1166 = mad((WorkingColorSpace_FromAP1[0].z), _1153, mad((WorkingColorSpace_FromAP1[0].y), _1152, ((WorkingColorSpace_FromAP1[0].x) * _1151)));
  float _1167 = mad((WorkingColorSpace_FromAP1[1].z), _1153, mad((WorkingColorSpace_FromAP1[1].y), _1152, ((WorkingColorSpace_FromAP1[1].x) * _1151)));
  float _1168 = mad((WorkingColorSpace_FromAP1[2].z), _1153, mad((WorkingColorSpace_FromAP1[2].y), _1152, ((WorkingColorSpace_FromAP1[2].x) * _1151)));

  // _1179 = renodx::color::srgb::Encode(saturate(_1166));
  // _1190 = renodx::color::srgb::Encode(saturate(_1167));
  // _1201 = renodx::color::srgb::Encode(saturate(_1168));
  // float _1205 = (_1190 * 0.9375f) + 0.03125f;
  // float _1212 = _1201 * 15.0f;
  // float _1213 = floor(_1212);
  // float _1214 = _1212 - _1213;
  // float _1216 = (((_1179 * 0.9375f) + 0.03125f) + _1213) * 0.0625f;
  // float4 _1219 = Textures_1.Sample(Samplers_1, float2(_1216, _1205));
  // float4 _1226 = Textures_1.Sample(Samplers_1, float2((_1216 + 0.0625f), _1205));
  // float _1245 = (((lerp(_1219.x, _1226.x, _1214)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1179));
  // float _1246 = (((lerp(_1219.y, _1226.y, _1214)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1190));
  // float _1247 = (((lerp(_1219.z, _1226.z, _1214)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1201));
  // float _1269 = renodx::color::srgb::Decode(max(_1245, 6.103519990574569e-05f));
  // float _1270 = renodx::color::srgb::Decode(max(_1246, 6.103519990574569e-05f));
  // float _1271 = renodx::color::srgb::Decode(max(_1247, 6.103519990574569e-05f));

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
    do {
      if (WorkingColorSpace_bIsSRGB == 0) {
        float _1357 = mad((WorkingColorSpace_ToAP1[0].z), _1334, mad((WorkingColorSpace_ToAP1[0].y), _1333, ((WorkingColorSpace_ToAP1[0].x) * _1332)));
        float _1360 = mad((WorkingColorSpace_ToAP1[1].z), _1334, mad((WorkingColorSpace_ToAP1[1].y), _1333, ((WorkingColorSpace_ToAP1[1].x) * _1332)));
        float _1363 = mad((WorkingColorSpace_ToAP1[2].z), _1334, mad((WorkingColorSpace_ToAP1[2].y), _1333, ((WorkingColorSpace_ToAP1[2].x) * _1332)));
        _1374 = mad(_47, _1363, mad(_46, _1360, (_1357 * _45)));
        _1375 = mad(_50, _1363, mad(_49, _1360, (_1357 * _48)));
        _1376 = mad(_53, _1363, mad(_52, _1360, (_1357 * _51)));
      } else {
        _1374 = _1332;
        _1375 = _1333;
        _1376 = _1334;
      }
      do {
        if (_1374 < 0.0031306699384003878f) {
          _1387 = (_1374 * 12.920000076293945f);
        } else {
          _1387 = (((pow(_1374, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1375 < 0.0031306699384003878f) {
            _1398 = (_1375 * 12.920000076293945f);
          } else {
            _1398 = (((pow(_1375, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1376 < 0.0031306699384003878f) {
            _2754 = _1387;
            _2755 = _1398;
            _2756 = (_1376 * 12.920000076293945f);
          } else {
            _2754 = _1387;
            _2755 = _1398;
            _2756 = (((pow(_1376, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1425 = mad((WorkingColorSpace_ToAP1[0].z), _1334, mad((WorkingColorSpace_ToAP1[0].y), _1333, ((WorkingColorSpace_ToAP1[0].x) * _1332)));
      float _1428 = mad((WorkingColorSpace_ToAP1[1].z), _1334, mad((WorkingColorSpace_ToAP1[1].y), _1333, ((WorkingColorSpace_ToAP1[1].x) * _1332)));
      float _1431 = mad((WorkingColorSpace_ToAP1[2].z), _1334, mad((WorkingColorSpace_ToAP1[2].y), _1333, ((WorkingColorSpace_ToAP1[2].x) * _1332)));
      float _1441 = max(6.103519990574569e-05f, mad(_47, _1431, mad(_46, _1428, (_1425 * _45))));
      float _1442 = max(6.103519990574569e-05f, mad(_50, _1431, mad(_49, _1428, (_1425 * _48))));
      float _1443 = max(6.103519990574569e-05f, mad(_53, _1431, mad(_52, _1428, (_1425 * _51))));
      _2754 = min((_1441 * 4.5f), ((exp2(log2(max(_1441, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2755 = min((_1442 * 4.5f), ((exp2(log2(max(_1442, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2756 = min((_1443 * 4.5f), ((exp2(log2(max(_1443, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        float _1518 = ACESSceneColorMultiplier * _1318;
        float _1519 = ACESSceneColorMultiplier * _1319;
        float _1520 = ACESSceneColorMultiplier * _1320;
        float _1523 = mad((WorkingColorSpace_ToAP0[0].z), _1520, mad((WorkingColorSpace_ToAP0[0].y), _1519, ((WorkingColorSpace_ToAP0[0].x) * _1518)));
        float _1526 = mad((WorkingColorSpace_ToAP0[1].z), _1520, mad((WorkingColorSpace_ToAP0[1].y), _1519, ((WorkingColorSpace_ToAP0[1].x) * _1518)));
        float _1529 = mad((WorkingColorSpace_ToAP0[2].z), _1520, mad((WorkingColorSpace_ToAP0[2].y), _1519, ((WorkingColorSpace_ToAP0[2].x) * _1518)));
        float _1533 = max(max(_1523, _1526), _1529);
        float _1538 = (max(_1533, 1.000000013351432e-10f) - max(min(min(_1523, _1526), _1529), 1.000000013351432e-10f)) / max(_1533, 0.009999999776482582f);
        float _1551 = ((_1526 + _1523) + _1529) + (sqrt((((_1529 - _1526) * _1529) + ((_1526 - _1523) * _1526)) + ((_1523 - _1529) * _1523)) * 1.75f);
        float _1552 = _1551 * 0.3333333432674408f;
        float _1553 = _1538 + -0.4000000059604645f;
        float _1554 = _1553 * 5.0f;
        float _1558 = max((1.0f - abs(_1553 * 2.5f)), 0.0f);
        float _1569 = ((float((int)(((int)(uint)((bool)(_1554 > 0.0f))) - ((int)(uint)((bool)(_1554 < 0.0f))))) * (1.0f - (_1558 * _1558))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1552 <= 0.0533333346247673f)) {
            if (!(_1552 >= 0.1599999964237213f)) {
              _1578 = (((0.23999999463558197f / _1551) + -0.5f) * _1569);
            } else {
              _1578 = 0.0f;
            }
          } else {
            _1578 = _1569;
          }
          float _1579 = _1578 + 1.0f;
          float _1580 = _1579 * _1523;
          float _1581 = _1579 * _1526;
          float _1582 = _1579 * _1529;
          do {
            if (!((bool)(_1580 == _1581) && (bool)(_1581 == _1582))) {
              float _1589 = ((_1580 * 2.0f) - _1581) - _1582;
              float _1592 = ((_1526 - _1529) * 1.7320507764816284f) * _1579;
              float _1594 = atan(_1592 / _1589);
              bool _1597 = (_1589 < 0.0f);
              bool _1598 = (_1589 == 0.0f);
              bool _1599 = (_1592 >= 0.0f);
              bool _1600 = (_1592 < 0.0f);
              _1611 = select((_1599 && _1598), 90.0f, select((_1600 && _1598), -90.0f, (select((_1600 && _1597), (_1594 + -3.1415927410125732f), select((_1599 && _1597), (_1594 + 3.1415927410125732f), _1594)) * 57.2957763671875f)));
            } else {
              _1611 = 0.0f;
            }
            float _1616 = min(max(select((_1611 < 0.0f), (_1611 + 360.0f), _1611), 0.0f), 360.0f);
            do {
              if (_1616 < -180.0f) {
                _1625 = (_1616 + 360.0f);
              } else {
                if (_1616 > 180.0f) {
                  _1625 = (_1616 + -360.0f);
                } else {
                  _1625 = _1616;
                }
              }
              do {
                if ((bool)(_1625 > -67.5f) && (bool)(_1625 < 67.5f)) {
                  float _1631 = (_1625 + 67.5f) * 0.029629629105329514f;
                  int _1632 = int(_1631);
                  float _1634 = _1631 - float((int)(_1632));
                  float _1635 = _1634 * _1634;
                  float _1636 = _1635 * _1634;
                  if (_1632 == 3) {
                    _1664 = (((0.1666666716337204f - (_1634 * 0.5f)) + (_1635 * 0.5f)) - (_1636 * 0.1666666716337204f));
                  } else {
                    if (_1632 == 2) {
                      _1664 = ((0.6666666865348816f - _1635) + (_1636 * 0.5f));
                    } else {
                      if (_1632 == 1) {
                        _1664 = (((_1636 * -0.5f) + 0.1666666716337204f) + ((_1635 + _1634) * 0.5f));
                      } else {
                        _1664 = select((_1632 == 0), (_1636 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1664 = 0.0f;
                }
                float _1673 = min(max(((((_1538 * 0.27000001072883606f) * (0.029999999329447746f - _1580)) * _1664) + _1580), 0.0f), 65535.0f);
                float _1674 = min(max(_1581, 0.0f), 65535.0f);
                float _1675 = min(max(_1582, 0.0f), 65535.0f);
                float _1688 = min(max(mad(-0.21492856740951538f, _1675, mad(-0.2365107536315918f, _1674, (_1673 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1689 = min(max(mad(-0.09967592358589172f, _1675, mad(1.17622971534729f, _1674, (_1673 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1690 = min(max(mad(0.9977163076400757f, _1675, mad(-0.006032449658960104f, _1674, (_1673 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1691 = dot(float3(_1688, _1689, _1690), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1702 = log2(max((lerp(_1691, _1688, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1703 = _1702 * 0.3010300099849701f;
                float _1704 = log2(ACESMinMaxData.x);
                float _1705 = _1704 * 0.3010300099849701f;
                do {
                  if (!(!(_1703 <= _1705))) {
                    _1774 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _1712 = log2(ACESMidData.x);
                    float _1713 = _1712 * 0.3010300099849701f;
                    if ((bool)(_1703 > _1705) && (bool)(_1703 < _1713)) {
                      float _1721 = ((_1702 - _1704) * 0.9030900001525879f) / ((_1712 - _1704) * 0.3010300099849701f);
                      int _1722 = int(_1721);
                      float _1724 = _1721 - float((int)(_1722));
                      float _1726 = _12[_1722];
                      float _1729 = _12[(_1722 + 1)];
                      float _1734 = _1726 * 0.5f;
                      _1774 = dot(float3((_1724 * _1724), _1724, 1.0f), float3(mad((_12[(_1722 + 2)]), 0.5f, mad(_1729, -1.0f, _1734)), (_1729 - _1726), mad(_1729, 0.5f, _1734)));
                    } else {
                      do {
                        if (!(!(_1703 >= _1713))) {
                          float _1743 = log2(ACESMinMaxData.z);
                          if (_1703 < (_1743 * 0.3010300099849701f)) {
                            float _1751 = ((_1702 - _1712) * 0.9030900001525879f) / ((_1743 - _1712) * 0.3010300099849701f);
                            int _1752 = int(_1751);
                            float _1754 = _1751 - float((int)(_1752));
                            float _1756 = _13[_1752];
                            float _1759 = _13[(_1752 + 1)];
                            float _1764 = _1756 * 0.5f;
                            _1774 = dot(float3((_1754 * _1754), _1754, 1.0f), float3(mad((_13[(_1752 + 2)]), 0.5f, mad(_1759, -1.0f, _1764)), (_1759 - _1756), mad(_1759, 0.5f, _1764)));
                            break;
                          }
                        }
                        _1774 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1778 = log2(max((lerp(_1691, _1689, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1779 = _1778 * 0.3010300099849701f;
                  do {
                    if (!(!(_1779 <= _1705))) {
                      _1848 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1786 = log2(ACESMidData.x);
                      float _1787 = _1786 * 0.3010300099849701f;
                      if ((bool)(_1779 > _1705) && (bool)(_1779 < _1787)) {
                        float _1795 = ((_1778 - _1704) * 0.9030900001525879f) / ((_1786 - _1704) * 0.3010300099849701f);
                        int _1796 = int(_1795);
                        float _1798 = _1795 - float((int)(_1796));
                        float _1800 = _12[_1796];
                        float _1803 = _12[(_1796 + 1)];
                        float _1808 = _1800 * 0.5f;
                        _1848 = dot(float3((_1798 * _1798), _1798, 1.0f), float3(mad((_12[(_1796 + 2)]), 0.5f, mad(_1803, -1.0f, _1808)), (_1803 - _1800), mad(_1803, 0.5f, _1808)));
                      } else {
                        do {
                          if (!(!(_1779 >= _1787))) {
                            float _1817 = log2(ACESMinMaxData.z);
                            if (_1779 < (_1817 * 0.3010300099849701f)) {
                              float _1825 = ((_1778 - _1786) * 0.9030900001525879f) / ((_1817 - _1786) * 0.3010300099849701f);
                              int _1826 = int(_1825);
                              float _1828 = _1825 - float((int)(_1826));
                              float _1830 = _13[_1826];
                              float _1833 = _13[(_1826 + 1)];
                              float _1838 = _1830 * 0.5f;
                              _1848 = dot(float3((_1828 * _1828), _1828, 1.0f), float3(mad((_13[(_1826 + 2)]), 0.5f, mad(_1833, -1.0f, _1838)), (_1833 - _1830), mad(_1833, 0.5f, _1838)));
                              break;
                            }
                          }
                          _1848 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1852 = log2(max((lerp(_1691, _1690, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1853 = _1852 * 0.3010300099849701f;
                    do {
                      if (!(!(_1853 <= _1705))) {
                        _1922 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1860 = log2(ACESMidData.x);
                        float _1861 = _1860 * 0.3010300099849701f;
                        if ((bool)(_1853 > _1705) && (bool)(_1853 < _1861)) {
                          float _1869 = ((_1852 - _1704) * 0.9030900001525879f) / ((_1860 - _1704) * 0.3010300099849701f);
                          int _1870 = int(_1869);
                          float _1872 = _1869 - float((int)(_1870));
                          float _1874 = _12[_1870];
                          float _1877 = _12[(_1870 + 1)];
                          float _1882 = _1874 * 0.5f;
                          _1922 = dot(float3((_1872 * _1872), _1872, 1.0f), float3(mad((_12[(_1870 + 2)]), 0.5f, mad(_1877, -1.0f, _1882)), (_1877 - _1874), mad(_1877, 0.5f, _1882)));
                        } else {
                          do {
                            if (!(!(_1853 >= _1861))) {
                              float _1891 = log2(ACESMinMaxData.z);
                              if (_1853 < (_1891 * 0.3010300099849701f)) {
                                float _1899 = ((_1852 - _1860) * 0.9030900001525879f) / ((_1891 - _1860) * 0.3010300099849701f);
                                int _1900 = int(_1899);
                                float _1902 = _1899 - float((int)(_1900));
                                float _1904 = _13[_1900];
                                float _1907 = _13[(_1900 + 1)];
                                float _1912 = _1904 * 0.5f;
                                _1922 = dot(float3((_1902 * _1902), _1902, 1.0f), float3(mad((_13[(_1900 + 2)]), 0.5f, mad(_1907, -1.0f, _1912)), (_1907 - _1904), mad(_1907, 0.5f, _1912)));
                                break;
                              }
                            }
                            _1922 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1926 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _1927 = (exp2(_1774 * 3.321928024291992f) - ACESMinMaxData.y) / _1926;
                      float _1929 = (exp2(_1848 * 3.321928024291992f) - ACESMinMaxData.y) / _1926;
                      float _1931 = (exp2(_1922 * 3.321928024291992f) - ACESMinMaxData.y) / _1926;
                      float _1934 = mad(0.15618768334388733f, _1931, mad(0.13400420546531677f, _1929, (_1927 * 0.6624541878700256f)));
                      float _1937 = mad(0.053689517080783844f, _1931, mad(0.6740817427635193f, _1929, (_1927 * 0.2722287178039551f)));
                      float _1940 = mad(1.0103391408920288f, _1931, mad(0.00406073359772563f, _1929, (_1927 * -0.005574649665504694f)));
                      float _1953 = min(max(mad(-0.23642469942569733f, _1940, mad(-0.32480329275131226f, _1937, (_1934 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1954 = min(max(mad(0.016756348311901093f, _1940, mad(1.6153316497802734f, _1937, (_1934 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1955 = min(max(mad(0.9883948564529419f, _1940, mad(-0.008284442126750946f, _1937, (_1934 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1958 = mad(0.15618768334388733f, _1955, mad(0.13400420546531677f, _1954, (_1953 * 0.6624541878700256f)));
                      float _1961 = mad(0.053689517080783844f, _1955, mad(0.6740817427635193f, _1954, (_1953 * 0.2722287178039551f)));
                      float _1964 = mad(1.0103391408920288f, _1955, mad(0.00406073359772563f, _1954, (_1953 * -0.005574649665504694f)));
                      float _1986 = min(max((min(max(mad(-0.23642469942569733f, _1964, mad(-0.32480329275131226f, _1961, (_1958 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1987 = min(max((min(max(mad(0.016756348311901093f, _1964, mad(1.6153316497802734f, _1961, (_1958 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _1988 = min(max((min(max(mad(0.9883948564529419f, _1964, mad(-0.008284442126750946f, _1961, (_1958 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!(OutputDevice == 5)) {
                          _2001 = mad(_47, _1988, mad(_46, _1987, (_1986 * _45)));
                          _2002 = mad(_50, _1988, mad(_49, _1987, (_1986 * _48)));
                          _2003 = mad(_53, _1988, mad(_52, _1987, (_1986 * _51)));
                        } else {
                          _2001 = _1986;
                          _2002 = _1987;
                          _2003 = _1988;
                        }
                        float _2013 = exp2(log2(_2001 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2014 = exp2(log2(_2002 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2015 = exp2(log2(_2003 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2754 = exp2(log2((1.0f / ((_2013 * 18.6875f) + 1.0f)) * ((_2013 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2755 = exp2(log2((1.0f / ((_2014 * 18.6875f) + 1.0f)) * ((_2014 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2756 = exp2(log2((1.0f / ((_2015 * 18.6875f) + 1.0f)) * ((_2015 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2092 = ACESSceneColorMultiplier * _1318;
          float _2093 = ACESSceneColorMultiplier * _1319;
          float _2094 = ACESSceneColorMultiplier * _1320;
          float _2097 = mad((WorkingColorSpace_ToAP0[0].z), _2094, mad((WorkingColorSpace_ToAP0[0].y), _2093, ((WorkingColorSpace_ToAP0[0].x) * _2092)));
          float _2100 = mad((WorkingColorSpace_ToAP0[1].z), _2094, mad((WorkingColorSpace_ToAP0[1].y), _2093, ((WorkingColorSpace_ToAP0[1].x) * _2092)));
          float _2103 = mad((WorkingColorSpace_ToAP0[2].z), _2094, mad((WorkingColorSpace_ToAP0[2].y), _2093, ((WorkingColorSpace_ToAP0[2].x) * _2092)));
          float _2107 = max(max(_2097, _2100), _2103);
          float _2112 = (max(_2107, 1.000000013351432e-10f) - max(min(min(_2097, _2100), _2103), 1.000000013351432e-10f)) / max(_2107, 0.009999999776482582f);
          float _2125 = ((_2100 + _2097) + _2103) + (sqrt((((_2103 - _2100) * _2103) + ((_2100 - _2097) * _2100)) + ((_2097 - _2103) * _2097)) * 1.75f);
          float _2126 = _2125 * 0.3333333432674408f;
          float _2127 = _2112 + -0.4000000059604645f;
          float _2128 = _2127 * 5.0f;
          float _2132 = max((1.0f - abs(_2127 * 2.5f)), 0.0f);
          float _2143 = ((float((int)(((int)(uint)((bool)(_2128 > 0.0f))) - ((int)(uint)((bool)(_2128 < 0.0f))))) * (1.0f - (_2132 * _2132))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2126 <= 0.0533333346247673f)) {
              if (!(_2126 >= 0.1599999964237213f)) {
                _2152 = (((0.23999999463558197f / _2125) + -0.5f) * _2143);
              } else {
                _2152 = 0.0f;
              }
            } else {
              _2152 = _2143;
            }
            float _2153 = _2152 + 1.0f;
            float _2154 = _2153 * _2097;
            float _2155 = _2153 * _2100;
            float _2156 = _2153 * _2103;
            do {
              if (!((bool)(_2154 == _2155) && (bool)(_2155 == _2156))) {
                float _2163 = ((_2154 * 2.0f) - _2155) - _2156;
                float _2166 = ((_2100 - _2103) * 1.7320507764816284f) * _2153;
                float _2168 = atan(_2166 / _2163);
                bool _2171 = (_2163 < 0.0f);
                bool _2172 = (_2163 == 0.0f);
                bool _2173 = (_2166 >= 0.0f);
                bool _2174 = (_2166 < 0.0f);
                _2185 = select((_2173 && _2172), 90.0f, select((_2174 && _2172), -90.0f, (select((_2174 && _2171), (_2168 + -3.1415927410125732f), select((_2173 && _2171), (_2168 + 3.1415927410125732f), _2168)) * 57.2957763671875f)));
              } else {
                _2185 = 0.0f;
              }
              float _2190 = min(max(select((_2185 < 0.0f), (_2185 + 360.0f), _2185), 0.0f), 360.0f);
              do {
                if (_2190 < -180.0f) {
                  _2199 = (_2190 + 360.0f);
                } else {
                  if (_2190 > 180.0f) {
                    _2199 = (_2190 + -360.0f);
                  } else {
                    _2199 = _2190;
                  }
                }
                do {
                  if ((bool)(_2199 > -67.5f) && (bool)(_2199 < 67.5f)) {
                    float _2205 = (_2199 + 67.5f) * 0.029629629105329514f;
                    int _2206 = int(_2205);
                    float _2208 = _2205 - float((int)(_2206));
                    float _2209 = _2208 * _2208;
                    float _2210 = _2209 * _2208;
                    if (_2206 == 3) {
                      _2238 = (((0.1666666716337204f - (_2208 * 0.5f)) + (_2209 * 0.5f)) - (_2210 * 0.1666666716337204f));
                    } else {
                      if (_2206 == 2) {
                        _2238 = ((0.6666666865348816f - _2209) + (_2210 * 0.5f));
                      } else {
                        if (_2206 == 1) {
                          _2238 = (((_2210 * -0.5f) + 0.1666666716337204f) + ((_2209 + _2208) * 0.5f));
                        } else {
                          _2238 = select((_2206 == 0), (_2210 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2238 = 0.0f;
                  }
                  float _2247 = min(max(((((_2112 * 0.27000001072883606f) * (0.029999999329447746f - _2154)) * _2238) + _2154), 0.0f), 65535.0f);
                  float _2248 = min(max(_2155, 0.0f), 65535.0f);
                  float _2249 = min(max(_2156, 0.0f), 65535.0f);
                  float _2262 = min(max(mad(-0.21492856740951538f, _2249, mad(-0.2365107536315918f, _2248, (_2247 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2263 = min(max(mad(-0.09967592358589172f, _2249, mad(1.17622971534729f, _2248, (_2247 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2264 = min(max(mad(0.9977163076400757f, _2249, mad(-0.006032449658960104f, _2248, (_2247 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2265 = dot(float3(_2262, _2263, _2264), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2276 = log2(max((lerp(_2265, _2262, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2277 = _2276 * 0.3010300099849701f;
                  float _2278 = log2(ACESMinMaxData.x);
                  float _2279 = _2278 * 0.3010300099849701f;
                  do {
                    if (!(!(_2277 <= _2279))) {
                      _2348 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2286 = log2(ACESMidData.x);
                      float _2287 = _2286 * 0.3010300099849701f;
                      if ((bool)(_2277 > _2279) && (bool)(_2277 < _2287)) {
                        float _2295 = ((_2276 - _2278) * 0.9030900001525879f) / ((_2286 - _2278) * 0.3010300099849701f);
                        int _2296 = int(_2295);
                        float _2298 = _2295 - float((int)(_2296));
                        float _2300 = _10[_2296];
                        float _2303 = _10[(_2296 + 1)];
                        float _2308 = _2300 * 0.5f;
                        _2348 = dot(float3((_2298 * _2298), _2298, 1.0f), float3(mad((_10[(_2296 + 2)]), 0.5f, mad(_2303, -1.0f, _2308)), (_2303 - _2300), mad(_2303, 0.5f, _2308)));
                      } else {
                        do {
                          if (!(!(_2277 >= _2287))) {
                            float _2317 = log2(ACESMinMaxData.z);
                            if (_2277 < (_2317 * 0.3010300099849701f)) {
                              float _2325 = ((_2276 - _2286) * 0.9030900001525879f) / ((_2317 - _2286) * 0.3010300099849701f);
                              int _2326 = int(_2325);
                              float _2328 = _2325 - float((int)(_2326));
                              float _2330 = _11[_2326];
                              float _2333 = _11[(_2326 + 1)];
                              float _2338 = _2330 * 0.5f;
                              _2348 = dot(float3((_2328 * _2328), _2328, 1.0f), float3(mad((_11[(_2326 + 2)]), 0.5f, mad(_2333, -1.0f, _2338)), (_2333 - _2330), mad(_2333, 0.5f, _2338)));
                              break;
                            }
                          }
                          _2348 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2352 = log2(max((lerp(_2265, _2263, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2353 = _2352 * 0.3010300099849701f;
                    do {
                      if (!(!(_2353 <= _2279))) {
                        _2422 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2360 = log2(ACESMidData.x);
                        float _2361 = _2360 * 0.3010300099849701f;
                        if ((bool)(_2353 > _2279) && (bool)(_2353 < _2361)) {
                          float _2369 = ((_2352 - _2278) * 0.9030900001525879f) / ((_2360 - _2278) * 0.3010300099849701f);
                          int _2370 = int(_2369);
                          float _2372 = _2369 - float((int)(_2370));
                          float _2374 = _10[_2370];
                          float _2377 = _10[(_2370 + 1)];
                          float _2382 = _2374 * 0.5f;
                          _2422 = dot(float3((_2372 * _2372), _2372, 1.0f), float3(mad((_10[(_2370 + 2)]), 0.5f, mad(_2377, -1.0f, _2382)), (_2377 - _2374), mad(_2377, 0.5f, _2382)));
                        } else {
                          do {
                            if (!(!(_2353 >= _2361))) {
                              float _2391 = log2(ACESMinMaxData.z);
                              if (_2353 < (_2391 * 0.3010300099849701f)) {
                                float _2399 = ((_2352 - _2360) * 0.9030900001525879f) / ((_2391 - _2360) * 0.3010300099849701f);
                                int _2400 = int(_2399);
                                float _2402 = _2399 - float((int)(_2400));
                                float _2404 = _11[_2400];
                                float _2407 = _11[(_2400 + 1)];
                                float _2412 = _2404 * 0.5f;
                                _2422 = dot(float3((_2402 * _2402), _2402, 1.0f), float3(mad((_11[(_2400 + 2)]), 0.5f, mad(_2407, -1.0f, _2412)), (_2407 - _2404), mad(_2407, 0.5f, _2412)));
                                break;
                              }
                            }
                            _2422 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2426 = log2(max((lerp(_2265, _2264, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2427 = _2426 * 0.3010300099849701f;
                      do {
                        if (!(!(_2427 <= _2279))) {
                          _2496 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2434 = log2(ACESMidData.x);
                          float _2435 = _2434 * 0.3010300099849701f;
                          if ((bool)(_2427 > _2279) && (bool)(_2427 < _2435)) {
                            float _2443 = ((_2426 - _2278) * 0.9030900001525879f) / ((_2434 - _2278) * 0.3010300099849701f);
                            int _2444 = int(_2443);
                            float _2446 = _2443 - float((int)(_2444));
                            float _2448 = _10[_2444];
                            float _2451 = _10[(_2444 + 1)];
                            float _2456 = _2448 * 0.5f;
                            _2496 = dot(float3((_2446 * _2446), _2446, 1.0f), float3(mad((_10[(_2444 + 2)]), 0.5f, mad(_2451, -1.0f, _2456)), (_2451 - _2448), mad(_2451, 0.5f, _2456)));
                          } else {
                            do {
                              if (!(!(_2427 >= _2435))) {
                                float _2465 = log2(ACESMinMaxData.z);
                                if (_2427 < (_2465 * 0.3010300099849701f)) {
                                  float _2473 = ((_2426 - _2434) * 0.9030900001525879f) / ((_2465 - _2434) * 0.3010300099849701f);
                                  int _2474 = int(_2473);
                                  float _2476 = _2473 - float((int)(_2474));
                                  float _2478 = _11[_2474];
                                  float _2481 = _11[(_2474 + 1)];
                                  float _2486 = _2478 * 0.5f;
                                  _2496 = dot(float3((_2476 * _2476), _2476, 1.0f), float3(mad((_11[(_2474 + 2)]), 0.5f, mad(_2481, -1.0f, _2486)), (_2481 - _2478), mad(_2481, 0.5f, _2486)));
                                  break;
                                }
                              }
                              _2496 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2500 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2501 = (exp2(_2348 * 3.321928024291992f) - ACESMinMaxData.y) / _2500;
                        float _2503 = (exp2(_2422 * 3.321928024291992f) - ACESMinMaxData.y) / _2500;
                        float _2505 = (exp2(_2496 * 3.321928024291992f) - ACESMinMaxData.y) / _2500;
                        float _2508 = mad(0.15618768334388733f, _2505, mad(0.13400420546531677f, _2503, (_2501 * 0.6624541878700256f)));
                        float _2511 = mad(0.053689517080783844f, _2505, mad(0.6740817427635193f, _2503, (_2501 * 0.2722287178039551f)));
                        float _2514 = mad(1.0103391408920288f, _2505, mad(0.00406073359772563f, _2503, (_2501 * -0.005574649665504694f)));
                        float _2527 = min(max(mad(-0.23642469942569733f, _2514, mad(-0.32480329275131226f, _2511, (_2508 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2528 = min(max(mad(0.016756348311901093f, _2514, mad(1.6153316497802734f, _2511, (_2508 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2529 = min(max(mad(0.9883948564529419f, _2514, mad(-0.008284442126750946f, _2511, (_2508 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2532 = mad(0.15618768334388733f, _2529, mad(0.13400420546531677f, _2528, (_2527 * 0.6624541878700256f)));
                        float _2535 = mad(0.053689517080783844f, _2529, mad(0.6740817427635193f, _2528, (_2527 * 0.2722287178039551f)));
                        float _2538 = mad(1.0103391408920288f, _2529, mad(0.00406073359772563f, _2528, (_2527 * -0.005574649665504694f)));
                        float _2560 = min(max((min(max(mad(-0.23642469942569733f, _2538, mad(-0.32480329275131226f, _2535, (_2532 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2561 = min(max((min(max(mad(0.016756348311901093f, _2538, mad(1.6153316497802734f, _2535, (_2532 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2562 = min(max((min(max(mad(0.9883948564529419f, _2538, mad(-0.008284442126750946f, _2535, (_2532 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 6)) {
                            _2575 = mad(_47, _2562, mad(_46, _2561, (_2560 * _45)));
                            _2576 = mad(_50, _2562, mad(_49, _2561, (_2560 * _48)));
                            _2577 = mad(_53, _2562, mad(_52, _2561, (_2560 * _51)));
                          } else {
                            _2575 = _2560;
                            _2576 = _2561;
                            _2577 = _2562;
                          }
                          float _2587 = exp2(log2(_2575 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2588 = exp2(log2(_2576 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2589 = exp2(log2(_2577 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2754 = exp2(log2((1.0f / ((_2587 * 18.6875f) + 1.0f)) * ((_2587 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2755 = exp2(log2((1.0f / ((_2588 * 18.6875f) + 1.0f)) * ((_2588 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2756 = exp2(log2((1.0f / ((_2589 * 18.6875f) + 1.0f)) * ((_2589 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2634 = mad((WorkingColorSpace_ToAP1[0].z), _1320, mad((WorkingColorSpace_ToAP1[0].y), _1319, ((WorkingColorSpace_ToAP1[0].x) * _1318)));
            float _2637 = mad((WorkingColorSpace_ToAP1[1].z), _1320, mad((WorkingColorSpace_ToAP1[1].y), _1319, ((WorkingColorSpace_ToAP1[1].x) * _1318)));
            float _2640 = mad((WorkingColorSpace_ToAP1[2].z), _1320, mad((WorkingColorSpace_ToAP1[2].y), _1319, ((WorkingColorSpace_ToAP1[2].x) * _1318)));
            float _2659 = exp2(log2(mad(_47, _2640, mad(_46, _2637, (_2634 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2660 = exp2(log2(mad(_50, _2640, mad(_49, _2637, (_2634 * _48))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2661 = exp2(log2(mad(_53, _2640, mad(_52, _2637, (_2634 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2754 = exp2(log2((1.0f / ((_2659 * 18.6875f) + 1.0f)) * ((_2659 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2755 = exp2(log2((1.0f / ((_2660 * 18.6875f) + 1.0f)) * ((_2660 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2756 = exp2(log2((1.0f / ((_2661 * 18.6875f) + 1.0f)) * ((_2661 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2708 = mad((WorkingColorSpace_ToAP1[0].z), _1308, mad((WorkingColorSpace_ToAP1[0].y), _1307, ((WorkingColorSpace_ToAP1[0].x) * _1306)));
                float _2711 = mad((WorkingColorSpace_ToAP1[1].z), _1308, mad((WorkingColorSpace_ToAP1[1].y), _1307, ((WorkingColorSpace_ToAP1[1].x) * _1306)));
                float _2714 = mad((WorkingColorSpace_ToAP1[2].z), _1308, mad((WorkingColorSpace_ToAP1[2].y), _1307, ((WorkingColorSpace_ToAP1[2].x) * _1306)));
                _2754 = mad(_47, _2714, mad(_46, _2711, (_2708 * _45)));
                _2755 = mad(_50, _2714, mad(_49, _2711, (_2708 * _48)));
                _2756 = mad(_53, _2714, mad(_52, _2711, (_2708 * _51)));
              } else {
                float _2727 = mad((WorkingColorSpace_ToAP1[0].z), _1334, mad((WorkingColorSpace_ToAP1[0].y), _1333, ((WorkingColorSpace_ToAP1[0].x) * _1332)));
                float _2730 = mad((WorkingColorSpace_ToAP1[1].z), _1334, mad((WorkingColorSpace_ToAP1[1].y), _1333, ((WorkingColorSpace_ToAP1[1].x) * _1332)));
                float _2733 = mad((WorkingColorSpace_ToAP1[2].z), _1334, mad((WorkingColorSpace_ToAP1[2].y), _1333, ((WorkingColorSpace_ToAP1[2].x) * _1332)));
                _2754 = exp2(log2(mad(_47, _2733, mad(_46, _2730, (_2727 * _45)))) * InverseGamma.z);
                _2755 = exp2(log2(mad(_50, _2733, mad(_49, _2730, (_2727 * _48)))) * InverseGamma.z);
                _2756 = exp2(log2(mad(_53, _2733, mad(_52, _2730, (_2727 * _51)))) * InverseGamma.z);
              }
            } else {
              _2754 = _1318;
              _2755 = _1319;
              _2756 = _1320;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2754 * 0.9523810148239136f);
  SV_Target.y = (_2755 * 0.9523810148239136f);
  SV_Target.z = (_2756 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

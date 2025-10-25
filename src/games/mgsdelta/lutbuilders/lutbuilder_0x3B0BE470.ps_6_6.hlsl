#include "./filmiclutbuilder.hlsl"

cbuffer UniformBufferConstants_WorkingColorSpace : register(b1) {
  float4 WorkingColorSpace_ToXYZ[4] : packoffset(c000.x);
  float4 WorkingColorSpace_FromXYZ[4] : packoffset(c004.x);
  float4 WorkingColorSpace_ToAP1[4] : packoffset(c008.x);
  float4 WorkingColorSpace_FromAP1[4] : packoffset(c012.x);
  float4 WorkingColorSpace_ToAP0[4] : packoffset(c016.x);
  uint WorkingColorSpace_bIsSRGB : packoffset(c020.x);
};

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex
) : SV_Target {
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;
  bool is_hdr = (output_device >= 3u && output_device <= 6u);

  float4 SV_Target;
  float _8[6];
  float _9[6];
  float _10[6];
  float _11[6];
  float _14 = 0.5f / LUTSize;
  float _19 = LUTSize + -1.0f;
  float _20 = (LUTSize * (TEXCOORD.x - _14)) / _19;
  float _21 = (LUTSize * (TEXCOORD.y - _14)) / _19;
  float _23 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _19;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _109;
  float _110;
  float _111;
  float _112;
  float _113;
  float _114;
  float _539;
  float _714;
  float _806;
  float _839;
  float _853;
  float _917;
  float _1168;
  float _1201;
  float _1215;
  float _1386;
  float _1419;
  float _1433;
  float _1484;
  float _1764;
  float _1765;
  float _1766;
  float _1777;
  float _1788;
  float _1956;
  float _1989;
  float _2003;
  float _2042;
  float _2152;
  float _2226;
  float _2300;
  float _2405;
  float _2406;
  float _2407;
  float _2418;
  float _2419;
  float _2420;
  float _2569;
  float _2602;
  float _2616;
  float _2655;
  float _2765;
  float _2839;
  float _2913;
  float _3018;
  float _3019;
  float _3020;
  float _3031;
  float _3032;
  float _3033;
  float _3186;
  float _3187;
  float _3188;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _32 = (OutputGamut == 4);
        _43 = select(_32, 1.0f, 1.705051064491272f);
        _44 = select(_32, 0.0f, -0.6217921376228333f);
        _45 = select(_32, 0.0f, -0.0832589864730835f);
        _46 = select(_32, 0.0f, -0.13025647401809692f);
        _47 = select(_32, 1.0f, 1.140804648399353f);
        _48 = select(_32, 0.0f, -0.010548308491706848f);
        _49 = select(_32, 0.0f, -0.024003351107239723f);
        _50 = select(_32, 0.0f, -0.1289689838886261f);
        _51 = select(_32, 1.0f, 1.1529725790023804f);
      } else {
        _43 = 0.6954522132873535f;
        _44 = 0.14067870378494263f;
        _45 = 0.16386906802654266f;
        _46 = 0.044794563204050064f;
        _47 = 0.8596711158752441f;
        _48 = 0.0955343171954155f;
        _49 = -0.005525882821530104f;
        _50 = 0.004025210160762072f;
        _51 = 1.0015007257461548f;
      }
    } else {
      _43 = 1.0258246660232544f;
      _44 = -0.020053181797266006f;
      _45 = -0.005771636962890625f;
      _46 = -0.002234415616840124f;
      _47 = 1.0045864582061768f;
      _48 = -0.002352118492126465f;
      _49 = -0.005013350863009691f;
      _50 = -0.025290070101618767f;
      _51 = 1.0303035974502563f;
    }
  } else {
    _43 = 1.3792141675949097f;
    _44 = -0.30886411666870117f;
    _45 = -0.0703500509262085f;
    _46 = -0.06933490186929703f;
    _47 = 1.08229660987854f;
    _48 = -0.012961871922016144f;
    _49 = -0.0021590073592960835f;
    _50 = -0.0454593189060688f;
    _51 = 1.0476183891296387f;
  }
  if ((uint)OutputDevice > (uint)2) {
    float _62 = (pow(_20, 0.012683313339948654f));
    float _63 = (pow(_21, 0.012683313339948654f));
    float _64 = (pow(_23, 0.012683313339948654f));
    float _89 = exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 100.0f;
    float _90 = exp2(log2(max(0.0f, (_63 + -0.8359375f)) / (18.8515625f - (_63 * 18.6875f))) * 6.277394771575928f) * 100.0f;
    float _91 = exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 100.0f;
    _109 = _89;
    _110 = _90;
    _111 = _91;
    _112 = _89;
    _113 = _90;
    _114 = _91;
  } else {
    _109 = ((exp2((_20 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _110 = ((exp2((_21 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _111 = ((exp2((_23 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _112 = 0.0f;
    _113 = 0.0f;
    _114 = 0.0f;
  }

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  float _129 = mad((WorkingColorSpace_ToAP1[0].z), _111, mad((WorkingColorSpace_ToAP1[0].y), _110, ((WorkingColorSpace_ToAP1[0].x) * _109)));
  float _132 = mad((WorkingColorSpace_ToAP1[1].z), _111, mad((WorkingColorSpace_ToAP1[1].y), _110, ((WorkingColorSpace_ToAP1[1].x) * _109)));
  float _135 = mad((WorkingColorSpace_ToAP1[2].z), _111, mad((WorkingColorSpace_ToAP1[2].y), _110, ((WorkingColorSpace_ToAP1[2].x) * _109)));
  float _136 = dot(float3(_129, _132, _135), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _140 = (_129 / _136) + -1.0f;
  float _141 = (_132 / _136) + -1.0f;
  float _142 = (_135 / _136) + -1.0f;
  float _154 = (1.0f - exp2(((_136 * _136) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_140, _141, _142), float3(_140, _141, _142)) * -4.0f));
  float _170 = ((mad(-0.06368321925401688f, _135, mad(-0.3292922377586365f, _132, (_129 * 1.3704125881195068f))) - _129) * _154) + _129;
  float _171 = ((mad(-0.010861365124583244f, _135, mad(1.0970927476882935f, _132, (_129 * -0.08343357592821121f))) - _132) * _154) + _132;
  float _172 = ((mad(1.2036951780319214f, _135, mad(-0.09862580895423889f, _132, (_129 * -0.02579331398010254f))) - _135) * _154) + _135;
  float _173 = dot(float3(_170, _171, _172), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _187 = ColorOffset.w + ColorOffsetShadows.w;
  float _201 = ColorGain.w * ColorGainShadows.w;
  float _215 = ColorGamma.w * ColorGammaShadows.w;
  float _229 = ColorContrast.w * ColorContrastShadows.w;
  float _243 = ColorSaturation.w * ColorSaturationShadows.w;
  float _244 = (ColorSaturation.x * ColorSaturationShadows.x) * _243;
  float _245 = (ColorSaturation.y * ColorSaturationShadows.y) * _243;
  float _246 = (ColorSaturation.z * ColorSaturationShadows.z) * _243;
  float _247 = _170 - _173;
  float _248 = _171 - _173;
  float _249 = _172 - _173;
  float _259 = (ColorContrast.x * ColorContrastShadows.x) * _229;
  float _260 = (ColorContrast.y * ColorContrastShadows.y) * _229;
  float _261 = (ColorContrast.z * ColorContrastShadows.z) * _229;
  float _280 = 1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _215);
  float _281 = 1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _215);
  float _282 = 1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _215);
  float _292 = (ColorGain.x * ColorGainShadows.x) * _201;
  float _293 = (ColorGain.y * ColorGainShadows.y) * _201;
  float _294 = (ColorGain.z * ColorGainShadows.z) * _201;
  float _298 = (ColorOffset.x + ColorOffsetShadows.x) + _187;
  float _299 = (ColorOffset.y + ColorOffsetShadows.y) + _187;
  float _300 = (ColorOffset.z + ColorOffsetShadows.z) + _187;
  float _301 = _298 + (_292 * exp2(log2(exp2(_259 * log2(max(0.0f, ((_244 * _247) + _173)) * 5.55555534362793f)) * 0.18000000715255737f) * _280));
  float _302 = _299 + (_293 * exp2(log2(exp2(_260 * log2(max(0.0f, ((_245 * _248) + _173)) * 5.55555534362793f)) * 0.18000000715255737f) * _281));
  float _303 = _300 + (_294 * exp2(log2(exp2(_261 * log2(max(0.0f, ((_246 * _249) + _173)) * 5.55555534362793f)) * 0.18000000715255737f) * _282));
  float _306 = saturate(_173 / ColorCorrectionShadowsMax);
  float _310 = (_306 * _306) * (3.0f - (_306 * 2.0f));
  float _311 = 1.0f - _310;
  float _320 = ColorOffset.w + ColorOffsetHighlights.w;
  float _329 = ColorGain.w * ColorGainHighlights.w;
  float _338 = ColorGamma.w * ColorGammaHighlights.w;
  float _347 = ColorContrast.w * ColorContrastHighlights.w;
  float _356 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _357 = (ColorSaturation.x * ColorSaturationHighlights.x) * _356;
  float _358 = (ColorSaturation.y * ColorSaturationHighlights.y) * _356;
  float _359 = (ColorSaturation.z * ColorSaturationHighlights.z) * _356;
  float _369 = (ColorContrast.x * ColorContrastHighlights.x) * _347;
  float _370 = (ColorContrast.y * ColorContrastHighlights.y) * _347;
  float _371 = (ColorContrast.z * ColorContrastHighlights.z) * _347;
  float _390 = 1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _338);
  float _391 = 1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _338);
  float _392 = 1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _338);
  float _402 = (ColorGain.x * ColorGainHighlights.x) * _329;
  float _403 = (ColorGain.y * ColorGainHighlights.y) * _329;
  float _404 = (ColorGain.z * ColorGainHighlights.z) * _329;
  float _408 = (ColorOffset.x + ColorOffsetHighlights.x) + _320;
  float _409 = (ColorOffset.y + ColorOffsetHighlights.y) + _320;
  float _410 = (ColorOffset.z + ColorOffsetHighlights.z) + _320;
  float _416 = ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin;
  float _419 = saturate((_173 - ColorCorrectionHighlightsMin) / _416);
  float _423 = (_419 * _419) * (3.0f - (_419 * 2.0f));
  float _435 = ColorOffset.w + ColorOffsetMidtones.w;
  float _444 = ColorGain.w * ColorGainMidtones.w;
  float _453 = ColorGamma.w * ColorGammaMidtones.w;
  float _462 = ColorContrast.w * ColorContrastMidtones.w;
  float _471 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _472 = (ColorSaturation.x * ColorSaturationMidtones.x) * _471;
  float _473 = (ColorSaturation.y * ColorSaturationMidtones.y) * _471;
  float _474 = (ColorSaturation.z * ColorSaturationMidtones.z) * _471;
  float _484 = (ColorContrast.x * ColorContrastMidtones.x) * _462;
  float _485 = (ColorContrast.y * ColorContrastMidtones.y) * _462;
  float _486 = (ColorContrast.z * ColorContrastMidtones.z) * _462;
  float _505 = 1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _453);
  float _506 = 1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _453);
  float _507 = 1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _453);
  float _517 = (ColorGain.x * ColorGainMidtones.x) * _444;
  float _518 = (ColorGain.y * ColorGainMidtones.y) * _444;
  float _519 = (ColorGain.z * ColorGainMidtones.z) * _444;
  float _523 = (ColorOffset.x + ColorOffsetMidtones.x) + _435;
  float _524 = (ColorOffset.y + ColorOffsetMidtones.y) + _435;
  float _525 = (ColorOffset.z + ColorOffsetMidtones.z) + _435;
  float _526 = _523 + (_517 * exp2(log2(exp2(_484 * log2(max(0.0f, ((_472 * _247) + _173)) * 5.55555534362793f)) * 0.18000000715255737f) * _505));
  float _527 = _524 + (_518 * exp2(log2(exp2(_485 * log2(max(0.0f, ((_473 * _248) + _173)) * 5.55555534362793f)) * 0.18000000715255737f) * _506));
  float _528 = _525 + (_519 * exp2(log2(exp2(_486 * log2(max(0.0f, ((_474 * _249) + _173)) * 5.55555534362793f)) * 0.18000000715255737f) * _507));
  if ((bool)(_311 > 0.5f) && (bool)(dot(float3(_526, _527, _528), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)) < dot(float3(_301, _302, _303), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)))) {
    _539 = (_311 - (_311 * (0.6000000238418579f - _310)));
  } else {
    _539 = _311;
  }
  float _541 = (1.0f - _539) - _423;
  float _552 = ((_539 * _301) + (_423 * min(1e+05f, (_408 + (_402 * exp2(log2(exp2(_369 * log2(max(0.0f, ((_357 * _247) + _173)) * 5.55555534362793f)) * 0.18000000715255737f) * _390)))))) + (_541 * _526);
  float _554 = ((_539 * _302) + (_423 * min(1e+05f, (_409 + (_403 * exp2(log2(exp2(_370 * log2(max(0.0f, ((_358 * _248) + _173)) * 5.55555534362793f)) * 0.18000000715255737f) * _391)))))) + (_541 * _527);
  float _556 = ((_539 * _303) + (min(1e+05f, (_410 + (_404 * exp2(log2(exp2(_371 * log2(max(0.0f, ((_359 * _249) + _173)) * 5.55555534362793f)) * 0.18000000715255737f) * _392)))) * _423)) + (_541 * _528);
  float _559 = mad((WorkingColorSpace_ToAP1[0].z), _114, mad((WorkingColorSpace_ToAP1[0].y), _113, ((WorkingColorSpace_ToAP1[0].x) * _112)));
  float _562 = mad((WorkingColorSpace_ToAP1[1].z), _114, mad((WorkingColorSpace_ToAP1[1].y), _113, ((WorkingColorSpace_ToAP1[1].x) * _112)));
  float _565 = mad((WorkingColorSpace_ToAP1[2].z), _114, mad((WorkingColorSpace_ToAP1[2].y), _113, ((WorkingColorSpace_ToAP1[2].x) * _112)));
  float _566 = dot(float3(_559, _562, _565), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _567 = _559 - _566;
  float _568 = _562 - _566;
  float _569 = _565 - _566;
  float _606 = _298 + (_292 * exp2(log2(exp2(_259 * log2(max(0.0f, ((_244 * _567) + _566)) * 5.55555534362793f)) * 0.18000000715255737f) * _280));
  float _607 = _299 + (_293 * exp2(log2(exp2(_260 * log2(max(0.0f, ((_245 * _568) + _566)) * 5.55555534362793f)) * 0.18000000715255737f) * _281));
  float _608 = _300 + (_294 * exp2(log2(exp2(_261 * log2(max(0.0f, ((_246 * _569) + _566)) * 5.55555534362793f)) * 0.18000000715255737f) * _282));
  float _610 = saturate(_566 / ColorCorrectionShadowsMax);
  float _614 = (_610 * _610) * (3.0f - (_610 * 2.0f));
  float _615 = 1.0f - _614;
  float _657 = saturate((_566 - ColorCorrectionHighlightsMin) / _416);
  float _661 = (_657 * _657) * (3.0f - (_657 * 2.0f));
  float _701 = _523 + (_517 * exp2(log2(exp2(_484 * log2(max(0.0f, ((_472 * _567) + _566)) * 5.55555534362793f)) * 0.18000000715255737f) * _505));
  float _702 = _524 + (_518 * exp2(log2(exp2(_485 * log2(max(0.0f, ((_473 * _568) + _566)) * 5.55555534362793f)) * 0.18000000715255737f) * _506));
  float _703 = _525 + (_519 * exp2(log2(exp2(_486 * log2(max(0.0f, ((_474 * _569) + _566)) * 5.55555534362793f)) * 0.18000000715255737f) * _507));
  if ((bool)(_615 > 0.5f) && (bool)(dot(float3(_701, _702, _703), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)) < dot(float3(_606, _607, _608), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)))) {
    _714 = (_615 - (_615 * (0.6000000238418579f - _614)));
  } else {
    _714 = _615;
  }
  float _716 = (1.0f - _714) - _661;
  float _727 = ((_714 * _606) + (_661 * min(1e+05f, (_408 + (_402 * exp2(log2(exp2(_369 * log2(max(0.0f, ((_357 * _567) + _566)) * 5.55555534362793f)) * 0.18000000715255737f) * _390)))))) + (_716 * _701);
  float _729 = ((_714 * _607) + (_661 * min(1e+05f, (_409 + (_403 * exp2(log2(exp2(_370 * log2(max(0.0f, ((_358 * _568) + _566)) * 5.55555534362793f)) * 0.18000000715255737f) * _391)))))) + (_716 * _702);
  float _731 = ((_714 * _608) + (min(1e+05f, (_410 + (_404 * exp2(log2(exp2(_371 * log2(max(0.0f, ((_359 * _569) + _566)) * 5.55555534362793f)) * 0.18000000715255737f) * _392)))) * _661)) + (_716 * _703);
  float _746 = ((mad(0.061360642313957214f, _556, mad(-4.540197551250458e-09f, _554, (_552 * 0.9386394023895264f))) - _552) * BlueCorrection) + _552;
  float _747 = ((mad(0.169205904006958f, _556, mad(0.8307942152023315f, _554, (_552 * 6.775371730327606e-08f))) - _554) * BlueCorrection) + _554;
  float _748 = (mad(-2.3283064365386963e-10f, _554, (_552 * -9.313225746154785e-10f)) * BlueCorrection) + _556;
  float _751 = mad(0.16386905312538147f, _748, mad(0.14067868888378143f, _747, (_746 * 0.6954522132873535f)));
  float _754 = mad(0.0955343246459961f, _748, mad(0.8596711158752441f, _747, (_746 * 0.044794581830501556f)));
  float _757 = mad(1.0015007257461548f, _748, mad(0.004025210160762072f, _747, (_746 * -0.005525882821530104f)));
  float _761 = max(max(_751, _754), _757);
  float _766 = (max(_761, 1.000000013351432e-10f) - max(min(min(_751, _754), _757), 1.000000013351432e-10f)) / max(_761, 0.009999999776482582f);
  float _779 = ((_754 + _751) + _757) + (sqrt((((_757 - _754) * _757) + ((_754 - _751) * _754)) + ((_751 - _757) * _751)) * 1.75f);
  float _780 = _779 * 0.3333333432674408f;
  float _781 = _766 + -0.4000000059604645f;
  float _782 = _781 * 5.0f;
  float _786 = max((1.0f - abs(_781 * 2.5f)), 0.0f);
  float _797 = ((float((int)(((int)(uint)((bool)(_782 > 0.0f))) - ((int)(uint)((bool)(_782 < 0.0f))))) * (1.0f - (_786 * _786))) + 1.0f) * 0.02500000037252903f;
  if (!(_780 <= 0.0533333346247673f)) {
    if (!(_780 >= 0.1599999964237213f)) {
      _806 = (((0.23999999463558197f / _779) + -0.5f) * _797);
    } else {
      _806 = 0.0f;
    }
  } else {
    _806 = _797;
  }
  float _807 = _806 + 1.0f;
  float _808 = _807 * _751;
  float _809 = _807 * _754;
  float _810 = _807 * _757;
  if (!((bool)(_808 == _809) && (bool)(_809 == _810))) {
    float _817 = ((_808 * 2.0f) - _809) - _810;
    float _820 = ((_754 - _757) * 1.7320507764816284f) * _807;
    float _822 = atan(_820 / _817);
    bool _825 = (_817 < 0.0f);
    bool _826 = (_817 == 0.0f);
    bool _827 = (_820 >= 0.0f);
    bool _828 = (_820 < 0.0f);
    _839 = select((_827 && _826), 90.0f, select((_828 && _826), -90.0f, (select((_828 && _825), (_822 + -3.1415927410125732f), select((_827 && _825), (_822 + 3.1415927410125732f), _822)) * 57.2957763671875f)));
  } else {
    _839 = 0.0f;
  }
  float _844 = min(max(select((_839 < 0.0f), (_839 + 360.0f), _839), 0.0f), 360.0f);
  if (_844 < -180.0f) {
    _853 = (_844 + 360.0f);
  } else {
    if (_844 > 180.0f) {
      _853 = (_844 + -360.0f);
    } else {
      _853 = _844;
    }
  }
  float _857 = saturate(1.0f - abs(_853 * 0.014814814552664757f));
  float _861 = (_857 * _857) * (3.0f - (_857 * 2.0f));
  float _867 = ((_861 * _861) * ((_766 * 0.18000000715255737f) * (0.029999999329447746f - _808))) + _808;
  float _877 = max(0.0f, mad(-0.21492856740951538f, _810, mad(-0.2365107536315918f, _809, (_867 * 1.4514392614364624f))));
  float _878 = max(0.0f, mad(-0.09967592358589172f, _810, mad(1.17622971534729f, _809, (_867 * -0.07655377686023712f))));
  float _879 = max(0.0f, mad(0.9977163076400757f, _810, mad(-0.006032449658960104f, _809, (_867 * 0.008316148072481155f))));
  float _880 = dot(float3(_877, _878, _879), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float3 lerpColor = lerp(_880, float3(_877, _878, _879), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _746, _747, _748);
  float _1068 = lerpColor.r, _1069 = lerpColor.g, _1070 = lerpColor.b;
#else
  float _895 = (FilmBlackClip + 1.0f) - FilmToe;
  float _897 = FilmWhiteClip + 1.0f;
  float _899 = _897 - FilmShoulder;
  bool _900 = (FilmToe > 0.800000011920929f);
  if (_900) {
    _917 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _908 = (FilmBlackClip + 0.18000000715255737f) / _895;
    _917 = (-0.7447274923324585f - ((log2(_908 / (2.0f - _908)) * 0.3465735912322998f) * (_895 / FilmSlope)));
  }
  float _919 = (1.0f - FilmToe) / FilmSlope;
  float _920 = _919 - _917;
  float _921 = FilmShoulder / FilmSlope;
  float _922 = _921 - _920;
  float _926 = log2(lerp(_880, _877, 0.9599999785423279f)) * 0.3010300099849701f;
  float _927 = log2(lerp(_880, _878, 0.9599999785423279f)) * 0.3010300099849701f;
  float _928 = log2(lerp(_880, _879, 0.9599999785423279f)) * 0.3010300099849701f;
  float _932 = FilmSlope * (_926 + _920);
  float _933 = FilmSlope * (_927 + _920);
  float _934 = FilmSlope * (_928 + _920);
  float _935 = _895 * 2.0f;
  float _937 = (FilmSlope * -2.0f) / _895;
  float _938 = _926 - _917;
  float _939 = _927 - _917;
  float _940 = _928 - _917;
  float _959 = _899 * 2.0f;
  float _961 = (FilmSlope * 2.0f) / _899;
  float _986 = select((_926 < _917), ((_935 / (exp2((_938 * 1.4426950216293335f) * _937) + 1.0f)) - FilmBlackClip), _932);
  float _987 = select((_927 < _917), ((_935 / (exp2((_939 * 1.4426950216293335f) * _937) + 1.0f)) - FilmBlackClip), _933);
  float _988 = select((_928 < _917), ((_935 / (exp2((_940 * 1.4426950216293335f) * _937) + 1.0f)) - FilmBlackClip), _934);
  float _995 = _922 - _917;
  float _999 = saturate(_938 / _995);
  float _1000 = saturate(_939 / _995);
  float _1001 = saturate(_940 / _995);
  bool _1002 = (_922 < _917);
  float _1006 = select(_1002, (1.0f - _999), _999);
  float _1007 = select(_1002, (1.0f - _1000), _1000);
  float _1008 = select(_1002, (1.0f - _1001), _1001);
  float _1027 = (((_1006 * _1006) * (select((_926 > _922), (_897 - (_959 / (exp2(((_926 - _922) * 1.4426950216293335f) * _961) + 1.0f))), _932) - _986)) * (3.0f - (_1006 * 2.0f))) + _986;
  float _1028 = (((_1007 * _1007) * (select((_927 > _922), (_897 - (_959 / (exp2(((_927 - _922) * 1.4426950216293335f) * _961) + 1.0f))), _933) - _987)) * (3.0f - (_1007 * 2.0f))) + _987;
  float _1029 = (((_1008 * _1008) * (select((_928 > _922), (_897 - (_959 / (exp2(((_928 - _922) * 1.4426950216293335f) * _961) + 1.0f))), _934) - _988)) * (3.0f - (_1008 * 2.0f))) + _988;
  float _1030 = dot(float3(_1027, _1028, _1029), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1050 = (ToneCurveAmount * (max(0.0f, (lerp(_1030, _1027, 0.9300000071525574f))) - _746)) + _746;
  float _1051 = (ToneCurveAmount * (max(0.0f, (lerp(_1030, _1028, 0.9300000071525574f))) - _747)) + _747;
  float _1052 = (ToneCurveAmount * (max(0.0f, (lerp(_1030, _1029, 0.9300000071525574f))) - _748)) + _748;
  float _1068 = ((mad(-0.06537103652954102f, _1052, mad(1.451815478503704e-06f, _1051, (_1050 * 1.065374732017517f))) - _1050) * BlueCorrection) + _1050;
  float _1069 = ((mad(-0.20366770029067993f, _1052, mad(1.2036634683609009f, _1051, (_1050 * -2.57161445915699e-07f))) - _1051) * BlueCorrection) + _1051;
  float _1070 = ((mad(0.9999996423721313f, _1052, mad(2.0954757928848267e-08f, _1051, (_1050 * 1.862645149230957e-08f))) - _1052) * BlueCorrection) + _1052;
#endif
  float _1092 = (mad((WorkingColorSpace_FromAP1[0].z), _1070, mad((WorkingColorSpace_FromAP1[0].y), _1069, ((WorkingColorSpace_FromAP1[0].x) * _1068))));
  float _1093 = (mad((WorkingColorSpace_FromAP1[1].z), _1070, mad((WorkingColorSpace_FromAP1[1].y), _1069, ((WorkingColorSpace_FromAP1[1].x) * _1068))));
  float _1094 = (mad((WorkingColorSpace_FromAP1[2].z), _1070, mad((WorkingColorSpace_FromAP1[2].y), _1069, ((WorkingColorSpace_FromAP1[2].x) * _1068))));
  
  // They run the whole thing again but discard it??
  /* float _1108 = ((mad(0.061360642313957214f, _731, mad(-4.540197551250458e-09f, _729, (_727 * 0.9386394023895264f))) - _727) * BlueCorrection) + _727;
  float _1109 = ((mad(0.169205904006958f, _731, mad(0.8307942152023315f, _729, (_727 * 6.775371730327606e-08f))) - _729) * BlueCorrection) + _729;
  float _1110 = (mad(-2.3283064365386963e-10f, _729, (_727 * -9.313225746154785e-10f)) * BlueCorrection) + _731;
  float _1113 = mad(0.16386905312538147f, _1110, mad(0.14067868888378143f, _1109, (_1108 * 0.6954522132873535f)));
  float _1116 = mad(0.0955343246459961f, _1110, mad(0.8596711158752441f, _1109, (_1108 * 0.044794581830501556f)));
  float _1119 = mad(1.0015007257461548f, _1110, mad(0.004025210160762072f, _1109, (_1108 * -0.005525882821530104f)));
  float _1123 = max(max(_1113, _1116), _1119);
  float _1128 = (max(_1123, 1.000000013351432e-10f) - max(min(min(_1113, _1116), _1119), 1.000000013351432e-10f)) / max(_1123, 0.009999999776482582f);
  float _1141 = ((_1116 + _1113) + _1119) + (sqrt((((_1119 - _1116) * _1119) + ((_1116 - _1113) * _1116)) + ((_1113 - _1119) * _1113)) * 1.75f);
  float _1142 = _1141 * 0.3333333432674408f;
  float _1143 = _1128 + -0.4000000059604645f;
  float _1144 = _1143 * 5.0f;
  float _1148 = max((1.0f - abs(_1143 * 2.5f)), 0.0f);
  float _1159 = ((float((int)(((int)(uint)((bool)(_1144 > 0.0f))) - ((int)(uint)((bool)(_1144 < 0.0f))))) * (1.0f - (_1148 * _1148))) + 1.0f) * 0.02500000037252903f;
  bool _1160 = !(_1142 <= 0.0533333346247673f);
  if (_1160) {
    if (!(_1142 >= 0.1599999964237213f)) {
      _1168 = (((0.23999999463558197f / _1141) + -0.5f) * _1159);
    } else {
      _1168 = 0.0f;
    }
  } else {
    _1168 = _1159;
  }
  float _1169 = _1168 + 1.0f;
  float _1170 = _1169 * _1113;
  float _1171 = _1169 * _1116;
  float _1172 = _1169 * _1119;
  if (!((bool)(_1170 == _1171) && (bool)(_1171 == _1172))) {
    float _1179 = ((_1170 * 2.0f) - _1171) - _1172;
    float _1182 = ((_1116 - _1119) * 1.7320507764816284f) * _1169;
    float _1184 = atan(_1182 / _1179);
    bool _1187 = (_1179 < 0.0f);
    bool _1188 = (_1179 == 0.0f);
    bool _1189 = (_1182 >= 0.0f);
    bool _1190 = (_1182 < 0.0f);
    _1201 = select((_1189 && _1188), 90.0f, select((_1190 && _1188), -90.0f, (select((_1190 && _1187), (_1184 + -3.1415927410125732f), select((_1189 && _1187), (_1184 + 3.1415927410125732f), _1184)) * 57.2957763671875f)));
  } else {
    _1201 = 0.0f;
  }
  float _1206 = min(max(select((_1201 < 0.0f), (_1201 + 360.0f), _1201), 0.0f), 360.0f);
  if (_1206 < -180.0f) {
    _1215 = (_1206 + 360.0f);
  } else {
    if (_1206 > 180.0f) {
      _1215 = (_1206 + -360.0f);
    } else {
      _1215 = _1206;
    }
  }
  float _1219 = saturate(1.0f - abs(_1215 * 0.014814814552664757f));
  float _1223 = (_1219 * _1219) * (3.0f - (_1219 * 2.0f));
  float _1225 = _1128 * 0.18000000715255737f;
  float _1229 = ((_1223 * _1223) * (_1225 * (0.029999999329447746f - _1170))) + _1170;
  float _1239 = max(0.0f, mad(-0.21492856740951538f, _1172, mad(-0.2365107536315918f, _1171, (_1229 * 1.4514392614364624f))));
  float _1240 = max(0.0f, mad(-0.09967592358589172f, _1172, mad(1.17622971534729f, _1171, (_1229 * -0.07655377686023712f))));
  float _1241 = max(0.0f, mad(0.9977163076400757f, _1172, mad(-0.006032449658960104f, _1171, (_1229 * 0.008316148072481155f))));
  float _1242 = dot(float3(_1239, _1240, _1241), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1252 = log2(lerp(_1242, _1239, 0.9599999785423279f));
  float _1253 = log2(lerp(_1242, _1240, 0.9599999785423279f));
  float _1254 = log2(lerp(_1242, _1241, 0.9599999785423279f));
  float _1255 = _1252 * 0.3010300099849701f;
  float _1256 = _1253 * 0.3010300099849701f;
  float _1257 = _1254 * 0.3010300099849701f;
  float _1259 = (_1252 * 0.2649064064025879f) + 0.7934439778327942f;
  float _1261 = (_1253 * 0.2649064064025879f) + 0.7934439778327942f;
  float _1263 = (_1254 * 0.2649064064025879f) + 0.7934439778327942f;
  float _1300 = select((_1255 < -0.39027726650238037f), (0.8999999761581421f / (exp2(-2.202155351638794f - (_1252 * 1.6985740661621094f)) + 1.0f)), _1259);
  float _1301 = select((_1256 < -0.39027726650238037f), (0.8999999761581421f / (exp2(-2.202155351638794f - (_1253 * 1.6985740661621094f)) + 1.0f)), _1261);
  float _1302 = select((_1257 < -0.39027726650238037f), (0.8999999761581421f / (exp2(-2.202155351638794f - (_1254 * 1.6985740661621094f)) + 1.0f)), _1263);
  float _1318 = 1.0f - saturate(-1.8075997829437256f - (_1252 * 1.3942440748214722f));
  float _1319 = 1.0f - saturate(-1.8075997829437256f - (_1253 * 1.3942440748214722f));
  float _1320 = 1.0f - saturate(-1.8075997829437256f - (_1254 * 1.3942440748214722f));
  float _1339 = (((_1318 * _1318) * (select((_1255 > -0.6061863899230957f), (1.0399999618530273f - (1.559999942779541f / (exp2((_1252 * 0.9799466133117676f) + 1.9733258485794067f) + 1.0f))), _1259) - _1300)) * (3.0f - (_1318 * 2.0f))) + _1300;
  float _1340 = (((_1319 * _1319) * (select((_1256 > -0.6061863899230957f), (1.0399999618530273f - (1.559999942779541f / (exp2((_1253 * 0.9799466133117676f) + 1.9733258485794067f) + 1.0f))), _1261) - _1301)) * (3.0f - (_1319 * 2.0f))) + _1301;
  float _1341 = (((_1320 * _1320) * (select((_1257 > -0.6061863899230957f), (1.0399999618530273f - (1.559999942779541f / (exp2((_1254 * 0.9799466133117676f) + 1.9733258485794067f) + 1.0f))), _1263) - _1302)) * (3.0f - (_1320 * 2.0f))) + _1302;
  float _1342 = dot(float3(_1339, _1340, _1341), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1361 = (ToneCurveAmount * (max(0.0f, (lerp(_1342, _1339, 0.9300000071525574f))) - _1108)) + _1108;
  float _1362 = (ToneCurveAmount * (max(0.0f, (lerp(_1342, _1340, 0.9300000071525574f))) - _1109)) + _1109;
  float _1363 = (ToneCurveAmount * (max(0.0f, (lerp(_1342, _1341, 0.9300000071525574f))) - _1110)) + _1110;
  if (_1160) {
    if (!(_1142 >= 0.1599999964237213f)) {
      _1386 = (((0.23999999463558197f / _1141) + -0.5f) * _1159);
    } else {
      _1386 = 0.0f;
    }
  } else {
    _1386 = _1159;
  }
  float _1387 = _1386 + 1.0f;
  float _1388 = _1387 * _1113;
  float _1389 = _1387 * _1116;
  float _1390 = _1387 * _1119;
  if (!((bool)(_1388 == _1389) && (bool)(_1389 == _1390))) {
    float _1397 = ((_1388 * 2.0f) - _1389) - _1390;
    float _1400 = ((_1116 - _1119) * 1.7320507764816284f) * _1387;
    float _1402 = atan(_1400 / _1397);
    bool _1405 = (_1397 < 0.0f);
    bool _1406 = (_1397 == 0.0f);
    bool _1407 = (_1400 >= 0.0f);
    bool _1408 = (_1400 < 0.0f);
    _1419 = select((_1407 && _1406), 90.0f, select((_1408 && _1406), -90.0f, (select((_1408 && _1405), (_1402 + -3.1415927410125732f), select((_1407 && _1405), (_1402 + 3.1415927410125732f), _1402)) * 57.2957763671875f)));
  } else {
    _1419 = 0.0f;
  }
  float _1424 = min(max(select((_1419 < 0.0f), (_1419 + 360.0f), _1419), 0.0f), 360.0f);
  if (_1424 < -180.0f) {
    _1433 = (_1424 + 360.0f);
  } else {
    if (_1424 > 180.0f) {
      _1433 = (_1424 + -360.0f);
    } else {
      _1433 = _1424;
    }
  }
  float _1437 = saturate(1.0f - abs(_1433 * 0.014814814552664757f));
  float _1441 = (_1437 * _1437) * (3.0f - (_1437 * 2.0f));
  float _1446 = ((_1441 * _1441) * (_1225 * (0.029999999329447746f - _1388))) + _1388;
  float _1456 = max(0.0f, mad(-0.21492856740951538f, _1390, mad(-0.2365107536315918f, _1389, (_1446 * 1.4514392614364624f))));
  float _1457 = max(0.0f, mad(-0.09967592358589172f, _1390, mad(1.17622971534729f, _1389, (_1446 * -0.07655377686023712f))));
  float _1458 = max(0.0f, mad(0.9977163076400757f, _1390, mad(-0.006032449658960104f, _1389, (_1446 * 0.008316148072481155f))));
  float _1459 = dot(float3(_1456, _1457, _1458), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  if (_900) {
    _1484 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _1475 = (FilmBlackClip + 0.18000000715255737f) / _895;
    _1484 = (-0.7447274923324585f - ((log2(_1475 / (2.0f - _1475)) * 0.3465735912322998f) * (_895 / FilmSlope)));
  }
  float _1485 = _919 - _1484;
  float _1486 = _921 - _1485;
  float _1490 = log2(lerp(_1459, _1456, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1491 = log2(lerp(_1459, _1457, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1492 = log2(lerp(_1459, _1458, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1496 = FilmSlope * (_1490 + _1485);
  float _1497 = FilmSlope * (_1491 + _1485);
  float _1498 = FilmSlope * (_1492 + _1485);
  float _1499 = _1490 - _1484;
  float _1500 = _1491 - _1484;
  float _1501 = _1492 - _1484;
  float _1544 = select((_1490 < _1484), ((_935 / (exp2((_1499 * 1.4426950216293335f) * _937) + 1.0f)) - FilmBlackClip), _1496);
  float _1545 = select((_1491 < _1484), ((_935 / (exp2((_1500 * 1.4426950216293335f) * _937) + 1.0f)) - FilmBlackClip), _1497);
  float _1546 = select((_1492 < _1484), ((_935 / (exp2((_1501 * 1.4426950216293335f) * _937) + 1.0f)) - FilmBlackClip), _1498);
  float _1553 = _1486 - _1484;
  float _1557 = saturate(_1499 / _1553);
  float _1558 = saturate(_1500 / _1553);
  float _1559 = saturate(_1501 / _1553);
  bool _1560 = (_1486 < _1484);
  float _1564 = select(_1560, (1.0f - _1557), _1557);
  float _1565 = select(_1560, (1.0f - _1558), _1558);
  float _1566 = select(_1560, (1.0f - _1559), _1559);
  float _1585 = (((_1564 * _1564) * (select((_1490 > _1486), (_897 - (_959 / (exp2(((_1490 - _1486) * 1.4426950216293335f) * _961) + 1.0f))), _1496) - _1544)) * (3.0f - (_1564 * 2.0f))) + _1544;
  float _1586 = (((_1565 * _1565) * (select((_1491 > _1486), (_897 - (_959 / (exp2(((_1491 - _1486) * 1.4426950216293335f) * _961) + 1.0f))), _1497) - _1545)) * (3.0f - (_1565 * 2.0f))) + _1545;
  float _1587 = (((_1566 * _1566) * (select((_1492 > _1486), (_897 - (_959 / (exp2(((_1492 - _1486) * 1.4426950216293335f) * _961) + 1.0f))), _1498) - _1546)) * (3.0f - (_1566 * 2.0f))) + _1546;
  float _1588 = dot(float3(_1585, _1586, _1587), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1607 = (ToneCurveAmount * (max(0.0f, (lerp(_1588, _1585, 0.9300000071525574f))) - _1108)) + _1108;
  float _1608 = (ToneCurveAmount * (max(0.0f, (lerp(_1588, _1586, 0.9300000071525574f))) - _1109)) + _1109;
  float _1609 = (ToneCurveAmount * (max(0.0f, (lerp(_1588, _1587, 0.9300000071525574f))) - _1110)) + _1110;
  float _1625 = ((mad(-0.06537103652954102f, _1609, mad(1.451815478503704e-06f, _1608, (_1607 * 1.065374732017517f))) - _1607) * BlueCorrection) + _1607;
  float _1626 = ((mad(-0.20366770029067993f, _1609, mad(1.2036634683609009f, _1608, (_1607 * -2.57161445915699e-07f))) - _1608) * BlueCorrection) + _1608;
  float _1627 = ((mad(0.9999996423721313f, _1609, mad(2.0954757928848267e-08f, _1608, (_1607 * 1.862645149230957e-08f))) - _1609) * BlueCorrection) + _1609;
  float _1630 = ((_552 - _1361) - ((mad(-0.06537103652954102f, _1363, mad(1.451815478503704e-06f, _1362, (_1361 * 1.065374732017517f))) - _1361) * BlueCorrection)) + _1625;
  float _1633 = ((_554 - _1362) - ((mad(-0.20366770029067993f, _1363, mad(1.2036634683609009f, _1362, (_1361 * -2.57161445915699e-07f))) - _1362) * BlueCorrection)) + _1626;
  float _1636 = ((_556 - _1363) - ((mad(0.9999996423721313f, _1363, mad(2.0954757928848267e-08f, _1362, (_1361 * 1.862645149230957e-08f))) - _1363) * BlueCorrection)) + _1627;
   */
  float _1671 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1092)) * _1092) + MappingPolynomial.z);
  float _1672 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1093)) * _1093) + MappingPolynomial.z);
  float _1673 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1094)) * _1094) + MappingPolynomial.z);
  float _1680 = ((OverlayColor.x - _1671) * OverlayColor.w) + _1671;
  float _1681 = ((OverlayColor.y - _1672) * OverlayColor.w) + _1672;
  float _1682 = ((OverlayColor.z - _1673) * OverlayColor.w) + _1673;

  if (GenerateOutput(_1680, _1681, _1682, SV_Target, is_hdr)) {
    return SV_Target;
  }

  /* float _1683 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _1636, mad((WorkingColorSpace_FromAP1[0].y), _1633, ((WorkingColorSpace_FromAP1[0].x) * _1630)));
  float _1684 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _1636, mad((WorkingColorSpace_FromAP1[1].y), _1633, ((WorkingColorSpace_FromAP1[1].x) * _1630)));
  float _1685 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _1636, mad((WorkingColorSpace_FromAP1[2].y), _1633, ((WorkingColorSpace_FromAP1[2].x) * _1630)));
  float _1692 = ((OverlayColor.x - _1683) * OverlayColor.w) + _1683;
  float _1693 = ((OverlayColor.y - _1684) * OverlayColor.w) + _1684;
  float _1694 = ((OverlayColor.z - _1685) * OverlayColor.w) + _1685;
  float _1704 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _1627, mad((WorkingColorSpace_FromAP1[0].y), _1626, ((WorkingColorSpace_FromAP1[0].x) * _1625)));
  float _1705 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _1627, mad((WorkingColorSpace_FromAP1[1].y), _1626, ((WorkingColorSpace_FromAP1[1].x) * _1625)));
  float _1706 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _1627, mad((WorkingColorSpace_FromAP1[2].y), _1626, ((WorkingColorSpace_FromAP1[2].x) * _1625)));
  float _1713 = ((OverlayColor.x - _1704) * OverlayColor.w) + _1704;
  float _1714 = ((OverlayColor.y - _1705) * OverlayColor.w) + _1705;
  float _1715 = ((OverlayColor.z - _1706) * OverlayColor.w) + _1706;
  float _1718 = mad((WorkingColorSpace_ToAP1[0].z), _1715, mad((WorkingColorSpace_ToAP1[0].y), _1714, (_1713 * (WorkingColorSpace_ToAP1[0].x))));
  float _1721 = mad((WorkingColorSpace_ToAP1[1].z), _1715, mad((WorkingColorSpace_ToAP1[1].y), _1714, (_1713 * (WorkingColorSpace_ToAP1[1].x))));
  float _1724 = mad((WorkingColorSpace_ToAP1[2].z), _1715, mad((WorkingColorSpace_ToAP1[2].y), _1714, (_1713 * (WorkingColorSpace_ToAP1[2].x)))); */
  float _1736 = exp2(log2(max(0.0f, _1680)) * InverseGamma.y);
  float _1737 = exp2(log2(max(0.0f, _1681)) * InverseGamma.y);
  float _1738 = exp2(log2(max(0.0f, _1682)) * InverseGamma.y);
  /* [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace_bIsSRGB == 0) {
        float _1747 = mad((WorkingColorSpace_ToAP1[0].z), _1738, mad((WorkingColorSpace_ToAP1[0].y), _1737, ((WorkingColorSpace_ToAP1[0].x) * _1736)));
        float _1750 = mad((WorkingColorSpace_ToAP1[1].z), _1738, mad((WorkingColorSpace_ToAP1[1].y), _1737, ((WorkingColorSpace_ToAP1[1].x) * _1736)));
        float _1753 = mad((WorkingColorSpace_ToAP1[2].z), _1738, mad((WorkingColorSpace_ToAP1[2].y), _1737, ((WorkingColorSpace_ToAP1[2].x) * _1736)));
        _1764 = mad(_45, _1753, mad(_44, _1750, (_1747 * _43)));
        _1765 = mad(_48, _1753, mad(_47, _1750, (_1747 * _46)));
        _1766 = mad(_51, _1753, mad(_50, _1750, (_1747 * _49)));
      } else {
        _1764 = _1736;
        _1765 = _1737;
        _1766 = _1738;
      }
      do {
        if (_1764 < 0.0031306699384003878f) {
          _1777 = (_1764 * 12.920000076293945f);
        } else {
          _1777 = (((pow(_1764, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1765 < 0.0031306699384003878f) {
            _1788 = (_1765 * 12.920000076293945f);
          } else {
            _1788 = (((pow(_1765, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1766 < 0.0031306699384003878f) {
            _3186 = _1777;
            _3187 = _1788;
            _3188 = (_1766 * 12.920000076293945f);
          } else {
            _3186 = _1777;
            _3187 = _1788;
            _3188 = (((pow(_1766, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1803 = mad((WorkingColorSpace_ToAP1[0].z), _1738, mad((WorkingColorSpace_ToAP1[0].y), _1737, ((WorkingColorSpace_ToAP1[0].x) * _1736)));
      float _1806 = mad((WorkingColorSpace_ToAP1[1].z), _1738, mad((WorkingColorSpace_ToAP1[1].y), _1737, ((WorkingColorSpace_ToAP1[1].x) * _1736)));
      float _1809 = mad((WorkingColorSpace_ToAP1[2].z), _1738, mad((WorkingColorSpace_ToAP1[2].y), _1737, ((WorkingColorSpace_ToAP1[2].x) * _1736)));
      float _1819 = max(6.103519990574569e-05f, mad(_45, _1809, mad(_44, _1806, (_1803 * _43))));
      float _1820 = max(6.103519990574569e-05f, mad(_48, _1809, mad(_47, _1806, (_1803 * _46))));
      float _1821 = max(6.103519990574569e-05f, mad(_51, _1809, mad(_50, _1806, (_1803 * _49))));
      _3186 = min((_1819 * 4.5f), ((exp2(log2(max(_1819, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3187 = min((_1820 * 4.5f), ((exp2(log2(max(_1820, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3188 = min((_1821 * 4.5f), ((exp2(log2(max(_1821, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
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
        float _1896 = ACESSceneColorMultiplier * _1692;
        float _1897 = ACESSceneColorMultiplier * _1693;
        float _1898 = ACESSceneColorMultiplier * _1694;
        float _1901 = mad((WorkingColorSpace_ToAP0[0].z), _1898, mad((WorkingColorSpace_ToAP0[0].y), _1897, ((WorkingColorSpace_ToAP0[0].x) * _1896)));
        float _1904 = mad((WorkingColorSpace_ToAP0[1].z), _1898, mad((WorkingColorSpace_ToAP0[1].y), _1897, ((WorkingColorSpace_ToAP0[1].x) * _1896)));
        float _1907 = mad((WorkingColorSpace_ToAP0[2].z), _1898, mad((WorkingColorSpace_ToAP0[2].y), _1897, ((WorkingColorSpace_ToAP0[2].x) * _1896)));
        float _1911 = max(max(_1901, _1904), _1907);
        float _1916 = (max(_1911, 1.000000013351432e-10f) - max(min(min(_1901, _1904), _1907), 1.000000013351432e-10f)) / max(_1911, 0.009999999776482582f);
        float _1929 = ((_1904 + _1901) + _1907) + (sqrt((((_1907 - _1904) * _1907) + ((_1904 - _1901) * _1904)) + ((_1901 - _1907) * _1901)) * 1.75f);
        float _1930 = _1929 * 0.3333333432674408f;
        float _1931 = _1916 + -0.4000000059604645f;
        float _1932 = _1931 * 5.0f;
        float _1936 = max((1.0f - abs(_1931 * 2.5f)), 0.0f);
        float _1947 = ((float((int)(((int)(uint)((bool)(_1932 > 0.0f))) - ((int)(uint)((bool)(_1932 < 0.0f))))) * (1.0f - (_1936 * _1936))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1930 <= 0.0533333346247673f)) {
            if (!(_1930 >= 0.1599999964237213f)) {
              _1956 = (((0.23999999463558197f / _1929) + -0.5f) * _1947);
            } else {
              _1956 = 0.0f;
            }
          } else {
            _1956 = _1947;
          }
          float _1957 = _1956 + 1.0f;
          float _1958 = _1957 * _1901;
          float _1959 = _1957 * _1904;
          float _1960 = _1957 * _1907;
          do {
            if (!((bool)(_1958 == _1959) && (bool)(_1959 == _1960))) {
              float _1967 = ((_1958 * 2.0f) - _1959) - _1960;
              float _1970 = ((_1904 - _1907) * 1.7320507764816284f) * _1957;
              float _1972 = atan(_1970 / _1967);
              bool _1975 = (_1967 < 0.0f);
              bool _1976 = (_1967 == 0.0f);
              bool _1977 = (_1970 >= 0.0f);
              bool _1978 = (_1970 < 0.0f);
              _1989 = select((_1977 && _1976), 90.0f, select((_1978 && _1976), -90.0f, (select((_1978 && _1975), (_1972 + -3.1415927410125732f), select((_1977 && _1975), (_1972 + 3.1415927410125732f), _1972)) * 57.2957763671875f)));
            } else {
              _1989 = 0.0f;
            }
            float _1994 = min(max(select((_1989 < 0.0f), (_1989 + 360.0f), _1989), 0.0f), 360.0f);
            do {
              if (_1994 < -180.0f) {
                _2003 = (_1994 + 360.0f);
              } else {
                if (_1994 > 180.0f) {
                  _2003 = (_1994 + -360.0f);
                } else {
                  _2003 = _1994;
                }
              }
              do {
                if ((bool)(_2003 > -67.5f) && (bool)(_2003 < 67.5f)) {
                  float _2009 = (_2003 + 67.5f) * 0.029629629105329514f;
                  int _2010 = int(_2009);
                  float _2012 = _2009 - float((int)(_2010));
                  float _2013 = _2012 * _2012;
                  float _2014 = _2013 * _2012;
                  if (_2010 == 3) {
                    _2042 = (((0.1666666716337204f - (_2012 * 0.5f)) + (_2013 * 0.5f)) - (_2014 * 0.1666666716337204f));
                  } else {
                    if (_2010 == 2) {
                      _2042 = ((0.6666666865348816f - _2013) + (_2014 * 0.5f));
                    } else {
                      if (_2010 == 1) {
                        _2042 = (((_2014 * -0.5f) + 0.1666666716337204f) + ((_2013 + _2012) * 0.5f));
                      } else {
                        _2042 = select((_2010 == 0), (_2014 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _2042 = 0.0f;
                }
                float _2051 = min(max(((((_1916 * 0.27000001072883606f) * (0.029999999329447746f - _1958)) * _2042) + _1958), 0.0f), 65535.0f);
                float _2052 = min(max(_1959, 0.0f), 65535.0f);
                float _2053 = min(max(_1960, 0.0f), 65535.0f);
                float _2066 = min(max(mad(-0.21492856740951538f, _2053, mad(-0.2365107536315918f, _2052, (_2051 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _2067 = min(max(mad(-0.09967592358589172f, _2053, mad(1.17622971534729f, _2052, (_2051 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _2068 = min(max(mad(0.9977163076400757f, _2053, mad(-0.006032449658960104f, _2052, (_2051 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _2069 = dot(float3(_2066, _2067, _2068), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _2080 = log2(max((lerp(_2069, _2066, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _2081 = _2080 * 0.3010300099849701f;
                float _2082 = log2(ACESMinMaxData.x);
                float _2083 = _2082 * 0.3010300099849701f;
                do {
                  if (!(!(_2081 <= _2083))) {
                    _2152 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _2090 = log2(ACESMidData.x);
                    float _2091 = _2090 * 0.3010300099849701f;
                    if ((bool)(_2081 > _2083) && (bool)(_2081 < _2091)) {
                      float _2099 = ((_2080 - _2082) * 0.9030900001525879f) / ((_2090 - _2082) * 0.3010300099849701f);
                      int _2100 = int(_2099);
                      float _2102 = _2099 - float((int)(_2100));
                      float _2104 = _10[_2100];
                      float _2107 = _10[(_2100 + 1)];
                      float _2112 = _2104 * 0.5f;
                      _2152 = dot(float3((_2102 * _2102), _2102, 1.0f), float3(mad((_10[(_2100 + 2)]), 0.5f, mad(_2107, -1.0f, _2112)), (_2107 - _2104), mad(_2107, 0.5f, _2112)));
                    } else {
                      do {
                        if (!(!(_2081 >= _2091))) {
                          float _2121 = log2(ACESMinMaxData.z);
                          if (_2081 < (_2121 * 0.3010300099849701f)) {
                            float _2129 = ((_2080 - _2090) * 0.9030900001525879f) / ((_2121 - _2090) * 0.3010300099849701f);
                            int _2130 = int(_2129);
                            float _2132 = _2129 - float((int)(_2130));
                            float _2134 = _11[_2130];
                            float _2137 = _11[(_2130 + 1)];
                            float _2142 = _2134 * 0.5f;
                            _2152 = dot(float3((_2132 * _2132), _2132, 1.0f), float3(mad((_11[(_2130 + 2)]), 0.5f, mad(_2137, -1.0f, _2142)), (_2137 - _2134), mad(_2137, 0.5f, _2142)));
                            break;
                          }
                        }
                        _2152 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _2156 = log2(max((lerp(_2069, _2067, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2157 = _2156 * 0.3010300099849701f;
                  do {
                    if (!(!(_2157 <= _2083))) {
                      _2226 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2164 = log2(ACESMidData.x);
                      float _2165 = _2164 * 0.3010300099849701f;
                      if ((bool)(_2157 > _2083) && (bool)(_2157 < _2165)) {
                        float _2173 = ((_2156 - _2082) * 0.9030900001525879f) / ((_2164 - _2082) * 0.3010300099849701f);
                        int _2174 = int(_2173);
                        float _2176 = _2173 - float((int)(_2174));
                        float _2178 = _10[_2174];
                        float _2181 = _10[(_2174 + 1)];
                        float _2186 = _2178 * 0.5f;
                        _2226 = dot(float3((_2176 * _2176), _2176, 1.0f), float3(mad((_10[(_2174 + 2)]), 0.5f, mad(_2181, -1.0f, _2186)), (_2181 - _2178), mad(_2181, 0.5f, _2186)));
                      } else {
                        do {
                          if (!(!(_2157 >= _2165))) {
                            float _2195 = log2(ACESMinMaxData.z);
                            if (_2157 < (_2195 * 0.3010300099849701f)) {
                              float _2203 = ((_2156 - _2164) * 0.9030900001525879f) / ((_2195 - _2164) * 0.3010300099849701f);
                              int _2204 = int(_2203);
                              float _2206 = _2203 - float((int)(_2204));
                              float _2208 = _11[_2204];
                              float _2211 = _11[(_2204 + 1)];
                              float _2216 = _2208 * 0.5f;
                              _2226 = dot(float3((_2206 * _2206), _2206, 1.0f), float3(mad((_11[(_2204 + 2)]), 0.5f, mad(_2211, -1.0f, _2216)), (_2211 - _2208), mad(_2211, 0.5f, _2216)));
                              break;
                            }
                          }
                          _2226 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2230 = log2(max((lerp(_2069, _2068, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2231 = _2230 * 0.3010300099849701f;
                    do {
                      if (!(!(_2231 <= _2083))) {
                        _2300 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2238 = log2(ACESMidData.x);
                        float _2239 = _2238 * 0.3010300099849701f;
                        if ((bool)(_2231 > _2083) && (bool)(_2231 < _2239)) {
                          float _2247 = ((_2230 - _2082) * 0.9030900001525879f) / ((_2238 - _2082) * 0.3010300099849701f);
                          int _2248 = int(_2247);
                          float _2250 = _2247 - float((int)(_2248));
                          float _2252 = _10[_2248];
                          float _2255 = _10[(_2248 + 1)];
                          float _2260 = _2252 * 0.5f;
                          _2300 = dot(float3((_2250 * _2250), _2250, 1.0f), float3(mad((_10[(_2248 + 2)]), 0.5f, mad(_2255, -1.0f, _2260)), (_2255 - _2252), mad(_2255, 0.5f, _2260)));
                        } else {
                          do {
                            if (!(!(_2231 >= _2239))) {
                              float _2269 = log2(ACESMinMaxData.z);
                              if (_2231 < (_2269 * 0.3010300099849701f)) {
                                float _2277 = ((_2230 - _2238) * 0.9030900001525879f) / ((_2269 - _2238) * 0.3010300099849701f);
                                int _2278 = int(_2277);
                                float _2280 = _2277 - float((int)(_2278));
                                float _2282 = _11[_2278];
                                float _2285 = _11[(_2278 + 1)];
                                float _2290 = _2282 * 0.5f;
                                _2300 = dot(float3((_2280 * _2280), _2280, 1.0f), float3(mad((_11[(_2278 + 2)]), 0.5f, mad(_2285, -1.0f, _2290)), (_2285 - _2282), mad(_2285, 0.5f, _2290)));
                                break;
                              }
                            }
                            _2300 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2304 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _2305 = (exp2(_2152 * 3.321928024291992f) - ACESMinMaxData.y) / _2304;
                      float _2307 = (exp2(_2226 * 3.321928024291992f) - ACESMinMaxData.y) / _2304;
                      float _2309 = (exp2(_2300 * 3.321928024291992f) - ACESMinMaxData.y) / _2304;
                      float _2312 = mad(0.15618768334388733f, _2309, mad(0.13400420546531677f, _2307, (_2305 * 0.6624541878700256f)));
                      float _2315 = mad(0.053689517080783844f, _2309, mad(0.6740817427635193f, _2307, (_2305 * 0.2722287178039551f)));
                      float _2318 = mad(1.0103391408920288f, _2309, mad(0.00406073359772563f, _2307, (_2305 * -0.005574649665504694f)));
                      float _2331 = min(max(mad(-0.23642469942569733f, _2318, mad(-0.32480329275131226f, _2315, (_2312 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _2332 = min(max(mad(0.016756348311901093f, _2318, mad(1.6153316497802734f, _2315, (_2312 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _2333 = min(max(mad(0.9883948564529419f, _2318, mad(-0.008284442126750946f, _2315, (_2312 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _2336 = mad(0.15618768334388733f, _2333, mad(0.13400420546531677f, _2332, (_2331 * 0.6624541878700256f)));
                      float _2339 = mad(0.053689517080783844f, _2333, mad(0.6740817427635193f, _2332, (_2331 * 0.2722287178039551f)));
                      float _2342 = mad(1.0103391408920288f, _2333, mad(0.00406073359772563f, _2332, (_2331 * -0.005574649665504694f)));
                      float _2364 = min(max((min(max(mad(-0.23642469942569733f, _2342, mad(-0.32480329275131226f, _2339, (_2336 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2365 = min(max((min(max(mad(0.016756348311901093f, _2342, mad(1.6153316497802734f, _2339, (_2336 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2366 = min(max((min(max(mad(0.9883948564529419f, _2342, mad(-0.008284442126750946f, _2339, (_2336 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!(OutputDevice == 5)) {
                          float _2369 = dot(float3(_2364, _2365, _2366), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                          float _2370 = _1718 * 300.0f;
                          float _2371 = _1721 * 300.0f;
                          float _2372 = _1724 * 300.0f;
                          do {
                            [branch]
                            if (!(_2369 < 1.0f)) {
                              if (_2369 < 5.0f) {
                                float _2378 = (_2369 + -1.0f) * 0.25f;
                                _2405 = ((_2378 * (_2370 - _2364)) + _2364);
                                _2406 = ((_2378 * (_2371 - _2365)) + _2365);
                                _2407 = ((_2378 * (_2372 - _2366)) + _2366);
                              } else {
                                if (!(_2369 < 50.0f)) {
                                  if (_2369 < 150.0f) {
                                    float _2394 = (_2369 + -50.0f) * 0.009999999776482582f;
                                    _2405 = ((_2394 * (_2364 - _2370)) + _2370);
                                    _2406 = ((_2394 * (_2365 - _2371)) + _2371);
                                    _2407 = ((_2394 * (_2366 - _2372)) + _2372);
                                  } else {
                                    _2405 = _2364;
                                    _2406 = _2365;
                                    _2407 = _2366;
                                  }
                                } else {
                                  _2405 = _2370;
                                  _2406 = _2371;
                                  _2407 = _2372;
                                }
                              }
                            } else {
                              _2405 = _2364;
                              _2406 = _2365;
                              _2407 = _2366;
                            }
                            _2418 = mad(_45, _2407, mad(_44, _2406, (_2405 * _43)));
                            _2419 = mad(_48, _2407, mad(_47, _2406, (_2405 * _46)));
                            _2420 = mad(_51, _2407, mad(_50, _2406, (_2405 * _49)));
                          } while (false);
                        } else {
                          _2418 = _2364;
                          _2419 = _2365;
                          _2420 = _2366;
                        }
                        float _2430 = exp2(log2(_2418 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2431 = exp2(log2(_2419 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2432 = exp2(log2(_2420 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _3186 = exp2(log2((1.0f / ((_2430 * 18.6875f) + 1.0f)) * ((_2430 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _3187 = exp2(log2((1.0f / ((_2431 * 18.6875f) + 1.0f)) * ((_2431 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _3188 = exp2(log2((1.0f / ((_2432 * 18.6875f) + 1.0f)) * ((_2432 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          _8[0] = ACESCoefsLow_0.x;
          _8[1] = ACESCoefsLow_0.y;
          _8[2] = ACESCoefsLow_0.z;
          _8[3] = ACESCoefsLow_0.w;
          _8[4] = ACESCoefsLow_4;
          _8[5] = ACESCoefsLow_4;
          _9[0] = ACESCoefsHigh_0.x;
          _9[1] = ACESCoefsHigh_0.y;
          _9[2] = ACESCoefsHigh_0.z;
          _9[3] = ACESCoefsHigh_0.w;
          _9[4] = ACESCoefsHigh_4;
          _9[5] = ACESCoefsHigh_4;
          float _2509 = ACESSceneColorMultiplier * _1692;
          float _2510 = ACESSceneColorMultiplier * _1693;
          float _2511 = ACESSceneColorMultiplier * _1694;
          float _2514 = mad((WorkingColorSpace_ToAP0[0].z), _2511, mad((WorkingColorSpace_ToAP0[0].y), _2510, ((WorkingColorSpace_ToAP0[0].x) * _2509)));
          float _2517 = mad((WorkingColorSpace_ToAP0[1].z), _2511, mad((WorkingColorSpace_ToAP0[1].y), _2510, ((WorkingColorSpace_ToAP0[1].x) * _2509)));
          float _2520 = mad((WorkingColorSpace_ToAP0[2].z), _2511, mad((WorkingColorSpace_ToAP0[2].y), _2510, ((WorkingColorSpace_ToAP0[2].x) * _2509)));
          float _2524 = max(max(_2514, _2517), _2520);
          float _2529 = (max(_2524, 1.000000013351432e-10f) - max(min(min(_2514, _2517), _2520), 1.000000013351432e-10f)) / max(_2524, 0.009999999776482582f);
          float _2542 = ((_2517 + _2514) + _2520) + (sqrt((((_2520 - _2517) * _2520) + ((_2517 - _2514) * _2517)) + ((_2514 - _2520) * _2514)) * 1.75f);
          float _2543 = _2542 * 0.3333333432674408f;
          float _2544 = _2529 + -0.4000000059604645f;
          float _2545 = _2544 * 5.0f;
          float _2549 = max((1.0f - abs(_2544 * 2.5f)), 0.0f);
          float _2560 = ((float((int)(((int)(uint)((bool)(_2545 > 0.0f))) - ((int)(uint)((bool)(_2545 < 0.0f))))) * (1.0f - (_2549 * _2549))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2543 <= 0.0533333346247673f)) {
              if (!(_2543 >= 0.1599999964237213f)) {
                _2569 = (((0.23999999463558197f / _2542) + -0.5f) * _2560);
              } else {
                _2569 = 0.0f;
              }
            } else {
              _2569 = _2560;
            }
            float _2570 = _2569 + 1.0f;
            float _2571 = _2570 * _2514;
            float _2572 = _2570 * _2517;
            float _2573 = _2570 * _2520;
            do {
              if (!((bool)(_2571 == _2572) && (bool)(_2572 == _2573))) {
                float _2580 = ((_2571 * 2.0f) - _2572) - _2573;
                float _2583 = ((_2517 - _2520) * 1.7320507764816284f) * _2570;
                float _2585 = atan(_2583 / _2580);
                bool _2588 = (_2580 < 0.0f);
                bool _2589 = (_2580 == 0.0f);
                bool _2590 = (_2583 >= 0.0f);
                bool _2591 = (_2583 < 0.0f);
                _2602 = select((_2590 && _2589), 90.0f, select((_2591 && _2589), -90.0f, (select((_2591 && _2588), (_2585 + -3.1415927410125732f), select((_2590 && _2588), (_2585 + 3.1415927410125732f), _2585)) * 57.2957763671875f)));
              } else {
                _2602 = 0.0f;
              }
              float _2607 = min(max(select((_2602 < 0.0f), (_2602 + 360.0f), _2602), 0.0f), 360.0f);
              do {
                if (_2607 < -180.0f) {
                  _2616 = (_2607 + 360.0f);
                } else {
                  if (_2607 > 180.0f) {
                    _2616 = (_2607 + -360.0f);
                  } else {
                    _2616 = _2607;
                  }
                }
                do {
                  if ((bool)(_2616 > -67.5f) && (bool)(_2616 < 67.5f)) {
                    float _2622 = (_2616 + 67.5f) * 0.029629629105329514f;
                    int _2623 = int(_2622);
                    float _2625 = _2622 - float((int)(_2623));
                    float _2626 = _2625 * _2625;
                    float _2627 = _2626 * _2625;
                    if (_2623 == 3) {
                      _2655 = (((0.1666666716337204f - (_2625 * 0.5f)) + (_2626 * 0.5f)) - (_2627 * 0.1666666716337204f));
                    } else {
                      if (_2623 == 2) {
                        _2655 = ((0.6666666865348816f - _2626) + (_2627 * 0.5f));
                      } else {
                        if (_2623 == 1) {
                          _2655 = (((_2627 * -0.5f) + 0.1666666716337204f) + ((_2626 + _2625) * 0.5f));
                        } else {
                          _2655 = select((_2623 == 0), (_2627 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2655 = 0.0f;
                  }
                  float _2664 = min(max(((((_2529 * 0.27000001072883606f) * (0.029999999329447746f - _2571)) * _2655) + _2571), 0.0f), 65535.0f);
                  float _2665 = min(max(_2572, 0.0f), 65535.0f);
                  float _2666 = min(max(_2573, 0.0f), 65535.0f);
                  float _2679 = min(max(mad(-0.21492856740951538f, _2666, mad(-0.2365107536315918f, _2665, (_2664 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2680 = min(max(mad(-0.09967592358589172f, _2666, mad(1.17622971534729f, _2665, (_2664 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2681 = min(max(mad(0.9977163076400757f, _2666, mad(-0.006032449658960104f, _2665, (_2664 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2682 = dot(float3(_2679, _2680, _2681), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2693 = log2(max((lerp(_2682, _2679, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2694 = _2693 * 0.3010300099849701f;
                  float _2695 = log2(ACESMinMaxData.x);
                  float _2696 = _2695 * 0.3010300099849701f;
                  do {
                    if (!(!(_2694 <= _2696))) {
                      _2765 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2703 = log2(ACESMidData.x);
                      float _2704 = _2703 * 0.3010300099849701f;
                      if ((bool)(_2694 > _2696) && (bool)(_2694 < _2704)) {
                        float _2712 = ((_2693 - _2695) * 0.9030900001525879f) / ((_2703 - _2695) * 0.3010300099849701f);
                        int _2713 = int(_2712);
                        float _2715 = _2712 - float((int)(_2713));
                        float _2717 = _8[_2713];
                        float _2720 = _8[(_2713 + 1)];
                        float _2725 = _2717 * 0.5f;
                        _2765 = dot(float3((_2715 * _2715), _2715, 1.0f), float3(mad((_8[(_2713 + 2)]), 0.5f, mad(_2720, -1.0f, _2725)), (_2720 - _2717), mad(_2720, 0.5f, _2725)));
                      } else {
                        do {
                          if (!(!(_2694 >= _2704))) {
                            float _2734 = log2(ACESMinMaxData.z);
                            if (_2694 < (_2734 * 0.3010300099849701f)) {
                              float _2742 = ((_2693 - _2703) * 0.9030900001525879f) / ((_2734 - _2703) * 0.3010300099849701f);
                              int _2743 = int(_2742);
                              float _2745 = _2742 - float((int)(_2743));
                              float _2747 = _9[_2743];
                              float _2750 = _9[(_2743 + 1)];
                              float _2755 = _2747 * 0.5f;
                              _2765 = dot(float3((_2745 * _2745), _2745, 1.0f), float3(mad((_9[(_2743 + 2)]), 0.5f, mad(_2750, -1.0f, _2755)), (_2750 - _2747), mad(_2750, 0.5f, _2755)));
                              break;
                            }
                          }
                          _2765 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2769 = log2(max((lerp(_2682, _2680, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2770 = _2769 * 0.3010300099849701f;
                    do {
                      if (!(!(_2770 <= _2696))) {
                        _2839 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2777 = log2(ACESMidData.x);
                        float _2778 = _2777 * 0.3010300099849701f;
                        if ((bool)(_2770 > _2696) && (bool)(_2770 < _2778)) {
                          float _2786 = ((_2769 - _2695) * 0.9030900001525879f) / ((_2777 - _2695) * 0.3010300099849701f);
                          int _2787 = int(_2786);
                          float _2789 = _2786 - float((int)(_2787));
                          float _2791 = _8[_2787];
                          float _2794 = _8[(_2787 + 1)];
                          float _2799 = _2791 * 0.5f;
                          _2839 = dot(float3((_2789 * _2789), _2789, 1.0f), float3(mad((_8[(_2787 + 2)]), 0.5f, mad(_2794, -1.0f, _2799)), (_2794 - _2791), mad(_2794, 0.5f, _2799)));
                        } else {
                          do {
                            if (!(!(_2770 >= _2778))) {
                              float _2808 = log2(ACESMinMaxData.z);
                              if (_2770 < (_2808 * 0.3010300099849701f)) {
                                float _2816 = ((_2769 - _2777) * 0.9030900001525879f) / ((_2808 - _2777) * 0.3010300099849701f);
                                int _2817 = int(_2816);
                                float _2819 = _2816 - float((int)(_2817));
                                float _2821 = _9[_2817];
                                float _2824 = _9[(_2817 + 1)];
                                float _2829 = _2821 * 0.5f;
                                _2839 = dot(float3((_2819 * _2819), _2819, 1.0f), float3(mad((_9[(_2817 + 2)]), 0.5f, mad(_2824, -1.0f, _2829)), (_2824 - _2821), mad(_2824, 0.5f, _2829)));
                                break;
                              }
                            }
                            _2839 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2843 = log2(max((lerp(_2682, _2681, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2844 = _2843 * 0.3010300099849701f;
                      do {
                        if (!(!(_2844 <= _2696))) {
                          _2913 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2851 = log2(ACESMidData.x);
                          float _2852 = _2851 * 0.3010300099849701f;
                          if ((bool)(_2844 > _2696) && (bool)(_2844 < _2852)) {
                            float _2860 = ((_2843 - _2695) * 0.9030900001525879f) / ((_2851 - _2695) * 0.3010300099849701f);
                            int _2861 = int(_2860);
                            float _2863 = _2860 - float((int)(_2861));
                            float _2865 = _8[_2861];
                            float _2868 = _8[(_2861 + 1)];
                            float _2873 = _2865 * 0.5f;
                            _2913 = dot(float3((_2863 * _2863), _2863, 1.0f), float3(mad((_8[(_2861 + 2)]), 0.5f, mad(_2868, -1.0f, _2873)), (_2868 - _2865), mad(_2868, 0.5f, _2873)));
                          } else {
                            do {
                              if (!(!(_2844 >= _2852))) {
                                float _2882 = log2(ACESMinMaxData.z);
                                if (_2844 < (_2882 * 0.3010300099849701f)) {
                                  float _2890 = ((_2843 - _2851) * 0.9030900001525879f) / ((_2882 - _2851) * 0.3010300099849701f);
                                  int _2891 = int(_2890);
                                  float _2893 = _2890 - float((int)(_2891));
                                  float _2895 = _9[_2891];
                                  float _2898 = _9[(_2891 + 1)];
                                  float _2903 = _2895 * 0.5f;
                                  _2913 = dot(float3((_2893 * _2893), _2893, 1.0f), float3(mad((_9[(_2891 + 2)]), 0.5f, mad(_2898, -1.0f, _2903)), (_2898 - _2895), mad(_2898, 0.5f, _2903)));
                                  break;
                                }
                              }
                              _2913 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2917 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _2918 = (exp2(_2765 * 3.321928024291992f) - ACESMinMaxData.y) / _2917;
                        float _2920 = (exp2(_2839 * 3.321928024291992f) - ACESMinMaxData.y) / _2917;
                        float _2922 = (exp2(_2913 * 3.321928024291992f) - ACESMinMaxData.y) / _2917;
                        float _2925 = mad(0.15618768334388733f, _2922, mad(0.13400420546531677f, _2920, (_2918 * 0.6624541878700256f)));
                        float _2928 = mad(0.053689517080783844f, _2922, mad(0.6740817427635193f, _2920, (_2918 * 0.2722287178039551f)));
                        float _2931 = mad(1.0103391408920288f, _2922, mad(0.00406073359772563f, _2920, (_2918 * -0.005574649665504694f)));
                        float _2944 = min(max(mad(-0.23642469942569733f, _2931, mad(-0.32480329275131226f, _2928, (_2925 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2945 = min(max(mad(0.016756348311901093f, _2931, mad(1.6153316497802734f, _2928, (_2925 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2946 = min(max(mad(0.9883948564529419f, _2931, mad(-0.008284442126750946f, _2928, (_2925 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2949 = mad(0.15618768334388733f, _2946, mad(0.13400420546531677f, _2945, (_2944 * 0.6624541878700256f)));
                        float _2952 = mad(0.053689517080783844f, _2946, mad(0.6740817427635193f, _2945, (_2944 * 0.2722287178039551f)));
                        float _2955 = mad(1.0103391408920288f, _2946, mad(0.00406073359772563f, _2945, (_2944 * -0.005574649665504694f)));
                        float _2977 = min(max((min(max(mad(-0.23642469942569733f, _2955, mad(-0.32480329275131226f, _2952, (_2949 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2978 = min(max((min(max(mad(0.016756348311901093f, _2955, mad(1.6153316497802734f, _2952, (_2949 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2979 = min(max((min(max(mad(0.9883948564529419f, _2955, mad(-0.008284442126750946f, _2952, (_2949 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 6)) {
                            float _2982 = dot(float3(_2977, _2978, _2979), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                            float _2983 = _1718 * 300.0f;
                            float _2984 = _1721 * 300.0f;
                            float _2985 = _1724 * 300.0f;
                            do {
                              [branch]
                              if (!(_2982 < 1.0f)) {
                                if (_2982 < 5.0f) {
                                  float _2991 = (_2982 + -1.0f) * 0.25f;
                                  _3018 = ((_2991 * (_2983 - _2977)) + _2977);
                                  _3019 = ((_2991 * (_2984 - _2978)) + _2978);
                                  _3020 = ((_2991 * (_2985 - _2979)) + _2979);
                                } else {
                                  if (!(_2982 < 50.0f)) {
                                    if (_2982 < 150.0f) {
                                      float _3007 = (_2982 + -50.0f) * 0.009999999776482582f;
                                      _3018 = ((_3007 * (_2977 - _2983)) + _2983);
                                      _3019 = ((_3007 * (_2978 - _2984)) + _2984);
                                      _3020 = ((_3007 * (_2979 - _2985)) + _2985);
                                    } else {
                                      _3018 = _2977;
                                      _3019 = _2978;
                                      _3020 = _2979;
                                    }
                                  } else {
                                    _3018 = _2983;
                                    _3019 = _2984;
                                    _3020 = _2985;
                                  }
                                }
                              } else {
                                _3018 = _2977;
                                _3019 = _2978;
                                _3020 = _2979;
                              }
                              _3031 = mad(_45, _3020, mad(_44, _3019, (_3018 * _43)));
                              _3032 = mad(_48, _3020, mad(_47, _3019, (_3018 * _46)));
                              _3033 = mad(_51, _3020, mad(_50, _3019, (_3018 * _49)));
                            } while (false);
                          } else {
                            _3031 = _2977;
                            _3032 = _2978;
                            _3033 = _2979;
                          }
                          float _3043 = exp2(log2(_3031 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _3044 = exp2(log2(_3032 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _3045 = exp2(log2(_3033 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _3186 = exp2(log2((1.0f / ((_3043 * 18.6875f) + 1.0f)) * ((_3043 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3187 = exp2(log2((1.0f / ((_3044 * 18.6875f) + 1.0f)) * ((_3044 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3188 = exp2(log2((1.0f / ((_3045 * 18.6875f) + 1.0f)) * ((_3045 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _3078 = mad((WorkingColorSpace_ToAP1[0].z), _1694, mad((WorkingColorSpace_ToAP1[0].y), _1693, ((WorkingColorSpace_ToAP1[0].x) * _1692)));
            float _3081 = mad((WorkingColorSpace_ToAP1[1].z), _1694, mad((WorkingColorSpace_ToAP1[1].y), _1693, ((WorkingColorSpace_ToAP1[1].x) * _1692)));
            float _3084 = mad((WorkingColorSpace_ToAP1[2].z), _1694, mad((WorkingColorSpace_ToAP1[2].y), _1693, ((WorkingColorSpace_ToAP1[2].x) * _1692)));
            float _3103 = exp2(log2(mad(_45, _3084, mad(_44, _3081, (_3078 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _3104 = exp2(log2(mad(_48, _3084, mad(_47, _3081, (_3078 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _3105 = exp2(log2(mad(_51, _3084, mad(_50, _3081, (_3078 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3186 = exp2(log2((1.0f / ((_3103 * 18.6875f) + 1.0f)) * ((_3103 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3187 = exp2(log2((1.0f / ((_3104 * 18.6875f) + 1.0f)) * ((_3104 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3188 = exp2(log2((1.0f / ((_3105 * 18.6875f) + 1.0f)) * ((_3105 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _3140 = mad((WorkingColorSpace_ToAP1[0].z), _1682, mad((WorkingColorSpace_ToAP1[0].y), _1681, ((WorkingColorSpace_ToAP1[0].x) * _1680)));
                float _3143 = mad((WorkingColorSpace_ToAP1[1].z), _1682, mad((WorkingColorSpace_ToAP1[1].y), _1681, ((WorkingColorSpace_ToAP1[1].x) * _1680)));
                float _3146 = mad((WorkingColorSpace_ToAP1[2].z), _1682, mad((WorkingColorSpace_ToAP1[2].y), _1681, ((WorkingColorSpace_ToAP1[2].x) * _1680)));
                _3186 = mad(_45, _3146, mad(_44, _3143, (_3140 * _43)));
                _3187 = mad(_48, _3146, mad(_47, _3143, (_3140 * _46)));
                _3188 = mad(_51, _3146, mad(_50, _3143, (_3140 * _49)));
              } else {
                float _3159 = mad((WorkingColorSpace_ToAP1[0].z), _1738, mad((WorkingColorSpace_ToAP1[0].y), _1737, ((WorkingColorSpace_ToAP1[0].x) * _1736)));
                float _3162 = mad((WorkingColorSpace_ToAP1[1].z), _1738, mad((WorkingColorSpace_ToAP1[1].y), _1737, ((WorkingColorSpace_ToAP1[1].x) * _1736)));
                float _3165 = mad((WorkingColorSpace_ToAP1[2].z), _1738, mad((WorkingColorSpace_ToAP1[2].y), _1737, ((WorkingColorSpace_ToAP1[2].x) * _1736)));
                _3186 = exp2(log2(mad(_45, _3165, mad(_44, _3162, (_3159 * _43)))) * InverseGamma.z);
                _3187 = exp2(log2(mad(_48, _3165, mad(_47, _3162, (_3159 * _46)))) * InverseGamma.z);
                _3188 = exp2(log2(mad(_51, _3165, mad(_50, _3162, (_3159 * _49)))) * InverseGamma.z);
              }
            } else {
              _3186 = _1692;
              _3187 = _1693;
              _3188 = _1694;
            }
          }
        }
      }
    }
  }

  SV_Target.x = (_3186 * 0.9523810148239136f);
  SV_Target.y = (_3187 * 0.9523810148239136f);
  SV_Target.z = (_3188 * 0.9523810148239136f); */

  SV_Target.rgb = float3(0, 0, 0); 
  SV_Target.w = 0.0f;
  return SV_Target;
}

// Found in Metal Gear Solid Delta Snake Eater

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> Textures_1 : register(t0);

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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
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
  float _114;
  float _115;
  float _116;
  float _541;
  float _716;
  float _808;
  float _841;
  float _855;
  float _919;
  float _1170;
  float _1203;
  float _1217;
  float _1388;
  float _1421;
  float _1435;
  float _1486;
  float _1661;
  float _1672;
  float _1683;
  float _1855;
  float _1866;
  float _1877;
  float _1954;
  float _1955;
  float _1956;
  float _2057;
  float _2058;
  float _2059;
  float _2070;
  float _2081;
  float _2261;
  float _2294;
  float _2308;
  float _2347;
  float _2457;
  float _2531;
  float _2605;
  float _2684;
  float _2685;
  float _2686;
  float _2835;
  float _2868;
  float _2882;
  float _2921;
  float _3031;
  float _3105;
  float _3179;
  float _3258;
  float _3259;
  float _3260;
  float _3437;
  float _3438;
  float _3439;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _34 = (OutputGamut == 4);
        _45 = select(_34, 1.0f, 1.705051064491272f);
        _46 = select(_34, 0.0f, -0.6217921376228333f);
        _47 = select(_34, 0.0f, -0.0832589864730835f);
        _48 = select(_34, 0.0f, -0.13025647401809692f);
        _49 = select(_34, 1.0f, 1.140804648399353f);
        _50 = select(_34, 0.0f, -0.010548308491706848f);
        _51 = select(_34, 0.0f, -0.024003351107239723f);
        _52 = select(_34, 0.0f, -0.1289689838886261f);
        _53 = select(_34, 1.0f, 1.1529725790023804f);
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
      _45 = 1.0258246660232544f;
      _46 = -0.020053181797266006f;
      _47 = -0.005771636962890625f;
      _48 = -0.002234415616840124f;
      _49 = 1.0045864582061768f;
      _50 = -0.002352118492126465f;
      _51 = -0.005013350863009691f;
      _52 = -0.025290070101618767f;
      _53 = 1.0303035974502563f;
    }
  } else {
    _45 = 1.3792141675949097f;
    _46 = -0.30886411666870117f;
    _47 = -0.0703500509262085f;
    _48 = -0.06933490186929703f;
    _49 = 1.08229660987854f;
    _50 = -0.012961871922016144f;
    _51 = -0.0021590073592960835f;
    _52 = -0.0454593189060688f;
    _53 = 1.0476183891296387f;
  }
  if ((uint)OutputDevice > (uint)2) {
    float _64 = (pow(_22, 0.012683313339948654f));
    float _65 = (pow(_23, 0.012683313339948654f));
    float _66 = (pow(_25, 0.012683313339948654f));
    float _91 = exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 100.0f;
    float _92 = exp2(log2(max(0.0f, (_65 + -0.8359375f)) / (18.8515625f - (_65 * 18.6875f))) * 6.277394771575928f) * 100.0f;
    float _93 = exp2(log2(max(0.0f, (_66 + -0.8359375f)) / (18.8515625f - (_66 * 18.6875f))) * 6.277394771575928f) * 100.0f;
    _111 = _91;
    _112 = _92;
    _113 = _93;
    _114 = _91;
    _115 = _92;
    _116 = _93;
  } else {
    _111 = ((exp2((_22 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _112 = ((exp2((_23 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _113 = ((exp2((_25 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _114 = 0.0f;
    _115 = 0.0f;
    _116 = 0.0f;
  }
  float _131 = mad((WorkingColorSpace_ToAP1[0].z), _113, mad((WorkingColorSpace_ToAP1[0].y), _112, ((WorkingColorSpace_ToAP1[0].x) * _111)));
  float _134 = mad((WorkingColorSpace_ToAP1[1].z), _113, mad((WorkingColorSpace_ToAP1[1].y), _112, ((WorkingColorSpace_ToAP1[1].x) * _111)));
  float _137 = mad((WorkingColorSpace_ToAP1[2].z), _113, mad((WorkingColorSpace_ToAP1[2].y), _112, ((WorkingColorSpace_ToAP1[2].x) * _111)));
  float _138 = dot(float3(_131, _134, _137), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _142 = (_131 / _138) + -1.0f;
  float _143 = (_134 / _138) + -1.0f;
  float _144 = (_137 / _138) + -1.0f;

  // float _156 = (1.0f - exp2(((_138 * _138) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_142, _143, _144), float3(_142, _143, _144)) * -4.0f));
  float _156 = (1.0f - exp2(((_138 * _138) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_142, _143, _144), float3(_142, _143, _144)) * -4.0f));

  float _172 = ((mad(-0.06368321925401688f, _137, mad(-0.3292922377586365f, _134, (_131 * 1.3704125881195068f))) - _131) * _156) + _131;
  float _173 = ((mad(-0.010861365124583244f, _137, mad(1.0970927476882935f, _134, (_131 * -0.08343357592821121f))) - _134) * _156) + _134;
  float _174 = ((mad(1.2036951780319214f, _137, mad(-0.09862580895423889f, _134, (_131 * -0.02579331398010254f))) - _137) * _156) + _137;
  float _175 = dot(float3(_172, _173, _174), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _189 = ColorOffset.w + ColorOffsetShadows.w;
  float _203 = ColorGain.w * ColorGainShadows.w;
  float _217 = ColorGamma.w * ColorGammaShadows.w;
  float _231 = ColorContrast.w * ColorContrastShadows.w;
  float _245 = ColorSaturation.w * ColorSaturationShadows.w;
  float _246 = (ColorSaturation.x * ColorSaturationShadows.x) * _245;
  float _247 = (ColorSaturation.y * ColorSaturationShadows.y) * _245;
  float _248 = (ColorSaturation.z * ColorSaturationShadows.z) * _245;
  float _249 = _172 - _175;
  float _250 = _173 - _175;
  float _251 = _174 - _175;
  float _261 = (ColorContrast.x * ColorContrastShadows.x) * _231;
  float _262 = (ColorContrast.y * ColorContrastShadows.y) * _231;
  float _263 = (ColorContrast.z * ColorContrastShadows.z) * _231;
  float _282 = 1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _217);
  float _283 = 1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _217);
  float _284 = 1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _217);
  float _294 = (ColorGain.x * ColorGainShadows.x) * _203;
  float _295 = (ColorGain.y * ColorGainShadows.y) * _203;
  float _296 = (ColorGain.z * ColorGainShadows.z) * _203;
  float _300 = (ColorOffset.x + ColorOffsetShadows.x) + _189;
  float _301 = (ColorOffset.y + ColorOffsetShadows.y) + _189;
  float _302 = (ColorOffset.z + ColorOffsetShadows.z) + _189;
  float _303 = _300 + (_294 * exp2(log2(exp2(_261 * log2(max(0.0f, ((_246 * _249) + _175)) * 5.55555534362793f)) * 0.18000000715255737f) * _282));
  float _304 = _301 + (_295 * exp2(log2(exp2(_262 * log2(max(0.0f, ((_247 * _250) + _175)) * 5.55555534362793f)) * 0.18000000715255737f) * _283));
  float _305 = _302 + (_296 * exp2(log2(exp2(_263 * log2(max(0.0f, ((_248 * _251) + _175)) * 5.55555534362793f)) * 0.18000000715255737f) * _284));
  float _308 = saturate(_175 / ColorCorrectionShadowsMax);
  float _312 = (_308 * _308) * (3.0f - (_308 * 2.0f));
  float _313 = 1.0f - _312;
  float _322 = ColorOffset.w + ColorOffsetHighlights.w;
  float _331 = ColorGain.w * ColorGainHighlights.w;
  float _340 = ColorGamma.w * ColorGammaHighlights.w;
  float _349 = ColorContrast.w * ColorContrastHighlights.w;
  float _358 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _359 = (ColorSaturation.x * ColorSaturationHighlights.x) * _358;
  float _360 = (ColorSaturation.y * ColorSaturationHighlights.y) * _358;
  float _361 = (ColorSaturation.z * ColorSaturationHighlights.z) * _358;
  float _371 = (ColorContrast.x * ColorContrastHighlights.x) * _349;
  float _372 = (ColorContrast.y * ColorContrastHighlights.y) * _349;
  float _373 = (ColorContrast.z * ColorContrastHighlights.z) * _349;
  float _392 = 1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _340);
  float _393 = 1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _340);
  float _394 = 1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _340);
  float _404 = (ColorGain.x * ColorGainHighlights.x) * _331;
  float _405 = (ColorGain.y * ColorGainHighlights.y) * _331;
  float _406 = (ColorGain.z * ColorGainHighlights.z) * _331;
  float _410 = (ColorOffset.x + ColorOffsetHighlights.x) + _322;
  float _411 = (ColorOffset.y + ColorOffsetHighlights.y) + _322;
  float _412 = (ColorOffset.z + ColorOffsetHighlights.z) + _322;
  float _418 = ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin;
  float _421 = saturate((_175 - ColorCorrectionHighlightsMin) / _418);
  float _425 = (_421 * _421) * (3.0f - (_421 * 2.0f));
  float _437 = ColorOffset.w + ColorOffsetMidtones.w;
  float _446 = ColorGain.w * ColorGainMidtones.w;
  float _455 = ColorGamma.w * ColorGammaMidtones.w;
  float _464 = ColorContrast.w * ColorContrastMidtones.w;
  float _473 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _474 = (ColorSaturation.x * ColorSaturationMidtones.x) * _473;
  float _475 = (ColorSaturation.y * ColorSaturationMidtones.y) * _473;
  float _476 = (ColorSaturation.z * ColorSaturationMidtones.z) * _473;
  float _486 = (ColorContrast.x * ColorContrastMidtones.x) * _464;
  float _487 = (ColorContrast.y * ColorContrastMidtones.y) * _464;
  float _488 = (ColorContrast.z * ColorContrastMidtones.z) * _464;
  float _507 = 1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _455);
  float _508 = 1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _455);
  float _509 = 1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _455);
  float _519 = (ColorGain.x * ColorGainMidtones.x) * _446;
  float _520 = (ColorGain.y * ColorGainMidtones.y) * _446;
  float _521 = (ColorGain.z * ColorGainMidtones.z) * _446;
  float _525 = (ColorOffset.x + ColorOffsetMidtones.x) + _437;
  float _526 = (ColorOffset.y + ColorOffsetMidtones.y) + _437;
  float _527 = (ColorOffset.z + ColorOffsetMidtones.z) + _437;
  float _528 = _525 + (_519 * exp2(log2(exp2(_486 * log2(max(0.0f, ((_474 * _249) + _175)) * 5.55555534362793f)) * 0.18000000715255737f) * _507));
  float _529 = _526 + (_520 * exp2(log2(exp2(_487 * log2(max(0.0f, ((_475 * _250) + _175)) * 5.55555534362793f)) * 0.18000000715255737f) * _508));
  float _530 = _527 + (_521 * exp2(log2(exp2(_488 * log2(max(0.0f, ((_476 * _251) + _175)) * 5.55555534362793f)) * 0.18000000715255737f) * _509));
  if ((bool)(_313 > 0.5f) && (bool)(dot(float3(_528, _529, _530), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)) < dot(float3(_303, _304, _305), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)))) {
    _541 = (_313 - (_313 * (0.6000000238418579f - _312)));
  } else {
    _541 = _313;
  }
  float _543 = (1.0f - _541) - _425;
  float _554 = ((_541 * _303) + (_425 * min(1e+05f, (_410 + (_404 * exp2(log2(exp2(_371 * log2(max(0.0f, ((_359 * _249) + _175)) * 5.55555534362793f)) * 0.18000000715255737f) * _392)))))) + (_543 * _528);
  float _556 = ((_541 * _304) + (_425 * min(1e+05f, (_411 + (_405 * exp2(log2(exp2(_372 * log2(max(0.0f, ((_360 * _250) + _175)) * 5.55555534362793f)) * 0.18000000715255737f) * _393)))))) + (_543 * _529);
  float _558 = ((_541 * _305) + (min(1e+05f, (_412 + (_406 * exp2(log2(exp2(_373 * log2(max(0.0f, ((_361 * _251) + _175)) * 5.55555534362793f)) * 0.18000000715255737f) * _394)))) * _425)) + (_543 * _530);
  float _561 = mad((WorkingColorSpace_ToAP1[0].z), _116, mad((WorkingColorSpace_ToAP1[0].y), _115, ((WorkingColorSpace_ToAP1[0].x) * _114)));
  float _564 = mad((WorkingColorSpace_ToAP1[1].z), _116, mad((WorkingColorSpace_ToAP1[1].y), _115, ((WorkingColorSpace_ToAP1[1].x) * _114)));
  float _567 = mad((WorkingColorSpace_ToAP1[2].z), _116, mad((WorkingColorSpace_ToAP1[2].y), _115, ((WorkingColorSpace_ToAP1[2].x) * _114)));
  float _568 = dot(float3(_561, _564, _567), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _569 = _561 - _568;
  float _570 = _564 - _568;
  float _571 = _567 - _568;
  float _608 = _300 + (_294 * exp2(log2(exp2(_261 * log2(max(0.0f, ((_246 * _569) + _568)) * 5.55555534362793f)) * 0.18000000715255737f) * _282));
  float _609 = _301 + (_295 * exp2(log2(exp2(_262 * log2(max(0.0f, ((_247 * _570) + _568)) * 5.55555534362793f)) * 0.18000000715255737f) * _283));
  float _610 = _302 + (_296 * exp2(log2(exp2(_263 * log2(max(0.0f, ((_248 * _571) + _568)) * 5.55555534362793f)) * 0.18000000715255737f) * _284));
  float _612 = saturate(_568 / ColorCorrectionShadowsMax);
  float _616 = (_612 * _612) * (3.0f - (_612 * 2.0f));
  float _617 = 1.0f - _616;
  float _659 = saturate((_568 - ColorCorrectionHighlightsMin) / _418);
  float _663 = (_659 * _659) * (3.0f - (_659 * 2.0f));
  float _703 = _525 + (_519 * exp2(log2(exp2(_486 * log2(max(0.0f, ((_474 * _569) + _568)) * 5.55555534362793f)) * 0.18000000715255737f) * _507));
  float _704 = _526 + (_520 * exp2(log2(exp2(_487 * log2(max(0.0f, ((_475 * _570) + _568)) * 5.55555534362793f)) * 0.18000000715255737f) * _508));
  float _705 = _527 + (_521 * exp2(log2(exp2(_488 * log2(max(0.0f, ((_476 * _571) + _568)) * 5.55555534362793f)) * 0.18000000715255737f) * _509));
  if ((bool)(_617 > 0.5f) && (bool)(dot(float3(_703, _704, _705), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)) < dot(float3(_608, _609, _610), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)))) {
    _716 = (_617 - (_617 * (0.6000000238418579f - _616)));
  } else {
    _716 = _617;
  }
  float _718 = (1.0f - _716) - _663;
  float _729 = ((_716 * _608) + (_663 * min(1e+05f, (_410 + (_404 * exp2(log2(exp2(_371 * log2(max(0.0f, ((_359 * _569) + _568)) * 5.55555534362793f)) * 0.18000000715255737f) * _392)))))) + (_718 * _703);
  float _731 = ((_716 * _609) + (_663 * min(1e+05f, (_411 + (_405 * exp2(log2(exp2(_372 * log2(max(0.0f, ((_360 * _570) + _568)) * 5.55555534362793f)) * 0.18000000715255737f) * _393)))))) + (_718 * _704);
  float _733 = ((_716 * _610) + (min(1e+05f, (_412 + (_406 * exp2(log2(exp2(_373 * log2(max(0.0f, ((_361 * _571) + _568)) * 5.55555534362793f)) * 0.18000000715255737f) * _394)))) * _663)) + (_718 * _705);

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = FilmBlackClip;
  cb_config.ue_filmtoe = FilmToe;
  cb_config.ue_filmshoulder = FilmShoulder;
  cb_config.ue_filmslope = FilmSlope;
  cb_config.ue_filmwhiteclip = FilmWhiteClip;
  cb_config.ue_tonecurveammount = ToneCurveAmount;
  cb_config.ue_mappingpolynomial = MappingPolynomial;
  cb_config.ue_overlaycolor = OverlayColor;
  cb_config.ue_bluecorrection = BlueCorrection;
  cb_config.ue_colorscale = ColorScale;
  cb_config.ue_lutweights = LUTWeights;

  SV_Target = ProcessLutbuilder(float3(_729, _731, _733), Samplers_1, Textures_1, cb_config, SV_Target, OutputDevice);
  return SV_Target;

  float _748 = ((mad(0.061360642313957214f, _558, mad(-4.540197551250458e-09f, _556, (_554 * 0.9386394023895264f))) - _554) * BlueCorrection) + _554;
  float _749 = ((mad(0.169205904006958f, _558, mad(0.8307942152023315f, _556, (_554 * 6.775371730327606e-08f))) - _556) * BlueCorrection) + _556;
  float _750 = (mad(-2.3283064365386963e-10f, _556, (_554 * -9.313225746154785e-10f)) * BlueCorrection) + _558;
  float _753 = mad(0.16386905312538147f, _750, mad(0.14067868888378143f, _749, (_748 * 0.6954522132873535f)));
  float _756 = mad(0.0955343246459961f, _750, mad(0.8596711158752441f, _749, (_748 * 0.044794581830501556f)));
  float _759 = mad(1.0015007257461548f, _750, mad(0.004025210160762072f, _749, (_748 * -0.005525882821530104f)));
  float _763 = max(max(_753, _756), _759);
  float _768 = (max(_763, 1.000000013351432e-10f) - max(min(min(_753, _756), _759), 1.000000013351432e-10f)) / max(_763, 0.009999999776482582f);
  float _781 = ((_756 + _753) + _759) + (sqrt((((_759 - _756) * _759) + ((_756 - _753) * _756)) + ((_753 - _759) * _753)) * 1.75f);
  float _782 = _781 * 0.3333333432674408f;
  float _783 = _768 + -0.4000000059604645f;
  float _784 = _783 * 5.0f;
  float _788 = max((1.0f - abs(_783 * 2.5f)), 0.0f);
  float _799 = ((float((int)(((int)(uint)((bool)(_784 > 0.0f))) - ((int)(uint)((bool)(_784 < 0.0f))))) * (1.0f - (_788 * _788))) + 1.0f) * 0.02500000037252903f;
  if (!(_782 <= 0.0533333346247673f)) {
    if (!(_782 >= 0.1599999964237213f)) {
      _808 = (((0.23999999463558197f / _781) + -0.5f) * _799);
    } else {
      _808 = 0.0f;
    }
  } else {
    _808 = _799;
  }
  float _809 = _808 + 1.0f;
  float _810 = _809 * _753;
  float _811 = _809 * _756;
  float _812 = _809 * _759;
  if (!((bool)(_810 == _811) && (bool)(_811 == _812))) {
    float _819 = ((_810 * 2.0f) - _811) - _812;
    float _822 = ((_756 - _759) * 1.7320507764816284f) * _809;
    float _824 = atan(_822 / _819);
    bool _827 = (_819 < 0.0f);
    bool _828 = (_819 == 0.0f);
    bool _829 = (_822 >= 0.0f);
    bool _830 = (_822 < 0.0f);
    _841 = select((_829 && _828), 90.0f, select((_830 && _828), -90.0f, (select((_830 && _827), (_824 + -3.1415927410125732f), select((_829 && _827), (_824 + 3.1415927410125732f), _824)) * 57.2957763671875f)));
  } else {
    _841 = 0.0f;
  }
  float _846 = min(max(select((_841 < 0.0f), (_841 + 360.0f), _841), 0.0f), 360.0f);
  if (_846 < -180.0f) {
    _855 = (_846 + 360.0f);
  } else {
    if (_846 > 180.0f) {
      _855 = (_846 + -360.0f);
    } else {
      _855 = _846;
    }
  }
  float _859 = saturate(1.0f - abs(_855 * 0.014814814552664757f));
  float _863 = (_859 * _859) * (3.0f - (_859 * 2.0f));
  float _869 = ((_863 * _863) * ((_768 * 0.18000000715255737f) * (0.029999999329447746f - _810))) + _810;
  float _879 = max(0.0f, mad(-0.21492856740951538f, _812, mad(-0.2365107536315918f, _811, (_869 * 1.4514392614364624f))));
  float _880 = max(0.0f, mad(-0.09967592358589172f, _812, mad(1.17622971534729f, _811, (_869 * -0.07655377686023712f))));
  float _881 = max(0.0f, mad(0.9977163076400757f, _812, mad(-0.006032449658960104f, _811, (_869 * 0.008316148072481155f))));
  float _882 = dot(float3(_879, _880, _881), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _897 = (FilmBlackClip + 1.0f) - FilmToe;
  float _899 = FilmWhiteClip + 1.0f;
  float _901 = _899 - FilmShoulder;
  bool _902 = (FilmToe > 0.800000011920929f);
  if (_902) {
    _919 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _910 = (FilmBlackClip + 0.18000000715255737f) / _897;
    _919 = (-0.7447274923324585f - ((log2(_910 / (2.0f - _910)) * 0.3465735912322998f) * (_897 / FilmSlope)));
  }
  float _921 = (1.0f - FilmToe) / FilmSlope;
  float _922 = _921 - _919;
  float _923 = FilmShoulder / FilmSlope;
  float _924 = _923 - _922;
  float _928 = log2(lerp(_882, _879, 0.9599999785423279f)) * 0.3010300099849701f;
  float _929 = log2(lerp(_882, _880, 0.9599999785423279f)) * 0.3010300099849701f;
  float _930 = log2(lerp(_882, _881, 0.9599999785423279f)) * 0.3010300099849701f;
  float _934 = FilmSlope * (_928 + _922);
  float _935 = FilmSlope * (_929 + _922);
  float _936 = FilmSlope * (_930 + _922);
  float _937 = _897 * 2.0f;
  float _939 = (FilmSlope * -2.0f) / _897;
  float _940 = _928 - _919;
  float _941 = _929 - _919;
  float _942 = _930 - _919;
  float _961 = _901 * 2.0f;
  float _963 = (FilmSlope * 2.0f) / _901;
  float _988 = select((_928 < _919), ((_937 / (exp2((_940 * 1.4426950216293335f) * _939) + 1.0f)) - FilmBlackClip), _934);
  float _989 = select((_929 < _919), ((_937 / (exp2((_941 * 1.4426950216293335f) * _939) + 1.0f)) - FilmBlackClip), _935);
  float _990 = select((_930 < _919), ((_937 / (exp2((_942 * 1.4426950216293335f) * _939) + 1.0f)) - FilmBlackClip), _936);
  float _997 = _924 - _919;
  float _1001 = saturate(_940 / _997);
  float _1002 = saturate(_941 / _997);
  float _1003 = saturate(_942 / _997);
  bool _1004 = (_924 < _919);
  float _1008 = select(_1004, (1.0f - _1001), _1001);
  float _1009 = select(_1004, (1.0f - _1002), _1002);
  float _1010 = select(_1004, (1.0f - _1003), _1003);
  float _1029 = (((_1008 * _1008) * (select((_928 > _924), (_899 - (_961 / (exp2(((_928 - _924) * 1.4426950216293335f) * _963) + 1.0f))), _934) - _988)) * (3.0f - (_1008 * 2.0f))) + _988;
  float _1030 = (((_1009 * _1009) * (select((_929 > _924), (_899 - (_961 / (exp2(((_929 - _924) * 1.4426950216293335f) * _963) + 1.0f))), _935) - _989)) * (3.0f - (_1009 * 2.0f))) + _989;
  float _1031 = (((_1010 * _1010) * (select((_930 > _924), (_899 - (_961 / (exp2(((_930 - _924) * 1.4426950216293335f) * _963) + 1.0f))), _936) - _990)) * (3.0f - (_1010 * 2.0f))) + _990;
  float _1032 = dot(float3(_1029, _1030, _1031), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1052 = (ToneCurveAmount * (max(0.0f, (lerp(_1032, _1029, 0.9300000071525574f))) - _748)) + _748;
  float _1053 = (ToneCurveAmount * (max(0.0f, (lerp(_1032, _1030, 0.9300000071525574f))) - _749)) + _749;
  float _1054 = (ToneCurveAmount * (max(0.0f, (lerp(_1032, _1031, 0.9300000071525574f))) - _750)) + _750;
  float _1070 = ((mad(-0.06537103652954102f, _1054, mad(1.451815478503704e-06f, _1053, (_1052 * 1.065374732017517f))) - _1052) * BlueCorrection) + _1052;
  float _1071 = ((mad(-0.20366770029067993f, _1054, mad(1.2036634683609009f, _1053, (_1052 * -2.57161445915699e-07f))) - _1053) * BlueCorrection) + _1053;
  float _1072 = ((mad(0.9999996423721313f, _1054, mad(2.0954757928848267e-08f, _1053, (_1052 * 1.862645149230957e-08f))) - _1054) * BlueCorrection) + _1054;
  float _1110 = ((mad(0.061360642313957214f, _733, mad(-4.540197551250458e-09f, _731, (_729 * 0.9386394023895264f))) - _729) * BlueCorrection) + _729;
  float _1111 = ((mad(0.169205904006958f, _733, mad(0.8307942152023315f, _731, (_729 * 6.775371730327606e-08f))) - _731) * BlueCorrection) + _731;
  float _1112 = (mad(-2.3283064365386963e-10f, _731, (_729 * -9.313225746154785e-10f)) * BlueCorrection) + _733;
  float _1115 = mad(0.16386905312538147f, _1112, mad(0.14067868888378143f, _1111, (_1110 * 0.6954522132873535f)));
  float _1118 = mad(0.0955343246459961f, _1112, mad(0.8596711158752441f, _1111, (_1110 * 0.044794581830501556f)));
  float _1121 = mad(1.0015007257461548f, _1112, mad(0.004025210160762072f, _1111, (_1110 * -0.005525882821530104f)));
  float _1125 = max(max(_1115, _1118), _1121);
  float _1130 = (max(_1125, 1.000000013351432e-10f) - max(min(min(_1115, _1118), _1121), 1.000000013351432e-10f)) / max(_1125, 0.009999999776482582f);
  float _1143 = ((_1118 + _1115) + _1121) + (sqrt((((_1121 - _1118) * _1121) + ((_1118 - _1115) * _1118)) + ((_1115 - _1121) * _1115)) * 1.75f);
  float _1144 = _1143 * 0.3333333432674408f;
  float _1145 = _1130 + -0.4000000059604645f;
  float _1146 = _1145 * 5.0f;
  float _1150 = max((1.0f - abs(_1145 * 2.5f)), 0.0f);
  float _1161 = ((float((int)(((int)(uint)((bool)(_1146 > 0.0f))) - ((int)(uint)((bool)(_1146 < 0.0f))))) * (1.0f - (_1150 * _1150))) + 1.0f) * 0.02500000037252903f;
  bool _1162 = !(_1144 <= 0.0533333346247673f);
  if (_1162) {
    if (!(_1144 >= 0.1599999964237213f)) {
      _1170 = (((0.23999999463558197f / _1143) + -0.5f) * _1161);
    } else {
      _1170 = 0.0f;
    }
  } else {
    _1170 = _1161;
  }
  float _1171 = _1170 + 1.0f;
  float _1172 = _1171 * _1115;
  float _1173 = _1171 * _1118;
  float _1174 = _1171 * _1121;
  if (!((bool)(_1172 == _1173) && (bool)(_1173 == _1174))) {
    float _1181 = ((_1172 * 2.0f) - _1173) - _1174;
    float _1184 = ((_1118 - _1121) * 1.7320507764816284f) * _1171;
    float _1186 = atan(_1184 / _1181);
    bool _1189 = (_1181 < 0.0f);
    bool _1190 = (_1181 == 0.0f);
    bool _1191 = (_1184 >= 0.0f);
    bool _1192 = (_1184 < 0.0f);
    _1203 = select((_1191 && _1190), 90.0f, select((_1192 && _1190), -90.0f, (select((_1192 && _1189), (_1186 + -3.1415927410125732f), select((_1191 && _1189), (_1186 + 3.1415927410125732f), _1186)) * 57.2957763671875f)));
  } else {
    _1203 = 0.0f;
  }
  float _1208 = min(max(select((_1203 < 0.0f), (_1203 + 360.0f), _1203), 0.0f), 360.0f);
  if (_1208 < -180.0f) {
    _1217 = (_1208 + 360.0f);
  } else {
    if (_1208 > 180.0f) {
      _1217 = (_1208 + -360.0f);
    } else {
      _1217 = _1208;
    }
  }
  float _1221 = saturate(1.0f - abs(_1217 * 0.014814814552664757f));
  float _1225 = (_1221 * _1221) * (3.0f - (_1221 * 2.0f));
  float _1227 = _1130 * 0.18000000715255737f;
  float _1231 = ((_1225 * _1225) * (_1227 * (0.029999999329447746f - _1172))) + _1172;
  float _1241 = max(0.0f, mad(-0.21492856740951538f, _1174, mad(-0.2365107536315918f, _1173, (_1231 * 1.4514392614364624f))));
  float _1242 = max(0.0f, mad(-0.09967592358589172f, _1174, mad(1.17622971534729f, _1173, (_1231 * -0.07655377686023712f))));
  float _1243 = max(0.0f, mad(0.9977163076400757f, _1174, mad(-0.006032449658960104f, _1173, (_1231 * 0.008316148072481155f))));
  float _1244 = dot(float3(_1241, _1242, _1243), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1254 = log2(lerp(_1244, _1241, 0.9599999785423279f));
  float _1255 = log2(lerp(_1244, _1242, 0.9599999785423279f));
  float _1256 = log2(lerp(_1244, _1243, 0.9599999785423279f));
  float _1257 = _1254 * 0.3010300099849701f;
  float _1258 = _1255 * 0.3010300099849701f;
  float _1259 = _1256 * 0.3010300099849701f;
  float _1261 = (_1254 * 0.2649064064025879f) + 0.7934439778327942f;
  float _1263 = (_1255 * 0.2649064064025879f) + 0.7934439778327942f;
  float _1265 = (_1256 * 0.2649064064025879f) + 0.7934439778327942f;
  float _1302 = select((_1257 < -0.39027726650238037f), (0.8999999761581421f / (exp2(-2.202155351638794f - (_1254 * 1.6985740661621094f)) + 1.0f)), _1261);
  float _1303 = select((_1258 < -0.39027726650238037f), (0.8999999761581421f / (exp2(-2.202155351638794f - (_1255 * 1.6985740661621094f)) + 1.0f)), _1263);
  float _1304 = select((_1259 < -0.39027726650238037f), (0.8999999761581421f / (exp2(-2.202155351638794f - (_1256 * 1.6985740661621094f)) + 1.0f)), _1265);
  float _1320 = 1.0f - saturate(-1.8075997829437256f - (_1254 * 1.3942440748214722f));
  float _1321 = 1.0f - saturate(-1.8075997829437256f - (_1255 * 1.3942440748214722f));
  float _1322 = 1.0f - saturate(-1.8075997829437256f - (_1256 * 1.3942440748214722f));
  float _1341 = (((_1320 * _1320) * (select((_1257 > -0.6061863899230957f), (1.0399999618530273f - (1.559999942779541f / (exp2((_1254 * 0.9799466133117676f) + 1.9733258485794067f) + 1.0f))), _1261) - _1302)) * (3.0f - (_1320 * 2.0f))) + _1302;
  float _1342 = (((_1321 * _1321) * (select((_1258 > -0.6061863899230957f), (1.0399999618530273f - (1.559999942779541f / (exp2((_1255 * 0.9799466133117676f) + 1.9733258485794067f) + 1.0f))), _1263) - _1303)) * (3.0f - (_1321 * 2.0f))) + _1303;
  float _1343 = (((_1322 * _1322) * (select((_1259 > -0.6061863899230957f), (1.0399999618530273f - (1.559999942779541f / (exp2((_1256 * 0.9799466133117676f) + 1.9733258485794067f) + 1.0f))), _1265) - _1304)) * (3.0f - (_1322 * 2.0f))) + _1304;
  float _1344 = dot(float3(_1341, _1342, _1343), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1363 = (ToneCurveAmount * (max(0.0f, (lerp(_1344, _1341, 0.9300000071525574f))) - _1110)) + _1110;
  float _1364 = (ToneCurveAmount * (max(0.0f, (lerp(_1344, _1342, 0.9300000071525574f))) - _1111)) + _1111;
  float _1365 = (ToneCurveAmount * (max(0.0f, (lerp(_1344, _1343, 0.9300000071525574f))) - _1112)) + _1112;
  if (_1162) {
    if (!(_1144 >= 0.1599999964237213f)) {
      _1388 = (((0.23999999463558197f / _1143) + -0.5f) * _1161);
    } else {
      _1388 = 0.0f;
    }
  } else {
    _1388 = _1161;
  }
  float _1389 = _1388 + 1.0f;
  float _1390 = _1389 * _1115;
  float _1391 = _1389 * _1118;
  float _1392 = _1389 * _1121;
  if (!((bool)(_1390 == _1391) && (bool)(_1391 == _1392))) {
    float _1399 = ((_1390 * 2.0f) - _1391) - _1392;
    float _1402 = ((_1118 - _1121) * 1.7320507764816284f) * _1389;
    float _1404 = atan(_1402 / _1399);
    bool _1407 = (_1399 < 0.0f);
    bool _1408 = (_1399 == 0.0f);
    bool _1409 = (_1402 >= 0.0f);
    bool _1410 = (_1402 < 0.0f);
    _1421 = select((_1409 && _1408), 90.0f, select((_1410 && _1408), -90.0f, (select((_1410 && _1407), (_1404 + -3.1415927410125732f), select((_1409 && _1407), (_1404 + 3.1415927410125732f), _1404)) * 57.2957763671875f)));
  } else {
    _1421 = 0.0f;
  }
  float _1426 = min(max(select((_1421 < 0.0f), (_1421 + 360.0f), _1421), 0.0f), 360.0f);
  if (_1426 < -180.0f) {
    _1435 = (_1426 + 360.0f);
  } else {
    if (_1426 > 180.0f) {
      _1435 = (_1426 + -360.0f);
    } else {
      _1435 = _1426;
    }
  }
  float _1439 = saturate(1.0f - abs(_1435 * 0.014814814552664757f));
  float _1443 = (_1439 * _1439) * (3.0f - (_1439 * 2.0f));
  float _1448 = ((_1443 * _1443) * (_1227 * (0.029999999329447746f - _1390))) + _1390;
  float _1458 = max(0.0f, mad(-0.21492856740951538f, _1392, mad(-0.2365107536315918f, _1391, (_1448 * 1.4514392614364624f))));
  float _1459 = max(0.0f, mad(-0.09967592358589172f, _1392, mad(1.17622971534729f, _1391, (_1448 * -0.07655377686023712f))));
  float _1460 = max(0.0f, mad(0.9977163076400757f, _1392, mad(-0.006032449658960104f, _1391, (_1448 * 0.008316148072481155f))));
  float _1461 = dot(float3(_1458, _1459, _1460), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  if (_902) {
    _1486 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _1477 = (FilmBlackClip + 0.18000000715255737f) / _897;
    _1486 = (-0.7447274923324585f - ((log2(_1477 / (2.0f - _1477)) * 0.3465735912322998f) * (_897 / FilmSlope)));
  }
  float _1487 = _921 - _1486;
  float _1488 = _923 - _1487;
  float _1492 = log2(lerp(_1461, _1458, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1493 = log2(lerp(_1461, _1459, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1494 = log2(lerp(_1461, _1460, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1498 = FilmSlope * (_1492 + _1487);
  float _1499 = FilmSlope * (_1493 + _1487);
  float _1500 = FilmSlope * (_1494 + _1487);
  float _1501 = _1492 - _1486;
  float _1502 = _1493 - _1486;
  float _1503 = _1494 - _1486;
  float _1546 = select((_1492 < _1486), ((_937 / (exp2((_1501 * 1.4426950216293335f) * _939) + 1.0f)) - FilmBlackClip), _1498);
  float _1547 = select((_1493 < _1486), ((_937 / (exp2((_1502 * 1.4426950216293335f) * _939) + 1.0f)) - FilmBlackClip), _1499);
  float _1548 = select((_1494 < _1486), ((_937 / (exp2((_1503 * 1.4426950216293335f) * _939) + 1.0f)) - FilmBlackClip), _1500);
  float _1555 = _1488 - _1486;
  float _1559 = saturate(_1501 / _1555);
  float _1560 = saturate(_1502 / _1555);
  float _1561 = saturate(_1503 / _1555);
  bool _1562 = (_1488 < _1486);
  float _1566 = select(_1562, (1.0f - _1559), _1559);
  float _1567 = select(_1562, (1.0f - _1560), _1560);
  float _1568 = select(_1562, (1.0f - _1561), _1561);
  float _1587 = (((_1566 * _1566) * (select((_1492 > _1488), (_899 - (_961 / (exp2(((_1492 - _1488) * 1.4426950216293335f) * _963) + 1.0f))), _1498) - _1546)) * (3.0f - (_1566 * 2.0f))) + _1546;
  float _1588 = (((_1567 * _1567) * (select((_1493 > _1488), (_899 - (_961 / (exp2(((_1493 - _1488) * 1.4426950216293335f) * _963) + 1.0f))), _1499) - _1547)) * (3.0f - (_1567 * 2.0f))) + _1547;
  float _1589 = (((_1568 * _1568) * (select((_1494 > _1488), (_899 - (_961 / (exp2(((_1494 - _1488) * 1.4426950216293335f) * _963) + 1.0f))), _1500) - _1548)) * (3.0f - (_1568 * 2.0f))) + _1548;
  float _1590 = dot(float3(_1587, _1588, _1589), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1609 = (ToneCurveAmount * (max(0.0f, (lerp(_1590, _1587, 0.9300000071525574f))) - _1110)) + _1110;
  float _1610 = (ToneCurveAmount * (max(0.0f, (lerp(_1590, _1588, 0.9300000071525574f))) - _1111)) + _1111;
  float _1611 = (ToneCurveAmount * (max(0.0f, (lerp(_1590, _1589, 0.9300000071525574f))) - _1112)) + _1112;
  float _1630 = (((_554 - _1363) - ((mad(-0.06537103652954102f, _1365, mad(1.451815478503704e-06f, _1364, (_1363 * 1.065374732017517f))) - _1363) * BlueCorrection)) + _1609) + ((mad(-0.06537103652954102f, _1611, mad(1.451815478503704e-06f, _1610, (_1609 * 1.065374732017517f))) - _1609) * BlueCorrection);
  float _1634 = (((_556 - _1364) - ((mad(-0.20366770029067993f, _1365, mad(1.2036634683609009f, _1364, (_1363 * -2.57161445915699e-07f))) - _1364) * BlueCorrection)) + _1610) + ((mad(-0.20366770029067993f, _1611, mad(1.2036634683609009f, _1610, (_1609 * -2.57161445915699e-07f))) - _1610) * BlueCorrection);
  float _1638 = (((_558 - _1365) - ((mad(0.9999996423721313f, _1365, mad(2.0954757928848267e-08f, _1364, (_1363 * 1.862645149230957e-08f))) - _1365) * BlueCorrection)) + _1611) + ((mad(0.9999996423721313f, _1611, mad(2.0954757928848267e-08f, _1610, (_1609 * 1.862645149230957e-08f))) - _1611) * BlueCorrection);
  float _1641 = mad((WorkingColorSpace_FromAP1[0].z), _1638, mad((WorkingColorSpace_FromAP1[0].y), _1634, ((WorkingColorSpace_FromAP1[0].x) * _1630)));
  float _1644 = mad((WorkingColorSpace_FromAP1[1].z), _1638, mad((WorkingColorSpace_FromAP1[1].y), _1634, ((WorkingColorSpace_FromAP1[1].x) * _1630)));
  float _1647 = mad((WorkingColorSpace_FromAP1[2].z), _1638, mad((WorkingColorSpace_FromAP1[2].y), _1634, ((WorkingColorSpace_FromAP1[2].x) * _1630)));
  float _1648 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1072, mad((WorkingColorSpace_FromAP1[0].y), _1071, ((WorkingColorSpace_FromAP1[0].x) * _1070)))));
  float _1649 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1072, mad((WorkingColorSpace_FromAP1[1].y), _1071, ((WorkingColorSpace_FromAP1[1].x) * _1070)))));
  float _1650 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1072, mad((WorkingColorSpace_FromAP1[2].y), _1071, ((WorkingColorSpace_FromAP1[2].x) * _1070)))));
  if (_1648 < 0.0031306699384003878f) {
    _1661 = (_1648 * 12.920000076293945f);
  } else {
    _1661 = (((pow(_1648, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1649 < 0.0031306699384003878f) {
    _1672 = (_1649 * 12.920000076293945f);
  } else {
    _1672 = (((pow(_1649, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1650 < 0.0031306699384003878f) {
    _1683 = (_1650 * 12.920000076293945f);
  } else {
    _1683 = (((pow(_1650, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1687 = (_1672 * 0.9375f) + 0.03125f;
  float _1694 = _1683 * 15.0f;
  float _1695 = floor(_1694);
  float _1696 = _1694 - _1695;
  float _1698 = (((_1661 * 0.9375f) + 0.03125f) + _1695) * 0.0625f;
  float4 _1701 = Textures_1.Sample(Samplers_1, float2(_1698, _1687));
  float4 _1708 = Textures_1.Sample(Samplers_1, float2((_1698 + 0.0625f), _1687));
  float _1727 = max(6.103519990574569e-05f, (((lerp(_1701.x, _1708.x, _1696)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1661)));
  float _1728 = max(6.103519990574569e-05f, (((lerp(_1701.y, _1708.y, _1696)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1672)));
  float _1729 = max(6.103519990574569e-05f, (((lerp(_1701.z, _1708.z, _1696)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1683)));
  float _1751 = select((_1727 > 0.040449999272823334f), exp2(log2((_1727 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1727 * 0.07739938050508499f));
  float _1752 = select((_1728 > 0.040449999272823334f), exp2(log2((_1728 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1728 * 0.07739938050508499f));
  float _1753 = select((_1729 > 0.040449999272823334f), exp2(log2((_1729 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1729 * 0.07739938050508499f));
  if ((uint)OutputDevice > (uint)2) {
    float _1838 = mad(mad(-0.4986107647418976f, (WorkingColorSpace_ToXYZ[2].z), mad(-1.5373831987380981f, (WorkingColorSpace_ToXYZ[1].z), ((WorkingColorSpace_ToXYZ[0].z) * 3.2409698963165283f))), _1647, mad(mad(-0.4986107647418976f, (WorkingColorSpace_ToXYZ[2].y), mad(-1.5373831987380981f, (WorkingColorSpace_ToXYZ[1].y), ((WorkingColorSpace_ToXYZ[0].y) * 3.2409698963165283f))), _1644, (mad(-0.4986107647418976f, (WorkingColorSpace_ToXYZ[2].x), mad(-1.5373831987380981f, (WorkingColorSpace_ToXYZ[1].x), ((WorkingColorSpace_ToXYZ[0].x) * 3.2409698963165283f))) * _1641)));
    float _1841 = mad(mad(0.04155505821108818f, (WorkingColorSpace_ToXYZ[2].z), mad(1.8759675025939941f, (WorkingColorSpace_ToXYZ[1].z), ((WorkingColorSpace_ToXYZ[0].z) * -0.9692436456680298f))), _1647, mad(mad(0.04155505821108818f, (WorkingColorSpace_ToXYZ[2].y), mad(1.8759675025939941f, (WorkingColorSpace_ToXYZ[1].y), ((WorkingColorSpace_ToXYZ[0].y) * -0.9692436456680298f))), _1644, (mad(0.04155505821108818f, (WorkingColorSpace_ToXYZ[2].x), mad(1.8759675025939941f, (WorkingColorSpace_ToXYZ[1].x), ((WorkingColorSpace_ToXYZ[0].x) * -0.9692436456680298f))) * _1641)));
    float _1844 = mad(mad(1.056971549987793f, (WorkingColorSpace_ToXYZ[2].z), mad(-0.20397695899009705f, (WorkingColorSpace_ToXYZ[1].z), ((WorkingColorSpace_ToXYZ[0].z) * 0.05563008040189743f))), _1647, mad(mad(1.056971549987793f, (WorkingColorSpace_ToXYZ[2].y), mad(-0.20397695899009705f, (WorkingColorSpace_ToXYZ[1].y), ((WorkingColorSpace_ToXYZ[0].y) * 0.05563008040189743f))), _1644, (mad(1.056971549987793f, (WorkingColorSpace_ToXYZ[2].x), mad(-0.20397695899009705f, (WorkingColorSpace_ToXYZ[1].x), ((WorkingColorSpace_ToXYZ[0].x) * 0.05563008040189743f))) * _1641)));
    do {
      if (_1838 < 0.0031306699384003878f) {
        _1855 = (_1838 * 12.920000076293945f);
      } else {
        _1855 = (((pow(_1838, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      do {
        if (_1841 < 0.0031306699384003878f) {
          _1866 = (_1841 * 12.920000076293945f);
        } else {
          _1866 = (((pow(_1841, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1844 < 0.0031306699384003878f) {
            _1877 = (_1844 * 12.920000076293945f);
          } else {
            _1877 = (((pow(_1844, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          float _1881 = (_1866 * 0.9375f) + 0.03125f;
          float _1888 = _1877 * 15.0f;
          float _1889 = floor(_1888);
          float _1890 = _1888 - _1889;
          float _1892 = (((_1855 * 0.9375f) + 0.03125f) + _1889) * 0.0625f;
          float4 _1893 = Textures_1.Sample(Samplers_1, float2(_1892, _1881));
          float4 _1898 = Textures_1.Sample(Samplers_1, float2((_1892 + 0.0625f), _1881));
          float _1917 = max(6.103519990574569e-05f, (((lerp(_1893.x, _1898.x, _1890)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1855)));
          float _1918 = max(6.103519990574569e-05f, (((lerp(_1893.y, _1898.y, _1890)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1866)));
          float _1919 = max(6.103519990574569e-05f, (((lerp(_1893.z, _1898.z, _1890)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1877)));
          float _1941 = select((_1917 > 0.040449999272823334f), exp2(log2((_1917 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1917 * 0.07739938050508499f));
          float _1942 = select((_1918 > 0.040449999272823334f), exp2(log2((_1918 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1918 * 0.07739938050508499f));
          float _1943 = select((_1919 > 0.040449999272823334f), exp2(log2((_1919 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1919 * 0.07739938050508499f));
          _1954 = mad(mad((WorkingColorSpace_FromXYZ[0].z), 0.9505321383476257f, mad((WorkingColorSpace_FromXYZ[0].y), 0.07219231873750687f, ((WorkingColorSpace_FromXYZ[0].x) * 0.18048079311847687f))), _1943, mad(mad((WorkingColorSpace_FromXYZ[0].z), 0.11919478327035904f, mad((WorkingColorSpace_FromXYZ[0].y), 0.7151686549186707f, ((WorkingColorSpace_FromXYZ[0].x) * 0.3575843274593353f))), _1942, (_1941 * mad((WorkingColorSpace_FromXYZ[0].z), 0.019330818206071854f, mad((WorkingColorSpace_FromXYZ[0].y), 0.2126390039920807f, ((WorkingColorSpace_FromXYZ[0].x) * 0.412390798330307f))))));
          _1955 = mad(mad((WorkingColorSpace_FromXYZ[1].z), 0.9505321383476257f, mad((WorkingColorSpace_FromXYZ[1].y), 0.07219231873750687f, ((WorkingColorSpace_FromXYZ[1].x) * 0.18048079311847687f))), _1943, mad(mad((WorkingColorSpace_FromXYZ[1].z), 0.11919478327035904f, mad((WorkingColorSpace_FromXYZ[1].y), 0.7151686549186707f, ((WorkingColorSpace_FromXYZ[1].x) * 0.3575843274593353f))), _1942, (_1941 * mad((WorkingColorSpace_FromXYZ[1].z), 0.019330818206071854f, mad((WorkingColorSpace_FromXYZ[1].y), 0.2126390039920807f, ((WorkingColorSpace_FromXYZ[1].x) * 0.412390798330307f))))));
          _1956 = mad(mad((WorkingColorSpace_FromXYZ[2].z), 0.9505321383476257f, mad((WorkingColorSpace_FromXYZ[2].y), 0.07219231873750687f, ((WorkingColorSpace_FromXYZ[2].x) * 0.18048079311847687f))), _1943, mad(mad((WorkingColorSpace_FromXYZ[2].z), 0.11919478327035904f, mad((WorkingColorSpace_FromXYZ[2].y), 0.7151686549186707f, ((WorkingColorSpace_FromXYZ[2].x) * 0.3575843274593353f))), _1942, (_1941 * mad((WorkingColorSpace_FromXYZ[2].z), 0.019330818206071854f, mad((WorkingColorSpace_FromXYZ[2].y), 0.2126390039920807f, ((WorkingColorSpace_FromXYZ[2].x) * 0.412390798330307f))))));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1954 = _1641;
    _1955 = _1644;
    _1956 = _1647;
  }
  float _1982 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1751)) * _1751) + MappingPolynomial.z);
  float _1983 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1752)) * _1752) + MappingPolynomial.z);
  float _1984 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1753)) * _1753) + MappingPolynomial.z);
  float _1991 = ((OverlayColor.x - _1982) * OverlayColor.w) + _1982;
  float _1992 = ((OverlayColor.y - _1983) * OverlayColor.w) + _1983;
  float _1993 = ((OverlayColor.z - _1984) * OverlayColor.w) + _1984;
  float _1994 = ColorScale.x * _1954;
  float _1995 = ColorScale.y * _1955;
  float _1996 = ColorScale.z * _1956;
  float _2003 = ((OverlayColor.x - _1994) * OverlayColor.w) + _1994;
  float _2004 = ((OverlayColor.y - _1995) * OverlayColor.w) + _1995;
  float _2005 = ((OverlayColor.z - _1996) * OverlayColor.w) + _1996;
  float _2017 = exp2(log2(max(0.0f, _1991)) * InverseGamma.y);
  float _2018 = exp2(log2(max(0.0f, _1992)) * InverseGamma.y);
  float _2019 = exp2(log2(max(0.0f, _1993)) * InverseGamma.y);
  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace_bIsSRGB == 0) {
        float _2040 = mad((WorkingColorSpace_ToAP1[0].z), _2019, mad((WorkingColorSpace_ToAP1[0].y), _2018, ((WorkingColorSpace_ToAP1[0].x) * _2017)));
        float _2043 = mad((WorkingColorSpace_ToAP1[1].z), _2019, mad((WorkingColorSpace_ToAP1[1].y), _2018, ((WorkingColorSpace_ToAP1[1].x) * _2017)));
        float _2046 = mad((WorkingColorSpace_ToAP1[2].z), _2019, mad((WorkingColorSpace_ToAP1[2].y), _2018, ((WorkingColorSpace_ToAP1[2].x) * _2017)));
        _2057 = mad(_47, _2046, mad(_46, _2043, (_2040 * _45)));
        _2058 = mad(_50, _2046, mad(_49, _2043, (_2040 * _48)));
        _2059 = mad(_53, _2046, mad(_52, _2043, (_2040 * _51)));
      } else {
        _2057 = _2017;
        _2058 = _2018;
        _2059 = _2019;
      }
      do {
        if (_2057 < 0.0031306699384003878f) {
          _2070 = (_2057 * 12.920000076293945f);
        } else {
          _2070 = (((pow(_2057, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_2058 < 0.0031306699384003878f) {
            _2081 = (_2058 * 12.920000076293945f);
          } else {
            _2081 = (((pow(_2058, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_2059 < 0.0031306699384003878f) {
            _3437 = _2070;
            _3438 = _2081;
            _3439 = (_2059 * 12.920000076293945f);
          } else {
            _3437 = _2070;
            _3438 = _2081;
            _3439 = (((pow(_2059, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _2108 = mad((WorkingColorSpace_ToAP1[0].z), _2019, mad((WorkingColorSpace_ToAP1[0].y), _2018, ((WorkingColorSpace_ToAP1[0].x) * _2017)));
      float _2111 = mad((WorkingColorSpace_ToAP1[1].z), _2019, mad((WorkingColorSpace_ToAP1[1].y), _2018, ((WorkingColorSpace_ToAP1[1].x) * _2017)));
      float _2114 = mad((WorkingColorSpace_ToAP1[2].z), _2019, mad((WorkingColorSpace_ToAP1[2].y), _2018, ((WorkingColorSpace_ToAP1[2].x) * _2017)));
      float _2124 = max(6.103519990574569e-05f, mad(_47, _2114, mad(_46, _2111, (_2108 * _45))));
      float _2125 = max(6.103519990574569e-05f, mad(_50, _2114, mad(_49, _2111, (_2108 * _48))));
      float _2126 = max(6.103519990574569e-05f, mad(_53, _2114, mad(_52, _2111, (_2108 * _51))));
      _3437 = min((_2124 * 4.5f), ((exp2(log2(max(_2124, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3438 = min((_2125 * 4.5f), ((exp2(log2(max(_2125, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3439 = min((_2126 * 4.5f), ((exp2(log2(max(_2126, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        float _2201 = ACESSceneColorMultiplier * _2003;
        float _2202 = ACESSceneColorMultiplier * _2004;
        float _2203 = ACESSceneColorMultiplier * _2005;
        float _2206 = mad((WorkingColorSpace_ToAP0[0].z), _2203, mad((WorkingColorSpace_ToAP0[0].y), _2202, ((WorkingColorSpace_ToAP0[0].x) * _2201)));
        float _2209 = mad((WorkingColorSpace_ToAP0[1].z), _2203, mad((WorkingColorSpace_ToAP0[1].y), _2202, ((WorkingColorSpace_ToAP0[1].x) * _2201)));
        float _2212 = mad((WorkingColorSpace_ToAP0[2].z), _2203, mad((WorkingColorSpace_ToAP0[2].y), _2202, ((WorkingColorSpace_ToAP0[2].x) * _2201)));
        float _2216 = max(max(_2206, _2209), _2212);
        float _2221 = (max(_2216, 1.000000013351432e-10f) - max(min(min(_2206, _2209), _2212), 1.000000013351432e-10f)) / max(_2216, 0.009999999776482582f);
        float _2234 = ((_2209 + _2206) + _2212) + (sqrt((((_2212 - _2209) * _2212) + ((_2209 - _2206) * _2209)) + ((_2206 - _2212) * _2206)) * 1.75f);
        float _2235 = _2234 * 0.3333333432674408f;
        float _2236 = _2221 + -0.4000000059604645f;
        float _2237 = _2236 * 5.0f;
        float _2241 = max((1.0f - abs(_2236 * 2.5f)), 0.0f);
        float _2252 = ((float((int)(((int)(uint)((bool)(_2237 > 0.0f))) - ((int)(uint)((bool)(_2237 < 0.0f))))) * (1.0f - (_2241 * _2241))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_2235 <= 0.0533333346247673f)) {
            if (!(_2235 >= 0.1599999964237213f)) {
              _2261 = (((0.23999999463558197f / _2234) + -0.5f) * _2252);
            } else {
              _2261 = 0.0f;
            }
          } else {
            _2261 = _2252;
          }
          float _2262 = _2261 + 1.0f;
          float _2263 = _2262 * _2206;
          float _2264 = _2262 * _2209;
          float _2265 = _2262 * _2212;
          do {
            if (!((bool)(_2263 == _2264) && (bool)(_2264 == _2265))) {
              float _2272 = ((_2263 * 2.0f) - _2264) - _2265;
              float _2275 = ((_2209 - _2212) * 1.7320507764816284f) * _2262;
              float _2277 = atan(_2275 / _2272);
              bool _2280 = (_2272 < 0.0f);
              bool _2281 = (_2272 == 0.0f);
              bool _2282 = (_2275 >= 0.0f);
              bool _2283 = (_2275 < 0.0f);
              _2294 = select((_2282 && _2281), 90.0f, select((_2283 && _2281), -90.0f, (select((_2283 && _2280), (_2277 + -3.1415927410125732f), select((_2282 && _2280), (_2277 + 3.1415927410125732f), _2277)) * 57.2957763671875f)));
            } else {
              _2294 = 0.0f;
            }
            float _2299 = min(max(select((_2294 < 0.0f), (_2294 + 360.0f), _2294), 0.0f), 360.0f);
            do {
              if (_2299 < -180.0f) {
                _2308 = (_2299 + 360.0f);
              } else {
                if (_2299 > 180.0f) {
                  _2308 = (_2299 + -360.0f);
                } else {
                  _2308 = _2299;
                }
              }
              do {
                if ((bool)(_2308 > -67.5f) && (bool)(_2308 < 67.5f)) {
                  float _2314 = (_2308 + 67.5f) * 0.029629629105329514f;
                  int _2315 = int(_2314);
                  float _2317 = _2314 - float((int)(_2315));
                  float _2318 = _2317 * _2317;
                  float _2319 = _2318 * _2317;
                  if (_2315 == 3) {
                    _2347 = (((0.1666666716337204f - (_2317 * 0.5f)) + (_2318 * 0.5f)) - (_2319 * 0.1666666716337204f));
                  } else {
                    if (_2315 == 2) {
                      _2347 = ((0.6666666865348816f - _2318) + (_2319 * 0.5f));
                    } else {
                      if (_2315 == 1) {
                        _2347 = (((_2319 * -0.5f) + 0.1666666716337204f) + ((_2318 + _2317) * 0.5f));
                      } else {
                        _2347 = select((_2315 == 0), (_2319 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _2347 = 0.0f;
                }
                float _2356 = min(max(((((_2221 * 0.27000001072883606f) * (0.029999999329447746f - _2263)) * _2347) + _2263), 0.0f), 65535.0f);
                float _2357 = min(max(_2264, 0.0f), 65535.0f);
                float _2358 = min(max(_2265, 0.0f), 65535.0f);
                float _2371 = min(max(mad(-0.21492856740951538f, _2358, mad(-0.2365107536315918f, _2357, (_2356 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _2372 = min(max(mad(-0.09967592358589172f, _2358, mad(1.17622971534729f, _2357, (_2356 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _2373 = min(max(mad(0.9977163076400757f, _2358, mad(-0.006032449658960104f, _2357, (_2356 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _2374 = dot(float3(_2371, _2372, _2373), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _2385 = log2(max((lerp(_2374, _2371, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _2386 = _2385 * 0.3010300099849701f;
                float _2387 = log2(ACESMinMaxData.x);
                float _2388 = _2387 * 0.3010300099849701f;
                do {
                  if (!(!(_2386 <= _2388))) {
                    _2457 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                  } else {
                    float _2395 = log2(ACESMidData.x);
                    float _2396 = _2395 * 0.3010300099849701f;
                    if ((bool)(_2386 > _2388) && (bool)(_2386 < _2396)) {
                      float _2404 = ((_2385 - _2387) * 0.9030900001525879f) / ((_2395 - _2387) * 0.3010300099849701f);
                      int _2405 = int(_2404);
                      float _2407 = _2404 - float((int)(_2405));
                      float _2409 = _12[_2405];
                      float _2412 = _12[(_2405 + 1)];
                      float _2417 = _2409 * 0.5f;
                      _2457 = dot(float3((_2407 * _2407), _2407, 1.0f), float3(mad((_12[(_2405 + 2)]), 0.5f, mad(_2412, -1.0f, _2417)), (_2412 - _2409), mad(_2412, 0.5f, _2417)));
                    } else {
                      do {
                        if (!(!(_2386 >= _2396))) {
                          float _2426 = log2(ACESMinMaxData.z);
                          if (_2386 < (_2426 * 0.3010300099849701f)) {
                            float _2434 = ((_2385 - _2395) * 0.9030900001525879f) / ((_2426 - _2395) * 0.3010300099849701f);
                            int _2435 = int(_2434);
                            float _2437 = _2434 - float((int)(_2435));
                            float _2439 = _13[_2435];
                            float _2442 = _13[(_2435 + 1)];
                            float _2447 = _2439 * 0.5f;
                            _2457 = dot(float3((_2437 * _2437), _2437, 1.0f), float3(mad((_13[(_2435 + 2)]), 0.5f, mad(_2442, -1.0f, _2447)), (_2442 - _2439), mad(_2442, 0.5f, _2447)));
                            break;
                          }
                        }
                        _2457 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _2461 = log2(max((lerp(_2374, _2372, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2462 = _2461 * 0.3010300099849701f;
                  do {
                    if (!(!(_2462 <= _2388))) {
                      _2531 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2469 = log2(ACESMidData.x);
                      float _2470 = _2469 * 0.3010300099849701f;
                      if ((bool)(_2462 > _2388) && (bool)(_2462 < _2470)) {
                        float _2478 = ((_2461 - _2387) * 0.9030900001525879f) / ((_2469 - _2387) * 0.3010300099849701f);
                        int _2479 = int(_2478);
                        float _2481 = _2478 - float((int)(_2479));
                        float _2483 = _12[_2479];
                        float _2486 = _12[(_2479 + 1)];
                        float _2491 = _2483 * 0.5f;
                        _2531 = dot(float3((_2481 * _2481), _2481, 1.0f), float3(mad((_12[(_2479 + 2)]), 0.5f, mad(_2486, -1.0f, _2491)), (_2486 - _2483), mad(_2486, 0.5f, _2491)));
                      } else {
                        do {
                          if (!(!(_2462 >= _2470))) {
                            float _2500 = log2(ACESMinMaxData.z);
                            if (_2462 < (_2500 * 0.3010300099849701f)) {
                              float _2508 = ((_2461 - _2469) * 0.9030900001525879f) / ((_2500 - _2469) * 0.3010300099849701f);
                              int _2509 = int(_2508);
                              float _2511 = _2508 - float((int)(_2509));
                              float _2513 = _13[_2509];
                              float _2516 = _13[(_2509 + 1)];
                              float _2521 = _2513 * 0.5f;
                              _2531 = dot(float3((_2511 * _2511), _2511, 1.0f), float3(mad((_13[(_2509 + 2)]), 0.5f, mad(_2516, -1.0f, _2521)), (_2516 - _2513), mad(_2516, 0.5f, _2521)));
                              break;
                            }
                          }
                          _2531 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2535 = log2(max((lerp(_2374, _2373, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2536 = _2535 * 0.3010300099849701f;
                    do {
                      if (!(!(_2536 <= _2388))) {
                        _2605 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2543 = log2(ACESMidData.x);
                        float _2544 = _2543 * 0.3010300099849701f;
                        if ((bool)(_2536 > _2388) && (bool)(_2536 < _2544)) {
                          float _2552 = ((_2535 - _2387) * 0.9030900001525879f) / ((_2543 - _2387) * 0.3010300099849701f);
                          int _2553 = int(_2552);
                          float _2555 = _2552 - float((int)(_2553));
                          float _2557 = _12[_2553];
                          float _2560 = _12[(_2553 + 1)];
                          float _2565 = _2557 * 0.5f;
                          _2605 = dot(float3((_2555 * _2555), _2555, 1.0f), float3(mad((_12[(_2553 + 2)]), 0.5f, mad(_2560, -1.0f, _2565)), (_2560 - _2557), mad(_2560, 0.5f, _2565)));
                        } else {
                          do {
                            if (!(!(_2536 >= _2544))) {
                              float _2574 = log2(ACESMinMaxData.z);
                              if (_2536 < (_2574 * 0.3010300099849701f)) {
                                float _2582 = ((_2535 - _2543) * 0.9030900001525879f) / ((_2574 - _2543) * 0.3010300099849701f);
                                int _2583 = int(_2582);
                                float _2585 = _2582 - float((int)(_2583));
                                float _2587 = _13[_2583];
                                float _2590 = _13[(_2583 + 1)];
                                float _2595 = _2587 * 0.5f;
                                _2605 = dot(float3((_2585 * _2585), _2585, 1.0f), float3(mad((_13[(_2583 + 2)]), 0.5f, mad(_2590, -1.0f, _2595)), (_2590 - _2587), mad(_2590, 0.5f, _2595)));
                                break;
                              }
                            }
                            _2605 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2609 = ACESMinMaxData.w - ACESMinMaxData.y;
                      float _2610 = (exp2(_2457 * 3.321928024291992f) - ACESMinMaxData.y) / _2609;
                      float _2612 = (exp2(_2531 * 3.321928024291992f) - ACESMinMaxData.y) / _2609;
                      float _2614 = (exp2(_2605 * 3.321928024291992f) - ACESMinMaxData.y) / _2609;
                      float _2617 = mad(0.15618768334388733f, _2614, mad(0.13400420546531677f, _2612, (_2610 * 0.6624541878700256f)));
                      float _2620 = mad(0.053689517080783844f, _2614, mad(0.6740817427635193f, _2612, (_2610 * 0.2722287178039551f)));
                      float _2623 = mad(1.0103391408920288f, _2614, mad(0.00406073359772563f, _2612, (_2610 * -0.005574649665504694f)));
                      float _2636 = min(max(mad(-0.23642469942569733f, _2623, mad(-0.32480329275131226f, _2620, (_2617 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _2637 = min(max(mad(0.016756348311901093f, _2623, mad(1.6153316497802734f, _2620, (_2617 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _2638 = min(max(mad(0.9883948564529419f, _2623, mad(-0.008284442126750946f, _2620, (_2617 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _2641 = mad(0.15618768334388733f, _2638, mad(0.13400420546531677f, _2637, (_2636 * 0.6624541878700256f)));
                      float _2644 = mad(0.053689517080783844f, _2638, mad(0.6740817427635193f, _2637, (_2636 * 0.2722287178039551f)));
                      float _2647 = mad(1.0103391408920288f, _2638, mad(0.00406073359772563f, _2637, (_2636 * -0.005574649665504694f)));
                      float _2669 = min(max((min(max(mad(-0.23642469942569733f, _2647, mad(-0.32480329275131226f, _2644, (_2641 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2670 = min(max((min(max(mad(0.016756348311901093f, _2647, mad(1.6153316497802734f, _2644, (_2641 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      float _2671 = min(max((min(max(mad(0.9883948564529419f, _2647, mad(-0.008284442126750946f, _2644, (_2641 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                      do {
                        if (!(OutputDevice == 5)) {
                          _2684 = mad(_47, _2671, mad(_46, _2670, (_2669 * _45)));
                          _2685 = mad(_50, _2671, mad(_49, _2670, (_2669 * _48)));
                          _2686 = mad(_53, _2671, mad(_52, _2670, (_2669 * _51)));
                        } else {
                          _2684 = _2669;
                          _2685 = _2670;
                          _2686 = _2671;
                        }
                        float _2696 = exp2(log2(_2684 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2697 = exp2(log2(_2685 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2698 = exp2(log2(_2686 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _3437 = exp2(log2((1.0f / ((_2696 * 18.6875f) + 1.0f)) * ((_2696 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _3438 = exp2(log2((1.0f / ((_2697 * 18.6875f) + 1.0f)) * ((_2697 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _3439 = exp2(log2((1.0f / ((_2698 * 18.6875f) + 1.0f)) * ((_2698 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2775 = ACESSceneColorMultiplier * _2003;
          float _2776 = ACESSceneColorMultiplier * _2004;
          float _2777 = ACESSceneColorMultiplier * _2005;
          float _2780 = mad((WorkingColorSpace_ToAP0[0].z), _2777, mad((WorkingColorSpace_ToAP0[0].y), _2776, ((WorkingColorSpace_ToAP0[0].x) * _2775)));
          float _2783 = mad((WorkingColorSpace_ToAP0[1].z), _2777, mad((WorkingColorSpace_ToAP0[1].y), _2776, ((WorkingColorSpace_ToAP0[1].x) * _2775)));
          float _2786 = mad((WorkingColorSpace_ToAP0[2].z), _2777, mad((WorkingColorSpace_ToAP0[2].y), _2776, ((WorkingColorSpace_ToAP0[2].x) * _2775)));
          float _2790 = max(max(_2780, _2783), _2786);
          float _2795 = (max(_2790, 1.000000013351432e-10f) - max(min(min(_2780, _2783), _2786), 1.000000013351432e-10f)) / max(_2790, 0.009999999776482582f);
          float _2808 = ((_2783 + _2780) + _2786) + (sqrt((((_2786 - _2783) * _2786) + ((_2783 - _2780) * _2783)) + ((_2780 - _2786) * _2780)) * 1.75f);
          float _2809 = _2808 * 0.3333333432674408f;
          float _2810 = _2795 + -0.4000000059604645f;
          float _2811 = _2810 * 5.0f;
          float _2815 = max((1.0f - abs(_2810 * 2.5f)), 0.0f);
          float _2826 = ((float((int)(((int)(uint)((bool)(_2811 > 0.0f))) - ((int)(uint)((bool)(_2811 < 0.0f))))) * (1.0f - (_2815 * _2815))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2809 <= 0.0533333346247673f)) {
              if (!(_2809 >= 0.1599999964237213f)) {
                _2835 = (((0.23999999463558197f / _2808) + -0.5f) * _2826);
              } else {
                _2835 = 0.0f;
              }
            } else {
              _2835 = _2826;
            }
            float _2836 = _2835 + 1.0f;
            float _2837 = _2836 * _2780;
            float _2838 = _2836 * _2783;
            float _2839 = _2836 * _2786;
            do {
              if (!((bool)(_2837 == _2838) && (bool)(_2838 == _2839))) {
                float _2846 = ((_2837 * 2.0f) - _2838) - _2839;
                float _2849 = ((_2783 - _2786) * 1.7320507764816284f) * _2836;
                float _2851 = atan(_2849 / _2846);
                bool _2854 = (_2846 < 0.0f);
                bool _2855 = (_2846 == 0.0f);
                bool _2856 = (_2849 >= 0.0f);
                bool _2857 = (_2849 < 0.0f);
                _2868 = select((_2856 && _2855), 90.0f, select((_2857 && _2855), -90.0f, (select((_2857 && _2854), (_2851 + -3.1415927410125732f), select((_2856 && _2854), (_2851 + 3.1415927410125732f), _2851)) * 57.2957763671875f)));
              } else {
                _2868 = 0.0f;
              }
              float _2873 = min(max(select((_2868 < 0.0f), (_2868 + 360.0f), _2868), 0.0f), 360.0f);
              do {
                if (_2873 < -180.0f) {
                  _2882 = (_2873 + 360.0f);
                } else {
                  if (_2873 > 180.0f) {
                    _2882 = (_2873 + -360.0f);
                  } else {
                    _2882 = _2873;
                  }
                }
                do {
                  if ((bool)(_2882 > -67.5f) && (bool)(_2882 < 67.5f)) {
                    float _2888 = (_2882 + 67.5f) * 0.029629629105329514f;
                    int _2889 = int(_2888);
                    float _2891 = _2888 - float((int)(_2889));
                    float _2892 = _2891 * _2891;
                    float _2893 = _2892 * _2891;
                    if (_2889 == 3) {
                      _2921 = (((0.1666666716337204f - (_2891 * 0.5f)) + (_2892 * 0.5f)) - (_2893 * 0.1666666716337204f));
                    } else {
                      if (_2889 == 2) {
                        _2921 = ((0.6666666865348816f - _2892) + (_2893 * 0.5f));
                      } else {
                        if (_2889 == 1) {
                          _2921 = (((_2893 * -0.5f) + 0.1666666716337204f) + ((_2892 + _2891) * 0.5f));
                        } else {
                          _2921 = select((_2889 == 0), (_2893 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2921 = 0.0f;
                  }
                  float _2930 = min(max(((((_2795 * 0.27000001072883606f) * (0.029999999329447746f - _2837)) * _2921) + _2837), 0.0f), 65535.0f);
                  float _2931 = min(max(_2838, 0.0f), 65535.0f);
                  float _2932 = min(max(_2839, 0.0f), 65535.0f);
                  float _2945 = min(max(mad(-0.21492856740951538f, _2932, mad(-0.2365107536315918f, _2931, (_2930 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2946 = min(max(mad(-0.09967592358589172f, _2932, mad(1.17622971534729f, _2931, (_2930 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2947 = min(max(mad(0.9977163076400757f, _2932, mad(-0.006032449658960104f, _2931, (_2930 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2948 = dot(float3(_2945, _2946, _2947), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2959 = log2(max((lerp(_2948, _2945, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2960 = _2959 * 0.3010300099849701f;
                  float _2961 = log2(ACESMinMaxData.x);
                  float _2962 = _2961 * 0.3010300099849701f;
                  do {
                    if (!(!(_2960 <= _2962))) {
                      _3031 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _2969 = log2(ACESMidData.x);
                      float _2970 = _2969 * 0.3010300099849701f;
                      if ((bool)(_2960 > _2962) && (bool)(_2960 < _2970)) {
                        float _2978 = ((_2959 - _2961) * 0.9030900001525879f) / ((_2969 - _2961) * 0.3010300099849701f);
                        int _2979 = int(_2978);
                        float _2981 = _2978 - float((int)(_2979));
                        float _2983 = _10[_2979];
                        float _2986 = _10[(_2979 + 1)];
                        float _2991 = _2983 * 0.5f;
                        _3031 = dot(float3((_2981 * _2981), _2981, 1.0f), float3(mad((_10[(_2979 + 2)]), 0.5f, mad(_2986, -1.0f, _2991)), (_2986 - _2983), mad(_2986, 0.5f, _2991)));
                      } else {
                        do {
                          if (!(!(_2960 >= _2970))) {
                            float _3000 = log2(ACESMinMaxData.z);
                            if (_2960 < (_3000 * 0.3010300099849701f)) {
                              float _3008 = ((_2959 - _2969) * 0.9030900001525879f) / ((_3000 - _2969) * 0.3010300099849701f);
                              int _3009 = int(_3008);
                              float _3011 = _3008 - float((int)(_3009));
                              float _3013 = _11[_3009];
                              float _3016 = _11[(_3009 + 1)];
                              float _3021 = _3013 * 0.5f;
                              _3031 = dot(float3((_3011 * _3011), _3011, 1.0f), float3(mad((_11[(_3009 + 2)]), 0.5f, mad(_3016, -1.0f, _3021)), (_3016 - _3013), mad(_3016, 0.5f, _3021)));
                              break;
                            }
                          }
                          _3031 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _3035 = log2(max((lerp(_2948, _2946, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _3036 = _3035 * 0.3010300099849701f;
                    do {
                      if (!(!(_3036 <= _2962))) {
                        _3105 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _3043 = log2(ACESMidData.x);
                        float _3044 = _3043 * 0.3010300099849701f;
                        if ((bool)(_3036 > _2962) && (bool)(_3036 < _3044)) {
                          float _3052 = ((_3035 - _2961) * 0.9030900001525879f) / ((_3043 - _2961) * 0.3010300099849701f);
                          int _3053 = int(_3052);
                          float _3055 = _3052 - float((int)(_3053));
                          float _3057 = _10[_3053];
                          float _3060 = _10[(_3053 + 1)];
                          float _3065 = _3057 * 0.5f;
                          _3105 = dot(float3((_3055 * _3055), _3055, 1.0f), float3(mad((_10[(_3053 + 2)]), 0.5f, mad(_3060, -1.0f, _3065)), (_3060 - _3057), mad(_3060, 0.5f, _3065)));
                        } else {
                          do {
                            if (!(!(_3036 >= _3044))) {
                              float _3074 = log2(ACESMinMaxData.z);
                              if (_3036 < (_3074 * 0.3010300099849701f)) {
                                float _3082 = ((_3035 - _3043) * 0.9030900001525879f) / ((_3074 - _3043) * 0.3010300099849701f);
                                int _3083 = int(_3082);
                                float _3085 = _3082 - float((int)(_3083));
                                float _3087 = _11[_3083];
                                float _3090 = _11[(_3083 + 1)];
                                float _3095 = _3087 * 0.5f;
                                _3105 = dot(float3((_3085 * _3085), _3085, 1.0f), float3(mad((_11[(_3083 + 2)]), 0.5f, mad(_3090, -1.0f, _3095)), (_3090 - _3087), mad(_3090, 0.5f, _3095)));
                                break;
                              }
                            }
                            _3105 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _3109 = log2(max((lerp(_2948, _2947, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _3110 = _3109 * 0.3010300099849701f;
                      do {
                        if (!(!(_3110 <= _2962))) {
                          _3179 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _3117 = log2(ACESMidData.x);
                          float _3118 = _3117 * 0.3010300099849701f;
                          if ((bool)(_3110 > _2962) && (bool)(_3110 < _3118)) {
                            float _3126 = ((_3109 - _2961) * 0.9030900001525879f) / ((_3117 - _2961) * 0.3010300099849701f);
                            int _3127 = int(_3126);
                            float _3129 = _3126 - float((int)(_3127));
                            float _3131 = _10[_3127];
                            float _3134 = _10[(_3127 + 1)];
                            float _3139 = _3131 * 0.5f;
                            _3179 = dot(float3((_3129 * _3129), _3129, 1.0f), float3(mad((_10[(_3127 + 2)]), 0.5f, mad(_3134, -1.0f, _3139)), (_3134 - _3131), mad(_3134, 0.5f, _3139)));
                          } else {
                            do {
                              if (!(!(_3110 >= _3118))) {
                                float _3148 = log2(ACESMinMaxData.z);
                                if (_3110 < (_3148 * 0.3010300099849701f)) {
                                  float _3156 = ((_3109 - _3117) * 0.9030900001525879f) / ((_3148 - _3117) * 0.3010300099849701f);
                                  int _3157 = int(_3156);
                                  float _3159 = _3156 - float((int)(_3157));
                                  float _3161 = _11[_3157];
                                  float _3164 = _11[(_3157 + 1)];
                                  float _3169 = _3161 * 0.5f;
                                  _3179 = dot(float3((_3159 * _3159), _3159, 1.0f), float3(mad((_11[(_3157 + 2)]), 0.5f, mad(_3164, -1.0f, _3169)), (_3164 - _3161), mad(_3164, 0.5f, _3169)));
                                  break;
                                }
                              }
                              _3179 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _3183 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _3184 = (exp2(_3031 * 3.321928024291992f) - ACESMinMaxData.y) / _3183;
                        float _3186 = (exp2(_3105 * 3.321928024291992f) - ACESMinMaxData.y) / _3183;
                        float _3188 = (exp2(_3179 * 3.321928024291992f) - ACESMinMaxData.y) / _3183;
                        float _3191 = mad(0.15618768334388733f, _3188, mad(0.13400420546531677f, _3186, (_3184 * 0.6624541878700256f)));
                        float _3194 = mad(0.053689517080783844f, _3188, mad(0.6740817427635193f, _3186, (_3184 * 0.2722287178039551f)));
                        float _3197 = mad(1.0103391408920288f, _3188, mad(0.00406073359772563f, _3186, (_3184 * -0.005574649665504694f)));
                        float _3210 = min(max(mad(-0.23642469942569733f, _3197, mad(-0.32480329275131226f, _3194, (_3191 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _3211 = min(max(mad(0.016756348311901093f, _3197, mad(1.6153316497802734f, _3194, (_3191 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _3212 = min(max(mad(0.9883948564529419f, _3197, mad(-0.008284442126750946f, _3194, (_3191 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _3215 = mad(0.15618768334388733f, _3212, mad(0.13400420546531677f, _3211, (_3210 * 0.6624541878700256f)));
                        float _3218 = mad(0.053689517080783844f, _3212, mad(0.6740817427635193f, _3211, (_3210 * 0.2722287178039551f)));
                        float _3221 = mad(1.0103391408920288f, _3212, mad(0.00406073359772563f, _3211, (_3210 * -0.005574649665504694f)));
                        float _3243 = min(max((min(max(mad(-0.23642469942569733f, _3221, mad(-0.32480329275131226f, _3218, (_3215 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _3244 = min(max((min(max(mad(0.016756348311901093f, _3221, mad(1.6153316497802734f, _3218, (_3215 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _3245 = min(max((min(max(mad(0.9883948564529419f, _3221, mad(-0.008284442126750946f, _3218, (_3215 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 6)) {
                            _3258 = mad(_47, _3245, mad(_46, _3244, (_3243 * _45)));
                            _3259 = mad(_50, _3245, mad(_49, _3244, (_3243 * _48)));
                            _3260 = mad(_53, _3245, mad(_52, _3244, (_3243 * _51)));
                          } else {
                            _3258 = _3243;
                            _3259 = _3244;
                            _3260 = _3245;
                          }
                          float _3270 = exp2(log2(_3258 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _3271 = exp2(log2(_3259 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _3272 = exp2(log2(_3260 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _3437 = exp2(log2((1.0f / ((_3270 * 18.6875f) + 1.0f)) * ((_3270 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3438 = exp2(log2((1.0f / ((_3271 * 18.6875f) + 1.0f)) * ((_3271 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3439 = exp2(log2((1.0f / ((_3272 * 18.6875f) + 1.0f)) * ((_3272 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _3317 = mad((WorkingColorSpace_ToAP1[0].z), _2005, mad((WorkingColorSpace_ToAP1[0].y), _2004, ((WorkingColorSpace_ToAP1[0].x) * _2003)));
            float _3320 = mad((WorkingColorSpace_ToAP1[1].z), _2005, mad((WorkingColorSpace_ToAP1[1].y), _2004, ((WorkingColorSpace_ToAP1[1].x) * _2003)));
            float _3323 = mad((WorkingColorSpace_ToAP1[2].z), _2005, mad((WorkingColorSpace_ToAP1[2].y), _2004, ((WorkingColorSpace_ToAP1[2].x) * _2003)));
            float _3342 = exp2(log2(mad(_47, _3323, mad(_46, _3320, (_3317 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _3343 = exp2(log2(mad(_50, _3323, mad(_49, _3320, (_3317 * _48))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _3344 = exp2(log2(mad(_53, _3323, mad(_52, _3320, (_3317 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3437 = exp2(log2((1.0f / ((_3342 * 18.6875f) + 1.0f)) * ((_3342 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3438 = exp2(log2((1.0f / ((_3343 * 18.6875f) + 1.0f)) * ((_3343 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3439 = exp2(log2((1.0f / ((_3344 * 18.6875f) + 1.0f)) * ((_3344 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _3391 = mad((WorkingColorSpace_ToAP1[0].z), _1993, mad((WorkingColorSpace_ToAP1[0].y), _1992, ((WorkingColorSpace_ToAP1[0].x) * _1991)));
                float _3394 = mad((WorkingColorSpace_ToAP1[1].z), _1993, mad((WorkingColorSpace_ToAP1[1].y), _1992, ((WorkingColorSpace_ToAP1[1].x) * _1991)));
                float _3397 = mad((WorkingColorSpace_ToAP1[2].z), _1993, mad((WorkingColorSpace_ToAP1[2].y), _1992, ((WorkingColorSpace_ToAP1[2].x) * _1991)));
                _3437 = mad(_47, _3397, mad(_46, _3394, (_3391 * _45)));
                _3438 = mad(_50, _3397, mad(_49, _3394, (_3391 * _48)));
                _3439 = mad(_53, _3397, mad(_52, _3394, (_3391 * _51)));
              } else {
                float _3410 = mad((WorkingColorSpace_ToAP1[0].z), _2019, mad((WorkingColorSpace_ToAP1[0].y), _2018, ((WorkingColorSpace_ToAP1[0].x) * _2017)));
                float _3413 = mad((WorkingColorSpace_ToAP1[1].z), _2019, mad((WorkingColorSpace_ToAP1[1].y), _2018, ((WorkingColorSpace_ToAP1[1].x) * _2017)));
                float _3416 = mad((WorkingColorSpace_ToAP1[2].z), _2019, mad((WorkingColorSpace_ToAP1[2].y), _2018, ((WorkingColorSpace_ToAP1[2].x) * _2017)));
                _3437 = exp2(log2(mad(_47, _3416, mad(_46, _3413, (_3410 * _45)))) * InverseGamma.z);
                _3438 = exp2(log2(mad(_50, _3416, mad(_49, _3413, (_3410 * _48)))) * InverseGamma.z);
                _3439 = exp2(log2(mad(_53, _3416, mad(_52, _3413, (_3410 * _51)))) * InverseGamma.z);
              }
            } else {
              _3437 = _2003;
              _3438 = _2004;
              _3439 = _2005;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_3437 * 0.9523810148239136f);
  SV_Target.y = (_3438 * 0.9523810148239136f);
  SV_Target.z = (_3439 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

#include "../../common.hlsl"

// Found in Slitterhead

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
  float3 HyperbolaToe : packoffset(c013.x);
  float2 HyperbolaMid : packoffset(c014.x);
  float3 HyperbolaShoulder : packoffset(c015.x);
  float4 HyperbolaThreshold : packoffset(c016.x);
  float2 HyperbolaMultiplier : packoffset(c017.x);
  float4 OverlayColor : packoffset(c018.x);
  float3 ColorScale : packoffset(c019.x);
  float4 ColorSaturation : packoffset(c020.x);
  float4 ColorContrast : packoffset(c021.x);
  float4 ColorGamma : packoffset(c022.x);
  float4 ColorGain : packoffset(c023.x);
  float4 ColorOffset : packoffset(c024.x);
  float4 ColorSaturationShadows : packoffset(c025.x);
  float4 ColorContrastShadows : packoffset(c026.x);
  float4 ColorGammaShadows : packoffset(c027.x);
  float4 ColorGainShadows : packoffset(c028.x);
  float4 ColorOffsetShadows : packoffset(c029.x);
  float4 ColorSaturationMidtones : packoffset(c030.x);
  float4 ColorContrastMidtones : packoffset(c031.x);
  float4 ColorGammaMidtones : packoffset(c032.x);
  float4 ColorGainMidtones : packoffset(c033.x);
  float4 ColorOffsetMidtones : packoffset(c034.x);
  float4 ColorSaturationHighlights : packoffset(c035.x);
  float4 ColorContrastHighlights : packoffset(c036.x);
  float4 ColorGammaHighlights : packoffset(c037.x);
  float4 ColorGainHighlights : packoffset(c038.x);
  float4 ColorOffsetHighlights : packoffset(c039.x);
  float LUTSize : packoffset(c040.x);
  float WhiteTemp : packoffset(c040.y);
  float WhiteTint : packoffset(c040.z);
  float ColorCorrectionShadowsMax : packoffset(c040.w);
  float ColorCorrectionHighlightsMin : packoffset(c041.x);
  float ColorCorrectionHighlightsMax : packoffset(c041.y);
  float BlueCorrection : packoffset(c041.z);
  float ExpandGamut : packoffset(c041.w);
  float ToneCurveAmount : packoffset(c042.x);
  float FilmSlope : packoffset(c042.y);
  float FilmToe : packoffset(c042.z);
  float FilmShoulder : packoffset(c042.w);
  float FilmBlackClip : packoffset(c043.x);
  float FilmWhiteClip : packoffset(c043.y);
  uint bUseMobileTonemapper : packoffset(c043.z);
  uint bIsTemperatureWhiteBalance : packoffset(c043.w);
  float3 MappingPolynomial : packoffset(c044.x);
  float3 InverseGamma : packoffset(c045.x);
  uint OutputDevice : packoffset(c045.w);
  uint OutputGamut : packoffset(c046.x);
  float OutputMaxLuminance : packoffset(c046.y);
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
  float _12 = 0.5f / LUTSize;
  float _17 = LUTSize + -1.0f;
  float _18 = (LUTSize * (TEXCOORD.x - _12)) / _17;
  float _19 = (LUTSize * (TEXCOORD.y - _12)) / _17;
  float _21 = float((uint)SV_RenderTargetArrayIndex) / _17;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _107;
  float _108;
  float _109;
  float _897;
  float _898;
  float _899;
  float _910;
  float _921;
  float _1034;
  float _1035;
  float _1036;
  float _1118;
  float _1119;
  float _1120;
  float _1297;
  float _1298;
  float _1299;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _30 = ((uint)(OutputGamut) == 4);
        _41 = select(_30, 1.0f, 1.7050515413284302f);
        _42 = select(_30, 0.0f, -0.6217905879020691f);
        _43 = select(_30, 0.0f, -0.0832584798336029f);
        _44 = select(_30, 0.0f, -0.13025718927383423f);
        _45 = select(_30, 1.0f, 1.1408027410507202f);
        _46 = select(_30, 0.0f, -0.010548528283834457f);
        _47 = select(_30, 0.0f, -0.024003278464078903f);
        _48 = select(_30, 0.0f, -0.1289687603712082f);
        _49 = select(_30, 1.0f, 1.152971863746643f);
      } else {
        _41 = 0.6954522132873535f;
        _42 = 0.14067870378494263f;
        _43 = 0.16386906802654266f;
        _44 = 0.044794563204050064f;
        _45 = 0.8596711158752441f;
        _46 = 0.0955343171954155f;
        _47 = -0.005525882821530104f;
        _48 = 0.004025210160762072f;
        _49 = 1.0015007257461548f;
      }
    } else {
      _41 = 1.02579927444458f;
      _42 = -0.020052503794431686f;
      _43 = -0.0057713985443115234f;
      _44 = -0.0022350111976265907f;
      _45 = 1.0045825242996216f;
      _46 = -0.002352306619286537f;
      _47 = -0.005014004185795784f;
      _48 = -0.025293385609984398f;
      _49 = 1.0304402112960815f;
    }
  } else {
    _41 = 1.379158854484558f;
    _42 = -0.3088507056236267f;
    _43 = -0.07034677267074585f;
    _44 = -0.06933528929948807f;
    _45 = 1.0822921991348267f;
    _46 = -0.012962047010660172f;
    _47 = -0.002159259282052517f;
    _48 = -0.045465391129255295f;
    _49 = 1.0477596521377563f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _60 = (pow(_18, 0.012683313339948654f));
    float _61 = (pow(_19, 0.012683313339948654f));
    float _62 = (pow(_21, 0.012683313339948654f));
    _107 = (exp2(log2(max(0.0f, (_60 + -0.8359375f)) / (18.8515625f - (_60 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _108 = (exp2(log2(max(0.0f, (_61 + -0.8359375f)) / (18.8515625f - (_61 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _109 = (exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _107 = ((exp2((_18 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _108 = ((exp2((_19 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _109 = ((exp2((_21 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _124 = mad((WorkingColorSpace_ToAP1[0].z), _109, mad((WorkingColorSpace_ToAP1[0].y), _108, ((WorkingColorSpace_ToAP1[0].x) * _107)));
  float _127 = mad((WorkingColorSpace_ToAP1[1].z), _109, mad((WorkingColorSpace_ToAP1[1].y), _108, ((WorkingColorSpace_ToAP1[1].x) * _107)));
  float _130 = mad((WorkingColorSpace_ToAP1[2].z), _109, mad((WorkingColorSpace_ToAP1[2].y), _108, ((WorkingColorSpace_ToAP1[2].x) * _107)));
  float _131 = dot(float3(_124, _127, _130), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUntonemappedAP1(float3(_124, _127, _130));

  float _135 = (_124 / _131) + -1.0f;
  float _136 = (_127 / _131) + -1.0f;
  float _137 = (_130 / _131) + -1.0f;
  float _149 = (1.0f - exp2(((_131 * _131) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_135, _136, _137), float3(_135, _136, _137)) * -4.0f));
  float _165 = ((mad(-0.06368283927440643f, _130, mad(-0.32929131388664246f, _127, (_124 * 1.370412826538086f))) - _124) * _149) + _124;
  float _166 = ((mad(-0.010861567221581936f, _130, mad(1.0970908403396606f, _127, (_124 * -0.08343426138162613f))) - _127) * _149) + _127;
  float _167 = ((mad(1.203694462776184f, _130, mad(-0.09862564504146576f, _127, (_124 * -0.02579325996339321f))) - _130) * _149) + _130;
  float _168 = dot(float3(_165, _166, _167), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _182 = ColorOffset.w + ColorOffsetShadows.w;
  float _196 = ColorGain.w * ColorGainShadows.w;
  float _210 = ColorGamma.w * ColorGammaShadows.w;
  float _224 = ColorContrast.w * ColorContrastShadows.w;
  float _238 = ColorSaturation.w * ColorSaturationShadows.w;
  float _242 = _165 - _168;
  float _243 = _166 - _168;
  float _244 = _167 - _168;
  float _301 = saturate(_168 / ColorCorrectionShadowsMax);
  float _305 = (_301 * _301) * (3.0f - (_301 * 2.0f));
  float _306 = 1.0f - _305;
  float _315 = ColorOffset.w + ColorOffsetHighlights.w;
  float _324 = ColorGain.w * ColorGainHighlights.w;
  float _333 = ColorGamma.w * ColorGammaHighlights.w;
  float _342 = ColorContrast.w * ColorContrastHighlights.w;
  float _351 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _414 = saturate((_168 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _418 = (_414 * _414) * (3.0f - (_414 * 2.0f));
  float _427 = ColorOffset.w + ColorOffsetMidtones.w;
  float _436 = ColorGain.w * ColorGainMidtones.w;
  float _445 = ColorGamma.w * ColorGammaMidtones.w;
  float _454 = ColorContrast.w * ColorContrastMidtones.w;
  float _463 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _521 = _305 - _418;
  float _537 = max((((_418 * (((ColorOffset.x + ColorOffsetHighlights.x) + _315) + (((ColorGain.x * ColorGainHighlights.x) * _324) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _342) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _351) * _242) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _333)))))) + (_306 * (((ColorOffset.x + ColorOffsetShadows.x) + _182) + (((ColorGain.x * ColorGainShadows.x) * _196) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _224) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _238) * _242) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _210))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _427) + (((ColorGain.x * ColorGainMidtones.x) * _436) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _454) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _463) * _242) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _445))))) * _521)), 9.999999974752427e-07f);
  float _538 = max((((_418 * (((ColorOffset.y + ColorOffsetHighlights.y) + _315) + (((ColorGain.y * ColorGainHighlights.y) * _324) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _342) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _351) * _243) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _333)))))) + (_306 * (((ColorOffset.y + ColorOffsetShadows.y) + _182) + (((ColorGain.y * ColorGainShadows.y) * _196) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _224) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _238) * _243) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _210))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _427) + (((ColorGain.y * ColorGainMidtones.y) * _436) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _454) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _463) * _243) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _445))))) * _521)), 9.999999974752427e-07f);
  float _539 = max((((_418 * (((ColorOffset.z + ColorOffsetHighlights.z) + _315) + (((ColorGain.z * ColorGainHighlights.z) * _324) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _342) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _351) * _244) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _333)))))) + (_306 * (((ColorOffset.z + ColorOffsetShadows.z) + _182) + (((ColorGain.z * ColorGainShadows.z) * _196) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _224) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _238) * _244) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _210))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _427) + (((ColorGain.z * ColorGainMidtones.z) * _436) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _454) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _463) * _244) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _445))))) * _521)), 9.999999974752427e-07f);
  float _558 = (log2(_537) + 9.720000267028809f) * 0.05707762390375137f;
  float _559 = (log2(_538) + 9.720000267028809f) * 0.05707762390375137f;
  float _560 = (log2(_539) + 9.720000267028809f) * 0.05707762390375137f;
  float _567 = ((((_537 * 10.540237426757812f) + 0.072905533015728f) - _558) * select((_537 > 0.0078125f), 0.0f, 1.0f)) + _558;
  float _568 = ((((_538 * 10.540237426757812f) + 0.072905533015728f) - _559) * select((_538 > 0.0078125f), 0.0f, 1.0f)) + _559;
  float _569 = ((((_539 * 10.540237426757812f) + 0.072905533015728f) - _560) * select((_539 > 0.0078125f), 0.0f, 1.0f)) + _560;
  float _572 = (_568 * 0.9375f) + 0.03125f;
  float _579 = _569 * 15.0f;
  float _580 = floor(_579);
  float _581 = _579 - _580;
  float _584 = ((_580 + 0.03125f) + (_567 * 0.9375f)) * 0.0625f;
  float4 _587 = Textures_1.Sample(Samplers_1, float2(_584, _572));
  float4 _594 = Textures_1.Sample(Samplers_1, float2((_584 + 0.0625f), _572));
  float _610 = ((lerp(_587.x, _594.x, _581)) * (LUTWeights[0].y)) + (_567 * (LUTWeights[0].x));
  float _611 = ((lerp(_587.y, _594.y, _581)) * (LUTWeights[0].y)) + (_568 * (LUTWeights[0].x));
  float _612 = ((lerp(_587.z, _594.z, _581)) * (LUTWeights[0].y)) + (_569 * (LUTWeights[0].x));
  float _631 = exp2((_610 * 17.520000457763672f) + -9.720000267028809f);
  float _632 = exp2((_611 * 17.520000457763672f) + -9.720000267028809f);
  float _633 = exp2((_612 * 17.520000457763672f) + -9.720000267028809f);
  float _640 = ((((_610 + -0.072905533015728f) * 0.09487452358007431f) - _631) * select((_610 > 0.155251145362854f), 0.0f, 1.0f)) + _631;
  float _641 = ((((_611 + -0.072905533015728f) * 0.09487452358007431f) - _632) * select((_611 > 0.155251145362854f), 0.0f, 1.0f)) + _632;
  float _642 = ((((_612 + -0.072905533015728f) * 0.09487452358007431f) - _633) * select((_612 > 0.155251145362854f), 0.0f, 1.0f)) + _633;
  float _679 = ((mad(0.061360642313957214f, _642, mad(-4.540197551250458e-09f, _641, (_640 * 0.9386394023895264f))) - _640) * BlueCorrection) + _640;
  float _680 = ((mad(0.169205904006958f, _642, mad(0.8307942152023315f, _641, (_640 * 6.775371730327606e-08f))) - _641) * BlueCorrection) + _641;
  float _681 = (mad(-2.3283064365386963e-10f, _641, (_640 * -9.313225746154785e-10f)) * BlueCorrection) + _642;
  float _696 = dot(float3(_679, _680, _681), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _703 = ((_679 - _696) * 0.9599999785423279f) + _696;
  float _704 = ((_680 - _696) * 0.9599999785423279f) + _696;
  float _705 = ((_681 - _696) * 0.9599999785423279f) + _696;
  float _706 = -0.0f - HyperbolaToe.x;
  float _722 = -0.0f - HyperbolaShoulder.x;
  float _741 = select((_703 < HyperbolaThreshold.x), ((_706 / (_703 + HyperbolaToe.y)) + HyperbolaToe.z), select((_703 < HyperbolaThreshold.y), ((_703 * HyperbolaMid.x) + HyperbolaMid.y), ((_722 / (_703 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _742 = select((_704 < HyperbolaThreshold.x), ((_706 / (_704 + HyperbolaToe.y)) + HyperbolaToe.z), select((_704 < HyperbolaThreshold.y), ((_704 * HyperbolaMid.x) + HyperbolaMid.y), ((_722 / (_704 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _743 = select((_705 < HyperbolaThreshold.x), ((_706 / (_705 + HyperbolaToe.y)) + HyperbolaToe.z), select((_705 < HyperbolaThreshold.y), ((_705 * HyperbolaMid.x) + HyperbolaMid.y), ((_722 / (_705 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _744 = dot(float3(_741, _742, _743), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _762 = (((_744 - _679) + ((_741 - _744) * 0.9300000071525574f)) * ToneCurveAmount) + _679;
  float _763 = (((_744 - _680) + ((_742 - _744) * 0.9300000071525574f)) * ToneCurveAmount) + _680;
  float _764 = (((_744 - _681) + ((_743 - _744) * 0.9300000071525574f)) * ToneCurveAmount) + _681;
  float _780 = ((mad(-0.06537103652954102f, _764, mad(1.451815478503704e-06f, _763, (_762 * 1.065374732017517f))) - _762) * BlueCorrection) + _762;
  float _781 = ((mad(-0.20366770029067993f, _764, mad(1.2036634683609009f, _763, (_762 * -2.57161445915699e-07f))) - _763) * BlueCorrection) + _763;
  float _782 = ((mad(0.9999996423721313f, _764, mad(2.0954757928848267e-08f, _763, (_762 * 1.862645149230957e-08f))) - _764) * BlueCorrection) + _764;

  SetTonemappedAP1(_780, _781, _782);

  float _792 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _782, mad((WorkingColorSpace_FromAP1[0].y), _781, ((WorkingColorSpace_FromAP1[0].x) * _780))));
  float _793 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _782, mad((WorkingColorSpace_FromAP1[1].y), _781, ((WorkingColorSpace_FromAP1[1].x) * _780))));
  float _794 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _782, mad((WorkingColorSpace_FromAP1[2].y), _781, ((WorkingColorSpace_FromAP1[2].x) * _780))));
  float _820 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _792)) * _792) + MappingPolynomial.z);
  float _821 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _793)) * _793) + MappingPolynomial.z);
  float _822 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _794)) * _794) + MappingPolynomial.z);
  float _829 = ((OverlayColor.x - _820) * OverlayColor.w) + _820;
  float _830 = ((OverlayColor.y - _821) * OverlayColor.w) + _821;
  float _831 = ((OverlayColor.z - _822) * OverlayColor.w) + _822;
  float _832 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _642, mad((WorkingColorSpace_FromAP1[0].y), _641, (_640 * (WorkingColorSpace_FromAP1[0].x))));
  float _833 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _642, mad((WorkingColorSpace_FromAP1[1].y), _641, (_640 * (WorkingColorSpace_FromAP1[1].x))));
  float _834 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _642, mad((WorkingColorSpace_FromAP1[2].y), _641, (_640 * (WorkingColorSpace_FromAP1[2].x))));
  float _841 = ((OverlayColor.x - _832) * OverlayColor.w) + _832;
  float _842 = ((OverlayColor.y - _833) * OverlayColor.w) + _833;
  float _843 = ((OverlayColor.z - _834) * OverlayColor.w) + _834;
  float _855 = exp2(log2(max(0.0f, _829)) * InverseGamma.y);
  float _856 = exp2(log2(max(0.0f, _830)) * InverseGamma.y);
  float _857 = exp2(log2(max(0.0f, _831)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_855, _856, _857));
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _880 = mad((WorkingColorSpace_ToAP1[0].z), _857, mad((WorkingColorSpace_ToAP1[0].y), _856, ((WorkingColorSpace_ToAP1[0].x) * _855)));
        float _883 = mad((WorkingColorSpace_ToAP1[1].z), _857, mad((WorkingColorSpace_ToAP1[1].y), _856, ((WorkingColorSpace_ToAP1[1].x) * _855)));
        float _886 = mad((WorkingColorSpace_ToAP1[2].z), _857, mad((WorkingColorSpace_ToAP1[2].y), _856, ((WorkingColorSpace_ToAP1[2].x) * _855)));
        _897 = mad(_43, _886, mad(_42, _883, (_880 * _41)));
        _898 = mad(_46, _886, mad(_45, _883, (_880 * _44)));
        _899 = mad(_49, _886, mad(_48, _883, (_880 * _47)));
      } else {
        _897 = _855;
        _898 = _856;
        _899 = _857;
      }
      do {
        if (_897 < 0.0031306699384003878f) {
          _910 = (_897 * 12.920000076293945f);
        } else {
          _910 = (((pow(_897, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_898 < 0.0031306699384003878f) {
            _921 = (_898 * 12.920000076293945f);
          } else {
            _921 = (((pow(_898, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_899 < 0.0031306699384003878f) {
            _1297 = _910;
            _1298 = _921;
            _1299 = (_899 * 12.920000076293945f);
          } else {
            _1297 = _910;
            _1298 = _921;
            _1299 = (((pow(_899, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _948 = mad((WorkingColorSpace_ToAP1[0].z), _857, mad((WorkingColorSpace_ToAP1[0].y), _856, ((WorkingColorSpace_ToAP1[0].x) * _855)));
      float _951 = mad((WorkingColorSpace_ToAP1[1].z), _857, mad((WorkingColorSpace_ToAP1[1].y), _856, ((WorkingColorSpace_ToAP1[1].x) * _855)));
      float _954 = mad((WorkingColorSpace_ToAP1[2].z), _857, mad((WorkingColorSpace_ToAP1[2].y), _856, ((WorkingColorSpace_ToAP1[2].x) * _855)));
      float _964 = max(6.103519990574569e-05f, mad(_43, _954, mad(_42, _951, (_948 * _41))));
      float _965 = max(6.103519990574569e-05f, mad(_46, _954, mad(_45, _951, (_948 * _44))));
      float _966 = max(6.103519990574569e-05f, mad(_49, _954, mad(_48, _951, (_948 * _47))));
      _1297 = min((_964 * 4.5f), ((exp2(log2(max(_964, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1298 = min((_965 * 4.5f), ((exp2(log2(max(_965, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1299 = min((_966 * 4.5f), ((exp2(log2(max(_966, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        float _998 = HyperbolaMultiplier.x * _829;
        float _999 = HyperbolaMultiplier.x * _830;
        float _1000 = HyperbolaMultiplier.x * _831;
        float _1015 = mad((WorkingColorSpace_ToAP1[0].z), _1000, mad((WorkingColorSpace_ToAP1[0].y), _999, ((WorkingColorSpace_ToAP1[0].x) * _998)));
        float _1018 = mad((WorkingColorSpace_ToAP1[1].z), _1000, mad((WorkingColorSpace_ToAP1[1].y), _999, ((WorkingColorSpace_ToAP1[1].x) * _998)));
        float _1021 = mad((WorkingColorSpace_ToAP1[2].z), _1000, mad((WorkingColorSpace_ToAP1[2].y), _999, ((WorkingColorSpace_ToAP1[2].x) * _998)));
        do {
          if (!((uint)(OutputDevice) == 5)) {
            _1034 = mad(_43, _1021, mad(_42, _1018, (_1015 * _41)));
            _1035 = mad(_46, _1021, mad(_45, _1018, (_1015 * _44)));
            _1036 = mad(_49, _1021, mad(_48, _1018, (_1015 * _47)));
          } else {
            _1034 = _1015;
            _1035 = _1018;
            _1036 = _1021;
          }
          float _1046 = exp2(log2(_1034 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1047 = exp2(log2(_1035 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1048 = exp2(log2(_1036 * 9.999999747378752e-05f) * 0.1593017578125f);
          _1297 = exp2(log2((1.0f / ((_1046 * 18.6875f) + 1.0f)) * ((_1046 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1298 = exp2(log2((1.0f / ((_1047 * 18.6875f) + 1.0f)) * ((_1047 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1299 = exp2(log2((1.0f / ((_1048 * 18.6875f) + 1.0f)) * ((_1048 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        } while (false);
      } else {
        if (((uint)(OutputDevice) & -3) == 4) {
          float _1082 = HyperbolaMultiplier.x * _829;
          float _1083 = HyperbolaMultiplier.x * _830;
          float _1084 = HyperbolaMultiplier.x * _831;
          float _1099 = mad((WorkingColorSpace_ToAP1[0].z), _1084, mad((WorkingColorSpace_ToAP1[0].y), _1083, ((WorkingColorSpace_ToAP1[0].x) * _1082)));
          float _1102 = mad((WorkingColorSpace_ToAP1[1].z), _1084, mad((WorkingColorSpace_ToAP1[1].y), _1083, ((WorkingColorSpace_ToAP1[1].x) * _1082)));
          float _1105 = mad((WorkingColorSpace_ToAP1[2].z), _1084, mad((WorkingColorSpace_ToAP1[2].y), _1083, ((WorkingColorSpace_ToAP1[2].x) * _1082)));
          do {
            if (!((uint)(OutputDevice) == 6)) {
              _1118 = mad(_43, _1105, mad(_42, _1102, (_1099 * _41)));
              _1119 = mad(_46, _1105, mad(_45, _1102, (_1099 * _44)));
              _1120 = mad(_49, _1105, mad(_48, _1102, (_1099 * _47)));
            } else {
              _1118 = _1099;
              _1119 = _1102;
              _1120 = _1105;
            }
            float _1130 = exp2(log2(_1118 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1131 = exp2(log2(_1119 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1132 = exp2(log2(_1120 * 9.999999747378752e-05f) * 0.1593017578125f);
            _1297 = exp2(log2((1.0f / ((_1130 * 18.6875f) + 1.0f)) * ((_1130 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1298 = exp2(log2((1.0f / ((_1131 * 18.6875f) + 1.0f)) * ((_1131 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1299 = exp2(log2((1.0f / ((_1132 * 18.6875f) + 1.0f)) * ((_1132 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } while (false);
        } else {
          if ((uint)(OutputDevice) == 7) {
            float _1177 = mad((WorkingColorSpace_ToAP1[0].z), _843, mad((WorkingColorSpace_ToAP1[0].y), _842, ((WorkingColorSpace_ToAP1[0].x) * _841)));
            float _1180 = mad((WorkingColorSpace_ToAP1[1].z), _843, mad((WorkingColorSpace_ToAP1[1].y), _842, ((WorkingColorSpace_ToAP1[1].x) * _841)));
            float _1183 = mad((WorkingColorSpace_ToAP1[2].z), _843, mad((WorkingColorSpace_ToAP1[2].y), _842, ((WorkingColorSpace_ToAP1[2].x) * _841)));
            float _1202 = exp2(log2(mad(_43, _1183, mad(_42, _1180, (_1177 * _41))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1203 = exp2(log2(mad(_46, _1183, mad(_45, _1180, (_1177 * _44))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1204 = exp2(log2(mad(_49, _1183, mad(_48, _1180, (_1177 * _47))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _1297 = exp2(log2((1.0f / ((_1202 * 18.6875f) + 1.0f)) * ((_1202 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1298 = exp2(log2((1.0f / ((_1203 * 18.6875f) + 1.0f)) * ((_1203 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1299 = exp2(log2((1.0f / ((_1204 * 18.6875f) + 1.0f)) * ((_1204 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _1251 = mad((WorkingColorSpace_ToAP1[0].z), _831, mad((WorkingColorSpace_ToAP1[0].y), _830, ((WorkingColorSpace_ToAP1[0].x) * _829)));
                float _1254 = mad((WorkingColorSpace_ToAP1[1].z), _831, mad((WorkingColorSpace_ToAP1[1].y), _830, ((WorkingColorSpace_ToAP1[1].x) * _829)));
                float _1257 = mad((WorkingColorSpace_ToAP1[2].z), _831, mad((WorkingColorSpace_ToAP1[2].y), _830, ((WorkingColorSpace_ToAP1[2].x) * _829)));
                _1297 = mad(_43, _1257, mad(_42, _1254, (_1251 * _41)));
                _1298 = mad(_46, _1257, mad(_45, _1254, (_1251 * _44)));
                _1299 = mad(_49, _1257, mad(_48, _1254, (_1251 * _47)));
              } else {
                float _1270 = mad((WorkingColorSpace_ToAP1[0].z), _857, mad((WorkingColorSpace_ToAP1[0].y), _856, ((WorkingColorSpace_ToAP1[0].x) * _855)));
                float _1273 = mad((WorkingColorSpace_ToAP1[1].z), _857, mad((WorkingColorSpace_ToAP1[1].y), _856, ((WorkingColorSpace_ToAP1[1].x) * _855)));
                float _1276 = mad((WorkingColorSpace_ToAP1[2].z), _857, mad((WorkingColorSpace_ToAP1[2].y), _856, ((WorkingColorSpace_ToAP1[2].x) * _855)));
                _1297 = exp2(log2(mad(_43, _1276, mad(_42, _1273, (_1270 * _41)))) * InverseGamma.z);
                _1298 = exp2(log2(mad(_46, _1276, mad(_45, _1273, (_1270 * _44)))) * InverseGamma.z);
                _1299 = exp2(log2(mad(_49, _1276, mad(_48, _1273, (_1270 * _47)))) * InverseGamma.z);
              }
            } else {
              _1297 = _841;
              _1298 = _842;
              _1299 = _843;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_1297 * 0.9523810148239136f);
  SV_Target.y = (_1298 * 0.9523810148239136f);
  SV_Target.z = (_1299 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

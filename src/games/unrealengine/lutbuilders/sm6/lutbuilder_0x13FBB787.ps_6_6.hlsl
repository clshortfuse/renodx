#include "../../common.hlsl"

// Found in Slitterhead

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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _10 = 0.5f / LUTSize;
  float _15 = LUTSize + -1.0f;
  float _16 = (LUTSize * (TEXCOORD.x - _10)) / _15;
  float _17 = (LUTSize * (TEXCOORD.y - _10)) / _15;
  float _19 = float((uint)SV_RenderTargetArrayIndex) / _15;
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _105;
  float _106;
  float _107;
  float _790;
  float _791;
  float _792;
  float _803;
  float _814;
  float _927;
  float _928;
  float _929;
  float _1011;
  float _1012;
  float _1013;
  float _1190;
  float _1191;
  float _1192;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _28 = ((uint)(OutputGamut) == 4);
        _39 = select(_28, 1.0f, 1.7050515413284302f);
        _40 = select(_28, 0.0f, -0.6217905879020691f);
        _41 = select(_28, 0.0f, -0.0832584798336029f);
        _42 = select(_28, 0.0f, -0.13025718927383423f);
        _43 = select(_28, 1.0f, 1.1408027410507202f);
        _44 = select(_28, 0.0f, -0.010548528283834457f);
        _45 = select(_28, 0.0f, -0.024003278464078903f);
        _46 = select(_28, 0.0f, -0.1289687603712082f);
        _47 = select(_28, 1.0f, 1.152971863746643f);
      } else {
        _39 = 0.6954522132873535f;
        _40 = 0.14067870378494263f;
        _41 = 0.16386906802654266f;
        _42 = 0.044794563204050064f;
        _43 = 0.8596711158752441f;
        _44 = 0.0955343171954155f;
        _45 = -0.005525882821530104f;
        _46 = 0.004025210160762072f;
        _47 = 1.0015007257461548f;
      }
    } else {
      _39 = 1.02579927444458f;
      _40 = -0.020052503794431686f;
      _41 = -0.0057713985443115234f;
      _42 = -0.0022350111976265907f;
      _43 = 1.0045825242996216f;
      _44 = -0.002352306619286537f;
      _45 = -0.005014004185795784f;
      _46 = -0.025293385609984398f;
      _47 = 1.0304402112960815f;
    }
  } else {
    _39 = 1.379158854484558f;
    _40 = -0.3088507056236267f;
    _41 = -0.07034677267074585f;
    _42 = -0.06933528929948807f;
    _43 = 1.0822921991348267f;
    _44 = -0.012962047010660172f;
    _45 = -0.002159259282052517f;
    _46 = -0.045465391129255295f;
    _47 = 1.0477596521377563f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _58 = (pow(_16, 0.012683313339948654f));
    float _59 = (pow(_17, 0.012683313339948654f));
    float _60 = (pow(_19, 0.012683313339948654f));
    _105 = (exp2(log2(max(0.0f, (_58 + -0.8359375f)) / (18.8515625f - (_58 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _106 = (exp2(log2(max(0.0f, (_59 + -0.8359375f)) / (18.8515625f - (_59 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _107 = (exp2(log2(max(0.0f, (_60 + -0.8359375f)) / (18.8515625f - (_60 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _105 = ((exp2((_16 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _106 = ((exp2((_17 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _107 = ((exp2((_19 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _122 = mad((WorkingColorSpace_ToAP1[0].z), _107, mad((WorkingColorSpace_ToAP1[0].y), _106, ((WorkingColorSpace_ToAP1[0].x) * _105)));
  float _125 = mad((WorkingColorSpace_ToAP1[1].z), _107, mad((WorkingColorSpace_ToAP1[1].y), _106, ((WorkingColorSpace_ToAP1[1].x) * _105)));
  float _128 = mad((WorkingColorSpace_ToAP1[2].z), _107, mad((WorkingColorSpace_ToAP1[2].y), _106, ((WorkingColorSpace_ToAP1[2].x) * _105)));
  float _129 = dot(float3(_122, _125, _128), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUntonemappedAP1(float3(_122, _125, _128));

  float _133 = (_122 / _129) + -1.0f;
  float _134 = (_125 / _129) + -1.0f;
  float _135 = (_128 / _129) + -1.0f;
  float _147 = (1.0f - exp2(((_129 * _129) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_133, _134, _135), float3(_133, _134, _135)) * -4.0f));
  float _163 = ((mad(-0.06368283927440643f, _128, mad(-0.32929131388664246f, _125, (_122 * 1.370412826538086f))) - _122) * _147) + _122;
  float _164 = ((mad(-0.010861567221581936f, _128, mad(1.0970908403396606f, _125, (_122 * -0.08343426138162613f))) - _125) * _147) + _125;
  float _165 = ((mad(1.203694462776184f, _128, mad(-0.09862564504146576f, _125, (_122 * -0.02579325996339321f))) - _128) * _147) + _128;
  float _166 = dot(float3(_163, _164, _165), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _180 = ColorOffset.w + ColorOffsetShadows.w;
  float _194 = ColorGain.w * ColorGainShadows.w;
  float _208 = ColorGamma.w * ColorGammaShadows.w;
  float _222 = ColorContrast.w * ColorContrastShadows.w;
  float _236 = ColorSaturation.w * ColorSaturationShadows.w;
  float _240 = _163 - _166;
  float _241 = _164 - _166;
  float _242 = _165 - _166;
  float _299 = saturate(_166 / ColorCorrectionShadowsMax);
  float _303 = (_299 * _299) * (3.0f - (_299 * 2.0f));
  float _304 = 1.0f - _303;
  float _313 = ColorOffset.w + ColorOffsetHighlights.w;
  float _322 = ColorGain.w * ColorGainHighlights.w;
  float _331 = ColorGamma.w * ColorGammaHighlights.w;
  float _340 = ColorContrast.w * ColorContrastHighlights.w;
  float _349 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _412 = saturate((_166 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _416 = (_412 * _412) * (3.0f - (_412 * 2.0f));
  float _425 = ColorOffset.w + ColorOffsetMidtones.w;
  float _434 = ColorGain.w * ColorGainMidtones.w;
  float _443 = ColorGamma.w * ColorGammaMidtones.w;
  float _452 = ColorContrast.w * ColorContrastMidtones.w;
  float _461 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _519 = _303 - _416;
  float _530 = ((_416 * (((ColorOffset.x + ColorOffsetHighlights.x) + _313) + (((ColorGain.x * ColorGainHighlights.x) * _322) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _340) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _349) * _240) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _331)))))) + (_304 * (((ColorOffset.x + ColorOffsetShadows.x) + _180) + (((ColorGain.x * ColorGainShadows.x) * _194) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _222) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _236) * _240) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _208))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _425) + (((ColorGain.x * ColorGainMidtones.x) * _434) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _452) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _461) * _240) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _443))))) * _519);
  float _532 = ((_416 * (((ColorOffset.y + ColorOffsetHighlights.y) + _313) + (((ColorGain.y * ColorGainHighlights.y) * _322) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _340) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _349) * _241) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _331)))))) + (_304 * (((ColorOffset.y + ColorOffsetShadows.y) + _180) + (((ColorGain.y * ColorGainShadows.y) * _194) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _222) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _236) * _241) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _208))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _425) + (((ColorGain.y * ColorGainMidtones.y) * _434) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _452) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _461) * _241) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _443))))) * _519);
  float _534 = ((_416 * (((ColorOffset.z + ColorOffsetHighlights.z) + _313) + (((ColorGain.z * ColorGainHighlights.z) * _322) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _340) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _349) * _242) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _331)))))) + (_304 * (((ColorOffset.z + ColorOffsetShadows.z) + _180) + (((ColorGain.z * ColorGainShadows.z) * _194) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _222) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _236) * _242) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _208))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _425) + (((ColorGain.z * ColorGainMidtones.z) * _434) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _452) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _461) * _242) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _443))))) * _519);
  float _570 = ((mad(0.061360642313957214f, _534, mad(-4.540197551250458e-09f, _532, (_530 * 0.9386394023895264f))) - _530) * BlueCorrection) + _530;
  float _571 = ((mad(0.169205904006958f, _534, mad(0.8307942152023315f, _532, (_530 * 6.775371730327606e-08f))) - _532) * BlueCorrection) + _532;
  float _572 = (mad(-2.3283064365386963e-10f, _532, (_530 * -9.313225746154785e-10f)) * BlueCorrection) + _534;
  float _587 = dot(float3(_570, _571, _572), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _594 = ((_570 - _587) * 0.9599999785423279f) + _587;
  float _595 = ((_571 - _587) * 0.9599999785423279f) + _587;
  float _596 = ((_572 - _587) * 0.9599999785423279f) + _587;
  float _597 = -0.0f - HyperbolaToe.x;
  float _613 = -0.0f - HyperbolaShoulder.x;
  float _632 = select((_594 < HyperbolaThreshold.x), ((_597 / (_594 + HyperbolaToe.y)) + HyperbolaToe.z), select((_594 < HyperbolaThreshold.y), ((_594 * HyperbolaMid.x) + HyperbolaMid.y), ((_613 / (_594 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _633 = select((_595 < HyperbolaThreshold.x), ((_597 / (_595 + HyperbolaToe.y)) + HyperbolaToe.z), select((_595 < HyperbolaThreshold.y), ((_595 * HyperbolaMid.x) + HyperbolaMid.y), ((_613 / (_595 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _634 = select((_596 < HyperbolaThreshold.x), ((_597 / (_596 + HyperbolaToe.y)) + HyperbolaToe.z), select((_596 < HyperbolaThreshold.y), ((_596 * HyperbolaMid.x) + HyperbolaMid.y), ((_613 / (_596 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _635 = dot(float3(_632, _633, _634), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _653 = (((_635 - _570) + ((_632 - _635) * 0.9300000071525574f)) * ToneCurveAmount) + _570;
  float _654 = (((_635 - _571) + ((_633 - _635) * 0.9300000071525574f)) * ToneCurveAmount) + _571;
  float _655 = (((_635 - _572) + ((_634 - _635) * 0.9300000071525574f)) * ToneCurveAmount) + _572;
  float _673 = ((mad(-0.06537103652954102f, _655, mad(1.451815478503704e-06f, _654, (_653 * 1.065374732017517f))) - _653) * BlueCorrection) + _653;
  float _674 = ((mad(-0.20366770029067993f, _655, mad(1.2036634683609009f, _654, (_653 * -2.57161445915699e-07f))) - _654) * BlueCorrection) + _654;
  float _675 = ((mad(0.9999996423721313f, _655, mad(2.0954757928848267e-08f, _654, (_653 * 1.862645149230957e-08f))) - _655) * BlueCorrection) + _655;

  SetTonemappedAP1(_673, _674, _675);

  float _685 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _675, mad((WorkingColorSpace_FromAP1[0].y), _674, ((WorkingColorSpace_FromAP1[0].x) * _673))));
  float _686 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _675, mad((WorkingColorSpace_FromAP1[1].y), _674, ((WorkingColorSpace_FromAP1[1].x) * _673))));
  float _687 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _675, mad((WorkingColorSpace_FromAP1[2].y), _674, ((WorkingColorSpace_FromAP1[2].x) * _673))));
  float _713 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _685)) * _685) + MappingPolynomial.z);
  float _714 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _686)) * _686) + MappingPolynomial.z);
  float _715 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _687)) * _687) + MappingPolynomial.z);
  float _722 = ((OverlayColor.x - _713) * OverlayColor.w) + _713;
  float _723 = ((OverlayColor.y - _714) * OverlayColor.w) + _714;
  float _724 = ((OverlayColor.z - _715) * OverlayColor.w) + _715;
  float _725 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _534, mad((WorkingColorSpace_FromAP1[0].y), _532, (_530 * (WorkingColorSpace_FromAP1[0].x))));
  float _726 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _534, mad((WorkingColorSpace_FromAP1[1].y), _532, ((WorkingColorSpace_FromAP1[1].x) * _530)));
  float _727 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _534, mad((WorkingColorSpace_FromAP1[2].y), _532, ((WorkingColorSpace_FromAP1[2].x) * _530)));
  float _734 = ((OverlayColor.x - _725) * OverlayColor.w) + _725;
  float _735 = ((OverlayColor.y - _726) * OverlayColor.w) + _726;
  float _736 = ((OverlayColor.z - _727) * OverlayColor.w) + _727;
  float _748 = exp2(log2(max(0.0f, _722)) * InverseGamma.y);
  float _749 = exp2(log2(max(0.0f, _723)) * InverseGamma.y);
  float _750 = exp2(log2(max(0.0f, _724)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_748, _749, _750));
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _773 = mad((WorkingColorSpace_ToAP1[0].z), _750, mad((WorkingColorSpace_ToAP1[0].y), _749, ((WorkingColorSpace_ToAP1[0].x) * _748)));
        float _776 = mad((WorkingColorSpace_ToAP1[1].z), _750, mad((WorkingColorSpace_ToAP1[1].y), _749, ((WorkingColorSpace_ToAP1[1].x) * _748)));
        float _779 = mad((WorkingColorSpace_ToAP1[2].z), _750, mad((WorkingColorSpace_ToAP1[2].y), _749, ((WorkingColorSpace_ToAP1[2].x) * _748)));
        _790 = mad(_41, _779, mad(_40, _776, (_773 * _39)));
        _791 = mad(_44, _779, mad(_43, _776, (_773 * _42)));
        _792 = mad(_47, _779, mad(_46, _776, (_773 * _45)));
      } else {
        _790 = _748;
        _791 = _749;
        _792 = _750;
      }
      do {
        if (_790 < 0.0031306699384003878f) {
          _803 = (_790 * 12.920000076293945f);
        } else {
          _803 = (((pow(_790, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_791 < 0.0031306699384003878f) {
            _814 = (_791 * 12.920000076293945f);
          } else {
            _814 = (((pow(_791, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_792 < 0.0031306699384003878f) {
            _1190 = _803;
            _1191 = _814;
            _1192 = (_792 * 12.920000076293945f);
          } else {
            _1190 = _803;
            _1191 = _814;
            _1192 = (((pow(_792, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _841 = mad((WorkingColorSpace_ToAP1[0].z), _750, mad((WorkingColorSpace_ToAP1[0].y), _749, ((WorkingColorSpace_ToAP1[0].x) * _748)));
      float _844 = mad((WorkingColorSpace_ToAP1[1].z), _750, mad((WorkingColorSpace_ToAP1[1].y), _749, ((WorkingColorSpace_ToAP1[1].x) * _748)));
      float _847 = mad((WorkingColorSpace_ToAP1[2].z), _750, mad((WorkingColorSpace_ToAP1[2].y), _749, ((WorkingColorSpace_ToAP1[2].x) * _748)));
      float _857 = max(6.103519990574569e-05f, mad(_41, _847, mad(_40, _844, (_841 * _39))));
      float _858 = max(6.103519990574569e-05f, mad(_44, _847, mad(_43, _844, (_841 * _42))));
      float _859 = max(6.103519990574569e-05f, mad(_47, _847, mad(_46, _844, (_841 * _45))));
      _1190 = min((_857 * 4.5f), ((exp2(log2(max(_857, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1191 = min((_858 * 4.5f), ((exp2(log2(max(_858, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1192 = min((_859 * 4.5f), ((exp2(log2(max(_859, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        float _891 = HyperbolaMultiplier.x * _722;
        float _892 = HyperbolaMultiplier.x * _723;
        float _893 = HyperbolaMultiplier.x * _724;
        float _908 = mad((WorkingColorSpace_ToAP1[0].z), _893, mad((WorkingColorSpace_ToAP1[0].y), _892, ((WorkingColorSpace_ToAP1[0].x) * _891)));
        float _911 = mad((WorkingColorSpace_ToAP1[1].z), _893, mad((WorkingColorSpace_ToAP1[1].y), _892, ((WorkingColorSpace_ToAP1[1].x) * _891)));
        float _914 = mad((WorkingColorSpace_ToAP1[2].z), _893, mad((WorkingColorSpace_ToAP1[2].y), _892, ((WorkingColorSpace_ToAP1[2].x) * _891)));
        do {
          if (!((uint)(OutputDevice) == 5)) {
            _927 = mad(_41, _914, mad(_40, _911, (_908 * _39)));
            _928 = mad(_44, _914, mad(_43, _911, (_908 * _42)));
            _929 = mad(_47, _914, mad(_46, _911, (_908 * _45)));
          } else {
            _927 = _908;
            _928 = _911;
            _929 = _914;
          }
          float _939 = exp2(log2(_927 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _940 = exp2(log2(_928 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _941 = exp2(log2(_929 * 9.999999747378752e-05f) * 0.1593017578125f);
          _1190 = exp2(log2((1.0f / ((_939 * 18.6875f) + 1.0f)) * ((_939 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1191 = exp2(log2((1.0f / ((_940 * 18.6875f) + 1.0f)) * ((_940 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1192 = exp2(log2((1.0f / ((_941 * 18.6875f) + 1.0f)) * ((_941 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        } while (false);
      } else {
        if (((uint)(OutputDevice) & -3) == 4) {
          float _975 = HyperbolaMultiplier.x * _722;
          float _976 = HyperbolaMultiplier.x * _723;
          float _977 = HyperbolaMultiplier.x * _724;
          float _992 = mad((WorkingColorSpace_ToAP1[0].z), _977, mad((WorkingColorSpace_ToAP1[0].y), _976, ((WorkingColorSpace_ToAP1[0].x) * _975)));
          float _995 = mad((WorkingColorSpace_ToAP1[1].z), _977, mad((WorkingColorSpace_ToAP1[1].y), _976, ((WorkingColorSpace_ToAP1[1].x) * _975)));
          float _998 = mad((WorkingColorSpace_ToAP1[2].z), _977, mad((WorkingColorSpace_ToAP1[2].y), _976, ((WorkingColorSpace_ToAP1[2].x) * _975)));
          do {
            if (!((uint)(OutputDevice) == 6)) {
              _1011 = mad(_41, _998, mad(_40, _995, (_992 * _39)));
              _1012 = mad(_44, _998, mad(_43, _995, (_992 * _42)));
              _1013 = mad(_47, _998, mad(_46, _995, (_992 * _45)));
            } else {
              _1011 = _992;
              _1012 = _995;
              _1013 = _998;
            }
            float _1023 = exp2(log2(_1011 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1024 = exp2(log2(_1012 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1025 = exp2(log2(_1013 * 9.999999747378752e-05f) * 0.1593017578125f);
            _1190 = exp2(log2((1.0f / ((_1023 * 18.6875f) + 1.0f)) * ((_1023 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1191 = exp2(log2((1.0f / ((_1024 * 18.6875f) + 1.0f)) * ((_1024 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1192 = exp2(log2((1.0f / ((_1025 * 18.6875f) + 1.0f)) * ((_1025 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } while (false);
        } else {
          if ((uint)(OutputDevice) == 7) {
            float _1070 = mad((WorkingColorSpace_ToAP1[0].z), _736, mad((WorkingColorSpace_ToAP1[0].y), _735, ((WorkingColorSpace_ToAP1[0].x) * _734)));
            float _1073 = mad((WorkingColorSpace_ToAP1[1].z), _736, mad((WorkingColorSpace_ToAP1[1].y), _735, ((WorkingColorSpace_ToAP1[1].x) * _734)));
            float _1076 = mad((WorkingColorSpace_ToAP1[2].z), _736, mad((WorkingColorSpace_ToAP1[2].y), _735, ((WorkingColorSpace_ToAP1[2].x) * _734)));
            float _1095 = exp2(log2(mad(_41, _1076, mad(_40, _1073, (_1070 * _39))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1096 = exp2(log2(mad(_44, _1076, mad(_43, _1073, (_1070 * _42))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1097 = exp2(log2(mad(_47, _1076, mad(_46, _1073, (_1070 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _1190 = exp2(log2((1.0f / ((_1095 * 18.6875f) + 1.0f)) * ((_1095 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1191 = exp2(log2((1.0f / ((_1096 * 18.6875f) + 1.0f)) * ((_1096 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1192 = exp2(log2((1.0f / ((_1097 * 18.6875f) + 1.0f)) * ((_1097 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _1144 = mad((WorkingColorSpace_ToAP1[0].z), _724, mad((WorkingColorSpace_ToAP1[0].y), _723, ((WorkingColorSpace_ToAP1[0].x) * _722)));
                float _1147 = mad((WorkingColorSpace_ToAP1[1].z), _724, mad((WorkingColorSpace_ToAP1[1].y), _723, ((WorkingColorSpace_ToAP1[1].x) * _722)));
                float _1150 = mad((WorkingColorSpace_ToAP1[2].z), _724, mad((WorkingColorSpace_ToAP1[2].y), _723, ((WorkingColorSpace_ToAP1[2].x) * _722)));
                _1190 = mad(_41, _1150, mad(_40, _1147, (_1144 * _39)));
                _1191 = mad(_44, _1150, mad(_43, _1147, (_1144 * _42)));
                _1192 = mad(_47, _1150, mad(_46, _1147, (_1144 * _45)));
              } else {
                float _1163 = mad((WorkingColorSpace_ToAP1[0].z), _750, mad((WorkingColorSpace_ToAP1[0].y), _749, ((WorkingColorSpace_ToAP1[0].x) * _748)));
                float _1166 = mad((WorkingColorSpace_ToAP1[1].z), _750, mad((WorkingColorSpace_ToAP1[1].y), _749, ((WorkingColorSpace_ToAP1[1].x) * _748)));
                float _1169 = mad((WorkingColorSpace_ToAP1[2].z), _750, mad((WorkingColorSpace_ToAP1[2].y), _749, ((WorkingColorSpace_ToAP1[2].x) * _748)));
                _1190 = exp2(log2(mad(_41, _1169, mad(_40, _1166, (_1163 * _39)))) * InverseGamma.z);
                _1191 = exp2(log2(mad(_44, _1169, mad(_43, _1166, (_1163 * _42)))) * InverseGamma.z);
                _1192 = exp2(log2(mad(_47, _1169, mad(_46, _1166, (_1163 * _45)))) * InverseGamma.z);
              }
            } else {
              _1190 = _734;
              _1191 = _735;
              _1192 = _736;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_1190 * 0.9523810148239136f);
  SV_Target.y = (_1191 * 0.9523810148239136f);
  SV_Target.z = (_1192 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

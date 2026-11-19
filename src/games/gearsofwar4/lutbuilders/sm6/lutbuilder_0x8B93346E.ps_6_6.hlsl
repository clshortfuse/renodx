#include "../../common.hlsl"

// Found in Slitterhead

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

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

SamplerState Samplers_2 : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _14 = 0.5f / LUTSize;
  float _19 = LUTSize + -1.0f;
  float _20 = (LUTSize * (TEXCOORD.x - _14)) / _19;
  float _21 = (LUTSize * (TEXCOORD.y - _14)) / _19;
  float _23 = float((uint)SV_RenderTargetArrayIndex) / _19;
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
  float _928;
  float _929;
  float _930;
  float _941;
  float _952;
  float _1065;
  float _1066;
  float _1067;
  float _1149;
  float _1150;
  float _1151;
  float _1328;
  float _1329;
  float _1330;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _32 = ((uint)(OutputGamut) == 4);
        _43 = select(_32, 1.0f, 1.7050515413284302f);
        _44 = select(_32, 0.0f, -0.6217905879020691f);
        _45 = select(_32, 0.0f, -0.0832584798336029f);
        _46 = select(_32, 0.0f, -0.13025718927383423f);
        _47 = select(_32, 1.0f, 1.1408027410507202f);
        _48 = select(_32, 0.0f, -0.010548528283834457f);
        _49 = select(_32, 0.0f, -0.024003278464078903f);
        _50 = select(_32, 0.0f, -0.1289687603712082f);
        _51 = select(_32, 1.0f, 1.152971863746643f);
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
      _43 = 1.02579927444458f;
      _44 = -0.020052503794431686f;
      _45 = -0.0057713985443115234f;
      _46 = -0.0022350111976265907f;
      _47 = 1.0045825242996216f;
      _48 = -0.002352306619286537f;
      _49 = -0.005014004185795784f;
      _50 = -0.025293385609984398f;
      _51 = 1.0304402112960815f;
    }
  } else {
    _43 = 1.379158854484558f;
    _44 = -0.3088507056236267f;
    _45 = -0.07034677267074585f;
    _46 = -0.06933528929948807f;
    _47 = 1.0822921991348267f;
    _48 = -0.012962047010660172f;
    _49 = -0.002159259282052517f;
    _50 = -0.045465391129255295f;
    _51 = 1.0477596521377563f;
  }
  if ((uint)(uint)(OutputDevice) > (uint)2) {
    float _62 = (pow(_20, 0.012683313339948654f));
    float _63 = (pow(_21, 0.012683313339948654f));
    float _64 = (pow(_23, 0.012683313339948654f));
    _109 = (exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _110 = (exp2(log2(max(0.0f, (_63 + -0.8359375f)) / (18.8515625f - (_63 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _111 = (exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _109 = ((exp2((_20 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _110 = ((exp2((_21 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _111 = ((exp2((_23 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _126 = mad((WorkingColorSpace_ToAP1[0].z), _111, mad((WorkingColorSpace_ToAP1[0].y), _110, ((WorkingColorSpace_ToAP1[0].x) * _109)));
  float _129 = mad((WorkingColorSpace_ToAP1[1].z), _111, mad((WorkingColorSpace_ToAP1[1].y), _110, ((WorkingColorSpace_ToAP1[1].x) * _109)));
  float _132 = mad((WorkingColorSpace_ToAP1[2].z), _111, mad((WorkingColorSpace_ToAP1[2].y), _110, ((WorkingColorSpace_ToAP1[2].x) * _109)));
  float _133 = dot(float3(_126, _129, _132), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_126, _129, _132));

  float _137 = (_126 / _133) + -1.0f;
  float _138 = (_129 / _133) + -1.0f;
  float _139 = (_132 / _133) + -1.0f;
  float _151 = (1.0f - exp2(((_133 * _133) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_137, _138, _139), float3(_137, _138, _139)) * -4.0f));
  float _167 = ((mad(-0.06368283927440643f, _132, mad(-0.32929131388664246f, _129, (_126 * 1.370412826538086f))) - _126) * _151) + _126;
  float _168 = ((mad(-0.010861567221581936f, _132, mad(1.0970908403396606f, _129, (_126 * -0.08343426138162613f))) - _129) * _151) + _129;
  float _169 = ((mad(1.203694462776184f, _132, mad(-0.09862564504146576f, _129, (_126 * -0.02579325996339321f))) - _132) * _151) + _132;
  float _170 = dot(float3(_167, _168, _169), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _184 = ColorOffset.w + ColorOffsetShadows.w;
  float _198 = ColorGain.w * ColorGainShadows.w;
  float _212 = ColorGamma.w * ColorGammaShadows.w;
  float _226 = ColorContrast.w * ColorContrastShadows.w;
  float _240 = ColorSaturation.w * ColorSaturationShadows.w;
  float _244 = _167 - _170;
  float _245 = _168 - _170;
  float _246 = _169 - _170;
  float _303 = saturate(_170 / ColorCorrectionShadowsMax);
  float _307 = (_303 * _303) * (3.0f - (_303 * 2.0f));
  float _308 = 1.0f - _307;
  float _317 = ColorOffset.w + ColorOffsetHighlights.w;
  float _326 = ColorGain.w * ColorGainHighlights.w;
  float _335 = ColorGamma.w * ColorGammaHighlights.w;
  float _344 = ColorContrast.w * ColorContrastHighlights.w;
  float _353 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _416 = saturate((_170 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _420 = (_416 * _416) * (3.0f - (_416 * 2.0f));
  float _429 = ColorOffset.w + ColorOffsetMidtones.w;
  float _438 = ColorGain.w * ColorGainMidtones.w;
  float _447 = ColorGamma.w * ColorGammaMidtones.w;
  float _456 = ColorContrast.w * ColorContrastMidtones.w;
  float _465 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _523 = _307 - _420;
  float _539 = max((((_420 * (((ColorOffset.x + ColorOffsetHighlights.x) + _317) + (((ColorGain.x * ColorGainHighlights.x) * _326) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _344) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _353) * _244) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _335)))))) + (_308 * (((ColorOffset.x + ColorOffsetShadows.x) + _184) + (((ColorGain.x * ColorGainShadows.x) * _198) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _226) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _240) * _244) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _212))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _429) + (((ColorGain.x * ColorGainMidtones.x) * _438) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _456) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _465) * _244) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _447))))) * _523)), 9.999999974752427e-07f);
  float _540 = max((((_420 * (((ColorOffset.y + ColorOffsetHighlights.y) + _317) + (((ColorGain.y * ColorGainHighlights.y) * _326) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _344) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _353) * _245) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _335)))))) + (_308 * (((ColorOffset.y + ColorOffsetShadows.y) + _184) + (((ColorGain.y * ColorGainShadows.y) * _198) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _226) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _240) * _245) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _212))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _429) + (((ColorGain.y * ColorGainMidtones.y) * _438) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _456) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _465) * _245) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _447))))) * _523)), 9.999999974752427e-07f);
  float _541 = max((((_420 * (((ColorOffset.z + ColorOffsetHighlights.z) + _317) + (((ColorGain.z * ColorGainHighlights.z) * _326) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _344) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _353) * _246) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _335)))))) + (_308 * (((ColorOffset.z + ColorOffsetShadows.z) + _184) + (((ColorGain.z * ColorGainShadows.z) * _198) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _226) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _240) * _246) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _212))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _429) + (((ColorGain.z * ColorGainMidtones.z) * _438) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _456) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _465) * _246) + _170)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _447))))) * _523)), 9.999999974752427e-07f);
  float _560 = (log2(_539) + 9.720000267028809f) * 0.05707762390375137f;
  float _561 = (log2(_540) + 9.720000267028809f) * 0.05707762390375137f;
  float _562 = (log2(_541) + 9.720000267028809f) * 0.05707762390375137f;
  float _569 = ((((_539 * 10.540237426757812f) + 0.072905533015728f) - _560) * select((_539 > 0.0078125f), 0.0f, 1.0f)) + _560;
  float _570 = ((((_540 * 10.540237426757812f) + 0.072905533015728f) - _561) * select((_540 > 0.0078125f), 0.0f, 1.0f)) + _561;
  float _571 = ((((_541 * 10.540237426757812f) + 0.072905533015728f) - _562) * select((_541 > 0.0078125f), 0.0f, 1.0f)) + _562;
  float _575 = (_570 * 0.9375f) + 0.03125f;
  float _582 = _571 * 15.0f;
  float _583 = floor(_582);
  float _584 = _582 - _583;
  float _586 = (((_569 * 0.9375f) + 0.03125f) + _583) * 0.0625f;
  float4 _589 = Textures_1.Sample(Samplers_1, float2(_586, _575));
  float _593 = _586 + 0.0625f;
  float4 _596 = Textures_1.Sample(Samplers_1, float2(_593, _575));
  float4 _619 = Textures_2.Sample(Samplers_2, float2(_586, _575));
  float4 _625 = Textures_2.Sample(Samplers_2, float2(_593, _575));
  float _641 = (((lerp(_589.x, _596.x, _584)) * (LUTWeights[0].y)) + (_569 * (LUTWeights[0].x))) + ((lerp(_619.x, _625.x, _584)) * (LUTWeights[0].z));
  float _642 = (((lerp(_589.y, _596.y, _584)) * (LUTWeights[0].y)) + (_570 * (LUTWeights[0].x))) + ((lerp(_619.y, _625.y, _584)) * (LUTWeights[0].z));
  float _643 = (((lerp(_589.z, _596.z, _584)) * (LUTWeights[0].y)) + (_571 * (LUTWeights[0].x))) + ((lerp(_619.z, _625.z, _584)) * (LUTWeights[0].z));
  float _662 = exp2((_641 * 17.520000457763672f) + -9.720000267028809f);
  float _663 = exp2((_642 * 17.520000457763672f) + -9.720000267028809f);
  float _664 = exp2((_643 * 17.520000457763672f) + -9.720000267028809f);
  float _671 = ((((_641 + -0.072905533015728f) * 0.09487452358007431f) - _662) * select((_641 > 0.155251145362854f), 0.0f, 1.0f)) + _662;
  float _672 = ((((_642 + -0.072905533015728f) * 0.09487452358007431f) - _663) * select((_642 > 0.155251145362854f), 0.0f, 1.0f)) + _663;
  float _673 = ((((_643 + -0.072905533015728f) * 0.09487452358007431f) - _664) * select((_643 > 0.155251145362854f), 0.0f, 1.0f)) + _664;

  SetUntonemappedAP1(float3(_671, _672, _673));

  float _710 = ((mad(0.061360642313957214f, _673, mad(-4.540197551250458e-09f, _672, (_671 * 0.9386394023895264f))) - _671) * BlueCorrection) + _671;
  float _711 = ((mad(0.169205904006958f, _673, mad(0.8307942152023315f, _672, (_671 * 6.775371730327606e-08f))) - _672) * BlueCorrection) + _672;
  float _712 = (mad(-2.3283064365386963e-10f, _672, (_671 * -9.313225746154785e-10f)) * BlueCorrection) + _673;
  float _727 = dot(float3(_710, _711, _712), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _734 = ((_710 - _727) * 0.9599999785423279f) + _727;
  float _735 = ((_711 - _727) * 0.9599999785423279f) + _727;
  float _736 = ((_712 - _727) * 0.9599999785423279f) + _727;
  float _737 = -0.0f - HyperbolaToe.x;
  float _753 = -0.0f - HyperbolaShoulder.x;
  float _772 = select((_734 < HyperbolaThreshold.x), ((_737 / (_734 + HyperbolaToe.y)) + HyperbolaToe.z), select((_734 < HyperbolaThreshold.y), ((_734 * HyperbolaMid.x) + HyperbolaMid.y), ((_753 / (_734 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _773 = select((_735 < HyperbolaThreshold.x), ((_737 / (_735 + HyperbolaToe.y)) + HyperbolaToe.z), select((_735 < HyperbolaThreshold.y), ((_735 * HyperbolaMid.x) + HyperbolaMid.y), ((_753 / (_735 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _774 = select((_736 < HyperbolaThreshold.x), ((_737 / (_736 + HyperbolaToe.y)) + HyperbolaToe.z), select((_736 < HyperbolaThreshold.y), ((_736 * HyperbolaMid.x) + HyperbolaMid.y), ((_753 / (_736 + HyperbolaShoulder.y)) + HyperbolaShoulder.z)));
  float _775 = dot(float3(_772, _773, _774), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _793 = (((_775 - _710) + ((_772 - _775) * 0.9300000071525574f)) * ToneCurveAmount) + _710;
  float _794 = (((_775 - _711) + ((_773 - _775) * 0.9300000071525574f)) * ToneCurveAmount) + _711;
  float _795 = (((_775 - _712) + ((_774 - _775) * 0.9300000071525574f)) * ToneCurveAmount) + _712;
  float _811 = ((mad(-0.06537103652954102f, _795, mad(1.451815478503704e-06f, _794, (_793 * 1.065374732017517f))) - _793) * BlueCorrection) + _793;
  float _812 = ((mad(-0.20366770029067993f, _795, mad(1.2036634683609009f, _794, (_793 * -2.57161445915699e-07f))) - _794) * BlueCorrection) + _794;
  float _813 = ((mad(0.9999996423721313f, _795, mad(2.0954757928848267e-08f, _794, (_793 * 1.862645149230957e-08f))) - _795) * BlueCorrection) + _795;

  SetTonemappedAP1(_811, _812, _813);

  float _823 = max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _813, mad((WorkingColorSpace_FromAP1[0].y), _812, ((WorkingColorSpace_FromAP1[0].x) * _811))));
  float _824 = max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _813, mad((WorkingColorSpace_FromAP1[1].y), _812, ((WorkingColorSpace_FromAP1[1].x) * _811))));
  float _825 = max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _813, mad((WorkingColorSpace_FromAP1[2].y), _812, ((WorkingColorSpace_FromAP1[2].x) * _811))));
  float _851 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _823)) * _823) + MappingPolynomial.z);
  float _852 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _824)) * _824) + MappingPolynomial.z);
  float _853 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _825)) * _825) + MappingPolynomial.z);
  float _860 = ((OverlayColor.x - _851) * OverlayColor.w) + _851;
  float _861 = ((OverlayColor.y - _852) * OverlayColor.w) + _852;
  float _862 = ((OverlayColor.z - _853) * OverlayColor.w) + _853;
  float _863 = ColorScale.x * mad((WorkingColorSpace_FromAP1[0].z), _673, mad((WorkingColorSpace_FromAP1[0].y), _672, (_671 * (WorkingColorSpace_FromAP1[0].x))));
  float _864 = ColorScale.y * mad((WorkingColorSpace_FromAP1[1].z), _673, mad((WorkingColorSpace_FromAP1[1].y), _672, (_671 * (WorkingColorSpace_FromAP1[1].x))));
  float _865 = ColorScale.z * mad((WorkingColorSpace_FromAP1[2].z), _673, mad((WorkingColorSpace_FromAP1[2].y), _672, (_671 * (WorkingColorSpace_FromAP1[2].x))));
  float _872 = ((OverlayColor.x - _863) * OverlayColor.w) + _863;
  float _873 = ((OverlayColor.y - _864) * OverlayColor.w) + _864;
  float _874 = ((OverlayColor.z - _865) * OverlayColor.w) + _865;
  float _886 = exp2(log2(max(0.0f, _860)) * InverseGamma.y);
  float _887 = exp2(log2(max(0.0f, _861)) * InverseGamma.y);
  float _888 = exp2(log2(max(0.0f, _862)) * InverseGamma.y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_886, _887, _888), OutputDevice);
  }

  [branch]
  if ((uint)(OutputDevice) == 0) {
    do {
      if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
        float _911 = mad((WorkingColorSpace_ToAP1[0].z), _888, mad((WorkingColorSpace_ToAP1[0].y), _887, ((WorkingColorSpace_ToAP1[0].x) * _886)));
        float _914 = mad((WorkingColorSpace_ToAP1[1].z), _888, mad((WorkingColorSpace_ToAP1[1].y), _887, ((WorkingColorSpace_ToAP1[1].x) * _886)));
        float _917 = mad((WorkingColorSpace_ToAP1[2].z), _888, mad((WorkingColorSpace_ToAP1[2].y), _887, ((WorkingColorSpace_ToAP1[2].x) * _886)));
        _928 = mad(_45, _917, mad(_44, _914, (_911 * _43)));
        _929 = mad(_48, _917, mad(_47, _914, (_911 * _46)));
        _930 = mad(_51, _917, mad(_50, _914, (_911 * _49)));
      } else {
        _928 = _886;
        _929 = _887;
        _930 = _888;
      }
      do {
        if (_928 < 0.0031306699384003878f) {
          _941 = (_928 * 12.920000076293945f);
        } else {
          _941 = (((pow(_928, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_929 < 0.0031306699384003878f) {
            _952 = (_929 * 12.920000076293945f);
          } else {
            _952 = (((pow(_929, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_930 < 0.0031306699384003878f) {
            _1328 = _941;
            _1329 = _952;
            _1330 = (_930 * 12.920000076293945f);
          } else {
            _1328 = _941;
            _1329 = _952;
            _1330 = (((pow(_930, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(OutputDevice) == 1) {
      float _979 = mad((WorkingColorSpace_ToAP1[0].z), _888, mad((WorkingColorSpace_ToAP1[0].y), _887, ((WorkingColorSpace_ToAP1[0].x) * _886)));
      float _982 = mad((WorkingColorSpace_ToAP1[1].z), _888, mad((WorkingColorSpace_ToAP1[1].y), _887, ((WorkingColorSpace_ToAP1[1].x) * _886)));
      float _985 = mad((WorkingColorSpace_ToAP1[2].z), _888, mad((WorkingColorSpace_ToAP1[2].y), _887, ((WorkingColorSpace_ToAP1[2].x) * _886)));
      float _995 = max(6.103519990574569e-05f, mad(_45, _985, mad(_44, _982, (_979 * _43))));
      float _996 = max(6.103519990574569e-05f, mad(_48, _985, mad(_47, _982, (_979 * _46))));
      float _997 = max(6.103519990574569e-05f, mad(_51, _985, mad(_50, _982, (_979 * _49))));
      _1328 = min((_995 * 4.5f), ((exp2(log2(max(_995, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1329 = min((_996 * 4.5f), ((exp2(log2(max(_996, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _1330 = min((_997 * 4.5f), ((exp2(log2(max(_997, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(OutputDevice) == 3) || (bool)((uint)(OutputDevice) == 5)) {
        float _1029 = HyperbolaMultiplier.x * _860;
        float _1030 = HyperbolaMultiplier.x * _861;
        float _1031 = HyperbolaMultiplier.x * _862;
        float _1046 = mad((WorkingColorSpace_ToAP1[0].z), _1031, mad((WorkingColorSpace_ToAP1[0].y), _1030, ((WorkingColorSpace_ToAP1[0].x) * _1029)));
        float _1049 = mad((WorkingColorSpace_ToAP1[1].z), _1031, mad((WorkingColorSpace_ToAP1[1].y), _1030, ((WorkingColorSpace_ToAP1[1].x) * _1029)));
        float _1052 = mad((WorkingColorSpace_ToAP1[2].z), _1031, mad((WorkingColorSpace_ToAP1[2].y), _1030, ((WorkingColorSpace_ToAP1[2].x) * _1029)));
        do {
          if (!((uint)(OutputDevice) == 5)) {
            _1065 = mad(_45, _1052, mad(_44, _1049, (_1046 * _43)));
            _1066 = mad(_48, _1052, mad(_47, _1049, (_1046 * _46)));
            _1067 = mad(_51, _1052, mad(_50, _1049, (_1046 * _49)));
          } else {
            _1065 = _1046;
            _1066 = _1049;
            _1067 = _1052;
          }
          float _1077 = exp2(log2(_1065 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1078 = exp2(log2(_1066 * 9.999999747378752e-05f) * 0.1593017578125f);
          float _1079 = exp2(log2(_1067 * 9.999999747378752e-05f) * 0.1593017578125f);
          _1328 = exp2(log2((1.0f / ((_1077 * 18.6875f) + 1.0f)) * ((_1077 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1329 = exp2(log2((1.0f / ((_1078 * 18.6875f) + 1.0f)) * ((_1078 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _1330 = exp2(log2((1.0f / ((_1079 * 18.6875f) + 1.0f)) * ((_1079 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        } while (false);
      } else {
        if (((uint)(OutputDevice) & -3) == 4) {
          float _1113 = HyperbolaMultiplier.x * _860;
          float _1114 = HyperbolaMultiplier.x * _861;
          float _1115 = HyperbolaMultiplier.x * _862;
          float _1130 = mad((WorkingColorSpace_ToAP1[0].z), _1115, mad((WorkingColorSpace_ToAP1[0].y), _1114, ((WorkingColorSpace_ToAP1[0].x) * _1113)));
          float _1133 = mad((WorkingColorSpace_ToAP1[1].z), _1115, mad((WorkingColorSpace_ToAP1[1].y), _1114, ((WorkingColorSpace_ToAP1[1].x) * _1113)));
          float _1136 = mad((WorkingColorSpace_ToAP1[2].z), _1115, mad((WorkingColorSpace_ToAP1[2].y), _1114, ((WorkingColorSpace_ToAP1[2].x) * _1113)));
          do {
            if (!((uint)(OutputDevice) == 6)) {
              _1149 = mad(_45, _1136, mad(_44, _1133, (_1130 * _43)));
              _1150 = mad(_48, _1136, mad(_47, _1133, (_1130 * _46)));
              _1151 = mad(_51, _1136, mad(_50, _1133, (_1130 * _49)));
            } else {
              _1149 = _1130;
              _1150 = _1133;
              _1151 = _1136;
            }
            float _1161 = exp2(log2(_1149 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1162 = exp2(log2(_1150 * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1163 = exp2(log2(_1151 * 9.999999747378752e-05f) * 0.1593017578125f);
            _1328 = exp2(log2((1.0f / ((_1161 * 18.6875f) + 1.0f)) * ((_1161 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1329 = exp2(log2((1.0f / ((_1162 * 18.6875f) + 1.0f)) * ((_1162 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1330 = exp2(log2((1.0f / ((_1163 * 18.6875f) + 1.0f)) * ((_1163 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } while (false);
        } else {
          if ((uint)(OutputDevice) == 7) {
            float _1208 = mad((WorkingColorSpace_ToAP1[0].z), _874, mad((WorkingColorSpace_ToAP1[0].y), _873, ((WorkingColorSpace_ToAP1[0].x) * _872)));
            float _1211 = mad((WorkingColorSpace_ToAP1[1].z), _874, mad((WorkingColorSpace_ToAP1[1].y), _873, ((WorkingColorSpace_ToAP1[1].x) * _872)));
            float _1214 = mad((WorkingColorSpace_ToAP1[2].z), _874, mad((WorkingColorSpace_ToAP1[2].y), _873, ((WorkingColorSpace_ToAP1[2].x) * _872)));
            float _1233 = exp2(log2(mad(_45, _1214, mad(_44, _1211, (_1208 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1234 = exp2(log2(mad(_48, _1214, mad(_47, _1211, (_1208 * _46))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _1235 = exp2(log2(mad(_51, _1214, mad(_50, _1211, (_1208 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _1328 = exp2(log2((1.0f / ((_1233 * 18.6875f) + 1.0f)) * ((_1233 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1329 = exp2(log2((1.0f / ((_1234 * 18.6875f) + 1.0f)) * ((_1234 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _1330 = exp2(log2((1.0f / ((_1235 * 18.6875f) + 1.0f)) * ((_1235 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(OutputDevice) == 8)) {
              if ((uint)(OutputDevice) == 9) {
                float _1282 = mad((WorkingColorSpace_ToAP1[0].z), _862, mad((WorkingColorSpace_ToAP1[0].y), _861, ((WorkingColorSpace_ToAP1[0].x) * _860)));
                float _1285 = mad((WorkingColorSpace_ToAP1[1].z), _862, mad((WorkingColorSpace_ToAP1[1].y), _861, ((WorkingColorSpace_ToAP1[1].x) * _860)));
                float _1288 = mad((WorkingColorSpace_ToAP1[2].z), _862, mad((WorkingColorSpace_ToAP1[2].y), _861, ((WorkingColorSpace_ToAP1[2].x) * _860)));
                _1328 = mad(_45, _1288, mad(_44, _1285, (_1282 * _43)));
                _1329 = mad(_48, _1288, mad(_47, _1285, (_1282 * _46)));
                _1330 = mad(_51, _1288, mad(_50, _1285, (_1282 * _49)));
              } else {
                float _1301 = mad((WorkingColorSpace_ToAP1[0].z), _888, mad((WorkingColorSpace_ToAP1[0].y), _887, ((WorkingColorSpace_ToAP1[0].x) * _886)));
                float _1304 = mad((WorkingColorSpace_ToAP1[1].z), _888, mad((WorkingColorSpace_ToAP1[1].y), _887, ((WorkingColorSpace_ToAP1[1].x) * _886)));
                float _1307 = mad((WorkingColorSpace_ToAP1[2].z), _888, mad((WorkingColorSpace_ToAP1[2].y), _887, ((WorkingColorSpace_ToAP1[2].x) * _886)));
                _1328 = exp2(log2(mad(_45, _1307, mad(_44, _1304, (_1301 * _43)))) * InverseGamma.z);
                _1329 = exp2(log2(mad(_48, _1307, mad(_47, _1304, (_1301 * _46)))) * InverseGamma.z);
                _1330 = exp2(log2(mad(_51, _1307, mad(_50, _1304, (_1301 * _49)))) * InverseGamma.z);
              }
            } else {
              _1328 = _872;
              _1329 = _873;
              _1330 = _874;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_1328 * 0.9523810148239136f);
  SV_Target.y = (_1329 * 0.9523810148239136f);
  SV_Target.z = (_1330 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}

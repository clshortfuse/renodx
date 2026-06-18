#define TONE_MAP_PARAM_CBUFFER_REGISTER b1
#include "./PostProcess.hlsli"

struct RGCParam {
  float CyanLimit;
  float MagentaLimit;
  float YellowLimit;
  float CyanThreshold;
  float MagentaThreshold;
  float YellowThreshold;
  float RollOff;
  uint EnableReferenceGamutCompress;
  float InvCyanSTerm;
  float InvMagentaSTerm;
  float InvYellowSTerm;
  float InvRollOff;
};

struct RadialBlurComputeResult {
  float computeAlpha;
};


Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

Texture2D<uint2> RE_POSTPROCESS_Stencil : register(t1);

Texture2D<float> RE_POSTPROCESS_EffectMask : register(t2);

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t3);

Texture3D<float4> tTextureMap0 : register(t4);

Texture3D<float4> tTextureMap1 : register(t5);

Texture3D<float4> tTextureMap2 : register(t6);

Texture2D<float4> ImagePlameBase : register(t7);

Texture2D<float> ImagePlameAlpha : register(t8);

Texture3D<float4> ExColorCube : register(t9);

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c000.x);
  row_major float3x4 transposeViewMat : packoffset(c004.x);
  row_major float3x4 transposeViewInvMat : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  row_major float4x4 viewProjInvMat : packoffset(c014.x);
  row_major float4x4 prevViewProjMat : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[8] : packoffset(c025.x);
  float4 clipplane : packoffset(c033.x);
  float2 vrsVelocityThreshold : packoffset(c034.x);
  uint GPUVisibleMask : packoffset(c034.z);
  uint resolutionRatioPacked : packoffset(c034.w);
  float3 worldOffset : packoffset(c035.x);
  uint sceneInfoMisc : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float tessellationParam : packoffset(c038.w);
  float SceneInfo_Reserve2 : packoffset(c039.x);
};

// cbuffer TonemapParam : register(b1) {
//   float contrast : packoffset(c000.x);
//   float linearBegin : packoffset(c000.y);
//   float linearLength : packoffset(c000.z);
//   float toe : packoffset(c000.w);
//   float maxNit : packoffset(c001.x);
//   float linearStart : packoffset(c001.y);
//   float displayMaxNitSubContrastFactor : packoffset(c001.z);
//   float contrastFactor : packoffset(c001.w);
//   float mulLinearStartContrastFactor : packoffset(c002.x);
//   float invLinearBegin : packoffset(c002.y);
//   float madLinearStartContrastFactor : packoffset(c002.z);
//   float tonemapParam_isHDRMode : packoffset(c002.w);
//   float useDynamicRangeConversion : packoffset(c003.x);
//   float useHuePreserve : packoffset(c003.y);
//   float exposureScale : packoffset(c003.z);
//   float kneeStartNit : packoffset(c003.w);
//   float knee : packoffset(c004.x);
//   float curve_HDRip : packoffset(c004.y);
//   float curve_k2 : packoffset(c004.z);
//   float curve_k4 : packoffset(c004.w);
//   row_major float4x4 RGBToXYZViaCrosstalkMatrix : packoffset(c005.x);
//   row_major float4x4 XYZToRGBViaCrosstalkMatrix : packoffset(c009.x);
//   float tonemapGraphScale : packoffset(c013.x);
// };

cbuffer LDRPostProcessParam : register(b2) {
  float fHazeFilterStart : packoffset(c000.x);
  float fHazeFilterInverseRange : packoffset(c000.y);
  float fHazeFilterHeightStart : packoffset(c000.z);
  float fHazeFilterHeightInverseRange : packoffset(c000.w);
  float4 fHazeFilterUVWOffset : packoffset(c001.x);
  float fHazeFilterScale : packoffset(c002.x);
  float fHazeFilterBorder : packoffset(c002.y);
  float fHazeFilterBorderFade : packoffset(c002.z);
  float fHazeFilterDepthDiffBias : packoffset(c002.w);
  uint fHazeFilterAttribute : packoffset(c003.x);
  uint fHazeFilterReductionResolution : packoffset(c003.y);
  uint fHazeFilterReserved1 : packoffset(c003.z);
  uint fHazeFilterReserved2 : packoffset(c003.w);
  float fDistortionCoef : packoffset(c004.x);
  float fRefraction : packoffset(c004.y);
  float fRefractionCenterRate : packoffset(c004.z);
  float fGradationStartOffset : packoffset(c004.w);
  float fGradationEndOffset : packoffset(c005.x);
  uint aberrationEnable : packoffset(c005.y);
  uint distortionType : packoffset(c005.z);
  float fCorrectCoef : packoffset(c005.w);
  uint aberrationBlurEnable : packoffset(c006.x);
  float fBlurNoisePower : packoffset(c006.y);
  float2 LensDistortion_Reserve : packoffset(c006.z);
  float4 fOptimizedParam : packoffset(c007.x);
  float2 fNoisePower : packoffset(c008.x);
  float2 fNoiseUVOffset : packoffset(c008.z);
  float fNoiseDensity : packoffset(c009.x);
  float fNoiseContrast : packoffset(c009.y);
  float fBlendRate : packoffset(c009.z);
  float fReverseNoiseSize : packoffset(c009.w);
  float fTextureSize : packoffset(c010.x);
  float fTextureBlendRate : packoffset(c010.y);
  float fTextureBlendRate2 : packoffset(c010.z);
  float fTextureInverseSize : packoffset(c010.w);
  float fHalfTextureInverseSize : packoffset(c011.x);
  float fOneMinusTextureInverseSize : packoffset(c011.y);
  float fColorCorrectTextureReserve : packoffset(c011.z);
  float fColorCorrectTextureReserve2 : packoffset(c011.w);
  row_major float4x4 fColorMatrix : packoffset(c012.x);
  float4 cvdR : packoffset(c016.x);
  float4 cvdG : packoffset(c017.x);
  float4 cvdB : packoffset(c018.x);
  float4 ColorParam : packoffset(c019.x);
  float Levels_Rate : packoffset(c020.x);
  float Levels_Range : packoffset(c020.y);
  uint Blend_Type : packoffset(c020.z);
  float ImagePlane_Reserve : packoffset(c020.w);
  float4 cbRadialColor : packoffset(c021.x);
  float2 cbRadialScreenPos : packoffset(c022.x);
  float2 cbRadialMaskSmoothstep : packoffset(c022.z);
  float2 cbRadialMaskRate : packoffset(c023.x);
  float cbRadialBlurPower : packoffset(c023.z);
  float cbRadialSharpRange : packoffset(c023.w);
  uint cbRadialBlurFlags : packoffset(c024.x);
  float cbRadialReserve0 : packoffset(c024.y);
  float cbRadialReserve1 : packoffset(c024.z);
  float cbRadialReserve2 : packoffset(c024.w);
};

cbuffer CBControl : register(b3) {
  float3 CBControl_reserve : packoffset(c000.x);
  uint cPassEnabled : packoffset(c000.w);
  row_major float4x4 fOCIOTransformMatrix : packoffset(c001.x);
  RGCParam cbControlRGCParam : packoffset(c005.x);
};

cbuffer UserShaderLDRPostProcessSettings : register(b4) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

cbuffer UserMaterial : register(b5) {
  float4 VAR_TargetColorMod : packoffset(c000.x);
  float VAR_EnableKompiraTrip : packoffset(c001.x);
  float VAR_KompiraTripRate : packoffset(c001.y);
  float VAR_DestortionIntensity : packoffset(c001.z);
  float VAR_EnableHighlightTarget : packoffset(c001.w);
  float VAR_TargetStencilID : packoffset(c002.x);
  float VAR_GrayScaleRatio : packoffset(c002.y);
  float VAR_GrayScaleCoef : packoffset(c002.z);
  float VAR_EnableCustomColorCorrect : packoffset(c002.w);
  float VAR_ExColorCorrectTargetStencilID : packoffset(c003.x);
  float VAR_ExColorCorrectTargetStencilID_2 : packoffset(c003.y);
  float VAR_UseEffectMask : packoffset(c003.z);
  float VAR_EnableEffectMaskPow : packoffset(c003.w);
  float VAR_EnableColorSupport : packoffset(c004.x);
  float VAR_ColorSupportScale : packoffset(c004.y);
  float VAR_ColorSupportOffset : packoffset(c004.z);
  float VAR_ColorSupportIntensity : packoffset(c004.w);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

SamplerState AutomaticWrap : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float _33;
  float _34;
  float _166;
  float _167;
  float _471;
  float _472;
  float _473;
  float _555;
  float _1110;
  float _1111;
  float _1112;
  float _1146;
  float _1147;
  float _1148;
  float _1159;
  float _1160;
  float _1161;
  float _1201;
  float _1217;
  float _1233;
  float _1261;
  float _1262;
  float _1263;
  float _1321;
  float _1342;
  float _1362;
  float _1370;
  float _1371;
  float _1372;
  float _1415;
  float _1425;
  float _1435;
  float _1461;
  float _1475;
  float _1489;
  float _1500;
  float _1509;
  float _1518;
  float _1543;
  float _1557;
  float _1571;
  float _1592;
  float _1602;
  float _1612;
  float _1637;
  float _1651;
  float _1665;
  float _1687;
  float _1697;
  float _1707;
  float _1732;
  float _1746;
  float _1760;
  float _1771;
  float _1772;
  float _1773;
  float _1787;
  float _1788;
  float _1789;
  float _1827;
  float _1837;
  float _1847;
  float _1873;
  float _1887;
  float _1901;
  float _1914;
  float _1925;
  float _1926;
  float _1927;
  float _1963;
  float _1964;
  float _1965;
  float _2015;
  float _2027;
  float _2039;
  float _2050;
  float _2051;
  float _2052;
  float _2068;
  float _2077;
  float _2086;
  float _2157;
  float _2158;
  float _2159;
  float _2211;
  float _2212;
  float _2213;
  float _2244;
  float _2297;
  float _2298;
  float _2299;
  float4 _41;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _60;
  float _61;
  float _64;
  float _65;
  float _67;
  float _70;
  float _72;
  float _74;
  float _76;
  float _81;
  float _85;
  float _94;
  float _102;
  float _103;
  float _104;
  float _105;
  float _112;
  float _118;
  float _119;
  float _121;
  float _124;
  float _128;
  float _130;
  float _137;
  float _141;
  float _150;
  float _158;
  uint _199;
  bool _204;
  bool _205;
  float4 _215;
  float _222;
  float _223;
  float _224;
  bool _227;
  float _239;
  float _240;
  float _241;
  float _243;
  float _244;
  float _246;
  float _248;
  float _249;
  float4 _254;
  float _273;
  float _283;
  float _284;
  float _288;
  float _299;
  float _311;
  float4 _316;
  float _325;
  float4 _330;
  float _339;
  float _350;
  float4 _355;
  float _363;
  float4 _368;
  float _383;
  float _395;
  float _403;
  float _409;
  float _411;
  float _418;
  float _442;
  float _446;
  float _447;
  float _455;
  float4 _463;
  uint _493;
  float _505;
  float _509;
  float _512;
  float _518;
  float _519;
  float _521;
  float _523;
  float _526;
  float _529;
  float _535;
  uint _542;
  uint _546;
  uint _549;
  float _559;
  float _561;
  float _562;
  float _563;
  float _564;
  float _566;
  float _570;
  float _571;
  float _573;
  float _578;
  float _579;
  float _580;
  float _585;
  float _586;
  float _587;
  float _592;
  float _593;
  float _594;
  float _599;
  float _600;
  float _601;
  float _606;
  float _607;
  float _608;
  float _613;
  float _614;
  float _615;
  float _620;
  float _621;
  float _624;
  float _629;
  float _630;
  float _632;
  float _633;
  float _637;
  float4 _643;
  float _647;
  float _648;
  float _652;
  float4 _657;
  float _664;
  float _665;
  float _669;
  float4 _674;
  float _681;
  float _682;
  float _686;
  float4 _691;
  float _698;
  float _699;
  float _703;
  float4 _708;
  float _715;
  float _716;
  float _720;
  float4 _725;
  float _732;
  float _733;
  float _737;
  float4 _742;
  float _749;
  float _750;
  float _754;
  float4 _759;
  float _766;
  float _767;
  float _771;
  float4 _776;
  float _784;
  float _785;
  float _786;
  float _787;
  float _788;
  float _789;
  float _790;
  float _791;
  float _792;
  float _793;
  float _794;
  float _795;
  float _796;
  float _797;
  float _798;
  float _799;
  float _800;
  float _801;
  float _802;
  float _803;
  float _807;
  float _811;
  float _812;
  float _819;
  float _820;
  float4 _827;
  float _833;
  float _837;
  float _838;
  float _845;
  float4 _851;
  float _860;
  float _864;
  float _865;
  float _872;
  float4 _878;
  float _887;
  float _891;
  float _892;
  float _899;
  float4 _905;
  float _914;
  float _918;
  float _919;
  float _926;
  float4 _932;
  float _941;
  float _945;
  float _946;
  float _953;
  float4 _959;
  float _968;
  float _972;
  float _973;
  float _980;
  float4 _986;
  float _995;
  float _999;
  float _1000;
  float _1007;
  float4 _1013;
  float _1022;
  float _1026;
  float _1027;
  float _1034;
  float4 _1040;
  float4 _1049;
  float4 _1053;
  float4 _1060;
  float4 _1067;
  float4 _1074;
  float4 _1081;
  float4 _1088;
  float4 _1095;
  float4 _1102;
  float _1122;
  float _1123;
  float _1124;
  float _1129;
  float _1135;
  float _1179;
  float _1181;
  float _1187;
  int _1192;
  uint _1193;
  float _1203;
  int _1207;
  uint _1208;
  float _1219;
  int _1223;
  uint _1224;
  float _1234;
  float _1235;
  float _1236;
  float _1250;
  float _1278;
  float _1281;
  float _1284;
  float _1290;
  float _1296;
  float _1297;
  float _1298;
  float _1299;
  float _1309;
  float _1330;
  float _1350;
  bool _1406;
  bool _1416;
  bool _1426;
  float4 _1444;
  float4 _1526;
  float _1578;
  float _1579;
  float _1580;
  float4 _1620;
  float4 _1715;
  uint2 _1798;
  float _1810;
  float4 _1856;
  float _1906;
  float _1910;
  float _1969;
  float _1970;
  float4 _1976;
  float _1996;
  float _1997;
  float _1998;
  float _2003;
  float _2060;
  float _2069;
  float _2078;
  float _2095;
  float _2096;
  float _2097;
  uint2 _2169;
  float _2193;
  float _2194;
  float _2219;
  float _2222;
  float _2225;
  float _2228;
  float _2250;
  _33 = screenInverseSize.x * SV_Position.x;
  _34 = screenInverseSize.y * SV_Position.y;
  if (VAR_EnableKompiraTrip > 0.0f) {
    _41 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_33, _34), 0.0f);
    _52 = ((_41.z + _41.x) + _41.y) * 0.029999999329447746f;
    _53 = _41.x * 0.029999999329447746f;
    _54 = _41.y * 0.029999999329447746f;
    _55 = floor(_52);
    _56 = frac(_52);
    _60 = (_56 * _56) * (3.0f - (_56 * 2.0f));
    _61 = _55 * 0.3183099031448364f;
    _64 = frac(_61 + 0.7099999785423279f);
    _65 = frac(_61 + 0.11299999803304672f);
    _67 = _64 * 125000.0f;
    _70 = frac((_67 * _65) * (_65 + _64));
    _72 = (_55 + 1.0f) * 0.3183099031448364f;
    _74 = frac(_72 + 0.7099999785423279f);
    _76 = _74 * 125000.0f;
    _81 = frac(_72 + 0.11299999803304672f);
    _85 = frac((_81 * _67) * (_81 + _64));
    _94 = ((frac((_76 * _65) * (_74 + _65)) - _70) * _60) + _70;
    _102 = floor(_53);
    _103 = floor(_54);
    _104 = frac(_53);
    _105 = frac(_54);
    _112 = (_104 * _104) * (3.0f - (_104 * 2.0f));
    _118 = frac((_102 * 0.3183099031448364f) + 0.7099999785423279f);
    _119 = frac((_103 * 0.3183099031448364f) + 0.11299999803304672f);
    _121 = _118 * 125000.0f;
    _124 = frac((_121 * _119) * (_119 + _118));
    _128 = frac(((_102 + 1.0f) * 0.3183099031448364f) + 0.7099999785423279f);
    _130 = _128 * 125000.0f;
    _137 = frac(((_103 + 1.0f) * 0.3183099031448364f) + 0.11299999803304672f);
    _141 = frac((_137 * _121) * (_137 + _118));
    _150 = ((frac((_130 * _119) * (_128 + _119)) - _124) * _112) + _124;
    _158 = VAR_KompiraTripRate * VAR_DestortionIntensity;
    _166 = (((screenSize.x * _158) * (((((((frac((_81 * _76) * (_81 + _74)) - _85) * _60) + _85) - _94) * 2.0f) * _60) + ((_94 * 2.0f) + -1.0f))) + SV_Position.x);
    _167 = (((screenSize.y * _158) * ((((_105 * _105) * (3.0f - (_105 * 2.0f))) * (((((frac((_137 * _130) * (_137 + _128)) - _141) * _112) + _141) - _150) * 2.0f)) + ((_150 * 2.0f) + -1.0f))) + SV_Position.y);
  } else {
    _166 = SV_Position.x;
    _167 = SV_Position.y;
  }
  _199 = uint((float)((uint)(uint)(distortionType)));
  _204 = (LDRPPSettings_enabled != 0);
  _205 = ((cPassEnabled & 1) != 0);
  if (!(_205 && _204)) {
    _215 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * _166), (screenInverseSize.y * _167)));
    _222 = min(_215.x, 65000.0f) * Exposure;
    _223 = min(_215.y, 65000.0f) * Exposure;
    _224 = min(_215.z, 65000.0f) * Exposure;
    _227 = isfinite(max(max(_222, _223), _224));
    _471 = select(_227, _222, 1.0f);
    _472 = select(_227, _223, 1.0f);
    _473 = select(_227, _224, 1.0f);
  } else {
    if (_199 == 0) {
      _239 = (screenInverseSize.x * _166) + -0.5f;
      _240 = (screenInverseSize.y * _167) + -0.5f;
      _241 = dot(float2(_239, _240), float2(_239, _240));
      _243 = (_241 * fDistortionCoef) + 1.0f;
      _244 = _239 * fCorrectCoef;
      _246 = _240 * fCorrectCoef;
      _248 = (_244 * _243) + 0.5f;
      _249 = (_246 * _243) + 0.5f;
      if ((int)(uint((float)((uint)(uint)(aberrationEnable)))) == 0) {
        _254 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_248, _249));
        _471 = (_254.x * Exposure);
        _472 = (_254.y * Exposure);
        _473 = (_254.z * Exposure);
      } else {
        _273 = ((saturate((sqrt((_239 * _239) + (_240 * _240)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((int)(uint((float)((uint)(uint)(aberrationBlurEnable)))) == 0)) {
          _283 = (fBlurNoisePower * 0.125f) * frac(frac((_167 * 0.005837149918079376f) + (_166 * 0.0671105608344078f)) * 52.98291778564453f);
          _284 = _273 * 2.0f;
          _288 = (((_283 * _284) + _241) * fDistortionCoef) + 1.0f;
          _299 = ((((_283 + 0.125f) * _284) + _241) * fDistortionCoef) + 1.0f;
          _311 = ((((_283 + 0.25f) * _284) + _241) * fDistortionCoef) + 1.0f;
          _316 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_311 * _244) + 0.5f), ((_311 * _246) + 0.5f)));
          _325 = ((((_283 + 0.375f) * _284) + _241) * fDistortionCoef) + 1.0f;
          _330 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_325 * _244) + 0.5f), ((_325 * _246) + 0.5f)));
          _339 = ((((_283 + 0.5f) * _284) + _241) * fDistortionCoef) + 1.0f;
          _350 = ((((_283 + 0.625f) * _284) + _241) * fDistortionCoef) + 1.0f;
          _355 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_350 * _244) + 0.5f), ((_350 * _246) + 0.5f)));
          _363 = ((((_283 + 0.75f) * _284) + _241) * fDistortionCoef) + 1.0f;
          _368 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_363 * _244) + 0.5f), ((_363 * _246) + 0.5f)));
          _383 = ((((_283 + 0.875f) * _284) + _241) * fDistortionCoef) + 1.0f;
          _395 = ((((_283 + 1.0f) * _284) + _241) * fDistortionCoef) + 1.0f;
          _403 = Exposure * 0.3199999928474426f;
          _471 = (((((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_299 * _244) + 0.5f), ((_299 * _246) + 0.5f))))).x) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_288 * _244) + 0.5f), ((_288 * _246) + 0.5f))))).x)) + (_316.x * 0.75f)) + (_330.x * 0.375f)) * _403);
          _472 = ((Exposure * 0.3636363744735718f) * ((((_355.y + _330.y) * 0.625f) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_339 * _244) + 0.5f), ((_339 * _246) + 0.5f))))).y)) + ((_368.y + _316.y) * 0.25f)));
          _473 = (((((_368.z * 0.75f) + (_355.z * 0.375f)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_383 * _244) + 0.5f), ((_383 * _246) + 0.5f))))).z)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_395 * _244) + 0.5f), ((_395 * _246) + 0.5f))))).z)) * _403);
        } else {
          _409 = _273 + _241;
          _411 = (_409 * fDistortionCoef) + 1.0f;
          _418 = ((_409 + _273) * fDistortionCoef) + 1.0f;
          _471 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_248, _249)))).x) * Exposure);
          _472 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_411 * _244) + 0.5f), ((_411 * _246) + 0.5f))))).y) * Exposure);
          _473 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_418 * _244) + 0.5f), ((_418 * _246) + 0.5f))))).z) * Exposure);
        }
      }
    } else {
      if (_199 == 1) {
        _442 = ((_166 * 2.0f) * screenInverseSize.x) + -1.0f;
        _446 = sqrt((_442 * _442) + 1.0f);
        _447 = 1.0f / _446;
        _455 = ((_446 * fOptimizedParam.z) * (_447 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        _463 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_455 * _442) + 0.5f), (((_455 * (((_167 * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_447 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _471 = (_463.x * Exposure);
        _472 = (_463.y * Exposure);
        _473 = (_463.z * Exposure);
      } else {
        _471 = 0.0f;
        _472 = 0.0f;
        _473 = 0.0f;
      }
    }
  }
  _493 = uint(asfloat(cbRadialBlurFlags));
  if (_204 && ((cPassEnabled & 32) != 0)) {
    _505 = (float)((bool)(uint)((_493 & 2) != 0));
    _509 = ComputeResultSRV[0].computeAlpha;
    _512 = ((1.0f - _505) + (_509 * _505)) * cbRadialColor.w;
    if (!(_512 == 0.0f)) {
      _518 = screenInverseSize.x * _166;
      _519 = screenInverseSize.y * _167;
      _521 = _518 + (-0.5f - cbRadialScreenPos.x);
      _523 = _519 + (-0.5f - cbRadialScreenPos.y);
      _526 = select((_521 < 0.0f), (1.0f - _518), _518);
      _529 = select((_523 < 0.0f), (1.0f - _519), _519);
      do {
        _555 = 1.0f;
        if (!((_493 & 1) == 0)) {
          _535 = rsqrt(dot(float2(_521, _523), float2(_521, _523))) * cbRadialSharpRange;
          _542 = uint(abs(_535 * _523)) + uint(abs(_535 * _521));
          _546 = ((_542 ^ 61) ^ ((uint)(_542) >> 16)) * 9;
          _549 = (((uint)(_546) >> 4) ^ _546) * 668265261;
          _555 = (((float)((uint)((uint)(((uint)(_549) >> 15) ^ _549)))) * 2.3283064365386963e-10f);
        }
        _559 = sqrt((_521 * _521) + (_523 * _523));
        _561 = 1.0f / max(1.0f, _559);
        _562 = _555 * _526;
        _563 = cbRadialBlurPower * _561;
        _564 = _563 * -0.0011111111380159855f;
        _566 = _555 * _529;
        _570 = ((_564 * _562) + 1.0f) * _521;
        _571 = ((_564 * _566) + 1.0f) * _523;
        _573 = _563 * -0.002222222276031971f;
        _578 = ((_573 * _562) + 1.0f) * _521;
        _579 = ((_573 * _566) + 1.0f) * _523;
        _580 = _563 * -0.0033333334140479565f;
        _585 = ((_580 * _562) + 1.0f) * _521;
        _586 = ((_580 * _566) + 1.0f) * _523;
        _587 = _563 * -0.004444444552063942f;
        _592 = ((_587 * _562) + 1.0f) * _521;
        _593 = ((_587 * _566) + 1.0f) * _523;
        _594 = _563 * -0.0055555556900799274f;
        _599 = ((_594 * _562) + 1.0f) * _521;
        _600 = ((_594 * _566) + 1.0f) * _523;
        _601 = _563 * -0.006666666828095913f;
        _606 = ((_601 * _562) + 1.0f) * _521;
        _607 = ((_601 * _566) + 1.0f) * _523;
        _608 = _563 * -0.007777777966111898f;
        _613 = ((_608 * _562) + 1.0f) * _521;
        _614 = ((_608 * _566) + 1.0f) * _523;
        _615 = _563 * -0.008888889104127884f;
        _620 = ((_615 * _562) + 1.0f) * _521;
        _621 = ((_615 * _566) + 1.0f) * _523;
        _624 = _561 * ((cbRadialBlurPower * -0.009999999776482582f) * _555);
        _629 = ((_624 * _526) + 1.0f) * _521;
        _630 = ((_624 * _529) + 1.0f) * _523;
        do {
          if (_205 && (_199 == 0)) {
            _632 = _570 + cbRadialScreenPos.x;
            _633 = _571 + cbRadialScreenPos.y;
            _637 = ((dot(float2(_632, _633), float2(_632, _633)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _643 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_637 * _632) + 0.5f), ((_637 * _633) + 0.5f)), 0.0f);
            _647 = _578 + cbRadialScreenPos.x;
            _648 = _579 + cbRadialScreenPos.y;
            _652 = ((dot(float2(_647, _648), float2(_647, _648)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _657 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_652 * _647) + 0.5f), ((_652 * _648) + 0.5f)), 0.0f);
            _664 = _585 + cbRadialScreenPos.x;
            _665 = _586 + cbRadialScreenPos.y;
            _669 = ((dot(float2(_664, _665), float2(_664, _665)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _674 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_669 * _664) + 0.5f), ((_669 * _665) + 0.5f)), 0.0f);
            _681 = _592 + cbRadialScreenPos.x;
            _682 = _593 + cbRadialScreenPos.y;
            _686 = ((dot(float2(_681, _682), float2(_681, _682)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _691 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_686 * _681) + 0.5f), ((_686 * _682) + 0.5f)), 0.0f);
            _698 = _599 + cbRadialScreenPos.x;
            _699 = _600 + cbRadialScreenPos.y;
            _703 = ((dot(float2(_698, _699), float2(_698, _699)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _708 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_703 * _698) + 0.5f), ((_703 * _699) + 0.5f)), 0.0f);
            _715 = _606 + cbRadialScreenPos.x;
            _716 = _607 + cbRadialScreenPos.y;
            _720 = ((dot(float2(_715, _716), float2(_715, _716)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _725 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_720 * _715) + 0.5f), ((_720 * _716) + 0.5f)), 0.0f);
            _732 = _613 + cbRadialScreenPos.x;
            _733 = _614 + cbRadialScreenPos.y;
            _737 = ((dot(float2(_732, _733), float2(_732, _733)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _742 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_737 * _732) + 0.5f), ((_737 * _733) + 0.5f)), 0.0f);
            _749 = _620 + cbRadialScreenPos.x;
            _750 = _621 + cbRadialScreenPos.y;
            _754 = ((dot(float2(_749, _750), float2(_749, _750)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _759 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_754 * _749) + 0.5f), ((_754 * _750) + 0.5f)), 0.0f);
            _766 = _629 + cbRadialScreenPos.x;
            _767 = _630 + cbRadialScreenPos.y;
            _771 = ((dot(float2(_766, _767), float2(_766, _767)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _776 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_771 * _766) + 0.5f), ((_771 * _767) + 0.5f)), 0.0f);
            _1110 = ((((((((_657.x + _643.x) + _674.x) + _691.x) + _708.x) + _725.x) + _742.x) + _759.x) + _776.x);
            _1111 = ((((((((_657.y + _643.y) + _674.y) + _691.y) + _708.y) + _725.y) + _742.y) + _759.y) + _776.y);
            _1112 = ((((((((_657.z + _643.z) + _674.z) + _691.z) + _708.z) + _725.z) + _742.z) + _759.z) + _776.z);
          } else {
            _784 = cbRadialScreenPos.x + 0.5f;
            _785 = _570 + _784;
            _786 = cbRadialScreenPos.y + 0.5f;
            _787 = _571 + _786;
            _788 = _578 + _784;
            _789 = _579 + _786;
            _790 = _585 + _784;
            _791 = _586 + _786;
            _792 = _592 + _784;
            _793 = _593 + _786;
            _794 = _599 + _784;
            _795 = _600 + _786;
            _796 = _606 + _784;
            _797 = _607 + _786;
            _798 = _613 + _784;
            _799 = _614 + _786;
            _800 = _620 + _784;
            _801 = _621 + _786;
            _802 = _629 + _784;
            _803 = _630 + _786;
            if (_205 && (_199 == 1)) {
              _807 = (_785 * 2.0f) + -1.0f;
              _811 = sqrt((_807 * _807) + 1.0f);
              _812 = 1.0f / _811;
              _819 = fOptimizedParam.w * 0.5f;
              _820 = ((_811 * fOptimizedParam.z) * (_812 + fOptimizedParam.x)) * _819;
              _827 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_820 * _807) + 0.5f), (((_820 * ((_787 * 2.0f) + -1.0f)) * (((_812 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _833 = (_788 * 2.0f) + -1.0f;
              _837 = sqrt((_833 * _833) + 1.0f);
              _838 = 1.0f / _837;
              _845 = ((_837 * fOptimizedParam.z) * (_838 + fOptimizedParam.x)) * _819;
              _851 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_845 * _833) + 0.5f), (((_845 * ((_789 * 2.0f) + -1.0f)) * (((_838 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _860 = (_790 * 2.0f) + -1.0f;
              _864 = sqrt((_860 * _860) + 1.0f);
              _865 = 1.0f / _864;
              _872 = ((_864 * fOptimizedParam.z) * (_865 + fOptimizedParam.x)) * _819;
              _878 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_872 * _860) + 0.5f), (((_872 * ((_791 * 2.0f) + -1.0f)) * (((_865 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _887 = (_792 * 2.0f) + -1.0f;
              _891 = sqrt((_887 * _887) + 1.0f);
              _892 = 1.0f / _891;
              _899 = ((_891 * fOptimizedParam.z) * (_892 + fOptimizedParam.x)) * _819;
              _905 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_899 * _887) + 0.5f), (((_899 * ((_793 * 2.0f) + -1.0f)) * (((_892 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _914 = (_794 * 2.0f) + -1.0f;
              _918 = sqrt((_914 * _914) + 1.0f);
              _919 = 1.0f / _918;
              _926 = ((_918 * fOptimizedParam.z) * (_919 + fOptimizedParam.x)) * _819;
              _932 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_926 * _914) + 0.5f), (((_926 * ((_795 * 2.0f) + -1.0f)) * (((_919 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _941 = (_796 * 2.0f) + -1.0f;
              _945 = sqrt((_941 * _941) + 1.0f);
              _946 = 1.0f / _945;
              _953 = ((_945 * fOptimizedParam.z) * (_946 + fOptimizedParam.x)) * _819;
              _959 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_953 * _941) + 0.5f), (((_953 * ((_797 * 2.0f) + -1.0f)) * (((_946 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _968 = (_798 * 2.0f) + -1.0f;
              _972 = sqrt((_968 * _968) + 1.0f);
              _973 = 1.0f / _972;
              _980 = ((_972 * fOptimizedParam.z) * (_973 + fOptimizedParam.x)) * _819;
              _986 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_980 * _968) + 0.5f), (((_980 * ((_799 * 2.0f) + -1.0f)) * (((_973 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _995 = (_800 * 2.0f) + -1.0f;
              _999 = sqrt((_995 * _995) + 1.0f);
              _1000 = 1.0f / _999;
              _1007 = ((_999 * fOptimizedParam.z) * (_1000 + fOptimizedParam.x)) * _819;
              _1013 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1007 * _995) + 0.5f), (((_1007 * ((_801 * 2.0f) + -1.0f)) * (((_1000 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1022 = (_802 * 2.0f) + -1.0f;
              _1026 = sqrt((_1022 * _1022) + 1.0f);
              _1027 = 1.0f / _1026;
              _1034 = ((_1026 * fOptimizedParam.z) * (_1027 + fOptimizedParam.x)) * _819;
              _1040 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1034 * _1022) + 0.5f), (((_1034 * ((_803 * 2.0f) + -1.0f)) * (((_1027 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1110 = ((((((((_851.x + _827.x) + _878.x) + _905.x) + _932.x) + _959.x) + _986.x) + _1013.x) + _1040.x);
              _1111 = ((((((((_851.y + _827.y) + _878.y) + _905.y) + _932.y) + _959.y) + _986.y) + _1013.y) + _1040.y);
              _1112 = ((((((((_851.z + _827.z) + _878.z) + _905.z) + _932.z) + _959.z) + _986.z) + _1013.z) + _1040.z);
            } else {
              _1049 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_785, _787), 0.0f);
              _1053 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_788, _789), 0.0f);
              _1060 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_790, _791), 0.0f);
              _1067 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_792, _793), 0.0f);
              _1074 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_794, _795), 0.0f);
              _1081 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_796, _797), 0.0f);
              _1088 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_798, _799), 0.0f);
              _1095 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_800, _801), 0.0f);
              _1102 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_802, _803), 0.0f);
              _1110 = ((((((((_1053.x + _1049.x) + _1060.x) + _1067.x) + _1074.x) + _1081.x) + _1088.x) + _1095.x) + _1102.x);
              _1111 = ((((((((_1053.y + _1049.y) + _1060.y) + _1067.y) + _1074.y) + _1081.y) + _1088.y) + _1095.y) + _1102.y);
              _1112 = ((((((((_1053.z + _1049.z) + _1060.z) + _1067.z) + _1074.z) + _1081.z) + _1088.z) + _1095.z) + _1102.z);
            }
          }
          _1122 = (cbRadialColor.z * (_473 + (Exposure * _1112))) * 0.10000000149011612f;
          _1123 = (cbRadialColor.y * (_472 + (Exposure * _1111))) * 0.10000000149011612f;
          _1124 = (cbRadialColor.x * (_471 + (Exposure * _1110))) * 0.10000000149011612f;
          do {
            _1146 = _1124;
            _1147 = _1123;
            _1148 = _1122;
            if (cbRadialMaskRate.x > 0.0f) {
              _1129 = saturate((_559 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              _1135 = (((_1129 * _1129) * cbRadialMaskRate.x) * (3.0f - (_1129 * 2.0f))) + cbRadialMaskRate.y;
              _1146 = ((_1135 * (_1124 - _471)) + _471);
              _1147 = ((_1135 * (_1123 - _472)) + _472);
              _1148 = ((_1135 * (_1122 - _473)) + _473);
            }
            _1159 = (lerp(_471, _1146, _512));
            _1160 = (lerp(_472, _1147, _512));
            _1161 = (lerp(_473, _1148, _512));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1159 = _471;
      _1160 = _472;
      _1161 = _473;
    }
  } else {
    _1159 = _471;
    _1160 = _472;
    _1161 = _473;
  }
  if (_204 && ((cPassEnabled & 2) != 0)) {
    _1179 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    _1181 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    _1187 = frac(frac((_1181 * 0.005837149918079376f) + (_1179 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      _1201 = 0.0f;
      if (_1187 < fNoiseDensity) {
        _1192 = (int)(uint(_1181 * _1179)) ^ 12345391;
        _1193 = _1192 * 3635641;
        _1201 = (((float)((uint)((uint)((((uint)(_1193) >> 26) | ((int)(_1192 * 232681024))) ^ _1193)))) * 2.3283064365386963e-10f);
      }
      _1203 = frac(_1187 * 757.4846801757812f);
      do {
        _1217 = 0.0f;
        if (_1203 < fNoiseDensity) {
          _1207 = asint(_1203) ^ 12345391;
          _1208 = _1207 * 3635641;
          _1217 = ((((float)((uint)((uint)((((uint)(_1208) >> 26) | ((int)(_1207 * 232681024))) ^ _1208)))) * 2.3283064365386963e-10f) + -0.5f);
        }
        _1219 = frac(_1203 * 757.4846801757812f);
        do {
          _1233 = 0.0f;
          if (_1219 < fNoiseDensity) {
            _1223 = asint(_1219) ^ 12345391;
            _1224 = _1223 * 3635641;
            _1233 = ((((float)((uint)((uint)((((uint)(_1224) >> 26) | ((int)(_1223 * 232681024))) ^ _1224)))) * 2.3283064365386963e-10f) + -0.5f);
          }
          _1234 = _1201 * CUSTOM_NOISE * fNoisePower.x;
          _1235 = _1233 * CUSTOM_NOISE * fNoisePower.y;
          _1236 = _1217 * CUSTOM_NOISE * fNoisePower.y;
          _1250 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1159), saturate(_1160), saturate(_1161)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1261 = ((_1250 * (mad(_1236, 1.4019999504089355f, _1234) - _1159)) + _1159);
          _1262 = ((_1250 * (mad(_1236, -0.7139999866485596f, mad(_1235, -0.3440000116825104f, _1234)) - _1160)) + _1160);
          _1263 = ((_1250 * (mad(_1235, 1.7719999551773071f, _1234) - _1161)) + _1161);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1261 = _1159;
    _1262 = _1160;
    _1263 = _1161;
  }
  _1278 = mad(_1263, (fOCIOTransformMatrix[2].x), mad(_1262, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1261)));
  _1281 = mad(_1263, (fOCIOTransformMatrix[2].y), mad(_1262, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1261)));
  _1284 = mad(_1263, (fOCIOTransformMatrix[2].z), mad(_1262, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1261)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    _1290 = max(max(_1278, _1281), _1284);
    if (!(_1290 == 0.0f)) {
      _1296 = abs(_1290);
      _1297 = (_1290 - _1278) / _1296;
      _1298 = (_1290 - _1281) / _1296;
      _1299 = (_1290 - _1284) / _1296;
      do {
        _1321 = _1297;
        if (!(!(_1297 >= cbControlRGCParam.CyanThreshold))) {
          _1309 = _1297 - cbControlRGCParam.CyanThreshold;
          _1321 = ((_1309 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1309) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        }
        do {
          _1342 = _1298;
          if (!(!(_1298 >= cbControlRGCParam.MagentaThreshold))) {
            _1330 = _1298 - cbControlRGCParam.MagentaThreshold;
            _1342 = ((_1330 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1330) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          }
          do {
            _1362 = _1299;
            if (!(!(_1299 >= cbControlRGCParam.YellowThreshold))) {
              _1350 = _1299 - cbControlRGCParam.YellowThreshold;
              _1362 = ((_1350 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1350) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            }
            _1370 = (_1290 - (_1321 * _1296));
            _1371 = (_1290 - (_1342 * _1296));
            _1372 = (_1290 - (_1362 * _1296));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1370 = _1278;
      _1371 = _1281;
      _1372 = _1284;
    }
  } else {
    _1370 = _1278;
    _1371 = _1281;
    _1372 = _1284;
  }
#if 1
  ApplyColorCorrectTexturePass(
      _204 && ((cPassEnabled & 4) != 0),
      _1370, _1371, _1372,
      fTextureBlendRate,
      fTextureBlendRate2,
      fTextureSize,
      fOneMinusTextureInverseSize,
      fHalfTextureInverseSize,
      fColorMatrix,
      tTextureMap0,
      tTextureMap1,
      tTextureMap2,
      TrilinearClamp,
      _1787, _1788, _1789);
#else
  if (_204 && ((cPassEnabled & 4) != 0)) {
    _1406 = !(_1370 <= 0.0078125f);
    do {
      if (!(_1406)) {
        _1415 = ((_1370 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _1415 = ((log2(_1370) + 9.720000267028809f) * 0.05707762390375137f);
      }
      _1416 = !(_1371 <= 0.0078125f);
      do {
        if (!(_1416)) {
          _1425 = ((_1371 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _1425 = ((log2(_1371) + 9.720000267028809f) * 0.05707762390375137f);
        }
        _1426 = !(_1372 <= 0.0078125f);
        do {
          if (!(_1426)) {
            _1435 = ((_1372 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _1435 = ((log2(_1372) + 9.720000267028809f) * 0.05707762390375137f);
          }
          _1444 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_1415 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1425 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1435 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_1444.x < 0.155251145362854f) {
              _1461 = ((_1444.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((_1444.x >= 0.155251145362854f) && (_1444.x < 1.4679962396621704f)) {
                _1461 = exp2((_1444.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _1461 = 65504.0f;
              }
            }
            do {
              if (_1444.y < 0.155251145362854f) {
                _1475 = ((_1444.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_1444.y >= 0.155251145362854f) && (_1444.y < 1.4679962396621704f)) {
                  _1475 = exp2((_1444.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _1475 = 65504.0f;
                }
              }
              do {
                if (_1444.z < 0.155251145362854f) {
                  _1489 = ((_1444.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_1444.z >= 0.155251145362854f) && (_1444.z < 1.4679962396621704f)) {
                    _1489 = exp2((_1444.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _1489 = 65504.0f;
                  }
                }
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!(_1406)) {
                        _1500 = ((_1370 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _1500 = ((log2(_1370) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(_1416)) {
                          _1509 = ((_1371 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1509 = ((log2(_1371) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(_1426)) {
                            _1518 = ((_1372 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1518 = ((log2(_1372) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          _1526 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_1500 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1509 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1518 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_1526.x < 0.155251145362854f) {
                              _1543 = ((_1526.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((_1526.x >= 0.155251145362854f) && (_1526.x < 1.4679962396621704f)) {
                                _1543 = exp2((_1526.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _1543 = 65504.0f;
                              }
                            }
                            do {
                              if (_1526.y < 0.155251145362854f) {
                                _1557 = ((_1526.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_1526.y >= 0.155251145362854f) && (_1526.y < 1.4679962396621704f)) {
                                  _1557 = exp2((_1526.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1557 = 65504.0f;
                                }
                              }
                              do {
                                if (_1526.z < 0.155251145362854f) {
                                  _1571 = ((_1526.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_1526.z >= 0.155251145362854f) && (_1526.z < 1.4679962396621704f)) {
                                    _1571 = exp2((_1526.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1571 = 65504.0f;
                                  }
                                }
                                _1578 = ((_1543 - _1461) * fTextureBlendRate) + _1461;
                                _1579 = ((_1557 - _1475) * fTextureBlendRate) + _1475;
                                _1580 = ((_1571 - _1489) * fTextureBlendRate) + _1489;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_1578 <= 0.0078125f))) {
                                      _1592 = ((_1578 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _1592 = ((log2(_1578) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_1579 <= 0.0078125f))) {
                                        _1602 = ((_1579 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _1602 = ((log2(_1579) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_1580 <= 0.0078125f))) {
                                          _1612 = ((_1580 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _1612 = ((log2(_1580) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        _1620 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1592 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1602 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1612 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_1620.x < 0.155251145362854f) {
                                            _1637 = ((_1620.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((_1620.x >= 0.155251145362854f) && (_1620.x < 1.4679962396621704f)) {
                                              _1637 = exp2((_1620.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _1637 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_1620.y < 0.155251145362854f) {
                                              _1651 = ((_1620.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((_1620.y >= 0.155251145362854f) && (_1620.y < 1.4679962396621704f)) {
                                                _1651 = exp2((_1620.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _1651 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_1620.z < 0.155251145362854f) {
                                                _1665 = ((_1620.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((_1620.z >= 0.155251145362854f) && (_1620.z < 1.4679962396621704f)) {
                                                  _1665 = exp2((_1620.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _1665 = 65504.0f;
                                                }
                                              }
                                              _1771 = (lerp(_1578, _1637, fTextureBlendRate2));
                                              _1772 = (lerp(_1579, _1651, fTextureBlendRate2));
                                              _1773 = (lerp(_1580, _1665, fTextureBlendRate2));
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _1771 = _1578;
                                  _1772 = _1579;
                                  _1773 = _1580;
                                }
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } else {
                    if (fTextureBlendRate2 > 0.0f) {
                      do {
                        if (!(!(_1461 <= 0.0078125f))) {
                          _1687 = ((_1461 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1687 = ((log2(_1461) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_1475 <= 0.0078125f))) {
                            _1697 = ((_1475 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1697 = ((log2(_1475) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_1489 <= 0.0078125f))) {
                              _1707 = ((_1489 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _1707 = ((log2(_1489) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            _1715 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1687 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1697 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1707 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_1715.x < 0.155251145362854f) {
                                _1732 = ((_1715.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_1715.x >= 0.155251145362854f) && (_1715.x < 1.4679962396621704f)) {
                                  _1732 = exp2((_1715.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1732 = 65504.0f;
                                }
                              }
                              do {
                                if (_1715.y < 0.155251145362854f) {
                                  _1746 = ((_1715.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_1715.y >= 0.155251145362854f) && (_1715.y < 1.4679962396621704f)) {
                                    _1746 = exp2((_1715.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1746 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_1715.z < 0.155251145362854f) {
                                    _1760 = ((_1715.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((_1715.z >= 0.155251145362854f) && (_1715.z < 1.4679962396621704f)) {
                                      _1760 = exp2((_1715.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _1760 = 65504.0f;
                                    }
                                  }
                                  _1771 = (lerp(_1461, _1732, fTextureBlendRate2));
                                  _1772 = (lerp(_1475, _1746, fTextureBlendRate2));
                                  _1773 = (lerp(_1489, _1760, fTextureBlendRate2));
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _1771 = _1461;
                      _1772 = _1475;
                      _1773 = _1489;
                    }
                  }
                  _1787 = (mad(_1773, (fColorMatrix[2].x), mad(_1772, (fColorMatrix[1].x), (_1771 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _1788 = (mad(_1773, (fColorMatrix[2].y), mad(_1772, (fColorMatrix[1].y), (_1771 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _1789 = (mad(_1773, (fColorMatrix[2].z), mad(_1772, (fColorMatrix[1].z), (_1771 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1787 = _1370;
    _1788 = _1371;
    _1789 = _1372;
  }
#endif
  if (VAR_EnableCustomColorCorrect > 0.0f) {
    uint2 _1798; RE_POSTPROCESS_Stencil.GetDimensions(_1798.x, _1798.y);
    _1810 = (float)((uint)((uint)((uint)((uint)(((uint2)(RE_POSTPROCESS_Stencil.Load(int3(int((screenInverseSize.x * SV_Position.x) * float((int)((int)(_1798.x)))), int((screenInverseSize.y * SV_Position.y) * float((int)((int)(_1798.y)))), 0)))).y)) >> 4)));
    if ((VAR_ExColorCorrectTargetStencilID == _1810) || (VAR_ExColorCorrectTargetStencilID_2 == _1810)) {
      do {
        if (!(!(_1370 <= 0.0078125f))) {
          _1827 = ((_1370 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _1827 = ((log2(_1370) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_1371 <= 0.0078125f))) {
            _1837 = ((_1371 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _1837 = ((log2(_1371) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_1372 <= 0.0078125f))) {
              _1847 = ((_1372 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _1847 = ((log2(_1372) + 9.720000267028809f) * 0.05707762390375137f);
            }
            _1856 = ExColorCube.SampleLevel(TrilinearClamp, float3(((_1827 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1837 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1847 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_1856.x < 0.155251145362854f) {
                _1873 = ((_1856.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_1856.x >= 0.155251145362854f) && (_1856.x < 1.4679962396621704f)) {
                  _1873 = exp2((_1856.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _1873 = 65504.0f;
                }
              }
              do {
                if (_1856.y < 0.155251145362854f) {
                  _1887 = ((_1856.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_1856.y >= 0.155251145362854f) && (_1856.y < 1.4679962396621704f)) {
                    _1887 = exp2((_1856.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _1887 = 65504.0f;
                  }
                }
                do {
                  if (_1856.z < 0.155251145362854f) {
                    _1901 = ((_1856.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((_1856.z >= 0.155251145362854f) && (_1856.z < 1.4679962396621704f)) {
                      _1901 = exp2((_1856.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _1901 = 65504.0f;
                    }
                  }
                  do {
                    _1914 = 0.0f;
                    if (VAR_UseEffectMask > 0.0f) {
                      _1906 = RE_POSTPROCESS_EffectMask.Sample(AutomaticWrap, float2(_33, _34));
                      if (VAR_EnableEffectMaskPow > 0.0f) {
                        _1910 = 1.0f - _1906.x;
                        _1914 = (1.0f - (_1910 * _1910));
                      } else {
                        _1914 = _1906.x;
                      }
                    }
                    _1925 = ((_1914 * (_1787 - _1873)) + _1873);
                    _1926 = ((_1914 * (_1788 - _1887)) + _1887);
                    _1927 = ((_1914 * (_1789 - _1901)) + _1901);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1925 = _1787;
      _1926 = _1788;
      _1927 = _1789;
    }
  } else {
    _1925 = _1787;
    _1926 = _1788;
    _1927 = _1789;
  }
  if (_204 && ((cPassEnabled & 8) != 0)) {
    _1963 = saturate(((cvdR.x * _1925) + (cvdR.y * _1926)) + (cvdR.z * _1927));
    _1964 = saturate(((cvdG.x * _1925) + (cvdG.y * _1926)) + (cvdG.z * _1927));
    _1965 = saturate(((cvdB.x * _1925) + (cvdB.y * _1926)) + (cvdB.z * _1927));
  } else {
    _1963 = _1925;
    _1964 = _1926;
    _1965 = _1927;
  }
  _1969 = screenInverseSize.x * SV_Position.x;
  _1970 = screenInverseSize.y * SV_Position.y;
  _1976 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1969, _1970), 0.0f);
  if (_204 && (asint(((float)((bool)(uint)((cPassEnabled & 16) != 0)))) != 0)) {
    _1996 = ColorParam.x * _1976.x;
    _1997 = ColorParam.y * _1976.y;
    _1998 = ColorParam.z * _1976.z;
    _2003 = (ColorParam.w * _1976.w) * saturate((((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1969, _1970), 0.0f)).x) * Levels_Rate) + Levels_Range);
    do {
      if (_1996 < 0.5f) {
        _2015 = ((_1963 * 2.0f) * _1996);
      } else {
        _2015 = (1.0f - (((1.0f - _1963) * 2.0f) * (1.0f - _1996)));
      }
      do {
        if (_1997 < 0.5f) {
          _2027 = ((_1964 * 2.0f) * _1997);
        } else {
          _2027 = (1.0f - (((1.0f - _1964) * 2.0f) * (1.0f - _1997)));
        }
        do {
          if (_1998 < 0.5f) {
            _2039 = ((_1965 * 2.0f) * _1998);
          } else {
            _2039 = (1.0f - (((1.0f - _1965) * 2.0f) * (1.0f - _1998)));
          }
          _2050 = (lerp(_1963, _2015, _2003));
          _2051 = (lerp(_1964, _2027, _2003));
          _2052 = (lerp(_1965, _2039, _2003));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2050 = _1963;
    _2051 = _1964;
    _2052 = _1965;
  }
#if 1
  ApplyCapcomExponentialToneMap(_2050, _2051, _2052,
                                _2157, _2158, _2159);
#else
  if (tonemapParam_isHDRMode == 0.0f) {
    _2060 = invLinearBegin * _2050;
    do {
      _2068 = 1.0f;
      if (!(_2050 >= linearBegin)) {
        _2068 = ((_2060 * _2060) * (3.0f - (_2060 * 2.0f)));
      }
      _2069 = invLinearBegin * _2051;
      do {
        _2077 = 1.0f;
        if (!(_2051 >= linearBegin)) {
          _2077 = ((_2069 * _2069) * (3.0f - (_2069 * 2.0f)));
        }
        _2078 = invLinearBegin * _2052;
        do {
          _2086 = 1.0f;
          if (!(_2052 >= linearBegin)) {
            _2086 = ((_2078 * _2078) * (3.0f - (_2078 * 2.0f)));
          }
          _2095 = select((_2050 < linearStart), 0.0f, 1.0f);
          _2096 = select((_2051 < linearStart), 0.0f, 1.0f);
          _2097 = select((_2052 < linearStart), 0.0f, 1.0f);
          _2157 = (((((1.0f - _2068) * linearBegin) * (pow(_2060, toe))) + ((_2068 - _2095) * ((contrast * _2050) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2050) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2095));
          _2158 = (((((1.0f - _2077) * linearBegin) * (pow(_2069, toe))) + ((_2077 - _2096) * ((contrast * _2051) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2051) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2096));
          _2159 = (((((1.0f - _2086) * linearBegin) * (pow(_2078, toe))) + ((_2086 - _2097) * ((contrast * _2052) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2052) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2097));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2157 = _2050;
    _2158 = _2051;
    _2159 = _2052;
  }
#endif
  if (VAR_EnableHighlightTarget > 0.0f) {
    uint2 _2169; RE_POSTPROCESS_Stencil.GetDimensions(_2169.x, _2169.y);
    if (VAR_TargetStencilID == ((float)((uint)((uint)((uint)((uint)(((uint2)(RE_POSTPROCESS_Stencil.Load(int3(int(float((int)((int)(_2169.x))) * _1969), int(float((int)((int)(_2169.y))) * _1970), 0)))).y)) >> 4))))) {
      _2211 = (VAR_TargetColorMod.x * _2157);
      _2212 = (VAR_TargetColorMod.y * _2158);
      _2213 = (VAR_TargetColorMod.z * _2159);
    } else {
      _2193 = _2159 * 0.11447799950838089f;
      _2194 = (_2158 * 0.5866109728813171f) + (_2157 * 0.298911988735199f);
      _2211 = (((((_2194 - _2157) + _2193) * VAR_GrayScaleRatio) + _2157) * VAR_GrayScaleCoef);
      _2212 = (((((_2194 - _2158) + _2193) * VAR_GrayScaleRatio) + _2158) * VAR_GrayScaleCoef);
      _2213 = (((((_2194 - _2159) + _2193) * VAR_GrayScaleRatio) + _2159) * VAR_GrayScaleCoef);
    }
  } else {
    _2211 = _2157;
    _2212 = _2158;
    _2213 = _2159;
  }
  if (VAR_EnableColorSupport > 0.0f) {
    _2219 = max(_2211, max(_2212, _2213));
    _2222 = _2219 - min(_2211, min(_2212, _2213));
    _2225 = select((!(_2219 == 0.0f)), (_2222 / _2219), 0.0f);
    _2228 = select((_2222 == 0.0f), 0.0f, (1.0f / _2222));
    do {
      if (_2211 == _2219) {
        _2244 = (_2228 * (_2212 - _2213));
      } else {
        if (_2212 == _2219) {
          _2244 = ((_2228 * (_2213 - _2211)) + 2.0f);
        } else {
          _2244 = ((_2228 * (_2211 - _2212)) + 4.0f);
        }
      }
      _2250 = (frac(_2244 * 0.1666666716337204f) * VAR_ColorSupportScale) + VAR_ColorSupportOffset;
      _2297 = (((((((saturate((abs((frac(_2250) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _2225) + 1.0f) * _2219) - _2211) * VAR_ColorSupportIntensity) + _2211);
      _2298 = (((((((saturate((abs((frac(_2250 + 0.6666666865348816f) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _2225) + 1.0f) * _2219) - _2212) * VAR_ColorSupportIntensity) + _2212);
      _2299 = (((((((saturate((abs((frac(_2250 + 0.3333333432674408f) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _2225) + 1.0f) * _2219) - _2213) * VAR_ColorSupportIntensity) + _2213);
    } while (false);
  } else {
    _2297 = _2211;
    _2298 = _2212;
    _2299 = _2213;
  }
  SV_Target.x = _2297;
  SV_Target.y = _2298;
  SV_Target.z = _2299;
  SV_Target.w = 1.0f;
  return SV_Target;
}
#define TONE_MAP_PARAM_CBUFFER_REGISTER b4
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


ByteAddressBuffer WhitePtSrv : register(t0);

Texture3D<float2> BilateralLuminanceSRV : register(t1);

Texture2D<float> BlurredLuminanceSRV : register(t2);

Texture2D<float4> RE_POSTPROCESS_Color : register(t3);

Texture2D<uint2> RE_POSTPROCESS_Stencil : register(t4);

Texture2D<float> RE_POSTPROCESS_EffectMask : register(t5);

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t6);

Texture3D<float4> tTextureMap0 : register(t7);

Texture3D<float4> tTextureMap1 : register(t8);

Texture3D<float4> tTextureMap2 : register(t9);

Texture2D<float4> ImagePlameBase : register(t10);

Texture2D<float> ImagePlameAlpha : register(t11);

Texture3D<float4> ExColorCube : register(t12);

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

cbuffer RangeCompressInfo : register(b1) {
  float rangeCompress : packoffset(c000.x);
  float rangeDecompress : packoffset(c000.y);
  float prevRangeCompress : packoffset(c000.z);
  float prevRangeDecompress : packoffset(c000.w);
  float rangeCompressForResource : packoffset(c001.x);
  float rangeDecompressForResource : packoffset(c001.y);
  float rangeCompressForCommon : packoffset(c001.z);
  float rangeDecompressForCommon : packoffset(c001.w);
};

cbuffer Tonemap : register(b2) {
  float exposureAdjustment : packoffset(c000.x);
  float tonemapRange : packoffset(c000.y);
  float specularSuppression : packoffset(c000.z);
  float sharpness : packoffset(c000.w);
  float preTonemapRange : packoffset(c001.x);
  int useAutoExposure : packoffset(c001.y);
  float echoBlend : packoffset(c001.z);
  float AABlend : packoffset(c001.w);
  float AASubPixel : packoffset(c002.x);
  float ResponsiveAARate : packoffset(c002.y);
  float VelocityWeightRate : packoffset(c002.z);
  float DepthRejectionRate : packoffset(c002.w);
  float ContrastTrackingRate : packoffset(c003.x);
  float ContrastTrackingThreshold : packoffset(c003.y);
  float LEHighlightContrast : packoffset(c003.z);
  float LEShadowContrast : packoffset(c003.w);
  float LEDetailStrength : packoffset(c004.x);
  float LEMiddleGreyLog : packoffset(c004.y);
  float LEBilateralGridScale : packoffset(c004.z);
  float LEBilateralGridBias : packoffset(c004.w);
  float LEPreExposureLog : packoffset(c005.x);
  int LEBlurredLogDownsampleMip : packoffset(c005.y);
  int2 LELuminanceTextureSize : packoffset(c005.z);
};

cbuffer CameraKerare : register(b3) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

// cbuffer TonemapParam : register(b4) {
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

cbuffer LDRPostProcessParam : register(b5) {
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

cbuffer CBControl : register(b6) {
  float3 CBControl_reserve : packoffset(c000.x);
  uint cPassEnabled : packoffset(c000.w);
  row_major float4x4 fOCIOTransformMatrix : packoffset(c001.x);
  RGCParam cbControlRGCParam : packoffset(c005.x);
};

cbuffer UserShaderLDRPostProcessSettings : register(b7) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

cbuffer UserMaterial : register(b8) {
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
  float _46;
  float _47;
  float _179;
  float _180;
  float _227;
  float _293;
  float _395;
  float _665;
  float _720;
  float _721;
  float _722;
  float _804;
  float _1359;
  float _1360;
  float _1361;
  float _1395;
  float _1396;
  float _1397;
  float _1408;
  float _1409;
  float _1410;
  float _1450;
  float _1466;
  float _1482;
  float _1510;
  float _1511;
  float _1512;
  float _1570;
  float _1591;
  float _1611;
  float _1619;
  float _1620;
  float _1621;
  float _1664;
  float _1674;
  float _1684;
  float _1710;
  float _1724;
  float _1738;
  float _1749;
  float _1758;
  float _1767;
  float _1792;
  float _1806;
  float _1820;
  float _1841;
  float _1851;
  float _1861;
  float _1886;
  float _1900;
  float _1914;
  float _1936;
  float _1946;
  float _1956;
  float _1981;
  float _1995;
  float _2009;
  float _2020;
  float _2021;
  float _2022;
  float _2036;
  float _2037;
  float _2038;
  float _2076;
  float _2086;
  float _2096;
  float _2122;
  float _2136;
  float _2150;
  float _2163;
  float _2174;
  float _2175;
  float _2176;
  float _2212;
  float _2213;
  float _2214;
  float _2264;
  float _2276;
  float _2288;
  float _2299;
  float _2300;
  float _2301;
  float _2317;
  float _2326;
  float _2335;
  float _2406;
  float _2407;
  float _2408;
  float _2460;
  float _2461;
  float _2462;
  float _2493;
  float _2546;
  float _2547;
  float _2548;
  float4 _54;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _73;
  float _74;
  float _77;
  float _78;
  float _80;
  float _83;
  float _85;
  float _87;
  float _89;
  float _94;
  float _98;
  float _107;
  float _115;
  float _116;
  float _117;
  float _118;
  float _125;
  float _131;
  float _132;
  float _134;
  float _137;
  float _141;
  float _143;
  float _150;
  float _154;
  float _163;
  float _171;
  float _188;
  float _189;
  float _190;
  float _194;
  float _199;
  float _210;
  float _212;
  float _214;
  float _222;
  float _230;
  uint _262;
  bool _267;
  bool _268;
  float _274;
  float _275;
  float4 _278;
  int _290;
  float _297;
  float _303;
  float2 _311;
  float _315;
  float _319;
  float _325;
  float _326;
  float _329;
  float _341;
  float _348;
  float _349;
  float _350;
  bool _353;
  float _365;
  float _366;
  float _367;
  float _369;
  float _370;
  float _372;
  float _374;
  float _375;
  float4 _380;
  int _392;
  float _399;
  float _405;
  float2 _413;
  float _417;
  float _421;
  float _427;
  float _428;
  float _431;
  float _444;
  float _460;
  float _470;
  float _471;
  float _475;
  float _486;
  float _498;
  float4 _503;
  float _512;
  float4 _517;
  float _526;
  float _537;
  float4 _542;
  float _550;
  float4 _555;
  float _570;
  float _582;
  float _590;
  float _596;
  float _598;
  float _605;
  float _629;
  float _633;
  float _634;
  float _642;
  float _646;
  float _647;
  float4 _650;
  int _662;
  float _669;
  float _675;
  float2 _684;
  float _688;
  float _692;
  float _698;
  float _699;
  float _702;
  float _715;
  uint _742;
  float _754;
  float _758;
  float _761;
  float _767;
  float _768;
  float _770;
  float _772;
  float _775;
  float _778;
  float _784;
  uint _791;
  uint _795;
  uint _798;
  float _808;
  float _810;
  float _811;
  float _812;
  float _813;
  float _815;
  float _819;
  float _820;
  float _822;
  float _827;
  float _828;
  float _829;
  float _834;
  float _835;
  float _836;
  float _841;
  float _842;
  float _843;
  float _848;
  float _849;
  float _850;
  float _855;
  float _856;
  float _857;
  float _862;
  float _863;
  float _864;
  float _869;
  float _870;
  float _873;
  float _878;
  float _879;
  float _881;
  float _882;
  float _886;
  float4 _892;
  float _896;
  float _897;
  float _901;
  float4 _906;
  float _913;
  float _914;
  float _918;
  float4 _923;
  float _930;
  float _931;
  float _935;
  float4 _940;
  float _947;
  float _948;
  float _952;
  float4 _957;
  float _964;
  float _965;
  float _969;
  float4 _974;
  float _981;
  float _982;
  float _986;
  float4 _991;
  float _998;
  float _999;
  float _1003;
  float4 _1008;
  float _1015;
  float _1016;
  float _1020;
  float4 _1025;
  float _1033;
  float _1034;
  float _1035;
  float _1036;
  float _1037;
  float _1038;
  float _1039;
  float _1040;
  float _1041;
  float _1042;
  float _1043;
  float _1044;
  float _1045;
  float _1046;
  float _1047;
  float _1048;
  float _1049;
  float _1050;
  float _1051;
  float _1052;
  float _1056;
  float _1060;
  float _1061;
  float _1068;
  float _1069;
  float4 _1076;
  float _1082;
  float _1086;
  float _1087;
  float _1094;
  float4 _1100;
  float _1109;
  float _1113;
  float _1114;
  float _1121;
  float4 _1127;
  float _1136;
  float _1140;
  float _1141;
  float _1148;
  float4 _1154;
  float _1163;
  float _1167;
  float _1168;
  float _1175;
  float4 _1181;
  float _1190;
  float _1194;
  float _1195;
  float _1202;
  float4 _1208;
  float _1217;
  float _1221;
  float _1222;
  float _1229;
  float4 _1235;
  float _1244;
  float _1248;
  float _1249;
  float _1256;
  float4 _1262;
  float _1271;
  float _1275;
  float _1276;
  float _1283;
  float4 _1289;
  float4 _1298;
  float4 _1302;
  float4 _1309;
  float4 _1316;
  float4 _1323;
  float4 _1330;
  float4 _1337;
  float4 _1344;
  float4 _1351;
  float _1371;
  float _1372;
  float _1373;
  float _1378;
  float _1384;
  float _1428;
  float _1430;
  float _1436;
  int _1441;
  uint _1442;
  float _1452;
  int _1456;
  uint _1457;
  float _1468;
  int _1472;
  uint _1473;
  float _1483;
  float _1484;
  float _1485;
  float _1499;
  float _1527;
  float _1530;
  float _1533;
  float _1539;
  float _1545;
  float _1546;
  float _1547;
  float _1548;
  float _1558;
  float _1579;
  float _1599;
  bool _1655;
  bool _1665;
  bool _1675;
  float4 _1693;
  float4 _1775;
  float _1827;
  float _1828;
  float _1829;
  float4 _1869;
  float4 _1964;
  uint2 _2047;
  float _2059;
  float4 _2105;
  float _2155;
  float _2159;
  float _2218;
  float _2219;
  float4 _2225;
  float _2245;
  float _2246;
  float _2247;
  float _2252;
  float _2309;
  float _2318;
  float _2327;
  float _2344;
  float _2345;
  float _2346;
  uint2 _2418;
  float _2442;
  float _2443;
  float _2468;
  float _2471;
  float _2474;
  float _2477;
  float _2499;
  _46 = screenInverseSize.x * SV_Position.x;
  _47 = screenInverseSize.y * SV_Position.y;
  if (VAR_EnableKompiraTrip > 0.0f) {
    _54 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_46, _47), 0.0f);
    _65 = ((_54.z + _54.x) + _54.y) * 0.029999999329447746f;
    _66 = _54.x * 0.029999999329447746f;
    _67 = _54.y * 0.029999999329447746f;
    _68 = floor(_65);
    _69 = frac(_65);
    _73 = (_69 * _69) * (3.0f - (_69 * 2.0f));
    _74 = _68 * 0.3183099031448364f;
    _77 = frac(_74 + 0.7099999785423279f);
    _78 = frac(_74 + 0.11299999803304672f);
    _80 = _77 * 125000.0f;
    _83 = frac((_80 * _78) * (_78 + _77));
    _85 = (_68 + 1.0f) * 0.3183099031448364f;
    _87 = frac(_85 + 0.7099999785423279f);
    _89 = _87 * 125000.0f;
    _94 = frac(_85 + 0.11299999803304672f);
    _98 = frac((_94 * _80) * (_94 + _77));
    _107 = ((frac((_89 * _78) * (_87 + _78)) - _83) * _73) + _83;
    _115 = floor(_66);
    _116 = floor(_67);
    _117 = frac(_66);
    _118 = frac(_67);
    _125 = (_117 * _117) * (3.0f - (_117 * 2.0f));
    _131 = frac((_115 * 0.3183099031448364f) + 0.7099999785423279f);
    _132 = frac((_116 * 0.3183099031448364f) + 0.11299999803304672f);
    _134 = _131 * 125000.0f;
    _137 = frac((_134 * _132) * (_132 + _131));
    _141 = frac(((_115 + 1.0f) * 0.3183099031448364f) + 0.7099999785423279f);
    _143 = _141 * 125000.0f;
    _150 = frac(((_116 + 1.0f) * 0.3183099031448364f) + 0.11299999803304672f);
    _154 = frac((_150 * _134) * (_150 + _131));
    _163 = ((frac((_143 * _132) * (_141 + _132)) - _137) * _125) + _137;
    _171 = VAR_KompiraTripRate * VAR_DestortionIntensity;
    _179 = (((screenSize.x * _171) * (((((((frac((_94 * _89) * (_94 + _87)) - _98) * _73) + _98) - _107) * 2.0f) * _73) + ((_107 * 2.0f) + -1.0f))) + SV_Position.x);
    _180 = (((screenSize.y * _171) * ((((_118 * _118) * (3.0f - (_118 * 2.0f))) * (((((frac((_150 * _143) * (_150 + _141)) - _154) * _125) + _154) - _163) * 2.0f)) + ((_163 * 2.0f) + -1.0f))) + SV_Position.y);
  } else {
    _179 = SV_Position.x;
    _180 = SV_Position.y;
  }
  [branch]
  if (film_aspect == 0.0f) {
    _188 = Kerare.x / Kerare.w;
    _189 = Kerare.y / Kerare.w;
    _190 = Kerare.z / Kerare.w;
    _194 = abs(rsqrt(dot(float3(_188, _189, _190), float3(_188, _189, _190))) * _190);
    _199 = _194 * _194;
    _227 = ((_199 * _199) * (1.0f - saturate((_194 * kerare_scale) + kerare_offset)));
  } else {
    _210 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    _212 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    _214 = sqrt(dot(float2(_212, _210), float2(_212, _210)));
    _222 = (_214 * _214) + 1.0f;
    _227 = ((1.0f / (_222 * _222)) * (1.0f - saturate(((1.0f / (_214 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  _230 = saturate(_227 + kerare_brightness) * Exposure;
  _262 = uint((float)((uint)(uint)(distortionType)));
  _267 = (LDRPPSettings_enabled != 0);
  _268 = ((cPassEnabled & 1) != 0);
  if (!(_268 && _267)) {
    _274 = screenInverseSize.x * _179;
    _275 = screenInverseSize.y * _180;
    _278 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_274, _275));
    do {
      _293 = 1.0f;
      if (!(useAutoExposure == 0)) {
        _290 = asint(WhitePtSrv.Load(0));
        _293 = asfloat(_290);
      }
      _297 = (_293 * exposureAdjustment) * rangeDecompress;
      _303 = log2(dot(float3((_297 * _278.x), (_297 * _278.y), (_297 * _278.z)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) + 9.999999747378752e-06f);
      _311 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_274, _275, ((LEBilateralGridBias + -0.0078125f) + (LEBilateralGridScale * _303))), 0.0f);
      _315 = BlurredLuminanceSRV.SampleLevel(BilinearClamp, float2(_274, _275), 0.0f);
      _319 = select((_311.y >= 9.999999747378752e-06f), (_311.x / _311.y), _315.x);
      _325 = (LEPreExposureLog + _319) + ((_315.x - _319) * 0.6000000238418579f);
      _326 = LEPreExposureLog + _303;
      _329 = _325 - LEMiddleGreyLog;
      _341 = exp2(((LEMiddleGreyLog - _326) + ((_326 - _325) * LEDetailStrength)) + (select((_329 > 0.0f), LEHighlightContrast, LEShadowContrast) * _329));
      _348 = min((_341 * _278.x), 65000.0f) * _230;
      _349 = min((_341 * _278.y), 65000.0f) * _230;
      _350 = min((_341 * _278.z), 65000.0f) * _230;
      _353 = isfinite(max(max(_348, _349), _350));
      _720 = select(_353, _348, 1.0f);
      _721 = select(_353, _349, 1.0f);
      _722 = select(_353, _350, 1.0f);
    } while (false);
  } else {
    if (_262 == 0) {
      _365 = (screenInverseSize.x * _179) + -0.5f;
      _366 = (screenInverseSize.y * _180) + -0.5f;
      _367 = dot(float2(_365, _366), float2(_365, _366));
      _369 = (_367 * fDistortionCoef) + 1.0f;
      _370 = _365 * fCorrectCoef;
      _372 = _366 * fCorrectCoef;
      _374 = (_370 * _369) + 0.5f;
      _375 = (_372 * _369) + 0.5f;
      if ((int)(uint((float)((uint)(uint)(aberrationEnable)))) == 0) {
        _380 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_374, _375));
        do {
          _395 = 1.0f;
          if (!(useAutoExposure == 0)) {
            _392 = asint(WhitePtSrv.Load(0));
            _395 = asfloat(_392);
          }
          _399 = (_395 * exposureAdjustment) * rangeDecompress;
          _405 = log2(dot(float3((_399 * _380.x), (_399 * _380.y), (_399 * _380.z)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) + 9.999999747378752e-06f);
          _413 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_374, _375, ((LEBilateralGridBias + -0.0078125f) + (LEBilateralGridScale * _405))), 0.0f);
          _417 = BlurredLuminanceSRV.SampleLevel(BilinearClamp, float2(_374, _375), 0.0f);
          _421 = select((_413.y >= 9.999999747378752e-06f), (_413.x / _413.y), _417.x);
          _427 = (LEPreExposureLog + _421) + ((_417.x - _421) * 0.6000000238418579f);
          _428 = LEPreExposureLog + _405;
          _431 = _427 - LEMiddleGreyLog;
          _444 = exp2(((LEMiddleGreyLog - _428) + ((_428 - _427) * LEDetailStrength)) + (select((_431 > 0.0f), LEHighlightContrast, LEShadowContrast) * _431)) * _230;
          _720 = (_444 * _380.x);
          _721 = (_444 * _380.y);
          _722 = (_444 * _380.z);
        } while (false);
      } else {
        _460 = ((saturate((sqrt((_365 * _365) + (_366 * _366)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((int)(uint((float)((uint)(uint)(aberrationBlurEnable)))) == 0)) {
          _470 = (fBlurNoisePower * 0.125f) * frac(frac((_180 * 0.005837149918079376f) + (_179 * 0.0671105608344078f)) * 52.98291778564453f);
          _471 = _460 * 2.0f;
          _475 = (((_470 * _471) + _367) * fDistortionCoef) + 1.0f;
          _486 = ((((_470 + 0.125f) * _471) + _367) * fDistortionCoef) + 1.0f;
          _498 = ((((_470 + 0.25f) * _471) + _367) * fDistortionCoef) + 1.0f;
          _503 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_498 * _370) + 0.5f), ((_498 * _372) + 0.5f)));
          _512 = ((((_470 + 0.375f) * _471) + _367) * fDistortionCoef) + 1.0f;
          _517 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_512 * _370) + 0.5f), ((_512 * _372) + 0.5f)));
          _526 = ((((_470 + 0.5f) * _471) + _367) * fDistortionCoef) + 1.0f;
          _537 = ((((_470 + 0.625f) * _471) + _367) * fDistortionCoef) + 1.0f;
          _542 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_537 * _370) + 0.5f), ((_537 * _372) + 0.5f)));
          _550 = ((((_470 + 0.75f) * _471) + _367) * fDistortionCoef) + 1.0f;
          _555 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_550 * _370) + 0.5f), ((_550 * _372) + 0.5f)));
          _570 = ((((_470 + 0.875f) * _471) + _367) * fDistortionCoef) + 1.0f;
          _582 = ((((_470 + 1.0f) * _471) + _367) * fDistortionCoef) + 1.0f;
          _590 = _230 * 0.3199999928474426f;
          _720 = (((((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_486 * _370) + 0.5f), ((_486 * _372) + 0.5f))))).x) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_475 * _370) + 0.5f), ((_475 * _372) + 0.5f))))).x)) + (_503.x * 0.75f)) + (_517.x * 0.375f)) * _590);
          _721 = ((_230 * 0.3636363744735718f) * ((((_542.y + _517.y) * 0.625f) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_526 * _370) + 0.5f), ((_526 * _372) + 0.5f))))).y)) + ((_555.y + _503.y) * 0.25f)));
          _722 = (((((_555.z * 0.75f) + (_542.z * 0.375f)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_570 * _370) + 0.5f), ((_570 * _372) + 0.5f))))).z)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_582 * _370) + 0.5f), ((_582 * _372) + 0.5f))))).z)) * _590);
        } else {
          _596 = _460 + _367;
          _598 = (_596 * fDistortionCoef) + 1.0f;
          _605 = ((_596 + _460) * fDistortionCoef) + 1.0f;
          _720 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_374, _375)))).x) * _230);
          _721 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_598 * _370) + 0.5f), ((_598 * _372) + 0.5f))))).y) * _230);
          _722 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_605 * _370) + 0.5f), ((_605 * _372) + 0.5f))))).z) * _230);
        }
      }
    } else {
      if (_262 == 1) {
        _629 = ((_179 * 2.0f) * screenInverseSize.x) + -1.0f;
        _633 = sqrt((_629 * _629) + 1.0f);
        _634 = 1.0f / _633;
        _642 = ((_633 * fOptimizedParam.z) * (_634 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        _646 = (_642 * _629) + 0.5f;
        _647 = ((_642 * (((_180 * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_634 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f;
        _650 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_646, _647));
        do {
          _665 = 1.0f;
          if (!(useAutoExposure == 0)) {
            _662 = asint(WhitePtSrv.Load(0));
            _665 = asfloat(_662);
          }
          _669 = (_665 * exposureAdjustment) * rangeDecompress;
          _675 = log2(dot(float3((_669 * _650.x), (_669 * _650.y), (_669 * _650.z)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) + 9.999999747378752e-06f);
          _684 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_646, _647, ((LEBilateralGridBias + -0.0078125f) + (LEBilateralGridScale * _675))), 0.0f);
          _688 = BlurredLuminanceSRV.SampleLevel(BilinearClamp, float2(_646, _647), 0.0f);
          _692 = select((_684.y >= 9.999999747378752e-06f), (_684.x / _684.y), _688.x);
          _698 = (LEPreExposureLog + _692) + ((_688.x - _692) * 0.6000000238418579f);
          _699 = LEPreExposureLog + _675;
          _702 = _698 - LEMiddleGreyLog;
          _715 = exp2(((LEMiddleGreyLog - _699) + ((_699 - _698) * LEDetailStrength)) + (select((_702 > 0.0f), LEHighlightContrast, LEShadowContrast) * _702)) * _230;
          _720 = (_715 * _650.x);
          _721 = (_715 * _650.y);
          _722 = (_715 * _650.z);
        } while (false);
      } else {
        _720 = 0.0f;
        _721 = 0.0f;
        _722 = 0.0f;
      }
    }
  }
  _742 = uint(asfloat(cbRadialBlurFlags));
  if (_267 && ((cPassEnabled & 32) != 0)) {
    _754 = (float)((bool)(uint)((_742 & 2) != 0));
    _758 = ComputeResultSRV[0].computeAlpha;
    _761 = ((1.0f - _754) + (_758 * _754)) * cbRadialColor.w;
    if (!(_761 == 0.0f)) {
      _767 = screenInverseSize.x * _179;
      _768 = screenInverseSize.y * _180;
      _770 = _767 + (-0.5f - cbRadialScreenPos.x);
      _772 = _768 + (-0.5f - cbRadialScreenPos.y);
      _775 = select((_770 < 0.0f), (1.0f - _767), _767);
      _778 = select((_772 < 0.0f), (1.0f - _768), _768);
      do {
        _804 = 1.0f;
        if (!((_742 & 1) == 0)) {
          _784 = rsqrt(dot(float2(_770, _772), float2(_770, _772))) * cbRadialSharpRange;
          _791 = uint(abs(_784 * _772)) + uint(abs(_784 * _770));
          _795 = ((_791 ^ 61) ^ ((uint)(_791) >> 16)) * 9;
          _798 = (((uint)(_795) >> 4) ^ _795) * 668265261;
          _804 = (((float)((uint)((uint)(((uint)(_798) >> 15) ^ _798)))) * 2.3283064365386963e-10f);
        }
        _808 = sqrt((_770 * _770) + (_772 * _772));
        _810 = 1.0f / max(1.0f, _808);
        _811 = _804 * _775;
        _812 = cbRadialBlurPower * _810;
        _813 = _812 * -0.0011111111380159855f;
        _815 = _804 * _778;
        _819 = ((_813 * _811) + 1.0f) * _770;
        _820 = ((_813 * _815) + 1.0f) * _772;
        _822 = _812 * -0.002222222276031971f;
        _827 = ((_822 * _811) + 1.0f) * _770;
        _828 = ((_822 * _815) + 1.0f) * _772;
        _829 = _812 * -0.0033333334140479565f;
        _834 = ((_829 * _811) + 1.0f) * _770;
        _835 = ((_829 * _815) + 1.0f) * _772;
        _836 = _812 * -0.004444444552063942f;
        _841 = ((_836 * _811) + 1.0f) * _770;
        _842 = ((_836 * _815) + 1.0f) * _772;
        _843 = _812 * -0.0055555556900799274f;
        _848 = ((_843 * _811) + 1.0f) * _770;
        _849 = ((_843 * _815) + 1.0f) * _772;
        _850 = _812 * -0.006666666828095913f;
        _855 = ((_850 * _811) + 1.0f) * _770;
        _856 = ((_850 * _815) + 1.0f) * _772;
        _857 = _812 * -0.007777777966111898f;
        _862 = ((_857 * _811) + 1.0f) * _770;
        _863 = ((_857 * _815) + 1.0f) * _772;
        _864 = _812 * -0.008888889104127884f;
        _869 = ((_864 * _811) + 1.0f) * _770;
        _870 = ((_864 * _815) + 1.0f) * _772;
        _873 = _810 * ((cbRadialBlurPower * -0.009999999776482582f) * _804);
        _878 = ((_873 * _775) + 1.0f) * _770;
        _879 = ((_873 * _778) + 1.0f) * _772;
        do {
          if (_268 && (_262 == 0)) {
            _881 = _819 + cbRadialScreenPos.x;
            _882 = _820 + cbRadialScreenPos.y;
            _886 = ((dot(float2(_881, _882), float2(_881, _882)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _892 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_886 * _881) + 0.5f), ((_886 * _882) + 0.5f)), 0.0f);
            _896 = _827 + cbRadialScreenPos.x;
            _897 = _828 + cbRadialScreenPos.y;
            _901 = ((dot(float2(_896, _897), float2(_896, _897)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _906 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_901 * _896) + 0.5f), ((_901 * _897) + 0.5f)), 0.0f);
            _913 = _834 + cbRadialScreenPos.x;
            _914 = _835 + cbRadialScreenPos.y;
            _918 = ((dot(float2(_913, _914), float2(_913, _914)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _923 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_918 * _913) + 0.5f), ((_918 * _914) + 0.5f)), 0.0f);
            _930 = _841 + cbRadialScreenPos.x;
            _931 = _842 + cbRadialScreenPos.y;
            _935 = ((dot(float2(_930, _931), float2(_930, _931)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _940 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_935 * _930) + 0.5f), ((_935 * _931) + 0.5f)), 0.0f);
            _947 = _848 + cbRadialScreenPos.x;
            _948 = _849 + cbRadialScreenPos.y;
            _952 = ((dot(float2(_947, _948), float2(_947, _948)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _957 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_952 * _947) + 0.5f), ((_952 * _948) + 0.5f)), 0.0f);
            _964 = _855 + cbRadialScreenPos.x;
            _965 = _856 + cbRadialScreenPos.y;
            _969 = ((dot(float2(_964, _965), float2(_964, _965)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _974 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_969 * _964) + 0.5f), ((_969 * _965) + 0.5f)), 0.0f);
            _981 = _862 + cbRadialScreenPos.x;
            _982 = _863 + cbRadialScreenPos.y;
            _986 = ((dot(float2(_981, _982), float2(_981, _982)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _991 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_986 * _981) + 0.5f), ((_986 * _982) + 0.5f)), 0.0f);
            _998 = _869 + cbRadialScreenPos.x;
            _999 = _870 + cbRadialScreenPos.y;
            _1003 = ((dot(float2(_998, _999), float2(_998, _999)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _1008 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1003 * _998) + 0.5f), ((_1003 * _999) + 0.5f)), 0.0f);
            _1015 = _878 + cbRadialScreenPos.x;
            _1016 = _879 + cbRadialScreenPos.y;
            _1020 = ((dot(float2(_1015, _1016), float2(_1015, _1016)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _1025 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1020 * _1015) + 0.5f), ((_1020 * _1016) + 0.5f)), 0.0f);
            _1359 = ((((((((_906.x + _892.x) + _923.x) + _940.x) + _957.x) + _974.x) + _991.x) + _1008.x) + _1025.x);
            _1360 = ((((((((_906.y + _892.y) + _923.y) + _940.y) + _957.y) + _974.y) + _991.y) + _1008.y) + _1025.y);
            _1361 = ((((((((_906.z + _892.z) + _923.z) + _940.z) + _957.z) + _974.z) + _991.z) + _1008.z) + _1025.z);
          } else {
            _1033 = cbRadialScreenPos.x + 0.5f;
            _1034 = _819 + _1033;
            _1035 = cbRadialScreenPos.y + 0.5f;
            _1036 = _820 + _1035;
            _1037 = _827 + _1033;
            _1038 = _828 + _1035;
            _1039 = _834 + _1033;
            _1040 = _835 + _1035;
            _1041 = _841 + _1033;
            _1042 = _842 + _1035;
            _1043 = _848 + _1033;
            _1044 = _849 + _1035;
            _1045 = _855 + _1033;
            _1046 = _856 + _1035;
            _1047 = _862 + _1033;
            _1048 = _863 + _1035;
            _1049 = _869 + _1033;
            _1050 = _870 + _1035;
            _1051 = _878 + _1033;
            _1052 = _879 + _1035;
            if (_268 && (_262 == 1)) {
              _1056 = (_1034 * 2.0f) + -1.0f;
              _1060 = sqrt((_1056 * _1056) + 1.0f);
              _1061 = 1.0f / _1060;
              _1068 = fOptimizedParam.w * 0.5f;
              _1069 = ((_1060 * fOptimizedParam.z) * (_1061 + fOptimizedParam.x)) * _1068;
              _1076 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1069 * _1056) + 0.5f), (((_1069 * ((_1036 * 2.0f) + -1.0f)) * (((_1061 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1082 = (_1037 * 2.0f) + -1.0f;
              _1086 = sqrt((_1082 * _1082) + 1.0f);
              _1087 = 1.0f / _1086;
              _1094 = ((_1086 * fOptimizedParam.z) * (_1087 + fOptimizedParam.x)) * _1068;
              _1100 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1094 * _1082) + 0.5f), (((_1094 * ((_1038 * 2.0f) + -1.0f)) * (((_1087 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1109 = (_1039 * 2.0f) + -1.0f;
              _1113 = sqrt((_1109 * _1109) + 1.0f);
              _1114 = 1.0f / _1113;
              _1121 = ((_1113 * fOptimizedParam.z) * (_1114 + fOptimizedParam.x)) * _1068;
              _1127 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1121 * _1109) + 0.5f), (((_1121 * ((_1040 * 2.0f) + -1.0f)) * (((_1114 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1136 = (_1041 * 2.0f) + -1.0f;
              _1140 = sqrt((_1136 * _1136) + 1.0f);
              _1141 = 1.0f / _1140;
              _1148 = ((_1140 * fOptimizedParam.z) * (_1141 + fOptimizedParam.x)) * _1068;
              _1154 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1148 * _1136) + 0.5f), (((_1148 * ((_1042 * 2.0f) + -1.0f)) * (((_1141 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1163 = (_1043 * 2.0f) + -1.0f;
              _1167 = sqrt((_1163 * _1163) + 1.0f);
              _1168 = 1.0f / _1167;
              _1175 = ((_1167 * fOptimizedParam.z) * (_1168 + fOptimizedParam.x)) * _1068;
              _1181 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1175 * _1163) + 0.5f), (((_1175 * ((_1044 * 2.0f) + -1.0f)) * (((_1168 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1190 = (_1045 * 2.0f) + -1.0f;
              _1194 = sqrt((_1190 * _1190) + 1.0f);
              _1195 = 1.0f / _1194;
              _1202 = ((_1194 * fOptimizedParam.z) * (_1195 + fOptimizedParam.x)) * _1068;
              _1208 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1202 * _1190) + 0.5f), (((_1202 * ((_1046 * 2.0f) + -1.0f)) * (((_1195 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1217 = (_1047 * 2.0f) + -1.0f;
              _1221 = sqrt((_1217 * _1217) + 1.0f);
              _1222 = 1.0f / _1221;
              _1229 = ((_1221 * fOptimizedParam.z) * (_1222 + fOptimizedParam.x)) * _1068;
              _1235 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1229 * _1217) + 0.5f), (((_1229 * ((_1048 * 2.0f) + -1.0f)) * (((_1222 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1244 = (_1049 * 2.0f) + -1.0f;
              _1248 = sqrt((_1244 * _1244) + 1.0f);
              _1249 = 1.0f / _1248;
              _1256 = ((_1248 * fOptimizedParam.z) * (_1249 + fOptimizedParam.x)) * _1068;
              _1262 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1256 * _1244) + 0.5f), (((_1256 * ((_1050 * 2.0f) + -1.0f)) * (((_1249 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1271 = (_1051 * 2.0f) + -1.0f;
              _1275 = sqrt((_1271 * _1271) + 1.0f);
              _1276 = 1.0f / _1275;
              _1283 = ((_1275 * fOptimizedParam.z) * (_1276 + fOptimizedParam.x)) * _1068;
              _1289 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1283 * _1271) + 0.5f), (((_1283 * ((_1052 * 2.0f) + -1.0f)) * (((_1276 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1359 = ((((((((_1100.x + _1076.x) + _1127.x) + _1154.x) + _1181.x) + _1208.x) + _1235.x) + _1262.x) + _1289.x);
              _1360 = ((((((((_1100.y + _1076.y) + _1127.y) + _1154.y) + _1181.y) + _1208.y) + _1235.y) + _1262.y) + _1289.y);
              _1361 = ((((((((_1100.z + _1076.z) + _1127.z) + _1154.z) + _1181.z) + _1208.z) + _1235.z) + _1262.z) + _1289.z);
            } else {
              _1298 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1034, _1036), 0.0f);
              _1302 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1037, _1038), 0.0f);
              _1309 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1039, _1040), 0.0f);
              _1316 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1041, _1042), 0.0f);
              _1323 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1043, _1044), 0.0f);
              _1330 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1045, _1046), 0.0f);
              _1337 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1047, _1048), 0.0f);
              _1344 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1049, _1050), 0.0f);
              _1351 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1051, _1052), 0.0f);
              _1359 = ((((((((_1302.x + _1298.x) + _1309.x) + _1316.x) + _1323.x) + _1330.x) + _1337.x) + _1344.x) + _1351.x);
              _1360 = ((((((((_1302.y + _1298.y) + _1309.y) + _1316.y) + _1323.y) + _1330.y) + _1337.y) + _1344.y) + _1351.y);
              _1361 = ((((((((_1302.z + _1298.z) + _1309.z) + _1316.z) + _1323.z) + _1330.z) + _1337.z) + _1344.z) + _1351.z);
            }
          }
          _1371 = (cbRadialColor.z * (_722 + (_230 * _1361))) * 0.10000000149011612f;
          _1372 = (cbRadialColor.y * (_721 + (_230 * _1360))) * 0.10000000149011612f;
          _1373 = (cbRadialColor.x * (_720 + (_230 * _1359))) * 0.10000000149011612f;
          do {
            _1395 = _1373;
            _1396 = _1372;
            _1397 = _1371;
            if (cbRadialMaskRate.x > 0.0f) {
              _1378 = saturate((_808 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              _1384 = (((_1378 * _1378) * cbRadialMaskRate.x) * (3.0f - (_1378 * 2.0f))) + cbRadialMaskRate.y;
              _1395 = ((_1384 * (_1373 - _720)) + _720);
              _1396 = ((_1384 * (_1372 - _721)) + _721);
              _1397 = ((_1384 * (_1371 - _722)) + _722);
            }
            _1408 = (lerp(_720, _1395, _761));
            _1409 = (lerp(_721, _1396, _761));
            _1410 = (lerp(_722, _1397, _761));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1408 = _720;
      _1409 = _721;
      _1410 = _722;
    }
  } else {
    _1408 = _720;
    _1409 = _721;
    _1410 = _722;
  }
  if (_267 && ((cPassEnabled & 2) != 0)) {
    _1428 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    _1430 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    _1436 = frac(frac((_1430 * 0.005837149918079376f) + (_1428 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      _1450 = 0.0f;
      if (_1436 < fNoiseDensity) {
        _1441 = (int)(uint(_1430 * _1428)) ^ 12345391;
        _1442 = _1441 * 3635641;
        _1450 = (((float)((uint)((uint)((((uint)(_1442) >> 26) | ((int)(_1441 * 232681024))) ^ _1442)))) * 2.3283064365386963e-10f);
      }
      _1452 = frac(_1436 * 757.4846801757812f);
      do {
        _1466 = 0.0f;
        if (_1452 < fNoiseDensity) {
          _1456 = asint(_1452) ^ 12345391;
          _1457 = _1456 * 3635641;
          _1466 = ((((float)((uint)((uint)((((uint)(_1457) >> 26) | ((int)(_1456 * 232681024))) ^ _1457)))) * 2.3283064365386963e-10f) + -0.5f);
        }
        _1468 = frac(_1452 * 757.4846801757812f);
        do {
          _1482 = 0.0f;
          if (_1468 < fNoiseDensity) {
            _1472 = asint(_1468) ^ 12345391;
            _1473 = _1472 * 3635641;
            _1482 = ((((float)((uint)((uint)((((uint)(_1473) >> 26) | ((int)(_1472 * 232681024))) ^ _1473)))) * 2.3283064365386963e-10f) + -0.5f);
          }
          _1483 = _1450 * CUSTOM_NOISE * fNoisePower.x;
          _1484 = _1482 * CUSTOM_NOISE * fNoisePower.y;
          _1485 = _1466 * CUSTOM_NOISE * fNoisePower.y;
          _1499 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1408), saturate(_1409), saturate(_1410)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1510 = ((_1499 * (mad(_1485, 1.4019999504089355f, _1483) - _1408)) + _1408);
          _1511 = ((_1499 * (mad(_1485, -0.7139999866485596f, mad(_1484, -0.3440000116825104f, _1483)) - _1409)) + _1409);
          _1512 = ((_1499 * (mad(_1484, 1.7719999551773071f, _1483) - _1410)) + _1410);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1510 = _1408;
    _1511 = _1409;
    _1512 = _1410;
  }
  _1527 = mad(_1512, (fOCIOTransformMatrix[2].x), mad(_1511, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1510)));
  _1530 = mad(_1512, (fOCIOTransformMatrix[2].y), mad(_1511, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1510)));
  _1533 = mad(_1512, (fOCIOTransformMatrix[2].z), mad(_1511, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1510)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    _1539 = max(max(_1527, _1530), _1533);
    if (!(_1539 == 0.0f)) {
      _1545 = abs(_1539);
      _1546 = (_1539 - _1527) / _1545;
      _1547 = (_1539 - _1530) / _1545;
      _1548 = (_1539 - _1533) / _1545;
      do {
        _1570 = _1546;
        if (!(!(_1546 >= cbControlRGCParam.CyanThreshold))) {
          _1558 = _1546 - cbControlRGCParam.CyanThreshold;
          _1570 = ((_1558 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1558) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        }
        do {
          _1591 = _1547;
          if (!(!(_1547 >= cbControlRGCParam.MagentaThreshold))) {
            _1579 = _1547 - cbControlRGCParam.MagentaThreshold;
            _1591 = ((_1579 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1579) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          }
          do {
            _1611 = _1548;
            if (!(!(_1548 >= cbControlRGCParam.YellowThreshold))) {
              _1599 = _1548 - cbControlRGCParam.YellowThreshold;
              _1611 = ((_1599 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1599) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            }
            _1619 = (_1539 - (_1570 * _1545));
            _1620 = (_1539 - (_1591 * _1545));
            _1621 = (_1539 - (_1611 * _1545));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1619 = _1527;
      _1620 = _1530;
      _1621 = _1533;
    }
  } else {
    _1619 = _1527;
    _1620 = _1530;
    _1621 = _1533;
  }
#if 1
  ApplyColorCorrectTexturePass(
      _267 && ((cPassEnabled & 4) != 0),
      _1619, _1620, _1621,
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
      _2036, _2037, _2038);
#else
  if (_267 && ((cPassEnabled & 4) != 0)) {
    _1655 = !(_1619 <= 0.0078125f);
    do {
      if (!(_1655)) {
        _1664 = ((_1619 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _1664 = ((log2(_1619) + 9.720000267028809f) * 0.05707762390375137f);
      }
      _1665 = !(_1620 <= 0.0078125f);
      do {
        if (!(_1665)) {
          _1674 = ((_1620 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _1674 = ((log2(_1620) + 9.720000267028809f) * 0.05707762390375137f);
        }
        _1675 = !(_1621 <= 0.0078125f);
        do {
          if (!(_1675)) {
            _1684 = ((_1621 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _1684 = ((log2(_1621) + 9.720000267028809f) * 0.05707762390375137f);
          }
          _1693 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_1664 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1674 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1684 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_1693.x < 0.155251145362854f) {
              _1710 = ((_1693.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((_1693.x >= 0.155251145362854f) && (_1693.x < 1.4679962396621704f)) {
                _1710 = exp2((_1693.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _1710 = 65504.0f;
              }
            }
            do {
              if (_1693.y < 0.155251145362854f) {
                _1724 = ((_1693.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_1693.y >= 0.155251145362854f) && (_1693.y < 1.4679962396621704f)) {
                  _1724 = exp2((_1693.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _1724 = 65504.0f;
                }
              }
              do {
                if (_1693.z < 0.155251145362854f) {
                  _1738 = ((_1693.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_1693.z >= 0.155251145362854f) && (_1693.z < 1.4679962396621704f)) {
                    _1738 = exp2((_1693.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _1738 = 65504.0f;
                  }
                }
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!(_1655)) {
                        _1749 = ((_1619 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _1749 = ((log2(_1619) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(_1665)) {
                          _1758 = ((_1620 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1758 = ((log2(_1620) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(_1675)) {
                            _1767 = ((_1621 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1767 = ((log2(_1621) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          _1775 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_1749 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1758 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1767 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_1775.x < 0.155251145362854f) {
                              _1792 = ((_1775.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((_1775.x >= 0.155251145362854f) && (_1775.x < 1.4679962396621704f)) {
                                _1792 = exp2((_1775.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _1792 = 65504.0f;
                              }
                            }
                            do {
                              if (_1775.y < 0.155251145362854f) {
                                _1806 = ((_1775.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_1775.y >= 0.155251145362854f) && (_1775.y < 1.4679962396621704f)) {
                                  _1806 = exp2((_1775.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1806 = 65504.0f;
                                }
                              }
                              do {
                                if (_1775.z < 0.155251145362854f) {
                                  _1820 = ((_1775.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_1775.z >= 0.155251145362854f) && (_1775.z < 1.4679962396621704f)) {
                                    _1820 = exp2((_1775.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1820 = 65504.0f;
                                  }
                                }
                                _1827 = ((_1792 - _1710) * fTextureBlendRate) + _1710;
                                _1828 = ((_1806 - _1724) * fTextureBlendRate) + _1724;
                                _1829 = ((_1820 - _1738) * fTextureBlendRate) + _1738;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_1827 <= 0.0078125f))) {
                                      _1841 = ((_1827 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _1841 = ((log2(_1827) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_1828 <= 0.0078125f))) {
                                        _1851 = ((_1828 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _1851 = ((log2(_1828) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_1829 <= 0.0078125f))) {
                                          _1861 = ((_1829 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _1861 = ((log2(_1829) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        _1869 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1841 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1851 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1861 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_1869.x < 0.155251145362854f) {
                                            _1886 = ((_1869.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((_1869.x >= 0.155251145362854f) && (_1869.x < 1.4679962396621704f)) {
                                              _1886 = exp2((_1869.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _1886 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_1869.y < 0.155251145362854f) {
                                              _1900 = ((_1869.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((_1869.y >= 0.155251145362854f) && (_1869.y < 1.4679962396621704f)) {
                                                _1900 = exp2((_1869.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _1900 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_1869.z < 0.155251145362854f) {
                                                _1914 = ((_1869.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((_1869.z >= 0.155251145362854f) && (_1869.z < 1.4679962396621704f)) {
                                                  _1914 = exp2((_1869.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _1914 = 65504.0f;
                                                }
                                              }
                                              _2020 = (lerp(_1827, _1886, fTextureBlendRate2));
                                              _2021 = (lerp(_1828, _1900, fTextureBlendRate2));
                                              _2022 = (lerp(_1829, _1914, fTextureBlendRate2));
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _2020 = _1827;
                                  _2021 = _1828;
                                  _2022 = _1829;
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
                        if (!(!(_1710 <= 0.0078125f))) {
                          _1936 = ((_1710 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1936 = ((log2(_1710) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_1724 <= 0.0078125f))) {
                            _1946 = ((_1724 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1946 = ((log2(_1724) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_1738 <= 0.0078125f))) {
                              _1956 = ((_1738 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _1956 = ((log2(_1738) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            _1964 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1936 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1946 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1956 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_1964.x < 0.155251145362854f) {
                                _1981 = ((_1964.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_1964.x >= 0.155251145362854f) && (_1964.x < 1.4679962396621704f)) {
                                  _1981 = exp2((_1964.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1981 = 65504.0f;
                                }
                              }
                              do {
                                if (_1964.y < 0.155251145362854f) {
                                  _1995 = ((_1964.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_1964.y >= 0.155251145362854f) && (_1964.y < 1.4679962396621704f)) {
                                    _1995 = exp2((_1964.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1995 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_1964.z < 0.155251145362854f) {
                                    _2009 = ((_1964.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((_1964.z >= 0.155251145362854f) && (_1964.z < 1.4679962396621704f)) {
                                      _2009 = exp2((_1964.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _2009 = 65504.0f;
                                    }
                                  }
                                  _2020 = (lerp(_1710, _1981, fTextureBlendRate2));
                                  _2021 = (lerp(_1724, _1995, fTextureBlendRate2));
                                  _2022 = (lerp(_1738, _2009, fTextureBlendRate2));
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _2020 = _1710;
                      _2021 = _1724;
                      _2022 = _1738;
                    }
                  }
                  _2036 = (mad(_2022, (fColorMatrix[2].x), mad(_2021, (fColorMatrix[1].x), (_2020 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _2037 = (mad(_2022, (fColorMatrix[2].y), mad(_2021, (fColorMatrix[1].y), (_2020 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _2038 = (mad(_2022, (fColorMatrix[2].z), mad(_2021, (fColorMatrix[1].z), (_2020 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2036 = _1619;
    _2037 = _1620;
    _2038 = _1621;
  }
#endif
  if (VAR_EnableCustomColorCorrect > 0.0f) {
    uint2 _2047; RE_POSTPROCESS_Stencil.GetDimensions(_2047.x, _2047.y);
    _2059 = (float)((uint)((uint)((uint)((uint)(((uint2)(RE_POSTPROCESS_Stencil.Load(int3(int((screenInverseSize.x * SV_Position.x) * float((int)((int)(_2047.x)))), int((screenInverseSize.y * SV_Position.y) * float((int)((int)(_2047.y)))), 0)))).y)) >> 4)));
    if ((VAR_ExColorCorrectTargetStencilID == _2059) || (VAR_ExColorCorrectTargetStencilID_2 == _2059)) {
      do {
        if (!(!(_1619 <= 0.0078125f))) {
          _2076 = ((_1619 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2076 = ((log2(_1619) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_1620 <= 0.0078125f))) {
            _2086 = ((_1620 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _2086 = ((log2(_1620) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_1621 <= 0.0078125f))) {
              _2096 = ((_1621 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _2096 = ((log2(_1621) + 9.720000267028809f) * 0.05707762390375137f);
            }
            _2105 = ExColorCube.SampleLevel(TrilinearClamp, float3(((_2076 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2086 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2096 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_2105.x < 0.155251145362854f) {
                _2122 = ((_2105.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_2105.x >= 0.155251145362854f) && (_2105.x < 1.4679962396621704f)) {
                  _2122 = exp2((_2105.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _2122 = 65504.0f;
                }
              }
              do {
                if (_2105.y < 0.155251145362854f) {
                  _2136 = ((_2105.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_2105.y >= 0.155251145362854f) && (_2105.y < 1.4679962396621704f)) {
                    _2136 = exp2((_2105.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _2136 = 65504.0f;
                  }
                }
                do {
                  if (_2105.z < 0.155251145362854f) {
                    _2150 = ((_2105.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((_2105.z >= 0.155251145362854f) && (_2105.z < 1.4679962396621704f)) {
                      _2150 = exp2((_2105.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _2150 = 65504.0f;
                    }
                  }
                  do {
                    _2163 = 0.0f;
                    if (VAR_UseEffectMask > 0.0f) {
                      _2155 = RE_POSTPROCESS_EffectMask.Sample(AutomaticWrap, float2(_46, _47));
                      if (VAR_EnableEffectMaskPow > 0.0f) {
                        _2159 = 1.0f - _2155.x;
                        _2163 = (1.0f - (_2159 * _2159));
                      } else {
                        _2163 = _2155.x;
                      }
                    }
                    _2174 = ((_2163 * (_2036 - _2122)) + _2122);
                    _2175 = ((_2163 * (_2037 - _2136)) + _2136);
                    _2176 = ((_2163 * (_2038 - _2150)) + _2150);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _2174 = _2036;
      _2175 = _2037;
      _2176 = _2038;
    }
  } else {
    _2174 = _2036;
    _2175 = _2037;
    _2176 = _2038;
  }
  if (_267 && ((cPassEnabled & 8) != 0)) {
    _2212 = saturate(((cvdR.x * _2174) + (cvdR.y * _2175)) + (cvdR.z * _2176));
    _2213 = saturate(((cvdG.x * _2174) + (cvdG.y * _2175)) + (cvdG.z * _2176));
    _2214 = saturate(((cvdB.x * _2174) + (cvdB.y * _2175)) + (cvdB.z * _2176));
  } else {
    _2212 = _2174;
    _2213 = _2175;
    _2214 = _2176;
  }
  _2218 = screenInverseSize.x * SV_Position.x;
  _2219 = screenInverseSize.y * SV_Position.y;
  _2225 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2218, _2219), 0.0f);
  if (_267 && (asint(((float)((bool)(uint)((cPassEnabled & 16) != 0)))) != 0)) {
    _2245 = ColorParam.x * _2225.x;
    _2246 = ColorParam.y * _2225.y;
    _2247 = ColorParam.z * _2225.z;
    _2252 = (ColorParam.w * _2225.w) * saturate((((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2218, _2219), 0.0f)).x) * Levels_Rate) + Levels_Range);
    do {
      if (_2245 < 0.5f) {
        _2264 = ((_2212 * 2.0f) * _2245);
      } else {
        _2264 = (1.0f - (((1.0f - _2212) * 2.0f) * (1.0f - _2245)));
      }
      do {
        if (_2246 < 0.5f) {
          _2276 = ((_2213 * 2.0f) * _2246);
        } else {
          _2276 = (1.0f - (((1.0f - _2213) * 2.0f) * (1.0f - _2246)));
        }
        do {
          if (_2247 < 0.5f) {
            _2288 = ((_2214 * 2.0f) * _2247);
          } else {
            _2288 = (1.0f - (((1.0f - _2214) * 2.0f) * (1.0f - _2247)));
          }
          _2299 = (lerp(_2212, _2264, _2252));
          _2300 = (lerp(_2213, _2276, _2252));
          _2301 = (lerp(_2214, _2288, _2252));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2299 = _2212;
    _2300 = _2213;
    _2301 = _2214;
  }
#if 1
  ApplyCapcomExponentialToneMap(_2299, _2300, _2301,
                                _2406, _2407, _2408);
#else
  if (tonemapParam_isHDRMode == 0.0f) {
    _2309 = invLinearBegin * _2299;
    do {
      _2317 = 1.0f;
      if (!(_2299 >= linearBegin)) {
        _2317 = ((_2309 * _2309) * (3.0f - (_2309 * 2.0f)));
      }
      _2318 = invLinearBegin * _2300;
      do {
        _2326 = 1.0f;
        if (!(_2300 >= linearBegin)) {
          _2326 = ((_2318 * _2318) * (3.0f - (_2318 * 2.0f)));
        }
        _2327 = invLinearBegin * _2301;
        do {
          _2335 = 1.0f;
          if (!(_2301 >= linearBegin)) {
            _2335 = ((_2327 * _2327) * (3.0f - (_2327 * 2.0f)));
          }
          _2344 = select((_2299 < linearStart), 0.0f, 1.0f);
          _2345 = select((_2300 < linearStart), 0.0f, 1.0f);
          _2346 = select((_2301 < linearStart), 0.0f, 1.0f);
          _2406 = (((((1.0f - _2317) * linearBegin) * (pow(_2309, toe))) + ((_2317 - _2344) * ((contrast * _2299) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2299) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2344));
          _2407 = (((((1.0f - _2326) * linearBegin) * (pow(_2318, toe))) + ((_2326 - _2345) * ((contrast * _2300) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2300) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2345));
          _2408 = (((((1.0f - _2335) * linearBegin) * (pow(_2327, toe))) + ((_2335 - _2346) * ((contrast * _2301) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2301) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2346));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2406 = _2299;
    _2407 = _2300;
    _2408 = _2301;
  }
#endif
  if (VAR_EnableHighlightTarget > 0.0f) {
    uint2 _2418; RE_POSTPROCESS_Stencil.GetDimensions(_2418.x, _2418.y);
    if (VAR_TargetStencilID == ((float)((uint)((uint)((uint)((uint)(((uint2)(RE_POSTPROCESS_Stencil.Load(int3(int(float((int)((int)(_2418.x))) * _2218), int(float((int)((int)(_2418.y))) * _2219), 0)))).y)) >> 4))))) {
      _2460 = (VAR_TargetColorMod.x * _2406);
      _2461 = (VAR_TargetColorMod.y * _2407);
      _2462 = (VAR_TargetColorMod.z * _2408);
    } else {
      _2442 = _2408 * 0.11447799950838089f;
      _2443 = (_2407 * 0.5866109728813171f) + (_2406 * 0.298911988735199f);
      _2460 = (((((_2443 - _2406) + _2442) * VAR_GrayScaleRatio) + _2406) * VAR_GrayScaleCoef);
      _2461 = (((((_2443 - _2407) + _2442) * VAR_GrayScaleRatio) + _2407) * VAR_GrayScaleCoef);
      _2462 = (((((_2443 - _2408) + _2442) * VAR_GrayScaleRatio) + _2408) * VAR_GrayScaleCoef);
    }
  } else {
    _2460 = _2406;
    _2461 = _2407;
    _2462 = _2408;
  }
  if (VAR_EnableColorSupport > 0.0f) {
    _2468 = max(_2460, max(_2461, _2462));
    _2471 = _2468 - min(_2460, min(_2461, _2462));
    _2474 = select((!(_2468 == 0.0f)), (_2471 / _2468), 0.0f);
    _2477 = select((_2471 == 0.0f), 0.0f, (1.0f / _2471));
    do {
      if (_2460 == _2468) {
        _2493 = (_2477 * (_2461 - _2462));
      } else {
        if (_2461 == _2468) {
          _2493 = ((_2477 * (_2462 - _2460)) + 2.0f);
        } else {
          _2493 = ((_2477 * (_2460 - _2461)) + 4.0f);
        }
      }
      _2499 = (frac(_2493 * 0.1666666716337204f) * VAR_ColorSupportScale) + VAR_ColorSupportOffset;
      _2546 = (((((((saturate((abs((frac(_2499) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _2474) + 1.0f) * _2468) - _2460) * VAR_ColorSupportIntensity) + _2460);
      _2547 = (((((((saturate((abs((frac(_2499 + 0.6666666865348816f) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _2474) + 1.0f) * _2468) - _2461) * VAR_ColorSupportIntensity) + _2461);
      _2548 = (((((((saturate((abs((frac(_2499 + 0.3333333432674408f) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _2474) + 1.0f) * _2468) - _2462) * VAR_ColorSupportIntensity) + _2462);
    } while (false);
  } else {
    _2546 = _2460;
    _2547 = _2461;
    _2548 = _2462;
  }
  SV_Target.x = _2546;
  SV_Target.y = _2547;
  SV_Target.z = _2548;
  SV_Target.w = 1.0f;
  return SV_Target;
}
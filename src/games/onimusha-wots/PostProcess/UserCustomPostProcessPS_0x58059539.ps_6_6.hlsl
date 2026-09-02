#define TONE_MAP_PARAM_CBUFFER_REGISTER b2
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

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
  float film_aspect : packoffset(c000.w);
};

// cbuffer TonemapParam : register(b2) {
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

cbuffer LDRPostProcessParam : register(b3) {
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

cbuffer CBControl : register(b4) {
  float3 CBControl_reserve : packoffset(c000.x);
  uint cPassEnabled : packoffset(c000.w);
  row_major float4x4 fOCIOTransformMatrix : packoffset(c001.x);
  RGCParam cbControlRGCParam : packoffset(c005.x);
};

cbuffer UserShaderLDRPostProcessSettings : register(b5) {
  uint LDRPPSettings_enabled : packoffset(c000.x);
  uint LDRPPSettings_reserve1 : packoffset(c000.y);
  uint LDRPPSettings_reserve2 : packoffset(c000.z);
  uint LDRPPSettings_reserve3 : packoffset(c000.w);
};

cbuffer UserMaterial : register(b6) {
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
  float _39;
  float _40;
  float _172;
  float _173;
  float _220;
  float _527;
  float _528;
  float _529;
  float _611;
  float _1166;
  float _1167;
  float _1168;
  float _1202;
  float _1203;
  float _1204;
  float _1215;
  float _1216;
  float _1217;
  float _1257;
  float _1273;
  float _1289;
  float _1317;
  float _1318;
  float _1319;
  float _1377;
  float _1398;
  float _1418;
  float _1426;
  float _1427;
  float _1428;
  float _1471;
  float _1481;
  float _1491;
  float _1517;
  float _1531;
  float _1545;
  float _1556;
  float _1565;
  float _1574;
  float _1599;
  float _1613;
  float _1627;
  float _1648;
  float _1658;
  float _1668;
  float _1693;
  float _1707;
  float _1721;
  float _1743;
  float _1753;
  float _1763;
  float _1788;
  float _1802;
  float _1816;
  float _1827;
  float _1828;
  float _1829;
  float _1843;
  float _1844;
  float _1845;
  float _1883;
  float _1893;
  float _1903;
  float _1929;
  float _1943;
  float _1957;
  float _1970;
  float _1981;
  float _1982;
  float _1983;
  float _2019;
  float _2020;
  float _2021;
  float _2071;
  float _2083;
  float _2095;
  float _2106;
  float _2107;
  float _2108;
  float _2124;
  float _2133;
  float _2142;
  float _2213;
  float _2214;
  float _2215;
  float _2267;
  float _2268;
  float _2269;
  float _2300;
  float _2353;
  float _2354;
  float _2355;
  float4 _47;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _66;
  float _67;
  float _70;
  float _71;
  float _73;
  float _76;
  float _78;
  float _80;
  float _82;
  float _87;
  float _91;
  float _100;
  float _108;
  float _109;
  float _110;
  float _111;
  float _118;
  float _124;
  float _125;
  float _127;
  float _130;
  float _134;
  float _136;
  float _143;
  float _147;
  float _156;
  float _164;
  float _181;
  float _182;
  float _183;
  float _187;
  float _192;
  float _203;
  float _205;
  float _207;
  float _215;
  float _223;
  uint _255;
  bool _260;
  bool _261;
  float4 _271;
  float _278;
  float _279;
  float _280;
  bool _283;
  float _295;
  float _296;
  float _297;
  float _299;
  float _300;
  float _302;
  float _304;
  float _305;
  float4 _310;
  float _329;
  float _339;
  float _340;
  float _344;
  float _355;
  float _367;
  float4 _372;
  float _381;
  float4 _386;
  float _395;
  float _406;
  float4 _411;
  float _419;
  float4 _424;
  float _439;
  float _451;
  float _459;
  float _465;
  float _467;
  float _474;
  float _498;
  float _502;
  float _503;
  float _511;
  float4 _519;
  uint _549;
  float _561;
  float _565;
  float _568;
  float _574;
  float _575;
  float _577;
  float _579;
  float _582;
  float _585;
  float _591;
  uint _598;
  uint _602;
  uint _605;
  float _615;
  float _617;
  float _618;
  float _619;
  float _620;
  float _622;
  float _626;
  float _627;
  float _629;
  float _634;
  float _635;
  float _636;
  float _641;
  float _642;
  float _643;
  float _648;
  float _649;
  float _650;
  float _655;
  float _656;
  float _657;
  float _662;
  float _663;
  float _664;
  float _669;
  float _670;
  float _671;
  float _676;
  float _677;
  float _680;
  float _685;
  float _686;
  float _688;
  float _689;
  float _693;
  float4 _699;
  float _703;
  float _704;
  float _708;
  float4 _713;
  float _720;
  float _721;
  float _725;
  float4 _730;
  float _737;
  float _738;
  float _742;
  float4 _747;
  float _754;
  float _755;
  float _759;
  float4 _764;
  float _771;
  float _772;
  float _776;
  float4 _781;
  float _788;
  float _789;
  float _793;
  float4 _798;
  float _805;
  float _806;
  float _810;
  float4 _815;
  float _822;
  float _823;
  float _827;
  float4 _832;
  float _840;
  float _841;
  float _842;
  float _843;
  float _844;
  float _845;
  float _846;
  float _847;
  float _848;
  float _849;
  float _850;
  float _851;
  float _852;
  float _853;
  float _854;
  float _855;
  float _856;
  float _857;
  float _858;
  float _859;
  float _863;
  float _867;
  float _868;
  float _875;
  float _876;
  float4 _883;
  float _889;
  float _893;
  float _894;
  float _901;
  float4 _907;
  float _916;
  float _920;
  float _921;
  float _928;
  float4 _934;
  float _943;
  float _947;
  float _948;
  float _955;
  float4 _961;
  float _970;
  float _974;
  float _975;
  float _982;
  float4 _988;
  float _997;
  float _1001;
  float _1002;
  float _1009;
  float4 _1015;
  float _1024;
  float _1028;
  float _1029;
  float _1036;
  float4 _1042;
  float _1051;
  float _1055;
  float _1056;
  float _1063;
  float4 _1069;
  float _1078;
  float _1082;
  float _1083;
  float _1090;
  float4 _1096;
  float4 _1105;
  float4 _1109;
  float4 _1116;
  float4 _1123;
  float4 _1130;
  float4 _1137;
  float4 _1144;
  float4 _1151;
  float4 _1158;
  float _1178;
  float _1179;
  float _1180;
  float _1185;
  float _1191;
  float _1235;
  float _1237;
  float _1243;
  int _1248;
  uint _1249;
  float _1259;
  int _1263;
  uint _1264;
  float _1275;
  int _1279;
  uint _1280;
  float _1290;
  float _1291;
  float _1292;
  float _1306;
  float _1334;
  float _1337;
  float _1340;
  float _1346;
  float _1352;
  float _1353;
  float _1354;
  float _1355;
  float _1365;
  float _1386;
  float _1406;
  bool _1462;
  bool _1472;
  bool _1482;
  float4 _1500;
  float4 _1582;
  float _1634;
  float _1635;
  float _1636;
  float4 _1676;
  float4 _1771;
  uint2 _1854;
  float _1866;
  float4 _1912;
  float _1962;
  float _1966;
  float _2025;
  float _2026;
  float4 _2032;
  float _2052;
  float _2053;
  float _2054;
  float _2059;
  float _2116;
  float _2125;
  float _2134;
  float _2151;
  float _2152;
  float _2153;
  uint2 _2225;
  float _2249;
  float _2250;
  float _2275;
  float _2278;
  float _2281;
  float _2284;
  float _2306;
  _39 = screenInverseSize.x * SV_Position.x;
  _40 = screenInverseSize.y * SV_Position.y;
  if (VAR_EnableKompiraTrip > 0.0f) {
    _47 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_39, _40), 0.0f);
    _58 = ((_47.z + _47.x) + _47.y) * 0.029999999329447746f;
    _59 = _47.x * 0.029999999329447746f;
    _60 = _47.y * 0.029999999329447746f;
    _61 = floor(_58);
    _62 = frac(_58);
    _66 = (_62 * _62) * (3.0f - (_62 * 2.0f));
    _67 = _61 * 0.3183099031448364f;
    _70 = frac(_67 + 0.7099999785423279f);
    _71 = frac(_67 + 0.11299999803304672f);
    _73 = _70 * 125000.0f;
    _76 = frac((_73 * _71) * (_71 + _70));
    _78 = (_61 + 1.0f) * 0.3183099031448364f;
    _80 = frac(_78 + 0.7099999785423279f);
    _82 = _80 * 125000.0f;
    _87 = frac(_78 + 0.11299999803304672f);
    _91 = frac((_87 * _73) * (_87 + _70));
    _100 = ((frac((_82 * _71) * (_80 + _71)) - _76) * _66) + _76;
    _108 = floor(_59);
    _109 = floor(_60);
    _110 = frac(_59);
    _111 = frac(_60);
    _118 = (_110 * _110) * (3.0f - (_110 * 2.0f));
    _124 = frac((_108 * 0.3183099031448364f) + 0.7099999785423279f);
    _125 = frac((_109 * 0.3183099031448364f) + 0.11299999803304672f);
    _127 = _124 * 125000.0f;
    _130 = frac((_127 * _125) * (_125 + _124));
    _134 = frac(((_108 + 1.0f) * 0.3183099031448364f) + 0.7099999785423279f);
    _136 = _134 * 125000.0f;
    _143 = frac(((_109 + 1.0f) * 0.3183099031448364f) + 0.11299999803304672f);
    _147 = frac((_143 * _127) * (_143 + _124));
    _156 = ((frac((_136 * _125) * (_134 + _125)) - _130) * _118) + _130;
    _164 = VAR_KompiraTripRate * VAR_DestortionIntensity;
    _172 = (((screenSize.x * _164) * (((((((frac((_87 * _82) * (_87 + _80)) - _91) * _66) + _91) - _100) * 2.0f) * _66) + ((_100 * 2.0f) + -1.0f))) + SV_Position.x);
    _173 = (((screenSize.y * _164) * ((((_111 * _111) * (3.0f - (_111 * 2.0f))) * (((((frac((_143 * _136) * (_143 + _134)) - _147) * _118) + _147) - _156) * 2.0f)) + ((_156 * 2.0f) + -1.0f))) + SV_Position.y);
  } else {
    _172 = SV_Position.x;
    _173 = SV_Position.y;
  }
  [branch]
  if (film_aspect == 0.0f) {
    _181 = Kerare.x / Kerare.w;
    _182 = Kerare.y / Kerare.w;
    _183 = Kerare.z / Kerare.w;
    _187 = abs(rsqrt(dot(float3(_181, _182, _183), float3(_181, _182, _183))) * _183);
    _192 = _187 * _187;
    _220 = ((_192 * _192) * (1.0f - saturate((_187 * kerare_scale) + kerare_offset)));
  } else {
    _203 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    _205 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    _207 = sqrt(dot(float2(_205, _203), float2(_205, _203)));
    _215 = (_207 * _207) + 1.0f;
    _220 = ((1.0f / (_215 * _215)) * (1.0f - saturate(((1.0f / (_207 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  _223 = saturate(_220 + kerare_brightness) * Exposure;
  _255 = uint((float)((uint)(uint)(distortionType)));
  _260 = (LDRPPSettings_enabled != 0);
  _261 = ((cPassEnabled & 1) != 0);
  if (!(_261 && _260)) {
    _271 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((screenInverseSize.x * _172), (screenInverseSize.y * _173)));
    _278 = min(_271.x, 65000.0f) * _223;
    _279 = min(_271.y, 65000.0f) * _223;
    _280 = min(_271.z, 65000.0f) * _223;
    _283 = isfinite(max(max(_278, _279), _280));
    _527 = select(_283, _278, 1.0f);
    _528 = select(_283, _279, 1.0f);
    _529 = select(_283, _280, 1.0f);
  } else {
    if (_255 == 0) {
      _295 = (screenInverseSize.x * _172) + -0.5f;
      _296 = (screenInverseSize.y * _173) + -0.5f;
      _297 = dot(float2(_295, _296), float2(_295, _296));
      _299 = (_297 * fDistortionCoef) + 1.0f;
      _300 = _295 * fCorrectCoef;
      _302 = _296 * fCorrectCoef;
      _304 = (_300 * _299) + 0.5f;
      _305 = (_302 * _299) + 0.5f;
      if ((int)(uint((float)((uint)(uint)(aberrationEnable)))) == 0) {
        _310 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_304, _305));
        _527 = (_310.x * _223);
        _528 = (_310.y * _223);
        _529 = (_310.z * _223);
      } else {
        _329 = ((saturate((sqrt((_295 * _295) + (_296 * _296)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
        if (!((int)(uint((float)((uint)(uint)(aberrationBlurEnable)))) == 0)) {
          _339 = (fBlurNoisePower * 0.125f) * frac(frac((_173 * 0.005837149918079376f) + (_172 * 0.0671105608344078f)) * 52.98291778564453f);
          _340 = _329 * 2.0f;
          _344 = (((_339 * _340) + _297) * fDistortionCoef) + 1.0f;
          _355 = ((((_339 + 0.125f) * _340) + _297) * fDistortionCoef) + 1.0f;
          _367 = ((((_339 + 0.25f) * _340) + _297) * fDistortionCoef) + 1.0f;
          _372 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_367 * _300) + 0.5f), ((_367 * _302) + 0.5f)));
          _381 = ((((_339 + 0.375f) * _340) + _297) * fDistortionCoef) + 1.0f;
          _386 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_381 * _300) + 0.5f), ((_381 * _302) + 0.5f)));
          _395 = ((((_339 + 0.5f) * _340) + _297) * fDistortionCoef) + 1.0f;
          _406 = ((((_339 + 0.625f) * _340) + _297) * fDistortionCoef) + 1.0f;
          _411 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_406 * _300) + 0.5f), ((_406 * _302) + 0.5f)));
          _419 = ((((_339 + 0.75f) * _340) + _297) * fDistortionCoef) + 1.0f;
          _424 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_419 * _300) + 0.5f), ((_419 * _302) + 0.5f)));
          _439 = ((((_339 + 0.875f) * _340) + _297) * fDistortionCoef) + 1.0f;
          _451 = ((((_339 + 1.0f) * _340) + _297) * fDistortionCoef) + 1.0f;
          _459 = _223 * 0.3199999928474426f;
          _527 = (((((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_355 * _300) + 0.5f), ((_355 * _302) + 0.5f))))).x) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_344 * _300) + 0.5f), ((_344 * _302) + 0.5f))))).x)) + (_372.x * 0.75f)) + (_386.x * 0.375f)) * _459);
          _528 = ((_223 * 0.3636363744735718f) * ((((_411.y + _386.y) * 0.625f) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_395 * _300) + 0.5f), ((_395 * _302) + 0.5f))))).y)) + ((_424.y + _372.y) * 0.25f)));
          _529 = (((((_424.z * 0.75f) + (_411.z * 0.375f)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_439 * _300) + 0.5f), ((_439 * _302) + 0.5f))))).z)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_451 * _300) + 0.5f), ((_451 * _302) + 0.5f))))).z)) * _459);
        } else {
          _465 = _329 + _297;
          _467 = (_465 * fDistortionCoef) + 1.0f;
          _474 = ((_465 + _329) * fDistortionCoef) + 1.0f;
          _527 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_304, _305)))).x) * _223);
          _528 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_467 * _300) + 0.5f), ((_467 * _302) + 0.5f))))).y) * _223);
          _529 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_474 * _300) + 0.5f), ((_474 * _302) + 0.5f))))).z) * _223);
        }
      }
    } else {
      if (_255 == 1) {
        _498 = ((_172 * 2.0f) * screenInverseSize.x) + -1.0f;
        _502 = sqrt((_498 * _498) + 1.0f);
        _503 = 1.0f / _502;
        _511 = ((_502 * fOptimizedParam.z) * (_503 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
        _519 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_511 * _498) + 0.5f), (((_511 * (((_173 * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_503 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)));
        _527 = (_519.x * _223);
        _528 = (_519.y * _223);
        _529 = (_519.z * _223);
      } else {
        _527 = 0.0f;
        _528 = 0.0f;
        _529 = 0.0f;
      }
    }
  }
  _549 = uint(asfloat(cbRadialBlurFlags));
  if (_260 && ((cPassEnabled & 32) != 0)) {
    _561 = (float)((bool)(uint)((_549 & 2) != 0));
    _565 = ComputeResultSRV[0].computeAlpha;
    _568 = ((1.0f - _561) + (_565 * _561)) * cbRadialColor.w;
    if (!(_568 == 0.0f)) {
      _574 = screenInverseSize.x * _172;
      _575 = screenInverseSize.y * _173;
      _577 = _574 + (-0.5f - cbRadialScreenPos.x);
      _579 = _575 + (-0.5f - cbRadialScreenPos.y);
      _582 = select((_577 < 0.0f), (1.0f - _574), _574);
      _585 = select((_579 < 0.0f), (1.0f - _575), _575);
      do {
        _611 = 1.0f;
        if (!((_549 & 1) == 0)) {
          _591 = rsqrt(dot(float2(_577, _579), float2(_577, _579))) * cbRadialSharpRange;
          _598 = uint(abs(_591 * _579)) + uint(abs(_591 * _577));
          _602 = ((_598 ^ 61) ^ ((uint)(_598) >> 16)) * 9;
          _605 = (((uint)(_602) >> 4) ^ _602) * 668265261;
          _611 = (((float)((uint)((uint)(((uint)(_605) >> 15) ^ _605)))) * 2.3283064365386963e-10f);
        }
        _615 = sqrt((_577 * _577) + (_579 * _579));
        _617 = 1.0f / max(1.0f, _615);
        _618 = _611 * _582;
        _619 = cbRadialBlurPower * _617;
        _620 = _619 * -0.0011111111380159855f;
        _622 = _611 * _585;
        _626 = ((_620 * _618) + 1.0f) * _577;
        _627 = ((_620 * _622) + 1.0f) * _579;
        _629 = _619 * -0.002222222276031971f;
        _634 = ((_629 * _618) + 1.0f) * _577;
        _635 = ((_629 * _622) + 1.0f) * _579;
        _636 = _619 * -0.0033333334140479565f;
        _641 = ((_636 * _618) + 1.0f) * _577;
        _642 = ((_636 * _622) + 1.0f) * _579;
        _643 = _619 * -0.004444444552063942f;
        _648 = ((_643 * _618) + 1.0f) * _577;
        _649 = ((_643 * _622) + 1.0f) * _579;
        _650 = _619 * -0.0055555556900799274f;
        _655 = ((_650 * _618) + 1.0f) * _577;
        _656 = ((_650 * _622) + 1.0f) * _579;
        _657 = _619 * -0.006666666828095913f;
        _662 = ((_657 * _618) + 1.0f) * _577;
        _663 = ((_657 * _622) + 1.0f) * _579;
        _664 = _619 * -0.007777777966111898f;
        _669 = ((_664 * _618) + 1.0f) * _577;
        _670 = ((_664 * _622) + 1.0f) * _579;
        _671 = _619 * -0.008888889104127884f;
        _676 = ((_671 * _618) + 1.0f) * _577;
        _677 = ((_671 * _622) + 1.0f) * _579;
        _680 = _617 * ((cbRadialBlurPower * -0.009999999776482582f) * _611);
        _685 = ((_680 * _582) + 1.0f) * _577;
        _686 = ((_680 * _585) + 1.0f) * _579;
        do {
          if (_261 && (_255 == 0)) {
            _688 = _626 + cbRadialScreenPos.x;
            _689 = _627 + cbRadialScreenPos.y;
            _693 = ((dot(float2(_688, _689), float2(_688, _689)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _699 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_693 * _688) + 0.5f), ((_693 * _689) + 0.5f)), 0.0f);
            _703 = _634 + cbRadialScreenPos.x;
            _704 = _635 + cbRadialScreenPos.y;
            _708 = ((dot(float2(_703, _704), float2(_703, _704)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _713 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_708 * _703) + 0.5f), ((_708 * _704) + 0.5f)), 0.0f);
            _720 = _641 + cbRadialScreenPos.x;
            _721 = _642 + cbRadialScreenPos.y;
            _725 = ((dot(float2(_720, _721), float2(_720, _721)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _730 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_725 * _720) + 0.5f), ((_725 * _721) + 0.5f)), 0.0f);
            _737 = _648 + cbRadialScreenPos.x;
            _738 = _649 + cbRadialScreenPos.y;
            _742 = ((dot(float2(_737, _738), float2(_737, _738)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _747 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_742 * _737) + 0.5f), ((_742 * _738) + 0.5f)), 0.0f);
            _754 = _655 + cbRadialScreenPos.x;
            _755 = _656 + cbRadialScreenPos.y;
            _759 = ((dot(float2(_754, _755), float2(_754, _755)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _764 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_759 * _754) + 0.5f), ((_759 * _755) + 0.5f)), 0.0f);
            _771 = _662 + cbRadialScreenPos.x;
            _772 = _663 + cbRadialScreenPos.y;
            _776 = ((dot(float2(_771, _772), float2(_771, _772)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _781 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_776 * _771) + 0.5f), ((_776 * _772) + 0.5f)), 0.0f);
            _788 = _669 + cbRadialScreenPos.x;
            _789 = _670 + cbRadialScreenPos.y;
            _793 = ((dot(float2(_788, _789), float2(_788, _789)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _798 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_793 * _788) + 0.5f), ((_793 * _789) + 0.5f)), 0.0f);
            _805 = _676 + cbRadialScreenPos.x;
            _806 = _677 + cbRadialScreenPos.y;
            _810 = ((dot(float2(_805, _806), float2(_805, _806)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _815 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_810 * _805) + 0.5f), ((_810 * _806) + 0.5f)), 0.0f);
            _822 = _685 + cbRadialScreenPos.x;
            _823 = _686 + cbRadialScreenPos.y;
            _827 = ((dot(float2(_822, _823), float2(_822, _823)) * fDistortionCoef) + 1.0f) * fCorrectCoef;
            _832 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_827 * _822) + 0.5f), ((_827 * _823) + 0.5f)), 0.0f);
            _1166 = ((((((((_713.x + _699.x) + _730.x) + _747.x) + _764.x) + _781.x) + _798.x) + _815.x) + _832.x);
            _1167 = ((((((((_713.y + _699.y) + _730.y) + _747.y) + _764.y) + _781.y) + _798.y) + _815.y) + _832.y);
            _1168 = ((((((((_713.z + _699.z) + _730.z) + _747.z) + _764.z) + _781.z) + _798.z) + _815.z) + _832.z);
          } else {
            _840 = cbRadialScreenPos.x + 0.5f;
            _841 = _626 + _840;
            _842 = cbRadialScreenPos.y + 0.5f;
            _843 = _627 + _842;
            _844 = _634 + _840;
            _845 = _635 + _842;
            _846 = _641 + _840;
            _847 = _642 + _842;
            _848 = _648 + _840;
            _849 = _649 + _842;
            _850 = _655 + _840;
            _851 = _656 + _842;
            _852 = _662 + _840;
            _853 = _663 + _842;
            _854 = _669 + _840;
            _855 = _670 + _842;
            _856 = _676 + _840;
            _857 = _677 + _842;
            _858 = _685 + _840;
            _859 = _686 + _842;
            if (_261 && (_255 == 1)) {
              _863 = (_841 * 2.0f) + -1.0f;
              _867 = sqrt((_863 * _863) + 1.0f);
              _868 = 1.0f / _867;
              _875 = fOptimizedParam.w * 0.5f;
              _876 = ((_867 * fOptimizedParam.z) * (_868 + fOptimizedParam.x)) * _875;
              _883 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_876 * _863) + 0.5f), (((_876 * ((_843 * 2.0f) + -1.0f)) * (((_868 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _889 = (_844 * 2.0f) + -1.0f;
              _893 = sqrt((_889 * _889) + 1.0f);
              _894 = 1.0f / _893;
              _901 = ((_893 * fOptimizedParam.z) * (_894 + fOptimizedParam.x)) * _875;
              _907 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_901 * _889) + 0.5f), (((_901 * ((_845 * 2.0f) + -1.0f)) * (((_894 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _916 = (_846 * 2.0f) + -1.0f;
              _920 = sqrt((_916 * _916) + 1.0f);
              _921 = 1.0f / _920;
              _928 = ((_920 * fOptimizedParam.z) * (_921 + fOptimizedParam.x)) * _875;
              _934 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_928 * _916) + 0.5f), (((_928 * ((_847 * 2.0f) + -1.0f)) * (((_921 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _943 = (_848 * 2.0f) + -1.0f;
              _947 = sqrt((_943 * _943) + 1.0f);
              _948 = 1.0f / _947;
              _955 = ((_947 * fOptimizedParam.z) * (_948 + fOptimizedParam.x)) * _875;
              _961 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_955 * _943) + 0.5f), (((_955 * ((_849 * 2.0f) + -1.0f)) * (((_948 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _970 = (_850 * 2.0f) + -1.0f;
              _974 = sqrt((_970 * _970) + 1.0f);
              _975 = 1.0f / _974;
              _982 = ((_974 * fOptimizedParam.z) * (_975 + fOptimizedParam.x)) * _875;
              _988 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_982 * _970) + 0.5f), (((_982 * ((_851 * 2.0f) + -1.0f)) * (((_975 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _997 = (_852 * 2.0f) + -1.0f;
              _1001 = sqrt((_997 * _997) + 1.0f);
              _1002 = 1.0f / _1001;
              _1009 = ((_1001 * fOptimizedParam.z) * (_1002 + fOptimizedParam.x)) * _875;
              _1015 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1009 * _997) + 0.5f), (((_1009 * ((_853 * 2.0f) + -1.0f)) * (((_1002 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1024 = (_854 * 2.0f) + -1.0f;
              _1028 = sqrt((_1024 * _1024) + 1.0f);
              _1029 = 1.0f / _1028;
              _1036 = ((_1028 * fOptimizedParam.z) * (_1029 + fOptimizedParam.x)) * _875;
              _1042 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1036 * _1024) + 0.5f), (((_1036 * ((_855 * 2.0f) + -1.0f)) * (((_1029 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1051 = (_856 * 2.0f) + -1.0f;
              _1055 = sqrt((_1051 * _1051) + 1.0f);
              _1056 = 1.0f / _1055;
              _1063 = ((_1055 * fOptimizedParam.z) * (_1056 + fOptimizedParam.x)) * _875;
              _1069 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1063 * _1051) + 0.5f), (((_1063 * ((_857 * 2.0f) + -1.0f)) * (((_1056 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1078 = (_858 * 2.0f) + -1.0f;
              _1082 = sqrt((_1078 * _1078) + 1.0f);
              _1083 = 1.0f / _1082;
              _1090 = ((_1082 * fOptimizedParam.z) * (_1083 + fOptimizedParam.x)) * _875;
              _1096 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1090 * _1078) + 0.5f), (((_1090 * ((_859 * 2.0f) + -1.0f)) * (((_1083 + -1.0f) * fOptimizedParam.y) + 1.0f)) + 0.5f)), 0.0f);
              _1166 = ((((((((_907.x + _883.x) + _934.x) + _961.x) + _988.x) + _1015.x) + _1042.x) + _1069.x) + _1096.x);
              _1167 = ((((((((_907.y + _883.y) + _934.y) + _961.y) + _988.y) + _1015.y) + _1042.y) + _1069.y) + _1096.y);
              _1168 = ((((((((_907.z + _883.z) + _934.z) + _961.z) + _988.z) + _1015.z) + _1042.z) + _1069.z) + _1096.z);
            } else {
              _1105 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_841, _843), 0.0f);
              _1109 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_844, _845), 0.0f);
              _1116 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_846, _847), 0.0f);
              _1123 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_848, _849), 0.0f);
              _1130 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_850, _851), 0.0f);
              _1137 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_852, _853), 0.0f);
              _1144 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_854, _855), 0.0f);
              _1151 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_856, _857), 0.0f);
              _1158 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_858, _859), 0.0f);
              _1166 = ((((((((_1109.x + _1105.x) + _1116.x) + _1123.x) + _1130.x) + _1137.x) + _1144.x) + _1151.x) + _1158.x);
              _1167 = ((((((((_1109.y + _1105.y) + _1116.y) + _1123.y) + _1130.y) + _1137.y) + _1144.y) + _1151.y) + _1158.y);
              _1168 = ((((((((_1109.z + _1105.z) + _1116.z) + _1123.z) + _1130.z) + _1137.z) + _1144.z) + _1151.z) + _1158.z);
            }
          }
          _1178 = (cbRadialColor.z * (_529 + (_223 * _1168))) * 0.10000000149011612f;
          _1179 = (cbRadialColor.y * (_528 + (_223 * _1167))) * 0.10000000149011612f;
          _1180 = (cbRadialColor.x * (_527 + (_223 * _1166))) * 0.10000000149011612f;
          do {
            _1202 = _1180;
            _1203 = _1179;
            _1204 = _1178;
            if (cbRadialMaskRate.x > 0.0f) {
              _1185 = saturate((_615 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              _1191 = (((_1185 * _1185) * cbRadialMaskRate.x) * (3.0f - (_1185 * 2.0f))) + cbRadialMaskRate.y;
              _1202 = ((_1191 * (_1180 - _527)) + _527);
              _1203 = ((_1191 * (_1179 - _528)) + _528);
              _1204 = ((_1191 * (_1178 - _529)) + _529);
            }
            _1215 = (lerp(_527, _1202, _568));
            _1216 = (lerp(_528, _1203, _568));
            _1217 = (lerp(_529, _1204, _568));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1215 = _527;
      _1216 = _528;
      _1217 = _529;
    }
  } else {
    _1215 = _527;
    _1216 = _528;
    _1217 = _529;
  }
  if (_260 && ((cPassEnabled & 2) != 0)) {
    _1235 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    _1237 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    _1243 = frac(frac((_1237 * 0.005837149918079376f) + (_1235 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      _1257 = 0.0f;
      if (_1243 < fNoiseDensity) {
        _1248 = (int)(uint(_1237 * _1235)) ^ 12345391;
        _1249 = _1248 * 3635641;
        _1257 = (((float)((uint)((uint)((((uint)(_1249) >> 26) | ((int)(_1248 * 232681024))) ^ _1249)))) * 2.3283064365386963e-10f);
      }
      _1259 = frac(_1243 * 757.4846801757812f);
      do {
        _1273 = 0.0f;
        if (_1259 < fNoiseDensity) {
          _1263 = asint(_1259) ^ 12345391;
          _1264 = _1263 * 3635641;
          _1273 = ((((float)((uint)((uint)((((uint)(_1264) >> 26) | ((int)(_1263 * 232681024))) ^ _1264)))) * 2.3283064365386963e-10f) + -0.5f);
        }
        _1275 = frac(_1259 * 757.4846801757812f);
        do {
          _1289 = 0.0f;
          if (_1275 < fNoiseDensity) {
            _1279 = asint(_1275) ^ 12345391;
            _1280 = _1279 * 3635641;
            _1289 = ((((float)((uint)((uint)((((uint)(_1280) >> 26) | ((int)(_1279 * 232681024))) ^ _1280)))) * 2.3283064365386963e-10f) + -0.5f);
          }
          _1290 = _1257 * CUSTOM_NOISE * fNoisePower.x;
          _1291 = _1289 * CUSTOM_NOISE * fNoisePower.y;
          _1292 = _1273 * CUSTOM_NOISE * fNoisePower.y;
          _1306 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1215), saturate(_1216), saturate(_1217)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1317 = ((_1306 * (mad(_1292, 1.4019999504089355f, _1290) - _1215)) + _1215);
          _1318 = ((_1306 * (mad(_1292, -0.7139999866485596f, mad(_1291, -0.3440000116825104f, _1290)) - _1216)) + _1216);
          _1319 = ((_1306 * (mad(_1291, 1.7719999551773071f, _1290) - _1217)) + _1217);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1317 = _1215;
    _1318 = _1216;
    _1319 = _1217;
  }
  _1334 = mad(_1319, (fOCIOTransformMatrix[2].x), mad(_1318, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1317)));
  _1337 = mad(_1319, (fOCIOTransformMatrix[2].y), mad(_1318, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1317)));
  _1340 = mad(_1319, (fOCIOTransformMatrix[2].z), mad(_1318, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1317)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    _1346 = max(max(_1334, _1337), _1340);
    if (!(_1346 == 0.0f)) {
      _1352 = abs(_1346);
      _1353 = (_1346 - _1334) / _1352;
      _1354 = (_1346 - _1337) / _1352;
      _1355 = (_1346 - _1340) / _1352;
      do {
        _1377 = _1353;
        if (!(!(_1353 >= cbControlRGCParam.CyanThreshold))) {
          _1365 = _1353 - cbControlRGCParam.CyanThreshold;
          _1377 = ((_1365 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1365) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        }
        do {
          _1398 = _1354;
          if (!(!(_1354 >= cbControlRGCParam.MagentaThreshold))) {
            _1386 = _1354 - cbControlRGCParam.MagentaThreshold;
            _1398 = ((_1386 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1386) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          }
          do {
            _1418 = _1355;
            if (!(!(_1355 >= cbControlRGCParam.YellowThreshold))) {
              _1406 = _1355 - cbControlRGCParam.YellowThreshold;
              _1418 = ((_1406 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1406) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            }
            _1426 = (_1346 - (_1377 * _1352));
            _1427 = (_1346 - (_1398 * _1352));
            _1428 = (_1346 - (_1418 * _1352));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1426 = _1334;
      _1427 = _1337;
      _1428 = _1340;
    }
  } else {
    _1426 = _1334;
    _1427 = _1337;
    _1428 = _1340;
  }
#if 1
  ApplyColorCorrectTexturePass(
      _260 && ((cPassEnabled & 4) != 0),
      _1426, _1427, _1428,
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
      _1843, _1844, _1845);
#else
  if (_260 && ((cPassEnabled & 4) != 0)) {
    _1462 = !(_1426 <= 0.0078125f);
    do {
      if (!(_1462)) {
        _1471 = ((_1426 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _1471 = ((log2(_1426) + 9.720000267028809f) * 0.05707762390375137f);
      }
      _1472 = !(_1427 <= 0.0078125f);
      do {
        if (!(_1472)) {
          _1481 = ((_1427 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _1481 = ((log2(_1427) + 9.720000267028809f) * 0.05707762390375137f);
        }
        _1482 = !(_1428 <= 0.0078125f);
        do {
          if (!(_1482)) {
            _1491 = ((_1428 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _1491 = ((log2(_1428) + 9.720000267028809f) * 0.05707762390375137f);
          }
          _1500 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_1471 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1481 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1491 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_1500.x < 0.155251145362854f) {
              _1517 = ((_1500.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((_1500.x >= 0.155251145362854f) && (_1500.x < 1.4679962396621704f)) {
                _1517 = exp2((_1500.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _1517 = 65504.0f;
              }
            }
            do {
              if (_1500.y < 0.155251145362854f) {
                _1531 = ((_1500.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_1500.y >= 0.155251145362854f) && (_1500.y < 1.4679962396621704f)) {
                  _1531 = exp2((_1500.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _1531 = 65504.0f;
                }
              }
              do {
                if (_1500.z < 0.155251145362854f) {
                  _1545 = ((_1500.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_1500.z >= 0.155251145362854f) && (_1500.z < 1.4679962396621704f)) {
                    _1545 = exp2((_1500.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _1545 = 65504.0f;
                  }
                }
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!(_1462)) {
                        _1556 = ((_1426 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _1556 = ((log2(_1426) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(_1472)) {
                          _1565 = ((_1427 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1565 = ((log2(_1427) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(_1482)) {
                            _1574 = ((_1428 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1574 = ((log2(_1428) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          _1582 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_1556 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1565 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1574 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_1582.x < 0.155251145362854f) {
                              _1599 = ((_1582.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((_1582.x >= 0.155251145362854f) && (_1582.x < 1.4679962396621704f)) {
                                _1599 = exp2((_1582.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _1599 = 65504.0f;
                              }
                            }
                            do {
                              if (_1582.y < 0.155251145362854f) {
                                _1613 = ((_1582.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_1582.y >= 0.155251145362854f) && (_1582.y < 1.4679962396621704f)) {
                                  _1613 = exp2((_1582.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1613 = 65504.0f;
                                }
                              }
                              do {
                                if (_1582.z < 0.155251145362854f) {
                                  _1627 = ((_1582.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_1582.z >= 0.155251145362854f) && (_1582.z < 1.4679962396621704f)) {
                                    _1627 = exp2((_1582.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1627 = 65504.0f;
                                  }
                                }
                                _1634 = ((_1599 - _1517) * fTextureBlendRate) + _1517;
                                _1635 = ((_1613 - _1531) * fTextureBlendRate) + _1531;
                                _1636 = ((_1627 - _1545) * fTextureBlendRate) + _1545;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_1634 <= 0.0078125f))) {
                                      _1648 = ((_1634 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _1648 = ((log2(_1634) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_1635 <= 0.0078125f))) {
                                        _1658 = ((_1635 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _1658 = ((log2(_1635) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_1636 <= 0.0078125f))) {
                                          _1668 = ((_1636 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _1668 = ((log2(_1636) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        _1676 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1648 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1658 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1668 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_1676.x < 0.155251145362854f) {
                                            _1693 = ((_1676.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((_1676.x >= 0.155251145362854f) && (_1676.x < 1.4679962396621704f)) {
                                              _1693 = exp2((_1676.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _1693 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_1676.y < 0.155251145362854f) {
                                              _1707 = ((_1676.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((_1676.y >= 0.155251145362854f) && (_1676.y < 1.4679962396621704f)) {
                                                _1707 = exp2((_1676.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _1707 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_1676.z < 0.155251145362854f) {
                                                _1721 = ((_1676.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((_1676.z >= 0.155251145362854f) && (_1676.z < 1.4679962396621704f)) {
                                                  _1721 = exp2((_1676.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _1721 = 65504.0f;
                                                }
                                              }
                                              _1827 = (lerp(_1634, _1693, fTextureBlendRate2));
                                              _1828 = (lerp(_1635, _1707, fTextureBlendRate2));
                                              _1829 = (lerp(_1636, _1721, fTextureBlendRate2));
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _1827 = _1634;
                                  _1828 = _1635;
                                  _1829 = _1636;
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
                        if (!(!(_1517 <= 0.0078125f))) {
                          _1743 = ((_1517 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _1743 = ((log2(_1517) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_1531 <= 0.0078125f))) {
                            _1753 = ((_1531 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _1753 = ((log2(_1531) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_1545 <= 0.0078125f))) {
                              _1763 = ((_1545 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _1763 = ((log2(_1545) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            _1771 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_1743 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1753 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1763 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_1771.x < 0.155251145362854f) {
                                _1788 = ((_1771.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_1771.x >= 0.155251145362854f) && (_1771.x < 1.4679962396621704f)) {
                                  _1788 = exp2((_1771.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _1788 = 65504.0f;
                                }
                              }
                              do {
                                if (_1771.y < 0.155251145362854f) {
                                  _1802 = ((_1771.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_1771.y >= 0.155251145362854f) && (_1771.y < 1.4679962396621704f)) {
                                    _1802 = exp2((_1771.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _1802 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_1771.z < 0.155251145362854f) {
                                    _1816 = ((_1771.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((_1771.z >= 0.155251145362854f) && (_1771.z < 1.4679962396621704f)) {
                                      _1816 = exp2((_1771.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _1816 = 65504.0f;
                                    }
                                  }
                                  _1827 = (lerp(_1517, _1788, fTextureBlendRate2));
                                  _1828 = (lerp(_1531, _1802, fTextureBlendRate2));
                                  _1829 = (lerp(_1545, _1816, fTextureBlendRate2));
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _1827 = _1517;
                      _1828 = _1531;
                      _1829 = _1545;
                    }
                  }
                  _1843 = (mad(_1829, (fColorMatrix[2].x), mad(_1828, (fColorMatrix[1].x), (_1827 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _1844 = (mad(_1829, (fColorMatrix[2].y), mad(_1828, (fColorMatrix[1].y), (_1827 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _1845 = (mad(_1829, (fColorMatrix[2].z), mad(_1828, (fColorMatrix[1].z), (_1827 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1843 = _1426;
    _1844 = _1427;
    _1845 = _1428;
  }
#endif
  if (VAR_EnableCustomColorCorrect > 0.0f) {
    uint2 _1854; RE_POSTPROCESS_Stencil.GetDimensions(_1854.x, _1854.y);
    _1866 = (float)((uint)((uint)((uint)((uint)(((uint2)(RE_POSTPROCESS_Stencil.Load(int3(int((screenInverseSize.x * SV_Position.x) * float((int)((int)(_1854.x)))), int((screenInverseSize.y * SV_Position.y) * float((int)((int)(_1854.y)))), 0)))).y)) >> 4)));
    if ((VAR_ExColorCorrectTargetStencilID == _1866) || (VAR_ExColorCorrectTargetStencilID_2 == _1866)) {
      do {
        if (!(!(_1426 <= 0.0078125f))) {
          _1883 = ((_1426 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _1883 = ((log2(_1426) + 9.720000267028809f) * 0.05707762390375137f);
        }
        do {
          if (!(!(_1427 <= 0.0078125f))) {
            _1893 = ((_1427 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _1893 = ((log2(_1427) + 9.720000267028809f) * 0.05707762390375137f);
          }
          do {
            if (!(!(_1428 <= 0.0078125f))) {
              _1903 = ((_1428 * 10.540237426757812f) + 0.072905533015728f);
            } else {
              _1903 = ((log2(_1428) + 9.720000267028809f) * 0.05707762390375137f);
            }
            _1912 = ExColorCube.SampleLevel(TrilinearClamp, float3(((_1883 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1893 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_1903 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
            do {
              if (_1912.x < 0.155251145362854f) {
                _1929 = ((_1912.x + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_1912.x >= 0.155251145362854f) && (_1912.x < 1.4679962396621704f)) {
                  _1929 = exp2((_1912.x * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _1929 = 65504.0f;
                }
              }
              do {
                if (_1912.y < 0.155251145362854f) {
                  _1943 = ((_1912.y + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_1912.y >= 0.155251145362854f) && (_1912.y < 1.4679962396621704f)) {
                    _1943 = exp2((_1912.y * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _1943 = 65504.0f;
                  }
                }
                do {
                  if (_1912.z < 0.155251145362854f) {
                    _1957 = ((_1912.z + -0.072905533015728f) * 0.09487452358007431f);
                  } else {
                    if ((_1912.z >= 0.155251145362854f) && (_1912.z < 1.4679962396621704f)) {
                      _1957 = exp2((_1912.z * 17.520000457763672f) + -9.720000267028809f);
                    } else {
                      _1957 = 65504.0f;
                    }
                  }
                  do {
                    _1970 = 0.0f;
                    if (VAR_UseEffectMask > 0.0f) {
                      _1962 = RE_POSTPROCESS_EffectMask.Sample(AutomaticWrap, float2(_39, _40));
                      if (VAR_EnableEffectMaskPow > 0.0f) {
                        _1966 = 1.0f - _1962.x;
                        _1970 = (1.0f - (_1966 * _1966));
                      } else {
                        _1970 = _1962.x;
                      }
                    }
                    _1981 = ((_1970 * (_1843 - _1929)) + _1929);
                    _1982 = ((_1970 * (_1844 - _1943)) + _1943);
                    _1983 = ((_1970 * (_1845 - _1957)) + _1957);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1981 = _1843;
      _1982 = _1844;
      _1983 = _1845;
    }
  } else {
    _1981 = _1843;
    _1982 = _1844;
    _1983 = _1845;
  }
  if (_260 && ((cPassEnabled & 8) != 0)) {
    _2019 = saturate(((cvdR.x * _1981) + (cvdR.y * _1982)) + (cvdR.z * _1983));
    _2020 = saturate(((cvdG.x * _1981) + (cvdG.y * _1982)) + (cvdG.z * _1983));
    _2021 = saturate(((cvdB.x * _1981) + (cvdB.y * _1982)) + (cvdB.z * _1983));
  } else {
    _2019 = _1981;
    _2020 = _1982;
    _2021 = _1983;
  }
  _2025 = screenInverseSize.x * SV_Position.x;
  _2026 = screenInverseSize.y * SV_Position.y;
  _2032 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2025, _2026), 0.0f);
  if (_260 && (asint(((float)((bool)(uint)((cPassEnabled & 16) != 0)))) != 0)) {
    _2052 = ColorParam.x * _2032.x;
    _2053 = ColorParam.y * _2032.y;
    _2054 = ColorParam.z * _2032.z;
    _2059 = (ColorParam.w * _2032.w) * saturate((((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2025, _2026), 0.0f)).x) * Levels_Rate) + Levels_Range);
    do {
      if (_2052 < 0.5f) {
        _2071 = ((_2019 * 2.0f) * _2052);
      } else {
        _2071 = (1.0f - (((1.0f - _2019) * 2.0f) * (1.0f - _2052)));
      }
      do {
        if (_2053 < 0.5f) {
          _2083 = ((_2020 * 2.0f) * _2053);
        } else {
          _2083 = (1.0f - (((1.0f - _2020) * 2.0f) * (1.0f - _2053)));
        }
        do {
          if (_2054 < 0.5f) {
            _2095 = ((_2021 * 2.0f) * _2054);
          } else {
            _2095 = (1.0f - (((1.0f - _2021) * 2.0f) * (1.0f - _2054)));
          }
          _2106 = (lerp(_2019, _2071, _2059));
          _2107 = (lerp(_2020, _2083, _2059));
          _2108 = (lerp(_2021, _2095, _2059));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2106 = _2019;
    _2107 = _2020;
    _2108 = _2021;
  }
#if 1
  ApplyCapcomExponentialToneMap(_2106, _2107, _2108,
                                _2213, _2214, _2215);
#else
  if (tonemapParam_isHDRMode == 0.0f) {
    _2116 = invLinearBegin * _2106;
    do {
      _2124 = 1.0f;
      if (!(_2106 >= linearBegin)) {
        _2124 = ((_2116 * _2116) * (3.0f - (_2116 * 2.0f)));
      }
      _2125 = invLinearBegin * _2107;
      do {
        _2133 = 1.0f;
        if (!(_2107 >= linearBegin)) {
          _2133 = ((_2125 * _2125) * (3.0f - (_2125 * 2.0f)));
        }
        _2134 = invLinearBegin * _2108;
        do {
          _2142 = 1.0f;
          if (!(_2108 >= linearBegin)) {
            _2142 = ((_2134 * _2134) * (3.0f - (_2134 * 2.0f)));
          }
          _2151 = select((_2106 < linearStart), 0.0f, 1.0f);
          _2152 = select((_2107 < linearStart), 0.0f, 1.0f);
          _2153 = select((_2108 < linearStart), 0.0f, 1.0f);
          _2213 = (((((1.0f - _2124) * linearBegin) * (pow(_2116, toe))) + ((_2124 - _2151) * ((contrast * _2106) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2106) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2151));
          _2214 = (((((1.0f - _2133) * linearBegin) * (pow(_2125, toe))) + ((_2133 - _2152) * ((contrast * _2107) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2107) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2152));
          _2215 = (((((1.0f - _2142) * linearBegin) * (pow(_2134, toe))) + ((_2142 - _2153) * ((contrast * _2108) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2108) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2153));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2213 = _2106;
    _2214 = _2107;
    _2215 = _2108;
  }
#endif
  if (VAR_EnableHighlightTarget > 0.0f) {
    uint2 _2225; RE_POSTPROCESS_Stencil.GetDimensions(_2225.x, _2225.y);
    if (VAR_TargetStencilID == ((float)((uint)((uint)((uint)((uint)(((uint2)(RE_POSTPROCESS_Stencil.Load(int3(int(float((int)((int)(_2225.x))) * _2025), int(float((int)((int)(_2225.y))) * _2026), 0)))).y)) >> 4))))) {
      _2267 = (VAR_TargetColorMod.x * _2213);
      _2268 = (VAR_TargetColorMod.y * _2214);
      _2269 = (VAR_TargetColorMod.z * _2215);
    } else {
      _2249 = _2215 * 0.11447799950838089f;
      _2250 = (_2214 * 0.5866109728813171f) + (_2213 * 0.298911988735199f);
      _2267 = (((((_2250 - _2213) + _2249) * VAR_GrayScaleRatio) + _2213) * VAR_GrayScaleCoef);
      _2268 = (((((_2250 - _2214) + _2249) * VAR_GrayScaleRatio) + _2214) * VAR_GrayScaleCoef);
      _2269 = (((((_2250 - _2215) + _2249) * VAR_GrayScaleRatio) + _2215) * VAR_GrayScaleCoef);
    }
  } else {
    _2267 = _2213;
    _2268 = _2214;
    _2269 = _2215;
  }
  if (VAR_EnableColorSupport > 0.0f) {
    _2275 = max(_2267, max(_2268, _2269));
    _2278 = _2275 - min(_2267, min(_2268, _2269));
    _2281 = select((!(_2275 == 0.0f)), (_2278 / _2275), 0.0f);
    _2284 = select((_2278 == 0.0f), 0.0f, (1.0f / _2278));
    do {
      if (_2267 == _2275) {
        _2300 = (_2284 * (_2268 - _2269));
      } else {
        if (_2268 == _2275) {
          _2300 = ((_2284 * (_2269 - _2267)) + 2.0f);
        } else {
          _2300 = ((_2284 * (_2267 - _2268)) + 4.0f);
        }
      }
      _2306 = (frac(_2300 * 0.1666666716337204f) * VAR_ColorSupportScale) + VAR_ColorSupportOffset;
      _2353 = (((((((saturate((abs((frac(_2306) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _2281) + 1.0f) * _2275) - _2267) * VAR_ColorSupportIntensity) + _2267);
      _2354 = (((((((saturate((abs((frac(_2306 + 0.6666666865348816f) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _2281) + 1.0f) * _2275) - _2268) * VAR_ColorSupportIntensity) + _2268);
      _2355 = (((((((saturate((abs((frac(_2306 + 0.3333333432674408f) * 2.0f) + -1.0f) * 3.0f) + -1.0f) + -1.0f) * _2281) + 1.0f) * _2275) - _2269) * VAR_ColorSupportIntensity) + _2269);
    } while (false);
  } else {
    _2353 = _2267;
    _2354 = _2268;
    _2355 = _2269;
  }
  SV_Target.x = _2353;
  SV_Target.y = _2354;
  SV_Target.z = _2355;
  SV_Target.w = 1.0f;
  return SV_Target;
}
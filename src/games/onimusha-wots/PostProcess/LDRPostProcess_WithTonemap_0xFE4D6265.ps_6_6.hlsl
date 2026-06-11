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


Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> RE_POSTPROCESS_Color : register(t1);

Texture2D<float> tFilterTempMap1 : register(t2);

Texture3D<float> tVolumeMap : register(t3);

Texture2D<float2> HazeNoiseResult : register(t4);

StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t5);

Texture3D<float4> tTextureMap0 : register(t6);

Texture3D<float4> tTextureMap1 : register(t7);

Texture3D<float4> tTextureMap2 : register(t8);

Texture2D<float4> ImagePlameBase : register(t9);

Texture2D<float> ImagePlameAlpha : register(t10);

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

SamplerState PointClamp : register(s1, space32);

SamplerState BilinearWrap : register(s4, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  bool _31;
  bool _37;
  bool _43;
  float _188;
  float _189;
  float _210;
  float _329;
  float _330;
  float _338;
  float _339;
  float _659;
  float _660;
  float _681;
  float _800;
  float _801;
  float _809;
  float _810;
  float _938;
  float _939;
  float _962;
  float _1081;
  float _1082;
  float _1088;
  float _1089;
  float _1099;
  float _1100;
  float _1101;
  float _1102;
  float _1103;
  float _1104;
  float _1105;
  float _1106;
  float _1107;
  float _1180;
  float _1735;
  float _1736;
  float _1737;
  float _1771;
  float _1772;
  float _1773;
  float _1784;
  float _1785;
  float _1786;
  float _1825;
  float _1841;
  float _1857;
  float _1885;
  float _1886;
  float _1887;
  float _1945;
  float _1966;
  float _1986;
  float _1994;
  float _1995;
  float _1996;
  float _2031;
  float _2041;
  float _2051;
  float _2077;
  float _2091;
  float _2105;
  float _2116;
  float _2125;
  float _2134;
  float _2159;
  float _2173;
  float _2187;
  float _2208;
  float _2218;
  float _2228;
  float _2253;
  float _2267;
  float _2281;
  float _2303;
  float _2313;
  float _2323;
  float _2348;
  float _2362;
  float _2376;
  float _2387;
  float _2388;
  float _2389;
  float _2403;
  float _2404;
  float _2405;
  float _2449;
  float _2450;
  float _2451;
  float _2494;
  float _2506;
  float _2518;
  float _2529;
  float _2530;
  float _2531;
  float _2547;
  float _2556;
  float _2565;
  float _2636;
  float _2637;
  float _2638;
  bool _45;
  float _62;
  float _63;
  float _64;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _72;
  float2 _82;
  bool _94;
  float _98;
  float _105;
  float _113;
  float _114;
  float _151;
  float _153;
  float _161;
  float _162;
  float _163;
  float _203;
  float _211;
  float _218;
  float _241;
  float _242;
  float _243;
  float _251;
  float _252;
  float _253;
  float _261;
  float _262;
  float _263;
  float _271;
  float _272;
  float _273;
  float _281;
  float _282;
  float _283;
  float _315;
  float _316;
  float4 _342;
  float _362;
  float _374;
  float _375;
  float _379;
  float _390;
  float _402;
  float4 _407;
  float _416;
  float4 _421;
  float _430;
  float _441;
  float4 _446;
  float _454;
  float4 _459;
  float _474;
  float _486;
  float _498;
  float _500;
  float _507;
  float _525;
  float _527;
  float _529;
  float _533;
  float _534;
  float _542;
  float _543;
  float _545;
  float _546;
  float _547;
  float2 _555;
  bool _567;
  float _571;
  float _578;
  float _584;
  float _585;
  float _622;
  float _624;
  float _632;
  float _633;
  float _634;
  float _674;
  float _682;
  float _689;
  float _712;
  float _713;
  float _714;
  float _722;
  float _723;
  float _724;
  float _732;
  float _733;
  float _734;
  float _742;
  float _743;
  float _744;
  float _752;
  float _753;
  float _754;
  float _786;
  float _787;
  float4 _813;
  float _818;
  float _819;
  float4 _823;
  float2 _834;
  bool _844;
  float _848;
  float _855;
  float _863;
  float _864;
  float _901;
  float _903;
  float _911;
  float _912;
  float _913;
  float _955;
  float _963;
  float _970;
  float _993;
  float _994;
  float _995;
  float _1003;
  float _1004;
  float _1005;
  float _1013;
  float _1014;
  float _1015;
  float _1023;
  float _1024;
  float _1025;
  float _1033;
  float _1034;
  float _1035;
  float _1067;
  float _1068;
  float4 _1094;
  float _1108;
  float _1109;
  float _1110;
  float _1133;
  float _1137;
  float _1140;
  float _1143;
  float _1144;
  float _1146;
  float _1148;
  float _1151;
  float _1154;
  float _1160;
  uint _1167;
  uint _1171;
  uint _1174;
  float _1184;
  float _1186;
  float _1187;
  float _1188;
  float _1189;
  float _1191;
  float _1195;
  float _1196;
  float _1198;
  float _1203;
  float _1204;
  float _1205;
  float _1210;
  float _1211;
  float _1212;
  float _1217;
  float _1218;
  float _1219;
  float _1224;
  float _1225;
  float _1226;
  float _1231;
  float _1232;
  float _1233;
  float _1238;
  float _1239;
  float _1240;
  float _1245;
  float _1246;
  float _1249;
  float _1254;
  float _1255;
  float _1257;
  float _1258;
  float _1262;
  float4 _1268;
  float _1272;
  float _1273;
  float _1277;
  float4 _1282;
  float _1289;
  float _1290;
  float _1294;
  float4 _1299;
  float _1306;
  float _1307;
  float _1311;
  float4 _1316;
  float _1323;
  float _1324;
  float _1328;
  float4 _1333;
  float _1340;
  float _1341;
  float _1345;
  float4 _1350;
  float _1357;
  float _1358;
  float _1362;
  float4 _1367;
  float _1374;
  float _1375;
  float _1379;
  float4 _1384;
  float _1391;
  float _1392;
  float _1396;
  float4 _1401;
  float _1409;
  float _1410;
  float _1411;
  float _1412;
  float _1413;
  float _1414;
  float _1415;
  float _1416;
  float _1417;
  float _1418;
  float _1419;
  float _1420;
  float _1421;
  float _1422;
  float _1423;
  float _1424;
  float _1425;
  float _1426;
  float _1427;
  float _1428;
  float _1432;
  float _1436;
  float _1437;
  float _1444;
  float _1445;
  float4 _1452;
  float _1458;
  float _1462;
  float _1463;
  float _1470;
  float4 _1476;
  float _1485;
  float _1489;
  float _1490;
  float _1497;
  float4 _1503;
  float _1512;
  float _1516;
  float _1517;
  float _1524;
  float4 _1530;
  float _1539;
  float _1543;
  float _1544;
  float _1551;
  float4 _1557;
  float _1566;
  float _1570;
  float _1571;
  float _1578;
  float4 _1584;
  float _1593;
  float _1597;
  float _1598;
  float _1605;
  float4 _1611;
  float _1620;
  float _1624;
  float _1625;
  float _1632;
  float4 _1638;
  float _1647;
  float _1651;
  float _1652;
  float _1659;
  float4 _1665;
  float4 _1674;
  float4 _1678;
  float4 _1685;
  float4 _1692;
  float4 _1699;
  float4 _1706;
  float4 _1713;
  float4 _1720;
  float4 _1727;
  float _1747;
  float _1748;
  float _1749;
  float _1754;
  float _1760;
  float _1803;
  float _1805;
  float _1811;
  int _1816;
  uint _1817;
  float _1827;
  int _1831;
  uint _1832;
  float _1843;
  int _1847;
  uint _1848;
  float _1858;
  float _1859;
  float _1860;
  float _1874;
  float _1902;
  float _1905;
  float _1908;
  float _1914;
  float _1920;
  float _1921;
  float _1922;
  float _1923;
  float _1933;
  float _1954;
  float _1974;
  bool _2022;
  bool _2032;
  bool _2042;
  float4 _2060;
  float4 _2142;
  float _2194;
  float _2195;
  float _2196;
  float4 _2236;
  float4 _2331;
  float _2406;
  float _2407;
  float _2408;
  bool _2411;
  float _2412;
  float _2413;
  float _2414;
  float _2463;
  float _2464;
  float4 _2467;
  float _2472;
  float _2473;
  float _2474;
  float _2482;
  float _2539;
  float _2548;
  float _2557;
  float _2574;
  float _2575;
  float _2576;
  _31 = ((cPassEnabled & 1) == 0);
  if (!(_31)) {
    _37 = (distortionType == 0);
  } else {
    _37 = false;
  }
  if (!(_31)) {
    _43 = (distortionType == 1);
  } else {
    _43 = false;
  }
  _45 = ((cPassEnabled & 64) != 0);
  if (_37) {
    _62 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    _63 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    _64 = dot(float2(_62, _63), float2(_62, _63));
    _66 = (_64 * fDistortionCoef) + 1.0f;
    _67 = fCorrectCoef * _62;
    _68 = _66 * _67;
    _69 = fCorrectCoef * _63;
    _70 = _66 * _69;
    _71 = _68 + 0.5f;
    _72 = _70 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        _338 = _71;
        _339 = _72;
        if (_45) {
          if (!(fHazeFilterReductionResolution == 0)) {
            _82 = HazeNoiseResult.Sample(BilinearWrap, float2(_71, _72));
            _338 = ((fHazeFilterScale * _82.x) + _71);
            _339 = ((fHazeFilterScale * _82.y) + _72);
          } else {
            _94 = ((fHazeFilterAttribute & 2) != 0);
            _98 = tFilterTempMap1.Sample(BilinearWrap, float2(_71, _72));
            do {
              if (_94) {
                _105 = ReadonlyDepth.SampleLevel(PointClamp, float2(_71, _72), 0.0f);
                _113 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _71) + -1.0f;
                _114 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _72);
                _151 = 1.0f / (mad(_105.x, (viewProjInvMat[2].w), mad(_114, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _113))) + (viewProjInvMat[3].w));
                _153 = _151 * (mad(_105.x, (viewProjInvMat[2].y), mad(_114, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _113))) + (viewProjInvMat[3].y));
                _161 = (_151 * (mad(_105.x, (viewProjInvMat[2].x), mad(_114, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _113))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _162 = _153 - (transposeViewInvMat[1].w);
                _163 = (_151 * (mad(_105.x, (viewProjInvMat[2].z), mad(_114, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _113))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _188 = saturate(max(((sqrt(((_162 * _162) + (_161 * _161)) + (_163 * _163)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_153 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _98.x);
                _189 = _105.x;
              } else {
                _188 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _98.x), _98.x);
                _189 = 0.0f;
              }
              do {
                _210 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _203 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _210 = (1.0f - saturate(max((_203 * min(max((abs(_68) - fHazeFilterBorder), 0.0f), 1.0f)), (_203 * min(max((abs(_70) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _211 = _210 * _188;
                do {
                  _329 = 0.0f;
                  _330 = 0.0f;
                  if (!(_211 <= 9.999999747378752e-06f)) {
                    _218 = -0.0f - _72;
                    _241 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_218, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _71))) * fHazeFilterUVWOffset.w;
                    _242 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_218, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _71))) * fHazeFilterUVWOffset.w;
                    _243 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_218, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _71))) * fHazeFilterUVWOffset.w;
                    _251 = _241 * 2.0f;
                    _252 = _242 * 2.0f;
                    _253 = _243 * 2.0f;
                    _261 = _241 * 4.0f;
                    _262 = _242 * 4.0f;
                    _263 = _243 * 4.0f;
                    _271 = _241 * 8.0f;
                    _272 = _242 * 8.0f;
                    _273 = _243 * 8.0f;
                    _281 = fHazeFilterUVWOffset.x + 0.5f;
                    _282 = fHazeFilterUVWOffset.y + 0.5f;
                    _283 = fHazeFilterUVWOffset.z + 0.5f;
                    _315 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_251 + fHazeFilterUVWOffset.x), (_252 + fHazeFilterUVWOffset.y), (_253 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_241 + fHazeFilterUVWOffset.x), (_242 + fHazeFilterUVWOffset.y), (_243 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_261 + fHazeFilterUVWOffset.x), (_262 + fHazeFilterUVWOffset.y), (_263 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_271 + fHazeFilterUVWOffset.x), (_272 + fHazeFilterUVWOffset.y), (_273 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _211;
                    _316 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_251 + _281), (_252 + _282), (_253 + _283)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_241 + _281), (_242 + _282), (_243 + _283)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_261 + _281), (_262 + _282), (_263 + _283)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_271 + _281), (_272 + _282), (_273 + _283)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _211;
                    if (_94) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2((_315 + _71), (_316 + _72)))).x) - _189) >= fHazeFilterDepthDiffBias)) {
                        _329 = _315;
                        _330 = _316;
                      } else {
                        _329 = 0.0f;
                        _330 = 0.0f;
                      }
                    } else {
                      _329 = _315;
                      _330 = _316;
                    }
                  }
                  _338 = ((fHazeFilterScale * _329) + _71);
                  _339 = ((fHazeFilterScale * _330) + _72);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        _342 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_338, _339));
        _1099 = _342.x;
        _1100 = _342.y;
        _1101 = _342.z;
        _1102 = fDistortionCoef;
        _1103 = 0.0f;
        _1104 = 0.0f;
        _1105 = 0.0f;
        _1106 = 0.0f;
        _1107 = fCorrectCoef;
      } while (false);
    } else {
      _362 = ((saturate((sqrt((_62 * _62) + (_63 * _63)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      if (!(aberrationBlurEnable == 0)) {
        _374 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
        _375 = _362 * 2.0f;
        _379 = (((_374 * _375) + _64) * fDistortionCoef) + 1.0f;
        _390 = ((((_374 + 0.125f) * _375) + _64) * fDistortionCoef) + 1.0f;
        _402 = ((((_374 + 0.25f) * _375) + _64) * fDistortionCoef) + 1.0f;
        _407 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_402 * _67) + 0.5f), ((_402 * _69) + 0.5f)));
        _416 = ((((_374 + 0.375f) * _375) + _64) * fDistortionCoef) + 1.0f;
        _421 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_416 * _67) + 0.5f), ((_416 * _69) + 0.5f)));
        _430 = ((((_374 + 0.5f) * _375) + _64) * fDistortionCoef) + 1.0f;
        _441 = ((((_374 + 0.625f) * _375) + _64) * fDistortionCoef) + 1.0f;
        _446 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_441 * _67) + 0.5f), ((_441 * _69) + 0.5f)));
        _454 = ((((_374 + 0.75f) * _375) + _64) * fDistortionCoef) + 1.0f;
        _459 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_454 * _67) + 0.5f), ((_454 * _69) + 0.5f)));
        _474 = ((((_374 + 0.875f) * _375) + _64) * fDistortionCoef) + 1.0f;
        _486 = ((((_374 + 1.0f) * _375) + _64) * fDistortionCoef) + 1.0f;
        _1099 = (((((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_390 * _67) + 0.5f), ((_390 * _69) + 0.5f))))).x) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_379 * _67) + 0.5f), ((_379 * _69) + 0.5f))))).x)) + (_407.x * 0.75f)) + (_421.x * 0.375f)) * 0.3199999928474426f);
        _1100 = (((((_446.y + _421.y) * 0.625f) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_430 * _67) + 0.5f), ((_430 * _69) + 0.5f))))).y)) + ((_459.y + _407.y) * 0.25f)) * 0.3636363744735718f);
        _1101 = (((((_459.z * 0.75f) + (_446.z * 0.375f)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_474 * _67) + 0.5f), ((_474 * _69) + 0.5f))))).z)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_486 * _67) + 0.5f), ((_486 * _69) + 0.5f))))).z)) * 0.3199999928474426f);
        _1102 = fDistortionCoef;
        _1103 = 0.0f;
        _1104 = 0.0f;
        _1105 = 0.0f;
        _1106 = 0.0f;
        _1107 = fCorrectCoef;
      } else {
        _498 = _362 + _64;
        _500 = (_498 * fDistortionCoef) + 1.0f;
        _507 = ((_498 + _362) * fDistortionCoef) + 1.0f;
        _1099 = (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_71, _72)))).x);
        _1100 = (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_500 * _67) + 0.5f), ((_500 * _69) + 0.5f))))).y);
        _1101 = (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_507 * _67) + 0.5f), ((_507 * _69) + 0.5f))))).z);
        _1102 = fDistortionCoef;
        _1103 = 0.0f;
        _1104 = 0.0f;
        _1105 = 0.0f;
        _1106 = 0.0f;
        _1107 = fCorrectCoef;
      }
    }
  } else {
    if (_43) {
      _525 = screenInverseSize.x * 2.0f;
      _527 = screenInverseSize.y * 2.0f;
      _529 = (_525 * SV_Position.x) + -1.0f;
      _533 = sqrt((_529 * _529) + 1.0f);
      _534 = 1.0f / _533;
      _542 = ((_533 * fOptimizedParam.z) * (_534 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
      _543 = _542 * _529;
      _545 = (_542 * ((_527 * SV_Position.y) + -1.0f)) * (((_534 + -1.0f) * fOptimizedParam.y) + 1.0f);
      _546 = _543 + 0.5f;
      _547 = _545 + 0.5f;
      do {
        _809 = _546;
        _810 = _547;
        if (_45) {
          if (!(fHazeFilterReductionResolution == 0)) {
            _555 = HazeNoiseResult.Sample(BilinearWrap, float2(_546, _547));
            _809 = ((fHazeFilterScale * _555.x) + _546);
            _810 = ((fHazeFilterScale * _555.y) + _547);
          } else {
            _567 = ((fHazeFilterAttribute & 2) != 0);
            _571 = tFilterTempMap1.Sample(BilinearWrap, float2(_546, _547));
            do {
              if (_567) {
                _578 = ReadonlyDepth.SampleLevel(PointClamp, float2(_546, _547), 0.0f);
                _584 = ((_525 * screenSize.x) * _546) + -1.0f;
                _585 = 1.0f - ((_527 * screenSize.y) * _547);
                _622 = 1.0f / (mad(_578.x, (viewProjInvMat[2].w), mad(_585, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _584))) + (viewProjInvMat[3].w));
                _624 = _622 * (mad(_578.x, (viewProjInvMat[2].y), mad(_585, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _584))) + (viewProjInvMat[3].y));
                _632 = (_622 * (mad(_578.x, (viewProjInvMat[2].x), mad(_585, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _584))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _633 = _624 - (transposeViewInvMat[1].w);
                _634 = (_622 * (mad(_578.x, (viewProjInvMat[2].z), mad(_585, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _584))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _659 = saturate(max(((sqrt(((_633 * _633) + (_632 * _632)) + (_634 * _634)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_624 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _571.x);
                _660 = _578.x;
              } else {
                _659 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _571.x), _571.x);
                _660 = 0.0f;
              }
              do {
                _681 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _674 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _681 = (1.0f - saturate(max((_674 * min(max((abs(_543) - fHazeFilterBorder), 0.0f), 1.0f)), (_674 * min(max((abs(_545) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _682 = _681 * _659;
                do {
                  _800 = 0.0f;
                  _801 = 0.0f;
                  if (!(_682 <= 9.999999747378752e-06f)) {
                    _689 = -0.0f - _547;
                    _712 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_689, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _546))) * fHazeFilterUVWOffset.w;
                    _713 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_689, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _546))) * fHazeFilterUVWOffset.w;
                    _714 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_689, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _546))) * fHazeFilterUVWOffset.w;
                    _722 = _712 * 2.0f;
                    _723 = _713 * 2.0f;
                    _724 = _714 * 2.0f;
                    _732 = _712 * 4.0f;
                    _733 = _713 * 4.0f;
                    _734 = _714 * 4.0f;
                    _742 = _712 * 8.0f;
                    _743 = _713 * 8.0f;
                    _744 = _714 * 8.0f;
                    _752 = fHazeFilterUVWOffset.x + 0.5f;
                    _753 = fHazeFilterUVWOffset.y + 0.5f;
                    _754 = fHazeFilterUVWOffset.z + 0.5f;
                    _786 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_722 + fHazeFilterUVWOffset.x), (_723 + fHazeFilterUVWOffset.y), (_724 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_712 + fHazeFilterUVWOffset.x), (_713 + fHazeFilterUVWOffset.y), (_714 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_732 + fHazeFilterUVWOffset.x), (_733 + fHazeFilterUVWOffset.y), (_734 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_742 + fHazeFilterUVWOffset.x), (_743 + fHazeFilterUVWOffset.y), (_744 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _682;
                    _787 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_722 + _752), (_723 + _753), (_724 + _754)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_712 + _752), (_713 + _753), (_714 + _754)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_732 + _752), (_733 + _753), (_734 + _754)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_742 + _752), (_743 + _753), (_744 + _754)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _682;
                    if (_567) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2((_786 + _546), (_787 + _547)))).x) - _660) >= fHazeFilterDepthDiffBias)) {
                        _800 = _786;
                        _801 = _787;
                      } else {
                        _800 = 0.0f;
                        _801 = 0.0f;
                      }
                    } else {
                      _800 = _786;
                      _801 = _787;
                    }
                  }
                  _809 = ((fHazeFilterScale * _800) + _546);
                  _810 = ((fHazeFilterScale * _801) + _547);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        _813 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_809, _810));
        _1099 = _813.x;
        _1100 = _813.y;
        _1101 = _813.z;
        _1102 = 0.0f;
        _1103 = fOptimizedParam.x;
        _1104 = fOptimizedParam.y;
        _1105 = fOptimizedParam.z;
        _1106 = fOptimizedParam.w;
        _1107 = 1.0f;
      } while (false);
    } else {
      _818 = screenInverseSize.x * SV_Position.x;
      _819 = screenInverseSize.y * SV_Position.y;
      if (!(_45)) {
        _823 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_818, _819));
        _1099 = _823.x;
        _1100 = _823.y;
        _1101 = _823.z;
        _1102 = 0.0f;
        _1103 = 0.0f;
        _1104 = 0.0f;
        _1105 = 0.0f;
        _1106 = 0.0f;
        _1107 = 1.0f;
      } else {
        do {
          if (!(fHazeFilterReductionResolution == 0)) {
            _834 = HazeNoiseResult.Sample(BilinearWrap, float2(_818, _819));
            _1088 = (fHazeFilterScale * _834.x);
            _1089 = (fHazeFilterScale * _834.y);
          } else {
            _844 = ((fHazeFilterAttribute & 2) != 0);
            _848 = tFilterTempMap1.Sample(BilinearWrap, float2(_818, _819));
            do {
              if (_844) {
                _855 = ReadonlyDepth.SampleLevel(PointClamp, float2(_818, _819), 0.0f);
                _863 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _818) + -1.0f;
                _864 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _819);
                _901 = 1.0f / (mad(_855.x, (viewProjInvMat[2].w), mad(_864, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _863))) + (viewProjInvMat[3].w));
                _903 = _901 * (mad(_855.x, (viewProjInvMat[2].y), mad(_864, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _863))) + (viewProjInvMat[3].y));
                _911 = (_901 * (mad(_855.x, (viewProjInvMat[2].x), mad(_864, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _863))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _912 = _903 - (transposeViewInvMat[1].w);
                _913 = (_901 * (mad(_855.x, (viewProjInvMat[2].z), mad(_864, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _863))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _938 = saturate(max(((sqrt(((_912 * _912) + (_911 * _911)) + (_913 * _913)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_903 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _848.x);
                _939 = _855.x;
              } else {
                _938 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _848.x), _848.x);
                _939 = 0.0f;
              }
              do {
                _962 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _955 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _962 = (1.0f - saturate(max((_955 * min(max((abs(_818 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)), (_955 * min(max((abs(_819 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _963 = _962 * _938;
                do {
                  _1081 = 0.0f;
                  _1082 = 0.0f;
                  if (!(_963 <= 9.999999747378752e-06f)) {
                    _970 = -0.0f - _819;
                    _993 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_970, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _818))) * fHazeFilterUVWOffset.w;
                    _994 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_970, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _818))) * fHazeFilterUVWOffset.w;
                    _995 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_970, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _818))) * fHazeFilterUVWOffset.w;
                    _1003 = _993 * 2.0f;
                    _1004 = _994 * 2.0f;
                    _1005 = _995 * 2.0f;
                    _1013 = _993 * 4.0f;
                    _1014 = _994 * 4.0f;
                    _1015 = _995 * 4.0f;
                    _1023 = _993 * 8.0f;
                    _1024 = _994 * 8.0f;
                    _1025 = _995 * 8.0f;
                    _1033 = fHazeFilterUVWOffset.x + 0.5f;
                    _1034 = fHazeFilterUVWOffset.y + 0.5f;
                    _1035 = fHazeFilterUVWOffset.z + 0.5f;
                    _1067 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1003 + fHazeFilterUVWOffset.x), (_1004 + fHazeFilterUVWOffset.y), (_1005 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_993 + fHazeFilterUVWOffset.x), (_994 + fHazeFilterUVWOffset.y), (_995 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1013 + fHazeFilterUVWOffset.x), (_1014 + fHazeFilterUVWOffset.y), (_1015 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1023 + fHazeFilterUVWOffset.x), (_1024 + fHazeFilterUVWOffset.y), (_1025 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _963;
                    _1068 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1003 + _1033), (_1004 + _1034), (_1005 + _1035)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_993 + _1033), (_994 + _1034), (_995 + _1035)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1013 + _1033), (_1014 + _1034), (_1015 + _1035)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1023 + _1033), (_1024 + _1034), (_1025 + _1035)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _963;
                    if (_844) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2((_1067 + _818), (_1068 + _819)))).x) - _939) >= fHazeFilterDepthDiffBias)) {
                        _1081 = _1067;
                        _1082 = _1068;
                      } else {
                        _1081 = 0.0f;
                        _1082 = 0.0f;
                      }
                    } else {
                      _1081 = _1067;
                      _1082 = _1068;
                    }
                  }
                  _1088 = (fHazeFilterScale * _1081);
                  _1089 = (fHazeFilterScale * _1082);
                } while (false);
              } while (false);
            } while (false);
          }
          _1094 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1088 + _818), (_1089 + _819)));
          _1099 = _1094.x;
          _1100 = _1094.y;
          _1101 = _1094.z;
          _1102 = 0.0f;
          _1103 = 0.0f;
          _1104 = 0.0f;
          _1105 = 0.0f;
          _1106 = 0.0f;
          _1107 = 1.0f;
        } while (false);
      }
    }
  }
  _1108 = Exposure * _1101;
  _1109 = Exposure * _1100;
  _1110 = Exposure * _1099;
  if (!((cPassEnabled & 32) == 0)) {
    _1133 = (float)((bool)(uint)((cbRadialBlurFlags & 2) != 0));
    _1137 = ComputeResultSRV[0].computeAlpha;
    _1140 = ((1.0f - _1133) + (_1137 * _1133)) * cbRadialColor.w;
    if (!(_1140 == 0.0f)) {
      _1143 = screenInverseSize.x * SV_Position.x;
      _1144 = screenInverseSize.y * SV_Position.y;
      _1146 = _1143 + (-0.5f - cbRadialScreenPos.x);
      _1148 = _1144 + (-0.5f - cbRadialScreenPos.y);
      _1151 = select((_1146 < 0.0f), (1.0f - _1143), _1143);
      _1154 = select((_1148 < 0.0f), (1.0f - _1144), _1144);
      do {
        _1180 = 1.0f;
        if (!((cbRadialBlurFlags & 1) == 0)) {
          _1160 = rsqrt(dot(float2(_1146, _1148), float2(_1146, _1148))) * cbRadialSharpRange;
          _1167 = uint(abs(_1160 * _1148)) + uint(abs(_1160 * _1146));
          _1171 = ((_1167 ^ 61) ^ ((uint)(_1167) >> 16)) * 9;
          _1174 = (((uint)(_1171) >> 4) ^ _1171) * 668265261;
          _1180 = (((float)((uint)((uint)(((uint)(_1174) >> 15) ^ _1174)))) * 2.3283064365386963e-10f);
        }
        _1184 = sqrt((_1146 * _1146) + (_1148 * _1148));
        _1186 = 1.0f / max(1.0f, _1184);
        _1187 = _1180 * _1151;
        _1188 = cbRadialBlurPower * _1186;
        _1189 = _1188 * -0.0011111111380159855f;
        _1191 = _1180 * _1154;
        _1195 = ((_1189 * _1187) + 1.0f) * _1146;
        _1196 = ((_1189 * _1191) + 1.0f) * _1148;
        _1198 = _1188 * -0.002222222276031971f;
        _1203 = ((_1198 * _1187) + 1.0f) * _1146;
        _1204 = ((_1198 * _1191) + 1.0f) * _1148;
        _1205 = _1188 * -0.0033333334140479565f;
        _1210 = ((_1205 * _1187) + 1.0f) * _1146;
        _1211 = ((_1205 * _1191) + 1.0f) * _1148;
        _1212 = _1188 * -0.004444444552063942f;
        _1217 = ((_1212 * _1187) + 1.0f) * _1146;
        _1218 = ((_1212 * _1191) + 1.0f) * _1148;
        _1219 = _1188 * -0.0055555556900799274f;
        _1224 = ((_1219 * _1187) + 1.0f) * _1146;
        _1225 = ((_1219 * _1191) + 1.0f) * _1148;
        _1226 = _1188 * -0.006666666828095913f;
        _1231 = ((_1226 * _1187) + 1.0f) * _1146;
        _1232 = ((_1226 * _1191) + 1.0f) * _1148;
        _1233 = _1188 * -0.007777777966111898f;
        _1238 = ((_1233 * _1187) + 1.0f) * _1146;
        _1239 = ((_1233 * _1191) + 1.0f) * _1148;
        _1240 = _1188 * -0.008888889104127884f;
        _1245 = ((_1240 * _1187) + 1.0f) * _1146;
        _1246 = ((_1240 * _1191) + 1.0f) * _1148;
        _1249 = _1186 * ((cbRadialBlurPower * -0.009999999776482582f) * _1180);
        _1254 = ((_1249 * _1151) + 1.0f) * _1146;
        _1255 = ((_1249 * _1154) + 1.0f) * _1148;
        do {
          if (_37) {
            _1257 = _1195 + cbRadialScreenPos.x;
            _1258 = _1196 + cbRadialScreenPos.y;
            _1262 = ((dot(float2(_1257, _1258), float2(_1257, _1258)) * _1102) + 1.0f) * _1107;
            _1268 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1262 * _1257) + 0.5f), ((_1262 * _1258) + 0.5f)), 0.0f);
            _1272 = _1203 + cbRadialScreenPos.x;
            _1273 = _1204 + cbRadialScreenPos.y;
            _1277 = ((dot(float2(_1272, _1273), float2(_1272, _1273)) * _1102) + 1.0f) * _1107;
            _1282 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1277 * _1272) + 0.5f), ((_1277 * _1273) + 0.5f)), 0.0f);
            _1289 = _1210 + cbRadialScreenPos.x;
            _1290 = _1211 + cbRadialScreenPos.y;
            _1294 = ((dot(float2(_1289, _1290), float2(_1289, _1290)) * _1102) + 1.0f) * _1107;
            _1299 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1294 * _1289) + 0.5f), ((_1294 * _1290) + 0.5f)), 0.0f);
            _1306 = _1217 + cbRadialScreenPos.x;
            _1307 = _1218 + cbRadialScreenPos.y;
            _1311 = ((dot(float2(_1306, _1307), float2(_1306, _1307)) * _1102) + 1.0f) * _1107;
            _1316 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1311 * _1306) + 0.5f), ((_1311 * _1307) + 0.5f)), 0.0f);
            _1323 = _1224 + cbRadialScreenPos.x;
            _1324 = _1225 + cbRadialScreenPos.y;
            _1328 = ((dot(float2(_1323, _1324), float2(_1323, _1324)) * _1102) + 1.0f) * _1107;
            _1333 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1328 * _1323) + 0.5f), ((_1328 * _1324) + 0.5f)), 0.0f);
            _1340 = _1231 + cbRadialScreenPos.x;
            _1341 = _1232 + cbRadialScreenPos.y;
            _1345 = ((dot(float2(_1340, _1341), float2(_1340, _1341)) * _1102) + 1.0f) * _1107;
            _1350 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1345 * _1340) + 0.5f), ((_1345 * _1341) + 0.5f)), 0.0f);
            _1357 = _1238 + cbRadialScreenPos.x;
            _1358 = _1239 + cbRadialScreenPos.y;
            _1362 = ((dot(float2(_1357, _1358), float2(_1357, _1358)) * _1102) + 1.0f) * _1107;
            _1367 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1362 * _1357) + 0.5f), ((_1362 * _1358) + 0.5f)), 0.0f);
            _1374 = _1245 + cbRadialScreenPos.x;
            _1375 = _1246 + cbRadialScreenPos.y;
            _1379 = ((dot(float2(_1374, _1375), float2(_1374, _1375)) * _1102) + 1.0f) * _1107;
            _1384 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1379 * _1374) + 0.5f), ((_1379 * _1375) + 0.5f)), 0.0f);
            _1391 = _1254 + cbRadialScreenPos.x;
            _1392 = _1255 + cbRadialScreenPos.y;
            _1396 = ((dot(float2(_1391, _1392), float2(_1391, _1392)) * _1102) + 1.0f) * _1107;
            _1401 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1396 * _1391) + 0.5f), ((_1396 * _1392) + 0.5f)), 0.0f);
            _1735 = ((((((((_1282.x + _1268.x) + _1299.x) + _1316.x) + _1333.x) + _1350.x) + _1367.x) + _1384.x) + _1401.x);
            _1736 = ((((((((_1282.y + _1268.y) + _1299.y) + _1316.y) + _1333.y) + _1350.y) + _1367.y) + _1384.y) + _1401.y);
            _1737 = ((((((((_1282.z + _1268.z) + _1299.z) + _1316.z) + _1333.z) + _1350.z) + _1367.z) + _1384.z) + _1401.z);
          } else {
            _1409 = cbRadialScreenPos.x + 0.5f;
            _1410 = _1195 + _1409;
            _1411 = cbRadialScreenPos.y + 0.5f;
            _1412 = _1196 + _1411;
            _1413 = _1203 + _1409;
            _1414 = _1204 + _1411;
            _1415 = _1210 + _1409;
            _1416 = _1211 + _1411;
            _1417 = _1217 + _1409;
            _1418 = _1218 + _1411;
            _1419 = _1224 + _1409;
            _1420 = _1225 + _1411;
            _1421 = _1231 + _1409;
            _1422 = _1232 + _1411;
            _1423 = _1238 + _1409;
            _1424 = _1239 + _1411;
            _1425 = _1245 + _1409;
            _1426 = _1246 + _1411;
            _1427 = _1254 + _1409;
            _1428 = _1255 + _1411;
            if (_43) {
              _1432 = (_1410 * 2.0f) + -1.0f;
              _1436 = sqrt((_1432 * _1432) + 1.0f);
              _1437 = 1.0f / _1436;
              _1444 = _1106 * 0.5f;
              _1445 = ((_1436 * _1105) * (_1437 + _1103)) * _1444;
              _1452 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1445 * _1432) + 0.5f), (((_1445 * ((_1412 * 2.0f) + -1.0f)) * (((_1437 + -1.0f) * _1104) + 1.0f)) + 0.5f)), 0.0f);
              _1458 = (_1413 * 2.0f) + -1.0f;
              _1462 = sqrt((_1458 * _1458) + 1.0f);
              _1463 = 1.0f / _1462;
              _1470 = ((_1462 * _1105) * (_1463 + _1103)) * _1444;
              _1476 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1470 * _1458) + 0.5f), (((_1470 * ((_1414 * 2.0f) + -1.0f)) * (((_1463 + -1.0f) * _1104) + 1.0f)) + 0.5f)), 0.0f);
              _1485 = (_1415 * 2.0f) + -1.0f;
              _1489 = sqrt((_1485 * _1485) + 1.0f);
              _1490 = 1.0f / _1489;
              _1497 = ((_1489 * _1105) * (_1490 + _1103)) * _1444;
              _1503 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1497 * _1485) + 0.5f), (((_1497 * ((_1416 * 2.0f) + -1.0f)) * (((_1490 + -1.0f) * _1104) + 1.0f)) + 0.5f)), 0.0f);
              _1512 = (_1417 * 2.0f) + -1.0f;
              _1516 = sqrt((_1512 * _1512) + 1.0f);
              _1517 = 1.0f / _1516;
              _1524 = ((_1516 * _1105) * (_1517 + _1103)) * _1444;
              _1530 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1524 * _1512) + 0.5f), (((_1524 * ((_1418 * 2.0f) + -1.0f)) * (((_1517 + -1.0f) * _1104) + 1.0f)) + 0.5f)), 0.0f);
              _1539 = (_1419 * 2.0f) + -1.0f;
              _1543 = sqrt((_1539 * _1539) + 1.0f);
              _1544 = 1.0f / _1543;
              _1551 = ((_1543 * _1105) * (_1544 + _1103)) * _1444;
              _1557 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1551 * _1539) + 0.5f), (((_1551 * ((_1420 * 2.0f) + -1.0f)) * (((_1544 + -1.0f) * _1104) + 1.0f)) + 0.5f)), 0.0f);
              _1566 = (_1421 * 2.0f) + -1.0f;
              _1570 = sqrt((_1566 * _1566) + 1.0f);
              _1571 = 1.0f / _1570;
              _1578 = ((_1570 * _1105) * (_1571 + _1103)) * _1444;
              _1584 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1578 * _1566) + 0.5f), (((_1578 * ((_1422 * 2.0f) + -1.0f)) * (((_1571 + -1.0f) * _1104) + 1.0f)) + 0.5f)), 0.0f);
              _1593 = (_1423 * 2.0f) + -1.0f;
              _1597 = sqrt((_1593 * _1593) + 1.0f);
              _1598 = 1.0f / _1597;
              _1605 = ((_1597 * _1105) * (_1598 + _1103)) * _1444;
              _1611 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1605 * _1593) + 0.5f), (((_1605 * ((_1424 * 2.0f) + -1.0f)) * (((_1598 + -1.0f) * _1104) + 1.0f)) + 0.5f)), 0.0f);
              _1620 = (_1425 * 2.0f) + -1.0f;
              _1624 = sqrt((_1620 * _1620) + 1.0f);
              _1625 = 1.0f / _1624;
              _1632 = ((_1624 * _1105) * (_1625 + _1103)) * _1444;
              _1638 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1632 * _1620) + 0.5f), (((_1632 * ((_1426 * 2.0f) + -1.0f)) * (((_1625 + -1.0f) * _1104) + 1.0f)) + 0.5f)), 0.0f);
              _1647 = (_1427 * 2.0f) + -1.0f;
              _1651 = sqrt((_1647 * _1647) + 1.0f);
              _1652 = 1.0f / _1651;
              _1659 = ((_1651 * _1105) * (_1652 + _1103)) * _1444;
              _1665 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1659 * _1647) + 0.5f), (((_1659 * ((_1428 * 2.0f) + -1.0f)) * (((_1652 + -1.0f) * _1104) + 1.0f)) + 0.5f)), 0.0f);
              _1735 = ((((((((_1476.x + _1452.x) + _1503.x) + _1530.x) + _1557.x) + _1584.x) + _1611.x) + _1638.x) + _1665.x);
              _1736 = ((((((((_1476.y + _1452.y) + _1503.y) + _1530.y) + _1557.y) + _1584.y) + _1611.y) + _1638.y) + _1665.y);
              _1737 = ((((((((_1476.z + _1452.z) + _1503.z) + _1530.z) + _1557.z) + _1584.z) + _1611.z) + _1638.z) + _1665.z);
            } else {
              _1674 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1410, _1412), 0.0f);
              _1678 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1413, _1414), 0.0f);
              _1685 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1415, _1416), 0.0f);
              _1692 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1417, _1418), 0.0f);
              _1699 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1419, _1420), 0.0f);
              _1706 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1421, _1422), 0.0f);
              _1713 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1423, _1424), 0.0f);
              _1720 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1425, _1426), 0.0f);
              _1727 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1427, _1428), 0.0f);
              _1735 = ((((((((_1678.x + _1674.x) + _1685.x) + _1692.x) + _1699.x) + _1706.x) + _1713.x) + _1720.x) + _1727.x);
              _1736 = ((((((((_1678.y + _1674.y) + _1685.y) + _1692.y) + _1699.y) + _1706.y) + _1713.y) + _1720.y) + _1727.y);
              _1737 = ((((((((_1678.z + _1674.z) + _1685.z) + _1692.z) + _1699.z) + _1706.z) + _1713.z) + _1720.z) + _1727.z);
            }
          }
          _1747 = (cbRadialColor.z * (Exposure * (_1101 + _1737))) * 0.10000000149011612f;
          _1748 = (cbRadialColor.y * (Exposure * (_1100 + _1736))) * 0.10000000149011612f;
          _1749 = (cbRadialColor.x * (Exposure * (_1099 + _1735))) * 0.10000000149011612f;
          do {
            _1771 = _1749;
            _1772 = _1748;
            _1773 = _1747;
            if (cbRadialMaskRate.x > 0.0f) {
              _1754 = saturate((_1184 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              _1760 = (((_1754 * _1754) * cbRadialMaskRate.x) * (3.0f - (_1754 * 2.0f))) + cbRadialMaskRate.y;
              _1771 = ((_1760 * (_1749 - _1110)) + _1110);
              _1772 = ((_1760 * (_1748 - _1109)) + _1109);
              _1773 = ((_1760 * (_1747 - _1108)) + _1108);
            }
            _1784 = (lerp(_1110, _1771, _1140));
            _1785 = (lerp(_1109, _1772, _1140));
            _1786 = (lerp(_1108, _1773, _1140));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1784 = _1110;
      _1785 = _1109;
      _1786 = _1108;
    }
  } else {
    _1784 = _1110;
    _1785 = _1109;
    _1786 = _1108;
  }
  if (!((cPassEnabled & 2) == 0)) {
    _1803 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    _1805 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    _1811 = frac(frac((_1805 * 0.005837149918079376f) + (_1803 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      _1825 = 0.0f;
      if (_1811 < fNoiseDensity) {
        _1816 = (int)(uint(_1805 * _1803)) ^ 12345391;
        _1817 = _1816 * 3635641;
        _1825 = (((float)((uint)((uint)((((uint)(_1817) >> 26) | ((int)(_1816 * 232681024))) ^ _1817)))) * 2.3283064365386963e-10f);
      }
      _1827 = frac(_1811 * 757.4846801757812f);
      do {
        _1841 = 0.0f;
        if (_1827 < fNoiseDensity) {
          _1831 = asint(_1827) ^ 12345391;
          _1832 = _1831 * 3635641;
          _1841 = ((((float)((uint)((uint)((((uint)(_1832) >> 26) | ((int)(_1831 * 232681024))) ^ _1832)))) * 2.3283064365386963e-10f) + -0.5f);
        }
        _1843 = frac(_1827 * 757.4846801757812f);
        do {
          _1857 = 0.0f;
          if (_1843 < fNoiseDensity) {
            _1847 = asint(_1843) ^ 12345391;
            _1848 = _1847 * 3635641;
            _1857 = ((((float)((uint)((uint)((((uint)(_1848) >> 26) | ((int)(_1847 * 232681024))) ^ _1848)))) * 2.3283064365386963e-10f) + -0.5f);
          }
          _1858 = _1825 * CUSTOM_NOISE *  fNoisePower.x;
          _1859 = _1857 * CUSTOM_NOISE *  fNoisePower.y;
          _1860 = _1841 * CUSTOM_NOISE *  fNoisePower.y;
          _1874 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1784), saturate(_1785), saturate(_1786)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1885 = ((_1874 * (mad(_1860, 1.4019999504089355f, _1858) - _1784)) + _1784);
          _1886 = ((_1874 * (mad(_1860, -0.7139999866485596f, mad(_1859, -0.3440000116825104f, _1858)) - _1785)) + _1785);
          _1887 = ((_1874 * (mad(_1859, 1.7719999551773071f, _1858) - _1786)) + _1786);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1885 = _1784;
    _1886 = _1785;
    _1887 = _1786;
  }
  _1902 = mad(_1887, (fOCIOTransformMatrix[2].x), mad(_1886, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1885)));
  _1905 = mad(_1887, (fOCIOTransformMatrix[2].y), mad(_1886, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1885)));
  _1908 = mad(_1887, (fOCIOTransformMatrix[2].z), mad(_1886, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1885)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    _1914 = max(max(_1902, _1905), _1908);
    if (!(_1914 == 0.0f)) {
      _1920 = abs(_1914);
      _1921 = (_1914 - _1902) / _1920;
      _1922 = (_1914 - _1905) / _1920;
      _1923 = (_1914 - _1908) / _1920;
      do {
        _1945 = _1921;
        if (!(!(_1921 >= cbControlRGCParam.CyanThreshold))) {
          _1933 = _1921 - cbControlRGCParam.CyanThreshold;
          _1945 = ((_1933 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1933) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        }
        do {
          _1966 = _1922;
          if (!(!(_1922 >= cbControlRGCParam.MagentaThreshold))) {
            _1954 = _1922 - cbControlRGCParam.MagentaThreshold;
            _1966 = ((_1954 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1954) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          }
          do {
            _1986 = _1923;
            if (!(!(_1923 >= cbControlRGCParam.YellowThreshold))) {
              _1974 = _1923 - cbControlRGCParam.YellowThreshold;
              _1986 = ((_1974 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1974) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            }
            _1994 = (_1914 - (_1945 * _1920));
            _1995 = (_1914 - (_1966 * _1920));
            _1996 = (_1914 - (_1986 * _1920));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1994 = _1902;
      _1995 = _1905;
      _1996 = _1908;
    }
  } else {
    _1994 = _1902;
    _1995 = _1905;
    _1996 = _1908;
  }
#if 1
  ApplyColorCorrectTexturePass(
      (cPassEnabled & 4) != 0,
      _1994, _1995, _1996,
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
      _2403, _2404, _2405);
#else
  if (!((cPassEnabled & 4) == 0)) {
    _2022 = !(_1994 <= 0.0078125f);
    do {
      if (!(_2022)) {
        _2031 = ((_1994 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2031 = ((log2(_1994) + 9.720000267028809f) * 0.05707762390375137f);
      }
      _2032 = !(_1995 <= 0.0078125f);
      do {
        if (!(_2032)) {
          _2041 = ((_1995 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2041 = ((log2(_1995) + 9.720000267028809f) * 0.05707762390375137f);
        }
        _2042 = !(_1996 <= 0.0078125f);
        do {
          if (!(_2042)) {
            _2051 = ((_1996 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _2051 = ((log2(_1996) + 9.720000267028809f) * 0.05707762390375137f);
          }
          _2060 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_2031 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2041 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2051 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_2060.x < 0.155251145362854f) {
              _2077 = ((_2060.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((_2060.x >= 0.155251145362854f) && (_2060.x < 1.4679962396621704f)) {
                _2077 = exp2((_2060.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _2077 = 65504.0f;
              }
            }
            do {
              if (_2060.y < 0.155251145362854f) {
                _2091 = ((_2060.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_2060.y >= 0.155251145362854f) && (_2060.y < 1.4679962396621704f)) {
                  _2091 = exp2((_2060.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _2091 = 65504.0f;
                }
              }
              do {
                if (_2060.z < 0.155251145362854f) {
                  _2105 = ((_2060.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_2060.z >= 0.155251145362854f) && (_2060.z < 1.4679962396621704f)) {
                    _2105 = exp2((_2060.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _2105 = 65504.0f;
                  }
                }
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!(_2022)) {
                        _2116 = ((_1994 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _2116 = ((log2(_1994) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(_2032)) {
                          _2125 = ((_1995 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2125 = ((log2(_1995) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(_2042)) {
                            _2134 = ((_1996 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2134 = ((log2(_1996) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          _2142 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_2116 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2125 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2134 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_2142.x < 0.155251145362854f) {
                              _2159 = ((_2142.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((_2142.x >= 0.155251145362854f) && (_2142.x < 1.4679962396621704f)) {
                                _2159 = exp2((_2142.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _2159 = 65504.0f;
                              }
                            }
                            do {
                              if (_2142.y < 0.155251145362854f) {
                                _2173 = ((_2142.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_2142.y >= 0.155251145362854f) && (_2142.y < 1.4679962396621704f)) {
                                  _2173 = exp2((_2142.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2173 = 65504.0f;
                                }
                              }
                              do {
                                if (_2142.z < 0.155251145362854f) {
                                  _2187 = ((_2142.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_2142.z >= 0.155251145362854f) && (_2142.z < 1.4679962396621704f)) {
                                    _2187 = exp2((_2142.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2187 = 65504.0f;
                                  }
                                }
                                _2194 = ((_2159 - _2077) * fTextureBlendRate) + _2077;
                                _2195 = ((_2173 - _2091) * fTextureBlendRate) + _2091;
                                _2196 = ((_2187 - _2105) * fTextureBlendRate) + _2105;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_2194 <= 0.0078125f))) {
                                      _2208 = ((_2194 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _2208 = ((log2(_2194) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_2195 <= 0.0078125f))) {
                                        _2218 = ((_2195 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _2218 = ((log2(_2195) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_2196 <= 0.0078125f))) {
                                          _2228 = ((_2196 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _2228 = ((log2(_2196) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        _2236 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2208 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2218 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2228 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_2236.x < 0.155251145362854f) {
                                            _2253 = ((_2236.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((_2236.x >= 0.155251145362854f) && (_2236.x < 1.4679962396621704f)) {
                                              _2253 = exp2((_2236.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _2253 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_2236.y < 0.155251145362854f) {
                                              _2267 = ((_2236.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((_2236.y >= 0.155251145362854f) && (_2236.y < 1.4679962396621704f)) {
                                                _2267 = exp2((_2236.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _2267 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_2236.z < 0.155251145362854f) {
                                                _2281 = ((_2236.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((_2236.z >= 0.155251145362854f) && (_2236.z < 1.4679962396621704f)) {
                                                  _2281 = exp2((_2236.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _2281 = 65504.0f;
                                                }
                                              }
                                              _2387 = (lerp(_2194, _2253, fTextureBlendRate2));
                                              _2388 = (lerp(_2195, _2267, fTextureBlendRate2));
                                              _2389 = (lerp(_2196, _2281, fTextureBlendRate2));
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _2387 = _2194;
                                  _2388 = _2195;
                                  _2389 = _2196;
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
                        if (!(!(_2077 <= 0.0078125f))) {
                          _2303 = ((_2077 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2303 = ((log2(_2077) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_2091 <= 0.0078125f))) {
                            _2313 = ((_2091 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2313 = ((log2(_2091) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_2105 <= 0.0078125f))) {
                              _2323 = ((_2105 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _2323 = ((log2(_2105) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            _2331 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2303 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2313 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2323 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_2331.x < 0.155251145362854f) {
                                _2348 = ((_2331.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_2331.x >= 0.155251145362854f) && (_2331.x < 1.4679962396621704f)) {
                                  _2348 = exp2((_2331.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2348 = 65504.0f;
                                }
                              }
                              do {
                                if (_2331.y < 0.155251145362854f) {
                                  _2362 = ((_2331.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_2331.y >= 0.155251145362854f) && (_2331.y < 1.4679962396621704f)) {
                                    _2362 = exp2((_2331.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2362 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_2331.z < 0.155251145362854f) {
                                    _2376 = ((_2331.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((_2331.z >= 0.155251145362854f) && (_2331.z < 1.4679962396621704f)) {
                                      _2376 = exp2((_2331.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _2376 = 65504.0f;
                                    }
                                  }
                                  _2387 = (lerp(_2077, _2348, fTextureBlendRate2));
                                  _2388 = (lerp(_2091, _2362, fTextureBlendRate2));
                                  _2389 = (lerp(_2105, _2376, fTextureBlendRate2));
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _2387 = _2077;
                      _2388 = _2091;
                      _2389 = _2105;
                    }
                  }
                  _2403 = (mad(_2389, (fColorMatrix[2].x), mad(_2388, (fColorMatrix[1].x), (_2387 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _2404 = (mad(_2389, (fColorMatrix[2].y), mad(_2388, (fColorMatrix[1].y), (_2387 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _2405 = (mad(_2389, (fColorMatrix[2].z), mad(_2388, (fColorMatrix[1].z), (_2387 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2403 = _1994;
    _2404 = _1995;
    _2405 = _1996;
  }
#endif
  _2406 = min(_2403, 65000.0f);
  _2407 = min(_2404, 65000.0f);
  _2408 = min(_2405, 65000.0f);
  _2411 = isfinite(max(max(_2406, _2407), _2408));
  _2412 = select(_2411, _2406, 1.0f);
  _2413 = select(_2411, _2407, 1.0f);
  _2414 = select(_2411, _2408, 1.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2449 = saturate(((cvdR.x * _2412) + (cvdR.y * _2413)) + (cvdR.z * _2414));
    _2450 = saturate(((cvdG.x * _2412) + (cvdG.y * _2413)) + (cvdG.z * _2414));
    _2451 = saturate(((cvdB.x * _2412) + (cvdB.y * _2413)) + (cvdB.z * _2414));
  } else {
    _2449 = _2412;
    _2450 = _2413;
    _2451 = _2414;
  }
  if (!((cPassEnabled & 16) == 0)) {
    _2463 = screenInverseSize.x * SV_Position.x;
    _2464 = screenInverseSize.y * SV_Position.y;
    _2467 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2463, _2464), 0.0f);
    _2472 = _2467.x * ColorParam.x;
    _2473 = _2467.y * ColorParam.y;
    _2474 = _2467.z * ColorParam.z;
    _2482 = (_2467.w * ColorParam.w) * saturate((((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2463, _2464), 0.0f)).x) * Levels_Rate) + Levels_Range);
    do {
      if (_2472 < 0.5f) {
        _2494 = ((_2449 * 2.0f) * _2472);
      } else {
        _2494 = (1.0f - (((1.0f - _2449) * 2.0f) * (1.0f - _2472)));
      }
      do {
        if (_2473 < 0.5f) {
          _2506 = ((_2450 * 2.0f) * _2473);
        } else {
          _2506 = (1.0f - (((1.0f - _2450) * 2.0f) * (1.0f - _2473)));
        }
        do {
          if (_2474 < 0.5f) {
            _2518 = ((_2451 * 2.0f) * _2474);
          } else {
            _2518 = (1.0f - (((1.0f - _2451) * 2.0f) * (1.0f - _2474)));
          }
          _2529 = (lerp(_2449, _2494, _2482));
          _2530 = (lerp(_2450, _2506, _2482));
          _2531 = (lerp(_2451, _2518, _2482));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2529 = _2449;
    _2530 = _2450;
    _2531 = _2451;
  }
#if 1
  ApplyCapcomExponentialToneMap(_2529, _2530, _2531,
                                _2636, _2637, _2638);
#else
  if (tonemapParam_isHDRMode == 0.0f) {
    _2539 = invLinearBegin * _2529;
    do {
      _2547 = 1.0f;
      if (!(_2529 >= linearBegin)) {
        _2547 = ((_2539 * _2539) * (3.0f - (_2539 * 2.0f)));
      }
      _2548 = invLinearBegin * _2530;
      do {
        _2556 = 1.0f;
        if (!(_2530 >= linearBegin)) {
          _2556 = ((_2548 * _2548) * (3.0f - (_2548 * 2.0f)));
        }
        _2557 = invLinearBegin * _2531;
        do {
          _2565 = 1.0f;
          if (!(_2531 >= linearBegin)) {
            _2565 = ((_2557 * _2557) * (3.0f - (_2557 * 2.0f)));
          }
          _2574 = select((_2529 < linearStart), 0.0f, 1.0f);
          _2575 = select((_2530 < linearStart), 0.0f, 1.0f);
          _2576 = select((_2531 < linearStart), 0.0f, 1.0f);
          _2636 = (((((1.0f - _2547) * linearBegin) * (pow(_2539, toe))) + ((_2547 - _2574) * ((contrast * _2529) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2529) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2574));
          _2637 = (((((1.0f - _2556) * linearBegin) * (pow(_2548, toe))) + ((_2556 - _2575) * ((contrast * _2530) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2530) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2575));
          _2638 = (((((1.0f - _2565) * linearBegin) * (pow(_2557, toe))) + ((_2565 - _2576) * ((contrast * _2531) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2531) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2576));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2636 = _2529;
    _2637 = _2530;
    _2638 = _2531;
  }
#endif
  SV_Target.x = _2636;
  SV_Target.y = _2637;
  SV_Target.z = _2638;
  SV_Target.w = 0.0f;
  return SV_Target;
}
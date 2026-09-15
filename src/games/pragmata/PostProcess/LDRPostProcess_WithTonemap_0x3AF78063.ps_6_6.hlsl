#include "PostProcess.hlsli"

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
  uint sceneInfoAdditionalFlags : packoffset(c039.x);
};

cbuffer TonemapParam : register(b1) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  float toe : packoffset(c000.w);
  float maxNit : packoffset(c001.x);
  float linearStart : packoffset(c001.y);
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
  float tonemapParam_isHDRMode : packoffset(c002.w);
  float useDynamicRangeConversion : packoffset(c003.x);
  float useHuePreserve : packoffset(c003.y);
  float exposureScale : packoffset(c003.z);
  float kneeStartNit : packoffset(c003.w);
  float knee : packoffset(c004.x);
  float curve_HDRip : packoffset(c004.y);
  float curve_k2 : packoffset(c004.z);
  float curve_k4 : packoffset(c004.w);
  row_major float4x4 RGBToXYZViaCrosstalkMatrix : packoffset(c005.x);
  row_major float4x4 XYZToRGBViaCrosstalkMatrix : packoffset(c009.x);
  float tonemapGraphScale : packoffset(c013.x);
  float offsetEVCurveStart : packoffset(c013.y);
  float offsetEVCurveRange : packoffset(c013.z);
};

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

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure) : SV_Target {
  float4 SV_Target;
  bool _31;
  bool _37;
  bool _43;
  float _188;
  float _189;
  float _210;
  float _332;
  float _333;
  float _341;
  float _342;
  float _662;
  float _663;
  float _684;
  float _806;
  float _807;
  float _815;
  float _816;
  float _944;
  float _945;
  float _968;
  float _1090;
  float _1091;
  float _1097;
  float _1098;
  float _1108;
  float _1109;
  float _1110;
  float _1111;
  float _1112;
  float _1113;
  float _1114;
  float _1115;
  float _1116;
  float _1189;
  float _1744;
  float _1745;
  float _1746;
  float _1780;
  float _1781;
  float _1782;
  float _1793;
  float _1794;
  float _1795;
  float _1834;
  float _1850;
  float _1866;
  float _1894;
  float _1895;
  float _1896;
  float _1954;
  float _1975;
  float _1995;
  float _2003;
  float _2004;
  float _2005;
  float _2040;
  float _2050;
  float _2060;
  float _2086;
  float _2100;
  float _2114;
  float _2128;
  float _2137;
  float _2146;
  float _2171;
  float _2185;
  float _2199;
  float _2223;
  float _2233;
  float _2243;
  float _2268;
  float _2282;
  float _2296;
  float _2321;
  float _2331;
  float _2341;
  float _2366;
  float _2380;
  float _2394;
  float _2408;
  float _2409;
  float _2410;
  float _2424;
  float _2425;
  float _2426;
  float _2467;
  float _2468;
  float _2469;
  float _2512;
  float _2524;
  float _2536;
  float _2547;
  float _2548;
  float _2549;
  float _2565;
  float _2574;
  float _2583;
  float _2654;
  float _2655;
  float _2656;
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
  float4 _345;
  float _365;
  float _377;
  float _378;
  float _382;
  float _393;
  float _405;
  float4 _410;
  float _419;
  float4 _424;
  float _433;
  float _444;
  float4 _449;
  float _457;
  float4 _462;
  float _477;
  float _489;
  float _501;
  float _503;
  float _510;
  float _528;
  float _530;
  float _532;
  float _536;
  float _537;
  float _545;
  float _546;
  float _548;
  float _549;
  float _550;
  float2 _558;
  bool _570;
  float _574;
  float _581;
  float _587;
  float _588;
  float _625;
  float _627;
  float _635;
  float _636;
  float _637;
  float _677;
  float _685;
  float _692;
  float _715;
  float _716;
  float _717;
  float _725;
  float _726;
  float _727;
  float _735;
  float _736;
  float _737;
  float _745;
  float _746;
  float _747;
  float _755;
  float _756;
  float _757;
  float _789;
  float _790;
  float4 _819;
  float _824;
  float _825;
  float4 _829;
  float2 _840;
  bool _850;
  float _854;
  float _861;
  float _869;
  float _870;
  float _907;
  float _909;
  float _917;
  float _918;
  float _919;
  float _961;
  float _969;
  float _976;
  float _999;
  float _1000;
  float _1001;
  float _1009;
  float _1010;
  float _1011;
  float _1019;
  float _1020;
  float _1021;
  float _1029;
  float _1030;
  float _1031;
  float _1039;
  float _1040;
  float _1041;
  float _1073;
  float _1074;
  float4 _1103;
  float _1117;
  float _1118;
  float _1119;
  float _1142;
  float _1146;
  float _1149;
  float _1152;
  float _1153;
  float _1155;
  float _1157;
  float _1160;
  float _1163;
  float _1169;
  uint _1176;
  uint _1180;
  uint _1183;
  float _1193;
  float _1195;
  float _1196;
  float _1197;
  float _1198;
  float _1200;
  float _1204;
  float _1205;
  float _1207;
  float _1212;
  float _1213;
  float _1214;
  float _1219;
  float _1220;
  float _1221;
  float _1226;
  float _1227;
  float _1228;
  float _1233;
  float _1234;
  float _1235;
  float _1240;
  float _1241;
  float _1242;
  float _1247;
  float _1248;
  float _1249;
  float _1254;
  float _1255;
  float _1258;
  float _1263;
  float _1264;
  float _1266;
  float _1267;
  float _1271;
  float4 _1277;
  float _1281;
  float _1282;
  float _1286;
  float4 _1291;
  float _1298;
  float _1299;
  float _1303;
  float4 _1308;
  float _1315;
  float _1316;
  float _1320;
  float4 _1325;
  float _1332;
  float _1333;
  float _1337;
  float4 _1342;
  float _1349;
  float _1350;
  float _1354;
  float4 _1359;
  float _1366;
  float _1367;
  float _1371;
  float4 _1376;
  float _1383;
  float _1384;
  float _1388;
  float4 _1393;
  float _1400;
  float _1401;
  float _1405;
  float4 _1410;
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
  float _1429;
  float _1430;
  float _1431;
  float _1432;
  float _1433;
  float _1434;
  float _1435;
  float _1436;
  float _1437;
  float _1441;
  float _1445;
  float _1446;
  float _1453;
  float _1454;
  float4 _1461;
  float _1467;
  float _1471;
  float _1472;
  float _1479;
  float4 _1485;
  float _1494;
  float _1498;
  float _1499;
  float _1506;
  float4 _1512;
  float _1521;
  float _1525;
  float _1526;
  float _1533;
  float4 _1539;
  float _1548;
  float _1552;
  float _1553;
  float _1560;
  float4 _1566;
  float _1575;
  float _1579;
  float _1580;
  float _1587;
  float4 _1593;
  float _1602;
  float _1606;
  float _1607;
  float _1614;
  float4 _1620;
  float _1629;
  float _1633;
  float _1634;
  float _1641;
  float4 _1647;
  float _1656;
  float _1660;
  float _1661;
  float _1668;
  float4 _1674;
  float4 _1683;
  float4 _1687;
  float4 _1694;
  float4 _1701;
  float4 _1708;
  float4 _1715;
  float4 _1722;
  float4 _1729;
  float4 _1736;
  float _1756;
  float _1757;
  float _1758;
  float _1763;
  float _1769;
  float _1812;
  float _1814;
  float _1820;
  int _1825;
  uint _1826;
  float _1836;
  int _1840;
  uint _1841;
  float _1852;
  int _1856;
  uint _1857;
  float _1867;
  float _1868;
  float _1869;
  float _1883;
  float _1911;
  float _1914;
  float _1917;
  float _1923;
  float _1929;
  float _1930;
  float _1931;
  float _1932;
  float _1942;
  float _1963;
  float _1983;
  bool _2031;
  bool _2041;
  bool _2051;
  float4 _2069;
  float _2115;
  float _2116;
  float _2117;
  float4 _2154;
  float _2209;
  float _2210;
  float _2211;
  float4 _2251;
  float4 _2349;
  float _2427;
  float _2428;
  float _2429;
  bool _2432;
  float _2433;
  float _2434;
  float _2435;
  float _2481;
  float _2482;
  float4 _2485;
  float _2490;
  float _2491;
  float _2492;
  float _2500;
  float _2557;
  float _2566;
  float _2575;
  float _2592;
  float _2593;
  float _2594;
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
        _341 = _71;
        _342 = _72;
        if (_45) {
          if (!(fHazeFilterReductionResolution == 0)) {
            _82 = HazeNoiseResult.Sample(BilinearWrap, float2(_71, _72));
            _341 = ((fHazeFilterScale * _82.x) + _71);
            _342 = ((fHazeFilterScale * _82.y) + _72);
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
                  _332 = 0.0f;
                  _333 = 0.0f;
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
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _315) + _71), ((fHazeFilterScale * _316) + _72)))).x) - _189) >= fHazeFilterDepthDiffBias)) {
                        _332 = _315;
                        _333 = _316;
                      } else {
                        _332 = 0.0f;
                        _333 = 0.0f;
                      }
                    } else {
                      _332 = _315;
                      _333 = _316;
                    }
                  }
                  _341 = ((fHazeFilterScale * _332) + _71);
                  _342 = ((fHazeFilterScale * _333) + _72);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        _345 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_341, _342));
        _1108 = _345.x;
        _1109 = _345.y;
        _1110 = _345.z;
        _1111 = fDistortionCoef;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = 0.0f;
        _1115 = 0.0f;
        _1116 = fCorrectCoef;
      } while (false);
    } else {
      _365 = ((saturate((sqrt((_62 * _62) + (_63 * _63)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      if (!(aberrationBlurEnable == 0)) {
        _377 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
        _378 = _365 * 2.0f;
        _382 = (((_377 * _378) + _64) * fDistortionCoef) + 1.0f;
        _393 = ((((_377 + 0.125f) * _378) + _64) * fDistortionCoef) + 1.0f;
        _405 = ((((_377 + 0.25f) * _378) + _64) * fDistortionCoef) + 1.0f;
        _410 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_405 * _67) + 0.5f), ((_405 * _69) + 0.5f)));
        _419 = ((((_377 + 0.375f) * _378) + _64) * fDistortionCoef) + 1.0f;
        _424 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_419 * _67) + 0.5f), ((_419 * _69) + 0.5f)));
        _433 = ((((_377 + 0.5f) * _378) + _64) * fDistortionCoef) + 1.0f;
        _444 = ((((_377 + 0.625f) * _378) + _64) * fDistortionCoef) + 1.0f;
        _449 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_444 * _67) + 0.5f), ((_444 * _69) + 0.5f)));
        _457 = ((((_377 + 0.75f) * _378) + _64) * fDistortionCoef) + 1.0f;
        _462 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_457 * _67) + 0.5f), ((_457 * _69) + 0.5f)));
        _477 = ((((_377 + 0.875f) * _378) + _64) * fDistortionCoef) + 1.0f;
        _489 = ((((_377 + 1.0f) * _378) + _64) * fDistortionCoef) + 1.0f;
        _1108 = (((((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_393 * _67) + 0.5f), ((_393 * _69) + 0.5f))))).x) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_382 * _67) + 0.5f), ((_382 * _69) + 0.5f))))).x)) + (_410.x * 0.75f)) + (_424.x * 0.375f)) * 0.3199999928474426f);
        _1109 = (((((_449.y + _424.y) * 0.625f) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_433 * _67) + 0.5f), ((_433 * _69) + 0.5f))))).y)) + ((_462.y + _410.y) * 0.25f)) * 0.3636363744735718f);
        _1110 = (((((_462.z * 0.75f) + (_449.z * 0.375f)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_477 * _67) + 0.5f), ((_477 * _69) + 0.5f))))).z)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_489 * _67) + 0.5f), ((_489 * _69) + 0.5f))))).z)) * 0.3199999928474426f);
        _1111 = fDistortionCoef;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = 0.0f;
        _1115 = 0.0f;
        _1116 = fCorrectCoef;
      } else {
        _501 = _365 + _64;
        _503 = (_501 * fDistortionCoef) + 1.0f;
        _510 = ((_501 + _365) * fDistortionCoef) + 1.0f;
        _1108 = (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_71, _72)))).x);
        _1109 = (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_503 * _67) + 0.5f), ((_503 * _69) + 0.5f))))).y);
        _1110 = (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_510 * _67) + 0.5f), ((_510 * _69) + 0.5f))))).z);
        _1111 = fDistortionCoef;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = 0.0f;
        _1115 = 0.0f;
        _1116 = fCorrectCoef;
      }
    }
  } else {
    if (_43) {
      _528 = screenInverseSize.x * 2.0f;
      _530 = screenInverseSize.y * 2.0f;
      _532 = (_528 * SV_Position.x) + -1.0f;
      _536 = sqrt((_532 * _532) + 1.0f);
      _537 = 1.0f / _536;
      _545 = ((_536 * fOptimizedParam.z) * (_537 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
      _546 = _545 * _532;
      _548 = (_545 * ((_530 * SV_Position.y) + -1.0f)) * (((_537 + -1.0f) * fOptimizedParam.y) + 1.0f);
      _549 = _546 + 0.5f;
      _550 = _548 + 0.5f;
      do {
        _815 = _549;
        _816 = _550;
        if (_45) {
          if (!(fHazeFilterReductionResolution == 0)) {
            _558 = HazeNoiseResult.Sample(BilinearWrap, float2(_549, _550));
            _815 = ((fHazeFilterScale * _558.x) + _549);
            _816 = ((fHazeFilterScale * _558.y) + _550);
          } else {
            _570 = ((fHazeFilterAttribute & 2) != 0);
            _574 = tFilterTempMap1.Sample(BilinearWrap, float2(_549, _550));
            do {
              if (_570) {
                _581 = ReadonlyDepth.SampleLevel(PointClamp, float2(_549, _550), 0.0f);
                _587 = ((_528 * screenSize.x) * _549) + -1.0f;
                _588 = 1.0f - ((_530 * screenSize.y) * _550);
                _625 = 1.0f / (mad(_581.x, (viewProjInvMat[2].w), mad(_588, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _587))) + (viewProjInvMat[3].w));
                _627 = _625 * (mad(_581.x, (viewProjInvMat[2].y), mad(_588, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _587))) + (viewProjInvMat[3].y));
                _635 = (_625 * (mad(_581.x, (viewProjInvMat[2].x), mad(_588, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _587))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _636 = _627 - (transposeViewInvMat[1].w);
                _637 = (_625 * (mad(_581.x, (viewProjInvMat[2].z), mad(_588, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _587))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _662 = saturate(max(((sqrt(((_636 * _636) + (_635 * _635)) + (_637 * _637)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_627 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _574.x);
                _663 = _581.x;
              } else {
                _662 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _574.x), _574.x);
                _663 = 0.0f;
              }
              do {
                _684 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _677 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _684 = (1.0f - saturate(max((_677 * min(max((abs(_546) - fHazeFilterBorder), 0.0f), 1.0f)), (_677 * min(max((abs(_548) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _685 = _684 * _662;
                do {
                  _806 = 0.0f;
                  _807 = 0.0f;
                  if (!(_685 <= 9.999999747378752e-06f)) {
                    _692 = -0.0f - _550;
                    _715 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_692, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _549))) * fHazeFilterUVWOffset.w;
                    _716 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_692, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _549))) * fHazeFilterUVWOffset.w;
                    _717 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_692, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _549))) * fHazeFilterUVWOffset.w;
                    _725 = _715 * 2.0f;
                    _726 = _716 * 2.0f;
                    _727 = _717 * 2.0f;
                    _735 = _715 * 4.0f;
                    _736 = _716 * 4.0f;
                    _737 = _717 * 4.0f;
                    _745 = _715 * 8.0f;
                    _746 = _716 * 8.0f;
                    _747 = _717 * 8.0f;
                    _755 = fHazeFilterUVWOffset.x + 0.5f;
                    _756 = fHazeFilterUVWOffset.y + 0.5f;
                    _757 = fHazeFilterUVWOffset.z + 0.5f;
                    _789 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_725 + fHazeFilterUVWOffset.x), (_726 + fHazeFilterUVWOffset.y), (_727 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_715 + fHazeFilterUVWOffset.x), (_716 + fHazeFilterUVWOffset.y), (_717 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_735 + fHazeFilterUVWOffset.x), (_736 + fHazeFilterUVWOffset.y), (_737 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_745 + fHazeFilterUVWOffset.x), (_746 + fHazeFilterUVWOffset.y), (_747 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _685;
                    _790 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_725 + _755), (_726 + _756), (_727 + _757)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_715 + _755), (_716 + _756), (_717 + _757)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_735 + _755), (_736 + _756), (_737 + _757)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_745 + _755), (_746 + _756), (_747 + _757)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _685;
                    if (_570) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _789) + _549), ((fHazeFilterScale * _790) + _550)))).x) - _663) >= fHazeFilterDepthDiffBias)) {
                        _806 = _789;
                        _807 = _790;
                      } else {
                        _806 = 0.0f;
                        _807 = 0.0f;
                      }
                    } else {
                      _806 = _789;
                      _807 = _790;
                    }
                  }
                  _815 = ((fHazeFilterScale * _806) + _549);
                  _816 = ((fHazeFilterScale * _807) + _550);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        _819 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_815, _816));
        _1108 = _819.x;
        _1109 = _819.y;
        _1110 = _819.z;
        _1111 = 0.0f;
        _1112 = fOptimizedParam.x;
        _1113 = fOptimizedParam.y;
        _1114 = fOptimizedParam.z;
        _1115 = fOptimizedParam.w;
        _1116 = 1.0f;
      } while (false);
    } else {
      _824 = screenInverseSize.x * SV_Position.x;
      _825 = screenInverseSize.y * SV_Position.y;
      if (!(_45)) {
        _829 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_824, _825));
        _1108 = _829.x;
        _1109 = _829.y;
        _1110 = _829.z;
        _1111 = 0.0f;
        _1112 = 0.0f;
        _1113 = 0.0f;
        _1114 = 0.0f;
        _1115 = 0.0f;
        _1116 = 1.0f;
      } else {
        do {
          if (!(fHazeFilterReductionResolution == 0)) {
            _840 = HazeNoiseResult.Sample(BilinearWrap, float2(_824, _825));
            _1097 = (fHazeFilterScale * _840.x);
            _1098 = (fHazeFilterScale * _840.y);
          } else {
            _850 = ((fHazeFilterAttribute & 2) != 0);
            _854 = tFilterTempMap1.Sample(BilinearWrap, float2(_824, _825));
            do {
              if (_850) {
                _861 = ReadonlyDepth.SampleLevel(PointClamp, float2(_824, _825), 0.0f);
                _869 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _824) + -1.0f;
                _870 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _825);
                _907 = 1.0f / (mad(_861.x, (viewProjInvMat[2].w), mad(_870, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _869))) + (viewProjInvMat[3].w));
                _909 = _907 * (mad(_861.x, (viewProjInvMat[2].y), mad(_870, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _869))) + (viewProjInvMat[3].y));
                _917 = (_907 * (mad(_861.x, (viewProjInvMat[2].x), mad(_870, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _869))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _918 = _909 - (transposeViewInvMat[1].w);
                _919 = (_907 * (mad(_861.x, (viewProjInvMat[2].z), mad(_870, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _869))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _944 = saturate(max(((sqrt(((_918 * _918) + (_917 * _917)) + (_919 * _919)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_909 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _854.x);
                _945 = _861.x;
              } else {
                _944 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _854.x), _854.x);
                _945 = 0.0f;
              }
              do {
                _968 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _961 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _968 = (1.0f - saturate(max((_961 * min(max((abs(_824 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)), (_961 * min(max((abs(_825 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _969 = _968 * _944;
                do {
                  _1090 = 0.0f;
                  _1091 = 0.0f;
                  if (!(_969 <= 9.999999747378752e-06f)) {
                    _976 = -0.0f - _825;
                    _999 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_976, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _824))) * fHazeFilterUVWOffset.w;
                    _1000 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_976, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _824))) * fHazeFilterUVWOffset.w;
                    _1001 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_976, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _824))) * fHazeFilterUVWOffset.w;
                    _1009 = _999 * 2.0f;
                    _1010 = _1000 * 2.0f;
                    _1011 = _1001 * 2.0f;
                    _1019 = _999 * 4.0f;
                    _1020 = _1000 * 4.0f;
                    _1021 = _1001 * 4.0f;
                    _1029 = _999 * 8.0f;
                    _1030 = _1000 * 8.0f;
                    _1031 = _1001 * 8.0f;
                    _1039 = fHazeFilterUVWOffset.x + 0.5f;
                    _1040 = fHazeFilterUVWOffset.y + 0.5f;
                    _1041 = fHazeFilterUVWOffset.z + 0.5f;
                    _1073 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1009 + fHazeFilterUVWOffset.x), (_1010 + fHazeFilterUVWOffset.y), (_1011 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_999 + fHazeFilterUVWOffset.x), (_1000 + fHazeFilterUVWOffset.y), (_1001 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1019 + fHazeFilterUVWOffset.x), (_1020 + fHazeFilterUVWOffset.y), (_1021 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1029 + fHazeFilterUVWOffset.x), (_1030 + fHazeFilterUVWOffset.y), (_1031 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _969;
                    _1074 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1009 + _1039), (_1010 + _1040), (_1011 + _1041)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_999 + _1039), (_1000 + _1040), (_1001 + _1041)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1019 + _1039), (_1020 + _1040), (_1021 + _1041)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1029 + _1039), (_1030 + _1040), (_1031 + _1041)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _969;
                    if (_850) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2(((fHazeFilterScale * _1073) + _824), ((fHazeFilterScale * _1074) + _825)))).x) - _945) >= fHazeFilterDepthDiffBias)) {
                        _1090 = _1073;
                        _1091 = _1074;
                      } else {
                        _1090 = 0.0f;
                        _1091 = 0.0f;
                      }
                    } else {
                      _1090 = _1073;
                      _1091 = _1074;
                    }
                  }
                  _1097 = (fHazeFilterScale * _1090);
                  _1098 = (fHazeFilterScale * _1091);
                } while (false);
              } while (false);
            } while (false);
          }
          _1103 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1097 + _824), (_1098 + _825)));
          _1108 = _1103.x;
          _1109 = _1103.y;
          _1110 = _1103.z;
          _1111 = 0.0f;
          _1112 = 0.0f;
          _1113 = 0.0f;
          _1114 = 0.0f;
          _1115 = 0.0f;
          _1116 = 1.0f;
        } while (false);
      }
    }
  }
  _1117 = Exposure * _1110;
  _1118 = Exposure * _1109;
  _1119 = Exposure * _1108;
  if (!((cPassEnabled & 32) == 0)) {
    _1142 = (float)((bool)(uint)((cbRadialBlurFlags & 2) != 0));
    _1146 = ComputeResultSRV[0].computeAlpha;
    _1149 = ((1.0f - _1142) + (_1146 * _1142)) * cbRadialColor.w;
    if (!(_1149 == 0.0f)) {
      _1152 = screenInverseSize.x * SV_Position.x;
      _1153 = screenInverseSize.y * SV_Position.y;
      _1155 = _1152 + (-0.5f - cbRadialScreenPos.x);
      _1157 = _1153 + (-0.5f - cbRadialScreenPos.y);
      _1160 = select((_1155 < 0.0f), (1.0f - _1152), _1152);
      _1163 = select((_1157 < 0.0f), (1.0f - _1153), _1153);
      do {
        _1189 = 1.0f;
        if (!((cbRadialBlurFlags & 1) == 0)) {
          _1169 = rsqrt(dot(float2(_1155, _1157), float2(_1155, _1157))) * cbRadialSharpRange;
          _1176 = uint(abs(_1169 * _1157)) + uint(abs(_1169 * _1155));
          _1180 = ((_1176 ^ 61) ^ ((uint)(_1176) >> 16)) * 9;
          _1183 = (((uint)(_1180) >> 4) ^ _1180) * 668265261;
          _1189 = (((float)((uint)((uint)(((uint)(_1183) >> 15) ^ _1183)))) * 2.3283064365386963e-10f);
        }
        _1193 = sqrt((_1155 * _1155) + (_1157 * _1157));
        _1195 = 1.0f / max(1.0f, _1193);
        _1196 = _1189 * _1160;
        _1197 = cbRadialBlurPower * _1195;
        _1198 = _1197 * -0.0011111111380159855f;
        _1200 = _1189 * _1163;
        _1204 = ((_1198 * _1196) + 1.0f) * _1155;
        _1205 = ((_1198 * _1200) + 1.0f) * _1157;
        _1207 = _1197 * -0.002222222276031971f;
        _1212 = ((_1207 * _1196) + 1.0f) * _1155;
        _1213 = ((_1207 * _1200) + 1.0f) * _1157;
        _1214 = _1197 * -0.0033333334140479565f;
        _1219 = ((_1214 * _1196) + 1.0f) * _1155;
        _1220 = ((_1214 * _1200) + 1.0f) * _1157;
        _1221 = _1197 * -0.004444444552063942f;
        _1226 = ((_1221 * _1196) + 1.0f) * _1155;
        _1227 = ((_1221 * _1200) + 1.0f) * _1157;
        _1228 = _1197 * -0.0055555556900799274f;
        _1233 = ((_1228 * _1196) + 1.0f) * _1155;
        _1234 = ((_1228 * _1200) + 1.0f) * _1157;
        _1235 = _1197 * -0.006666666828095913f;
        _1240 = ((_1235 * _1196) + 1.0f) * _1155;
        _1241 = ((_1235 * _1200) + 1.0f) * _1157;
        _1242 = _1197 * -0.007777777966111898f;
        _1247 = ((_1242 * _1196) + 1.0f) * _1155;
        _1248 = ((_1242 * _1200) + 1.0f) * _1157;
        _1249 = _1197 * -0.008888889104127884f;
        _1254 = ((_1249 * _1196) + 1.0f) * _1155;
        _1255 = ((_1249 * _1200) + 1.0f) * _1157;
        _1258 = _1195 * ((cbRadialBlurPower * -0.009999999776482582f) * _1189);
        _1263 = ((_1258 * _1160) + 1.0f) * _1155;
        _1264 = ((_1258 * _1163) + 1.0f) * _1157;
        do {
          if (_37) {
            _1266 = _1204 + cbRadialScreenPos.x;
            _1267 = _1205 + cbRadialScreenPos.y;
            _1271 = ((dot(float2(_1266, _1267), float2(_1266, _1267)) * _1111) + 1.0f) * _1116;
            _1277 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1271 * _1266) + 0.5f), ((_1271 * _1267) + 0.5f)), 0.0f);
            _1281 = _1212 + cbRadialScreenPos.x;
            _1282 = _1213 + cbRadialScreenPos.y;
            _1286 = ((dot(float2(_1281, _1282), float2(_1281, _1282)) * _1111) + 1.0f) * _1116;
            _1291 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1286 * _1281) + 0.5f), ((_1286 * _1282) + 0.5f)), 0.0f);
            _1298 = _1219 + cbRadialScreenPos.x;
            _1299 = _1220 + cbRadialScreenPos.y;
            _1303 = ((dot(float2(_1298, _1299), float2(_1298, _1299)) * _1111) + 1.0f) * _1116;
            _1308 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1303 * _1298) + 0.5f), ((_1303 * _1299) + 0.5f)), 0.0f);
            _1315 = _1226 + cbRadialScreenPos.x;
            _1316 = _1227 + cbRadialScreenPos.y;
            _1320 = ((dot(float2(_1315, _1316), float2(_1315, _1316)) * _1111) + 1.0f) * _1116;
            _1325 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1320 * _1315) + 0.5f), ((_1320 * _1316) + 0.5f)), 0.0f);
            _1332 = _1233 + cbRadialScreenPos.x;
            _1333 = _1234 + cbRadialScreenPos.y;
            _1337 = ((dot(float2(_1332, _1333), float2(_1332, _1333)) * _1111) + 1.0f) * _1116;
            _1342 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1337 * _1332) + 0.5f), ((_1337 * _1333) + 0.5f)), 0.0f);
            _1349 = _1240 + cbRadialScreenPos.x;
            _1350 = _1241 + cbRadialScreenPos.y;
            _1354 = ((dot(float2(_1349, _1350), float2(_1349, _1350)) * _1111) + 1.0f) * _1116;
            _1359 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1354 * _1349) + 0.5f), ((_1354 * _1350) + 0.5f)), 0.0f);
            _1366 = _1247 + cbRadialScreenPos.x;
            _1367 = _1248 + cbRadialScreenPos.y;
            _1371 = ((dot(float2(_1366, _1367), float2(_1366, _1367)) * _1111) + 1.0f) * _1116;
            _1376 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1371 * _1366) + 0.5f), ((_1371 * _1367) + 0.5f)), 0.0f);
            _1383 = _1254 + cbRadialScreenPos.x;
            _1384 = _1255 + cbRadialScreenPos.y;
            _1388 = ((dot(float2(_1383, _1384), float2(_1383, _1384)) * _1111) + 1.0f) * _1116;
            _1393 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1388 * _1383) + 0.5f), ((_1388 * _1384) + 0.5f)), 0.0f);
            _1400 = _1263 + cbRadialScreenPos.x;
            _1401 = _1264 + cbRadialScreenPos.y;
            _1405 = ((dot(float2(_1400, _1401), float2(_1400, _1401)) * _1111) + 1.0f) * _1116;
            _1410 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1405 * _1400) + 0.5f), ((_1405 * _1401) + 0.5f)), 0.0f);
            _1744 = ((((((((_1291.x + _1277.x) + _1308.x) + _1325.x) + _1342.x) + _1359.x) + _1376.x) + _1393.x) + _1410.x);
            _1745 = ((((((((_1291.y + _1277.y) + _1308.y) + _1325.y) + _1342.y) + _1359.y) + _1376.y) + _1393.y) + _1410.y);
            _1746 = ((((((((_1291.z + _1277.z) + _1308.z) + _1325.z) + _1342.z) + _1359.z) + _1376.z) + _1393.z) + _1410.z);
          } else {
            _1418 = cbRadialScreenPos.x + 0.5f;
            _1419 = _1204 + _1418;
            _1420 = cbRadialScreenPos.y + 0.5f;
            _1421 = _1205 + _1420;
            _1422 = _1212 + _1418;
            _1423 = _1213 + _1420;
            _1424 = _1219 + _1418;
            _1425 = _1220 + _1420;
            _1426 = _1226 + _1418;
            _1427 = _1227 + _1420;
            _1428 = _1233 + _1418;
            _1429 = _1234 + _1420;
            _1430 = _1240 + _1418;
            _1431 = _1241 + _1420;
            _1432 = _1247 + _1418;
            _1433 = _1248 + _1420;
            _1434 = _1254 + _1418;
            _1435 = _1255 + _1420;
            _1436 = _1263 + _1418;
            _1437 = _1264 + _1420;
            if (_43) {
              _1441 = (_1419 * 2.0f) + -1.0f;
              _1445 = sqrt((_1441 * _1441) + 1.0f);
              _1446 = 1.0f / _1445;
              _1453 = _1115 * 0.5f;
              _1454 = ((_1445 * _1114) * (_1446 + _1112)) * _1453;
              _1461 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1454 * _1441) + 0.5f), (((_1454 * ((_1421 * 2.0f) + -1.0f)) * (((_1446 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1467 = (_1422 * 2.0f) + -1.0f;
              _1471 = sqrt((_1467 * _1467) + 1.0f);
              _1472 = 1.0f / _1471;
              _1479 = ((_1471 * _1114) * (_1472 + _1112)) * _1453;
              _1485 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1479 * _1467) + 0.5f), (((_1479 * ((_1423 * 2.0f) + -1.0f)) * (((_1472 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1494 = (_1424 * 2.0f) + -1.0f;
              _1498 = sqrt((_1494 * _1494) + 1.0f);
              _1499 = 1.0f / _1498;
              _1506 = ((_1498 * _1114) * (_1499 + _1112)) * _1453;
              _1512 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1506 * _1494) + 0.5f), (((_1506 * ((_1425 * 2.0f) + -1.0f)) * (((_1499 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1521 = (_1426 * 2.0f) + -1.0f;
              _1525 = sqrt((_1521 * _1521) + 1.0f);
              _1526 = 1.0f / _1525;
              _1533 = ((_1525 * _1114) * (_1526 + _1112)) * _1453;
              _1539 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1533 * _1521) + 0.5f), (((_1533 * ((_1427 * 2.0f) + -1.0f)) * (((_1526 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1548 = (_1428 * 2.0f) + -1.0f;
              _1552 = sqrt((_1548 * _1548) + 1.0f);
              _1553 = 1.0f / _1552;
              _1560 = ((_1552 * _1114) * (_1553 + _1112)) * _1453;
              _1566 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1560 * _1548) + 0.5f), (((_1560 * ((_1429 * 2.0f) + -1.0f)) * (((_1553 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1575 = (_1430 * 2.0f) + -1.0f;
              _1579 = sqrt((_1575 * _1575) + 1.0f);
              _1580 = 1.0f / _1579;
              _1587 = ((_1579 * _1114) * (_1580 + _1112)) * _1453;
              _1593 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1587 * _1575) + 0.5f), (((_1587 * ((_1431 * 2.0f) + -1.0f)) * (((_1580 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1602 = (_1432 * 2.0f) + -1.0f;
              _1606 = sqrt((_1602 * _1602) + 1.0f);
              _1607 = 1.0f / _1606;
              _1614 = ((_1606 * _1114) * (_1607 + _1112)) * _1453;
              _1620 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1614 * _1602) + 0.5f), (((_1614 * ((_1433 * 2.0f) + -1.0f)) * (((_1607 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1629 = (_1434 * 2.0f) + -1.0f;
              _1633 = sqrt((_1629 * _1629) + 1.0f);
              _1634 = 1.0f / _1633;
              _1641 = ((_1633 * _1114) * (_1634 + _1112)) * _1453;
              _1647 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1641 * _1629) + 0.5f), (((_1641 * ((_1435 * 2.0f) + -1.0f)) * (((_1634 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1656 = (_1436 * 2.0f) + -1.0f;
              _1660 = sqrt((_1656 * _1656) + 1.0f);
              _1661 = 1.0f / _1660;
              _1668 = ((_1660 * _1114) * (_1661 + _1112)) * _1453;
              _1674 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1668 * _1656) + 0.5f), (((_1668 * ((_1437 * 2.0f) + -1.0f)) * (((_1661 + -1.0f) * _1113) + 1.0f)) + 0.5f)), 0.0f);
              _1744 = ((((((((_1485.x + _1461.x) + _1512.x) + _1539.x) + _1566.x) + _1593.x) + _1620.x) + _1647.x) + _1674.x);
              _1745 = ((((((((_1485.y + _1461.y) + _1512.y) + _1539.y) + _1566.y) + _1593.y) + _1620.y) + _1647.y) + _1674.y);
              _1746 = ((((((((_1485.z + _1461.z) + _1512.z) + _1539.z) + _1566.z) + _1593.z) + _1620.z) + _1647.z) + _1674.z);
            } else {
              _1683 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1419, _1421), 0.0f);
              _1687 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1422, _1423), 0.0f);
              _1694 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1424, _1425), 0.0f);
              _1701 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1426, _1427), 0.0f);
              _1708 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1428, _1429), 0.0f);
              _1715 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1430, _1431), 0.0f);
              _1722 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1432, _1433), 0.0f);
              _1729 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1434, _1435), 0.0f);
              _1736 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1436, _1437), 0.0f);
              _1744 = ((((((((_1687.x + _1683.x) + _1694.x) + _1701.x) + _1708.x) + _1715.x) + _1722.x) + _1729.x) + _1736.x);
              _1745 = ((((((((_1687.y + _1683.y) + _1694.y) + _1701.y) + _1708.y) + _1715.y) + _1722.y) + _1729.y) + _1736.y);
              _1746 = ((((((((_1687.z + _1683.z) + _1694.z) + _1701.z) + _1708.z) + _1715.z) + _1722.z) + _1729.z) + _1736.z);
            }
          }
          _1756 = (cbRadialColor.z * (Exposure * (_1110 + _1746))) * 0.10000000149011612f;
          _1757 = (cbRadialColor.y * (Exposure * (_1109 + _1745))) * 0.10000000149011612f;
          _1758 = (cbRadialColor.x * (Exposure * (_1108 + _1744))) * 0.10000000149011612f;
          do {
            _1780 = _1758;
            _1781 = _1757;
            _1782 = _1756;
            if (cbRadialMaskRate.x > 0.0f) {
              _1763 = saturate((_1193 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              _1769 = (((_1763 * _1763) * cbRadialMaskRate.x) * (3.0f - (_1763 * 2.0f))) + cbRadialMaskRate.y;
              _1780 = ((_1769 * (_1758 - _1119)) + _1119);
              _1781 = ((_1769 * (_1757 - _1118)) + _1118);
              _1782 = ((_1769 * (_1756 - _1117)) + _1117);
            }
            _1793 = (lerp(_1119, _1780, _1149));
            _1794 = (lerp(_1118, _1781, _1149));
            _1795 = (lerp(_1117, _1782, _1149));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1793 = _1119;
      _1794 = _1118;
      _1795 = _1117;
    }
  } else {
    _1793 = _1119;
    _1794 = _1118;
    _1795 = _1117;
  }
  if (!((cPassEnabled & 2) == 0)) {
    _1812 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    _1814 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    _1820 = frac(frac((_1814 * 0.005837149918079376f) + (_1812 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      _1834 = 0.0f;
      if (_1820 < fNoiseDensity) {
        _1825 = (int)(uint(_1814 * _1812)) ^ 12345391;
        _1826 = _1825 * 3635641;
        _1834 = (((float)((uint)((uint)((((uint)(_1826) >> 26) | ((int)(_1825 * 232681024))) ^ _1826)))) * 2.3283064365386963e-10f);
      }
      _1836 = frac(_1820 * 757.4846801757812f);
      do {
        _1850 = 0.0f;
        if (_1836 < fNoiseDensity) {
          _1840 = asint(_1836) ^ 12345391;
          _1841 = _1840 * 3635641;
          _1850 = ((((float)((uint)((uint)((((uint)(_1841) >> 26) | ((int)(_1840 * 232681024))) ^ _1841)))) * 2.3283064365386963e-10f) + -0.5f);
        }
        _1852 = frac(_1836 * 757.4846801757812f);
        do {
          _1866 = 0.0f;
          if (_1852 < fNoiseDensity) {
            _1856 = asint(_1852) ^ 12345391;
            _1857 = _1856 * 3635641;
            _1866 = ((((float)((uint)((uint)((((uint)(_1857) >> 26) | ((int)(_1856 * 232681024))) ^ _1857)))) * 2.3283064365386963e-10f) + -0.5f);
          }
          _1867 = _1834 * fNoisePower.x;
          _1868 = _1866 * fNoisePower.y;
          _1869 = _1850 * fNoisePower.y;
          _1883 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1793), saturate(_1794), saturate(_1795)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1894 = ((_1883 * (mad(_1869, 1.4019999504089355f, _1867) - _1793)) + _1793);
          _1895 = ((_1883 * (mad(_1869, -0.7139999866485596f, mad(_1868, -0.3440000116825104f, _1867)) - _1794)) + _1794);
          _1896 = ((_1883 * (mad(_1868, 1.7719999551773071f, _1867) - _1795)) + _1795);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1894 = _1793;
    _1895 = _1794;
    _1896 = _1795;
  }
  _1911 = mad(_1896, (fOCIOTransformMatrix[2].x), mad(_1895, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1894)));
  _1914 = mad(_1896, (fOCIOTransformMatrix[2].y), mad(_1895, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1894)));
  _1917 = mad(_1896, (fOCIOTransformMatrix[2].z), mad(_1895, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1894)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    _1923 = max(max(_1911, _1914), _1917);
    if (!(_1923 == 0.0f)) {
      _1929 = abs(_1923);
      _1930 = (_1923 - _1911) / _1929;
      _1931 = (_1923 - _1914) / _1929;
      _1932 = (_1923 - _1917) / _1929;
      do {
        _1954 = _1930;
        if (!(!(_1930 >= cbControlRGCParam.CyanThreshold))) {
          _1942 = _1930 - cbControlRGCParam.CyanThreshold;
          _1954 = ((_1942 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1942) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        }
        do {
          _1975 = _1931;
          if (!(!(_1931 >= cbControlRGCParam.MagentaThreshold))) {
            _1963 = _1931 - cbControlRGCParam.MagentaThreshold;
            _1975 = ((_1963 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1963) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          }
          do {
            _1995 = _1932;
            if (!(!(_1932 >= cbControlRGCParam.YellowThreshold))) {
              _1983 = _1932 - cbControlRGCParam.YellowThreshold;
              _1995 = ((_1983 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1983) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            }
            _2003 = (_1923 - (_1954 * _1929));
            _2004 = (_1923 - (_1975 * _1929));
            _2005 = (_1923 - (_1995 * _1929));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _2003 = _1911;
      _2004 = _1914;
      _2005 = _1917;
    }
  } else {
    _2003 = _1911;
    _2004 = _1914;
    _2005 = _1917;
  }
#if 1
  ApplyColorCorrectTexturePass(
      (cPassEnabled & 4) != 0,
      _2003, _2004, _2005,
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
      _2424, _2425, _2426);
#else
  if (!((cPassEnabled & 4) == 0)) {
    _2031 = !(_2003 <= 0.0078125f);
    do {
      if (!(_2031)) {
        _2040 = ((_2003 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2040 = ((log2(_2003) + 9.720000267028809f) * 0.05707762390375137f);
      }
      _2041 = !(_2004 <= 0.0078125f);
      do {
        if (!(_2041)) {
          _2050 = ((_2004 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2050 = ((log2(_2004) + 9.720000267028809f) * 0.05707762390375137f);
        }
        _2051 = !(_2005 <= 0.0078125f);
        do {
          if (!(_2051)) {
            _2060 = ((_2005 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _2060 = ((log2(_2005) + 9.720000267028809f) * 0.05707762390375137f);
          }
          _2069 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_2040 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2050 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2060 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_2069.x < 0.155251145362854f) {
              _2086 = ((_2069.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((_2069.x >= 0.155251145362854f) && (_2069.x < 1.4679962396621704f)) {
                _2086 = exp2((_2069.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _2086 = 65504.0f;
              }
            }
            do {
              if (_2069.y < 0.155251145362854f) {
                _2100 = ((_2069.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_2069.y >= 0.155251145362854f) && (_2069.y < 1.4679962396621704f)) {
                  _2100 = exp2((_2069.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _2100 = 65504.0f;
                }
              }
              do {
                if (_2069.z < 0.155251145362854f) {
                  _2114 = ((_2069.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_2069.z >= 0.155251145362854f) && (_2069.z < 1.4679962396621704f)) {
                    _2114 = exp2((_2069.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _2114 = 65504.0f;
                  }
                }
                _2115 = max(_2086, 0.0f);
                _2116 = max(_2100, 0.0f);
                _2117 = max(_2114, 0.0f);
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!(_2031)) {
                        _2128 = ((_2003 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _2128 = ((log2(_2003) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(_2041)) {
                          _2137 = ((_2004 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2137 = ((log2(_2004) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(_2051)) {
                            _2146 = ((_2005 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2146 = ((log2(_2005) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          _2154 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_2128 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2137 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2146 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_2154.x < 0.155251145362854f) {
                              _2171 = ((_2154.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((_2154.x >= 0.155251145362854f) && (_2154.x < 1.4679962396621704f)) {
                                _2171 = exp2((_2154.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _2171 = 65504.0f;
                              }
                            }
                            do {
                              if (_2154.y < 0.155251145362854f) {
                                _2185 = ((_2154.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_2154.y >= 0.155251145362854f) && (_2154.y < 1.4679962396621704f)) {
                                  _2185 = exp2((_2154.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2185 = 65504.0f;
                                }
                              }
                              do {
                                if (_2154.z < 0.155251145362854f) {
                                  _2199 = ((_2154.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_2154.z >= 0.155251145362854f) && (_2154.z < 1.4679962396621704f)) {
                                    _2199 = exp2((_2154.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2199 = 65504.0f;
                                  }
                                }
                                _2209 = ((max(_2171, 0.0f) - _2115) * fTextureBlendRate) + _2115;
                                _2210 = ((max(_2185, 0.0f) - _2116) * fTextureBlendRate) + _2116;
                                _2211 = ((max(_2199, 0.0f) - _2117) * fTextureBlendRate) + _2117;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_2209 <= 0.0078125f))) {
                                      _2223 = ((_2209 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _2223 = ((log2(_2209) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_2210 <= 0.0078125f))) {
                                        _2233 = ((_2210 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _2233 = ((log2(_2210) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_2211 <= 0.0078125f))) {
                                          _2243 = ((_2211 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _2243 = ((log2(_2211) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        _2251 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2223 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2233 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2243 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_2251.x < 0.155251145362854f) {
                                            _2268 = ((_2251.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((_2251.x >= 0.155251145362854f) && (_2251.x < 1.4679962396621704f)) {
                                              _2268 = exp2((_2251.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _2268 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_2251.y < 0.155251145362854f) {
                                              _2282 = ((_2251.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((_2251.y >= 0.155251145362854f) && (_2251.y < 1.4679962396621704f)) {
                                                _2282 = exp2((_2251.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _2282 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_2251.z < 0.155251145362854f) {
                                                _2296 = ((_2251.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((_2251.z >= 0.155251145362854f) && (_2251.z < 1.4679962396621704f)) {
                                                  _2296 = exp2((_2251.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _2296 = 65504.0f;
                                                }
                                              }
                                              _2408 = (((max(_2268, 0.0f) - _2209) * fTextureBlendRate2) + _2209);
                                              _2409 = (((max(_2282, 0.0f) - _2210) * fTextureBlendRate2) + _2210);
                                              _2410 = (((max(_2296, 0.0f) - _2211) * fTextureBlendRate2) + _2211);
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _2408 = _2209;
                                  _2409 = _2210;
                                  _2410 = _2211;
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
                        if (!(!(_2115 <= 0.0078125f))) {
                          _2321 = ((_2115 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2321 = ((log2(_2115) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_2116 <= 0.0078125f))) {
                            _2331 = ((_2116 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2331 = ((log2(_2116) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_2117 <= 0.0078125f))) {
                              _2341 = ((_2117 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _2341 = ((log2(_2117) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            _2349 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2321 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2331 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2341 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_2349.x < 0.155251145362854f) {
                                _2366 = ((_2349.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_2349.x >= 0.155251145362854f) && (_2349.x < 1.4679962396621704f)) {
                                  _2366 = exp2((_2349.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2366 = 65504.0f;
                                }
                              }
                              do {
                                if (_2349.y < 0.155251145362854f) {
                                  _2380 = ((_2349.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_2349.y >= 0.155251145362854f) && (_2349.y < 1.4679962396621704f)) {
                                    _2380 = exp2((_2349.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2380 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_2349.z < 0.155251145362854f) {
                                    _2394 = ((_2349.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((_2349.z >= 0.155251145362854f) && (_2349.z < 1.4679962396621704f)) {
                                      _2394 = exp2((_2349.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _2394 = 65504.0f;
                                    }
                                  }
                                  _2408 = (((max(_2366, 0.0f) - _2115) * fTextureBlendRate2) + _2115);
                                  _2409 = (((max(_2380, 0.0f) - _2116) * fTextureBlendRate2) + _2116);
                                  _2410 = (((max(_2394, 0.0f) - _2117) * fTextureBlendRate2) + _2117);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _2408 = _2115;
                      _2409 = _2116;
                      _2410 = _2117;
                    }
                  }
                  _2424 = (mad(_2410, (fColorMatrix[2].x), mad(_2409, (fColorMatrix[1].x), (_2408 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _2425 = (mad(_2410, (fColorMatrix[2].y), mad(_2409, (fColorMatrix[1].y), (_2408 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _2426 = (mad(_2410, (fColorMatrix[2].z), mad(_2409, (fColorMatrix[1].z), (_2408 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2424 = _2003;
    _2425 = _2004;
    _2426 = _2005;
  }
#endif
  _2427 = min(_2424, 65000.0f);
  _2428 = min(_2425, 65000.0f);
  _2429 = min(_2426, 65000.0f);
  _2432 = isfinite(max(max(_2427, _2428), _2429));
  _2433 = select(_2432, _2427, 1.0f);
  _2434 = select(_2432, _2428, 1.0f);
  _2435 = select(_2432, _2429, 1.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2467 = (((cvdR.x * _2433) + (cvdR.y * _2434)) + (cvdR.z * _2435));
    _2468 = (((cvdG.x * _2433) + (cvdG.y * _2434)) + (cvdG.z * _2435));
    _2469 = (((cvdB.x * _2433) + (cvdB.y * _2434)) + (cvdB.z * _2435));
  } else {
    _2467 = _2433;
    _2468 = _2434;
    _2469 = _2435;
  }
  if (!((cPassEnabled & 16) == 0)) {
    _2481 = screenInverseSize.x * SV_Position.x;
    _2482 = screenInverseSize.y * SV_Position.y;
    _2485 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2481, _2482), 0.0f);
    _2490 = _2485.x * ColorParam.x;
    _2491 = _2485.y * ColorParam.y;
    _2492 = _2485.z * ColorParam.z;
    _2500 = (_2485.w * ColorParam.w) * saturate((((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2481, _2482), 0.0f)).x) * Levels_Rate) + Levels_Range);
    do {
      if (_2490 < 0.5f) {
        _2512 = ((_2467 * 2.0f) * _2490);
      } else {
        _2512 = (1.0f - (((1.0f - _2467) * 2.0f) * (1.0f - _2490)));
      }
      do {
        if (_2491 < 0.5f) {
          _2524 = ((_2468 * 2.0f) * _2491);
        } else {
          _2524 = (1.0f - (((1.0f - _2468) * 2.0f) * (1.0f - _2491)));
        }
        do {
          if (_2492 < 0.5f) {
            _2536 = ((_2469 * 2.0f) * _2492);
          } else {
            _2536 = (1.0f - (((1.0f - _2469) * 2.0f) * (1.0f - _2492)));
          }
          _2547 = (lerp(_2467, _2512, _2500));
          _2548 = (lerp(_2468, _2524, _2500));
          _2549 = (lerp(_2469, _2536, _2500));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2547 = _2467;
    _2548 = _2468;
    _2549 = _2469;
  }
#if 1
  ApplyCapcomExponentialToneMap(
      _2547, _2548, _2549,
      _2654, _2655, _2656,
      contrast, linearBegin, toe, maxNit, linearStart,
      displayMaxNitSubContrastFactor, contrastFactor, mulLinearStartContrastFactor,
      invLinearBegin, madLinearStartContrastFactor, tonemapParam_isHDRMode);
#else
  if (tonemapParam_isHDRMode == 0.0f) {
    _2557 = invLinearBegin * _2547;
    do {
      _2565 = 1.0f;
      if (!(_2547 >= linearBegin)) {
        _2565 = ((_2557 * _2557) * (3.0f - (_2557 * 2.0f)));
      }
      _2566 = invLinearBegin * _2548;
      do {
        _2574 = 1.0f;
        if (!(_2548 >= linearBegin)) {
          _2574 = ((_2566 * _2566) * (3.0f - (_2566 * 2.0f)));
        }
        _2575 = invLinearBegin * _2549;
        do {
          _2583 = 1.0f;
          if (!(_2549 >= linearBegin)) {
            _2583 = ((_2575 * _2575) * (3.0f - (_2575 * 2.0f)));
          }
          _2592 = select((_2547 < linearStart), 0.0f, 1.0f);
          _2593 = select((_2548 < linearStart), 0.0f, 1.0f);
          _2594 = select((_2549 < linearStart), 0.0f, 1.0f);
          _2654 = (((((1.0f - _2565) * linearBegin) * (pow(_2557, toe))) + ((_2565 - _2592) * ((contrast * _2547) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2547) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2592));
          _2655 = (((((1.0f - _2574) * linearBegin) * (pow(_2566, toe))) + ((_2574 - _2593) * ((contrast * _2548) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2548) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2593));
          _2656 = (((((1.0f - _2583) * linearBegin) * (pow(_2575, toe))) + ((_2583 - _2594) * ((contrast * _2549) + madLinearStartContrastFactor))) + ((maxNit - (exp2((contrastFactor * _2549) + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor)) * _2594));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2654 = _2547;
    _2655 = _2548;
    _2656 = _2549;
  }
#endif
  SV_Target.x = _2654;
  SV_Target.y = _2655;
  SV_Target.z = _2656;
  SV_Target.w = 0.0f;
  return SV_Target;
}

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
  bool _37;
  bool _43;
  bool _49;
  float _98;
  float _244;
  float _245;
  float _266;
  float _385;
  float _386;
  float _394;
  float _395;
  float _723;
  float _724;
  float _745;
  float _864;
  float _865;
  float _873;
  float _874;
  float _1005;
  float _1006;
  float _1029;
  float _1148;
  float _1149;
  float _1155;
  float _1156;
  float _1166;
  float _1167;
  float _1168;
  float _1173;
  float _1174;
  float _1175;
  float _1176;
  float _1177;
  float _1178;
  float _1179;
  float _1180;
  float _1181;
  float _1251;
  float _1806;
  float _1807;
  float _1808;
  float _1842;
  float _1843;
  float _1844;
  float _1855;
  float _1856;
  float _1857;
  float _1896;
  float _1912;
  float _1928;
  float _1956;
  float _1957;
  float _1958;
  float _2016;
  float _2037;
  float _2057;
  float _2065;
  float _2066;
  float _2067;
  float _2102;
  float _2112;
  float _2122;
  float _2148;
  float _2162;
  float _2176;
  float _2187;
  float _2196;
  float _2205;
  float _2230;
  float _2244;
  float _2258;
  float _2279;
  float _2289;
  float _2299;
  float _2324;
  float _2338;
  float _2352;
  float _2374;
  float _2384;
  float _2394;
  float _2419;
  float _2433;
  float _2447;
  float _2458;
  float _2459;
  float _2460;
  float _2474;
  float _2475;
  float _2476;
  float _2514;
  float _2515;
  float _2516;
  float _2559;
  float _2571;
  float _2583;
  float _2594;
  float _2595;
  float _2596;
  float _2657;
  float _2690;
  float _2701;
  float _2712;
  float _2713;
  float _2714;
  bool _51;
  float _59;
  float _60;
  float _61;
  float _65;
  float _70;
  float _81;
  float _83;
  float _85;
  float _93;
  float _101;
  float _118;
  float _119;
  float _120;
  float _122;
  float _123;
  float _124;
  float _125;
  float _126;
  float _127;
  float _128;
  float2 _138;
  bool _150;
  float _154;
  float _161;
  float _169;
  float _170;
  float _207;
  float _209;
  float _217;
  float _218;
  float _219;
  float _259;
  float _267;
  float _274;
  float _297;
  float _298;
  float _299;
  float _307;
  float _308;
  float _309;
  float _317;
  float _318;
  float _319;
  float _327;
  float _328;
  float _329;
  float _337;
  float _338;
  float _339;
  float _371;
  float _372;
  float4 _398;
  float _421;
  float _433;
  float _434;
  float _438;
  float _449;
  float _461;
  float4 _466;
  float _475;
  float4 _480;
  float _489;
  float _500;
  float4 _505;
  float _513;
  float4 _518;
  float _533;
  float _545;
  float _553;
  float _559;
  float _561;
  float _568;
  float _589;
  float _591;
  float _593;
  float _597;
  float _598;
  float _606;
  float _607;
  float _609;
  float _610;
  float _611;
  float2 _619;
  bool _631;
  float _635;
  float _642;
  float _648;
  float _649;
  float _686;
  float _688;
  float _696;
  float _697;
  float _698;
  float _738;
  float _746;
  float _753;
  float _776;
  float _777;
  float _778;
  float _786;
  float _787;
  float _788;
  float _796;
  float _797;
  float _798;
  float _806;
  float _807;
  float _808;
  float _816;
  float _817;
  float _818;
  float _850;
  float _851;
  float4 _877;
  float _885;
  float _886;
  float4 _890;
  float2 _901;
  bool _911;
  float _915;
  float _922;
  float _930;
  float _931;
  float _968;
  float _970;
  float _978;
  float _979;
  float _980;
  float _1022;
  float _1030;
  float _1037;
  float _1060;
  float _1061;
  float _1062;
  float _1070;
  float _1071;
  float _1072;
  float _1080;
  float _1081;
  float _1082;
  float _1090;
  float _1091;
  float _1092;
  float _1100;
  float _1101;
  float _1102;
  float _1134;
  float _1135;
  float4 _1161;
  float _1204;
  float _1208;
  float _1211;
  float _1214;
  float _1215;
  float _1217;
  float _1219;
  float _1222;
  float _1225;
  float _1231;
  uint _1238;
  uint _1242;
  uint _1245;
  float _1255;
  float _1257;
  float _1258;
  float _1259;
  float _1260;
  float _1262;
  float _1266;
  float _1267;
  float _1269;
  float _1274;
  float _1275;
  float _1276;
  float _1281;
  float _1282;
  float _1283;
  float _1288;
  float _1289;
  float _1290;
  float _1295;
  float _1296;
  float _1297;
  float _1302;
  float _1303;
  float _1304;
  float _1309;
  float _1310;
  float _1311;
  float _1316;
  float _1317;
  float _1320;
  float _1325;
  float _1326;
  float _1328;
  float _1329;
  float _1333;
  float4 _1339;
  float _1343;
  float _1344;
  float _1348;
  float4 _1353;
  float _1360;
  float _1361;
  float _1365;
  float4 _1370;
  float _1377;
  float _1378;
  float _1382;
  float4 _1387;
  float _1394;
  float _1395;
  float _1399;
  float4 _1404;
  float _1411;
  float _1412;
  float _1416;
  float4 _1421;
  float _1428;
  float _1429;
  float _1433;
  float4 _1438;
  float _1445;
  float _1446;
  float _1450;
  float4 _1455;
  float _1462;
  float _1463;
  float _1467;
  float4 _1472;
  float _1480;
  float _1481;
  float _1482;
  float _1483;
  float _1484;
  float _1485;
  float _1486;
  float _1487;
  float _1488;
  float _1489;
  float _1490;
  float _1491;
  float _1492;
  float _1493;
  float _1494;
  float _1495;
  float _1496;
  float _1497;
  float _1498;
  float _1499;
  float _1503;
  float _1507;
  float _1508;
  float _1515;
  float _1516;
  float4 _1523;
  float _1529;
  float _1533;
  float _1534;
  float _1541;
  float4 _1547;
  float _1556;
  float _1560;
  float _1561;
  float _1568;
  float4 _1574;
  float _1583;
  float _1587;
  float _1588;
  float _1595;
  float4 _1601;
  float _1610;
  float _1614;
  float _1615;
  float _1622;
  float4 _1628;
  float _1637;
  float _1641;
  float _1642;
  float _1649;
  float4 _1655;
  float _1664;
  float _1668;
  float _1669;
  float _1676;
  float4 _1682;
  float _1691;
  float _1695;
  float _1696;
  float _1703;
  float4 _1709;
  float _1718;
  float _1722;
  float _1723;
  float _1730;
  float4 _1736;
  float4 _1745;
  float4 _1749;
  float4 _1756;
  float4 _1763;
  float4 _1770;
  float4 _1777;
  float4 _1784;
  float4 _1791;
  float4 _1798;
  float _1818;
  float _1819;
  float _1820;
  float _1825;
  float _1831;
  float _1874;
  float _1876;
  float _1882;
  int _1887;
  uint _1888;
  float _1898;
  int _1902;
  uint _1903;
  float _1914;
  int _1918;
  uint _1919;
  float _1929;
  float _1930;
  float _1931;
  float _1945;
  float _1973;
  float _1976;
  float _1979;
  float _1985;
  float _1991;
  float _1992;
  float _1993;
  float _1994;
  float _2004;
  float _2025;
  float _2045;
  bool _2093;
  bool _2103;
  bool _2113;
  float4 _2131;
  float4 _2213;
  float _2265;
  float _2266;
  float _2267;
  float4 _2307;
  float4 _2402;
  float _2477;
  float _2478;
  float _2479;
  float _2528;
  float _2529;
  float4 _2532;
  float _2537;
  float _2538;
  float _2539;
  float _2547;
  float _2636;
  float _2639;
  float _2644;
  float _2645;
  float _2646;
  float _2659;
  float _2663;
  _37 = ((cPassEnabled & 1) == 0);
  if (!(_37)) {
    _43 = (distortionType == 0);
  } else {
    _43 = false;
  }
  if (!(_37)) {
    _49 = (distortionType == 1);
  } else {
    _49 = false;
  }
  _51 = ((cPassEnabled & 64) != 0);
  [branch]
  if (film_aspect == 0.0f) {
    _59 = Kerare.x / Kerare.w;
    _60 = Kerare.y / Kerare.w;
    _61 = Kerare.z / Kerare.w;
    _65 = abs(rsqrt(dot(float3(_59, _60, _61), float3(_59, _60, _61))) * _61);
    _70 = _65 * _65;
    _98 = ((_70 * _70) * (1.0f - saturate((_65 * kerare_scale) + kerare_offset)));
  } else {
    _81 = ((screenInverseSize.y * SV_Position.y) + -0.5f) * 2.0f;
    _83 = (film_aspect * 2.0f) * ((screenInverseSize.x * SV_Position.x) + -0.5f);
    _85 = sqrt(dot(float2(_83, _81), float2(_83, _81)));
    _93 = (_85 * _85) + 1.0f;
    _98 = ((1.0f / (_93 * _93)) * (1.0f - saturate(((1.0f / (_85 + 1.0f)) * kerare_scale) + kerare_offset)));
  }
  _101 = saturate(_98 + kerare_brightness) * Exposure;
  if (_43) {
    _118 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    _119 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    _120 = dot(float2(_118, _119), float2(_118, _119));
    _122 = (_120 * fDistortionCoef) + 1.0f;
    _123 = fCorrectCoef * _118;
    _124 = _122 * _123;
    _125 = fCorrectCoef * _119;
    _126 = _122 * _125;
    _127 = _124 + 0.5f;
    _128 = _126 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        _394 = _127;
        _395 = _128;
        if (_51) {
          if (!(fHazeFilterReductionResolution == 0)) {
            _138 = HazeNoiseResult.Sample(BilinearWrap, float2(_127, _128));
            _394 = ((fHazeFilterScale * _138.x) + _127);
            _395 = ((fHazeFilterScale * _138.y) + _128);
          } else {
            _150 = ((fHazeFilterAttribute & 2) != 0);
            _154 = tFilterTempMap1.Sample(BilinearWrap, float2(_127, _128));
            do {
              if (_150) {
                _161 = ReadonlyDepth.SampleLevel(PointClamp, float2(_127, _128), 0.0f);
                _169 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _127) + -1.0f;
                _170 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _128);
                _207 = 1.0f / (mad(_161.x, (viewProjInvMat[2].w), mad(_170, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _169))) + (viewProjInvMat[3].w));
                _209 = _207 * (mad(_161.x, (viewProjInvMat[2].y), mad(_170, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _169))) + (viewProjInvMat[3].y));
                _217 = (_207 * (mad(_161.x, (viewProjInvMat[2].x), mad(_170, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _169))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _218 = _209 - (transposeViewInvMat[1].w);
                _219 = (_207 * (mad(_161.x, (viewProjInvMat[2].z), mad(_170, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _169))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _244 = saturate(max(((sqrt(((_218 * _218) + (_217 * _217)) + (_219 * _219)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_209 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _154.x);
                _245 = _161.x;
              } else {
                _244 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _154.x), _154.x);
                _245 = 0.0f;
              }
              do {
                _266 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _259 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _266 = (1.0f - saturate(max((_259 * min(max((abs(_124) - fHazeFilterBorder), 0.0f), 1.0f)), (_259 * min(max((abs(_126) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _267 = _266 * _244;
                do {
                  _385 = 0.0f;
                  _386 = 0.0f;
                  if (!(_267 <= 9.999999747378752e-06f)) {
                    _274 = -0.0f - _128;
                    _297 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_274, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _127))) * fHazeFilterUVWOffset.w;
                    _298 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_274, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _127))) * fHazeFilterUVWOffset.w;
                    _299 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_274, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _127))) * fHazeFilterUVWOffset.w;
                    _307 = _297 * 2.0f;
                    _308 = _298 * 2.0f;
                    _309 = _299 * 2.0f;
                    _317 = _297 * 4.0f;
                    _318 = _298 * 4.0f;
                    _319 = _299 * 4.0f;
                    _327 = _297 * 8.0f;
                    _328 = _298 * 8.0f;
                    _329 = _299 * 8.0f;
                    _337 = fHazeFilterUVWOffset.x + 0.5f;
                    _338 = fHazeFilterUVWOffset.y + 0.5f;
                    _339 = fHazeFilterUVWOffset.z + 0.5f;
                    _371 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_307 + fHazeFilterUVWOffset.x), (_308 + fHazeFilterUVWOffset.y), (_309 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_297 + fHazeFilterUVWOffset.x), (_298 + fHazeFilterUVWOffset.y), (_299 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_317 + fHazeFilterUVWOffset.x), (_318 + fHazeFilterUVWOffset.y), (_319 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_327 + fHazeFilterUVWOffset.x), (_328 + fHazeFilterUVWOffset.y), (_329 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _267;
                    _372 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_307 + _337), (_308 + _338), (_309 + _339)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_297 + _337), (_298 + _338), (_299 + _339)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_317 + _337), (_318 + _338), (_319 + _339)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_327 + _337), (_328 + _338), (_329 + _339)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _267;
                    if (_150) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2((_371 + _127), (_372 + _128)))).x) - _245) >= fHazeFilterDepthDiffBias)) {
                        _385 = _371;
                        _386 = _372;
                      } else {
                        _385 = 0.0f;
                        _386 = 0.0f;
                      }
                    } else {
                      _385 = _371;
                      _386 = _372;
                    }
                  }
                  _394 = ((fHazeFilterScale * _385) + _127);
                  _395 = ((fHazeFilterScale * _386) + _128);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        _398 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_394, _395));
        _1173 = (_398.x * _101);
        _1174 = (_398.y * _101);
        _1175 = (_398.z * _101);
        _1176 = fDistortionCoef;
        _1177 = 0.0f;
        _1178 = 0.0f;
        _1179 = 0.0f;
        _1180 = 0.0f;
        _1181 = fCorrectCoef;
      } while (false);
    } else {
      _421 = ((saturate((sqrt((_118 * _118) + (_119 * _119)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      if (!(aberrationBlurEnable == 0)) {
        _433 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
        _434 = _421 * 2.0f;
        _438 = (((_433 * _434) + _120) * fDistortionCoef) + 1.0f;
        _449 = ((((_433 + 0.125f) * _434) + _120) * fDistortionCoef) + 1.0f;
        _461 = ((((_433 + 0.25f) * _434) + _120) * fDistortionCoef) + 1.0f;
        _466 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_461 * _123) + 0.5f), ((_461 * _125) + 0.5f)));
        _475 = ((((_433 + 0.375f) * _434) + _120) * fDistortionCoef) + 1.0f;
        _480 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_475 * _123) + 0.5f), ((_475 * _125) + 0.5f)));
        _489 = ((((_433 + 0.5f) * _434) + _120) * fDistortionCoef) + 1.0f;
        _500 = ((((_433 + 0.625f) * _434) + _120) * fDistortionCoef) + 1.0f;
        _505 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_500 * _123) + 0.5f), ((_500 * _125) + 0.5f)));
        _513 = ((((_433 + 0.75f) * _434) + _120) * fDistortionCoef) + 1.0f;
        _518 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_513 * _123) + 0.5f), ((_513 * _125) + 0.5f)));
        _533 = ((((_433 + 0.875f) * _434) + _120) * fDistortionCoef) + 1.0f;
        _545 = ((((_433 + 1.0f) * _434) + _120) * fDistortionCoef) + 1.0f;
        _553 = _101 * 0.3199999928474426f;
        _1173 = (((((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_449 * _123) + 0.5f), ((_449 * _125) + 0.5f))))).x) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_438 * _123) + 0.5f), ((_438 * _125) + 0.5f))))).x)) + (_466.x * 0.75f)) + (_480.x * 0.375f)) * _553);
        _1174 = ((_101 * 0.3636363744735718f) * ((((_505.y + _480.y) * 0.625f) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_489 * _123) + 0.5f), ((_489 * _125) + 0.5f))))).y)) + ((_518.y + _466.y) * 0.25f)));
        _1175 = (((((_518.z * 0.75f) + (_505.z * 0.375f)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_533 * _123) + 0.5f), ((_533 * _125) + 0.5f))))).z)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_545 * _123) + 0.5f), ((_545 * _125) + 0.5f))))).z)) * _553);
        _1176 = fDistortionCoef;
        _1177 = 0.0f;
        _1178 = 0.0f;
        _1179 = 0.0f;
        _1180 = 0.0f;
        _1181 = fCorrectCoef;
      } else {
        _559 = _421 + _120;
        _561 = (_559 * fDistortionCoef) + 1.0f;
        _568 = ((_559 + _421) * fDistortionCoef) + 1.0f;
        _1173 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_127, _128)))).x) * _101);
        _1174 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_561 * _123) + 0.5f), ((_561 * _125) + 0.5f))))).y) * _101);
        _1175 = ((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_568 * _123) + 0.5f), ((_568 * _125) + 0.5f))))).z) * _101);
        _1176 = fDistortionCoef;
        _1177 = 0.0f;
        _1178 = 0.0f;
        _1179 = 0.0f;
        _1180 = 0.0f;
        _1181 = fCorrectCoef;
      }
    }
  } else {
    if (_49) {
      _589 = screenInverseSize.x * 2.0f;
      _591 = screenInverseSize.y * 2.0f;
      _593 = (_589 * SV_Position.x) + -1.0f;
      _597 = sqrt((_593 * _593) + 1.0f);
      _598 = 1.0f / _597;
      _606 = ((_597 * fOptimizedParam.z) * (_598 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
      _607 = _606 * _593;
      _609 = (_606 * ((_591 * SV_Position.y) + -1.0f)) * (((_598 + -1.0f) * fOptimizedParam.y) + 1.0f);
      _610 = _607 + 0.5f;
      _611 = _609 + 0.5f;
      do {
        _873 = _610;
        _874 = _611;
        if (_51) {
          if (!(fHazeFilterReductionResolution == 0)) {
            _619 = HazeNoiseResult.Sample(BilinearWrap, float2(_610, _611));
            _873 = ((fHazeFilterScale * _619.x) + _610);
            _874 = ((fHazeFilterScale * _619.y) + _611);
          } else {
            _631 = ((fHazeFilterAttribute & 2) != 0);
            _635 = tFilterTempMap1.Sample(BilinearWrap, float2(_610, _611));
            do {
              if (_631) {
                _642 = ReadonlyDepth.SampleLevel(PointClamp, float2(_610, _611), 0.0f);
                _648 = ((_589 * screenSize.x) * _610) + -1.0f;
                _649 = 1.0f - ((_591 * screenSize.y) * _611);
                _686 = 1.0f / (mad(_642.x, (viewProjInvMat[2].w), mad(_649, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _648))) + (viewProjInvMat[3].w));
                _688 = _686 * (mad(_642.x, (viewProjInvMat[2].y), mad(_649, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _648))) + (viewProjInvMat[3].y));
                _696 = (_686 * (mad(_642.x, (viewProjInvMat[2].x), mad(_649, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _648))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _697 = _688 - (transposeViewInvMat[1].w);
                _698 = (_686 * (mad(_642.x, (viewProjInvMat[2].z), mad(_649, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _648))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _723 = saturate(max(((sqrt(((_697 * _697) + (_696 * _696)) + (_698 * _698)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_688 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _635.x);
                _724 = _642.x;
              } else {
                _723 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _635.x), _635.x);
                _724 = 0.0f;
              }
              do {
                _745 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _738 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _745 = (1.0f - saturate(max((_738 * min(max((abs(_607) - fHazeFilterBorder), 0.0f), 1.0f)), (_738 * min(max((abs(_609) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _746 = _745 * _723;
                do {
                  _864 = 0.0f;
                  _865 = 0.0f;
                  if (!(_746 <= 9.999999747378752e-06f)) {
                    _753 = -0.0f - _611;
                    _776 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_753, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _610))) * fHazeFilterUVWOffset.w;
                    _777 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_753, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _610))) * fHazeFilterUVWOffset.w;
                    _778 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_753, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _610))) * fHazeFilterUVWOffset.w;
                    _786 = _776 * 2.0f;
                    _787 = _777 * 2.0f;
                    _788 = _778 * 2.0f;
                    _796 = _776 * 4.0f;
                    _797 = _777 * 4.0f;
                    _798 = _778 * 4.0f;
                    _806 = _776 * 8.0f;
                    _807 = _777 * 8.0f;
                    _808 = _778 * 8.0f;
                    _816 = fHazeFilterUVWOffset.x + 0.5f;
                    _817 = fHazeFilterUVWOffset.y + 0.5f;
                    _818 = fHazeFilterUVWOffset.z + 0.5f;
                    _850 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_786 + fHazeFilterUVWOffset.x), (_787 + fHazeFilterUVWOffset.y), (_788 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_776 + fHazeFilterUVWOffset.x), (_777 + fHazeFilterUVWOffset.y), (_778 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_796 + fHazeFilterUVWOffset.x), (_797 + fHazeFilterUVWOffset.y), (_798 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_806 + fHazeFilterUVWOffset.x), (_807 + fHazeFilterUVWOffset.y), (_808 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _746;
                    _851 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_786 + _816), (_787 + _817), (_788 + _818)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_776 + _816), (_777 + _817), (_778 + _818)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_796 + _816), (_797 + _817), (_798 + _818)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_806 + _816), (_807 + _817), (_808 + _818)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _746;
                    if (_631) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2((_850 + _610), (_851 + _611)))).x) - _724) >= fHazeFilterDepthDiffBias)) {
                        _864 = _850;
                        _865 = _851;
                      } else {
                        _864 = 0.0f;
                        _865 = 0.0f;
                      }
                    } else {
                      _864 = _850;
                      _865 = _851;
                    }
                  }
                  _873 = ((fHazeFilterScale * _864) + _610);
                  _874 = ((fHazeFilterScale * _865) + _611);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        _877 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_873, _874));
        _1173 = (_877.x * _101);
        _1174 = (_877.y * _101);
        _1175 = (_877.z * _101);
        _1176 = 0.0f;
        _1177 = fOptimizedParam.x;
        _1178 = fOptimizedParam.y;
        _1179 = fOptimizedParam.z;
        _1180 = fOptimizedParam.w;
        _1181 = 1.0f;
      } while (false);
    } else {
      _885 = screenInverseSize.x * SV_Position.x;
      _886 = screenInverseSize.y * SV_Position.y;
      do {
        if (!(_51)) {
          _890 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_885, _886));
          _1166 = _890.x;
          _1167 = _890.y;
          _1168 = _890.z;
        } else {
          do {
            if (!(fHazeFilterReductionResolution == 0)) {
              _901 = HazeNoiseResult.Sample(BilinearWrap, float2(_885, _886));
              _1155 = (fHazeFilterScale * _901.x);
              _1156 = (fHazeFilterScale * _901.y);
            } else {
              _911 = ((fHazeFilterAttribute & 2) != 0);
              _915 = tFilterTempMap1.Sample(BilinearWrap, float2(_885, _886));
              do {
                if (_911) {
                  _922 = ReadonlyDepth.SampleLevel(PointClamp, float2(_885, _886), 0.0f);
                  _930 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _885) + -1.0f;
                  _931 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _886);
                  _968 = 1.0f / (mad(_922.x, (viewProjInvMat[2].w), mad(_931, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _930))) + (viewProjInvMat[3].w));
                  _970 = _968 * (mad(_922.x, (viewProjInvMat[2].y), mad(_931, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _930))) + (viewProjInvMat[3].y));
                  _978 = (_968 * (mad(_922.x, (viewProjInvMat[2].x), mad(_931, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _930))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                  _979 = _970 - (transposeViewInvMat[1].w);
                  _980 = (_968 * (mad(_922.x, (viewProjInvMat[2].z), mad(_931, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _930))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                  _1005 = saturate(max(((sqrt(((_979 * _979) + (_978 * _978)) + (_980 * _980)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_970 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _915.x);
                  _1006 = _922.x;
                } else {
                  _1005 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _915.x), _915.x);
                  _1006 = 0.0f;
                }
                do {
                  _1029 = 1.0f;
                  if (!((fHazeFilterAttribute & 4) == 0)) {
                    _1022 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                    _1029 = (1.0f - saturate(max((_1022 * min(max((abs(_885 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)), (_1022 * min(max((abs(_886 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)))));
                  }
                  _1030 = _1029 * _1005;
                  do {
                    _1148 = 0.0f;
                    _1149 = 0.0f;
                    if (!(_1030 <= 9.999999747378752e-06f)) {
                      _1037 = -0.0f - _886;
                      _1060 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_1037, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _885))) * fHazeFilterUVWOffset.w;
                      _1061 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_1037, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _885))) * fHazeFilterUVWOffset.w;
                      _1062 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_1037, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _885))) * fHazeFilterUVWOffset.w;
                      _1070 = _1060 * 2.0f;
                      _1071 = _1061 * 2.0f;
                      _1072 = _1062 * 2.0f;
                      _1080 = _1060 * 4.0f;
                      _1081 = _1061 * 4.0f;
                      _1082 = _1062 * 4.0f;
                      _1090 = _1060 * 8.0f;
                      _1091 = _1061 * 8.0f;
                      _1092 = _1062 * 8.0f;
                      _1100 = fHazeFilterUVWOffset.x + 0.5f;
                      _1101 = fHazeFilterUVWOffset.y + 0.5f;
                      _1102 = fHazeFilterUVWOffset.z + 0.5f;
                      _1134 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1070 + fHazeFilterUVWOffset.x), (_1071 + fHazeFilterUVWOffset.y), (_1072 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_1060 + fHazeFilterUVWOffset.x), (_1061 + fHazeFilterUVWOffset.y), (_1062 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1080 + fHazeFilterUVWOffset.x), (_1081 + fHazeFilterUVWOffset.y), (_1082 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1090 + fHazeFilterUVWOffset.x), (_1091 + fHazeFilterUVWOffset.y), (_1092 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _1030;
                      _1135 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1070 + _1100), (_1071 + _1101), (_1072 + _1102)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_1060 + _1100), (_1061 + _1101), (_1062 + _1102)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1080 + _1100), (_1081 + _1101), (_1082 + _1102)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1090 + _1100), (_1091 + _1101), (_1092 + _1102)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _1030;
                      if (_911) {
                        if (!((((ReadonlyDepth.Sample(BilinearWrap, float2((_1134 + _885), (_1135 + _886)))).x) - _1006) >= fHazeFilterDepthDiffBias)) {
                          _1148 = _1134;
                          _1149 = _1135;
                        } else {
                          _1148 = 0.0f;
                          _1149 = 0.0f;
                        }
                      } else {
                        _1148 = _1134;
                        _1149 = _1135;
                      }
                    }
                    _1155 = (fHazeFilterScale * _1148);
                    _1156 = (fHazeFilterScale * _1149);
                  } while (false);
                } while (false);
              } while (false);
            }
            _1161 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1155 + _885), (_1156 + _886)));
            _1166 = _1161.x;
            _1167 = _1161.y;
            _1168 = _1161.z;
          } while (false);
        }
        _1173 = (_1166 * _101);
        _1174 = (_1167 * _101);
        _1175 = (_1168 * _101);
        _1176 = 0.0f;
        _1177 = 0.0f;
        _1178 = 0.0f;
        _1179 = 0.0f;
        _1180 = 0.0f;
        _1181 = 1.0f;
      } while (false);
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    _1204 = (float)((bool)(uint)((cbRadialBlurFlags & 2) != 0));
    _1208 = ComputeResultSRV[0].computeAlpha;
    _1211 = ((1.0f - _1204) + (_1208 * _1204)) * cbRadialColor.w;
    if (!(_1211 == 0.0f)) {
      _1214 = screenInverseSize.x * SV_Position.x;
      _1215 = screenInverseSize.y * SV_Position.y;
      _1217 = _1214 + (-0.5f - cbRadialScreenPos.x);
      _1219 = _1215 + (-0.5f - cbRadialScreenPos.y);
      _1222 = select((_1217 < 0.0f), (1.0f - _1214), _1214);
      _1225 = select((_1219 < 0.0f), (1.0f - _1215), _1215);
      do {
        _1251 = 1.0f;
        if (!((cbRadialBlurFlags & 1) == 0)) {
          _1231 = rsqrt(dot(float2(_1217, _1219), float2(_1217, _1219))) * cbRadialSharpRange;
          _1238 = uint(abs(_1231 * _1219)) + uint(abs(_1231 * _1217));
          _1242 = ((_1238 ^ 61) ^ ((uint)(_1238) >> 16)) * 9;
          _1245 = (((uint)(_1242) >> 4) ^ _1242) * 668265261;
          _1251 = (((float)((uint)((uint)(((uint)(_1245) >> 15) ^ _1245)))) * 2.3283064365386963e-10f);
        }
        _1255 = sqrt((_1217 * _1217) + (_1219 * _1219));
        _1257 = 1.0f / max(1.0f, _1255);
        _1258 = _1251 * _1222;
        _1259 = cbRadialBlurPower * _1257;
        _1260 = _1259 * -0.0011111111380159855f;
        _1262 = _1251 * _1225;
        _1266 = ((_1260 * _1258) + 1.0f) * _1217;
        _1267 = ((_1260 * _1262) + 1.0f) * _1219;
        _1269 = _1259 * -0.002222222276031971f;
        _1274 = ((_1269 * _1258) + 1.0f) * _1217;
        _1275 = ((_1269 * _1262) + 1.0f) * _1219;
        _1276 = _1259 * -0.0033333334140479565f;
        _1281 = ((_1276 * _1258) + 1.0f) * _1217;
        _1282 = ((_1276 * _1262) + 1.0f) * _1219;
        _1283 = _1259 * -0.004444444552063942f;
        _1288 = ((_1283 * _1258) + 1.0f) * _1217;
        _1289 = ((_1283 * _1262) + 1.0f) * _1219;
        _1290 = _1259 * -0.0055555556900799274f;
        _1295 = ((_1290 * _1258) + 1.0f) * _1217;
        _1296 = ((_1290 * _1262) + 1.0f) * _1219;
        _1297 = _1259 * -0.006666666828095913f;
        _1302 = ((_1297 * _1258) + 1.0f) * _1217;
        _1303 = ((_1297 * _1262) + 1.0f) * _1219;
        _1304 = _1259 * -0.007777777966111898f;
        _1309 = ((_1304 * _1258) + 1.0f) * _1217;
        _1310 = ((_1304 * _1262) + 1.0f) * _1219;
        _1311 = _1259 * -0.008888889104127884f;
        _1316 = ((_1311 * _1258) + 1.0f) * _1217;
        _1317 = ((_1311 * _1262) + 1.0f) * _1219;
        _1320 = _1257 * ((cbRadialBlurPower * -0.009999999776482582f) * _1251);
        _1325 = ((_1320 * _1222) + 1.0f) * _1217;
        _1326 = ((_1320 * _1225) + 1.0f) * _1219;
        do {
          if (_43) {
            _1328 = _1266 + cbRadialScreenPos.x;
            _1329 = _1267 + cbRadialScreenPos.y;
            _1333 = ((dot(float2(_1328, _1329), float2(_1328, _1329)) * _1176) + 1.0f) * _1181;
            _1339 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1333 * _1328) + 0.5f), ((_1333 * _1329) + 0.5f)), 0.0f);
            _1343 = _1274 + cbRadialScreenPos.x;
            _1344 = _1275 + cbRadialScreenPos.y;
            _1348 = ((dot(float2(_1343, _1344), float2(_1343, _1344)) * _1176) + 1.0f) * _1181;
            _1353 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1348 * _1343) + 0.5f), ((_1348 * _1344) + 0.5f)), 0.0f);
            _1360 = _1281 + cbRadialScreenPos.x;
            _1361 = _1282 + cbRadialScreenPos.y;
            _1365 = ((dot(float2(_1360, _1361), float2(_1360, _1361)) * _1176) + 1.0f) * _1181;
            _1370 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1365 * _1360) + 0.5f), ((_1365 * _1361) + 0.5f)), 0.0f);
            _1377 = _1288 + cbRadialScreenPos.x;
            _1378 = _1289 + cbRadialScreenPos.y;
            _1382 = ((dot(float2(_1377, _1378), float2(_1377, _1378)) * _1176) + 1.0f) * _1181;
            _1387 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1382 * _1377) + 0.5f), ((_1382 * _1378) + 0.5f)), 0.0f);
            _1394 = _1295 + cbRadialScreenPos.x;
            _1395 = _1296 + cbRadialScreenPos.y;
            _1399 = ((dot(float2(_1394, _1395), float2(_1394, _1395)) * _1176) + 1.0f) * _1181;
            _1404 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1399 * _1394) + 0.5f), ((_1399 * _1395) + 0.5f)), 0.0f);
            _1411 = _1302 + cbRadialScreenPos.x;
            _1412 = _1303 + cbRadialScreenPos.y;
            _1416 = ((dot(float2(_1411, _1412), float2(_1411, _1412)) * _1176) + 1.0f) * _1181;
            _1421 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1416 * _1411) + 0.5f), ((_1416 * _1412) + 0.5f)), 0.0f);
            _1428 = _1309 + cbRadialScreenPos.x;
            _1429 = _1310 + cbRadialScreenPos.y;
            _1433 = ((dot(float2(_1428, _1429), float2(_1428, _1429)) * _1176) + 1.0f) * _1181;
            _1438 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1433 * _1428) + 0.5f), ((_1433 * _1429) + 0.5f)), 0.0f);
            _1445 = _1316 + cbRadialScreenPos.x;
            _1446 = _1317 + cbRadialScreenPos.y;
            _1450 = ((dot(float2(_1445, _1446), float2(_1445, _1446)) * _1176) + 1.0f) * _1181;
            _1455 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1450 * _1445) + 0.5f), ((_1450 * _1446) + 0.5f)), 0.0f);
            _1462 = _1325 + cbRadialScreenPos.x;
            _1463 = _1326 + cbRadialScreenPos.y;
            _1467 = ((dot(float2(_1462, _1463), float2(_1462, _1463)) * _1176) + 1.0f) * _1181;
            _1472 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1467 * _1462) + 0.5f), ((_1467 * _1463) + 0.5f)), 0.0f);
            _1806 = ((((((((_1353.x + _1339.x) + _1370.x) + _1387.x) + _1404.x) + _1421.x) + _1438.x) + _1455.x) + _1472.x);
            _1807 = ((((((((_1353.y + _1339.y) + _1370.y) + _1387.y) + _1404.y) + _1421.y) + _1438.y) + _1455.y) + _1472.y);
            _1808 = ((((((((_1353.z + _1339.z) + _1370.z) + _1387.z) + _1404.z) + _1421.z) + _1438.z) + _1455.z) + _1472.z);
          } else {
            _1480 = cbRadialScreenPos.x + 0.5f;
            _1481 = _1266 + _1480;
            _1482 = cbRadialScreenPos.y + 0.5f;
            _1483 = _1267 + _1482;
            _1484 = _1274 + _1480;
            _1485 = _1275 + _1482;
            _1486 = _1281 + _1480;
            _1487 = _1282 + _1482;
            _1488 = _1288 + _1480;
            _1489 = _1289 + _1482;
            _1490 = _1295 + _1480;
            _1491 = _1296 + _1482;
            _1492 = _1302 + _1480;
            _1493 = _1303 + _1482;
            _1494 = _1309 + _1480;
            _1495 = _1310 + _1482;
            _1496 = _1316 + _1480;
            _1497 = _1317 + _1482;
            _1498 = _1325 + _1480;
            _1499 = _1326 + _1482;
            if (_49) {
              _1503 = (_1481 * 2.0f) + -1.0f;
              _1507 = sqrt((_1503 * _1503) + 1.0f);
              _1508 = 1.0f / _1507;
              _1515 = _1180 * 0.5f;
              _1516 = ((_1507 * _1179) * (_1508 + _1177)) * _1515;
              _1523 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1516 * _1503) + 0.5f), (((_1516 * ((_1483 * 2.0f) + -1.0f)) * (((_1508 + -1.0f) * _1178) + 1.0f)) + 0.5f)), 0.0f);
              _1529 = (_1484 * 2.0f) + -1.0f;
              _1533 = sqrt((_1529 * _1529) + 1.0f);
              _1534 = 1.0f / _1533;
              _1541 = ((_1533 * _1179) * (_1534 + _1177)) * _1515;
              _1547 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1541 * _1529) + 0.5f), (((_1541 * ((_1485 * 2.0f) + -1.0f)) * (((_1534 + -1.0f) * _1178) + 1.0f)) + 0.5f)), 0.0f);
              _1556 = (_1486 * 2.0f) + -1.0f;
              _1560 = sqrt((_1556 * _1556) + 1.0f);
              _1561 = 1.0f / _1560;
              _1568 = ((_1560 * _1179) * (_1561 + _1177)) * _1515;
              _1574 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1568 * _1556) + 0.5f), (((_1568 * ((_1487 * 2.0f) + -1.0f)) * (((_1561 + -1.0f) * _1178) + 1.0f)) + 0.5f)), 0.0f);
              _1583 = (_1488 * 2.0f) + -1.0f;
              _1587 = sqrt((_1583 * _1583) + 1.0f);
              _1588 = 1.0f / _1587;
              _1595 = ((_1587 * _1179) * (_1588 + _1177)) * _1515;
              _1601 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1595 * _1583) + 0.5f), (((_1595 * ((_1489 * 2.0f) + -1.0f)) * (((_1588 + -1.0f) * _1178) + 1.0f)) + 0.5f)), 0.0f);
              _1610 = (_1490 * 2.0f) + -1.0f;
              _1614 = sqrt((_1610 * _1610) + 1.0f);
              _1615 = 1.0f / _1614;
              _1622 = ((_1614 * _1179) * (_1615 + _1177)) * _1515;
              _1628 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1622 * _1610) + 0.5f), (((_1622 * ((_1491 * 2.0f) + -1.0f)) * (((_1615 + -1.0f) * _1178) + 1.0f)) + 0.5f)), 0.0f);
              _1637 = (_1492 * 2.0f) + -1.0f;
              _1641 = sqrt((_1637 * _1637) + 1.0f);
              _1642 = 1.0f / _1641;
              _1649 = ((_1641 * _1179) * (_1642 + _1177)) * _1515;
              _1655 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1649 * _1637) + 0.5f), (((_1649 * ((_1493 * 2.0f) + -1.0f)) * (((_1642 + -1.0f) * _1178) + 1.0f)) + 0.5f)), 0.0f);
              _1664 = (_1494 * 2.0f) + -1.0f;
              _1668 = sqrt((_1664 * _1664) + 1.0f);
              _1669 = 1.0f / _1668;
              _1676 = ((_1668 * _1179) * (_1669 + _1177)) * _1515;
              _1682 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1676 * _1664) + 0.5f), (((_1676 * ((_1495 * 2.0f) + -1.0f)) * (((_1669 + -1.0f) * _1178) + 1.0f)) + 0.5f)), 0.0f);
              _1691 = (_1496 * 2.0f) + -1.0f;
              _1695 = sqrt((_1691 * _1691) + 1.0f);
              _1696 = 1.0f / _1695;
              _1703 = ((_1695 * _1179) * (_1696 + _1177)) * _1515;
              _1709 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1703 * _1691) + 0.5f), (((_1703 * ((_1497 * 2.0f) + -1.0f)) * (((_1696 + -1.0f) * _1178) + 1.0f)) + 0.5f)), 0.0f);
              _1718 = (_1498 * 2.0f) + -1.0f;
              _1722 = sqrt((_1718 * _1718) + 1.0f);
              _1723 = 1.0f / _1722;
              _1730 = ((_1722 * _1179) * (_1723 + _1177)) * _1515;
              _1736 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1730 * _1718) + 0.5f), (((_1730 * ((_1499 * 2.0f) + -1.0f)) * (((_1723 + -1.0f) * _1178) + 1.0f)) + 0.5f)), 0.0f);
              _1806 = ((((((((_1547.x + _1523.x) + _1574.x) + _1601.x) + _1628.x) + _1655.x) + _1682.x) + _1709.x) + _1736.x);
              _1807 = ((((((((_1547.y + _1523.y) + _1574.y) + _1601.y) + _1628.y) + _1655.y) + _1682.y) + _1709.y) + _1736.y);
              _1808 = ((((((((_1547.z + _1523.z) + _1574.z) + _1601.z) + _1628.z) + _1655.z) + _1682.z) + _1709.z) + _1736.z);
            } else {
              _1745 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1481, _1483), 0.0f);
              _1749 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1484, _1485), 0.0f);
              _1756 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1486, _1487), 0.0f);
              _1763 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1488, _1489), 0.0f);
              _1770 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1490, _1491), 0.0f);
              _1777 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1492, _1493), 0.0f);
              _1784 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1494, _1495), 0.0f);
              _1791 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1496, _1497), 0.0f);
              _1798 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1498, _1499), 0.0f);
              _1806 = ((((((((_1749.x + _1745.x) + _1756.x) + _1763.x) + _1770.x) + _1777.x) + _1784.x) + _1791.x) + _1798.x);
              _1807 = ((((((((_1749.y + _1745.y) + _1756.y) + _1763.y) + _1770.y) + _1777.y) + _1784.y) + _1791.y) + _1798.y);
              _1808 = ((((((((_1749.z + _1745.z) + _1756.z) + _1763.z) + _1770.z) + _1777.z) + _1784.z) + _1791.z) + _1798.z);
            }
          }
          _1818 = (cbRadialColor.z * (_1175 + (_101 * _1808))) * 0.10000000149011612f;
          _1819 = (cbRadialColor.y * (_1174 + (_101 * _1807))) * 0.10000000149011612f;
          _1820 = (cbRadialColor.x * (_1173 + (_101 * _1806))) * 0.10000000149011612f;
          do {
            _1842 = _1820;
            _1843 = _1819;
            _1844 = _1818;
            if (cbRadialMaskRate.x > 0.0f) {
              _1825 = saturate((_1255 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              _1831 = (((_1825 * _1825) * cbRadialMaskRate.x) * (3.0f - (_1825 * 2.0f))) + cbRadialMaskRate.y;
              _1842 = ((_1831 * (_1820 - _1173)) + _1173);
              _1843 = ((_1831 * (_1819 - _1174)) + _1174);
              _1844 = ((_1831 * (_1818 - _1175)) + _1175);
            }
            _1855 = (lerp(_1173, _1842, _1211));
            _1856 = (lerp(_1174, _1843, _1211));
            _1857 = (lerp(_1175, _1844, _1211));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1855 = _1173;
      _1856 = _1174;
      _1857 = _1175;
    }
  } else {
    _1855 = _1173;
    _1856 = _1174;
    _1857 = _1175;
  }
  if (!((cPassEnabled & 2) == 0)) {
    _1874 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    _1876 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    _1882 = frac(frac((_1876 * 0.005837149918079376f) + (_1874 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      _1896 = 0.0f;
      if (_1882 < fNoiseDensity) {
        _1887 = (int)(uint(_1876 * _1874)) ^ 12345391;
        _1888 = _1887 * 3635641;
        _1896 = (((float)((uint)((uint)((((uint)(_1888) >> 26) | ((int)(_1887 * 232681024))) ^ _1888)))) * 2.3283064365386963e-10f);
      }
      _1898 = frac(_1882 * 757.4846801757812f);
      do {
        _1912 = 0.0f;
        if (_1898 < fNoiseDensity) {
          _1902 = asint(_1898) ^ 12345391;
          _1903 = _1902 * 3635641;
          _1912 = ((((float)((uint)((uint)((((uint)(_1903) >> 26) | ((int)(_1902 * 232681024))) ^ _1903)))) * 2.3283064365386963e-10f) + -0.5f);
        }
        _1914 = frac(_1898 * 757.4846801757812f);
        do {
          _1928 = 0.0f;
          if (_1914 < fNoiseDensity) {
            _1918 = asint(_1914) ^ 12345391;
            _1919 = _1918 * 3635641;
            _1928 = ((((float)((uint)((uint)((((uint)(_1919) >> 26) | ((int)(_1918 * 232681024))) ^ _1919)))) * 2.3283064365386963e-10f) + -0.5f);
          }
          _1929 = _1896 * CUSTOM_NOISE * fNoisePower.x;
          _1930 = _1928 * CUSTOM_NOISE * fNoisePower.y;
          _1931 = _1912 * CUSTOM_NOISE * fNoisePower.y;
          _1945 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1855), saturate(_1856), saturate(_1857)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1956 = ((_1945 * (mad(_1931, 1.4019999504089355f, _1929) - _1855)) + _1855);
          _1957 = ((_1945 * (mad(_1931, -0.7139999866485596f, mad(_1930, -0.3440000116825104f, _1929)) - _1856)) + _1856);
          _1958 = ((_1945 * (mad(_1930, 1.7719999551773071f, _1929) - _1857)) + _1857);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1956 = _1855;
    _1957 = _1856;
    _1958 = _1857;
  }
  _1973 = mad(_1958, (fOCIOTransformMatrix[2].x), mad(_1957, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1956)));
  _1976 = mad(_1958, (fOCIOTransformMatrix[2].y), mad(_1957, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1956)));
  _1979 = mad(_1958, (fOCIOTransformMatrix[2].z), mad(_1957, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1956)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    _1985 = max(max(_1973, _1976), _1979);
    if (!(_1985 == 0.0f)) {
      _1991 = abs(_1985);
      _1992 = (_1985 - _1973) / _1991;
      _1993 = (_1985 - _1976) / _1991;
      _1994 = (_1985 - _1979) / _1991;
      do {
        _2016 = _1992;
        if (!(!(_1992 >= cbControlRGCParam.CyanThreshold))) {
          _2004 = _1992 - cbControlRGCParam.CyanThreshold;
          _2016 = ((_2004 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _2004) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        }
        do {
          _2037 = _1993;
          if (!(!(_1993 >= cbControlRGCParam.MagentaThreshold))) {
            _2025 = _1993 - cbControlRGCParam.MagentaThreshold;
            _2037 = ((_2025 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _2025) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          }
          do {
            _2057 = _1994;
            if (!(!(_1994 >= cbControlRGCParam.YellowThreshold))) {
              _2045 = _1994 - cbControlRGCParam.YellowThreshold;
              _2057 = ((_2045 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _2045) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            }
            _2065 = (_1985 - (_2016 * _1991));
            _2066 = (_1985 - (_2037 * _1991));
            _2067 = (_1985 - (_2057 * _1991));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _2065 = _1973;
      _2066 = _1976;
      _2067 = _1979;
    }
  } else {
    _2065 = _1973;
    _2066 = _1976;
    _2067 = _1979;
  }
#if 1
  ApplyColorCorrectTexturePass(
      (cPassEnabled & 4) != 0,
      _2065, _2066, _2067,
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
      _2474, _2475, _2476);
#else
  if (!((cPassEnabled & 4) == 0)) {
    _2093 = !(_2065 <= 0.0078125f);
    do {
      if (!(_2093)) {
        _2102 = ((_2065 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2102 = ((log2(_2065) + 9.720000267028809f) * 0.05707762390375137f);
      }
      _2103 = !(_2066 <= 0.0078125f);
      do {
        if (!(_2103)) {
          _2112 = ((_2066 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2112 = ((log2(_2066) + 9.720000267028809f) * 0.05707762390375137f);
        }
        _2113 = !(_2067 <= 0.0078125f);
        do {
          if (!(_2113)) {
            _2122 = ((_2067 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _2122 = ((log2(_2067) + 9.720000267028809f) * 0.05707762390375137f);
          }
          _2131 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_2102 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2112 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2122 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_2131.x < 0.155251145362854f) {
              _2148 = ((_2131.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((_2131.x >= 0.155251145362854f) && (_2131.x < 1.4679962396621704f)) {
                _2148 = exp2((_2131.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _2148 = 65504.0f;
              }
            }
            do {
              if (_2131.y < 0.155251145362854f) {
                _2162 = ((_2131.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_2131.y >= 0.155251145362854f) && (_2131.y < 1.4679962396621704f)) {
                  _2162 = exp2((_2131.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _2162 = 65504.0f;
                }
              }
              do {
                if (_2131.z < 0.155251145362854f) {
                  _2176 = ((_2131.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_2131.z >= 0.155251145362854f) && (_2131.z < 1.4679962396621704f)) {
                    _2176 = exp2((_2131.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _2176 = 65504.0f;
                  }
                }
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!(_2093)) {
                        _2187 = ((_2065 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _2187 = ((log2(_2065) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(_2103)) {
                          _2196 = ((_2066 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2196 = ((log2(_2066) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(_2113)) {
                            _2205 = ((_2067 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2205 = ((log2(_2067) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          _2213 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_2187 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2196 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2205 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_2213.x < 0.155251145362854f) {
                              _2230 = ((_2213.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((_2213.x >= 0.155251145362854f) && (_2213.x < 1.4679962396621704f)) {
                                _2230 = exp2((_2213.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _2230 = 65504.0f;
                              }
                            }
                            do {
                              if (_2213.y < 0.155251145362854f) {
                                _2244 = ((_2213.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_2213.y >= 0.155251145362854f) && (_2213.y < 1.4679962396621704f)) {
                                  _2244 = exp2((_2213.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2244 = 65504.0f;
                                }
                              }
                              do {
                                if (_2213.z < 0.155251145362854f) {
                                  _2258 = ((_2213.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_2213.z >= 0.155251145362854f) && (_2213.z < 1.4679962396621704f)) {
                                    _2258 = exp2((_2213.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2258 = 65504.0f;
                                  }
                                }
                                _2265 = ((_2230 - _2148) * fTextureBlendRate) + _2148;
                                _2266 = ((_2244 - _2162) * fTextureBlendRate) + _2162;
                                _2267 = ((_2258 - _2176) * fTextureBlendRate) + _2176;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_2265 <= 0.0078125f))) {
                                      _2279 = ((_2265 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _2279 = ((log2(_2265) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_2266 <= 0.0078125f))) {
                                        _2289 = ((_2266 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _2289 = ((log2(_2266) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_2267 <= 0.0078125f))) {
                                          _2299 = ((_2267 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _2299 = ((log2(_2267) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        _2307 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2279 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2289 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2299 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_2307.x < 0.155251145362854f) {
                                            _2324 = ((_2307.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((_2307.x >= 0.155251145362854f) && (_2307.x < 1.4679962396621704f)) {
                                              _2324 = exp2((_2307.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _2324 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_2307.y < 0.155251145362854f) {
                                              _2338 = ((_2307.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((_2307.y >= 0.155251145362854f) && (_2307.y < 1.4679962396621704f)) {
                                                _2338 = exp2((_2307.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _2338 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_2307.z < 0.155251145362854f) {
                                                _2352 = ((_2307.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((_2307.z >= 0.155251145362854f) && (_2307.z < 1.4679962396621704f)) {
                                                  _2352 = exp2((_2307.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _2352 = 65504.0f;
                                                }
                                              }
                                              _2458 = (lerp(_2265, _2324, fTextureBlendRate2));
                                              _2459 = (lerp(_2266, _2338, fTextureBlendRate2));
                                              _2460 = (lerp(_2267, _2352, fTextureBlendRate2));
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _2458 = _2265;
                                  _2459 = _2266;
                                  _2460 = _2267;
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
                        if (!(!(_2148 <= 0.0078125f))) {
                          _2374 = ((_2148 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2374 = ((log2(_2148) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_2162 <= 0.0078125f))) {
                            _2384 = ((_2162 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2384 = ((log2(_2162) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_2176 <= 0.0078125f))) {
                              _2394 = ((_2176 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _2394 = ((log2(_2176) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            _2402 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2374 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2384 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2394 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_2402.x < 0.155251145362854f) {
                                _2419 = ((_2402.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_2402.x >= 0.155251145362854f) && (_2402.x < 1.4679962396621704f)) {
                                  _2419 = exp2((_2402.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2419 = 65504.0f;
                                }
                              }
                              do {
                                if (_2402.y < 0.155251145362854f) {
                                  _2433 = ((_2402.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_2402.y >= 0.155251145362854f) && (_2402.y < 1.4679962396621704f)) {
                                    _2433 = exp2((_2402.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2433 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_2402.z < 0.155251145362854f) {
                                    _2447 = ((_2402.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((_2402.z >= 0.155251145362854f) && (_2402.z < 1.4679962396621704f)) {
                                      _2447 = exp2((_2402.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _2447 = 65504.0f;
                                    }
                                  }
                                  _2458 = (lerp(_2148, _2419, fTextureBlendRate2));
                                  _2459 = (lerp(_2162, _2433, fTextureBlendRate2));
                                  _2460 = (lerp(_2176, _2447, fTextureBlendRate2));
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _2458 = _2148;
                      _2459 = _2162;
                      _2460 = _2176;
                    }
                  }
                  _2474 = (mad(_2460, (fColorMatrix[2].x), mad(_2459, (fColorMatrix[1].x), (_2458 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _2475 = (mad(_2460, (fColorMatrix[2].y), mad(_2459, (fColorMatrix[1].y), (_2458 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _2476 = (mad(_2460, (fColorMatrix[2].z), mad(_2459, (fColorMatrix[1].z), (_2458 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2474 = _2065;
    _2475 = _2066;
    _2476 = _2067;
  }
#endif
  _2477 = min(_2474, 65000.0f);
  _2478 = min(_2475, 65000.0f);
  _2479 = min(_2476, 65000.0f);
  if (!((cPassEnabled & 8) == 0)) {
    _2514 = saturate(((cvdR.x * _2477) + (cvdR.y * _2478)) + (cvdR.z * _2479));
    _2515 = saturate(((cvdG.x * _2477) + (cvdG.y * _2478)) + (cvdG.z * _2479));
    _2516 = saturate(((cvdB.x * _2477) + (cvdB.y * _2478)) + (cvdB.z * _2479));
  } else {
    _2514 = _2477;
    _2515 = _2478;
    _2516 = _2479;
  }
  if (!((cPassEnabled & 16) == 0)) {
    _2528 = screenInverseSize.x * SV_Position.x;
    _2529 = screenInverseSize.y * SV_Position.y;
    _2532 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2528, _2529), 0.0f);
    _2537 = _2532.x * ColorParam.x;
    _2538 = _2532.y * ColorParam.y;
    _2539 = _2532.z * ColorParam.z;
    _2547 = (_2532.w * ColorParam.w) * saturate((((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2528, _2529), 0.0f)).x) * Levels_Rate) + Levels_Range);
    do {
      if (_2537 < 0.5f) {
        _2559 = ((_2514 * 2.0f) * _2537);
      } else {
        _2559 = (1.0f - (((1.0f - _2514) * 2.0f) * (1.0f - _2537)));
      }
      do {
        if (_2538 < 0.5f) {
          _2571 = ((_2515 * 2.0f) * _2538);
        } else {
          _2571 = (1.0f - (((1.0f - _2515) * 2.0f) * (1.0f - _2538)));
        }
        do {
          if (_2539 < 0.5f) {
            _2583 = ((_2516 * 2.0f) * _2539);
          } else {
            _2583 = (1.0f - (((1.0f - _2516) * 2.0f) * (1.0f - _2539)));
          }
          _2594 = (lerp(_2514, _2559, _2547));
          _2595 = (lerp(_2515, _2571, _2547));
          _2596 = (lerp(_2516, _2583, _2547));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2594 = _2514;
    _2595 = _2515;
    _2596 = _2516;
  }
  if (!(useDynamicRangeConversion == 0.0f)) {
    if (!(useHuePreserve == 0.0f)) {
      _2636 = mad((RGBToXYZViaCrosstalkMatrix[0].z), _2596, mad((RGBToXYZViaCrosstalkMatrix[0].y), _2595, ((RGBToXYZViaCrosstalkMatrix[0].x) * _2594)));
      _2639 = mad((RGBToXYZViaCrosstalkMatrix[1].z), _2596, mad((RGBToXYZViaCrosstalkMatrix[1].y), _2595, ((RGBToXYZViaCrosstalkMatrix[1].x) * _2594)));
      _2644 = (_2639 + _2636) + mad((RGBToXYZViaCrosstalkMatrix[2].z), _2596, mad((RGBToXYZViaCrosstalkMatrix[2].y), _2595, ((RGBToXYZViaCrosstalkMatrix[2].x) * _2594)));
      _2645 = _2636 / _2644;
      _2646 = _2639 / _2644;
      do {
        if (_2639 < curve_HDRip) {
          _2657 = (_2639 * exposureScale);
        } else {
          _2657 = ((log2((_2639 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        _2659 = (_2645 / _2646) * _2657;
        _2663 = (((1.0f - _2645) - _2646) / _2646) * _2657;
        _2712 = min(max(mad((XYZToRGBViaCrosstalkMatrix[0].z), _2663, mad((XYZToRGBViaCrosstalkMatrix[0].y), _2657, (_2659 * (XYZToRGBViaCrosstalkMatrix[0].x)))), 0.0f), 65536.0f);
        _2713 = min(max(mad((XYZToRGBViaCrosstalkMatrix[1].z), _2663, mad((XYZToRGBViaCrosstalkMatrix[1].y), _2657, (_2659 * (XYZToRGBViaCrosstalkMatrix[1].x)))), 0.0f), 65536.0f);
        _2714 = min(max(mad((XYZToRGBViaCrosstalkMatrix[2].z), _2663, mad((XYZToRGBViaCrosstalkMatrix[2].y), _2657, (_2659 * (XYZToRGBViaCrosstalkMatrix[2].x)))), 0.0f), 65536.0f);
      } while (false);
    } else {
      do {
        if (_2594 < curve_HDRip) {
          _2690 = (exposureScale * _2594);
        } else {
          _2690 = ((log2((_2594 / curve_HDRip) - knee) * curve_k2) + curve_k4);
        }
        do {
          if (_2595 < curve_HDRip) {
            _2701 = (exposureScale * _2595);
          } else {
            _2701 = ((log2((_2595 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
          if (_2596 < curve_HDRip) {
            _2712 = _2690;
            _2713 = _2701;
            _2714 = (exposureScale * _2596);
          } else {
            _2712 = _2690;
            _2713 = _2701;
            _2714 = ((log2((_2596 / curve_HDRip) - knee) * curve_k2) + curve_k4);
          }
        } while (false);
      } while (false);
    }
  } else {
    _2712 = _2594;
    _2713 = _2595;
    _2714 = _2596;
  }
  SV_Target.x = _2712;
  SV_Target.y = _2713;
  SV_Target.z = _2714;
  SV_Target.w = 0.0f;
  return SV_Target;
}
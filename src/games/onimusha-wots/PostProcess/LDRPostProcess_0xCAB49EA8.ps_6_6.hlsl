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
    precise noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  bool _30;
  bool _36;
  bool _42;
  float _187;
  float _188;
  float _209;
  float _328;
  float _329;
  float _337;
  float _338;
  float _658;
  float _659;
  float _680;
  float _799;
  float _800;
  float _808;
  float _809;
  float _937;
  float _938;
  float _961;
  float _1080;
  float _1081;
  float _1087;
  float _1088;
  float _1098;
  float _1099;
  float _1100;
  float _1101;
  float _1102;
  float _1103;
  float _1104;
  float _1105;
  float _1106;
  float _1176;
  float _1731;
  float _1732;
  float _1733;
  float _1764;
  float _1765;
  float _1766;
  float _1777;
  float _1778;
  float _1779;
  float _1823;
  float _1839;
  float _1855;
  float _1883;
  float _1884;
  float _1885;
  float _1943;
  float _1964;
  float _1984;
  float _1992;
  float _1993;
  float _1994;
  float _2029;
  float _2039;
  float _2049;
  float _2075;
  float _2089;
  float _2103;
  float _2114;
  float _2123;
  float _2132;
  float _2157;
  float _2171;
  float _2185;
  float _2206;
  float _2216;
  float _2226;
  float _2251;
  float _2265;
  float _2279;
  float _2301;
  float _2311;
  float _2321;
  float _2346;
  float _2360;
  float _2374;
  float _2385;
  float _2386;
  float _2387;
  float _2401;
  float _2402;
  float _2403;
  float _2438;
  float _2439;
  float _2440;
  float _2483;
  float _2495;
  float _2507;
  float _2518;
  float _2519;
  float _2520;
  bool _44;
  float _61;
  float _62;
  float _63;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float2 _81;
  bool _93;
  float _97;
  float _104;
  float _112;
  float _113;
  float _150;
  float _152;
  float _160;
  float _161;
  float _162;
  float _202;
  float _210;
  float _217;
  float _240;
  float _241;
  float _242;
  float _250;
  float _251;
  float _252;
  float _260;
  float _261;
  float _262;
  float _270;
  float _271;
  float _272;
  float _280;
  float _281;
  float _282;
  float _314;
  float _315;
  float4 _341;
  float _361;
  float _362;
  float _364;
  float _367;
  float _379;
  float _380;
  float _384;
  float _395;
  float _407;
  float4 _412;
  float _421;
  float4 _426;
  float _435;
  float _446;
  float4 _451;
  float _459;
  float4 _464;
  float _479;
  float _491;
  float _524;
  float _526;
  float _528;
  float _532;
  float _533;
  float _541;
  float _542;
  float _544;
  float _545;
  float _546;
  float2 _554;
  bool _566;
  float _570;
  float _577;
  float _583;
  float _584;
  float _621;
  float _623;
  float _631;
  float _632;
  float _633;
  float _673;
  float _681;
  float _688;
  float _711;
  float _712;
  float _713;
  float _721;
  float _722;
  float _723;
  float _731;
  float _732;
  float _733;
  float _741;
  float _742;
  float _743;
  float _751;
  float _752;
  float _753;
  float _785;
  float _786;
  float4 _812;
  float _817;
  float _818;
  float4 _822;
  float2 _833;
  bool _843;
  float _847;
  float _854;
  float _862;
  float _863;
  float _900;
  float _902;
  float _910;
  float _911;
  float _912;
  float _954;
  float _962;
  float _969;
  float _992;
  float _993;
  float _994;
  float _1002;
  float _1003;
  float _1004;
  float _1012;
  float _1013;
  float _1014;
  float _1022;
  float _1023;
  float _1024;
  float _1032;
  float _1033;
  float _1034;
  float _1066;
  float _1067;
  float4 _1093;
  float _1129;
  float _1133;
  float _1136;
  float _1139;
  float _1140;
  float _1142;
  float _1144;
  float _1147;
  float _1150;
  float _1156;
  uint _1163;
  uint _1167;
  uint _1170;
  float _1180;
  float _1182;
  float _1183;
  float _1184;
  float _1185;
  float _1187;
  float _1191;
  float _1192;
  float _1194;
  float _1199;
  float _1200;
  float _1201;
  float _1206;
  float _1207;
  float _1208;
  float _1213;
  float _1214;
  float _1215;
  float _1220;
  float _1221;
  float _1222;
  float _1227;
  float _1228;
  float _1229;
  float _1234;
  float _1235;
  float _1236;
  float _1241;
  float _1242;
  float _1245;
  float _1250;
  float _1251;
  float _1253;
  float _1254;
  float _1258;
  float4 _1264;
  float _1268;
  float _1269;
  float _1273;
  float4 _1278;
  float _1285;
  float _1286;
  float _1290;
  float4 _1295;
  float _1302;
  float _1303;
  float _1307;
  float4 _1312;
  float _1319;
  float _1320;
  float _1324;
  float4 _1329;
  float _1336;
  float _1337;
  float _1341;
  float4 _1346;
  float _1353;
  float _1354;
  float _1358;
  float4 _1363;
  float _1370;
  float _1371;
  float _1375;
  float4 _1380;
  float _1387;
  float _1388;
  float _1392;
  float4 _1397;
  float _1405;
  float _1406;
  float _1407;
  float _1408;
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
  float _1428;
  float _1432;
  float _1433;
  float _1440;
  float _1441;
  float4 _1448;
  float _1454;
  float _1458;
  float _1459;
  float _1466;
  float4 _1472;
  float _1481;
  float _1485;
  float _1486;
  float _1493;
  float4 _1499;
  float _1508;
  float _1512;
  float _1513;
  float _1520;
  float4 _1526;
  float _1535;
  float _1539;
  float _1540;
  float _1547;
  float4 _1553;
  float _1562;
  float _1566;
  float _1567;
  float _1574;
  float4 _1580;
  float _1589;
  float _1593;
  float _1594;
  float _1601;
  float4 _1607;
  float _1616;
  float _1620;
  float _1621;
  float _1628;
  float4 _1634;
  float _1643;
  float _1647;
  float _1648;
  float _1655;
  float4 _1661;
  float4 _1670;
  float4 _1674;
  float4 _1681;
  float4 _1688;
  float4 _1695;
  float4 _1702;
  float4 _1709;
  float4 _1716;
  float4 _1723;
  float _1740;
  float _1741;
  float _1742;
  float _1747;
  float _1753;
  float _1782;
  float _1783;
  float _1784;
  float _1801;
  float _1803;
  float _1809;
  int _1814;
  uint _1815;
  float _1825;
  int _1829;
  uint _1830;
  float _1841;
  int _1845;
  uint _1846;
  float _1856;
  float _1857;
  float _1858;
  float _1872;
  float _1900;
  float _1903;
  float _1906;
  float _1912;
  float _1918;
  float _1919;
  float _1920;
  float _1921;
  float _1931;
  float _1952;
  float _1972;
  bool _2020;
  bool _2030;
  bool _2040;
  float4 _2058;
  float4 _2140;
  float _2192;
  float _2193;
  float _2194;
  float4 _2234;
  float4 _2329;
  float _2452;
  float _2453;
  float4 _2456;
  float _2461;
  float _2462;
  float _2463;
  float _2471;
  _30 = ((cPassEnabled & 1) == 0);
  if (!(_30)) {
    _36 = (distortionType == 0);
  } else {
    _36 = false;
  }
  if (!(_30)) {
    _42 = (distortionType == 1);
  } else {
    _42 = false;
  }
  _44 = ((cPassEnabled & 64) != 0);
  if (_36) {
    _61 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    _62 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    _63 = dot(float2(_61, _62), float2(_61, _62));
    _65 = (_63 * fDistortionCoef) + 1.0f;
    _66 = fCorrectCoef * _61;
    _67 = _65 * _66;
    _68 = fCorrectCoef * _62;
    _69 = _65 * _68;
    _70 = _67 + 0.5f;
    _71 = _69 + 0.5f;
    if (aberrationEnable == 0) {
      do {
        _337 = _70;
        _338 = _71;
        if (_44) {
          if (!(fHazeFilterReductionResolution == 0)) {
            _81 = HazeNoiseResult.Sample(BilinearWrap, float2(_70, _71));
            _337 = ((fHazeFilterScale * _81.x) + _70);
            _338 = ((fHazeFilterScale * _81.y) + _71);
          } else {
            _93 = ((fHazeFilterAttribute & 2) != 0);
            _97 = tFilterTempMap1.Sample(BilinearWrap, float2(_70, _71));
            do {
              if (_93) {
                _104 = ReadonlyDepth.SampleLevel(PointClamp, float2(_70, _71), 0.0f);
                _112 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _70) + -1.0f;
                _113 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _71);
                _150 = 1.0f / (mad(_104.x, (viewProjInvMat[2].w), mad(_113, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _112))) + (viewProjInvMat[3].w));
                _152 = _150 * (mad(_104.x, (viewProjInvMat[2].y), mad(_113, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _112))) + (viewProjInvMat[3].y));
                _160 = (_150 * (mad(_104.x, (viewProjInvMat[2].x), mad(_113, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _112))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _161 = _152 - (transposeViewInvMat[1].w);
                _162 = (_150 * (mad(_104.x, (viewProjInvMat[2].z), mad(_113, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _112))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _187 = saturate(max(((sqrt(((_161 * _161) + (_160 * _160)) + (_162 * _162)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_152 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _97.x);
                _188 = _104.x;
              } else {
                _187 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _97.x), _97.x);
                _188 = 0.0f;
              }
              do {
                _209 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _202 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _209 = (1.0f - saturate(max((_202 * min(max((abs(_67) - fHazeFilterBorder), 0.0f), 1.0f)), (_202 * min(max((abs(_69) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _210 = _209 * _187;
                do {
                  _328 = 0.0f;
                  _329 = 0.0f;
                  if (!(_210 <= 9.999999747378752e-06f)) {
                    _217 = -0.0f - _71;
                    _240 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_217, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _70))) * fHazeFilterUVWOffset.w;
                    _241 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_217, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _70))) * fHazeFilterUVWOffset.w;
                    _242 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_217, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _70))) * fHazeFilterUVWOffset.w;
                    _250 = _240 * 2.0f;
                    _251 = _241 * 2.0f;
                    _252 = _242 * 2.0f;
                    _260 = _240 * 4.0f;
                    _261 = _241 * 4.0f;
                    _262 = _242 * 4.0f;
                    _270 = _240 * 8.0f;
                    _271 = _241 * 8.0f;
                    _272 = _242 * 8.0f;
                    _280 = fHazeFilterUVWOffset.x + 0.5f;
                    _281 = fHazeFilterUVWOffset.y + 0.5f;
                    _282 = fHazeFilterUVWOffset.z + 0.5f;
                    _314 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_250 + fHazeFilterUVWOffset.x), (_251 + fHazeFilterUVWOffset.y), (_252 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_240 + fHazeFilterUVWOffset.x), (_241 + fHazeFilterUVWOffset.y), (_242 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_260 + fHazeFilterUVWOffset.x), (_261 + fHazeFilterUVWOffset.y), (_262 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_270 + fHazeFilterUVWOffset.x), (_271 + fHazeFilterUVWOffset.y), (_272 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _210;
                    _315 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_250 + _280), (_251 + _281), (_252 + _282)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_240 + _280), (_241 + _281), (_242 + _282)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_260 + _280), (_261 + _281), (_262 + _282)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_270 + _280), (_271 + _281), (_272 + _282)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _210;
                    if (_93) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2((_314 + _70), (_315 + _71)))).x) - _188) >= fHazeFilterDepthDiffBias)) {
                        _328 = _314;
                        _329 = _315;
                      } else {
                        _328 = 0.0f;
                        _329 = 0.0f;
                      }
                    } else {
                      _328 = _314;
                      _329 = _315;
                    }
                  }
                  _337 = ((fHazeFilterScale * _328) + _70);
                  _338 = ((fHazeFilterScale * _329) + _71);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        _341 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_337, _338));
        _1098 = fDistortionCoef;
        _1099 = fCorrectCoef;
        _1100 = 0.0f;
        _1101 = 0.0f;
        _1102 = 0.0f;
        _1103 = 0.0f;
        _1104 = _341.x;
        _1105 = _341.y;
        _1106 = _341.z;
      } while (false);
    } else {
      _361 = ((saturate((sqrt((_61 * _61) + (_62 * _62)) - fGradationStartOffset) / (fGradationEndOffset - fGradationStartOffset)) * (1.0f - fRefractionCenterRate)) + fRefractionCenterRate) * fRefraction;
      _362 = _361 + _63;
      _364 = (_362 * fDistortionCoef) + 1.0f;
      _367 = ((_362 + _361) * fDistortionCoef) + 1.0f;
      if (!(aberrationBlurEnable == 0)) {
        _379 = (fBlurNoisePower * 0.125f) * frac(frac((SV_Position.y * 0.005837149918079376f) + (SV_Position.x * 0.0671105608344078f)) * 52.98291778564453f);
        _380 = _361 * 2.0f;
        _384 = (((_379 * _380) + _63) * fDistortionCoef) + 1.0f;
        _395 = ((((_379 + 0.125f) * _380) + _63) * fDistortionCoef) + 1.0f;
        _407 = ((((_379 + 0.25f) * _380) + _63) * fDistortionCoef) + 1.0f;
        _412 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_407 * _66) + 0.5f), ((_407 * _68) + 0.5f)));
        _421 = ((((_379 + 0.375f) * _380) + _63) * fDistortionCoef) + 1.0f;
        _426 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_421 * _66) + 0.5f), ((_421 * _68) + 0.5f)));
        _435 = ((((_379 + 0.5f) * _380) + _63) * fDistortionCoef) + 1.0f;
        _446 = ((((_379 + 0.625f) * _380) + _63) * fDistortionCoef) + 1.0f;
        _451 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_446 * _66) + 0.5f), ((_446 * _68) + 0.5f)));
        _459 = ((((_379 + 0.75f) * _380) + _63) * fDistortionCoef) + 1.0f;
        _464 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_459 * _66) + 0.5f), ((_459 * _68) + 0.5f)));
        _479 = ((((_379 + 0.875f) * _380) + _63) * fDistortionCoef) + 1.0f;
        _491 = ((((_379 + 1.0f) * _380) + _63) * fDistortionCoef) + 1.0f;
        _1098 = fDistortionCoef;
        _1099 = fCorrectCoef;
        _1100 = 0.0f;
        _1101 = 0.0f;
        _1102 = 0.0f;
        _1103 = 0.0f;
        _1104 = (((((((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_395 * _66) + 0.5f), ((_395 * _68) + 0.5f))))).x) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_384 * _66) + 0.5f), ((_384 * _68) + 0.5f))))).x)) + (_412.x * 0.75f)) + (_426.x * 0.375f)) * 0.3199999928474426f);
        _1105 = (((((_451.y + _426.y) * 0.625f) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_435 * _66) + 0.5f), ((_435 * _68) + 0.5f))))).y)) + ((_464.y + _412.y) * 0.25f)) * 0.3636363744735718f);
        _1106 = (((((_464.z * 0.75f) + (_451.z * 0.375f)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_479 * _66) + 0.5f), ((_479 * _68) + 0.5f))))).z)) + (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_491 * _66) + 0.5f), ((_491 * _68) + 0.5f))))).z)) * 0.3199999928474426f);
      } else {
        _1098 = fDistortionCoef;
        _1099 = fCorrectCoef;
        _1100 = 0.0f;
        _1101 = 0.0f;
        _1102 = 0.0f;
        _1103 = 0.0f;
        _1104 = (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_70, _71)))).x);
        _1105 = (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_364 * _66) + 0.5f), ((_364 * _68) + 0.5f))))).y);
        _1106 = (((float4)(RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_367 * _66) + 0.5f), ((_367 * _68) + 0.5f))))).z);
      }
    }
  } else {
    if (_42) {
      _524 = screenInverseSize.x * 2.0f;
      _526 = screenInverseSize.y * 2.0f;
      _528 = (_524 * SV_Position.x) + -1.0f;
      _532 = sqrt((_528 * _528) + 1.0f);
      _533 = 1.0f / _532;
      _541 = ((_532 * fOptimizedParam.z) * (_533 + fOptimizedParam.x)) * (fOptimizedParam.w * 0.5f);
      _542 = _541 * _528;
      _544 = (_541 * ((_526 * SV_Position.y) + -1.0f)) * (((_533 + -1.0f) * fOptimizedParam.y) + 1.0f);
      _545 = _542 + 0.5f;
      _546 = _544 + 0.5f;
      do {
        _808 = _545;
        _809 = _546;
        if (_44) {
          if (!(fHazeFilterReductionResolution == 0)) {
            _554 = HazeNoiseResult.Sample(BilinearWrap, float2(_545, _546));
            _808 = ((fHazeFilterScale * _554.x) + _545);
            _809 = ((fHazeFilterScale * _554.y) + _546);
          } else {
            _566 = ((fHazeFilterAttribute & 2) != 0);
            _570 = tFilterTempMap1.Sample(BilinearWrap, float2(_545, _546));
            do {
              if (_566) {
                _577 = ReadonlyDepth.SampleLevel(PointClamp, float2(_545, _546), 0.0f);
                _583 = ((_524 * screenSize.x) * _545) + -1.0f;
                _584 = 1.0f - ((_526 * screenSize.y) * _546);
                _621 = 1.0f / (mad(_577.x, (viewProjInvMat[2].w), mad(_584, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _583))) + (viewProjInvMat[3].w));
                _623 = _621 * (mad(_577.x, (viewProjInvMat[2].y), mad(_584, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _583))) + (viewProjInvMat[3].y));
                _631 = (_621 * (mad(_577.x, (viewProjInvMat[2].x), mad(_584, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _583))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _632 = _623 - (transposeViewInvMat[1].w);
                _633 = (_621 * (mad(_577.x, (viewProjInvMat[2].z), mad(_584, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _583))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _658 = saturate(max(((sqrt(((_632 * _632) + (_631 * _631)) + (_633 * _633)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_623 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _570.x);
                _659 = _577.x;
              } else {
                _658 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _570.x), _570.x);
                _659 = 0.0f;
              }
              do {
                _680 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _673 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _680 = (1.0f - saturate(max((_673 * min(max((abs(_542) - fHazeFilterBorder), 0.0f), 1.0f)), (_673 * min(max((abs(_544) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _681 = _680 * _658;
                do {
                  _799 = 0.0f;
                  _800 = 0.0f;
                  if (!(_681 <= 9.999999747378752e-06f)) {
                    _688 = -0.0f - _546;
                    _711 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_688, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _545))) * fHazeFilterUVWOffset.w;
                    _712 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_688, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _545))) * fHazeFilterUVWOffset.w;
                    _713 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_688, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _545))) * fHazeFilterUVWOffset.w;
                    _721 = _711 * 2.0f;
                    _722 = _712 * 2.0f;
                    _723 = _713 * 2.0f;
                    _731 = _711 * 4.0f;
                    _732 = _712 * 4.0f;
                    _733 = _713 * 4.0f;
                    _741 = _711 * 8.0f;
                    _742 = _712 * 8.0f;
                    _743 = _713 * 8.0f;
                    _751 = fHazeFilterUVWOffset.x + 0.5f;
                    _752 = fHazeFilterUVWOffset.y + 0.5f;
                    _753 = fHazeFilterUVWOffset.z + 0.5f;
                    _785 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_721 + fHazeFilterUVWOffset.x), (_722 + fHazeFilterUVWOffset.y), (_723 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_711 + fHazeFilterUVWOffset.x), (_712 + fHazeFilterUVWOffset.y), (_713 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_731 + fHazeFilterUVWOffset.x), (_732 + fHazeFilterUVWOffset.y), (_733 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_741 + fHazeFilterUVWOffset.x), (_742 + fHazeFilterUVWOffset.y), (_743 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _681;
                    _786 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_721 + _751), (_722 + _752), (_723 + _753)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_711 + _751), (_712 + _752), (_713 + _753)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_731 + _751), (_732 + _752), (_733 + _753)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_741 + _751), (_742 + _752), (_743 + _753)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _681;
                    if (_566) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2((_785 + _545), (_786 + _546)))).x) - _659) >= fHazeFilterDepthDiffBias)) {
                        _799 = _785;
                        _800 = _786;
                      } else {
                        _799 = 0.0f;
                        _800 = 0.0f;
                      }
                    } else {
                      _799 = _785;
                      _800 = _786;
                    }
                  }
                  _808 = ((fHazeFilterScale * _799) + _545);
                  _809 = ((fHazeFilterScale * _800) + _546);
                } while (false);
              } while (false);
            } while (false);
          }
        }
        _812 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_808, _809));
        _1098 = 0.0f;
        _1099 = 1.0f;
        _1100 = fOptimizedParam.x;
        _1101 = fOptimizedParam.y;
        _1102 = fOptimizedParam.z;
        _1103 = fOptimizedParam.w;
        _1104 = _812.x;
        _1105 = _812.y;
        _1106 = _812.z;
      } while (false);
    } else {
      _817 = screenInverseSize.x * SV_Position.x;
      _818 = screenInverseSize.y * SV_Position.y;
      if (!(_44)) {
        _822 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_817, _818));
        _1098 = 0.0f;
        _1099 = 1.0f;
        _1100 = 0.0f;
        _1101 = 0.0f;
        _1102 = 0.0f;
        _1103 = 0.0f;
        _1104 = _822.x;
        _1105 = _822.y;
        _1106 = _822.z;
      } else {
        do {
          if (!(fHazeFilterReductionResolution == 0)) {
            _833 = HazeNoiseResult.Sample(BilinearWrap, float2(_817, _818));
            _1087 = (fHazeFilterScale * _833.x);
            _1088 = (fHazeFilterScale * _833.y);
          } else {
            _843 = ((fHazeFilterAttribute & 2) != 0);
            _847 = tFilterTempMap1.Sample(BilinearWrap, float2(_817, _818));
            do {
              if (_843) {
                _854 = ReadonlyDepth.SampleLevel(PointClamp, float2(_817, _818), 0.0f);
                _862 = (((screenInverseSize.x * 2.0f) * screenSize.x) * _817) + -1.0f;
                _863 = 1.0f - (((screenInverseSize.y * 2.0f) * screenSize.y) * _818);
                _900 = 1.0f / (mad(_854.x, (viewProjInvMat[2].w), mad(_863, (viewProjInvMat[1].w), ((viewProjInvMat[0].w) * _862))) + (viewProjInvMat[3].w));
                _902 = _900 * (mad(_854.x, (viewProjInvMat[2].y), mad(_863, (viewProjInvMat[1].y), ((viewProjInvMat[0].y) * _862))) + (viewProjInvMat[3].y));
                _910 = (_900 * (mad(_854.x, (viewProjInvMat[2].x), mad(_863, (viewProjInvMat[1].x), ((viewProjInvMat[0].x) * _862))) + (viewProjInvMat[3].x))) - (transposeViewInvMat[0].w);
                _911 = _902 - (transposeViewInvMat[1].w);
                _912 = (_900 * (mad(_854.x, (viewProjInvMat[2].z), mad(_863, (viewProjInvMat[1].z), ((viewProjInvMat[0].z) * _862))) + (viewProjInvMat[3].z))) - (transposeViewInvMat[2].w);
                _937 = saturate(max(((sqrt(((_911 * _911) + (_910 * _910)) + (_912 * _912)) - fHazeFilterStart) * fHazeFilterInverseRange), ((_902 - fHazeFilterHeightStart) * fHazeFilterHeightInverseRange)) * _847.x);
                _938 = _854.x;
              } else {
                _937 = select(((fHazeFilterAttribute & 1) != 0), (1.0f - _847.x), _847.x);
                _938 = 0.0f;
              }
              do {
                _961 = 1.0f;
                if (!((fHazeFilterAttribute & 4) == 0)) {
                  _954 = (0.5f / fHazeFilterBorder) * fHazeFilterBorderFade;
                  _961 = (1.0f - saturate(max((_954 * min(max((abs(_817 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)), (_954 * min(max((abs(_818 + -0.5f) - fHazeFilterBorder), 0.0f), 1.0f)))));
                }
                _962 = _961 * _937;
                do {
                  _1080 = 0.0f;
                  _1081 = 0.0f;
                  if (!(_962 <= 9.999999747378752e-06f)) {
                    _969 = -0.0f - _818;
                    _992 = mad(-1.0f, (transposeViewInvMat[0].z), mad(_969, (transposeViewInvMat[0].y), ((transposeViewInvMat[0].x) * _817))) * fHazeFilterUVWOffset.w;
                    _993 = mad(-1.0f, (transposeViewInvMat[1].z), mad(_969, (transposeViewInvMat[1].y), ((transposeViewInvMat[1].x) * _817))) * fHazeFilterUVWOffset.w;
                    _994 = mad(-1.0f, (transposeViewInvMat[2].z), mad(_969, (transposeViewInvMat[2].y), ((transposeViewInvMat[2].x) * _817))) * fHazeFilterUVWOffset.w;
                    _1002 = _992 * 2.0f;
                    _1003 = _993 * 2.0f;
                    _1004 = _994 * 2.0f;
                    _1012 = _992 * 4.0f;
                    _1013 = _993 * 4.0f;
                    _1014 = _994 * 4.0f;
                    _1022 = _992 * 8.0f;
                    _1023 = _993 * 8.0f;
                    _1024 = _994 * 8.0f;
                    _1032 = fHazeFilterUVWOffset.x + 0.5f;
                    _1033 = fHazeFilterUVWOffset.y + 0.5f;
                    _1034 = fHazeFilterUVWOffset.z + 0.5f;
                    _1066 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1002 + fHazeFilterUVWOffset.x), (_1003 + fHazeFilterUVWOffset.y), (_1004 + fHazeFilterUVWOffset.z)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_992 + fHazeFilterUVWOffset.x), (_993 + fHazeFilterUVWOffset.y), (_994 + fHazeFilterUVWOffset.z)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1012 + fHazeFilterUVWOffset.x), (_1013 + fHazeFilterUVWOffset.y), (_1014 + fHazeFilterUVWOffset.z)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1022 + fHazeFilterUVWOffset.x), (_1023 + fHazeFilterUVWOffset.y), (_1024 + fHazeFilterUVWOffset.z)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _962;
                    _1067 = ((((((((tVolumeMap.Sample(BilinearWrap, float3((_1002 + _1032), (_1003 + _1033), (_1004 + _1034)))).x) * 0.25f) + (((tVolumeMap.Sample(BilinearWrap, float3((_992 + _1032), (_993 + _1033), (_994 + _1034)))).x) * 0.5f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1012 + _1032), (_1013 + _1033), (_1014 + _1034)))).x) * 0.125f)) + (((tVolumeMap.Sample(BilinearWrap, float3((_1022 + _1032), (_1023 + _1033), (_1024 + _1034)))).x) * 0.0625f)) * 2.0f) + -1.0f) * _962;
                    if (_843) {
                      if (!((((ReadonlyDepth.Sample(BilinearWrap, float2((_1066 + _817), (_1067 + _818)))).x) - _938) >= fHazeFilterDepthDiffBias)) {
                        _1080 = _1066;
                        _1081 = _1067;
                      } else {
                        _1080 = 0.0f;
                        _1081 = 0.0f;
                      }
                    } else {
                      _1080 = _1066;
                      _1081 = _1067;
                    }
                  }
                  _1087 = (fHazeFilterScale * _1080);
                  _1088 = (fHazeFilterScale * _1081);
                } while (false);
              } while (false);
            } while (false);
          }
          _1093 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_1087 + _817), (_1088 + _818)));
          _1098 = 0.0f;
          _1099 = 1.0f;
          _1100 = 0.0f;
          _1101 = 0.0f;
          _1102 = 0.0f;
          _1103 = 0.0f;
          _1104 = _1093.x;
          _1105 = _1093.y;
          _1106 = _1093.z;
        } while (false);
      }
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    _1129 = (float)((bool)(uint)((cbRadialBlurFlags & 2) != 0));
    _1133 = ComputeResultSRV[0].computeAlpha;
    _1136 = ((1.0f - _1129) + (_1133 * _1129)) * cbRadialColor.w;
    if (!(_1136 == 0.0f)) {
      _1139 = screenInverseSize.x * SV_Position.x;
      _1140 = screenInverseSize.y * SV_Position.y;
      _1142 = _1139 + (-0.5f - cbRadialScreenPos.x);
      _1144 = _1140 + (-0.5f - cbRadialScreenPos.y);
      _1147 = select((_1142 < 0.0f), (1.0f - _1139), _1139);
      _1150 = select((_1144 < 0.0f), (1.0f - _1140), _1140);
      do {
        _1176 = 1.0f;
        if (!((cbRadialBlurFlags & 1) == 0)) {
          _1156 = rsqrt(dot(float2(_1142, _1144), float2(_1142, _1144))) * cbRadialSharpRange;
          _1163 = uint(abs(_1156 * _1144)) + uint(abs(_1156 * _1142));
          _1167 = ((_1163 ^ 61) ^ ((uint)(_1163) >> 16)) * 9;
          _1170 = (((uint)(_1167) >> 4) ^ _1167) * 668265261;
          _1176 = (((float)((uint)((uint)(((uint)(_1170) >> 15) ^ _1170)))) * 2.3283064365386963e-10f);
        }
        _1180 = sqrt((_1142 * _1142) + (_1144 * _1144));
        _1182 = 1.0f / max(1.0f, _1180);
        _1183 = _1176 * _1147;
        _1184 = cbRadialBlurPower * _1182;
        _1185 = _1184 * -0.0011111111380159855f;
        _1187 = _1176 * _1150;
        _1191 = ((_1185 * _1183) + 1.0f) * _1142;
        _1192 = ((_1185 * _1187) + 1.0f) * _1144;
        _1194 = _1184 * -0.002222222276031971f;
        _1199 = ((_1194 * _1183) + 1.0f) * _1142;
        _1200 = ((_1194 * _1187) + 1.0f) * _1144;
        _1201 = _1184 * -0.0033333334140479565f;
        _1206 = ((_1201 * _1183) + 1.0f) * _1142;
        _1207 = ((_1201 * _1187) + 1.0f) * _1144;
        _1208 = _1184 * -0.004444444552063942f;
        _1213 = ((_1208 * _1183) + 1.0f) * _1142;
        _1214 = ((_1208 * _1187) + 1.0f) * _1144;
        _1215 = _1184 * -0.0055555556900799274f;
        _1220 = ((_1215 * _1183) + 1.0f) * _1142;
        _1221 = ((_1215 * _1187) + 1.0f) * _1144;
        _1222 = _1184 * -0.006666666828095913f;
        _1227 = ((_1222 * _1183) + 1.0f) * _1142;
        _1228 = ((_1222 * _1187) + 1.0f) * _1144;
        _1229 = _1184 * -0.007777777966111898f;
        _1234 = ((_1229 * _1183) + 1.0f) * _1142;
        _1235 = ((_1229 * _1187) + 1.0f) * _1144;
        _1236 = _1184 * -0.008888889104127884f;
        _1241 = ((_1236 * _1183) + 1.0f) * _1142;
        _1242 = ((_1236 * _1187) + 1.0f) * _1144;
        _1245 = _1182 * ((cbRadialBlurPower * -0.009999999776482582f) * _1176);
        _1250 = ((_1245 * _1147) + 1.0f) * _1142;
        _1251 = ((_1245 * _1150) + 1.0f) * _1144;
        do {
          if (_36) {
            _1253 = _1191 + cbRadialScreenPos.x;
            _1254 = _1192 + cbRadialScreenPos.y;
            _1258 = ((dot(float2(_1253, _1254), float2(_1253, _1254)) * _1098) + 1.0f) * _1099;
            _1264 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1258 * _1253) + 0.5f), ((_1258 * _1254) + 0.5f)), 0.0f);
            _1268 = _1199 + cbRadialScreenPos.x;
            _1269 = _1200 + cbRadialScreenPos.y;
            _1273 = ((dot(float2(_1268, _1269), float2(_1268, _1269)) * _1098) + 1.0f) * _1099;
            _1278 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1273 * _1268) + 0.5f), ((_1273 * _1269) + 0.5f)), 0.0f);
            _1285 = _1206 + cbRadialScreenPos.x;
            _1286 = _1207 + cbRadialScreenPos.y;
            _1290 = ((dot(float2(_1285, _1286), float2(_1285, _1286)) * _1098) + 1.0f) * _1099;
            _1295 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1290 * _1285) + 0.5f), ((_1290 * _1286) + 0.5f)), 0.0f);
            _1302 = _1213 + cbRadialScreenPos.x;
            _1303 = _1214 + cbRadialScreenPos.y;
            _1307 = ((dot(float2(_1302, _1303), float2(_1302, _1303)) * _1098) + 1.0f) * _1099;
            _1312 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1307 * _1302) + 0.5f), ((_1307 * _1303) + 0.5f)), 0.0f);
            _1319 = _1220 + cbRadialScreenPos.x;
            _1320 = _1221 + cbRadialScreenPos.y;
            _1324 = ((dot(float2(_1319, _1320), float2(_1319, _1320)) * _1098) + 1.0f) * _1099;
            _1329 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1324 * _1319) + 0.5f), ((_1324 * _1320) + 0.5f)), 0.0f);
            _1336 = _1227 + cbRadialScreenPos.x;
            _1337 = _1228 + cbRadialScreenPos.y;
            _1341 = ((dot(float2(_1336, _1337), float2(_1336, _1337)) * _1098) + 1.0f) * _1099;
            _1346 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1341 * _1336) + 0.5f), ((_1341 * _1337) + 0.5f)), 0.0f);
            _1353 = _1234 + cbRadialScreenPos.x;
            _1354 = _1235 + cbRadialScreenPos.y;
            _1358 = ((dot(float2(_1353, _1354), float2(_1353, _1354)) * _1098) + 1.0f) * _1099;
            _1363 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1358 * _1353) + 0.5f), ((_1358 * _1354) + 0.5f)), 0.0f);
            _1370 = _1241 + cbRadialScreenPos.x;
            _1371 = _1242 + cbRadialScreenPos.y;
            _1375 = ((dot(float2(_1370, _1371), float2(_1370, _1371)) * _1098) + 1.0f) * _1099;
            _1380 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1375 * _1370) + 0.5f), ((_1375 * _1371) + 0.5f)), 0.0f);
            _1387 = _1250 + cbRadialScreenPos.x;
            _1388 = _1251 + cbRadialScreenPos.y;
            _1392 = ((dot(float2(_1387, _1388), float2(_1387, _1388)) * _1098) + 1.0f) * _1099;
            _1397 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1392 * _1387) + 0.5f), ((_1392 * _1388) + 0.5f)), 0.0f);
            _1731 = ((((((((_1278.x + _1264.x) + _1295.x) + _1312.x) + _1329.x) + _1346.x) + _1363.x) + _1380.x) + _1397.x);
            _1732 = ((((((((_1278.y + _1264.y) + _1295.y) + _1312.y) + _1329.y) + _1346.y) + _1363.y) + _1380.y) + _1397.y);
            _1733 = ((((((((_1278.z + _1264.z) + _1295.z) + _1312.z) + _1329.z) + _1346.z) + _1363.z) + _1380.z) + _1397.z);
          } else {
            _1405 = cbRadialScreenPos.x + 0.5f;
            _1406 = _1191 + _1405;
            _1407 = cbRadialScreenPos.y + 0.5f;
            _1408 = _1192 + _1407;
            _1409 = _1199 + _1405;
            _1410 = _1200 + _1407;
            _1411 = _1206 + _1405;
            _1412 = _1207 + _1407;
            _1413 = _1213 + _1405;
            _1414 = _1214 + _1407;
            _1415 = _1220 + _1405;
            _1416 = _1221 + _1407;
            _1417 = _1227 + _1405;
            _1418 = _1228 + _1407;
            _1419 = _1234 + _1405;
            _1420 = _1235 + _1407;
            _1421 = _1241 + _1405;
            _1422 = _1242 + _1407;
            _1423 = _1250 + _1405;
            _1424 = _1251 + _1407;
            if (_42) {
              _1428 = (_1406 * 2.0f) + -1.0f;
              _1432 = sqrt((_1428 * _1428) + 1.0f);
              _1433 = 1.0f / _1432;
              _1440 = _1103 * 0.5f;
              _1441 = ((_1432 * _1102) * (_1433 + _1100)) * _1440;
              _1448 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1441 * _1428) + 0.5f), (((_1441 * ((_1408 * 2.0f) + -1.0f)) * (((_1433 + -1.0f) * _1101) + 1.0f)) + 0.5f)), 0.0f);
              _1454 = (_1409 * 2.0f) + -1.0f;
              _1458 = sqrt((_1454 * _1454) + 1.0f);
              _1459 = 1.0f / _1458;
              _1466 = ((_1458 * _1102) * (_1459 + _1100)) * _1440;
              _1472 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1466 * _1454) + 0.5f), (((_1466 * ((_1410 * 2.0f) + -1.0f)) * (((_1459 + -1.0f) * _1101) + 1.0f)) + 0.5f)), 0.0f);
              _1481 = (_1411 * 2.0f) + -1.0f;
              _1485 = sqrt((_1481 * _1481) + 1.0f);
              _1486 = 1.0f / _1485;
              _1493 = ((_1485 * _1102) * (_1486 + _1100)) * _1440;
              _1499 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1493 * _1481) + 0.5f), (((_1493 * ((_1412 * 2.0f) + -1.0f)) * (((_1486 + -1.0f) * _1101) + 1.0f)) + 0.5f)), 0.0f);
              _1508 = (_1413 * 2.0f) + -1.0f;
              _1512 = sqrt((_1508 * _1508) + 1.0f);
              _1513 = 1.0f / _1512;
              _1520 = ((_1512 * _1102) * (_1513 + _1100)) * _1440;
              _1526 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1520 * _1508) + 0.5f), (((_1520 * ((_1414 * 2.0f) + -1.0f)) * (((_1513 + -1.0f) * _1101) + 1.0f)) + 0.5f)), 0.0f);
              _1535 = (_1415 * 2.0f) + -1.0f;
              _1539 = sqrt((_1535 * _1535) + 1.0f);
              _1540 = 1.0f / _1539;
              _1547 = ((_1539 * _1102) * (_1540 + _1100)) * _1440;
              _1553 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1547 * _1535) + 0.5f), (((_1547 * ((_1416 * 2.0f) + -1.0f)) * (((_1540 + -1.0f) * _1101) + 1.0f)) + 0.5f)), 0.0f);
              _1562 = (_1417 * 2.0f) + -1.0f;
              _1566 = sqrt((_1562 * _1562) + 1.0f);
              _1567 = 1.0f / _1566;
              _1574 = ((_1566 * _1102) * (_1567 + _1100)) * _1440;
              _1580 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1574 * _1562) + 0.5f), (((_1574 * ((_1418 * 2.0f) + -1.0f)) * (((_1567 + -1.0f) * _1101) + 1.0f)) + 0.5f)), 0.0f);
              _1589 = (_1419 * 2.0f) + -1.0f;
              _1593 = sqrt((_1589 * _1589) + 1.0f);
              _1594 = 1.0f / _1593;
              _1601 = ((_1593 * _1102) * (_1594 + _1100)) * _1440;
              _1607 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1601 * _1589) + 0.5f), (((_1601 * ((_1420 * 2.0f) + -1.0f)) * (((_1594 + -1.0f) * _1101) + 1.0f)) + 0.5f)), 0.0f);
              _1616 = (_1421 * 2.0f) + -1.0f;
              _1620 = sqrt((_1616 * _1616) + 1.0f);
              _1621 = 1.0f / _1620;
              _1628 = ((_1620 * _1102) * (_1621 + _1100)) * _1440;
              _1634 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1628 * _1616) + 0.5f), (((_1628 * ((_1422 * 2.0f) + -1.0f)) * (((_1621 + -1.0f) * _1101) + 1.0f)) + 0.5f)), 0.0f);
              _1643 = (_1423 * 2.0f) + -1.0f;
              _1647 = sqrt((_1643 * _1643) + 1.0f);
              _1648 = 1.0f / _1647;
              _1655 = ((_1647 * _1102) * (_1648 + _1100)) * _1440;
              _1661 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1655 * _1643) + 0.5f), (((_1655 * ((_1424 * 2.0f) + -1.0f)) * (((_1648 + -1.0f) * _1101) + 1.0f)) + 0.5f)), 0.0f);
              _1731 = ((((((((_1472.x + _1448.x) + _1499.x) + _1526.x) + _1553.x) + _1580.x) + _1607.x) + _1634.x) + _1661.x);
              _1732 = ((((((((_1472.y + _1448.y) + _1499.y) + _1526.y) + _1553.y) + _1580.y) + _1607.y) + _1634.y) + _1661.y);
              _1733 = ((((((((_1472.z + _1448.z) + _1499.z) + _1526.z) + _1553.z) + _1580.z) + _1607.z) + _1634.z) + _1661.z);
            } else {
              _1670 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1406, _1408), 0.0f);
              _1674 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1409, _1410), 0.0f);
              _1681 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1411, _1412), 0.0f);
              _1688 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1413, _1414), 0.0f);
              _1695 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1415, _1416), 0.0f);
              _1702 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1417, _1418), 0.0f);
              _1709 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1419, _1420), 0.0f);
              _1716 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1421, _1422), 0.0f);
              _1723 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1423, _1424), 0.0f);
              _1731 = ((((((((_1674.x + _1670.x) + _1681.x) + _1688.x) + _1695.x) + _1702.x) + _1709.x) + _1716.x) + _1723.x);
              _1732 = ((((((((_1674.y + _1670.y) + _1681.y) + _1688.y) + _1695.y) + _1702.y) + _1709.y) + _1716.y) + _1723.y);
              _1733 = ((((((((_1674.z + _1670.z) + _1681.z) + _1688.z) + _1695.z) + _1702.z) + _1709.z) + _1716.z) + _1723.z);
            }
          }
          _1740 = ((_1104 + _1731) * 0.10000000149011612f) * cbRadialColor.x;
          _1741 = ((_1105 + _1732) * 0.10000000149011612f) * cbRadialColor.y;
          _1742 = ((_1106 + _1733) * 0.10000000149011612f) * cbRadialColor.z;
          do {
            _1764 = _1740;
            _1765 = _1741;
            _1766 = _1742;
            if (cbRadialMaskRate.x > 0.0f) {
              _1747 = saturate((_1180 * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
              _1753 = (((_1747 * _1747) * cbRadialMaskRate.x) * (3.0f - (_1747 * 2.0f))) + cbRadialMaskRate.y;
              _1764 = ((_1753 * (_1740 - _1104)) + _1104);
              _1765 = ((_1753 * (_1741 - _1105)) + _1105);
              _1766 = ((_1753 * (_1742 - _1106)) + _1106);
            }
            _1777 = (lerp(_1104, _1764, _1136));
            _1778 = (lerp(_1105, _1765, _1136));
            _1779 = (lerp(_1106, _1766, _1136));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1777 = _1104;
      _1778 = _1105;
      _1779 = _1106;
    }
  } else {
    _1777 = _1104;
    _1778 = _1105;
    _1779 = _1106;
  }
  _1782 = rangeDecompress * _1777;
  _1783 = rangeDecompress * _1778;
  _1784 = rangeDecompress * _1779;
  if (!((cPassEnabled & 2) == 0)) {
    _1801 = floor(fReverseNoiseSize * (fNoiseUVOffset.x + SV_Position.x));
    _1803 = floor(fReverseNoiseSize * (fNoiseUVOffset.y + SV_Position.y));
    _1809 = frac(frac((_1803 * 0.005837149918079376f) + (_1801 * 0.0671105608344078f)) * 52.98291778564453f);
    do {
      _1823 = 0.0f;
      if (_1809 < fNoiseDensity) {
        _1814 = (int)(uint(_1803 * _1801)) ^ 12345391;
        _1815 = _1814 * 3635641;
        _1823 = (((float)((uint)((uint)((((uint)(_1815) >> 26) | ((int)(_1814 * 232681024))) ^ _1815)))) * 2.3283064365386963e-10f);
      }
      _1825 = frac(_1809 * 757.4846801757812f);
      do {
        _1839 = 0.0f;
        if (_1825 < fNoiseDensity) {
          _1829 = asint(_1825) ^ 12345391;
          _1830 = _1829 * 3635641;
          _1839 = ((((float)((uint)((uint)((((uint)(_1830) >> 26) | ((int)(_1829 * 232681024))) ^ _1830)))) * 2.3283064365386963e-10f) + -0.5f);
        }
        _1841 = frac(_1825 * 757.4846801757812f);
        do {
          _1855 = 0.0f;
          if (_1841 < fNoiseDensity) {
            _1845 = asint(_1841) ^ 12345391;
            _1846 = _1845 * 3635641;
            _1855 = ((((float)((uint)((uint)((((uint)(_1846) >> 26) | ((int)(_1845 * 232681024))) ^ _1846)))) * 2.3283064365386963e-10f) + -0.5f);
          }
          _1856 = _1823 * CUSTOM_NOISE * fNoisePower.x;
          _1857 = _1855 * CUSTOM_NOISE * fNoisePower.y;
          _1858 = _1839 * CUSTOM_NOISE * fNoisePower.y;
          _1872 = exp2(log2(1.0f - saturate(dot(float3(saturate(_1782), saturate(_1783), saturate(_1784)), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1883 = ((_1872 * (mad(_1858, 1.4019999504089355f, _1856) - _1782)) + _1782);
          _1884 = ((_1872 * (mad(_1858, -0.7139999866485596f, mad(_1857, -0.3440000116825104f, _1856)) - _1783)) + _1783);
          _1885 = ((_1872 * (mad(_1857, 1.7719999551773071f, _1856) - _1784)) + _1784);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1883 = _1782;
    _1884 = _1783;
    _1885 = _1784;
  }
  _1900 = mad(_1885, (fOCIOTransformMatrix[2].x), mad(_1884, (fOCIOTransformMatrix[1].x), ((fOCIOTransformMatrix[0].x) * _1883)));
  _1903 = mad(_1885, (fOCIOTransformMatrix[2].y), mad(_1884, (fOCIOTransformMatrix[1].y), ((fOCIOTransformMatrix[0].y) * _1883)));
  _1906 = mad(_1885, (fOCIOTransformMatrix[2].z), mad(_1884, (fOCIOTransformMatrix[1].z), ((fOCIOTransformMatrix[0].z) * _1883)));
  if (!(cbControlRGCParam.EnableReferenceGamutCompress == 0)) {
    _1912 = max(max(_1900, _1903), _1906);
    if (!(_1912 == 0.0f)) {
      _1918 = abs(_1912);
      _1919 = (_1912 - _1900) / _1918;
      _1920 = (_1912 - _1903) / _1918;
      _1921 = (_1912 - _1906) / _1918;
      do {
        _1943 = _1919;
        if (!(!(_1919 >= cbControlRGCParam.CyanThreshold))) {
          _1931 = _1919 - cbControlRGCParam.CyanThreshold;
          _1943 = ((_1931 / exp2(log2(exp2(log2(cbControlRGCParam.InvCyanSTerm * _1931) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.CyanThreshold);
        }
        do {
          _1964 = _1920;
          if (!(!(_1920 >= cbControlRGCParam.MagentaThreshold))) {
            _1952 = _1920 - cbControlRGCParam.MagentaThreshold;
            _1964 = ((_1952 / exp2(log2(exp2(log2(cbControlRGCParam.InvMagentaSTerm * _1952) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.MagentaThreshold);
          }
          do {
            _1984 = _1921;
            if (!(!(_1921 >= cbControlRGCParam.YellowThreshold))) {
              _1972 = _1921 - cbControlRGCParam.YellowThreshold;
              _1984 = ((_1972 / exp2(log2(exp2(log2(cbControlRGCParam.InvYellowSTerm * _1972) * cbControlRGCParam.RollOff) + 1.0f) * cbControlRGCParam.InvRollOff)) + cbControlRGCParam.YellowThreshold);
            }
            _1992 = (_1912 - (_1943 * _1918));
            _1993 = (_1912 - (_1964 * _1918));
            _1994 = (_1912 - (_1984 * _1918));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _1992 = _1900;
      _1993 = _1903;
      _1994 = _1906;
    }
  } else {
    _1992 = _1900;
    _1993 = _1903;
    _1994 = _1906;
  }
#if 1
  ApplyColorCorrectTexturePass(
      (cPassEnabled & 4) != 0,
      _1992, _1993, _1994,
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
      _2401, _2402, _2403);
#else
  if (!((cPassEnabled & 4) == 0)) {
    _2020 = !(_1992 <= 0.0078125f);
    do {
      if (!(_2020)) {
        _2029 = ((_1992 * 10.540237426757812f) + 0.072905533015728f);
      } else {
        _2029 = ((log2(_1992) + 9.720000267028809f) * 0.05707762390375137f);
      }
      _2030 = !(_1993 <= 0.0078125f);
      do {
        if (!(_2030)) {
          _2039 = ((_1993 * 10.540237426757812f) + 0.072905533015728f);
        } else {
          _2039 = ((log2(_1993) + 9.720000267028809f) * 0.05707762390375137f);
        }
        _2040 = !(_1994 <= 0.0078125f);
        do {
          if (!(_2040)) {
            _2049 = ((_1994 * 10.540237426757812f) + 0.072905533015728f);
          } else {
            _2049 = ((log2(_1994) + 9.720000267028809f) * 0.05707762390375137f);
          }
          _2058 = tTextureMap0.SampleLevel(TrilinearClamp, float3(((_2029 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2039 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2049 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
          do {
            if (_2058.x < 0.155251145362854f) {
              _2075 = ((_2058.x + -0.072905533015728f) * 0.09487452358007431f);
            } else {
              if ((_2058.x >= 0.155251145362854f) && (_2058.x < 1.4679962396621704f)) {
                _2075 = exp2((_2058.x * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _2075 = 65504.0f;
              }
            }
            do {
              if (_2058.y < 0.155251145362854f) {
                _2089 = ((_2058.y + -0.072905533015728f) * 0.09487452358007431f);
              } else {
                if ((_2058.y >= 0.155251145362854f) && (_2058.y < 1.4679962396621704f)) {
                  _2089 = exp2((_2058.y * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _2089 = 65504.0f;
                }
              }
              do {
                if (_2058.z < 0.155251145362854f) {
                  _2103 = ((_2058.z + -0.072905533015728f) * 0.09487452358007431f);
                } else {
                  if ((_2058.z >= 0.155251145362854f) && (_2058.z < 1.4679962396621704f)) {
                    _2103 = exp2((_2058.z * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _2103 = 65504.0f;
                  }
                }
                do {
                  [branch]
                  if (fTextureBlendRate > 0.0f) {
                    do {
                      if (!(_2020)) {
                        _2114 = ((_1992 * 10.540237426757812f) + 0.072905533015728f);
                      } else {
                        _2114 = ((log2(_1992) + 9.720000267028809f) * 0.05707762390375137f);
                      }
                      do {
                        if (!(_2030)) {
                          _2123 = ((_1993 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2123 = ((log2(_1993) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(_2040)) {
                            _2132 = ((_1994 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2132 = ((log2(_1994) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          _2140 = tTextureMap1.SampleLevel(TrilinearClamp, float3(((_2114 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2123 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2132 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                          do {
                            if (_2140.x < 0.155251145362854f) {
                              _2157 = ((_2140.x + -0.072905533015728f) * 0.09487452358007431f);
                            } else {
                              if ((_2140.x >= 0.155251145362854f) && (_2140.x < 1.4679962396621704f)) {
                                _2157 = exp2((_2140.x * 17.520000457763672f) + -9.720000267028809f);
                              } else {
                                _2157 = 65504.0f;
                              }
                            }
                            do {
                              if (_2140.y < 0.155251145362854f) {
                                _2171 = ((_2140.y + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_2140.y >= 0.155251145362854f) && (_2140.y < 1.4679962396621704f)) {
                                  _2171 = exp2((_2140.y * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2171 = 65504.0f;
                                }
                              }
                              do {
                                if (_2140.z < 0.155251145362854f) {
                                  _2185 = ((_2140.z + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_2140.z >= 0.155251145362854f) && (_2140.z < 1.4679962396621704f)) {
                                    _2185 = exp2((_2140.z * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2185 = 65504.0f;
                                  }
                                }
                                _2192 = ((_2157 - _2075) * fTextureBlendRate) + _2075;
                                _2193 = ((_2171 - _2089) * fTextureBlendRate) + _2089;
                                _2194 = ((_2185 - _2103) * fTextureBlendRate) + _2103;
                                if (fTextureBlendRate2 > 0.0f) {
                                  do {
                                    if (!(!(_2192 <= 0.0078125f))) {
                                      _2206 = ((_2192 * 10.540237426757812f) + 0.072905533015728f);
                                    } else {
                                      _2206 = ((log2(_2192) + 9.720000267028809f) * 0.05707762390375137f);
                                    }
                                    do {
                                      if (!(!(_2193 <= 0.0078125f))) {
                                        _2216 = ((_2193 * 10.540237426757812f) + 0.072905533015728f);
                                      } else {
                                        _2216 = ((log2(_2193) + 9.720000267028809f) * 0.05707762390375137f);
                                      }
                                      do {
                                        if (!(!(_2194 <= 0.0078125f))) {
                                          _2226 = ((_2194 * 10.540237426757812f) + 0.072905533015728f);
                                        } else {
                                          _2226 = ((log2(_2194) + 9.720000267028809f) * 0.05707762390375137f);
                                        }
                                        _2234 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2206 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2216 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2226 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                                        do {
                                          if (_2234.x < 0.155251145362854f) {
                                            _2251 = ((_2234.x + -0.072905533015728f) * 0.09487452358007431f);
                                          } else {
                                            if ((_2234.x >= 0.155251145362854f) && (_2234.x < 1.4679962396621704f)) {
                                              _2251 = exp2((_2234.x * 17.520000457763672f) + -9.720000267028809f);
                                            } else {
                                              _2251 = 65504.0f;
                                            }
                                          }
                                          do {
                                            if (_2234.y < 0.155251145362854f) {
                                              _2265 = ((_2234.y + -0.072905533015728f) * 0.09487452358007431f);
                                            } else {
                                              if ((_2234.y >= 0.155251145362854f) && (_2234.y < 1.4679962396621704f)) {
                                                _2265 = exp2((_2234.y * 17.520000457763672f) + -9.720000267028809f);
                                              } else {
                                                _2265 = 65504.0f;
                                              }
                                            }
                                            do {
                                              if (_2234.z < 0.155251145362854f) {
                                                _2279 = ((_2234.z + -0.072905533015728f) * 0.09487452358007431f);
                                              } else {
                                                if ((_2234.z >= 0.155251145362854f) && (_2234.z < 1.4679962396621704f)) {
                                                  _2279 = exp2((_2234.z * 17.520000457763672f) + -9.720000267028809f);
                                                } else {
                                                  _2279 = 65504.0f;
                                                }
                                              }
                                              _2385 = (lerp(_2192, _2251, fTextureBlendRate2));
                                              _2386 = (lerp(_2193, _2265, fTextureBlendRate2));
                                              _2387 = (lerp(_2194, _2279, fTextureBlendRate2));
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _2385 = _2192;
                                  _2386 = _2193;
                                  _2387 = _2194;
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
                        if (!(!(_2075 <= 0.0078125f))) {
                          _2301 = ((_2075 * 10.540237426757812f) + 0.072905533015728f);
                        } else {
                          _2301 = ((log2(_2075) + 9.720000267028809f) * 0.05707762390375137f);
                        }
                        do {
                          if (!(!(_2089 <= 0.0078125f))) {
                            _2311 = ((_2089 * 10.540237426757812f) + 0.072905533015728f);
                          } else {
                            _2311 = ((log2(_2089) + 9.720000267028809f) * 0.05707762390375137f);
                          }
                          do {
                            if (!(!(_2103 <= 0.0078125f))) {
                              _2321 = ((_2103 * 10.540237426757812f) + 0.072905533015728f);
                            } else {
                              _2321 = ((log2(_2103) + 9.720000267028809f) * 0.05707762390375137f);
                            }
                            _2329 = tTextureMap2.SampleLevel(TrilinearClamp, float3(((_2301 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2311 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize), ((_2321 * fOneMinusTextureInverseSize) + fHalfTextureInverseSize)), 0.0f);
                            do {
                              if (_2329.x < 0.155251145362854f) {
                                _2346 = ((_2329.x + -0.072905533015728f) * 0.09487452358007431f);
                              } else {
                                if ((_2329.x >= 0.155251145362854f) && (_2329.x < 1.4679962396621704f)) {
                                  _2346 = exp2((_2329.x * 17.520000457763672f) + -9.720000267028809f);
                                } else {
                                  _2346 = 65504.0f;
                                }
                              }
                              do {
                                if (_2329.y < 0.155251145362854f) {
                                  _2360 = ((_2329.y + -0.072905533015728f) * 0.09487452358007431f);
                                } else {
                                  if ((_2329.y >= 0.155251145362854f) && (_2329.y < 1.4679962396621704f)) {
                                    _2360 = exp2((_2329.y * 17.520000457763672f) + -9.720000267028809f);
                                  } else {
                                    _2360 = 65504.0f;
                                  }
                                }
                                do {
                                  if (_2329.z < 0.155251145362854f) {
                                    _2374 = ((_2329.z + -0.072905533015728f) * 0.09487452358007431f);
                                  } else {
                                    if ((_2329.z >= 0.155251145362854f) && (_2329.z < 1.4679962396621704f)) {
                                      _2374 = exp2((_2329.z * 17.520000457763672f) + -9.720000267028809f);
                                    } else {
                                      _2374 = 65504.0f;
                                    }
                                  }
                                  _2385 = (lerp(_2075, _2346, fTextureBlendRate2));
                                  _2386 = (lerp(_2089, _2360, fTextureBlendRate2));
                                  _2387 = (lerp(_2103, _2374, fTextureBlendRate2));
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      _2385 = _2075;
                      _2386 = _2089;
                      _2387 = _2103;
                    }
                  }
                  _2401 = (mad(_2387, (fColorMatrix[2].x), mad(_2386, (fColorMatrix[1].x), (_2385 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x));
                  _2402 = (mad(_2387, (fColorMatrix[2].y), mad(_2386, (fColorMatrix[1].y), (_2385 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y));
                  _2403 = (mad(_2387, (fColorMatrix[2].z), mad(_2386, (fColorMatrix[1].z), (_2385 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z));
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2401 = _1992;
    _2402 = _1993;
    _2403 = _1994;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _2438 = saturate(((cvdR.x * _2401) + (cvdR.y * _2402)) + (cvdR.z * _2403));
    _2439 = saturate(((cvdG.x * _2401) + (cvdG.y * _2402)) + (cvdG.z * _2403));
    _2440 = saturate(((cvdB.x * _2401) + (cvdB.y * _2402)) + (cvdB.z * _2403));
  } else {
    _2438 = _2401;
    _2439 = _2402;
    _2440 = _2403;
  }
  if (!((cPassEnabled & 16) == 0)) {
    _2452 = screenInverseSize.x * SV_Position.x;
    _2453 = screenInverseSize.y * SV_Position.y;
    _2456 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2452, _2453), 0.0f);
    _2461 = _2456.x * ColorParam.x;
    _2462 = _2456.y * ColorParam.y;
    _2463 = _2456.z * ColorParam.z;
    _2471 = (_2456.w * ColorParam.w) * saturate((((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2452, _2453), 0.0f)).x) * Levels_Rate) + Levels_Range);
    do {
      if (_2461 < 0.5f) {
        _2483 = ((_2438 * 2.0f) * _2461);
      } else {
        _2483 = (1.0f - (((1.0f - _2438) * 2.0f) * (1.0f - _2461)));
      }
      do {
        if (_2462 < 0.5f) {
          _2495 = ((_2439 * 2.0f) * _2462);
        } else {
          _2495 = (1.0f - (((1.0f - _2439) * 2.0f) * (1.0f - _2462)));
        }
        do {
          if (_2463 < 0.5f) {
            _2507 = ((_2440 * 2.0f) * _2463);
          } else {
            _2507 = (1.0f - (((1.0f - _2440) * 2.0f) * (1.0f - _2463)));
          }
          _2518 = (lerp(_2438, _2483, _2471));
          _2519 = (lerp(_2439, _2495, _2471));
          _2520 = (lerp(_2440, _2507, _2471));
        } while (false);
      } while (false);
    } while (false);
  } else {
    _2518 = _2438;
    _2519 = _2439;
    _2520 = _2440;
  }
  SV_Target.x = _2518;
  SV_Target.y = _2519;
  SV_Target.z = _2520;
  SV_Target.w = 0.0f;
  return SV_Target;
}

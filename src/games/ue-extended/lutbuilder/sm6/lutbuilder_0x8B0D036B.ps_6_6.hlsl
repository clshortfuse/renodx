// Lego Batman Legacy

#include "../lutbuilderoutput.hlsli"

cbuffer cb0 : register(b0) {
  float cb0_008x : packoffset(c008.x);
  float cb0_008y : packoffset(c008.y);
  float cb0_008z : packoffset(c008.z);
  float cb0_008w : packoffset(c008.w);
  float cb0_009x : packoffset(c009.x);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_010w : packoffset(c010.w);
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_011w : packoffset(c011.w);
  float cb0_012x : packoffset(c012.x);
  float cb0_012y : packoffset(c012.y);
  float cb0_012z : packoffset(c012.z);
  float cb0_012w : packoffset(c012.w);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_016x : packoffset(c016.x);
  float cb0_016y : packoffset(c016.y);
  float cb0_016z : packoffset(c016.z);
  float cb0_017x : packoffset(c017.x);
  float cb0_017y : packoffset(c017.y);
  float cb0_017z : packoffset(c017.z);
  float cb0_017w : packoffset(c017.w);
  float cb0_018x : packoffset(c018.x);
  float cb0_018y : packoffset(c018.y);
  float cb0_018z : packoffset(c018.z);
  float cb0_018w : packoffset(c018.w);
  float cb0_019x : packoffset(c019.x);
  float cb0_019y : packoffset(c019.y);
  float cb0_019z : packoffset(c019.z);
  float cb0_019w : packoffset(c019.w);
  float cb0_020x : packoffset(c020.x);
  float cb0_020y : packoffset(c020.y);
  float cb0_020z : packoffset(c020.z);
  float cb0_020w : packoffset(c020.w);
  float cb0_021x : packoffset(c021.x);
  float cb0_021y : packoffset(c021.y);
  float cb0_021z : packoffset(c021.z);
  float cb0_021w : packoffset(c021.w);
  float cb0_022x : packoffset(c022.x);
  float cb0_022y : packoffset(c022.y);
  float cb0_022z : packoffset(c022.z);
  float cb0_022w : packoffset(c022.w);
  float cb0_023x : packoffset(c023.x);
  float cb0_023y : packoffset(c023.y);
  float cb0_023z : packoffset(c023.z);
  float cb0_023w : packoffset(c023.w);
  float cb0_024x : packoffset(c024.x);
  float cb0_024y : packoffset(c024.y);
  float cb0_024z : packoffset(c024.z);
  float cb0_024w : packoffset(c024.w);
  float cb0_025x : packoffset(c025.x);
  float cb0_025y : packoffset(c025.y);
  float cb0_025z : packoffset(c025.z);
  float cb0_025w : packoffset(c025.w);
  float cb0_026x : packoffset(c026.x);
  float cb0_026y : packoffset(c026.y);
  float cb0_026z : packoffset(c026.z);
  float cb0_026w : packoffset(c026.w);
  float cb0_027x : packoffset(c027.x);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
  float cb0_027w : packoffset(c027.w);
  float cb0_028x : packoffset(c028.x);
  float cb0_028y : packoffset(c028.y);
  float cb0_028z : packoffset(c028.z);
  float cb0_028w : packoffset(c028.w);
  float cb0_029x : packoffset(c029.x);
  float cb0_029y : packoffset(c029.y);
  float cb0_029z : packoffset(c029.z);
  float cb0_029w : packoffset(c029.w);
  float cb0_030x : packoffset(c030.x);
  float cb0_030y : packoffset(c030.y);
  float cb0_030z : packoffset(c030.z);
  float cb0_030w : packoffset(c030.w);
  float cb0_031x : packoffset(c031.x);
  float cb0_031y : packoffset(c031.y);
  float cb0_031z : packoffset(c031.z);
  float cb0_031w : packoffset(c031.w);
  float cb0_032x : packoffset(c032.x);
  float cb0_032y : packoffset(c032.y);
  float cb0_032z : packoffset(c032.z);
  float cb0_032w : packoffset(c032.w);
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_034z : packoffset(c034.z);
  float cb0_034w : packoffset(c034.w);
  float cb0_035x : packoffset(c035.x);
  float cb0_035y : packoffset(c035.y);
  float cb0_035z : packoffset(c035.z);
  float cb0_035w : packoffset(c035.w);
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_036w : packoffset(c036.w);
  float cb0_037x : packoffset(c037.x);
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  float cb0_038w : packoffset(c038.w);
  int cb0_040w : packoffset(c040.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  int cb0_042w : packoffset(c042.w);
  int cb0_043x : packoffset(c043.x);
  // Added for ProcessLutbuilder
  float cb0_038z : packoffset(c038.z);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_039w : packoffset(c039.w);
  float cb0_040x : packoffset(c040.x);
  float cb0_040y : packoffset(c040.y);
};

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  float4 WorkingColorSpace_320[4] : packoffset(c020.x);
  int WorkingColorSpace_384 : packoffset(c024.x);
};

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  precise noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _21;
  float _26;
  float _27;
  float _28;
  float _30;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _116;
  float _117;
  float _118;
  float _173;
  float _380;
  float _381;
  float _382;
  float _939;
  float _940;
  float _941;
  float _952;
  float _963;
  float _1132;
  float _1147;
  float _1162;
  float _1170;
  float _1171;
  float _1172;
  float _1239;
  float _1272;
  float _1286;
  float _1325;
  float _1447;
  float _1527;
  float _1601;
  float _1806;
  float _1821;
  float _1836;
  float _1844;
  float _1845;
  float _1846;
  float _1913;
  float _1946;
  float _1960;
  float _1999;
  float _2121;
  float _2207;
  float _2293;
  float _2508;
  float _2509;
  float _2510;
  bool _39;
  float _69;
  float _70;
  float _71;
  bool _154;
  float _156;
  float _187;
  float _194;
  float _197;
  float _202;
  float _203;
  float _205;
  bool _206;
  float _215;
  float _217;
  float _224;
  float _226;
  float _228;
  float _229;
  float _232;
  float _235;
  float _240;
  float _246;
  float _247;
  float _248;
  float _249;
  float _250;
  float _251;
  float _252;
  float _253;
  float _256;
  float _257;
  float _258;
  float _261;
  float _280;
  float _281;
  float _282;
  float _283;
  float _284;
  float _285;
  float _286;
  float _287;
  float _288;
  float _291;
  float _294;
  float _297;
  float _300;
  float _303;
  float _306;
  float _309;
  float _312;
  float _315;
  float _318;
  float _321;
  float _324;
  float _327;
  float _330;
  float _333;
  float _336;
  float _339;
  float _342;
  float _397;
  float _400;
  float _403;
  float _404;
  float _408;
  float _409;
  float _410;
  float _422;
  float _438;
  float _439;
  float _440;
  float _441;
  float _455;
  float _469;
  float _483;
  float _497;
  float _511;
  float _515;
  float _516;
  float _517;
  float _574;
  float _578;
  float _579;
  float _588;
  float _597;
  float _606;
  float _615;
  float _624;
  float _687;
  float _691;
  float _700;
  float _709;
  float _718;
  float _727;
  float _736;
  float _794;
  float _805;
  float _807;
  float _809;
  float _834;
  float _835;
  float _836;
  float _862;
  float _863;
  float _864;
  float _871;
  float _872;
  float _873;
  float _874;
  float _875;
  float _876;
  float _883;
  float _884;
  float _885;
  float _897;
  float _898;
  float _899;
  float _922;
  float _925;
  float _928;
  float _990;
  float _993;
  float _996;
  float _999;
  float _1002;
  float _1005;
  float _1080;
  float _1081;
  float _1082;
  float _1085;
  float _1088;
  float _1091;
  float _1094;
  float _1097;
  float _1100;
  float _1102;
  float _1112;
  float _1113;
  float _1115;
  float _1117;
  float _1120;
  float _1135;
  float _1150;
  float _1188;
  float _1189;
  float _1190;
  float _1194;
  float _1199;
  float _1212;
  float _1213;
  float _1214;
  float _1215;
  float _1219;
  float _1230;
  float _1240;
  float _1241;
  float _1242;
  float _1243;
  float _1250;
  float _1253;
  float _1255;
  bool _1258;
  bool _1259;
  bool _1260;
  bool _1261;
  float _1277;
  float _1292;
  int _1293;
  float _1295;
  float _1296;
  float _1297;
  float _1334;
  float _1335;
  float _1336;
  float _1349;
  float _1350;
  float _1351;
  float _1352;
  float _1375;
  float _1376;
  float _1377;
  float _1378;
  float _1385;
  float _1386;
  float _1394;
  int _1395;
  float _1397;
  float _1399;
  float _1402;
  float _1407;
  float _1416;
  float _1424;
  int _1425;
  float _1427;
  float _1429;
  float _1432;
  float _1437;
  float _1457;
  float _1458;
  float _1465;
  float _1466;
  float _1474;
  int _1475;
  float _1477;
  float _1479;
  float _1482;
  float _1487;
  float _1496;
  float _1504;
  int _1505;
  float _1507;
  float _1509;
  float _1512;
  float _1517;
  float _1531;
  float _1532;
  float _1539;
  float _1540;
  float _1548;
  int _1549;
  float _1551;
  float _1553;
  float _1556;
  float _1561;
  float _1570;
  float _1578;
  int _1579;
  float _1581;
  float _1583;
  float _1586;
  float _1591;
  float _1605;
  float _1606;
  float _1608;
  float _1610;
  float _1613;
  float _1616;
  float _1619;
  float _1632;
  float _1633;
  float _1634;
  float _1637;
  float _1640;
  float _1643;
  float _1665;
  float _1666;
  float _1667;
  float _1686;
  float _1687;
  float _1688;
  float _1754;
  float _1755;
  float _1756;
  float _1759;
  float _1762;
  float _1765;
  float _1768;
  float _1771;
  float _1774;
  float _1776;
  float _1786;
  float _1787;
  float _1789;
  float _1791;
  float _1794;
  float _1809;
  float _1824;
  float _1862;
  float _1863;
  float _1864;
  float _1868;
  float _1873;
  float _1886;
  float _1887;
  float _1888;
  float _1889;
  float _1893;
  float _1904;
  float _1914;
  float _1915;
  float _1916;
  float _1917;
  float _1924;
  float _1927;
  float _1929;
  bool _1932;
  bool _1933;
  bool _1934;
  bool _1935;
  float _1951;
  float _1966;
  int _1967;
  float _1969;
  float _1970;
  float _1971;
  float _2008;
  float _2009;
  float _2010;
  float _2023;
  float _2024;
  float _2025;
  float _2026;
  float _2049;
  float _2050;
  float _2051;
  float _2052;
  float _2059;
  float _2060;
  float _2068;
  int _2069;
  float _2071;
  float _2073;
  float _2076;
  float _2081;
  float _2090;
  float _2098;
  int _2099;
  float _2101;
  float _2103;
  float _2106;
  float _2111;
  float _2137;
  float _2138;
  float _2145;
  float _2146;
  float _2154;
  int _2155;
  float _2157;
  float _2159;
  float _2162;
  float _2167;
  float _2176;
  float _2184;
  int _2185;
  float _2187;
  float _2189;
  float _2192;
  float _2197;
  float _2223;
  float _2224;
  float _2231;
  float _2232;
  float _2240;
  int _2241;
  float _2243;
  float _2245;
  float _2248;
  float _2253;
  float _2262;
  float _2270;
  int _2271;
  float _2273;
  float _2275;
  float _2278;
  float _2283;
  float _2297;
  float _2298;
  float _2300;
  float _2302;
  float _2305;
  float _2308;
  float _2311;
  float _2324;
  float _2325;
  float _2326;
  float _2329;
  float _2332;
  float _2335;
  float _2357;
  float _2360;
  float _2361;
  float _2388;
  float _2391;
  float _2394;
  float _2413;
  float _2414;
  float _2415;
  float _2462;
  float _2465;
  float _2468;
  float _2481;
  float _2484;
  float _2487;
  float _8[6];
  float _9[6];
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _14[6];
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  _21 = 0.5f / cb0_037x;
  _26 = cb0_037x + -1.0f;
  _27 = (cb0_037x * (TEXCOORD.x - _21)) / _26;
  _28 = (cb0_037x * (TEXCOORD.y - _21)) / _26;
  _30 = float((uint)(uint)(SV_RenderTargetArrayIndex)) / _26;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _39 = (cb0_043x == 4);
        _50 = select(_39, 1.0f, 1.705051064491272f);
        _51 = select(_39, 0.0f, -0.6217921376228333f);
        _52 = select(_39, 0.0f, -0.0832589864730835f);
        _53 = select(_39, 0.0f, -0.13025647401809692f);
        _54 = select(_39, 1.0f, 1.140804648399353f);
        _55 = select(_39, 0.0f, -0.010548308491706848f);
        _56 = select(_39, 0.0f, -0.024003351107239723f);
        _57 = select(_39, 0.0f, -0.1289689838886261f);
        _58 = select(_39, 1.0f, 1.1529725790023804f);
      } else {
        _50 = 0.6954522132873535f;
        _51 = 0.14067870378494263f;
        _52 = 0.16386906802654266f;
        _53 = 0.044794563204050064f;
        _54 = 0.8596711158752441f;
        _55 = 0.0955343171954155f;
        _56 = -0.005525882821530104f;
        _57 = 0.004025210160762072f;
        _58 = 1.0015007257461548f;
      }
    } else {
      _50 = 1.0258246660232544f;
      _51 = -0.020053181797266006f;
      _52 = -0.005771636962890625f;
      _53 = -0.002234415616840124f;
      _54 = 1.0045864582061768f;
      _55 = -0.002352118492126465f;
      _56 = -0.005013350863009691f;
      _57 = -0.025290070101618767f;
      _58 = 1.0303035974502563f;
    }
  } else {
    _50 = 1.3792141675949097f;
    _51 = -0.30886411666870117f;
    _52 = -0.0703500509262085f;
    _53 = -0.06933490186929703f;
    _54 = 1.08229660987854f;
    _55 = -0.012961871922016144f;
    _56 = -0.0021590073592960835f;
    _57 = -0.0454593189060688f;
    _58 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _69 = (pow(_27, 0.012683313339948654f));
    _70 = (pow(_28, 0.012683313339948654f));
    _71 = (pow(_30, 0.012683313339948654f));
    _116 = (exp2(log2(max(0.0f, (_69 + -0.8359375f)) / (18.8515625f - (_69 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _116 = ((exp2((_27 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _117 = ((exp2((_28 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _118 = ((exp2((_30 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _154 = (cb0_040w != 0);
    _156 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _173 = (((((1901800.0f - (_156 * 2006400000.0f)) * _156) + 247.47999572753906f) * _156) + 0.23703999817371368f);
    } else {
      _173 = (((((2967800.0f - (_156 * 4607000064.0f)) * _156) + 99.11000061035156f) * _156) + 0.24406300485134125f);
    }
    _187 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _194 = cb0_037y * cb0_037y;
    _197 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_194 * 1.6145605741257896e-07f));
    _202 = ((_187 * 2.0f) + 4.0f) - (_197 * 8.0f);
    _203 = (_187 * 3.0f) / _202;
    _205 = (_197 * 2.0f) / _202;
    _206 = (cb0_037y < 4000.0f);
    _215 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _217 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_194 * 1.5317699909210205f)) / (_215 * _215);
    _224 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _194;
    _226 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_194 * 308.60699462890625f)) / (_224 * _224);
    _228 = rsqrt(dot(float2(_217, _226), float2(_217, _226)));
    _229 = cb0_037z * 0.05000000074505806f;
    _232 = ((_229 * _226) * _228) + _187;
    _235 = _197 - ((_229 * _217) * _228);
    _240 = (4.0f - (_235 * 8.0f)) + (_232 * 2.0f);
    _246 = (((_232 * 3.0f) / _240) - _203) + select(_206, _203, _173);
    _247 = (((_235 * 2.0f) / _240) - _205) + select(_206, _205, (((_173 * 2.869999885559082f) + -0.2750000059604645f) - ((_173 * _173) * 3.0f)));
    _248 = select(_154, _246, 0.3127000033855438f);
    _249 = select(_154, _247, 0.32899999618530273f);
    _250 = select(_154, 0.3127000033855438f, _246);
    _251 = select(_154, 0.32899999618530273f, _247);
    _252 = max(_249, 1.000000013351432e-10f);
    _253 = _248 / _252;
    _256 = ((1.0f - _248) - _249) / _252;
    _257 = max(_251, 1.000000013351432e-10f);
    _258 = _250 / _257;
    _261 = ((1.0f - _250) - _251) / _257;
    _280 = mad(-0.16140000522136688f, _261, ((_258 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _256, ((_253 * 0.8950999975204468f) + 0.266400009393692f));
    _281 = mad(0.03669999912381172f, _261, (1.7135000228881836f - (_258 * 0.7501999735832214f))) / mad(0.03669999912381172f, _256, (1.7135000228881836f - (_253 * 0.7501999735832214f)));
    _282 = mad(1.0296000242233276f, _261, ((_258 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _256, ((_253 * 0.03889999911189079f) + -0.06849999725818634f));
    _283 = mad(_281, -0.7501999735832214f, 0.0f);
    _284 = mad(_281, 1.7135000228881836f, 0.0f);
    _285 = mad(_281, 0.03669999912381172f, -0.0f);
    _286 = mad(_282, 0.03889999911189079f, 0.0f);
    _287 = mad(_282, -0.06849999725818634f, 0.0f);
    _288 = mad(_282, 1.0296000242233276f, 0.0f);
    _291 = mad(0.1599626988172531f, _286, mad(-0.1470542997121811f, _283, (_280 * 0.883457362651825f)));
    _294 = mad(0.1599626988172531f, _287, mad(-0.1470542997121811f, _284, (_280 * 0.26293492317199707f)));
    _297 = mad(0.1599626988172531f, _288, mad(-0.1470542997121811f, _285, (_280 * -0.15930065512657166f)));
    _300 = mad(0.04929120093584061f, _286, mad(0.5183603167533875f, _283, (_280 * 0.38695648312568665f)));
    _303 = mad(0.04929120093584061f, _287, mad(0.5183603167533875f, _284, (_280 * 0.11516613513231277f)));
    _306 = mad(0.04929120093584061f, _288, mad(0.5183603167533875f, _285, (_280 * -0.0697740763425827f)));
    _309 = mad(0.9684867262840271f, _286, mad(0.04004279896616936f, _283, (_280 * -0.007634039502590895f)));
    _312 = mad(0.9684867262840271f, _287, mad(0.04004279896616936f, _284, (_280 * -0.0022720457054674625f)));
    _315 = mad(0.9684867262840271f, _288, mad(0.04004279896616936f, _285, (_280 * 0.0013765322510153055f)));
    _318 = mad(_297, (WorkingColorSpace_000[2].x), mad(_294, (WorkingColorSpace_000[1].x), (_291 * (WorkingColorSpace_000[0].x))));
    _321 = mad(_297, (WorkingColorSpace_000[2].y), mad(_294, (WorkingColorSpace_000[1].y), (_291 * (WorkingColorSpace_000[0].y))));
    _324 = mad(_297, (WorkingColorSpace_000[2].z), mad(_294, (WorkingColorSpace_000[1].z), (_291 * (WorkingColorSpace_000[0].z))));
    _327 = mad(_306, (WorkingColorSpace_000[2].x), mad(_303, (WorkingColorSpace_000[1].x), (_300 * (WorkingColorSpace_000[0].x))));
    _330 = mad(_306, (WorkingColorSpace_000[2].y), mad(_303, (WorkingColorSpace_000[1].y), (_300 * (WorkingColorSpace_000[0].y))));
    _333 = mad(_306, (WorkingColorSpace_000[2].z), mad(_303, (WorkingColorSpace_000[1].z), (_300 * (WorkingColorSpace_000[0].z))));
    _336 = mad(_315, (WorkingColorSpace_000[2].x), mad(_312, (WorkingColorSpace_000[1].x), (_309 * (WorkingColorSpace_000[0].x))));
    _339 = mad(_315, (WorkingColorSpace_000[2].y), mad(_312, (WorkingColorSpace_000[1].y), (_309 * (WorkingColorSpace_000[0].y))));
    _342 = mad(_315, (WorkingColorSpace_000[2].z), mad(_312, (WorkingColorSpace_000[1].z), (_309 * (WorkingColorSpace_000[0].z))));
    _380 = mad(mad((WorkingColorSpace_064[0].z), _342, mad((WorkingColorSpace_064[0].y), _333, (_324 * (WorkingColorSpace_064[0].x)))), _118, mad(mad((WorkingColorSpace_064[0].z), _339, mad((WorkingColorSpace_064[0].y), _330, (_321 * (WorkingColorSpace_064[0].x)))), _117, (mad((WorkingColorSpace_064[0].z), _336, mad((WorkingColorSpace_064[0].y), _327, (_318 * (WorkingColorSpace_064[0].x)))) * _116)));
    _381 = mad(mad((WorkingColorSpace_064[1].z), _342, mad((WorkingColorSpace_064[1].y), _333, (_324 * (WorkingColorSpace_064[1].x)))), _118, mad(mad((WorkingColorSpace_064[1].z), _339, mad((WorkingColorSpace_064[1].y), _330, (_321 * (WorkingColorSpace_064[1].x)))), _117, (mad((WorkingColorSpace_064[1].z), _336, mad((WorkingColorSpace_064[1].y), _327, (_318 * (WorkingColorSpace_064[1].x)))) * _116)));
    _382 = mad(mad((WorkingColorSpace_064[2].z), _342, mad((WorkingColorSpace_064[2].y), _333, (_324 * (WorkingColorSpace_064[2].x)))), _118, mad(mad((WorkingColorSpace_064[2].z), _339, mad((WorkingColorSpace_064[2].y), _330, (_321 * (WorkingColorSpace_064[2].x)))), _117, (mad((WorkingColorSpace_064[2].z), _336, mad((WorkingColorSpace_064[2].y), _327, (_318 * (WorkingColorSpace_064[2].x)))) * _116)));
  } else {
    _380 = _116;
    _381 = _117;
    _382 = _118;
  }
  _397 = mad((WorkingColorSpace_128[0].z), _382, mad((WorkingColorSpace_128[0].y), _381, ((WorkingColorSpace_128[0].x) * _380)));
  _400 = mad((WorkingColorSpace_128[1].z), _382, mad((WorkingColorSpace_128[1].y), _381, ((WorkingColorSpace_128[1].x) * _380)));
  _403 = mad((WorkingColorSpace_128[2].z), _382, mad((WorkingColorSpace_128[2].y), _381, ((WorkingColorSpace_128[2].x) * _380)));
  _404 = dot(float3(_397, _400, _403), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _408 = (_397 / _404) + -1.0f;
  _409 = (_400 / _404) + -1.0f;
  _410 = (_403 / _404) + -1.0f;
  _422 = (1.0f - exp2(((_404 * _404) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_408, _409, _410), float3(_408, _409, _410)) * -4.0f));
  _438 = ((mad(-0.06368321925401688f, _403, mad(-0.3292922377586365f, _400, (_397 * 1.3704125881195068f))) - _397) * _422) + _397;
  _439 = ((mad(-0.010861365124583244f, _403, mad(1.0970927476882935f, _400, (_397 * -0.08343357592821121f))) - _400) * _422) + _400;
  _440 = ((mad(1.2036951780319214f, _403, mad(-0.09862580895423889f, _400, (_397 * -0.02579331398010254f))) - _403) * _422) + _403;
  _441 = dot(float3(_438, _439, _440), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _455 = cb0_021w + cb0_026w;
  _469 = cb0_020w * cb0_025w;
  _483 = cb0_019w * cb0_024w;
  _497 = cb0_018w * cb0_023w;
  _511 = cb0_017w * cb0_022w;
  _515 = _438 - _441;
  _516 = _439 - _441;
  _517 = _440 - _441;
  _574 = saturate(_441 / cb0_037w);
  _578 = (_574 * _574) * (3.0f - (_574 * 2.0f));
  _579 = 1.0f - _578;
  _588 = cb0_021w + cb0_036w;
  _597 = cb0_020w * cb0_035w;
  _606 = cb0_019w * cb0_034w;
  _615 = cb0_018w * cb0_033w;
  _624 = cb0_017w * cb0_032w;
  _687 = saturate((_441 - cb0_038x) / (cb0_038y - cb0_038x));
  _691 = (_687 * _687) * (3.0f - (_687 * 2.0f));
  _700 = cb0_021w + cb0_031w;
  _709 = cb0_020w * cb0_030w;
  _718 = cb0_019w * cb0_029w;
  _727 = cb0_018w * cb0_028w;
  _736 = cb0_017w * cb0_027w;
  _794 = _578 - _691;
  _805 = ((_691 * (((cb0_021x + cb0_036x) + _588) + (((cb0_020x * cb0_035x) * _597) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _615) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _624) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _606)))))) + (_579 * (((cb0_021x + cb0_026x) + _455) + (((cb0_020x * cb0_025x) * _469) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _497) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _511) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _483))))))) + ((((cb0_021x + cb0_031x) + _700) + (((cb0_020x * cb0_030x) * _709) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _727) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _736) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _718))))) * _794);
  _807 = ((_691 * (((cb0_021y + cb0_036y) + _588) + (((cb0_020y * cb0_035y) * _597) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _615) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _624) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _606)))))) + (_579 * (((cb0_021y + cb0_026y) + _455) + (((cb0_020y * cb0_025y) * _469) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _497) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _511) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _483))))))) + ((((cb0_021y + cb0_031y) + _700) + (((cb0_020y * cb0_030y) * _709) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _727) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _736) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _718))))) * _794);
  _809 = ((_691 * (((cb0_021z + cb0_036z) + _588) + (((cb0_020z * cb0_035z) * _597) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _615) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _624) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _606)))))) + (_579 * (((cb0_021z + cb0_026z) + _455) + (((cb0_020z * cb0_025z) * _469) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _497) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _511) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _483))))))) + ((((cb0_021z + cb0_031z) + _700) + (((cb0_020z * cb0_030z) * _709) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _727) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _736) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _718))))) * _794);

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = cb0_040x;
  cb_config.ue_filmtoe = cb0_039z;
  cb_config.ue_filmshoulder = cb0_039w;
  cb_config.ue_filmslope = cb0_039y;
  cb_config.ue_filmwhiteclip = cb0_040y;
  cb_config.ue_tonecurveammount = cb0_039x;
  cb_config.ue_mappingpolynomial = float3(cb0_041x, cb0_041y, cb0_041z);
  cb_config.ue_overlaycolor = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
  cb_config.ue_bluecorrection = cb0_038z;
  cb_config.ue_colorscale = float3(cb0_016x, cb0_016y, cb0_016z);

  float4 output = ProcessLutbuilder(float3(_805, _807, _809), cb_config, SV_Target, (uint)cb0_042w);
  SV_Target = output;
  return SV_Target;

  _834 = min(max(_116, 0.0f), 1.0f);
  _835 = min(max(_117, 0.0f), 1.0f);
  _836 = min(max(_118, 0.0f), 1.0f);
  _862 = cb0_016x * (((cb0_041y + (cb0_041x * _834)) * _834) + cb0_041z);
  _863 = cb0_016y * (((cb0_041y + (cb0_041x * _835)) * _835) + cb0_041z);
  _864 = cb0_016z * (((cb0_041y + (cb0_041x * _836)) * _836) + cb0_041z);
  _871 = ((cb0_015x - _862) * cb0_015w) + _862;
  _872 = ((cb0_015y - _863) * cb0_015w) + _863;
  _873 = ((cb0_015z - _864) * cb0_015w) + _864;
  _874 = cb0_016x * mad((WorkingColorSpace_192[0].z), _809, mad((WorkingColorSpace_192[0].y), _807, (_805 * (WorkingColorSpace_192[0].x))));
  _875 = cb0_016y * mad((WorkingColorSpace_192[1].z), _809, mad((WorkingColorSpace_192[1].y), _807, ((WorkingColorSpace_192[1].x) * _805)));
  _876 = cb0_016z * mad((WorkingColorSpace_192[2].z), _809, mad((WorkingColorSpace_192[2].y), _807, ((WorkingColorSpace_192[2].x) * _805)));
  _883 = ((cb0_015x - _874) * cb0_015w) + _874;
  _884 = ((cb0_015y - _875) * cb0_015w) + _875;
  _885 = ((cb0_015z - _876) * cb0_015w) + _876;
  _897 = exp2(log2(max(0.0f, _871)) * cb0_042y);
  _898 = exp2(log2(max(0.0f, _872)) * cb0_042y);
  _899 = exp2(log2(max(0.0f, _873)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _922 = mad((WorkingColorSpace_128[0].z), _899, mad((WorkingColorSpace_128[0].y), _898, ((WorkingColorSpace_128[0].x) * _897)));
      _925 = mad((WorkingColorSpace_128[1].z), _899, mad((WorkingColorSpace_128[1].y), _898, ((WorkingColorSpace_128[1].x) * _897)));
      _928 = mad((WorkingColorSpace_128[2].z), _899, mad((WorkingColorSpace_128[2].y), _898, ((WorkingColorSpace_128[2].x) * _897)));
      _939 = mad(_52, _928, mad(_51, _925, (_922 * _50)));
      _940 = mad(_55, _928, mad(_54, _925, (_922 * _53)));
      _941 = mad(_58, _928, mad(_57, _925, (_922 * _56)));
    } else {
      _939 = _897;
      _940 = _898;
      _941 = _899;
    }
    if (_939 < 0.0031306699384003878f) {
      _952 = (_939 * 12.920000076293945f);
    } else {
      _952 = (((pow(_939, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_940 < 0.0031306699384003878f) {
      _963 = (_940 * 12.920000076293945f);
    } else {
      _963 = (((pow(_940, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_941 < 0.0031306699384003878f) {
      _2508 = _952;
      _2509 = _963;
      _2510 = (_941 * 12.920000076293945f);
    } else {
      _2508 = _952;
      _2509 = _963;
      _2510 = (((pow(_941, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _990 = mad((WorkingColorSpace_128[0].z), _899, mad((WorkingColorSpace_128[0].y), _898, ((WorkingColorSpace_128[0].x) * _897)));
      _993 = mad((WorkingColorSpace_128[1].z), _899, mad((WorkingColorSpace_128[1].y), _898, ((WorkingColorSpace_128[1].x) * _897)));
      _996 = mad((WorkingColorSpace_128[2].z), _899, mad((WorkingColorSpace_128[2].y), _898, ((WorkingColorSpace_128[2].x) * _897)));
      _999 = mad(_52, _996, mad(_51, _993, (_990 * _50)));
      _1002 = mad(_55, _996, mad(_54, _993, (_990 * _53)));
      _1005 = mad(_58, _996, mad(_57, _993, (_990 * _56)));
      _2508 = min((_999 * 4.5f), ((exp2(log2(max(_999, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2509 = min((_1002 * 4.5f), ((exp2(log2(max(_1002, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2510 = min((_1005 * 4.5f), ((exp2(log2(max(_1005, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
        _8[0] = cb0_010x;
        _8[1] = cb0_010y;
        _8[2] = cb0_010z;
        _8[3] = cb0_010w;
        _8[4] = cb0_012x;
        _8[5] = cb0_012x;
        _9[0] = cb0_011x;
        _9[1] = cb0_011y;
        _9[2] = cb0_011z;
        _9[3] = cb0_011w;
        _9[4] = cb0_012y;
        _9[5] = cb0_012y;
        _1080 = cb0_012z * _883;
        _1081 = cb0_012z * _884;
        _1082 = cb0_012z * _885;
        _1085 = mad((WorkingColorSpace_256[0].z), _1082, mad((WorkingColorSpace_256[0].y), _1081, ((WorkingColorSpace_256[0].x) * _1080)));
        _1088 = mad((WorkingColorSpace_256[1].z), _1082, mad((WorkingColorSpace_256[1].y), _1081, ((WorkingColorSpace_256[1].x) * _1080)));
        _1091 = mad((WorkingColorSpace_256[2].z), _1082, mad((WorkingColorSpace_256[2].y), _1081, ((WorkingColorSpace_256[2].x) * _1080)));
        _1094 = mad(-0.21492856740951538f, _1091, mad(-0.2365107536315918f, _1088, (_1085 * 1.4514392614364624f)));
        _1097 = mad(-0.09967592358589172f, _1091, mad(1.17622971534729f, _1088, (_1085 * -0.07655377686023712f)));
        _1100 = mad(0.9977163076400757f, _1091, mad(-0.006032449658960104f, _1088, (_1085 * 0.008316148072481155f)));
        _1102 = max(_1094, max(_1097, _1100));
        if (!(_1102 < 1.000000013351432e-10f)) {
          if (!(((_1085 < 0.0f) || (_1088 < 0.0f)) || (_1091 < 0.0f))) {
            _1112 = abs(_1102);
            _1113 = (_1102 - _1094) / _1112;
            _1115 = (_1102 - _1097) / _1112;
            _1117 = (_1102 - _1100) / _1112;
            if (!(_1113 < 0.8149999976158142f)) {
              _1120 = _1113 + -0.8149999976158142f;
              _1132 = ((_1120 / exp2(log2(exp2(log2(_1120 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1132 = _1113;
            }
            if (!(_1115 < 0.8029999732971191f)) {
              _1135 = _1115 + -0.8029999732971191f;
              _1147 = ((_1135 / exp2(log2(exp2(log2(_1135 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1147 = _1115;
            }
            if (!(_1117 < 0.8799999952316284f)) {
              _1150 = _1117 + -0.8799999952316284f;
              _1162 = ((_1150 / exp2(log2(exp2(log2(_1150 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1162 = _1117;
            }
            _1170 = (_1102 - (_1112 * _1132));
            _1171 = (_1102 - (_1112 * _1147));
            _1172 = (_1102 - (_1112 * _1162));
          } else {
            _1170 = _1094;
            _1171 = _1097;
            _1172 = _1100;
          }
        } else {
          _1170 = _1094;
          _1171 = _1097;
          _1172 = _1100;
        }
        _1188 = ((mad(0.16386906802654266f, _1172, mad(0.14067870378494263f, _1171, (_1170 * 0.6954522132873535f))) - _1085) * cb0_012w) + _1085;
        _1189 = ((mad(0.0955343171954155f, _1172, mad(0.8596711158752441f, _1171, (_1170 * 0.044794563204050064f))) - _1088) * cb0_012w) + _1088;
        _1190 = ((mad(1.0015007257461548f, _1172, mad(0.004025210160762072f, _1171, (_1170 * -0.005525882821530104f))) - _1091) * cb0_012w) + _1091;
        _1194 = max(max(_1188, _1189), _1190);
        _1199 = (max(_1194, 1.000000013351432e-10f) - max(min(min(_1188, _1189), _1190), 1.000000013351432e-10f)) / max(_1194, 0.009999999776482582f);
        _1212 = ((_1189 + _1188) + _1190) + (sqrt((((_1190 - _1189) * _1190) + ((_1189 - _1188) * _1189)) + ((_1188 - _1190) * _1188)) * 1.75f);
        _1213 = _1212 * 0.3333333432674408f;
        _1214 = _1199 + -0.4000000059604645f;
        _1215 = _1214 * 5.0f;
        _1219 = max((1.0f - abs(_1214 * 2.5f)), 0.0f);
        _1230 = ((float((int)(((int)(uint)((int)(_1215 > 0.0f))) - ((int)(uint)((int)(_1215 < 0.0f))))) * (1.0f - (_1219 * _1219))) + 1.0f) * 0.02500000037252903f;
        if (_1213 > 0.0533333346247673f) {
          if (_1213 < 0.1599999964237213f) {
            _1239 = (((0.23999999463558197f / _1212) + -0.5f) * _1230);
          } else {
            _1239 = 0.0f;
          }
        } else {
          _1239 = _1230;
        }
        _1240 = _1239 + 1.0f;
        _1241 = _1240 * _1188;
        _1242 = _1240 * _1189;
        _1243 = _1240 * _1190;
        if (!((_1241 == _1242) && (_1242 == _1243))) {
          _1250 = ((_1241 * 2.0f) - _1242) - _1243;
          _1253 = ((_1189 - _1190) * 1.7320507764816284f) * _1240;
          _1255 = atan(_1253 / _1250);
          _1258 = (_1250 < 0.0f);
          _1259 = (_1250 == 0.0f);
          _1260 = (_1253 >= 0.0f);
          _1261 = (_1253 < 0.0f);
          _1272 = select((_1260 && _1259), 90.0f, select((_1261 && _1259), -90.0f, (select((_1261 && _1258), (_1255 + -3.1415927410125732f), select((_1260 && _1258), (_1255 + 3.1415927410125732f), _1255)) * 57.2957763671875f)));
        } else {
          _1272 = 0.0f;
        }
        _1277 = min(max(select((_1272 < 0.0f), (_1272 + 360.0f), _1272), 0.0f), 360.0f);
        if (_1277 < -180.0f) {
          _1286 = (_1277 + 360.0f);
        } else {
          if (_1277 > 180.0f) {
            _1286 = (_1277 + -360.0f);
          } else {
            _1286 = _1277;
          }
        }
        if ((_1286 > -67.5f) && (_1286 < 67.5f)) {
          _1292 = (_1286 + 67.5f) * 0.029629629105329514f;
          _1293 = int(_1292);
          _1295 = _1292 - float((int)(_1293));
          _1296 = _1295 * _1295;
          _1297 = _1296 * _1295;
          if (_1293 == 3) {
            _1325 = (((0.1666666716337204f - (_1295 * 0.5f)) + (_1296 * 0.5f)) - (_1297 * 0.1666666716337204f));
          } else {
            if (_1293 == 2) {
              _1325 = ((0.6666666865348816f - _1296) + (_1297 * 0.5f));
            } else {
              if (_1293 == 1) {
                _1325 = (((_1297 * -0.5f) + 0.1666666716337204f) + ((_1296 + _1295) * 0.5f));
              } else {
                _1325 = select((_1293 == 0), (_1297 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1325 = 0.0f;
        }
        _1334 = min(max(((((_1199 * 0.27000001072883606f) * (0.029999999329447746f - _1241)) * _1325) + _1241), 0.0f), 65535.0f);
        _1335 = min(max(_1242, 0.0f), 65535.0f);
        _1336 = min(max(_1243, 0.0f), 65535.0f);
        _1349 = min(max(mad(-0.21492856740951538f, _1336, mad(-0.2365107536315918f, _1335, (_1334 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1350 = min(max(mad(-0.09967592358589172f, _1336, mad(1.17622971534729f, _1335, (_1334 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1351 = min(max(mad(0.9977163076400757f, _1336, mad(-0.006032449658960104f, _1335, (_1334 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1352 = dot(float3(_1349, _1350, _1351), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        _16[0] = cb0_010x;
        _16[1] = cb0_010y;
        _16[2] = cb0_010z;
        _16[3] = cb0_010w;
        _16[4] = cb0_012x;
        _16[5] = cb0_012x;
        _17[0] = cb0_011x;
        _17[1] = cb0_011y;
        _17[2] = cb0_011z;
        _17[3] = cb0_011w;
        _17[4] = cb0_012y;
        _17[5] = cb0_012y;
        _1375 = log2(max((lerp(_1352, _1349, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1376 = _1375 * 0.3010300099849701f;
        _1377 = log2(cb0_008x);
        _1378 = _1377 * 0.3010300099849701f;
        if (_1376 > _1378) {
          _1385 = log2(cb0_009x);
          _1386 = _1385 * 0.3010300099849701f;
          if ((_1376 > _1378) && (_1376 < _1386)) {
            _1394 = ((_1375 - _1377) * 0.9030900001525879f) / ((_1385 - _1377) * 0.3010300099849701f);
            _1395 = int(_1394);
            _1397 = _1394 - float((int)(_1395));
            _1399 = _16[min((uint)(_1395), 5u)];
            _1402 = _16[min((uint)((_1395 + 1)), 5u)];
            _1407 = _1399 * 0.5f;
            _1447 = dot(float3((_1397 * _1397), _1397, 1.0f), float3(mad((_16[min((uint)((_1395 + 2)), 5u)]), 0.5f, mad(_1402, -1.0f, _1407)), (_1402 - _1399), mad(_1402, 0.5f, _1407)));
          } else {
            if (_1376 < _1386) {
              _1447 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1416 = log2(cb0_008z);
              if (!(_1376 < (_1416 * 0.3010300099849701f))) {
                _1447 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1424 = ((_1375 - _1385) * 0.9030900001525879f) / ((_1416 - _1385) * 0.3010300099849701f);
                _1425 = int(_1424);
                _1427 = _1424 - float((int)(_1425));
                _1429 = _17[min((uint)(_1425), 5u)];
                _1432 = _17[min((uint)((_1425 + 1)), 5u)];
                _1437 = _1429 * 0.5f;
                _1447 = dot(float3((_1427 * _1427), _1427, 1.0f), float3(mad((_17[min((uint)((_1425 + 2)), 5u)]), 0.5f, mad(_1432, -1.0f, _1437)), (_1432 - _1429), mad(_1432, 0.5f, _1437)));
              }
            }
          }
        } else {
          _1447 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _18[0] = cb0_010x;
        _18[1] = cb0_010y;
        _18[2] = cb0_010z;
        _18[3] = cb0_010w;
        _18[4] = cb0_012x;
        _18[5] = cb0_012x;
        _1457 = log2(max((lerp(_1352, _1350, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1458 = _1457 * 0.3010300099849701f;
        if (_1458 > _1378) {
          _1465 = log2(cb0_009x);
          _1466 = _1465 * 0.3010300099849701f;
          if ((_1458 > _1378) && (_1458 < _1466)) {
            _1474 = ((_1457 - _1377) * 0.9030900001525879f) / ((_1465 - _1377) * 0.3010300099849701f);
            _1475 = int(_1474);
            _1477 = _1474 - float((int)(_1475));
            _1479 = _18[min((uint)(_1475), 5u)];
            _1482 = _18[min((uint)((_1475 + 1)), 5u)];
            _1487 = _1479 * 0.5f;
            _1527 = dot(float3((_1477 * _1477), _1477, 1.0f), float3(mad((_18[min((uint)((_1475 + 2)), 5u)]), 0.5f, mad(_1482, -1.0f, _1487)), (_1482 - _1479), mad(_1482, 0.5f, _1487)));
          } else {
            if (_1458 < _1466) {
              _1527 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1496 = log2(cb0_008z);
              if (!(_1458 < (_1496 * 0.3010300099849701f))) {
                _1527 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1504 = ((_1457 - _1465) * 0.9030900001525879f) / ((_1496 - _1465) * 0.3010300099849701f);
                _1505 = int(_1504);
                _1507 = _1504 - float((int)(_1505));
                _1509 = _9[min((uint)(_1505), 5u)];
                _1512 = _9[min((uint)((_1505 + 1)), 5u)];
                _1517 = _1509 * 0.5f;
                _1527 = dot(float3((_1507 * _1507), _1507, 1.0f), float3(mad((_9[min((uint)((_1505 + 2)), 5u)]), 0.5f, mad(_1512, -1.0f, _1517)), (_1512 - _1509), mad(_1512, 0.5f, _1517)));
              }
            }
          }
        } else {
          _1527 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1531 = log2(max((lerp(_1352, _1351, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1532 = _1531 * 0.3010300099849701f;
        if (_1532 > _1378) {
          _1539 = log2(cb0_009x);
          _1540 = _1539 * 0.3010300099849701f;
          if ((_1532 > _1378) && (_1532 < _1540)) {
            _1548 = ((_1531 - _1377) * 0.9030900001525879f) / ((_1539 - _1377) * 0.3010300099849701f);
            _1549 = int(_1548);
            _1551 = _1548 - float((int)(_1549));
            _1553 = _8[min((uint)(_1549), 5u)];
            _1556 = _8[min((uint)((_1549 + 1)), 5u)];
            _1561 = _1553 * 0.5f;
            _1601 = dot(float3((_1551 * _1551), _1551, 1.0f), float3(mad((_8[min((uint)((_1549 + 2)), 5u)]), 0.5f, mad(_1556, -1.0f, _1561)), (_1556 - _1553), mad(_1556, 0.5f, _1561)));
          } else {
            if (_1532 < _1540) {
              _1601 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1570 = log2(cb0_008z);
              if (!(_1532 < (_1570 * 0.3010300099849701f))) {
                _1601 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1578 = ((_1531 - _1539) * 0.9030900001525879f) / ((_1570 - _1539) * 0.3010300099849701f);
                _1579 = int(_1578);
                _1581 = _1578 - float((int)(_1579));
                _1583 = _9[min((uint)(_1579), 5u)];
                _1586 = _9[min((uint)((_1579 + 1)), 5u)];
                _1591 = _1583 * 0.5f;
                _1601 = dot(float3((_1581 * _1581), _1581, 1.0f), float3(mad((_9[min((uint)((_1579 + 2)), 5u)]), 0.5f, mad(_1586, -1.0f, _1591)), (_1586 - _1583), mad(_1586, 0.5f, _1591)));
              }
            }
          }
        } else {
          _1601 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1605 = cb0_008w - cb0_008y;
        _1606 = (exp2(_1447 * 3.321928024291992f) - cb0_008y) / _1605;
        _1608 = (exp2(_1527 * 3.321928024291992f) - cb0_008y) / _1605;
        _1610 = (exp2(_1601 * 3.321928024291992f) - cb0_008y) / _1605;
        _1613 = mad(0.15618768334388733f, _1610, mad(0.13400420546531677f, _1608, (_1606 * 0.6624541878700256f)));
        _1616 = mad(0.053689517080783844f, _1610, mad(0.6740817427635193f, _1608, (_1606 * 0.2722287178039551f)));
        _1619 = mad(1.0103391408920288f, _1610, mad(0.00406073359772563f, _1608, (_1606 * -0.005574649665504694f)));
        _1632 = min(max(mad(-0.23642469942569733f, _1619, mad(-0.32480329275131226f, _1616, (_1613 * 1.6410233974456787f))), 0.0f), 1.0f);
        _1633 = min(max(mad(0.016756348311901093f, _1619, mad(1.6153316497802734f, _1616, (_1613 * -0.663662850856781f))), 0.0f), 1.0f);
        _1634 = min(max(mad(0.9883948564529419f, _1619, mad(-0.008284442126750946f, _1616, (_1613 * 0.011721894145011902f))), 0.0f), 1.0f);
        _1637 = mad(0.15618768334388733f, _1634, mad(0.13400420546531677f, _1633, (_1632 * 0.6624541878700256f)));
        _1640 = mad(0.053689517080783844f, _1634, mad(0.6740817427635193f, _1633, (_1632 * 0.2722287178039551f)));
        _1643 = mad(1.0103391408920288f, _1634, mad(0.00406073359772563f, _1633, (_1632 * -0.005574649665504694f)));
        _1665 = min(max((min(max(mad(-0.23642469942569733f, _1643, mad(-0.32480329275131226f, _1640, (_1637 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _1666 = min(max((min(max(mad(0.016756348311901093f, _1643, mad(1.6153316497802734f, _1640, (_1637 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _1667 = min(max((min(max(mad(0.9883948564529419f, _1643, mad(-0.008284442126750946f, _1640, (_1637 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _1686 = exp2(log2(mad(_52, _1667, mad(_51, _1666, (_1665 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _1687 = exp2(log2(mad(_55, _1667, mad(_54, _1666, (_1665 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _1688 = exp2(log2(mad(_58, _1667, mad(_57, _1666, (_1665 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2508 = exp2(log2((1.0f / ((_1686 * 18.6875f) + 1.0f)) * ((_1686 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2509 = exp2(log2((1.0f / ((_1687 * 18.6875f) + 1.0f)) * ((_1687 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2510 = exp2(log2((1.0f / ((_1688 * 18.6875f) + 1.0f)) * ((_1688 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _1754 = cb0_012z * _883;
          _1755 = cb0_012z * _884;
          _1756 = cb0_012z * _885;
          _1759 = mad((WorkingColorSpace_256[0].z), _1756, mad((WorkingColorSpace_256[0].y), _1755, ((WorkingColorSpace_256[0].x) * _1754)));
          _1762 = mad((WorkingColorSpace_256[1].z), _1756, mad((WorkingColorSpace_256[1].y), _1755, ((WorkingColorSpace_256[1].x) * _1754)));
          _1765 = mad((WorkingColorSpace_256[2].z), _1756, mad((WorkingColorSpace_256[2].y), _1755, ((WorkingColorSpace_256[2].x) * _1754)));
          _1768 = mad(-0.21492856740951538f, _1765, mad(-0.2365107536315918f, _1762, (_1759 * 1.4514392614364624f)));
          _1771 = mad(-0.09967592358589172f, _1765, mad(1.17622971534729f, _1762, (_1759 * -0.07655377686023712f)));
          _1774 = mad(0.9977163076400757f, _1765, mad(-0.006032449658960104f, _1762, (_1759 * 0.008316148072481155f)));
          _1776 = max(_1768, max(_1771, _1774));
          if (!(_1776 < 1.000000013351432e-10f)) {
            if (!(((_1759 < 0.0f) || (_1762 < 0.0f)) || (_1765 < 0.0f))) {
              _1786 = abs(_1776);
              _1787 = (_1776 - _1768) / _1786;
              _1789 = (_1776 - _1771) / _1786;
              _1791 = (_1776 - _1774) / _1786;
              if (!(_1787 < 0.8149999976158142f)) {
                _1794 = _1787 + -0.8149999976158142f;
                _1806 = ((_1794 / exp2(log2(exp2(log2(_1794 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _1806 = _1787;
              }
              if (!(_1789 < 0.8029999732971191f)) {
                _1809 = _1789 + -0.8029999732971191f;
                _1821 = ((_1809 / exp2(log2(exp2(log2(_1809 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _1821 = _1789;
              }
              if (!(_1791 < 0.8799999952316284f)) {
                _1824 = _1791 + -0.8799999952316284f;
                _1836 = ((_1824 / exp2(log2(exp2(log2(_1824 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _1836 = _1791;
              }
              _1844 = (_1776 - (_1786 * _1806));
              _1845 = (_1776 - (_1786 * _1821));
              _1846 = (_1776 - (_1786 * _1836));
            } else {
              _1844 = _1768;
              _1845 = _1771;
              _1846 = _1774;
            }
          } else {
            _1844 = _1768;
            _1845 = _1771;
            _1846 = _1774;
          }
          _1862 = ((mad(0.16386906802654266f, _1846, mad(0.14067870378494263f, _1845, (_1844 * 0.6954522132873535f))) - _1759) * cb0_012w) + _1759;
          _1863 = ((mad(0.0955343171954155f, _1846, mad(0.8596711158752441f, _1845, (_1844 * 0.044794563204050064f))) - _1762) * cb0_012w) + _1762;
          _1864 = ((mad(1.0015007257461548f, _1846, mad(0.004025210160762072f, _1845, (_1844 * -0.005525882821530104f))) - _1765) * cb0_012w) + _1765;
          _1868 = max(max(_1862, _1863), _1864);
          _1873 = (max(_1868, 1.000000013351432e-10f) - max(min(min(_1862, _1863), _1864), 1.000000013351432e-10f)) / max(_1868, 0.009999999776482582f);
          _1886 = ((_1863 + _1862) + _1864) + (sqrt((((_1864 - _1863) * _1864) + ((_1863 - _1862) * _1863)) + ((_1862 - _1864) * _1862)) * 1.75f);
          _1887 = _1886 * 0.3333333432674408f;
          _1888 = _1873 + -0.4000000059604645f;
          _1889 = _1888 * 5.0f;
          _1893 = max((1.0f - abs(_1888 * 2.5f)), 0.0f);
          _1904 = ((float((int)(((int)(uint)((int)(_1889 > 0.0f))) - ((int)(uint)((int)(_1889 < 0.0f))))) * (1.0f - (_1893 * _1893))) + 1.0f) * 0.02500000037252903f;
          if (_1887 > 0.0533333346247673f) {
            if (_1887 < 0.1599999964237213f) {
              _1913 = (((0.23999999463558197f / _1886) + -0.5f) * _1904);
            } else {
              _1913 = 0.0f;
            }
          } else {
            _1913 = _1904;
          }
          _1914 = _1913 + 1.0f;
          _1915 = _1914 * _1862;
          _1916 = _1914 * _1863;
          _1917 = _1914 * _1864;
          if (!((_1915 == _1916) && (_1916 == _1917))) {
            _1924 = ((_1915 * 2.0f) - _1916) - _1917;
            _1927 = ((_1863 - _1864) * 1.7320507764816284f) * _1914;
            _1929 = atan(_1927 / _1924);
            _1932 = (_1924 < 0.0f);
            _1933 = (_1924 == 0.0f);
            _1934 = (_1927 >= 0.0f);
            _1935 = (_1927 < 0.0f);
            _1946 = select((_1934 && _1933), 90.0f, select((_1935 && _1933), -90.0f, (select((_1935 && _1932), (_1929 + -3.1415927410125732f), select((_1934 && _1932), (_1929 + 3.1415927410125732f), _1929)) * 57.2957763671875f)));
          } else {
            _1946 = 0.0f;
          }
          _1951 = min(max(select((_1946 < 0.0f), (_1946 + 360.0f), _1946), 0.0f), 360.0f);
          if (_1951 < -180.0f) {
            _1960 = (_1951 + 360.0f);
          } else {
            if (_1951 > 180.0f) {
              _1960 = (_1951 + -360.0f);
            } else {
              _1960 = _1951;
            }
          }
          if ((_1960 > -67.5f) && (_1960 < 67.5f)) {
            _1966 = (_1960 + 67.5f) * 0.029629629105329514f;
            _1967 = int(_1966);
            _1969 = _1966 - float((int)(_1967));
            _1970 = _1969 * _1969;
            _1971 = _1970 * _1969;
            if (_1967 == 3) {
              _1999 = (((0.1666666716337204f - (_1969 * 0.5f)) + (_1970 * 0.5f)) - (_1971 * 0.1666666716337204f));
            } else {
              if (_1967 == 2) {
                _1999 = ((0.6666666865348816f - _1970) + (_1971 * 0.5f));
              } else {
                if (_1967 == 1) {
                  _1999 = (((_1971 * -0.5f) + 0.1666666716337204f) + ((_1970 + _1969) * 0.5f));
                } else {
                  _1999 = select((_1967 == 0), (_1971 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _1999 = 0.0f;
          }
          _2008 = min(max(((((_1873 * 0.27000001072883606f) * (0.029999999329447746f - _1915)) * _1999) + _1915), 0.0f), 65535.0f);
          _2009 = min(max(_1916, 0.0f), 65535.0f);
          _2010 = min(max(_1917, 0.0f), 65535.0f);
          _2023 = min(max(mad(-0.21492856740951538f, _2010, mad(-0.2365107536315918f, _2009, (_2008 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2024 = min(max(mad(-0.09967592358589172f, _2010, mad(1.17622971534729f, _2009, (_2008 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2025 = min(max(mad(0.9977163076400757f, _2010, mad(-0.006032449658960104f, _2009, (_2008 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2026 = dot(float3(_2023, _2024, _2025), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
          _14[0] = cb0_010x;
          _14[1] = cb0_010y;
          _14[2] = cb0_010z;
          _14[3] = cb0_010w;
          _14[4] = cb0_012x;
          _14[5] = cb0_012x;
          _15[0] = cb0_011x;
          _15[1] = cb0_011y;
          _15[2] = cb0_011z;
          _15[3] = cb0_011w;
          _15[4] = cb0_012y;
          _15[5] = cb0_012y;
          _2049 = log2(max((lerp(_2026, _2023, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2050 = _2049 * 0.3010300099849701f;
          _2051 = log2(cb0_008x);
          _2052 = _2051 * 0.3010300099849701f;
          if (_2050 > _2052) {
            _2059 = log2(cb0_009x);
            _2060 = _2059 * 0.3010300099849701f;
            if ((_2050 > _2052) && (_2050 < _2060)) {
              _2068 = ((_2049 - _2051) * 0.9030900001525879f) / ((_2059 - _2051) * 0.3010300099849701f);
              _2069 = int(_2068);
              _2071 = _2068 - float((int)(_2069));
              _2073 = _14[min((uint)(_2069), 5u)];
              _2076 = _14[min((uint)((_2069 + 1)), 5u)];
              _2081 = _2073 * 0.5f;
              _2121 = dot(float3((_2071 * _2071), _2071, 1.0f), float3(mad((_14[min((uint)((_2069 + 2)), 5u)]), 0.5f, mad(_2076, -1.0f, _2081)), (_2076 - _2073), mad(_2076, 0.5f, _2081)));
            } else {
              if (_2050 < _2060) {
                _2121 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2090 = log2(cb0_008z);
                if (!(_2050 < (_2090 * 0.3010300099849701f))) {
                  _2121 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2098 = ((_2049 - _2059) * 0.9030900001525879f) / ((_2090 - _2059) * 0.3010300099849701f);
                  _2099 = int(_2098);
                  _2101 = _2098 - float((int)(_2099));
                  _2103 = _15[min((uint)(_2099), 5u)];
                  _2106 = _15[min((uint)((_2099 + 1)), 5u)];
                  _2111 = _2103 * 0.5f;
                  _2121 = dot(float3((_2101 * _2101), _2101, 1.0f), float3(mad((_15[min((uint)((_2099 + 2)), 5u)]), 0.5f, mad(_2106, -1.0f, _2111)), (_2106 - _2103), mad(_2106, 0.5f, _2111)));
                }
              }
            }
          } else {
            _2121 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _10[0] = cb0_010x;
          _10[1] = cb0_010y;
          _10[2] = cb0_010z;
          _10[3] = cb0_010w;
          _10[4] = cb0_012x;
          _10[5] = cb0_012x;
          _11[0] = cb0_011x;
          _11[1] = cb0_011y;
          _11[2] = cb0_011z;
          _11[3] = cb0_011w;
          _11[4] = cb0_012y;
          _11[5] = cb0_012y;
          _2137 = log2(max((lerp(_2026, _2024, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2138 = _2137 * 0.3010300099849701f;
          if (_2138 > _2052) {
            _2145 = log2(cb0_009x);
            _2146 = _2145 * 0.3010300099849701f;
            if ((_2138 > _2052) && (_2138 < _2146)) {
              _2154 = ((_2137 - _2051) * 0.9030900001525879f) / ((_2145 - _2051) * 0.3010300099849701f);
              _2155 = int(_2154);
              _2157 = _2154 - float((int)(_2155));
              _2159 = _10[min((uint)(_2155), 5u)];
              _2162 = _10[min((uint)((_2155 + 1)), 5u)];
              _2167 = _2159 * 0.5f;
              _2207 = dot(float3((_2157 * _2157), _2157, 1.0f), float3(mad((_10[min((uint)((_2155 + 2)), 5u)]), 0.5f, mad(_2162, -1.0f, _2167)), (_2162 - _2159), mad(_2162, 0.5f, _2167)));
            } else {
              if (_2138 < _2146) {
                _2207 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2176 = log2(cb0_008z);
                if (!(_2138 < (_2176 * 0.3010300099849701f))) {
                  _2207 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2184 = ((_2137 - _2145) * 0.9030900001525879f) / ((_2176 - _2145) * 0.3010300099849701f);
                  _2185 = int(_2184);
                  _2187 = _2184 - float((int)(_2185));
                  _2189 = _11[min((uint)(_2185), 5u)];
                  _2192 = _11[min((uint)((_2185 + 1)), 5u)];
                  _2197 = _2189 * 0.5f;
                  _2207 = dot(float3((_2187 * _2187), _2187, 1.0f), float3(mad((_11[min((uint)((_2185 + 2)), 5u)]), 0.5f, mad(_2192, -1.0f, _2197)), (_2192 - _2189), mad(_2192, 0.5f, _2197)));
                }
              }
            }
          } else {
            _2207 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _12[0] = cb0_010x;
          _12[1] = cb0_010y;
          _12[2] = cb0_010z;
          _12[3] = cb0_010w;
          _12[4] = cb0_012x;
          _12[5] = cb0_012x;
          _13[0] = cb0_011x;
          _13[1] = cb0_011y;
          _13[2] = cb0_011z;
          _13[3] = cb0_011w;
          _13[4] = cb0_012y;
          _13[5] = cb0_012y;
          _2223 = log2(max((lerp(_2026, _2025, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2224 = _2223 * 0.3010300099849701f;
          if (_2224 > _2052) {
            _2231 = log2(cb0_009x);
            _2232 = _2231 * 0.3010300099849701f;
            if ((_2224 > _2052) && (_2224 < _2232)) {
              _2240 = ((_2223 - _2051) * 0.9030900001525879f) / ((_2231 - _2051) * 0.3010300099849701f);
              _2241 = int(_2240);
              _2243 = _2240 - float((int)(_2241));
              _2245 = _12[min((uint)(_2241), 5u)];
              _2248 = _12[min((uint)((_2241 + 1)), 5u)];
              _2253 = _2245 * 0.5f;
              _2293 = dot(float3((_2243 * _2243), _2243, 1.0f), float3(mad((_12[min((uint)((_2241 + 2)), 5u)]), 0.5f, mad(_2248, -1.0f, _2253)), (_2248 - _2245), mad(_2248, 0.5f, _2253)));
            } else {
              if (_2224 < _2232) {
                _2293 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2262 = log2(cb0_008z);
                if (!(_2224 < (_2262 * 0.3010300099849701f))) {
                  _2293 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2270 = ((_2223 - _2231) * 0.9030900001525879f) / ((_2262 - _2231) * 0.3010300099849701f);
                  _2271 = int(_2270);
                  _2273 = _2270 - float((int)(_2271));
                  _2275 = _13[min((uint)(_2271), 5u)];
                  _2278 = _13[min((uint)((_2271 + 1)), 5u)];
                  _2283 = _2275 * 0.5f;
                  _2293 = dot(float3((_2273 * _2273), _2273, 1.0f), float3(mad((_13[min((uint)((_2271 + 2)), 5u)]), 0.5f, mad(_2278, -1.0f, _2283)), (_2278 - _2275), mad(_2278, 0.5f, _2283)));
                }
              }
            }
          } else {
            _2293 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2297 = cb0_008w - cb0_008y;
          _2298 = (exp2(_2121 * 3.321928024291992f) - cb0_008y) / _2297;
          _2300 = (exp2(_2207 * 3.321928024291992f) - cb0_008y) / _2297;
          _2302 = (exp2(_2293 * 3.321928024291992f) - cb0_008y) / _2297;
          _2305 = mad(0.15618768334388733f, _2302, mad(0.13400420546531677f, _2300, (_2298 * 0.6624541878700256f)));
          _2308 = mad(0.053689517080783844f, _2302, mad(0.6740817427635193f, _2300, (_2298 * 0.2722287178039551f)));
          _2311 = mad(1.0103391408920288f, _2302, mad(0.00406073359772563f, _2300, (_2298 * -0.005574649665504694f)));
          _2324 = min(max(mad(-0.23642469942569733f, _2311, mad(-0.32480329275131226f, _2308, (_2305 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2325 = min(max(mad(0.016756348311901093f, _2311, mad(1.6153316497802734f, _2308, (_2305 * -0.663662850856781f))), 0.0f), 1.0f);
          _2326 = min(max(mad(0.9883948564529419f, _2311, mad(-0.008284442126750946f, _2308, (_2305 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2329 = mad(0.15618768334388733f, _2326, mad(0.13400420546531677f, _2325, (_2324 * 0.6624541878700256f)));
          _2332 = mad(0.053689517080783844f, _2326, mad(0.6740817427635193f, _2325, (_2324 * 0.2722287178039551f)));
          _2335 = mad(1.0103391408920288f, _2326, mad(0.00406073359772563f, _2325, (_2324 * -0.005574649665504694f)));
          _2357 = min(max((min(max(mad(-0.23642469942569733f, _2335, mad(-0.32480329275131226f, _2332, (_2329 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2360 = min(max((min(max(mad(0.016756348311901093f, _2335, mad(1.6153316497802734f, _2332, (_2329 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2361 = min(max((min(max(mad(0.9883948564529419f, _2335, mad(-0.008284442126750946f, _2332, (_2329 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2508 = mad(-0.0832589864730835f, _2361, mad(-0.6217921376228333f, _2360, (_2357 * 0.0213131383061409f)));
          _2509 = mad(-0.010548308491706848f, _2361, mad(1.140804648399353f, _2360, (_2357 * -0.0016282059950754046f)));
          _2510 = mad(1.1529725790023804f, _2361, mad(-0.1289689838886261f, _2360, (_2357 * -0.00030004189466126263f)));
        } else {
          if (cb0_042w == 7) {
            _2388 = mad((WorkingColorSpace_128[0].z), _885, mad((WorkingColorSpace_128[0].y), _884, ((WorkingColorSpace_128[0].x) * _883)));
            _2391 = mad((WorkingColorSpace_128[1].z), _885, mad((WorkingColorSpace_128[1].y), _884, ((WorkingColorSpace_128[1].x) * _883)));
            _2394 = mad((WorkingColorSpace_128[2].z), _885, mad((WorkingColorSpace_128[2].y), _884, ((WorkingColorSpace_128[2].x) * _883)));
            _2413 = exp2(log2(mad(_52, _2394, mad(_51, _2391, (_2388 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2414 = exp2(log2(mad(_55, _2394, mad(_54, _2391, (_2388 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2415 = exp2(log2(mad(_58, _2394, mad(_57, _2391, (_2388 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2508 = exp2(log2((1.0f / ((_2413 * 18.6875f) + 1.0f)) * ((_2413 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2509 = exp2(log2((1.0f / ((_2414 * 18.6875f) + 1.0f)) * ((_2414 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2510 = exp2(log2((1.0f / ((_2415 * 18.6875f) + 1.0f)) * ((_2415 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _2462 = mad((WorkingColorSpace_128[0].z), _873, mad((WorkingColorSpace_128[0].y), _872, ((WorkingColorSpace_128[0].x) * _871)));
                _2465 = mad((WorkingColorSpace_128[1].z), _873, mad((WorkingColorSpace_128[1].y), _872, ((WorkingColorSpace_128[1].x) * _871)));
                _2468 = mad((WorkingColorSpace_128[2].z), _873, mad((WorkingColorSpace_128[2].y), _872, ((WorkingColorSpace_128[2].x) * _871)));
                _2508 = mad(_52, _2468, mad(_51, _2465, (_2462 * _50)));
                _2509 = mad(_55, _2468, mad(_54, _2465, (_2462 * _53)));
                _2510 = mad(_58, _2468, mad(_57, _2465, (_2462 * _56)));
              } else {
                _2481 = mad((WorkingColorSpace_128[0].z), _899, mad((WorkingColorSpace_128[0].y), _898, ((WorkingColorSpace_128[0].x) * _897)));
                _2484 = mad((WorkingColorSpace_128[1].z), _899, mad((WorkingColorSpace_128[1].y), _898, ((WorkingColorSpace_128[1].x) * _897)));
                _2487 = mad((WorkingColorSpace_128[2].z), _899, mad((WorkingColorSpace_128[2].y), _898, ((WorkingColorSpace_128[2].x) * _897)));
                _2508 = exp2(log2(mad(_52, _2487, mad(_51, _2484, (_2481 * _50)))) * cb0_042z);
                _2509 = exp2(log2(mad(_55, _2487, mad(_54, _2484, (_2481 * _53)))) * cb0_042z);
                _2510 = exp2(log2(mad(_58, _2487, mad(_57, _2484, (_2481 * _56)))) * cb0_042z);
              }
            } else {
              _2508 = _883;
              _2509 = _884;
              _2510 = _885;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2508 * 0.9523810148239136f);
  SV_Target.y = (_2509 * 0.9523810148239136f);
  SV_Target.z = (_2510 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
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
  float cb0_038z : packoffset(c038.z);
  float cb0_038w : packoffset(c038.w);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_039w : packoffset(c039.w);
  float cb0_040x : packoffset(c040.x);
  float cb0_040y : packoffset(c040.y);
  int cb0_040w : packoffset(c040.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  int cb0_042w : packoffset(c042.w);
  int cb0_043x : packoffset(c043.x);
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
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

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _36;
  float _41;
  float _42;
  float _43;
  float _45;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _72;
  float _73;
  float _131;
  float _132;
  float _133;
  float _188;
  float _395;
  float _396;
  float _397;
  float _920;
  float _953;
  float _967;
  float _1031;
  float _1210;
  float _1221;
  float _1232;
  float _1455;
  float _1456;
  float _1457;
  float _1468;
  float _1479;
  float _1648;
  float _1663;
  float _1678;
  float _1686;
  float _1687;
  float _1688;
  float _1755;
  float _1788;
  float _1802;
  float _1841;
  float _1963;
  float _2037;
  float _2111;
  float _2316;
  float _2331;
  float _2346;
  float _2354;
  float _2355;
  float _2356;
  float _2423;
  float _2456;
  float _2470;
  float _2509;
  float _2631;
  float _2717;
  float _2803;
  float _3018;
  float _3019;
  float _3020;
  bool _54;
  float _84;
  float _85;
  float _86;
  bool _169;
  float _171;
  float _202;
  float _209;
  float _212;
  float _217;
  float _218;
  float _220;
  bool _221;
  float _230;
  float _232;
  float _239;
  float _241;
  float _243;
  float _244;
  float _247;
  float _250;
  float _255;
  float _261;
  float _262;
  float _263;
  float _264;
  float _265;
  float _266;
  float _267;
  float _268;
  float _271;
  float _272;
  float _273;
  float _276;
  float _295;
  float _296;
  float _297;
  float _298;
  float _299;
  float _300;
  float _301;
  float _302;
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
  float _345;
  float _348;
  float _351;
  float _354;
  float _357;
  float _412;
  float _415;
  float _418;
  float _419;
  float _423;
  float _424;
  float _425;
  float _437;
  float _453;
  float _454;
  float _455;
  float _456;
  float _470;
  float _484;
  float _498;
  float _512;
  float _526;
  float _530;
  float _531;
  float _532;
  float _589;
  float _593;
  float _594;
  float _603;
  float _612;
  float _621;
  float _630;
  float _639;
  float _702;
  float _706;
  float _715;
  float _724;
  float _733;
  float _742;
  float _751;
  float _809;
  float _820;
  float _822;
  float _824;
  float _860;
  float _861;
  float _862;
  float _865;
  float _868;
  float _871;
  float _875;
  float _880;
  float _893;
  float _894;
  float _895;
  float _896;
  float _900;
  float _911;
  float _921;
  float _922;
  float _923;
  float _924;
  float _931;
  float _934;
  float _936;
  bool _939;
  bool _940;
  bool _941;
  bool _942;
  float _958;
  float _971;
  float _975;
  float _981;
  float _991;
  float _992;
  float _993;
  float _994;
  float _1009;
  float _1011;
  float _1013;
  float _1022;
  float _1034;
  float _1036;
  float _1040;
  float _1041;
  float _1042;
  float _1046;
  float _1047;
  float _1048;
  float _1049;
  float _1051;
  float _1052;
  float _1053;
  float _1054;
  float _1073;
  float _1075;
  float _1100;
  float _1101;
  float _1102;
  float _1109;
  float _1113;
  float _1114;
  float _1115;
  bool _1116;
  float _1120;
  float _1121;
  float _1122;
  float _1141;
  float _1142;
  float _1143;
  float _1144;
  float _1164;
  float _1165;
  float _1166;
  float _1182;
  float _1183;
  float _1184;
  float _1197;
  float _1198;
  float _1199;
  float _1236;
  float _1243;
  float _1244;
  float _1245;
  float _1247;
  float4 _1250;
  float _1254;
  float4 _1255;
  float4 _1277;
  float4 _1281;
  float4 _1303;
  float4 _1307;
  float _1323;
  float _1324;
  float _1325;
  float _1350;
  float _1351;
  float _1352;
  float _1378;
  float _1379;
  float _1380;
  float _1387;
  float _1388;
  float _1389;
  float _1390;
  float _1391;
  float _1392;
  float _1399;
  float _1400;
  float _1401;
  float _1413;
  float _1414;
  float _1415;
  float _1438;
  float _1441;
  float _1444;
  float _1506;
  float _1509;
  float _1512;
  float _1515;
  float _1518;
  float _1521;
  float _1596;
  float _1597;
  float _1598;
  float _1601;
  float _1604;
  float _1607;
  float _1610;
  float _1613;
  float _1616;
  float _1618;
  float _1628;
  float _1629;
  float _1631;
  float _1633;
  float _1636;
  float _1651;
  float _1666;
  float _1704;
  float _1705;
  float _1706;
  float _1710;
  float _1715;
  float _1728;
  float _1729;
  float _1730;
  float _1731;
  float _1735;
  float _1746;
  float _1756;
  float _1757;
  float _1758;
  float _1759;
  float _1766;
  float _1769;
  float _1771;
  bool _1774;
  bool _1775;
  bool _1776;
  bool _1777;
  float _1793;
  float _1808;
  int _1809;
  float _1811;
  float _1812;
  float _1813;
  float _1850;
  float _1851;
  float _1852;
  float _1865;
  float _1866;
  float _1867;
  float _1868;
  float _1891;
  float _1892;
  float _1893;
  float _1894;
  float _1901;
  float _1902;
  float _1910;
  int _1911;
  float _1913;
  float _1915;
  float _1918;
  float _1923;
  float _1932;
  float _1940;
  int _1941;
  float _1943;
  float _1945;
  float _1948;
  float _1953;
  float _1967;
  float _1968;
  float _1975;
  float _1976;
  float _1984;
  int _1985;
  float _1987;
  float _1989;
  float _1992;
  float _1997;
  float _2006;
  float _2014;
  int _2015;
  float _2017;
  float _2019;
  float _2022;
  float _2027;
  float _2041;
  float _2042;
  float _2049;
  float _2050;
  float _2058;
  int _2059;
  float _2061;
  float _2063;
  float _2066;
  float _2071;
  float _2080;
  float _2088;
  int _2089;
  float _2091;
  float _2093;
  float _2096;
  float _2101;
  float _2115;
  float _2116;
  float _2118;
  float _2120;
  float _2123;
  float _2126;
  float _2129;
  float _2142;
  float _2143;
  float _2144;
  float _2147;
  float _2150;
  float _2153;
  float _2175;
  float _2176;
  float _2177;
  float _2196;
  float _2197;
  float _2198;
  float _2264;
  float _2265;
  float _2266;
  float _2269;
  float _2272;
  float _2275;
  float _2278;
  float _2281;
  float _2284;
  float _2286;
  float _2296;
  float _2297;
  float _2299;
  float _2301;
  float _2304;
  float _2319;
  float _2334;
  float _2372;
  float _2373;
  float _2374;
  float _2378;
  float _2383;
  float _2396;
  float _2397;
  float _2398;
  float _2399;
  float _2403;
  float _2414;
  float _2424;
  float _2425;
  float _2426;
  float _2427;
  float _2434;
  float _2437;
  float _2439;
  bool _2442;
  bool _2443;
  bool _2444;
  bool _2445;
  float _2461;
  float _2476;
  int _2477;
  float _2479;
  float _2480;
  float _2481;
  float _2518;
  float _2519;
  float _2520;
  float _2533;
  float _2534;
  float _2535;
  float _2536;
  float _2559;
  float _2560;
  float _2561;
  float _2562;
  float _2569;
  float _2570;
  float _2578;
  int _2579;
  float _2581;
  float _2583;
  float _2586;
  float _2591;
  float _2600;
  float _2608;
  int _2609;
  float _2611;
  float _2613;
  float _2616;
  float _2621;
  float _2647;
  float _2648;
  float _2655;
  float _2656;
  float _2664;
  int _2665;
  float _2667;
  float _2669;
  float _2672;
  float _2677;
  float _2686;
  float _2694;
  int _2695;
  float _2697;
  float _2699;
  float _2702;
  float _2707;
  float _2733;
  float _2734;
  float _2741;
  float _2742;
  float _2750;
  int _2751;
  float _2753;
  float _2755;
  float _2758;
  float _2763;
  float _2772;
  float _2780;
  int _2781;
  float _2783;
  float _2785;
  float _2788;
  float _2793;
  float _2807;
  float _2808;
  float _2810;
  float _2812;
  float _2815;
  float _2818;
  float _2821;
  float _2834;
  float _2835;
  float _2836;
  float _2839;
  float _2842;
  float _2845;
  float _2867;
  float _2870;
  float _2871;
  float _2898;
  float _2901;
  float _2904;
  float _2923;
  float _2924;
  float _2925;
  float _2972;
  float _2975;
  float _2978;
  float _2991;
  float _2994;
  float _2997;
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _21[6];
  float _22[6];
  float _23[6];
  float _24[6];
  _36 = 0.5f / cb0_037x;
  _41 = cb0_037x + -1.0f;
  _42 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _36)) / _41;
  _43 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _36)) / _41;
  _45 = float((uint)SV_DispatchThreadID.z) / _41;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _54 = (cb0_043x == 4);
        _65 = select(_54, 1.0f, 1.705051064491272f);
        _66 = select(_54, 0.0f, -0.6217921376228333f);
        _67 = select(_54, 0.0f, -0.0832589864730835f);
        _68 = select(_54, 0.0f, -0.13025647401809692f);
        _69 = select(_54, 1.0f, 1.140804648399353f);
        _70 = select(_54, 0.0f, -0.010548308491706848f);
        _71 = select(_54, 0.0f, -0.024003351107239723f);
        _72 = select(_54, 0.0f, -0.1289689838886261f);
        _73 = select(_54, 1.0f, 1.1529725790023804f);
      } else {
        _65 = 0.6954522132873535f;
        _66 = 0.14067870378494263f;
        _67 = 0.16386906802654266f;
        _68 = 0.044794563204050064f;
        _69 = 0.8596711158752441f;
        _70 = 0.0955343171954155f;
        _71 = -0.005525882821530104f;
        _72 = 0.004025210160762072f;
        _73 = 1.0015007257461548f;
      }
    } else {
      _65 = 1.0258246660232544f;
      _66 = -0.020053181797266006f;
      _67 = -0.005771636962890625f;
      _68 = -0.002234415616840124f;
      _69 = 1.0045864582061768f;
      _70 = -0.002352118492126465f;
      _71 = -0.005013350863009691f;
      _72 = -0.025290070101618767f;
      _73 = 1.0303035974502563f;
    }
  } else {
    _65 = 1.3792141675949097f;
    _66 = -0.30886411666870117f;
    _67 = -0.0703500509262085f;
    _68 = -0.06933490186929703f;
    _69 = 1.08229660987854f;
    _70 = -0.012961871922016144f;
    _71 = -0.0021590073592960835f;
    _72 = -0.0454593189060688f;
    _73 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _84 = (pow(_42, 0.012683313339948654f));
    _85 = (pow(_43, 0.012683313339948654f));
    _86 = (pow(_45, 0.012683313339948654f));
    _131 = (exp2(log2(max(0.0f, (_84 + -0.8359375f)) / (18.8515625f - (_84 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _132 = (exp2(log2(max(0.0f, (_85 + -0.8359375f)) / (18.8515625f - (_85 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _133 = (exp2(log2(max(0.0f, (_86 + -0.8359375f)) / (18.8515625f - (_86 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _131 = ((exp2((_42 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _132 = ((exp2((_43 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _133 = ((exp2((_45 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _169 = (cb0_040w != 0);
    _171 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _188 = (((((1901800.0f - (_171 * 2006400000.0f)) * _171) + 247.47999572753906f) * _171) + 0.23703999817371368f);
    } else {
      _188 = (((((2967800.0f - (_171 * 4607000064.0f)) * _171) + 99.11000061035156f) * _171) + 0.24406300485134125f);
    }
    _202 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _209 = cb0_037y * cb0_037y;
    _212 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_209 * 1.6145605741257896e-07f));
    _217 = ((_202 * 2.0f) + 4.0f) - (_212 * 8.0f);
    _218 = (_202 * 3.0f) / _217;
    _220 = (_212 * 2.0f) / _217;
    _221 = (cb0_037y < 4000.0f);
    _230 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _232 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_209 * 1.5317699909210205f)) / (_230 * _230);
    _239 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _209;
    _241 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_209 * 308.60699462890625f)) / (_239 * _239);
    _243 = rsqrt(dot(float2(_232, _241), float2(_232, _241)));
    _244 = cb0_037z * 0.05000000074505806f;
    _247 = ((_244 * _241) * _243) + _202;
    _250 = _212 - ((_244 * _232) * _243);
    _255 = (4.0f - (_250 * 8.0f)) + (_247 * 2.0f);
    _261 = (((_247 * 3.0f) / _255) - _218) + select(_221, _218, _188);
    _262 = (((_250 * 2.0f) / _255) - _220) + select(_221, _220, (((_188 * 2.869999885559082f) + -0.2750000059604645f) - ((_188 * _188) * 3.0f)));
    _263 = select(_169, _261, 0.3127000033855438f);
    _264 = select(_169, _262, 0.32899999618530273f);
    _265 = select(_169, 0.3127000033855438f, _261);
    _266 = select(_169, 0.32899999618530273f, _262);
    _267 = max(_264, 1.000000013351432e-10f);
    _268 = _263 / _267;
    _271 = ((1.0f - _263) - _264) / _267;
    _272 = max(_266, 1.000000013351432e-10f);
    _273 = _265 / _272;
    _276 = ((1.0f - _265) - _266) / _272;
    _295 = mad(-0.16140000522136688f, _276, ((_273 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _271, ((_268 * 0.8950999975204468f) + 0.266400009393692f));
    _296 = mad(0.03669999912381172f, _276, (1.7135000228881836f - (_273 * 0.7501999735832214f))) / mad(0.03669999912381172f, _271, (1.7135000228881836f - (_268 * 0.7501999735832214f)));
    _297 = mad(1.0296000242233276f, _276, ((_273 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _271, ((_268 * 0.03889999911189079f) + -0.06849999725818634f));
    _298 = mad(_296, -0.7501999735832214f, 0.0f);
    _299 = mad(_296, 1.7135000228881836f, 0.0f);
    _300 = mad(_296, 0.03669999912381172f, -0.0f);
    _301 = mad(_297, 0.03889999911189079f, 0.0f);
    _302 = mad(_297, -0.06849999725818634f, 0.0f);
    _303 = mad(_297, 1.0296000242233276f, 0.0f);
    _306 = mad(0.1599626988172531f, _301, mad(-0.1470542997121811f, _298, (_295 * 0.883457362651825f)));
    _309 = mad(0.1599626988172531f, _302, mad(-0.1470542997121811f, _299, (_295 * 0.26293492317199707f)));
    _312 = mad(0.1599626988172531f, _303, mad(-0.1470542997121811f, _300, (_295 * -0.15930065512657166f)));
    _315 = mad(0.04929120093584061f, _301, mad(0.5183603167533875f, _298, (_295 * 0.38695648312568665f)));
    _318 = mad(0.04929120093584061f, _302, mad(0.5183603167533875f, _299, (_295 * 0.11516613513231277f)));
    _321 = mad(0.04929120093584061f, _303, mad(0.5183603167533875f, _300, (_295 * -0.0697740763425827f)));
    _324 = mad(0.9684867262840271f, _301, mad(0.04004279896616936f, _298, (_295 * -0.007634039502590895f)));
    _327 = mad(0.9684867262840271f, _302, mad(0.04004279896616936f, _299, (_295 * -0.0022720457054674625f)));
    _330 = mad(0.9684867262840271f, _303, mad(0.04004279896616936f, _300, (_295 * 0.0013765322510153055f)));
    _333 = mad(_312, (WorkingColorSpace_000[2].x), mad(_309, (WorkingColorSpace_000[1].x), (_306 * (WorkingColorSpace_000[0].x))));
    _336 = mad(_312, (WorkingColorSpace_000[2].y), mad(_309, (WorkingColorSpace_000[1].y), (_306 * (WorkingColorSpace_000[0].y))));
    _339 = mad(_312, (WorkingColorSpace_000[2].z), mad(_309, (WorkingColorSpace_000[1].z), (_306 * (WorkingColorSpace_000[0].z))));
    _342 = mad(_321, (WorkingColorSpace_000[2].x), mad(_318, (WorkingColorSpace_000[1].x), (_315 * (WorkingColorSpace_000[0].x))));
    _345 = mad(_321, (WorkingColorSpace_000[2].y), mad(_318, (WorkingColorSpace_000[1].y), (_315 * (WorkingColorSpace_000[0].y))));
    _348 = mad(_321, (WorkingColorSpace_000[2].z), mad(_318, (WorkingColorSpace_000[1].z), (_315 * (WorkingColorSpace_000[0].z))));
    _351 = mad(_330, (WorkingColorSpace_000[2].x), mad(_327, (WorkingColorSpace_000[1].x), (_324 * (WorkingColorSpace_000[0].x))));
    _354 = mad(_330, (WorkingColorSpace_000[2].y), mad(_327, (WorkingColorSpace_000[1].y), (_324 * (WorkingColorSpace_000[0].y))));
    _357 = mad(_330, (WorkingColorSpace_000[2].z), mad(_327, (WorkingColorSpace_000[1].z), (_324 * (WorkingColorSpace_000[0].z))));
    _395 = mad(mad((WorkingColorSpace_064[0].z), _357, mad((WorkingColorSpace_064[0].y), _348, (_339 * (WorkingColorSpace_064[0].x)))), _133, mad(mad((WorkingColorSpace_064[0].z), _354, mad((WorkingColorSpace_064[0].y), _345, (_336 * (WorkingColorSpace_064[0].x)))), _132, (mad((WorkingColorSpace_064[0].z), _351, mad((WorkingColorSpace_064[0].y), _342, (_333 * (WorkingColorSpace_064[0].x)))) * _131)));
    _396 = mad(mad((WorkingColorSpace_064[1].z), _357, mad((WorkingColorSpace_064[1].y), _348, (_339 * (WorkingColorSpace_064[1].x)))), _133, mad(mad((WorkingColorSpace_064[1].z), _354, mad((WorkingColorSpace_064[1].y), _345, (_336 * (WorkingColorSpace_064[1].x)))), _132, (mad((WorkingColorSpace_064[1].z), _351, mad((WorkingColorSpace_064[1].y), _342, (_333 * (WorkingColorSpace_064[1].x)))) * _131)));
    _397 = mad(mad((WorkingColorSpace_064[2].z), _357, mad((WorkingColorSpace_064[2].y), _348, (_339 * (WorkingColorSpace_064[2].x)))), _133, mad(mad((WorkingColorSpace_064[2].z), _354, mad((WorkingColorSpace_064[2].y), _345, (_336 * (WorkingColorSpace_064[2].x)))), _132, (mad((WorkingColorSpace_064[2].z), _351, mad((WorkingColorSpace_064[2].y), _342, (_333 * (WorkingColorSpace_064[2].x)))) * _131)));
  } else {
    _395 = _131;
    _396 = _132;
    _397 = _133;
  }
  _412 = mad((WorkingColorSpace_128[0].z), _397, mad((WorkingColorSpace_128[0].y), _396, ((WorkingColorSpace_128[0].x) * _395)));
  _415 = mad((WorkingColorSpace_128[1].z), _397, mad((WorkingColorSpace_128[1].y), _396, ((WorkingColorSpace_128[1].x) * _395)));
  _418 = mad((WorkingColorSpace_128[2].z), _397, mad((WorkingColorSpace_128[2].y), _396, ((WorkingColorSpace_128[2].x) * _395)));
  _419 = dot(float3(_412, _415, _418), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _423 = (_412 / _419) + -1.0f;
  _424 = (_415 / _419) + -1.0f;
  _425 = (_418 / _419) + -1.0f;
  _437 = (1.0f - exp2(((_419 * _419) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_423, _424, _425), float3(_423, _424, _425)) * -4.0f));
  _453 = ((mad(-0.06368321925401688f, _418, mad(-0.3292922377586365f, _415, (_412 * 1.3704125881195068f))) - _412) * _437) + _412;
  _454 = ((mad(-0.010861365124583244f, _418, mad(1.0970927476882935f, _415, (_412 * -0.08343357592821121f))) - _415) * _437) + _415;
  _455 = ((mad(1.2036951780319214f, _418, mad(-0.09862580895423889f, _415, (_412 * -0.02579331398010254f))) - _418) * _437) + _418;
  _456 = dot(float3(_453, _454, _455), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _470 = cb0_021w + cb0_026w;
  _484 = cb0_020w * cb0_025w;
  _498 = cb0_019w * cb0_024w;
  _512 = cb0_018w * cb0_023w;
  _526 = cb0_017w * cb0_022w;
  _530 = _453 - _456;
  _531 = _454 - _456;
  _532 = _455 - _456;
  _589 = saturate(_456 / cb0_037w);
  _593 = (_589 * _589) * (3.0f - (_589 * 2.0f));
  _594 = 1.0f - _593;
  _603 = cb0_021w + cb0_036w;
  _612 = cb0_020w * cb0_035w;
  _621 = cb0_019w * cb0_034w;
  _630 = cb0_018w * cb0_033w;
  _639 = cb0_017w * cb0_032w;
  _702 = saturate((_456 - cb0_038x) / (cb0_038y - cb0_038x));
  _706 = (_702 * _702) * (3.0f - (_702 * 2.0f));
  _715 = cb0_021w + cb0_031w;
  _724 = cb0_020w * cb0_030w;
  _733 = cb0_019w * cb0_029w;
  _742 = cb0_018w * cb0_028w;
  _751 = cb0_017w * cb0_027w;
  _809 = _593 - _706;
  _820 = ((_706 * (((cb0_021x + cb0_036x) + _603) + (((cb0_020x * cb0_035x) * _612) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _630) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _639) * _530) + _456)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _621)))))) + (_594 * (((cb0_021x + cb0_026x) + _470) + (((cb0_020x * cb0_025x) * _484) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _512) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _526) * _530) + _456)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _498))))))) + ((((cb0_021x + cb0_031x) + _715) + (((cb0_020x * cb0_030x) * _724) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _742) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _751) * _530) + _456)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _733))))) * _809);
  _822 = ((_706 * (((cb0_021y + cb0_036y) + _603) + (((cb0_020y * cb0_035y) * _612) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _630) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _639) * _531) + _456)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _621)))))) + (_594 * (((cb0_021y + cb0_026y) + _470) + (((cb0_020y * cb0_025y) * _484) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _512) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _526) * _531) + _456)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _498))))))) + ((((cb0_021y + cb0_031y) + _715) + (((cb0_020y * cb0_030y) * _724) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _742) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _751) * _531) + _456)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _733))))) * _809);
  _824 = ((_706 * (((cb0_021z + cb0_036z) + _603) + (((cb0_020z * cb0_035z) * _612) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _630) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _639) * _532) + _456)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _621)))))) + (_594 * (((cb0_021z + cb0_026z) + _470) + (((cb0_020z * cb0_025z) * _484) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _512) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _526) * _532) + _456)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _498))))))) + ((((cb0_021z + cb0_031z) + _715) + (((cb0_020z * cb0_030z) * _724) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _742) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _751) * _532) + _456)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _733))))) * _809);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;
  float4 output = ProcessLutbuilder(float3(_820, _822, _824), s0, s1, s2, t0, t1, t2, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _860 = ((mad(0.061360642313957214f, _824, mad(-4.540197551250458e-09f, _822, (_820 * 0.9386394023895264f))) - _820) * cb0_038z) + _820;
  _861 = ((mad(0.169205904006958f, _824, mad(0.8307942152023315f, _822, (_820 * 6.775371730327606e-08f))) - _822) * cb0_038z) + _822;
  _862 = (mad(-2.3283064365386963e-10f, _822, (_820 * -9.313225746154785e-10f)) * cb0_038z) + _824;
  _865 = mad(0.16386905312538147f, _862, mad(0.14067868888378143f, _861, (_860 * 0.6954522132873535f)));
  _868 = mad(0.0955343246459961f, _862, mad(0.8596711158752441f, _861, (_860 * 0.044794581830501556f)));
  _871 = mad(1.0015007257461548f, _862, mad(0.004025210160762072f, _861, (_860 * -0.005525882821530104f)));
  _875 = max(max(_865, _868), _871);
  _880 = (max(_875, 1.000000013351432e-10f) - max(min(min(_865, _868), _871), 1.000000013351432e-10f)) / max(_875, 0.009999999776482582f);
  _893 = ((_868 + _865) + _871) + (sqrt((((_871 - _868) * _871) + ((_868 - _865) * _868)) + ((_865 - _871) * _865)) * 1.75f);
  _894 = _893 * 0.3333333432674408f;
  _895 = _880 + -0.4000000059604645f;
  _896 = _895 * 5.0f;
  _900 = max((1.0f - abs(_895 * 2.5f)), 0.0f);
  _911 = ((float((int)(((int)(uint)((int)(_896 > 0.0f))) - ((int)(uint)((int)(_896 < 0.0f))))) * (1.0f - (_900 * _900))) + 1.0f) * 0.02500000037252903f;
  if (_894 > 0.0533333346247673f) {
    if (_894 < 0.1599999964237213f) {
      _920 = (((0.23999999463558197f / _893) + -0.5f) * _911);
    } else {
      _920 = 0.0f;
    }
  } else {
    _920 = _911;
  }
  _921 = _920 + 1.0f;
  _922 = _921 * _865;
  _923 = _921 * _868;
  _924 = _921 * _871;
  if (!((_922 == _923) && (_923 == _924))) {
    _931 = ((_922 * 2.0f) - _923) - _924;
    _934 = ((_868 - _871) * 1.7320507764816284f) * _921;
    _936 = atan(_934 / _931);
    _939 = (_931 < 0.0f);
    _940 = (_931 == 0.0f);
    _941 = (_934 >= 0.0f);
    _942 = (_934 < 0.0f);
    _953 = select((_941 && _940), 90.0f, select((_942 && _940), -90.0f, (select((_942 && _939), (_936 + -3.1415927410125732f), select((_941 && _939), (_936 + 3.1415927410125732f), _936)) * 57.2957763671875f)));
  } else {
    _953 = 0.0f;
  }
  _958 = min(max(select((_953 < 0.0f), (_953 + 360.0f), _953), 0.0f), 360.0f);
  if (_958 < -180.0f) {
    _967 = (_958 + 360.0f);
  } else {
    if (_958 > 180.0f) {
      _967 = (_958 + -360.0f);
    } else {
      _967 = _958;
    }
  }
  _971 = saturate(1.0f - abs(_967 * 0.014814814552664757f));
  _975 = (_971 * _971) * (3.0f - (_971 * 2.0f));
  _981 = ((_975 * _975) * ((_880 * 0.18000000715255737f) * (0.029999999329447746f - _922))) + _922;
  _991 = max(0.0f, mad(-0.21492856740951538f, _924, mad(-0.2365107536315918f, _923, (_981 * 1.4514392614364624f))));
  _992 = max(0.0f, mad(-0.09967592358589172f, _924, mad(1.17622971534729f, _923, (_981 * -0.07655377686023712f))));
  _993 = max(0.0f, mad(0.9977163076400757f, _924, mad(-0.006032449658960104f, _923, (_981 * 0.008316148072481155f))));
  _994 = dot(float3(_991, _992, _993), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1009 = (cb0_040x + 1.0f) - cb0_039z;
  _1011 = cb0_040y + 1.0f;
  _1013 = _1011 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1031 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1022 = (cb0_040x + 0.18000000715255737f) / _1009;
    _1031 = (-0.7447274923324585f - ((log2(_1022 / (2.0f - _1022)) * 0.3465735912322998f) * (_1009 / cb0_039y)));
  }
  _1034 = ((1.0f - cb0_039z) / cb0_039y) - _1031;
  _1036 = (cb0_039w / cb0_039y) - _1034;
  _1040 = log2(lerp(_994, _991, 0.9599999785423279f)) * 0.3010300099849701f;
  _1041 = log2(lerp(_994, _992, 0.9599999785423279f)) * 0.3010300099849701f;
  _1042 = log2(lerp(_994, _993, 0.9599999785423279f)) * 0.3010300099849701f;
  _1046 = cb0_039y * (_1040 + _1034);
  _1047 = cb0_039y * (_1041 + _1034);
  _1048 = cb0_039y * (_1042 + _1034);
  _1049 = _1009 * 2.0f;
  _1051 = (cb0_039y * -2.0f) / _1009;
  _1052 = _1040 - _1031;
  _1053 = _1041 - _1031;
  _1054 = _1042 - _1031;
  _1073 = _1013 * 2.0f;
  _1075 = (cb0_039y * 2.0f) / _1013;
  _1100 = select((_1040 < _1031), ((_1049 / (exp2((_1052 * 1.4426950216293335f) * _1051) + 1.0f)) - cb0_040x), _1046);
  _1101 = select((_1041 < _1031), ((_1049 / (exp2((_1053 * 1.4426950216293335f) * _1051) + 1.0f)) - cb0_040x), _1047);
  _1102 = select((_1042 < _1031), ((_1049 / (exp2((_1054 * 1.4426950216293335f) * _1051) + 1.0f)) - cb0_040x), _1048);
  _1109 = _1036 - _1031;
  _1113 = saturate(_1052 / _1109);
  _1114 = saturate(_1053 / _1109);
  _1115 = saturate(_1054 / _1109);
  _1116 = (_1036 < _1031);
  _1120 = select(_1116, (1.0f - _1113), _1113);
  _1121 = select(_1116, (1.0f - _1114), _1114);
  _1122 = select(_1116, (1.0f - _1115), _1115);
  _1141 = (((_1120 * _1120) * (select((_1040 > _1036), (_1011 - (_1073 / (exp2(((_1040 - _1036) * 1.4426950216293335f) * _1075) + 1.0f))), _1046) - _1100)) * (3.0f - (_1120 * 2.0f))) + _1100;
  _1142 = (((_1121 * _1121) * (select((_1041 > _1036), (_1011 - (_1073 / (exp2(((_1041 - _1036) * 1.4426950216293335f) * _1075) + 1.0f))), _1047) - _1101)) * (3.0f - (_1121 * 2.0f))) + _1101;
  _1143 = (((_1122 * _1122) * (select((_1042 > _1036), (_1011 - (_1073 / (exp2(((_1042 - _1036) * 1.4426950216293335f) * _1075) + 1.0f))), _1048) - _1102)) * (3.0f - (_1122 * 2.0f))) + _1102;
  _1144 = dot(float3(_1141, _1142, _1143), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1164 = (cb0_039x * (max(0.0f, (lerp(_1144, _1141, 0.9300000071525574f))) - _860)) + _860;
  _1165 = (cb0_039x * (max(0.0f, (lerp(_1144, _1142, 0.9300000071525574f))) - _861)) + _861;
  _1166 = (cb0_039x * (max(0.0f, (lerp(_1144, _1143, 0.9300000071525574f))) - _862)) + _862;
  _1182 = ((mad(-0.06537103652954102f, _1166, mad(1.451815478503704e-06f, _1165, (_1164 * 1.065374732017517f))) - _1164) * cb0_038z) + _1164;
  _1183 = ((mad(-0.20366770029067993f, _1166, mad(1.2036634683609009f, _1165, (_1164 * -2.57161445915699e-07f))) - _1165) * cb0_038z) + _1165;
  _1184 = ((mad(0.9999996423721313f, _1166, mad(2.0954757928848267e-08f, _1165, (_1164 * 1.862645149230957e-08f))) - _1166) * cb0_038z) + _1166;
  _1197 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1184, mad((WorkingColorSpace_192[0].y), _1183, ((WorkingColorSpace_192[0].x) * _1182)))));
  _1198 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1184, mad((WorkingColorSpace_192[1].y), _1183, ((WorkingColorSpace_192[1].x) * _1182)))));
  _1199 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1184, mad((WorkingColorSpace_192[2].y), _1183, ((WorkingColorSpace_192[2].x) * _1182)))));
  if (_1197 < 0.0031306699384003878f) {
    _1210 = (_1197 * 12.920000076293945f);
  } else {
    _1210 = (((pow(_1197, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1198 < 0.0031306699384003878f) {
    _1221 = (_1198 * 12.920000076293945f);
  } else {
    _1221 = (((pow(_1198, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1199 < 0.0031306699384003878f) {
    _1232 = (_1199 * 12.920000076293945f);
  } else {
    _1232 = (((pow(_1199, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1236 = (_1221 * 0.9375f) + 0.03125f;
  _1243 = _1232 * 15.0f;
  _1244 = floor(_1243);
  _1245 = _1243 - _1244;
  _1247 = (_1244 + ((_1210 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1250 = t0.SampleLevel(s0, float2(_1247, _1236), 0.0f);
  _1254 = _1247 + 0.0625f;
  _1255 = t0.SampleLevel(s0, float2(_1254, _1236), 0.0f);
  _1277 = t1.SampleLevel(s1, float2(_1247, _1236), 0.0f);
  _1281 = t1.SampleLevel(s1, float2(_1254, _1236), 0.0f);
  _1303 = t2.SampleLevel(s2, float2(_1247, _1236), 0.0f);
  _1307 = t2.SampleLevel(s2, float2(_1254, _1236), 0.0f);
  _1323 = ((((lerp(_1250.x, _1255.x, _1245)) * cb0_005y) + (cb0_005x * _1210)) + ((lerp(_1277.x, _1281.x, _1245)) * cb0_005z)) + ((lerp(_1303.x, _1307.x, _1245)) * cb0_005w);
  _1324 = ((((lerp(_1250.y, _1255.y, _1245)) * cb0_005y) + (cb0_005x * _1221)) + ((lerp(_1277.y, _1281.y, _1245)) * cb0_005z)) + ((lerp(_1303.y, _1307.y, _1245)) * cb0_005w);
  _1325 = ((((lerp(_1250.z, _1255.z, _1245)) * cb0_005y) + (cb0_005x * _1232)) + ((lerp(_1277.z, _1281.z, _1245)) * cb0_005z)) + ((lerp(_1303.z, _1307.z, _1245)) * cb0_005w);
  _1350 = select((_1323 > 0.040449999272823334f), exp2(log2((abs(_1323) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1323 * 0.07739938050508499f));
  _1351 = select((_1324 > 0.040449999272823334f), exp2(log2((abs(_1324) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1324 * 0.07739938050508499f));
  _1352 = select((_1325 > 0.040449999272823334f), exp2(log2((abs(_1325) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1325 * 0.07739938050508499f));
  _1378 = cb0_016x * (((cb0_041y + (cb0_041x * _1350)) * _1350) + cb0_041z);
  _1379 = cb0_016y * (((cb0_041y + (cb0_041x * _1351)) * _1351) + cb0_041z);
  _1380 = cb0_016z * (((cb0_041y + (cb0_041x * _1352)) * _1352) + cb0_041z);
  _1387 = ((cb0_015x - _1378) * cb0_015w) + _1378;
  _1388 = ((cb0_015y - _1379) * cb0_015w) + _1379;
  _1389 = ((cb0_015z - _1380) * cb0_015w) + _1380;
  _1390 = cb0_016x * mad((WorkingColorSpace_192[0].z), _824, mad((WorkingColorSpace_192[0].y), _822, (_820 * (WorkingColorSpace_192[0].x))));
  _1391 = cb0_016y * mad((WorkingColorSpace_192[1].z), _824, mad((WorkingColorSpace_192[1].y), _822, ((WorkingColorSpace_192[1].x) * _820)));
  _1392 = cb0_016z * mad((WorkingColorSpace_192[2].z), _824, mad((WorkingColorSpace_192[2].y), _822, ((WorkingColorSpace_192[2].x) * _820)));
  _1399 = ((cb0_015x - _1390) * cb0_015w) + _1390;
  _1400 = ((cb0_015y - _1391) * cb0_015w) + _1391;
  _1401 = ((cb0_015z - _1392) * cb0_015w) + _1392;
  _1413 = exp2(log2(max(0.0f, _1387)) * cb0_042y);
  _1414 = exp2(log2(max(0.0f, _1388)) * cb0_042y);
  _1415 = exp2(log2(max(0.0f, _1389)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1438 = mad((WorkingColorSpace_128[0].z), _1415, mad((WorkingColorSpace_128[0].y), _1414, ((WorkingColorSpace_128[0].x) * _1413)));
      _1441 = mad((WorkingColorSpace_128[1].z), _1415, mad((WorkingColorSpace_128[1].y), _1414, ((WorkingColorSpace_128[1].x) * _1413)));
      _1444 = mad((WorkingColorSpace_128[2].z), _1415, mad((WorkingColorSpace_128[2].y), _1414, ((WorkingColorSpace_128[2].x) * _1413)));
      _1455 = mad(_67, _1444, mad(_66, _1441, (_1438 * _65)));
      _1456 = mad(_70, _1444, mad(_69, _1441, (_1438 * _68)));
      _1457 = mad(_73, _1444, mad(_72, _1441, (_1438 * _71)));
    } else {
      _1455 = _1413;
      _1456 = _1414;
      _1457 = _1415;
    }
    if (_1455 < 0.0031306699384003878f) {
      _1468 = (_1455 * 12.920000076293945f);
    } else {
      _1468 = (((pow(_1455, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1456 < 0.0031306699384003878f) {
      _1479 = (_1456 * 12.920000076293945f);
    } else {
      _1479 = (((pow(_1456, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1457 < 0.0031306699384003878f) {
      _3018 = _1468;
      _3019 = _1479;
      _3020 = (_1457 * 12.920000076293945f);
    } else {
      _3018 = _1468;
      _3019 = _1479;
      _3020 = (((pow(_1457, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1506 = mad((WorkingColorSpace_128[0].z), _1415, mad((WorkingColorSpace_128[0].y), _1414, ((WorkingColorSpace_128[0].x) * _1413)));
      _1509 = mad((WorkingColorSpace_128[1].z), _1415, mad((WorkingColorSpace_128[1].y), _1414, ((WorkingColorSpace_128[1].x) * _1413)));
      _1512 = mad((WorkingColorSpace_128[2].z), _1415, mad((WorkingColorSpace_128[2].y), _1414, ((WorkingColorSpace_128[2].x) * _1413)));
      _1515 = mad(_67, _1512, mad(_66, _1509, (_1506 * _65)));
      _1518 = mad(_70, _1512, mad(_69, _1509, (_1506 * _68)));
      _1521 = mad(_73, _1512, mad(_72, _1509, (_1506 * _71)));
      _3018 = min((_1515 * 4.5f), ((exp2(log2(max(_1515, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3019 = min((_1518 * 4.5f), ((exp2(log2(max(_1518, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3020 = min((_1521 * 4.5f), ((exp2(log2(max(_1521, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
        _17[0] = cb0_010x;
        _17[1] = cb0_010y;
        _17[2] = cb0_010z;
        _17[3] = cb0_010w;
        _17[4] = cb0_012x;
        _17[5] = cb0_012x;
        _18[0] = cb0_011x;
        _18[1] = cb0_011y;
        _18[2] = cb0_011z;
        _18[3] = cb0_011w;
        _18[4] = cb0_012y;
        _18[5] = cb0_012y;
        _1596 = cb0_012z * _1399;
        _1597 = cb0_012z * _1400;
        _1598 = cb0_012z * _1401;
        _1601 = mad((WorkingColorSpace_256[0].z), _1598, mad((WorkingColorSpace_256[0].y), _1597, ((WorkingColorSpace_256[0].x) * _1596)));
        _1604 = mad((WorkingColorSpace_256[1].z), _1598, mad((WorkingColorSpace_256[1].y), _1597, ((WorkingColorSpace_256[1].x) * _1596)));
        _1607 = mad((WorkingColorSpace_256[2].z), _1598, mad((WorkingColorSpace_256[2].y), _1597, ((WorkingColorSpace_256[2].x) * _1596)));
        _1610 = mad(-0.21492856740951538f, _1607, mad(-0.2365107536315918f, _1604, (_1601 * 1.4514392614364624f)));
        _1613 = mad(-0.09967592358589172f, _1607, mad(1.17622971534729f, _1604, (_1601 * -0.07655377686023712f)));
        _1616 = mad(0.9977163076400757f, _1607, mad(-0.006032449658960104f, _1604, (_1601 * 0.008316148072481155f)));
        _1618 = max(_1610, max(_1613, _1616));
        if (!(_1618 < 1.000000013351432e-10f)) {
          if (!(((_1601 < 0.0f) || (_1604 < 0.0f)) || (_1607 < 0.0f))) {
            _1628 = abs(_1618);
            _1629 = (_1618 - _1610) / _1628;
            _1631 = (_1618 - _1613) / _1628;
            _1633 = (_1618 - _1616) / _1628;
            if (!(_1629 < 0.8149999976158142f)) {
              _1636 = _1629 + -0.8149999976158142f;
              _1648 = ((_1636 / exp2(log2(exp2(log2(_1636 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1648 = _1629;
            }
            if (!(_1631 < 0.8029999732971191f)) {
              _1651 = _1631 + -0.8029999732971191f;
              _1663 = ((_1651 / exp2(log2(exp2(log2(_1651 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1663 = _1631;
            }
            if (!(_1633 < 0.8799999952316284f)) {
              _1666 = _1633 + -0.8799999952316284f;
              _1678 = ((_1666 / exp2(log2(exp2(log2(_1666 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1678 = _1633;
            }
            _1686 = (_1618 - (_1628 * _1648));
            _1687 = (_1618 - (_1628 * _1663));
            _1688 = (_1618 - (_1628 * _1678));
          } else {
            _1686 = _1610;
            _1687 = _1613;
            _1688 = _1616;
          }
        } else {
          _1686 = _1610;
          _1687 = _1613;
          _1688 = _1616;
        }
        _1704 = ((mad(0.16386906802654266f, _1688, mad(0.14067870378494263f, _1687, (_1686 * 0.6954522132873535f))) - _1601) * cb0_012w) + _1601;
        _1705 = ((mad(0.0955343171954155f, _1688, mad(0.8596711158752441f, _1687, (_1686 * 0.044794563204050064f))) - _1604) * cb0_012w) + _1604;
        _1706 = ((mad(1.0015007257461548f, _1688, mad(0.004025210160762072f, _1687, (_1686 * -0.005525882821530104f))) - _1607) * cb0_012w) + _1607;
        _1710 = max(max(_1704, _1705), _1706);
        _1715 = (max(_1710, 1.000000013351432e-10f) - max(min(min(_1704, _1705), _1706), 1.000000013351432e-10f)) / max(_1710, 0.009999999776482582f);
        _1728 = ((_1705 + _1704) + _1706) + (sqrt((((_1706 - _1705) * _1706) + ((_1705 - _1704) * _1705)) + ((_1704 - _1706) * _1704)) * 1.75f);
        _1729 = _1728 * 0.3333333432674408f;
        _1730 = _1715 + -0.4000000059604645f;
        _1731 = _1730 * 5.0f;
        _1735 = max((1.0f - abs(_1730 * 2.5f)), 0.0f);
        _1746 = ((float((int)(((int)(uint)((int)(_1731 > 0.0f))) - ((int)(uint)((int)(_1731 < 0.0f))))) * (1.0f - (_1735 * _1735))) + 1.0f) * 0.02500000037252903f;
        if (_1729 > 0.0533333346247673f) {
          if (_1729 < 0.1599999964237213f) {
            _1755 = (((0.23999999463558197f / _1728) + -0.5f) * _1746);
          } else {
            _1755 = 0.0f;
          }
        } else {
          _1755 = _1746;
        }
        _1756 = _1755 + 1.0f;
        _1757 = _1756 * _1704;
        _1758 = _1756 * _1705;
        _1759 = _1756 * _1706;
        if (!((_1757 == _1758) && (_1758 == _1759))) {
          _1766 = ((_1757 * 2.0f) - _1758) - _1759;
          _1769 = ((_1705 - _1706) * 1.7320507764816284f) * _1756;
          _1771 = atan(_1769 / _1766);
          _1774 = (_1766 < 0.0f);
          _1775 = (_1766 == 0.0f);
          _1776 = (_1769 >= 0.0f);
          _1777 = (_1769 < 0.0f);
          _1788 = select((_1776 && _1775), 90.0f, select((_1777 && _1775), -90.0f, (select((_1777 && _1774), (_1771 + -3.1415927410125732f), select((_1776 && _1774), (_1771 + 3.1415927410125732f), _1771)) * 57.2957763671875f)));
        } else {
          _1788 = 0.0f;
        }
        _1793 = min(max(select((_1788 < 0.0f), (_1788 + 360.0f), _1788), 0.0f), 360.0f);
        if (_1793 < -180.0f) {
          _1802 = (_1793 + 360.0f);
        } else {
          if (_1793 > 180.0f) {
            _1802 = (_1793 + -360.0f);
          } else {
            _1802 = _1793;
          }
        }
        if ((_1802 > -67.5f) && (_1802 < 67.5f)) {
          _1808 = (_1802 + 67.5f) * 0.029629629105329514f;
          _1809 = int(_1808);
          _1811 = _1808 - float((int)(_1809));
          _1812 = _1811 * _1811;
          _1813 = _1812 * _1811;
          if (_1809 == 3) {
            _1841 = (((0.1666666716337204f - (_1811 * 0.5f)) + (_1812 * 0.5f)) - (_1813 * 0.1666666716337204f));
          } else {
            if (_1809 == 2) {
              _1841 = ((0.6666666865348816f - _1812) + (_1813 * 0.5f));
            } else {
              if (_1809 == 1) {
                _1841 = (((_1813 * -0.5f) + 0.1666666716337204f) + ((_1812 + _1811) * 0.5f));
              } else {
                _1841 = select((_1809 == 0), (_1813 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1841 = 0.0f;
        }
        _1850 = min(max(((((_1715 * 0.27000001072883606f) * (0.029999999329447746f - _1757)) * _1841) + _1757), 0.0f), 65535.0f);
        _1851 = min(max(_1758, 0.0f), 65535.0f);
        _1852 = min(max(_1759, 0.0f), 65535.0f);
        _1865 = min(max(mad(-0.21492856740951538f, _1852, mad(-0.2365107536315918f, _1851, (_1850 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1866 = min(max(mad(-0.09967592358589172f, _1852, mad(1.17622971534729f, _1851, (_1850 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1867 = min(max(mad(0.9977163076400757f, _1852, mad(-0.006032449658960104f, _1851, (_1850 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1868 = dot(float3(_1865, _1866, _1867), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        _23[0] = cb0_010x;
        _23[1] = cb0_010y;
        _23[2] = cb0_010z;
        _23[3] = cb0_010w;
        _23[4] = cb0_012x;
        _23[5] = cb0_012x;
        _24[0] = cb0_011x;
        _24[1] = cb0_011y;
        _24[2] = cb0_011z;
        _24[3] = cb0_011w;
        _24[4] = cb0_012y;
        _24[5] = cb0_012y;
        _1891 = log2(max((lerp(_1868, _1865, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1892 = _1891 * 0.3010300099849701f;
        _1893 = log2(cb0_008x);
        _1894 = _1893 * 0.3010300099849701f;
        if (_1892 > _1894) {
          _1901 = log2(cb0_009x);
          _1902 = _1901 * 0.3010300099849701f;
          if ((_1892 > _1894) && (_1892 < _1902)) {
            _1910 = ((_1891 - _1893) * 0.9030900001525879f) / ((_1901 - _1893) * 0.3010300099849701f);
            _1911 = int(_1910);
            _1913 = _1910 - float((int)(_1911));
            _1915 = _23[min((uint)(_1911), 5u)];
            _1918 = _23[min((uint)((_1911 + 1)), 5u)];
            _1923 = _1915 * 0.5f;
            _1963 = dot(float3((_1913 * _1913), _1913, 1.0f), float3(mad((_23[min((uint)((_1911 + 2)), 5u)]), 0.5f, mad(_1918, -1.0f, _1923)), (_1918 - _1915), mad(_1918, 0.5f, _1923)));
          } else {
            if (_1892 < _1902) {
              _1963 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1932 = log2(cb0_008z);
              if (!(_1892 < (_1932 * 0.3010300099849701f))) {
                _1963 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1940 = ((_1891 - _1901) * 0.9030900001525879f) / ((_1932 - _1901) * 0.3010300099849701f);
                _1941 = int(_1940);
                _1943 = _1940 - float((int)(_1941));
                _1945 = _24[min((uint)(_1941), 5u)];
                _1948 = _24[min((uint)((_1941 + 1)), 5u)];
                _1953 = _1945 * 0.5f;
                _1963 = dot(float3((_1943 * _1943), _1943, 1.0f), float3(mad((_24[min((uint)((_1941 + 2)), 5u)]), 0.5f, mad(_1948, -1.0f, _1953)), (_1948 - _1945), mad(_1948, 0.5f, _1953)));
              }
            }
          }
        } else {
          _1963 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1967 = log2(max((lerp(_1868, _1866, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1968 = _1967 * 0.3010300099849701f;
        if (_1968 > _1894) {
          _1975 = log2(cb0_009x);
          _1976 = _1975 * 0.3010300099849701f;
          if ((_1968 > _1894) && (_1968 < _1976)) {
            _1984 = ((_1967 - _1893) * 0.9030900001525879f) / ((_1975 - _1893) * 0.3010300099849701f);
            _1985 = int(_1984);
            _1987 = _1984 - float((int)(_1985));
            _1989 = _17[min((uint)(_1985), 5u)];
            _1992 = _17[min((uint)((_1985 + 1)), 5u)];
            _1997 = _1989 * 0.5f;
            _2037 = dot(float3((_1987 * _1987), _1987, 1.0f), float3(mad((_17[min((uint)((_1985 + 2)), 5u)]), 0.5f, mad(_1992, -1.0f, _1997)), (_1992 - _1989), mad(_1992, 0.5f, _1997)));
          } else {
            if (_1968 < _1976) {
              _2037 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _2006 = log2(cb0_008z);
              if (!(_1968 < (_2006 * 0.3010300099849701f))) {
                _2037 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2014 = ((_1967 - _1975) * 0.9030900001525879f) / ((_2006 - _1975) * 0.3010300099849701f);
                _2015 = int(_2014);
                _2017 = _2014 - float((int)(_2015));
                _2019 = _18[min((uint)(_2015), 5u)];
                _2022 = _18[min((uint)((_2015 + 1)), 5u)];
                _2027 = _2019 * 0.5f;
                _2037 = dot(float3((_2017 * _2017), _2017, 1.0f), float3(mad((_18[min((uint)((_2015 + 2)), 5u)]), 0.5f, mad(_2022, -1.0f, _2027)), (_2022 - _2019), mad(_2022, 0.5f, _2027)));
              }
            }
          }
        } else {
          _2037 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2041 = log2(max((lerp(_1868, _1867, 0.9599999785423279f)), 1.000000013351432e-10f));
        _2042 = _2041 * 0.3010300099849701f;
        if (_2042 > _1894) {
          _2049 = log2(cb0_009x);
          _2050 = _2049 * 0.3010300099849701f;
          if ((_2042 > _1894) && (_2042 < _2050)) {
            _2058 = ((_2041 - _1893) * 0.9030900001525879f) / ((_2049 - _1893) * 0.3010300099849701f);
            _2059 = int(_2058);
            _2061 = _2058 - float((int)(_2059));
            _2063 = _17[min((uint)(_2059), 5u)];
            _2066 = _17[min((uint)((_2059 + 1)), 5u)];
            _2071 = _2063 * 0.5f;
            _2111 = dot(float3((_2061 * _2061), _2061, 1.0f), float3(mad((_17[min((uint)((_2059 + 2)), 5u)]), 0.5f, mad(_2066, -1.0f, _2071)), (_2066 - _2063), mad(_2066, 0.5f, _2071)));
          } else {
            if (_2042 < _2050) {
              _2111 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _2080 = log2(cb0_008z);
              if (!(_2042 < (_2080 * 0.3010300099849701f))) {
                _2111 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2088 = ((_2041 - _2049) * 0.9030900001525879f) / ((_2080 - _2049) * 0.3010300099849701f);
                _2089 = int(_2088);
                _2091 = _2088 - float((int)(_2089));
                _2093 = _18[min((uint)(_2089), 5u)];
                _2096 = _18[min((uint)((_2089 + 1)), 5u)];
                _2101 = _2093 * 0.5f;
                _2111 = dot(float3((_2091 * _2091), _2091, 1.0f), float3(mad((_18[min((uint)((_2089 + 2)), 5u)]), 0.5f, mad(_2096, -1.0f, _2101)), (_2096 - _2093), mad(_2096, 0.5f, _2101)));
              }
            }
          }
        } else {
          _2111 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2115 = cb0_008w - cb0_008y;
        _2116 = (exp2(_1963 * 3.321928024291992f) - cb0_008y) / _2115;
        _2118 = (exp2(_2037 * 3.321928024291992f) - cb0_008y) / _2115;
        _2120 = (exp2(_2111 * 3.321928024291992f) - cb0_008y) / _2115;
        _2123 = mad(0.15618768334388733f, _2120, mad(0.13400420546531677f, _2118, (_2116 * 0.6624541878700256f)));
        _2126 = mad(0.053689517080783844f, _2120, mad(0.6740817427635193f, _2118, (_2116 * 0.2722287178039551f)));
        _2129 = mad(1.0103391408920288f, _2120, mad(0.00406073359772563f, _2118, (_2116 * -0.005574649665504694f)));
        _2142 = min(max(mad(-0.23642469942569733f, _2129, mad(-0.32480329275131226f, _2126, (_2123 * 1.6410233974456787f))), 0.0f), 1.0f);
        _2143 = min(max(mad(0.016756348311901093f, _2129, mad(1.6153316497802734f, _2126, (_2123 * -0.663662850856781f))), 0.0f), 1.0f);
        _2144 = min(max(mad(0.9883948564529419f, _2129, mad(-0.008284442126750946f, _2126, (_2123 * 0.011721894145011902f))), 0.0f), 1.0f);
        _2147 = mad(0.15618768334388733f, _2144, mad(0.13400420546531677f, _2143, (_2142 * 0.6624541878700256f)));
        _2150 = mad(0.053689517080783844f, _2144, mad(0.6740817427635193f, _2143, (_2142 * 0.2722287178039551f)));
        _2153 = mad(1.0103391408920288f, _2144, mad(0.00406073359772563f, _2143, (_2142 * -0.005574649665504694f)));
        _2175 = min(max((min(max(mad(-0.23642469942569733f, _2153, mad(-0.32480329275131226f, _2150, (_2147 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2176 = min(max((min(max(mad(0.016756348311901093f, _2153, mad(1.6153316497802734f, _2150, (_2147 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2177 = min(max((min(max(mad(0.9883948564529419f, _2153, mad(-0.008284442126750946f, _2150, (_2147 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2196 = exp2(log2(mad(_67, _2177, mad(_66, _2176, (_2175 * _65))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2197 = exp2(log2(mad(_70, _2177, mad(_69, _2176, (_2175 * _68))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2198 = exp2(log2(mad(_73, _2177, mad(_72, _2176, (_2175 * _71))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _3018 = exp2(log2((1.0f / ((_2196 * 18.6875f) + 1.0f)) * ((_2196 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _3019 = exp2(log2((1.0f / ((_2197 * 18.6875f) + 1.0f)) * ((_2197 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _3020 = exp2(log2((1.0f / ((_2198 * 18.6875f) + 1.0f)) * ((_2198 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2264 = cb0_012z * _1399;
          _2265 = cb0_012z * _1400;
          _2266 = cb0_012z * _1401;
          _2269 = mad((WorkingColorSpace_256[0].z), _2266, mad((WorkingColorSpace_256[0].y), _2265, ((WorkingColorSpace_256[0].x) * _2264)));
          _2272 = mad((WorkingColorSpace_256[1].z), _2266, mad((WorkingColorSpace_256[1].y), _2265, ((WorkingColorSpace_256[1].x) * _2264)));
          _2275 = mad((WorkingColorSpace_256[2].z), _2266, mad((WorkingColorSpace_256[2].y), _2265, ((WorkingColorSpace_256[2].x) * _2264)));
          _2278 = mad(-0.21492856740951538f, _2275, mad(-0.2365107536315918f, _2272, (_2269 * 1.4514392614364624f)));
          _2281 = mad(-0.09967592358589172f, _2275, mad(1.17622971534729f, _2272, (_2269 * -0.07655377686023712f)));
          _2284 = mad(0.9977163076400757f, _2275, mad(-0.006032449658960104f, _2272, (_2269 * 0.008316148072481155f)));
          _2286 = max(_2278, max(_2281, _2284));
          if (!(_2286 < 1.000000013351432e-10f)) {
            if (!(((_2269 < 0.0f) || (_2272 < 0.0f)) || (_2275 < 0.0f))) {
              _2296 = abs(_2286);
              _2297 = (_2286 - _2278) / _2296;
              _2299 = (_2286 - _2281) / _2296;
              _2301 = (_2286 - _2284) / _2296;
              if (!(_2297 < 0.8149999976158142f)) {
                _2304 = _2297 + -0.8149999976158142f;
                _2316 = ((_2304 / exp2(log2(exp2(log2(_2304 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _2316 = _2297;
              }
              if (!(_2299 < 0.8029999732971191f)) {
                _2319 = _2299 + -0.8029999732971191f;
                _2331 = ((_2319 / exp2(log2(exp2(log2(_2319 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _2331 = _2299;
              }
              if (!(_2301 < 0.8799999952316284f)) {
                _2334 = _2301 + -0.8799999952316284f;
                _2346 = ((_2334 / exp2(log2(exp2(log2(_2334 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2346 = _2301;
              }
              _2354 = (_2286 - (_2296 * _2316));
              _2355 = (_2286 - (_2296 * _2331));
              _2356 = (_2286 - (_2296 * _2346));
            } else {
              _2354 = _2278;
              _2355 = _2281;
              _2356 = _2284;
            }
          } else {
            _2354 = _2278;
            _2355 = _2281;
            _2356 = _2284;
          }
          _2372 = ((mad(0.16386906802654266f, _2356, mad(0.14067870378494263f, _2355, (_2354 * 0.6954522132873535f))) - _2269) * cb0_012w) + _2269;
          _2373 = ((mad(0.0955343171954155f, _2356, mad(0.8596711158752441f, _2355, (_2354 * 0.044794563204050064f))) - _2272) * cb0_012w) + _2272;
          _2374 = ((mad(1.0015007257461548f, _2356, mad(0.004025210160762072f, _2355, (_2354 * -0.005525882821530104f))) - _2275) * cb0_012w) + _2275;
          _2378 = max(max(_2372, _2373), _2374);
          _2383 = (max(_2378, 1.000000013351432e-10f) - max(min(min(_2372, _2373), _2374), 1.000000013351432e-10f)) / max(_2378, 0.009999999776482582f);
          _2396 = ((_2373 + _2372) + _2374) + (sqrt((((_2374 - _2373) * _2374) + ((_2373 - _2372) * _2373)) + ((_2372 - _2374) * _2372)) * 1.75f);
          _2397 = _2396 * 0.3333333432674408f;
          _2398 = _2383 + -0.4000000059604645f;
          _2399 = _2398 * 5.0f;
          _2403 = max((1.0f - abs(_2398 * 2.5f)), 0.0f);
          _2414 = ((float((int)(((int)(uint)((int)(_2399 > 0.0f))) - ((int)(uint)((int)(_2399 < 0.0f))))) * (1.0f - (_2403 * _2403))) + 1.0f) * 0.02500000037252903f;
          if (_2397 > 0.0533333346247673f) {
            if (_2397 < 0.1599999964237213f) {
              _2423 = (((0.23999999463558197f / _2396) + -0.5f) * _2414);
            } else {
              _2423 = 0.0f;
            }
          } else {
            _2423 = _2414;
          }
          _2424 = _2423 + 1.0f;
          _2425 = _2424 * _2372;
          _2426 = _2424 * _2373;
          _2427 = _2424 * _2374;
          if (!((_2425 == _2426) && (_2426 == _2427))) {
            _2434 = ((_2425 * 2.0f) - _2426) - _2427;
            _2437 = ((_2373 - _2374) * 1.7320507764816284f) * _2424;
            _2439 = atan(_2437 / _2434);
            _2442 = (_2434 < 0.0f);
            _2443 = (_2434 == 0.0f);
            _2444 = (_2437 >= 0.0f);
            _2445 = (_2437 < 0.0f);
            _2456 = select((_2444 && _2443), 90.0f, select((_2445 && _2443), -90.0f, (select((_2445 && _2442), (_2439 + -3.1415927410125732f), select((_2444 && _2442), (_2439 + 3.1415927410125732f), _2439)) * 57.2957763671875f)));
          } else {
            _2456 = 0.0f;
          }
          _2461 = min(max(select((_2456 < 0.0f), (_2456 + 360.0f), _2456), 0.0f), 360.0f);
          if (_2461 < -180.0f) {
            _2470 = (_2461 + 360.0f);
          } else {
            if (_2461 > 180.0f) {
              _2470 = (_2461 + -360.0f);
            } else {
              _2470 = _2461;
            }
          }
          if ((_2470 > -67.5f) && (_2470 < 67.5f)) {
            _2476 = (_2470 + 67.5f) * 0.029629629105329514f;
            _2477 = int(_2476);
            _2479 = _2476 - float((int)(_2477));
            _2480 = _2479 * _2479;
            _2481 = _2480 * _2479;
            if (_2477 == 3) {
              _2509 = (((0.1666666716337204f - (_2479 * 0.5f)) + (_2480 * 0.5f)) - (_2481 * 0.1666666716337204f));
            } else {
              if (_2477 == 2) {
                _2509 = ((0.6666666865348816f - _2480) + (_2481 * 0.5f));
              } else {
                if (_2477 == 1) {
                  _2509 = (((_2481 * -0.5f) + 0.1666666716337204f) + ((_2480 + _2479) * 0.5f));
                } else {
                  _2509 = select((_2477 == 0), (_2481 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2509 = 0.0f;
          }
          _2518 = min(max(((((_2383 * 0.27000001072883606f) * (0.029999999329447746f - _2425)) * _2509) + _2425), 0.0f), 65535.0f);
          _2519 = min(max(_2426, 0.0f), 65535.0f);
          _2520 = min(max(_2427, 0.0f), 65535.0f);
          _2533 = min(max(mad(-0.21492856740951538f, _2520, mad(-0.2365107536315918f, _2519, (_2518 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2534 = min(max(mad(-0.09967592358589172f, _2520, mad(1.17622971534729f, _2519, (_2518 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2535 = min(max(mad(0.9977163076400757f, _2520, mad(-0.006032449658960104f, _2519, (_2518 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2536 = dot(float3(_2533, _2534, _2535), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
          _21[0] = cb0_010x;
          _21[1] = cb0_010y;
          _21[2] = cb0_010z;
          _21[3] = cb0_010w;
          _21[4] = cb0_012x;
          _21[5] = cb0_012x;
          _22[0] = cb0_011x;
          _22[1] = cb0_011y;
          _22[2] = cb0_011z;
          _22[3] = cb0_011w;
          _22[4] = cb0_012y;
          _22[5] = cb0_012y;
          _2559 = log2(max((lerp(_2536, _2533, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2560 = _2559 * 0.3010300099849701f;
          _2561 = log2(cb0_008x);
          _2562 = _2561 * 0.3010300099849701f;
          if (_2560 > _2562) {
            _2569 = log2(cb0_009x);
            _2570 = _2569 * 0.3010300099849701f;
            if ((_2560 > _2562) && (_2560 < _2570)) {
              _2578 = ((_2559 - _2561) * 0.9030900001525879f) / ((_2569 - _2561) * 0.3010300099849701f);
              _2579 = int(_2578);
              _2581 = _2578 - float((int)(_2579));
              _2583 = _21[min((uint)(_2579), 5u)];
              _2586 = _21[min((uint)((_2579 + 1)), 5u)];
              _2591 = _2583 * 0.5f;
              _2631 = dot(float3((_2581 * _2581), _2581, 1.0f), float3(mad((_21[min((uint)((_2579 + 2)), 5u)]), 0.5f, mad(_2586, -1.0f, _2591)), (_2586 - _2583), mad(_2586, 0.5f, _2591)));
            } else {
              if (_2560 < _2570) {
                _2631 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2600 = log2(cb0_008z);
                if (!(_2560 < (_2600 * 0.3010300099849701f))) {
                  _2631 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2608 = ((_2559 - _2569) * 0.9030900001525879f) / ((_2600 - _2569) * 0.3010300099849701f);
                  _2609 = int(_2608);
                  _2611 = _2608 - float((int)(_2609));
                  _2613 = _22[min((uint)(_2609), 5u)];
                  _2616 = _22[min((uint)((_2609 + 1)), 5u)];
                  _2621 = _2613 * 0.5f;
                  _2631 = dot(float3((_2611 * _2611), _2611, 1.0f), float3(mad((_22[min((uint)((_2609 + 2)), 5u)]), 0.5f, mad(_2616, -1.0f, _2621)), (_2616 - _2613), mad(_2616, 0.5f, _2621)));
                }
              }
            }
          } else {
            _2631 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _15[0] = cb0_010x;
          _15[1] = cb0_010y;
          _15[2] = cb0_010z;
          _15[3] = cb0_010w;
          _15[4] = cb0_012x;
          _15[5] = cb0_012x;
          _16[0] = cb0_011x;
          _16[1] = cb0_011y;
          _16[2] = cb0_011z;
          _16[3] = cb0_011w;
          _16[4] = cb0_012y;
          _16[5] = cb0_012y;
          _2647 = log2(max((lerp(_2536, _2534, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2648 = _2647 * 0.3010300099849701f;
          if (_2648 > _2562) {
            _2655 = log2(cb0_009x);
            _2656 = _2655 * 0.3010300099849701f;
            if ((_2648 > _2562) && (_2648 < _2656)) {
              _2664 = ((_2647 - _2561) * 0.9030900001525879f) / ((_2655 - _2561) * 0.3010300099849701f);
              _2665 = int(_2664);
              _2667 = _2664 - float((int)(_2665));
              _2669 = _15[min((uint)(_2665), 5u)];
              _2672 = _15[min((uint)((_2665 + 1)), 5u)];
              _2677 = _2669 * 0.5f;
              _2717 = dot(float3((_2667 * _2667), _2667, 1.0f), float3(mad((_15[min((uint)((_2665 + 2)), 5u)]), 0.5f, mad(_2672, -1.0f, _2677)), (_2672 - _2669), mad(_2672, 0.5f, _2677)));
            } else {
              if (_2648 < _2656) {
                _2717 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2686 = log2(cb0_008z);
                if (!(_2648 < (_2686 * 0.3010300099849701f))) {
                  _2717 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2694 = ((_2647 - _2655) * 0.9030900001525879f) / ((_2686 - _2655) * 0.3010300099849701f);
                  _2695 = int(_2694);
                  _2697 = _2694 - float((int)(_2695));
                  _2699 = _16[min((uint)(_2695), 5u)];
                  _2702 = _16[min((uint)((_2695 + 1)), 5u)];
                  _2707 = _2699 * 0.5f;
                  _2717 = dot(float3((_2697 * _2697), _2697, 1.0f), float3(mad((_16[min((uint)((_2695 + 2)), 5u)]), 0.5f, mad(_2702, -1.0f, _2707)), (_2702 - _2699), mad(_2702, 0.5f, _2707)));
                }
              }
            }
          } else {
            _2717 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _19[0] = cb0_010x;
          _19[1] = cb0_010y;
          _19[2] = cb0_010z;
          _19[3] = cb0_010w;
          _19[4] = cb0_012x;
          _19[5] = cb0_012x;
          _20[0] = cb0_011x;
          _20[1] = cb0_011y;
          _20[2] = cb0_011z;
          _20[3] = cb0_011w;
          _20[4] = cb0_012y;
          _20[5] = cb0_012y;
          _2733 = log2(max((lerp(_2536, _2535, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2734 = _2733 * 0.3010300099849701f;
          if (_2734 > _2562) {
            _2741 = log2(cb0_009x);
            _2742 = _2741 * 0.3010300099849701f;
            if ((_2734 > _2562) && (_2734 < _2742)) {
              _2750 = ((_2733 - _2561) * 0.9030900001525879f) / ((_2741 - _2561) * 0.3010300099849701f);
              _2751 = int(_2750);
              _2753 = _2750 - float((int)(_2751));
              _2755 = _19[min((uint)(_2751), 5u)];
              _2758 = _19[min((uint)((_2751 + 1)), 5u)];
              _2763 = _2755 * 0.5f;
              _2803 = dot(float3((_2753 * _2753), _2753, 1.0f), float3(mad((_19[min((uint)((_2751 + 2)), 5u)]), 0.5f, mad(_2758, -1.0f, _2763)), (_2758 - _2755), mad(_2758, 0.5f, _2763)));
            } else {
              if (_2734 < _2742) {
                _2803 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2772 = log2(cb0_008z);
                if (!(_2734 < (_2772 * 0.3010300099849701f))) {
                  _2803 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2780 = ((_2733 - _2741) * 0.9030900001525879f) / ((_2772 - _2741) * 0.3010300099849701f);
                  _2781 = int(_2780);
                  _2783 = _2780 - float((int)(_2781));
                  _2785 = _20[min((uint)(_2781), 5u)];
                  _2788 = _20[min((uint)((_2781 + 1)), 5u)];
                  _2793 = _2785 * 0.5f;
                  _2803 = dot(float3((_2783 * _2783), _2783, 1.0f), float3(mad((_20[min((uint)((_2781 + 2)), 5u)]), 0.5f, mad(_2788, -1.0f, _2793)), (_2788 - _2785), mad(_2788, 0.5f, _2793)));
                }
              }
            }
          } else {
            _2803 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2807 = cb0_008w - cb0_008y;
          _2808 = (exp2(_2631 * 3.321928024291992f) - cb0_008y) / _2807;
          _2810 = (exp2(_2717 * 3.321928024291992f) - cb0_008y) / _2807;
          _2812 = (exp2(_2803 * 3.321928024291992f) - cb0_008y) / _2807;
          _2815 = mad(0.15618768334388733f, _2812, mad(0.13400420546531677f, _2810, (_2808 * 0.6624541878700256f)));
          _2818 = mad(0.053689517080783844f, _2812, mad(0.6740817427635193f, _2810, (_2808 * 0.2722287178039551f)));
          _2821 = mad(1.0103391408920288f, _2812, mad(0.00406073359772563f, _2810, (_2808 * -0.005574649665504694f)));
          _2834 = min(max(mad(-0.23642469942569733f, _2821, mad(-0.32480329275131226f, _2818, (_2815 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2835 = min(max(mad(0.016756348311901093f, _2821, mad(1.6153316497802734f, _2818, (_2815 * -0.663662850856781f))), 0.0f), 1.0f);
          _2836 = min(max(mad(0.9883948564529419f, _2821, mad(-0.008284442126750946f, _2818, (_2815 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2839 = mad(0.15618768334388733f, _2836, mad(0.13400420546531677f, _2835, (_2834 * 0.6624541878700256f)));
          _2842 = mad(0.053689517080783844f, _2836, mad(0.6740817427635193f, _2835, (_2834 * 0.2722287178039551f)));
          _2845 = mad(1.0103391408920288f, _2836, mad(0.00406073359772563f, _2835, (_2834 * -0.005574649665504694f)));
          _2867 = min(max((min(max(mad(-0.23642469942569733f, _2845, mad(-0.32480329275131226f, _2842, (_2839 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2870 = min(max((min(max(mad(0.016756348311901093f, _2845, mad(1.6153316497802734f, _2842, (_2839 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2871 = min(max((min(max(mad(0.9883948564529419f, _2845, mad(-0.008284442126750946f, _2842, (_2839 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _3018 = mad(-0.0832589864730835f, _2871, mad(-0.6217921376228333f, _2870, (_2867 * 0.0213131383061409f)));
          _3019 = mad(-0.010548308491706848f, _2871, mad(1.140804648399353f, _2870, (_2867 * -0.0016282059950754046f)));
          _3020 = mad(1.1529725790023804f, _2871, mad(-0.1289689838886261f, _2870, (_2867 * -0.00030004189466126263f)));
        } else {
          if (cb0_042w == 7) {
            _2898 = mad((WorkingColorSpace_128[0].z), _1401, mad((WorkingColorSpace_128[0].y), _1400, ((WorkingColorSpace_128[0].x) * _1399)));
            _2901 = mad((WorkingColorSpace_128[1].z), _1401, mad((WorkingColorSpace_128[1].y), _1400, ((WorkingColorSpace_128[1].x) * _1399)));
            _2904 = mad((WorkingColorSpace_128[2].z), _1401, mad((WorkingColorSpace_128[2].y), _1400, ((WorkingColorSpace_128[2].x) * _1399)));
            _2923 = exp2(log2(mad(_67, _2904, mad(_66, _2901, (_2898 * _65))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2924 = exp2(log2(mad(_70, _2904, mad(_69, _2901, (_2898 * _68))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2925 = exp2(log2(mad(_73, _2904, mad(_72, _2901, (_2898 * _71))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3018 = exp2(log2((1.0f / ((_2923 * 18.6875f) + 1.0f)) * ((_2923 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3019 = exp2(log2((1.0f / ((_2924 * 18.6875f) + 1.0f)) * ((_2924 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3020 = exp2(log2((1.0f / ((_2925 * 18.6875f) + 1.0f)) * ((_2925 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _2972 = mad((WorkingColorSpace_128[0].z), _1389, mad((WorkingColorSpace_128[0].y), _1388, ((WorkingColorSpace_128[0].x) * _1387)));
                _2975 = mad((WorkingColorSpace_128[1].z), _1389, mad((WorkingColorSpace_128[1].y), _1388, ((WorkingColorSpace_128[1].x) * _1387)));
                _2978 = mad((WorkingColorSpace_128[2].z), _1389, mad((WorkingColorSpace_128[2].y), _1388, ((WorkingColorSpace_128[2].x) * _1387)));
                _3018 = mad(_67, _2978, mad(_66, _2975, (_2972 * _65)));
                _3019 = mad(_70, _2978, mad(_69, _2975, (_2972 * _68)));
                _3020 = mad(_73, _2978, mad(_72, _2975, (_2972 * _71)));
              } else {
                _2991 = mad((WorkingColorSpace_128[0].z), _1415, mad((WorkingColorSpace_128[0].y), _1414, ((WorkingColorSpace_128[0].x) * _1413)));
                _2994 = mad((WorkingColorSpace_128[1].z), _1415, mad((WorkingColorSpace_128[1].y), _1414, ((WorkingColorSpace_128[1].x) * _1413)));
                _2997 = mad((WorkingColorSpace_128[2].z), _1415, mad((WorkingColorSpace_128[2].y), _1414, ((WorkingColorSpace_128[2].x) * _1413)));
                _3018 = exp2(log2(mad(_67, _2997, mad(_66, _2994, (_2991 * _65)))) * cb0_042z);
                _3019 = exp2(log2(mad(_70, _2997, mad(_69, _2994, (_2991 * _68)))) * cb0_042z);
                _3020 = exp2(log2(mad(_73, _2997, mad(_72, _2994, (_2991 * _71)))) * cb0_042z);
              }
            } else {
              _3018 = _1399;
              _3019 = _1400;
              _3020 = _1401;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_3018 * 0.9523810148239136f), (_3019 * 0.9523810148239136f), (_3020 * 0.9523810148239136f), 0.0f);
}
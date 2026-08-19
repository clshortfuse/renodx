// From Halo Campaign Evolved

#include "../lutbuilderoutput.hlsli"

RWTexture3D<float4> u0 : register(u0);

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
  float cb0_013x : packoffset(c013.x);
  float cb0_013y : packoffset(c013.y);
  float cb0_013z : packoffset(c013.z);
  float cb0_013w : packoffset(c013.w);
  float cb0_014x : packoffset(c014.x);
  float cb0_014y : packoffset(c014.y);
  float cb0_014z : packoffset(c014.z);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_016x : packoffset(c016.x);
  float cb0_016y : packoffset(c016.y);
  float cb0_016z : packoffset(c016.z);
  float cb0_016w : packoffset(c016.w);
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
  int cb0_038w : packoffset(c038.w);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  int cb0_040w : packoffset(c040.w);
  int cb0_041x : packoffset(c041.x);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
};

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  int WorkingColorSpace_320 : packoffset(c020.x);
};

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
  float _32;
  float _37;
  float _38;
  float _39;
  float _41;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _127;
  float _128;
  float _129;
  float _177;
  float _905;
  float _938;
  float _952;
  float _1016;
  float _1284;
  float _1285;
  float _1286;
  float _1297;
  float _1308;
  float _1481;
  float _1496;
  float _1511;
  float _1519;
  float _1520;
  float _1521;
  float _1588;
  float _1621;
  float _1635;
  float _1674;
  float _1796;
  float _1882;
  float _1956;
  float _2035;
  float _2036;
  float _2037;
  float _2167;
  float _2182;
  float _2197;
  float _2205;
  float _2206;
  float _2207;
  float _2274;
  float _2307;
  float _2321;
  float _2360;
  float _2482;
  float _2568;
  float _2654;
  float _2733;
  float _2734;
  float _2735;
  float _2912;
  float _2913;
  float _2914;
  bool _50;
  float _80;
  float _81;
  float _82;
  bool _156;
  float _160;
  float _191;
  float _198;
  float _201;
  float _206;
  float _207;
  float _209;
  bool _210;
  float _219;
  float _221;
  float _228;
  float _230;
  float _232;
  float _233;
  float _236;
  float _239;
  float _244;
  float _250;
  float _251;
  float _252;
  float _253;
  float _254;
  float _255;
  float _256;
  float _257;
  float _260;
  float _261;
  float _262;
  float _265;
  float _284;
  float _285;
  float _286;
  float _287;
  float _288;
  float _289;
  float _290;
  float _291;
  float _292;
  float _295;
  float _298;
  float _301;
  float _304;
  float _307;
  float _310;
  float _313;
  float _316;
  float _319;
  float _322;
  float _325;
  float _328;
  float _331;
  float _334;
  float _337;
  float _340;
  float _343;
  float _346;
  float _376;
  float _379;
  float _382;
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
  float _845;
  float _846;
  float _847;
  float _850;
  float _853;
  float _856;
  float _860;
  float _865;
  float _878;
  float _879;
  float _880;
  float _881;
  float _885;
  float _896;
  float _906;
  float _907;
  float _908;
  float _909;
  float _916;
  float _919;
  float _921;
  bool _924;
  bool _925;
  bool _926;
  bool _927;
  float _943;
  float _956;
  float _960;
  float _966;
  float _976;
  float _977;
  float _978;
  float _979;
  float _994;
  float _996;
  float _998;
  float _1007;
  float _1019;
  float _1021;
  float _1025;
  float _1026;
  float _1027;
  float _1031;
  float _1032;
  float _1033;
  float _1034;
  float _1036;
  float _1037;
  float _1038;
  float _1039;
  float _1058;
  float _1060;
  float _1085;
  float _1086;
  float _1087;
  float _1094;
  float _1098;
  float _1099;
  float _1100;
  bool _1101;
  float _1105;
  float _1106;
  float _1107;
  float _1126;
  float _1127;
  float _1128;
  float _1129;
  float _1149;
  float _1150;
  float _1151;
  float _1167;
  float _1168;
  float _1169;
  float _1179;
  float _1180;
  float _1181;
  float _1207;
  float _1208;
  float _1209;
  float _1216;
  float _1217;
  float _1218;
  float _1219;
  float _1220;
  float _1221;
  float _1228;
  float _1229;
  float _1230;
  float _1242;
  float _1243;
  float _1244;
  float _1267;
  float _1270;
  float _1273;
  float _1335;
  float _1338;
  float _1341;
  float _1351;
  float _1352;
  float _1353;
  float _1429;
  float _1430;
  float _1431;
  float _1434;
  float _1437;
  float _1440;
  float _1443;
  float _1446;
  float _1449;
  float _1451;
  float _1461;
  float _1462;
  float _1464;
  float _1466;
  float _1469;
  float _1484;
  float _1499;
  float _1537;
  float _1538;
  float _1539;
  float _1543;
  float _1548;
  float _1561;
  float _1562;
  float _1563;
  float _1564;
  float _1568;
  float _1579;
  float _1589;
  float _1590;
  float _1591;
  float _1592;
  float _1599;
  float _1602;
  float _1604;
  bool _1607;
  bool _1608;
  bool _1609;
  bool _1610;
  float _1626;
  float _1641;
  int _1642;
  float _1644;
  float _1645;
  float _1646;
  float _1683;
  float _1684;
  float _1685;
  float _1698;
  float _1699;
  float _1700;
  float _1701;
  float _1724;
  float _1725;
  float _1726;
  float _1727;
  float _1734;
  float _1735;
  float _1743;
  int _1744;
  float _1746;
  float _1748;
  float _1751;
  float _1756;
  float _1765;
  float _1773;
  int _1774;
  float _1776;
  float _1778;
  float _1781;
  float _1786;
  float _1812;
  float _1813;
  float _1820;
  float _1821;
  float _1829;
  int _1830;
  float _1832;
  float _1834;
  float _1837;
  float _1842;
  float _1851;
  float _1859;
  int _1860;
  float _1862;
  float _1864;
  float _1867;
  float _1872;
  float _1886;
  float _1887;
  float _1894;
  float _1895;
  float _1903;
  int _1904;
  float _1906;
  float _1908;
  float _1911;
  float _1916;
  float _1925;
  float _1933;
  int _1934;
  float _1936;
  float _1938;
  float _1941;
  float _1946;
  float _1960;
  float _1961;
  float _1963;
  float _1965;
  float _1968;
  float _1971;
  float _1974;
  float _1987;
  float _1988;
  float _1989;
  float _1992;
  float _1995;
  float _1998;
  float _2020;
  float _2021;
  float _2022;
  float _2047;
  float _2048;
  float _2049;
  float _2115;
  float _2116;
  float _2117;
  float _2120;
  float _2123;
  float _2126;
  float _2129;
  float _2132;
  float _2135;
  float _2137;
  float _2147;
  float _2148;
  float _2150;
  float _2152;
  float _2155;
  float _2170;
  float _2185;
  float _2223;
  float _2224;
  float _2225;
  float _2229;
  float _2234;
  float _2247;
  float _2248;
  float _2249;
  float _2250;
  float _2254;
  float _2265;
  float _2275;
  float _2276;
  float _2277;
  float _2278;
  float _2285;
  float _2288;
  float _2290;
  bool _2293;
  bool _2294;
  bool _2295;
  bool _2296;
  float _2312;
  float _2327;
  int _2328;
  float _2330;
  float _2331;
  float _2332;
  float _2369;
  float _2370;
  float _2371;
  float _2384;
  float _2385;
  float _2386;
  float _2387;
  float _2410;
  float _2411;
  float _2412;
  float _2413;
  float _2420;
  float _2421;
  float _2429;
  int _2430;
  float _2432;
  float _2434;
  float _2437;
  float _2442;
  float _2451;
  float _2459;
  int _2460;
  float _2462;
  float _2464;
  float _2467;
  float _2472;
  float _2498;
  float _2499;
  float _2506;
  float _2507;
  float _2515;
  int _2516;
  float _2518;
  float _2520;
  float _2523;
  float _2528;
  float _2537;
  float _2545;
  int _2546;
  float _2548;
  float _2550;
  float _2553;
  float _2558;
  float _2584;
  float _2585;
  float _2592;
  float _2593;
  float _2601;
  int _2602;
  float _2604;
  float _2606;
  float _2609;
  float _2614;
  float _2623;
  float _2631;
  int _2632;
  float _2634;
  float _2636;
  float _2639;
  float _2644;
  float _2658;
  float _2659;
  float _2661;
  float _2663;
  float _2666;
  float _2669;
  float _2672;
  float _2685;
  float _2686;
  float _2687;
  float _2690;
  float _2693;
  float _2696;
  float _2718;
  float _2719;
  float _2720;
  float _2745;
  float _2746;
  float _2747;
  float _2792;
  float _2795;
  float _2798;
  float _2817;
  float _2818;
  float _2819;
  float _2866;
  float _2869;
  float _2872;
  float _2885;
  float _2888;
  float _2891;
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
  float _19[6];
  float _20[6];
  _32 = 0.5f / cb0_035x;
  _37 = cb0_035x + -1.0f;
  _38 = (cb0_035x * ((cb0_042x * (((float)((uint)SV_DispatchThreadID.x)) + 0.5f)) - _32)) / _37;
  _39 = (cb0_035x * ((cb0_042y * (((float)((uint)SV_DispatchThreadID.y)) + 0.5f)) - _32)) / _37;
  _41 = ((float)((uint)SV_DispatchThreadID.z)) / _37;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        _50 = (cb0_041x == 4);
        _61 = select(_50, 1.0f, 1.705051064491272f);
        _62 = select(_50, 0.0f, -0.6217921376228333f);
        _63 = select(_50, 0.0f, -0.0832589864730835f);
        _64 = select(_50, 0.0f, -0.13025647401809692f);
        _65 = select(_50, 1.0f, 1.140804648399353f);
        _66 = select(_50, 0.0f, -0.010548308491706848f);
        _67 = select(_50, 0.0f, -0.024003351107239723f);
        _68 = select(_50, 0.0f, -0.1289689838886261f);
        _69 = select(_50, 1.0f, 1.1529725790023804f);
      } else {
        _61 = 0.6954522132873535f;
        _62 = 0.14067870378494263f;
        _63 = 0.16386906802654266f;
        _64 = 0.044794563204050064f;
        _65 = 0.8596711158752441f;
        _66 = 0.0955343171954155f;
        _67 = -0.005525882821530104f;
        _68 = 0.004025210160762072f;
        _69 = 1.0015007257461548f;
      }
    } else {
      _61 = 1.0258246660232544f;
      _62 = -0.020053181797266006f;
      _63 = -0.005771636962890625f;
      _64 = -0.002234415616840124f;
      _65 = 1.0045864582061768f;
      _66 = -0.002352118492126465f;
      _67 = -0.005013350863009691f;
      _68 = -0.025290070101618767f;
      _69 = 1.0303035974502563f;
    }
  } else {
    _61 = 1.3792141675949097f;
    _62 = -0.30886411666870117f;
    _63 = -0.0703500509262085f;
    _64 = -0.06933490186929703f;
    _65 = 1.08229660987854f;
    _66 = -0.012961871922016144f;
    _67 = -0.0021590073592960835f;
    _68 = -0.0454593189060688f;
    _69 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    _80 = (pow(_38, 0.012683313339948654f));
    _81 = (pow(_39, 0.012683313339948654f));
    _82 = (pow(_41, 0.012683313339948654f));
    _127 = (exp2(log2(max(0.0f, (_80 + -0.8359375f)) / (18.8515625f - (_80 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _128 = (exp2(log2(max(0.0f, (_81 + -0.8359375f)) / (18.8515625f - (_81 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _129 = (exp2(log2(max(0.0f, (_82 + -0.8359375f)) / (18.8515625f - (_82 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _127 = ((exp2((_38 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _128 = ((exp2((_39 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _129 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  _156 = (cb0_038w != 0);
  _160 = 0.9994439482688904f / cb0_035y;
  if (!(!((cb0_035y * 1.0005563497543335f) <= 7000.0f))) {
    _177 = (((((2967800.0f - (_160 * 4607000064.0f)) * _160) + 99.11000061035156f) * _160) + 0.24406300485134125f);
  } else {
    _177 = (((((1901800.0f - (_160 * 2006400000.0f)) * _160) + 247.47999572753906f) * _160) + 0.23703999817371368f);
  }
  _191 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  _198 = cb0_035y * cb0_035y;
  _201 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_198 * 1.6145605741257896e-07f));
  _206 = ((_191 * 2.0f) + 4.0f) - (_201 * 8.0f);
  _207 = (_191 * 3.0f) / _206;
  _209 = (_201 * 2.0f) / _206;
  _210 = (cb0_035y < 4000.0f);
  _219 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  _221 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_198 * 1.5317699909210205f)) / (_219 * _219);
  _228 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _198;
  _230 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_198 * 308.60699462890625f)) / (_228 * _228);
  _232 = rsqrt(dot(float2(_221, _230), float2(_221, _230)));
  _233 = cb0_035z * 0.05000000074505806f;
  _236 = ((_233 * _230) * _232) + _191;
  _239 = _201 - ((_233 * _221) * _232);
  _244 = (4.0f - (_239 * 8.0f)) + (_236 * 2.0f);
  _250 = (((_236 * 3.0f) / _244) - _207) + select(_210, _207, _177);
  _251 = (((_239 * 2.0f) / _244) - _209) + select(_210, _209, (((_177 * 2.869999885559082f) + -0.2750000059604645f) - ((_177 * _177) * 3.0f)));
  _252 = select(_156, _250, 0.3127000033855438f);
  _253 = select(_156, _251, 0.32899999618530273f);
  _254 = select(_156, 0.3127000033855438f, _250);
  _255 = select(_156, 0.32899999618530273f, _251);
  _256 = max(_253, 1.000000013351432e-10f);
  _257 = _252 / _256;
  _260 = ((1.0f - _252) - _253) / _256;
  _261 = max(_255, 1.000000013351432e-10f);
  _262 = _254 / _261;
  _265 = ((1.0f - _254) - _255) / _261;
  _284 = mad(-0.16140000522136688f, _265, ((_262 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _260, ((_257 * 0.8950999975204468f) + 0.266400009393692f));
  _285 = mad(0.03669999912381172f, _265, (1.7135000228881836f - (_262 * 0.7501999735832214f))) / mad(0.03669999912381172f, _260, (1.7135000228881836f - (_257 * 0.7501999735832214f)));
  _286 = mad(1.0296000242233276f, _265, ((_262 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _260, ((_257 * 0.03889999911189079f) + -0.06849999725818634f));
  _287 = mad(_285, -0.7501999735832214f, 0.0f);
  _288 = mad(_285, 1.7135000228881836f, 0.0f);
  _289 = mad(_285, 0.03669999912381172f, -0.0f);
  _290 = mad(_286, 0.03889999911189079f, 0.0f);
  _291 = mad(_286, -0.06849999725818634f, 0.0f);
  _292 = mad(_286, 1.0296000242233276f, 0.0f);
  _295 = mad(0.1599626988172531f, _290, mad(-0.1470542997121811f, _287, (_284 * 0.883457362651825f)));
  _298 = mad(0.1599626988172531f, _291, mad(-0.1470542997121811f, _288, (_284 * 0.26293492317199707f)));
  _301 = mad(0.1599626988172531f, _292, mad(-0.1470542997121811f, _289, (_284 * -0.15930065512657166f)));
  _304 = mad(0.04929120093584061f, _290, mad(0.5183603167533875f, _287, (_284 * 0.38695648312568665f)));
  _307 = mad(0.04929120093584061f, _291, mad(0.5183603167533875f, _288, (_284 * 0.11516613513231277f)));
  _310 = mad(0.04929120093584061f, _292, mad(0.5183603167533875f, _289, (_284 * -0.0697740763425827f)));
  _313 = mad(0.9684867262840271f, _290, mad(0.04004279896616936f, _287, (_284 * -0.007634039502590895f)));
  _316 = mad(0.9684867262840271f, _291, mad(0.04004279896616936f, _288, (_284 * -0.0022720457054674625f)));
  _319 = mad(0.9684867262840271f, _292, mad(0.04004279896616936f, _289, (_284 * 0.0013765322510153055f)));
  _322 = mad(_301, (WorkingColorSpace_000[2].x), mad(_298, (WorkingColorSpace_000[1].x), (_295 * (WorkingColorSpace_000[0].x))));
  _325 = mad(_301, (WorkingColorSpace_000[2].y), mad(_298, (WorkingColorSpace_000[1].y), (_295 * (WorkingColorSpace_000[0].y))));
  _328 = mad(_301, (WorkingColorSpace_000[2].z), mad(_298, (WorkingColorSpace_000[1].z), (_295 * (WorkingColorSpace_000[0].z))));
  _331 = mad(_310, (WorkingColorSpace_000[2].x), mad(_307, (WorkingColorSpace_000[1].x), (_304 * (WorkingColorSpace_000[0].x))));
  _334 = mad(_310, (WorkingColorSpace_000[2].y), mad(_307, (WorkingColorSpace_000[1].y), (_304 * (WorkingColorSpace_000[0].y))));
  _337 = mad(_310, (WorkingColorSpace_000[2].z), mad(_307, (WorkingColorSpace_000[1].z), (_304 * (WorkingColorSpace_000[0].z))));
  _340 = mad(_319, (WorkingColorSpace_000[2].x), mad(_316, (WorkingColorSpace_000[1].x), (_313 * (WorkingColorSpace_000[0].x))));
  _343 = mad(_319, (WorkingColorSpace_000[2].y), mad(_316, (WorkingColorSpace_000[1].y), (_313 * (WorkingColorSpace_000[0].y))));
  _346 = mad(_319, (WorkingColorSpace_000[2].z), mad(_316, (WorkingColorSpace_000[1].z), (_313 * (WorkingColorSpace_000[0].z))));
  _376 = mad(mad((WorkingColorSpace_064[0].z), _346, mad((WorkingColorSpace_064[0].y), _337, (_328 * (WorkingColorSpace_064[0].x)))), _129, mad(mad((WorkingColorSpace_064[0].z), _343, mad((WorkingColorSpace_064[0].y), _334, (_325 * (WorkingColorSpace_064[0].x)))), _128, (mad((WorkingColorSpace_064[0].z), _340, mad((WorkingColorSpace_064[0].y), _331, (_322 * (WorkingColorSpace_064[0].x)))) * _127)));
  _379 = mad(mad((WorkingColorSpace_064[1].z), _346, mad((WorkingColorSpace_064[1].y), _337, (_328 * (WorkingColorSpace_064[1].x)))), _129, mad(mad((WorkingColorSpace_064[1].z), _343, mad((WorkingColorSpace_064[1].y), _334, (_325 * (WorkingColorSpace_064[1].x)))), _128, (mad((WorkingColorSpace_064[1].z), _340, mad((WorkingColorSpace_064[1].y), _331, (_322 * (WorkingColorSpace_064[1].x)))) * _127)));
  _382 = mad(mad((WorkingColorSpace_064[2].z), _346, mad((WorkingColorSpace_064[2].y), _337, (_328 * (WorkingColorSpace_064[2].x)))), _129, mad(mad((WorkingColorSpace_064[2].z), _343, mad((WorkingColorSpace_064[2].y), _334, (_325 * (WorkingColorSpace_064[2].x)))), _128, (mad((WorkingColorSpace_064[2].z), _340, mad((WorkingColorSpace_064[2].y), _331, (_322 * (WorkingColorSpace_064[2].x)))) * _127)));
  _397 = mad((WorkingColorSpace_128[0].z), _382, mad((WorkingColorSpace_128[0].y), _379, ((WorkingColorSpace_128[0].x) * _376)));
  _400 = mad((WorkingColorSpace_128[1].z), _382, mad((WorkingColorSpace_128[1].y), _379, ((WorkingColorSpace_128[1].x) * _376)));
  _403 = mad((WorkingColorSpace_128[2].z), _382, mad((WorkingColorSpace_128[2].y), _379, ((WorkingColorSpace_128[2].x) * _376)));
  _404 = dot(float3(_397, _400, _403), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _408 = (_397 / _404) + -1.0f;
  _409 = (_400 / _404) + -1.0f;
  _410 = (_403 / _404) + -1.0f;
  // ExpandGamut set to 0
  _422 = (1.0f - exp2(((_404 * _404) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_408, _409, _410), float3(_408, _409, _410)) * -4.0f));
  _438 = ((mad(-0.06368321925401688f, _403, mad(-0.3292922377586365f, _400, (_397 * 1.3704125881195068f))) - _397) * _422) + _397;
  _439 = ((mad(-0.010861365124583244f, _403, mad(1.0970927476882935f, _400, (_397 * -0.08343357592821121f))) - _400) * _422) + _400;
  _440 = ((mad(1.2036951780319214f, _403, mad(-0.09862580895423889f, _400, (_397 * -0.02579331398010254f))) - _403) * _422) + _403;
  _441 = dot(float3(_438, _439, _440), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _455 = cb0_019w + cb0_024w;
  _469 = cb0_018w * cb0_023w;
  _483 = cb0_017w * cb0_022w;
  _497 = cb0_016w * cb0_021w;
  _511 = cb0_015w * cb0_020w;
  _515 = _438 - _441;
  _516 = _439 - _441;
  _517 = _440 - _441;
  _574 = saturate(_441 / cb0_035w);
  _578 = (_574 * _574) * (3.0f - (_574 * 2.0f));
  _579 = 1.0f - _578;
  _588 = cb0_019w + cb0_034w;
  _597 = cb0_018w * cb0_033w;
  _606 = cb0_017w * cb0_032w;
  _615 = cb0_016w * cb0_031w;
  _624 = cb0_015w * cb0_030w;
  _687 = saturate((_441 - cb0_036x) / (cb0_036y - cb0_036x));
  _691 = (_687 * _687) * (3.0f - (_687 * 2.0f));
  _700 = cb0_019w + cb0_029w;
  _709 = cb0_018w * cb0_028w;
  _718 = cb0_017w * cb0_027w;
  _727 = cb0_016w * cb0_026w;
  _736 = cb0_015w * cb0_025w;
  _794 = _578 - _691;
  _805 = ((_691 * (((cb0_019x + cb0_034x) + _588) + (((cb0_018x * cb0_033x) * _597) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _615) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _624) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _606)))))) + (_579 * (((cb0_019x + cb0_024x) + _455) + (((cb0_018x * cb0_023x) * _469) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _497) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _511) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _483))))))) + ((((cb0_019x + cb0_029x) + _700) + (((cb0_018x * cb0_028x) * _709) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _727) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _736) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _718))))) * _794);
  _807 = ((_691 * (((cb0_019y + cb0_034y) + _588) + (((cb0_018y * cb0_033y) * _597) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _615) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _624) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _606)))))) + (_579 * (((cb0_019y + cb0_024y) + _455) + (((cb0_018y * cb0_023y) * _469) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _497) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _511) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _483))))))) + ((((cb0_019y + cb0_029y) + _700) + (((cb0_018y * cb0_028y) * _709) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _727) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _736) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _718))))) * _794);
  _809 = ((_691 * (((cb0_019z + cb0_034z) + _588) + (((cb0_018z * cb0_033z) * _597) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _615) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _624) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _606)))))) + (_579 * (((cb0_019z + cb0_024z) + _455) + (((cb0_018z * cb0_023z) * _469) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _497) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _511) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _483))))))) + ((((cb0_019z + cb0_029z) + _700) + (((cb0_018z * cb0_028z) * _709) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _727) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _736) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _718))))) * _794);
  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = cb0_038x;
  cb_config.ue_filmtoe = cb0_037z;
  cb_config.ue_filmshoulder = cb0_037w;
  cb_config.ue_filmslope = cb0_037y;
  cb_config.ue_filmwhiteclip = cb0_038y;
  cb_config.ue_tonecurveammount = cb0_037x;
  cb_config.ue_mappingpolynomial = float3(cb0_039x, cb0_039y, cb0_039z);
  cb_config.ue_overlaycolor = float4(cb0_013x, cb0_013y, cb0_013z, cb0_013w);
  cb_config.ue_bluecorrection = cb0_036z;
  cb_config.ue_colorscale = float3(cb0_014x, cb0_014y, cb0_014z);

  float4 output = ProcessLutbuilder(float3(_805, _807, _809), cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _845 = ((mad(0.061360642313957214f, _809, mad(-4.540197551250458e-09f, _807, (_805 * 0.9386394023895264f))) - _805) * cb0_036z) + _805;
  _846 = ((mad(0.169205904006958f, _809, mad(0.8307942152023315f, _807, (_805 * 6.775371730327606e-08f))) - _807) * cb0_036z) + _807;
  _847 = (mad(-2.3283064365386963e-10f, _807, (_805 * -9.313225746154785e-10f)) * cb0_036z) + _809;
  _850 = mad(0.16386905312538147f, _847, mad(0.14067868888378143f, _846, (_845 * 0.6954522132873535f)));
  _853 = mad(0.0955343246459961f, _847, mad(0.8596711158752441f, _846, (_845 * 0.044794581830501556f)));
  _856 = mad(1.0015007257461548f, _847, mad(0.004025210160762072f, _846, (_845 * -0.005525882821530104f)));
  _860 = max(max(_850, _853), _856);
  _865 = (max(_860, 1.000000013351432e-10f) - max(min(min(_850, _853), _856), 1.000000013351432e-10f)) / max(_860, 0.009999999776482582f);
  _878 = ((_853 + _850) + _856) + (sqrt((((_856 - _853) * _856) + ((_853 - _850) * _853)) + ((_850 - _856) * _850)) * 1.75f);
  _879 = _878 * 0.3333333432674408f;
  _880 = _865 + -0.4000000059604645f;
  _881 = _880 * 5.0f;
  _885 = max((1.0f - abs(_880 * 2.5f)), 0.0f);
  _896 = ((float((int)(((int)(uint)((int)(_881 > 0.0f))) - ((int)(uint)((int)(_881 < 0.0f))))) * (1.0f - (_885 * _885))) + 1.0f) * 0.02500000037252903f;
  if (!(_879 <= 0.0533333346247673f)) {
    if (!(_879 >= 0.1599999964237213f)) {
      _905 = (((0.23999999463558197f / _878) + -0.5f) * _896);
    } else {
      _905 = 0.0f;
    }
  } else {
    _905 = _896;
  }
  _906 = _905 + 1.0f;
  _907 = _906 * _850;
  _908 = _906 * _853;
  _909 = _906 * _856;
  if (!((_907 == _908) && (_908 == _909))) {
    _916 = ((_907 * 2.0f) - _908) - _909;
    _919 = ((_853 - _856) * 1.7320507764816284f) * _906;
    _921 = atan(_919 / _916);
    _924 = (_916 < 0.0f);
    _925 = (_916 == 0.0f);
    _926 = (_919 >= 0.0f);
    _927 = (_919 < 0.0f);
    _938 = select((_926 && _925), 90.0f, select((_927 && _925), -90.0f, (select((_927 && _924), (_921 + -3.1415927410125732f), select((_926 && _924), (_921 + 3.1415927410125732f), _921)) * 57.2957763671875f)));
  } else {
    _938 = 0.0f;
  }
  _943 = min(max(select((_938 < 0.0f), (_938 + 360.0f), _938), 0.0f), 360.0f);
  if (_943 < -180.0f) {
    _952 = (_943 + 360.0f);
  } else {
    if (_943 > 180.0f) {
      _952 = (_943 + -360.0f);
    } else {
      _952 = _943;
    }
  }
  _956 = saturate(1.0f - abs(_952 * 0.014814814552664757f));
  _960 = (_956 * _956) * (3.0f - (_956 * 2.0f));
  _966 = ((_960 * _960) * ((_865 * 0.18000000715255737f) * (0.029999999329447746f - _907))) + _907;
  _976 = max(0.0f, mad(-0.21492856740951538f, _909, mad(-0.2365107536315918f, _908, (_966 * 1.4514392614364624f))));
  _977 = max(0.0f, mad(-0.09967592358589172f, _909, mad(1.17622971534729f, _908, (_966 * -0.07655377686023712f))));
  _978 = max(0.0f, mad(0.9977163076400757f, _909, mad(-0.006032449658960104f, _908, (_966 * 0.008316148072481155f))));
  _979 = dot(float3(_976, _977, _978), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _994 = (cb0_038x + 1.0f) - cb0_037z;
  _996 = cb0_038y + 1.0f;
  _998 = _996 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _1016 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    _1007 = (cb0_038x + 0.18000000715255737f) / _994;
    _1016 = (-0.7447274923324585f - ((log2(_1007 / (2.0f - _1007)) * 0.3465735912322998f) * (_994 / cb0_037y)));
  }
  _1019 = ((1.0f - cb0_037z) / cb0_037y) - _1016;
  _1021 = (cb0_037w / cb0_037y) - _1019;
  _1025 = log2(lerp(_979, _976, 0.9599999785423279f)) * 0.3010300099849701f;
  _1026 = log2(lerp(_979, _977, 0.9599999785423279f)) * 0.3010300099849701f;
  _1027 = log2(lerp(_979, _978, 0.9599999785423279f)) * 0.3010300099849701f;
  _1031 = cb0_037y * (_1025 + _1019);
  _1032 = cb0_037y * (_1026 + _1019);
  _1033 = cb0_037y * (_1027 + _1019);
  _1034 = _994 * 2.0f;
  _1036 = (cb0_037y * -2.0f) / _994;
  _1037 = _1025 - _1016;
  _1038 = _1026 - _1016;
  _1039 = _1027 - _1016;
  _1058 = _998 * 2.0f;
  _1060 = (cb0_037y * 2.0f) / _998;
  _1085 = select((_1025 < _1016), ((_1034 / (exp2((_1037 * 1.4426950216293335f) * _1036) + 1.0f)) - cb0_038x), _1031);
  _1086 = select((_1026 < _1016), ((_1034 / (exp2((_1038 * 1.4426950216293335f) * _1036) + 1.0f)) - cb0_038x), _1032);
  _1087 = select((_1027 < _1016), ((_1034 / (exp2((_1039 * 1.4426950216293335f) * _1036) + 1.0f)) - cb0_038x), _1033);
  _1094 = _1021 - _1016;
  _1098 = saturate(_1037 / _1094);
  _1099 = saturate(_1038 / _1094);
  _1100 = saturate(_1039 / _1094);
  _1101 = (_1021 < _1016);
  _1105 = select(_1101, (1.0f - _1098), _1098);
  _1106 = select(_1101, (1.0f - _1099), _1099);
  _1107 = select(_1101, (1.0f - _1100), _1100);
  _1126 = (((_1105 * _1105) * (select((_1025 > _1021), (_996 - (_1058 / (exp2(((_1025 - _1021) * 1.4426950216293335f) * _1060) + 1.0f))), _1031) - _1085)) * (3.0f - (_1105 * 2.0f))) + _1085;
  _1127 = (((_1106 * _1106) * (select((_1026 > _1021), (_996 - (_1058 / (exp2(((_1026 - _1021) * 1.4426950216293335f) * _1060) + 1.0f))), _1032) - _1086)) * (3.0f - (_1106 * 2.0f))) + _1086;
  _1128 = (((_1107 * _1107) * (select((_1027 > _1021), (_996 - (_1058 / (exp2(((_1027 - _1021) * 1.4426950216293335f) * _1060) + 1.0f))), _1033) - _1087)) * (3.0f - (_1107 * 2.0f))) + _1087;
  _1129 = dot(float3(_1126, _1127, _1128), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1149 = (cb0_037x * (max(0.0f, (lerp(_1129, _1126, 0.9300000071525574f))) - _845)) + _845;
  _1150 = (cb0_037x * (max(0.0f, (lerp(_1129, _1127, 0.9300000071525574f))) - _846)) + _846;
  _1151 = (cb0_037x * (max(0.0f, (lerp(_1129, _1128, 0.9300000071525574f))) - _847)) + _847;
  _1167 = ((mad(-0.06537103652954102f, _1151, mad(1.451815478503704e-06f, _1150, (_1149 * 1.065374732017517f))) - _1149) * cb0_036z) + _1149;
  _1168 = ((mad(-0.20366770029067993f, _1151, mad(1.2036634683609009f, _1150, (_1149 * -2.57161445915699e-07f))) - _1150) * cb0_036z) + _1150;
  _1169 = ((mad(0.9999996423721313f, _1151, mad(2.0954757928848267e-08f, _1150, (_1149 * 1.862645149230957e-08f))) - _1151) * cb0_036z) + _1151;
  _1179 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1169, mad((WorkingColorSpace_192[0].y), _1168, ((WorkingColorSpace_192[0].x) * _1167))));
  _1180 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1169, mad((WorkingColorSpace_192[1].y), _1168, ((WorkingColorSpace_192[1].x) * _1167))));
  _1181 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1169, mad((WorkingColorSpace_192[2].y), _1168, ((WorkingColorSpace_192[2].x) * _1167))));
  _1207 = cb0_014x * (((cb0_039y + (cb0_039x * _1179)) * _1179) + cb0_039z);
  _1208 = cb0_014y * (((cb0_039y + (cb0_039x * _1180)) * _1180) + cb0_039z);
  _1209 = cb0_014z * (((cb0_039y + (cb0_039x * _1181)) * _1181) + cb0_039z);
  _1216 = ((cb0_013x - _1207) * cb0_013w) + _1207;
  _1217 = ((cb0_013y - _1208) * cb0_013w) + _1208;
  _1218 = ((cb0_013z - _1209) * cb0_013w) + _1209;
  _1219 = cb0_014x * mad((WorkingColorSpace_192[0].z), _809, mad((WorkingColorSpace_192[0].y), _807, (_805 * (WorkingColorSpace_192[0].x))));
  _1220 = cb0_014y * mad((WorkingColorSpace_192[1].z), _809, mad((WorkingColorSpace_192[1].y), _807, ((WorkingColorSpace_192[1].x) * _805)));
  _1221 = cb0_014z * mad((WorkingColorSpace_192[2].z), _809, mad((WorkingColorSpace_192[2].y), _807, ((WorkingColorSpace_192[2].x) * _805)));
  _1228 = ((cb0_013x - _1219) * cb0_013w) + _1219;
  _1229 = ((cb0_013y - _1220) * cb0_013w) + _1220;
  _1230 = ((cb0_013z - _1221) * cb0_013w) + _1221;
  _1242 = exp2(log2(max(0.0f, _1216)) * cb0_040y);
  _1243 = exp2(log2(max(0.0f, _1217)) * cb0_040y);
  _1244 = exp2(log2(max(0.0f, _1218)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      _1284 = _1242;
      _1285 = _1243;
      _1286 = _1244;
      if (WorkingColorSpace_320 == 0) {
        _1267 = mad((WorkingColorSpace_128[0].z), _1244, mad((WorkingColorSpace_128[0].y), _1243, ((WorkingColorSpace_128[0].x) * _1242)));
        _1270 = mad((WorkingColorSpace_128[1].z), _1244, mad((WorkingColorSpace_128[1].y), _1243, ((WorkingColorSpace_128[1].x) * _1242)));
        _1273 = mad((WorkingColorSpace_128[2].z), _1244, mad((WorkingColorSpace_128[2].y), _1243, ((WorkingColorSpace_128[2].x) * _1242)));
        _1284 = mad(_63, _1273, mad(_62, _1270, (_1267 * _61)));
        _1285 = mad(_66, _1273, mad(_65, _1270, (_1267 * _64)));
        _1286 = mad(_69, _1273, mad(_68, _1270, (_1267 * _67)));
      }
      do {
        if (_1284 < 0.0031306699384003878f) {
          _1297 = (_1284 * 12.920000076293945f);
        } else {
          _1297 = (((pow(_1284, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1285 < 0.0031306699384003878f) {
            _1308 = (_1285 * 12.920000076293945f);
          } else {
            _1308 = (((pow(_1285, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1286 < 0.0031306699384003878f) {
            _2912 = _1297;
            _2913 = _1308;
            _2914 = (_1286 * 12.920000076293945f);
          } else {
            _2912 = _1297;
            _2913 = _1308;
            _2914 = (((pow(_1286, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      _1335 = mad((WorkingColorSpace_128[0].z), _1244, mad((WorkingColorSpace_128[0].y), _1243, ((WorkingColorSpace_128[0].x) * _1242)));
      _1338 = mad((WorkingColorSpace_128[1].z), _1244, mad((WorkingColorSpace_128[1].y), _1243, ((WorkingColorSpace_128[1].x) * _1242)));
      _1341 = mad((WorkingColorSpace_128[2].z), _1244, mad((WorkingColorSpace_128[2].y), _1243, ((WorkingColorSpace_128[2].x) * _1242)));
      _1351 = max(6.103519990574569e-05f, mad(_63, _1341, mad(_62, _1338, (_1335 * _61))));
      _1352 = max(6.103519990574569e-05f, mad(_66, _1341, mad(_65, _1338, (_1335 * _64))));
      _1353 = max(6.103519990574569e-05f, mad(_69, _1341, mad(_68, _1338, (_1335 * _67))));
      _2912 = min((_1351 * 4.5f), ((exp2(log2(max(_1351, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2913 = min((_1352 * 4.5f), ((exp2(log2(max(_1352, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2914 = min((_1353 * 4.5f), ((exp2(log2(max(_1353, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((cb0_040w == 3) || (cb0_040w == 5)) {
        _9[0] = cb0_010x;
        _9[1] = cb0_010y;
        _9[2] = cb0_010z;
        _9[3] = cb0_010w;
        _9[4] = cb0_012x;
        _9[5] = cb0_012x;
        _10[0] = cb0_011x;
        _10[1] = cb0_011y;
        _10[2] = cb0_011z;
        _10[3] = cb0_011w;
        _10[4] = cb0_012y;
        _10[5] = cb0_012y;
        _1429 = cb0_012z * _1228;
        _1430 = cb0_012z * _1229;
        _1431 = cb0_012z * _1230;
        _1434 = mad((WorkingColorSpace_256[0].z), _1431, mad((WorkingColorSpace_256[0].y), _1430, ((WorkingColorSpace_256[0].x) * _1429)));
        _1437 = mad((WorkingColorSpace_256[1].z), _1431, mad((WorkingColorSpace_256[1].y), _1430, ((WorkingColorSpace_256[1].x) * _1429)));
        _1440 = mad((WorkingColorSpace_256[2].z), _1431, mad((WorkingColorSpace_256[2].y), _1430, ((WorkingColorSpace_256[2].x) * _1429)));
        _1443 = mad(-0.21492856740951538f, _1440, mad(-0.2365107536315918f, _1437, (_1434 * 1.4514392614364624f)));
        _1446 = mad(-0.09967592358589172f, _1440, mad(1.17622971534729f, _1437, (_1434 * -0.07655377686023712f)));
        _1449 = mad(0.9977163076400757f, _1440, mad(-0.006032449658960104f, _1437, (_1434 * 0.008316148072481155f)));
        _1451 = max(_1443, max(_1446, _1449));
        do {
          _1519 = _1443;
          _1520 = _1446;
          _1521 = _1449;
          if (!(_1451 < 1.000000013351432e-10f)) {
            if (!(((_1434 < 0.0f) || (_1437 < 0.0f)) || (_1440 < 0.0f))) {
              _1461 = abs(_1451);
              _1462 = (_1451 - _1443) / _1461;
              _1464 = (_1451 - _1446) / _1461;
              _1466 = (_1451 - _1449) / _1461;
              do {
                _1481 = _1462;
                if (!(_1462 < 0.8149999976158142f)) {
                  _1469 = _1462 + -0.8149999976158142f;
                  _1481 = ((_1469 / exp2(log2(exp2(log2(_1469 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                }
                do {
                  _1496 = _1464;
                  if (!(_1464 < 0.8029999732971191f)) {
                    _1484 = _1464 + -0.8029999732971191f;
                    _1496 = ((_1484 / exp2(log2(exp2(log2(_1484 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  }
                  do {
                    _1511 = _1466;
                    if (!(_1466 < 0.8799999952316284f)) {
                      _1499 = _1466 + -0.8799999952316284f;
                      _1511 = ((_1499 / exp2(log2(exp2(log2(_1499 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    }
                    _1519 = (_1451 - (_1461 * _1481));
                    _1520 = (_1451 - (_1461 * _1496));
                    _1521 = (_1451 - (_1461 * _1511));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1519 = _1443;
              _1520 = _1446;
              _1521 = _1449;
            }
          }
          _1537 = ((mad(0.16386906802654266f, _1521, mad(0.14067870378494263f, _1520, (_1519 * 0.6954522132873535f))) - _1434) * cb0_012w) + _1434;
          _1538 = ((mad(0.0955343171954155f, _1521, mad(0.8596711158752441f, _1520, (_1519 * 0.044794563204050064f))) - _1437) * cb0_012w) + _1437;
          _1539 = ((mad(1.0015007257461548f, _1521, mad(0.004025210160762072f, _1520, (_1519 * -0.005525882821530104f))) - _1440) * cb0_012w) + _1440;
          _1543 = max(max(_1537, _1538), _1539);
          _1548 = (max(_1543, 1.000000013351432e-10f) - max(min(min(_1537, _1538), _1539), 1.000000013351432e-10f)) / max(_1543, 0.009999999776482582f);
          _1561 = ((_1538 + _1537) + _1539) + (sqrt((((_1539 - _1538) * _1539) + ((_1538 - _1537) * _1538)) + ((_1537 - _1539) * _1537)) * 1.75f);
          _1562 = _1561 * 0.3333333432674408f;
          _1563 = _1548 + -0.4000000059604645f;
          _1564 = _1563 * 5.0f;
          _1568 = max((1.0f - abs(_1563 * 2.5f)), 0.0f);
          _1579 = ((float((int)(((int)(uint)((int)(_1564 > 0.0f))) - ((int)(uint)((int)(_1564 < 0.0f))))) * (1.0f - (_1568 * _1568))) + 1.0f) * 0.02500000037252903f;
          do {
            _1588 = _1579;
            if (!(_1562 <= 0.0533333346247673f)) {
              if (!(_1562 >= 0.1599999964237213f)) {
                _1588 = (((0.23999999463558197f / _1561) + -0.5f) * _1579);
              } else {
                _1588 = 0.0f;
              }
            }
            _1589 = _1588 + 1.0f;
            _1590 = _1589 * _1537;
            _1591 = _1589 * _1538;
            _1592 = _1589 * _1539;
            do {
              _1621 = 0.0f;
              if (!((_1590 == _1591) && (_1591 == _1592))) {
                _1599 = ((_1590 * 2.0f) - _1591) - _1592;
                _1602 = ((_1538 - _1539) * 1.7320507764816284f) * _1589;
                _1604 = atan(_1602 / _1599);
                _1607 = (_1599 < 0.0f);
                _1608 = (_1599 == 0.0f);
                _1609 = (_1602 >= 0.0f);
                _1610 = (_1602 < 0.0f);
                _1621 = select((_1609 && _1608), 90.0f, select((_1610 && _1608), -90.0f, (select((_1610 && _1607), (_1604 + -3.1415927410125732f), select((_1609 && _1607), (_1604 + 3.1415927410125732f), _1604)) * 57.2957763671875f)));
              }
              _1626 = min(max(select((_1621 < 0.0f), (_1621 + 360.0f), _1621), 0.0f), 360.0f);
              do {
                if (_1626 < -180.0f) {
                  _1635 = (_1626 + 360.0f);
                } else {
                  if (_1626 > 180.0f) {
                    _1635 = (_1626 + -360.0f);
                  } else {
                    _1635 = _1626;
                  }
                }
                do {
                  _1674 = 0.0f;
                  if ((_1635 > -67.5f) && (_1635 < 67.5f)) {
                    _1641 = (_1635 + 67.5f) * 0.029629629105329514f;
                    _1642 = int(_1641);
                    _1644 = _1641 - float((int)(_1642));
                    _1645 = _1644 * _1644;
                    _1646 = _1645 * _1644;
                    if (_1642 == 3) {
                      _1674 = (((0.1666666716337204f - (_1644 * 0.5f)) + (_1645 * 0.5f)) - (_1646 * 0.1666666716337204f));
                    } else {
                      if (_1642 == 2) {
                        _1674 = ((0.6666666865348816f - _1645) + (_1646 * 0.5f));
                      } else {
                        if (_1642 == 1) {
                          _1674 = (((_1646 * -0.5f) + 0.1666666716337204f) + ((_1645 + _1644) * 0.5f));
                        } else {
                          _1674 = select((_1642 == 0), (_1646 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  }
                  _1683 = min(max(((((_1548 * 0.27000001072883606f) * (0.029999999329447746f - _1590)) * _1674) + _1590), 0.0f), 65535.0f);
                  _1684 = min(max(_1591, 0.0f), 65535.0f);
                  _1685 = min(max(_1592, 0.0f), 65535.0f);
                  _1698 = min(max(mad(-0.21492856740951538f, _1685, mad(-0.2365107536315918f, _1684, (_1683 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  _1699 = min(max(mad(-0.09967592358589172f, _1685, mad(1.17622971534729f, _1684, (_1683 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  _1700 = min(max(mad(0.9977163076400757f, _1685, mad(-0.006032449658960104f, _1684, (_1683 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  _1701 = dot(float3(_1698, _1699, _1700), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  _1724 = log2(max((lerp(_1701, _1698, 0.9599999785423279f)), 1.000000013351432e-10f));
                  _1725 = _1724 * 0.3010300099849701f;
                  _1726 = log2(cb0_008x);
                  _1727 = _1726 * 0.3010300099849701f;
                  do {
                    if (!(!(_1725 <= _1727))) {
                      _1796 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      _1734 = log2(cb0_009x);
                      _1735 = _1734 * 0.3010300099849701f;
                      if ((_1725 > _1727) && (_1725 < _1735)) {
                        _1743 = ((_1724 - _1726) * 0.9030900001525879f) / ((_1734 - _1726) * 0.3010300099849701f);
                        _1744 = int(_1743);
                        _1746 = _1743 - float((int)(_1744));
                        _1748 = _17[min((uint)(_1744), 5u)];
                        _1751 = _17[min((uint)((_1744 + 1)), 5u)];
                        _1756 = _1748 * 0.5f;
                        _1796 = dot(float3((_1746 * _1746), _1746, 1.0f), float3(mad((_17[min((uint)((_1744 + 2)), 5u)]), 0.5f, mad(_1751, -1.0f, _1756)), (_1751 - _1748), mad(_1751, 0.5f, _1756)));
                      } else {
                        if (!(!(_1725 >= _1735))) {
                          _1765 = log2(cb0_008z);
                          if (_1725 < (_1765 * 0.3010300099849701f)) {
                            _1773 = ((_1724 - _1734) * 0.9030900001525879f) / ((_1765 - _1734) * 0.3010300099849701f);
                            _1774 = int(_1773);
                            _1776 = _1773 - float((int)(_1774));
                            _1778 = _18[min((uint)(_1774), 5u)];
                            _1781 = _18[min((uint)((_1774 + 1)), 5u)];
                            _1786 = _1778 * 0.5f;
                            _1796 = dot(float3((_1776 * _1776), _1776, 1.0f), float3(mad((_18[min((uint)((_1774 + 2)), 5u)]), 0.5f, mad(_1781, -1.0f, _1786)), (_1781 - _1778), mad(_1781, 0.5f, _1786)));
                          } else {
                            _1796 = (log2(cb0_008w) * 0.3010300099849701f);
                          }
                        } else {
                          _1796 = (log2(cb0_008w) * 0.3010300099849701f);
                        }
                      }
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
                    _1812 = log2(max((lerp(_1701, _1699, 0.9599999785423279f)), 1.000000013351432e-10f));
                    _1813 = _1812 * 0.3010300099849701f;
                    do {
                      if (!(!(_1813 <= _1727))) {
                        _1882 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        _1820 = log2(cb0_009x);
                        _1821 = _1820 * 0.3010300099849701f;
                        if ((_1813 > _1727) && (_1813 < _1821)) {
                          _1829 = ((_1812 - _1726) * 0.9030900001525879f) / ((_1820 - _1726) * 0.3010300099849701f);
                          _1830 = int(_1829);
                          _1832 = _1829 - float((int)(_1830));
                          _1834 = _19[min((uint)(_1830), 5u)];
                          _1837 = _19[min((uint)((_1830 + 1)), 5u)];
                          _1842 = _1834 * 0.5f;
                          _1882 = dot(float3((_1832 * _1832), _1832, 1.0f), float3(mad((_19[min((uint)((_1830 + 2)), 5u)]), 0.5f, mad(_1837, -1.0f, _1842)), (_1837 - _1834), mad(_1837, 0.5f, _1842)));
                        } else {
                          if (!(!(_1813 >= _1821))) {
                            _1851 = log2(cb0_008z);
                            if (_1813 < (_1851 * 0.3010300099849701f)) {
                              _1859 = ((_1812 - _1820) * 0.9030900001525879f) / ((_1851 - _1820) * 0.3010300099849701f);
                              _1860 = int(_1859);
                              _1862 = _1859 - float((int)(_1860));
                              _1864 = _20[min((uint)(_1860), 5u)];
                              _1867 = _20[min((uint)((_1860 + 1)), 5u)];
                              _1872 = _1864 * 0.5f;
                              _1882 = dot(float3((_1862 * _1862), _1862, 1.0f), float3(mad((_20[min((uint)((_1860 + 2)), 5u)]), 0.5f, mad(_1867, -1.0f, _1872)), (_1867 - _1864), mad(_1867, 0.5f, _1872)));
                            } else {
                              _1882 = (log2(cb0_008w) * 0.3010300099849701f);
                            }
                          } else {
                            _1882 = (log2(cb0_008w) * 0.3010300099849701f);
                          }
                        }
                      }
                      _1886 = log2(max((lerp(_1701, _1700, 0.9599999785423279f)), 1.000000013351432e-10f));
                      _1887 = _1886 * 0.3010300099849701f;
                      do {
                        if (!(!(_1887 <= _1727))) {
                          _1956 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          _1894 = log2(cb0_009x);
                          _1895 = _1894 * 0.3010300099849701f;
                          if ((_1887 > _1727) && (_1887 < _1895)) {
                            _1903 = ((_1886 - _1726) * 0.9030900001525879f) / ((_1894 - _1726) * 0.3010300099849701f);
                            _1904 = int(_1903);
                            _1906 = _1903 - float((int)(_1904));
                            _1908 = _9[min((uint)(_1904), 5u)];
                            _1911 = _9[min((uint)((_1904 + 1)), 5u)];
                            _1916 = _1908 * 0.5f;
                            _1956 = dot(float3((_1906 * _1906), _1906, 1.0f), float3(mad((_9[min((uint)((_1904 + 2)), 5u)]), 0.5f, mad(_1911, -1.0f, _1916)), (_1911 - _1908), mad(_1911, 0.5f, _1916)));
                          } else {
                            if (!(!(_1887 >= _1895))) {
                              _1925 = log2(cb0_008z);
                              if (_1887 < (_1925 * 0.3010300099849701f)) {
                                _1933 = ((_1886 - _1894) * 0.9030900001525879f) / ((_1925 - _1894) * 0.3010300099849701f);
                                _1934 = int(_1933);
                                _1936 = _1933 - float((int)(_1934));
                                _1938 = _10[min((uint)(_1934), 5u)];
                                _1941 = _10[min((uint)((_1934 + 1)), 5u)];
                                _1946 = _1938 * 0.5f;
                                _1956 = dot(float3((_1936 * _1936), _1936, 1.0f), float3(mad((_10[min((uint)((_1934 + 2)), 5u)]), 0.5f, mad(_1941, -1.0f, _1946)), (_1941 - _1938), mad(_1941, 0.5f, _1946)));
                              } else {
                                _1956 = (log2(cb0_008w) * 0.3010300099849701f);
                              }
                            } else {
                              _1956 = (log2(cb0_008w) * 0.3010300099849701f);
                            }
                          }
                        }
                        _1960 = cb0_008w - cb0_008y;
                        _1961 = (exp2(_1796 * 3.321928024291992f) - cb0_008y) / _1960;
                        _1963 = (exp2(_1882 * 3.321928024291992f) - cb0_008y) / _1960;
                        _1965 = (exp2(_1956 * 3.321928024291992f) - cb0_008y) / _1960;
                        _1968 = mad(0.15618768334388733f, _1965, mad(0.13400420546531677f, _1963, (_1961 * 0.6624541878700256f)));
                        _1971 = mad(0.053689517080783844f, _1965, mad(0.6740817427635193f, _1963, (_1961 * 0.2722287178039551f)));
                        _1974 = mad(1.0103391408920288f, _1965, mad(0.00406073359772563f, _1963, (_1961 * -0.005574649665504694f)));
                        _1987 = min(max(mad(-0.23642469942569733f, _1974, mad(-0.32480329275131226f, _1971, (_1968 * 1.6410233974456787f))), 0.0f), 1.0f);
                        _1988 = min(max(mad(0.016756348311901093f, _1974, mad(1.6153316497802734f, _1971, (_1968 * -0.663662850856781f))), 0.0f), 1.0f);
                        _1989 = min(max(mad(0.9883948564529419f, _1974, mad(-0.008284442126750946f, _1971, (_1968 * 0.011721894145011902f))), 0.0f), 1.0f);
                        _1992 = mad(0.15618768334388733f, _1989, mad(0.13400420546531677f, _1988, (_1987 * 0.6624541878700256f)));
                        _1995 = mad(0.053689517080783844f, _1989, mad(0.6740817427635193f, _1988, (_1987 * 0.2722287178039551f)));
                        _1998 = mad(1.0103391408920288f, _1989, mad(0.00406073359772563f, _1988, (_1987 * -0.005574649665504694f)));
                        _2020 = min(max((min(max(mad(-0.23642469942569733f, _1998, mad(-0.32480329275131226f, _1995, (_1992 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        _2021 = min(max((min(max(mad(0.016756348311901093f, _1998, mad(1.6153316497802734f, _1995, (_1992 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        _2022 = min(max((min(max(mad(0.9883948564529419f, _1998, mad(-0.008284442126750946f, _1995, (_1992 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          _2035 = _2020;
                          _2036 = _2021;
                          _2037 = _2022;
                          if (!(cb0_040w == 5)) {
                            _2035 = mad(_63, _2022, mad(_62, _2021, (_2020 * _61)));
                            _2036 = mad(_66, _2022, mad(_65, _2021, (_2020 * _64)));
                            _2037 = mad(_69, _2022, mad(_68, _2021, (_2020 * _67)));
                          }
                          _2047 = exp2(log2(_2035 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2048 = exp2(log2(_2036 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2049 = exp2(log2(_2037 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2912 = exp2(log2((1.0f / ((_2047 * 18.6875f) + 1.0f)) * ((_2047 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2913 = exp2(log2((1.0f / ((_2048 * 18.6875f) + 1.0f)) * ((_2048 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2914 = exp2(log2((1.0f / ((_2049 * 18.6875f) + 1.0f)) * ((_2049 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((cb0_040w & -3) == 4) {
          _2115 = cb0_012z * _1228;
          _2116 = cb0_012z * _1229;
          _2117 = cb0_012z * _1230;
          _2120 = mad((WorkingColorSpace_256[0].z), _2117, mad((WorkingColorSpace_256[0].y), _2116, ((WorkingColorSpace_256[0].x) * _2115)));
          _2123 = mad((WorkingColorSpace_256[1].z), _2117, mad((WorkingColorSpace_256[1].y), _2116, ((WorkingColorSpace_256[1].x) * _2115)));
          _2126 = mad((WorkingColorSpace_256[2].z), _2117, mad((WorkingColorSpace_256[2].y), _2116, ((WorkingColorSpace_256[2].x) * _2115)));
          _2129 = mad(-0.21492856740951538f, _2126, mad(-0.2365107536315918f, _2123, (_2120 * 1.4514392614364624f)));
          _2132 = mad(-0.09967592358589172f, _2126, mad(1.17622971534729f, _2123, (_2120 * -0.07655377686023712f)));
          _2135 = mad(0.9977163076400757f, _2126, mad(-0.006032449658960104f, _2123, (_2120 * 0.008316148072481155f)));
          _2137 = max(_2129, max(_2132, _2135));
          do {
            _2205 = _2129;
            _2206 = _2132;
            _2207 = _2135;
            if (!(_2137 < 1.000000013351432e-10f)) {
              if (!(((_2120 < 0.0f) || (_2123 < 0.0f)) || (_2126 < 0.0f))) {
                _2147 = abs(_2137);
                _2148 = (_2137 - _2129) / _2147;
                _2150 = (_2137 - _2132) / _2147;
                _2152 = (_2137 - _2135) / _2147;
                do {
                  _2167 = _2148;
                  if (!(_2148 < 0.8149999976158142f)) {
                    _2155 = _2148 + -0.8149999976158142f;
                    _2167 = ((_2155 / exp2(log2(exp2(log2(_2155 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  }
                  do {
                    _2182 = _2150;
                    if (!(_2150 < 0.8029999732971191f)) {
                      _2170 = _2150 + -0.8029999732971191f;
                      _2182 = ((_2170 / exp2(log2(exp2(log2(_2170 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    }
                    do {
                      _2197 = _2152;
                      if (!(_2152 < 0.8799999952316284f)) {
                        _2185 = _2152 + -0.8799999952316284f;
                        _2197 = ((_2185 / exp2(log2(exp2(log2(_2185 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      }
                      _2205 = (_2137 - (_2147 * _2167));
                      _2206 = (_2137 - (_2147 * _2182));
                      _2207 = (_2137 - (_2147 * _2197));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2205 = _2129;
                _2206 = _2132;
                _2207 = _2135;
              }
            }
            _2223 = ((mad(0.16386906802654266f, _2207, mad(0.14067870378494263f, _2206, (_2205 * 0.6954522132873535f))) - _2120) * cb0_012w) + _2120;
            _2224 = ((mad(0.0955343171954155f, _2207, mad(0.8596711158752441f, _2206, (_2205 * 0.044794563204050064f))) - _2123) * cb0_012w) + _2123;
            _2225 = ((mad(1.0015007257461548f, _2207, mad(0.004025210160762072f, _2206, (_2205 * -0.005525882821530104f))) - _2126) * cb0_012w) + _2126;
            _2229 = max(max(_2223, _2224), _2225);
            _2234 = (max(_2229, 1.000000013351432e-10f) - max(min(min(_2223, _2224), _2225), 1.000000013351432e-10f)) / max(_2229, 0.009999999776482582f);
            _2247 = ((_2224 + _2223) + _2225) + (sqrt((((_2225 - _2224) * _2225) + ((_2224 - _2223) * _2224)) + ((_2223 - _2225) * _2223)) * 1.75f);
            _2248 = _2247 * 0.3333333432674408f;
            _2249 = _2234 + -0.4000000059604645f;
            _2250 = _2249 * 5.0f;
            _2254 = max((1.0f - abs(_2249 * 2.5f)), 0.0f);
            _2265 = ((float((int)(((int)(uint)((int)(_2250 > 0.0f))) - ((int)(uint)((int)(_2250 < 0.0f))))) * (1.0f - (_2254 * _2254))) + 1.0f) * 0.02500000037252903f;
            do {
              _2274 = _2265;
              if (!(_2248 <= 0.0533333346247673f)) {
                if (!(_2248 >= 0.1599999964237213f)) {
                  _2274 = (((0.23999999463558197f / _2247) + -0.5f) * _2265);
                } else {
                  _2274 = 0.0f;
                }
              }
              _2275 = _2274 + 1.0f;
              _2276 = _2275 * _2223;
              _2277 = _2275 * _2224;
              _2278 = _2275 * _2225;
              do {
                _2307 = 0.0f;
                if (!((_2276 == _2277) && (_2277 == _2278))) {
                  _2285 = ((_2276 * 2.0f) - _2277) - _2278;
                  _2288 = ((_2224 - _2225) * 1.7320507764816284f) * _2275;
                  _2290 = atan(_2288 / _2285);
                  _2293 = (_2285 < 0.0f);
                  _2294 = (_2285 == 0.0f);
                  _2295 = (_2288 >= 0.0f);
                  _2296 = (_2288 < 0.0f);
                  _2307 = select((_2295 && _2294), 90.0f, select((_2296 && _2294), -90.0f, (select((_2296 && _2293), (_2290 + -3.1415927410125732f), select((_2295 && _2293), (_2290 + 3.1415927410125732f), _2290)) * 57.2957763671875f)));
                }
                _2312 = min(max(select((_2307 < 0.0f), (_2307 + 360.0f), _2307), 0.0f), 360.0f);
                do {
                  if (_2312 < -180.0f) {
                    _2321 = (_2312 + 360.0f);
                  } else {
                    if (_2312 > 180.0f) {
                      _2321 = (_2312 + -360.0f);
                    } else {
                      _2321 = _2312;
                    }
                  }
                  do {
                    _2360 = 0.0f;
                    if ((_2321 > -67.5f) && (_2321 < 67.5f)) {
                      _2327 = (_2321 + 67.5f) * 0.029629629105329514f;
                      _2328 = int(_2327);
                      _2330 = _2327 - float((int)(_2328));
                      _2331 = _2330 * _2330;
                      _2332 = _2331 * _2330;
                      if (_2328 == 3) {
                        _2360 = (((0.1666666716337204f - (_2330 * 0.5f)) + (_2331 * 0.5f)) - (_2332 * 0.1666666716337204f));
                      } else {
                        if (_2328 == 2) {
                          _2360 = ((0.6666666865348816f - _2331) + (_2332 * 0.5f));
                        } else {
                          if (_2328 == 1) {
                            _2360 = (((_2332 * -0.5f) + 0.1666666716337204f) + ((_2331 + _2330) * 0.5f));
                          } else {
                            _2360 = select((_2328 == 0), (_2332 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    }
                    _2369 = min(max(((((_2234 * 0.27000001072883606f) * (0.029999999329447746f - _2276)) * _2360) + _2276), 0.0f), 65535.0f);
                    _2370 = min(max(_2277, 0.0f), 65535.0f);
                    _2371 = min(max(_2278, 0.0f), 65535.0f);
                    _2384 = min(max(mad(-0.21492856740951538f, _2371, mad(-0.2365107536315918f, _2370, (_2369 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    _2385 = min(max(mad(-0.09967592358589172f, _2371, mad(1.17622971534729f, _2370, (_2369 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    _2386 = min(max(mad(0.9977163076400757f, _2371, mad(-0.006032449658960104f, _2370, (_2369 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    _2387 = dot(float3(_2384, _2385, _2386), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    _2410 = log2(max((lerp(_2387, _2384, 0.9599999785423279f)), 1.000000013351432e-10f));
                    _2411 = _2410 * 0.3010300099849701f;
                    _2412 = log2(cb0_008x);
                    _2413 = _2412 * 0.3010300099849701f;
                    do {
                      if (!(!(_2411 <= _2413))) {
                        _2482 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        _2420 = log2(cb0_009x);
                        _2421 = _2420 * 0.3010300099849701f;
                        if ((_2411 > _2413) && (_2411 < _2421)) {
                          _2429 = ((_2410 - _2412) * 0.9030900001525879f) / ((_2420 - _2412) * 0.3010300099849701f);
                          _2430 = int(_2429);
                          _2432 = _2429 - float((int)(_2430));
                          _2434 = _15[min((uint)(_2430), 5u)];
                          _2437 = _15[min((uint)((_2430 + 1)), 5u)];
                          _2442 = _2434 * 0.5f;
                          _2482 = dot(float3((_2432 * _2432), _2432, 1.0f), float3(mad((_15[min((uint)((_2430 + 2)), 5u)]), 0.5f, mad(_2437, -1.0f, _2442)), (_2437 - _2434), mad(_2437, 0.5f, _2442)));
                        } else {
                          if (!(!(_2411 >= _2421))) {
                            _2451 = log2(cb0_008z);
                            if (_2411 < (_2451 * 0.3010300099849701f)) {
                              _2459 = ((_2410 - _2420) * 0.9030900001525879f) / ((_2451 - _2420) * 0.3010300099849701f);
                              _2460 = int(_2459);
                              _2462 = _2459 - float((int)(_2460));
                              _2464 = _16[min((uint)(_2460), 5u)];
                              _2467 = _16[min((uint)((_2460 + 1)), 5u)];
                              _2472 = _2464 * 0.5f;
                              _2482 = dot(float3((_2462 * _2462), _2462, 1.0f), float3(mad((_16[min((uint)((_2460 + 2)), 5u)]), 0.5f, mad(_2467, -1.0f, _2472)), (_2467 - _2464), mad(_2467, 0.5f, _2472)));
                            } else {
                              _2482 = (log2(cb0_008w) * 0.3010300099849701f);
                            }
                          } else {
                            _2482 = (log2(cb0_008w) * 0.3010300099849701f);
                          }
                        }
                      }
                      _11[0] = cb0_010x;
                      _11[1] = cb0_010y;
                      _11[2] = cb0_010z;
                      _11[3] = cb0_010w;
                      _11[4] = cb0_012x;
                      _11[5] = cb0_012x;
                      _12[0] = cb0_011x;
                      _12[1] = cb0_011y;
                      _12[2] = cb0_011z;
                      _12[3] = cb0_011w;
                      _12[4] = cb0_012y;
                      _12[5] = cb0_012y;
                      _2498 = log2(max((lerp(_2387, _2385, 0.9599999785423279f)), 1.000000013351432e-10f));
                      _2499 = _2498 * 0.3010300099849701f;
                      do {
                        if (!(!(_2499 <= _2413))) {
                          _2568 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          _2506 = log2(cb0_009x);
                          _2507 = _2506 * 0.3010300099849701f;
                          if ((_2499 > _2413) && (_2499 < _2507)) {
                            _2515 = ((_2498 - _2412) * 0.9030900001525879f) / ((_2506 - _2412) * 0.3010300099849701f);
                            _2516 = int(_2515);
                            _2518 = _2515 - float((int)(_2516));
                            _2520 = _11[min((uint)(_2516), 5u)];
                            _2523 = _11[min((uint)((_2516 + 1)), 5u)];
                            _2528 = _2520 * 0.5f;
                            _2568 = dot(float3((_2518 * _2518), _2518, 1.0f), float3(mad((_11[min((uint)((_2516 + 2)), 5u)]), 0.5f, mad(_2523, -1.0f, _2528)), (_2523 - _2520), mad(_2523, 0.5f, _2528)));
                          } else {
                            if (!(!(_2499 >= _2507))) {
                              _2537 = log2(cb0_008z);
                              if (_2499 < (_2537 * 0.3010300099849701f)) {
                                _2545 = ((_2498 - _2506) * 0.9030900001525879f) / ((_2537 - _2506) * 0.3010300099849701f);
                                _2546 = int(_2545);
                                _2548 = _2545 - float((int)(_2546));
                                _2550 = _12[min((uint)(_2546), 5u)];
                                _2553 = _12[min((uint)((_2546 + 1)), 5u)];
                                _2558 = _2550 * 0.5f;
                                _2568 = dot(float3((_2548 * _2548), _2548, 1.0f), float3(mad((_12[min((uint)((_2546 + 2)), 5u)]), 0.5f, mad(_2553, -1.0f, _2558)), (_2553 - _2550), mad(_2553, 0.5f, _2558)));
                              } else {
                                _2568 = (log2(cb0_008w) * 0.3010300099849701f);
                              }
                            } else {
                              _2568 = (log2(cb0_008w) * 0.3010300099849701f);
                            }
                          }
                        }
                        _13[0] = cb0_010x;
                        _13[1] = cb0_010y;
                        _13[2] = cb0_010z;
                        _13[3] = cb0_010w;
                        _13[4] = cb0_012x;
                        _13[5] = cb0_012x;
                        _14[0] = cb0_011x;
                        _14[1] = cb0_011y;
                        _14[2] = cb0_011z;
                        _14[3] = cb0_011w;
                        _14[4] = cb0_012y;
                        _14[5] = cb0_012y;
                        _2584 = log2(max((lerp(_2387, _2386, 0.9599999785423279f)), 1.000000013351432e-10f));
                        _2585 = _2584 * 0.3010300099849701f;
                        do {
                          if (!(!(_2585 <= _2413))) {
                            _2654 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            _2592 = log2(cb0_009x);
                            _2593 = _2592 * 0.3010300099849701f;
                            if ((_2585 > _2413) && (_2585 < _2593)) {
                              _2601 = ((_2584 - _2412) * 0.9030900001525879f) / ((_2592 - _2412) * 0.3010300099849701f);
                              _2602 = int(_2601);
                              _2604 = _2601 - float((int)(_2602));
                              _2606 = _13[min((uint)(_2602), 5u)];
                              _2609 = _13[min((uint)((_2602 + 1)), 5u)];
                              _2614 = _2606 * 0.5f;
                              _2654 = dot(float3((_2604 * _2604), _2604, 1.0f), float3(mad((_13[min((uint)((_2602 + 2)), 5u)]), 0.5f, mad(_2609, -1.0f, _2614)), (_2609 - _2606), mad(_2609, 0.5f, _2614)));
                            } else {
                              if (!(!(_2585 >= _2593))) {
                                _2623 = log2(cb0_008z);
                                if (_2585 < (_2623 * 0.3010300099849701f)) {
                                  _2631 = ((_2584 - _2592) * 0.9030900001525879f) / ((_2623 - _2592) * 0.3010300099849701f);
                                  _2632 = int(_2631);
                                  _2634 = _2631 - float((int)(_2632));
                                  _2636 = _14[min((uint)(_2632), 5u)];
                                  _2639 = _14[min((uint)((_2632 + 1)), 5u)];
                                  _2644 = _2636 * 0.5f;
                                  _2654 = dot(float3((_2634 * _2634), _2634, 1.0f), float3(mad((_14[min((uint)((_2632 + 2)), 5u)]), 0.5f, mad(_2639, -1.0f, _2644)), (_2639 - _2636), mad(_2639, 0.5f, _2644)));
                                } else {
                                  _2654 = (log2(cb0_008w) * 0.3010300099849701f);
                                }
                              } else {
                                _2654 = (log2(cb0_008w) * 0.3010300099849701f);
                              }
                            }
                          }
                          _2658 = cb0_008w - cb0_008y;
                          _2659 = (exp2(_2482 * 3.321928024291992f) - cb0_008y) / _2658;
                          _2661 = (exp2(_2568 * 3.321928024291992f) - cb0_008y) / _2658;
                          _2663 = (exp2(_2654 * 3.321928024291992f) - cb0_008y) / _2658;
                          _2666 = mad(0.15618768334388733f, _2663, mad(0.13400420546531677f, _2661, (_2659 * 0.6624541878700256f)));
                          _2669 = mad(0.053689517080783844f, _2663, mad(0.6740817427635193f, _2661, (_2659 * 0.2722287178039551f)));
                          _2672 = mad(1.0103391408920288f, _2663, mad(0.00406073359772563f, _2661, (_2659 * -0.005574649665504694f)));
                          _2685 = min(max(mad(-0.23642469942569733f, _2672, mad(-0.32480329275131226f, _2669, (_2666 * 1.6410233974456787f))), 0.0f), 1.0f);
                          _2686 = min(max(mad(0.016756348311901093f, _2672, mad(1.6153316497802734f, _2669, (_2666 * -0.663662850856781f))), 0.0f), 1.0f);
                          _2687 = min(max(mad(0.9883948564529419f, _2672, mad(-0.008284442126750946f, _2669, (_2666 * 0.011721894145011902f))), 0.0f), 1.0f);
                          _2690 = mad(0.15618768334388733f, _2687, mad(0.13400420546531677f, _2686, (_2685 * 0.6624541878700256f)));
                          _2693 = mad(0.053689517080783844f, _2687, mad(0.6740817427635193f, _2686, (_2685 * 0.2722287178039551f)));
                          _2696 = mad(1.0103391408920288f, _2687, mad(0.00406073359772563f, _2686, (_2685 * -0.005574649665504694f)));
                          _2718 = min(max((min(max(mad(-0.23642469942569733f, _2696, mad(-0.32480329275131226f, _2693, (_2690 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          _2719 = min(max((min(max(mad(0.016756348311901093f, _2696, mad(1.6153316497802734f, _2693, (_2690 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          _2720 = min(max((min(max(mad(0.9883948564529419f, _2696, mad(-0.008284442126750946f, _2693, (_2690 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            _2733 = _2718;
                            _2734 = _2719;
                            _2735 = _2720;
                            if (!(cb0_040w == 6)) {
                              _2733 = mad(_63, _2720, mad(_62, _2719, (_2718 * _61)));
                              _2734 = mad(_66, _2720, mad(_65, _2719, (_2718 * _64)));
                              _2735 = mad(_69, _2720, mad(_68, _2719, (_2718 * _67)));
                            }
                            _2745 = exp2(log2(_2733 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2746 = exp2(log2(_2734 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2747 = exp2(log2(_2735 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2912 = exp2(log2((1.0f / ((_2745 * 18.6875f) + 1.0f)) * ((_2745 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2913 = exp2(log2((1.0f / ((_2746 * 18.6875f) + 1.0f)) * ((_2746 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2914 = exp2(log2((1.0f / ((_2747 * 18.6875f) + 1.0f)) * ((_2747 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (cb0_040w == 7) {
            _2792 = mad((WorkingColorSpace_128[0].z), _1230, mad((WorkingColorSpace_128[0].y), _1229, ((WorkingColorSpace_128[0].x) * _1228)));
            _2795 = mad((WorkingColorSpace_128[1].z), _1230, mad((WorkingColorSpace_128[1].y), _1229, ((WorkingColorSpace_128[1].x) * _1228)));
            _2798 = mad((WorkingColorSpace_128[2].z), _1230, mad((WorkingColorSpace_128[2].y), _1229, ((WorkingColorSpace_128[2].x) * _1228)));
            _2817 = exp2(log2(mad(_63, _2798, mad(_62, _2795, (_2792 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2818 = exp2(log2(mad(_66, _2798, mad(_65, _2795, (_2792 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2819 = exp2(log2(mad(_69, _2798, mad(_68, _2795, (_2792 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2912 = exp2(log2((1.0f / ((_2817 * 18.6875f) + 1.0f)) * ((_2817 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2913 = exp2(log2((1.0f / ((_2818 * 18.6875f) + 1.0f)) * ((_2818 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2914 = exp2(log2((1.0f / ((_2819 * 18.6875f) + 1.0f)) * ((_2819 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                _2866 = mad((WorkingColorSpace_128[0].z), _1218, mad((WorkingColorSpace_128[0].y), _1217, ((WorkingColorSpace_128[0].x) * _1216)));
                _2869 = mad((WorkingColorSpace_128[1].z), _1218, mad((WorkingColorSpace_128[1].y), _1217, ((WorkingColorSpace_128[1].x) * _1216)));
                _2872 = mad((WorkingColorSpace_128[2].z), _1218, mad((WorkingColorSpace_128[2].y), _1217, ((WorkingColorSpace_128[2].x) * _1216)));
                _2912 = mad(_63, _2872, mad(_62, _2869, (_2866 * _61)));
                _2913 = mad(_66, _2872, mad(_65, _2869, (_2866 * _64)));
                _2914 = mad(_69, _2872, mad(_68, _2869, (_2866 * _67)));
              } else {
                _2885 = mad((WorkingColorSpace_128[0].z), _1244, mad((WorkingColorSpace_128[0].y), _1243, ((WorkingColorSpace_128[0].x) * _1242)));
                _2888 = mad((WorkingColorSpace_128[1].z), _1244, mad((WorkingColorSpace_128[1].y), _1243, ((WorkingColorSpace_128[1].x) * _1242)));
                _2891 = mad((WorkingColorSpace_128[2].z), _1244, mad((WorkingColorSpace_128[2].y), _1243, ((WorkingColorSpace_128[2].x) * _1242)));
                _2912 = exp2(log2(mad(_63, _2891, mad(_62, _2888, (_2885 * _61)))) * cb0_040z);
                _2913 = exp2(log2(mad(_66, _2891, mad(_65, _2888, (_2885 * _64)))) * cb0_040z);
                _2914 = exp2(log2(mad(_69, _2891, mad(_68, _2888, (_2885 * _67)))) * cb0_040z);
              }
            } else {
              _2912 = _1228;
              _2913 = _1229;
              _2914 = _1230;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_2912 * 0.9523810148239136f), (_2913 * 0.9523810148239136f), (_2914 * 0.9523810148239136f), 0.0f);
}
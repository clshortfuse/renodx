// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
  float cb0_006x : packoffset(c006.x);
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

SamplerState s3 : register(s3);

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
  float _38;
  float _43;
  float _44;
  float _45;
  float _47;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _72;
  float _73;
  float _74;
  float _75;
  float _133;
  float _134;
  float _135;
  float _190;
  float _397;
  float _398;
  float _399;
  float _922;
  float _955;
  float _969;
  float _1033;
  float _1212;
  float _1223;
  float _1234;
  float _1484;
  float _1485;
  float _1486;
  float _1497;
  float _1508;
  float _1677;
  float _1692;
  float _1707;
  float _1715;
  float _1716;
  float _1717;
  float _1784;
  float _1817;
  float _1831;
  float _1870;
  float _1992;
  float _2066;
  float _2140;
  float _2345;
  float _2360;
  float _2375;
  float _2383;
  float _2384;
  float _2385;
  float _2452;
  float _2485;
  float _2499;
  float _2538;
  float _2660;
  float _2746;
  float _2832;
  float _3047;
  float _3048;
  float _3049;
  bool _56;
  float _86;
  float _87;
  float _88;
  bool _171;
  float _173;
  float _204;
  float _211;
  float _214;
  float _219;
  float _220;
  float _222;
  bool _223;
  float _232;
  float _234;
  float _241;
  float _243;
  float _245;
  float _246;
  float _249;
  float _252;
  float _257;
  float _263;
  float _264;
  float _265;
  float _266;
  float _267;
  float _268;
  float _269;
  float _270;
  float _273;
  float _274;
  float _275;
  float _278;
  float _297;
  float _298;
  float _299;
  float _300;
  float _301;
  float _302;
  float _303;
  float _304;
  float _305;
  float _308;
  float _311;
  float _314;
  float _317;
  float _320;
  float _323;
  float _326;
  float _329;
  float _332;
  float _335;
  float _338;
  float _341;
  float _344;
  float _347;
  float _350;
  float _353;
  float _356;
  float _359;
  float _414;
  float _417;
  float _420;
  float _421;
  float _425;
  float _426;
  float _427;
  float _439;
  float _455;
  float _456;
  float _457;
  float _458;
  float _472;
  float _486;
  float _500;
  float _514;
  float _528;
  float _532;
  float _533;
  float _534;
  float _591;
  float _595;
  float _596;
  float _605;
  float _614;
  float _623;
  float _632;
  float _641;
  float _704;
  float _708;
  float _717;
  float _726;
  float _735;
  float _744;
  float _753;
  float _811;
  float _822;
  float _824;
  float _826;
  float _862;
  float _863;
  float _864;
  float _867;
  float _870;
  float _873;
  float _877;
  float _882;
  float _895;
  float _896;
  float _897;
  float _898;
  float _902;
  float _913;
  float _923;
  float _924;
  float _925;
  float _926;
  float _933;
  float _936;
  float _938;
  bool _941;
  bool _942;
  bool _943;
  bool _944;
  float _960;
  float _973;
  float _977;
  float _983;
  float _993;
  float _994;
  float _995;
  float _996;
  float _1011;
  float _1013;
  float _1015;
  float _1024;
  float _1036;
  float _1038;
  float _1042;
  float _1043;
  float _1044;
  float _1048;
  float _1049;
  float _1050;
  float _1051;
  float _1053;
  float _1054;
  float _1055;
  float _1056;
  float _1075;
  float _1077;
  float _1102;
  float _1103;
  float _1104;
  float _1111;
  float _1115;
  float _1116;
  float _1117;
  bool _1118;
  float _1122;
  float _1123;
  float _1124;
  float _1143;
  float _1144;
  float _1145;
  float _1146;
  float _1166;
  float _1167;
  float _1168;
  float _1184;
  float _1185;
  float _1186;
  float _1199;
  float _1200;
  float _1201;
  float _1238;
  float _1245;
  float _1246;
  float _1247;
  float _1249;
  float4 _1252;
  float _1256;
  float4 _1257;
  float4 _1279;
  float4 _1283;
  float4 _1305;
  float4 _1309;
  float4 _1332;
  float4 _1336;
  float _1352;
  float _1353;
  float _1354;
  float _1379;
  float _1380;
  float _1381;
  float _1407;
  float _1408;
  float _1409;
  float _1416;
  float _1417;
  float _1418;
  float _1419;
  float _1420;
  float _1421;
  float _1428;
  float _1429;
  float _1430;
  float _1442;
  float _1443;
  float _1444;
  float _1467;
  float _1470;
  float _1473;
  float _1535;
  float _1538;
  float _1541;
  float _1544;
  float _1547;
  float _1550;
  float _1625;
  float _1626;
  float _1627;
  float _1630;
  float _1633;
  float _1636;
  float _1639;
  float _1642;
  float _1645;
  float _1647;
  float _1657;
  float _1658;
  float _1660;
  float _1662;
  float _1665;
  float _1680;
  float _1695;
  float _1733;
  float _1734;
  float _1735;
  float _1739;
  float _1744;
  float _1757;
  float _1758;
  float _1759;
  float _1760;
  float _1764;
  float _1775;
  float _1785;
  float _1786;
  float _1787;
  float _1788;
  float _1795;
  float _1798;
  float _1800;
  bool _1803;
  bool _1804;
  bool _1805;
  bool _1806;
  float _1822;
  float _1837;
  int _1838;
  float _1840;
  float _1841;
  float _1842;
  float _1879;
  float _1880;
  float _1881;
  float _1894;
  float _1895;
  float _1896;
  float _1897;
  float _1920;
  float _1921;
  float _1922;
  float _1923;
  float _1930;
  float _1931;
  float _1939;
  int _1940;
  float _1942;
  float _1944;
  float _1947;
  float _1952;
  float _1961;
  float _1969;
  int _1970;
  float _1972;
  float _1974;
  float _1977;
  float _1982;
  float _1996;
  float _1997;
  float _2004;
  float _2005;
  float _2013;
  int _2014;
  float _2016;
  float _2018;
  float _2021;
  float _2026;
  float _2035;
  float _2043;
  int _2044;
  float _2046;
  float _2048;
  float _2051;
  float _2056;
  float _2070;
  float _2071;
  float _2078;
  float _2079;
  float _2087;
  int _2088;
  float _2090;
  float _2092;
  float _2095;
  float _2100;
  float _2109;
  float _2117;
  int _2118;
  float _2120;
  float _2122;
  float _2125;
  float _2130;
  float _2144;
  float _2145;
  float _2147;
  float _2149;
  float _2152;
  float _2155;
  float _2158;
  float _2171;
  float _2172;
  float _2173;
  float _2176;
  float _2179;
  float _2182;
  float _2204;
  float _2205;
  float _2206;
  float _2225;
  float _2226;
  float _2227;
  float _2293;
  float _2294;
  float _2295;
  float _2298;
  float _2301;
  float _2304;
  float _2307;
  float _2310;
  float _2313;
  float _2315;
  float _2325;
  float _2326;
  float _2328;
  float _2330;
  float _2333;
  float _2348;
  float _2363;
  float _2401;
  float _2402;
  float _2403;
  float _2407;
  float _2412;
  float _2425;
  float _2426;
  float _2427;
  float _2428;
  float _2432;
  float _2443;
  float _2453;
  float _2454;
  float _2455;
  float _2456;
  float _2463;
  float _2466;
  float _2468;
  bool _2471;
  bool _2472;
  bool _2473;
  bool _2474;
  float _2490;
  float _2505;
  int _2506;
  float _2508;
  float _2509;
  float _2510;
  float _2547;
  float _2548;
  float _2549;
  float _2562;
  float _2563;
  float _2564;
  float _2565;
  float _2588;
  float _2589;
  float _2590;
  float _2591;
  float _2598;
  float _2599;
  float _2607;
  int _2608;
  float _2610;
  float _2612;
  float _2615;
  float _2620;
  float _2629;
  float _2637;
  int _2638;
  float _2640;
  float _2642;
  float _2645;
  float _2650;
  float _2676;
  float _2677;
  float _2684;
  float _2685;
  float _2693;
  int _2694;
  float _2696;
  float _2698;
  float _2701;
  float _2706;
  float _2715;
  float _2723;
  int _2724;
  float _2726;
  float _2728;
  float _2731;
  float _2736;
  float _2762;
  float _2763;
  float _2770;
  float _2771;
  float _2779;
  int _2780;
  float _2782;
  float _2784;
  float _2787;
  float _2792;
  float _2801;
  float _2809;
  int _2810;
  float _2812;
  float _2814;
  float _2817;
  float _2822;
  float _2836;
  float _2837;
  float _2839;
  float _2841;
  float _2844;
  float _2847;
  float _2850;
  float _2863;
  float _2864;
  float _2865;
  float _2868;
  float _2871;
  float _2874;
  float _2896;
  float _2899;
  float _2900;
  float _2927;
  float _2930;
  float _2933;
  float _2952;
  float _2953;
  float _2954;
  float _3001;
  float _3004;
  float _3007;
  float _3020;
  float _3023;
  float _3026;
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _21[6];
  float _22[6];
  float _23[6];
  float _24[6];
  float _25[6];
  float _26[6];
  _38 = 0.5f / cb0_037x;
  _43 = cb0_037x + -1.0f;
  _44 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _38)) / _43;
  _45 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _38)) / _43;
  _47 = float((uint)SV_DispatchThreadID.z) / _43;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _56 = (cb0_043x == 4);
        _67 = select(_56, 1.0f, 1.705051064491272f);
        _68 = select(_56, 0.0f, -0.6217921376228333f);
        _69 = select(_56, 0.0f, -0.0832589864730835f);
        _70 = select(_56, 0.0f, -0.13025647401809692f);
        _71 = select(_56, 1.0f, 1.140804648399353f);
        _72 = select(_56, 0.0f, -0.010548308491706848f);
        _73 = select(_56, 0.0f, -0.024003351107239723f);
        _74 = select(_56, 0.0f, -0.1289689838886261f);
        _75 = select(_56, 1.0f, 1.1529725790023804f);
      } else {
        _67 = 0.6954522132873535f;
        _68 = 0.14067870378494263f;
        _69 = 0.16386906802654266f;
        _70 = 0.044794563204050064f;
        _71 = 0.8596711158752441f;
        _72 = 0.0955343171954155f;
        _73 = -0.005525882821530104f;
        _74 = 0.004025210160762072f;
        _75 = 1.0015007257461548f;
      }
    } else {
      _67 = 1.0258246660232544f;
      _68 = -0.020053181797266006f;
      _69 = -0.005771636962890625f;
      _70 = -0.002234415616840124f;
      _71 = 1.0045864582061768f;
      _72 = -0.002352118492126465f;
      _73 = -0.005013350863009691f;
      _74 = -0.025290070101618767f;
      _75 = 1.0303035974502563f;
    }
  } else {
    _67 = 1.3792141675949097f;
    _68 = -0.30886411666870117f;
    _69 = -0.0703500509262085f;
    _70 = -0.06933490186929703f;
    _71 = 1.08229660987854f;
    _72 = -0.012961871922016144f;
    _73 = -0.0021590073592960835f;
    _74 = -0.0454593189060688f;
    _75 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _86 = (pow(_44, 0.012683313339948654f));
    _87 = (pow(_45, 0.012683313339948654f));
    _88 = (pow(_47, 0.012683313339948654f));
    _133 = (exp2(log2(max(0.0f, (_86 + -0.8359375f)) / (18.8515625f - (_86 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _134 = (exp2(log2(max(0.0f, (_87 + -0.8359375f)) / (18.8515625f - (_87 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _135 = (exp2(log2(max(0.0f, (_88 + -0.8359375f)) / (18.8515625f - (_88 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _133 = ((exp2((_44 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _134 = ((exp2((_45 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _135 = ((exp2((_47 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _171 = (cb0_040w != 0);
    _173 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _190 = (((((1901800.0f - (_173 * 2006400000.0f)) * _173) + 247.47999572753906f) * _173) + 0.23703999817371368f);
    } else {
      _190 = (((((2967800.0f - (_173 * 4607000064.0f)) * _173) + 99.11000061035156f) * _173) + 0.24406300485134125f);
    }
    _204 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _211 = cb0_037y * cb0_037y;
    _214 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_211 * 1.6145605741257896e-07f));
    _219 = ((_204 * 2.0f) + 4.0f) - (_214 * 8.0f);
    _220 = (_204 * 3.0f) / _219;
    _222 = (_214 * 2.0f) / _219;
    _223 = (cb0_037y < 4000.0f);
    _232 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _234 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_211 * 1.5317699909210205f)) / (_232 * _232);
    _241 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _211;
    _243 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_211 * 308.60699462890625f)) / (_241 * _241);
    _245 = rsqrt(dot(float2(_234, _243), float2(_234, _243)));
    _246 = cb0_037z * 0.05000000074505806f;
    _249 = ((_246 * _243) * _245) + _204;
    _252 = _214 - ((_246 * _234) * _245);
    _257 = (4.0f - (_252 * 8.0f)) + (_249 * 2.0f);
    _263 = (((_249 * 3.0f) / _257) - _220) + select(_223, _220, _190);
    _264 = (((_252 * 2.0f) / _257) - _222) + select(_223, _222, (((_190 * 2.869999885559082f) + -0.2750000059604645f) - ((_190 * _190) * 3.0f)));
    _265 = select(_171, _263, 0.3127000033855438f);
    _266 = select(_171, _264, 0.32899999618530273f);
    _267 = select(_171, 0.3127000033855438f, _263);
    _268 = select(_171, 0.32899999618530273f, _264);
    _269 = max(_266, 1.000000013351432e-10f);
    _270 = _265 / _269;
    _273 = ((1.0f - _265) - _266) / _269;
    _274 = max(_268, 1.000000013351432e-10f);
    _275 = _267 / _274;
    _278 = ((1.0f - _267) - _268) / _274;
    _297 = mad(-0.16140000522136688f, _278, ((_275 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _273, ((_270 * 0.8950999975204468f) + 0.266400009393692f));
    _298 = mad(0.03669999912381172f, _278, (1.7135000228881836f - (_275 * 0.7501999735832214f))) / mad(0.03669999912381172f, _273, (1.7135000228881836f - (_270 * 0.7501999735832214f)));
    _299 = mad(1.0296000242233276f, _278, ((_275 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _273, ((_270 * 0.03889999911189079f) + -0.06849999725818634f));
    _300 = mad(_298, -0.7501999735832214f, 0.0f);
    _301 = mad(_298, 1.7135000228881836f, 0.0f);
    _302 = mad(_298, 0.03669999912381172f, -0.0f);
    _303 = mad(_299, 0.03889999911189079f, 0.0f);
    _304 = mad(_299, -0.06849999725818634f, 0.0f);
    _305 = mad(_299, 1.0296000242233276f, 0.0f);
    _308 = mad(0.1599626988172531f, _303, mad(-0.1470542997121811f, _300, (_297 * 0.883457362651825f)));
    _311 = mad(0.1599626988172531f, _304, mad(-0.1470542997121811f, _301, (_297 * 0.26293492317199707f)));
    _314 = mad(0.1599626988172531f, _305, mad(-0.1470542997121811f, _302, (_297 * -0.15930065512657166f)));
    _317 = mad(0.04929120093584061f, _303, mad(0.5183603167533875f, _300, (_297 * 0.38695648312568665f)));
    _320 = mad(0.04929120093584061f, _304, mad(0.5183603167533875f, _301, (_297 * 0.11516613513231277f)));
    _323 = mad(0.04929120093584061f, _305, mad(0.5183603167533875f, _302, (_297 * -0.0697740763425827f)));
    _326 = mad(0.9684867262840271f, _303, mad(0.04004279896616936f, _300, (_297 * -0.007634039502590895f)));
    _329 = mad(0.9684867262840271f, _304, mad(0.04004279896616936f, _301, (_297 * -0.0022720457054674625f)));
    _332 = mad(0.9684867262840271f, _305, mad(0.04004279896616936f, _302, (_297 * 0.0013765322510153055f)));
    _335 = mad(_314, (WorkingColorSpace_000[2].x), mad(_311, (WorkingColorSpace_000[1].x), (_308 * (WorkingColorSpace_000[0].x))));
    _338 = mad(_314, (WorkingColorSpace_000[2].y), mad(_311, (WorkingColorSpace_000[1].y), (_308 * (WorkingColorSpace_000[0].y))));
    _341 = mad(_314, (WorkingColorSpace_000[2].z), mad(_311, (WorkingColorSpace_000[1].z), (_308 * (WorkingColorSpace_000[0].z))));
    _344 = mad(_323, (WorkingColorSpace_000[2].x), mad(_320, (WorkingColorSpace_000[1].x), (_317 * (WorkingColorSpace_000[0].x))));
    _347 = mad(_323, (WorkingColorSpace_000[2].y), mad(_320, (WorkingColorSpace_000[1].y), (_317 * (WorkingColorSpace_000[0].y))));
    _350 = mad(_323, (WorkingColorSpace_000[2].z), mad(_320, (WorkingColorSpace_000[1].z), (_317 * (WorkingColorSpace_000[0].z))));
    _353 = mad(_332, (WorkingColorSpace_000[2].x), mad(_329, (WorkingColorSpace_000[1].x), (_326 * (WorkingColorSpace_000[0].x))));
    _356 = mad(_332, (WorkingColorSpace_000[2].y), mad(_329, (WorkingColorSpace_000[1].y), (_326 * (WorkingColorSpace_000[0].y))));
    _359 = mad(_332, (WorkingColorSpace_000[2].z), mad(_329, (WorkingColorSpace_000[1].z), (_326 * (WorkingColorSpace_000[0].z))));
    _397 = mad(mad((WorkingColorSpace_064[0].z), _359, mad((WorkingColorSpace_064[0].y), _350, (_341 * (WorkingColorSpace_064[0].x)))), _135, mad(mad((WorkingColorSpace_064[0].z), _356, mad((WorkingColorSpace_064[0].y), _347, (_338 * (WorkingColorSpace_064[0].x)))), _134, (mad((WorkingColorSpace_064[0].z), _353, mad((WorkingColorSpace_064[0].y), _344, (_335 * (WorkingColorSpace_064[0].x)))) * _133)));
    _398 = mad(mad((WorkingColorSpace_064[1].z), _359, mad((WorkingColorSpace_064[1].y), _350, (_341 * (WorkingColorSpace_064[1].x)))), _135, mad(mad((WorkingColorSpace_064[1].z), _356, mad((WorkingColorSpace_064[1].y), _347, (_338 * (WorkingColorSpace_064[1].x)))), _134, (mad((WorkingColorSpace_064[1].z), _353, mad((WorkingColorSpace_064[1].y), _344, (_335 * (WorkingColorSpace_064[1].x)))) * _133)));
    _399 = mad(mad((WorkingColorSpace_064[2].z), _359, mad((WorkingColorSpace_064[2].y), _350, (_341 * (WorkingColorSpace_064[2].x)))), _135, mad(mad((WorkingColorSpace_064[2].z), _356, mad((WorkingColorSpace_064[2].y), _347, (_338 * (WorkingColorSpace_064[2].x)))), _134, (mad((WorkingColorSpace_064[2].z), _353, mad((WorkingColorSpace_064[2].y), _344, (_335 * (WorkingColorSpace_064[2].x)))) * _133)));
  } else {
    _397 = _133;
    _398 = _134;
    _399 = _135;
  }
  _414 = mad((WorkingColorSpace_128[0].z), _399, mad((WorkingColorSpace_128[0].y), _398, ((WorkingColorSpace_128[0].x) * _397)));
  _417 = mad((WorkingColorSpace_128[1].z), _399, mad((WorkingColorSpace_128[1].y), _398, ((WorkingColorSpace_128[1].x) * _397)));
  _420 = mad((WorkingColorSpace_128[2].z), _399, mad((WorkingColorSpace_128[2].y), _398, ((WorkingColorSpace_128[2].x) * _397)));
  _421 = dot(float3(_414, _417, _420), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _425 = (_414 / _421) + -1.0f;
  _426 = (_417 / _421) + -1.0f;
  _427 = (_420 / _421) + -1.0f;
  _439 = (1.0f - exp2(((_421 * _421) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_425, _426, _427), float3(_425, _426, _427)) * -4.0f));
  _455 = ((mad(-0.06368321925401688f, _420, mad(-0.3292922377586365f, _417, (_414 * 1.3704125881195068f))) - _414) * _439) + _414;
  _456 = ((mad(-0.010861365124583244f, _420, mad(1.0970927476882935f, _417, (_414 * -0.08343357592821121f))) - _417) * _439) + _417;
  _457 = ((mad(1.2036951780319214f, _420, mad(-0.09862580895423889f, _417, (_414 * -0.02579331398010254f))) - _420) * _439) + _420;
  _458 = dot(float3(_455, _456, _457), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _472 = cb0_021w + cb0_026w;
  _486 = cb0_020w * cb0_025w;
  _500 = cb0_019w * cb0_024w;
  _514 = cb0_018w * cb0_023w;
  _528 = cb0_017w * cb0_022w;
  _532 = _455 - _458;
  _533 = _456 - _458;
  _534 = _457 - _458;
  _591 = saturate(_458 / cb0_037w);
  _595 = (_591 * _591) * (3.0f - (_591 * 2.0f));
  _596 = 1.0f - _595;
  _605 = cb0_021w + cb0_036w;
  _614 = cb0_020w * cb0_035w;
  _623 = cb0_019w * cb0_034w;
  _632 = cb0_018w * cb0_033w;
  _641 = cb0_017w * cb0_032w;
  _704 = saturate((_458 - cb0_038x) / (cb0_038y - cb0_038x));
  _708 = (_704 * _704) * (3.0f - (_704 * 2.0f));
  _717 = cb0_021w + cb0_031w;
  _726 = cb0_020w * cb0_030w;
  _735 = cb0_019w * cb0_029w;
  _744 = cb0_018w * cb0_028w;
  _753 = cb0_017w * cb0_027w;
  _811 = _595 - _708;
  _822 = ((_708 * (((cb0_021x + cb0_036x) + _605) + (((cb0_020x * cb0_035x) * _614) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _632) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _641) * _532) + _458)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _623)))))) + (_596 * (((cb0_021x + cb0_026x) + _472) + (((cb0_020x * cb0_025x) * _486) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _514) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _528) * _532) + _458)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _500))))))) + ((((cb0_021x + cb0_031x) + _717) + (((cb0_020x * cb0_030x) * _726) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _744) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _753) * _532) + _458)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _735))))) * _811);
  _824 = ((_708 * (((cb0_021y + cb0_036y) + _605) + (((cb0_020y * cb0_035y) * _614) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _632) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _641) * _533) + _458)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _623)))))) + (_596 * (((cb0_021y + cb0_026y) + _472) + (((cb0_020y * cb0_025y) * _486) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _514) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _528) * _533) + _458)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _500))))))) + ((((cb0_021y + cb0_031y) + _717) + (((cb0_020y * cb0_030y) * _726) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _744) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _753) * _533) + _458)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _735))))) * _811);
  _826 = ((_708 * (((cb0_021z + cb0_036z) + _605) + (((cb0_020z * cb0_035z) * _614) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _632) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _641) * _534) + _458)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _623)))))) + (_596 * (((cb0_021z + cb0_026z) + _472) + (((cb0_020z * cb0_025z) * _486) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _514) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _528) * _534) + _458)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _500))))))) + ((((cb0_021z + cb0_031z) + _717) + (((cb0_020z * cb0_030z) * _726) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _744) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _753) * _534) + _458)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _735))))) * _811);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w), float4(cb0_006x, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;
  float4 output = ProcessLutbuilder(float3(_822, _824, _826), s0, s1, s2, s3, t0, t1, t2, t3, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _862 = ((mad(0.061360642313957214f, _826, mad(-4.540197551250458e-09f, _824, (_822 * 0.9386394023895264f))) - _822) * cb0_038z) + _822;
  _863 = ((mad(0.169205904006958f, _826, mad(0.8307942152023315f, _824, (_822 * 6.775371730327606e-08f))) - _824) * cb0_038z) + _824;
  _864 = (mad(-2.3283064365386963e-10f, _824, (_822 * -9.313225746154785e-10f)) * cb0_038z) + _826;
  _867 = mad(0.16386905312538147f, _864, mad(0.14067868888378143f, _863, (_862 * 0.6954522132873535f)));
  _870 = mad(0.0955343246459961f, _864, mad(0.8596711158752441f, _863, (_862 * 0.044794581830501556f)));
  _873 = mad(1.0015007257461548f, _864, mad(0.004025210160762072f, _863, (_862 * -0.005525882821530104f)));
  _877 = max(max(_867, _870), _873);
  _882 = (max(_877, 1.000000013351432e-10f) - max(min(min(_867, _870), _873), 1.000000013351432e-10f)) / max(_877, 0.009999999776482582f);
  _895 = ((_870 + _867) + _873) + (sqrt((((_873 - _870) * _873) + ((_870 - _867) * _870)) + ((_867 - _873) * _867)) * 1.75f);
  _896 = _895 * 0.3333333432674408f;
  _897 = _882 + -0.4000000059604645f;
  _898 = _897 * 5.0f;
  _902 = max((1.0f - abs(_897 * 2.5f)), 0.0f);
  _913 = ((float((int)(((int)(uint)((int)(_898 > 0.0f))) - ((int)(uint)((int)(_898 < 0.0f))))) * (1.0f - (_902 * _902))) + 1.0f) * 0.02500000037252903f;
  if (_896 > 0.0533333346247673f) {
    if (_896 < 0.1599999964237213f) {
      _922 = (((0.23999999463558197f / _895) + -0.5f) * _913);
    } else {
      _922 = 0.0f;
    }
  } else {
    _922 = _913;
  }
  _923 = _922 + 1.0f;
  _924 = _923 * _867;
  _925 = _923 * _870;
  _926 = _923 * _873;
  if (!((_924 == _925) && (_925 == _926))) {
    _933 = ((_924 * 2.0f) - _925) - _926;
    _936 = ((_870 - _873) * 1.7320507764816284f) * _923;
    _938 = atan(_936 / _933);
    _941 = (_933 < 0.0f);
    _942 = (_933 == 0.0f);
    _943 = (_936 >= 0.0f);
    _944 = (_936 < 0.0f);
    _955 = select((_943 && _942), 90.0f, select((_944 && _942), -90.0f, (select((_944 && _941), (_938 + -3.1415927410125732f), select((_943 && _941), (_938 + 3.1415927410125732f), _938)) * 57.2957763671875f)));
  } else {
    _955 = 0.0f;
  }
  _960 = min(max(select((_955 < 0.0f), (_955 + 360.0f), _955), 0.0f), 360.0f);
  if (_960 < -180.0f) {
    _969 = (_960 + 360.0f);
  } else {
    if (_960 > 180.0f) {
      _969 = (_960 + -360.0f);
    } else {
      _969 = _960;
    }
  }
  _973 = saturate(1.0f - abs(_969 * 0.014814814552664757f));
  _977 = (_973 * _973) * (3.0f - (_973 * 2.0f));
  _983 = ((_977 * _977) * ((_882 * 0.18000000715255737f) * (0.029999999329447746f - _924))) + _924;
  _993 = max(0.0f, mad(-0.21492856740951538f, _926, mad(-0.2365107536315918f, _925, (_983 * 1.4514392614364624f))));
  _994 = max(0.0f, mad(-0.09967592358589172f, _926, mad(1.17622971534729f, _925, (_983 * -0.07655377686023712f))));
  _995 = max(0.0f, mad(0.9977163076400757f, _926, mad(-0.006032449658960104f, _925, (_983 * 0.008316148072481155f))));
  _996 = dot(float3(_993, _994, _995), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1011 = (cb0_040x + 1.0f) - cb0_039z;
  _1013 = cb0_040y + 1.0f;
  _1015 = _1013 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1033 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1024 = (cb0_040x + 0.18000000715255737f) / _1011;
    _1033 = (-0.7447274923324585f - ((log2(_1024 / (2.0f - _1024)) * 0.3465735912322998f) * (_1011 / cb0_039y)));
  }
  _1036 = ((1.0f - cb0_039z) / cb0_039y) - _1033;
  _1038 = (cb0_039w / cb0_039y) - _1036;
  _1042 = log2(lerp(_996, _993, 0.9599999785423279f)) * 0.3010300099849701f;
  _1043 = log2(lerp(_996, _994, 0.9599999785423279f)) * 0.3010300099849701f;
  _1044 = log2(lerp(_996, _995, 0.9599999785423279f)) * 0.3010300099849701f;
  _1048 = cb0_039y * (_1042 + _1036);
  _1049 = cb0_039y * (_1043 + _1036);
  _1050 = cb0_039y * (_1044 + _1036);
  _1051 = _1011 * 2.0f;
  _1053 = (cb0_039y * -2.0f) / _1011;
  _1054 = _1042 - _1033;
  _1055 = _1043 - _1033;
  _1056 = _1044 - _1033;
  _1075 = _1015 * 2.0f;
  _1077 = (cb0_039y * 2.0f) / _1015;
  _1102 = select((_1042 < _1033), ((_1051 / (exp2((_1054 * 1.4426950216293335f) * _1053) + 1.0f)) - cb0_040x), _1048);
  _1103 = select((_1043 < _1033), ((_1051 / (exp2((_1055 * 1.4426950216293335f) * _1053) + 1.0f)) - cb0_040x), _1049);
  _1104 = select((_1044 < _1033), ((_1051 / (exp2((_1056 * 1.4426950216293335f) * _1053) + 1.0f)) - cb0_040x), _1050);
  _1111 = _1038 - _1033;
  _1115 = saturate(_1054 / _1111);
  _1116 = saturate(_1055 / _1111);
  _1117 = saturate(_1056 / _1111);
  _1118 = (_1038 < _1033);
  _1122 = select(_1118, (1.0f - _1115), _1115);
  _1123 = select(_1118, (1.0f - _1116), _1116);
  _1124 = select(_1118, (1.0f - _1117), _1117);
  _1143 = (((_1122 * _1122) * (select((_1042 > _1038), (_1013 - (_1075 / (exp2(((_1042 - _1038) * 1.4426950216293335f) * _1077) + 1.0f))), _1048) - _1102)) * (3.0f - (_1122 * 2.0f))) + _1102;
  _1144 = (((_1123 * _1123) * (select((_1043 > _1038), (_1013 - (_1075 / (exp2(((_1043 - _1038) * 1.4426950216293335f) * _1077) + 1.0f))), _1049) - _1103)) * (3.0f - (_1123 * 2.0f))) + _1103;
  _1145 = (((_1124 * _1124) * (select((_1044 > _1038), (_1013 - (_1075 / (exp2(((_1044 - _1038) * 1.4426950216293335f) * _1077) + 1.0f))), _1050) - _1104)) * (3.0f - (_1124 * 2.0f))) + _1104;
  _1146 = dot(float3(_1143, _1144, _1145), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1166 = (cb0_039x * (max(0.0f, (lerp(_1146, _1143, 0.9300000071525574f))) - _862)) + _862;
  _1167 = (cb0_039x * (max(0.0f, (lerp(_1146, _1144, 0.9300000071525574f))) - _863)) + _863;
  _1168 = (cb0_039x * (max(0.0f, (lerp(_1146, _1145, 0.9300000071525574f))) - _864)) + _864;
  _1184 = ((mad(-0.06537103652954102f, _1168, mad(1.451815478503704e-06f, _1167, (_1166 * 1.065374732017517f))) - _1166) * cb0_038z) + _1166;
  _1185 = ((mad(-0.20366770029067993f, _1168, mad(1.2036634683609009f, _1167, (_1166 * -2.57161445915699e-07f))) - _1167) * cb0_038z) + _1167;
  _1186 = ((mad(0.9999996423721313f, _1168, mad(2.0954757928848267e-08f, _1167, (_1166 * 1.862645149230957e-08f))) - _1168) * cb0_038z) + _1168;
  _1199 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1186, mad((WorkingColorSpace_192[0].y), _1185, ((WorkingColorSpace_192[0].x) * _1184)))));
  _1200 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1186, mad((WorkingColorSpace_192[1].y), _1185, ((WorkingColorSpace_192[1].x) * _1184)))));
  _1201 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1186, mad((WorkingColorSpace_192[2].y), _1185, ((WorkingColorSpace_192[2].x) * _1184)))));
  if (_1199 < 0.0031306699384003878f) {
    _1212 = (_1199 * 12.920000076293945f);
  } else {
    _1212 = (((pow(_1199, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1200 < 0.0031306699384003878f) {
    _1223 = (_1200 * 12.920000076293945f);
  } else {
    _1223 = (((pow(_1200, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1201 < 0.0031306699384003878f) {
    _1234 = (_1201 * 12.920000076293945f);
  } else {
    _1234 = (((pow(_1201, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1238 = (_1223 * 0.9375f) + 0.03125f;
  _1245 = _1234 * 15.0f;
  _1246 = floor(_1245);
  _1247 = _1245 - _1246;
  _1249 = (_1246 + ((_1212 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1252 = t0.SampleLevel(s0, float2(_1249, _1238), 0.0f);
  _1256 = _1249 + 0.0625f;
  _1257 = t0.SampleLevel(s0, float2(_1256, _1238), 0.0f);
  _1279 = t1.SampleLevel(s1, float2(_1249, _1238), 0.0f);
  _1283 = t1.SampleLevel(s1, float2(_1256, _1238), 0.0f);
  _1305 = t2.SampleLevel(s2, float2(_1249, _1238), 0.0f);
  _1309 = t2.SampleLevel(s2, float2(_1256, _1238), 0.0f);
  _1332 = t3.SampleLevel(s3, float2(_1249, _1238), 0.0f);
  _1336 = t3.SampleLevel(s3, float2(_1256, _1238), 0.0f);
  _1352 = (((((lerp(_1252.x, _1257.x, _1247)) * cb0_005y) + (cb0_005x * _1212)) + ((lerp(_1279.x, _1283.x, _1247)) * cb0_005z)) + ((lerp(_1305.x, _1309.x, _1247)) * cb0_005w)) + ((lerp(_1332.x, _1336.x, _1247)) * cb0_006x);
  _1353 = (((((lerp(_1252.y, _1257.y, _1247)) * cb0_005y) + (cb0_005x * _1223)) + ((lerp(_1279.y, _1283.y, _1247)) * cb0_005z)) + ((lerp(_1305.y, _1309.y, _1247)) * cb0_005w)) + ((lerp(_1332.y, _1336.y, _1247)) * cb0_006x);
  _1354 = (((((lerp(_1252.z, _1257.z, _1247)) * cb0_005y) + (cb0_005x * _1234)) + ((lerp(_1279.z, _1283.z, _1247)) * cb0_005z)) + ((lerp(_1305.z, _1309.z, _1247)) * cb0_005w)) + ((lerp(_1332.z, _1336.z, _1247)) * cb0_006x);
  _1379 = select((_1352 > 0.040449999272823334f), exp2(log2((abs(_1352) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1352 * 0.07739938050508499f));
  _1380 = select((_1353 > 0.040449999272823334f), exp2(log2((abs(_1353) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1353 * 0.07739938050508499f));
  _1381 = select((_1354 > 0.040449999272823334f), exp2(log2((abs(_1354) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1354 * 0.07739938050508499f));
  _1407 = cb0_016x * (((cb0_041y + (cb0_041x * _1379)) * _1379) + cb0_041z);
  _1408 = cb0_016y * (((cb0_041y + (cb0_041x * _1380)) * _1380) + cb0_041z);
  _1409 = cb0_016z * (((cb0_041y + (cb0_041x * _1381)) * _1381) + cb0_041z);
  _1416 = ((cb0_015x - _1407) * cb0_015w) + _1407;
  _1417 = ((cb0_015y - _1408) * cb0_015w) + _1408;
  _1418 = ((cb0_015z - _1409) * cb0_015w) + _1409;
  _1419 = cb0_016x * mad((WorkingColorSpace_192[0].z), _826, mad((WorkingColorSpace_192[0].y), _824, (_822 * (WorkingColorSpace_192[0].x))));
  _1420 = cb0_016y * mad((WorkingColorSpace_192[1].z), _826, mad((WorkingColorSpace_192[1].y), _824, ((WorkingColorSpace_192[1].x) * _822)));
  _1421 = cb0_016z * mad((WorkingColorSpace_192[2].z), _826, mad((WorkingColorSpace_192[2].y), _824, ((WorkingColorSpace_192[2].x) * _822)));
  _1428 = ((cb0_015x - _1419) * cb0_015w) + _1419;
  _1429 = ((cb0_015y - _1420) * cb0_015w) + _1420;
  _1430 = ((cb0_015z - _1421) * cb0_015w) + _1421;
  _1442 = exp2(log2(max(0.0f, _1416)) * cb0_042y);
  _1443 = exp2(log2(max(0.0f, _1417)) * cb0_042y);
  _1444 = exp2(log2(max(0.0f, _1418)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1467 = mad((WorkingColorSpace_128[0].z), _1444, mad((WorkingColorSpace_128[0].y), _1443, ((WorkingColorSpace_128[0].x) * _1442)));
      _1470 = mad((WorkingColorSpace_128[1].z), _1444, mad((WorkingColorSpace_128[1].y), _1443, ((WorkingColorSpace_128[1].x) * _1442)));
      _1473 = mad((WorkingColorSpace_128[2].z), _1444, mad((WorkingColorSpace_128[2].y), _1443, ((WorkingColorSpace_128[2].x) * _1442)));
      _1484 = mad(_69, _1473, mad(_68, _1470, (_1467 * _67)));
      _1485 = mad(_72, _1473, mad(_71, _1470, (_1467 * _70)));
      _1486 = mad(_75, _1473, mad(_74, _1470, (_1467 * _73)));
    } else {
      _1484 = _1442;
      _1485 = _1443;
      _1486 = _1444;
    }
    if (_1484 < 0.0031306699384003878f) {
      _1497 = (_1484 * 12.920000076293945f);
    } else {
      _1497 = (((pow(_1484, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1485 < 0.0031306699384003878f) {
      _1508 = (_1485 * 12.920000076293945f);
    } else {
      _1508 = (((pow(_1485, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1486 < 0.0031306699384003878f) {
      _3047 = _1497;
      _3048 = _1508;
      _3049 = (_1486 * 12.920000076293945f);
    } else {
      _3047 = _1497;
      _3048 = _1508;
      _3049 = (((pow(_1486, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1535 = mad((WorkingColorSpace_128[0].z), _1444, mad((WorkingColorSpace_128[0].y), _1443, ((WorkingColorSpace_128[0].x) * _1442)));
      _1538 = mad((WorkingColorSpace_128[1].z), _1444, mad((WorkingColorSpace_128[1].y), _1443, ((WorkingColorSpace_128[1].x) * _1442)));
      _1541 = mad((WorkingColorSpace_128[2].z), _1444, mad((WorkingColorSpace_128[2].y), _1443, ((WorkingColorSpace_128[2].x) * _1442)));
      _1544 = mad(_69, _1541, mad(_68, _1538, (_1535 * _67)));
      _1547 = mad(_72, _1541, mad(_71, _1538, (_1535 * _70)));
      _1550 = mad(_75, _1541, mad(_74, _1538, (_1535 * _73)));
      _3047 = min((_1544 * 4.5f), ((exp2(log2(max(_1544, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3048 = min((_1547 * 4.5f), ((exp2(log2(max(_1547, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3049 = min((_1550 * 4.5f), ((exp2(log2(max(_1550, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        _1625 = cb0_012z * _1428;
        _1626 = cb0_012z * _1429;
        _1627 = cb0_012z * _1430;
        _1630 = mad((WorkingColorSpace_256[0].z), _1627, mad((WorkingColorSpace_256[0].y), _1626, ((WorkingColorSpace_256[0].x) * _1625)));
        _1633 = mad((WorkingColorSpace_256[1].z), _1627, mad((WorkingColorSpace_256[1].y), _1626, ((WorkingColorSpace_256[1].x) * _1625)));
        _1636 = mad((WorkingColorSpace_256[2].z), _1627, mad((WorkingColorSpace_256[2].y), _1626, ((WorkingColorSpace_256[2].x) * _1625)));
        _1639 = mad(-0.21492856740951538f, _1636, mad(-0.2365107536315918f, _1633, (_1630 * 1.4514392614364624f)));
        _1642 = mad(-0.09967592358589172f, _1636, mad(1.17622971534729f, _1633, (_1630 * -0.07655377686023712f)));
        _1645 = mad(0.9977163076400757f, _1636, mad(-0.006032449658960104f, _1633, (_1630 * 0.008316148072481155f)));
        _1647 = max(_1639, max(_1642, _1645));
        if (!(_1647 < 1.000000013351432e-10f)) {
          if (!(((_1630 < 0.0f) || (_1633 < 0.0f)) || (_1636 < 0.0f))) {
            _1657 = abs(_1647);
            _1658 = (_1647 - _1639) / _1657;
            _1660 = (_1647 - _1642) / _1657;
            _1662 = (_1647 - _1645) / _1657;
            if (!(_1658 < 0.8149999976158142f)) {
              _1665 = _1658 + -0.8149999976158142f;
              _1677 = ((_1665 / exp2(log2(exp2(log2(_1665 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1677 = _1658;
            }
            if (!(_1660 < 0.8029999732971191f)) {
              _1680 = _1660 + -0.8029999732971191f;
              _1692 = ((_1680 / exp2(log2(exp2(log2(_1680 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1692 = _1660;
            }
            if (!(_1662 < 0.8799999952316284f)) {
              _1695 = _1662 + -0.8799999952316284f;
              _1707 = ((_1695 / exp2(log2(exp2(log2(_1695 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1707 = _1662;
            }
            _1715 = (_1647 - (_1657 * _1677));
            _1716 = (_1647 - (_1657 * _1692));
            _1717 = (_1647 - (_1657 * _1707));
          } else {
            _1715 = _1639;
            _1716 = _1642;
            _1717 = _1645;
          }
        } else {
          _1715 = _1639;
          _1716 = _1642;
          _1717 = _1645;
        }
        _1733 = ((mad(0.16386906802654266f, _1717, mad(0.14067870378494263f, _1716, (_1715 * 0.6954522132873535f))) - _1630) * cb0_012w) + _1630;
        _1734 = ((mad(0.0955343171954155f, _1717, mad(0.8596711158752441f, _1716, (_1715 * 0.044794563204050064f))) - _1633) * cb0_012w) + _1633;
        _1735 = ((mad(1.0015007257461548f, _1717, mad(0.004025210160762072f, _1716, (_1715 * -0.005525882821530104f))) - _1636) * cb0_012w) + _1636;
        _1739 = max(max(_1733, _1734), _1735);
        _1744 = (max(_1739, 1.000000013351432e-10f) - max(min(min(_1733, _1734), _1735), 1.000000013351432e-10f)) / max(_1739, 0.009999999776482582f);
        _1757 = ((_1734 + _1733) + _1735) + (sqrt((((_1735 - _1734) * _1735) + ((_1734 - _1733) * _1734)) + ((_1733 - _1735) * _1733)) * 1.75f);
        _1758 = _1757 * 0.3333333432674408f;
        _1759 = _1744 + -0.4000000059604645f;
        _1760 = _1759 * 5.0f;
        _1764 = max((1.0f - abs(_1759 * 2.5f)), 0.0f);
        _1775 = ((float((int)(((int)(uint)((int)(_1760 > 0.0f))) - ((int)(uint)((int)(_1760 < 0.0f))))) * (1.0f - (_1764 * _1764))) + 1.0f) * 0.02500000037252903f;
        if (_1758 > 0.0533333346247673f) {
          if (_1758 < 0.1599999964237213f) {
            _1784 = (((0.23999999463558197f / _1757) + -0.5f) * _1775);
          } else {
            _1784 = 0.0f;
          }
        } else {
          _1784 = _1775;
        }
        _1785 = _1784 + 1.0f;
        _1786 = _1785 * _1733;
        _1787 = _1785 * _1734;
        _1788 = _1785 * _1735;
        if (!((_1786 == _1787) && (_1787 == _1788))) {
          _1795 = ((_1786 * 2.0f) - _1787) - _1788;
          _1798 = ((_1734 - _1735) * 1.7320507764816284f) * _1785;
          _1800 = atan(_1798 / _1795);
          _1803 = (_1795 < 0.0f);
          _1804 = (_1795 == 0.0f);
          _1805 = (_1798 >= 0.0f);
          _1806 = (_1798 < 0.0f);
          _1817 = select((_1805 && _1804), 90.0f, select((_1806 && _1804), -90.0f, (select((_1806 && _1803), (_1800 + -3.1415927410125732f), select((_1805 && _1803), (_1800 + 3.1415927410125732f), _1800)) * 57.2957763671875f)));
        } else {
          _1817 = 0.0f;
        }
        _1822 = min(max(select((_1817 < 0.0f), (_1817 + 360.0f), _1817), 0.0f), 360.0f);
        if (_1822 < -180.0f) {
          _1831 = (_1822 + 360.0f);
        } else {
          if (_1822 > 180.0f) {
            _1831 = (_1822 + -360.0f);
          } else {
            _1831 = _1822;
          }
        }
        if ((_1831 > -67.5f) && (_1831 < 67.5f)) {
          _1837 = (_1831 + 67.5f) * 0.029629629105329514f;
          _1838 = int(_1837);
          _1840 = _1837 - float((int)(_1838));
          _1841 = _1840 * _1840;
          _1842 = _1841 * _1840;
          if (_1838 == 3) {
            _1870 = (((0.1666666716337204f - (_1840 * 0.5f)) + (_1841 * 0.5f)) - (_1842 * 0.1666666716337204f));
          } else {
            if (_1838 == 2) {
              _1870 = ((0.6666666865348816f - _1841) + (_1842 * 0.5f));
            } else {
              if (_1838 == 1) {
                _1870 = (((_1842 * -0.5f) + 0.1666666716337204f) + ((_1841 + _1840) * 0.5f));
              } else {
                _1870 = select((_1838 == 0), (_1842 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1870 = 0.0f;
        }
        _1879 = min(max(((((_1744 * 0.27000001072883606f) * (0.029999999329447746f - _1786)) * _1870) + _1786), 0.0f), 65535.0f);
        _1880 = min(max(_1787, 0.0f), 65535.0f);
        _1881 = min(max(_1788, 0.0f), 65535.0f);
        _1894 = min(max(mad(-0.21492856740951538f, _1881, mad(-0.2365107536315918f, _1880, (_1879 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1895 = min(max(mad(-0.09967592358589172f, _1881, mad(1.17622971534729f, _1880, (_1879 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1896 = min(max(mad(0.9977163076400757f, _1881, mad(-0.006032449658960104f, _1880, (_1879 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1897 = dot(float3(_1894, _1895, _1896), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        _25[0] = cb0_010x;
        _25[1] = cb0_010y;
        _25[2] = cb0_010z;
        _25[3] = cb0_010w;
        _25[4] = cb0_012x;
        _25[5] = cb0_012x;
        _26[0] = cb0_011x;
        _26[1] = cb0_011y;
        _26[2] = cb0_011z;
        _26[3] = cb0_011w;
        _26[4] = cb0_012y;
        _26[5] = cb0_012y;
        _1920 = log2(max((lerp(_1897, _1894, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1921 = _1920 * 0.3010300099849701f;
        _1922 = log2(cb0_008x);
        _1923 = _1922 * 0.3010300099849701f;
        if (_1921 > _1923) {
          _1930 = log2(cb0_009x);
          _1931 = _1930 * 0.3010300099849701f;
          if ((_1921 > _1923) && (_1921 < _1931)) {
            _1939 = ((_1920 - _1922) * 0.9030900001525879f) / ((_1930 - _1922) * 0.3010300099849701f);
            _1940 = int(_1939);
            _1942 = _1939 - float((int)(_1940));
            _1944 = _25[min((uint)(_1940), 5u)];
            _1947 = _25[min((uint)((_1940 + 1)), 5u)];
            _1952 = _1944 * 0.5f;
            _1992 = dot(float3((_1942 * _1942), _1942, 1.0f), float3(mad((_25[min((uint)((_1940 + 2)), 5u)]), 0.5f, mad(_1947, -1.0f, _1952)), (_1947 - _1944), mad(_1947, 0.5f, _1952)));
          } else {
            if (_1921 < _1931) {
              _1992 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1961 = log2(cb0_008z);
              if (!(_1921 < (_1961 * 0.3010300099849701f))) {
                _1992 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1969 = ((_1920 - _1930) * 0.9030900001525879f) / ((_1961 - _1930) * 0.3010300099849701f);
                _1970 = int(_1969);
                _1972 = _1969 - float((int)(_1970));
                _1974 = _26[min((uint)(_1970), 5u)];
                _1977 = _26[min((uint)((_1970 + 1)), 5u)];
                _1982 = _1974 * 0.5f;
                _1992 = dot(float3((_1972 * _1972), _1972, 1.0f), float3(mad((_26[min((uint)((_1970 + 2)), 5u)]), 0.5f, mad(_1977, -1.0f, _1982)), (_1977 - _1974), mad(_1977, 0.5f, _1982)));
              }
            }
          }
        } else {
          _1992 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1996 = log2(max((lerp(_1897, _1895, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1997 = _1996 * 0.3010300099849701f;
        if (_1997 > _1923) {
          _2004 = log2(cb0_009x);
          _2005 = _2004 * 0.3010300099849701f;
          if ((_1997 > _1923) && (_1997 < _2005)) {
            _2013 = ((_1996 - _1922) * 0.9030900001525879f) / ((_2004 - _1922) * 0.3010300099849701f);
            _2014 = int(_2013);
            _2016 = _2013 - float((int)(_2014));
            _2018 = _17[min((uint)(_2014), 5u)];
            _2021 = _17[min((uint)((_2014 + 1)), 5u)];
            _2026 = _2018 * 0.5f;
            _2066 = dot(float3((_2016 * _2016), _2016, 1.0f), float3(mad((_17[min((uint)((_2014 + 2)), 5u)]), 0.5f, mad(_2021, -1.0f, _2026)), (_2021 - _2018), mad(_2021, 0.5f, _2026)));
          } else {
            if (_1997 < _2005) {
              _2066 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _2035 = log2(cb0_008z);
              if (!(_1997 < (_2035 * 0.3010300099849701f))) {
                _2066 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2043 = ((_1996 - _2004) * 0.9030900001525879f) / ((_2035 - _2004) * 0.3010300099849701f);
                _2044 = int(_2043);
                _2046 = _2043 - float((int)(_2044));
                _2048 = _18[min((uint)(_2044), 5u)];
                _2051 = _18[min((uint)((_2044 + 1)), 5u)];
                _2056 = _2048 * 0.5f;
                _2066 = dot(float3((_2046 * _2046), _2046, 1.0f), float3(mad((_18[min((uint)((_2044 + 2)), 5u)]), 0.5f, mad(_2051, -1.0f, _2056)), (_2051 - _2048), mad(_2051, 0.5f, _2056)));
              }
            }
          }
        } else {
          _2066 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2070 = log2(max((lerp(_1897, _1896, 0.9599999785423279f)), 1.000000013351432e-10f));
        _2071 = _2070 * 0.3010300099849701f;
        if (_2071 > _1923) {
          _2078 = log2(cb0_009x);
          _2079 = _2078 * 0.3010300099849701f;
          if ((_2071 > _1923) && (_2071 < _2079)) {
            _2087 = ((_2070 - _1922) * 0.9030900001525879f) / ((_2078 - _1922) * 0.3010300099849701f);
            _2088 = int(_2087);
            _2090 = _2087 - float((int)(_2088));
            _2092 = _17[min((uint)(_2088), 5u)];
            _2095 = _17[min((uint)((_2088 + 1)), 5u)];
            _2100 = _2092 * 0.5f;
            _2140 = dot(float3((_2090 * _2090), _2090, 1.0f), float3(mad((_17[min((uint)((_2088 + 2)), 5u)]), 0.5f, mad(_2095, -1.0f, _2100)), (_2095 - _2092), mad(_2095, 0.5f, _2100)));
          } else {
            if (_2071 < _2079) {
              _2140 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _2109 = log2(cb0_008z);
              if (!(_2071 < (_2109 * 0.3010300099849701f))) {
                _2140 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2117 = ((_2070 - _2078) * 0.9030900001525879f) / ((_2109 - _2078) * 0.3010300099849701f);
                _2118 = int(_2117);
                _2120 = _2117 - float((int)(_2118));
                _2122 = _18[min((uint)(_2118), 5u)];
                _2125 = _18[min((uint)((_2118 + 1)), 5u)];
                _2130 = _2122 * 0.5f;
                _2140 = dot(float3((_2120 * _2120), _2120, 1.0f), float3(mad((_18[min((uint)((_2118 + 2)), 5u)]), 0.5f, mad(_2125, -1.0f, _2130)), (_2125 - _2122), mad(_2125, 0.5f, _2130)));
              }
            }
          }
        } else {
          _2140 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2144 = cb0_008w - cb0_008y;
        _2145 = (exp2(_1992 * 3.321928024291992f) - cb0_008y) / _2144;
        _2147 = (exp2(_2066 * 3.321928024291992f) - cb0_008y) / _2144;
        _2149 = (exp2(_2140 * 3.321928024291992f) - cb0_008y) / _2144;
        _2152 = mad(0.15618768334388733f, _2149, mad(0.13400420546531677f, _2147, (_2145 * 0.6624541878700256f)));
        _2155 = mad(0.053689517080783844f, _2149, mad(0.6740817427635193f, _2147, (_2145 * 0.2722287178039551f)));
        _2158 = mad(1.0103391408920288f, _2149, mad(0.00406073359772563f, _2147, (_2145 * -0.005574649665504694f)));
        _2171 = min(max(mad(-0.23642469942569733f, _2158, mad(-0.32480329275131226f, _2155, (_2152 * 1.6410233974456787f))), 0.0f), 1.0f);
        _2172 = min(max(mad(0.016756348311901093f, _2158, mad(1.6153316497802734f, _2155, (_2152 * -0.663662850856781f))), 0.0f), 1.0f);
        _2173 = min(max(mad(0.9883948564529419f, _2158, mad(-0.008284442126750946f, _2155, (_2152 * 0.011721894145011902f))), 0.0f), 1.0f);
        _2176 = mad(0.15618768334388733f, _2173, mad(0.13400420546531677f, _2172, (_2171 * 0.6624541878700256f)));
        _2179 = mad(0.053689517080783844f, _2173, mad(0.6740817427635193f, _2172, (_2171 * 0.2722287178039551f)));
        _2182 = mad(1.0103391408920288f, _2173, mad(0.00406073359772563f, _2172, (_2171 * -0.005574649665504694f)));
        _2204 = min(max((min(max(mad(-0.23642469942569733f, _2182, mad(-0.32480329275131226f, _2179, (_2176 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2205 = min(max((min(max(mad(0.016756348311901093f, _2182, mad(1.6153316497802734f, _2179, (_2176 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2206 = min(max((min(max(mad(0.9883948564529419f, _2182, mad(-0.008284442126750946f, _2179, (_2176 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2225 = exp2(log2(mad(_69, _2206, mad(_68, _2205, (_2204 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2226 = exp2(log2(mad(_72, _2206, mad(_71, _2205, (_2204 * _70))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2227 = exp2(log2(mad(_75, _2206, mad(_74, _2205, (_2204 * _73))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _3047 = exp2(log2((1.0f / ((_2225 * 18.6875f) + 1.0f)) * ((_2225 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _3048 = exp2(log2((1.0f / ((_2226 * 18.6875f) + 1.0f)) * ((_2226 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _3049 = exp2(log2((1.0f / ((_2227 * 18.6875f) + 1.0f)) * ((_2227 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2293 = cb0_012z * _1428;
          _2294 = cb0_012z * _1429;
          _2295 = cb0_012z * _1430;
          _2298 = mad((WorkingColorSpace_256[0].z), _2295, mad((WorkingColorSpace_256[0].y), _2294, ((WorkingColorSpace_256[0].x) * _2293)));
          _2301 = mad((WorkingColorSpace_256[1].z), _2295, mad((WorkingColorSpace_256[1].y), _2294, ((WorkingColorSpace_256[1].x) * _2293)));
          _2304 = mad((WorkingColorSpace_256[2].z), _2295, mad((WorkingColorSpace_256[2].y), _2294, ((WorkingColorSpace_256[2].x) * _2293)));
          _2307 = mad(-0.21492856740951538f, _2304, mad(-0.2365107536315918f, _2301, (_2298 * 1.4514392614364624f)));
          _2310 = mad(-0.09967592358589172f, _2304, mad(1.17622971534729f, _2301, (_2298 * -0.07655377686023712f)));
          _2313 = mad(0.9977163076400757f, _2304, mad(-0.006032449658960104f, _2301, (_2298 * 0.008316148072481155f)));
          _2315 = max(_2307, max(_2310, _2313));
          if (!(_2315 < 1.000000013351432e-10f)) {
            if (!(((_2298 < 0.0f) || (_2301 < 0.0f)) || (_2304 < 0.0f))) {
              _2325 = abs(_2315);
              _2326 = (_2315 - _2307) / _2325;
              _2328 = (_2315 - _2310) / _2325;
              _2330 = (_2315 - _2313) / _2325;
              if (!(_2326 < 0.8149999976158142f)) {
                _2333 = _2326 + -0.8149999976158142f;
                _2345 = ((_2333 / exp2(log2(exp2(log2(_2333 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _2345 = _2326;
              }
              if (!(_2328 < 0.8029999732971191f)) {
                _2348 = _2328 + -0.8029999732971191f;
                _2360 = ((_2348 / exp2(log2(exp2(log2(_2348 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _2360 = _2328;
              }
              if (!(_2330 < 0.8799999952316284f)) {
                _2363 = _2330 + -0.8799999952316284f;
                _2375 = ((_2363 / exp2(log2(exp2(log2(_2363 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2375 = _2330;
              }
              _2383 = (_2315 - (_2325 * _2345));
              _2384 = (_2315 - (_2325 * _2360));
              _2385 = (_2315 - (_2325 * _2375));
            } else {
              _2383 = _2307;
              _2384 = _2310;
              _2385 = _2313;
            }
          } else {
            _2383 = _2307;
            _2384 = _2310;
            _2385 = _2313;
          }
          _2401 = ((mad(0.16386906802654266f, _2385, mad(0.14067870378494263f, _2384, (_2383 * 0.6954522132873535f))) - _2298) * cb0_012w) + _2298;
          _2402 = ((mad(0.0955343171954155f, _2385, mad(0.8596711158752441f, _2384, (_2383 * 0.044794563204050064f))) - _2301) * cb0_012w) + _2301;
          _2403 = ((mad(1.0015007257461548f, _2385, mad(0.004025210160762072f, _2384, (_2383 * -0.005525882821530104f))) - _2304) * cb0_012w) + _2304;
          _2407 = max(max(_2401, _2402), _2403);
          _2412 = (max(_2407, 1.000000013351432e-10f) - max(min(min(_2401, _2402), _2403), 1.000000013351432e-10f)) / max(_2407, 0.009999999776482582f);
          _2425 = ((_2402 + _2401) + _2403) + (sqrt((((_2403 - _2402) * _2403) + ((_2402 - _2401) * _2402)) + ((_2401 - _2403) * _2401)) * 1.75f);
          _2426 = _2425 * 0.3333333432674408f;
          _2427 = _2412 + -0.4000000059604645f;
          _2428 = _2427 * 5.0f;
          _2432 = max((1.0f - abs(_2427 * 2.5f)), 0.0f);
          _2443 = ((float((int)(((int)(uint)((int)(_2428 > 0.0f))) - ((int)(uint)((int)(_2428 < 0.0f))))) * (1.0f - (_2432 * _2432))) + 1.0f) * 0.02500000037252903f;
          if (_2426 > 0.0533333346247673f) {
            if (_2426 < 0.1599999964237213f) {
              _2452 = (((0.23999999463558197f / _2425) + -0.5f) * _2443);
            } else {
              _2452 = 0.0f;
            }
          } else {
            _2452 = _2443;
          }
          _2453 = _2452 + 1.0f;
          _2454 = _2453 * _2401;
          _2455 = _2453 * _2402;
          _2456 = _2453 * _2403;
          if (!((_2454 == _2455) && (_2455 == _2456))) {
            _2463 = ((_2454 * 2.0f) - _2455) - _2456;
            _2466 = ((_2402 - _2403) * 1.7320507764816284f) * _2453;
            _2468 = atan(_2466 / _2463);
            _2471 = (_2463 < 0.0f);
            _2472 = (_2463 == 0.0f);
            _2473 = (_2466 >= 0.0f);
            _2474 = (_2466 < 0.0f);
            _2485 = select((_2473 && _2472), 90.0f, select((_2474 && _2472), -90.0f, (select((_2474 && _2471), (_2468 + -3.1415927410125732f), select((_2473 && _2471), (_2468 + 3.1415927410125732f), _2468)) * 57.2957763671875f)));
          } else {
            _2485 = 0.0f;
          }
          _2490 = min(max(select((_2485 < 0.0f), (_2485 + 360.0f), _2485), 0.0f), 360.0f);
          if (_2490 < -180.0f) {
            _2499 = (_2490 + 360.0f);
          } else {
            if (_2490 > 180.0f) {
              _2499 = (_2490 + -360.0f);
            } else {
              _2499 = _2490;
            }
          }
          if ((_2499 > -67.5f) && (_2499 < 67.5f)) {
            _2505 = (_2499 + 67.5f) * 0.029629629105329514f;
            _2506 = int(_2505);
            _2508 = _2505 - float((int)(_2506));
            _2509 = _2508 * _2508;
            _2510 = _2509 * _2508;
            if (_2506 == 3) {
              _2538 = (((0.1666666716337204f - (_2508 * 0.5f)) + (_2509 * 0.5f)) - (_2510 * 0.1666666716337204f));
            } else {
              if (_2506 == 2) {
                _2538 = ((0.6666666865348816f - _2509) + (_2510 * 0.5f));
              } else {
                if (_2506 == 1) {
                  _2538 = (((_2510 * -0.5f) + 0.1666666716337204f) + ((_2509 + _2508) * 0.5f));
                } else {
                  _2538 = select((_2506 == 0), (_2510 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2538 = 0.0f;
          }
          _2547 = min(max(((((_2412 * 0.27000001072883606f) * (0.029999999329447746f - _2454)) * _2538) + _2454), 0.0f), 65535.0f);
          _2548 = min(max(_2455, 0.0f), 65535.0f);
          _2549 = min(max(_2456, 0.0f), 65535.0f);
          _2562 = min(max(mad(-0.21492856740951538f, _2549, mad(-0.2365107536315918f, _2548, (_2547 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2563 = min(max(mad(-0.09967592358589172f, _2549, mad(1.17622971534729f, _2548, (_2547 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2564 = min(max(mad(0.9977163076400757f, _2549, mad(-0.006032449658960104f, _2548, (_2547 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2565 = dot(float3(_2562, _2563, _2564), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
          _2588 = log2(max((lerp(_2565, _2562, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2589 = _2588 * 0.3010300099849701f;
          _2590 = log2(cb0_008x);
          _2591 = _2590 * 0.3010300099849701f;
          if (_2589 > _2591) {
            _2598 = log2(cb0_009x);
            _2599 = _2598 * 0.3010300099849701f;
            if ((_2589 > _2591) && (_2589 < _2599)) {
              _2607 = ((_2588 - _2590) * 0.9030900001525879f) / ((_2598 - _2590) * 0.3010300099849701f);
              _2608 = int(_2607);
              _2610 = _2607 - float((int)(_2608));
              _2612 = _23[min((uint)(_2608), 5u)];
              _2615 = _23[min((uint)((_2608 + 1)), 5u)];
              _2620 = _2612 * 0.5f;
              _2660 = dot(float3((_2610 * _2610), _2610, 1.0f), float3(mad((_23[min((uint)((_2608 + 2)), 5u)]), 0.5f, mad(_2615, -1.0f, _2620)), (_2615 - _2612), mad(_2615, 0.5f, _2620)));
            } else {
              if (_2589 < _2599) {
                _2660 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2629 = log2(cb0_008z);
                if (!(_2589 < (_2629 * 0.3010300099849701f))) {
                  _2660 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2637 = ((_2588 - _2598) * 0.9030900001525879f) / ((_2629 - _2598) * 0.3010300099849701f);
                  _2638 = int(_2637);
                  _2640 = _2637 - float((int)(_2638));
                  _2642 = _24[min((uint)(_2638), 5u)];
                  _2645 = _24[min((uint)((_2638 + 1)), 5u)];
                  _2650 = _2642 * 0.5f;
                  _2660 = dot(float3((_2640 * _2640), _2640, 1.0f), float3(mad((_24[min((uint)((_2638 + 2)), 5u)]), 0.5f, mad(_2645, -1.0f, _2650)), (_2645 - _2642), mad(_2645, 0.5f, _2650)));
                }
              }
            }
          } else {
            _2660 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2676 = log2(max((lerp(_2565, _2563, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2677 = _2676 * 0.3010300099849701f;
          if (_2677 > _2591) {
            _2684 = log2(cb0_009x);
            _2685 = _2684 * 0.3010300099849701f;
            if ((_2677 > _2591) && (_2677 < _2685)) {
              _2693 = ((_2676 - _2590) * 0.9030900001525879f) / ((_2684 - _2590) * 0.3010300099849701f);
              _2694 = int(_2693);
              _2696 = _2693 - float((int)(_2694));
              _2698 = _19[min((uint)(_2694), 5u)];
              _2701 = _19[min((uint)((_2694 + 1)), 5u)];
              _2706 = _2698 * 0.5f;
              _2746 = dot(float3((_2696 * _2696), _2696, 1.0f), float3(mad((_19[min((uint)((_2694 + 2)), 5u)]), 0.5f, mad(_2701, -1.0f, _2706)), (_2701 - _2698), mad(_2701, 0.5f, _2706)));
            } else {
              if (_2677 < _2685) {
                _2746 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2715 = log2(cb0_008z);
                if (!(_2677 < (_2715 * 0.3010300099849701f))) {
                  _2746 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2723 = ((_2676 - _2684) * 0.9030900001525879f) / ((_2715 - _2684) * 0.3010300099849701f);
                  _2724 = int(_2723);
                  _2726 = _2723 - float((int)(_2724));
                  _2728 = _20[min((uint)(_2724), 5u)];
                  _2731 = _20[min((uint)((_2724 + 1)), 5u)];
                  _2736 = _2728 * 0.5f;
                  _2746 = dot(float3((_2726 * _2726), _2726, 1.0f), float3(mad((_20[min((uint)((_2724 + 2)), 5u)]), 0.5f, mad(_2731, -1.0f, _2736)), (_2731 - _2728), mad(_2731, 0.5f, _2736)));
                }
              }
            }
          } else {
            _2746 = (log2(cb0_008y) * 0.3010300099849701f);
          }
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
          _2762 = log2(max((lerp(_2565, _2564, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2763 = _2762 * 0.3010300099849701f;
          if (_2763 > _2591) {
            _2770 = log2(cb0_009x);
            _2771 = _2770 * 0.3010300099849701f;
            if ((_2763 > _2591) && (_2763 < _2771)) {
              _2779 = ((_2762 - _2590) * 0.9030900001525879f) / ((_2770 - _2590) * 0.3010300099849701f);
              _2780 = int(_2779);
              _2782 = _2779 - float((int)(_2780));
              _2784 = _21[min((uint)(_2780), 5u)];
              _2787 = _21[min((uint)((_2780 + 1)), 5u)];
              _2792 = _2784 * 0.5f;
              _2832 = dot(float3((_2782 * _2782), _2782, 1.0f), float3(mad((_21[min((uint)((_2780 + 2)), 5u)]), 0.5f, mad(_2787, -1.0f, _2792)), (_2787 - _2784), mad(_2787, 0.5f, _2792)));
            } else {
              if (_2763 < _2771) {
                _2832 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2801 = log2(cb0_008z);
                if (!(_2763 < (_2801 * 0.3010300099849701f))) {
                  _2832 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2809 = ((_2762 - _2770) * 0.9030900001525879f) / ((_2801 - _2770) * 0.3010300099849701f);
                  _2810 = int(_2809);
                  _2812 = _2809 - float((int)(_2810));
                  _2814 = _22[min((uint)(_2810), 5u)];
                  _2817 = _22[min((uint)((_2810 + 1)), 5u)];
                  _2822 = _2814 * 0.5f;
                  _2832 = dot(float3((_2812 * _2812), _2812, 1.0f), float3(mad((_22[min((uint)((_2810 + 2)), 5u)]), 0.5f, mad(_2817, -1.0f, _2822)), (_2817 - _2814), mad(_2817, 0.5f, _2822)));
                }
              }
            }
          } else {
            _2832 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2836 = cb0_008w - cb0_008y;
          _2837 = (exp2(_2660 * 3.321928024291992f) - cb0_008y) / _2836;
          _2839 = (exp2(_2746 * 3.321928024291992f) - cb0_008y) / _2836;
          _2841 = (exp2(_2832 * 3.321928024291992f) - cb0_008y) / _2836;
          _2844 = mad(0.15618768334388733f, _2841, mad(0.13400420546531677f, _2839, (_2837 * 0.6624541878700256f)));
          _2847 = mad(0.053689517080783844f, _2841, mad(0.6740817427635193f, _2839, (_2837 * 0.2722287178039551f)));
          _2850 = mad(1.0103391408920288f, _2841, mad(0.00406073359772563f, _2839, (_2837 * -0.005574649665504694f)));
          _2863 = min(max(mad(-0.23642469942569733f, _2850, mad(-0.32480329275131226f, _2847, (_2844 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2864 = min(max(mad(0.016756348311901093f, _2850, mad(1.6153316497802734f, _2847, (_2844 * -0.663662850856781f))), 0.0f), 1.0f);
          _2865 = min(max(mad(0.9883948564529419f, _2850, mad(-0.008284442126750946f, _2847, (_2844 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2868 = mad(0.15618768334388733f, _2865, mad(0.13400420546531677f, _2864, (_2863 * 0.6624541878700256f)));
          _2871 = mad(0.053689517080783844f, _2865, mad(0.6740817427635193f, _2864, (_2863 * 0.2722287178039551f)));
          _2874 = mad(1.0103391408920288f, _2865, mad(0.00406073359772563f, _2864, (_2863 * -0.005574649665504694f)));
          _2896 = min(max((min(max(mad(-0.23642469942569733f, _2874, mad(-0.32480329275131226f, _2871, (_2868 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2899 = min(max((min(max(mad(0.016756348311901093f, _2874, mad(1.6153316497802734f, _2871, (_2868 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2900 = min(max((min(max(mad(0.9883948564529419f, _2874, mad(-0.008284442126750946f, _2871, (_2868 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _3047 = mad(-0.0832589864730835f, _2900, mad(-0.6217921376228333f, _2899, (_2896 * 0.0213131383061409f)));
          _3048 = mad(-0.010548308491706848f, _2900, mad(1.140804648399353f, _2899, (_2896 * -0.0016282059950754046f)));
          _3049 = mad(1.1529725790023804f, _2900, mad(-0.1289689838886261f, _2899, (_2896 * -0.00030004189466126263f)));
        } else {
          if (cb0_042w == 7) {
            _2927 = mad((WorkingColorSpace_128[0].z), _1430, mad((WorkingColorSpace_128[0].y), _1429, ((WorkingColorSpace_128[0].x) * _1428)));
            _2930 = mad((WorkingColorSpace_128[1].z), _1430, mad((WorkingColorSpace_128[1].y), _1429, ((WorkingColorSpace_128[1].x) * _1428)));
            _2933 = mad((WorkingColorSpace_128[2].z), _1430, mad((WorkingColorSpace_128[2].y), _1429, ((WorkingColorSpace_128[2].x) * _1428)));
            _2952 = exp2(log2(mad(_69, _2933, mad(_68, _2930, (_2927 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2953 = exp2(log2(mad(_72, _2933, mad(_71, _2930, (_2927 * _70))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2954 = exp2(log2(mad(_75, _2933, mad(_74, _2930, (_2927 * _73))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3047 = exp2(log2((1.0f / ((_2952 * 18.6875f) + 1.0f)) * ((_2952 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3048 = exp2(log2((1.0f / ((_2953 * 18.6875f) + 1.0f)) * ((_2953 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3049 = exp2(log2((1.0f / ((_2954 * 18.6875f) + 1.0f)) * ((_2954 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _3001 = mad((WorkingColorSpace_128[0].z), _1418, mad((WorkingColorSpace_128[0].y), _1417, ((WorkingColorSpace_128[0].x) * _1416)));
                _3004 = mad((WorkingColorSpace_128[1].z), _1418, mad((WorkingColorSpace_128[1].y), _1417, ((WorkingColorSpace_128[1].x) * _1416)));
                _3007 = mad((WorkingColorSpace_128[2].z), _1418, mad((WorkingColorSpace_128[2].y), _1417, ((WorkingColorSpace_128[2].x) * _1416)));
                _3047 = mad(_69, _3007, mad(_68, _3004, (_3001 * _67)));
                _3048 = mad(_72, _3007, mad(_71, _3004, (_3001 * _70)));
                _3049 = mad(_75, _3007, mad(_74, _3004, (_3001 * _73)));
              } else {
                _3020 = mad((WorkingColorSpace_128[0].z), _1444, mad((WorkingColorSpace_128[0].y), _1443, ((WorkingColorSpace_128[0].x) * _1442)));
                _3023 = mad((WorkingColorSpace_128[1].z), _1444, mad((WorkingColorSpace_128[1].y), _1443, ((WorkingColorSpace_128[1].x) * _1442)));
                _3026 = mad((WorkingColorSpace_128[2].z), _1444, mad((WorkingColorSpace_128[2].y), _1443, ((WorkingColorSpace_128[2].x) * _1442)));
                _3047 = exp2(log2(mad(_69, _3026, mad(_68, _3023, (_3020 * _67)))) * cb0_042z);
                _3048 = exp2(log2(mad(_72, _3026, mad(_71, _3023, (_3020 * _70)))) * cb0_042z);
                _3049 = exp2(log2(mad(_75, _3026, mad(_74, _3023, (_3020 * _73)))) * cb0_042z);
              }
            } else {
              _3047 = _1428;
              _3048 = _1429;
              _3049 = _1430;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_3047 * 0.9523810148239136f), (_3048 * 0.9523810148239136f), (_3049 * 0.9523810148239136f), 0.0f);
}
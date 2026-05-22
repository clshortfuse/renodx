// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
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
  float _184;
  float _391;
  float _392;
  float _393;
  float _916;
  float _949;
  float _963;
  float _1027;
  float _1206;
  float _1217;
  float _1228;
  float _1399;
  float _1400;
  float _1401;
  float _1412;
  float _1423;
  float _1592;
  float _1607;
  float _1622;
  float _1630;
  float _1631;
  float _1632;
  float _1699;
  float _1732;
  float _1746;
  float _1785;
  float _1907;
  float _1981;
  float _2055;
  float _2260;
  float _2275;
  float _2290;
  float _2298;
  float _2299;
  float _2300;
  float _2367;
  float _2400;
  float _2414;
  float _2453;
  float _2575;
  float _2661;
  float _2747;
  float _2962;
  float _2963;
  float _2964;
  bool _50;
  float _80;
  float _81;
  float _82;
  bool _165;
  float _167;
  float _198;
  float _205;
  float _208;
  float _213;
  float _214;
  float _216;
  bool _217;
  float _226;
  float _228;
  float _235;
  float _237;
  float _239;
  float _240;
  float _243;
  float _246;
  float _251;
  float _257;
  float _258;
  float _259;
  float _260;
  float _261;
  float _262;
  float _263;
  float _264;
  float _267;
  float _268;
  float _269;
  float _272;
  float _291;
  float _292;
  float _293;
  float _294;
  float _295;
  float _296;
  float _297;
  float _298;
  float _299;
  float _302;
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
  float _408;
  float _411;
  float _414;
  float _415;
  float _419;
  float _420;
  float _421;
  float _433;
  float _449;
  float _450;
  float _451;
  float _452;
  float _466;
  float _480;
  float _494;
  float _508;
  float _522;
  float _526;
  float _527;
  float _528;
  float _585;
  float _589;
  float _590;
  float _599;
  float _608;
  float _617;
  float _626;
  float _635;
  float _698;
  float _702;
  float _711;
  float _720;
  float _729;
  float _738;
  float _747;
  float _805;
  float _816;
  float _818;
  float _820;
  float _856;
  float _857;
  float _858;
  float _861;
  float _864;
  float _867;
  float _871;
  float _876;
  float _889;
  float _890;
  float _891;
  float _892;
  float _896;
  float _907;
  float _917;
  float _918;
  float _919;
  float _920;
  float _927;
  float _930;
  float _932;
  bool _935;
  bool _936;
  bool _937;
  bool _938;
  float _954;
  float _967;
  float _971;
  float _977;
  float _987;
  float _988;
  float _989;
  float _990;
  float _1005;
  float _1007;
  float _1009;
  float _1018;
  float _1030;
  float _1032;
  float _1036;
  float _1037;
  float _1038;
  float _1042;
  float _1043;
  float _1044;
  float _1045;
  float _1047;
  float _1048;
  float _1049;
  float _1050;
  float _1069;
  float _1071;
  float _1096;
  float _1097;
  float _1098;
  float _1105;
  float _1109;
  float _1110;
  float _1111;
  bool _1112;
  float _1116;
  float _1117;
  float _1118;
  float _1137;
  float _1138;
  float _1139;
  float _1140;
  float _1160;
  float _1161;
  float _1162;
  float _1178;
  float _1179;
  float _1180;
  float _1193;
  float _1194;
  float _1195;
  float _1232;
  float _1239;
  float _1240;
  float _1241;
  float _1243;
  float4 _1246;
  float4 _1251;
  float _1267;
  float _1268;
  float _1269;
  float _1294;
  float _1295;
  float _1296;
  float _1322;
  float _1323;
  float _1324;
  float _1331;
  float _1332;
  float _1333;
  float _1334;
  float _1335;
  float _1336;
  float _1343;
  float _1344;
  float _1345;
  float _1357;
  float _1358;
  float _1359;
  float _1382;
  float _1385;
  float _1388;
  float _1450;
  float _1453;
  float _1456;
  float _1459;
  float _1462;
  float _1465;
  float _1540;
  float _1541;
  float _1542;
  float _1545;
  float _1548;
  float _1551;
  float _1554;
  float _1557;
  float _1560;
  float _1562;
  float _1572;
  float _1573;
  float _1575;
  float _1577;
  float _1580;
  float _1595;
  float _1610;
  float _1648;
  float _1649;
  float _1650;
  float _1654;
  float _1659;
  float _1672;
  float _1673;
  float _1674;
  float _1675;
  float _1679;
  float _1690;
  float _1700;
  float _1701;
  float _1702;
  float _1703;
  float _1710;
  float _1713;
  float _1715;
  bool _1718;
  bool _1719;
  bool _1720;
  bool _1721;
  float _1737;
  float _1752;
  int _1753;
  float _1755;
  float _1756;
  float _1757;
  float _1794;
  float _1795;
  float _1796;
  float _1809;
  float _1810;
  float _1811;
  float _1812;
  float _1835;
  float _1836;
  float _1837;
  float _1838;
  float _1845;
  float _1846;
  float _1854;
  int _1855;
  float _1857;
  float _1859;
  float _1862;
  float _1867;
  float _1876;
  float _1884;
  int _1885;
  float _1887;
  float _1889;
  float _1892;
  float _1897;
  float _1911;
  float _1912;
  float _1919;
  float _1920;
  float _1928;
  int _1929;
  float _1931;
  float _1933;
  float _1936;
  float _1941;
  float _1950;
  float _1958;
  int _1959;
  float _1961;
  float _1963;
  float _1966;
  float _1971;
  float _1985;
  float _1986;
  float _1993;
  float _1994;
  float _2002;
  int _2003;
  float _2005;
  float _2007;
  float _2010;
  float _2015;
  float _2024;
  float _2032;
  int _2033;
  float _2035;
  float _2037;
  float _2040;
  float _2045;
  float _2059;
  float _2060;
  float _2062;
  float _2064;
  float _2067;
  float _2070;
  float _2073;
  float _2086;
  float _2087;
  float _2088;
  float _2091;
  float _2094;
  float _2097;
  float _2119;
  float _2120;
  float _2121;
  float _2140;
  float _2141;
  float _2142;
  float _2208;
  float _2209;
  float _2210;
  float _2213;
  float _2216;
  float _2219;
  float _2222;
  float _2225;
  float _2228;
  float _2230;
  float _2240;
  float _2241;
  float _2243;
  float _2245;
  float _2248;
  float _2263;
  float _2278;
  float _2316;
  float _2317;
  float _2318;
  float _2322;
  float _2327;
  float _2340;
  float _2341;
  float _2342;
  float _2343;
  float _2347;
  float _2358;
  float _2368;
  float _2369;
  float _2370;
  float _2371;
  float _2378;
  float _2381;
  float _2383;
  bool _2386;
  bool _2387;
  bool _2388;
  bool _2389;
  float _2405;
  float _2420;
  int _2421;
  float _2423;
  float _2424;
  float _2425;
  float _2462;
  float _2463;
  float _2464;
  float _2477;
  float _2478;
  float _2479;
  float _2480;
  float _2503;
  float _2504;
  float _2505;
  float _2506;
  float _2513;
  float _2514;
  float _2522;
  int _2523;
  float _2525;
  float _2527;
  float _2530;
  float _2535;
  float _2544;
  float _2552;
  int _2553;
  float _2555;
  float _2557;
  float _2560;
  float _2565;
  float _2591;
  float _2592;
  float _2599;
  float _2600;
  float _2608;
  int _2609;
  float _2611;
  float _2613;
  float _2616;
  float _2621;
  float _2630;
  float _2638;
  int _2639;
  float _2641;
  float _2643;
  float _2646;
  float _2651;
  float _2677;
  float _2678;
  float _2685;
  float _2686;
  float _2694;
  int _2695;
  float _2697;
  float _2699;
  float _2702;
  float _2707;
  float _2716;
  float _2724;
  int _2725;
  float _2727;
  float _2729;
  float _2732;
  float _2737;
  float _2751;
  float _2752;
  float _2754;
  float _2756;
  float _2759;
  float _2762;
  float _2765;
  float _2778;
  float _2779;
  float _2780;
  float _2783;
  float _2786;
  float _2789;
  float _2811;
  float _2814;
  float _2815;
  float _2842;
  float _2845;
  float _2848;
  float _2867;
  float _2868;
  float _2869;
  float _2916;
  float _2919;
  float _2922;
  float _2935;
  float _2938;
  float _2941;
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
  _32 = 0.5f / cb0_037x;
  _37 = cb0_037x + -1.0f;
  _38 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _32)) / _37;
  _39 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _32)) / _37;
  _41 = float((uint)SV_DispatchThreadID.z) / _37;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _50 = (cb0_043x == 4);
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
  if ((uint)cb0_042w > (uint)2) {
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
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _165 = (cb0_040w != 0);
    _167 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _184 = (((((1901800.0f - (_167 * 2006400000.0f)) * _167) + 247.47999572753906f) * _167) + 0.23703999817371368f);
    } else {
      _184 = (((((2967800.0f - (_167 * 4607000064.0f)) * _167) + 99.11000061035156f) * _167) + 0.24406300485134125f);
    }
    _198 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _205 = cb0_037y * cb0_037y;
    _208 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_205 * 1.6145605741257896e-07f));
    _213 = ((_198 * 2.0f) + 4.0f) - (_208 * 8.0f);
    _214 = (_198 * 3.0f) / _213;
    _216 = (_208 * 2.0f) / _213;
    _217 = (cb0_037y < 4000.0f);
    _226 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _228 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_205 * 1.5317699909210205f)) / (_226 * _226);
    _235 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _205;
    _237 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_205 * 308.60699462890625f)) / (_235 * _235);
    _239 = rsqrt(dot(float2(_228, _237), float2(_228, _237)));
    _240 = cb0_037z * 0.05000000074505806f;
    _243 = ((_240 * _237) * _239) + _198;
    _246 = _208 - ((_240 * _228) * _239);
    _251 = (4.0f - (_246 * 8.0f)) + (_243 * 2.0f);
    _257 = (((_243 * 3.0f) / _251) - _214) + select(_217, _214, _184);
    _258 = (((_246 * 2.0f) / _251) - _216) + select(_217, _216, (((_184 * 2.869999885559082f) + -0.2750000059604645f) - ((_184 * _184) * 3.0f)));
    _259 = select(_165, _257, 0.3127000033855438f);
    _260 = select(_165, _258, 0.32899999618530273f);
    _261 = select(_165, 0.3127000033855438f, _257);
    _262 = select(_165, 0.32899999618530273f, _258);
    _263 = max(_260, 1.000000013351432e-10f);
    _264 = _259 / _263;
    _267 = ((1.0f - _259) - _260) / _263;
    _268 = max(_262, 1.000000013351432e-10f);
    _269 = _261 / _268;
    _272 = ((1.0f - _261) - _262) / _268;
    _291 = mad(-0.16140000522136688f, _272, ((_269 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _267, ((_264 * 0.8950999975204468f) + 0.266400009393692f));
    _292 = mad(0.03669999912381172f, _272, (1.7135000228881836f - (_269 * 0.7501999735832214f))) / mad(0.03669999912381172f, _267, (1.7135000228881836f - (_264 * 0.7501999735832214f)));
    _293 = mad(1.0296000242233276f, _272, ((_269 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _267, ((_264 * 0.03889999911189079f) + -0.06849999725818634f));
    _294 = mad(_292, -0.7501999735832214f, 0.0f);
    _295 = mad(_292, 1.7135000228881836f, 0.0f);
    _296 = mad(_292, 0.03669999912381172f, -0.0f);
    _297 = mad(_293, 0.03889999911189079f, 0.0f);
    _298 = mad(_293, -0.06849999725818634f, 0.0f);
    _299 = mad(_293, 1.0296000242233276f, 0.0f);
    _302 = mad(0.1599626988172531f, _297, mad(-0.1470542997121811f, _294, (_291 * 0.883457362651825f)));
    _305 = mad(0.1599626988172531f, _298, mad(-0.1470542997121811f, _295, (_291 * 0.26293492317199707f)));
    _308 = mad(0.1599626988172531f, _299, mad(-0.1470542997121811f, _296, (_291 * -0.15930065512657166f)));
    _311 = mad(0.04929120093584061f, _297, mad(0.5183603167533875f, _294, (_291 * 0.38695648312568665f)));
    _314 = mad(0.04929120093584061f, _298, mad(0.5183603167533875f, _295, (_291 * 0.11516613513231277f)));
    _317 = mad(0.04929120093584061f, _299, mad(0.5183603167533875f, _296, (_291 * -0.0697740763425827f)));
    _320 = mad(0.9684867262840271f, _297, mad(0.04004279896616936f, _294, (_291 * -0.007634039502590895f)));
    _323 = mad(0.9684867262840271f, _298, mad(0.04004279896616936f, _295, (_291 * -0.0022720457054674625f)));
    _326 = mad(0.9684867262840271f, _299, mad(0.04004279896616936f, _296, (_291 * 0.0013765322510153055f)));
    _329 = mad(_308, (WorkingColorSpace_000[2].x), mad(_305, (WorkingColorSpace_000[1].x), (_302 * (WorkingColorSpace_000[0].x))));
    _332 = mad(_308, (WorkingColorSpace_000[2].y), mad(_305, (WorkingColorSpace_000[1].y), (_302 * (WorkingColorSpace_000[0].y))));
    _335 = mad(_308, (WorkingColorSpace_000[2].z), mad(_305, (WorkingColorSpace_000[1].z), (_302 * (WorkingColorSpace_000[0].z))));
    _338 = mad(_317, (WorkingColorSpace_000[2].x), mad(_314, (WorkingColorSpace_000[1].x), (_311 * (WorkingColorSpace_000[0].x))));
    _341 = mad(_317, (WorkingColorSpace_000[2].y), mad(_314, (WorkingColorSpace_000[1].y), (_311 * (WorkingColorSpace_000[0].y))));
    _344 = mad(_317, (WorkingColorSpace_000[2].z), mad(_314, (WorkingColorSpace_000[1].z), (_311 * (WorkingColorSpace_000[0].z))));
    _347 = mad(_326, (WorkingColorSpace_000[2].x), mad(_323, (WorkingColorSpace_000[1].x), (_320 * (WorkingColorSpace_000[0].x))));
    _350 = mad(_326, (WorkingColorSpace_000[2].y), mad(_323, (WorkingColorSpace_000[1].y), (_320 * (WorkingColorSpace_000[0].y))));
    _353 = mad(_326, (WorkingColorSpace_000[2].z), mad(_323, (WorkingColorSpace_000[1].z), (_320 * (WorkingColorSpace_000[0].z))));
    _391 = mad(mad((WorkingColorSpace_064[0].z), _353, mad((WorkingColorSpace_064[0].y), _344, (_335 * (WorkingColorSpace_064[0].x)))), _129, mad(mad((WorkingColorSpace_064[0].z), _350, mad((WorkingColorSpace_064[0].y), _341, (_332 * (WorkingColorSpace_064[0].x)))), _128, (mad((WorkingColorSpace_064[0].z), _347, mad((WorkingColorSpace_064[0].y), _338, (_329 * (WorkingColorSpace_064[0].x)))) * _127)));
    _392 = mad(mad((WorkingColorSpace_064[1].z), _353, mad((WorkingColorSpace_064[1].y), _344, (_335 * (WorkingColorSpace_064[1].x)))), _129, mad(mad((WorkingColorSpace_064[1].z), _350, mad((WorkingColorSpace_064[1].y), _341, (_332 * (WorkingColorSpace_064[1].x)))), _128, (mad((WorkingColorSpace_064[1].z), _347, mad((WorkingColorSpace_064[1].y), _338, (_329 * (WorkingColorSpace_064[1].x)))) * _127)));
    _393 = mad(mad((WorkingColorSpace_064[2].z), _353, mad((WorkingColorSpace_064[2].y), _344, (_335 * (WorkingColorSpace_064[2].x)))), _129, mad(mad((WorkingColorSpace_064[2].z), _350, mad((WorkingColorSpace_064[2].y), _341, (_332 * (WorkingColorSpace_064[2].x)))), _128, (mad((WorkingColorSpace_064[2].z), _347, mad((WorkingColorSpace_064[2].y), _338, (_329 * (WorkingColorSpace_064[2].x)))) * _127)));
  } else {
    _391 = _127;
    _392 = _128;
    _393 = _129;
  }
  _408 = mad((WorkingColorSpace_128[0].z), _393, mad((WorkingColorSpace_128[0].y), _392, ((WorkingColorSpace_128[0].x) * _391)));
  _411 = mad((WorkingColorSpace_128[1].z), _393, mad((WorkingColorSpace_128[1].y), _392, ((WorkingColorSpace_128[1].x) * _391)));
  _414 = mad((WorkingColorSpace_128[2].z), _393, mad((WorkingColorSpace_128[2].y), _392, ((WorkingColorSpace_128[2].x) * _391)));
  _415 = dot(float3(_408, _411, _414), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _419 = (_408 / _415) + -1.0f;
  _420 = (_411 / _415) + -1.0f;
  _421 = (_414 / _415) + -1.0f;
  _433 = (1.0f - exp2(((_415 * _415) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_419, _420, _421), float3(_419, _420, _421)) * -4.0f));
  _449 = ((mad(-0.06368321925401688f, _414, mad(-0.3292922377586365f, _411, (_408 * 1.3704125881195068f))) - _408) * _433) + _408;
  _450 = ((mad(-0.010861365124583244f, _414, mad(1.0970927476882935f, _411, (_408 * -0.08343357592821121f))) - _411) * _433) + _411;
  _451 = ((mad(1.2036951780319214f, _414, mad(-0.09862580895423889f, _411, (_408 * -0.02579331398010254f))) - _414) * _433) + _414;
  _452 = dot(float3(_449, _450, _451), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _466 = cb0_021w + cb0_026w;
  _480 = cb0_020w * cb0_025w;
  _494 = cb0_019w * cb0_024w;
  _508 = cb0_018w * cb0_023w;
  _522 = cb0_017w * cb0_022w;
  _526 = _449 - _452;
  _527 = _450 - _452;
  _528 = _451 - _452;
  _585 = saturate(_452 / cb0_037w);
  _589 = (_585 * _585) * (3.0f - (_585 * 2.0f));
  _590 = 1.0f - _589;
  _599 = cb0_021w + cb0_036w;
  _608 = cb0_020w * cb0_035w;
  _617 = cb0_019w * cb0_034w;
  _626 = cb0_018w * cb0_033w;
  _635 = cb0_017w * cb0_032w;
  _698 = saturate((_452 - cb0_038x) / (cb0_038y - cb0_038x));
  _702 = (_698 * _698) * (3.0f - (_698 * 2.0f));
  _711 = cb0_021w + cb0_031w;
  _720 = cb0_020w * cb0_030w;
  _729 = cb0_019w * cb0_029w;
  _738 = cb0_018w * cb0_028w;
  _747 = cb0_017w * cb0_027w;
  _805 = _589 - _702;
  _816 = ((_702 * (((cb0_021x + cb0_036x) + _599) + (((cb0_020x * cb0_035x) * _608) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _626) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _635) * _526) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _617)))))) + (_590 * (((cb0_021x + cb0_026x) + _466) + (((cb0_020x * cb0_025x) * _480) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _508) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _522) * _526) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _494))))))) + ((((cb0_021x + cb0_031x) + _711) + (((cb0_020x * cb0_030x) * _720) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _738) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _747) * _526) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _729))))) * _805);
  _818 = ((_702 * (((cb0_021y + cb0_036y) + _599) + (((cb0_020y * cb0_035y) * _608) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _626) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _635) * _527) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _617)))))) + (_590 * (((cb0_021y + cb0_026y) + _466) + (((cb0_020y * cb0_025y) * _480) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _508) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _522) * _527) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _494))))))) + ((((cb0_021y + cb0_031y) + _711) + (((cb0_020y * cb0_030y) * _720) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _738) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _747) * _527) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _729))))) * _805);
  _820 = ((_702 * (((cb0_021z + cb0_036z) + _599) + (((cb0_020z * cb0_035z) * _608) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _626) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _635) * _528) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _617)))))) + (_590 * (((cb0_021z + cb0_026z) + _466) + (((cb0_020z * cb0_025z) * _480) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _508) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _522) * _528) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _494))))))) + ((((cb0_021z + cb0_031z) + _711) + (((cb0_020z * cb0_030z) * _720) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _738) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _747) * _528) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _729))))) * _805);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;
  float4 output = ProcessLutbuilder(float3(_816, _818, _820), s0, t0, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _856 = ((mad(0.061360642313957214f, _820, mad(-4.540197551250458e-09f, _818, (_816 * 0.9386394023895264f))) - _816) * cb0_038z) + _816;
  _857 = ((mad(0.169205904006958f, _820, mad(0.8307942152023315f, _818, (_816 * 6.775371730327606e-08f))) - _818) * cb0_038z) + _818;
  _858 = (mad(-2.3283064365386963e-10f, _818, (_816 * -9.313225746154785e-10f)) * cb0_038z) + _820;
  _861 = mad(0.16386905312538147f, _858, mad(0.14067868888378143f, _857, (_856 * 0.6954522132873535f)));
  _864 = mad(0.0955343246459961f, _858, mad(0.8596711158752441f, _857, (_856 * 0.044794581830501556f)));
  _867 = mad(1.0015007257461548f, _858, mad(0.004025210160762072f, _857, (_856 * -0.005525882821530104f)));
  _871 = max(max(_861, _864), _867);
  _876 = (max(_871, 1.000000013351432e-10f) - max(min(min(_861, _864), _867), 1.000000013351432e-10f)) / max(_871, 0.009999999776482582f);
  _889 = ((_864 + _861) + _867) + (sqrt((((_867 - _864) * _867) + ((_864 - _861) * _864)) + ((_861 - _867) * _861)) * 1.75f);
  _890 = _889 * 0.3333333432674408f;
  _891 = _876 + -0.4000000059604645f;
  _892 = _891 * 5.0f;
  _896 = max((1.0f - abs(_891 * 2.5f)), 0.0f);
  _907 = ((float((int)(((int)(uint)((int)(_892 > 0.0f))) - ((int)(uint)((int)(_892 < 0.0f))))) * (1.0f - (_896 * _896))) + 1.0f) * 0.02500000037252903f;
  if (_890 > 0.0533333346247673f) {
    if (_890 < 0.1599999964237213f) {
      _916 = (((0.23999999463558197f / _889) + -0.5f) * _907);
    } else {
      _916 = 0.0f;
    }
  } else {
    _916 = _907;
  }
  _917 = _916 + 1.0f;
  _918 = _917 * _861;
  _919 = _917 * _864;
  _920 = _917 * _867;
  if (!((_918 == _919) && (_919 == _920))) {
    _927 = ((_918 * 2.0f) - _919) - _920;
    _930 = ((_864 - _867) * 1.7320507764816284f) * _917;
    _932 = atan(_930 / _927);
    _935 = (_927 < 0.0f);
    _936 = (_927 == 0.0f);
    _937 = (_930 >= 0.0f);
    _938 = (_930 < 0.0f);
    _949 = select((_937 && _936), 90.0f, select((_938 && _936), -90.0f, (select((_938 && _935), (_932 + -3.1415927410125732f), select((_937 && _935), (_932 + 3.1415927410125732f), _932)) * 57.2957763671875f)));
  } else {
    _949 = 0.0f;
  }
  _954 = min(max(select((_949 < 0.0f), (_949 + 360.0f), _949), 0.0f), 360.0f);
  if (_954 < -180.0f) {
    _963 = (_954 + 360.0f);
  } else {
    if (_954 > 180.0f) {
      _963 = (_954 + -360.0f);
    } else {
      _963 = _954;
    }
  }
  _967 = saturate(1.0f - abs(_963 * 0.014814814552664757f));
  _971 = (_967 * _967) * (3.0f - (_967 * 2.0f));
  _977 = ((_971 * _971) * ((_876 * 0.18000000715255737f) * (0.029999999329447746f - _918))) + _918;
  _987 = max(0.0f, mad(-0.21492856740951538f, _920, mad(-0.2365107536315918f, _919, (_977 * 1.4514392614364624f))));
  _988 = max(0.0f, mad(-0.09967592358589172f, _920, mad(1.17622971534729f, _919, (_977 * -0.07655377686023712f))));
  _989 = max(0.0f, mad(0.9977163076400757f, _920, mad(-0.006032449658960104f, _919, (_977 * 0.008316148072481155f))));
  _990 = dot(float3(_987, _988, _989), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1005 = (cb0_040x + 1.0f) - cb0_039z;
  _1007 = cb0_040y + 1.0f;
  _1009 = _1007 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1027 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1018 = (cb0_040x + 0.18000000715255737f) / _1005;
    _1027 = (-0.7447274923324585f - ((log2(_1018 / (2.0f - _1018)) * 0.3465735912322998f) * (_1005 / cb0_039y)));
  }
  _1030 = ((1.0f - cb0_039z) / cb0_039y) - _1027;
  _1032 = (cb0_039w / cb0_039y) - _1030;
  _1036 = log2(lerp(_990, _987, 0.9599999785423279f)) * 0.3010300099849701f;
  _1037 = log2(lerp(_990, _988, 0.9599999785423279f)) * 0.3010300099849701f;
  _1038 = log2(lerp(_990, _989, 0.9599999785423279f)) * 0.3010300099849701f;
  _1042 = cb0_039y * (_1036 + _1030);
  _1043 = cb0_039y * (_1037 + _1030);
  _1044 = cb0_039y * (_1038 + _1030);
  _1045 = _1005 * 2.0f;
  _1047 = (cb0_039y * -2.0f) / _1005;
  _1048 = _1036 - _1027;
  _1049 = _1037 - _1027;
  _1050 = _1038 - _1027;
  _1069 = _1009 * 2.0f;
  _1071 = (cb0_039y * 2.0f) / _1009;
  _1096 = select((_1036 < _1027), ((_1045 / (exp2((_1048 * 1.4426950216293335f) * _1047) + 1.0f)) - cb0_040x), _1042);
  _1097 = select((_1037 < _1027), ((_1045 / (exp2((_1049 * 1.4426950216293335f) * _1047) + 1.0f)) - cb0_040x), _1043);
  _1098 = select((_1038 < _1027), ((_1045 / (exp2((_1050 * 1.4426950216293335f) * _1047) + 1.0f)) - cb0_040x), _1044);
  _1105 = _1032 - _1027;
  _1109 = saturate(_1048 / _1105);
  _1110 = saturate(_1049 / _1105);
  _1111 = saturate(_1050 / _1105);
  _1112 = (_1032 < _1027);
  _1116 = select(_1112, (1.0f - _1109), _1109);
  _1117 = select(_1112, (1.0f - _1110), _1110);
  _1118 = select(_1112, (1.0f - _1111), _1111);
  _1137 = (((_1116 * _1116) * (select((_1036 > _1032), (_1007 - (_1069 / (exp2(((_1036 - _1032) * 1.4426950216293335f) * _1071) + 1.0f))), _1042) - _1096)) * (3.0f - (_1116 * 2.0f))) + _1096;
  _1138 = (((_1117 * _1117) * (select((_1037 > _1032), (_1007 - (_1069 / (exp2(((_1037 - _1032) * 1.4426950216293335f) * _1071) + 1.0f))), _1043) - _1097)) * (3.0f - (_1117 * 2.0f))) + _1097;
  _1139 = (((_1118 * _1118) * (select((_1038 > _1032), (_1007 - (_1069 / (exp2(((_1038 - _1032) * 1.4426950216293335f) * _1071) + 1.0f))), _1044) - _1098)) * (3.0f - (_1118 * 2.0f))) + _1098;
  _1140 = dot(float3(_1137, _1138, _1139), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1160 = (cb0_039x * (max(0.0f, (lerp(_1140, _1137, 0.9300000071525574f))) - _856)) + _856;
  _1161 = (cb0_039x * (max(0.0f, (lerp(_1140, _1138, 0.9300000071525574f))) - _857)) + _857;
  _1162 = (cb0_039x * (max(0.0f, (lerp(_1140, _1139, 0.9300000071525574f))) - _858)) + _858;
  _1178 = ((mad(-0.06537103652954102f, _1162, mad(1.451815478503704e-06f, _1161, (_1160 * 1.065374732017517f))) - _1160) * cb0_038z) + _1160;
  _1179 = ((mad(-0.20366770029067993f, _1162, mad(1.2036634683609009f, _1161, (_1160 * -2.57161445915699e-07f))) - _1161) * cb0_038z) + _1161;
  _1180 = ((mad(0.9999996423721313f, _1162, mad(2.0954757928848267e-08f, _1161, (_1160 * 1.862645149230957e-08f))) - _1162) * cb0_038z) + _1162;
  _1193 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1180, mad((WorkingColorSpace_192[0].y), _1179, ((WorkingColorSpace_192[0].x) * _1178)))));
  _1194 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1180, mad((WorkingColorSpace_192[1].y), _1179, ((WorkingColorSpace_192[1].x) * _1178)))));
  _1195 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1180, mad((WorkingColorSpace_192[2].y), _1179, ((WorkingColorSpace_192[2].x) * _1178)))));
  if (_1193 < 0.0031306699384003878f) {
    _1206 = (_1193 * 12.920000076293945f);
  } else {
    _1206 = (((pow(_1193, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1194 < 0.0031306699384003878f) {
    _1217 = (_1194 * 12.920000076293945f);
  } else {
    _1217 = (((pow(_1194, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1195 < 0.0031306699384003878f) {
    _1228 = (_1195 * 12.920000076293945f);
  } else {
    _1228 = (((pow(_1195, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1232 = (_1217 * 0.9375f) + 0.03125f;
  _1239 = _1228 * 15.0f;
  _1240 = floor(_1239);
  _1241 = _1239 - _1240;
  _1243 = (((_1206 * 0.9375f) + 0.03125f) + _1240) * 0.0625f;
  _1246 = t0.SampleLevel(s0, float2(_1243, _1232), 0.0f);
  _1251 = t0.SampleLevel(s0, float2((_1243 + 0.0625f), _1232), 0.0f);
  _1267 = ((lerp(_1246.x, _1251.x, _1241)) * cb0_005y) + (cb0_005x * _1206);
  _1268 = ((lerp(_1246.y, _1251.y, _1241)) * cb0_005y) + (cb0_005x * _1217);
  _1269 = ((lerp(_1246.z, _1251.z, _1241)) * cb0_005y) + (cb0_005x * _1228);
  _1294 = select((_1267 > 0.040449999272823334f), exp2(log2((abs(_1267) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1267 * 0.07739938050508499f));
  _1295 = select((_1268 > 0.040449999272823334f), exp2(log2((abs(_1268) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1268 * 0.07739938050508499f));
  _1296 = select((_1269 > 0.040449999272823334f), exp2(log2((abs(_1269) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1269 * 0.07739938050508499f));
  _1322 = cb0_016x * (((cb0_041y + (cb0_041x * _1294)) * _1294) + cb0_041z);
  _1323 = cb0_016y * (((cb0_041y + (cb0_041x * _1295)) * _1295) + cb0_041z);
  _1324 = cb0_016z * (((cb0_041y + (cb0_041x * _1296)) * _1296) + cb0_041z);
  _1331 = ((cb0_015x - _1322) * cb0_015w) + _1322;
  _1332 = ((cb0_015y - _1323) * cb0_015w) + _1323;
  _1333 = ((cb0_015z - _1324) * cb0_015w) + _1324;
  _1334 = cb0_016x * mad((WorkingColorSpace_192[0].z), _820, mad((WorkingColorSpace_192[0].y), _818, (_816 * (WorkingColorSpace_192[0].x))));
  _1335 = cb0_016y * mad((WorkingColorSpace_192[1].z), _820, mad((WorkingColorSpace_192[1].y), _818, ((WorkingColorSpace_192[1].x) * _816)));
  _1336 = cb0_016z * mad((WorkingColorSpace_192[2].z), _820, mad((WorkingColorSpace_192[2].y), _818, ((WorkingColorSpace_192[2].x) * _816)));
  _1343 = ((cb0_015x - _1334) * cb0_015w) + _1334;
  _1344 = ((cb0_015y - _1335) * cb0_015w) + _1335;
  _1345 = ((cb0_015z - _1336) * cb0_015w) + _1336;
  _1357 = exp2(log2(max(0.0f, _1331)) * cb0_042y);
  _1358 = exp2(log2(max(0.0f, _1332)) * cb0_042y);
  _1359 = exp2(log2(max(0.0f, _1333)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1382 = mad((WorkingColorSpace_128[0].z), _1359, mad((WorkingColorSpace_128[0].y), _1358, ((WorkingColorSpace_128[0].x) * _1357)));
      _1385 = mad((WorkingColorSpace_128[1].z), _1359, mad((WorkingColorSpace_128[1].y), _1358, ((WorkingColorSpace_128[1].x) * _1357)));
      _1388 = mad((WorkingColorSpace_128[2].z), _1359, mad((WorkingColorSpace_128[2].y), _1358, ((WorkingColorSpace_128[2].x) * _1357)));
      _1399 = mad(_63, _1388, mad(_62, _1385, (_1382 * _61)));
      _1400 = mad(_66, _1388, mad(_65, _1385, (_1382 * _64)));
      _1401 = mad(_69, _1388, mad(_68, _1385, (_1382 * _67)));
    } else {
      _1399 = _1357;
      _1400 = _1358;
      _1401 = _1359;
    }
    if (_1399 < 0.0031306699384003878f) {
      _1412 = (_1399 * 12.920000076293945f);
    } else {
      _1412 = (((pow(_1399, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1400 < 0.0031306699384003878f) {
      _1423 = (_1400 * 12.920000076293945f);
    } else {
      _1423 = (((pow(_1400, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1401 < 0.0031306699384003878f) {
      _2962 = _1412;
      _2963 = _1423;
      _2964 = (_1401 * 12.920000076293945f);
    } else {
      _2962 = _1412;
      _2963 = _1423;
      _2964 = (((pow(_1401, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1450 = mad((WorkingColorSpace_128[0].z), _1359, mad((WorkingColorSpace_128[0].y), _1358, ((WorkingColorSpace_128[0].x) * _1357)));
      _1453 = mad((WorkingColorSpace_128[1].z), _1359, mad((WorkingColorSpace_128[1].y), _1358, ((WorkingColorSpace_128[1].x) * _1357)));
      _1456 = mad((WorkingColorSpace_128[2].z), _1359, mad((WorkingColorSpace_128[2].y), _1358, ((WorkingColorSpace_128[2].x) * _1357)));
      _1459 = mad(_63, _1456, mad(_62, _1453, (_1450 * _61)));
      _1462 = mad(_66, _1456, mad(_65, _1453, (_1450 * _64)));
      _1465 = mad(_69, _1456, mad(_68, _1453, (_1450 * _67)));
      _2962 = min((_1459 * 4.5f), ((exp2(log2(max(_1459, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2963 = min((_1462 * 4.5f), ((exp2(log2(max(_1462, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2964 = min((_1465 * 4.5f), ((exp2(log2(max(_1465, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
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
        _1540 = cb0_012z * _1343;
        _1541 = cb0_012z * _1344;
        _1542 = cb0_012z * _1345;
        _1545 = mad((WorkingColorSpace_256[0].z), _1542, mad((WorkingColorSpace_256[0].y), _1541, ((WorkingColorSpace_256[0].x) * _1540)));
        _1548 = mad((WorkingColorSpace_256[1].z), _1542, mad((WorkingColorSpace_256[1].y), _1541, ((WorkingColorSpace_256[1].x) * _1540)));
        _1551 = mad((WorkingColorSpace_256[2].z), _1542, mad((WorkingColorSpace_256[2].y), _1541, ((WorkingColorSpace_256[2].x) * _1540)));
        _1554 = mad(-0.21492856740951538f, _1551, mad(-0.2365107536315918f, _1548, (_1545 * 1.4514392614364624f)));
        _1557 = mad(-0.09967592358589172f, _1551, mad(1.17622971534729f, _1548, (_1545 * -0.07655377686023712f)));
        _1560 = mad(0.9977163076400757f, _1551, mad(-0.006032449658960104f, _1548, (_1545 * 0.008316148072481155f)));
        _1562 = max(_1554, max(_1557, _1560));
        if (!(_1562 < 1.000000013351432e-10f)) {
          if (!(((_1545 < 0.0f) || (_1548 < 0.0f)) || (_1551 < 0.0f))) {
            _1572 = abs(_1562);
            _1573 = (_1562 - _1554) / _1572;
            _1575 = (_1562 - _1557) / _1572;
            _1577 = (_1562 - _1560) / _1572;
            if (!(_1573 < 0.8149999976158142f)) {
              _1580 = _1573 + -0.8149999976158142f;
              _1592 = ((_1580 / exp2(log2(exp2(log2(_1580 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1592 = _1573;
            }
            if (!(_1575 < 0.8029999732971191f)) {
              _1595 = _1575 + -0.8029999732971191f;
              _1607 = ((_1595 / exp2(log2(exp2(log2(_1595 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1607 = _1575;
            }
            if (!(_1577 < 0.8799999952316284f)) {
              _1610 = _1577 + -0.8799999952316284f;
              _1622 = ((_1610 / exp2(log2(exp2(log2(_1610 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1622 = _1577;
            }
            _1630 = (_1562 - (_1572 * _1592));
            _1631 = (_1562 - (_1572 * _1607));
            _1632 = (_1562 - (_1572 * _1622));
          } else {
            _1630 = _1554;
            _1631 = _1557;
            _1632 = _1560;
          }
        } else {
          _1630 = _1554;
          _1631 = _1557;
          _1632 = _1560;
        }
        _1648 = ((mad(0.16386906802654266f, _1632, mad(0.14067870378494263f, _1631, (_1630 * 0.6954522132873535f))) - _1545) * cb0_012w) + _1545;
        _1649 = ((mad(0.0955343171954155f, _1632, mad(0.8596711158752441f, _1631, (_1630 * 0.044794563204050064f))) - _1548) * cb0_012w) + _1548;
        _1650 = ((mad(1.0015007257461548f, _1632, mad(0.004025210160762072f, _1631, (_1630 * -0.005525882821530104f))) - _1551) * cb0_012w) + _1551;
        _1654 = max(max(_1648, _1649), _1650);
        _1659 = (max(_1654, 1.000000013351432e-10f) - max(min(min(_1648, _1649), _1650), 1.000000013351432e-10f)) / max(_1654, 0.009999999776482582f);
        _1672 = ((_1649 + _1648) + _1650) + (sqrt((((_1650 - _1649) * _1650) + ((_1649 - _1648) * _1649)) + ((_1648 - _1650) * _1648)) * 1.75f);
        _1673 = _1672 * 0.3333333432674408f;
        _1674 = _1659 + -0.4000000059604645f;
        _1675 = _1674 * 5.0f;
        _1679 = max((1.0f - abs(_1674 * 2.5f)), 0.0f);
        _1690 = ((float((int)(((int)(uint)((int)(_1675 > 0.0f))) - ((int)(uint)((int)(_1675 < 0.0f))))) * (1.0f - (_1679 * _1679))) + 1.0f) * 0.02500000037252903f;
        if (_1673 > 0.0533333346247673f) {
          if (_1673 < 0.1599999964237213f) {
            _1699 = (((0.23999999463558197f / _1672) + -0.5f) * _1690);
          } else {
            _1699 = 0.0f;
          }
        } else {
          _1699 = _1690;
        }
        _1700 = _1699 + 1.0f;
        _1701 = _1700 * _1648;
        _1702 = _1700 * _1649;
        _1703 = _1700 * _1650;
        if (!((_1701 == _1702) && (_1702 == _1703))) {
          _1710 = ((_1701 * 2.0f) - _1702) - _1703;
          _1713 = ((_1649 - _1650) * 1.7320507764816284f) * _1700;
          _1715 = atan(_1713 / _1710);
          _1718 = (_1710 < 0.0f);
          _1719 = (_1710 == 0.0f);
          _1720 = (_1713 >= 0.0f);
          _1721 = (_1713 < 0.0f);
          _1732 = select((_1720 && _1719), 90.0f, select((_1721 && _1719), -90.0f, (select((_1721 && _1718), (_1715 + -3.1415927410125732f), select((_1720 && _1718), (_1715 + 3.1415927410125732f), _1715)) * 57.2957763671875f)));
        } else {
          _1732 = 0.0f;
        }
        _1737 = min(max(select((_1732 < 0.0f), (_1732 + 360.0f), _1732), 0.0f), 360.0f);
        if (_1737 < -180.0f) {
          _1746 = (_1737 + 360.0f);
        } else {
          if (_1737 > 180.0f) {
            _1746 = (_1737 + -360.0f);
          } else {
            _1746 = _1737;
          }
        }
        if ((_1746 > -67.5f) && (_1746 < 67.5f)) {
          _1752 = (_1746 + 67.5f) * 0.029629629105329514f;
          _1753 = int(_1752);
          _1755 = _1752 - float((int)(_1753));
          _1756 = _1755 * _1755;
          _1757 = _1756 * _1755;
          if (_1753 == 3) {
            _1785 = (((0.1666666716337204f - (_1755 * 0.5f)) + (_1756 * 0.5f)) - (_1757 * 0.1666666716337204f));
          } else {
            if (_1753 == 2) {
              _1785 = ((0.6666666865348816f - _1756) + (_1757 * 0.5f));
            } else {
              if (_1753 == 1) {
                _1785 = (((_1757 * -0.5f) + 0.1666666716337204f) + ((_1756 + _1755) * 0.5f));
              } else {
                _1785 = select((_1753 == 0), (_1757 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1785 = 0.0f;
        }
        _1794 = min(max(((((_1659 * 0.27000001072883606f) * (0.029999999329447746f - _1701)) * _1785) + _1701), 0.0f), 65535.0f);
        _1795 = min(max(_1702, 0.0f), 65535.0f);
        _1796 = min(max(_1703, 0.0f), 65535.0f);
        _1809 = min(max(mad(-0.21492856740951538f, _1796, mad(-0.2365107536315918f, _1795, (_1794 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1810 = min(max(mad(-0.09967592358589172f, _1796, mad(1.17622971534729f, _1795, (_1794 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1811 = min(max(mad(0.9977163076400757f, _1796, mad(-0.006032449658960104f, _1795, (_1794 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1812 = dot(float3(_1809, _1810, _1811), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
        _1835 = log2(max((lerp(_1812, _1809, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1836 = _1835 * 0.3010300099849701f;
        _1837 = log2(cb0_008x);
        _1838 = _1837 * 0.3010300099849701f;
        if (_1836 > _1838) {
          _1845 = log2(cb0_009x);
          _1846 = _1845 * 0.3010300099849701f;
          if ((_1836 > _1838) && (_1836 < _1846)) {
            _1854 = ((_1835 - _1837) * 0.9030900001525879f) / ((_1845 - _1837) * 0.3010300099849701f);
            _1855 = int(_1854);
            _1857 = _1854 - float((int)(_1855));
            _1859 = _19[min((uint)(_1855), 5u)];
            _1862 = _19[min((uint)((_1855 + 1)), 5u)];
            _1867 = _1859 * 0.5f;
            _1907 = dot(float3((_1857 * _1857), _1857, 1.0f), float3(mad((_19[min((uint)((_1855 + 2)), 5u)]), 0.5f, mad(_1862, -1.0f, _1867)), (_1862 - _1859), mad(_1862, 0.5f, _1867)));
          } else {
            if (_1836 < _1846) {
              _1907 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1876 = log2(cb0_008z);
              if (!(_1836 < (_1876 * 0.3010300099849701f))) {
                _1907 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1884 = ((_1835 - _1845) * 0.9030900001525879f) / ((_1876 - _1845) * 0.3010300099849701f);
                _1885 = int(_1884);
                _1887 = _1884 - float((int)(_1885));
                _1889 = _20[min((uint)(_1885), 5u)];
                _1892 = _20[min((uint)((_1885 + 1)), 5u)];
                _1897 = _1889 * 0.5f;
                _1907 = dot(float3((_1887 * _1887), _1887, 1.0f), float3(mad((_20[min((uint)((_1885 + 2)), 5u)]), 0.5f, mad(_1892, -1.0f, _1897)), (_1892 - _1889), mad(_1892, 0.5f, _1897)));
              }
            }
          }
        } else {
          _1907 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1911 = log2(max((lerp(_1812, _1810, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1912 = _1911 * 0.3010300099849701f;
        if (_1912 > _1838) {
          _1919 = log2(cb0_009x);
          _1920 = _1919 * 0.3010300099849701f;
          if ((_1912 > _1838) && (_1912 < _1920)) {
            _1928 = ((_1911 - _1837) * 0.9030900001525879f) / ((_1919 - _1837) * 0.3010300099849701f);
            _1929 = int(_1928);
            _1931 = _1928 - float((int)(_1929));
            _1933 = _11[min((uint)(_1929), 5u)];
            _1936 = _11[min((uint)((_1929 + 1)), 5u)];
            _1941 = _1933 * 0.5f;
            _1981 = dot(float3((_1931 * _1931), _1931, 1.0f), float3(mad((_11[min((uint)((_1929 + 2)), 5u)]), 0.5f, mad(_1936, -1.0f, _1941)), (_1936 - _1933), mad(_1936, 0.5f, _1941)));
          } else {
            if (_1912 < _1920) {
              _1981 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1950 = log2(cb0_008z);
              if (!(_1912 < (_1950 * 0.3010300099849701f))) {
                _1981 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1958 = ((_1911 - _1919) * 0.9030900001525879f) / ((_1950 - _1919) * 0.3010300099849701f);
                _1959 = int(_1958);
                _1961 = _1958 - float((int)(_1959));
                _1963 = _12[min((uint)(_1959), 5u)];
                _1966 = _12[min((uint)((_1959 + 1)), 5u)];
                _1971 = _1963 * 0.5f;
                _1981 = dot(float3((_1961 * _1961), _1961, 1.0f), float3(mad((_12[min((uint)((_1959 + 2)), 5u)]), 0.5f, mad(_1966, -1.0f, _1971)), (_1966 - _1963), mad(_1966, 0.5f, _1971)));
              }
            }
          }
        } else {
          _1981 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1985 = log2(max((lerp(_1812, _1811, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1986 = _1985 * 0.3010300099849701f;
        if (_1986 > _1838) {
          _1993 = log2(cb0_009x);
          _1994 = _1993 * 0.3010300099849701f;
          if ((_1986 > _1838) && (_1986 < _1994)) {
            _2002 = ((_1985 - _1837) * 0.9030900001525879f) / ((_1993 - _1837) * 0.3010300099849701f);
            _2003 = int(_2002);
            _2005 = _2002 - float((int)(_2003));
            _2007 = _11[min((uint)(_2003), 5u)];
            _2010 = _11[min((uint)((_2003 + 1)), 5u)];
            _2015 = _2007 * 0.5f;
            _2055 = dot(float3((_2005 * _2005), _2005, 1.0f), float3(mad((_11[min((uint)((_2003 + 2)), 5u)]), 0.5f, mad(_2010, -1.0f, _2015)), (_2010 - _2007), mad(_2010, 0.5f, _2015)));
          } else {
            if (_1986 < _1994) {
              _2055 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _2024 = log2(cb0_008z);
              if (!(_1986 < (_2024 * 0.3010300099849701f))) {
                _2055 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2032 = ((_1985 - _1993) * 0.9030900001525879f) / ((_2024 - _1993) * 0.3010300099849701f);
                _2033 = int(_2032);
                _2035 = _2032 - float((int)(_2033));
                _2037 = _12[min((uint)(_2033), 5u)];
                _2040 = _12[min((uint)((_2033 + 1)), 5u)];
                _2045 = _2037 * 0.5f;
                _2055 = dot(float3((_2035 * _2035), _2035, 1.0f), float3(mad((_12[min((uint)((_2033 + 2)), 5u)]), 0.5f, mad(_2040, -1.0f, _2045)), (_2040 - _2037), mad(_2040, 0.5f, _2045)));
              }
            }
          }
        } else {
          _2055 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2059 = cb0_008w - cb0_008y;
        _2060 = (exp2(_1907 * 3.321928024291992f) - cb0_008y) / _2059;
        _2062 = (exp2(_1981 * 3.321928024291992f) - cb0_008y) / _2059;
        _2064 = (exp2(_2055 * 3.321928024291992f) - cb0_008y) / _2059;
        _2067 = mad(0.15618768334388733f, _2064, mad(0.13400420546531677f, _2062, (_2060 * 0.6624541878700256f)));
        _2070 = mad(0.053689517080783844f, _2064, mad(0.6740817427635193f, _2062, (_2060 * 0.2722287178039551f)));
        _2073 = mad(1.0103391408920288f, _2064, mad(0.00406073359772563f, _2062, (_2060 * -0.005574649665504694f)));
        _2086 = min(max(mad(-0.23642469942569733f, _2073, mad(-0.32480329275131226f, _2070, (_2067 * 1.6410233974456787f))), 0.0f), 1.0f);
        _2087 = min(max(mad(0.016756348311901093f, _2073, mad(1.6153316497802734f, _2070, (_2067 * -0.663662850856781f))), 0.0f), 1.0f);
        _2088 = min(max(mad(0.9883948564529419f, _2073, mad(-0.008284442126750946f, _2070, (_2067 * 0.011721894145011902f))), 0.0f), 1.0f);
        _2091 = mad(0.15618768334388733f, _2088, mad(0.13400420546531677f, _2087, (_2086 * 0.6624541878700256f)));
        _2094 = mad(0.053689517080783844f, _2088, mad(0.6740817427635193f, _2087, (_2086 * 0.2722287178039551f)));
        _2097 = mad(1.0103391408920288f, _2088, mad(0.00406073359772563f, _2087, (_2086 * -0.005574649665504694f)));
        _2119 = min(max((min(max(mad(-0.23642469942569733f, _2097, mad(-0.32480329275131226f, _2094, (_2091 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2120 = min(max((min(max(mad(0.016756348311901093f, _2097, mad(1.6153316497802734f, _2094, (_2091 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2121 = min(max((min(max(mad(0.9883948564529419f, _2097, mad(-0.008284442126750946f, _2094, (_2091 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2140 = exp2(log2(mad(_63, _2121, mad(_62, _2120, (_2119 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2141 = exp2(log2(mad(_66, _2121, mad(_65, _2120, (_2119 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2142 = exp2(log2(mad(_69, _2121, mad(_68, _2120, (_2119 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2962 = exp2(log2((1.0f / ((_2140 * 18.6875f) + 1.0f)) * ((_2140 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2963 = exp2(log2((1.0f / ((_2141 * 18.6875f) + 1.0f)) * ((_2141 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2964 = exp2(log2((1.0f / ((_2142 * 18.6875f) + 1.0f)) * ((_2142 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2208 = cb0_012z * _1343;
          _2209 = cb0_012z * _1344;
          _2210 = cb0_012z * _1345;
          _2213 = mad((WorkingColorSpace_256[0].z), _2210, mad((WorkingColorSpace_256[0].y), _2209, ((WorkingColorSpace_256[0].x) * _2208)));
          _2216 = mad((WorkingColorSpace_256[1].z), _2210, mad((WorkingColorSpace_256[1].y), _2209, ((WorkingColorSpace_256[1].x) * _2208)));
          _2219 = mad((WorkingColorSpace_256[2].z), _2210, mad((WorkingColorSpace_256[2].y), _2209, ((WorkingColorSpace_256[2].x) * _2208)));
          _2222 = mad(-0.21492856740951538f, _2219, mad(-0.2365107536315918f, _2216, (_2213 * 1.4514392614364624f)));
          _2225 = mad(-0.09967592358589172f, _2219, mad(1.17622971534729f, _2216, (_2213 * -0.07655377686023712f)));
          _2228 = mad(0.9977163076400757f, _2219, mad(-0.006032449658960104f, _2216, (_2213 * 0.008316148072481155f)));
          _2230 = max(_2222, max(_2225, _2228));
          if (!(_2230 < 1.000000013351432e-10f)) {
            if (!(((_2213 < 0.0f) || (_2216 < 0.0f)) || (_2219 < 0.0f))) {
              _2240 = abs(_2230);
              _2241 = (_2230 - _2222) / _2240;
              _2243 = (_2230 - _2225) / _2240;
              _2245 = (_2230 - _2228) / _2240;
              if (!(_2241 < 0.8149999976158142f)) {
                _2248 = _2241 + -0.8149999976158142f;
                _2260 = ((_2248 / exp2(log2(exp2(log2(_2248 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _2260 = _2241;
              }
              if (!(_2243 < 0.8029999732971191f)) {
                _2263 = _2243 + -0.8029999732971191f;
                _2275 = ((_2263 / exp2(log2(exp2(log2(_2263 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _2275 = _2243;
              }
              if (!(_2245 < 0.8799999952316284f)) {
                _2278 = _2245 + -0.8799999952316284f;
                _2290 = ((_2278 / exp2(log2(exp2(log2(_2278 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2290 = _2245;
              }
              _2298 = (_2230 - (_2240 * _2260));
              _2299 = (_2230 - (_2240 * _2275));
              _2300 = (_2230 - (_2240 * _2290));
            } else {
              _2298 = _2222;
              _2299 = _2225;
              _2300 = _2228;
            }
          } else {
            _2298 = _2222;
            _2299 = _2225;
            _2300 = _2228;
          }
          _2316 = ((mad(0.16386906802654266f, _2300, mad(0.14067870378494263f, _2299, (_2298 * 0.6954522132873535f))) - _2213) * cb0_012w) + _2213;
          _2317 = ((mad(0.0955343171954155f, _2300, mad(0.8596711158752441f, _2299, (_2298 * 0.044794563204050064f))) - _2216) * cb0_012w) + _2216;
          _2318 = ((mad(1.0015007257461548f, _2300, mad(0.004025210160762072f, _2299, (_2298 * -0.005525882821530104f))) - _2219) * cb0_012w) + _2219;
          _2322 = max(max(_2316, _2317), _2318);
          _2327 = (max(_2322, 1.000000013351432e-10f) - max(min(min(_2316, _2317), _2318), 1.000000013351432e-10f)) / max(_2322, 0.009999999776482582f);
          _2340 = ((_2317 + _2316) + _2318) + (sqrt((((_2318 - _2317) * _2318) + ((_2317 - _2316) * _2317)) + ((_2316 - _2318) * _2316)) * 1.75f);
          _2341 = _2340 * 0.3333333432674408f;
          _2342 = _2327 + -0.4000000059604645f;
          _2343 = _2342 * 5.0f;
          _2347 = max((1.0f - abs(_2342 * 2.5f)), 0.0f);
          _2358 = ((float((int)(((int)(uint)((int)(_2343 > 0.0f))) - ((int)(uint)((int)(_2343 < 0.0f))))) * (1.0f - (_2347 * _2347))) + 1.0f) * 0.02500000037252903f;
          if (_2341 > 0.0533333346247673f) {
            if (_2341 < 0.1599999964237213f) {
              _2367 = (((0.23999999463558197f / _2340) + -0.5f) * _2358);
            } else {
              _2367 = 0.0f;
            }
          } else {
            _2367 = _2358;
          }
          _2368 = _2367 + 1.0f;
          _2369 = _2368 * _2316;
          _2370 = _2368 * _2317;
          _2371 = _2368 * _2318;
          if (!((_2369 == _2370) && (_2370 == _2371))) {
            _2378 = ((_2369 * 2.0f) - _2370) - _2371;
            _2381 = ((_2317 - _2318) * 1.7320507764816284f) * _2368;
            _2383 = atan(_2381 / _2378);
            _2386 = (_2378 < 0.0f);
            _2387 = (_2378 == 0.0f);
            _2388 = (_2381 >= 0.0f);
            _2389 = (_2381 < 0.0f);
            _2400 = select((_2388 && _2387), 90.0f, select((_2389 && _2387), -90.0f, (select((_2389 && _2386), (_2383 + -3.1415927410125732f), select((_2388 && _2386), (_2383 + 3.1415927410125732f), _2383)) * 57.2957763671875f)));
          } else {
            _2400 = 0.0f;
          }
          _2405 = min(max(select((_2400 < 0.0f), (_2400 + 360.0f), _2400), 0.0f), 360.0f);
          if (_2405 < -180.0f) {
            _2414 = (_2405 + 360.0f);
          } else {
            if (_2405 > 180.0f) {
              _2414 = (_2405 + -360.0f);
            } else {
              _2414 = _2405;
            }
          }
          if ((_2414 > -67.5f) && (_2414 < 67.5f)) {
            _2420 = (_2414 + 67.5f) * 0.029629629105329514f;
            _2421 = int(_2420);
            _2423 = _2420 - float((int)(_2421));
            _2424 = _2423 * _2423;
            _2425 = _2424 * _2423;
            if (_2421 == 3) {
              _2453 = (((0.1666666716337204f - (_2423 * 0.5f)) + (_2424 * 0.5f)) - (_2425 * 0.1666666716337204f));
            } else {
              if (_2421 == 2) {
                _2453 = ((0.6666666865348816f - _2424) + (_2425 * 0.5f));
              } else {
                if (_2421 == 1) {
                  _2453 = (((_2425 * -0.5f) + 0.1666666716337204f) + ((_2424 + _2423) * 0.5f));
                } else {
                  _2453 = select((_2421 == 0), (_2425 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2453 = 0.0f;
          }
          _2462 = min(max(((((_2327 * 0.27000001072883606f) * (0.029999999329447746f - _2369)) * _2453) + _2369), 0.0f), 65535.0f);
          _2463 = min(max(_2370, 0.0f), 65535.0f);
          _2464 = min(max(_2371, 0.0f), 65535.0f);
          _2477 = min(max(mad(-0.21492856740951538f, _2464, mad(-0.2365107536315918f, _2463, (_2462 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2478 = min(max(mad(-0.09967592358589172f, _2464, mad(1.17622971534729f, _2463, (_2462 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2479 = min(max(mad(0.9977163076400757f, _2464, mad(-0.006032449658960104f, _2463, (_2462 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2480 = dot(float3(_2477, _2478, _2479), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
          _2503 = log2(max((lerp(_2480, _2477, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2504 = _2503 * 0.3010300099849701f;
          _2505 = log2(cb0_008x);
          _2506 = _2505 * 0.3010300099849701f;
          if (_2504 > _2506) {
            _2513 = log2(cb0_009x);
            _2514 = _2513 * 0.3010300099849701f;
            if ((_2504 > _2506) && (_2504 < _2514)) {
              _2522 = ((_2503 - _2505) * 0.9030900001525879f) / ((_2513 - _2505) * 0.3010300099849701f);
              _2523 = int(_2522);
              _2525 = _2522 - float((int)(_2523));
              _2527 = _17[min((uint)(_2523), 5u)];
              _2530 = _17[min((uint)((_2523 + 1)), 5u)];
              _2535 = _2527 * 0.5f;
              _2575 = dot(float3((_2525 * _2525), _2525, 1.0f), float3(mad((_17[min((uint)((_2523 + 2)), 5u)]), 0.5f, mad(_2530, -1.0f, _2535)), (_2530 - _2527), mad(_2530, 0.5f, _2535)));
            } else {
              if (_2504 < _2514) {
                _2575 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2544 = log2(cb0_008z);
                if (!(_2504 < (_2544 * 0.3010300099849701f))) {
                  _2575 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2552 = ((_2503 - _2513) * 0.9030900001525879f) / ((_2544 - _2513) * 0.3010300099849701f);
                  _2553 = int(_2552);
                  _2555 = _2552 - float((int)(_2553));
                  _2557 = _18[min((uint)(_2553), 5u)];
                  _2560 = _18[min((uint)((_2553 + 1)), 5u)];
                  _2565 = _2557 * 0.5f;
                  _2575 = dot(float3((_2555 * _2555), _2555, 1.0f), float3(mad((_18[min((uint)((_2553 + 2)), 5u)]), 0.5f, mad(_2560, -1.0f, _2565)), (_2560 - _2557), mad(_2560, 0.5f, _2565)));
                }
              }
            }
          } else {
            _2575 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2591 = log2(max((lerp(_2480, _2478, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2592 = _2591 * 0.3010300099849701f;
          if (_2592 > _2506) {
            _2599 = log2(cb0_009x);
            _2600 = _2599 * 0.3010300099849701f;
            if ((_2592 > _2506) && (_2592 < _2600)) {
              _2608 = ((_2591 - _2505) * 0.9030900001525879f) / ((_2599 - _2505) * 0.3010300099849701f);
              _2609 = int(_2608);
              _2611 = _2608 - float((int)(_2609));
              _2613 = _13[min((uint)(_2609), 5u)];
              _2616 = _13[min((uint)((_2609 + 1)), 5u)];
              _2621 = _2613 * 0.5f;
              _2661 = dot(float3((_2611 * _2611), _2611, 1.0f), float3(mad((_13[min((uint)((_2609 + 2)), 5u)]), 0.5f, mad(_2616, -1.0f, _2621)), (_2616 - _2613), mad(_2616, 0.5f, _2621)));
            } else {
              if (_2592 < _2600) {
                _2661 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2630 = log2(cb0_008z);
                if (!(_2592 < (_2630 * 0.3010300099849701f))) {
                  _2661 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2638 = ((_2591 - _2599) * 0.9030900001525879f) / ((_2630 - _2599) * 0.3010300099849701f);
                  _2639 = int(_2638);
                  _2641 = _2638 - float((int)(_2639));
                  _2643 = _14[min((uint)(_2639), 5u)];
                  _2646 = _14[min((uint)((_2639 + 1)), 5u)];
                  _2651 = _2643 * 0.5f;
                  _2661 = dot(float3((_2641 * _2641), _2641, 1.0f), float3(mad((_14[min((uint)((_2639 + 2)), 5u)]), 0.5f, mad(_2646, -1.0f, _2651)), (_2646 - _2643), mad(_2646, 0.5f, _2651)));
                }
              }
            }
          } else {
            _2661 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2677 = log2(max((lerp(_2480, _2479, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2678 = _2677 * 0.3010300099849701f;
          if (_2678 > _2506) {
            _2685 = log2(cb0_009x);
            _2686 = _2685 * 0.3010300099849701f;
            if ((_2678 > _2506) && (_2678 < _2686)) {
              _2694 = ((_2677 - _2505) * 0.9030900001525879f) / ((_2685 - _2505) * 0.3010300099849701f);
              _2695 = int(_2694);
              _2697 = _2694 - float((int)(_2695));
              _2699 = _15[min((uint)(_2695), 5u)];
              _2702 = _15[min((uint)((_2695 + 1)), 5u)];
              _2707 = _2699 * 0.5f;
              _2747 = dot(float3((_2697 * _2697), _2697, 1.0f), float3(mad((_15[min((uint)((_2695 + 2)), 5u)]), 0.5f, mad(_2702, -1.0f, _2707)), (_2702 - _2699), mad(_2702, 0.5f, _2707)));
            } else {
              if (_2678 < _2686) {
                _2747 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2716 = log2(cb0_008z);
                if (!(_2678 < (_2716 * 0.3010300099849701f))) {
                  _2747 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2724 = ((_2677 - _2685) * 0.9030900001525879f) / ((_2716 - _2685) * 0.3010300099849701f);
                  _2725 = int(_2724);
                  _2727 = _2724 - float((int)(_2725));
                  _2729 = _16[min((uint)(_2725), 5u)];
                  _2732 = _16[min((uint)((_2725 + 1)), 5u)];
                  _2737 = _2729 * 0.5f;
                  _2747 = dot(float3((_2727 * _2727), _2727, 1.0f), float3(mad((_16[min((uint)((_2725 + 2)), 5u)]), 0.5f, mad(_2732, -1.0f, _2737)), (_2732 - _2729), mad(_2732, 0.5f, _2737)));
                }
              }
            }
          } else {
            _2747 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2751 = cb0_008w - cb0_008y;
          _2752 = (exp2(_2575 * 3.321928024291992f) - cb0_008y) / _2751;
          _2754 = (exp2(_2661 * 3.321928024291992f) - cb0_008y) / _2751;
          _2756 = (exp2(_2747 * 3.321928024291992f) - cb0_008y) / _2751;
          _2759 = mad(0.15618768334388733f, _2756, mad(0.13400420546531677f, _2754, (_2752 * 0.6624541878700256f)));
          _2762 = mad(0.053689517080783844f, _2756, mad(0.6740817427635193f, _2754, (_2752 * 0.2722287178039551f)));
          _2765 = mad(1.0103391408920288f, _2756, mad(0.00406073359772563f, _2754, (_2752 * -0.005574649665504694f)));
          _2778 = min(max(mad(-0.23642469942569733f, _2765, mad(-0.32480329275131226f, _2762, (_2759 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2779 = min(max(mad(0.016756348311901093f, _2765, mad(1.6153316497802734f, _2762, (_2759 * -0.663662850856781f))), 0.0f), 1.0f);
          _2780 = min(max(mad(0.9883948564529419f, _2765, mad(-0.008284442126750946f, _2762, (_2759 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2783 = mad(0.15618768334388733f, _2780, mad(0.13400420546531677f, _2779, (_2778 * 0.6624541878700256f)));
          _2786 = mad(0.053689517080783844f, _2780, mad(0.6740817427635193f, _2779, (_2778 * 0.2722287178039551f)));
          _2789 = mad(1.0103391408920288f, _2780, mad(0.00406073359772563f, _2779, (_2778 * -0.005574649665504694f)));
          _2811 = min(max((min(max(mad(-0.23642469942569733f, _2789, mad(-0.32480329275131226f, _2786, (_2783 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2814 = min(max((min(max(mad(0.016756348311901093f, _2789, mad(1.6153316497802734f, _2786, (_2783 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2815 = min(max((min(max(mad(0.9883948564529419f, _2789, mad(-0.008284442126750946f, _2786, (_2783 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2962 = mad(-0.0832589864730835f, _2815, mad(-0.6217921376228333f, _2814, (_2811 * 0.0213131383061409f)));
          _2963 = mad(-0.010548308491706848f, _2815, mad(1.140804648399353f, _2814, (_2811 * -0.0016282059950754046f)));
          _2964 = mad(1.1529725790023804f, _2815, mad(-0.1289689838886261f, _2814, (_2811 * -0.00030004189466126263f)));
        } else {
          if (cb0_042w == 7) {
            _2842 = mad((WorkingColorSpace_128[0].z), _1345, mad((WorkingColorSpace_128[0].y), _1344, ((WorkingColorSpace_128[0].x) * _1343)));
            _2845 = mad((WorkingColorSpace_128[1].z), _1345, mad((WorkingColorSpace_128[1].y), _1344, ((WorkingColorSpace_128[1].x) * _1343)));
            _2848 = mad((WorkingColorSpace_128[2].z), _1345, mad((WorkingColorSpace_128[2].y), _1344, ((WorkingColorSpace_128[2].x) * _1343)));
            _2867 = exp2(log2(mad(_63, _2848, mad(_62, _2845, (_2842 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2868 = exp2(log2(mad(_66, _2848, mad(_65, _2845, (_2842 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2869 = exp2(log2(mad(_69, _2848, mad(_68, _2845, (_2842 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2962 = exp2(log2((1.0f / ((_2867 * 18.6875f) + 1.0f)) * ((_2867 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2963 = exp2(log2((1.0f / ((_2868 * 18.6875f) + 1.0f)) * ((_2868 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2964 = exp2(log2((1.0f / ((_2869 * 18.6875f) + 1.0f)) * ((_2869 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _2916 = mad((WorkingColorSpace_128[0].z), _1333, mad((WorkingColorSpace_128[0].y), _1332, ((WorkingColorSpace_128[0].x) * _1331)));
                _2919 = mad((WorkingColorSpace_128[1].z), _1333, mad((WorkingColorSpace_128[1].y), _1332, ((WorkingColorSpace_128[1].x) * _1331)));
                _2922 = mad((WorkingColorSpace_128[2].z), _1333, mad((WorkingColorSpace_128[2].y), _1332, ((WorkingColorSpace_128[2].x) * _1331)));
                _2962 = mad(_63, _2922, mad(_62, _2919, (_2916 * _61)));
                _2963 = mad(_66, _2922, mad(_65, _2919, (_2916 * _64)));
                _2964 = mad(_69, _2922, mad(_68, _2919, (_2916 * _67)));
              } else {
                _2935 = mad((WorkingColorSpace_128[0].z), _1359, mad((WorkingColorSpace_128[0].y), _1358, ((WorkingColorSpace_128[0].x) * _1357)));
                _2938 = mad((WorkingColorSpace_128[1].z), _1359, mad((WorkingColorSpace_128[1].y), _1358, ((WorkingColorSpace_128[1].x) * _1357)));
                _2941 = mad((WorkingColorSpace_128[2].z), _1359, mad((WorkingColorSpace_128[2].y), _1358, ((WorkingColorSpace_128[2].x) * _1357)));
                _2962 = exp2(log2(mad(_63, _2941, mad(_62, _2938, (_2935 * _61)))) * cb0_042z);
                _2963 = exp2(log2(mad(_66, _2941, mad(_65, _2938, (_2935 * _64)))) * cb0_042z);
                _2964 = exp2(log2(mad(_69, _2941, mad(_68, _2938, (_2935 * _67)))) * cb0_042z);
              }
            } else {
              _2962 = _1343;
              _2963 = _1344;
              _2964 = _1345;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_2962 * 0.9523810148239136f), (_2963 * 0.9523810148239136f), (_2964 * 0.9523810148239136f), 0.0f);
}
// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

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
  float _30;
  float _35;
  float _36;
  float _37;
  float _39;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _125;
  float _126;
  float _127;
  float _182;
  float _389;
  float _390;
  float _391;
  float _914;
  float _947;
  float _961;
  float _1025;
  float _1293;
  float _1294;
  float _1295;
  float _1306;
  float _1317;
  float _1486;
  float _1501;
  float _1516;
  float _1524;
  float _1525;
  float _1526;
  float _1593;
  float _1626;
  float _1640;
  float _1679;
  float _1801;
  float _1875;
  float _1949;
  float _2154;
  float _2169;
  float _2184;
  float _2192;
  float _2193;
  float _2194;
  float _2261;
  float _2294;
  float _2308;
  float _2347;
  float _2469;
  float _2555;
  float _2641;
  float _2856;
  float _2857;
  float _2858;
  bool _48;
  float _78;
  float _79;
  float _80;
  bool _163;
  float _165;
  float _196;
  float _203;
  float _206;
  float _211;
  float _212;
  float _214;
  bool _215;
  float _224;
  float _226;
  float _233;
  float _235;
  float _237;
  float _238;
  float _241;
  float _244;
  float _249;
  float _255;
  float _256;
  float _257;
  float _258;
  float _259;
  float _260;
  float _261;
  float _262;
  float _265;
  float _266;
  float _267;
  float _270;
  float _289;
  float _290;
  float _291;
  float _292;
  float _293;
  float _294;
  float _295;
  float _296;
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
  float _345;
  float _348;
  float _351;
  float _406;
  float _409;
  float _412;
  float _413;
  float _417;
  float _418;
  float _419;
  float _431;
  float _447;
  float _448;
  float _449;
  float _450;
  float _464;
  float _478;
  float _492;
  float _506;
  float _520;
  float _524;
  float _525;
  float _526;
  float _583;
  float _587;
  float _588;
  float _597;
  float _606;
  float _615;
  float _624;
  float _633;
  float _696;
  float _700;
  float _709;
  float _718;
  float _727;
  float _736;
  float _745;
  float _803;
  float _814;
  float _816;
  float _818;
  float _854;
  float _855;
  float _856;
  float _859;
  float _862;
  float _865;
  float _869;
  float _874;
  float _887;
  float _888;
  float _889;
  float _890;
  float _894;
  float _905;
  float _915;
  float _916;
  float _917;
  float _918;
  float _925;
  float _928;
  float _930;
  bool _933;
  bool _934;
  bool _935;
  bool _936;
  float _952;
  float _965;
  float _969;
  float _975;
  float _985;
  float _986;
  float _987;
  float _988;
  float _1003;
  float _1005;
  float _1007;
  float _1016;
  float _1028;
  float _1030;
  float _1034;
  float _1035;
  float _1036;
  float _1040;
  float _1041;
  float _1042;
  float _1043;
  float _1045;
  float _1046;
  float _1047;
  float _1048;
  float _1067;
  float _1069;
  float _1094;
  float _1095;
  float _1096;
  float _1103;
  float _1107;
  float _1108;
  float _1109;
  bool _1110;
  float _1114;
  float _1115;
  float _1116;
  float _1135;
  float _1136;
  float _1137;
  float _1138;
  float _1158;
  float _1159;
  float _1160;
  float _1176;
  float _1177;
  float _1178;
  float _1188;
  float _1189;
  float _1190;
  float _1216;
  float _1217;
  float _1218;
  float _1225;
  float _1226;
  float _1227;
  float _1228;
  float _1229;
  float _1230;
  float _1237;
  float _1238;
  float _1239;
  float _1251;
  float _1252;
  float _1253;
  float _1276;
  float _1279;
  float _1282;
  float _1344;
  float _1347;
  float _1350;
  float _1353;
  float _1356;
  float _1359;
  float _1434;
  float _1435;
  float _1436;
  float _1439;
  float _1442;
  float _1445;
  float _1448;
  float _1451;
  float _1454;
  float _1456;
  float _1466;
  float _1467;
  float _1469;
  float _1471;
  float _1474;
  float _1489;
  float _1504;
  float _1542;
  float _1543;
  float _1544;
  float _1548;
  float _1553;
  float _1566;
  float _1567;
  float _1568;
  float _1569;
  float _1573;
  float _1584;
  float _1594;
  float _1595;
  float _1596;
  float _1597;
  float _1604;
  float _1607;
  float _1609;
  bool _1612;
  bool _1613;
  bool _1614;
  bool _1615;
  float _1631;
  float _1646;
  int _1647;
  float _1649;
  float _1650;
  float _1651;
  float _1688;
  float _1689;
  float _1690;
  float _1703;
  float _1704;
  float _1705;
  float _1706;
  float _1729;
  float _1730;
  float _1731;
  float _1732;
  float _1739;
  float _1740;
  float _1748;
  int _1749;
  float _1751;
  float _1753;
  float _1756;
  float _1761;
  float _1770;
  float _1778;
  int _1779;
  float _1781;
  float _1783;
  float _1786;
  float _1791;
  float _1805;
  float _1806;
  float _1813;
  float _1814;
  float _1822;
  int _1823;
  float _1825;
  float _1827;
  float _1830;
  float _1835;
  float _1844;
  float _1852;
  int _1853;
  float _1855;
  float _1857;
  float _1860;
  float _1865;
  float _1879;
  float _1880;
  float _1887;
  float _1888;
  float _1896;
  int _1897;
  float _1899;
  float _1901;
  float _1904;
  float _1909;
  float _1918;
  float _1926;
  int _1927;
  float _1929;
  float _1931;
  float _1934;
  float _1939;
  float _1953;
  float _1954;
  float _1956;
  float _1958;
  float _1961;
  float _1964;
  float _1967;
  float _1980;
  float _1981;
  float _1982;
  float _1985;
  float _1988;
  float _1991;
  float _2013;
  float _2014;
  float _2015;
  float _2034;
  float _2035;
  float _2036;
  float _2102;
  float _2103;
  float _2104;
  float _2107;
  float _2110;
  float _2113;
  float _2116;
  float _2119;
  float _2122;
  float _2124;
  float _2134;
  float _2135;
  float _2137;
  float _2139;
  float _2142;
  float _2157;
  float _2172;
  float _2210;
  float _2211;
  float _2212;
  float _2216;
  float _2221;
  float _2234;
  float _2235;
  float _2236;
  float _2237;
  float _2241;
  float _2252;
  float _2262;
  float _2263;
  float _2264;
  float _2265;
  float _2272;
  float _2275;
  float _2277;
  bool _2280;
  bool _2281;
  bool _2282;
  bool _2283;
  float _2299;
  float _2314;
  int _2315;
  float _2317;
  float _2318;
  float _2319;
  float _2356;
  float _2357;
  float _2358;
  float _2371;
  float _2372;
  float _2373;
  float _2374;
  float _2397;
  float _2398;
  float _2399;
  float _2400;
  float _2407;
  float _2408;
  float _2416;
  int _2417;
  float _2419;
  float _2421;
  float _2424;
  float _2429;
  float _2438;
  float _2446;
  int _2447;
  float _2449;
  float _2451;
  float _2454;
  float _2459;
  float _2485;
  float _2486;
  float _2493;
  float _2494;
  float _2502;
  int _2503;
  float _2505;
  float _2507;
  float _2510;
  float _2515;
  float _2524;
  float _2532;
  int _2533;
  float _2535;
  float _2537;
  float _2540;
  float _2545;
  float _2571;
  float _2572;
  float _2579;
  float _2580;
  float _2588;
  int _2589;
  float _2591;
  float _2593;
  float _2596;
  float _2601;
  float _2610;
  float _2618;
  int _2619;
  float _2621;
  float _2623;
  float _2626;
  float _2631;
  float _2645;
  float _2646;
  float _2648;
  float _2650;
  float _2653;
  float _2656;
  float _2659;
  float _2672;
  float _2673;
  float _2674;
  float _2677;
  float _2680;
  float _2683;
  float _2705;
  float _2708;
  float _2709;
  float _2736;
  float _2739;
  float _2742;
  float _2761;
  float _2762;
  float _2763;
  float _2810;
  float _2813;
  float _2816;
  float _2829;
  float _2832;
  float _2835;
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
  _30 = 0.5f / cb0_037x;
  _35 = cb0_037x + -1.0f;
  _36 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _30)) / _35;
  _37 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _30)) / _35;
  _39 = float((uint)SV_DispatchThreadID.z) / _35;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _48 = (cb0_043x == 4);
        _59 = select(_48, 1.0f, 1.705051064491272f);
        _60 = select(_48, 0.0f, -0.6217921376228333f);
        _61 = select(_48, 0.0f, -0.0832589864730835f);
        _62 = select(_48, 0.0f, -0.13025647401809692f);
        _63 = select(_48, 1.0f, 1.140804648399353f);
        _64 = select(_48, 0.0f, -0.010548308491706848f);
        _65 = select(_48, 0.0f, -0.024003351107239723f);
        _66 = select(_48, 0.0f, -0.1289689838886261f);
        _67 = select(_48, 1.0f, 1.1529725790023804f);
      } else {
        _59 = 0.6954522132873535f;
        _60 = 0.14067870378494263f;
        _61 = 0.16386906802654266f;
        _62 = 0.044794563204050064f;
        _63 = 0.8596711158752441f;
        _64 = 0.0955343171954155f;
        _65 = -0.005525882821530104f;
        _66 = 0.004025210160762072f;
        _67 = 1.0015007257461548f;
      }
    } else {
      _59 = 1.0258246660232544f;
      _60 = -0.020053181797266006f;
      _61 = -0.005771636962890625f;
      _62 = -0.002234415616840124f;
      _63 = 1.0045864582061768f;
      _64 = -0.002352118492126465f;
      _65 = -0.005013350863009691f;
      _66 = -0.025290070101618767f;
      _67 = 1.0303035974502563f;
    }
  } else {
    _59 = 1.3792141675949097f;
    _60 = -0.30886411666870117f;
    _61 = -0.0703500509262085f;
    _62 = -0.06933490186929703f;
    _63 = 1.08229660987854f;
    _64 = -0.012961871922016144f;
    _65 = -0.0021590073592960835f;
    _66 = -0.0454593189060688f;
    _67 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _78 = (pow(_36, 0.012683313339948654f));
    _79 = (pow(_37, 0.012683313339948654f));
    _80 = (pow(_39, 0.012683313339948654f));
    _125 = (exp2(log2(max(0.0f, (_78 + -0.8359375f)) / (18.8515625f - (_78 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _126 = (exp2(log2(max(0.0f, (_79 + -0.8359375f)) / (18.8515625f - (_79 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _127 = (exp2(log2(max(0.0f, (_80 + -0.8359375f)) / (18.8515625f - (_80 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _125 = ((exp2((_36 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _126 = ((exp2((_37 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _127 = ((exp2((_39 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _163 = (cb0_040w != 0);
    _165 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _182 = (((((1901800.0f - (_165 * 2006400000.0f)) * _165) + 247.47999572753906f) * _165) + 0.23703999817371368f);
    } else {
      _182 = (((((2967800.0f - (_165 * 4607000064.0f)) * _165) + 99.11000061035156f) * _165) + 0.24406300485134125f);
    }
    _196 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _203 = cb0_037y * cb0_037y;
    _206 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_203 * 1.6145605741257896e-07f));
    _211 = ((_196 * 2.0f) + 4.0f) - (_206 * 8.0f);
    _212 = (_196 * 3.0f) / _211;
    _214 = (_206 * 2.0f) / _211;
    _215 = (cb0_037y < 4000.0f);
    _224 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _226 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_203 * 1.5317699909210205f)) / (_224 * _224);
    _233 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _203;
    _235 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_203 * 308.60699462890625f)) / (_233 * _233);
    _237 = rsqrt(dot(float2(_226, _235), float2(_226, _235)));
    _238 = cb0_037z * 0.05000000074505806f;
    _241 = ((_238 * _235) * _237) + _196;
    _244 = _206 - ((_238 * _226) * _237);
    _249 = (4.0f - (_244 * 8.0f)) + (_241 * 2.0f);
    _255 = (((_241 * 3.0f) / _249) - _212) + select(_215, _212, _182);
    _256 = (((_244 * 2.0f) / _249) - _214) + select(_215, _214, (((_182 * 2.869999885559082f) + -0.2750000059604645f) - ((_182 * _182) * 3.0f)));
    _257 = select(_163, _255, 0.3127000033855438f);
    _258 = select(_163, _256, 0.32899999618530273f);
    _259 = select(_163, 0.3127000033855438f, _255);
    _260 = select(_163, 0.32899999618530273f, _256);
    _261 = max(_258, 1.000000013351432e-10f);
    _262 = _257 / _261;
    _265 = ((1.0f - _257) - _258) / _261;
    _266 = max(_260, 1.000000013351432e-10f);
    _267 = _259 / _266;
    _270 = ((1.0f - _259) - _260) / _266;
    _289 = mad(-0.16140000522136688f, _270, ((_267 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _265, ((_262 * 0.8950999975204468f) + 0.266400009393692f));
    _290 = mad(0.03669999912381172f, _270, (1.7135000228881836f - (_267 * 0.7501999735832214f))) / mad(0.03669999912381172f, _265, (1.7135000228881836f - (_262 * 0.7501999735832214f)));
    _291 = mad(1.0296000242233276f, _270, ((_267 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _265, ((_262 * 0.03889999911189079f) + -0.06849999725818634f));
    _292 = mad(_290, -0.7501999735832214f, 0.0f);
    _293 = mad(_290, 1.7135000228881836f, 0.0f);
    _294 = mad(_290, 0.03669999912381172f, -0.0f);
    _295 = mad(_291, 0.03889999911189079f, 0.0f);
    _296 = mad(_291, -0.06849999725818634f, 0.0f);
    _297 = mad(_291, 1.0296000242233276f, 0.0f);
    _300 = mad(0.1599626988172531f, _295, mad(-0.1470542997121811f, _292, (_289 * 0.883457362651825f)));
    _303 = mad(0.1599626988172531f, _296, mad(-0.1470542997121811f, _293, (_289 * 0.26293492317199707f)));
    _306 = mad(0.1599626988172531f, _297, mad(-0.1470542997121811f, _294, (_289 * -0.15930065512657166f)));
    _309 = mad(0.04929120093584061f, _295, mad(0.5183603167533875f, _292, (_289 * 0.38695648312568665f)));
    _312 = mad(0.04929120093584061f, _296, mad(0.5183603167533875f, _293, (_289 * 0.11516613513231277f)));
    _315 = mad(0.04929120093584061f, _297, mad(0.5183603167533875f, _294, (_289 * -0.0697740763425827f)));
    _318 = mad(0.9684867262840271f, _295, mad(0.04004279896616936f, _292, (_289 * -0.007634039502590895f)));
    _321 = mad(0.9684867262840271f, _296, mad(0.04004279896616936f, _293, (_289 * -0.0022720457054674625f)));
    _324 = mad(0.9684867262840271f, _297, mad(0.04004279896616936f, _294, (_289 * 0.0013765322510153055f)));
    _327 = mad(_306, (WorkingColorSpace_000[2].x), mad(_303, (WorkingColorSpace_000[1].x), (_300 * (WorkingColorSpace_000[0].x))));
    _330 = mad(_306, (WorkingColorSpace_000[2].y), mad(_303, (WorkingColorSpace_000[1].y), (_300 * (WorkingColorSpace_000[0].y))));
    _333 = mad(_306, (WorkingColorSpace_000[2].z), mad(_303, (WorkingColorSpace_000[1].z), (_300 * (WorkingColorSpace_000[0].z))));
    _336 = mad(_315, (WorkingColorSpace_000[2].x), mad(_312, (WorkingColorSpace_000[1].x), (_309 * (WorkingColorSpace_000[0].x))));
    _339 = mad(_315, (WorkingColorSpace_000[2].y), mad(_312, (WorkingColorSpace_000[1].y), (_309 * (WorkingColorSpace_000[0].y))));
    _342 = mad(_315, (WorkingColorSpace_000[2].z), mad(_312, (WorkingColorSpace_000[1].z), (_309 * (WorkingColorSpace_000[0].z))));
    _345 = mad(_324, (WorkingColorSpace_000[2].x), mad(_321, (WorkingColorSpace_000[1].x), (_318 * (WorkingColorSpace_000[0].x))));
    _348 = mad(_324, (WorkingColorSpace_000[2].y), mad(_321, (WorkingColorSpace_000[1].y), (_318 * (WorkingColorSpace_000[0].y))));
    _351 = mad(_324, (WorkingColorSpace_000[2].z), mad(_321, (WorkingColorSpace_000[1].z), (_318 * (WorkingColorSpace_000[0].z))));
    _389 = mad(mad((WorkingColorSpace_064[0].z), _351, mad((WorkingColorSpace_064[0].y), _342, (_333 * (WorkingColorSpace_064[0].x)))), _127, mad(mad((WorkingColorSpace_064[0].z), _348, mad((WorkingColorSpace_064[0].y), _339, (_330 * (WorkingColorSpace_064[0].x)))), _126, (mad((WorkingColorSpace_064[0].z), _345, mad((WorkingColorSpace_064[0].y), _336, (_327 * (WorkingColorSpace_064[0].x)))) * _125)));
    _390 = mad(mad((WorkingColorSpace_064[1].z), _351, mad((WorkingColorSpace_064[1].y), _342, (_333 * (WorkingColorSpace_064[1].x)))), _127, mad(mad((WorkingColorSpace_064[1].z), _348, mad((WorkingColorSpace_064[1].y), _339, (_330 * (WorkingColorSpace_064[1].x)))), _126, (mad((WorkingColorSpace_064[1].z), _345, mad((WorkingColorSpace_064[1].y), _336, (_327 * (WorkingColorSpace_064[1].x)))) * _125)));
    _391 = mad(mad((WorkingColorSpace_064[2].z), _351, mad((WorkingColorSpace_064[2].y), _342, (_333 * (WorkingColorSpace_064[2].x)))), _127, mad(mad((WorkingColorSpace_064[2].z), _348, mad((WorkingColorSpace_064[2].y), _339, (_330 * (WorkingColorSpace_064[2].x)))), _126, (mad((WorkingColorSpace_064[2].z), _345, mad((WorkingColorSpace_064[2].y), _336, (_327 * (WorkingColorSpace_064[2].x)))) * _125)));
  } else {
    _389 = _125;
    _390 = _126;
    _391 = _127;
  }
  _406 = mad((WorkingColorSpace_128[0].z), _391, mad((WorkingColorSpace_128[0].y), _390, ((WorkingColorSpace_128[0].x) * _389)));
  _409 = mad((WorkingColorSpace_128[1].z), _391, mad((WorkingColorSpace_128[1].y), _390, ((WorkingColorSpace_128[1].x) * _389)));
  _412 = mad((WorkingColorSpace_128[2].z), _391, mad((WorkingColorSpace_128[2].y), _390, ((WorkingColorSpace_128[2].x) * _389)));
  _413 = dot(float3(_406, _409, _412), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _417 = (_406 / _413) + -1.0f;
  _418 = (_409 / _413) + -1.0f;
  _419 = (_412 / _413) + -1.0f;
  _431 = (1.0f - exp2(((_413 * _413) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_417, _418, _419), float3(_417, _418, _419)) * -4.0f));
  _447 = ((mad(-0.06368321925401688f, _412, mad(-0.3292922377586365f, _409, (_406 * 1.3704125881195068f))) - _406) * _431) + _406;
  _448 = ((mad(-0.010861365124583244f, _412, mad(1.0970927476882935f, _409, (_406 * -0.08343357592821121f))) - _409) * _431) + _409;
  _449 = ((mad(1.2036951780319214f, _412, mad(-0.09862580895423889f, _409, (_406 * -0.02579331398010254f))) - _412) * _431) + _412;
  _450 = dot(float3(_447, _448, _449), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _464 = cb0_021w + cb0_026w;
  _478 = cb0_020w * cb0_025w;
  _492 = cb0_019w * cb0_024w;
  _506 = cb0_018w * cb0_023w;
  _520 = cb0_017w * cb0_022w;
  _524 = _447 - _450;
  _525 = _448 - _450;
  _526 = _449 - _450;
  _583 = saturate(_450 / cb0_037w);
  _587 = (_583 * _583) * (3.0f - (_583 * 2.0f));
  _588 = 1.0f - _587;
  _597 = cb0_021w + cb0_036w;
  _606 = cb0_020w * cb0_035w;
  _615 = cb0_019w * cb0_034w;
  _624 = cb0_018w * cb0_033w;
  _633 = cb0_017w * cb0_032w;
  _696 = saturate((_450 - cb0_038x) / (cb0_038y - cb0_038x));
  _700 = (_696 * _696) * (3.0f - (_696 * 2.0f));
  _709 = cb0_021w + cb0_031w;
  _718 = cb0_020w * cb0_030w;
  _727 = cb0_019w * cb0_029w;
  _736 = cb0_018w * cb0_028w;
  _745 = cb0_017w * cb0_027w;
  _803 = _587 - _700;
  _814 = ((_700 * (((cb0_021x + cb0_036x) + _597) + (((cb0_020x * cb0_035x) * _606) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _624) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _633) * _524) + _450)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _615)))))) + (_588 * (((cb0_021x + cb0_026x) + _464) + (((cb0_020x * cb0_025x) * _478) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _506) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _520) * _524) + _450)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _492))))))) + ((((cb0_021x + cb0_031x) + _709) + (((cb0_020x * cb0_030x) * _718) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _736) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _745) * _524) + _450)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _727))))) * _803);
  _816 = ((_700 * (((cb0_021y + cb0_036y) + _597) + (((cb0_020y * cb0_035y) * _606) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _624) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _633) * _525) + _450)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _615)))))) + (_588 * (((cb0_021y + cb0_026y) + _464) + (((cb0_020y * cb0_025y) * _478) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _506) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _520) * _525) + _450)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _492))))))) + ((((cb0_021y + cb0_031y) + _709) + (((cb0_020y * cb0_030y) * _718) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _736) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _745) * _525) + _450)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _727))))) * _803);
  _818 = ((_700 * (((cb0_021z + cb0_036z) + _597) + (((cb0_020z * cb0_035z) * _606) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _624) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _633) * _526) + _450)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _615)))))) + (_588 * (((cb0_021z + cb0_026z) + _464) + (((cb0_020z * cb0_025z) * _478) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _506) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _520) * _526) + _450)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _492))))))) + ((((cb0_021z + cb0_031z) + _709) + (((cb0_020z * cb0_030z) * _718) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _736) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _745) * _526) + _450)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _727))))) * _803);

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
  float4 output = ProcessLutbuilder(float3(_814, _816, _818), cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _854 = ((mad(0.061360642313957214f, _818, mad(-4.540197551250458e-09f, _816, (_814 * 0.9386394023895264f))) - _814) * cb0_038z) + _814;
  _855 = ((mad(0.169205904006958f, _818, mad(0.8307942152023315f, _816, (_814 * 6.775371730327606e-08f))) - _816) * cb0_038z) + _816;
  _856 = (mad(-2.3283064365386963e-10f, _816, (_814 * -9.313225746154785e-10f)) * cb0_038z) + _818;
  _859 = mad(0.16386905312538147f, _856, mad(0.14067868888378143f, _855, (_854 * 0.6954522132873535f)));
  _862 = mad(0.0955343246459961f, _856, mad(0.8596711158752441f, _855, (_854 * 0.044794581830501556f)));
  _865 = mad(1.0015007257461548f, _856, mad(0.004025210160762072f, _855, (_854 * -0.005525882821530104f)));
  _869 = max(max(_859, _862), _865);
  _874 = (max(_869, 1.000000013351432e-10f) - max(min(min(_859, _862), _865), 1.000000013351432e-10f)) / max(_869, 0.009999999776482582f);
  _887 = ((_862 + _859) + _865) + (sqrt((((_865 - _862) * _865) + ((_862 - _859) * _862)) + ((_859 - _865) * _859)) * 1.75f);
  _888 = _887 * 0.3333333432674408f;
  _889 = _874 + -0.4000000059604645f;
  _890 = _889 * 5.0f;
  _894 = max((1.0f - abs(_889 * 2.5f)), 0.0f);
  _905 = ((float((int)(((int)(uint)((int)(_890 > 0.0f))) - ((int)(uint)((int)(_890 < 0.0f))))) * (1.0f - (_894 * _894))) + 1.0f) * 0.02500000037252903f;
  if (_888 > 0.0533333346247673f) {
    if (_888 < 0.1599999964237213f) {
      _914 = (((0.23999999463558197f / _887) + -0.5f) * _905);
    } else {
      _914 = 0.0f;
    }
  } else {
    _914 = _905;
  }
  _915 = _914 + 1.0f;
  _916 = _915 * _859;
  _917 = _915 * _862;
  _918 = _915 * _865;
  if (!((_916 == _917) && (_917 == _918))) {
    _925 = ((_916 * 2.0f) - _917) - _918;
    _928 = ((_862 - _865) * 1.7320507764816284f) * _915;
    _930 = atan(_928 / _925);
    _933 = (_925 < 0.0f);
    _934 = (_925 == 0.0f);
    _935 = (_928 >= 0.0f);
    _936 = (_928 < 0.0f);
    _947 = select((_935 && _934), 90.0f, select((_936 && _934), -90.0f, (select((_936 && _933), (_930 + -3.1415927410125732f), select((_935 && _933), (_930 + 3.1415927410125732f), _930)) * 57.2957763671875f)));
  } else {
    _947 = 0.0f;
  }
  _952 = min(max(select((_947 < 0.0f), (_947 + 360.0f), _947), 0.0f), 360.0f);
  if (_952 < -180.0f) {
    _961 = (_952 + 360.0f);
  } else {
    if (_952 > 180.0f) {
      _961 = (_952 + -360.0f);
    } else {
      _961 = _952;
    }
  }
  _965 = saturate(1.0f - abs(_961 * 0.014814814552664757f));
  _969 = (_965 * _965) * (3.0f - (_965 * 2.0f));
  _975 = ((_969 * _969) * ((_874 * 0.18000000715255737f) * (0.029999999329447746f - _916))) + _916;
  _985 = max(0.0f, mad(-0.21492856740951538f, _918, mad(-0.2365107536315918f, _917, (_975 * 1.4514392614364624f))));
  _986 = max(0.0f, mad(-0.09967592358589172f, _918, mad(1.17622971534729f, _917, (_975 * -0.07655377686023712f))));
  _987 = max(0.0f, mad(0.9977163076400757f, _918, mad(-0.006032449658960104f, _917, (_975 * 0.008316148072481155f))));
  _988 = dot(float3(_985, _986, _987), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1003 = (cb0_040x + 1.0f) - cb0_039z;
  _1005 = cb0_040y + 1.0f;
  _1007 = _1005 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1025 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1016 = (cb0_040x + 0.18000000715255737f) / _1003;
    _1025 = (-0.7447274923324585f - ((log2(_1016 / (2.0f - _1016)) * 0.3465735912322998f) * (_1003 / cb0_039y)));
  }
  _1028 = ((1.0f - cb0_039z) / cb0_039y) - _1025;
  _1030 = (cb0_039w / cb0_039y) - _1028;
  _1034 = log2(lerp(_988, _985, 0.9599999785423279f)) * 0.3010300099849701f;
  _1035 = log2(lerp(_988, _986, 0.9599999785423279f)) * 0.3010300099849701f;
  _1036 = log2(lerp(_988, _987, 0.9599999785423279f)) * 0.3010300099849701f;
  _1040 = cb0_039y * (_1034 + _1028);
  _1041 = cb0_039y * (_1035 + _1028);
  _1042 = cb0_039y * (_1036 + _1028);
  _1043 = _1003 * 2.0f;
  _1045 = (cb0_039y * -2.0f) / _1003;
  _1046 = _1034 - _1025;
  _1047 = _1035 - _1025;
  _1048 = _1036 - _1025;
  _1067 = _1007 * 2.0f;
  _1069 = (cb0_039y * 2.0f) / _1007;
  _1094 = select((_1034 < _1025), ((_1043 / (exp2((_1046 * 1.4426950216293335f) * _1045) + 1.0f)) - cb0_040x), _1040);
  _1095 = select((_1035 < _1025), ((_1043 / (exp2((_1047 * 1.4426950216293335f) * _1045) + 1.0f)) - cb0_040x), _1041);
  _1096 = select((_1036 < _1025), ((_1043 / (exp2((_1048 * 1.4426950216293335f) * _1045) + 1.0f)) - cb0_040x), _1042);
  _1103 = _1030 - _1025;
  _1107 = saturate(_1046 / _1103);
  _1108 = saturate(_1047 / _1103);
  _1109 = saturate(_1048 / _1103);
  _1110 = (_1030 < _1025);
  _1114 = select(_1110, (1.0f - _1107), _1107);
  _1115 = select(_1110, (1.0f - _1108), _1108);
  _1116 = select(_1110, (1.0f - _1109), _1109);
  _1135 = (((_1114 * _1114) * (select((_1034 > _1030), (_1005 - (_1067 / (exp2(((_1034 - _1030) * 1.4426950216293335f) * _1069) + 1.0f))), _1040) - _1094)) * (3.0f - (_1114 * 2.0f))) + _1094;
  _1136 = (((_1115 * _1115) * (select((_1035 > _1030), (_1005 - (_1067 / (exp2(((_1035 - _1030) * 1.4426950216293335f) * _1069) + 1.0f))), _1041) - _1095)) * (3.0f - (_1115 * 2.0f))) + _1095;
  _1137 = (((_1116 * _1116) * (select((_1036 > _1030), (_1005 - (_1067 / (exp2(((_1036 - _1030) * 1.4426950216293335f) * _1069) + 1.0f))), _1042) - _1096)) * (3.0f - (_1116 * 2.0f))) + _1096;
  _1138 = dot(float3(_1135, _1136, _1137), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1158 = (cb0_039x * (max(0.0f, (lerp(_1138, _1135, 0.9300000071525574f))) - _854)) + _854;
  _1159 = (cb0_039x * (max(0.0f, (lerp(_1138, _1136, 0.9300000071525574f))) - _855)) + _855;
  _1160 = (cb0_039x * (max(0.0f, (lerp(_1138, _1137, 0.9300000071525574f))) - _856)) + _856;
  _1176 = ((mad(-0.06537103652954102f, _1160, mad(1.451815478503704e-06f, _1159, (_1158 * 1.065374732017517f))) - _1158) * cb0_038z) + _1158;
  _1177 = ((mad(-0.20366770029067993f, _1160, mad(1.2036634683609009f, _1159, (_1158 * -2.57161445915699e-07f))) - _1159) * cb0_038z) + _1159;
  _1178 = ((mad(0.9999996423721313f, _1160, mad(2.0954757928848267e-08f, _1159, (_1158 * 1.862645149230957e-08f))) - _1160) * cb0_038z) + _1160;
  _1188 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1178, mad((WorkingColorSpace_192[0].y), _1177, ((WorkingColorSpace_192[0].x) * _1176))));
  _1189 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1178, mad((WorkingColorSpace_192[1].y), _1177, ((WorkingColorSpace_192[1].x) * _1176))));
  _1190 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1178, mad((WorkingColorSpace_192[2].y), _1177, ((WorkingColorSpace_192[2].x) * _1176))));
  _1216 = cb0_016x * (((cb0_041y + (cb0_041x * _1188)) * _1188) + cb0_041z);
  _1217 = cb0_016y * (((cb0_041y + (cb0_041x * _1189)) * _1189) + cb0_041z);
  _1218 = cb0_016z * (((cb0_041y + (cb0_041x * _1190)) * _1190) + cb0_041z);
  _1225 = ((cb0_015x - _1216) * cb0_015w) + _1216;
  _1226 = ((cb0_015y - _1217) * cb0_015w) + _1217;
  _1227 = ((cb0_015z - _1218) * cb0_015w) + _1218;
  _1228 = cb0_016x * mad((WorkingColorSpace_192[0].z), _818, mad((WorkingColorSpace_192[0].y), _816, (_814 * (WorkingColorSpace_192[0].x))));
  _1229 = cb0_016y * mad((WorkingColorSpace_192[1].z), _818, mad((WorkingColorSpace_192[1].y), _816, ((WorkingColorSpace_192[1].x) * _814)));
  _1230 = cb0_016z * mad((WorkingColorSpace_192[2].z), _818, mad((WorkingColorSpace_192[2].y), _816, ((WorkingColorSpace_192[2].x) * _814)));
  _1237 = ((cb0_015x - _1228) * cb0_015w) + _1228;
  _1238 = ((cb0_015y - _1229) * cb0_015w) + _1229;
  _1239 = ((cb0_015z - _1230) * cb0_015w) + _1230;
  _1251 = exp2(log2(max(0.0f, _1225)) * cb0_042y);
  _1252 = exp2(log2(max(0.0f, _1226)) * cb0_042y);
  _1253 = exp2(log2(max(0.0f, _1227)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1276 = mad((WorkingColorSpace_128[0].z), _1253, mad((WorkingColorSpace_128[0].y), _1252, ((WorkingColorSpace_128[0].x) * _1251)));
      _1279 = mad((WorkingColorSpace_128[1].z), _1253, mad((WorkingColorSpace_128[1].y), _1252, ((WorkingColorSpace_128[1].x) * _1251)));
      _1282 = mad((WorkingColorSpace_128[2].z), _1253, mad((WorkingColorSpace_128[2].y), _1252, ((WorkingColorSpace_128[2].x) * _1251)));
      _1293 = mad(_61, _1282, mad(_60, _1279, (_1276 * _59)));
      _1294 = mad(_64, _1282, mad(_63, _1279, (_1276 * _62)));
      _1295 = mad(_67, _1282, mad(_66, _1279, (_1276 * _65)));
    } else {
      _1293 = _1251;
      _1294 = _1252;
      _1295 = _1253;
    }
    if (_1293 < 0.0031306699384003878f) {
      _1306 = (_1293 * 12.920000076293945f);
    } else {
      _1306 = (((pow(_1293, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1294 < 0.0031306699384003878f) {
      _1317 = (_1294 * 12.920000076293945f);
    } else {
      _1317 = (((pow(_1294, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1295 < 0.0031306699384003878f) {
      _2856 = _1306;
      _2857 = _1317;
      _2858 = (_1295 * 12.920000076293945f);
    } else {
      _2856 = _1306;
      _2857 = _1317;
      _2858 = (((pow(_1295, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1344 = mad((WorkingColorSpace_128[0].z), _1253, mad((WorkingColorSpace_128[0].y), _1252, ((WorkingColorSpace_128[0].x) * _1251)));
      _1347 = mad((WorkingColorSpace_128[1].z), _1253, mad((WorkingColorSpace_128[1].y), _1252, ((WorkingColorSpace_128[1].x) * _1251)));
      _1350 = mad((WorkingColorSpace_128[2].z), _1253, mad((WorkingColorSpace_128[2].y), _1252, ((WorkingColorSpace_128[2].x) * _1251)));
      _1353 = mad(_61, _1350, mad(_60, _1347, (_1344 * _59)));
      _1356 = mad(_64, _1350, mad(_63, _1347, (_1344 * _62)));
      _1359 = mad(_67, _1350, mad(_66, _1347, (_1344 * _65)));
      _2856 = min((_1353 * 4.5f), ((exp2(log2(max(_1353, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2857 = min((_1356 * 4.5f), ((exp2(log2(max(_1356, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2858 = min((_1359 * 4.5f), ((exp2(log2(max(_1359, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
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
        _1434 = cb0_012z * _1237;
        _1435 = cb0_012z * _1238;
        _1436 = cb0_012z * _1239;
        _1439 = mad((WorkingColorSpace_256[0].z), _1436, mad((WorkingColorSpace_256[0].y), _1435, ((WorkingColorSpace_256[0].x) * _1434)));
        _1442 = mad((WorkingColorSpace_256[1].z), _1436, mad((WorkingColorSpace_256[1].y), _1435, ((WorkingColorSpace_256[1].x) * _1434)));
        _1445 = mad((WorkingColorSpace_256[2].z), _1436, mad((WorkingColorSpace_256[2].y), _1435, ((WorkingColorSpace_256[2].x) * _1434)));
        _1448 = mad(-0.21492856740951538f, _1445, mad(-0.2365107536315918f, _1442, (_1439 * 1.4514392614364624f)));
        _1451 = mad(-0.09967592358589172f, _1445, mad(1.17622971534729f, _1442, (_1439 * -0.07655377686023712f)));
        _1454 = mad(0.9977163076400757f, _1445, mad(-0.006032449658960104f, _1442, (_1439 * 0.008316148072481155f)));
        _1456 = max(_1448, max(_1451, _1454));
        if (!(_1456 < 1.000000013351432e-10f)) {
          if (!(((_1439 < 0.0f) || (_1442 < 0.0f)) || (_1445 < 0.0f))) {
            _1466 = abs(_1456);
            _1467 = (_1456 - _1448) / _1466;
            _1469 = (_1456 - _1451) / _1466;
            _1471 = (_1456 - _1454) / _1466;
            if (!(_1467 < 0.8149999976158142f)) {
              _1474 = _1467 + -0.8149999976158142f;
              _1486 = ((_1474 / exp2(log2(exp2(log2(_1474 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1486 = _1467;
            }
            if (!(_1469 < 0.8029999732971191f)) {
              _1489 = _1469 + -0.8029999732971191f;
              _1501 = ((_1489 / exp2(log2(exp2(log2(_1489 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1501 = _1469;
            }
            if (!(_1471 < 0.8799999952316284f)) {
              _1504 = _1471 + -0.8799999952316284f;
              _1516 = ((_1504 / exp2(log2(exp2(log2(_1504 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1516 = _1471;
            }
            _1524 = (_1456 - (_1466 * _1486));
            _1525 = (_1456 - (_1466 * _1501));
            _1526 = (_1456 - (_1466 * _1516));
          } else {
            _1524 = _1448;
            _1525 = _1451;
            _1526 = _1454;
          }
        } else {
          _1524 = _1448;
          _1525 = _1451;
          _1526 = _1454;
        }
        _1542 = ((mad(0.16386906802654266f, _1526, mad(0.14067870378494263f, _1525, (_1524 * 0.6954522132873535f))) - _1439) * cb0_012w) + _1439;
        _1543 = ((mad(0.0955343171954155f, _1526, mad(0.8596711158752441f, _1525, (_1524 * 0.044794563204050064f))) - _1442) * cb0_012w) + _1442;
        _1544 = ((mad(1.0015007257461548f, _1526, mad(0.004025210160762072f, _1525, (_1524 * -0.005525882821530104f))) - _1445) * cb0_012w) + _1445;
        _1548 = max(max(_1542, _1543), _1544);
        _1553 = (max(_1548, 1.000000013351432e-10f) - max(min(min(_1542, _1543), _1544), 1.000000013351432e-10f)) / max(_1548, 0.009999999776482582f);
        _1566 = ((_1543 + _1542) + _1544) + (sqrt((((_1544 - _1543) * _1544) + ((_1543 - _1542) * _1543)) + ((_1542 - _1544) * _1542)) * 1.75f);
        _1567 = _1566 * 0.3333333432674408f;
        _1568 = _1553 + -0.4000000059604645f;
        _1569 = _1568 * 5.0f;
        _1573 = max((1.0f - abs(_1568 * 2.5f)), 0.0f);
        _1584 = ((float((int)(((int)(uint)((int)(_1569 > 0.0f))) - ((int)(uint)((int)(_1569 < 0.0f))))) * (1.0f - (_1573 * _1573))) + 1.0f) * 0.02500000037252903f;
        if (_1567 > 0.0533333346247673f) {
          if (_1567 < 0.1599999964237213f) {
            _1593 = (((0.23999999463558197f / _1566) + -0.5f) * _1584);
          } else {
            _1593 = 0.0f;
          }
        } else {
          _1593 = _1584;
        }
        _1594 = _1593 + 1.0f;
        _1595 = _1594 * _1542;
        _1596 = _1594 * _1543;
        _1597 = _1594 * _1544;
        if (!((_1595 == _1596) && (_1596 == _1597))) {
          _1604 = ((_1595 * 2.0f) - _1596) - _1597;
          _1607 = ((_1543 - _1544) * 1.7320507764816284f) * _1594;
          _1609 = atan(_1607 / _1604);
          _1612 = (_1604 < 0.0f);
          _1613 = (_1604 == 0.0f);
          _1614 = (_1607 >= 0.0f);
          _1615 = (_1607 < 0.0f);
          _1626 = select((_1614 && _1613), 90.0f, select((_1615 && _1613), -90.0f, (select((_1615 && _1612), (_1609 + -3.1415927410125732f), select((_1614 && _1612), (_1609 + 3.1415927410125732f), _1609)) * 57.2957763671875f)));
        } else {
          _1626 = 0.0f;
        }
        _1631 = min(max(select((_1626 < 0.0f), (_1626 + 360.0f), _1626), 0.0f), 360.0f);
        if (_1631 < -180.0f) {
          _1640 = (_1631 + 360.0f);
        } else {
          if (_1631 > 180.0f) {
            _1640 = (_1631 + -360.0f);
          } else {
            _1640 = _1631;
          }
        }
        if ((_1640 > -67.5f) && (_1640 < 67.5f)) {
          _1646 = (_1640 + 67.5f) * 0.029629629105329514f;
          _1647 = int(_1646);
          _1649 = _1646 - float((int)(_1647));
          _1650 = _1649 * _1649;
          _1651 = _1650 * _1649;
          if (_1647 == 3) {
            _1679 = (((0.1666666716337204f - (_1649 * 0.5f)) + (_1650 * 0.5f)) - (_1651 * 0.1666666716337204f));
          } else {
            if (_1647 == 2) {
              _1679 = ((0.6666666865348816f - _1650) + (_1651 * 0.5f));
            } else {
              if (_1647 == 1) {
                _1679 = (((_1651 * -0.5f) + 0.1666666716337204f) + ((_1650 + _1649) * 0.5f));
              } else {
                _1679 = select((_1647 == 0), (_1651 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1679 = 0.0f;
        }
        _1688 = min(max(((((_1553 * 0.27000001072883606f) * (0.029999999329447746f - _1595)) * _1679) + _1595), 0.0f), 65535.0f);
        _1689 = min(max(_1596, 0.0f), 65535.0f);
        _1690 = min(max(_1597, 0.0f), 65535.0f);
        _1703 = min(max(mad(-0.21492856740951538f, _1690, mad(-0.2365107536315918f, _1689, (_1688 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1704 = min(max(mad(-0.09967592358589172f, _1690, mad(1.17622971534729f, _1689, (_1688 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1705 = min(max(mad(0.9977163076400757f, _1690, mad(-0.006032449658960104f, _1689, (_1688 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1706 = dot(float3(_1703, _1704, _1705), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
        _1729 = log2(max((lerp(_1706, _1703, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1730 = _1729 * 0.3010300099849701f;
        _1731 = log2(cb0_008x);
        _1732 = _1731 * 0.3010300099849701f;
        if (_1730 > _1732) {
          _1739 = log2(cb0_009x);
          _1740 = _1739 * 0.3010300099849701f;
          if ((_1730 > _1732) && (_1730 < _1740)) {
            _1748 = ((_1729 - _1731) * 0.9030900001525879f) / ((_1739 - _1731) * 0.3010300099849701f);
            _1749 = int(_1748);
            _1751 = _1748 - float((int)(_1749));
            _1753 = _17[min((uint)(_1749), 5u)];
            _1756 = _17[min((uint)((_1749 + 1)), 5u)];
            _1761 = _1753 * 0.5f;
            _1801 = dot(float3((_1751 * _1751), _1751, 1.0f), float3(mad((_17[min((uint)((_1749 + 2)), 5u)]), 0.5f, mad(_1756, -1.0f, _1761)), (_1756 - _1753), mad(_1756, 0.5f, _1761)));
          } else {
            if (_1730 < _1740) {
              _1801 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1770 = log2(cb0_008z);
              if (!(_1730 < (_1770 * 0.3010300099849701f))) {
                _1801 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1778 = ((_1729 - _1739) * 0.9030900001525879f) / ((_1770 - _1739) * 0.3010300099849701f);
                _1779 = int(_1778);
                _1781 = _1778 - float((int)(_1779));
                _1783 = _18[min((uint)(_1779), 5u)];
                _1786 = _18[min((uint)((_1779 + 1)), 5u)];
                _1791 = _1783 * 0.5f;
                _1801 = dot(float3((_1781 * _1781), _1781, 1.0f), float3(mad((_18[min((uint)((_1779 + 2)), 5u)]), 0.5f, mad(_1786, -1.0f, _1791)), (_1786 - _1783), mad(_1786, 0.5f, _1791)));
              }
            }
          }
        } else {
          _1801 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1805 = log2(max((lerp(_1706, _1704, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1806 = _1805 * 0.3010300099849701f;
        if (_1806 > _1732) {
          _1813 = log2(cb0_009x);
          _1814 = _1813 * 0.3010300099849701f;
          if ((_1806 > _1732) && (_1806 < _1814)) {
            _1822 = ((_1805 - _1731) * 0.9030900001525879f) / ((_1813 - _1731) * 0.3010300099849701f);
            _1823 = int(_1822);
            _1825 = _1822 - float((int)(_1823));
            _1827 = _9[min((uint)(_1823), 5u)];
            _1830 = _9[min((uint)((_1823 + 1)), 5u)];
            _1835 = _1827 * 0.5f;
            _1875 = dot(float3((_1825 * _1825), _1825, 1.0f), float3(mad((_9[min((uint)((_1823 + 2)), 5u)]), 0.5f, mad(_1830, -1.0f, _1835)), (_1830 - _1827), mad(_1830, 0.5f, _1835)));
          } else {
            if (_1806 < _1814) {
              _1875 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1844 = log2(cb0_008z);
              if (!(_1806 < (_1844 * 0.3010300099849701f))) {
                _1875 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1852 = ((_1805 - _1813) * 0.9030900001525879f) / ((_1844 - _1813) * 0.3010300099849701f);
                _1853 = int(_1852);
                _1855 = _1852 - float((int)(_1853));
                _1857 = _10[min((uint)(_1853), 5u)];
                _1860 = _10[min((uint)((_1853 + 1)), 5u)];
                _1865 = _1857 * 0.5f;
                _1875 = dot(float3((_1855 * _1855), _1855, 1.0f), float3(mad((_10[min((uint)((_1853 + 2)), 5u)]), 0.5f, mad(_1860, -1.0f, _1865)), (_1860 - _1857), mad(_1860, 0.5f, _1865)));
              }
            }
          }
        } else {
          _1875 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1879 = log2(max((lerp(_1706, _1705, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1880 = _1879 * 0.3010300099849701f;
        if (_1880 > _1732) {
          _1887 = log2(cb0_009x);
          _1888 = _1887 * 0.3010300099849701f;
          if ((_1880 > _1732) && (_1880 < _1888)) {
            _1896 = ((_1879 - _1731) * 0.9030900001525879f) / ((_1887 - _1731) * 0.3010300099849701f);
            _1897 = int(_1896);
            _1899 = _1896 - float((int)(_1897));
            _1901 = _9[min((uint)(_1897), 5u)];
            _1904 = _9[min((uint)((_1897 + 1)), 5u)];
            _1909 = _1901 * 0.5f;
            _1949 = dot(float3((_1899 * _1899), _1899, 1.0f), float3(mad((_9[min((uint)((_1897 + 2)), 5u)]), 0.5f, mad(_1904, -1.0f, _1909)), (_1904 - _1901), mad(_1904, 0.5f, _1909)));
          } else {
            if (_1880 < _1888) {
              _1949 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1918 = log2(cb0_008z);
              if (!(_1880 < (_1918 * 0.3010300099849701f))) {
                _1949 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1926 = ((_1879 - _1887) * 0.9030900001525879f) / ((_1918 - _1887) * 0.3010300099849701f);
                _1927 = int(_1926);
                _1929 = _1926 - float((int)(_1927));
                _1931 = _10[min((uint)(_1927), 5u)];
                _1934 = _10[min((uint)((_1927 + 1)), 5u)];
                _1939 = _1931 * 0.5f;
                _1949 = dot(float3((_1929 * _1929), _1929, 1.0f), float3(mad((_10[min((uint)((_1927 + 2)), 5u)]), 0.5f, mad(_1934, -1.0f, _1939)), (_1934 - _1931), mad(_1934, 0.5f, _1939)));
              }
            }
          }
        } else {
          _1949 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1953 = cb0_008w - cb0_008y;
        _1954 = (exp2(_1801 * 3.321928024291992f) - cb0_008y) / _1953;
        _1956 = (exp2(_1875 * 3.321928024291992f) - cb0_008y) / _1953;
        _1958 = (exp2(_1949 * 3.321928024291992f) - cb0_008y) / _1953;
        _1961 = mad(0.15618768334388733f, _1958, mad(0.13400420546531677f, _1956, (_1954 * 0.6624541878700256f)));
        _1964 = mad(0.053689517080783844f, _1958, mad(0.6740817427635193f, _1956, (_1954 * 0.2722287178039551f)));
        _1967 = mad(1.0103391408920288f, _1958, mad(0.00406073359772563f, _1956, (_1954 * -0.005574649665504694f)));
        _1980 = min(max(mad(-0.23642469942569733f, _1967, mad(-0.32480329275131226f, _1964, (_1961 * 1.6410233974456787f))), 0.0f), 1.0f);
        _1981 = min(max(mad(0.016756348311901093f, _1967, mad(1.6153316497802734f, _1964, (_1961 * -0.663662850856781f))), 0.0f), 1.0f);
        _1982 = min(max(mad(0.9883948564529419f, _1967, mad(-0.008284442126750946f, _1964, (_1961 * 0.011721894145011902f))), 0.0f), 1.0f);
        _1985 = mad(0.15618768334388733f, _1982, mad(0.13400420546531677f, _1981, (_1980 * 0.6624541878700256f)));
        _1988 = mad(0.053689517080783844f, _1982, mad(0.6740817427635193f, _1981, (_1980 * 0.2722287178039551f)));
        _1991 = mad(1.0103391408920288f, _1982, mad(0.00406073359772563f, _1981, (_1980 * -0.005574649665504694f)));
        _2013 = min(max((min(max(mad(-0.23642469942569733f, _1991, mad(-0.32480329275131226f, _1988, (_1985 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2014 = min(max((min(max(mad(0.016756348311901093f, _1991, mad(1.6153316497802734f, _1988, (_1985 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2015 = min(max((min(max(mad(0.9883948564529419f, _1991, mad(-0.008284442126750946f, _1988, (_1985 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2034 = exp2(log2(mad(_61, _2015, mad(_60, _2014, (_2013 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2035 = exp2(log2(mad(_64, _2015, mad(_63, _2014, (_2013 * _62))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2036 = exp2(log2(mad(_67, _2015, mad(_66, _2014, (_2013 * _65))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2856 = exp2(log2((1.0f / ((_2034 * 18.6875f) + 1.0f)) * ((_2034 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2857 = exp2(log2((1.0f / ((_2035 * 18.6875f) + 1.0f)) * ((_2035 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2858 = exp2(log2((1.0f / ((_2036 * 18.6875f) + 1.0f)) * ((_2036 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2102 = cb0_012z * _1237;
          _2103 = cb0_012z * _1238;
          _2104 = cb0_012z * _1239;
          _2107 = mad((WorkingColorSpace_256[0].z), _2104, mad((WorkingColorSpace_256[0].y), _2103, ((WorkingColorSpace_256[0].x) * _2102)));
          _2110 = mad((WorkingColorSpace_256[1].z), _2104, mad((WorkingColorSpace_256[1].y), _2103, ((WorkingColorSpace_256[1].x) * _2102)));
          _2113 = mad((WorkingColorSpace_256[2].z), _2104, mad((WorkingColorSpace_256[2].y), _2103, ((WorkingColorSpace_256[2].x) * _2102)));
          _2116 = mad(-0.21492856740951538f, _2113, mad(-0.2365107536315918f, _2110, (_2107 * 1.4514392614364624f)));
          _2119 = mad(-0.09967592358589172f, _2113, mad(1.17622971534729f, _2110, (_2107 * -0.07655377686023712f)));
          _2122 = mad(0.9977163076400757f, _2113, mad(-0.006032449658960104f, _2110, (_2107 * 0.008316148072481155f)));
          _2124 = max(_2116, max(_2119, _2122));
          if (!(_2124 < 1.000000013351432e-10f)) {
            if (!(((_2107 < 0.0f) || (_2110 < 0.0f)) || (_2113 < 0.0f))) {
              _2134 = abs(_2124);
              _2135 = (_2124 - _2116) / _2134;
              _2137 = (_2124 - _2119) / _2134;
              _2139 = (_2124 - _2122) / _2134;
              if (!(_2135 < 0.8149999976158142f)) {
                _2142 = _2135 + -0.8149999976158142f;
                _2154 = ((_2142 / exp2(log2(exp2(log2(_2142 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _2154 = _2135;
              }
              if (!(_2137 < 0.8029999732971191f)) {
                _2157 = _2137 + -0.8029999732971191f;
                _2169 = ((_2157 / exp2(log2(exp2(log2(_2157 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _2169 = _2137;
              }
              if (!(_2139 < 0.8799999952316284f)) {
                _2172 = _2139 + -0.8799999952316284f;
                _2184 = ((_2172 / exp2(log2(exp2(log2(_2172 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2184 = _2139;
              }
              _2192 = (_2124 - (_2134 * _2154));
              _2193 = (_2124 - (_2134 * _2169));
              _2194 = (_2124 - (_2134 * _2184));
            } else {
              _2192 = _2116;
              _2193 = _2119;
              _2194 = _2122;
            }
          } else {
            _2192 = _2116;
            _2193 = _2119;
            _2194 = _2122;
          }
          _2210 = ((mad(0.16386906802654266f, _2194, mad(0.14067870378494263f, _2193, (_2192 * 0.6954522132873535f))) - _2107) * cb0_012w) + _2107;
          _2211 = ((mad(0.0955343171954155f, _2194, mad(0.8596711158752441f, _2193, (_2192 * 0.044794563204050064f))) - _2110) * cb0_012w) + _2110;
          _2212 = ((mad(1.0015007257461548f, _2194, mad(0.004025210160762072f, _2193, (_2192 * -0.005525882821530104f))) - _2113) * cb0_012w) + _2113;
          _2216 = max(max(_2210, _2211), _2212);
          _2221 = (max(_2216, 1.000000013351432e-10f) - max(min(min(_2210, _2211), _2212), 1.000000013351432e-10f)) / max(_2216, 0.009999999776482582f);
          _2234 = ((_2211 + _2210) + _2212) + (sqrt((((_2212 - _2211) * _2212) + ((_2211 - _2210) * _2211)) + ((_2210 - _2212) * _2210)) * 1.75f);
          _2235 = _2234 * 0.3333333432674408f;
          _2236 = _2221 + -0.4000000059604645f;
          _2237 = _2236 * 5.0f;
          _2241 = max((1.0f - abs(_2236 * 2.5f)), 0.0f);
          _2252 = ((float((int)(((int)(uint)((int)(_2237 > 0.0f))) - ((int)(uint)((int)(_2237 < 0.0f))))) * (1.0f - (_2241 * _2241))) + 1.0f) * 0.02500000037252903f;
          if (_2235 > 0.0533333346247673f) {
            if (_2235 < 0.1599999964237213f) {
              _2261 = (((0.23999999463558197f / _2234) + -0.5f) * _2252);
            } else {
              _2261 = 0.0f;
            }
          } else {
            _2261 = _2252;
          }
          _2262 = _2261 + 1.0f;
          _2263 = _2262 * _2210;
          _2264 = _2262 * _2211;
          _2265 = _2262 * _2212;
          if (!((_2263 == _2264) && (_2264 == _2265))) {
            _2272 = ((_2263 * 2.0f) - _2264) - _2265;
            _2275 = ((_2211 - _2212) * 1.7320507764816284f) * _2262;
            _2277 = atan(_2275 / _2272);
            _2280 = (_2272 < 0.0f);
            _2281 = (_2272 == 0.0f);
            _2282 = (_2275 >= 0.0f);
            _2283 = (_2275 < 0.0f);
            _2294 = select((_2282 && _2281), 90.0f, select((_2283 && _2281), -90.0f, (select((_2283 && _2280), (_2277 + -3.1415927410125732f), select((_2282 && _2280), (_2277 + 3.1415927410125732f), _2277)) * 57.2957763671875f)));
          } else {
            _2294 = 0.0f;
          }
          _2299 = min(max(select((_2294 < 0.0f), (_2294 + 360.0f), _2294), 0.0f), 360.0f);
          if (_2299 < -180.0f) {
            _2308 = (_2299 + 360.0f);
          } else {
            if (_2299 > 180.0f) {
              _2308 = (_2299 + -360.0f);
            } else {
              _2308 = _2299;
            }
          }
          if ((_2308 > -67.5f) && (_2308 < 67.5f)) {
            _2314 = (_2308 + 67.5f) * 0.029629629105329514f;
            _2315 = int(_2314);
            _2317 = _2314 - float((int)(_2315));
            _2318 = _2317 * _2317;
            _2319 = _2318 * _2317;
            if (_2315 == 3) {
              _2347 = (((0.1666666716337204f - (_2317 * 0.5f)) + (_2318 * 0.5f)) - (_2319 * 0.1666666716337204f));
            } else {
              if (_2315 == 2) {
                _2347 = ((0.6666666865348816f - _2318) + (_2319 * 0.5f));
              } else {
                if (_2315 == 1) {
                  _2347 = (((_2319 * -0.5f) + 0.1666666716337204f) + ((_2318 + _2317) * 0.5f));
                } else {
                  _2347 = select((_2315 == 0), (_2319 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2347 = 0.0f;
          }
          _2356 = min(max(((((_2221 * 0.27000001072883606f) * (0.029999999329447746f - _2263)) * _2347) + _2263), 0.0f), 65535.0f);
          _2357 = min(max(_2264, 0.0f), 65535.0f);
          _2358 = min(max(_2265, 0.0f), 65535.0f);
          _2371 = min(max(mad(-0.21492856740951538f, _2358, mad(-0.2365107536315918f, _2357, (_2356 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2372 = min(max(mad(-0.09967592358589172f, _2358, mad(1.17622971534729f, _2357, (_2356 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2373 = min(max(mad(0.9977163076400757f, _2358, mad(-0.006032449658960104f, _2357, (_2356 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2374 = dot(float3(_2371, _2372, _2373), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
          _2397 = log2(max((lerp(_2374, _2371, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2398 = _2397 * 0.3010300099849701f;
          _2399 = log2(cb0_008x);
          _2400 = _2399 * 0.3010300099849701f;
          if (_2398 > _2400) {
            _2407 = log2(cb0_009x);
            _2408 = _2407 * 0.3010300099849701f;
            if ((_2398 > _2400) && (_2398 < _2408)) {
              _2416 = ((_2397 - _2399) * 0.9030900001525879f) / ((_2407 - _2399) * 0.3010300099849701f);
              _2417 = int(_2416);
              _2419 = _2416 - float((int)(_2417));
              _2421 = _15[min((uint)(_2417), 5u)];
              _2424 = _15[min((uint)((_2417 + 1)), 5u)];
              _2429 = _2421 * 0.5f;
              _2469 = dot(float3((_2419 * _2419), _2419, 1.0f), float3(mad((_15[min((uint)((_2417 + 2)), 5u)]), 0.5f, mad(_2424, -1.0f, _2429)), (_2424 - _2421), mad(_2424, 0.5f, _2429)));
            } else {
              if (_2398 < _2408) {
                _2469 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2438 = log2(cb0_008z);
                if (!(_2398 < (_2438 * 0.3010300099849701f))) {
                  _2469 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2446 = ((_2397 - _2407) * 0.9030900001525879f) / ((_2438 - _2407) * 0.3010300099849701f);
                  _2447 = int(_2446);
                  _2449 = _2446 - float((int)(_2447));
                  _2451 = _16[min((uint)(_2447), 5u)];
                  _2454 = _16[min((uint)((_2447 + 1)), 5u)];
                  _2459 = _2451 * 0.5f;
                  _2469 = dot(float3((_2449 * _2449), _2449, 1.0f), float3(mad((_16[min((uint)((_2447 + 2)), 5u)]), 0.5f, mad(_2454, -1.0f, _2459)), (_2454 - _2451), mad(_2454, 0.5f, _2459)));
                }
              }
            }
          } else {
            _2469 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2485 = log2(max((lerp(_2374, _2372, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2486 = _2485 * 0.3010300099849701f;
          if (_2486 > _2400) {
            _2493 = log2(cb0_009x);
            _2494 = _2493 * 0.3010300099849701f;
            if ((_2486 > _2400) && (_2486 < _2494)) {
              _2502 = ((_2485 - _2399) * 0.9030900001525879f) / ((_2493 - _2399) * 0.3010300099849701f);
              _2503 = int(_2502);
              _2505 = _2502 - float((int)(_2503));
              _2507 = _11[min((uint)(_2503), 5u)];
              _2510 = _11[min((uint)((_2503 + 1)), 5u)];
              _2515 = _2507 * 0.5f;
              _2555 = dot(float3((_2505 * _2505), _2505, 1.0f), float3(mad((_11[min((uint)((_2503 + 2)), 5u)]), 0.5f, mad(_2510, -1.0f, _2515)), (_2510 - _2507), mad(_2510, 0.5f, _2515)));
            } else {
              if (_2486 < _2494) {
                _2555 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2524 = log2(cb0_008z);
                if (!(_2486 < (_2524 * 0.3010300099849701f))) {
                  _2555 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2532 = ((_2485 - _2493) * 0.9030900001525879f) / ((_2524 - _2493) * 0.3010300099849701f);
                  _2533 = int(_2532);
                  _2535 = _2532 - float((int)(_2533));
                  _2537 = _12[min((uint)(_2533), 5u)];
                  _2540 = _12[min((uint)((_2533 + 1)), 5u)];
                  _2545 = _2537 * 0.5f;
                  _2555 = dot(float3((_2535 * _2535), _2535, 1.0f), float3(mad((_12[min((uint)((_2533 + 2)), 5u)]), 0.5f, mad(_2540, -1.0f, _2545)), (_2540 - _2537), mad(_2540, 0.5f, _2545)));
                }
              }
            }
          } else {
            _2555 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2571 = log2(max((lerp(_2374, _2373, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2572 = _2571 * 0.3010300099849701f;
          if (_2572 > _2400) {
            _2579 = log2(cb0_009x);
            _2580 = _2579 * 0.3010300099849701f;
            if ((_2572 > _2400) && (_2572 < _2580)) {
              _2588 = ((_2571 - _2399) * 0.9030900001525879f) / ((_2579 - _2399) * 0.3010300099849701f);
              _2589 = int(_2588);
              _2591 = _2588 - float((int)(_2589));
              _2593 = _13[min((uint)(_2589), 5u)];
              _2596 = _13[min((uint)((_2589 + 1)), 5u)];
              _2601 = _2593 * 0.5f;
              _2641 = dot(float3((_2591 * _2591), _2591, 1.0f), float3(mad((_13[min((uint)((_2589 + 2)), 5u)]), 0.5f, mad(_2596, -1.0f, _2601)), (_2596 - _2593), mad(_2596, 0.5f, _2601)));
            } else {
              if (_2572 < _2580) {
                _2641 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2610 = log2(cb0_008z);
                if (!(_2572 < (_2610 * 0.3010300099849701f))) {
                  _2641 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2618 = ((_2571 - _2579) * 0.9030900001525879f) / ((_2610 - _2579) * 0.3010300099849701f);
                  _2619 = int(_2618);
                  _2621 = _2618 - float((int)(_2619));
                  _2623 = _14[min((uint)(_2619), 5u)];
                  _2626 = _14[min((uint)((_2619 + 1)), 5u)];
                  _2631 = _2623 * 0.5f;
                  _2641 = dot(float3((_2621 * _2621), _2621, 1.0f), float3(mad((_14[min((uint)((_2619 + 2)), 5u)]), 0.5f, mad(_2626, -1.0f, _2631)), (_2626 - _2623), mad(_2626, 0.5f, _2631)));
                }
              }
            }
          } else {
            _2641 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2645 = cb0_008w - cb0_008y;
          _2646 = (exp2(_2469 * 3.321928024291992f) - cb0_008y) / _2645;
          _2648 = (exp2(_2555 * 3.321928024291992f) - cb0_008y) / _2645;
          _2650 = (exp2(_2641 * 3.321928024291992f) - cb0_008y) / _2645;
          _2653 = mad(0.15618768334388733f, _2650, mad(0.13400420546531677f, _2648, (_2646 * 0.6624541878700256f)));
          _2656 = mad(0.053689517080783844f, _2650, mad(0.6740817427635193f, _2648, (_2646 * 0.2722287178039551f)));
          _2659 = mad(1.0103391408920288f, _2650, mad(0.00406073359772563f, _2648, (_2646 * -0.005574649665504694f)));
          _2672 = min(max(mad(-0.23642469942569733f, _2659, mad(-0.32480329275131226f, _2656, (_2653 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2673 = min(max(mad(0.016756348311901093f, _2659, mad(1.6153316497802734f, _2656, (_2653 * -0.663662850856781f))), 0.0f), 1.0f);
          _2674 = min(max(mad(0.9883948564529419f, _2659, mad(-0.008284442126750946f, _2656, (_2653 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2677 = mad(0.15618768334388733f, _2674, mad(0.13400420546531677f, _2673, (_2672 * 0.6624541878700256f)));
          _2680 = mad(0.053689517080783844f, _2674, mad(0.6740817427635193f, _2673, (_2672 * 0.2722287178039551f)));
          _2683 = mad(1.0103391408920288f, _2674, mad(0.00406073359772563f, _2673, (_2672 * -0.005574649665504694f)));
          _2705 = min(max((min(max(mad(-0.23642469942569733f, _2683, mad(-0.32480329275131226f, _2680, (_2677 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2708 = min(max((min(max(mad(0.016756348311901093f, _2683, mad(1.6153316497802734f, _2680, (_2677 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2709 = min(max((min(max(mad(0.9883948564529419f, _2683, mad(-0.008284442126750946f, _2680, (_2677 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2856 = mad(-0.0832589864730835f, _2709, mad(-0.6217921376228333f, _2708, (_2705 * 0.0213131383061409f)));
          _2857 = mad(-0.010548308491706848f, _2709, mad(1.140804648399353f, _2708, (_2705 * -0.0016282059950754046f)));
          _2858 = mad(1.1529725790023804f, _2709, mad(-0.1289689838886261f, _2708, (_2705 * -0.00030004189466126263f)));
        } else {
          if (cb0_042w == 7) {
            _2736 = mad((WorkingColorSpace_128[0].z), _1239, mad((WorkingColorSpace_128[0].y), _1238, ((WorkingColorSpace_128[0].x) * _1237)));
            _2739 = mad((WorkingColorSpace_128[1].z), _1239, mad((WorkingColorSpace_128[1].y), _1238, ((WorkingColorSpace_128[1].x) * _1237)));
            _2742 = mad((WorkingColorSpace_128[2].z), _1239, mad((WorkingColorSpace_128[2].y), _1238, ((WorkingColorSpace_128[2].x) * _1237)));
            _2761 = exp2(log2(mad(_61, _2742, mad(_60, _2739, (_2736 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2762 = exp2(log2(mad(_64, _2742, mad(_63, _2739, (_2736 * _62))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2763 = exp2(log2(mad(_67, _2742, mad(_66, _2739, (_2736 * _65))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2856 = exp2(log2((1.0f / ((_2761 * 18.6875f) + 1.0f)) * ((_2761 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2857 = exp2(log2((1.0f / ((_2762 * 18.6875f) + 1.0f)) * ((_2762 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2858 = exp2(log2((1.0f / ((_2763 * 18.6875f) + 1.0f)) * ((_2763 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _2810 = mad((WorkingColorSpace_128[0].z), _1227, mad((WorkingColorSpace_128[0].y), _1226, ((WorkingColorSpace_128[0].x) * _1225)));
                _2813 = mad((WorkingColorSpace_128[1].z), _1227, mad((WorkingColorSpace_128[1].y), _1226, ((WorkingColorSpace_128[1].x) * _1225)));
                _2816 = mad((WorkingColorSpace_128[2].z), _1227, mad((WorkingColorSpace_128[2].y), _1226, ((WorkingColorSpace_128[2].x) * _1225)));
                _2856 = mad(_61, _2816, mad(_60, _2813, (_2810 * _59)));
                _2857 = mad(_64, _2816, mad(_63, _2813, (_2810 * _62)));
                _2858 = mad(_67, _2816, mad(_66, _2813, (_2810 * _65)));
              } else {
                _2829 = mad((WorkingColorSpace_128[0].z), _1253, mad((WorkingColorSpace_128[0].y), _1252, ((WorkingColorSpace_128[0].x) * _1251)));
                _2832 = mad((WorkingColorSpace_128[1].z), _1253, mad((WorkingColorSpace_128[1].y), _1252, ((WorkingColorSpace_128[1].x) * _1251)));
                _2835 = mad((WorkingColorSpace_128[2].z), _1253, mad((WorkingColorSpace_128[2].y), _1252, ((WorkingColorSpace_128[2].x) * _1251)));
                _2856 = exp2(log2(mad(_61, _2835, mad(_60, _2832, (_2829 * _59)))) * cb0_042z);
                _2857 = exp2(log2(mad(_64, _2835, mad(_63, _2832, (_2829 * _62)))) * cb0_042z);
                _2858 = exp2(log2(mad(_67, _2835, mad(_66, _2832, (_2829 * _65)))) * cb0_042z);
              }
            } else {
              _2856 = _1237;
              _2857 = _1238;
              _2858 = _1239;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_2856 * 0.9523810148239136f), (_2857 * 0.9523810148239136f), (_2858 * 0.9523810148239136f), 0.0f);
}
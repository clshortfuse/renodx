#include "../lutbuilderoutput.hlsli"

// Grounded 2

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
  float cb0_041w : packoffset(c041.w);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  float cb0_043y : packoffset(c043.y);
  float cb0_043z : packoffset(c043.z);
  int cb0_043w : packoffset(c043.w);
  int cb0_044x : packoffset(c044.x);
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
  float _22;
  float _27;
  float _28;
  float _29;
  float _31;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _117;
  float _118;
  float _119;
  float _174;
  float _381;
  float _382;
  float _383;
  float _906;
  float _939;
  float _953;
  float _1017;
  float _1285;
  float _1286;
  float _1287;
  float _1298;
  float _1309;
  float _1478;
  float _1493;
  float _1508;
  float _1516;
  float _1517;
  float _1518;
  float _1585;
  float _1618;
  float _1632;
  float _1671;
  float _1793;
  float _1879;
  float _1953;
  float _2213;
  float _2228;
  float _2243;
  float _2251;
  float _2252;
  float _2253;
  float _2320;
  float _2353;
  float _2367;
  float _2406;
  float _2528;
  float _2614;
  float _2700;
  float _2915;
  float _2916;
  float _2917;
  bool _40;
  float _70;
  float _71;
  float _72;
  bool _155;
  float _157;
  float _188;
  float _195;
  float _198;
  float _203;
  float _204;
  float _206;
  bool _207;
  float _216;
  float _218;
  float _225;
  float _227;
  float _229;
  float _230;
  float _233;
  float _236;
  float _241;
  float _247;
  float _248;
  float _249;
  float _250;
  float _251;
  float _252;
  float _253;
  float _254;
  float _257;
  float _258;
  float _259;
  float _262;
  float _281;
  float _282;
  float _283;
  float _284;
  float _285;
  float _286;
  float _287;
  float _288;
  float _289;
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
  float _398;
  float _401;
  float _404;
  float _405;
  float _409;
  float _410;
  float _411;
  float _423;
  float _439;
  float _440;
  float _441;
  float _442;
  float _456;
  float _470;
  float _484;
  float _498;
  float _512;
  float _516;
  float _517;
  float _518;
  float _575;
  float _579;
  float _580;
  float _589;
  float _598;
  float _607;
  float _616;
  float _625;
  float _688;
  float _692;
  float _701;
  float _710;
  float _719;
  float _728;
  float _737;
  float _795;
  float _806;
  float _808;
  float _810;
  float _846;
  float _847;
  float _848;
  float _851;
  float _854;
  float _857;
  float _861;
  float _866;
  float _879;
  float _880;
  float _881;
  float _882;
  float _886;
  float _897;
  float _907;
  float _908;
  float _909;
  float _910;
  float _917;
  float _920;
  float _922;
  bool _925;
  bool _926;
  bool _927;
  bool _928;
  float _944;
  float _957;
  float _961;
  float _967;
  float _977;
  float _978;
  float _979;
  float _980;
  float _995;
  float _997;
  float _999;
  float _1008;
  float _1020;
  float _1022;
  float _1026;
  float _1027;
  float _1028;
  float _1032;
  float _1033;
  float _1034;
  float _1035;
  float _1037;
  float _1038;
  float _1039;
  float _1040;
  float _1059;
  float _1061;
  float _1086;
  float _1087;
  float _1088;
  float _1095;
  float _1099;
  float _1100;
  float _1101;
  bool _1102;
  float _1106;
  float _1107;
  float _1108;
  float _1127;
  float _1128;
  float _1129;
  float _1130;
  float _1150;
  float _1151;
  float _1152;
  float _1168;
  float _1169;
  float _1170;
  float _1180;
  float _1181;
  float _1182;
  float _1208;
  float _1209;
  float _1210;
  float _1217;
  float _1218;
  float _1219;
  float _1220;
  float _1221;
  float _1222;
  float _1229;
  float _1230;
  float _1231;
  float _1243;
  float _1244;
  float _1245;
  float _1268;
  float _1271;
  float _1274;
  float _1336;
  float _1339;
  float _1342;
  float _1345;
  float _1348;
  float _1351;
  float _1426;
  float _1427;
  float _1428;
  float _1431;
  float _1434;
  float _1437;
  float _1440;
  float _1443;
  float _1446;
  float _1448;
  float _1458;
  float _1459;
  float _1461;
  float _1463;
  float _1466;
  float _1481;
  float _1496;
  float _1534;
  float _1535;
  float _1536;
  float _1540;
  float _1545;
  float _1558;
  float _1559;
  float _1560;
  float _1561;
  float _1565;
  float _1576;
  float _1586;
  float _1587;
  float _1588;
  float _1589;
  float _1596;
  float _1599;
  float _1601;
  bool _1604;
  bool _1605;
  bool _1606;
  bool _1607;
  float _1623;
  float _1638;
  int _1639;
  float _1641;
  float _1642;
  float _1643;
  float _1680;
  float _1681;
  float _1682;
  float _1695;
  float _1696;
  float _1697;
  float _1698;
  float _1721;
  float _1722;
  float _1723;
  float _1724;
  float _1731;
  float _1732;
  float _1740;
  int _1741;
  float _1743;
  float _1745;
  float _1748;
  float _1753;
  float _1762;
  float _1770;
  int _1771;
  float _1773;
  float _1775;
  float _1778;
  float _1783;
  float _1809;
  float _1810;
  float _1817;
  float _1818;
  float _1826;
  int _1827;
  float _1829;
  float _1831;
  float _1834;
  float _1839;
  float _1848;
  float _1856;
  int _1857;
  float _1859;
  float _1861;
  float _1864;
  float _1869;
  float _1883;
  float _1884;
  float _1891;
  float _1892;
  float _1900;
  int _1901;
  float _1903;
  float _1905;
  float _1908;
  float _1913;
  float _1922;
  float _1930;
  int _1931;
  float _1933;
  float _1935;
  float _1938;
  float _1943;
  float _1957;
  float _1958;
  float _1960;
  float _1962;
  float _1965;
  float _1968;
  float _1971;
  float _1984;
  float _1985;
  float _1986;
  float _1989;
  float _1992;
  float _1995;
  float _2017;
  float _2018;
  float _2019;
  float _2022;
  float _2025;
  float _2028;
  float _2032;
  float _2045;
  float _2046;
  float _2047;
  float _2053;
  float _2057;
  float _2076;
  float _2077;
  float _2078;
  float _2109;
  float _2119;
  float _2161;
  float _2162;
  float _2163;
  float _2166;
  float _2169;
  float _2172;
  float _2175;
  float _2178;
  float _2181;
  float _2183;
  float _2193;
  float _2194;
  float _2196;
  float _2198;
  float _2201;
  float _2216;
  float _2231;
  float _2269;
  float _2270;
  float _2271;
  float _2275;
  float _2280;
  float _2293;
  float _2294;
  float _2295;
  float _2296;
  float _2300;
  float _2311;
  float _2321;
  float _2322;
  float _2323;
  float _2324;
  float _2331;
  float _2334;
  float _2336;
  bool _2339;
  bool _2340;
  bool _2341;
  bool _2342;
  float _2358;
  float _2373;
  int _2374;
  float _2376;
  float _2377;
  float _2378;
  float _2415;
  float _2416;
  float _2417;
  float _2430;
  float _2431;
  float _2432;
  float _2433;
  float _2456;
  float _2457;
  float _2458;
  float _2459;
  float _2466;
  float _2467;
  float _2475;
  int _2476;
  float _2478;
  float _2480;
  float _2483;
  float _2488;
  float _2497;
  float _2505;
  int _2506;
  float _2508;
  float _2510;
  float _2513;
  float _2518;
  float _2544;
  float _2545;
  float _2552;
  float _2553;
  float _2561;
  int _2562;
  float _2564;
  float _2566;
  float _2569;
  float _2574;
  float _2583;
  float _2591;
  int _2592;
  float _2594;
  float _2596;
  float _2599;
  float _2604;
  float _2630;
  float _2631;
  float _2638;
  float _2639;
  float _2647;
  int _2648;
  float _2650;
  float _2652;
  float _2655;
  float _2660;
  float _2669;
  float _2677;
  int _2678;
  float _2680;
  float _2682;
  float _2685;
  float _2690;
  float _2704;
  float _2705;
  float _2707;
  float _2709;
  float _2712;
  float _2715;
  float _2718;
  float _2731;
  float _2732;
  float _2733;
  float _2736;
  float _2739;
  float _2742;
  float _2764;
  float _2767;
  float _2768;
  float _2795;
  float _2798;
  float _2801;
  float _2820;
  float _2821;
  float _2822;
  float _2869;
  float _2872;
  float _2875;
  float _2888;
  float _2891;
  float _2894;
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
  float _19[6];
  _22 = 0.5f / cb0_037x;
  _27 = cb0_037x + -1.0f;
  _28 = (cb0_037x * (TEXCOORD.x - _22)) / _27;
  _29 = (cb0_037x * (TEXCOORD.y - _22)) / _27;
  _31 = float((uint)(uint)(SV_RenderTargetArrayIndex)) / _27;
  if (!(cb0_044x == 1)) {
    if (!(cb0_044x == 2)) {
      if (!(cb0_044x == 3)) {
        _40 = (cb0_044x == 4);
        _51 = select(_40, 1.0f, 1.705051064491272f);
        _52 = select(_40, 0.0f, -0.6217921376228333f);
        _53 = select(_40, 0.0f, -0.0832589864730835f);
        _54 = select(_40, 0.0f, -0.13025647401809692f);
        _55 = select(_40, 1.0f, 1.140804648399353f);
        _56 = select(_40, 0.0f, -0.010548308491706848f);
        _57 = select(_40, 0.0f, -0.024003351107239723f);
        _58 = select(_40, 0.0f, -0.1289689838886261f);
        _59 = select(_40, 1.0f, 1.1529725790023804f);
      } else {
        _51 = 0.6954522132873535f;
        _52 = 0.14067870378494263f;
        _53 = 0.16386906802654266f;
        _54 = 0.044794563204050064f;
        _55 = 0.8596711158752441f;
        _56 = 0.0955343171954155f;
        _57 = -0.005525882821530104f;
        _58 = 0.004025210160762072f;
        _59 = 1.0015007257461548f;
      }
    } else {
      _51 = 1.0258246660232544f;
      _52 = -0.020053181797266006f;
      _53 = -0.005771636962890625f;
      _54 = -0.002234415616840124f;
      _55 = 1.0045864582061768f;
      _56 = -0.002352118492126465f;
      _57 = -0.005013350863009691f;
      _58 = -0.025290070101618767f;
      _59 = 1.0303035974502563f;
    }
  } else {
    _51 = 1.3792141675949097f;
    _52 = -0.30886411666870117f;
    _53 = -0.0703500509262085f;
    _54 = -0.06933490186929703f;
    _55 = 1.08229660987854f;
    _56 = -0.012961871922016144f;
    _57 = -0.0021590073592960835f;
    _58 = -0.0454593189060688f;
    _59 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_043w > (uint)2) {
    _70 = (pow(_28, 0.012683313339948654f));
    _71 = (pow(_29, 0.012683313339948654f));
    _72 = (pow(_31, 0.012683313339948654f));
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _117 = ((exp2((_28 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _118 = ((exp2((_29 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _119 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _155 = (cb0_040w != 0);
    _157 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _174 = (((((1901800.0f - (_157 * 2006400000.0f)) * _157) + 247.47999572753906f) * _157) + 0.23703999817371368f);
    } else {
      _174 = (((((2967800.0f - (_157 * 4607000064.0f)) * _157) + 99.11000061035156f) * _157) + 0.24406300485134125f);
    }
    _188 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _195 = cb0_037y * cb0_037y;
    _198 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_195 * 1.6145605741257896e-07f));
    _203 = ((_188 * 2.0f) + 4.0f) - (_198 * 8.0f);
    _204 = (_188 * 3.0f) / _203;
    _206 = (_198 * 2.0f) / _203;
    _207 = (cb0_037y < 4000.0f);
    _216 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _218 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_195 * 1.5317699909210205f)) / (_216 * _216);
    _225 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _195;
    _227 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_195 * 308.60699462890625f)) / (_225 * _225);
    _229 = rsqrt(dot(float2(_218, _227), float2(_218, _227)));
    _230 = cb0_037z * 0.05000000074505806f;
    _233 = ((_230 * _227) * _229) + _188;
    _236 = _198 - ((_230 * _218) * _229);
    _241 = (4.0f - (_236 * 8.0f)) + (_233 * 2.0f);
    _247 = (((_233 * 3.0f) / _241) - _204) + select(_207, _204, _174);
    _248 = (((_236 * 2.0f) / _241) - _206) + select(_207, _206, (((_174 * 2.869999885559082f) + -0.2750000059604645f) - ((_174 * _174) * 3.0f)));
    _249 = select(_155, _247, 0.3127000033855438f);
    _250 = select(_155, _248, 0.32899999618530273f);
    _251 = select(_155, 0.3127000033855438f, _247);
    _252 = select(_155, 0.32899999618530273f, _248);
    _253 = max(_250, 1.000000013351432e-10f);
    _254 = _249 / _253;
    _257 = ((1.0f - _249) - _250) / _253;
    _258 = max(_252, 1.000000013351432e-10f);
    _259 = _251 / _258;
    _262 = ((1.0f - _251) - _252) / _258;
    _281 = mad(-0.16140000522136688f, _262, ((_259 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _257, ((_254 * 0.8950999975204468f) + 0.266400009393692f));
    _282 = mad(0.03669999912381172f, _262, (1.7135000228881836f - (_259 * 0.7501999735832214f))) / mad(0.03669999912381172f, _257, (1.7135000228881836f - (_254 * 0.7501999735832214f)));
    _283 = mad(1.0296000242233276f, _262, ((_259 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _257, ((_254 * 0.03889999911189079f) + -0.06849999725818634f));
    _284 = mad(_282, -0.7501999735832214f, 0.0f);
    _285 = mad(_282, 1.7135000228881836f, 0.0f);
    _286 = mad(_282, 0.03669999912381172f, -0.0f);
    _287 = mad(_283, 0.03889999911189079f, 0.0f);
    _288 = mad(_283, -0.06849999725818634f, 0.0f);
    _289 = mad(_283, 1.0296000242233276f, 0.0f);
    _292 = mad(0.1599626988172531f, _287, mad(-0.1470542997121811f, _284, (_281 * 0.883457362651825f)));
    _295 = mad(0.1599626988172531f, _288, mad(-0.1470542997121811f, _285, (_281 * 0.26293492317199707f)));
    _298 = mad(0.1599626988172531f, _289, mad(-0.1470542997121811f, _286, (_281 * -0.15930065512657166f)));
    _301 = mad(0.04929120093584061f, _287, mad(0.5183603167533875f, _284, (_281 * 0.38695648312568665f)));
    _304 = mad(0.04929120093584061f, _288, mad(0.5183603167533875f, _285, (_281 * 0.11516613513231277f)));
    _307 = mad(0.04929120093584061f, _289, mad(0.5183603167533875f, _286, (_281 * -0.0697740763425827f)));
    _310 = mad(0.9684867262840271f, _287, mad(0.04004279896616936f, _284, (_281 * -0.007634039502590895f)));
    _313 = mad(0.9684867262840271f, _288, mad(0.04004279896616936f, _285, (_281 * -0.0022720457054674625f)));
    _316 = mad(0.9684867262840271f, _289, mad(0.04004279896616936f, _286, (_281 * 0.0013765322510153055f)));
    _319 = mad(_298, (WorkingColorSpace_000[2].x), mad(_295, (WorkingColorSpace_000[1].x), (_292 * (WorkingColorSpace_000[0].x))));
    _322 = mad(_298, (WorkingColorSpace_000[2].y), mad(_295, (WorkingColorSpace_000[1].y), (_292 * (WorkingColorSpace_000[0].y))));
    _325 = mad(_298, (WorkingColorSpace_000[2].z), mad(_295, (WorkingColorSpace_000[1].z), (_292 * (WorkingColorSpace_000[0].z))));
    _328 = mad(_307, (WorkingColorSpace_000[2].x), mad(_304, (WorkingColorSpace_000[1].x), (_301 * (WorkingColorSpace_000[0].x))));
    _331 = mad(_307, (WorkingColorSpace_000[2].y), mad(_304, (WorkingColorSpace_000[1].y), (_301 * (WorkingColorSpace_000[0].y))));
    _334 = mad(_307, (WorkingColorSpace_000[2].z), mad(_304, (WorkingColorSpace_000[1].z), (_301 * (WorkingColorSpace_000[0].z))));
    _337 = mad(_316, (WorkingColorSpace_000[2].x), mad(_313, (WorkingColorSpace_000[1].x), (_310 * (WorkingColorSpace_000[0].x))));
    _340 = mad(_316, (WorkingColorSpace_000[2].y), mad(_313, (WorkingColorSpace_000[1].y), (_310 * (WorkingColorSpace_000[0].y))));
    _343 = mad(_316, (WorkingColorSpace_000[2].z), mad(_313, (WorkingColorSpace_000[1].z), (_310 * (WorkingColorSpace_000[0].z))));
    _381 = mad(mad((WorkingColorSpace_064[0].z), _343, mad((WorkingColorSpace_064[0].y), _334, (_325 * (WorkingColorSpace_064[0].x)))), _119, mad(mad((WorkingColorSpace_064[0].z), _340, mad((WorkingColorSpace_064[0].y), _331, (_322 * (WorkingColorSpace_064[0].x)))), _118, (mad((WorkingColorSpace_064[0].z), _337, mad((WorkingColorSpace_064[0].y), _328, (_319 * (WorkingColorSpace_064[0].x)))) * _117)));
    _382 = mad(mad((WorkingColorSpace_064[1].z), _343, mad((WorkingColorSpace_064[1].y), _334, (_325 * (WorkingColorSpace_064[1].x)))), _119, mad(mad((WorkingColorSpace_064[1].z), _340, mad((WorkingColorSpace_064[1].y), _331, (_322 * (WorkingColorSpace_064[1].x)))), _118, (mad((WorkingColorSpace_064[1].z), _337, mad((WorkingColorSpace_064[1].y), _328, (_319 * (WorkingColorSpace_064[1].x)))) * _117)));
    _383 = mad(mad((WorkingColorSpace_064[2].z), _343, mad((WorkingColorSpace_064[2].y), _334, (_325 * (WorkingColorSpace_064[2].x)))), _119, mad(mad((WorkingColorSpace_064[2].z), _340, mad((WorkingColorSpace_064[2].y), _331, (_322 * (WorkingColorSpace_064[2].x)))), _118, (mad((WorkingColorSpace_064[2].z), _337, mad((WorkingColorSpace_064[2].y), _328, (_319 * (WorkingColorSpace_064[2].x)))) * _117)));
  } else {
    _381 = _117;
    _382 = _118;
    _383 = _119;
  }
  _398 = mad((WorkingColorSpace_128[0].z), _383, mad((WorkingColorSpace_128[0].y), _382, ((WorkingColorSpace_128[0].x) * _381)));
  _401 = mad((WorkingColorSpace_128[1].z), _383, mad((WorkingColorSpace_128[1].y), _382, ((WorkingColorSpace_128[1].x) * _381)));
  _404 = mad((WorkingColorSpace_128[2].z), _383, mad((WorkingColorSpace_128[2].y), _382, ((WorkingColorSpace_128[2].x) * _381)));
  _405 = dot(float3(_398, _401, _404), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _409 = (_398 / _405) + -1.0f;
  _410 = (_401 / _405) + -1.0f;
  _411 = (_404 / _405) + -1.0f;
  // _423 = (1.0f - exp2(((_405 * _405) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_409, _410, _411), float3(_409, _410, _411)) * -4.0f));
  _423 = (1.0f - exp2(((_405 * _405) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_409, _410, _411), float3(_409, _410, _411)) * -4.0f));
  _439 = ((mad(-0.06368321925401688f, _404, mad(-0.3292922377586365f, _401, (_398 * 1.3704125881195068f))) - _398) * _423) + _398;
  _440 = ((mad(-0.010861365124583244f, _404, mad(1.0970927476882935f, _401, (_398 * -0.08343357592821121f))) - _401) * _423) + _401;
  _441 = ((mad(1.2036951780319214f, _404, mad(-0.09862580895423889f, _401, (_398 * -0.02579331398010254f))) - _404) * _423) + _404;
  _442 = dot(float3(_439, _440, _441), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _456 = cb0_021w + cb0_026w;
  _470 = cb0_020w * cb0_025w;
  _484 = cb0_019w * cb0_024w;
  _498 = cb0_018w * cb0_023w;
  _512 = cb0_017w * cb0_022w;
  _516 = _439 - _442;
  _517 = _440 - _442;
  _518 = _441 - _442;
  _575 = saturate(_442 / cb0_037w);
  _579 = (_575 * _575) * (3.0f - (_575 * 2.0f));
  _580 = 1.0f - _579;
  _589 = cb0_021w + cb0_036w;
  _598 = cb0_020w * cb0_035w;
  _607 = cb0_019w * cb0_034w;
  _616 = cb0_018w * cb0_033w;
  _625 = cb0_017w * cb0_032w;
  _688 = saturate((_442 - cb0_038x) / (cb0_038y - cb0_038x));
  _692 = (_688 * _688) * (3.0f - (_688 * 2.0f));
  _701 = cb0_021w + cb0_031w;
  _710 = cb0_020w * cb0_030w;
  _719 = cb0_019w * cb0_029w;
  _728 = cb0_018w * cb0_028w;
  _737 = cb0_017w * cb0_027w;
  _795 = _579 - _692;
  _806 = ((_692 * (((cb0_021x + cb0_036x) + _589) + (((cb0_020x * cb0_035x) * _598) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _616) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _625) * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _607)))))) + (_580 * (((cb0_021x + cb0_026x) + _456) + (((cb0_020x * cb0_025x) * _470) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _498) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _512) * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _484))))))) + ((((cb0_021x + cb0_031x) + _701) + (((cb0_020x * cb0_030x) * _710) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _728) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _737) * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _719))))) * _795);
  _808 = ((_692 * (((cb0_021y + cb0_036y) + _589) + (((cb0_020y * cb0_035y) * _598) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _616) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _625) * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _607)))))) + (_580 * (((cb0_021y + cb0_026y) + _456) + (((cb0_020y * cb0_025y) * _470) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _498) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _512) * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _484))))))) + ((((cb0_021y + cb0_031y) + _701) + (((cb0_020y * cb0_030y) * _710) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _728) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _737) * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _719))))) * _795);
  _810 = ((_692 * (((cb0_021z + cb0_036z) + _589) + (((cb0_020z * cb0_035z) * _598) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _616) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _625) * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _607)))))) + (_580 * (((cb0_021z + cb0_026z) + _456) + (((cb0_020z * cb0_025z) * _470) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _498) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _512) * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _484))))))) + ((((cb0_021z + cb0_031z) + _701) + (((cb0_020z * cb0_030z) * _710) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _728) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _737) * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _719))))) * _795);

  // 0x41294F17 (Grounded 2 HDR lutbuilder):
  // - _806/_808/_810 = untonemapped AP1 after whitepoint/ExpandGamut/color-grade
  // - cb0_043w = output transfer selector (0/1 = SDR sRGB/gamma2.2, 2/3/5/6 = ACES+PQ,
  //   4 = gamma cb0_043z, 7 = PQ, 8 = linear, 9 = linear+neutwo)
  // - cb0_044x = ODT gamut matrix selector (1-4), not a device id
  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = cb0_040x;
  cb_config.ue_filmtoe = cb0_039z;
  cb_config.ue_filmshoulder = cb0_039w;
  cb_config.ue_filmslope = cb0_039y;
  cb_config.ue_filmwhiteclip = cb0_040y;
  cb_config.ue_tonecurveammount = cb0_039x;
  cb_config.ue_bluecorrection = cb0_038z;
  cb_config.ue_mappingpolynomial = float3(cb0_042x, cb0_042y, cb0_042z);
  cb_config.ue_overlaycolor = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
  cb_config.ue_colorscale = float3(cb0_016x, cb0_016y, cb0_016z);
  SV_Target = ProcessLutbuilder(float3(_806, _808, _810), cb_config, SV_Target, asuint(cb0_043w));
  return SV_Target;

  _846 = ((mad(0.061360642313957214f, _810, mad(-4.540197551250458e-09f, _808, (_806 * 0.9386394023895264f))) - _806) * cb0_038z) + _806;
  _847 = ((mad(0.169205904006958f, _810, mad(0.8307942152023315f, _808, (_806 * 6.775371730327606e-08f))) - _808) * cb0_038z) + _808;
  _848 = (mad(-2.3283064365386963e-10f, _808, (_806 * -9.313225746154785e-10f)) * cb0_038z) + _810;
  _851 = mad(0.16386905312538147f, _848, mad(0.14067868888378143f, _847, (_846 * 0.6954522132873535f)));
  _854 = mad(0.0955343246459961f, _848, mad(0.8596711158752441f, _847, (_846 * 0.044794581830501556f)));
  _857 = mad(1.0015007257461548f, _848, mad(0.004025210160762072f, _847, (_846 * -0.005525882821530104f)));
  _861 = max(max(_851, _854), _857);
  _866 = (max(_861, 1.000000013351432e-10f) - max(min(min(_851, _854), _857), 1.000000013351432e-10f)) / max(_861, 0.009999999776482582f);
  _879 = ((_854 + _851) + _857) + (sqrt((((_857 - _854) * _857) + ((_854 - _851) * _854)) + ((_851 - _857) * _851)) * 1.75f);
  _880 = _879 * 0.3333333432674408f;
  _881 = _866 + -0.4000000059604645f;
  _882 = _881 * 5.0f;
  _886 = max((1.0f - abs(_881 * 2.5f)), 0.0f);
  _897 = ((float((int)(((int)(uint)((int)(_882 > 0.0f))) - ((int)(uint)((int)(_882 < 0.0f))))) * (1.0f - (_886 * _886))) + 1.0f) * 0.02500000037252903f;
  if (_880 > 0.0533333346247673f) {
    if (_880 < 0.1599999964237213f) {
      _906 = (((0.23999999463558197f / _879) + -0.5f) * _897);
    } else {
      _906 = 0.0f;
    }
  } else {
    _906 = _897;
  }
  _907 = _906 + 1.0f;
  _908 = _907 * _851;
  _909 = _907 * _854;
  _910 = _907 * _857;
  if (!((_908 == _909) && (_909 == _910))) {
    _917 = ((_908 * 2.0f) - _909) - _910;
    _920 = ((_854 - _857) * 1.7320507764816284f) * _907;
    _922 = atan(_920 / _917);
    _925 = (_917 < 0.0f);
    _926 = (_917 == 0.0f);
    _927 = (_920 >= 0.0f);
    _928 = (_920 < 0.0f);
    _939 = select((_927 && _926), 90.0f, select((_928 && _926), -90.0f, (select((_928 && _925), (_922 + -3.1415927410125732f), select((_927 && _925), (_922 + 3.1415927410125732f), _922)) * 57.2957763671875f)));
  } else {
    _939 = 0.0f;
  }
  _944 = min(max(select((_939 < 0.0f), (_939 + 360.0f), _939), 0.0f), 360.0f);
  if (_944 < -180.0f) {
    _953 = (_944 + 360.0f);
  } else {
    if (_944 > 180.0f) {
      _953 = (_944 + -360.0f);
    } else {
      _953 = _944;
    }
  }
  _957 = saturate(1.0f - abs(_953 * 0.014814814552664757f));
  _961 = (_957 * _957) * (3.0f - (_957 * 2.0f));
  _967 = ((_961 * _961) * ((_866 * 0.18000000715255737f) * (0.029999999329447746f - _908))) + _908;
  _977 = max(0.0f, mad(-0.21492856740951538f, _910, mad(-0.2365107536315918f, _909, (_967 * 1.4514392614364624f))));
  _978 = max(0.0f, mad(-0.09967592358589172f, _910, mad(1.17622971534729f, _909, (_967 * -0.07655377686023712f))));
  _979 = max(0.0f, mad(0.9977163076400757f, _910, mad(-0.006032449658960104f, _909, (_967 * 0.008316148072481155f))));
  _980 = dot(float3(_977, _978, _979), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _995 = (cb0_040x + 1.0f) - cb0_039z;
  _997 = cb0_040y + 1.0f;
  _999 = _997 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1017 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1008 = (cb0_040x + 0.18000000715255737f) / _995;
    _1017 = (-0.7447274923324585f - ((log2(_1008 / (2.0f - _1008)) * 0.3465735912322998f) * (_995 / cb0_039y)));
  }
  _1020 = ((1.0f - cb0_039z) / cb0_039y) - _1017;
  _1022 = (cb0_039w / cb0_039y) - _1020;
  _1026 = log2(lerp(_980, _977, 0.9599999785423279f)) * 0.3010300099849701f;
  _1027 = log2(lerp(_980, _978, 0.9599999785423279f)) * 0.3010300099849701f;
  _1028 = log2(lerp(_980, _979, 0.9599999785423279f)) * 0.3010300099849701f;
  _1032 = cb0_039y * (_1026 + _1020);
  _1033 = cb0_039y * (_1027 + _1020);
  _1034 = cb0_039y * (_1028 + _1020);
  _1035 = _995 * 2.0f;
  _1037 = (cb0_039y * -2.0f) / _995;
  _1038 = _1026 - _1017;
  _1039 = _1027 - _1017;
  _1040 = _1028 - _1017;
  _1059 = _999 * 2.0f;
  _1061 = (cb0_039y * 2.0f) / _999;
  _1086 = select((_1026 < _1017), ((_1035 / (exp2((_1038 * 1.4426950216293335f) * _1037) + 1.0f)) - cb0_040x), _1032);
  _1087 = select((_1027 < _1017), ((_1035 / (exp2((_1039 * 1.4426950216293335f) * _1037) + 1.0f)) - cb0_040x), _1033);
  _1088 = select((_1028 < _1017), ((_1035 / (exp2((_1040 * 1.4426950216293335f) * _1037) + 1.0f)) - cb0_040x), _1034);
  _1095 = _1022 - _1017;
  _1099 = saturate(_1038 / _1095);
  _1100 = saturate(_1039 / _1095);
  _1101 = saturate(_1040 / _1095);
  _1102 = (_1022 < _1017);
  _1106 = select(_1102, (1.0f - _1099), _1099);
  _1107 = select(_1102, (1.0f - _1100), _1100);
  _1108 = select(_1102, (1.0f - _1101), _1101);
  _1127 = (((_1106 * _1106) * (select((_1026 > _1022), (_997 - (_1059 / (exp2(((_1026 - _1022) * 1.4426950216293335f) * _1061) + 1.0f))), _1032) - _1086)) * (3.0f - (_1106 * 2.0f))) + _1086;
  _1128 = (((_1107 * _1107) * (select((_1027 > _1022), (_997 - (_1059 / (exp2(((_1027 - _1022) * 1.4426950216293335f) * _1061) + 1.0f))), _1033) - _1087)) * (3.0f - (_1107 * 2.0f))) + _1087;
  _1129 = (((_1108 * _1108) * (select((_1028 > _1022), (_997 - (_1059 / (exp2(((_1028 - _1022) * 1.4426950216293335f) * _1061) + 1.0f))), _1034) - _1088)) * (3.0f - (_1108 * 2.0f))) + _1088;
  _1130 = dot(float3(_1127, _1128, _1129), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1150 = (cb0_039x * (max(0.0f, (lerp(_1130, _1127, 0.9300000071525574f))) - _846)) + _846;
  _1151 = (cb0_039x * (max(0.0f, (lerp(_1130, _1128, 0.9300000071525574f))) - _847)) + _847;
  _1152 = (cb0_039x * (max(0.0f, (lerp(_1130, _1129, 0.9300000071525574f))) - _848)) + _848;
  _1168 = ((mad(-0.06537103652954102f, _1152, mad(1.451815478503704e-06f, _1151, (_1150 * 1.065374732017517f))) - _1150) * cb0_038z) + _1150;
  _1169 = ((mad(-0.20366770029067993f, _1152, mad(1.2036634683609009f, _1151, (_1150 * -2.57161445915699e-07f))) - _1151) * cb0_038z) + _1151;
  _1170 = ((mad(0.9999996423721313f, _1152, mad(2.0954757928848267e-08f, _1151, (_1150 * 1.862645149230957e-08f))) - _1152) * cb0_038z) + _1152;
  _1180 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1170, mad((WorkingColorSpace_192[0].y), _1169, ((WorkingColorSpace_192[0].x) * _1168))));
  _1181 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1170, mad((WorkingColorSpace_192[1].y), _1169, ((WorkingColorSpace_192[1].x) * _1168))));
  _1182 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1170, mad((WorkingColorSpace_192[2].y), _1169, ((WorkingColorSpace_192[2].x) * _1168))));
  _1208 = cb0_016x * (((cb0_042y + (cb0_042x * _1180)) * _1180) + cb0_042z);
  _1209 = cb0_016y * (((cb0_042y + (cb0_042x * _1181)) * _1181) + cb0_042z);
  _1210 = cb0_016z * (((cb0_042y + (cb0_042x * _1182)) * _1182) + cb0_042z);
  _1217 = ((cb0_015x - _1208) * cb0_015w) + _1208;
  _1218 = ((cb0_015y - _1209) * cb0_015w) + _1209;
  _1219 = ((cb0_015z - _1210) * cb0_015w) + _1210;
  _1220 = cb0_016x * mad((WorkingColorSpace_192[0].z), _810, mad((WorkingColorSpace_192[0].y), _808, (_806 * (WorkingColorSpace_192[0].x))));
  _1221 = cb0_016y * mad((WorkingColorSpace_192[1].z), _810, mad((WorkingColorSpace_192[1].y), _808, ((WorkingColorSpace_192[1].x) * _806)));
  _1222 = cb0_016z * mad((WorkingColorSpace_192[2].z), _810, mad((WorkingColorSpace_192[2].y), _808, ((WorkingColorSpace_192[2].x) * _806)));
  _1229 = ((cb0_015x - _1220) * cb0_015w) + _1220;
  _1230 = ((cb0_015y - _1221) * cb0_015w) + _1221;
  _1231 = ((cb0_015z - _1222) * cb0_015w) + _1222;
  _1243 = exp2(log2(max(0.0f, _1217)) * cb0_043y);
  _1244 = exp2(log2(max(0.0f, _1218)) * cb0_043y);
  _1245 = exp2(log2(max(0.0f, _1219)) * cb0_043y);
  [branch]
  if (cb0_043w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1268 = mad((WorkingColorSpace_128[0].z), _1245, mad((WorkingColorSpace_128[0].y), _1244, ((WorkingColorSpace_128[0].x) * _1243)));
      _1271 = mad((WorkingColorSpace_128[1].z), _1245, mad((WorkingColorSpace_128[1].y), _1244, ((WorkingColorSpace_128[1].x) * _1243)));
      _1274 = mad((WorkingColorSpace_128[2].z), _1245, mad((WorkingColorSpace_128[2].y), _1244, ((WorkingColorSpace_128[2].x) * _1243)));
      _1285 = mad(_53, _1274, mad(_52, _1271, (_1268 * _51)));
      _1286 = mad(_56, _1274, mad(_55, _1271, (_1268 * _54)));
      _1287 = mad(_59, _1274, mad(_58, _1271, (_1268 * _57)));
    } else {
      _1285 = _1243;
      _1286 = _1244;
      _1287 = _1245;
    }
    if (_1285 < 0.0031306699384003878f) {
      _1298 = (_1285 * 12.920000076293945f);
    } else {
      _1298 = (((pow(_1285, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1286 < 0.0031306699384003878f) {
      _1309 = (_1286 * 12.920000076293945f);
    } else {
      _1309 = (((pow(_1286, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1287 < 0.0031306699384003878f) {
      _2915 = _1298;
      _2916 = _1309;
      _2917 = (_1287 * 12.920000076293945f);
    } else {
      _2915 = _1298;
      _2916 = _1309;
      _2917 = (((pow(_1287, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_043w == 1) {
      _1336 = mad((WorkingColorSpace_128[0].z), _1245, mad((WorkingColorSpace_128[0].y), _1244, ((WorkingColorSpace_128[0].x) * _1243)));
      _1339 = mad((WorkingColorSpace_128[1].z), _1245, mad((WorkingColorSpace_128[1].y), _1244, ((WorkingColorSpace_128[1].x) * _1243)));
      _1342 = mad((WorkingColorSpace_128[2].z), _1245, mad((WorkingColorSpace_128[2].y), _1244, ((WorkingColorSpace_128[2].x) * _1243)));
      _1345 = mad(_53, _1342, mad(_52, _1339, (_1336 * _51)));
      _1348 = mad(_56, _1342, mad(_55, _1339, (_1336 * _54)));
      _1351 = mad(_59, _1342, mad(_58, _1339, (_1336 * _57)));
      _2915 = min((_1345 * 4.5f), ((exp2(log2(max(_1345, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2916 = min((_1348 * 4.5f), ((exp2(log2(max(_1348, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2917 = min((_1351 * 4.5f), ((exp2(log2(max(_1351, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_043w) + (uint)(-3))) < (uint)2) {
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
        _1426 = cb0_012z * _1229;
        _1427 = cb0_012z * _1230;
        _1428 = cb0_012z * _1231;
        _1431 = mad((WorkingColorSpace_256[0].z), _1428, mad((WorkingColorSpace_256[0].y), _1427, ((WorkingColorSpace_256[0].x) * _1426)));
        _1434 = mad((WorkingColorSpace_256[1].z), _1428, mad((WorkingColorSpace_256[1].y), _1427, ((WorkingColorSpace_256[1].x) * _1426)));
        _1437 = mad((WorkingColorSpace_256[2].z), _1428, mad((WorkingColorSpace_256[2].y), _1427, ((WorkingColorSpace_256[2].x) * _1426)));
        _1440 = mad(-0.21492856740951538f, _1437, mad(-0.2365107536315918f, _1434, (_1431 * 1.4514392614364624f)));
        _1443 = mad(-0.09967592358589172f, _1437, mad(1.17622971534729f, _1434, (_1431 * -0.07655377686023712f)));
        _1446 = mad(0.9977163076400757f, _1437, mad(-0.006032449658960104f, _1434, (_1431 * 0.008316148072481155f)));
        _1448 = max(_1440, max(_1443, _1446));
        if (!(_1448 < 1.000000013351432e-10f)) {
          if (!(((_1431 < 0.0f) || (_1434 < 0.0f)) || (_1437 < 0.0f))) {
            _1458 = abs(_1448);
            _1459 = (_1448 - _1440) / _1458;
            _1461 = (_1448 - _1443) / _1458;
            _1463 = (_1448 - _1446) / _1458;
            if (!(_1459 < 0.8149999976158142f)) {
              _1466 = _1459 + -0.8149999976158142f;
              _1478 = ((_1466 / exp2(log2(exp2(log2(_1466 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1478 = _1459;
            }
            if (!(_1461 < 0.8029999732971191f)) {
              _1481 = _1461 + -0.8029999732971191f;
              _1493 = ((_1481 / exp2(log2(exp2(log2(_1481 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1493 = _1461;
            }
            if (!(_1463 < 0.8799999952316284f)) {
              _1496 = _1463 + -0.8799999952316284f;
              _1508 = ((_1496 / exp2(log2(exp2(log2(_1496 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1508 = _1463;
            }
            _1516 = (_1448 - (_1458 * _1478));
            _1517 = (_1448 - (_1458 * _1493));
            _1518 = (_1448 - (_1458 * _1508));
          } else {
            _1516 = _1440;
            _1517 = _1443;
            _1518 = _1446;
          }
        } else {
          _1516 = _1440;
          _1517 = _1443;
          _1518 = _1446;
        }
        _1534 = ((mad(0.16386906802654266f, _1518, mad(0.14067870378494263f, _1517, (_1516 * 0.6954522132873535f))) - _1431) * cb0_012w) + _1431;
        _1535 = ((mad(0.0955343171954155f, _1518, mad(0.8596711158752441f, _1517, (_1516 * 0.044794563204050064f))) - _1434) * cb0_012w) + _1434;
        _1536 = ((mad(1.0015007257461548f, _1518, mad(0.004025210160762072f, _1517, (_1516 * -0.005525882821530104f))) - _1437) * cb0_012w) + _1437;
        _1540 = max(max(_1534, _1535), _1536);
        _1545 = (max(_1540, 1.000000013351432e-10f) - max(min(min(_1534, _1535), _1536), 1.000000013351432e-10f)) / max(_1540, 0.009999999776482582f);
        _1558 = ((_1535 + _1534) + _1536) + (sqrt((((_1536 - _1535) * _1536) + ((_1535 - _1534) * _1535)) + ((_1534 - _1536) * _1534)) * 1.75f);
        _1559 = _1558 * 0.3333333432674408f;
        _1560 = _1545 + -0.4000000059604645f;
        _1561 = _1560 * 5.0f;
        _1565 = max((1.0f - abs(_1560 * 2.5f)), 0.0f);
        _1576 = ((float((int)(((int)(uint)((int)(_1561 > 0.0f))) - ((int)(uint)((int)(_1561 < 0.0f))))) * (1.0f - (_1565 * _1565))) + 1.0f) * 0.02500000037252903f;
        if (_1559 > 0.0533333346247673f) {
          if (_1559 < 0.1599999964237213f) {
            _1585 = (((0.23999999463558197f / _1558) + -0.5f) * _1576);
          } else {
            _1585 = 0.0f;
          }
        } else {
          _1585 = _1576;
        }
        _1586 = _1585 + 1.0f;
        _1587 = _1586 * _1534;
        _1588 = _1586 * _1535;
        _1589 = _1586 * _1536;
        if (!((_1587 == _1588) && (_1588 == _1589))) {
          _1596 = ((_1587 * 2.0f) - _1588) - _1589;
          _1599 = ((_1535 - _1536) * 1.7320507764816284f) * _1586;
          _1601 = atan(_1599 / _1596);
          _1604 = (_1596 < 0.0f);
          _1605 = (_1596 == 0.0f);
          _1606 = (_1599 >= 0.0f);
          _1607 = (_1599 < 0.0f);
          _1618 = select((_1606 && _1605), 90.0f, select((_1607 && _1605), -90.0f, (select((_1607 && _1604), (_1601 + -3.1415927410125732f), select((_1606 && _1604), (_1601 + 3.1415927410125732f), _1601)) * 57.2957763671875f)));
        } else {
          _1618 = 0.0f;
        }
        _1623 = min(max(select((_1618 < 0.0f), (_1618 + 360.0f), _1618), 0.0f), 360.0f);
        if (_1623 < -180.0f) {
          _1632 = (_1623 + 360.0f);
        } else {
          if (_1623 > 180.0f) {
            _1632 = (_1623 + -360.0f);
          } else {
            _1632 = _1623;
          }
        }
        if ((_1632 > -67.5f) && (_1632 < 67.5f)) {
          _1638 = (_1632 + 67.5f) * 0.029629629105329514f;
          _1639 = int(_1638);
          _1641 = _1638 - float((int)(_1639));
          _1642 = _1641 * _1641;
          _1643 = _1642 * _1641;
          if (_1639 == 3) {
            _1671 = (((0.1666666716337204f - (_1641 * 0.5f)) + (_1642 * 0.5f)) - (_1643 * 0.1666666716337204f));
          } else {
            if (_1639 == 2) {
              _1671 = ((0.6666666865348816f - _1642) + (_1643 * 0.5f));
            } else {
              if (_1639 == 1) {
                _1671 = (((_1643 * -0.5f) + 0.1666666716337204f) + ((_1642 + _1641) * 0.5f));
              } else {
                _1671 = select((_1639 == 0), (_1643 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1671 = 0.0f;
        }
        _1680 = min(max(((((_1545 * 0.27000001072883606f) * (0.029999999329447746f - _1587)) * _1671) + _1587), 0.0f), 65535.0f);
        _1681 = min(max(_1588, 0.0f), 65535.0f);
        _1682 = min(max(_1589, 0.0f), 65535.0f);
        _1695 = min(max(mad(-0.21492856740951538f, _1682, mad(-0.2365107536315918f, _1681, (_1680 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1696 = min(max(mad(-0.09967592358589172f, _1682, mad(1.17622971534729f, _1681, (_1680 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1697 = min(max(mad(0.9977163076400757f, _1682, mad(-0.006032449658960104f, _1681, (_1680 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1698 = dot(float3(_1695, _1696, _1697), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
        _1721 = log2(max((lerp(_1698, _1695, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1722 = _1721 * 0.3010300099849701f;
        _1723 = log2(cb0_008x);
        _1724 = _1723 * 0.3010300099849701f;
        if (_1722 > _1724) {
          _1731 = log2(cb0_009x);
          _1732 = _1731 * 0.3010300099849701f;
          if ((_1722 > _1724) && (_1722 < _1732)) {
            _1740 = ((_1721 - _1723) * 0.9030900001525879f) / ((_1731 - _1723) * 0.3010300099849701f);
            _1741 = int(_1740);
            _1743 = _1740 - float((int)(_1741));
            _1745 = _16[min((uint)(_1741), 5u)];
            _1748 = _16[min((uint)((_1741 + 1)), 5u)];
            _1753 = _1745 * 0.5f;
            _1793 = dot(float3((_1743 * _1743), _1743, 1.0f), float3(mad((_16[min((uint)((_1741 + 2)), 5u)]), 0.5f, mad(_1748, -1.0f, _1753)), (_1748 - _1745), mad(_1748, 0.5f, _1753)));
          } else {
            if (_1722 < _1732) {
              _1793 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1762 = log2(cb0_008z);
              if (!(_1722 < (_1762 * 0.3010300099849701f))) {
                _1793 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1770 = ((_1721 - _1731) * 0.9030900001525879f) / ((_1762 - _1731) * 0.3010300099849701f);
                _1771 = int(_1770);
                _1773 = _1770 - float((int)(_1771));
                _1775 = _17[min((uint)(_1771), 5u)];
                _1778 = _17[min((uint)((_1771 + 1)), 5u)];
                _1783 = _1775 * 0.5f;
                _1793 = dot(float3((_1773 * _1773), _1773, 1.0f), float3(mad((_17[min((uint)((_1771 + 2)), 5u)]), 0.5f, mad(_1778, -1.0f, _1783)), (_1778 - _1775), mad(_1778, 0.5f, _1783)));
              }
            }
          }
        } else {
          _1793 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _18[0] = cb0_010x;
        _18[1] = cb0_010y;
        _18[2] = cb0_010z;
        _18[3] = cb0_010w;
        _18[4] = cb0_012x;
        _18[5] = cb0_012x;
        _19[0] = cb0_011x;
        _19[1] = cb0_011y;
        _19[2] = cb0_011z;
        _19[3] = cb0_011w;
        _19[4] = cb0_012y;
        _19[5] = cb0_012y;
        _1809 = log2(max((lerp(_1698, _1696, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1810 = _1809 * 0.3010300099849701f;
        if (_1810 > _1724) {
          _1817 = log2(cb0_009x);
          _1818 = _1817 * 0.3010300099849701f;
          if ((_1810 > _1724) && (_1810 < _1818)) {
            _1826 = ((_1809 - _1723) * 0.9030900001525879f) / ((_1817 - _1723) * 0.3010300099849701f);
            _1827 = int(_1826);
            _1829 = _1826 - float((int)(_1827));
            _1831 = _18[min((uint)(_1827), 5u)];
            _1834 = _18[min((uint)((_1827 + 1)), 5u)];
            _1839 = _1831 * 0.5f;
            _1879 = dot(float3((_1829 * _1829), _1829, 1.0f), float3(mad((_18[min((uint)((_1827 + 2)), 5u)]), 0.5f, mad(_1834, -1.0f, _1839)), (_1834 - _1831), mad(_1834, 0.5f, _1839)));
          } else {
            if (_1810 < _1818) {
              _1879 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1848 = log2(cb0_008z);
              if (!(_1810 < (_1848 * 0.3010300099849701f))) {
                _1879 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1856 = ((_1809 - _1817) * 0.9030900001525879f) / ((_1848 - _1817) * 0.3010300099849701f);
                _1857 = int(_1856);
                _1859 = _1856 - float((int)(_1857));
                _1861 = _19[min((uint)(_1857), 5u)];
                _1864 = _19[min((uint)((_1857 + 1)), 5u)];
                _1869 = _1861 * 0.5f;
                _1879 = dot(float3((_1859 * _1859), _1859, 1.0f), float3(mad((_19[min((uint)((_1857 + 2)), 5u)]), 0.5f, mad(_1864, -1.0f, _1869)), (_1864 - _1861), mad(_1864, 0.5f, _1869)));
              }
            }
          }
        } else {
          _1879 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1883 = log2(max((lerp(_1698, _1697, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1884 = _1883 * 0.3010300099849701f;
        if (_1884 > _1724) {
          _1891 = log2(cb0_009x);
          _1892 = _1891 * 0.3010300099849701f;
          if ((_1884 > _1724) && (_1884 < _1892)) {
            _1900 = ((_1883 - _1723) * 0.9030900001525879f) / ((_1891 - _1723) * 0.3010300099849701f);
            _1901 = int(_1900);
            _1903 = _1900 - float((int)(_1901));
            _1905 = _8[min((uint)(_1901), 5u)];
            _1908 = _8[min((uint)((_1901 + 1)), 5u)];
            _1913 = _1905 * 0.5f;
            _1953 = dot(float3((_1903 * _1903), _1903, 1.0f), float3(mad((_8[min((uint)((_1901 + 2)), 5u)]), 0.5f, mad(_1908, -1.0f, _1913)), (_1908 - _1905), mad(_1908, 0.5f, _1913)));
          } else {
            if (_1884 < _1892) {
              _1953 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1922 = log2(cb0_008z);
              if (!(_1884 < (_1922 * 0.3010300099849701f))) {
                _1953 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1930 = ((_1883 - _1891) * 0.9030900001525879f) / ((_1922 - _1891) * 0.3010300099849701f);
                _1931 = int(_1930);
                _1933 = _1930 - float((int)(_1931));
                _1935 = _9[min((uint)(_1931), 5u)];
                _1938 = _9[min((uint)((_1931 + 1)), 5u)];
                _1943 = _1935 * 0.5f;
                _1953 = dot(float3((_1933 * _1933), _1933, 1.0f), float3(mad((_9[min((uint)((_1931 + 2)), 5u)]), 0.5f, mad(_1938, -1.0f, _1943)), (_1938 - _1935), mad(_1938, 0.5f, _1943)));
              }
            }
          }
        } else {
          _1953 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1957 = cb0_008w - cb0_008y;
        _1958 = (exp2(_1793 * 3.321928024291992f) - cb0_008y) / _1957;
        _1960 = (exp2(_1879 * 3.321928024291992f) - cb0_008y) / _1957;
        _1962 = (exp2(_1953 * 3.321928024291992f) - cb0_008y) / _1957;
        _1965 = mad(0.15618768334388733f, _1962, mad(0.13400420546531677f, _1960, (_1958 * 0.6624541878700256f)));
        _1968 = mad(0.053689517080783844f, _1962, mad(0.6740817427635193f, _1960, (_1958 * 0.2722287178039551f)));
        _1971 = mad(1.0103391408920288f, _1962, mad(0.00406073359772563f, _1960, (_1958 * -0.005574649665504694f)));
        _1984 = min(max(mad(-0.23642469942569733f, _1971, mad(-0.32480329275131226f, _1968, (_1965 * 1.6410233974456787f))), 0.0f), 1.0f);
        _1985 = min(max(mad(0.016756348311901093f, _1971, mad(1.6153316497802734f, _1968, (_1965 * -0.663662850856781f))), 0.0f), 1.0f);
        _1986 = min(max(mad(0.9883948564529419f, _1971, mad(-0.008284442126750946f, _1968, (_1965 * 0.011721894145011902f))), 0.0f), 1.0f);
        _1989 = mad(0.15618768334388733f, _1986, mad(0.13400420546531677f, _1985, (_1984 * 0.6624541878700256f)));
        _1992 = mad(0.053689517080783844f, _1986, mad(0.6740817427635193f, _1985, (_1984 * 0.2722287178039551f)));
        _1995 = mad(1.0103391408920288f, _1986, mad(0.00406073359772563f, _1985, (_1984 * -0.005574649665504694f)));
        _2017 = min(max((min(max(mad(-0.23642469942569733f, _1995, mad(-0.32480329275131226f, _1992, (_1989 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2018 = min(max((min(max(mad(0.016756348311901093f, _1995, mad(1.6153316497802734f, _1992, (_1989 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2019 = min(max((min(max(mad(0.9883948564529419f, _1995, mad(-0.008284442126750946f, _1992, (_1989 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2022 = mad(_53, _2019, mad(_52, _2018, (_2017 * _51)));
        _2025 = mad(_56, _2019, mad(_55, _2018, (_2017 * _54)));
        _2028 = mad(_59, _2019, mad(_58, _2018, (_2017 * _57)));
        _2032 = 1.0f / cb0_041y;
        _2045 = cb0_041y * exp2(log2(_2032 * _2022) * cb0_041x);
        _2046 = cb0_041y * exp2(log2(_2032 * _2025) * cb0_041x);
        _2047 = cb0_041y * exp2(log2(_2032 * _2028) * cb0_041x);
        _2053 = saturate((dot(float3(_2022, _2025, _2028), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f)) - cb0_041y) / (cb0_041z - cb0_041y));
        _2057 = (_2053 * _2053) * (3.0f - (_2053 * 2.0f));
        _2076 = exp2(log2(((_2057 * (_2022 - _2045)) + _2045) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2077 = exp2(log2(((_2057 * (_2025 - _2046)) + _2046) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2078 = exp2(log2(((_2057 * (_2028 - _2047)) + _2047) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2109 = (pow(cb0_041w, 0.1593017578125f));
        _2119 = exp2(log2(((_2109 * 18.8515625f) + 0.8359375f) * (1.0f / ((_2109 * 18.6875f) + 1.0f))) * 78.84375f) * 1.3300952911376953f;
        _2915 = (_2119 * exp2(log2((1.0f / ((_2076 * 18.6875f) + 1.0f)) * ((_2076 * 18.8515625f) + 0.8359375f)) * 78.84375f));
        _2916 = (_2119 * exp2(log2((1.0f / ((_2077 * 18.6875f) + 1.0f)) * ((_2077 * 18.8515625f) + 0.8359375f)) * 78.84375f));
        _2917 = (_2119 * exp2(log2((1.0f / ((_2078 * 18.6875f) + 1.0f)) * ((_2078 * 18.8515625f) + 0.8359375f)) * 78.84375f));
      } else {
        if ((uint)((int)((uint)(cb0_043w) + (uint)(-5))) < (uint)2) {
          _2161 = cb0_012z * _1229;
          _2162 = cb0_012z * _1230;
          _2163 = cb0_012z * _1231;
          _2166 = mad((WorkingColorSpace_256[0].z), _2163, mad((WorkingColorSpace_256[0].y), _2162, ((WorkingColorSpace_256[0].x) * _2161)));
          _2169 = mad((WorkingColorSpace_256[1].z), _2163, mad((WorkingColorSpace_256[1].y), _2162, ((WorkingColorSpace_256[1].x) * _2161)));
          _2172 = mad((WorkingColorSpace_256[2].z), _2163, mad((WorkingColorSpace_256[2].y), _2162, ((WorkingColorSpace_256[2].x) * _2161)));
          _2175 = mad(-0.21492856740951538f, _2172, mad(-0.2365107536315918f, _2169, (_2166 * 1.4514392614364624f)));
          _2178 = mad(-0.09967592358589172f, _2172, mad(1.17622971534729f, _2169, (_2166 * -0.07655377686023712f)));
          _2181 = mad(0.9977163076400757f, _2172, mad(-0.006032449658960104f, _2169, (_2166 * 0.008316148072481155f)));
          _2183 = max(_2175, max(_2178, _2181));
          if (!(_2183 < 1.000000013351432e-10f)) {
            if (!(((_2166 < 0.0f) || (_2169 < 0.0f)) || (_2172 < 0.0f))) {
              _2193 = abs(_2183);
              _2194 = (_2183 - _2175) / _2193;
              _2196 = (_2183 - _2178) / _2193;
              _2198 = (_2183 - _2181) / _2193;
              if (!(_2194 < 0.8149999976158142f)) {
                _2201 = _2194 + -0.8149999976158142f;
                _2213 = ((_2201 / exp2(log2(exp2(log2(_2201 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _2213 = _2194;
              }
              if (!(_2196 < 0.8029999732971191f)) {
                _2216 = _2196 + -0.8029999732971191f;
                _2228 = ((_2216 / exp2(log2(exp2(log2(_2216 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _2228 = _2196;
              }
              if (!(_2198 < 0.8799999952316284f)) {
                _2231 = _2198 + -0.8799999952316284f;
                _2243 = ((_2231 / exp2(log2(exp2(log2(_2231 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2243 = _2198;
              }
              _2251 = (_2183 - (_2193 * _2213));
              _2252 = (_2183 - (_2193 * _2228));
              _2253 = (_2183 - (_2193 * _2243));
            } else {
              _2251 = _2175;
              _2252 = _2178;
              _2253 = _2181;
            }
          } else {
            _2251 = _2175;
            _2252 = _2178;
            _2253 = _2181;
          }
          _2269 = ((mad(0.16386906802654266f, _2253, mad(0.14067870378494263f, _2252, (_2251 * 0.6954522132873535f))) - _2166) * cb0_012w) + _2166;
          _2270 = ((mad(0.0955343171954155f, _2253, mad(0.8596711158752441f, _2252, (_2251 * 0.044794563204050064f))) - _2169) * cb0_012w) + _2169;
          _2271 = ((mad(1.0015007257461548f, _2253, mad(0.004025210160762072f, _2252, (_2251 * -0.005525882821530104f))) - _2172) * cb0_012w) + _2172;
          _2275 = max(max(_2269, _2270), _2271);
          _2280 = (max(_2275, 1.000000013351432e-10f) - max(min(min(_2269, _2270), _2271), 1.000000013351432e-10f)) / max(_2275, 0.009999999776482582f);
          _2293 = ((_2270 + _2269) + _2271) + (sqrt((((_2271 - _2270) * _2271) + ((_2270 - _2269) * _2270)) + ((_2269 - _2271) * _2269)) * 1.75f);
          _2294 = _2293 * 0.3333333432674408f;
          _2295 = _2280 + -0.4000000059604645f;
          _2296 = _2295 * 5.0f;
          _2300 = max((1.0f - abs(_2295 * 2.5f)), 0.0f);
          _2311 = ((float((int)(((int)(uint)((int)(_2296 > 0.0f))) - ((int)(uint)((int)(_2296 < 0.0f))))) * (1.0f - (_2300 * _2300))) + 1.0f) * 0.02500000037252903f;
          if (_2294 > 0.0533333346247673f) {
            if (_2294 < 0.1599999964237213f) {
              _2320 = (((0.23999999463558197f / _2293) + -0.5f) * _2311);
            } else {
              _2320 = 0.0f;
            }
          } else {
            _2320 = _2311;
          }
          _2321 = _2320 + 1.0f;
          _2322 = _2321 * _2269;
          _2323 = _2321 * _2270;
          _2324 = _2321 * _2271;
          if (!((_2322 == _2323) && (_2323 == _2324))) {
            _2331 = ((_2322 * 2.0f) - _2323) - _2324;
            _2334 = ((_2270 - _2271) * 1.7320507764816284f) * _2321;
            _2336 = atan(_2334 / _2331);
            _2339 = (_2331 < 0.0f);
            _2340 = (_2331 == 0.0f);
            _2341 = (_2334 >= 0.0f);
            _2342 = (_2334 < 0.0f);
            _2353 = select((_2341 && _2340), 90.0f, select((_2342 && _2340), -90.0f, (select((_2342 && _2339), (_2336 + -3.1415927410125732f), select((_2341 && _2339), (_2336 + 3.1415927410125732f), _2336)) * 57.2957763671875f)));
          } else {
            _2353 = 0.0f;
          }
          _2358 = min(max(select((_2353 < 0.0f), (_2353 + 360.0f), _2353), 0.0f), 360.0f);
          if (_2358 < -180.0f) {
            _2367 = (_2358 + 360.0f);
          } else {
            if (_2358 > 180.0f) {
              _2367 = (_2358 + -360.0f);
            } else {
              _2367 = _2358;
            }
          }
          if ((_2367 > -67.5f) && (_2367 < 67.5f)) {
            _2373 = (_2367 + 67.5f) * 0.029629629105329514f;
            _2374 = int(_2373);
            _2376 = _2373 - float((int)(_2374));
            _2377 = _2376 * _2376;
            _2378 = _2377 * _2376;
            if (_2374 == 3) {
              _2406 = (((0.1666666716337204f - (_2376 * 0.5f)) + (_2377 * 0.5f)) - (_2378 * 0.1666666716337204f));
            } else {
              if (_2374 == 2) {
                _2406 = ((0.6666666865348816f - _2377) + (_2378 * 0.5f));
              } else {
                if (_2374 == 1) {
                  _2406 = (((_2378 * -0.5f) + 0.1666666716337204f) + ((_2377 + _2376) * 0.5f));
                } else {
                  _2406 = select((_2374 == 0), (_2378 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2406 = 0.0f;
          }
          _2415 = min(max(((((_2280 * 0.27000001072883606f) * (0.029999999329447746f - _2322)) * _2406) + _2322), 0.0f), 65535.0f);
          _2416 = min(max(_2323, 0.0f), 65535.0f);
          _2417 = min(max(_2324, 0.0f), 65535.0f);
          _2430 = min(max(mad(-0.21492856740951538f, _2417, mad(-0.2365107536315918f, _2416, (_2415 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2431 = min(max(mad(-0.09967592358589172f, _2417, mad(1.17622971534729f, _2416, (_2415 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2432 = min(max(mad(0.9977163076400757f, _2417, mad(-0.006032449658960104f, _2416, (_2415 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2433 = dot(float3(_2430, _2431, _2432), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
          _2456 = log2(max((lerp(_2433, _2430, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2457 = _2456 * 0.3010300099849701f;
          _2458 = log2(cb0_008x);
          _2459 = _2458 * 0.3010300099849701f;
          if (_2457 > _2459) {
            _2466 = log2(cb0_009x);
            _2467 = _2466 * 0.3010300099849701f;
            if ((_2457 > _2459) && (_2457 < _2467)) {
              _2475 = ((_2456 - _2458) * 0.9030900001525879f) / ((_2466 - _2458) * 0.3010300099849701f);
              _2476 = int(_2475);
              _2478 = _2475 - float((int)(_2476));
              _2480 = _14[min((uint)(_2476), 5u)];
              _2483 = _14[min((uint)((_2476 + 1)), 5u)];
              _2488 = _2480 * 0.5f;
              _2528 = dot(float3((_2478 * _2478), _2478, 1.0f), float3(mad((_14[min((uint)((_2476 + 2)), 5u)]), 0.5f, mad(_2483, -1.0f, _2488)), (_2483 - _2480), mad(_2483, 0.5f, _2488)));
            } else {
              if (_2457 < _2467) {
                _2528 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2497 = log2(cb0_008z);
                if (!(_2457 < (_2497 * 0.3010300099849701f))) {
                  _2528 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2505 = ((_2456 - _2466) * 0.9030900001525879f) / ((_2497 - _2466) * 0.3010300099849701f);
                  _2506 = int(_2505);
                  _2508 = _2505 - float((int)(_2506));
                  _2510 = _15[min((uint)(_2506), 5u)];
                  _2513 = _15[min((uint)((_2506 + 1)), 5u)];
                  _2518 = _2510 * 0.5f;
                  _2528 = dot(float3((_2508 * _2508), _2508, 1.0f), float3(mad((_15[min((uint)((_2506 + 2)), 5u)]), 0.5f, mad(_2513, -1.0f, _2518)), (_2513 - _2510), mad(_2513, 0.5f, _2518)));
                }
              }
            }
          } else {
            _2528 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2544 = log2(max((lerp(_2433, _2431, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2545 = _2544 * 0.3010300099849701f;
          if (_2545 > _2459) {
            _2552 = log2(cb0_009x);
            _2553 = _2552 * 0.3010300099849701f;
            if ((_2545 > _2459) && (_2545 < _2553)) {
              _2561 = ((_2544 - _2458) * 0.9030900001525879f) / ((_2552 - _2458) * 0.3010300099849701f);
              _2562 = int(_2561);
              _2564 = _2561 - float((int)(_2562));
              _2566 = _10[min((uint)(_2562), 5u)];
              _2569 = _10[min((uint)((_2562 + 1)), 5u)];
              _2574 = _2566 * 0.5f;
              _2614 = dot(float3((_2564 * _2564), _2564, 1.0f), float3(mad((_10[min((uint)((_2562 + 2)), 5u)]), 0.5f, mad(_2569, -1.0f, _2574)), (_2569 - _2566), mad(_2569, 0.5f, _2574)));
            } else {
              if (_2545 < _2553) {
                _2614 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2583 = log2(cb0_008z);
                if (!(_2545 < (_2583 * 0.3010300099849701f))) {
                  _2614 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2591 = ((_2544 - _2552) * 0.9030900001525879f) / ((_2583 - _2552) * 0.3010300099849701f);
                  _2592 = int(_2591);
                  _2594 = _2591 - float((int)(_2592));
                  _2596 = _11[min((uint)(_2592), 5u)];
                  _2599 = _11[min((uint)((_2592 + 1)), 5u)];
                  _2604 = _2596 * 0.5f;
                  _2614 = dot(float3((_2594 * _2594), _2594, 1.0f), float3(mad((_11[min((uint)((_2592 + 2)), 5u)]), 0.5f, mad(_2599, -1.0f, _2604)), (_2599 - _2596), mad(_2599, 0.5f, _2604)));
                }
              }
            }
          } else {
            _2614 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2630 = log2(max((lerp(_2433, _2432, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2631 = _2630 * 0.3010300099849701f;
          if (_2631 > _2459) {
            _2638 = log2(cb0_009x);
            _2639 = _2638 * 0.3010300099849701f;
            if ((_2631 > _2459) && (_2631 < _2639)) {
              _2647 = ((_2630 - _2458) * 0.9030900001525879f) / ((_2638 - _2458) * 0.3010300099849701f);
              _2648 = int(_2647);
              _2650 = _2647 - float((int)(_2648));
              _2652 = _12[min((uint)(_2648), 5u)];
              _2655 = _12[min((uint)((_2648 + 1)), 5u)];
              _2660 = _2652 * 0.5f;
              _2700 = dot(float3((_2650 * _2650), _2650, 1.0f), float3(mad((_12[min((uint)((_2648 + 2)), 5u)]), 0.5f, mad(_2655, -1.0f, _2660)), (_2655 - _2652), mad(_2655, 0.5f, _2660)));
            } else {
              if (_2631 < _2639) {
                _2700 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2669 = log2(cb0_008z);
                if (!(_2631 < (_2669 * 0.3010300099849701f))) {
                  _2700 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2677 = ((_2630 - _2638) * 0.9030900001525879f) / ((_2669 - _2638) * 0.3010300099849701f);
                  _2678 = int(_2677);
                  _2680 = _2677 - float((int)(_2678));
                  _2682 = _13[min((uint)(_2678), 5u)];
                  _2685 = _13[min((uint)((_2678 + 1)), 5u)];
                  _2690 = _2682 * 0.5f;
                  _2700 = dot(float3((_2680 * _2680), _2680, 1.0f), float3(mad((_13[min((uint)((_2678 + 2)), 5u)]), 0.5f, mad(_2685, -1.0f, _2690)), (_2685 - _2682), mad(_2685, 0.5f, _2690)));
                }
              }
            }
          } else {
            _2700 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2704 = cb0_008w - cb0_008y;
          _2705 = (exp2(_2528 * 3.321928024291992f) - cb0_008y) / _2704;
          _2707 = (exp2(_2614 * 3.321928024291992f) - cb0_008y) / _2704;
          _2709 = (exp2(_2700 * 3.321928024291992f) - cb0_008y) / _2704;
          _2712 = mad(0.15618768334388733f, _2709, mad(0.13400420546531677f, _2707, (_2705 * 0.6624541878700256f)));
          _2715 = mad(0.053689517080783844f, _2709, mad(0.6740817427635193f, _2707, (_2705 * 0.2722287178039551f)));
          _2718 = mad(1.0103391408920288f, _2709, mad(0.00406073359772563f, _2707, (_2705 * -0.005574649665504694f)));
          _2731 = min(max(mad(-0.23642469942569733f, _2718, mad(-0.32480329275131226f, _2715, (_2712 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2732 = min(max(mad(0.016756348311901093f, _2718, mad(1.6153316497802734f, _2715, (_2712 * -0.663662850856781f))), 0.0f), 1.0f);
          _2733 = min(max(mad(0.9883948564529419f, _2718, mad(-0.008284442126750946f, _2715, (_2712 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2736 = mad(0.15618768334388733f, _2733, mad(0.13400420546531677f, _2732, (_2731 * 0.6624541878700256f)));
          _2739 = mad(0.053689517080783844f, _2733, mad(0.6740817427635193f, _2732, (_2731 * 0.2722287178039551f)));
          _2742 = mad(1.0103391408920288f, _2733, mad(0.00406073359772563f, _2732, (_2731 * -0.005574649665504694f)));
          _2764 = min(max((min(max(mad(-0.23642469942569733f, _2742, mad(-0.32480329275131226f, _2739, (_2736 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2767 = min(max((min(max(mad(0.016756348311901093f, _2742, mad(1.6153316497802734f, _2739, (_2736 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2768 = min(max((min(max(mad(0.9883948564529419f, _2742, mad(-0.008284442126750946f, _2739, (_2736 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2915 = mad(-0.0832589864730835f, _2768, mad(-0.6217921376228333f, _2767, (_2764 * 0.0213131383061409f)));
          _2916 = mad(-0.010548308491706848f, _2768, mad(1.140804648399353f, _2767, (_2764 * -0.0016282059950754046f)));
          _2917 = mad(1.1529725790023804f, _2768, mad(-0.1289689838886261f, _2767, (_2764 * -0.00030004189466126263f)));
        } else {
          if (cb0_043w == 7) {
            _2795 = mad((WorkingColorSpace_128[0].z), _1231, mad((WorkingColorSpace_128[0].y), _1230, ((WorkingColorSpace_128[0].x) * _1229)));
            _2798 = mad((WorkingColorSpace_128[1].z), _1231, mad((WorkingColorSpace_128[1].y), _1230, ((WorkingColorSpace_128[1].x) * _1229)));
            _2801 = mad((WorkingColorSpace_128[2].z), _1231, mad((WorkingColorSpace_128[2].y), _1230, ((WorkingColorSpace_128[2].x) * _1229)));
            _2820 = exp2(log2(mad(_53, _2801, mad(_52, _2798, (_2795 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2821 = exp2(log2(mad(_56, _2801, mad(_55, _2798, (_2795 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2822 = exp2(log2(mad(_59, _2801, mad(_58, _2798, (_2795 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2915 = exp2(log2((1.0f / ((_2820 * 18.6875f) + 1.0f)) * ((_2820 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2916 = exp2(log2((1.0f / ((_2821 * 18.6875f) + 1.0f)) * ((_2821 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2917 = exp2(log2((1.0f / ((_2822 * 18.6875f) + 1.0f)) * ((_2822 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_043w == 8)) {
              if (cb0_043w == 9) {
                _2869 = mad((WorkingColorSpace_128[0].z), _1219, mad((WorkingColorSpace_128[0].y), _1218, ((WorkingColorSpace_128[0].x) * _1217)));
                _2872 = mad((WorkingColorSpace_128[1].z), _1219, mad((WorkingColorSpace_128[1].y), _1218, ((WorkingColorSpace_128[1].x) * _1217)));
                _2875 = mad((WorkingColorSpace_128[2].z), _1219, mad((WorkingColorSpace_128[2].y), _1218, ((WorkingColorSpace_128[2].x) * _1217)));
                _2915 = mad(_53, _2875, mad(_52, _2872, (_2869 * _51)));
                _2916 = mad(_56, _2875, mad(_55, _2872, (_2869 * _54)));
                _2917 = mad(_59, _2875, mad(_58, _2872, (_2869 * _57)));
              } else {
                _2888 = mad((WorkingColorSpace_128[0].z), _1245, mad((WorkingColorSpace_128[0].y), _1244, ((WorkingColorSpace_128[0].x) * _1243)));
                _2891 = mad((WorkingColorSpace_128[1].z), _1245, mad((WorkingColorSpace_128[1].y), _1244, ((WorkingColorSpace_128[1].x) * _1243)));
                _2894 = mad((WorkingColorSpace_128[2].z), _1245, mad((WorkingColorSpace_128[2].y), _1244, ((WorkingColorSpace_128[2].x) * _1243)));
                _2915 = exp2(log2(mad(_53, _2894, mad(_52, _2891, (_2888 * _51)))) * cb0_043z);
                _2916 = exp2(log2(mad(_56, _2894, mad(_55, _2891, (_2888 * _54)))) * cb0_043z);
                _2917 = exp2(log2(mad(_59, _2894, mad(_58, _2891, (_2888 * _57)))) * cb0_043z);
              }
            } else {
              _2915 = _1229;
              _2916 = _1230;
              _2917 = _1231;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2915 * 0.9523810148239136f);
  SV_Target.y = (_2916 * 0.9523810148239136f);
  SV_Target.z = (_2917 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
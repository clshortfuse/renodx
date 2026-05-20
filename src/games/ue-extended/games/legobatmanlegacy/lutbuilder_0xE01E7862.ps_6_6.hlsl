// Lego Batman Legacy

#include "../../lutbuilder/lutbuilderoutput.hlsli"

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
  float _1102;
  float _1103;
  float _1104;
  float _1115;
  float _1126;
  float _1295;
  float _1310;
  float _1325;
  float _1333;
  float _1334;
  float _1335;
  float _1402;
  float _1435;
  float _1449;
  float _1488;
  float _1610;
  float _1696;
  float _1770;
  float _1975;
  float _1990;
  float _2005;
  float _2013;
  float _2014;
  float _2015;
  float _2082;
  float _2115;
  float _2129;
  float _2168;
  float _2290;
  float _2376;
  float _2462;
  float _2677;
  float _2678;
  float _2679;
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
  float _513;
  float _514;
  float _515;
  float _516;
  float _517;
  float _518;
  float _528;
  float _529;
  float _530;
  float _549;
  float _550;
  float _551;
  float _561;
  float _562;
  float _563;
  float _567;
  float _568;
  float _569;
  float _575;
  float _579;
  float _580;
  float _589;
  float _598;
  float _607;
  float _616;
  float _625;
  float _626;
  float _627;
  float _628;
  float _638;
  float _639;
  float _640;
  float _659;
  float _660;
  float _661;
  float _671;
  float _672;
  float _673;
  float _677;
  float _678;
  float _679;
  float _688;
  float _692;
  float _701;
  float _710;
  float _719;
  float _728;
  float _737;
  float _738;
  float _739;
  float _740;
  float _750;
  float _751;
  float _752;
  float _771;
  float _772;
  float _773;
  float _783;
  float _784;
  float _785;
  float _789;
  float _790;
  float _791;
  float _795;
  float _806;
  float _808;
  float _810;
  float _832;
  float _833;
  float _834;
  float _835;
  float _876;
  float _880;
  float _881;
  float _927;
  float _931;
  float _971;
  float _982;
  float _984;
  float _986;
  float _987;
  float _993;
  float _997;
  float _998;
  float _999;
  float _1025;
  float _1026;
  float _1027;
  float _1034;
  float _1035;
  float _1036;
  float _1037;
  float _1038;
  float _1039;
  float _1046;
  float _1047;
  float _1048;
  float _1060;
  float _1061;
  float _1062;
  float _1085;
  float _1088;
  float _1091;
  float _1153;
  float _1156;
  float _1159;
  float _1162;
  float _1165;
  float _1168;
  float _1243;
  float _1244;
  float _1245;
  float _1248;
  float _1251;
  float _1254;
  float _1257;
  float _1260;
  float _1263;
  float _1265;
  float _1275;
  float _1276;
  float _1278;
  float _1280;
  float _1283;
  float _1298;
  float _1313;
  float _1351;
  float _1352;
  float _1353;
  float _1357;
  float _1362;
  float _1375;
  float _1376;
  float _1377;
  float _1378;
  float _1382;
  float _1393;
  float _1403;
  float _1404;
  float _1405;
  float _1406;
  float _1413;
  float _1416;
  float _1418;
  bool _1421;
  bool _1422;
  bool _1423;
  bool _1424;
  float _1440;
  float _1455;
  int _1456;
  float _1458;
  float _1459;
  float _1460;
  float _1497;
  float _1498;
  float _1499;
  float _1512;
  float _1513;
  float _1514;
  float _1515;
  float _1538;
  float _1539;
  float _1540;
  float _1541;
  float _1548;
  float _1549;
  float _1557;
  int _1558;
  float _1560;
  float _1562;
  float _1565;
  float _1570;
  float _1579;
  float _1587;
  int _1588;
  float _1590;
  float _1592;
  float _1595;
  float _1600;
  float _1626;
  float _1627;
  float _1634;
  float _1635;
  float _1643;
  int _1644;
  float _1646;
  float _1648;
  float _1651;
  float _1656;
  float _1665;
  float _1673;
  int _1674;
  float _1676;
  float _1678;
  float _1681;
  float _1686;
  float _1700;
  float _1701;
  float _1708;
  float _1709;
  float _1717;
  int _1718;
  float _1720;
  float _1722;
  float _1725;
  float _1730;
  float _1739;
  float _1747;
  int _1748;
  float _1750;
  float _1752;
  float _1755;
  float _1760;
  float _1774;
  float _1775;
  float _1777;
  float _1779;
  float _1782;
  float _1785;
  float _1788;
  float _1801;
  float _1802;
  float _1803;
  float _1806;
  float _1809;
  float _1812;
  float _1834;
  float _1835;
  float _1836;
  float _1855;
  float _1856;
  float _1857;
  float _1923;
  float _1924;
  float _1925;
  float _1928;
  float _1931;
  float _1934;
  float _1937;
  float _1940;
  float _1943;
  float _1945;
  float _1955;
  float _1956;
  float _1958;
  float _1960;
  float _1963;
  float _1978;
  float _1993;
  float _2031;
  float _2032;
  float _2033;
  float _2037;
  float _2042;
  float _2055;
  float _2056;
  float _2057;
  float _2058;
  float _2062;
  float _2073;
  float _2083;
  float _2084;
  float _2085;
  float _2086;
  float _2093;
  float _2096;
  float _2098;
  bool _2101;
  bool _2102;
  bool _2103;
  bool _2104;
  float _2120;
  float _2135;
  int _2136;
  float _2138;
  float _2139;
  float _2140;
  float _2177;
  float _2178;
  float _2179;
  float _2192;
  float _2193;
  float _2194;
  float _2195;
  float _2218;
  float _2219;
  float _2220;
  float _2221;
  float _2228;
  float _2229;
  float _2237;
  int _2238;
  float _2240;
  float _2242;
  float _2245;
  float _2250;
  float _2259;
  float _2267;
  int _2268;
  float _2270;
  float _2272;
  float _2275;
  float _2280;
  float _2306;
  float _2307;
  float _2314;
  float _2315;
  float _2323;
  int _2324;
  float _2326;
  float _2328;
  float _2331;
  float _2336;
  float _2345;
  float _2353;
  int _2354;
  float _2356;
  float _2358;
  float _2361;
  float _2366;
  float _2392;
  float _2393;
  float _2400;
  float _2401;
  float _2409;
  int _2410;
  float _2412;
  float _2414;
  float _2417;
  float _2422;
  float _2431;
  float _2439;
  int _2440;
  float _2442;
  float _2444;
  float _2447;
  float _2452;
  float _2466;
  float _2467;
  float _2469;
  float _2471;
  float _2474;
  float _2477;
  float _2480;
  float _2493;
  float _2494;
  float _2495;
  float _2498;
  float _2501;
  float _2504;
  float _2526;
  float _2529;
  float _2530;
  float _2557;
  float _2560;
  float _2563;
  float _2582;
  float _2583;
  float _2584;
  float _2631;
  float _2634;
  float _2637;
  float _2650;
  float _2653;
  float _2656;
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
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _40 = (cb0_043x == 4);
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
  if ((uint)cb0_042w > (uint)2) {
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
  _513 = (cb0_017x * cb0_022x) * _512;
  _514 = (cb0_017y * cb0_022y) * _512;
  _515 = (cb0_017z * cb0_022z) * _512;
  _516 = _439 - _442;
  _517 = _440 - _442;
  _518 = _441 - _442;
  _528 = (cb0_018x * cb0_023x) * _498;
  _529 = (cb0_018y * cb0_023y) * _498;
  _530 = (cb0_018z * cb0_023z) * _498;
  _549 = 1.0f / ((cb0_019x * cb0_024x) * _484);
  _550 = 1.0f / ((cb0_019y * cb0_024y) * _484);
  _551 = 1.0f / ((cb0_019z * cb0_024z) * _484);
  _561 = (cb0_020x * cb0_025x) * _470;
  _562 = (cb0_020y * cb0_025y) * _470;
  _563 = (cb0_020z * cb0_025z) * _470;
  _567 = (cb0_021x + cb0_026x) + _456;
  _568 = (cb0_021y + cb0_026y) + _456;
  _569 = (cb0_021z + cb0_026z) + _456;
  _575 = saturate(_442 / cb0_037w);
  _579 = (_575 * _575) * (3.0f - (_575 * 2.0f));
  _580 = 1.0f - _579;
  _589 = cb0_021w + cb0_036w;
  _598 = cb0_020w * cb0_035w;
  _607 = cb0_019w * cb0_034w;
  _616 = cb0_018w * cb0_033w;
  _625 = cb0_017w * cb0_032w;
  _626 = (cb0_017x * cb0_032x) * _625;
  _627 = (cb0_017y * cb0_032y) * _625;
  _628 = (cb0_017z * cb0_032z) * _625;
  _638 = (cb0_018x * cb0_033x) * _616;
  _639 = (cb0_018y * cb0_033y) * _616;
  _640 = (cb0_018z * cb0_033z) * _616;
  _659 = 1.0f / ((cb0_019x * cb0_034x) * _607);
  _660 = 1.0f / ((cb0_019y * cb0_034y) * _607);
  _661 = 1.0f / ((cb0_019z * cb0_034z) * _607);
  _671 = (cb0_020x * cb0_035x) * _598;
  _672 = (cb0_020y * cb0_035y) * _598;
  _673 = (cb0_020z * cb0_035z) * _598;
  _677 = (cb0_021x + cb0_036x) + _589;
  _678 = (cb0_021y + cb0_036y) + _589;
  _679 = (cb0_021z + cb0_036z) + _589;
  _688 = saturate((_442 - cb0_038x) / (cb0_038y - cb0_038x));
  _692 = (_688 * _688) * (3.0f - (_688 * 2.0f));
  _701 = cb0_021w + cb0_031w;
  _710 = cb0_020w * cb0_030w;
  _719 = cb0_019w * cb0_029w;
  _728 = cb0_018w * cb0_028w;
  _737 = cb0_017w * cb0_027w;
  _738 = (cb0_017x * cb0_027x) * _737;
  _739 = (cb0_017y * cb0_027y) * _737;
  _740 = (cb0_017z * cb0_027z) * _737;
  _750 = (cb0_018x * cb0_028x) * _728;
  _751 = (cb0_018y * cb0_028y) * _728;
  _752 = (cb0_018z * cb0_028z) * _728;
  _771 = 1.0f / ((cb0_019x * cb0_029x) * _719);
  _772 = 1.0f / ((cb0_019y * cb0_029y) * _719);
  _773 = 1.0f / ((cb0_019z * cb0_029z) * _719);
  _783 = (cb0_020x * cb0_030x) * _710;
  _784 = (cb0_020y * cb0_030y) * _710;
  _785 = (cb0_020z * cb0_030z) * _710;
  _789 = (cb0_021x + cb0_031x) + _701;
  _790 = (cb0_021y + cb0_031y) + _701;
  _791 = (cb0_021z + cb0_031z) + _701;
  _795 = _579 - _692;
  _806 = ((_692 * (_677 + (_671 * exp2(log2(exp2(_638 * log2(max(0.0f, ((_626 * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * _659)))) + (_580 * (_567 + (_561 * exp2(log2(exp2(_528 * log2(max(0.0f, ((_513 * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * _549))))) + ((_789 + (_783 * exp2(log2(exp2(_750 * log2(max(0.0f, ((_738 * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * _771))) * _795);
  _808 = ((_692 * (_678 + (_672 * exp2(log2(exp2(_639 * log2(max(0.0f, ((_627 * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * _660)))) + (_580 * (_568 + (_562 * exp2(log2(exp2(_529 * log2(max(0.0f, ((_514 * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * _550))))) + ((_790 + (_784 * exp2(log2(exp2(_751 * log2(max(0.0f, ((_739 * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * _772))) * _795);
  _810 = ((_692 * (_679 + (_673 * exp2(log2(exp2(_640 * log2(max(0.0f, ((_628 * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * _661)))) + (_580 * (_569 + (_563 * exp2(log2(exp2(_530 * log2(max(0.0f, ((_515 * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * _551))))) + ((_791 + (_785 * exp2(log2(exp2(_752 * log2(max(0.0f, ((_740 * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * _773))) * _795);

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = cb0_040x;
  cb_config.ue_filmtoe = cb0_039z;
  cb_config.ue_filmshoulder = cb0_039w;
  cb_config.ue_filmslope = cb0_039y;
  cb_config.ue_filmwhiteclip = cb0_040y;
  cb_config.ue_tonecurveammount = 0.f;
  cb_config.ue_mappingpolynomial = float3(cb0_041x, cb0_041y, cb0_041z);
  cb_config.ue_overlaycolor = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
  cb_config.ue_bluecorrection = 0.f;
  cb_config.ue_colorscale = float3(cb0_016x, cb0_016y, cb0_016z);

  float4 output = ProcessLutbuilder(float3(_806, _808, _810), cb_config, SV_Target, asuint(cb0_042w));
  SV_Target = output;
  return SV_Target;

  _832 = dot(float3(_381, _382, _383), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _833 = _381 - _832;
  _834 = _382 - _832;
  _835 = _383 - _832;
  _876 = saturate(_832 / cb0_037w);
  _880 = (_876 * _876) * (3.0f - (_876 * 2.0f));
  _881 = 1.0f - _880;
  _927 = saturate((_832 - cb0_038x) / (cb0_038y - cb0_038x));
  _931 = (_927 * _927) * (3.0f - (_927 * 2.0f));
  _971 = _880 - _931;
  _982 = ((_931 * (_677 + (_671 * exp2(log2(exp2(_638 * log2(max(0.0f, ((_626 * _833) + _832)) * 5.55555534362793f)) * 0.18000000715255737f) * _659)))) + (_881 * (_567 + (_561 * exp2(log2(exp2(_528 * log2(max(0.0f, ((_513 * _833) + _832)) * 5.55555534362793f)) * 0.18000000715255737f) * _549))))) + ((_789 + (_783 * exp2(log2(exp2(_750 * log2(max(0.0f, ((_738 * _833) + _832)) * 5.55555534362793f)) * 0.18000000715255737f) * _771))) * _971);
  _984 = ((_931 * (_678 + (_672 * exp2(log2(exp2(_639 * log2(max(0.0f, ((_627 * _834) + _832)) * 5.55555534362793f)) * 0.18000000715255737f) * _660)))) + (_881 * (_568 + (_562 * exp2(log2(exp2(_529 * log2(max(0.0f, ((_514 * _834) + _832)) * 5.55555534362793f)) * 0.18000000715255737f) * _550))))) + ((_790 + (_784 * exp2(log2(exp2(_751 * log2(max(0.0f, ((_739 * _834) + _832)) * 5.55555534362793f)) * 0.18000000715255737f) * _772))) * _971);
  _986 = ((_931 * (_679 + (_673 * exp2(log2(exp2(_640 * log2(max(0.0f, ((_628 * _835) + _832)) * 5.55555534362793f)) * 0.18000000715255737f) * _661)))) + (_881 * (_569 + (_563 * exp2(log2(exp2(_530 * log2(max(0.0f, ((_515 * _835) + _832)) * 5.55555534362793f)) * 0.18000000715255737f) * _551))))) + ((_791 + (_785 * exp2(log2(exp2(_752 * log2(max(0.0f, ((_740 * _835) + _832)) * 5.55555534362793f)) * 0.18000000715255737f) * _773))) * _971);
  _987 = dot(float3(_982, _984, _986), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  _993 = (((_987 * 0.25f) + 1.0f) * _987) / ((_987 + 1.0f) * _987);
  _997 = max(0.0f, (_982 * _993));
  _998 = max(0.0f, (_984 * _993));
  _999 = max(0.0f, (_986 * _993));
  _1025 = cb0_016x * (((cb0_041y + (cb0_041x * _997)) * _997) + cb0_041z);
  _1026 = cb0_016y * (((cb0_041y + (cb0_041x * _998)) * _998) + cb0_041z);
  _1027 = cb0_016z * (((cb0_041y + (cb0_041x * _999)) * _999) + cb0_041z);
  _1034 = ((cb0_015x - _1025) * cb0_015w) + _1025;
  _1035 = ((cb0_015y - _1026) * cb0_015w) + _1026;
  _1036 = ((cb0_015z - _1027) * cb0_015w) + _1027;
  _1037 = cb0_016x * mad((WorkingColorSpace_192[0].z), _810, mad((WorkingColorSpace_192[0].y), _808, (_806 * (WorkingColorSpace_192[0].x))));
  _1038 = cb0_016y * mad((WorkingColorSpace_192[1].z), _810, mad((WorkingColorSpace_192[1].y), _808, ((WorkingColorSpace_192[1].x) * _806)));
  _1039 = cb0_016z * mad((WorkingColorSpace_192[2].z), _810, mad((WorkingColorSpace_192[2].y), _808, ((WorkingColorSpace_192[2].x) * _806)));
  _1046 = ((cb0_015x - _1037) * cb0_015w) + _1037;
  _1047 = ((cb0_015y - _1038) * cb0_015w) + _1038;
  _1048 = ((cb0_015z - _1039) * cb0_015w) + _1039;
  _1060 = exp2(log2(max(0.0f, _1034)) * cb0_042y);
  _1061 = exp2(log2(max(0.0f, _1035)) * cb0_042y);
  _1062 = exp2(log2(max(0.0f, _1036)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1085 = mad((WorkingColorSpace_128[0].z), _1062, mad((WorkingColorSpace_128[0].y), _1061, ((WorkingColorSpace_128[0].x) * _1060)));
      _1088 = mad((WorkingColorSpace_128[1].z), _1062, mad((WorkingColorSpace_128[1].y), _1061, ((WorkingColorSpace_128[1].x) * _1060)));
      _1091 = mad((WorkingColorSpace_128[2].z), _1062, mad((WorkingColorSpace_128[2].y), _1061, ((WorkingColorSpace_128[2].x) * _1060)));
      _1102 = mad(_53, _1091, mad(_52, _1088, (_1085 * _51)));
      _1103 = mad(_56, _1091, mad(_55, _1088, (_1085 * _54)));
      _1104 = mad(_59, _1091, mad(_58, _1088, (_1085 * _57)));
    } else {
      _1102 = _1060;
      _1103 = _1061;
      _1104 = _1062;
    }
    if (_1102 < 0.0031306699384003878f) {
      _1115 = (_1102 * 12.920000076293945f);
    } else {
      _1115 = (((pow(_1102, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1103 < 0.0031306699384003878f) {
      _1126 = (_1103 * 12.920000076293945f);
    } else {
      _1126 = (((pow(_1103, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1104 < 0.0031306699384003878f) {
      _2677 = _1115;
      _2678 = _1126;
      _2679 = (_1104 * 12.920000076293945f);
    } else {
      _2677 = _1115;
      _2678 = _1126;
      _2679 = (((pow(_1104, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1153 = mad((WorkingColorSpace_128[0].z), _1062, mad((WorkingColorSpace_128[0].y), _1061, ((WorkingColorSpace_128[0].x) * _1060)));
      _1156 = mad((WorkingColorSpace_128[1].z), _1062, mad((WorkingColorSpace_128[1].y), _1061, ((WorkingColorSpace_128[1].x) * _1060)));
      _1159 = mad((WorkingColorSpace_128[2].z), _1062, mad((WorkingColorSpace_128[2].y), _1061, ((WorkingColorSpace_128[2].x) * _1060)));
      _1162 = mad(_53, _1159, mad(_52, _1156, (_1153 * _51)));
      _1165 = mad(_56, _1159, mad(_55, _1156, (_1153 * _54)));
      _1168 = mad(_59, _1159, mad(_58, _1156, (_1153 * _57)));
      _2677 = min((_1162 * 4.5f), ((exp2(log2(max(_1162, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2678 = min((_1165 * 4.5f), ((exp2(log2(max(_1165, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2679 = min((_1168 * 4.5f), ((exp2(log2(max(_1168, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        _1243 = cb0_012z * _1046;
        _1244 = cb0_012z * _1047;
        _1245 = cb0_012z * _1048;
        _1248 = mad((WorkingColorSpace_256[0].z), _1245, mad((WorkingColorSpace_256[0].y), _1244, ((WorkingColorSpace_256[0].x) * _1243)));
        _1251 = mad((WorkingColorSpace_256[1].z), _1245, mad((WorkingColorSpace_256[1].y), _1244, ((WorkingColorSpace_256[1].x) * _1243)));
        _1254 = mad((WorkingColorSpace_256[2].z), _1245, mad((WorkingColorSpace_256[2].y), _1244, ((WorkingColorSpace_256[2].x) * _1243)));
        _1257 = mad(-0.21492856740951538f, _1254, mad(-0.2365107536315918f, _1251, (_1248 * 1.4514392614364624f)));
        _1260 = mad(-0.09967592358589172f, _1254, mad(1.17622971534729f, _1251, (_1248 * -0.07655377686023712f)));
        _1263 = mad(0.9977163076400757f, _1254, mad(-0.006032449658960104f, _1251, (_1248 * 0.008316148072481155f)));
        _1265 = max(_1257, max(_1260, _1263));
        if (!(_1265 < 1.000000013351432e-10f)) {
          if (!(((_1248 < 0.0f) || (_1251 < 0.0f)) || (_1254 < 0.0f))) {
            _1275 = abs(_1265);
            _1276 = (_1265 - _1257) / _1275;
            _1278 = (_1265 - _1260) / _1275;
            _1280 = (_1265 - _1263) / _1275;
            if (!(_1276 < 0.8149999976158142f)) {
              _1283 = _1276 + -0.8149999976158142f;
              _1295 = ((_1283 / exp2(log2(exp2(log2(_1283 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1295 = _1276;
            }
            if (!(_1278 < 0.8029999732971191f)) {
              _1298 = _1278 + -0.8029999732971191f;
              _1310 = ((_1298 / exp2(log2(exp2(log2(_1298 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1310 = _1278;
            }
            if (!(_1280 < 0.8799999952316284f)) {
              _1313 = _1280 + -0.8799999952316284f;
              _1325 = ((_1313 / exp2(log2(exp2(log2(_1313 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1325 = _1280;
            }
            _1333 = (_1265 - (_1275 * _1295));
            _1334 = (_1265 - (_1275 * _1310));
            _1335 = (_1265 - (_1275 * _1325));
          } else {
            _1333 = _1257;
            _1334 = _1260;
            _1335 = _1263;
          }
        } else {
          _1333 = _1257;
          _1334 = _1260;
          _1335 = _1263;
        }
        _1351 = ((mad(0.16386906802654266f, _1335, mad(0.14067870378494263f, _1334, (_1333 * 0.6954522132873535f))) - _1248) * cb0_012w) + _1248;
        _1352 = ((mad(0.0955343171954155f, _1335, mad(0.8596711158752441f, _1334, (_1333 * 0.044794563204050064f))) - _1251) * cb0_012w) + _1251;
        _1353 = ((mad(1.0015007257461548f, _1335, mad(0.004025210160762072f, _1334, (_1333 * -0.005525882821530104f))) - _1254) * cb0_012w) + _1254;
        _1357 = max(max(_1351, _1352), _1353);
        _1362 = (max(_1357, 1.000000013351432e-10f) - max(min(min(_1351, _1352), _1353), 1.000000013351432e-10f)) / max(_1357, 0.009999999776482582f);
        _1375 = ((_1352 + _1351) + _1353) + (sqrt((((_1353 - _1352) * _1353) + ((_1352 - _1351) * _1352)) + ((_1351 - _1353) * _1351)) * 1.75f);
        _1376 = _1375 * 0.3333333432674408f;
        _1377 = _1362 + -0.4000000059604645f;
        _1378 = _1377 * 5.0f;
        _1382 = max((1.0f - abs(_1377 * 2.5f)), 0.0f);
        _1393 = ((float((int)(((int)(uint)((int)(_1378 > 0.0f))) - ((int)(uint)((int)(_1378 < 0.0f))))) * (1.0f - (_1382 * _1382))) + 1.0f) * 0.02500000037252903f;
        if (_1376 > 0.0533333346247673f) {
          if (_1376 < 0.1599999964237213f) {
            _1402 = (((0.23999999463558197f / _1375) + -0.5f) * _1393);
          } else {
            _1402 = 0.0f;
          }
        } else {
          _1402 = _1393;
        }
        _1403 = _1402 + 1.0f;
        _1404 = _1403 * _1351;
        _1405 = _1403 * _1352;
        _1406 = _1403 * _1353;
        if (!((_1404 == _1405) && (_1405 == _1406))) {
          _1413 = ((_1404 * 2.0f) - _1405) - _1406;
          _1416 = ((_1352 - _1353) * 1.7320507764816284f) * _1403;
          _1418 = atan(_1416 / _1413);
          _1421 = (_1413 < 0.0f);
          _1422 = (_1413 == 0.0f);
          _1423 = (_1416 >= 0.0f);
          _1424 = (_1416 < 0.0f);
          _1435 = select((_1423 && _1422), 90.0f, select((_1424 && _1422), -90.0f, (select((_1424 && _1421), (_1418 + -3.1415927410125732f), select((_1423 && _1421), (_1418 + 3.1415927410125732f), _1418)) * 57.2957763671875f)));
        } else {
          _1435 = 0.0f;
        }
        _1440 = min(max(select((_1435 < 0.0f), (_1435 + 360.0f), _1435), 0.0f), 360.0f);
        if (_1440 < -180.0f) {
          _1449 = (_1440 + 360.0f);
        } else {
          if (_1440 > 180.0f) {
            _1449 = (_1440 + -360.0f);
          } else {
            _1449 = _1440;
          }
        }
        if ((_1449 > -67.5f) && (_1449 < 67.5f)) {
          _1455 = (_1449 + 67.5f) * 0.029629629105329514f;
          _1456 = int(_1455);
          _1458 = _1455 - float((int)(_1456));
          _1459 = _1458 * _1458;
          _1460 = _1459 * _1458;
          if (_1456 == 3) {
            _1488 = (((0.1666666716337204f - (_1458 * 0.5f)) + (_1459 * 0.5f)) - (_1460 * 0.1666666716337204f));
          } else {
            if (_1456 == 2) {
              _1488 = ((0.6666666865348816f - _1459) + (_1460 * 0.5f));
            } else {
              if (_1456 == 1) {
                _1488 = (((_1460 * -0.5f) + 0.1666666716337204f) + ((_1459 + _1458) * 0.5f));
              } else {
                _1488 = select((_1456 == 0), (_1460 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1488 = 0.0f;
        }
        _1497 = min(max(((((_1362 * 0.27000001072883606f) * (0.029999999329447746f - _1404)) * _1488) + _1404), 0.0f), 65535.0f);
        _1498 = min(max(_1405, 0.0f), 65535.0f);
        _1499 = min(max(_1406, 0.0f), 65535.0f);
        _1512 = min(max(mad(-0.21492856740951538f, _1499, mad(-0.2365107536315918f, _1498, (_1497 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1513 = min(max(mad(-0.09967592358589172f, _1499, mad(1.17622971534729f, _1498, (_1497 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1514 = min(max(mad(0.9977163076400757f, _1499, mad(-0.006032449658960104f, _1498, (_1497 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1515 = dot(float3(_1512, _1513, _1514), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
        _1538 = log2(max((lerp(_1515, _1512, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1539 = _1538 * 0.3010300099849701f;
        _1540 = log2(cb0_008x);
        _1541 = _1540 * 0.3010300099849701f;
        if (_1539 > _1541) {
          _1548 = log2(cb0_009x);
          _1549 = _1548 * 0.3010300099849701f;
          if ((_1539 > _1541) && (_1539 < _1549)) {
            _1557 = ((_1538 - _1540) * 0.9030900001525879f) / ((_1548 - _1540) * 0.3010300099849701f);
            _1558 = int(_1557);
            _1560 = _1557 - float((int)(_1558));
            _1562 = _16[min((uint)(_1558), 5u)];
            _1565 = _16[min((uint)((_1558 + 1)), 5u)];
            _1570 = _1562 * 0.5f;
            _1610 = dot(float3((_1560 * _1560), _1560, 1.0f), float3(mad((_16[min((uint)((_1558 + 2)), 5u)]), 0.5f, mad(_1565, -1.0f, _1570)), (_1565 - _1562), mad(_1565, 0.5f, _1570)));
          } else {
            if (_1539 < _1549) {
              _1610 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1579 = log2(cb0_008z);
              if (!(_1539 < (_1579 * 0.3010300099849701f))) {
                _1610 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1587 = ((_1538 - _1548) * 0.9030900001525879f) / ((_1579 - _1548) * 0.3010300099849701f);
                _1588 = int(_1587);
                _1590 = _1587 - float((int)(_1588));
                _1592 = _17[min((uint)(_1588), 5u)];
                _1595 = _17[min((uint)((_1588 + 1)), 5u)];
                _1600 = _1592 * 0.5f;
                _1610 = dot(float3((_1590 * _1590), _1590, 1.0f), float3(mad((_17[min((uint)((_1588 + 2)), 5u)]), 0.5f, mad(_1595, -1.0f, _1600)), (_1595 - _1592), mad(_1595, 0.5f, _1600)));
              }
            }
          }
        } else {
          _1610 = (log2(cb0_008y) * 0.3010300099849701f);
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
        _1626 = log2(max((lerp(_1515, _1513, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1627 = _1626 * 0.3010300099849701f;
        if (_1627 > _1541) {
          _1634 = log2(cb0_009x);
          _1635 = _1634 * 0.3010300099849701f;
          if ((_1627 > _1541) && (_1627 < _1635)) {
            _1643 = ((_1626 - _1540) * 0.9030900001525879f) / ((_1634 - _1540) * 0.3010300099849701f);
            _1644 = int(_1643);
            _1646 = _1643 - float((int)(_1644));
            _1648 = _18[min((uint)(_1644), 5u)];
            _1651 = _18[min((uint)((_1644 + 1)), 5u)];
            _1656 = _1648 * 0.5f;
            _1696 = dot(float3((_1646 * _1646), _1646, 1.0f), float3(mad((_18[min((uint)((_1644 + 2)), 5u)]), 0.5f, mad(_1651, -1.0f, _1656)), (_1651 - _1648), mad(_1651, 0.5f, _1656)));
          } else {
            if (_1627 < _1635) {
              _1696 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1665 = log2(cb0_008z);
              if (!(_1627 < (_1665 * 0.3010300099849701f))) {
                _1696 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1673 = ((_1626 - _1634) * 0.9030900001525879f) / ((_1665 - _1634) * 0.3010300099849701f);
                _1674 = int(_1673);
                _1676 = _1673 - float((int)(_1674));
                _1678 = _19[min((uint)(_1674), 5u)];
                _1681 = _19[min((uint)((_1674 + 1)), 5u)];
                _1686 = _1678 * 0.5f;
                _1696 = dot(float3((_1676 * _1676), _1676, 1.0f), float3(mad((_19[min((uint)((_1674 + 2)), 5u)]), 0.5f, mad(_1681, -1.0f, _1686)), (_1681 - _1678), mad(_1681, 0.5f, _1686)));
              }
            }
          }
        } else {
          _1696 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1700 = log2(max((lerp(_1515, _1514, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1701 = _1700 * 0.3010300099849701f;
        if (_1701 > _1541) {
          _1708 = log2(cb0_009x);
          _1709 = _1708 * 0.3010300099849701f;
          if ((_1701 > _1541) && (_1701 < _1709)) {
            _1717 = ((_1700 - _1540) * 0.9030900001525879f) / ((_1708 - _1540) * 0.3010300099849701f);
            _1718 = int(_1717);
            _1720 = _1717 - float((int)(_1718));
            _1722 = _8[min((uint)(_1718), 5u)];
            _1725 = _8[min((uint)((_1718 + 1)), 5u)];
            _1730 = _1722 * 0.5f;
            _1770 = dot(float3((_1720 * _1720), _1720, 1.0f), float3(mad((_8[min((uint)((_1718 + 2)), 5u)]), 0.5f, mad(_1725, -1.0f, _1730)), (_1725 - _1722), mad(_1725, 0.5f, _1730)));
          } else {
            if (_1701 < _1709) {
              _1770 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1739 = log2(cb0_008z);
              if (!(_1701 < (_1739 * 0.3010300099849701f))) {
                _1770 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1747 = ((_1700 - _1708) * 0.9030900001525879f) / ((_1739 - _1708) * 0.3010300099849701f);
                _1748 = int(_1747);
                _1750 = _1747 - float((int)(_1748));
                _1752 = _9[min((uint)(_1748), 5u)];
                _1755 = _9[min((uint)((_1748 + 1)), 5u)];
                _1760 = _1752 * 0.5f;
                _1770 = dot(float3((_1750 * _1750), _1750, 1.0f), float3(mad((_9[min((uint)((_1748 + 2)), 5u)]), 0.5f, mad(_1755, -1.0f, _1760)), (_1755 - _1752), mad(_1755, 0.5f, _1760)));
              }
            }
          }
        } else {
          _1770 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1774 = cb0_008w - cb0_008y;
        _1775 = (exp2(_1610 * 3.321928024291992f) - cb0_008y) / _1774;
        _1777 = (exp2(_1696 * 3.321928024291992f) - cb0_008y) / _1774;
        _1779 = (exp2(_1770 * 3.321928024291992f) - cb0_008y) / _1774;
        _1782 = mad(0.15618768334388733f, _1779, mad(0.13400420546531677f, _1777, (_1775 * 0.6624541878700256f)));
        _1785 = mad(0.053689517080783844f, _1779, mad(0.6740817427635193f, _1777, (_1775 * 0.2722287178039551f)));
        _1788 = mad(1.0103391408920288f, _1779, mad(0.00406073359772563f, _1777, (_1775 * -0.005574649665504694f)));
        _1801 = min(max(mad(-0.23642469942569733f, _1788, mad(-0.32480329275131226f, _1785, (_1782 * 1.6410233974456787f))), 0.0f), 1.0f);
        _1802 = min(max(mad(0.016756348311901093f, _1788, mad(1.6153316497802734f, _1785, (_1782 * -0.663662850856781f))), 0.0f), 1.0f);
        _1803 = min(max(mad(0.9883948564529419f, _1788, mad(-0.008284442126750946f, _1785, (_1782 * 0.011721894145011902f))), 0.0f), 1.0f);
        _1806 = mad(0.15618768334388733f, _1803, mad(0.13400420546531677f, _1802, (_1801 * 0.6624541878700256f)));
        _1809 = mad(0.053689517080783844f, _1803, mad(0.6740817427635193f, _1802, (_1801 * 0.2722287178039551f)));
        _1812 = mad(1.0103391408920288f, _1803, mad(0.00406073359772563f, _1802, (_1801 * -0.005574649665504694f)));
        _1834 = min(max((min(max(mad(-0.23642469942569733f, _1812, mad(-0.32480329275131226f, _1809, (_1806 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _1835 = min(max((min(max(mad(0.016756348311901093f, _1812, mad(1.6153316497802734f, _1809, (_1806 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _1836 = min(max((min(max(mad(0.9883948564529419f, _1812, mad(-0.008284442126750946f, _1809, (_1806 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _1855 = exp2(log2(mad(_53, _1836, mad(_52, _1835, (_1834 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _1856 = exp2(log2(mad(_56, _1836, mad(_55, _1835, (_1834 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _1857 = exp2(log2(mad(_59, _1836, mad(_58, _1835, (_1834 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2677 = exp2(log2((1.0f / ((_1855 * 18.6875f) + 1.0f)) * ((_1855 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2678 = exp2(log2((1.0f / ((_1856 * 18.6875f) + 1.0f)) * ((_1856 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2679 = exp2(log2((1.0f / ((_1857 * 18.6875f) + 1.0f)) * ((_1857 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _1923 = cb0_012z * _1046;
          _1924 = cb0_012z * _1047;
          _1925 = cb0_012z * _1048;
          _1928 = mad((WorkingColorSpace_256[0].z), _1925, mad((WorkingColorSpace_256[0].y), _1924, ((WorkingColorSpace_256[0].x) * _1923)));
          _1931 = mad((WorkingColorSpace_256[1].z), _1925, mad((WorkingColorSpace_256[1].y), _1924, ((WorkingColorSpace_256[1].x) * _1923)));
          _1934 = mad((WorkingColorSpace_256[2].z), _1925, mad((WorkingColorSpace_256[2].y), _1924, ((WorkingColorSpace_256[2].x) * _1923)));
          _1937 = mad(-0.21492856740951538f, _1934, mad(-0.2365107536315918f, _1931, (_1928 * 1.4514392614364624f)));
          _1940 = mad(-0.09967592358589172f, _1934, mad(1.17622971534729f, _1931, (_1928 * -0.07655377686023712f)));
          _1943 = mad(0.9977163076400757f, _1934, mad(-0.006032449658960104f, _1931, (_1928 * 0.008316148072481155f)));
          _1945 = max(_1937, max(_1940, _1943));
          if (!(_1945 < 1.000000013351432e-10f)) {
            if (!(((_1928 < 0.0f) || (_1931 < 0.0f)) || (_1934 < 0.0f))) {
              _1955 = abs(_1945);
              _1956 = (_1945 - _1937) / _1955;
              _1958 = (_1945 - _1940) / _1955;
              _1960 = (_1945 - _1943) / _1955;
              if (!(_1956 < 0.8149999976158142f)) {
                _1963 = _1956 + -0.8149999976158142f;
                _1975 = ((_1963 / exp2(log2(exp2(log2(_1963 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _1975 = _1956;
              }
              if (!(_1958 < 0.8029999732971191f)) {
                _1978 = _1958 + -0.8029999732971191f;
                _1990 = ((_1978 / exp2(log2(exp2(log2(_1978 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _1990 = _1958;
              }
              if (!(_1960 < 0.8799999952316284f)) {
                _1993 = _1960 + -0.8799999952316284f;
                _2005 = ((_1993 / exp2(log2(exp2(log2(_1993 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2005 = _1960;
              }
              _2013 = (_1945 - (_1955 * _1975));
              _2014 = (_1945 - (_1955 * _1990));
              _2015 = (_1945 - (_1955 * _2005));
            } else {
              _2013 = _1937;
              _2014 = _1940;
              _2015 = _1943;
            }
          } else {
            _2013 = _1937;
            _2014 = _1940;
            _2015 = _1943;
          }
          _2031 = ((mad(0.16386906802654266f, _2015, mad(0.14067870378494263f, _2014, (_2013 * 0.6954522132873535f))) - _1928) * cb0_012w) + _1928;
          _2032 = ((mad(0.0955343171954155f, _2015, mad(0.8596711158752441f, _2014, (_2013 * 0.044794563204050064f))) - _1931) * cb0_012w) + _1931;
          _2033 = ((mad(1.0015007257461548f, _2015, mad(0.004025210160762072f, _2014, (_2013 * -0.005525882821530104f))) - _1934) * cb0_012w) + _1934;
          _2037 = max(max(_2031, _2032), _2033);
          _2042 = (max(_2037, 1.000000013351432e-10f) - max(min(min(_2031, _2032), _2033), 1.000000013351432e-10f)) / max(_2037, 0.009999999776482582f);
          _2055 = ((_2032 + _2031) + _2033) + (sqrt((((_2033 - _2032) * _2033) + ((_2032 - _2031) * _2032)) + ((_2031 - _2033) * _2031)) * 1.75f);
          _2056 = _2055 * 0.3333333432674408f;
          _2057 = _2042 + -0.4000000059604645f;
          _2058 = _2057 * 5.0f;
          _2062 = max((1.0f - abs(_2057 * 2.5f)), 0.0f);
          _2073 = ((float((int)(((int)(uint)((int)(_2058 > 0.0f))) - ((int)(uint)((int)(_2058 < 0.0f))))) * (1.0f - (_2062 * _2062))) + 1.0f) * 0.02500000037252903f;
          if (_2056 > 0.0533333346247673f) {
            if (_2056 < 0.1599999964237213f) {
              _2082 = (((0.23999999463558197f / _2055) + -0.5f) * _2073);
            } else {
              _2082 = 0.0f;
            }
          } else {
            _2082 = _2073;
          }
          _2083 = _2082 + 1.0f;
          _2084 = _2083 * _2031;
          _2085 = _2083 * _2032;
          _2086 = _2083 * _2033;
          if (!((_2084 == _2085) && (_2085 == _2086))) {
            _2093 = ((_2084 * 2.0f) - _2085) - _2086;
            _2096 = ((_2032 - _2033) * 1.7320507764816284f) * _2083;
            _2098 = atan(_2096 / _2093);
            _2101 = (_2093 < 0.0f);
            _2102 = (_2093 == 0.0f);
            _2103 = (_2096 >= 0.0f);
            _2104 = (_2096 < 0.0f);
            _2115 = select((_2103 && _2102), 90.0f, select((_2104 && _2102), -90.0f, (select((_2104 && _2101), (_2098 + -3.1415927410125732f), select((_2103 && _2101), (_2098 + 3.1415927410125732f), _2098)) * 57.2957763671875f)));
          } else {
            _2115 = 0.0f;
          }
          _2120 = min(max(select((_2115 < 0.0f), (_2115 + 360.0f), _2115), 0.0f), 360.0f);
          if (_2120 < -180.0f) {
            _2129 = (_2120 + 360.0f);
          } else {
            if (_2120 > 180.0f) {
              _2129 = (_2120 + -360.0f);
            } else {
              _2129 = _2120;
            }
          }
          if ((_2129 > -67.5f) && (_2129 < 67.5f)) {
            _2135 = (_2129 + 67.5f) * 0.029629629105329514f;
            _2136 = int(_2135);
            _2138 = _2135 - float((int)(_2136));
            _2139 = _2138 * _2138;
            _2140 = _2139 * _2138;
            if (_2136 == 3) {
              _2168 = (((0.1666666716337204f - (_2138 * 0.5f)) + (_2139 * 0.5f)) - (_2140 * 0.1666666716337204f));
            } else {
              if (_2136 == 2) {
                _2168 = ((0.6666666865348816f - _2139) + (_2140 * 0.5f));
              } else {
                if (_2136 == 1) {
                  _2168 = (((_2140 * -0.5f) + 0.1666666716337204f) + ((_2139 + _2138) * 0.5f));
                } else {
                  _2168 = select((_2136 == 0), (_2140 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2168 = 0.0f;
          }
          _2177 = min(max(((((_2042 * 0.27000001072883606f) * (0.029999999329447746f - _2084)) * _2168) + _2084), 0.0f), 65535.0f);
          _2178 = min(max(_2085, 0.0f), 65535.0f);
          _2179 = min(max(_2086, 0.0f), 65535.0f);
          _2192 = min(max(mad(-0.21492856740951538f, _2179, mad(-0.2365107536315918f, _2178, (_2177 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2193 = min(max(mad(-0.09967592358589172f, _2179, mad(1.17622971534729f, _2178, (_2177 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2194 = min(max(mad(0.9977163076400757f, _2179, mad(-0.006032449658960104f, _2178, (_2177 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2195 = dot(float3(_2192, _2193, _2194), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
          _2218 = log2(max((lerp(_2195, _2192, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2219 = _2218 * 0.3010300099849701f;
          _2220 = log2(cb0_008x);
          _2221 = _2220 * 0.3010300099849701f;
          if (_2219 > _2221) {
            _2228 = log2(cb0_009x);
            _2229 = _2228 * 0.3010300099849701f;
            if ((_2219 > _2221) && (_2219 < _2229)) {
              _2237 = ((_2218 - _2220) * 0.9030900001525879f) / ((_2228 - _2220) * 0.3010300099849701f);
              _2238 = int(_2237);
              _2240 = _2237 - float((int)(_2238));
              _2242 = _14[min((uint)(_2238), 5u)];
              _2245 = _14[min((uint)((_2238 + 1)), 5u)];
              _2250 = _2242 * 0.5f;
              _2290 = dot(float3((_2240 * _2240), _2240, 1.0f), float3(mad((_14[min((uint)((_2238 + 2)), 5u)]), 0.5f, mad(_2245, -1.0f, _2250)), (_2245 - _2242), mad(_2245, 0.5f, _2250)));
            } else {
              if (_2219 < _2229) {
                _2290 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2259 = log2(cb0_008z);
                if (!(_2219 < (_2259 * 0.3010300099849701f))) {
                  _2290 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2267 = ((_2218 - _2228) * 0.9030900001525879f) / ((_2259 - _2228) * 0.3010300099849701f);
                  _2268 = int(_2267);
                  _2270 = _2267 - float((int)(_2268));
                  _2272 = _15[min((uint)(_2268), 5u)];
                  _2275 = _15[min((uint)((_2268 + 1)), 5u)];
                  _2280 = _2272 * 0.5f;
                  _2290 = dot(float3((_2270 * _2270), _2270, 1.0f), float3(mad((_15[min((uint)((_2268 + 2)), 5u)]), 0.5f, mad(_2275, -1.0f, _2280)), (_2275 - _2272), mad(_2275, 0.5f, _2280)));
                }
              }
            }
          } else {
            _2290 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2306 = log2(max((lerp(_2195, _2193, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2307 = _2306 * 0.3010300099849701f;
          if (_2307 > _2221) {
            _2314 = log2(cb0_009x);
            _2315 = _2314 * 0.3010300099849701f;
            if ((_2307 > _2221) && (_2307 < _2315)) {
              _2323 = ((_2306 - _2220) * 0.9030900001525879f) / ((_2314 - _2220) * 0.3010300099849701f);
              _2324 = int(_2323);
              _2326 = _2323 - float((int)(_2324));
              _2328 = _10[min((uint)(_2324), 5u)];
              _2331 = _10[min((uint)((_2324 + 1)), 5u)];
              _2336 = _2328 * 0.5f;
              _2376 = dot(float3((_2326 * _2326), _2326, 1.0f), float3(mad((_10[min((uint)((_2324 + 2)), 5u)]), 0.5f, mad(_2331, -1.0f, _2336)), (_2331 - _2328), mad(_2331, 0.5f, _2336)));
            } else {
              if (_2307 < _2315) {
                _2376 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2345 = log2(cb0_008z);
                if (!(_2307 < (_2345 * 0.3010300099849701f))) {
                  _2376 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2353 = ((_2306 - _2314) * 0.9030900001525879f) / ((_2345 - _2314) * 0.3010300099849701f);
                  _2354 = int(_2353);
                  _2356 = _2353 - float((int)(_2354));
                  _2358 = _11[min((uint)(_2354), 5u)];
                  _2361 = _11[min((uint)((_2354 + 1)), 5u)];
                  _2366 = _2358 * 0.5f;
                  _2376 = dot(float3((_2356 * _2356), _2356, 1.0f), float3(mad((_11[min((uint)((_2354 + 2)), 5u)]), 0.5f, mad(_2361, -1.0f, _2366)), (_2361 - _2358), mad(_2361, 0.5f, _2366)));
                }
              }
            }
          } else {
            _2376 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2392 = log2(max((lerp(_2195, _2194, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2393 = _2392 * 0.3010300099849701f;
          if (_2393 > _2221) {
            _2400 = log2(cb0_009x);
            _2401 = _2400 * 0.3010300099849701f;
            if ((_2393 > _2221) && (_2393 < _2401)) {
              _2409 = ((_2392 - _2220) * 0.9030900001525879f) / ((_2400 - _2220) * 0.3010300099849701f);
              _2410 = int(_2409);
              _2412 = _2409 - float((int)(_2410));
              _2414 = _12[min((uint)(_2410), 5u)];
              _2417 = _12[min((uint)((_2410 + 1)), 5u)];
              _2422 = _2414 * 0.5f;
              _2462 = dot(float3((_2412 * _2412), _2412, 1.0f), float3(mad((_12[min((uint)((_2410 + 2)), 5u)]), 0.5f, mad(_2417, -1.0f, _2422)), (_2417 - _2414), mad(_2417, 0.5f, _2422)));
            } else {
              if (_2393 < _2401) {
                _2462 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2431 = log2(cb0_008z);
                if (!(_2393 < (_2431 * 0.3010300099849701f))) {
                  _2462 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2439 = ((_2392 - _2400) * 0.9030900001525879f) / ((_2431 - _2400) * 0.3010300099849701f);
                  _2440 = int(_2439);
                  _2442 = _2439 - float((int)(_2440));
                  _2444 = _13[min((uint)(_2440), 5u)];
                  _2447 = _13[min((uint)((_2440 + 1)), 5u)];
                  _2452 = _2444 * 0.5f;
                  _2462 = dot(float3((_2442 * _2442), _2442, 1.0f), float3(mad((_13[min((uint)((_2440 + 2)), 5u)]), 0.5f, mad(_2447, -1.0f, _2452)), (_2447 - _2444), mad(_2447, 0.5f, _2452)));
                }
              }
            }
          } else {
            _2462 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2466 = cb0_008w - cb0_008y;
          _2467 = (exp2(_2290 * 3.321928024291992f) - cb0_008y) / _2466;
          _2469 = (exp2(_2376 * 3.321928024291992f) - cb0_008y) / _2466;
          _2471 = (exp2(_2462 * 3.321928024291992f) - cb0_008y) / _2466;
          _2474 = mad(0.15618768334388733f, _2471, mad(0.13400420546531677f, _2469, (_2467 * 0.6624541878700256f)));
          _2477 = mad(0.053689517080783844f, _2471, mad(0.6740817427635193f, _2469, (_2467 * 0.2722287178039551f)));
          _2480 = mad(1.0103391408920288f, _2471, mad(0.00406073359772563f, _2469, (_2467 * -0.005574649665504694f)));
          _2493 = min(max(mad(-0.23642469942569733f, _2480, mad(-0.32480329275131226f, _2477, (_2474 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2494 = min(max(mad(0.016756348311901093f, _2480, mad(1.6153316497802734f, _2477, (_2474 * -0.663662850856781f))), 0.0f), 1.0f);
          _2495 = min(max(mad(0.9883948564529419f, _2480, mad(-0.008284442126750946f, _2477, (_2474 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2498 = mad(0.15618768334388733f, _2495, mad(0.13400420546531677f, _2494, (_2493 * 0.6624541878700256f)));
          _2501 = mad(0.053689517080783844f, _2495, mad(0.6740817427635193f, _2494, (_2493 * 0.2722287178039551f)));
          _2504 = mad(1.0103391408920288f, _2495, mad(0.00406073359772563f, _2494, (_2493 * -0.005574649665504694f)));
          _2526 = min(max((min(max(mad(-0.23642469942569733f, _2504, mad(-0.32480329275131226f, _2501, (_2498 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2529 = min(max((min(max(mad(0.016756348311901093f, _2504, mad(1.6153316497802734f, _2501, (_2498 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2530 = min(max((min(max(mad(0.9883948564529419f, _2504, mad(-0.008284442126750946f, _2501, (_2498 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2677 = mad(-0.0832589864730835f, _2530, mad(-0.6217921376228333f, _2529, (_2526 * 0.0213131383061409f)));
          _2678 = mad(-0.010548308491706848f, _2530, mad(1.140804648399353f, _2529, (_2526 * -0.0016282059950754046f)));
          _2679 = mad(1.1529725790023804f, _2530, mad(-0.1289689838886261f, _2529, (_2526 * -0.00030004189466126263f)));
        } else {
          if (cb0_042w == 7) {
            _2557 = mad((WorkingColorSpace_128[0].z), _1048, mad((WorkingColorSpace_128[0].y), _1047, ((WorkingColorSpace_128[0].x) * _1046)));
            _2560 = mad((WorkingColorSpace_128[1].z), _1048, mad((WorkingColorSpace_128[1].y), _1047, ((WorkingColorSpace_128[1].x) * _1046)));
            _2563 = mad((WorkingColorSpace_128[2].z), _1048, mad((WorkingColorSpace_128[2].y), _1047, ((WorkingColorSpace_128[2].x) * _1046)));
            _2582 = exp2(log2(mad(_53, _2563, mad(_52, _2560, (_2557 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2583 = exp2(log2(mad(_56, _2563, mad(_55, _2560, (_2557 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2584 = exp2(log2(mad(_59, _2563, mad(_58, _2560, (_2557 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2677 = exp2(log2((1.0f / ((_2582 * 18.6875f) + 1.0f)) * ((_2582 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2678 = exp2(log2((1.0f / ((_2583 * 18.6875f) + 1.0f)) * ((_2583 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2679 = exp2(log2((1.0f / ((_2584 * 18.6875f) + 1.0f)) * ((_2584 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _2631 = mad((WorkingColorSpace_128[0].z), _1036, mad((WorkingColorSpace_128[0].y), _1035, ((WorkingColorSpace_128[0].x) * _1034)));
                _2634 = mad((WorkingColorSpace_128[1].z), _1036, mad((WorkingColorSpace_128[1].y), _1035, ((WorkingColorSpace_128[1].x) * _1034)));
                _2637 = mad((WorkingColorSpace_128[2].z), _1036, mad((WorkingColorSpace_128[2].y), _1035, ((WorkingColorSpace_128[2].x) * _1034)));
                _2677 = mad(_53, _2637, mad(_52, _2634, (_2631 * _51)));
                _2678 = mad(_56, _2637, mad(_55, _2634, (_2631 * _54)));
                _2679 = mad(_59, _2637, mad(_58, _2634, (_2631 * _57)));
              } else {
                _2650 = mad((WorkingColorSpace_128[0].z), _1062, mad((WorkingColorSpace_128[0].y), _1061, ((WorkingColorSpace_128[0].x) * _1060)));
                _2653 = mad((WorkingColorSpace_128[1].z), _1062, mad((WorkingColorSpace_128[1].y), _1061, ((WorkingColorSpace_128[1].x) * _1060)));
                _2656 = mad((WorkingColorSpace_128[2].z), _1062, mad((WorkingColorSpace_128[2].y), _1061, ((WorkingColorSpace_128[2].x) * _1060)));
                _2677 = exp2(log2(mad(_53, _2656, mad(_52, _2653, (_2650 * _51)))) * cb0_042z);
                _2678 = exp2(log2(mad(_56, _2656, mad(_55, _2653, (_2650 * _54)))) * cb0_042z);
                _2679 = exp2(log2(mad(_59, _2656, mad(_58, _2653, (_2650 * _57)))) * cb0_042z);
              }
            } else {
              _2677 = _1046;
              _2678 = _1047;
              _2679 = _1048;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2677 * 0.9523810148239136f);
  SV_Target.y = (_2678 * 0.9523810148239136f);
  SV_Target.z = (_2679 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
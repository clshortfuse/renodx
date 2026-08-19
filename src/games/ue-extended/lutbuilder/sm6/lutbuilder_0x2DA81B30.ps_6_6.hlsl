// Directive 8020

#include "../lutbuilderoutput.hlsli"

Texture3D<float4> t0 : register(t0);

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
  int cb0_042x : packoffset(c042.x);
  int cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
};

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  int WorkingColorSpace_320 : packoffset(c020.x);
};

SamplerState s0 : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  precise noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _24;
  float _29;
  float _30;
  float _31;
  float _33;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _119;
  float _120;
  float _121;
  float _169;
  float _815;
  float _825;
  float _835;
  float _912;
  float _913;
  float _914;
  float _924;
  float _934;
  float _944;
  float _952;
  float _953;
  float _954;
  float _1051;
  float _1084;
  float _1098;
  float _1162;
  float _1430;
  float _1431;
  float _1432;
  float _1443;
  float _1454;
  float _1627;
  float _1642;
  float _1657;
  float _1665;
  float _1666;
  float _1667;
  float _1734;
  float _1767;
  float _1781;
  float _1820;
  float _1942;
  float _2028;
  float _2102;
  float _2181;
  float _2182;
  float _2183;
  float _2313;
  float _2328;
  float _2343;
  float _2351;
  float _2352;
  float _2353;
  float _2420;
  float _2453;
  float _2467;
  float _2506;
  float _2628;
  float _2714;
  float _2800;
  float _2879;
  float _2880;
  float _2881;
  float _3058;
  float _3059;
  float _3060;
  bool _42;
  float _72;
  float _73;
  float _74;
  bool _148;
  float _152;
  float _183;
  float _190;
  float _193;
  float _198;
  float _199;
  float _201;
  bool _202;
  float _211;
  float _213;
  float _220;
  float _222;
  float _224;
  float _225;
  float _228;
  float _231;
  float _236;
  float _242;
  float _243;
  float _244;
  float _245;
  float _246;
  float _247;
  float _248;
  float _249;
  float _252;
  float _253;
  float _254;
  float _257;
  float _276;
  float _277;
  float _278;
  float _279;
  float _280;
  float _281;
  float _282;
  float _283;
  float _284;
  float _287;
  float _290;
  float _293;
  float _296;
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
  float _368;
  float _371;
  float _374;
  float _389;
  float _392;
  float _395;
  float _396;
  float _400;
  float _401;
  float _402;
  float _414;
  float _430;
  float _431;
  float _432;
  float _433;
  float _447;
  float _461;
  float _475;
  float _489;
  float _503;
  float _507;
  float _508;
  float _509;
  float _566;
  float _570;
  float _571;
  float _580;
  float _589;
  float _598;
  float _607;
  float _616;
  float _679;
  float _683;
  float _692;
  float _701;
  float _710;
  float _719;
  float _728;
  float _786;
  float _797;
  float _799;
  float _801;
  float _839;
  float _840;
  float _841;
  float4 _846;
  float4 _854;
  float4 _859;
  float4 _864;
  float _880;
  float _881;
  float _882;
  float _883;
  float _884;
  float _885;
  float _886;
  float _904;
  float _991;
  float _992;
  float _993;
  float _996;
  float _999;
  float _1002;
  float _1006;
  float _1011;
  float _1024;
  float _1025;
  float _1026;
  float _1027;
  float _1031;
  float _1042;
  float _1052;
  float _1053;
  float _1054;
  float _1055;
  float _1062;
  float _1065;
  float _1067;
  bool _1070;
  bool _1071;
  bool _1072;
  bool _1073;
  float _1089;
  float _1102;
  float _1106;
  float _1112;
  float _1122;
  float _1123;
  float _1124;
  float _1125;
  float _1140;
  float _1142;
  float _1144;
  float _1153;
  float _1165;
  float _1167;
  float _1171;
  float _1172;
  float _1173;
  float _1177;
  float _1178;
  float _1179;
  float _1180;
  float _1182;
  float _1183;
  float _1184;
  float _1185;
  float _1204;
  float _1206;
  float _1231;
  float _1232;
  float _1233;
  float _1240;
  float _1244;
  float _1245;
  float _1246;
  bool _1247;
  float _1251;
  float _1252;
  float _1253;
  float _1272;
  float _1273;
  float _1274;
  float _1275;
  float _1295;
  float _1296;
  float _1297;
  float _1313;
  float _1314;
  float _1315;
  float _1325;
  float _1326;
  float _1327;
  float _1353;
  float _1354;
  float _1355;
  float _1362;
  float _1363;
  float _1364;
  float _1365;
  float _1366;
  float _1367;
  float _1374;
  float _1375;
  float _1376;
  float _1388;
  float _1389;
  float _1390;
  float _1413;
  float _1416;
  float _1419;
  float _1481;
  float _1484;
  float _1487;
  float _1497;
  float _1498;
  float _1499;
  float _1575;
  float _1576;
  float _1577;
  float _1580;
  float _1583;
  float _1586;
  float _1589;
  float _1592;
  float _1595;
  float _1597;
  float _1607;
  float _1608;
  float _1610;
  float _1612;
  float _1615;
  float _1630;
  float _1645;
  float _1683;
  float _1684;
  float _1685;
  float _1689;
  float _1694;
  float _1707;
  float _1708;
  float _1709;
  float _1710;
  float _1714;
  float _1725;
  float _1735;
  float _1736;
  float _1737;
  float _1738;
  float _1745;
  float _1748;
  float _1750;
  bool _1753;
  bool _1754;
  bool _1755;
  bool _1756;
  float _1772;
  float _1787;
  int _1788;
  float _1790;
  float _1791;
  float _1792;
  float _1829;
  float _1830;
  float _1831;
  float _1844;
  float _1845;
  float _1846;
  float _1847;
  float _1870;
  float _1871;
  float _1872;
  float _1873;
  float _1880;
  float _1881;
  float _1889;
  int _1890;
  float _1892;
  float _1894;
  float _1897;
  float _1902;
  float _1911;
  float _1919;
  int _1920;
  float _1922;
  float _1924;
  float _1927;
  float _1932;
  float _1958;
  float _1959;
  float _1966;
  float _1967;
  float _1975;
  int _1976;
  float _1978;
  float _1980;
  float _1983;
  float _1988;
  float _1997;
  float _2005;
  int _2006;
  float _2008;
  float _2010;
  float _2013;
  float _2018;
  float _2032;
  float _2033;
  float _2040;
  float _2041;
  float _2049;
  int _2050;
  float _2052;
  float _2054;
  float _2057;
  float _2062;
  float _2071;
  float _2079;
  int _2080;
  float _2082;
  float _2084;
  float _2087;
  float _2092;
  float _2106;
  float _2107;
  float _2109;
  float _2111;
  float _2114;
  float _2117;
  float _2120;
  float _2133;
  float _2134;
  float _2135;
  float _2138;
  float _2141;
  float _2144;
  float _2166;
  float _2167;
  float _2168;
  float _2193;
  float _2194;
  float _2195;
  float _2261;
  float _2262;
  float _2263;
  float _2266;
  float _2269;
  float _2272;
  float _2275;
  float _2278;
  float _2281;
  float _2283;
  float _2293;
  float _2294;
  float _2296;
  float _2298;
  float _2301;
  float _2316;
  float _2331;
  float _2369;
  float _2370;
  float _2371;
  float _2375;
  float _2380;
  float _2393;
  float _2394;
  float _2395;
  float _2396;
  float _2400;
  float _2411;
  float _2421;
  float _2422;
  float _2423;
  float _2424;
  float _2431;
  float _2434;
  float _2436;
  bool _2439;
  bool _2440;
  bool _2441;
  bool _2442;
  float _2458;
  float _2473;
  int _2474;
  float _2476;
  float _2477;
  float _2478;
  float _2515;
  float _2516;
  float _2517;
  float _2530;
  float _2531;
  float _2532;
  float _2533;
  float _2556;
  float _2557;
  float _2558;
  float _2559;
  float _2566;
  float _2567;
  float _2575;
  int _2576;
  float _2578;
  float _2580;
  float _2583;
  float _2588;
  float _2597;
  float _2605;
  int _2606;
  float _2608;
  float _2610;
  float _2613;
  float _2618;
  float _2644;
  float _2645;
  float _2652;
  float _2653;
  float _2661;
  int _2662;
  float _2664;
  float _2666;
  float _2669;
  float _2674;
  float _2683;
  float _2691;
  int _2692;
  float _2694;
  float _2696;
  float _2699;
  float _2704;
  float _2730;
  float _2731;
  float _2738;
  float _2739;
  float _2747;
  int _2748;
  float _2750;
  float _2752;
  float _2755;
  float _2760;
  float _2769;
  float _2777;
  int _2778;
  float _2780;
  float _2782;
  float _2785;
  float _2790;
  float _2804;
  float _2805;
  float _2807;
  float _2809;
  float _2812;
  float _2815;
  float _2818;
  float _2831;
  float _2832;
  float _2833;
  float _2836;
  float _2839;
  float _2842;
  float _2864;
  float _2865;
  float _2866;
  float _2891;
  float _2892;
  float _2893;
  float _2938;
  float _2941;
  float _2944;
  float _2963;
  float _2964;
  float _2965;
  float _3012;
  float _3015;
  float _3018;
  float _3031;
  float _3034;
  float _3037;
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
  float _21[6];
  _24 = 0.5f / cb0_035x;
  _29 = cb0_035x + -1.0f;
  _30 = (cb0_035x * (TEXCOORD.x - _24)) / _29;
  _31 = (cb0_035x * (TEXCOORD.y - _24)) / _29;
  _33 = float((uint)(uint)(SV_RenderTargetArrayIndex)) / _29;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        _42 = (cb0_041x == 4);
        _53 = select(_42, 1.0f, 1.705051064491272f);
        _54 = select(_42, 0.0f, -0.6217921376228333f);
        _55 = select(_42, 0.0f, -0.0832589864730835f);
        _56 = select(_42, 0.0f, -0.13025647401809692f);
        _57 = select(_42, 1.0f, 1.140804648399353f);
        _58 = select(_42, 0.0f, -0.010548308491706848f);
        _59 = select(_42, 0.0f, -0.024003351107239723f);
        _60 = select(_42, 0.0f, -0.1289689838886261f);
        _61 = select(_42, 1.0f, 1.1529725790023804f);
      } else {
        _53 = 0.6954522132873535f;
        _54 = 0.14067870378494263f;
        _55 = 0.16386906802654266f;
        _56 = 0.044794563204050064f;
        _57 = 0.8596711158752441f;
        _58 = 0.0955343171954155f;
        _59 = -0.005525882821530104f;
        _60 = 0.004025210160762072f;
        _61 = 1.0015007257461548f;
      }
    } else {
      _53 = 1.0258246660232544f;
      _54 = -0.020053181797266006f;
      _55 = -0.005771636962890625f;
      _56 = -0.002234415616840124f;
      _57 = 1.0045864582061768f;
      _58 = -0.002352118492126465f;
      _59 = -0.005013350863009691f;
      _60 = -0.025290070101618767f;
      _61 = 1.0303035974502563f;
    }
  } else {
    _53 = 1.3792141675949097f;
    _54 = -0.30886411666870117f;
    _55 = -0.0703500509262085f;
    _56 = -0.06933490186929703f;
    _57 = 1.08229660987854f;
    _58 = -0.012961871922016144f;
    _59 = -0.0021590073592960835f;
    _60 = -0.0454593189060688f;
    _61 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    _72 = (pow(_30, 0.012683313339948654f));
    _73 = (pow(_31, 0.012683313339948654f));
    _74 = (pow(_33, 0.012683313339948654f));
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _119 = ((exp2((_30 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _120 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _121 = ((exp2((_33 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  _148 = (cb0_038w != 0);
  _152 = 0.9994439482688904f / cb0_035y;
  if ((cb0_035y * 1.0005563497543335f) > 7000.0f) {
    _169 = (((((1901800.0f - (_152 * 2006400000.0f)) * _152) + 247.47999572753906f) * _152) + 0.23703999817371368f);
  } else {
    _169 = (((((2967800.0f - (_152 * 4607000064.0f)) * _152) + 99.11000061035156f) * _152) + 0.24406300485134125f);
  }
  _183 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  _190 = cb0_035y * cb0_035y;
  _193 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_190 * 1.6145605741257896e-07f));
  _198 = ((_183 * 2.0f) + 4.0f) - (_193 * 8.0f);
  _199 = (_183 * 3.0f) / _198;
  _201 = (_193 * 2.0f) / _198;
  _202 = (cb0_035y < 4000.0f);
  _211 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  _213 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_190 * 1.5317699909210205f)) / (_211 * _211);
  _220 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _190;
  _222 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_190 * 308.60699462890625f)) / (_220 * _220);
  _224 = rsqrt(dot(float2(_213, _222), float2(_213, _222)));
  _225 = cb0_035z * 0.05000000074505806f;
  _228 = ((_225 * _222) * _224) + _183;
  _231 = _193 - ((_225 * _213) * _224);
  _236 = (4.0f - (_231 * 8.0f)) + (_228 * 2.0f);
  _242 = (((_228 * 3.0f) / _236) - _199) + select(_202, _199, _169);
  _243 = (((_231 * 2.0f) / _236) - _201) + select(_202, _201, (((_169 * 2.869999885559082f) + -0.2750000059604645f) - ((_169 * _169) * 3.0f)));
  _244 = select(_148, _242, 0.3127000033855438f);
  _245 = select(_148, _243, 0.32899999618530273f);
  _246 = select(_148, 0.3127000033855438f, _242);
  _247 = select(_148, 0.32899999618530273f, _243);
  _248 = max(_245, 1.000000013351432e-10f);
  _249 = _244 / _248;
  _252 = ((1.0f - _244) - _245) / _248;
  _253 = max(_247, 1.000000013351432e-10f);
  _254 = _246 / _253;
  _257 = ((1.0f - _246) - _247) / _253;
  _276 = mad(-0.16140000522136688f, _257, ((_254 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _252, ((_249 * 0.8950999975204468f) + 0.266400009393692f));
  _277 = mad(0.03669999912381172f, _257, (1.7135000228881836f - (_254 * 0.7501999735832214f))) / mad(0.03669999912381172f, _252, (1.7135000228881836f - (_249 * 0.7501999735832214f)));
  _278 = mad(1.0296000242233276f, _257, ((_254 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _252, ((_249 * 0.03889999911189079f) + -0.06849999725818634f));
  _279 = mad(_277, -0.7501999735832214f, 0.0f);
  _280 = mad(_277, 1.7135000228881836f, 0.0f);
  _281 = mad(_277, 0.03669999912381172f, -0.0f);
  _282 = mad(_278, 0.03889999911189079f, 0.0f);
  _283 = mad(_278, -0.06849999725818634f, 0.0f);
  _284 = mad(_278, 1.0296000242233276f, 0.0f);
  _287 = mad(0.1599626988172531f, _282, mad(-0.1470542997121811f, _279, (_276 * 0.883457362651825f)));
  _290 = mad(0.1599626988172531f, _283, mad(-0.1470542997121811f, _280, (_276 * 0.26293492317199707f)));
  _293 = mad(0.1599626988172531f, _284, mad(-0.1470542997121811f, _281, (_276 * -0.15930065512657166f)));
  _296 = mad(0.04929120093584061f, _282, mad(0.5183603167533875f, _279, (_276 * 0.38695648312568665f)));
  _299 = mad(0.04929120093584061f, _283, mad(0.5183603167533875f, _280, (_276 * 0.11516613513231277f)));
  _302 = mad(0.04929120093584061f, _284, mad(0.5183603167533875f, _281, (_276 * -0.0697740763425827f)));
  _305 = mad(0.9684867262840271f, _282, mad(0.04004279896616936f, _279, (_276 * -0.007634039502590895f)));
  _308 = mad(0.9684867262840271f, _283, mad(0.04004279896616936f, _280, (_276 * -0.0022720457054674625f)));
  _311 = mad(0.9684867262840271f, _284, mad(0.04004279896616936f, _281, (_276 * 0.0013765322510153055f)));
  _314 = mad(_293, (WorkingColorSpace_000[2].x), mad(_290, (WorkingColorSpace_000[1].x), (_287 * (WorkingColorSpace_000[0].x))));
  _317 = mad(_293, (WorkingColorSpace_000[2].y), mad(_290, (WorkingColorSpace_000[1].y), (_287 * (WorkingColorSpace_000[0].y))));
  _320 = mad(_293, (WorkingColorSpace_000[2].z), mad(_290, (WorkingColorSpace_000[1].z), (_287 * (WorkingColorSpace_000[0].z))));
  _323 = mad(_302, (WorkingColorSpace_000[2].x), mad(_299, (WorkingColorSpace_000[1].x), (_296 * (WorkingColorSpace_000[0].x))));
  _326 = mad(_302, (WorkingColorSpace_000[2].y), mad(_299, (WorkingColorSpace_000[1].y), (_296 * (WorkingColorSpace_000[0].y))));
  _329 = mad(_302, (WorkingColorSpace_000[2].z), mad(_299, (WorkingColorSpace_000[1].z), (_296 * (WorkingColorSpace_000[0].z))));
  _332 = mad(_311, (WorkingColorSpace_000[2].x), mad(_308, (WorkingColorSpace_000[1].x), (_305 * (WorkingColorSpace_000[0].x))));
  _335 = mad(_311, (WorkingColorSpace_000[2].y), mad(_308, (WorkingColorSpace_000[1].y), (_305 * (WorkingColorSpace_000[0].y))));
  _338 = mad(_311, (WorkingColorSpace_000[2].z), mad(_308, (WorkingColorSpace_000[1].z), (_305 * (WorkingColorSpace_000[0].z))));
  _368 = mad(mad((WorkingColorSpace_064[0].z), _338, mad((WorkingColorSpace_064[0].y), _329, (_320 * (WorkingColorSpace_064[0].x)))), _121, mad(mad((WorkingColorSpace_064[0].z), _335, mad((WorkingColorSpace_064[0].y), _326, (_317 * (WorkingColorSpace_064[0].x)))), _120, (mad((WorkingColorSpace_064[0].z), _332, mad((WorkingColorSpace_064[0].y), _323, (_314 * (WorkingColorSpace_064[0].x)))) * _119)));
  _371 = mad(mad((WorkingColorSpace_064[1].z), _338, mad((WorkingColorSpace_064[1].y), _329, (_320 * (WorkingColorSpace_064[1].x)))), _121, mad(mad((WorkingColorSpace_064[1].z), _335, mad((WorkingColorSpace_064[1].y), _326, (_317 * (WorkingColorSpace_064[1].x)))), _120, (mad((WorkingColorSpace_064[1].z), _332, mad((WorkingColorSpace_064[1].y), _323, (_314 * (WorkingColorSpace_064[1].x)))) * _119)));
  _374 = mad(mad((WorkingColorSpace_064[2].z), _338, mad((WorkingColorSpace_064[2].y), _329, (_320 * (WorkingColorSpace_064[2].x)))), _121, mad(mad((WorkingColorSpace_064[2].z), _335, mad((WorkingColorSpace_064[2].y), _326, (_317 * (WorkingColorSpace_064[2].x)))), _120, (mad((WorkingColorSpace_064[2].z), _332, mad((WorkingColorSpace_064[2].y), _323, (_314 * (WorkingColorSpace_064[2].x)))) * _119)));
  _389 = mad((WorkingColorSpace_128[0].z), _374, mad((WorkingColorSpace_128[0].y), _371, ((WorkingColorSpace_128[0].x) * _368)));
  _392 = mad((WorkingColorSpace_128[1].z), _374, mad((WorkingColorSpace_128[1].y), _371, ((WorkingColorSpace_128[1].x) * _368)));
  _395 = mad((WorkingColorSpace_128[2].z), _374, mad((WorkingColorSpace_128[2].y), _371, ((WorkingColorSpace_128[2].x) * _368)));
  _396 = dot(float3(_389, _392, _395), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _400 = (_389 / _396) + -1.0f;
  _401 = (_392 / _396) + -1.0f;
  _402 = (_395 / _396) + -1.0f;
  _414 = (1.0f - exp2(((_396 * _396) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_400, _401, _402), float3(_400, _401, _402)) * -4.0f));
  _430 = ((mad(-0.06368321925401688f, _395, mad(-0.3292922377586365f, _392, (_389 * 1.3704125881195068f))) - _389) * _414) + _389;
  _431 = ((mad(-0.010861365124583244f, _395, mad(1.0970927476882935f, _392, (_389 * -0.08343357592821121f))) - _392) * _414) + _392;
  _432 = ((mad(1.2036951780319214f, _395, mad(-0.09862580895423889f, _392, (_389 * -0.02579331398010254f))) - _395) * _414) + _395;
  _433 = dot(float3(_430, _431, _432), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _447 = cb0_019w + cb0_024w;
  _461 = cb0_018w * cb0_023w;
  _475 = cb0_017w * cb0_022w;
  _489 = cb0_016w * cb0_021w;
  _503 = cb0_015w * cb0_020w;
  _507 = _430 - _433;
  _508 = _431 - _433;
  _509 = _432 - _433;
  _566 = saturate(_433 / cb0_035w);
  _570 = (_566 * _566) * (3.0f - (_566 * 2.0f));
  _571 = 1.0f - _570;
  _580 = cb0_019w + cb0_034w;
  _589 = cb0_018w * cb0_033w;
  _598 = cb0_017w * cb0_032w;
  _607 = cb0_016w * cb0_031w;
  _616 = cb0_015w * cb0_030w;
  _679 = saturate((_433 - cb0_036x) / (cb0_036y - cb0_036x));
  _683 = (_679 * _679) * (3.0f - (_679 * 2.0f));
  _692 = cb0_019w + cb0_029w;
  _701 = cb0_018w * cb0_028w;
  _710 = cb0_017w * cb0_027w;
  _719 = cb0_016w * cb0_026w;
  _728 = cb0_015w * cb0_025w;
  _786 = _570 - _683;
  _797 = ((_683 * (((cb0_019x + cb0_034x) + _580) + (((cb0_018x * cb0_033x) * _589) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _607) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _616) * _507) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _598)))))) + (_571 * (((cb0_019x + cb0_024x) + _447) + (((cb0_018x * cb0_023x) * _461) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _489) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _503) * _507) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _475))))))) + ((((cb0_019x + cb0_029x) + _692) + (((cb0_018x * cb0_028x) * _701) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _719) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _728) * _507) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _710))))) * _786);
  _799 = ((_683 * (((cb0_019y + cb0_034y) + _580) + (((cb0_018y * cb0_033y) * _589) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _607) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _616) * _508) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _598)))))) + (_571 * (((cb0_019y + cb0_024y) + _447) + (((cb0_018y * cb0_023y) * _461) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _489) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _503) * _508) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _475))))))) + ((((cb0_019y + cb0_029y) + _692) + (((cb0_018y * cb0_028y) * _701) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _719) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _728) * _508) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _710))))) * _786);
  _801 = ((_683 * (((cb0_019z + cb0_034z) + _580) + (((cb0_018z * cb0_033z) * _589) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _607) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _616) * _509) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _598)))))) + (_571 * (((cb0_019z + cb0_024z) + _447) + (((cb0_018z * cb0_023z) * _461) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _489) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _503) * _509) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _475))))))) + ((((cb0_019z + cb0_029z) + _692) + (((cb0_018z * cb0_028z) * _701) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _719) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _728) * _509) + _433)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _710))))) * _786);
  if (!(cb0_042x == 0)) {
    if (_797 > 0.0078125f) {
      _815 = ((log2(_797) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _815 = ((_797 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_799 > 0.0078125f) {
      _825 = ((log2(_799) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _825 = ((_799 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_801 > 0.0078125f) {
      _835 = ((log2(_801) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _835 = ((_801 * 10.540237426757812f) + 0.072905533015728f);
    }
    _839 = min(max(_815, 0.0f), 1.0f);
    _840 = min(max(_825, 0.0f), 1.0f);
    _841 = min(max(_835, 0.0f), 1.0f);
    _846 = t0.Sample(s0, float3(_839, _840, _841));
    if (cb0_042y == 1) {
      _854 = t0.Sample(s0, float3((cb0_042z + _839), _840, _841));
      _859 = t0.Sample(s0, float3(_839, (cb0_042z + _840), _841));
      _864 = t0.Sample(s0, float3(_839, _840, (cb0_042z + _841)));
      _880 = saturate(1.0f - abs(_839 - floor(_839)));
      _881 = saturate(1.0f - abs(_840 - floor(_840)));
      _882 = saturate(1.0f - abs(_841 - floor(_841)));
      _883 = dot(float3(_880, _881, _882), float3(1.0f, 1.0f, 1.0f));
      _884 = _880 / _883;
      _885 = _881 / _883;
      _886 = _882 / _883;
      _904 = ((1.0f - _884) - _885) - _886;
      _912 = ((((_885 * _854.x) + (_884 * _846.x)) + (_886 * _859.x)) + (_904 * _864.x));
      _913 = ((((_885 * _854.y) + (_884 * _846.y)) + (_886 * _859.y)) + (_904 * _864.y));
      _914 = ((((_885 * _854.z) + (_884 * _846.z)) + (_886 * _859.z)) + (_904 * _864.z));
    } else {
      _912 = _846.x;
      _913 = _846.y;
      _914 = _846.z;
    }
    if (_912 > 0.155251145362854f) {
      _924 = exp2((_912 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _924 = ((_912 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_913 > 0.155251145362854f) {
      _934 = exp2((_913 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _934 = ((_913 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_914 > 0.155251145362854f) {
      _944 = exp2((_914 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _944 = ((_914 + -0.072905533015728f) * 0.09487452358007431f);
    }
    _952 = min(max(_924, 0.0f), 65504.0f);
    _953 = min(max(_934, 0.0f), 65504.0f);
    _954 = min(max(_944, 0.0f), 65504.0f);
  } else {
    _952 = _797;
    _953 = _799;
    _954 = _801;
  }

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
  float4 output = ProcessLutbuilder(float3(_952, _953, _954), cb_config, SV_Target, asuint(cb0_040w));
  SV_Target = output;
  return SV_Target;
  _991 = ((mad(0.061360642313957214f, _954, mad(-4.540197551250458e-09f, _953, (_952 * 0.9386394023895264f))) - _952) * cb0_036z) + _952;
  _992 = ((mad(0.169205904006958f, _954, mad(0.8307942152023315f, _953, (_952 * 6.775371730327606e-08f))) - _953) * cb0_036z) + _953;
  _993 = (mad(-2.3283064365386963e-10f, _953, (_952 * -9.313225746154785e-10f)) * cb0_036z) + _954;
  _996 = mad(0.16386905312538147f, _993, mad(0.14067868888378143f, _992, (_991 * 0.6954522132873535f)));
  _999 = mad(0.0955343246459961f, _993, mad(0.8596711158752441f, _992, (_991 * 0.044794581830501556f)));
  _1002 = mad(1.0015007257461548f, _993, mad(0.004025210160762072f, _992, (_991 * -0.005525882821530104f)));
  _1006 = max(max(_996, _999), _1002);
  _1011 = (max(_1006, 1.000000013351432e-10f) - max(min(min(_996, _999), _1002), 1.000000013351432e-10f)) / max(_1006, 0.009999999776482582f);
  _1024 = ((_999 + _996) + _1002) + (sqrt((((_1002 - _999) * _1002) + ((_999 - _996) * _999)) + ((_996 - _1002) * _996)) * 1.75f);
  _1025 = _1024 * 0.3333333432674408f;
  _1026 = _1011 + -0.4000000059604645f;
  _1027 = _1026 * 5.0f;
  _1031 = max((1.0f - abs(_1026 * 2.5f)), 0.0f);
  _1042 = ((float((int)(((int)(uint)((int)(_1027 > 0.0f))) - ((int)(uint)((int)(_1027 < 0.0f))))) * (1.0f - (_1031 * _1031))) + 1.0f) * 0.02500000037252903f;
  if (_1025 > 0.0533333346247673f) {
    if (_1025 < 0.1599999964237213f) {
      _1051 = (((0.23999999463558197f / _1024) + -0.5f) * _1042);
    } else {
      _1051 = 0.0f;
    }
  } else {
    _1051 = _1042;
  }
  _1052 = _1051 + 1.0f;
  _1053 = _1052 * _996;
  _1054 = _1052 * _999;
  _1055 = _1052 * _1002;
  if (!((_1053 == _1054) && (_1054 == _1055))) {
    _1062 = ((_1053 * 2.0f) - _1054) - _1055;
    _1065 = ((_999 - _1002) * 1.7320507764816284f) * _1052;
    _1067 = atan(_1065 / _1062);
    _1070 = (_1062 < 0.0f);
    _1071 = (_1062 == 0.0f);
    _1072 = (_1065 >= 0.0f);
    _1073 = (_1065 < 0.0f);
    _1084 = select((_1072 && _1071), 90.0f, select((_1073 && _1071), -90.0f, (select((_1073 && _1070), (_1067 + -3.1415927410125732f), select((_1072 && _1070), (_1067 + 3.1415927410125732f), _1067)) * 57.2957763671875f)));
  } else {
    _1084 = 0.0f;
  }
  _1089 = min(max(select((_1084 < 0.0f), (_1084 + 360.0f), _1084), 0.0f), 360.0f);
  if (_1089 < -180.0f) {
    _1098 = (_1089 + 360.0f);
  } else {
    if (_1089 > 180.0f) {
      _1098 = (_1089 + -360.0f);
    } else {
      _1098 = _1089;
    }
  }
  _1102 = saturate(1.0f - abs(_1098 * 0.014814814552664757f));
  _1106 = (_1102 * _1102) * (3.0f - (_1102 * 2.0f));
  _1112 = ((_1106 * _1106) * ((_1011 * 0.18000000715255737f) * (0.029999999329447746f - _1053))) + _1053;
  _1122 = max(0.0f, mad(-0.21492856740951538f, _1055, mad(-0.2365107536315918f, _1054, (_1112 * 1.4514392614364624f))));
  _1123 = max(0.0f, mad(-0.09967592358589172f, _1055, mad(1.17622971534729f, _1054, (_1112 * -0.07655377686023712f))));
  _1124 = max(0.0f, mad(0.9977163076400757f, _1055, mad(-0.006032449658960104f, _1054, (_1112 * 0.008316148072481155f))));
  _1125 = dot(float3(_1122, _1123, _1124), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1140 = (cb0_038x + 1.0f) - cb0_037z;
  _1142 = cb0_038y + 1.0f;
  _1144 = _1142 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _1162 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    _1153 = (cb0_038x + 0.18000000715255737f) / _1140;
    _1162 = (-0.7447274923324585f - ((log2(_1153 / (2.0f - _1153)) * 0.3465735912322998f) * (_1140 / cb0_037y)));
  }
  _1165 = ((1.0f - cb0_037z) / cb0_037y) - _1162;
  _1167 = (cb0_037w / cb0_037y) - _1165;
  _1171 = log2(lerp(_1125, _1122, 0.9599999785423279f)) * 0.3010300099849701f;
  _1172 = log2(lerp(_1125, _1123, 0.9599999785423279f)) * 0.3010300099849701f;
  _1173 = log2(lerp(_1125, _1124, 0.9599999785423279f)) * 0.3010300099849701f;
  _1177 = cb0_037y * (_1171 + _1165);
  _1178 = cb0_037y * (_1172 + _1165);
  _1179 = cb0_037y * (_1173 + _1165);
  _1180 = _1140 * 2.0f;
  _1182 = (cb0_037y * -2.0f) / _1140;
  _1183 = _1171 - _1162;
  _1184 = _1172 - _1162;
  _1185 = _1173 - _1162;
  _1204 = _1144 * 2.0f;
  _1206 = (cb0_037y * 2.0f) / _1144;
  _1231 = select((_1171 < _1162), ((_1180 / (exp2((_1183 * 1.4426950216293335f) * _1182) + 1.0f)) - cb0_038x), _1177);
  _1232 = select((_1172 < _1162), ((_1180 / (exp2((_1184 * 1.4426950216293335f) * _1182) + 1.0f)) - cb0_038x), _1178);
  _1233 = select((_1173 < _1162), ((_1180 / (exp2((_1185 * 1.4426950216293335f) * _1182) + 1.0f)) - cb0_038x), _1179);
  _1240 = _1167 - _1162;
  _1244 = saturate(_1183 / _1240);
  _1245 = saturate(_1184 / _1240);
  _1246 = saturate(_1185 / _1240);
  _1247 = (_1167 < _1162);
  _1251 = select(_1247, (1.0f - _1244), _1244);
  _1252 = select(_1247, (1.0f - _1245), _1245);
  _1253 = select(_1247, (1.0f - _1246), _1246);
  _1272 = (((_1251 * _1251) * (select((_1171 > _1167), (_1142 - (_1204 / (exp2(((_1171 - _1167) * 1.4426950216293335f) * _1206) + 1.0f))), _1177) - _1231)) * (3.0f - (_1251 * 2.0f))) + _1231;
  _1273 = (((_1252 * _1252) * (select((_1172 > _1167), (_1142 - (_1204 / (exp2(((_1172 - _1167) * 1.4426950216293335f) * _1206) + 1.0f))), _1178) - _1232)) * (3.0f - (_1252 * 2.0f))) + _1232;
  _1274 = (((_1253 * _1253) * (select((_1173 > _1167), (_1142 - (_1204 / (exp2(((_1173 - _1167) * 1.4426950216293335f) * _1206) + 1.0f))), _1179) - _1233)) * (3.0f - (_1253 * 2.0f))) + _1233;
  _1275 = dot(float3(_1272, _1273, _1274), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1295 = (cb0_037x * (max(0.0f, (lerp(_1275, _1272, 0.9300000071525574f))) - _991)) + _991;
  _1296 = (cb0_037x * (max(0.0f, (lerp(_1275, _1273, 0.9300000071525574f))) - _992)) + _992;
  _1297 = (cb0_037x * (max(0.0f, (lerp(_1275, _1274, 0.9300000071525574f))) - _993)) + _993;
  _1313 = ((mad(-0.06537103652954102f, _1297, mad(1.451815478503704e-06f, _1296, (_1295 * 1.065374732017517f))) - _1295) * cb0_036z) + _1295;
  _1314 = ((mad(-0.20366770029067993f, _1297, mad(1.2036634683609009f, _1296, (_1295 * -2.57161445915699e-07f))) - _1296) * cb0_036z) + _1296;
  _1315 = ((mad(0.9999996423721313f, _1297, mad(2.0954757928848267e-08f, _1296, (_1295 * 1.862645149230957e-08f))) - _1297) * cb0_036z) + _1297;
  _1325 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1315, mad((WorkingColorSpace_192[0].y), _1314, ((WorkingColorSpace_192[0].x) * _1313))));
  _1326 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1315, mad((WorkingColorSpace_192[1].y), _1314, ((WorkingColorSpace_192[1].x) * _1313))));
  _1327 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1315, mad((WorkingColorSpace_192[2].y), _1314, ((WorkingColorSpace_192[2].x) * _1313))));
  _1353 = cb0_014x * (((cb0_039y + (cb0_039x * _1325)) * _1325) + cb0_039z);
  _1354 = cb0_014y * (((cb0_039y + (cb0_039x * _1326)) * _1326) + cb0_039z);
  _1355 = cb0_014z * (((cb0_039y + (cb0_039x * _1327)) * _1327) + cb0_039z);
  _1362 = ((cb0_013x - _1353) * cb0_013w) + _1353;
  _1363 = ((cb0_013y - _1354) * cb0_013w) + _1354;
  _1364 = ((cb0_013z - _1355) * cb0_013w) + _1355;
  _1365 = cb0_014x * mad((WorkingColorSpace_192[0].z), _954, mad((WorkingColorSpace_192[0].y), _953, ((WorkingColorSpace_192[0].x) * _952)));
  _1366 = cb0_014y * mad((WorkingColorSpace_192[1].z), _954, mad((WorkingColorSpace_192[1].y), _953, ((WorkingColorSpace_192[1].x) * _952)));
  _1367 = cb0_014z * mad((WorkingColorSpace_192[2].z), _954, mad((WorkingColorSpace_192[2].y), _953, ((WorkingColorSpace_192[2].x) * _952)));
  _1374 = ((cb0_013x - _1365) * cb0_013w) + _1365;
  _1375 = ((cb0_013y - _1366) * cb0_013w) + _1366;
  _1376 = ((cb0_013z - _1367) * cb0_013w) + _1367;
  _1388 = exp2(log2(max(0.0f, _1362)) * cb0_040y);
  _1389 = exp2(log2(max(0.0f, _1363)) * cb0_040y);
  _1390 = exp2(log2(max(0.0f, _1364)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    if (WorkingColorSpace_320 == 0) {
      _1413 = mad((WorkingColorSpace_128[0].z), _1390, mad((WorkingColorSpace_128[0].y), _1389, ((WorkingColorSpace_128[0].x) * _1388)));
      _1416 = mad((WorkingColorSpace_128[1].z), _1390, mad((WorkingColorSpace_128[1].y), _1389, ((WorkingColorSpace_128[1].x) * _1388)));
      _1419 = mad((WorkingColorSpace_128[2].z), _1390, mad((WorkingColorSpace_128[2].y), _1389, ((WorkingColorSpace_128[2].x) * _1388)));
      _1430 = mad(_55, _1419, mad(_54, _1416, (_1413 * _53)));
      _1431 = mad(_58, _1419, mad(_57, _1416, (_1413 * _56)));
      _1432 = mad(_61, _1419, mad(_60, _1416, (_1413 * _59)));
    } else {
      _1430 = _1388;
      _1431 = _1389;
      _1432 = _1390;
    }
    if (_1430 < 0.0031306699384003878f) {
      _1443 = (_1430 * 12.920000076293945f);
    } else {
      _1443 = (((pow(_1430, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1431 < 0.0031306699384003878f) {
      _1454 = (_1431 * 12.920000076293945f);
    } else {
      _1454 = (((pow(_1431, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1432 < 0.0031306699384003878f) {
      _3058 = _1443;
      _3059 = _1454;
      _3060 = (_1432 * 12.920000076293945f);
    } else {
      _3058 = _1443;
      _3059 = _1454;
      _3060 = (((pow(_1432, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_040w == 1) {
      _1481 = mad((WorkingColorSpace_128[0].z), _1390, mad((WorkingColorSpace_128[0].y), _1389, ((WorkingColorSpace_128[0].x) * _1388)));
      _1484 = mad((WorkingColorSpace_128[1].z), _1390, mad((WorkingColorSpace_128[1].y), _1389, ((WorkingColorSpace_128[1].x) * _1388)));
      _1487 = mad((WorkingColorSpace_128[2].z), _1390, mad((WorkingColorSpace_128[2].y), _1389, ((WorkingColorSpace_128[2].x) * _1388)));
      _1497 = max(6.103519990574569e-05f, mad(_55, _1487, mad(_54, _1484, (_1481 * _53))));
      _1498 = max(6.103519990574569e-05f, mad(_58, _1487, mad(_57, _1484, (_1481 * _56))));
      _1499 = max(6.103519990574569e-05f, mad(_61, _1487, mad(_60, _1484, (_1481 * _59))));
      _3058 = min((_1497 * 4.5f), ((exp2(log2(max(_1497, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3059 = min((_1498 * 4.5f), ((exp2(log2(max(_1498, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3060 = min((_1499 * 4.5f), ((exp2(log2(max(_1499, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((cb0_040w == 3) || (cb0_040w == 5)) {
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
        _1575 = cb0_012z * _1374;
        _1576 = cb0_012z * _1375;
        _1577 = cb0_012z * _1376;
        _1580 = mad((WorkingColorSpace_256[0].z), _1577, mad((WorkingColorSpace_256[0].y), _1576, ((WorkingColorSpace_256[0].x) * _1575)));
        _1583 = mad((WorkingColorSpace_256[1].z), _1577, mad((WorkingColorSpace_256[1].y), _1576, ((WorkingColorSpace_256[1].x) * _1575)));
        _1586 = mad((WorkingColorSpace_256[2].z), _1577, mad((WorkingColorSpace_256[2].y), _1576, ((WorkingColorSpace_256[2].x) * _1575)));
        _1589 = mad(-0.21492856740951538f, _1586, mad(-0.2365107536315918f, _1583, (_1580 * 1.4514392614364624f)));
        _1592 = mad(-0.09967592358589172f, _1586, mad(1.17622971534729f, _1583, (_1580 * -0.07655377686023712f)));
        _1595 = mad(0.9977163076400757f, _1586, mad(-0.006032449658960104f, _1583, (_1580 * 0.008316148072481155f)));
        _1597 = max(_1589, max(_1592, _1595));
        if (!(_1597 < 1.000000013351432e-10f)) {
          if (!(((_1580 < 0.0f) || (_1583 < 0.0f)) || (_1586 < 0.0f))) {
            _1607 = abs(_1597);
            _1608 = (_1597 - _1589) / _1607;
            _1610 = (_1597 - _1592) / _1607;
            _1612 = (_1597 - _1595) / _1607;
            if (!(_1608 < 0.8149999976158142f)) {
              _1615 = _1608 + -0.8149999976158142f;
              _1627 = ((_1615 / exp2(log2(exp2(log2(_1615 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1627 = _1608;
            }
            if (!(_1610 < 0.8029999732971191f)) {
              _1630 = _1610 + -0.8029999732971191f;
              _1642 = ((_1630 / exp2(log2(exp2(log2(_1630 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1642 = _1610;
            }
            if (!(_1612 < 0.8799999952316284f)) {
              _1645 = _1612 + -0.8799999952316284f;
              _1657 = ((_1645 / exp2(log2(exp2(log2(_1645 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1657 = _1612;
            }
            _1665 = (_1597 - (_1607 * _1627));
            _1666 = (_1597 - (_1607 * _1642));
            _1667 = (_1597 - (_1607 * _1657));
          } else {
            _1665 = _1589;
            _1666 = _1592;
            _1667 = _1595;
          }
        } else {
          _1665 = _1589;
          _1666 = _1592;
          _1667 = _1595;
        }
        _1683 = ((mad(0.16386906802654266f, _1667, mad(0.14067870378494263f, _1666, (_1665 * 0.6954522132873535f))) - _1580) * cb0_012w) + _1580;
        _1684 = ((mad(0.0955343171954155f, _1667, mad(0.8596711158752441f, _1666, (_1665 * 0.044794563204050064f))) - _1583) * cb0_012w) + _1583;
        _1685 = ((mad(1.0015007257461548f, _1667, mad(0.004025210160762072f, _1666, (_1665 * -0.005525882821530104f))) - _1586) * cb0_012w) + _1586;
        _1689 = max(max(_1683, _1684), _1685);
        _1694 = (max(_1689, 1.000000013351432e-10f) - max(min(min(_1683, _1684), _1685), 1.000000013351432e-10f)) / max(_1689, 0.009999999776482582f);
        _1707 = ((_1684 + _1683) + _1685) + (sqrt((((_1685 - _1684) * _1685) + ((_1684 - _1683) * _1684)) + ((_1683 - _1685) * _1683)) * 1.75f);
        _1708 = _1707 * 0.3333333432674408f;
        _1709 = _1694 + -0.4000000059604645f;
        _1710 = _1709 * 5.0f;
        _1714 = max((1.0f - abs(_1709 * 2.5f)), 0.0f);
        _1725 = ((float((int)(((int)(uint)((int)(_1710 > 0.0f))) - ((int)(uint)((int)(_1710 < 0.0f))))) * (1.0f - (_1714 * _1714))) + 1.0f) * 0.02500000037252903f;
        if (_1708 > 0.0533333346247673f) {
          if (_1708 < 0.1599999964237213f) {
            _1734 = (((0.23999999463558197f / _1707) + -0.5f) * _1725);
          } else {
            _1734 = 0.0f;
          }
        } else {
          _1734 = _1725;
        }
        _1735 = _1734 + 1.0f;
        _1736 = _1735 * _1683;
        _1737 = _1735 * _1684;
        _1738 = _1735 * _1685;
        if (!((_1736 == _1737) && (_1737 == _1738))) {
          _1745 = ((_1736 * 2.0f) - _1737) - _1738;
          _1748 = ((_1684 - _1685) * 1.7320507764816284f) * _1735;
          _1750 = atan(_1748 / _1745);
          _1753 = (_1745 < 0.0f);
          _1754 = (_1745 == 0.0f);
          _1755 = (_1748 >= 0.0f);
          _1756 = (_1748 < 0.0f);
          _1767 = select((_1755 && _1754), 90.0f, select((_1756 && _1754), -90.0f, (select((_1756 && _1753), (_1750 + -3.1415927410125732f), select((_1755 && _1753), (_1750 + 3.1415927410125732f), _1750)) * 57.2957763671875f)));
        } else {
          _1767 = 0.0f;
        }
        _1772 = min(max(select((_1767 < 0.0f), (_1767 + 360.0f), _1767), 0.0f), 360.0f);
        if (_1772 < -180.0f) {
          _1781 = (_1772 + 360.0f);
        } else {
          if (_1772 > 180.0f) {
            _1781 = (_1772 + -360.0f);
          } else {
            _1781 = _1772;
          }
        }
        if ((_1781 > -67.5f) && (_1781 < 67.5f)) {
          _1787 = (_1781 + 67.5f) * 0.029629629105329514f;
          _1788 = int(_1787);
          _1790 = _1787 - float((int)(_1788));
          _1791 = _1790 * _1790;
          _1792 = _1791 * _1790;
          if (_1788 == 3) {
            _1820 = (((0.1666666716337204f - (_1790 * 0.5f)) + (_1791 * 0.5f)) - (_1792 * 0.1666666716337204f));
          } else {
            if (_1788 == 2) {
              _1820 = ((0.6666666865348816f - _1791) + (_1792 * 0.5f));
            } else {
              if (_1788 == 1) {
                _1820 = (((_1792 * -0.5f) + 0.1666666716337204f) + ((_1791 + _1790) * 0.5f));
              } else {
                _1820 = select((_1788 == 0), (_1792 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1820 = 0.0f;
        }
        _1829 = min(max(((((_1694 * 0.27000001072883606f) * (0.029999999329447746f - _1736)) * _1820) + _1736), 0.0f), 65535.0f);
        _1830 = min(max(_1737, 0.0f), 65535.0f);
        _1831 = min(max(_1738, 0.0f), 65535.0f);
        _1844 = min(max(mad(-0.21492856740951538f, _1831, mad(-0.2365107536315918f, _1830, (_1829 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1845 = min(max(mad(-0.09967592358589172f, _1831, mad(1.17622971534729f, _1830, (_1829 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1846 = min(max(mad(0.9977163076400757f, _1831, mad(-0.006032449658960104f, _1830, (_1829 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1847 = dot(float3(_1844, _1845, _1846), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
        _1870 = log2(max((lerp(_1847, _1844, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1871 = _1870 * 0.3010300099849701f;
        _1872 = log2(cb0_008x);
        _1873 = _1872 * 0.3010300099849701f;
        if (_1871 > _1873) {
          _1880 = log2(cb0_009x);
          _1881 = _1880 * 0.3010300099849701f;
          if ((_1871 > _1873) && (_1871 < _1881)) {
            _1889 = ((_1870 - _1872) * 0.9030900001525879f) / ((_1880 - _1872) * 0.3010300099849701f);
            _1890 = int(_1889);
            _1892 = _1889 - float((int)(_1890));
            _1894 = _18[min((uint)(_1890), 5u)];
            _1897 = _18[min((uint)((_1890 + 1)), 5u)];
            _1902 = _1894 * 0.5f;
            _1942 = dot(float3((_1892 * _1892), _1892, 1.0f), float3(mad((_18[min((uint)((_1890 + 2)), 5u)]), 0.5f, mad(_1897, -1.0f, _1902)), (_1897 - _1894), mad(_1897, 0.5f, _1902)));
          } else {
            if (_1871 < _1881) {
              _1942 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1911 = log2(cb0_008z);
              if (!(_1871 < (_1911 * 0.3010300099849701f))) {
                _1942 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1919 = ((_1870 - _1880) * 0.9030900001525879f) / ((_1911 - _1880) * 0.3010300099849701f);
                _1920 = int(_1919);
                _1922 = _1919 - float((int)(_1920));
                _1924 = _19[min((uint)(_1920), 5u)];
                _1927 = _19[min((uint)((_1920 + 1)), 5u)];
                _1932 = _1924 * 0.5f;
                _1942 = dot(float3((_1922 * _1922), _1922, 1.0f), float3(mad((_19[min((uint)((_1920 + 2)), 5u)]), 0.5f, mad(_1927, -1.0f, _1932)), (_1927 - _1924), mad(_1927, 0.5f, _1932)));
              }
            }
          }
        } else {
          _1942 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _20[0] = cb0_010x;
        _20[1] = cb0_010y;
        _20[2] = cb0_010z;
        _20[3] = cb0_010w;
        _20[4] = cb0_012x;
        _20[5] = cb0_012x;
        _21[0] = cb0_011x;
        _21[1] = cb0_011y;
        _21[2] = cb0_011z;
        _21[3] = cb0_011w;
        _21[4] = cb0_012y;
        _21[5] = cb0_012y;
        _1958 = log2(max((lerp(_1847, _1845, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1959 = _1958 * 0.3010300099849701f;
        if (_1959 > _1873) {
          _1966 = log2(cb0_009x);
          _1967 = _1966 * 0.3010300099849701f;
          if ((_1959 > _1873) && (_1959 < _1967)) {
            _1975 = ((_1958 - _1872) * 0.9030900001525879f) / ((_1966 - _1872) * 0.3010300099849701f);
            _1976 = int(_1975);
            _1978 = _1975 - float((int)(_1976));
            _1980 = _20[min((uint)(_1976), 5u)];
            _1983 = _20[min((uint)((_1976 + 1)), 5u)];
            _1988 = _1980 * 0.5f;
            _2028 = dot(float3((_1978 * _1978), _1978, 1.0f), float3(mad((_20[min((uint)((_1976 + 2)), 5u)]), 0.5f, mad(_1983, -1.0f, _1988)), (_1983 - _1980), mad(_1983, 0.5f, _1988)));
          } else {
            if (_1959 < _1967) {
              _2028 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1997 = log2(cb0_008z);
              if (!(_1959 < (_1997 * 0.3010300099849701f))) {
                _2028 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2005 = ((_1958 - _1966) * 0.9030900001525879f) / ((_1997 - _1966) * 0.3010300099849701f);
                _2006 = int(_2005);
                _2008 = _2005 - float((int)(_2006));
                _2010 = _21[min((uint)(_2006), 5u)];
                _2013 = _21[min((uint)((_2006 + 1)), 5u)];
                _2018 = _2010 * 0.5f;
                _2028 = dot(float3((_2008 * _2008), _2008, 1.0f), float3(mad((_21[min((uint)((_2006 + 2)), 5u)]), 0.5f, mad(_2013, -1.0f, _2018)), (_2013 - _2010), mad(_2013, 0.5f, _2018)));
              }
            }
          }
        } else {
          _2028 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2032 = log2(max((lerp(_1847, _1846, 0.9599999785423279f)), 1.000000013351432e-10f));
        _2033 = _2032 * 0.3010300099849701f;
        if (_2033 > _1873) {
          _2040 = log2(cb0_009x);
          _2041 = _2040 * 0.3010300099849701f;
          if ((_2033 > _1873) && (_2033 < _2041)) {
            _2049 = ((_2032 - _1872) * 0.9030900001525879f) / ((_2040 - _1872) * 0.3010300099849701f);
            _2050 = int(_2049);
            _2052 = _2049 - float((int)(_2050));
            _2054 = _10[min((uint)(_2050), 5u)];
            _2057 = _10[min((uint)((_2050 + 1)), 5u)];
            _2062 = _2054 * 0.5f;
            _2102 = dot(float3((_2052 * _2052), _2052, 1.0f), float3(mad((_10[min((uint)((_2050 + 2)), 5u)]), 0.5f, mad(_2057, -1.0f, _2062)), (_2057 - _2054), mad(_2057, 0.5f, _2062)));
          } else {
            if (_2033 < _2041) {
              _2102 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _2071 = log2(cb0_008z);
              if (!(_2033 < (_2071 * 0.3010300099849701f))) {
                _2102 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2079 = ((_2032 - _2040) * 0.9030900001525879f) / ((_2071 - _2040) * 0.3010300099849701f);
                _2080 = int(_2079);
                _2082 = _2079 - float((int)(_2080));
                _2084 = _11[min((uint)(_2080), 5u)];
                _2087 = _11[min((uint)((_2080 + 1)), 5u)];
                _2092 = _2084 * 0.5f;
                _2102 = dot(float3((_2082 * _2082), _2082, 1.0f), float3(mad((_11[min((uint)((_2080 + 2)), 5u)]), 0.5f, mad(_2087, -1.0f, _2092)), (_2087 - _2084), mad(_2087, 0.5f, _2092)));
              }
            }
          }
        } else {
          _2102 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2106 = cb0_008w - cb0_008y;
        _2107 = (exp2(_1942 * 3.321928024291992f) - cb0_008y) / _2106;
        _2109 = (exp2(_2028 * 3.321928024291992f) - cb0_008y) / _2106;
        _2111 = (exp2(_2102 * 3.321928024291992f) - cb0_008y) / _2106;
        _2114 = mad(0.15618768334388733f, _2111, mad(0.13400420546531677f, _2109, (_2107 * 0.6624541878700256f)));
        _2117 = mad(0.053689517080783844f, _2111, mad(0.6740817427635193f, _2109, (_2107 * 0.2722287178039551f)));
        _2120 = mad(1.0103391408920288f, _2111, mad(0.00406073359772563f, _2109, (_2107 * -0.005574649665504694f)));
        _2133 = min(max(mad(-0.23642469942569733f, _2120, mad(-0.32480329275131226f, _2117, (_2114 * 1.6410233974456787f))), 0.0f), 1.0f);
        _2134 = min(max(mad(0.016756348311901093f, _2120, mad(1.6153316497802734f, _2117, (_2114 * -0.663662850856781f))), 0.0f), 1.0f);
        _2135 = min(max(mad(0.9883948564529419f, _2120, mad(-0.008284442126750946f, _2117, (_2114 * 0.011721894145011902f))), 0.0f), 1.0f);
        _2138 = mad(0.15618768334388733f, _2135, mad(0.13400420546531677f, _2134, (_2133 * 0.6624541878700256f)));
        _2141 = mad(0.053689517080783844f, _2135, mad(0.6740817427635193f, _2134, (_2133 * 0.2722287178039551f)));
        _2144 = mad(1.0103391408920288f, _2135, mad(0.00406073359772563f, _2134, (_2133 * -0.005574649665504694f)));
        _2166 = min(max((min(max(mad(-0.23642469942569733f, _2144, mad(-0.32480329275131226f, _2141, (_2138 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2167 = min(max((min(max(mad(0.016756348311901093f, _2144, mad(1.6153316497802734f, _2141, (_2138 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2168 = min(max((min(max(mad(0.9883948564529419f, _2144, mad(-0.008284442126750946f, _2141, (_2138 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        if (!(cb0_040w == 5)) {
          _2181 = mad(_55, _2168, mad(_54, _2167, (_2166 * _53)));
          _2182 = mad(_58, _2168, mad(_57, _2167, (_2166 * _56)));
          _2183 = mad(_61, _2168, mad(_60, _2167, (_2166 * _59)));
        } else {
          _2181 = _2166;
          _2182 = _2167;
          _2183 = _2168;
        }
        _2193 = exp2(log2(_2181 * 9.999999747378752e-05f) * 0.1593017578125f);
        _2194 = exp2(log2(_2182 * 9.999999747378752e-05f) * 0.1593017578125f);
        _2195 = exp2(log2(_2183 * 9.999999747378752e-05f) * 0.1593017578125f);
        _3058 = exp2(log2((1.0f / ((_2193 * 18.6875f) + 1.0f)) * ((_2193 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _3059 = exp2(log2((1.0f / ((_2194 * 18.6875f) + 1.0f)) * ((_2194 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _3060 = exp2(log2((1.0f / ((_2195 * 18.6875f) + 1.0f)) * ((_2195 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((cb0_040w & -3) == 4) {
          _2261 = cb0_012z * _1374;
          _2262 = cb0_012z * _1375;
          _2263 = cb0_012z * _1376;
          _2266 = mad((WorkingColorSpace_256[0].z), _2263, mad((WorkingColorSpace_256[0].y), _2262, ((WorkingColorSpace_256[0].x) * _2261)));
          _2269 = mad((WorkingColorSpace_256[1].z), _2263, mad((WorkingColorSpace_256[1].y), _2262, ((WorkingColorSpace_256[1].x) * _2261)));
          _2272 = mad((WorkingColorSpace_256[2].z), _2263, mad((WorkingColorSpace_256[2].y), _2262, ((WorkingColorSpace_256[2].x) * _2261)));
          _2275 = mad(-0.21492856740951538f, _2272, mad(-0.2365107536315918f, _2269, (_2266 * 1.4514392614364624f)));
          _2278 = mad(-0.09967592358589172f, _2272, mad(1.17622971534729f, _2269, (_2266 * -0.07655377686023712f)));
          _2281 = mad(0.9977163076400757f, _2272, mad(-0.006032449658960104f, _2269, (_2266 * 0.008316148072481155f)));
          _2283 = max(_2275, max(_2278, _2281));
          if (!(_2283 < 1.000000013351432e-10f)) {
            if (!(((_2266 < 0.0f) || (_2269 < 0.0f)) || (_2272 < 0.0f))) {
              _2293 = abs(_2283);
              _2294 = (_2283 - _2275) / _2293;
              _2296 = (_2283 - _2278) / _2293;
              _2298 = (_2283 - _2281) / _2293;
              if (!(_2294 < 0.8149999976158142f)) {
                _2301 = _2294 + -0.8149999976158142f;
                _2313 = ((_2301 / exp2(log2(exp2(log2(_2301 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _2313 = _2294;
              }
              if (!(_2296 < 0.8029999732971191f)) {
                _2316 = _2296 + -0.8029999732971191f;
                _2328 = ((_2316 / exp2(log2(exp2(log2(_2316 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _2328 = _2296;
              }
              if (!(_2298 < 0.8799999952316284f)) {
                _2331 = _2298 + -0.8799999952316284f;
                _2343 = ((_2331 / exp2(log2(exp2(log2(_2331 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2343 = _2298;
              }
              _2351 = (_2283 - (_2293 * _2313));
              _2352 = (_2283 - (_2293 * _2328));
              _2353 = (_2283 - (_2293 * _2343));
            } else {
              _2351 = _2275;
              _2352 = _2278;
              _2353 = _2281;
            }
          } else {
            _2351 = _2275;
            _2352 = _2278;
            _2353 = _2281;
          }
          _2369 = ((mad(0.16386906802654266f, _2353, mad(0.14067870378494263f, _2352, (_2351 * 0.6954522132873535f))) - _2266) * cb0_012w) + _2266;
          _2370 = ((mad(0.0955343171954155f, _2353, mad(0.8596711158752441f, _2352, (_2351 * 0.044794563204050064f))) - _2269) * cb0_012w) + _2269;
          _2371 = ((mad(1.0015007257461548f, _2353, mad(0.004025210160762072f, _2352, (_2351 * -0.005525882821530104f))) - _2272) * cb0_012w) + _2272;
          _2375 = max(max(_2369, _2370), _2371);
          _2380 = (max(_2375, 1.000000013351432e-10f) - max(min(min(_2369, _2370), _2371), 1.000000013351432e-10f)) / max(_2375, 0.009999999776482582f);
          _2393 = ((_2370 + _2369) + _2371) + (sqrt((((_2371 - _2370) * _2371) + ((_2370 - _2369) * _2370)) + ((_2369 - _2371) * _2369)) * 1.75f);
          _2394 = _2393 * 0.3333333432674408f;
          _2395 = _2380 + -0.4000000059604645f;
          _2396 = _2395 * 5.0f;
          _2400 = max((1.0f - abs(_2395 * 2.5f)), 0.0f);
          _2411 = ((float((int)(((int)(uint)((int)(_2396 > 0.0f))) - ((int)(uint)((int)(_2396 < 0.0f))))) * (1.0f - (_2400 * _2400))) + 1.0f) * 0.02500000037252903f;
          if (_2394 > 0.0533333346247673f) {
            if (_2394 < 0.1599999964237213f) {
              _2420 = (((0.23999999463558197f / _2393) + -0.5f) * _2411);
            } else {
              _2420 = 0.0f;
            }
          } else {
            _2420 = _2411;
          }
          _2421 = _2420 + 1.0f;
          _2422 = _2421 * _2369;
          _2423 = _2421 * _2370;
          _2424 = _2421 * _2371;
          if (!((_2422 == _2423) && (_2423 == _2424))) {
            _2431 = ((_2422 * 2.0f) - _2423) - _2424;
            _2434 = ((_2370 - _2371) * 1.7320507764816284f) * _2421;
            _2436 = atan(_2434 / _2431);
            _2439 = (_2431 < 0.0f);
            _2440 = (_2431 == 0.0f);
            _2441 = (_2434 >= 0.0f);
            _2442 = (_2434 < 0.0f);
            _2453 = select((_2441 && _2440), 90.0f, select((_2442 && _2440), -90.0f, (select((_2442 && _2439), (_2436 + -3.1415927410125732f), select((_2441 && _2439), (_2436 + 3.1415927410125732f), _2436)) * 57.2957763671875f)));
          } else {
            _2453 = 0.0f;
          }
          _2458 = min(max(select((_2453 < 0.0f), (_2453 + 360.0f), _2453), 0.0f), 360.0f);
          if (_2458 < -180.0f) {
            _2467 = (_2458 + 360.0f);
          } else {
            if (_2458 > 180.0f) {
              _2467 = (_2458 + -360.0f);
            } else {
              _2467 = _2458;
            }
          }
          if ((_2467 > -67.5f) && (_2467 < 67.5f)) {
            _2473 = (_2467 + 67.5f) * 0.029629629105329514f;
            _2474 = int(_2473);
            _2476 = _2473 - float((int)(_2474));
            _2477 = _2476 * _2476;
            _2478 = _2477 * _2476;
            if (_2474 == 3) {
              _2506 = (((0.1666666716337204f - (_2476 * 0.5f)) + (_2477 * 0.5f)) - (_2478 * 0.1666666716337204f));
            } else {
              if (_2474 == 2) {
                _2506 = ((0.6666666865348816f - _2477) + (_2478 * 0.5f));
              } else {
                if (_2474 == 1) {
                  _2506 = (((_2478 * -0.5f) + 0.1666666716337204f) + ((_2477 + _2476) * 0.5f));
                } else {
                  _2506 = select((_2474 == 0), (_2478 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2506 = 0.0f;
          }
          _2515 = min(max(((((_2380 * 0.27000001072883606f) * (0.029999999329447746f - _2422)) * _2506) + _2422), 0.0f), 65535.0f);
          _2516 = min(max(_2423, 0.0f), 65535.0f);
          _2517 = min(max(_2424, 0.0f), 65535.0f);
          _2530 = min(max(mad(-0.21492856740951538f, _2517, mad(-0.2365107536315918f, _2516, (_2515 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2531 = min(max(mad(-0.09967592358589172f, _2517, mad(1.17622971534729f, _2516, (_2515 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2532 = min(max(mad(0.9977163076400757f, _2517, mad(-0.006032449658960104f, _2516, (_2515 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2533 = dot(float3(_2530, _2531, _2532), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
          _2556 = log2(max((lerp(_2533, _2530, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2557 = _2556 * 0.3010300099849701f;
          _2558 = log2(cb0_008x);
          _2559 = _2558 * 0.3010300099849701f;
          if (_2557 > _2559) {
            _2566 = log2(cb0_009x);
            _2567 = _2566 * 0.3010300099849701f;
            if ((_2557 > _2559) && (_2557 < _2567)) {
              _2575 = ((_2556 - _2558) * 0.9030900001525879f) / ((_2566 - _2558) * 0.3010300099849701f);
              _2576 = int(_2575);
              _2578 = _2575 - float((int)(_2576));
              _2580 = _16[min((uint)(_2576), 5u)];
              _2583 = _16[min((uint)((_2576 + 1)), 5u)];
              _2588 = _2580 * 0.5f;
              _2628 = dot(float3((_2578 * _2578), _2578, 1.0f), float3(mad((_16[min((uint)((_2576 + 2)), 5u)]), 0.5f, mad(_2583, -1.0f, _2588)), (_2583 - _2580), mad(_2583, 0.5f, _2588)));
            } else {
              if (_2557 < _2567) {
                _2628 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2597 = log2(cb0_008z);
                if (!(_2557 < (_2597 * 0.3010300099849701f))) {
                  _2628 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2605 = ((_2556 - _2566) * 0.9030900001525879f) / ((_2597 - _2566) * 0.3010300099849701f);
                  _2606 = int(_2605);
                  _2608 = _2605 - float((int)(_2606));
                  _2610 = _17[min((uint)(_2606), 5u)];
                  _2613 = _17[min((uint)((_2606 + 1)), 5u)];
                  _2618 = _2610 * 0.5f;
                  _2628 = dot(float3((_2608 * _2608), _2608, 1.0f), float3(mad((_17[min((uint)((_2606 + 2)), 5u)]), 0.5f, mad(_2613, -1.0f, _2618)), (_2613 - _2610), mad(_2613, 0.5f, _2618)));
                }
              }
            }
          } else {
            _2628 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2644 = log2(max((lerp(_2533, _2531, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2645 = _2644 * 0.3010300099849701f;
          if (_2645 > _2559) {
            _2652 = log2(cb0_009x);
            _2653 = _2652 * 0.3010300099849701f;
            if ((_2645 > _2559) && (_2645 < _2653)) {
              _2661 = ((_2644 - _2558) * 0.9030900001525879f) / ((_2652 - _2558) * 0.3010300099849701f);
              _2662 = int(_2661);
              _2664 = _2661 - float((int)(_2662));
              _2666 = _12[min((uint)(_2662), 5u)];
              _2669 = _12[min((uint)((_2662 + 1)), 5u)];
              _2674 = _2666 * 0.5f;
              _2714 = dot(float3((_2664 * _2664), _2664, 1.0f), float3(mad((_12[min((uint)((_2662 + 2)), 5u)]), 0.5f, mad(_2669, -1.0f, _2674)), (_2669 - _2666), mad(_2669, 0.5f, _2674)));
            } else {
              if (_2645 < _2653) {
                _2714 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2683 = log2(cb0_008z);
                if (!(_2645 < (_2683 * 0.3010300099849701f))) {
                  _2714 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2691 = ((_2644 - _2652) * 0.9030900001525879f) / ((_2683 - _2652) * 0.3010300099849701f);
                  _2692 = int(_2691);
                  _2694 = _2691 - float((int)(_2692));
                  _2696 = _13[min((uint)(_2692), 5u)];
                  _2699 = _13[min((uint)((_2692 + 1)), 5u)];
                  _2704 = _2696 * 0.5f;
                  _2714 = dot(float3((_2694 * _2694), _2694, 1.0f), float3(mad((_13[min((uint)((_2692 + 2)), 5u)]), 0.5f, mad(_2699, -1.0f, _2704)), (_2699 - _2696), mad(_2699, 0.5f, _2704)));
                }
              }
            }
          } else {
            _2714 = (log2(cb0_008y) * 0.3010300099849701f);
          }
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
          _2730 = log2(max((lerp(_2533, _2532, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2731 = _2730 * 0.3010300099849701f;
          if (_2731 > _2559) {
            _2738 = log2(cb0_009x);
            _2739 = _2738 * 0.3010300099849701f;
            if ((_2731 > _2559) && (_2731 < _2739)) {
              _2747 = ((_2730 - _2558) * 0.9030900001525879f) / ((_2738 - _2558) * 0.3010300099849701f);
              _2748 = int(_2747);
              _2750 = _2747 - float((int)(_2748));
              _2752 = _14[min((uint)(_2748), 5u)];
              _2755 = _14[min((uint)((_2748 + 1)), 5u)];
              _2760 = _2752 * 0.5f;
              _2800 = dot(float3((_2750 * _2750), _2750, 1.0f), float3(mad((_14[min((uint)((_2748 + 2)), 5u)]), 0.5f, mad(_2755, -1.0f, _2760)), (_2755 - _2752), mad(_2755, 0.5f, _2760)));
            } else {
              if (_2731 < _2739) {
                _2800 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2769 = log2(cb0_008z);
                if (!(_2731 < (_2769 * 0.3010300099849701f))) {
                  _2800 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2777 = ((_2730 - _2738) * 0.9030900001525879f) / ((_2769 - _2738) * 0.3010300099849701f);
                  _2778 = int(_2777);
                  _2780 = _2777 - float((int)(_2778));
                  _2782 = _15[min((uint)(_2778), 5u)];
                  _2785 = _15[min((uint)((_2778 + 1)), 5u)];
                  _2790 = _2782 * 0.5f;
                  _2800 = dot(float3((_2780 * _2780), _2780, 1.0f), float3(mad((_15[min((uint)((_2778 + 2)), 5u)]), 0.5f, mad(_2785, -1.0f, _2790)), (_2785 - _2782), mad(_2785, 0.5f, _2790)));
                }
              }
            }
          } else {
            _2800 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2804 = cb0_008w - cb0_008y;
          _2805 = (exp2(_2628 * 3.321928024291992f) - cb0_008y) / _2804;
          _2807 = (exp2(_2714 * 3.321928024291992f) - cb0_008y) / _2804;
          _2809 = (exp2(_2800 * 3.321928024291992f) - cb0_008y) / _2804;
          _2812 = mad(0.15618768334388733f, _2809, mad(0.13400420546531677f, _2807, (_2805 * 0.6624541878700256f)));
          _2815 = mad(0.053689517080783844f, _2809, mad(0.6740817427635193f, _2807, (_2805 * 0.2722287178039551f)));
          _2818 = mad(1.0103391408920288f, _2809, mad(0.00406073359772563f, _2807, (_2805 * -0.005574649665504694f)));
          _2831 = min(max(mad(-0.23642469942569733f, _2818, mad(-0.32480329275131226f, _2815, (_2812 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2832 = min(max(mad(0.016756348311901093f, _2818, mad(1.6153316497802734f, _2815, (_2812 * -0.663662850856781f))), 0.0f), 1.0f);
          _2833 = min(max(mad(0.9883948564529419f, _2818, mad(-0.008284442126750946f, _2815, (_2812 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2836 = mad(0.15618768334388733f, _2833, mad(0.13400420546531677f, _2832, (_2831 * 0.6624541878700256f)));
          _2839 = mad(0.053689517080783844f, _2833, mad(0.6740817427635193f, _2832, (_2831 * 0.2722287178039551f)));
          _2842 = mad(1.0103391408920288f, _2833, mad(0.00406073359772563f, _2832, (_2831 * -0.005574649665504694f)));
          _2864 = min(max((min(max(mad(-0.23642469942569733f, _2842, mad(-0.32480329275131226f, _2839, (_2836 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2865 = min(max((min(max(mad(0.016756348311901093f, _2842, mad(1.6153316497802734f, _2839, (_2836 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2866 = min(max((min(max(mad(0.9883948564529419f, _2842, mad(-0.008284442126750946f, _2839, (_2836 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          if (!(cb0_040w == 6)) {
            _2879 = mad(_55, _2866, mad(_54, _2865, (_2864 * _53)));
            _2880 = mad(_58, _2866, mad(_57, _2865, (_2864 * _56)));
            _2881 = mad(_61, _2866, mad(_60, _2865, (_2864 * _59)));
          } else {
            _2879 = _2864;
            _2880 = _2865;
            _2881 = _2866;
          }
          _2891 = exp2(log2(_2879 * 9.999999747378752e-05f) * 0.1593017578125f);
          _2892 = exp2(log2(_2880 * 9.999999747378752e-05f) * 0.1593017578125f);
          _2893 = exp2(log2(_2881 * 9.999999747378752e-05f) * 0.1593017578125f);
          _3058 = exp2(log2((1.0f / ((_2891 * 18.6875f) + 1.0f)) * ((_2891 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3059 = exp2(log2((1.0f / ((_2892 * 18.6875f) + 1.0f)) * ((_2892 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3060 = exp2(log2((1.0f / ((_2893 * 18.6875f) + 1.0f)) * ((_2893 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        } else {
          if (cb0_040w == 7) {
            _2938 = mad((WorkingColorSpace_128[0].z), _1376, mad((WorkingColorSpace_128[0].y), _1375, ((WorkingColorSpace_128[0].x) * _1374)));
            _2941 = mad((WorkingColorSpace_128[1].z), _1376, mad((WorkingColorSpace_128[1].y), _1375, ((WorkingColorSpace_128[1].x) * _1374)));
            _2944 = mad((WorkingColorSpace_128[2].z), _1376, mad((WorkingColorSpace_128[2].y), _1375, ((WorkingColorSpace_128[2].x) * _1374)));
            _2963 = exp2(log2(mad(_55, _2944, mad(_54, _2941, (_2938 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2964 = exp2(log2(mad(_58, _2944, mad(_57, _2941, (_2938 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2965 = exp2(log2(mad(_61, _2944, mad(_60, _2941, (_2938 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3058 = exp2(log2((1.0f / ((_2963 * 18.6875f) + 1.0f)) * ((_2963 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3059 = exp2(log2((1.0f / ((_2964 * 18.6875f) + 1.0f)) * ((_2964 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3060 = exp2(log2((1.0f / ((_2965 * 18.6875f) + 1.0f)) * ((_2965 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                _3012 = mad((WorkingColorSpace_128[0].z), _1364, mad((WorkingColorSpace_128[0].y), _1363, ((WorkingColorSpace_128[0].x) * _1362)));
                _3015 = mad((WorkingColorSpace_128[1].z), _1364, mad((WorkingColorSpace_128[1].y), _1363, ((WorkingColorSpace_128[1].x) * _1362)));
                _3018 = mad((WorkingColorSpace_128[2].z), _1364, mad((WorkingColorSpace_128[2].y), _1363, ((WorkingColorSpace_128[2].x) * _1362)));
                _3058 = mad(_55, _3018, mad(_54, _3015, (_3012 * _53)));
                _3059 = mad(_58, _3018, mad(_57, _3015, (_3012 * _56)));
                _3060 = mad(_61, _3018, mad(_60, _3015, (_3012 * _59)));
              } else {
                _3031 = mad((WorkingColorSpace_128[0].z), _1390, mad((WorkingColorSpace_128[0].y), _1389, ((WorkingColorSpace_128[0].x) * _1388)));
                _3034 = mad((WorkingColorSpace_128[1].z), _1390, mad((WorkingColorSpace_128[1].y), _1389, ((WorkingColorSpace_128[1].x) * _1388)));
                _3037 = mad((WorkingColorSpace_128[2].z), _1390, mad((WorkingColorSpace_128[2].y), _1389, ((WorkingColorSpace_128[2].x) * _1388)));
                _3058 = exp2(log2(mad(_55, _3037, mad(_54, _3034, (_3031 * _53)))) * cb0_040z);
                _3059 = exp2(log2(mad(_58, _3037, mad(_57, _3034, (_3031 * _56)))) * cb0_040z);
                _3060 = exp2(log2(mad(_61, _3037, mad(_60, _3034, (_3031 * _59)))) * cb0_040z);
              }
            } else {
              _3058 = _1374;
              _3059 = _1375;
              _3060 = _1376;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_3058 * 0.9523810148239136f);
  SV_Target.y = (_3059 * 0.9523810148239136f);
  SV_Target.z = (_3060 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
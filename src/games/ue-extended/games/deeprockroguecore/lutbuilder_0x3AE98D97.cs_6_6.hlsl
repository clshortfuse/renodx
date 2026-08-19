// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float> t1 : register(t1);

Texture2D<float3> t2 : register(t2);

Texture2D<float> t3 : register(t3);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_012z : packoffset(c012.z);
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
  float cb0_043y : packoffset(c043.y);
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
  float _25;
  float _30;
  float _31;
  float _32;
  float _34;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _120;
  float _121;
  float _122;
  float _177;
  float _384;
  float _385;
  float _386;
  float _909;
  float _942;
  float _956;
  float _1020;
  float _1199;
  float _1210;
  float _1221;
  float _1392;
  float _1393;
  float _1394;
  float _1405;
  float _1416;
  float _1626;
  float _1633;
  float _1640;
  float _1723;
  float _1906;
  float _1929;
  float _1932;
  int _1942;
  int _1943;
  int _1944;
  float _2002;
  float _2032;
  float _2040;
  float _2064;
  float _2070;
  float _2149;
  float _2164;
  float _2172;
  float _2220;
  float _2226;
  float _2227;
  float _2238;
  float _2289;
  float _2296;
  float _2303;
  float _2547;
  float _2554;
  float _2561;
  float _2644;
  float _2827;
  float _2850;
  float _2853;
  int _2863;
  int _2864;
  int _2865;
  float _2923;
  float _2953;
  float _2961;
  float _2985;
  float _2991;
  float _3070;
  float _3085;
  float _3093;
  float _3141;
  float _3147;
  float _3148;
  float _3159;
  float _3210;
  float _3217;
  float _3224;
  float _3422;
  float _3423;
  float _3424;
  bool _43;
  float _73;
  float _74;
  float _75;
  bool _158;
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
  float _401;
  float _404;
  float _407;
  float _408;
  float _412;
  float _413;
  float _414;
  float _426;
  float _442;
  float _443;
  float _444;
  float _445;
  float _459;
  float _473;
  float _487;
  float _501;
  float _515;
  float _519;
  float _520;
  float _521;
  float _578;
  float _582;
  float _583;
  float _592;
  float _601;
  float _610;
  float _619;
  float _628;
  float _691;
  float _695;
  float _704;
  float _713;
  float _722;
  float _731;
  float _740;
  float _798;
  float _809;
  float _811;
  float _813;
  float _849;
  float _850;
  float _851;
  float _854;
  float _857;
  float _860;
  float _864;
  float _869;
  float _882;
  float _883;
  float _884;
  float _885;
  float _889;
  float _900;
  float _910;
  float _911;
  float _912;
  float _913;
  float _920;
  float _923;
  float _925;
  bool _928;
  bool _929;
  bool _930;
  bool _931;
  float _947;
  float _960;
  float _964;
  float _970;
  float _980;
  float _981;
  float _982;
  float _983;
  float _998;
  float _1000;
  float _1002;
  float _1011;
  float _1023;
  float _1025;
  float _1029;
  float _1030;
  float _1031;
  float _1035;
  float _1036;
  float _1037;
  float _1038;
  float _1040;
  float _1041;
  float _1042;
  float _1043;
  float _1062;
  float _1064;
  float _1089;
  float _1090;
  float _1091;
  float _1098;
  float _1102;
  float _1103;
  float _1104;
  bool _1105;
  float _1109;
  float _1110;
  float _1111;
  float _1130;
  float _1131;
  float _1132;
  float _1133;
  float _1153;
  float _1154;
  float _1155;
  float _1171;
  float _1172;
  float _1173;
  float _1186;
  float _1187;
  float _1188;
  float _1225;
  float _1232;
  float _1233;
  float _1234;
  float _1236;
  float4 _1239;
  float4 _1244;
  float _1260;
  float _1261;
  float _1262;
  float _1287;
  float _1288;
  float _1289;
  float _1315;
  float _1316;
  float _1317;
  float _1324;
  float _1325;
  float _1326;
  float _1327;
  float _1328;
  float _1329;
  float _1336;
  float _1337;
  float _1338;
  float _1350;
  float _1351;
  float _1352;
  float _1375;
  float _1378;
  float _1381;
  float _1443;
  float _1446;
  float _1449;
  float _1452;
  float _1455;
  float _1458;
  float _1503;
  float _1504;
  float _1505;
  float _1508;
  float _1511;
  float _1514;
  float _1515;
  float _1516;
  float _1521;
  float _1536;
  float _1538;
  float _1543;
  float _1584;
  float _1588;
  float _1589;
  float _1590;
  float _1593;
  float _1600;
  float _1601;
  float _1611;
  float _1612;
  float _1613;
  float _1617;
  float _1618;
  float _1619;
  float _1668;
  float _1669;
  float _1670;
  float _1674;
  float _1678;
  float _1680;
  bool _1683;
  bool _1684;
  bool _1685;
  bool _1686;
  float _1695;
  float _1699;
  float _1702;
  float _1705;
  float _1714;
  float _1728;
  float _1743;
  float _1745;
  float _1749;
  float _1750;
  float _1751;
  float _1758;
  float _1759;
  float _1769;
  float _1774;
  float _1789;
  float _1794;
  float _1799;
  float _1814;
  float _1816;
  float _1817;
  float _1819;
  float _1820;
  float _1822;
  float _1824;
  float _1825;
  float _1826;
  float _1827;
  float _1828;
  float _1829;
  float _1844;
  float _1850;
  int _1854;
  int _1856;
  float _1865;
  float _1870;
  float _1871;
  float _1872;
  float _1873;
  float _1874;
  float _1881;
  float _1887;
  float _1891;
  float _1894;
  float _1896;
  float _1907;
  float _1910;
  float _1914;
  float _1917;
  float _1919;
  float _1935;
  float _1938;
  int _1939;
  int _1940;
  bool _1948;
  int _1949;
  int _1950;
  float3 _1957;
  float3 _1961;
  float _1967;
  float _1970;
  float _1984;
  float _1985;
  float _1986;
  float _1988;
  float _2003;
  uint2 _2005;
  float _2009;
  float _2013;
  float _2018;
  float _2019;
  bool _2021;
  float _2022;
  float _2045;
  float _2051;
  bool _2053;
  float _2054;
  float _2075;
  float _2081;
  float _2083;
  float _2087;
  float _2096;
  float _2107;
  float _2109;
  float _2113;
  float _2114;
  float _2120;
  float _2121;
  float _2122;
  int _2123;
  float _2131;
  float _2135;
  float _2150;
  float _2151;
  bool _2153;
  float _2154;
  float _2177;
  float _2183;
  float _2200;
  float _2202;
  float _2203;
  float _2208;
  float _2210;
  float _2228;
  float _2229;
  float _2240;
  float _2242;
  float _2249;
  float _2250;
  float _2251;
  float _2271;
  float _2272;
  float _2273;
  float _2280;
  float _2281;
  float _2282;
  float _2304;
  float _2306;
  float _2308;
  float _2311;
  float _2318;
  float _2319;
  float _2332;
  float _2333;
  float _2334;
  float _2337;
  float _2340;
  float _2343;
  float _2353;
  float _2354;
  float _2355;
  float _2374;
  float _2375;
  float _2376;
  float _2424;
  float _2425;
  float _2426;
  float _2429;
  float _2432;
  float _2435;
  float _2436;
  float _2437;
  float _2442;
  float _2457;
  float _2459;
  float _2464;
  float _2505;
  float _2509;
  float _2510;
  float _2511;
  float _2514;
  float _2521;
  float _2522;
  float _2532;
  float _2533;
  float _2534;
  float _2538;
  float _2539;
  float _2540;
  float _2589;
  float _2590;
  float _2591;
  float _2595;
  float _2599;
  float _2601;
  bool _2604;
  bool _2605;
  bool _2606;
  bool _2607;
  float _2616;
  float _2620;
  float _2623;
  float _2626;
  float _2635;
  float _2649;
  float _2664;
  float _2666;
  float _2670;
  float _2671;
  float _2672;
  float _2679;
  float _2680;
  float _2690;
  float _2695;
  float _2710;
  float _2715;
  float _2720;
  float _2735;
  float _2737;
  float _2738;
  float _2740;
  float _2741;
  float _2743;
  float _2745;
  float _2746;
  float _2747;
  float _2748;
  float _2749;
  float _2750;
  float _2765;
  float _2771;
  int _2775;
  int _2777;
  float _2786;
  float _2791;
  float _2792;
  float _2793;
  float _2794;
  float _2795;
  float _2802;
  float _2808;
  float _2812;
  float _2815;
  float _2817;
  float _2828;
  float _2831;
  float _2835;
  float _2838;
  float _2840;
  float _2856;
  float _2859;
  int _2860;
  int _2861;
  bool _2869;
  int _2870;
  int _2871;
  float3 _2878;
  float3 _2882;
  float _2888;
  float _2891;
  float _2905;
  float _2906;
  float _2907;
  float _2909;
  float _2924;
  uint2 _2926;
  float _2930;
  float _2934;
  float _2939;
  float _2940;
  bool _2942;
  float _2943;
  float _2966;
  float _2972;
  bool _2974;
  float _2975;
  float _2996;
  float _3002;
  float _3004;
  float _3008;
  float _3017;
  float _3028;
  float _3030;
  float _3034;
  float _3035;
  float _3041;
  float _3042;
  float _3043;
  int _3044;
  float _3052;
  float _3056;
  float _3071;
  float _3072;
  bool _3074;
  float _3075;
  float _3098;
  float _3104;
  float _3121;
  float _3123;
  float _3124;
  float _3129;
  float _3131;
  float _3149;
  float _3150;
  float _3161;
  float _3163;
  float _3170;
  float _3171;
  float _3172;
  float _3192;
  float _3193;
  float _3194;
  float _3201;
  float _3202;
  float _3203;
  float _3225;
  float _3227;
  float _3229;
  float _3232;
  float _3239;
  float _3240;
  float _3253;
  float _3254;
  float _3255;
  float _3258;
  float _3261;
  float _3264;
  float _3267;
  float _3274;
  float _3275;
  float _3302;
  float _3305;
  float _3308;
  float _3327;
  float _3328;
  float _3329;
  float _3376;
  float _3379;
  float _3382;
  float _3395;
  float _3398;
  float _3401;
  _25 = 0.5f / cb0_037x;
  _30 = cb0_037x + -1.0f;
  _31 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _25)) / _30;
  _32 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _25)) / _30;
  _34 = float((uint)SV_DispatchThreadID.z) / _30;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _43 = (cb0_043x == 4);
        _54 = select(_43, 1.0f, 1.705051064491272f);
        _55 = select(_43, 0.0f, -0.6217921376228333f);
        _56 = select(_43, 0.0f, -0.0832589864730835f);
        _57 = select(_43, 0.0f, -0.13025647401809692f);
        _58 = select(_43, 1.0f, 1.140804648399353f);
        _59 = select(_43, 0.0f, -0.010548308491706848f);
        _60 = select(_43, 0.0f, -0.024003351107239723f);
        _61 = select(_43, 0.0f, -0.1289689838886261f);
        _62 = select(_43, 1.0f, 1.1529725790023804f);
      } else {
        _54 = 0.6954522132873535f;
        _55 = 0.14067870378494263f;
        _56 = 0.16386906802654266f;
        _57 = 0.044794563204050064f;
        _58 = 0.8596711158752441f;
        _59 = 0.0955343171954155f;
        _60 = -0.005525882821530104f;
        _61 = 0.004025210160762072f;
        _62 = 1.0015007257461548f;
      }
    } else {
      _54 = 1.0258246660232544f;
      _55 = -0.020053181797266006f;
      _56 = -0.005771636962890625f;
      _57 = -0.002234415616840124f;
      _58 = 1.0045864582061768f;
      _59 = -0.002352118492126465f;
      _60 = -0.005013350863009691f;
      _61 = -0.025290070101618767f;
      _62 = 1.0303035974502563f;
    }
  } else {
    _54 = 1.3792141675949097f;
    _55 = -0.30886411666870117f;
    _56 = -0.0703500509262085f;
    _57 = -0.06933490186929703f;
    _58 = 1.08229660987854f;
    _59 = -0.012961871922016144f;
    _60 = -0.0021590073592960835f;
    _61 = -0.0454593189060688f;
    _62 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _73 = (pow(_31, 0.012683313339948654f));
    _74 = (pow(_32, 0.012683313339948654f));
    _75 = (pow(_34, 0.012683313339948654f));
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _122 = (exp2(log2(max(0.0f, (_75 + -0.8359375f)) / (18.8515625f - (_75 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _120 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _121 = ((exp2((_32 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _122 = ((exp2((_34 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _158 = (cb0_040w != 0);
    _160 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _177 = (((((1901800.0f - (_160 * 2006400000.0f)) * _160) + 247.47999572753906f) * _160) + 0.23703999817371368f);
    } else {
      _177 = (((((2967800.0f - (_160 * 4607000064.0f)) * _160) + 99.11000061035156f) * _160) + 0.24406300485134125f);
    }
    _191 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _198 = cb0_037y * cb0_037y;
    _201 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_198 * 1.6145605741257896e-07f));
    _206 = ((_191 * 2.0f) + 4.0f) - (_201 * 8.0f);
    _207 = (_191 * 3.0f) / _206;
    _209 = (_201 * 2.0f) / _206;
    _210 = (cb0_037y < 4000.0f);
    _219 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _221 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_198 * 1.5317699909210205f)) / (_219 * _219);
    _228 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _198;
    _230 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_198 * 308.60699462890625f)) / (_228 * _228);
    _232 = rsqrt(dot(float2(_221, _230), float2(_221, _230)));
    _233 = cb0_037z * 0.05000000074505806f;
    _236 = ((_233 * _230) * _232) + _191;
    _239 = _201 - ((_233 * _221) * _232);
    _244 = (4.0f - (_239 * 8.0f)) + (_236 * 2.0f);
    _250 = (((_236 * 3.0f) / _244) - _207) + select(_210, _207, _177);
    _251 = (((_239 * 2.0f) / _244) - _209) + select(_210, _209, (((_177 * 2.869999885559082f) + -0.2750000059604645f) - ((_177 * _177) * 3.0f)));
    _252 = select(_158, _250, 0.3127000033855438f);
    _253 = select(_158, _251, 0.32899999618530273f);
    _254 = select(_158, 0.3127000033855438f, _250);
    _255 = select(_158, 0.32899999618530273f, _251);
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
    _384 = mad(mad((WorkingColorSpace_064[0].z), _346, mad((WorkingColorSpace_064[0].y), _337, (_328 * (WorkingColorSpace_064[0].x)))), _122, mad(mad((WorkingColorSpace_064[0].z), _343, mad((WorkingColorSpace_064[0].y), _334, (_325 * (WorkingColorSpace_064[0].x)))), _121, (mad((WorkingColorSpace_064[0].z), _340, mad((WorkingColorSpace_064[0].y), _331, (_322 * (WorkingColorSpace_064[0].x)))) * _120)));
    _385 = mad(mad((WorkingColorSpace_064[1].z), _346, mad((WorkingColorSpace_064[1].y), _337, (_328 * (WorkingColorSpace_064[1].x)))), _122, mad(mad((WorkingColorSpace_064[1].z), _343, mad((WorkingColorSpace_064[1].y), _334, (_325 * (WorkingColorSpace_064[1].x)))), _121, (mad((WorkingColorSpace_064[1].z), _340, mad((WorkingColorSpace_064[1].y), _331, (_322 * (WorkingColorSpace_064[1].x)))) * _120)));
    _386 = mad(mad((WorkingColorSpace_064[2].z), _346, mad((WorkingColorSpace_064[2].y), _337, (_328 * (WorkingColorSpace_064[2].x)))), _122, mad(mad((WorkingColorSpace_064[2].z), _343, mad((WorkingColorSpace_064[2].y), _334, (_325 * (WorkingColorSpace_064[2].x)))), _121, (mad((WorkingColorSpace_064[2].z), _340, mad((WorkingColorSpace_064[2].y), _331, (_322 * (WorkingColorSpace_064[2].x)))) * _120)));
  } else {
    _384 = _120;
    _385 = _121;
    _386 = _122;
  }
  _401 = mad((WorkingColorSpace_128[0].z), _386, mad((WorkingColorSpace_128[0].y), _385, ((WorkingColorSpace_128[0].x) * _384)));
  _404 = mad((WorkingColorSpace_128[1].z), _386, mad((WorkingColorSpace_128[1].y), _385, ((WorkingColorSpace_128[1].x) * _384)));
  _407 = mad((WorkingColorSpace_128[2].z), _386, mad((WorkingColorSpace_128[2].y), _385, ((WorkingColorSpace_128[2].x) * _384)));
  _408 = dot(float3(_401, _404, _407), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _412 = (_401 / _408) + -1.0f;
  _413 = (_404 / _408) + -1.0f;
  _414 = (_407 / _408) + -1.0f;
  _426 = (1.0f - exp2(((_408 * _408) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_412, _413, _414), float3(_412, _413, _414)) * -4.0f));
  _442 = ((mad(-0.06368321925401688f, _407, mad(-0.3292922377586365f, _404, (_401 * 1.3704125881195068f))) - _401) * _426) + _401;
  _443 = ((mad(-0.010861365124583244f, _407, mad(1.0970927476882935f, _404, (_401 * -0.08343357592821121f))) - _404) * _426) + _404;
  _444 = ((mad(1.2036951780319214f, _407, mad(-0.09862580895423889f, _404, (_401 * -0.02579331398010254f))) - _407) * _426) + _407;
  _445 = dot(float3(_442, _443, _444), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _459 = cb0_021w + cb0_026w;
  _473 = cb0_020w * cb0_025w;
  _487 = cb0_019w * cb0_024w;
  _501 = cb0_018w * cb0_023w;
  _515 = cb0_017w * cb0_022w;
  _519 = _442 - _445;
  _520 = _443 - _445;
  _521 = _444 - _445;
  _578 = saturate(_445 / cb0_037w);
  _582 = (_578 * _578) * (3.0f - (_578 * 2.0f));
  _583 = 1.0f - _582;
  _592 = cb0_021w + cb0_036w;
  _601 = cb0_020w * cb0_035w;
  _610 = cb0_019w * cb0_034w;
  _619 = cb0_018w * cb0_033w;
  _628 = cb0_017w * cb0_032w;
  _691 = saturate((_445 - cb0_038x) / (cb0_038y - cb0_038x));
  _695 = (_691 * _691) * (3.0f - (_691 * 2.0f));
  _704 = cb0_021w + cb0_031w;
  _713 = cb0_020w * cb0_030w;
  _722 = cb0_019w * cb0_029w;
  _731 = cb0_018w * cb0_028w;
  _740 = cb0_017w * cb0_027w;
  _798 = _582 - _695;
  _809 = ((_695 * (((cb0_021x + cb0_036x) + _592) + (((cb0_020x * cb0_035x) * _601) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _619) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _628) * _519) + _445)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _610)))))) + (_583 * (((cb0_021x + cb0_026x) + _459) + (((cb0_020x * cb0_025x) * _473) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _501) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _515) * _519) + _445)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _487))))))) + ((((cb0_021x + cb0_031x) + _704) + (((cb0_020x * cb0_030x) * _713) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _731) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _740) * _519) + _445)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _722))))) * _798);
  _811 = ((_695 * (((cb0_021y + cb0_036y) + _592) + (((cb0_020y * cb0_035y) * _601) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _619) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _628) * _520) + _445)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _610)))))) + (_583 * (((cb0_021y + cb0_026y) + _459) + (((cb0_020y * cb0_025y) * _473) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _501) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _515) * _520) + _445)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _487))))))) + ((((cb0_021y + cb0_031y) + _704) + (((cb0_020y * cb0_030y) * _713) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _731) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _740) * _520) + _445)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _722))))) * _798);
  _813 = ((_695 * (((cb0_021z + cb0_036z) + _592) + (((cb0_020z * cb0_035z) * _601) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _619) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _628) * _521) + _445)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _610)))))) + (_583 * (((cb0_021z + cb0_026z) + _459) + (((cb0_020z * cb0_025z) * _473) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _501) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _515) * _521) + _445)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _487))))))) + ((((cb0_021z + cb0_031z) + _704) + (((cb0_020z * cb0_030z) * _713) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _731) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _740) * _521) + _445)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _722))))) * _798);

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
  float4 output = ProcessLutbuilder(float3(_809, _811, _813), s0, t0, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _849 = ((mad(0.061360642313957214f, _813, mad(-4.540197551250458e-09f, _811, (_809 * 0.9386394023895264f))) - _809) * cb0_038z) + _809;
  _850 = ((mad(0.169205904006958f, _813, mad(0.8307942152023315f, _811, (_809 * 6.775371730327606e-08f))) - _811) * cb0_038z) + _811;
  _851 = (mad(-2.3283064365386963e-10f, _811, (_809 * -9.313225746154785e-10f)) * cb0_038z) + _813;
  _854 = mad(0.16386905312538147f, _851, mad(0.14067868888378143f, _850, (_849 * 0.6954522132873535f)));
  _857 = mad(0.0955343246459961f, _851, mad(0.8596711158752441f, _850, (_849 * 0.044794581830501556f)));
  _860 = mad(1.0015007257461548f, _851, mad(0.004025210160762072f, _850, (_849 * -0.005525882821530104f)));
  _864 = max(max(_854, _857), _860);
  _869 = (max(_864, 1.000000013351432e-10f) - max(min(min(_854, _857), _860), 1.000000013351432e-10f)) / max(_864, 0.009999999776482582f);
  _882 = ((_857 + _854) + _860) + (sqrt((((_860 - _857) * _860) + ((_857 - _854) * _857)) + ((_854 - _860) * _854)) * 1.75f);
  _883 = _882 * 0.3333333432674408f;
  _884 = _869 + -0.4000000059604645f;
  _885 = _884 * 5.0f;
  _889 = max((1.0f - abs(_884 * 2.5f)), 0.0f);
  _900 = ((float((int)(((int)(uint)((int)(_885 > 0.0f))) - ((int)(uint)((int)(_885 < 0.0f))))) * (1.0f - (_889 * _889))) + 1.0f) * 0.02500000037252903f;
  if (_883 > 0.0533333346247673f) {
    if (_883 < 0.1599999964237213f) {
      _909 = (((0.23999999463558197f / _882) + -0.5f) * _900);
    } else {
      _909 = 0.0f;
    }
  } else {
    _909 = _900;
  }
  _910 = _909 + 1.0f;
  _911 = _910 * _854;
  _912 = _910 * _857;
  _913 = _910 * _860;
  if (!((_911 == _912) && (_912 == _913))) {
    _920 = ((_911 * 2.0f) - _912) - _913;
    _923 = ((_857 - _860) * 1.7320507764816284f) * _910;
    _925 = atan(_923 / _920);
    _928 = (_920 < 0.0f);
    _929 = (_920 == 0.0f);
    _930 = (_923 >= 0.0f);
    _931 = (_923 < 0.0f);
    _942 = select((_930 && _929), 90.0f, select((_931 && _929), -90.0f, (select((_931 && _928), (_925 + -3.1415927410125732f), select((_930 && _928), (_925 + 3.1415927410125732f), _925)) * 57.2957763671875f)));
  } else {
    _942 = 0.0f;
  }
  _947 = min(max(select((_942 < 0.0f), (_942 + 360.0f), _942), 0.0f), 360.0f);
  if (_947 < -180.0f) {
    _956 = (_947 + 360.0f);
  } else {
    if (_947 > 180.0f) {
      _956 = (_947 + -360.0f);
    } else {
      _956 = _947;
    }
  }
  _960 = saturate(1.0f - abs(_956 * 0.014814814552664757f));
  _964 = (_960 * _960) * (3.0f - (_960 * 2.0f));
  _970 = ((_964 * _964) * ((_869 * 0.18000000715255737f) * (0.029999999329447746f - _911))) + _911;
  _980 = max(0.0f, mad(-0.21492856740951538f, _913, mad(-0.2365107536315918f, _912, (_970 * 1.4514392614364624f))));
  _981 = max(0.0f, mad(-0.09967592358589172f, _913, mad(1.17622971534729f, _912, (_970 * -0.07655377686023712f))));
  _982 = max(0.0f, mad(0.9977163076400757f, _913, mad(-0.006032449658960104f, _912, (_970 * 0.008316148072481155f))));
  _983 = dot(float3(_980, _981, _982), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _998 = (cb0_040x + 1.0f) - cb0_039z;
  _1000 = cb0_040y + 1.0f;
  _1002 = _1000 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1020 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1011 = (cb0_040x + 0.18000000715255737f) / _998;
    _1020 = (-0.7447274923324585f - ((log2(_1011 / (2.0f - _1011)) * 0.3465735912322998f) * (_998 / cb0_039y)));
  }
  _1023 = ((1.0f - cb0_039z) / cb0_039y) - _1020;
  _1025 = (cb0_039w / cb0_039y) - _1023;
  _1029 = log2(lerp(_983, _980, 0.9599999785423279f)) * 0.3010300099849701f;
  _1030 = log2(lerp(_983, _981, 0.9599999785423279f)) * 0.3010300099849701f;
  _1031 = log2(lerp(_983, _982, 0.9599999785423279f)) * 0.3010300099849701f;
  _1035 = cb0_039y * (_1029 + _1023);
  _1036 = cb0_039y * (_1030 + _1023);
  _1037 = cb0_039y * (_1031 + _1023);
  _1038 = _998 * 2.0f;
  _1040 = (cb0_039y * -2.0f) / _998;
  _1041 = _1029 - _1020;
  _1042 = _1030 - _1020;
  _1043 = _1031 - _1020;
  _1062 = _1002 * 2.0f;
  _1064 = (cb0_039y * 2.0f) / _1002;
  _1089 = select((_1029 < _1020), ((_1038 / (exp2((_1041 * 1.4426950216293335f) * _1040) + 1.0f)) - cb0_040x), _1035);
  _1090 = select((_1030 < _1020), ((_1038 / (exp2((_1042 * 1.4426950216293335f) * _1040) + 1.0f)) - cb0_040x), _1036);
  _1091 = select((_1031 < _1020), ((_1038 / (exp2((_1043 * 1.4426950216293335f) * _1040) + 1.0f)) - cb0_040x), _1037);
  _1098 = _1025 - _1020;
  _1102 = saturate(_1041 / _1098);
  _1103 = saturate(_1042 / _1098);
  _1104 = saturate(_1043 / _1098);
  _1105 = (_1025 < _1020);
  _1109 = select(_1105, (1.0f - _1102), _1102);
  _1110 = select(_1105, (1.0f - _1103), _1103);
  _1111 = select(_1105, (1.0f - _1104), _1104);
  _1130 = (((_1109 * _1109) * (select((_1029 > _1025), (_1000 - (_1062 / (exp2(((_1029 - _1025) * 1.4426950216293335f) * _1064) + 1.0f))), _1035) - _1089)) * (3.0f - (_1109 * 2.0f))) + _1089;
  _1131 = (((_1110 * _1110) * (select((_1030 > _1025), (_1000 - (_1062 / (exp2(((_1030 - _1025) * 1.4426950216293335f) * _1064) + 1.0f))), _1036) - _1090)) * (3.0f - (_1110 * 2.0f))) + _1090;
  _1132 = (((_1111 * _1111) * (select((_1031 > _1025), (_1000 - (_1062 / (exp2(((_1031 - _1025) * 1.4426950216293335f) * _1064) + 1.0f))), _1037) - _1091)) * (3.0f - (_1111 * 2.0f))) + _1091;
  _1133 = dot(float3(_1130, _1131, _1132), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1153 = (cb0_039x * (max(0.0f, (lerp(_1133, _1130, 0.9300000071525574f))) - _849)) + _849;
  _1154 = (cb0_039x * (max(0.0f, (lerp(_1133, _1131, 0.9300000071525574f))) - _850)) + _850;
  _1155 = (cb0_039x * (max(0.0f, (lerp(_1133, _1132, 0.9300000071525574f))) - _851)) + _851;
  _1171 = ((mad(-0.06537103652954102f, _1155, mad(1.451815478503704e-06f, _1154, (_1153 * 1.065374732017517f))) - _1153) * cb0_038z) + _1153;
  _1172 = ((mad(-0.20366770029067993f, _1155, mad(1.2036634683609009f, _1154, (_1153 * -2.57161445915699e-07f))) - _1154) * cb0_038z) + _1154;
  _1173 = ((mad(0.9999996423721313f, _1155, mad(2.0954757928848267e-08f, _1154, (_1153 * 1.862645149230957e-08f))) - _1155) * cb0_038z) + _1155;
  _1186 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1173, mad((WorkingColorSpace_192[0].y), _1172, ((WorkingColorSpace_192[0].x) * _1171)))));
  _1187 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1173, mad((WorkingColorSpace_192[1].y), _1172, ((WorkingColorSpace_192[1].x) * _1171)))));
  _1188 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1173, mad((WorkingColorSpace_192[2].y), _1172, ((WorkingColorSpace_192[2].x) * _1171)))));
  if (_1186 < 0.0031306699384003878f) {
    _1199 = (_1186 * 12.920000076293945f);
  } else {
    _1199 = (((pow(_1186, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1187 < 0.0031306699384003878f) {
    _1210 = (_1187 * 12.920000076293945f);
  } else {
    _1210 = (((pow(_1187, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1188 < 0.0031306699384003878f) {
    _1221 = (_1188 * 12.920000076293945f);
  } else {
    _1221 = (((pow(_1188, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1225 = (_1210 * 0.9375f) + 0.03125f;
  _1232 = _1221 * 15.0f;
  _1233 = floor(_1232);
  _1234 = _1232 - _1233;
  _1236 = (((_1199 * 0.9375f) + 0.03125f) + _1233) * 0.0625f;
  _1239 = t0.SampleLevel(s0, float2(_1236, _1225), 0.0f);
  _1244 = t0.SampleLevel(s0, float2((_1236 + 0.0625f), _1225), 0.0f);
  _1260 = ((lerp(_1239.x, _1244.x, _1234)) * cb0_005y) + (cb0_005x * _1199);
  _1261 = ((lerp(_1239.y, _1244.y, _1234)) * cb0_005y) + (cb0_005x * _1210);
  _1262 = ((lerp(_1239.z, _1244.z, _1234)) * cb0_005y) + (cb0_005x * _1221);
  _1287 = select((_1260 > 0.040449999272823334f), exp2(log2((abs(_1260) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1260 * 0.07739938050508499f));
  _1288 = select((_1261 > 0.040449999272823334f), exp2(log2((abs(_1261) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1261 * 0.07739938050508499f));
  _1289 = select((_1262 > 0.040449999272823334f), exp2(log2((abs(_1262) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1262 * 0.07739938050508499f));
  _1315 = cb0_016x * (((cb0_041y + (cb0_041x * _1287)) * _1287) + cb0_041z);
  _1316 = cb0_016y * (((cb0_041y + (cb0_041x * _1288)) * _1288) + cb0_041z);
  _1317 = cb0_016z * (((cb0_041y + (cb0_041x * _1289)) * _1289) + cb0_041z);
  _1324 = ((cb0_015x - _1315) * cb0_015w) + _1315;
  _1325 = ((cb0_015y - _1316) * cb0_015w) + _1316;
  _1326 = ((cb0_015z - _1317) * cb0_015w) + _1317;
  _1327 = cb0_016x * mad((WorkingColorSpace_192[0].z), _813, mad((WorkingColorSpace_192[0].y), _811, (_809 * (WorkingColorSpace_192[0].x))));
  _1328 = cb0_016y * mad((WorkingColorSpace_192[1].z), _813, mad((WorkingColorSpace_192[1].y), _811, ((WorkingColorSpace_192[1].x) * _809)));
  _1329 = cb0_016z * mad((WorkingColorSpace_192[2].z), _813, mad((WorkingColorSpace_192[2].y), _811, ((WorkingColorSpace_192[2].x) * _809)));
  _1336 = ((cb0_015x - _1327) * cb0_015w) + _1327;
  _1337 = ((cb0_015y - _1328) * cb0_015w) + _1328;
  _1338 = ((cb0_015z - _1329) * cb0_015w) + _1329;
  _1350 = exp2(log2(max(0.0f, _1324)) * cb0_042y);
  _1351 = exp2(log2(max(0.0f, _1325)) * cb0_042y);
  _1352 = exp2(log2(max(0.0f, _1326)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1375 = mad((WorkingColorSpace_128[0].z), _1352, mad((WorkingColorSpace_128[0].y), _1351, ((WorkingColorSpace_128[0].x) * _1350)));
      _1378 = mad((WorkingColorSpace_128[1].z), _1352, mad((WorkingColorSpace_128[1].y), _1351, ((WorkingColorSpace_128[1].x) * _1350)));
      _1381 = mad((WorkingColorSpace_128[2].z), _1352, mad((WorkingColorSpace_128[2].y), _1351, ((WorkingColorSpace_128[2].x) * _1350)));
      _1392 = mad(_56, _1381, mad(_55, _1378, (_1375 * _54)));
      _1393 = mad(_59, _1381, mad(_58, _1378, (_1375 * _57)));
      _1394 = mad(_62, _1381, mad(_61, _1378, (_1375 * _60)));
    } else {
      _1392 = _1350;
      _1393 = _1351;
      _1394 = _1352;
    }
    if (_1392 < 0.0031306699384003878f) {
      _1405 = (_1392 * 12.920000076293945f);
    } else {
      _1405 = (((pow(_1392, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1393 < 0.0031306699384003878f) {
      _1416 = (_1393 * 12.920000076293945f);
    } else {
      _1416 = (((pow(_1393, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1394 < 0.0031306699384003878f) {
      _3422 = _1405;
      _3423 = _1416;
      _3424 = (_1394 * 12.920000076293945f);
    } else {
      _3422 = _1405;
      _3423 = _1416;
      _3424 = (((pow(_1394, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1443 = mad((WorkingColorSpace_128[0].z), _1352, mad((WorkingColorSpace_128[0].y), _1351, ((WorkingColorSpace_128[0].x) * _1350)));
      _1446 = mad((WorkingColorSpace_128[1].z), _1352, mad((WorkingColorSpace_128[1].y), _1351, ((WorkingColorSpace_128[1].x) * _1350)));
      _1449 = mad((WorkingColorSpace_128[2].z), _1352, mad((WorkingColorSpace_128[2].y), _1351, ((WorkingColorSpace_128[2].x) * _1350)));
      _1452 = mad(_56, _1449, mad(_55, _1446, (_1443 * _54)));
      _1455 = mad(_59, _1449, mad(_58, _1446, (_1443 * _57)));
      _1458 = mad(_62, _1449, mad(_61, _1446, (_1443 * _60)));
      _3422 = min((_1452 * 4.5f), ((exp2(log2(max(_1452, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3423 = min((_1455 * 4.5f), ((exp2(log2(max(_1455, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3424 = min((_1458 * 4.5f), ((exp2(log2(max(_1458, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
        _1503 = cb0_012z * _1336;
        _1504 = cb0_012z * _1337;
        _1505 = cb0_012z * _1338;
        _1508 = mad((WorkingColorSpace_256[0].z), _1505, mad((WorkingColorSpace_256[0].y), _1504, (_1503 * (WorkingColorSpace_256[0].x))));
        _1511 = mad((WorkingColorSpace_256[1].z), _1505, mad((WorkingColorSpace_256[1].y), _1504, (_1503 * (WorkingColorSpace_256[1].x))));
        _1514 = mad((WorkingColorSpace_256[2].z), _1505, mad((WorkingColorSpace_256[2].y), _1504, (_1503 * (WorkingColorSpace_256[2].x))));
        _1515 = cb0_043y * 0.009999999776482582f;
        _1516 = log2(_1515);
        _1521 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
        _1536 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_1521 * 400.0f) / (_1521 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1538 = (_1516 * 1.4018198251724243f) + 10.012999534606934f;
        _1543 = exp2(log2(abs(_1538) * 0.00793700572103262f) * 0.41999998688697815f);
        _1584 = (_1516 * 924.7640991210938f) + 1024.0f;
        _1588 = min(max(mad(-0.21492856740951538f, _1514, mad(-0.2365107536315918f, _1511, (_1508 * 1.4514392614364624f))), 0.0f), _1584);
        _1589 = min(max(mad(-0.09967592358589172f, _1514, mad(1.17622971534729f, _1511, (_1508 * -0.07655377686023712f))), 0.0f), _1584);
        _1590 = min(max(mad(0.9977163076400757f, _1514, mad(-0.006032449658960104f, _1511, (_1508 * 0.008316148072481155f))), 0.0f), _1584);
        _1593 = mad(0.15618768334388733f, _1590, mad(0.13400420546531677f, _1589, (_1588 * 0.6624541878700256f)));
        _1600 = mad(0.053689517080783844f, _1590, mad(0.6740817427635193f, _1589, (_1588 * 0.2722287178039551f))) * 100.0f;
        _1601 = mad(1.0103391408920288f, _1590, mad(0.00406073359772563f, _1589, (_1588 * -0.005574649665504694f))) * 100.0f;
        _1611 = mad(0.04110127314925194f, _1601, mad(0.594700813293457f, _1600, (_1593 * 36.407447814941406f))) * 1.0172951221466064f;
        _1612 = mad(0.1479453295469284f, _1601, mad(1.0738555192947388f, _1600, (_1593 * -22.224510192871094f))) * 0.9887425899505615f;
        _1613 = mad(0.9503875374794006f, _1601, mad(0.04882604628801346f, _1600, (_1593 * -0.20676189661026f))) * 0.9944003820419312f;
        _1617 = abs(_1611) * 0.00793700572103262f;
        _1618 = abs(_1612) * 0.00793700572103262f;
        _1619 = abs(_1613) * 0.00793700572103262f;
        if (!(_1617 < 0.0f)) {
          _1626 = (pow(_1617, 0.41999998688697815f));
        } else {
          _1626 = 0.0f;
        }
        if (!(_1618 < 0.0f)) {
          _1633 = (pow(_1618, 0.41999998688697815f));
        } else {
          _1633 = 0.0f;
        }
        if (!(_1619 < 0.0f)) {
          _1640 = (pow(_1619, 0.41999998688697815f));
        } else {
          _1640 = 0.0f;
        }
        _1668 = ((float((int)(((int)(uint)((int)(_1611 > 0.0f))) - ((int)(uint)((int)(_1611 < 0.0f))))) * 400.0f) * _1626) / (_1626 + 27.1299991607666f);
        _1669 = ((float((int)(((int)(uint)((int)(_1612 > 0.0f))) - ((int)(uint)((int)(_1612 < 0.0f))))) * 400.0f) * _1633) / (_1633 + 27.1299991607666f);
        _1670 = ((float((int)(((int)(uint)((int)(_1613 > 0.0f))) - ((int)(uint)((int)(_1613 < 0.0f))))) * 400.0f) * _1640) / (_1640 + 27.1299991607666f);
        _1674 = (_1668 - (_1669 * 1.0909091234207153f)) + (_1670 * 0.09090909361839294f);
        _1678 = ((_1669 + _1668) - (_1670 * 2.0f)) * 0.1111111119389534f;
        _1680 = atan(_1678 / _1674);
        _1683 = (_1674 < 0.0f);
        _1684 = (_1674 == 0.0f);
        _1685 = (_1678 >= 0.0f);
        _1686 = (_1678 < 0.0f);
        _1695 = select((_1684 && _1685), 0.25f, select((_1684 && _1686), -0.25f, (select((_1683 && _1686), (_1680 + -3.1415927410125732f), select((_1683 && _1685), (_1680 + 3.1415927410125732f), _1680)) * 0.15915493667125702f)));
        _1699 = frac(abs(_1695));
        _1702 = select((_1695 >= (-0.0f - _1695)), _1699, (-0.0f - _1699)) * 360.0f;
        _1705 = select((_1702 < 0.0f), (_1702 + 360.0f), _1702);
        _1714 = exp2(log2((((_1668 * 2.0f) + _1669) + (_1670 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
        if (!(_1714 == 0.0f)) {
          _1723 = (sqrt((_1678 * _1678) + (_1674 * _1674)) * 38.70000076293945f);
        } else {
          _1723 = 0.0f;
        }
        _1728 = exp2(log2(abs(_1714) * 0.009999999776482582f) * 0.8794641494750977f);
        _1743 = (float((int)(((int)(uint)((int)(_1714 > 0.0f))) - ((int)(uint)((int)(_1714 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_1728 * 351.2578430175781f) / (400.0f - (_1728 * 12.947211265563965f))) * 2.3809523582458496f);
        _1745 = (_1516 * 115.59551239013672f) + 128.0f;
        _1749 = sqrt((_1515 + 0.1599999964237213f) * _1515) + _1515;
        _1750 = _1749 * 0.5f;
        _1751 = _1745 / _1750;
        _1758 = _1516 * 0.014018198475241661f;
        _1759 = _1758 + 0.10012999176979065f;
        _1769 = exp2(log2((((_1759 + sqrt(_1759 * (_1758 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_1745 / (_1750 * (_1751 + 1.0f))) * 1.149999976158142f)) / _1750) * 0.8695652484893799f);
        _1774 = 0.18000000715255737f / (((_1749 * -0.5f) * _1769) / (_1769 + -1.0f));
        _1789 = exp2(log2(max(0.0f, _1743) / ((_1774 * _1750) + _1743)) * 1.149999976158142f) * (_1750 / exp2(log2(_1745 / ((_1751 + _1774) * _1750)) * 1.149999976158142f));
        _1794 = max(0.0f, ((_1789 * _1789) / (_1789 + 0.03999999910593033f))) * 100.0f;
        _1799 = exp2(log2(abs(_1794) * 0.00793700572103262f) * 0.41999998688697815f);
        _1814 = (float((int)(((int)(uint)((int)(_1794 > 0.0f))) - ((int)(uint)((int)(_1794 < 0.0f))))) * 100.0f) * exp2(log2(((_1799 * 400.0f) / (_1799 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1816 = _1705 * 0.0027777778450399637f;
        _1817 = -0.0f - _1816;
        _1819 = frac(abs(_1816));
        _1820 = -0.0f - _1819;
        if (!(_1723 == 0.0f)) {
          _1822 = _1814 / _1536;
          _1824 = max(0.0f, (1.0f - _1822));
          _1825 = _1705 * 0.01745329424738884f;
          _1826 = cos(_1825);
          _1827 = sin(_1825);
          _1828 = _1826 * _1826;
          _1829 = _1827 * _1827;
          _1844 = ((((77.12895965576172f - ((_1826 * 12.74448013305664f) * _1827)) + ((_1828 - _1829) * 16.468990325927734f)) + (((_1828 * 31.535200119018555f) + -12.31067943572998f) * _1826)) + ((42.245330810546875f - (_1829 * 36.774559020996094f)) * _1827)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
          _1850 = select((_1816 >= _1817), _1819, _1820) * 360.0f;
          _1854 = int(select((_1850 < 0.0f), (_1850 + 360.0f), _1850));
          _1856 = (_1854 + 1) % 360;
          _1865 = t1.Load(int3(_1854, 0, 0));
          _1870 = (((((t1.Load(int3(_1856, 0, 0))).x) - _1865.x) * ((_1705 - float((int)(_1854))) / float((int)(_1856 - _1854)))) + _1865.x) * (pow(_1822, 0.8794641494750977f));
          _1871 = _1870 / _1844;
          _1872 = _1871 + -0.0010000000474974513f;
          _1873 = _1824 * max(0.20000000298023224f, (1.2999999523162842f - (_1516 * 0.270023912191391f)));
          _1874 = _1822 * ((_1516 * 2.384157657623291f) + 2.4000000953674316f);
          _1881 = (_1870 - (exp2(log2(_1814 / _1714) * 0.8794641494750977f) * _1723)) / _1844;
          if (!(_1881 > _1872)) {
            _1887 = max(sqrt((_1822 * _1822) + (0.5f / cb0_043y)), 0.0010000000474974513f);
            _1891 = sqrt((_1887 * _1887) + (_1873 * _1873));
            _1894 = (_1891 + _1872) / (_1887 + _1872);
            _1896 = (_1894 * _1881) - _1891;
            _1906 = ((_1896 + sqrt((_1896 * _1896) + (((_1881 * 4.0f) * _1887) * _1894))) * 0.5f);
          } else {
            _1906 = _1881;
          }
          _1907 = _1871 - _1906;
          if (!(_1907 > _1871)) {
            _1910 = max(_1824, 0.0010000000474974513f);
            _1914 = sqrt((_1910 * _1910) + (_1874 * _1874));
            _1917 = (_1914 + _1871) / (_1910 + _1871);
            _1919 = (_1917 * _1907) - _1914;
            _1929 = ((_1919 + sqrt((_1919 * _1919) + (((_1907 * 4.0f) * _1910) * _1917))) * 0.5f);
          } else {
            _1929 = _1907;
          }
          _1932 = (_1929 * _1844);
        } else {
          _1932 = _1723;
        }
        _1935 = select((_1816 >= _1817), _1819, _1820) * 360.0f;
        _1938 = select((_1935 < 0.0f), (_1935 + 360.0f), _1935);
        _1939 = int(_1938);
        _1940 = _1939 + 1;
        _1942 = 0;
        _1943 = 361;
        _1944 = _1940;
        while(true) {
          _1948 = (_1705 > (((float3)(t2.Load(int3(_1944, 0, 0)))).z));
          _1949 = select(_1948, _1944, _1942);
          _1950 = select(_1948, _1943, _1944);
          if ((int)(_1949 + 1) < (int)_1950) {
            _1942 = _1949;
            _1943 = _1950;
            _1944 = ((_1949 + _1950) / 2);
            continue;
          }
          _1957 = t2.Load(int3((_1950 + -1), 0, 0));
          _1961 = t2.Load(int3(_1950, 0, 0));
          _1967 = (_1705 - _1957.z) / (_1961.z - _1957.z);
          _1970 = ((_1961.x - _1957.x) * _1967) + _1957.x;
          if (!((_1814 > _1536) || (_1932 < 9.999999747378752e-05f))) {
            _1984 = (min(1.0f, (1.2999999523162842f - (_1970 / _1536))) * (((float((int)(((int)(uint)((int)(_1538 > 0.0f))) - ((int)(uint)((int)(_1538 < 0.0f))))) * 100.0f) * exp2(log2(((_1543 * 400.0f) / (_1543 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _1970)) + _1970;
            _1985 = ((_1516 * 0.7111833691596985f) + 1.350000023841858f) * _1536;
            _1986 = _1536 - _1970;
            _1988 = (_1986 * 0.30000001192092896f) + _1970;
            if (_1814 > _1988) {
              _2002 = (exp2(log2(log2((_1536 - _1988) / max(9.999999747378752e-05f, (_1536 - _1814))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _2002 = 1.0f;
            }
            _2003 = _1985 * _2002;
            t3.GetDimensions(_2005.x, _2005.y);
            _2009 = float((int)(_1939));
            _2013 = t3.Load(int3(_1940, 0, 0));
            _2018 = (lerp(_1957.y, _1961.y, _1967)) * 1.0324000120162964f;
            _2019 = _2003 * _1984;
            _2021 = (_1814 < _1984);
            _2022 = _1932 / _2003;
            if (_2021) {
              _2032 = (1.0f - _2022);
            } else {
              _2032 = (-0.0f - ((_2022 + 1.0f) + ((_1932 * _1536) / _2019)));
            }
            if (_2021) {
              _2040 = (-0.0f - _1814);
            } else {
              _2040 = (((_1932 * _1536) / _2003) + _1814);
            }
            _2045 = sqrt((_2032 * _2032) - (((_1932 / _2019) * 4.0f) * _2040));
            _2051 = (_2040 * 2.0f) / select(_2021, ((-0.0f - _2032) - _2045), (_2045 - _2032));
            _2053 = (_1970 < _1984);
            _2054 = _2018 / _2003;
            if (_2053) {
              _2064 = (1.0f - _2054);
            } else {
              _2064 = (-0.0f - ((_2054 + 1.0f) + ((_2018 * _1536) / _2019)));
            }
            if (!_2053) {
              _2070 = (((_2018 * _1536) / _2003) + _1970);
            } else {
              _2070 = (-0.0f - _1970);
            }
            _2075 = sqrt((_2064 * _2064) - (((_2018 / _2019) * 4.0f) * _2070));
            _2081 = (_2070 * 2.0f) / select(_2053, ((-0.0f - _2064) - _2075), (_2075 - _2064));
            _2083 = _1536 - _2051;
            _2087 = ((_2051 - _1984) * select((_2051 < _1984), _2051, _2083)) / _2019;
            _2096 = _1536 - _2081;
            _2107 = ((_2096 * _2018) * exp2(log2(_2083 / _2096) * (1.0f / (((((t3.Load(int3(((_1939 + 2) % (int)(_2005.x)), 0, 0))).x) - _2013.x) * (_1938 - _2009)) + _2013.x)))) / ((_1986 + (_2087 * _2018)) * _2018);
            _2109 = (exp2(log2(_2051 / _2081) * (1.0f / ((_1516 * 0.02107210084795952f) + 1.1399999856948853f))) * _2081) / (((_1970 / _2018) - _2087) * _2018);
            _2113 = max((0.11999999731779099f - abs(_2109 - _2107)), 0.0f);
            _2114 = _2113 * 8.333333969116211f;
            _2120 = (min(_2109, _2107) - ((_2114 * _2114) * (_2113 * 0.1666666716337204f))) * _2018;
            _2121 = _2120 * _2087;
            _2122 = _2121 + _2051;
            _2123 = _1940 % 360;
            _2131 = t1.Load(int3(_1939, 0, 0));
            _2135 = ((((t1.Load(int3(_2123, 0, 0))).x) - _2131.x) * ((_1705 - _2009) / float((int)(_2123 - _1939)))) + _2131.x;
            if (_2122 > _1988) {
              _2149 = (exp2(log2(log2((_1536 - _1988) / max(9.999999747378752e-05f, (_1536 - _2122))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _2149 = 1.0f;
            }
            _2150 = _1985 * _2149;
            _2151 = _2150 * _1984;
            _2153 = (_2122 < _1984);
            _2154 = _2120 / _2150;
            if (_2153) {
              _2164 = (1.0f - _2154);
            } else {
              _2164 = (-0.0f - ((_2154 + 1.0f) + ((_2120 * _1536) / _2151)));
            }
            if (_2153) {
              _2172 = (-0.0f - _2122);
            } else {
              _2172 = (((_2120 * _1536) / _2150) + _2122);
            }
            _2177 = sqrt((_2164 * _2164) - (((_2120 / _2151) * 4.0f) * _2172));
            _2183 = (_2172 * 2.0f) / select(_2153, ((-0.0f - _2164) - _2177), (_2177 - _2164));
            _2200 = max(1.000100016593933f, (((_2135 * _1536) * exp2(log2(_2183 / _1536) * 0.8794641494750977f)) / ((_1536 - ((((_2183 - _1984) * select((_2183 < _1984), _2183, (_1536 - _2183))) / _2151) * _2135)) * _2120)));
            _2202 = max(0.75f, (1.0f / _2200));
            _2203 = _1932 / _2120;
            _2208 = ((_2200 - _2202) * (1.0f - _2202)) / (_2200 + -1.0f);
            _2210 = (_2203 - _2202) / _2208;
            if (!((_2200 <= 1.000100016593933f) || (_2203 < _2202))) {
              _2220 = (((_2210 * _2208) / (_2210 + 1.0f)) + _2202);
            } else {
              _2220 = _2203;
            }
            _2226 = ((_2220 * _2121) + _2051);
            _2227 = ((_2120 * _2220) * 0.0258397925645113f);
          } else {
            _2226 = _1814;
            _2227 = 0.0f;
          }
          _2228 = _1705 * 0.01745329424738884f;
          _2229 = _2226 * 0.009999999776482582f;
          if (!(_2229 < 0.0f)) {
            _2238 = (((pow(_2229, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
          } else {
            _2238 = 0.0f;
          }
          _2240 = cos(_2228) * _2227;
          _2242 = sin(_2228) * _2227;
          _2249 = mad(288.0f, _2242, mad(451.0f, _2240, _2238)) * 0.0007127583958208561f;
          _2250 = mad(-261.0f, _2242, mad(-891.0f, _2240, _2238)) * 0.0007127583958208561f;
          _2251 = mad(-6300.0f, _2242, mad(-220.0f, _2240, _2238)) * 0.0007127583958208561f;
          _2271 = abs(_2249);
          _2272 = abs(_2250);
          _2273 = abs(_2251);
          _2280 = (_2271 * 27.1299991607666f) / (400.0f - _2271);
          _2281 = (_2272 * 27.1299991607666f) / (400.0f - _2272);
          _2282 = (_2273 * 27.1299991607666f) / (400.0f - _2273);
          if (!(_2280 < 0.0f)) {
            _2289 = (pow(_2280, 2.3809523582458496f));
          } else {
            _2289 = 0.0f;
          }
          if (!(_2281 < 0.0f)) {
            _2296 = (pow(_2281, 2.3809523582458496f));
          } else {
            _2296 = 0.0f;
          }
          if (!(_2282 < 0.0f)) {
            _2303 = (pow(_2282, 2.3809523582458496f));
          } else {
            _2303 = 0.0f;
          }
          _2304 = (float((int)(((int)(uint)((int)(_2249 > 0.0f))) - ((int)(uint)((int)(_2249 < 0.0f))))) * 125.99209594726562f) * _2289;
          _2306 = (float((int)(((int)(uint)((int)(_2250 > 0.0f))) - ((int)(uint)((int)(_2250 < 0.0f))))) * 127.42658996582031f) * _2296;
          _2308 = (float((int)(((int)(uint)((int)(_2251 > 0.0f))) - ((int)(uint)((int)(_2251 < 0.0f))))) * 126.70159912109375f) * _2303;
          _2311 = mad(0.08875565975904465f, _2308, mad(-1.140031337738037f, _2306, (_2304 * 2.016401767730713f)));
          _2318 = mad(-0.12752249836921692f, _2308, mad(0.7005835175514221f, _2306, (_2304 * 0.41968056559562683f))) * 0.009999999776482582f;
          _2319 = mad(1.0589468479156494f, _2308, mad(-0.03847259283065796f, _2306, (_2304 * -0.01717424765229225f))) * 0.009999999776482582f;
          _2332 = min(max(mad(-0.23642469942569733f, _2319, mad(-0.32480329275131226f, _2318, (_2311 * 0.016410233452916145f))), 0.0f), _1515);
          _2333 = min(max(mad(0.016756348311901093f, _2319, mad(1.6153316497802734f, _2318, (_2311 * -0.006636628415435553f))), 0.0f), _1515);
          _2334 = min(max(mad(0.9883948564529419f, _2319, mad(-0.008284442126750946f, _2318, (_2311 * 0.00011721893679350615f))), 0.0f), _1515);
          _2337 = mad(0.15618768334388733f, _2334, mad(0.13400420546531677f, _2333, (_2332 * 0.6624541878700256f)));
          _2340 = mad(0.053689517080783844f, _2334, mad(0.6740817427635193f, _2333, (_2332 * 0.2722287178039551f)));
          _2343 = mad(1.0103391408920288f, _2334, mad(0.00406073359772563f, _2333, (_2332 * -0.005574649665504694f)));
          _2353 = mad(-0.23642469942569733f, _2343, mad(-0.32480329275131226f, _2340, (_2337 * 1.6410233974456787f))) * 100.0f;
          _2354 = mad(0.016756348311901093f, _2343, mad(1.6153316497802734f, _2340, (_2337 * -0.663662850856781f))) * 100.0f;
          _2355 = mad(0.9883948564529419f, _2343, mad(-0.008284442126750946f, _2340, (_2337 * 0.011721894145011902f))) * 100.0f;
          _2374 = exp2(log2(mad(_56, _2355, mad(_55, _2354, (_2353 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2375 = exp2(log2(mad(_59, _2355, mad(_58, _2354, (_2353 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2376 = exp2(log2(mad(_62, _2355, mad(_61, _2354, (_2353 * _60))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _3422 = exp2(log2((1.0f / ((_2374 * 18.6875f) + 1.0f)) * ((_2374 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3423 = exp2(log2((1.0f / ((_2375 * 18.6875f) + 1.0f)) * ((_2375 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3424 = exp2(log2((1.0f / ((_2376 * 18.6875f) + 1.0f)) * ((_2376 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          break;
        }
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2424 = cb0_012z * _1336;
          _2425 = cb0_012z * _1337;
          _2426 = cb0_012z * _1338;
          _2429 = mad((WorkingColorSpace_256[0].z), _2426, mad((WorkingColorSpace_256[0].y), _2425, (_2424 * (WorkingColorSpace_256[0].x))));
          _2432 = mad((WorkingColorSpace_256[1].z), _2426, mad((WorkingColorSpace_256[1].y), _2425, (_2424 * (WorkingColorSpace_256[1].x))));
          _2435 = mad((WorkingColorSpace_256[2].z), _2426, mad((WorkingColorSpace_256[2].y), _2425, (_2424 * (WorkingColorSpace_256[2].x))));
          _2436 = cb0_043y * 0.009999999776482582f;
          _2437 = log2(_2436);
          _2442 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
          _2457 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_2442 * 400.0f) / (_2442 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2459 = (_2437 * 1.4018198251724243f) + 10.012999534606934f;
          _2464 = exp2(log2(abs(_2459) * 0.00793700572103262f) * 0.41999998688697815f);
          _2505 = (_2437 * 924.7640991210938f) + 1024.0f;
          _2509 = min(max(mad(-0.21492856740951538f, _2435, mad(-0.2365107536315918f, _2432, (_2429 * 1.4514392614364624f))), 0.0f), _2505);
          _2510 = min(max(mad(-0.09967592358589172f, _2435, mad(1.17622971534729f, _2432, (_2429 * -0.07655377686023712f))), 0.0f), _2505);
          _2511 = min(max(mad(0.9977163076400757f, _2435, mad(-0.006032449658960104f, _2432, (_2429 * 0.008316148072481155f))), 0.0f), _2505);
          _2514 = mad(0.15618768334388733f, _2511, mad(0.13400420546531677f, _2510, (_2509 * 0.6624541878700256f)));
          _2521 = mad(0.053689517080783844f, _2511, mad(0.6740817427635193f, _2510, (_2509 * 0.2722287178039551f))) * 100.0f;
          _2522 = mad(1.0103391408920288f, _2511, mad(0.00406073359772563f, _2510, (_2509 * -0.005574649665504694f))) * 100.0f;
          _2532 = mad(0.04110127314925194f, _2522, mad(0.594700813293457f, _2521, (_2514 * 36.407447814941406f))) * 1.0172951221466064f;
          _2533 = mad(0.1479453295469284f, _2522, mad(1.0738555192947388f, _2521, (_2514 * -22.224510192871094f))) * 0.9887425899505615f;
          _2534 = mad(0.9503875374794006f, _2522, mad(0.04882604628801346f, _2521, (_2514 * -0.20676189661026f))) * 0.9944003820419312f;
          _2538 = abs(_2532) * 0.00793700572103262f;
          _2539 = abs(_2533) * 0.00793700572103262f;
          _2540 = abs(_2534) * 0.00793700572103262f;
          if (!(_2538 < 0.0f)) {
            _2547 = (pow(_2538, 0.41999998688697815f));
          } else {
            _2547 = 0.0f;
          }
          if (!(_2539 < 0.0f)) {
            _2554 = (pow(_2539, 0.41999998688697815f));
          } else {
            _2554 = 0.0f;
          }
          if (!(_2540 < 0.0f)) {
            _2561 = (pow(_2540, 0.41999998688697815f));
          } else {
            _2561 = 0.0f;
          }
          _2589 = ((float((int)(((int)(uint)((int)(_2532 > 0.0f))) - ((int)(uint)((int)(_2532 < 0.0f))))) * 400.0f) * _2547) / (_2547 + 27.1299991607666f);
          _2590 = ((float((int)(((int)(uint)((int)(_2533 > 0.0f))) - ((int)(uint)((int)(_2533 < 0.0f))))) * 400.0f) * _2554) / (_2554 + 27.1299991607666f);
          _2591 = ((float((int)(((int)(uint)((int)(_2534 > 0.0f))) - ((int)(uint)((int)(_2534 < 0.0f))))) * 400.0f) * _2561) / (_2561 + 27.1299991607666f);
          _2595 = (_2589 - (_2590 * 1.0909091234207153f)) + (_2591 * 0.09090909361839294f);
          _2599 = ((_2590 + _2589) - (_2591 * 2.0f)) * 0.1111111119389534f;
          _2601 = atan(_2599 / _2595);
          _2604 = (_2595 < 0.0f);
          _2605 = (_2595 == 0.0f);
          _2606 = (_2599 >= 0.0f);
          _2607 = (_2599 < 0.0f);
          _2616 = select((_2605 && _2606), 0.25f, select((_2605 && _2607), -0.25f, (select((_2604 && _2607), (_2601 + -3.1415927410125732f), select((_2604 && _2606), (_2601 + 3.1415927410125732f), _2601)) * 0.15915493667125702f)));
          _2620 = frac(abs(_2616));
          _2623 = select((_2616 >= (-0.0f - _2616)), _2620, (-0.0f - _2620)) * 360.0f;
          _2626 = select((_2623 < 0.0f), (_2623 + 360.0f), _2623);
          _2635 = exp2(log2((((_2589 * 2.0f) + _2590) + (_2591 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
          if (!(_2635 == 0.0f)) {
            _2644 = (sqrt((_2599 * _2599) + (_2595 * _2595)) * 38.70000076293945f);
          } else {
            _2644 = 0.0f;
          }
          _2649 = exp2(log2(abs(_2635) * 0.009999999776482582f) * 0.8794641494750977f);
          _2664 = (float((int)(((int)(uint)((int)(_2635 > 0.0f))) - ((int)(uint)((int)(_2635 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_2649 * 351.2578430175781f) / (400.0f - (_2649 * 12.947211265563965f))) * 2.3809523582458496f);
          _2666 = (_2437 * 115.59551239013672f) + 128.0f;
          _2670 = sqrt((_2436 + 0.1599999964237213f) * _2436) + _2436;
          _2671 = _2670 * 0.5f;
          _2672 = _2666 / _2671;
          _2679 = _2437 * 0.014018198475241661f;
          _2680 = _2679 + 0.10012999176979065f;
          _2690 = exp2(log2((((_2680 + sqrt(_2680 * (_2679 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_2666 / (_2671 * (_2672 + 1.0f))) * 1.149999976158142f)) / _2671) * 0.8695652484893799f);
          _2695 = 0.18000000715255737f / (((_2670 * -0.5f) * _2690) / (_2690 + -1.0f));
          _2710 = exp2(log2(max(0.0f, _2664) / ((_2695 * _2671) + _2664)) * 1.149999976158142f) * (_2671 / exp2(log2(_2666 / ((_2672 + _2695) * _2671)) * 1.149999976158142f));
          _2715 = max(0.0f, ((_2710 * _2710) / (_2710 + 0.03999999910593033f))) * 100.0f;
          _2720 = exp2(log2(abs(_2715) * 0.00793700572103262f) * 0.41999998688697815f);
          _2735 = (float((int)(((int)(uint)((int)(_2715 > 0.0f))) - ((int)(uint)((int)(_2715 < 0.0f))))) * 100.0f) * exp2(log2(((_2720 * 400.0f) / (_2720 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2737 = _2626 * 0.0027777778450399637f;
          _2738 = -0.0f - _2737;
          _2740 = frac(abs(_2737));
          _2741 = -0.0f - _2740;
          if (!(_2644 == 0.0f)) {
            _2743 = _2735 / _2457;
            _2745 = max(0.0f, (1.0f - _2743));
            _2746 = _2626 * 0.01745329424738884f;
            _2747 = cos(_2746);
            _2748 = sin(_2746);
            _2749 = _2747 * _2747;
            _2750 = _2748 * _2748;
            _2765 = ((((77.12895965576172f - ((_2747 * 12.74448013305664f) * _2748)) + ((_2749 - _2750) * 16.468990325927734f)) + (((_2749 * 31.535200119018555f) + -12.31067943572998f) * _2747)) + ((42.245330810546875f - (_2750 * 36.774559020996094f)) * _2748)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
            _2771 = select((_2737 >= _2738), _2740, _2741) * 360.0f;
            _2775 = int(select((_2771 < 0.0f), (_2771 + 360.0f), _2771));
            _2777 = (_2775 + 1) % 360;
            _2786 = t1.Load(int3(_2775, 0, 0));
            _2791 = (((((t1.Load(int3(_2777, 0, 0))).x) - _2786.x) * ((_2626 - float((int)(_2775))) / float((int)(_2777 - _2775)))) + _2786.x) * (pow(_2743, 0.8794641494750977f));
            _2792 = _2791 / _2765;
            _2793 = _2792 + -0.0010000000474974513f;
            _2794 = _2745 * max(0.20000000298023224f, (1.2999999523162842f - (_2437 * 0.270023912191391f)));
            _2795 = _2743 * ((_2437 * 2.384157657623291f) + 2.4000000953674316f);
            _2802 = (_2791 - (exp2(log2(_2735 / _2635) * 0.8794641494750977f) * _2644)) / _2765;
            if (!(_2802 > _2793)) {
              _2808 = max(sqrt((_2743 * _2743) + (0.5f / cb0_043y)), 0.0010000000474974513f);
              _2812 = sqrt((_2808 * _2808) + (_2794 * _2794));
              _2815 = (_2812 + _2793) / (_2808 + _2793);
              _2817 = (_2815 * _2802) - _2812;
              _2827 = ((_2817 + sqrt((_2817 * _2817) + (((_2802 * 4.0f) * _2808) * _2815))) * 0.5f);
            } else {
              _2827 = _2802;
            }
            _2828 = _2792 - _2827;
            if (!(_2828 > _2792)) {
              _2831 = max(_2745, 0.0010000000474974513f);
              _2835 = sqrt((_2831 * _2831) + (_2795 * _2795));
              _2838 = (_2835 + _2792) / (_2831 + _2792);
              _2840 = (_2838 * _2828) - _2835;
              _2850 = ((_2840 + sqrt((_2840 * _2840) + (((_2828 * 4.0f) * _2831) * _2838))) * 0.5f);
            } else {
              _2850 = _2828;
            }
            _2853 = (_2850 * _2765);
          } else {
            _2853 = _2644;
          }
          _2856 = select((_2737 >= _2738), _2740, _2741) * 360.0f;
          _2859 = select((_2856 < 0.0f), (_2856 + 360.0f), _2856);
          _2860 = int(_2859);
          _2861 = _2860 + 1;
          _2863 = 0;
          _2864 = 361;
          _2865 = _2861;
          while(true) {
            _2869 = (_2626 > (((float3)(t2.Load(int3(_2865, 0, 0)))).z));
            _2870 = select(_2869, _2865, _2863);
            _2871 = select(_2869, _2864, _2865);
            if ((int)(_2870 + 1) < (int)_2871) {
              _2863 = _2870;
              _2864 = _2871;
              _2865 = ((_2870 + _2871) / 2);
              continue;
            }
            _2878 = t2.Load(int3((_2871 + -1), 0, 0));
            _2882 = t2.Load(int3(_2871, 0, 0));
            _2888 = (_2626 - _2878.z) / (_2882.z - _2878.z);
            _2891 = ((_2882.x - _2878.x) * _2888) + _2878.x;
            if (!((_2735 > _2457) || (_2853 < 9.999999747378752e-05f))) {
              _2905 = (min(1.0f, (1.2999999523162842f - (_2891 / _2457))) * (((float((int)(((int)(uint)((int)(_2459 > 0.0f))) - ((int)(uint)((int)(_2459 < 0.0f))))) * 100.0f) * exp2(log2(((_2464 * 400.0f) / (_2464 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _2891)) + _2891;
              _2906 = ((_2437 * 0.7111833691596985f) + 1.350000023841858f) * _2457;
              _2907 = _2457 - _2891;
              _2909 = (_2907 * 0.30000001192092896f) + _2891;
              if (_2735 > _2909) {
                _2923 = (exp2(log2(log2((_2457 - _2909) / max(9.999999747378752e-05f, (_2457 - _2735))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _2923 = 1.0f;
              }
              _2924 = _2906 * _2923;
              t3.GetDimensions(_2926.x, _2926.y);
              _2930 = float((int)(_2860));
              _2934 = t3.Load(int3(_2861, 0, 0));
              _2939 = (lerp(_2878.y, _2882.y, _2888)) * 1.0324000120162964f;
              _2940 = _2924 * _2905;
              _2942 = (_2735 < _2905);
              _2943 = _2853 / _2924;
              if (_2942) {
                _2953 = (1.0f - _2943);
              } else {
                _2953 = (-0.0f - ((_2943 + 1.0f) + ((_2853 * _2457) / _2940)));
              }
              if (_2942) {
                _2961 = (-0.0f - _2735);
              } else {
                _2961 = (((_2853 * _2457) / _2924) + _2735);
              }
              _2966 = sqrt((_2953 * _2953) - (((_2853 / _2940) * 4.0f) * _2961));
              _2972 = (_2961 * 2.0f) / select(_2942, ((-0.0f - _2953) - _2966), (_2966 - _2953));
              _2974 = (_2891 < _2905);
              _2975 = _2939 / _2924;
              if (_2974) {
                _2985 = (1.0f - _2975);
              } else {
                _2985 = (-0.0f - ((_2975 + 1.0f) + ((_2939 * _2457) / _2940)));
              }
              if (!_2974) {
                _2991 = (((_2939 * _2457) / _2924) + _2891);
              } else {
                _2991 = (-0.0f - _2891);
              }
              _2996 = sqrt((_2985 * _2985) - (((_2939 / _2940) * 4.0f) * _2991));
              _3002 = (_2991 * 2.0f) / select(_2974, ((-0.0f - _2985) - _2996), (_2996 - _2985));
              _3004 = _2457 - _2972;
              _3008 = ((_2972 - _2905) * select((_2972 < _2905), _2972, _3004)) / _2940;
              _3017 = _2457 - _3002;
              _3028 = ((_3017 * _2939) * exp2(log2(_3004 / _3017) * (1.0f / (((((t3.Load(int3(((_2860 + 2) % (int)(_2926.x)), 0, 0))).x) - _2934.x) * (_2859 - _2930)) + _2934.x)))) / ((_2907 + (_3008 * _2939)) * _2939);
              _3030 = (exp2(log2(_2972 / _3002) * (1.0f / ((_2437 * 0.02107210084795952f) + 1.1399999856948853f))) * _3002) / (((_2891 / _2939) - _3008) * _2939);
              _3034 = max((0.11999999731779099f - abs(_3030 - _3028)), 0.0f);
              _3035 = _3034 * 8.333333969116211f;
              _3041 = (min(_3030, _3028) - ((_3035 * _3035) * (_3034 * 0.1666666716337204f))) * _2939;
              _3042 = _3041 * _3008;
              _3043 = _3042 + _2972;
              _3044 = _2861 % 360;
              _3052 = t1.Load(int3(_2860, 0, 0));
              _3056 = ((((t1.Load(int3(_3044, 0, 0))).x) - _3052.x) * ((_2626 - _2930) / float((int)(_3044 - _2860)))) + _3052.x;
              if (_3043 > _2909) {
                _3070 = (exp2(log2(log2((_2457 - _2909) / max(9.999999747378752e-05f, (_2457 - _3043))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _3070 = 1.0f;
              }
              _3071 = _2906 * _3070;
              _3072 = _3071 * _2905;
              _3074 = (_3043 < _2905);
              _3075 = _3041 / _3071;
              if (_3074) {
                _3085 = (1.0f - _3075);
              } else {
                _3085 = (-0.0f - ((_3075 + 1.0f) + ((_3041 * _2457) / _3072)));
              }
              if (_3074) {
                _3093 = (-0.0f - _3043);
              } else {
                _3093 = (((_3041 * _2457) / _3071) + _3043);
              }
              _3098 = sqrt((_3085 * _3085) - (((_3041 / _3072) * 4.0f) * _3093));
              _3104 = (_3093 * 2.0f) / select(_3074, ((-0.0f - _3085) - _3098), (_3098 - _3085));
              _3121 = max(1.000100016593933f, (((_3056 * _2457) * exp2(log2(_3104 / _2457) * 0.8794641494750977f)) / ((_2457 - ((((_3104 - _2905) * select((_3104 < _2905), _3104, (_2457 - _3104))) / _3072) * _3056)) * _3041)));
              _3123 = max(0.75f, (1.0f / _3121));
              _3124 = _2853 / _3041;
              _3129 = ((_3121 - _3123) * (1.0f - _3123)) / (_3121 + -1.0f);
              _3131 = (_3124 - _3123) / _3129;
              if (!((_3121 <= 1.000100016593933f) || (_3124 < _3123))) {
                _3141 = (((_3131 * _3129) / (_3131 + 1.0f)) + _3123);
              } else {
                _3141 = _3124;
              }
              _3147 = ((_3141 * _3042) + _2972);
              _3148 = ((_3041 * _3141) * 0.0258397925645113f);
            } else {
              _3147 = _2735;
              _3148 = 0.0f;
            }
            _3149 = _2626 * 0.01745329424738884f;
            _3150 = _3147 * 0.009999999776482582f;
            if (!(_3150 < 0.0f)) {
              _3159 = (((pow(_3150, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
            } else {
              _3159 = 0.0f;
            }
            _3161 = cos(_3149) * _3148;
            _3163 = sin(_3149) * _3148;
            _3170 = mad(288.0f, _3163, mad(451.0f, _3161, _3159)) * 0.0007127583958208561f;
            _3171 = mad(-261.0f, _3163, mad(-891.0f, _3161, _3159)) * 0.0007127583958208561f;
            _3172 = mad(-6300.0f, _3163, mad(-220.0f, _3161, _3159)) * 0.0007127583958208561f;
            _3192 = abs(_3170);
            _3193 = abs(_3171);
            _3194 = abs(_3172);
            _3201 = (_3192 * 27.1299991607666f) / (400.0f - _3192);
            _3202 = (_3193 * 27.1299991607666f) / (400.0f - _3193);
            _3203 = (_3194 * 27.1299991607666f) / (400.0f - _3194);
            if (!(_3201 < 0.0f)) {
              _3210 = (pow(_3201, 2.3809523582458496f));
            } else {
              _3210 = 0.0f;
            }
            if (!(_3202 < 0.0f)) {
              _3217 = (pow(_3202, 2.3809523582458496f));
            } else {
              _3217 = 0.0f;
            }
            if (!(_3203 < 0.0f)) {
              _3224 = (pow(_3203, 2.3809523582458496f));
            } else {
              _3224 = 0.0f;
            }
            _3225 = (float((int)(((int)(uint)((int)(_3170 > 0.0f))) - ((int)(uint)((int)(_3170 < 0.0f))))) * 125.99209594726562f) * _3210;
            _3227 = (float((int)(((int)(uint)((int)(_3171 > 0.0f))) - ((int)(uint)((int)(_3171 < 0.0f))))) * 127.42658996582031f) * _3217;
            _3229 = (float((int)(((int)(uint)((int)(_3172 > 0.0f))) - ((int)(uint)((int)(_3172 < 0.0f))))) * 126.70159912109375f) * _3224;
            _3232 = mad(0.08875565975904465f, _3229, mad(-1.140031337738037f, _3227, (_3225 * 2.016401767730713f)));
            _3239 = mad(-0.12752249836921692f, _3229, mad(0.7005835175514221f, _3227, (_3225 * 0.41968056559562683f))) * 0.009999999776482582f;
            _3240 = mad(1.0589468479156494f, _3229, mad(-0.03847259283065796f, _3227, (_3225 * -0.01717424765229225f))) * 0.009999999776482582f;
            _3253 = min(max(mad(-0.23642469942569733f, _3240, mad(-0.32480329275131226f, _3239, (_3232 * 0.016410233452916145f))), 0.0f), _2436);
            _3254 = min(max(mad(0.016756348311901093f, _3240, mad(1.6153316497802734f, _3239, (_3232 * -0.006636628415435553f))), 0.0f), _2436);
            _3255 = min(max(mad(0.9883948564529419f, _3240, mad(-0.008284442126750946f, _3239, (_3232 * 0.00011721893679350615f))), 0.0f), _2436);
            _3258 = mad(0.15618768334388733f, _3255, mad(0.13400420546531677f, _3254, (_3253 * 0.6624541878700256f)));
            _3261 = mad(0.053689517080783844f, _3255, mad(0.6740817427635193f, _3254, (_3253 * 0.2722287178039551f)));
            _3264 = mad(1.0103391408920288f, _3255, mad(0.00406073359772563f, _3254, (_3253 * -0.005574649665504694f)));
            _3267 = mad(-0.23642469942569733f, _3264, mad(-0.32480329275131226f, _3261, (_3258 * 1.6410233974456787f)));
            _3274 = mad(0.016756348311901093f, _3264, mad(1.6153316497802734f, _3261, (_3258 * -0.663662850856781f))) * 1.25f;
            _3275 = mad(0.9883948564529419f, _3264, mad(-0.008284442126750946f, _3261, (_3258 * 0.011721894145011902f))) * 1.25f;
            _3422 = mad(-0.0832589864730835f, _3275, mad(-0.6217921376228333f, _3274, (_3267 * 2.1313138008117676f)));
            _3423 = mad(-0.010548308491706848f, _3275, mad(1.140804648399353f, _3274, (_3267 * -0.16282059252262115f)));
            _3424 = mad(1.1529725790023804f, _3275, mad(-0.1289689838886261f, _3274, (_3267 * -0.030004188418388367f)));
            break;
          }
        } else {
          if (cb0_042w == 7) {
            _3302 = mad((WorkingColorSpace_128[0].z), _1338, mad((WorkingColorSpace_128[0].y), _1337, ((WorkingColorSpace_128[0].x) * _1336)));
            _3305 = mad((WorkingColorSpace_128[1].z), _1338, mad((WorkingColorSpace_128[1].y), _1337, ((WorkingColorSpace_128[1].x) * _1336)));
            _3308 = mad((WorkingColorSpace_128[2].z), _1338, mad((WorkingColorSpace_128[2].y), _1337, ((WorkingColorSpace_128[2].x) * _1336)));
            _3327 = exp2(log2(mad(_56, _3308, mad(_55, _3305, (_3302 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3328 = exp2(log2(mad(_59, _3308, mad(_58, _3305, (_3302 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3329 = exp2(log2(mad(_62, _3308, mad(_61, _3305, (_3302 * _60))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3422 = exp2(log2((1.0f / ((_3327 * 18.6875f) + 1.0f)) * ((_3327 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3423 = exp2(log2((1.0f / ((_3328 * 18.6875f) + 1.0f)) * ((_3328 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3424 = exp2(log2((1.0f / ((_3329 * 18.6875f) + 1.0f)) * ((_3329 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _3376 = mad((WorkingColorSpace_128[0].z), _1326, mad((WorkingColorSpace_128[0].y), _1325, ((WorkingColorSpace_128[0].x) * _1324)));
                _3379 = mad((WorkingColorSpace_128[1].z), _1326, mad((WorkingColorSpace_128[1].y), _1325, ((WorkingColorSpace_128[1].x) * _1324)));
                _3382 = mad((WorkingColorSpace_128[2].z), _1326, mad((WorkingColorSpace_128[2].y), _1325, ((WorkingColorSpace_128[2].x) * _1324)));
                _3422 = mad(_56, _3382, mad(_55, _3379, (_3376 * _54)));
                _3423 = mad(_59, _3382, mad(_58, _3379, (_3376 * _57)));
                _3424 = mad(_62, _3382, mad(_61, _3379, (_3376 * _60)));
              } else {
                _3395 = mad((WorkingColorSpace_128[0].z), _1352, mad((WorkingColorSpace_128[0].y), _1351, ((WorkingColorSpace_128[0].x) * _1350)));
                _3398 = mad((WorkingColorSpace_128[1].z), _1352, mad((WorkingColorSpace_128[1].y), _1351, ((WorkingColorSpace_128[1].x) * _1350)));
                _3401 = mad((WorkingColorSpace_128[2].z), _1352, mad((WorkingColorSpace_128[2].y), _1351, ((WorkingColorSpace_128[2].x) * _1350)));
                _3422 = exp2(log2(mad(_56, _3401, mad(_55, _3398, (_3395 * _54)))) * cb0_042z);
                _3423 = exp2(log2(mad(_59, _3401, mad(_58, _3398, (_3395 * _57)))) * cb0_042z);
                _3424 = exp2(log2(mad(_62, _3401, mad(_61, _3398, (_3395 * _60)))) * cb0_042z);
              }
            } else {
              _3422 = _1336;
              _3423 = _1337;
              _3424 = _1338;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_3422 * 0.9523810148239136f), (_3423 * 0.9523810148239136f), (_3424 * 0.9523810148239136f), 0.0f);
}
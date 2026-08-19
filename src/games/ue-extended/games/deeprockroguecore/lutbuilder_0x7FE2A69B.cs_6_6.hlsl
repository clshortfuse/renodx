// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float> t4 : register(t4);

Texture2D<float3> t5 : register(t5);

Texture2D<float> t6 : register(t6);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
  float cb0_006x : packoffset(c006.x);
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
  float _31;
  float _36;
  float _37;
  float _38;
  float _40;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _126;
  float _127;
  float _128;
  float _183;
  float _390;
  float _391;
  float _392;
  float _915;
  float _948;
  float _962;
  float _1026;
  float _1205;
  float _1216;
  float _1227;
  float _1477;
  float _1478;
  float _1479;
  float _1490;
  float _1501;
  float _1711;
  float _1718;
  float _1725;
  float _1808;
  float _1991;
  float _2014;
  float _2017;
  int _2027;
  int _2028;
  int _2029;
  float _2087;
  float _2117;
  float _2125;
  float _2149;
  float _2155;
  float _2234;
  float _2249;
  float _2257;
  float _2305;
  float _2311;
  float _2312;
  float _2323;
  float _2374;
  float _2381;
  float _2388;
  float _2632;
  float _2639;
  float _2646;
  float _2729;
  float _2912;
  float _2935;
  float _2938;
  int _2948;
  int _2949;
  int _2950;
  float _3008;
  float _3038;
  float _3046;
  float _3070;
  float _3076;
  float _3155;
  float _3170;
  float _3178;
  float _3226;
  float _3232;
  float _3233;
  float _3244;
  float _3295;
  float _3302;
  float _3309;
  float _3507;
  float _3508;
  float _3509;
  bool _49;
  float _79;
  float _80;
  float _81;
  bool _164;
  float _166;
  float _197;
  float _204;
  float _207;
  float _212;
  float _213;
  float _215;
  bool _216;
  float _225;
  float _227;
  float _234;
  float _236;
  float _238;
  float _239;
  float _242;
  float _245;
  float _250;
  float _256;
  float _257;
  float _258;
  float _259;
  float _260;
  float _261;
  float _262;
  float _263;
  float _266;
  float _267;
  float _268;
  float _271;
  float _290;
  float _291;
  float _292;
  float _293;
  float _294;
  float _295;
  float _296;
  float _297;
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
  float _349;
  float _352;
  float _407;
  float _410;
  float _413;
  float _414;
  float _418;
  float _419;
  float _420;
  float _432;
  float _448;
  float _449;
  float _450;
  float _451;
  float _465;
  float _479;
  float _493;
  float _507;
  float _521;
  float _525;
  float _526;
  float _527;
  float _584;
  float _588;
  float _589;
  float _598;
  float _607;
  float _616;
  float _625;
  float _634;
  float _697;
  float _701;
  float _710;
  float _719;
  float _728;
  float _737;
  float _746;
  float _804;
  float _815;
  float _817;
  float _819;
  float _855;
  float _856;
  float _857;
  float _860;
  float _863;
  float _866;
  float _870;
  float _875;
  float _888;
  float _889;
  float _890;
  float _891;
  float _895;
  float _906;
  float _916;
  float _917;
  float _918;
  float _919;
  float _926;
  float _929;
  float _931;
  bool _934;
  bool _935;
  bool _936;
  bool _937;
  float _953;
  float _966;
  float _970;
  float _976;
  float _986;
  float _987;
  float _988;
  float _989;
  float _1004;
  float _1006;
  float _1008;
  float _1017;
  float _1029;
  float _1031;
  float _1035;
  float _1036;
  float _1037;
  float _1041;
  float _1042;
  float _1043;
  float _1044;
  float _1046;
  float _1047;
  float _1048;
  float _1049;
  float _1068;
  float _1070;
  float _1095;
  float _1096;
  float _1097;
  float _1104;
  float _1108;
  float _1109;
  float _1110;
  bool _1111;
  float _1115;
  float _1116;
  float _1117;
  float _1136;
  float _1137;
  float _1138;
  float _1139;
  float _1159;
  float _1160;
  float _1161;
  float _1177;
  float _1178;
  float _1179;
  float _1192;
  float _1193;
  float _1194;
  float _1231;
  float _1238;
  float _1239;
  float _1240;
  float _1242;
  float4 _1245;
  float _1249;
  float4 _1250;
  float4 _1272;
  float4 _1276;
  float4 _1298;
  float4 _1302;
  float4 _1325;
  float4 _1329;
  float _1345;
  float _1346;
  float _1347;
  float _1372;
  float _1373;
  float _1374;
  float _1400;
  float _1401;
  float _1402;
  float _1409;
  float _1410;
  float _1411;
  float _1412;
  float _1413;
  float _1414;
  float _1421;
  float _1422;
  float _1423;
  float _1435;
  float _1436;
  float _1437;
  float _1460;
  float _1463;
  float _1466;
  float _1528;
  float _1531;
  float _1534;
  float _1537;
  float _1540;
  float _1543;
  float _1588;
  float _1589;
  float _1590;
  float _1593;
  float _1596;
  float _1599;
  float _1600;
  float _1601;
  float _1606;
  float _1621;
  float _1623;
  float _1628;
  float _1669;
  float _1673;
  float _1674;
  float _1675;
  float _1678;
  float _1685;
  float _1686;
  float _1696;
  float _1697;
  float _1698;
  float _1702;
  float _1703;
  float _1704;
  float _1753;
  float _1754;
  float _1755;
  float _1759;
  float _1763;
  float _1765;
  bool _1768;
  bool _1769;
  bool _1770;
  bool _1771;
  float _1780;
  float _1784;
  float _1787;
  float _1790;
  float _1799;
  float _1813;
  float _1828;
  float _1830;
  float _1834;
  float _1835;
  float _1836;
  float _1843;
  float _1844;
  float _1854;
  float _1859;
  float _1874;
  float _1879;
  float _1884;
  float _1899;
  float _1901;
  float _1902;
  float _1904;
  float _1905;
  float _1907;
  float _1909;
  float _1910;
  float _1911;
  float _1912;
  float _1913;
  float _1914;
  float _1929;
  float _1935;
  int _1939;
  int _1941;
  float _1950;
  float _1955;
  float _1956;
  float _1957;
  float _1958;
  float _1959;
  float _1966;
  float _1972;
  float _1976;
  float _1979;
  float _1981;
  float _1992;
  float _1995;
  float _1999;
  float _2002;
  float _2004;
  float _2020;
  float _2023;
  int _2024;
  int _2025;
  bool _2033;
  int _2034;
  int _2035;
  float3 _2042;
  float3 _2046;
  float _2052;
  float _2055;
  float _2069;
  float _2070;
  float _2071;
  float _2073;
  float _2088;
  uint2 _2090;
  float _2094;
  float _2098;
  float _2103;
  float _2104;
  bool _2106;
  float _2107;
  float _2130;
  float _2136;
  bool _2138;
  float _2139;
  float _2160;
  float _2166;
  float _2168;
  float _2172;
  float _2181;
  float _2192;
  float _2194;
  float _2198;
  float _2199;
  float _2205;
  float _2206;
  float _2207;
  int _2208;
  float _2216;
  float _2220;
  float _2235;
  float _2236;
  bool _2238;
  float _2239;
  float _2262;
  float _2268;
  float _2285;
  float _2287;
  float _2288;
  float _2293;
  float _2295;
  float _2313;
  float _2314;
  float _2325;
  float _2327;
  float _2334;
  float _2335;
  float _2336;
  float _2356;
  float _2357;
  float _2358;
  float _2365;
  float _2366;
  float _2367;
  float _2389;
  float _2391;
  float _2393;
  float _2396;
  float _2403;
  float _2404;
  float _2417;
  float _2418;
  float _2419;
  float _2422;
  float _2425;
  float _2428;
  float _2438;
  float _2439;
  float _2440;
  float _2459;
  float _2460;
  float _2461;
  float _2509;
  float _2510;
  float _2511;
  float _2514;
  float _2517;
  float _2520;
  float _2521;
  float _2522;
  float _2527;
  float _2542;
  float _2544;
  float _2549;
  float _2590;
  float _2594;
  float _2595;
  float _2596;
  float _2599;
  float _2606;
  float _2607;
  float _2617;
  float _2618;
  float _2619;
  float _2623;
  float _2624;
  float _2625;
  float _2674;
  float _2675;
  float _2676;
  float _2680;
  float _2684;
  float _2686;
  bool _2689;
  bool _2690;
  bool _2691;
  bool _2692;
  float _2701;
  float _2705;
  float _2708;
  float _2711;
  float _2720;
  float _2734;
  float _2749;
  float _2751;
  float _2755;
  float _2756;
  float _2757;
  float _2764;
  float _2765;
  float _2775;
  float _2780;
  float _2795;
  float _2800;
  float _2805;
  float _2820;
  float _2822;
  float _2823;
  float _2825;
  float _2826;
  float _2828;
  float _2830;
  float _2831;
  float _2832;
  float _2833;
  float _2834;
  float _2835;
  float _2850;
  float _2856;
  int _2860;
  int _2862;
  float _2871;
  float _2876;
  float _2877;
  float _2878;
  float _2879;
  float _2880;
  float _2887;
  float _2893;
  float _2897;
  float _2900;
  float _2902;
  float _2913;
  float _2916;
  float _2920;
  float _2923;
  float _2925;
  float _2941;
  float _2944;
  int _2945;
  int _2946;
  bool _2954;
  int _2955;
  int _2956;
  float3 _2963;
  float3 _2967;
  float _2973;
  float _2976;
  float _2990;
  float _2991;
  float _2992;
  float _2994;
  float _3009;
  uint2 _3011;
  float _3015;
  float _3019;
  float _3024;
  float _3025;
  bool _3027;
  float _3028;
  float _3051;
  float _3057;
  bool _3059;
  float _3060;
  float _3081;
  float _3087;
  float _3089;
  float _3093;
  float _3102;
  float _3113;
  float _3115;
  float _3119;
  float _3120;
  float _3126;
  float _3127;
  float _3128;
  int _3129;
  float _3137;
  float _3141;
  float _3156;
  float _3157;
  bool _3159;
  float _3160;
  float _3183;
  float _3189;
  float _3206;
  float _3208;
  float _3209;
  float _3214;
  float _3216;
  float _3234;
  float _3235;
  float _3246;
  float _3248;
  float _3255;
  float _3256;
  float _3257;
  float _3277;
  float _3278;
  float _3279;
  float _3286;
  float _3287;
  float _3288;
  float _3310;
  float _3312;
  float _3314;
  float _3317;
  float _3324;
  float _3325;
  float _3338;
  float _3339;
  float _3340;
  float _3343;
  float _3346;
  float _3349;
  float _3352;
  float _3359;
  float _3360;
  float _3387;
  float _3390;
  float _3393;
  float _3412;
  float _3413;
  float _3414;
  float _3461;
  float _3464;
  float _3467;
  float _3480;
  float _3483;
  float _3486;
  _31 = 0.5f / cb0_037x;
  _36 = cb0_037x + -1.0f;
  _37 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _31)) / _36;
  _38 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _31)) / _36;
  _40 = float((uint)SV_DispatchThreadID.z) / _36;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _49 = (cb0_043x == 4);
        _60 = select(_49, 1.0f, 1.705051064491272f);
        _61 = select(_49, 0.0f, -0.6217921376228333f);
        _62 = select(_49, 0.0f, -0.0832589864730835f);
        _63 = select(_49, 0.0f, -0.13025647401809692f);
        _64 = select(_49, 1.0f, 1.140804648399353f);
        _65 = select(_49, 0.0f, -0.010548308491706848f);
        _66 = select(_49, 0.0f, -0.024003351107239723f);
        _67 = select(_49, 0.0f, -0.1289689838886261f);
        _68 = select(_49, 1.0f, 1.1529725790023804f);
      } else {
        _60 = 0.6954522132873535f;
        _61 = 0.14067870378494263f;
        _62 = 0.16386906802654266f;
        _63 = 0.044794563204050064f;
        _64 = 0.8596711158752441f;
        _65 = 0.0955343171954155f;
        _66 = -0.005525882821530104f;
        _67 = 0.004025210160762072f;
        _68 = 1.0015007257461548f;
      }
    } else {
      _60 = 1.0258246660232544f;
      _61 = -0.020053181797266006f;
      _62 = -0.005771636962890625f;
      _63 = -0.002234415616840124f;
      _64 = 1.0045864582061768f;
      _65 = -0.002352118492126465f;
      _66 = -0.005013350863009691f;
      _67 = -0.025290070101618767f;
      _68 = 1.0303035974502563f;
    }
  } else {
    _60 = 1.3792141675949097f;
    _61 = -0.30886411666870117f;
    _62 = -0.0703500509262085f;
    _63 = -0.06933490186929703f;
    _64 = 1.08229660987854f;
    _65 = -0.012961871922016144f;
    _66 = -0.0021590073592960835f;
    _67 = -0.0454593189060688f;
    _68 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _79 = (pow(_37, 0.012683313339948654f));
    _80 = (pow(_38, 0.012683313339948654f));
    _81 = (pow(_40, 0.012683313339948654f));
    _126 = (exp2(log2(max(0.0f, (_79 + -0.8359375f)) / (18.8515625f - (_79 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _127 = (exp2(log2(max(0.0f, (_80 + -0.8359375f)) / (18.8515625f - (_80 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _128 = (exp2(log2(max(0.0f, (_81 + -0.8359375f)) / (18.8515625f - (_81 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _126 = ((exp2((_37 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _127 = ((exp2((_38 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _128 = ((exp2((_40 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _164 = (cb0_040w != 0);
    _166 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _183 = (((((1901800.0f - (_166 * 2006400000.0f)) * _166) + 247.47999572753906f) * _166) + 0.23703999817371368f);
    } else {
      _183 = (((((2967800.0f - (_166 * 4607000064.0f)) * _166) + 99.11000061035156f) * _166) + 0.24406300485134125f);
    }
    _197 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _204 = cb0_037y * cb0_037y;
    _207 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_204 * 1.6145605741257896e-07f));
    _212 = ((_197 * 2.0f) + 4.0f) - (_207 * 8.0f);
    _213 = (_197 * 3.0f) / _212;
    _215 = (_207 * 2.0f) / _212;
    _216 = (cb0_037y < 4000.0f);
    _225 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _227 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_204 * 1.5317699909210205f)) / (_225 * _225);
    _234 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _204;
    _236 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_204 * 308.60699462890625f)) / (_234 * _234);
    _238 = rsqrt(dot(float2(_227, _236), float2(_227, _236)));
    _239 = cb0_037z * 0.05000000074505806f;
    _242 = ((_239 * _236) * _238) + _197;
    _245 = _207 - ((_239 * _227) * _238);
    _250 = (4.0f - (_245 * 8.0f)) + (_242 * 2.0f);
    _256 = (((_242 * 3.0f) / _250) - _213) + select(_216, _213, _183);
    _257 = (((_245 * 2.0f) / _250) - _215) + select(_216, _215, (((_183 * 2.869999885559082f) + -0.2750000059604645f) - ((_183 * _183) * 3.0f)));
    _258 = select(_164, _256, 0.3127000033855438f);
    _259 = select(_164, _257, 0.32899999618530273f);
    _260 = select(_164, 0.3127000033855438f, _256);
    _261 = select(_164, 0.32899999618530273f, _257);
    _262 = max(_259, 1.000000013351432e-10f);
    _263 = _258 / _262;
    _266 = ((1.0f - _258) - _259) / _262;
    _267 = max(_261, 1.000000013351432e-10f);
    _268 = _260 / _267;
    _271 = ((1.0f - _260) - _261) / _267;
    _290 = mad(-0.16140000522136688f, _271, ((_268 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _266, ((_263 * 0.8950999975204468f) + 0.266400009393692f));
    _291 = mad(0.03669999912381172f, _271, (1.7135000228881836f - (_268 * 0.7501999735832214f))) / mad(0.03669999912381172f, _266, (1.7135000228881836f - (_263 * 0.7501999735832214f)));
    _292 = mad(1.0296000242233276f, _271, ((_268 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _266, ((_263 * 0.03889999911189079f) + -0.06849999725818634f));
    _293 = mad(_291, -0.7501999735832214f, 0.0f);
    _294 = mad(_291, 1.7135000228881836f, 0.0f);
    _295 = mad(_291, 0.03669999912381172f, -0.0f);
    _296 = mad(_292, 0.03889999911189079f, 0.0f);
    _297 = mad(_292, -0.06849999725818634f, 0.0f);
    _298 = mad(_292, 1.0296000242233276f, 0.0f);
    _301 = mad(0.1599626988172531f, _296, mad(-0.1470542997121811f, _293, (_290 * 0.883457362651825f)));
    _304 = mad(0.1599626988172531f, _297, mad(-0.1470542997121811f, _294, (_290 * 0.26293492317199707f)));
    _307 = mad(0.1599626988172531f, _298, mad(-0.1470542997121811f, _295, (_290 * -0.15930065512657166f)));
    _310 = mad(0.04929120093584061f, _296, mad(0.5183603167533875f, _293, (_290 * 0.38695648312568665f)));
    _313 = mad(0.04929120093584061f, _297, mad(0.5183603167533875f, _294, (_290 * 0.11516613513231277f)));
    _316 = mad(0.04929120093584061f, _298, mad(0.5183603167533875f, _295, (_290 * -0.0697740763425827f)));
    _319 = mad(0.9684867262840271f, _296, mad(0.04004279896616936f, _293, (_290 * -0.007634039502590895f)));
    _322 = mad(0.9684867262840271f, _297, mad(0.04004279896616936f, _294, (_290 * -0.0022720457054674625f)));
    _325 = mad(0.9684867262840271f, _298, mad(0.04004279896616936f, _295, (_290 * 0.0013765322510153055f)));
    _328 = mad(_307, (WorkingColorSpace_000[2].x), mad(_304, (WorkingColorSpace_000[1].x), (_301 * (WorkingColorSpace_000[0].x))));
    _331 = mad(_307, (WorkingColorSpace_000[2].y), mad(_304, (WorkingColorSpace_000[1].y), (_301 * (WorkingColorSpace_000[0].y))));
    _334 = mad(_307, (WorkingColorSpace_000[2].z), mad(_304, (WorkingColorSpace_000[1].z), (_301 * (WorkingColorSpace_000[0].z))));
    _337 = mad(_316, (WorkingColorSpace_000[2].x), mad(_313, (WorkingColorSpace_000[1].x), (_310 * (WorkingColorSpace_000[0].x))));
    _340 = mad(_316, (WorkingColorSpace_000[2].y), mad(_313, (WorkingColorSpace_000[1].y), (_310 * (WorkingColorSpace_000[0].y))));
    _343 = mad(_316, (WorkingColorSpace_000[2].z), mad(_313, (WorkingColorSpace_000[1].z), (_310 * (WorkingColorSpace_000[0].z))));
    _346 = mad(_325, (WorkingColorSpace_000[2].x), mad(_322, (WorkingColorSpace_000[1].x), (_319 * (WorkingColorSpace_000[0].x))));
    _349 = mad(_325, (WorkingColorSpace_000[2].y), mad(_322, (WorkingColorSpace_000[1].y), (_319 * (WorkingColorSpace_000[0].y))));
    _352 = mad(_325, (WorkingColorSpace_000[2].z), mad(_322, (WorkingColorSpace_000[1].z), (_319 * (WorkingColorSpace_000[0].z))));
    _390 = mad(mad((WorkingColorSpace_064[0].z), _352, mad((WorkingColorSpace_064[0].y), _343, (_334 * (WorkingColorSpace_064[0].x)))), _128, mad(mad((WorkingColorSpace_064[0].z), _349, mad((WorkingColorSpace_064[0].y), _340, (_331 * (WorkingColorSpace_064[0].x)))), _127, (mad((WorkingColorSpace_064[0].z), _346, mad((WorkingColorSpace_064[0].y), _337, (_328 * (WorkingColorSpace_064[0].x)))) * _126)));
    _391 = mad(mad((WorkingColorSpace_064[1].z), _352, mad((WorkingColorSpace_064[1].y), _343, (_334 * (WorkingColorSpace_064[1].x)))), _128, mad(mad((WorkingColorSpace_064[1].z), _349, mad((WorkingColorSpace_064[1].y), _340, (_331 * (WorkingColorSpace_064[1].x)))), _127, (mad((WorkingColorSpace_064[1].z), _346, mad((WorkingColorSpace_064[1].y), _337, (_328 * (WorkingColorSpace_064[1].x)))) * _126)));
    _392 = mad(mad((WorkingColorSpace_064[2].z), _352, mad((WorkingColorSpace_064[2].y), _343, (_334 * (WorkingColorSpace_064[2].x)))), _128, mad(mad((WorkingColorSpace_064[2].z), _349, mad((WorkingColorSpace_064[2].y), _340, (_331 * (WorkingColorSpace_064[2].x)))), _127, (mad((WorkingColorSpace_064[2].z), _346, mad((WorkingColorSpace_064[2].y), _337, (_328 * (WorkingColorSpace_064[2].x)))) * _126)));
  } else {
    _390 = _126;
    _391 = _127;
    _392 = _128;
  }
  _407 = mad((WorkingColorSpace_128[0].z), _392, mad((WorkingColorSpace_128[0].y), _391, ((WorkingColorSpace_128[0].x) * _390)));
  _410 = mad((WorkingColorSpace_128[1].z), _392, mad((WorkingColorSpace_128[1].y), _391, ((WorkingColorSpace_128[1].x) * _390)));
  _413 = mad((WorkingColorSpace_128[2].z), _392, mad((WorkingColorSpace_128[2].y), _391, ((WorkingColorSpace_128[2].x) * _390)));
  _414 = dot(float3(_407, _410, _413), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _418 = (_407 / _414) + -1.0f;
  _419 = (_410 / _414) + -1.0f;
  _420 = (_413 / _414) + -1.0f;
  _432 = (1.0f - exp2(((_414 * _414) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_418, _419, _420), float3(_418, _419, _420)) * -4.0f));
  _448 = ((mad(-0.06368321925401688f, _413, mad(-0.3292922377586365f, _410, (_407 * 1.3704125881195068f))) - _407) * _432) + _407;
  _449 = ((mad(-0.010861365124583244f, _413, mad(1.0970927476882935f, _410, (_407 * -0.08343357592821121f))) - _410) * _432) + _410;
  _450 = ((mad(1.2036951780319214f, _413, mad(-0.09862580895423889f, _410, (_407 * -0.02579331398010254f))) - _413) * _432) + _413;
  _451 = dot(float3(_448, _449, _450), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _465 = cb0_021w + cb0_026w;
  _479 = cb0_020w * cb0_025w;
  _493 = cb0_019w * cb0_024w;
  _507 = cb0_018w * cb0_023w;
  _521 = cb0_017w * cb0_022w;
  _525 = _448 - _451;
  _526 = _449 - _451;
  _527 = _450 - _451;
  _584 = saturate(_451 / cb0_037w);
  _588 = (_584 * _584) * (3.0f - (_584 * 2.0f));
  _589 = 1.0f - _588;
  _598 = cb0_021w + cb0_036w;
  _607 = cb0_020w * cb0_035w;
  _616 = cb0_019w * cb0_034w;
  _625 = cb0_018w * cb0_033w;
  _634 = cb0_017w * cb0_032w;
  _697 = saturate((_451 - cb0_038x) / (cb0_038y - cb0_038x));
  _701 = (_697 * _697) * (3.0f - (_697 * 2.0f));
  _710 = cb0_021w + cb0_031w;
  _719 = cb0_020w * cb0_030w;
  _728 = cb0_019w * cb0_029w;
  _737 = cb0_018w * cb0_028w;
  _746 = cb0_017w * cb0_027w;
  _804 = _588 - _701;
  _815 = ((_701 * (((cb0_021x + cb0_036x) + _598) + (((cb0_020x * cb0_035x) * _607) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _625) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _634) * _525) + _451)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _616)))))) + (_589 * (((cb0_021x + cb0_026x) + _465) + (((cb0_020x * cb0_025x) * _479) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _507) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _521) * _525) + _451)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _493))))))) + ((((cb0_021x + cb0_031x) + _710) + (((cb0_020x * cb0_030x) * _719) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _737) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _746) * _525) + _451)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _728))))) * _804);
  _817 = ((_701 * (((cb0_021y + cb0_036y) + _598) + (((cb0_020y * cb0_035y) * _607) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _625) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _634) * _526) + _451)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _616)))))) + (_589 * (((cb0_021y + cb0_026y) + _465) + (((cb0_020y * cb0_025y) * _479) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _507) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _521) * _526) + _451)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _493))))))) + ((((cb0_021y + cb0_031y) + _710) + (((cb0_020y * cb0_030y) * _719) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _737) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _746) * _526) + _451)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _728))))) * _804);
  _819 = ((_701 * (((cb0_021z + cb0_036z) + _598) + (((cb0_020z * cb0_035z) * _607) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _625) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _634) * _527) + _451)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _616)))))) + (_589 * (((cb0_021z + cb0_026z) + _465) + (((cb0_020z * cb0_025z) * _479) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _507) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _521) * _527) + _451)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _493))))))) + ((((cb0_021z + cb0_031z) + _710) + (((cb0_020z * cb0_030z) * _719) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _737) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _746) * _527) + _451)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _728))))) * _804);

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
  float4 output = ProcessLutbuilder(float3(_815, _817, _819), s0, s1, s2, s3, t0, t1, t2, t3, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _855 = ((mad(0.061360642313957214f, _819, mad(-4.540197551250458e-09f, _817, (_815 * 0.9386394023895264f))) - _815) * cb0_038z) + _815;
  _856 = ((mad(0.169205904006958f, _819, mad(0.8307942152023315f, _817, (_815 * 6.775371730327606e-08f))) - _817) * cb0_038z) + _817;
  _857 = (mad(-2.3283064365386963e-10f, _817, (_815 * -9.313225746154785e-10f)) * cb0_038z) + _819;
  _860 = mad(0.16386905312538147f, _857, mad(0.14067868888378143f, _856, (_855 * 0.6954522132873535f)));
  _863 = mad(0.0955343246459961f, _857, mad(0.8596711158752441f, _856, (_855 * 0.044794581830501556f)));
  _866 = mad(1.0015007257461548f, _857, mad(0.004025210160762072f, _856, (_855 * -0.005525882821530104f)));
  _870 = max(max(_860, _863), _866);
  _875 = (max(_870, 1.000000013351432e-10f) - max(min(min(_860, _863), _866), 1.000000013351432e-10f)) / max(_870, 0.009999999776482582f);
  _888 = ((_863 + _860) + _866) + (sqrt((((_866 - _863) * _866) + ((_863 - _860) * _863)) + ((_860 - _866) * _860)) * 1.75f);
  _889 = _888 * 0.3333333432674408f;
  _890 = _875 + -0.4000000059604645f;
  _891 = _890 * 5.0f;
  _895 = max((1.0f - abs(_890 * 2.5f)), 0.0f);
  _906 = ((float((int)(((int)(uint)((int)(_891 > 0.0f))) - ((int)(uint)((int)(_891 < 0.0f))))) * (1.0f - (_895 * _895))) + 1.0f) * 0.02500000037252903f;
  if (_889 > 0.0533333346247673f) {
    if (_889 < 0.1599999964237213f) {
      _915 = (((0.23999999463558197f / _888) + -0.5f) * _906);
    } else {
      _915 = 0.0f;
    }
  } else {
    _915 = _906;
  }
  _916 = _915 + 1.0f;
  _917 = _916 * _860;
  _918 = _916 * _863;
  _919 = _916 * _866;
  if (!((_917 == _918) && (_918 == _919))) {
    _926 = ((_917 * 2.0f) - _918) - _919;
    _929 = ((_863 - _866) * 1.7320507764816284f) * _916;
    _931 = atan(_929 / _926);
    _934 = (_926 < 0.0f);
    _935 = (_926 == 0.0f);
    _936 = (_929 >= 0.0f);
    _937 = (_929 < 0.0f);
    _948 = select((_936 && _935), 90.0f, select((_937 && _935), -90.0f, (select((_937 && _934), (_931 + -3.1415927410125732f), select((_936 && _934), (_931 + 3.1415927410125732f), _931)) * 57.2957763671875f)));
  } else {
    _948 = 0.0f;
  }
  _953 = min(max(select((_948 < 0.0f), (_948 + 360.0f), _948), 0.0f), 360.0f);
  if (_953 < -180.0f) {
    _962 = (_953 + 360.0f);
  } else {
    if (_953 > 180.0f) {
      _962 = (_953 + -360.0f);
    } else {
      _962 = _953;
    }
  }
  _966 = saturate(1.0f - abs(_962 * 0.014814814552664757f));
  _970 = (_966 * _966) * (3.0f - (_966 * 2.0f));
  _976 = ((_970 * _970) * ((_875 * 0.18000000715255737f) * (0.029999999329447746f - _917))) + _917;
  _986 = max(0.0f, mad(-0.21492856740951538f, _919, mad(-0.2365107536315918f, _918, (_976 * 1.4514392614364624f))));
  _987 = max(0.0f, mad(-0.09967592358589172f, _919, mad(1.17622971534729f, _918, (_976 * -0.07655377686023712f))));
  _988 = max(0.0f, mad(0.9977163076400757f, _919, mad(-0.006032449658960104f, _918, (_976 * 0.008316148072481155f))));
  _989 = dot(float3(_986, _987, _988), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1004 = (cb0_040x + 1.0f) - cb0_039z;
  _1006 = cb0_040y + 1.0f;
  _1008 = _1006 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1026 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1017 = (cb0_040x + 0.18000000715255737f) / _1004;
    _1026 = (-0.7447274923324585f - ((log2(_1017 / (2.0f - _1017)) * 0.3465735912322998f) * (_1004 / cb0_039y)));
  }
  _1029 = ((1.0f - cb0_039z) / cb0_039y) - _1026;
  _1031 = (cb0_039w / cb0_039y) - _1029;
  _1035 = log2(lerp(_989, _986, 0.9599999785423279f)) * 0.3010300099849701f;
  _1036 = log2(lerp(_989, _987, 0.9599999785423279f)) * 0.3010300099849701f;
  _1037 = log2(lerp(_989, _988, 0.9599999785423279f)) * 0.3010300099849701f;
  _1041 = cb0_039y * (_1035 + _1029);
  _1042 = cb0_039y * (_1036 + _1029);
  _1043 = cb0_039y * (_1037 + _1029);
  _1044 = _1004 * 2.0f;
  _1046 = (cb0_039y * -2.0f) / _1004;
  _1047 = _1035 - _1026;
  _1048 = _1036 - _1026;
  _1049 = _1037 - _1026;
  _1068 = _1008 * 2.0f;
  _1070 = (cb0_039y * 2.0f) / _1008;
  _1095 = select((_1035 < _1026), ((_1044 / (exp2((_1047 * 1.4426950216293335f) * _1046) + 1.0f)) - cb0_040x), _1041);
  _1096 = select((_1036 < _1026), ((_1044 / (exp2((_1048 * 1.4426950216293335f) * _1046) + 1.0f)) - cb0_040x), _1042);
  _1097 = select((_1037 < _1026), ((_1044 / (exp2((_1049 * 1.4426950216293335f) * _1046) + 1.0f)) - cb0_040x), _1043);
  _1104 = _1031 - _1026;
  _1108 = saturate(_1047 / _1104);
  _1109 = saturate(_1048 / _1104);
  _1110 = saturate(_1049 / _1104);
  _1111 = (_1031 < _1026);
  _1115 = select(_1111, (1.0f - _1108), _1108);
  _1116 = select(_1111, (1.0f - _1109), _1109);
  _1117 = select(_1111, (1.0f - _1110), _1110);
  _1136 = (((_1115 * _1115) * (select((_1035 > _1031), (_1006 - (_1068 / (exp2(((_1035 - _1031) * 1.4426950216293335f) * _1070) + 1.0f))), _1041) - _1095)) * (3.0f - (_1115 * 2.0f))) + _1095;
  _1137 = (((_1116 * _1116) * (select((_1036 > _1031), (_1006 - (_1068 / (exp2(((_1036 - _1031) * 1.4426950216293335f) * _1070) + 1.0f))), _1042) - _1096)) * (3.0f - (_1116 * 2.0f))) + _1096;
  _1138 = (((_1117 * _1117) * (select((_1037 > _1031), (_1006 - (_1068 / (exp2(((_1037 - _1031) * 1.4426950216293335f) * _1070) + 1.0f))), _1043) - _1097)) * (3.0f - (_1117 * 2.0f))) + _1097;
  _1139 = dot(float3(_1136, _1137, _1138), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1159 = (cb0_039x * (max(0.0f, (lerp(_1139, _1136, 0.9300000071525574f))) - _855)) + _855;
  _1160 = (cb0_039x * (max(0.0f, (lerp(_1139, _1137, 0.9300000071525574f))) - _856)) + _856;
  _1161 = (cb0_039x * (max(0.0f, (lerp(_1139, _1138, 0.9300000071525574f))) - _857)) + _857;
  _1177 = ((mad(-0.06537103652954102f, _1161, mad(1.451815478503704e-06f, _1160, (_1159 * 1.065374732017517f))) - _1159) * cb0_038z) + _1159;
  _1178 = ((mad(-0.20366770029067993f, _1161, mad(1.2036634683609009f, _1160, (_1159 * -2.57161445915699e-07f))) - _1160) * cb0_038z) + _1160;
  _1179 = ((mad(0.9999996423721313f, _1161, mad(2.0954757928848267e-08f, _1160, (_1159 * 1.862645149230957e-08f))) - _1161) * cb0_038z) + _1161;
  _1192 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1179, mad((WorkingColorSpace_192[0].y), _1178, ((WorkingColorSpace_192[0].x) * _1177)))));
  _1193 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1179, mad((WorkingColorSpace_192[1].y), _1178, ((WorkingColorSpace_192[1].x) * _1177)))));
  _1194 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1179, mad((WorkingColorSpace_192[2].y), _1178, ((WorkingColorSpace_192[2].x) * _1177)))));
  if (_1192 < 0.0031306699384003878f) {
    _1205 = (_1192 * 12.920000076293945f);
  } else {
    _1205 = (((pow(_1192, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1193 < 0.0031306699384003878f) {
    _1216 = (_1193 * 12.920000076293945f);
  } else {
    _1216 = (((pow(_1193, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1194 < 0.0031306699384003878f) {
    _1227 = (_1194 * 12.920000076293945f);
  } else {
    _1227 = (((pow(_1194, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1231 = (_1216 * 0.9375f) + 0.03125f;
  _1238 = _1227 * 15.0f;
  _1239 = floor(_1238);
  _1240 = _1238 - _1239;
  _1242 = (_1239 + ((_1205 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1245 = t0.SampleLevel(s0, float2(_1242, _1231), 0.0f);
  _1249 = _1242 + 0.0625f;
  _1250 = t0.SampleLevel(s0, float2(_1249, _1231), 0.0f);
  _1272 = t1.SampleLevel(s1, float2(_1242, _1231), 0.0f);
  _1276 = t1.SampleLevel(s1, float2(_1249, _1231), 0.0f);
  _1298 = t2.SampleLevel(s2, float2(_1242, _1231), 0.0f);
  _1302 = t2.SampleLevel(s2, float2(_1249, _1231), 0.0f);
  _1325 = t3.SampleLevel(s3, float2(_1242, _1231), 0.0f);
  _1329 = t3.SampleLevel(s3, float2(_1249, _1231), 0.0f);
  _1345 = (((((lerp(_1245.x, _1250.x, _1240)) * cb0_005y) + (cb0_005x * _1205)) + ((lerp(_1272.x, _1276.x, _1240)) * cb0_005z)) + ((lerp(_1298.x, _1302.x, _1240)) * cb0_005w)) + ((lerp(_1325.x, _1329.x, _1240)) * cb0_006x);
  _1346 = (((((lerp(_1245.y, _1250.y, _1240)) * cb0_005y) + (cb0_005x * _1216)) + ((lerp(_1272.y, _1276.y, _1240)) * cb0_005z)) + ((lerp(_1298.y, _1302.y, _1240)) * cb0_005w)) + ((lerp(_1325.y, _1329.y, _1240)) * cb0_006x);
  _1347 = (((((lerp(_1245.z, _1250.z, _1240)) * cb0_005y) + (cb0_005x * _1227)) + ((lerp(_1272.z, _1276.z, _1240)) * cb0_005z)) + ((lerp(_1298.z, _1302.z, _1240)) * cb0_005w)) + ((lerp(_1325.z, _1329.z, _1240)) * cb0_006x);
  _1372 = select((_1345 > 0.040449999272823334f), exp2(log2((abs(_1345) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1345 * 0.07739938050508499f));
  _1373 = select((_1346 > 0.040449999272823334f), exp2(log2((abs(_1346) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1346 * 0.07739938050508499f));
  _1374 = select((_1347 > 0.040449999272823334f), exp2(log2((abs(_1347) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1347 * 0.07739938050508499f));
  _1400 = cb0_016x * (((cb0_041y + (cb0_041x * _1372)) * _1372) + cb0_041z);
  _1401 = cb0_016y * (((cb0_041y + (cb0_041x * _1373)) * _1373) + cb0_041z);
  _1402 = cb0_016z * (((cb0_041y + (cb0_041x * _1374)) * _1374) + cb0_041z);
  _1409 = ((cb0_015x - _1400) * cb0_015w) + _1400;
  _1410 = ((cb0_015y - _1401) * cb0_015w) + _1401;
  _1411 = ((cb0_015z - _1402) * cb0_015w) + _1402;
  _1412 = cb0_016x * mad((WorkingColorSpace_192[0].z), _819, mad((WorkingColorSpace_192[0].y), _817, (_815 * (WorkingColorSpace_192[0].x))));
  _1413 = cb0_016y * mad((WorkingColorSpace_192[1].z), _819, mad((WorkingColorSpace_192[1].y), _817, ((WorkingColorSpace_192[1].x) * _815)));
  _1414 = cb0_016z * mad((WorkingColorSpace_192[2].z), _819, mad((WorkingColorSpace_192[2].y), _817, ((WorkingColorSpace_192[2].x) * _815)));
  _1421 = ((cb0_015x - _1412) * cb0_015w) + _1412;
  _1422 = ((cb0_015y - _1413) * cb0_015w) + _1413;
  _1423 = ((cb0_015z - _1414) * cb0_015w) + _1414;
  _1435 = exp2(log2(max(0.0f, _1409)) * cb0_042y);
  _1436 = exp2(log2(max(0.0f, _1410)) * cb0_042y);
  _1437 = exp2(log2(max(0.0f, _1411)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1460 = mad((WorkingColorSpace_128[0].z), _1437, mad((WorkingColorSpace_128[0].y), _1436, ((WorkingColorSpace_128[0].x) * _1435)));
      _1463 = mad((WorkingColorSpace_128[1].z), _1437, mad((WorkingColorSpace_128[1].y), _1436, ((WorkingColorSpace_128[1].x) * _1435)));
      _1466 = mad((WorkingColorSpace_128[2].z), _1437, mad((WorkingColorSpace_128[2].y), _1436, ((WorkingColorSpace_128[2].x) * _1435)));
      _1477 = mad(_62, _1466, mad(_61, _1463, (_1460 * _60)));
      _1478 = mad(_65, _1466, mad(_64, _1463, (_1460 * _63)));
      _1479 = mad(_68, _1466, mad(_67, _1463, (_1460 * _66)));
    } else {
      _1477 = _1435;
      _1478 = _1436;
      _1479 = _1437;
    }
    if (_1477 < 0.0031306699384003878f) {
      _1490 = (_1477 * 12.920000076293945f);
    } else {
      _1490 = (((pow(_1477, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1478 < 0.0031306699384003878f) {
      _1501 = (_1478 * 12.920000076293945f);
    } else {
      _1501 = (((pow(_1478, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1479 < 0.0031306699384003878f) {
      _3507 = _1490;
      _3508 = _1501;
      _3509 = (_1479 * 12.920000076293945f);
    } else {
      _3507 = _1490;
      _3508 = _1501;
      _3509 = (((pow(_1479, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1528 = mad((WorkingColorSpace_128[0].z), _1437, mad((WorkingColorSpace_128[0].y), _1436, ((WorkingColorSpace_128[0].x) * _1435)));
      _1531 = mad((WorkingColorSpace_128[1].z), _1437, mad((WorkingColorSpace_128[1].y), _1436, ((WorkingColorSpace_128[1].x) * _1435)));
      _1534 = mad((WorkingColorSpace_128[2].z), _1437, mad((WorkingColorSpace_128[2].y), _1436, ((WorkingColorSpace_128[2].x) * _1435)));
      _1537 = mad(_62, _1534, mad(_61, _1531, (_1528 * _60)));
      _1540 = mad(_65, _1534, mad(_64, _1531, (_1528 * _63)));
      _1543 = mad(_68, _1534, mad(_67, _1531, (_1528 * _66)));
      _3507 = min((_1537 * 4.5f), ((exp2(log2(max(_1537, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3508 = min((_1540 * 4.5f), ((exp2(log2(max(_1540, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3509 = min((_1543 * 4.5f), ((exp2(log2(max(_1543, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
        _1588 = cb0_012z * _1421;
        _1589 = cb0_012z * _1422;
        _1590 = cb0_012z * _1423;
        _1593 = mad((WorkingColorSpace_256[0].z), _1590, mad((WorkingColorSpace_256[0].y), _1589, (_1588 * (WorkingColorSpace_256[0].x))));
        _1596 = mad((WorkingColorSpace_256[1].z), _1590, mad((WorkingColorSpace_256[1].y), _1589, (_1588 * (WorkingColorSpace_256[1].x))));
        _1599 = mad((WorkingColorSpace_256[2].z), _1590, mad((WorkingColorSpace_256[2].y), _1589, (_1588 * (WorkingColorSpace_256[2].x))));
        _1600 = cb0_043y * 0.009999999776482582f;
        _1601 = log2(_1600);
        _1606 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
        _1621 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_1606 * 400.0f) / (_1606 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1623 = (_1601 * 1.4018198251724243f) + 10.012999534606934f;
        _1628 = exp2(log2(abs(_1623) * 0.00793700572103262f) * 0.41999998688697815f);
        _1669 = (_1601 * 924.7640991210938f) + 1024.0f;
        _1673 = min(max(mad(-0.21492856740951538f, _1599, mad(-0.2365107536315918f, _1596, (_1593 * 1.4514392614364624f))), 0.0f), _1669);
        _1674 = min(max(mad(-0.09967592358589172f, _1599, mad(1.17622971534729f, _1596, (_1593 * -0.07655377686023712f))), 0.0f), _1669);
        _1675 = min(max(mad(0.9977163076400757f, _1599, mad(-0.006032449658960104f, _1596, (_1593 * 0.008316148072481155f))), 0.0f), _1669);
        _1678 = mad(0.15618768334388733f, _1675, mad(0.13400420546531677f, _1674, (_1673 * 0.6624541878700256f)));
        _1685 = mad(0.053689517080783844f, _1675, mad(0.6740817427635193f, _1674, (_1673 * 0.2722287178039551f))) * 100.0f;
        _1686 = mad(1.0103391408920288f, _1675, mad(0.00406073359772563f, _1674, (_1673 * -0.005574649665504694f))) * 100.0f;
        _1696 = mad(0.04110127314925194f, _1686, mad(0.594700813293457f, _1685, (_1678 * 36.407447814941406f))) * 1.0172951221466064f;
        _1697 = mad(0.1479453295469284f, _1686, mad(1.0738555192947388f, _1685, (_1678 * -22.224510192871094f))) * 0.9887425899505615f;
        _1698 = mad(0.9503875374794006f, _1686, mad(0.04882604628801346f, _1685, (_1678 * -0.20676189661026f))) * 0.9944003820419312f;
        _1702 = abs(_1696) * 0.00793700572103262f;
        _1703 = abs(_1697) * 0.00793700572103262f;
        _1704 = abs(_1698) * 0.00793700572103262f;
        if (!(_1702 < 0.0f)) {
          _1711 = (pow(_1702, 0.41999998688697815f));
        } else {
          _1711 = 0.0f;
        }
        if (!(_1703 < 0.0f)) {
          _1718 = (pow(_1703, 0.41999998688697815f));
        } else {
          _1718 = 0.0f;
        }
        if (!(_1704 < 0.0f)) {
          _1725 = (pow(_1704, 0.41999998688697815f));
        } else {
          _1725 = 0.0f;
        }
        _1753 = ((float((int)(((int)(uint)((int)(_1696 > 0.0f))) - ((int)(uint)((int)(_1696 < 0.0f))))) * 400.0f) * _1711) / (_1711 + 27.1299991607666f);
        _1754 = ((float((int)(((int)(uint)((int)(_1697 > 0.0f))) - ((int)(uint)((int)(_1697 < 0.0f))))) * 400.0f) * _1718) / (_1718 + 27.1299991607666f);
        _1755 = ((float((int)(((int)(uint)((int)(_1698 > 0.0f))) - ((int)(uint)((int)(_1698 < 0.0f))))) * 400.0f) * _1725) / (_1725 + 27.1299991607666f);
        _1759 = (_1753 - (_1754 * 1.0909091234207153f)) + (_1755 * 0.09090909361839294f);
        _1763 = ((_1754 + _1753) - (_1755 * 2.0f)) * 0.1111111119389534f;
        _1765 = atan(_1763 / _1759);
        _1768 = (_1759 < 0.0f);
        _1769 = (_1759 == 0.0f);
        _1770 = (_1763 >= 0.0f);
        _1771 = (_1763 < 0.0f);
        _1780 = select((_1769 && _1770), 0.25f, select((_1769 && _1771), -0.25f, (select((_1768 && _1771), (_1765 + -3.1415927410125732f), select((_1768 && _1770), (_1765 + 3.1415927410125732f), _1765)) * 0.15915493667125702f)));
        _1784 = frac(abs(_1780));
        _1787 = select((_1780 >= (-0.0f - _1780)), _1784, (-0.0f - _1784)) * 360.0f;
        _1790 = select((_1787 < 0.0f), (_1787 + 360.0f), _1787);
        _1799 = exp2(log2((((_1753 * 2.0f) + _1754) + (_1755 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
        if (!(_1799 == 0.0f)) {
          _1808 = (sqrt((_1763 * _1763) + (_1759 * _1759)) * 38.70000076293945f);
        } else {
          _1808 = 0.0f;
        }
        _1813 = exp2(log2(abs(_1799) * 0.009999999776482582f) * 0.8794641494750977f);
        _1828 = (float((int)(((int)(uint)((int)(_1799 > 0.0f))) - ((int)(uint)((int)(_1799 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_1813 * 351.2578430175781f) / (400.0f - (_1813 * 12.947211265563965f))) * 2.3809523582458496f);
        _1830 = (_1601 * 115.59551239013672f) + 128.0f;
        _1834 = sqrt((_1600 + 0.1599999964237213f) * _1600) + _1600;
        _1835 = _1834 * 0.5f;
        _1836 = _1830 / _1835;
        _1843 = _1601 * 0.014018198475241661f;
        _1844 = _1843 + 0.10012999176979065f;
        _1854 = exp2(log2((((_1844 + sqrt(_1844 * (_1843 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_1830 / (_1835 * (_1836 + 1.0f))) * 1.149999976158142f)) / _1835) * 0.8695652484893799f);
        _1859 = 0.18000000715255737f / (((_1834 * -0.5f) * _1854) / (_1854 + -1.0f));
        _1874 = exp2(log2(max(0.0f, _1828) / ((_1859 * _1835) + _1828)) * 1.149999976158142f) * (_1835 / exp2(log2(_1830 / ((_1836 + _1859) * _1835)) * 1.149999976158142f));
        _1879 = max(0.0f, ((_1874 * _1874) / (_1874 + 0.03999999910593033f))) * 100.0f;
        _1884 = exp2(log2(abs(_1879) * 0.00793700572103262f) * 0.41999998688697815f);
        _1899 = (float((int)(((int)(uint)((int)(_1879 > 0.0f))) - ((int)(uint)((int)(_1879 < 0.0f))))) * 100.0f) * exp2(log2(((_1884 * 400.0f) / (_1884 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1901 = _1790 * 0.0027777778450399637f;
        _1902 = -0.0f - _1901;
        _1904 = frac(abs(_1901));
        _1905 = -0.0f - _1904;
        if (!(_1808 == 0.0f)) {
          _1907 = _1899 / _1621;
          _1909 = max(0.0f, (1.0f - _1907));
          _1910 = _1790 * 0.01745329424738884f;
          _1911 = cos(_1910);
          _1912 = sin(_1910);
          _1913 = _1911 * _1911;
          _1914 = _1912 * _1912;
          _1929 = ((((77.12895965576172f - ((_1911 * 12.74448013305664f) * _1912)) + ((_1913 - _1914) * 16.468990325927734f)) + (((_1913 * 31.535200119018555f) + -12.31067943572998f) * _1911)) + ((42.245330810546875f - (_1914 * 36.774559020996094f)) * _1912)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
          _1935 = select((_1901 >= _1902), _1904, _1905) * 360.0f;
          _1939 = int(select((_1935 < 0.0f), (_1935 + 360.0f), _1935));
          _1941 = (_1939 + 1) % 360;
          _1950 = t4.Load(int3(_1939, 0, 0));
          _1955 = (((((t4.Load(int3(_1941, 0, 0))).x) - _1950.x) * ((_1790 - float((int)(_1939))) / float((int)(_1941 - _1939)))) + _1950.x) * (pow(_1907, 0.8794641494750977f));
          _1956 = _1955 / _1929;
          _1957 = _1956 + -0.0010000000474974513f;
          _1958 = _1909 * max(0.20000000298023224f, (1.2999999523162842f - (_1601 * 0.270023912191391f)));
          _1959 = _1907 * ((_1601 * 2.384157657623291f) + 2.4000000953674316f);
          _1966 = (_1955 - (exp2(log2(_1899 / _1799) * 0.8794641494750977f) * _1808)) / _1929;
          if (!(_1966 > _1957)) {
            _1972 = max(sqrt((_1907 * _1907) + (0.5f / cb0_043y)), 0.0010000000474974513f);
            _1976 = sqrt((_1972 * _1972) + (_1958 * _1958));
            _1979 = (_1976 + _1957) / (_1972 + _1957);
            _1981 = (_1979 * _1966) - _1976;
            _1991 = ((_1981 + sqrt((_1981 * _1981) + (((_1966 * 4.0f) * _1972) * _1979))) * 0.5f);
          } else {
            _1991 = _1966;
          }
          _1992 = _1956 - _1991;
          if (!(_1992 > _1956)) {
            _1995 = max(_1909, 0.0010000000474974513f);
            _1999 = sqrt((_1995 * _1995) + (_1959 * _1959));
            _2002 = (_1999 + _1956) / (_1995 + _1956);
            _2004 = (_2002 * _1992) - _1999;
            _2014 = ((_2004 + sqrt((_2004 * _2004) + (((_1992 * 4.0f) * _1995) * _2002))) * 0.5f);
          } else {
            _2014 = _1992;
          }
          _2017 = (_2014 * _1929);
        } else {
          _2017 = _1808;
        }
        _2020 = select((_1901 >= _1902), _1904, _1905) * 360.0f;
        _2023 = select((_2020 < 0.0f), (_2020 + 360.0f), _2020);
        _2024 = int(_2023);
        _2025 = _2024 + 1;
        _2027 = 0;
        _2028 = 361;
        _2029 = _2025;
        while(true) {
          _2033 = (_1790 > (((float3)(t5.Load(int3(_2029, 0, 0)))).z));
          _2034 = select(_2033, _2029, _2027);
          _2035 = select(_2033, _2028, _2029);
          if ((int)(_2034 + 1) < (int)_2035) {
            _2027 = _2034;
            _2028 = _2035;
            _2029 = ((_2034 + _2035) / 2);
            continue;
          }
          _2042 = t5.Load(int3((_2035 + -1), 0, 0));
          _2046 = t5.Load(int3(_2035, 0, 0));
          _2052 = (_1790 - _2042.z) / (_2046.z - _2042.z);
          _2055 = ((_2046.x - _2042.x) * _2052) + _2042.x;
          if (!((_1899 > _1621) || (_2017 < 9.999999747378752e-05f))) {
            _2069 = (min(1.0f, (1.2999999523162842f - (_2055 / _1621))) * (((float((int)(((int)(uint)((int)(_1623 > 0.0f))) - ((int)(uint)((int)(_1623 < 0.0f))))) * 100.0f) * exp2(log2(((_1628 * 400.0f) / (_1628 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _2055)) + _2055;
            _2070 = ((_1601 * 0.7111833691596985f) + 1.350000023841858f) * _1621;
            _2071 = _1621 - _2055;
            _2073 = (_2071 * 0.30000001192092896f) + _2055;
            if (_1899 > _2073) {
              _2087 = (exp2(log2(log2((_1621 - _2073) / max(9.999999747378752e-05f, (_1621 - _1899))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _2087 = 1.0f;
            }
            _2088 = _2070 * _2087;
            t6.GetDimensions(_2090.x, _2090.y);
            _2094 = float((int)(_2024));
            _2098 = t6.Load(int3(_2025, 0, 0));
            _2103 = (lerp(_2042.y, _2046.y, _2052)) * 1.0324000120162964f;
            _2104 = _2088 * _2069;
            _2106 = (_1899 < _2069);
            _2107 = _2017 / _2088;
            if (_2106) {
              _2117 = (1.0f - _2107);
            } else {
              _2117 = (-0.0f - ((_2107 + 1.0f) + ((_2017 * _1621) / _2104)));
            }
            if (_2106) {
              _2125 = (-0.0f - _1899);
            } else {
              _2125 = (((_2017 * _1621) / _2088) + _1899);
            }
            _2130 = sqrt((_2117 * _2117) - (((_2017 / _2104) * 4.0f) * _2125));
            _2136 = (_2125 * 2.0f) / select(_2106, ((-0.0f - _2117) - _2130), (_2130 - _2117));
            _2138 = (_2055 < _2069);
            _2139 = _2103 / _2088;
            if (_2138) {
              _2149 = (1.0f - _2139);
            } else {
              _2149 = (-0.0f - ((_2139 + 1.0f) + ((_2103 * _1621) / _2104)));
            }
            if (!_2138) {
              _2155 = (((_2103 * _1621) / _2088) + _2055);
            } else {
              _2155 = (-0.0f - _2055);
            }
            _2160 = sqrt((_2149 * _2149) - (((_2103 / _2104) * 4.0f) * _2155));
            _2166 = (_2155 * 2.0f) / select(_2138, ((-0.0f - _2149) - _2160), (_2160 - _2149));
            _2168 = _1621 - _2136;
            _2172 = ((_2136 - _2069) * select((_2136 < _2069), _2136, _2168)) / _2104;
            _2181 = _1621 - _2166;
            _2192 = ((_2181 * _2103) * exp2(log2(_2168 / _2181) * (1.0f / (((((t6.Load(int3(((_2024 + 2) % (int)(_2090.x)), 0, 0))).x) - _2098.x) * (_2023 - _2094)) + _2098.x)))) / ((_2071 + (_2172 * _2103)) * _2103);
            _2194 = (exp2(log2(_2136 / _2166) * (1.0f / ((_1601 * 0.02107210084795952f) + 1.1399999856948853f))) * _2166) / (((_2055 / _2103) - _2172) * _2103);
            _2198 = max((0.11999999731779099f - abs(_2194 - _2192)), 0.0f);
            _2199 = _2198 * 8.333333969116211f;
            _2205 = (min(_2194, _2192) - ((_2199 * _2199) * (_2198 * 0.1666666716337204f))) * _2103;
            _2206 = _2205 * _2172;
            _2207 = _2206 + _2136;
            _2208 = _2025 % 360;
            _2216 = t4.Load(int3(_2024, 0, 0));
            _2220 = ((((t4.Load(int3(_2208, 0, 0))).x) - _2216.x) * ((_1790 - _2094) / float((int)(_2208 - _2024)))) + _2216.x;
            if (_2207 > _2073) {
              _2234 = (exp2(log2(log2((_1621 - _2073) / max(9.999999747378752e-05f, (_1621 - _2207))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _2234 = 1.0f;
            }
            _2235 = _2070 * _2234;
            _2236 = _2235 * _2069;
            _2238 = (_2207 < _2069);
            _2239 = _2205 / _2235;
            if (_2238) {
              _2249 = (1.0f - _2239);
            } else {
              _2249 = (-0.0f - ((_2239 + 1.0f) + ((_2205 * _1621) / _2236)));
            }
            if (_2238) {
              _2257 = (-0.0f - _2207);
            } else {
              _2257 = (((_2205 * _1621) / _2235) + _2207);
            }
            _2262 = sqrt((_2249 * _2249) - (((_2205 / _2236) * 4.0f) * _2257));
            _2268 = (_2257 * 2.0f) / select(_2238, ((-0.0f - _2249) - _2262), (_2262 - _2249));
            _2285 = max(1.000100016593933f, (((_2220 * _1621) * exp2(log2(_2268 / _1621) * 0.8794641494750977f)) / ((_1621 - ((((_2268 - _2069) * select((_2268 < _2069), _2268, (_1621 - _2268))) / _2236) * _2220)) * _2205)));
            _2287 = max(0.75f, (1.0f / _2285));
            _2288 = _2017 / _2205;
            _2293 = ((_2285 - _2287) * (1.0f - _2287)) / (_2285 + -1.0f);
            _2295 = (_2288 - _2287) / _2293;
            if (!((_2285 <= 1.000100016593933f) || (_2288 < _2287))) {
              _2305 = (((_2295 * _2293) / (_2295 + 1.0f)) + _2287);
            } else {
              _2305 = _2288;
            }
            _2311 = ((_2305 * _2206) + _2136);
            _2312 = ((_2205 * _2305) * 0.0258397925645113f);
          } else {
            _2311 = _1899;
            _2312 = 0.0f;
          }
          _2313 = _1790 * 0.01745329424738884f;
          _2314 = _2311 * 0.009999999776482582f;
          if (!(_2314 < 0.0f)) {
            _2323 = (((pow(_2314, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
          } else {
            _2323 = 0.0f;
          }
          _2325 = cos(_2313) * _2312;
          _2327 = sin(_2313) * _2312;
          _2334 = mad(288.0f, _2327, mad(451.0f, _2325, _2323)) * 0.0007127583958208561f;
          _2335 = mad(-261.0f, _2327, mad(-891.0f, _2325, _2323)) * 0.0007127583958208561f;
          _2336 = mad(-6300.0f, _2327, mad(-220.0f, _2325, _2323)) * 0.0007127583958208561f;
          _2356 = abs(_2334);
          _2357 = abs(_2335);
          _2358 = abs(_2336);
          _2365 = (_2356 * 27.1299991607666f) / (400.0f - _2356);
          _2366 = (_2357 * 27.1299991607666f) / (400.0f - _2357);
          _2367 = (_2358 * 27.1299991607666f) / (400.0f - _2358);
          if (!(_2365 < 0.0f)) {
            _2374 = (pow(_2365, 2.3809523582458496f));
          } else {
            _2374 = 0.0f;
          }
          if (!(_2366 < 0.0f)) {
            _2381 = (pow(_2366, 2.3809523582458496f));
          } else {
            _2381 = 0.0f;
          }
          if (!(_2367 < 0.0f)) {
            _2388 = (pow(_2367, 2.3809523582458496f));
          } else {
            _2388 = 0.0f;
          }
          _2389 = (float((int)(((int)(uint)((int)(_2334 > 0.0f))) - ((int)(uint)((int)(_2334 < 0.0f))))) * 125.99209594726562f) * _2374;
          _2391 = (float((int)(((int)(uint)((int)(_2335 > 0.0f))) - ((int)(uint)((int)(_2335 < 0.0f))))) * 127.42658996582031f) * _2381;
          _2393 = (float((int)(((int)(uint)((int)(_2336 > 0.0f))) - ((int)(uint)((int)(_2336 < 0.0f))))) * 126.70159912109375f) * _2388;
          _2396 = mad(0.08875565975904465f, _2393, mad(-1.140031337738037f, _2391, (_2389 * 2.016401767730713f)));
          _2403 = mad(-0.12752249836921692f, _2393, mad(0.7005835175514221f, _2391, (_2389 * 0.41968056559562683f))) * 0.009999999776482582f;
          _2404 = mad(1.0589468479156494f, _2393, mad(-0.03847259283065796f, _2391, (_2389 * -0.01717424765229225f))) * 0.009999999776482582f;
          _2417 = min(max(mad(-0.23642469942569733f, _2404, mad(-0.32480329275131226f, _2403, (_2396 * 0.016410233452916145f))), 0.0f), _1600);
          _2418 = min(max(mad(0.016756348311901093f, _2404, mad(1.6153316497802734f, _2403, (_2396 * -0.006636628415435553f))), 0.0f), _1600);
          _2419 = min(max(mad(0.9883948564529419f, _2404, mad(-0.008284442126750946f, _2403, (_2396 * 0.00011721893679350615f))), 0.0f), _1600);
          _2422 = mad(0.15618768334388733f, _2419, mad(0.13400420546531677f, _2418, (_2417 * 0.6624541878700256f)));
          _2425 = mad(0.053689517080783844f, _2419, mad(0.6740817427635193f, _2418, (_2417 * 0.2722287178039551f)));
          _2428 = mad(1.0103391408920288f, _2419, mad(0.00406073359772563f, _2418, (_2417 * -0.005574649665504694f)));
          _2438 = mad(-0.23642469942569733f, _2428, mad(-0.32480329275131226f, _2425, (_2422 * 1.6410233974456787f))) * 100.0f;
          _2439 = mad(0.016756348311901093f, _2428, mad(1.6153316497802734f, _2425, (_2422 * -0.663662850856781f))) * 100.0f;
          _2440 = mad(0.9883948564529419f, _2428, mad(-0.008284442126750946f, _2425, (_2422 * 0.011721894145011902f))) * 100.0f;
          _2459 = exp2(log2(mad(_62, _2440, mad(_61, _2439, (_2438 * _60))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2460 = exp2(log2(mad(_65, _2440, mad(_64, _2439, (_2438 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2461 = exp2(log2(mad(_68, _2440, mad(_67, _2439, (_2438 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _3507 = exp2(log2((1.0f / ((_2459 * 18.6875f) + 1.0f)) * ((_2459 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3508 = exp2(log2((1.0f / ((_2460 * 18.6875f) + 1.0f)) * ((_2460 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3509 = exp2(log2((1.0f / ((_2461 * 18.6875f) + 1.0f)) * ((_2461 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          break;
        }
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2509 = cb0_012z * _1421;
          _2510 = cb0_012z * _1422;
          _2511 = cb0_012z * _1423;
          _2514 = mad((WorkingColorSpace_256[0].z), _2511, mad((WorkingColorSpace_256[0].y), _2510, (_2509 * (WorkingColorSpace_256[0].x))));
          _2517 = mad((WorkingColorSpace_256[1].z), _2511, mad((WorkingColorSpace_256[1].y), _2510, (_2509 * (WorkingColorSpace_256[1].x))));
          _2520 = mad((WorkingColorSpace_256[2].z), _2511, mad((WorkingColorSpace_256[2].y), _2510, (_2509 * (WorkingColorSpace_256[2].x))));
          _2521 = cb0_043y * 0.009999999776482582f;
          _2522 = log2(_2521);
          _2527 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
          _2542 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_2527 * 400.0f) / (_2527 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2544 = (_2522 * 1.4018198251724243f) + 10.012999534606934f;
          _2549 = exp2(log2(abs(_2544) * 0.00793700572103262f) * 0.41999998688697815f);
          _2590 = (_2522 * 924.7640991210938f) + 1024.0f;
          _2594 = min(max(mad(-0.21492856740951538f, _2520, mad(-0.2365107536315918f, _2517, (_2514 * 1.4514392614364624f))), 0.0f), _2590);
          _2595 = min(max(mad(-0.09967592358589172f, _2520, mad(1.17622971534729f, _2517, (_2514 * -0.07655377686023712f))), 0.0f), _2590);
          _2596 = min(max(mad(0.9977163076400757f, _2520, mad(-0.006032449658960104f, _2517, (_2514 * 0.008316148072481155f))), 0.0f), _2590);
          _2599 = mad(0.15618768334388733f, _2596, mad(0.13400420546531677f, _2595, (_2594 * 0.6624541878700256f)));
          _2606 = mad(0.053689517080783844f, _2596, mad(0.6740817427635193f, _2595, (_2594 * 0.2722287178039551f))) * 100.0f;
          _2607 = mad(1.0103391408920288f, _2596, mad(0.00406073359772563f, _2595, (_2594 * -0.005574649665504694f))) * 100.0f;
          _2617 = mad(0.04110127314925194f, _2607, mad(0.594700813293457f, _2606, (_2599 * 36.407447814941406f))) * 1.0172951221466064f;
          _2618 = mad(0.1479453295469284f, _2607, mad(1.0738555192947388f, _2606, (_2599 * -22.224510192871094f))) * 0.9887425899505615f;
          _2619 = mad(0.9503875374794006f, _2607, mad(0.04882604628801346f, _2606, (_2599 * -0.20676189661026f))) * 0.9944003820419312f;
          _2623 = abs(_2617) * 0.00793700572103262f;
          _2624 = abs(_2618) * 0.00793700572103262f;
          _2625 = abs(_2619) * 0.00793700572103262f;
          if (!(_2623 < 0.0f)) {
            _2632 = (pow(_2623, 0.41999998688697815f));
          } else {
            _2632 = 0.0f;
          }
          if (!(_2624 < 0.0f)) {
            _2639 = (pow(_2624, 0.41999998688697815f));
          } else {
            _2639 = 0.0f;
          }
          if (!(_2625 < 0.0f)) {
            _2646 = (pow(_2625, 0.41999998688697815f));
          } else {
            _2646 = 0.0f;
          }
          _2674 = ((float((int)(((int)(uint)((int)(_2617 > 0.0f))) - ((int)(uint)((int)(_2617 < 0.0f))))) * 400.0f) * _2632) / (_2632 + 27.1299991607666f);
          _2675 = ((float((int)(((int)(uint)((int)(_2618 > 0.0f))) - ((int)(uint)((int)(_2618 < 0.0f))))) * 400.0f) * _2639) / (_2639 + 27.1299991607666f);
          _2676 = ((float((int)(((int)(uint)((int)(_2619 > 0.0f))) - ((int)(uint)((int)(_2619 < 0.0f))))) * 400.0f) * _2646) / (_2646 + 27.1299991607666f);
          _2680 = (_2674 - (_2675 * 1.0909091234207153f)) + (_2676 * 0.09090909361839294f);
          _2684 = ((_2675 + _2674) - (_2676 * 2.0f)) * 0.1111111119389534f;
          _2686 = atan(_2684 / _2680);
          _2689 = (_2680 < 0.0f);
          _2690 = (_2680 == 0.0f);
          _2691 = (_2684 >= 0.0f);
          _2692 = (_2684 < 0.0f);
          _2701 = select((_2690 && _2691), 0.25f, select((_2690 && _2692), -0.25f, (select((_2689 && _2692), (_2686 + -3.1415927410125732f), select((_2689 && _2691), (_2686 + 3.1415927410125732f), _2686)) * 0.15915493667125702f)));
          _2705 = frac(abs(_2701));
          _2708 = select((_2701 >= (-0.0f - _2701)), _2705, (-0.0f - _2705)) * 360.0f;
          _2711 = select((_2708 < 0.0f), (_2708 + 360.0f), _2708);
          _2720 = exp2(log2((((_2674 * 2.0f) + _2675) + (_2676 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
          if (!(_2720 == 0.0f)) {
            _2729 = (sqrt((_2684 * _2684) + (_2680 * _2680)) * 38.70000076293945f);
          } else {
            _2729 = 0.0f;
          }
          _2734 = exp2(log2(abs(_2720) * 0.009999999776482582f) * 0.8794641494750977f);
          _2749 = (float((int)(((int)(uint)((int)(_2720 > 0.0f))) - ((int)(uint)((int)(_2720 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_2734 * 351.2578430175781f) / (400.0f - (_2734 * 12.947211265563965f))) * 2.3809523582458496f);
          _2751 = (_2522 * 115.59551239013672f) + 128.0f;
          _2755 = sqrt((_2521 + 0.1599999964237213f) * _2521) + _2521;
          _2756 = _2755 * 0.5f;
          _2757 = _2751 / _2756;
          _2764 = _2522 * 0.014018198475241661f;
          _2765 = _2764 + 0.10012999176979065f;
          _2775 = exp2(log2((((_2765 + sqrt(_2765 * (_2764 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_2751 / (_2756 * (_2757 + 1.0f))) * 1.149999976158142f)) / _2756) * 0.8695652484893799f);
          _2780 = 0.18000000715255737f / (((_2755 * -0.5f) * _2775) / (_2775 + -1.0f));
          _2795 = exp2(log2(max(0.0f, _2749) / ((_2780 * _2756) + _2749)) * 1.149999976158142f) * (_2756 / exp2(log2(_2751 / ((_2757 + _2780) * _2756)) * 1.149999976158142f));
          _2800 = max(0.0f, ((_2795 * _2795) / (_2795 + 0.03999999910593033f))) * 100.0f;
          _2805 = exp2(log2(abs(_2800) * 0.00793700572103262f) * 0.41999998688697815f);
          _2820 = (float((int)(((int)(uint)((int)(_2800 > 0.0f))) - ((int)(uint)((int)(_2800 < 0.0f))))) * 100.0f) * exp2(log2(((_2805 * 400.0f) / (_2805 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2822 = _2711 * 0.0027777778450399637f;
          _2823 = -0.0f - _2822;
          _2825 = frac(abs(_2822));
          _2826 = -0.0f - _2825;
          if (!(_2729 == 0.0f)) {
            _2828 = _2820 / _2542;
            _2830 = max(0.0f, (1.0f - _2828));
            _2831 = _2711 * 0.01745329424738884f;
            _2832 = cos(_2831);
            _2833 = sin(_2831);
            _2834 = _2832 * _2832;
            _2835 = _2833 * _2833;
            _2850 = ((((77.12895965576172f - ((_2832 * 12.74448013305664f) * _2833)) + ((_2834 - _2835) * 16.468990325927734f)) + (((_2834 * 31.535200119018555f) + -12.31067943572998f) * _2832)) + ((42.245330810546875f - (_2835 * 36.774559020996094f)) * _2833)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
            _2856 = select((_2822 >= _2823), _2825, _2826) * 360.0f;
            _2860 = int(select((_2856 < 0.0f), (_2856 + 360.0f), _2856));
            _2862 = (_2860 + 1) % 360;
            _2871 = t4.Load(int3(_2860, 0, 0));
            _2876 = (((((t4.Load(int3(_2862, 0, 0))).x) - _2871.x) * ((_2711 - float((int)(_2860))) / float((int)(_2862 - _2860)))) + _2871.x) * (pow(_2828, 0.8794641494750977f));
            _2877 = _2876 / _2850;
            _2878 = _2877 + -0.0010000000474974513f;
            _2879 = _2830 * max(0.20000000298023224f, (1.2999999523162842f - (_2522 * 0.270023912191391f)));
            _2880 = _2828 * ((_2522 * 2.384157657623291f) + 2.4000000953674316f);
            _2887 = (_2876 - (exp2(log2(_2820 / _2720) * 0.8794641494750977f) * _2729)) / _2850;
            if (!(_2887 > _2878)) {
              _2893 = max(sqrt((_2828 * _2828) + (0.5f / cb0_043y)), 0.0010000000474974513f);
              _2897 = sqrt((_2893 * _2893) + (_2879 * _2879));
              _2900 = (_2897 + _2878) / (_2893 + _2878);
              _2902 = (_2900 * _2887) - _2897;
              _2912 = ((_2902 + sqrt((_2902 * _2902) + (((_2887 * 4.0f) * _2893) * _2900))) * 0.5f);
            } else {
              _2912 = _2887;
            }
            _2913 = _2877 - _2912;
            if (!(_2913 > _2877)) {
              _2916 = max(_2830, 0.0010000000474974513f);
              _2920 = sqrt((_2916 * _2916) + (_2880 * _2880));
              _2923 = (_2920 + _2877) / (_2916 + _2877);
              _2925 = (_2923 * _2913) - _2920;
              _2935 = ((_2925 + sqrt((_2925 * _2925) + (((_2913 * 4.0f) * _2916) * _2923))) * 0.5f);
            } else {
              _2935 = _2913;
            }
            _2938 = (_2935 * _2850);
          } else {
            _2938 = _2729;
          }
          _2941 = select((_2822 >= _2823), _2825, _2826) * 360.0f;
          _2944 = select((_2941 < 0.0f), (_2941 + 360.0f), _2941);
          _2945 = int(_2944);
          _2946 = _2945 + 1;
          _2948 = 0;
          _2949 = 361;
          _2950 = _2946;
          while(true) {
            _2954 = (_2711 > (((float3)(t5.Load(int3(_2950, 0, 0)))).z));
            _2955 = select(_2954, _2950, _2948);
            _2956 = select(_2954, _2949, _2950);
            if ((int)(_2955 + 1) < (int)_2956) {
              _2948 = _2955;
              _2949 = _2956;
              _2950 = ((_2955 + _2956) / 2);
              continue;
            }
            _2963 = t5.Load(int3((_2956 + -1), 0, 0));
            _2967 = t5.Load(int3(_2956, 0, 0));
            _2973 = (_2711 - _2963.z) / (_2967.z - _2963.z);
            _2976 = ((_2967.x - _2963.x) * _2973) + _2963.x;
            if (!((_2820 > _2542) || (_2938 < 9.999999747378752e-05f))) {
              _2990 = (min(1.0f, (1.2999999523162842f - (_2976 / _2542))) * (((float((int)(((int)(uint)((int)(_2544 > 0.0f))) - ((int)(uint)((int)(_2544 < 0.0f))))) * 100.0f) * exp2(log2(((_2549 * 400.0f) / (_2549 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _2976)) + _2976;
              _2991 = ((_2522 * 0.7111833691596985f) + 1.350000023841858f) * _2542;
              _2992 = _2542 - _2976;
              _2994 = (_2992 * 0.30000001192092896f) + _2976;
              if (_2820 > _2994) {
                _3008 = (exp2(log2(log2((_2542 - _2994) / max(9.999999747378752e-05f, (_2542 - _2820))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _3008 = 1.0f;
              }
              _3009 = _2991 * _3008;
              t6.GetDimensions(_3011.x, _3011.y);
              _3015 = float((int)(_2945));
              _3019 = t6.Load(int3(_2946, 0, 0));
              _3024 = (lerp(_2963.y, _2967.y, _2973)) * 1.0324000120162964f;
              _3025 = _3009 * _2990;
              _3027 = (_2820 < _2990);
              _3028 = _2938 / _3009;
              if (_3027) {
                _3038 = (1.0f - _3028);
              } else {
                _3038 = (-0.0f - ((_3028 + 1.0f) + ((_2938 * _2542) / _3025)));
              }
              if (_3027) {
                _3046 = (-0.0f - _2820);
              } else {
                _3046 = (((_2938 * _2542) / _3009) + _2820);
              }
              _3051 = sqrt((_3038 * _3038) - (((_2938 / _3025) * 4.0f) * _3046));
              _3057 = (_3046 * 2.0f) / select(_3027, ((-0.0f - _3038) - _3051), (_3051 - _3038));
              _3059 = (_2976 < _2990);
              _3060 = _3024 / _3009;
              if (_3059) {
                _3070 = (1.0f - _3060);
              } else {
                _3070 = (-0.0f - ((_3060 + 1.0f) + ((_3024 * _2542) / _3025)));
              }
              if (!_3059) {
                _3076 = (((_3024 * _2542) / _3009) + _2976);
              } else {
                _3076 = (-0.0f - _2976);
              }
              _3081 = sqrt((_3070 * _3070) - (((_3024 / _3025) * 4.0f) * _3076));
              _3087 = (_3076 * 2.0f) / select(_3059, ((-0.0f - _3070) - _3081), (_3081 - _3070));
              _3089 = _2542 - _3057;
              _3093 = ((_3057 - _2990) * select((_3057 < _2990), _3057, _3089)) / _3025;
              _3102 = _2542 - _3087;
              _3113 = ((_3102 * _3024) * exp2(log2(_3089 / _3102) * (1.0f / (((((t6.Load(int3(((_2945 + 2) % (int)(_3011.x)), 0, 0))).x) - _3019.x) * (_2944 - _3015)) + _3019.x)))) / ((_2992 + (_3093 * _3024)) * _3024);
              _3115 = (exp2(log2(_3057 / _3087) * (1.0f / ((_2522 * 0.02107210084795952f) + 1.1399999856948853f))) * _3087) / (((_2976 / _3024) - _3093) * _3024);
              _3119 = max((0.11999999731779099f - abs(_3115 - _3113)), 0.0f);
              _3120 = _3119 * 8.333333969116211f;
              _3126 = (min(_3115, _3113) - ((_3120 * _3120) * (_3119 * 0.1666666716337204f))) * _3024;
              _3127 = _3126 * _3093;
              _3128 = _3127 + _3057;
              _3129 = _2946 % 360;
              _3137 = t4.Load(int3(_2945, 0, 0));
              _3141 = ((((t4.Load(int3(_3129, 0, 0))).x) - _3137.x) * ((_2711 - _3015) / float((int)(_3129 - _2945)))) + _3137.x;
              if (_3128 > _2994) {
                _3155 = (exp2(log2(log2((_2542 - _2994) / max(9.999999747378752e-05f, (_2542 - _3128))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _3155 = 1.0f;
              }
              _3156 = _2991 * _3155;
              _3157 = _3156 * _2990;
              _3159 = (_3128 < _2990);
              _3160 = _3126 / _3156;
              if (_3159) {
                _3170 = (1.0f - _3160);
              } else {
                _3170 = (-0.0f - ((_3160 + 1.0f) + ((_3126 * _2542) / _3157)));
              }
              if (_3159) {
                _3178 = (-0.0f - _3128);
              } else {
                _3178 = (((_3126 * _2542) / _3156) + _3128);
              }
              _3183 = sqrt((_3170 * _3170) - (((_3126 / _3157) * 4.0f) * _3178));
              _3189 = (_3178 * 2.0f) / select(_3159, ((-0.0f - _3170) - _3183), (_3183 - _3170));
              _3206 = max(1.000100016593933f, (((_3141 * _2542) * exp2(log2(_3189 / _2542) * 0.8794641494750977f)) / ((_2542 - ((((_3189 - _2990) * select((_3189 < _2990), _3189, (_2542 - _3189))) / _3157) * _3141)) * _3126)));
              _3208 = max(0.75f, (1.0f / _3206));
              _3209 = _2938 / _3126;
              _3214 = ((_3206 - _3208) * (1.0f - _3208)) / (_3206 + -1.0f);
              _3216 = (_3209 - _3208) / _3214;
              if (!((_3206 <= 1.000100016593933f) || (_3209 < _3208))) {
                _3226 = (((_3216 * _3214) / (_3216 + 1.0f)) + _3208);
              } else {
                _3226 = _3209;
              }
              _3232 = ((_3226 * _3127) + _3057);
              _3233 = ((_3126 * _3226) * 0.0258397925645113f);
            } else {
              _3232 = _2820;
              _3233 = 0.0f;
            }
            _3234 = _2711 * 0.01745329424738884f;
            _3235 = _3232 * 0.009999999776482582f;
            if (!(_3235 < 0.0f)) {
              _3244 = (((pow(_3235, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
            } else {
              _3244 = 0.0f;
            }
            _3246 = cos(_3234) * _3233;
            _3248 = sin(_3234) * _3233;
            _3255 = mad(288.0f, _3248, mad(451.0f, _3246, _3244)) * 0.0007127583958208561f;
            _3256 = mad(-261.0f, _3248, mad(-891.0f, _3246, _3244)) * 0.0007127583958208561f;
            _3257 = mad(-6300.0f, _3248, mad(-220.0f, _3246, _3244)) * 0.0007127583958208561f;
            _3277 = abs(_3255);
            _3278 = abs(_3256);
            _3279 = abs(_3257);
            _3286 = (_3277 * 27.1299991607666f) / (400.0f - _3277);
            _3287 = (_3278 * 27.1299991607666f) / (400.0f - _3278);
            _3288 = (_3279 * 27.1299991607666f) / (400.0f - _3279);
            if (!(_3286 < 0.0f)) {
              _3295 = (pow(_3286, 2.3809523582458496f));
            } else {
              _3295 = 0.0f;
            }
            if (!(_3287 < 0.0f)) {
              _3302 = (pow(_3287, 2.3809523582458496f));
            } else {
              _3302 = 0.0f;
            }
            if (!(_3288 < 0.0f)) {
              _3309 = (pow(_3288, 2.3809523582458496f));
            } else {
              _3309 = 0.0f;
            }
            _3310 = (float((int)(((int)(uint)((int)(_3255 > 0.0f))) - ((int)(uint)((int)(_3255 < 0.0f))))) * 125.99209594726562f) * _3295;
            _3312 = (float((int)(((int)(uint)((int)(_3256 > 0.0f))) - ((int)(uint)((int)(_3256 < 0.0f))))) * 127.42658996582031f) * _3302;
            _3314 = (float((int)(((int)(uint)((int)(_3257 > 0.0f))) - ((int)(uint)((int)(_3257 < 0.0f))))) * 126.70159912109375f) * _3309;
            _3317 = mad(0.08875565975904465f, _3314, mad(-1.140031337738037f, _3312, (_3310 * 2.016401767730713f)));
            _3324 = mad(-0.12752249836921692f, _3314, mad(0.7005835175514221f, _3312, (_3310 * 0.41968056559562683f))) * 0.009999999776482582f;
            _3325 = mad(1.0589468479156494f, _3314, mad(-0.03847259283065796f, _3312, (_3310 * -0.01717424765229225f))) * 0.009999999776482582f;
            _3338 = min(max(mad(-0.23642469942569733f, _3325, mad(-0.32480329275131226f, _3324, (_3317 * 0.016410233452916145f))), 0.0f), _2521);
            _3339 = min(max(mad(0.016756348311901093f, _3325, mad(1.6153316497802734f, _3324, (_3317 * -0.006636628415435553f))), 0.0f), _2521);
            _3340 = min(max(mad(0.9883948564529419f, _3325, mad(-0.008284442126750946f, _3324, (_3317 * 0.00011721893679350615f))), 0.0f), _2521);
            _3343 = mad(0.15618768334388733f, _3340, mad(0.13400420546531677f, _3339, (_3338 * 0.6624541878700256f)));
            _3346 = mad(0.053689517080783844f, _3340, mad(0.6740817427635193f, _3339, (_3338 * 0.2722287178039551f)));
            _3349 = mad(1.0103391408920288f, _3340, mad(0.00406073359772563f, _3339, (_3338 * -0.005574649665504694f)));
            _3352 = mad(-0.23642469942569733f, _3349, mad(-0.32480329275131226f, _3346, (_3343 * 1.6410233974456787f)));
            _3359 = mad(0.016756348311901093f, _3349, mad(1.6153316497802734f, _3346, (_3343 * -0.663662850856781f))) * 1.25f;
            _3360 = mad(0.9883948564529419f, _3349, mad(-0.008284442126750946f, _3346, (_3343 * 0.011721894145011902f))) * 1.25f;
            _3507 = mad(-0.0832589864730835f, _3360, mad(-0.6217921376228333f, _3359, (_3352 * 2.1313138008117676f)));
            _3508 = mad(-0.010548308491706848f, _3360, mad(1.140804648399353f, _3359, (_3352 * -0.16282059252262115f)));
            _3509 = mad(1.1529725790023804f, _3360, mad(-0.1289689838886261f, _3359, (_3352 * -0.030004188418388367f)));
            break;
          }
        } else {
          if (cb0_042w == 7) {
            _3387 = mad((WorkingColorSpace_128[0].z), _1423, mad((WorkingColorSpace_128[0].y), _1422, ((WorkingColorSpace_128[0].x) * _1421)));
            _3390 = mad((WorkingColorSpace_128[1].z), _1423, mad((WorkingColorSpace_128[1].y), _1422, ((WorkingColorSpace_128[1].x) * _1421)));
            _3393 = mad((WorkingColorSpace_128[2].z), _1423, mad((WorkingColorSpace_128[2].y), _1422, ((WorkingColorSpace_128[2].x) * _1421)));
            _3412 = exp2(log2(mad(_62, _3393, mad(_61, _3390, (_3387 * _60))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3413 = exp2(log2(mad(_65, _3393, mad(_64, _3390, (_3387 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3414 = exp2(log2(mad(_68, _3393, mad(_67, _3390, (_3387 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3507 = exp2(log2((1.0f / ((_3412 * 18.6875f) + 1.0f)) * ((_3412 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3508 = exp2(log2((1.0f / ((_3413 * 18.6875f) + 1.0f)) * ((_3413 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3509 = exp2(log2((1.0f / ((_3414 * 18.6875f) + 1.0f)) * ((_3414 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _3461 = mad((WorkingColorSpace_128[0].z), _1411, mad((WorkingColorSpace_128[0].y), _1410, ((WorkingColorSpace_128[0].x) * _1409)));
                _3464 = mad((WorkingColorSpace_128[1].z), _1411, mad((WorkingColorSpace_128[1].y), _1410, ((WorkingColorSpace_128[1].x) * _1409)));
                _3467 = mad((WorkingColorSpace_128[2].z), _1411, mad((WorkingColorSpace_128[2].y), _1410, ((WorkingColorSpace_128[2].x) * _1409)));
                _3507 = mad(_62, _3467, mad(_61, _3464, (_3461 * _60)));
                _3508 = mad(_65, _3467, mad(_64, _3464, (_3461 * _63)));
                _3509 = mad(_68, _3467, mad(_67, _3464, (_3461 * _66)));
              } else {
                _3480 = mad((WorkingColorSpace_128[0].z), _1437, mad((WorkingColorSpace_128[0].y), _1436, ((WorkingColorSpace_128[0].x) * _1435)));
                _3483 = mad((WorkingColorSpace_128[1].z), _1437, mad((WorkingColorSpace_128[1].y), _1436, ((WorkingColorSpace_128[1].x) * _1435)));
                _3486 = mad((WorkingColorSpace_128[2].z), _1437, mad((WorkingColorSpace_128[2].y), _1436, ((WorkingColorSpace_128[2].x) * _1435)));
                _3507 = exp2(log2(mad(_62, _3486, mad(_61, _3483, (_3480 * _60)))) * cb0_042z);
                _3508 = exp2(log2(mad(_65, _3486, mad(_64, _3483, (_3480 * _63)))) * cb0_042z);
                _3509 = exp2(log2(mad(_68, _3486, mad(_67, _3483, (_3480 * _66)))) * cb0_042z);
              }
            } else {
              _3507 = _1421;
              _3508 = _1422;
              _3509 = _1423;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_3507 * 0.9523810148239136f), (_3508 * 0.9523810148239136f), (_3509 * 0.9523810148239136f), 0.0f);
}
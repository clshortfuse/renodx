// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float> t3 : register(t3);

Texture2D<float3> t4 : register(t4);

Texture2D<float> t5 : register(t5);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
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
  float _29;
  float _34;
  float _35;
  float _36;
  float _38;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _124;
  float _125;
  float _126;
  float _181;
  float _388;
  float _389;
  float _390;
  float _913;
  float _946;
  float _960;
  float _1024;
  float _1203;
  float _1214;
  float _1225;
  float _1448;
  float _1449;
  float _1450;
  float _1461;
  float _1472;
  float _1682;
  float _1689;
  float _1696;
  float _1779;
  float _1962;
  float _1985;
  float _1988;
  int _1998;
  int _1999;
  int _2000;
  float _2058;
  float _2088;
  float _2096;
  float _2120;
  float _2126;
  float _2205;
  float _2220;
  float _2228;
  float _2276;
  float _2282;
  float _2283;
  float _2294;
  float _2345;
  float _2352;
  float _2359;
  float _2603;
  float _2610;
  float _2617;
  float _2700;
  float _2883;
  float _2906;
  float _2909;
  int _2919;
  int _2920;
  int _2921;
  float _2979;
  float _3009;
  float _3017;
  float _3041;
  float _3047;
  float _3126;
  float _3141;
  float _3149;
  float _3197;
  float _3203;
  float _3204;
  float _3215;
  float _3266;
  float _3273;
  float _3280;
  float _3478;
  float _3479;
  float _3480;
  bool _47;
  float _77;
  float _78;
  float _79;
  bool _162;
  float _164;
  float _195;
  float _202;
  float _205;
  float _210;
  float _211;
  float _213;
  bool _214;
  float _223;
  float _225;
  float _232;
  float _234;
  float _236;
  float _237;
  float _240;
  float _243;
  float _248;
  float _254;
  float _255;
  float _256;
  float _257;
  float _258;
  float _259;
  float _260;
  float _261;
  float _264;
  float _265;
  float _266;
  float _269;
  float _288;
  float _289;
  float _290;
  float _291;
  float _292;
  float _293;
  float _294;
  float _295;
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
  float _341;
  float _344;
  float _347;
  float _350;
  float _405;
  float _408;
  float _411;
  float _412;
  float _416;
  float _417;
  float _418;
  float _430;
  float _446;
  float _447;
  float _448;
  float _449;
  float _463;
  float _477;
  float _491;
  float _505;
  float _519;
  float _523;
  float _524;
  float _525;
  float _582;
  float _586;
  float _587;
  float _596;
  float _605;
  float _614;
  float _623;
  float _632;
  float _695;
  float _699;
  float _708;
  float _717;
  float _726;
  float _735;
  float _744;
  float _802;
  float _813;
  float _815;
  float _817;
  float _853;
  float _854;
  float _855;
  float _858;
  float _861;
  float _864;
  float _868;
  float _873;
  float _886;
  float _887;
  float _888;
  float _889;
  float _893;
  float _904;
  float _914;
  float _915;
  float _916;
  float _917;
  float _924;
  float _927;
  float _929;
  bool _932;
  bool _933;
  bool _934;
  bool _935;
  float _951;
  float _964;
  float _968;
  float _974;
  float _984;
  float _985;
  float _986;
  float _987;
  float _1002;
  float _1004;
  float _1006;
  float _1015;
  float _1027;
  float _1029;
  float _1033;
  float _1034;
  float _1035;
  float _1039;
  float _1040;
  float _1041;
  float _1042;
  float _1044;
  float _1045;
  float _1046;
  float _1047;
  float _1066;
  float _1068;
  float _1093;
  float _1094;
  float _1095;
  float _1102;
  float _1106;
  float _1107;
  float _1108;
  bool _1109;
  float _1113;
  float _1114;
  float _1115;
  float _1134;
  float _1135;
  float _1136;
  float _1137;
  float _1157;
  float _1158;
  float _1159;
  float _1175;
  float _1176;
  float _1177;
  float _1190;
  float _1191;
  float _1192;
  float _1229;
  float _1236;
  float _1237;
  float _1238;
  float _1240;
  float4 _1243;
  float _1247;
  float4 _1248;
  float4 _1270;
  float4 _1274;
  float4 _1296;
  float4 _1300;
  float _1316;
  float _1317;
  float _1318;
  float _1343;
  float _1344;
  float _1345;
  float _1371;
  float _1372;
  float _1373;
  float _1380;
  float _1381;
  float _1382;
  float _1383;
  float _1384;
  float _1385;
  float _1392;
  float _1393;
  float _1394;
  float _1406;
  float _1407;
  float _1408;
  float _1431;
  float _1434;
  float _1437;
  float _1499;
  float _1502;
  float _1505;
  float _1508;
  float _1511;
  float _1514;
  float _1559;
  float _1560;
  float _1561;
  float _1564;
  float _1567;
  float _1570;
  float _1571;
  float _1572;
  float _1577;
  float _1592;
  float _1594;
  float _1599;
  float _1640;
  float _1644;
  float _1645;
  float _1646;
  float _1649;
  float _1656;
  float _1657;
  float _1667;
  float _1668;
  float _1669;
  float _1673;
  float _1674;
  float _1675;
  float _1724;
  float _1725;
  float _1726;
  float _1730;
  float _1734;
  float _1736;
  bool _1739;
  bool _1740;
  bool _1741;
  bool _1742;
  float _1751;
  float _1755;
  float _1758;
  float _1761;
  float _1770;
  float _1784;
  float _1799;
  float _1801;
  float _1805;
  float _1806;
  float _1807;
  float _1814;
  float _1815;
  float _1825;
  float _1830;
  float _1845;
  float _1850;
  float _1855;
  float _1870;
  float _1872;
  float _1873;
  float _1875;
  float _1876;
  float _1878;
  float _1880;
  float _1881;
  float _1882;
  float _1883;
  float _1884;
  float _1885;
  float _1900;
  float _1906;
  int _1910;
  int _1912;
  float _1921;
  float _1926;
  float _1927;
  float _1928;
  float _1929;
  float _1930;
  float _1937;
  float _1943;
  float _1947;
  float _1950;
  float _1952;
  float _1963;
  float _1966;
  float _1970;
  float _1973;
  float _1975;
  float _1991;
  float _1994;
  int _1995;
  int _1996;
  bool _2004;
  int _2005;
  int _2006;
  float3 _2013;
  float3 _2017;
  float _2023;
  float _2026;
  float _2040;
  float _2041;
  float _2042;
  float _2044;
  float _2059;
  uint2 _2061;
  float _2065;
  float _2069;
  float _2074;
  float _2075;
  bool _2077;
  float _2078;
  float _2101;
  float _2107;
  bool _2109;
  float _2110;
  float _2131;
  float _2137;
  float _2139;
  float _2143;
  float _2152;
  float _2163;
  float _2165;
  float _2169;
  float _2170;
  float _2176;
  float _2177;
  float _2178;
  int _2179;
  float _2187;
  float _2191;
  float _2206;
  float _2207;
  bool _2209;
  float _2210;
  float _2233;
  float _2239;
  float _2256;
  float _2258;
  float _2259;
  float _2264;
  float _2266;
  float _2284;
  float _2285;
  float _2296;
  float _2298;
  float _2305;
  float _2306;
  float _2307;
  float _2327;
  float _2328;
  float _2329;
  float _2336;
  float _2337;
  float _2338;
  float _2360;
  float _2362;
  float _2364;
  float _2367;
  float _2374;
  float _2375;
  float _2388;
  float _2389;
  float _2390;
  float _2393;
  float _2396;
  float _2399;
  float _2409;
  float _2410;
  float _2411;
  float _2430;
  float _2431;
  float _2432;
  float _2480;
  float _2481;
  float _2482;
  float _2485;
  float _2488;
  float _2491;
  float _2492;
  float _2493;
  float _2498;
  float _2513;
  float _2515;
  float _2520;
  float _2561;
  float _2565;
  float _2566;
  float _2567;
  float _2570;
  float _2577;
  float _2578;
  float _2588;
  float _2589;
  float _2590;
  float _2594;
  float _2595;
  float _2596;
  float _2645;
  float _2646;
  float _2647;
  float _2651;
  float _2655;
  float _2657;
  bool _2660;
  bool _2661;
  bool _2662;
  bool _2663;
  float _2672;
  float _2676;
  float _2679;
  float _2682;
  float _2691;
  float _2705;
  float _2720;
  float _2722;
  float _2726;
  float _2727;
  float _2728;
  float _2735;
  float _2736;
  float _2746;
  float _2751;
  float _2766;
  float _2771;
  float _2776;
  float _2791;
  float _2793;
  float _2794;
  float _2796;
  float _2797;
  float _2799;
  float _2801;
  float _2802;
  float _2803;
  float _2804;
  float _2805;
  float _2806;
  float _2821;
  float _2827;
  int _2831;
  int _2833;
  float _2842;
  float _2847;
  float _2848;
  float _2849;
  float _2850;
  float _2851;
  float _2858;
  float _2864;
  float _2868;
  float _2871;
  float _2873;
  float _2884;
  float _2887;
  float _2891;
  float _2894;
  float _2896;
  float _2912;
  float _2915;
  int _2916;
  int _2917;
  bool _2925;
  int _2926;
  int _2927;
  float3 _2934;
  float3 _2938;
  float _2944;
  float _2947;
  float _2961;
  float _2962;
  float _2963;
  float _2965;
  float _2980;
  uint2 _2982;
  float _2986;
  float _2990;
  float _2995;
  float _2996;
  bool _2998;
  float _2999;
  float _3022;
  float _3028;
  bool _3030;
  float _3031;
  float _3052;
  float _3058;
  float _3060;
  float _3064;
  float _3073;
  float _3084;
  float _3086;
  float _3090;
  float _3091;
  float _3097;
  float _3098;
  float _3099;
  int _3100;
  float _3108;
  float _3112;
  float _3127;
  float _3128;
  bool _3130;
  float _3131;
  float _3154;
  float _3160;
  float _3177;
  float _3179;
  float _3180;
  float _3185;
  float _3187;
  float _3205;
  float _3206;
  float _3217;
  float _3219;
  float _3226;
  float _3227;
  float _3228;
  float _3248;
  float _3249;
  float _3250;
  float _3257;
  float _3258;
  float _3259;
  float _3281;
  float _3283;
  float _3285;
  float _3288;
  float _3295;
  float _3296;
  float _3309;
  float _3310;
  float _3311;
  float _3314;
  float _3317;
  float _3320;
  float _3323;
  float _3330;
  float _3331;
  float _3358;
  float _3361;
  float _3364;
  float _3383;
  float _3384;
  float _3385;
  float _3432;
  float _3435;
  float _3438;
  float _3451;
  float _3454;
  float _3457;
  _29 = 0.5f / cb0_037x;
  _34 = cb0_037x + -1.0f;
  _35 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _29)) / _34;
  _36 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _29)) / _34;
  _38 = float((uint)SV_DispatchThreadID.z) / _34;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _47 = (cb0_043x == 4);
        _58 = select(_47, 1.0f, 1.705051064491272f);
        _59 = select(_47, 0.0f, -0.6217921376228333f);
        _60 = select(_47, 0.0f, -0.0832589864730835f);
        _61 = select(_47, 0.0f, -0.13025647401809692f);
        _62 = select(_47, 1.0f, 1.140804648399353f);
        _63 = select(_47, 0.0f, -0.010548308491706848f);
        _64 = select(_47, 0.0f, -0.024003351107239723f);
        _65 = select(_47, 0.0f, -0.1289689838886261f);
        _66 = select(_47, 1.0f, 1.1529725790023804f);
      } else {
        _58 = 0.6954522132873535f;
        _59 = 0.14067870378494263f;
        _60 = 0.16386906802654266f;
        _61 = 0.044794563204050064f;
        _62 = 0.8596711158752441f;
        _63 = 0.0955343171954155f;
        _64 = -0.005525882821530104f;
        _65 = 0.004025210160762072f;
        _66 = 1.0015007257461548f;
      }
    } else {
      _58 = 1.0258246660232544f;
      _59 = -0.020053181797266006f;
      _60 = -0.005771636962890625f;
      _61 = -0.002234415616840124f;
      _62 = 1.0045864582061768f;
      _63 = -0.002352118492126465f;
      _64 = -0.005013350863009691f;
      _65 = -0.025290070101618767f;
      _66 = 1.0303035974502563f;
    }
  } else {
    _58 = 1.3792141675949097f;
    _59 = -0.30886411666870117f;
    _60 = -0.0703500509262085f;
    _61 = -0.06933490186929703f;
    _62 = 1.08229660987854f;
    _63 = -0.012961871922016144f;
    _64 = -0.0021590073592960835f;
    _65 = -0.0454593189060688f;
    _66 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _77 = (pow(_35, 0.012683313339948654f));
    _78 = (pow(_36, 0.012683313339948654f));
    _79 = (pow(_38, 0.012683313339948654f));
    _124 = (exp2(log2(max(0.0f, (_77 + -0.8359375f)) / (18.8515625f - (_77 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _125 = (exp2(log2(max(0.0f, (_78 + -0.8359375f)) / (18.8515625f - (_78 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _126 = (exp2(log2(max(0.0f, (_79 + -0.8359375f)) / (18.8515625f - (_79 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _124 = ((exp2((_35 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _125 = ((exp2((_36 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _126 = ((exp2((_38 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _162 = (cb0_040w != 0);
    _164 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _181 = (((((1901800.0f - (_164 * 2006400000.0f)) * _164) + 247.47999572753906f) * _164) + 0.23703999817371368f);
    } else {
      _181 = (((((2967800.0f - (_164 * 4607000064.0f)) * _164) + 99.11000061035156f) * _164) + 0.24406300485134125f);
    }
    _195 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _202 = cb0_037y * cb0_037y;
    _205 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_202 * 1.6145605741257896e-07f));
    _210 = ((_195 * 2.0f) + 4.0f) - (_205 * 8.0f);
    _211 = (_195 * 3.0f) / _210;
    _213 = (_205 * 2.0f) / _210;
    _214 = (cb0_037y < 4000.0f);
    _223 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _225 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_202 * 1.5317699909210205f)) / (_223 * _223);
    _232 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _202;
    _234 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_202 * 308.60699462890625f)) / (_232 * _232);
    _236 = rsqrt(dot(float2(_225, _234), float2(_225, _234)));
    _237 = cb0_037z * 0.05000000074505806f;
    _240 = ((_237 * _234) * _236) + _195;
    _243 = _205 - ((_237 * _225) * _236);
    _248 = (4.0f - (_243 * 8.0f)) + (_240 * 2.0f);
    _254 = (((_240 * 3.0f) / _248) - _211) + select(_214, _211, _181);
    _255 = (((_243 * 2.0f) / _248) - _213) + select(_214, _213, (((_181 * 2.869999885559082f) + -0.2750000059604645f) - ((_181 * _181) * 3.0f)));
    _256 = select(_162, _254, 0.3127000033855438f);
    _257 = select(_162, _255, 0.32899999618530273f);
    _258 = select(_162, 0.3127000033855438f, _254);
    _259 = select(_162, 0.32899999618530273f, _255);
    _260 = max(_257, 1.000000013351432e-10f);
    _261 = _256 / _260;
    _264 = ((1.0f - _256) - _257) / _260;
    _265 = max(_259, 1.000000013351432e-10f);
    _266 = _258 / _265;
    _269 = ((1.0f - _258) - _259) / _265;
    _288 = mad(-0.16140000522136688f, _269, ((_266 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _264, ((_261 * 0.8950999975204468f) + 0.266400009393692f));
    _289 = mad(0.03669999912381172f, _269, (1.7135000228881836f - (_266 * 0.7501999735832214f))) / mad(0.03669999912381172f, _264, (1.7135000228881836f - (_261 * 0.7501999735832214f)));
    _290 = mad(1.0296000242233276f, _269, ((_266 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _264, ((_261 * 0.03889999911189079f) + -0.06849999725818634f));
    _291 = mad(_289, -0.7501999735832214f, 0.0f);
    _292 = mad(_289, 1.7135000228881836f, 0.0f);
    _293 = mad(_289, 0.03669999912381172f, -0.0f);
    _294 = mad(_290, 0.03889999911189079f, 0.0f);
    _295 = mad(_290, -0.06849999725818634f, 0.0f);
    _296 = mad(_290, 1.0296000242233276f, 0.0f);
    _299 = mad(0.1599626988172531f, _294, mad(-0.1470542997121811f, _291, (_288 * 0.883457362651825f)));
    _302 = mad(0.1599626988172531f, _295, mad(-0.1470542997121811f, _292, (_288 * 0.26293492317199707f)));
    _305 = mad(0.1599626988172531f, _296, mad(-0.1470542997121811f, _293, (_288 * -0.15930065512657166f)));
    _308 = mad(0.04929120093584061f, _294, mad(0.5183603167533875f, _291, (_288 * 0.38695648312568665f)));
    _311 = mad(0.04929120093584061f, _295, mad(0.5183603167533875f, _292, (_288 * 0.11516613513231277f)));
    _314 = mad(0.04929120093584061f, _296, mad(0.5183603167533875f, _293, (_288 * -0.0697740763425827f)));
    _317 = mad(0.9684867262840271f, _294, mad(0.04004279896616936f, _291, (_288 * -0.007634039502590895f)));
    _320 = mad(0.9684867262840271f, _295, mad(0.04004279896616936f, _292, (_288 * -0.0022720457054674625f)));
    _323 = mad(0.9684867262840271f, _296, mad(0.04004279896616936f, _293, (_288 * 0.0013765322510153055f)));
    _326 = mad(_305, (WorkingColorSpace_000[2].x), mad(_302, (WorkingColorSpace_000[1].x), (_299 * (WorkingColorSpace_000[0].x))));
    _329 = mad(_305, (WorkingColorSpace_000[2].y), mad(_302, (WorkingColorSpace_000[1].y), (_299 * (WorkingColorSpace_000[0].y))));
    _332 = mad(_305, (WorkingColorSpace_000[2].z), mad(_302, (WorkingColorSpace_000[1].z), (_299 * (WorkingColorSpace_000[0].z))));
    _335 = mad(_314, (WorkingColorSpace_000[2].x), mad(_311, (WorkingColorSpace_000[1].x), (_308 * (WorkingColorSpace_000[0].x))));
    _338 = mad(_314, (WorkingColorSpace_000[2].y), mad(_311, (WorkingColorSpace_000[1].y), (_308 * (WorkingColorSpace_000[0].y))));
    _341 = mad(_314, (WorkingColorSpace_000[2].z), mad(_311, (WorkingColorSpace_000[1].z), (_308 * (WorkingColorSpace_000[0].z))));
    _344 = mad(_323, (WorkingColorSpace_000[2].x), mad(_320, (WorkingColorSpace_000[1].x), (_317 * (WorkingColorSpace_000[0].x))));
    _347 = mad(_323, (WorkingColorSpace_000[2].y), mad(_320, (WorkingColorSpace_000[1].y), (_317 * (WorkingColorSpace_000[0].y))));
    _350 = mad(_323, (WorkingColorSpace_000[2].z), mad(_320, (WorkingColorSpace_000[1].z), (_317 * (WorkingColorSpace_000[0].z))));
    _388 = mad(mad((WorkingColorSpace_064[0].z), _350, mad((WorkingColorSpace_064[0].y), _341, (_332 * (WorkingColorSpace_064[0].x)))), _126, mad(mad((WorkingColorSpace_064[0].z), _347, mad((WorkingColorSpace_064[0].y), _338, (_329 * (WorkingColorSpace_064[0].x)))), _125, (mad((WorkingColorSpace_064[0].z), _344, mad((WorkingColorSpace_064[0].y), _335, (_326 * (WorkingColorSpace_064[0].x)))) * _124)));
    _389 = mad(mad((WorkingColorSpace_064[1].z), _350, mad((WorkingColorSpace_064[1].y), _341, (_332 * (WorkingColorSpace_064[1].x)))), _126, mad(mad((WorkingColorSpace_064[1].z), _347, mad((WorkingColorSpace_064[1].y), _338, (_329 * (WorkingColorSpace_064[1].x)))), _125, (mad((WorkingColorSpace_064[1].z), _344, mad((WorkingColorSpace_064[1].y), _335, (_326 * (WorkingColorSpace_064[1].x)))) * _124)));
    _390 = mad(mad((WorkingColorSpace_064[2].z), _350, mad((WorkingColorSpace_064[2].y), _341, (_332 * (WorkingColorSpace_064[2].x)))), _126, mad(mad((WorkingColorSpace_064[2].z), _347, mad((WorkingColorSpace_064[2].y), _338, (_329 * (WorkingColorSpace_064[2].x)))), _125, (mad((WorkingColorSpace_064[2].z), _344, mad((WorkingColorSpace_064[2].y), _335, (_326 * (WorkingColorSpace_064[2].x)))) * _124)));
  } else {
    _388 = _124;
    _389 = _125;
    _390 = _126;
  }
  _405 = mad((WorkingColorSpace_128[0].z), _390, mad((WorkingColorSpace_128[0].y), _389, ((WorkingColorSpace_128[0].x) * _388)));
  _408 = mad((WorkingColorSpace_128[1].z), _390, mad((WorkingColorSpace_128[1].y), _389, ((WorkingColorSpace_128[1].x) * _388)));
  _411 = mad((WorkingColorSpace_128[2].z), _390, mad((WorkingColorSpace_128[2].y), _389, ((WorkingColorSpace_128[2].x) * _388)));
  _412 = dot(float3(_405, _408, _411), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _416 = (_405 / _412) + -1.0f;
  _417 = (_408 / _412) + -1.0f;
  _418 = (_411 / _412) + -1.0f;
  _430 = (1.0f - exp2(((_412 * _412) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_416, _417, _418), float3(_416, _417, _418)) * -4.0f));
  _446 = ((mad(-0.06368321925401688f, _411, mad(-0.3292922377586365f, _408, (_405 * 1.3704125881195068f))) - _405) * _430) + _405;
  _447 = ((mad(-0.010861365124583244f, _411, mad(1.0970927476882935f, _408, (_405 * -0.08343357592821121f))) - _408) * _430) + _408;
  _448 = ((mad(1.2036951780319214f, _411, mad(-0.09862580895423889f, _408, (_405 * -0.02579331398010254f))) - _411) * _430) + _411;
  _449 = dot(float3(_446, _447, _448), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _463 = cb0_021w + cb0_026w;
  _477 = cb0_020w * cb0_025w;
  _491 = cb0_019w * cb0_024w;
  _505 = cb0_018w * cb0_023w;
  _519 = cb0_017w * cb0_022w;
  _523 = _446 - _449;
  _524 = _447 - _449;
  _525 = _448 - _449;
  _582 = saturate(_449 / cb0_037w);
  _586 = (_582 * _582) * (3.0f - (_582 * 2.0f));
  _587 = 1.0f - _586;
  _596 = cb0_021w + cb0_036w;
  _605 = cb0_020w * cb0_035w;
  _614 = cb0_019w * cb0_034w;
  _623 = cb0_018w * cb0_033w;
  _632 = cb0_017w * cb0_032w;
  _695 = saturate((_449 - cb0_038x) / (cb0_038y - cb0_038x));
  _699 = (_695 * _695) * (3.0f - (_695 * 2.0f));
  _708 = cb0_021w + cb0_031w;
  _717 = cb0_020w * cb0_030w;
  _726 = cb0_019w * cb0_029w;
  _735 = cb0_018w * cb0_028w;
  _744 = cb0_017w * cb0_027w;
  _802 = _586 - _699;
  _813 = ((_699 * (((cb0_021x + cb0_036x) + _596) + (((cb0_020x * cb0_035x) * _605) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _623) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _632) * _523) + _449)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _614)))))) + (_587 * (((cb0_021x + cb0_026x) + _463) + (((cb0_020x * cb0_025x) * _477) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _505) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _519) * _523) + _449)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _491))))))) + ((((cb0_021x + cb0_031x) + _708) + (((cb0_020x * cb0_030x) * _717) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _735) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _744) * _523) + _449)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _726))))) * _802);
  _815 = ((_699 * (((cb0_021y + cb0_036y) + _596) + (((cb0_020y * cb0_035y) * _605) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _623) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _632) * _524) + _449)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _614)))))) + (_587 * (((cb0_021y + cb0_026y) + _463) + (((cb0_020y * cb0_025y) * _477) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _505) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _519) * _524) + _449)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _491))))))) + ((((cb0_021y + cb0_031y) + _708) + (((cb0_020y * cb0_030y) * _717) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _735) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _744) * _524) + _449)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _726))))) * _802);
  _817 = ((_699 * (((cb0_021z + cb0_036z) + _596) + (((cb0_020z * cb0_035z) * _605) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _623) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _632) * _525) + _449)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _614)))))) + (_587 * (((cb0_021z + cb0_026z) + _463) + (((cb0_020z * cb0_025z) * _477) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _505) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _519) * _525) + _449)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _491))))))) + ((((cb0_021z + cb0_031z) + _708) + (((cb0_020z * cb0_030z) * _717) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _735) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _744) * _525) + _449)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _726))))) * _802);

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
  float4 output = ProcessLutbuilder(float3(_813, _815, _817), s0, s1, s2, t0, t1, t2, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _853 = ((mad(0.061360642313957214f, _817, mad(-4.540197551250458e-09f, _815, (_813 * 0.9386394023895264f))) - _813) * cb0_038z) + _813;
  _854 = ((mad(0.169205904006958f, _817, mad(0.8307942152023315f, _815, (_813 * 6.775371730327606e-08f))) - _815) * cb0_038z) + _815;
  _855 = (mad(-2.3283064365386963e-10f, _815, (_813 * -9.313225746154785e-10f)) * cb0_038z) + _817;
  _858 = mad(0.16386905312538147f, _855, mad(0.14067868888378143f, _854, (_853 * 0.6954522132873535f)));
  _861 = mad(0.0955343246459961f, _855, mad(0.8596711158752441f, _854, (_853 * 0.044794581830501556f)));
  _864 = mad(1.0015007257461548f, _855, mad(0.004025210160762072f, _854, (_853 * -0.005525882821530104f)));
  _868 = max(max(_858, _861), _864);
  _873 = (max(_868, 1.000000013351432e-10f) - max(min(min(_858, _861), _864), 1.000000013351432e-10f)) / max(_868, 0.009999999776482582f);
  _886 = ((_861 + _858) + _864) + (sqrt((((_864 - _861) * _864) + ((_861 - _858) * _861)) + ((_858 - _864) * _858)) * 1.75f);
  _887 = _886 * 0.3333333432674408f;
  _888 = _873 + -0.4000000059604645f;
  _889 = _888 * 5.0f;
  _893 = max((1.0f - abs(_888 * 2.5f)), 0.0f);
  _904 = ((float((int)(((int)(uint)((int)(_889 > 0.0f))) - ((int)(uint)((int)(_889 < 0.0f))))) * (1.0f - (_893 * _893))) + 1.0f) * 0.02500000037252903f;
  if (_887 > 0.0533333346247673f) {
    if (_887 < 0.1599999964237213f) {
      _913 = (((0.23999999463558197f / _886) + -0.5f) * _904);
    } else {
      _913 = 0.0f;
    }
  } else {
    _913 = _904;
  }
  _914 = _913 + 1.0f;
  _915 = _914 * _858;
  _916 = _914 * _861;
  _917 = _914 * _864;
  if (!((_915 == _916) && (_916 == _917))) {
    _924 = ((_915 * 2.0f) - _916) - _917;
    _927 = ((_861 - _864) * 1.7320507764816284f) * _914;
    _929 = atan(_927 / _924);
    _932 = (_924 < 0.0f);
    _933 = (_924 == 0.0f);
    _934 = (_927 >= 0.0f);
    _935 = (_927 < 0.0f);
    _946 = select((_934 && _933), 90.0f, select((_935 && _933), -90.0f, (select((_935 && _932), (_929 + -3.1415927410125732f), select((_934 && _932), (_929 + 3.1415927410125732f), _929)) * 57.2957763671875f)));
  } else {
    _946 = 0.0f;
  }
  _951 = min(max(select((_946 < 0.0f), (_946 + 360.0f), _946), 0.0f), 360.0f);
  if (_951 < -180.0f) {
    _960 = (_951 + 360.0f);
  } else {
    if (_951 > 180.0f) {
      _960 = (_951 + -360.0f);
    } else {
      _960 = _951;
    }
  }
  _964 = saturate(1.0f - abs(_960 * 0.014814814552664757f));
  _968 = (_964 * _964) * (3.0f - (_964 * 2.0f));
  _974 = ((_968 * _968) * ((_873 * 0.18000000715255737f) * (0.029999999329447746f - _915))) + _915;
  _984 = max(0.0f, mad(-0.21492856740951538f, _917, mad(-0.2365107536315918f, _916, (_974 * 1.4514392614364624f))));
  _985 = max(0.0f, mad(-0.09967592358589172f, _917, mad(1.17622971534729f, _916, (_974 * -0.07655377686023712f))));
  _986 = max(0.0f, mad(0.9977163076400757f, _917, mad(-0.006032449658960104f, _916, (_974 * 0.008316148072481155f))));
  _987 = dot(float3(_984, _985, _986), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1002 = (cb0_040x + 1.0f) - cb0_039z;
  _1004 = cb0_040y + 1.0f;
  _1006 = _1004 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1024 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1015 = (cb0_040x + 0.18000000715255737f) / _1002;
    _1024 = (-0.7447274923324585f - ((log2(_1015 / (2.0f - _1015)) * 0.3465735912322998f) * (_1002 / cb0_039y)));
  }
  _1027 = ((1.0f - cb0_039z) / cb0_039y) - _1024;
  _1029 = (cb0_039w / cb0_039y) - _1027;
  _1033 = log2(lerp(_987, _984, 0.9599999785423279f)) * 0.3010300099849701f;
  _1034 = log2(lerp(_987, _985, 0.9599999785423279f)) * 0.3010300099849701f;
  _1035 = log2(lerp(_987, _986, 0.9599999785423279f)) * 0.3010300099849701f;
  _1039 = cb0_039y * (_1033 + _1027);
  _1040 = cb0_039y * (_1034 + _1027);
  _1041 = cb0_039y * (_1035 + _1027);
  _1042 = _1002 * 2.0f;
  _1044 = (cb0_039y * -2.0f) / _1002;
  _1045 = _1033 - _1024;
  _1046 = _1034 - _1024;
  _1047 = _1035 - _1024;
  _1066 = _1006 * 2.0f;
  _1068 = (cb0_039y * 2.0f) / _1006;
  _1093 = select((_1033 < _1024), ((_1042 / (exp2((_1045 * 1.4426950216293335f) * _1044) + 1.0f)) - cb0_040x), _1039);
  _1094 = select((_1034 < _1024), ((_1042 / (exp2((_1046 * 1.4426950216293335f) * _1044) + 1.0f)) - cb0_040x), _1040);
  _1095 = select((_1035 < _1024), ((_1042 / (exp2((_1047 * 1.4426950216293335f) * _1044) + 1.0f)) - cb0_040x), _1041);
  _1102 = _1029 - _1024;
  _1106 = saturate(_1045 / _1102);
  _1107 = saturate(_1046 / _1102);
  _1108 = saturate(_1047 / _1102);
  _1109 = (_1029 < _1024);
  _1113 = select(_1109, (1.0f - _1106), _1106);
  _1114 = select(_1109, (1.0f - _1107), _1107);
  _1115 = select(_1109, (1.0f - _1108), _1108);
  _1134 = (((_1113 * _1113) * (select((_1033 > _1029), (_1004 - (_1066 / (exp2(((_1033 - _1029) * 1.4426950216293335f) * _1068) + 1.0f))), _1039) - _1093)) * (3.0f - (_1113 * 2.0f))) + _1093;
  _1135 = (((_1114 * _1114) * (select((_1034 > _1029), (_1004 - (_1066 / (exp2(((_1034 - _1029) * 1.4426950216293335f) * _1068) + 1.0f))), _1040) - _1094)) * (3.0f - (_1114 * 2.0f))) + _1094;
  _1136 = (((_1115 * _1115) * (select((_1035 > _1029), (_1004 - (_1066 / (exp2(((_1035 - _1029) * 1.4426950216293335f) * _1068) + 1.0f))), _1041) - _1095)) * (3.0f - (_1115 * 2.0f))) + _1095;
  _1137 = dot(float3(_1134, _1135, _1136), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1157 = (cb0_039x * (max(0.0f, (lerp(_1137, _1134, 0.9300000071525574f))) - _853)) + _853;
  _1158 = (cb0_039x * (max(0.0f, (lerp(_1137, _1135, 0.9300000071525574f))) - _854)) + _854;
  _1159 = (cb0_039x * (max(0.0f, (lerp(_1137, _1136, 0.9300000071525574f))) - _855)) + _855;
  _1175 = ((mad(-0.06537103652954102f, _1159, mad(1.451815478503704e-06f, _1158, (_1157 * 1.065374732017517f))) - _1157) * cb0_038z) + _1157;
  _1176 = ((mad(-0.20366770029067993f, _1159, mad(1.2036634683609009f, _1158, (_1157 * -2.57161445915699e-07f))) - _1158) * cb0_038z) + _1158;
  _1177 = ((mad(0.9999996423721313f, _1159, mad(2.0954757928848267e-08f, _1158, (_1157 * 1.862645149230957e-08f))) - _1159) * cb0_038z) + _1159;
  _1190 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1177, mad((WorkingColorSpace_192[0].y), _1176, ((WorkingColorSpace_192[0].x) * _1175)))));
  _1191 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1177, mad((WorkingColorSpace_192[1].y), _1176, ((WorkingColorSpace_192[1].x) * _1175)))));
  _1192 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1177, mad((WorkingColorSpace_192[2].y), _1176, ((WorkingColorSpace_192[2].x) * _1175)))));
  if (_1190 < 0.0031306699384003878f) {
    _1203 = (_1190 * 12.920000076293945f);
  } else {
    _1203 = (((pow(_1190, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1191 < 0.0031306699384003878f) {
    _1214 = (_1191 * 12.920000076293945f);
  } else {
    _1214 = (((pow(_1191, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1192 < 0.0031306699384003878f) {
    _1225 = (_1192 * 12.920000076293945f);
  } else {
    _1225 = (((pow(_1192, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1229 = (_1214 * 0.9375f) + 0.03125f;
  _1236 = _1225 * 15.0f;
  _1237 = floor(_1236);
  _1238 = _1236 - _1237;
  _1240 = (_1237 + ((_1203 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1243 = t0.SampleLevel(s0, float2(_1240, _1229), 0.0f);
  _1247 = _1240 + 0.0625f;
  _1248 = t0.SampleLevel(s0, float2(_1247, _1229), 0.0f);
  _1270 = t1.SampleLevel(s1, float2(_1240, _1229), 0.0f);
  _1274 = t1.SampleLevel(s1, float2(_1247, _1229), 0.0f);
  _1296 = t2.SampleLevel(s2, float2(_1240, _1229), 0.0f);
  _1300 = t2.SampleLevel(s2, float2(_1247, _1229), 0.0f);
  _1316 = ((((lerp(_1243.x, _1248.x, _1238)) * cb0_005y) + (cb0_005x * _1203)) + ((lerp(_1270.x, _1274.x, _1238)) * cb0_005z)) + ((lerp(_1296.x, _1300.x, _1238)) * cb0_005w);
  _1317 = ((((lerp(_1243.y, _1248.y, _1238)) * cb0_005y) + (cb0_005x * _1214)) + ((lerp(_1270.y, _1274.y, _1238)) * cb0_005z)) + ((lerp(_1296.y, _1300.y, _1238)) * cb0_005w);
  _1318 = ((((lerp(_1243.z, _1248.z, _1238)) * cb0_005y) + (cb0_005x * _1225)) + ((lerp(_1270.z, _1274.z, _1238)) * cb0_005z)) + ((lerp(_1296.z, _1300.z, _1238)) * cb0_005w);
  _1343 = select((_1316 > 0.040449999272823334f), exp2(log2((abs(_1316) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1316 * 0.07739938050508499f));
  _1344 = select((_1317 > 0.040449999272823334f), exp2(log2((abs(_1317) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1317 * 0.07739938050508499f));
  _1345 = select((_1318 > 0.040449999272823334f), exp2(log2((abs(_1318) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1318 * 0.07739938050508499f));
  _1371 = cb0_016x * (((cb0_041y + (cb0_041x * _1343)) * _1343) + cb0_041z);
  _1372 = cb0_016y * (((cb0_041y + (cb0_041x * _1344)) * _1344) + cb0_041z);
  _1373 = cb0_016z * (((cb0_041y + (cb0_041x * _1345)) * _1345) + cb0_041z);
  _1380 = ((cb0_015x - _1371) * cb0_015w) + _1371;
  _1381 = ((cb0_015y - _1372) * cb0_015w) + _1372;
  _1382 = ((cb0_015z - _1373) * cb0_015w) + _1373;
  _1383 = cb0_016x * mad((WorkingColorSpace_192[0].z), _817, mad((WorkingColorSpace_192[0].y), _815, (_813 * (WorkingColorSpace_192[0].x))));
  _1384 = cb0_016y * mad((WorkingColorSpace_192[1].z), _817, mad((WorkingColorSpace_192[1].y), _815, ((WorkingColorSpace_192[1].x) * _813)));
  _1385 = cb0_016z * mad((WorkingColorSpace_192[2].z), _817, mad((WorkingColorSpace_192[2].y), _815, ((WorkingColorSpace_192[2].x) * _813)));
  _1392 = ((cb0_015x - _1383) * cb0_015w) + _1383;
  _1393 = ((cb0_015y - _1384) * cb0_015w) + _1384;
  _1394 = ((cb0_015z - _1385) * cb0_015w) + _1385;
  _1406 = exp2(log2(max(0.0f, _1380)) * cb0_042y);
  _1407 = exp2(log2(max(0.0f, _1381)) * cb0_042y);
  _1408 = exp2(log2(max(0.0f, _1382)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1431 = mad((WorkingColorSpace_128[0].z), _1408, mad((WorkingColorSpace_128[0].y), _1407, ((WorkingColorSpace_128[0].x) * _1406)));
      _1434 = mad((WorkingColorSpace_128[1].z), _1408, mad((WorkingColorSpace_128[1].y), _1407, ((WorkingColorSpace_128[1].x) * _1406)));
      _1437 = mad((WorkingColorSpace_128[2].z), _1408, mad((WorkingColorSpace_128[2].y), _1407, ((WorkingColorSpace_128[2].x) * _1406)));
      _1448 = mad(_60, _1437, mad(_59, _1434, (_1431 * _58)));
      _1449 = mad(_63, _1437, mad(_62, _1434, (_1431 * _61)));
      _1450 = mad(_66, _1437, mad(_65, _1434, (_1431 * _64)));
    } else {
      _1448 = _1406;
      _1449 = _1407;
      _1450 = _1408;
    }
    if (_1448 < 0.0031306699384003878f) {
      _1461 = (_1448 * 12.920000076293945f);
    } else {
      _1461 = (((pow(_1448, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1449 < 0.0031306699384003878f) {
      _1472 = (_1449 * 12.920000076293945f);
    } else {
      _1472 = (((pow(_1449, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1450 < 0.0031306699384003878f) {
      _3478 = _1461;
      _3479 = _1472;
      _3480 = (_1450 * 12.920000076293945f);
    } else {
      _3478 = _1461;
      _3479 = _1472;
      _3480 = (((pow(_1450, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1499 = mad((WorkingColorSpace_128[0].z), _1408, mad((WorkingColorSpace_128[0].y), _1407, ((WorkingColorSpace_128[0].x) * _1406)));
      _1502 = mad((WorkingColorSpace_128[1].z), _1408, mad((WorkingColorSpace_128[1].y), _1407, ((WorkingColorSpace_128[1].x) * _1406)));
      _1505 = mad((WorkingColorSpace_128[2].z), _1408, mad((WorkingColorSpace_128[2].y), _1407, ((WorkingColorSpace_128[2].x) * _1406)));
      _1508 = mad(_60, _1505, mad(_59, _1502, (_1499 * _58)));
      _1511 = mad(_63, _1505, mad(_62, _1502, (_1499 * _61)));
      _1514 = mad(_66, _1505, mad(_65, _1502, (_1499 * _64)));
      _3478 = min((_1508 * 4.5f), ((exp2(log2(max(_1508, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3479 = min((_1511 * 4.5f), ((exp2(log2(max(_1511, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3480 = min((_1514 * 4.5f), ((exp2(log2(max(_1514, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
        _1559 = cb0_012z * _1392;
        _1560 = cb0_012z * _1393;
        _1561 = cb0_012z * _1394;
        _1564 = mad((WorkingColorSpace_256[0].z), _1561, mad((WorkingColorSpace_256[0].y), _1560, (_1559 * (WorkingColorSpace_256[0].x))));
        _1567 = mad((WorkingColorSpace_256[1].z), _1561, mad((WorkingColorSpace_256[1].y), _1560, (_1559 * (WorkingColorSpace_256[1].x))));
        _1570 = mad((WorkingColorSpace_256[2].z), _1561, mad((WorkingColorSpace_256[2].y), _1560, (_1559 * (WorkingColorSpace_256[2].x))));
        _1571 = cb0_043y * 0.009999999776482582f;
        _1572 = log2(_1571);
        _1577 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
        _1592 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_1577 * 400.0f) / (_1577 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1594 = (_1572 * 1.4018198251724243f) + 10.012999534606934f;
        _1599 = exp2(log2(abs(_1594) * 0.00793700572103262f) * 0.41999998688697815f);
        _1640 = (_1572 * 924.7640991210938f) + 1024.0f;
        _1644 = min(max(mad(-0.21492856740951538f, _1570, mad(-0.2365107536315918f, _1567, (_1564 * 1.4514392614364624f))), 0.0f), _1640);
        _1645 = min(max(mad(-0.09967592358589172f, _1570, mad(1.17622971534729f, _1567, (_1564 * -0.07655377686023712f))), 0.0f), _1640);
        _1646 = min(max(mad(0.9977163076400757f, _1570, mad(-0.006032449658960104f, _1567, (_1564 * 0.008316148072481155f))), 0.0f), _1640);
        _1649 = mad(0.15618768334388733f, _1646, mad(0.13400420546531677f, _1645, (_1644 * 0.6624541878700256f)));
        _1656 = mad(0.053689517080783844f, _1646, mad(0.6740817427635193f, _1645, (_1644 * 0.2722287178039551f))) * 100.0f;
        _1657 = mad(1.0103391408920288f, _1646, mad(0.00406073359772563f, _1645, (_1644 * -0.005574649665504694f))) * 100.0f;
        _1667 = mad(0.04110127314925194f, _1657, mad(0.594700813293457f, _1656, (_1649 * 36.407447814941406f))) * 1.0172951221466064f;
        _1668 = mad(0.1479453295469284f, _1657, mad(1.0738555192947388f, _1656, (_1649 * -22.224510192871094f))) * 0.9887425899505615f;
        _1669 = mad(0.9503875374794006f, _1657, mad(0.04882604628801346f, _1656, (_1649 * -0.20676189661026f))) * 0.9944003820419312f;
        _1673 = abs(_1667) * 0.00793700572103262f;
        _1674 = abs(_1668) * 0.00793700572103262f;
        _1675 = abs(_1669) * 0.00793700572103262f;
        if (!(_1673 < 0.0f)) {
          _1682 = (pow(_1673, 0.41999998688697815f));
        } else {
          _1682 = 0.0f;
        }
        if (!(_1674 < 0.0f)) {
          _1689 = (pow(_1674, 0.41999998688697815f));
        } else {
          _1689 = 0.0f;
        }
        if (!(_1675 < 0.0f)) {
          _1696 = (pow(_1675, 0.41999998688697815f));
        } else {
          _1696 = 0.0f;
        }
        _1724 = ((float((int)(((int)(uint)((int)(_1667 > 0.0f))) - ((int)(uint)((int)(_1667 < 0.0f))))) * 400.0f) * _1682) / (_1682 + 27.1299991607666f);
        _1725 = ((float((int)(((int)(uint)((int)(_1668 > 0.0f))) - ((int)(uint)((int)(_1668 < 0.0f))))) * 400.0f) * _1689) / (_1689 + 27.1299991607666f);
        _1726 = ((float((int)(((int)(uint)((int)(_1669 > 0.0f))) - ((int)(uint)((int)(_1669 < 0.0f))))) * 400.0f) * _1696) / (_1696 + 27.1299991607666f);
        _1730 = (_1724 - (_1725 * 1.0909091234207153f)) + (_1726 * 0.09090909361839294f);
        _1734 = ((_1725 + _1724) - (_1726 * 2.0f)) * 0.1111111119389534f;
        _1736 = atan(_1734 / _1730);
        _1739 = (_1730 < 0.0f);
        _1740 = (_1730 == 0.0f);
        _1741 = (_1734 >= 0.0f);
        _1742 = (_1734 < 0.0f);
        _1751 = select((_1740 && _1741), 0.25f, select((_1740 && _1742), -0.25f, (select((_1739 && _1742), (_1736 + -3.1415927410125732f), select((_1739 && _1741), (_1736 + 3.1415927410125732f), _1736)) * 0.15915493667125702f)));
        _1755 = frac(abs(_1751));
        _1758 = select((_1751 >= (-0.0f - _1751)), _1755, (-0.0f - _1755)) * 360.0f;
        _1761 = select((_1758 < 0.0f), (_1758 + 360.0f), _1758);
        _1770 = exp2(log2((((_1724 * 2.0f) + _1725) + (_1726 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
        if (!(_1770 == 0.0f)) {
          _1779 = (sqrt((_1734 * _1734) + (_1730 * _1730)) * 38.70000076293945f);
        } else {
          _1779 = 0.0f;
        }
        _1784 = exp2(log2(abs(_1770) * 0.009999999776482582f) * 0.8794641494750977f);
        _1799 = (float((int)(((int)(uint)((int)(_1770 > 0.0f))) - ((int)(uint)((int)(_1770 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_1784 * 351.2578430175781f) / (400.0f - (_1784 * 12.947211265563965f))) * 2.3809523582458496f);
        _1801 = (_1572 * 115.59551239013672f) + 128.0f;
        _1805 = sqrt((_1571 + 0.1599999964237213f) * _1571) + _1571;
        _1806 = _1805 * 0.5f;
        _1807 = _1801 / _1806;
        _1814 = _1572 * 0.014018198475241661f;
        _1815 = _1814 + 0.10012999176979065f;
        _1825 = exp2(log2((((_1815 + sqrt(_1815 * (_1814 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_1801 / (_1806 * (_1807 + 1.0f))) * 1.149999976158142f)) / _1806) * 0.8695652484893799f);
        _1830 = 0.18000000715255737f / (((_1805 * -0.5f) * _1825) / (_1825 + -1.0f));
        _1845 = exp2(log2(max(0.0f, _1799) / ((_1830 * _1806) + _1799)) * 1.149999976158142f) * (_1806 / exp2(log2(_1801 / ((_1807 + _1830) * _1806)) * 1.149999976158142f));
        _1850 = max(0.0f, ((_1845 * _1845) / (_1845 + 0.03999999910593033f))) * 100.0f;
        _1855 = exp2(log2(abs(_1850) * 0.00793700572103262f) * 0.41999998688697815f);
        _1870 = (float((int)(((int)(uint)((int)(_1850 > 0.0f))) - ((int)(uint)((int)(_1850 < 0.0f))))) * 100.0f) * exp2(log2(((_1855 * 400.0f) / (_1855 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1872 = _1761 * 0.0027777778450399637f;
        _1873 = -0.0f - _1872;
        _1875 = frac(abs(_1872));
        _1876 = -0.0f - _1875;
        if (!(_1779 == 0.0f)) {
          _1878 = _1870 / _1592;
          _1880 = max(0.0f, (1.0f - _1878));
          _1881 = _1761 * 0.01745329424738884f;
          _1882 = cos(_1881);
          _1883 = sin(_1881);
          _1884 = _1882 * _1882;
          _1885 = _1883 * _1883;
          _1900 = ((((77.12895965576172f - ((_1882 * 12.74448013305664f) * _1883)) + ((_1884 - _1885) * 16.468990325927734f)) + (((_1884 * 31.535200119018555f) + -12.31067943572998f) * _1882)) + ((42.245330810546875f - (_1885 * 36.774559020996094f)) * _1883)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
          _1906 = select((_1872 >= _1873), _1875, _1876) * 360.0f;
          _1910 = int(select((_1906 < 0.0f), (_1906 + 360.0f), _1906));
          _1912 = (_1910 + 1) % 360;
          _1921 = t3.Load(int3(_1910, 0, 0));
          _1926 = (((((t3.Load(int3(_1912, 0, 0))).x) - _1921.x) * ((_1761 - float((int)(_1910))) / float((int)(_1912 - _1910)))) + _1921.x) * (pow(_1878, 0.8794641494750977f));
          _1927 = _1926 / _1900;
          _1928 = _1927 + -0.0010000000474974513f;
          _1929 = _1880 * max(0.20000000298023224f, (1.2999999523162842f - (_1572 * 0.270023912191391f)));
          _1930 = _1878 * ((_1572 * 2.384157657623291f) + 2.4000000953674316f);
          _1937 = (_1926 - (exp2(log2(_1870 / _1770) * 0.8794641494750977f) * _1779)) / _1900;
          if (!(_1937 > _1928)) {
            _1943 = max(sqrt((_1878 * _1878) + (0.5f / cb0_043y)), 0.0010000000474974513f);
            _1947 = sqrt((_1943 * _1943) + (_1929 * _1929));
            _1950 = (_1947 + _1928) / (_1943 + _1928);
            _1952 = (_1950 * _1937) - _1947;
            _1962 = ((_1952 + sqrt((_1952 * _1952) + (((_1937 * 4.0f) * _1943) * _1950))) * 0.5f);
          } else {
            _1962 = _1937;
          }
          _1963 = _1927 - _1962;
          if (!(_1963 > _1927)) {
            _1966 = max(_1880, 0.0010000000474974513f);
            _1970 = sqrt((_1966 * _1966) + (_1930 * _1930));
            _1973 = (_1970 + _1927) / (_1966 + _1927);
            _1975 = (_1973 * _1963) - _1970;
            _1985 = ((_1975 + sqrt((_1975 * _1975) + (((_1963 * 4.0f) * _1966) * _1973))) * 0.5f);
          } else {
            _1985 = _1963;
          }
          _1988 = (_1985 * _1900);
        } else {
          _1988 = _1779;
        }
        _1991 = select((_1872 >= _1873), _1875, _1876) * 360.0f;
        _1994 = select((_1991 < 0.0f), (_1991 + 360.0f), _1991);
        _1995 = int(_1994);
        _1996 = _1995 + 1;
        _1998 = 0;
        _1999 = 361;
        _2000 = _1996;
        while(true) {
          _2004 = (_1761 > (((float3)(t4.Load(int3(_2000, 0, 0)))).z));
          _2005 = select(_2004, _2000, _1998);
          _2006 = select(_2004, _1999, _2000);
          if ((int)(_2005 + 1) < (int)_2006) {
            _1998 = _2005;
            _1999 = _2006;
            _2000 = ((_2005 + _2006) / 2);
            continue;
          }
          _2013 = t4.Load(int3((_2006 + -1), 0, 0));
          _2017 = t4.Load(int3(_2006, 0, 0));
          _2023 = (_1761 - _2013.z) / (_2017.z - _2013.z);
          _2026 = ((_2017.x - _2013.x) * _2023) + _2013.x;
          if (!((_1870 > _1592) || (_1988 < 9.999999747378752e-05f))) {
            _2040 = (min(1.0f, (1.2999999523162842f - (_2026 / _1592))) * (((float((int)(((int)(uint)((int)(_1594 > 0.0f))) - ((int)(uint)((int)(_1594 < 0.0f))))) * 100.0f) * exp2(log2(((_1599 * 400.0f) / (_1599 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _2026)) + _2026;
            _2041 = ((_1572 * 0.7111833691596985f) + 1.350000023841858f) * _1592;
            _2042 = _1592 - _2026;
            _2044 = (_2042 * 0.30000001192092896f) + _2026;
            if (_1870 > _2044) {
              _2058 = (exp2(log2(log2((_1592 - _2044) / max(9.999999747378752e-05f, (_1592 - _1870))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _2058 = 1.0f;
            }
            _2059 = _2041 * _2058;
            t5.GetDimensions(_2061.x, _2061.y);
            _2065 = float((int)(_1995));
            _2069 = t5.Load(int3(_1996, 0, 0));
            _2074 = (lerp(_2013.y, _2017.y, _2023)) * 1.0324000120162964f;
            _2075 = _2059 * _2040;
            _2077 = (_1870 < _2040);
            _2078 = _1988 / _2059;
            if (_2077) {
              _2088 = (1.0f - _2078);
            } else {
              _2088 = (-0.0f - ((_2078 + 1.0f) + ((_1988 * _1592) / _2075)));
            }
            if (_2077) {
              _2096 = (-0.0f - _1870);
            } else {
              _2096 = (((_1988 * _1592) / _2059) + _1870);
            }
            _2101 = sqrt((_2088 * _2088) - (((_1988 / _2075) * 4.0f) * _2096));
            _2107 = (_2096 * 2.0f) / select(_2077, ((-0.0f - _2088) - _2101), (_2101 - _2088));
            _2109 = (_2026 < _2040);
            _2110 = _2074 / _2059;
            if (_2109) {
              _2120 = (1.0f - _2110);
            } else {
              _2120 = (-0.0f - ((_2110 + 1.0f) + ((_2074 * _1592) / _2075)));
            }
            if (!_2109) {
              _2126 = (((_2074 * _1592) / _2059) + _2026);
            } else {
              _2126 = (-0.0f - _2026);
            }
            _2131 = sqrt((_2120 * _2120) - (((_2074 / _2075) * 4.0f) * _2126));
            _2137 = (_2126 * 2.0f) / select(_2109, ((-0.0f - _2120) - _2131), (_2131 - _2120));
            _2139 = _1592 - _2107;
            _2143 = ((_2107 - _2040) * select((_2107 < _2040), _2107, _2139)) / _2075;
            _2152 = _1592 - _2137;
            _2163 = ((_2152 * _2074) * exp2(log2(_2139 / _2152) * (1.0f / (((((t5.Load(int3(((_1995 + 2) % (int)(_2061.x)), 0, 0))).x) - _2069.x) * (_1994 - _2065)) + _2069.x)))) / ((_2042 + (_2143 * _2074)) * _2074);
            _2165 = (exp2(log2(_2107 / _2137) * (1.0f / ((_1572 * 0.02107210084795952f) + 1.1399999856948853f))) * _2137) / (((_2026 / _2074) - _2143) * _2074);
            _2169 = max((0.11999999731779099f - abs(_2165 - _2163)), 0.0f);
            _2170 = _2169 * 8.333333969116211f;
            _2176 = (min(_2165, _2163) - ((_2170 * _2170) * (_2169 * 0.1666666716337204f))) * _2074;
            _2177 = _2176 * _2143;
            _2178 = _2177 + _2107;
            _2179 = _1996 % 360;
            _2187 = t3.Load(int3(_1995, 0, 0));
            _2191 = ((((t3.Load(int3(_2179, 0, 0))).x) - _2187.x) * ((_1761 - _2065) / float((int)(_2179 - _1995)))) + _2187.x;
            if (_2178 > _2044) {
              _2205 = (exp2(log2(log2((_1592 - _2044) / max(9.999999747378752e-05f, (_1592 - _2178))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _2205 = 1.0f;
            }
            _2206 = _2041 * _2205;
            _2207 = _2206 * _2040;
            _2209 = (_2178 < _2040);
            _2210 = _2176 / _2206;
            if (_2209) {
              _2220 = (1.0f - _2210);
            } else {
              _2220 = (-0.0f - ((_2210 + 1.0f) + ((_2176 * _1592) / _2207)));
            }
            if (_2209) {
              _2228 = (-0.0f - _2178);
            } else {
              _2228 = (((_2176 * _1592) / _2206) + _2178);
            }
            _2233 = sqrt((_2220 * _2220) - (((_2176 / _2207) * 4.0f) * _2228));
            _2239 = (_2228 * 2.0f) / select(_2209, ((-0.0f - _2220) - _2233), (_2233 - _2220));
            _2256 = max(1.000100016593933f, (((_2191 * _1592) * exp2(log2(_2239 / _1592) * 0.8794641494750977f)) / ((_1592 - ((((_2239 - _2040) * select((_2239 < _2040), _2239, (_1592 - _2239))) / _2207) * _2191)) * _2176)));
            _2258 = max(0.75f, (1.0f / _2256));
            _2259 = _1988 / _2176;
            _2264 = ((_2256 - _2258) * (1.0f - _2258)) / (_2256 + -1.0f);
            _2266 = (_2259 - _2258) / _2264;
            if (!((_2256 <= 1.000100016593933f) || (_2259 < _2258))) {
              _2276 = (((_2266 * _2264) / (_2266 + 1.0f)) + _2258);
            } else {
              _2276 = _2259;
            }
            _2282 = ((_2276 * _2177) + _2107);
            _2283 = ((_2176 * _2276) * 0.0258397925645113f);
          } else {
            _2282 = _1870;
            _2283 = 0.0f;
          }
          _2284 = _1761 * 0.01745329424738884f;
          _2285 = _2282 * 0.009999999776482582f;
          if (!(_2285 < 0.0f)) {
            _2294 = (((pow(_2285, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
          } else {
            _2294 = 0.0f;
          }
          _2296 = cos(_2284) * _2283;
          _2298 = sin(_2284) * _2283;
          _2305 = mad(288.0f, _2298, mad(451.0f, _2296, _2294)) * 0.0007127583958208561f;
          _2306 = mad(-261.0f, _2298, mad(-891.0f, _2296, _2294)) * 0.0007127583958208561f;
          _2307 = mad(-6300.0f, _2298, mad(-220.0f, _2296, _2294)) * 0.0007127583958208561f;
          _2327 = abs(_2305);
          _2328 = abs(_2306);
          _2329 = abs(_2307);
          _2336 = (_2327 * 27.1299991607666f) / (400.0f - _2327);
          _2337 = (_2328 * 27.1299991607666f) / (400.0f - _2328);
          _2338 = (_2329 * 27.1299991607666f) / (400.0f - _2329);
          if (!(_2336 < 0.0f)) {
            _2345 = (pow(_2336, 2.3809523582458496f));
          } else {
            _2345 = 0.0f;
          }
          if (!(_2337 < 0.0f)) {
            _2352 = (pow(_2337, 2.3809523582458496f));
          } else {
            _2352 = 0.0f;
          }
          if (!(_2338 < 0.0f)) {
            _2359 = (pow(_2338, 2.3809523582458496f));
          } else {
            _2359 = 0.0f;
          }
          _2360 = (float((int)(((int)(uint)((int)(_2305 > 0.0f))) - ((int)(uint)((int)(_2305 < 0.0f))))) * 125.99209594726562f) * _2345;
          _2362 = (float((int)(((int)(uint)((int)(_2306 > 0.0f))) - ((int)(uint)((int)(_2306 < 0.0f))))) * 127.42658996582031f) * _2352;
          _2364 = (float((int)(((int)(uint)((int)(_2307 > 0.0f))) - ((int)(uint)((int)(_2307 < 0.0f))))) * 126.70159912109375f) * _2359;
          _2367 = mad(0.08875565975904465f, _2364, mad(-1.140031337738037f, _2362, (_2360 * 2.016401767730713f)));
          _2374 = mad(-0.12752249836921692f, _2364, mad(0.7005835175514221f, _2362, (_2360 * 0.41968056559562683f))) * 0.009999999776482582f;
          _2375 = mad(1.0589468479156494f, _2364, mad(-0.03847259283065796f, _2362, (_2360 * -0.01717424765229225f))) * 0.009999999776482582f;
          _2388 = min(max(mad(-0.23642469942569733f, _2375, mad(-0.32480329275131226f, _2374, (_2367 * 0.016410233452916145f))), 0.0f), _1571);
          _2389 = min(max(mad(0.016756348311901093f, _2375, mad(1.6153316497802734f, _2374, (_2367 * -0.006636628415435553f))), 0.0f), _1571);
          _2390 = min(max(mad(0.9883948564529419f, _2375, mad(-0.008284442126750946f, _2374, (_2367 * 0.00011721893679350615f))), 0.0f), _1571);
          _2393 = mad(0.15618768334388733f, _2390, mad(0.13400420546531677f, _2389, (_2388 * 0.6624541878700256f)));
          _2396 = mad(0.053689517080783844f, _2390, mad(0.6740817427635193f, _2389, (_2388 * 0.2722287178039551f)));
          _2399 = mad(1.0103391408920288f, _2390, mad(0.00406073359772563f, _2389, (_2388 * -0.005574649665504694f)));
          _2409 = mad(-0.23642469942569733f, _2399, mad(-0.32480329275131226f, _2396, (_2393 * 1.6410233974456787f))) * 100.0f;
          _2410 = mad(0.016756348311901093f, _2399, mad(1.6153316497802734f, _2396, (_2393 * -0.663662850856781f))) * 100.0f;
          _2411 = mad(0.9883948564529419f, _2399, mad(-0.008284442126750946f, _2396, (_2393 * 0.011721894145011902f))) * 100.0f;
          _2430 = exp2(log2(mad(_60, _2411, mad(_59, _2410, (_2409 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2431 = exp2(log2(mad(_63, _2411, mad(_62, _2410, (_2409 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2432 = exp2(log2(mad(_66, _2411, mad(_65, _2410, (_2409 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _3478 = exp2(log2((1.0f / ((_2430 * 18.6875f) + 1.0f)) * ((_2430 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3479 = exp2(log2((1.0f / ((_2431 * 18.6875f) + 1.0f)) * ((_2431 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3480 = exp2(log2((1.0f / ((_2432 * 18.6875f) + 1.0f)) * ((_2432 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          break;
        }
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2480 = cb0_012z * _1392;
          _2481 = cb0_012z * _1393;
          _2482 = cb0_012z * _1394;
          _2485 = mad((WorkingColorSpace_256[0].z), _2482, mad((WorkingColorSpace_256[0].y), _2481, (_2480 * (WorkingColorSpace_256[0].x))));
          _2488 = mad((WorkingColorSpace_256[1].z), _2482, mad((WorkingColorSpace_256[1].y), _2481, (_2480 * (WorkingColorSpace_256[1].x))));
          _2491 = mad((WorkingColorSpace_256[2].z), _2482, mad((WorkingColorSpace_256[2].y), _2481, (_2480 * (WorkingColorSpace_256[2].x))));
          _2492 = cb0_043y * 0.009999999776482582f;
          _2493 = log2(_2492);
          _2498 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
          _2513 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_2498 * 400.0f) / (_2498 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2515 = (_2493 * 1.4018198251724243f) + 10.012999534606934f;
          _2520 = exp2(log2(abs(_2515) * 0.00793700572103262f) * 0.41999998688697815f);
          _2561 = (_2493 * 924.7640991210938f) + 1024.0f;
          _2565 = min(max(mad(-0.21492856740951538f, _2491, mad(-0.2365107536315918f, _2488, (_2485 * 1.4514392614364624f))), 0.0f), _2561);
          _2566 = min(max(mad(-0.09967592358589172f, _2491, mad(1.17622971534729f, _2488, (_2485 * -0.07655377686023712f))), 0.0f), _2561);
          _2567 = min(max(mad(0.9977163076400757f, _2491, mad(-0.006032449658960104f, _2488, (_2485 * 0.008316148072481155f))), 0.0f), _2561);
          _2570 = mad(0.15618768334388733f, _2567, mad(0.13400420546531677f, _2566, (_2565 * 0.6624541878700256f)));
          _2577 = mad(0.053689517080783844f, _2567, mad(0.6740817427635193f, _2566, (_2565 * 0.2722287178039551f))) * 100.0f;
          _2578 = mad(1.0103391408920288f, _2567, mad(0.00406073359772563f, _2566, (_2565 * -0.005574649665504694f))) * 100.0f;
          _2588 = mad(0.04110127314925194f, _2578, mad(0.594700813293457f, _2577, (_2570 * 36.407447814941406f))) * 1.0172951221466064f;
          _2589 = mad(0.1479453295469284f, _2578, mad(1.0738555192947388f, _2577, (_2570 * -22.224510192871094f))) * 0.9887425899505615f;
          _2590 = mad(0.9503875374794006f, _2578, mad(0.04882604628801346f, _2577, (_2570 * -0.20676189661026f))) * 0.9944003820419312f;
          _2594 = abs(_2588) * 0.00793700572103262f;
          _2595 = abs(_2589) * 0.00793700572103262f;
          _2596 = abs(_2590) * 0.00793700572103262f;
          if (!(_2594 < 0.0f)) {
            _2603 = (pow(_2594, 0.41999998688697815f));
          } else {
            _2603 = 0.0f;
          }
          if (!(_2595 < 0.0f)) {
            _2610 = (pow(_2595, 0.41999998688697815f));
          } else {
            _2610 = 0.0f;
          }
          if (!(_2596 < 0.0f)) {
            _2617 = (pow(_2596, 0.41999998688697815f));
          } else {
            _2617 = 0.0f;
          }
          _2645 = ((float((int)(((int)(uint)((int)(_2588 > 0.0f))) - ((int)(uint)((int)(_2588 < 0.0f))))) * 400.0f) * _2603) / (_2603 + 27.1299991607666f);
          _2646 = ((float((int)(((int)(uint)((int)(_2589 > 0.0f))) - ((int)(uint)((int)(_2589 < 0.0f))))) * 400.0f) * _2610) / (_2610 + 27.1299991607666f);
          _2647 = ((float((int)(((int)(uint)((int)(_2590 > 0.0f))) - ((int)(uint)((int)(_2590 < 0.0f))))) * 400.0f) * _2617) / (_2617 + 27.1299991607666f);
          _2651 = (_2645 - (_2646 * 1.0909091234207153f)) + (_2647 * 0.09090909361839294f);
          _2655 = ((_2646 + _2645) - (_2647 * 2.0f)) * 0.1111111119389534f;
          _2657 = atan(_2655 / _2651);
          _2660 = (_2651 < 0.0f);
          _2661 = (_2651 == 0.0f);
          _2662 = (_2655 >= 0.0f);
          _2663 = (_2655 < 0.0f);
          _2672 = select((_2661 && _2662), 0.25f, select((_2661 && _2663), -0.25f, (select((_2660 && _2663), (_2657 + -3.1415927410125732f), select((_2660 && _2662), (_2657 + 3.1415927410125732f), _2657)) * 0.15915493667125702f)));
          _2676 = frac(abs(_2672));
          _2679 = select((_2672 >= (-0.0f - _2672)), _2676, (-0.0f - _2676)) * 360.0f;
          _2682 = select((_2679 < 0.0f), (_2679 + 360.0f), _2679);
          _2691 = exp2(log2((((_2645 * 2.0f) + _2646) + (_2647 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
          if (!(_2691 == 0.0f)) {
            _2700 = (sqrt((_2655 * _2655) + (_2651 * _2651)) * 38.70000076293945f);
          } else {
            _2700 = 0.0f;
          }
          _2705 = exp2(log2(abs(_2691) * 0.009999999776482582f) * 0.8794641494750977f);
          _2720 = (float((int)(((int)(uint)((int)(_2691 > 0.0f))) - ((int)(uint)((int)(_2691 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_2705 * 351.2578430175781f) / (400.0f - (_2705 * 12.947211265563965f))) * 2.3809523582458496f);
          _2722 = (_2493 * 115.59551239013672f) + 128.0f;
          _2726 = sqrt((_2492 + 0.1599999964237213f) * _2492) + _2492;
          _2727 = _2726 * 0.5f;
          _2728 = _2722 / _2727;
          _2735 = _2493 * 0.014018198475241661f;
          _2736 = _2735 + 0.10012999176979065f;
          _2746 = exp2(log2((((_2736 + sqrt(_2736 * (_2735 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_2722 / (_2727 * (_2728 + 1.0f))) * 1.149999976158142f)) / _2727) * 0.8695652484893799f);
          _2751 = 0.18000000715255737f / (((_2726 * -0.5f) * _2746) / (_2746 + -1.0f));
          _2766 = exp2(log2(max(0.0f, _2720) / ((_2751 * _2727) + _2720)) * 1.149999976158142f) * (_2727 / exp2(log2(_2722 / ((_2728 + _2751) * _2727)) * 1.149999976158142f));
          _2771 = max(0.0f, ((_2766 * _2766) / (_2766 + 0.03999999910593033f))) * 100.0f;
          _2776 = exp2(log2(abs(_2771) * 0.00793700572103262f) * 0.41999998688697815f);
          _2791 = (float((int)(((int)(uint)((int)(_2771 > 0.0f))) - ((int)(uint)((int)(_2771 < 0.0f))))) * 100.0f) * exp2(log2(((_2776 * 400.0f) / (_2776 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2793 = _2682 * 0.0027777778450399637f;
          _2794 = -0.0f - _2793;
          _2796 = frac(abs(_2793));
          _2797 = -0.0f - _2796;
          if (!(_2700 == 0.0f)) {
            _2799 = _2791 / _2513;
            _2801 = max(0.0f, (1.0f - _2799));
            _2802 = _2682 * 0.01745329424738884f;
            _2803 = cos(_2802);
            _2804 = sin(_2802);
            _2805 = _2803 * _2803;
            _2806 = _2804 * _2804;
            _2821 = ((((77.12895965576172f - ((_2803 * 12.74448013305664f) * _2804)) + ((_2805 - _2806) * 16.468990325927734f)) + (((_2805 * 31.535200119018555f) + -12.31067943572998f) * _2803)) + ((42.245330810546875f - (_2806 * 36.774559020996094f)) * _2804)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
            _2827 = select((_2793 >= _2794), _2796, _2797) * 360.0f;
            _2831 = int(select((_2827 < 0.0f), (_2827 + 360.0f), _2827));
            _2833 = (_2831 + 1) % 360;
            _2842 = t3.Load(int3(_2831, 0, 0));
            _2847 = (((((t3.Load(int3(_2833, 0, 0))).x) - _2842.x) * ((_2682 - float((int)(_2831))) / float((int)(_2833 - _2831)))) + _2842.x) * (pow(_2799, 0.8794641494750977f));
            _2848 = _2847 / _2821;
            _2849 = _2848 + -0.0010000000474974513f;
            _2850 = _2801 * max(0.20000000298023224f, (1.2999999523162842f - (_2493 * 0.270023912191391f)));
            _2851 = _2799 * ((_2493 * 2.384157657623291f) + 2.4000000953674316f);
            _2858 = (_2847 - (exp2(log2(_2791 / _2691) * 0.8794641494750977f) * _2700)) / _2821;
            if (!(_2858 > _2849)) {
              _2864 = max(sqrt((_2799 * _2799) + (0.5f / cb0_043y)), 0.0010000000474974513f);
              _2868 = sqrt((_2864 * _2864) + (_2850 * _2850));
              _2871 = (_2868 + _2849) / (_2864 + _2849);
              _2873 = (_2871 * _2858) - _2868;
              _2883 = ((_2873 + sqrt((_2873 * _2873) + (((_2858 * 4.0f) * _2864) * _2871))) * 0.5f);
            } else {
              _2883 = _2858;
            }
            _2884 = _2848 - _2883;
            if (!(_2884 > _2848)) {
              _2887 = max(_2801, 0.0010000000474974513f);
              _2891 = sqrt((_2887 * _2887) + (_2851 * _2851));
              _2894 = (_2891 + _2848) / (_2887 + _2848);
              _2896 = (_2894 * _2884) - _2891;
              _2906 = ((_2896 + sqrt((_2896 * _2896) + (((_2884 * 4.0f) * _2887) * _2894))) * 0.5f);
            } else {
              _2906 = _2884;
            }
            _2909 = (_2906 * _2821);
          } else {
            _2909 = _2700;
          }
          _2912 = select((_2793 >= _2794), _2796, _2797) * 360.0f;
          _2915 = select((_2912 < 0.0f), (_2912 + 360.0f), _2912);
          _2916 = int(_2915);
          _2917 = _2916 + 1;
          _2919 = 0;
          _2920 = 361;
          _2921 = _2917;
          while(true) {
            _2925 = (_2682 > (((float3)(t4.Load(int3(_2921, 0, 0)))).z));
            _2926 = select(_2925, _2921, _2919);
            _2927 = select(_2925, _2920, _2921);
            if ((int)(_2926 + 1) < (int)_2927) {
              _2919 = _2926;
              _2920 = _2927;
              _2921 = ((_2926 + _2927) / 2);
              continue;
            }
            _2934 = t4.Load(int3((_2927 + -1), 0, 0));
            _2938 = t4.Load(int3(_2927, 0, 0));
            _2944 = (_2682 - _2934.z) / (_2938.z - _2934.z);
            _2947 = ((_2938.x - _2934.x) * _2944) + _2934.x;
            if (!((_2791 > _2513) || (_2909 < 9.999999747378752e-05f))) {
              _2961 = (min(1.0f, (1.2999999523162842f - (_2947 / _2513))) * (((float((int)(((int)(uint)((int)(_2515 > 0.0f))) - ((int)(uint)((int)(_2515 < 0.0f))))) * 100.0f) * exp2(log2(((_2520 * 400.0f) / (_2520 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _2947)) + _2947;
              _2962 = ((_2493 * 0.7111833691596985f) + 1.350000023841858f) * _2513;
              _2963 = _2513 - _2947;
              _2965 = (_2963 * 0.30000001192092896f) + _2947;
              if (_2791 > _2965) {
                _2979 = (exp2(log2(log2((_2513 - _2965) / max(9.999999747378752e-05f, (_2513 - _2791))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _2979 = 1.0f;
              }
              _2980 = _2962 * _2979;
              t5.GetDimensions(_2982.x, _2982.y);
              _2986 = float((int)(_2916));
              _2990 = t5.Load(int3(_2917, 0, 0));
              _2995 = (lerp(_2934.y, _2938.y, _2944)) * 1.0324000120162964f;
              _2996 = _2980 * _2961;
              _2998 = (_2791 < _2961);
              _2999 = _2909 / _2980;
              if (_2998) {
                _3009 = (1.0f - _2999);
              } else {
                _3009 = (-0.0f - ((_2999 + 1.0f) + ((_2909 * _2513) / _2996)));
              }
              if (_2998) {
                _3017 = (-0.0f - _2791);
              } else {
                _3017 = (((_2909 * _2513) / _2980) + _2791);
              }
              _3022 = sqrt((_3009 * _3009) - (((_2909 / _2996) * 4.0f) * _3017));
              _3028 = (_3017 * 2.0f) / select(_2998, ((-0.0f - _3009) - _3022), (_3022 - _3009));
              _3030 = (_2947 < _2961);
              _3031 = _2995 / _2980;
              if (_3030) {
                _3041 = (1.0f - _3031);
              } else {
                _3041 = (-0.0f - ((_3031 + 1.0f) + ((_2995 * _2513) / _2996)));
              }
              if (!_3030) {
                _3047 = (((_2995 * _2513) / _2980) + _2947);
              } else {
                _3047 = (-0.0f - _2947);
              }
              _3052 = sqrt((_3041 * _3041) - (((_2995 / _2996) * 4.0f) * _3047));
              _3058 = (_3047 * 2.0f) / select(_3030, ((-0.0f - _3041) - _3052), (_3052 - _3041));
              _3060 = _2513 - _3028;
              _3064 = ((_3028 - _2961) * select((_3028 < _2961), _3028, _3060)) / _2996;
              _3073 = _2513 - _3058;
              _3084 = ((_3073 * _2995) * exp2(log2(_3060 / _3073) * (1.0f / (((((t5.Load(int3(((_2916 + 2) % (int)(_2982.x)), 0, 0))).x) - _2990.x) * (_2915 - _2986)) + _2990.x)))) / ((_2963 + (_3064 * _2995)) * _2995);
              _3086 = (exp2(log2(_3028 / _3058) * (1.0f / ((_2493 * 0.02107210084795952f) + 1.1399999856948853f))) * _3058) / (((_2947 / _2995) - _3064) * _2995);
              _3090 = max((0.11999999731779099f - abs(_3086 - _3084)), 0.0f);
              _3091 = _3090 * 8.333333969116211f;
              _3097 = (min(_3086, _3084) - ((_3091 * _3091) * (_3090 * 0.1666666716337204f))) * _2995;
              _3098 = _3097 * _3064;
              _3099 = _3098 + _3028;
              _3100 = _2917 % 360;
              _3108 = t3.Load(int3(_2916, 0, 0));
              _3112 = ((((t3.Load(int3(_3100, 0, 0))).x) - _3108.x) * ((_2682 - _2986) / float((int)(_3100 - _2916)))) + _3108.x;
              if (_3099 > _2965) {
                _3126 = (exp2(log2(log2((_2513 - _2965) / max(9.999999747378752e-05f, (_2513 - _3099))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _3126 = 1.0f;
              }
              _3127 = _2962 * _3126;
              _3128 = _3127 * _2961;
              _3130 = (_3099 < _2961);
              _3131 = _3097 / _3127;
              if (_3130) {
                _3141 = (1.0f - _3131);
              } else {
                _3141 = (-0.0f - ((_3131 + 1.0f) + ((_3097 * _2513) / _3128)));
              }
              if (_3130) {
                _3149 = (-0.0f - _3099);
              } else {
                _3149 = (((_3097 * _2513) / _3127) + _3099);
              }
              _3154 = sqrt((_3141 * _3141) - (((_3097 / _3128) * 4.0f) * _3149));
              _3160 = (_3149 * 2.0f) / select(_3130, ((-0.0f - _3141) - _3154), (_3154 - _3141));
              _3177 = max(1.000100016593933f, (((_3112 * _2513) * exp2(log2(_3160 / _2513) * 0.8794641494750977f)) / ((_2513 - ((((_3160 - _2961) * select((_3160 < _2961), _3160, (_2513 - _3160))) / _3128) * _3112)) * _3097)));
              _3179 = max(0.75f, (1.0f / _3177));
              _3180 = _2909 / _3097;
              _3185 = ((_3177 - _3179) * (1.0f - _3179)) / (_3177 + -1.0f);
              _3187 = (_3180 - _3179) / _3185;
              if (!((_3177 <= 1.000100016593933f) || (_3180 < _3179))) {
                _3197 = (((_3187 * _3185) / (_3187 + 1.0f)) + _3179);
              } else {
                _3197 = _3180;
              }
              _3203 = ((_3197 * _3098) + _3028);
              _3204 = ((_3097 * _3197) * 0.0258397925645113f);
            } else {
              _3203 = _2791;
              _3204 = 0.0f;
            }
            _3205 = _2682 * 0.01745329424738884f;
            _3206 = _3203 * 0.009999999776482582f;
            if (!(_3206 < 0.0f)) {
              _3215 = (((pow(_3206, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
            } else {
              _3215 = 0.0f;
            }
            _3217 = cos(_3205) * _3204;
            _3219 = sin(_3205) * _3204;
            _3226 = mad(288.0f, _3219, mad(451.0f, _3217, _3215)) * 0.0007127583958208561f;
            _3227 = mad(-261.0f, _3219, mad(-891.0f, _3217, _3215)) * 0.0007127583958208561f;
            _3228 = mad(-6300.0f, _3219, mad(-220.0f, _3217, _3215)) * 0.0007127583958208561f;
            _3248 = abs(_3226);
            _3249 = abs(_3227);
            _3250 = abs(_3228);
            _3257 = (_3248 * 27.1299991607666f) / (400.0f - _3248);
            _3258 = (_3249 * 27.1299991607666f) / (400.0f - _3249);
            _3259 = (_3250 * 27.1299991607666f) / (400.0f - _3250);
            if (!(_3257 < 0.0f)) {
              _3266 = (pow(_3257, 2.3809523582458496f));
            } else {
              _3266 = 0.0f;
            }
            if (!(_3258 < 0.0f)) {
              _3273 = (pow(_3258, 2.3809523582458496f));
            } else {
              _3273 = 0.0f;
            }
            if (!(_3259 < 0.0f)) {
              _3280 = (pow(_3259, 2.3809523582458496f));
            } else {
              _3280 = 0.0f;
            }
            _3281 = (float((int)(((int)(uint)((int)(_3226 > 0.0f))) - ((int)(uint)((int)(_3226 < 0.0f))))) * 125.99209594726562f) * _3266;
            _3283 = (float((int)(((int)(uint)((int)(_3227 > 0.0f))) - ((int)(uint)((int)(_3227 < 0.0f))))) * 127.42658996582031f) * _3273;
            _3285 = (float((int)(((int)(uint)((int)(_3228 > 0.0f))) - ((int)(uint)((int)(_3228 < 0.0f))))) * 126.70159912109375f) * _3280;
            _3288 = mad(0.08875565975904465f, _3285, mad(-1.140031337738037f, _3283, (_3281 * 2.016401767730713f)));
            _3295 = mad(-0.12752249836921692f, _3285, mad(0.7005835175514221f, _3283, (_3281 * 0.41968056559562683f))) * 0.009999999776482582f;
            _3296 = mad(1.0589468479156494f, _3285, mad(-0.03847259283065796f, _3283, (_3281 * -0.01717424765229225f))) * 0.009999999776482582f;
            _3309 = min(max(mad(-0.23642469942569733f, _3296, mad(-0.32480329275131226f, _3295, (_3288 * 0.016410233452916145f))), 0.0f), _2492);
            _3310 = min(max(mad(0.016756348311901093f, _3296, mad(1.6153316497802734f, _3295, (_3288 * -0.006636628415435553f))), 0.0f), _2492);
            _3311 = min(max(mad(0.9883948564529419f, _3296, mad(-0.008284442126750946f, _3295, (_3288 * 0.00011721893679350615f))), 0.0f), _2492);
            _3314 = mad(0.15618768334388733f, _3311, mad(0.13400420546531677f, _3310, (_3309 * 0.6624541878700256f)));
            _3317 = mad(0.053689517080783844f, _3311, mad(0.6740817427635193f, _3310, (_3309 * 0.2722287178039551f)));
            _3320 = mad(1.0103391408920288f, _3311, mad(0.00406073359772563f, _3310, (_3309 * -0.005574649665504694f)));
            _3323 = mad(-0.23642469942569733f, _3320, mad(-0.32480329275131226f, _3317, (_3314 * 1.6410233974456787f)));
            _3330 = mad(0.016756348311901093f, _3320, mad(1.6153316497802734f, _3317, (_3314 * -0.663662850856781f))) * 1.25f;
            _3331 = mad(0.9883948564529419f, _3320, mad(-0.008284442126750946f, _3317, (_3314 * 0.011721894145011902f))) * 1.25f;
            _3478 = mad(-0.0832589864730835f, _3331, mad(-0.6217921376228333f, _3330, (_3323 * 2.1313138008117676f)));
            _3479 = mad(-0.010548308491706848f, _3331, mad(1.140804648399353f, _3330, (_3323 * -0.16282059252262115f)));
            _3480 = mad(1.1529725790023804f, _3331, mad(-0.1289689838886261f, _3330, (_3323 * -0.030004188418388367f)));
            break;
          }
        } else {
          if (cb0_042w == 7) {
            _3358 = mad((WorkingColorSpace_128[0].z), _1394, mad((WorkingColorSpace_128[0].y), _1393, ((WorkingColorSpace_128[0].x) * _1392)));
            _3361 = mad((WorkingColorSpace_128[1].z), _1394, mad((WorkingColorSpace_128[1].y), _1393, ((WorkingColorSpace_128[1].x) * _1392)));
            _3364 = mad((WorkingColorSpace_128[2].z), _1394, mad((WorkingColorSpace_128[2].y), _1393, ((WorkingColorSpace_128[2].x) * _1392)));
            _3383 = exp2(log2(mad(_60, _3364, mad(_59, _3361, (_3358 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3384 = exp2(log2(mad(_63, _3364, mad(_62, _3361, (_3358 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3385 = exp2(log2(mad(_66, _3364, mad(_65, _3361, (_3358 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3478 = exp2(log2((1.0f / ((_3383 * 18.6875f) + 1.0f)) * ((_3383 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3479 = exp2(log2((1.0f / ((_3384 * 18.6875f) + 1.0f)) * ((_3384 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3480 = exp2(log2((1.0f / ((_3385 * 18.6875f) + 1.0f)) * ((_3385 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _3432 = mad((WorkingColorSpace_128[0].z), _1382, mad((WorkingColorSpace_128[0].y), _1381, ((WorkingColorSpace_128[0].x) * _1380)));
                _3435 = mad((WorkingColorSpace_128[1].z), _1382, mad((WorkingColorSpace_128[1].y), _1381, ((WorkingColorSpace_128[1].x) * _1380)));
                _3438 = mad((WorkingColorSpace_128[2].z), _1382, mad((WorkingColorSpace_128[2].y), _1381, ((WorkingColorSpace_128[2].x) * _1380)));
                _3478 = mad(_60, _3438, mad(_59, _3435, (_3432 * _58)));
                _3479 = mad(_63, _3438, mad(_62, _3435, (_3432 * _61)));
                _3480 = mad(_66, _3438, mad(_65, _3435, (_3432 * _64)));
              } else {
                _3451 = mad((WorkingColorSpace_128[0].z), _1408, mad((WorkingColorSpace_128[0].y), _1407, ((WorkingColorSpace_128[0].x) * _1406)));
                _3454 = mad((WorkingColorSpace_128[1].z), _1408, mad((WorkingColorSpace_128[1].y), _1407, ((WorkingColorSpace_128[1].x) * _1406)));
                _3457 = mad((WorkingColorSpace_128[2].z), _1408, mad((WorkingColorSpace_128[2].y), _1407, ((WorkingColorSpace_128[2].x) * _1406)));
                _3478 = exp2(log2(mad(_60, _3457, mad(_59, _3454, (_3451 * _58)))) * cb0_042z);
                _3479 = exp2(log2(mad(_63, _3457, mad(_62, _3454, (_3451 * _61)))) * cb0_042z);
                _3480 = exp2(log2(mad(_66, _3457, mad(_65, _3454, (_3451 * _64)))) * cb0_042z);
              }
            } else {
              _3478 = _1392;
              _3479 = _1393;
              _3480 = _1394;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_3478 * 0.9523810148239136f), (_3479 * 0.9523810148239136f), (_3480 * 0.9523810148239136f), 0.0f);
}
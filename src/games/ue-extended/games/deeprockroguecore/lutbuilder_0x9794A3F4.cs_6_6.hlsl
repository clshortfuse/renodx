// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float> t2 : register(t2);

Texture2D<float3> t3 : register(t3);

Texture2D<float> t4 : register(t4);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
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
  float _27;
  float _32;
  float _33;
  float _34;
  float _36;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _122;
  float _123;
  float _124;
  float _179;
  float _386;
  float _387;
  float _388;
  float _911;
  float _944;
  float _958;
  float _1022;
  float _1201;
  float _1212;
  float _1223;
  float _1420;
  float _1421;
  float _1422;
  float _1433;
  float _1444;
  float _1654;
  float _1661;
  float _1668;
  float _1751;
  float _1934;
  float _1957;
  float _1960;
  int _1970;
  int _1971;
  int _1972;
  float _2030;
  float _2060;
  float _2068;
  float _2092;
  float _2098;
  float _2177;
  float _2192;
  float _2200;
  float _2248;
  float _2254;
  float _2255;
  float _2266;
  float _2317;
  float _2324;
  float _2331;
  float _2575;
  float _2582;
  float _2589;
  float _2672;
  float _2855;
  float _2878;
  float _2881;
  int _2891;
  int _2892;
  int _2893;
  float _2951;
  float _2981;
  float _2989;
  float _3013;
  float _3019;
  float _3098;
  float _3113;
  float _3121;
  float _3169;
  float _3175;
  float _3176;
  float _3187;
  float _3238;
  float _3245;
  float _3252;
  float _3450;
  float _3451;
  float _3452;
  bool _45;
  float _75;
  float _76;
  float _77;
  bool _160;
  float _162;
  float _193;
  float _200;
  float _203;
  float _208;
  float _209;
  float _211;
  bool _212;
  float _221;
  float _223;
  float _230;
  float _232;
  float _234;
  float _235;
  float _238;
  float _241;
  float _246;
  float _252;
  float _253;
  float _254;
  float _255;
  float _256;
  float _257;
  float _258;
  float _259;
  float _262;
  float _263;
  float _264;
  float _267;
  float _286;
  float _287;
  float _288;
  float _289;
  float _290;
  float _291;
  float _292;
  float _293;
  float _294;
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
  float _403;
  float _406;
  float _409;
  float _410;
  float _414;
  float _415;
  float _416;
  float _428;
  float _444;
  float _445;
  float _446;
  float _447;
  float _461;
  float _475;
  float _489;
  float _503;
  float _517;
  float _521;
  float _522;
  float _523;
  float _580;
  float _584;
  float _585;
  float _594;
  float _603;
  float _612;
  float _621;
  float _630;
  float _693;
  float _697;
  float _706;
  float _715;
  float _724;
  float _733;
  float _742;
  float _800;
  float _811;
  float _813;
  float _815;
  float _851;
  float _852;
  float _853;
  float _856;
  float _859;
  float _862;
  float _866;
  float _871;
  float _884;
  float _885;
  float _886;
  float _887;
  float _891;
  float _902;
  float _912;
  float _913;
  float _914;
  float _915;
  float _922;
  float _925;
  float _927;
  bool _930;
  bool _931;
  bool _932;
  bool _933;
  float _949;
  float _962;
  float _966;
  float _972;
  float _982;
  float _983;
  float _984;
  float _985;
  float _1000;
  float _1002;
  float _1004;
  float _1013;
  float _1025;
  float _1027;
  float _1031;
  float _1032;
  float _1033;
  float _1037;
  float _1038;
  float _1039;
  float _1040;
  float _1042;
  float _1043;
  float _1044;
  float _1045;
  float _1064;
  float _1066;
  float _1091;
  float _1092;
  float _1093;
  float _1100;
  float _1104;
  float _1105;
  float _1106;
  bool _1107;
  float _1111;
  float _1112;
  float _1113;
  float _1132;
  float _1133;
  float _1134;
  float _1135;
  float _1155;
  float _1156;
  float _1157;
  float _1173;
  float _1174;
  float _1175;
  float _1188;
  float _1189;
  float _1190;
  float _1227;
  float _1234;
  float _1235;
  float _1236;
  float _1238;
  float4 _1241;
  float _1245;
  float4 _1246;
  float4 _1268;
  float4 _1272;
  float _1288;
  float _1289;
  float _1290;
  float _1315;
  float _1316;
  float _1317;
  float _1343;
  float _1344;
  float _1345;
  float _1352;
  float _1353;
  float _1354;
  float _1355;
  float _1356;
  float _1357;
  float _1364;
  float _1365;
  float _1366;
  float _1378;
  float _1379;
  float _1380;
  float _1403;
  float _1406;
  float _1409;
  float _1471;
  float _1474;
  float _1477;
  float _1480;
  float _1483;
  float _1486;
  float _1531;
  float _1532;
  float _1533;
  float _1536;
  float _1539;
  float _1542;
  float _1543;
  float _1544;
  float _1549;
  float _1564;
  float _1566;
  float _1571;
  float _1612;
  float _1616;
  float _1617;
  float _1618;
  float _1621;
  float _1628;
  float _1629;
  float _1639;
  float _1640;
  float _1641;
  float _1645;
  float _1646;
  float _1647;
  float _1696;
  float _1697;
  float _1698;
  float _1702;
  float _1706;
  float _1708;
  bool _1711;
  bool _1712;
  bool _1713;
  bool _1714;
  float _1723;
  float _1727;
  float _1730;
  float _1733;
  float _1742;
  float _1756;
  float _1771;
  float _1773;
  float _1777;
  float _1778;
  float _1779;
  float _1786;
  float _1787;
  float _1797;
  float _1802;
  float _1817;
  float _1822;
  float _1827;
  float _1842;
  float _1844;
  float _1845;
  float _1847;
  float _1848;
  float _1850;
  float _1852;
  float _1853;
  float _1854;
  float _1855;
  float _1856;
  float _1857;
  float _1872;
  float _1878;
  int _1882;
  int _1884;
  float _1893;
  float _1898;
  float _1899;
  float _1900;
  float _1901;
  float _1902;
  float _1909;
  float _1915;
  float _1919;
  float _1922;
  float _1924;
  float _1935;
  float _1938;
  float _1942;
  float _1945;
  float _1947;
  float _1963;
  float _1966;
  int _1967;
  int _1968;
  bool _1976;
  int _1977;
  int _1978;
  float3 _1985;
  float3 _1989;
  float _1995;
  float _1998;
  float _2012;
  float _2013;
  float _2014;
  float _2016;
  float _2031;
  uint2 _2033;
  float _2037;
  float _2041;
  float _2046;
  float _2047;
  bool _2049;
  float _2050;
  float _2073;
  float _2079;
  bool _2081;
  float _2082;
  float _2103;
  float _2109;
  float _2111;
  float _2115;
  float _2124;
  float _2135;
  float _2137;
  float _2141;
  float _2142;
  float _2148;
  float _2149;
  float _2150;
  int _2151;
  float _2159;
  float _2163;
  float _2178;
  float _2179;
  bool _2181;
  float _2182;
  float _2205;
  float _2211;
  float _2228;
  float _2230;
  float _2231;
  float _2236;
  float _2238;
  float _2256;
  float _2257;
  float _2268;
  float _2270;
  float _2277;
  float _2278;
  float _2279;
  float _2299;
  float _2300;
  float _2301;
  float _2308;
  float _2309;
  float _2310;
  float _2332;
  float _2334;
  float _2336;
  float _2339;
  float _2346;
  float _2347;
  float _2360;
  float _2361;
  float _2362;
  float _2365;
  float _2368;
  float _2371;
  float _2381;
  float _2382;
  float _2383;
  float _2402;
  float _2403;
  float _2404;
  float _2452;
  float _2453;
  float _2454;
  float _2457;
  float _2460;
  float _2463;
  float _2464;
  float _2465;
  float _2470;
  float _2485;
  float _2487;
  float _2492;
  float _2533;
  float _2537;
  float _2538;
  float _2539;
  float _2542;
  float _2549;
  float _2550;
  float _2560;
  float _2561;
  float _2562;
  float _2566;
  float _2567;
  float _2568;
  float _2617;
  float _2618;
  float _2619;
  float _2623;
  float _2627;
  float _2629;
  bool _2632;
  bool _2633;
  bool _2634;
  bool _2635;
  float _2644;
  float _2648;
  float _2651;
  float _2654;
  float _2663;
  float _2677;
  float _2692;
  float _2694;
  float _2698;
  float _2699;
  float _2700;
  float _2707;
  float _2708;
  float _2718;
  float _2723;
  float _2738;
  float _2743;
  float _2748;
  float _2763;
  float _2765;
  float _2766;
  float _2768;
  float _2769;
  float _2771;
  float _2773;
  float _2774;
  float _2775;
  float _2776;
  float _2777;
  float _2778;
  float _2793;
  float _2799;
  int _2803;
  int _2805;
  float _2814;
  float _2819;
  float _2820;
  float _2821;
  float _2822;
  float _2823;
  float _2830;
  float _2836;
  float _2840;
  float _2843;
  float _2845;
  float _2856;
  float _2859;
  float _2863;
  float _2866;
  float _2868;
  float _2884;
  float _2887;
  int _2888;
  int _2889;
  bool _2897;
  int _2898;
  int _2899;
  float3 _2906;
  float3 _2910;
  float _2916;
  float _2919;
  float _2933;
  float _2934;
  float _2935;
  float _2937;
  float _2952;
  uint2 _2954;
  float _2958;
  float _2962;
  float _2967;
  float _2968;
  bool _2970;
  float _2971;
  float _2994;
  float _3000;
  bool _3002;
  float _3003;
  float _3024;
  float _3030;
  float _3032;
  float _3036;
  float _3045;
  float _3056;
  float _3058;
  float _3062;
  float _3063;
  float _3069;
  float _3070;
  float _3071;
  int _3072;
  float _3080;
  float _3084;
  float _3099;
  float _3100;
  bool _3102;
  float _3103;
  float _3126;
  float _3132;
  float _3149;
  float _3151;
  float _3152;
  float _3157;
  float _3159;
  float _3177;
  float _3178;
  float _3189;
  float _3191;
  float _3198;
  float _3199;
  float _3200;
  float _3220;
  float _3221;
  float _3222;
  float _3229;
  float _3230;
  float _3231;
  float _3253;
  float _3255;
  float _3257;
  float _3260;
  float _3267;
  float _3268;
  float _3281;
  float _3282;
  float _3283;
  float _3286;
  float _3289;
  float _3292;
  float _3295;
  float _3302;
  float _3303;
  float _3330;
  float _3333;
  float _3336;
  float _3355;
  float _3356;
  float _3357;
  float _3404;
  float _3407;
  float _3410;
  float _3423;
  float _3426;
  float _3429;
  _27 = 0.5f / cb0_037x;
  _32 = cb0_037x + -1.0f;
  _33 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _27)) / _32;
  _34 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _27)) / _32;
  _36 = float((uint)SV_DispatchThreadID.z) / _32;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _45 = (cb0_043x == 4);
        _56 = select(_45, 1.0f, 1.705051064491272f);
        _57 = select(_45, 0.0f, -0.6217921376228333f);
        _58 = select(_45, 0.0f, -0.0832589864730835f);
        _59 = select(_45, 0.0f, -0.13025647401809692f);
        _60 = select(_45, 1.0f, 1.140804648399353f);
        _61 = select(_45, 0.0f, -0.010548308491706848f);
        _62 = select(_45, 0.0f, -0.024003351107239723f);
        _63 = select(_45, 0.0f, -0.1289689838886261f);
        _64 = select(_45, 1.0f, 1.1529725790023804f);
      } else {
        _56 = 0.6954522132873535f;
        _57 = 0.14067870378494263f;
        _58 = 0.16386906802654266f;
        _59 = 0.044794563204050064f;
        _60 = 0.8596711158752441f;
        _61 = 0.0955343171954155f;
        _62 = -0.005525882821530104f;
        _63 = 0.004025210160762072f;
        _64 = 1.0015007257461548f;
      }
    } else {
      _56 = 1.0258246660232544f;
      _57 = -0.020053181797266006f;
      _58 = -0.005771636962890625f;
      _59 = -0.002234415616840124f;
      _60 = 1.0045864582061768f;
      _61 = -0.002352118492126465f;
      _62 = -0.005013350863009691f;
      _63 = -0.025290070101618767f;
      _64 = 1.0303035974502563f;
    }
  } else {
    _56 = 1.3792141675949097f;
    _57 = -0.30886411666870117f;
    _58 = -0.0703500509262085f;
    _59 = -0.06933490186929703f;
    _60 = 1.08229660987854f;
    _61 = -0.012961871922016144f;
    _62 = -0.0021590073592960835f;
    _63 = -0.0454593189060688f;
    _64 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _75 = (pow(_33, 0.012683313339948654f));
    _76 = (pow(_34, 0.012683313339948654f));
    _77 = (pow(_36, 0.012683313339948654f));
    _122 = (exp2(log2(max(0.0f, (_75 + -0.8359375f)) / (18.8515625f - (_75 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _123 = (exp2(log2(max(0.0f, (_76 + -0.8359375f)) / (18.8515625f - (_76 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _124 = (exp2(log2(max(0.0f, (_77 + -0.8359375f)) / (18.8515625f - (_77 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _122 = ((exp2((_33 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _123 = ((exp2((_34 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _124 = ((exp2((_36 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _160 = (cb0_040w != 0);
    _162 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _179 = (((((1901800.0f - (_162 * 2006400000.0f)) * _162) + 247.47999572753906f) * _162) + 0.23703999817371368f);
    } else {
      _179 = (((((2967800.0f - (_162 * 4607000064.0f)) * _162) + 99.11000061035156f) * _162) + 0.24406300485134125f);
    }
    _193 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _200 = cb0_037y * cb0_037y;
    _203 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_200 * 1.6145605741257896e-07f));
    _208 = ((_193 * 2.0f) + 4.0f) - (_203 * 8.0f);
    _209 = (_193 * 3.0f) / _208;
    _211 = (_203 * 2.0f) / _208;
    _212 = (cb0_037y < 4000.0f);
    _221 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _223 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_200 * 1.5317699909210205f)) / (_221 * _221);
    _230 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _200;
    _232 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_200 * 308.60699462890625f)) / (_230 * _230);
    _234 = rsqrt(dot(float2(_223, _232), float2(_223, _232)));
    _235 = cb0_037z * 0.05000000074505806f;
    _238 = ((_235 * _232) * _234) + _193;
    _241 = _203 - ((_235 * _223) * _234);
    _246 = (4.0f - (_241 * 8.0f)) + (_238 * 2.0f);
    _252 = (((_238 * 3.0f) / _246) - _209) + select(_212, _209, _179);
    _253 = (((_241 * 2.0f) / _246) - _211) + select(_212, _211, (((_179 * 2.869999885559082f) + -0.2750000059604645f) - ((_179 * _179) * 3.0f)));
    _254 = select(_160, _252, 0.3127000033855438f);
    _255 = select(_160, _253, 0.32899999618530273f);
    _256 = select(_160, 0.3127000033855438f, _252);
    _257 = select(_160, 0.32899999618530273f, _253);
    _258 = max(_255, 1.000000013351432e-10f);
    _259 = _254 / _258;
    _262 = ((1.0f - _254) - _255) / _258;
    _263 = max(_257, 1.000000013351432e-10f);
    _264 = _256 / _263;
    _267 = ((1.0f - _256) - _257) / _263;
    _286 = mad(-0.16140000522136688f, _267, ((_264 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _262, ((_259 * 0.8950999975204468f) + 0.266400009393692f));
    _287 = mad(0.03669999912381172f, _267, (1.7135000228881836f - (_264 * 0.7501999735832214f))) / mad(0.03669999912381172f, _262, (1.7135000228881836f - (_259 * 0.7501999735832214f)));
    _288 = mad(1.0296000242233276f, _267, ((_264 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _262, ((_259 * 0.03889999911189079f) + -0.06849999725818634f));
    _289 = mad(_287, -0.7501999735832214f, 0.0f);
    _290 = mad(_287, 1.7135000228881836f, 0.0f);
    _291 = mad(_287, 0.03669999912381172f, -0.0f);
    _292 = mad(_288, 0.03889999911189079f, 0.0f);
    _293 = mad(_288, -0.06849999725818634f, 0.0f);
    _294 = mad(_288, 1.0296000242233276f, 0.0f);
    _297 = mad(0.1599626988172531f, _292, mad(-0.1470542997121811f, _289, (_286 * 0.883457362651825f)));
    _300 = mad(0.1599626988172531f, _293, mad(-0.1470542997121811f, _290, (_286 * 0.26293492317199707f)));
    _303 = mad(0.1599626988172531f, _294, mad(-0.1470542997121811f, _291, (_286 * -0.15930065512657166f)));
    _306 = mad(0.04929120093584061f, _292, mad(0.5183603167533875f, _289, (_286 * 0.38695648312568665f)));
    _309 = mad(0.04929120093584061f, _293, mad(0.5183603167533875f, _290, (_286 * 0.11516613513231277f)));
    _312 = mad(0.04929120093584061f, _294, mad(0.5183603167533875f, _291, (_286 * -0.0697740763425827f)));
    _315 = mad(0.9684867262840271f, _292, mad(0.04004279896616936f, _289, (_286 * -0.007634039502590895f)));
    _318 = mad(0.9684867262840271f, _293, mad(0.04004279896616936f, _290, (_286 * -0.0022720457054674625f)));
    _321 = mad(0.9684867262840271f, _294, mad(0.04004279896616936f, _291, (_286 * 0.0013765322510153055f)));
    _324 = mad(_303, (WorkingColorSpace_000[2].x), mad(_300, (WorkingColorSpace_000[1].x), (_297 * (WorkingColorSpace_000[0].x))));
    _327 = mad(_303, (WorkingColorSpace_000[2].y), mad(_300, (WorkingColorSpace_000[1].y), (_297 * (WorkingColorSpace_000[0].y))));
    _330 = mad(_303, (WorkingColorSpace_000[2].z), mad(_300, (WorkingColorSpace_000[1].z), (_297 * (WorkingColorSpace_000[0].z))));
    _333 = mad(_312, (WorkingColorSpace_000[2].x), mad(_309, (WorkingColorSpace_000[1].x), (_306 * (WorkingColorSpace_000[0].x))));
    _336 = mad(_312, (WorkingColorSpace_000[2].y), mad(_309, (WorkingColorSpace_000[1].y), (_306 * (WorkingColorSpace_000[0].y))));
    _339 = mad(_312, (WorkingColorSpace_000[2].z), mad(_309, (WorkingColorSpace_000[1].z), (_306 * (WorkingColorSpace_000[0].z))));
    _342 = mad(_321, (WorkingColorSpace_000[2].x), mad(_318, (WorkingColorSpace_000[1].x), (_315 * (WorkingColorSpace_000[0].x))));
    _345 = mad(_321, (WorkingColorSpace_000[2].y), mad(_318, (WorkingColorSpace_000[1].y), (_315 * (WorkingColorSpace_000[0].y))));
    _348 = mad(_321, (WorkingColorSpace_000[2].z), mad(_318, (WorkingColorSpace_000[1].z), (_315 * (WorkingColorSpace_000[0].z))));
    _386 = mad(mad((WorkingColorSpace_064[0].z), _348, mad((WorkingColorSpace_064[0].y), _339, (_330 * (WorkingColorSpace_064[0].x)))), _124, mad(mad((WorkingColorSpace_064[0].z), _345, mad((WorkingColorSpace_064[0].y), _336, (_327 * (WorkingColorSpace_064[0].x)))), _123, (mad((WorkingColorSpace_064[0].z), _342, mad((WorkingColorSpace_064[0].y), _333, (_324 * (WorkingColorSpace_064[0].x)))) * _122)));
    _387 = mad(mad((WorkingColorSpace_064[1].z), _348, mad((WorkingColorSpace_064[1].y), _339, (_330 * (WorkingColorSpace_064[1].x)))), _124, mad(mad((WorkingColorSpace_064[1].z), _345, mad((WorkingColorSpace_064[1].y), _336, (_327 * (WorkingColorSpace_064[1].x)))), _123, (mad((WorkingColorSpace_064[1].z), _342, mad((WorkingColorSpace_064[1].y), _333, (_324 * (WorkingColorSpace_064[1].x)))) * _122)));
    _388 = mad(mad((WorkingColorSpace_064[2].z), _348, mad((WorkingColorSpace_064[2].y), _339, (_330 * (WorkingColorSpace_064[2].x)))), _124, mad(mad((WorkingColorSpace_064[2].z), _345, mad((WorkingColorSpace_064[2].y), _336, (_327 * (WorkingColorSpace_064[2].x)))), _123, (mad((WorkingColorSpace_064[2].z), _342, mad((WorkingColorSpace_064[2].y), _333, (_324 * (WorkingColorSpace_064[2].x)))) * _122)));
  } else {
    _386 = _122;
    _387 = _123;
    _388 = _124;
  }
  _403 = mad((WorkingColorSpace_128[0].z), _388, mad((WorkingColorSpace_128[0].y), _387, ((WorkingColorSpace_128[0].x) * _386)));
  _406 = mad((WorkingColorSpace_128[1].z), _388, mad((WorkingColorSpace_128[1].y), _387, ((WorkingColorSpace_128[1].x) * _386)));
  _409 = mad((WorkingColorSpace_128[2].z), _388, mad((WorkingColorSpace_128[2].y), _387, ((WorkingColorSpace_128[2].x) * _386)));
  _410 = dot(float3(_403, _406, _409), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _414 = (_403 / _410) + -1.0f;
  _415 = (_406 / _410) + -1.0f;
  _416 = (_409 / _410) + -1.0f;
  _428 = (1.0f - exp2(((_410 * _410) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_414, _415, _416), float3(_414, _415, _416)) * -4.0f));
  _444 = ((mad(-0.06368321925401688f, _409, mad(-0.3292922377586365f, _406, (_403 * 1.3704125881195068f))) - _403) * _428) + _403;
  _445 = ((mad(-0.010861365124583244f, _409, mad(1.0970927476882935f, _406, (_403 * -0.08343357592821121f))) - _406) * _428) + _406;
  _446 = ((mad(1.2036951780319214f, _409, mad(-0.09862580895423889f, _406, (_403 * -0.02579331398010254f))) - _409) * _428) + _409;
  _447 = dot(float3(_444, _445, _446), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _461 = cb0_021w + cb0_026w;
  _475 = cb0_020w * cb0_025w;
  _489 = cb0_019w * cb0_024w;
  _503 = cb0_018w * cb0_023w;
  _517 = cb0_017w * cb0_022w;
  _521 = _444 - _447;
  _522 = _445 - _447;
  _523 = _446 - _447;
  _580 = saturate(_447 / cb0_037w);
  _584 = (_580 * _580) * (3.0f - (_580 * 2.0f));
  _585 = 1.0f - _584;
  _594 = cb0_021w + cb0_036w;
  _603 = cb0_020w * cb0_035w;
  _612 = cb0_019w * cb0_034w;
  _621 = cb0_018w * cb0_033w;
  _630 = cb0_017w * cb0_032w;
  _693 = saturate((_447 - cb0_038x) / (cb0_038y - cb0_038x));
  _697 = (_693 * _693) * (3.0f - (_693 * 2.0f));
  _706 = cb0_021w + cb0_031w;
  _715 = cb0_020w * cb0_030w;
  _724 = cb0_019w * cb0_029w;
  _733 = cb0_018w * cb0_028w;
  _742 = cb0_017w * cb0_027w;
  _800 = _584 - _697;
  _811 = ((_697 * (((cb0_021x + cb0_036x) + _594) + (((cb0_020x * cb0_035x) * _603) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _621) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _630) * _521) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _612)))))) + (_585 * (((cb0_021x + cb0_026x) + _461) + (((cb0_020x * cb0_025x) * _475) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _503) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _517) * _521) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _489))))))) + ((((cb0_021x + cb0_031x) + _706) + (((cb0_020x * cb0_030x) * _715) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _733) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _742) * _521) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _724))))) * _800);
  _813 = ((_697 * (((cb0_021y + cb0_036y) + _594) + (((cb0_020y * cb0_035y) * _603) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _621) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _630) * _522) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _612)))))) + (_585 * (((cb0_021y + cb0_026y) + _461) + (((cb0_020y * cb0_025y) * _475) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _503) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _517) * _522) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _489))))))) + ((((cb0_021y + cb0_031y) + _706) + (((cb0_020y * cb0_030y) * _715) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _733) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _742) * _522) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _724))))) * _800);
  _815 = ((_697 * (((cb0_021z + cb0_036z) + _594) + (((cb0_020z * cb0_035z) * _603) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _621) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _630) * _523) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _612)))))) + (_585 * (((cb0_021z + cb0_026z) + _461) + (((cb0_020z * cb0_025z) * _475) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _503) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _517) * _523) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _489))))))) + ((((cb0_021z + cb0_031z) + _706) + (((cb0_020z * cb0_030z) * _715) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _733) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _742) * _523) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _724))))) * _800);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;
  float4 output = ProcessLutbuilder(float3(_811, _813, _815), s0, s1, t0, t1, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _851 = ((mad(0.061360642313957214f, _815, mad(-4.540197551250458e-09f, _813, (_811 * 0.9386394023895264f))) - _811) * cb0_038z) + _811;
  _852 = ((mad(0.169205904006958f, _815, mad(0.8307942152023315f, _813, (_811 * 6.775371730327606e-08f))) - _813) * cb0_038z) + _813;
  _853 = (mad(-2.3283064365386963e-10f, _813, (_811 * -9.313225746154785e-10f)) * cb0_038z) + _815;
  _856 = mad(0.16386905312538147f, _853, mad(0.14067868888378143f, _852, (_851 * 0.6954522132873535f)));
  _859 = mad(0.0955343246459961f, _853, mad(0.8596711158752441f, _852, (_851 * 0.044794581830501556f)));
  _862 = mad(1.0015007257461548f, _853, mad(0.004025210160762072f, _852, (_851 * -0.005525882821530104f)));
  _866 = max(max(_856, _859), _862);
  _871 = (max(_866, 1.000000013351432e-10f) - max(min(min(_856, _859), _862), 1.000000013351432e-10f)) / max(_866, 0.009999999776482582f);
  _884 = ((_859 + _856) + _862) + (sqrt((((_862 - _859) * _862) + ((_859 - _856) * _859)) + ((_856 - _862) * _856)) * 1.75f);
  _885 = _884 * 0.3333333432674408f;
  _886 = _871 + -0.4000000059604645f;
  _887 = _886 * 5.0f;
  _891 = max((1.0f - abs(_886 * 2.5f)), 0.0f);
  _902 = ((float((int)(((int)(uint)((int)(_887 > 0.0f))) - ((int)(uint)((int)(_887 < 0.0f))))) * (1.0f - (_891 * _891))) + 1.0f) * 0.02500000037252903f;
  if (_885 > 0.0533333346247673f) {
    if (_885 < 0.1599999964237213f) {
      _911 = (((0.23999999463558197f / _884) + -0.5f) * _902);
    } else {
      _911 = 0.0f;
    }
  } else {
    _911 = _902;
  }
  _912 = _911 + 1.0f;
  _913 = _912 * _856;
  _914 = _912 * _859;
  _915 = _912 * _862;
  if (!((_913 == _914) && (_914 == _915))) {
    _922 = ((_913 * 2.0f) - _914) - _915;
    _925 = ((_859 - _862) * 1.7320507764816284f) * _912;
    _927 = atan(_925 / _922);
    _930 = (_922 < 0.0f);
    _931 = (_922 == 0.0f);
    _932 = (_925 >= 0.0f);
    _933 = (_925 < 0.0f);
    _944 = select((_932 && _931), 90.0f, select((_933 && _931), -90.0f, (select((_933 && _930), (_927 + -3.1415927410125732f), select((_932 && _930), (_927 + 3.1415927410125732f), _927)) * 57.2957763671875f)));
  } else {
    _944 = 0.0f;
  }
  _949 = min(max(select((_944 < 0.0f), (_944 + 360.0f), _944), 0.0f), 360.0f);
  if (_949 < -180.0f) {
    _958 = (_949 + 360.0f);
  } else {
    if (_949 > 180.0f) {
      _958 = (_949 + -360.0f);
    } else {
      _958 = _949;
    }
  }
  _962 = saturate(1.0f - abs(_958 * 0.014814814552664757f));
  _966 = (_962 * _962) * (3.0f - (_962 * 2.0f));
  _972 = ((_966 * _966) * ((_871 * 0.18000000715255737f) * (0.029999999329447746f - _913))) + _913;
  _982 = max(0.0f, mad(-0.21492856740951538f, _915, mad(-0.2365107536315918f, _914, (_972 * 1.4514392614364624f))));
  _983 = max(0.0f, mad(-0.09967592358589172f, _915, mad(1.17622971534729f, _914, (_972 * -0.07655377686023712f))));
  _984 = max(0.0f, mad(0.9977163076400757f, _915, mad(-0.006032449658960104f, _914, (_972 * 0.008316148072481155f))));
  _985 = dot(float3(_982, _983, _984), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1000 = (cb0_040x + 1.0f) - cb0_039z;
  _1002 = cb0_040y + 1.0f;
  _1004 = _1002 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1022 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1013 = (cb0_040x + 0.18000000715255737f) / _1000;
    _1022 = (-0.7447274923324585f - ((log2(_1013 / (2.0f - _1013)) * 0.3465735912322998f) * (_1000 / cb0_039y)));
  }
  _1025 = ((1.0f - cb0_039z) / cb0_039y) - _1022;
  _1027 = (cb0_039w / cb0_039y) - _1025;
  _1031 = log2(lerp(_985, _982, 0.9599999785423279f)) * 0.3010300099849701f;
  _1032 = log2(lerp(_985, _983, 0.9599999785423279f)) * 0.3010300099849701f;
  _1033 = log2(lerp(_985, _984, 0.9599999785423279f)) * 0.3010300099849701f;
  _1037 = cb0_039y * (_1031 + _1025);
  _1038 = cb0_039y * (_1032 + _1025);
  _1039 = cb0_039y * (_1033 + _1025);
  _1040 = _1000 * 2.0f;
  _1042 = (cb0_039y * -2.0f) / _1000;
  _1043 = _1031 - _1022;
  _1044 = _1032 - _1022;
  _1045 = _1033 - _1022;
  _1064 = _1004 * 2.0f;
  _1066 = (cb0_039y * 2.0f) / _1004;
  _1091 = select((_1031 < _1022), ((_1040 / (exp2((_1043 * 1.4426950216293335f) * _1042) + 1.0f)) - cb0_040x), _1037);
  _1092 = select((_1032 < _1022), ((_1040 / (exp2((_1044 * 1.4426950216293335f) * _1042) + 1.0f)) - cb0_040x), _1038);
  _1093 = select((_1033 < _1022), ((_1040 / (exp2((_1045 * 1.4426950216293335f) * _1042) + 1.0f)) - cb0_040x), _1039);
  _1100 = _1027 - _1022;
  _1104 = saturate(_1043 / _1100);
  _1105 = saturate(_1044 / _1100);
  _1106 = saturate(_1045 / _1100);
  _1107 = (_1027 < _1022);
  _1111 = select(_1107, (1.0f - _1104), _1104);
  _1112 = select(_1107, (1.0f - _1105), _1105);
  _1113 = select(_1107, (1.0f - _1106), _1106);
  _1132 = (((_1111 * _1111) * (select((_1031 > _1027), (_1002 - (_1064 / (exp2(((_1031 - _1027) * 1.4426950216293335f) * _1066) + 1.0f))), _1037) - _1091)) * (3.0f - (_1111 * 2.0f))) + _1091;
  _1133 = (((_1112 * _1112) * (select((_1032 > _1027), (_1002 - (_1064 / (exp2(((_1032 - _1027) * 1.4426950216293335f) * _1066) + 1.0f))), _1038) - _1092)) * (3.0f - (_1112 * 2.0f))) + _1092;
  _1134 = (((_1113 * _1113) * (select((_1033 > _1027), (_1002 - (_1064 / (exp2(((_1033 - _1027) * 1.4426950216293335f) * _1066) + 1.0f))), _1039) - _1093)) * (3.0f - (_1113 * 2.0f))) + _1093;
  _1135 = dot(float3(_1132, _1133, _1134), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1155 = (cb0_039x * (max(0.0f, (lerp(_1135, _1132, 0.9300000071525574f))) - _851)) + _851;
  _1156 = (cb0_039x * (max(0.0f, (lerp(_1135, _1133, 0.9300000071525574f))) - _852)) + _852;
  _1157 = (cb0_039x * (max(0.0f, (lerp(_1135, _1134, 0.9300000071525574f))) - _853)) + _853;
  _1173 = ((mad(-0.06537103652954102f, _1157, mad(1.451815478503704e-06f, _1156, (_1155 * 1.065374732017517f))) - _1155) * cb0_038z) + _1155;
  _1174 = ((mad(-0.20366770029067993f, _1157, mad(1.2036634683609009f, _1156, (_1155 * -2.57161445915699e-07f))) - _1156) * cb0_038z) + _1156;
  _1175 = ((mad(0.9999996423721313f, _1157, mad(2.0954757928848267e-08f, _1156, (_1155 * 1.862645149230957e-08f))) - _1157) * cb0_038z) + _1157;
  _1188 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1175, mad((WorkingColorSpace_192[0].y), _1174, ((WorkingColorSpace_192[0].x) * _1173)))));
  _1189 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1175, mad((WorkingColorSpace_192[1].y), _1174, ((WorkingColorSpace_192[1].x) * _1173)))));
  _1190 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1175, mad((WorkingColorSpace_192[2].y), _1174, ((WorkingColorSpace_192[2].x) * _1173)))));
  if (_1188 < 0.0031306699384003878f) {
    _1201 = (_1188 * 12.920000076293945f);
  } else {
    _1201 = (((pow(_1188, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1189 < 0.0031306699384003878f) {
    _1212 = (_1189 * 12.920000076293945f);
  } else {
    _1212 = (((pow(_1189, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1190 < 0.0031306699384003878f) {
    _1223 = (_1190 * 12.920000076293945f);
  } else {
    _1223 = (((pow(_1190, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1227 = (_1212 * 0.9375f) + 0.03125f;
  _1234 = _1223 * 15.0f;
  _1235 = floor(_1234);
  _1236 = _1234 - _1235;
  _1238 = (_1235 + ((_1201 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1241 = t0.SampleLevel(s0, float2(_1238, _1227), 0.0f);
  _1245 = _1238 + 0.0625f;
  _1246 = t0.SampleLevel(s0, float2(_1245, _1227), 0.0f);
  _1268 = t1.SampleLevel(s1, float2(_1238, _1227), 0.0f);
  _1272 = t1.SampleLevel(s1, float2(_1245, _1227), 0.0f);
  _1288 = (((lerp(_1241.x, _1246.x, _1236)) * cb0_005y) + (cb0_005x * _1201)) + ((lerp(_1268.x, _1272.x, _1236)) * cb0_005z);
  _1289 = (((lerp(_1241.y, _1246.y, _1236)) * cb0_005y) + (cb0_005x * _1212)) + ((lerp(_1268.y, _1272.y, _1236)) * cb0_005z);
  _1290 = (((lerp(_1241.z, _1246.z, _1236)) * cb0_005y) + (cb0_005x * _1223)) + ((lerp(_1268.z, _1272.z, _1236)) * cb0_005z);
  _1315 = select((_1288 > 0.040449999272823334f), exp2(log2((abs(_1288) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1288 * 0.07739938050508499f));
  _1316 = select((_1289 > 0.040449999272823334f), exp2(log2((abs(_1289) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1289 * 0.07739938050508499f));
  _1317 = select((_1290 > 0.040449999272823334f), exp2(log2((abs(_1290) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1290 * 0.07739938050508499f));
  _1343 = cb0_016x * (((cb0_041y + (cb0_041x * _1315)) * _1315) + cb0_041z);
  _1344 = cb0_016y * (((cb0_041y + (cb0_041x * _1316)) * _1316) + cb0_041z);
  _1345 = cb0_016z * (((cb0_041y + (cb0_041x * _1317)) * _1317) + cb0_041z);
  _1352 = ((cb0_015x - _1343) * cb0_015w) + _1343;
  _1353 = ((cb0_015y - _1344) * cb0_015w) + _1344;
  _1354 = ((cb0_015z - _1345) * cb0_015w) + _1345;
  _1355 = cb0_016x * mad((WorkingColorSpace_192[0].z), _815, mad((WorkingColorSpace_192[0].y), _813, (_811 * (WorkingColorSpace_192[0].x))));
  _1356 = cb0_016y * mad((WorkingColorSpace_192[1].z), _815, mad((WorkingColorSpace_192[1].y), _813, ((WorkingColorSpace_192[1].x) * _811)));
  _1357 = cb0_016z * mad((WorkingColorSpace_192[2].z), _815, mad((WorkingColorSpace_192[2].y), _813, ((WorkingColorSpace_192[2].x) * _811)));
  _1364 = ((cb0_015x - _1355) * cb0_015w) + _1355;
  _1365 = ((cb0_015y - _1356) * cb0_015w) + _1356;
  _1366 = ((cb0_015z - _1357) * cb0_015w) + _1357;
  _1378 = exp2(log2(max(0.0f, _1352)) * cb0_042y);
  _1379 = exp2(log2(max(0.0f, _1353)) * cb0_042y);
  _1380 = exp2(log2(max(0.0f, _1354)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1403 = mad((WorkingColorSpace_128[0].z), _1380, mad((WorkingColorSpace_128[0].y), _1379, ((WorkingColorSpace_128[0].x) * _1378)));
      _1406 = mad((WorkingColorSpace_128[1].z), _1380, mad((WorkingColorSpace_128[1].y), _1379, ((WorkingColorSpace_128[1].x) * _1378)));
      _1409 = mad((WorkingColorSpace_128[2].z), _1380, mad((WorkingColorSpace_128[2].y), _1379, ((WorkingColorSpace_128[2].x) * _1378)));
      _1420 = mad(_58, _1409, mad(_57, _1406, (_1403 * _56)));
      _1421 = mad(_61, _1409, mad(_60, _1406, (_1403 * _59)));
      _1422 = mad(_64, _1409, mad(_63, _1406, (_1403 * _62)));
    } else {
      _1420 = _1378;
      _1421 = _1379;
      _1422 = _1380;
    }
    if (_1420 < 0.0031306699384003878f) {
      _1433 = (_1420 * 12.920000076293945f);
    } else {
      _1433 = (((pow(_1420, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1421 < 0.0031306699384003878f) {
      _1444 = (_1421 * 12.920000076293945f);
    } else {
      _1444 = (((pow(_1421, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1422 < 0.0031306699384003878f) {
      _3450 = _1433;
      _3451 = _1444;
      _3452 = (_1422 * 12.920000076293945f);
    } else {
      _3450 = _1433;
      _3451 = _1444;
      _3452 = (((pow(_1422, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1471 = mad((WorkingColorSpace_128[0].z), _1380, mad((WorkingColorSpace_128[0].y), _1379, ((WorkingColorSpace_128[0].x) * _1378)));
      _1474 = mad((WorkingColorSpace_128[1].z), _1380, mad((WorkingColorSpace_128[1].y), _1379, ((WorkingColorSpace_128[1].x) * _1378)));
      _1477 = mad((WorkingColorSpace_128[2].z), _1380, mad((WorkingColorSpace_128[2].y), _1379, ((WorkingColorSpace_128[2].x) * _1378)));
      _1480 = mad(_58, _1477, mad(_57, _1474, (_1471 * _56)));
      _1483 = mad(_61, _1477, mad(_60, _1474, (_1471 * _59)));
      _1486 = mad(_64, _1477, mad(_63, _1474, (_1471 * _62)));
      _3450 = min((_1480 * 4.5f), ((exp2(log2(max(_1480, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3451 = min((_1483 * 4.5f), ((exp2(log2(max(_1483, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3452 = min((_1486 * 4.5f), ((exp2(log2(max(_1486, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
        _1531 = cb0_012z * _1364;
        _1532 = cb0_012z * _1365;
        _1533 = cb0_012z * _1366;
        _1536 = mad((WorkingColorSpace_256[0].z), _1533, mad((WorkingColorSpace_256[0].y), _1532, (_1531 * (WorkingColorSpace_256[0].x))));
        _1539 = mad((WorkingColorSpace_256[1].z), _1533, mad((WorkingColorSpace_256[1].y), _1532, (_1531 * (WorkingColorSpace_256[1].x))));
        _1542 = mad((WorkingColorSpace_256[2].z), _1533, mad((WorkingColorSpace_256[2].y), _1532, (_1531 * (WorkingColorSpace_256[2].x))));
        _1543 = cb0_043y * 0.009999999776482582f;
        _1544 = log2(_1543);
        _1549 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
        _1564 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_1549 * 400.0f) / (_1549 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1566 = (_1544 * 1.4018198251724243f) + 10.012999534606934f;
        _1571 = exp2(log2(abs(_1566) * 0.00793700572103262f) * 0.41999998688697815f);
        _1612 = (_1544 * 924.7640991210938f) + 1024.0f;
        _1616 = min(max(mad(-0.21492856740951538f, _1542, mad(-0.2365107536315918f, _1539, (_1536 * 1.4514392614364624f))), 0.0f), _1612);
        _1617 = min(max(mad(-0.09967592358589172f, _1542, mad(1.17622971534729f, _1539, (_1536 * -0.07655377686023712f))), 0.0f), _1612);
        _1618 = min(max(mad(0.9977163076400757f, _1542, mad(-0.006032449658960104f, _1539, (_1536 * 0.008316148072481155f))), 0.0f), _1612);
        _1621 = mad(0.15618768334388733f, _1618, mad(0.13400420546531677f, _1617, (_1616 * 0.6624541878700256f)));
        _1628 = mad(0.053689517080783844f, _1618, mad(0.6740817427635193f, _1617, (_1616 * 0.2722287178039551f))) * 100.0f;
        _1629 = mad(1.0103391408920288f, _1618, mad(0.00406073359772563f, _1617, (_1616 * -0.005574649665504694f))) * 100.0f;
        _1639 = mad(0.04110127314925194f, _1629, mad(0.594700813293457f, _1628, (_1621 * 36.407447814941406f))) * 1.0172951221466064f;
        _1640 = mad(0.1479453295469284f, _1629, mad(1.0738555192947388f, _1628, (_1621 * -22.224510192871094f))) * 0.9887425899505615f;
        _1641 = mad(0.9503875374794006f, _1629, mad(0.04882604628801346f, _1628, (_1621 * -0.20676189661026f))) * 0.9944003820419312f;
        _1645 = abs(_1639) * 0.00793700572103262f;
        _1646 = abs(_1640) * 0.00793700572103262f;
        _1647 = abs(_1641) * 0.00793700572103262f;
        if (!(_1645 < 0.0f)) {
          _1654 = (pow(_1645, 0.41999998688697815f));
        } else {
          _1654 = 0.0f;
        }
        if (!(_1646 < 0.0f)) {
          _1661 = (pow(_1646, 0.41999998688697815f));
        } else {
          _1661 = 0.0f;
        }
        if (!(_1647 < 0.0f)) {
          _1668 = (pow(_1647, 0.41999998688697815f));
        } else {
          _1668 = 0.0f;
        }
        _1696 = ((float((int)(((int)(uint)((int)(_1639 > 0.0f))) - ((int)(uint)((int)(_1639 < 0.0f))))) * 400.0f) * _1654) / (_1654 + 27.1299991607666f);
        _1697 = ((float((int)(((int)(uint)((int)(_1640 > 0.0f))) - ((int)(uint)((int)(_1640 < 0.0f))))) * 400.0f) * _1661) / (_1661 + 27.1299991607666f);
        _1698 = ((float((int)(((int)(uint)((int)(_1641 > 0.0f))) - ((int)(uint)((int)(_1641 < 0.0f))))) * 400.0f) * _1668) / (_1668 + 27.1299991607666f);
        _1702 = (_1696 - (_1697 * 1.0909091234207153f)) + (_1698 * 0.09090909361839294f);
        _1706 = ((_1697 + _1696) - (_1698 * 2.0f)) * 0.1111111119389534f;
        _1708 = atan(_1706 / _1702);
        _1711 = (_1702 < 0.0f);
        _1712 = (_1702 == 0.0f);
        _1713 = (_1706 >= 0.0f);
        _1714 = (_1706 < 0.0f);
        _1723 = select((_1712 && _1713), 0.25f, select((_1712 && _1714), -0.25f, (select((_1711 && _1714), (_1708 + -3.1415927410125732f), select((_1711 && _1713), (_1708 + 3.1415927410125732f), _1708)) * 0.15915493667125702f)));
        _1727 = frac(abs(_1723));
        _1730 = select((_1723 >= (-0.0f - _1723)), _1727, (-0.0f - _1727)) * 360.0f;
        _1733 = select((_1730 < 0.0f), (_1730 + 360.0f), _1730);
        _1742 = exp2(log2((((_1696 * 2.0f) + _1697) + (_1698 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
        if (!(_1742 == 0.0f)) {
          _1751 = (sqrt((_1706 * _1706) + (_1702 * _1702)) * 38.70000076293945f);
        } else {
          _1751 = 0.0f;
        }
        _1756 = exp2(log2(abs(_1742) * 0.009999999776482582f) * 0.8794641494750977f);
        _1771 = (float((int)(((int)(uint)((int)(_1742 > 0.0f))) - ((int)(uint)((int)(_1742 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_1756 * 351.2578430175781f) / (400.0f - (_1756 * 12.947211265563965f))) * 2.3809523582458496f);
        _1773 = (_1544 * 115.59551239013672f) + 128.0f;
        _1777 = sqrt((_1543 + 0.1599999964237213f) * _1543) + _1543;
        _1778 = _1777 * 0.5f;
        _1779 = _1773 / _1778;
        _1786 = _1544 * 0.014018198475241661f;
        _1787 = _1786 + 0.10012999176979065f;
        _1797 = exp2(log2((((_1787 + sqrt(_1787 * (_1786 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_1773 / (_1778 * (_1779 + 1.0f))) * 1.149999976158142f)) / _1778) * 0.8695652484893799f);
        _1802 = 0.18000000715255737f / (((_1777 * -0.5f) * _1797) / (_1797 + -1.0f));
        _1817 = exp2(log2(max(0.0f, _1771) / ((_1802 * _1778) + _1771)) * 1.149999976158142f) * (_1778 / exp2(log2(_1773 / ((_1779 + _1802) * _1778)) * 1.149999976158142f));
        _1822 = max(0.0f, ((_1817 * _1817) / (_1817 + 0.03999999910593033f))) * 100.0f;
        _1827 = exp2(log2(abs(_1822) * 0.00793700572103262f) * 0.41999998688697815f);
        _1842 = (float((int)(((int)(uint)((int)(_1822 > 0.0f))) - ((int)(uint)((int)(_1822 < 0.0f))))) * 100.0f) * exp2(log2(((_1827 * 400.0f) / (_1827 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1844 = _1733 * 0.0027777778450399637f;
        _1845 = -0.0f - _1844;
        _1847 = frac(abs(_1844));
        _1848 = -0.0f - _1847;
        if (!(_1751 == 0.0f)) {
          _1850 = _1842 / _1564;
          _1852 = max(0.0f, (1.0f - _1850));
          _1853 = _1733 * 0.01745329424738884f;
          _1854 = cos(_1853);
          _1855 = sin(_1853);
          _1856 = _1854 * _1854;
          _1857 = _1855 * _1855;
          _1872 = ((((77.12895965576172f - ((_1854 * 12.74448013305664f) * _1855)) + ((_1856 - _1857) * 16.468990325927734f)) + (((_1856 * 31.535200119018555f) + -12.31067943572998f) * _1854)) + ((42.245330810546875f - (_1857 * 36.774559020996094f)) * _1855)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
          _1878 = select((_1844 >= _1845), _1847, _1848) * 360.0f;
          _1882 = int(select((_1878 < 0.0f), (_1878 + 360.0f), _1878));
          _1884 = (_1882 + 1) % 360;
          _1893 = t2.Load(int3(_1882, 0, 0));
          _1898 = (((((t2.Load(int3(_1884, 0, 0))).x) - _1893.x) * ((_1733 - float((int)(_1882))) / float((int)(_1884 - _1882)))) + _1893.x) * (pow(_1850, 0.8794641494750977f));
          _1899 = _1898 / _1872;
          _1900 = _1899 + -0.0010000000474974513f;
          _1901 = _1852 * max(0.20000000298023224f, (1.2999999523162842f - (_1544 * 0.270023912191391f)));
          _1902 = _1850 * ((_1544 * 2.384157657623291f) + 2.4000000953674316f);
          _1909 = (_1898 - (exp2(log2(_1842 / _1742) * 0.8794641494750977f) * _1751)) / _1872;
          if (!(_1909 > _1900)) {
            _1915 = max(sqrt((_1850 * _1850) + (0.5f / cb0_043y)), 0.0010000000474974513f);
            _1919 = sqrt((_1915 * _1915) + (_1901 * _1901));
            _1922 = (_1919 + _1900) / (_1915 + _1900);
            _1924 = (_1922 * _1909) - _1919;
            _1934 = ((_1924 + sqrt((_1924 * _1924) + (((_1909 * 4.0f) * _1915) * _1922))) * 0.5f);
          } else {
            _1934 = _1909;
          }
          _1935 = _1899 - _1934;
          if (!(_1935 > _1899)) {
            _1938 = max(_1852, 0.0010000000474974513f);
            _1942 = sqrt((_1938 * _1938) + (_1902 * _1902));
            _1945 = (_1942 + _1899) / (_1938 + _1899);
            _1947 = (_1945 * _1935) - _1942;
            _1957 = ((_1947 + sqrt((_1947 * _1947) + (((_1935 * 4.0f) * _1938) * _1945))) * 0.5f);
          } else {
            _1957 = _1935;
          }
          _1960 = (_1957 * _1872);
        } else {
          _1960 = _1751;
        }
        _1963 = select((_1844 >= _1845), _1847, _1848) * 360.0f;
        _1966 = select((_1963 < 0.0f), (_1963 + 360.0f), _1963);
        _1967 = int(_1966);
        _1968 = _1967 + 1;
        _1970 = 0;
        _1971 = 361;
        _1972 = _1968;
        while(true) {
          _1976 = (_1733 > (((float3)(t3.Load(int3(_1972, 0, 0)))).z));
          _1977 = select(_1976, _1972, _1970);
          _1978 = select(_1976, _1971, _1972);
          if ((int)(_1977 + 1) < (int)_1978) {
            _1970 = _1977;
            _1971 = _1978;
            _1972 = ((_1977 + _1978) / 2);
            continue;
          }
          _1985 = t3.Load(int3((_1978 + -1), 0, 0));
          _1989 = t3.Load(int3(_1978, 0, 0));
          _1995 = (_1733 - _1985.z) / (_1989.z - _1985.z);
          _1998 = ((_1989.x - _1985.x) * _1995) + _1985.x;
          if (!((_1842 > _1564) || (_1960 < 9.999999747378752e-05f))) {
            _2012 = (min(1.0f, (1.2999999523162842f - (_1998 / _1564))) * (((float((int)(((int)(uint)((int)(_1566 > 0.0f))) - ((int)(uint)((int)(_1566 < 0.0f))))) * 100.0f) * exp2(log2(((_1571 * 400.0f) / (_1571 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _1998)) + _1998;
            _2013 = ((_1544 * 0.7111833691596985f) + 1.350000023841858f) * _1564;
            _2014 = _1564 - _1998;
            _2016 = (_2014 * 0.30000001192092896f) + _1998;
            if (_1842 > _2016) {
              _2030 = (exp2(log2(log2((_1564 - _2016) / max(9.999999747378752e-05f, (_1564 - _1842))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _2030 = 1.0f;
            }
            _2031 = _2013 * _2030;
            t4.GetDimensions(_2033.x, _2033.y);
            _2037 = float((int)(_1967));
            _2041 = t4.Load(int3(_1968, 0, 0));
            _2046 = (lerp(_1985.y, _1989.y, _1995)) * 1.0324000120162964f;
            _2047 = _2031 * _2012;
            _2049 = (_1842 < _2012);
            _2050 = _1960 / _2031;
            if (_2049) {
              _2060 = (1.0f - _2050);
            } else {
              _2060 = (-0.0f - ((_2050 + 1.0f) + ((_1960 * _1564) / _2047)));
            }
            if (_2049) {
              _2068 = (-0.0f - _1842);
            } else {
              _2068 = (((_1960 * _1564) / _2031) + _1842);
            }
            _2073 = sqrt((_2060 * _2060) - (((_1960 / _2047) * 4.0f) * _2068));
            _2079 = (_2068 * 2.0f) / select(_2049, ((-0.0f - _2060) - _2073), (_2073 - _2060));
            _2081 = (_1998 < _2012);
            _2082 = _2046 / _2031;
            if (_2081) {
              _2092 = (1.0f - _2082);
            } else {
              _2092 = (-0.0f - ((_2082 + 1.0f) + ((_2046 * _1564) / _2047)));
            }
            if (!_2081) {
              _2098 = (((_2046 * _1564) / _2031) + _1998);
            } else {
              _2098 = (-0.0f - _1998);
            }
            _2103 = sqrt((_2092 * _2092) - (((_2046 / _2047) * 4.0f) * _2098));
            _2109 = (_2098 * 2.0f) / select(_2081, ((-0.0f - _2092) - _2103), (_2103 - _2092));
            _2111 = _1564 - _2079;
            _2115 = ((_2079 - _2012) * select((_2079 < _2012), _2079, _2111)) / _2047;
            _2124 = _1564 - _2109;
            _2135 = ((_2124 * _2046) * exp2(log2(_2111 / _2124) * (1.0f / (((((t4.Load(int3(((_1967 + 2) % (int)(_2033.x)), 0, 0))).x) - _2041.x) * (_1966 - _2037)) + _2041.x)))) / ((_2014 + (_2115 * _2046)) * _2046);
            _2137 = (exp2(log2(_2079 / _2109) * (1.0f / ((_1544 * 0.02107210084795952f) + 1.1399999856948853f))) * _2109) / (((_1998 / _2046) - _2115) * _2046);
            _2141 = max((0.11999999731779099f - abs(_2137 - _2135)), 0.0f);
            _2142 = _2141 * 8.333333969116211f;
            _2148 = (min(_2137, _2135) - ((_2142 * _2142) * (_2141 * 0.1666666716337204f))) * _2046;
            _2149 = _2148 * _2115;
            _2150 = _2149 + _2079;
            _2151 = _1968 % 360;
            _2159 = t2.Load(int3(_1967, 0, 0));
            _2163 = ((((t2.Load(int3(_2151, 0, 0))).x) - _2159.x) * ((_1733 - _2037) / float((int)(_2151 - _1967)))) + _2159.x;
            if (_2150 > _2016) {
              _2177 = (exp2(log2(log2((_1564 - _2016) / max(9.999999747378752e-05f, (_1564 - _2150))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _2177 = 1.0f;
            }
            _2178 = _2013 * _2177;
            _2179 = _2178 * _2012;
            _2181 = (_2150 < _2012);
            _2182 = _2148 / _2178;
            if (_2181) {
              _2192 = (1.0f - _2182);
            } else {
              _2192 = (-0.0f - ((_2182 + 1.0f) + ((_2148 * _1564) / _2179)));
            }
            if (_2181) {
              _2200 = (-0.0f - _2150);
            } else {
              _2200 = (((_2148 * _1564) / _2178) + _2150);
            }
            _2205 = sqrt((_2192 * _2192) - (((_2148 / _2179) * 4.0f) * _2200));
            _2211 = (_2200 * 2.0f) / select(_2181, ((-0.0f - _2192) - _2205), (_2205 - _2192));
            _2228 = max(1.000100016593933f, (((_2163 * _1564) * exp2(log2(_2211 / _1564) * 0.8794641494750977f)) / ((_1564 - ((((_2211 - _2012) * select((_2211 < _2012), _2211, (_1564 - _2211))) / _2179) * _2163)) * _2148)));
            _2230 = max(0.75f, (1.0f / _2228));
            _2231 = _1960 / _2148;
            _2236 = ((_2228 - _2230) * (1.0f - _2230)) / (_2228 + -1.0f);
            _2238 = (_2231 - _2230) / _2236;
            if (!((_2228 <= 1.000100016593933f) || (_2231 < _2230))) {
              _2248 = (((_2238 * _2236) / (_2238 + 1.0f)) + _2230);
            } else {
              _2248 = _2231;
            }
            _2254 = ((_2248 * _2149) + _2079);
            _2255 = ((_2148 * _2248) * 0.0258397925645113f);
          } else {
            _2254 = _1842;
            _2255 = 0.0f;
          }
          _2256 = _1733 * 0.01745329424738884f;
          _2257 = _2254 * 0.009999999776482582f;
          if (!(_2257 < 0.0f)) {
            _2266 = (((pow(_2257, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
          } else {
            _2266 = 0.0f;
          }
          _2268 = cos(_2256) * _2255;
          _2270 = sin(_2256) * _2255;
          _2277 = mad(288.0f, _2270, mad(451.0f, _2268, _2266)) * 0.0007127583958208561f;
          _2278 = mad(-261.0f, _2270, mad(-891.0f, _2268, _2266)) * 0.0007127583958208561f;
          _2279 = mad(-6300.0f, _2270, mad(-220.0f, _2268, _2266)) * 0.0007127583958208561f;
          _2299 = abs(_2277);
          _2300 = abs(_2278);
          _2301 = abs(_2279);
          _2308 = (_2299 * 27.1299991607666f) / (400.0f - _2299);
          _2309 = (_2300 * 27.1299991607666f) / (400.0f - _2300);
          _2310 = (_2301 * 27.1299991607666f) / (400.0f - _2301);
          if (!(_2308 < 0.0f)) {
            _2317 = (pow(_2308, 2.3809523582458496f));
          } else {
            _2317 = 0.0f;
          }
          if (!(_2309 < 0.0f)) {
            _2324 = (pow(_2309, 2.3809523582458496f));
          } else {
            _2324 = 0.0f;
          }
          if (!(_2310 < 0.0f)) {
            _2331 = (pow(_2310, 2.3809523582458496f));
          } else {
            _2331 = 0.0f;
          }
          _2332 = (float((int)(((int)(uint)((int)(_2277 > 0.0f))) - ((int)(uint)((int)(_2277 < 0.0f))))) * 125.99209594726562f) * _2317;
          _2334 = (float((int)(((int)(uint)((int)(_2278 > 0.0f))) - ((int)(uint)((int)(_2278 < 0.0f))))) * 127.42658996582031f) * _2324;
          _2336 = (float((int)(((int)(uint)((int)(_2279 > 0.0f))) - ((int)(uint)((int)(_2279 < 0.0f))))) * 126.70159912109375f) * _2331;
          _2339 = mad(0.08875565975904465f, _2336, mad(-1.140031337738037f, _2334, (_2332 * 2.016401767730713f)));
          _2346 = mad(-0.12752249836921692f, _2336, mad(0.7005835175514221f, _2334, (_2332 * 0.41968056559562683f))) * 0.009999999776482582f;
          _2347 = mad(1.0589468479156494f, _2336, mad(-0.03847259283065796f, _2334, (_2332 * -0.01717424765229225f))) * 0.009999999776482582f;
          _2360 = min(max(mad(-0.23642469942569733f, _2347, mad(-0.32480329275131226f, _2346, (_2339 * 0.016410233452916145f))), 0.0f), _1543);
          _2361 = min(max(mad(0.016756348311901093f, _2347, mad(1.6153316497802734f, _2346, (_2339 * -0.006636628415435553f))), 0.0f), _1543);
          _2362 = min(max(mad(0.9883948564529419f, _2347, mad(-0.008284442126750946f, _2346, (_2339 * 0.00011721893679350615f))), 0.0f), _1543);
          _2365 = mad(0.15618768334388733f, _2362, mad(0.13400420546531677f, _2361, (_2360 * 0.6624541878700256f)));
          _2368 = mad(0.053689517080783844f, _2362, mad(0.6740817427635193f, _2361, (_2360 * 0.2722287178039551f)));
          _2371 = mad(1.0103391408920288f, _2362, mad(0.00406073359772563f, _2361, (_2360 * -0.005574649665504694f)));
          _2381 = mad(-0.23642469942569733f, _2371, mad(-0.32480329275131226f, _2368, (_2365 * 1.6410233974456787f))) * 100.0f;
          _2382 = mad(0.016756348311901093f, _2371, mad(1.6153316497802734f, _2368, (_2365 * -0.663662850856781f))) * 100.0f;
          _2383 = mad(0.9883948564529419f, _2371, mad(-0.008284442126750946f, _2368, (_2365 * 0.011721894145011902f))) * 100.0f;
          _2402 = exp2(log2(mad(_58, _2383, mad(_57, _2382, (_2381 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2403 = exp2(log2(mad(_61, _2383, mad(_60, _2382, (_2381 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2404 = exp2(log2(mad(_64, _2383, mad(_63, _2382, (_2381 * _62))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _3450 = exp2(log2((1.0f / ((_2402 * 18.6875f) + 1.0f)) * ((_2402 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3451 = exp2(log2((1.0f / ((_2403 * 18.6875f) + 1.0f)) * ((_2403 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3452 = exp2(log2((1.0f / ((_2404 * 18.6875f) + 1.0f)) * ((_2404 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          break;
        }
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2452 = cb0_012z * _1364;
          _2453 = cb0_012z * _1365;
          _2454 = cb0_012z * _1366;
          _2457 = mad((WorkingColorSpace_256[0].z), _2454, mad((WorkingColorSpace_256[0].y), _2453, (_2452 * (WorkingColorSpace_256[0].x))));
          _2460 = mad((WorkingColorSpace_256[1].z), _2454, mad((WorkingColorSpace_256[1].y), _2453, (_2452 * (WorkingColorSpace_256[1].x))));
          _2463 = mad((WorkingColorSpace_256[2].z), _2454, mad((WorkingColorSpace_256[2].y), _2453, (_2452 * (WorkingColorSpace_256[2].x))));
          _2464 = cb0_043y * 0.009999999776482582f;
          _2465 = log2(_2464);
          _2470 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
          _2485 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_2470 * 400.0f) / (_2470 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2487 = (_2465 * 1.4018198251724243f) + 10.012999534606934f;
          _2492 = exp2(log2(abs(_2487) * 0.00793700572103262f) * 0.41999998688697815f);
          _2533 = (_2465 * 924.7640991210938f) + 1024.0f;
          _2537 = min(max(mad(-0.21492856740951538f, _2463, mad(-0.2365107536315918f, _2460, (_2457 * 1.4514392614364624f))), 0.0f), _2533);
          _2538 = min(max(mad(-0.09967592358589172f, _2463, mad(1.17622971534729f, _2460, (_2457 * -0.07655377686023712f))), 0.0f), _2533);
          _2539 = min(max(mad(0.9977163076400757f, _2463, mad(-0.006032449658960104f, _2460, (_2457 * 0.008316148072481155f))), 0.0f), _2533);
          _2542 = mad(0.15618768334388733f, _2539, mad(0.13400420546531677f, _2538, (_2537 * 0.6624541878700256f)));
          _2549 = mad(0.053689517080783844f, _2539, mad(0.6740817427635193f, _2538, (_2537 * 0.2722287178039551f))) * 100.0f;
          _2550 = mad(1.0103391408920288f, _2539, mad(0.00406073359772563f, _2538, (_2537 * -0.005574649665504694f))) * 100.0f;
          _2560 = mad(0.04110127314925194f, _2550, mad(0.594700813293457f, _2549, (_2542 * 36.407447814941406f))) * 1.0172951221466064f;
          _2561 = mad(0.1479453295469284f, _2550, mad(1.0738555192947388f, _2549, (_2542 * -22.224510192871094f))) * 0.9887425899505615f;
          _2562 = mad(0.9503875374794006f, _2550, mad(0.04882604628801346f, _2549, (_2542 * -0.20676189661026f))) * 0.9944003820419312f;
          _2566 = abs(_2560) * 0.00793700572103262f;
          _2567 = abs(_2561) * 0.00793700572103262f;
          _2568 = abs(_2562) * 0.00793700572103262f;
          if (!(_2566 < 0.0f)) {
            _2575 = (pow(_2566, 0.41999998688697815f));
          } else {
            _2575 = 0.0f;
          }
          if (!(_2567 < 0.0f)) {
            _2582 = (pow(_2567, 0.41999998688697815f));
          } else {
            _2582 = 0.0f;
          }
          if (!(_2568 < 0.0f)) {
            _2589 = (pow(_2568, 0.41999998688697815f));
          } else {
            _2589 = 0.0f;
          }
          _2617 = ((float((int)(((int)(uint)((int)(_2560 > 0.0f))) - ((int)(uint)((int)(_2560 < 0.0f))))) * 400.0f) * _2575) / (_2575 + 27.1299991607666f);
          _2618 = ((float((int)(((int)(uint)((int)(_2561 > 0.0f))) - ((int)(uint)((int)(_2561 < 0.0f))))) * 400.0f) * _2582) / (_2582 + 27.1299991607666f);
          _2619 = ((float((int)(((int)(uint)((int)(_2562 > 0.0f))) - ((int)(uint)((int)(_2562 < 0.0f))))) * 400.0f) * _2589) / (_2589 + 27.1299991607666f);
          _2623 = (_2617 - (_2618 * 1.0909091234207153f)) + (_2619 * 0.09090909361839294f);
          _2627 = ((_2618 + _2617) - (_2619 * 2.0f)) * 0.1111111119389534f;
          _2629 = atan(_2627 / _2623);
          _2632 = (_2623 < 0.0f);
          _2633 = (_2623 == 0.0f);
          _2634 = (_2627 >= 0.0f);
          _2635 = (_2627 < 0.0f);
          _2644 = select((_2633 && _2634), 0.25f, select((_2633 && _2635), -0.25f, (select((_2632 && _2635), (_2629 + -3.1415927410125732f), select((_2632 && _2634), (_2629 + 3.1415927410125732f), _2629)) * 0.15915493667125702f)));
          _2648 = frac(abs(_2644));
          _2651 = select((_2644 >= (-0.0f - _2644)), _2648, (-0.0f - _2648)) * 360.0f;
          _2654 = select((_2651 < 0.0f), (_2651 + 360.0f), _2651);
          _2663 = exp2(log2((((_2617 * 2.0f) + _2618) + (_2619 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
          if (!(_2663 == 0.0f)) {
            _2672 = (sqrt((_2627 * _2627) + (_2623 * _2623)) * 38.70000076293945f);
          } else {
            _2672 = 0.0f;
          }
          _2677 = exp2(log2(abs(_2663) * 0.009999999776482582f) * 0.8794641494750977f);
          _2692 = (float((int)(((int)(uint)((int)(_2663 > 0.0f))) - ((int)(uint)((int)(_2663 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_2677 * 351.2578430175781f) / (400.0f - (_2677 * 12.947211265563965f))) * 2.3809523582458496f);
          _2694 = (_2465 * 115.59551239013672f) + 128.0f;
          _2698 = sqrt((_2464 + 0.1599999964237213f) * _2464) + _2464;
          _2699 = _2698 * 0.5f;
          _2700 = _2694 / _2699;
          _2707 = _2465 * 0.014018198475241661f;
          _2708 = _2707 + 0.10012999176979065f;
          _2718 = exp2(log2((((_2708 + sqrt(_2708 * (_2707 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_2694 / (_2699 * (_2700 + 1.0f))) * 1.149999976158142f)) / _2699) * 0.8695652484893799f);
          _2723 = 0.18000000715255737f / (((_2698 * -0.5f) * _2718) / (_2718 + -1.0f));
          _2738 = exp2(log2(max(0.0f, _2692) / ((_2723 * _2699) + _2692)) * 1.149999976158142f) * (_2699 / exp2(log2(_2694 / ((_2700 + _2723) * _2699)) * 1.149999976158142f));
          _2743 = max(0.0f, ((_2738 * _2738) / (_2738 + 0.03999999910593033f))) * 100.0f;
          _2748 = exp2(log2(abs(_2743) * 0.00793700572103262f) * 0.41999998688697815f);
          _2763 = (float((int)(((int)(uint)((int)(_2743 > 0.0f))) - ((int)(uint)((int)(_2743 < 0.0f))))) * 100.0f) * exp2(log2(((_2748 * 400.0f) / (_2748 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2765 = _2654 * 0.0027777778450399637f;
          _2766 = -0.0f - _2765;
          _2768 = frac(abs(_2765));
          _2769 = -0.0f - _2768;
          if (!(_2672 == 0.0f)) {
            _2771 = _2763 / _2485;
            _2773 = max(0.0f, (1.0f - _2771));
            _2774 = _2654 * 0.01745329424738884f;
            _2775 = cos(_2774);
            _2776 = sin(_2774);
            _2777 = _2775 * _2775;
            _2778 = _2776 * _2776;
            _2793 = ((((77.12895965576172f - ((_2775 * 12.74448013305664f) * _2776)) + ((_2777 - _2778) * 16.468990325927734f)) + (((_2777 * 31.535200119018555f) + -12.31067943572998f) * _2775)) + ((42.245330810546875f - (_2778 * 36.774559020996094f)) * _2776)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
            _2799 = select((_2765 >= _2766), _2768, _2769) * 360.0f;
            _2803 = int(select((_2799 < 0.0f), (_2799 + 360.0f), _2799));
            _2805 = (_2803 + 1) % 360;
            _2814 = t2.Load(int3(_2803, 0, 0));
            _2819 = (((((t2.Load(int3(_2805, 0, 0))).x) - _2814.x) * ((_2654 - float((int)(_2803))) / float((int)(_2805 - _2803)))) + _2814.x) * (pow(_2771, 0.8794641494750977f));
            _2820 = _2819 / _2793;
            _2821 = _2820 + -0.0010000000474974513f;
            _2822 = _2773 * max(0.20000000298023224f, (1.2999999523162842f - (_2465 * 0.270023912191391f)));
            _2823 = _2771 * ((_2465 * 2.384157657623291f) + 2.4000000953674316f);
            _2830 = (_2819 - (exp2(log2(_2763 / _2663) * 0.8794641494750977f) * _2672)) / _2793;
            if (!(_2830 > _2821)) {
              _2836 = max(sqrt((_2771 * _2771) + (0.5f / cb0_043y)), 0.0010000000474974513f);
              _2840 = sqrt((_2836 * _2836) + (_2822 * _2822));
              _2843 = (_2840 + _2821) / (_2836 + _2821);
              _2845 = (_2843 * _2830) - _2840;
              _2855 = ((_2845 + sqrt((_2845 * _2845) + (((_2830 * 4.0f) * _2836) * _2843))) * 0.5f);
            } else {
              _2855 = _2830;
            }
            _2856 = _2820 - _2855;
            if (!(_2856 > _2820)) {
              _2859 = max(_2773, 0.0010000000474974513f);
              _2863 = sqrt((_2859 * _2859) + (_2823 * _2823));
              _2866 = (_2863 + _2820) / (_2859 + _2820);
              _2868 = (_2866 * _2856) - _2863;
              _2878 = ((_2868 + sqrt((_2868 * _2868) + (((_2856 * 4.0f) * _2859) * _2866))) * 0.5f);
            } else {
              _2878 = _2856;
            }
            _2881 = (_2878 * _2793);
          } else {
            _2881 = _2672;
          }
          _2884 = select((_2765 >= _2766), _2768, _2769) * 360.0f;
          _2887 = select((_2884 < 0.0f), (_2884 + 360.0f), _2884);
          _2888 = int(_2887);
          _2889 = _2888 + 1;
          _2891 = 0;
          _2892 = 361;
          _2893 = _2889;
          while(true) {
            _2897 = (_2654 > (((float3)(t3.Load(int3(_2893, 0, 0)))).z));
            _2898 = select(_2897, _2893, _2891);
            _2899 = select(_2897, _2892, _2893);
            if ((int)(_2898 + 1) < (int)_2899) {
              _2891 = _2898;
              _2892 = _2899;
              _2893 = ((_2898 + _2899) / 2);
              continue;
            }
            _2906 = t3.Load(int3((_2899 + -1), 0, 0));
            _2910 = t3.Load(int3(_2899, 0, 0));
            _2916 = (_2654 - _2906.z) / (_2910.z - _2906.z);
            _2919 = ((_2910.x - _2906.x) * _2916) + _2906.x;
            if (!((_2763 > _2485) || (_2881 < 9.999999747378752e-05f))) {
              _2933 = (min(1.0f, (1.2999999523162842f - (_2919 / _2485))) * (((float((int)(((int)(uint)((int)(_2487 > 0.0f))) - ((int)(uint)((int)(_2487 < 0.0f))))) * 100.0f) * exp2(log2(((_2492 * 400.0f) / (_2492 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _2919)) + _2919;
              _2934 = ((_2465 * 0.7111833691596985f) + 1.350000023841858f) * _2485;
              _2935 = _2485 - _2919;
              _2937 = (_2935 * 0.30000001192092896f) + _2919;
              if (_2763 > _2937) {
                _2951 = (exp2(log2(log2((_2485 - _2937) / max(9.999999747378752e-05f, (_2485 - _2763))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _2951 = 1.0f;
              }
              _2952 = _2934 * _2951;
              t4.GetDimensions(_2954.x, _2954.y);
              _2958 = float((int)(_2888));
              _2962 = t4.Load(int3(_2889, 0, 0));
              _2967 = (lerp(_2906.y, _2910.y, _2916)) * 1.0324000120162964f;
              _2968 = _2952 * _2933;
              _2970 = (_2763 < _2933);
              _2971 = _2881 / _2952;
              if (_2970) {
                _2981 = (1.0f - _2971);
              } else {
                _2981 = (-0.0f - ((_2971 + 1.0f) + ((_2881 * _2485) / _2968)));
              }
              if (_2970) {
                _2989 = (-0.0f - _2763);
              } else {
                _2989 = (((_2881 * _2485) / _2952) + _2763);
              }
              _2994 = sqrt((_2981 * _2981) - (((_2881 / _2968) * 4.0f) * _2989));
              _3000 = (_2989 * 2.0f) / select(_2970, ((-0.0f - _2981) - _2994), (_2994 - _2981));
              _3002 = (_2919 < _2933);
              _3003 = _2967 / _2952;
              if (_3002) {
                _3013 = (1.0f - _3003);
              } else {
                _3013 = (-0.0f - ((_3003 + 1.0f) + ((_2967 * _2485) / _2968)));
              }
              if (!_3002) {
                _3019 = (((_2967 * _2485) / _2952) + _2919);
              } else {
                _3019 = (-0.0f - _2919);
              }
              _3024 = sqrt((_3013 * _3013) - (((_2967 / _2968) * 4.0f) * _3019));
              _3030 = (_3019 * 2.0f) / select(_3002, ((-0.0f - _3013) - _3024), (_3024 - _3013));
              _3032 = _2485 - _3000;
              _3036 = ((_3000 - _2933) * select((_3000 < _2933), _3000, _3032)) / _2968;
              _3045 = _2485 - _3030;
              _3056 = ((_3045 * _2967) * exp2(log2(_3032 / _3045) * (1.0f / (((((t4.Load(int3(((_2888 + 2) % (int)(_2954.x)), 0, 0))).x) - _2962.x) * (_2887 - _2958)) + _2962.x)))) / ((_2935 + (_3036 * _2967)) * _2967);
              _3058 = (exp2(log2(_3000 / _3030) * (1.0f / ((_2465 * 0.02107210084795952f) + 1.1399999856948853f))) * _3030) / (((_2919 / _2967) - _3036) * _2967);
              _3062 = max((0.11999999731779099f - abs(_3058 - _3056)), 0.0f);
              _3063 = _3062 * 8.333333969116211f;
              _3069 = (min(_3058, _3056) - ((_3063 * _3063) * (_3062 * 0.1666666716337204f))) * _2967;
              _3070 = _3069 * _3036;
              _3071 = _3070 + _3000;
              _3072 = _2889 % 360;
              _3080 = t2.Load(int3(_2888, 0, 0));
              _3084 = ((((t2.Load(int3(_3072, 0, 0))).x) - _3080.x) * ((_2654 - _2958) / float((int)(_3072 - _2888)))) + _3080.x;
              if (_3071 > _2937) {
                _3098 = (exp2(log2(log2((_2485 - _2937) / max(9.999999747378752e-05f, (_2485 - _3071))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _3098 = 1.0f;
              }
              _3099 = _2934 * _3098;
              _3100 = _3099 * _2933;
              _3102 = (_3071 < _2933);
              _3103 = _3069 / _3099;
              if (_3102) {
                _3113 = (1.0f - _3103);
              } else {
                _3113 = (-0.0f - ((_3103 + 1.0f) + ((_3069 * _2485) / _3100)));
              }
              if (_3102) {
                _3121 = (-0.0f - _3071);
              } else {
                _3121 = (((_3069 * _2485) / _3099) + _3071);
              }
              _3126 = sqrt((_3113 * _3113) - (((_3069 / _3100) * 4.0f) * _3121));
              _3132 = (_3121 * 2.0f) / select(_3102, ((-0.0f - _3113) - _3126), (_3126 - _3113));
              _3149 = max(1.000100016593933f, (((_3084 * _2485) * exp2(log2(_3132 / _2485) * 0.8794641494750977f)) / ((_2485 - ((((_3132 - _2933) * select((_3132 < _2933), _3132, (_2485 - _3132))) / _3100) * _3084)) * _3069)));
              _3151 = max(0.75f, (1.0f / _3149));
              _3152 = _2881 / _3069;
              _3157 = ((_3149 - _3151) * (1.0f - _3151)) / (_3149 + -1.0f);
              _3159 = (_3152 - _3151) / _3157;
              if (!((_3149 <= 1.000100016593933f) || (_3152 < _3151))) {
                _3169 = (((_3159 * _3157) / (_3159 + 1.0f)) + _3151);
              } else {
                _3169 = _3152;
              }
              _3175 = ((_3169 * _3070) + _3000);
              _3176 = ((_3069 * _3169) * 0.0258397925645113f);
            } else {
              _3175 = _2763;
              _3176 = 0.0f;
            }
            _3177 = _2654 * 0.01745329424738884f;
            _3178 = _3175 * 0.009999999776482582f;
            if (!(_3178 < 0.0f)) {
              _3187 = (((pow(_3178, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
            } else {
              _3187 = 0.0f;
            }
            _3189 = cos(_3177) * _3176;
            _3191 = sin(_3177) * _3176;
            _3198 = mad(288.0f, _3191, mad(451.0f, _3189, _3187)) * 0.0007127583958208561f;
            _3199 = mad(-261.0f, _3191, mad(-891.0f, _3189, _3187)) * 0.0007127583958208561f;
            _3200 = mad(-6300.0f, _3191, mad(-220.0f, _3189, _3187)) * 0.0007127583958208561f;
            _3220 = abs(_3198);
            _3221 = abs(_3199);
            _3222 = abs(_3200);
            _3229 = (_3220 * 27.1299991607666f) / (400.0f - _3220);
            _3230 = (_3221 * 27.1299991607666f) / (400.0f - _3221);
            _3231 = (_3222 * 27.1299991607666f) / (400.0f - _3222);
            if (!(_3229 < 0.0f)) {
              _3238 = (pow(_3229, 2.3809523582458496f));
            } else {
              _3238 = 0.0f;
            }
            if (!(_3230 < 0.0f)) {
              _3245 = (pow(_3230, 2.3809523582458496f));
            } else {
              _3245 = 0.0f;
            }
            if (!(_3231 < 0.0f)) {
              _3252 = (pow(_3231, 2.3809523582458496f));
            } else {
              _3252 = 0.0f;
            }
            _3253 = (float((int)(((int)(uint)((int)(_3198 > 0.0f))) - ((int)(uint)((int)(_3198 < 0.0f))))) * 125.99209594726562f) * _3238;
            _3255 = (float((int)(((int)(uint)((int)(_3199 > 0.0f))) - ((int)(uint)((int)(_3199 < 0.0f))))) * 127.42658996582031f) * _3245;
            _3257 = (float((int)(((int)(uint)((int)(_3200 > 0.0f))) - ((int)(uint)((int)(_3200 < 0.0f))))) * 126.70159912109375f) * _3252;
            _3260 = mad(0.08875565975904465f, _3257, mad(-1.140031337738037f, _3255, (_3253 * 2.016401767730713f)));
            _3267 = mad(-0.12752249836921692f, _3257, mad(0.7005835175514221f, _3255, (_3253 * 0.41968056559562683f))) * 0.009999999776482582f;
            _3268 = mad(1.0589468479156494f, _3257, mad(-0.03847259283065796f, _3255, (_3253 * -0.01717424765229225f))) * 0.009999999776482582f;
            _3281 = min(max(mad(-0.23642469942569733f, _3268, mad(-0.32480329275131226f, _3267, (_3260 * 0.016410233452916145f))), 0.0f), _2464);
            _3282 = min(max(mad(0.016756348311901093f, _3268, mad(1.6153316497802734f, _3267, (_3260 * -0.006636628415435553f))), 0.0f), _2464);
            _3283 = min(max(mad(0.9883948564529419f, _3268, mad(-0.008284442126750946f, _3267, (_3260 * 0.00011721893679350615f))), 0.0f), _2464);
            _3286 = mad(0.15618768334388733f, _3283, mad(0.13400420546531677f, _3282, (_3281 * 0.6624541878700256f)));
            _3289 = mad(0.053689517080783844f, _3283, mad(0.6740817427635193f, _3282, (_3281 * 0.2722287178039551f)));
            _3292 = mad(1.0103391408920288f, _3283, mad(0.00406073359772563f, _3282, (_3281 * -0.005574649665504694f)));
            _3295 = mad(-0.23642469942569733f, _3292, mad(-0.32480329275131226f, _3289, (_3286 * 1.6410233974456787f)));
            _3302 = mad(0.016756348311901093f, _3292, mad(1.6153316497802734f, _3289, (_3286 * -0.663662850856781f))) * 1.25f;
            _3303 = mad(0.9883948564529419f, _3292, mad(-0.008284442126750946f, _3289, (_3286 * 0.011721894145011902f))) * 1.25f;
            _3450 = mad(-0.0832589864730835f, _3303, mad(-0.6217921376228333f, _3302, (_3295 * 2.1313138008117676f)));
            _3451 = mad(-0.010548308491706848f, _3303, mad(1.140804648399353f, _3302, (_3295 * -0.16282059252262115f)));
            _3452 = mad(1.1529725790023804f, _3303, mad(-0.1289689838886261f, _3302, (_3295 * -0.030004188418388367f)));
            break;
          }
        } else {
          if (cb0_042w == 7) {
            _3330 = mad((WorkingColorSpace_128[0].z), _1366, mad((WorkingColorSpace_128[0].y), _1365, ((WorkingColorSpace_128[0].x) * _1364)));
            _3333 = mad((WorkingColorSpace_128[1].z), _1366, mad((WorkingColorSpace_128[1].y), _1365, ((WorkingColorSpace_128[1].x) * _1364)));
            _3336 = mad((WorkingColorSpace_128[2].z), _1366, mad((WorkingColorSpace_128[2].y), _1365, ((WorkingColorSpace_128[2].x) * _1364)));
            _3355 = exp2(log2(mad(_58, _3336, mad(_57, _3333, (_3330 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3356 = exp2(log2(mad(_61, _3336, mad(_60, _3333, (_3330 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3357 = exp2(log2(mad(_64, _3336, mad(_63, _3333, (_3330 * _62))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3450 = exp2(log2((1.0f / ((_3355 * 18.6875f) + 1.0f)) * ((_3355 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3451 = exp2(log2((1.0f / ((_3356 * 18.6875f) + 1.0f)) * ((_3356 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3452 = exp2(log2((1.0f / ((_3357 * 18.6875f) + 1.0f)) * ((_3357 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _3404 = mad((WorkingColorSpace_128[0].z), _1354, mad((WorkingColorSpace_128[0].y), _1353, ((WorkingColorSpace_128[0].x) * _1352)));
                _3407 = mad((WorkingColorSpace_128[1].z), _1354, mad((WorkingColorSpace_128[1].y), _1353, ((WorkingColorSpace_128[1].x) * _1352)));
                _3410 = mad((WorkingColorSpace_128[2].z), _1354, mad((WorkingColorSpace_128[2].y), _1353, ((WorkingColorSpace_128[2].x) * _1352)));
                _3450 = mad(_58, _3410, mad(_57, _3407, (_3404 * _56)));
                _3451 = mad(_61, _3410, mad(_60, _3407, (_3404 * _59)));
                _3452 = mad(_64, _3410, mad(_63, _3407, (_3404 * _62)));
              } else {
                _3423 = mad((WorkingColorSpace_128[0].z), _1380, mad((WorkingColorSpace_128[0].y), _1379, ((WorkingColorSpace_128[0].x) * _1378)));
                _3426 = mad((WorkingColorSpace_128[1].z), _1380, mad((WorkingColorSpace_128[1].y), _1379, ((WorkingColorSpace_128[1].x) * _1378)));
                _3429 = mad((WorkingColorSpace_128[2].z), _1380, mad((WorkingColorSpace_128[2].y), _1379, ((WorkingColorSpace_128[2].x) * _1378)));
                _3450 = exp2(log2(mad(_58, _3429, mad(_57, _3426, (_3423 * _56)))) * cb0_042z);
                _3451 = exp2(log2(mad(_61, _3429, mad(_60, _3426, (_3423 * _59)))) * cb0_042z);
                _3452 = exp2(log2(mad(_64, _3429, mad(_63, _3426, (_3423 * _62)))) * cb0_042z);
              }
            } else {
              _3450 = _1364;
              _3451 = _1365;
              _3452 = _1366;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_3450 * 0.9523810148239136f), (_3451 * 0.9523810148239136f), (_3452 * 0.9523810148239136f), 0.0f);
}
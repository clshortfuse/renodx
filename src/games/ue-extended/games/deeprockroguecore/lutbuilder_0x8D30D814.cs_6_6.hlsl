// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float> t0 : register(t0);

Texture2D<float3> t1 : register(t1);

Texture2D<float> t2 : register(t2);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
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
  float _23;
  float _28;
  float _29;
  float _30;
  float _32;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _118;
  float _119;
  float _120;
  float _175;
  float _382;
  float _383;
  float _384;
  float _907;
  float _940;
  float _954;
  float _1018;
  float _1286;
  float _1287;
  float _1288;
  float _1299;
  float _1310;
  float _1520;
  float _1527;
  float _1534;
  float _1617;
  float _1800;
  float _1823;
  float _1826;
  int _1836;
  int _1837;
  int _1838;
  float _1896;
  float _1926;
  float _1934;
  float _1958;
  float _1964;
  float _2043;
  float _2058;
  float _2066;
  float _2114;
  float _2120;
  float _2121;
  float _2132;
  float _2183;
  float _2190;
  float _2197;
  float _2441;
  float _2448;
  float _2455;
  float _2538;
  float _2721;
  float _2744;
  float _2747;
  int _2757;
  int _2758;
  int _2759;
  float _2817;
  float _2847;
  float _2855;
  float _2879;
  float _2885;
  float _2964;
  float _2979;
  float _2987;
  float _3035;
  float _3041;
  float _3042;
  float _3053;
  float _3104;
  float _3111;
  float _3118;
  float _3316;
  float _3317;
  float _3318;
  bool _41;
  float _71;
  float _72;
  float _73;
  bool _156;
  float _158;
  float _189;
  float _196;
  float _199;
  float _204;
  float _205;
  float _207;
  bool _208;
  float _217;
  float _219;
  float _226;
  float _228;
  float _230;
  float _231;
  float _234;
  float _237;
  float _242;
  float _248;
  float _249;
  float _250;
  float _251;
  float _252;
  float _253;
  float _254;
  float _255;
  float _258;
  float _259;
  float _260;
  float _263;
  float _282;
  float _283;
  float _284;
  float _285;
  float _286;
  float _287;
  float _288;
  float _289;
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
  float _341;
  float _344;
  float _399;
  float _402;
  float _405;
  float _406;
  float _410;
  float _411;
  float _412;
  float _424;
  float _440;
  float _441;
  float _442;
  float _443;
  float _457;
  float _471;
  float _485;
  float _499;
  float _513;
  float _517;
  float _518;
  float _519;
  float _576;
  float _580;
  float _581;
  float _590;
  float _599;
  float _608;
  float _617;
  float _626;
  float _689;
  float _693;
  float _702;
  float _711;
  float _720;
  float _729;
  float _738;
  float _796;
  float _807;
  float _809;
  float _811;
  float _847;
  float _848;
  float _849;
  float _852;
  float _855;
  float _858;
  float _862;
  float _867;
  float _880;
  float _881;
  float _882;
  float _883;
  float _887;
  float _898;
  float _908;
  float _909;
  float _910;
  float _911;
  float _918;
  float _921;
  float _923;
  bool _926;
  bool _927;
  bool _928;
  bool _929;
  float _945;
  float _958;
  float _962;
  float _968;
  float _978;
  float _979;
  float _980;
  float _981;
  float _996;
  float _998;
  float _1000;
  float _1009;
  float _1021;
  float _1023;
  float _1027;
  float _1028;
  float _1029;
  float _1033;
  float _1034;
  float _1035;
  float _1036;
  float _1038;
  float _1039;
  float _1040;
  float _1041;
  float _1060;
  float _1062;
  float _1087;
  float _1088;
  float _1089;
  float _1096;
  float _1100;
  float _1101;
  float _1102;
  bool _1103;
  float _1107;
  float _1108;
  float _1109;
  float _1128;
  float _1129;
  float _1130;
  float _1131;
  float _1151;
  float _1152;
  float _1153;
  float _1169;
  float _1170;
  float _1171;
  float _1181;
  float _1182;
  float _1183;
  float _1209;
  float _1210;
  float _1211;
  float _1218;
  float _1219;
  float _1220;
  float _1221;
  float _1222;
  float _1223;
  float _1230;
  float _1231;
  float _1232;
  float _1244;
  float _1245;
  float _1246;
  float _1269;
  float _1272;
  float _1275;
  float _1337;
  float _1340;
  float _1343;
  float _1346;
  float _1349;
  float _1352;
  float _1397;
  float _1398;
  float _1399;
  float _1402;
  float _1405;
  float _1408;
  float _1409;
  float _1410;
  float _1415;
  float _1430;
  float _1432;
  float _1437;
  float _1478;
  float _1482;
  float _1483;
  float _1484;
  float _1487;
  float _1494;
  float _1495;
  float _1505;
  float _1506;
  float _1507;
  float _1511;
  float _1512;
  float _1513;
  float _1562;
  float _1563;
  float _1564;
  float _1568;
  float _1572;
  float _1574;
  bool _1577;
  bool _1578;
  bool _1579;
  bool _1580;
  float _1589;
  float _1593;
  float _1596;
  float _1599;
  float _1608;
  float _1622;
  float _1637;
  float _1639;
  float _1643;
  float _1644;
  float _1645;
  float _1652;
  float _1653;
  float _1663;
  float _1668;
  float _1683;
  float _1688;
  float _1693;
  float _1708;
  float _1710;
  float _1711;
  float _1713;
  float _1714;
  float _1716;
  float _1718;
  float _1719;
  float _1720;
  float _1721;
  float _1722;
  float _1723;
  float _1738;
  float _1744;
  int _1748;
  int _1750;
  float _1759;
  float _1764;
  float _1765;
  float _1766;
  float _1767;
  float _1768;
  float _1775;
  float _1781;
  float _1785;
  float _1788;
  float _1790;
  float _1801;
  float _1804;
  float _1808;
  float _1811;
  float _1813;
  float _1829;
  float _1832;
  int _1833;
  int _1834;
  bool _1842;
  int _1843;
  int _1844;
  float3 _1851;
  float3 _1855;
  float _1861;
  float _1864;
  float _1878;
  float _1879;
  float _1880;
  float _1882;
  float _1897;
  uint2 _1899;
  float _1903;
  float _1907;
  float _1912;
  float _1913;
  bool _1915;
  float _1916;
  float _1939;
  float _1945;
  bool _1947;
  float _1948;
  float _1969;
  float _1975;
  float _1977;
  float _1981;
  float _1990;
  float _2001;
  float _2003;
  float _2007;
  float _2008;
  float _2014;
  float _2015;
  float _2016;
  int _2017;
  float _2025;
  float _2029;
  float _2044;
  float _2045;
  bool _2047;
  float _2048;
  float _2071;
  float _2077;
  float _2094;
  float _2096;
  float _2097;
  float _2102;
  float _2104;
  float _2122;
  float _2123;
  float _2134;
  float _2136;
  float _2143;
  float _2144;
  float _2145;
  float _2165;
  float _2166;
  float _2167;
  float _2174;
  float _2175;
  float _2176;
  float _2198;
  float _2200;
  float _2202;
  float _2205;
  float _2212;
  float _2213;
  float _2226;
  float _2227;
  float _2228;
  float _2231;
  float _2234;
  float _2237;
  float _2247;
  float _2248;
  float _2249;
  float _2268;
  float _2269;
  float _2270;
  float _2318;
  float _2319;
  float _2320;
  float _2323;
  float _2326;
  float _2329;
  float _2330;
  float _2331;
  float _2336;
  float _2351;
  float _2353;
  float _2358;
  float _2399;
  float _2403;
  float _2404;
  float _2405;
  float _2408;
  float _2415;
  float _2416;
  float _2426;
  float _2427;
  float _2428;
  float _2432;
  float _2433;
  float _2434;
  float _2483;
  float _2484;
  float _2485;
  float _2489;
  float _2493;
  float _2495;
  bool _2498;
  bool _2499;
  bool _2500;
  bool _2501;
  float _2510;
  float _2514;
  float _2517;
  float _2520;
  float _2529;
  float _2543;
  float _2558;
  float _2560;
  float _2564;
  float _2565;
  float _2566;
  float _2573;
  float _2574;
  float _2584;
  float _2589;
  float _2604;
  float _2609;
  float _2614;
  float _2629;
  float _2631;
  float _2632;
  float _2634;
  float _2635;
  float _2637;
  float _2639;
  float _2640;
  float _2641;
  float _2642;
  float _2643;
  float _2644;
  float _2659;
  float _2665;
  int _2669;
  int _2671;
  float _2680;
  float _2685;
  float _2686;
  float _2687;
  float _2688;
  float _2689;
  float _2696;
  float _2702;
  float _2706;
  float _2709;
  float _2711;
  float _2722;
  float _2725;
  float _2729;
  float _2732;
  float _2734;
  float _2750;
  float _2753;
  int _2754;
  int _2755;
  bool _2763;
  int _2764;
  int _2765;
  float3 _2772;
  float3 _2776;
  float _2782;
  float _2785;
  float _2799;
  float _2800;
  float _2801;
  float _2803;
  float _2818;
  uint2 _2820;
  float _2824;
  float _2828;
  float _2833;
  float _2834;
  bool _2836;
  float _2837;
  float _2860;
  float _2866;
  bool _2868;
  float _2869;
  float _2890;
  float _2896;
  float _2898;
  float _2902;
  float _2911;
  float _2922;
  float _2924;
  float _2928;
  float _2929;
  float _2935;
  float _2936;
  float _2937;
  int _2938;
  float _2946;
  float _2950;
  float _2965;
  float _2966;
  bool _2968;
  float _2969;
  float _2992;
  float _2998;
  float _3015;
  float _3017;
  float _3018;
  float _3023;
  float _3025;
  float _3043;
  float _3044;
  float _3055;
  float _3057;
  float _3064;
  float _3065;
  float _3066;
  float _3086;
  float _3087;
  float _3088;
  float _3095;
  float _3096;
  float _3097;
  float _3119;
  float _3121;
  float _3123;
  float _3126;
  float _3133;
  float _3134;
  float _3147;
  float _3148;
  float _3149;
  float _3152;
  float _3155;
  float _3158;
  float _3161;
  float _3168;
  float _3169;
  float _3196;
  float _3199;
  float _3202;
  float _3221;
  float _3222;
  float _3223;
  float _3270;
  float _3273;
  float _3276;
  float _3289;
  float _3292;
  float _3295;
  _23 = 0.5f / cb0_037x;
  _28 = cb0_037x + -1.0f;
  _29 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _23)) / _28;
  _30 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _23)) / _28;
  _32 = float((uint)SV_DispatchThreadID.z) / _28;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _41 = (cb0_043x == 4);
        _52 = select(_41, 1.0f, 1.705051064491272f);
        _53 = select(_41, 0.0f, -0.6217921376228333f);
        _54 = select(_41, 0.0f, -0.0832589864730835f);
        _55 = select(_41, 0.0f, -0.13025647401809692f);
        _56 = select(_41, 1.0f, 1.140804648399353f);
        _57 = select(_41, 0.0f, -0.010548308491706848f);
        _58 = select(_41, 0.0f, -0.024003351107239723f);
        _59 = select(_41, 0.0f, -0.1289689838886261f);
        _60 = select(_41, 1.0f, 1.1529725790023804f);
      } else {
        _52 = 0.6954522132873535f;
        _53 = 0.14067870378494263f;
        _54 = 0.16386906802654266f;
        _55 = 0.044794563204050064f;
        _56 = 0.8596711158752441f;
        _57 = 0.0955343171954155f;
        _58 = -0.005525882821530104f;
        _59 = 0.004025210160762072f;
        _60 = 1.0015007257461548f;
      }
    } else {
      _52 = 1.0258246660232544f;
      _53 = -0.020053181797266006f;
      _54 = -0.005771636962890625f;
      _55 = -0.002234415616840124f;
      _56 = 1.0045864582061768f;
      _57 = -0.002352118492126465f;
      _58 = -0.005013350863009691f;
      _59 = -0.025290070101618767f;
      _60 = 1.0303035974502563f;
    }
  } else {
    _52 = 1.3792141675949097f;
    _53 = -0.30886411666870117f;
    _54 = -0.0703500509262085f;
    _55 = -0.06933490186929703f;
    _56 = 1.08229660987854f;
    _57 = -0.012961871922016144f;
    _58 = -0.0021590073592960835f;
    _59 = -0.0454593189060688f;
    _60 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _71 = (pow(_29, 0.012683313339948654f));
    _72 = (pow(_30, 0.012683313339948654f));
    _73 = (pow(_32, 0.012683313339948654f));
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _118 = ((exp2((_29 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _119 = ((exp2((_30 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _120 = ((exp2((_32 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _156 = (cb0_040w != 0);
    _158 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _175 = (((((1901800.0f - (_158 * 2006400000.0f)) * _158) + 247.47999572753906f) * _158) + 0.23703999817371368f);
    } else {
      _175 = (((((2967800.0f - (_158 * 4607000064.0f)) * _158) + 99.11000061035156f) * _158) + 0.24406300485134125f);
    }
    _189 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _196 = cb0_037y * cb0_037y;
    _199 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_196 * 1.6145605741257896e-07f));
    _204 = ((_189 * 2.0f) + 4.0f) - (_199 * 8.0f);
    _205 = (_189 * 3.0f) / _204;
    _207 = (_199 * 2.0f) / _204;
    _208 = (cb0_037y < 4000.0f);
    _217 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _219 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_196 * 1.5317699909210205f)) / (_217 * _217);
    _226 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _196;
    _228 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_196 * 308.60699462890625f)) / (_226 * _226);
    _230 = rsqrt(dot(float2(_219, _228), float2(_219, _228)));
    _231 = cb0_037z * 0.05000000074505806f;
    _234 = ((_231 * _228) * _230) + _189;
    _237 = _199 - ((_231 * _219) * _230);
    _242 = (4.0f - (_237 * 8.0f)) + (_234 * 2.0f);
    _248 = (((_234 * 3.0f) / _242) - _205) + select(_208, _205, _175);
    _249 = (((_237 * 2.0f) / _242) - _207) + select(_208, _207, (((_175 * 2.869999885559082f) + -0.2750000059604645f) - ((_175 * _175) * 3.0f)));
    _250 = select(_156, _248, 0.3127000033855438f);
    _251 = select(_156, _249, 0.32899999618530273f);
    _252 = select(_156, 0.3127000033855438f, _248);
    _253 = select(_156, 0.32899999618530273f, _249);
    _254 = max(_251, 1.000000013351432e-10f);
    _255 = _250 / _254;
    _258 = ((1.0f - _250) - _251) / _254;
    _259 = max(_253, 1.000000013351432e-10f);
    _260 = _252 / _259;
    _263 = ((1.0f - _252) - _253) / _259;
    _282 = mad(-0.16140000522136688f, _263, ((_260 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _258, ((_255 * 0.8950999975204468f) + 0.266400009393692f));
    _283 = mad(0.03669999912381172f, _263, (1.7135000228881836f - (_260 * 0.7501999735832214f))) / mad(0.03669999912381172f, _258, (1.7135000228881836f - (_255 * 0.7501999735832214f)));
    _284 = mad(1.0296000242233276f, _263, ((_260 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _258, ((_255 * 0.03889999911189079f) + -0.06849999725818634f));
    _285 = mad(_283, -0.7501999735832214f, 0.0f);
    _286 = mad(_283, 1.7135000228881836f, 0.0f);
    _287 = mad(_283, 0.03669999912381172f, -0.0f);
    _288 = mad(_284, 0.03889999911189079f, 0.0f);
    _289 = mad(_284, -0.06849999725818634f, 0.0f);
    _290 = mad(_284, 1.0296000242233276f, 0.0f);
    _293 = mad(0.1599626988172531f, _288, mad(-0.1470542997121811f, _285, (_282 * 0.883457362651825f)));
    _296 = mad(0.1599626988172531f, _289, mad(-0.1470542997121811f, _286, (_282 * 0.26293492317199707f)));
    _299 = mad(0.1599626988172531f, _290, mad(-0.1470542997121811f, _287, (_282 * -0.15930065512657166f)));
    _302 = mad(0.04929120093584061f, _288, mad(0.5183603167533875f, _285, (_282 * 0.38695648312568665f)));
    _305 = mad(0.04929120093584061f, _289, mad(0.5183603167533875f, _286, (_282 * 0.11516613513231277f)));
    _308 = mad(0.04929120093584061f, _290, mad(0.5183603167533875f, _287, (_282 * -0.0697740763425827f)));
    _311 = mad(0.9684867262840271f, _288, mad(0.04004279896616936f, _285, (_282 * -0.007634039502590895f)));
    _314 = mad(0.9684867262840271f, _289, mad(0.04004279896616936f, _286, (_282 * -0.0022720457054674625f)));
    _317 = mad(0.9684867262840271f, _290, mad(0.04004279896616936f, _287, (_282 * 0.0013765322510153055f)));
    _320 = mad(_299, (WorkingColorSpace_000[2].x), mad(_296, (WorkingColorSpace_000[1].x), (_293 * (WorkingColorSpace_000[0].x))));
    _323 = mad(_299, (WorkingColorSpace_000[2].y), mad(_296, (WorkingColorSpace_000[1].y), (_293 * (WorkingColorSpace_000[0].y))));
    _326 = mad(_299, (WorkingColorSpace_000[2].z), mad(_296, (WorkingColorSpace_000[1].z), (_293 * (WorkingColorSpace_000[0].z))));
    _329 = mad(_308, (WorkingColorSpace_000[2].x), mad(_305, (WorkingColorSpace_000[1].x), (_302 * (WorkingColorSpace_000[0].x))));
    _332 = mad(_308, (WorkingColorSpace_000[2].y), mad(_305, (WorkingColorSpace_000[1].y), (_302 * (WorkingColorSpace_000[0].y))));
    _335 = mad(_308, (WorkingColorSpace_000[2].z), mad(_305, (WorkingColorSpace_000[1].z), (_302 * (WorkingColorSpace_000[0].z))));
    _338 = mad(_317, (WorkingColorSpace_000[2].x), mad(_314, (WorkingColorSpace_000[1].x), (_311 * (WorkingColorSpace_000[0].x))));
    _341 = mad(_317, (WorkingColorSpace_000[2].y), mad(_314, (WorkingColorSpace_000[1].y), (_311 * (WorkingColorSpace_000[0].y))));
    _344 = mad(_317, (WorkingColorSpace_000[2].z), mad(_314, (WorkingColorSpace_000[1].z), (_311 * (WorkingColorSpace_000[0].z))));
    _382 = mad(mad((WorkingColorSpace_064[0].z), _344, mad((WorkingColorSpace_064[0].y), _335, (_326 * (WorkingColorSpace_064[0].x)))), _120, mad(mad((WorkingColorSpace_064[0].z), _341, mad((WorkingColorSpace_064[0].y), _332, (_323 * (WorkingColorSpace_064[0].x)))), _119, (mad((WorkingColorSpace_064[0].z), _338, mad((WorkingColorSpace_064[0].y), _329, (_320 * (WorkingColorSpace_064[0].x)))) * _118)));
    _383 = mad(mad((WorkingColorSpace_064[1].z), _344, mad((WorkingColorSpace_064[1].y), _335, (_326 * (WorkingColorSpace_064[1].x)))), _120, mad(mad((WorkingColorSpace_064[1].z), _341, mad((WorkingColorSpace_064[1].y), _332, (_323 * (WorkingColorSpace_064[1].x)))), _119, (mad((WorkingColorSpace_064[1].z), _338, mad((WorkingColorSpace_064[1].y), _329, (_320 * (WorkingColorSpace_064[1].x)))) * _118)));
    _384 = mad(mad((WorkingColorSpace_064[2].z), _344, mad((WorkingColorSpace_064[2].y), _335, (_326 * (WorkingColorSpace_064[2].x)))), _120, mad(mad((WorkingColorSpace_064[2].z), _341, mad((WorkingColorSpace_064[2].y), _332, (_323 * (WorkingColorSpace_064[2].x)))), _119, (mad((WorkingColorSpace_064[2].z), _338, mad((WorkingColorSpace_064[2].y), _329, (_320 * (WorkingColorSpace_064[2].x)))) * _118)));
  } else {
    _382 = _118;
    _383 = _119;
    _384 = _120;
  }
  _399 = mad((WorkingColorSpace_128[0].z), _384, mad((WorkingColorSpace_128[0].y), _383, ((WorkingColorSpace_128[0].x) * _382)));
  _402 = mad((WorkingColorSpace_128[1].z), _384, mad((WorkingColorSpace_128[1].y), _383, ((WorkingColorSpace_128[1].x) * _382)));
  _405 = mad((WorkingColorSpace_128[2].z), _384, mad((WorkingColorSpace_128[2].y), _383, ((WorkingColorSpace_128[2].x) * _382)));
  _406 = dot(float3(_399, _402, _405), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _410 = (_399 / _406) + -1.0f;
  _411 = (_402 / _406) + -1.0f;
  _412 = (_405 / _406) + -1.0f;
  _424 = (1.0f - exp2(((_406 * _406) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_410, _411, _412), float3(_410, _411, _412)) * -4.0f));
  _440 = ((mad(-0.06368321925401688f, _405, mad(-0.3292922377586365f, _402, (_399 * 1.3704125881195068f))) - _399) * _424) + _399;
  _441 = ((mad(-0.010861365124583244f, _405, mad(1.0970927476882935f, _402, (_399 * -0.08343357592821121f))) - _402) * _424) + _402;
  _442 = ((mad(1.2036951780319214f, _405, mad(-0.09862580895423889f, _402, (_399 * -0.02579331398010254f))) - _405) * _424) + _405;
  _443 = dot(float3(_440, _441, _442), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _457 = cb0_021w + cb0_026w;
  _471 = cb0_020w * cb0_025w;
  _485 = cb0_019w * cb0_024w;
  _499 = cb0_018w * cb0_023w;
  _513 = cb0_017w * cb0_022w;
  _517 = _440 - _443;
  _518 = _441 - _443;
  _519 = _442 - _443;
  _576 = saturate(_443 / cb0_037w);
  _580 = (_576 * _576) * (3.0f - (_576 * 2.0f));
  _581 = 1.0f - _580;
  _590 = cb0_021w + cb0_036w;
  _599 = cb0_020w * cb0_035w;
  _608 = cb0_019w * cb0_034w;
  _617 = cb0_018w * cb0_033w;
  _626 = cb0_017w * cb0_032w;
  _689 = saturate((_443 - cb0_038x) / (cb0_038y - cb0_038x));
  _693 = (_689 * _689) * (3.0f - (_689 * 2.0f));
  _702 = cb0_021w + cb0_031w;
  _711 = cb0_020w * cb0_030w;
  _720 = cb0_019w * cb0_029w;
  _729 = cb0_018w * cb0_028w;
  _738 = cb0_017w * cb0_027w;
  _796 = _580 - _693;
  _807 = ((_693 * (((cb0_021x + cb0_036x) + _590) + (((cb0_020x * cb0_035x) * _599) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _617) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _626) * _517) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _608)))))) + (_581 * (((cb0_021x + cb0_026x) + _457) + (((cb0_020x * cb0_025x) * _471) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _499) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _513) * _517) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _485))))))) + ((((cb0_021x + cb0_031x) + _702) + (((cb0_020x * cb0_030x) * _711) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _729) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _738) * _517) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _720))))) * _796);
  _809 = ((_693 * (((cb0_021y + cb0_036y) + _590) + (((cb0_020y * cb0_035y) * _599) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _617) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _626) * _518) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _608)))))) + (_581 * (((cb0_021y + cb0_026y) + _457) + (((cb0_020y * cb0_025y) * _471) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _499) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _513) * _518) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _485))))))) + ((((cb0_021y + cb0_031y) + _702) + (((cb0_020y * cb0_030y) * _711) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _729) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _738) * _518) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _720))))) * _796);
  _811 = ((_693 * (((cb0_021z + cb0_036z) + _590) + (((cb0_020z * cb0_035z) * _599) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _617) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _626) * _519) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _608)))))) + (_581 * (((cb0_021z + cb0_026z) + _457) + (((cb0_020z * cb0_025z) * _471) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _499) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _513) * _519) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _485))))))) + ((((cb0_021z + cb0_031z) + _702) + (((cb0_020z * cb0_030z) * _711) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _729) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _738) * _519) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _720))))) * _796);

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
  float4 output = ProcessLutbuilder(float3(_807, _809, _811), cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _847 = ((mad(0.061360642313957214f, _811, mad(-4.540197551250458e-09f, _809, (_807 * 0.9386394023895264f))) - _807) * cb0_038z) + _807;
  _848 = ((mad(0.169205904006958f, _811, mad(0.8307942152023315f, _809, (_807 * 6.775371730327606e-08f))) - _809) * cb0_038z) + _809;
  _849 = (mad(-2.3283064365386963e-10f, _809, (_807 * -9.313225746154785e-10f)) * cb0_038z) + _811;
  _852 = mad(0.16386905312538147f, _849, mad(0.14067868888378143f, _848, (_847 * 0.6954522132873535f)));
  _855 = mad(0.0955343246459961f, _849, mad(0.8596711158752441f, _848, (_847 * 0.044794581830501556f)));
  _858 = mad(1.0015007257461548f, _849, mad(0.004025210160762072f, _848, (_847 * -0.005525882821530104f)));
  _862 = max(max(_852, _855), _858);
  _867 = (max(_862, 1.000000013351432e-10f) - max(min(min(_852, _855), _858), 1.000000013351432e-10f)) / max(_862, 0.009999999776482582f);
  _880 = ((_855 + _852) + _858) + (sqrt((((_858 - _855) * _858) + ((_855 - _852) * _855)) + ((_852 - _858) * _852)) * 1.75f);
  _881 = _880 * 0.3333333432674408f;
  _882 = _867 + -0.4000000059604645f;
  _883 = _882 * 5.0f;
  _887 = max((1.0f - abs(_882 * 2.5f)), 0.0f);
  _898 = ((float((int)(((int)(uint)((int)(_883 > 0.0f))) - ((int)(uint)((int)(_883 < 0.0f))))) * (1.0f - (_887 * _887))) + 1.0f) * 0.02500000037252903f;
  if (_881 > 0.0533333346247673f) {
    if (_881 < 0.1599999964237213f) {
      _907 = (((0.23999999463558197f / _880) + -0.5f) * _898);
    } else {
      _907 = 0.0f;
    }
  } else {
    _907 = _898;
  }
  _908 = _907 + 1.0f;
  _909 = _908 * _852;
  _910 = _908 * _855;
  _911 = _908 * _858;
  if (!((_909 == _910) && (_910 == _911))) {
    _918 = ((_909 * 2.0f) - _910) - _911;
    _921 = ((_855 - _858) * 1.7320507764816284f) * _908;
    _923 = atan(_921 / _918);
    _926 = (_918 < 0.0f);
    _927 = (_918 == 0.0f);
    _928 = (_921 >= 0.0f);
    _929 = (_921 < 0.0f);
    _940 = select((_928 && _927), 90.0f, select((_929 && _927), -90.0f, (select((_929 && _926), (_923 + -3.1415927410125732f), select((_928 && _926), (_923 + 3.1415927410125732f), _923)) * 57.2957763671875f)));
  } else {
    _940 = 0.0f;
  }
  _945 = min(max(select((_940 < 0.0f), (_940 + 360.0f), _940), 0.0f), 360.0f);
  if (_945 < -180.0f) {
    _954 = (_945 + 360.0f);
  } else {
    if (_945 > 180.0f) {
      _954 = (_945 + -360.0f);
    } else {
      _954 = _945;
    }
  }
  _958 = saturate(1.0f - abs(_954 * 0.014814814552664757f));
  _962 = (_958 * _958) * (3.0f - (_958 * 2.0f));
  _968 = ((_962 * _962) * ((_867 * 0.18000000715255737f) * (0.029999999329447746f - _909))) + _909;
  _978 = max(0.0f, mad(-0.21492856740951538f, _911, mad(-0.2365107536315918f, _910, (_968 * 1.4514392614364624f))));
  _979 = max(0.0f, mad(-0.09967592358589172f, _911, mad(1.17622971534729f, _910, (_968 * -0.07655377686023712f))));
  _980 = max(0.0f, mad(0.9977163076400757f, _911, mad(-0.006032449658960104f, _910, (_968 * 0.008316148072481155f))));
  _981 = dot(float3(_978, _979, _980), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _996 = (cb0_040x + 1.0f) - cb0_039z;
  _998 = cb0_040y + 1.0f;
  _1000 = _998 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1018 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1009 = (cb0_040x + 0.18000000715255737f) / _996;
    _1018 = (-0.7447274923324585f - ((log2(_1009 / (2.0f - _1009)) * 0.3465735912322998f) * (_996 / cb0_039y)));
  }
  _1021 = ((1.0f - cb0_039z) / cb0_039y) - _1018;
  _1023 = (cb0_039w / cb0_039y) - _1021;
  _1027 = log2(lerp(_981, _978, 0.9599999785423279f)) * 0.3010300099849701f;
  _1028 = log2(lerp(_981, _979, 0.9599999785423279f)) * 0.3010300099849701f;
  _1029 = log2(lerp(_981, _980, 0.9599999785423279f)) * 0.3010300099849701f;
  _1033 = cb0_039y * (_1027 + _1021);
  _1034 = cb0_039y * (_1028 + _1021);
  _1035 = cb0_039y * (_1029 + _1021);
  _1036 = _996 * 2.0f;
  _1038 = (cb0_039y * -2.0f) / _996;
  _1039 = _1027 - _1018;
  _1040 = _1028 - _1018;
  _1041 = _1029 - _1018;
  _1060 = _1000 * 2.0f;
  _1062 = (cb0_039y * 2.0f) / _1000;
  _1087 = select((_1027 < _1018), ((_1036 / (exp2((_1039 * 1.4426950216293335f) * _1038) + 1.0f)) - cb0_040x), _1033);
  _1088 = select((_1028 < _1018), ((_1036 / (exp2((_1040 * 1.4426950216293335f) * _1038) + 1.0f)) - cb0_040x), _1034);
  _1089 = select((_1029 < _1018), ((_1036 / (exp2((_1041 * 1.4426950216293335f) * _1038) + 1.0f)) - cb0_040x), _1035);
  _1096 = _1023 - _1018;
  _1100 = saturate(_1039 / _1096);
  _1101 = saturate(_1040 / _1096);
  _1102 = saturate(_1041 / _1096);
  _1103 = (_1023 < _1018);
  _1107 = select(_1103, (1.0f - _1100), _1100);
  _1108 = select(_1103, (1.0f - _1101), _1101);
  _1109 = select(_1103, (1.0f - _1102), _1102);
  _1128 = (((_1107 * _1107) * (select((_1027 > _1023), (_998 - (_1060 / (exp2(((_1027 - _1023) * 1.4426950216293335f) * _1062) + 1.0f))), _1033) - _1087)) * (3.0f - (_1107 * 2.0f))) + _1087;
  _1129 = (((_1108 * _1108) * (select((_1028 > _1023), (_998 - (_1060 / (exp2(((_1028 - _1023) * 1.4426950216293335f) * _1062) + 1.0f))), _1034) - _1088)) * (3.0f - (_1108 * 2.0f))) + _1088;
  _1130 = (((_1109 * _1109) * (select((_1029 > _1023), (_998 - (_1060 / (exp2(((_1029 - _1023) * 1.4426950216293335f) * _1062) + 1.0f))), _1035) - _1089)) * (3.0f - (_1109 * 2.0f))) + _1089;
  _1131 = dot(float3(_1128, _1129, _1130), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1151 = (cb0_039x * (max(0.0f, (lerp(_1131, _1128, 0.9300000071525574f))) - _847)) + _847;
  _1152 = (cb0_039x * (max(0.0f, (lerp(_1131, _1129, 0.9300000071525574f))) - _848)) + _848;
  _1153 = (cb0_039x * (max(0.0f, (lerp(_1131, _1130, 0.9300000071525574f))) - _849)) + _849;
  _1169 = ((mad(-0.06537103652954102f, _1153, mad(1.451815478503704e-06f, _1152, (_1151 * 1.065374732017517f))) - _1151) * cb0_038z) + _1151;
  _1170 = ((mad(-0.20366770029067993f, _1153, mad(1.2036634683609009f, _1152, (_1151 * -2.57161445915699e-07f))) - _1152) * cb0_038z) + _1152;
  _1171 = ((mad(0.9999996423721313f, _1153, mad(2.0954757928848267e-08f, _1152, (_1151 * 1.862645149230957e-08f))) - _1153) * cb0_038z) + _1153;
  _1181 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1171, mad((WorkingColorSpace_192[0].y), _1170, ((WorkingColorSpace_192[0].x) * _1169))));
  _1182 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1171, mad((WorkingColorSpace_192[1].y), _1170, ((WorkingColorSpace_192[1].x) * _1169))));
  _1183 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1171, mad((WorkingColorSpace_192[2].y), _1170, ((WorkingColorSpace_192[2].x) * _1169))));
  _1209 = cb0_016x * (((cb0_041y + (cb0_041x * _1181)) * _1181) + cb0_041z);
  _1210 = cb0_016y * (((cb0_041y + (cb0_041x * _1182)) * _1182) + cb0_041z);
  _1211 = cb0_016z * (((cb0_041y + (cb0_041x * _1183)) * _1183) + cb0_041z);
  _1218 = ((cb0_015x - _1209) * cb0_015w) + _1209;
  _1219 = ((cb0_015y - _1210) * cb0_015w) + _1210;
  _1220 = ((cb0_015z - _1211) * cb0_015w) + _1211;
  _1221 = cb0_016x * mad((WorkingColorSpace_192[0].z), _811, mad((WorkingColorSpace_192[0].y), _809, (_807 * (WorkingColorSpace_192[0].x))));
  _1222 = cb0_016y * mad((WorkingColorSpace_192[1].z), _811, mad((WorkingColorSpace_192[1].y), _809, ((WorkingColorSpace_192[1].x) * _807)));
  _1223 = cb0_016z * mad((WorkingColorSpace_192[2].z), _811, mad((WorkingColorSpace_192[2].y), _809, ((WorkingColorSpace_192[2].x) * _807)));
  _1230 = ((cb0_015x - _1221) * cb0_015w) + _1221;
  _1231 = ((cb0_015y - _1222) * cb0_015w) + _1222;
  _1232 = ((cb0_015z - _1223) * cb0_015w) + _1223;
  _1244 = exp2(log2(max(0.0f, _1218)) * cb0_042y);
  _1245 = exp2(log2(max(0.0f, _1219)) * cb0_042y);
  _1246 = exp2(log2(max(0.0f, _1220)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1269 = mad((WorkingColorSpace_128[0].z), _1246, mad((WorkingColorSpace_128[0].y), _1245, ((WorkingColorSpace_128[0].x) * _1244)));
      _1272 = mad((WorkingColorSpace_128[1].z), _1246, mad((WorkingColorSpace_128[1].y), _1245, ((WorkingColorSpace_128[1].x) * _1244)));
      _1275 = mad((WorkingColorSpace_128[2].z), _1246, mad((WorkingColorSpace_128[2].y), _1245, ((WorkingColorSpace_128[2].x) * _1244)));
      _1286 = mad(_54, _1275, mad(_53, _1272, (_1269 * _52)));
      _1287 = mad(_57, _1275, mad(_56, _1272, (_1269 * _55)));
      _1288 = mad(_60, _1275, mad(_59, _1272, (_1269 * _58)));
    } else {
      _1286 = _1244;
      _1287 = _1245;
      _1288 = _1246;
    }
    if (_1286 < 0.0031306699384003878f) {
      _1299 = (_1286 * 12.920000076293945f);
    } else {
      _1299 = (((pow(_1286, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1287 < 0.0031306699384003878f) {
      _1310 = (_1287 * 12.920000076293945f);
    } else {
      _1310 = (((pow(_1287, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1288 < 0.0031306699384003878f) {
      _3316 = _1299;
      _3317 = _1310;
      _3318 = (_1288 * 12.920000076293945f);
    } else {
      _3316 = _1299;
      _3317 = _1310;
      _3318 = (((pow(_1288, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1337 = mad((WorkingColorSpace_128[0].z), _1246, mad((WorkingColorSpace_128[0].y), _1245, ((WorkingColorSpace_128[0].x) * _1244)));
      _1340 = mad((WorkingColorSpace_128[1].z), _1246, mad((WorkingColorSpace_128[1].y), _1245, ((WorkingColorSpace_128[1].x) * _1244)));
      _1343 = mad((WorkingColorSpace_128[2].z), _1246, mad((WorkingColorSpace_128[2].y), _1245, ((WorkingColorSpace_128[2].x) * _1244)));
      _1346 = mad(_54, _1343, mad(_53, _1340, (_1337 * _52)));
      _1349 = mad(_57, _1343, mad(_56, _1340, (_1337 * _55)));
      _1352 = mad(_60, _1343, mad(_59, _1340, (_1337 * _58)));
      _3316 = min((_1346 * 4.5f), ((exp2(log2(max(_1346, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3317 = min((_1349 * 4.5f), ((exp2(log2(max(_1349, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3318 = min((_1352 * 4.5f), ((exp2(log2(max(_1352, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
        _1397 = cb0_012z * _1230;
        _1398 = cb0_012z * _1231;
        _1399 = cb0_012z * _1232;
        _1402 = mad((WorkingColorSpace_256[0].z), _1399, mad((WorkingColorSpace_256[0].y), _1398, (_1397 * (WorkingColorSpace_256[0].x))));
        _1405 = mad((WorkingColorSpace_256[1].z), _1399, mad((WorkingColorSpace_256[1].y), _1398, (_1397 * (WorkingColorSpace_256[1].x))));
        _1408 = mad((WorkingColorSpace_256[2].z), _1399, mad((WorkingColorSpace_256[2].y), _1398, (_1397 * (WorkingColorSpace_256[2].x))));
        _1409 = cb0_043y * 0.009999999776482582f;
        _1410 = log2(_1409);
        _1415 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
        _1430 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_1415 * 400.0f) / (_1415 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1432 = (_1410 * 1.4018198251724243f) + 10.012999534606934f;
        _1437 = exp2(log2(abs(_1432) * 0.00793700572103262f) * 0.41999998688697815f);
        _1478 = (_1410 * 924.7640991210938f) + 1024.0f;
        _1482 = min(max(mad(-0.21492856740951538f, _1408, mad(-0.2365107536315918f, _1405, (_1402 * 1.4514392614364624f))), 0.0f), _1478);
        _1483 = min(max(mad(-0.09967592358589172f, _1408, mad(1.17622971534729f, _1405, (_1402 * -0.07655377686023712f))), 0.0f), _1478);
        _1484 = min(max(mad(0.9977163076400757f, _1408, mad(-0.006032449658960104f, _1405, (_1402 * 0.008316148072481155f))), 0.0f), _1478);
        _1487 = mad(0.15618768334388733f, _1484, mad(0.13400420546531677f, _1483, (_1482 * 0.6624541878700256f)));
        _1494 = mad(0.053689517080783844f, _1484, mad(0.6740817427635193f, _1483, (_1482 * 0.2722287178039551f))) * 100.0f;
        _1495 = mad(1.0103391408920288f, _1484, mad(0.00406073359772563f, _1483, (_1482 * -0.005574649665504694f))) * 100.0f;
        _1505 = mad(0.04110127314925194f, _1495, mad(0.594700813293457f, _1494, (_1487 * 36.407447814941406f))) * 1.0172951221466064f;
        _1506 = mad(0.1479453295469284f, _1495, mad(1.0738555192947388f, _1494, (_1487 * -22.224510192871094f))) * 0.9887425899505615f;
        _1507 = mad(0.9503875374794006f, _1495, mad(0.04882604628801346f, _1494, (_1487 * -0.20676189661026f))) * 0.9944003820419312f;
        _1511 = abs(_1505) * 0.00793700572103262f;
        _1512 = abs(_1506) * 0.00793700572103262f;
        _1513 = abs(_1507) * 0.00793700572103262f;
        if (!(_1511 < 0.0f)) {
          _1520 = (pow(_1511, 0.41999998688697815f));
        } else {
          _1520 = 0.0f;
        }
        if (!(_1512 < 0.0f)) {
          _1527 = (pow(_1512, 0.41999998688697815f));
        } else {
          _1527 = 0.0f;
        }
        if (!(_1513 < 0.0f)) {
          _1534 = (pow(_1513, 0.41999998688697815f));
        } else {
          _1534 = 0.0f;
        }
        _1562 = ((float((int)(((int)(uint)((int)(_1505 > 0.0f))) - ((int)(uint)((int)(_1505 < 0.0f))))) * 400.0f) * _1520) / (_1520 + 27.1299991607666f);
        _1563 = ((float((int)(((int)(uint)((int)(_1506 > 0.0f))) - ((int)(uint)((int)(_1506 < 0.0f))))) * 400.0f) * _1527) / (_1527 + 27.1299991607666f);
        _1564 = ((float((int)(((int)(uint)((int)(_1507 > 0.0f))) - ((int)(uint)((int)(_1507 < 0.0f))))) * 400.0f) * _1534) / (_1534 + 27.1299991607666f);
        _1568 = (_1562 - (_1563 * 1.0909091234207153f)) + (_1564 * 0.09090909361839294f);
        _1572 = ((_1563 + _1562) - (_1564 * 2.0f)) * 0.1111111119389534f;
        _1574 = atan(_1572 / _1568);
        _1577 = (_1568 < 0.0f);
        _1578 = (_1568 == 0.0f);
        _1579 = (_1572 >= 0.0f);
        _1580 = (_1572 < 0.0f);
        _1589 = select((_1578 && _1579), 0.25f, select((_1578 && _1580), -0.25f, (select((_1577 && _1580), (_1574 + -3.1415927410125732f), select((_1577 && _1579), (_1574 + 3.1415927410125732f), _1574)) * 0.15915493667125702f)));
        _1593 = frac(abs(_1589));
        _1596 = select((_1589 >= (-0.0f - _1589)), _1593, (-0.0f - _1593)) * 360.0f;
        _1599 = select((_1596 < 0.0f), (_1596 + 360.0f), _1596);
        _1608 = exp2(log2((((_1562 * 2.0f) + _1563) + (_1564 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
        if (!(_1608 == 0.0f)) {
          _1617 = (sqrt((_1572 * _1572) + (_1568 * _1568)) * 38.70000076293945f);
        } else {
          _1617 = 0.0f;
        }
        _1622 = exp2(log2(abs(_1608) * 0.009999999776482582f) * 0.8794641494750977f);
        _1637 = (float((int)(((int)(uint)((int)(_1608 > 0.0f))) - ((int)(uint)((int)(_1608 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_1622 * 351.2578430175781f) / (400.0f - (_1622 * 12.947211265563965f))) * 2.3809523582458496f);
        _1639 = (_1410 * 115.59551239013672f) + 128.0f;
        _1643 = sqrt((_1409 + 0.1599999964237213f) * _1409) + _1409;
        _1644 = _1643 * 0.5f;
        _1645 = _1639 / _1644;
        _1652 = _1410 * 0.014018198475241661f;
        _1653 = _1652 + 0.10012999176979065f;
        _1663 = exp2(log2((((_1653 + sqrt(_1653 * (_1652 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_1639 / (_1644 * (_1645 + 1.0f))) * 1.149999976158142f)) / _1644) * 0.8695652484893799f);
        _1668 = 0.18000000715255737f / (((_1643 * -0.5f) * _1663) / (_1663 + -1.0f));
        _1683 = exp2(log2(max(0.0f, _1637) / ((_1668 * _1644) + _1637)) * 1.149999976158142f) * (_1644 / exp2(log2(_1639 / ((_1645 + _1668) * _1644)) * 1.149999976158142f));
        _1688 = max(0.0f, ((_1683 * _1683) / (_1683 + 0.03999999910593033f))) * 100.0f;
        _1693 = exp2(log2(abs(_1688) * 0.00793700572103262f) * 0.41999998688697815f);
        _1708 = (float((int)(((int)(uint)((int)(_1688 > 0.0f))) - ((int)(uint)((int)(_1688 < 0.0f))))) * 100.0f) * exp2(log2(((_1693 * 400.0f) / (_1693 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
        _1710 = _1599 * 0.0027777778450399637f;
        _1711 = -0.0f - _1710;
        _1713 = frac(abs(_1710));
        _1714 = -0.0f - _1713;
        if (!(_1617 == 0.0f)) {
          _1716 = _1708 / _1430;
          _1718 = max(0.0f, (1.0f - _1716));
          _1719 = _1599 * 0.01745329424738884f;
          _1720 = cos(_1719);
          _1721 = sin(_1719);
          _1722 = _1720 * _1720;
          _1723 = _1721 * _1721;
          _1738 = ((((77.12895965576172f - ((_1720 * 12.74448013305664f) * _1721)) + ((_1722 - _1723) * 16.468990325927734f)) + (((_1722 * 31.535200119018555f) + -12.31067943572998f) * _1720)) + ((42.245330810546875f - (_1723 * 36.774559020996094f)) * _1721)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
          _1744 = select((_1710 >= _1711), _1713, _1714) * 360.0f;
          _1748 = int(select((_1744 < 0.0f), (_1744 + 360.0f), _1744));
          _1750 = (_1748 + 1) % 360;
          _1759 = t0.Load(int3(_1748, 0, 0));
          _1764 = (((((t0.Load(int3(_1750, 0, 0))).x) - _1759.x) * ((_1599 - float((int)(_1748))) / float((int)(_1750 - _1748)))) + _1759.x) * (pow(_1716, 0.8794641494750977f));
          _1765 = _1764 / _1738;
          _1766 = _1765 + -0.0010000000474974513f;
          _1767 = _1718 * max(0.20000000298023224f, (1.2999999523162842f - (_1410 * 0.270023912191391f)));
          _1768 = _1716 * ((_1410 * 2.384157657623291f) + 2.4000000953674316f);
          _1775 = (_1764 - (exp2(log2(_1708 / _1608) * 0.8794641494750977f) * _1617)) / _1738;
          if (!(_1775 > _1766)) {
            _1781 = max(sqrt((_1716 * _1716) + (0.5f / cb0_043y)), 0.0010000000474974513f);
            _1785 = sqrt((_1781 * _1781) + (_1767 * _1767));
            _1788 = (_1785 + _1766) / (_1781 + _1766);
            _1790 = (_1788 * _1775) - _1785;
            _1800 = ((_1790 + sqrt((_1790 * _1790) + (((_1775 * 4.0f) * _1781) * _1788))) * 0.5f);
          } else {
            _1800 = _1775;
          }
          _1801 = _1765 - _1800;
          if (!(_1801 > _1765)) {
            _1804 = max(_1718, 0.0010000000474974513f);
            _1808 = sqrt((_1804 * _1804) + (_1768 * _1768));
            _1811 = (_1808 + _1765) / (_1804 + _1765);
            _1813 = (_1811 * _1801) - _1808;
            _1823 = ((_1813 + sqrt((_1813 * _1813) + (((_1801 * 4.0f) * _1804) * _1811))) * 0.5f);
          } else {
            _1823 = _1801;
          }
          _1826 = (_1823 * _1738);
        } else {
          _1826 = _1617;
        }
        _1829 = select((_1710 >= _1711), _1713, _1714) * 360.0f;
        _1832 = select((_1829 < 0.0f), (_1829 + 360.0f), _1829);
        _1833 = int(_1832);
        _1834 = _1833 + 1;
        _1836 = 0;
        _1837 = 361;
        _1838 = _1834;
        while(true) {
          _1842 = (_1599 > (((float3)(t1.Load(int3(_1838, 0, 0)))).z));
          _1843 = select(_1842, _1838, _1836);
          _1844 = select(_1842, _1837, _1838);
          if ((int)(_1843 + 1) < (int)_1844) {
            _1836 = _1843;
            _1837 = _1844;
            _1838 = ((_1843 + _1844) / 2);
            continue;
          }
          _1851 = t1.Load(int3((_1844 + -1), 0, 0));
          _1855 = t1.Load(int3(_1844, 0, 0));
          _1861 = (_1599 - _1851.z) / (_1855.z - _1851.z);
          _1864 = ((_1855.x - _1851.x) * _1861) + _1851.x;
          if (!((_1708 > _1430) || (_1826 < 9.999999747378752e-05f))) {
            _1878 = (min(1.0f, (1.2999999523162842f - (_1864 / _1430))) * (((float((int)(((int)(uint)((int)(_1432 > 0.0f))) - ((int)(uint)((int)(_1432 < 0.0f))))) * 100.0f) * exp2(log2(((_1437 * 400.0f) / (_1437 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _1864)) + _1864;
            _1879 = ((_1410 * 0.7111833691596985f) + 1.350000023841858f) * _1430;
            _1880 = _1430 - _1864;
            _1882 = (_1880 * 0.30000001192092896f) + _1864;
            if (_1708 > _1882) {
              _1896 = (exp2(log2(log2((_1430 - _1882) / max(9.999999747378752e-05f, (_1430 - _1708))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _1896 = 1.0f;
            }
            _1897 = _1879 * _1896;
            t2.GetDimensions(_1899.x, _1899.y);
            _1903 = float((int)(_1833));
            _1907 = t2.Load(int3(_1834, 0, 0));
            _1912 = (lerp(_1851.y, _1855.y, _1861)) * 1.0324000120162964f;
            _1913 = _1897 * _1878;
            _1915 = (_1708 < _1878);
            _1916 = _1826 / _1897;
            if (_1915) {
              _1926 = (1.0f - _1916);
            } else {
              _1926 = (-0.0f - ((_1916 + 1.0f) + ((_1826 * _1430) / _1913)));
            }
            if (_1915) {
              _1934 = (-0.0f - _1708);
            } else {
              _1934 = (((_1826 * _1430) / _1897) + _1708);
            }
            _1939 = sqrt((_1926 * _1926) - (((_1826 / _1913) * 4.0f) * _1934));
            _1945 = (_1934 * 2.0f) / select(_1915, ((-0.0f - _1926) - _1939), (_1939 - _1926));
            _1947 = (_1864 < _1878);
            _1948 = _1912 / _1897;
            if (_1947) {
              _1958 = (1.0f - _1948);
            } else {
              _1958 = (-0.0f - ((_1948 + 1.0f) + ((_1912 * _1430) / _1913)));
            }
            if (!_1947) {
              _1964 = (((_1912 * _1430) / _1897) + _1864);
            } else {
              _1964 = (-0.0f - _1864);
            }
            _1969 = sqrt((_1958 * _1958) - (((_1912 / _1913) * 4.0f) * _1964));
            _1975 = (_1964 * 2.0f) / select(_1947, ((-0.0f - _1958) - _1969), (_1969 - _1958));
            _1977 = _1430 - _1945;
            _1981 = ((_1945 - _1878) * select((_1945 < _1878), _1945, _1977)) / _1913;
            _1990 = _1430 - _1975;
            _2001 = ((_1990 * _1912) * exp2(log2(_1977 / _1990) * (1.0f / (((((t2.Load(int3(((_1833 + 2) % (int)(_1899.x)), 0, 0))).x) - _1907.x) * (_1832 - _1903)) + _1907.x)))) / ((_1880 + (_1981 * _1912)) * _1912);
            _2003 = (exp2(log2(_1945 / _1975) * (1.0f / ((_1410 * 0.02107210084795952f) + 1.1399999856948853f))) * _1975) / (((_1864 / _1912) - _1981) * _1912);
            _2007 = max((0.11999999731779099f - abs(_2003 - _2001)), 0.0f);
            _2008 = _2007 * 8.333333969116211f;
            _2014 = (min(_2003, _2001) - ((_2008 * _2008) * (_2007 * 0.1666666716337204f))) * _1912;
            _2015 = _2014 * _1981;
            _2016 = _2015 + _1945;
            _2017 = _1834 % 360;
            _2025 = t0.Load(int3(_1833, 0, 0));
            _2029 = ((((t0.Load(int3(_2017, 0, 0))).x) - _2025.x) * ((_1599 - _1903) / float((int)(_2017 - _1833)))) + _2025.x;
            if (_2016 > _1882) {
              _2043 = (exp2(log2(log2((_1430 - _1882) / max(9.999999747378752e-05f, (_1430 - _2016))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
            } else {
              _2043 = 1.0f;
            }
            _2044 = _1879 * _2043;
            _2045 = _2044 * _1878;
            _2047 = (_2016 < _1878);
            _2048 = _2014 / _2044;
            if (_2047) {
              _2058 = (1.0f - _2048);
            } else {
              _2058 = (-0.0f - ((_2048 + 1.0f) + ((_2014 * _1430) / _2045)));
            }
            if (_2047) {
              _2066 = (-0.0f - _2016);
            } else {
              _2066 = (((_2014 * _1430) / _2044) + _2016);
            }
            _2071 = sqrt((_2058 * _2058) - (((_2014 / _2045) * 4.0f) * _2066));
            _2077 = (_2066 * 2.0f) / select(_2047, ((-0.0f - _2058) - _2071), (_2071 - _2058));
            _2094 = max(1.000100016593933f, (((_2029 * _1430) * exp2(log2(_2077 / _1430) * 0.8794641494750977f)) / ((_1430 - ((((_2077 - _1878) * select((_2077 < _1878), _2077, (_1430 - _2077))) / _2045) * _2029)) * _2014)));
            _2096 = max(0.75f, (1.0f / _2094));
            _2097 = _1826 / _2014;
            _2102 = ((_2094 - _2096) * (1.0f - _2096)) / (_2094 + -1.0f);
            _2104 = (_2097 - _2096) / _2102;
            if (!((_2094 <= 1.000100016593933f) || (_2097 < _2096))) {
              _2114 = (((_2104 * _2102) / (_2104 + 1.0f)) + _2096);
            } else {
              _2114 = _2097;
            }
            _2120 = ((_2114 * _2015) + _1945);
            _2121 = ((_2014 * _2114) * 0.0258397925645113f);
          } else {
            _2120 = _1708;
            _2121 = 0.0f;
          }
          _2122 = _1599 * 0.01745329424738884f;
          _2123 = _2120 * 0.009999999776482582f;
          if (!(_2123 < 0.0f)) {
            _2132 = (((pow(_2123, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
          } else {
            _2132 = 0.0f;
          }
          _2134 = cos(_2122) * _2121;
          _2136 = sin(_2122) * _2121;
          _2143 = mad(288.0f, _2136, mad(451.0f, _2134, _2132)) * 0.0007127583958208561f;
          _2144 = mad(-261.0f, _2136, mad(-891.0f, _2134, _2132)) * 0.0007127583958208561f;
          _2145 = mad(-6300.0f, _2136, mad(-220.0f, _2134, _2132)) * 0.0007127583958208561f;
          _2165 = abs(_2143);
          _2166 = abs(_2144);
          _2167 = abs(_2145);
          _2174 = (_2165 * 27.1299991607666f) / (400.0f - _2165);
          _2175 = (_2166 * 27.1299991607666f) / (400.0f - _2166);
          _2176 = (_2167 * 27.1299991607666f) / (400.0f - _2167);
          if (!(_2174 < 0.0f)) {
            _2183 = (pow(_2174, 2.3809523582458496f));
          } else {
            _2183 = 0.0f;
          }
          if (!(_2175 < 0.0f)) {
            _2190 = (pow(_2175, 2.3809523582458496f));
          } else {
            _2190 = 0.0f;
          }
          if (!(_2176 < 0.0f)) {
            _2197 = (pow(_2176, 2.3809523582458496f));
          } else {
            _2197 = 0.0f;
          }
          _2198 = (float((int)(((int)(uint)((int)(_2143 > 0.0f))) - ((int)(uint)((int)(_2143 < 0.0f))))) * 125.99209594726562f) * _2183;
          _2200 = (float((int)(((int)(uint)((int)(_2144 > 0.0f))) - ((int)(uint)((int)(_2144 < 0.0f))))) * 127.42658996582031f) * _2190;
          _2202 = (float((int)(((int)(uint)((int)(_2145 > 0.0f))) - ((int)(uint)((int)(_2145 < 0.0f))))) * 126.70159912109375f) * _2197;
          _2205 = mad(0.08875565975904465f, _2202, mad(-1.140031337738037f, _2200, (_2198 * 2.016401767730713f)));
          _2212 = mad(-0.12752249836921692f, _2202, mad(0.7005835175514221f, _2200, (_2198 * 0.41968056559562683f))) * 0.009999999776482582f;
          _2213 = mad(1.0589468479156494f, _2202, mad(-0.03847259283065796f, _2200, (_2198 * -0.01717424765229225f))) * 0.009999999776482582f;
          _2226 = min(max(mad(-0.23642469942569733f, _2213, mad(-0.32480329275131226f, _2212, (_2205 * 0.016410233452916145f))), 0.0f), _1409);
          _2227 = min(max(mad(0.016756348311901093f, _2213, mad(1.6153316497802734f, _2212, (_2205 * -0.006636628415435553f))), 0.0f), _1409);
          _2228 = min(max(mad(0.9883948564529419f, _2213, mad(-0.008284442126750946f, _2212, (_2205 * 0.00011721893679350615f))), 0.0f), _1409);
          _2231 = mad(0.15618768334388733f, _2228, mad(0.13400420546531677f, _2227, (_2226 * 0.6624541878700256f)));
          _2234 = mad(0.053689517080783844f, _2228, mad(0.6740817427635193f, _2227, (_2226 * 0.2722287178039551f)));
          _2237 = mad(1.0103391408920288f, _2228, mad(0.00406073359772563f, _2227, (_2226 * -0.005574649665504694f)));
          _2247 = mad(-0.23642469942569733f, _2237, mad(-0.32480329275131226f, _2234, (_2231 * 1.6410233974456787f))) * 100.0f;
          _2248 = mad(0.016756348311901093f, _2237, mad(1.6153316497802734f, _2234, (_2231 * -0.663662850856781f))) * 100.0f;
          _2249 = mad(0.9883948564529419f, _2237, mad(-0.008284442126750946f, _2234, (_2231 * 0.011721894145011902f))) * 100.0f;
          _2268 = exp2(log2(mad(_54, _2249, mad(_53, _2248, (_2247 * _52))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2269 = exp2(log2(mad(_57, _2249, mad(_56, _2248, (_2247 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _2270 = exp2(log2(mad(_60, _2249, mad(_59, _2248, (_2247 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
          _3316 = exp2(log2((1.0f / ((_2268 * 18.6875f) + 1.0f)) * ((_2268 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3317 = exp2(log2((1.0f / ((_2269 * 18.6875f) + 1.0f)) * ((_2269 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3318 = exp2(log2((1.0f / ((_2270 * 18.6875f) + 1.0f)) * ((_2270 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          break;
        }
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2318 = cb0_012z * _1230;
          _2319 = cb0_012z * _1231;
          _2320 = cb0_012z * _1232;
          _2323 = mad((WorkingColorSpace_256[0].z), _2320, mad((WorkingColorSpace_256[0].y), _2319, (_2318 * (WorkingColorSpace_256[0].x))));
          _2326 = mad((WorkingColorSpace_256[1].z), _2320, mad((WorkingColorSpace_256[1].y), _2319, (_2318 * (WorkingColorSpace_256[1].x))));
          _2329 = mad((WorkingColorSpace_256[2].z), _2320, mad((WorkingColorSpace_256[2].y), _2319, (_2318 * (WorkingColorSpace_256[2].x))));
          _2330 = cb0_043y * 0.009999999776482582f;
          _2331 = log2(_2330);
          _2336 = exp2(log2(abs(cb0_043y) * 0.00793700572103262f) * 0.41999998688697815f);
          _2351 = (float((int)(((int)(uint)((int)(cb0_043y > 0.0f))) - ((int)(uint)((int)(cb0_043y < 0.0f))))) * 100.0f) * exp2(log2(((_2336 * 400.0f) / (_2336 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2353 = (_2331 * 1.4018198251724243f) + 10.012999534606934f;
          _2358 = exp2(log2(abs(_2353) * 0.00793700572103262f) * 0.41999998688697815f);
          _2399 = (_2331 * 924.7640991210938f) + 1024.0f;
          _2403 = min(max(mad(-0.21492856740951538f, _2329, mad(-0.2365107536315918f, _2326, (_2323 * 1.4514392614364624f))), 0.0f), _2399);
          _2404 = min(max(mad(-0.09967592358589172f, _2329, mad(1.17622971534729f, _2326, (_2323 * -0.07655377686023712f))), 0.0f), _2399);
          _2405 = min(max(mad(0.9977163076400757f, _2329, mad(-0.006032449658960104f, _2326, (_2323 * 0.008316148072481155f))), 0.0f), _2399);
          _2408 = mad(0.15618768334388733f, _2405, mad(0.13400420546531677f, _2404, (_2403 * 0.6624541878700256f)));
          _2415 = mad(0.053689517080783844f, _2405, mad(0.6740817427635193f, _2404, (_2403 * 0.2722287178039551f))) * 100.0f;
          _2416 = mad(1.0103391408920288f, _2405, mad(0.00406073359772563f, _2404, (_2403 * -0.005574649665504694f))) * 100.0f;
          _2426 = mad(0.04110127314925194f, _2416, mad(0.594700813293457f, _2415, (_2408 * 36.407447814941406f))) * 1.0172951221466064f;
          _2427 = mad(0.1479453295469284f, _2416, mad(1.0738555192947388f, _2415, (_2408 * -22.224510192871094f))) * 0.9887425899505615f;
          _2428 = mad(0.9503875374794006f, _2416, mad(0.04882604628801346f, _2415, (_2408 * -0.20676189661026f))) * 0.9944003820419312f;
          _2432 = abs(_2426) * 0.00793700572103262f;
          _2433 = abs(_2427) * 0.00793700572103262f;
          _2434 = abs(_2428) * 0.00793700572103262f;
          if (!(_2432 < 0.0f)) {
            _2441 = (pow(_2432, 0.41999998688697815f));
          } else {
            _2441 = 0.0f;
          }
          if (!(_2433 < 0.0f)) {
            _2448 = (pow(_2433, 0.41999998688697815f));
          } else {
            _2448 = 0.0f;
          }
          if (!(_2434 < 0.0f)) {
            _2455 = (pow(_2434, 0.41999998688697815f));
          } else {
            _2455 = 0.0f;
          }
          _2483 = ((float((int)(((int)(uint)((int)(_2426 > 0.0f))) - ((int)(uint)((int)(_2426 < 0.0f))))) * 400.0f) * _2441) / (_2441 + 27.1299991607666f);
          _2484 = ((float((int)(((int)(uint)((int)(_2427 > 0.0f))) - ((int)(uint)((int)(_2427 < 0.0f))))) * 400.0f) * _2448) / (_2448 + 27.1299991607666f);
          _2485 = ((float((int)(((int)(uint)((int)(_2428 > 0.0f))) - ((int)(uint)((int)(_2428 < 0.0f))))) * 400.0f) * _2455) / (_2455 + 27.1299991607666f);
          _2489 = (_2483 - (_2484 * 1.0909091234207153f)) + (_2485 * 0.09090909361839294f);
          _2493 = ((_2484 + _2483) - (_2485 * 2.0f)) * 0.1111111119389534f;
          _2495 = atan(_2493 / _2489);
          _2498 = (_2489 < 0.0f);
          _2499 = (_2489 == 0.0f);
          _2500 = (_2493 >= 0.0f);
          _2501 = (_2493 < 0.0f);
          _2510 = select((_2499 && _2500), 0.25f, select((_2499 && _2501), -0.25f, (select((_2498 && _2501), (_2495 + -3.1415927410125732f), select((_2498 && _2500), (_2495 + 3.1415927410125732f), _2495)) * 0.15915493667125702f)));
          _2514 = frac(abs(_2510));
          _2517 = select((_2510 >= (-0.0f - _2510)), _2514, (-0.0f - _2514)) * 360.0f;
          _2520 = select((_2517 < 0.0f), (_2517 + 360.0f), _2517);
          _2529 = exp2(log2((((_2483 * 2.0f) + _2484) + (_2485 * 0.05000000074505806f)) * 0.02532351203262806f) * 1.1370559930801392f) * 100.0f;
          if (!(_2529 == 0.0f)) {
            _2538 = (sqrt((_2493 * _2493) + (_2489 * _2489)) * 38.70000076293945f);
          } else {
            _2538 = 0.0f;
          }
          _2543 = exp2(log2(abs(_2529) * 0.009999999776482582f) * 0.8794641494750977f);
          _2558 = (float((int)(((int)(uint)((int)(_2529 > 0.0f))) - ((int)(uint)((int)(_2529 < 0.0f))))) * 1.2599209547042847f) * exp2(log2((_2543 * 351.2578430175781f) / (400.0f - (_2543 * 12.947211265563965f))) * 2.3809523582458496f);
          _2560 = (_2331 * 115.59551239013672f) + 128.0f;
          _2564 = sqrt((_2330 + 0.1599999964237213f) * _2330) + _2330;
          _2565 = _2564 * 0.5f;
          _2566 = _2560 / _2565;
          _2573 = _2331 * 0.014018198475241661f;
          _2574 = _2573 + 0.10012999176979065f;
          _2584 = exp2(log2((((_2574 + sqrt(_2574 * (_2573 + 0.26012998819351196f))) * 0.5f) * exp2(log2(_2560 / (_2565 * (_2566 + 1.0f))) * 1.149999976158142f)) / _2565) * 0.8695652484893799f);
          _2589 = 0.18000000715255737f / (((_2564 * -0.5f) * _2584) / (_2584 + -1.0f));
          _2604 = exp2(log2(max(0.0f, _2558) / ((_2589 * _2565) + _2558)) * 1.149999976158142f) * (_2565 / exp2(log2(_2560 / ((_2566 + _2589) * _2565)) * 1.149999976158142f));
          _2609 = max(0.0f, ((_2604 * _2604) / (_2604 + 0.03999999910593033f))) * 100.0f;
          _2614 = exp2(log2(abs(_2609) * 0.00793700572103262f) * 0.41999998688697815f);
          _2629 = (float((int)(((int)(uint)((int)(_2609 > 0.0f))) - ((int)(uint)((int)(_2609 < 0.0f))))) * 100.0f) * exp2(log2(((_2614 * 400.0f) / (_2614 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f);
          _2631 = _2520 * 0.0027777778450399637f;
          _2632 = -0.0f - _2631;
          _2634 = frac(abs(_2631));
          _2635 = -0.0f - _2634;
          if (!(_2538 == 0.0f)) {
            _2637 = _2629 / _2351;
            _2639 = max(0.0f, (1.0f - _2637));
            _2640 = _2520 * 0.01745329424738884f;
            _2641 = cos(_2640);
            _2642 = sin(_2640);
            _2643 = _2641 * _2641;
            _2644 = _2642 * _2642;
            _2659 = ((((77.12895965576172f - ((_2641 * 12.74448013305664f) * _2642)) + ((_2643 - _2644) * 16.468990325927734f)) + (((_2643 * 31.535200119018555f) + -12.31067943572998f) * _2641)) + ((42.245330810546875f - (_2644 * 36.774559020996094f)) * _2642)) * (exp2(log2(cb0_043y * 0.03378999978303909f) * 0.3059599995613098f) + -0.45135000348091125f);
            _2665 = select((_2631 >= _2632), _2634, _2635) * 360.0f;
            _2669 = int(select((_2665 < 0.0f), (_2665 + 360.0f), _2665));
            _2671 = (_2669 + 1) % 360;
            _2680 = t0.Load(int3(_2669, 0, 0));
            _2685 = (((((t0.Load(int3(_2671, 0, 0))).x) - _2680.x) * ((_2520 - float((int)(_2669))) / float((int)(_2671 - _2669)))) + _2680.x) * (pow(_2637, 0.8794641494750977f));
            _2686 = _2685 / _2659;
            _2687 = _2686 + -0.0010000000474974513f;
            _2688 = _2639 * max(0.20000000298023224f, (1.2999999523162842f - (_2331 * 0.270023912191391f)));
            _2689 = _2637 * ((_2331 * 2.384157657623291f) + 2.4000000953674316f);
            _2696 = (_2685 - (exp2(log2(_2629 / _2529) * 0.8794641494750977f) * _2538)) / _2659;
            if (!(_2696 > _2687)) {
              _2702 = max(sqrt((_2637 * _2637) + (0.5f / cb0_043y)), 0.0010000000474974513f);
              _2706 = sqrt((_2702 * _2702) + (_2688 * _2688));
              _2709 = (_2706 + _2687) / (_2702 + _2687);
              _2711 = (_2709 * _2696) - _2706;
              _2721 = ((_2711 + sqrt((_2711 * _2711) + (((_2696 * 4.0f) * _2702) * _2709))) * 0.5f);
            } else {
              _2721 = _2696;
            }
            _2722 = _2686 - _2721;
            if (!(_2722 > _2686)) {
              _2725 = max(_2639, 0.0010000000474974513f);
              _2729 = sqrt((_2725 * _2725) + (_2689 * _2689));
              _2732 = (_2729 + _2686) / (_2725 + _2686);
              _2734 = (_2732 * _2722) - _2729;
              _2744 = ((_2734 + sqrt((_2734 * _2734) + (((_2722 * 4.0f) * _2725) * _2732))) * 0.5f);
            } else {
              _2744 = _2722;
            }
            _2747 = (_2744 * _2659);
          } else {
            _2747 = _2538;
          }
          _2750 = select((_2631 >= _2632), _2634, _2635) * 360.0f;
          _2753 = select((_2750 < 0.0f), (_2750 + 360.0f), _2750);
          _2754 = int(_2753);
          _2755 = _2754 + 1;
          _2757 = 0;
          _2758 = 361;
          _2759 = _2755;
          while(true) {
            _2763 = (_2520 > (((float3)(t1.Load(int3(_2759, 0, 0)))).z));
            _2764 = select(_2763, _2759, _2757);
            _2765 = select(_2763, _2758, _2759);
            if ((int)(_2764 + 1) < (int)_2765) {
              _2757 = _2764;
              _2758 = _2765;
              _2759 = ((_2764 + _2765) / 2);
              continue;
            }
            _2772 = t1.Load(int3((_2765 + -1), 0, 0));
            _2776 = t1.Load(int3(_2765, 0, 0));
            _2782 = (_2520 - _2772.z) / (_2776.z - _2772.z);
            _2785 = ((_2776.x - _2772.x) * _2782) + _2772.x;
            if (!((_2629 > _2351) || (_2747 < 9.999999747378752e-05f))) {
              _2799 = (min(1.0f, (1.2999999523162842f - (_2785 / _2351))) * (((float((int)(((int)(uint)((int)(_2353 > 0.0f))) - ((int)(uint)((int)(_2353 < 0.0f))))) * 100.0f) * exp2(log2(((_2358 * 400.0f) / (_2358 + 27.1299991607666f)) * 0.07723671197891235f) * 1.1370559930801392f)) - _2785)) + _2785;
              _2800 = ((_2331 * 0.7111833691596985f) + 1.350000023841858f) * _2351;
              _2801 = _2351 - _2785;
              _2803 = (_2801 * 0.30000001192092896f) + _2785;
              if (_2629 > _2803) {
                _2817 = (exp2(log2(log2((_2351 - _2803) / max(9.999999747378752e-05f, (_2351 - _2629))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _2817 = 1.0f;
              }
              _2818 = _2800 * _2817;
              t2.GetDimensions(_2820.x, _2820.y);
              _2824 = float((int)(_2754));
              _2828 = t2.Load(int3(_2755, 0, 0));
              _2833 = (lerp(_2772.y, _2776.y, _2782)) * 1.0324000120162964f;
              _2834 = _2818 * _2799;
              _2836 = (_2629 < _2799);
              _2837 = _2747 / _2818;
              if (_2836) {
                _2847 = (1.0f - _2837);
              } else {
                _2847 = (-0.0f - ((_2837 + 1.0f) + ((_2747 * _2351) / _2834)));
              }
              if (_2836) {
                _2855 = (-0.0f - _2629);
              } else {
                _2855 = (((_2747 * _2351) / _2818) + _2629);
              }
              _2860 = sqrt((_2847 * _2847) - (((_2747 / _2834) * 4.0f) * _2855));
              _2866 = (_2855 * 2.0f) / select(_2836, ((-0.0f - _2847) - _2860), (_2860 - _2847));
              _2868 = (_2785 < _2799);
              _2869 = _2833 / _2818;
              if (_2868) {
                _2879 = (1.0f - _2869);
              } else {
                _2879 = (-0.0f - ((_2869 + 1.0f) + ((_2833 * _2351) / _2834)));
              }
              if (!_2868) {
                _2885 = (((_2833 * _2351) / _2818) + _2785);
              } else {
                _2885 = (-0.0f - _2785);
              }
              _2890 = sqrt((_2879 * _2879) - (((_2833 / _2834) * 4.0f) * _2885));
              _2896 = (_2885 * 2.0f) / select(_2868, ((-0.0f - _2879) - _2890), (_2890 - _2879));
              _2898 = _2351 - _2866;
              _2902 = ((_2866 - _2799) * select((_2866 < _2799), _2866, _2898)) / _2834;
              _2911 = _2351 - _2896;
              _2922 = ((_2911 * _2833) * exp2(log2(_2898 / _2911) * (1.0f / (((((t2.Load(int3(((_2754 + 2) % (int)(_2820.x)), 0, 0))).x) - _2828.x) * (_2753 - _2824)) + _2828.x)))) / ((_2801 + (_2902 * _2833)) * _2833);
              _2924 = (exp2(log2(_2866 / _2896) * (1.0f / ((_2331 * 0.02107210084795952f) + 1.1399999856948853f))) * _2896) / (((_2785 / _2833) - _2902) * _2833);
              _2928 = max((0.11999999731779099f - abs(_2924 - _2922)), 0.0f);
              _2929 = _2928 * 8.333333969116211f;
              _2935 = (min(_2924, _2922) - ((_2929 * _2929) * (_2928 * 0.1666666716337204f))) * _2833;
              _2936 = _2935 * _2902;
              _2937 = _2936 + _2866;
              _2938 = _2755 % 360;
              _2946 = t0.Load(int3(_2754, 0, 0));
              _2950 = ((((t0.Load(int3(_2938, 0, 0))).x) - _2946.x) * ((_2520 - _2824) / float((int)(_2938 - _2754)))) + _2946.x;
              if (_2937 > _2803) {
                _2964 = (exp2(log2(log2((_2351 - _2803) / max(9.999999747378752e-05f, (_2351 - _2937))) * 0.3010300099849701f) * 1.8181817531585693f) + 1.0f);
              } else {
                _2964 = 1.0f;
              }
              _2965 = _2800 * _2964;
              _2966 = _2965 * _2799;
              _2968 = (_2937 < _2799);
              _2969 = _2935 / _2965;
              if (_2968) {
                _2979 = (1.0f - _2969);
              } else {
                _2979 = (-0.0f - ((_2969 + 1.0f) + ((_2935 * _2351) / _2966)));
              }
              if (_2968) {
                _2987 = (-0.0f - _2937);
              } else {
                _2987 = (((_2935 * _2351) / _2965) + _2937);
              }
              _2992 = sqrt((_2979 * _2979) - (((_2935 / _2966) * 4.0f) * _2987));
              _2998 = (_2987 * 2.0f) / select(_2968, ((-0.0f - _2979) - _2992), (_2992 - _2979));
              _3015 = max(1.000100016593933f, (((_2950 * _2351) * exp2(log2(_2998 / _2351) * 0.8794641494750977f)) / ((_2351 - ((((_2998 - _2799) * select((_2998 < _2799), _2998, (_2351 - _2998))) / _2966) * _2950)) * _2935)));
              _3017 = max(0.75f, (1.0f / _3015));
              _3018 = _2747 / _2935;
              _3023 = ((_3015 - _3017) * (1.0f - _3017)) / (_3015 + -1.0f);
              _3025 = (_3018 - _3017) / _3023;
              if (!((_3015 <= 1.000100016593933f) || (_3018 < _3017))) {
                _3035 = (((_3025 * _3023) / (_3025 + 1.0f)) + _3017);
              } else {
                _3035 = _3018;
              }
              _3041 = ((_3035 * _2936) + _2866);
              _3042 = ((_2935 * _3035) * 0.0258397925645113f);
            } else {
              _3041 = _2629;
              _3042 = 0.0f;
            }
            _3043 = _2520 * 0.01745329424738884f;
            _3044 = _3041 * 0.009999999776482582f;
            if (!(_3044 < 0.0f)) {
              _3053 = (((pow(_3044, 0.8794641494750977f)) * 39.48899459838867f) * 460.0f);
            } else {
              _3053 = 0.0f;
            }
            _3055 = cos(_3043) * _3042;
            _3057 = sin(_3043) * _3042;
            _3064 = mad(288.0f, _3057, mad(451.0f, _3055, _3053)) * 0.0007127583958208561f;
            _3065 = mad(-261.0f, _3057, mad(-891.0f, _3055, _3053)) * 0.0007127583958208561f;
            _3066 = mad(-6300.0f, _3057, mad(-220.0f, _3055, _3053)) * 0.0007127583958208561f;
            _3086 = abs(_3064);
            _3087 = abs(_3065);
            _3088 = abs(_3066);
            _3095 = (_3086 * 27.1299991607666f) / (400.0f - _3086);
            _3096 = (_3087 * 27.1299991607666f) / (400.0f - _3087);
            _3097 = (_3088 * 27.1299991607666f) / (400.0f - _3088);
            if (!(_3095 < 0.0f)) {
              _3104 = (pow(_3095, 2.3809523582458496f));
            } else {
              _3104 = 0.0f;
            }
            if (!(_3096 < 0.0f)) {
              _3111 = (pow(_3096, 2.3809523582458496f));
            } else {
              _3111 = 0.0f;
            }
            if (!(_3097 < 0.0f)) {
              _3118 = (pow(_3097, 2.3809523582458496f));
            } else {
              _3118 = 0.0f;
            }
            _3119 = (float((int)(((int)(uint)((int)(_3064 > 0.0f))) - ((int)(uint)((int)(_3064 < 0.0f))))) * 125.99209594726562f) * _3104;
            _3121 = (float((int)(((int)(uint)((int)(_3065 > 0.0f))) - ((int)(uint)((int)(_3065 < 0.0f))))) * 127.42658996582031f) * _3111;
            _3123 = (float((int)(((int)(uint)((int)(_3066 > 0.0f))) - ((int)(uint)((int)(_3066 < 0.0f))))) * 126.70159912109375f) * _3118;
            _3126 = mad(0.08875565975904465f, _3123, mad(-1.140031337738037f, _3121, (_3119 * 2.016401767730713f)));
            _3133 = mad(-0.12752249836921692f, _3123, mad(0.7005835175514221f, _3121, (_3119 * 0.41968056559562683f))) * 0.009999999776482582f;
            _3134 = mad(1.0589468479156494f, _3123, mad(-0.03847259283065796f, _3121, (_3119 * -0.01717424765229225f))) * 0.009999999776482582f;
            _3147 = min(max(mad(-0.23642469942569733f, _3134, mad(-0.32480329275131226f, _3133, (_3126 * 0.016410233452916145f))), 0.0f), _2330);
            _3148 = min(max(mad(0.016756348311901093f, _3134, mad(1.6153316497802734f, _3133, (_3126 * -0.006636628415435553f))), 0.0f), _2330);
            _3149 = min(max(mad(0.9883948564529419f, _3134, mad(-0.008284442126750946f, _3133, (_3126 * 0.00011721893679350615f))), 0.0f), _2330);
            _3152 = mad(0.15618768334388733f, _3149, mad(0.13400420546531677f, _3148, (_3147 * 0.6624541878700256f)));
            _3155 = mad(0.053689517080783844f, _3149, mad(0.6740817427635193f, _3148, (_3147 * 0.2722287178039551f)));
            _3158 = mad(1.0103391408920288f, _3149, mad(0.00406073359772563f, _3148, (_3147 * -0.005574649665504694f)));
            _3161 = mad(-0.23642469942569733f, _3158, mad(-0.32480329275131226f, _3155, (_3152 * 1.6410233974456787f)));
            _3168 = mad(0.016756348311901093f, _3158, mad(1.6153316497802734f, _3155, (_3152 * -0.663662850856781f))) * 1.25f;
            _3169 = mad(0.9883948564529419f, _3158, mad(-0.008284442126750946f, _3155, (_3152 * 0.011721894145011902f))) * 1.25f;
            _3316 = mad(-0.0832589864730835f, _3169, mad(-0.6217921376228333f, _3168, (_3161 * 2.1313138008117676f)));
            _3317 = mad(-0.010548308491706848f, _3169, mad(1.140804648399353f, _3168, (_3161 * -0.16282059252262115f)));
            _3318 = mad(1.1529725790023804f, _3169, mad(-0.1289689838886261f, _3168, (_3161 * -0.030004188418388367f)));
            break;
          }
        } else {
          if (cb0_042w == 7) {
            _3196 = mad((WorkingColorSpace_128[0].z), _1232, mad((WorkingColorSpace_128[0].y), _1231, ((WorkingColorSpace_128[0].x) * _1230)));
            _3199 = mad((WorkingColorSpace_128[1].z), _1232, mad((WorkingColorSpace_128[1].y), _1231, ((WorkingColorSpace_128[1].x) * _1230)));
            _3202 = mad((WorkingColorSpace_128[2].z), _1232, mad((WorkingColorSpace_128[2].y), _1231, ((WorkingColorSpace_128[2].x) * _1230)));
            _3221 = exp2(log2(mad(_54, _3202, mad(_53, _3199, (_3196 * _52))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3222 = exp2(log2(mad(_57, _3202, mad(_56, _3199, (_3196 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3223 = exp2(log2(mad(_60, _3202, mad(_59, _3199, (_3196 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3316 = exp2(log2((1.0f / ((_3221 * 18.6875f) + 1.0f)) * ((_3221 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3317 = exp2(log2((1.0f / ((_3222 * 18.6875f) + 1.0f)) * ((_3222 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3318 = exp2(log2((1.0f / ((_3223 * 18.6875f) + 1.0f)) * ((_3223 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _3270 = mad((WorkingColorSpace_128[0].z), _1220, mad((WorkingColorSpace_128[0].y), _1219, ((WorkingColorSpace_128[0].x) * _1218)));
                _3273 = mad((WorkingColorSpace_128[1].z), _1220, mad((WorkingColorSpace_128[1].y), _1219, ((WorkingColorSpace_128[1].x) * _1218)));
                _3276 = mad((WorkingColorSpace_128[2].z), _1220, mad((WorkingColorSpace_128[2].y), _1219, ((WorkingColorSpace_128[2].x) * _1218)));
                _3316 = mad(_54, _3276, mad(_53, _3273, (_3270 * _52)));
                _3317 = mad(_57, _3276, mad(_56, _3273, (_3270 * _55)));
                _3318 = mad(_60, _3276, mad(_59, _3273, (_3270 * _58)));
              } else {
                _3289 = mad((WorkingColorSpace_128[0].z), _1246, mad((WorkingColorSpace_128[0].y), _1245, ((WorkingColorSpace_128[0].x) * _1244)));
                _3292 = mad((WorkingColorSpace_128[1].z), _1246, mad((WorkingColorSpace_128[1].y), _1245, ((WorkingColorSpace_128[1].x) * _1244)));
                _3295 = mad((WorkingColorSpace_128[2].z), _1246, mad((WorkingColorSpace_128[2].y), _1245, ((WorkingColorSpace_128[2].x) * _1244)));
                _3316 = exp2(log2(mad(_54, _3295, mad(_53, _3292, (_3289 * _52)))) * cb0_042z);
                _3317 = exp2(log2(mad(_57, _3295, mad(_56, _3292, (_3289 * _55)))) * cb0_042z);
                _3318 = exp2(log2(mad(_60, _3295, mad(_59, _3292, (_3289 * _58)))) * cb0_042z);
              }
            } else {
              _3316 = _1230;
              _3317 = _1231;
              _3318 = _1232;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_3316 * 0.9523810148239136f), (_3317 * 0.9523810148239136f), (_3318 * 0.9523810148239136f), 0.0f);
}
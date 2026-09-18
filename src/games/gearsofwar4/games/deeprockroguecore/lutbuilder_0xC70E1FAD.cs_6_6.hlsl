// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
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
  float _34;
  float _39;
  float _40;
  float _41;
  float _43;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _129;
  float _130;
  float _131;
  float _186;
  float _393;
  float _394;
  float _395;
  float _918;
  float _951;
  float _965;
  float _1029;
  float _1208;
  float _1219;
  float _1230;
  float _1427;
  float _1428;
  float _1429;
  float _1440;
  float _1451;
  float _1620;
  float _1635;
  float _1650;
  float _1658;
  float _1659;
  float _1660;
  float _1727;
  float _1760;
  float _1774;
  float _1813;
  float _1935;
  float _2009;
  float _2083;
  float _2288;
  float _2303;
  float _2318;
  float _2326;
  float _2327;
  float _2328;
  float _2395;
  float _2428;
  float _2442;
  float _2481;
  float _2603;
  float _2689;
  float _2775;
  float _2990;
  float _2991;
  float _2992;
  bool _52;
  float _82;
  float _83;
  float _84;
  bool _167;
  float _169;
  float _200;
  float _207;
  float _210;
  float _215;
  float _216;
  float _218;
  bool _219;
  float _228;
  float _230;
  float _237;
  float _239;
  float _241;
  float _242;
  float _245;
  float _248;
  float _253;
  float _259;
  float _260;
  float _261;
  float _262;
  float _263;
  float _264;
  float _265;
  float _266;
  float _269;
  float _270;
  float _271;
  float _274;
  float _293;
  float _294;
  float _295;
  float _296;
  float _297;
  float _298;
  float _299;
  float _300;
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
  float _355;
  float _410;
  float _413;
  float _416;
  float _417;
  float _421;
  float _422;
  float _423;
  float _435;
  float _451;
  float _452;
  float _453;
  float _454;
  float _468;
  float _482;
  float _496;
  float _510;
  float _524;
  float _528;
  float _529;
  float _530;
  float _587;
  float _591;
  float _592;
  float _601;
  float _610;
  float _619;
  float _628;
  float _637;
  float _700;
  float _704;
  float _713;
  float _722;
  float _731;
  float _740;
  float _749;
  float _807;
  float _818;
  float _820;
  float _822;
  float _858;
  float _859;
  float _860;
  float _863;
  float _866;
  float _869;
  float _873;
  float _878;
  float _891;
  float _892;
  float _893;
  float _894;
  float _898;
  float _909;
  float _919;
  float _920;
  float _921;
  float _922;
  float _929;
  float _932;
  float _934;
  bool _937;
  bool _938;
  bool _939;
  bool _940;
  float _956;
  float _969;
  float _973;
  float _979;
  float _989;
  float _990;
  float _991;
  float _992;
  float _1007;
  float _1009;
  float _1011;
  float _1020;
  float _1032;
  float _1034;
  float _1038;
  float _1039;
  float _1040;
  float _1044;
  float _1045;
  float _1046;
  float _1047;
  float _1049;
  float _1050;
  float _1051;
  float _1052;
  float _1071;
  float _1073;
  float _1098;
  float _1099;
  float _1100;
  float _1107;
  float _1111;
  float _1112;
  float _1113;
  bool _1114;
  float _1118;
  float _1119;
  float _1120;
  float _1139;
  float _1140;
  float _1141;
  float _1142;
  float _1162;
  float _1163;
  float _1164;
  float _1180;
  float _1181;
  float _1182;
  float _1195;
  float _1196;
  float _1197;
  float _1234;
  float _1241;
  float _1242;
  float _1243;
  float _1245;
  float4 _1248;
  float _1252;
  float4 _1253;
  float4 _1275;
  float4 _1279;
  float _1295;
  float _1296;
  float _1297;
  float _1322;
  float _1323;
  float _1324;
  float _1350;
  float _1351;
  float _1352;
  float _1359;
  float _1360;
  float _1361;
  float _1362;
  float _1363;
  float _1364;
  float _1371;
  float _1372;
  float _1373;
  float _1385;
  float _1386;
  float _1387;
  float _1410;
  float _1413;
  float _1416;
  float _1478;
  float _1481;
  float _1484;
  float _1487;
  float _1490;
  float _1493;
  float _1568;
  float _1569;
  float _1570;
  float _1573;
  float _1576;
  float _1579;
  float _1582;
  float _1585;
  float _1588;
  float _1590;
  float _1600;
  float _1601;
  float _1603;
  float _1605;
  float _1608;
  float _1623;
  float _1638;
  float _1676;
  float _1677;
  float _1678;
  float _1682;
  float _1687;
  float _1700;
  float _1701;
  float _1702;
  float _1703;
  float _1707;
  float _1718;
  float _1728;
  float _1729;
  float _1730;
  float _1731;
  float _1738;
  float _1741;
  float _1743;
  bool _1746;
  bool _1747;
  bool _1748;
  bool _1749;
  float _1765;
  float _1780;
  int _1781;
  float _1783;
  float _1784;
  float _1785;
  float _1822;
  float _1823;
  float _1824;
  float _1837;
  float _1838;
  float _1839;
  float _1840;
  float _1863;
  float _1864;
  float _1865;
  float _1866;
  float _1873;
  float _1874;
  float _1882;
  int _1883;
  float _1885;
  float _1887;
  float _1890;
  float _1895;
  float _1904;
  float _1912;
  int _1913;
  float _1915;
  float _1917;
  float _1920;
  float _1925;
  float _1939;
  float _1940;
  float _1947;
  float _1948;
  float _1956;
  int _1957;
  float _1959;
  float _1961;
  float _1964;
  float _1969;
  float _1978;
  float _1986;
  int _1987;
  float _1989;
  float _1991;
  float _1994;
  float _1999;
  float _2013;
  float _2014;
  float _2021;
  float _2022;
  float _2030;
  int _2031;
  float _2033;
  float _2035;
  float _2038;
  float _2043;
  float _2052;
  float _2060;
  int _2061;
  float _2063;
  float _2065;
  float _2068;
  float _2073;
  float _2087;
  float _2088;
  float _2090;
  float _2092;
  float _2095;
  float _2098;
  float _2101;
  float _2114;
  float _2115;
  float _2116;
  float _2119;
  float _2122;
  float _2125;
  float _2147;
  float _2148;
  float _2149;
  float _2168;
  float _2169;
  float _2170;
  float _2236;
  float _2237;
  float _2238;
  float _2241;
  float _2244;
  float _2247;
  float _2250;
  float _2253;
  float _2256;
  float _2258;
  float _2268;
  float _2269;
  float _2271;
  float _2273;
  float _2276;
  float _2291;
  float _2306;
  float _2344;
  float _2345;
  float _2346;
  float _2350;
  float _2355;
  float _2368;
  float _2369;
  float _2370;
  float _2371;
  float _2375;
  float _2386;
  float _2396;
  float _2397;
  float _2398;
  float _2399;
  float _2406;
  float _2409;
  float _2411;
  bool _2414;
  bool _2415;
  bool _2416;
  bool _2417;
  float _2433;
  float _2448;
  int _2449;
  float _2451;
  float _2452;
  float _2453;
  float _2490;
  float _2491;
  float _2492;
  float _2505;
  float _2506;
  float _2507;
  float _2508;
  float _2531;
  float _2532;
  float _2533;
  float _2534;
  float _2541;
  float _2542;
  float _2550;
  int _2551;
  float _2553;
  float _2555;
  float _2558;
  float _2563;
  float _2572;
  float _2580;
  int _2581;
  float _2583;
  float _2585;
  float _2588;
  float _2593;
  float _2619;
  float _2620;
  float _2627;
  float _2628;
  float _2636;
  int _2637;
  float _2639;
  float _2641;
  float _2644;
  float _2649;
  float _2658;
  float _2666;
  int _2667;
  float _2669;
  float _2671;
  float _2674;
  float _2679;
  float _2705;
  float _2706;
  float _2713;
  float _2714;
  float _2722;
  int _2723;
  float _2725;
  float _2727;
  float _2730;
  float _2735;
  float _2744;
  float _2752;
  int _2753;
  float _2755;
  float _2757;
  float _2760;
  float _2765;
  float _2779;
  float _2780;
  float _2782;
  float _2784;
  float _2787;
  float _2790;
  float _2793;
  float _2806;
  float _2807;
  float _2808;
  float _2811;
  float _2814;
  float _2817;
  float _2839;
  float _2842;
  float _2843;
  float _2870;
  float _2873;
  float _2876;
  float _2895;
  float _2896;
  float _2897;
  float _2944;
  float _2947;
  float _2950;
  float _2963;
  float _2966;
  float _2969;
  float _13[6];
  float _14[6];
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _21[6];
  float _22[6];
  _34 = 0.5f / cb0_037x;
  _39 = cb0_037x + -1.0f;
  _40 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _34)) / _39;
  _41 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _34)) / _39;
  _43 = float((uint)SV_DispatchThreadID.z) / _39;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _52 = (cb0_043x == 4);
        _63 = select(_52, 1.0f, 1.705051064491272f);
        _64 = select(_52, 0.0f, -0.6217921376228333f);
        _65 = select(_52, 0.0f, -0.0832589864730835f);
        _66 = select(_52, 0.0f, -0.13025647401809692f);
        _67 = select(_52, 1.0f, 1.140804648399353f);
        _68 = select(_52, 0.0f, -0.010548308491706848f);
        _69 = select(_52, 0.0f, -0.024003351107239723f);
        _70 = select(_52, 0.0f, -0.1289689838886261f);
        _71 = select(_52, 1.0f, 1.1529725790023804f);
      } else {
        _63 = 0.6954522132873535f;
        _64 = 0.14067870378494263f;
        _65 = 0.16386906802654266f;
        _66 = 0.044794563204050064f;
        _67 = 0.8596711158752441f;
        _68 = 0.0955343171954155f;
        _69 = -0.005525882821530104f;
        _70 = 0.004025210160762072f;
        _71 = 1.0015007257461548f;
      }
    } else {
      _63 = 1.0258246660232544f;
      _64 = -0.020053181797266006f;
      _65 = -0.005771636962890625f;
      _66 = -0.002234415616840124f;
      _67 = 1.0045864582061768f;
      _68 = -0.002352118492126465f;
      _69 = -0.005013350863009691f;
      _70 = -0.025290070101618767f;
      _71 = 1.0303035974502563f;
    }
  } else {
    _63 = 1.3792141675949097f;
    _64 = -0.30886411666870117f;
    _65 = -0.0703500509262085f;
    _66 = -0.06933490186929703f;
    _67 = 1.08229660987854f;
    _68 = -0.012961871922016144f;
    _69 = -0.0021590073592960835f;
    _70 = -0.0454593189060688f;
    _71 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    _82 = (pow(_40, 0.012683313339948654f));
    _83 = (pow(_41, 0.012683313339948654f));
    _84 = (pow(_43, 0.012683313339948654f));
    _129 = (exp2(log2(max(0.0f, (_82 + -0.8359375f)) / (18.8515625f - (_82 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _130 = (exp2(log2(max(0.0f, (_83 + -0.8359375f)) / (18.8515625f - (_83 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _131 = (exp2(log2(max(0.0f, (_84 + -0.8359375f)) / (18.8515625f - (_84 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _129 = ((exp2((_40 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _130 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _131 = ((exp2((_43 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _167 = (cb0_040w != 0);
    _169 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _186 = (((((1901800.0f - (_169 * 2006400000.0f)) * _169) + 247.47999572753906f) * _169) + 0.23703999817371368f);
    } else {
      _186 = (((((2967800.0f - (_169 * 4607000064.0f)) * _169) + 99.11000061035156f) * _169) + 0.24406300485134125f);
    }
    _200 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _207 = cb0_037y * cb0_037y;
    _210 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_207 * 1.6145605741257896e-07f));
    _215 = ((_200 * 2.0f) + 4.0f) - (_210 * 8.0f);
    _216 = (_200 * 3.0f) / _215;
    _218 = (_210 * 2.0f) / _215;
    _219 = (cb0_037y < 4000.0f);
    _228 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _230 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_207 * 1.5317699909210205f)) / (_228 * _228);
    _237 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _207;
    _239 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_207 * 308.60699462890625f)) / (_237 * _237);
    _241 = rsqrt(dot(float2(_230, _239), float2(_230, _239)));
    _242 = cb0_037z * 0.05000000074505806f;
    _245 = ((_242 * _239) * _241) + _200;
    _248 = _210 - ((_242 * _230) * _241);
    _253 = (4.0f - (_248 * 8.0f)) + (_245 * 2.0f);
    _259 = (((_245 * 3.0f) / _253) - _216) + select(_219, _216, _186);
    _260 = (((_248 * 2.0f) / _253) - _218) + select(_219, _218, (((_186 * 2.869999885559082f) + -0.2750000059604645f) - ((_186 * _186) * 3.0f)));
    _261 = select(_167, _259, 0.3127000033855438f);
    _262 = select(_167, _260, 0.32899999618530273f);
    _263 = select(_167, 0.3127000033855438f, _259);
    _264 = select(_167, 0.32899999618530273f, _260);
    _265 = max(_262, 1.000000013351432e-10f);
    _266 = _261 / _265;
    _269 = ((1.0f - _261) - _262) / _265;
    _270 = max(_264, 1.000000013351432e-10f);
    _271 = _263 / _270;
    _274 = ((1.0f - _263) - _264) / _270;
    _293 = mad(-0.16140000522136688f, _274, ((_271 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _269, ((_266 * 0.8950999975204468f) + 0.266400009393692f));
    _294 = mad(0.03669999912381172f, _274, (1.7135000228881836f - (_271 * 0.7501999735832214f))) / mad(0.03669999912381172f, _269, (1.7135000228881836f - (_266 * 0.7501999735832214f)));
    _295 = mad(1.0296000242233276f, _274, ((_271 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _269, ((_266 * 0.03889999911189079f) + -0.06849999725818634f));
    _296 = mad(_294, -0.7501999735832214f, 0.0f);
    _297 = mad(_294, 1.7135000228881836f, 0.0f);
    _298 = mad(_294, 0.03669999912381172f, -0.0f);
    _299 = mad(_295, 0.03889999911189079f, 0.0f);
    _300 = mad(_295, -0.06849999725818634f, 0.0f);
    _301 = mad(_295, 1.0296000242233276f, 0.0f);
    _304 = mad(0.1599626988172531f, _299, mad(-0.1470542997121811f, _296, (_293 * 0.883457362651825f)));
    _307 = mad(0.1599626988172531f, _300, mad(-0.1470542997121811f, _297, (_293 * 0.26293492317199707f)));
    _310 = mad(0.1599626988172531f, _301, mad(-0.1470542997121811f, _298, (_293 * -0.15930065512657166f)));
    _313 = mad(0.04929120093584061f, _299, mad(0.5183603167533875f, _296, (_293 * 0.38695648312568665f)));
    _316 = mad(0.04929120093584061f, _300, mad(0.5183603167533875f, _297, (_293 * 0.11516613513231277f)));
    _319 = mad(0.04929120093584061f, _301, mad(0.5183603167533875f, _298, (_293 * -0.0697740763425827f)));
    _322 = mad(0.9684867262840271f, _299, mad(0.04004279896616936f, _296, (_293 * -0.007634039502590895f)));
    _325 = mad(0.9684867262840271f, _300, mad(0.04004279896616936f, _297, (_293 * -0.0022720457054674625f)));
    _328 = mad(0.9684867262840271f, _301, mad(0.04004279896616936f, _298, (_293 * 0.0013765322510153055f)));
    _331 = mad(_310, (WorkingColorSpace_000[2].x), mad(_307, (WorkingColorSpace_000[1].x), (_304 * (WorkingColorSpace_000[0].x))));
    _334 = mad(_310, (WorkingColorSpace_000[2].y), mad(_307, (WorkingColorSpace_000[1].y), (_304 * (WorkingColorSpace_000[0].y))));
    _337 = mad(_310, (WorkingColorSpace_000[2].z), mad(_307, (WorkingColorSpace_000[1].z), (_304 * (WorkingColorSpace_000[0].z))));
    _340 = mad(_319, (WorkingColorSpace_000[2].x), mad(_316, (WorkingColorSpace_000[1].x), (_313 * (WorkingColorSpace_000[0].x))));
    _343 = mad(_319, (WorkingColorSpace_000[2].y), mad(_316, (WorkingColorSpace_000[1].y), (_313 * (WorkingColorSpace_000[0].y))));
    _346 = mad(_319, (WorkingColorSpace_000[2].z), mad(_316, (WorkingColorSpace_000[1].z), (_313 * (WorkingColorSpace_000[0].z))));
    _349 = mad(_328, (WorkingColorSpace_000[2].x), mad(_325, (WorkingColorSpace_000[1].x), (_322 * (WorkingColorSpace_000[0].x))));
    _352 = mad(_328, (WorkingColorSpace_000[2].y), mad(_325, (WorkingColorSpace_000[1].y), (_322 * (WorkingColorSpace_000[0].y))));
    _355 = mad(_328, (WorkingColorSpace_000[2].z), mad(_325, (WorkingColorSpace_000[1].z), (_322 * (WorkingColorSpace_000[0].z))));
    _393 = mad(mad((WorkingColorSpace_064[0].z), _355, mad((WorkingColorSpace_064[0].y), _346, (_337 * (WorkingColorSpace_064[0].x)))), _131, mad(mad((WorkingColorSpace_064[0].z), _352, mad((WorkingColorSpace_064[0].y), _343, (_334 * (WorkingColorSpace_064[0].x)))), _130, (mad((WorkingColorSpace_064[0].z), _349, mad((WorkingColorSpace_064[0].y), _340, (_331 * (WorkingColorSpace_064[0].x)))) * _129)));
    _394 = mad(mad((WorkingColorSpace_064[1].z), _355, mad((WorkingColorSpace_064[1].y), _346, (_337 * (WorkingColorSpace_064[1].x)))), _131, mad(mad((WorkingColorSpace_064[1].z), _352, mad((WorkingColorSpace_064[1].y), _343, (_334 * (WorkingColorSpace_064[1].x)))), _130, (mad((WorkingColorSpace_064[1].z), _349, mad((WorkingColorSpace_064[1].y), _340, (_331 * (WorkingColorSpace_064[1].x)))) * _129)));
    _395 = mad(mad((WorkingColorSpace_064[2].z), _355, mad((WorkingColorSpace_064[2].y), _346, (_337 * (WorkingColorSpace_064[2].x)))), _131, mad(mad((WorkingColorSpace_064[2].z), _352, mad((WorkingColorSpace_064[2].y), _343, (_334 * (WorkingColorSpace_064[2].x)))), _130, (mad((WorkingColorSpace_064[2].z), _349, mad((WorkingColorSpace_064[2].y), _340, (_331 * (WorkingColorSpace_064[2].x)))) * _129)));
  } else {
    _393 = _129;
    _394 = _130;
    _395 = _131;
  }
  _410 = mad((WorkingColorSpace_128[0].z), _395, mad((WorkingColorSpace_128[0].y), _394, ((WorkingColorSpace_128[0].x) * _393)));
  _413 = mad((WorkingColorSpace_128[1].z), _395, mad((WorkingColorSpace_128[1].y), _394, ((WorkingColorSpace_128[1].x) * _393)));
  _416 = mad((WorkingColorSpace_128[2].z), _395, mad((WorkingColorSpace_128[2].y), _394, ((WorkingColorSpace_128[2].x) * _393)));
  _417 = dot(float3(_410, _413, _416), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _421 = (_410 / _417) + -1.0f;
  _422 = (_413 / _417) + -1.0f;
  _423 = (_416 / _417) + -1.0f;
  _435 = (1.0f - exp2(((_417 * _417) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_421, _422, _423), float3(_421, _422, _423)) * -4.0f));
  _451 = ((mad(-0.06368321925401688f, _416, mad(-0.3292922377586365f, _413, (_410 * 1.3704125881195068f))) - _410) * _435) + _410;
  _452 = ((mad(-0.010861365124583244f, _416, mad(1.0970927476882935f, _413, (_410 * -0.08343357592821121f))) - _413) * _435) + _413;
  _453 = ((mad(1.2036951780319214f, _416, mad(-0.09862580895423889f, _413, (_410 * -0.02579331398010254f))) - _416) * _435) + _416;
  _454 = dot(float3(_451, _452, _453), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _468 = cb0_021w + cb0_026w;
  _482 = cb0_020w * cb0_025w;
  _496 = cb0_019w * cb0_024w;
  _510 = cb0_018w * cb0_023w;
  _524 = cb0_017w * cb0_022w;
  _528 = _451 - _454;
  _529 = _452 - _454;
  _530 = _453 - _454;
  _587 = saturate(_454 / cb0_037w);
  _591 = (_587 * _587) * (3.0f - (_587 * 2.0f));
  _592 = 1.0f - _591;
  _601 = cb0_021w + cb0_036w;
  _610 = cb0_020w * cb0_035w;
  _619 = cb0_019w * cb0_034w;
  _628 = cb0_018w * cb0_033w;
  _637 = cb0_017w * cb0_032w;
  _700 = saturate((_454 - cb0_038x) / (cb0_038y - cb0_038x));
  _704 = (_700 * _700) * (3.0f - (_700 * 2.0f));
  _713 = cb0_021w + cb0_031w;
  _722 = cb0_020w * cb0_030w;
  _731 = cb0_019w * cb0_029w;
  _740 = cb0_018w * cb0_028w;
  _749 = cb0_017w * cb0_027w;
  _807 = _591 - _704;
  _818 = ((_704 * (((cb0_021x + cb0_036x) + _601) + (((cb0_020x * cb0_035x) * _610) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _628) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _637) * _528) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _619)))))) + (_592 * (((cb0_021x + cb0_026x) + _468) + (((cb0_020x * cb0_025x) * _482) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _510) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _524) * _528) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _496))))))) + ((((cb0_021x + cb0_031x) + _713) + (((cb0_020x * cb0_030x) * _722) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _740) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _749) * _528) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _731))))) * _807);
  _820 = ((_704 * (((cb0_021y + cb0_036y) + _601) + (((cb0_020y * cb0_035y) * _610) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _628) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _637) * _529) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _619)))))) + (_592 * (((cb0_021y + cb0_026y) + _468) + (((cb0_020y * cb0_025y) * _482) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _510) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _524) * _529) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _496))))))) + ((((cb0_021y + cb0_031y) + _713) + (((cb0_020y * cb0_030y) * _722) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _740) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _749) * _529) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _731))))) * _807);
  _822 = ((_704 * (((cb0_021z + cb0_036z) + _601) + (((cb0_020z * cb0_035z) * _610) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _628) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _637) * _530) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _619)))))) + (_592 * (((cb0_021z + cb0_026z) + _468) + (((cb0_020z * cb0_025z) * _482) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _510) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _524) * _530) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _496))))))) + ((((cb0_021z + cb0_031z) + _713) + (((cb0_020z * cb0_030z) * _722) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _740) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _749) * _530) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _731))))) * _807);

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
  float4 output = ProcessLutbuilder(float3(_818, _820, _822), s0, s1, t0, t1, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], asuint(cb0_042w));
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _858 = ((mad(0.061360642313957214f, _822, mad(-4.540197551250458e-09f, _820, (_818 * 0.9386394023895264f))) - _818) * cb0_038z) + _818;
  _859 = ((mad(0.169205904006958f, _822, mad(0.8307942152023315f, _820, (_818 * 6.775371730327606e-08f))) - _820) * cb0_038z) + _820;
  _860 = (mad(-2.3283064365386963e-10f, _820, (_818 * -9.313225746154785e-10f)) * cb0_038z) + _822;
  _863 = mad(0.16386905312538147f, _860, mad(0.14067868888378143f, _859, (_858 * 0.6954522132873535f)));
  _866 = mad(0.0955343246459961f, _860, mad(0.8596711158752441f, _859, (_858 * 0.044794581830501556f)));
  _869 = mad(1.0015007257461548f, _860, mad(0.004025210160762072f, _859, (_858 * -0.005525882821530104f)));
  _873 = max(max(_863, _866), _869);
  _878 = (max(_873, 1.000000013351432e-10f) - max(min(min(_863, _866), _869), 1.000000013351432e-10f)) / max(_873, 0.009999999776482582f);
  _891 = ((_866 + _863) + _869) + (sqrt((((_869 - _866) * _869) + ((_866 - _863) * _866)) + ((_863 - _869) * _863)) * 1.75f);
  _892 = _891 * 0.3333333432674408f;
  _893 = _878 + -0.4000000059604645f;
  _894 = _893 * 5.0f;
  _898 = max((1.0f - abs(_893 * 2.5f)), 0.0f);
  _909 = ((float((int)(((int)(uint)((int)(_894 > 0.0f))) - ((int)(uint)((int)(_894 < 0.0f))))) * (1.0f - (_898 * _898))) + 1.0f) * 0.02500000037252903f;
  if (_892 > 0.0533333346247673f) {
    if (_892 < 0.1599999964237213f) {
      _918 = (((0.23999999463558197f / _891) + -0.5f) * _909);
    } else {
      _918 = 0.0f;
    }
  } else {
    _918 = _909;
  }
  _919 = _918 + 1.0f;
  _920 = _919 * _863;
  _921 = _919 * _866;
  _922 = _919 * _869;
  if (!((_920 == _921) && (_921 == _922))) {
    _929 = ((_920 * 2.0f) - _921) - _922;
    _932 = ((_866 - _869) * 1.7320507764816284f) * _919;
    _934 = atan(_932 / _929);
    _937 = (_929 < 0.0f);
    _938 = (_929 == 0.0f);
    _939 = (_932 >= 0.0f);
    _940 = (_932 < 0.0f);
    _951 = select((_939 && _938), 90.0f, select((_940 && _938), -90.0f, (select((_940 && _937), (_934 + -3.1415927410125732f), select((_939 && _937), (_934 + 3.1415927410125732f), _934)) * 57.2957763671875f)));
  } else {
    _951 = 0.0f;
  }
  _956 = min(max(select((_951 < 0.0f), (_951 + 360.0f), _951), 0.0f), 360.0f);
  if (_956 < -180.0f) {
    _965 = (_956 + 360.0f);
  } else {
    if (_956 > 180.0f) {
      _965 = (_956 + -360.0f);
    } else {
      _965 = _956;
    }
  }
  _969 = saturate(1.0f - abs(_965 * 0.014814814552664757f));
  _973 = (_969 * _969) * (3.0f - (_969 * 2.0f));
  _979 = ((_973 * _973) * ((_878 * 0.18000000715255737f) * (0.029999999329447746f - _920))) + _920;
  _989 = max(0.0f, mad(-0.21492856740951538f, _922, mad(-0.2365107536315918f, _921, (_979 * 1.4514392614364624f))));
  _990 = max(0.0f, mad(-0.09967592358589172f, _922, mad(1.17622971534729f, _921, (_979 * -0.07655377686023712f))));
  _991 = max(0.0f, mad(0.9977163076400757f, _922, mad(-0.006032449658960104f, _921, (_979 * 0.008316148072481155f))));
  _992 = dot(float3(_989, _990, _991), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1007 = (cb0_040x + 1.0f) - cb0_039z;
  _1009 = cb0_040y + 1.0f;
  _1011 = _1009 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1029 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _1020 = (cb0_040x + 0.18000000715255737f) / _1007;
    _1029 = (-0.7447274923324585f - ((log2(_1020 / (2.0f - _1020)) * 0.3465735912322998f) * (_1007 / cb0_039y)));
  }
  _1032 = ((1.0f - cb0_039z) / cb0_039y) - _1029;
  _1034 = (cb0_039w / cb0_039y) - _1032;
  _1038 = log2(lerp(_992, _989, 0.9599999785423279f)) * 0.3010300099849701f;
  _1039 = log2(lerp(_992, _990, 0.9599999785423279f)) * 0.3010300099849701f;
  _1040 = log2(lerp(_992, _991, 0.9599999785423279f)) * 0.3010300099849701f;
  _1044 = cb0_039y * (_1038 + _1032);
  _1045 = cb0_039y * (_1039 + _1032);
  _1046 = cb0_039y * (_1040 + _1032);
  _1047 = _1007 * 2.0f;
  _1049 = (cb0_039y * -2.0f) / _1007;
  _1050 = _1038 - _1029;
  _1051 = _1039 - _1029;
  _1052 = _1040 - _1029;
  _1071 = _1011 * 2.0f;
  _1073 = (cb0_039y * 2.0f) / _1011;
  _1098 = select((_1038 < _1029), ((_1047 / (exp2((_1050 * 1.4426950216293335f) * _1049) + 1.0f)) - cb0_040x), _1044);
  _1099 = select((_1039 < _1029), ((_1047 / (exp2((_1051 * 1.4426950216293335f) * _1049) + 1.0f)) - cb0_040x), _1045);
  _1100 = select((_1040 < _1029), ((_1047 / (exp2((_1052 * 1.4426950216293335f) * _1049) + 1.0f)) - cb0_040x), _1046);
  _1107 = _1034 - _1029;
  _1111 = saturate(_1050 / _1107);
  _1112 = saturate(_1051 / _1107);
  _1113 = saturate(_1052 / _1107);
  _1114 = (_1034 < _1029);
  _1118 = select(_1114, (1.0f - _1111), _1111);
  _1119 = select(_1114, (1.0f - _1112), _1112);
  _1120 = select(_1114, (1.0f - _1113), _1113);
  _1139 = (((_1118 * _1118) * (select((_1038 > _1034), (_1009 - (_1071 / (exp2(((_1038 - _1034) * 1.4426950216293335f) * _1073) + 1.0f))), _1044) - _1098)) * (3.0f - (_1118 * 2.0f))) + _1098;
  _1140 = (((_1119 * _1119) * (select((_1039 > _1034), (_1009 - (_1071 / (exp2(((_1039 - _1034) * 1.4426950216293335f) * _1073) + 1.0f))), _1045) - _1099)) * (3.0f - (_1119 * 2.0f))) + _1099;
  _1141 = (((_1120 * _1120) * (select((_1040 > _1034), (_1009 - (_1071 / (exp2(((_1040 - _1034) * 1.4426950216293335f) * _1073) + 1.0f))), _1046) - _1100)) * (3.0f - (_1120 * 2.0f))) + _1100;
  _1142 = dot(float3(_1139, _1140, _1141), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1162 = (cb0_039x * (max(0.0f, (lerp(_1142, _1139, 0.9300000071525574f))) - _858)) + _858;
  _1163 = (cb0_039x * (max(0.0f, (lerp(_1142, _1140, 0.9300000071525574f))) - _859)) + _859;
  _1164 = (cb0_039x * (max(0.0f, (lerp(_1142, _1141, 0.9300000071525574f))) - _860)) + _860;
  _1180 = ((mad(-0.06537103652954102f, _1164, mad(1.451815478503704e-06f, _1163, (_1162 * 1.065374732017517f))) - _1162) * cb0_038z) + _1162;
  _1181 = ((mad(-0.20366770029067993f, _1164, mad(1.2036634683609009f, _1163, (_1162 * -2.57161445915699e-07f))) - _1163) * cb0_038z) + _1163;
  _1182 = ((mad(0.9999996423721313f, _1164, mad(2.0954757928848267e-08f, _1163, (_1162 * 1.862645149230957e-08f))) - _1164) * cb0_038z) + _1164;
  _1195 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1182, mad((WorkingColorSpace_192[0].y), _1181, ((WorkingColorSpace_192[0].x) * _1180)))));
  _1196 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1182, mad((WorkingColorSpace_192[1].y), _1181, ((WorkingColorSpace_192[1].x) * _1180)))));
  _1197 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1182, mad((WorkingColorSpace_192[2].y), _1181, ((WorkingColorSpace_192[2].x) * _1180)))));
  if (_1195 < 0.0031306699384003878f) {
    _1208 = (_1195 * 12.920000076293945f);
  } else {
    _1208 = (((pow(_1195, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1196 < 0.0031306699384003878f) {
    _1219 = (_1196 * 12.920000076293945f);
  } else {
    _1219 = (((pow(_1196, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1197 < 0.0031306699384003878f) {
    _1230 = (_1197 * 12.920000076293945f);
  } else {
    _1230 = (((pow(_1197, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1234 = (_1219 * 0.9375f) + 0.03125f;
  _1241 = _1230 * 15.0f;
  _1242 = floor(_1241);
  _1243 = _1241 - _1242;
  _1245 = (_1242 + ((_1208 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1248 = t0.SampleLevel(s0, float2(_1245, _1234), 0.0f);
  _1252 = _1245 + 0.0625f;
  _1253 = t0.SampleLevel(s0, float2(_1252, _1234), 0.0f);
  _1275 = t1.SampleLevel(s1, float2(_1245, _1234), 0.0f);
  _1279 = t1.SampleLevel(s1, float2(_1252, _1234), 0.0f);
  _1295 = (((lerp(_1248.x, _1253.x, _1243)) * cb0_005y) + (cb0_005x * _1208)) + ((lerp(_1275.x, _1279.x, _1243)) * cb0_005z);
  _1296 = (((lerp(_1248.y, _1253.y, _1243)) * cb0_005y) + (cb0_005x * _1219)) + ((lerp(_1275.y, _1279.y, _1243)) * cb0_005z);
  _1297 = (((lerp(_1248.z, _1253.z, _1243)) * cb0_005y) + (cb0_005x * _1230)) + ((lerp(_1275.z, _1279.z, _1243)) * cb0_005z);
  _1322 = select((_1295 > 0.040449999272823334f), exp2(log2((abs(_1295) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1295 * 0.07739938050508499f));
  _1323 = select((_1296 > 0.040449999272823334f), exp2(log2((abs(_1296) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1296 * 0.07739938050508499f));
  _1324 = select((_1297 > 0.040449999272823334f), exp2(log2((abs(_1297) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1297 * 0.07739938050508499f));
  _1350 = cb0_016x * (((cb0_041y + (cb0_041x * _1322)) * _1322) + cb0_041z);
  _1351 = cb0_016y * (((cb0_041y + (cb0_041x * _1323)) * _1323) + cb0_041z);
  _1352 = cb0_016z * (((cb0_041y + (cb0_041x * _1324)) * _1324) + cb0_041z);
  _1359 = ((cb0_015x - _1350) * cb0_015w) + _1350;
  _1360 = ((cb0_015y - _1351) * cb0_015w) + _1351;
  _1361 = ((cb0_015z - _1352) * cb0_015w) + _1352;
  _1362 = cb0_016x * mad((WorkingColorSpace_192[0].z), _822, mad((WorkingColorSpace_192[0].y), _820, (_818 * (WorkingColorSpace_192[0].x))));
  _1363 = cb0_016y * mad((WorkingColorSpace_192[1].z), _822, mad((WorkingColorSpace_192[1].y), _820, ((WorkingColorSpace_192[1].x) * _818)));
  _1364 = cb0_016z * mad((WorkingColorSpace_192[2].z), _822, mad((WorkingColorSpace_192[2].y), _820, ((WorkingColorSpace_192[2].x) * _818)));
  _1371 = ((cb0_015x - _1362) * cb0_015w) + _1362;
  _1372 = ((cb0_015y - _1363) * cb0_015w) + _1363;
  _1373 = ((cb0_015z - _1364) * cb0_015w) + _1364;
  _1385 = exp2(log2(max(0.0f, _1359)) * cb0_042y);
  _1386 = exp2(log2(max(0.0f, _1360)) * cb0_042y);
  _1387 = exp2(log2(max(0.0f, _1361)) * cb0_042y);
  [branch]
  if (cb0_042w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1410 = mad((WorkingColorSpace_128[0].z), _1387, mad((WorkingColorSpace_128[0].y), _1386, ((WorkingColorSpace_128[0].x) * _1385)));
      _1413 = mad((WorkingColorSpace_128[1].z), _1387, mad((WorkingColorSpace_128[1].y), _1386, ((WorkingColorSpace_128[1].x) * _1385)));
      _1416 = mad((WorkingColorSpace_128[2].z), _1387, mad((WorkingColorSpace_128[2].y), _1386, ((WorkingColorSpace_128[2].x) * _1385)));
      _1427 = mad(_65, _1416, mad(_64, _1413, (_1410 * _63)));
      _1428 = mad(_68, _1416, mad(_67, _1413, (_1410 * _66)));
      _1429 = mad(_71, _1416, mad(_70, _1413, (_1410 * _69)));
    } else {
      _1427 = _1385;
      _1428 = _1386;
      _1429 = _1387;
    }
    if (_1427 < 0.0031306699384003878f) {
      _1440 = (_1427 * 12.920000076293945f);
    } else {
      _1440 = (((pow(_1427, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1428 < 0.0031306699384003878f) {
      _1451 = (_1428 * 12.920000076293945f);
    } else {
      _1451 = (((pow(_1428, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1429 < 0.0031306699384003878f) {
      _2990 = _1440;
      _2991 = _1451;
      _2992 = (_1429 * 12.920000076293945f);
    } else {
      _2990 = _1440;
      _2991 = _1451;
      _2992 = (((pow(_1429, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_042w == 1) {
      _1478 = mad((WorkingColorSpace_128[0].z), _1387, mad((WorkingColorSpace_128[0].y), _1386, ((WorkingColorSpace_128[0].x) * _1385)));
      _1481 = mad((WorkingColorSpace_128[1].z), _1387, mad((WorkingColorSpace_128[1].y), _1386, ((WorkingColorSpace_128[1].x) * _1385)));
      _1484 = mad((WorkingColorSpace_128[2].z), _1387, mad((WorkingColorSpace_128[2].y), _1386, ((WorkingColorSpace_128[2].x) * _1385)));
      _1487 = mad(_65, _1484, mad(_64, _1481, (_1478 * _63)));
      _1490 = mad(_68, _1484, mad(_67, _1481, (_1478 * _66)));
      _1493 = mad(_71, _1484, mad(_70, _1481, (_1478 * _69)));
      _2990 = min((_1487 * 4.5f), ((exp2(log2(max(_1487, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2991 = min((_1490 * 4.5f), ((exp2(log2(max(_1490, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2992 = min((_1493 * 4.5f), ((exp2(log2(max(_1493, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((int)((uint)(cb0_042w) + (uint)(-3))) < (uint)2) {
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
        _1568 = cb0_012z * _1371;
        _1569 = cb0_012z * _1372;
        _1570 = cb0_012z * _1373;
        _1573 = mad((WorkingColorSpace_256[0].z), _1570, mad((WorkingColorSpace_256[0].y), _1569, ((WorkingColorSpace_256[0].x) * _1568)));
        _1576 = mad((WorkingColorSpace_256[1].z), _1570, mad((WorkingColorSpace_256[1].y), _1569, ((WorkingColorSpace_256[1].x) * _1568)));
        _1579 = mad((WorkingColorSpace_256[2].z), _1570, mad((WorkingColorSpace_256[2].y), _1569, ((WorkingColorSpace_256[2].x) * _1568)));
        _1582 = mad(-0.21492856740951538f, _1579, mad(-0.2365107536315918f, _1576, (_1573 * 1.4514392614364624f)));
        _1585 = mad(-0.09967592358589172f, _1579, mad(1.17622971534729f, _1576, (_1573 * -0.07655377686023712f)));
        _1588 = mad(0.9977163076400757f, _1579, mad(-0.006032449658960104f, _1576, (_1573 * 0.008316148072481155f)));
        _1590 = max(_1582, max(_1585, _1588));
        if (!(_1590 < 1.000000013351432e-10f)) {
          if (!(((_1573 < 0.0f) || (_1576 < 0.0f)) || (_1579 < 0.0f))) {
            _1600 = abs(_1590);
            _1601 = (_1590 - _1582) / _1600;
            _1603 = (_1590 - _1585) / _1600;
            _1605 = (_1590 - _1588) / _1600;
            if (!(_1601 < 0.8149999976158142f)) {
              _1608 = _1601 + -0.8149999976158142f;
              _1620 = ((_1608 / exp2(log2(exp2(log2(_1608 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1620 = _1601;
            }
            if (!(_1603 < 0.8029999732971191f)) {
              _1623 = _1603 + -0.8029999732971191f;
              _1635 = ((_1623 / exp2(log2(exp2(log2(_1623 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1635 = _1603;
            }
            if (!(_1605 < 0.8799999952316284f)) {
              _1638 = _1605 + -0.8799999952316284f;
              _1650 = ((_1638 / exp2(log2(exp2(log2(_1638 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1650 = _1605;
            }
            _1658 = (_1590 - (_1600 * _1620));
            _1659 = (_1590 - (_1600 * _1635));
            _1660 = (_1590 - (_1600 * _1650));
          } else {
            _1658 = _1582;
            _1659 = _1585;
            _1660 = _1588;
          }
        } else {
          _1658 = _1582;
          _1659 = _1585;
          _1660 = _1588;
        }
        _1676 = ((mad(0.16386906802654266f, _1660, mad(0.14067870378494263f, _1659, (_1658 * 0.6954522132873535f))) - _1573) * cb0_012w) + _1573;
        _1677 = ((mad(0.0955343171954155f, _1660, mad(0.8596711158752441f, _1659, (_1658 * 0.044794563204050064f))) - _1576) * cb0_012w) + _1576;
        _1678 = ((mad(1.0015007257461548f, _1660, mad(0.004025210160762072f, _1659, (_1658 * -0.005525882821530104f))) - _1579) * cb0_012w) + _1579;
        _1682 = max(max(_1676, _1677), _1678);
        _1687 = (max(_1682, 1.000000013351432e-10f) - max(min(min(_1676, _1677), _1678), 1.000000013351432e-10f)) / max(_1682, 0.009999999776482582f);
        _1700 = ((_1677 + _1676) + _1678) + (sqrt((((_1678 - _1677) * _1678) + ((_1677 - _1676) * _1677)) + ((_1676 - _1678) * _1676)) * 1.75f);
        _1701 = _1700 * 0.3333333432674408f;
        _1702 = _1687 + -0.4000000059604645f;
        _1703 = _1702 * 5.0f;
        _1707 = max((1.0f - abs(_1702 * 2.5f)), 0.0f);
        _1718 = ((float((int)(((int)(uint)((int)(_1703 > 0.0f))) - ((int)(uint)((int)(_1703 < 0.0f))))) * (1.0f - (_1707 * _1707))) + 1.0f) * 0.02500000037252903f;
        if (_1701 > 0.0533333346247673f) {
          if (_1701 < 0.1599999964237213f) {
            _1727 = (((0.23999999463558197f / _1700) + -0.5f) * _1718);
          } else {
            _1727 = 0.0f;
          }
        } else {
          _1727 = _1718;
        }
        _1728 = _1727 + 1.0f;
        _1729 = _1728 * _1676;
        _1730 = _1728 * _1677;
        _1731 = _1728 * _1678;
        if (!((_1729 == _1730) && (_1730 == _1731))) {
          _1738 = ((_1729 * 2.0f) - _1730) - _1731;
          _1741 = ((_1677 - _1678) * 1.7320507764816284f) * _1728;
          _1743 = atan(_1741 / _1738);
          _1746 = (_1738 < 0.0f);
          _1747 = (_1738 == 0.0f);
          _1748 = (_1741 >= 0.0f);
          _1749 = (_1741 < 0.0f);
          _1760 = select((_1748 && _1747), 90.0f, select((_1749 && _1747), -90.0f, (select((_1749 && _1746), (_1743 + -3.1415927410125732f), select((_1748 && _1746), (_1743 + 3.1415927410125732f), _1743)) * 57.2957763671875f)));
        } else {
          _1760 = 0.0f;
        }
        _1765 = min(max(select((_1760 < 0.0f), (_1760 + 360.0f), _1760), 0.0f), 360.0f);
        if (_1765 < -180.0f) {
          _1774 = (_1765 + 360.0f);
        } else {
          if (_1765 > 180.0f) {
            _1774 = (_1765 + -360.0f);
          } else {
            _1774 = _1765;
          }
        }
        if ((_1774 > -67.5f) && (_1774 < 67.5f)) {
          _1780 = (_1774 + 67.5f) * 0.029629629105329514f;
          _1781 = int(_1780);
          _1783 = _1780 - float((int)(_1781));
          _1784 = _1783 * _1783;
          _1785 = _1784 * _1783;
          if (_1781 == 3) {
            _1813 = (((0.1666666716337204f - (_1783 * 0.5f)) + (_1784 * 0.5f)) - (_1785 * 0.1666666716337204f));
          } else {
            if (_1781 == 2) {
              _1813 = ((0.6666666865348816f - _1784) + (_1785 * 0.5f));
            } else {
              if (_1781 == 1) {
                _1813 = (((_1785 * -0.5f) + 0.1666666716337204f) + ((_1784 + _1783) * 0.5f));
              } else {
                _1813 = select((_1781 == 0), (_1785 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1813 = 0.0f;
        }
        _1822 = min(max(((((_1687 * 0.27000001072883606f) * (0.029999999329447746f - _1729)) * _1813) + _1729), 0.0f), 65535.0f);
        _1823 = min(max(_1730, 0.0f), 65535.0f);
        _1824 = min(max(_1731, 0.0f), 65535.0f);
        _1837 = min(max(mad(-0.21492856740951538f, _1824, mad(-0.2365107536315918f, _1823, (_1822 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1838 = min(max(mad(-0.09967592358589172f, _1824, mad(1.17622971534729f, _1823, (_1822 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1839 = min(max(mad(0.9977163076400757f, _1824, mad(-0.006032449658960104f, _1823, (_1822 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1840 = dot(float3(_1837, _1838, _1839), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        _21[0] = cb0_010x;
        _21[1] = cb0_010y;
        _21[2] = cb0_010z;
        _21[3] = cb0_010w;
        _21[4] = cb0_012x;
        _21[5] = cb0_012x;
        _22[0] = cb0_011x;
        _22[1] = cb0_011y;
        _22[2] = cb0_011z;
        _22[3] = cb0_011w;
        _22[4] = cb0_012y;
        _22[5] = cb0_012y;
        _1863 = log2(max((lerp(_1840, _1837, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1864 = _1863 * 0.3010300099849701f;
        _1865 = log2(cb0_008x);
        _1866 = _1865 * 0.3010300099849701f;
        if (_1864 > _1866) {
          _1873 = log2(cb0_009x);
          _1874 = _1873 * 0.3010300099849701f;
          if ((_1864 > _1866) && (_1864 < _1874)) {
            _1882 = ((_1863 - _1865) * 0.9030900001525879f) / ((_1873 - _1865) * 0.3010300099849701f);
            _1883 = int(_1882);
            _1885 = _1882 - float((int)(_1883));
            _1887 = _21[min((uint)(_1883), 5u)];
            _1890 = _21[min((uint)((_1883 + 1)), 5u)];
            _1895 = _1887 * 0.5f;
            _1935 = dot(float3((_1885 * _1885), _1885, 1.0f), float3(mad((_21[min((uint)((_1883 + 2)), 5u)]), 0.5f, mad(_1890, -1.0f, _1895)), (_1890 - _1887), mad(_1890, 0.5f, _1895)));
          } else {
            if (_1864 < _1874) {
              _1935 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1904 = log2(cb0_008z);
              if (!(_1864 < (_1904 * 0.3010300099849701f))) {
                _1935 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1912 = ((_1863 - _1873) * 0.9030900001525879f) / ((_1904 - _1873) * 0.3010300099849701f);
                _1913 = int(_1912);
                _1915 = _1912 - float((int)(_1913));
                _1917 = _22[min((uint)(_1913), 5u)];
                _1920 = _22[min((uint)((_1913 + 1)), 5u)];
                _1925 = _1917 * 0.5f;
                _1935 = dot(float3((_1915 * _1915), _1915, 1.0f), float3(mad((_22[min((uint)((_1913 + 2)), 5u)]), 0.5f, mad(_1920, -1.0f, _1925)), (_1920 - _1917), mad(_1920, 0.5f, _1925)));
              }
            }
          }
        } else {
          _1935 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1939 = log2(max((lerp(_1840, _1838, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1940 = _1939 * 0.3010300099849701f;
        if (_1940 > _1866) {
          _1947 = log2(cb0_009x);
          _1948 = _1947 * 0.3010300099849701f;
          if ((_1940 > _1866) && (_1940 < _1948)) {
            _1956 = ((_1939 - _1865) * 0.9030900001525879f) / ((_1947 - _1865) * 0.3010300099849701f);
            _1957 = int(_1956);
            _1959 = _1956 - float((int)(_1957));
            _1961 = _13[min((uint)(_1957), 5u)];
            _1964 = _13[min((uint)((_1957 + 1)), 5u)];
            _1969 = _1961 * 0.5f;
            _2009 = dot(float3((_1959 * _1959), _1959, 1.0f), float3(mad((_13[min((uint)((_1957 + 2)), 5u)]), 0.5f, mad(_1964, -1.0f, _1969)), (_1964 - _1961), mad(_1964, 0.5f, _1969)));
          } else {
            if (_1940 < _1948) {
              _2009 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1978 = log2(cb0_008z);
              if (!(_1940 < (_1978 * 0.3010300099849701f))) {
                _2009 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1986 = ((_1939 - _1947) * 0.9030900001525879f) / ((_1978 - _1947) * 0.3010300099849701f);
                _1987 = int(_1986);
                _1989 = _1986 - float((int)(_1987));
                _1991 = _14[min((uint)(_1987), 5u)];
                _1994 = _14[min((uint)((_1987 + 1)), 5u)];
                _1999 = _1991 * 0.5f;
                _2009 = dot(float3((_1989 * _1989), _1989, 1.0f), float3(mad((_14[min((uint)((_1987 + 2)), 5u)]), 0.5f, mad(_1994, -1.0f, _1999)), (_1994 - _1991), mad(_1994, 0.5f, _1999)));
              }
            }
          }
        } else {
          _2009 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2013 = log2(max((lerp(_1840, _1839, 0.9599999785423279f)), 1.000000013351432e-10f));
        _2014 = _2013 * 0.3010300099849701f;
        if (_2014 > _1866) {
          _2021 = log2(cb0_009x);
          _2022 = _2021 * 0.3010300099849701f;
          if ((_2014 > _1866) && (_2014 < _2022)) {
            _2030 = ((_2013 - _1865) * 0.9030900001525879f) / ((_2021 - _1865) * 0.3010300099849701f);
            _2031 = int(_2030);
            _2033 = _2030 - float((int)(_2031));
            _2035 = _13[min((uint)(_2031), 5u)];
            _2038 = _13[min((uint)((_2031 + 1)), 5u)];
            _2043 = _2035 * 0.5f;
            _2083 = dot(float3((_2033 * _2033), _2033, 1.0f), float3(mad((_13[min((uint)((_2031 + 2)), 5u)]), 0.5f, mad(_2038, -1.0f, _2043)), (_2038 - _2035), mad(_2038, 0.5f, _2043)));
          } else {
            if (_2014 < _2022) {
              _2083 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _2052 = log2(cb0_008z);
              if (!(_2014 < (_2052 * 0.3010300099849701f))) {
                _2083 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2060 = ((_2013 - _2021) * 0.9030900001525879f) / ((_2052 - _2021) * 0.3010300099849701f);
                _2061 = int(_2060);
                _2063 = _2060 - float((int)(_2061));
                _2065 = _14[min((uint)(_2061), 5u)];
                _2068 = _14[min((uint)((_2061 + 1)), 5u)];
                _2073 = _2065 * 0.5f;
                _2083 = dot(float3((_2063 * _2063), _2063, 1.0f), float3(mad((_14[min((uint)((_2061 + 2)), 5u)]), 0.5f, mad(_2068, -1.0f, _2073)), (_2068 - _2065), mad(_2068, 0.5f, _2073)));
              }
            }
          }
        } else {
          _2083 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2087 = cb0_008w - cb0_008y;
        _2088 = (exp2(_1935 * 3.321928024291992f) - cb0_008y) / _2087;
        _2090 = (exp2(_2009 * 3.321928024291992f) - cb0_008y) / _2087;
        _2092 = (exp2(_2083 * 3.321928024291992f) - cb0_008y) / _2087;
        _2095 = mad(0.15618768334388733f, _2092, mad(0.13400420546531677f, _2090, (_2088 * 0.6624541878700256f)));
        _2098 = mad(0.053689517080783844f, _2092, mad(0.6740817427635193f, _2090, (_2088 * 0.2722287178039551f)));
        _2101 = mad(1.0103391408920288f, _2092, mad(0.00406073359772563f, _2090, (_2088 * -0.005574649665504694f)));
        _2114 = min(max(mad(-0.23642469942569733f, _2101, mad(-0.32480329275131226f, _2098, (_2095 * 1.6410233974456787f))), 0.0f), 1.0f);
        _2115 = min(max(mad(0.016756348311901093f, _2101, mad(1.6153316497802734f, _2098, (_2095 * -0.663662850856781f))), 0.0f), 1.0f);
        _2116 = min(max(mad(0.9883948564529419f, _2101, mad(-0.008284442126750946f, _2098, (_2095 * 0.011721894145011902f))), 0.0f), 1.0f);
        _2119 = mad(0.15618768334388733f, _2116, mad(0.13400420546531677f, _2115, (_2114 * 0.6624541878700256f)));
        _2122 = mad(0.053689517080783844f, _2116, mad(0.6740817427635193f, _2115, (_2114 * 0.2722287178039551f)));
        _2125 = mad(1.0103391408920288f, _2116, mad(0.00406073359772563f, _2115, (_2114 * -0.005574649665504694f)));
        _2147 = min(max((min(max(mad(-0.23642469942569733f, _2125, mad(-0.32480329275131226f, _2122, (_2119 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2148 = min(max((min(max(mad(0.016756348311901093f, _2125, mad(1.6153316497802734f, _2122, (_2119 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2149 = min(max((min(max(mad(0.9883948564529419f, _2125, mad(-0.008284442126750946f, _2122, (_2119 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2168 = exp2(log2(mad(_65, _2149, mad(_64, _2148, (_2147 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2169 = exp2(log2(mad(_68, _2149, mad(_67, _2148, (_2147 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2170 = exp2(log2(mad(_71, _2149, mad(_70, _2148, (_2147 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2990 = exp2(log2((1.0f / ((_2168 * 18.6875f) + 1.0f)) * ((_2168 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2991 = exp2(log2((1.0f / ((_2169 * 18.6875f) + 1.0f)) * ((_2169 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2992 = exp2(log2((1.0f / ((_2170 * 18.6875f) + 1.0f)) * ((_2170 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((uint)((int)((uint)(cb0_042w) + (uint)(-5))) < (uint)2) {
          _2236 = cb0_012z * _1371;
          _2237 = cb0_012z * _1372;
          _2238 = cb0_012z * _1373;
          _2241 = mad((WorkingColorSpace_256[0].z), _2238, mad((WorkingColorSpace_256[0].y), _2237, ((WorkingColorSpace_256[0].x) * _2236)));
          _2244 = mad((WorkingColorSpace_256[1].z), _2238, mad((WorkingColorSpace_256[1].y), _2237, ((WorkingColorSpace_256[1].x) * _2236)));
          _2247 = mad((WorkingColorSpace_256[2].z), _2238, mad((WorkingColorSpace_256[2].y), _2237, ((WorkingColorSpace_256[2].x) * _2236)));
          _2250 = mad(-0.21492856740951538f, _2247, mad(-0.2365107536315918f, _2244, (_2241 * 1.4514392614364624f)));
          _2253 = mad(-0.09967592358589172f, _2247, mad(1.17622971534729f, _2244, (_2241 * -0.07655377686023712f)));
          _2256 = mad(0.9977163076400757f, _2247, mad(-0.006032449658960104f, _2244, (_2241 * 0.008316148072481155f)));
          _2258 = max(_2250, max(_2253, _2256));
          if (!(_2258 < 1.000000013351432e-10f)) {
            if (!(((_2241 < 0.0f) || (_2244 < 0.0f)) || (_2247 < 0.0f))) {
              _2268 = abs(_2258);
              _2269 = (_2258 - _2250) / _2268;
              _2271 = (_2258 - _2253) / _2268;
              _2273 = (_2258 - _2256) / _2268;
              if (!(_2269 < 0.8149999976158142f)) {
                _2276 = _2269 + -0.8149999976158142f;
                _2288 = ((_2276 / exp2(log2(exp2(log2(_2276 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _2288 = _2269;
              }
              if (!(_2271 < 0.8029999732971191f)) {
                _2291 = _2271 + -0.8029999732971191f;
                _2303 = ((_2291 / exp2(log2(exp2(log2(_2291 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _2303 = _2271;
              }
              if (!(_2273 < 0.8799999952316284f)) {
                _2306 = _2273 + -0.8799999952316284f;
                _2318 = ((_2306 / exp2(log2(exp2(log2(_2306 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2318 = _2273;
              }
              _2326 = (_2258 - (_2268 * _2288));
              _2327 = (_2258 - (_2268 * _2303));
              _2328 = (_2258 - (_2268 * _2318));
            } else {
              _2326 = _2250;
              _2327 = _2253;
              _2328 = _2256;
            }
          } else {
            _2326 = _2250;
            _2327 = _2253;
            _2328 = _2256;
          }
          _2344 = ((mad(0.16386906802654266f, _2328, mad(0.14067870378494263f, _2327, (_2326 * 0.6954522132873535f))) - _2241) * cb0_012w) + _2241;
          _2345 = ((mad(0.0955343171954155f, _2328, mad(0.8596711158752441f, _2327, (_2326 * 0.044794563204050064f))) - _2244) * cb0_012w) + _2244;
          _2346 = ((mad(1.0015007257461548f, _2328, mad(0.004025210160762072f, _2327, (_2326 * -0.005525882821530104f))) - _2247) * cb0_012w) + _2247;
          _2350 = max(max(_2344, _2345), _2346);
          _2355 = (max(_2350, 1.000000013351432e-10f) - max(min(min(_2344, _2345), _2346), 1.000000013351432e-10f)) / max(_2350, 0.009999999776482582f);
          _2368 = ((_2345 + _2344) + _2346) + (sqrt((((_2346 - _2345) * _2346) + ((_2345 - _2344) * _2345)) + ((_2344 - _2346) * _2344)) * 1.75f);
          _2369 = _2368 * 0.3333333432674408f;
          _2370 = _2355 + -0.4000000059604645f;
          _2371 = _2370 * 5.0f;
          _2375 = max((1.0f - abs(_2370 * 2.5f)), 0.0f);
          _2386 = ((float((int)(((int)(uint)((int)(_2371 > 0.0f))) - ((int)(uint)((int)(_2371 < 0.0f))))) * (1.0f - (_2375 * _2375))) + 1.0f) * 0.02500000037252903f;
          if (_2369 > 0.0533333346247673f) {
            if (_2369 < 0.1599999964237213f) {
              _2395 = (((0.23999999463558197f / _2368) + -0.5f) * _2386);
            } else {
              _2395 = 0.0f;
            }
          } else {
            _2395 = _2386;
          }
          _2396 = _2395 + 1.0f;
          _2397 = _2396 * _2344;
          _2398 = _2396 * _2345;
          _2399 = _2396 * _2346;
          if (!((_2397 == _2398) && (_2398 == _2399))) {
            _2406 = ((_2397 * 2.0f) - _2398) - _2399;
            _2409 = ((_2345 - _2346) * 1.7320507764816284f) * _2396;
            _2411 = atan(_2409 / _2406);
            _2414 = (_2406 < 0.0f);
            _2415 = (_2406 == 0.0f);
            _2416 = (_2409 >= 0.0f);
            _2417 = (_2409 < 0.0f);
            _2428 = select((_2416 && _2415), 90.0f, select((_2417 && _2415), -90.0f, (select((_2417 && _2414), (_2411 + -3.1415927410125732f), select((_2416 && _2414), (_2411 + 3.1415927410125732f), _2411)) * 57.2957763671875f)));
          } else {
            _2428 = 0.0f;
          }
          _2433 = min(max(select((_2428 < 0.0f), (_2428 + 360.0f), _2428), 0.0f), 360.0f);
          if (_2433 < -180.0f) {
            _2442 = (_2433 + 360.0f);
          } else {
            if (_2433 > 180.0f) {
              _2442 = (_2433 + -360.0f);
            } else {
              _2442 = _2433;
            }
          }
          if ((_2442 > -67.5f) && (_2442 < 67.5f)) {
            _2448 = (_2442 + 67.5f) * 0.029629629105329514f;
            _2449 = int(_2448);
            _2451 = _2448 - float((int)(_2449));
            _2452 = _2451 * _2451;
            _2453 = _2452 * _2451;
            if (_2449 == 3) {
              _2481 = (((0.1666666716337204f - (_2451 * 0.5f)) + (_2452 * 0.5f)) - (_2453 * 0.1666666716337204f));
            } else {
              if (_2449 == 2) {
                _2481 = ((0.6666666865348816f - _2452) + (_2453 * 0.5f));
              } else {
                if (_2449 == 1) {
                  _2481 = (((_2453 * -0.5f) + 0.1666666716337204f) + ((_2452 + _2451) * 0.5f));
                } else {
                  _2481 = select((_2449 == 0), (_2453 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2481 = 0.0f;
          }
          _2490 = min(max(((((_2355 * 0.27000001072883606f) * (0.029999999329447746f - _2397)) * _2481) + _2397), 0.0f), 65535.0f);
          _2491 = min(max(_2398, 0.0f), 65535.0f);
          _2492 = min(max(_2399, 0.0f), 65535.0f);
          _2505 = min(max(mad(-0.21492856740951538f, _2492, mad(-0.2365107536315918f, _2491, (_2490 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2506 = min(max(mad(-0.09967592358589172f, _2492, mad(1.17622971534729f, _2491, (_2490 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2507 = min(max(mad(0.9977163076400757f, _2492, mad(-0.006032449658960104f, _2491, (_2490 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2508 = dot(float3(_2505, _2506, _2507), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
          _2531 = log2(max((lerp(_2508, _2505, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2532 = _2531 * 0.3010300099849701f;
          _2533 = log2(cb0_008x);
          _2534 = _2533 * 0.3010300099849701f;
          if (_2532 > _2534) {
            _2541 = log2(cb0_009x);
            _2542 = _2541 * 0.3010300099849701f;
            if ((_2532 > _2534) && (_2532 < _2542)) {
              _2550 = ((_2531 - _2533) * 0.9030900001525879f) / ((_2541 - _2533) * 0.3010300099849701f);
              _2551 = int(_2550);
              _2553 = _2550 - float((int)(_2551));
              _2555 = _19[min((uint)(_2551), 5u)];
              _2558 = _19[min((uint)((_2551 + 1)), 5u)];
              _2563 = _2555 * 0.5f;
              _2603 = dot(float3((_2553 * _2553), _2553, 1.0f), float3(mad((_19[min((uint)((_2551 + 2)), 5u)]), 0.5f, mad(_2558, -1.0f, _2563)), (_2558 - _2555), mad(_2558, 0.5f, _2563)));
            } else {
              if (_2532 < _2542) {
                _2603 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2572 = log2(cb0_008z);
                if (!(_2532 < (_2572 * 0.3010300099849701f))) {
                  _2603 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2580 = ((_2531 - _2541) * 0.9030900001525879f) / ((_2572 - _2541) * 0.3010300099849701f);
                  _2581 = int(_2580);
                  _2583 = _2580 - float((int)(_2581));
                  _2585 = _20[min((uint)(_2581), 5u)];
                  _2588 = _20[min((uint)((_2581 + 1)), 5u)];
                  _2593 = _2585 * 0.5f;
                  _2603 = dot(float3((_2583 * _2583), _2583, 1.0f), float3(mad((_20[min((uint)((_2581 + 2)), 5u)]), 0.5f, mad(_2588, -1.0f, _2593)), (_2588 - _2585), mad(_2588, 0.5f, _2593)));
                }
              }
            }
          } else {
            _2603 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2619 = log2(max((lerp(_2508, _2506, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2620 = _2619 * 0.3010300099849701f;
          if (_2620 > _2534) {
            _2627 = log2(cb0_009x);
            _2628 = _2627 * 0.3010300099849701f;
            if ((_2620 > _2534) && (_2620 < _2628)) {
              _2636 = ((_2619 - _2533) * 0.9030900001525879f) / ((_2627 - _2533) * 0.3010300099849701f);
              _2637 = int(_2636);
              _2639 = _2636 - float((int)(_2637));
              _2641 = _15[min((uint)(_2637), 5u)];
              _2644 = _15[min((uint)((_2637 + 1)), 5u)];
              _2649 = _2641 * 0.5f;
              _2689 = dot(float3((_2639 * _2639), _2639, 1.0f), float3(mad((_15[min((uint)((_2637 + 2)), 5u)]), 0.5f, mad(_2644, -1.0f, _2649)), (_2644 - _2641), mad(_2644, 0.5f, _2649)));
            } else {
              if (_2620 < _2628) {
                _2689 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2658 = log2(cb0_008z);
                if (!(_2620 < (_2658 * 0.3010300099849701f))) {
                  _2689 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2666 = ((_2619 - _2627) * 0.9030900001525879f) / ((_2658 - _2627) * 0.3010300099849701f);
                  _2667 = int(_2666);
                  _2669 = _2666 - float((int)(_2667));
                  _2671 = _16[min((uint)(_2667), 5u)];
                  _2674 = _16[min((uint)((_2667 + 1)), 5u)];
                  _2679 = _2671 * 0.5f;
                  _2689 = dot(float3((_2669 * _2669), _2669, 1.0f), float3(mad((_16[min((uint)((_2667 + 2)), 5u)]), 0.5f, mad(_2674, -1.0f, _2679)), (_2674 - _2671), mad(_2674, 0.5f, _2679)));
                }
              }
            }
          } else {
            _2689 = (log2(cb0_008y) * 0.3010300099849701f);
          }
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
          _2705 = log2(max((lerp(_2508, _2507, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2706 = _2705 * 0.3010300099849701f;
          if (_2706 > _2534) {
            _2713 = log2(cb0_009x);
            _2714 = _2713 * 0.3010300099849701f;
            if ((_2706 > _2534) && (_2706 < _2714)) {
              _2722 = ((_2705 - _2533) * 0.9030900001525879f) / ((_2713 - _2533) * 0.3010300099849701f);
              _2723 = int(_2722);
              _2725 = _2722 - float((int)(_2723));
              _2727 = _17[min((uint)(_2723), 5u)];
              _2730 = _17[min((uint)((_2723 + 1)), 5u)];
              _2735 = _2727 * 0.5f;
              _2775 = dot(float3((_2725 * _2725), _2725, 1.0f), float3(mad((_17[min((uint)((_2723 + 2)), 5u)]), 0.5f, mad(_2730, -1.0f, _2735)), (_2730 - _2727), mad(_2730, 0.5f, _2735)));
            } else {
              if (_2706 < _2714) {
                _2775 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2744 = log2(cb0_008z);
                if (!(_2706 < (_2744 * 0.3010300099849701f))) {
                  _2775 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2752 = ((_2705 - _2713) * 0.9030900001525879f) / ((_2744 - _2713) * 0.3010300099849701f);
                  _2753 = int(_2752);
                  _2755 = _2752 - float((int)(_2753));
                  _2757 = _18[min((uint)(_2753), 5u)];
                  _2760 = _18[min((uint)((_2753 + 1)), 5u)];
                  _2765 = _2757 * 0.5f;
                  _2775 = dot(float3((_2755 * _2755), _2755, 1.0f), float3(mad((_18[min((uint)((_2753 + 2)), 5u)]), 0.5f, mad(_2760, -1.0f, _2765)), (_2760 - _2757), mad(_2760, 0.5f, _2765)));
                }
              }
            }
          } else {
            _2775 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2779 = cb0_008w - cb0_008y;
          _2780 = (exp2(_2603 * 3.321928024291992f) - cb0_008y) / _2779;
          _2782 = (exp2(_2689 * 3.321928024291992f) - cb0_008y) / _2779;
          _2784 = (exp2(_2775 * 3.321928024291992f) - cb0_008y) / _2779;
          _2787 = mad(0.15618768334388733f, _2784, mad(0.13400420546531677f, _2782, (_2780 * 0.6624541878700256f)));
          _2790 = mad(0.053689517080783844f, _2784, mad(0.6740817427635193f, _2782, (_2780 * 0.2722287178039551f)));
          _2793 = mad(1.0103391408920288f, _2784, mad(0.00406073359772563f, _2782, (_2780 * -0.005574649665504694f)));
          _2806 = min(max(mad(-0.23642469942569733f, _2793, mad(-0.32480329275131226f, _2790, (_2787 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2807 = min(max(mad(0.016756348311901093f, _2793, mad(1.6153316497802734f, _2790, (_2787 * -0.663662850856781f))), 0.0f), 1.0f);
          _2808 = min(max(mad(0.9883948564529419f, _2793, mad(-0.008284442126750946f, _2790, (_2787 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2811 = mad(0.15618768334388733f, _2808, mad(0.13400420546531677f, _2807, (_2806 * 0.6624541878700256f)));
          _2814 = mad(0.053689517080783844f, _2808, mad(0.6740817427635193f, _2807, (_2806 * 0.2722287178039551f)));
          _2817 = mad(1.0103391408920288f, _2808, mad(0.00406073359772563f, _2807, (_2806 * -0.005574649665504694f)));
          _2839 = min(max((min(max(mad(-0.23642469942569733f, _2817, mad(-0.32480329275131226f, _2814, (_2811 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2842 = min(max((min(max(mad(0.016756348311901093f, _2817, mad(1.6153316497802734f, _2814, (_2811 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2843 = min(max((min(max(mad(0.9883948564529419f, _2817, mad(-0.008284442126750946f, _2814, (_2811 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2990 = mad(-0.0832589864730835f, _2843, mad(-0.6217921376228333f, _2842, (_2839 * 0.0213131383061409f)));
          _2991 = mad(-0.010548308491706848f, _2843, mad(1.140804648399353f, _2842, (_2839 * -0.0016282059950754046f)));
          _2992 = mad(1.1529725790023804f, _2843, mad(-0.1289689838886261f, _2842, (_2839 * -0.00030004189466126263f)));
        } else {
          if (cb0_042w == 7) {
            _2870 = mad((WorkingColorSpace_128[0].z), _1373, mad((WorkingColorSpace_128[0].y), _1372, ((WorkingColorSpace_128[0].x) * _1371)));
            _2873 = mad((WorkingColorSpace_128[1].z), _1373, mad((WorkingColorSpace_128[1].y), _1372, ((WorkingColorSpace_128[1].x) * _1371)));
            _2876 = mad((WorkingColorSpace_128[2].z), _1373, mad((WorkingColorSpace_128[2].y), _1372, ((WorkingColorSpace_128[2].x) * _1371)));
            _2895 = exp2(log2(mad(_65, _2876, mad(_64, _2873, (_2870 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2896 = exp2(log2(mad(_68, _2876, mad(_67, _2873, (_2870 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2897 = exp2(log2(mad(_71, _2876, mad(_70, _2873, (_2870 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2990 = exp2(log2((1.0f / ((_2895 * 18.6875f) + 1.0f)) * ((_2895 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2991 = exp2(log2((1.0f / ((_2896 * 18.6875f) + 1.0f)) * ((_2896 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2992 = exp2(log2((1.0f / ((_2897 * 18.6875f) + 1.0f)) * ((_2897 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                _2944 = mad((WorkingColorSpace_128[0].z), _1361, mad((WorkingColorSpace_128[0].y), _1360, ((WorkingColorSpace_128[0].x) * _1359)));
                _2947 = mad((WorkingColorSpace_128[1].z), _1361, mad((WorkingColorSpace_128[1].y), _1360, ((WorkingColorSpace_128[1].x) * _1359)));
                _2950 = mad((WorkingColorSpace_128[2].z), _1361, mad((WorkingColorSpace_128[2].y), _1360, ((WorkingColorSpace_128[2].x) * _1359)));
                _2990 = mad(_65, _2950, mad(_64, _2947, (_2944 * _63)));
                _2991 = mad(_68, _2950, mad(_67, _2947, (_2944 * _66)));
                _2992 = mad(_71, _2950, mad(_70, _2947, (_2944 * _69)));
              } else {
                _2963 = mad((WorkingColorSpace_128[0].z), _1387, mad((WorkingColorSpace_128[0].y), _1386, ((WorkingColorSpace_128[0].x) * _1385)));
                _2966 = mad((WorkingColorSpace_128[1].z), _1387, mad((WorkingColorSpace_128[1].y), _1386, ((WorkingColorSpace_128[1].x) * _1385)));
                _2969 = mad((WorkingColorSpace_128[2].z), _1387, mad((WorkingColorSpace_128[2].y), _1386, ((WorkingColorSpace_128[2].x) * _1385)));
                _2990 = exp2(log2(mad(_65, _2969, mad(_64, _2966, (_2963 * _63)))) * cb0_042z);
                _2991 = exp2(log2(mad(_68, _2969, mad(_67, _2966, (_2963 * _66)))) * cb0_042z);
                _2992 = exp2(log2(mad(_71, _2969, mad(_70, _2966, (_2963 * _69)))) * cb0_042z);
              }
            } else {
              _2990 = _1371;
              _2991 = _1372;
              _2992 = _1373;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_2990 * 0.9523810148239136f), (_2991 * 0.9523810148239136f), (_2992 * 0.9523810148239136f), 0.0f);
}
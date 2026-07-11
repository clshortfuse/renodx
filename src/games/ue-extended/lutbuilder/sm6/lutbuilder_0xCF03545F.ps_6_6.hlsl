// Neverness to Everness, UE 5.6.1
#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

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
  int cb0_042z : packoffset(c042.z);
  float cb0_043x : packoffset(c043.x);
  float cb0_043y : packoffset(c043.y);
  float cb0_043z : packoffset(c043.z);
  float cb0_044y : packoffset(c044.y);
  float cb0_044z : packoffset(c044.z);
  int cb0_044w : packoffset(c044.w);
  int cb0_045x : packoffset(c045.x);
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
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    precise noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
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
  float _1423;
  float _1424;
  float _1425;
  float _1436;
  float _1447;
  float _1616;
  float _1631;
  float _1646;
  float _1654;
  float _1655;
  float _1656;
  float _1723;
  float _1756;
  float _1770;
  float _1809;
  float _1931;
  float _2011;
  float _2085;
  float _2290;
  float _2305;
  float _2320;
  float _2328;
  float _2329;
  float _2330;
  float _2397;
  float _2430;
  float _2444;
  float _2483;
  float _2605;
  float _2691;
  float _2777;
  float _2992;
  float _2993;
  float _2994;
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
  float _1243;
  float4 _1246;
  float4 _1269;
  float4 _1275;
  float _1291;
  float _1292;
  float _1293;
  float _1318;
  float _1319;
  float _1320;
  float _1346;
  float _1347;
  float _1348;
  float _1355;
  float _1356;
  float _1357;
  float _1358;
  float _1359;
  float _1360;
  float _1367;
  float _1368;
  float _1369;
  float _1381;
  float _1382;
  float _1383;
  float _1406;
  float _1409;
  float _1412;
  float _1474;
  float _1477;
  float _1480;
  float _1483;
  float _1486;
  float _1489;
  float _1564;
  float _1565;
  float _1566;
  float _1569;
  float _1572;
  float _1575;
  float _1578;
  float _1581;
  float _1584;
  float _1586;
  float _1596;
  float _1597;
  float _1599;
  float _1601;
  float _1604;
  float _1619;
  float _1634;
  float _1672;
  float _1673;
  float _1674;
  float _1678;
  float _1683;
  float _1696;
  float _1697;
  float _1698;
  float _1699;
  float _1703;
  float _1714;
  float _1724;
  float _1725;
  float _1726;
  float _1727;
  float _1734;
  float _1737;
  float _1739;
  bool _1742;
  bool _1743;
  bool _1744;
  bool _1745;
  float _1761;
  float _1776;
  int _1777;
  float _1779;
  float _1780;
  float _1781;
  float _1818;
  float _1819;
  float _1820;
  float _1833;
  float _1834;
  float _1835;
  float _1836;
  float _1859;
  float _1860;
  float _1861;
  float _1862;
  float _1869;
  float _1870;
  float _1878;
  int _1879;
  float _1881;
  float _1883;
  float _1886;
  float _1891;
  float _1900;
  float _1908;
  int _1909;
  float _1911;
  float _1913;
  float _1916;
  float _1921;
  float _1941;
  float _1942;
  float _1949;
  float _1950;
  float _1958;
  int _1959;
  float _1961;
  float _1963;
  float _1966;
  float _1971;
  float _1980;
  float _1988;
  int _1989;
  float _1991;
  float _1993;
  float _1996;
  float _2001;
  float _2015;
  float _2016;
  float _2023;
  float _2024;
  float _2032;
  int _2033;
  float _2035;
  float _2037;
  float _2040;
  float _2045;
  float _2054;
  float _2062;
  int _2063;
  float _2065;
  float _2067;
  float _2070;
  float _2075;
  float _2089;
  float _2090;
  float _2092;
  float _2094;
  float _2097;
  float _2100;
  float _2103;
  float _2116;
  float _2117;
  float _2118;
  float _2121;
  float _2124;
  float _2127;
  float _2149;
  float _2150;
  float _2151;
  float _2170;
  float _2171;
  float _2172;
  float _2238;
  float _2239;
  float _2240;
  float _2243;
  float _2246;
  float _2249;
  float _2252;
  float _2255;
  float _2258;
  float _2260;
  float _2270;
  float _2271;
  float _2273;
  float _2275;
  float _2278;
  float _2293;
  float _2308;
  float _2346;
  float _2347;
  float _2348;
  float _2352;
  float _2357;
  float _2370;
  float _2371;
  float _2372;
  float _2373;
  float _2377;
  float _2388;
  float _2398;
  float _2399;
  float _2400;
  float _2401;
  float _2408;
  float _2411;
  float _2413;
  bool _2416;
  bool _2417;
  bool _2418;
  bool _2419;
  float _2435;
  float _2450;
  int _2451;
  float _2453;
  float _2454;
  float _2455;
  float _2492;
  float _2493;
  float _2494;
  float _2507;
  float _2508;
  float _2509;
  float _2510;
  float _2533;
  float _2534;
  float _2535;
  float _2536;
  float _2543;
  float _2544;
  float _2552;
  int _2553;
  float _2555;
  float _2557;
  float _2560;
  float _2565;
  float _2574;
  float _2582;
  int _2583;
  float _2585;
  float _2587;
  float _2590;
  float _2595;
  float _2621;
  float _2622;
  float _2629;
  float _2630;
  float _2638;
  int _2639;
  float _2641;
  float _2643;
  float _2646;
  float _2651;
  float _2660;
  float _2668;
  int _2669;
  float _2671;
  float _2673;
  float _2676;
  float _2681;
  float _2707;
  float _2708;
  float _2715;
  float _2716;
  float _2724;
  int _2725;
  float _2727;
  float _2729;
  float _2732;
  float _2737;
  float _2746;
  float _2754;
  int _2755;
  float _2757;
  float _2759;
  float _2762;
  float _2767;
  float _2781;
  float _2782;
  float _2784;
  float _2786;
  float _2789;
  float _2792;
  float _2795;
  float _2808;
  float _2809;
  float _2810;
  float _2813;
  float _2816;
  float _2819;
  float _2841;
  float _2844;
  float _2845;
  float _2872;
  float _2875;
  float _2878;
  float _2897;
  float _2898;
  float _2899;
  float _2946;
  float _2949;
  float _2952;
  float _2965;
  float _2968;
  float _2971;
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
  float _22[6];
  _25 = 0.5f / cb0_037x;
  _30 = cb0_037x + -1.0f;
  _31 = (cb0_037x * (TEXCOORD.x - _25)) / _30;
  _32 = (cb0_037x * (TEXCOORD.y - _25)) / _30;
  _34 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _30;
  if (!(cb0_045x == 1)) {
    if (!(cb0_045x == 2)) {
      if (!(cb0_045x == 3)) {
        _43 = (cb0_045x == 4);
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
  if ((uint)cb0_044w > (uint)2) {
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
    _158 = (cb0_042z != 0);
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
  //  _426 = (1.0f - exp2(((_408 * _408) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_412, _413, _414), float3(_412, _413, _414)) * -4.0f));
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
  cb_config.ue_mappingpolynomial = float3(cb0_043x, cb0_043y, cb0_043z);
  cb_config.ue_overlaycolor = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
  cb_config.ue_bluecorrection = cb0_038z;
  cb_config.ue_colorscale = float3(cb0_016x, cb0_016y, cb0_016z);
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xyz is used

  SV_Target = ProcessLutbuilder(float3(_809, _811, _813), s0, s1, t0, t1, cb_config, SV_Target, asuint(cb0_044w));
  return SV_Target;

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
  _900 = ((float((int)(((int)(uint)((bool)(_885 > 0.0f))) - ((int)(uint)((bool)(_885 < 0.0f))))) * (1.0f - (_889 * _889))) + 1.0f) * 0.02500000037252903f;
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
  if (!((bool)(_911 == _912) && (bool)(_912 == _913))) {
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
  _1236 = (_1233 + ((_1199 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1239 = t0.Sample(s0, float2(_1236, _1225));
  _1243 = _1236 + 0.0625f;
  _1246 = t0.Sample(s0, float2(_1243, _1225));
  _1269 = t1.Sample(s1, float2(_1236, _1225));
  _1275 = t1.Sample(s1, float2(_1243, _1225));
  _1291 = (((lerp(_1239.x, _1246.x, _1234)) * cb0_005y) + (cb0_005x * _1199)) + ((lerp(_1269.x, _1275.x, _1234)) * cb0_005z);
  _1292 = (((lerp(_1239.y, _1246.y, _1234)) * cb0_005y) + (cb0_005x * _1210)) + ((lerp(_1269.y, _1275.y, _1234)) * cb0_005z);
  _1293 = (((lerp(_1239.z, _1246.z, _1234)) * cb0_005y) + (cb0_005x * _1221)) + ((lerp(_1269.z, _1275.z, _1234)) * cb0_005z);
  _1318 = select((_1291 > 0.040449999272823334f), exp2(log2((abs(_1291) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1291 * 0.07739938050508499f));
  _1319 = select((_1292 > 0.040449999272823334f), exp2(log2((abs(_1292) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1292 * 0.07739938050508499f));
  _1320 = select((_1293 > 0.040449999272823334f), exp2(log2((abs(_1293) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1293 * 0.07739938050508499f));
  _1346 = cb0_016x * (((cb0_043y + (cb0_043x * _1318)) * _1318) + cb0_043z);
  _1347 = cb0_016y * (((cb0_043y + (cb0_043x * _1319)) * _1319) + cb0_043z);
  _1348 = cb0_016z * (((cb0_043y + (cb0_043x * _1320)) * _1320) + cb0_043z);
  _1355 = ((cb0_015x - _1346) * cb0_015w) + _1346;
  _1356 = ((cb0_015y - _1347) * cb0_015w) + _1347;
  _1357 = ((cb0_015z - _1348) * cb0_015w) + _1348;
  _1358 = cb0_016x * mad((WorkingColorSpace_192[0].z), _813, mad((WorkingColorSpace_192[0].y), _811, (_809 * (WorkingColorSpace_192[0].x))));
  _1359 = cb0_016y * mad((WorkingColorSpace_192[1].z), _813, mad((WorkingColorSpace_192[1].y), _811, ((WorkingColorSpace_192[1].x) * _809)));
  _1360 = cb0_016z * mad((WorkingColorSpace_192[2].z), _813, mad((WorkingColorSpace_192[2].y), _811, ((WorkingColorSpace_192[2].x) * _809)));
  _1367 = ((cb0_015x - _1358) * cb0_015w) + _1358;
  _1368 = ((cb0_015y - _1359) * cb0_015w) + _1359;
  _1369 = ((cb0_015z - _1360) * cb0_015w) + _1360;
  _1381 = exp2(log2(max(0.0f, _1355)) * cb0_044y);
  _1382 = exp2(log2(max(0.0f, _1356)) * cb0_044y);
  _1383 = exp2(log2(max(0.0f, _1357)) * cb0_044y);
  [branch]
  if (cb0_044w == 0) {
    if (WorkingColorSpace_384 == 0) {
      _1406 = mad((WorkingColorSpace_128[0].z), _1383, mad((WorkingColorSpace_128[0].y), _1382, ((WorkingColorSpace_128[0].x) * _1381)));
      _1409 = mad((WorkingColorSpace_128[1].z), _1383, mad((WorkingColorSpace_128[1].y), _1382, ((WorkingColorSpace_128[1].x) * _1381)));
      _1412 = mad((WorkingColorSpace_128[2].z), _1383, mad((WorkingColorSpace_128[2].y), _1382, ((WorkingColorSpace_128[2].x) * _1381)));
      _1423 = mad(_56, _1412, mad(_55, _1409, (_1406 * _54)));
      _1424 = mad(_59, _1412, mad(_58, _1409, (_1406 * _57)));
      _1425 = mad(_62, _1412, mad(_61, _1409, (_1406 * _60)));
    } else {
      _1423 = _1381;
      _1424 = _1382;
      _1425 = _1383;
    }
    if (_1423 < 0.0031306699384003878f) {
      _1436 = (_1423 * 12.920000076293945f);
    } else {
      _1436 = (((pow(_1423, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1424 < 0.0031306699384003878f) {
      _1447 = (_1424 * 12.920000076293945f);
    } else {
      _1447 = (((pow(_1424, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1425 < 0.0031306699384003878f) {
      _2992 = _1436;
      _2993 = _1447;
      _2994 = (_1425 * 12.920000076293945f);
    } else {
      _2992 = _1436;
      _2993 = _1447;
      _2994 = (((pow(_1425, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_044w == 1) {
      _1474 = mad((WorkingColorSpace_128[0].z), _1383, mad((WorkingColorSpace_128[0].y), _1382, ((WorkingColorSpace_128[0].x) * _1381)));
      _1477 = mad((WorkingColorSpace_128[1].z), _1383, mad((WorkingColorSpace_128[1].y), _1382, ((WorkingColorSpace_128[1].x) * _1381)));
      _1480 = mad((WorkingColorSpace_128[2].z), _1383, mad((WorkingColorSpace_128[2].y), _1382, ((WorkingColorSpace_128[2].x) * _1381)));
      _1483 = mad(_56, _1480, mad(_55, _1477, (_1474 * _54)));
      _1486 = mad(_59, _1480, mad(_58, _1477, (_1474 * _57)));
      _1489 = mad(_62, _1480, mad(_61, _1477, (_1474 * _60)));
      _2992 = min((_1483 * 4.5f), ((exp2(log2(max(_1483, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2993 = min((_1486 * 4.5f), ((exp2(log2(max(_1486, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2994 = min((_1489 * 4.5f), ((exp2(log2(max(_1489, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((uint)((int)(cb0_044w) + (uint)(-3))) < (uint)2) {
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
        _1564 = cb0_012z * _1367;
        _1565 = cb0_012z * _1368;
        _1566 = cb0_012z * _1369;
        _1569 = mad((WorkingColorSpace_256[0].z), _1566, mad((WorkingColorSpace_256[0].y), _1565, ((WorkingColorSpace_256[0].x) * _1564)));
        _1572 = mad((WorkingColorSpace_256[1].z), _1566, mad((WorkingColorSpace_256[1].y), _1565, ((WorkingColorSpace_256[1].x) * _1564)));
        _1575 = mad((WorkingColorSpace_256[2].z), _1566, mad((WorkingColorSpace_256[2].y), _1565, ((WorkingColorSpace_256[2].x) * _1564)));
        _1578 = mad(-0.21492856740951538f, _1575, mad(-0.2365107536315918f, _1572, (_1569 * 1.4514392614364624f)));
        _1581 = mad(-0.09967592358589172f, _1575, mad(1.17622971534729f, _1572, (_1569 * -0.07655377686023712f)));
        _1584 = mad(0.9977163076400757f, _1575, mad(-0.006032449658960104f, _1572, (_1569 * 0.008316148072481155f)));
        _1586 = max(_1578, max(_1581, _1584));
        if (!(_1586 < 1.000000013351432e-10f)) {
          if (!(((bool)((bool)(_1569 < 0.0f) || (bool)(_1572 < 0.0f))) || (bool)(_1575 < 0.0f))) {
            _1596 = abs(_1586);
            _1597 = (_1586 - _1578) / _1596;
            _1599 = (_1586 - _1581) / _1596;
            _1601 = (_1586 - _1584) / _1596;
            if (!(_1597 < 0.8149999976158142f)) {
              _1604 = _1597 + -0.8149999976158142f;
              _1616 = ((_1604 / exp2(log2(exp2(log2(_1604 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1616 = _1597;
            }
            if (!(_1599 < 0.8029999732971191f)) {
              _1619 = _1599 + -0.8029999732971191f;
              _1631 = ((_1619 / exp2(log2(exp2(log2(_1619 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1631 = _1599;
            }
            if (!(_1601 < 0.8799999952316284f)) {
              _1634 = _1601 + -0.8799999952316284f;
              _1646 = ((_1634 / exp2(log2(exp2(log2(_1634 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1646 = _1601;
            }
            _1654 = (_1586 - (_1596 * _1616));
            _1655 = (_1586 - (_1596 * _1631));
            _1656 = (_1586 - (_1596 * _1646));
          } else {
            _1654 = _1578;
            _1655 = _1581;
            _1656 = _1584;
          }
        } else {
          _1654 = _1578;
          _1655 = _1581;
          _1656 = _1584;
        }
        _1672 = ((mad(0.16386906802654266f, _1656, mad(0.14067870378494263f, _1655, (_1654 * 0.6954522132873535f))) - _1569) * cb0_012w) + _1569;
        _1673 = ((mad(0.0955343171954155f, _1656, mad(0.8596711158752441f, _1655, (_1654 * 0.044794563204050064f))) - _1572) * cb0_012w) + _1572;
        _1674 = ((mad(1.0015007257461548f, _1656, mad(0.004025210160762072f, _1655, (_1654 * -0.005525882821530104f))) - _1575) * cb0_012w) + _1575;
        _1678 = max(max(_1672, _1673), _1674);
        _1683 = (max(_1678, 1.000000013351432e-10f) - max(min(min(_1672, _1673), _1674), 1.000000013351432e-10f)) / max(_1678, 0.009999999776482582f);
        _1696 = ((_1673 + _1672) + _1674) + (sqrt((((_1674 - _1673) * _1674) + ((_1673 - _1672) * _1673)) + ((_1672 - _1674) * _1672)) * 1.75f);
        _1697 = _1696 * 0.3333333432674408f;
        _1698 = _1683 + -0.4000000059604645f;
        _1699 = _1698 * 5.0f;
        _1703 = max((1.0f - abs(_1698 * 2.5f)), 0.0f);
        _1714 = ((float((int)(((int)(uint)((bool)(_1699 > 0.0f))) - ((int)(uint)((bool)(_1699 < 0.0f))))) * (1.0f - (_1703 * _1703))) + 1.0f) * 0.02500000037252903f;
        if (_1697 > 0.0533333346247673f) {
          if (_1697 < 0.1599999964237213f) {
            _1723 = (((0.23999999463558197f / _1696) + -0.5f) * _1714);
          } else {
            _1723 = 0.0f;
          }
        } else {
          _1723 = _1714;
        }
        _1724 = _1723 + 1.0f;
        _1725 = _1724 * _1672;
        _1726 = _1724 * _1673;
        _1727 = _1724 * _1674;
        if (!((bool)(_1725 == _1726) && (bool)(_1726 == _1727))) {
          _1734 = ((_1725 * 2.0f) - _1726) - _1727;
          _1737 = ((_1673 - _1674) * 1.7320507764816284f) * _1724;
          _1739 = atan(_1737 / _1734);
          _1742 = (_1734 < 0.0f);
          _1743 = (_1734 == 0.0f);
          _1744 = (_1737 >= 0.0f);
          _1745 = (_1737 < 0.0f);
          _1756 = select((_1744 && _1743), 90.0f, select((_1745 && _1743), -90.0f, (select((_1745 && _1742), (_1739 + -3.1415927410125732f), select((_1744 && _1742), (_1739 + 3.1415927410125732f), _1739)) * 57.2957763671875f)));
        } else {
          _1756 = 0.0f;
        }
        _1761 = min(max(select((_1756 < 0.0f), (_1756 + 360.0f), _1756), 0.0f), 360.0f);
        if (_1761 < -180.0f) {
          _1770 = (_1761 + 360.0f);
        } else {
          if (_1761 > 180.0f) {
            _1770 = (_1761 + -360.0f);
          } else {
            _1770 = _1761;
          }
        }
        if ((bool)(_1770 > -67.5f) && (bool)(_1770 < 67.5f)) {
          _1776 = (_1770 + 67.5f) * 0.029629629105329514f;
          _1777 = int(_1776);
          _1779 = _1776 - float((int)(_1777));
          _1780 = _1779 * _1779;
          _1781 = _1780 * _1779;
          if (_1777 == 3) {
            _1809 = (((0.1666666716337204f - (_1779 * 0.5f)) + (_1780 * 0.5f)) - (_1781 * 0.1666666716337204f));
          } else {
            if (_1777 == 2) {
              _1809 = ((0.6666666865348816f - _1780) + (_1781 * 0.5f));
            } else {
              if (_1777 == 1) {
                _1809 = (((_1781 * -0.5f) + 0.1666666716337204f) + ((_1780 + _1779) * 0.5f));
              } else {
                _1809 = select((_1777 == 0), (_1781 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1809 = 0.0f;
        }
        _1818 = min(max(((((_1683 * 0.27000001072883606f) * (0.029999999329447746f - _1725)) * _1809) + _1725), 0.0f), 65535.0f);
        _1819 = min(max(_1726, 0.0f), 65535.0f);
        _1820 = min(max(_1727, 0.0f), 65535.0f);
        _1833 = min(max(mad(-0.21492856740951538f, _1820, mad(-0.2365107536315918f, _1819, (_1818 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1834 = min(max(mad(-0.09967592358589172f, _1820, mad(1.17622971534729f, _1819, (_1818 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1835 = min(max(mad(0.9977163076400757f, _1820, mad(-0.006032449658960104f, _1819, (_1818 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1836 = dot(float3(_1833, _1834, _1835), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
        _1859 = log2(max((lerp(_1836, _1833, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1860 = _1859 * 0.3010300099849701f;
        _1861 = log2(cb0_008x);
        _1862 = _1861 * 0.3010300099849701f;
        if (_1860 > _1862) {
          _1869 = log2(cb0_009x);
          _1870 = _1869 * 0.3010300099849701f;
          if ((bool)(_1860 > _1862) && (bool)(_1860 < _1870)) {
            _1878 = ((_1859 - _1861) * 0.9030900001525879f) / ((_1869 - _1861) * 0.3010300099849701f);
            _1879 = int(_1878);
            _1881 = _1878 - float((int)(_1879));
            _1883 = _20[_1879];
            _1886 = _20[(_1879 + 1)];
            _1891 = _1883 * 0.5f;
            _1931 = dot(float3((_1881 * _1881), _1881, 1.0f), float3(mad((_20[(_1879 + 2)]), 0.5f, mad(_1886, -1.0f, _1891)), (_1886 - _1883), mad(_1886, 0.5f, _1891)));
          } else {
            if ((_1860 < _1870) || ((!(_1860 < _1870)) && (!(_1860 < ((log2(cb0_008z)) * 0.3010300099849701f))))) {
              _1931 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1908 = ((_1859 - _1869) * 0.9030900001525879f) / ((_1900 - _1869) * 0.3010300099849701f);
              _1909 = int(_1908);
              _1911 = _1908 - float((int)(_1909));
              _1913 = _21[_1909];
              _1916 = _21[(_1909 + 1)];
              _1921 = _1913 * 0.5f;
              _1931 = dot(float3((_1911 * _1911), _1911, 1.0f), float3(mad((_21[(_1909 + 2)]), 0.5f, mad(_1916, -1.0f, _1921)), (_1916 - _1913), mad(_1916, 0.5f, _1921)));
            }
          }
        } else {
          _1931 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _22[0] = cb0_011x;
        _22[1] = cb0_011y;
        _22[2] = cb0_011z;
        _22[3] = cb0_011w;
        _22[4] = cb0_012y;
        _22[5] = cb0_012y;
        _1941 = log2(max((lerp(_1836, _1834, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1942 = _1941 * 0.3010300099849701f;
        if (_1942 > _1862) {
          _1949 = log2(cb0_009x);
          _1950 = _1949 * 0.3010300099849701f;
          if ((bool)(_1942 > _1862) && (bool)(_1942 < _1950)) {
            _1958 = ((_1941 - _1861) * 0.9030900001525879f) / ((_1949 - _1861) * 0.3010300099849701f);
            _1959 = int(_1958);
            _1961 = _1958 - float((int)(_1959));
            _1963 = _12[_1959];
            _1966 = _12[(_1959 + 1)];
            _1971 = _1963 * 0.5f;
            _2011 = dot(float3((_1961 * _1961), _1961, 1.0f), float3(mad((_12[(_1959 + 2)]), 0.5f, mad(_1966, -1.0f, _1971)), (_1966 - _1963), mad(_1966, 0.5f, _1971)));
          } else {
            if ((_1942 < _1950) || ((!(_1942 < _1950)) && (!(_1942 < ((log2(cb0_008z)) * 0.3010300099849701f))))) {
              _2011 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1988 = ((_1941 - _1949) * 0.9030900001525879f) / ((_1980 - _1949) * 0.3010300099849701f);
              _1989 = int(_1988);
              _1991 = _1988 - float((int)(_1989));
              _1993 = _22[_1989];
              _1996 = _22[(_1989 + 1)];
              _2001 = _1993 * 0.5f;
              _2011 = dot(float3((_1991 * _1991), _1991, 1.0f), float3(mad((_22[(_1989 + 2)]), 0.5f, mad(_1996, -1.0f, _2001)), (_1996 - _1993), mad(_1996, 0.5f, _2001)));
            }
          }
        } else {
          _2011 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2015 = log2(max((lerp(_1836, _1835, 0.9599999785423279f)), 1.000000013351432e-10f));
        _2016 = _2015 * 0.3010300099849701f;
        if (_2016 > _1862) {
          _2023 = log2(cb0_009x);
          _2024 = _2023 * 0.3010300099849701f;
          if ((bool)(_2016 > _1862) && (bool)(_2016 < _2024)) {
            _2032 = ((_2015 - _1861) * 0.9030900001525879f) / ((_2023 - _1861) * 0.3010300099849701f);
            _2033 = int(_2032);
            _2035 = _2032 - float((int)(_2033));
            _2037 = _12[_2033];
            _2040 = _12[(_2033 + 1)];
            _2045 = _2037 * 0.5f;
            _2085 = dot(float3((_2035 * _2035), _2035, 1.0f), float3(mad((_12[(_2033 + 2)]), 0.5f, mad(_2040, -1.0f, _2045)), (_2040 - _2037), mad(_2040, 0.5f, _2045)));
          } else {
            if ((_2016 < _2024) || ((!(_2016 < _2024)) && (!(_2016 < ((log2(cb0_008z)) * 0.3010300099849701f))))) {
              _2085 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _2062 = ((_2015 - _2023) * 0.9030900001525879f) / ((_2054 - _2023) * 0.3010300099849701f);
              _2063 = int(_2062);
              _2065 = _2062 - float((int)(_2063));
              _2067 = _13[_2063];
              _2070 = _13[(_2063 + 1)];
              _2075 = _2067 * 0.5f;
              _2085 = dot(float3((_2065 * _2065), _2065, 1.0f), float3(mad((_13[(_2063 + 2)]), 0.5f, mad(_2070, -1.0f, _2075)), (_2070 - _2067), mad(_2070, 0.5f, _2075)));
            }
          }
        } else {
          _2085 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _2089 = cb0_008w - cb0_008y;
        _2090 = (exp2(_1931 * 3.321928024291992f) - cb0_008y) / _2089;
        _2092 = (exp2(_2011 * 3.321928024291992f) - cb0_008y) / _2089;
        _2094 = (exp2(_2085 * 3.321928024291992f) - cb0_008y) / _2089;
        _2097 = mad(0.15618768334388733f, _2094, mad(0.13400420546531677f, _2092, (_2090 * 0.6624541878700256f)));
        _2100 = mad(0.053689517080783844f, _2094, mad(0.6740817427635193f, _2092, (_2090 * 0.2722287178039551f)));
        _2103 = mad(1.0103391408920288f, _2094, mad(0.00406073359772563f, _2092, (_2090 * -0.005574649665504694f)));
        _2116 = min(max(mad(-0.23642469942569733f, _2103, mad(-0.32480329275131226f, _2100, (_2097 * 1.6410233974456787f))), 0.0f), 1.0f);
        _2117 = min(max(mad(0.016756348311901093f, _2103, mad(1.6153316497802734f, _2100, (_2097 * -0.663662850856781f))), 0.0f), 1.0f);
        _2118 = min(max(mad(0.9883948564529419f, _2103, mad(-0.008284442126750946f, _2100, (_2097 * 0.011721894145011902f))), 0.0f), 1.0f);
        _2121 = mad(0.15618768334388733f, _2118, mad(0.13400420546531677f, _2117, (_2116 * 0.6624541878700256f)));
        _2124 = mad(0.053689517080783844f, _2118, mad(0.6740817427635193f, _2117, (_2116 * 0.2722287178039551f)));
        _2127 = mad(1.0103391408920288f, _2118, mad(0.00406073359772563f, _2117, (_2116 * -0.005574649665504694f)));
        _2149 = min(max((min(max(mad(-0.23642469942569733f, _2127, mad(-0.32480329275131226f, _2124, (_2121 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2150 = min(max((min(max(mad(0.016756348311901093f, _2127, mad(1.6153316497802734f, _2124, (_2121 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2151 = min(max((min(max(mad(0.9883948564529419f, _2127, mad(-0.008284442126750946f, _2124, (_2121 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _2170 = exp2(log2(mad(_56, _2151, mad(_55, _2150, (_2149 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2171 = exp2(log2(mad(_59, _2151, mad(_58, _2150, (_2149 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2172 = exp2(log2(mad(_62, _2151, mad(_61, _2150, (_2149 * _60))) * 9.999999747378752e-05f) * 0.1593017578125f);
        _2992 = exp2(log2((1.0f / ((_2170 * 18.6875f) + 1.0f)) * ((_2170 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2993 = exp2(log2((1.0f / ((_2171 * 18.6875f) + 1.0f)) * ((_2171 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2994 = exp2(log2((1.0f / ((_2172 * 18.6875f) + 1.0f)) * ((_2172 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((uint)((uint)((int)(cb0_044w) + (uint)(-5))) < (uint)2) {
          _2238 = cb0_012z * _1367;
          _2239 = cb0_012z * _1368;
          _2240 = cb0_012z * _1369;
          _2243 = mad((WorkingColorSpace_256[0].z), _2240, mad((WorkingColorSpace_256[0].y), _2239, ((WorkingColorSpace_256[0].x) * _2238)));
          _2246 = mad((WorkingColorSpace_256[1].z), _2240, mad((WorkingColorSpace_256[1].y), _2239, ((WorkingColorSpace_256[1].x) * _2238)));
          _2249 = mad((WorkingColorSpace_256[2].z), _2240, mad((WorkingColorSpace_256[2].y), _2239, ((WorkingColorSpace_256[2].x) * _2238)));
          _2252 = mad(-0.21492856740951538f, _2249, mad(-0.2365107536315918f, _2246, (_2243 * 1.4514392614364624f)));
          _2255 = mad(-0.09967592358589172f, _2249, mad(1.17622971534729f, _2246, (_2243 * -0.07655377686023712f)));
          _2258 = mad(0.9977163076400757f, _2249, mad(-0.006032449658960104f, _2246, (_2243 * 0.008316148072481155f)));
          _2260 = max(_2252, max(_2255, _2258));
          if (!(_2260 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_2243 < 0.0f) || (bool)(_2246 < 0.0f))) || (bool)(_2249 < 0.0f))) {
              _2270 = abs(_2260);
              _2271 = (_2260 - _2252) / _2270;
              _2273 = (_2260 - _2255) / _2270;
              _2275 = (_2260 - _2258) / _2270;
              if (!(_2271 < 0.8149999976158142f)) {
                _2278 = _2271 + -0.8149999976158142f;
                _2290 = ((_2278 / exp2(log2(exp2(log2(_2278 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _2290 = _2271;
              }
              if (!(_2273 < 0.8029999732971191f)) {
                _2293 = _2273 + -0.8029999732971191f;
                _2305 = ((_2293 / exp2(log2(exp2(log2(_2293 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _2305 = _2273;
              }
              if (!(_2275 < 0.8799999952316284f)) {
                _2308 = _2275 + -0.8799999952316284f;
                _2320 = ((_2308 / exp2(log2(exp2(log2(_2308 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2320 = _2275;
              }
              _2328 = (_2260 - (_2270 * _2290));
              _2329 = (_2260 - (_2270 * _2305));
              _2330 = (_2260 - (_2270 * _2320));
            } else {
              _2328 = _2252;
              _2329 = _2255;
              _2330 = _2258;
            }
          } else {
            _2328 = _2252;
            _2329 = _2255;
            _2330 = _2258;
          }
          _2346 = ((mad(0.16386906802654266f, _2330, mad(0.14067870378494263f, _2329, (_2328 * 0.6954522132873535f))) - _2243) * cb0_012w) + _2243;
          _2347 = ((mad(0.0955343171954155f, _2330, mad(0.8596711158752441f, _2329, (_2328 * 0.044794563204050064f))) - _2246) * cb0_012w) + _2246;
          _2348 = ((mad(1.0015007257461548f, _2330, mad(0.004025210160762072f, _2329, (_2328 * -0.005525882821530104f))) - _2249) * cb0_012w) + _2249;
          _2352 = max(max(_2346, _2347), _2348);
          _2357 = (max(_2352, 1.000000013351432e-10f) - max(min(min(_2346, _2347), _2348), 1.000000013351432e-10f)) / max(_2352, 0.009999999776482582f);
          _2370 = ((_2347 + _2346) + _2348) + (sqrt((((_2348 - _2347) * _2348) + ((_2347 - _2346) * _2347)) + ((_2346 - _2348) * _2346)) * 1.75f);
          _2371 = _2370 * 0.3333333432674408f;
          _2372 = _2357 + -0.4000000059604645f;
          _2373 = _2372 * 5.0f;
          _2377 = max((1.0f - abs(_2372 * 2.5f)), 0.0f);
          _2388 = ((float((int)(((int)(uint)((bool)(_2373 > 0.0f))) - ((int)(uint)((bool)(_2373 < 0.0f))))) * (1.0f - (_2377 * _2377))) + 1.0f) * 0.02500000037252903f;
          if (_2371 > 0.0533333346247673f) {
            if (_2371 < 0.1599999964237213f) {
              _2397 = (((0.23999999463558197f / _2370) + -0.5f) * _2388);
            } else {
              _2397 = 0.0f;
            }
          } else {
            _2397 = _2388;
          }
          _2398 = _2397 + 1.0f;
          _2399 = _2398 * _2346;
          _2400 = _2398 * _2347;
          _2401 = _2398 * _2348;
          if (!((bool)(_2399 == _2400) && (bool)(_2400 == _2401))) {
            _2408 = ((_2399 * 2.0f) - _2400) - _2401;
            _2411 = ((_2347 - _2348) * 1.7320507764816284f) * _2398;
            _2413 = atan(_2411 / _2408);
            _2416 = (_2408 < 0.0f);
            _2417 = (_2408 == 0.0f);
            _2418 = (_2411 >= 0.0f);
            _2419 = (_2411 < 0.0f);
            _2430 = select((_2418 && _2417), 90.0f, select((_2419 && _2417), -90.0f, (select((_2419 && _2416), (_2413 + -3.1415927410125732f), select((_2418 && _2416), (_2413 + 3.1415927410125732f), _2413)) * 57.2957763671875f)));
          } else {
            _2430 = 0.0f;
          }
          _2435 = min(max(select((_2430 < 0.0f), (_2430 + 360.0f), _2430), 0.0f), 360.0f);
          if (_2435 < -180.0f) {
            _2444 = (_2435 + 360.0f);
          } else {
            if (_2435 > 180.0f) {
              _2444 = (_2435 + -360.0f);
            } else {
              _2444 = _2435;
            }
          }
          if ((bool)(_2444 > -67.5f) && (bool)(_2444 < 67.5f)) {
            _2450 = (_2444 + 67.5f) * 0.029629629105329514f;
            _2451 = int(_2450);
            _2453 = _2450 - float((int)(_2451));
            _2454 = _2453 * _2453;
            _2455 = _2454 * _2453;
            if (_2451 == 3) {
              _2483 = (((0.1666666716337204f - (_2453 * 0.5f)) + (_2454 * 0.5f)) - (_2455 * 0.1666666716337204f));
            } else {
              if (_2451 == 2) {
                _2483 = ((0.6666666865348816f - _2454) + (_2455 * 0.5f));
              } else {
                if (_2451 == 1) {
                  _2483 = (((_2455 * -0.5f) + 0.1666666716337204f) + ((_2454 + _2453) * 0.5f));
                } else {
                  _2483 = select((_2451 == 0), (_2455 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2483 = 0.0f;
          }
          _2492 = min(max(((((_2357 * 0.27000001072883606f) * (0.029999999329447746f - _2399)) * _2483) + _2399), 0.0f), 65535.0f);
          _2493 = min(max(_2400, 0.0f), 65535.0f);
          _2494 = min(max(_2401, 0.0f), 65535.0f);
          _2507 = min(max(mad(-0.21492856740951538f, _2494, mad(-0.2365107536315918f, _2493, (_2492 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2508 = min(max(mad(-0.09967592358589172f, _2494, mad(1.17622971534729f, _2493, (_2492 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2509 = min(max(mad(0.9977163076400757f, _2494, mad(-0.006032449658960104f, _2493, (_2492 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2510 = dot(float3(_2507, _2508, _2509), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
          _2533 = log2(max((lerp(_2510, _2507, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2534 = _2533 * 0.3010300099849701f;
          _2535 = log2(cb0_008x);
          _2536 = _2535 * 0.3010300099849701f;
          if (_2534 > _2536) {
            _2543 = log2(cb0_009x);
            _2544 = _2543 * 0.3010300099849701f;
            if ((bool)(_2534 > _2536) && (bool)(_2534 < _2544)) {
              _2552 = ((_2533 - _2535) * 0.9030900001525879f) / ((_2543 - _2535) * 0.3010300099849701f);
              _2553 = int(_2552);
              _2555 = _2552 - float((int)(_2553));
              _2557 = _18[_2553];
              _2560 = _18[(_2553 + 1)];
              _2565 = _2557 * 0.5f;
              _2605 = dot(float3((_2555 * _2555), _2555, 1.0f), float3(mad((_18[(_2553 + 2)]), 0.5f, mad(_2560, -1.0f, _2565)), (_2560 - _2557), mad(_2560, 0.5f, _2565)));
            } else {
              if ((_2534 < _2544) || ((!(_2534 < _2544)) && (!(_2534 < ((log2(cb0_008z)) * 0.3010300099849701f))))) {
                _2605 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2582 = ((_2533 - _2543) * 0.9030900001525879f) / ((_2574 - _2543) * 0.3010300099849701f);
                _2583 = int(_2582);
                _2585 = _2582 - float((int)(_2583));
                _2587 = _19[_2583];
                _2590 = _19[(_2583 + 1)];
                _2595 = _2587 * 0.5f;
                _2605 = dot(float3((_2585 * _2585), _2585, 1.0f), float3(mad((_19[(_2583 + 2)]), 0.5f, mad(_2590, -1.0f, _2595)), (_2590 - _2587), mad(_2590, 0.5f, _2595)));
              }
            }
          } else {
            _2605 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2621 = log2(max((lerp(_2510, _2508, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2622 = _2621 * 0.3010300099849701f;
          if (_2622 > _2536) {
            _2629 = log2(cb0_009x);
            _2630 = _2629 * 0.3010300099849701f;
            if ((bool)(_2622 > _2536) && (bool)(_2622 < _2630)) {
              _2638 = ((_2621 - _2535) * 0.9030900001525879f) / ((_2629 - _2535) * 0.3010300099849701f);
              _2639 = int(_2638);
              _2641 = _2638 - float((int)(_2639));
              _2643 = _14[_2639];
              _2646 = _14[(_2639 + 1)];
              _2651 = _2643 * 0.5f;
              _2691 = dot(float3((_2641 * _2641), _2641, 1.0f), float3(mad((_14[(_2639 + 2)]), 0.5f, mad(_2646, -1.0f, _2651)), (_2646 - _2643), mad(_2646, 0.5f, _2651)));
            } else {
              if ((_2622 < _2630) || ((!(_2622 < _2630)) && (!(_2622 < ((log2(cb0_008z)) * 0.3010300099849701f))))) {
                _2691 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2668 = ((_2621 - _2629) * 0.9030900001525879f) / ((_2660 - _2629) * 0.3010300099849701f);
                _2669 = int(_2668);
                _2671 = _2668 - float((int)(_2669));
                _2673 = _15[_2669];
                _2676 = _15[(_2669 + 1)];
                _2681 = _2673 * 0.5f;
                _2691 = dot(float3((_2671 * _2671), _2671, 1.0f), float3(mad((_15[(_2669 + 2)]), 0.5f, mad(_2676, -1.0f, _2681)), (_2676 - _2673), mad(_2676, 0.5f, _2681)));
              }
            }
          } else {
            _2691 = (log2(cb0_008y) * 0.3010300099849701f);
          }
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
          _2707 = log2(max((lerp(_2510, _2509, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2708 = _2707 * 0.3010300099849701f;
          if (_2708 > _2536) {
            _2715 = log2(cb0_009x);
            _2716 = _2715 * 0.3010300099849701f;
            if ((bool)(_2708 > _2536) && (bool)(_2708 < _2716)) {
              _2724 = ((_2707 - _2535) * 0.9030900001525879f) / ((_2715 - _2535) * 0.3010300099849701f);
              _2725 = int(_2724);
              _2727 = _2724 - float((int)(_2725));
              _2729 = _16[_2725];
              _2732 = _16[(_2725 + 1)];
              _2737 = _2729 * 0.5f;
              _2777 = dot(float3((_2727 * _2727), _2727, 1.0f), float3(mad((_16[(_2725 + 2)]), 0.5f, mad(_2732, -1.0f, _2737)), (_2732 - _2729), mad(_2732, 0.5f, _2737)));
            } else {
              if ((_2708 < _2716) || ((!(_2708 < _2716)) && (!(_2708 < ((log2(cb0_008z)) * 0.3010300099849701f))))) {
                _2777 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2754 = ((_2707 - _2715) * 0.9030900001525879f) / ((_2746 - _2715) * 0.3010300099849701f);
                _2755 = int(_2754);
                _2757 = _2754 - float((int)(_2755));
                _2759 = _17[_2755];
                _2762 = _17[(_2755 + 1)];
                _2767 = _2759 * 0.5f;
                _2777 = dot(float3((_2757 * _2757), _2757, 1.0f), float3(mad((_17[(_2755 + 2)]), 0.5f, mad(_2762, -1.0f, _2767)), (_2762 - _2759), mad(_2762, 0.5f, _2767)));
              }
            }
          } else {
            _2777 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2781 = cb0_008w - cb0_008y;
          _2782 = (exp2(_2605 * 3.321928024291992f) - cb0_008y) / _2781;
          _2784 = (exp2(_2691 * 3.321928024291992f) - cb0_008y) / _2781;
          _2786 = (exp2(_2777 * 3.321928024291992f) - cb0_008y) / _2781;
          _2789 = mad(0.15618768334388733f, _2786, mad(0.13400420546531677f, _2784, (_2782 * 0.6624541878700256f)));
          _2792 = mad(0.053689517080783844f, _2786, mad(0.6740817427635193f, _2784, (_2782 * 0.2722287178039551f)));
          _2795 = mad(1.0103391408920288f, _2786, mad(0.00406073359772563f, _2784, (_2782 * -0.005574649665504694f)));
          _2808 = min(max(mad(-0.23642469942569733f, _2795, mad(-0.32480329275131226f, _2792, (_2789 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2809 = min(max(mad(0.016756348311901093f, _2795, mad(1.6153316497802734f, _2792, (_2789 * -0.663662850856781f))), 0.0f), 1.0f);
          _2810 = min(max(mad(0.9883948564529419f, _2795, mad(-0.008284442126750946f, _2792, (_2789 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2813 = mad(0.15618768334388733f, _2810, mad(0.13400420546531677f, _2809, (_2808 * 0.6624541878700256f)));
          _2816 = mad(0.053689517080783844f, _2810, mad(0.6740817427635193f, _2809, (_2808 * 0.2722287178039551f)));
          _2819 = mad(1.0103391408920288f, _2810, mad(0.00406073359772563f, _2809, (_2808 * -0.005574649665504694f)));
          _2841 = min(max((min(max(mad(-0.23642469942569733f, _2819, mad(-0.32480329275131226f, _2816, (_2813 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2844 = min(max((min(max(mad(0.016756348311901093f, _2819, mad(1.6153316497802734f, _2816, (_2813 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2845 = min(max((min(max(mad(0.9883948564529419f, _2819, mad(-0.008284442126750946f, _2816, (_2813 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
          _2992 = mad(-0.0832589864730835f, _2845, mad(-0.6217921376228333f, _2844, (_2841 * 0.0213131383061409f)));
          _2993 = mad(-0.010548308491706848f, _2845, mad(1.140804648399353f, _2844, (_2841 * -0.0016282059950754046f)));
          _2994 = mad(1.1529725790023804f, _2845, mad(-0.1289689838886261f, _2844, (_2841 * -0.00030004189466126263f)));
        } else {
          if (cb0_044w == 7) {
            _2872 = mad((WorkingColorSpace_128[0].z), _1369, mad((WorkingColorSpace_128[0].y), _1368, ((WorkingColorSpace_128[0].x) * _1367)));
            _2875 = mad((WorkingColorSpace_128[1].z), _1369, mad((WorkingColorSpace_128[1].y), _1368, ((WorkingColorSpace_128[1].x) * _1367)));
            _2878 = mad((WorkingColorSpace_128[2].z), _1369, mad((WorkingColorSpace_128[2].y), _1368, ((WorkingColorSpace_128[2].x) * _1367)));
            _2897 = exp2(log2(mad(_56, _2878, mad(_55, _2875, (_2872 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2898 = exp2(log2(mad(_59, _2878, mad(_58, _2875, (_2872 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2899 = exp2(log2(mad(_62, _2878, mad(_61, _2875, (_2872 * _60))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2992 = exp2(log2((1.0f / ((_2897 * 18.6875f) + 1.0f)) * ((_2897 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2993 = exp2(log2((1.0f / ((_2898 * 18.6875f) + 1.0f)) * ((_2898 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2994 = exp2(log2((1.0f / ((_2899 * 18.6875f) + 1.0f)) * ((_2899 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_044w == 8)) {
              if (cb0_044w == 9) {
                _2946 = mad((WorkingColorSpace_128[0].z), _1357, mad((WorkingColorSpace_128[0].y), _1356, ((WorkingColorSpace_128[0].x) * _1355)));
                _2949 = mad((WorkingColorSpace_128[1].z), _1357, mad((WorkingColorSpace_128[1].y), _1356, ((WorkingColorSpace_128[1].x) * _1355)));
                _2952 = mad((WorkingColorSpace_128[2].z), _1357, mad((WorkingColorSpace_128[2].y), _1356, ((WorkingColorSpace_128[2].x) * _1355)));
                _2992 = mad(_56, _2952, mad(_55, _2949, (_2946 * _54)));
                _2993 = mad(_59, _2952, mad(_58, _2949, (_2946 * _57)));
                _2994 = mad(_62, _2952, mad(_61, _2949, (_2946 * _60)));
              } else {
                _2965 = mad((WorkingColorSpace_128[0].z), _1383, mad((WorkingColorSpace_128[0].y), _1382, ((WorkingColorSpace_128[0].x) * _1381)));
                _2968 = mad((WorkingColorSpace_128[1].z), _1383, mad((WorkingColorSpace_128[1].y), _1382, ((WorkingColorSpace_128[1].x) * _1381)));
                _2971 = mad((WorkingColorSpace_128[2].z), _1383, mad((WorkingColorSpace_128[2].y), _1382, ((WorkingColorSpace_128[2].x) * _1381)));
                _2992 = exp2(log2(mad(_56, _2971, mad(_55, _2968, (_2965 * _54)))) * cb0_044z);
                _2993 = exp2(log2(mad(_59, _2971, mad(_58, _2968, (_2965 * _57)))) * cb0_044z);
                _2994 = exp2(log2(mad(_62, _2971, mad(_61, _2968, (_2965 * _60)))) * cb0_044z);
              }
            } else {
              _2992 = _1367;
              _2993 = _1368;
              _2994 = _1369;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2992 * 0.9523810148239136f);
  SV_Target.y = (_2993 * 0.9523810148239136f);
  SV_Target.z = (_2994 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}

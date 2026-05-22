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
  float _562;
  float _572;
  float _582;
  float _659;
  float _660;
  float _661;
  float _671;
  float _681;
  float _691;
  float _699;
  float _700;
  float _701;
  float _798;
  float _831;
  float _845;
  float _909;
  float _1177;
  float _1178;
  float _1179;
  float _1190;
  float _1201;
  float _1374;
  float _1389;
  float _1404;
  float _1412;
  float _1413;
  float _1414;
  float _1481;
  float _1514;
  float _1528;
  float _1567;
  float _1689;
  float _1775;
  float _1849;
  float _1928;
  float _1929;
  float _1930;
  float _2060;
  float _2075;
  float _2090;
  float _2098;
  float _2099;
  float _2100;
  float _2167;
  float _2200;
  float _2214;
  float _2253;
  float _2375;
  float _2461;
  float _2547;
  float _2626;
  float _2627;
  float _2628;
  float _2805;
  float _2806;
  float _2807;
  bool _42;
  float _72;
  float _73;
  float _74;
  float _136;
  float _139;
  float _142;
  float _143;
  float _147;
  float _148;
  float _149;
  float _161;
  float _177;
  float _178;
  float _179;
  float _180;
  float _194;
  float _208;
  float _222;
  float _236;
  float _250;
  float _254;
  float _255;
  float _256;
  float _313;
  float _317;
  float _318;
  float _327;
  float _336;
  float _345;
  float _354;
  float _363;
  float _426;
  float _430;
  float _439;
  float _448;
  float _457;
  float _466;
  float _475;
  float _533;
  float _544;
  float _546;
  float _548;
  float _586;
  float _587;
  float _588;
  float4 _593;
  float4 _601;
  float4 _606;
  float4 _611;
  float _627;
  float _628;
  float _629;
  float _630;
  float _631;
  float _632;
  float _633;
  float _651;
  float _738;
  float _739;
  float _740;
  float _743;
  float _746;
  float _749;
  float _753;
  float _758;
  float _771;
  float _772;
  float _773;
  float _774;
  float _778;
  float _789;
  float _799;
  float _800;
  float _801;
  float _802;
  float _809;
  float _812;
  float _814;
  bool _817;
  bool _818;
  bool _819;
  bool _820;
  float _836;
  float _849;
  float _853;
  float _859;
  float _869;
  float _870;
  float _871;
  float _872;
  float _887;
  float _889;
  float _891;
  float _900;
  float _912;
  float _914;
  float _918;
  float _919;
  float _920;
  float _924;
  float _925;
  float _926;
  float _927;
  float _929;
  float _930;
  float _931;
  float _932;
  float _951;
  float _953;
  float _978;
  float _979;
  float _980;
  float _987;
  float _991;
  float _992;
  float _993;
  bool _994;
  float _998;
  float _999;
  float _1000;
  float _1019;
  float _1020;
  float _1021;
  float _1022;
  float _1042;
  float _1043;
  float _1044;
  float _1060;
  float _1061;
  float _1062;
  float _1072;
  float _1073;
  float _1074;
  float _1100;
  float _1101;
  float _1102;
  float _1109;
  float _1110;
  float _1111;
  float _1112;
  float _1113;
  float _1114;
  float _1121;
  float _1122;
  float _1123;
  float _1135;
  float _1136;
  float _1137;
  float _1160;
  float _1163;
  float _1166;
  float _1228;
  float _1231;
  float _1234;
  float _1244;
  float _1245;
  float _1246;
  float _1322;
  float _1323;
  float _1324;
  float _1327;
  float _1330;
  float _1333;
  float _1336;
  float _1339;
  float _1342;
  float _1344;
  float _1354;
  float _1355;
  float _1357;
  float _1359;
  float _1362;
  float _1377;
  float _1392;
  float _1430;
  float _1431;
  float _1432;
  float _1436;
  float _1441;
  float _1454;
  float _1455;
  float _1456;
  float _1457;
  float _1461;
  float _1472;
  float _1482;
  float _1483;
  float _1484;
  float _1485;
  float _1492;
  float _1495;
  float _1497;
  bool _1500;
  bool _1501;
  bool _1502;
  bool _1503;
  float _1519;
  float _1534;
  int _1535;
  float _1537;
  float _1538;
  float _1539;
  float _1576;
  float _1577;
  float _1578;
  float _1591;
  float _1592;
  float _1593;
  float _1594;
  float _1617;
  float _1618;
  float _1619;
  float _1620;
  float _1627;
  float _1628;
  float _1636;
  int _1637;
  float _1639;
  float _1641;
  float _1644;
  float _1649;
  float _1658;
  float _1666;
  int _1667;
  float _1669;
  float _1671;
  float _1674;
  float _1679;
  float _1705;
  float _1706;
  float _1713;
  float _1714;
  float _1722;
  int _1723;
  float _1725;
  float _1727;
  float _1730;
  float _1735;
  float _1744;
  float _1752;
  int _1753;
  float _1755;
  float _1757;
  float _1760;
  float _1765;
  float _1779;
  float _1780;
  float _1787;
  float _1788;
  float _1796;
  int _1797;
  float _1799;
  float _1801;
  float _1804;
  float _1809;
  float _1818;
  float _1826;
  int _1827;
  float _1829;
  float _1831;
  float _1834;
  float _1839;
  float _1853;
  float _1854;
  float _1856;
  float _1858;
  float _1861;
  float _1864;
  float _1867;
  float _1880;
  float _1881;
  float _1882;
  float _1885;
  float _1888;
  float _1891;
  float _1913;
  float _1914;
  float _1915;
  float _1940;
  float _1941;
  float _1942;
  float _2008;
  float _2009;
  float _2010;
  float _2013;
  float _2016;
  float _2019;
  float _2022;
  float _2025;
  float _2028;
  float _2030;
  float _2040;
  float _2041;
  float _2043;
  float _2045;
  float _2048;
  float _2063;
  float _2078;
  float _2116;
  float _2117;
  float _2118;
  float _2122;
  float _2127;
  float _2140;
  float _2141;
  float _2142;
  float _2143;
  float _2147;
  float _2158;
  float _2168;
  float _2169;
  float _2170;
  float _2171;
  float _2178;
  float _2181;
  float _2183;
  bool _2186;
  bool _2187;
  bool _2188;
  bool _2189;
  float _2205;
  float _2220;
  int _2221;
  float _2223;
  float _2224;
  float _2225;
  float _2262;
  float _2263;
  float _2264;
  float _2277;
  float _2278;
  float _2279;
  float _2280;
  float _2303;
  float _2304;
  float _2305;
  float _2306;
  float _2313;
  float _2314;
  float _2322;
  int _2323;
  float _2325;
  float _2327;
  float _2330;
  float _2335;
  float _2344;
  float _2352;
  int _2353;
  float _2355;
  float _2357;
  float _2360;
  float _2365;
  float _2391;
  float _2392;
  float _2399;
  float _2400;
  float _2408;
  int _2409;
  float _2411;
  float _2413;
  float _2416;
  float _2421;
  float _2430;
  float _2438;
  int _2439;
  float _2441;
  float _2443;
  float _2446;
  float _2451;
  float _2477;
  float _2478;
  float _2485;
  float _2486;
  float _2494;
  int _2495;
  float _2497;
  float _2499;
  float _2502;
  float _2507;
  float _2516;
  float _2524;
  int _2525;
  float _2527;
  float _2529;
  float _2532;
  float _2537;
  float _2551;
  float _2552;
  float _2554;
  float _2556;
  float _2559;
  float _2562;
  float _2565;
  float _2578;
  float _2579;
  float _2580;
  float _2583;
  float _2586;
  float _2589;
  float _2611;
  float _2612;
  float _2613;
  float _2638;
  float _2639;
  float _2640;
  float _2685;
  float _2688;
  float _2691;
  float _2710;
  float _2711;
  float _2712;
  float _2759;
  float _2762;
  float _2765;
  float _2778;
  float _2781;
  float _2784;
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
  _136 = mad((WorkingColorSpace_128[0].z), _121, mad((WorkingColorSpace_128[0].y), _120, ((WorkingColorSpace_128[0].x) * _119)));
  _139 = mad((WorkingColorSpace_128[1].z), _121, mad((WorkingColorSpace_128[1].y), _120, ((WorkingColorSpace_128[1].x) * _119)));
  _142 = mad((WorkingColorSpace_128[2].z), _121, mad((WorkingColorSpace_128[2].y), _120, ((WorkingColorSpace_128[2].x) * _119)));
  _143 = dot(float3(_136, _139, _142), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _147 = (_136 / _143) + -1.0f;
  _148 = (_139 / _143) + -1.0f;
  _149 = (_142 / _143) + -1.0f;
  _161 = (1.0f - exp2(((_143 * _143) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_147, _148, _149), float3(_147, _148, _149)) * -4.0f));
  _177 = ((mad(-0.06368321925401688f, _142, mad(-0.3292922377586365f, _139, (_136 * 1.3704125881195068f))) - _136) * _161) + _136;
  _178 = ((mad(-0.010861365124583244f, _142, mad(1.0970927476882935f, _139, (_136 * -0.08343357592821121f))) - _139) * _161) + _139;
  _179 = ((mad(1.2036951780319214f, _142, mad(-0.09862580895423889f, _139, (_136 * -0.02579331398010254f))) - _142) * _161) + _142;
  _180 = dot(float3(_177, _178, _179), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _194 = cb0_019w + cb0_024w;
  _208 = cb0_018w * cb0_023w;
  _222 = cb0_017w * cb0_022w;
  _236 = cb0_016w * cb0_021w;
  _250 = cb0_015w * cb0_020w;
  _254 = _177 - _180;
  _255 = _178 - _180;
  _256 = _179 - _180;
  _313 = saturate(_180 / cb0_035w);
  _317 = (_313 * _313) * (3.0f - (_313 * 2.0f));
  _318 = 1.0f - _317;
  _327 = cb0_019w + cb0_034w;
  _336 = cb0_018w * cb0_033w;
  _345 = cb0_017w * cb0_032w;
  _354 = cb0_016w * cb0_031w;
  _363 = cb0_015w * cb0_030w;
  _426 = saturate((_180 - cb0_036x) / (cb0_036y - cb0_036x));
  _430 = (_426 * _426) * (3.0f - (_426 * 2.0f));
  _439 = cb0_019w + cb0_029w;
  _448 = cb0_018w * cb0_028w;
  _457 = cb0_017w * cb0_027w;
  _466 = cb0_016w * cb0_026w;
  _475 = cb0_015w * cb0_025w;
  _533 = _317 - _430;
  _544 = ((_430 * (((cb0_019x + cb0_034x) + _327) + (((cb0_018x * cb0_033x) * _336) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _354) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _363) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _345)))))) + (_318 * (((cb0_019x + cb0_024x) + _194) + (((cb0_018x * cb0_023x) * _208) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _236) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _250) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _222))))))) + ((((cb0_019x + cb0_029x) + _439) + (((cb0_018x * cb0_028x) * _448) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _466) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _475) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _457))))) * _533);
  _546 = ((_430 * (((cb0_019y + cb0_034y) + _327) + (((cb0_018y * cb0_033y) * _336) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _354) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _363) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _345)))))) + (_318 * (((cb0_019y + cb0_024y) + _194) + (((cb0_018y * cb0_023y) * _208) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _236) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _250) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _222))))))) + ((((cb0_019y + cb0_029y) + _439) + (((cb0_018y * cb0_028y) * _448) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _466) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _475) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _457))))) * _533);
  _548 = ((_430 * (((cb0_019z + cb0_034z) + _327) + (((cb0_018z * cb0_033z) * _336) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _354) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _363) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _345)))))) + (_318 * (((cb0_019z + cb0_024z) + _194) + (((cb0_018z * cb0_023z) * _208) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _236) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _250) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _222))))))) + ((((cb0_019z + cb0_029z) + _439) + (((cb0_018z * cb0_028z) * _448) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _466) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _475) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _457))))) * _533);
  if (!(cb0_042x == 0)) {
    if (_544 > 0.0078125f) {
      _562 = ((log2(_544) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _562 = ((_544 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_546 > 0.0078125f) {
      _572 = ((log2(_546) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _572 = ((_546 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_548 > 0.0078125f) {
      _582 = ((log2(_548) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _582 = ((_548 * 10.540237426757812f) + 0.072905533015728f);
    }
    _586 = min(max(_562, 0.0f), 1.0f);
    _587 = min(max(_572, 0.0f), 1.0f);
    _588 = min(max(_582, 0.0f), 1.0f);
    _593 = t0.Sample(s0, float3(_586, _587, _588));
    if (cb0_042y == 1) {
      _601 = t0.Sample(s0, float3((cb0_042z + _586), _587, _588));
      _606 = t0.Sample(s0, float3(_586, (cb0_042z + _587), _588));
      _611 = t0.Sample(s0, float3(_586, _587, (cb0_042z + _588)));
      _627 = saturate(1.0f - abs(_586 - floor(_586)));
      _628 = saturate(1.0f - abs(_587 - floor(_587)));
      _629 = saturate(1.0f - abs(_588 - floor(_588)));
      _630 = dot(float3(_627, _628, _629), float3(1.0f, 1.0f, 1.0f));
      _631 = _627 / _630;
      _632 = _628 / _630;
      _633 = _629 / _630;
      _651 = ((1.0f - _631) - _632) - _633;
      _659 = ((((_632 * _601.x) + (_631 * _593.x)) + (_633 * _606.x)) + (_651 * _611.x));
      _660 = ((((_632 * _601.y) + (_631 * _593.y)) + (_633 * _606.y)) + (_651 * _611.y));
      _661 = ((((_632 * _601.z) + (_631 * _593.z)) + (_633 * _606.z)) + (_651 * _611.z));
    } else {
      _659 = _593.x;
      _660 = _593.y;
      _661 = _593.z;
    }
    if (_659 > 0.155251145362854f) {
      _671 = exp2((_659 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _671 = ((_659 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_660 > 0.155251145362854f) {
      _681 = exp2((_660 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _681 = ((_660 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_661 > 0.155251145362854f) {
      _691 = exp2((_661 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _691 = ((_661 + -0.072905533015728f) * 0.09487452358007431f);
    }
    _699 = min(max(_671, 0.0f), 65504.0f);
    _700 = min(max(_681, 0.0f), 65504.0f);
    _701 = min(max(_691, 0.0f), 65504.0f);
  } else {
    _699 = _544;
    _700 = _546;
    _701 = _548;
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
  float4 output = ProcessLutbuilder(float3(_699, _700, _701), cb_config, SV_Target, asuint(cb0_040w));
  SV_Target = output;
  return SV_Target;
  _738 = ((mad(0.061360642313957214f, _701, mad(-4.540197551250458e-09f, _700, (_699 * 0.9386394023895264f))) - _699) * cb0_036z) + _699;
  _739 = ((mad(0.169205904006958f, _701, mad(0.8307942152023315f, _700, (_699 * 6.775371730327606e-08f))) - _700) * cb0_036z) + _700;
  _740 = (mad(-2.3283064365386963e-10f, _700, (_699 * -9.313225746154785e-10f)) * cb0_036z) + _701;
  _743 = mad(0.16386905312538147f, _740, mad(0.14067868888378143f, _739, (_738 * 0.6954522132873535f)));
  _746 = mad(0.0955343246459961f, _740, mad(0.8596711158752441f, _739, (_738 * 0.044794581830501556f)));
  _749 = mad(1.0015007257461548f, _740, mad(0.004025210160762072f, _739, (_738 * -0.005525882821530104f)));
  _753 = max(max(_743, _746), _749);
  _758 = (max(_753, 1.000000013351432e-10f) - max(min(min(_743, _746), _749), 1.000000013351432e-10f)) / max(_753, 0.009999999776482582f);
  _771 = ((_746 + _743) + _749) + (sqrt((((_749 - _746) * _749) + ((_746 - _743) * _746)) + ((_743 - _749) * _743)) * 1.75f);
  _772 = _771 * 0.3333333432674408f;
  _773 = _758 + -0.4000000059604645f;
  _774 = _773 * 5.0f;
  _778 = max((1.0f - abs(_773 * 2.5f)), 0.0f);
  _789 = ((float((int)(((int)(uint)((int)(_774 > 0.0f))) - ((int)(uint)((int)(_774 < 0.0f))))) * (1.0f - (_778 * _778))) + 1.0f) * 0.02500000037252903f;
  if (_772 > 0.0533333346247673f) {
    if (_772 < 0.1599999964237213f) {
      _798 = (((0.23999999463558197f / _771) + -0.5f) * _789);
    } else {
      _798 = 0.0f;
    }
  } else {
    _798 = _789;
  }
  _799 = _798 + 1.0f;
  _800 = _799 * _743;
  _801 = _799 * _746;
  _802 = _799 * _749;
  if (!((_800 == _801) && (_801 == _802))) {
    _809 = ((_800 * 2.0f) - _801) - _802;
    _812 = ((_746 - _749) * 1.7320507764816284f) * _799;
    _814 = atan(_812 / _809);
    _817 = (_809 < 0.0f);
    _818 = (_809 == 0.0f);
    _819 = (_812 >= 0.0f);
    _820 = (_812 < 0.0f);
    _831 = select((_819 && _818), 90.0f, select((_820 && _818), -90.0f, (select((_820 && _817), (_814 + -3.1415927410125732f), select((_819 && _817), (_814 + 3.1415927410125732f), _814)) * 57.2957763671875f)));
  } else {
    _831 = 0.0f;
  }
  _836 = min(max(select((_831 < 0.0f), (_831 + 360.0f), _831), 0.0f), 360.0f);
  if (_836 < -180.0f) {
    _845 = (_836 + 360.0f);
  } else {
    if (_836 > 180.0f) {
      _845 = (_836 + -360.0f);
    } else {
      _845 = _836;
    }
  }
  _849 = saturate(1.0f - abs(_845 * 0.014814814552664757f));
  _853 = (_849 * _849) * (3.0f - (_849 * 2.0f));
  _859 = ((_853 * _853) * ((_758 * 0.18000000715255737f) * (0.029999999329447746f - _800))) + _800;
  _869 = max(0.0f, mad(-0.21492856740951538f, _802, mad(-0.2365107536315918f, _801, (_859 * 1.4514392614364624f))));
  _870 = max(0.0f, mad(-0.09967592358589172f, _802, mad(1.17622971534729f, _801, (_859 * -0.07655377686023712f))));
  _871 = max(0.0f, mad(0.9977163076400757f, _802, mad(-0.006032449658960104f, _801, (_859 * 0.008316148072481155f))));
  _872 = dot(float3(_869, _870, _871), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _887 = (cb0_038x + 1.0f) - cb0_037z;
  _889 = cb0_038y + 1.0f;
  _891 = _889 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _909 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    _900 = (cb0_038x + 0.18000000715255737f) / _887;
    _909 = (-0.7447274923324585f - ((log2(_900 / (2.0f - _900)) * 0.3465735912322998f) * (_887 / cb0_037y)));
  }
  _912 = ((1.0f - cb0_037z) / cb0_037y) - _909;
  _914 = (cb0_037w / cb0_037y) - _912;
  _918 = log2(lerp(_872, _869, 0.9599999785423279f)) * 0.3010300099849701f;
  _919 = log2(lerp(_872, _870, 0.9599999785423279f)) * 0.3010300099849701f;
  _920 = log2(lerp(_872, _871, 0.9599999785423279f)) * 0.3010300099849701f;
  _924 = cb0_037y * (_918 + _912);
  _925 = cb0_037y * (_919 + _912);
  _926 = cb0_037y * (_920 + _912);
  _927 = _887 * 2.0f;
  _929 = (cb0_037y * -2.0f) / _887;
  _930 = _918 - _909;
  _931 = _919 - _909;
  _932 = _920 - _909;
  _951 = _891 * 2.0f;
  _953 = (cb0_037y * 2.0f) / _891;
  _978 = select((_918 < _909), ((_927 / (exp2((_930 * 1.4426950216293335f) * _929) + 1.0f)) - cb0_038x), _924);
  _979 = select((_919 < _909), ((_927 / (exp2((_931 * 1.4426950216293335f) * _929) + 1.0f)) - cb0_038x), _925);
  _980 = select((_920 < _909), ((_927 / (exp2((_932 * 1.4426950216293335f) * _929) + 1.0f)) - cb0_038x), _926);
  _987 = _914 - _909;
  _991 = saturate(_930 / _987);
  _992 = saturate(_931 / _987);
  _993 = saturate(_932 / _987);
  _994 = (_914 < _909);
  _998 = select(_994, (1.0f - _991), _991);
  _999 = select(_994, (1.0f - _992), _992);
  _1000 = select(_994, (1.0f - _993), _993);
  _1019 = (((_998 * _998) * (select((_918 > _914), (_889 - (_951 / (exp2(((_918 - _914) * 1.4426950216293335f) * _953) + 1.0f))), _924) - _978)) * (3.0f - (_998 * 2.0f))) + _978;
  _1020 = (((_999 * _999) * (select((_919 > _914), (_889 - (_951 / (exp2(((_919 - _914) * 1.4426950216293335f) * _953) + 1.0f))), _925) - _979)) * (3.0f - (_999 * 2.0f))) + _979;
  _1021 = (((_1000 * _1000) * (select((_920 > _914), (_889 - (_951 / (exp2(((_920 - _914) * 1.4426950216293335f) * _953) + 1.0f))), _926) - _980)) * (3.0f - (_1000 * 2.0f))) + _980;
  _1022 = dot(float3(_1019, _1020, _1021), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1042 = (cb0_037x * (max(0.0f, (lerp(_1022, _1019, 0.9300000071525574f))) - _738)) + _738;
  _1043 = (cb0_037x * (max(0.0f, (lerp(_1022, _1020, 0.9300000071525574f))) - _739)) + _739;
  _1044 = (cb0_037x * (max(0.0f, (lerp(_1022, _1021, 0.9300000071525574f))) - _740)) + _740;
  _1060 = ((mad(-0.06537103652954102f, _1044, mad(1.451815478503704e-06f, _1043, (_1042 * 1.065374732017517f))) - _1042) * cb0_036z) + _1042;
  _1061 = ((mad(-0.20366770029067993f, _1044, mad(1.2036634683609009f, _1043, (_1042 * -2.57161445915699e-07f))) - _1043) * cb0_036z) + _1043;
  _1062 = ((mad(0.9999996423721313f, _1044, mad(2.0954757928848267e-08f, _1043, (_1042 * 1.862645149230957e-08f))) - _1044) * cb0_036z) + _1044;
  _1072 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1062, mad((WorkingColorSpace_192[0].y), _1061, ((WorkingColorSpace_192[0].x) * _1060))));
  _1073 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1062, mad((WorkingColorSpace_192[1].y), _1061, ((WorkingColorSpace_192[1].x) * _1060))));
  _1074 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1062, mad((WorkingColorSpace_192[2].y), _1061, ((WorkingColorSpace_192[2].x) * _1060))));
  _1100 = cb0_014x * (((cb0_039y + (cb0_039x * _1072)) * _1072) + cb0_039z);
  _1101 = cb0_014y * (((cb0_039y + (cb0_039x * _1073)) * _1073) + cb0_039z);
  _1102 = cb0_014z * (((cb0_039y + (cb0_039x * _1074)) * _1074) + cb0_039z);
  _1109 = ((cb0_013x - _1100) * cb0_013w) + _1100;
  _1110 = ((cb0_013y - _1101) * cb0_013w) + _1101;
  _1111 = ((cb0_013z - _1102) * cb0_013w) + _1102;
  _1112 = cb0_014x * mad((WorkingColorSpace_192[0].z), _701, mad((WorkingColorSpace_192[0].y), _700, ((WorkingColorSpace_192[0].x) * _699)));
  _1113 = cb0_014y * mad((WorkingColorSpace_192[1].z), _701, mad((WorkingColorSpace_192[1].y), _700, ((WorkingColorSpace_192[1].x) * _699)));
  _1114 = cb0_014z * mad((WorkingColorSpace_192[2].z), _701, mad((WorkingColorSpace_192[2].y), _700, ((WorkingColorSpace_192[2].x) * _699)));
  _1121 = ((cb0_013x - _1112) * cb0_013w) + _1112;
  _1122 = ((cb0_013y - _1113) * cb0_013w) + _1113;
  _1123 = ((cb0_013z - _1114) * cb0_013w) + _1114;
  _1135 = exp2(log2(max(0.0f, _1109)) * cb0_040y);
  _1136 = exp2(log2(max(0.0f, _1110)) * cb0_040y);
  _1137 = exp2(log2(max(0.0f, _1111)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    if (WorkingColorSpace_320 == 0) {
      _1160 = mad((WorkingColorSpace_128[0].z), _1137, mad((WorkingColorSpace_128[0].y), _1136, ((WorkingColorSpace_128[0].x) * _1135)));
      _1163 = mad((WorkingColorSpace_128[1].z), _1137, mad((WorkingColorSpace_128[1].y), _1136, ((WorkingColorSpace_128[1].x) * _1135)));
      _1166 = mad((WorkingColorSpace_128[2].z), _1137, mad((WorkingColorSpace_128[2].y), _1136, ((WorkingColorSpace_128[2].x) * _1135)));
      _1177 = mad(_55, _1166, mad(_54, _1163, (_1160 * _53)));
      _1178 = mad(_58, _1166, mad(_57, _1163, (_1160 * _56)));
      _1179 = mad(_61, _1166, mad(_60, _1163, (_1160 * _59)));
    } else {
      _1177 = _1135;
      _1178 = _1136;
      _1179 = _1137;
    }
    if (_1177 < 0.0031306699384003878f) {
      _1190 = (_1177 * 12.920000076293945f);
    } else {
      _1190 = (((pow(_1177, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1178 < 0.0031306699384003878f) {
      _1201 = (_1178 * 12.920000076293945f);
    } else {
      _1201 = (((pow(_1178, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1179 < 0.0031306699384003878f) {
      _2805 = _1190;
      _2806 = _1201;
      _2807 = (_1179 * 12.920000076293945f);
    } else {
      _2805 = _1190;
      _2806 = _1201;
      _2807 = (((pow(_1179, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_040w == 1) {
      _1228 = mad((WorkingColorSpace_128[0].z), _1137, mad((WorkingColorSpace_128[0].y), _1136, ((WorkingColorSpace_128[0].x) * _1135)));
      _1231 = mad((WorkingColorSpace_128[1].z), _1137, mad((WorkingColorSpace_128[1].y), _1136, ((WorkingColorSpace_128[1].x) * _1135)));
      _1234 = mad((WorkingColorSpace_128[2].z), _1137, mad((WorkingColorSpace_128[2].y), _1136, ((WorkingColorSpace_128[2].x) * _1135)));
      _1244 = max(6.103519990574569e-05f, mad(_55, _1234, mad(_54, _1231, (_1228 * _53))));
      _1245 = max(6.103519990574569e-05f, mad(_58, _1234, mad(_57, _1231, (_1228 * _56))));
      _1246 = max(6.103519990574569e-05f, mad(_61, _1234, mad(_60, _1231, (_1228 * _59))));
      _2805 = min((_1244 * 4.5f), ((exp2(log2(max(_1244, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2806 = min((_1245 * 4.5f), ((exp2(log2(max(_1245, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2807 = min((_1246 * 4.5f), ((exp2(log2(max(_1246, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        _1322 = cb0_012z * _1121;
        _1323 = cb0_012z * _1122;
        _1324 = cb0_012z * _1123;
        _1327 = mad((WorkingColorSpace_256[0].z), _1324, mad((WorkingColorSpace_256[0].y), _1323, ((WorkingColorSpace_256[0].x) * _1322)));
        _1330 = mad((WorkingColorSpace_256[1].z), _1324, mad((WorkingColorSpace_256[1].y), _1323, ((WorkingColorSpace_256[1].x) * _1322)));
        _1333 = mad((WorkingColorSpace_256[2].z), _1324, mad((WorkingColorSpace_256[2].y), _1323, ((WorkingColorSpace_256[2].x) * _1322)));
        _1336 = mad(-0.21492856740951538f, _1333, mad(-0.2365107536315918f, _1330, (_1327 * 1.4514392614364624f)));
        _1339 = mad(-0.09967592358589172f, _1333, mad(1.17622971534729f, _1330, (_1327 * -0.07655377686023712f)));
        _1342 = mad(0.9977163076400757f, _1333, mad(-0.006032449658960104f, _1330, (_1327 * 0.008316148072481155f)));
        _1344 = max(_1336, max(_1339, _1342));
        if (!(_1344 < 1.000000013351432e-10f)) {
          if (!(((_1327 < 0.0f) || (_1330 < 0.0f)) || (_1333 < 0.0f))) {
            _1354 = abs(_1344);
            _1355 = (_1344 - _1336) / _1354;
            _1357 = (_1344 - _1339) / _1354;
            _1359 = (_1344 - _1342) / _1354;
            if (!(_1355 < 0.8149999976158142f)) {
              _1362 = _1355 + -0.8149999976158142f;
              _1374 = ((_1362 / exp2(log2(exp2(log2(_1362 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
            } else {
              _1374 = _1355;
            }
            if (!(_1357 < 0.8029999732971191f)) {
              _1377 = _1357 + -0.8029999732971191f;
              _1389 = ((_1377 / exp2(log2(exp2(log2(_1377 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
            } else {
              _1389 = _1357;
            }
            if (!(_1359 < 0.8799999952316284f)) {
              _1392 = _1359 + -0.8799999952316284f;
              _1404 = ((_1392 / exp2(log2(exp2(log2(_1392 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
            } else {
              _1404 = _1359;
            }
            _1412 = (_1344 - (_1354 * _1374));
            _1413 = (_1344 - (_1354 * _1389));
            _1414 = (_1344 - (_1354 * _1404));
          } else {
            _1412 = _1336;
            _1413 = _1339;
            _1414 = _1342;
          }
        } else {
          _1412 = _1336;
          _1413 = _1339;
          _1414 = _1342;
        }
        _1430 = ((mad(0.16386906802654266f, _1414, mad(0.14067870378494263f, _1413, (_1412 * 0.6954522132873535f))) - _1327) * cb0_012w) + _1327;
        _1431 = ((mad(0.0955343171954155f, _1414, mad(0.8596711158752441f, _1413, (_1412 * 0.044794563204050064f))) - _1330) * cb0_012w) + _1330;
        _1432 = ((mad(1.0015007257461548f, _1414, mad(0.004025210160762072f, _1413, (_1412 * -0.005525882821530104f))) - _1333) * cb0_012w) + _1333;
        _1436 = max(max(_1430, _1431), _1432);
        _1441 = (max(_1436, 1.000000013351432e-10f) - max(min(min(_1430, _1431), _1432), 1.000000013351432e-10f)) / max(_1436, 0.009999999776482582f);
        _1454 = ((_1431 + _1430) + _1432) + (sqrt((((_1432 - _1431) * _1432) + ((_1431 - _1430) * _1431)) + ((_1430 - _1432) * _1430)) * 1.75f);
        _1455 = _1454 * 0.3333333432674408f;
        _1456 = _1441 + -0.4000000059604645f;
        _1457 = _1456 * 5.0f;
        _1461 = max((1.0f - abs(_1456 * 2.5f)), 0.0f);
        _1472 = ((float((int)(((int)(uint)((int)(_1457 > 0.0f))) - ((int)(uint)((int)(_1457 < 0.0f))))) * (1.0f - (_1461 * _1461))) + 1.0f) * 0.02500000037252903f;
        if (_1455 > 0.0533333346247673f) {
          if (_1455 < 0.1599999964237213f) {
            _1481 = (((0.23999999463558197f / _1454) + -0.5f) * _1472);
          } else {
            _1481 = 0.0f;
          }
        } else {
          _1481 = _1472;
        }
        _1482 = _1481 + 1.0f;
        _1483 = _1482 * _1430;
        _1484 = _1482 * _1431;
        _1485 = _1482 * _1432;
        if (!((_1483 == _1484) && (_1484 == _1485))) {
          _1492 = ((_1483 * 2.0f) - _1484) - _1485;
          _1495 = ((_1431 - _1432) * 1.7320507764816284f) * _1482;
          _1497 = atan(_1495 / _1492);
          _1500 = (_1492 < 0.0f);
          _1501 = (_1492 == 0.0f);
          _1502 = (_1495 >= 0.0f);
          _1503 = (_1495 < 0.0f);
          _1514 = select((_1502 && _1501), 90.0f, select((_1503 && _1501), -90.0f, (select((_1503 && _1500), (_1497 + -3.1415927410125732f), select((_1502 && _1500), (_1497 + 3.1415927410125732f), _1497)) * 57.2957763671875f)));
        } else {
          _1514 = 0.0f;
        }
        _1519 = min(max(select((_1514 < 0.0f), (_1514 + 360.0f), _1514), 0.0f), 360.0f);
        if (_1519 < -180.0f) {
          _1528 = (_1519 + 360.0f);
        } else {
          if (_1519 > 180.0f) {
            _1528 = (_1519 + -360.0f);
          } else {
            _1528 = _1519;
          }
        }
        if ((_1528 > -67.5f) && (_1528 < 67.5f)) {
          _1534 = (_1528 + 67.5f) * 0.029629629105329514f;
          _1535 = int(_1534);
          _1537 = _1534 - float((int)(_1535));
          _1538 = _1537 * _1537;
          _1539 = _1538 * _1537;
          if (_1535 == 3) {
            _1567 = (((0.1666666716337204f - (_1537 * 0.5f)) + (_1538 * 0.5f)) - (_1539 * 0.1666666716337204f));
          } else {
            if (_1535 == 2) {
              _1567 = ((0.6666666865348816f - _1538) + (_1539 * 0.5f));
            } else {
              if (_1535 == 1) {
                _1567 = (((_1539 * -0.5f) + 0.1666666716337204f) + ((_1538 + _1537) * 0.5f));
              } else {
                _1567 = select((_1535 == 0), (_1539 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _1567 = 0.0f;
        }
        _1576 = min(max(((((_1441 * 0.27000001072883606f) * (0.029999999329447746f - _1483)) * _1567) + _1483), 0.0f), 65535.0f);
        _1577 = min(max(_1484, 0.0f), 65535.0f);
        _1578 = min(max(_1485, 0.0f), 65535.0f);
        _1591 = min(max(mad(-0.21492856740951538f, _1578, mad(-0.2365107536315918f, _1577, (_1576 * 1.4514392614364624f))), 0.0f), 65504.0f);
        _1592 = min(max(mad(-0.09967592358589172f, _1578, mad(1.17622971534729f, _1577, (_1576 * -0.07655377686023712f))), 0.0f), 65504.0f);
        _1593 = min(max(mad(0.9977163076400757f, _1578, mad(-0.006032449658960104f, _1577, (_1576 * 0.008316148072481155f))), 0.0f), 65504.0f);
        _1594 = dot(float3(_1591, _1592, _1593), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
        _1617 = log2(max((lerp(_1594, _1591, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1618 = _1617 * 0.3010300099849701f;
        _1619 = log2(cb0_008x);
        _1620 = _1619 * 0.3010300099849701f;
        if (_1618 > _1620) {
          _1627 = log2(cb0_009x);
          _1628 = _1627 * 0.3010300099849701f;
          if ((_1618 > _1620) && (_1618 < _1628)) {
            _1636 = ((_1617 - _1619) * 0.9030900001525879f) / ((_1627 - _1619) * 0.3010300099849701f);
            _1637 = int(_1636);
            _1639 = _1636 - float((int)(_1637));
            _1641 = _18[min((uint)(_1637), 5u)];
            _1644 = _18[min((uint)((_1637 + 1)), 5u)];
            _1649 = _1641 * 0.5f;
            _1689 = dot(float3((_1639 * _1639), _1639, 1.0f), float3(mad((_18[min((uint)((_1637 + 2)), 5u)]), 0.5f, mad(_1644, -1.0f, _1649)), (_1644 - _1641), mad(_1644, 0.5f, _1649)));
          } else {
            if (_1618 < _1628) {
              _1689 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1658 = log2(cb0_008z);
              if (!(_1618 < (_1658 * 0.3010300099849701f))) {
                _1689 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1666 = ((_1617 - _1627) * 0.9030900001525879f) / ((_1658 - _1627) * 0.3010300099849701f);
                _1667 = int(_1666);
                _1669 = _1666 - float((int)(_1667));
                _1671 = _19[min((uint)(_1667), 5u)];
                _1674 = _19[min((uint)((_1667 + 1)), 5u)];
                _1679 = _1671 * 0.5f;
                _1689 = dot(float3((_1669 * _1669), _1669, 1.0f), float3(mad((_19[min((uint)((_1667 + 2)), 5u)]), 0.5f, mad(_1674, -1.0f, _1679)), (_1674 - _1671), mad(_1674, 0.5f, _1679)));
              }
            }
          }
        } else {
          _1689 = (log2(cb0_008y) * 0.3010300099849701f);
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
        _1705 = log2(max((lerp(_1594, _1592, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1706 = _1705 * 0.3010300099849701f;
        if (_1706 > _1620) {
          _1713 = log2(cb0_009x);
          _1714 = _1713 * 0.3010300099849701f;
          if ((_1706 > _1620) && (_1706 < _1714)) {
            _1722 = ((_1705 - _1619) * 0.9030900001525879f) / ((_1713 - _1619) * 0.3010300099849701f);
            _1723 = int(_1722);
            _1725 = _1722 - float((int)(_1723));
            _1727 = _20[min((uint)(_1723), 5u)];
            _1730 = _20[min((uint)((_1723 + 1)), 5u)];
            _1735 = _1727 * 0.5f;
            _1775 = dot(float3((_1725 * _1725), _1725, 1.0f), float3(mad((_20[min((uint)((_1723 + 2)), 5u)]), 0.5f, mad(_1730, -1.0f, _1735)), (_1730 - _1727), mad(_1730, 0.5f, _1735)));
          } else {
            if (_1706 < _1714) {
              _1775 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1744 = log2(cb0_008z);
              if (!(_1706 < (_1744 * 0.3010300099849701f))) {
                _1775 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1752 = ((_1705 - _1713) * 0.9030900001525879f) / ((_1744 - _1713) * 0.3010300099849701f);
                _1753 = int(_1752);
                _1755 = _1752 - float((int)(_1753));
                _1757 = _21[min((uint)(_1753), 5u)];
                _1760 = _21[min((uint)((_1753 + 1)), 5u)];
                _1765 = _1757 * 0.5f;
                _1775 = dot(float3((_1755 * _1755), _1755, 1.0f), float3(mad((_21[min((uint)((_1753 + 2)), 5u)]), 0.5f, mad(_1760, -1.0f, _1765)), (_1760 - _1757), mad(_1760, 0.5f, _1765)));
              }
            }
          }
        } else {
          _1775 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1779 = log2(max((lerp(_1594, _1593, 0.9599999785423279f)), 1.000000013351432e-10f));
        _1780 = _1779 * 0.3010300099849701f;
        if (_1780 > _1620) {
          _1787 = log2(cb0_009x);
          _1788 = _1787 * 0.3010300099849701f;
          if ((_1780 > _1620) && (_1780 < _1788)) {
            _1796 = ((_1779 - _1619) * 0.9030900001525879f) / ((_1787 - _1619) * 0.3010300099849701f);
            _1797 = int(_1796);
            _1799 = _1796 - float((int)(_1797));
            _1801 = _10[min((uint)(_1797), 5u)];
            _1804 = _10[min((uint)((_1797 + 1)), 5u)];
            _1809 = _1801 * 0.5f;
            _1849 = dot(float3((_1799 * _1799), _1799, 1.0f), float3(mad((_10[min((uint)((_1797 + 2)), 5u)]), 0.5f, mad(_1804, -1.0f, _1809)), (_1804 - _1801), mad(_1804, 0.5f, _1809)));
          } else {
            if (_1780 < _1788) {
              _1849 = (log2(cb0_008w) * 0.3010300099849701f);
            } else {
              _1818 = log2(cb0_008z);
              if (!(_1780 < (_1818 * 0.3010300099849701f))) {
                _1849 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _1826 = ((_1779 - _1787) * 0.9030900001525879f) / ((_1818 - _1787) * 0.3010300099849701f);
                _1827 = int(_1826);
                _1829 = _1826 - float((int)(_1827));
                _1831 = _11[min((uint)(_1827), 5u)];
                _1834 = _11[min((uint)((_1827 + 1)), 5u)];
                _1839 = _1831 * 0.5f;
                _1849 = dot(float3((_1829 * _1829), _1829, 1.0f), float3(mad((_11[min((uint)((_1827 + 2)), 5u)]), 0.5f, mad(_1834, -1.0f, _1839)), (_1834 - _1831), mad(_1834, 0.5f, _1839)));
              }
            }
          }
        } else {
          _1849 = (log2(cb0_008y) * 0.3010300099849701f);
        }
        _1853 = cb0_008w - cb0_008y;
        _1854 = (exp2(_1689 * 3.321928024291992f) - cb0_008y) / _1853;
        _1856 = (exp2(_1775 * 3.321928024291992f) - cb0_008y) / _1853;
        _1858 = (exp2(_1849 * 3.321928024291992f) - cb0_008y) / _1853;
        _1861 = mad(0.15618768334388733f, _1858, mad(0.13400420546531677f, _1856, (_1854 * 0.6624541878700256f)));
        _1864 = mad(0.053689517080783844f, _1858, mad(0.6740817427635193f, _1856, (_1854 * 0.2722287178039551f)));
        _1867 = mad(1.0103391408920288f, _1858, mad(0.00406073359772563f, _1856, (_1854 * -0.005574649665504694f)));
        _1880 = min(max(mad(-0.23642469942569733f, _1867, mad(-0.32480329275131226f, _1864, (_1861 * 1.6410233974456787f))), 0.0f), 1.0f);
        _1881 = min(max(mad(0.016756348311901093f, _1867, mad(1.6153316497802734f, _1864, (_1861 * -0.663662850856781f))), 0.0f), 1.0f);
        _1882 = min(max(mad(0.9883948564529419f, _1867, mad(-0.008284442126750946f, _1864, (_1861 * 0.011721894145011902f))), 0.0f), 1.0f);
        _1885 = mad(0.15618768334388733f, _1882, mad(0.13400420546531677f, _1881, (_1880 * 0.6624541878700256f)));
        _1888 = mad(0.053689517080783844f, _1882, mad(0.6740817427635193f, _1881, (_1880 * 0.2722287178039551f)));
        _1891 = mad(1.0103391408920288f, _1882, mad(0.00406073359772563f, _1881, (_1880 * -0.005574649665504694f)));
        _1913 = min(max((min(max(mad(-0.23642469942569733f, _1891, mad(-0.32480329275131226f, _1888, (_1885 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _1914 = min(max((min(max(mad(0.016756348311901093f, _1891, mad(1.6153316497802734f, _1888, (_1885 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        _1915 = min(max((min(max(mad(0.9883948564529419f, _1891, mad(-0.008284442126750946f, _1888, (_1885 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
        if (!(cb0_040w == 5)) {
          _1928 = mad(_55, _1915, mad(_54, _1914, (_1913 * _53)));
          _1929 = mad(_58, _1915, mad(_57, _1914, (_1913 * _56)));
          _1930 = mad(_61, _1915, mad(_60, _1914, (_1913 * _59)));
        } else {
          _1928 = _1913;
          _1929 = _1914;
          _1930 = _1915;
        }
        _1940 = exp2(log2(_1928 * 9.999999747378752e-05f) * 0.1593017578125f);
        _1941 = exp2(log2(_1929 * 9.999999747378752e-05f) * 0.1593017578125f);
        _1942 = exp2(log2(_1930 * 9.999999747378752e-05f) * 0.1593017578125f);
        _2805 = exp2(log2((1.0f / ((_1940 * 18.6875f) + 1.0f)) * ((_1940 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2806 = exp2(log2((1.0f / ((_1941 * 18.6875f) + 1.0f)) * ((_1941 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _2807 = exp2(log2((1.0f / ((_1942 * 18.6875f) + 1.0f)) * ((_1942 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((cb0_040w & -3) == 4) {
          _2008 = cb0_012z * _1121;
          _2009 = cb0_012z * _1122;
          _2010 = cb0_012z * _1123;
          _2013 = mad((WorkingColorSpace_256[0].z), _2010, mad((WorkingColorSpace_256[0].y), _2009, ((WorkingColorSpace_256[0].x) * _2008)));
          _2016 = mad((WorkingColorSpace_256[1].z), _2010, mad((WorkingColorSpace_256[1].y), _2009, ((WorkingColorSpace_256[1].x) * _2008)));
          _2019 = mad((WorkingColorSpace_256[2].z), _2010, mad((WorkingColorSpace_256[2].y), _2009, ((WorkingColorSpace_256[2].x) * _2008)));
          _2022 = mad(-0.21492856740951538f, _2019, mad(-0.2365107536315918f, _2016, (_2013 * 1.4514392614364624f)));
          _2025 = mad(-0.09967592358589172f, _2019, mad(1.17622971534729f, _2016, (_2013 * -0.07655377686023712f)));
          _2028 = mad(0.9977163076400757f, _2019, mad(-0.006032449658960104f, _2016, (_2013 * 0.008316148072481155f)));
          _2030 = max(_2022, max(_2025, _2028));
          if (!(_2030 < 1.000000013351432e-10f)) {
            if (!(((_2013 < 0.0f) || (_2016 < 0.0f)) || (_2019 < 0.0f))) {
              _2040 = abs(_2030);
              _2041 = (_2030 - _2022) / _2040;
              _2043 = (_2030 - _2025) / _2040;
              _2045 = (_2030 - _2028) / _2040;
              if (!(_2041 < 0.8149999976158142f)) {
                _2048 = _2041 + -0.8149999976158142f;
                _2060 = ((_2048 / exp2(log2(exp2(log2(_2048 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
              } else {
                _2060 = _2041;
              }
              if (!(_2043 < 0.8029999732971191f)) {
                _2063 = _2043 + -0.8029999732971191f;
                _2075 = ((_2063 / exp2(log2(exp2(log2(_2063 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
              } else {
                _2075 = _2043;
              }
              if (!(_2045 < 0.8799999952316284f)) {
                _2078 = _2045 + -0.8799999952316284f;
                _2090 = ((_2078 / exp2(log2(exp2(log2(_2078 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
              } else {
                _2090 = _2045;
              }
              _2098 = (_2030 - (_2040 * _2060));
              _2099 = (_2030 - (_2040 * _2075));
              _2100 = (_2030 - (_2040 * _2090));
            } else {
              _2098 = _2022;
              _2099 = _2025;
              _2100 = _2028;
            }
          } else {
            _2098 = _2022;
            _2099 = _2025;
            _2100 = _2028;
          }
          _2116 = ((mad(0.16386906802654266f, _2100, mad(0.14067870378494263f, _2099, (_2098 * 0.6954522132873535f))) - _2013) * cb0_012w) + _2013;
          _2117 = ((mad(0.0955343171954155f, _2100, mad(0.8596711158752441f, _2099, (_2098 * 0.044794563204050064f))) - _2016) * cb0_012w) + _2016;
          _2118 = ((mad(1.0015007257461548f, _2100, mad(0.004025210160762072f, _2099, (_2098 * -0.005525882821530104f))) - _2019) * cb0_012w) + _2019;
          _2122 = max(max(_2116, _2117), _2118);
          _2127 = (max(_2122, 1.000000013351432e-10f) - max(min(min(_2116, _2117), _2118), 1.000000013351432e-10f)) / max(_2122, 0.009999999776482582f);
          _2140 = ((_2117 + _2116) + _2118) + (sqrt((((_2118 - _2117) * _2118) + ((_2117 - _2116) * _2117)) + ((_2116 - _2118) * _2116)) * 1.75f);
          _2141 = _2140 * 0.3333333432674408f;
          _2142 = _2127 + -0.4000000059604645f;
          _2143 = _2142 * 5.0f;
          _2147 = max((1.0f - abs(_2142 * 2.5f)), 0.0f);
          _2158 = ((float((int)(((int)(uint)((int)(_2143 > 0.0f))) - ((int)(uint)((int)(_2143 < 0.0f))))) * (1.0f - (_2147 * _2147))) + 1.0f) * 0.02500000037252903f;
          if (_2141 > 0.0533333346247673f) {
            if (_2141 < 0.1599999964237213f) {
              _2167 = (((0.23999999463558197f / _2140) + -0.5f) * _2158);
            } else {
              _2167 = 0.0f;
            }
          } else {
            _2167 = _2158;
          }
          _2168 = _2167 + 1.0f;
          _2169 = _2168 * _2116;
          _2170 = _2168 * _2117;
          _2171 = _2168 * _2118;
          if (!((_2169 == _2170) && (_2170 == _2171))) {
            _2178 = ((_2169 * 2.0f) - _2170) - _2171;
            _2181 = ((_2117 - _2118) * 1.7320507764816284f) * _2168;
            _2183 = atan(_2181 / _2178);
            _2186 = (_2178 < 0.0f);
            _2187 = (_2178 == 0.0f);
            _2188 = (_2181 >= 0.0f);
            _2189 = (_2181 < 0.0f);
            _2200 = select((_2188 && _2187), 90.0f, select((_2189 && _2187), -90.0f, (select((_2189 && _2186), (_2183 + -3.1415927410125732f), select((_2188 && _2186), (_2183 + 3.1415927410125732f), _2183)) * 57.2957763671875f)));
          } else {
            _2200 = 0.0f;
          }
          _2205 = min(max(select((_2200 < 0.0f), (_2200 + 360.0f), _2200), 0.0f), 360.0f);
          if (_2205 < -180.0f) {
            _2214 = (_2205 + 360.0f);
          } else {
            if (_2205 > 180.0f) {
              _2214 = (_2205 + -360.0f);
            } else {
              _2214 = _2205;
            }
          }
          if ((_2214 > -67.5f) && (_2214 < 67.5f)) {
            _2220 = (_2214 + 67.5f) * 0.029629629105329514f;
            _2221 = int(_2220);
            _2223 = _2220 - float((int)(_2221));
            _2224 = _2223 * _2223;
            _2225 = _2224 * _2223;
            if (_2221 == 3) {
              _2253 = (((0.1666666716337204f - (_2223 * 0.5f)) + (_2224 * 0.5f)) - (_2225 * 0.1666666716337204f));
            } else {
              if (_2221 == 2) {
                _2253 = ((0.6666666865348816f - _2224) + (_2225 * 0.5f));
              } else {
                if (_2221 == 1) {
                  _2253 = (((_2225 * -0.5f) + 0.1666666716337204f) + ((_2224 + _2223) * 0.5f));
                } else {
                  _2253 = select((_2221 == 0), (_2225 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2253 = 0.0f;
          }
          _2262 = min(max(((((_2127 * 0.27000001072883606f) * (0.029999999329447746f - _2169)) * _2253) + _2169), 0.0f), 65535.0f);
          _2263 = min(max(_2170, 0.0f), 65535.0f);
          _2264 = min(max(_2171, 0.0f), 65535.0f);
          _2277 = min(max(mad(-0.21492856740951538f, _2264, mad(-0.2365107536315918f, _2263, (_2262 * 1.4514392614364624f))), 0.0f), 65504.0f);
          _2278 = min(max(mad(-0.09967592358589172f, _2264, mad(1.17622971534729f, _2263, (_2262 * -0.07655377686023712f))), 0.0f), 65504.0f);
          _2279 = min(max(mad(0.9977163076400757f, _2264, mad(-0.006032449658960104f, _2263, (_2262 * 0.008316148072481155f))), 0.0f), 65504.0f);
          _2280 = dot(float3(_2277, _2278, _2279), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
          _2303 = log2(max((lerp(_2280, _2277, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2304 = _2303 * 0.3010300099849701f;
          _2305 = log2(cb0_008x);
          _2306 = _2305 * 0.3010300099849701f;
          if (_2304 > _2306) {
            _2313 = log2(cb0_009x);
            _2314 = _2313 * 0.3010300099849701f;
            if ((_2304 > _2306) && (_2304 < _2314)) {
              _2322 = ((_2303 - _2305) * 0.9030900001525879f) / ((_2313 - _2305) * 0.3010300099849701f);
              _2323 = int(_2322);
              _2325 = _2322 - float((int)(_2323));
              _2327 = _16[min((uint)(_2323), 5u)];
              _2330 = _16[min((uint)((_2323 + 1)), 5u)];
              _2335 = _2327 * 0.5f;
              _2375 = dot(float3((_2325 * _2325), _2325, 1.0f), float3(mad((_16[min((uint)((_2323 + 2)), 5u)]), 0.5f, mad(_2330, -1.0f, _2335)), (_2330 - _2327), mad(_2330, 0.5f, _2335)));
            } else {
              if (_2304 < _2314) {
                _2375 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2344 = log2(cb0_008z);
                if (!(_2304 < (_2344 * 0.3010300099849701f))) {
                  _2375 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2352 = ((_2303 - _2313) * 0.9030900001525879f) / ((_2344 - _2313) * 0.3010300099849701f);
                  _2353 = int(_2352);
                  _2355 = _2352 - float((int)(_2353));
                  _2357 = _17[min((uint)(_2353), 5u)];
                  _2360 = _17[min((uint)((_2353 + 1)), 5u)];
                  _2365 = _2357 * 0.5f;
                  _2375 = dot(float3((_2355 * _2355), _2355, 1.0f), float3(mad((_17[min((uint)((_2353 + 2)), 5u)]), 0.5f, mad(_2360, -1.0f, _2365)), (_2360 - _2357), mad(_2360, 0.5f, _2365)));
                }
              }
            }
          } else {
            _2375 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2391 = log2(max((lerp(_2280, _2278, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2392 = _2391 * 0.3010300099849701f;
          if (_2392 > _2306) {
            _2399 = log2(cb0_009x);
            _2400 = _2399 * 0.3010300099849701f;
            if ((_2392 > _2306) && (_2392 < _2400)) {
              _2408 = ((_2391 - _2305) * 0.9030900001525879f) / ((_2399 - _2305) * 0.3010300099849701f);
              _2409 = int(_2408);
              _2411 = _2408 - float((int)(_2409));
              _2413 = _12[min((uint)(_2409), 5u)];
              _2416 = _12[min((uint)((_2409 + 1)), 5u)];
              _2421 = _2413 * 0.5f;
              _2461 = dot(float3((_2411 * _2411), _2411, 1.0f), float3(mad((_12[min((uint)((_2409 + 2)), 5u)]), 0.5f, mad(_2416, -1.0f, _2421)), (_2416 - _2413), mad(_2416, 0.5f, _2421)));
            } else {
              if (_2392 < _2400) {
                _2461 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2430 = log2(cb0_008z);
                if (!(_2392 < (_2430 * 0.3010300099849701f))) {
                  _2461 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2438 = ((_2391 - _2399) * 0.9030900001525879f) / ((_2430 - _2399) * 0.3010300099849701f);
                  _2439 = int(_2438);
                  _2441 = _2438 - float((int)(_2439));
                  _2443 = _13[min((uint)(_2439), 5u)];
                  _2446 = _13[min((uint)((_2439 + 1)), 5u)];
                  _2451 = _2443 * 0.5f;
                  _2461 = dot(float3((_2441 * _2441), _2441, 1.0f), float3(mad((_13[min((uint)((_2439 + 2)), 5u)]), 0.5f, mad(_2446, -1.0f, _2451)), (_2446 - _2443), mad(_2446, 0.5f, _2451)));
                }
              }
            }
          } else {
            _2461 = (log2(cb0_008y) * 0.3010300099849701f);
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
          _2477 = log2(max((lerp(_2280, _2279, 0.9599999785423279f)), 1.000000013351432e-10f));
          _2478 = _2477 * 0.3010300099849701f;
          if (_2478 > _2306) {
            _2485 = log2(cb0_009x);
            _2486 = _2485 * 0.3010300099849701f;
            if ((_2478 > _2306) && (_2478 < _2486)) {
              _2494 = ((_2477 - _2305) * 0.9030900001525879f) / ((_2485 - _2305) * 0.3010300099849701f);
              _2495 = int(_2494);
              _2497 = _2494 - float((int)(_2495));
              _2499 = _14[min((uint)(_2495), 5u)];
              _2502 = _14[min((uint)((_2495 + 1)), 5u)];
              _2507 = _2499 * 0.5f;
              _2547 = dot(float3((_2497 * _2497), _2497, 1.0f), float3(mad((_14[min((uint)((_2495 + 2)), 5u)]), 0.5f, mad(_2502, -1.0f, _2507)), (_2502 - _2499), mad(_2502, 0.5f, _2507)));
            } else {
              if (_2478 < _2486) {
                _2547 = (log2(cb0_008w) * 0.3010300099849701f);
              } else {
                _2516 = log2(cb0_008z);
                if (!(_2478 < (_2516 * 0.3010300099849701f))) {
                  _2547 = (log2(cb0_008w) * 0.3010300099849701f);
                } else {
                  _2524 = ((_2477 - _2485) * 0.9030900001525879f) / ((_2516 - _2485) * 0.3010300099849701f);
                  _2525 = int(_2524);
                  _2527 = _2524 - float((int)(_2525));
                  _2529 = _15[min((uint)(_2525), 5u)];
                  _2532 = _15[min((uint)((_2525 + 1)), 5u)];
                  _2537 = _2529 * 0.5f;
                  _2547 = dot(float3((_2527 * _2527), _2527, 1.0f), float3(mad((_15[min((uint)((_2525 + 2)), 5u)]), 0.5f, mad(_2532, -1.0f, _2537)), (_2532 - _2529), mad(_2532, 0.5f, _2537)));
                }
              }
            }
          } else {
            _2547 = (log2(cb0_008y) * 0.3010300099849701f);
          }
          _2551 = cb0_008w - cb0_008y;
          _2552 = (exp2(_2375 * 3.321928024291992f) - cb0_008y) / _2551;
          _2554 = (exp2(_2461 * 3.321928024291992f) - cb0_008y) / _2551;
          _2556 = (exp2(_2547 * 3.321928024291992f) - cb0_008y) / _2551;
          _2559 = mad(0.15618768334388733f, _2556, mad(0.13400420546531677f, _2554, (_2552 * 0.6624541878700256f)));
          _2562 = mad(0.053689517080783844f, _2556, mad(0.6740817427635193f, _2554, (_2552 * 0.2722287178039551f)));
          _2565 = mad(1.0103391408920288f, _2556, mad(0.00406073359772563f, _2554, (_2552 * -0.005574649665504694f)));
          _2578 = min(max(mad(-0.23642469942569733f, _2565, mad(-0.32480329275131226f, _2562, (_2559 * 1.6410233974456787f))), 0.0f), 1.0f);
          _2579 = min(max(mad(0.016756348311901093f, _2565, mad(1.6153316497802734f, _2562, (_2559 * -0.663662850856781f))), 0.0f), 1.0f);
          _2580 = min(max(mad(0.9883948564529419f, _2565, mad(-0.008284442126750946f, _2562, (_2559 * 0.011721894145011902f))), 0.0f), 1.0f);
          _2583 = mad(0.15618768334388733f, _2580, mad(0.13400420546531677f, _2579, (_2578 * 0.6624541878700256f)));
          _2586 = mad(0.053689517080783844f, _2580, mad(0.6740817427635193f, _2579, (_2578 * 0.2722287178039551f)));
          _2589 = mad(1.0103391408920288f, _2580, mad(0.00406073359772563f, _2579, (_2578 * -0.005574649665504694f)));
          _2611 = min(max((min(max(mad(-0.23642469942569733f, _2589, mad(-0.32480329275131226f, _2586, (_2583 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2612 = min(max((min(max(mad(0.016756348311901093f, _2589, mad(1.6153316497802734f, _2586, (_2583 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          _2613 = min(max((min(max(mad(0.9883948564529419f, _2589, mad(-0.008284442126750946f, _2586, (_2583 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
          if (!(cb0_040w == 6)) {
            _2626 = mad(_55, _2613, mad(_54, _2612, (_2611 * _53)));
            _2627 = mad(_58, _2613, mad(_57, _2612, (_2611 * _56)));
            _2628 = mad(_61, _2613, mad(_60, _2612, (_2611 * _59)));
          } else {
            _2626 = _2611;
            _2627 = _2612;
            _2628 = _2613;
          }
          _2638 = exp2(log2(_2626 * 9.999999747378752e-05f) * 0.1593017578125f);
          _2639 = exp2(log2(_2627 * 9.999999747378752e-05f) * 0.1593017578125f);
          _2640 = exp2(log2(_2628 * 9.999999747378752e-05f) * 0.1593017578125f);
          _2805 = exp2(log2((1.0f / ((_2638 * 18.6875f) + 1.0f)) * ((_2638 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _2806 = exp2(log2((1.0f / ((_2639 * 18.6875f) + 1.0f)) * ((_2639 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _2807 = exp2(log2((1.0f / ((_2640 * 18.6875f) + 1.0f)) * ((_2640 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        } else {
          if (cb0_040w == 7) {
            _2685 = mad((WorkingColorSpace_128[0].z), _1123, mad((WorkingColorSpace_128[0].y), _1122, ((WorkingColorSpace_128[0].x) * _1121)));
            _2688 = mad((WorkingColorSpace_128[1].z), _1123, mad((WorkingColorSpace_128[1].y), _1122, ((WorkingColorSpace_128[1].x) * _1121)));
            _2691 = mad((WorkingColorSpace_128[2].z), _1123, mad((WorkingColorSpace_128[2].y), _1122, ((WorkingColorSpace_128[2].x) * _1121)));
            _2710 = exp2(log2(mad(_55, _2691, mad(_54, _2688, (_2685 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2711 = exp2(log2(mad(_58, _2691, mad(_57, _2688, (_2685 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2712 = exp2(log2(mad(_61, _2691, mad(_60, _2688, (_2685 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2805 = exp2(log2((1.0f / ((_2710 * 18.6875f) + 1.0f)) * ((_2710 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2806 = exp2(log2((1.0f / ((_2711 * 18.6875f) + 1.0f)) * ((_2711 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2807 = exp2(log2((1.0f / ((_2712 * 18.6875f) + 1.0f)) * ((_2712 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                _2759 = mad((WorkingColorSpace_128[0].z), _1111, mad((WorkingColorSpace_128[0].y), _1110, ((WorkingColorSpace_128[0].x) * _1109)));
                _2762 = mad((WorkingColorSpace_128[1].z), _1111, mad((WorkingColorSpace_128[1].y), _1110, ((WorkingColorSpace_128[1].x) * _1109)));
                _2765 = mad((WorkingColorSpace_128[2].z), _1111, mad((WorkingColorSpace_128[2].y), _1110, ((WorkingColorSpace_128[2].x) * _1109)));
                _2805 = mad(_55, _2765, mad(_54, _2762, (_2759 * _53)));
                _2806 = mad(_58, _2765, mad(_57, _2762, (_2759 * _56)));
                _2807 = mad(_61, _2765, mad(_60, _2762, (_2759 * _59)));
              } else {
                _2778 = mad((WorkingColorSpace_128[0].z), _1137, mad((WorkingColorSpace_128[0].y), _1136, ((WorkingColorSpace_128[0].x) * _1135)));
                _2781 = mad((WorkingColorSpace_128[1].z), _1137, mad((WorkingColorSpace_128[1].y), _1136, ((WorkingColorSpace_128[1].x) * _1135)));
                _2784 = mad((WorkingColorSpace_128[2].z), _1137, mad((WorkingColorSpace_128[2].y), _1136, ((WorkingColorSpace_128[2].x) * _1135)));
                _2805 = exp2(log2(mad(_55, _2784, mad(_54, _2781, (_2778 * _53)))) * cb0_040z);
                _2806 = exp2(log2(mad(_58, _2784, mad(_57, _2781, (_2778 * _56)))) * cb0_040z);
                _2807 = exp2(log2(mad(_61, _2784, mad(_60, _2781, (_2778 * _59)))) * cb0_040z);
              }
            } else {
              _2805 = _1121;
              _2806 = _1122;
              _2807 = _1123;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2805 * 0.9523810148239136f);
  SV_Target.y = (_2806 * 0.9523810148239136f);
  SV_Target.z = (_2807 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
// From Halo Campaign Evolved

#include "../lutbuilderoutput.hlsli"

RWTexture3D<float4> u0 : register(u0);

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
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
};

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  int WorkingColorSpace_320 : packoffset(c020.x);
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
  float _32;
  float _37;
  float _38;
  float _39;
  float _41;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _127;
  float _128;
  float _129;
  float _652;
  float _685;
  float _699;
  float _763;
  float _1031;
  float _1032;
  float _1033;
  float _1044;
  float _1055;
  float _1228;
  float _1243;
  float _1258;
  float _1266;
  float _1267;
  float _1268;
  float _1335;
  float _1368;
  float _1382;
  float _1421;
  float _1543;
  float _1629;
  float _1703;
  float _1782;
  float _1783;
  float _1784;
  float _1914;
  float _1929;
  float _1944;
  float _1952;
  float _1953;
  float _1954;
  float _2021;
  float _2054;
  float _2068;
  float _2107;
  float _2229;
  float _2315;
  float _2401;
  float _2480;
  float _2481;
  float _2482;
  float _2659;
  float _2660;
  float _2661;
  bool _50;
  float _80;
  float _81;
  float _82;
  float _144;
  float _147;
  float _150;
  float _151;
  float _155;
  float _156;
  float _157;
  float _169;
  float _185;
  float _186;
  float _187;
  float _188;
  float _202;
  float _216;
  float _230;
  float _244;
  float _258;
  float _262;
  float _263;
  float _264;
  float _321;
  float _325;
  float _326;
  float _335;
  float _344;
  float _353;
  float _362;
  float _371;
  float _434;
  float _438;
  float _447;
  float _456;
  float _465;
  float _474;
  float _483;
  float _541;
  float _552;
  float _554;
  float _556;
  float _592;
  float _593;
  float _594;
  float _597;
  float _600;
  float _603;
  float _607;
  float _612;
  float _625;
  float _626;
  float _627;
  float _628;
  float _632;
  float _643;
  float _653;
  float _654;
  float _655;
  float _656;
  float _663;
  float _666;
  float _668;
  bool _671;
  bool _672;
  bool _673;
  bool _674;
  float _690;
  float _703;
  float _707;
  float _713;
  float _723;
  float _724;
  float _725;
  float _726;
  float _741;
  float _743;
  float _745;
  float _754;
  float _766;
  float _768;
  float _772;
  float _773;
  float _774;
  float _778;
  float _779;
  float _780;
  float _781;
  float _783;
  float _784;
  float _785;
  float _786;
  float _805;
  float _807;
  float _832;
  float _833;
  float _834;
  float _841;
  float _845;
  float _846;
  float _847;
  bool _848;
  float _852;
  float _853;
  float _854;
  float _873;
  float _874;
  float _875;
  float _876;
  float _896;
  float _897;
  float _898;
  float _914;
  float _915;
  float _916;
  float _926;
  float _927;
  float _928;
  float _954;
  float _955;
  float _956;
  float _963;
  float _964;
  float _965;
  float _966;
  float _967;
  float _968;
  float _975;
  float _976;
  float _977;
  float _989;
  float _990;
  float _991;
  float _1014;
  float _1017;
  float _1020;
  float _1082;
  float _1085;
  float _1088;
  float _1098;
  float _1099;
  float _1100;
  float _1176;
  float _1177;
  float _1178;
  float _1181;
  float _1184;
  float _1187;
  float _1190;
  float _1193;
  float _1196;
  float _1198;
  float _1208;
  float _1209;
  float _1211;
  float _1213;
  float _1216;
  float _1231;
  float _1246;
  float _1284;
  float _1285;
  float _1286;
  float _1290;
  float _1295;
  float _1308;
  float _1309;
  float _1310;
  float _1311;
  float _1315;
  float _1326;
  float _1336;
  float _1337;
  float _1338;
  float _1339;
  float _1346;
  float _1349;
  float _1351;
  bool _1354;
  bool _1355;
  bool _1356;
  bool _1357;
  float _1373;
  float _1388;
  int _1389;
  float _1391;
  float _1392;
  float _1393;
  float _1430;
  float _1431;
  float _1432;
  float _1445;
  float _1446;
  float _1447;
  float _1448;
  float _1471;
  float _1472;
  float _1473;
  float _1474;
  float _1481;
  float _1482;
  float _1490;
  int _1491;
  float _1493;
  float _1495;
  float _1498;
  float _1503;
  float _1512;
  float _1520;
  int _1521;
  float _1523;
  float _1525;
  float _1528;
  float _1533;
  float _1559;
  float _1560;
  float _1567;
  float _1568;
  float _1576;
  int _1577;
  float _1579;
  float _1581;
  float _1584;
  float _1589;
  float _1598;
  float _1606;
  int _1607;
  float _1609;
  float _1611;
  float _1614;
  float _1619;
  float _1633;
  float _1634;
  float _1641;
  float _1642;
  float _1650;
  int _1651;
  float _1653;
  float _1655;
  float _1658;
  float _1663;
  float _1672;
  float _1680;
  int _1681;
  float _1683;
  float _1685;
  float _1688;
  float _1693;
  float _1707;
  float _1708;
  float _1710;
  float _1712;
  float _1715;
  float _1718;
  float _1721;
  float _1734;
  float _1735;
  float _1736;
  float _1739;
  float _1742;
  float _1745;
  float _1767;
  float _1768;
  float _1769;
  float _1794;
  float _1795;
  float _1796;
  float _1862;
  float _1863;
  float _1864;
  float _1867;
  float _1870;
  float _1873;
  float _1876;
  float _1879;
  float _1882;
  float _1884;
  float _1894;
  float _1895;
  float _1897;
  float _1899;
  float _1902;
  float _1917;
  float _1932;
  float _1970;
  float _1971;
  float _1972;
  float _1976;
  float _1981;
  float _1994;
  float _1995;
  float _1996;
  float _1997;
  float _2001;
  float _2012;
  float _2022;
  float _2023;
  float _2024;
  float _2025;
  float _2032;
  float _2035;
  float _2037;
  bool _2040;
  bool _2041;
  bool _2042;
  bool _2043;
  float _2059;
  float _2074;
  int _2075;
  float _2077;
  float _2078;
  float _2079;
  float _2116;
  float _2117;
  float _2118;
  float _2131;
  float _2132;
  float _2133;
  float _2134;
  float _2157;
  float _2158;
  float _2159;
  float _2160;
  float _2167;
  float _2168;
  float _2176;
  int _2177;
  float _2179;
  float _2181;
  float _2184;
  float _2189;
  float _2198;
  float _2206;
  int _2207;
  float _2209;
  float _2211;
  float _2214;
  float _2219;
  float _2245;
  float _2246;
  float _2253;
  float _2254;
  float _2262;
  int _2263;
  float _2265;
  float _2267;
  float _2270;
  float _2275;
  float _2284;
  float _2292;
  int _2293;
  float _2295;
  float _2297;
  float _2300;
  float _2305;
  float _2331;
  float _2332;
  float _2339;
  float _2340;
  float _2348;
  int _2349;
  float _2351;
  float _2353;
  float _2356;
  float _2361;
  float _2370;
  float _2378;
  int _2379;
  float _2381;
  float _2383;
  float _2386;
  float _2391;
  float _2405;
  float _2406;
  float _2408;
  float _2410;
  float _2413;
  float _2416;
  float _2419;
  float _2432;
  float _2433;
  float _2434;
  float _2437;
  float _2440;
  float _2443;
  float _2465;
  float _2466;
  float _2467;
  float _2492;
  float _2493;
  float _2494;
  float _2539;
  float _2542;
  float _2545;
  float _2564;
  float _2565;
  float _2566;
  float _2613;
  float _2616;
  float _2619;
  float _2632;
  float _2635;
  float _2638;
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
  float _20[6];
  _32 = 0.5f / cb0_035x;
  _37 = cb0_035x + -1.0f;
  _38 = (cb0_035x * ((cb0_042x * (((float)((uint)SV_DispatchThreadID.x)) + 0.5f)) - _32)) / _37;
  _39 = (cb0_035x * ((cb0_042y * (((float)((uint)SV_DispatchThreadID.y)) + 0.5f)) - _32)) / _37;
  _41 = ((float)((uint)SV_DispatchThreadID.z)) / _37;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        _50 = (cb0_041x == 4);
        _61 = select(_50, 1.0f, 1.705051064491272f);
        _62 = select(_50, 0.0f, -0.6217921376228333f);
        _63 = select(_50, 0.0f, -0.0832589864730835f);
        _64 = select(_50, 0.0f, -0.13025647401809692f);
        _65 = select(_50, 1.0f, 1.140804648399353f);
        _66 = select(_50, 0.0f, -0.010548308491706848f);
        _67 = select(_50, 0.0f, -0.024003351107239723f);
        _68 = select(_50, 0.0f, -0.1289689838886261f);
        _69 = select(_50, 1.0f, 1.1529725790023804f);
      } else {
        _61 = 0.6954522132873535f;
        _62 = 0.14067870378494263f;
        _63 = 0.16386906802654266f;
        _64 = 0.044794563204050064f;
        _65 = 0.8596711158752441f;
        _66 = 0.0955343171954155f;
        _67 = -0.005525882821530104f;
        _68 = 0.004025210160762072f;
        _69 = 1.0015007257461548f;
      }
    } else {
      _61 = 1.0258246660232544f;
      _62 = -0.020053181797266006f;
      _63 = -0.005771636962890625f;
      _64 = -0.002234415616840124f;
      _65 = 1.0045864582061768f;
      _66 = -0.002352118492126465f;
      _67 = -0.005013350863009691f;
      _68 = -0.025290070101618767f;
      _69 = 1.0303035974502563f;
    }
  } else {
    _61 = 1.3792141675949097f;
    _62 = -0.30886411666870117f;
    _63 = -0.0703500509262085f;
    _64 = -0.06933490186929703f;
    _65 = 1.08229660987854f;
    _66 = -0.012961871922016144f;
    _67 = -0.0021590073592960835f;
    _68 = -0.0454593189060688f;
    _69 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    _80 = (pow(_38, 0.012683313339948654f));
    _81 = (pow(_39, 0.012683313339948654f));
    _82 = (pow(_41, 0.012683313339948654f));
    _127 = (exp2(log2(max(0.0f, (_80 + -0.8359375f)) / (18.8515625f - (_80 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _128 = (exp2(log2(max(0.0f, (_81 + -0.8359375f)) / (18.8515625f - (_81 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _129 = (exp2(log2(max(0.0f, (_82 + -0.8359375f)) / (18.8515625f - (_82 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _127 = ((exp2((_38 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _128 = ((exp2((_39 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _129 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  _144 = mad((WorkingColorSpace_128[0].z), _129, mad((WorkingColorSpace_128[0].y), _128, ((WorkingColorSpace_128[0].x) * _127)));
  _147 = mad((WorkingColorSpace_128[1].z), _129, mad((WorkingColorSpace_128[1].y), _128, ((WorkingColorSpace_128[1].x) * _127)));
  _150 = mad((WorkingColorSpace_128[2].z), _129, mad((WorkingColorSpace_128[2].y), _128, ((WorkingColorSpace_128[2].x) * _127)));
  _151 = dot(float3(_144, _147, _150), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _155 = (_144 / _151) + -1.0f;
  _156 = (_147 / _151) + -1.0f;
  _157 = (_150 / _151) + -1.0f;
  // ExpandGamut set to 0
  _169 = (1.0f - exp2(((_151 * _151) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_155, _156, _157), float3(_155, _156, _157)) * -4.0f));
  _185 = ((mad(-0.06368321925401688f, _150, mad(-0.3292922377586365f, _147, (_144 * 1.3704125881195068f))) - _144) * _169) + _144;
  _186 = ((mad(-0.010861365124583244f, _150, mad(1.0970927476882935f, _147, (_144 * -0.08343357592821121f))) - _147) * _169) + _147;
  _187 = ((mad(1.2036951780319214f, _150, mad(-0.09862580895423889f, _147, (_144 * -0.02579331398010254f))) - _150) * _169) + _150;
  _188 = dot(float3(_185, _186, _187), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _202 = cb0_019w + cb0_024w;
  _216 = cb0_018w * cb0_023w;
  _230 = cb0_017w * cb0_022w;
  _244 = cb0_016w * cb0_021w;
  _258 = cb0_015w * cb0_020w;
  _262 = _185 - _188;
  _263 = _186 - _188;
  _264 = _187 - _188;
  _321 = saturate(_188 / cb0_035w);
  _325 = (_321 * _321) * (3.0f - (_321 * 2.0f));
  _326 = 1.0f - _325;
  _335 = cb0_019w + cb0_034w;
  _344 = cb0_018w * cb0_033w;
  _353 = cb0_017w * cb0_032w;
  _362 = cb0_016w * cb0_031w;
  _371 = cb0_015w * cb0_030w;
  _434 = saturate((_188 - cb0_036x) / (cb0_036y - cb0_036x));
  _438 = (_434 * _434) * (3.0f - (_434 * 2.0f));
  _447 = cb0_019w + cb0_029w;
  _456 = cb0_018w * cb0_028w;
  _465 = cb0_017w * cb0_027w;
  _474 = cb0_016w * cb0_026w;
  _483 = cb0_015w * cb0_025w;
  _541 = _325 - _438;
  _552 = ((_438 * (((cb0_019x + cb0_034x) + _335) + (((cb0_018x * cb0_033x) * _344) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _362) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _371) * _262) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _353)))))) + (_326 * (((cb0_019x + cb0_024x) + _202) + (((cb0_018x * cb0_023x) * _216) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _244) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _258) * _262) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _230))))))) + ((((cb0_019x + cb0_029x) + _447) + (((cb0_018x * cb0_028x) * _456) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _474) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _483) * _262) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _465))))) * _541);
  _554 = ((_438 * (((cb0_019y + cb0_034y) + _335) + (((cb0_018y * cb0_033y) * _344) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _362) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _371) * _263) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _353)))))) + (_326 * (((cb0_019y + cb0_024y) + _202) + (((cb0_018y * cb0_023y) * _216) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _244) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _258) * _263) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _230))))))) + ((((cb0_019y + cb0_029y) + _447) + (((cb0_018y * cb0_028y) * _456) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _474) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _483) * _263) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _465))))) * _541);
  _556 = ((_438 * (((cb0_019z + cb0_034z) + _335) + (((cb0_018z * cb0_033z) * _344) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _362) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _371) * _264) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _353)))))) + (_326 * (((cb0_019z + cb0_024z) + _202) + (((cb0_018z * cb0_023z) * _216) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _244) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _258) * _264) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _230))))))) + ((((cb0_019z + cb0_029z) + _447) + (((cb0_018z * cb0_028z) * _456) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _474) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _483) * _264) + _188)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _465))))) * _541);
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

  float4 output = ProcessLutbuilder(float3(_552, _554, _556), cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _592 = ((mad(0.061360642313957214f, _556, mad(-4.540197551250458e-09f, _554, (_552 * 0.9386394023895264f))) - _552) * cb0_036z) + _552;
  _593 = ((mad(0.169205904006958f, _556, mad(0.8307942152023315f, _554, (_552 * 6.775371730327606e-08f))) - _554) * cb0_036z) + _554;
  _594 = (mad(-2.3283064365386963e-10f, _554, (_552 * -9.313225746154785e-10f)) * cb0_036z) + _556;
  _597 = mad(0.16386905312538147f, _594, mad(0.14067868888378143f, _593, (_592 * 0.6954522132873535f)));
  _600 = mad(0.0955343246459961f, _594, mad(0.8596711158752441f, _593, (_592 * 0.044794581830501556f)));
  _603 = mad(1.0015007257461548f, _594, mad(0.004025210160762072f, _593, (_592 * -0.005525882821530104f)));
  _607 = max(max(_597, _600), _603);
  _612 = (max(_607, 1.000000013351432e-10f) - max(min(min(_597, _600), _603), 1.000000013351432e-10f)) / max(_607, 0.009999999776482582f);
  _625 = ((_600 + _597) + _603) + (sqrt((((_603 - _600) * _603) + ((_600 - _597) * _600)) + ((_597 - _603) * _597)) * 1.75f);
  _626 = _625 * 0.3333333432674408f;
  _627 = _612 + -0.4000000059604645f;
  _628 = _627 * 5.0f;
  _632 = max((1.0f - abs(_627 * 2.5f)), 0.0f);
  _643 = ((float((int)(((int)(uint)((int)(_628 > 0.0f))) - ((int)(uint)((int)(_628 < 0.0f))))) * (1.0f - (_632 * _632))) + 1.0f) * 0.02500000037252903f;
  if (!(_626 <= 0.0533333346247673f)) {
    if (!(_626 >= 0.1599999964237213f)) {
      _652 = (((0.23999999463558197f / _625) + -0.5f) * _643);
    } else {
      _652 = 0.0f;
    }
  } else {
    _652 = _643;
  }
  _653 = _652 + 1.0f;
  _654 = _653 * _597;
  _655 = _653 * _600;
  _656 = _653 * _603;
  if (!((_654 == _655) && (_655 == _656))) {
    _663 = ((_654 * 2.0f) - _655) - _656;
    _666 = ((_600 - _603) * 1.7320507764816284f) * _653;
    _668 = atan(_666 / _663);
    _671 = (_663 < 0.0f);
    _672 = (_663 == 0.0f);
    _673 = (_666 >= 0.0f);
    _674 = (_666 < 0.0f);
    _685 = select((_673 && _672), 90.0f, select((_674 && _672), -90.0f, (select((_674 && _671), (_668 + -3.1415927410125732f), select((_673 && _671), (_668 + 3.1415927410125732f), _668)) * 57.2957763671875f)));
  } else {
    _685 = 0.0f;
  }
  _690 = min(max(select((_685 < 0.0f), (_685 + 360.0f), _685), 0.0f), 360.0f);
  if (_690 < -180.0f) {
    _699 = (_690 + 360.0f);
  } else {
    if (_690 > 180.0f) {
      _699 = (_690 + -360.0f);
    } else {
      _699 = _690;
    }
  }
  _703 = saturate(1.0f - abs(_699 * 0.014814814552664757f));
  _707 = (_703 * _703) * (3.0f - (_703 * 2.0f));
  _713 = ((_707 * _707) * ((_612 * 0.18000000715255737f) * (0.029999999329447746f - _654))) + _654;
  _723 = max(0.0f, mad(-0.21492856740951538f, _656, mad(-0.2365107536315918f, _655, (_713 * 1.4514392614364624f))));
  _724 = max(0.0f, mad(-0.09967592358589172f, _656, mad(1.17622971534729f, _655, (_713 * -0.07655377686023712f))));
  _725 = max(0.0f, mad(0.9977163076400757f, _656, mad(-0.006032449658960104f, _655, (_713 * 0.008316148072481155f))));
  _726 = dot(float3(_723, _724, _725), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _741 = (cb0_038x + 1.0f) - cb0_037z;
  _743 = cb0_038y + 1.0f;
  _745 = _743 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _763 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    _754 = (cb0_038x + 0.18000000715255737f) / _741;
    _763 = (-0.7447274923324585f - ((log2(_754 / (2.0f - _754)) * 0.3465735912322998f) * (_741 / cb0_037y)));
  }
  _766 = ((1.0f - cb0_037z) / cb0_037y) - _763;
  _768 = (cb0_037w / cb0_037y) - _766;
  _772 = log2(lerp(_726, _723, 0.9599999785423279f)) * 0.3010300099849701f;
  _773 = log2(lerp(_726, _724, 0.9599999785423279f)) * 0.3010300099849701f;
  _774 = log2(lerp(_726, _725, 0.9599999785423279f)) * 0.3010300099849701f;
  _778 = cb0_037y * (_772 + _766);
  _779 = cb0_037y * (_773 + _766);
  _780 = cb0_037y * (_774 + _766);
  _781 = _741 * 2.0f;
  _783 = (cb0_037y * -2.0f) / _741;
  _784 = _772 - _763;
  _785 = _773 - _763;
  _786 = _774 - _763;
  _805 = _745 * 2.0f;
  _807 = (cb0_037y * 2.0f) / _745;
  _832 = select((_772 < _763), ((_781 / (exp2((_784 * 1.4426950216293335f) * _783) + 1.0f)) - cb0_038x), _778);
  _833 = select((_773 < _763), ((_781 / (exp2((_785 * 1.4426950216293335f) * _783) + 1.0f)) - cb0_038x), _779);
  _834 = select((_774 < _763), ((_781 / (exp2((_786 * 1.4426950216293335f) * _783) + 1.0f)) - cb0_038x), _780);
  _841 = _768 - _763;
  _845 = saturate(_784 / _841);
  _846 = saturate(_785 / _841);
  _847 = saturate(_786 / _841);
  _848 = (_768 < _763);
  _852 = select(_848, (1.0f - _845), _845);
  _853 = select(_848, (1.0f - _846), _846);
  _854 = select(_848, (1.0f - _847), _847);
  _873 = (((_852 * _852) * (select((_772 > _768), (_743 - (_805 / (exp2(((_772 - _768) * 1.4426950216293335f) * _807) + 1.0f))), _778) - _832)) * (3.0f - (_852 * 2.0f))) + _832;
  _874 = (((_853 * _853) * (select((_773 > _768), (_743 - (_805 / (exp2(((_773 - _768) * 1.4426950216293335f) * _807) + 1.0f))), _779) - _833)) * (3.0f - (_853 * 2.0f))) + _833;
  _875 = (((_854 * _854) * (select((_774 > _768), (_743 - (_805 / (exp2(((_774 - _768) * 1.4426950216293335f) * _807) + 1.0f))), _780) - _834)) * (3.0f - (_854 * 2.0f))) + _834;
  _876 = dot(float3(_873, _874, _875), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _896 = (cb0_037x * (max(0.0f, (lerp(_876, _873, 0.9300000071525574f))) - _592)) + _592;
  _897 = (cb0_037x * (max(0.0f, (lerp(_876, _874, 0.9300000071525574f))) - _593)) + _593;
  _898 = (cb0_037x * (max(0.0f, (lerp(_876, _875, 0.9300000071525574f))) - _594)) + _594;
  _914 = ((mad(-0.06537103652954102f, _898, mad(1.451815478503704e-06f, _897, (_896 * 1.065374732017517f))) - _896) * cb0_036z) + _896;
  _915 = ((mad(-0.20366770029067993f, _898, mad(1.2036634683609009f, _897, (_896 * -2.57161445915699e-07f))) - _897) * cb0_036z) + _897;
  _916 = ((mad(0.9999996423721313f, _898, mad(2.0954757928848267e-08f, _897, (_896 * 1.862645149230957e-08f))) - _898) * cb0_036z) + _898;
  _926 = max(0.0f, mad((WorkingColorSpace_192[0].z), _916, mad((WorkingColorSpace_192[0].y), _915, ((WorkingColorSpace_192[0].x) * _914))));
  _927 = max(0.0f, mad((WorkingColorSpace_192[1].z), _916, mad((WorkingColorSpace_192[1].y), _915, ((WorkingColorSpace_192[1].x) * _914))));
  _928 = max(0.0f, mad((WorkingColorSpace_192[2].z), _916, mad((WorkingColorSpace_192[2].y), _915, ((WorkingColorSpace_192[2].x) * _914))));
  _954 = cb0_014x * (((cb0_039y + (cb0_039x * _926)) * _926) + cb0_039z);
  _955 = cb0_014y * (((cb0_039y + (cb0_039x * _927)) * _927) + cb0_039z);
  _956 = cb0_014z * (((cb0_039y + (cb0_039x * _928)) * _928) + cb0_039z);
  _963 = ((cb0_013x - _954) * cb0_013w) + _954;
  _964 = ((cb0_013y - _955) * cb0_013w) + _955;
  _965 = ((cb0_013z - _956) * cb0_013w) + _956;
  _966 = cb0_014x * mad((WorkingColorSpace_192[0].z), _556, mad((WorkingColorSpace_192[0].y), _554, (_552 * (WorkingColorSpace_192[0].x))));
  _967 = cb0_014y * mad((WorkingColorSpace_192[1].z), _556, mad((WorkingColorSpace_192[1].y), _554, ((WorkingColorSpace_192[1].x) * _552)));
  _968 = cb0_014z * mad((WorkingColorSpace_192[2].z), _556, mad((WorkingColorSpace_192[2].y), _554, ((WorkingColorSpace_192[2].x) * _552)));
  _975 = ((cb0_013x - _966) * cb0_013w) + _966;
  _976 = ((cb0_013y - _967) * cb0_013w) + _967;
  _977 = ((cb0_013z - _968) * cb0_013w) + _968;
  _989 = exp2(log2(max(0.0f, _963)) * cb0_040y);
  _990 = exp2(log2(max(0.0f, _964)) * cb0_040y);
  _991 = exp2(log2(max(0.0f, _965)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      _1031 = _989;
      _1032 = _990;
      _1033 = _991;
      if (WorkingColorSpace_320 == 0) {
        _1014 = mad((WorkingColorSpace_128[0].z), _991, mad((WorkingColorSpace_128[0].y), _990, ((WorkingColorSpace_128[0].x) * _989)));
        _1017 = mad((WorkingColorSpace_128[1].z), _991, mad((WorkingColorSpace_128[1].y), _990, ((WorkingColorSpace_128[1].x) * _989)));
        _1020 = mad((WorkingColorSpace_128[2].z), _991, mad((WorkingColorSpace_128[2].y), _990, ((WorkingColorSpace_128[2].x) * _989)));
        _1031 = mad(_63, _1020, mad(_62, _1017, (_1014 * _61)));
        _1032 = mad(_66, _1020, mad(_65, _1017, (_1014 * _64)));
        _1033 = mad(_69, _1020, mad(_68, _1017, (_1014 * _67)));
      }
      do {
        if (_1031 < 0.0031306699384003878f) {
          _1044 = (_1031 * 12.920000076293945f);
        } else {
          _1044 = (((pow(_1031, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1032 < 0.0031306699384003878f) {
            _1055 = (_1032 * 12.920000076293945f);
          } else {
            _1055 = (((pow(_1032, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1033 < 0.0031306699384003878f) {
            _2659 = _1044;
            _2660 = _1055;
            _2661 = (_1033 * 12.920000076293945f);
          } else {
            _2659 = _1044;
            _2660 = _1055;
            _2661 = (((pow(_1033, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      _1082 = mad((WorkingColorSpace_128[0].z), _991, mad((WorkingColorSpace_128[0].y), _990, ((WorkingColorSpace_128[0].x) * _989)));
      _1085 = mad((WorkingColorSpace_128[1].z), _991, mad((WorkingColorSpace_128[1].y), _990, ((WorkingColorSpace_128[1].x) * _989)));
      _1088 = mad((WorkingColorSpace_128[2].z), _991, mad((WorkingColorSpace_128[2].y), _990, ((WorkingColorSpace_128[2].x) * _989)));
      _1098 = max(6.103519990574569e-05f, mad(_63, _1088, mad(_62, _1085, (_1082 * _61))));
      _1099 = max(6.103519990574569e-05f, mad(_66, _1088, mad(_65, _1085, (_1082 * _64))));
      _1100 = max(6.103519990574569e-05f, mad(_69, _1088, mad(_68, _1085, (_1082 * _67))));
      _2659 = min((_1098 * 4.5f), ((exp2(log2(max(_1098, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2660 = min((_1099 * 4.5f), ((exp2(log2(max(_1099, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2661 = min((_1100 * 4.5f), ((exp2(log2(max(_1100, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((cb0_040w == 3) || (cb0_040w == 5)) {
        _9[0] = cb0_010x;
        _9[1] = cb0_010y;
        _9[2] = cb0_010z;
        _9[3] = cb0_010w;
        _9[4] = cb0_012x;
        _9[5] = cb0_012x;
        _10[0] = cb0_011x;
        _10[1] = cb0_011y;
        _10[2] = cb0_011z;
        _10[3] = cb0_011w;
        _10[4] = cb0_012y;
        _10[5] = cb0_012y;
        _1176 = cb0_012z * _975;
        _1177 = cb0_012z * _976;
        _1178 = cb0_012z * _977;
        _1181 = mad((WorkingColorSpace_256[0].z), _1178, mad((WorkingColorSpace_256[0].y), _1177, ((WorkingColorSpace_256[0].x) * _1176)));
        _1184 = mad((WorkingColorSpace_256[1].z), _1178, mad((WorkingColorSpace_256[1].y), _1177, ((WorkingColorSpace_256[1].x) * _1176)));
        _1187 = mad((WorkingColorSpace_256[2].z), _1178, mad((WorkingColorSpace_256[2].y), _1177, ((WorkingColorSpace_256[2].x) * _1176)));
        _1190 = mad(-0.21492856740951538f, _1187, mad(-0.2365107536315918f, _1184, (_1181 * 1.4514392614364624f)));
        _1193 = mad(-0.09967592358589172f, _1187, mad(1.17622971534729f, _1184, (_1181 * -0.07655377686023712f)));
        _1196 = mad(0.9977163076400757f, _1187, mad(-0.006032449658960104f, _1184, (_1181 * 0.008316148072481155f)));
        _1198 = max(_1190, max(_1193, _1196));
        do {
          _1266 = _1190;
          _1267 = _1193;
          _1268 = _1196;
          if (!(_1198 < 1.000000013351432e-10f)) {
            if (!(((_1181 < 0.0f) || (_1184 < 0.0f)) || (_1187 < 0.0f))) {
              _1208 = abs(_1198);
              _1209 = (_1198 - _1190) / _1208;
              _1211 = (_1198 - _1193) / _1208;
              _1213 = (_1198 - _1196) / _1208;
              do {
                _1228 = _1209;
                if (!(_1209 < 0.8149999976158142f)) {
                  _1216 = _1209 + -0.8149999976158142f;
                  _1228 = ((_1216 / exp2(log2(exp2(log2(_1216 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                }
                do {
                  _1243 = _1211;
                  if (!(_1211 < 0.8029999732971191f)) {
                    _1231 = _1211 + -0.8029999732971191f;
                    _1243 = ((_1231 / exp2(log2(exp2(log2(_1231 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  }
                  do {
                    _1258 = _1213;
                    if (!(_1213 < 0.8799999952316284f)) {
                      _1246 = _1213 + -0.8799999952316284f;
                      _1258 = ((_1246 / exp2(log2(exp2(log2(_1246 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    }
                    _1266 = (_1198 - (_1208 * _1228));
                    _1267 = (_1198 - (_1208 * _1243));
                    _1268 = (_1198 - (_1208 * _1258));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1266 = _1190;
              _1267 = _1193;
              _1268 = _1196;
            }
          }
          _1284 = ((mad(0.16386906802654266f, _1268, mad(0.14067870378494263f, _1267, (_1266 * 0.6954522132873535f))) - _1181) * cb0_012w) + _1181;
          _1285 = ((mad(0.0955343171954155f, _1268, mad(0.8596711158752441f, _1267, (_1266 * 0.044794563204050064f))) - _1184) * cb0_012w) + _1184;
          _1286 = ((mad(1.0015007257461548f, _1268, mad(0.004025210160762072f, _1267, (_1266 * -0.005525882821530104f))) - _1187) * cb0_012w) + _1187;
          _1290 = max(max(_1284, _1285), _1286);
          _1295 = (max(_1290, 1.000000013351432e-10f) - max(min(min(_1284, _1285), _1286), 1.000000013351432e-10f)) / max(_1290, 0.009999999776482582f);
          _1308 = ((_1285 + _1284) + _1286) + (sqrt((((_1286 - _1285) * _1286) + ((_1285 - _1284) * _1285)) + ((_1284 - _1286) * _1284)) * 1.75f);
          _1309 = _1308 * 0.3333333432674408f;
          _1310 = _1295 + -0.4000000059604645f;
          _1311 = _1310 * 5.0f;
          _1315 = max((1.0f - abs(_1310 * 2.5f)), 0.0f);
          _1326 = ((float((int)(((int)(uint)((int)(_1311 > 0.0f))) - ((int)(uint)((int)(_1311 < 0.0f))))) * (1.0f - (_1315 * _1315))) + 1.0f) * 0.02500000037252903f;
          do {
            _1335 = _1326;
            if (!(_1309 <= 0.0533333346247673f)) {
              if (!(_1309 >= 0.1599999964237213f)) {
                _1335 = (((0.23999999463558197f / _1308) + -0.5f) * _1326);
              } else {
                _1335 = 0.0f;
              }
            }
            _1336 = _1335 + 1.0f;
            _1337 = _1336 * _1284;
            _1338 = _1336 * _1285;
            _1339 = _1336 * _1286;
            do {
              _1368 = 0.0f;
              if (!((_1337 == _1338) && (_1338 == _1339))) {
                _1346 = ((_1337 * 2.0f) - _1338) - _1339;
                _1349 = ((_1285 - _1286) * 1.7320507764816284f) * _1336;
                _1351 = atan(_1349 / _1346);
                _1354 = (_1346 < 0.0f);
                _1355 = (_1346 == 0.0f);
                _1356 = (_1349 >= 0.0f);
                _1357 = (_1349 < 0.0f);
                _1368 = select((_1356 && _1355), 90.0f, select((_1357 && _1355), -90.0f, (select((_1357 && _1354), (_1351 + -3.1415927410125732f), select((_1356 && _1354), (_1351 + 3.1415927410125732f), _1351)) * 57.2957763671875f)));
              }
              _1373 = min(max(select((_1368 < 0.0f), (_1368 + 360.0f), _1368), 0.0f), 360.0f);
              do {
                if (_1373 < -180.0f) {
                  _1382 = (_1373 + 360.0f);
                } else {
                  if (_1373 > 180.0f) {
                    _1382 = (_1373 + -360.0f);
                  } else {
                    _1382 = _1373;
                  }
                }
                do {
                  _1421 = 0.0f;
                  if ((_1382 > -67.5f) && (_1382 < 67.5f)) {
                    _1388 = (_1382 + 67.5f) * 0.029629629105329514f;
                    _1389 = int(_1388);
                    _1391 = _1388 - float((int)(_1389));
                    _1392 = _1391 * _1391;
                    _1393 = _1392 * _1391;
                    if (_1389 == 3) {
                      _1421 = (((0.1666666716337204f - (_1391 * 0.5f)) + (_1392 * 0.5f)) - (_1393 * 0.1666666716337204f));
                    } else {
                      if (_1389 == 2) {
                        _1421 = ((0.6666666865348816f - _1392) + (_1393 * 0.5f));
                      } else {
                        if (_1389 == 1) {
                          _1421 = (((_1393 * -0.5f) + 0.1666666716337204f) + ((_1392 + _1391) * 0.5f));
                        } else {
                          _1421 = select((_1389 == 0), (_1393 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  }
                  _1430 = min(max(((((_1295 * 0.27000001072883606f) * (0.029999999329447746f - _1337)) * _1421) + _1337), 0.0f), 65535.0f);
                  _1431 = min(max(_1338, 0.0f), 65535.0f);
                  _1432 = min(max(_1339, 0.0f), 65535.0f);
                  _1445 = min(max(mad(-0.21492856740951538f, _1432, mad(-0.2365107536315918f, _1431, (_1430 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  _1446 = min(max(mad(-0.09967592358589172f, _1432, mad(1.17622971534729f, _1431, (_1430 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  _1447 = min(max(mad(0.9977163076400757f, _1432, mad(-0.006032449658960104f, _1431, (_1430 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  _1448 = dot(float3(_1445, _1446, _1447), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  _1471 = log2(max((lerp(_1448, _1445, 0.9599999785423279f)), 1.000000013351432e-10f));
                  _1472 = _1471 * 0.3010300099849701f;
                  _1473 = log2(cb0_008x);
                  _1474 = _1473 * 0.3010300099849701f;
                  do {
                    if (!(!(_1472 <= _1474))) {
                      _1543 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      _1481 = log2(cb0_009x);
                      _1482 = _1481 * 0.3010300099849701f;
                      if ((_1472 > _1474) && (_1472 < _1482)) {
                        _1490 = ((_1471 - _1473) * 0.9030900001525879f) / ((_1481 - _1473) * 0.3010300099849701f);
                        _1491 = int(_1490);
                        _1493 = _1490 - float((int)(_1491));
                        _1495 = _17[min((uint)(_1491), 5u)];
                        _1498 = _17[min((uint)((_1491 + 1)), 5u)];
                        _1503 = _1495 * 0.5f;
                        _1543 = dot(float3((_1493 * _1493), _1493, 1.0f), float3(mad((_17[min((uint)((_1491 + 2)), 5u)]), 0.5f, mad(_1498, -1.0f, _1503)), (_1498 - _1495), mad(_1498, 0.5f, _1503)));
                      } else {
                        if (!(!(_1472 >= _1482))) {
                          _1512 = log2(cb0_008z);
                          if (_1472 < (_1512 * 0.3010300099849701f)) {
                            _1520 = ((_1471 - _1481) * 0.9030900001525879f) / ((_1512 - _1481) * 0.3010300099849701f);
                            _1521 = int(_1520);
                            _1523 = _1520 - float((int)(_1521));
                            _1525 = _18[min((uint)(_1521), 5u)];
                            _1528 = _18[min((uint)((_1521 + 1)), 5u)];
                            _1533 = _1525 * 0.5f;
                            _1543 = dot(float3((_1523 * _1523), _1523, 1.0f), float3(mad((_18[min((uint)((_1521 + 2)), 5u)]), 0.5f, mad(_1528, -1.0f, _1533)), (_1528 - _1525), mad(_1528, 0.5f, _1533)));
                          } else {
                            _1543 = (log2(cb0_008w) * 0.3010300099849701f);
                          }
                        } else {
                          _1543 = (log2(cb0_008w) * 0.3010300099849701f);
                        }
                      }
                    }
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
                    _1559 = log2(max((lerp(_1448, _1446, 0.9599999785423279f)), 1.000000013351432e-10f));
                    _1560 = _1559 * 0.3010300099849701f;
                    do {
                      if (!(!(_1560 <= _1474))) {
                        _1629 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        _1567 = log2(cb0_009x);
                        _1568 = _1567 * 0.3010300099849701f;
                        if ((_1560 > _1474) && (_1560 < _1568)) {
                          _1576 = ((_1559 - _1473) * 0.9030900001525879f) / ((_1567 - _1473) * 0.3010300099849701f);
                          _1577 = int(_1576);
                          _1579 = _1576 - float((int)(_1577));
                          _1581 = _19[min((uint)(_1577), 5u)];
                          _1584 = _19[min((uint)((_1577 + 1)), 5u)];
                          _1589 = _1581 * 0.5f;
                          _1629 = dot(float3((_1579 * _1579), _1579, 1.0f), float3(mad((_19[min((uint)((_1577 + 2)), 5u)]), 0.5f, mad(_1584, -1.0f, _1589)), (_1584 - _1581), mad(_1584, 0.5f, _1589)));
                        } else {
                          if (!(!(_1560 >= _1568))) {
                            _1598 = log2(cb0_008z);
                            if (_1560 < (_1598 * 0.3010300099849701f)) {
                              _1606 = ((_1559 - _1567) * 0.9030900001525879f) / ((_1598 - _1567) * 0.3010300099849701f);
                              _1607 = int(_1606);
                              _1609 = _1606 - float((int)(_1607));
                              _1611 = _20[min((uint)(_1607), 5u)];
                              _1614 = _20[min((uint)((_1607 + 1)), 5u)];
                              _1619 = _1611 * 0.5f;
                              _1629 = dot(float3((_1609 * _1609), _1609, 1.0f), float3(mad((_20[min((uint)((_1607 + 2)), 5u)]), 0.5f, mad(_1614, -1.0f, _1619)), (_1614 - _1611), mad(_1614, 0.5f, _1619)));
                            } else {
                              _1629 = (log2(cb0_008w) * 0.3010300099849701f);
                            }
                          } else {
                            _1629 = (log2(cb0_008w) * 0.3010300099849701f);
                          }
                        }
                      }
                      _1633 = log2(max((lerp(_1448, _1447, 0.9599999785423279f)), 1.000000013351432e-10f));
                      _1634 = _1633 * 0.3010300099849701f;
                      do {
                        if (!(!(_1634 <= _1474))) {
                          _1703 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          _1641 = log2(cb0_009x);
                          _1642 = _1641 * 0.3010300099849701f;
                          if ((_1634 > _1474) && (_1634 < _1642)) {
                            _1650 = ((_1633 - _1473) * 0.9030900001525879f) / ((_1641 - _1473) * 0.3010300099849701f);
                            _1651 = int(_1650);
                            _1653 = _1650 - float((int)(_1651));
                            _1655 = _9[min((uint)(_1651), 5u)];
                            _1658 = _9[min((uint)((_1651 + 1)), 5u)];
                            _1663 = _1655 * 0.5f;
                            _1703 = dot(float3((_1653 * _1653), _1653, 1.0f), float3(mad((_9[min((uint)((_1651 + 2)), 5u)]), 0.5f, mad(_1658, -1.0f, _1663)), (_1658 - _1655), mad(_1658, 0.5f, _1663)));
                          } else {
                            if (!(!(_1634 >= _1642))) {
                              _1672 = log2(cb0_008z);
                              if (_1634 < (_1672 * 0.3010300099849701f)) {
                                _1680 = ((_1633 - _1641) * 0.9030900001525879f) / ((_1672 - _1641) * 0.3010300099849701f);
                                _1681 = int(_1680);
                                _1683 = _1680 - float((int)(_1681));
                                _1685 = _10[min((uint)(_1681), 5u)];
                                _1688 = _10[min((uint)((_1681 + 1)), 5u)];
                                _1693 = _1685 * 0.5f;
                                _1703 = dot(float3((_1683 * _1683), _1683, 1.0f), float3(mad((_10[min((uint)((_1681 + 2)), 5u)]), 0.5f, mad(_1688, -1.0f, _1693)), (_1688 - _1685), mad(_1688, 0.5f, _1693)));
                              } else {
                                _1703 = (log2(cb0_008w) * 0.3010300099849701f);
                              }
                            } else {
                              _1703 = (log2(cb0_008w) * 0.3010300099849701f);
                            }
                          }
                        }
                        _1707 = cb0_008w - cb0_008y;
                        _1708 = (exp2(_1543 * 3.321928024291992f) - cb0_008y) / _1707;
                        _1710 = (exp2(_1629 * 3.321928024291992f) - cb0_008y) / _1707;
                        _1712 = (exp2(_1703 * 3.321928024291992f) - cb0_008y) / _1707;
                        _1715 = mad(0.15618768334388733f, _1712, mad(0.13400420546531677f, _1710, (_1708 * 0.6624541878700256f)));
                        _1718 = mad(0.053689517080783844f, _1712, mad(0.6740817427635193f, _1710, (_1708 * 0.2722287178039551f)));
                        _1721 = mad(1.0103391408920288f, _1712, mad(0.00406073359772563f, _1710, (_1708 * -0.005574649665504694f)));
                        _1734 = min(max(mad(-0.23642469942569733f, _1721, mad(-0.32480329275131226f, _1718, (_1715 * 1.6410233974456787f))), 0.0f), 1.0f);
                        _1735 = min(max(mad(0.016756348311901093f, _1721, mad(1.6153316497802734f, _1718, (_1715 * -0.663662850856781f))), 0.0f), 1.0f);
                        _1736 = min(max(mad(0.9883948564529419f, _1721, mad(-0.008284442126750946f, _1718, (_1715 * 0.011721894145011902f))), 0.0f), 1.0f);
                        _1739 = mad(0.15618768334388733f, _1736, mad(0.13400420546531677f, _1735, (_1734 * 0.6624541878700256f)));
                        _1742 = mad(0.053689517080783844f, _1736, mad(0.6740817427635193f, _1735, (_1734 * 0.2722287178039551f)));
                        _1745 = mad(1.0103391408920288f, _1736, mad(0.00406073359772563f, _1735, (_1734 * -0.005574649665504694f)));
                        _1767 = min(max((min(max(mad(-0.23642469942569733f, _1745, mad(-0.32480329275131226f, _1742, (_1739 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        _1768 = min(max((min(max(mad(0.016756348311901093f, _1745, mad(1.6153316497802734f, _1742, (_1739 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        _1769 = min(max((min(max(mad(0.9883948564529419f, _1745, mad(-0.008284442126750946f, _1742, (_1739 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          _1782 = _1767;
                          _1783 = _1768;
                          _1784 = _1769;
                          if (!(cb0_040w == 5)) {
                            _1782 = mad(_63, _1769, mad(_62, _1768, (_1767 * _61)));
                            _1783 = mad(_66, _1769, mad(_65, _1768, (_1767 * _64)));
                            _1784 = mad(_69, _1769, mad(_68, _1768, (_1767 * _67)));
                          }
                          _1794 = exp2(log2(_1782 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _1795 = exp2(log2(_1783 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _1796 = exp2(log2(_1784 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2659 = exp2(log2((1.0f / ((_1794 * 18.6875f) + 1.0f)) * ((_1794 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2660 = exp2(log2((1.0f / ((_1795 * 18.6875f) + 1.0f)) * ((_1795 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2661 = exp2(log2((1.0f / ((_1796 * 18.6875f) + 1.0f)) * ((_1796 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((cb0_040w & -3) == 4) {
          _1862 = cb0_012z * _975;
          _1863 = cb0_012z * _976;
          _1864 = cb0_012z * _977;
          _1867 = mad((WorkingColorSpace_256[0].z), _1864, mad((WorkingColorSpace_256[0].y), _1863, ((WorkingColorSpace_256[0].x) * _1862)));
          _1870 = mad((WorkingColorSpace_256[1].z), _1864, mad((WorkingColorSpace_256[1].y), _1863, ((WorkingColorSpace_256[1].x) * _1862)));
          _1873 = mad((WorkingColorSpace_256[2].z), _1864, mad((WorkingColorSpace_256[2].y), _1863, ((WorkingColorSpace_256[2].x) * _1862)));
          _1876 = mad(-0.21492856740951538f, _1873, mad(-0.2365107536315918f, _1870, (_1867 * 1.4514392614364624f)));
          _1879 = mad(-0.09967592358589172f, _1873, mad(1.17622971534729f, _1870, (_1867 * -0.07655377686023712f)));
          _1882 = mad(0.9977163076400757f, _1873, mad(-0.006032449658960104f, _1870, (_1867 * 0.008316148072481155f)));
          _1884 = max(_1876, max(_1879, _1882));
          do {
            _1952 = _1876;
            _1953 = _1879;
            _1954 = _1882;
            if (!(_1884 < 1.000000013351432e-10f)) {
              if (!(((_1867 < 0.0f) || (_1870 < 0.0f)) || (_1873 < 0.0f))) {
                _1894 = abs(_1884);
                _1895 = (_1884 - _1876) / _1894;
                _1897 = (_1884 - _1879) / _1894;
                _1899 = (_1884 - _1882) / _1894;
                do {
                  _1914 = _1895;
                  if (!(_1895 < 0.8149999976158142f)) {
                    _1902 = _1895 + -0.8149999976158142f;
                    _1914 = ((_1902 / exp2(log2(exp2(log2(_1902 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  }
                  do {
                    _1929 = _1897;
                    if (!(_1897 < 0.8029999732971191f)) {
                      _1917 = _1897 + -0.8029999732971191f;
                      _1929 = ((_1917 / exp2(log2(exp2(log2(_1917 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    }
                    do {
                      _1944 = _1899;
                      if (!(_1899 < 0.8799999952316284f)) {
                        _1932 = _1899 + -0.8799999952316284f;
                        _1944 = ((_1932 / exp2(log2(exp2(log2(_1932 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      }
                      _1952 = (_1884 - (_1894 * _1914));
                      _1953 = (_1884 - (_1894 * _1929));
                      _1954 = (_1884 - (_1894 * _1944));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _1952 = _1876;
                _1953 = _1879;
                _1954 = _1882;
              }
            }
            _1970 = ((mad(0.16386906802654266f, _1954, mad(0.14067870378494263f, _1953, (_1952 * 0.6954522132873535f))) - _1867) * cb0_012w) + _1867;
            _1971 = ((mad(0.0955343171954155f, _1954, mad(0.8596711158752441f, _1953, (_1952 * 0.044794563204050064f))) - _1870) * cb0_012w) + _1870;
            _1972 = ((mad(1.0015007257461548f, _1954, mad(0.004025210160762072f, _1953, (_1952 * -0.005525882821530104f))) - _1873) * cb0_012w) + _1873;
            _1976 = max(max(_1970, _1971), _1972);
            _1981 = (max(_1976, 1.000000013351432e-10f) - max(min(min(_1970, _1971), _1972), 1.000000013351432e-10f)) / max(_1976, 0.009999999776482582f);
            _1994 = ((_1971 + _1970) + _1972) + (sqrt((((_1972 - _1971) * _1972) + ((_1971 - _1970) * _1971)) + ((_1970 - _1972) * _1970)) * 1.75f);
            _1995 = _1994 * 0.3333333432674408f;
            _1996 = _1981 + -0.4000000059604645f;
            _1997 = _1996 * 5.0f;
            _2001 = max((1.0f - abs(_1996 * 2.5f)), 0.0f);
            _2012 = ((float((int)(((int)(uint)((int)(_1997 > 0.0f))) - ((int)(uint)((int)(_1997 < 0.0f))))) * (1.0f - (_2001 * _2001))) + 1.0f) * 0.02500000037252903f;
            do {
              _2021 = _2012;
              if (!(_1995 <= 0.0533333346247673f)) {
                if (!(_1995 >= 0.1599999964237213f)) {
                  _2021 = (((0.23999999463558197f / _1994) + -0.5f) * _2012);
                } else {
                  _2021 = 0.0f;
                }
              }
              _2022 = _2021 + 1.0f;
              _2023 = _2022 * _1970;
              _2024 = _2022 * _1971;
              _2025 = _2022 * _1972;
              do {
                _2054 = 0.0f;
                if (!((_2023 == _2024) && (_2024 == _2025))) {
                  _2032 = ((_2023 * 2.0f) - _2024) - _2025;
                  _2035 = ((_1971 - _1972) * 1.7320507764816284f) * _2022;
                  _2037 = atan(_2035 / _2032);
                  _2040 = (_2032 < 0.0f);
                  _2041 = (_2032 == 0.0f);
                  _2042 = (_2035 >= 0.0f);
                  _2043 = (_2035 < 0.0f);
                  _2054 = select((_2042 && _2041), 90.0f, select((_2043 && _2041), -90.0f, (select((_2043 && _2040), (_2037 + -3.1415927410125732f), select((_2042 && _2040), (_2037 + 3.1415927410125732f), _2037)) * 57.2957763671875f)));
                }
                _2059 = min(max(select((_2054 < 0.0f), (_2054 + 360.0f), _2054), 0.0f), 360.0f);
                do {
                  if (_2059 < -180.0f) {
                    _2068 = (_2059 + 360.0f);
                  } else {
                    if (_2059 > 180.0f) {
                      _2068 = (_2059 + -360.0f);
                    } else {
                      _2068 = _2059;
                    }
                  }
                  do {
                    _2107 = 0.0f;
                    if ((_2068 > -67.5f) && (_2068 < 67.5f)) {
                      _2074 = (_2068 + 67.5f) * 0.029629629105329514f;
                      _2075 = int(_2074);
                      _2077 = _2074 - float((int)(_2075));
                      _2078 = _2077 * _2077;
                      _2079 = _2078 * _2077;
                      if (_2075 == 3) {
                        _2107 = (((0.1666666716337204f - (_2077 * 0.5f)) + (_2078 * 0.5f)) - (_2079 * 0.1666666716337204f));
                      } else {
                        if (_2075 == 2) {
                          _2107 = ((0.6666666865348816f - _2078) + (_2079 * 0.5f));
                        } else {
                          if (_2075 == 1) {
                            _2107 = (((_2079 * -0.5f) + 0.1666666716337204f) + ((_2078 + _2077) * 0.5f));
                          } else {
                            _2107 = select((_2075 == 0), (_2079 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    }
                    _2116 = min(max(((((_1981 * 0.27000001072883606f) * (0.029999999329447746f - _2023)) * _2107) + _2023), 0.0f), 65535.0f);
                    _2117 = min(max(_2024, 0.0f), 65535.0f);
                    _2118 = min(max(_2025, 0.0f), 65535.0f);
                    _2131 = min(max(mad(-0.21492856740951538f, _2118, mad(-0.2365107536315918f, _2117, (_2116 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    _2132 = min(max(mad(-0.09967592358589172f, _2118, mad(1.17622971534729f, _2117, (_2116 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    _2133 = min(max(mad(0.9977163076400757f, _2118, mad(-0.006032449658960104f, _2117, (_2116 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    _2134 = dot(float3(_2131, _2132, _2133), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    _2157 = log2(max((lerp(_2134, _2131, 0.9599999785423279f)), 1.000000013351432e-10f));
                    _2158 = _2157 * 0.3010300099849701f;
                    _2159 = log2(cb0_008x);
                    _2160 = _2159 * 0.3010300099849701f;
                    do {
                      if (!(!(_2158 <= _2160))) {
                        _2229 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        _2167 = log2(cb0_009x);
                        _2168 = _2167 * 0.3010300099849701f;
                        if ((_2158 > _2160) && (_2158 < _2168)) {
                          _2176 = ((_2157 - _2159) * 0.9030900001525879f) / ((_2167 - _2159) * 0.3010300099849701f);
                          _2177 = int(_2176);
                          _2179 = _2176 - float((int)(_2177));
                          _2181 = _15[min((uint)(_2177), 5u)];
                          _2184 = _15[min((uint)((_2177 + 1)), 5u)];
                          _2189 = _2181 * 0.5f;
                          _2229 = dot(float3((_2179 * _2179), _2179, 1.0f), float3(mad((_15[min((uint)((_2177 + 2)), 5u)]), 0.5f, mad(_2184, -1.0f, _2189)), (_2184 - _2181), mad(_2184, 0.5f, _2189)));
                        } else {
                          if (!(!(_2158 >= _2168))) {
                            _2198 = log2(cb0_008z);
                            if (_2158 < (_2198 * 0.3010300099849701f)) {
                              _2206 = ((_2157 - _2167) * 0.9030900001525879f) / ((_2198 - _2167) * 0.3010300099849701f);
                              _2207 = int(_2206);
                              _2209 = _2206 - float((int)(_2207));
                              _2211 = _16[min((uint)(_2207), 5u)];
                              _2214 = _16[min((uint)((_2207 + 1)), 5u)];
                              _2219 = _2211 * 0.5f;
                              _2229 = dot(float3((_2209 * _2209), _2209, 1.0f), float3(mad((_16[min((uint)((_2207 + 2)), 5u)]), 0.5f, mad(_2214, -1.0f, _2219)), (_2214 - _2211), mad(_2214, 0.5f, _2219)));
                            } else {
                              _2229 = (log2(cb0_008w) * 0.3010300099849701f);
                            }
                          } else {
                            _2229 = (log2(cb0_008w) * 0.3010300099849701f);
                          }
                        }
                      }
                      _11[0] = cb0_010x;
                      _11[1] = cb0_010y;
                      _11[2] = cb0_010z;
                      _11[3] = cb0_010w;
                      _11[4] = cb0_012x;
                      _11[5] = cb0_012x;
                      _12[0] = cb0_011x;
                      _12[1] = cb0_011y;
                      _12[2] = cb0_011z;
                      _12[3] = cb0_011w;
                      _12[4] = cb0_012y;
                      _12[5] = cb0_012y;
                      _2245 = log2(max((lerp(_2134, _2132, 0.9599999785423279f)), 1.000000013351432e-10f));
                      _2246 = _2245 * 0.3010300099849701f;
                      do {
                        if (!(!(_2246 <= _2160))) {
                          _2315 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          _2253 = log2(cb0_009x);
                          _2254 = _2253 * 0.3010300099849701f;
                          if ((_2246 > _2160) && (_2246 < _2254)) {
                            _2262 = ((_2245 - _2159) * 0.9030900001525879f) / ((_2253 - _2159) * 0.3010300099849701f);
                            _2263 = int(_2262);
                            _2265 = _2262 - float((int)(_2263));
                            _2267 = _11[min((uint)(_2263), 5u)];
                            _2270 = _11[min((uint)((_2263 + 1)), 5u)];
                            _2275 = _2267 * 0.5f;
                            _2315 = dot(float3((_2265 * _2265), _2265, 1.0f), float3(mad((_11[min((uint)((_2263 + 2)), 5u)]), 0.5f, mad(_2270, -1.0f, _2275)), (_2270 - _2267), mad(_2270, 0.5f, _2275)));
                          } else {
                            if (!(!(_2246 >= _2254))) {
                              _2284 = log2(cb0_008z);
                              if (_2246 < (_2284 * 0.3010300099849701f)) {
                                _2292 = ((_2245 - _2253) * 0.9030900001525879f) / ((_2284 - _2253) * 0.3010300099849701f);
                                _2293 = int(_2292);
                                _2295 = _2292 - float((int)(_2293));
                                _2297 = _12[min((uint)(_2293), 5u)];
                                _2300 = _12[min((uint)((_2293 + 1)), 5u)];
                                _2305 = _2297 * 0.5f;
                                _2315 = dot(float3((_2295 * _2295), _2295, 1.0f), float3(mad((_12[min((uint)((_2293 + 2)), 5u)]), 0.5f, mad(_2300, -1.0f, _2305)), (_2300 - _2297), mad(_2300, 0.5f, _2305)));
                              } else {
                                _2315 = (log2(cb0_008w) * 0.3010300099849701f);
                              }
                            } else {
                              _2315 = (log2(cb0_008w) * 0.3010300099849701f);
                            }
                          }
                        }
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
                        _2331 = log2(max((lerp(_2134, _2133, 0.9599999785423279f)), 1.000000013351432e-10f));
                        _2332 = _2331 * 0.3010300099849701f;
                        do {
                          if (!(!(_2332 <= _2160))) {
                            _2401 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            _2339 = log2(cb0_009x);
                            _2340 = _2339 * 0.3010300099849701f;
                            if ((_2332 > _2160) && (_2332 < _2340)) {
                              _2348 = ((_2331 - _2159) * 0.9030900001525879f) / ((_2339 - _2159) * 0.3010300099849701f);
                              _2349 = int(_2348);
                              _2351 = _2348 - float((int)(_2349));
                              _2353 = _13[min((uint)(_2349), 5u)];
                              _2356 = _13[min((uint)((_2349 + 1)), 5u)];
                              _2361 = _2353 * 0.5f;
                              _2401 = dot(float3((_2351 * _2351), _2351, 1.0f), float3(mad((_13[min((uint)((_2349 + 2)), 5u)]), 0.5f, mad(_2356, -1.0f, _2361)), (_2356 - _2353), mad(_2356, 0.5f, _2361)));
                            } else {
                              if (!(!(_2332 >= _2340))) {
                                _2370 = log2(cb0_008z);
                                if (_2332 < (_2370 * 0.3010300099849701f)) {
                                  _2378 = ((_2331 - _2339) * 0.9030900001525879f) / ((_2370 - _2339) * 0.3010300099849701f);
                                  _2379 = int(_2378);
                                  _2381 = _2378 - float((int)(_2379));
                                  _2383 = _14[min((uint)(_2379), 5u)];
                                  _2386 = _14[min((uint)((_2379 + 1)), 5u)];
                                  _2391 = _2383 * 0.5f;
                                  _2401 = dot(float3((_2381 * _2381), _2381, 1.0f), float3(mad((_14[min((uint)((_2379 + 2)), 5u)]), 0.5f, mad(_2386, -1.0f, _2391)), (_2386 - _2383), mad(_2386, 0.5f, _2391)));
                                } else {
                                  _2401 = (log2(cb0_008w) * 0.3010300099849701f);
                                }
                              } else {
                                _2401 = (log2(cb0_008w) * 0.3010300099849701f);
                              }
                            }
                          }
                          _2405 = cb0_008w - cb0_008y;
                          _2406 = (exp2(_2229 * 3.321928024291992f) - cb0_008y) / _2405;
                          _2408 = (exp2(_2315 * 3.321928024291992f) - cb0_008y) / _2405;
                          _2410 = (exp2(_2401 * 3.321928024291992f) - cb0_008y) / _2405;
                          _2413 = mad(0.15618768334388733f, _2410, mad(0.13400420546531677f, _2408, (_2406 * 0.6624541878700256f)));
                          _2416 = mad(0.053689517080783844f, _2410, mad(0.6740817427635193f, _2408, (_2406 * 0.2722287178039551f)));
                          _2419 = mad(1.0103391408920288f, _2410, mad(0.00406073359772563f, _2408, (_2406 * -0.005574649665504694f)));
                          _2432 = min(max(mad(-0.23642469942569733f, _2419, mad(-0.32480329275131226f, _2416, (_2413 * 1.6410233974456787f))), 0.0f), 1.0f);
                          _2433 = min(max(mad(0.016756348311901093f, _2419, mad(1.6153316497802734f, _2416, (_2413 * -0.663662850856781f))), 0.0f), 1.0f);
                          _2434 = min(max(mad(0.9883948564529419f, _2419, mad(-0.008284442126750946f, _2416, (_2413 * 0.011721894145011902f))), 0.0f), 1.0f);
                          _2437 = mad(0.15618768334388733f, _2434, mad(0.13400420546531677f, _2433, (_2432 * 0.6624541878700256f)));
                          _2440 = mad(0.053689517080783844f, _2434, mad(0.6740817427635193f, _2433, (_2432 * 0.2722287178039551f)));
                          _2443 = mad(1.0103391408920288f, _2434, mad(0.00406073359772563f, _2433, (_2432 * -0.005574649665504694f)));
                          _2465 = min(max((min(max(mad(-0.23642469942569733f, _2443, mad(-0.32480329275131226f, _2440, (_2437 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          _2466 = min(max((min(max(mad(0.016756348311901093f, _2443, mad(1.6153316497802734f, _2440, (_2437 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          _2467 = min(max((min(max(mad(0.9883948564529419f, _2443, mad(-0.008284442126750946f, _2440, (_2437 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            _2480 = _2465;
                            _2481 = _2466;
                            _2482 = _2467;
                            if (!(cb0_040w == 6)) {
                              _2480 = mad(_63, _2467, mad(_62, _2466, (_2465 * _61)));
                              _2481 = mad(_66, _2467, mad(_65, _2466, (_2465 * _64)));
                              _2482 = mad(_69, _2467, mad(_68, _2466, (_2465 * _67)));
                            }
                            _2492 = exp2(log2(_2480 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2493 = exp2(log2(_2481 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2494 = exp2(log2(_2482 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2659 = exp2(log2((1.0f / ((_2492 * 18.6875f) + 1.0f)) * ((_2492 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2660 = exp2(log2((1.0f / ((_2493 * 18.6875f) + 1.0f)) * ((_2493 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2661 = exp2(log2((1.0f / ((_2494 * 18.6875f) + 1.0f)) * ((_2494 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (cb0_040w == 7) {
            _2539 = mad((WorkingColorSpace_128[0].z), _977, mad((WorkingColorSpace_128[0].y), _976, ((WorkingColorSpace_128[0].x) * _975)));
            _2542 = mad((WorkingColorSpace_128[1].z), _977, mad((WorkingColorSpace_128[1].y), _976, ((WorkingColorSpace_128[1].x) * _975)));
            _2545 = mad((WorkingColorSpace_128[2].z), _977, mad((WorkingColorSpace_128[2].y), _976, ((WorkingColorSpace_128[2].x) * _975)));
            _2564 = exp2(log2(mad(_63, _2545, mad(_62, _2542, (_2539 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2565 = exp2(log2(mad(_66, _2545, mad(_65, _2542, (_2539 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2566 = exp2(log2(mad(_69, _2545, mad(_68, _2542, (_2539 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2659 = exp2(log2((1.0f / ((_2564 * 18.6875f) + 1.0f)) * ((_2564 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2660 = exp2(log2((1.0f / ((_2565 * 18.6875f) + 1.0f)) * ((_2565 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2661 = exp2(log2((1.0f / ((_2566 * 18.6875f) + 1.0f)) * ((_2566 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                _2613 = mad((WorkingColorSpace_128[0].z), _965, mad((WorkingColorSpace_128[0].y), _964, ((WorkingColorSpace_128[0].x) * _963)));
                _2616 = mad((WorkingColorSpace_128[1].z), _965, mad((WorkingColorSpace_128[1].y), _964, ((WorkingColorSpace_128[1].x) * _963)));
                _2619 = mad((WorkingColorSpace_128[2].z), _965, mad((WorkingColorSpace_128[2].y), _964, ((WorkingColorSpace_128[2].x) * _963)));
                _2659 = mad(_63, _2619, mad(_62, _2616, (_2613 * _61)));
                _2660 = mad(_66, _2619, mad(_65, _2616, (_2613 * _64)));
                _2661 = mad(_69, _2619, mad(_68, _2616, (_2613 * _67)));
              } else {
                _2632 = mad((WorkingColorSpace_128[0].z), _991, mad((WorkingColorSpace_128[0].y), _990, ((WorkingColorSpace_128[0].x) * _989)));
                _2635 = mad((WorkingColorSpace_128[1].z), _991, mad((WorkingColorSpace_128[1].y), _990, ((WorkingColorSpace_128[1].x) * _989)));
                _2638 = mad((WorkingColorSpace_128[2].z), _991, mad((WorkingColorSpace_128[2].y), _990, ((WorkingColorSpace_128[2].x) * _989)));
                _2659 = exp2(log2(mad(_63, _2638, mad(_62, _2635, (_2632 * _61)))) * cb0_040z);
                _2660 = exp2(log2(mad(_66, _2638, mad(_65, _2635, (_2632 * _64)))) * cb0_040z);
                _2661 = exp2(log2(mad(_69, _2638, mad(_68, _2635, (_2632 * _67)))) * cb0_040z);
              }
            } else {
              _2659 = _975;
              _2660 = _976;
              _2661 = _977;
            }
          }
        }
      }
    }
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_2659 * 0.9523810148239136f), (_2660 * 0.9523810148239136f), (_2661 * 0.9523810148239136f), 0.0f);
}
#include "../../lutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

cbuffer cb0 : register(b0) {
  float cb0_026x : packoffset(c026.x);
  float cb0_026y : packoffset(c026.y);
  float cb0_026z : packoffset(c026.z);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
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
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_034z : packoffset(c034.z);
  float cb0_035x : packoffset(c035.x);
  float cb0_035y : packoffset(c035.y);
  float cb0_035z : packoffset(c035.z);
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_036w : packoffset(c036.w);
  float cb0_037x : packoffset(c037.x);
  float cb0_038w : packoffset(c038.w);
  float cb0_039z : packoffset(c039.z);
  float cb0_040x : packoffset(c040.x);
  float cb0_041x : packoffset(c041.x);
  float cb0_042x : packoffset(c042.x);
  float cb0_043x : packoffset(c043.x);
  float cb0_044y : packoffset(c044.y);
  float cb0_044z : packoffset(c044.z);
  float cb0_044w : packoffset(c044.w);
  float cb0_045x : packoffset(c045.x);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_045w : packoffset(c045.w);
  int cb0_046x : packoffset(c046.x);
  int cb0_046y : packoffset(c046.y);
  int cb0_046z : packoffset(c046.z);
  int cb0_046w : packoffset(c046.w);
  float cb0_047x : packoffset(c047.x);
  float cb0_047y : packoffset(c047.y);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_049x : packoffset(c049.x);
  float cb0_049y : packoffset(c049.y);
  float cb0_049z : packoffset(c049.z);
  float cb0_049w : packoffset(c049.w);
  float cb0_050x : packoffset(c050.x);
  float cb0_050y : packoffset(c050.y);
  float cb0_050z : packoffset(c050.z);
  float cb0_050w : packoffset(c050.w);
  float cb0_051x : packoffset(c051.x);
  float cb0_051y : packoffset(c051.y);
  float cb0_051z : packoffset(c051.z);
  float cb0_051w : packoffset(c051.w);
  float cb0_052x : packoffset(c052.x);
  float cb0_052y : packoffset(c052.y);
  float cb0_052z : packoffset(c052.z);
  float cb0_052w : packoffset(c052.w);
  float cb0_053x : packoffset(c053.x);
  float cb0_053y : packoffset(c053.y);
  float cb0_053z : packoffset(c053.z);
  float cb0_053w : packoffset(c053.w);
  float cb0_054x : packoffset(c054.x);
  float cb0_054y : packoffset(c054.y);
  float cb0_054z : packoffset(c054.z);
  float cb0_054w : packoffset(c054.w);
  float cb0_055x : packoffset(c055.x);
  float cb0_055y : packoffset(c055.y);
  float cb0_055z : packoffset(c055.z);
  float cb0_055w : packoffset(c055.w);
  float cb0_056x : packoffset(c056.x);
  float cb0_056y : packoffset(c056.y);
  float cb0_056z : packoffset(c056.z);
  float cb0_056w : packoffset(c056.w);
  float cb0_057x : packoffset(c057.x);
  float cb0_057y : packoffset(c057.y);
  float cb0_057z : packoffset(c057.z);
  float cb0_057w : packoffset(c057.w);
  float cb0_058x : packoffset(c058.x);
  float cb0_058y : packoffset(c058.y);
  float cb0_058z : packoffset(c058.z);
  float cb0_058w : packoffset(c058.w);
  float cb0_059x : packoffset(c059.x);
  float cb0_059y : packoffset(c059.y);
  float cb0_059z : packoffset(c059.z);
  float cb0_059w : packoffset(c059.w);
  float cb0_060x : packoffset(c060.x);
  float cb0_060y : packoffset(c060.y);
  float cb0_060z : packoffset(c060.z);
  float cb0_060w : packoffset(c060.w);
  float cb0_061x : packoffset(c061.x);
  float cb0_061y : packoffset(c061.y);
  float cb0_061z : packoffset(c061.z);
  float cb0_061w : packoffset(c061.w);
  float cb0_062x : packoffset(c062.x);
  float cb0_062y : packoffset(c062.y);
  float cb0_062z : packoffset(c062.z);
  float cb0_062w : packoffset(c062.w);
  float cb0_063x : packoffset(c063.x);
  float cb0_063y : packoffset(c063.y);
  float cb0_063z : packoffset(c063.z);
  float cb0_063w : packoffset(c063.w);
  float cb0_064x : packoffset(c064.x);
  float cb0_064y : packoffset(c064.y);
  float cb0_064z : packoffset(c064.z);
  float cb0_064w : packoffset(c064.w);
  float cb0_065x : packoffset(c065.x);
  float cb0_065y : packoffset(c065.y);
  float cb0_065z : packoffset(c065.z);
  float cb0_065w : packoffset(c065.w);
  float cb0_066x : packoffset(c066.x);
  float cb0_066y : packoffset(c066.y);
  float cb0_066z : packoffset(c066.z);
  float cb0_066w : packoffset(c066.w);
  float cb0_067x : packoffset(c067.x);
  float cb0_067y : packoffset(c067.y);
  float cb0_067z : packoffset(c067.z);
  float cb0_067w : packoffset(c067.w);
  float cb0_068x : packoffset(c068.x);
  float cb0_068y : packoffset(c068.y);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_069x : packoffset(c069.x);
  float cb0_069y : packoffset(c069.y);
  float cb0_069z : packoffset(c069.z);
  float cb0_069w : packoffset(c069.w);
  float cb0_070x : packoffset(c070.x);
  float cb0_070y : packoffset(c070.y);
  float cb0_070z : packoffset(c070.z);
  float cb0_070w : packoffset(c070.w);
  float cb0_071x : packoffset(c071.x);
  float cb0_071y : packoffset(c071.y);
  float cb0_071z : packoffset(c071.z);
  float cb0_071w : packoffset(c071.w);
  float cb0_072x : packoffset(c072.x);
  float cb0_072y : packoffset(c072.y);
  float cb0_072z : packoffset(c072.z);
  float cb0_072w : packoffset(c072.w);
  float cb0_073x : packoffset(c073.x);
  float cb0_073y : packoffset(c073.y);
  float cb0_073z : packoffset(c073.z);
  float cb0_073w : packoffset(c073.w);
  int cb0_074z : packoffset(c074.z);
  int cb0_074w : packoffset(c074.w);
  float cb0_075x : packoffset(c075.x);
  float cb0_075y : packoffset(c075.y);
  float cb0_075z : packoffset(c075.z);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

static const float _global_0[6] = { -4.0f, -4.0f, -3.157376527786255f, -0.48524999618530273f, 1.847732424736023f, 1.847732424736023f };
static const float _global_1[6] = { -0.7185482382774353f, 2.0810306072235107f, 3.668124198913574f, 4.0f, 4.0f, 4.0f };
static const float _global_2[10] = { -4.9706220626831055f, -3.0293781757354736f, -2.126199960708618f, -1.5104999542236328f, -1.057800054550171f, -0.4668000042438507f, 0.11937999725341797f, 0.7088134288787842f, 1.2911865711212158f, 1.2911865711212158f };
static const float _global_3[10] = { 0.8089132308959961f, 1.191086769104004f, 1.5683000087738037f, 1.9483000040054321f, 2.308300018310547f, 2.638400077819824f, 2.859499931335449f, 2.9872608184814453f, 3.0127391815185547f, 3.0127391815185547f };
static const float _global_4[10] = { -2.301029920578003f, -2.301029920578003f, -1.9312000274658203f, -1.5204999446868896f, -1.057800054550171f, -0.4668000042438507f, 0.11937999725341797f, 0.7088134288787842f, 1.2911865711212158f, 1.2911865711212158f };
static const float _global_5[10] = { 0.8019952178001404f, 1.1980048418045044f, 1.5943000316619873f, 1.9973000288009644f, 2.3782999515533447f, 2.768399953842163f, 3.051500082015991f, 3.2746293544769287f, 3.3274307250976562f, 3.3274307250976562f };

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  precise noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _13;
  float _14;
  float _17;
  float _38;
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _103;
  float _104;
  float _105;
  float _344;
  float _345;
  float _346;
  float _512;
  float _513;
  float _535;
  float _536;
  float _537;
  float _682;
  float _683;
  float _704;
  float _705;
  float _706;
  float _852;
  float _853;
  float _874;
  float _875;
  float _876;
  float _1011;
  float _1012;
  float _1033;
  float _1034;
  float _1035;
  float _1130;
  float _1163;
  float _1177;
  float _1241;
  float _1378;
  float _1379;
  float _1380;
  float _1523;
  float _1524;
  float _1525;
  float _1539;
  float _1550;
  float _1561;
  float _1787;
  float _1798;
  float _1920;
  float _1953;
  float _1967;
  float _2006;
  float _2099;
  float _2158;
  float _2217;
  float _2300;
  float _2365;
  float _2430;
  float _2447;
  float _2448;
  float _2449;
  float _2553;
  float _2586;
  float _2600;
  float _2639;
  float _2732;
  float _2791;
  float _2850;
  float _2930;
  float _2992;
  float _3054;
  float _3068;
  float _3069;
  float _3070;
  float _3226;
  float _3227;
  float _3228;
  bool _27;
  float _56;
  float _57;
  float _58;
  float _108;
  float _122;
  float _136;
  float _146;
  float _151;
  float _152;
  float _154;
  bool _155;
  float _160;
  float _161;
  float _164;
  float _167;
  float _172;
  float _178;
  float _179;
  float _180;
  float _181;
  float _184;
  float _194;
  float _195;
  float _196;
  float _197;
  float _198;
  float _199;
  float _200;
  float _201;
  float _202;
  float _205;
  float _208;
  float _211;
  float _214;
  float _217;
  float _220;
  float _223;
  float _226;
  float _229;
  float _232;
  float _235;
  float _238;
  float _241;
  float _244;
  float _247;
  float _250;
  float _253;
  float _256;
  float _286;
  float _289;
  float _292;
  float _295;
  float _298;
  float _301;
  bool _304;
  float _306;
  float _310;
  float _311;
  float _312;
  float _324;
  float _347;
  float _361;
  float _375;
  float _389;
  float _403;
  float _417;
  float _421;
  float _422;
  float _423;
  float _480;
  float _484;
  float _485;
  float _486;
  float _490;
  float _491;
  float _494;
  float _515;
  float _516;
  float _517;
  float _518;
  float _520;
  float _523;
  float _543;
  float _547;
  float _548;
  float _557;
  float _566;
  float _575;
  float _584;
  float _593;
  float _654;
  float _655;
  float _656;
  float _660;
  float _661;
  float _664;
  float _684;
  float _685;
  float _686;
  float _687;
  float _689;
  float _692;
  float _714;
  float _718;
  float _727;
  float _736;
  float _745;
  float _754;
  float _763;
  float _824;
  float _825;
  float _826;
  float _830;
  float _831;
  float _834;
  float _854;
  float _855;
  float _856;
  float _857;
  float _859;
  float _862;
  float _881;
  float _889;
  float _891;
  float _893;
  float _919;
  float _983;
  float _984;
  float _985;
  float _989;
  float _990;
  float _993;
  float _1013;
  float _1014;
  float _1015;
  float _1016;
  float _1018;
  float _1021;
  float _1036;
  float _1037;
  float _1038;
  float _1041;
  float _1044;
  float _1047;
  float _1063;
  float _1064;
  float _1065;
  float _1075;
  float _1078;
  float _1081;
  float _1085;
  float _1090;
  float _1103;
  float _1104;
  float _1105;
  float _1106;
  float _1110;
  float _1121;
  float _1131;
  float _1132;
  float _1133;
  float _1134;
  float _1141;
  float _1144;
  float _1146;
  bool _1149;
  bool _1150;
  bool _1151;
  bool _1152;
  float _1168;
  float _1181;
  float _1185;
  float _1191;
  float _1201;
  float _1202;
  float _1203;
  float _1204;
  float _1218;
  float _1221;
  float _1223;
  float _1232;
  float _1244;
  float _1246;
  float _1250;
  float _1251;
  float _1252;
  float _1256;
  float _1257;
  float _1258;
  float _1259;
  float _1261;
  float _1262;
  float _1263;
  float _1264;
  float _1283;
  float _1285;
  float _1310;
  float _1311;
  float _1312;
  float _1319;
  float _1323;
  float _1324;
  float _1325;
  bool _1326;
  float _1330;
  float _1331;
  float _1332;
  float _1351;
  float _1352;
  float _1353;
  float _1354;
  float _1396;
  float _1397;
  float _1398;
  float _1441;
  float _1451;
  float _1452;
  float _1453;
  float _1459;
  float _1460;
  float _1461;
  float _1463;
  float _1464;
  float _1465;
  float _1526;
  float _1527;
  float _1528;
  float _1565;
  float _1573;
  float _1574;
  float _1575;
  float _1577;
  float4 _1578;
  float _1582;
  float4 _1583;
  float4 _1604;
  float4 _1608;
  float4 _1629;
  float4 _1633;
  float _1649;
  float _1650;
  float _1651;
  float4 _1654;
  float4 _1658;
  float _1676;
  float _1683;
  float _1684;
  float _1685;
  float _1707;
  float _1708;
  float _1709;
  float _1735;
  float _1736;
  float _1737;
  float _1744;
  float _1745;
  float _1746;
  float _1747;
  float _1748;
  float _1749;
  float _1756;
  float _1757;
  float _1758;
  float _1770;
  float _1771;
  float _1772;
  float _1813;
  float _1816;
  float _1819;
  float _1829;
  float _1830;
  float _1831;
  bool _1858;
  float _1861;
  float _1862;
  float _1865;
  float _1868;
  float _1871;
  float _1875;
  float _1880;
  float _1893;
  float _1894;
  float _1895;
  float _1896;
  float _1900;
  float _1911;
  float _1921;
  float _1922;
  float _1923;
  float _1924;
  float _1931;
  float _1934;
  float _1936;
  bool _1939;
  bool _1940;
  bool _1941;
  bool _1942;
  float _1958;
  float _1973;
  int _1974;
  float _1976;
  float _1977;
  float _1978;
  float _2015;
  float _2016;
  float _2017;
  float _2030;
  float _2031;
  float _2032;
  float _2033;
  float _2040;
  float _2041;
  float _2042;
  float _2045;
  float _2046;
  float _2054;
  int _2055;
  float _2057;
  float _2059;
  float _2062;
  float _2067;
  float _2079;
  int _2080;
  float _2082;
  float _2084;
  float _2087;
  float _2092;
  float _2101;
  float _2104;
  float _2105;
  float _2113;
  int _2114;
  float _2116;
  float _2118;
  float _2121;
  float _2126;
  float _2138;
  int _2139;
  float _2141;
  float _2143;
  float _2146;
  float _2151;
  float _2160;
  float _2163;
  float _2164;
  float _2172;
  int _2173;
  float _2175;
  float _2177;
  float _2180;
  float _2185;
  float _2197;
  int _2198;
  float _2200;
  float _2202;
  float _2205;
  float _2210;
  float _2219;
  float _2222;
  float _2225;
  float _2228;
  float _2231;
  float _2234;
  float _2237;
  float _2240;
  float _2241;
  float _2252;
  int _2253;
  float _2255;
  float _2257;
  float _2260;
  float _2265;
  float _2277;
  int _2278;
  float _2280;
  float _2282;
  float _2285;
  float _2290;
  float _2305;
  float _2306;
  float _2317;
  int _2318;
  float _2320;
  float _2322;
  float _2325;
  float _2330;
  float _2342;
  int _2343;
  float _2345;
  float _2347;
  float _2350;
  float _2355;
  float _2370;
  float _2371;
  float _2382;
  int _2383;
  float _2385;
  float _2387;
  float _2390;
  float _2395;
  float _2407;
  int _2408;
  float _2410;
  float _2412;
  float _2415;
  float _2420;
  float _2433;
  float _2434;
  float _2435;
  float _2459;
  float _2460;
  float _2461;
  float _2494;
  float _2495;
  float _2498;
  float _2501;
  float _2504;
  float _2508;
  float _2513;
  float _2526;
  float _2527;
  float _2528;
  float _2529;
  float _2533;
  float _2544;
  float _2554;
  float _2555;
  float _2556;
  float _2557;
  float _2564;
  float _2567;
  float _2569;
  bool _2572;
  bool _2573;
  bool _2574;
  bool _2575;
  float _2591;
  float _2606;
  int _2607;
  float _2609;
  float _2610;
  float _2611;
  float _2648;
  float _2649;
  float _2650;
  float _2663;
  float _2664;
  float _2665;
  float _2666;
  float _2673;
  float _2674;
  float _2675;
  float _2678;
  float _2679;
  float _2687;
  int _2688;
  float _2690;
  float _2692;
  float _2695;
  float _2700;
  float _2712;
  int _2713;
  float _2715;
  float _2717;
  float _2720;
  float _2725;
  float _2734;
  float _2737;
  float _2738;
  float _2746;
  int _2747;
  float _2749;
  float _2751;
  float _2754;
  float _2759;
  float _2771;
  int _2772;
  float _2774;
  float _2776;
  float _2779;
  float _2784;
  float _2793;
  float _2796;
  float _2797;
  float _2805;
  int _2806;
  float _2808;
  float _2810;
  float _2813;
  float _2818;
  float _2830;
  int _2831;
  float _2833;
  float _2835;
  float _2838;
  float _2843;
  float _2852;
  float _2855;
  float _2858;
  float _2861;
  float _2864;
  float _2867;
  float _2870;
  float _2873;
  float _2874;
  float _2882;
  int _2883;
  float _2885;
  float _2887;
  float _2890;
  float _2895;
  float _2907;
  int _2908;
  float _2910;
  float _2912;
  float _2915;
  float _2920;
  float _2932;
  float _2935;
  float _2936;
  float _2944;
  int _2945;
  float _2947;
  float _2949;
  float _2952;
  float _2957;
  float _2969;
  int _2970;
  float _2972;
  float _2974;
  float _2977;
  float _2982;
  float _2994;
  float _2997;
  float _2998;
  float _3006;
  int _3007;
  float _3009;
  float _3011;
  float _3014;
  float _3019;
  float _3031;
  int _3032;
  float _3034;
  float _3036;
  float _3039;
  float _3044;
  float _3056;
  float _3080;
  float _3081;
  float _3082;
  float _3115;
  float _3118;
  float _3121;
  float _3140;
  float _3141;
  float _3142;
  float _3177;
  float _3180;
  float _3183;
  float _3196;
  float _3199;
  float _3202;
  float _3215;
  _13 = TEXCOORD.x + -0.015625f;
  _14 = TEXCOORD.y + -0.015625f;
  _17 = float((uint)(int)(SV_RenderTargetArrayIndex));
  if (!(cb0_074w == 1)) {
    if (!(cb0_074w == 2)) {
      if (!(cb0_074w == 3)) {
        _27 = (cb0_074w == 4);
        _38 = select(_27, 1.0f, 1.7050515413284302f);
        _39 = select(_27, 0.0f, -0.6217905879020691f);
        _40 = select(_27, 0.0f, -0.0832584798336029f);
        _41 = select(_27, 0.0f, -0.13025718927383423f);
        _42 = select(_27, 1.0f, 1.1408027410507202f);
        _43 = select(_27, 0.0f, -0.010548528283834457f);
        _44 = select(_27, 0.0f, -0.024003278464078903f);
        _45 = select(_27, 0.0f, -0.1289687603712082f);
        _46 = select(_27, 1.0f, 1.152971863746643f);
      } else {
        _38 = 0.6954522132873535f;
        _39 = 0.14067870378494263f;
        _40 = 0.16386906802654266f;
        _41 = 0.044794563204050064f;
        _42 = 0.8596711158752441f;
        _43 = 0.0955343171954155f;
        _44 = -0.005525882821530104f;
        _45 = 0.004025210160762072f;
        _46 = 1.0015007257461548f;
      }
    } else {
      _38 = 1.02579927444458f;
      _39 = -0.020052503794431686f;
      _40 = -0.0057713985443115234f;
      _41 = -0.0022350111976265907f;
      _42 = 1.0045825242996216f;
      _43 = -0.002352306619286537f;
      _44 = -0.005014004185795784f;
      _45 = -0.025293385609984398f;
      _46 = 1.0304402112960815f;
    }
  } else {
    _38 = 1.379158854484558f;
    _39 = -0.3088507056236267f;
    _40 = -0.07034677267074585f;
    _41 = -0.06933528929948807f;
    _42 = 1.0822921991348267f;
    _43 = -0.012962047010660172f;
    _44 = -0.002159259282052517f;
    _45 = -0.045465391129255295f;
    _46 = 1.0477596521377563f;
  }
  if ((uint)cb0_074z > (uint)2) {
    _56 = exp2(log2(_13 * 1.0322580337524414f) * 0.012683313339948654f);
    _57 = exp2(log2(_14 * 1.0322580337524414f) * 0.012683313339948654f);
    _58 = exp2(log2(_17 * 0.032258063554763794f) * 0.012683313339948654f);
    _103 = (exp2(log2(max(0.0f, (_56 + -0.8359375f)) / (18.8515625f - (_56 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _104 = (exp2(log2(max(0.0f, (_57 + -0.8359375f)) / (18.8515625f - (_57 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _105 = (exp2(log2(max(0.0f, (_58 + -0.8359375f)) / (18.8515625f - (_58 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _103 = ((exp2((_13 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _104 = ((exp2((_14 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _105 = ((exp2((_17 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  _108 = cb0_047x * 1.0005563497543335f;
  _122 = select((_108 <= 7000.0f), (((((2967800.0f - (4604438528.0f / cb0_047x)) / _108) + 99.11000061035156f) / _108) + 0.24406300485134125f), (((((1901800.0f - (2005284352.0f / cb0_047x)) / _108) + 247.47999572753906f) / _108) + 0.23703999817371368f));
  _136 = ((((cb0_047x * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_047x) + 0.8601177334785461f) / ((((cb0_047x * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_047x) + 1.0f);
  _146 = ((((cb0_047x * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_047x) + 0.31739872694015503f) / ((1.0f - (cb0_047x * 2.8974181986995973e-05f)) + ((cb0_047x * cb0_047x) * 1.6145605741257896e-07f));
  _151 = ((_136 * 2.0f) + 4.0f) - (_146 * 8.0f);
  _152 = (_136 * 3.0f) / _151;
  _154 = (_146 * 2.0f) / _151;
  _155 = (cb0_047x < 4000.0f);
  _160 = rsqrt(dot(float2(_136, _146), float2(_136, _146)));
  _161 = cb0_047y * 0.05000000074505806f;
  _164 = _136 - ((_161 * _146) * _160);
  _167 = ((_161 * _136) * _160) + _146;
  _172 = (4.0f - (_167 * 8.0f)) + (_164 * 2.0f);
  _178 = (((_164 * 3.0f) / _172) - _152) + select(_155, _152, _122);
  _179 = (((_167 * 2.0f) / _172) - _154) + select(_155, _154, (((_122 * 2.869999885559082f) + -0.2750000059604645f) - ((_122 * _122) * 3.0f)));
  _180 = max(_179, 1.000000013351432e-10f);
  _181 = _178 / _180;
  _184 = ((1.0f - _178) - _179) / _180;
  _194 = 0.9413792490959167f / mad(-0.16140000522136688f, _184, ((_181 * 0.8950999975204468f) + 0.266400009393692f));
  _195 = 1.0404363870620728f / mad(0.03669999912381172f, _184, (1.7135000228881836f - (_181 * 0.7501999735832214f)));
  _196 = 1.089766502380371f / mad(1.0296000242233276f, _184, ((_181 * 0.03889999911189079f) + -0.06849999725818634f));
  _197 = mad(_195, -0.7501999735832214f, 0.0f);
  _198 = mad(_195, 1.7135000228881836f, 0.0f);
  _199 = mad(_195, 0.03669999912381172f, -0.0f);
  _200 = mad(_196, 0.03889999911189079f, 0.0f);
  _201 = mad(_196, -0.06849999725818634f, 0.0f);
  _202 = mad(_196, 1.0296000242233276f, 0.0f);
  _205 = mad(0.1599626988172531f, _200, mad(-0.1470542997121811f, _197, (_194 * 0.883457362651825f)));
  _208 = mad(0.1599626988172531f, _201, mad(-0.1470542997121811f, _198, (_194 * 0.26293492317199707f)));
  _211 = mad(0.1599626988172531f, _202, mad(-0.1470542997121811f, _199, (_194 * -0.15930065512657166f)));
  _214 = mad(0.04929120093584061f, _200, mad(0.5183603167533875f, _197, (_194 * 0.38695648312568665f)));
  _217 = mad(0.04929120093584061f, _201, mad(0.5183603167533875f, _198, (_194 * 0.11516613513231277f)));
  _220 = mad(0.04929120093584061f, _202, mad(0.5183603167533875f, _199, (_194 * -0.0697740763425827f)));
  _223 = mad(0.9684867262840271f, _200, mad(0.04004279896616936f, _197, (_194 * -0.007634039502590895f)));
  _226 = mad(0.9684867262840271f, _201, mad(0.04004279896616936f, _198, (_194 * -0.0022720457054674625f)));
  _229 = mad(0.9684867262840271f, _202, mad(0.04004279896616936f, _199, (_194 * 0.0013765322510153055f)));
  _232 = mad(_211, 0.01933390088379383f, mad(_208, 0.2126729041337967f, (_205 * 0.4124563932418823f)));
  _235 = mad(_211, 0.11919199675321579f, mad(_208, 0.7151522040367126f, (_205 * 0.3575761020183563f)));
  _238 = mad(_211, 0.9503040909767151f, mad(_208, 0.07217500358819962f, (_205 * 0.18043750524520874f)));
  _241 = mad(_220, 0.01933390088379383f, mad(_217, 0.2126729041337967f, (_214 * 0.4124563932418823f)));
  _244 = mad(_220, 0.11919199675321579f, mad(_217, 0.7151522040367126f, (_214 * 0.3575761020183563f)));
  _247 = mad(_220, 0.9503040909767151f, mad(_217, 0.07217500358819962f, (_214 * 0.18043750524520874f)));
  _250 = mad(_229, 0.01933390088379383f, mad(_226, 0.2126729041337967f, (_223 * 0.4124563932418823f)));
  _253 = mad(_229, 0.11919199675321579f, mad(_226, 0.7151522040367126f, (_223 * 0.3575761020183563f)));
  _256 = mad(_229, 0.9503040909767151f, mad(_226, 0.07217500358819962f, (_223 * 0.18043750524520874f)));
  _286 = mad(mad(-0.4986107647418976f, _256, mad(-1.5373831987380981f, _247, (_238 * 3.2409698963165283f))), _105, mad(mad(-0.4986107647418976f, _253, mad(-1.5373831987380981f, _244, (_235 * 3.2409698963165283f))), _104, (mad(-0.4986107647418976f, _250, mad(-1.5373831987380981f, _241, (_232 * 3.2409698963165283f))) * _103)));
  _289 = mad(mad(0.04155505821108818f, _256, mad(1.8759675025939941f, _247, (_238 * -0.9692436456680298f))), _105, mad(mad(0.04155505821108818f, _253, mad(1.8759675025939941f, _244, (_235 * -0.9692436456680298f))), _104, (mad(0.04155505821108818f, _250, mad(1.8759675025939941f, _241, (_232 * -0.9692436456680298f))) * _103)));
  _292 = mad(mad(1.056971549987793f, _256, mad(-0.20397695899009705f, _247, (_238 * 0.05563008040189743f))), _105, mad(mad(1.056971549987793f, _253, mad(-0.20397695899009705f, _244, (_235 * 0.05563008040189743f))), _104, (mad(1.056971549987793f, _250, mad(-0.20397695899009705f, _241, (_232 * 0.05563008040189743f))) * _103)));
  _295 = mad(0.04736635088920593f, _292, mad(0.3395121395587921f, _289, (_286 * 0.613191545009613f)));
  _298 = mad(0.01345000695437193f, _292, mad(0.9163357615470886f, _289, (_286 * 0.07020691782236099f)));
  _301 = mad(0.8696067929267883f, _292, mad(0.1095672994852066f, _289, (_286 * 0.020618872717022896f)));
  CAPTURE_UNGRADED(_295, _298, _301);
  const float4 tm_flags = float4(
    cb0_046x,
    float(RENODX_WUWA_TM == 1),
    float(RENODX_WUWA_TM == 2),
    float(RENODX_WUWA_TM == 3)
  );

  // _304 = (cb0_046x == 0);
  _304 = ((uint)(tm_flags.x) == 0);
  if (_304) {
    _306 = dot(float3(_295, _298, _301), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    _310 = (_295 / _306) + -1.0f;
    _311 = (_298 / _306) + -1.0f;
    _312 = (_301 / _306) + -1.0f;
    _324 = (1.0f - exp2(((_306 * _306) * -4.0f) * cb0_075y)) * (1.0f - exp2(dot(float3(_310, _311, _312), float3(_310, _311, _312)) * -4.0f));
    _344 = (((mad(-0.06368283927440643f, _301, mad(-0.32929131388664246f, _298, (_295 * 1.370412826538086f))) - _295) * _324) + _295);
    _345 = (((mad(-0.010861567221581936f, _301, mad(1.0970908403396606f, _298, (_295 * -0.08343426138162613f))) - _298) * _324) + _298);
    _346 = (((mad(1.203694462776184f, _301, mad(-0.09862564504146576f, _298, (_295 * -0.02579325996339321f))) - _301) * _324) + _301);
  } else {
    _344 = _295;
    _345 = _298;
    _346 = _301;
  }
  _347 = dot(float3(_344, _345, _346), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _361 = cb0_052w + cb0_057w;
  _375 = cb0_051w * cb0_056w;
  _389 = cb0_050w * cb0_055w;
  _403 = cb0_049w * cb0_054w;
  _417 = cb0_048w * cb0_053w;
  _421 = _344 - _347;
  _422 = _345 - _347;
  _423 = _346 - _347;
  _480 = cb0_073w + 1.0f;
  _484 = saturate(_480 * (((cb0_052x + cb0_057x) + _361) + (((cb0_051x * cb0_056x) * _375) * exp2(log2(exp2(((cb0_049x * cb0_054x) * _403) * log2(max(0.0f, ((((cb0_048x * cb0_053x) * _417) * _421) + _347)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_050x * cb0_055x) * _389))))));
  _485 = saturate(_480 * (((cb0_052y + cb0_057y) + _361) + (((cb0_051y * cb0_056y) * _375) * exp2(log2(exp2(((cb0_049y * cb0_054y) * _403) * log2(max(0.0f, ((((cb0_048y * cb0_053y) * _417) * _422) + _347)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_050y * cb0_055y) * _389))))));
  _486 = saturate(_480 * (((cb0_052z + cb0_057z) + _361) + (((cb0_051z * cb0_056z) * _375) * exp2(log2(exp2(((cb0_049z * cb0_054z) * _403) * log2(max(0.0f, ((((cb0_048z * cb0_053z) * _417) * _423) + _347)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_050z * cb0_055z) * _389))))));
  _490 = max(_484, max(_485, _486));
  _491 = _490 - min(_484, min(_485, _486));
  if (_491 != 0.0f) {
    _494 = _491 / _490;
    if (_484 == _490) {
      _512 = ((_485 - _486) / _491);
      _513 = _494;
    } else {
      if (_485 == _490) {
        _512 = (((_486 - _484) / _491) + 2.0f);
        _513 = _494;
      } else {
        if (_486 == _490) {
          _512 = (((_484 - _485) / _491) + 4.0f);
          _513 = _494;
        } else {
          _512 = 0.0f;
          _513 = _494;
        }
      }
    }
  } else {
    _512 = 0.0f;
    _513 = 0.0f;
  }
  _515 = cb0_073z + _512;
  _516 = floor(_515);
  _517 = _515 - _516;
  _518 = 1.0f - _513;
  _520 = 1.0f - (_517 * _513);
  _523 = 1.0f - ((1.0f - _517) * _513);
  if (!(_516 == 0.0f)) {
    if (!(_516 == 1.0f)) {
      if (!(_516 == 2.0f)) {
        if (!(_516 == 3.0f)) {
          if (!(_516 == 4.0f)) {
            _535 = 1.0f;
            _536 = _518;
            _537 = _520;
          } else {
            _535 = _523;
            _536 = _518;
            _537 = 1.0f;
          }
        } else {
          _535 = _518;
          _536 = _520;
          _537 = 1.0f;
        }
      } else {
        _535 = _518;
        _536 = 1.0f;
        _537 = _523;
      }
    } else {
      _535 = _520;
      _536 = 1.0f;
      _537 = _518;
    }
  } else {
    _535 = 1.0f;
    _536 = _523;
    _537 = _518;
  }
  _543 = saturate(_347 / cb0_073x);
  _547 = (_543 * _543) * (3.0f - (_543 * 2.0f));
  _548 = 1.0f - _547;
  _557 = cb0_052w + cb0_067w;
  _566 = cb0_051w * cb0_066w;
  _575 = cb0_050w * cb0_065w;
  _584 = cb0_049w * cb0_064w;
  _593 = cb0_048w * cb0_063w;
  _654 = saturate(_480 * (((cb0_052x + cb0_067x) + _557) + (((cb0_051x * cb0_066x) * _566) * exp2(log2(exp2(((cb0_049x * cb0_064x) * _584) * log2(max(0.0f, ((((cb0_048x * cb0_063x) * _593) * _421) + _347)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_050x * cb0_065x) * _575))))));
  _655 = saturate(_480 * (((cb0_052y + cb0_067y) + _557) + (((cb0_051y * cb0_066y) * _566) * exp2(log2(exp2(((cb0_049y * cb0_064y) * _584) * log2(max(0.0f, ((((cb0_048y * cb0_063y) * _593) * _422) + _347)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_050y * cb0_065y) * _575))))));
  _656 = saturate(_480 * (((cb0_052z + cb0_067z) + _557) + (((cb0_051z * cb0_066z) * _566) * exp2(log2(exp2(((cb0_049z * cb0_064z) * _584) * log2(max(0.0f, ((((cb0_048z * cb0_063z) * _593) * _423) + _347)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_050z * cb0_065z) * _575))))));
  _660 = max(_654, max(_655, _656));
  _661 = _660 - min(_654, min(_655, _656));
  if (_661 != 0.0f) {
    _664 = _661 / _660;
    if (_654 == _660) {
      _682 = ((_655 - _656) / _661);
      _683 = _664;
    } else {
      if (_655 == _660) {
        _682 = (((_656 - _654) / _661) + 2.0f);
        _683 = _664;
      } else {
        if (_656 == _660) {
          _682 = (((_654 - _655) / _661) + 4.0f);
          _683 = _664;
        } else {
          _682 = 0.0f;
          _683 = _664;
        }
      }
    }
  } else {
    _682 = 0.0f;
    _683 = 0.0f;
  }
  _684 = cb0_073z + _682;
  _685 = floor(_684);
  _686 = _684 - _685;
  _687 = 1.0f - _683;
  _689 = 1.0f - (_686 * _683);
  _692 = 1.0f - ((1.0f - _686) * _683);
  if (!(_685 == 0.0f)) {
    if (!(_685 == 1.0f)) {
      if (!(_685 == 2.0f)) {
        if (!(_685 == 3.0f)) {
          if (!(_685 == 4.0f)) {
            _704 = 1.0f;
            _705 = _687;
            _706 = _689;
          } else {
            _704 = _692;
            _705 = _687;
            _706 = 1.0f;
          }
        } else {
          _704 = _687;
          _705 = _689;
          _706 = 1.0f;
        }
      } else {
        _704 = _687;
        _705 = 1.0f;
        _706 = _692;
      }
    } else {
      _704 = _689;
      _705 = 1.0f;
      _706 = _687;
    }
  } else {
    _704 = 1.0f;
    _705 = _692;
    _706 = _687;
  }
  _714 = saturate((_347 - cb0_073y) / (1.0f - cb0_073y));
  _718 = (_714 * _714) * (3.0f - (_714 * 2.0f));
  _727 = cb0_052w + cb0_062w;
  _736 = cb0_051w * cb0_061w;
  _745 = cb0_050w * cb0_060w;
  _754 = cb0_049w * cb0_059w;
  _763 = cb0_048w * cb0_058w;
  _824 = saturate(_480 * (((cb0_052x + cb0_062x) + _727) + (((cb0_051x * cb0_061x) * _736) * exp2(log2(exp2(((cb0_049x * cb0_059x) * _754) * log2(max(0.0f, ((((cb0_048x * cb0_058x) * _763) * _421) + _347)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_050x * cb0_060x) * _745))))));
  _825 = saturate(_480 * (((cb0_052y + cb0_062y) + _727) + (((cb0_051y * cb0_061y) * _736) * exp2(log2(exp2(((cb0_049y * cb0_059y) * _754) * log2(max(0.0f, ((((cb0_048y * cb0_058y) * _763) * _422) + _347)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_050y * cb0_060y) * _745))))));
  _826 = saturate(_480 * (((cb0_052z + cb0_062z) + _727) + (((cb0_051z * cb0_061z) * _736) * exp2(log2(exp2(((cb0_049z * cb0_059z) * _754) * log2(max(0.0f, ((((cb0_048z * cb0_058z) * _763) * _423) + _347)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_050z * cb0_060z) * _745))))));
  _830 = max(_824, max(_825, _826));
  _831 = _830 - min(_824, min(_825, _826));
  if (_831 != 0.0f) {
    _834 = _831 / _830;
    if (_824 == _830) {
      _852 = ((_825 - _826) / _831);
      _853 = _834;
    } else {
      if (_825 == _830) {
        _852 = (((_826 - _824) / _831) + 2.0f);
        _853 = _834;
      } else {
        if (_826 == _830) {
          _852 = (((_824 - _825) / _831) + 4.0f);
          _853 = _834;
        } else {
          _852 = 0.0f;
          _853 = _834;
        }
      }
    }
  } else {
    _852 = 0.0f;
    _853 = 0.0f;
  }
  _854 = cb0_073z + _852;
  _855 = floor(_854);
  _856 = _854 - _855;
  _857 = 1.0f - _853;
  _859 = 1.0f - (_856 * _853);
  _862 = 1.0f - ((1.0f - _856) * _853);
  if (!(_855 == 0.0f)) {
    if (!(_855 == 1.0f)) {
      if (!(_855 == 2.0f)) {
        if (!(_855 == 3.0f)) {
          if (!(_855 == 4.0f)) {
            _874 = 1.0f;
            _875 = _857;
            _876 = _859;
          } else {
            _874 = _862;
            _875 = _857;
            _876 = 1.0f;
          }
        } else {
          _874 = _857;
          _875 = _859;
          _876 = 1.0f;
        }
      } else {
        _874 = _857;
        _875 = 1.0f;
        _876 = _862;
      }
    } else {
      _874 = _859;
      _875 = 1.0f;
      _876 = _857;
    }
  } else {
    _874 = 1.0f;
    _875 = _862;
    _876 = _857;
  }
  _881 = _830 * (_547 - _718);
  _889 = (((_704 * _660) * _718) + ((_535 * _490) * _548)) + (_881 * _874);
  _891 = (((_705 * _660) * _718) + ((_536 * _490) * _548)) + (_881 * _875);
  _893 = (((_706 * _660) * _718) + ((_537 * _490) * _548)) + (_881 * _876);
  _919 = dot(float3(_889, _891, _893), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _983 = saturate(_480 * ((cb0_072x + cb0_072w) + ((cb0_071x * cb0_071w) * exp2(log2(exp2((cb0_069x * cb0_069w) * log2(max(0.0f, (((cb0_068x * cb0_068w) * (_889 - _919)) + _919)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / (cb0_070x * cb0_070w))))));
  _984 = saturate(_480 * ((cb0_072y + cb0_072w) + ((cb0_071y * cb0_071w) * exp2(log2(exp2((cb0_069y * cb0_069w) * log2(max(0.0f, (((cb0_068y * cb0_068w) * (_891 - _919)) + _919)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / (cb0_070y * cb0_070w))))));
  _985 = saturate(_480 * ((cb0_072z + cb0_072w) + ((cb0_071z * cb0_071w) * exp2(log2(exp2((cb0_069z * cb0_069w) * log2(max(0.0f, (((cb0_068z * cb0_068w) * (_893 - _919)) + _919)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / (cb0_070z * cb0_070w))))));
  _989 = max(_983, max(_984, _985));
  _990 = _989 - min(_983, min(_984, _985));
  if (_990 != 0.0f) {
    _993 = _990 / _989;
    if (_983 == _989) {
      _1011 = ((_984 - _985) / _990);
      _1012 = _993;
    } else {
      if (_984 == _989) {
        _1011 = (((_985 - _983) / _990) + 2.0f);
        _1012 = _993;
      } else {
        if (_985 == _989) {
          _1011 = (((_983 - _984) / _990) + 4.0f);
          _1012 = _993;
        } else {
          _1011 = 0.0f;
          _1012 = _993;
        }
      }
    }
  } else {
    _1011 = 0.0f;
    _1012 = 0.0f;
  }
  _1013 = cb0_073z + _1011;
  _1014 = floor(_1013);
  _1015 = _1013 - _1014;
  _1016 = 1.0f - _1012;
  _1018 = 1.0f - (_1015 * _1012);
  _1021 = 1.0f - ((1.0f - _1015) * _1012);
  if (!(_1014 == 0.0f)) {
    if (!(_1014 == 1.0f)) {
      if (!(_1014 == 2.0f)) {
        if (!(_1014 == 3.0f)) {
          if (!(_1014 == 4.0f)) {
            _1033 = 1.0f;
            _1034 = _1016;
            _1035 = _1018;
          } else {
            _1033 = _1021;
            _1034 = _1016;
            _1035 = 1.0f;
          }
        } else {
          _1033 = _1016;
          _1034 = _1018;
          _1035 = 1.0f;
        }
      } else {
        _1033 = _1016;
        _1034 = 1.0f;
        _1035 = _1021;
      }
    } else {
      _1033 = _1018;
      _1034 = 1.0f;
      _1035 = _1016;
    }
  } else {
    _1033 = 1.0f;
    _1034 = _1021;
    _1035 = _1016;
  }
  _1036 = _1033 * _989;
  _1037 = _1034 * _989;
  _1038 = _1035 * _989;
  _1041 = mad(-0.0832584798336029f, _1038, mad(-0.6217905879020691f, _1037, (_1036 * 1.7050515413284302f)));
  _1044 = mad(-0.010548528283834457f, _1038, mad(1.1408027410507202f, _1037, (_1036 * -0.13025718927383423f)));
  _1047 = mad(1.152971863746643f, _1038, mad(-0.1289687603712082f, _1037, (_1036 * -0.024003278464078903f)));
  _1063 = ((mad(0.061360642313957214f, _1038, mad(-4.540197551250458e-09f, _1037, (_1036 * 0.9386394023895264f))) - _1036) * cb0_075x) + _1036;
  _1064 = ((mad(0.169205904006958f, _1038, mad(0.8307942152023315f, _1037, (_1036 * 6.775371730327606e-08f))) - _1037) * cb0_075x) + _1037;
  _1065 = (mad(-2.3283064365386963e-10f, _1037, (_1036 * -9.313225746154785e-10f)) * cb0_075x) + _1038;
  // if (((cb0_046z | cb0_046y) | cb0_046w) == 0) {
  if ((((uint)(tm_flags.z) | (uint)(tm_flags.y)) | (uint)(tm_flags.w)) == 0) {
    _1075 = mad(0.16386905312538147f, _1065, mad(0.14067868888378143f, _1064, (_1063 * 0.6954522132873535f)));
    _1078 = mad(0.0955343246459961f, _1065, mad(0.8596711158752441f, _1064, (_1063 * 0.044794581830501556f)));
    _1081 = mad(1.0015007257461548f, _1065, mad(0.004025210160762072f, _1064, (_1063 * -0.005525882821530104f)));
    _1085 = max(max(_1075, _1078), _1081);
    _1090 = (max(_1085, 1.000000013351432e-10f) - max(min(min(_1075, _1078), _1081), 1.000000013351432e-10f)) / max(_1085, 0.009999999776482582f);
    _1103 = ((_1078 + _1075) + _1081) + (sqrt((((_1081 - _1078) * _1081) + ((_1078 - _1075) * _1078)) + ((_1075 - _1081) * _1075)) * 1.75f);
    _1104 = _1103 * 0.3333333432674408f;
    _1105 = _1090 + -0.4000000059604645f;
    _1106 = _1105 * 5.0f;
    _1110 = max((1.0f - abs(_1105 * 2.5f)), 0.0f);
    _1121 = ((float((int)(((int)(uint)((bool)(_1106 > 0.0f))) - ((int)(uint)((bool)(_1106 < 0.0f))))) * (1.0f - (_1110 * _1110))) + 1.0f) * 0.02500000037252903f;
    if (_1104 > 0.0533333346247673f) {
      if (_1104 < 0.1599999964237213f) {
        _1130 = (((0.23999999463558197f / _1103) + -0.5f) * _1121);
      } else {
        _1130 = 0.0f;
      }
    } else {
      _1130 = _1121;
    }
    _1131 = _1130 + 1.0f;
    _1132 = _1131 * _1075;
    _1133 = _1131 * _1078;
    _1134 = _1131 * _1081;
    if (!((bool)(_1132 == _1133) && (bool)(_1133 == _1134))) {
      _1141 = ((_1132 * 2.0f) - _1133) - _1134;
      _1144 = ((_1078 - _1081) * 1.7320507764816284f) * _1131;
      _1146 = atan(_1144 / _1141);
      _1149 = (_1141 < 0.0f);
      _1150 = (_1141 == 0.0f);
      _1151 = (_1144 >= 0.0f);
      _1152 = (_1144 < 0.0f);
      _1163 = select((_1151 && _1150), 90.0f, select((_1152 && _1150), -90.0f, (select((_1152 && _1149), (_1146 + -3.1415927410125732f), select((_1151 && _1149), (_1146 + 3.1415927410125732f), _1146)) * 57.2957763671875f)));
    } else {
      _1163 = 0.0f;
    }
    _1168 = min(max(select((_1163 < 0.0f), (_1163 + 360.0f), _1163), 0.0f), 360.0f);
    if (_1168 < -180.0f) {
      _1177 = (_1168 + 360.0f);
    } else {
      if (_1168 > 180.0f) {
        _1177 = (_1168 + -360.0f);
      } else {
        _1177 = _1168;
      }
    }
    _1181 = saturate(1.0f - abs(_1177 * 0.014814814552664757f));
    _1185 = (_1181 * _1181) * (3.0f - (_1181 * 2.0f));
    _1191 = ((_1185 * _1185) * ((_1090 * 0.18000000715255737f) * (0.029999999329447746f - _1132))) + _1132;
    _1201 = max(0.0f, mad(-0.21492856740951538f, _1134, mad(-0.2365107536315918f, _1133, (_1191 * 1.4514392614364624f))));
    _1202 = max(0.0f, mad(-0.09967592358589172f, _1134, mad(1.17622971534729f, _1133, (_1191 * -0.07655377686023712f))));
    _1203 = max(0.0f, mad(0.9977163076400757f, _1134, mad(-0.006032449658960104f, _1133, (_1191 * 0.008316148072481155f))));
    _1204 = dot(float3(_1201, _1202, _1203), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    _1218 = (cb0_036w + 1.0f) - cb0_036y;
    _1221 = cb0_037x + 1.0f;
    _1223 = _1221 - cb0_036z;
    if (cb0_036y > 0.800000011920929f) {
      _1241 = (((0.8199999928474426f - cb0_036y) / cb0_036x) + -0.7447274923324585f);
    } else {
      _1232 = (cb0_036w + 0.18000000715255737f) / _1218;
      _1241 = (-0.7447274923324585f - ((log2(_1232 / (2.0f - _1232)) * 0.3465735912322998f) * (_1218 / cb0_036x)));
    }
    _1244 = ((1.0f - cb0_036y) / cb0_036x) - _1241;
    _1246 = (cb0_036z / cb0_036x) - _1244;
    _1250 = log2(lerp(_1204, _1201, 0.9599999785423279f)) * 0.3010300099849701f;
    _1251 = log2(lerp(_1204, _1202, 0.9599999785423279f)) * 0.3010300099849701f;
    _1252 = log2(lerp(_1204, _1203, 0.9599999785423279f)) * 0.3010300099849701f;
    _1256 = cb0_036x * (_1250 + _1244);
    _1257 = cb0_036x * (_1251 + _1244);
    _1258 = cb0_036x * (_1252 + _1244);
    _1259 = _1218 * 2.0f;
    _1261 = (cb0_036x * -2.0f) / _1218;
    _1262 = _1250 - _1241;
    _1263 = _1251 - _1241;
    _1264 = _1252 - _1241;
    _1283 = _1223 * 2.0f;
    _1285 = (cb0_036x * 2.0f) / _1223;
    _1310 = select((_1250 < _1241), ((_1259 / (exp2((_1262 * 1.4426950216293335f) * _1261) + 1.0f)) - cb0_036w), _1256);
    _1311 = select((_1251 < _1241), ((_1259 / (exp2((_1263 * 1.4426950216293335f) * _1261) + 1.0f)) - cb0_036w), _1257);
    _1312 = select((_1252 < _1241), ((_1259 / (exp2((_1264 * 1.4426950216293335f) * _1261) + 1.0f)) - cb0_036w), _1258);
    _1319 = _1246 - _1241;
    _1323 = saturate(_1262 / _1319);
    _1324 = saturate(_1263 / _1319);
    _1325 = saturate(_1264 / _1319);
    _1326 = (_1246 < _1241);
    _1330 = select(_1326, (1.0f - _1323), _1323);
    _1331 = select(_1326, (1.0f - _1324), _1324);
    _1332 = select(_1326, (1.0f - _1325), _1325);
    _1351 = (((_1330 * _1330) * (select((_1250 > _1246), (_1221 - (_1283 / (exp2(((_1250 - _1246) * 1.4426950216293335f) * _1285) + 1.0f))), _1256) - _1310)) * (3.0f - (_1330 * 2.0f))) + _1310;
    _1352 = (((_1331 * _1331) * (select((_1251 > _1246), (_1221 - (_1283 / (exp2(((_1251 - _1246) * 1.4426950216293335f) * _1285) + 1.0f))), _1257) - _1311)) * (3.0f - (_1331 * 2.0f))) + _1311;
    _1353 = (((_1332 * _1332) * (select((_1252 > _1246), (_1221 - (_1283 / (exp2(((_1252 - _1246) * 1.4426950216293335f) * _1285) + 1.0f))), _1258) - _1312)) * (3.0f - (_1332 * 2.0f))) + _1312;
    _1354 = dot(float3(_1351, _1352, _1353), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    _1378 = ((cb0_075z * (max(0.0f, (lerp(_1354, _1351, 0.9300000071525574f))) - _1063)) + _1063);
    _1379 = ((cb0_075z * (max(0.0f, (lerp(_1354, _1352, 0.9300000071525574f))) - _1064)) + _1064);
    _1380 = ((cb0_075z * (max(0.0f, (lerp(_1354, _1353, 0.9300000071525574f))) - _1065)) + _1065);
  } else {
    _1378 = _1063;
    _1379 = _1064;
    _1380 = _1065;
  }
  _1396 = ((mad(-0.06537103652954102f, _1380, mad(1.451815478503704e-06f, _1379, (_1378 * 1.065374732017517f))) - _1378) * cb0_075x) + _1378;
  _1397 = ((mad(-0.20366770029067993f, _1380, mad(1.2036634683609009f, _1379, (_1378 * -2.57161445915699e-07f))) - _1379) * cb0_075x) + _1379;
  _1398 = ((mad(0.9999996423721313f, _1380, mad(2.0954757928848267e-08f, _1379, (_1378 * 1.862645149230957e-08f))) - _1380) * cb0_075x) + _1380;
  [branch]
  if (!_304) {
    _1441 = 1.0f / (dot(float3(_1041, _1044, _1047), float3(cb0_033x, cb0_033y, cb0_033z)) + 1.0f);
    _1451 = max(0.0f, (((_1441 * cb0_035x) + cb0_034x) * dot(float3(_1041, _1044, _1047), float3(cb0_028x, cb0_028y, cb0_028z))));
    _1452 = max(0.0f, (((_1441 * cb0_035y) + cb0_034y) * dot(float3(_1041, _1044, _1047), float3(cb0_029x, cb0_029y, cb0_029z))));
    _1453 = max(0.0f, (((_1441 * cb0_035z) + cb0_034z) * dot(float3(_1041, _1044, _1047), float3(cb0_030x, cb0_030y, cb0_030z))));
    _1459 = max(0.0f, (cb0_031x - _1451));
    _1460 = max(0.0f, (cb0_031x - _1452));
    _1461 = max(0.0f, (cb0_031x - _1453));
    _1463 = max(_1451, cb0_031z);
    _1464 = max(_1452, cb0_031z);
    _1465 = max(_1453, cb0_031z);
    _1523 = (((((((cb0_032x * _1463) + cb0_032y) * (1.0f / (cb0_031w + _1463))) + -0.0020000000949949026f) + (cb0_030w * min(max(_1451, cb0_031x), cb0_031z))) + ((cb0_028w * _1459) * (1.0f / (cb0_031y + _1459)))) + cb0_029w);
    _1524 = ((((((1.0f / (cb0_031w + _1464)) * ((cb0_032x * _1464) + cb0_032y)) + -0.0020000000949949026f) + (cb0_030w * min(max(_1452, cb0_031x), cb0_031z))) + ((cb0_028w * _1460) * (1.0f / (cb0_031y + _1460)))) + cb0_029w);
    _1525 = ((((((1.0f / (cb0_031w + _1465)) * ((cb0_032x * _1465) + cb0_032y)) + -0.0020000000949949026f) + (cb0_030w * min(max(_1453, cb0_031x), cb0_031z))) + ((cb0_028w * _1461) * (1.0f / (cb0_031y + _1461)))) + cb0_029w);
  } else {
    _1523 = max(0.0f, mad(-0.0832584798336029f, _1398, mad(-0.6217905879020691f, _1397, (_1396 * 1.7050515413284302f))));
    _1524 = max(0.0f, mad(-0.010548528283834457f, _1398, mad(1.1408027410507202f, _1397, (_1396 * -0.13025718927383423f))));
    _1525 = max(0.0f, mad(1.152971863746643f, _1398, mad(-0.1289687603712082f, _1397, (_1396 * -0.024003278464078903f))));
  }

  float lut_sampling_scale = wuwa::lut::PrepareLinearInput(_1523, _1524, _1525);

  _1526 = _1523;
  _1527 = _1524;
  _1528 = _1525;
  if (_1526 < 0.0031306699384003878f) {
    _1539 = (_1526 * 12.920000076293945f);
  } else {
    _1539 = (((pow(_1526, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1527 < 0.0031306699384003878f) {
    _1550 = (_1527 * 12.920000076293945f);
  } else {
    _1550 = (((pow(_1527, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1528 < 0.0031306699384003878f) {
    _1561 = (_1528 * 12.920000076293945f);
  } else {
    _1561 = (((pow(_1528, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }

  float lut_sample_max_channel = wuwa::lut::NormalizeEncodedInput(_1539, _1550, _1561);

  _1565 = (_1550 * 0.9375f) + 0.03125f;
  _1573 = _1561 * 15.0f;
  _1574 = floor(_1573);
  _1575 = _1573 - _1574;
  _1577 = (_1574 + ((_1539 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1578 = t1.Sample(s1, float2(_1577, _1565));
  _1582 = _1577 + 0.0625f;
  _1583 = t1.Sample(s1, float2(_1582, _1565));
  _1604 = t2.Sample(s2, float2(_1577, _1565));
  _1608 = t2.Sample(s2, float2(_1582, _1565));
  _1629 = t3.Sample(s3, float2(_1577, _1565));
  _1633 = t3.Sample(s3, float2(_1582, _1565));
  _1649 = ((((lerp(_1578.x, _1583.x, _1575)) * cb0_041x) + (cb0_040x * _1539)) + ((lerp(_1604.x, _1608.x, _1575)) * cb0_042x)) + ((lerp(_1629.x, _1633.x, _1575)) * cb0_043x);
  _1650 = ((((lerp(_1578.y, _1583.y, _1575)) * cb0_041x) + (cb0_040x * _1550)) + ((lerp(_1604.y, _1608.y, _1575)) * cb0_042x)) + ((lerp(_1629.y, _1633.y, _1575)) * cb0_043x);
  _1651 = ((((lerp(_1578.z, _1583.z, _1575)) * cb0_041x) + (cb0_040x * _1561)) + ((lerp(_1604.z, _1608.z, _1575)) * cb0_042x)) + ((lerp(_1629.z, _1633.z, _1575)) * cb0_043x);
  _1654 = t0.Sample(s0, float2(_1577, _1565));
  _1658 = t0.Sample(s0, float2(_1582, _1565));
  _1676 = cb0_038w * cb0_039z;
  _1683 = max(6.103519990574569e-05f, ((_1676 * ((_1654.x - _1649) + ((_1658.x - _1654.x) * _1575))) + _1649));
  _1684 = max(6.103519990574569e-05f, ((_1676 * ((_1654.y - _1650) + ((_1658.y - _1654.y) * _1575))) + _1650));
  _1685 = max(6.103519990574569e-05f, ((_1676 * ((_1654.z - _1651) + ((_1658.z - _1654.z) * _1575))) + _1651));

  wuwa::lut::ApplySampleMaxChannel(_1683, _1684, _1685, lut_sample_max_channel);
  _1707 = select((_1683 > 0.040449999272823334f), exp2(log2((_1683 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1683 * 0.07739938050508499f));
  _1708 = select((_1684 > 0.040449999272823334f), exp2(log2((_1684 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1684 * 0.07739938050508499f));
  _1709 = select((_1685 > 0.040449999272823334f), exp2(log2((_1685 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1685 * 0.07739938050508499f));

  wuwa::lut::ApplyInverseSamplingScale(_1707, _1708, _1709, lut_sampling_scale);

  wuwa::lut::PreserveReferenceLightness(_1707, _1708, _1709, float3(_1523, _1524, _1525));
  _1735 = cb0_044y * (((cb0_026y + (cb0_026x * _1707)) * _1707) + cb0_026z);
  _1736 = cb0_044z * (((cb0_026y + (cb0_026x * _1708)) * _1708) + cb0_026z);
  _1737 = cb0_044w * (((cb0_026y + (cb0_026x * _1709)) * _1709) + cb0_026z);
  _1744 = ((cb0_045x - _1735) * cb0_045w) + _1735;
  _1745 = ((cb0_045y - _1736) * cb0_045w) + _1736;
  _1746 = ((cb0_045z - _1737) * cb0_045w) + _1737;

  wuwa::lut::ApplyLutStrength(_1744, _1745, _1746, ungraded);
  _1747 = cb0_044y * _1041;
  _1748 = cb0_044z * _1044;
  _1749 = cb0_044w * _1047;
  _1756 = ((cb0_045x - _1747) * cb0_045w) + _1747;
  _1757 = ((cb0_045y - _1748) * cb0_045w) + _1748;
  _1758 = ((cb0_045z - _1749) * cb0_045w) + _1749;
  _1770 = exp2(log2(max(0.0f, _1744)) * cb0_027y);
  _1771 = exp2(log2(max(0.0f, _1745)) * cb0_027y);
  _1772 = exp2(log2(max(0.0f, _1746)) * cb0_027y);

  SV_Target.rgb = GenerateLUTOutput(float3(_1770, _1771, _1772));
  SV_Target.a = 0;
  return SV_Target;
  [branch]
  if (cb0_074z == 0) {
    if (_1770 < 0.0031306699384003878f) {
      _1787 = (_1770 * 12.920000076293945f);
    } else {
      _1787 = (((pow(_1770, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1771 < 0.0031306699384003878f) {
      _1798 = (_1771 * 12.920000076293945f);
    } else {
      _1798 = (((pow(_1771, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_1772 < 0.0031306699384003878f) {
      _3226 = _1787;
      _3227 = _1798;
      _3228 = (_1772 * 12.920000076293945f);
    } else {
      _3226 = _1787;
      _3227 = _1798;
      _3228 = (((pow(_1772, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    if (cb0_074z == 1) {
      _1813 = mad(0.04736635088920593f, _1772, mad(0.3395121395587921f, _1771, (_1770 * 0.613191545009613f)));
      _1816 = mad(0.01345000695437193f, _1772, mad(0.9163357615470886f, _1771, (_1770 * 0.07020691782236099f)));
      _1819 = mad(0.8696067929267883f, _1772, mad(0.1095672994852066f, _1771, (_1770 * 0.020618872717022896f)));
      _1829 = max(6.103519990574569e-05f, mad(_40, _1819, mad(_39, _1816, (_1813 * _38))));
      _1830 = max(6.103519990574569e-05f, mad(_43, _1819, mad(_42, _1816, (_1813 * _41))));
      _1831 = max(6.103519990574569e-05f, mad(_46, _1819, mad(_45, _1816, (_1813 * _44))));
      _3226 = min((_1829 * 4.5f), ((exp2(log2(max(_1829, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3227 = min((_1830 * 4.5f), ((exp2(log2(max(_1830, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3228 = min((_1831 * 4.5f), ((exp2(log2(max(_1831, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      _1858 = (cb0_074z == 5);
      if ((bool)(cb0_074z == 3) || _1858) {
        _1861 = _1757 * 3.0f;
        _1862 = _1758 * 3.0f;
        _1865 = mad(0.17733481526374817f, _1862, mad(0.38297808170318604f, _1861, (_1756 * 1.31910240650177f)));
        _1868 = mad(0.09676162153482437f, _1862, mad(0.8134231567382812f, _1861, (_1756 * 0.2693769633769989f)));
        _1871 = mad(0.870704174041748f, _1862, mad(0.11154405772686005f, _1861, (_1756 * 0.05263196676969528f)));
        _1875 = max(max(_1865, _1868), _1871);
        _1880 = (max(_1875, 1.000000013351432e-10f) - max(min(min(_1865, _1868), _1871), 1.000000013351432e-10f)) / max(_1875, 0.009999999776482582f);
        _1893 = ((_1868 + _1865) + _1871) + (sqrt((((_1871 - _1868) * _1871) + ((_1868 - _1865) * _1868)) + ((_1865 - _1871) * _1865)) * 1.75f);
        _1894 = _1893 * 0.3333333432674408f;
        _1895 = _1880 + -0.4000000059604645f;
        _1896 = _1895 * 5.0f;
        _1900 = max((1.0f - abs(_1895 * 2.5f)), 0.0f);
        _1911 = ((float((int)(((int)(uint)((bool)(_1896 > 0.0f))) - ((int)(uint)((bool)(_1896 < 0.0f))))) * (1.0f - (_1900 * _1900))) + 1.0f) * 0.02500000037252903f;
        if (_1894 > 0.0533333346247673f) {
          if (_1894 < 0.1599999964237213f) {
            _1920 = (((0.23999999463558197f / _1893) + -0.5f) * _1911);
          } else {
            _1920 = 0.0f;
          }
        } else {
          _1920 = _1911;
        }
        _1921 = _1920 + 1.0f;
        _1922 = _1921 * _1865;
        _1923 = _1921 * _1868;
        _1924 = _1921 * _1871;
        if (!((bool)(_1922 == _1923) && (bool)(_1923 == _1924))) {
          _1931 = ((_1922 * 2.0f) - _1923) - _1924;
          _1934 = ((_1868 - _1871) * 1.7320507764816284f) * _1921;
          _1936 = atan(_1934 / _1931);
          _1939 = (_1931 < 0.0f);
          _1940 = (_1931 == 0.0f);
          _1941 = (_1934 >= 0.0f);
          _1942 = (_1934 < 0.0f);
          _1953 = select((_1941 && _1940), 90.0f, select((_1942 && _1940), -90.0f, (select((_1942 && _1939), (_1936 + -3.1415927410125732f), select((_1941 && _1939), (_1936 + 3.1415927410125732f), _1936)) * 57.2957763671875f)));
        } else {
          _1953 = 0.0f;
        }
        _1958 = min(max(select((_1953 < 0.0f), (_1953 + 360.0f), _1953), 0.0f), 360.0f);
        if (_1958 < -180.0f) {
          _1967 = (_1958 + 360.0f);
        } else {
          if (_1958 > 180.0f) {
            _1967 = (_1958 + -360.0f);
          } else {
            _1967 = _1958;
          }
        }
        if ((bool)(_1967 > -67.5f) && (bool)(_1967 < 67.5f)) {
          _1973 = (_1967 + 67.5f) * 0.029629629105329514f;
          _1974 = int(_1973);
          _1976 = _1973 - float((int)(_1974));
          _1977 = _1976 * _1976;
          _1978 = _1977 * _1976;
          if (_1974 == 3) {
            _2006 = (((0.1666666716337204f - (_1976 * 0.5f)) + (_1977 * 0.5f)) - (_1978 * 0.1666666716337204f));
          } else {
            if (_1974 == 2) {
              _2006 = ((0.6666666865348816f - _1977) + (_1978 * 0.5f));
            } else {
              if (_1974 == 1) {
                _2006 = (((_1978 * -0.5f) + 0.1666666716337204f) + ((_1977 + _1976) * 0.5f));
              } else {
                _2006 = select((_1974 == 0), (_1978 * 0.1666666716337204f), 0.0f);
              }
            }
          }
        } else {
          _2006 = 0.0f;
        }
        _2015 = min(max(((((_1880 * 0.27000001072883606f) * (0.029999999329447746f - _1922)) * _2006) + _1922), 0.0f), 65535.0f);
        _2016 = min(max(_1923, 0.0f), 65535.0f);
        _2017 = min(max(_1924, 0.0f), 65535.0f);
        _2030 = min(max(mad(-0.21492856740951538f, _2017, mad(-0.2365107536315918f, _2016, (_2015 * 1.4514392614364624f))), 0.0f), 65535.0f);
        _2031 = min(max(mad(-0.09967592358589172f, _2017, mad(1.17622971534729f, _2016, (_2015 * -0.07655377686023712f))), 0.0f), 65535.0f);
        _2032 = min(max(mad(0.9977163076400757f, _2017, mad(-0.006032449658960104f, _2016, (_2015 * 0.008316148072481155f))), 0.0f), 65535.0f);
        _2033 = dot(float3(_2030, _2031, _2032), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        _2040 = ((_2030 - _2033) * 0.9599999785423279f) + _2033;
        _2041 = ((_2031 - _2033) * 0.9599999785423279f) + _2033;
        _2042 = ((_2032 - _2033) * 0.9599999785423279f) + _2033;
        _2045 = log2(select((_2040 <= 0.0f), 6.103515625e-05f, _2040));
        _2046 = _2045 * 0.3010300099849701f;
        if (_2046 > -5.2601776123046875f) {
          if ((bool)(_2046 > -5.2601776123046875f) && (bool)(_2046 < -0.7447274923324585f)) {
            _2054 = (_2045 * 0.19999998807907104f) + 3.494786262512207f;
            _2055 = int(_2054);
            _2057 = _2054 - float((int)(_2055));
            _2059 = _global_0[_2055];
            _2062 = _global_0[(_2055 + 1)];
            _2067 = _2059 * 0.5f;
            _2099 = dot(float3((_2057 * _2057), _2057, 1.0f), float3(mad((_global_0[(_2055 + 2)]), 0.5f, mad(_2062, -1.0f, _2067)), (_2062 - _2059), mad(_2062, 0.5f, _2067)));
          } else {
            if ((bool)(_2046 >= -0.7447274923324585f) && (bool)(_2046 < 4.673812389373779f)) {
              _2079 = (_2045 * 0.1666666567325592f) + 0.4123218357563019f;
              _2080 = int(_2079);
              _2082 = _2079 - float((int)(_2080));
              _2084 = _global_1[_2080];
              _2087 = _global_1[(_2080 + 1)];
              _2092 = _2084 * 0.5f;
              _2099 = dot(float3((_2082 * _2082), _2082, 1.0f), float3(mad((_global_1[(_2080 + 2)]), 0.5f, mad(_2087, -1.0f, _2092)), (_2087 - _2084), mad(_2087, 0.5f, _2092)));
            } else {
              _2099 = 4.0f;
            }
          }
        } else {
          _2099 = -4.0f;
        }
        _2101 = exp2(_2099 * 3.321928024291992f);
        _2104 = log2(select((_2041 <= 0.0f), 6.103515625e-05f, _2041));
        _2105 = _2104 * 0.3010300099849701f;
        if (_2105 > -5.2601776123046875f) {
          if ((bool)(_2105 > -5.2601776123046875f) && (bool)(_2105 < -0.7447274923324585f)) {
            _2113 = (_2104 * 0.19999998807907104f) + 3.494786262512207f;
            _2114 = int(_2113);
            _2116 = _2113 - float((int)(_2114));
            _2118 = _global_0[_2114];
            _2121 = _global_0[(_2114 + 1)];
            _2126 = _2118 * 0.5f;
            _2158 = dot(float3((_2116 * _2116), _2116, 1.0f), float3(mad((_global_0[(_2114 + 2)]), 0.5f, mad(_2121, -1.0f, _2126)), (_2121 - _2118), mad(_2121, 0.5f, _2126)));
          } else {
            if ((bool)(_2105 >= -0.7447274923324585f) && (bool)(_2105 < 4.673812389373779f)) {
              _2138 = (_2104 * 0.1666666567325592f) + 0.4123218357563019f;
              _2139 = int(_2138);
              _2141 = _2138 - float((int)(_2139));
              _2143 = _global_1[_2139];
              _2146 = _global_1[(_2139 + 1)];
              _2151 = _2143 * 0.5f;
              _2158 = dot(float3((_2141 * _2141), _2141, 1.0f), float3(mad((_global_1[(_2139 + 2)]), 0.5f, mad(_2146, -1.0f, _2151)), (_2146 - _2143), mad(_2146, 0.5f, _2151)));
            } else {
              _2158 = 4.0f;
            }
          }
        } else {
          _2158 = -4.0f;
        }
        _2160 = exp2(_2158 * 3.321928024291992f);
        _2163 = log2(select((_2042 <= 0.0f), 6.103515625e-05f, _2042));
        _2164 = _2163 * 0.3010300099849701f;
        if (_2164 > -5.2601776123046875f) {
          if ((bool)(_2164 > -5.2601776123046875f) && (bool)(_2164 < -0.7447274923324585f)) {
            _2172 = (_2163 * 0.19999998807907104f) + 3.494786262512207f;
            _2173 = int(_2172);
            _2175 = _2172 - float((int)(_2173));
            _2177 = _global_0[_2173];
            _2180 = _global_0[(_2173 + 1)];
            _2185 = _2177 * 0.5f;
            _2217 = dot(float3((_2175 * _2175), _2175, 1.0f), float3(mad((_global_0[(_2173 + 2)]), 0.5f, mad(_2180, -1.0f, _2185)), (_2180 - _2177), mad(_2180, 0.5f, _2185)));
          } else {
            if ((bool)(_2164 >= -0.7447274923324585f) && (bool)(_2164 < 4.673812389373779f)) {
              _2197 = (_2163 * 0.1666666567325592f) + 0.4123218357563019f;
              _2198 = int(_2197);
              _2200 = _2197 - float((int)(_2198));
              _2202 = _global_1[_2198];
              _2205 = _global_1[(_2198 + 1)];
              _2210 = _2202 * 0.5f;
              _2217 = dot(float3((_2200 * _2200), _2200, 1.0f), float3(mad((_global_1[(_2198 + 2)]), 0.5f, mad(_2205, -1.0f, _2210)), (_2205 - _2202), mad(_2205, 0.5f, _2210)));
            } else {
              _2217 = 4.0f;
            }
          }
        } else {
          _2217 = -4.0f;
        }
        _2219 = exp2(_2217 * 3.321928024291992f);
        _2222 = mad(0.16386906802654266f, _2219, mad(0.14067870378494263f, _2160, (_2101 * 0.6954522132873535f)));
        _2225 = mad(0.0955343171954155f, _2219, mad(0.8596711158752441f, _2160, (_2101 * 0.044794563204050064f)));
        _2228 = mad(1.0015007257461548f, _2219, mad(0.004025210160762072f, _2160, (_2101 * -0.005525882821530104f)));
        _2231 = mad(-0.21492856740951538f, _2228, mad(-0.2365107536315918f, _2225, (_2222 * 1.4514392614364624f)));
        _2234 = mad(-0.09967592358589172f, _2228, mad(1.17622971534729f, _2225, (_2222 * -0.07655377686023712f)));
        _2237 = mad(0.9977163076400757f, _2228, mad(-0.006032449658960104f, _2225, (_2222 * 0.008316148072481155f)));
        _2240 = log2(select((_2231 <= 0.0f), 9.999999747378752e-05f, _2231));
        _2241 = _2240 * 0.3010300099849701f;
        if (_2241 > -3.848327875137329f) {
          if ((bool)(_2241 > -3.848327875137329f) && (bool)(_2241 < 0.6812411546707153f)) {
            _2252 = (_2240 + 12.783867835998535f) * 0.46521204710006714f;
            _2253 = int(_2252);
            _2255 = _2252 - float((int)(_2253));
            _2257 = _global_2[_2253];
            _2260 = _global_2[(_2253 + 1)];
            _2265 = _2257 * 0.5f;
            _2300 = dot(float3((_2255 * _2255), _2255, 1.0f), float3(mad((_global_2[(_2253 + 2)]), 0.5f, mad(_2260, -1.0f, _2265)), (_2260 - _2257), mad(_2260, 0.5f, _2265)));
          } else {
            if ((bool)(_2241 >= 0.6812411546707153f) && (bool)(_2241 < 3.653702974319458f)) {
              _2277 = (_2240 + -2.2630341053009033f) * 0.7089107632637024f;
              _2278 = int(_2277);
              _2280 = _2277 - float((int)(_2278));
              _2282 = _global_3[_2278];
              _2285 = _global_3[(_2278 + 1)];
              _2290 = _2282 * 0.5f;
              _2300 = dot(float3((_2280 * _2280), _2280, 1.0f), float3(mad((_global_3[(_2278 + 2)]), 0.5f, mad(_2285, -1.0f, _2290)), (_2285 - _2282), mad(_2285, 0.5f, _2290)));
            } else {
              _2300 = ((_2240 * 0.018061799928545952f) + 2.780777931213379f);
            }
          }
        } else {
          _2300 = ((_2240 * 0.9030900001525879f) + 7.54498291015625f);
        }
        _2305 = log2(select((_2234 <= 0.0f), 9.999999747378752e-05f, _2234));
        _2306 = _2305 * 0.3010300099849701f;
        if (_2306 > -3.848327875137329f) {
          if ((bool)(_2306 > -3.848327875137329f) && (bool)(_2306 < 0.6812411546707153f)) {
            _2317 = (_2305 + 12.783867835998535f) * 0.46521204710006714f;
            _2318 = int(_2317);
            _2320 = _2317 - float((int)(_2318));
            _2322 = _global_2[_2318];
            _2325 = _global_2[(_2318 + 1)];
            _2330 = _2322 * 0.5f;
            _2365 = dot(float3((_2320 * _2320), _2320, 1.0f), float3(mad((_global_2[(_2318 + 2)]), 0.5f, mad(_2325, -1.0f, _2330)), (_2325 - _2322), mad(_2325, 0.5f, _2330)));
          } else {
            if ((bool)(_2306 >= 0.6812411546707153f) && (bool)(_2306 < 3.653702974319458f)) {
              _2342 = (_2305 + -2.2630341053009033f) * 0.7089107632637024f;
              _2343 = int(_2342);
              _2345 = _2342 - float((int)(_2343));
              _2347 = _global_3[_2343];
              _2350 = _global_3[(_2343 + 1)];
              _2355 = _2347 * 0.5f;
              _2365 = dot(float3((_2345 * _2345), _2345, 1.0f), float3(mad((_global_3[(_2343 + 2)]), 0.5f, mad(_2350, -1.0f, _2355)), (_2350 - _2347), mad(_2350, 0.5f, _2355)));
            } else {
              _2365 = ((_2305 * 0.018061799928545952f) + 2.780777931213379f);
            }
          }
        } else {
          _2365 = ((_2305 * 0.9030900001525879f) + 7.54498291015625f);
        }
        _2370 = log2(select((_2237 <= 0.0f), 9.999999747378752e-05f, _2237));
        _2371 = _2370 * 0.3010300099849701f;
        if (_2371 > -3.848327875137329f) {
          if ((bool)(_2371 > -3.848327875137329f) && (bool)(_2371 < 0.6812411546707153f)) {
            _2382 = (_2370 + 12.783867835998535f) * 0.46521204710006714f;
            _2383 = int(_2382);
            _2385 = _2382 - float((int)(_2383));
            _2387 = _global_2[_2383];
            _2390 = _global_2[(_2383 + 1)];
            _2395 = _2387 * 0.5f;
            _2430 = dot(float3((_2385 * _2385), _2385, 1.0f), float3(mad((_global_2[(_2383 + 2)]), 0.5f, mad(_2390, -1.0f, _2395)), (_2390 - _2387), mad(_2390, 0.5f, _2395)));
          } else {
            if ((bool)(_2371 >= 0.6812411546707153f) && (bool)(_2371 < 3.653702974319458f)) {
              _2407 = (_2370 + -2.2630341053009033f) * 0.7089107632637024f;
              _2408 = int(_2407);
              _2410 = _2407 - float((int)(_2408));
              _2412 = _global_3[_2408];
              _2415 = _global_3[(_2408 + 1)];
              _2420 = _2412 * 0.5f;
              _2430 = dot(float3((_2410 * _2410), _2410, 1.0f), float3(mad((_global_3[(_2408 + 2)]), 0.5f, mad(_2415, -1.0f, _2420)), (_2415 - _2412), mad(_2415, 0.5f, _2420)));
            } else {
              _2430 = ((_2370 * 0.018061799928545952f) + 2.780777931213379f);
            }
          }
        } else {
          _2430 = ((_2370 * 0.9030900001525879f) + 7.54498291015625f);
        }
        _2433 = exp2(_2300 * 3.321928024291992f) + -3.507384462864138e-05f;
        _2434 = exp2(_2365 * 3.321928024291992f) + -3.507384462864138e-05f;
        _2435 = exp2(_2430 * 3.321928024291992f) + -3.507384462864138e-05f;
        if (!_1858) {
          _2447 = mad(_40, _2435, mad(_39, _2434, (_2433 * _38)));
          _2448 = mad(_43, _2435, mad(_42, _2434, (_2433 * _41)));
          _2449 = mad(_46, _2435, mad(_45, _2434, (_2433 * _44)));
        } else {
          _2447 = _2433;
          _2448 = _2434;
          _2449 = _2435;
        }
        _2459 = exp2(log2(_2447 * 9.999999747378752e-05f) * 0.1593017578125f);
        _2460 = exp2(log2(_2448 * 9.999999747378752e-05f) * 0.1593017578125f);
        _2461 = exp2(log2(_2449 * 9.999999747378752e-05f) * 0.1593017578125f);
        _3226 = exp2(log2((1.0f / ((_2459 * 18.6875f) + 1.0f)) * ((_2459 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _3227 = exp2(log2((1.0f / ((_2460 * 18.6875f) + 1.0f)) * ((_2460 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        _3228 = exp2(log2((1.0f / ((_2461 * 18.6875f) + 1.0f)) * ((_2461 * 18.8515625f) + 0.8359375f)) * 78.84375f);
      } else {
        if ((cb0_074z & -3) == 4) {
          _2494 = _1757 * 3.0f;
          _2495 = _1758 * 3.0f;
          _2498 = mad(0.17733481526374817f, _2495, mad(0.38297808170318604f, _2494, (_1756 * 1.31910240650177f)));
          _2501 = mad(0.09676162153482437f, _2495, mad(0.8134231567382812f, _2494, (_1756 * 0.2693769633769989f)));
          _2504 = mad(0.870704174041748f, _2495, mad(0.11154405772686005f, _2494, (_1756 * 0.05263196676969528f)));
          _2508 = max(max(_2498, _2501), _2504);
          _2513 = (max(_2508, 1.000000013351432e-10f) - max(min(min(_2498, _2501), _2504), 1.000000013351432e-10f)) / max(_2508, 0.009999999776482582f);
          _2526 = ((_2501 + _2498) + _2504) + (sqrt((((_2504 - _2501) * _2504) + ((_2501 - _2498) * _2501)) + ((_2498 - _2504) * _2498)) * 1.75f);
          _2527 = _2526 * 0.3333333432674408f;
          _2528 = _2513 + -0.4000000059604645f;
          _2529 = _2528 * 5.0f;
          _2533 = max((1.0f - abs(_2528 * 2.5f)), 0.0f);
          _2544 = ((float((int)(((int)(uint)((bool)(_2529 > 0.0f))) - ((int)(uint)((bool)(_2529 < 0.0f))))) * (1.0f - (_2533 * _2533))) + 1.0f) * 0.02500000037252903f;
          if (_2527 > 0.0533333346247673f) {
            if (_2527 < 0.1599999964237213f) {
              _2553 = (((0.23999999463558197f / _2526) + -0.5f) * _2544);
            } else {
              _2553 = 0.0f;
            }
          } else {
            _2553 = _2544;
          }
          _2554 = _2553 + 1.0f;
          _2555 = _2554 * _2498;
          _2556 = _2554 * _2501;
          _2557 = _2554 * _2504;
          if (!((bool)(_2555 == _2556) && (bool)(_2556 == _2557))) {
            _2564 = ((_2555 * 2.0f) - _2556) - _2557;
            _2567 = ((_2501 - _2504) * 1.7320507764816284f) * _2554;
            _2569 = atan(_2567 / _2564);
            _2572 = (_2564 < 0.0f);
            _2573 = (_2564 == 0.0f);
            _2574 = (_2567 >= 0.0f);
            _2575 = (_2567 < 0.0f);
            _2586 = select((_2574 && _2573), 90.0f, select((_2575 && _2573), -90.0f, (select((_2575 && _2572), (_2569 + -3.1415927410125732f), select((_2574 && _2572), (_2569 + 3.1415927410125732f), _2569)) * 57.2957763671875f)));
          } else {
            _2586 = 0.0f;
          }
          _2591 = min(max(select((_2586 < 0.0f), (_2586 + 360.0f), _2586), 0.0f), 360.0f);
          if (_2591 < -180.0f) {
            _2600 = (_2591 + 360.0f);
          } else {
            if (_2591 > 180.0f) {
              _2600 = (_2591 + -360.0f);
            } else {
              _2600 = _2591;
            }
          }
          if ((bool)(_2600 > -67.5f) && (bool)(_2600 < 67.5f)) {
            _2606 = (_2600 + 67.5f) * 0.029629629105329514f;
            _2607 = int(_2606);
            _2609 = _2606 - float((int)(_2607));
            _2610 = _2609 * _2609;
            _2611 = _2610 * _2609;
            if (_2607 == 3) {
              _2639 = (((0.1666666716337204f - (_2609 * 0.5f)) + (_2610 * 0.5f)) - (_2611 * 0.1666666716337204f));
            } else {
              if (_2607 == 2) {
                _2639 = ((0.6666666865348816f - _2610) + (_2611 * 0.5f));
              } else {
                if (_2607 == 1) {
                  _2639 = (((_2611 * -0.5f) + 0.1666666716337204f) + ((_2610 + _2609) * 0.5f));
                } else {
                  _2639 = select((_2607 == 0), (_2611 * 0.1666666716337204f), 0.0f);
                }
              }
            }
          } else {
            _2639 = 0.0f;
          }
          _2648 = min(max(((((_2513 * 0.27000001072883606f) * (0.029999999329447746f - _2555)) * _2639) + _2555), 0.0f), 65535.0f);
          _2649 = min(max(_2556, 0.0f), 65535.0f);
          _2650 = min(max(_2557, 0.0f), 65535.0f);
          _2663 = min(max(mad(-0.21492856740951538f, _2650, mad(-0.2365107536315918f, _2649, (_2648 * 1.4514392614364624f))), 0.0f), 65535.0f);
          _2664 = min(max(mad(-0.09967592358589172f, _2650, mad(1.17622971534729f, _2649, (_2648 * -0.07655377686023712f))), 0.0f), 65535.0f);
          _2665 = min(max(mad(0.9977163076400757f, _2650, mad(-0.006032449658960104f, _2649, (_2648 * 0.008316148072481155f))), 0.0f), 65535.0f);
          _2666 = dot(float3(_2663, _2664, _2665), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
          _2673 = ((_2663 - _2666) * 0.9599999785423279f) + _2666;
          _2674 = ((_2664 - _2666) * 0.9599999785423279f) + _2666;
          _2675 = ((_2665 - _2666) * 0.9599999785423279f) + _2666;
          _2678 = log2(select((_2673 <= 0.0f), 6.103515625e-05f, _2673));
          _2679 = _2678 * 0.3010300099849701f;
          if (_2679 > -5.2601776123046875f) {
            if ((bool)(_2679 > -5.2601776123046875f) && (bool)(_2679 < -0.7447274923324585f)) {
              _2687 = (_2678 * 0.19999998807907104f) + 3.494786262512207f;
              _2688 = int(_2687);
              _2690 = _2687 - float((int)(_2688));
              _2692 = _global_0[_2688];
              _2695 = _global_0[(_2688 + 1)];
              _2700 = _2692 * 0.5f;
              _2732 = dot(float3((_2690 * _2690), _2690, 1.0f), float3(mad((_global_0[(_2688 + 2)]), 0.5f, mad(_2695, -1.0f, _2700)), (_2695 - _2692), mad(_2695, 0.5f, _2700)));
            } else {
              if ((bool)(_2679 >= -0.7447274923324585f) && (bool)(_2679 < 4.673812389373779f)) {
                _2712 = (_2678 * 0.1666666567325592f) + 0.4123218357563019f;
                _2713 = int(_2712);
                _2715 = _2712 - float((int)(_2713));
                _2717 = _global_1[_2713];
                _2720 = _global_1[(_2713 + 1)];
                _2725 = _2717 * 0.5f;
                _2732 = dot(float3((_2715 * _2715), _2715, 1.0f), float3(mad((_global_1[(_2713 + 2)]), 0.5f, mad(_2720, -1.0f, _2725)), (_2720 - _2717), mad(_2720, 0.5f, _2725)));
              } else {
                _2732 = 4.0f;
              }
            }
          } else {
            _2732 = -4.0f;
          }
          _2734 = exp2(_2732 * 3.321928024291992f);
          _2737 = log2(select((_2674 <= 0.0f), 6.103515625e-05f, _2674));
          _2738 = _2737 * 0.3010300099849701f;
          if (_2738 > -5.2601776123046875f) {
            if ((bool)(_2738 > -5.2601776123046875f) && (bool)(_2738 < -0.7447274923324585f)) {
              _2746 = (_2737 * 0.19999998807907104f) + 3.494786262512207f;
              _2747 = int(_2746);
              _2749 = _2746 - float((int)(_2747));
              _2751 = _global_0[_2747];
              _2754 = _global_0[(_2747 + 1)];
              _2759 = _2751 * 0.5f;
              _2791 = dot(float3((_2749 * _2749), _2749, 1.0f), float3(mad((_global_0[(_2747 + 2)]), 0.5f, mad(_2754, -1.0f, _2759)), (_2754 - _2751), mad(_2754, 0.5f, _2759)));
            } else {
              if ((bool)(_2738 >= -0.7447274923324585f) && (bool)(_2738 < 4.673812389373779f)) {
                _2771 = (_2737 * 0.1666666567325592f) + 0.4123218357563019f;
                _2772 = int(_2771);
                _2774 = _2771 - float((int)(_2772));
                _2776 = _global_1[_2772];
                _2779 = _global_1[(_2772 + 1)];
                _2784 = _2776 * 0.5f;
                _2791 = dot(float3((_2774 * _2774), _2774, 1.0f), float3(mad((_global_1[(_2772 + 2)]), 0.5f, mad(_2779, -1.0f, _2784)), (_2779 - _2776), mad(_2779, 0.5f, _2784)));
              } else {
                _2791 = 4.0f;
              }
            }
          } else {
            _2791 = -4.0f;
          }
          _2793 = exp2(_2791 * 3.321928024291992f);
          _2796 = log2(select((_2675 <= 0.0f), 6.103515625e-05f, _2675));
          _2797 = _2796 * 0.3010300099849701f;
          if (_2797 > -5.2601776123046875f) {
            if ((bool)(_2797 > -5.2601776123046875f) && (bool)(_2797 < -0.7447274923324585f)) {
              _2805 = (_2796 * 0.19999998807907104f) + 3.494786262512207f;
              _2806 = int(_2805);
              _2808 = _2805 - float((int)(_2806));
              _2810 = _global_0[_2806];
              _2813 = _global_0[(_2806 + 1)];
              _2818 = _2810 * 0.5f;
              _2850 = dot(float3((_2808 * _2808), _2808, 1.0f), float3(mad((_global_0[(_2806 + 2)]), 0.5f, mad(_2813, -1.0f, _2818)), (_2813 - _2810), mad(_2813, 0.5f, _2818)));
            } else {
              if ((bool)(_2797 >= -0.7447274923324585f) && (bool)(_2797 < 4.673812389373779f)) {
                _2830 = (_2796 * 0.1666666567325592f) + 0.4123218357563019f;
                _2831 = int(_2830);
                _2833 = _2830 - float((int)(_2831));
                _2835 = _global_1[_2831];
                _2838 = _global_1[(_2831 + 1)];
                _2843 = _2835 * 0.5f;
                _2850 = dot(float3((_2833 * _2833), _2833, 1.0f), float3(mad((_global_1[(_2831 + 2)]), 0.5f, mad(_2838, -1.0f, _2843)), (_2838 - _2835), mad(_2838, 0.5f, _2843)));
              } else {
                _2850 = 4.0f;
              }
            }
          } else {
            _2850 = -4.0f;
          }
          _2852 = exp2(_2850 * 3.321928024291992f);
          _2855 = mad(0.16386906802654266f, _2852, mad(0.14067870378494263f, _2793, (_2734 * 0.6954522132873535f)));
          _2858 = mad(0.0955343171954155f, _2852, mad(0.8596711158752441f, _2793, (_2734 * 0.044794563204050064f)));
          _2861 = mad(1.0015007257461548f, _2852, mad(0.004025210160762072f, _2793, (_2734 * -0.005525882821530104f)));
          _2864 = mad(-0.21492856740951538f, _2861, mad(-0.2365107536315918f, _2858, (_2855 * 1.4514392614364624f)));
          _2867 = mad(-0.09967592358589172f, _2861, mad(1.17622971534729f, _2858, (_2855 * -0.07655377686023712f)));
          _2870 = mad(0.9977163076400757f, _2861, mad(-0.006032449658960104f, _2858, (_2855 * 0.008316148072481155f)));
          _2873 = log2(select((_2864 <= 0.0f), 9.999999747378752e-05f, _2864));
          _2874 = _2873 * 0.3010300099849701f;
          if (_2874 > -3.848327875137329f) {
            if ((bool)(_2874 > -3.848327875137329f) && (bool)(_2874 < 0.6812411546707153f)) {
              _2882 = (_2873 + 12.783867835998535f) * 0.46521204710006714f;
              _2883 = int(_2882);
              _2885 = _2882 - float((int)(_2883));
              _2887 = _global_4[_2883];
              _2890 = _global_4[(_2883 + 1)];
              _2895 = _2887 * 0.5f;
              _2930 = dot(float3((_2885 * _2885), _2885, 1.0f), float3(mad((_global_4[(_2883 + 2)]), 0.5f, mad(_2890, -1.0f, _2895)), (_2890 - _2887), mad(_2890, 0.5f, _2895)));
            } else {
              if ((bool)(_2874 >= 0.6812411546707153f) && (bool)(_2874 < 3.7613162994384766f)) {
                _2907 = (_2873 + -2.2630341053009033f) * 0.6841424107551575f;
                _2908 = int(_2907);
                _2910 = _2907 - float((int)(_2908));
                _2912 = _global_5[_2908];
                _2915 = _global_5[(_2908 + 1)];
                _2920 = _2912 * 0.5f;
                _2930 = dot(float3((_2910 * _2910), _2910, 1.0f), float3(mad((_global_5[(_2908 + 2)]), 0.5f, mad(_2915, -1.0f, _2920)), (_2915 - _2912), mad(_2915, 0.5f, _2920)));
              } else {
                _2930 = ((_2873 * 0.036123599857091904f) + 2.849672317504883f);
              }
            }
          } else {
            _2930 = -2.301030158996582f;
          }
          _2932 = exp2(_2930 * 3.321928024291992f);
          _2935 = log2(select((_2867 <= 0.0f), 9.999999747378752e-05f, _2867));
          _2936 = _2935 * 0.3010300099849701f;
          if (_2936 > -3.848327875137329f) {
            if ((bool)(_2936 > -3.848327875137329f) && (bool)(_2936 < 0.6812411546707153f)) {
              _2944 = (_2935 + 12.783867835998535f) * 0.46521204710006714f;
              _2945 = int(_2944);
              _2947 = _2944 - float((int)(_2945));
              _2949 = _global_4[_2945];
              _2952 = _global_4[(_2945 + 1)];
              _2957 = _2949 * 0.5f;
              _2992 = dot(float3((_2947 * _2947), _2947, 1.0f), float3(mad((_global_4[(_2945 + 2)]), 0.5f, mad(_2952, -1.0f, _2957)), (_2952 - _2949), mad(_2952, 0.5f, _2957)));
            } else {
              if ((bool)(_2936 >= 0.6812411546707153f) && (bool)(_2936 < 3.7613162994384766f)) {
                _2969 = (_2935 + -2.2630341053009033f) * 0.6841424107551575f;
                _2970 = int(_2969);
                _2972 = _2969 - float((int)(_2970));
                _2974 = _global_5[_2970];
                _2977 = _global_5[(_2970 + 1)];
                _2982 = _2974 * 0.5f;
                _2992 = dot(float3((_2972 * _2972), _2972, 1.0f), float3(mad((_global_5[(_2970 + 2)]), 0.5f, mad(_2977, -1.0f, _2982)), (_2977 - _2974), mad(_2977, 0.5f, _2982)));
              } else {
                _2992 = ((_2935 * 0.036123599857091904f) + 2.849672317504883f);
              }
            }
          } else {
            _2992 = -2.301030158996582f;
          }
          _2994 = exp2(_2992 * 3.321928024291992f);
          _2997 = log2(select((_2870 <= 0.0f), 9.999999747378752e-05f, _2870));
          _2998 = _2997 * 0.3010300099849701f;
          if (_2998 > -3.848327875137329f) {
            if ((bool)(_2998 > -3.848327875137329f) && (bool)(_2998 < 0.6812411546707153f)) {
              _3006 = (_2997 + 12.783867835998535f) * 0.46521204710006714f;
              _3007 = int(_3006);
              _3009 = _3006 - float((int)(_3007));
              _3011 = _global_4[_3007];
              _3014 = _global_4[(_3007 + 1)];
              _3019 = _3011 * 0.5f;
              _3054 = dot(float3((_3009 * _3009), _3009, 1.0f), float3(mad((_global_4[(_3007 + 2)]), 0.5f, mad(_3014, -1.0f, _3019)), (_3014 - _3011), mad(_3014, 0.5f, _3019)));
            } else {
              if ((bool)(_2998 >= 0.6812411546707153f) && (bool)(_2998 < 3.7613162994384766f)) {
                _3031 = (_2997 + -2.2630341053009033f) * 0.6841424107551575f;
                _3032 = int(_3031);
                _3034 = _3031 - float((int)(_3032));
                _3036 = _global_5[_3032];
                _3039 = _global_5[(_3032 + 1)];
                _3044 = _3036 * 0.5f;
                _3054 = dot(float3((_3034 * _3034), _3034, 1.0f), float3(mad((_global_5[(_3032 + 2)]), 0.5f, mad(_3039, -1.0f, _3044)), (_3039 - _3036), mad(_3039, 0.5f, _3044)));
              } else {
                _3054 = ((_2997 * 0.036123599857091904f) + 2.849672317504883f);
              }
            }
          } else {
            _3054 = -2.301030158996582f;
          }
          _3056 = exp2(_3054 * 3.321928024291992f);
          if (!(cb0_074z == 6)) {
            _3068 = mad(_40, _3056, mad(_39, _2994, (_2932 * _38)));
            _3069 = mad(_43, _3056, mad(_42, _2994, (_2932 * _41)));
            _3070 = mad(_46, _3056, mad(_45, _2994, (_2932 * _44)));
          } else {
            _3068 = _2932;
            _3069 = _2994;
            _3070 = _3056;
          }
          _3080 = exp2(log2(_3068 * 9.999999747378752e-05f) * 0.1593017578125f);
          _3081 = exp2(log2(_3069 * 9.999999747378752e-05f) * 0.1593017578125f);
          _3082 = exp2(log2(_3070 * 9.999999747378752e-05f) * 0.1593017578125f);
          _3226 = exp2(log2((1.0f / ((_3080 * 18.6875f) + 1.0f)) * ((_3080 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3227 = exp2(log2((1.0f / ((_3081 * 18.6875f) + 1.0f)) * ((_3081 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          _3228 = exp2(log2((1.0f / ((_3082 * 18.6875f) + 1.0f)) * ((_3082 * 18.8515625f) + 0.8359375f)) * 78.84375f);
        } else {
          if (cb0_074z == 7) {
            _3115 = mad(0.04736635088920593f, _1758, mad(0.3395121395587921f, _1757, (_1756 * 0.613191545009613f)));
            _3118 = mad(0.01345000695437193f, _1758, mad(0.9163357615470886f, _1757, (_1756 * 0.07020691782236099f)));
            _3121 = mad(0.8696067929267883f, _1758, mad(0.1095672994852066f, _1757, (_1756 * 0.020618872717022896f)));
            _3140 = exp2(log2(mad(_40, _3121, mad(_39, _3118, (_3115 * _38))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3141 = exp2(log2(mad(_43, _3121, mad(_42, _3118, (_3115 * _41))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3142 = exp2(log2(mad(_46, _3121, mad(_45, _3118, (_3115 * _44))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3226 = exp2(log2((1.0f / ((_3140 * 18.6875f) + 1.0f)) * ((_3140 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3227 = exp2(log2((1.0f / ((_3141 * 18.6875f) + 1.0f)) * ((_3141 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3228 = exp2(log2((1.0f / ((_3142 * 18.6875f) + 1.0f)) * ((_3142 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_074z == 8)) {
              if (cb0_074z == 9) {
                _3177 = mad(0.04736635088920593f, _1746, mad(0.3395121395587921f, _1745, (_1744 * 0.613191545009613f)));
                _3180 = mad(0.01345000695437193f, _1746, mad(0.9163357615470886f, _1745, (_1744 * 0.07020691782236099f)));
                _3183 = mad(0.8696067929267883f, _1746, mad(0.1095672994852066f, _1745, (_1744 * 0.020618872717022896f)));
                _3226 = mad(_40, _3183, mad(_39, _3180, (_3177 * _38)));
                _3227 = mad(_43, _3183, mad(_42, _3180, (_3177 * _41)));
                _3228 = mad(_46, _3183, mad(_45, _3180, (_3177 * _44)));
              } else {
                _3196 = mad(0.04736635088920593f, _1772, mad(0.3395121395587921f, _1771, (_1770 * 0.613191545009613f)));
                _3199 = mad(0.01345000695437193f, _1772, mad(0.9163357615470886f, _1771, (_1770 * 0.07020691782236099f)));
                _3202 = mad(0.8696067929267883f, _1772, mad(0.1095672994852066f, _1771, (_1770 * 0.020618872717022896f)));
                _3215 = ((0.4545454680919647f - cb0_027z) * cb0_038w) + cb0_027z;
                _3226 = exp2(_3215 * log2(mad(_40, _3202, mad(_39, _3199, (_3196 * _38)))));
                _3227 = exp2(_3215 * log2(mad(_43, _3202, mad(_42, _3199, (_3196 * _41)))));
                _3228 = exp2(_3215 * log2(mad(_46, _3202, mad(_45, _3199, (_3196 * _44)))));
              }
            } else {
              _3226 = _1756;
              _3227 = _1757;
              _3228 = _1758;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_3226 * 0.9523810148239136f);
  SV_Target.y = (_3227 * 0.9523810148239136f);
  SV_Target.z = (_3228 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
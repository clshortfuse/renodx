#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t16_space1 : register(t16, space1);

Texture2D<float4> t17_space1 : register(t17, space1);

Texture2D<uint2> t18_space1 : register(t18, space1);

Texture2D<float4> t19_space1 : register(t19, space1);

Texture2D<float4> t20_space1 : register(t20, space1);

Texture2D<float2> t22_space1 : register(t22, space1);

Texture2D<float4> t23_space1 : register(t23, space1);

Texture2D<float4> t25_space1 : register(t25, space1);

Texture2D<float4> t28_space1 : register(t28, space1);

Texture2D<float4> t29_space1 : register(t29, space1);

Texture2D<float4> t30_space1 : register(t30, space1);

Texture2D<float4> t31_space1 : register(t31, space1);

cbuffer cb2 : register(b2) {
  float4 g_rage_matrices_000[4] : packoffset(c000.x);
  float4 g_rage_matrices_064[4] : packoffset(c004.x);
  float4 g_rage_matrices_128[4] : packoffset(c008.x);
  float4 g_rage_matrices_192[4] : packoffset(c012.x);
  float4 g_rage_matrices_256[4] : packoffset(c016.x);
  float4 g_rage_matrices_320[4] : packoffset(c020.x);
  float4 g_rage_matrices_384[4] : packoffset(c024.x);
  float4 g_rage_matrices_448[4] : packoffset(c028.x);
  float4 g_rage_matrices_512[4] : packoffset(c032.x);
  float4 g_rage_matrices_576[4] : packoffset(c036.x);
  float4 g_rage_matrices_640[4] : packoffset(c040.x);
  float4 g_rage_matrices_704[4] : packoffset(c044.x);
  float4 g_rage_matrices_768[4] : packoffset(c048.x);
  float4 g_rage_matrices_832[4] : packoffset(c052.x);
};

cbuffer cb3 : register(b3) {
  int g_rage_dynamicsamplerindices_000 : packoffset(c000.x);
  int g_rage_dynamicsamplerindices_004 : packoffset(c000.y);
  int g_rage_dynamicsamplerindices_008 : packoffset(c000.z);
  int g_rage_dynamicsamplerindices_012 : packoffset(c000.w);
  int g_rage_dynamicsamplerindices_016 : packoffset(c001.x);
  int g_rage_dynamicsamplerindices_020 : packoffset(c001.y);
  int g_rage_dynamicsamplerindices_024 : packoffset(c001.z);
  int g_rage_dynamicsamplerindices_028 : packoffset(c001.w);
  int g_rage_dynamicsamplerindices_032 : packoffset(c002.x);
  int g_rage_dynamicsamplerindices_036 : packoffset(c002.y);
  int g_rage_dynamicsamplerindices_040 : packoffset(c002.z);
  int g_rage_dynamicsamplerindices_044 : packoffset(c002.w);
  int g_rage_dynamicsamplerindices_048 : packoffset(c003.x);
  int g_rage_dynamicsamplerindices_052 : packoffset(c003.y);
  int g_rage_dynamicsamplerindices_056 : packoffset(c003.z);
  int g_rage_dynamicsamplerindices_060 : packoffset(c003.w);
  int g_rage_dynamicsamplerindices_064 : packoffset(c004.x);
  int g_rage_dynamicsamplerindices_068 : packoffset(c004.y);
  int g_rage_dynamicsamplerindices_072 : packoffset(c004.z);
  int g_rage_dynamicsamplerindices_076 : packoffset(c004.w);
  int g_rage_dynamicsamplerindices_080 : packoffset(c005.x);
  int g_rage_dynamicsamplerindices_084 : packoffset(c005.y);
};

cbuffer cb5 : register(b5) {
  float4 misc_globals_000 : packoffset(c000.x);
  float misc_globals_016 : packoffset(c001.x);
  float misc_globals_020 : packoffset(c001.y);
  float misc_globals_024 : packoffset(c001.z);
  float misc_globals_028 : packoffset(c001.w);
  float4 misc_globals_032 : packoffset(c002.x);
  float4 misc_globals_048 : packoffset(c003.x);
  float4 misc_globals_064 : packoffset(c004.x);
  float4 misc_globals_080 : packoffset(c005.x);
  float4 misc_globals_096 : packoffset(c006.x);
  float4 misc_globals_112[4] : packoffset(c007.x);
  float4 misc_globals_176 : packoffset(c011.x);
  float4 misc_globals_192 : packoffset(c012.x);
  float4 misc_globals_208 : packoffset(c013.x);
  float4 misc_globals_224 : packoffset(c014.x);
  float4 misc_globals_240 : packoffset(c015.x);
  int4 misc_globals_256 : packoffset(c016.x);
  float4 misc_globals_272 : packoffset(c017.x);
  float4 misc_globals_288 : packoffset(c018.x);
  float misc_globals_304 : packoffset(c019.x);
  float misc_globals_308 : packoffset(c019.y);
  float4 misc_globals_320 : packoffset(c020.x);
  float4 misc_globals_336 : packoffset(c021.x);
  float misc_globals_352 : packoffset(c022.x);
  int misc_globals_356 : packoffset(c022.y);
  int misc_globals_360 : packoffset(c022.z);
  int2 misc_globals_368 : packoffset(c023.x);
  int2 misc_globals_376 : packoffset(c023.z);
  int misc_globals_384 : packoffset(c024.x);
  float misc_globals_388 : packoffset(c024.y);
  int misc_globals_392 : packoffset(c024.z);
  float misc_globals_396 : packoffset(c024.w);
  float2 misc_globals_400 : packoffset(c025.x);
  int misc_globals_408 : packoffset(c025.z);
};

cbuffer cb12_space1 : register(b12, space1) {
  float4 postfx_cbuffer_000 : packoffset(c000.x);
  float4 postfx_cbuffer_016 : packoffset(c001.x);
  float4 postfx_cbuffer_032 : packoffset(c002.x);
  float4 postfx_cbuffer_048 : packoffset(c003.x);
  float4 postfx_cbuffer_064 : packoffset(c004.x);
  float4 postfx_cbuffer_080 : packoffset(c005.x);
  float4 postfx_cbuffer_096 : packoffset(c006.x);
  float4 postfx_cbuffer_112 : packoffset(c007.x);
  float4 postfx_cbuffer_128 : packoffset(c008.x);
  float4 postfx_cbuffer_144 : packoffset(c009.x);
  float4 postfx_cbuffer_160 : packoffset(c010.x);
  float4 postfx_cbuffer_176 : packoffset(c011.x);
  float4 postfx_cbuffer_192 : packoffset(c012.x);
  float4 postfx_cbuffer_208 : packoffset(c013.x);
  float2 postfx_cbuffer_224 : packoffset(c014.x);
  float4 postfx_cbuffer_240 : packoffset(c015.x);
  float4 postfx_cbuffer_256 : packoffset(c016.x);
  float4 postfx_cbuffer_272 : packoffset(c017.x);
  float4 postfx_cbuffer_288 : packoffset(c018.x);
  float4 postfx_cbuffer_304 : packoffset(c019.x);
  float4 postfx_cbuffer_320 : packoffset(c020.x);
  float3 postfx_cbuffer_336 : packoffset(c021.x);
  float3 postfx_cbuffer_352 : packoffset(c022.x);
  float3 postfx_cbuffer_368 : packoffset(c023.x);
  float postfx_cbuffer_380 : packoffset(c023.w);
  float postfx_cbuffer_384 : packoffset(c024.x);
  float postfx_cbuffer_388 : packoffset(c024.y);
  float postfx_cbuffer_392 : packoffset(c024.z);
  float postfx_cbuffer_396 : packoffset(c024.w);
  float postfx_cbuffer_400 : packoffset(c025.x);
  float postfx_cbuffer_404 : packoffset(c025.y);
  float postfx_cbuffer_408 : packoffset(c025.z);
  float postfx_cbuffer_412 : packoffset(c025.w);
  float postfx_cbuffer_416 : packoffset(c026.x);
  float postfx_cbuffer_420 : packoffset(c026.y);
  float4 postfx_cbuffer_432 : packoffset(c027.x);
  float4 postfx_cbuffer_448 : packoffset(c028.x);
  float4 postfx_cbuffer_464 : packoffset(c029.x);
  float4 postfx_cbuffer_480 : packoffset(c030.x);
  float4 postfx_cbuffer_496 : packoffset(c031.x);
  float4 postfx_cbuffer_512 : packoffset(c032.x);
  float4 postfx_cbuffer_528 : packoffset(c033.x);
  float4 postfx_cbuffer_544 : packoffset(c034.x);
  float4 postfx_cbuffer_560 : packoffset(c035.x);
  float4 postfx_cbuffer_576 : packoffset(c036.x);
  float4 postfx_cbuffer_592 : packoffset(c037.x);
  float4 postfx_cbuffer_608 : packoffset(c038.x);
  float4 postfx_cbuffer_624 : packoffset(c039.x);
  float4 postfx_cbuffer_640 : packoffset(c040.x);
  float4 postfx_cbuffer_656 : packoffset(c041.x);
  float4 postfx_cbuffer_672 : packoffset(c042.x);
  float4 postfx_cbuffer_688 : packoffset(c043.x);
  float4 postfx_cbuffer_704 : packoffset(c044.x);
  float4 postfx_cbuffer_720 : packoffset(c045.x);
  float4 postfx_cbuffer_736 : packoffset(c046.x);
  float4 postfx_cbuffer_752 : packoffset(c047.x);
  float4 postfx_cbuffer_768 : packoffset(c048.x);
  float4 postfx_cbuffer_784 : packoffset(c049.x);
  float4 postfx_cbuffer_800 : packoffset(c050.x);
  float4 postfx_cbuffer_816 : packoffset(c051.x);
  float4 postfx_cbuffer_832 : packoffset(c052.x);
  float4 postfx_cbuffer_848 : packoffset(c053.x);
  float4 postfx_cbuffer_864 : packoffset(c054.x);
  float4 postfx_cbuffer_880 : packoffset(c055.x);
  float postfx_cbuffer_896 : packoffset(c056.x);
  float4 postfx_cbuffer_912 : packoffset(c057.x);
  float4 postfx_cbuffer_928 : packoffset(c058.x);
  float4 postfx_cbuffer_944 : packoffset(c059.x);
  float4 postfx_cbuffer_960 : packoffset(c060.x);
  float4 postfx_cbuffer_976 : packoffset(c061.x);
  float4 postfx_cbuffer_992 : packoffset(c062.x);
  float4 postfx_cbuffer_1008 : packoffset(c063.x);
  float postfx_cbuffer_1024 : packoffset(c064.x);
  float4 postfx_cbuffer_1040 : packoffset(c065.x);
  float4 postfx_cbuffer_1056 : packoffset(c066.x);
  float postfx_cbuffer_1072 : packoffset(c067.x);
  float postfx_cbuffer_1076 : packoffset(c067.y);
  float4 postfx_cbuffer_1088 : packoffset(c068.x);
  float4 postfx_cbuffer_1104 : packoffset(c069.x);
  float4 postfx_cbuffer_1120 : packoffset(c070.x);
  float4 postfx_cbuffer_1136 : packoffset(c071.x);
  float4 postfx_cbuffer_1152 : packoffset(c072.x);
  float4 postfx_cbuffer_1168 : packoffset(c073.x);
  float2 postfx_cbuffer_1184 : packoffset(c074.x);
  float4 postfx_cbuffer_1200 : packoffset(c075.x);
  float3 postfx_cbuffer_1216 : packoffset(c076.x);
  float4 postfx_cbuffer_1232 : packoffset(c077.x);
  float4 postfx_cbuffer_1248 : packoffset(c078.x);
  float4 postfx_cbuffer_1264 : packoffset(c079.x);
  float4 postfx_cbuffer_1280 : packoffset(c080.x);
  float4 postfx_cbuffer_1296 : packoffset(c081.x);
  float4 postfx_cbuffer_1312 : packoffset(c082.x);
  float4 postfx_cbuffer_1328 : packoffset(c083.x);
  float4 postfx_cbuffer_1344 : packoffset(c084.x);
  float postfx_cbuffer_1360 : packoffset(c085.x);
  float4 postfx_cbuffer_1376 : packoffset(c086.x);
  float3 postfx_cbuffer_1392 : packoffset(c087.x);
  float postfx_cbuffer_1404 : packoffset(c087.w);
  float4 postfx_cbuffer_1408 : packoffset(c088.x);
  float postfx_cbuffer_1424 : packoffset(c089.x);
  float4 postfx_cbuffer_1440 : packoffset(c090.x);
  float4 postfx_cbuffer_1456 : packoffset(c091.x);
  float4 postfx_cbuffer_1472 : packoffset(c092.x);
  float4 postfx_cbuffer_1488 : packoffset(c093.x);
  float postfx_cbuffer_1504 : packoffset(c094.x);
  float postfx_cbuffer_1508 : packoffset(c094.y);
  float postfx_cbuffer_1512 : packoffset(c094.z);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s1_space1 : register(s1, space1);

SamplerState s2_space1 : register(s2, space1);

SamplerState s3_space1 : register(s3, space1);

SamplerState s0_space2[] : register(s0, space2);

SamplerState s6_space1 : register(s6, space1);

SamplerState s8_space1 : register(s8, space1);

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float _35;
  float _40;
  float _68;
  float4 _87;
  float4 _90;
  float _114;
  float _121;
  float _122;
  float _123;
  float _124;
  float _130;
  float _131;
  float _132;
  float _133;
  float _134;
  float _138;
  float _139;
  float _142;
  float _143;
  float _144;
  float _145;
  float _146;
  float _147;
  float _148;
  float _149;
  float _150;
  float _151;
  float _156;
  float _157;
  float _169;
  float _171;
  float _173;
  float _176;
  float _188;
  float _189;
  float _192;
  float _193;
  float _194;
  float _195;
  float _196;
  float _200;
  float4 _205;
  float4 _214;
  float4 _225;
  float4 _236;
  float4 _247;
  float _256;
  float _257;
  float _265;
  float _266;
  float _272;
  float _285;
  float4 _287;
  float _291;
  float _298;
  float _299;
  float _300;
  int _303;
  float _410;
  float _411;
  float _412;
  float _413;
  int _414;
  float _462;
  float _463;
  float _464;
  float _465;
  float _551;
  float _552;
  float _553;
  float _554;
  int _555;
  float _674;
  float _675;
  float _676;
  float _677;
  float _685;
  float _686;
  float _687;
  float _688;
  float _785;
  float _786;
  float _787;
  float _788;
  int _789;
  float _910;
  float _911;
  float _912;
  float _913;
  float _921;
  float _922;
  float _923;
  float _924;
  float _945;
  float _946;
  float _947;
  float _994;
  float _995;
  float _996;
  float _1369;
  float _1370;
  float _1371;
  float _322;
  float _325;
  float _326;
  float _349;
  float _350;
  float _351;
  float _369;
  float _371;
  float _376;
  float _377;
  float _378;
  bool _379;
  float _380;
  float _386;
  float _388;
  float _389;
  float _390;
  float _391;
  float _416;
  float _430;
  float _431;
  float _443;
  float4 _444;
  float _451;
  float _452;
  float _453;
  float _454;
  int _455;
  float _466;
  float _473;
  float4 _491;
  float2 _500;
  float _505;
  float _506;
  float _515;
  int _520;
  float _524;
  float _525;
  float _527;
  float _528;
  float _545;
  float _556;
  float _557;
  float _558;
  float _561;
  float _562;
  float2 _563;
  float _568;
  float _569;
  float _575;
  float _583;
  float _589;
  float _590;
  float _596;
  float4 _603;
  float _607;
  float _608;
  float _611;
  float _612;
  float2 _613;
  float _616;
  float _617;
  float _622;
  float _627;
  float _633;
  float _639;
  float _645;
  float4 _646;
  bool _650;
  bool _651;
  float _653;
  float _655;
  float _663;
  float _665;
  float _667;
  float _669;
  int _670;
  float _679;
  float _689;
  float4 _696;
  float _701;
  float4 _716;
  float2 _725;
  float4 _735;
  float _739;
  float _740;
  float _749;
  int _754;
  float _758;
  float _759;
  float _761;
  float _762;
  float _779;
  float _790;
  float _791;
  float _792;
  float _795;
  float _796;
  float2 _797;
  float _802;
  float _803;
  float _809;
  float4 _817;
  float _824;
  float _825;
  float _831;
  float4 _838;
  float _842;
  float _843;
  float _846;
  float _847;
  float2 _848;
  float _851;
  float _852;
  float _857;
  float4 _862;
  float _869;
  float _875;
  float _881;
  float4 _882;
  bool _886;
  bool _887;
  float _889;
  float _891;
  float _899;
  float _901;
  float _903;
  float _905;
  int _906;
  float _915;
  float _925;
  float4 _932;
  float _937;
  float4 _948;
  float _960;
  float _961;
  float _962;
  bool _965;
  float _966;
  float4 _967;
  float _971;
  float _972;
  float _973;
  float4 _978;
  float _980;
  float _981;
  float _982;
  float _1005;
  float _1027;
  float _1028;
  float _1037;
  float _1062;
  float _1081;
  float _1082;
  float _1084;
  float _1099;
  float _1100;
  float _1101;
  float _1102;
  float _1103;
  float _1106;
  float _1110;
  float _1113;
  float _1115;
  float _1119;
  float _1120;
  float _1121;
  float _1122;
  float _1123;
  float _1124;
  float _1152;
  float _1153;
  float _1154;
  float _1162;
  float _1163;
  float _1164;
  float _1165;
  float _1174;
  float _1175;
  float _1176;
  float _1180;
  float _1197;
  float _1198;
  float _1199;
  float _1205;
  float _1250;
  float _1270;
  float _1277;
  float _1278;
  float _1279;
  bool _1289;
  float _1291;
  float _1348;
  float _1354;
  float _1358;
  _35 = 1.0f - ((t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y))).x);
  _40 = postfx_cbuffer_000.z / (_35 + postfx_cbuffer_000.w);
  _68 = ((((((float4)(t16_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y)))).x) * ((float)((bool)((uint)((_40 > postfx_cbuffer_480.y) && (_40 < postfx_cbuffer_480.y)))))) * postfx_cbuffer_528.z) * (postfx_cbuffer_480.w - postfx_cbuffer_480.z)) + postfx_cbuffer_480.z;
  _87 = t29_space1.Sample(s3_space1, float2(((postfx_cbuffer_496.x * TEXCOORD.x) + postfx_cbuffer_496.z), ((postfx_cbuffer_496.y * TEXCOORD.y) + postfx_cbuffer_496.w)));
  _90 = t29_space1.Sample(s3_space1, float2(((postfx_cbuffer_512.x * TEXCOORD.x) + postfx_cbuffer_512.z), ((postfx_cbuffer_512.y * TEXCOORD.y) + postfx_cbuffer_512.w)));
  _114 = min(max((1.0f - saturate(((postfx_cbuffer_1152.z / postfx_cbuffer_1152.w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  _121 = (((postfx_cbuffer_528.x * _68) * ((_87.x + -1.0f) + _90.x)) + TEXCOORD.x) + -0.5f;
  _122 = (((postfx_cbuffer_528.y * _68) * ((_87.y + -1.0f) + _90.y)) + TEXCOORD.y) + -0.5f;
  _123 = (postfx_cbuffer_1152.x / postfx_cbuffer_1152.y) * _121;
  _124 = dot(float2(_123, _122), float2(_123, _122));
  _130 = CUSTOM_LENS_DISTORTION * ((_114 * _124) * ((sqrt(_124) * postfx_cbuffer_1104.y) + postfx_cbuffer_1104.x)) + 1.0f;
  _131 = _130 * _121;
  _132 = _130 * _122;
  _133 = _131 + 0.5f;
  _134 = _132 + 0.5f;
  _138 = _133 * misc_globals_240.x;
  _139 = _134 * misc_globals_240.y;
  _142 = floor(_138 + -0.5f);
  _143 = floor(_139 + -0.5f);
  _144 = _142 + 0.5f;
  _145 = _143 + 0.5f;
  _146 = _138 - _144;
  _147 = _139 - _145;
  _148 = _146 * _146;
  _149 = _147 * _147;
  _150 = _148 * _146;
  _151 = _149 * _147;
  _156 = _148 - ((_150 + _146) * 0.5f);
  _157 = _149 - ((_151 + _147) * 0.5f);
  _169 = (_146 * 0.5f) * (_148 - _146);
  _171 = (_147 * 0.5f) * (_149 - _147);
  _173 = (1.0f - _169) - _156;
  _176 = (1.0f - _171) - _157;
  _188 = (((_173 - (((_150 * 1.5f) - (_148 * 2.5f)) + 1.0f)) / _173) + _144) / misc_globals_240.x;
  _189 = (((_176 - (((_151 * 1.5f) - (_149 * 2.5f)) + 1.0f)) / _176) + _145) / misc_globals_240.y;
  _192 = _173 * _157;
  _193 = _176 * _156;
  _194 = _173 * _176;
  _195 = _176 * _169;
  _196 = _173 * _171;
  _200 = (((_192 + _193) + _194) + _195) + _196;
  _205 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_188, ((_143 + -0.5f) / misc_globals_240.y)), 0.0f);
  _214 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(((_142 + -0.5f) / misc_globals_240.x), _189), 0.0f);
  _225 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_188, _189), 0.0f);
  _236 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(((_142 + 2.5f) / misc_globals_240.x), _189), 0.0f);
  _247 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_188, ((_143 + 2.5f) / misc_globals_240.y)), 0.0f);
  _256 = max(0.0f, ((((((_214.y * _193) + (_205.y * _192)) + (_225.y * _194)) + (_236.y * _195)) + (_247.y * _196)) / _200));
  _257 = max(0.0f, ((((((_214.z * _193) + (_205.z * _192)) + (_225.z * _194)) + (_236.z * _195)) + (_247.z * _196)) / _200));
  _265 = (postfx_cbuffer_1152.x / postfx_cbuffer_1152.y) * _131;
  _266 = dot(float2(_265, _132), float2(_265, _132));
  _272 = CUSTOM_CHROMATIC_ABERRATION * ((_114 * _266) * ((sqrt(_266) * postfx_cbuffer_1104.w) + postfx_cbuffer_1104.z)) + 1.0f;
  _285 = misc_globals_224.w * (((float4)(t15_space1.Sample(s0_space2[((uint)(g_rage_dynamicsamplerindices_012) + 0u)], float2(((_272 * _131) + 0.5f), ((_272 * _132) + 0.5f))))).x);
  _287 = t19_space1.Sample(s1_space1, float2(_133, _134));
  _291 = saturate(max(((saturate(postfx_cbuffer_032.y * (_40 - postfx_cbuffer_032.x)) * ((float)((bool)((uint)(!(_35 == 0.0f)))))) * postfx_cbuffer_032.z), _68));
  _298 = ((_287.x - _285) * _291) + _285;
  _299 = ((_287.y - _256) * _291) + _256;
  _300 = ((_287.z - _257) * _291) + _257;
  _303 = int(postfx_cbuffer_272.z);
  if (_303 == 1) {
    _322 = select(((((float)((uint)((uint)(((uint2)(t18_space1.Load(int3(int(misc_globals_240.x * _133), int(misc_globals_240.y * _134), 0)))).y)))) * 0.003921568859368563f) > postfx_cbuffer_896), 0.0f, 1.0f);
    _325 = (_133 * 2.0f) + -1.0f;
    _326 = 1.0f - (_134 * 2.0f);
    _349 = (g_rage_matrices_192[3].x) + (dot(float3(_325, _326, 1.0f), float3(postfx_cbuffer_336.x, postfx_cbuffer_336.y, postfx_cbuffer_336.z)) * _40);
    _350 = (g_rage_matrices_192[3].y) + (dot(float3(_325, _326, 1.0f), float3(postfx_cbuffer_352.x, postfx_cbuffer_352.y, postfx_cbuffer_352.z)) * _40);
    _351 = (g_rage_matrices_192[3].z) + (dot(float3(_325, _326, 1.0f), float3(postfx_cbuffer_368.x, postfx_cbuffer_368.y, postfx_cbuffer_368.z)) * _40);
    _369 = dot(float4(_349, _350, _351, 1.0f), float4(postfx_cbuffer_320.x, postfx_cbuffer_320.y, postfx_cbuffer_320.z, postfx_cbuffer_320.w));
    _371 = select((_369 == 0.0f), 9.999999747378752e-06f, _369);
    _376 = (_325 - (dot(float4(_349, _350, _351, 1.0f), float4(postfx_cbuffer_288.x, postfx_cbuffer_288.y, postfx_cbuffer_288.z, postfx_cbuffer_288.w)) / _371)) * 40.0f;
    _377 = (_326 - (dot(float4(_349, _350, _351, 1.0f), float4(postfx_cbuffer_304.x, postfx_cbuffer_304.y, postfx_cbuffer_304.z, postfx_cbuffer_304.w)) / _371)) * -22.5f;
    _378 = dot(float2(_376, _377), float2(_376, _377));
    _379 = (_378 > 1.0f);
    _380 = rsqrt(_378);
    _386 = (postfx_cbuffer_256.x * 0.012500000186264515f) * select(_379, (_380 * _376), _376);
    _388 = (postfx_cbuffer_256.x * 0.02222222276031971f) * select(_379, (_377 * _380), _377);
    _389 = _322 * _298;
    _390 = _322 * _299;
    _391 = _322 * _300;
    do {
      _462 = _389;
      _463 = _390;
      _464 = _391;
      _465 = _322;
      if ((int)int(postfx_cbuffer_272.x) > (int)1) {
        _410 = _389;
        _411 = _390;
        _412 = _391;
        _413 = _322;
        _414 = 1;
        bool _loop_break_0 = false;
        while (true) {
          _416 = float((int)(_414)) + (((((float4)(t28_space1.Sample(s6_space1, float2(((_298 * 8.0f) + (_133 * 58.16400146484375f)), ((_299 * 8.0f) + (_134 * 47.130001068115234f)))))).x) + -0.5f) * 0.5f);
          _430 = (round((((_386 * postfx_cbuffer_272.y) * _416) + _133) * misc_globals_240.x) + 0.5f) / misc_globals_240.x;
          _431 = (round((((_388 * postfx_cbuffer_272.y) * _416) + _134) * misc_globals_240.y) + 0.5f) / misc_globals_240.y;
          _443 = select(((((float)((uint)((uint)(((uint2)(t18_space1.Load(int3(int(misc_globals_240.x * _430), int(misc_globals_240.y * _431), 0)))).y)))) * 0.003921568859368563f) > postfx_cbuffer_896), 0.0f, 1.0f);
          _444 = t19_space1.SampleLevel(s1_space1, float2(_430, _431), 0.0f);
          _451 = (_444.x * _443) + _410;
          _452 = (_444.y * _443) + _411;
          _453 = (_444.z * _443) + _412;
          _454 = _443 + _413;
          _455 = _414 + 1;
          do {
            if ((int)_455 < (int)int(postfx_cbuffer_272.x)) {
              _410 = _451;
              _411 = _452;
              _412 = _453;
              _413 = _454;
              _414 = _455;
              _loop_break_0 = true;
              break;
            }
            _462 = _451;
            _463 = _452;
            _464 = _453;
            _465 = _454;
          } while (false);
          if (_loop_break_0) {
            _loop_break_0 = false;
            continue;
          }
          break;
        }
      }
      _466 = max(_465, 0.10000000149011612f);
      _473 = saturate(dot(float2(_386, _388), float2(_386, _388)) * 1e+05f) * _322;
      _945 = ((_473 * ((_462 / _466) - _298)) + _298);
      _946 = ((_473 * ((_463 / _466) - _299)) + _299);
      _947 = ((_473 * ((_464 / _466) - _300)) + _300);
    } while (false);
  } else {
    if (_303 == 2) {
      _491 = t23_space1.SampleLevel(s0_space1, float2((postfx_cbuffer_1408.x * _133), (postfx_cbuffer_1408.y * _134)), 0.0f);
      do {
        _685 = 0.0f;
        _686 = 0.0f;
        _687 = 0.0f;
        _688 = 0.0f;
        [branch]
        if ((_491.z >= 1.0f) && (_491.w < 2.0f)) {
          _500 = t22_space1.SampleLevel(s0_space1, float2(_133, _134), 0.0f);
          _505 = postfx_cbuffer_256.x * _500.x;
          _506 = postfx_cbuffer_256.x * _500.y;
          _515 = min(_491.z, 2.0f);
          _520 = int(min(2.0f, (_515 + 1.0f)));
          _524 = postfx_cbuffer_1152.x * (_515 * (_491.x / _491.z));
          _525 = postfx_cbuffer_1152.y * (_515 * (_491.y / _491.z));
          _527 = float((int)(_520)) + -0.5f;
          _528 = _527 / _515;
          _545 = ((((((float)((uint)((uint)((int)(uint(SV_Position.y)) & 1)))) * 2.0f) + -1.0f) * ((((float)((uint)((uint)((int)(uint(SV_Position.x)) & 1)))) * 2.0f) + -1.0f)) * postfx_cbuffer_256.w) * saturate((_515 + -2.0f) * 0.5f);
          do {
            _674 = 0.0f;
            _675 = 0.0f;
            _676 = 0.0f;
            _677 = 0.0f;
            if ((int)_520 > (int)0) {
              _551 = 0.0f;
              _552 = 0.0f;
              _553 = 0.0f;
              _554 = 0.0f;
              _555 = 0;
              bool _loop_break_1 = false;
              while (true) {
                _556 = float((int)(_555));
                _557 = (_545 + 0.5f) + _556;
                _558 = _557 / _527;
                _561 = (_524 * _558) + _133;
                _562 = (_525 * _558) + _134;
                _563 = t22_space1.SampleLevel(s0_space1, float2(_561, _562), 0.0f);
                _568 = postfx_cbuffer_256.x * _563.x;
                _569 = postfx_cbuffer_256.x * _563.y;
                _575 = min(sqrt((_568 * _568) + (_569 * _569)), postfx_cbuffer_256.z);
                _583 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.SampleLevel(s0_space1, float2(_561, _562), 0.0f)).x)) + postfx_cbuffer_000.w);
                _589 = _528 * min(sqrt((_505 * _505) + (_506 * _506)), postfx_cbuffer_256.z);
                _590 = _583 - _40;
                _596 = max((_557 + -1.0f), 0.0f);
                _603 = t19_space1.SampleLevel(s1_space1, float2(_561, _562), 0.0f);
                _607 = _556 + (0.5f - _545);
                _608 = _607 / _527;
                _611 = _133 - (_524 * _608);
                _612 = _134 - (_525 * _608);
                _613 = t22_space1.SampleLevel(s0_space1, float2(_611, _612), 0.0f);
                _616 = postfx_cbuffer_256.x * _613.x;
                _617 = postfx_cbuffer_256.x * _613.y;
                _622 = min(sqrt((_616 * _616) + (_617 * _617)), postfx_cbuffer_256.z);
                _627 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.SampleLevel(s0_space1, float2(_611, _612), 0.0f)).x)) + postfx_cbuffer_000.w);
                _633 = _627 - _40;
                _639 = max((_607 + -1.0f), 0.0f);
                _645 = dot(float2(saturate(_633 + 0.5f), saturate(0.5f - _633)), float2(saturate(_589 - _639), saturate((_622 * _528) - _639))) * (1.0f - saturate((1.0f - _622) * 8.0f));
                _646 = t19_space1.SampleLevel(s1_space1, float2(_611, _612), 0.0f);
                _650 = (_583 > _627);
                _651 = (_622 > _575);
                _653 = select((_651 && _650), _645, (dot(float2(saturate(_590 + 0.5f), saturate(0.5f - _590)), float2(saturate(_589 - _596), saturate((_575 * _528) - _596))) * (1.0f - saturate((1.0f - _575) * 8.0f))));
                _655 = select((_651 || _650), _645, _653);
                _663 = ((_653 * _603.x) + _551) + (_646.x * _655);
                _665 = ((_653 * _603.y) + _552) + (_646.y * _655);
                _667 = ((_653 * _603.z) + _553) + (_646.z * _655);
                _669 = (_653 + _554) + _655;
                _670 = _555 + 1;
                do {
                  if (!(_670 == _520)) {
                    _551 = _663;
                    _552 = _665;
                    _553 = _667;
                    _554 = _669;
                    _555 = _670;
                    _loop_break_1 = true;
                    break;
                  }
                  _674 = _663;
                  _675 = _665;
                  _676 = _667;
                  _677 = _669;
                } while (false);
                if (_loop_break_1) {
                  _loop_break_1 = false;
                  continue;
                }
                break;
              }
            }
            _679 = float((int)(_520 << 1));
            _685 = (_674 / _679);
            _686 = (_675 / _679);
            _687 = (_676 / _679);
            _688 = (_677 / _679);
          } while (false);
        }
        _689 = 1.0f - _688;
        _696 = t20_space1.SampleLevel(s1_space1, float2(_133, _134), 0.0f);
        _701 = 1.0f - _696.w;
        _945 = ((_701 * ((_689 * _298) + _685)) + _696.x);
        _946 = ((_701 * ((_689 * _299) + _686)) + _696.y);
        _947 = ((_701 * ((_689 * _300) + _687)) + _696.z);
      } while (false);
    } else {
      if (_303 == 3) {
        _716 = t23_space1.SampleLevel(s0_space1, float2((postfx_cbuffer_1408.x * _133), (postfx_cbuffer_1408.y * _134)), 0.0f);
        do {
          _921 = 0.0f;
          _922 = 0.0f;
          _923 = 0.0f;
          _924 = 0.0f;
          [branch]
          if ((_716.z >= 1.0f) && (_716.w < 2.0f)) {
            _725 = t22_space1.SampleLevel(s0_space1, float2(_133, _134), 0.0f);
            _735 = t19_space1.Load(int3(int(misc_globals_240.x * _133), int(misc_globals_240.y * _134), 0));
            _739 = postfx_cbuffer_256.x * _725.x;
            _740 = postfx_cbuffer_256.x * _725.y;
            _749 = min(_716.z, 2.0f);
            _754 = int(min(2.0f, (_749 + 1.0f)));
            _758 = postfx_cbuffer_1152.x * (_749 * (_716.x / _716.z));
            _759 = postfx_cbuffer_1152.y * (_749 * (_716.y / _716.z));
            _761 = float((int)(_754)) + -0.5f;
            _762 = _761 / _749;
            _779 = ((((((float)((uint)((uint)((int)(uint(SV_Position.y)) & 1)))) * 2.0f) + -1.0f) * ((((float)((uint)((uint)((int)(uint(SV_Position.x)) & 1)))) * 2.0f) + -1.0f)) * postfx_cbuffer_256.w) * saturate((_749 + -2.0f) * 0.5f);
            do {
              _910 = 0.0f;
              _911 = 0.0f;
              _912 = 0.0f;
              _913 = 0.0f;
              if ((int)_754 > (int)0) {
                _785 = 0.0f;
                _786 = 0.0f;
                _787 = 0.0f;
                _788 = 0.0f;
                _789 = 0;
                bool _loop_break_2 = false;
                while (true) {
                  _790 = float((int)(_789));
                  _791 = (_779 + 0.5f) + _790;
                  _792 = _791 / _761;
                  _795 = (_758 * _792) + _133;
                  _796 = (_759 * _792) + _134;
                  _797 = t22_space1.SampleLevel(s0_space1, float2(_795, _796), 0.0f);
                  _802 = postfx_cbuffer_256.x * _797.x;
                  _803 = postfx_cbuffer_256.x * _797.y;
                  _809 = min(sqrt((_802 * _802) + (_803 * _803)), postfx_cbuffer_256.z);
                  _817 = t19_space1.Load(int3(int(misc_globals_240.x * _795), int(misc_globals_240.y * _796), 0));
                  _824 = _762 * min(sqrt((_739 * _739) + (_740 * _740)), postfx_cbuffer_256.z);
                  _825 = _817.w - _735.w;
                  _831 = max((_791 + -1.0f), 0.0f);
                  _838 = t19_space1.SampleLevel(s1_space1, float2(_795, _796), 0.0f);
                  _842 = _790 + (0.5f - _779);
                  _843 = _842 / _761;
                  _846 = _133 - (_758 * _843);
                  _847 = _134 - (_759 * _843);
                  _848 = t22_space1.SampleLevel(s0_space1, float2(_846, _847), 0.0f);
                  _851 = postfx_cbuffer_256.x * _848.x;
                  _852 = postfx_cbuffer_256.x * _848.y;
                  _857 = min(sqrt((_851 * _851) + (_852 * _852)), postfx_cbuffer_256.z);
                  _862 = t19_space1.Load(int3(int(misc_globals_240.x * _846), int(misc_globals_240.y * _847), 0));
                  _869 = _862.w - _735.w;
                  _875 = max((_842 + -1.0f), 0.0f);
                  _881 = dot(float2(saturate(_869 + 0.5f), saturate(0.5f - _869)), float2(saturate(_824 - _875), saturate((_857 * _762) - _875))) * (1.0f - saturate((1.0f - _857) * 8.0f));
                  _882 = t19_space1.SampleLevel(s1_space1, float2(_846, _847), 0.0f);
                  _886 = (_817.w > _862.w);
                  _887 = (_857 > _809);
                  _889 = select((_887 && _886), _881, (dot(float2(saturate(_825 + 0.5f), saturate(0.5f - _825)), float2(saturate(_824 - _831), saturate((_809 * _762) - _831))) * (1.0f - saturate((1.0f - _809) * 8.0f))));
                  _891 = select((_887 || _886), _881, _889);
                  _899 = ((_889 * _838.x) + _785) + (_882.x * _891);
                  _901 = ((_889 * _838.y) + _786) + (_882.y * _891);
                  _903 = ((_889 * _838.z) + _787) + (_882.z * _891);
                  _905 = (_889 + _788) + _891;
                  _906 = _789 + 1;
                  do {
                    if (!(_906 == _754)) {
                      _785 = _899;
                      _786 = _901;
                      _787 = _903;
                      _788 = _905;
                      _789 = _906;
                      _loop_break_2 = true;
                      break;
                    }
                    _910 = _899;
                    _911 = _901;
                    _912 = _903;
                    _913 = _905;
                  } while (false);
                  if (_loop_break_2) {
                    _loop_break_2 = false;
                    continue;
                  }
                  break;
                }
              }
              _915 = float((int)(_754 << 1));
              _921 = (_910 / _915);
              _922 = (_911 / _915);
              _923 = (_912 / _915);
              _924 = (_913 / _915);
            } while (false);
          }
          _925 = 1.0f - _924;
          _932 = t20_space1.SampleLevel(s1_space1, float2(_133, _134), 0.0f);
          _937 = 1.0f - _932.w;
          _945 = ((_937 * ((_925 * _298) + _921)) + _932.x);
          _946 = ((_937 * ((_925 * _299) + _922)) + _932.y);
          _947 = ((_937 * ((_925 * _300) + _923)) + _932.z);
        } while (false);
      } else {
        _945 = _298;
        _946 = _299;
        _947 = _300;
      }
    }
  }
  _948 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  _960 = (postfx_cbuffer_1024 * (_948.x - _945)) + _945;
  _961 = (postfx_cbuffer_1024 * (_948.y - _946)) + _946;
  _962 = (postfx_cbuffer_1024 * (_948.z - _947)) + _947;
  _965 = (postfx_cbuffer_112.y < 0.0f);
  _966 = select(_965, 1.0f, TEXCOORD.w);
  _967 = t25_space1.Sample(s2_space1, float2(_133, _134));
  _967 *= CUSTOM_BLOOM;
  _971 = _967.x * _966;
  _972 = _967.y * _966;
  _973 = _967.z * _966;
  if (postfx_cbuffer_1200.z > 0.0f) {
    _978 = t31_space1.Sample(s2_space1, float2(_133, _134));
    _978 = max(0.f, _978);
    _980 = _978.x * _978.x;
    _981 = _980 * _980;
    _982 = _981 * _981 * CUSTOM_SUN_BLOOM;
    _994 = ((_982 * postfx_cbuffer_736.x) + _960);
    _995 = ((_982 * postfx_cbuffer_736.y) + _961);
    _996 = ((_982 * postfx_cbuffer_736.z) + _962);
  } else {
    _994 = _960;
    _995 = _961;
    _996 = _962;
  }
  _1005 = abs(postfx_cbuffer_112.y);
  _1027 = TEXCOORD.x + -0.5f;
  _1028 = TEXCOORD.y + -0.5f;
  _1037 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1027, _1028), float2(_1027, _1028))) * postfx_cbuffer_912.y) + postfx_cbuffer_912.x) * postfx_cbuffer_912.z);
  _1037 = lerp(1.f, _1037, CUSTOM_VIGNETTE);
  _1062 = saturate((postfx_cbuffer_224.x * TEXCOORD_1) + postfx_cbuffer_224.y);
  _1081 = ((postfx_cbuffer_192.x - postfx_cbuffer_160.x) * _1062) + postfx_cbuffer_160.x;
  _1082 = ((postfx_cbuffer_192.y - postfx_cbuffer_160.y) * _1062) + postfx_cbuffer_160.y;
  _1084 = ((postfx_cbuffer_192.w - postfx_cbuffer_160.w) * _1062) + postfx_cbuffer_160.w;
  _1099 = ((postfx_cbuffer_208.x - postfx_cbuffer_176.x) * _1062) + postfx_cbuffer_176.x;
  _1100 = ((postfx_cbuffer_208.y - postfx_cbuffer_176.y) * _1062) + postfx_cbuffer_176.y;
  _1101 = ((postfx_cbuffer_208.z - postfx_cbuffer_176.z) * _1062) + postfx_cbuffer_176.z;
  _1102 = _1101 * _1081;
  _1103 = (lerp(postfx_cbuffer_160.z, postfx_cbuffer_192.z, _1062))*_1082;
  _1106 = _1099 * _1084;
  _1110 = _1100 * _1084;
  _1113 = _1099 / _1100;
  _1115 = 1.0f / (((((_1102 + _1103) * _1101) + _1106) / (((_1102 + _1082) * _1101) + _1110)) - _1113);
  _1119 = max(0.0f, (min(((lerp(postfx_cbuffer_928.x, 1.0f, _1037)) * (_994 + select(_965, (((misc_globals_224.w * _971) - _994) * _1005), ((_971 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));
  _1120 = max(0.0f, (min(((lerp(postfx_cbuffer_928.y, 1.0f, _1037)) * (_995 + select(_965, (((misc_globals_224.w * _972) - _995) * _1005), ((_972 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));
  _1121 = max(0.0f, (min(((lerp(postfx_cbuffer_928.z, 1.0f, _1037)) * (_996 + select(_965, (((misc_globals_224.w * _973) - _996) * _1005), ((_973 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    GTAVTonemapConfig tonemap_config = CreateGTAVTonemapConfig();
    tonemap_config.a = _1081;
    tonemap_config.b = _1082;
    tonemap_config.c_times_b = _1103;
    tonemap_config.d_times_e = _1106;
    tonemap_config.d_times_f = _1110;
    tonemap_config.e_over_f = _1113;
    tonemap_config.white_scale = _1115;
    tonemap_config.fade_to_white = postfx_cbuffer_208.w;
    tonemap_config.saturation = postfx_cbuffer_1072;
    tonemap_config.grade_a = postfx_cbuffer_1056.xyz;
    tonemap_config.grade_b = postfx_cbuffer_1040.xyz;
    tonemap_config.grade_luma_max = postfx_cbuffer_1056.w;
    tonemap_config.blend_range = postfx_cbuffer_1040.w;
    return GenerateGTAVOutput(float3(_1119, _1120, _1121), TEXCOORD.xy, SV_Position.xy, tonemap_config);
  }

  _1122 = _1119 * _1081;
  _1123 = _1120 * _1081;
  _1124 = _1121 * _1081;
  _1152 = saturate((((((_1122 + _1103) * _1119) + _1106) / (((_1122 + _1082) * _1119) + _1110)) - _1113) * _1115);
  _1153 = saturate((((((_1123 + _1103) * _1120) + _1106) / (((_1123 + _1082) * _1120) + _1110)) - _1113) * _1115);
  _1154 = saturate((((((_1124 + _1103) * _1121) + _1106) / (((_1124 + _1082) * _1121) + _1110)) - _1113) * _1115);
  _1162 = (postfx_cbuffer_208.w * (1.0f - _1152)) + _1152;
  _1163 = (postfx_cbuffer_208.w * (1.0f - _1153)) + _1153;
  _1164 = (postfx_cbuffer_208.w * (1.0f - _1154)) + _1154;
  _1165 = dot(float3(_1162, _1163, _1164), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  _1174 = ((_1162 - _1165) * postfx_cbuffer_1072) + _1165;
  _1175 = ((_1163 - _1165) * postfx_cbuffer_1072) + _1165;
  _1176 = ((_1164 - _1165) * postfx_cbuffer_1072) + _1165;
  _1180 = saturate(_1165 / postfx_cbuffer_1056.w);
  _1197 = (lerp(postfx_cbuffer_1056.x, postfx_cbuffer_1040.x, _1180))*_1174;
  _1198 = (lerp(postfx_cbuffer_1056.y, postfx_cbuffer_1040.y, _1180))*_1175;
  _1199 = (lerp(postfx_cbuffer_1056.z, postfx_cbuffer_1040.z, _1180))*_1176;
  _1205 = saturate(((_1165 + -1.0f) + postfx_cbuffer_1040.w) / max(0.009999999776482582f, postfx_cbuffer_1040.w));
  _1250 = (1.0f - (((sin((postfx_cbuffer_1008.w + TEXCOORD.y) * postfx_cbuffer_1008.y) * 0.5f) + 0.5f) * postfx_cbuffer_1008.x)) - (((sin(((postfx_cbuffer_1008.w * 0.5f) + TEXCOORD.y) * postfx_cbuffer_1008.z) * 0.5f) + 0.5f) * postfx_cbuffer_1008.x);
  _1270 = ((((float4)(t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * postfx_cbuffer_240.w) + postfx_cbuffer_240.x), frac(((TEXCOORD.y * 0.8999999761581421f) * postfx_cbuffer_240.w) + postfx_cbuffer_240.y))))).w) + -0.5f) * postfx_cbuffer_240.z;

  ConfigureVanillaGrain(_1270, _1250);

  _1277 = saturate(max(0.0f, (_1270 + (_1250 * exp2(log2(abs(saturate(lerp(_1197, _1174, _1205)))) * postfx_cbuffer_1076)))));
  _1278 = saturate(max(0.0f, (_1270 + (_1250 * exp2(log2(abs(saturate(lerp(_1198, _1175, _1205)))) * postfx_cbuffer_1076)))));
  _1279 = saturate(max(0.0f, (_1270 + (_1250 * exp2(log2(abs(saturate(lerp(_1199, _1176, _1205)))) * postfx_cbuffer_1076)))));
  if (!(asint(postfx_cbuffer_1424) == 0)) {
    _1289 = (asint(postfx_cbuffer_1472.w) != 0);
    _1291 = max(_1277, max(_1278, _1279));
    _1348 = (((t1.Load(int4(((int)(uint(SV_Position.x)) & 63), ((int)(uint(SV_Position.y)) & 63), (misc_globals_356 & 31), 0))).x) * 2.0f) + -1.0f;
    _1354 = float((int)(((int)(uint)((int)(_1348 > 0.0f))) - ((int)(uint)((int)(_1348 < 0.0f)))));
    _1358 = 1.0f - sqrt(1.0f - abs(_1348));
    _1369 = (((_1358 * (((postfx_cbuffer_1456.x - postfx_cbuffer_1440.x) * exp2(log2(saturate((select(_1289, _1277, _1291) - postfx_cbuffer_1488.x) * postfx_cbuffer_1472.x)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.x)) * _1354) + _1277);
    _1370 = (((_1358 * (((postfx_cbuffer_1456.y - postfx_cbuffer_1440.y) * exp2(log2(saturate((select(_1289, _1278, _1291) - postfx_cbuffer_1488.y) * postfx_cbuffer_1472.y)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.y)) * _1354) + _1278);
    _1371 = (((_1358 * (((postfx_cbuffer_1456.z - postfx_cbuffer_1440.z) * exp2(log2(saturate((select(_1289, _1279, _1291) - postfx_cbuffer_1488.z) * postfx_cbuffer_1472.z)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.z)) * _1354) + _1279);

    ConfigureVanillaDithering(
        _1277, _1278, _1279,
        _1369, _1370, _1371);
  } else {
    _1369 = _1277;
    _1370 = _1278;
    _1371 = _1279;
  }
  SV_Target.x = _1369;
  SV_Target.y = _1370;
  SV_Target.z = _1371;
  SV_Target.w = dot(float3(_1277, _1278, _1279), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / postfx_cbuffer_1076));
  return SV_Target;
}

#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

Texture2D<float4> t14_space1 : register(t14, space1);

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
  float _41;
  float _58;
  float4 _77;
  float4 _80;
  float _104;
  float _111;
  float _112;
  float _113;
  float _114;
  float _120;
  float _121;
  float _122;
  float _123;
  float _124;
  float _128;
  float _129;
  float _132;
  float _133;
  float _134;
  float _135;
  float _136;
  float _137;
  float _138;
  float _139;
  float _140;
  float _141;
  float _146;
  float _147;
  float _159;
  float _161;
  float _163;
  float _166;
  float _178;
  float _179;
  float _182;
  float _183;
  float _184;
  float _185;
  float _186;
  float _190;
  float4 _195;
  float4 _204;
  float4 _215;
  float4 _226;
  float4 _237;
  float _246;
  float _247;
  float _255;
  float _256;
  float _262;
  float _275;
  float _356;
  float _357;
  float _358;
  float _468;
  float _469;
  float _470;
  float _471;
  int _472;
  float _520;
  float _521;
  float _522;
  float _523;
  float _609;
  float _610;
  float _611;
  float _612;
  int _613;
  float _732;
  float _733;
  float _734;
  float _735;
  float _743;
  float _744;
  float _745;
  float _746;
  float _843;
  float _844;
  float _845;
  float _846;
  int _847;
  float _968;
  float _969;
  float _970;
  float _971;
  float _979;
  float _980;
  float _981;
  float _982;
  float _1003;
  float _1004;
  float _1005;
  float _1052;
  float _1053;
  float _1054;
  float _1427;
  float _1428;
  float _1429;
  float4 _280;
  float4 _284;
  float4 _288;
  float _319;
  float _326;
  float _329;
  float _330;
  float _331;
  float _332;
  float _333;
  int _361;
  float _380;
  float _383;
  float _384;
  float _407;
  float _408;
  float _409;
  float _427;
  float _429;
  float _434;
  float _435;
  float _436;
  bool _437;
  float _438;
  float _444;
  float _446;
  float _447;
  float _448;
  float _449;
  float _474;
  float _488;
  float _489;
  float _501;
  float4 _502;
  float _509;
  float _510;
  float _511;
  float _512;
  int _513;
  float _524;
  float _531;
  float4 _549;
  float2 _558;
  float _563;
  float _564;
  float _573;
  int _578;
  float _582;
  float _583;
  float _585;
  float _586;
  float _603;
  float _614;
  float _615;
  float _616;
  float _619;
  float _620;
  float2 _621;
  float _626;
  float _627;
  float _633;
  float _641;
  float _647;
  float _648;
  float _654;
  float4 _661;
  float _665;
  float _666;
  float _669;
  float _670;
  float2 _671;
  float _674;
  float _675;
  float _680;
  float _685;
  float _691;
  float _697;
  float _703;
  float4 _704;
  bool _708;
  bool _709;
  float _711;
  float _713;
  float _721;
  float _723;
  float _725;
  float _727;
  int _728;
  float _737;
  float _747;
  float4 _754;
  float _759;
  float4 _774;
  float2 _783;
  float4 _793;
  float _797;
  float _798;
  float _807;
  int _812;
  float _816;
  float _817;
  float _819;
  float _820;
  float _837;
  float _848;
  float _849;
  float _850;
  float _853;
  float _854;
  float2 _855;
  float _860;
  float _861;
  float _867;
  float4 _875;
  float _882;
  float _883;
  float _889;
  float4 _896;
  float _900;
  float _901;
  float _904;
  float _905;
  float2 _906;
  float _909;
  float _910;
  float _915;
  float4 _920;
  float _927;
  float _933;
  float _939;
  float4 _940;
  bool _944;
  bool _945;
  float _947;
  float _949;
  float _957;
  float _959;
  float _961;
  float _963;
  int _964;
  float _973;
  float _983;
  float4 _990;
  float _995;
  float4 _1006;
  float _1018;
  float _1019;
  float _1020;
  bool _1023;
  float _1024;
  float4 _1025;
  float _1029;
  float _1030;
  float _1031;
  float4 _1036;
  float _1038;
  float _1039;
  float _1040;
  float _1063;
  float _1085;
  float _1086;
  float _1095;
  float _1120;
  float _1139;
  float _1140;
  float _1142;
  float _1157;
  float _1158;
  float _1159;
  float _1160;
  float _1161;
  float _1164;
  float _1168;
  float _1171;
  float _1173;
  float _1177;
  float _1178;
  float _1179;
  float _1180;
  float _1181;
  float _1182;
  float _1210;
  float _1211;
  float _1212;
  float _1220;
  float _1221;
  float _1222;
  float _1223;
  float _1232;
  float _1233;
  float _1234;
  float _1238;
  float _1255;
  float _1256;
  float _1257;
  float _1263;
  float _1308;
  float _1328;
  float _1335;
  float _1336;
  float _1337;
  bool _1347;
  float _1349;
  float _1406;
  float _1412;
  float _1416;
  _41 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y))).x)) + postfx_cbuffer_000.w);
  _58 = ((((((float4)(t16_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y)))).x) * ((float)((bool)((uint)((_41 > postfx_cbuffer_480.y) && (_41 < postfx_cbuffer_480.y)))))) * postfx_cbuffer_528.z) * (postfx_cbuffer_480.w - postfx_cbuffer_480.z)) + postfx_cbuffer_480.z;
  _77 = t29_space1.Sample(s3_space1, float2(((postfx_cbuffer_496.x * TEXCOORD.x) + postfx_cbuffer_496.z), ((postfx_cbuffer_496.y * TEXCOORD.y) + postfx_cbuffer_496.w)));
  _80 = t29_space1.Sample(s3_space1, float2(((postfx_cbuffer_512.x * TEXCOORD.x) + postfx_cbuffer_512.z), ((postfx_cbuffer_512.y * TEXCOORD.y) + postfx_cbuffer_512.w)));
  _104 = min(max((1.0f - saturate(((postfx_cbuffer_1152.z / postfx_cbuffer_1152.w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  _111 = (((postfx_cbuffer_528.x * _58) * ((_77.x + -1.0f) + _80.x)) + TEXCOORD.x) + -0.5f;
  _112 = (((postfx_cbuffer_528.y * _58) * ((_77.y + -1.0f) + _80.y)) + TEXCOORD.y) + -0.5f;
  _113 = (postfx_cbuffer_1152.x / postfx_cbuffer_1152.y) * _111;
  _114 = dot(float2(_113, _112), float2(_113, _112));
  _120 = CUSTOM_LENS_DISTORTION * ((_104 * _114) * ((sqrt(_114) * postfx_cbuffer_1104.y) + postfx_cbuffer_1104.x)) + 1.0f;
  _121 = _120 * _111;
  _122 = _120 * _112;
  _123 = _121 + 0.5f;
  _124 = _122 + 0.5f;
  _128 = _123 * misc_globals_240.x;
  _129 = _124 * misc_globals_240.y;
  _132 = floor(_128 + -0.5f);
  _133 = floor(_129 + -0.5f);
  _134 = _132 + 0.5f;
  _135 = _133 + 0.5f;
  _136 = _128 - _134;
  _137 = _129 - _135;
  _138 = _136 * _136;
  _139 = _137 * _137;
  _140 = _138 * _136;
  _141 = _139 * _137;
  _146 = _138 - ((_140 + _136) * 0.5f);
  _147 = _139 - ((_141 + _137) * 0.5f);
  _159 = (_136 * 0.5f) * (_138 - _136);
  _161 = (_137 * 0.5f) * (_139 - _137);
  _163 = (1.0f - _159) - _146;
  _166 = (1.0f - _161) - _147;
  _178 = (((_163 - (((_140 * 1.5f) - (_138 * 2.5f)) + 1.0f)) / _163) + _134) / misc_globals_240.x;
  _179 = (((_166 - (((_141 * 1.5f) - (_139 * 2.5f)) + 1.0f)) / _166) + _135) / misc_globals_240.y;
  _182 = _163 * _147;
  _183 = _166 * _146;
  _184 = _163 * _166;
  _185 = _166 * _159;
  _186 = _163 * _161;
  _190 = (((_182 + _183) + _184) + _185) + _186;
  _195 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_178, ((_133 + -0.5f) / misc_globals_240.y)), 0.0f);
  _204 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(((_132 + -0.5f) / misc_globals_240.x), _179), 0.0f);
  _215 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_178, _179), 0.0f);
  _226 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(((_132 + 2.5f) / misc_globals_240.x), _179), 0.0f);
  _237 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_178, ((_133 + 2.5f) / misc_globals_240.y)), 0.0f);
  _246 = max(0.0f, ((((((_204.y * _183) + (_195.y * _182)) + (_215.y * _184)) + (_226.y * _185)) + (_237.y * _186)) / _190));
  _247 = max(0.0f, ((((((_204.z * _183) + (_195.z * _182)) + (_215.z * _184)) + (_226.z * _185)) + (_237.z * _186)) / _190));
  _255 = (postfx_cbuffer_1152.x / postfx_cbuffer_1152.y) * _121;
  _256 = dot(float2(_255, _122), float2(_255, _122));
  _262 = CUSTOM_CHROMATIC_ABERRATION * ((_104 * _256) * ((sqrt(_256) * postfx_cbuffer_1104.w) + postfx_cbuffer_1104.z)) + 1.0f;
  _275 = misc_globals_224.w * (((float4)(t15_space1.Sample(s0_space2[((uint)(g_rage_dynamicsamplerindices_012) + 0u)], float2(((_262 * _121) + 0.5f), ((_262 * _122) + 0.5f))))).x);
  if (!(postfx_cbuffer_1360 > 0.0f)) {
    _280 = t19_space1.Sample(s1_space1, float2(_123, _124));
    _284 = t14_space1.Sample(s2_space1, float2(_123, _124));
    _288 = t30_space1.Sample(s2_space1, float2(_123, _124));
    _319 = max(saturate(1.0f - ((_41 - postfx_cbuffer_048.x) * postfx_cbuffer_048.y)), saturate((_41 - postfx_cbuffer_048.z) * postfx_cbuffer_048.w));
    _326 = saturate(1.0f - (_319 * 499.9999694824219f));
    _329 = 1.0f - _326;
    _330 = min(saturate(0.5015197396278381f - (_319 * 0.5065855979919434f)), _329);
    _331 = _329 - _330;
    _332 = min(saturate(100.0f - (_319 * 100.0f)), _331);
    _333 = _331 - _332;
    _356 = ((((_330 * _280.x) + (_326 * _275)) + (_332 * ((_284.x * 0.699999988079071f) + (_280.x * 0.30000001192092896f)))) + (((_288.x + _284.x) * 0.5f) * _333));
    _357 = ((((_330 * _280.y) + (_326 * _246)) + (_332 * ((_284.y * 0.699999988079071f) + (_280.y * 0.30000001192092896f)))) + (((_288.y + _284.y) * 0.5f) * _333));
    _358 = ((((_330 * _280.z) + (_326 * _247)) + (_332 * ((_284.z * 0.699999988079071f) + (_280.z * 0.30000001192092896f)))) + (((_288.z + _284.z) * 0.5f) * _333));
  } else {
    _356 = _275;
    _357 = _246;
    _358 = _247;
  }
  _361 = int(postfx_cbuffer_272.z);
  if (_361 == 1) {
    _380 = select(((((float)((uint)((uint)(((uint2)(t18_space1.Load(int3(int(misc_globals_240.x * _123), int(misc_globals_240.y * _124), 0)))).y)))) * 0.003921568859368563f) > postfx_cbuffer_896), 0.0f, 1.0f);
    _383 = (_123 * 2.0f) + -1.0f;
    _384 = 1.0f - (_124 * 2.0f);
    _407 = (g_rage_matrices_192[3].x) + (dot(float3(_383, _384, 1.0f), float3(postfx_cbuffer_336.x, postfx_cbuffer_336.y, postfx_cbuffer_336.z)) * _41);
    _408 = (g_rage_matrices_192[3].y) + (dot(float3(_383, _384, 1.0f), float3(postfx_cbuffer_352.x, postfx_cbuffer_352.y, postfx_cbuffer_352.z)) * _41);
    _409 = (g_rage_matrices_192[3].z) + (dot(float3(_383, _384, 1.0f), float3(postfx_cbuffer_368.x, postfx_cbuffer_368.y, postfx_cbuffer_368.z)) * _41);
    _427 = dot(float4(_407, _408, _409, 1.0f), float4(postfx_cbuffer_320.x, postfx_cbuffer_320.y, postfx_cbuffer_320.z, postfx_cbuffer_320.w));
    _429 = select((_427 == 0.0f), 9.999999747378752e-06f, _427);
    _434 = (_383 - (dot(float4(_407, _408, _409, 1.0f), float4(postfx_cbuffer_288.x, postfx_cbuffer_288.y, postfx_cbuffer_288.z, postfx_cbuffer_288.w)) / _429)) * 40.0f;
    _435 = (_384 - (dot(float4(_407, _408, _409, 1.0f), float4(postfx_cbuffer_304.x, postfx_cbuffer_304.y, postfx_cbuffer_304.z, postfx_cbuffer_304.w)) / _429)) * -22.5f;
    _436 = dot(float2(_434, _435), float2(_434, _435));
    _437 = (_436 > 1.0f);
    _438 = rsqrt(_436);
    _444 = (postfx_cbuffer_256.x * 0.012500000186264515f) * select(_437, (_438 * _434), _434);
    _446 = (postfx_cbuffer_256.x * 0.02222222276031971f) * select(_437, (_435 * _438), _435);
    _447 = _380 * _356;
    _448 = _380 * _357;
    _449 = _380 * _358;
    do {
      _520 = _447;
      _521 = _448;
      _522 = _449;
      _523 = _380;
      if ((int)int(postfx_cbuffer_272.x) > (int)1) {
        _468 = _447;
        _469 = _448;
        _470 = _449;
        _471 = _380;
        _472 = 1;
        bool _loop_break_0 = false;
        while (true) {
          _474 = float((int)(_472)) + (((((float4)(t28_space1.Sample(s6_space1, float2(((_356 * 8.0f) + (_123 * 58.16400146484375f)), ((_357 * 8.0f) + (_124 * 47.130001068115234f)))))).x) + -0.5f) * 0.5f);
          _488 = (round((((_444 * postfx_cbuffer_272.y) * _474) + _123) * misc_globals_240.x) + 0.5f) / misc_globals_240.x;
          _489 = (round((((_446 * postfx_cbuffer_272.y) * _474) + _124) * misc_globals_240.y) + 0.5f) / misc_globals_240.y;
          _501 = select(((((float)((uint)((uint)(((uint2)(t18_space1.Load(int3(int(misc_globals_240.x * _488), int(misc_globals_240.y * _489), 0)))).y)))) * 0.003921568859368563f) > postfx_cbuffer_896), 0.0f, 1.0f);
          _502 = t19_space1.SampleLevel(s1_space1, float2(_488, _489), 0.0f);
          _509 = (_502.x * _501) + _468;
          _510 = (_502.y * _501) + _469;
          _511 = (_502.z * _501) + _470;
          _512 = _501 + _471;
          _513 = _472 + 1;
          do {
            if ((int)_513 < (int)int(postfx_cbuffer_272.x)) {
              _468 = _509;
              _469 = _510;
              _470 = _511;
              _471 = _512;
              _472 = _513;
              _loop_break_0 = true;
              break;
            }
            _520 = _509;
            _521 = _510;
            _522 = _511;
            _523 = _512;
          } while (false);
          if (_loop_break_0) {
            _loop_break_0 = false;
            continue;
          }
          break;
        }
      }
      _524 = max(_523, 0.10000000149011612f);
      _531 = saturate(dot(float2(_444, _446), float2(_444, _446)) * 1e+05f) * _380;
      _1003 = ((_531 * ((_520 / _524) - _356)) + _356);
      _1004 = ((_531 * ((_521 / _524) - _357)) + _357);
      _1005 = ((_531 * ((_522 / _524) - _358)) + _358);
    } while (false);
  } else {
    if (_361 == 2) {
      _549 = t23_space1.SampleLevel(s0_space1, float2((postfx_cbuffer_1408.x * _123), (postfx_cbuffer_1408.y * _124)), 0.0f);
      do {
        _743 = 0.0f;
        _744 = 0.0f;
        _745 = 0.0f;
        _746 = 0.0f;
        [branch]
        if ((_549.z >= 1.0f) && (_549.w < 2.0f)) {
          _558 = t22_space1.SampleLevel(s0_space1, float2(_123, _124), 0.0f);
          _563 = postfx_cbuffer_256.x * _558.x;
          _564 = postfx_cbuffer_256.x * _558.y;
          _573 = min(_549.z, 2.0f);
          _578 = int(min(2.0f, (_573 + 1.0f)));
          _582 = postfx_cbuffer_1152.x * (_573 * (_549.x / _549.z));
          _583 = postfx_cbuffer_1152.y * (_573 * (_549.y / _549.z));
          _585 = float((int)(_578)) + -0.5f;
          _586 = _585 / _573;
          _603 = ((((((float)((uint)((uint)((int)(uint(SV_Position.y)) & 1)))) * 2.0f) + -1.0f) * ((((float)((uint)((uint)((int)(uint(SV_Position.x)) & 1)))) * 2.0f) + -1.0f)) * postfx_cbuffer_256.w) * saturate((_573 + -2.0f) * 0.5f);
          do {
            _732 = 0.0f;
            _733 = 0.0f;
            _734 = 0.0f;
            _735 = 0.0f;
            if ((int)_578 > (int)0) {
              _609 = 0.0f;
              _610 = 0.0f;
              _611 = 0.0f;
              _612 = 0.0f;
              _613 = 0;
              bool _loop_break_1 = false;
              while (true) {
                _614 = float((int)(_613));
                _615 = (_603 + 0.5f) + _614;
                _616 = _615 / _585;
                _619 = (_582 * _616) + _123;
                _620 = (_583 * _616) + _124;
                _621 = t22_space1.SampleLevel(s0_space1, float2(_619, _620), 0.0f);
                _626 = postfx_cbuffer_256.x * _621.x;
                _627 = postfx_cbuffer_256.x * _621.y;
                _633 = min(sqrt((_626 * _626) + (_627 * _627)), postfx_cbuffer_256.z);
                _641 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.SampleLevel(s0_space1, float2(_619, _620), 0.0f)).x)) + postfx_cbuffer_000.w);
                _647 = _586 * min(sqrt((_563 * _563) + (_564 * _564)), postfx_cbuffer_256.z);
                _648 = _641 - _41;
                _654 = max((_615 + -1.0f), 0.0f);
                _661 = t19_space1.SampleLevel(s1_space1, float2(_619, _620), 0.0f);
                _665 = _614 + (0.5f - _603);
                _666 = _665 / _585;
                _669 = _123 - (_582 * _666);
                _670 = _124 - (_583 * _666);
                _671 = t22_space1.SampleLevel(s0_space1, float2(_669, _670), 0.0f);
                _674 = postfx_cbuffer_256.x * _671.x;
                _675 = postfx_cbuffer_256.x * _671.y;
                _680 = min(sqrt((_674 * _674) + (_675 * _675)), postfx_cbuffer_256.z);
                _685 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.SampleLevel(s0_space1, float2(_669, _670), 0.0f)).x)) + postfx_cbuffer_000.w);
                _691 = _685 - _41;
                _697 = max((_665 + -1.0f), 0.0f);
                _703 = dot(float2(saturate(_691 + 0.5f), saturate(0.5f - _691)), float2(saturate(_647 - _697), saturate((_680 * _586) - _697))) * (1.0f - saturate((1.0f - _680) * 8.0f));
                _704 = t19_space1.SampleLevel(s1_space1, float2(_669, _670), 0.0f);
                _708 = (_641 > _685);
                _709 = (_680 > _633);
                _711 = select((_709 && _708), _703, (dot(float2(saturate(_648 + 0.5f), saturate(0.5f - _648)), float2(saturate(_647 - _654), saturate((_633 * _586) - _654))) * (1.0f - saturate((1.0f - _633) * 8.0f))));
                _713 = select((_709 || _708), _703, _711);
                _721 = ((_711 * _661.x) + _609) + (_704.x * _713);
                _723 = ((_711 * _661.y) + _610) + (_704.y * _713);
                _725 = ((_711 * _661.z) + _611) + (_704.z * _713);
                _727 = (_711 + _612) + _713;
                _728 = _613 + 1;
                do {
                  if (!(_728 == _578)) {
                    _609 = _721;
                    _610 = _723;
                    _611 = _725;
                    _612 = _727;
                    _613 = _728;
                    _loop_break_1 = true;
                    break;
                  }
                  _732 = _721;
                  _733 = _723;
                  _734 = _725;
                  _735 = _727;
                } while (false);
                if (_loop_break_1) {
                  _loop_break_1 = false;
                  continue;
                }
                break;
              }
            }
            _737 = float((int)(_578 << 1));
            _743 = (_732 / _737);
            _744 = (_733 / _737);
            _745 = (_734 / _737);
            _746 = (_735 / _737);
          } while (false);
        }
        _747 = 1.0f - _746;
        _754 = t20_space1.SampleLevel(s1_space1, float2(_123, _124), 0.0f);
        _759 = 1.0f - _754.w;
        _1003 = ((_759 * ((_747 * _356) + _743)) + _754.x);
        _1004 = ((_759 * ((_747 * _357) + _744)) + _754.y);
        _1005 = ((_759 * ((_747 * _358) + _745)) + _754.z);
      } while (false);
    } else {
      if (_361 == 3) {
        _774 = t23_space1.SampleLevel(s0_space1, float2((postfx_cbuffer_1408.x * _123), (postfx_cbuffer_1408.y * _124)), 0.0f);
        do {
          _979 = 0.0f;
          _980 = 0.0f;
          _981 = 0.0f;
          _982 = 0.0f;
          [branch]
          if ((_774.z >= 1.0f) && (_774.w < 2.0f)) {
            _783 = t22_space1.SampleLevel(s0_space1, float2(_123, _124), 0.0f);
            _793 = t19_space1.Load(int3(int(misc_globals_240.x * _123), int(misc_globals_240.y * _124), 0));
            _797 = postfx_cbuffer_256.x * _783.x;
            _798 = postfx_cbuffer_256.x * _783.y;
            _807 = min(_774.z, 2.0f);
            _812 = int(min(2.0f, (_807 + 1.0f)));
            _816 = postfx_cbuffer_1152.x * (_807 * (_774.x / _774.z));
            _817 = postfx_cbuffer_1152.y * (_807 * (_774.y / _774.z));
            _819 = float((int)(_812)) + -0.5f;
            _820 = _819 / _807;
            _837 = ((((((float)((uint)((uint)((int)(uint(SV_Position.y)) & 1)))) * 2.0f) + -1.0f) * ((((float)((uint)((uint)((int)(uint(SV_Position.x)) & 1)))) * 2.0f) + -1.0f)) * postfx_cbuffer_256.w) * saturate((_807 + -2.0f) * 0.5f);
            do {
              _968 = 0.0f;
              _969 = 0.0f;
              _970 = 0.0f;
              _971 = 0.0f;
              if ((int)_812 > (int)0) {
                _843 = 0.0f;
                _844 = 0.0f;
                _845 = 0.0f;
                _846 = 0.0f;
                _847 = 0;
                bool _loop_break_2 = false;
                while (true) {
                  _848 = float((int)(_847));
                  _849 = (_837 + 0.5f) + _848;
                  _850 = _849 / _819;
                  _853 = (_816 * _850) + _123;
                  _854 = (_817 * _850) + _124;
                  _855 = t22_space1.SampleLevel(s0_space1, float2(_853, _854), 0.0f);
                  _860 = postfx_cbuffer_256.x * _855.x;
                  _861 = postfx_cbuffer_256.x * _855.y;
                  _867 = min(sqrt((_860 * _860) + (_861 * _861)), postfx_cbuffer_256.z);
                  _875 = t19_space1.Load(int3(int(misc_globals_240.x * _853), int(misc_globals_240.y * _854), 0));
                  _882 = _820 * min(sqrt((_797 * _797) + (_798 * _798)), postfx_cbuffer_256.z);
                  _883 = _875.w - _793.w;
                  _889 = max((_849 + -1.0f), 0.0f);
                  _896 = t19_space1.SampleLevel(s1_space1, float2(_853, _854), 0.0f);
                  _900 = _848 + (0.5f - _837);
                  _901 = _900 / _819;
                  _904 = _123 - (_816 * _901);
                  _905 = _124 - (_817 * _901);
                  _906 = t22_space1.SampleLevel(s0_space1, float2(_904, _905), 0.0f);
                  _909 = postfx_cbuffer_256.x * _906.x;
                  _910 = postfx_cbuffer_256.x * _906.y;
                  _915 = min(sqrt((_909 * _909) + (_910 * _910)), postfx_cbuffer_256.z);
                  _920 = t19_space1.Load(int3(int(misc_globals_240.x * _904), int(misc_globals_240.y * _905), 0));
                  _927 = _920.w - _793.w;
                  _933 = max((_900 + -1.0f), 0.0f);
                  _939 = dot(float2(saturate(_927 + 0.5f), saturate(0.5f - _927)), float2(saturate(_882 - _933), saturate((_915 * _820) - _933))) * (1.0f - saturate((1.0f - _915) * 8.0f));
                  _940 = t19_space1.SampleLevel(s1_space1, float2(_904, _905), 0.0f);
                  _944 = (_875.w > _920.w);
                  _945 = (_915 > _867);
                  _947 = select((_945 && _944), _939, (dot(float2(saturate(_883 + 0.5f), saturate(0.5f - _883)), float2(saturate(_882 - _889), saturate((_867 * _820) - _889))) * (1.0f - saturate((1.0f - _867) * 8.0f))));
                  _949 = select((_945 || _944), _939, _947);
                  _957 = ((_947 * _896.x) + _843) + (_940.x * _949);
                  _959 = ((_947 * _896.y) + _844) + (_940.y * _949);
                  _961 = ((_947 * _896.z) + _845) + (_940.z * _949);
                  _963 = (_947 + _846) + _949;
                  _964 = _847 + 1;
                  do {
                    if (!(_964 == _812)) {
                      _843 = _957;
                      _844 = _959;
                      _845 = _961;
                      _846 = _963;
                      _847 = _964;
                      _loop_break_2 = true;
                      break;
                    }
                    _968 = _957;
                    _969 = _959;
                    _970 = _961;
                    _971 = _963;
                  } while (false);
                  if (_loop_break_2) {
                    _loop_break_2 = false;
                    continue;
                  }
                  break;
                }
              }
              _973 = float((int)(_812 << 1));
              _979 = (_968 / _973);
              _980 = (_969 / _973);
              _981 = (_970 / _973);
              _982 = (_971 / _973);
            } while (false);
          }
          _983 = 1.0f - _982;
          _990 = t20_space1.SampleLevel(s1_space1, float2(_123, _124), 0.0f);
          _995 = 1.0f - _990.w;
          _1003 = ((_995 * ((_983 * _356) + _979)) + _990.x);
          _1004 = ((_995 * ((_983 * _357) + _980)) + _990.y);
          _1005 = ((_995 * ((_983 * _358) + _981)) + _990.z);
        } while (false);
      } else {
        _1003 = _356;
        _1004 = _357;
        _1005 = _358;
      }
    }
  }
  _1006 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  _1018 = (postfx_cbuffer_1024 * (_1006.x - _1003)) + _1003;
  _1019 = (postfx_cbuffer_1024 * (_1006.y - _1004)) + _1004;
  _1020 = (postfx_cbuffer_1024 * (_1006.z - _1005)) + _1005;
  _1023 = (postfx_cbuffer_112.y < 0.0f);
  _1024 = select(_1023, 1.0f, TEXCOORD.w);
  _1025 = t25_space1.Sample(s2_space1, float2(_123, _124));
  _1025 *= CUSTOM_BLOOM;
  _1029 = _1025.x * _1024;
  _1030 = _1025.y * _1024;
  _1031 = _1025.z * _1024;
  if (postfx_cbuffer_1200.z > 0.0f) {
    _1036 = t31_space1.Sample(s2_space1, float2(_123, _124));
    _1036 = max(0.f, _1036);
    _1038 = _1036.x * _1036.x;
    _1039 = _1038 * _1038;
    _1040 = _1039 * _1039 * CUSTOM_SUN_BLOOM;
    _1052 = ((_1040 * postfx_cbuffer_736.x) + _1018);
    _1053 = ((_1040 * postfx_cbuffer_736.y) + _1019);
    _1054 = ((_1040 * postfx_cbuffer_736.z) + _1020);
  } else {
    _1052 = _1018;
    _1053 = _1019;
    _1054 = _1020;
  }
  _1063 = abs(postfx_cbuffer_112.y);
  _1085 = TEXCOORD.x + -0.5f;
  _1086 = TEXCOORD.y + -0.5f;
  _1095 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1085, _1086), float2(_1085, _1086))) * postfx_cbuffer_912.y) + postfx_cbuffer_912.x) * postfx_cbuffer_912.z);
  _1095 = lerp(1.f, _1095, CUSTOM_VIGNETTE);
  _1120 = saturate((postfx_cbuffer_224.x * TEXCOORD_1) + postfx_cbuffer_224.y);
  _1139 = ((postfx_cbuffer_192.x - postfx_cbuffer_160.x) * _1120) + postfx_cbuffer_160.x;
  _1140 = ((postfx_cbuffer_192.y - postfx_cbuffer_160.y) * _1120) + postfx_cbuffer_160.y;
  _1142 = ((postfx_cbuffer_192.w - postfx_cbuffer_160.w) * _1120) + postfx_cbuffer_160.w;
  _1157 = ((postfx_cbuffer_208.x - postfx_cbuffer_176.x) * _1120) + postfx_cbuffer_176.x;
  _1158 = ((postfx_cbuffer_208.y - postfx_cbuffer_176.y) * _1120) + postfx_cbuffer_176.y;
  _1159 = ((postfx_cbuffer_208.z - postfx_cbuffer_176.z) * _1120) + postfx_cbuffer_176.z;
  _1160 = _1159 * _1139;
  _1161 = (lerp(postfx_cbuffer_160.z, postfx_cbuffer_192.z, _1120))*_1140;
  _1164 = _1157 * _1142;
  _1168 = _1158 * _1142;
  _1171 = _1157 / _1158;
  _1173 = 1.0f / (((((_1160 + _1161) * _1159) + _1164) / (((_1160 + _1140) * _1159) + _1168)) - _1171);
  _1177 = max(0.0f, (min(((lerp(postfx_cbuffer_928.x, 1.0f, _1095)) * (_1052 + select(_1023, (((misc_globals_224.w * _1029) - _1052) * _1063), ((_1029 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));
  _1178 = max(0.0f, (min(((lerp(postfx_cbuffer_928.y, 1.0f, _1095)) * (_1053 + select(_1023, (((misc_globals_224.w * _1030) - _1053) * _1063), ((_1030 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));
  _1179 = max(0.0f, (min(((lerp(postfx_cbuffer_928.z, 1.0f, _1095)) * (_1054 + select(_1023, (((misc_globals_224.w * _1031) - _1054) * _1063), ((_1031 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    GTAVTonemapConfig tonemap_config = CreateGTAVTonemapConfig();
    tonemap_config.a = _1139;
    tonemap_config.b = _1140;
    tonemap_config.c_times_b = _1161;
    tonemap_config.d_times_e = _1164;
    tonemap_config.d_times_f = _1168;
    tonemap_config.e_over_f = _1171;
    tonemap_config.white_scale = _1173;
    tonemap_config.fade_to_white = postfx_cbuffer_208.w;
    tonemap_config.saturation = postfx_cbuffer_1072;
    tonemap_config.grade_a = postfx_cbuffer_1056.xyz;
    tonemap_config.grade_b = postfx_cbuffer_1040.xyz;
    tonemap_config.grade_luma_max = postfx_cbuffer_1056.w;
    tonemap_config.blend_range = postfx_cbuffer_1040.w;
    return GenerateGTAVOutput(float3(_1177, _1178, _1179), TEXCOORD.xy, SV_Position.xy, tonemap_config);
  }

  _1180 = _1177 * _1139;
  _1181 = _1178 * _1139;
  _1182 = _1179 * _1139;
  _1210 = saturate((((((_1180 + _1161) * _1177) + _1164) / (((_1180 + _1140) * _1177) + _1168)) - _1171) * _1173);
  _1211 = saturate((((((_1181 + _1161) * _1178) + _1164) / (((_1181 + _1140) * _1178) + _1168)) - _1171) * _1173);
  _1212 = saturate((((((_1182 + _1161) * _1179) + _1164) / (((_1182 + _1140) * _1179) + _1168)) - _1171) * _1173);
  _1220 = (postfx_cbuffer_208.w * (1.0f - _1210)) + _1210;
  _1221 = (postfx_cbuffer_208.w * (1.0f - _1211)) + _1211;
  _1222 = (postfx_cbuffer_208.w * (1.0f - _1212)) + _1212;
  _1223 = dot(float3(_1220, _1221, _1222), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  _1232 = ((_1220 - _1223) * postfx_cbuffer_1072) + _1223;
  _1233 = ((_1221 - _1223) * postfx_cbuffer_1072) + _1223;
  _1234 = ((_1222 - _1223) * postfx_cbuffer_1072) + _1223;
  _1238 = saturate(_1223 / postfx_cbuffer_1056.w);
  _1255 = (lerp(postfx_cbuffer_1056.x, postfx_cbuffer_1040.x, _1238))*_1232;
  _1256 = (lerp(postfx_cbuffer_1056.y, postfx_cbuffer_1040.y, _1238))*_1233;
  _1257 = (lerp(postfx_cbuffer_1056.z, postfx_cbuffer_1040.z, _1238))*_1234;
  _1263 = saturate(((_1223 + -1.0f) + postfx_cbuffer_1040.w) / max(0.009999999776482582f, postfx_cbuffer_1040.w));
  _1308 = (1.0f - (((sin((postfx_cbuffer_1008.w + TEXCOORD.y) * postfx_cbuffer_1008.y) * 0.5f) + 0.5f) * postfx_cbuffer_1008.x)) - (((sin(((postfx_cbuffer_1008.w * 0.5f) + TEXCOORD.y) * postfx_cbuffer_1008.z) * 0.5f) + 0.5f) * postfx_cbuffer_1008.x);
  _1328 = ((((float4)(t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * postfx_cbuffer_240.w) + postfx_cbuffer_240.x), frac(((TEXCOORD.y * 0.8999999761581421f) * postfx_cbuffer_240.w) + postfx_cbuffer_240.y))))).w) + -0.5f) * postfx_cbuffer_240.z;

  ConfigureVanillaGrain(_1328, _1308);

  _1335 = saturate(max(0.0f, (_1328 + (_1308 * exp2(log2(abs(saturate(lerp(_1255, _1232, _1263)))) * postfx_cbuffer_1076)))));
  _1336 = saturate(max(0.0f, (_1328 + (_1308 * exp2(log2(abs(saturate(lerp(_1256, _1233, _1263)))) * postfx_cbuffer_1076)))));
  _1337 = saturate(max(0.0f, (_1328 + (_1308 * exp2(log2(abs(saturate(lerp(_1257, _1234, _1263)))) * postfx_cbuffer_1076)))));
  if (!(asint(postfx_cbuffer_1424) == 0)) {
    _1347 = (asint(postfx_cbuffer_1472.w) != 0);
    _1349 = max(_1335, max(_1336, _1337));
    _1406 = (((t1.Load(int4(((int)(uint(SV_Position.x)) & 63), ((int)(uint(SV_Position.y)) & 63), (misc_globals_356 & 31), 0))).x) * 2.0f) + -1.0f;
    _1412 = float((int)(((int)(uint)((int)(_1406 > 0.0f))) - ((int)(uint)((int)(_1406 < 0.0f)))));
    _1416 = 1.0f - sqrt(1.0f - abs(_1406));
    _1427 = (((_1416 * (((postfx_cbuffer_1456.x - postfx_cbuffer_1440.x) * exp2(log2(saturate((select(_1347, _1335, _1349) - postfx_cbuffer_1488.x) * postfx_cbuffer_1472.x)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.x)) * _1412) + _1335);
    _1428 = (((_1416 * (((postfx_cbuffer_1456.y - postfx_cbuffer_1440.y) * exp2(log2(saturate((select(_1347, _1336, _1349) - postfx_cbuffer_1488.y) * postfx_cbuffer_1472.y)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.y)) * _1412) + _1336);
    _1429 = (((_1416 * (((postfx_cbuffer_1456.z - postfx_cbuffer_1440.z) * exp2(log2(saturate((select(_1347, _1337, _1349) - postfx_cbuffer_1488.z) * postfx_cbuffer_1472.z)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.z)) * _1412) + _1337);

    ConfigureVanillaDithering(
        _1335, _1336, _1337,
        _1427, _1428, _1429);
  } else {
    _1427 = _1335;
    _1428 = _1336;
    _1429 = _1337;
  }
  SV_Target.x = _1427;
  SV_Target.y = _1428;
  SV_Target.z = _1429;
  SV_Target.w = dot(float3(_1335, _1336, _1337), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / postfx_cbuffer_1076));
  return SV_Target;
}

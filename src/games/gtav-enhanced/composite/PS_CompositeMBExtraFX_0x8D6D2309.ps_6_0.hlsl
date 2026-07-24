#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

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
  float _34;
  float _39;
  float _60;
  float _67;
  float _68;
  float _69;
  float _70;
  float _76;
  float _77;
  float _78;
  float _79;
  float _80;
  float _84;
  float _85;
  float _88;
  float _89;
  float _90;
  float _91;
  float _92;
  float _93;
  float _94;
  float _95;
  float _96;
  float _97;
  float _102;
  float _103;
  float _115;
  float _117;
  float _119;
  float _122;
  float _134;
  float _135;
  float _138;
  float _139;
  float _140;
  float _141;
  float _142;
  float _146;
  float4 _151;
  float4 _160;
  float4 _171;
  float4 _182;
  float4 _193;
  float _202;
  float _203;
  float _211;
  float _212;
  float _218;
  float _231;
  float4 _232;
  float _236;
  float _243;
  float _244;
  float _245;
  int _248;
  float _355;
  float _356;
  float _357;
  float _358;
  int _359;
  float _407;
  float _408;
  float _409;
  float _410;
  float _496;
  float _497;
  float _498;
  float _499;
  int _500;
  float _619;
  float _620;
  float _621;
  float _622;
  float _630;
  float _631;
  float _632;
  float _633;
  float _730;
  float _731;
  float _732;
  float _733;
  int _734;
  float _855;
  float _856;
  float _857;
  float _858;
  float _866;
  float _867;
  float _868;
  float _869;
  float _890;
  float _891;
  float _892;
  float _939;
  float _940;
  float _941;
  float _1343;
  float _1344;
  float _1345;
  float _267;
  float _270;
  float _271;
  float _294;
  float _295;
  float _296;
  float _314;
  float _316;
  float _321;
  float _322;
  float _323;
  bool _324;
  float _325;
  float _331;
  float _333;
  float _334;
  float _335;
  float _336;
  float _361;
  float _375;
  float _376;
  float _388;
  float4 _389;
  float _396;
  float _397;
  float _398;
  float _399;
  int _400;
  float _411;
  float _418;
  float4 _436;
  float2 _445;
  float _450;
  float _451;
  float _460;
  int _465;
  float _469;
  float _470;
  float _472;
  float _473;
  float _490;
  float _501;
  float _502;
  float _503;
  float _506;
  float _507;
  float2 _508;
  float _513;
  float _514;
  float _520;
  float _528;
  float _534;
  float _535;
  float _541;
  float4 _548;
  float _552;
  float _553;
  float _556;
  float _557;
  float2 _558;
  float _561;
  float _562;
  float _567;
  float _572;
  float _578;
  float _584;
  float _590;
  float4 _591;
  bool _595;
  bool _596;
  float _598;
  float _600;
  float _608;
  float _610;
  float _612;
  float _614;
  int _615;
  float _624;
  float _634;
  float4 _641;
  float _646;
  float4 _661;
  float2 _670;
  float4 _680;
  float _684;
  float _685;
  float _694;
  int _699;
  float _703;
  float _704;
  float _706;
  float _707;
  float _724;
  float _735;
  float _736;
  float _737;
  float _740;
  float _741;
  float2 _742;
  float _747;
  float _748;
  float _754;
  float4 _762;
  float _769;
  float _770;
  float _776;
  float4 _783;
  float _787;
  float _788;
  float _791;
  float _792;
  float2 _793;
  float _796;
  float _797;
  float _802;
  float4 _807;
  float _814;
  float _820;
  float _826;
  float4 _827;
  bool _831;
  bool _832;
  float _834;
  float _836;
  float _844;
  float _846;
  float _848;
  float _850;
  int _851;
  float _860;
  float _870;
  float4 _877;
  float _882;
  float4 _893;
  float _905;
  float _906;
  float _907;
  bool _910;
  float _911;
  float4 _912;
  float _916;
  float _917;
  float _918;
  float4 _923;
  float _925;
  float _926;
  float _927;
  float4 _942;
  float _964;
  float _968;
  float _969;
  float _970;
  float _979;
  float _1001;
  float _1002;
  float _1011;
  float _1036;
  float _1055;
  float _1056;
  float _1058;
  float _1073;
  float _1074;
  float _1075;
  float _1076;
  float _1077;
  float _1080;
  float _1084;
  float _1087;
  float _1089;
  float _1093;
  float _1094;
  float _1095;
  float _1096;
  float _1097;
  float _1098;
  float _1126;
  float _1127;
  float _1128;
  float _1136;
  float _1137;
  float _1138;
  float _1139;
  float _1148;
  float _1149;
  float _1150;
  float _1154;
  float _1171;
  float _1172;
  float _1173;
  float _1179;
  float _1224;
  float _1244;
  float _1251;
  float _1252;
  float _1253;
  bool _1263;
  float _1265;
  float _1322;
  float _1328;
  float _1332;
  _34 = 1.0f - ((t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y))).x);
  _39 = postfx_cbuffer_000.z / (_34 + postfx_cbuffer_000.w);
  _60 = min(max((1.0f - saturate(((postfx_cbuffer_1152.z / postfx_cbuffer_1152.w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  _67 = TEXCOORD.x + -0.5f;
  _68 = TEXCOORD.y + -0.5f;
  _69 = (postfx_cbuffer_1152.x / postfx_cbuffer_1152.y) * _67;
  _70 = dot(float2(_69, _68), float2(_69, _68));
  _76 = CUSTOM_LENS_DISTORTION * ((_60 * _70) * ((sqrt(_70) * postfx_cbuffer_1104.y) + postfx_cbuffer_1104.x)) + 1.0f;
  _77 = _76 * _67;
  _78 = _76 * _68;
  _79 = _77 + 0.5f;
  _80 = _78 + 0.5f;
  _84 = _79 * misc_globals_240.x;
  _85 = _80 * misc_globals_240.y;
  _88 = floor(_84 + -0.5f);
  _89 = floor(_85 + -0.5f);
  _90 = _88 + 0.5f;
  _91 = _89 + 0.5f;
  _92 = _84 - _90;
  _93 = _85 - _91;
  _94 = _92 * _92;
  _95 = _93 * _93;
  _96 = _94 * _92;
  _97 = _95 * _93;
  _102 = _94 - ((_96 + _92) * 0.5f);
  _103 = _95 - ((_97 + _93) * 0.5f);
  _115 = (_92 * 0.5f) * (_94 - _92);
  _117 = (_93 * 0.5f) * (_95 - _93);
  _119 = (1.0f - _115) - _102;
  _122 = (1.0f - _117) - _103;
  _134 = (((_119 - (((_96 * 1.5f) - (_94 * 2.5f)) + 1.0f)) / _119) + _90) / misc_globals_240.x;
  _135 = (((_122 - (((_97 * 1.5f) - (_95 * 2.5f)) + 1.0f)) / _122) + _91) / misc_globals_240.y;
  _138 = _119 * _103;
  _139 = _122 * _102;
  _140 = _119 * _122;
  _141 = _122 * _115;
  _142 = _119 * _117;
  _146 = (((_138 + _139) + _140) + _141) + _142;
  _151 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_134, ((_89 + -0.5f) / misc_globals_240.y)), 0.0f);
  _160 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(((_88 + -0.5f) / misc_globals_240.x), _135), 0.0f);
  _171 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_134, _135), 0.0f);
  _182 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(((_88 + 2.5f) / misc_globals_240.x), _135), 0.0f);
  _193 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_134, ((_89 + 2.5f) / misc_globals_240.y)), 0.0f);
  _202 = max(0.0f, ((((((_160.y * _139) + (_151.y * _138)) + (_171.y * _140)) + (_182.y * _141)) + (_193.y * _142)) / _146));
  _203 = max(0.0f, ((((((_160.z * _139) + (_151.z * _138)) + (_171.z * _140)) + (_182.z * _141)) + (_193.z * _142)) / _146));
  _211 = (postfx_cbuffer_1152.x / postfx_cbuffer_1152.y) * _77;
  _212 = dot(float2(_211, _78), float2(_211, _78));
  _218 = CUSTOM_CHROMATIC_ABERRATION * ((_60 * _212) * ((sqrt(_212) * postfx_cbuffer_1104.w) + postfx_cbuffer_1104.z)) + 1.0f;
  _231 = misc_globals_224.w * (((float4)(t15_space1.Sample(s0_space2[((uint)(g_rage_dynamicsamplerindices_012) + 0u)], float2(((_218 * _77) + 0.5f), ((_218 * _78) + 0.5f))))).x);
  _232 = t19_space1.Sample(s1_space1, float2(_79, _80));
  _236 = saturate((saturate(postfx_cbuffer_032.y * (_39 - postfx_cbuffer_032.x)) * ((float)((bool)((uint)(!(_34 == 0.0f)))))) * postfx_cbuffer_032.z);
  _243 = ((_232.x - _231) * _236) + _231;
  _244 = ((_232.y - _202) * _236) + _202;
  _245 = ((_232.z - _203) * _236) + _203;
  _248 = int(postfx_cbuffer_272.z);
  if (_248 == 1) {
    _267 = select(((((float)((uint)((uint)(((uint2)(t18_space1.Load(int3(int(misc_globals_240.x * _79), int(misc_globals_240.y * _80), 0)))).y)))) * 0.003921568859368563f) > postfx_cbuffer_896), 0.0f, 1.0f);
    _270 = (_79 * 2.0f) + -1.0f;
    _271 = 1.0f - (_80 * 2.0f);
    _294 = (g_rage_matrices_192[3].x) + (dot(float3(_270, _271, 1.0f), float3(postfx_cbuffer_336.x, postfx_cbuffer_336.y, postfx_cbuffer_336.z)) * _39);
    _295 = (g_rage_matrices_192[3].y) + (dot(float3(_270, _271, 1.0f), float3(postfx_cbuffer_352.x, postfx_cbuffer_352.y, postfx_cbuffer_352.z)) * _39);
    _296 = (g_rage_matrices_192[3].z) + (dot(float3(_270, _271, 1.0f), float3(postfx_cbuffer_368.x, postfx_cbuffer_368.y, postfx_cbuffer_368.z)) * _39);
    _314 = dot(float4(_294, _295, _296, 1.0f), float4(postfx_cbuffer_320.x, postfx_cbuffer_320.y, postfx_cbuffer_320.z, postfx_cbuffer_320.w));
    _316 = select((_314 == 0.0f), 9.999999747378752e-06f, _314);
    _321 = (_270 - (dot(float4(_294, _295, _296, 1.0f), float4(postfx_cbuffer_288.x, postfx_cbuffer_288.y, postfx_cbuffer_288.z, postfx_cbuffer_288.w)) / _316)) * 40.0f;
    _322 = (_271 - (dot(float4(_294, _295, _296, 1.0f), float4(postfx_cbuffer_304.x, postfx_cbuffer_304.y, postfx_cbuffer_304.z, postfx_cbuffer_304.w)) / _316)) * -22.5f;
    _323 = dot(float2(_321, _322), float2(_321, _322));
    _324 = (_323 > 1.0f);
    _325 = rsqrt(_323);
    _331 = (postfx_cbuffer_256.x * 0.012500000186264515f) * select(_324, (_325 * _321), _321);
    _333 = (postfx_cbuffer_256.x * 0.02222222276031971f) * select(_324, (_322 * _325), _322);
    _334 = _267 * _243;
    _335 = _267 * _244;
    _336 = _267 * _245;
    do {
      _407 = _334;
      _408 = _335;
      _409 = _336;
      _410 = _267;
      if ((int)int(postfx_cbuffer_272.x) > (int)1) {
        _355 = _334;
        _356 = _335;
        _357 = _336;
        _358 = _267;
        _359 = 1;
        bool _loop_break_0 = false;
        while (true) {
          _361 = float((int)(_359)) + (((((float4)(t28_space1.Sample(s6_space1, float2(((_243 * 8.0f) + (_79 * 58.16400146484375f)), ((_244 * 8.0f) + (_80 * 47.130001068115234f)))))).x) + -0.5f) * 0.5f);
          _375 = (round((((_331 * postfx_cbuffer_272.y) * _361) + _79) * misc_globals_240.x) + 0.5f) / misc_globals_240.x;
          _376 = (round((((_333 * postfx_cbuffer_272.y) * _361) + _80) * misc_globals_240.y) + 0.5f) / misc_globals_240.y;
          _388 = select(((((float)((uint)((uint)(((uint2)(t18_space1.Load(int3(int(misc_globals_240.x * _375), int(misc_globals_240.y * _376), 0)))).y)))) * 0.003921568859368563f) > postfx_cbuffer_896), 0.0f, 1.0f);
          _389 = t19_space1.SampleLevel(s1_space1, float2(_375, _376), 0.0f);
          _396 = (_389.x * _388) + _355;
          _397 = (_389.y * _388) + _356;
          _398 = (_389.z * _388) + _357;
          _399 = _388 + _358;
          _400 = _359 + 1;
          do {
            if ((int)_400 < (int)int(postfx_cbuffer_272.x)) {
              _355 = _396;
              _356 = _397;
              _357 = _398;
              _358 = _399;
              _359 = _400;
              _loop_break_0 = true;
              break;
            }
            _407 = _396;
            _408 = _397;
            _409 = _398;
            _410 = _399;
          } while (false);
          if (_loop_break_0) {
            _loop_break_0 = false;
            continue;
          }
          break;
        }
      }
      _411 = max(_410, 0.10000000149011612f);
      _418 = saturate(dot(float2(_331, _333), float2(_331, _333)) * 1e+05f) * _267;
      _890 = ((_418 * ((_407 / _411) - _243)) + _243);
      _891 = ((_418 * ((_408 / _411) - _244)) + _244);
      _892 = ((_418 * ((_409 / _411) - _245)) + _245);
    } while (false);
  } else {
    if (_248 == 2) {
      _436 = t23_space1.SampleLevel(s0_space1, float2((postfx_cbuffer_1408.x * _79), (postfx_cbuffer_1408.y * _80)), 0.0f);
      do {
        _630 = 0.0f;
        _631 = 0.0f;
        _632 = 0.0f;
        _633 = 0.0f;
        [branch]
        if ((_436.z >= 1.0f) && (_436.w < 2.0f)) {
          _445 = t22_space1.SampleLevel(s0_space1, float2(_79, _80), 0.0f);
          _450 = postfx_cbuffer_256.x * _445.x;
          _451 = postfx_cbuffer_256.x * _445.y;
          _460 = min(_436.z, 2.0f);
          _465 = int(min(2.0f, (_460 + 1.0f)));
          _469 = postfx_cbuffer_1152.x * (_460 * (_436.x / _436.z));
          _470 = postfx_cbuffer_1152.y * (_460 * (_436.y / _436.z));
          _472 = float((int)(_465)) + -0.5f;
          _473 = _472 / _460;
          _490 = ((((((float)((uint)((uint)((int)(uint(SV_Position.y)) & 1)))) * 2.0f) + -1.0f) * ((((float)((uint)((uint)((int)(uint(SV_Position.x)) & 1)))) * 2.0f) + -1.0f)) * postfx_cbuffer_256.w) * saturate((_460 + -2.0f) * 0.5f);
          do {
            _619 = 0.0f;
            _620 = 0.0f;
            _621 = 0.0f;
            _622 = 0.0f;
            if ((int)_465 > (int)0) {
              _496 = 0.0f;
              _497 = 0.0f;
              _498 = 0.0f;
              _499 = 0.0f;
              _500 = 0;
              bool _loop_break_1 = false;
              while (true) {
                _501 = float((int)(_500));
                _502 = (_490 + 0.5f) + _501;
                _503 = _502 / _472;
                _506 = (_469 * _503) + _79;
                _507 = (_470 * _503) + _80;
                _508 = t22_space1.SampleLevel(s0_space1, float2(_506, _507), 0.0f);
                _513 = postfx_cbuffer_256.x * _508.x;
                _514 = postfx_cbuffer_256.x * _508.y;
                _520 = min(sqrt((_513 * _513) + (_514 * _514)), postfx_cbuffer_256.z);
                _528 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.SampleLevel(s0_space1, float2(_506, _507), 0.0f)).x)) + postfx_cbuffer_000.w);
                _534 = _473 * min(sqrt((_450 * _450) + (_451 * _451)), postfx_cbuffer_256.z);
                _535 = _528 - _39;
                _541 = max((_502 + -1.0f), 0.0f);
                _548 = t19_space1.SampleLevel(s1_space1, float2(_506, _507), 0.0f);
                _552 = _501 + (0.5f - _490);
                _553 = _552 / _472;
                _556 = _79 - (_469 * _553);
                _557 = _80 - (_470 * _553);
                _558 = t22_space1.SampleLevel(s0_space1, float2(_556, _557), 0.0f);
                _561 = postfx_cbuffer_256.x * _558.x;
                _562 = postfx_cbuffer_256.x * _558.y;
                _567 = min(sqrt((_561 * _561) + (_562 * _562)), postfx_cbuffer_256.z);
                _572 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.SampleLevel(s0_space1, float2(_556, _557), 0.0f)).x)) + postfx_cbuffer_000.w);
                _578 = _572 - _39;
                _584 = max((_552 + -1.0f), 0.0f);
                _590 = dot(float2(saturate(_578 + 0.5f), saturate(0.5f - _578)), float2(saturate(_534 - _584), saturate((_567 * _473) - _584))) * (1.0f - saturate((1.0f - _567) * 8.0f));
                _591 = t19_space1.SampleLevel(s1_space1, float2(_556, _557), 0.0f);
                _595 = (_528 > _572);
                _596 = (_567 > _520);
                _598 = select((_596 && _595), _590, (dot(float2(saturate(_535 + 0.5f), saturate(0.5f - _535)), float2(saturate(_534 - _541), saturate((_520 * _473) - _541))) * (1.0f - saturate((1.0f - _520) * 8.0f))));
                _600 = select((_596 || _595), _590, _598);
                _608 = ((_598 * _548.x) + _496) + (_591.x * _600);
                _610 = ((_598 * _548.y) + _497) + (_591.y * _600);
                _612 = ((_598 * _548.z) + _498) + (_591.z * _600);
                _614 = (_598 + _499) + _600;
                _615 = _500 + 1;
                do {
                  if (!(_615 == _465)) {
                    _496 = _608;
                    _497 = _610;
                    _498 = _612;
                    _499 = _614;
                    _500 = _615;
                    _loop_break_1 = true;
                    break;
                  }
                  _619 = _608;
                  _620 = _610;
                  _621 = _612;
                  _622 = _614;
                } while (false);
                if (_loop_break_1) {
                  _loop_break_1 = false;
                  continue;
                }
                break;
              }
            }
            _624 = float((int)(_465 << 1));
            _630 = (_619 / _624);
            _631 = (_620 / _624);
            _632 = (_621 / _624);
            _633 = (_622 / _624);
          } while (false);
        }
        _634 = 1.0f - _633;
        _641 = t20_space1.SampleLevel(s1_space1, float2(_79, _80), 0.0f);
        _646 = 1.0f - _641.w;
        _890 = ((_646 * ((_634 * _243) + _630)) + _641.x);
        _891 = ((_646 * ((_634 * _244) + _631)) + _641.y);
        _892 = ((_646 * ((_634 * _245) + _632)) + _641.z);
      } while (false);
    } else {
      if (_248 == 3) {
        _661 = t23_space1.SampleLevel(s0_space1, float2((postfx_cbuffer_1408.x * _79), (postfx_cbuffer_1408.y * _80)), 0.0f);
        do {
          _866 = 0.0f;
          _867 = 0.0f;
          _868 = 0.0f;
          _869 = 0.0f;
          [branch]
          if ((_661.z >= 1.0f) && (_661.w < 2.0f)) {
            _670 = t22_space1.SampleLevel(s0_space1, float2(_79, _80), 0.0f);
            _680 = t19_space1.Load(int3(int(misc_globals_240.x * _79), int(misc_globals_240.y * _80), 0));
            _684 = postfx_cbuffer_256.x * _670.x;
            _685 = postfx_cbuffer_256.x * _670.y;
            _694 = min(_661.z, 2.0f);
            _699 = int(min(2.0f, (_694 + 1.0f)));
            _703 = postfx_cbuffer_1152.x * (_694 * (_661.x / _661.z));
            _704 = postfx_cbuffer_1152.y * (_694 * (_661.y / _661.z));
            _706 = float((int)(_699)) + -0.5f;
            _707 = _706 / _694;
            _724 = ((((((float)((uint)((uint)((int)(uint(SV_Position.y)) & 1)))) * 2.0f) + -1.0f) * ((((float)((uint)((uint)((int)(uint(SV_Position.x)) & 1)))) * 2.0f) + -1.0f)) * postfx_cbuffer_256.w) * saturate((_694 + -2.0f) * 0.5f);
            do {
              _855 = 0.0f;
              _856 = 0.0f;
              _857 = 0.0f;
              _858 = 0.0f;
              if ((int)_699 > (int)0) {
                _730 = 0.0f;
                _731 = 0.0f;
                _732 = 0.0f;
                _733 = 0.0f;
                _734 = 0;
                bool _loop_break_2 = false;
                while (true) {
                  _735 = float((int)(_734));
                  _736 = (_724 + 0.5f) + _735;
                  _737 = _736 / _706;
                  _740 = (_703 * _737) + _79;
                  _741 = (_704 * _737) + _80;
                  _742 = t22_space1.SampleLevel(s0_space1, float2(_740, _741), 0.0f);
                  _747 = postfx_cbuffer_256.x * _742.x;
                  _748 = postfx_cbuffer_256.x * _742.y;
                  _754 = min(sqrt((_747 * _747) + (_748 * _748)), postfx_cbuffer_256.z);
                  _762 = t19_space1.Load(int3(int(misc_globals_240.x * _740), int(misc_globals_240.y * _741), 0));
                  _769 = _707 * min(sqrt((_684 * _684) + (_685 * _685)), postfx_cbuffer_256.z);
                  _770 = _762.w - _680.w;
                  _776 = max((_736 + -1.0f), 0.0f);
                  _783 = t19_space1.SampleLevel(s1_space1, float2(_740, _741), 0.0f);
                  _787 = _735 + (0.5f - _724);
                  _788 = _787 / _706;
                  _791 = _79 - (_703 * _788);
                  _792 = _80 - (_704 * _788);
                  _793 = t22_space1.SampleLevel(s0_space1, float2(_791, _792), 0.0f);
                  _796 = postfx_cbuffer_256.x * _793.x;
                  _797 = postfx_cbuffer_256.x * _793.y;
                  _802 = min(sqrt((_796 * _796) + (_797 * _797)), postfx_cbuffer_256.z);
                  _807 = t19_space1.Load(int3(int(misc_globals_240.x * _791), int(misc_globals_240.y * _792), 0));
                  _814 = _807.w - _680.w;
                  _820 = max((_787 + -1.0f), 0.0f);
                  _826 = dot(float2(saturate(_814 + 0.5f), saturate(0.5f - _814)), float2(saturate(_769 - _820), saturate((_802 * _707) - _820))) * (1.0f - saturate((1.0f - _802) * 8.0f));
                  _827 = t19_space1.SampleLevel(s1_space1, float2(_791, _792), 0.0f);
                  _831 = (_762.w > _807.w);
                  _832 = (_802 > _754);
                  _834 = select((_832 && _831), _826, (dot(float2(saturate(_770 + 0.5f), saturate(0.5f - _770)), float2(saturate(_769 - _776), saturate((_754 * _707) - _776))) * (1.0f - saturate((1.0f - _754) * 8.0f))));
                  _836 = select((_832 || _831), _826, _834);
                  _844 = ((_834 * _783.x) + _730) + (_827.x * _836);
                  _846 = ((_834 * _783.y) + _731) + (_827.y * _836);
                  _848 = ((_834 * _783.z) + _732) + (_827.z * _836);
                  _850 = (_834 + _733) + _836;
                  _851 = _734 + 1;
                  do {
                    if (!(_851 == _699)) {
                      _730 = _844;
                      _731 = _846;
                      _732 = _848;
                      _733 = _850;
                      _734 = _851;
                      _loop_break_2 = true;
                      break;
                    }
                    _855 = _844;
                    _856 = _846;
                    _857 = _848;
                    _858 = _850;
                  } while (false);
                  if (_loop_break_2) {
                    _loop_break_2 = false;
                    continue;
                  }
                  break;
                }
              }
              _860 = float((int)(_699 << 1));
              _866 = (_855 / _860);
              _867 = (_856 / _860);
              _868 = (_857 / _860);
              _869 = (_858 / _860);
            } while (false);
          }
          _870 = 1.0f - _869;
          _877 = t20_space1.SampleLevel(s1_space1, float2(_79, _80), 0.0f);
          _882 = 1.0f - _877.w;
          _890 = ((_882 * ((_870 * _243) + _866)) + _877.x);
          _891 = ((_882 * ((_870 * _244) + _867)) + _877.y);
          _892 = ((_882 * ((_870 * _245) + _868)) + _877.z);
        } while (false);
      } else {
        _890 = _243;
        _891 = _244;
        _892 = _245;
      }
    }
  }
  _893 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  _905 = (postfx_cbuffer_1024 * (_893.x - _890)) + _890;
  _906 = (postfx_cbuffer_1024 * (_893.y - _891)) + _891;
  _907 = (postfx_cbuffer_1024 * (_893.z - _892)) + _892;
  _910 = (postfx_cbuffer_112.y < 0.0f);
  _911 = select(_910, 1.0f, TEXCOORD.w);
  _912 = t25_space1.Sample(s2_space1, float2(_79, _80));
  _912 *= CUSTOM_BLOOM;
  _916 = _912.x * _911;
  _917 = _912.y * _911;
  _918 = _912.z * _911;
  if (postfx_cbuffer_1200.z > 0.0f) {
    _923 = t31_space1.Sample(s2_space1, float2(_79, _80));
    _923 = max(0.f, _923);
    _925 = _923.x * _923.x;
    _926 = _925 * _925;
    _927 = _926 * _926 * CUSTOM_SUN_BLOOM;
    _939 = ((_927 * postfx_cbuffer_736.x) + _905);
    _940 = ((_927 * postfx_cbuffer_736.y) + _906);
    _941 = ((_927 * postfx_cbuffer_736.z) + _907);
  } else {
    _939 = _905;
    _940 = _906;
    _941 = _907;
  }
  _942 = t29_space1.Sample(s3_space1, float2(TEXCOORD.x, TEXCOORD.y));
  _964 = ((((postfx_cbuffer_544.z + -1.0f) + ((postfx_cbuffer_544.w - postfx_cbuffer_544.z) * saturate((TEXCOORD.z - postfx_cbuffer_544.x) * postfx_cbuffer_544.y))) * postfx_cbuffer_560.x) + 1.0f) * postfx_cbuffer_576.w;
  _964 *= CUSTOM_LENS_FLARE;
  _968 = (_964 * _942.x) + _939;
  _969 = (_964 * _942.y) + _940;
  _970 = (_964 * _942.z) + _941;
  _979 = abs(postfx_cbuffer_112.y);
  _1001 = TEXCOORD.x + -0.5f;
  _1002 = TEXCOORD.y + -0.5f;
  _1011 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1001, _1002), float2(_1001, _1002))) * postfx_cbuffer_912.y) + postfx_cbuffer_912.x) * postfx_cbuffer_912.z);
  _1011 = lerp(1.f, _1011, CUSTOM_VIGNETTE);
  _1036 = saturate((postfx_cbuffer_224.x * TEXCOORD_1) + postfx_cbuffer_224.y);
  _1055 = ((postfx_cbuffer_192.x - postfx_cbuffer_160.x) * _1036) + postfx_cbuffer_160.x;
  _1056 = ((postfx_cbuffer_192.y - postfx_cbuffer_160.y) * _1036) + postfx_cbuffer_160.y;
  _1058 = ((postfx_cbuffer_192.w - postfx_cbuffer_160.w) * _1036) + postfx_cbuffer_160.w;
  _1073 = ((postfx_cbuffer_208.x - postfx_cbuffer_176.x) * _1036) + postfx_cbuffer_176.x;
  _1074 = ((postfx_cbuffer_208.y - postfx_cbuffer_176.y) * _1036) + postfx_cbuffer_176.y;
  _1075 = ((postfx_cbuffer_208.z - postfx_cbuffer_176.z) * _1036) + postfx_cbuffer_176.z;
  _1076 = _1075 * _1055;
  _1077 = (lerp(postfx_cbuffer_160.z, postfx_cbuffer_192.z, _1036))*_1056;
  _1080 = _1073 * _1058;
  _1084 = _1074 * _1058;
  _1087 = _1073 / _1074;
  _1089 = 1.0f / (((((_1076 + _1077) * _1075) + _1080) / (((_1076 + _1056) * _1075) + _1084)) - _1087);
  _1093 = max(0.0f, (min(((lerp(postfx_cbuffer_928.x, 1.0f, _1011)) * (_968 + select(_910, (((misc_globals_224.w * _916) - _968) * _979), ((_916 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));
  _1094 = max(0.0f, (min(((lerp(postfx_cbuffer_928.y, 1.0f, _1011)) * (_969 + select(_910, (((misc_globals_224.w * _917) - _969) * _979), ((_917 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));
  _1095 = max(0.0f, (min(((lerp(postfx_cbuffer_928.z, 1.0f, _1011)) * (_970 + select(_910, (((misc_globals_224.w * _918) - _970) * _979), ((_918 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    GTAVTonemapConfig tonemap_config = CreateGTAVTonemapConfig();
    tonemap_config.a = _1055;
    tonemap_config.b = _1056;
    tonemap_config.c_times_b = _1077;
    tonemap_config.d_times_e = _1080;
    tonemap_config.d_times_f = _1084;
    tonemap_config.e_over_f = _1087;
    tonemap_config.white_scale = _1089;
    tonemap_config.fade_to_white = postfx_cbuffer_208.w;
    tonemap_config.saturation = postfx_cbuffer_1072;
    tonemap_config.grade_a = postfx_cbuffer_1056.xyz;
    tonemap_config.grade_b = postfx_cbuffer_1040.xyz;
    tonemap_config.grade_luma_max = postfx_cbuffer_1056.w;
    tonemap_config.blend_range = postfx_cbuffer_1040.w;
    return GenerateGTAVOutput(float3(_1093, _1094, _1095), TEXCOORD.xy, SV_Position.xy, tonemap_config);
  }

  _1096 = _1093 * _1055;
  _1097 = _1094 * _1055;
  _1098 = _1095 * _1055;
  _1126 = saturate((((((_1096 + _1077) * _1093) + _1080) / (((_1096 + _1056) * _1093) + _1084)) - _1087) * _1089);
  _1127 = saturate((((((_1097 + _1077) * _1094) + _1080) / (((_1097 + _1056) * _1094) + _1084)) - _1087) * _1089);
  _1128 = saturate((((((_1098 + _1077) * _1095) + _1080) / (((_1098 + _1056) * _1095) + _1084)) - _1087) * _1089);
  _1136 = (postfx_cbuffer_208.w * (1.0f - _1126)) + _1126;
  _1137 = (postfx_cbuffer_208.w * (1.0f - _1127)) + _1127;
  _1138 = (postfx_cbuffer_208.w * (1.0f - _1128)) + _1128;
  _1139 = dot(float3(_1136, _1137, _1138), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  _1148 = ((_1136 - _1139) * postfx_cbuffer_1072) + _1139;
  _1149 = ((_1137 - _1139) * postfx_cbuffer_1072) + _1139;
  _1150 = ((_1138 - _1139) * postfx_cbuffer_1072) + _1139;
  _1154 = saturate(_1139 / postfx_cbuffer_1056.w);
  _1171 = (lerp(postfx_cbuffer_1056.x, postfx_cbuffer_1040.x, _1154))*_1148;
  _1172 = (lerp(postfx_cbuffer_1056.y, postfx_cbuffer_1040.y, _1154))*_1149;
  _1173 = (lerp(postfx_cbuffer_1056.z, postfx_cbuffer_1040.z, _1154))*_1150;
  _1179 = saturate(((_1139 + -1.0f) + postfx_cbuffer_1040.w) / max(0.009999999776482582f, postfx_cbuffer_1040.w));
  _1224 = (1.0f - (((sin((postfx_cbuffer_1008.w + TEXCOORD.y) * postfx_cbuffer_1008.y) * 0.5f) + 0.5f) * postfx_cbuffer_1008.x)) - (((sin(((postfx_cbuffer_1008.w * 0.5f) + TEXCOORD.y) * postfx_cbuffer_1008.z) * 0.5f) + 0.5f) * postfx_cbuffer_1008.x);
  _1244 = ((((float4)(t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * postfx_cbuffer_240.w) + postfx_cbuffer_240.x), frac(((TEXCOORD.y * 0.8999999761581421f) * postfx_cbuffer_240.w) + postfx_cbuffer_240.y))))).w) + -0.5f) * postfx_cbuffer_240.z;

  ConfigureVanillaGrain(_1244, _1224);

  _1251 = saturate(max(0.0f, (_1244 + (_1224 * exp2(log2(abs(saturate(lerp(_1171, _1148, _1179)))) * postfx_cbuffer_1076)))));
  _1252 = saturate(max(0.0f, (_1244 + (_1224 * exp2(log2(abs(saturate(lerp(_1172, _1149, _1179)))) * postfx_cbuffer_1076)))));
  _1253 = saturate(max(0.0f, (_1244 + (_1224 * exp2(log2(abs(saturate(lerp(_1173, _1150, _1179)))) * postfx_cbuffer_1076)))));
  if (!(asint(postfx_cbuffer_1424) == 0)) {
    _1263 = (asint(postfx_cbuffer_1472.w) != 0);
    _1265 = max(_1251, max(_1252, _1253));
    _1322 = (((t1.Load(int4(((int)(uint(SV_Position.x)) & 63), ((int)(uint(SV_Position.y)) & 63), (misc_globals_356 & 31), 0))).x) * 2.0f) + -1.0f;
    _1328 = float((int)(((int)(uint)((int)(_1322 > 0.0f))) - ((int)(uint)((int)(_1322 < 0.0f)))));
    _1332 = 1.0f - sqrt(1.0f - abs(_1322));
    _1343 = (((_1332 * (((postfx_cbuffer_1456.x - postfx_cbuffer_1440.x) * exp2(log2(saturate((select(_1263, _1251, _1265) - postfx_cbuffer_1488.x) * postfx_cbuffer_1472.x)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.x)) * _1328) + _1251);
    _1344 = (((_1332 * (((postfx_cbuffer_1456.y - postfx_cbuffer_1440.y) * exp2(log2(saturate((select(_1263, _1252, _1265) - postfx_cbuffer_1488.y) * postfx_cbuffer_1472.y)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.y)) * _1328) + _1252);
    _1345 = (((_1332 * (((postfx_cbuffer_1456.z - postfx_cbuffer_1440.z) * exp2(log2(saturate((select(_1263, _1253, _1265) - postfx_cbuffer_1488.z) * postfx_cbuffer_1472.z)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.z)) * _1328) + _1253);

    ConfigureVanillaDithering(
        _1251, _1252, _1253,
        _1343, _1344, _1345);
  } else {
    _1343 = _1251;
    _1344 = _1252;
    _1345 = _1253;
  }
  SV_Target.x = _1343;
  SV_Target.y = _1344;
  SV_Target.z = _1345;
  SV_Target.w = dot(float3(_1251, _1252, _1253), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / postfx_cbuffer_1076));
  return SV_Target;
}

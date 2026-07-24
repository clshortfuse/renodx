#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

Texture2D<float4> t14_space1 : register(t14, space1);

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
  float _40;
  float _50;
  float _57;
  float _58;
  float _59;
  float _60;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _74;
  float _75;
  float _78;
  float _79;
  float _80;
  float _81;
  float _82;
  float _83;
  float _84;
  float _85;
  float _86;
  float _87;
  float _92;
  float _93;
  float _105;
  float _107;
  float _109;
  float _112;
  float _124;
  float _125;
  float _128;
  float _129;
  float _130;
  float _131;
  float _132;
  float _136;
  float4 _141;
  float4 _150;
  float4 _161;
  float4 _172;
  float4 _183;
  float _192;
  float _193;
  float _201;
  float _202;
  float _208;
  float _221;
  float _302;
  float _303;
  float _304;
  float _414;
  float _415;
  float _416;
  float _417;
  int _418;
  float _466;
  float _467;
  float _468;
  float _469;
  float _555;
  float _556;
  float _557;
  float _558;
  int _559;
  float _678;
  float _679;
  float _680;
  float _681;
  float _689;
  float _690;
  float _691;
  float _692;
  float _789;
  float _790;
  float _791;
  float _792;
  int _793;
  float _914;
  float _915;
  float _916;
  float _917;
  float _925;
  float _926;
  float _927;
  float _928;
  float _949;
  float _950;
  float _951;
  float _998;
  float _999;
  float _1000;
  float _1402;
  float _1403;
  float _1404;
  float4 _226;
  float4 _230;
  float4 _234;
  float _265;
  float _272;
  float _275;
  float _276;
  float _277;
  float _278;
  float _279;
  int _307;
  float _326;
  float _329;
  float _330;
  float _353;
  float _354;
  float _355;
  float _373;
  float _375;
  float _380;
  float _381;
  float _382;
  bool _383;
  float _384;
  float _390;
  float _392;
  float _393;
  float _394;
  float _395;
  float _420;
  float _434;
  float _435;
  float _447;
  float4 _448;
  float _455;
  float _456;
  float _457;
  float _458;
  int _459;
  float _470;
  float _477;
  float4 _495;
  float2 _504;
  float _509;
  float _510;
  float _519;
  int _524;
  float _528;
  float _529;
  float _531;
  float _532;
  float _549;
  float _560;
  float _561;
  float _562;
  float _565;
  float _566;
  float2 _567;
  float _572;
  float _573;
  float _579;
  float _587;
  float _593;
  float _594;
  float _600;
  float4 _607;
  float _611;
  float _612;
  float _615;
  float _616;
  float2 _617;
  float _620;
  float _621;
  float _626;
  float _631;
  float _637;
  float _643;
  float _649;
  float4 _650;
  bool _654;
  bool _655;
  float _657;
  float _659;
  float _667;
  float _669;
  float _671;
  float _673;
  int _674;
  float _683;
  float _693;
  float4 _700;
  float _705;
  float4 _720;
  float2 _729;
  float4 _739;
  float _743;
  float _744;
  float _753;
  int _758;
  float _762;
  float _763;
  float _765;
  float _766;
  float _783;
  float _794;
  float _795;
  float _796;
  float _799;
  float _800;
  float2 _801;
  float _806;
  float _807;
  float _813;
  float4 _821;
  float _828;
  float _829;
  float _835;
  float4 _842;
  float _846;
  float _847;
  float _850;
  float _851;
  float2 _852;
  float _855;
  float _856;
  float _861;
  float4 _866;
  float _873;
  float _879;
  float _885;
  float4 _886;
  bool _890;
  bool _891;
  float _893;
  float _895;
  float _903;
  float _905;
  float _907;
  float _909;
  int _910;
  float _919;
  float _929;
  float4 _936;
  float _941;
  float4 _952;
  float _964;
  float _965;
  float _966;
  bool _969;
  float _970;
  float4 _971;
  float _975;
  float _976;
  float _977;
  float4 _982;
  float _984;
  float _985;
  float _986;
  float4 _1001;
  float _1023;
  float _1027;
  float _1028;
  float _1029;
  float _1038;
  float _1060;
  float _1061;
  float _1070;
  float _1095;
  float _1114;
  float _1115;
  float _1117;
  float _1132;
  float _1133;
  float _1134;
  float _1135;
  float _1136;
  float _1139;
  float _1143;
  float _1146;
  float _1148;
  float _1152;
  float _1153;
  float _1154;
  float _1155;
  float _1156;
  float _1157;
  float _1185;
  float _1186;
  float _1187;
  float _1195;
  float _1196;
  float _1197;
  float _1198;
  float _1207;
  float _1208;
  float _1209;
  float _1213;
  float _1230;
  float _1231;
  float _1232;
  float _1238;
  float _1283;
  float _1303;
  float _1310;
  float _1311;
  float _1312;
  bool _1322;
  float _1324;
  float _1381;
  float _1387;
  float _1391;
  _40 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y))).x)) + postfx_cbuffer_000.w);
  _50 = min(max((1.0f - saturate(((postfx_cbuffer_1152.z / postfx_cbuffer_1152.w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  _57 = TEXCOORD.x + -0.5f;
  _58 = TEXCOORD.y + -0.5f;
  _59 = (postfx_cbuffer_1152.x / postfx_cbuffer_1152.y) * _57;
  _60 = dot(float2(_59, _58), float2(_59, _58));
  _66 = CUSTOM_LENS_DISTORTION * ((_50 * _60) * ((sqrt(_60) * postfx_cbuffer_1104.y) + postfx_cbuffer_1104.x)) + 1.0f;
  _67 = _66 * _57;
  _68 = _66 * _58;
  _69 = _67 + 0.5f;
  _70 = _68 + 0.5f;
  _74 = _69 * misc_globals_240.x;
  _75 = _70 * misc_globals_240.y;
  _78 = floor(_74 + -0.5f);
  _79 = floor(_75 + -0.5f);
  _80 = _78 + 0.5f;
  _81 = _79 + 0.5f;
  _82 = _74 - _80;
  _83 = _75 - _81;
  _84 = _82 * _82;
  _85 = _83 * _83;
  _86 = _84 * _82;
  _87 = _85 * _83;
  _92 = _84 - ((_86 + _82) * 0.5f);
  _93 = _85 - ((_87 + _83) * 0.5f);
  _105 = (_82 * 0.5f) * (_84 - _82);
  _107 = (_83 * 0.5f) * (_85 - _83);
  _109 = (1.0f - _105) - _92;
  _112 = (1.0f - _107) - _93;
  _124 = (((_109 - (((_86 * 1.5f) - (_84 * 2.5f)) + 1.0f)) / _109) + _80) / misc_globals_240.x;
  _125 = (((_112 - (((_87 * 1.5f) - (_85 * 2.5f)) + 1.0f)) / _112) + _81) / misc_globals_240.y;
  _128 = _109 * _93;
  _129 = _112 * _92;
  _130 = _109 * _112;
  _131 = _112 * _105;
  _132 = _109 * _107;
  _136 = (((_128 + _129) + _130) + _131) + _132;
  _141 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_124, ((_79 + -0.5f) / misc_globals_240.y)), 0.0f);
  _150 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(((_78 + -0.5f) / misc_globals_240.x), _125), 0.0f);
  _161 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_124, _125), 0.0f);
  _172 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(((_78 + 2.5f) / misc_globals_240.x), _125), 0.0f);
  _183 = t15_space1.SampleLevel(s0_space2[((uint)(g_rage_dynamicsamplerindices_016) + 0u)], float2(_124, ((_79 + 2.5f) / misc_globals_240.y)), 0.0f);
  _192 = max(0.0f, ((((((_150.y * _129) + (_141.y * _128)) + (_161.y * _130)) + (_172.y * _131)) + (_183.y * _132)) / _136));
  _193 = max(0.0f, ((((((_150.z * _129) + (_141.z * _128)) + (_161.z * _130)) + (_172.z * _131)) + (_183.z * _132)) / _136));
  _201 = (postfx_cbuffer_1152.x / postfx_cbuffer_1152.y) * _67;
  _202 = dot(float2(_201, _68), float2(_201, _68));
  _208 = CUSTOM_CHROMATIC_ABERRATION * ((_50 * _202) * ((sqrt(_202) * postfx_cbuffer_1104.w) + postfx_cbuffer_1104.z)) + 1.0f;
  _221 = misc_globals_224.w * (((float4)(t15_space1.Sample(s0_space2[((uint)(g_rage_dynamicsamplerindices_012) + 0u)], float2(((_208 * _67) + 0.5f), ((_208 * _68) + 0.5f))))).x);
  if (!(postfx_cbuffer_1360 > 0.0f)) {
    _226 = t19_space1.Sample(s1_space1, float2(_69, _70));
    _230 = t14_space1.Sample(s2_space1, float2(_69, _70));
    _234 = t30_space1.Sample(s2_space1, float2(_69, _70));
    _265 = max(saturate(1.0f - ((_40 - postfx_cbuffer_048.x) * postfx_cbuffer_048.y)), saturate((_40 - postfx_cbuffer_048.z) * postfx_cbuffer_048.w));
    _272 = saturate(1.0f - (_265 * 499.9999694824219f));
    _275 = 1.0f - _272;
    _276 = min(saturate(0.5015197396278381f - (_265 * 0.5065855979919434f)), _275);
    _277 = _275 - _276;
    _278 = min(saturate(100.0f - (_265 * 100.0f)), _277);
    _279 = _277 - _278;
    _302 = ((((_276 * _226.x) + (_272 * _221)) + (_278 * ((_230.x * 0.699999988079071f) + (_226.x * 0.30000001192092896f)))) + (((_234.x + _230.x) * 0.5f) * _279));
    _303 = ((((_276 * _226.y) + (_272 * _192)) + (_278 * ((_230.y * 0.699999988079071f) + (_226.y * 0.30000001192092896f)))) + (((_234.y + _230.y) * 0.5f) * _279));
    _304 = ((((_276 * _226.z) + (_272 * _193)) + (_278 * ((_230.z * 0.699999988079071f) + (_226.z * 0.30000001192092896f)))) + (((_234.z + _230.z) * 0.5f) * _279));
  } else {
    _302 = _221;
    _303 = _192;
    _304 = _193;
  }
  _307 = int(postfx_cbuffer_272.z);
  if (_307 == 1) {
    _326 = select(((((float)((uint)((uint)(((uint2)(t18_space1.Load(int3(int(misc_globals_240.x * _69), int(misc_globals_240.y * _70), 0)))).y)))) * 0.003921568859368563f) > postfx_cbuffer_896), 0.0f, 1.0f);
    _329 = (_69 * 2.0f) + -1.0f;
    _330 = 1.0f - (_70 * 2.0f);
    _353 = (g_rage_matrices_192[3].x) + (dot(float3(_329, _330, 1.0f), float3(postfx_cbuffer_336.x, postfx_cbuffer_336.y, postfx_cbuffer_336.z)) * _40);
    _354 = (g_rage_matrices_192[3].y) + (dot(float3(_329, _330, 1.0f), float3(postfx_cbuffer_352.x, postfx_cbuffer_352.y, postfx_cbuffer_352.z)) * _40);
    _355 = (g_rage_matrices_192[3].z) + (dot(float3(_329, _330, 1.0f), float3(postfx_cbuffer_368.x, postfx_cbuffer_368.y, postfx_cbuffer_368.z)) * _40);
    _373 = dot(float4(_353, _354, _355, 1.0f), float4(postfx_cbuffer_320.x, postfx_cbuffer_320.y, postfx_cbuffer_320.z, postfx_cbuffer_320.w));
    _375 = select((_373 == 0.0f), 9.999999747378752e-06f, _373);
    _380 = (_329 - (dot(float4(_353, _354, _355, 1.0f), float4(postfx_cbuffer_288.x, postfx_cbuffer_288.y, postfx_cbuffer_288.z, postfx_cbuffer_288.w)) / _375)) * 40.0f;
    _381 = (_330 - (dot(float4(_353, _354, _355, 1.0f), float4(postfx_cbuffer_304.x, postfx_cbuffer_304.y, postfx_cbuffer_304.z, postfx_cbuffer_304.w)) / _375)) * -22.5f;
    _382 = dot(float2(_380, _381), float2(_380, _381));
    _383 = (_382 > 1.0f);
    _384 = rsqrt(_382);
    _390 = (postfx_cbuffer_256.x * 0.012500000186264515f) * select(_383, (_384 * _380), _380);
    _392 = (postfx_cbuffer_256.x * 0.02222222276031971f) * select(_383, (_381 * _384), _381);
    _393 = _326 * _302;
    _394 = _326 * _303;
    _395 = _326 * _304;
    do {
      _466 = _393;
      _467 = _394;
      _468 = _395;
      _469 = _326;
      if ((int)int(postfx_cbuffer_272.x) > (int)1) {
        _414 = _393;
        _415 = _394;
        _416 = _395;
        _417 = _326;
        _418 = 1;
        bool _loop_break_0 = false;
        while (true) {
          _420 = float((int)(_418)) + (((((float4)(t28_space1.Sample(s6_space1, float2(((_302 * 8.0f) + (_69 * 58.16400146484375f)), ((_303 * 8.0f) + (_70 * 47.130001068115234f)))))).x) + -0.5f) * 0.5f);
          _434 = (round((((_390 * postfx_cbuffer_272.y) * _420) + _69) * misc_globals_240.x) + 0.5f) / misc_globals_240.x;
          _435 = (round((((_392 * postfx_cbuffer_272.y) * _420) + _70) * misc_globals_240.y) + 0.5f) / misc_globals_240.y;
          _447 = select(((((float)((uint)((uint)(((uint2)(t18_space1.Load(int3(int(misc_globals_240.x * _434), int(misc_globals_240.y * _435), 0)))).y)))) * 0.003921568859368563f) > postfx_cbuffer_896), 0.0f, 1.0f);
          _448 = t19_space1.SampleLevel(s1_space1, float2(_434, _435), 0.0f);
          _455 = (_448.x * _447) + _414;
          _456 = (_448.y * _447) + _415;
          _457 = (_448.z * _447) + _416;
          _458 = _447 + _417;
          _459 = _418 + 1;
          do {
            if ((int)_459 < (int)int(postfx_cbuffer_272.x)) {
              _414 = _455;
              _415 = _456;
              _416 = _457;
              _417 = _458;
              _418 = _459;
              _loop_break_0 = true;
              break;
            }
            _466 = _455;
            _467 = _456;
            _468 = _457;
            _469 = _458;
          } while (false);
          if (_loop_break_0) {
            _loop_break_0 = false;
            continue;
          }
          break;
        }
      }
      _470 = max(_469, 0.10000000149011612f);
      _477 = saturate(dot(float2(_390, _392), float2(_390, _392)) * 1e+05f) * _326;
      _949 = ((_477 * ((_466 / _470) - _302)) + _302);
      _950 = ((_477 * ((_467 / _470) - _303)) + _303);
      _951 = ((_477 * ((_468 / _470) - _304)) + _304);
    } while (false);
  } else {
    if (_307 == 2) {
      _495 = t23_space1.SampleLevel(s0_space1, float2((postfx_cbuffer_1408.x * _69), (postfx_cbuffer_1408.y * _70)), 0.0f);
      do {
        _689 = 0.0f;
        _690 = 0.0f;
        _691 = 0.0f;
        _692 = 0.0f;
        [branch]
        if ((_495.z >= 1.0f) && (_495.w < 2.0f)) {
          _504 = t22_space1.SampleLevel(s0_space1, float2(_69, _70), 0.0f);
          _509 = postfx_cbuffer_256.x * _504.x;
          _510 = postfx_cbuffer_256.x * _504.y;
          _519 = min(_495.z, 2.0f);
          _524 = int(min(2.0f, (_519 + 1.0f)));
          _528 = postfx_cbuffer_1152.x * (_519 * (_495.x / _495.z));
          _529 = postfx_cbuffer_1152.y * (_519 * (_495.y / _495.z));
          _531 = float((int)(_524)) + -0.5f;
          _532 = _531 / _519;
          _549 = ((((((float)((uint)((uint)((int)(uint(SV_Position.y)) & 1)))) * 2.0f) + -1.0f) * ((((float)((uint)((uint)((int)(uint(SV_Position.x)) & 1)))) * 2.0f) + -1.0f)) * postfx_cbuffer_256.w) * saturate((_519 + -2.0f) * 0.5f);
          do {
            _678 = 0.0f;
            _679 = 0.0f;
            _680 = 0.0f;
            _681 = 0.0f;
            if ((int)_524 > (int)0) {
              _555 = 0.0f;
              _556 = 0.0f;
              _557 = 0.0f;
              _558 = 0.0f;
              _559 = 0;
              bool _loop_break_1 = false;
              while (true) {
                _560 = float((int)(_559));
                _561 = (_549 + 0.5f) + _560;
                _562 = _561 / _531;
                _565 = (_528 * _562) + _69;
                _566 = (_529 * _562) + _70;
                _567 = t22_space1.SampleLevel(s0_space1, float2(_565, _566), 0.0f);
                _572 = postfx_cbuffer_256.x * _567.x;
                _573 = postfx_cbuffer_256.x * _567.y;
                _579 = min(sqrt((_572 * _572) + (_573 * _573)), postfx_cbuffer_256.z);
                _587 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.SampleLevel(s0_space1, float2(_565, _566), 0.0f)).x)) + postfx_cbuffer_000.w);
                _593 = _532 * min(sqrt((_509 * _509) + (_510 * _510)), postfx_cbuffer_256.z);
                _594 = _587 - _40;
                _600 = max((_561 + -1.0f), 0.0f);
                _607 = t19_space1.SampleLevel(s1_space1, float2(_565, _566), 0.0f);
                _611 = _560 + (0.5f - _549);
                _612 = _611 / _531;
                _615 = _69 - (_528 * _612);
                _616 = _70 - (_529 * _612);
                _617 = t22_space1.SampleLevel(s0_space1, float2(_615, _616), 0.0f);
                _620 = postfx_cbuffer_256.x * _617.x;
                _621 = postfx_cbuffer_256.x * _617.y;
                _626 = min(sqrt((_620 * _620) + (_621 * _621)), postfx_cbuffer_256.z);
                _631 = postfx_cbuffer_000.z / ((1.0f - ((t11_space1.SampleLevel(s0_space1, float2(_615, _616), 0.0f)).x)) + postfx_cbuffer_000.w);
                _637 = _631 - _40;
                _643 = max((_611 + -1.0f), 0.0f);
                _649 = dot(float2(saturate(_637 + 0.5f), saturate(0.5f - _637)), float2(saturate(_593 - _643), saturate((_626 * _532) - _643))) * (1.0f - saturate((1.0f - _626) * 8.0f));
                _650 = t19_space1.SampleLevel(s1_space1, float2(_615, _616), 0.0f);
                _654 = (_587 > _631);
                _655 = (_626 > _579);
                _657 = select((_655 && _654), _649, (dot(float2(saturate(_594 + 0.5f), saturate(0.5f - _594)), float2(saturate(_593 - _600), saturate((_579 * _532) - _600))) * (1.0f - saturate((1.0f - _579) * 8.0f))));
                _659 = select((_655 || _654), _649, _657);
                _667 = ((_657 * _607.x) + _555) + (_650.x * _659);
                _669 = ((_657 * _607.y) + _556) + (_650.y * _659);
                _671 = ((_657 * _607.z) + _557) + (_650.z * _659);
                _673 = (_657 + _558) + _659;
                _674 = _559 + 1;
                do {
                  if (!(_674 == _524)) {
                    _555 = _667;
                    _556 = _669;
                    _557 = _671;
                    _558 = _673;
                    _559 = _674;
                    _loop_break_1 = true;
                    break;
                  }
                  _678 = _667;
                  _679 = _669;
                  _680 = _671;
                  _681 = _673;
                } while (false);
                if (_loop_break_1) {
                  _loop_break_1 = false;
                  continue;
                }
                break;
              }
            }
            _683 = float((int)(_524 << 1));
            _689 = (_678 / _683);
            _690 = (_679 / _683);
            _691 = (_680 / _683);
            _692 = (_681 / _683);
          } while (false);
        }
        _693 = 1.0f - _692;
        _700 = t20_space1.SampleLevel(s1_space1, float2(_69, _70), 0.0f);
        _705 = 1.0f - _700.w;
        _949 = ((_705 * ((_693 * _302) + _689)) + _700.x);
        _950 = ((_705 * ((_693 * _303) + _690)) + _700.y);
        _951 = ((_705 * ((_693 * _304) + _691)) + _700.z);
      } while (false);
    } else {
      if (_307 == 3) {
        _720 = t23_space1.SampleLevel(s0_space1, float2((postfx_cbuffer_1408.x * _69), (postfx_cbuffer_1408.y * _70)), 0.0f);
        do {
          _925 = 0.0f;
          _926 = 0.0f;
          _927 = 0.0f;
          _928 = 0.0f;
          [branch]
          if ((_720.z >= 1.0f) && (_720.w < 2.0f)) {
            _729 = t22_space1.SampleLevel(s0_space1, float2(_69, _70), 0.0f);
            _739 = t19_space1.Load(int3(int(misc_globals_240.x * _69), int(misc_globals_240.y * _70), 0));
            _743 = postfx_cbuffer_256.x * _729.x;
            _744 = postfx_cbuffer_256.x * _729.y;
            _753 = min(_720.z, 2.0f);
            _758 = int(min(2.0f, (_753 + 1.0f)));
            _762 = postfx_cbuffer_1152.x * (_753 * (_720.x / _720.z));
            _763 = postfx_cbuffer_1152.y * (_753 * (_720.y / _720.z));
            _765 = float((int)(_758)) + -0.5f;
            _766 = _765 / _753;
            _783 = ((((((float)((uint)((uint)((int)(uint(SV_Position.y)) & 1)))) * 2.0f) + -1.0f) * ((((float)((uint)((uint)((int)(uint(SV_Position.x)) & 1)))) * 2.0f) + -1.0f)) * postfx_cbuffer_256.w) * saturate((_753 + -2.0f) * 0.5f);
            do {
              _914 = 0.0f;
              _915 = 0.0f;
              _916 = 0.0f;
              _917 = 0.0f;
              if ((int)_758 > (int)0) {
                _789 = 0.0f;
                _790 = 0.0f;
                _791 = 0.0f;
                _792 = 0.0f;
                _793 = 0;
                bool _loop_break_2 = false;
                while (true) {
                  _794 = float((int)(_793));
                  _795 = (_783 + 0.5f) + _794;
                  _796 = _795 / _765;
                  _799 = (_762 * _796) + _69;
                  _800 = (_763 * _796) + _70;
                  _801 = t22_space1.SampleLevel(s0_space1, float2(_799, _800), 0.0f);
                  _806 = postfx_cbuffer_256.x * _801.x;
                  _807 = postfx_cbuffer_256.x * _801.y;
                  _813 = min(sqrt((_806 * _806) + (_807 * _807)), postfx_cbuffer_256.z);
                  _821 = t19_space1.Load(int3(int(misc_globals_240.x * _799), int(misc_globals_240.y * _800), 0));
                  _828 = _766 * min(sqrt((_743 * _743) + (_744 * _744)), postfx_cbuffer_256.z);
                  _829 = _821.w - _739.w;
                  _835 = max((_795 + -1.0f), 0.0f);
                  _842 = t19_space1.SampleLevel(s1_space1, float2(_799, _800), 0.0f);
                  _846 = _794 + (0.5f - _783);
                  _847 = _846 / _765;
                  _850 = _69 - (_762 * _847);
                  _851 = _70 - (_763 * _847);
                  _852 = t22_space1.SampleLevel(s0_space1, float2(_850, _851), 0.0f);
                  _855 = postfx_cbuffer_256.x * _852.x;
                  _856 = postfx_cbuffer_256.x * _852.y;
                  _861 = min(sqrt((_855 * _855) + (_856 * _856)), postfx_cbuffer_256.z);
                  _866 = t19_space1.Load(int3(int(misc_globals_240.x * _850), int(misc_globals_240.y * _851), 0));
                  _873 = _866.w - _739.w;
                  _879 = max((_846 + -1.0f), 0.0f);
                  _885 = dot(float2(saturate(_873 + 0.5f), saturate(0.5f - _873)), float2(saturate(_828 - _879), saturate((_861 * _766) - _879))) * (1.0f - saturate((1.0f - _861) * 8.0f));
                  _886 = t19_space1.SampleLevel(s1_space1, float2(_850, _851), 0.0f);
                  _890 = (_821.w > _866.w);
                  _891 = (_861 > _813);
                  _893 = select((_891 && _890), _885, (dot(float2(saturate(_829 + 0.5f), saturate(0.5f - _829)), float2(saturate(_828 - _835), saturate((_813 * _766) - _835))) * (1.0f - saturate((1.0f - _813) * 8.0f))));
                  _895 = select((_891 || _890), _885, _893);
                  _903 = ((_893 * _842.x) + _789) + (_886.x * _895);
                  _905 = ((_893 * _842.y) + _790) + (_886.y * _895);
                  _907 = ((_893 * _842.z) + _791) + (_886.z * _895);
                  _909 = (_893 + _792) + _895;
                  _910 = _793 + 1;
                  do {
                    if (!(_910 == _758)) {
                      _789 = _903;
                      _790 = _905;
                      _791 = _907;
                      _792 = _909;
                      _793 = _910;
                      _loop_break_2 = true;
                      break;
                    }
                    _914 = _903;
                    _915 = _905;
                    _916 = _907;
                    _917 = _909;
                  } while (false);
                  if (_loop_break_2) {
                    _loop_break_2 = false;
                    continue;
                  }
                  break;
                }
              }
              _919 = float((int)(_758 << 1));
              _925 = (_914 / _919);
              _926 = (_915 / _919);
              _927 = (_916 / _919);
              _928 = (_917 / _919);
            } while (false);
          }
          _929 = 1.0f - _928;
          _936 = t20_space1.SampleLevel(s1_space1, float2(_69, _70), 0.0f);
          _941 = 1.0f - _936.w;
          _949 = ((_941 * ((_929 * _302) + _925)) + _936.x);
          _950 = ((_941 * ((_929 * _303) + _926)) + _936.y);
          _951 = ((_941 * ((_929 * _304) + _927)) + _936.z);
        } while (false);
      } else {
        _949 = _302;
        _950 = _303;
        _951 = _304;
      }
    }
  }
  _952 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  _964 = (postfx_cbuffer_1024 * (_952.x - _949)) + _949;
  _965 = (postfx_cbuffer_1024 * (_952.y - _950)) + _950;
  _966 = (postfx_cbuffer_1024 * (_952.z - _951)) + _951;
  _969 = (postfx_cbuffer_112.y < 0.0f);
  _970 = select(_969, 1.0f, TEXCOORD.w);
  _971 = t25_space1.Sample(s2_space1, float2(_69, _70));
  _971 *= CUSTOM_BLOOM;
  _975 = _971.x * _970;
  _976 = _971.y * _970;
  _977 = _971.z * _970;
  if (postfx_cbuffer_1200.z > 0.0f) {
    _982 = t31_space1.Sample(s2_space1, float2(_69, _70));
    _982 = max(0.f, _982);
    _984 = _982.x * _982.x;
    _985 = _984 * _984;
    _986 = _985 * _985 * CUSTOM_SUN_BLOOM;
    _998 = ((_986 * postfx_cbuffer_736.x) + _964);
    _999 = ((_986 * postfx_cbuffer_736.y) + _965);
    _1000 = ((_986 * postfx_cbuffer_736.z) + _966);
  } else {
    _998 = _964;
    _999 = _965;
    _1000 = _966;
  }
  _1001 = t29_space1.Sample(s3_space1, float2(TEXCOORD.x, TEXCOORD.y));
  _1023 = ((((postfx_cbuffer_544.z + -1.0f) + ((postfx_cbuffer_544.w - postfx_cbuffer_544.z) * saturate((TEXCOORD.z - postfx_cbuffer_544.x) * postfx_cbuffer_544.y))) * postfx_cbuffer_560.x) + 1.0f) * postfx_cbuffer_576.w;
  _1027 = (_1023 * _1001.x) + _998;
  _1028 = (_1023 * _1001.y) + _999;
  _1029 = (_1023 * _1001.z) + _1000;
  _1038 = abs(postfx_cbuffer_112.y);
  _1060 = TEXCOORD.x + -0.5f;
  _1061 = TEXCOORD.y + -0.5f;
  _1070 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1060, _1061), float2(_1060, _1061))) * postfx_cbuffer_912.y) + postfx_cbuffer_912.x) * postfx_cbuffer_912.z);
  _1070 = lerp(1.f, _1070, CUSTOM_VIGNETTE);
  _1095 = saturate((postfx_cbuffer_224.x * TEXCOORD_1) + postfx_cbuffer_224.y);
  _1114 = ((postfx_cbuffer_192.x - postfx_cbuffer_160.x) * _1095) + postfx_cbuffer_160.x;
  _1115 = ((postfx_cbuffer_192.y - postfx_cbuffer_160.y) * _1095) + postfx_cbuffer_160.y;
  _1117 = ((postfx_cbuffer_192.w - postfx_cbuffer_160.w) * _1095) + postfx_cbuffer_160.w;
  _1132 = ((postfx_cbuffer_208.x - postfx_cbuffer_176.x) * _1095) + postfx_cbuffer_176.x;
  _1133 = ((postfx_cbuffer_208.y - postfx_cbuffer_176.y) * _1095) + postfx_cbuffer_176.y;
  _1134 = ((postfx_cbuffer_208.z - postfx_cbuffer_176.z) * _1095) + postfx_cbuffer_176.z;
  _1135 = _1134 * _1114;
  _1136 = (lerp(postfx_cbuffer_160.z, postfx_cbuffer_192.z, _1095))*_1115;
  _1139 = _1132 * _1117;
  _1143 = _1133 * _1117;
  _1146 = _1132 / _1133;
  _1148 = 1.0f / (((((_1135 + _1136) * _1134) + _1139) / (((_1135 + _1115) * _1134) + _1143)) - _1146);
  _1152 = max(0.0f, (min(((lerp(postfx_cbuffer_928.x, 1.0f, _1070)) * (_1027 + select(_969, (((misc_globals_224.w * _975) - _1027) * _1038), ((_975 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));
  _1153 = max(0.0f, (min(((lerp(postfx_cbuffer_928.y, 1.0f, _1070)) * (_1028 + select(_969, (((misc_globals_224.w * _976) - _1028) * _1038), ((_976 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));
  _1154 = max(0.0f, (min(((lerp(postfx_cbuffer_928.z, 1.0f, _1070)) * (_1029 + select(_969, (((misc_globals_224.w * _977) - _1029) * _1038), ((_977 * 0.25f) * postfx_cbuffer_112.y)))), 65504.0f) * TEXCOORD.z));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    GTAVTonemapConfig tonemap_config = CreateGTAVTonemapConfig();
    tonemap_config.a = _1114;
    tonemap_config.b = _1115;
    tonemap_config.c_times_b = _1136;
    tonemap_config.d_times_e = _1139;
    tonemap_config.d_times_f = _1143;
    tonemap_config.e_over_f = _1146;
    tonemap_config.white_scale = _1148;
    tonemap_config.fade_to_white = postfx_cbuffer_208.w;
    tonemap_config.saturation = postfx_cbuffer_1072;
    tonemap_config.grade_a = postfx_cbuffer_1056.xyz;
    tonemap_config.grade_b = postfx_cbuffer_1040.xyz;
    tonemap_config.grade_luma_max = postfx_cbuffer_1056.w;
    tonemap_config.blend_range = postfx_cbuffer_1040.w;
    return GenerateGTAVOutput(float3(_1152, _1153, _1154), TEXCOORD.xy, SV_Position.xy, tonemap_config);
  }

  _1155 = _1152 * _1114;
  _1156 = _1153 * _1114;
  _1157 = _1154 * _1114;
  _1185 = saturate((((((_1155 + _1136) * _1152) + _1139) / (((_1155 + _1115) * _1152) + _1143)) - _1146) * _1148);
  _1186 = saturate((((((_1156 + _1136) * _1153) + _1139) / (((_1156 + _1115) * _1153) + _1143)) - _1146) * _1148);
  _1187 = saturate((((((_1157 + _1136) * _1154) + _1139) / (((_1157 + _1115) * _1154) + _1143)) - _1146) * _1148);
  _1195 = (postfx_cbuffer_208.w * (1.0f - _1185)) + _1185;
  _1196 = (postfx_cbuffer_208.w * (1.0f - _1186)) + _1186;
  _1197 = (postfx_cbuffer_208.w * (1.0f - _1187)) + _1187;
  _1198 = dot(float3(_1195, _1196, _1197), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  _1207 = ((_1195 - _1198) * postfx_cbuffer_1072) + _1198;
  _1208 = ((_1196 - _1198) * postfx_cbuffer_1072) + _1198;
  _1209 = ((_1197 - _1198) * postfx_cbuffer_1072) + _1198;
  _1213 = saturate(_1198 / postfx_cbuffer_1056.w);
  _1230 = (lerp(postfx_cbuffer_1056.x, postfx_cbuffer_1040.x, _1213))*_1207;
  _1231 = (lerp(postfx_cbuffer_1056.y, postfx_cbuffer_1040.y, _1213))*_1208;
  _1232 = (lerp(postfx_cbuffer_1056.z, postfx_cbuffer_1040.z, _1213))*_1209;
  _1238 = saturate(((_1198 + -1.0f) + postfx_cbuffer_1040.w) / max(0.009999999776482582f, postfx_cbuffer_1040.w));
  _1283 = (1.0f - (((sin((postfx_cbuffer_1008.w + TEXCOORD.y) * postfx_cbuffer_1008.y) * 0.5f) + 0.5f) * postfx_cbuffer_1008.x)) - (((sin(((postfx_cbuffer_1008.w * 0.5f) + TEXCOORD.y) * postfx_cbuffer_1008.z) * 0.5f) + 0.5f) * postfx_cbuffer_1008.x);
  _1303 = ((((float4)(t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * postfx_cbuffer_240.w) + postfx_cbuffer_240.x), frac(((TEXCOORD.y * 0.8999999761581421f) * postfx_cbuffer_240.w) + postfx_cbuffer_240.y))))).w) + -0.5f) * postfx_cbuffer_240.z;

  ConfigureVanillaGrain(_1303, _1283);

  _1310 = saturate(max(0.0f, (_1303 + (_1283 * exp2(log2(abs(saturate(lerp(_1230, _1207, _1238)))) * postfx_cbuffer_1076)))));
  _1311 = saturate(max(0.0f, (_1303 + (_1283 * exp2(log2(abs(saturate(lerp(_1231, _1208, _1238)))) * postfx_cbuffer_1076)))));
  _1312 = saturate(max(0.0f, (_1303 + (_1283 * exp2(log2(abs(saturate(lerp(_1232, _1209, _1238)))) * postfx_cbuffer_1076)))));
  if (!(asint(postfx_cbuffer_1424) == 0)) {
    _1322 = (asint(postfx_cbuffer_1472.w) != 0);
    _1324 = max(_1310, max(_1311, _1312));
    _1381 = (((t1.Load(int4(((int)(uint(SV_Position.x)) & 63), ((int)(uint(SV_Position.y)) & 63), (misc_globals_356 & 31), 0))).x) * 2.0f) + -1.0f;
    _1387 = float((int)(((int)(uint)((int)(_1381 > 0.0f))) - ((int)(uint)((int)(_1381 < 0.0f)))));
    _1391 = 1.0f - sqrt(1.0f - abs(_1381));
    _1402 = (((_1391 * (((postfx_cbuffer_1456.x - postfx_cbuffer_1440.x) * exp2(log2(saturate((select(_1322, _1310, _1324) - postfx_cbuffer_1488.x) * postfx_cbuffer_1472.x)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.x)) * _1387) + _1310);
    _1403 = (((_1391 * (((postfx_cbuffer_1456.y - postfx_cbuffer_1440.y) * exp2(log2(saturate((select(_1322, _1311, _1324) - postfx_cbuffer_1488.y) * postfx_cbuffer_1472.y)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.y)) * _1387) + _1311);
    _1404 = (((_1391 * (((postfx_cbuffer_1456.z - postfx_cbuffer_1440.z) * exp2(log2(saturate((select(_1322, _1312, _1324) - postfx_cbuffer_1488.z) * postfx_cbuffer_1472.z)) * postfx_cbuffer_1488.w)) + postfx_cbuffer_1440.z)) * _1387) + _1312);

    ConfigureVanillaDithering(
        _1310, _1311, _1312,
        _1402, _1403, _1404);
  } else {
    _1402 = _1310;
    _1403 = _1311;
    _1404 = _1312;
  }
  SV_Target.x = _1402;
  SV_Target.y = _1403;
  SV_Target.z = _1404;
  SV_Target.w = dot(float3(_1310, _1311, _1312), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / postfx_cbuffer_1076));
  return SV_Target;
}

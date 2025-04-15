#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);  // Grain

Texture2D<float> t11_space1 : register(t11, space1);  // Depth Buffer

Texture2D<float4> t14_space1 : register(t14, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t16_space1 : register(t16, space1);

Texture2D<float4> t17_space1 : register(t17, space1);

Texture2D<uint2> t18_space1 : register(t18, space1);

Texture2D<float4> t19_space1 : register(t19, space1);  // Render

Texture2D<float4> t20_space1 : register(t20, space1);

Texture2D<float2> t22_space1 : register(t22, space1);

Texture2D<float4> t23_space1 : register(t23, space1);

Texture2D<float4> t25_space1 : register(t25, space1);  // Bloom

Texture2D<float4> t28_space1 : register(t28, space1);

Texture2D<float4> t29_space1 : register(t29, space1);  // Lens Flare

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
  float cb5_014w : packoffset(c014.w);
  float cb5_015x : packoffset(c015.x);
  float cb5_015y : packoffset(c015.y);
  uint cb5_022y : packoffset(c022.y);
};

cbuffer cb12_space1 : register(b12, space1) {
  float cb12_space1_000z : packoffset(c000.z);
  float cb12_space1_000w : packoffset(c000.w);
  float cb12_space1_003x : packoffset(c003.x);
  float cb12_space1_003y : packoffset(c003.y);
  float cb12_space1_003z : packoffset(c003.z);
  float cb12_space1_003w : packoffset(c003.w);
  float cb12_space1_004x : packoffset(c004.x);
  float cb12_space1_007y : packoffset(c007.y);
  float cb12_space1_010x : packoffset(c010.x);
  float cb12_space1_010y : packoffset(c010.y);
  float cb12_space1_010z : packoffset(c010.z);
  float cb12_space1_010w : packoffset(c010.w);
  float cb12_space1_011x : packoffset(c011.x);
  float cb12_space1_011y : packoffset(c011.y);
  float cb12_space1_011z : packoffset(c011.z);
  float cb12_space1_012x : packoffset(c012.x);
  float cb12_space1_012y : packoffset(c012.y);
  float cb12_space1_012z : packoffset(c012.z);
  float cb12_space1_012w : packoffset(c012.w);
  float cb12_space1_013x : packoffset(c013.x);
  float cb12_space1_013y : packoffset(c013.y);
  float cb12_space1_013z : packoffset(c013.z);
  float cb12_space1_014x : packoffset(c014.x);
  float cb12_space1_014y : packoffset(c014.y);
  float cb12_space1_015x : packoffset(c015.x);
  float cb12_space1_015y : packoffset(c015.y);
  float cb12_space1_015z : packoffset(c015.z);
  float cb12_space1_015w : packoffset(c015.w);
  float cb12_space1_016x : packoffset(c016.x);
  float cb12_space1_016z : packoffset(c016.z);
  float cb12_space1_016w : packoffset(c016.w);
  float cb12_space1_017x : packoffset(c017.x);
  float cb12_space1_017y : packoffset(c017.y);
  float cb12_space1_017z : packoffset(c017.z);
  float cb12_space1_018x : packoffset(c018.x);
  float cb12_space1_018y : packoffset(c018.y);
  float cb12_space1_018z : packoffset(c018.z);
  float cb12_space1_018w : packoffset(c018.w);
  float cb12_space1_019x : packoffset(c019.x);
  float cb12_space1_019y : packoffset(c019.y);
  float cb12_space1_019z : packoffset(c019.z);
  float cb12_space1_019w : packoffset(c019.w);
  float cb12_space1_020x : packoffset(c020.x);
  float cb12_space1_020y : packoffset(c020.y);
  float cb12_space1_020z : packoffset(c020.z);
  float cb12_space1_020w : packoffset(c020.w);
  float cb12_space1_021x : packoffset(c021.x);
  float cb12_space1_021y : packoffset(c021.y);
  float cb12_space1_021z : packoffset(c021.z);
  float cb12_space1_022x : packoffset(c022.x);
  float cb12_space1_022y : packoffset(c022.y);
  float cb12_space1_022z : packoffset(c022.z);
  float cb12_space1_023x : packoffset(c023.x);
  float cb12_space1_023y : packoffset(c023.y);
  float cb12_space1_023z : packoffset(c023.z);
  float cb12_space1_030y : packoffset(c030.y);
  float cb12_space1_030z : packoffset(c030.z);
  float cb12_space1_030w : packoffset(c030.w);
  float cb12_space1_031x : packoffset(c031.x);
  float cb12_space1_031y : packoffset(c031.y);
  float cb12_space1_031z : packoffset(c031.z);
  float cb12_space1_031w : packoffset(c031.w);
  float cb12_space1_032x : packoffset(c032.x);
  float cb12_space1_032y : packoffset(c032.y);
  float cb12_space1_032z : packoffset(c032.z);
  float cb12_space1_032w : packoffset(c032.w);
  float cb12_space1_033x : packoffset(c033.x);
  float cb12_space1_033y : packoffset(c033.y);
  float cb12_space1_033z : packoffset(c033.z);
  float cb12_space1_046x : packoffset(c046.x);
  float cb12_space1_046y : packoffset(c046.y);
  float cb12_space1_046z : packoffset(c046.z);
  float cb12_space1_056x : packoffset(c056.x);
  float cb12_space1_057x : packoffset(c057.x);
  float cb12_space1_057y : packoffset(c057.y);
  float cb12_space1_057z : packoffset(c057.z);
  float cb12_space1_058x : packoffset(c058.x);
  float cb12_space1_058y : packoffset(c058.y);
  float cb12_space1_058z : packoffset(c058.z);
  float cb12_space1_063x : packoffset(c063.x);
  float cb12_space1_063y : packoffset(c063.y);
  float cb12_space1_063z : packoffset(c063.z);
  float cb12_space1_063w : packoffset(c063.w);
  float cb12_space1_064x : packoffset(c064.x);
  float cb12_space1_065x : packoffset(c065.x);
  float cb12_space1_065y : packoffset(c065.y);
  float cb12_space1_065z : packoffset(c065.z);
  float cb12_space1_065w : packoffset(c065.w);
  float cb12_space1_066x : packoffset(c066.x);
  float cb12_space1_066y : packoffset(c066.y);
  float cb12_space1_066z : packoffset(c066.z);
  float cb12_space1_066w : packoffset(c066.w);
  float cb12_space1_067x : packoffset(c067.x);
  float cb12_space1_067y : packoffset(c067.y);
  float cb12_space1_069x : packoffset(c069.x);
  float cb12_space1_069y : packoffset(c069.y);
  float cb12_space1_069z : packoffset(c069.z);
  float cb12_space1_069w : packoffset(c069.w);
  float cb12_space1_072x : packoffset(c072.x);
  float cb12_space1_072y : packoffset(c072.y);
  float cb12_space1_072z : packoffset(c072.z);
  float cb12_space1_072w : packoffset(c072.w);
  float cb12_space1_075z : packoffset(c075.z);
  float cb12_space1_085x : packoffset(c085.x);
  float cb12_space1_088x : packoffset(c088.x);
  float cb12_space1_088y : packoffset(c088.y);
  float cb12_space1_089x : packoffset(c089.x);
  float cb12_space1_090x : packoffset(c090.x);
  float cb12_space1_090y : packoffset(c090.y);
  float cb12_space1_090z : packoffset(c090.z);
  float cb12_space1_091x : packoffset(c091.x);
  float cb12_space1_091y : packoffset(c091.y);
  float cb12_space1_091z : packoffset(c091.z);
  float cb12_space1_092x : packoffset(c092.x);
  float cb12_space1_092y : packoffset(c092.y);
  float cb12_space1_092z : packoffset(c092.z);
  float cb12_space1_092w : packoffset(c092.w);
  float cb12_space1_093x : packoffset(c093.x);
  float cb12_space1_093y : packoffset(c093.y);
  float cb12_space1_093z : packoffset(c093.z);
  float cb12_space1_093w : packoffset(c093.w);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s1_space1 : register(s1, space1);

SamplerState s2_space1 : register(s2, space1);

SamplerState s3_space1 : register(s3, space1);

SamplerState s0_space2[] : register(s0, space2);

SamplerState s6_space1 : register(s6, space1);

SamplerState s8_space1 : register(s8, space1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float TEXCOORD_1: TEXCOORD1) : SV_Target {
  float4 SV_Target;
  float _34 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _41 = cb12_space1_000z / ((1.0f - _34.x) + cb12_space1_000w);
  float4 _48 = t16_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _58 = (((_48.x * float((bool)((bool)((bool)(_41 > cb12_space1_030y) && (bool)(_41 < cb12_space1_030y))))) * cb12_space1_033z) * (cb12_space1_030w - cb12_space1_030z)) + cb12_space1_030z;
  float4 _77 = t29_space1.Sample(s3_space1, float2(((cb12_space1_031x * TEXCOORD.x) + cb12_space1_031z), ((cb12_space1_031y * TEXCOORD.y) + cb12_space1_031w)));
  float4 _80 = t29_space1.Sample(s3_space1, float2(((cb12_space1_032x * TEXCOORD.x) + cb12_space1_032z), ((cb12_space1_032y * TEXCOORD.y) + cb12_space1_032w)));
  float _104 = min(max((1.0f - saturate(((cb12_space1_072z / cb12_space1_072w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  float _111 = (((cb12_space1_033x * _58) * ((_77.x + -1.0f) + _80.x)) + TEXCOORD.x) + -0.5f;
  float _112 = (((cb12_space1_033y * _58) * ((_77.y + -1.0f) + _80.y)) + TEXCOORD.y) + -0.5f;
  float _113 = (cb12_space1_072x / cb12_space1_072y) * _111;
  float _114 = dot(float2(_113, _112), float2(_113, _112));
  float _120 = CUSTOM_LENS_DISTORTION * ((_104 * _114) * ((sqrt(_114) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
  float _121 = _120 * _111;
  float _122 = _120 * _112;
  float _123 = _121 + 0.5f;
  float _124 = _122 + 0.5f;
  float _128 = _123 * cb5_015x;
  float _129 = _124 * cb5_015y;
  float _132 = floor(_128 + -0.5f);
  float _133 = floor(_129 + -0.5f);
  float _134 = _132 + 0.5f;
  float _135 = _133 + 0.5f;
  float _136 = _128 - _134;
  float _137 = _129 - _135;
  float _138 = _136 * _136;
  float _139 = _137 * _137;
  float _140 = _138 * _136;
  float _141 = _139 * _137;
  float _146 = _138 - ((_140 + _136) * 0.5f);
  float _147 = _139 - ((_141 + _137) * 0.5f);
  float _159 = (_136 * 0.5f) * (_138 - _136);
  float _161 = (_137 * 0.5f) * (_139 - _137);
  float _163 = (1.0f - _159) - _146;
  float _166 = (1.0f - _161) - _147;
  float _178 = (((_163 - (((_140 * 1.5f) - (_138 * 2.5f)) + 1.0f)) / _163) + _134) / cb5_015x;
  float _179 = (((_166 - (((_141 * 1.5f) - (_139 * 2.5f)) + 1.0f)) / _166) + _135) / cb5_015y;
  float _182 = _163 * _147;
  float _183 = _166 * _146;
  float _184 = _163 * _166;
  float _185 = _166 * _159;
  float _186 = _163 * _161;
  float _190 = (((_182 + _183) + _184) + _185) + _186;
  float4 _195 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_178, ((_133 + -0.5f) / cb5_015y)), 0.0f);
  float4 _204 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_132 + -0.5f) / cb5_015x), _179), 0.0f);
  float4 _215 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_178, _179), 0.0f);
  float4 _226 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_132 + 2.5f) / cb5_015x), _179), 0.0f);
  float4 _237 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_178, ((_133 + 2.5f) / cb5_015y)), 0.0f);
  float _246 = max(0.0f, ((((((_204.y * _183) + (_195.y * _182)) + (_215.y * _184)) + (_226.y * _185)) + (_237.y * _186)) / _190));
  float _247 = max(0.0f, ((((((_204.z * _183) + (_195.z * _182)) + (_215.z * _184)) + (_226.z * _185)) + (_237.z * _186)) / _190));
  float _255 = (cb12_space1_072x / cb12_space1_072y) * _121;
  float _256 = dot(float2(_255, _122), float2(_255, _122));
  float _262 = CUSTOM_CHROMATIC_ABERRATION * ((_104 * _256) * ((sqrt(_256) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _271 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_262 * _121) + 0.5f), ((_262 * _122) + 0.5f)));
  float _275 = cb5_014w * _271.x;
  float _423;
  float _424;
  float _425;
  float _535;
  float _536;
  float _537;
  float _538;
  int _539;
  float _587;
  float _588;
  float _589;
  float _590;
  float _676;
  float _677;
  float _678;
  float _679;
  int _680;
  float _799;
  float _800;
  float _801;
  float _802;
  float _810;
  float _811;
  float _812;
  float _813;
  float _910;
  float _911;
  float _912;
  float _913;
  int _914;
  float _1035;
  float _1036;
  float _1037;
  float _1038;
  float _1046;
  float _1047;
  float _1048;
  float _1049;
  float _1070;
  float _1071;
  float _1072;
  float _1119;
  float _1120;
  float _1121;
  float _1484;
  float _1485;
  float _1486;
  if (!(cb12_space1_085x > 0.0f)) {
    float _283 = cb12_space1_072y * 0.5f;
    float _284 = _123 - cb12_space1_072x;
    float _285 = _124 - _283;
    float4 _286 = t14_space1.Sample(s2_space1, float2(_284, _285));
    float _290 = cb12_space1_072x * 0.5f;
    float _291 = _290 + _123;
    float _292 = _124 - cb12_space1_072y;
    float4 _293 = t14_space1.Sample(s2_space1, float2(_291, _292));
    float _297 = _123 - _290;
    float _298 = cb12_space1_072y + _124;
    float4 _299 = t14_space1.Sample(s2_space1, float2(_297, _298));
    float _303 = cb12_space1_072x + _123;
    float _304 = _283 + _124;
    float4 _305 = t14_space1.Sample(s2_space1, float2(_303, _304));
    float4 _309 = t14_space1.Sample(s2_space1, float2(_123, _124));
    float4 _313 = t19_space1.Sample(s1_space1, float2(_284, _285));
    float4 _317 = t19_space1.Sample(s1_space1, float2(_291, _292));
    float4 _321 = t19_space1.Sample(s1_space1, float2(_297, _298));
    float4 _325 = t19_space1.Sample(s1_space1, float2(_303, _304));
    float4 _329 = t19_space1.Sample(s1_space1, float2(_123, _124));
    float _334 = (_329.x + _309.x) * 0.5f;
    float _336 = (_329.y + _309.y) * 0.5f;
    float _338 = (_329.z + _309.z) * 0.5f;
    bool _368 = !(cb12_space1_004x == 0.0f);
    float _387 = max(saturate(1.0f - ((_41 - cb12_space1_003x) * cb12_space1_003y)), saturate((_41 - cb12_space1_003z) * cb12_space1_003w));
    float _388 = _387 * 2.0040080547332764f;
    float _393 = saturate(1.0f - _388);
    float _396 = 1.0f - _393;
    float _397 = min(saturate(2.0020039081573486f - _388), _396);
    float _398 = _396 - _397;
    float _399 = min(saturate(999.9999389648438f - (_387 * 999.9999389648438f)), _398);
    float _400 = _398 - _399;
    _423 = ((((_397 * _329.x) + (_393 * _275)) + (_399 * select(_368, _329.x, _334))) + (_400 * select(_368, _329.x, (((((((((_293.x + _286.x) + _299.x) + _305.x) + _313.x) + _317.x) + _321.x) + _325.x) + _334) * 0.1111111119389534f))));
    _424 = ((((_397 * _329.y) + (_393 * _246)) + (_399 * select(_368, _329.y, _336))) + (_400 * select(_368, _329.y, (((((((((_293.y + _286.y) + _299.y) + _305.y) + _313.y) + _317.y) + _321.y) + _325.y) + _336) * 0.1111111119389534f))));
    _425 = ((((_397 * _329.z) + (_393 * _247)) + (_399 * select(_368, _329.z, _338))) + (_400 * select(_368, _329.z, (((((((((_293.z + _286.z) + _299.z) + _305.z) + _313.z) + _317.z) + _321.z) + _325.z) + _338) * 0.1111111119389534f))));
  } else {
    _423 = _275;
    _424 = _246;
    _425 = _247;
  }
  int _428 = int(cb12_space1_017z);
  if (_428 == 1) {
    uint2 _440 = t18_space1.Load(int3(int(cb5_015x * _123), int(cb5_015y * _124), 0));
    float _447 = select(((float((uint)(int)(_440.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
    float _450 = (_123 * 2.0f) + -1.0f;
    float _451 = 1.0f - (_124 * 2.0f);
    float _474 = (g_rage_matrices_192[3].x) + (dot(float3(_450, _451, 1.0f), float3(cb12_space1_021x, cb12_space1_021y, cb12_space1_021z)) * _41);
    float _475 = (g_rage_matrices_192[3].y) + (dot(float3(_450, _451, 1.0f), float3(cb12_space1_022x, cb12_space1_022y, cb12_space1_022z)) * _41);
    float _476 = (g_rage_matrices_192[3].z) + (dot(float3(_450, _451, 1.0f), float3(cb12_space1_023x, cb12_space1_023y, cb12_space1_023z)) * _41);
    float _494 = dot(float4(_474, _475, _476, 1.0f), float4(cb12_space1_020x, cb12_space1_020y, cb12_space1_020z, cb12_space1_020w));
    float _496 = select((_494 == 0.0f), 9.999999747378752e-06f, _494);
    float _501 = (_450 - (dot(float4(_474, _475, _476, 1.0f), float4(cb12_space1_018x, cb12_space1_018y, cb12_space1_018z, cb12_space1_018w)) / _496)) * 40.0f;
    float _502 = (_451 - (dot(float4(_474, _475, _476, 1.0f), float4(cb12_space1_019x, cb12_space1_019y, cb12_space1_019z, cb12_space1_019w)) / _496)) * -22.5f;
    float _503 = dot(float2(_501, _502), float2(_501, _502));
    bool _504 = (_503 > 1.0f);
    float _505 = rsqrt(_503);
    float _511 = (cb12_space1_016x * 0.012500000186264515f) * select(_504, (_505 * _501), _501);
    float _513 = (cb12_space1_016x * 0.02222222276031971f) * select(_504, (_502 * _505), _502);
    float _514 = _447 * _423;
    float _515 = _447 * _424;
    float _516 = _447 * _425;
    float4 _526 = t28_space1.Sample(s6_space1, float2(((_423 * 8.0f) + (_123 * 58.16400146484375f)), ((_424 * 8.0f) + (_124 * 47.130001068115234f))));
    if ((int)int(cb12_space1_017x) > (int)1) {
      _535 = _514;
      _536 = _515;
      _537 = _516;
      _538 = _447;
      _539 = 1;
      while (true) {
        float _541 = float(_539) + ((_526.x + -0.5f) * 0.5f);
        float _555 = (round((((_511 * cb12_space1_017y) * _541) + _123) * cb5_015x) + 0.5f) / cb5_015x;
        float _556 = (round((((_513 * cb12_space1_017y) * _541) + _124) * cb5_015y) + 0.5f) / cb5_015y;
        uint2 _561 = t18_space1.Load(int3(int(cb5_015x * _555), int(cb5_015y * _556), 0));
        float _568 = select(((float((uint)(int)(_561.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
        float4 _569 = t19_space1.SampleLevel(s1_space1, float2(_555, _556), 0.0f);
        float _576 = (_569.x * _568) + _535;
        float _577 = (_569.y * _568) + _536;
        float _578 = (_569.z * _568) + _537;
        float _579 = _568 + _538;
        int _580 = _539 + 1;
        if ((int)_580 < (int)int(cb12_space1_017x)) {
          _535 = _576;
          _536 = _577;
          _537 = _578;
          _538 = _579;
          _539 = _580;
          continue;
        }
        _587 = _576;
        _588 = _577;
        _589 = _578;
        _590 = _579;
        break;
      }
    } else {
      _587 = _514;
      _588 = _515;
      _589 = _516;
      _590 = _447;
    }
    float _591 = max(_590, 0.10000000149011612f);
    float _598 = saturate(dot(float2(_511, _513), float2(_511, _513)) * 1e+05f) * _447;
    _1070 = ((_598 * ((_587 / _591) - _423)) + _423);
    _1071 = ((_598 * ((_588 / _591) - _424)) + _424);
    _1072 = ((_598 * ((_589 / _591) - _425)) + _425);
  } else {
    if (_428 == 2) {
      float4 _616 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _123), (cb12_space1_088y * _124)), 0.0f);
      [branch]
      if ((bool)(_616.z >= 1.0f) && (bool)(_616.w < 2.0f)) {
        float2 _625 = t22_space1.SampleLevel(s0_space1, float2(_123, _124), 0.0f);
        float _630 = cb12_space1_016x * _625.x;
        float _631 = cb12_space1_016x * _625.y;
        float _640 = min(_616.z, 2.0f);
        int _645 = int(min(2.0f, (_640 + 1.0f)));
        float _649 = cb12_space1_072x * (_640 * (_616.x / _616.z));
        float _650 = cb12_space1_072y * (_640 * (_616.y / _616.z));
        float _652 = float(_645) + -0.5f;
        float _653 = _652 / _640;
        float _670 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_640 + -2.0f) * 0.5f);
        if ((int)_645 > (int)0) {
          _676 = 0.0f;
          _677 = 0.0f;
          _678 = 0.0f;
          _679 = 0.0f;
          _680 = 0;
          while (true) {
            float _681 = float(_680);
            float _682 = (_670 + 0.5f) + _681;
            float _683 = _682 / _652;
            float _686 = (_649 * _683) + _123;
            float _687 = (_650 * _683) + _124;
            float2 _688 = t22_space1.SampleLevel(s0_space1, float2(_686, _687), 0.0f);
            float _693 = cb12_space1_016x * _688.x;
            float _694 = cb12_space1_016x * _688.y;
            float _700 = min(sqrt((_693 * _693) + (_694 * _694)), cb12_space1_016z);
            float _701 = t11_space1.SampleLevel(s0_space1, float2(_686, _687), 0.0f);
            float _708 = cb12_space1_000z / ((1.0f - _701.x) + cb12_space1_000w);
            float _714 = _653 * min(sqrt((_630 * _630) + (_631 * _631)), cb12_space1_016z);
            float _715 = _708 - _41;
            float _721 = max((_682 + -1.0f), 0.0f);
            float4 _728 = t19_space1.SampleLevel(s1_space1, float2(_686, _687), 0.0f);
            float _732 = _681 + (0.5f - _670);
            float _733 = _732 / _652;
            float _736 = _123 - (_649 * _733);
            float _737 = _124 - (_650 * _733);
            float2 _738 = t22_space1.SampleLevel(s0_space1, float2(_736, _737), 0.0f);
            float _741 = cb12_space1_016x * _738.x;
            float _742 = cb12_space1_016x * _738.y;
            float _747 = min(sqrt((_741 * _741) + (_742 * _742)), cb12_space1_016z);
            float _748 = t11_space1.SampleLevel(s0_space1, float2(_736, _737), 0.0f);
            float _752 = cb12_space1_000z / ((1.0f - _748.x) + cb12_space1_000w);
            float _758 = _752 - _41;
            float _764 = max((_732 + -1.0f), 0.0f);
            float _770 = dot(float2(saturate(_758 + 0.5f), saturate(0.5f - _758)), float2(saturate(_714 - _764), saturate((_747 * _653) - _764))) * (1.0f - saturate((1.0f - _747) * 8.0f));
            float4 _771 = t19_space1.SampleLevel(s1_space1, float2(_736, _737), 0.0f);
            bool _775 = (_708 > _752);
            bool _776 = (_747 > _700);
            float _778 = select((_776 && _775), _770, (dot(float2(saturate(_715 + 0.5f), saturate(0.5f - _715)), float2(saturate(_714 - _721), saturate((_700 * _653) - _721))) * (1.0f - saturate((1.0f - _700) * 8.0f))));
            float _780 = select((_776 || _775), _770, _778);
            float _788 = ((_778 * _728.x) + _676) + (_771.x * _780);
            float _790 = ((_778 * _728.y) + _677) + (_771.y * _780);
            float _792 = ((_778 * _728.z) + _678) + (_771.z * _780);
            float _794 = (_778 + _679) + _780;
            int _795 = _680 + 1;
            if (!(_795 == _645)) {
              _676 = _788;
              _677 = _790;
              _678 = _792;
              _679 = _794;
              _680 = _795;
              continue;
            }
            _799 = _788;
            _800 = _790;
            _801 = _792;
            _802 = _794;
            break;
          }
        } else {
          _799 = 0.0f;
          _800 = 0.0f;
          _801 = 0.0f;
          _802 = 0.0f;
        }
        float _804 = float(_645 << 1);
        _810 = (_799 / _804);
        _811 = (_800 / _804);
        _812 = (_801 / _804);
        _813 = (_802 / _804);
      } else {
        _810 = 0.0f;
        _811 = 0.0f;
        _812 = 0.0f;
        _813 = 0.0f;
      }
      float _814 = 1.0f - _813;
      float4 _821 = t20_space1.SampleLevel(s1_space1, float2(_123, _124), 0.0f);
      float _826 = 1.0f - _821.w;
      _1070 = ((_826 * ((_814 * _423) + _810)) + _821.x);
      _1071 = ((_826 * ((_814 * _424) + _811)) + _821.y);
      _1072 = ((_826 * ((_814 * _425) + _812)) + _821.z);
    } else {
      if (_428 == 3) {
        float4 _841 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _123), (cb12_space1_088y * _124)), 0.0f);
        [branch]
        if ((bool)(_841.z >= 1.0f) && (bool)(_841.w < 2.0f)) {
          float2 _850 = t22_space1.SampleLevel(s0_space1, float2(_123, _124), 0.0f);
          float4 _860 = t19_space1.Load(int3(int(cb5_015x * _123), int(cb5_015y * _124), 0));
          float _864 = cb12_space1_016x * _850.x;
          float _865 = cb12_space1_016x * _850.y;
          float _874 = min(_841.z, 2.0f);
          int _879 = int(min(2.0f, (_874 + 1.0f)));
          float _883 = cb12_space1_072x * (_874 * (_841.x / _841.z));
          float _884 = cb12_space1_072y * (_874 * (_841.y / _841.z));
          float _886 = float(_879) + -0.5f;
          float _887 = _886 / _874;
          float _904 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_874 + -2.0f) * 0.5f);
          if ((int)_879 > (int)0) {
            _910 = 0.0f;
            _911 = 0.0f;
            _912 = 0.0f;
            _913 = 0.0f;
            _914 = 0;
            while (true) {
              float _915 = float(_914);
              float _916 = (_904 + 0.5f) + _915;
              float _917 = _916 / _886;
              float _920 = (_883 * _917) + _123;
              float _921 = (_884 * _917) + _124;
              float2 _922 = t22_space1.SampleLevel(s0_space1, float2(_920, _921), 0.0f);
              float _927 = cb12_space1_016x * _922.x;
              float _928 = cb12_space1_016x * _922.y;
              float _934 = min(sqrt((_927 * _927) + (_928 * _928)), cb12_space1_016z);
              float4 _942 = t19_space1.Load(int3(int(cb5_015x * _920), int(cb5_015y * _921), 0));
              float _949 = _887 * min(sqrt((_864 * _864) + (_865 * _865)), cb12_space1_016z);
              float _950 = _942.w - _860.w;
              float _956 = max((_916 + -1.0f), 0.0f);
              float4 _963 = t19_space1.SampleLevel(s1_space1, float2(_920, _921), 0.0f);
              float _967 = _915 + (0.5f - _904);
              float _968 = _967 / _886;
              float _971 = _123 - (_883 * _968);
              float _972 = _124 - (_884 * _968);
              float2 _973 = t22_space1.SampleLevel(s0_space1, float2(_971, _972), 0.0f);
              float _976 = cb12_space1_016x * _973.x;
              float _977 = cb12_space1_016x * _973.y;
              float _982 = min(sqrt((_976 * _976) + (_977 * _977)), cb12_space1_016z);
              float4 _987 = t19_space1.Load(int3(int(cb5_015x * _971), int(cb5_015y * _972), 0));
              float _994 = _987.w - _860.w;
              float _1000 = max((_967 + -1.0f), 0.0f);
              float _1006 = dot(float2(saturate(_994 + 0.5f), saturate(0.5f - _994)), float2(saturate(_949 - _1000), saturate((_982 * _887) - _1000))) * (1.0f - saturate((1.0f - _982) * 8.0f));
              float4 _1007 = t19_space1.SampleLevel(s1_space1, float2(_971, _972), 0.0f);
              bool _1011 = (_942.w > _987.w);
              bool _1012 = (_982 > _934);
              float _1014 = select((_1012 && _1011), _1006, (dot(float2(saturate(_950 + 0.5f), saturate(0.5f - _950)), float2(saturate(_949 - _956), saturate((_934 * _887) - _956))) * (1.0f - saturate((1.0f - _934) * 8.0f))));
              float _1016 = select((_1012 || _1011), _1006, _1014);
              float _1024 = ((_1014 * _963.x) + _910) + (_1007.x * _1016);
              float _1026 = ((_1014 * _963.y) + _911) + (_1007.y * _1016);
              float _1028 = ((_1014 * _963.z) + _912) + (_1007.z * _1016);
              float _1030 = (_1014 + _913) + _1016;
              int _1031 = _914 + 1;
              if (!(_1031 == _879)) {
                _910 = _1024;
                _911 = _1026;
                _912 = _1028;
                _913 = _1030;
                _914 = _1031;
                continue;
              }
              _1035 = _1024;
              _1036 = _1026;
              _1037 = _1028;
              _1038 = _1030;
              break;
            }
          } else {
            _1035 = 0.0f;
            _1036 = 0.0f;
            _1037 = 0.0f;
            _1038 = 0.0f;
          }
          float _1040 = float(_879 << 1);
          _1046 = (_1035 / _1040);
          _1047 = (_1036 / _1040);
          _1048 = (_1037 / _1040);
          _1049 = (_1038 / _1040);
        } else {
          _1046 = 0.0f;
          _1047 = 0.0f;
          _1048 = 0.0f;
          _1049 = 0.0f;
        }
        float _1050 = 1.0f - _1049;
        float4 _1057 = t20_space1.SampleLevel(s1_space1, float2(_123, _124), 0.0f);
        float _1062 = 1.0f - _1057.w;
        _1070 = ((_1062 * ((_1050 * _423) + _1046)) + _1057.x);
        _1071 = ((_1062 * ((_1050 * _424) + _1047)) + _1057.y);
        _1072 = ((_1062 * ((_1050 * _425) + _1048)) + _1057.z);
      } else {
        _1070 = _423;
        _1071 = _424;
        _1072 = _425;
      }
    }
  }
  float4 _1073 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _1085 = (cb12_space1_064x * (_1073.x - _1070)) + _1070;
  float _1086 = (cb12_space1_064x * (_1073.y - _1071)) + _1071;
  float _1087 = (cb12_space1_064x * (_1073.z - _1072)) + _1072;
  bool _1090 = (cb12_space1_007y < 0.0f);
  float _1091 = select(_1090, 1.0f, TEXCOORD.w);
  float4 _1092 = t25_space1.Sample(s2_space1, float2(_123, _124));

  _1092 *= CUSTOM_BLOOM;

  float _1096 = _1092.x * _1091;
  float _1097 = _1092.y * _1091;
  float _1098 = _1092.z * _1091;
  if (cb12_space1_075z > 0.0f) {
    float4 _1103 = t31_space1.Sample(s2_space1, float2(_123, _124));

    _1103 = max(0, _1103);  // Fix NaN

    float _1105 = _1103.x * _1103.x;
    float _1106 = _1105 * _1105;
    float _1107 = _1106 * _1106 * CUSTOM_SUN_BLOOM;

    _1119 = ((_1107 * cb12_space1_046x) + _1085);
    _1120 = ((_1107 * cb12_space1_046y) + _1086);
    _1121 = ((_1107 * cb12_space1_046z) + _1087);
  } else {
    _1119 = _1085;
    _1120 = _1086;
    _1121 = _1087;
  }
  float _1130 = abs(cb12_space1_007y);
  float _1152 = TEXCOORD.x + -0.5f;
  float _1153 = TEXCOORD.y + -0.5f;
  float _1162 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1152, _1153), float2(_1152, _1153))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);

  _1162 = lerp(1.f, _1162, CUSTOM_VIGNETTE);

  float _1187 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _1206 = ((cb12_space1_012x - cb12_space1_010x) * _1187) + cb12_space1_010x;
  float _1207 = ((cb12_space1_012y - cb12_space1_010y) * _1187) + cb12_space1_010y;
  float _1209 = ((cb12_space1_012w - cb12_space1_010w) * _1187) + cb12_space1_010w;
  float _1224 = ((cb12_space1_013x - cb12_space1_011x) * _1187) + cb12_space1_011x;
  float _1225 = ((cb12_space1_013y - cb12_space1_011y) * _1187) + cb12_space1_011y;
  float _1226 = ((cb12_space1_013z - cb12_space1_011z) * _1187) + cb12_space1_011z;
  float _1227 = _1226 * _1206;
  float _1228 = (lerp(cb12_space1_010z, cb12_space1_012z, _1187)) * _1207;
  float _1231 = _1224 * _1209;
  float _1235 = _1225 * _1209;
  float _1238 = _1224 / _1225;
  float _1240 = 1.0f / (((((_1227 + _1228) * _1226) + _1231) / (((_1227 + _1207) * _1226) + _1235)) - _1238);

  float mid_gray = 0.18f;
  {
    float _1096 = 0.18f;
    float _1097 = 0.18f;
    float _1098 = 0.18f;

    float _1119 = 0.18f;
    float _1120 = 0.18f;
    float _1121 = 0.18f;

    float _1244 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _1162)) * (_1119 + select(_1090, (((cb5_014w * _1096) - _1119) * _1130), ((_1096 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _1245 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _1162)) * (_1120 + select(_1090, (((cb5_014w * _1097) - _1120) * _1130), ((_1097 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _1246 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _1162)) * (_1121 + select(_1090, (((cb5_014w * _1098) - _1121) * _1130), ((_1098 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _1247 = _1244 * _1206;
    float _1248 = _1245 * _1206;
    float _1249 = _1246 * _1206;
    // Replace saturate with max
    float _1277 = max(0.f, (((((_1247 + _1228) * _1244) + _1231) / (((_1247 + _1207) * _1244) + _1235)) - _1238) * _1240);
    float _1278 = max(0.f, (((((_1248 + _1228) * _1245) + _1231) / (((_1248 + _1207) * _1245) + _1235)) - _1238) * _1240);
    float _1279 = max(0.f, (((((_1249 + _1228) * _1246) + _1231) / (((_1249 + _1207) * _1246) + _1235)) - _1238) * _1240);

    mid_gray = renodx::color::y::from::BT709(float3(_1277, _1278, _1279));
  }

  float _1244 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _1162)) * (_1119 + select(_1090, (((cb5_014w * _1096) - _1119) * _1130), ((_1096 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1245 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _1162)) * (_1120 + select(_1090, (((cb5_014w * _1097) - _1120) * _1130), ((_1097 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1246 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _1162)) * (_1121 + select(_1090, (((cb5_014w * _1098) - _1121) * _1130), ((_1098 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1247 = _1244 * _1206;
  float _1248 = _1245 * _1206;
  float _1249 = _1246 * _1206;

  float3 untonemapped = float3(_1247, _1248, _1249) * mid_gray / 0.18f;

  // Replace saturate with max
  float _1277 = max(0.f, (((((_1247 + _1228) * _1244) + _1231) / (((_1247 + _1207) * _1244) + _1235)) - _1238) * _1240);
  float _1278 = max(0.f, (((((_1248 + _1228) * _1245) + _1231) / (((_1248 + _1207) * _1245) + _1235)) - _1238) * _1240);
  float _1279 = max(0.f, (((((_1249 + _1228) * _1246) + _1231) / (((_1249 + _1207) * _1246) + _1235)) - _1238) * _1240);

  ApplyPerChannelCorrection(untonemapped, _1277, _1278, _1279);

  float _1280 = dot(float3(_1277, _1278, _1279), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _1289 = (cb12_space1_067x * (_1277 - _1280)) + _1280;
  float _1290 = (cb12_space1_067x * (_1278 - _1280)) + _1280;
  float _1291 = (cb12_space1_067x * (_1279 - _1280)) + _1280;
  float _1295 = saturate(_1280 / cb12_space1_066w);
  float _1312 = (lerp(cb12_space1_066x, cb12_space1_065x, _1295)) * _1289;
  float _1313 = (lerp(cb12_space1_066y, cb12_space1_065y, _1295)) * _1290;
  float _1314 = (lerp(cb12_space1_066z, cb12_space1_065z, _1295)) * _1291;
  float _1320 = saturate(((_1280 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        float3(_1312, _1313, _1314),
        float3(_1289, _1290, _1291),
        _1320,
        TEXCOORD.xy);
  }

  float _1365 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _1381 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _1385 = (_1381.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_1385, _1365);

  float _1392 = saturate(max(0.0f, (_1385 + (_1365 * exp2(log2(abs(saturate(lerp(_1312, _1289, _1320)))) * cb12_space1_067y)))));
  float _1393 = saturate(max(0.0f, (_1385 + (_1365 * exp2(log2(abs(saturate(lerp(_1313, _1290, _1320)))) * cb12_space1_067y)))));
  float _1394 = saturate(max(0.0f, (_1385 + (_1365 * exp2(log2(abs(saturate(lerp(_1314, _1291, _1320)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _1404 = (asint(cb12_space1_092w) != 0);
    float _1406 = max(_1392, max(_1393, _1394));
    float _1460 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _1463 = (_1460.x * 2.0f) + -1.0f;
    float _1469 = float(((int)(uint)((bool)(_1463 > 0.0f))) - ((int)(uint)((bool)(_1463 < 0.0f))));
    float _1473 = 1.0f - sqrt(1.0f - abs(_1463));
    _1484 = (((_1473 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_1404, _1392, _1406) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _1469) + _1392);
    _1485 = (((_1473 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_1404, _1393, _1406) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _1469) + _1393);
    _1486 = (((_1473 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_1404, _1394, _1406) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _1469) + _1394);

    ConfigureVanillaDithering(
        _1392, _1393, _1394,
        _1484, _1485, _1486);

  } else {
    _1484 = _1392;
    _1485 = _1393;
    _1486 = _1394;
  }
  SV_Target.x = _1484;
  SV_Target.y = _1485;
  SV_Target.z = _1486;
  SV_Target.w = dot(float3(_1392, _1393, _1394), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}

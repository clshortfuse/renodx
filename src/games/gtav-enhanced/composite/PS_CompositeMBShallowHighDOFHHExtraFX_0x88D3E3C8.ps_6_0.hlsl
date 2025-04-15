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
  float _1417;
  float _1418;
  float _1419;
  if (!(cb12_space1_085x > 0.0f)) {
    float4 _280 = t19_space1.Sample(s1_space1, float2(_123, _124));
    float4 _284 = t14_space1.Sample(s2_space1, float2(_123, _124));
    float4 _288 = t30_space1.Sample(s2_space1, float2(_123, _124));
    float _319 = max(saturate(1.0f - ((_41 - cb12_space1_003x) * cb12_space1_003y)), saturate((_41 - cb12_space1_003z) * cb12_space1_003w));
    float _326 = saturate(1.0f - (_319 * 499.9999694824219f));
    float _329 = 1.0f - _326;
    float _330 = min(saturate(0.5015197396278381f - (_319 * 0.5065855979919434f)), _329);
    float _331 = _329 - _330;
    float _332 = min(saturate(100.0f - (_319 * 100.0f)), _331);
    float _333 = _331 - _332;
    _356 = ((((_330 * _280.x) + (_326 * _275)) + (_332 * ((_284.x * 0.699999988079071f) + (_280.x * 0.30000001192092896f)))) + (((_288.x + _284.x) * 0.5f) * _333));
    _357 = ((((_330 * _280.y) + (_326 * _246)) + (_332 * ((_284.y * 0.699999988079071f) + (_280.y * 0.30000001192092896f)))) + (((_288.y + _284.y) * 0.5f) * _333));
    _358 = ((((_330 * _280.z) + (_326 * _247)) + (_332 * ((_284.z * 0.699999988079071f) + (_280.z * 0.30000001192092896f)))) + (((_288.z + _284.z) * 0.5f) * _333));
  } else {
    _356 = _275;
    _357 = _246;
    _358 = _247;
  }
  int _361 = int(cb12_space1_017z);
  if (_361 == 1) {
    uint2 _373 = t18_space1.Load(int3(int(cb5_015x * _123), int(cb5_015y * _124), 0));
    float _380 = select(((float((uint)(int)(_373.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
    float _383 = (_123 * 2.0f) + -1.0f;
    float _384 = 1.0f - (_124 * 2.0f);
    float _407 = (g_rage_matrices_192[3].x) + (dot(float3(_383, _384, 1.0f), float3(cb12_space1_021x, cb12_space1_021y, cb12_space1_021z)) * _41);
    float _408 = (g_rage_matrices_192[3].y) + (dot(float3(_383, _384, 1.0f), float3(cb12_space1_022x, cb12_space1_022y, cb12_space1_022z)) * _41);
    float _409 = (g_rage_matrices_192[3].z) + (dot(float3(_383, _384, 1.0f), float3(cb12_space1_023x, cb12_space1_023y, cb12_space1_023z)) * _41);
    float _427 = dot(float4(_407, _408, _409, 1.0f), float4(cb12_space1_020x, cb12_space1_020y, cb12_space1_020z, cb12_space1_020w));
    float _429 = select((_427 == 0.0f), 9.999999747378752e-06f, _427);
    float _434 = (_383 - (dot(float4(_407, _408, _409, 1.0f), float4(cb12_space1_018x, cb12_space1_018y, cb12_space1_018z, cb12_space1_018w)) / _429)) * 40.0f;
    float _435 = (_384 - (dot(float4(_407, _408, _409, 1.0f), float4(cb12_space1_019x, cb12_space1_019y, cb12_space1_019z, cb12_space1_019w)) / _429)) * -22.5f;
    float _436 = dot(float2(_434, _435), float2(_434, _435));
    bool _437 = (_436 > 1.0f);
    float _438 = rsqrt(_436);
    float _444 = (cb12_space1_016x * 0.012500000186264515f) * select(_437, (_438 * _434), _434);
    float _446 = (cb12_space1_016x * 0.02222222276031971f) * select(_437, (_435 * _438), _435);
    float _447 = _380 * _356;
    float _448 = _380 * _357;
    float _449 = _380 * _358;
    float4 _459 = t28_space1.Sample(s6_space1, float2(((_356 * 8.0f) + (_123 * 58.16400146484375f)), ((_357 * 8.0f) + (_124 * 47.130001068115234f))));
    if ((int)int(cb12_space1_017x) > (int)1) {
      _468 = _447;
      _469 = _448;
      _470 = _449;
      _471 = _380;
      _472 = 1;
      while (true) {
        float _474 = float(_472) + ((_459.x + -0.5f) * 0.5f);
        float _488 = (round((((_444 * cb12_space1_017y) * _474) + _123) * cb5_015x) + 0.5f) / cb5_015x;
        float _489 = (round((((_446 * cb12_space1_017y) * _474) + _124) * cb5_015y) + 0.5f) / cb5_015y;
        uint2 _494 = t18_space1.Load(int3(int(cb5_015x * _488), int(cb5_015y * _489), 0));
        float _501 = select(((float((uint)(int)(_494.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
        float4 _502 = t19_space1.SampleLevel(s1_space1, float2(_488, _489), 0.0f);
        float _509 = (_502.x * _501) + _468;
        float _510 = (_502.y * _501) + _469;
        float _511 = (_502.z * _501) + _470;
        float _512 = _501 + _471;
        int _513 = _472 + 1;
        if ((int)_513 < (int)int(cb12_space1_017x)) {
          _468 = _509;
          _469 = _510;
          _470 = _511;
          _471 = _512;
          _472 = _513;
          continue;
        }
        _520 = _509;
        _521 = _510;
        _522 = _511;
        _523 = _512;
        break;
      }
    } else {
      _520 = _447;
      _521 = _448;
      _522 = _449;
      _523 = _380;
    }
    float _524 = max(_523, 0.10000000149011612f);
    float _531 = saturate(dot(float2(_444, _446), float2(_444, _446)) * 1e+05f) * _380;
    _1003 = ((_531 * ((_520 / _524) - _356)) + _356);
    _1004 = ((_531 * ((_521 / _524) - _357)) + _357);
    _1005 = ((_531 * ((_522 / _524) - _358)) + _358);
  } else {
    if (_361 == 2) {
      float4 _549 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _123), (cb12_space1_088y * _124)), 0.0f);
      [branch]
      if ((bool)(_549.z >= 1.0f) && (bool)(_549.w < 2.0f)) {
        float2 _558 = t22_space1.SampleLevel(s0_space1, float2(_123, _124), 0.0f);
        float _563 = cb12_space1_016x * _558.x;
        float _564 = cb12_space1_016x * _558.y;
        float _573 = min(_549.z, 2.0f);
        int _578 = int(min(2.0f, (_573 + 1.0f)));
        float _582 = cb12_space1_072x * (_573 * (_549.x / _549.z));
        float _583 = cb12_space1_072y * (_573 * (_549.y / _549.z));
        float _585 = float(_578) + -0.5f;
        float _586 = _585 / _573;
        float _603 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_573 + -2.0f) * 0.5f);
        if ((int)_578 > (int)0) {
          _609 = 0.0f;
          _610 = 0.0f;
          _611 = 0.0f;
          _612 = 0.0f;
          _613 = 0;
          while (true) {
            float _614 = float(_613);
            float _615 = (_603 + 0.5f) + _614;
            float _616 = _615 / _585;
            float _619 = (_582 * _616) + _123;
            float _620 = (_583 * _616) + _124;
            float2 _621 = t22_space1.SampleLevel(s0_space1, float2(_619, _620), 0.0f);
            float _626 = cb12_space1_016x * _621.x;
            float _627 = cb12_space1_016x * _621.y;
            float _633 = min(sqrt((_626 * _626) + (_627 * _627)), cb12_space1_016z);
            float _634 = t11_space1.SampleLevel(s0_space1, float2(_619, _620), 0.0f);
            float _641 = cb12_space1_000z / ((1.0f - _634.x) + cb12_space1_000w);
            float _647 = _586 * min(sqrt((_563 * _563) + (_564 * _564)), cb12_space1_016z);
            float _648 = _641 - _41;
            float _654 = max((_615 + -1.0f), 0.0f);
            float4 _661 = t19_space1.SampleLevel(s1_space1, float2(_619, _620), 0.0f);
            float _665 = _614 + (0.5f - _603);
            float _666 = _665 / _585;
            float _669 = _123 - (_582 * _666);
            float _670 = _124 - (_583 * _666);
            float2 _671 = t22_space1.SampleLevel(s0_space1, float2(_669, _670), 0.0f);
            float _674 = cb12_space1_016x * _671.x;
            float _675 = cb12_space1_016x * _671.y;
            float _680 = min(sqrt((_674 * _674) + (_675 * _675)), cb12_space1_016z);
            float _681 = t11_space1.SampleLevel(s0_space1, float2(_669, _670), 0.0f);
            float _685 = cb12_space1_000z / ((1.0f - _681.x) + cb12_space1_000w);
            float _691 = _685 - _41;
            float _697 = max((_665 + -1.0f), 0.0f);
            float _703 = dot(float2(saturate(_691 + 0.5f), saturate(0.5f - _691)), float2(saturate(_647 - _697), saturate((_680 * _586) - _697))) * (1.0f - saturate((1.0f - _680) * 8.0f));
            float4 _704 = t19_space1.SampleLevel(s1_space1, float2(_669, _670), 0.0f);
            bool _708 = (_641 > _685);
            bool _709 = (_680 > _633);
            float _711 = select((_709 && _708), _703, (dot(float2(saturate(_648 + 0.5f), saturate(0.5f - _648)), float2(saturate(_647 - _654), saturate((_633 * _586) - _654))) * (1.0f - saturate((1.0f - _633) * 8.0f))));
            float _713 = select((_709 || _708), _703, _711);
            float _721 = ((_711 * _661.x) + _609) + (_704.x * _713);
            float _723 = ((_711 * _661.y) + _610) + (_704.y * _713);
            float _725 = ((_711 * _661.z) + _611) + (_704.z * _713);
            float _727 = (_711 + _612) + _713;
            int _728 = _613 + 1;
            if (!(_728 == _578)) {
              _609 = _721;
              _610 = _723;
              _611 = _725;
              _612 = _727;
              _613 = _728;
              continue;
            }
            _732 = _721;
            _733 = _723;
            _734 = _725;
            _735 = _727;
            break;
          }
        } else {
          _732 = 0.0f;
          _733 = 0.0f;
          _734 = 0.0f;
          _735 = 0.0f;
        }
        float _737 = float(_578 << 1);
        _743 = (_732 / _737);
        _744 = (_733 / _737);
        _745 = (_734 / _737);
        _746 = (_735 / _737);
      } else {
        _743 = 0.0f;
        _744 = 0.0f;
        _745 = 0.0f;
        _746 = 0.0f;
      }
      float _747 = 1.0f - _746;
      float4 _754 = t20_space1.SampleLevel(s1_space1, float2(_123, _124), 0.0f);
      float _759 = 1.0f - _754.w;
      _1003 = ((_759 * ((_747 * _356) + _743)) + _754.x);
      _1004 = ((_759 * ((_747 * _357) + _744)) + _754.y);
      _1005 = ((_759 * ((_747 * _358) + _745)) + _754.z);
    } else {
      if (_361 == 3) {
        float4 _774 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _123), (cb12_space1_088y * _124)), 0.0f);
        [branch]
        if ((bool)(_774.z >= 1.0f) && (bool)(_774.w < 2.0f)) {
          float2 _783 = t22_space1.SampleLevel(s0_space1, float2(_123, _124), 0.0f);
          float4 _793 = t19_space1.Load(int3(int(cb5_015x * _123), int(cb5_015y * _124), 0));
          float _797 = cb12_space1_016x * _783.x;
          float _798 = cb12_space1_016x * _783.y;
          float _807 = min(_774.z, 2.0f);
          int _812 = int(min(2.0f, (_807 + 1.0f)));
          float _816 = cb12_space1_072x * (_807 * (_774.x / _774.z));
          float _817 = cb12_space1_072y * (_807 * (_774.y / _774.z));
          float _819 = float(_812) + -0.5f;
          float _820 = _819 / _807;
          float _837 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_807 + -2.0f) * 0.5f);
          if ((int)_812 > (int)0) {
            _843 = 0.0f;
            _844 = 0.0f;
            _845 = 0.0f;
            _846 = 0.0f;
            _847 = 0;
            while (true) {
              float _848 = float(_847);
              float _849 = (_837 + 0.5f) + _848;
              float _850 = _849 / _819;
              float _853 = (_816 * _850) + _123;
              float _854 = (_817 * _850) + _124;
              float2 _855 = t22_space1.SampleLevel(s0_space1, float2(_853, _854), 0.0f);
              float _860 = cb12_space1_016x * _855.x;
              float _861 = cb12_space1_016x * _855.y;
              float _867 = min(sqrt((_860 * _860) + (_861 * _861)), cb12_space1_016z);
              float4 _875 = t19_space1.Load(int3(int(cb5_015x * _853), int(cb5_015y * _854), 0));
              float _882 = _820 * min(sqrt((_797 * _797) + (_798 * _798)), cb12_space1_016z);
              float _883 = _875.w - _793.w;
              float _889 = max((_849 + -1.0f), 0.0f);
              float4 _896 = t19_space1.SampleLevel(s1_space1, float2(_853, _854), 0.0f);
              float _900 = _848 + (0.5f - _837);
              float _901 = _900 / _819;
              float _904 = _123 - (_816 * _901);
              float _905 = _124 - (_817 * _901);
              float2 _906 = t22_space1.SampleLevel(s0_space1, float2(_904, _905), 0.0f);
              float _909 = cb12_space1_016x * _906.x;
              float _910 = cb12_space1_016x * _906.y;
              float _915 = min(sqrt((_909 * _909) + (_910 * _910)), cb12_space1_016z);
              float4 _920 = t19_space1.Load(int3(int(cb5_015x * _904), int(cb5_015y * _905), 0));
              float _927 = _920.w - _793.w;
              float _933 = max((_900 + -1.0f), 0.0f);
              float _939 = dot(float2(saturate(_927 + 0.5f), saturate(0.5f - _927)), float2(saturate(_882 - _933), saturate((_915 * _820) - _933))) * (1.0f - saturate((1.0f - _915) * 8.0f));
              float4 _940 = t19_space1.SampleLevel(s1_space1, float2(_904, _905), 0.0f);
              bool _944 = (_875.w > _920.w);
              bool _945 = (_915 > _867);
              float _947 = select((_945 && _944), _939, (dot(float2(saturate(_883 + 0.5f), saturate(0.5f - _883)), float2(saturate(_882 - _889), saturate((_867 * _820) - _889))) * (1.0f - saturate((1.0f - _867) * 8.0f))));
              float _949 = select((_945 || _944), _939, _947);
              float _957 = ((_947 * _896.x) + _843) + (_940.x * _949);
              float _959 = ((_947 * _896.y) + _844) + (_940.y * _949);
              float _961 = ((_947 * _896.z) + _845) + (_940.z * _949);
              float _963 = (_947 + _846) + _949;
              int _964 = _847 + 1;
              if (!(_964 == _812)) {
                _843 = _957;
                _844 = _959;
                _845 = _961;
                _846 = _963;
                _847 = _964;
                continue;
              }
              _968 = _957;
              _969 = _959;
              _970 = _961;
              _971 = _963;
              break;
            }
          } else {
            _968 = 0.0f;
            _969 = 0.0f;
            _970 = 0.0f;
            _971 = 0.0f;
          }
          float _973 = float(_812 << 1);
          _979 = (_968 / _973);
          _980 = (_969 / _973);
          _981 = (_970 / _973);
          _982 = (_971 / _973);
        } else {
          _979 = 0.0f;
          _980 = 0.0f;
          _981 = 0.0f;
          _982 = 0.0f;
        }
        float _983 = 1.0f - _982;
        float4 _990 = t20_space1.SampleLevel(s1_space1, float2(_123, _124), 0.0f);
        float _995 = 1.0f - _990.w;
        _1003 = ((_995 * ((_983 * _356) + _979)) + _990.x);
        _1004 = ((_995 * ((_983 * _357) + _980)) + _990.y);
        _1005 = ((_995 * ((_983 * _358) + _981)) + _990.z);
      } else {
        _1003 = _356;
        _1004 = _357;
        _1005 = _358;
      }
    }
  }
  float4 _1006 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _1018 = (cb12_space1_064x * (_1006.x - _1003)) + _1003;
  float _1019 = (cb12_space1_064x * (_1006.y - _1004)) + _1004;
  float _1020 = (cb12_space1_064x * (_1006.z - _1005)) + _1005;
  bool _1023 = (cb12_space1_007y < 0.0f);
  float _1024 = select(_1023, 1.0f, TEXCOORD.w);
  float4 _1025 = t25_space1.Sample(s2_space1, float2(_123, _124));

  _1025 *= CUSTOM_BLOOM;

  float _1029 = _1025.x * _1024;
  float _1030 = _1025.y * _1024;
  float _1031 = _1025.z * _1024;
  if (cb12_space1_075z > 0.0f) {
    float4 _1036 = t31_space1.Sample(s2_space1, float2(_123, _124));

    _1036 = max(0, _1036);  // Fix NaN

    float _1038 = _1036.x * _1036.x;
    float _1039 = _1038 * _1038;
    float _1040 = _1039 * _1039 * CUSTOM_SUN_BLOOM;

    _1052 = ((_1040 * cb12_space1_046x) + _1018);
    _1053 = ((_1040 * cb12_space1_046y) + _1019);
    _1054 = ((_1040 * cb12_space1_046z) + _1020);
  } else {
    _1052 = _1018;
    _1053 = _1019;
    _1054 = _1020;
  }
  float _1063 = abs(cb12_space1_007y);
  float _1085 = TEXCOORD.x + -0.5f;
  float _1086 = TEXCOORD.y + -0.5f;
  float _1095 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1085, _1086), float2(_1085, _1086))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);

  _1095 = lerp(1.f, _1095, CUSTOM_VIGNETTE);

  float _1120 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _1139 = ((cb12_space1_012x - cb12_space1_010x) * _1120) + cb12_space1_010x;
  float _1140 = ((cb12_space1_012y - cb12_space1_010y) * _1120) + cb12_space1_010y;
  float _1142 = ((cb12_space1_012w - cb12_space1_010w) * _1120) + cb12_space1_010w;
  float _1157 = ((cb12_space1_013x - cb12_space1_011x) * _1120) + cb12_space1_011x;
  float _1158 = ((cb12_space1_013y - cb12_space1_011y) * _1120) + cb12_space1_011y;
  float _1159 = ((cb12_space1_013z - cb12_space1_011z) * _1120) + cb12_space1_011z;
  float _1160 = _1159 * _1139;
  float _1161 = (lerp(cb12_space1_010z, cb12_space1_012z, _1120)) * _1140;
  float _1164 = _1157 * _1142;
  float _1168 = _1158 * _1142;
  float _1171 = _1157 / _1158;
  float _1173 = 1.0f / (((((_1160 + _1161) * _1159) + _1164) / (((_1160 + _1140) * _1159) + _1168)) - _1171);

  float mid_gray = 0.18f;
  {
    float _1029 = 0.18f;
    float _1030 = 0.18f;
    float _1031 = 0.18f;

    float _1052 = 0.18f;
    float _1053 = 0.18f;
    float _1054 = 0.18f;
    float _1177 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _1095)) * (_1052 + select(_1023, (((cb5_014w * _1029) - _1052) * _1063), ((_1029 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _1178 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _1095)) * (_1053 + select(_1023, (((cb5_014w * _1030) - _1053) * _1063), ((_1030 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _1179 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _1095)) * (_1054 + select(_1023, (((cb5_014w * _1031) - _1054) * _1063), ((_1031 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _1180 = _1177 * _1139;
    float _1181 = _1178 * _1139;
    float _1182 = _1179 * _1139;
    // Replace saturate with max
    float _1210 = max(0.f, (((((_1180 + _1161) * _1177) + _1164) / (((_1180 + _1140) * _1177) + _1168)) - _1171) * _1173);
    float _1211 = max(0.f, (((((_1181 + _1161) * _1178) + _1164) / (((_1181 + _1140) * _1178) + _1168)) - _1171) * _1173);
    float _1212 = max(0.f, (((((_1182 + _1161) * _1179) + _1164) / (((_1182 + _1140) * _1179) + _1168)) - _1171) * _1173);

    mid_gray = renodx::color::y::from::BT709(float3(_1210, _1211, _1212));
  }

  float _1177 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _1095)) * (_1052 + select(_1023, (((cb5_014w * _1029) - _1052) * _1063), ((_1029 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1178 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _1095)) * (_1053 + select(_1023, (((cb5_014w * _1030) - _1053) * _1063), ((_1030 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1179 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _1095)) * (_1054 + select(_1023, (((cb5_014w * _1031) - _1054) * _1063), ((_1031 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1180 = _1177 * _1139;
  float _1181 = _1178 * _1139;
  float _1182 = _1179 * _1139;

  float3 untonemapped = float3(_1180, _1181, _1182) * mid_gray / 0.18f;

  // Replace saturate with max
  float _1210 = max(0.f, (((((_1180 + _1161) * _1177) + _1164) / (((_1180 + _1140) * _1177) + _1168)) - _1171) * _1173);
  float _1211 = max(0.f, (((((_1181 + _1161) * _1178) + _1164) / (((_1181 + _1140) * _1178) + _1168)) - _1171) * _1173);
  float _1212 = max(0.f, (((((_1182 + _1161) * _1179) + _1164) / (((_1182 + _1140) * _1179) + _1168)) - _1171) * _1173);

  ApplyPerChannelCorrection(untonemapped, _1210, _1211, _1212);

  float _1213 = dot(float3(_1210, _1211, _1212), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _1222 = (cb12_space1_067x * (_1210 - _1213)) + _1213;
  float _1223 = (cb12_space1_067x * (_1211 - _1213)) + _1213;
  float _1224 = (cb12_space1_067x * (_1212 - _1213)) + _1213;
  float _1228 = saturate(_1213 / cb12_space1_066w);
  float _1245 = (lerp(cb12_space1_066x, cb12_space1_065x, _1228)) * _1222;
  float _1246 = (lerp(cb12_space1_066y, cb12_space1_065y, _1228)) * _1223;
  float _1247 = (lerp(cb12_space1_066z, cb12_space1_065z, _1228)) * _1224;
  float _1253 = saturate(((_1213 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        float3(_1245, _1246, _1247),
        float3(_1222, _1223, _1224),
        _1253,
        TEXCOORD.xy);
  }
  float _1298 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _1314 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _1318 = (_1314.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_1318, _1298);

  float _1325 = saturate(max(0.0f, (_1318 + (_1298 * exp2(log2(abs(saturate(lerp(_1245, _1222, _1253)))) * cb12_space1_067y)))));
  float _1326 = saturate(max(0.0f, (_1318 + (_1298 * exp2(log2(abs(saturate(lerp(_1246, _1223, _1253)))) * cb12_space1_067y)))));
  float _1327 = saturate(max(0.0f, (_1318 + (_1298 * exp2(log2(abs(saturate(lerp(_1247, _1224, _1253)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _1337 = (asint(cb12_space1_092w) != 0);
    float _1339 = max(_1325, max(_1326, _1327));
    float _1393 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _1396 = (_1393.x * 2.0f) + -1.0f;
    float _1402 = float(((int)(uint)((bool)(_1396 > 0.0f))) - ((int)(uint)((bool)(_1396 < 0.0f))));
    float _1406 = 1.0f - sqrt(1.0f - abs(_1396));
    _1417 = (((_1406 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_1337, _1325, _1339) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _1402) + _1325);
    _1418 = (((_1406 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_1337, _1326, _1339) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _1402) + _1326);
    _1419 = (((_1406 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_1337, _1327, _1339) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _1402) + _1327);

    ConfigureVanillaDithering(
        _1325, _1326, _1327,
        _1417, _1418, _1419);

  } else {
    _1417 = _1325;
    _1418 = _1326;
    _1419 = _1327;
  }
  SV_Target.x = _1417;
  SV_Target.y = _1418;
  SV_Target.z = _1419;
  SV_Target.w = dot(float3(_1325, _1326, _1327), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}

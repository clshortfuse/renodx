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
  float cb5_014w : packoffset(c014.w);
  float cb5_015x : packoffset(c015.x);
  float cb5_015y : packoffset(c015.y);
  uint cb5_022y : packoffset(c022.y);
};

cbuffer cb12_space1 : register(b12, space1) {
  float cb12_space1_000z : packoffset(c000.z);
  float cb12_space1_000w : packoffset(c000.w);
  float cb12_space1_002x : packoffset(c002.x);
  float cb12_space1_002y : packoffset(c002.y);
  float cb12_space1_002z : packoffset(c002.z);
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
  float _33 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _35 = 1.0f - _33.x;
  float _40 = cb12_space1_000z / (_35 + cb12_space1_000w);
  float4 _58 = t16_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _68 = (((_58.x * float((bool)((bool)((bool)(_40 > cb12_space1_030y) && (bool)(_40 < cb12_space1_030y))))) * cb12_space1_033z) * (cb12_space1_030w - cb12_space1_030z)) + cb12_space1_030z;
  float4 _87 = t29_space1.Sample(s3_space1, float2(((cb12_space1_031x * TEXCOORD.x) + cb12_space1_031z), ((cb12_space1_031y * TEXCOORD.y) + cb12_space1_031w)));
  float4 _90 = t29_space1.Sample(s3_space1, float2(((cb12_space1_032x * TEXCOORD.x) + cb12_space1_032z), ((cb12_space1_032y * TEXCOORD.y) + cb12_space1_032w)));
  float _114 = min(max((1.0f - saturate(((cb12_space1_072z / cb12_space1_072w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  float _121 = (((cb12_space1_033x * _68) * ((_87.x + -1.0f) + _90.x)) + TEXCOORD.x) + -0.5f;
  float _122 = (((cb12_space1_033y * _68) * ((_87.y + -1.0f) + _90.y)) + TEXCOORD.y) + -0.5f;
  float _123 = (cb12_space1_072x / cb12_space1_072y) * _121;
  float _124 = dot(float2(_123, _122), float2(_123, _122));
  float _130 = CUSTOM_LENS_DISTORTION * ((_114 * _124) * ((sqrt(_124) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
  float _131 = _130 * _121;
  float _132 = _130 * _122;
  float _133 = _131 + 0.5f;
  float _134 = _132 + 0.5f;
  float _138 = _133 * cb5_015x;
  float _139 = _134 * cb5_015y;
  float _142 = floor(_138 + -0.5f);
  float _143 = floor(_139 + -0.5f);
  float _144 = _142 + 0.5f;
  float _145 = _143 + 0.5f;
  float _146 = _138 - _144;
  float _147 = _139 - _145;
  float _148 = _146 * _146;
  float _149 = _147 * _147;
  float _150 = _148 * _146;
  float _151 = _149 * _147;
  float _156 = _148 - ((_150 + _146) * 0.5f);
  float _157 = _149 - ((_151 + _147) * 0.5f);
  float _169 = (_146 * 0.5f) * (_148 - _146);
  float _171 = (_147 * 0.5f) * (_149 - _147);
  float _173 = (1.0f - _169) - _156;
  float _176 = (1.0f - _171) - _157;
  float _188 = (((_173 - (((_150 * 1.5f) - (_148 * 2.5f)) + 1.0f)) / _173) + _144) / cb5_015x;
  float _189 = (((_176 - (((_151 * 1.5f) - (_149 * 2.5f)) + 1.0f)) / _176) + _145) / cb5_015y;
  float _192 = _173 * _157;
  float _193 = _176 * _156;
  float _194 = _173 * _176;
  float _195 = _176 * _169;
  float _196 = _173 * _171;
  float _200 = (((_192 + _193) + _194) + _195) + _196;
  float4 _205 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_188, ((_143 + -0.5f) / cb5_015y)), 0.0f);
  float4 _214 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_142 + -0.5f) / cb5_015x), _189), 0.0f);
  float4 _225 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_188, _189), 0.0f);
  float4 _236 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_142 + 2.5f) / cb5_015x), _189), 0.0f);
  float4 _247 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_188, ((_143 + 2.5f) / cb5_015y)), 0.0f);
  float _256 = max(0.0f, ((((((_214.y * _193) + (_205.y * _192)) + (_225.y * _194)) + (_236.y * _195)) + (_247.y * _196)) / _200));
  float _257 = max(0.0f, ((((((_214.z * _193) + (_205.z * _192)) + (_225.z * _194)) + (_236.z * _195)) + (_247.z * _196)) / _200));
  float _265 = (cb12_space1_072x / cb12_space1_072y) * _131;
  float _266 = dot(float2(_265, _132), float2(_265, _132));
  float _272 = CUSTOM_CHROMATIC_ABERRATION * ((_114 * _266) * ((sqrt(_266) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _281 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_272 * _131) + 0.5f), ((_272 * _132) + 0.5f)));
  float _285 = cb5_014w * _281.x;
  float4 _287 = t19_space1.Sample(s1_space1, float2(_133, _134));
  float _291 = saturate(max(((saturate(cb12_space1_002y * (_40 - cb12_space1_002x)) * float((bool)((bool)(!(_35 == 0.0f))))) * cb12_space1_002z), _68));
  float _298 = ((_287.x - _285) * _291) + _285;
  float _299 = ((_287.y - _256) * _291) + _256;
  float _300 = ((_287.z - _257) * _291) + _257;
  int _303 = int(cb12_space1_017z);
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
  float _1359;
  float _1360;
  float _1361;
  if (_303 == 1) {
    uint2 _315 = t18_space1.Load(int3(int(cb5_015x * _133), int(cb5_015y * _134), 0));
    float _322 = select(((float((uint)(int)(_315.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
    float _325 = (_133 * 2.0f) + -1.0f;
    float _326 = 1.0f - (_134 * 2.0f);
    float _349 = (g_rage_matrices_192[3].x) + (dot(float3(_325, _326, 1.0f), float3(cb12_space1_021x, cb12_space1_021y, cb12_space1_021z)) * _40);
    float _350 = (g_rage_matrices_192[3].y) + (dot(float3(_325, _326, 1.0f), float3(cb12_space1_022x, cb12_space1_022y, cb12_space1_022z)) * _40);
    float _351 = (g_rage_matrices_192[3].z) + (dot(float3(_325, _326, 1.0f), float3(cb12_space1_023x, cb12_space1_023y, cb12_space1_023z)) * _40);
    float _369 = dot(float4(_349, _350, _351, 1.0f), float4(cb12_space1_020x, cb12_space1_020y, cb12_space1_020z, cb12_space1_020w));
    float _371 = select((_369 == 0.0f), 9.999999747378752e-06f, _369);
    float _376 = (_325 - (dot(float4(_349, _350, _351, 1.0f), float4(cb12_space1_018x, cb12_space1_018y, cb12_space1_018z, cb12_space1_018w)) / _371)) * 40.0f;
    float _377 = (_326 - (dot(float4(_349, _350, _351, 1.0f), float4(cb12_space1_019x, cb12_space1_019y, cb12_space1_019z, cb12_space1_019w)) / _371)) * -22.5f;
    float _378 = dot(float2(_376, _377), float2(_376, _377));
    bool _379 = (_378 > 1.0f);
    float _380 = rsqrt(_378);
    float _386 = (cb12_space1_016x * 0.012500000186264515f) * select(_379, (_380 * _376), _376);
    float _388 = (cb12_space1_016x * 0.02222222276031971f) * select(_379, (_377 * _380), _377);
    float _389 = _322 * _298;
    float _390 = _322 * _299;
    float _391 = _322 * _300;
    float4 _401 = t28_space1.Sample(s6_space1, float2(((_298 * 8.0f) + (_133 * 58.16400146484375f)), ((_299 * 8.0f) + (_134 * 47.130001068115234f))));
    if ((int)int(cb12_space1_017x) > (int)1) {
      _410 = _389;
      _411 = _390;
      _412 = _391;
      _413 = _322;
      _414 = 1;
      while (true) {
        float _416 = float(_414) + ((_401.x + -0.5f) * 0.5f);
        float _430 = (round((((_386 * cb12_space1_017y) * _416) + _133) * cb5_015x) + 0.5f) / cb5_015x;
        float _431 = (round((((_388 * cb12_space1_017y) * _416) + _134) * cb5_015y) + 0.5f) / cb5_015y;
        uint2 _436 = t18_space1.Load(int3(int(cb5_015x * _430), int(cb5_015y * _431), 0));
        float _443 = select(((float((uint)(int)(_436.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
        float4 _444 = t19_space1.SampleLevel(s1_space1, float2(_430, _431), 0.0f);
        float _451 = (_444.x * _443) + _410;
        float _452 = (_444.y * _443) + _411;
        float _453 = (_444.z * _443) + _412;
        float _454 = _443 + _413;
        int _455 = _414 + 1;
        if ((int)_455 < (int)int(cb12_space1_017x)) {
          _410 = _451;
          _411 = _452;
          _412 = _453;
          _413 = _454;
          _414 = _455;
          continue;
        }
        _462 = _451;
        _463 = _452;
        _464 = _453;
        _465 = _454;
        break;
      }
    } else {
      _462 = _389;
      _463 = _390;
      _464 = _391;
      _465 = _322;
    }
    float _466 = max(_465, 0.10000000149011612f);
    float _473 = saturate(dot(float2(_386, _388), float2(_386, _388)) * 1e+05f) * _322;
    _945 = ((_473 * ((_462 / _466) - _298)) + _298);
    _946 = ((_473 * ((_463 / _466) - _299)) + _299);
    _947 = ((_473 * ((_464 / _466) - _300)) + _300);
  } else {
    if (_303 == 2) {
      float4 _491 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _133), (cb12_space1_088y * _134)), 0.0f);
      [branch]
      if ((bool)(_491.z >= 1.0f) && (bool)(_491.w < 2.0f)) {
        float2 _500 = t22_space1.SampleLevel(s0_space1, float2(_133, _134), 0.0f);
        float _505 = cb12_space1_016x * _500.x;
        float _506 = cb12_space1_016x * _500.y;
        float _515 = min(_491.z, 2.0f);
        int _520 = int(min(2.0f, (_515 + 1.0f)));
        float _524 = cb12_space1_072x * (_515 * (_491.x / _491.z));
        float _525 = cb12_space1_072y * (_515 * (_491.y / _491.z));
        float _527 = float(_520) + -0.5f;
        float _528 = _527 / _515;
        float _545 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_515 + -2.0f) * 0.5f);
        if ((int)_520 > (int)0) {
          _551 = 0.0f;
          _552 = 0.0f;
          _553 = 0.0f;
          _554 = 0.0f;
          _555 = 0;
          while (true) {
            float _556 = float(_555);
            float _557 = (_545 + 0.5f) + _556;
            float _558 = _557 / _527;
            float _561 = (_524 * _558) + _133;
            float _562 = (_525 * _558) + _134;
            float2 _563 = t22_space1.SampleLevel(s0_space1, float2(_561, _562), 0.0f);
            float _568 = cb12_space1_016x * _563.x;
            float _569 = cb12_space1_016x * _563.y;
            float _575 = min(sqrt((_568 * _568) + (_569 * _569)), cb12_space1_016z);
            float _576 = t11_space1.SampleLevel(s0_space1, float2(_561, _562), 0.0f);
            float _583 = cb12_space1_000z / ((1.0f - _576.x) + cb12_space1_000w);
            float _589 = _528 * min(sqrt((_505 * _505) + (_506 * _506)), cb12_space1_016z);
            float _590 = _583 - _40;
            float _596 = max((_557 + -1.0f), 0.0f);
            float4 _603 = t19_space1.SampleLevel(s1_space1, float2(_561, _562), 0.0f);
            float _607 = _556 + (0.5f - _545);
            float _608 = _607 / _527;
            float _611 = _133 - (_524 * _608);
            float _612 = _134 - (_525 * _608);
            float2 _613 = t22_space1.SampleLevel(s0_space1, float2(_611, _612), 0.0f);
            float _616 = cb12_space1_016x * _613.x;
            float _617 = cb12_space1_016x * _613.y;
            float _622 = min(sqrt((_616 * _616) + (_617 * _617)), cb12_space1_016z);
            float _623 = t11_space1.SampleLevel(s0_space1, float2(_611, _612), 0.0f);
            float _627 = cb12_space1_000z / ((1.0f - _623.x) + cb12_space1_000w);
            float _633 = _627 - _40;
            float _639 = max((_607 + -1.0f), 0.0f);
            float _645 = dot(float2(saturate(_633 + 0.5f), saturate(0.5f - _633)), float2(saturate(_589 - _639), saturate((_622 * _528) - _639))) * (1.0f - saturate((1.0f - _622) * 8.0f));
            float4 _646 = t19_space1.SampleLevel(s1_space1, float2(_611, _612), 0.0f);
            bool _650 = (_583 > _627);
            bool _651 = (_622 > _575);
            float _653 = select((_651 && _650), _645, (dot(float2(saturate(_590 + 0.5f), saturate(0.5f - _590)), float2(saturate(_589 - _596), saturate((_575 * _528) - _596))) * (1.0f - saturate((1.0f - _575) * 8.0f))));
            float _655 = select((_651 || _650), _645, _653);
            float _663 = ((_653 * _603.x) + _551) + (_646.x * _655);
            float _665 = ((_653 * _603.y) + _552) + (_646.y * _655);
            float _667 = ((_653 * _603.z) + _553) + (_646.z * _655);
            float _669 = (_653 + _554) + _655;
            int _670 = _555 + 1;
            if (!(_670 == _520)) {
              _551 = _663;
              _552 = _665;
              _553 = _667;
              _554 = _669;
              _555 = _670;
              continue;
            }
            _674 = _663;
            _675 = _665;
            _676 = _667;
            _677 = _669;
            break;
          }
        } else {
          _674 = 0.0f;
          _675 = 0.0f;
          _676 = 0.0f;
          _677 = 0.0f;
        }
        float _679 = float(_520 << 1);
        _685 = (_674 / _679);
        _686 = (_675 / _679);
        _687 = (_676 / _679);
        _688 = (_677 / _679);
      } else {
        _685 = 0.0f;
        _686 = 0.0f;
        _687 = 0.0f;
        _688 = 0.0f;
      }
      float _689 = 1.0f - _688;
      float4 _696 = t20_space1.SampleLevel(s1_space1, float2(_133, _134), 0.0f);
      float _701 = 1.0f - _696.w;
      _945 = ((_701 * ((_689 * _298) + _685)) + _696.x);
      _946 = ((_701 * ((_689 * _299) + _686)) + _696.y);
      _947 = ((_701 * ((_689 * _300) + _687)) + _696.z);
    } else {
      if (_303 == 3) {
        float4 _716 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _133), (cb12_space1_088y * _134)), 0.0f);
        [branch]
        if ((bool)(_716.z >= 1.0f) && (bool)(_716.w < 2.0f)) {
          float2 _725 = t22_space1.SampleLevel(s0_space1, float2(_133, _134), 0.0f);
          float4 _735 = t19_space1.Load(int3(int(cb5_015x * _133), int(cb5_015y * _134), 0));
          float _739 = cb12_space1_016x * _725.x;
          float _740 = cb12_space1_016x * _725.y;
          float _749 = min(_716.z, 2.0f);
          int _754 = int(min(2.0f, (_749 + 1.0f)));
          float _758 = cb12_space1_072x * (_749 * (_716.x / _716.z));
          float _759 = cb12_space1_072y * (_749 * (_716.y / _716.z));
          float _761 = float(_754) + -0.5f;
          float _762 = _761 / _749;
          float _779 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_749 + -2.0f) * 0.5f);
          if ((int)_754 > (int)0) {
            _785 = 0.0f;
            _786 = 0.0f;
            _787 = 0.0f;
            _788 = 0.0f;
            _789 = 0;
            while (true) {
              float _790 = float(_789);
              float _791 = (_779 + 0.5f) + _790;
              float _792 = _791 / _761;
              float _795 = (_758 * _792) + _133;
              float _796 = (_759 * _792) + _134;
              float2 _797 = t22_space1.SampleLevel(s0_space1, float2(_795, _796), 0.0f);
              float _802 = cb12_space1_016x * _797.x;
              float _803 = cb12_space1_016x * _797.y;
              float _809 = min(sqrt((_802 * _802) + (_803 * _803)), cb12_space1_016z);
              float4 _817 = t19_space1.Load(int3(int(cb5_015x * _795), int(cb5_015y * _796), 0));
              float _824 = _762 * min(sqrt((_739 * _739) + (_740 * _740)), cb12_space1_016z);
              float _825 = _817.w - _735.w;
              float _831 = max((_791 + -1.0f), 0.0f);
              float4 _838 = t19_space1.SampleLevel(s1_space1, float2(_795, _796), 0.0f);
              float _842 = _790 + (0.5f - _779);
              float _843 = _842 / _761;
              float _846 = _133 - (_758 * _843);
              float _847 = _134 - (_759 * _843);
              float2 _848 = t22_space1.SampleLevel(s0_space1, float2(_846, _847), 0.0f);
              float _851 = cb12_space1_016x * _848.x;
              float _852 = cb12_space1_016x * _848.y;
              float _857 = min(sqrt((_851 * _851) + (_852 * _852)), cb12_space1_016z);
              float4 _862 = t19_space1.Load(int3(int(cb5_015x * _846), int(cb5_015y * _847), 0));
              float _869 = _862.w - _735.w;
              float _875 = max((_842 + -1.0f), 0.0f);
              float _881 = dot(float2(saturate(_869 + 0.5f), saturate(0.5f - _869)), float2(saturate(_824 - _875), saturate((_857 * _762) - _875))) * (1.0f - saturate((1.0f - _857) * 8.0f));
              float4 _882 = t19_space1.SampleLevel(s1_space1, float2(_846, _847), 0.0f);
              bool _886 = (_817.w > _862.w);
              bool _887 = (_857 > _809);
              float _889 = select((_887 && _886), _881, (dot(float2(saturate(_825 + 0.5f), saturate(0.5f - _825)), float2(saturate(_824 - _831), saturate((_809 * _762) - _831))) * (1.0f - saturate((1.0f - _809) * 8.0f))));
              float _891 = select((_887 || _886), _881, _889);
              float _899 = ((_889 * _838.x) + _785) + (_882.x * _891);
              float _901 = ((_889 * _838.y) + _786) + (_882.y * _891);
              float _903 = ((_889 * _838.z) + _787) + (_882.z * _891);
              float _905 = (_889 + _788) + _891;
              int _906 = _789 + 1;
              if (!(_906 == _754)) {
                _785 = _899;
                _786 = _901;
                _787 = _903;
                _788 = _905;
                _789 = _906;
                continue;
              }
              _910 = _899;
              _911 = _901;
              _912 = _903;
              _913 = _905;
              break;
            }
          } else {
            _910 = 0.0f;
            _911 = 0.0f;
            _912 = 0.0f;
            _913 = 0.0f;
          }
          float _915 = float(_754 << 1);
          _921 = (_910 / _915);
          _922 = (_911 / _915);
          _923 = (_912 / _915);
          _924 = (_913 / _915);
        } else {
          _921 = 0.0f;
          _922 = 0.0f;
          _923 = 0.0f;
          _924 = 0.0f;
        }
        float _925 = 1.0f - _924;
        float4 _932 = t20_space1.SampleLevel(s1_space1, float2(_133, _134), 0.0f);
        float _937 = 1.0f - _932.w;
        _945 = ((_937 * ((_925 * _298) + _921)) + _932.x);
        _946 = ((_937 * ((_925 * _299) + _922)) + _932.y);
        _947 = ((_937 * ((_925 * _300) + _923)) + _932.z);
      } else {
        _945 = _298;
        _946 = _299;
        _947 = _300;
      }
    }
  }
  float4 _948 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _960 = (cb12_space1_064x * (_948.x - _945)) + _945;
  float _961 = (cb12_space1_064x * (_948.y - _946)) + _946;
  float _962 = (cb12_space1_064x * (_948.z - _947)) + _947;
  bool _965 = (cb12_space1_007y < 0.0f);
  float _966 = select(_965, 1.0f, TEXCOORD.w);
  float4 _967 = t25_space1.Sample(s2_space1, float2(_133, _134));

  _967 *= CUSTOM_BLOOM;

  float _971 = _967.x * _966;
  float _972 = _967.y * _966;
  float _973 = _967.z * _966;
  if (cb12_space1_075z > 0.0f) {
    float4 _978 = t31_space1.Sample(s2_space1, float2(_133, _134));

    _978 = max(0, _978);  // Fix NaN

    float _980 = _978.x * _978.x;
    float _981 = _980 * _980;
    float _982 = _981 * _981 * CUSTOM_SUN_BLOOM;

    _994 = ((_982 * cb12_space1_046x) + _960);
    _995 = ((_982 * cb12_space1_046y) + _961);
    _996 = ((_982 * cb12_space1_046z) + _962);
  } else {
    _994 = _960;
    _995 = _961;
    _996 = _962;
  }

  float3 untonemapped = float3(_994, _995, _996);

  float _1005 = abs(cb12_space1_007y);
  float _1027 = TEXCOORD.x + -0.5f;
  float _1028 = TEXCOORD.y + -0.5f;
  float _1037 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1027, _1028), float2(_1027, _1028))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);
  float _1062 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _1081 = ((cb12_space1_012x - cb12_space1_010x) * _1062) + cb12_space1_010x;
  float _1082 = ((cb12_space1_012y - cb12_space1_010y) * _1062) + cb12_space1_010y;
  float _1084 = ((cb12_space1_012w - cb12_space1_010w) * _1062) + cb12_space1_010w;
  float _1099 = ((cb12_space1_013x - cb12_space1_011x) * _1062) + cb12_space1_011x;
  float _1100 = ((cb12_space1_013y - cb12_space1_011y) * _1062) + cb12_space1_011y;
  float _1101 = ((cb12_space1_013z - cb12_space1_011z) * _1062) + cb12_space1_011z;
  float _1102 = _1101 * _1081;
  float _1103 = (lerp(cb12_space1_010z, cb12_space1_012z, _1062)) * _1082;
  float _1106 = _1099 * _1084;
  float _1110 = _1100 * _1084;
  float _1113 = _1099 / _1100;
  float _1115 = 1.0f / (((((_1102 + _1103) * _1101) + _1106) / (((_1102 + _1082) * _1101) + _1110)) - _1113);

  float mid_gray = 0.18f;
  {
    float _971 = 0.18f;
    float _972 = 0.18f;
    float _973 = 0.18f;

    float _994 = 0.18f;
    float _995 = 0.18f;
    float _996 = 0.18f;

    float _1119 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _1037)) * (_994 + select(_965, (((cb5_014w * _971) - _994) * _1005), ((_971 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _1120 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _1037)) * (_995 + select(_965, (((cb5_014w * _972) - _995) * _1005), ((_972 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _1121 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _1037)) * (_996 + select(_965, (((cb5_014w * _973) - _996) * _1005), ((_973 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
    float _1122 = _1119 * _1081;
    float _1123 = _1120 * _1081;
    float _1124 = _1121 * _1081;
    // Replace saturate with max
    float _1152 = max(0.f, (((((_1122 + _1103) * _1119) + _1106) / (((_1122 + _1082) * _1119) + _1110)) - _1113) * _1115);
    float _1153 = max(0.f, (((((_1123 + _1103) * _1120) + _1106) / (((_1123 + _1082) * _1120) + _1110)) - _1113) * _1115);
    float _1154 = max(0.f, (((((_1124 + _1103) * _1121) + _1106) / (((_1124 + _1082) * _1121) + _1110)) - _1113) * _1115);

    mid_gray = renodx::color::y::from::BT709(float3(_1152, _1153, _1154));
  }

  float _1119 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _1037)) * (_994 + select(_965, (((cb5_014w * _971) - _994) * _1005), ((_971 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1120 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _1037)) * (_995 + select(_965, (((cb5_014w * _972) - _995) * _1005), ((_972 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1121 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _1037)) * (_996 + select(_965, (((cb5_014w * _973) - _996) * _1005), ((_973 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1122 = _1119 * _1081;
  float _1123 = _1120 * _1081;
  float _1124 = _1121 * _1081;
  // Replace saturate with max
  float _1152 = max(0.f, (((((_1122 + _1103) * _1119) + _1106) / (((_1122 + _1082) * _1119) + _1110)) - _1113) * _1115);
  float _1153 = max(0.f, (((((_1123 + _1103) * _1120) + _1106) / (((_1123 + _1082) * _1120) + _1110)) - _1113) * _1115);
  float _1154 = max(0.f, (((((_1124 + _1103) * _1121) + _1106) / (((_1124 + _1082) * _1121) + _1110)) - _1113) * _1115);
  float _1155 = dot(float3(_1152, _1153, _1154), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _1164 = (cb12_space1_067x * (_1152 - _1155)) + _1155;
  float _1165 = (cb12_space1_067x * (_1153 - _1155)) + _1155;
  float _1166 = (cb12_space1_067x * (_1154 - _1155)) + _1155;
  float _1170 = saturate(_1155 / cb12_space1_066w);
  float _1187 = (lerp(cb12_space1_066x, cb12_space1_065x, _1170)) * _1164;
  float _1188 = (lerp(cb12_space1_066y, cb12_space1_065y, _1170)) * _1165;
  float _1189 = (lerp(cb12_space1_066z, cb12_space1_065z, _1170)) * _1166;
  float _1195 = saturate(((_1155 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        mid_gray,
        float3(_1187, _1188, _1189),
        float3(_1164, _1165, _1166),
        _1195,
        TEXCOORD.xy);
  }

  float _1240 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _1256 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _1260 = (_1256.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_1260, _1240);

  float _1267 = saturate(max(0.0f, (_1260 + (_1240 * exp2(log2(abs(saturate(lerp(_1187, _1164, _1195)))) * cb12_space1_067y)))));
  float _1268 = saturate(max(0.0f, (_1260 + (_1240 * exp2(log2(abs(saturate(lerp(_1188, _1165, _1195)))) * cb12_space1_067y)))));
  float _1269 = saturate(max(0.0f, (_1260 + (_1240 * exp2(log2(abs(saturate(lerp(_1189, _1166, _1195)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _1279 = (asint(cb12_space1_092w) != 0);
    float _1281 = max(_1267, max(_1268, _1269));
    float _1335 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _1338 = (_1335.x * 2.0f) + -1.0f;
    float _1344 = float(((int)(uint)((bool)(_1338 > 0.0f))) - ((int)(uint)((bool)(_1338 < 0.0f))));
    float _1348 = 1.0f - sqrt(1.0f - abs(_1338));
    _1359 = (((_1348 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_1279, _1267, _1281) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _1344) + _1267);
    _1360 = (((_1348 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_1279, _1268, _1281) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _1344) + _1268);
    _1361 = (((_1348 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_1279, _1269, _1281) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _1344) + _1269);

    ConfigureVanillaDithering(
        _1267, _1268, _1269,
        _1359, _1360, _1361);

  } else {
    _1359 = _1267;
    _1360 = _1268;
    _1361 = _1269;
  }
  SV_Target.x = _1359;
  SV_Target.y = _1360;
  SV_Target.z = _1361;
  SV_Target.w = dot(float3(_1267, _1268, _1269), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}

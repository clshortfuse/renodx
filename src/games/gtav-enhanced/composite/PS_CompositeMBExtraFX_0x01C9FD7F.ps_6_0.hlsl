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
  float cb12_space1_034x : packoffset(c034.x);
  float cb12_space1_034y : packoffset(c034.y);
  float cb12_space1_034z : packoffset(c034.z);
  float cb12_space1_034w : packoffset(c034.w);
  float cb12_space1_035x : packoffset(c035.x);
  float cb12_space1_036w : packoffset(c036.w);
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
  float _32 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _34 = 1.0f - _32.x;
  float _39 = cb12_space1_000z / (_34 + cb12_space1_000w);
  float _60 = min(max((1.0f - saturate(((cb12_space1_072z / cb12_space1_072w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  float _67 = TEXCOORD.x + -0.5f;
  float _68 = TEXCOORD.y + -0.5f;
  float _69 = (cb12_space1_072x / cb12_space1_072y) * _67;
  float _70 = dot(float2(_69, _68), float2(_69, _68));
  float _76 = CUSTOM_LENS_DISTORTION * ((_60 * _70) * ((sqrt(_70) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
  float _77 = _76 * _67;
  float _78 = _76 * _68;
  float _79 = _77 + 0.5f;
  float _80 = _78 + 0.5f;
  float _84 = _79 * cb5_015x;
  float _85 = _80 * cb5_015y;
  float _88 = floor(_84 + -0.5f);
  float _89 = floor(_85 + -0.5f);
  float _90 = _88 + 0.5f;
  float _91 = _89 + 0.5f;
  float _92 = _84 - _90;
  float _93 = _85 - _91;
  float _94 = _92 * _92;
  float _95 = _93 * _93;
  float _96 = _94 * _92;
  float _97 = _95 * _93;
  float _102 = _94 - ((_96 + _92) * 0.5f);
  float _103 = _95 - ((_97 + _93) * 0.5f);
  float _115 = (_92 * 0.5f) * (_94 - _92);
  float _117 = (_93 * 0.5f) * (_95 - _93);
  float _119 = (1.0f - _115) - _102;
  float _122 = (1.0f - _117) - _103;
  float _134 = (((_119 - (((_96 * 1.5f) - (_94 * 2.5f)) + 1.0f)) / _119) + _90) / cb5_015x;
  float _135 = (((_122 - (((_97 * 1.5f) - (_95 * 2.5f)) + 1.0f)) / _122) + _91) / cb5_015y;
  float _138 = _119 * _103;
  float _139 = _122 * _102;
  float _140 = _119 * _122;
  float _141 = _122 * _115;
  float _142 = _119 * _117;
  float _146 = (((_138 + _139) + _140) + _141) + _142;
  float4 _151 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_134, ((_89 + -0.5f) / cb5_015y)), 0.0f);
  float4 _160 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_88 + -0.5f) / cb5_015x), _135), 0.0f);
  float4 _171 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_134, _135), 0.0f);
  float4 _182 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_88 + 2.5f) / cb5_015x), _135), 0.0f);
  float4 _193 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_134, ((_89 + 2.5f) / cb5_015y)), 0.0f);
  float _202 = max(0.0f, ((((((_160.y * _139) + (_151.y * _138)) + (_171.y * _140)) + (_182.y * _141)) + (_193.y * _142)) / _146));
  float _203 = max(0.0f, ((((((_160.z * _139) + (_151.z * _138)) + (_171.z * _140)) + (_182.z * _141)) + (_193.z * _142)) / _146));
  float _211 = (cb12_space1_072x / cb12_space1_072y) * _77;
  float _212 = dot(float2(_211, _78), float2(_211, _78));
  float _218 = CUSTOM_CHROMATIC_ABERRATION * ((_60 * _212) * ((sqrt(_212) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _227 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_218 * _77) + 0.5f), ((_218 * _78) + 0.5f)));
  float _231 = cb5_014w * _227.x;
  float4 _232 = t19_space1.Sample(s1_space1, float2(_79, _80));
  float _236 = saturate((saturate(cb12_space1_002y * (_39 - cb12_space1_002x)) * float((bool)((bool)(!(_34 == 0.0f))))) * cb12_space1_002z);
  float _243 = ((_232.x - _231) * _236) + _231;
  float _244 = ((_232.y - _202) * _236) + _202;
  float _245 = ((_232.z - _203) * _236) + _203;
  int _248 = int(cb12_space1_017z);
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
  float _1333;
  float _1334;
  float _1335;
  if (_248 == 1) {
    uint2 _260 = t18_space1.Load(int3(int(cb5_015x * _79), int(cb5_015y * _80), 0));
    float _267 = select(((float((uint)(int)(_260.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
    float _270 = (_79 * 2.0f) + -1.0f;
    float _271 = 1.0f - (_80 * 2.0f);
    float _294 = (g_rage_matrices_192[3].x) + (dot(float3(_270, _271, 1.0f), float3(cb12_space1_021x, cb12_space1_021y, cb12_space1_021z)) * _39);
    float _295 = (g_rage_matrices_192[3].y) + (dot(float3(_270, _271, 1.0f), float3(cb12_space1_022x, cb12_space1_022y, cb12_space1_022z)) * _39);
    float _296 = (g_rage_matrices_192[3].z) + (dot(float3(_270, _271, 1.0f), float3(cb12_space1_023x, cb12_space1_023y, cb12_space1_023z)) * _39);
    float _314 = dot(float4(_294, _295, _296, 1.0f), float4(cb12_space1_020x, cb12_space1_020y, cb12_space1_020z, cb12_space1_020w));
    float _316 = select((_314 == 0.0f), 9.999999747378752e-06f, _314);
    float _321 = (_270 - (dot(float4(_294, _295, _296, 1.0f), float4(cb12_space1_018x, cb12_space1_018y, cb12_space1_018z, cb12_space1_018w)) / _316)) * 40.0f;
    float _322 = (_271 - (dot(float4(_294, _295, _296, 1.0f), float4(cb12_space1_019x, cb12_space1_019y, cb12_space1_019z, cb12_space1_019w)) / _316)) * -22.5f;
    float _323 = dot(float2(_321, _322), float2(_321, _322));
    bool _324 = (_323 > 1.0f);
    float _325 = rsqrt(_323);
    float _331 = (cb12_space1_016x * 0.012500000186264515f) * select(_324, (_325 * _321), _321);
    float _333 = (cb12_space1_016x * 0.02222222276031971f) * select(_324, (_322 * _325), _322);
    float _334 = _267 * _243;
    float _335 = _267 * _244;
    float _336 = _267 * _245;
    float4 _346 = t28_space1.Sample(s6_space1, float2(((_243 * 8.0f) + (_79 * 58.16400146484375f)), ((_244 * 8.0f) + (_80 * 47.130001068115234f))));
    if ((int)int(cb12_space1_017x) > (int)1) {
      _355 = _334;
      _356 = _335;
      _357 = _336;
      _358 = _267;
      _359 = 1;
      while (true) {
        float _361 = float(_359) + ((_346.x + -0.5f) * 0.5f);
        float _375 = (round((((_331 * cb12_space1_017y) * _361) + _79) * cb5_015x) + 0.5f) / cb5_015x;
        float _376 = (round((((_333 * cb12_space1_017y) * _361) + _80) * cb5_015y) + 0.5f) / cb5_015y;
        uint2 _381 = t18_space1.Load(int3(int(cb5_015x * _375), int(cb5_015y * _376), 0));
        float _388 = select(((float((uint)(int)(_381.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
        float4 _389 = t19_space1.SampleLevel(s1_space1, float2(_375, _376), 0.0f);
        float _396 = (_389.x * _388) + _355;
        float _397 = (_389.y * _388) + _356;
        float _398 = (_389.z * _388) + _357;
        float _399 = _388 + _358;
        int _400 = _359 + 1;
        if ((int)_400 < (int)int(cb12_space1_017x)) {
          _355 = _396;
          _356 = _397;
          _357 = _398;
          _358 = _399;
          _359 = _400;
          continue;
        }
        _407 = _396;
        _408 = _397;
        _409 = _398;
        _410 = _399;
        break;
      }
    } else {
      _407 = _334;
      _408 = _335;
      _409 = _336;
      _410 = _267;
    }
    float _411 = max(_410, 0.10000000149011612f);
    float _418 = saturate(dot(float2(_331, _333), float2(_331, _333)) * 1e+05f) * _267;
    _890 = ((_418 * ((_407 / _411) - _243)) + _243);
    _891 = ((_418 * ((_408 / _411) - _244)) + _244);
    _892 = ((_418 * ((_409 / _411) - _245)) + _245);
  } else {
    if (_248 == 2) {
      float4 _436 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _79), (cb12_space1_088y * _80)), 0.0f);
      [branch]
      if ((bool)(_436.z >= 1.0f) && (bool)(_436.w < 2.0f)) {
        float2 _445 = t22_space1.SampleLevel(s0_space1, float2(_79, _80), 0.0f);
        float _450 = cb12_space1_016x * _445.x;
        float _451 = cb12_space1_016x * _445.y;
        float _460 = min(_436.z, 2.0f);
        int _465 = int(min(2.0f, (_460 + 1.0f)));
        float _469 = cb12_space1_072x * (_460 * (_436.x / _436.z));
        float _470 = cb12_space1_072y * (_460 * (_436.y / _436.z));
        float _472 = float(_465) + -0.5f;
        float _473 = _472 / _460;
        float _490 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_460 + -2.0f) * 0.5f);
        if ((int)_465 > (int)0) {
          _496 = 0.0f;
          _497 = 0.0f;
          _498 = 0.0f;
          _499 = 0.0f;
          _500 = 0;
          while (true) {
            float _501 = float(_500);
            float _502 = (_490 + 0.5f) + _501;
            float _503 = _502 / _472;
            float _506 = (_469 * _503) + _79;
            float _507 = (_470 * _503) + _80;
            float2 _508 = t22_space1.SampleLevel(s0_space1, float2(_506, _507), 0.0f);
            float _513 = cb12_space1_016x * _508.x;
            float _514 = cb12_space1_016x * _508.y;
            float _520 = min(sqrt((_513 * _513) + (_514 * _514)), cb12_space1_016z);
            float _521 = t11_space1.SampleLevel(s0_space1, float2(_506, _507), 0.0f);
            float _528 = cb12_space1_000z / ((1.0f - _521.x) + cb12_space1_000w);
            float _534 = _473 * min(sqrt((_450 * _450) + (_451 * _451)), cb12_space1_016z);
            float _535 = _528 - _39;
            float _541 = max((_502 + -1.0f), 0.0f);
            float4 _548 = t19_space1.SampleLevel(s1_space1, float2(_506, _507), 0.0f);
            float _552 = _501 + (0.5f - _490);
            float _553 = _552 / _472;
            float _556 = _79 - (_469 * _553);
            float _557 = _80 - (_470 * _553);
            float2 _558 = t22_space1.SampleLevel(s0_space1, float2(_556, _557), 0.0f);
            float _561 = cb12_space1_016x * _558.x;
            float _562 = cb12_space1_016x * _558.y;
            float _567 = min(sqrt((_561 * _561) + (_562 * _562)), cb12_space1_016z);
            float _568 = t11_space1.SampleLevel(s0_space1, float2(_556, _557), 0.0f);
            float _572 = cb12_space1_000z / ((1.0f - _568.x) + cb12_space1_000w);
            float _578 = _572 - _39;
            float _584 = max((_552 + -1.0f), 0.0f);
            float _590 = dot(float2(saturate(_578 + 0.5f), saturate(0.5f - _578)), float2(saturate(_534 - _584), saturate((_567 * _473) - _584))) * (1.0f - saturate((1.0f - _567) * 8.0f));
            float4 _591 = t19_space1.SampleLevel(s1_space1, float2(_556, _557), 0.0f);
            bool _595 = (_528 > _572);
            bool _596 = (_567 > _520);
            float _598 = select((_596 && _595), _590, (dot(float2(saturate(_535 + 0.5f), saturate(0.5f - _535)), float2(saturate(_534 - _541), saturate((_520 * _473) - _541))) * (1.0f - saturate((1.0f - _520) * 8.0f))));
            float _600 = select((_596 || _595), _590, _598);
            float _608 = ((_598 * _548.x) + _496) + (_591.x * _600);
            float _610 = ((_598 * _548.y) + _497) + (_591.y * _600);
            float _612 = ((_598 * _548.z) + _498) + (_591.z * _600);
            float _614 = (_598 + _499) + _600;
            int _615 = _500 + 1;
            if (!(_615 == _465)) {
              _496 = _608;
              _497 = _610;
              _498 = _612;
              _499 = _614;
              _500 = _615;
              continue;
            }
            _619 = _608;
            _620 = _610;
            _621 = _612;
            _622 = _614;
            break;
          }
        } else {
          _619 = 0.0f;
          _620 = 0.0f;
          _621 = 0.0f;
          _622 = 0.0f;
        }
        float _624 = float(_465 << 1);
        _630 = (_619 / _624);
        _631 = (_620 / _624);
        _632 = (_621 / _624);
        _633 = (_622 / _624);
      } else {
        _630 = 0.0f;
        _631 = 0.0f;
        _632 = 0.0f;
        _633 = 0.0f;
      }
      float _634 = 1.0f - _633;
      float4 _641 = t20_space1.SampleLevel(s1_space1, float2(_79, _80), 0.0f);
      float _646 = 1.0f - _641.w;
      _890 = ((_646 * ((_634 * _243) + _630)) + _641.x);
      _891 = ((_646 * ((_634 * _244) + _631)) + _641.y);
      _892 = ((_646 * ((_634 * _245) + _632)) + _641.z);
    } else {
      if (_248 == 3) {
        float4 _661 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _79), (cb12_space1_088y * _80)), 0.0f);
        [branch]
        if ((bool)(_661.z >= 1.0f) && (bool)(_661.w < 2.0f)) {
          float2 _670 = t22_space1.SampleLevel(s0_space1, float2(_79, _80), 0.0f);
          float4 _680 = t19_space1.Load(int3(int(cb5_015x * _79), int(cb5_015y * _80), 0));
          float _684 = cb12_space1_016x * _670.x;
          float _685 = cb12_space1_016x * _670.y;
          float _694 = min(_661.z, 2.0f);
          int _699 = int(min(2.0f, (_694 + 1.0f)));
          float _703 = cb12_space1_072x * (_694 * (_661.x / _661.z));
          float _704 = cb12_space1_072y * (_694 * (_661.y / _661.z));
          float _706 = float(_699) + -0.5f;
          float _707 = _706 / _694;
          float _724 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_694 + -2.0f) * 0.5f);
          if ((int)_699 > (int)0) {
            _730 = 0.0f;
            _731 = 0.0f;
            _732 = 0.0f;
            _733 = 0.0f;
            _734 = 0;
            while (true) {
              float _735 = float(_734);
              float _736 = (_724 + 0.5f) + _735;
              float _737 = _736 / _706;
              float _740 = (_703 * _737) + _79;
              float _741 = (_704 * _737) + _80;
              float2 _742 = t22_space1.SampleLevel(s0_space1, float2(_740, _741), 0.0f);
              float _747 = cb12_space1_016x * _742.x;
              float _748 = cb12_space1_016x * _742.y;
              float _754 = min(sqrt((_747 * _747) + (_748 * _748)), cb12_space1_016z);
              float4 _762 = t19_space1.Load(int3(int(cb5_015x * _740), int(cb5_015y * _741), 0));
              float _769 = _707 * min(sqrt((_684 * _684) + (_685 * _685)), cb12_space1_016z);
              float _770 = _762.w - _680.w;
              float _776 = max((_736 + -1.0f), 0.0f);
              float4 _783 = t19_space1.SampleLevel(s1_space1, float2(_740, _741), 0.0f);
              float _787 = _735 + (0.5f - _724);
              float _788 = _787 / _706;
              float _791 = _79 - (_703 * _788);
              float _792 = _80 - (_704 * _788);
              float2 _793 = t22_space1.SampleLevel(s0_space1, float2(_791, _792), 0.0f);
              float _796 = cb12_space1_016x * _793.x;
              float _797 = cb12_space1_016x * _793.y;
              float _802 = min(sqrt((_796 * _796) + (_797 * _797)), cb12_space1_016z);
              float4 _807 = t19_space1.Load(int3(int(cb5_015x * _791), int(cb5_015y * _792), 0));
              float _814 = _807.w - _680.w;
              float _820 = max((_787 + -1.0f), 0.0f);
              float _826 = dot(float2(saturate(_814 + 0.5f), saturate(0.5f - _814)), float2(saturate(_769 - _820), saturate((_802 * _707) - _820))) * (1.0f - saturate((1.0f - _802) * 8.0f));
              float4 _827 = t19_space1.SampleLevel(s1_space1, float2(_791, _792), 0.0f);
              bool _831 = (_762.w > _807.w);
              bool _832 = (_802 > _754);
              float _834 = select((_832 && _831), _826, (dot(float2(saturate(_770 + 0.5f), saturate(0.5f - _770)), float2(saturate(_769 - _776), saturate((_754 * _707) - _776))) * (1.0f - saturate((1.0f - _754) * 8.0f))));
              float _836 = select((_832 || _831), _826, _834);
              float _844 = ((_834 * _783.x) + _730) + (_827.x * _836);
              float _846 = ((_834 * _783.y) + _731) + (_827.y * _836);
              float _848 = ((_834 * _783.z) + _732) + (_827.z * _836);
              float _850 = (_834 + _733) + _836;
              int _851 = _734 + 1;
              if (!(_851 == _699)) {
                _730 = _844;
                _731 = _846;
                _732 = _848;
                _733 = _850;
                _734 = _851;
                continue;
              }
              _855 = _844;
              _856 = _846;
              _857 = _848;
              _858 = _850;
              break;
            }
          } else {
            _855 = 0.0f;
            _856 = 0.0f;
            _857 = 0.0f;
            _858 = 0.0f;
          }
          float _860 = float(_699 << 1);
          _866 = (_855 / _860);
          _867 = (_856 / _860);
          _868 = (_857 / _860);
          _869 = (_858 / _860);
        } else {
          _866 = 0.0f;
          _867 = 0.0f;
          _868 = 0.0f;
          _869 = 0.0f;
        }
        float _870 = 1.0f - _869;
        float4 _877 = t20_space1.SampleLevel(s1_space1, float2(_79, _80), 0.0f);
        float _882 = 1.0f - _877.w;
        _890 = ((_882 * ((_870 * _243) + _866)) + _877.x);
        _891 = ((_882 * ((_870 * _244) + _867)) + _877.y);
        _892 = ((_882 * ((_870 * _245) + _868)) + _877.z);
      } else {
        _890 = _243;
        _891 = _244;
        _892 = _245;
      }
    }
  }
  float4 _893 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _905 = (cb12_space1_064x * (_893.x - _890)) + _890;
  float _906 = (cb12_space1_064x * (_893.y - _891)) + _891;
  float _907 = (cb12_space1_064x * (_893.z - _892)) + _892;
  bool _910 = (cb12_space1_007y < 0.0f);
  float _911 = select(_910, 1.0f, TEXCOORD.w);
  float4 _912 = t25_space1.Sample(s2_space1, float2(_79, _80));

  _912 *= CUSTOM_BLOOM;

  float _916 = _912.x * _911;
  float _917 = _912.y * _911;
  float _918 = _912.z * _911;
  if (cb12_space1_075z > 0.0f) {
    float4 _923 = t31_space1.Sample(s2_space1, float2(_79, _80));

    _923 = max(0.f, _923);  // Fix NaN

    float _925 = _923.x * _923.x;
    float _926 = _925 * _925;
    float _927 = _926 * _926 * CUSTOM_SUN_BLOOM;

    _939 = ((_927 * cb12_space1_046x) + _905);
    _940 = ((_927 * cb12_space1_046y) + _906);
    _941 = ((_927 * cb12_space1_046z) + _907);
  } else {
    _939 = _905;
    _940 = _906;
    _941 = _907;
  }
  float4 _942 = t29_space1.Sample(s3_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _964 = ((((cb12_space1_034z + -1.0f) + ((cb12_space1_034w - cb12_space1_034z) * saturate((TEXCOORD.z - cb12_space1_034x) * cb12_space1_034y))) * cb12_space1_035x) + 1.0f) * cb12_space1_036w;

  _964 *= CUSTOM_LENS_FLARE;

  float _968 = (_964 * _942.x) + _939;
  float _969 = (_964 * _942.y) + _940;
  float _970 = (_964 * _942.z) + _941;

  float _979 = abs(cb12_space1_007y);
  float _1001 = TEXCOORD.x + -0.5f;
  float _1002 = TEXCOORD.y + -0.5f;
  float _1011 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1001, _1002), float2(_1001, _1002))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);

  _1011 = lerp(1.f, _1011, CUSTOM_VIGNETTE);

  float _1036 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _1055 = ((cb12_space1_012x - cb12_space1_010x) * _1036) + cb12_space1_010x;
  float _1056 = ((cb12_space1_012y - cb12_space1_010y) * _1036) + cb12_space1_010y;
  float _1058 = ((cb12_space1_012w - cb12_space1_010w) * _1036) + cb12_space1_010w;
  float _1073 = ((cb12_space1_013x - cb12_space1_011x) * _1036) + cb12_space1_011x;
  float _1074 = ((cb12_space1_013y - cb12_space1_011y) * _1036) + cb12_space1_011y;
  float _1075 = ((cb12_space1_013z - cb12_space1_011z) * _1036) + cb12_space1_011z;
  float _1076 = _1075 * _1055;
  float _1077 = (lerp(cb12_space1_010z, cb12_space1_012z, _1036)) * _1056;
  float _1080 = _1073 * _1058;
  float _1084 = _1074 * _1058;
  float _1087 = _1073 / _1074;
  float _1089 = 1.0f / (((((_1076 + _1077) * _1075) + _1080) / (((_1076 + _1056) * _1075) + _1084)) - _1087);

  float mid_gray = 0.18f;
  {
    float _1093 = 0.18f;
    float _1094 = 0.18f;
    float _1095 = 0.18f;
    float _1096 = _1093 * _1055;
    float _1097 = _1094 * _1055;
    float _1098 = _1095 * _1055;
    // Replace saturate with max
    float _1126 = max(0.f, (((((_1096 + _1077) * _1093) + _1080) / (((_1096 + _1056) * _1093) + _1084)) - _1087) * _1089);
    float _1127 = max(0.f, (((((_1097 + _1077) * _1094) + _1080) / (((_1097 + _1056) * _1094) + _1084)) - _1087) * _1089);
    float _1128 = max(0.f, (((((_1098 + _1077) * _1095) + _1080) / (((_1098 + _1056) * _1095) + _1084)) - _1087) * _1089);

    mid_gray = renodx::color::y::from::BT709(float3(_1126, _1127, _1128));
  }

  float _1093 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _1011)) * (_968 + select(_910, (((cb5_014w * _916) - _968) * _979), ((_916 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1094 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _1011)) * (_969 + select(_910, (((cb5_014w * _917) - _969) * _979), ((_917 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1095 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _1011)) * (_970 + select(_910, (((cb5_014w * _918) - _970) * _979), ((_918 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));

  float3 untonemapped = float3(_1093, _1094, _1095) * mid_gray / 0.18f;

  float _1096 = _1093 * _1055;
  float _1097 = _1094 * _1055;
  float _1098 = _1095 * _1055;

  // Replace saturate with max
  float _1126 = max(0.f, (((((_1096 + _1077) * _1093) + _1080) / (((_1096 + _1056) * _1093) + _1084)) - _1087) * _1089);
  float _1127 = max(0.f, (((((_1097 + _1077) * _1094) + _1080) / (((_1097 + _1056) * _1094) + _1084)) - _1087) * _1089);
  float _1128 = max(0.f, (((((_1098 + _1077) * _1095) + _1080) / (((_1098 + _1056) * _1095) + _1084)) - _1087) * _1089);

  ApplyPerChannelCorrection(untonemapped, _1126, _1127, _1128);

  float _1129 = dot(float3(_1126, _1127, _1128), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _1138 = (cb12_space1_067x * (_1126 - _1129)) + _1129;
  float _1139 = (cb12_space1_067x * (_1127 - _1129)) + _1129;
  float _1140 = (cb12_space1_067x * (_1128 - _1129)) + _1129;
  float _1144 = saturate(_1129 / cb12_space1_066w);
  float _1161 = (lerp(cb12_space1_066x, cb12_space1_065x, _1144)) * _1138;
  float _1162 = (lerp(cb12_space1_066y, cb12_space1_065y, _1144)) * _1139;
  float _1163 = (lerp(cb12_space1_066z, cb12_space1_065z, _1144)) * _1140;
  float _1169 = saturate(((_1129 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        float3(_1161, _1162, _1163),
        float3(_1138, _1139, _1140),
        _1169,
        TEXCOORD.xy);
  }

  float _1214 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _1230 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _1234 = (_1230.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_1234, _1214);

  float _1241 = saturate(max(0.0f, (_1234 + (_1214 * exp2(log2(abs(saturate(lerp(_1161, _1138, _1169)))) * cb12_space1_067y)))));
  float _1242 = saturate(max(0.0f, (_1234 + (_1214 * exp2(log2(abs(saturate(lerp(_1162, _1139, _1169)))) * cb12_space1_067y)))));
  float _1243 = saturate(max(0.0f, (_1234 + (_1214 * exp2(log2(abs(saturate(lerp(_1163, _1140, _1169)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _1253 = (asint(cb12_space1_092w) != 0);
    float _1255 = max(_1241, max(_1242, _1243));
    float _1309 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _1312 = (_1309.x * 2.0f) + -1.0f;
    float _1318 = float(((int)(uint)((bool)(_1312 > 0.0f))) - ((int)(uint)((bool)(_1312 < 0.0f))));
    float _1322 = 1.0f - sqrt(1.0f - abs(_1312));
    _1333 = (((_1322 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_1253, _1241, _1255) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _1318) + _1241);
    _1334 = (((_1322 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_1253, _1242, _1255) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _1318) + _1242);
    _1335 = (((_1322 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_1253, _1243, _1255) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _1318) + _1243);

    ConfigureVanillaDithering(
        _1241, _1242, _1243,
        _1333, _1334, _1335);

  } else {
    _1333 = _1241;
    _1334 = _1242;
    _1335 = _1243;
  }
  SV_Target.x = _1333;
  SV_Target.y = _1334;
  SV_Target.z = _1335;
  SV_Target.w = dot(float3(_1241, _1242, _1243), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}

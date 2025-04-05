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
  float cb12_space1_023w : packoffset(c023.w);
  float cb12_space1_024x : packoffset(c024.x);
  float cb12_space1_024y : packoffset(c024.y);
  float cb12_space1_024z : packoffset(c024.z);
  float cb12_space1_024w : packoffset(c024.w);
  float cb12_space1_025x : packoffset(c025.x);
  float cb12_space1_025y : packoffset(c025.y);
  float cb12_space1_025z : packoffset(c025.z);
  float cb12_space1_025w : packoffset(c025.w);
  float cb12_space1_026x : packoffset(c026.x);
  float cb12_space1_026y : packoffset(c026.y);
  float cb12_space1_027x : packoffset(c027.x);
  float cb12_space1_027y : packoffset(c027.y);
  float cb12_space1_027z : packoffset(c027.z);
  float cb12_space1_028x : packoffset(c028.x);
  float cb12_space1_028y : packoffset(c028.y);
  float cb12_space1_028z : packoffset(c028.z);
  float cb12_space1_029x : packoffset(c029.x);
  float cb12_space1_029y : packoffset(c029.y);
  float cb12_space1_029z : packoffset(c029.z);
  float cb12_space1_046x : packoffset(c046.x);
  float cb12_space1_046y : packoffset(c046.y);
  float cb12_space1_046z : packoffset(c046.z);
  float cb12_space1_056x : packoffset(c056.x);
  float cb12_space1_065x : packoffset(c065.x);
  float cb12_space1_065y : packoffset(c065.y);
  float cb12_space1_065z : packoffset(c065.z);
  float cb12_space1_065w : packoffset(c065.w);
  float cb12_space1_066x : packoffset(c066.x);
  float cb12_space1_066y : packoffset(c066.y);
  float cb12_space1_066z : packoffset(c066.z);
  float cb12_space1_066w : packoffset(c066.w);
  float cb12_space1_067x : packoffset(c067.x);
  float cb12_space1_072x : packoffset(c072.x);
  float cb12_space1_072y : packoffset(c072.y);
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

SamplerState s0_space2[] : register(s0, space2);

SamplerState s6_space1 : register(s6, space1);

SamplerState s8_space1 : register(s8, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _30 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _37 = cb12_space1_000z / ((1.0f - _30.x) + cb12_space1_000w);
  float4 _42 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(TEXCOORD.x, TEXCOORD.y));
  float _48 = cb5_014w * _42.x;
  float _49 = cb5_014w * _42.y;
  float _50 = cb5_014w * _42.z;
  float _198;
  float _199;
  float _200;
  float _310;
  float _311;
  float _312;
  float _313;
  int _314;
  float _362;
  float _363;
  float _364;
  float _365;
  float _451;
  float _452;
  float _453;
  float _454;
  int _455;
  float _574;
  float _575;
  float _576;
  float _577;
  float _585;
  float _586;
  float _587;
  float _588;
  float _685;
  float _686;
  float _687;
  float _688;
  int _689;
  float _810;
  float _811;
  float _812;
  float _813;
  float _821;
  float _822;
  float _823;
  float _824;
  float _845;
  float _846;
  float _847;
  float _876;
  float _877;
  float _878;
  float _1254;
  float _1255;
  float _1256;
  if (!(cb12_space1_085x > 0.0f)) {
    float _58 = cb12_space1_072y * 0.5f;
    float _59 = TEXCOORD.x - cb12_space1_072x;
    float _60 = TEXCOORD.y - _58;
    float4 _61 = t14_space1.Sample(s2_space1, float2(_59, _60));
    float _65 = cb12_space1_072x * 0.5f;
    float _66 = _65 + TEXCOORD.x;
    float _67 = TEXCOORD.y - cb12_space1_072y;
    float4 _68 = t14_space1.Sample(s2_space1, float2(_66, _67));
    float _72 = TEXCOORD.x - _65;
    float _73 = cb12_space1_072y + TEXCOORD.y;
    float4 _74 = t14_space1.Sample(s2_space1, float2(_72, _73));
    float _78 = cb12_space1_072x + TEXCOORD.x;
    float _79 = _58 + TEXCOORD.y;
    float4 _80 = t14_space1.Sample(s2_space1, float2(_78, _79));
    float4 _84 = t14_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float4 _88 = t19_space1.Sample(s1_space1, float2(_59, _60));
    float4 _92 = t19_space1.Sample(s1_space1, float2(_66, _67));
    float4 _96 = t19_space1.Sample(s1_space1, float2(_72, _73));
    float4 _100 = t19_space1.Sample(s1_space1, float2(_78, _79));
    float4 _104 = t19_space1.Sample(s1_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float _109 = (_104.x + _84.x) * 0.5f;
    float _111 = (_104.y + _84.y) * 0.5f;
    float _113 = (_104.z + _84.z) * 0.5f;
    bool _143 = !(cb12_space1_004x == 0.0f);
    float _162 = max(saturate(1.0f - ((_37 - cb12_space1_003x) * cb12_space1_003y)), saturate((_37 - cb12_space1_003z) * cb12_space1_003w));
    float _163 = _162 * 2.0040080547332764f;
    float _168 = saturate(1.0f - _163);
    float _171 = 1.0f - _168;
    float _172 = min(saturate(2.0020039081573486f - _163), _171);
    float _173 = _171 - _172;
    float _174 = min(saturate(999.9999389648438f - (_162 * 999.9999389648438f)), _173);
    float _175 = _173 - _174;
    _198 = ((((_172 * _104.x) + (_168 * _48)) + (_174 * select(_143, _104.x, _109))) + (_175 * select(_143, _104.x, (((((((((_68.x + _61.x) + _74.x) + _80.x) + _88.x) + _92.x) + _96.x) + _100.x) + _109) * 0.1111111119389534f))));
    _199 = ((((_172 * _104.y) + (_168 * _49)) + (_174 * select(_143, _104.y, _111))) + (_175 * select(_143, _104.y, (((((((((_68.y + _61.y) + _74.y) + _80.y) + _88.y) + _92.y) + _96.y) + _100.y) + _111) * 0.1111111119389534f))));
    _200 = ((((_172 * _104.z) + (_168 * _50)) + (_174 * select(_143, _104.z, _113))) + (_175 * select(_143, _104.z, (((((((((_68.z + _61.z) + _74.z) + _80.z) + _88.z) + _92.z) + _96.z) + _100.z) + _113) * 0.1111111119389534f))));
  } else {
    _198 = _48;
    _199 = _49;
    _200 = _50;
  }
  int _203 = int(cb12_space1_017z);
  if (_203 == 1) {
    uint2 _215 = t18_space1.Load(int3(int(cb5_015x * TEXCOORD.x), int(cb5_015y * TEXCOORD.y), 0));
    float _222 = select(((float((uint)(int)(_215.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
    float _225 = (TEXCOORD.x * 2.0f) + -1.0f;
    float _226 = 1.0f - (TEXCOORD.y * 2.0f);
    float _249 = (g_rage_matrices_192[3].x) + (dot(float3(_225, _226, 1.0f), float3(cb12_space1_021x, cb12_space1_021y, cb12_space1_021z)) * _37);
    float _250 = (g_rage_matrices_192[3].y) + (dot(float3(_225, _226, 1.0f), float3(cb12_space1_022x, cb12_space1_022y, cb12_space1_022z)) * _37);
    float _251 = (g_rage_matrices_192[3].z) + (dot(float3(_225, _226, 1.0f), float3(cb12_space1_023x, cb12_space1_023y, cb12_space1_023z)) * _37);
    float _269 = dot(float4(_249, _250, _251, 1.0f), float4(cb12_space1_020x, cb12_space1_020y, cb12_space1_020z, cb12_space1_020w));
    float _271 = select((_269 == 0.0f), 9.999999747378752e-06f, _269);
    float _276 = (_225 - (dot(float4(_249, _250, _251, 1.0f), float4(cb12_space1_018x, cb12_space1_018y, cb12_space1_018z, cb12_space1_018w)) / _271)) * 40.0f;
    float _277 = (_226 - (dot(float4(_249, _250, _251, 1.0f), float4(cb12_space1_019x, cb12_space1_019y, cb12_space1_019z, cb12_space1_019w)) / _271)) * -22.5f;
    float _278 = dot(float2(_276, _277), float2(_276, _277));
    bool _279 = (_278 > 1.0f);
    float _280 = rsqrt(_278);
    float _286 = (cb12_space1_016x * 0.012500000186264515f) * select(_279, (_280 * _276), _276);
    float _288 = (cb12_space1_016x * 0.02222222276031971f) * select(_279, (_277 * _280), _277);
    float _289 = _222 * _198;
    float _290 = _222 * _199;
    float _291 = _222 * _200;
    float4 _301 = t28_space1.Sample(s6_space1, float2(((_198 * 8.0f) + (TEXCOORD.x * 58.16400146484375f)), ((_199 * 8.0f) + (TEXCOORD.y * 47.130001068115234f))));
    if ((int)int(cb12_space1_017x) > (int)1) {
      _310 = _289;
      _311 = _290;
      _312 = _291;
      _313 = _222;
      _314 = 1;
      while(true) {
        float _316 = float(_314) + ((_301.x + -0.5f) * 0.5f);
        float _330 = (round((((_286 * cb12_space1_017y) * _316) + TEXCOORD.x) * cb5_015x) + 0.5f) / cb5_015x;
        float _331 = (round((((_288 * cb12_space1_017y) * _316) + TEXCOORD.y) * cb5_015y) + 0.5f) / cb5_015y;
        uint2 _336 = t18_space1.Load(int3(int(cb5_015x * _330), int(cb5_015y * _331), 0));
        float _343 = select(((float((uint)(int)(_336.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
        float4 _344 = t19_space1.SampleLevel(s1_space1, float2(_330, _331), 0.0f);
        float _351 = (_344.x * _343) + _310;
        float _352 = (_344.y * _343) + _311;
        float _353 = (_344.z * _343) + _312;
        float _354 = _343 + _313;
        int _355 = _314 + 1;
        if ((int)_355 < (int)int(cb12_space1_017x)) {
          _310 = _351;
          _311 = _352;
          _312 = _353;
          _313 = _354;
          _314 = _355;
          continue;
        }
        _362 = _351;
        _363 = _352;
        _364 = _353;
        _365 = _354;
        break;
      }
    } else {
      _362 = _289;
      _363 = _290;
      _364 = _291;
      _365 = _222;
    }
    float _366 = max(_365, 0.10000000149011612f);
    float _373 = saturate(dot(float2(_286, _288), float2(_286, _288)) * 1e+05f) * _222;
    _845 = ((_373 * ((_362 / _366) - _198)) + _198);
    _846 = ((_373 * ((_363 / _366) - _199)) + _199);
    _847 = ((_373 * ((_364 / _366) - _200)) + _200);
  } else {
    if (_203 == 2) {
      float4 _391 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * TEXCOORD.x), (cb12_space1_088y * TEXCOORD.y)), 0.0f);
      [branch]
      if ((bool)(_391.z >= 1.0f) && (bool)(_391.w < 2.0f)) {
        float2 _400 = t22_space1.SampleLevel(s0_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
        float _405 = cb12_space1_016x * _400.x;
        float _406 = cb12_space1_016x * _400.y;
        float _415 = min(_391.z, 2.0f);
        int _420 = int(min(2.0f, (_415 + 1.0f)));
        float _424 = cb12_space1_072x * (_415 * (_391.x / _391.z));
        float _425 = cb12_space1_072y * (_415 * (_391.y / _391.z));
        float _427 = float(_420) + -0.5f;
        float _428 = _427 / _415;
        float _445 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_415 + -2.0f) * 0.5f);
        if ((int)_420 > (int)0) {
          _451 = 0.0f;
          _452 = 0.0f;
          _453 = 0.0f;
          _454 = 0.0f;
          _455 = 0;
          while(true) {
            float _456 = float(_455);
            float _457 = (_445 + 0.5f) + _456;
            float _458 = _457 / _427;
            float _461 = (_424 * _458) + TEXCOORD.x;
            float _462 = (_425 * _458) + TEXCOORD.y;
            float2 _463 = t22_space1.SampleLevel(s0_space1, float2(_461, _462), 0.0f);
            float _468 = cb12_space1_016x * _463.x;
            float _469 = cb12_space1_016x * _463.y;
            float _475 = min(sqrt((_468 * _468) + (_469 * _469)), cb12_space1_016z);
            float _476 = t11_space1.SampleLevel(s0_space1, float2(_461, _462), 0.0f);
            float _483 = cb12_space1_000z / ((1.0f - _476.x) + cb12_space1_000w);
            float _489 = _428 * min(sqrt((_405 * _405) + (_406 * _406)), cb12_space1_016z);
            float _490 = _483 - _37;
            float _496 = max((_457 + -1.0f), 0.0f);
            float4 _503 = t19_space1.SampleLevel(s1_space1, float2(_461, _462), 0.0f);
            float _507 = _456 + (0.5f - _445);
            float _508 = _507 / _427;
            float _511 = TEXCOORD.x - (_424 * _508);
            float _512 = TEXCOORD.y - (_425 * _508);
            float2 _513 = t22_space1.SampleLevel(s0_space1, float2(_511, _512), 0.0f);
            float _516 = cb12_space1_016x * _513.x;
            float _517 = cb12_space1_016x * _513.y;
            float _522 = min(sqrt((_516 * _516) + (_517 * _517)), cb12_space1_016z);
            float _523 = t11_space1.SampleLevel(s0_space1, float2(_511, _512), 0.0f);
            float _527 = cb12_space1_000z / ((1.0f - _523.x) + cb12_space1_000w);
            float _533 = _527 - _37;
            float _539 = max((_507 + -1.0f), 0.0f);
            float _545 = dot(float2(saturate(_533 + 0.5f), saturate(0.5f - _533)), float2(saturate(_489 - _539), saturate((_522 * _428) - _539))) * (1.0f - saturate((1.0f - _522) * 8.0f));
            float4 _546 = t19_space1.SampleLevel(s1_space1, float2(_511, _512), 0.0f);
            bool _550 = (_483 > _527);
            bool _551 = (_522 > _475);
            float _553 = select((_551 && _550), _545, (dot(float2(saturate(_490 + 0.5f), saturate(0.5f - _490)), float2(saturate(_489 - _496), saturate((_475 * _428) - _496))) * (1.0f - saturate((1.0f - _475) * 8.0f))));
            float _555 = select((_551 || _550), _545, _553);
            float _563 = ((_553 * _503.x) + _451) + (_546.x * _555);
            float _565 = ((_553 * _503.y) + _452) + (_546.y * _555);
            float _567 = ((_553 * _503.z) + _453) + (_546.z * _555);
            float _569 = (_553 + _454) + _555;
            int _570 = _455 + 1;
            if (!(_570 == _420)) {
              _451 = _563;
              _452 = _565;
              _453 = _567;
              _454 = _569;
              _455 = _570;
              continue;
            }
            _574 = _563;
            _575 = _565;
            _576 = _567;
            _577 = _569;
            break;
          }
        } else {
          _574 = 0.0f;
          _575 = 0.0f;
          _576 = 0.0f;
          _577 = 0.0f;
        }
        float _579 = float(_420 << 1);
        _585 = (_574 / _579);
        _586 = (_575 / _579);
        _587 = (_576 / _579);
        _588 = (_577 / _579);
      } else {
        _585 = 0.0f;
        _586 = 0.0f;
        _587 = 0.0f;
        _588 = 0.0f;
      }
      float _589 = 1.0f - _588;
      float4 _596 = t20_space1.SampleLevel(s1_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
      float _601 = 1.0f - _596.w;
      _845 = ((_601 * ((_589 * _198) + _585)) + _596.x);
      _846 = ((_601 * ((_589 * _199) + _586)) + _596.y);
      _847 = ((_601 * ((_589 * _200) + _587)) + _596.z);
    } else {
      if (_203 == 3) {
        float4 _616 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * TEXCOORD.x), (cb12_space1_088y * TEXCOORD.y)), 0.0f);
        [branch]
        if ((bool)(_616.z >= 1.0f) && (bool)(_616.w < 2.0f)) {
          float2 _625 = t22_space1.SampleLevel(s0_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
          float4 _635 = t19_space1.Load(int3(int(cb5_015x * TEXCOORD.x), int(cb5_015y * TEXCOORD.y), 0));
          float _639 = cb12_space1_016x * _625.x;
          float _640 = cb12_space1_016x * _625.y;
          float _649 = min(_616.z, 2.0f);
          int _654 = int(min(2.0f, (_649 + 1.0f)));
          float _658 = cb12_space1_072x * (_649 * (_616.x / _616.z));
          float _659 = cb12_space1_072y * (_649 * (_616.y / _616.z));
          float _661 = float(_654) + -0.5f;
          float _662 = _661 / _649;
          float _679 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_649 + -2.0f) * 0.5f);
          if ((int)_654 > (int)0) {
            _685 = 0.0f;
            _686 = 0.0f;
            _687 = 0.0f;
            _688 = 0.0f;
            _689 = 0;
            while(true) {
              float _690 = float(_689);
              float _691 = (_679 + 0.5f) + _690;
              float _692 = _691 / _661;
              float _695 = (_658 * _692) + TEXCOORD.x;
              float _696 = (_659 * _692) + TEXCOORD.y;
              float2 _697 = t22_space1.SampleLevel(s0_space1, float2(_695, _696), 0.0f);
              float _702 = cb12_space1_016x * _697.x;
              float _703 = cb12_space1_016x * _697.y;
              float _709 = min(sqrt((_702 * _702) + (_703 * _703)), cb12_space1_016z);
              float4 _717 = t19_space1.Load(int3(int(cb5_015x * _695), int(cb5_015y * _696), 0));
              float _724 = _662 * min(sqrt((_639 * _639) + (_640 * _640)), cb12_space1_016z);
              float _725 = _717.w - _635.w;
              float _731 = max((_691 + -1.0f), 0.0f);
              float4 _738 = t19_space1.SampleLevel(s1_space1, float2(_695, _696), 0.0f);
              float _742 = _690 + (0.5f - _679);
              float _743 = _742 / _661;
              float _746 = TEXCOORD.x - (_658 * _743);
              float _747 = TEXCOORD.y - (_659 * _743);
              float2 _748 = t22_space1.SampleLevel(s0_space1, float2(_746, _747), 0.0f);
              float _751 = cb12_space1_016x * _748.x;
              float _752 = cb12_space1_016x * _748.y;
              float _757 = min(sqrt((_751 * _751) + (_752 * _752)), cb12_space1_016z);
              float4 _762 = t19_space1.Load(int3(int(cb5_015x * _746), int(cb5_015y * _747), 0));
              float _769 = _762.w - _635.w;
              float _775 = max((_742 + -1.0f), 0.0f);
              float _781 = dot(float2(saturate(_769 + 0.5f), saturate(0.5f - _769)), float2(saturate(_724 - _775), saturate((_757 * _662) - _775))) * (1.0f - saturate((1.0f - _757) * 8.0f));
              float4 _782 = t19_space1.SampleLevel(s1_space1, float2(_746, _747), 0.0f);
              bool _786 = (_717.w > _762.w);
              bool _787 = (_757 > _709);
              float _789 = select((_787 && _786), _781, (dot(float2(saturate(_725 + 0.5f), saturate(0.5f - _725)), float2(saturate(_724 - _731), saturate((_709 * _662) - _731))) * (1.0f - saturate((1.0f - _709) * 8.0f))));
              float _791 = select((_787 || _786), _781, _789);
              float _799 = ((_789 * _738.x) + _685) + (_782.x * _791);
              float _801 = ((_789 * _738.y) + _686) + (_782.y * _791);
              float _803 = ((_789 * _738.z) + _687) + (_782.z * _791);
              float _805 = (_789 + _688) + _791;
              int _806 = _689 + 1;
              if (!(_806 == _654)) {
                _685 = _799;
                _686 = _801;
                _687 = _803;
                _688 = _805;
                _689 = _806;
                continue;
              }
              _810 = _799;
              _811 = _801;
              _812 = _803;
              _813 = _805;
              break;
            }
          } else {
            _810 = 0.0f;
            _811 = 0.0f;
            _812 = 0.0f;
            _813 = 0.0f;
          }
          float _815 = float(_654 << 1);
          _821 = (_810 / _815);
          _822 = (_811 / _815);
          _823 = (_812 / _815);
          _824 = (_813 / _815);
        } else {
          _821 = 0.0f;
          _822 = 0.0f;
          _823 = 0.0f;
          _824 = 0.0f;
        }
        float _825 = 1.0f - _824;
        float4 _832 = t20_space1.SampleLevel(s1_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
        float _837 = 1.0f - _832.w;
        _845 = ((_837 * ((_825 * _198) + _821)) + _832.x);
        _846 = ((_837 * ((_825 * _199) + _822)) + _832.y);
        _847 = ((_837 * ((_825 * _200) + _823)) + _832.z);
      } else {
        _845 = _198;
        _846 = _199;
        _847 = _200;
      }
    }
  }
  float4 _852 = t25_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  if (cb12_space1_075z > 0.0f) {
    float4 _860 = t31_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float _862 = _860.x * _860.x;
    float _863 = _862 * _862;
    float _864 = _863 * _863;
    _876 = ((_864 * cb12_space1_046x) + _845);
    _877 = ((_864 * cb12_space1_046y) + _846);
    _878 = ((_864 * cb12_space1_046z) + _847);
  } else {
    _876 = _845;
    _877 = _846;
    _878 = _847;
  }
  float _887 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _906 = ((cb12_space1_012x - cb12_space1_010x) * _887) + cb12_space1_010x;
  float _907 = ((cb12_space1_012y - cb12_space1_010y) * _887) + cb12_space1_010y;
  float _909 = ((cb12_space1_012w - cb12_space1_010w) * _887) + cb12_space1_010w;
  float _924 = ((cb12_space1_013x - cb12_space1_011x) * _887) + cb12_space1_011x;
  float _925 = ((cb12_space1_013y - cb12_space1_011y) * _887) + cb12_space1_011y;
  float _926 = ((cb12_space1_013z - cb12_space1_011z) * _887) + cb12_space1_011z;
  float _927 = _926 * _906;
  float _928 = (lerp(cb12_space1_010z, cb12_space1_012z, _887)) * _907;
  float _931 = _924 * _909;
  float _935 = _925 * _909;
  float _938 = _924 / _925;
  float _940 = 1.0f / (((((_927 + _928) * _926) + _931) / (((_927 + _907) * _926) + _935)) - _938);
  float _944 = max(0.0f, (min(_876, 65504.0f) * TEXCOORD.z));
  float _945 = max(0.0f, (min(_877, 65504.0f) * TEXCOORD.z));
  float _946 = max(0.0f, (min(_878, 65504.0f) * TEXCOORD.z));
  float _947 = _944 * _906;
  float _948 = _945 * _906;
  float _949 = _946 * _906;
  float _977 = saturate((((((_947 + _928) * _944) + _931) / (((_947 + _907) * _944) + _935)) - _938) * _940);
  float _978 = saturate((((((_948 + _928) * _945) + _931) / (((_948 + _907) * _945) + _935)) - _938) * _940);
  float _979 = saturate((((((_949 + _928) * _946) + _931) / (((_949 + _907) * _946) + _935)) - _938) * _940);
  float _980 = dot(float3(_977, _978, _979), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _989 = (cb12_space1_067x * (_977 - _980)) + _980;
  float _990 = (cb12_space1_067x * (_978 - _980)) + _980;
  float _991 = (cb12_space1_067x * (_979 - _980)) + _980;
  float _995 = saturate(_980 / cb12_space1_066w);
  float _1012 = (lerp(cb12_space1_066x, cb12_space1_065x, _995)) * _989;
  float _1013 = (lerp(cb12_space1_066y, cb12_space1_065y, _995)) * _990;
  float _1014 = (lerp(cb12_space1_066z, cb12_space1_065z, _995)) * _991;
  float _1020 = saturate(((_980 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));
  float _1036 = cb12_space1_024z * dot(float3(saturate(lerp(_1012, _989, _1020)), saturate(lerp(_1013, _990, _1020)), saturate(lerp(_1014, _991, _1020))), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _1040 = saturate(_1036 / cb12_space1_023w);
  float _1041 = 1.0f - _1040;
  float _1047 = saturate((_1036 - cb12_space1_024x) / (cb12_space1_024y - cb12_space1_024x));
  float _1048 = _1040 - _1047;
  float _1057 = ((cb12_space1_025y * _1047) + (cb12_space1_025x * _1041)) + (cb12_space1_024w * _1048);
  float4 _1068 = t17_space1.Sample(s8_space1, float2(frac(cb12_space1_015x + (TEXCOORD.x * 2.4000000953674316f)), frac(cb12_space1_015y + (TEXCOORD.y * 1.3499999046325684f))));
  float _1075 = _1068.y + -0.5f;
  float _1082 = select((cb12_space1_007y < 0.0f), 1.0f, TEXCOORD.w) * TEXCOORD.z;
  float _1086 = max(0.0f, (_1082 * _852.x));
  float _1087 = max(0.0f, (_1082 * _852.y));
  float _1088 = max(0.0f, (_1082 * _852.z));
  float _1089 = _1086 * _906;
  float _1090 = _1087 * _906;
  float _1091 = _1088 * _906;
  float _1131 = (((_1057 + _1036) + max(((_1075 * _1047) * cb12_space1_026x), 0.0f)) + (((cb12_space1_025z * _1048) + (cb12_space1_025w * _1041)) * _1075)) + (max(((_1057 - _1047) + (cb12_space1_024z * dot(float3(saturate((((((_1089 + _928) * _1086) + _931) / (((_1089 + _907) * _1086) + _935)) - _938) * _940), saturate((((((_1090 + _928) * _1087) + _931) / (((_1090 + _907) * _1087) + _935)) - _938) * _940), saturate((((((_1091 + _928) * _1088) + _931) / (((_1091 + _907) * _1088) + _935)) - _938) * _940)), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f)))), 0.0f) * cb12_space1_026y);
  float _1162 = saturate((((cb12_space1_029x * _1047) + (cb12_space1_028x * _1041)) + (cb12_space1_027x * _1048)) * _1131);
  float _1163 = saturate((((cb12_space1_029y * _1047) + (cb12_space1_028y * _1041)) + (cb12_space1_027y * _1048)) * _1131);
  float _1164 = saturate((((cb12_space1_029z * _1047) + (cb12_space1_028z * _1041)) + (cb12_space1_027z * _1048)) * _1131);
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _1174 = (asint(cb12_space1_092w) != 0);
    float _1176 = max(_1162, max(_1163, _1164));
    float _1230 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _1233 = (_1230.x * 2.0f) + -1.0f;
    float _1239 = float(((int)(uint)((bool)(_1233 > 0.0f))) - ((int)(uint)((bool)(_1233 < 0.0f))));
    float _1243 = 1.0f - sqrt(1.0f - abs(_1233));
    _1254 = (((_1243 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_1174, _1162, _1176) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _1239) + _1162);
    _1255 = (((_1243 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_1174, _1163, _1176) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _1239) + _1163);
    _1256 = (((_1243 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_1174, _1164, _1176) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _1239) + _1164);
  } else {
    _1254 = _1162;
    _1255 = _1163;
    _1256 = _1164;
  }
  SV_Target.x = _1254;
  SV_Target.y = _1255;
  SV_Target.z = _1256;
  SV_Target.w = dot(float3(_1162, _1163, _1164), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  return SV_Target;
}

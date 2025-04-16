#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);  // Grain

Texture2D<float> t11_space1 : register(t11, space1);  // Depth Buffer

Texture2D<float4> t14_space1 : register(t14, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

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
  float _33 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _40 = cb12_space1_000z / ((1.0f - _33.x) + cb12_space1_000w);
  float _50 = min(max((1.0f - saturate(((cb12_space1_072z / cb12_space1_072w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  float _57 = TEXCOORD.x + -0.5f;
  float _58 = TEXCOORD.y + -0.5f;
  float _59 = (cb12_space1_072x / cb12_space1_072y) * _57;
  float _60 = dot(float2(_59, _58), float2(_59, _58));
  float _66 = CUSTOM_LENS_DISTORTION * ((_50 * _60) * ((sqrt(_60) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
  float _67 = _66 * _57;
  float _68 = _66 * _58;
  float _69 = _67 + 0.5f;
  float _70 = _68 + 0.5f;
  float _74 = _69 * cb5_015x;
  float _75 = _70 * cb5_015y;
  float _78 = floor(_74 + -0.5f);
  float _79 = floor(_75 + -0.5f);
  float _80 = _78 + 0.5f;
  float _81 = _79 + 0.5f;
  float _82 = _74 - _80;
  float _83 = _75 - _81;
  float _84 = _82 * _82;
  float _85 = _83 * _83;
  float _86 = _84 * _82;
  float _87 = _85 * _83;
  float _92 = _84 - ((_86 + _82) * 0.5f);
  float _93 = _85 - ((_87 + _83) * 0.5f);
  float _105 = (_82 * 0.5f) * (_84 - _82);
  float _107 = (_83 * 0.5f) * (_85 - _83);
  float _109 = (1.0f - _105) - _92;
  float _112 = (1.0f - _107) - _93;
  float _124 = (((_109 - (((_86 * 1.5f) - (_84 * 2.5f)) + 1.0f)) / _109) + _80) / cb5_015x;
  float _125 = (((_112 - (((_87 * 1.5f) - (_85 * 2.5f)) + 1.0f)) / _112) + _81) / cb5_015y;
  float _128 = _109 * _93;
  float _129 = _112 * _92;
  float _130 = _109 * _112;
  float _131 = _112 * _105;
  float _132 = _109 * _107;
  float _136 = (((_128 + _129) + _130) + _131) + _132;
  float4 _141 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_124, ((_79 + -0.5f) / cb5_015y)), 0.0f);
  float4 _150 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_78 + -0.5f) / cb5_015x), _125), 0.0f);
  float4 _161 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_124, _125), 0.0f);
  float4 _172 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_78 + 2.5f) / cb5_015x), _125), 0.0f);
  float4 _183 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_124, ((_79 + 2.5f) / cb5_015y)), 0.0f);
  float _192 = max(0.0f, ((((((_150.y * _129) + (_141.y * _128)) + (_161.y * _130)) + (_172.y * _131)) + (_183.y * _132)) / _136));
  float _193 = max(0.0f, ((((((_150.z * _129) + (_141.z * _128)) + (_161.z * _130)) + (_172.z * _131)) + (_183.z * _132)) / _136));
  float _201 = (cb12_space1_072x / cb12_space1_072y) * _67;
  float _202 = dot(float2(_201, _68), float2(_201, _68));
  float _208 = CUSTOM_CHROMATIC_ABERRATION * ((_50 * _202) * ((sqrt(_202) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _217 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_208 * _67) + 0.5f), ((_208 * _68) + 0.5f)));
  float _221 = cb5_014w * _217.x;
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
  float _1392;
  float _1393;
  float _1394;
  if (!(cb12_space1_085x > 0.0f)) {
    float4 _226 = t19_space1.Sample(s1_space1, float2(_69, _70));
    float4 _230 = t14_space1.Sample(s2_space1, float2(_69, _70));
    float4 _234 = t30_space1.Sample(s2_space1, float2(_69, _70));
    float _265 = max(saturate(1.0f - ((_40 - cb12_space1_003x) * cb12_space1_003y)), saturate((_40 - cb12_space1_003z) * cb12_space1_003w));
    float _272 = saturate(1.0f - (_265 * 499.9999694824219f));
    float _275 = 1.0f - _272;
    float _276 = min(saturate(0.5015197396278381f - (_265 * 0.5065855979919434f)), _275);
    float _277 = _275 - _276;
    float _278 = min(saturate(100.0f - (_265 * 100.0f)), _277);
    float _279 = _277 - _278;
    _302 = ((((_276 * _226.x) + (_272 * _221)) + (_278 * ((_230.x * 0.699999988079071f) + (_226.x * 0.30000001192092896f)))) + (((_234.x + _230.x) * 0.5f) * _279));
    _303 = ((((_276 * _226.y) + (_272 * _192)) + (_278 * ((_230.y * 0.699999988079071f) + (_226.y * 0.30000001192092896f)))) + (((_234.y + _230.y) * 0.5f) * _279));
    _304 = ((((_276 * _226.z) + (_272 * _193)) + (_278 * ((_230.z * 0.699999988079071f) + (_226.z * 0.30000001192092896f)))) + (((_234.z + _230.z) * 0.5f) * _279));
  } else {
    _302 = _221;
    _303 = _192;
    _304 = _193;
  }
  int _307 = int(cb12_space1_017z);
  if (_307 == 1) {
    uint2 _319 = t18_space1.Load(int3(int(cb5_015x * _69), int(cb5_015y * _70), 0));
    float _326 = select(((float((uint)(int)(_319.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
    float _329 = (_69 * 2.0f) + -1.0f;
    float _330 = 1.0f - (_70 * 2.0f);
    float _353 = (g_rage_matrices_192[3].x) + (dot(float3(_329, _330, 1.0f), float3(cb12_space1_021x, cb12_space1_021y, cb12_space1_021z)) * _40);
    float _354 = (g_rage_matrices_192[3].y) + (dot(float3(_329, _330, 1.0f), float3(cb12_space1_022x, cb12_space1_022y, cb12_space1_022z)) * _40);
    float _355 = (g_rage_matrices_192[3].z) + (dot(float3(_329, _330, 1.0f), float3(cb12_space1_023x, cb12_space1_023y, cb12_space1_023z)) * _40);
    float _373 = dot(float4(_353, _354, _355, 1.0f), float4(cb12_space1_020x, cb12_space1_020y, cb12_space1_020z, cb12_space1_020w));
    float _375 = select((_373 == 0.0f), 9.999999747378752e-06f, _373);
    float _380 = (_329 - (dot(float4(_353, _354, _355, 1.0f), float4(cb12_space1_018x, cb12_space1_018y, cb12_space1_018z, cb12_space1_018w)) / _375)) * 40.0f;
    float _381 = (_330 - (dot(float4(_353, _354, _355, 1.0f), float4(cb12_space1_019x, cb12_space1_019y, cb12_space1_019z, cb12_space1_019w)) / _375)) * -22.5f;
    float _382 = dot(float2(_380, _381), float2(_380, _381));
    bool _383 = (_382 > 1.0f);
    float _384 = rsqrt(_382);
    float _390 = (cb12_space1_016x * 0.012500000186264515f) * select(_383, (_384 * _380), _380);
    float _392 = (cb12_space1_016x * 0.02222222276031971f) * select(_383, (_381 * _384), _381);
    float _393 = _326 * _302;
    float _394 = _326 * _303;
    float _395 = _326 * _304;
    float4 _405 = t28_space1.Sample(s6_space1, float2(((_302 * 8.0f) + (_69 * 58.16400146484375f)), ((_303 * 8.0f) + (_70 * 47.130001068115234f))));
    if ((int)int(cb12_space1_017x) > (int)1) {
      _414 = _393;
      _415 = _394;
      _416 = _395;
      _417 = _326;
      _418 = 1;
      while (true) {
        float _420 = float(_418) + ((_405.x + -0.5f) * 0.5f);
        float _434 = (round((((_390 * cb12_space1_017y) * _420) + _69) * cb5_015x) + 0.5f) / cb5_015x;
        float _435 = (round((((_392 * cb12_space1_017y) * _420) + _70) * cb5_015y) + 0.5f) / cb5_015y;
        uint2 _440 = t18_space1.Load(int3(int(cb5_015x * _434), int(cb5_015y * _435), 0));
        float _447 = select(((float((uint)(int)(_440.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
        float4 _448 = t19_space1.SampleLevel(s1_space1, float2(_434, _435), 0.0f);
        float _455 = (_448.x * _447) + _414;
        float _456 = (_448.y * _447) + _415;
        float _457 = (_448.z * _447) + _416;
        float _458 = _447 + _417;
        int _459 = _418 + 1;
        if ((int)_459 < (int)int(cb12_space1_017x)) {
          _414 = _455;
          _415 = _456;
          _416 = _457;
          _417 = _458;
          _418 = _459;
          continue;
        }
        _466 = _455;
        _467 = _456;
        _468 = _457;
        _469 = _458;
        break;
      }
    } else {
      _466 = _393;
      _467 = _394;
      _468 = _395;
      _469 = _326;
    }
    float _470 = max(_469, 0.10000000149011612f);
    float _477 = saturate(dot(float2(_390, _392), float2(_390, _392)) * 1e+05f) * _326;
    _949 = ((_477 * ((_466 / _470) - _302)) + _302);
    _950 = ((_477 * ((_467 / _470) - _303)) + _303);
    _951 = ((_477 * ((_468 / _470) - _304)) + _304);
  } else {
    if (_307 == 2) {
      float4 _495 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _69), (cb12_space1_088y * _70)), 0.0f);
      [branch]
      if ((bool)(_495.z >= 1.0f) && (bool)(_495.w < 2.0f)) {
        float2 _504 = t22_space1.SampleLevel(s0_space1, float2(_69, _70), 0.0f);
        float _509 = cb12_space1_016x * _504.x;
        float _510 = cb12_space1_016x * _504.y;
        float _519 = min(_495.z, 2.0f);
        int _524 = int(min(2.0f, (_519 + 1.0f)));
        float _528 = cb12_space1_072x * (_519 * (_495.x / _495.z));
        float _529 = cb12_space1_072y * (_519 * (_495.y / _495.z));
        float _531 = float(_524) + -0.5f;
        float _532 = _531 / _519;
        float _549 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_519 + -2.0f) * 0.5f);
        if ((int)_524 > (int)0) {
          _555 = 0.0f;
          _556 = 0.0f;
          _557 = 0.0f;
          _558 = 0.0f;
          _559 = 0;
          while (true) {
            float _560 = float(_559);
            float _561 = (_549 + 0.5f) + _560;
            float _562 = _561 / _531;
            float _565 = (_528 * _562) + _69;
            float _566 = (_529 * _562) + _70;
            float2 _567 = t22_space1.SampleLevel(s0_space1, float2(_565, _566), 0.0f);
            float _572 = cb12_space1_016x * _567.x;
            float _573 = cb12_space1_016x * _567.y;
            float _579 = min(sqrt((_572 * _572) + (_573 * _573)), cb12_space1_016z);
            float _580 = t11_space1.SampleLevel(s0_space1, float2(_565, _566), 0.0f);
            float _587 = cb12_space1_000z / ((1.0f - _580.x) + cb12_space1_000w);
            float _593 = _532 * min(sqrt((_509 * _509) + (_510 * _510)), cb12_space1_016z);
            float _594 = _587 - _40;
            float _600 = max((_561 + -1.0f), 0.0f);
            float4 _607 = t19_space1.SampleLevel(s1_space1, float2(_565, _566), 0.0f);
            float _611 = _560 + (0.5f - _549);
            float _612 = _611 / _531;
            float _615 = _69 - (_528 * _612);
            float _616 = _70 - (_529 * _612);
            float2 _617 = t22_space1.SampleLevel(s0_space1, float2(_615, _616), 0.0f);
            float _620 = cb12_space1_016x * _617.x;
            float _621 = cb12_space1_016x * _617.y;
            float _626 = min(sqrt((_620 * _620) + (_621 * _621)), cb12_space1_016z);
            float _627 = t11_space1.SampleLevel(s0_space1, float2(_615, _616), 0.0f);
            float _631 = cb12_space1_000z / ((1.0f - _627.x) + cb12_space1_000w);
            float _637 = _631 - _40;
            float _643 = max((_611 + -1.0f), 0.0f);
            float _649 = dot(float2(saturate(_637 + 0.5f), saturate(0.5f - _637)), float2(saturate(_593 - _643), saturate((_626 * _532) - _643))) * (1.0f - saturate((1.0f - _626) * 8.0f));
            float4 _650 = t19_space1.SampleLevel(s1_space1, float2(_615, _616), 0.0f);
            bool _654 = (_587 > _631);
            bool _655 = (_626 > _579);
            float _657 = select((_655 && _654), _649, (dot(float2(saturate(_594 + 0.5f), saturate(0.5f - _594)), float2(saturate(_593 - _600), saturate((_579 * _532) - _600))) * (1.0f - saturate((1.0f - _579) * 8.0f))));
            float _659 = select((_655 || _654), _649, _657);
            float _667 = ((_657 * _607.x) + _555) + (_650.x * _659);
            float _669 = ((_657 * _607.y) + _556) + (_650.y * _659);
            float _671 = ((_657 * _607.z) + _557) + (_650.z * _659);
            float _673 = (_657 + _558) + _659;
            int _674 = _559 + 1;
            if (!(_674 == _524)) {
              _555 = _667;
              _556 = _669;
              _557 = _671;
              _558 = _673;
              _559 = _674;
              continue;
            }
            _678 = _667;
            _679 = _669;
            _680 = _671;
            _681 = _673;
            break;
          }
        } else {
          _678 = 0.0f;
          _679 = 0.0f;
          _680 = 0.0f;
          _681 = 0.0f;
        }
        float _683 = float(_524 << 1);
        _689 = (_678 / _683);
        _690 = (_679 / _683);
        _691 = (_680 / _683);
        _692 = (_681 / _683);
      } else {
        _689 = 0.0f;
        _690 = 0.0f;
        _691 = 0.0f;
        _692 = 0.0f;
      }
      float _693 = 1.0f - _692;
      float4 _700 = t20_space1.SampleLevel(s1_space1, float2(_69, _70), 0.0f);
      float _705 = 1.0f - _700.w;
      _949 = ((_705 * ((_693 * _302) + _689)) + _700.x);
      _950 = ((_705 * ((_693 * _303) + _690)) + _700.y);
      _951 = ((_705 * ((_693 * _304) + _691)) + _700.z);
    } else {
      if (_307 == 3) {
        float4 _720 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _69), (cb12_space1_088y * _70)), 0.0f);
        [branch]
        if ((bool)(_720.z >= 1.0f) && (bool)(_720.w < 2.0f)) {
          float2 _729 = t22_space1.SampleLevel(s0_space1, float2(_69, _70), 0.0f);
          float4 _739 = t19_space1.Load(int3(int(cb5_015x * _69), int(cb5_015y * _70), 0));
          float _743 = cb12_space1_016x * _729.x;
          float _744 = cb12_space1_016x * _729.y;
          float _753 = min(_720.z, 2.0f);
          int _758 = int(min(2.0f, (_753 + 1.0f)));
          float _762 = cb12_space1_072x * (_753 * (_720.x / _720.z));
          float _763 = cb12_space1_072y * (_753 * (_720.y / _720.z));
          float _765 = float(_758) + -0.5f;
          float _766 = _765 / _753;
          float _783 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_753 + -2.0f) * 0.5f);
          if ((int)_758 > (int)0) {
            _789 = 0.0f;
            _790 = 0.0f;
            _791 = 0.0f;
            _792 = 0.0f;
            _793 = 0;
            while (true) {
              float _794 = float(_793);
              float _795 = (_783 + 0.5f) + _794;
              float _796 = _795 / _765;
              float _799 = (_762 * _796) + _69;
              float _800 = (_763 * _796) + _70;
              float2 _801 = t22_space1.SampleLevel(s0_space1, float2(_799, _800), 0.0f);
              float _806 = cb12_space1_016x * _801.x;
              float _807 = cb12_space1_016x * _801.y;
              float _813 = min(sqrt((_806 * _806) + (_807 * _807)), cb12_space1_016z);
              float4 _821 = t19_space1.Load(int3(int(cb5_015x * _799), int(cb5_015y * _800), 0));
              float _828 = _766 * min(sqrt((_743 * _743) + (_744 * _744)), cb12_space1_016z);
              float _829 = _821.w - _739.w;
              float _835 = max((_795 + -1.0f), 0.0f);
              float4 _842 = t19_space1.SampleLevel(s1_space1, float2(_799, _800), 0.0f);
              float _846 = _794 + (0.5f - _783);
              float _847 = _846 / _765;
              float _850 = _69 - (_762 * _847);
              float _851 = _70 - (_763 * _847);
              float2 _852 = t22_space1.SampleLevel(s0_space1, float2(_850, _851), 0.0f);
              float _855 = cb12_space1_016x * _852.x;
              float _856 = cb12_space1_016x * _852.y;
              float _861 = min(sqrt((_855 * _855) + (_856 * _856)), cb12_space1_016z);
              float4 _866 = t19_space1.Load(int3(int(cb5_015x * _850), int(cb5_015y * _851), 0));
              float _873 = _866.w - _739.w;
              float _879 = max((_846 + -1.0f), 0.0f);
              float _885 = dot(float2(saturate(_873 + 0.5f), saturate(0.5f - _873)), float2(saturate(_828 - _879), saturate((_861 * _766) - _879))) * (1.0f - saturate((1.0f - _861) * 8.0f));
              float4 _886 = t19_space1.SampleLevel(s1_space1, float2(_850, _851), 0.0f);
              bool _890 = (_821.w > _866.w);
              bool _891 = (_861 > _813);
              float _893 = select((_891 && _890), _885, (dot(float2(saturate(_829 + 0.5f), saturate(0.5f - _829)), float2(saturate(_828 - _835), saturate((_813 * _766) - _835))) * (1.0f - saturate((1.0f - _813) * 8.0f))));
              float _895 = select((_891 || _890), _885, _893);
              float _903 = ((_893 * _842.x) + _789) + (_886.x * _895);
              float _905 = ((_893 * _842.y) + _790) + (_886.y * _895);
              float _907 = ((_893 * _842.z) + _791) + (_886.z * _895);
              float _909 = (_893 + _792) + _895;
              int _910 = _793 + 1;
              if (!(_910 == _758)) {
                _789 = _903;
                _790 = _905;
                _791 = _907;
                _792 = _909;
                _793 = _910;
                continue;
              }
              _914 = _903;
              _915 = _905;
              _916 = _907;
              _917 = _909;
              break;
            }
          } else {
            _914 = 0.0f;
            _915 = 0.0f;
            _916 = 0.0f;
            _917 = 0.0f;
          }
          float _919 = float(_758 << 1);
          _925 = (_914 / _919);
          _926 = (_915 / _919);
          _927 = (_916 / _919);
          _928 = (_917 / _919);
        } else {
          _925 = 0.0f;
          _926 = 0.0f;
          _927 = 0.0f;
          _928 = 0.0f;
        }
        float _929 = 1.0f - _928;
        float4 _936 = t20_space1.SampleLevel(s1_space1, float2(_69, _70), 0.0f);
        float _941 = 1.0f - _936.w;
        _949 = ((_941 * ((_929 * _302) + _925)) + _936.x);
        _950 = ((_941 * ((_929 * _303) + _926)) + _936.y);
        _951 = ((_941 * ((_929 * _304) + _927)) + _936.z);
      } else {
        _949 = _302;
        _950 = _303;
        _951 = _304;
      }
    }
  }
  float4 _952 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _964 = (cb12_space1_064x * (_952.x - _949)) + _949;
  float _965 = (cb12_space1_064x * (_952.y - _950)) + _950;
  float _966 = (cb12_space1_064x * (_952.z - _951)) + _951;
  bool _969 = (cb12_space1_007y < 0.0f);
  float _970 = select(_969, 1.0f, TEXCOORD.w);
  float4 _971 = t25_space1.Sample(s2_space1, float2(_69, _70));

  _971 *= CUSTOM_BLOOM;

  float _975 = _971.x * _970;
  float _976 = _971.y * _970;
  float _977 = _971.z * _970;
  if (cb12_space1_075z > 0.0f) {
    float4 _982 = t31_space1.Sample(s2_space1, float2(_69, _70));

    _982 = max(0, _982);  // Fix NaN

    float _984 = _982.x * _982.x;
    float _985 = _984 * _984;
    float _986 = _985 * _985 * CUSTOM_SUN_BLOOM;

    _998 = ((_986 * cb12_space1_046x) + _964);
    _999 = ((_986 * cb12_space1_046y) + _965);
    _1000 = ((_986 * cb12_space1_046z) + _966);
  } else {
    _998 = _964;
    _999 = _965;
    _1000 = _966;
  }

  float4 _1001 = t29_space1.Sample(s3_space1, float2(TEXCOORD.x, TEXCOORD.y));

  _1001 *= 1.f;  // Unknown

  float _1023 = ((((cb12_space1_034z + -1.0f) + ((cb12_space1_034w - cb12_space1_034z) * saturate((TEXCOORD.z - cb12_space1_034x) * cb12_space1_034y))) * cb12_space1_035x) + 1.0f) * cb12_space1_036w;
  float _1027 = (_1023 * _1001.x) + _998;
  float _1028 = (_1023 * _1001.y) + _999;
  float _1029 = (_1023 * _1001.z) + _1000;
  float _1038 = abs(cb12_space1_007y);
  float _1060 = TEXCOORD.x + -0.5f;
  float _1061 = TEXCOORD.y + -0.5f;
  float _1070 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1060, _1061), float2(_1060, _1061))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);

  _1070 = lerp(1.f, _1070, CUSTOM_VIGNETTE);

  float _1095 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _1114 = ((cb12_space1_012x - cb12_space1_010x) * _1095) + cb12_space1_010x;
  float _1115 = ((cb12_space1_012y - cb12_space1_010y) * _1095) + cb12_space1_010y;
  float _1117 = ((cb12_space1_012w - cb12_space1_010w) * _1095) + cb12_space1_010w;
  float _1132 = ((cb12_space1_013x - cb12_space1_011x) * _1095) + cb12_space1_011x;
  float _1133 = ((cb12_space1_013y - cb12_space1_011y) * _1095) + cb12_space1_011y;
  float _1134 = ((cb12_space1_013z - cb12_space1_011z) * _1095) + cb12_space1_011z;
  float _1135 = _1134 * _1114;
  float _1136 = (lerp(cb12_space1_010z, cb12_space1_012z, _1095)) * _1115;
  float _1139 = _1132 * _1117;
  float _1143 = _1133 * _1117;
  float _1146 = _1132 / _1133;
  float _1148 = 1.0f / (((((_1135 + _1136) * _1134) + _1139) / (((_1135 + _1115) * _1134) + _1143)) - _1146);

  float mid_gray = 0.18f;
  {
    float _1152 = 0.18f;
    float _1153 = 0.18f;
    float _1154 = 0.18f;
    float _1155 = _1152 * _1114;
    float _1156 = _1153 * _1114;
    float _1157 = _1154 * _1114;
    // Replace saturate with max
    float _1185 = max(0.f, (((((_1155 + _1136) * _1152) + _1139) / (((_1155 + _1115) * _1152) + _1143)) - _1146) * _1148);
    float _1186 = max(0.f, (((((_1156 + _1136) * _1153) + _1139) / (((_1156 + _1115) * _1153) + _1143)) - _1146) * _1148);
    float _1187 = max(0.f, (((((_1157 + _1136) * _1154) + _1139) / (((_1157 + _1115) * _1154) + _1143)) - _1146) * _1148);

    mid_gray = renodx::color::y::from::BT709(float3(_1185, _1186, _1187));
  }

  float _1152 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _1070)) * (_1027 + select(_969, (((cb5_014w * _975) - _1027) * _1038), ((_975 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1153 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _1070)) * (_1028 + select(_969, (((cb5_014w * _976) - _1028) * _1038), ((_976 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1154 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _1070)) * (_1029 + select(_969, (((cb5_014w * _977) - _1029) * _1038), ((_977 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));

  float3 untonemapped = float3(_1152, _1153, _1154) * mid_gray / 0.18f;

  float _1155 = _1152 * _1114;
  float _1156 = _1153 * _1114;
  float _1157 = _1154 * _1114;

  // Replace saturate with max
  float _1185 = max(0.f, (((((_1155 + _1136) * _1152) + _1139) / (((_1155 + _1115) * _1152) + _1143)) - _1146) * _1148);
  float _1186 = max(0.f, (((((_1156 + _1136) * _1153) + _1139) / (((_1156 + _1115) * _1153) + _1143)) - _1146) * _1148);
  float _1187 = max(0.f, (((((_1157 + _1136) * _1154) + _1139) / (((_1157 + _1115) * _1154) + _1143)) - _1146) * _1148);

  ApplyPerChannelCorrection(untonemapped, _1185, _1186, _1187);

  float _1188 = dot(float3(_1185, _1186, _1187), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _1197 = (cb12_space1_067x * (_1185 - _1188)) + _1188;
  float _1198 = (cb12_space1_067x * (_1186 - _1188)) + _1188;
  float _1199 = (cb12_space1_067x * (_1187 - _1188)) + _1188;
  float _1203 = saturate(_1188 / cb12_space1_066w);
  float _1220 = (lerp(cb12_space1_066x, cb12_space1_065x, _1203)) * _1197;
  float _1221 = (lerp(cb12_space1_066y, cb12_space1_065y, _1203)) * _1198;
  float _1222 = (lerp(cb12_space1_066z, cb12_space1_065z, _1203)) * _1199;
  float _1228 = saturate(((_1188 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        float3(_1220, _1221, _1222),
        float3(_1197, _1198, _1199),
        _1228,
        TEXCOORD.xy);
  }

  float _1273 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _1289 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _1293 = (_1289.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_1293, _1273);

  float _1300 = saturate(max(0.0f, (_1293 + (_1273 * exp2(log2(abs(saturate(lerp(_1220, _1197, _1228)))) * cb12_space1_067y)))));
  float _1301 = saturate(max(0.0f, (_1293 + (_1273 * exp2(log2(abs(saturate(lerp(_1221, _1198, _1228)))) * cb12_space1_067y)))));
  float _1302 = saturate(max(0.0f, (_1293 + (_1273 * exp2(log2(abs(saturate(lerp(_1222, _1199, _1228)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _1312 = (asint(cb12_space1_092w) != 0);
    float _1314 = max(_1300, max(_1301, _1302));
    float _1368 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _1371 = (_1368.x * 2.0f) + -1.0f;
    float _1377 = float(((int)(uint)((bool)(_1371 > 0.0f))) - ((int)(uint)((bool)(_1371 < 0.0f))));
    float _1381 = 1.0f - sqrt(1.0f - abs(_1371));
    _1392 = (((_1381 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_1312, _1300, _1314) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _1377) + _1300);
    _1393 = (((_1381 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_1312, _1301, _1314) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _1377) + _1301);
    _1394 = (((_1381 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_1312, _1302, _1314) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _1377) + _1302);

    ConfigureVanillaDithering(
        _1300, _1301, _1302,
        _1392, _1393, _1394);

  } else {
    _1392 = _1300;
    _1393 = _1301;
    _1394 = _1302;
  }
  SV_Target.x = _1392;
  SV_Target.y = _1393;
  SV_Target.z = _1394;
  SV_Target.w = dot(float3(_1300, _1301, _1302), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}

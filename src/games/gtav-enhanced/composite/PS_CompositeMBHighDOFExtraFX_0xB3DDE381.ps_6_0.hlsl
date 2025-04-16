#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);  // Grain

Texture2D<float> t11_space1 : register(t11, space1);  // Depth Buffer

Texture2D<float4> t14_space1 : register(t14, space1);

Texture2D<float4> t15_space1 : register(t15, space1);  // Render

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
  float cb5_014w : packoffset(c014.w);  // 1.f
  float cb5_015x : packoffset(c015.x);  // 2160
  float cb5_015y : packoffset(c015.y);  // 1272
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
  float _369;
  float _370;
  float _371;
  float _481;
  float _482;
  float _483;
  float _484;
  int _485;
  float _533;
  float _534;
  float _535;
  float _536;
  float _622;
  float _623;
  float _624;
  float _625;
  int _626;
  float _745;
  float _746;
  float _747;
  float _748;
  float _756;
  float _757;
  float _758;
  float _759;
  float _856;
  float _857;
  float _858;
  float _859;
  int _860;
  float _981;
  float _982;
  float _983;
  float _984;
  float _992;
  float _993;
  float _994;
  float _995;
  float _1016;
  float _1017;
  float _1018;
  float _1065;
  float _1066;
  float _1067;
  float _1459;
  float _1460;
  float _1461;
  if (!(cb12_space1_085x > 0.0f)) {
    float _229 = cb12_space1_072y * 0.5f;
    float _230 = _69 - cb12_space1_072x;
    float _231 = _70 - _229;
    float4 _232 = t14_space1.Sample(s2_space1, float2(_230, _231));
    float _236 = cb12_space1_072x * 0.5f;
    float _237 = _236 + _69;
    float _238 = _70 - cb12_space1_072y;
    float4 _239 = t14_space1.Sample(s2_space1, float2(_237, _238));
    float _243 = _69 - _236;
    float _244 = cb12_space1_072y + _70;
    float4 _245 = t14_space1.Sample(s2_space1, float2(_243, _244));
    float _249 = cb12_space1_072x + _69;
    float _250 = _229 + _70;
    float4 _251 = t14_space1.Sample(s2_space1, float2(_249, _250));
    float4 _255 = t14_space1.Sample(s2_space1, float2(_69, _70));
    float4 _259 = t19_space1.Sample(s1_space1, float2(_230, _231));
    float4 _263 = t19_space1.Sample(s1_space1, float2(_237, _238));
    float4 _267 = t19_space1.Sample(s1_space1, float2(_243, _244));
    float4 _271 = t19_space1.Sample(s1_space1, float2(_249, _250));
    float4 _275 = t19_space1.Sample(s1_space1, float2(_69, _70));
    float _280 = (_275.x + _255.x) * 0.5f;
    float _282 = (_275.y + _255.y) * 0.5f;
    float _284 = (_275.z + _255.z) * 0.5f;
    bool _314 = !(cb12_space1_004x == 0.0f);
    float _333 = max(saturate(1.0f - ((_40 - cb12_space1_003x) * cb12_space1_003y)), saturate((_40 - cb12_space1_003z) * cb12_space1_003w));
    float _334 = _333 * 2.0040080547332764f;
    float _339 = saturate(1.0f - _334);
    float _342 = 1.0f - _339;
    float _343 = min(saturate(2.0020039081573486f - _334), _342);
    float _344 = _342 - _343;
    float _345 = min(saturate(999.9999389648438f - (_333 * 999.9999389648438f)), _344);
    float _346 = _344 - _345;
    _369 = ((((_343 * _275.x) + (_339 * _221)) + (_345 * select(_314, _275.x, _280))) + (_346 * select(_314, _275.x, (((((((((_239.x + _232.x) + _245.x) + _251.x) + _259.x) + _263.x) + _267.x) + _271.x) + _280) * 0.1111111119389534f))));
    _370 = ((((_343 * _275.y) + (_339 * _192)) + (_345 * select(_314, _275.y, _282))) + (_346 * select(_314, _275.y, (((((((((_239.y + _232.y) + _245.y) + _251.y) + _259.y) + _263.y) + _267.y) + _271.y) + _282) * 0.1111111119389534f))));
    _371 = ((((_343 * _275.z) + (_339 * _193)) + (_345 * select(_314, _275.z, _284))) + (_346 * select(_314, _275.z, (((((((((_239.z + _232.z) + _245.z) + _251.z) + _259.z) + _263.z) + _267.z) + _271.z) + _284) * 0.1111111119389534f))));
  } else {
    _369 = _221;
    _370 = _192;
    _371 = _193;
  }
  int _374 = int(cb12_space1_017z);
  if (_374 == 1) {
    uint2 _386 = t18_space1.Load(int3(int(cb5_015x * _69), int(cb5_015y * _70), 0));
    float _393 = select(((float((uint)(int)(_386.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
    float _396 = (_69 * 2.0f) + -1.0f;
    float _397 = 1.0f - (_70 * 2.0f);
    float _420 = (g_rage_matrices_192[3].x) + (dot(float3(_396, _397, 1.0f), float3(cb12_space1_021x, cb12_space1_021y, cb12_space1_021z)) * _40);
    float _421 = (g_rage_matrices_192[3].y) + (dot(float3(_396, _397, 1.0f), float3(cb12_space1_022x, cb12_space1_022y, cb12_space1_022z)) * _40);
    float _422 = (g_rage_matrices_192[3].z) + (dot(float3(_396, _397, 1.0f), float3(cb12_space1_023x, cb12_space1_023y, cb12_space1_023z)) * _40);
    float _440 = dot(float4(_420, _421, _422, 1.0f), float4(cb12_space1_020x, cb12_space1_020y, cb12_space1_020z, cb12_space1_020w));
    float _442 = select((_440 == 0.0f), 9.999999747378752e-06f, _440);
    float _447 = (_396 - (dot(float4(_420, _421, _422, 1.0f), float4(cb12_space1_018x, cb12_space1_018y, cb12_space1_018z, cb12_space1_018w)) / _442)) * 40.0f;
    float _448 = (_397 - (dot(float4(_420, _421, _422, 1.0f), float4(cb12_space1_019x, cb12_space1_019y, cb12_space1_019z, cb12_space1_019w)) / _442)) * -22.5f;
    float _449 = dot(float2(_447, _448), float2(_447, _448));
    bool _450 = (_449 > 1.0f);
    float _451 = rsqrt(_449);
    float _457 = (cb12_space1_016x * 0.012500000186264515f) * select(_450, (_451 * _447), _447);
    float _459 = (cb12_space1_016x * 0.02222222276031971f) * select(_450, (_448 * _451), _448);
    float _460 = _393 * _369;
    float _461 = _393 * _370;
    float _462 = _393 * _371;
    float4 _472 = t28_space1.Sample(s6_space1, float2(((_369 * 8.0f) + (_69 * 58.16400146484375f)), ((_370 * 8.0f) + (_70 * 47.130001068115234f))));
    if ((int)int(cb12_space1_017x) > (int)1) {
      _481 = _460;
      _482 = _461;
      _483 = _462;
      _484 = _393;
      _485 = 1;
      while (true) {
        float _487 = float(_485) + ((_472.x + -0.5f) * 0.5f);
        float _501 = (round((((_457 * cb12_space1_017y) * _487) + _69) * cb5_015x) + 0.5f) / cb5_015x;
        float _502 = (round((((_459 * cb12_space1_017y) * _487) + _70) * cb5_015y) + 0.5f) / cb5_015y;
        uint2 _507 = t18_space1.Load(int3(int(cb5_015x * _501), int(cb5_015y * _502), 0));
        float _514 = select(((float((uint)(int)(_507.y)) * 0.003921568859368563f) > cb12_space1_056x), 0.0f, 1.0f);
        float4 _515 = t19_space1.SampleLevel(s1_space1, float2(_501, _502), 0.0f);
        float _522 = (_515.x * _514) + _481;
        float _523 = (_515.y * _514) + _482;
        float _524 = (_515.z * _514) + _483;
        float _525 = _514 + _484;
        int _526 = _485 + 1;
        if ((int)_526 < (int)int(cb12_space1_017x)) {
          _481 = _522;
          _482 = _523;
          _483 = _524;
          _484 = _525;
          _485 = _526;
          continue;
        }
        _533 = _522;
        _534 = _523;
        _535 = _524;
        _536 = _525;
        break;
      }
    } else {
      _533 = _460;
      _534 = _461;
      _535 = _462;
      _536 = _393;
    }
    float _537 = max(_536, 0.10000000149011612f);
    float _544 = saturate(dot(float2(_457, _459), float2(_457, _459)) * 1e+05f) * _393;
    _1016 = ((_544 * ((_533 / _537) - _369)) + _369);
    _1017 = ((_544 * ((_534 / _537) - _370)) + _370);
    _1018 = ((_544 * ((_535 / _537) - _371)) + _371);
  } else {
    if (_374 == 2) {
      float4 _562 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _69), (cb12_space1_088y * _70)), 0.0f);
      [branch]
      if ((bool)(_562.z >= 1.0f) && (bool)(_562.w < 2.0f)) {
        float2 _571 = t22_space1.SampleLevel(s0_space1, float2(_69, _70), 0.0f);
        float _576 = cb12_space1_016x * _571.x;
        float _577 = cb12_space1_016x * _571.y;
        float _586 = min(_562.z, 2.0f);
        int _591 = int(min(2.0f, (_586 + 1.0f)));
        float _595 = cb12_space1_072x * (_586 * (_562.x / _562.z));
        float _596 = cb12_space1_072y * (_586 * (_562.y / _562.z));
        float _598 = float(_591) + -0.5f;
        float _599 = _598 / _586;
        float _616 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_586 + -2.0f) * 0.5f);
        if ((int)_591 > (int)0) {
          _622 = 0.0f;
          _623 = 0.0f;
          _624 = 0.0f;
          _625 = 0.0f;
          _626 = 0;
          while (true) {
            float _627 = float(_626);
            float _628 = (_616 + 0.5f) + _627;
            float _629 = _628 / _598;
            float _632 = (_595 * _629) + _69;
            float _633 = (_596 * _629) + _70;
            float2 _634 = t22_space1.SampleLevel(s0_space1, float2(_632, _633), 0.0f);
            float _639 = cb12_space1_016x * _634.x;
            float _640 = cb12_space1_016x * _634.y;
            float _646 = min(sqrt((_639 * _639) + (_640 * _640)), cb12_space1_016z);
            float _647 = t11_space1.SampleLevel(s0_space1, float2(_632, _633), 0.0f);
            float _654 = cb12_space1_000z / ((1.0f - _647.x) + cb12_space1_000w);
            float _660 = _599 * min(sqrt((_576 * _576) + (_577 * _577)), cb12_space1_016z);
            float _661 = _654 - _40;
            float _667 = max((_628 + -1.0f), 0.0f);
            float4 _674 = t19_space1.SampleLevel(s1_space1, float2(_632, _633), 0.0f);
            float _678 = _627 + (0.5f - _616);
            float _679 = _678 / _598;
            float _682 = _69 - (_595 * _679);
            float _683 = _70 - (_596 * _679);
            float2 _684 = t22_space1.SampleLevel(s0_space1, float2(_682, _683), 0.0f);
            float _687 = cb12_space1_016x * _684.x;
            float _688 = cb12_space1_016x * _684.y;
            float _693 = min(sqrt((_687 * _687) + (_688 * _688)), cb12_space1_016z);
            float _694 = t11_space1.SampleLevel(s0_space1, float2(_682, _683), 0.0f);
            float _698 = cb12_space1_000z / ((1.0f - _694.x) + cb12_space1_000w);
            float _704 = _698 - _40;
            float _710 = max((_678 + -1.0f), 0.0f);
            float _716 = dot(float2(saturate(_704 + 0.5f), saturate(0.5f - _704)), float2(saturate(_660 - _710), saturate((_693 * _599) - _710))) * (1.0f - saturate((1.0f - _693) * 8.0f));
            float4 _717 = t19_space1.SampleLevel(s1_space1, float2(_682, _683), 0.0f);
            bool _721 = (_654 > _698);
            bool _722 = (_693 > _646);
            float _724 = select((_722 && _721), _716, (dot(float2(saturate(_661 + 0.5f), saturate(0.5f - _661)), float2(saturate(_660 - _667), saturate((_646 * _599) - _667))) * (1.0f - saturate((1.0f - _646) * 8.0f))));
            float _726 = select((_722 || _721), _716, _724);
            float _734 = ((_724 * _674.x) + _622) + (_717.x * _726);
            float _736 = ((_724 * _674.y) + _623) + (_717.y * _726);
            float _738 = ((_724 * _674.z) + _624) + (_717.z * _726);
            float _740 = (_724 + _625) + _726;
            int _741 = _626 + 1;
            if (!(_741 == _591)) {
              _622 = _734;
              _623 = _736;
              _624 = _738;
              _625 = _740;
              _626 = _741;
              continue;
            }
            _745 = _734;
            _746 = _736;
            _747 = _738;
            _748 = _740;
            break;
          }
        } else {
          _745 = 0.0f;
          _746 = 0.0f;
          _747 = 0.0f;
          _748 = 0.0f;
        }
        float _750 = float(_591 << 1);
        _756 = (_745 / _750);
        _757 = (_746 / _750);
        _758 = (_747 / _750);
        _759 = (_748 / _750);
      } else {
        _756 = 0.0f;
        _757 = 0.0f;
        _758 = 0.0f;
        _759 = 0.0f;
      }
      float _760 = 1.0f - _759;
      float4 _767 = t20_space1.SampleLevel(s1_space1, float2(_69, _70), 0.0f);
      float _772 = 1.0f - _767.w;
      _1016 = ((_772 * ((_760 * _369) + _756)) + _767.x);
      _1017 = ((_772 * ((_760 * _370) + _757)) + _767.y);
      _1018 = ((_772 * ((_760 * _371) + _758)) + _767.z);
    } else {
      if (_374 == 3) {
        float4 _787 = t23_space1.SampleLevel(s0_space1, float2((cb12_space1_088x * _69), (cb12_space1_088y * _70)), 0.0f);
        [branch]
        if ((bool)(_787.z >= 1.0f) && (bool)(_787.w < 2.0f)) {
          float2 _796 = t22_space1.SampleLevel(s0_space1, float2(_69, _70), 0.0f);
          float4 _806 = t19_space1.Load(int3(int(cb5_015x * _69), int(cb5_015y * _70), 0));
          float _810 = cb12_space1_016x * _796.x;
          float _811 = cb12_space1_016x * _796.y;
          float _820 = min(_787.z, 2.0f);
          int _825 = int(min(2.0f, (_820 + 1.0f)));
          float _829 = cb12_space1_072x * (_820 * (_787.x / _787.z));
          float _830 = cb12_space1_072y * (_820 * (_787.y / _787.z));
          float _832 = float(_825) + -0.5f;
          float _833 = _832 / _820;
          float _850 = ((((float((uint)((int)((uint)(uint(SV_Position.y)) & 1))) * 2.0f) + -1.0f) * ((float((uint)((int)((uint)(uint(SV_Position.x)) & 1))) * 2.0f) + -1.0f)) * cb12_space1_016w) * saturate((_820 + -2.0f) * 0.5f);
          if ((int)_825 > (int)0) {
            _856 = 0.0f;
            _857 = 0.0f;
            _858 = 0.0f;
            _859 = 0.0f;
            _860 = 0;
            while (true) {
              float _861 = float(_860);
              float _862 = (_850 + 0.5f) + _861;
              float _863 = _862 / _832;
              float _866 = (_829 * _863) + _69;
              float _867 = (_830 * _863) + _70;
              float2 _868 = t22_space1.SampleLevel(s0_space1, float2(_866, _867), 0.0f);
              float _873 = cb12_space1_016x * _868.x;
              float _874 = cb12_space1_016x * _868.y;
              float _880 = min(sqrt((_873 * _873) + (_874 * _874)), cb12_space1_016z);
              float4 _888 = t19_space1.Load(int3(int(cb5_015x * _866), int(cb5_015y * _867), 0));
              float _895 = _833 * min(sqrt((_810 * _810) + (_811 * _811)), cb12_space1_016z);
              float _896 = _888.w - _806.w;
              float _902 = max((_862 + -1.0f), 0.0f);
              float4 _909 = t19_space1.SampleLevel(s1_space1, float2(_866, _867), 0.0f);
              float _913 = _861 + (0.5f - _850);
              float _914 = _913 / _832;
              float _917 = _69 - (_829 * _914);
              float _918 = _70 - (_830 * _914);
              float2 _919 = t22_space1.SampleLevel(s0_space1, float2(_917, _918), 0.0f);
              float _922 = cb12_space1_016x * _919.x;
              float _923 = cb12_space1_016x * _919.y;
              float _928 = min(sqrt((_922 * _922) + (_923 * _923)), cb12_space1_016z);
              float4 _933 = t19_space1.Load(int3(int(cb5_015x * _917), int(cb5_015y * _918), 0));
              float _940 = _933.w - _806.w;
              float _946 = max((_913 + -1.0f), 0.0f);
              float _952 = dot(float2(saturate(_940 + 0.5f), saturate(0.5f - _940)), float2(saturate(_895 - _946), saturate((_928 * _833) - _946))) * (1.0f - saturate((1.0f - _928) * 8.0f));
              float4 _953 = t19_space1.SampleLevel(s1_space1, float2(_917, _918), 0.0f);
              bool _957 = (_888.w > _933.w);
              bool _958 = (_928 > _880);
              float _960 = select((_958 && _957), _952, (dot(float2(saturate(_896 + 0.5f), saturate(0.5f - _896)), float2(saturate(_895 - _902), saturate((_880 * _833) - _902))) * (1.0f - saturate((1.0f - _880) * 8.0f))));
              float _962 = select((_958 || _957), _952, _960);
              float _970 = ((_960 * _909.x) + _856) + (_953.x * _962);
              float _972 = ((_960 * _909.y) + _857) + (_953.y * _962);
              float _974 = ((_960 * _909.z) + _858) + (_953.z * _962);
              float _976 = (_960 + _859) + _962;
              int _977 = _860 + 1;
              if (!(_977 == _825)) {
                _856 = _970;
                _857 = _972;
                _858 = _974;
                _859 = _976;
                _860 = _977;
                continue;
              }
              _981 = _970;
              _982 = _972;
              _983 = _974;
              _984 = _976;
              break;
            }
          } else {
            _981 = 0.0f;
            _982 = 0.0f;
            _983 = 0.0f;
            _984 = 0.0f;
          }
          float _986 = float(_825 << 1);
          _992 = (_981 / _986);
          _993 = (_982 / _986);
          _994 = (_983 / _986);
          _995 = (_984 / _986);
        } else {
          _992 = 0.0f;
          _993 = 0.0f;
          _994 = 0.0f;
          _995 = 0.0f;
        }
        float _996 = 1.0f - _995;
        float4 _1003 = t20_space1.SampleLevel(s1_space1, float2(_69, _70), 0.0f);
        float _1008 = 1.0f - _1003.w;
        _1016 = ((_1008 * ((_996 * _369) + _992)) + _1003.x);
        _1017 = ((_1008 * ((_996 * _370) + _993)) + _1003.y);
        _1018 = ((_1008 * ((_996 * _371) + _994)) + _1003.z);
      } else {
        _1016 = _369;
        _1017 = _370;
        _1018 = _371;
      }
    }
  }
  float4 _1019 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _1031 = (cb12_space1_064x * (_1019.x - _1016)) + _1016;
  float _1032 = (cb12_space1_064x * (_1019.y - _1017)) + _1017;
  float _1033 = (cb12_space1_064x * (_1019.z - _1018)) + _1018;
  bool _1036 = (cb12_space1_007y < 0.0f);
  float _1037 = select(_1036, 1.0f, TEXCOORD.w);
  float4 _1038 = t25_space1.Sample(s2_space1, float2(_69, _70));

  _1038 *= CUSTOM_BLOOM;

  float _1042 = _1038.x * _1037;
  float _1043 = _1038.y * _1037;
  float _1044 = _1038.z * _1037;
  if (cb12_space1_075z > 0.0f) {
    float4 _1049 = t31_space1.Sample(s2_space1, float2(_69, _70));

    _1049 = max(0, _1049);  // Fix NaN

    float _1051 = _1049.x * _1049.x;
    float _1052 = _1051 * _1051;
    float _1053 = _1052 * _1052 * CUSTOM_SUN_BLOOM;
    _1065 = ((_1053 * cb12_space1_046x) + _1031);
    _1066 = ((_1053 * cb12_space1_046y) + _1032);
    _1067 = ((_1053 * cb12_space1_046z) + _1033);
  } else {
    _1065 = _1031;
    _1066 = _1032;
    _1067 = _1033;
  }
  float4 _1068 = t29_space1.Sample(s3_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _1090 = ((((cb12_space1_034z + -1.0f) + ((cb12_space1_034w - cb12_space1_034z) * saturate((TEXCOORD.z - cb12_space1_034x) * cb12_space1_034y))) * cb12_space1_035x) + 1.0f) * cb12_space1_036w;

  _1090 *= CUSTOM_LENS_FLARE;

  float _1094 = (_1090 * _1068.x) + _1065;
  float _1095 = (_1090 * _1068.y) + _1066;
  float _1096 = (_1090 * _1068.z) + _1067;

  float _1105 = abs(cb12_space1_007y);

  float _1127 = TEXCOORD.x + -0.5f;
  float _1128 = TEXCOORD.y + -0.5f;
  float _1137 = saturate(saturate(exp2(log2(1.0f - dot(float2(_1127, _1128), float2(_1127, _1128))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);

  _1137 = lerp(1.f, _1137, CUSTOM_VIGNETTE);

  float _1162 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _1181 = ((cb12_space1_012x - cb12_space1_010x) * _1162) + cb12_space1_010x;
  float _1182 = ((cb12_space1_012y - cb12_space1_010y) * _1162) + cb12_space1_010y;
  float _1184 = ((cb12_space1_012w - cb12_space1_010w) * _1162) + cb12_space1_010w;
  float _1199 = ((cb12_space1_013x - cb12_space1_011x) * _1162) + cb12_space1_011x;
  float _1200 = ((cb12_space1_013y - cb12_space1_011y) * _1162) + cb12_space1_011y;
  float _1201 = ((cb12_space1_013z - cb12_space1_011z) * _1162) + cb12_space1_011z;
  float _1202 = _1201 * _1181;
  float _1203 = (lerp(cb12_space1_010z, cb12_space1_012z, _1162)) * _1182;
  float _1206 = _1199 * _1184;
  float _1210 = _1200 * _1184;
  float _1213 = _1199 / _1200;
  float _1215 = 1.0f / (((((_1202 + _1203) * _1201) + _1206) / (((_1202 + _1182) * _1201) + _1210)) - _1213);

  float mid_gray = 0.18f;
  {
    float _1219 = 0.18f;
    float _1220 = 0.18f;
    float _1221 = 0.18f;

    float _1222 = _1219 * _1181;
    float _1223 = _1220 * _1181;
    float _1224 = _1221 * _1181;
    // Replace saturate with max
    float _1252 = max(0.f, (((((_1222 + _1203) * _1219) + _1206) / (((_1222 + _1182) * _1219) + _1210)) - _1213) * _1215);
    float _1253 = max(0.f, (((((_1223 + _1203) * _1220) + _1206) / (((_1223 + _1182) * _1220) + _1210)) - _1213) * _1215);
    float _1254 = max(0.f, (((((_1224 + _1203) * _1221) + _1206) / (((_1224 + _1182) * _1221) + _1210)) - _1213) * _1215);

    mid_gray = renodx::color::y::from::BT709(float3(_1252, _1253, _1254));
  }

  float _1219 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _1137)) * (_1094 + select(_1036, (((cb5_014w * _1042) - _1094) * _1105), ((_1042 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1220 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _1137)) * (_1095 + select(_1036, (((cb5_014w * _1043) - _1095) * _1105), ((_1043 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _1221 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _1137)) * (_1096 + select(_1036, (((cb5_014w * _1044) - _1096) * _1105), ((_1044 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));

  float3 untonemapped = float3(_1219, _1220, _1221) * mid_gray / 0.18f;

  float _1222 = _1219 * _1181;
  float _1223 = _1220 * _1181;
  float _1224 = _1221 * _1181;

  // Replace saturate with max
  float _1252 = max(0.f, (((((_1222 + _1203) * _1219) + _1206) / (((_1222 + _1182) * _1219) + _1210)) - _1213) * _1215);
  float _1253 = max(0.f, (((((_1223 + _1203) * _1220) + _1206) / (((_1223 + _1182) * _1220) + _1210)) - _1213) * _1215);
  float _1254 = max(0.f, (((((_1224 + _1203) * _1221) + _1206) / (((_1224 + _1182) * _1221) + _1210)) - _1213) * _1215);

  ApplyPerChannelCorrection(untonemapped, _1252, _1253, _1254);

  float _1255 = dot(float3(_1252, _1253, _1254), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _1264 = (cb12_space1_067x * (_1252 - _1255)) + _1255;
  float _1265 = (cb12_space1_067x * (_1253 - _1255)) + _1255;
  float _1266 = (cb12_space1_067x * (_1254 - _1255)) + _1255;
  float _1270 = saturate(_1255 / cb12_space1_066w);
  float _1287 = (lerp(cb12_space1_066x, cb12_space1_065x, _1270)) * _1264;
  float _1288 = (lerp(cb12_space1_066y, cb12_space1_065y, _1270)) * _1265;
  float _1289 = (lerp(cb12_space1_066z, cb12_space1_065z, _1270)) * _1266;
  float _1295 = saturate(((_1255 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        float3(_1287, _1288, _1289),
        float3(_1264, _1265, _1266),
        _1295,
        TEXCOORD.xy);
  }

  float _1340 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _1356 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _1360 = (_1356.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_1360, _1340);

  float _1367 = saturate(max(0.0f, (_1360 + (_1340 * exp2(log2(abs(saturate(lerp(_1287, _1264, _1295)))) * cb12_space1_067y)))));
  float _1368 = saturate(max(0.0f, (_1360 + (_1340 * exp2(log2(abs(saturate(lerp(_1288, _1265, _1295)))) * cb12_space1_067y)))));
  float _1369 = saturate(max(0.0f, (_1360 + (_1340 * exp2(log2(abs(saturate(lerp(_1289, _1266, _1295)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _1379 = (asint(cb12_space1_092w) != 0);
    float _1381 = max(_1367, max(_1368, _1369));
    float _1435 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _1438 = (_1435.x * 2.0f) + -1.0f;
    float _1444 = float(((int)(uint)((bool)(_1438 > 0.0f))) - ((int)(uint)((bool)(_1438 < 0.0f))));
    float _1448 = 1.0f - sqrt(1.0f - abs(_1438));
    _1459 = (((_1448 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_1379, _1367, _1381) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _1444) + _1367);
    _1460 = (((_1448 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_1379, _1368, _1381) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _1444) + _1368);
    _1461 = (((_1448 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_1379, _1369, _1381) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _1444) + _1369);

    ConfigureVanillaDithering(
        _1367, _1368, _1369,
        _1459, _1460, _1461);

  } else {
    _1459 = _1367;
    _1460 = _1368;
    _1461 = _1369;
  }
  SV_Target.x = _1459;
  SV_Target.y = _1460;
  SV_Target.z = _1461;
  SV_Target.w = dot(float3(_1367, _1368, _1369), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}

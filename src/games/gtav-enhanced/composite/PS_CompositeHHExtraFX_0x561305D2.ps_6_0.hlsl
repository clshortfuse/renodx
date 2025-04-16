#include "./common.hlsli"

Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t16_space1 : register(t16, space1);

Texture2D<float4> t17_space1 : register(t17, space1);

Texture2D<float4> t19_space1 : register(t19, space1);

Texture2D<float4> t25_space1 : register(t25, space1);

Texture2D<float4> t29_space1 : register(t29, space1);

Texture2D<float4> t30_space1 : register(t30, space1);

Texture2D<float4> t31_space1 : register(t31, space1);

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

SamplerState s8_space1 : register(s8, space1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float TEXCOORD_1: TEXCOORD1) : SV_Target {
  float4 SV_Target;
  float _26 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _28 = 1.0f - _26.x;
  float _33 = cb12_space1_000z / (_28 + cb12_space1_000w);
  float4 _51 = t16_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _61 = (((_51.x * float((bool)((bool)((bool)(_33 > cb12_space1_030y) && (bool)(_33 < cb12_space1_030y))))) * cb12_space1_033z) * (cb12_space1_030w - cb12_space1_030z)) + cb12_space1_030z;
  float4 _80 = t29_space1.Sample(s3_space1, float2(((cb12_space1_031x * TEXCOORD.x) + cb12_space1_031z), ((cb12_space1_031y * TEXCOORD.y) + cb12_space1_031w)));
  float4 _83 = t29_space1.Sample(s3_space1, float2(((cb12_space1_032x * TEXCOORD.x) + cb12_space1_032z), ((cb12_space1_032y * TEXCOORD.y) + cb12_space1_032w)));
  float _107 = min(max((1.0f - saturate(((cb12_space1_072z / cb12_space1_072w) * 0.20000000298023224f) + -0.4000000059604645f)), 0.5f), 1.0f);
  float _114 = (((cb12_space1_033x * _61) * ((_80.x + -1.0f) + _83.x)) + TEXCOORD.x) + -0.5f;
  float _115 = (((cb12_space1_033y * _61) * ((_80.y + -1.0f) + _83.y)) + TEXCOORD.y) + -0.5f;
  float _116 = (cb12_space1_072x / cb12_space1_072y) * _114;
  float _117 = dot(float2(_116, _115), float2(_116, _115));
  float _123 = CUSTOM_LENS_DISTORTION * ((_107 * _117) * ((sqrt(_117) * cb12_space1_069y) + cb12_space1_069x)) + 1.0f;
  float _124 = _123 * _114;
  float _125 = _123 * _115;
  float _126 = _124 + 0.5f;
  float _127 = _125 + 0.5f;
  float _131 = _126 * cb5_015x;
  float _132 = _127 * cb5_015y;
  float _135 = floor(_131 + -0.5f);
  float _136 = floor(_132 + -0.5f);
  float _137 = _135 + 0.5f;
  float _138 = _136 + 0.5f;
  float _139 = _131 - _137;
  float _140 = _132 - _138;
  float _141 = _139 * _139;
  float _142 = _140 * _140;
  float _143 = _141 * _139;
  float _144 = _142 * _140;
  float _149 = _141 - ((_143 + _139) * 0.5f);
  float _150 = _142 - ((_144 + _140) * 0.5f);
  float _162 = (_139 * 0.5f) * (_141 - _139);
  float _164 = (_140 * 0.5f) * (_142 - _140);
  float _166 = (1.0f - _162) - _149;
  float _169 = (1.0f - _164) - _150;
  float _181 = (((_166 - (((_143 * 1.5f) - (_141 * 2.5f)) + 1.0f)) / _166) + _137) / cb5_015x;
  float _182 = (((_169 - (((_144 * 1.5f) - (_142 * 2.5f)) + 1.0f)) / _169) + _138) / cb5_015y;
  float _185 = _166 * _150;
  float _186 = _169 * _149;
  float _187 = _166 * _169;
  float _188 = _169 * _162;
  float _189 = _166 * _164;
  float _193 = (((_185 + _186) + _187) + _188) + _189;
  float4 _198 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_181, ((_136 + -0.5f) / cb5_015y)), 0.0f);
  float4 _207 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_135 + -0.5f) / cb5_015x), _182), 0.0f);
  float4 _218 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_181, _182), 0.0f);
  float4 _229 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(((_135 + 2.5f) / cb5_015x), _182), 0.0f);
  float4 _240 = t15_space1.SampleLevel(s0_space2[(g_rage_dynamicsamplerindices_016 + 0u)], float2(_181, ((_136 + 2.5f) / cb5_015y)), 0.0f);
  float _249 = max(0.0f, ((((((_207.y * _186) + (_198.y * _185)) + (_218.y * _187)) + (_229.y * _188)) + (_240.y * _189)) / _193));
  float _250 = max(0.0f, ((((((_207.z * _186) + (_198.z * _185)) + (_218.z * _187)) + (_229.z * _188)) + (_240.z * _189)) / _193));
  float _258 = (cb12_space1_072x / cb12_space1_072y) * _124;
  float _259 = dot(float2(_258, _125), float2(_258, _125));
  float _265 = CUSTOM_CHROMATIC_ABERRATION * ((_107 * _259) * ((sqrt(_259) * cb12_space1_069w) + cb12_space1_069z)) + 1.0f;
  float4 _274 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(((_265 * _124) + 0.5f), ((_265 * _125) + 0.5f)));
  float _278 = cb5_014w * _274.x;
  float4 _280 = t19_space1.Sample(s1_space1, float2(_126, _127));
  float _284 = saturate(max(((saturate(cb12_space1_002y * (_33 - cb12_space1_002x)) * float((bool)((bool)(!(_28 == 0.0f))))) * cb12_space1_002z), _61));
  float _291 = ((_280.x - _278) * _284) + _278;
  float _292 = ((_280.y - _249) * _284) + _249;
  float _293 = ((_280.z - _250) * _284) + _250;
  float4 _294 = t30_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _306 = (cb12_space1_064x * (_294.x - _291)) + _291;
  float _307 = (cb12_space1_064x * (_294.y - _292)) + _292;
  float _308 = (cb12_space1_064x * (_294.z - _293)) + _293;
  bool _311 = (cb12_space1_007y < 0.0f);
  float _312 = select(_311, 1.0f, TEXCOORD.w);
  float4 _313 = t25_space1.Sample(s2_space1, float2(_126, _127));

  _313 *= CUSTOM_BLOOM;

  float _317 = _313.x * _312;
  float _318 = _313.y * _312;
  float _319 = _313.z * _312;
  float _340;
  float _341;
  float _342;
  float _705;
  float _706;
  float _707;
  if (cb12_space1_075z > 0.0f) {
    float4 _324 = t31_space1.Sample(s2_space1, float2(_126, _127));

    _324 = max(0.f, _324);

    float _326 = _324.x * _324.x;
    float _327 = _326 * _326;
    float _328 = _327 * _327 * CUSTOM_SUN_BLOOM;

    _340 = ((_328 * cb12_space1_046x) + _306);
    _341 = ((_328 * cb12_space1_046y) + _307);
    _342 = ((_328 * cb12_space1_046z) + _308);
  } else {
    _340 = _306;
    _341 = _307;
    _342 = _308;
  }

  float _351 = abs(cb12_space1_007y);
  float _373 = TEXCOORD.x + -0.5f;
  float _374 = TEXCOORD.y + -0.5f;
  float _383 = saturate(saturate(exp2(log2(1.0f - dot(float2(_373, _374), float2(_373, _374))) * cb12_space1_057y) + cb12_space1_057x) * cb12_space1_057z);

  _383 = lerp(1.f, _383, CUSTOM_VIGNETTE);

  float _408 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _427 = ((cb12_space1_012x - cb12_space1_010x) * _408) + cb12_space1_010x;
  float _428 = ((cb12_space1_012y - cb12_space1_010y) * _408) + cb12_space1_010y;
  float _430 = ((cb12_space1_012w - cb12_space1_010w) * _408) + cb12_space1_010w;
  float _445 = ((cb12_space1_013x - cb12_space1_011x) * _408) + cb12_space1_011x;
  float _446 = ((cb12_space1_013y - cb12_space1_011y) * _408) + cb12_space1_011y;
  float _447 = ((cb12_space1_013z - cb12_space1_011z) * _408) + cb12_space1_011z;
  float _448 = _447 * _427;
  float _449 = (lerp(cb12_space1_010z, cb12_space1_012z, _408)) * _428;
  float _452 = _445 * _430;
  float _456 = _446 * _430;
  float _459 = _445 / _446;
  float _461 = 1.0f / (((((_448 + _449) * _447) + _452) / (((_448 + _428) * _447) + _456)) - _459);

  float mid_gray = 0.18f;
  {
    float _465 = 0.18f;
    float _466 = 0.18f;
    float _467 = 0.18f;
    float _468 = _465 * _427;
    float _469 = _466 * _427;
    float _470 = _467 * _427;
    // Replace saturate with max
    float _498 = max(0.f, (((((_468 + _449) * _465) + _452) / (((_468 + _428) * _465) + _456)) - _459) * _461);
    float _499 = max(0.f, (((((_469 + _449) * _466) + _452) / (((_469 + _428) * _466) + _456)) - _459) * _461);
    float _500 = max(0.f, (((((_470 + _449) * _467) + _452) / (((_470 + _428) * _467) + _456)) - _459) * _461);

    mid_gray = renodx::color::y::from::BT709(float3(_498, _499, _500));
  }

  float _465 = max(0.0f, (min(((lerp(cb12_space1_058x, 1.0f, _383)) * (_340 + select(_311, (((cb5_014w * _317) - _340) * _351), ((_317 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _466 = max(0.0f, (min(((lerp(cb12_space1_058y, 1.0f, _383)) * (_341 + select(_311, (((cb5_014w * _318) - _341) * _351), ((_318 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));
  float _467 = max(0.0f, (min(((lerp(cb12_space1_058z, 1.0f, _383)) * (_342 + select(_311, (((cb5_014w * _319) - _342) * _351), ((_319 * 0.25f) * cb12_space1_007y)))), 65504.0f) * TEXCOORD.z));

  float3 untonemapped = float3(_465, _466, _467) * mid_gray / 0.18f;

  float _468 = _465 * _427;
  float _469 = _466 * _427;
  float _470 = _467 * _427;

  // Replace saturate with max
  float _498 = max(0.f, (((((_468 + _449) * _465) + _452) / (((_468 + _428) * _465) + _456)) - _459) * _461);
  float _499 = max(0.f, (((((_469 + _449) * _466) + _452) / (((_469 + _428) * _466) + _456)) - _459) * _461);
  float _500 = max(0.f, (((((_470 + _449) * _467) + _452) / (((_470 + _428) * _467) + _456)) - _459) * _461);

  ApplyPerChannelCorrection(untonemapped, _498, _499, _500);

  float _501 = dot(float3(_498, _499, _500), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _510 = (cb12_space1_067x * (_498 - _501)) + _501;
  float _511 = (cb12_space1_067x * (_499 - _501)) + _501;
  float _512 = (cb12_space1_067x * (_500 - _501)) + _501;
  float _516 = saturate(_501 / cb12_space1_066w);
  float _533 = (lerp(cb12_space1_066x, cb12_space1_065x, _516)) * _510;
  float _534 = (lerp(cb12_space1_066y, cb12_space1_065y, _516)) * _511;
  float _535 = (lerp(cb12_space1_066z, cb12_space1_065z, _516)) * _512;
  float _541 = saturate(((_501 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return CustomToneMap(
        untonemapped,
        float3(_533, _534, _535),
        float3(_510, _511, _512),
        _541,
        TEXCOORD.xy);
  }

  float _586 = (1.0f - (((sin((cb12_space1_063w + TEXCOORD.y) * cb12_space1_063y) * 0.5f) + 0.5f) * cb12_space1_063x)) - (((sin(((cb12_space1_063w * 0.5f) + TEXCOORD.y) * cb12_space1_063z) * 0.5f) + 0.5f) * cb12_space1_063x);
  float4 _602 = t17_space1.Sample(s8_space1, float2(frac(((TEXCOORD.x * 1.600000023841858f) * cb12_space1_015w) + cb12_space1_015x), frac(((TEXCOORD.y * 0.8999999761581421f) * cb12_space1_015w) + cb12_space1_015y)));
  float _606 = (_602.w + -0.5f) * cb12_space1_015z;

  ConfigureVanillaGrain(_606, _586);

  float _613 = saturate(max(0.0f, (_606 + (_586 * exp2(log2(abs(saturate(lerp(_533, _510, _541)))) * cb12_space1_067y)))));
  float _614 = saturate(max(0.0f, (_606 + (_586 * exp2(log2(abs(saturate(lerp(_534, _511, _541)))) * cb12_space1_067y)))));
  float _615 = saturate(max(0.0f, (_606 + (_586 * exp2(log2(abs(saturate(lerp(_535, _512, _541)))) * cb12_space1_067y)))));
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _625 = (asint(cb12_space1_092w) != 0);
    float _627 = max(_613, max(_614, _615));
    float _681 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _684 = (_681.x * 2.0f) + -1.0f;
    float _690 = float(((int)(uint)((bool)(_684 > 0.0f))) - ((int)(uint)((bool)(_684 < 0.0f))));
    float _694 = 1.0f - sqrt(1.0f - abs(_684));
    _705 = (((_694 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_625, _613, _627) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _690) + _613);
    _706 = (((_694 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_625, _614, _627) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _690) + _614);
    _707 = (((_694 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_625, _615, _627) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _690) + _615);

    ConfigureVanillaDithering(
        _613, _614, _615,
        _705, _706, _707);

  } else {
    _705 = _613;
    _706 = _614;
    _707 = _615;
  }
  SV_Target.x = _705;
  SV_Target.y = _706;
  SV_Target.z = _707;
  SV_Target.w = dot(float3(_613, _614, _615), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(renodx::color::gamma::Decode(SV_Target.rgb, 1.f / cb12_space1_067y));
  return SV_Target;
}

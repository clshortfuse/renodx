Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

Texture2D<float4> t14_space1 : register(t14, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t17_space1 : register(t17, space1);

Texture2D<float4> t19_space1 : register(t19, space1);

Texture2D<float4> t25_space1 : register(t25, space1);

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

SamplerState s8_space1 : register(s8, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _23 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _30 = cb12_space1_000z / ((1.0f - _23.x) + cb12_space1_000w);
  float4 _35 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(TEXCOORD.x, TEXCOORD.y));
  float _41 = cb5_014w * _35.x;
  float _42 = cb5_014w * _35.y;
  float _43 = cb5_014w * _35.z;
  float _191;
  float _192;
  float _193;
  float _222;
  float _223;
  float _224;
  float _600;
  float _601;
  float _602;
  if (!(cb12_space1_085x > 0.0f)) {
    float _51 = cb12_space1_072y * 0.5f;
    float _52 = TEXCOORD.x - cb12_space1_072x;
    float _53 = TEXCOORD.y - _51;
    float4 _54 = t14_space1.Sample(s2_space1, float2(_52, _53));
    float _58 = cb12_space1_072x * 0.5f;
    float _59 = _58 + TEXCOORD.x;
    float _60 = TEXCOORD.y - cb12_space1_072y;
    float4 _61 = t14_space1.Sample(s2_space1, float2(_59, _60));
    float _65 = TEXCOORD.x - _58;
    float _66 = cb12_space1_072y + TEXCOORD.y;
    float4 _67 = t14_space1.Sample(s2_space1, float2(_65, _66));
    float _71 = cb12_space1_072x + TEXCOORD.x;
    float _72 = _51 + TEXCOORD.y;
    float4 _73 = t14_space1.Sample(s2_space1, float2(_71, _72));
    float4 _77 = t14_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float4 _81 = t19_space1.Sample(s1_space1, float2(_52, _53));
    float4 _85 = t19_space1.Sample(s1_space1, float2(_59, _60));
    float4 _89 = t19_space1.Sample(s1_space1, float2(_65, _66));
    float4 _93 = t19_space1.Sample(s1_space1, float2(_71, _72));
    float4 _97 = t19_space1.Sample(s1_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float _102 = (_97.x + _77.x) * 0.5f;
    float _104 = (_97.y + _77.y) * 0.5f;
    float _106 = (_97.z + _77.z) * 0.5f;
    bool _136 = !(cb12_space1_004x == 0.0f);
    float _155 = max(saturate(1.0f - ((_30 - cb12_space1_003x) * cb12_space1_003y)), saturate((_30 - cb12_space1_003z) * cb12_space1_003w));
    float _156 = _155 * 2.0040080547332764f;
    float _161 = saturate(1.0f - _156);
    float _164 = 1.0f - _161;
    float _165 = min(saturate(2.0020039081573486f - _156), _164);
    float _166 = _164 - _165;
    float _167 = min(saturate(999.9999389648438f - (_155 * 999.9999389648438f)), _166);
    float _168 = _166 - _167;
    _191 = ((((_165 * _97.x) + (_161 * _41)) + (_167 * select(_136, _97.x, _102))) + (_168 * select(_136, _97.x, (((((((((_61.x + _54.x) + _67.x) + _73.x) + _81.x) + _85.x) + _89.x) + _93.x) + _102) * 0.1111111119389534f))));
    _192 = ((((_165 * _97.y) + (_161 * _42)) + (_167 * select(_136, _97.y, _104))) + (_168 * select(_136, _97.y, (((((((((_61.y + _54.y) + _67.y) + _73.y) + _81.y) + _85.y) + _89.y) + _93.y) + _104) * 0.1111111119389534f))));
    _193 = ((((_165 * _97.z) + (_161 * _43)) + (_167 * select(_136, _97.z, _106))) + (_168 * select(_136, _97.z, (((((((((_61.z + _54.z) + _67.z) + _73.z) + _81.z) + _85.z) + _89.z) + _93.z) + _106) * 0.1111111119389534f))));
  } else {
    _191 = _41;
    _192 = _42;
    _193 = _43;
  }
  float4 _198 = t25_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  if (cb12_space1_075z > 0.0f) {
    float4 _206 = t31_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float _208 = _206.x * _206.x;
    float _209 = _208 * _208;
    float _210 = _209 * _209;
    _222 = ((_210 * cb12_space1_046x) + _191);
    _223 = ((_210 * cb12_space1_046y) + _192);
    _224 = ((_210 * cb12_space1_046z) + _193);
  } else {
    _222 = _191;
    _223 = _192;
    _224 = _193;
  }
  float _233 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _252 = ((cb12_space1_012x - cb12_space1_010x) * _233) + cb12_space1_010x;
  float _253 = ((cb12_space1_012y - cb12_space1_010y) * _233) + cb12_space1_010y;
  float _255 = ((cb12_space1_012w - cb12_space1_010w) * _233) + cb12_space1_010w;
  float _270 = ((cb12_space1_013x - cb12_space1_011x) * _233) + cb12_space1_011x;
  float _271 = ((cb12_space1_013y - cb12_space1_011y) * _233) + cb12_space1_011y;
  float _272 = ((cb12_space1_013z - cb12_space1_011z) * _233) + cb12_space1_011z;
  float _273 = _272 * _252;
  float _274 = (lerp(cb12_space1_010z, cb12_space1_012z, _233)) * _253;
  float _277 = _270 * _255;
  float _281 = _271 * _255;
  float _284 = _270 / _271;
  float _286 = 1.0f / (((((_273 + _274) * _272) + _277) / (((_273 + _253) * _272) + _281)) - _284);
  float _290 = max(0.0f, (min(_222, 65504.0f) * TEXCOORD.z));
  float _291 = max(0.0f, (min(_223, 65504.0f) * TEXCOORD.z));
  float _292 = max(0.0f, (min(_224, 65504.0f) * TEXCOORD.z));
  float _293 = _290 * _252;
  float _294 = _291 * _252;
  float _295 = _292 * _252;
  float _323 = saturate((((((_293 + _274) * _290) + _277) / (((_293 + _253) * _290) + _281)) - _284) * _286);
  float _324 = saturate((((((_294 + _274) * _291) + _277) / (((_294 + _253) * _291) + _281)) - _284) * _286);
  float _325 = saturate((((((_295 + _274) * _292) + _277) / (((_295 + _253) * _292) + _281)) - _284) * _286);
  float _326 = dot(float3(_323, _324, _325), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _335 = (cb12_space1_067x * (_323 - _326)) + _326;
  float _336 = (cb12_space1_067x * (_324 - _326)) + _326;
  float _337 = (cb12_space1_067x * (_325 - _326)) + _326;
  float _341 = saturate(_326 / cb12_space1_066w);
  float _358 = (lerp(cb12_space1_066x, cb12_space1_065x, _341)) * _335;
  float _359 = (lerp(cb12_space1_066y, cb12_space1_065y, _341)) * _336;
  float _360 = (lerp(cb12_space1_066z, cb12_space1_065z, _341)) * _337;
  float _366 = saturate(((_326 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));
  float _382 = cb12_space1_024z * dot(float3(saturate(lerp(_358, _335, _366)), saturate(lerp(_359, _336, _366)), saturate(lerp(_360, _337, _366))), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _386 = saturate(_382 / cb12_space1_023w);
  float _387 = 1.0f - _386;
  float _393 = saturate((_382 - cb12_space1_024x) / (cb12_space1_024y - cb12_space1_024x));
  float _394 = _386 - _393;
  float _403 = ((cb12_space1_025y * _393) + (cb12_space1_025x * _387)) + (cb12_space1_024w * _394);
  float4 _414 = t17_space1.Sample(s8_space1, float2(frac(cb12_space1_015x + (TEXCOORD.x * 2.4000000953674316f)), frac(cb12_space1_015y + (TEXCOORD.y * 1.3499999046325684f))));
  float _421 = _414.y + -0.5f;
  float _428 = select((cb12_space1_007y < 0.0f), 1.0f, TEXCOORD.w) * TEXCOORD.z;
  float _432 = max(0.0f, (_428 * _198.x));
  float _433 = max(0.0f, (_428 * _198.y));
  float _434 = max(0.0f, (_428 * _198.z));
  float _435 = _432 * _252;
  float _436 = _433 * _252;
  float _437 = _434 * _252;
  float _477 = (((_403 + _382) + max(((_421 * _393) * cb12_space1_026x), 0.0f)) + (((cb12_space1_025z * _394) + (cb12_space1_025w * _387)) * _421)) + (max(((_403 - _393) + (cb12_space1_024z * dot(float3(saturate((((((_435 + _274) * _432) + _277) / (((_435 + _253) * _432) + _281)) - _284) * _286), saturate((((((_436 + _274) * _433) + _277) / (((_436 + _253) * _433) + _281)) - _284) * _286), saturate((((((_437 + _274) * _434) + _277) / (((_437 + _253) * _434) + _281)) - _284) * _286)), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f)))), 0.0f) * cb12_space1_026y);
  float _508 = saturate((((cb12_space1_029x * _393) + (cb12_space1_028x * _387)) + (cb12_space1_027x * _394)) * _477);
  float _509 = saturate((((cb12_space1_029y * _393) + (cb12_space1_028y * _387)) + (cb12_space1_027y * _394)) * _477);
  float _510 = saturate((((cb12_space1_029z * _393) + (cb12_space1_028z * _387)) + (cb12_space1_027z * _394)) * _477);
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _520 = (asint(cb12_space1_092w) != 0);
    float _522 = max(_508, max(_509, _510));
    float _576 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _579 = (_576.x * 2.0f) + -1.0f;
    float _585 = float(((int)(uint)((bool)(_579 > 0.0f))) - ((int)(uint)((bool)(_579 < 0.0f))));
    float _589 = 1.0f - sqrt(1.0f - abs(_579));
    _600 = (((_589 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_520, _508, _522) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _585) + _508);
    _601 = (((_589 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_520, _509, _522) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _585) + _509);
    _602 = (((_589 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_520, _510, _522) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _585) + _510);
  } else {
    _600 = _508;
    _601 = _509;
    _602 = _510;
  }
  SV_Target.x = _600;
  SV_Target.y = _601;
  SV_Target.z = _602;
  SV_Target.w = dot(float3(_508, _509, _510), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  return SV_Target;
}

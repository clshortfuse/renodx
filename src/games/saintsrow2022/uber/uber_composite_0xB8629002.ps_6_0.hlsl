#include "../tonemap/tonemap.hlsli"

StructuredBuffer<float4> t11_space15 : register(t11, space15);

Texture2D<float4> t16 : register(t16);

Texture2D<float4> t18 : register(t18);

Texture2D<float4> t19 : register(t19);

Texture3D<float4> t20 : register(t20);

Texture2D<float4> t21 : register(t21);

Texture3D<float> t27 : register(t27);

Texture3D<float> t28 : register(t28);

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float cb0_000x : packoffset(c000.x);
  float cb0_000y : packoffset(c000.y);
  float cb0_000z : packoffset(c000.z);
  float cb0_001x : packoffset(c001.x);
  float cb0_001y : packoffset(c001.y);
  float cb0_001z : packoffset(c001.z);
  float cb0_002x : packoffset(c002.x);
  float cb0_002y : packoffset(c002.y);
  float cb0_002z : packoffset(c002.z);
  float cb0_002w : packoffset(c002.w);
  float cb0_003x : packoffset(c003.x);
  float cb0_003y : packoffset(c003.y);
  float cb0_003z : packoffset(c003.z);
  float cb0_003w : packoffset(c003.w);
  float cb0_004x : packoffset(c004.x);
  float cb0_004y : packoffset(c004.y);
  float cb0_004z : packoffset(c004.z);
  float cb0_004w : packoffset(c004.w);
  int cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  int cb0_005w : packoffset(c005.w);
  float cb0_006x : packoffset(c006.x);
  float cb0_006y : packoffset(c006.y);
  float cb0_006z : packoffset(c006.z);
  float cb0_006w : packoffset(c006.w);
  float cb0_007x : packoffset(c007.x);
  float cb0_008x : packoffset(c008.x);
  float cb0_008y : packoffset(c008.y);
  float cb0_008z : packoffset(c008.z);
  float cb0_008w : packoffset(c008.w);
  float cb0_009x : packoffset(c009.x);
  float cb0_009y : packoffset(c009.y);
  float cb0_009z : packoffset(c009.z);
  float cb0_009w : packoffset(c009.w);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_011w : packoffset(c011.w);
  float cb0_012x : packoffset(c012.x);
  int cb0_012z : packoffset(c012.z);
};

cbuffer cb0_space5 : register(b0, space5) {
  float cb0_space5_008x : packoffset(c008.x);
  float cb0_space5_008y : packoffset(c008.y);
  float cb0_space5_008z : packoffset(c008.z);
  float cb0_space5_008w : packoffset(c008.w);
};

cbuffer cb1_space9 : register(b1, space9) {
  float cb1_space9_031x : packoffset(c031.x);
  float cb1_space9_031y : packoffset(c031.y);
  float cb1_space9_031z : packoffset(c031.z);
  float cb1_space9_041y : packoffset(c041.y);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s2_space1 : register(s2, space1);

static const float _global_0[6] = {-4.0f, -4.0f, -3.157376527786255f, -0.48524999618530273f, 1.847732424736023f, 1.847732424736023f};
static const float _global_1[6] = {-0.7185482382774353f, 2.0810306072235107f, 3.668124198913574f, 4.0f, 4.0f, 4.0f};
static const float _global_2[10] = {-1.6989699602127075f, -1.6989699602127075f, -1.4779000282287598f, -1.229099988937378f, -0.864799976348877f, -0.4480000138282776f, 0.005179999861866236f, 0.45110803842544556f, 0.9113744497299194f, 0.9113744497299194f};
static const float _global_3[10] = {0.5154386758804321f, 0.8470437526702881f, 1.1358000040054321f, 1.3802000284194946f, 1.519700050354004f, 1.5985000133514404f, 1.6467000246047974f, 1.6746091842651367f, 1.687873363494873f, 1.687873363494873f};

float4 main(
    noperspective float4 SV_Position : SV_Position,
    linear float2 TEXCOORD : TEXCOORD,
    linear float3 TEXCOORD_1 : TEXCOORD1) : SV_Target {
  float4 SV_Target;
  float _24 = dot(float3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z), float3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z));
  float _25 = rsqrt(_24);
  float4 _26 = t0.SampleLevel(s2_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _33 = cb0_011y * _26.w;
  float _35 = cb0_011x * _26.w;
  float _36 = max(_35, _33);
  float _40 = max(cb0_009x, cb0_009y);
  float _41 = _40 * _36;
  float _44 = min(cb0_011z, cb0_011w);
  float _45 = _44 * 2.0f;
  bool _46 = (_41 > _45);
  bool _49 = (cb0_012z != 0);
  bool _50 = _46 && _49;
  float _127;
  float _128;
  float _273;
  float _274;
  float _275;
  float _333;
  float _334;
  float _335;
  float _428;
  float _429;
  float _430;
  float _513;
  float _546;
  float _558;
  float _597;
  float _688;
  float _747;
  float _806;
  float _868;
  float _930;
  float _992;
  float _1238;
  float _1239;
  float _1240;
  float _1270;
  float _1271;
  float _1272;
  float _1324;
  float _1325;
  float _1326;
  [branch] if (_50) {
    float _52 = _25 * TEXCOORD_1.z;
    float _53 = _25 * TEXCOORD_1.y;
    float _54 = _25 * TEXCOORD_1.x;
    float _60 = cb1_space9_041y + cb1_space9_031y;
    float _64 = cb0_012x * cb1_space9_031x;
    float _65 = cb0_012x * _60;
    float _66 = cb0_012x * cb1_space9_031z;
    float _67 = _64 + _54;
    float _68 = _65 + _53;
    float _69 = _66 + _52;
    float _74 = _67 - cb0_010x;
    float _75 = _68 - cb0_010y;
    float _76 = _69 - cb0_010z;
    float _77 = _74 * cb0_009x;
    float _78 = _75 * cb0_009y;
    float _79 = _76 * cb0_009x;
    float _82 = _74 * cb0_009z;
    float _83 = _75 * cb0_009w;
    float _84 = _76 * cb0_009z;
    float _85 = t27.SampleLevel(s0_space1, float3(_77, _78, _79), 0.0f);
    float _87 = t28.SampleLevel(s0_space1, float3(_82, _83, _84), 0.0f);
    float _89 = _77 + 0.5f;
    float _90 = _78 + 0.5f;
    float _91 = _79 + 0.5f;
    float _92 = t27.SampleLevel(s0_space1, float3(_89, _90, _91), 0.0f);
    float _94 = _82 + 0.5f;
    float _95 = _83 + 0.5f;
    float _96 = _84 + 0.5f;
    float _97 = t28.SampleLevel(s0_space1, float3(_94, _95, _96), 0.0f);
    float _104 = _85.x - cb0_008x;
    float _105 = _104 * cb0_008y;
    float _106 = _87.x - cb0_008z;
    float _107 = _106 * cb0_008w;
    float _108 = _107 + -1.0f;
    float _109 = _108 + _105;
    float _110 = _109 * 6.2831854820251465f;
    float _111 = sin(_110);
    float _112 = _92.x - cb0_008x;
    float _113 = _112 * cb0_008y;
    float _114 = _97.x - cb0_008z;
    float _115 = _114 * cb0_008w;
    float _116 = _115 + -1.0f;
    float _117 = _116 + _113;
    float _118 = _117 * 6.2831854820251465f;
    float _119 = sin(_118);
    float _120 = _111 * _26.w;
    float _121 = _120 * cb0_011x;
    float _122 = _119 * _26.w;
    float _123 = _122 * cb0_011y;
    float _124 = _121 + TEXCOORD.x;
    float _125 = _123 + TEXCOORD.y;
    _127 = _124;
    _128 = _125;
  }
  else {
    _127 = TEXCOORD.x;
    _128 = TEXCOORD.y;
  }
  float _129 = _127 - cb0_011z;
  float _130 = _128 - cb0_011w;
  float4 _131 = t0.SampleLevel(s2_space1, float2(_129, _130), 0.0f);
  float _135 = _131.x - _131.z;
  float _136 = _135 * 0.5f;
  float _137 = _136 + _131.z;
  float _138 = _131.y - _137;
  float _139 = cb0_011w + _128;
  float4 _140 = t0.SampleLevel(s2_space1, float2(_129, _139), 0.0f);
  float _144 = _140.x - _140.z;
  float _145 = _144 * 0.5f;
  float _146 = _145 + _140.z;
  float _147 = _140.y - _146;
  float _148 = cb0_011z + _127;
  float4 _149 = t0.SampleLevel(s2_space1, float2(_148, _130), 0.0f);
  float _153 = _149.x - _149.z;
  float _154 = _153 * 0.5f;
  float _155 = _154 + _149.z;
  float _156 = _149.y - _155;
  float4 _157 = t0.SampleLevel(s2_space1, float2(_148, _139), 0.0f);
  float _161 = _157.x - _157.z;
  float _162 = _161 * 0.5f;
  float _163 = _162 + _157.z;
  float _164 = _157.y - _163;
  float4 _165 = t0.SampleLevel(s2_space1, float2(_127, _128), 0.0f);
  float _170 = _165.x - _165.z;
  float _171 = _170 * 0.5f;
  float _172 = _171 + _165.z;
  float _173 = _165.y - _172;
  float _174 = _173 * 0.5f;
  float _175 = _174 + _172;
  float4 _176 = t11_space15.Load(2);
  float _178 = _176.x * 4.0f;
  float _179 = _175 * 16.0f;
  float _180 = _147 + _138;
  float _181 = _180 + _156;
  float _182 = _181 + _164;
  float _183 = _182 * 0.5f;
  float _184 = _146 + _137;
  float _185 = _184 + _155;
  float _186 = _185 + _163;
  float _187 = _186 + _183;
  float _188 = _187 * 4.0f;
  float _189 = _179 - _188;
  float _190 = _189 * _178;
  bool _191 = (_190 > 0.0f);
  bool _192 = (_190 < 0.0f);
  int _193 = (int)(uint)(_191);
  int _194 = (int)(uint)(_192);
  int _195 = _193 - _194;
  float _196 = float((int)(_195));
  float _197 = abs(_190);
  float _198 = _197 + -0.10000000149011612f;
  float _199 = _198 * 3.846153497695923f;
  float _200 = saturate(_199);
  float _201 = _200 * 2.0f;
  float _202 = 3.0f - _201;
  float _203 = 1.0f - _197;
  float _204 = _203 * 1.5625f;
  float _205 = saturate(_204);
  float _206 = _205 * 2.0f;
  float _207 = 3.0f - _206;
  float _208 = _200 * _205;
  float _209 = _208 * _208;
  float _210 = _207 * _202;
  float _211 = _210 * _209;
  float _212 = _211 * _196;
  float _213 = _212 / _178;
  float _214 = _213 * cb0_000z;
  float _215 = _172 + _214;
  float _216 = _165.y + _214;
  float _217 = _215 - _171;
  float _218 = _217 + _170;
  float _219 = max(_218, 0.0f);
  float _220 = max(_216, 0.0f);
  float _221 = max(_217, 0.0f);
  float _222 = max(_165.w, 0.0f);
  float _223 = max(9.999999747378752e-06f, _222);
  float _224 = max(9.999999747378752e-06f, _26.w);
  float _225 = 1.0f / _224;
  float _226 = _225 * _223;
  float _227 = saturate(_226);
  float _228 = saturate(_227);
  float _229 = _228 * 2.0f;
  float _230 = 3.0f - _229;
  float _231 = _228 * _228;
  float _232 = _231 * _230;
  float _233 = _219 - _26.x;
  float _234 = _220 - _26.y;
  float _235 = _221 - _26.z;
  float _236 = _222 - _26.w;
  float _237 = _232 * _233;
  float _238 = _232 * _234;
  float _239 = _232 * _235;
  float _240 = _232 * _236;
  float _241 = _237 + _26.x;
  float _242 = _238 + _26.y;
  float _243 = _239 + _26.z;
  float _244 = _240 + _26.w;
  bool _246 = (cb0_000x > 0.0f);
  [branch] if (_246) {
    float _248 = 1.0f - _232;
    float4 _249 = t18.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float _254 = cb0_000x * _249.w;
    float _255 = _254 + -0.5f;
    float _256 = _255 * 2.0f;
    float _257 = saturate(_256);
    float _258 = _257 * 2.0f;
    float _259 = 3.0f - _258;
    float _260 = _257 * _257;
    float _261 = _260 * _259;
    float _262 = max(_248, _261);
    float _263 = _249.x - _241;
    float _264 = _249.y - _242;
    float _265 = _249.z - _243;
    float _266 = _262 * _263;
    float _267 = _262 * _264;
    float _268 = _262 * _265;
    float _269 = _266 + _241;
    float _270 = _267 + _242;
    float _271 = _268 + _243;
    _273 = _269;
    _274 = _270;
    _275 = _271;
  }
  else {
    _273 = _241;
    _274 = _242;
    _275 = _243;
  }
  float _276 = max(_273, 0.0f);
  float _277 = max(_274, 0.0f);
  float _278 = max(_275, 0.0f);
  float _279 = max(_244, 0.0f);
  float4 _280 = t16.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _284 = t19.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y)) * CUSTOM_LENS_DIRT;
  bool _290 = (cb0_005w == 0);
  float _292 = cb0_000y * _284.x;
  float _293 = cb0_000y * _284.y;
  float _294 = cb0_000y * _284.z;
  if (_290) {
    float _296 = _292 + 1.0f;
    float _297 = _293 + 1.0f;
    float _298 = _294 + 1.0f;
    float _299 = cb0_005y * 0.3333333432674408f;
    float _300 = _299 * _280.x;
    float _301 = _300 * _296;
    float _302 = _299 * _280.y;
    float _303 = _302 * _297;
    float _304 = _299 * _280.z;
    float _305 = _304 * _298;
    float _306 = _301 + _276;
    float _307 = _303 + _277;
    float _308 = _305 + _278;
    _333 = _306;
    _334 = _307;
    _335 = _308;
  } else {
    float _310 = _280.x * 0.3333333432674408f;
    float _311 = _280.y * 0.3333333432674408f;
    float _312 = _280.z * 0.3333333432674408f;
    float _315 = cb0_006x - cb0_005y;
    float _316 = _292 * _315;
    float _317 = _293 * _315;
    float _318 = _294 * _315;
    float _319 = _316 + cb0_005y;
    float _320 = _317 + cb0_005y;
    float _321 = _318 + cb0_005y;
    float _322 = 1.0f - cb0_005y;
    float _323 = _276 * _322;
    float _324 = _277 * _322;
    float _325 = _278 * _322;
    float _326 = _310 * _319;
    float _327 = _311 * _320;
    float _328 = _312 * _321;
    float _329 = _326 + _323;
    float _330 = _327 + _324;
    float _331 = _328 + _325;
    _333 = _329;
    _334 = _330;
    _335 = _331;
  }
  _333 = max(0.f, _276 + (_333 - _276) * CUSTOM_BLOOM);
  _334 = max(0.f, _277 + (_334 - _277) * CUSTOM_BLOOM);
  _335 = max(0.f, _278 + (_335 - _278) * CUSTOM_BLOOM);
  float _336 = _176.x * _333;
  float _337 = _176.x * _334;
  float _338 = _176.x * _335;
  float _339 = _336 * 0.6430370807647705f;
  float _340 = mad(0.31118518114089966f, _337, _339);
  float _341 = mad(0.04577704519033432f, _338, _340);
  float _342 = _336 * 0.059270311146974564f;
  float _343 = mad(0.9314354062080383f, _337, _342);
  float _344 = mad(0.009296739473938942f, _338, _343);
  float _345 = _336 * 0.0059599666856229305f;
  float _346 = mad(0.06392385065555573f, _337, _345);
  float _347 = mad(0.9301166534423828f, _338, _346);
  float _348 = log2(_341);
  float _349 = log2(_344);
  float _350 = log2(_347);
  float _351 = _348 + 9.720000267028809f;
  float _352 = _349 + 9.720000267028809f;
  float _353 = _350 + 9.720000267028809f;
  float _354 = _351 * 0.05707762390375137f;
  float _355 = _352 * 0.05707762390375137f;
  float _356 = _353 * 0.05707762390375137f;
  float _359 = cb0_007x * 0.05707762390375137f;
  float _360 = _359 + _354;
  float _361 = _359 + _355;
  float _362 = _359 + _356;
  bool _365 = !(cb0_002x <= 0.0f);
  if (_365) {
    float _367 = TEXCOORD.x * 2.0f;
    float _368 = TEXCOORD.y * 2.0f;
    float _369 = _367 + -1.0f;
    float _370 = _368 + -1.0f;
    float _374 = _369 - cb0_003x;
    float _375 = _370 - cb0_003y;
    float _376 = abs(_374);
    float _377 = abs(_375);
    float _380 = cb0_003z * _376;
    float _381 = cb0_003w * _377;
    float _383 = 1.0f / cb0_002w;
    float _384 = log2(_380);
    float _385 = _384 * cb0_002w;
    float _386 = exp2(_385);
    float _387 = log2(_381);
    float _388 = _387 * cb0_002w;
    float _389 = exp2(_388);
    float _390 = _389 + _386;
    float _391 = log2(_390);
    float _392 = _391 * _383;
    float _393 = exp2(_392);
    float _395 = cb0_002y * _393;
    float _396 = saturate(_395);
    float _398 = log2(_396);
    float _399 = _398 * cb0_002z;
    float _400 = exp2(_399);
    float _401 = _400 * (cb0_002x * CUSTOM_VIGNETTE);
    float _406 = 1.0f - cb0_001x;
    float _407 = 1.0f - cb0_001y;
    float _408 = 1.0f - cb0_001z;
    float _409 = _406 * _401;
    float _410 = _407 * _401;
    float _411 = _408 * _401;
    float _412 = min(_409, 0.9999989867210388f);
    float _413 = min(_410, 0.9999989867210388f);
    float _414 = min(_411, 0.9999989867210388f);
    float _415 = 1.0f - _412;
    float _416 = 1.0f - _413;
    float _417 = 1.0f - _414;
    float _418 = log2(_415);
    float _419 = log2(_416);
    float _420 = log2(_417);
    float _421 = _418 * 0.05707762390375137f;
    float _422 = _419 * 0.05707762390375137f;
    float _423 = _420 * 0.05707762390375137f;
    float _424 = _421 + _360;
    float _425 = _422 + _361;
    float _426 = _423 + _362;
    _428 = _424;
    _429 = _425;
    _430 = _426;
  } else {
    _428 = _360;
    _429 = _361;
    _430 = _362;
  }
  [branch] if (SR_TONE_MAP_ACTIVE) {
    SV_Target = float4(ApplySaintsRowScene(float3(_428, _429, _430) * 17.52f - cb0_007x, float3(cb0_space5_008x, cb0_space5_008y, cb0_space5_008z)), cb0_space5_008w * _279);
#if SR_DEBUG_MEASURE
    SV_Target.rgb = DrawMeasureOverlay(SV_Target.rgb, SV_Position.xy, t21, s2_space1, cb0_005x, float4(cb0_004x, cb0_004y, cb0_004z, cb0_004w), cb0_006w, float2(cb0_006y, cb0_006z), cb0_007x);
#endif
    return SV_Target;
  }
  bool _433 = (cb0_005x == 3);
  float _434 = _428 * 17.520000457763672f;
  float _435 = _429 * 17.520000457763672f;
  float _436 = _430 * 17.520000457763672f;
  if (_433) {
    float _438 = _434 + -9.720000267028809f;
    float _439 = _435 + -9.720000267028809f;
    float _440 = _436 + -9.720000267028809f;
    float _441 = exp2(_438);
    float _442 = exp2(_439);
    float _443 = exp2(_440);
    float _444 = _441 * 0.3390841782093048f;
    float _445 = _442 * 0.3390841782093048f;
    float _446 = _443 * 0.3390841782093048f;
    _1270 = _444;
    _1271 = _445;
    _1272 = _446;
  } else {
    bool _448 = (cb0_005x == 2);
    if (_448) {
      float _450 = _434 + -9.720000267028809f;
      float _451 = _435 + -9.720000267028809f;
      float _452 = _436 + -9.720000267028809f;
      float _453 = exp2(_450);
      float _454 = exp2(_451);
      float _455 = exp2(_452);
      float _456 = _453 * 0.6954522132873535f;
      float _457 = mad(0.14067870378494263f, _454, _456);
      float _458 = mad(0.16386906802654266f, _455, _457);
      float _459 = _453 * 0.044794563204050064f;
      float _460 = mad(0.8596711158752441f, _454, _459);
      float _461 = mad(0.0955343171954155f, _455, _460);
      float _462 = _453 * -0.005525882821530104f;
      float _463 = mad(0.004025210160762072f, _454, _462);
      float _464 = mad(1.0015007257461548f, _455, _463);
      float _465 = max(_461, _464);
      float _466 = max(_458, _465);
      float _467 = max(_466, 1.000000013351432e-10f);
      float _468 = min(_461, _464);
      float _469 = min(_458, _468);
      float _470 = max(_469, 1.000000013351432e-10f);
      float _471 = _467 - _470;
      float _472 = max(_466, 0.009999999776482582f);
      float _473 = _471 / _472;
      float _474 = _464 - _461;
      float _475 = _474 * _464;
      float _476 = _461 - _458;
      float _477 = _476 * _461;
      float _478 = _475 + _477;
      float _479 = _458 - _464;
      float _480 = _479 * _458;
      float _481 = _478 + _480;
      float _482 = sqrt(_481);
      float _483 = _482 * 1.75f;
      float _484 = _461 + _458;
      float _485 = _484 + _464;
      float _486 = _485 + _483;
      float _487 = _486 * 0.3333333432674408f;
      float _488 = _473 + -0.4000000059604645f;
      float _489 = _488 * 5.0f;
      float _490 = _488 * 2.5f;
      float _491 = abs(_490);
      float _492 = 1.0f - _491;
      float _493 = max(_492, 0.0f);
      bool _494 = (_489 > 0.0f);
      bool _495 = (_489 < 0.0f);
      int _496 = (int)(uint)(_494);
      int _497 = (int)(uint)(_495);
      int _498 = _496 - _497;
      float _499 = float((int)(_498));
      float _500 = _493 * _493;
      float _501 = 1.0f - _500;
      float _502 = _499 * _501;
      float _503 = _502 + 1.0f;
      float _504 = _503 * 0.02500000037252903f;
      bool _505 = !(_487 <= 0.0533333346247673f);
      if (_505) {
        bool _507 = !(_487 >= 0.1599999964237213f);
        if (_507) {
          float _509 = 0.23999999463558197f / _486;
          float _510 = _509 + -0.5f;
          float _511 = _510 * _504;
          _513 = _511;
        } else {
          _513 = 0.0f;
        }
      } else {
        _513 = _504;
      }
      float _514 = _513 + 1.0f;
      float _515 = _514 * _458;
      float _516 = _514 * _461;
      float _517 = _514 * _464;
      bool _518 = (_515 == _516);
      bool _519 = (_516 == _517);
      bool _520 = _518 && _519;
      if (!_520) {
        float _522 = _515 * 2.0f;
        float _523 = _522 - _516;
        float _524 = _523 - _517;
        float _525 = _461 - _464;
        float _526 = _525 * 1.7320507764816284f;
        float _527 = _526 * _514;
        float _528 = _527 / _524;
        float _529 = atan(_528);
        float _530 = _529 + 3.1415927410125732f;
        float _531 = _529 + -3.1415927410125732f;
        bool _532 = (_524 < 0.0f);
        bool _533 = (_524 == 0.0f);
        bool _534 = (_527 >= 0.0f);
        bool _535 = (_527 < 0.0f);
        bool _536 = _534 && _532;
        float _537 = select(_536, _530, _529);
        bool _538 = _535 && _532;
        float _539 = select(_538, _531, _537);
        bool _540 = _535 && _533;
        bool _541 = _534 && _533;
        float _542 = _539 * 57.2957763671875f;
        float _543 = select(_540, -90.0f, _542);
        float _544 = select(_541, 90.0f, _543);
        _546 = _544;
      } else {
        _546 = 0.0f;
      }
      bool _547 = (_546 < 0.0f);
      float _548 = _546 + 360.0f;
      float _549 = select(_547, _548, _546);
      bool _550 = (_549 < -180.0f);
      if (_550) {
        float _552 = _549 + 360.0f;
        _558 = _552;
      } else {
        bool _554 = (_549 > 180.0f);
        if (_554) {
          float _556 = _549 + -360.0f;
          _558 = _556;
        } else {
          _558 = _549;
        }
      }
      bool _559 = (_558 > -67.5f);
      bool _560 = (_558 < 67.5f);
      bool _561 = _559 && _560;
      if (_561) {
        float _563 = _558 + 67.5f;
        float _564 = _563 * 0.029629629105329514f;
        int _565 = int(_564);
        float _566 = float((int)(_565));
        float _567 = _564 - _566;
        float _568 = _567 * _567;
        float _569 = _568 * _567;
        bool _570 = (_565 == 3);
        if (_570) {
          float _572 = _569 * 0.1666666716337204f;
          float _573 = _568 * 0.5f;
          float _574 = _567 * 0.5f;
          float _575 = 0.1666666716337204f - _574;
          float _576 = _575 + _573;
          float _577 = _576 - _572;
          _597 = _577;
        } else {
          bool _579 = (_565 == 2);
          if (_579) {
            float _581 = _569 * 0.5f;
            float _582 = 0.6666666865348816f - _568;
            float _583 = _582 + _581;
            _597 = _583;
          } else {
            bool _585 = (_565 == 1);
            if (_585) {
              float _587 = _569 * -0.5f;
              float _588 = _568 + _567;
              float _589 = _588 * 0.5f;
              float _590 = _587 + 0.1666666716337204f;
              float _591 = _590 + _589;
              _597 = _591;
            } else {
              bool _593 = (_565 == 0);
              float _594 = _569 * 0.1666666716337204f;
              float _595 = select(_593, _594, 0.0f);
              _597 = _595;
            }
          }
        }
      } else {
        _597 = 0.0f;
      }
      float _598 = 0.029999999329447746f - _515;
      float _599 = _473 * 0.27000001072883606f;
      float _600 = _599 * _598;
      float _601 = _600 * _597;
      float _602 = _601 + _515;
      float _603 = max(_602, 0.0f);
      float _604 = max(_516, 0.0f);
      float _605 = max(_517, 0.0f);
      float _606 = min(_603, 65536.0f);
      float _607 = min(_604, 65536.0f);
      float _608 = min(_605, 65536.0f);
      float _609 = _606 * 1.4514392614364624f;
      float _610 = mad(-0.2365107536315918f, _607, _609);
      float _611 = mad(-0.21492856740951538f, _608, _610);
      float _612 = _606 * -0.07655377686023712f;
      float _613 = mad(1.17622971534729f, _607, _612);
      float _614 = mad(-0.09967592358589172f, _608, _613);
      float _615 = _606 * 0.008316148072481155f;
      float _616 = mad(-0.006032449658960104f, _607, _615);
      float _617 = mad(0.9977163076400757f, _608, _616);
      float _618 = max(_611, 0.0f);
      float _619 = max(_614, 0.0f);
      float _620 = max(_617, 0.0f);
      float _621 = min(_618, 65504.0f);
      float _622 = min(_619, 65504.0f);
      float _623 = min(_620, 65504.0f);
      float _624 = _621 * 0.970889151096344f;
      float _625 = mad(0.026963284239172935f, _622, _624);
      float _626 = mad(0.0021475818939507008f, _623, _625);
      float _627 = _621 * 0.010889154858887196f;
      float _628 = mad(0.9869632720947266f, _622, _627);
      float _629 = mad(0.0021475818939507008f, _623, _628);
      float _630 = mad(0.026963284239172935f, _622, _627);
      float _631 = mad(0.9621475338935852f, _623, _630);
      bool _632 = (_626 <= 0.0f);
      float _633 = select(_632, 6.103515625e-05f, _626);
      float _634 = log2(_633);
      float _635 = _634 * 0.3010300099849701f;
      bool _636 = !(_635 <= -5.2601776123046875f);
      if (_636) {
        bool _638 = (_635 > -5.2601776123046875f);
        bool _639 = (_635 < -0.7447274923324585f);
        bool _640 = _638 && _639;
        if (_640) {
          float _642 = _634 * 0.19999998807907104f;
          float _643 = _642 + 3.494786262512207f;
          int _644 = int(_643);
          float _645 = float((int)(_644));
          float _646 = _643 - _645;
          float _648 = _global_0[_644];
          int _649 = _644 + 1;
          float _651 = _global_0[_649];
          int _652 = _644 + 2;
          float _654 = _global_0[_652];
          float _655 = _646 * _646;
          float _656 = _648 * 0.5f;
          float _657 = mad(_651, -1.0f, _656);
          float _658 = mad(_654, 0.5f, _657);
          float _659 = _651 - _648;
          float _660 = mad(_651, 0.5f, _656);
          float _661 = dot(float3(_655, _646, 1.0f), float3(_658, _659, _660));
          _688 = _661;
        } else {
          bool _663 = (_635 >= -0.7447274923324585f);
          bool _664 = (_635 < 4.673812389373779f);
          bool _665 = _663 && _664;
          if (_665) {
            float _667 = _634 * 0.1666666567325592f;
            float _668 = _667 + 0.4123218357563019f;
            int _669 = int(_668);
            float _670 = float((int)(_669));
            float _671 = _668 - _670;
            float _673 = _global_1[_669];
            int _674 = _669 + 1;
            float _676 = _global_1[_674];
            int _677 = _669 + 2;
            float _679 = _global_1[_677];
            float _680 = _671 * _671;
            float _681 = _673 * 0.5f;
            float _682 = mad(_676, -1.0f, _681);
            float _683 = mad(_679, 0.5f, _682);
            float _684 = _676 - _673;
            float _685 = mad(_676, 0.5f, _681);
            float _686 = dot(float3(_680, _671, 1.0f), float3(_683, _684, _685));
            _688 = _686;
          } else {
            _688 = 4.0f;
          }
        }
      } else {
        _688 = -4.0f;
      }
      float _689 = _688 * 3.321928024291992f;
      float _690 = exp2(_689);
      bool _691 = (_629 <= 0.0f);
      float _692 = select(_691, 6.103515625e-05f, _629);
      float _693 = log2(_692);
      float _694 = _693 * 0.3010300099849701f;
      bool _695 = !(_694 <= -5.2601776123046875f);
      if (_695) {
        bool _697 = (_694 > -5.2601776123046875f);
        bool _698 = (_694 < -0.7447274923324585f);
        bool _699 = _697 && _698;
        if (_699) {
          float _701 = _693 * 0.19999998807907104f;
          float _702 = _701 + 3.494786262512207f;
          int _703 = int(_702);
          float _704 = float((int)(_703));
          float _705 = _702 - _704;
          float _707 = _global_0[_703];
          int _708 = _703 + 1;
          float _710 = _global_0[_708];
          int _711 = _703 + 2;
          float _713 = _global_0[_711];
          float _714 = _705 * _705;
          float _715 = _707 * 0.5f;
          float _716 = mad(_710, -1.0f, _715);
          float _717 = mad(_713, 0.5f, _716);
          float _718 = _710 - _707;
          float _719 = mad(_710, 0.5f, _715);
          float _720 = dot(float3(_714, _705, 1.0f), float3(_717, _718, _719));
          _747 = _720;
        } else {
          bool _722 = (_694 >= -0.7447274923324585f);
          bool _723 = (_694 < 4.673812389373779f);
          bool _724 = _722 && _723;
          if (_724) {
            float _726 = _693 * 0.1666666567325592f;
            float _727 = _726 + 0.4123218357563019f;
            int _728 = int(_727);
            float _729 = float((int)(_728));
            float _730 = _727 - _729;
            float _732 = _global_1[_728];
            int _733 = _728 + 1;
            float _735 = _global_1[_733];
            int _736 = _728 + 2;
            float _738 = _global_1[_736];
            float _739 = _730 * _730;
            float _740 = _732 * 0.5f;
            float _741 = mad(_735, -1.0f, _740);
            float _742 = mad(_738, 0.5f, _741);
            float _743 = _735 - _732;
            float _744 = mad(_735, 0.5f, _740);
            float _745 = dot(float3(_739, _730, 1.0f), float3(_742, _743, _744));
            _747 = _745;
          } else {
            _747 = 4.0f;
          }
        }
      } else {
        _747 = -4.0f;
      }
      float _748 = _747 * 3.321928024291992f;
      float _749 = exp2(_748);
      bool _750 = (_631 <= 0.0f);
      float _751 = select(_750, 6.103515625e-05f, _631);
      float _752 = log2(_751);
      float _753 = _752 * 0.3010300099849701f;
      bool _754 = !(_753 <= -5.2601776123046875f);
      if (_754) {
        bool _756 = (_753 > -5.2601776123046875f);
        bool _757 = (_753 < -0.7447274923324585f);
        bool _758 = _756 && _757;
        if (_758) {
          float _760 = _752 * 0.19999998807907104f;
          float _761 = _760 + 3.494786262512207f;
          int _762 = int(_761);
          float _763 = float((int)(_762));
          float _764 = _761 - _763;
          float _766 = _global_0[_762];
          int _767 = _762 + 1;
          float _769 = _global_0[_767];
          int _770 = _762 + 2;
          float _772 = _global_0[_770];
          float _773 = _764 * _764;
          float _774 = _766 * 0.5f;
          float _775 = mad(_769, -1.0f, _774);
          float _776 = mad(_772, 0.5f, _775);
          float _777 = _769 - _766;
          float _778 = mad(_769, 0.5f, _774);
          float _779 = dot(float3(_773, _764, 1.0f), float3(_776, _777, _778));
          _806 = _779;
        } else {
          bool _781 = (_753 >= -0.7447274923324585f);
          bool _782 = (_753 < 4.673812389373779f);
          bool _783 = _781 && _782;
          if (_783) {
            float _785 = _752 * 0.1666666567325592f;
            float _786 = _785 + 0.4123218357563019f;
            int _787 = int(_786);
            float _788 = float((int)(_787));
            float _789 = _786 - _788;
            float _791 = _global_1[_787];
            int _792 = _787 + 1;
            float _794 = _global_1[_792];
            int _795 = _787 + 2;
            float _797 = _global_1[_795];
            float _798 = _789 * _789;
            float _799 = _791 * 0.5f;
            float _800 = mad(_794, -1.0f, _799);
            float _801 = mad(_797, 0.5f, _800);
            float _802 = _794 - _791;
            float _803 = mad(_794, 0.5f, _799);
            float _804 = dot(float3(_798, _789, 1.0f), float3(_801, _802, _803));
            _806 = _804;
          } else {
            _806 = 4.0f;
          }
        }
      } else {
        _806 = -4.0f;
      }
      float _807 = _806 * 3.321928024291992f;
      float _808 = exp2(_807);
      bool _809 = (_690 <= 0.0f);
      float _810 = select(_809, 9.999999747378752e-05f, _690);
      float _811 = log2(_810);
      float _812 = _811 * 0.3010300099849701f;
      bool _813 = !(_812 <= -2.540623664855957f);
      if (_813) {
        bool _815 = (_812 > -2.540623664855957f);
        bool _816 = (_812 < 0.6812411546707153f);
        bool _817 = _815 && _816;
        if (_817) {
          float _819 = _811 + 8.43976879119873f;
          float _820 = _819 * 0.6540343165397644f;
          int _821 = int(_820);
          float _822 = float((int)(_821));
          float _823 = _820 - _822;
          float _825 = _global_2[_821];
          int _826 = _821 + 1;
          float _828 = _global_2[_826];
          int _829 = _821 + 2;
          float _831 = _global_2[_829];
          float _832 = _823 * _823;
          float _833 = _825 * 0.5f;
          float _834 = mad(_828, -1.0f, _833);
          float _835 = mad(_831, 0.5f, _834);
          float _836 = _828 - _825;
          float _837 = mad(_828, 0.5f, _833);
          float _838 = dot(float3(_832, _823, 1.0f), float3(_835, _836, _837));
          _868 = _838;
        } else {
          bool _840 = (_812 >= 0.6812411546707153f);
          bool _841 = (_812 < 3.002476692199707f);
          bool _842 = _840 && _841;
          if (_842) {
            float _844 = _811 + -2.2630341053009033f;
            float _845 = _844 * 0.9077967405319214f;
            int _846 = int(_845);
            float _847 = float((int)(_846));
            float _848 = _845 - _847;
            float _850 = _global_3[_846];
            int _851 = _846 + 1;
            float _853 = _global_3[_851];
            int _854 = _846 + 2;
            float _856 = _global_3[_854];
            float _857 = _848 * _848;
            float _858 = _850 * 0.5f;
            float _859 = mad(_853, -1.0f, _858);
            float _860 = mad(_856, 0.5f, _859);
            float _861 = _853 - _850;
            float _862 = mad(_853, 0.5f, _858);
            float _863 = dot(float3(_857, _848, 1.0f), float3(_860, _861, _862));
            _868 = _863;
          } else {
            float _865 = _811 * 0.012041199952363968f;
            float _866 = _865 + 1.5611422061920166f;
            _868 = _866;
          }
        }
      } else {
        _868 = -1.698970079421997f;
      }
      float _869 = _868 * 3.321928024291992f;
      float _870 = exp2(_869);
      bool _871 = (_749 <= 0.0f);
      float _872 = select(_871, 9.999999747378752e-05f, _749);
      float _873 = log2(_872);
      float _874 = _873 * 0.3010300099849701f;
      bool _875 = !(_874 <= -2.540623664855957f);
      if (_875) {
        bool _877 = (_874 > -2.540623664855957f);
        bool _878 = (_874 < 0.6812411546707153f);
        bool _879 = _877 && _878;
        if (_879) {
          float _881 = _873 + 8.43976879119873f;
          float _882 = _881 * 0.6540343165397644f;
          int _883 = int(_882);
          float _884 = float((int)(_883));
          float _885 = _882 - _884;
          float _887 = _global_2[_883];
          int _888 = _883 + 1;
          float _890 = _global_2[_888];
          int _891 = _883 + 2;
          float _893 = _global_2[_891];
          float _894 = _885 * _885;
          float _895 = _887 * 0.5f;
          float _896 = mad(_890, -1.0f, _895);
          float _897 = mad(_893, 0.5f, _896);
          float _898 = _890 - _887;
          float _899 = mad(_890, 0.5f, _895);
          float _900 = dot(float3(_894, _885, 1.0f), float3(_897, _898, _899));
          _930 = _900;
        } else {
          bool _902 = (_874 >= 0.6812411546707153f);
          bool _903 = (_874 < 3.002476692199707f);
          bool _904 = _902 && _903;
          if (_904) {
            float _906 = _873 + -2.2630341053009033f;
            float _907 = _906 * 0.9077967405319214f;
            int _908 = int(_907);
            float _909 = float((int)(_908));
            float _910 = _907 - _909;
            float _912 = _global_3[_908];
            int _913 = _908 + 1;
            float _915 = _global_3[_913];
            int _916 = _908 + 2;
            float _918 = _global_3[_916];
            float _919 = _910 * _910;
            float _920 = _912 * 0.5f;
            float _921 = mad(_915, -1.0f, _920);
            float _922 = mad(_918, 0.5f, _921);
            float _923 = _915 - _912;
            float _924 = mad(_915, 0.5f, _920);
            float _925 = dot(float3(_919, _910, 1.0f), float3(_922, _923, _924));
            _930 = _925;
          } else {
            float _927 = _873 * 0.012041199952363968f;
            float _928 = _927 + 1.5611422061920166f;
            _930 = _928;
          }
        }
      } else {
        _930 = -1.698970079421997f;
      }
      float _931 = _930 * 3.321928024291992f;
      float _932 = exp2(_931);
      bool _933 = (_808 <= 0.0f);
      float _934 = select(_933, 9.999999747378752e-05f, _808);
      float _935 = log2(_934);
      float _936 = _935 * 0.3010300099849701f;
      bool _937 = !(_936 <= -2.540623664855957f);
      if (_937) {
        bool _939 = (_936 > -2.540623664855957f);
        bool _940 = (_936 < 0.6812411546707153f);
        bool _941 = _939 && _940;
        if (_941) {
          float _943 = _935 + 8.43976879119873f;
          float _944 = _943 * 0.6540343165397644f;
          int _945 = int(_944);
          float _946 = float((int)(_945));
          float _947 = _944 - _946;
          float _949 = _global_2[_945];
          int _950 = _945 + 1;
          float _952 = _global_2[_950];
          int _953 = _945 + 2;
          float _955 = _global_2[_953];
          float _956 = _947 * _947;
          float _957 = _949 * 0.5f;
          float _958 = mad(_952, -1.0f, _957);
          float _959 = mad(_955, 0.5f, _958);
          float _960 = _952 - _949;
          float _961 = mad(_952, 0.5f, _957);
          float _962 = dot(float3(_956, _947, 1.0f), float3(_959, _960, _961));
          _992 = _962;
        } else {
          bool _964 = (_936 >= 0.6812411546707153f);
          bool _965 = (_936 < 3.002476692199707f);
          bool _966 = _964 && _965;
          if (_966) {
            float _968 = _935 + -2.2630341053009033f;
            float _969 = _968 * 0.9077967405319214f;
            int _970 = int(_969);
            float _971 = float((int)(_970));
            float _972 = _969 - _971;
            float _974 = _global_3[_970];
            int _975 = _970 + 1;
            float _977 = _global_3[_975];
            int _978 = _970 + 2;
            float _980 = _global_3[_978];
            float _981 = _972 * _972;
            float _982 = _974 * 0.5f;
            float _983 = mad(_977, -1.0f, _982);
            float _984 = mad(_980, 0.5f, _983);
            float _985 = _977 - _974;
            float _986 = mad(_977, 0.5f, _982);
            float _987 = dot(float3(_981, _972, 1.0f), float3(_984, _985, _986));
            _992 = _987;
          } else {
            float _989 = _935 * 0.012041199952363968f;
            float _990 = _989 + 1.5611422061920166f;
            _992 = _990;
          }
        }
      } else {
        _992 = -1.698970079421997f;
      }
      float _993 = _992 * 3.321928024291992f;
      float _994 = exp2(_993);
      float _995 = _870 + -0.020000001415610313f;
      float _996 = _932 + -0.020000001415610313f;
      float _997 = _996 * 0.020842017605900764f;
      float _998 = _994 + -0.020000001415610313f;
      float _999 = _998 * 0.020842017605900764f;
      float _1000 = _995 * 0.013806881383061409f;
      float _1001 = mad(0.13400420546531677f, _997, _1000);
      float _1002 = mad(0.15618768334388733f, _999, _1001);
      float _1003 = _995 * 0.005673795938491821f;
      float _1004 = mad(0.6740817427635193f, _997, _1003);
      float _1005 = mad(0.053689517080783844f, _999, _1004);
      float _1006 = _995 * -0.00011618694406934083f;
      float _1007 = mad(0.00406073359772563f, _997, _1006);
      float _1008 = mad(1.0103391408920288f, _999, _1007);
      float _1009 = _1005 + _1002;
      float _1010 = _1009 + _1008;
      bool _1011 = (_1010 == 0.0f);
      float _1012 = select(_1011, 1.000000013351432e-10f, _1010);
      float _1013 = _1002 / _1012;
      float _1014 = _1005 / _1012;
      float _1015 = max(_1005, 0.0f);
      float _1016 = log2(_1015);
      float _1017 = _1016 * 0.9811000227928162f;
      float _1018 = exp2(_1017);
      float _1019 = _1018 * _1013;
      float _1020 = max(_1014, 1.000000013351432e-10f);
      float _1021 = _1019 / _1020;
      float _1022 = 1.0f - _1013;
      float _1023 = _1022 - _1014;
      float _1024 = _1018 * _1023;
      float _1025 = _1024 / _1020;
      float _1026 = _1021 * 1.6410233974456787f;
      float _1027 = mad(-0.32480329275131226f, _1018, _1026);
      float _1028 = mad(-0.23642469942569733f, _1025, _1027);
      float _1029 = _1021 * -0.663662850856781f;
      float _1030 = mad(1.6153316497802734f, _1018, _1029);
      float _1031 = mad(0.016756348311901093f, _1025, _1030);
      float _1032 = _1021 * 0.011721894145011902f;
      float _1033 = mad(-0.008284442126750946f, _1018, _1032);
      float _1034 = mad(0.9883948564529419f, _1025, _1033);
      float _1035 = _1028 * 0.9490560293197632f;
      float _1036 = mad(0.04718571901321411f, _1031, _1035);
      float _1037 = mad(0.003758265869691968f, _1034, _1036);
      float _1038 = _1028 * 0.019056009128689766f;
      float _1039 = mad(0.9771857261657715f, _1031, _1038);
      float _1040 = mad(0.003758265869691968f, _1034, _1039);
      float _1041 = mad(0.04718571901321411f, _1031, _1038);
      float _1042 = mad(0.9337582588195801f, _1034, _1041);
      float _1043 = _1037 * 0.6624541878700256f;
      float _1044 = mad(0.13400420546531677f, _1040, _1043);
      float _1045 = mad(0.15618768334388733f, _1042, _1044);
      float _1046 = _1037 * 0.2722287178039551f;
      float _1047 = mad(0.6740817427635193f, _1040, _1046);
      float _1048 = mad(0.053689517080783844f, _1042, _1047);
      float _1049 = _1037 * -0.005574649665504694f;
      float _1050 = mad(0.00406073359772563f, _1040, _1049);
      float _1051 = mad(1.0103391408920288f, _1042, _1050);
      float _1052 = _1045 * 0.9872239828109741f;
      float _1053 = mad(-0.006113269831985235f, _1048, _1052);
      float _1054 = mad(0.015953300520777702f, _1051, _1053);
      float _1055 = _1045 * -0.007598360069096088f;
      float _1056 = mad(1.0018600225448608f, _1048, _1055);
      float _1057 = mad(0.005330020096153021f, _1051, _1056);
      float _1058 = _1045 * 0.003072570078074932f;
      float _1059 = mad(-0.005095949862152338f, _1048, _1058);
      float _1060 = mad(1.0816800594329834f, _1051, _1059);
      float _1061 = _1054 * 3.2409698963165283f;
      float _1062 = mad(-1.5373831987380981f, _1057, _1061);
      float _1063 = mad(-0.4986107647418976f, _1060, _1062);
      float _1064 = _1054 * -0.9692436456680298f;
      float _1065 = mad(1.8759675025939941f, _1057, _1064);
      float _1066 = mad(0.04155505821108818f, _1060, _1065);
      float _1067 = _1054 * 0.05563008040189743f;
      float _1068 = mad(-0.20397695899009705f, _1057, _1067);
      float _1069 = mad(1.056971549987793f, _1060, _1068);
      float _1070 = saturate(_1063);
      float _1071 = saturate(_1066);
      float _1072 = saturate(_1069);
      _1270 = _1070;
      _1271 = _1071;
      _1272 = _1072;
    } else {
      bool _1074 = (cb0_005x == 1);
      if (_1074) {
        float _1080 = _428 * 0.5309091210365295f;
        float _1081 = _429 * 0.5309091210365295f;
        float _1082 = _430 * 0.5309091210365295f;
        float _1083 = _1080 + 0.23496760427951813f;
        float _1084 = _1081 + 0.23496760427951813f;
        float _1085 = _1082 + 0.23496760427951813f;
        uint3 _1086;
        t20.GetDimensions(_1086.x, _1086.y, _1086.z);
        uint2 _1090;
        t21.GetDimensions(_1090.x, _1090.y);
        uint _1092 = _1086.x + -1u;
        uint _1093 = _1086.y + -1u;
        uint _1094 = _1086.z + -1u;
        float _1095 = float((uint)_1092);
        float _1096 = float((uint)_1093);
        float _1097 = float((uint)_1094);
        float _1098 = float((uint)_1086.x);
        float _1099 = float((uint)_1086.y);
        float _1100 = float((uint)_1086.z);
        float _1101 = _1095 / _1098;
        float _1102 = _1096 / _1099;
        float _1103 = _1097 / _1100;
        float _1104 = 0.5f / _1098;
        float _1105 = 0.5f / _1099;
        float _1106 = 0.5f / _1100;
        float _1107 = _1101 * _1083;
        float _1108 = _1102 * _1084;
        float _1109 = _1103 * _1085;
        float _1110 = _1104 + _1107;
        float _1111 = _1105 + _1108;
        float _1112 = _1106 + _1109;
        float4 _1113 = t20.SampleLevel(s2_space1, float3(_1110, _1111, _1112), 0.0f);
        float _1116 = _434 + -9.719999313354492f;
        float _1117 = _435 + -9.719999313354492f;
        float _1118 = _436 + -9.719999313354492f;
        float _1119 = exp2(_1116);
        float _1120 = exp2(_1117);
        float _1121 = exp2(_1118);
        float _1122 = _1119 * 0.6954522132873535f;
        float _1123 = mad(0.14067870378494263f, _1120, _1122);
        float _1124 = mad(0.16386906802654266f, _1121, _1123);
        float _1125 = _1119 * 0.044794563204050064f;
        float _1126 = mad(0.8596711158752441f, _1120, _1125);
        float _1127 = mad(0.0955343171954155f, _1121, _1126);
        float _1128 = _1119 * -0.005525882821530104f;
        float _1129 = mad(0.004025210160762072f, _1120, _1128);
        float _1130 = mad(1.0015007257461548f, _1121, _1129);
        float _1131 = _1113.x + 1.0f;
        float _1132 = _1124 * _1131;
        float _1133 = _1127 * _1131;
        float _1134 = _1130 * _1131;
        float _1135 = _1132 + _1113.y;
        float _1136 = max(_1135, 0.0f);
        float _1137 = max(_1133, 0.0f);
        float _1138 = max(_1134, 0.0f);
        float _1139 = min(_1136, 65536.0f);
        float _1140 = min(_1137, 65536.0f);
        float _1141 = min(_1138, 65536.0f);
        float _1142 = _1139 * 1.4514392614364624f;
        float _1143 = mad(-0.2365107536315918f, _1140, _1142);
        float _1144 = mad(-0.21492856740951538f, _1141, _1143);
        float _1145 = _1139 * -0.07655377686023712f;
        float _1146 = mad(1.17622971534729f, _1140, _1145);
        float _1147 = mad(-0.09967592358589172f, _1141, _1146);
        float _1148 = _1139 * 0.008316148072481155f;
        float _1149 = mad(-0.006032449658960104f, _1140, _1148);
        float _1150 = mad(0.9977163076400757f, _1141, _1149);
        float _1151 = max(_1144, 0.0f);
        float _1152 = max(_1147, 0.0f);
        float _1153 = max(_1150, 0.0f);
        float _1154 = min(_1151, 65504.0f);
        float _1155 = min(_1152, 65504.0f);
        float _1156 = min(_1153, 65504.0f);
        float _1157 = _1154 * 0.970889151096344f;
        float _1158 = mad(0.026963284239172935f, _1155, _1157);
        float _1159 = mad(0.0021475818939507008f, _1156, _1158);
        float _1160 = _1154 * 0.010889154858887196f;
        float _1161 = mad(0.9869632720947266f, _1155, _1160);
        float _1162 = mad(0.0021475818939507008f, _1156, _1161);
        float _1163 = mad(0.026963284239172935f, _1155, _1160);
        float _1164 = mad(0.9621475338935852f, _1156, _1163);
        float _1165 = log2(_1159);
        float _1166 = log2(_1162);
        float _1167 = log2(_1164);
        float _1168 = _1165 + 17.47393035888672f;
        float _1169 = _1166 + 17.47393035888672f;
        float _1170 = _1167 + 17.47393035888672f;
        float _1171 = _1168 * 0.03030303120613098f;
        float _1172 = _1169 * 0.03030303120613098f;
        float _1173 = _1170 * 0.03030303120613098f;
        uint _1174 = _1090.x + -1u;
        float _1175 = float((uint)_1174);
        float _1176 = float((uint)_1090.x);
        float _1177 = _1175 / _1176;
        float _1178 = 0.5f / _1176;
        float _1179 = _1171 * _1177;
        float _1180 = _1172 * _1177;
        float _1181 = _1173 * _1177;
        float _1182 = _1179 + _1178;
        float _1183 = _1180 + _1178;
        float _1184 = _1181 + _1178;
        float4 _1185 = t21.SampleLevel(s2_space1, float2(_1182, 0.5f), 0.0f);
        float4 _1187 = t21.SampleLevel(s2_space1, float2(_1183, 0.5f), 0.0f);
        float4 _1189 = t21.SampleLevel(s2_space1, float2(_1184, 0.5f), 0.0f);
        float _1191 = _1185.x * 3.321928024291992f;
        float _1192 = _1187.x * 3.321928024291992f;
        float _1193 = _1189.x * 3.321928024291992f;
        float _1194 = exp2(_1191);
        float _1195 = exp2(_1192);
        float _1196 = exp2(_1193);
        float _1197 = _1194 / cb0_006w;
        float _1198 = _1195 / cb0_006w;
        float _1199 = _1196 / cb0_006w;
        bool _1200 = (cb0_004w < 500.0f);
        if (_1200) {
          float _1202 = _1197 * 0.6624541878700256f;
          float _1203 = mad(0.13400420546531677f, _1198, _1202);
          float _1204 = mad(0.15618768334388733f, _1199, _1203);
          float _1205 = _1197 * 0.2722287178039551f;
          float _1206 = mad(0.6740817427635193f, _1198, _1205);
          float _1207 = mad(0.053689517080783844f, _1199, _1206);
          float _1208 = _1197 * -0.005574649665504694f;
          float _1209 = mad(0.00406073359772563f, _1198, _1208);
          float _1210 = mad(1.0103391408920288f, _1199, _1209);
          float _1211 = _1207 + _1204;
          float _1212 = _1211 + _1210;
          bool _1213 = (_1212 == 0.0f);
          float _1214 = select(_1213, 1.000000013351432e-10f, _1212);
          float _1215 = _1204 / _1214;
          float _1216 = _1207 / _1214;
          float _1217 = max(_1207, 0.0f);
          float _1218 = log2(_1217);
          float _1219 = _1218 * 0.9811000227928162f;
          float _1220 = exp2(_1219);
          float _1221 = _1220 * _1215;
          float _1222 = max(_1216, 1.000000013351432e-10f);
          float _1223 = _1221 / _1222;
          float _1224 = 1.0f - _1215;
          float _1225 = _1224 - _1216;
          float _1226 = _1220 * _1225;
          float _1227 = _1226 / _1222;
          float _1228 = _1223 * 1.6410233974456787f;
          float _1229 = mad(-0.32480329275131226f, _1220, _1228);
          float _1230 = mad(-0.23642469942569733f, _1227, _1229);
          float _1231 = _1223 * -0.663662850856781f;
          float _1232 = mad(1.6153316497802734f, _1220, _1231);
          float _1233 = mad(0.016756348311901093f, _1227, _1232);
          float _1234 = _1223 * 0.011721894145011902f;
          float _1235 = mad(-0.008284442126750946f, _1220, _1234);
          float _1236 = mad(0.9883948564529419f, _1227, _1235);
          _1238 = _1230;
          _1239 = _1233;
          _1240 = _1236;
        } else {
          _1238 = _1197;
          _1239 = _1198;
          _1240 = _1199;
        }
        float _1241 = _1238 * 1.6047539710998535f;
        float _1242 = mad(-0.5310794711112976f, _1239, _1241);
        float _1243 = mad(-0.07367203384637833f, _1240, _1242);
        float _1244 = _1238 * -0.10208318382501602f;
        float _1245 = mad(1.108132243156433f, _1239, _1244);
        float _1246 = mad(-0.006051875650882721f, _1240, _1245);
        float _1247 = _1238 * -0.0032670421060174704f;
        float _1248 = mad(-0.07275524735450745f, _1239, _1247);
        float _1249 = mad(1.0760219097137451f, _1240, _1248);
        float _1250 = max(_1243, 0.0f);
        float _1251 = max(_1246, 0.0f);
        float _1252 = max(_1249, 0.0f);
        _1270 = _1250;
        _1271 = _1251;
        _1272 = _1252;
      } else {
        float _1254 = _434 + -9.720000267028809f;
        float _1255 = _435 + -9.720000267028809f;
        float _1256 = _436 + -9.720000267028809f;
        float _1257 = exp2(_1254);
        float _1258 = exp2(_1255);
        float _1259 = exp2(_1256);
        float _1260 = _1257 * 1.6047539710998535f;
        float _1261 = mad(-0.5310794711112976f, _1258, _1260);
        float _1262 = mad(-0.07367203384637833f, _1259, _1261);
        float _1263 = _1257 * -0.10208318382501602f;
        float _1264 = mad(1.108132243156433f, _1258, _1263);
        float _1265 = mad(-0.006051875650882721f, _1259, _1264);
        float _1266 = _1257 * -0.0032670421060174704f;
        float _1267 = mad(-0.07275524735450745f, _1258, _1266);
        float _1268 = mad(1.0760219097137451f, _1259, _1267);
        _1270 = _1262;
        _1271 = _1265;
        _1272 = _1268;
      }
    }
  }
  float _1278 = cb0_space5_008x * _1270;
  float _1279 = cb0_space5_008y * _1271;
  float _1280 = cb0_space5_008z * _1272;
  float _1281 = cb0_space5_008w * _279;
  bool _1282 = (_1278 < 0.0031308000907301903f);
  bool _1283 = (_1279 < 0.0031308000907301903f);
  bool _1284 = (_1280 < 0.0031308000907301903f);
  float _1285 = _1278 * 12.920000076293945f;
  float _1286 = _1279 * 12.920000076293945f;
  float _1287 = _1280 * 12.920000076293945f;
  float _1288 = abs(_1278);
  float _1289 = abs(_1279);
  float _1290 = abs(_1280);
  float _1291 = log2(_1288);
  float _1292 = log2(_1289);
  float _1293 = log2(_1290);
  float _1294 = _1291 * 0.4166666567325592f;
  float _1295 = _1292 * 0.4166666567325592f;
  float _1296 = _1293 * 0.4166666567325592f;
  float _1297 = exp2(_1294);
  float _1298 = exp2(_1295);
  float _1299 = exp2(_1296);
  float _1300 = _1297 * 1.0549999475479126f;
  float _1301 = _1298 * 1.0549999475479126f;
  float _1302 = _1299 * 1.0549999475479126f;
  float _1303 = _1300 + -0.054999999701976776f;
  float _1304 = _1301 + -0.054999999701976776f;
  float _1305 = _1302 + -0.054999999701976776f;
  float _1306 = select(_1282, _1285, _1303);
  float _1307 = select(_1283, _1286, _1304);
  float _1308 = select(_1284, _1287, _1305);
  bool _1312 = !(cb0_006y == 0.0f);
  bool _1313 = !(cb0_006z == 0.0f);
  bool _1314 = _1312 || _1313;
  if (_1314) {
    float _1316 = cb0_006z - cb0_006y;
    float _1317 = _1316 * _1306;
    float _1318 = _1316 * _1307;
    float _1319 = _1316 * _1308;
    float _1320 = _1317 + cb0_006y;
    float _1321 = _1318 + cb0_006y;
    float _1322 = _1319 + cb0_006y;
    _1324 = _1320;
    _1325 = _1321;
    _1326 = _1322;
  } else {
    _1324 = _1306;
    _1325 = _1307;
    _1326 = _1308;
  }
  SV_Target.x = _1324;
  SV_Target.y = _1325;
  SV_Target.z = _1326;
  SV_Target.w = _1281;
#if SR_DEBUG_MEASURE
  SV_Target.rgb = DrawMeasureOverlay(SV_Target.rgb, SV_Position.xy, t21, s2_space1, cb0_005x, float4(cb0_004x, cb0_004y, cb0_004z, cb0_004w), cb0_006w, float2(cb0_006y, cb0_006z), cb0_007x);
#endif
  return SV_Target;
}

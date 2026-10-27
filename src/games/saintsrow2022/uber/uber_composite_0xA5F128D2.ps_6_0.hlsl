#include "../tonemap/tonemap.hlsli"

StructuredBuffer<float4> t11_space15 : register(t11, space15);

Texture2D<float4> t16 : register(t16);

Texture3D<float4> t17 : register(t17);

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
  float cb0_005z : packoffset(c005.z);
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
  float _25 = dot(float3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z), float3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z));
  float _26 = rsqrt(_25);
  float4 _27 = t0.SampleLevel(s2_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _34 = cb0_011y * _27.w;
  float _36 = cb0_011x * _27.w;
  float _37 = max(_36, _34);
  float _41 = max(cb0_009x, cb0_009y);
  float _42 = _41 * _37;
  float _45 = min(cb0_011z, cb0_011w);
  float _46 = _45 * 2.0f;
  bool _47 = (_42 > _46);
  bool _50 = (cb0_012z != 0);
  bool _51 = _47 && _50;
  float _128;
  float _129;
  float _274;
  float _275;
  float _276;
  float _334;
  float _335;
  float _336;
  float _373;
  float _495;
  float _496;
  float _497;
  float _580;
  float _613;
  float _625;
  float _664;
  float _755;
  float _814;
  float _873;
  float _935;
  float _997;
  float _1059;
  float _1305;
  float _1306;
  float _1307;
  float _1337;
  float _1338;
  float _1339;
  float _1391;
  float _1392;
  float _1393;
  [branch] if (_51) {
    float _53 = _26 * TEXCOORD_1.z;
    float _54 = _26 * TEXCOORD_1.y;
    float _55 = _26 * TEXCOORD_1.x;
    float _61 = cb1_space9_041y + cb1_space9_031y;
    float _65 = cb0_012x * cb1_space9_031x;
    float _66 = cb0_012x * _61;
    float _67 = cb0_012x * cb1_space9_031z;
    float _68 = _65 + _55;
    float _69 = _66 + _54;
    float _70 = _67 + _53;
    float _75 = _68 - cb0_010x;
    float _76 = _69 - cb0_010y;
    float _77 = _70 - cb0_010z;
    float _78 = _75 * cb0_009x;
    float _79 = _76 * cb0_009y;
    float _80 = _77 * cb0_009x;
    float _83 = _75 * cb0_009z;
    float _84 = _76 * cb0_009w;
    float _85 = _77 * cb0_009z;
    float _86 = t27.SampleLevel(s0_space1, float3(_78, _79, _80), 0.0f);
    float _88 = t28.SampleLevel(s0_space1, float3(_83, _84, _85), 0.0f);
    float _90 = _78 + 0.5f;
    float _91 = _79 + 0.5f;
    float _92 = _80 + 0.5f;
    float _93 = t27.SampleLevel(s0_space1, float3(_90, _91, _92), 0.0f);
    float _95 = _83 + 0.5f;
    float _96 = _84 + 0.5f;
    float _97 = _85 + 0.5f;
    float _98 = t28.SampleLevel(s0_space1, float3(_95, _96, _97), 0.0f);
    float _105 = _86.x - cb0_008x;
    float _106 = _105 * cb0_008y;
    float _107 = _88.x - cb0_008z;
    float _108 = _107 * cb0_008w;
    float _109 = _108 + -1.0f;
    float _110 = _109 + _106;
    float _111 = _110 * 6.2831854820251465f;
    float _112 = sin(_111);
    float _113 = _93.x - cb0_008x;
    float _114 = _113 * cb0_008y;
    float _115 = _98.x - cb0_008z;
    float _116 = _115 * cb0_008w;
    float _117 = _116 + -1.0f;
    float _118 = _117 + _114;
    float _119 = _118 * 6.2831854820251465f;
    float _120 = sin(_119);
    float _121 = _112 * _27.w;
    float _122 = _121 * cb0_011x;
    float _123 = _120 * _27.w;
    float _124 = _123 * cb0_011y;
    float _125 = _122 + TEXCOORD.x;
    float _126 = _124 + TEXCOORD.y;
    _128 = _125;
    _129 = _126;
  }
  else {
    _128 = TEXCOORD.x;
    _129 = TEXCOORD.y;
  }
  float _130 = _128 - cb0_011z;
  float _131 = _129 - cb0_011w;
  float4 _132 = t0.SampleLevel(s2_space1, float2(_130, _131), 0.0f);
  float _136 = _132.x - _132.z;
  float _137 = _136 * 0.5f;
  float _138 = _137 + _132.z;
  float _139 = _132.y - _138;
  float _140 = cb0_011w + _129;
  float4 _141 = t0.SampleLevel(s2_space1, float2(_130, _140), 0.0f);
  float _145 = _141.x - _141.z;
  float _146 = _145 * 0.5f;
  float _147 = _146 + _141.z;
  float _148 = _141.y - _147;
  float _149 = cb0_011z + _128;
  float4 _150 = t0.SampleLevel(s2_space1, float2(_149, _131), 0.0f);
  float _154 = _150.x - _150.z;
  float _155 = _154 * 0.5f;
  float _156 = _155 + _150.z;
  float _157 = _150.y - _156;
  float4 _158 = t0.SampleLevel(s2_space1, float2(_149, _140), 0.0f);
  float _162 = _158.x - _158.z;
  float _163 = _162 * 0.5f;
  float _164 = _163 + _158.z;
  float _165 = _158.y - _164;
  float4 _166 = t0.SampleLevel(s2_space1, float2(_128, _129), 0.0f);
  float _171 = _166.x - _166.z;
  float _172 = _171 * 0.5f;
  float _173 = _172 + _166.z;
  float _174 = _166.y - _173;
  float _175 = _174 * 0.5f;
  float _176 = _175 + _173;
  float4 _177 = t11_space15.Load(2);
  float _179 = _177.x * 4.0f;
  float _180 = _176 * 16.0f;
  float _181 = _148 + _139;
  float _182 = _181 + _157;
  float _183 = _182 + _165;
  float _184 = _183 * 0.5f;
  float _185 = _147 + _138;
  float _186 = _185 + _156;
  float _187 = _186 + _164;
  float _188 = _187 + _184;
  float _189 = _188 * 4.0f;
  float _190 = _180 - _189;
  float _191 = _190 * _179;
  bool _192 = (_191 > 0.0f);
  bool _193 = (_191 < 0.0f);
  int _194 = (int)(uint)(_192);
  int _195 = (int)(uint)(_193);
  int _196 = _194 - _195;
  float _197 = float((int)(_196));
  float _198 = abs(_191);
  float _199 = _198 + -0.10000000149011612f;
  float _200 = _199 * 3.846153497695923f;
  float _201 = saturate(_200);
  float _202 = _201 * 2.0f;
  float _203 = 3.0f - _202;
  float _204 = 1.0f - _198;
  float _205 = _204 * 1.5625f;
  float _206 = saturate(_205);
  float _207 = _206 * 2.0f;
  float _208 = 3.0f - _207;
  float _209 = _201 * _206;
  float _210 = _209 * _209;
  float _211 = _208 * _203;
  float _212 = _211 * _210;
  float _213 = _212 * _197;
  float _214 = _213 / _179;
  float _215 = _214 * cb0_000z;
  float _216 = _173 + _215;
  float _217 = _166.y + _215;
  float _218 = _216 - _172;
  float _219 = _218 + _171;
  float _220 = max(_219, 0.0f);
  float _221 = max(_217, 0.0f);
  float _222 = max(_218, 0.0f);
  float _223 = max(_166.w, 0.0f);
  float _224 = max(9.999999747378752e-06f, _223);
  float _225 = max(9.999999747378752e-06f, _27.w);
  float _226 = 1.0f / _225;
  float _227 = _226 * _224;
  float _228 = saturate(_227);
  float _229 = saturate(_228);
  float _230 = _229 * 2.0f;
  float _231 = 3.0f - _230;
  float _232 = _229 * _229;
  float _233 = _232 * _231;
  float _234 = _220 - _27.x;
  float _235 = _221 - _27.y;
  float _236 = _222 - _27.z;
  float _237 = _223 - _27.w;
  float _238 = _233 * _234;
  float _239 = _233 * _235;
  float _240 = _233 * _236;
  float _241 = _233 * _237;
  float _242 = _238 + _27.x;
  float _243 = _239 + _27.y;
  float _244 = _240 + _27.z;
  float _245 = _241 + _27.w;
  bool _247 = (cb0_000x > 0.0f);
  [branch] if (_247) {
    float _249 = 1.0f - _233;
    float4 _250 = t18.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float _255 = cb0_000x * _250.w;
    float _256 = _255 + -0.5f;
    float _257 = _256 * 2.0f;
    float _258 = saturate(_257);
    float _259 = _258 * 2.0f;
    float _260 = 3.0f - _259;
    float _261 = _258 * _258;
    float _262 = _261 * _260;
    float _263 = max(_249, _262);
    float _264 = _250.x - _242;
    float _265 = _250.y - _243;
    float _266 = _250.z - _244;
    float _267 = _263 * _264;
    float _268 = _263 * _265;
    float _269 = _263 * _266;
    float _270 = _267 + _242;
    float _271 = _268 + _243;
    float _272 = _269 + _244;
    _274 = _270;
    _275 = _271;
    _276 = _272;
  }
  else {
    _274 = _242;
    _275 = _243;
    _276 = _244;
  }
  float _277 = max(_274, 0.0f);
  float _278 = max(_275, 0.0f);
  float _279 = max(_276, 0.0f);
  float _280 = max(_245, 0.0f);
  float4 _281 = t16.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _285 = t19.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y)) * CUSTOM_LENS_DIRT;
  bool _291 = (cb0_005w == 0);
  float _293 = cb0_000y * _285.x;
  float _294 = cb0_000y * _285.y;
  float _295 = cb0_000y * _285.z;
  if (_291) {
    float _297 = _293 + 1.0f;
    float _298 = _294 + 1.0f;
    float _299 = _295 + 1.0f;
    float _300 = cb0_005y * 0.3333333432674408f;
    float _301 = _300 * _281.x;
    float _302 = _301 * _297;
    float _303 = _300 * _281.y;
    float _304 = _303 * _298;
    float _305 = _300 * _281.z;
    float _306 = _305 * _299;
    float _307 = _302 + _277;
    float _308 = _304 + _278;
    float _309 = _306 + _279;
    _334 = _307;
    _335 = _308;
    _336 = _309;
  } else {
    float _311 = _281.x * 0.3333333432674408f;
    float _312 = _281.y * 0.3333333432674408f;
    float _313 = _281.z * 0.3333333432674408f;
    float _316 = cb0_006x - cb0_005y;
    float _317 = _293 * _316;
    float _318 = _294 * _316;
    float _319 = _295 * _316;
    float _320 = _317 + cb0_005y;
    float _321 = _318 + cb0_005y;
    float _322 = _319 + cb0_005y;
    float _323 = 1.0f - cb0_005y;
    float _324 = _277 * _323;
    float _325 = _278 * _323;
    float _326 = _279 * _323;
    float _327 = _311 * _320;
    float _328 = _312 * _321;
    float _329 = _313 * _322;
    float _330 = _327 + _324;
    float _331 = _328 + _325;
    float _332 = _329 + _326;
    _334 = _330;
    _335 = _331;
    _336 = _332;
  }
  _334 = max(0.f, _277 + (_334 - _277) * CUSTOM_BLOOM);
  _335 = max(0.f, _278 + (_335 - _278) * CUSTOM_BLOOM);
  _336 = max(0.f, _279 + (_336 - _279) * CUSTOM_BLOOM);
  float _337 = _177.x * _334;
  float _338 = _177.x * _335;
  float _339 = _177.x * _336;
  float _340 = _337 * 0.6430370807647705f;
  float _341 = mad(0.31118518114089966f, _338, _340);
  float _342 = mad(0.04577704519033432f, _339, _341);
  float _343 = _337 * 0.059270311146974564f;
  float _344 = mad(0.9314354062080383f, _338, _343);
  float _345 = mad(0.009296739473938942f, _339, _344);
  float _346 = _337 * 0.0059599666856229305f;
  float _347 = mad(0.06392385065555573f, _338, _346);
  float _348 = mad(0.9301166534423828f, _339, _347);
  float _349 = log2(_342);
  float _350 = log2(_345);
  float _351 = log2(_348);
  float _352 = _349 + 9.720000267028809f;
  float _353 = _350 + 9.720000267028809f;
  float _354 = _351 + 9.720000267028809f;
  float _355 = _352 * 0.05707762390375137f;
  float _356 = _353 * 0.05707762390375137f;
  float _357 = _354 * 0.05707762390375137f;
  float _360 = dot(float3(_337, _338, _339), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _361 = max(_360, 1.000000013351432e-10f);
  float _362 = log2(_361);
  float _363 = _362 + 9.720000267028809f;
  float _364 = _363 * 0.05707762390375137f;
  bool _365 = (_364 < 0.0f);
  if (_365) {
    float _367 = -0.0f - _364;
    _373 = _367;
  } else {
    bool _369 = (_364 > 1.0f);
    if (_369) {
      float _371 = 1.0f - _364;
      _373 = _371;
    } else {
      _373 = 0.0f;
    }
  }
  float _374 = _373 + _355;
  float _375 = _373 + _356;
  float _376 = _373 + _357;
  float _377 = saturate(_374);
  float _378 = saturate(_375);
  float _379 = saturate(_376);
  uint3 _380;
  t17.GetDimensions(_380.x, _380.y, _380.z);
  uint _384 = _380.x + -1u;
  uint _385 = _380.y + -1u;
  uint _386 = _380.z + -1u;
  float _387 = float((uint)_384);
  float _388 = float((uint)_385);
  float _389 = float((uint)_386);
  float _390 = float((uint)_380.x);
  float _391 = float((uint)_380.y);
  float _392 = float((uint)_380.z);
  float _393 = _387 / _390;
  float _394 = _388 / _391;
  float _395 = _389 / _392;
  float _396 = 0.5f / _390;
  float _397 = 0.5f / _391;
  float _398 = 0.5f / _392;
  float _399 = _393 * _377;
  float _400 = _394 * _378;
  float _401 = _395 * _379;
  float _402 = _396 + _399;
  float _403 = _397 + _400;
  float _404 = _398 + _401;
  float4 _405 = t17.Sample(s0_space1, float3(_402, _403, _404));
  float _409 = -0.0f - _355;
  float _410 = _409 - _373;
  float _411 = _410 + _405.x;
  float _412 = -0.0f - _356;
  float _413 = _412 - _373;
  float _414 = _413 + _405.y;
  float _415 = -0.0f - _357;
  float _416 = _415 - _373;
  float _417 = _416 + _405.z;
  float _418 = _411 * (cb0_005z * CUSTOM_LUT_STRENGTH);
  float _419 = _414 * (cb0_005z * CUSTOM_LUT_STRENGTH);
  float _420 = _417 * (cb0_005z * CUSTOM_LUT_STRENGTH);
  float _421 = _418 + _355;
  float _422 = _419 + _356;
  float _423 = _420 + _357;
  float _426 = cb0_007x * 0.05707762390375137f;
  float _427 = _421 + _426;
  float _428 = _422 + _426;
  float _429 = _423 + _426;
  bool _432 = !(cb0_002x <= 0.0f);
  if (_432) {
    float _434 = TEXCOORD.x * 2.0f;
    float _435 = TEXCOORD.y * 2.0f;
    float _436 = _434 + -1.0f;
    float _437 = _435 + -1.0f;
    float _441 = _436 - cb0_003x;
    float _442 = _437 - cb0_003y;
    float _443 = abs(_441);
    float _444 = abs(_442);
    float _447 = cb0_003z * _443;
    float _448 = cb0_003w * _444;
    float _450 = 1.0f / cb0_002w;
    float _451 = log2(_447);
    float _452 = _451 * cb0_002w;
    float _453 = exp2(_452);
    float _454 = log2(_448);
    float _455 = _454 * cb0_002w;
    float _456 = exp2(_455);
    float _457 = _456 + _453;
    float _458 = log2(_457);
    float _459 = _458 * _450;
    float _460 = exp2(_459);
    float _462 = cb0_002y * _460;
    float _463 = saturate(_462);
    float _465 = log2(_463);
    float _466 = _465 * cb0_002z;
    float _467 = exp2(_466);
    float _468 = _467 * (cb0_002x * CUSTOM_VIGNETTE);
    float _473 = 1.0f - cb0_001x;
    float _474 = 1.0f - cb0_001y;
    float _475 = 1.0f - cb0_001z;
    float _476 = _473 * _468;
    float _477 = _474 * _468;
    float _478 = _475 * _468;
    float _479 = min(_476, 0.9999989867210388f);
    float _480 = min(_477, 0.9999989867210388f);
    float _481 = min(_478, 0.9999989867210388f);
    float _482 = 1.0f - _479;
    float _483 = 1.0f - _480;
    float _484 = 1.0f - _481;
    float _485 = log2(_482);
    float _486 = log2(_483);
    float _487 = log2(_484);
    float _488 = _485 * 0.05707762390375137f;
    float _489 = _486 * 0.05707762390375137f;
    float _490 = _487 * 0.05707762390375137f;
    float _491 = _488 + _427;
    float _492 = _489 + _428;
    float _493 = _490 + _429;
    _495 = _491;
    _496 = _492;
    _497 = _493;
  } else {
    _495 = _427;
    _496 = _428;
    _497 = _429;
  }
  [branch] if (SR_TONE_MAP_ACTIVE) {
    SV_Target = float4(ApplySaintsRowScene(float3(_495, _496, _497) * 17.52f - cb0_007x, float3(cb0_space5_008x, cb0_space5_008y, cb0_space5_008z)), cb0_space5_008w * _280);
#if SR_DEBUG_MEASURE
    SV_Target.rgb = DrawMeasureOverlay(SV_Target.rgb, SV_Position.xy, t21, s2_space1, cb0_005x, float4(cb0_004x, cb0_004y, cb0_004z, cb0_004w), cb0_006w, float2(cb0_006y, cb0_006z), cb0_007x);
#endif
    return SV_Target;
  }
  bool _500 = (cb0_005x == 3);
  float _501 = _495 * 17.520000457763672f;
  float _502 = _496 * 17.520000457763672f;
  float _503 = _497 * 17.520000457763672f;
  if (_500) {
    float _505 = _501 + -9.720000267028809f;
    float _506 = _502 + -9.720000267028809f;
    float _507 = _503 + -9.720000267028809f;
    float _508 = exp2(_505);
    float _509 = exp2(_506);
    float _510 = exp2(_507);
    float _511 = _508 * 0.3390841782093048f;
    float _512 = _509 * 0.3390841782093048f;
    float _513 = _510 * 0.3390841782093048f;
    _1337 = _511;
    _1338 = _512;
    _1339 = _513;
  } else {
    bool _515 = (cb0_005x == 2);
    if (_515) {
      float _517 = _501 + -9.720000267028809f;
      float _518 = _502 + -9.720000267028809f;
      float _519 = _503 + -9.720000267028809f;
      float _520 = exp2(_517);
      float _521 = exp2(_518);
      float _522 = exp2(_519);
      float _523 = _520 * 0.6954522132873535f;
      float _524 = mad(0.14067870378494263f, _521, _523);
      float _525 = mad(0.16386906802654266f, _522, _524);
      float _526 = _520 * 0.044794563204050064f;
      float _527 = mad(0.8596711158752441f, _521, _526);
      float _528 = mad(0.0955343171954155f, _522, _527);
      float _529 = _520 * -0.005525882821530104f;
      float _530 = mad(0.004025210160762072f, _521, _529);
      float _531 = mad(1.0015007257461548f, _522, _530);
      float _532 = max(_528, _531);
      float _533 = max(_525, _532);
      float _534 = max(_533, 1.000000013351432e-10f);
      float _535 = min(_528, _531);
      float _536 = min(_525, _535);
      float _537 = max(_536, 1.000000013351432e-10f);
      float _538 = _534 - _537;
      float _539 = max(_533, 0.009999999776482582f);
      float _540 = _538 / _539;
      float _541 = _531 - _528;
      float _542 = _541 * _531;
      float _543 = _528 - _525;
      float _544 = _543 * _528;
      float _545 = _542 + _544;
      float _546 = _525 - _531;
      float _547 = _546 * _525;
      float _548 = _545 + _547;
      float _549 = sqrt(_548);
      float _550 = _549 * 1.75f;
      float _551 = _528 + _525;
      float _552 = _551 + _531;
      float _553 = _552 + _550;
      float _554 = _553 * 0.3333333432674408f;
      float _555 = _540 + -0.4000000059604645f;
      float _556 = _555 * 5.0f;
      float _557 = _555 * 2.5f;
      float _558 = abs(_557);
      float _559 = 1.0f - _558;
      float _560 = max(_559, 0.0f);
      bool _561 = (_556 > 0.0f);
      bool _562 = (_556 < 0.0f);
      int _563 = (int)(uint)(_561);
      int _564 = (int)(uint)(_562);
      int _565 = _563 - _564;
      float _566 = float((int)(_565));
      float _567 = _560 * _560;
      float _568 = 1.0f - _567;
      float _569 = _566 * _568;
      float _570 = _569 + 1.0f;
      float _571 = _570 * 0.02500000037252903f;
      bool _572 = !(_554 <= 0.0533333346247673f);
      if (_572) {
        bool _574 = !(_554 >= 0.1599999964237213f);
        if (_574) {
          float _576 = 0.23999999463558197f / _553;
          float _577 = _576 + -0.5f;
          float _578 = _577 * _571;
          _580 = _578;
        } else {
          _580 = 0.0f;
        }
      } else {
        _580 = _571;
      }
      float _581 = _580 + 1.0f;
      float _582 = _581 * _525;
      float _583 = _581 * _528;
      float _584 = _581 * _531;
      bool _585 = (_582 == _583);
      bool _586 = (_583 == _584);
      bool _587 = _585 && _586;
      if (!_587) {
        float _589 = _582 * 2.0f;
        float _590 = _589 - _583;
        float _591 = _590 - _584;
        float _592 = _528 - _531;
        float _593 = _592 * 1.7320507764816284f;
        float _594 = _593 * _581;
        float _595 = _594 / _591;
        float _596 = atan(_595);
        float _597 = _596 + 3.1415927410125732f;
        float _598 = _596 + -3.1415927410125732f;
        bool _599 = (_591 < 0.0f);
        bool _600 = (_591 == 0.0f);
        bool _601 = (_594 >= 0.0f);
        bool _602 = (_594 < 0.0f);
        bool _603 = _601 && _599;
        float _604 = select(_603, _597, _596);
        bool _605 = _602 && _599;
        float _606 = select(_605, _598, _604);
        bool _607 = _602 && _600;
        bool _608 = _601 && _600;
        float _609 = _606 * 57.2957763671875f;
        float _610 = select(_607, -90.0f, _609);
        float _611 = select(_608, 90.0f, _610);
        _613 = _611;
      } else {
        _613 = 0.0f;
      }
      bool _614 = (_613 < 0.0f);
      float _615 = _613 + 360.0f;
      float _616 = select(_614, _615, _613);
      bool _617 = (_616 < -180.0f);
      if (_617) {
        float _619 = _616 + 360.0f;
        _625 = _619;
      } else {
        bool _621 = (_616 > 180.0f);
        if (_621) {
          float _623 = _616 + -360.0f;
          _625 = _623;
        } else {
          _625 = _616;
        }
      }
      bool _626 = (_625 > -67.5f);
      bool _627 = (_625 < 67.5f);
      bool _628 = _626 && _627;
      if (_628) {
        float _630 = _625 + 67.5f;
        float _631 = _630 * 0.029629629105329514f;
        int _632 = int(_631);
        float _633 = float((int)(_632));
        float _634 = _631 - _633;
        float _635 = _634 * _634;
        float _636 = _635 * _634;
        bool _637 = (_632 == 3);
        if (_637) {
          float _639 = _636 * 0.1666666716337204f;
          float _640 = _635 * 0.5f;
          float _641 = _634 * 0.5f;
          float _642 = 0.1666666716337204f - _641;
          float _643 = _642 + _640;
          float _644 = _643 - _639;
          _664 = _644;
        } else {
          bool _646 = (_632 == 2);
          if (_646) {
            float _648 = _636 * 0.5f;
            float _649 = 0.6666666865348816f - _635;
            float _650 = _649 + _648;
            _664 = _650;
          } else {
            bool _652 = (_632 == 1);
            if (_652) {
              float _654 = _636 * -0.5f;
              float _655 = _635 + _634;
              float _656 = _655 * 0.5f;
              float _657 = _654 + 0.1666666716337204f;
              float _658 = _657 + _656;
              _664 = _658;
            } else {
              bool _660 = (_632 == 0);
              float _661 = _636 * 0.1666666716337204f;
              float _662 = select(_660, _661, 0.0f);
              _664 = _662;
            }
          }
        }
      } else {
        _664 = 0.0f;
      }
      float _665 = 0.029999999329447746f - _582;
      float _666 = _540 * 0.27000001072883606f;
      float _667 = _666 * _665;
      float _668 = _667 * _664;
      float _669 = _668 + _582;
      float _670 = max(_669, 0.0f);
      float _671 = max(_583, 0.0f);
      float _672 = max(_584, 0.0f);
      float _673 = min(_670, 65536.0f);
      float _674 = min(_671, 65536.0f);
      float _675 = min(_672, 65536.0f);
      float _676 = _673 * 1.4514392614364624f;
      float _677 = mad(-0.2365107536315918f, _674, _676);
      float _678 = mad(-0.21492856740951538f, _675, _677);
      float _679 = _673 * -0.07655377686023712f;
      float _680 = mad(1.17622971534729f, _674, _679);
      float _681 = mad(-0.09967592358589172f, _675, _680);
      float _682 = _673 * 0.008316148072481155f;
      float _683 = mad(-0.006032449658960104f, _674, _682);
      float _684 = mad(0.9977163076400757f, _675, _683);
      float _685 = max(_678, 0.0f);
      float _686 = max(_681, 0.0f);
      float _687 = max(_684, 0.0f);
      float _688 = min(_685, 65504.0f);
      float _689 = min(_686, 65504.0f);
      float _690 = min(_687, 65504.0f);
      float _691 = _688 * 0.970889151096344f;
      float _692 = mad(0.026963284239172935f, _689, _691);
      float _693 = mad(0.0021475818939507008f, _690, _692);
      float _694 = _688 * 0.010889154858887196f;
      float _695 = mad(0.9869632720947266f, _689, _694);
      float _696 = mad(0.0021475818939507008f, _690, _695);
      float _697 = mad(0.026963284239172935f, _689, _694);
      float _698 = mad(0.9621475338935852f, _690, _697);
      bool _699 = (_693 <= 0.0f);
      float _700 = select(_699, 6.103515625e-05f, _693);
      float _701 = log2(_700);
      float _702 = _701 * 0.3010300099849701f;
      bool _703 = !(_702 <= -5.2601776123046875f);
      if (_703) {
        bool _705 = (_702 > -5.2601776123046875f);
        bool _706 = (_702 < -0.7447274923324585f);
        bool _707 = _705 && _706;
        if (_707) {
          float _709 = _701 * 0.19999998807907104f;
          float _710 = _709 + 3.494786262512207f;
          int _711 = int(_710);
          float _712 = float((int)(_711));
          float _713 = _710 - _712;
          float _715 = _global_0[_711];
          int _716 = _711 + 1;
          float _718 = _global_0[_716];
          int _719 = _711 + 2;
          float _721 = _global_0[_719];
          float _722 = _713 * _713;
          float _723 = _715 * 0.5f;
          float _724 = mad(_718, -1.0f, _723);
          float _725 = mad(_721, 0.5f, _724);
          float _726 = _718 - _715;
          float _727 = mad(_718, 0.5f, _723);
          float _728 = dot(float3(_722, _713, 1.0f), float3(_725, _726, _727));
          _755 = _728;
        } else {
          bool _730 = (_702 >= -0.7447274923324585f);
          bool _731 = (_702 < 4.673812389373779f);
          bool _732 = _730 && _731;
          if (_732) {
            float _734 = _701 * 0.1666666567325592f;
            float _735 = _734 + 0.4123218357563019f;
            int _736 = int(_735);
            float _737 = float((int)(_736));
            float _738 = _735 - _737;
            float _740 = _global_1[_736];
            int _741 = _736 + 1;
            float _743 = _global_1[_741];
            int _744 = _736 + 2;
            float _746 = _global_1[_744];
            float _747 = _738 * _738;
            float _748 = _740 * 0.5f;
            float _749 = mad(_743, -1.0f, _748);
            float _750 = mad(_746, 0.5f, _749);
            float _751 = _743 - _740;
            float _752 = mad(_743, 0.5f, _748);
            float _753 = dot(float3(_747, _738, 1.0f), float3(_750, _751, _752));
            _755 = _753;
          } else {
            _755 = 4.0f;
          }
        }
      } else {
        _755 = -4.0f;
      }
      float _756 = _755 * 3.321928024291992f;
      float _757 = exp2(_756);
      bool _758 = (_696 <= 0.0f);
      float _759 = select(_758, 6.103515625e-05f, _696);
      float _760 = log2(_759);
      float _761 = _760 * 0.3010300099849701f;
      bool _762 = !(_761 <= -5.2601776123046875f);
      if (_762) {
        bool _764 = (_761 > -5.2601776123046875f);
        bool _765 = (_761 < -0.7447274923324585f);
        bool _766 = _764 && _765;
        if (_766) {
          float _768 = _760 * 0.19999998807907104f;
          float _769 = _768 + 3.494786262512207f;
          int _770 = int(_769);
          float _771 = float((int)(_770));
          float _772 = _769 - _771;
          float _774 = _global_0[_770];
          int _775 = _770 + 1;
          float _777 = _global_0[_775];
          int _778 = _770 + 2;
          float _780 = _global_0[_778];
          float _781 = _772 * _772;
          float _782 = _774 * 0.5f;
          float _783 = mad(_777, -1.0f, _782);
          float _784 = mad(_780, 0.5f, _783);
          float _785 = _777 - _774;
          float _786 = mad(_777, 0.5f, _782);
          float _787 = dot(float3(_781, _772, 1.0f), float3(_784, _785, _786));
          _814 = _787;
        } else {
          bool _789 = (_761 >= -0.7447274923324585f);
          bool _790 = (_761 < 4.673812389373779f);
          bool _791 = _789 && _790;
          if (_791) {
            float _793 = _760 * 0.1666666567325592f;
            float _794 = _793 + 0.4123218357563019f;
            int _795 = int(_794);
            float _796 = float((int)(_795));
            float _797 = _794 - _796;
            float _799 = _global_1[_795];
            int _800 = _795 + 1;
            float _802 = _global_1[_800];
            int _803 = _795 + 2;
            float _805 = _global_1[_803];
            float _806 = _797 * _797;
            float _807 = _799 * 0.5f;
            float _808 = mad(_802, -1.0f, _807);
            float _809 = mad(_805, 0.5f, _808);
            float _810 = _802 - _799;
            float _811 = mad(_802, 0.5f, _807);
            float _812 = dot(float3(_806, _797, 1.0f), float3(_809, _810, _811));
            _814 = _812;
          } else {
            _814 = 4.0f;
          }
        }
      } else {
        _814 = -4.0f;
      }
      float _815 = _814 * 3.321928024291992f;
      float _816 = exp2(_815);
      bool _817 = (_698 <= 0.0f);
      float _818 = select(_817, 6.103515625e-05f, _698);
      float _819 = log2(_818);
      float _820 = _819 * 0.3010300099849701f;
      bool _821 = !(_820 <= -5.2601776123046875f);
      if (_821) {
        bool _823 = (_820 > -5.2601776123046875f);
        bool _824 = (_820 < -0.7447274923324585f);
        bool _825 = _823 && _824;
        if (_825) {
          float _827 = _819 * 0.19999998807907104f;
          float _828 = _827 + 3.494786262512207f;
          int _829 = int(_828);
          float _830 = float((int)(_829));
          float _831 = _828 - _830;
          float _833 = _global_0[_829];
          int _834 = _829 + 1;
          float _836 = _global_0[_834];
          int _837 = _829 + 2;
          float _839 = _global_0[_837];
          float _840 = _831 * _831;
          float _841 = _833 * 0.5f;
          float _842 = mad(_836, -1.0f, _841);
          float _843 = mad(_839, 0.5f, _842);
          float _844 = _836 - _833;
          float _845 = mad(_836, 0.5f, _841);
          float _846 = dot(float3(_840, _831, 1.0f), float3(_843, _844, _845));
          _873 = _846;
        } else {
          bool _848 = (_820 >= -0.7447274923324585f);
          bool _849 = (_820 < 4.673812389373779f);
          bool _850 = _848 && _849;
          if (_850) {
            float _852 = _819 * 0.1666666567325592f;
            float _853 = _852 + 0.4123218357563019f;
            int _854 = int(_853);
            float _855 = float((int)(_854));
            float _856 = _853 - _855;
            float _858 = _global_1[_854];
            int _859 = _854 + 1;
            float _861 = _global_1[_859];
            int _862 = _854 + 2;
            float _864 = _global_1[_862];
            float _865 = _856 * _856;
            float _866 = _858 * 0.5f;
            float _867 = mad(_861, -1.0f, _866);
            float _868 = mad(_864, 0.5f, _867);
            float _869 = _861 - _858;
            float _870 = mad(_861, 0.5f, _866);
            float _871 = dot(float3(_865, _856, 1.0f), float3(_868, _869, _870));
            _873 = _871;
          } else {
            _873 = 4.0f;
          }
        }
      } else {
        _873 = -4.0f;
      }
      float _874 = _873 * 3.321928024291992f;
      float _875 = exp2(_874);
      bool _876 = (_757 <= 0.0f);
      float _877 = select(_876, 9.999999747378752e-05f, _757);
      float _878 = log2(_877);
      float _879 = _878 * 0.3010300099849701f;
      bool _880 = !(_879 <= -2.540623664855957f);
      if (_880) {
        bool _882 = (_879 > -2.540623664855957f);
        bool _883 = (_879 < 0.6812411546707153f);
        bool _884 = _882 && _883;
        if (_884) {
          float _886 = _878 + 8.43976879119873f;
          float _887 = _886 * 0.6540343165397644f;
          int _888 = int(_887);
          float _889 = float((int)(_888));
          float _890 = _887 - _889;
          float _892 = _global_2[_888];
          int _893 = _888 + 1;
          float _895 = _global_2[_893];
          int _896 = _888 + 2;
          float _898 = _global_2[_896];
          float _899 = _890 * _890;
          float _900 = _892 * 0.5f;
          float _901 = mad(_895, -1.0f, _900);
          float _902 = mad(_898, 0.5f, _901);
          float _903 = _895 - _892;
          float _904 = mad(_895, 0.5f, _900);
          float _905 = dot(float3(_899, _890, 1.0f), float3(_902, _903, _904));
          _935 = _905;
        } else {
          bool _907 = (_879 >= 0.6812411546707153f);
          bool _908 = (_879 < 3.002476692199707f);
          bool _909 = _907 && _908;
          if (_909) {
            float _911 = _878 + -2.2630341053009033f;
            float _912 = _911 * 0.9077967405319214f;
            int _913 = int(_912);
            float _914 = float((int)(_913));
            float _915 = _912 - _914;
            float _917 = _global_3[_913];
            int _918 = _913 + 1;
            float _920 = _global_3[_918];
            int _921 = _913 + 2;
            float _923 = _global_3[_921];
            float _924 = _915 * _915;
            float _925 = _917 * 0.5f;
            float _926 = mad(_920, -1.0f, _925);
            float _927 = mad(_923, 0.5f, _926);
            float _928 = _920 - _917;
            float _929 = mad(_920, 0.5f, _925);
            float _930 = dot(float3(_924, _915, 1.0f), float3(_927, _928, _929));
            _935 = _930;
          } else {
            float _932 = _878 * 0.012041199952363968f;
            float _933 = _932 + 1.5611422061920166f;
            _935 = _933;
          }
        }
      } else {
        _935 = -1.698970079421997f;
      }
      float _936 = _935 * 3.321928024291992f;
      float _937 = exp2(_936);
      bool _938 = (_816 <= 0.0f);
      float _939 = select(_938, 9.999999747378752e-05f, _816);
      float _940 = log2(_939);
      float _941 = _940 * 0.3010300099849701f;
      bool _942 = !(_941 <= -2.540623664855957f);
      if (_942) {
        bool _944 = (_941 > -2.540623664855957f);
        bool _945 = (_941 < 0.6812411546707153f);
        bool _946 = _944 && _945;
        if (_946) {
          float _948 = _940 + 8.43976879119873f;
          float _949 = _948 * 0.6540343165397644f;
          int _950 = int(_949);
          float _951 = float((int)(_950));
          float _952 = _949 - _951;
          float _954 = _global_2[_950];
          int _955 = _950 + 1;
          float _957 = _global_2[_955];
          int _958 = _950 + 2;
          float _960 = _global_2[_958];
          float _961 = _952 * _952;
          float _962 = _954 * 0.5f;
          float _963 = mad(_957, -1.0f, _962);
          float _964 = mad(_960, 0.5f, _963);
          float _965 = _957 - _954;
          float _966 = mad(_957, 0.5f, _962);
          float _967 = dot(float3(_961, _952, 1.0f), float3(_964, _965, _966));
          _997 = _967;
        } else {
          bool _969 = (_941 >= 0.6812411546707153f);
          bool _970 = (_941 < 3.002476692199707f);
          bool _971 = _969 && _970;
          if (_971) {
            float _973 = _940 + -2.2630341053009033f;
            float _974 = _973 * 0.9077967405319214f;
            int _975 = int(_974);
            float _976 = float((int)(_975));
            float _977 = _974 - _976;
            float _979 = _global_3[_975];
            int _980 = _975 + 1;
            float _982 = _global_3[_980];
            int _983 = _975 + 2;
            float _985 = _global_3[_983];
            float _986 = _977 * _977;
            float _987 = _979 * 0.5f;
            float _988 = mad(_982, -1.0f, _987);
            float _989 = mad(_985, 0.5f, _988);
            float _990 = _982 - _979;
            float _991 = mad(_982, 0.5f, _987);
            float _992 = dot(float3(_986, _977, 1.0f), float3(_989, _990, _991));
            _997 = _992;
          } else {
            float _994 = _940 * 0.012041199952363968f;
            float _995 = _994 + 1.5611422061920166f;
            _997 = _995;
          }
        }
      } else {
        _997 = -1.698970079421997f;
      }
      float _998 = _997 * 3.321928024291992f;
      float _999 = exp2(_998);
      bool _1000 = (_875 <= 0.0f);
      float _1001 = select(_1000, 9.999999747378752e-05f, _875);
      float _1002 = log2(_1001);
      float _1003 = _1002 * 0.3010300099849701f;
      bool _1004 = !(_1003 <= -2.540623664855957f);
      if (_1004) {
        bool _1006 = (_1003 > -2.540623664855957f);
        bool _1007 = (_1003 < 0.6812411546707153f);
        bool _1008 = _1006 && _1007;
        if (_1008) {
          float _1010 = _1002 + 8.43976879119873f;
          float _1011 = _1010 * 0.6540343165397644f;
          int _1012 = int(_1011);
          float _1013 = float((int)(_1012));
          float _1014 = _1011 - _1013;
          float _1016 = _global_2[_1012];
          int _1017 = _1012 + 1;
          float _1019 = _global_2[_1017];
          int _1020 = _1012 + 2;
          float _1022 = _global_2[_1020];
          float _1023 = _1014 * _1014;
          float _1024 = _1016 * 0.5f;
          float _1025 = mad(_1019, -1.0f, _1024);
          float _1026 = mad(_1022, 0.5f, _1025);
          float _1027 = _1019 - _1016;
          float _1028 = mad(_1019, 0.5f, _1024);
          float _1029 = dot(float3(_1023, _1014, 1.0f), float3(_1026, _1027, _1028));
          _1059 = _1029;
        } else {
          bool _1031 = (_1003 >= 0.6812411546707153f);
          bool _1032 = (_1003 < 3.002476692199707f);
          bool _1033 = _1031 && _1032;
          if (_1033) {
            float _1035 = _1002 + -2.2630341053009033f;
            float _1036 = _1035 * 0.9077967405319214f;
            int _1037 = int(_1036);
            float _1038 = float((int)(_1037));
            float _1039 = _1036 - _1038;
            float _1041 = _global_3[_1037];
            int _1042 = _1037 + 1;
            float _1044 = _global_3[_1042];
            int _1045 = _1037 + 2;
            float _1047 = _global_3[_1045];
            float _1048 = _1039 * _1039;
            float _1049 = _1041 * 0.5f;
            float _1050 = mad(_1044, -1.0f, _1049);
            float _1051 = mad(_1047, 0.5f, _1050);
            float _1052 = _1044 - _1041;
            float _1053 = mad(_1044, 0.5f, _1049);
            float _1054 = dot(float3(_1048, _1039, 1.0f), float3(_1051, _1052, _1053));
            _1059 = _1054;
          } else {
            float _1056 = _1002 * 0.012041199952363968f;
            float _1057 = _1056 + 1.5611422061920166f;
            _1059 = _1057;
          }
        }
      } else {
        _1059 = -1.698970079421997f;
      }
      float _1060 = _1059 * 3.321928024291992f;
      float _1061 = exp2(_1060);
      float _1062 = _937 + -0.020000001415610313f;
      float _1063 = _999 + -0.020000001415610313f;
      float _1064 = _1063 * 0.020842017605900764f;
      float _1065 = _1061 + -0.020000001415610313f;
      float _1066 = _1065 * 0.020842017605900764f;
      float _1067 = _1062 * 0.013806881383061409f;
      float _1068 = mad(0.13400420546531677f, _1064, _1067);
      float _1069 = mad(0.15618768334388733f, _1066, _1068);
      float _1070 = _1062 * 0.005673795938491821f;
      float _1071 = mad(0.6740817427635193f, _1064, _1070);
      float _1072 = mad(0.053689517080783844f, _1066, _1071);
      float _1073 = _1062 * -0.00011618694406934083f;
      float _1074 = mad(0.00406073359772563f, _1064, _1073);
      float _1075 = mad(1.0103391408920288f, _1066, _1074);
      float _1076 = _1072 + _1069;
      float _1077 = _1076 + _1075;
      bool _1078 = (_1077 == 0.0f);
      float _1079 = select(_1078, 1.000000013351432e-10f, _1077);
      float _1080 = _1069 / _1079;
      float _1081 = _1072 / _1079;
      float _1082 = max(_1072, 0.0f);
      float _1083 = log2(_1082);
      float _1084 = _1083 * 0.9811000227928162f;
      float _1085 = exp2(_1084);
      float _1086 = _1085 * _1080;
      float _1087 = max(_1081, 1.000000013351432e-10f);
      float _1088 = _1086 / _1087;
      float _1089 = 1.0f - _1080;
      float _1090 = _1089 - _1081;
      float _1091 = _1085 * _1090;
      float _1092 = _1091 / _1087;
      float _1093 = _1088 * 1.6410233974456787f;
      float _1094 = mad(-0.32480329275131226f, _1085, _1093);
      float _1095 = mad(-0.23642469942569733f, _1092, _1094);
      float _1096 = _1088 * -0.663662850856781f;
      float _1097 = mad(1.6153316497802734f, _1085, _1096);
      float _1098 = mad(0.016756348311901093f, _1092, _1097);
      float _1099 = _1088 * 0.011721894145011902f;
      float _1100 = mad(-0.008284442126750946f, _1085, _1099);
      float _1101 = mad(0.9883948564529419f, _1092, _1100);
      float _1102 = _1095 * 0.9490560293197632f;
      float _1103 = mad(0.04718571901321411f, _1098, _1102);
      float _1104 = mad(0.003758265869691968f, _1101, _1103);
      float _1105 = _1095 * 0.019056009128689766f;
      float _1106 = mad(0.9771857261657715f, _1098, _1105);
      float _1107 = mad(0.003758265869691968f, _1101, _1106);
      float _1108 = mad(0.04718571901321411f, _1098, _1105);
      float _1109 = mad(0.9337582588195801f, _1101, _1108);
      float _1110 = _1104 * 0.6624541878700256f;
      float _1111 = mad(0.13400420546531677f, _1107, _1110);
      float _1112 = mad(0.15618768334388733f, _1109, _1111);
      float _1113 = _1104 * 0.2722287178039551f;
      float _1114 = mad(0.6740817427635193f, _1107, _1113);
      float _1115 = mad(0.053689517080783844f, _1109, _1114);
      float _1116 = _1104 * -0.005574649665504694f;
      float _1117 = mad(0.00406073359772563f, _1107, _1116);
      float _1118 = mad(1.0103391408920288f, _1109, _1117);
      float _1119 = _1112 * 0.9872239828109741f;
      float _1120 = mad(-0.006113269831985235f, _1115, _1119);
      float _1121 = mad(0.015953300520777702f, _1118, _1120);
      float _1122 = _1112 * -0.007598360069096088f;
      float _1123 = mad(1.0018600225448608f, _1115, _1122);
      float _1124 = mad(0.005330020096153021f, _1118, _1123);
      float _1125 = _1112 * 0.003072570078074932f;
      float _1126 = mad(-0.005095949862152338f, _1115, _1125);
      float _1127 = mad(1.0816800594329834f, _1118, _1126);
      float _1128 = _1121 * 3.2409698963165283f;
      float _1129 = mad(-1.5373831987380981f, _1124, _1128);
      float _1130 = mad(-0.4986107647418976f, _1127, _1129);
      float _1131 = _1121 * -0.9692436456680298f;
      float _1132 = mad(1.8759675025939941f, _1124, _1131);
      float _1133 = mad(0.04155505821108818f, _1127, _1132);
      float _1134 = _1121 * 0.05563008040189743f;
      float _1135 = mad(-0.20397695899009705f, _1124, _1134);
      float _1136 = mad(1.056971549987793f, _1127, _1135);
      float _1137 = saturate(_1130);
      float _1138 = saturate(_1133);
      float _1139 = saturate(_1136);
      _1337 = _1137;
      _1338 = _1138;
      _1339 = _1139;
    } else {
      bool _1141 = (cb0_005x == 1);
      if (_1141) {
        float _1147 = _495 * 0.5309091210365295f;
        float _1148 = _496 * 0.5309091210365295f;
        float _1149 = _497 * 0.5309091210365295f;
        float _1150 = _1147 + 0.23496760427951813f;
        float _1151 = _1148 + 0.23496760427951813f;
        float _1152 = _1149 + 0.23496760427951813f;
        uint3 _1153;
        t20.GetDimensions(_1153.x, _1153.y, _1153.z);
        uint2 _1157;
        t21.GetDimensions(_1157.x, _1157.y);
        uint _1159 = _1153.x + -1u;
        uint _1160 = _1153.y + -1u;
        uint _1161 = _1153.z + -1u;
        float _1162 = float((uint)_1159);
        float _1163 = float((uint)_1160);
        float _1164 = float((uint)_1161);
        float _1165 = float((uint)_1153.x);
        float _1166 = float((uint)_1153.y);
        float _1167 = float((uint)_1153.z);
        float _1168 = _1162 / _1165;
        float _1169 = _1163 / _1166;
        float _1170 = _1164 / _1167;
        float _1171 = 0.5f / _1165;
        float _1172 = 0.5f / _1166;
        float _1173 = 0.5f / _1167;
        float _1174 = _1168 * _1150;
        float _1175 = _1169 * _1151;
        float _1176 = _1170 * _1152;
        float _1177 = _1171 + _1174;
        float _1178 = _1172 + _1175;
        float _1179 = _1173 + _1176;
        float4 _1180 = t20.SampleLevel(s2_space1, float3(_1177, _1178, _1179), 0.0f);
        float _1183 = _501 + -9.719999313354492f;
        float _1184 = _502 + -9.719999313354492f;
        float _1185 = _503 + -9.719999313354492f;
        float _1186 = exp2(_1183);
        float _1187 = exp2(_1184);
        float _1188 = exp2(_1185);
        float _1189 = _1186 * 0.6954522132873535f;
        float _1190 = mad(0.14067870378494263f, _1187, _1189);
        float _1191 = mad(0.16386906802654266f, _1188, _1190);
        float _1192 = _1186 * 0.044794563204050064f;
        float _1193 = mad(0.8596711158752441f, _1187, _1192);
        float _1194 = mad(0.0955343171954155f, _1188, _1193);
        float _1195 = _1186 * -0.005525882821530104f;
        float _1196 = mad(0.004025210160762072f, _1187, _1195);
        float _1197 = mad(1.0015007257461548f, _1188, _1196);
        float _1198 = _1180.x + 1.0f;
        float _1199 = _1191 * _1198;
        float _1200 = _1194 * _1198;
        float _1201 = _1197 * _1198;
        float _1202 = _1199 + _1180.y;
        float _1203 = max(_1202, 0.0f);
        float _1204 = max(_1200, 0.0f);
        float _1205 = max(_1201, 0.0f);
        float _1206 = min(_1203, 65536.0f);
        float _1207 = min(_1204, 65536.0f);
        float _1208 = min(_1205, 65536.0f);
        float _1209 = _1206 * 1.4514392614364624f;
        float _1210 = mad(-0.2365107536315918f, _1207, _1209);
        float _1211 = mad(-0.21492856740951538f, _1208, _1210);
        float _1212 = _1206 * -0.07655377686023712f;
        float _1213 = mad(1.17622971534729f, _1207, _1212);
        float _1214 = mad(-0.09967592358589172f, _1208, _1213);
        float _1215 = _1206 * 0.008316148072481155f;
        float _1216 = mad(-0.006032449658960104f, _1207, _1215);
        float _1217 = mad(0.9977163076400757f, _1208, _1216);
        float _1218 = max(_1211, 0.0f);
        float _1219 = max(_1214, 0.0f);
        float _1220 = max(_1217, 0.0f);
        float _1221 = min(_1218, 65504.0f);
        float _1222 = min(_1219, 65504.0f);
        float _1223 = min(_1220, 65504.0f);
        float _1224 = _1221 * 0.970889151096344f;
        float _1225 = mad(0.026963284239172935f, _1222, _1224);
        float _1226 = mad(0.0021475818939507008f, _1223, _1225);
        float _1227 = _1221 * 0.010889154858887196f;
        float _1228 = mad(0.9869632720947266f, _1222, _1227);
        float _1229 = mad(0.0021475818939507008f, _1223, _1228);
        float _1230 = mad(0.026963284239172935f, _1222, _1227);
        float _1231 = mad(0.9621475338935852f, _1223, _1230);
        float _1232 = log2(_1226);
        float _1233 = log2(_1229);
        float _1234 = log2(_1231);
        float _1235 = _1232 + 17.47393035888672f;
        float _1236 = _1233 + 17.47393035888672f;
        float _1237 = _1234 + 17.47393035888672f;
        float _1238 = _1235 * 0.03030303120613098f;
        float _1239 = _1236 * 0.03030303120613098f;
        float _1240 = _1237 * 0.03030303120613098f;
        uint _1241 = _1157.x + -1u;
        float _1242 = float((uint)_1241);
        float _1243 = float((uint)_1157.x);
        float _1244 = _1242 / _1243;
        float _1245 = 0.5f / _1243;
        float _1246 = _1238 * _1244;
        float _1247 = _1239 * _1244;
        float _1248 = _1240 * _1244;
        float _1249 = _1246 + _1245;
        float _1250 = _1247 + _1245;
        float _1251 = _1248 + _1245;
        float4 _1252 = t21.SampleLevel(s2_space1, float2(_1249, 0.5f), 0.0f);
        float4 _1254 = t21.SampleLevel(s2_space1, float2(_1250, 0.5f), 0.0f);
        float4 _1256 = t21.SampleLevel(s2_space1, float2(_1251, 0.5f), 0.0f);
        float _1258 = _1252.x * 3.321928024291992f;
        float _1259 = _1254.x * 3.321928024291992f;
        float _1260 = _1256.x * 3.321928024291992f;
        float _1261 = exp2(_1258);
        float _1262 = exp2(_1259);
        float _1263 = exp2(_1260);
        float _1264 = _1261 / cb0_006w;
        float _1265 = _1262 / cb0_006w;
        float _1266 = _1263 / cb0_006w;
        bool _1267 = (cb0_004w < 500.0f);
        if (_1267) {
          float _1269 = _1264 * 0.6624541878700256f;
          float _1270 = mad(0.13400420546531677f, _1265, _1269);
          float _1271 = mad(0.15618768334388733f, _1266, _1270);
          float _1272 = _1264 * 0.2722287178039551f;
          float _1273 = mad(0.6740817427635193f, _1265, _1272);
          float _1274 = mad(0.053689517080783844f, _1266, _1273);
          float _1275 = _1264 * -0.005574649665504694f;
          float _1276 = mad(0.00406073359772563f, _1265, _1275);
          float _1277 = mad(1.0103391408920288f, _1266, _1276);
          float _1278 = _1274 + _1271;
          float _1279 = _1278 + _1277;
          bool _1280 = (_1279 == 0.0f);
          float _1281 = select(_1280, 1.000000013351432e-10f, _1279);
          float _1282 = _1271 / _1281;
          float _1283 = _1274 / _1281;
          float _1284 = max(_1274, 0.0f);
          float _1285 = log2(_1284);
          float _1286 = _1285 * 0.9811000227928162f;
          float _1287 = exp2(_1286);
          float _1288 = _1287 * _1282;
          float _1289 = max(_1283, 1.000000013351432e-10f);
          float _1290 = _1288 / _1289;
          float _1291 = 1.0f - _1282;
          float _1292 = _1291 - _1283;
          float _1293 = _1287 * _1292;
          float _1294 = _1293 / _1289;
          float _1295 = _1290 * 1.6410233974456787f;
          float _1296 = mad(-0.32480329275131226f, _1287, _1295);
          float _1297 = mad(-0.23642469942569733f, _1294, _1296);
          float _1298 = _1290 * -0.663662850856781f;
          float _1299 = mad(1.6153316497802734f, _1287, _1298);
          float _1300 = mad(0.016756348311901093f, _1294, _1299);
          float _1301 = _1290 * 0.011721894145011902f;
          float _1302 = mad(-0.008284442126750946f, _1287, _1301);
          float _1303 = mad(0.9883948564529419f, _1294, _1302);
          _1305 = _1297;
          _1306 = _1300;
          _1307 = _1303;
        } else {
          _1305 = _1264;
          _1306 = _1265;
          _1307 = _1266;
        }
        float _1308 = _1305 * 1.6047539710998535f;
        float _1309 = mad(-0.5310794711112976f, _1306, _1308);
        float _1310 = mad(-0.07367203384637833f, _1307, _1309);
        float _1311 = _1305 * -0.10208318382501602f;
        float _1312 = mad(1.108132243156433f, _1306, _1311);
        float _1313 = mad(-0.006051875650882721f, _1307, _1312);
        float _1314 = _1305 * -0.0032670421060174704f;
        float _1315 = mad(-0.07275524735450745f, _1306, _1314);
        float _1316 = mad(1.0760219097137451f, _1307, _1315);
        float _1317 = max(_1310, 0.0f);
        float _1318 = max(_1313, 0.0f);
        float _1319 = max(_1316, 0.0f);
        _1337 = _1317;
        _1338 = _1318;
        _1339 = _1319;
      } else {
        float _1321 = _501 + -9.720000267028809f;
        float _1322 = _502 + -9.720000267028809f;
        float _1323 = _503 + -9.720000267028809f;
        float _1324 = exp2(_1321);
        float _1325 = exp2(_1322);
        float _1326 = exp2(_1323);
        float _1327 = _1324 * 1.6047539710998535f;
        float _1328 = mad(-0.5310794711112976f, _1325, _1327);
        float _1329 = mad(-0.07367203384637833f, _1326, _1328);
        float _1330 = _1324 * -0.10208318382501602f;
        float _1331 = mad(1.108132243156433f, _1325, _1330);
        float _1332 = mad(-0.006051875650882721f, _1326, _1331);
        float _1333 = _1324 * -0.0032670421060174704f;
        float _1334 = mad(-0.07275524735450745f, _1325, _1333);
        float _1335 = mad(1.0760219097137451f, _1326, _1334);
        _1337 = _1329;
        _1338 = _1332;
        _1339 = _1335;
      }
    }
  }
  float _1345 = cb0_space5_008x * _1337;
  float _1346 = cb0_space5_008y * _1338;
  float _1347 = cb0_space5_008z * _1339;
  float _1348 = cb0_space5_008w * _280;
  bool _1349 = (_1345 < 0.0031308000907301903f);
  bool _1350 = (_1346 < 0.0031308000907301903f);
  bool _1351 = (_1347 < 0.0031308000907301903f);
  float _1352 = _1345 * 12.920000076293945f;
  float _1353 = _1346 * 12.920000076293945f;
  float _1354 = _1347 * 12.920000076293945f;
  float _1355 = abs(_1345);
  float _1356 = abs(_1346);
  float _1357 = abs(_1347);
  float _1358 = log2(_1355);
  float _1359 = log2(_1356);
  float _1360 = log2(_1357);
  float _1361 = _1358 * 0.4166666567325592f;
  float _1362 = _1359 * 0.4166666567325592f;
  float _1363 = _1360 * 0.4166666567325592f;
  float _1364 = exp2(_1361);
  float _1365 = exp2(_1362);
  float _1366 = exp2(_1363);
  float _1367 = _1364 * 1.0549999475479126f;
  float _1368 = _1365 * 1.0549999475479126f;
  float _1369 = _1366 * 1.0549999475479126f;
  float _1370 = _1367 + -0.054999999701976776f;
  float _1371 = _1368 + -0.054999999701976776f;
  float _1372 = _1369 + -0.054999999701976776f;
  float _1373 = select(_1349, _1352, _1370);
  float _1374 = select(_1350, _1353, _1371);
  float _1375 = select(_1351, _1354, _1372);
  bool _1379 = !(cb0_006y == 0.0f);
  bool _1380 = !(cb0_006z == 0.0f);
  bool _1381 = _1379 || _1380;
  if (_1381) {
    float _1383 = cb0_006z - cb0_006y;
    float _1384 = _1383 * _1373;
    float _1385 = _1383 * _1374;
    float _1386 = _1383 * _1375;
    float _1387 = _1384 + cb0_006y;
    float _1388 = _1385 + cb0_006y;
    float _1389 = _1386 + cb0_006y;
    _1391 = _1387;
    _1392 = _1388;
    _1393 = _1389;
  } else {
    _1391 = _1373;
    _1392 = _1374;
    _1393 = _1375;
  }
  SV_Target.x = _1391;
  SV_Target.y = _1392;
  SV_Target.z = _1393;
  SV_Target.w = _1348;
#if SR_DEBUG_MEASURE
  SV_Target.rgb = DrawMeasureOverlay(SV_Target.rgb, SV_Position.xy, t21, s2_space1, cb0_005x, float4(cb0_004x, cb0_004y, cb0_004z, cb0_004w), cb0_006w, float2(cb0_006y, cb0_006z), cb0_007x);
#endif
  return SV_Target;
}

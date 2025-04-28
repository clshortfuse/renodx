#include "../../common.hlsli"
struct SExposureData {
  float SExposureData_000;
  float SExposureData_004;
  float SExposureData_008;
  float SExposureData_012;
  float SExposureData_016;
  float SExposureData_020;
};

StructuredBuffer<SExposureData> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t9 : register(t9);

Texture3D<float2> t10 : register(t10);

Texture2D<float4> t11 : register(t11);

cbuffer cb0 : register(b0) {
  float cb0_028x : packoffset(c028.x);
  float cb0_028z : packoffset(c028.z);
};

cbuffer cb1 : register(b1) {
  float cb1_018y : packoffset(c018.y);
  float cb1_018z : packoffset(c018.z);
  uint cb1_018w : packoffset(c018.w);
};

cbuffer cb2 : register(b2) {
  float cb2_000x : packoffset(c000.x);
  float cb2_000y : packoffset(c000.y);
  float cb2_000z : packoffset(c000.z);
  float cb2_001x : packoffset(c001.x);
  float cb2_001y : packoffset(c001.y);
  float cb2_001z : packoffset(c001.z);
  float cb2_002x : packoffset(c002.x);
  float cb2_002y : packoffset(c002.y);
  float cb2_002z : packoffset(c002.z);
  float cb2_002w : packoffset(c002.w);
  float cb2_003x : packoffset(c003.x);
  float cb2_003y : packoffset(c003.y);
  float cb2_003z : packoffset(c003.z);
  float cb2_003w : packoffset(c003.w);
  float cb2_004x : packoffset(c004.x);
  float cb2_004y : packoffset(c004.y);
  float cb2_004z : packoffset(c004.z);
  float cb2_004w : packoffset(c004.w);
  float cb2_005x : packoffset(c005.x);
  float cb2_006x : packoffset(c006.x);
  float cb2_006y : packoffset(c006.y);
  float cb2_006z : packoffset(c006.z);
  float cb2_006w : packoffset(c006.w);
  float cb2_007x : packoffset(c007.x);
  float cb2_007y : packoffset(c007.y);
  float cb2_007z : packoffset(c007.z);
  float cb2_007w : packoffset(c007.w);
  float cb2_008x : packoffset(c008.x);
  float cb2_008y : packoffset(c008.y);
  float cb2_008z : packoffset(c008.z);
  float cb2_008w : packoffset(c008.w);
  float cb2_015x : packoffset(c015.x);
  float cb2_015y : packoffset(c015.y);
  float cb2_015z : packoffset(c015.z);
  float cb2_015w : packoffset(c015.w);
  float cb2_016x : packoffset(c016.x);
  float cb2_016y : packoffset(c016.y);
  float cb2_016z : packoffset(c016.z);
  float cb2_016w : packoffset(c016.w);
  float cb2_017x : packoffset(c017.x);
  float cb2_017y : packoffset(c017.y);
  float cb2_017z : packoffset(c017.z);
  float cb2_017w : packoffset(c017.w);
  float cb2_018x : packoffset(c018.x);
  float cb2_018y : packoffset(c018.y);
  uint cb2_019x : packoffset(c019.x);
  uint cb2_019y : packoffset(c019.y);
  uint cb2_019z : packoffset(c019.z);
  uint cb2_019w : packoffset(c019.w);
  float cb2_020x : packoffset(c020.x);
  float cb2_020y : packoffset(c020.y);
  float cb2_020z : packoffset(c020.z);
  float cb2_020w : packoffset(c020.w);
  float cb2_021x : packoffset(c021.x);
  float cb2_021y : packoffset(c021.y);
  float cb2_021z : packoffset(c021.z);
  float cb2_021w : packoffset(c021.w);
  float cb2_022x : packoffset(c022.x);
  float cb2_023x : packoffset(c023.x);
  float cb2_023y : packoffset(c023.y);
  float cb2_023z : packoffset(c023.z);
  float cb2_023w : packoffset(c023.w);
  float cb2_024x : packoffset(c024.x);
  float cb2_024y : packoffset(c024.y);
  float cb2_024z : packoffset(c024.z);
  float cb2_024w : packoffset(c024.w);
  float cb2_025x : packoffset(c025.x);
  float cb2_025y : packoffset(c025.y);
  float cb2_025z : packoffset(c025.z);
  float cb2_025w : packoffset(c025.w);
  float cb2_026x : packoffset(c026.x);
  float cb2_026y : packoffset(c026.y);
  float cb2_026z : packoffset(c026.z);
  float cb2_026w : packoffset(c026.w);
  float cb2_027x : packoffset(c027.x);
  float cb2_027y : packoffset(c027.y);
  float cb2_027z : packoffset(c027.z);
  float cb2_027w : packoffset(c027.w);
  uint cb2_028x : packoffset(c028.x);
  uint cb2_069y : packoffset(c069.y);
};

SamplerState s0_space2 : register(s0, space2);

SamplerState s2_space2 : register(s2, space2);

SamplerState s4_space2 : register(s4, space2);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
  linear float2 TEXCOORD0_centroid : TEXCOORD0_centroid,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float _26 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _31 = cb2_015x * TEXCOORD0_centroid.x;
  float _32 = cb2_015y * TEXCOORD0_centroid.y;
  float _35 = _31 + cb2_015z;
  float _36 = _32 + cb2_015w;
  float4 _37 = t9.SampleLevel(s0_space2, float2(_35, _36), 0.0f);
  float _41 = saturate(_37.x);
  float _42 = saturate(_37.z);
  float _45 = cb2_026x * _42;
  float _46 = _41 * 6.283199787139893f;
  float _47 = cos(_46);
  float _48 = sin(_46);
  float _49 = _45 * _47;
  float _50 = _48 * _45;
  float _51 = 1.0f - _37.y;
  float _52 = saturate(_51);
  float _53 = _49 * _52;
  float _54 = _50 * _52;
  float _55 = _53 + TEXCOORD0_centroid.x;
  float _56 = _54 + TEXCOORD0_centroid.y;
  float4 _57 = t1.SampleLevel(s4_space2, float2(_55, _56), 0.0f);
  float _61 = max(_57.x, 0.0f);
  float _62 = max(_57.y, 0.0f);
  float _63 = max(_57.z, 0.0f);
  float _64 = min(_61, 65000.0f);
  float _65 = min(_62, 65000.0f);
  float _66 = min(_63, 65000.0f);
  float4 _67 = t4.SampleLevel(s2_space2, float2(_55, _56), 0.0f);
  float _72 = max(_67.x, 0.0f);
  float _73 = max(_67.y, 0.0f);
  float _74 = max(_67.z, 0.0f);
  float _75 = max(_67.w, 0.0f);
  float _76 = min(_72, 5000.0f);
  float _77 = min(_73, 5000.0f);
  float _78 = min(_74, 5000.0f);
  float _79 = min(_75, 5000.0f);
  float _82 = _26.x * cb0_028z;
  float _83 = _82 + cb0_028x;
  float _84 = cb2_027w / _83;
  float _85 = 1.0f - _84;
  float _86 = abs(_85);
  float _88 = cb2_027y * _86;
  float _90 = _88 - cb2_027z;
  float _91 = saturate(_90);
  float _92 = max(_91, _79);
  float _93 = saturate(_92);
  float _97 = cb2_006x * _55;
  float _98 = cb2_006y * _56;
  float _101 = _97 + cb2_006z;
  float _102 = _98 + cb2_006w;
  float _106 = cb2_007x * _55;
  float _107 = cb2_007y * _56;
  float _110 = _106 + cb2_007z;
  float _111 = _107 + cb2_007w;
  float _115 = cb2_008x * _55;
  float _116 = cb2_008y * _56;
  float _119 = _115 + cb2_008z;
  float _120 = _116 + cb2_008w;
  float4 _121 = t1.SampleLevel(s2_space2, float2(_101, _102), 0.0f);
  float _123 = max(_121.x, 0.0f);
  float _124 = min(_123, 65000.0f);
  float4 _125 = t1.SampleLevel(s2_space2, float2(_110, _111), 0.0f);
  float _127 = max(_125.y, 0.0f);
  float _128 = min(_127, 65000.0f);
  float4 _129 = t1.SampleLevel(s2_space2, float2(_119, _120), 0.0f);
  float _131 = max(_129.z, 0.0f);
  float _132 = min(_131, 65000.0f);
  float4 _133 = t4.SampleLevel(s2_space2, float2(_101, _102), 0.0f);
  float _135 = max(_133.x, 0.0f);
  float _136 = min(_135, 5000.0f);
  float4 _137 = t4.SampleLevel(s2_space2, float2(_110, _111), 0.0f);
  float _139 = max(_137.y, 0.0f);
  float _140 = min(_139, 5000.0f);
  float4 _141 = t4.SampleLevel(s2_space2, float2(_119, _120), 0.0f);
  float _143 = max(_141.z, 0.0f);
  float _144 = min(_143, 5000.0f);
  float4 _145 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _151 = cb2_005x * _145.x;
  float _152 = cb2_005x * _145.y;
  float _153 = cb2_005x * _145.z;
  float _154 = _124 - _64;
  float _155 = _128 - _65;
  float _156 = _132 - _66;
  float _157 = _151 * _154;
  float _158 = _152 * _155;
  float _159 = _153 * _156;
  float _160 = _157 + _64;
  float _161 = _158 + _65;
  float _162 = _159 + _66;
  float _163 = _136 - _76;
  float _164 = _140 - _77;
  float _165 = _144 - _78;
  float _166 = _151 * _163;
  float _167 = _152 * _164;
  float _168 = _153 * _165;
  float _169 = _166 + _76;
  float _170 = _167 + _77;
  float _171 = _168 + _78;
  float4 _172 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _176 = _169 - _160;
  float _177 = _170 - _161;
  float _178 = _171 - _162;
  float _179 = _176 * _93;
  float _180 = _177 * _93;
  float _181 = _178 * _93;
  float _182 = _179 + _160;
  float _183 = _180 + _161;
  float _184 = _181 + _162;
  float _185 = dot(float3(_182, _183, _184), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _189 = t0[0].SExposureData_020;
  float _191 = t0[0].SExposureData_004;
  float _193 = cb2_018x * 0.5f;
  float _194 = _193 * cb2_018y;
  float _195 = _191.x - _194;
  float _196 = cb2_018y * cb2_018x;
  float _197 = 1.0f / _196;
  float _198 = _195 * _197;
  float _199 = _185 / _189.x;
  float _200 = _199 * 5464.01611328125f;
  float _201 = _200 + 9.99999993922529e-09f;
  float _202 = log2(_201);
  float _203 = _202 - _195;
  float _204 = _203 * _197;
  float _205 = saturate(_204);
  float2 _206 = t10.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _205), 0.0f);
  float _209 = max(_206.y, 1.0000000116860974e-07f);
  float _210 = _206.x / _209;
  float _211 = _210 + _198;
  float _212 = _211 / _197;
  float _213 = _212 - _191.x;
  float _214 = -0.0f - _213;
  float _216 = _214 - cb2_027x;
  float _217 = max(0.0f, _216);
  float _219 = cb2_026z * _217;
  float _220 = _213 - cb2_027x;
  float _221 = max(0.0f, _220);
  float _223 = cb2_026w * _221;
  bool _224 = (_213 < 0.0f);
  float _225 = select(_224, _219, _223);
  float _226 = exp2(_225);
  float _227 = _226 * _182;
  float _228 = _226 * _183;
  float _229 = _226 * _184;
  float _234 = cb2_024y * _172.x;
  float _235 = cb2_024z * _172.y;
  float _236 = cb2_024w * _172.z;
  float _237 = _234 + _227;
  float _238 = _235 + _228;
  float _239 = _236 + _229;
  float _244 = _237 * cb2_025x;
  float _245 = _238 * cb2_025y;
  float _246 = _239 * cb2_025z;
  float _247 = dot(float3(_244, _245, _246), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _248 = t0[0].SExposureData_012;
  float _250 = _247 * 5464.01611328125f;
  float _251 = _250 * _248.x;
  float _252 = _251 + 9.99999993922529e-09f;
  float _253 = log2(_252);
  float _254 = _253 + 16.929765701293945f;
  float _255 = _254 * 0.05734497308731079f;
  float _256 = saturate(_255);
  float _257 = _256 * _256;
  float _258 = _256 * 2.0f;
  float _259 = 3.0f - _258;
  float _260 = _257 * _259;
  float _261 = _245 * 0.8450999855995178f;
  float _262 = _246 * 0.14589999616146088f;
  float _263 = _261 + _262;
  float _264 = _263 * 2.4890189170837402f;
  float _265 = _263 * 0.3754962384700775f;
  float _266 = _263 * 2.811495304107666f;
  float _267 = _263 * 5.519708156585693f;
  float _268 = _247 - _264;
  float _269 = _260 * _268;
  float _270 = _269 + _264;
  float _271 = _260 * 0.5f;
  float _272 = _271 + 0.5f;
  float _273 = _272 * _268;
  float _274 = _273 + _264;
  float _275 = _244 - _265;
  float _276 = _245 - _266;
  float _277 = _246 - _267;
  float _278 = _272 * _275;
  float _279 = _272 * _276;
  float _280 = _272 * _277;
  float _281 = _278 + _265;
  float _282 = _279 + _266;
  float _283 = _280 + _267;
  float _284 = 1.0f / _274;
  float _285 = _270 * _284;
  float _286 = _285 * _281;
  float _287 = _285 * _282;
  float _288 = _285 * _283;
  float _292 = cb2_020x * TEXCOORD0_centroid.x;
  float _293 = cb2_020y * TEXCOORD0_centroid.y;
  float _296 = _292 + cb2_020z;
  float _297 = _293 + cb2_020w;
  float _300 = dot(float2(_296, _297), float2(_296, _297));
  float _301 = 1.0f - _300;
  float _302 = saturate(_301);
  float _303 = log2(_302);
  float _304 = _303 * cb2_021w;
  float _305 = exp2(_304);
  float _309 = _286 - cb2_021x;
  float _310 = _287 - cb2_021y;
  float _311 = _288 - cb2_021z;
  float _312 = _309 * _305;
  float _313 = _310 * _305;
  float _314 = _311 * _305;
  float _315 = _312 + cb2_021x;
  float _316 = _313 + cb2_021y;
  float _317 = _314 + cb2_021z;
  float _318 = t0[0].SExposureData_000;
  float _320 = max(_189.x, 0.0010000000474974513f);
  float _321 = 1.0f / _320;
  float _322 = _321 * _318.x;
  bool _325 = ((uint)(cb2_069y) == 0);
  float _331;
  float _332;
  float _333;
  float _387;
  float _388;
  float _389;
  float _480;
  float _481;
  float _482;
  float _527;
  float _528;
  float _529;
  float _530;
  float _579;
  float _580;
  float _581;
  float _582;
  float _607;
  float _608;
  float _609;
  float _710;
  float _711;
  float _712;
  float _737;
  float _749;
  float _777;
  float _789;
  float _801;
  float _802;
  float _803;
  float _830;
  float _831;
  float _832;
  if (!_325) {
    float _327 = _322 * _315;
    float _328 = _322 * _316;
    float _329 = _322 * _317;
    _331 = _327;
    _332 = _328;
    _333 = _329;
  } else {
    _331 = _315;
    _332 = _316;
    _333 = _317;
  }
  float _334 = _331 * 0.6130970120429993f;
  float _335 = mad(0.33952298760414124f, _332, _334);
  float _336 = mad(0.04737899824976921f, _333, _335);
  float _337 = _331 * 0.07019399851560593f;
  float _338 = mad(0.9163540005683899f, _332, _337);
  float _339 = mad(0.013451999984681606f, _333, _338);
  float _340 = _331 * 0.02061600051820278f;
  float _341 = mad(0.10956999659538269f, _332, _340);
  float _342 = mad(0.8698149919509888f, _333, _341);
  float _343 = log2(_336);
  float _344 = log2(_339);
  float _345 = log2(_342);
  float _346 = _343 * 0.04211956635117531f;
  float _347 = _344 * 0.04211956635117531f;
  float _348 = _345 * 0.04211956635117531f;
  float _349 = _346 + 0.6252607107162476f;
  float _350 = _347 + 0.6252607107162476f;
  float _351 = _348 + 0.6252607107162476f;
  float4 _352 = t6.SampleLevel(s2_space2, float3(_349, _350, _351), 0.0f);
  bool _358 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_358 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _362 = cb2_017x * _352.x;
    float _363 = cb2_017x * _352.y;
    float _364 = cb2_017x * _352.z;
    float _366 = _362 + cb2_017y;
    float _367 = _363 + cb2_017y;
    float _368 = _364 + cb2_017y;
    float _369 = exp2(_366);
    float _370 = exp2(_367);
    float _371 = exp2(_368);
    float _372 = _369 + 1.0f;
    float _373 = _370 + 1.0f;
    float _374 = _371 + 1.0f;
    float _375 = 1.0f / _372;
    float _376 = 1.0f / _373;
    float _377 = 1.0f / _374;
    float _379 = cb2_017z * _375;
    float _380 = cb2_017z * _376;
    float _381 = cb2_017z * _377;
    float _383 = _379 + cb2_017w;
    float _384 = _380 + cb2_017w;
    float _385 = _381 + cb2_017w;
    _387 = _383;
    _388 = _384;
    _389 = _385;
  } else {
    _387 = _352.x;
    _388 = _352.y;
    _389 = _352.z;
  }
  float _390 = _387 * 23.0f;
  float _391 = _390 + -14.473931312561035f;
  float _392 = exp2(_391);
  float _393 = _388 * 23.0f;
  float _394 = _393 + -14.473931312561035f;
  float _395 = exp2(_394);
  float _396 = _389 * 23.0f;
  float _397 = _396 + -14.473931312561035f;
  float _398 = exp2(_397);
  float _399 = dot(float3(_392, _395, _398), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _404 = dot(float3(_392, _395, _398), float3(_392, _395, _398));
  float _405 = rsqrt(_404);
  float _406 = _405 * _392;
  float _407 = _405 * _395;
  float _408 = _405 * _398;
  float _409 = cb2_001x - _406;
  float _410 = cb2_001y - _407;
  float _411 = cb2_001z - _408;
  float _412 = dot(float3(_409, _410, _411), float3(_409, _410, _411));
  float _415 = cb2_002z * _412;
  float _417 = _415 + cb2_002w;
  float _418 = saturate(_417);
  float _420 = cb2_002x * _418;
  float _421 = _399 - _392;
  float _422 = _399 - _395;
  float _423 = _399 - _398;
  float _424 = _420 * _421;
  float _425 = _420 * _422;
  float _426 = _420 * _423;
  float _427 = _424 + _392;
  float _428 = _425 + _395;
  float _429 = _426 + _398;
  float _431 = cb2_002y * _418;
  float _432 = 0.10000000149011612f - _427;
  float _433 = 0.10000000149011612f - _428;
  float _434 = 0.10000000149011612f - _429;
  float _435 = _432 * _431;
  float _436 = _433 * _431;
  float _437 = _434 * _431;
  float _438 = _435 + _427;
  float _439 = _436 + _428;
  float _440 = _437 + _429;
  float _441 = saturate(_438);
  float _442 = saturate(_439);
  float _443 = saturate(_440);
  float _448 = cb2_004x * TEXCOORD0_centroid.x;
  float _449 = cb2_004y * TEXCOORD0_centroid.y;
  float _452 = _448 + cb2_004z;
  float _453 = _449 + cb2_004w;
  float4 _459 = t8.Sample(s2_space2, float2(_452, _453));
  float _464 = _459.x * cb2_003x;
  float _465 = _459.y * cb2_003y;
  float _466 = _459.z * cb2_003z;
  float _467 = _459.w * cb2_003w;
  float _470 = _467 + cb2_026y;
  float _471 = saturate(_470);
  bool _474 = ((uint)(cb2_069y) == 0);
  if (!_474) {
    float _476 = _464 * _322;
    float _477 = _465 * _322;
    float _478 = _466 * _322;
    _480 = _476;
    _481 = _477;
    _482 = _478;
  } else {
    _480 = _464;
    _481 = _465;
    _482 = _466;
  }
  bool _485 = ((uint)(cb2_028x) == 2);
  bool _486 = ((uint)(cb2_028x) == 3);
  int _487 = (uint)(cb2_028x) & -2;
  bool _488 = (_487 == 2);
  bool _489 = ((uint)(cb2_028x) == 6);
  bool _490 = _488 || _489;
  if (_490) {
    float _492 = _480 * _471;
    float _493 = _481 * _471;
    float _494 = _482 * _471;
    float _495 = _471 * _471;
    _527 = _492;
    _528 = _493;
    _529 = _494;
    _530 = _495;
  } else {
    bool _497 = ((uint)(cb2_028x) == 4);
    if (_497) {
      float _499 = _480 + -1.0f;
      float _500 = _481 + -1.0f;
      float _501 = _482 + -1.0f;
      float _502 = _471 + -1.0f;
      float _503 = _499 * _471;
      float _504 = _500 * _471;
      float _505 = _501 * _471;
      float _506 = _502 * _471;
      float _507 = _503 + 1.0f;
      float _508 = _504 + 1.0f;
      float _509 = _505 + 1.0f;
      float _510 = _506 + 1.0f;
      _527 = _507;
      _528 = _508;
      _529 = _509;
      _530 = _510;
    } else {
      bool _512 = ((uint)(cb2_028x) == 5);
      if (_512) {
        float _514 = _480 + -0.5f;
        float _515 = _481 + -0.5f;
        float _516 = _482 + -0.5f;
        float _517 = _471 + -0.5f;
        float _518 = _514 * _471;
        float _519 = _515 * _471;
        float _520 = _516 * _471;
        float _521 = _517 * _471;
        float _522 = _518 + 0.5f;
        float _523 = _519 + 0.5f;
        float _524 = _520 + 0.5f;
        float _525 = _521 + 0.5f;
        _527 = _522;
        _528 = _523;
        _529 = _524;
        _530 = _525;
      } else {
        _527 = _480;
        _528 = _481;
        _529 = _482;
        _530 = _471;
      }
    }
  }
  if (_485) {
    float _532 = _527 + _441;
    float _533 = _528 + _442;
    float _534 = _529 + _443;
    _579 = _532;
    _580 = _533;
    _581 = _534;
    _582 = cb2_025w;
  } else {
    if (_486) {
      float _537 = 1.0f - _527;
      float _538 = 1.0f - _528;
      float _539 = 1.0f - _529;
      float _540 = _537 * _441;
      float _541 = _538 * _442;
      float _542 = _539 * _443;
      float _543 = _540 + _527;
      float _544 = _541 + _528;
      float _545 = _542 + _529;
      _579 = _543;
      _580 = _544;
      _581 = _545;
      _582 = cb2_025w;
    } else {
      bool _547 = ((uint)(cb2_028x) == 4);
      if (_547) {
        float _549 = _527 * _441;
        float _550 = _528 * _442;
        float _551 = _529 * _443;
        _579 = _549;
        _580 = _550;
        _581 = _551;
        _582 = cb2_025w;
      } else {
        bool _553 = ((uint)(cb2_028x) == 5);
        if (_553) {
          float _555 = _441 * 2.0f;
          float _556 = _555 * _527;
          float _557 = _442 * 2.0f;
          float _558 = _557 * _528;
          float _559 = _443 * 2.0f;
          float _560 = _559 * _529;
          _579 = _556;
          _580 = _558;
          _581 = _560;
          _582 = cb2_025w;
        } else {
          if (_489) {
            float _563 = _441 - _527;
            float _564 = _442 - _528;
            float _565 = _443 - _529;
            _579 = _563;
            _580 = _564;
            _581 = _565;
            _582 = cb2_025w;
          } else {
            float _567 = _527 - _441;
            float _568 = _528 - _442;
            float _569 = _529 - _443;
            float _570 = _530 * _567;
            float _571 = _530 * _568;
            float _572 = _530 * _569;
            float _573 = _570 + _441;
            float _574 = _571 + _442;
            float _575 = _572 + _443;
            float _576 = 1.0f - _530;
            float _577 = _576 * cb2_025w;
            _579 = _573;
            _580 = _574;
            _581 = _575;
            _582 = _577;
          }
        }
      }
    }
  }
  float _588 = cb2_016x - _579;
  float _589 = cb2_016y - _580;
  float _590 = cb2_016z - _581;
  float _591 = _588 * cb2_016w;
  float _592 = _589 * cb2_016w;
  float _593 = _590 * cb2_016w;
  float _594 = _591 + _579;
  float _595 = _592 + _580;
  float _596 = _593 + _581;
  bool _599 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_599 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _603 = cb2_024x * _594;
    float _604 = cb2_024x * _595;
    float _605 = cb2_024x * _596;
    _607 = _603;
    _608 = _604;
    _609 = _605;
  } else {
    _607 = _594;
    _608 = _595;
    _609 = _596;
  }
  float _610 = _607 * 0.9708889722824097f;
  float _611 = mad(0.026962999254465103f, _608, _610);
  float _612 = mad(0.002148000057786703f, _609, _611);
  float _613 = _607 * 0.01088900025933981f;
  float _614 = mad(0.9869629740715027f, _608, _613);
  float _615 = mad(0.002148000057786703f, _609, _614);
  float _616 = mad(0.026962999254465103f, _608, _613);
  float _617 = mad(0.9621480107307434f, _609, _616);
  if (_599) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _622 = cb1_018y * 0.10000000149011612f;
        float _623 = log2(cb1_018z);
        float _624 = _623 + -13.287712097167969f;
        float _625 = _624 * 1.4929734468460083f;
        float _626 = _625 + 18.0f;
        float _627 = exp2(_626);
        float _628 = _627 * 0.18000000715255737f;
        float _629 = abs(_628);
        float _630 = log2(_629);
        float _631 = _630 * 1.5f;
        float _632 = exp2(_631);
        float _633 = _632 * _622;
        float _634 = _633 / cb1_018z;
        float _635 = _634 + -0.07636754959821701f;
        float _636 = _630 * 1.2750000953674316f;
        float _637 = exp2(_636);
        float _638 = _637 * 0.07636754959821701f;
        float _639 = cb1_018y * 0.011232397519052029f;
        float _640 = _639 * _632;
        float _641 = _640 / cb1_018z;
        float _642 = _638 - _641;
        float _643 = _637 + -0.11232396960258484f;
        float _644 = _643 * _622;
        float _645 = _644 / cb1_018z;
        float _646 = _645 * cb1_018z;
        float _647 = abs(_612);
        float _648 = abs(_615);
        float _649 = abs(_617);
        float _650 = log2(_647);
        float _651 = log2(_648);
        float _652 = log2(_649);
        float _653 = _650 * 1.5f;
        float _654 = _651 * 1.5f;
        float _655 = _652 * 1.5f;
        float _656 = exp2(_653);
        float _657 = exp2(_654);
        float _658 = exp2(_655);
        float _659 = _656 * _646;
        float _660 = _657 * _646;
        float _661 = _658 * _646;
        float _662 = _650 * 1.2750000953674316f;
        float _663 = _651 * 1.2750000953674316f;
        float _664 = _652 * 1.2750000953674316f;
        float _665 = exp2(_662);
        float _666 = exp2(_663);
        float _667 = exp2(_664);
        float _668 = _665 * _635;
        float _669 = _666 * _635;
        float _670 = _667 * _635;
        float _671 = _668 + _642;
        float _672 = _669 + _642;
        float _673 = _670 + _642;
        float _674 = _659 / _671;
        float _675 = _660 / _672;
        float _676 = _661 / _673;
        float _677 = _674 * 9.999999747378752e-05f;
        float _678 = _675 * 9.999999747378752e-05f;
        float _679 = _676 * 9.999999747378752e-05f;
        float _680 = 5000.0f / cb1_018y;
        float _681 = _677 * _680;
        float _682 = _678 * _680;
        float _683 = _679 * _680;
        _710 = _681;
        _711 = _682;
        _712 = _683;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_612, _615, _617));
      _710 = tonemapped.x, _711 = tonemapped.y, _712 = tonemapped.z;
    }
      } else {
        float _685 = _612 + 0.020616600289940834f;
        float _686 = _615 + 0.020616600289940834f;
        float _687 = _617 + 0.020616600289940834f;
        float _688 = _685 * _612;
        float _689 = _686 * _615;
        float _690 = _687 * _617;
        float _691 = _688 + -7.456949970219284e-05f;
        float _692 = _689 + -7.456949970219284e-05f;
        float _693 = _690 + -7.456949970219284e-05f;
        float _694 = _612 * 0.9837960004806519f;
        float _695 = _615 * 0.9837960004806519f;
        float _696 = _617 * 0.9837960004806519f;
        float _697 = _694 + 0.4336790144443512f;
        float _698 = _695 + 0.4336790144443512f;
        float _699 = _696 + 0.4336790144443512f;
        float _700 = _697 * _612;
        float _701 = _698 * _615;
        float _702 = _699 * _617;
        float _703 = _700 + 0.24617899954319f;
        float _704 = _701 + 0.24617899954319f;
        float _705 = _702 + 0.24617899954319f;
        float _706 = _691 / _703;
        float _707 = _692 / _704;
        float _708 = _693 / _705;
        _710 = _706;
        _711 = _707;
        _712 = _708;
      }
      float _713 = _710 * 1.6047500371932983f;
      float _714 = mad(-0.5310800075531006f, _711, _713);
      float _715 = mad(-0.07366999983787537f, _712, _714);
      float _716 = _710 * -0.10208000242710114f;
      float _717 = mad(1.1081299781799316f, _711, _716);
      float _718 = mad(-0.006049999967217445f, _712, _717);
      float _719 = _710 * -0.0032599999103695154f;
      float _720 = mad(-0.07275000214576721f, _711, _719);
      float _721 = mad(1.0760200023651123f, _712, _720);
      if (_599) {
        // float _723 = max(_715, 0.0f);
        // float _724 = max(_718, 0.0f);
        // float _725 = max(_721, 0.0f);
        // bool _726 = !(_723 >= 0.0030399328097701073f);
        // if (!_726) {
        //   float _728 = abs(_723);
        //   float _729 = log2(_728);
        //   float _730 = _729 * 0.4166666567325592f;
        //   float _731 = exp2(_730);
        //   float _732 = _731 * 1.0549999475479126f;
        //   float _733 = _732 + -0.054999999701976776f;
        //   _737 = _733;
        // } else {
        //   float _735 = _723 * 12.923210144042969f;
        //   _737 = _735;
        // }
        // bool _738 = !(_724 >= 0.0030399328097701073f);
        // if (!_738) {
        //   float _740 = abs(_724);
        //   float _741 = log2(_740);
        //   float _742 = _741 * 0.4166666567325592f;
        //   float _743 = exp2(_742);
        //   float _744 = _743 * 1.0549999475479126f;
        //   float _745 = _744 + -0.054999999701976776f;
        //   _749 = _745;
        // } else {
        //   float _747 = _724 * 12.923210144042969f;
        //   _749 = _747;
        // }
        // bool _750 = !(_725 >= 0.0030399328097701073f);
        // if (!_750) {
        //   float _752 = abs(_725);
        //   float _753 = log2(_752);
        //   float _754 = _753 * 0.4166666567325592f;
        //   float _755 = exp2(_754);
        //   float _756 = _755 * 1.0549999475479126f;
        //   float _757 = _756 + -0.054999999701976776f;
        //   _830 = _737;
        //   _831 = _749;
        //   _832 = _757;
        // } else {
        //   float _759 = _725 * 12.923210144042969f;
        //   _830 = _737;
        //   _831 = _749;
        //   _832 = _759;
        // }
        _830 = renodx::color::srgb::EncodeSafe(_715);
        _831 = renodx::color::srgb::EncodeSafe(_718);
        _832 = renodx::color::srgb::EncodeSafe(_721);

      } else {
        float _761 = saturate(_715);
        float _762 = saturate(_718);
        float _763 = saturate(_721);
        bool _764 = ((uint)(cb1_018w) == -2);
        if (!_764) {
          bool _766 = !(_761 >= 0.0030399328097701073f);
          if (!_766) {
            float _768 = abs(_761);
            float _769 = log2(_768);
            float _770 = _769 * 0.4166666567325592f;
            float _771 = exp2(_770);
            float _772 = _771 * 1.0549999475479126f;
            float _773 = _772 + -0.054999999701976776f;
            _777 = _773;
          } else {
            float _775 = _761 * 12.923210144042969f;
            _777 = _775;
          }
          bool _778 = !(_762 >= 0.0030399328097701073f);
          if (!_778) {
            float _780 = abs(_762);
            float _781 = log2(_780);
            float _782 = _781 * 0.4166666567325592f;
            float _783 = exp2(_782);
            float _784 = _783 * 1.0549999475479126f;
            float _785 = _784 + -0.054999999701976776f;
            _789 = _785;
          } else {
            float _787 = _762 * 12.923210144042969f;
            _789 = _787;
          }
          bool _790 = !(_763 >= 0.0030399328097701073f);
          if (!_790) {
            float _792 = abs(_763);
            float _793 = log2(_792);
            float _794 = _793 * 0.4166666567325592f;
            float _795 = exp2(_794);
            float _796 = _795 * 1.0549999475479126f;
            float _797 = _796 + -0.054999999701976776f;
            _801 = _777;
            _802 = _789;
            _803 = _797;
          } else {
            float _799 = _763 * 12.923210144042969f;
            _801 = _777;
            _802 = _789;
            _803 = _799;
          }
        } else {
          _801 = _761;
          _802 = _762;
          _803 = _763;
        }
        float _808 = abs(_801);
        float _809 = abs(_802);
        float _810 = abs(_803);
        float _811 = log2(_808);
        float _812 = log2(_809);
        float _813 = log2(_810);
        float _814 = _811 * cb2_000z;
        float _815 = _812 * cb2_000z;
        float _816 = _813 * cb2_000z;
        float _817 = exp2(_814);
        float _818 = exp2(_815);
        float _819 = exp2(_816);
        float _820 = _817 * cb2_000y;
        float _821 = _818 * cb2_000y;
        float _822 = _819 * cb2_000y;
        float _823 = _820 + cb2_000x;
        float _824 = _821 + cb2_000x;
        float _825 = _822 + cb2_000x;
        float _826 = saturate(_823);
        float _827 = saturate(_824);
        float _828 = saturate(_825);
        _830 = _826;
        _831 = _827;
        _832 = _828;
      }
      float _836 = cb2_023x * TEXCOORD0_centroid.x;
      float _837 = cb2_023y * TEXCOORD0_centroid.y;
      float _840 = _836 + cb2_023z;
      float _841 = _837 + cb2_023w;
      float4 _844 = t11.SampleLevel(s0_space2, float2(_840, _841), 0.0f);
      float _846 = _844.x + -0.5f;
      float _847 = _846 * cb2_022x;
      float _848 = _847 + 0.5f;
      float _849 = _848 * 2.0f;
      float _850 = _849 * _830;
      float _851 = _849 * _831;
      float _852 = _849 * _832;
      float _856 = float((uint)(cb2_019z));
      float _857 = float((uint)(cb2_019w));
      float _858 = _856 + SV_Position.x;
      float _859 = _857 + SV_Position.y;
      uint _860 = uint(_858);
      uint _861 = uint(_859);
      uint _864 = cb2_019x + -1u;
      uint _865 = cb2_019y + -1u;
      int _866 = _860 & _864;
      int _867 = _861 & _865;
      float4 _868 = t3.Load(int3(_866, _867, 0));
      float _872 = _868.x * 2.0f;
      float _873 = _868.y * 2.0f;
      float _874 = _868.z * 2.0f;
      float _875 = _872 + -1.0f;
      float _876 = _873 + -1.0f;
      float _877 = _874 + -1.0f;
      float _878 = _875 * _582;
      float _879 = _876 * _582;
      float _880 = _877 * _582;
      float _881 = _878 + _850;
      float _882 = _879 + _851;
      float _883 = _880 + _852;
      float _884 = dot(float3(_881, _882, _883), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _881;
      SV_Target.y = _882;
      SV_Target.z = _883;
      SV_Target.w = _884;
      SV_Target_1.x = _884;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

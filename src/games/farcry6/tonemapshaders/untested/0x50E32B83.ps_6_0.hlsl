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

Texture3D<float2> t8 : register(t8);

Texture2D<float4> t9 : register(t9);

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
  float cb2_003x : packoffset(c003.x);
  float cb2_003y : packoffset(c003.y);
  float cb2_003z : packoffset(c003.z);
  float cb2_003w : packoffset(c003.w);
  float cb2_004x : packoffset(c004.x);
  float cb2_004y : packoffset(c004.y);
  float cb2_004z : packoffset(c004.z);
  float cb2_004w : packoffset(c004.w);
  float cb2_009x : packoffset(c009.x);
  float cb2_009y : packoffset(c009.y);
  float cb2_009z : packoffset(c009.z);
  float cb2_010x : packoffset(c010.x);
  float cb2_010y : packoffset(c010.y);
  float cb2_010z : packoffset(c010.z);
  float cb2_011x : packoffset(c011.x);
  float cb2_011y : packoffset(c011.y);
  float cb2_011z : packoffset(c011.z);
  float cb2_011w : packoffset(c011.w);
  float cb2_012x : packoffset(c012.x);
  float cb2_012y : packoffset(c012.y);
  float cb2_012z : packoffset(c012.z);
  float cb2_012w : packoffset(c012.w);
  float cb2_013x : packoffset(c013.x);
  float cb2_013y : packoffset(c013.y);
  float cb2_013z : packoffset(c013.z);
  float cb2_013w : packoffset(c013.w);
  float cb2_014x : packoffset(c014.x);
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
  float _24 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _26 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _30 = max(_26.x, 0.0f);
  float _31 = max(_26.y, 0.0f);
  float _32 = max(_26.z, 0.0f);
  float _33 = min(_30, 65000.0f);
  float _34 = min(_31, 65000.0f);
  float _35 = min(_32, 65000.0f);
  float4 _36 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _41 = max(_36.x, 0.0f);
  float _42 = max(_36.y, 0.0f);
  float _43 = max(_36.z, 0.0f);
  float _44 = max(_36.w, 0.0f);
  float _45 = min(_41, 5000.0f);
  float _46 = min(_42, 5000.0f);
  float _47 = min(_43, 5000.0f);
  float _48 = min(_44, 5000.0f);
  float _51 = _24.x * cb0_028z;
  float _52 = _51 + cb0_028x;
  float _53 = cb2_027w / _52;
  float _54 = 1.0f - _53;
  float _55 = abs(_54);
  float _57 = cb2_027y * _55;
  float _59 = _57 - cb2_027z;
  float _60 = saturate(_59);
  float _61 = max(_60, _48);
  float _62 = saturate(_61);
  float _66 = cb2_013x * TEXCOORD0_centroid.x;
  float _67 = cb2_013y * TEXCOORD0_centroid.y;
  float _70 = _66 + cb2_013z;
  float _71 = _67 + cb2_013w;
  float _74 = dot(float2(_70, _71), float2(_70, _71));
  float _75 = abs(_74);
  float _76 = log2(_75);
  float _77 = _76 * cb2_014x;
  float _78 = exp2(_77);
  float _79 = saturate(_78);
  float _83 = cb2_011x * TEXCOORD0_centroid.x;
  float _84 = cb2_011y * TEXCOORD0_centroid.y;
  float _87 = _83 + cb2_011z;
  float _88 = _84 + cb2_011w;
  float _89 = _87 * _79;
  float _90 = _88 * _79;
  float _91 = _89 + TEXCOORD0_centroid.x;
  float _92 = _90 + TEXCOORD0_centroid.y;
  float _96 = cb2_012x * TEXCOORD0_centroid.x;
  float _97 = cb2_012y * TEXCOORD0_centroid.y;
  float _100 = _96 + cb2_012z;
  float _101 = _97 + cb2_012w;
  float _102 = _100 * _79;
  float _103 = _101 * _79;
  float _104 = _102 + TEXCOORD0_centroid.x;
  float _105 = _103 + TEXCOORD0_centroid.y;
  float4 _106 = t1.SampleLevel(s2_space2, float2(_91, _92), 0.0f);
  float _110 = max(_106.x, 0.0f);
  float _111 = max(_106.y, 0.0f);
  float _112 = max(_106.z, 0.0f);
  float _113 = min(_110, 65000.0f);
  float _114 = min(_111, 65000.0f);
  float _115 = min(_112, 65000.0f);
  float4 _116 = t1.SampleLevel(s2_space2, float2(_104, _105), 0.0f);
  float _120 = max(_116.x, 0.0f);
  float _121 = max(_116.y, 0.0f);
  float _122 = max(_116.z, 0.0f);
  float _123 = min(_120, 65000.0f);
  float _124 = min(_121, 65000.0f);
  float _125 = min(_122, 65000.0f);
  float4 _126 = t4.SampleLevel(s2_space2, float2(_91, _92), 0.0f);
  float _130 = max(_126.x, 0.0f);
  float _131 = max(_126.y, 0.0f);
  float _132 = max(_126.z, 0.0f);
  float _133 = min(_130, 5000.0f);
  float _134 = min(_131, 5000.0f);
  float _135 = min(_132, 5000.0f);
  float4 _136 = t4.SampleLevel(s2_space2, float2(_104, _105), 0.0f);
  float _140 = max(_136.x, 0.0f);
  float _141 = max(_136.y, 0.0f);
  float _142 = max(_136.z, 0.0f);
  float _143 = min(_140, 5000.0f);
  float _144 = min(_141, 5000.0f);
  float _145 = min(_142, 5000.0f);
  float _150 = 1.0f - cb2_009x;
  float _151 = 1.0f - cb2_009y;
  float _152 = 1.0f - cb2_009z;
  float _157 = _150 - cb2_010x;
  float _158 = _151 - cb2_010y;
  float _159 = _152 - cb2_010z;
  float _160 = saturate(_157);
  float _161 = saturate(_158);
  float _162 = saturate(_159);
  float _163 = _160 * _33;
  float _164 = _161 * _34;
  float _165 = _162 * _35;
  float _166 = cb2_009x * _113;
  float _167 = cb2_009y * _114;
  float _168 = cb2_009z * _115;
  float _169 = _166 + _163;
  float _170 = _167 + _164;
  float _171 = _168 + _165;
  float _172 = cb2_010x * _123;
  float _173 = cb2_010y * _124;
  float _174 = cb2_010z * _125;
  float _175 = _169 + _172;
  float _176 = _170 + _173;
  float _177 = _171 + _174;
  float _178 = _160 * _45;
  float _179 = _161 * _46;
  float _180 = _162 * _47;
  float _181 = cb2_009x * _133;
  float _182 = cb2_009y * _134;
  float _183 = cb2_009z * _135;
  float _184 = cb2_010x * _143;
  float _185 = cb2_010y * _144;
  float _186 = cb2_010z * _145;
  float4 _187 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _191 = _178 - _175;
  float _192 = _191 + _181;
  float _193 = _192 + _184;
  float _194 = _179 - _176;
  float _195 = _194 + _182;
  float _196 = _195 + _185;
  float _197 = _180 - _177;
  float _198 = _197 + _183;
  float _199 = _198 + _186;
  float _200 = _193 * _62;
  float _201 = _196 * _62;
  float _202 = _199 * _62;
  float _203 = _200 + _175;
  float _204 = _201 + _176;
  float _205 = _202 + _177;
  float _206 = dot(float3(_203, _204, _205), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _210 = t0[0].SExposureData_020;
  float _212 = t0[0].SExposureData_004;
  float _214 = cb2_018x * 0.5f;
  float _215 = _214 * cb2_018y;
  float _216 = _212.x - _215;
  float _217 = cb2_018y * cb2_018x;
  float _218 = 1.0f / _217;
  float _219 = _216 * _218;
  float _220 = _206 / _210.x;
  float _221 = _220 * 5464.01611328125f;
  float _222 = _221 + 9.99999993922529e-09f;
  float _223 = log2(_222);
  float _224 = _223 - _216;
  float _225 = _224 * _218;
  float _226 = saturate(_225);
  float2 _227 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _226), 0.0f);
  float _230 = max(_227.y, 1.0000000116860974e-07f);
  float _231 = _227.x / _230;
  float _232 = _231 + _219;
  float _233 = _232 / _218;
  float _234 = _233 - _212.x;
  float _235 = -0.0f - _234;
  float _237 = _235 - cb2_027x;
  float _238 = max(0.0f, _237);
  float _241 = cb2_026z * _238;
  float _242 = _234 - cb2_027x;
  float _243 = max(0.0f, _242);
  float _245 = cb2_026w * _243;
  bool _246 = (_234 < 0.0f);
  float _247 = select(_246, _241, _245);
  float _248 = exp2(_247);
  float _249 = _248 * _203;
  float _250 = _248 * _204;
  float _251 = _248 * _205;
  float _256 = cb2_024y * _187.x;
  float _257 = cb2_024z * _187.y;
  float _258 = cb2_024w * _187.z;
  float _259 = _256 + _249;
  float _260 = _257 + _250;
  float _261 = _258 + _251;
  float _266 = _259 * cb2_025x;
  float _267 = _260 * cb2_025y;
  float _268 = _261 * cb2_025z;
  float _269 = dot(float3(_266, _267, _268), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _270 = t0[0].SExposureData_012;
  float _272 = _269 * 5464.01611328125f;
  float _273 = _272 * _270.x;
  float _274 = _273 + 9.99999993922529e-09f;
  float _275 = log2(_274);
  float _276 = _275 + 16.929765701293945f;
  float _277 = _276 * 0.05734497308731079f;
  float _278 = saturate(_277);
  float _279 = _278 * _278;
  float _280 = _278 * 2.0f;
  float _281 = 3.0f - _280;
  float _282 = _279 * _281;
  float _283 = _267 * 0.8450999855995178f;
  float _284 = _268 * 0.14589999616146088f;
  float _285 = _283 + _284;
  float _286 = _285 * 2.4890189170837402f;
  float _287 = _285 * 0.3754962384700775f;
  float _288 = _285 * 2.811495304107666f;
  float _289 = _285 * 5.519708156585693f;
  float _290 = _269 - _286;
  float _291 = _282 * _290;
  float _292 = _291 + _286;
  float _293 = _282 * 0.5f;
  float _294 = _293 + 0.5f;
  float _295 = _294 * _290;
  float _296 = _295 + _286;
  float _297 = _266 - _287;
  float _298 = _267 - _288;
  float _299 = _268 - _289;
  float _300 = _294 * _297;
  float _301 = _294 * _298;
  float _302 = _294 * _299;
  float _303 = _300 + _287;
  float _304 = _301 + _288;
  float _305 = _302 + _289;
  float _306 = 1.0f / _296;
  float _307 = _292 * _306;
  float _308 = _307 * _303;
  float _309 = _307 * _304;
  float _310 = _307 * _305;
  float _314 = cb2_020x * TEXCOORD0_centroid.x;
  float _315 = cb2_020y * TEXCOORD0_centroid.y;
  float _318 = _314 + cb2_020z;
  float _319 = _315 + cb2_020w;
  float _322 = dot(float2(_318, _319), float2(_318, _319));
  float _323 = 1.0f - _322;
  float _324 = saturate(_323);
  float _325 = log2(_324);
  float _326 = _325 * cb2_021w;
  float _327 = exp2(_326);
  float _331 = _308 - cb2_021x;
  float _332 = _309 - cb2_021y;
  float _333 = _310 - cb2_021z;
  float _334 = _331 * _327;
  float _335 = _332 * _327;
  float _336 = _333 * _327;
  float _337 = _334 + cb2_021x;
  float _338 = _335 + cb2_021y;
  float _339 = _336 + cb2_021z;
  float _340 = t0[0].SExposureData_000;
  float _342 = max(_210.x, 0.0010000000474974513f);
  float _343 = 1.0f / _342;
  float _344 = _343 * _340.x;
  bool _347 = ((uint)(cb2_069y) == 0);
  float _353;
  float _354;
  float _355;
  float _409;
  float _410;
  float _411;
  float _457;
  float _458;
  float _459;
  float _504;
  float _505;
  float _506;
  float _507;
  float _556;
  float _557;
  float _558;
  float _559;
  float _584;
  float _585;
  float _586;
  float _687;
  float _688;
  float _689;
  float _714;
  float _726;
  float _754;
  float _766;
  float _778;
  float _779;
  float _780;
  float _807;
  float _808;
  float _809;
  if (!_347) {
    float _349 = _344 * _337;
    float _350 = _344 * _338;
    float _351 = _344 * _339;
    _353 = _349;
    _354 = _350;
    _355 = _351;
  } else {
    _353 = _337;
    _354 = _338;
    _355 = _339;
  }
  float _356 = _353 * 0.6130970120429993f;
  float _357 = mad(0.33952298760414124f, _354, _356);
  float _358 = mad(0.04737899824976921f, _355, _357);
  float _359 = _353 * 0.07019399851560593f;
  float _360 = mad(0.9163540005683899f, _354, _359);
  float _361 = mad(0.013451999984681606f, _355, _360);
  float _362 = _353 * 0.02061600051820278f;
  float _363 = mad(0.10956999659538269f, _354, _362);
  float _364 = mad(0.8698149919509888f, _355, _363);
  float _365 = log2(_358);
  float _366 = log2(_361);
  float _367 = log2(_364);
  float _368 = _365 * 0.04211956635117531f;
  float _369 = _366 * 0.04211956635117531f;
  float _370 = _367 * 0.04211956635117531f;
  float _371 = _368 + 0.6252607107162476f;
  float _372 = _369 + 0.6252607107162476f;
  float _373 = _370 + 0.6252607107162476f;
  float4 _374 = t6.SampleLevel(s2_space2, float3(_371, _372, _373), 0.0f);
  bool _380 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_380 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _384 = cb2_017x * _374.x;
    float _385 = cb2_017x * _374.y;
    float _386 = cb2_017x * _374.z;
    float _388 = _384 + cb2_017y;
    float _389 = _385 + cb2_017y;
    float _390 = _386 + cb2_017y;
    float _391 = exp2(_388);
    float _392 = exp2(_389);
    float _393 = exp2(_390);
    float _394 = _391 + 1.0f;
    float _395 = _392 + 1.0f;
    float _396 = _393 + 1.0f;
    float _397 = 1.0f / _394;
    float _398 = 1.0f / _395;
    float _399 = 1.0f / _396;
    float _401 = cb2_017z * _397;
    float _402 = cb2_017z * _398;
    float _403 = cb2_017z * _399;
    float _405 = _401 + cb2_017w;
    float _406 = _402 + cb2_017w;
    float _407 = _403 + cb2_017w;
    _409 = _405;
    _410 = _406;
    _411 = _407;
  } else {
    _409 = _374.x;
    _410 = _374.y;
    _411 = _374.z;
  }
  float _412 = _409 * 23.0f;
  float _413 = _412 + -14.473931312561035f;
  float _414 = exp2(_413);
  float _415 = _410 * 23.0f;
  float _416 = _415 + -14.473931312561035f;
  float _417 = exp2(_416);
  float _418 = _411 * 23.0f;
  float _419 = _418 + -14.473931312561035f;
  float _420 = exp2(_419);
  float _425 = cb2_004x * TEXCOORD0_centroid.x;
  float _426 = cb2_004y * TEXCOORD0_centroid.y;
  float _429 = _425 + cb2_004z;
  float _430 = _426 + cb2_004w;
  float4 _436 = t7.Sample(s2_space2, float2(_429, _430));
  float _441 = _436.x * cb2_003x;
  float _442 = _436.y * cb2_003y;
  float _443 = _436.z * cb2_003z;
  float _444 = _436.w * cb2_003w;
  float _447 = _444 + cb2_026y;
  float _448 = saturate(_447);
  bool _451 = ((uint)(cb2_069y) == 0);
  if (!_451) {
    float _453 = _441 * _344;
    float _454 = _442 * _344;
    float _455 = _443 * _344;
    _457 = _453;
    _458 = _454;
    _459 = _455;
  } else {
    _457 = _441;
    _458 = _442;
    _459 = _443;
  }
  bool _462 = ((uint)(cb2_028x) == 2);
  bool _463 = ((uint)(cb2_028x) == 3);
  int _464 = (uint)(cb2_028x) & -2;
  bool _465 = (_464 == 2);
  bool _466 = ((uint)(cb2_028x) == 6);
  bool _467 = _465 || _466;
  if (_467) {
    float _469 = _457 * _448;
    float _470 = _458 * _448;
    float _471 = _459 * _448;
    float _472 = _448 * _448;
    _504 = _469;
    _505 = _470;
    _506 = _471;
    _507 = _472;
  } else {
    bool _474 = ((uint)(cb2_028x) == 4);
    if (_474) {
      float _476 = _457 + -1.0f;
      float _477 = _458 + -1.0f;
      float _478 = _459 + -1.0f;
      float _479 = _448 + -1.0f;
      float _480 = _476 * _448;
      float _481 = _477 * _448;
      float _482 = _478 * _448;
      float _483 = _479 * _448;
      float _484 = _480 + 1.0f;
      float _485 = _481 + 1.0f;
      float _486 = _482 + 1.0f;
      float _487 = _483 + 1.0f;
      _504 = _484;
      _505 = _485;
      _506 = _486;
      _507 = _487;
    } else {
      bool _489 = ((uint)(cb2_028x) == 5);
      if (_489) {
        float _491 = _457 + -0.5f;
        float _492 = _458 + -0.5f;
        float _493 = _459 + -0.5f;
        float _494 = _448 + -0.5f;
        float _495 = _491 * _448;
        float _496 = _492 * _448;
        float _497 = _493 * _448;
        float _498 = _494 * _448;
        float _499 = _495 + 0.5f;
        float _500 = _496 + 0.5f;
        float _501 = _497 + 0.5f;
        float _502 = _498 + 0.5f;
        _504 = _499;
        _505 = _500;
        _506 = _501;
        _507 = _502;
      } else {
        _504 = _457;
        _505 = _458;
        _506 = _459;
        _507 = _448;
      }
    }
  }
  if (_462) {
    float _509 = _504 + _414;
    float _510 = _505 + _417;
    float _511 = _506 + _420;
    _556 = _509;
    _557 = _510;
    _558 = _511;
    _559 = cb2_025w;
  } else {
    if (_463) {
      float _514 = 1.0f - _504;
      float _515 = 1.0f - _505;
      float _516 = 1.0f - _506;
      float _517 = _514 * _414;
      float _518 = _515 * _417;
      float _519 = _516 * _420;
      float _520 = _517 + _504;
      float _521 = _518 + _505;
      float _522 = _519 + _506;
      _556 = _520;
      _557 = _521;
      _558 = _522;
      _559 = cb2_025w;
    } else {
      bool _524 = ((uint)(cb2_028x) == 4);
      if (_524) {
        float _526 = _504 * _414;
        float _527 = _505 * _417;
        float _528 = _506 * _420;
        _556 = _526;
        _557 = _527;
        _558 = _528;
        _559 = cb2_025w;
      } else {
        bool _530 = ((uint)(cb2_028x) == 5);
        if (_530) {
          float _532 = _414 * 2.0f;
          float _533 = _532 * _504;
          float _534 = _417 * 2.0f;
          float _535 = _534 * _505;
          float _536 = _420 * 2.0f;
          float _537 = _536 * _506;
          _556 = _533;
          _557 = _535;
          _558 = _537;
          _559 = cb2_025w;
        } else {
          if (_466) {
            float _540 = _414 - _504;
            float _541 = _417 - _505;
            float _542 = _420 - _506;
            _556 = _540;
            _557 = _541;
            _558 = _542;
            _559 = cb2_025w;
          } else {
            float _544 = _504 - _414;
            float _545 = _505 - _417;
            float _546 = _506 - _420;
            float _547 = _507 * _544;
            float _548 = _507 * _545;
            float _549 = _507 * _546;
            float _550 = _547 + _414;
            float _551 = _548 + _417;
            float _552 = _549 + _420;
            float _553 = 1.0f - _507;
            float _554 = _553 * cb2_025w;
            _556 = _550;
            _557 = _551;
            _558 = _552;
            _559 = _554;
          }
        }
      }
    }
  }
  float _565 = cb2_016x - _556;
  float _566 = cb2_016y - _557;
  float _567 = cb2_016z - _558;
  float _568 = _565 * cb2_016w;
  float _569 = _566 * cb2_016w;
  float _570 = _567 * cb2_016w;
  float _571 = _568 + _556;
  float _572 = _569 + _557;
  float _573 = _570 + _558;
  bool _576 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_576 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _580 = cb2_024x * _571;
    float _581 = cb2_024x * _572;
    float _582 = cb2_024x * _573;
    _584 = _580;
    _585 = _581;
    _586 = _582;
  } else {
    _584 = _571;
    _585 = _572;
    _586 = _573;
  }
  float _587 = _584 * 0.9708889722824097f;
  float _588 = mad(0.026962999254465103f, _585, _587);
  float _589 = mad(0.002148000057786703f, _586, _588);
  float _590 = _584 * 0.01088900025933981f;
  float _591 = mad(0.9869629740715027f, _585, _590);
  float _592 = mad(0.002148000057786703f, _586, _591);
  float _593 = mad(0.026962999254465103f, _585, _590);
  float _594 = mad(0.9621480107307434f, _586, _593);
  if (_576) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _599 = cb1_018y * 0.10000000149011612f;
        float _600 = log2(cb1_018z);
        float _601 = _600 + -13.287712097167969f;
        float _602 = _601 * 1.4929734468460083f;
        float _603 = _602 + 18.0f;
        float _604 = exp2(_603);
        float _605 = _604 * 0.18000000715255737f;
        float _606 = abs(_605);
        float _607 = log2(_606);
        float _608 = _607 * 1.5f;
        float _609 = exp2(_608);
        float _610 = _609 * _599;
        float _611 = _610 / cb1_018z;
        float _612 = _611 + -0.07636754959821701f;
        float _613 = _607 * 1.2750000953674316f;
        float _614 = exp2(_613);
        float _615 = _614 * 0.07636754959821701f;
        float _616 = cb1_018y * 0.011232397519052029f;
        float _617 = _616 * _609;
        float _618 = _617 / cb1_018z;
        float _619 = _615 - _618;
        float _620 = _614 + -0.11232396960258484f;
        float _621 = _620 * _599;
        float _622 = _621 / cb1_018z;
        float _623 = _622 * cb1_018z;
        float _624 = abs(_589);
        float _625 = abs(_592);
        float _626 = abs(_594);
        float _627 = log2(_624);
        float _628 = log2(_625);
        float _629 = log2(_626);
        float _630 = _627 * 1.5f;
        float _631 = _628 * 1.5f;
        float _632 = _629 * 1.5f;
        float _633 = exp2(_630);
        float _634 = exp2(_631);
        float _635 = exp2(_632);
        float _636 = _633 * _623;
        float _637 = _634 * _623;
        float _638 = _635 * _623;
        float _639 = _627 * 1.2750000953674316f;
        float _640 = _628 * 1.2750000953674316f;
        float _641 = _629 * 1.2750000953674316f;
        float _642 = exp2(_639);
        float _643 = exp2(_640);
        float _644 = exp2(_641);
        float _645 = _642 * _612;
        float _646 = _643 * _612;
        float _647 = _644 * _612;
        float _648 = _645 + _619;
        float _649 = _646 + _619;
        float _650 = _647 + _619;
        float _651 = _636 / _648;
        float _652 = _637 / _649;
        float _653 = _638 / _650;
        float _654 = _651 * 9.999999747378752e-05f;
        float _655 = _652 * 9.999999747378752e-05f;
        float _656 = _653 * 9.999999747378752e-05f;
        float _657 = 5000.0f / cb1_018y;
        float _658 = _654 * _657;
        float _659 = _655 * _657;
        float _660 = _656 * _657;
        _687 = _658;
        _688 = _659;
        _689 = _660;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_589, _592, _594));
      _687 = tonemapped.x, _688 = tonemapped.y, _689 = tonemapped.z;
    }
      } else {
        float _662 = _589 + 0.020616600289940834f;
        float _663 = _592 + 0.020616600289940834f;
        float _664 = _594 + 0.020616600289940834f;
        float _665 = _662 * _589;
        float _666 = _663 * _592;
        float _667 = _664 * _594;
        float _668 = _665 + -7.456949970219284e-05f;
        float _669 = _666 + -7.456949970219284e-05f;
        float _670 = _667 + -7.456949970219284e-05f;
        float _671 = _589 * 0.9837960004806519f;
        float _672 = _592 * 0.9837960004806519f;
        float _673 = _594 * 0.9837960004806519f;
        float _674 = _671 + 0.4336790144443512f;
        float _675 = _672 + 0.4336790144443512f;
        float _676 = _673 + 0.4336790144443512f;
        float _677 = _674 * _589;
        float _678 = _675 * _592;
        float _679 = _676 * _594;
        float _680 = _677 + 0.24617899954319f;
        float _681 = _678 + 0.24617899954319f;
        float _682 = _679 + 0.24617899954319f;
        float _683 = _668 / _680;
        float _684 = _669 / _681;
        float _685 = _670 / _682;
        _687 = _683;
        _688 = _684;
        _689 = _685;
      }
      float _690 = _687 * 1.6047500371932983f;
      float _691 = mad(-0.5310800075531006f, _688, _690);
      float _692 = mad(-0.07366999983787537f, _689, _691);
      float _693 = _687 * -0.10208000242710114f;
      float _694 = mad(1.1081299781799316f, _688, _693);
      float _695 = mad(-0.006049999967217445f, _689, _694);
      float _696 = _687 * -0.0032599999103695154f;
      float _697 = mad(-0.07275000214576721f, _688, _696);
      float _698 = mad(1.0760200023651123f, _689, _697);
      if (_576) {
        // float _700 = max(_692, 0.0f);
        // float _701 = max(_695, 0.0f);
        // float _702 = max(_698, 0.0f);
        // bool _703 = !(_700 >= 0.0030399328097701073f);
        // if (!_703) {
        //   float _705 = abs(_700);
        //   float _706 = log2(_705);
        //   float _707 = _706 * 0.4166666567325592f;
        //   float _708 = exp2(_707);
        //   float _709 = _708 * 1.0549999475479126f;
        //   float _710 = _709 + -0.054999999701976776f;
        //   _714 = _710;
        // } else {
        //   float _712 = _700 * 12.923210144042969f;
        //   _714 = _712;
        // }
        // bool _715 = !(_701 >= 0.0030399328097701073f);
        // if (!_715) {
        //   float _717 = abs(_701);
        //   float _718 = log2(_717);
        //   float _719 = _718 * 0.4166666567325592f;
        //   float _720 = exp2(_719);
        //   float _721 = _720 * 1.0549999475479126f;
        //   float _722 = _721 + -0.054999999701976776f;
        //   _726 = _722;
        // } else {
        //   float _724 = _701 * 12.923210144042969f;
        //   _726 = _724;
        // }
        // bool _727 = !(_702 >= 0.0030399328097701073f);
        // if (!_727) {
        //   float _729 = abs(_702);
        //   float _730 = log2(_729);
        //   float _731 = _730 * 0.4166666567325592f;
        //   float _732 = exp2(_731);
        //   float _733 = _732 * 1.0549999475479126f;
        //   float _734 = _733 + -0.054999999701976776f;
        //   _807 = _714;
        //   _808 = _726;
        //   _809 = _734;
        // } else {
        //   float _736 = _702 * 12.923210144042969f;
        //   _807 = _714;
        //   _808 = _726;
        //   _809 = _736;
        // }
        _807 = renodx::color::srgb::EncodeSafe(_692);
        _808 = renodx::color::srgb::EncodeSafe(_695);
        _809 = renodx::color::srgb::EncodeSafe(_698);

      } else {
        float _738 = saturate(_692);
        float _739 = saturate(_695);
        float _740 = saturate(_698);
        bool _741 = ((uint)(cb1_018w) == -2);
        if (!_741) {
          bool _743 = !(_738 >= 0.0030399328097701073f);
          if (!_743) {
            float _745 = abs(_738);
            float _746 = log2(_745);
            float _747 = _746 * 0.4166666567325592f;
            float _748 = exp2(_747);
            float _749 = _748 * 1.0549999475479126f;
            float _750 = _749 + -0.054999999701976776f;
            _754 = _750;
          } else {
            float _752 = _738 * 12.923210144042969f;
            _754 = _752;
          }
          bool _755 = !(_739 >= 0.0030399328097701073f);
          if (!_755) {
            float _757 = abs(_739);
            float _758 = log2(_757);
            float _759 = _758 * 0.4166666567325592f;
            float _760 = exp2(_759);
            float _761 = _760 * 1.0549999475479126f;
            float _762 = _761 + -0.054999999701976776f;
            _766 = _762;
          } else {
            float _764 = _739 * 12.923210144042969f;
            _766 = _764;
          }
          bool _767 = !(_740 >= 0.0030399328097701073f);
          if (!_767) {
            float _769 = abs(_740);
            float _770 = log2(_769);
            float _771 = _770 * 0.4166666567325592f;
            float _772 = exp2(_771);
            float _773 = _772 * 1.0549999475479126f;
            float _774 = _773 + -0.054999999701976776f;
            _778 = _754;
            _779 = _766;
            _780 = _774;
          } else {
            float _776 = _740 * 12.923210144042969f;
            _778 = _754;
            _779 = _766;
            _780 = _776;
          }
        } else {
          _778 = _738;
          _779 = _739;
          _780 = _740;
        }
        float _785 = abs(_778);
        float _786 = abs(_779);
        float _787 = abs(_780);
        float _788 = log2(_785);
        float _789 = log2(_786);
        float _790 = log2(_787);
        float _791 = _788 * cb2_000z;
        float _792 = _789 * cb2_000z;
        float _793 = _790 * cb2_000z;
        float _794 = exp2(_791);
        float _795 = exp2(_792);
        float _796 = exp2(_793);
        float _797 = _794 * cb2_000y;
        float _798 = _795 * cb2_000y;
        float _799 = _796 * cb2_000y;
        float _800 = _797 + cb2_000x;
        float _801 = _798 + cb2_000x;
        float _802 = _799 + cb2_000x;
        float _803 = saturate(_800);
        float _804 = saturate(_801);
        float _805 = saturate(_802);
        _807 = _803;
        _808 = _804;
        _809 = _805;
      }
      float _813 = cb2_023x * TEXCOORD0_centroid.x;
      float _814 = cb2_023y * TEXCOORD0_centroid.y;
      float _817 = _813 + cb2_023z;
      float _818 = _814 + cb2_023w;
      float4 _821 = t9.SampleLevel(s0_space2, float2(_817, _818), 0.0f);
      float _823 = _821.x + -0.5f;
      float _824 = _823 * cb2_022x;
      float _825 = _824 + 0.5f;
      float _826 = _825 * 2.0f;
      float _827 = _826 * _807;
      float _828 = _826 * _808;
      float _829 = _826 * _809;
      float _833 = float((uint)(cb2_019z));
      float _834 = float((uint)(cb2_019w));
      float _835 = _833 + SV_Position.x;
      float _836 = _834 + SV_Position.y;
      uint _837 = uint(_835);
      uint _838 = uint(_836);
      uint _841 = cb2_019x + -1u;
      uint _842 = cb2_019y + -1u;
      int _843 = _837 & _841;
      int _844 = _838 & _842;
      float4 _845 = t3.Load(int3(_843, _844, 0));
      float _849 = _845.x * 2.0f;
      float _850 = _845.y * 2.0f;
      float _851 = _845.z * 2.0f;
      float _852 = _849 + -1.0f;
      float _853 = _850 + -1.0f;
      float _854 = _851 + -1.0f;
      float _855 = _852 * _559;
      float _856 = _853 * _559;
      float _857 = _854 * _559;
      float _858 = _855 + _827;
      float _859 = _856 + _828;
      float _860 = _857 + _829;
      float _861 = dot(float3(_858, _859, _860), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _858;
      SV_Target.y = _859;
      SV_Target.z = _860;
      SV_Target.w = _861;
      SV_Target_1.x = _861;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

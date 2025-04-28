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

Texture3D<float4> t5 : register(t5);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t7 : register(t7);

Texture3D<float2> t8 : register(t8);

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
  float cb2_020x : packoffset(c020.x);
  float cb2_020y : packoffset(c020.y);
  float cb2_020z : packoffset(c020.z);
  float cb2_020w : packoffset(c020.w);
  float cb2_021x : packoffset(c021.x);
  float cb2_021y : packoffset(c021.y);
  float cb2_021z : packoffset(c021.z);
  float cb2_021w : packoffset(c021.w);
  float cb2_024x : packoffset(c024.x);
  float cb2_024y : packoffset(c024.y);
  float cb2_024z : packoffset(c024.z);
  float cb2_024w : packoffset(c024.w);
  float cb2_025x : packoffset(c025.x);
  float cb2_025y : packoffset(c025.y);
  float cb2_025z : packoffset(c025.z);
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
  float _21 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _26 = cb2_015x * TEXCOORD0_centroid.x;
  float _27 = cb2_015y * TEXCOORD0_centroid.y;
  float _30 = _26 + cb2_015z;
  float _31 = _27 + cb2_015w;
  float4 _32 = t7.SampleLevel(s0_space2, float2(_30, _31), 0.0f);
  float _36 = saturate(_32.x);
  float _37 = saturate(_32.z);
  float _40 = cb2_026x * _37;
  float _41 = _36 * 6.283199787139893f;
  float _42 = cos(_41);
  float _43 = sin(_41);
  float _44 = _40 * _42;
  float _45 = _43 * _40;
  float _46 = 1.0f - _32.y;
  float _47 = saturate(_46);
  float _48 = _44 * _47;
  float _49 = _45 * _47;
  float _50 = _48 + TEXCOORD0_centroid.x;
  float _51 = _49 + TEXCOORD0_centroid.y;
  float4 _52 = t1.SampleLevel(s4_space2, float2(_50, _51), 0.0f);
  float _56 = max(_52.x, 0.0f);
  float _57 = max(_52.y, 0.0f);
  float _58 = max(_52.z, 0.0f);
  float _59 = min(_56, 65000.0f);
  float _60 = min(_57, 65000.0f);
  float _61 = min(_58, 65000.0f);
  float4 _62 = t3.SampleLevel(s2_space2, float2(_50, _51), 0.0f);
  float _67 = max(_62.x, 0.0f);
  float _68 = max(_62.y, 0.0f);
  float _69 = max(_62.z, 0.0f);
  float _70 = max(_62.w, 0.0f);
  float _71 = min(_67, 5000.0f);
  float _72 = min(_68, 5000.0f);
  float _73 = min(_69, 5000.0f);
  float _74 = min(_70, 5000.0f);
  float _77 = _21.x * cb0_028z;
  float _78 = _77 + cb0_028x;
  float _79 = cb2_027w / _78;
  float _80 = 1.0f - _79;
  float _81 = abs(_80);
  float _83 = cb2_027y * _81;
  float _85 = _83 - cb2_027z;
  float _86 = saturate(_85);
  float _87 = max(_86, _74);
  float _88 = saturate(_87);
  float _92 = cb2_013x * _50;
  float _93 = cb2_013y * _51;
  float _96 = _92 + cb2_013z;
  float _97 = _93 + cb2_013w;
  float _100 = dot(float2(_96, _97), float2(_96, _97));
  float _101 = abs(_100);
  float _102 = log2(_101);
  float _103 = _102 * cb2_014x;
  float _104 = exp2(_103);
  float _105 = saturate(_104);
  float _109 = cb2_011x * _50;
  float _110 = cb2_011y * _51;
  float _113 = _109 + cb2_011z;
  float _114 = _110 + cb2_011w;
  float _115 = _113 * _105;
  float _116 = _114 * _105;
  float _117 = _115 + _50;
  float _118 = _116 + _51;
  float _122 = cb2_012x * _50;
  float _123 = cb2_012y * _51;
  float _126 = _122 + cb2_012z;
  float _127 = _123 + cb2_012w;
  float _128 = _126 * _105;
  float _129 = _127 * _105;
  float _130 = _128 + _50;
  float _131 = _129 + _51;
  float4 _132 = t1.SampleLevel(s2_space2, float2(_117, _118), 0.0f);
  float _136 = max(_132.x, 0.0f);
  float _137 = max(_132.y, 0.0f);
  float _138 = max(_132.z, 0.0f);
  float _139 = min(_136, 65000.0f);
  float _140 = min(_137, 65000.0f);
  float _141 = min(_138, 65000.0f);
  float4 _142 = t1.SampleLevel(s2_space2, float2(_130, _131), 0.0f);
  float _146 = max(_142.x, 0.0f);
  float _147 = max(_142.y, 0.0f);
  float _148 = max(_142.z, 0.0f);
  float _149 = min(_146, 65000.0f);
  float _150 = min(_147, 65000.0f);
  float _151 = min(_148, 65000.0f);
  float4 _152 = t3.SampleLevel(s2_space2, float2(_117, _118), 0.0f);
  float _156 = max(_152.x, 0.0f);
  float _157 = max(_152.y, 0.0f);
  float _158 = max(_152.z, 0.0f);
  float _159 = min(_156, 5000.0f);
  float _160 = min(_157, 5000.0f);
  float _161 = min(_158, 5000.0f);
  float4 _162 = t3.SampleLevel(s2_space2, float2(_130, _131), 0.0f);
  float _166 = max(_162.x, 0.0f);
  float _167 = max(_162.y, 0.0f);
  float _168 = max(_162.z, 0.0f);
  float _169 = min(_166, 5000.0f);
  float _170 = min(_167, 5000.0f);
  float _171 = min(_168, 5000.0f);
  float _176 = 1.0f - cb2_009x;
  float _177 = 1.0f - cb2_009y;
  float _178 = 1.0f - cb2_009z;
  float _183 = _176 - cb2_010x;
  float _184 = _177 - cb2_010y;
  float _185 = _178 - cb2_010z;
  float _186 = saturate(_183);
  float _187 = saturate(_184);
  float _188 = saturate(_185);
  float _189 = _186 * _59;
  float _190 = _187 * _60;
  float _191 = _188 * _61;
  float _192 = cb2_009x * _139;
  float _193 = cb2_009y * _140;
  float _194 = cb2_009z * _141;
  float _195 = _192 + _189;
  float _196 = _193 + _190;
  float _197 = _194 + _191;
  float _198 = cb2_010x * _149;
  float _199 = cb2_010y * _150;
  float _200 = cb2_010z * _151;
  float _201 = _195 + _198;
  float _202 = _196 + _199;
  float _203 = _197 + _200;
  float _204 = _186 * _71;
  float _205 = _187 * _72;
  float _206 = _188 * _73;
  float _207 = cb2_009x * _159;
  float _208 = cb2_009y * _160;
  float _209 = cb2_009z * _161;
  float _210 = cb2_010x * _169;
  float _211 = cb2_010y * _170;
  float _212 = cb2_010z * _171;
  float4 _213 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _217 = _204 - _201;
  float _218 = _217 + _207;
  float _219 = _218 + _210;
  float _220 = _205 - _202;
  float _221 = _220 + _208;
  float _222 = _221 + _211;
  float _223 = _206 - _203;
  float _224 = _223 + _209;
  float _225 = _224 + _212;
  float _226 = _219 * _88;
  float _227 = _222 * _88;
  float _228 = _225 * _88;
  float _229 = _226 + _201;
  float _230 = _227 + _202;
  float _231 = _228 + _203;
  float _232 = dot(float3(_229, _230, _231), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _236 = t0[0].SExposureData_020;
  float _238 = t0[0].SExposureData_004;
  float _240 = cb2_018x * 0.5f;
  float _241 = _240 * cb2_018y;
  float _242 = _238.x - _241;
  float _243 = cb2_018y * cb2_018x;
  float _244 = 1.0f / _243;
  float _245 = _242 * _244;
  float _246 = _232 / _236.x;
  float _247 = _246 * 5464.01611328125f;
  float _248 = _247 + 9.99999993922529e-09f;
  float _249 = log2(_248);
  float _250 = _249 - _242;
  float _251 = _250 * _244;
  float _252 = saturate(_251);
  float2 _253 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _252), 0.0f);
  float _256 = max(_253.y, 1.0000000116860974e-07f);
  float _257 = _253.x / _256;
  float _258 = _257 + _245;
  float _259 = _258 / _244;
  float _260 = _259 - _238.x;
  float _261 = -0.0f - _260;
  float _263 = _261 - cb2_027x;
  float _264 = max(0.0f, _263);
  float _266 = cb2_026z * _264;
  float _267 = _260 - cb2_027x;
  float _268 = max(0.0f, _267);
  float _270 = cb2_026w * _268;
  bool _271 = (_260 < 0.0f);
  float _272 = select(_271, _266, _270);
  float _273 = exp2(_272);
  float _274 = _273 * _229;
  float _275 = _273 * _230;
  float _276 = _273 * _231;
  float _281 = cb2_024y * _213.x;
  float _282 = cb2_024z * _213.y;
  float _283 = cb2_024w * _213.z;
  float _284 = _281 + _274;
  float _285 = _282 + _275;
  float _286 = _283 + _276;
  float _291 = _284 * cb2_025x;
  float _292 = _285 * cb2_025y;
  float _293 = _286 * cb2_025z;
  float _294 = dot(float3(_291, _292, _293), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _295 = t0[0].SExposureData_012;
  float _297 = _294 * 5464.01611328125f;
  float _298 = _297 * _295.x;
  float _299 = _298 + 9.99999993922529e-09f;
  float _300 = log2(_299);
  float _301 = _300 + 16.929765701293945f;
  float _302 = _301 * 0.05734497308731079f;
  float _303 = saturate(_302);
  float _304 = _303 * _303;
  float _305 = _303 * 2.0f;
  float _306 = 3.0f - _305;
  float _307 = _304 * _306;
  float _308 = _292 * 0.8450999855995178f;
  float _309 = _293 * 0.14589999616146088f;
  float _310 = _308 + _309;
  float _311 = _310 * 2.4890189170837402f;
  float _312 = _310 * 0.3754962384700775f;
  float _313 = _310 * 2.811495304107666f;
  float _314 = _310 * 5.519708156585693f;
  float _315 = _294 - _311;
  float _316 = _307 * _315;
  float _317 = _316 + _311;
  float _318 = _307 * 0.5f;
  float _319 = _318 + 0.5f;
  float _320 = _319 * _315;
  float _321 = _320 + _311;
  float _322 = _291 - _312;
  float _323 = _292 - _313;
  float _324 = _293 - _314;
  float _325 = _319 * _322;
  float _326 = _319 * _323;
  float _327 = _319 * _324;
  float _328 = _325 + _312;
  float _329 = _326 + _313;
  float _330 = _327 + _314;
  float _331 = 1.0f / _321;
  float _332 = _317 * _331;
  float _333 = _332 * _328;
  float _334 = _332 * _329;
  float _335 = _332 * _330;
  float _339 = cb2_020x * TEXCOORD0_centroid.x;
  float _340 = cb2_020y * TEXCOORD0_centroid.y;
  float _343 = _339 + cb2_020z;
  float _344 = _340 + cb2_020w;
  float _347 = dot(float2(_343, _344), float2(_343, _344));
  float _348 = 1.0f - _347;
  float _349 = saturate(_348);
  float _350 = log2(_349);
  float _351 = _350 * cb2_021w;
  float _352 = exp2(_351);
  float _356 = _333 - cb2_021x;
  float _357 = _334 - cb2_021y;
  float _358 = _335 - cb2_021z;
  float _359 = _356 * _352;
  float _360 = _357 * _352;
  float _361 = _358 * _352;
  float _362 = _359 + cb2_021x;
  float _363 = _360 + cb2_021y;
  float _364 = _361 + cb2_021z;
  float _365 = t0[0].SExposureData_000;
  float _367 = max(_236.x, 0.0010000000474974513f);
  float _368 = 1.0f / _367;
  float _369 = _368 * _365.x;
  bool _372 = ((uint)(cb2_069y) == 0);
  float _378;
  float _379;
  float _380;
  float _434;
  float _435;
  float _436;
  float _481;
  float _482;
  float _483;
  float _528;
  float _529;
  float _530;
  float _531;
  float _578;
  float _579;
  float _580;
  float _605;
  float _606;
  float _607;
  float _708;
  float _709;
  float _710;
  float _735;
  float _747;
  float _775;
  float _787;
  float _799;
  float _800;
  float _801;
  float _828;
  float _829;
  float _830;
  if (!_372) {
    float _374 = _369 * _362;
    float _375 = _369 * _363;
    float _376 = _369 * _364;
    _378 = _374;
    _379 = _375;
    _380 = _376;
  } else {
    _378 = _362;
    _379 = _363;
    _380 = _364;
  }
  float _381 = _378 * 0.6130970120429993f;
  float _382 = mad(0.33952298760414124f, _379, _381);
  float _383 = mad(0.04737899824976921f, _380, _382);
  float _384 = _378 * 0.07019399851560593f;
  float _385 = mad(0.9163540005683899f, _379, _384);
  float _386 = mad(0.013451999984681606f, _380, _385);
  float _387 = _378 * 0.02061600051820278f;
  float _388 = mad(0.10956999659538269f, _379, _387);
  float _389 = mad(0.8698149919509888f, _380, _388);
  float _390 = log2(_383);
  float _391 = log2(_386);
  float _392 = log2(_389);
  float _393 = _390 * 0.04211956635117531f;
  float _394 = _391 * 0.04211956635117531f;
  float _395 = _392 * 0.04211956635117531f;
  float _396 = _393 + 0.6252607107162476f;
  float _397 = _394 + 0.6252607107162476f;
  float _398 = _395 + 0.6252607107162476f;
  float4 _399 = t5.SampleLevel(s2_space2, float3(_396, _397, _398), 0.0f);
  bool _405 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_405 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _409 = cb2_017x * _399.x;
    float _410 = cb2_017x * _399.y;
    float _411 = cb2_017x * _399.z;
    float _413 = _409 + cb2_017y;
    float _414 = _410 + cb2_017y;
    float _415 = _411 + cb2_017y;
    float _416 = exp2(_413);
    float _417 = exp2(_414);
    float _418 = exp2(_415);
    float _419 = _416 + 1.0f;
    float _420 = _417 + 1.0f;
    float _421 = _418 + 1.0f;
    float _422 = 1.0f / _419;
    float _423 = 1.0f / _420;
    float _424 = 1.0f / _421;
    float _426 = cb2_017z * _422;
    float _427 = cb2_017z * _423;
    float _428 = cb2_017z * _424;
    float _430 = _426 + cb2_017w;
    float _431 = _427 + cb2_017w;
    float _432 = _428 + cb2_017w;
    _434 = _430;
    _435 = _431;
    _436 = _432;
  } else {
    _434 = _399.x;
    _435 = _399.y;
    _436 = _399.z;
  }
  float _437 = _434 * 23.0f;
  float _438 = _437 + -14.473931312561035f;
  float _439 = exp2(_438);
  float _440 = _435 * 23.0f;
  float _441 = _440 + -14.473931312561035f;
  float _442 = exp2(_441);
  float _443 = _436 * 23.0f;
  float _444 = _443 + -14.473931312561035f;
  float _445 = exp2(_444);
  float _449 = cb2_004x * TEXCOORD0_centroid.x;
  float _450 = cb2_004y * TEXCOORD0_centroid.y;
  float _453 = _449 + cb2_004z;
  float _454 = _450 + cb2_004w;
  float4 _460 = t6.Sample(s2_space2, float2(_453, _454));
  float _465 = _460.x * cb2_003x;
  float _466 = _460.y * cb2_003y;
  float _467 = _460.z * cb2_003z;
  float _468 = _460.w * cb2_003w;
  float _471 = _468 + cb2_026y;
  float _472 = saturate(_471);
  bool _475 = ((uint)(cb2_069y) == 0);
  if (!_475) {
    float _477 = _465 * _369;
    float _478 = _466 * _369;
    float _479 = _467 * _369;
    _481 = _477;
    _482 = _478;
    _483 = _479;
  } else {
    _481 = _465;
    _482 = _466;
    _483 = _467;
  }
  bool _486 = ((uint)(cb2_028x) == 2);
  bool _487 = ((uint)(cb2_028x) == 3);
  int _488 = (uint)(cb2_028x) & -2;
  bool _489 = (_488 == 2);
  bool _490 = ((uint)(cb2_028x) == 6);
  bool _491 = _489 || _490;
  if (_491) {
    float _493 = _481 * _472;
    float _494 = _482 * _472;
    float _495 = _483 * _472;
    float _496 = _472 * _472;
    _528 = _493;
    _529 = _494;
    _530 = _495;
    _531 = _496;
  } else {
    bool _498 = ((uint)(cb2_028x) == 4);
    if (_498) {
      float _500 = _481 + -1.0f;
      float _501 = _482 + -1.0f;
      float _502 = _483 + -1.0f;
      float _503 = _472 + -1.0f;
      float _504 = _500 * _472;
      float _505 = _501 * _472;
      float _506 = _502 * _472;
      float _507 = _503 * _472;
      float _508 = _504 + 1.0f;
      float _509 = _505 + 1.0f;
      float _510 = _506 + 1.0f;
      float _511 = _507 + 1.0f;
      _528 = _508;
      _529 = _509;
      _530 = _510;
      _531 = _511;
    } else {
      bool _513 = ((uint)(cb2_028x) == 5);
      if (_513) {
        float _515 = _481 + -0.5f;
        float _516 = _482 + -0.5f;
        float _517 = _483 + -0.5f;
        float _518 = _472 + -0.5f;
        float _519 = _515 * _472;
        float _520 = _516 * _472;
        float _521 = _517 * _472;
        float _522 = _518 * _472;
        float _523 = _519 + 0.5f;
        float _524 = _520 + 0.5f;
        float _525 = _521 + 0.5f;
        float _526 = _522 + 0.5f;
        _528 = _523;
        _529 = _524;
        _530 = _525;
        _531 = _526;
      } else {
        _528 = _481;
        _529 = _482;
        _530 = _483;
        _531 = _472;
      }
    }
  }
  if (_486) {
    float _533 = _528 + _439;
    float _534 = _529 + _442;
    float _535 = _530 + _445;
    _578 = _533;
    _579 = _534;
    _580 = _535;
  } else {
    if (_487) {
      float _538 = 1.0f - _528;
      float _539 = 1.0f - _529;
      float _540 = 1.0f - _530;
      float _541 = _538 * _439;
      float _542 = _539 * _442;
      float _543 = _540 * _445;
      float _544 = _541 + _528;
      float _545 = _542 + _529;
      float _546 = _543 + _530;
      _578 = _544;
      _579 = _545;
      _580 = _546;
    } else {
      bool _548 = ((uint)(cb2_028x) == 4);
      if (_548) {
        float _550 = _528 * _439;
        float _551 = _529 * _442;
        float _552 = _530 * _445;
        _578 = _550;
        _579 = _551;
        _580 = _552;
      } else {
        bool _554 = ((uint)(cb2_028x) == 5);
        if (_554) {
          float _556 = _439 * 2.0f;
          float _557 = _556 * _528;
          float _558 = _442 * 2.0f;
          float _559 = _558 * _529;
          float _560 = _445 * 2.0f;
          float _561 = _560 * _530;
          _578 = _557;
          _579 = _559;
          _580 = _561;
        } else {
          if (_490) {
            float _564 = _439 - _528;
            float _565 = _442 - _529;
            float _566 = _445 - _530;
            _578 = _564;
            _579 = _565;
            _580 = _566;
          } else {
            float _568 = _528 - _439;
            float _569 = _529 - _442;
            float _570 = _530 - _445;
            float _571 = _531 * _568;
            float _572 = _531 * _569;
            float _573 = _531 * _570;
            float _574 = _571 + _439;
            float _575 = _572 + _442;
            float _576 = _573 + _445;
            _578 = _574;
            _579 = _575;
            _580 = _576;
          }
        }
      }
    }
  }
  float _586 = cb2_016x - _578;
  float _587 = cb2_016y - _579;
  float _588 = cb2_016z - _580;
  float _589 = _586 * cb2_016w;
  float _590 = _587 * cb2_016w;
  float _591 = _588 * cb2_016w;
  float _592 = _589 + _578;
  float _593 = _590 + _579;
  float _594 = _591 + _580;
  bool _597 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_597 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _601 = cb2_024x * _592;
    float _602 = cb2_024x * _593;
    float _603 = cb2_024x * _594;
    _605 = _601;
    _606 = _602;
    _607 = _603;
  } else {
    _605 = _592;
    _606 = _593;
    _607 = _594;
  }
  float _608 = _605 * 0.9708889722824097f;
  float _609 = mad(0.026962999254465103f, _606, _608);
  float _610 = mad(0.002148000057786703f, _607, _609);
  float _611 = _605 * 0.01088900025933981f;
  float _612 = mad(0.9869629740715027f, _606, _611);
  float _613 = mad(0.002148000057786703f, _607, _612);
  float _614 = mad(0.026962999254465103f, _606, _611);
  float _615 = mad(0.9621480107307434f, _607, _614);
  if (_597) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _620 = cb1_018y * 0.10000000149011612f;
        float _621 = log2(cb1_018z);
        float _622 = _621 + -13.287712097167969f;
        float _623 = _622 * 1.4929734468460083f;
        float _624 = _623 + 18.0f;
        float _625 = exp2(_624);
        float _626 = _625 * 0.18000000715255737f;
        float _627 = abs(_626);
        float _628 = log2(_627);
        float _629 = _628 * 1.5f;
        float _630 = exp2(_629);
        float _631 = _630 * _620;
        float _632 = _631 / cb1_018z;
        float _633 = _632 + -0.07636754959821701f;
        float _634 = _628 * 1.2750000953674316f;
        float _635 = exp2(_634);
        float _636 = _635 * 0.07636754959821701f;
        float _637 = cb1_018y * 0.011232397519052029f;
        float _638 = _637 * _630;
        float _639 = _638 / cb1_018z;
        float _640 = _636 - _639;
        float _641 = _635 + -0.11232396960258484f;
        float _642 = _641 * _620;
        float _643 = _642 / cb1_018z;
        float _644 = _643 * cb1_018z;
        float _645 = abs(_610);
        float _646 = abs(_613);
        float _647 = abs(_615);
        float _648 = log2(_645);
        float _649 = log2(_646);
        float _650 = log2(_647);
        float _651 = _648 * 1.5f;
        float _652 = _649 * 1.5f;
        float _653 = _650 * 1.5f;
        float _654 = exp2(_651);
        float _655 = exp2(_652);
        float _656 = exp2(_653);
        float _657 = _654 * _644;
        float _658 = _655 * _644;
        float _659 = _656 * _644;
        float _660 = _648 * 1.2750000953674316f;
        float _661 = _649 * 1.2750000953674316f;
        float _662 = _650 * 1.2750000953674316f;
        float _663 = exp2(_660);
        float _664 = exp2(_661);
        float _665 = exp2(_662);
        float _666 = _663 * _633;
        float _667 = _664 * _633;
        float _668 = _665 * _633;
        float _669 = _666 + _640;
        float _670 = _667 + _640;
        float _671 = _668 + _640;
        float _672 = _657 / _669;
        float _673 = _658 / _670;
        float _674 = _659 / _671;
        float _675 = _672 * 9.999999747378752e-05f;
        float _676 = _673 * 9.999999747378752e-05f;
        float _677 = _674 * 9.999999747378752e-05f;
        float _678 = 5000.0f / cb1_018y;
        float _679 = _675 * _678;
        float _680 = _676 * _678;
        float _681 = _677 * _678;
        _708 = _679;
        _709 = _680;
        _710 = _681;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_610, _613, _615));
      _708 = tonemapped.x, _709 = tonemapped.y, _710 = tonemapped.z;
    }
      } else {
        float _683 = _610 + 0.020616600289940834f;
        float _684 = _613 + 0.020616600289940834f;
        float _685 = _615 + 0.020616600289940834f;
        float _686 = _683 * _610;
        float _687 = _684 * _613;
        float _688 = _685 * _615;
        float _689 = _686 + -7.456949970219284e-05f;
        float _690 = _687 + -7.456949970219284e-05f;
        float _691 = _688 + -7.456949970219284e-05f;
        float _692 = _610 * 0.9837960004806519f;
        float _693 = _613 * 0.9837960004806519f;
        float _694 = _615 * 0.9837960004806519f;
        float _695 = _692 + 0.4336790144443512f;
        float _696 = _693 + 0.4336790144443512f;
        float _697 = _694 + 0.4336790144443512f;
        float _698 = _695 * _610;
        float _699 = _696 * _613;
        float _700 = _697 * _615;
        float _701 = _698 + 0.24617899954319f;
        float _702 = _699 + 0.24617899954319f;
        float _703 = _700 + 0.24617899954319f;
        float _704 = _689 / _701;
        float _705 = _690 / _702;
        float _706 = _691 / _703;
        _708 = _704;
        _709 = _705;
        _710 = _706;
      }
      float _711 = _708 * 1.6047500371932983f;
      float _712 = mad(-0.5310800075531006f, _709, _711);
      float _713 = mad(-0.07366999983787537f, _710, _712);
      float _714 = _708 * -0.10208000242710114f;
      float _715 = mad(1.1081299781799316f, _709, _714);
      float _716 = mad(-0.006049999967217445f, _710, _715);
      float _717 = _708 * -0.0032599999103695154f;
      float _718 = mad(-0.07275000214576721f, _709, _717);
      float _719 = mad(1.0760200023651123f, _710, _718);
      if (_597) {
        // float _721 = max(_713, 0.0f);
        // float _722 = max(_716, 0.0f);
        // float _723 = max(_719, 0.0f);
        // bool _724 = !(_721 >= 0.0030399328097701073f);
        // if (!_724) {
        //   float _726 = abs(_721);
        //   float _727 = log2(_726);
        //   float _728 = _727 * 0.4166666567325592f;
        //   float _729 = exp2(_728);
        //   float _730 = _729 * 1.0549999475479126f;
        //   float _731 = _730 + -0.054999999701976776f;
        //   _735 = _731;
        // } else {
        //   float _733 = _721 * 12.923210144042969f;
        //   _735 = _733;
        // }
        // bool _736 = !(_722 >= 0.0030399328097701073f);
        // if (!_736) {
        //   float _738 = abs(_722);
        //   float _739 = log2(_738);
        //   float _740 = _739 * 0.4166666567325592f;
        //   float _741 = exp2(_740);
        //   float _742 = _741 * 1.0549999475479126f;
        //   float _743 = _742 + -0.054999999701976776f;
        //   _747 = _743;
        // } else {
        //   float _745 = _722 * 12.923210144042969f;
        //   _747 = _745;
        // }
        // bool _748 = !(_723 >= 0.0030399328097701073f);
        // if (!_748) {
        //   float _750 = abs(_723);
        //   float _751 = log2(_750);
        //   float _752 = _751 * 0.4166666567325592f;
        //   float _753 = exp2(_752);
        //   float _754 = _753 * 1.0549999475479126f;
        //   float _755 = _754 + -0.054999999701976776f;
        //   _828 = _735;
        //   _829 = _747;
        //   _830 = _755;
        // } else {
        //   float _757 = _723 * 12.923210144042969f;
        //   _828 = _735;
        //   _829 = _747;
        //   _830 = _757;
        // }
        _828 = renodx::color::srgb::EncodeSafe(_713);
        _829 = renodx::color::srgb::EncodeSafe(_716);
        _830 = renodx::color::srgb::EncodeSafe(_719);

      } else {
        float _759 = saturate(_713);
        float _760 = saturate(_716);
        float _761 = saturate(_719);
        bool _762 = ((uint)(cb1_018w) == -2);
        if (!_762) {
          bool _764 = !(_759 >= 0.0030399328097701073f);
          if (!_764) {
            float _766 = abs(_759);
            float _767 = log2(_766);
            float _768 = _767 * 0.4166666567325592f;
            float _769 = exp2(_768);
            float _770 = _769 * 1.0549999475479126f;
            float _771 = _770 + -0.054999999701976776f;
            _775 = _771;
          } else {
            float _773 = _759 * 12.923210144042969f;
            _775 = _773;
          }
          bool _776 = !(_760 >= 0.0030399328097701073f);
          if (!_776) {
            float _778 = abs(_760);
            float _779 = log2(_778);
            float _780 = _779 * 0.4166666567325592f;
            float _781 = exp2(_780);
            float _782 = _781 * 1.0549999475479126f;
            float _783 = _782 + -0.054999999701976776f;
            _787 = _783;
          } else {
            float _785 = _760 * 12.923210144042969f;
            _787 = _785;
          }
          bool _788 = !(_761 >= 0.0030399328097701073f);
          if (!_788) {
            float _790 = abs(_761);
            float _791 = log2(_790);
            float _792 = _791 * 0.4166666567325592f;
            float _793 = exp2(_792);
            float _794 = _793 * 1.0549999475479126f;
            float _795 = _794 + -0.054999999701976776f;
            _799 = _775;
            _800 = _787;
            _801 = _795;
          } else {
            float _797 = _761 * 12.923210144042969f;
            _799 = _775;
            _800 = _787;
            _801 = _797;
          }
        } else {
          _799 = _759;
          _800 = _760;
          _801 = _761;
        }
        float _806 = abs(_799);
        float _807 = abs(_800);
        float _808 = abs(_801);
        float _809 = log2(_806);
        float _810 = log2(_807);
        float _811 = log2(_808);
        float _812 = _809 * cb2_000z;
        float _813 = _810 * cb2_000z;
        float _814 = _811 * cb2_000z;
        float _815 = exp2(_812);
        float _816 = exp2(_813);
        float _817 = exp2(_814);
        float _818 = _815 * cb2_000y;
        float _819 = _816 * cb2_000y;
        float _820 = _817 * cb2_000y;
        float _821 = _818 + cb2_000x;
        float _822 = _819 + cb2_000x;
        float _823 = _820 + cb2_000x;
        float _824 = saturate(_821);
        float _825 = saturate(_822);
        float _826 = saturate(_823);
        _828 = _824;
        _829 = _825;
        _830 = _826;
      }
      float _831 = dot(float3(_828, _829, _830), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _828;
      SV_Target.y = _829;
      SV_Target.z = _830;
      SV_Target.w = _831;
      SV_Target_1.x = _831;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

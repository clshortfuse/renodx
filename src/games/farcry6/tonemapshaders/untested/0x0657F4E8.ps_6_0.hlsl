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
  float _526;
  float _527;
  float _528;
  float _573;
  float _574;
  float _575;
  float _576;
  float _623;
  float _624;
  float _625;
  float _650;
  float _651;
  float _652;
  float _753;
  float _754;
  float _755;
  float _780;
  float _792;
  float _820;
  float _832;
  float _844;
  float _845;
  float _846;
  float _873;
  float _874;
  float _875;
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
  float _446 = dot(float3(_439, _442, _445), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _451 = dot(float3(_439, _442, _445), float3(_439, _442, _445));
  float _452 = rsqrt(_451);
  float _453 = _452 * _439;
  float _454 = _452 * _442;
  float _455 = _452 * _445;
  float _456 = cb2_001x - _453;
  float _457 = cb2_001y - _454;
  float _458 = cb2_001z - _455;
  float _459 = dot(float3(_456, _457, _458), float3(_456, _457, _458));
  float _462 = cb2_002z * _459;
  float _464 = _462 + cb2_002w;
  float _465 = saturate(_464);
  float _467 = cb2_002x * _465;
  float _468 = _446 - _439;
  float _469 = _446 - _442;
  float _470 = _446 - _445;
  float _471 = _467 * _468;
  float _472 = _467 * _469;
  float _473 = _467 * _470;
  float _474 = _471 + _439;
  float _475 = _472 + _442;
  float _476 = _473 + _445;
  float _478 = cb2_002y * _465;
  float _479 = 0.10000000149011612f - _474;
  float _480 = 0.10000000149011612f - _475;
  float _481 = 0.10000000149011612f - _476;
  float _482 = _479 * _478;
  float _483 = _480 * _478;
  float _484 = _481 * _478;
  float _485 = _482 + _474;
  float _486 = _483 + _475;
  float _487 = _484 + _476;
  float _488 = saturate(_485);
  float _489 = saturate(_486);
  float _490 = saturate(_487);
  float _494 = cb2_004x * TEXCOORD0_centroid.x;
  float _495 = cb2_004y * TEXCOORD0_centroid.y;
  float _498 = _494 + cb2_004z;
  float _499 = _495 + cb2_004w;
  float4 _505 = t6.Sample(s2_space2, float2(_498, _499));
  float _510 = _505.x * cb2_003x;
  float _511 = _505.y * cb2_003y;
  float _512 = _505.z * cb2_003z;
  float _513 = _505.w * cb2_003w;
  float _516 = _513 + cb2_026y;
  float _517 = saturate(_516);
  bool _520 = ((uint)(cb2_069y) == 0);
  if (!_520) {
    float _522 = _510 * _369;
    float _523 = _511 * _369;
    float _524 = _512 * _369;
    _526 = _522;
    _527 = _523;
    _528 = _524;
  } else {
    _526 = _510;
    _527 = _511;
    _528 = _512;
  }
  bool _531 = ((uint)(cb2_028x) == 2);
  bool _532 = ((uint)(cb2_028x) == 3);
  int _533 = (uint)(cb2_028x) & -2;
  bool _534 = (_533 == 2);
  bool _535 = ((uint)(cb2_028x) == 6);
  bool _536 = _534 || _535;
  if (_536) {
    float _538 = _526 * _517;
    float _539 = _527 * _517;
    float _540 = _528 * _517;
    float _541 = _517 * _517;
    _573 = _538;
    _574 = _539;
    _575 = _540;
    _576 = _541;
  } else {
    bool _543 = ((uint)(cb2_028x) == 4);
    if (_543) {
      float _545 = _526 + -1.0f;
      float _546 = _527 + -1.0f;
      float _547 = _528 + -1.0f;
      float _548 = _517 + -1.0f;
      float _549 = _545 * _517;
      float _550 = _546 * _517;
      float _551 = _547 * _517;
      float _552 = _548 * _517;
      float _553 = _549 + 1.0f;
      float _554 = _550 + 1.0f;
      float _555 = _551 + 1.0f;
      float _556 = _552 + 1.0f;
      _573 = _553;
      _574 = _554;
      _575 = _555;
      _576 = _556;
    } else {
      bool _558 = ((uint)(cb2_028x) == 5);
      if (_558) {
        float _560 = _526 + -0.5f;
        float _561 = _527 + -0.5f;
        float _562 = _528 + -0.5f;
        float _563 = _517 + -0.5f;
        float _564 = _560 * _517;
        float _565 = _561 * _517;
        float _566 = _562 * _517;
        float _567 = _563 * _517;
        float _568 = _564 + 0.5f;
        float _569 = _565 + 0.5f;
        float _570 = _566 + 0.5f;
        float _571 = _567 + 0.5f;
        _573 = _568;
        _574 = _569;
        _575 = _570;
        _576 = _571;
      } else {
        _573 = _526;
        _574 = _527;
        _575 = _528;
        _576 = _517;
      }
    }
  }
  if (_531) {
    float _578 = _573 + _488;
    float _579 = _574 + _489;
    float _580 = _575 + _490;
    _623 = _578;
    _624 = _579;
    _625 = _580;
  } else {
    if (_532) {
      float _583 = 1.0f - _573;
      float _584 = 1.0f - _574;
      float _585 = 1.0f - _575;
      float _586 = _583 * _488;
      float _587 = _584 * _489;
      float _588 = _585 * _490;
      float _589 = _586 + _573;
      float _590 = _587 + _574;
      float _591 = _588 + _575;
      _623 = _589;
      _624 = _590;
      _625 = _591;
    } else {
      bool _593 = ((uint)(cb2_028x) == 4);
      if (_593) {
        float _595 = _573 * _488;
        float _596 = _574 * _489;
        float _597 = _575 * _490;
        _623 = _595;
        _624 = _596;
        _625 = _597;
      } else {
        bool _599 = ((uint)(cb2_028x) == 5);
        if (_599) {
          float _601 = _488 * 2.0f;
          float _602 = _601 * _573;
          float _603 = _489 * 2.0f;
          float _604 = _603 * _574;
          float _605 = _490 * 2.0f;
          float _606 = _605 * _575;
          _623 = _602;
          _624 = _604;
          _625 = _606;
        } else {
          if (_535) {
            float _609 = _488 - _573;
            float _610 = _489 - _574;
            float _611 = _490 - _575;
            _623 = _609;
            _624 = _610;
            _625 = _611;
          } else {
            float _613 = _573 - _488;
            float _614 = _574 - _489;
            float _615 = _575 - _490;
            float _616 = _576 * _613;
            float _617 = _576 * _614;
            float _618 = _576 * _615;
            float _619 = _616 + _488;
            float _620 = _617 + _489;
            float _621 = _618 + _490;
            _623 = _619;
            _624 = _620;
            _625 = _621;
          }
        }
      }
    }
  }
  float _631 = cb2_016x - _623;
  float _632 = cb2_016y - _624;
  float _633 = cb2_016z - _625;
  float _634 = _631 * cb2_016w;
  float _635 = _632 * cb2_016w;
  float _636 = _633 * cb2_016w;
  float _637 = _634 + _623;
  float _638 = _635 + _624;
  float _639 = _636 + _625;
  bool _642 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_642 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _646 = cb2_024x * _637;
    float _647 = cb2_024x * _638;
    float _648 = cb2_024x * _639;
    _650 = _646;
    _651 = _647;
    _652 = _648;
  } else {
    _650 = _637;
    _651 = _638;
    _652 = _639;
  }
  float _653 = _650 * 0.9708889722824097f;
  float _654 = mad(0.026962999254465103f, _651, _653);
  float _655 = mad(0.002148000057786703f, _652, _654);
  float _656 = _650 * 0.01088900025933981f;
  float _657 = mad(0.9869629740715027f, _651, _656);
  float _658 = mad(0.002148000057786703f, _652, _657);
  float _659 = mad(0.026962999254465103f, _651, _656);
  float _660 = mad(0.9621480107307434f, _652, _659);
  if (_642) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _665 = cb1_018y * 0.10000000149011612f;
        float _666 = log2(cb1_018z);
        float _667 = _666 + -13.287712097167969f;
        float _668 = _667 * 1.4929734468460083f;
        float _669 = _668 + 18.0f;
        float _670 = exp2(_669);
        float _671 = _670 * 0.18000000715255737f;
        float _672 = abs(_671);
        float _673 = log2(_672);
        float _674 = _673 * 1.5f;
        float _675 = exp2(_674);
        float _676 = _675 * _665;
        float _677 = _676 / cb1_018z;
        float _678 = _677 + -0.07636754959821701f;
        float _679 = _673 * 1.2750000953674316f;
        float _680 = exp2(_679);
        float _681 = _680 * 0.07636754959821701f;
        float _682 = cb1_018y * 0.011232397519052029f;
        float _683 = _682 * _675;
        float _684 = _683 / cb1_018z;
        float _685 = _681 - _684;
        float _686 = _680 + -0.11232396960258484f;
        float _687 = _686 * _665;
        float _688 = _687 / cb1_018z;
        float _689 = _688 * cb1_018z;
        float _690 = abs(_655);
        float _691 = abs(_658);
        float _692 = abs(_660);
        float _693 = log2(_690);
        float _694 = log2(_691);
        float _695 = log2(_692);
        float _696 = _693 * 1.5f;
        float _697 = _694 * 1.5f;
        float _698 = _695 * 1.5f;
        float _699 = exp2(_696);
        float _700 = exp2(_697);
        float _701 = exp2(_698);
        float _702 = _699 * _689;
        float _703 = _700 * _689;
        float _704 = _701 * _689;
        float _705 = _693 * 1.2750000953674316f;
        float _706 = _694 * 1.2750000953674316f;
        float _707 = _695 * 1.2750000953674316f;
        float _708 = exp2(_705);
        float _709 = exp2(_706);
        float _710 = exp2(_707);
        float _711 = _708 * _678;
        float _712 = _709 * _678;
        float _713 = _710 * _678;
        float _714 = _711 + _685;
        float _715 = _712 + _685;
        float _716 = _713 + _685;
        float _717 = _702 / _714;
        float _718 = _703 / _715;
        float _719 = _704 / _716;
        float _720 = _717 * 9.999999747378752e-05f;
        float _721 = _718 * 9.999999747378752e-05f;
        float _722 = _719 * 9.999999747378752e-05f;
        float _723 = 5000.0f / cb1_018y;
        float _724 = _720 * _723;
        float _725 = _721 * _723;
        float _726 = _722 * _723;
        _753 = _724;
        _754 = _725;
        _755 = _726;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_655, _658, _660));
      _753 = tonemapped.x, _754 = tonemapped.y, _755 = tonemapped.z;
    }
      } else {
        float _728 = _655 + 0.020616600289940834f;
        float _729 = _658 + 0.020616600289940834f;
        float _730 = _660 + 0.020616600289940834f;
        float _731 = _728 * _655;
        float _732 = _729 * _658;
        float _733 = _730 * _660;
        float _734 = _731 + -7.456949970219284e-05f;
        float _735 = _732 + -7.456949970219284e-05f;
        float _736 = _733 + -7.456949970219284e-05f;
        float _737 = _655 * 0.9837960004806519f;
        float _738 = _658 * 0.9837960004806519f;
        float _739 = _660 * 0.9837960004806519f;
        float _740 = _737 + 0.4336790144443512f;
        float _741 = _738 + 0.4336790144443512f;
        float _742 = _739 + 0.4336790144443512f;
        float _743 = _740 * _655;
        float _744 = _741 * _658;
        float _745 = _742 * _660;
        float _746 = _743 + 0.24617899954319f;
        float _747 = _744 + 0.24617899954319f;
        float _748 = _745 + 0.24617899954319f;
        float _749 = _734 / _746;
        float _750 = _735 / _747;
        float _751 = _736 / _748;
        _753 = _749;
        _754 = _750;
        _755 = _751;
      }
      float _756 = _753 * 1.6047500371932983f;
      float _757 = mad(-0.5310800075531006f, _754, _756);
      float _758 = mad(-0.07366999983787537f, _755, _757);
      float _759 = _753 * -0.10208000242710114f;
      float _760 = mad(1.1081299781799316f, _754, _759);
      float _761 = mad(-0.006049999967217445f, _755, _760);
      float _762 = _753 * -0.0032599999103695154f;
      float _763 = mad(-0.07275000214576721f, _754, _762);
      float _764 = mad(1.0760200023651123f, _755, _763);
      if (_642) {
        // float _766 = max(_758, 0.0f);
        // float _767 = max(_761, 0.0f);
        // float _768 = max(_764, 0.0f);
        // bool _769 = !(_766 >= 0.0030399328097701073f);
        // if (!_769) {
        //   float _771 = abs(_766);
        //   float _772 = log2(_771);
        //   float _773 = _772 * 0.4166666567325592f;
        //   float _774 = exp2(_773);
        //   float _775 = _774 * 1.0549999475479126f;
        //   float _776 = _775 + -0.054999999701976776f;
        //   _780 = _776;
        // } else {
        //   float _778 = _766 * 12.923210144042969f;
        //   _780 = _778;
        // }
        // bool _781 = !(_767 >= 0.0030399328097701073f);
        // if (!_781) {
        //   float _783 = abs(_767);
        //   float _784 = log2(_783);
        //   float _785 = _784 * 0.4166666567325592f;
        //   float _786 = exp2(_785);
        //   float _787 = _786 * 1.0549999475479126f;
        //   float _788 = _787 + -0.054999999701976776f;
        //   _792 = _788;
        // } else {
        //   float _790 = _767 * 12.923210144042969f;
        //   _792 = _790;
        // }
        // bool _793 = !(_768 >= 0.0030399328097701073f);
        // if (!_793) {
        //   float _795 = abs(_768);
        //   float _796 = log2(_795);
        //   float _797 = _796 * 0.4166666567325592f;
        //   float _798 = exp2(_797);
        //   float _799 = _798 * 1.0549999475479126f;
        //   float _800 = _799 + -0.054999999701976776f;
        //   _873 = _780;
        //   _874 = _792;
        //   _875 = _800;
        // } else {
        //   float _802 = _768 * 12.923210144042969f;
        //   _873 = _780;
        //   _874 = _792;
        //   _875 = _802;
        // }
        _873 = renodx::color::srgb::EncodeSafe(_758);
        _874 = renodx::color::srgb::EncodeSafe(_761);
        _875 = renodx::color::srgb::EncodeSafe(_764);

      } else {
        float _804 = saturate(_758);
        float _805 = saturate(_761);
        float _806 = saturate(_764);
        bool _807 = ((uint)(cb1_018w) == -2);
        if (!_807) {
          bool _809 = !(_804 >= 0.0030399328097701073f);
          if (!_809) {
            float _811 = abs(_804);
            float _812 = log2(_811);
            float _813 = _812 * 0.4166666567325592f;
            float _814 = exp2(_813);
            float _815 = _814 * 1.0549999475479126f;
            float _816 = _815 + -0.054999999701976776f;
            _820 = _816;
          } else {
            float _818 = _804 * 12.923210144042969f;
            _820 = _818;
          }
          bool _821 = !(_805 >= 0.0030399328097701073f);
          if (!_821) {
            float _823 = abs(_805);
            float _824 = log2(_823);
            float _825 = _824 * 0.4166666567325592f;
            float _826 = exp2(_825);
            float _827 = _826 * 1.0549999475479126f;
            float _828 = _827 + -0.054999999701976776f;
            _832 = _828;
          } else {
            float _830 = _805 * 12.923210144042969f;
            _832 = _830;
          }
          bool _833 = !(_806 >= 0.0030399328097701073f);
          if (!_833) {
            float _835 = abs(_806);
            float _836 = log2(_835);
            float _837 = _836 * 0.4166666567325592f;
            float _838 = exp2(_837);
            float _839 = _838 * 1.0549999475479126f;
            float _840 = _839 + -0.054999999701976776f;
            _844 = _820;
            _845 = _832;
            _846 = _840;
          } else {
            float _842 = _806 * 12.923210144042969f;
            _844 = _820;
            _845 = _832;
            _846 = _842;
          }
        } else {
          _844 = _804;
          _845 = _805;
          _846 = _806;
        }
        float _851 = abs(_844);
        float _852 = abs(_845);
        float _853 = abs(_846);
        float _854 = log2(_851);
        float _855 = log2(_852);
        float _856 = log2(_853);
        float _857 = _854 * cb2_000z;
        float _858 = _855 * cb2_000z;
        float _859 = _856 * cb2_000z;
        float _860 = exp2(_857);
        float _861 = exp2(_858);
        float _862 = exp2(_859);
        float _863 = _860 * cb2_000y;
        float _864 = _861 * cb2_000y;
        float _865 = _862 * cb2_000y;
        float _866 = _863 + cb2_000x;
        float _867 = _864 + cb2_000x;
        float _868 = _865 + cb2_000x;
        float _869 = saturate(_866);
        float _870 = saturate(_867);
        float _871 = saturate(_868);
        _873 = _869;
        _874 = _870;
        _875 = _871;
      }
      float _876 = dot(float3(_873, _874, _875), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _873;
      SV_Target.y = _874;
      SV_Target.z = _875;
      SV_Target.w = _876;
      SV_Target_1.x = _876;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

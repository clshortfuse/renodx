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
  float cb2_026y : packoffset(c026.y);
  float cb2_026z : packoffset(c026.z);
  float cb2_026w : packoffset(c026.w);
  float cb2_027x : packoffset(c027.x);
  float cb2_027y : packoffset(c027.y);
  float cb2_027z : packoffset(c027.z);
  float cb2_027w : packoffset(c027.w);
  uint cb2_028x : packoffset(c028.x);
  uint cb2_069y : packoffset(c069.y);
  uint cb2_069z : packoffset(c069.z);
  uint cb2_070x : packoffset(c070.x);
  uint cb2_070y : packoffset(c070.y);
  uint cb2_070z : packoffset(c070.z);
  uint cb2_070w : packoffset(c070.w);
  uint cb2_071x : packoffset(c071.x);
  uint cb2_071y : packoffset(c071.y);
  uint cb2_071z : packoffset(c071.z);
  uint cb2_071w : packoffset(c071.w);
  uint cb2_072x : packoffset(c072.x);
  uint cb2_072y : packoffset(c072.y);
  uint cb2_072z : packoffset(c072.z);
  uint cb2_072w : packoffset(c072.w);
  uint cb2_073x : packoffset(c073.x);
  uint cb2_073y : packoffset(c073.y);
  uint cb2_073z : packoffset(c073.z);
  uint cb2_073w : packoffset(c073.w);
  uint cb2_074x : packoffset(c074.x);
  uint cb2_074y : packoffset(c074.y);
  uint cb2_074z : packoffset(c074.z);
  uint cb2_074w : packoffset(c074.w);
  uint cb2_075x : packoffset(c075.x);
  uint cb2_075y : packoffset(c075.y);
  uint cb2_075z : packoffset(c075.z);
  uint cb2_075w : packoffset(c075.w);
  uint cb2_076x : packoffset(c076.x);
  uint cb2_076y : packoffset(c076.y);
  uint cb2_076z : packoffset(c076.z);
  uint cb2_076w : packoffset(c076.w);
  uint cb2_077x : packoffset(c077.x);
  uint cb2_077y : packoffset(c077.y);
  uint cb2_077z : packoffset(c077.z);
  uint cb2_077w : packoffset(c077.w);
  uint cb2_078x : packoffset(c078.x);
  uint cb2_078y : packoffset(c078.y);
  uint cb2_078z : packoffset(c078.z);
  uint cb2_078w : packoffset(c078.w);
  uint cb2_079x : packoffset(c079.x);
  uint cb2_079y : packoffset(c079.y);
  uint cb2_079z : packoffset(c079.z);
  uint cb2_094x : packoffset(c094.x);
  uint cb2_094y : packoffset(c094.y);
  uint cb2_094z : packoffset(c094.z);
  uint cb2_094w : packoffset(c094.w);
  uint cb2_095x : packoffset(c095.x);
  float cb2_095y : packoffset(c095.y);
};

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
  float _20 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _22 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _26 = _22.x * 6.283199787139893f;
  float _27 = cos(_26);
  float _28 = sin(_26);
  float _29 = _27 * _22.z;
  float _30 = _28 * _22.z;
  float _31 = _29 + TEXCOORD0_centroid.x;
  float _32 = _30 + TEXCOORD0_centroid.y;
  float _33 = _31 * 10.0f;
  float _34 = 10.0f - _33;
  float _35 = min(_33, _34);
  float _36 = saturate(_35);
  float _37 = _36 * _29;
  float _38 = _32 * 10.0f;
  float _39 = 10.0f - _38;
  float _40 = min(_38, _39);
  float _41 = saturate(_40);
  float _42 = _41 * _30;
  float _43 = _37 + TEXCOORD0_centroid.x;
  float _44 = _42 + TEXCOORD0_centroid.y;
  float4 _45 = t7.SampleLevel(s2_space2, float2(_43, _44), 0.0f);
  float _47 = _45.w * _37;
  float _48 = _45.w * _42;
  float _49 = 1.0f - _22.y;
  float _50 = saturate(_49);
  float _51 = _47 * _50;
  float _52 = _48 * _50;
  float _53 = _51 + TEXCOORD0_centroid.x;
  float _54 = _52 + TEXCOORD0_centroid.y;
  float4 _55 = t7.SampleLevel(s2_space2, float2(_53, _54), 0.0f);
  bool _57 = (_55.y > 0.0f);
  float _58 = select(_57, TEXCOORD0_centroid.x, _53);
  float _59 = select(_57, TEXCOORD0_centroid.y, _54);
  float4 _60 = t1.SampleLevel(s4_space2, float2(_58, _59), 0.0f);
  float _64 = max(_60.x, 0.0f);
  float _65 = max(_60.y, 0.0f);
  float _66 = max(_60.z, 0.0f);
  float _67 = min(_64, 65000.0f);
  float _68 = min(_65, 65000.0f);
  float _69 = min(_66, 65000.0f);
  float4 _70 = t3.SampleLevel(s2_space2, float2(_58, _59), 0.0f);
  float _75 = max(_70.x, 0.0f);
  float _76 = max(_70.y, 0.0f);
  float _77 = max(_70.z, 0.0f);
  float _78 = max(_70.w, 0.0f);
  float _79 = min(_75, 5000.0f);
  float _80 = min(_76, 5000.0f);
  float _81 = min(_77, 5000.0f);
  float _82 = min(_78, 5000.0f);
  float _85 = _20.x * cb0_028z;
  float _86 = _85 + cb0_028x;
  float _87 = cb2_027w / _86;
  float _88 = 1.0f - _87;
  float _89 = abs(_88);
  float _91 = cb2_027y * _89;
  float _93 = _91 - cb2_027z;
  float _94 = saturate(_93);
  float _95 = max(_94, _82);
  float _96 = saturate(_95);
  float4 _97 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _101 = _79 - _67;
  float _102 = _80 - _68;
  float _103 = _81 - _69;
  float _104 = _96 * _101;
  float _105 = _96 * _102;
  float _106 = _96 * _103;
  float _107 = _104 + _67;
  float _108 = _105 + _68;
  float _109 = _106 + _69;
  float _110 = dot(float3(_107, _108, _109), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _114 = t0[0].SExposureData_020;
  float _116 = t0[0].SExposureData_004;
  float _118 = cb2_018x * 0.5f;
  float _119 = _118 * cb2_018y;
  float _120 = _116.x - _119;
  float _121 = cb2_018y * cb2_018x;
  float _122 = 1.0f / _121;
  float _123 = _120 * _122;
  float _124 = _110 / _114.x;
  float _125 = _124 * 5464.01611328125f;
  float _126 = _125 + 9.99999993922529e-09f;
  float _127 = log2(_126);
  float _128 = _127 - _120;
  float _129 = _128 * _122;
  float _130 = saturate(_129);
  float2 _131 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _130), 0.0f);
  float _134 = max(_131.y, 1.0000000116860974e-07f);
  float _135 = _131.x / _134;
  float _136 = _135 + _123;
  float _137 = _136 / _122;
  float _138 = _137 - _116.x;
  float _139 = -0.0f - _138;
  float _141 = _139 - cb2_027x;
  float _142 = max(0.0f, _141);
  float _145 = cb2_026z * _142;
  float _146 = _138 - cb2_027x;
  float _147 = max(0.0f, _146);
  float _149 = cb2_026w * _147;
  bool _150 = (_138 < 0.0f);
  float _151 = select(_150, _145, _149);
  float _152 = exp2(_151);
  float _153 = _152 * _107;
  float _154 = _152 * _108;
  float _155 = _152 * _109;
  float _160 = cb2_024y * _97.x;
  float _161 = cb2_024z * _97.y;
  float _162 = cb2_024w * _97.z;
  float _163 = _160 + _153;
  float _164 = _161 + _154;
  float _165 = _162 + _155;
  float _170 = _163 * cb2_025x;
  float _171 = _164 * cb2_025y;
  float _172 = _165 * cb2_025z;
  float _173 = dot(float3(_170, _171, _172), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _174 = t0[0].SExposureData_012;
  float _176 = _173 * 5464.01611328125f;
  float _177 = _176 * _174.x;
  float _178 = _177 + 9.99999993922529e-09f;
  float _179 = log2(_178);
  float _180 = _179 + 16.929765701293945f;
  float _181 = _180 * 0.05734497308731079f;
  float _182 = saturate(_181);
  float _183 = _182 * _182;
  float _184 = _182 * 2.0f;
  float _185 = 3.0f - _184;
  float _186 = _183 * _185;
  float _187 = _171 * 0.8450999855995178f;
  float _188 = _172 * 0.14589999616146088f;
  float _189 = _187 + _188;
  float _190 = _189 * 2.4890189170837402f;
  float _191 = _189 * 0.3754962384700775f;
  float _192 = _189 * 2.811495304107666f;
  float _193 = _189 * 5.519708156585693f;
  float _194 = _173 - _190;
  float _195 = _186 * _194;
  float _196 = _195 + _190;
  float _197 = _186 * 0.5f;
  float _198 = _197 + 0.5f;
  float _199 = _198 * _194;
  float _200 = _199 + _190;
  float _201 = _170 - _191;
  float _202 = _171 - _192;
  float _203 = _172 - _193;
  float _204 = _198 * _201;
  float _205 = _198 * _202;
  float _206 = _198 * _203;
  float _207 = _204 + _191;
  float _208 = _205 + _192;
  float _209 = _206 + _193;
  float _210 = 1.0f / _200;
  float _211 = _196 * _210;
  float _212 = _211 * _207;
  float _213 = _211 * _208;
  float _214 = _211 * _209;
  float _218 = cb2_020x * TEXCOORD0_centroid.x;
  float _219 = cb2_020y * TEXCOORD0_centroid.y;
  float _222 = _218 + cb2_020z;
  float _223 = _219 + cb2_020w;
  float _226 = dot(float2(_222, _223), float2(_222, _223));
  float _227 = 1.0f - _226;
  float _228 = saturate(_227);
  float _229 = log2(_228);
  float _230 = _229 * cb2_021w;
  float _231 = exp2(_230);
  float _235 = _212 - cb2_021x;
  float _236 = _213 - cb2_021y;
  float _237 = _214 - cb2_021z;
  float _238 = _235 * _231;
  float _239 = _236 * _231;
  float _240 = _237 * _231;
  float _241 = _238 + cb2_021x;
  float _242 = _239 + cb2_021y;
  float _243 = _240 + cb2_021z;
  float _244 = t0[0].SExposureData_000;
  float _246 = max(_114.x, 0.0010000000474974513f);
  float _247 = 1.0f / _246;
  float _248 = _247 * _244.x;
  bool _251 = ((uint)(cb2_069y) == 0);
  float _257;
  float _258;
  float _259;
  float _313;
  float _314;
  float _315;
  float _405;
  float _406;
  float _407;
  float _452;
  float _453;
  float _454;
  float _455;
  float _502;
  float _503;
  float _504;
  float _529;
  float _530;
  float _531;
  float _681;
  float _718;
  float _719;
  float _720;
  float _749;
  float _750;
  float _751;
  float _832;
  float _833;
  float _834;
  float _840;
  float _841;
  float _842;
  float _856;
  float _857;
  float _858;
  float _883;
  float _895;
  float _923;
  float _935;
  float _947;
  float _948;
  float _949;
  float _976;
  float _977;
  float _978;
  if (!_251) {
    float _253 = _248 * _241;
    float _254 = _248 * _242;
    float _255 = _248 * _243;
    _257 = _253;
    _258 = _254;
    _259 = _255;
  } else {
    _257 = _241;
    _258 = _242;
    _259 = _243;
  }
  float _260 = _257 * 0.6130970120429993f;
  float _261 = mad(0.33952298760414124f, _258, _260);
  float _262 = mad(0.04737899824976921f, _259, _261);
  float _263 = _257 * 0.07019399851560593f;
  float _264 = mad(0.9163540005683899f, _258, _263);
  float _265 = mad(0.013451999984681606f, _259, _264);
  float _266 = _257 * 0.02061600051820278f;
  float _267 = mad(0.10956999659538269f, _258, _266);
  float _268 = mad(0.8698149919509888f, _259, _267);
  float _269 = log2(_262);
  float _270 = log2(_265);
  float _271 = log2(_268);
  float _272 = _269 * 0.04211956635117531f;
  float _273 = _270 * 0.04211956635117531f;
  float _274 = _271 * 0.04211956635117531f;
  float _275 = _272 + 0.6252607107162476f;
  float _276 = _273 + 0.6252607107162476f;
  float _277 = _274 + 0.6252607107162476f;
  float4 _278 = t5.SampleLevel(s2_space2, float3(_275, _276, _277), 0.0f);
  bool _284 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_284 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _288 = cb2_017x * _278.x;
    float _289 = cb2_017x * _278.y;
    float _290 = cb2_017x * _278.z;
    float _292 = _288 + cb2_017y;
    float _293 = _289 + cb2_017y;
    float _294 = _290 + cb2_017y;
    float _295 = exp2(_292);
    float _296 = exp2(_293);
    float _297 = exp2(_294);
    float _298 = _295 + 1.0f;
    float _299 = _296 + 1.0f;
    float _300 = _297 + 1.0f;
    float _301 = 1.0f / _298;
    float _302 = 1.0f / _299;
    float _303 = 1.0f / _300;
    float _305 = cb2_017z * _301;
    float _306 = cb2_017z * _302;
    float _307 = cb2_017z * _303;
    float _309 = _305 + cb2_017w;
    float _310 = _306 + cb2_017w;
    float _311 = _307 + cb2_017w;
    _313 = _309;
    _314 = _310;
    _315 = _311;
  } else {
    _313 = _278.x;
    _314 = _278.y;
    _315 = _278.z;
  }
  float _316 = _313 * 23.0f;
  float _317 = _316 + -14.473931312561035f;
  float _318 = exp2(_317);
  float _319 = _314 * 23.0f;
  float _320 = _319 + -14.473931312561035f;
  float _321 = exp2(_320);
  float _322 = _315 * 23.0f;
  float _323 = _322 + -14.473931312561035f;
  float _324 = exp2(_323);
  float _325 = dot(float3(_318, _321, _324), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _330 = dot(float3(_318, _321, _324), float3(_318, _321, _324));
  float _331 = rsqrt(_330);
  float _332 = _331 * _318;
  float _333 = _331 * _321;
  float _334 = _331 * _324;
  float _335 = cb2_001x - _332;
  float _336 = cb2_001y - _333;
  float _337 = cb2_001z - _334;
  float _338 = dot(float3(_335, _336, _337), float3(_335, _336, _337));
  float _341 = cb2_002z * _338;
  float _343 = _341 + cb2_002w;
  float _344 = saturate(_343);
  float _346 = cb2_002x * _344;
  float _347 = _325 - _318;
  float _348 = _325 - _321;
  float _349 = _325 - _324;
  float _350 = _346 * _347;
  float _351 = _346 * _348;
  float _352 = _346 * _349;
  float _353 = _350 + _318;
  float _354 = _351 + _321;
  float _355 = _352 + _324;
  float _357 = cb2_002y * _344;
  float _358 = 0.10000000149011612f - _353;
  float _359 = 0.10000000149011612f - _354;
  float _360 = 0.10000000149011612f - _355;
  float _361 = _358 * _357;
  float _362 = _359 * _357;
  float _363 = _360 * _357;
  float _364 = _361 + _353;
  float _365 = _362 + _354;
  float _366 = _363 + _355;
  float _367 = saturate(_364);
  float _368 = saturate(_365);
  float _369 = saturate(_366);
  float _373 = cb2_004x * TEXCOORD0_centroid.x;
  float _374 = cb2_004y * TEXCOORD0_centroid.y;
  float _377 = _373 + cb2_004z;
  float _378 = _374 + cb2_004w;
  float4 _384 = t6.Sample(s2_space2, float2(_377, _378));
  float _389 = _384.x * cb2_003x;
  float _390 = _384.y * cb2_003y;
  float _391 = _384.z * cb2_003z;
  float _392 = _384.w * cb2_003w;
  float _395 = _392 + cb2_026y;
  float _396 = saturate(_395);
  bool _399 = ((uint)(cb2_069y) == 0);
  if (!_399) {
    float _401 = _389 * _248;
    float _402 = _390 * _248;
    float _403 = _391 * _248;
    _405 = _401;
    _406 = _402;
    _407 = _403;
  } else {
    _405 = _389;
    _406 = _390;
    _407 = _391;
  }
  bool _410 = ((uint)(cb2_028x) == 2);
  bool _411 = ((uint)(cb2_028x) == 3);
  int _412 = (uint)(cb2_028x) & -2;
  bool _413 = (_412 == 2);
  bool _414 = ((uint)(cb2_028x) == 6);
  bool _415 = _413 || _414;
  if (_415) {
    float _417 = _405 * _396;
    float _418 = _406 * _396;
    float _419 = _407 * _396;
    float _420 = _396 * _396;
    _452 = _417;
    _453 = _418;
    _454 = _419;
    _455 = _420;
  } else {
    bool _422 = ((uint)(cb2_028x) == 4);
    if (_422) {
      float _424 = _405 + -1.0f;
      float _425 = _406 + -1.0f;
      float _426 = _407 + -1.0f;
      float _427 = _396 + -1.0f;
      float _428 = _424 * _396;
      float _429 = _425 * _396;
      float _430 = _426 * _396;
      float _431 = _427 * _396;
      float _432 = _428 + 1.0f;
      float _433 = _429 + 1.0f;
      float _434 = _430 + 1.0f;
      float _435 = _431 + 1.0f;
      _452 = _432;
      _453 = _433;
      _454 = _434;
      _455 = _435;
    } else {
      bool _437 = ((uint)(cb2_028x) == 5);
      if (_437) {
        float _439 = _405 + -0.5f;
        float _440 = _406 + -0.5f;
        float _441 = _407 + -0.5f;
        float _442 = _396 + -0.5f;
        float _443 = _439 * _396;
        float _444 = _440 * _396;
        float _445 = _441 * _396;
        float _446 = _442 * _396;
        float _447 = _443 + 0.5f;
        float _448 = _444 + 0.5f;
        float _449 = _445 + 0.5f;
        float _450 = _446 + 0.5f;
        _452 = _447;
        _453 = _448;
        _454 = _449;
        _455 = _450;
      } else {
        _452 = _405;
        _453 = _406;
        _454 = _407;
        _455 = _396;
      }
    }
  }
  if (_410) {
    float _457 = _452 + _367;
    float _458 = _453 + _368;
    float _459 = _454 + _369;
    _502 = _457;
    _503 = _458;
    _504 = _459;
  } else {
    if (_411) {
      float _462 = 1.0f - _452;
      float _463 = 1.0f - _453;
      float _464 = 1.0f - _454;
      float _465 = _462 * _367;
      float _466 = _463 * _368;
      float _467 = _464 * _369;
      float _468 = _465 + _452;
      float _469 = _466 + _453;
      float _470 = _467 + _454;
      _502 = _468;
      _503 = _469;
      _504 = _470;
    } else {
      bool _472 = ((uint)(cb2_028x) == 4);
      if (_472) {
        float _474 = _452 * _367;
        float _475 = _453 * _368;
        float _476 = _454 * _369;
        _502 = _474;
        _503 = _475;
        _504 = _476;
      } else {
        bool _478 = ((uint)(cb2_028x) == 5);
        if (_478) {
          float _480 = _367 * 2.0f;
          float _481 = _480 * _452;
          float _482 = _368 * 2.0f;
          float _483 = _482 * _453;
          float _484 = _369 * 2.0f;
          float _485 = _484 * _454;
          _502 = _481;
          _503 = _483;
          _504 = _485;
        } else {
          if (_414) {
            float _488 = _367 - _452;
            float _489 = _368 - _453;
            float _490 = _369 - _454;
            _502 = _488;
            _503 = _489;
            _504 = _490;
          } else {
            float _492 = _452 - _367;
            float _493 = _453 - _368;
            float _494 = _454 - _369;
            float _495 = _455 * _492;
            float _496 = _455 * _493;
            float _497 = _455 * _494;
            float _498 = _495 + _367;
            float _499 = _496 + _368;
            float _500 = _497 + _369;
            _502 = _498;
            _503 = _499;
            _504 = _500;
          }
        }
      }
    }
  }
  float _510 = cb2_016x - _502;
  float _511 = cb2_016y - _503;
  float _512 = cb2_016z - _504;
  float _513 = _510 * cb2_016w;
  float _514 = _511 * cb2_016w;
  float _515 = _512 * cb2_016w;
  float _516 = _513 + _502;
  float _517 = _514 + _503;
  float _518 = _515 + _504;
  bool _521 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_521 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _525 = cb2_024x * _516;
    float _526 = cb2_024x * _517;
    float _527 = cb2_024x * _518;
    _529 = _525;
    _530 = _526;
    _531 = _527;
  } else {
    _529 = _516;
    _530 = _517;
    _531 = _518;
  }
  float _534 = _529 * 0.9708889722824097f;
  float _535 = mad(0.026962999254465103f, _530, _534);
  float _536 = mad(0.002148000057786703f, _531, _535);
  float _537 = _529 * 0.01088900025933981f;
  float _538 = mad(0.9869629740715027f, _530, _537);
  float _539 = mad(0.002148000057786703f, _531, _538);
  float _540 = mad(0.026962999254465103f, _530, _537);
  float _541 = mad(0.9621480107307434f, _531, _540);
  float _542 = max(_536, 0.0f);
  float _543 = max(_539, 0.0f);
  float _544 = max(_541, 0.0f);
  float _545 = min(_542, cb2_095y);
  float _546 = min(_543, cb2_095y);
  float _547 = min(_544, cb2_095y);
  bool _550 = ((uint)(cb2_095x) == 0);
  bool _553 = ((uint)(cb2_094w) == 0);
  bool _555 = ((uint)(cb2_094z) == 0);
  bool _557 = ((uint)(cb2_094y) != 0);
  bool _559 = ((uint)(cb2_094x) == 0);
  bool _561 = ((uint)(cb2_069z) != 0);
  float _608 = asfloat((uint)(cb2_075y));
  float _609 = asfloat((uint)(cb2_075z));
  float _610 = asfloat((uint)(cb2_075w));
  float _611 = asfloat((uint)(cb2_074z));
  float _612 = asfloat((uint)(cb2_074w));
  float _613 = asfloat((uint)(cb2_075x));
  float _614 = asfloat((uint)(cb2_073w));
  float _615 = asfloat((uint)(cb2_074x));
  float _616 = asfloat((uint)(cb2_074y));
  float _617 = asfloat((uint)(cb2_077x));
  float _618 = asfloat((uint)(cb2_077y));
  float _619 = asfloat((uint)(cb2_079x));
  float _620 = asfloat((uint)(cb2_079y));
  float _621 = asfloat((uint)(cb2_079z));
  float _622 = asfloat((uint)(cb2_078y));
  float _623 = asfloat((uint)(cb2_078z));
  float _624 = asfloat((uint)(cb2_078w));
  float _625 = asfloat((uint)(cb2_077z));
  float _626 = asfloat((uint)(cb2_077w));
  float _627 = asfloat((uint)(cb2_078x));
  float _628 = asfloat((uint)(cb2_072y));
  float _629 = asfloat((uint)(cb2_072z));
  float _630 = asfloat((uint)(cb2_072w));
  float _631 = asfloat((uint)(cb2_071x));
  float _632 = asfloat((uint)(cb2_071y));
  float _633 = asfloat((uint)(cb2_076x));
  float _634 = asfloat((uint)(cb2_070w));
  float _635 = asfloat((uint)(cb2_070x));
  float _636 = asfloat((uint)(cb2_070y));
  float _637 = asfloat((uint)(cb2_070z));
  float _638 = asfloat((uint)(cb2_073x));
  float _639 = asfloat((uint)(cb2_073y));
  float _640 = asfloat((uint)(cb2_073z));
  float _641 = asfloat((uint)(cb2_071z));
  float _642 = asfloat((uint)(cb2_071w));
  float _643 = asfloat((uint)(cb2_072x));
  float _644 = max(_546, _547);
  float _645 = max(_545, _644);
  float _646 = 1.0f / _645;
  float _647 = _646 * _545;
  float _648 = _646 * _546;
  float _649 = _646 * _547;
  float _650 = abs(_647);
  float _651 = log2(_650);
  float _652 = _651 * _635;
  float _653 = exp2(_652);
  float _654 = abs(_648);
  float _655 = log2(_654);
  float _656 = _655 * _636;
  float _657 = exp2(_656);
  float _658 = abs(_649);
  float _659 = log2(_658);
  float _660 = _659 * _637;
  float _661 = exp2(_660);
  if (_557) {
    float _664 = asfloat((uint)(cb2_076w));
    float _666 = asfloat((uint)(cb2_076z));
    float _668 = asfloat((uint)(cb2_076y));
    float _669 = _666 * _546;
    float _670 = _668 * _545;
    float _671 = _664 * _547;
    float _672 = _670 + _671;
    float _673 = _672 + _669;
    _681 = _673;
  } else {
    float _675 = _642 * _546;
    float _676 = _641 * _545;
    float _677 = _643 * _547;
    float _678 = _675 + _676;
    float _679 = _678 + _677;
    _681 = _679;
  }
  float _682 = abs(_681);
  float _683 = log2(_682);
  float _684 = _683 * _634;
  float _685 = exp2(_684);
  float _686 = log2(_685);
  float _687 = _686 * _633;
  float _688 = exp2(_687);
  float _689 = select(_561, _688, _685);
  float _690 = _689 * _631;
  float _691 = _690 + _632;
  float _692 = 1.0f / _691;
  float _693 = _692 * _685;
  if (_557) {
    if (!_559) {
      float _696 = _653 * _625;
      float _697 = _657 * _626;
      float _698 = _661 * _627;
      float _699 = _697 + _696;
      float _700 = _699 + _698;
      float _701 = _657 * _623;
      float _702 = _653 * _622;
      float _703 = _661 * _624;
      float _704 = _701 + _702;
      float _705 = _704 + _703;
      float _706 = _661 * _621;
      float _707 = _657 * _620;
      float _708 = _653 * _619;
      float _709 = _707 + _708;
      float _710 = _709 + _706;
      float _711 = max(_705, _710);
      float _712 = max(_700, _711);
      float _713 = 1.0f / _712;
      float _714 = _713 * _700;
      float _715 = _713 * _705;
      float _716 = _713 * _710;
      _718 = _714;
      _719 = _715;
      _720 = _716;
    } else {
      _718 = _653;
      _719 = _657;
      _720 = _661;
    }
    float _721 = _718 * _618;
    float _722 = exp2(_721);
    float _723 = _722 * _617;
    float _724 = saturate(_723);
    float _725 = _718 * _617;
    float _726 = _718 - _725;
    float _727 = saturate(_726);
    float _728 = max(_617, _727);
    float _729 = min(_728, _724);
    float _730 = _719 * _618;
    float _731 = exp2(_730);
    float _732 = _731 * _617;
    float _733 = saturate(_732);
    float _734 = _719 * _617;
    float _735 = _719 - _734;
    float _736 = saturate(_735);
    float _737 = max(_617, _736);
    float _738 = min(_737, _733);
    float _739 = _720 * _618;
    float _740 = exp2(_739);
    float _741 = _740 * _617;
    float _742 = saturate(_741);
    float _743 = _720 * _617;
    float _744 = _720 - _743;
    float _745 = saturate(_744);
    float _746 = max(_617, _745);
    float _747 = min(_746, _742);
    _749 = _729;
    _750 = _738;
    _751 = _747;
  } else {
    _749 = _653;
    _750 = _657;
    _751 = _661;
  }
  float _752 = _749 * _641;
  float _753 = _750 * _642;
  float _754 = _753 + _752;
  float _755 = _751 * _643;
  float _756 = _754 + _755;
  float _757 = 1.0f / _756;
  float _758 = _757 * _693;
  float _759 = saturate(_758);
  float _760 = _759 * _749;
  float _761 = saturate(_760);
  float _762 = _759 * _750;
  float _763 = saturate(_762);
  float _764 = _759 * _751;
  float _765 = saturate(_764);
  float _766 = _761 * _628;
  float _767 = _628 - _766;
  float _768 = _763 * _629;
  float _769 = _629 - _768;
  float _770 = _765 * _630;
  float _771 = _630 - _770;
  float _772 = _765 * _643;
  float _773 = _761 * _641;
  float _774 = _763 * _642;
  float _775 = _693 - _773;
  float _776 = _775 - _774;
  float _777 = _776 - _772;
  float _778 = saturate(_777);
  float _779 = _769 * _642;
  float _780 = _767 * _641;
  float _781 = _771 * _643;
  float _782 = _779 + _780;
  float _783 = _782 + _781;
  float _784 = 1.0f / _783;
  float _785 = _784 * _778;
  float _786 = _785 * _767;
  float _787 = _786 + _761;
  float _788 = saturate(_787);
  float _789 = _785 * _769;
  float _790 = _789 + _763;
  float _791 = saturate(_790);
  float _792 = _785 * _771;
  float _793 = _792 + _765;
  float _794 = saturate(_793);
  float _795 = _794 * _643;
  float _796 = _788 * _641;
  float _797 = _791 * _642;
  float _798 = _693 - _796;
  float _799 = _798 - _797;
  float _800 = _799 - _795;
  float _801 = saturate(_800);
  float _802 = _801 * _638;
  float _803 = _802 + _788;
  float _804 = saturate(_803);
  float _805 = _801 * _639;
  float _806 = _805 + _791;
  float _807 = saturate(_806);
  float _808 = _801 * _640;
  float _809 = _808 + _794;
  float _810 = saturate(_809);
  if (!_555) {
    float _812 = _804 * _614;
    float _813 = _807 * _615;
    float _814 = _810 * _616;
    float _815 = _813 + _812;
    float _816 = _815 + _814;
    float _817 = _807 * _612;
    float _818 = _804 * _611;
    float _819 = _810 * _613;
    float _820 = _817 + _818;
    float _821 = _820 + _819;
    float _822 = _810 * _610;
    float _823 = _807 * _609;
    float _824 = _804 * _608;
    float _825 = _823 + _824;
    float _826 = _825 + _822;
    if (!_553) {
      float _828 = saturate(_816);
      float _829 = saturate(_821);
      float _830 = saturate(_826);
      _832 = _830;
      _833 = _829;
      _834 = _828;
    } else {
      _832 = _826;
      _833 = _821;
      _834 = _816;
    }
  } else {
    _832 = _810;
    _833 = _807;
    _834 = _804;
  }
  if (!_550) {
    float _836 = _834 * _614;
    float _837 = _833 * _614;
    float _838 = _832 * _614;
    _840 = _838;
    _841 = _837;
    _842 = _836;
  } else {
    _840 = _832;
    _841 = _833;
    _842 = _834;
  }
  if (_521) {
    float _846 = cb1_018z * 9.999999747378752e-05f;
    float _847 = _846 * _842;
    float _848 = _846 * _841;
    float _849 = _846 * _840;
    float _851 = 5000.0f / cb1_018y;
    float _852 = _847 * _851;
    float _853 = _848 * _851;
    float _854 = _849 * _851;
    _856 = _852;
    _857 = _853;
    _858 = _854;
  } else {
    _856 = _842;
    _857 = _841;
    _858 = _840;
  }
  float _859 = _856 * 1.6047500371932983f;
  float _860 = mad(-0.5310800075531006f, _857, _859);
  float _861 = mad(-0.07366999983787537f, _858, _860);
  float _862 = _856 * -0.10208000242710114f;
  float _863 = mad(1.1081299781799316f, _857, _862);
  float _864 = mad(-0.006049999967217445f, _858, _863);
  float _865 = _856 * -0.0032599999103695154f;
  float _866 = mad(-0.07275000214576721f, _857, _865);
  float _867 = mad(1.0760200023651123f, _858, _866);
  if (_521) {
    // float _869 = max(_861, 0.0f);
    // float _870 = max(_864, 0.0f);
    // float _871 = max(_867, 0.0f);
    // bool _872 = !(_869 >= 0.0030399328097701073f);
    // if (!_872) {
    //   float _874 = abs(_869);
    //   float _875 = log2(_874);
    //   float _876 = _875 * 0.4166666567325592f;
    //   float _877 = exp2(_876);
    //   float _878 = _877 * 1.0549999475479126f;
    //   float _879 = _878 + -0.054999999701976776f;
    //   _883 = _879;
    // } else {
    //   float _881 = _869 * 12.923210144042969f;
    //   _883 = _881;
    // }
    // bool _884 = !(_870 >= 0.0030399328097701073f);
    // if (!_884) {
    //   float _886 = abs(_870);
    //   float _887 = log2(_886);
    //   float _888 = _887 * 0.4166666567325592f;
    //   float _889 = exp2(_888);
    //   float _890 = _889 * 1.0549999475479126f;
    //   float _891 = _890 + -0.054999999701976776f;
    //   _895 = _891;
    // } else {
    //   float _893 = _870 * 12.923210144042969f;
    //   _895 = _893;
    // }
    // bool _896 = !(_871 >= 0.0030399328097701073f);
    // if (!_896) {
    //   float _898 = abs(_871);
    //   float _899 = log2(_898);
    //   float _900 = _899 * 0.4166666567325592f;
    //   float _901 = exp2(_900);
    //   float _902 = _901 * 1.0549999475479126f;
    //   float _903 = _902 + -0.054999999701976776f;
    //   _976 = _883;
    //   _977 = _895;
    //   _978 = _903;
    // } else {
    //   float _905 = _871 * 12.923210144042969f;
    //   _976 = _883;
    //   _977 = _895;
    //   _978 = _905;
    // }
    _976 = renodx::color::srgb::EncodeSafe(_861);
    _977 = renodx::color::srgb::EncodeSafe(_864);
    _978 = renodx::color::srgb::EncodeSafe(_867);

  } else {
    float _907 = saturate(_861);
    float _908 = saturate(_864);
    float _909 = saturate(_867);
    bool _910 = ((uint)(cb1_018w) == -2);
    if (!_910) {
      bool _912 = !(_907 >= 0.0030399328097701073f);
      if (!_912) {
        float _914 = abs(_907);
        float _915 = log2(_914);
        float _916 = _915 * 0.4166666567325592f;
        float _917 = exp2(_916);
        float _918 = _917 * 1.0549999475479126f;
        float _919 = _918 + -0.054999999701976776f;
        _923 = _919;
      } else {
        float _921 = _907 * 12.923210144042969f;
        _923 = _921;
      }
      bool _924 = !(_908 >= 0.0030399328097701073f);
      if (!_924) {
        float _926 = abs(_908);
        float _927 = log2(_926);
        float _928 = _927 * 0.4166666567325592f;
        float _929 = exp2(_928);
        float _930 = _929 * 1.0549999475479126f;
        float _931 = _930 + -0.054999999701976776f;
        _935 = _931;
      } else {
        float _933 = _908 * 12.923210144042969f;
        _935 = _933;
      }
      bool _936 = !(_909 >= 0.0030399328097701073f);
      if (!_936) {
        float _938 = abs(_909);
        float _939 = log2(_938);
        float _940 = _939 * 0.4166666567325592f;
        float _941 = exp2(_940);
        float _942 = _941 * 1.0549999475479126f;
        float _943 = _942 + -0.054999999701976776f;
        _947 = _923;
        _948 = _935;
        _949 = _943;
      } else {
        float _945 = _909 * 12.923210144042969f;
        _947 = _923;
        _948 = _935;
        _949 = _945;
      }
    } else {
      _947 = _907;
      _948 = _908;
      _949 = _909;
    }
    float _954 = abs(_947);
    float _955 = abs(_948);
    float _956 = abs(_949);
    float _957 = log2(_954);
    float _958 = log2(_955);
    float _959 = log2(_956);
    float _960 = _957 * cb2_000z;
    float _961 = _958 * cb2_000z;
    float _962 = _959 * cb2_000z;
    float _963 = exp2(_960);
    float _964 = exp2(_961);
    float _965 = exp2(_962);
    float _966 = _963 * cb2_000y;
    float _967 = _964 * cb2_000y;
    float _968 = _965 * cb2_000y;
    float _969 = _966 + cb2_000x;
    float _970 = _967 + cb2_000x;
    float _971 = _968 + cb2_000x;
    float _972 = saturate(_969);
    float _973 = saturate(_970);
    float _974 = saturate(_971);
    _976 = _972;
    _977 = _973;
    _978 = _974;
  }
  float _979 = dot(float3(_976, _977, _978), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _976;
  SV_Target.y = _977;
  SV_Target.z = _978;
  SV_Target.w = _979;
  SV_Target_1.x = _979;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

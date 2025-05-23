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
  float _100 = cb2_013x * _58;
  float _101 = cb2_013y * _59;
  float _104 = _100 + cb2_013z;
  float _105 = _101 + cb2_013w;
  float _108 = dot(float2(_104, _105), float2(_104, _105));
  float _109 = abs(_108);
  float _110 = log2(_109);
  float _111 = _110 * cb2_014x;
  float _112 = exp2(_111);
  float _113 = saturate(_112);
  float _117 = cb2_011x * _58;
  float _118 = cb2_011y * _59;
  float _121 = _117 + cb2_011z;
  float _122 = _118 + cb2_011w;
  float _123 = _121 * _113;
  float _124 = _122 * _113;
  float _125 = _123 + _58;
  float _126 = _124 + _59;
  float _130 = cb2_012x * _58;
  float _131 = cb2_012y * _59;
  float _134 = _130 + cb2_012z;
  float _135 = _131 + cb2_012w;
  float _136 = _134 * _113;
  float _137 = _135 * _113;
  float _138 = _136 + _58;
  float _139 = _137 + _59;
  float4 _140 = t1.SampleLevel(s2_space2, float2(_125, _126), 0.0f);
  float _144 = max(_140.x, 0.0f);
  float _145 = max(_140.y, 0.0f);
  float _146 = max(_140.z, 0.0f);
  float _147 = min(_144, 65000.0f);
  float _148 = min(_145, 65000.0f);
  float _149 = min(_146, 65000.0f);
  float4 _150 = t1.SampleLevel(s2_space2, float2(_138, _139), 0.0f);
  float _154 = max(_150.x, 0.0f);
  float _155 = max(_150.y, 0.0f);
  float _156 = max(_150.z, 0.0f);
  float _157 = min(_154, 65000.0f);
  float _158 = min(_155, 65000.0f);
  float _159 = min(_156, 65000.0f);
  float4 _160 = t3.SampleLevel(s2_space2, float2(_125, _126), 0.0f);
  float _164 = max(_160.x, 0.0f);
  float _165 = max(_160.y, 0.0f);
  float _166 = max(_160.z, 0.0f);
  float _167 = min(_164, 5000.0f);
  float _168 = min(_165, 5000.0f);
  float _169 = min(_166, 5000.0f);
  float4 _170 = t3.SampleLevel(s2_space2, float2(_138, _139), 0.0f);
  float _174 = max(_170.x, 0.0f);
  float _175 = max(_170.y, 0.0f);
  float _176 = max(_170.z, 0.0f);
  float _177 = min(_174, 5000.0f);
  float _178 = min(_175, 5000.0f);
  float _179 = min(_176, 5000.0f);
  float _184 = 1.0f - cb2_009x;
  float _185 = 1.0f - cb2_009y;
  float _186 = 1.0f - cb2_009z;
  float _191 = _184 - cb2_010x;
  float _192 = _185 - cb2_010y;
  float _193 = _186 - cb2_010z;
  float _194 = saturate(_191);
  float _195 = saturate(_192);
  float _196 = saturate(_193);
  float _197 = _194 * _67;
  float _198 = _195 * _68;
  float _199 = _196 * _69;
  float _200 = cb2_009x * _147;
  float _201 = cb2_009y * _148;
  float _202 = cb2_009z * _149;
  float _203 = _200 + _197;
  float _204 = _201 + _198;
  float _205 = _202 + _199;
  float _206 = cb2_010x * _157;
  float _207 = cb2_010y * _158;
  float _208 = cb2_010z * _159;
  float _209 = _203 + _206;
  float _210 = _204 + _207;
  float _211 = _205 + _208;
  float _212 = _194 * _79;
  float _213 = _195 * _80;
  float _214 = _196 * _81;
  float _215 = cb2_009x * _167;
  float _216 = cb2_009y * _168;
  float _217 = cb2_009z * _169;
  float _218 = cb2_010x * _177;
  float _219 = cb2_010y * _178;
  float _220 = cb2_010z * _179;
  float4 _221 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _225 = _212 - _209;
  float _226 = _225 + _215;
  float _227 = _226 + _218;
  float _228 = _213 - _210;
  float _229 = _228 + _216;
  float _230 = _229 + _219;
  float _231 = _214 - _211;
  float _232 = _231 + _217;
  float _233 = _232 + _220;
  float _234 = _227 * _96;
  float _235 = _230 * _96;
  float _236 = _233 * _96;
  float _237 = _234 + _209;
  float _238 = _235 + _210;
  float _239 = _236 + _211;
  float _240 = dot(float3(_237, _238, _239), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _244 = t0[0].SExposureData_020;
  float _246 = t0[0].SExposureData_004;
  float _248 = cb2_018x * 0.5f;
  float _249 = _248 * cb2_018y;
  float _250 = _246.x - _249;
  float _251 = cb2_018y * cb2_018x;
  float _252 = 1.0f / _251;
  float _253 = _250 * _252;
  float _254 = _240 / _244.x;
  float _255 = _254 * 5464.01611328125f;
  float _256 = _255 + 9.99999993922529e-09f;
  float _257 = log2(_256);
  float _258 = _257 - _250;
  float _259 = _258 * _252;
  float _260 = saturate(_259);
  float2 _261 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _260), 0.0f);
  float _264 = max(_261.y, 1.0000000116860974e-07f);
  float _265 = _261.x / _264;
  float _266 = _265 + _253;
  float _267 = _266 / _252;
  float _268 = _267 - _246.x;
  float _269 = -0.0f - _268;
  float _271 = _269 - cb2_027x;
  float _272 = max(0.0f, _271);
  float _275 = cb2_026z * _272;
  float _276 = _268 - cb2_027x;
  float _277 = max(0.0f, _276);
  float _279 = cb2_026w * _277;
  bool _280 = (_268 < 0.0f);
  float _281 = select(_280, _275, _279);
  float _282 = exp2(_281);
  float _283 = _282 * _237;
  float _284 = _282 * _238;
  float _285 = _282 * _239;
  float _290 = cb2_024y * _221.x;
  float _291 = cb2_024z * _221.y;
  float _292 = cb2_024w * _221.z;
  float _293 = _290 + _283;
  float _294 = _291 + _284;
  float _295 = _292 + _285;
  float _300 = _293 * cb2_025x;
  float _301 = _294 * cb2_025y;
  float _302 = _295 * cb2_025z;
  float _303 = dot(float3(_300, _301, _302), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _304 = t0[0].SExposureData_012;
  float _306 = _303 * 5464.01611328125f;
  float _307 = _306 * _304.x;
  float _308 = _307 + 9.99999993922529e-09f;
  float _309 = log2(_308);
  float _310 = _309 + 16.929765701293945f;
  float _311 = _310 * 0.05734497308731079f;
  float _312 = saturate(_311);
  float _313 = _312 * _312;
  float _314 = _312 * 2.0f;
  float _315 = 3.0f - _314;
  float _316 = _313 * _315;
  float _317 = _301 * 0.8450999855995178f;
  float _318 = _302 * 0.14589999616146088f;
  float _319 = _317 + _318;
  float _320 = _319 * 2.4890189170837402f;
  float _321 = _319 * 0.3754962384700775f;
  float _322 = _319 * 2.811495304107666f;
  float _323 = _319 * 5.519708156585693f;
  float _324 = _303 - _320;
  float _325 = _316 * _324;
  float _326 = _325 + _320;
  float _327 = _316 * 0.5f;
  float _328 = _327 + 0.5f;
  float _329 = _328 * _324;
  float _330 = _329 + _320;
  float _331 = _300 - _321;
  float _332 = _301 - _322;
  float _333 = _302 - _323;
  float _334 = _328 * _331;
  float _335 = _328 * _332;
  float _336 = _328 * _333;
  float _337 = _334 + _321;
  float _338 = _335 + _322;
  float _339 = _336 + _323;
  float _340 = 1.0f / _330;
  float _341 = _326 * _340;
  float _342 = _341 * _337;
  float _343 = _341 * _338;
  float _344 = _341 * _339;
  float _348 = cb2_020x * TEXCOORD0_centroid.x;
  float _349 = cb2_020y * TEXCOORD0_centroid.y;
  float _352 = _348 + cb2_020z;
  float _353 = _349 + cb2_020w;
  float _356 = dot(float2(_352, _353), float2(_352, _353));
  float _357 = 1.0f - _356;
  float _358 = saturate(_357);
  float _359 = log2(_358);
  float _360 = _359 * cb2_021w;
  float _361 = exp2(_360);
  float _365 = _342 - cb2_021x;
  float _366 = _343 - cb2_021y;
  float _367 = _344 - cb2_021z;
  float _368 = _365 * _361;
  float _369 = _366 * _361;
  float _370 = _367 * _361;
  float _371 = _368 + cb2_021x;
  float _372 = _369 + cb2_021y;
  float _373 = _370 + cb2_021z;
  float _374 = t0[0].SExposureData_000;
  float _376 = max(_244.x, 0.0010000000474974513f);
  float _377 = 1.0f / _376;
  float _378 = _377 * _374.x;
  bool _381 = ((uint)(cb2_069y) == 0);
  float _387;
  float _388;
  float _389;
  float _443;
  float _444;
  float _445;
  float _535;
  float _536;
  float _537;
  float _582;
  float _583;
  float _584;
  float _585;
  float _632;
  float _633;
  float _634;
  float _659;
  float _660;
  float _661;
  float _811;
  float _848;
  float _849;
  float _850;
  float _879;
  float _880;
  float _881;
  float _962;
  float _963;
  float _964;
  float _970;
  float _971;
  float _972;
  float _986;
  float _987;
  float _988;
  float _1013;
  float _1025;
  float _1053;
  float _1065;
  float _1077;
  float _1078;
  float _1079;
  float _1106;
  float _1107;
  float _1108;
  if (!_381) {
    float _383 = _378 * _371;
    float _384 = _378 * _372;
    float _385 = _378 * _373;
    _387 = _383;
    _388 = _384;
    _389 = _385;
  } else {
    _387 = _371;
    _388 = _372;
    _389 = _373;
  }
  float _390 = _387 * 0.6130970120429993f;
  float _391 = mad(0.33952298760414124f, _388, _390);
  float _392 = mad(0.04737899824976921f, _389, _391);
  float _393 = _387 * 0.07019399851560593f;
  float _394 = mad(0.9163540005683899f, _388, _393);
  float _395 = mad(0.013451999984681606f, _389, _394);
  float _396 = _387 * 0.02061600051820278f;
  float _397 = mad(0.10956999659538269f, _388, _396);
  float _398 = mad(0.8698149919509888f, _389, _397);
  float _399 = log2(_392);
  float _400 = log2(_395);
  float _401 = log2(_398);
  float _402 = _399 * 0.04211956635117531f;
  float _403 = _400 * 0.04211956635117531f;
  float _404 = _401 * 0.04211956635117531f;
  float _405 = _402 + 0.6252607107162476f;
  float _406 = _403 + 0.6252607107162476f;
  float _407 = _404 + 0.6252607107162476f;
  float4 _408 = t5.SampleLevel(s2_space2, float3(_405, _406, _407), 0.0f);
  bool _414 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_414 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _418 = cb2_017x * _408.x;
    float _419 = cb2_017x * _408.y;
    float _420 = cb2_017x * _408.z;
    float _422 = _418 + cb2_017y;
    float _423 = _419 + cb2_017y;
    float _424 = _420 + cb2_017y;
    float _425 = exp2(_422);
    float _426 = exp2(_423);
    float _427 = exp2(_424);
    float _428 = _425 + 1.0f;
    float _429 = _426 + 1.0f;
    float _430 = _427 + 1.0f;
    float _431 = 1.0f / _428;
    float _432 = 1.0f / _429;
    float _433 = 1.0f / _430;
    float _435 = cb2_017z * _431;
    float _436 = cb2_017z * _432;
    float _437 = cb2_017z * _433;
    float _439 = _435 + cb2_017w;
    float _440 = _436 + cb2_017w;
    float _441 = _437 + cb2_017w;
    _443 = _439;
    _444 = _440;
    _445 = _441;
  } else {
    _443 = _408.x;
    _444 = _408.y;
    _445 = _408.z;
  }
  float _446 = _443 * 23.0f;
  float _447 = _446 + -14.473931312561035f;
  float _448 = exp2(_447);
  float _449 = _444 * 23.0f;
  float _450 = _449 + -14.473931312561035f;
  float _451 = exp2(_450);
  float _452 = _445 * 23.0f;
  float _453 = _452 + -14.473931312561035f;
  float _454 = exp2(_453);
  float _455 = dot(float3(_448, _451, _454), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _460 = dot(float3(_448, _451, _454), float3(_448, _451, _454));
  float _461 = rsqrt(_460);
  float _462 = _461 * _448;
  float _463 = _461 * _451;
  float _464 = _461 * _454;
  float _465 = cb2_001x - _462;
  float _466 = cb2_001y - _463;
  float _467 = cb2_001z - _464;
  float _468 = dot(float3(_465, _466, _467), float3(_465, _466, _467));
  float _471 = cb2_002z * _468;
  float _473 = _471 + cb2_002w;
  float _474 = saturate(_473);
  float _476 = cb2_002x * _474;
  float _477 = _455 - _448;
  float _478 = _455 - _451;
  float _479 = _455 - _454;
  float _480 = _476 * _477;
  float _481 = _476 * _478;
  float _482 = _476 * _479;
  float _483 = _480 + _448;
  float _484 = _481 + _451;
  float _485 = _482 + _454;
  float _487 = cb2_002y * _474;
  float _488 = 0.10000000149011612f - _483;
  float _489 = 0.10000000149011612f - _484;
  float _490 = 0.10000000149011612f - _485;
  float _491 = _488 * _487;
  float _492 = _489 * _487;
  float _493 = _490 * _487;
  float _494 = _491 + _483;
  float _495 = _492 + _484;
  float _496 = _493 + _485;
  float _497 = saturate(_494);
  float _498 = saturate(_495);
  float _499 = saturate(_496);
  float _503 = cb2_004x * TEXCOORD0_centroid.x;
  float _504 = cb2_004y * TEXCOORD0_centroid.y;
  float _507 = _503 + cb2_004z;
  float _508 = _504 + cb2_004w;
  float4 _514 = t6.Sample(s2_space2, float2(_507, _508));
  float _519 = _514.x * cb2_003x;
  float _520 = _514.y * cb2_003y;
  float _521 = _514.z * cb2_003z;
  float _522 = _514.w * cb2_003w;
  float _525 = _522 + cb2_026y;
  float _526 = saturate(_525);
  bool _529 = ((uint)(cb2_069y) == 0);
  if (!_529) {
    float _531 = _519 * _378;
    float _532 = _520 * _378;
    float _533 = _521 * _378;
    _535 = _531;
    _536 = _532;
    _537 = _533;
  } else {
    _535 = _519;
    _536 = _520;
    _537 = _521;
  }
  bool _540 = ((uint)(cb2_028x) == 2);
  bool _541 = ((uint)(cb2_028x) == 3);
  int _542 = (uint)(cb2_028x) & -2;
  bool _543 = (_542 == 2);
  bool _544 = ((uint)(cb2_028x) == 6);
  bool _545 = _543 || _544;
  if (_545) {
    float _547 = _535 * _526;
    float _548 = _536 * _526;
    float _549 = _537 * _526;
    float _550 = _526 * _526;
    _582 = _547;
    _583 = _548;
    _584 = _549;
    _585 = _550;
  } else {
    bool _552 = ((uint)(cb2_028x) == 4);
    if (_552) {
      float _554 = _535 + -1.0f;
      float _555 = _536 + -1.0f;
      float _556 = _537 + -1.0f;
      float _557 = _526 + -1.0f;
      float _558 = _554 * _526;
      float _559 = _555 * _526;
      float _560 = _556 * _526;
      float _561 = _557 * _526;
      float _562 = _558 + 1.0f;
      float _563 = _559 + 1.0f;
      float _564 = _560 + 1.0f;
      float _565 = _561 + 1.0f;
      _582 = _562;
      _583 = _563;
      _584 = _564;
      _585 = _565;
    } else {
      bool _567 = ((uint)(cb2_028x) == 5);
      if (_567) {
        float _569 = _535 + -0.5f;
        float _570 = _536 + -0.5f;
        float _571 = _537 + -0.5f;
        float _572 = _526 + -0.5f;
        float _573 = _569 * _526;
        float _574 = _570 * _526;
        float _575 = _571 * _526;
        float _576 = _572 * _526;
        float _577 = _573 + 0.5f;
        float _578 = _574 + 0.5f;
        float _579 = _575 + 0.5f;
        float _580 = _576 + 0.5f;
        _582 = _577;
        _583 = _578;
        _584 = _579;
        _585 = _580;
      } else {
        _582 = _535;
        _583 = _536;
        _584 = _537;
        _585 = _526;
      }
    }
  }
  if (_540) {
    float _587 = _582 + _497;
    float _588 = _583 + _498;
    float _589 = _584 + _499;
    _632 = _587;
    _633 = _588;
    _634 = _589;
  } else {
    if (_541) {
      float _592 = 1.0f - _582;
      float _593 = 1.0f - _583;
      float _594 = 1.0f - _584;
      float _595 = _592 * _497;
      float _596 = _593 * _498;
      float _597 = _594 * _499;
      float _598 = _595 + _582;
      float _599 = _596 + _583;
      float _600 = _597 + _584;
      _632 = _598;
      _633 = _599;
      _634 = _600;
    } else {
      bool _602 = ((uint)(cb2_028x) == 4);
      if (_602) {
        float _604 = _582 * _497;
        float _605 = _583 * _498;
        float _606 = _584 * _499;
        _632 = _604;
        _633 = _605;
        _634 = _606;
      } else {
        bool _608 = ((uint)(cb2_028x) == 5);
        if (_608) {
          float _610 = _497 * 2.0f;
          float _611 = _610 * _582;
          float _612 = _498 * 2.0f;
          float _613 = _612 * _583;
          float _614 = _499 * 2.0f;
          float _615 = _614 * _584;
          _632 = _611;
          _633 = _613;
          _634 = _615;
        } else {
          if (_544) {
            float _618 = _497 - _582;
            float _619 = _498 - _583;
            float _620 = _499 - _584;
            _632 = _618;
            _633 = _619;
            _634 = _620;
          } else {
            float _622 = _582 - _497;
            float _623 = _583 - _498;
            float _624 = _584 - _499;
            float _625 = _585 * _622;
            float _626 = _585 * _623;
            float _627 = _585 * _624;
            float _628 = _625 + _497;
            float _629 = _626 + _498;
            float _630 = _627 + _499;
            _632 = _628;
            _633 = _629;
            _634 = _630;
          }
        }
      }
    }
  }
  float _640 = cb2_016x - _632;
  float _641 = cb2_016y - _633;
  float _642 = cb2_016z - _634;
  float _643 = _640 * cb2_016w;
  float _644 = _641 * cb2_016w;
  float _645 = _642 * cb2_016w;
  float _646 = _643 + _632;
  float _647 = _644 + _633;
  float _648 = _645 + _634;
  bool _651 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_651 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _655 = cb2_024x * _646;
    float _656 = cb2_024x * _647;
    float _657 = cb2_024x * _648;
    _659 = _655;
    _660 = _656;
    _661 = _657;
  } else {
    _659 = _646;
    _660 = _647;
    _661 = _648;
  }
  float _664 = _659 * 0.9708889722824097f;
  float _665 = mad(0.026962999254465103f, _660, _664);
  float _666 = mad(0.002148000057786703f, _661, _665);
  float _667 = _659 * 0.01088900025933981f;
  float _668 = mad(0.9869629740715027f, _660, _667);
  float _669 = mad(0.002148000057786703f, _661, _668);
  float _670 = mad(0.026962999254465103f, _660, _667);
  float _671 = mad(0.9621480107307434f, _661, _670);
  float _672 = max(_666, 0.0f);
  float _673 = max(_669, 0.0f);
  float _674 = max(_671, 0.0f);
  float _675 = min(_672, cb2_095y);
  float _676 = min(_673, cb2_095y);
  float _677 = min(_674, cb2_095y);
  bool _680 = ((uint)(cb2_095x) == 0);
  bool _683 = ((uint)(cb2_094w) == 0);
  bool _685 = ((uint)(cb2_094z) == 0);
  bool _687 = ((uint)(cb2_094y) != 0);
  bool _689 = ((uint)(cb2_094x) == 0);
  bool _691 = ((uint)(cb2_069z) != 0);
  float _738 = asfloat((uint)(cb2_075y));
  float _739 = asfloat((uint)(cb2_075z));
  float _740 = asfloat((uint)(cb2_075w));
  float _741 = asfloat((uint)(cb2_074z));
  float _742 = asfloat((uint)(cb2_074w));
  float _743 = asfloat((uint)(cb2_075x));
  float _744 = asfloat((uint)(cb2_073w));
  float _745 = asfloat((uint)(cb2_074x));
  float _746 = asfloat((uint)(cb2_074y));
  float _747 = asfloat((uint)(cb2_077x));
  float _748 = asfloat((uint)(cb2_077y));
  float _749 = asfloat((uint)(cb2_079x));
  float _750 = asfloat((uint)(cb2_079y));
  float _751 = asfloat((uint)(cb2_079z));
  float _752 = asfloat((uint)(cb2_078y));
  float _753 = asfloat((uint)(cb2_078z));
  float _754 = asfloat((uint)(cb2_078w));
  float _755 = asfloat((uint)(cb2_077z));
  float _756 = asfloat((uint)(cb2_077w));
  float _757 = asfloat((uint)(cb2_078x));
  float _758 = asfloat((uint)(cb2_072y));
  float _759 = asfloat((uint)(cb2_072z));
  float _760 = asfloat((uint)(cb2_072w));
  float _761 = asfloat((uint)(cb2_071x));
  float _762 = asfloat((uint)(cb2_071y));
  float _763 = asfloat((uint)(cb2_076x));
  float _764 = asfloat((uint)(cb2_070w));
  float _765 = asfloat((uint)(cb2_070x));
  float _766 = asfloat((uint)(cb2_070y));
  float _767 = asfloat((uint)(cb2_070z));
  float _768 = asfloat((uint)(cb2_073x));
  float _769 = asfloat((uint)(cb2_073y));
  float _770 = asfloat((uint)(cb2_073z));
  float _771 = asfloat((uint)(cb2_071z));
  float _772 = asfloat((uint)(cb2_071w));
  float _773 = asfloat((uint)(cb2_072x));
  float _774 = max(_676, _677);
  float _775 = max(_675, _774);
  float _776 = 1.0f / _775;
  float _777 = _776 * _675;
  float _778 = _776 * _676;
  float _779 = _776 * _677;
  float _780 = abs(_777);
  float _781 = log2(_780);
  float _782 = _781 * _765;
  float _783 = exp2(_782);
  float _784 = abs(_778);
  float _785 = log2(_784);
  float _786 = _785 * _766;
  float _787 = exp2(_786);
  float _788 = abs(_779);
  float _789 = log2(_788);
  float _790 = _789 * _767;
  float _791 = exp2(_790);
  if (_687) {
    float _794 = asfloat((uint)(cb2_076w));
    float _796 = asfloat((uint)(cb2_076z));
    float _798 = asfloat((uint)(cb2_076y));
    float _799 = _796 * _676;
    float _800 = _798 * _675;
    float _801 = _794 * _677;
    float _802 = _800 + _801;
    float _803 = _802 + _799;
    _811 = _803;
  } else {
    float _805 = _772 * _676;
    float _806 = _771 * _675;
    float _807 = _773 * _677;
    float _808 = _805 + _806;
    float _809 = _808 + _807;
    _811 = _809;
  }
  float _812 = abs(_811);
  float _813 = log2(_812);
  float _814 = _813 * _764;
  float _815 = exp2(_814);
  float _816 = log2(_815);
  float _817 = _816 * _763;
  float _818 = exp2(_817);
  float _819 = select(_691, _818, _815);
  float _820 = _819 * _761;
  float _821 = _820 + _762;
  float _822 = 1.0f / _821;
  float _823 = _822 * _815;
  if (_687) {
    if (!_689) {
      float _826 = _783 * _755;
      float _827 = _787 * _756;
      float _828 = _791 * _757;
      float _829 = _827 + _826;
      float _830 = _829 + _828;
      float _831 = _787 * _753;
      float _832 = _783 * _752;
      float _833 = _791 * _754;
      float _834 = _831 + _832;
      float _835 = _834 + _833;
      float _836 = _791 * _751;
      float _837 = _787 * _750;
      float _838 = _783 * _749;
      float _839 = _837 + _838;
      float _840 = _839 + _836;
      float _841 = max(_835, _840);
      float _842 = max(_830, _841);
      float _843 = 1.0f / _842;
      float _844 = _843 * _830;
      float _845 = _843 * _835;
      float _846 = _843 * _840;
      _848 = _844;
      _849 = _845;
      _850 = _846;
    } else {
      _848 = _783;
      _849 = _787;
      _850 = _791;
    }
    float _851 = _848 * _748;
    float _852 = exp2(_851);
    float _853 = _852 * _747;
    float _854 = saturate(_853);
    float _855 = _848 * _747;
    float _856 = _848 - _855;
    float _857 = saturate(_856);
    float _858 = max(_747, _857);
    float _859 = min(_858, _854);
    float _860 = _849 * _748;
    float _861 = exp2(_860);
    float _862 = _861 * _747;
    float _863 = saturate(_862);
    float _864 = _849 * _747;
    float _865 = _849 - _864;
    float _866 = saturate(_865);
    float _867 = max(_747, _866);
    float _868 = min(_867, _863);
    float _869 = _850 * _748;
    float _870 = exp2(_869);
    float _871 = _870 * _747;
    float _872 = saturate(_871);
    float _873 = _850 * _747;
    float _874 = _850 - _873;
    float _875 = saturate(_874);
    float _876 = max(_747, _875);
    float _877 = min(_876, _872);
    _879 = _859;
    _880 = _868;
    _881 = _877;
  } else {
    _879 = _783;
    _880 = _787;
    _881 = _791;
  }
  float _882 = _879 * _771;
  float _883 = _880 * _772;
  float _884 = _883 + _882;
  float _885 = _881 * _773;
  float _886 = _884 + _885;
  float _887 = 1.0f / _886;
  float _888 = _887 * _823;
  float _889 = saturate(_888);
  float _890 = _889 * _879;
  float _891 = saturate(_890);
  float _892 = _889 * _880;
  float _893 = saturate(_892);
  float _894 = _889 * _881;
  float _895 = saturate(_894);
  float _896 = _891 * _758;
  float _897 = _758 - _896;
  float _898 = _893 * _759;
  float _899 = _759 - _898;
  float _900 = _895 * _760;
  float _901 = _760 - _900;
  float _902 = _895 * _773;
  float _903 = _891 * _771;
  float _904 = _893 * _772;
  float _905 = _823 - _903;
  float _906 = _905 - _904;
  float _907 = _906 - _902;
  float _908 = saturate(_907);
  float _909 = _899 * _772;
  float _910 = _897 * _771;
  float _911 = _901 * _773;
  float _912 = _909 + _910;
  float _913 = _912 + _911;
  float _914 = 1.0f / _913;
  float _915 = _914 * _908;
  float _916 = _915 * _897;
  float _917 = _916 + _891;
  float _918 = saturate(_917);
  float _919 = _915 * _899;
  float _920 = _919 + _893;
  float _921 = saturate(_920);
  float _922 = _915 * _901;
  float _923 = _922 + _895;
  float _924 = saturate(_923);
  float _925 = _924 * _773;
  float _926 = _918 * _771;
  float _927 = _921 * _772;
  float _928 = _823 - _926;
  float _929 = _928 - _927;
  float _930 = _929 - _925;
  float _931 = saturate(_930);
  float _932 = _931 * _768;
  float _933 = _932 + _918;
  float _934 = saturate(_933);
  float _935 = _931 * _769;
  float _936 = _935 + _921;
  float _937 = saturate(_936);
  float _938 = _931 * _770;
  float _939 = _938 + _924;
  float _940 = saturate(_939);
  if (!_685) {
    float _942 = _934 * _744;
    float _943 = _937 * _745;
    float _944 = _940 * _746;
    float _945 = _943 + _942;
    float _946 = _945 + _944;
    float _947 = _937 * _742;
    float _948 = _934 * _741;
    float _949 = _940 * _743;
    float _950 = _947 + _948;
    float _951 = _950 + _949;
    float _952 = _940 * _740;
    float _953 = _937 * _739;
    float _954 = _934 * _738;
    float _955 = _953 + _954;
    float _956 = _955 + _952;
    if (!_683) {
      float _958 = saturate(_946);
      float _959 = saturate(_951);
      float _960 = saturate(_956);
      _962 = _960;
      _963 = _959;
      _964 = _958;
    } else {
      _962 = _956;
      _963 = _951;
      _964 = _946;
    }
  } else {
    _962 = _940;
    _963 = _937;
    _964 = _934;
  }
  if (!_680) {
    float _966 = _964 * _744;
    float _967 = _963 * _744;
    float _968 = _962 * _744;
    _970 = _968;
    _971 = _967;
    _972 = _966;
  } else {
    _970 = _962;
    _971 = _963;
    _972 = _964;
  }
  if (_651) {
    float _976 = cb1_018z * 9.999999747378752e-05f;
    float _977 = _976 * _972;
    float _978 = _976 * _971;
    float _979 = _976 * _970;
    float _981 = 5000.0f / cb1_018y;
    float _982 = _977 * _981;
    float _983 = _978 * _981;
    float _984 = _979 * _981;
    _986 = _982;
    _987 = _983;
    _988 = _984;
  } else {
    _986 = _972;
    _987 = _971;
    _988 = _970;
  }
  float _989 = _986 * 1.6047500371932983f;
  float _990 = mad(-0.5310800075531006f, _987, _989);
  float _991 = mad(-0.07366999983787537f, _988, _990);
  float _992 = _986 * -0.10208000242710114f;
  float _993 = mad(1.1081299781799316f, _987, _992);
  float _994 = mad(-0.006049999967217445f, _988, _993);
  float _995 = _986 * -0.0032599999103695154f;
  float _996 = mad(-0.07275000214576721f, _987, _995);
  float _997 = mad(1.0760200023651123f, _988, _996);
  if (_651) {
    // float _999 = max(_991, 0.0f);
    // float _1000 = max(_994, 0.0f);
    // float _1001 = max(_997, 0.0f);
    // bool _1002 = !(_999 >= 0.0030399328097701073f);
    // if (!_1002) {
    //   float _1004 = abs(_999);
    //   float _1005 = log2(_1004);
    //   float _1006 = _1005 * 0.4166666567325592f;
    //   float _1007 = exp2(_1006);
    //   float _1008 = _1007 * 1.0549999475479126f;
    //   float _1009 = _1008 + -0.054999999701976776f;
    //   _1013 = _1009;
    // } else {
    //   float _1011 = _999 * 12.923210144042969f;
    //   _1013 = _1011;
    // }
    // bool _1014 = !(_1000 >= 0.0030399328097701073f);
    // if (!_1014) {
    //   float _1016 = abs(_1000);
    //   float _1017 = log2(_1016);
    //   float _1018 = _1017 * 0.4166666567325592f;
    //   float _1019 = exp2(_1018);
    //   float _1020 = _1019 * 1.0549999475479126f;
    //   float _1021 = _1020 + -0.054999999701976776f;
    //   _1025 = _1021;
    // } else {
    //   float _1023 = _1000 * 12.923210144042969f;
    //   _1025 = _1023;
    // }
    // bool _1026 = !(_1001 >= 0.0030399328097701073f);
    // if (!_1026) {
    //   float _1028 = abs(_1001);
    //   float _1029 = log2(_1028);
    //   float _1030 = _1029 * 0.4166666567325592f;
    //   float _1031 = exp2(_1030);
    //   float _1032 = _1031 * 1.0549999475479126f;
    //   float _1033 = _1032 + -0.054999999701976776f;
    //   _1106 = _1013;
    //   _1107 = _1025;
    //   _1108 = _1033;
    // } else {
    //   float _1035 = _1001 * 12.923210144042969f;
    //   _1106 = _1013;
    //   _1107 = _1025;
    //   _1108 = _1035;
    // }
    _1106 = renodx::color::srgb::EncodeSafe(_991);
    _1107 = renodx::color::srgb::EncodeSafe(_994);
    _1108 = renodx::color::srgb::EncodeSafe(_997);

  } else {
    float _1037 = saturate(_991);
    float _1038 = saturate(_994);
    float _1039 = saturate(_997);
    bool _1040 = ((uint)(cb1_018w) == -2);
    if (!_1040) {
      bool _1042 = !(_1037 >= 0.0030399328097701073f);
      if (!_1042) {
        float _1044 = abs(_1037);
        float _1045 = log2(_1044);
        float _1046 = _1045 * 0.4166666567325592f;
        float _1047 = exp2(_1046);
        float _1048 = _1047 * 1.0549999475479126f;
        float _1049 = _1048 + -0.054999999701976776f;
        _1053 = _1049;
      } else {
        float _1051 = _1037 * 12.923210144042969f;
        _1053 = _1051;
      }
      bool _1054 = !(_1038 >= 0.0030399328097701073f);
      if (!_1054) {
        float _1056 = abs(_1038);
        float _1057 = log2(_1056);
        float _1058 = _1057 * 0.4166666567325592f;
        float _1059 = exp2(_1058);
        float _1060 = _1059 * 1.0549999475479126f;
        float _1061 = _1060 + -0.054999999701976776f;
        _1065 = _1061;
      } else {
        float _1063 = _1038 * 12.923210144042969f;
        _1065 = _1063;
      }
      bool _1066 = !(_1039 >= 0.0030399328097701073f);
      if (!_1066) {
        float _1068 = abs(_1039);
        float _1069 = log2(_1068);
        float _1070 = _1069 * 0.4166666567325592f;
        float _1071 = exp2(_1070);
        float _1072 = _1071 * 1.0549999475479126f;
        float _1073 = _1072 + -0.054999999701976776f;
        _1077 = _1053;
        _1078 = _1065;
        _1079 = _1073;
      } else {
        float _1075 = _1039 * 12.923210144042969f;
        _1077 = _1053;
        _1078 = _1065;
        _1079 = _1075;
      }
    } else {
      _1077 = _1037;
      _1078 = _1038;
      _1079 = _1039;
    }
    float _1084 = abs(_1077);
    float _1085 = abs(_1078);
    float _1086 = abs(_1079);
    float _1087 = log2(_1084);
    float _1088 = log2(_1085);
    float _1089 = log2(_1086);
    float _1090 = _1087 * cb2_000z;
    float _1091 = _1088 * cb2_000z;
    float _1092 = _1089 * cb2_000z;
    float _1093 = exp2(_1090);
    float _1094 = exp2(_1091);
    float _1095 = exp2(_1092);
    float _1096 = _1093 * cb2_000y;
    float _1097 = _1094 * cb2_000y;
    float _1098 = _1095 * cb2_000y;
    float _1099 = _1096 + cb2_000x;
    float _1100 = _1097 + cb2_000x;
    float _1101 = _1098 + cb2_000x;
    float _1102 = saturate(_1099);
    float _1103 = saturate(_1100);
    float _1104 = saturate(_1101);
    _1106 = _1102;
    _1107 = _1103;
    _1108 = _1104;
  }
  float _1109 = dot(float3(_1106, _1107, _1108), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _1106;
  SV_Target.y = _1107;
  SV_Target.z = _1108;
  SV_Target.w = _1109;
  SV_Target_1.x = _1109;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

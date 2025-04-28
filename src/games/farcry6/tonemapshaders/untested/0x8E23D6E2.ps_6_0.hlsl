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
  float cb2_003x : packoffset(c003.x);
  float cb2_003y : packoffset(c003.y);
  float cb2_003z : packoffset(c003.z);
  float cb2_003w : packoffset(c003.w);
  float cb2_004x : packoffset(c004.x);
  float cb2_004y : packoffset(c004.y);
  float cb2_004z : packoffset(c004.z);
  float cb2_004w : packoffset(c004.w);
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
  float4 _28 = t8.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _32 = _28.x * 6.283199787139893f;
  float _33 = cos(_32);
  float _34 = sin(_32);
  float _35 = _33 * _28.z;
  float _36 = _34 * _28.z;
  float _37 = _35 + TEXCOORD0_centroid.x;
  float _38 = _36 + TEXCOORD0_centroid.y;
  float _39 = _37 * 10.0f;
  float _40 = 10.0f - _39;
  float _41 = min(_39, _40);
  float _42 = saturate(_41);
  float _43 = _42 * _35;
  float _44 = _38 * 10.0f;
  float _45 = 10.0f - _44;
  float _46 = min(_44, _45);
  float _47 = saturate(_46);
  float _48 = _47 * _36;
  float _49 = _43 + TEXCOORD0_centroid.x;
  float _50 = _48 + TEXCOORD0_centroid.y;
  float4 _51 = t8.SampleLevel(s2_space2, float2(_49, _50), 0.0f);
  float _53 = _51.w * _43;
  float _54 = _51.w * _48;
  float _55 = 1.0f - _28.y;
  float _56 = saturate(_55);
  float _57 = _53 * _56;
  float _58 = _54 * _56;
  float _62 = cb2_015x * TEXCOORD0_centroid.x;
  float _63 = cb2_015y * TEXCOORD0_centroid.y;
  float _66 = _62 + cb2_015z;
  float _67 = _63 + cb2_015w;
  float4 _68 = t9.SampleLevel(s0_space2, float2(_66, _67), 0.0f);
  float _72 = saturate(_68.x);
  float _73 = saturate(_68.z);
  float _76 = cb2_026x * _73;
  float _77 = _72 * 6.283199787139893f;
  float _78 = cos(_77);
  float _79 = sin(_77);
  float _80 = _76 * _78;
  float _81 = _79 * _76;
  float _82 = 1.0f - _68.y;
  float _83 = saturate(_82);
  float _84 = _80 * _83;
  float _85 = _81 * _83;
  float _86 = _57 + TEXCOORD0_centroid.x;
  float _87 = _86 + _84;
  float _88 = _58 + TEXCOORD0_centroid.y;
  float _89 = _88 + _85;
  float4 _90 = t8.SampleLevel(s2_space2, float2(_87, _89), 0.0f);
  bool _92 = (_90.y > 0.0f);
  float _93 = select(_92, TEXCOORD0_centroid.x, _87);
  float _94 = select(_92, TEXCOORD0_centroid.y, _89);
  float4 _95 = t1.SampleLevel(s4_space2, float2(_93, _94), 0.0f);
  float _99 = max(_95.x, 0.0f);
  float _100 = max(_95.y, 0.0f);
  float _101 = max(_95.z, 0.0f);
  float _102 = min(_99, 65000.0f);
  float _103 = min(_100, 65000.0f);
  float _104 = min(_101, 65000.0f);
  float4 _105 = t4.SampleLevel(s2_space2, float2(_93, _94), 0.0f);
  float _110 = max(_105.x, 0.0f);
  float _111 = max(_105.y, 0.0f);
  float _112 = max(_105.z, 0.0f);
  float _113 = max(_105.w, 0.0f);
  float _114 = min(_110, 5000.0f);
  float _115 = min(_111, 5000.0f);
  float _116 = min(_112, 5000.0f);
  float _117 = min(_113, 5000.0f);
  float _120 = _26.x * cb0_028z;
  float _121 = _120 + cb0_028x;
  float _122 = cb2_027w / _121;
  float _123 = 1.0f - _122;
  float _124 = abs(_123);
  float _126 = cb2_027y * _124;
  float _128 = _126 - cb2_027z;
  float _129 = saturate(_128);
  float _130 = max(_129, _117);
  float _131 = saturate(_130);
  float4 _132 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _136 = _114 - _102;
  float _137 = _115 - _103;
  float _138 = _116 - _104;
  float _139 = _131 * _136;
  float _140 = _131 * _137;
  float _141 = _131 * _138;
  float _142 = _139 + _102;
  float _143 = _140 + _103;
  float _144 = _141 + _104;
  float _145 = dot(float3(_142, _143, _144), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _149 = t0[0].SExposureData_020;
  float _151 = t0[0].SExposureData_004;
  float _153 = cb2_018x * 0.5f;
  float _154 = _153 * cb2_018y;
  float _155 = _151.x - _154;
  float _156 = cb2_018y * cb2_018x;
  float _157 = 1.0f / _156;
  float _158 = _155 * _157;
  float _159 = _145 / _149.x;
  float _160 = _159 * 5464.01611328125f;
  float _161 = _160 + 9.99999993922529e-09f;
  float _162 = log2(_161);
  float _163 = _162 - _155;
  float _164 = _163 * _157;
  float _165 = saturate(_164);
  float2 _166 = t10.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _165), 0.0f);
  float _169 = max(_166.y, 1.0000000116860974e-07f);
  float _170 = _166.x / _169;
  float _171 = _170 + _158;
  float _172 = _171 / _157;
  float _173 = _172 - _151.x;
  float _174 = -0.0f - _173;
  float _176 = _174 - cb2_027x;
  float _177 = max(0.0f, _176);
  float _179 = cb2_026z * _177;
  float _180 = _173 - cb2_027x;
  float _181 = max(0.0f, _180);
  float _183 = cb2_026w * _181;
  bool _184 = (_173 < 0.0f);
  float _185 = select(_184, _179, _183);
  float _186 = exp2(_185);
  float _187 = _186 * _142;
  float _188 = _186 * _143;
  float _189 = _186 * _144;
  float _194 = cb2_024y * _132.x;
  float _195 = cb2_024z * _132.y;
  float _196 = cb2_024w * _132.z;
  float _197 = _194 + _187;
  float _198 = _195 + _188;
  float _199 = _196 + _189;
  float _204 = _197 * cb2_025x;
  float _205 = _198 * cb2_025y;
  float _206 = _199 * cb2_025z;
  float _207 = dot(float3(_204, _205, _206), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _208 = t0[0].SExposureData_012;
  float _210 = _207 * 5464.01611328125f;
  float _211 = _210 * _208.x;
  float _212 = _211 + 9.99999993922529e-09f;
  float _213 = log2(_212);
  float _214 = _213 + 16.929765701293945f;
  float _215 = _214 * 0.05734497308731079f;
  float _216 = saturate(_215);
  float _217 = _216 * _216;
  float _218 = _216 * 2.0f;
  float _219 = 3.0f - _218;
  float _220 = _217 * _219;
  float _221 = _205 * 0.8450999855995178f;
  float _222 = _206 * 0.14589999616146088f;
  float _223 = _221 + _222;
  float _224 = _223 * 2.4890189170837402f;
  float _225 = _223 * 0.3754962384700775f;
  float _226 = _223 * 2.811495304107666f;
  float _227 = _223 * 5.519708156585693f;
  float _228 = _207 - _224;
  float _229 = _220 * _228;
  float _230 = _229 + _224;
  float _231 = _220 * 0.5f;
  float _232 = _231 + 0.5f;
  float _233 = _232 * _228;
  float _234 = _233 + _224;
  float _235 = _204 - _225;
  float _236 = _205 - _226;
  float _237 = _206 - _227;
  float _238 = _232 * _235;
  float _239 = _232 * _236;
  float _240 = _232 * _237;
  float _241 = _238 + _225;
  float _242 = _239 + _226;
  float _243 = _240 + _227;
  float _244 = 1.0f / _234;
  float _245 = _230 * _244;
  float _246 = _245 * _241;
  float _247 = _245 * _242;
  float _248 = _245 * _243;
  float _252 = cb2_020x * TEXCOORD0_centroid.x;
  float _253 = cb2_020y * TEXCOORD0_centroid.y;
  float _256 = _252 + cb2_020z;
  float _257 = _253 + cb2_020w;
  float _260 = dot(float2(_256, _257), float2(_256, _257));
  float _261 = 1.0f - _260;
  float _262 = saturate(_261);
  float _263 = log2(_262);
  float _264 = _263 * cb2_021w;
  float _265 = exp2(_264);
  float _269 = _246 - cb2_021x;
  float _270 = _247 - cb2_021y;
  float _271 = _248 - cb2_021z;
  float _272 = _269 * _265;
  float _273 = _270 * _265;
  float _274 = _271 * _265;
  float _275 = _272 + cb2_021x;
  float _276 = _273 + cb2_021y;
  float _277 = _274 + cb2_021z;
  float _278 = t0[0].SExposureData_000;
  float _280 = max(_149.x, 0.0010000000474974513f);
  float _281 = 1.0f / _280;
  float _282 = _281 * _278.x;
  bool _285 = ((uint)(cb2_069y) == 0);
  float _291;
  float _292;
  float _293;
  float _347;
  float _348;
  float _349;
  float _395;
  float _396;
  float _397;
  float _442;
  float _443;
  float _444;
  float _445;
  float _494;
  float _495;
  float _496;
  float _497;
  float _522;
  float _523;
  float _524;
  float _674;
  float _711;
  float _712;
  float _713;
  float _742;
  float _743;
  float _744;
  float _825;
  float _826;
  float _827;
  float _833;
  float _834;
  float _835;
  float _849;
  float _850;
  float _851;
  float _876;
  float _888;
  float _916;
  float _928;
  float _940;
  float _941;
  float _942;
  float _969;
  float _970;
  float _971;
  if (!_285) {
    float _287 = _282 * _275;
    float _288 = _282 * _276;
    float _289 = _282 * _277;
    _291 = _287;
    _292 = _288;
    _293 = _289;
  } else {
    _291 = _275;
    _292 = _276;
    _293 = _277;
  }
  float _294 = _291 * 0.6130970120429993f;
  float _295 = mad(0.33952298760414124f, _292, _294);
  float _296 = mad(0.04737899824976921f, _293, _295);
  float _297 = _291 * 0.07019399851560593f;
  float _298 = mad(0.9163540005683899f, _292, _297);
  float _299 = mad(0.013451999984681606f, _293, _298);
  float _300 = _291 * 0.02061600051820278f;
  float _301 = mad(0.10956999659538269f, _292, _300);
  float _302 = mad(0.8698149919509888f, _293, _301);
  float _303 = log2(_296);
  float _304 = log2(_299);
  float _305 = log2(_302);
  float _306 = _303 * 0.04211956635117531f;
  float _307 = _304 * 0.04211956635117531f;
  float _308 = _305 * 0.04211956635117531f;
  float _309 = _306 + 0.6252607107162476f;
  float _310 = _307 + 0.6252607107162476f;
  float _311 = _308 + 0.6252607107162476f;
  float4 _312 = t6.SampleLevel(s2_space2, float3(_309, _310, _311), 0.0f);
  bool _318 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_318 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _322 = cb2_017x * _312.x;
    float _323 = cb2_017x * _312.y;
    float _324 = cb2_017x * _312.z;
    float _326 = _322 + cb2_017y;
    float _327 = _323 + cb2_017y;
    float _328 = _324 + cb2_017y;
    float _329 = exp2(_326);
    float _330 = exp2(_327);
    float _331 = exp2(_328);
    float _332 = _329 + 1.0f;
    float _333 = _330 + 1.0f;
    float _334 = _331 + 1.0f;
    float _335 = 1.0f / _332;
    float _336 = 1.0f / _333;
    float _337 = 1.0f / _334;
    float _339 = cb2_017z * _335;
    float _340 = cb2_017z * _336;
    float _341 = cb2_017z * _337;
    float _343 = _339 + cb2_017w;
    float _344 = _340 + cb2_017w;
    float _345 = _341 + cb2_017w;
    _347 = _343;
    _348 = _344;
    _349 = _345;
  } else {
    _347 = _312.x;
    _348 = _312.y;
    _349 = _312.z;
  }
  float _350 = _347 * 23.0f;
  float _351 = _350 + -14.473931312561035f;
  float _352 = exp2(_351);
  float _353 = _348 * 23.0f;
  float _354 = _353 + -14.473931312561035f;
  float _355 = exp2(_354);
  float _356 = _349 * 23.0f;
  float _357 = _356 + -14.473931312561035f;
  float _358 = exp2(_357);
  float _363 = cb2_004x * TEXCOORD0_centroid.x;
  float _364 = cb2_004y * TEXCOORD0_centroid.y;
  float _367 = _363 + cb2_004z;
  float _368 = _364 + cb2_004w;
  float4 _374 = t7.Sample(s2_space2, float2(_367, _368));
  float _379 = _374.x * cb2_003x;
  float _380 = _374.y * cb2_003y;
  float _381 = _374.z * cb2_003z;
  float _382 = _374.w * cb2_003w;
  float _385 = _382 + cb2_026y;
  float _386 = saturate(_385);
  bool _389 = ((uint)(cb2_069y) == 0);
  if (!_389) {
    float _391 = _379 * _282;
    float _392 = _380 * _282;
    float _393 = _381 * _282;
    _395 = _391;
    _396 = _392;
    _397 = _393;
  } else {
    _395 = _379;
    _396 = _380;
    _397 = _381;
  }
  bool _400 = ((uint)(cb2_028x) == 2);
  bool _401 = ((uint)(cb2_028x) == 3);
  int _402 = (uint)(cb2_028x) & -2;
  bool _403 = (_402 == 2);
  bool _404 = ((uint)(cb2_028x) == 6);
  bool _405 = _403 || _404;
  if (_405) {
    float _407 = _395 * _386;
    float _408 = _396 * _386;
    float _409 = _397 * _386;
    float _410 = _386 * _386;
    _442 = _407;
    _443 = _408;
    _444 = _409;
    _445 = _410;
  } else {
    bool _412 = ((uint)(cb2_028x) == 4);
    if (_412) {
      float _414 = _395 + -1.0f;
      float _415 = _396 + -1.0f;
      float _416 = _397 + -1.0f;
      float _417 = _386 + -1.0f;
      float _418 = _414 * _386;
      float _419 = _415 * _386;
      float _420 = _416 * _386;
      float _421 = _417 * _386;
      float _422 = _418 + 1.0f;
      float _423 = _419 + 1.0f;
      float _424 = _420 + 1.0f;
      float _425 = _421 + 1.0f;
      _442 = _422;
      _443 = _423;
      _444 = _424;
      _445 = _425;
    } else {
      bool _427 = ((uint)(cb2_028x) == 5);
      if (_427) {
        float _429 = _395 + -0.5f;
        float _430 = _396 + -0.5f;
        float _431 = _397 + -0.5f;
        float _432 = _386 + -0.5f;
        float _433 = _429 * _386;
        float _434 = _430 * _386;
        float _435 = _431 * _386;
        float _436 = _432 * _386;
        float _437 = _433 + 0.5f;
        float _438 = _434 + 0.5f;
        float _439 = _435 + 0.5f;
        float _440 = _436 + 0.5f;
        _442 = _437;
        _443 = _438;
        _444 = _439;
        _445 = _440;
      } else {
        _442 = _395;
        _443 = _396;
        _444 = _397;
        _445 = _386;
      }
    }
  }
  if (_400) {
    float _447 = _442 + _352;
    float _448 = _443 + _355;
    float _449 = _444 + _358;
    _494 = _447;
    _495 = _448;
    _496 = _449;
    _497 = cb2_025w;
  } else {
    if (_401) {
      float _452 = 1.0f - _442;
      float _453 = 1.0f - _443;
      float _454 = 1.0f - _444;
      float _455 = _452 * _352;
      float _456 = _453 * _355;
      float _457 = _454 * _358;
      float _458 = _455 + _442;
      float _459 = _456 + _443;
      float _460 = _457 + _444;
      _494 = _458;
      _495 = _459;
      _496 = _460;
      _497 = cb2_025w;
    } else {
      bool _462 = ((uint)(cb2_028x) == 4);
      if (_462) {
        float _464 = _442 * _352;
        float _465 = _443 * _355;
        float _466 = _444 * _358;
        _494 = _464;
        _495 = _465;
        _496 = _466;
        _497 = cb2_025w;
      } else {
        bool _468 = ((uint)(cb2_028x) == 5);
        if (_468) {
          float _470 = _352 * 2.0f;
          float _471 = _470 * _442;
          float _472 = _355 * 2.0f;
          float _473 = _472 * _443;
          float _474 = _358 * 2.0f;
          float _475 = _474 * _444;
          _494 = _471;
          _495 = _473;
          _496 = _475;
          _497 = cb2_025w;
        } else {
          if (_404) {
            float _478 = _352 - _442;
            float _479 = _355 - _443;
            float _480 = _358 - _444;
            _494 = _478;
            _495 = _479;
            _496 = _480;
            _497 = cb2_025w;
          } else {
            float _482 = _442 - _352;
            float _483 = _443 - _355;
            float _484 = _444 - _358;
            float _485 = _445 * _482;
            float _486 = _445 * _483;
            float _487 = _445 * _484;
            float _488 = _485 + _352;
            float _489 = _486 + _355;
            float _490 = _487 + _358;
            float _491 = 1.0f - _445;
            float _492 = _491 * cb2_025w;
            _494 = _488;
            _495 = _489;
            _496 = _490;
            _497 = _492;
          }
        }
      }
    }
  }
  float _503 = cb2_016x - _494;
  float _504 = cb2_016y - _495;
  float _505 = cb2_016z - _496;
  float _506 = _503 * cb2_016w;
  float _507 = _504 * cb2_016w;
  float _508 = _505 * cb2_016w;
  float _509 = _506 + _494;
  float _510 = _507 + _495;
  float _511 = _508 + _496;
  bool _514 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_514 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _518 = cb2_024x * _509;
    float _519 = cb2_024x * _510;
    float _520 = cb2_024x * _511;
    _522 = _518;
    _523 = _519;
    _524 = _520;
  } else {
    _522 = _509;
    _523 = _510;
    _524 = _511;
  }
  float _527 = _522 * 0.9708889722824097f;
  float _528 = mad(0.026962999254465103f, _523, _527);
  float _529 = mad(0.002148000057786703f, _524, _528);
  float _530 = _522 * 0.01088900025933981f;
  float _531 = mad(0.9869629740715027f, _523, _530);
  float _532 = mad(0.002148000057786703f, _524, _531);
  float _533 = mad(0.026962999254465103f, _523, _530);
  float _534 = mad(0.9621480107307434f, _524, _533);
  float _535 = max(_529, 0.0f);
  float _536 = max(_532, 0.0f);
  float _537 = max(_534, 0.0f);
  float _538 = min(_535, cb2_095y);
  float _539 = min(_536, cb2_095y);
  float _540 = min(_537, cb2_095y);
  bool _543 = ((uint)(cb2_095x) == 0);
  bool _546 = ((uint)(cb2_094w) == 0);
  bool _548 = ((uint)(cb2_094z) == 0);
  bool _550 = ((uint)(cb2_094y) != 0);
  bool _552 = ((uint)(cb2_094x) == 0);
  bool _554 = ((uint)(cb2_069z) != 0);
  float _601 = asfloat((uint)(cb2_075y));
  float _602 = asfloat((uint)(cb2_075z));
  float _603 = asfloat((uint)(cb2_075w));
  float _604 = asfloat((uint)(cb2_074z));
  float _605 = asfloat((uint)(cb2_074w));
  float _606 = asfloat((uint)(cb2_075x));
  float _607 = asfloat((uint)(cb2_073w));
  float _608 = asfloat((uint)(cb2_074x));
  float _609 = asfloat((uint)(cb2_074y));
  float _610 = asfloat((uint)(cb2_077x));
  float _611 = asfloat((uint)(cb2_077y));
  float _612 = asfloat((uint)(cb2_079x));
  float _613 = asfloat((uint)(cb2_079y));
  float _614 = asfloat((uint)(cb2_079z));
  float _615 = asfloat((uint)(cb2_078y));
  float _616 = asfloat((uint)(cb2_078z));
  float _617 = asfloat((uint)(cb2_078w));
  float _618 = asfloat((uint)(cb2_077z));
  float _619 = asfloat((uint)(cb2_077w));
  float _620 = asfloat((uint)(cb2_078x));
  float _621 = asfloat((uint)(cb2_072y));
  float _622 = asfloat((uint)(cb2_072z));
  float _623 = asfloat((uint)(cb2_072w));
  float _624 = asfloat((uint)(cb2_071x));
  float _625 = asfloat((uint)(cb2_071y));
  float _626 = asfloat((uint)(cb2_076x));
  float _627 = asfloat((uint)(cb2_070w));
  float _628 = asfloat((uint)(cb2_070x));
  float _629 = asfloat((uint)(cb2_070y));
  float _630 = asfloat((uint)(cb2_070z));
  float _631 = asfloat((uint)(cb2_073x));
  float _632 = asfloat((uint)(cb2_073y));
  float _633 = asfloat((uint)(cb2_073z));
  float _634 = asfloat((uint)(cb2_071z));
  float _635 = asfloat((uint)(cb2_071w));
  float _636 = asfloat((uint)(cb2_072x));
  float _637 = max(_539, _540);
  float _638 = max(_538, _637);
  float _639 = 1.0f / _638;
  float _640 = _639 * _538;
  float _641 = _639 * _539;
  float _642 = _639 * _540;
  float _643 = abs(_640);
  float _644 = log2(_643);
  float _645 = _644 * _628;
  float _646 = exp2(_645);
  float _647 = abs(_641);
  float _648 = log2(_647);
  float _649 = _648 * _629;
  float _650 = exp2(_649);
  float _651 = abs(_642);
  float _652 = log2(_651);
  float _653 = _652 * _630;
  float _654 = exp2(_653);
  if (_550) {
    float _657 = asfloat((uint)(cb2_076w));
    float _659 = asfloat((uint)(cb2_076z));
    float _661 = asfloat((uint)(cb2_076y));
    float _662 = _659 * _539;
    float _663 = _661 * _538;
    float _664 = _657 * _540;
    float _665 = _663 + _664;
    float _666 = _665 + _662;
    _674 = _666;
  } else {
    float _668 = _635 * _539;
    float _669 = _634 * _538;
    float _670 = _636 * _540;
    float _671 = _668 + _669;
    float _672 = _671 + _670;
    _674 = _672;
  }
  float _675 = abs(_674);
  float _676 = log2(_675);
  float _677 = _676 * _627;
  float _678 = exp2(_677);
  float _679 = log2(_678);
  float _680 = _679 * _626;
  float _681 = exp2(_680);
  float _682 = select(_554, _681, _678);
  float _683 = _682 * _624;
  float _684 = _683 + _625;
  float _685 = 1.0f / _684;
  float _686 = _685 * _678;
  if (_550) {
    if (!_552) {
      float _689 = _646 * _618;
      float _690 = _650 * _619;
      float _691 = _654 * _620;
      float _692 = _690 + _689;
      float _693 = _692 + _691;
      float _694 = _650 * _616;
      float _695 = _646 * _615;
      float _696 = _654 * _617;
      float _697 = _694 + _695;
      float _698 = _697 + _696;
      float _699 = _654 * _614;
      float _700 = _650 * _613;
      float _701 = _646 * _612;
      float _702 = _700 + _701;
      float _703 = _702 + _699;
      float _704 = max(_698, _703);
      float _705 = max(_693, _704);
      float _706 = 1.0f / _705;
      float _707 = _706 * _693;
      float _708 = _706 * _698;
      float _709 = _706 * _703;
      _711 = _707;
      _712 = _708;
      _713 = _709;
    } else {
      _711 = _646;
      _712 = _650;
      _713 = _654;
    }
    float _714 = _711 * _611;
    float _715 = exp2(_714);
    float _716 = _715 * _610;
    float _717 = saturate(_716);
    float _718 = _711 * _610;
    float _719 = _711 - _718;
    float _720 = saturate(_719);
    float _721 = max(_610, _720);
    float _722 = min(_721, _717);
    float _723 = _712 * _611;
    float _724 = exp2(_723);
    float _725 = _724 * _610;
    float _726 = saturate(_725);
    float _727 = _712 * _610;
    float _728 = _712 - _727;
    float _729 = saturate(_728);
    float _730 = max(_610, _729);
    float _731 = min(_730, _726);
    float _732 = _713 * _611;
    float _733 = exp2(_732);
    float _734 = _733 * _610;
    float _735 = saturate(_734);
    float _736 = _713 * _610;
    float _737 = _713 - _736;
    float _738 = saturate(_737);
    float _739 = max(_610, _738);
    float _740 = min(_739, _735);
    _742 = _722;
    _743 = _731;
    _744 = _740;
  } else {
    _742 = _646;
    _743 = _650;
    _744 = _654;
  }
  float _745 = _742 * _634;
  float _746 = _743 * _635;
  float _747 = _746 + _745;
  float _748 = _744 * _636;
  float _749 = _747 + _748;
  float _750 = 1.0f / _749;
  float _751 = _750 * _686;
  float _752 = saturate(_751);
  float _753 = _752 * _742;
  float _754 = saturate(_753);
  float _755 = _752 * _743;
  float _756 = saturate(_755);
  float _757 = _752 * _744;
  float _758 = saturate(_757);
  float _759 = _754 * _621;
  float _760 = _621 - _759;
  float _761 = _756 * _622;
  float _762 = _622 - _761;
  float _763 = _758 * _623;
  float _764 = _623 - _763;
  float _765 = _758 * _636;
  float _766 = _754 * _634;
  float _767 = _756 * _635;
  float _768 = _686 - _766;
  float _769 = _768 - _767;
  float _770 = _769 - _765;
  float _771 = saturate(_770);
  float _772 = _762 * _635;
  float _773 = _760 * _634;
  float _774 = _764 * _636;
  float _775 = _772 + _773;
  float _776 = _775 + _774;
  float _777 = 1.0f / _776;
  float _778 = _777 * _771;
  float _779 = _778 * _760;
  float _780 = _779 + _754;
  float _781 = saturate(_780);
  float _782 = _778 * _762;
  float _783 = _782 + _756;
  float _784 = saturate(_783);
  float _785 = _778 * _764;
  float _786 = _785 + _758;
  float _787 = saturate(_786);
  float _788 = _787 * _636;
  float _789 = _781 * _634;
  float _790 = _784 * _635;
  float _791 = _686 - _789;
  float _792 = _791 - _790;
  float _793 = _792 - _788;
  float _794 = saturate(_793);
  float _795 = _794 * _631;
  float _796 = _795 + _781;
  float _797 = saturate(_796);
  float _798 = _794 * _632;
  float _799 = _798 + _784;
  float _800 = saturate(_799);
  float _801 = _794 * _633;
  float _802 = _801 + _787;
  float _803 = saturate(_802);
  if (!_548) {
    float _805 = _797 * _607;
    float _806 = _800 * _608;
    float _807 = _803 * _609;
    float _808 = _806 + _805;
    float _809 = _808 + _807;
    float _810 = _800 * _605;
    float _811 = _797 * _604;
    float _812 = _803 * _606;
    float _813 = _810 + _811;
    float _814 = _813 + _812;
    float _815 = _803 * _603;
    float _816 = _800 * _602;
    float _817 = _797 * _601;
    float _818 = _816 + _817;
    float _819 = _818 + _815;
    if (!_546) {
      float _821 = saturate(_809);
      float _822 = saturate(_814);
      float _823 = saturate(_819);
      _825 = _823;
      _826 = _822;
      _827 = _821;
    } else {
      _825 = _819;
      _826 = _814;
      _827 = _809;
    }
  } else {
    _825 = _803;
    _826 = _800;
    _827 = _797;
  }
  if (!_543) {
    float _829 = _827 * _607;
    float _830 = _826 * _607;
    float _831 = _825 * _607;
    _833 = _831;
    _834 = _830;
    _835 = _829;
  } else {
    _833 = _825;
    _834 = _826;
    _835 = _827;
  }
  if (_514) {
    float _839 = cb1_018z * 9.999999747378752e-05f;
    float _840 = _839 * _835;
    float _841 = _839 * _834;
    float _842 = _839 * _833;
    float _844 = 5000.0f / cb1_018y;
    float _845 = _840 * _844;
    float _846 = _841 * _844;
    float _847 = _842 * _844;
    _849 = _845;
    _850 = _846;
    _851 = _847;
  } else {
    _849 = _835;
    _850 = _834;
    _851 = _833;
  }
  float _852 = _849 * 1.6047500371932983f;
  float _853 = mad(-0.5310800075531006f, _850, _852);
  float _854 = mad(-0.07366999983787537f, _851, _853);
  float _855 = _849 * -0.10208000242710114f;
  float _856 = mad(1.1081299781799316f, _850, _855);
  float _857 = mad(-0.006049999967217445f, _851, _856);
  float _858 = _849 * -0.0032599999103695154f;
  float _859 = mad(-0.07275000214576721f, _850, _858);
  float _860 = mad(1.0760200023651123f, _851, _859);
  if (_514) {
    // float _862 = max(_854, 0.0f);
    // float _863 = max(_857, 0.0f);
    // float _864 = max(_860, 0.0f);
    // bool _865 = !(_862 >= 0.0030399328097701073f);
    // if (!_865) {
    //   float _867 = abs(_862);
    //   float _868 = log2(_867);
    //   float _869 = _868 * 0.4166666567325592f;
    //   float _870 = exp2(_869);
    //   float _871 = _870 * 1.0549999475479126f;
    //   float _872 = _871 + -0.054999999701976776f;
    //   _876 = _872;
    // } else {
    //   float _874 = _862 * 12.923210144042969f;
    //   _876 = _874;
    // }
    // bool _877 = !(_863 >= 0.0030399328097701073f);
    // if (!_877) {
    //   float _879 = abs(_863);
    //   float _880 = log2(_879);
    //   float _881 = _880 * 0.4166666567325592f;
    //   float _882 = exp2(_881);
    //   float _883 = _882 * 1.0549999475479126f;
    //   float _884 = _883 + -0.054999999701976776f;
    //   _888 = _884;
    // } else {
    //   float _886 = _863 * 12.923210144042969f;
    //   _888 = _886;
    // }
    // bool _889 = !(_864 >= 0.0030399328097701073f);
    // if (!_889) {
    //   float _891 = abs(_864);
    //   float _892 = log2(_891);
    //   float _893 = _892 * 0.4166666567325592f;
    //   float _894 = exp2(_893);
    //   float _895 = _894 * 1.0549999475479126f;
    //   float _896 = _895 + -0.054999999701976776f;
    //   _969 = _876;
    //   _970 = _888;
    //   _971 = _896;
    // } else {
    //   float _898 = _864 * 12.923210144042969f;
    //   _969 = _876;
    //   _970 = _888;
    //   _971 = _898;
    // }
    _969 = renodx::color::srgb::EncodeSafe(_854);
    _970 = renodx::color::srgb::EncodeSafe(_857);
    _971 = renodx::color::srgb::EncodeSafe(_860);

  } else {
    float _900 = saturate(_854);
    float _901 = saturate(_857);
    float _902 = saturate(_860);
    bool _903 = ((uint)(cb1_018w) == -2);
    if (!_903) {
      bool _905 = !(_900 >= 0.0030399328097701073f);
      if (!_905) {
        float _907 = abs(_900);
        float _908 = log2(_907);
        float _909 = _908 * 0.4166666567325592f;
        float _910 = exp2(_909);
        float _911 = _910 * 1.0549999475479126f;
        float _912 = _911 + -0.054999999701976776f;
        _916 = _912;
      } else {
        float _914 = _900 * 12.923210144042969f;
        _916 = _914;
      }
      bool _917 = !(_901 >= 0.0030399328097701073f);
      if (!_917) {
        float _919 = abs(_901);
        float _920 = log2(_919);
        float _921 = _920 * 0.4166666567325592f;
        float _922 = exp2(_921);
        float _923 = _922 * 1.0549999475479126f;
        float _924 = _923 + -0.054999999701976776f;
        _928 = _924;
      } else {
        float _926 = _901 * 12.923210144042969f;
        _928 = _926;
      }
      bool _929 = !(_902 >= 0.0030399328097701073f);
      if (!_929) {
        float _931 = abs(_902);
        float _932 = log2(_931);
        float _933 = _932 * 0.4166666567325592f;
        float _934 = exp2(_933);
        float _935 = _934 * 1.0549999475479126f;
        float _936 = _935 + -0.054999999701976776f;
        _940 = _916;
        _941 = _928;
        _942 = _936;
      } else {
        float _938 = _902 * 12.923210144042969f;
        _940 = _916;
        _941 = _928;
        _942 = _938;
      }
    } else {
      _940 = _900;
      _941 = _901;
      _942 = _902;
    }
    float _947 = abs(_940);
    float _948 = abs(_941);
    float _949 = abs(_942);
    float _950 = log2(_947);
    float _951 = log2(_948);
    float _952 = log2(_949);
    float _953 = _950 * cb2_000z;
    float _954 = _951 * cb2_000z;
    float _955 = _952 * cb2_000z;
    float _956 = exp2(_953);
    float _957 = exp2(_954);
    float _958 = exp2(_955);
    float _959 = _956 * cb2_000y;
    float _960 = _957 * cb2_000y;
    float _961 = _958 * cb2_000y;
    float _962 = _959 + cb2_000x;
    float _963 = _960 + cb2_000x;
    float _964 = _961 + cb2_000x;
    float _965 = saturate(_962);
    float _966 = saturate(_963);
    float _967 = saturate(_964);
    _969 = _965;
    _970 = _966;
    _971 = _967;
  }
  float _975 = cb2_023x * TEXCOORD0_centroid.x;
  float _976 = cb2_023y * TEXCOORD0_centroid.y;
  float _979 = _975 + cb2_023z;
  float _980 = _976 + cb2_023w;
  float4 _983 = t11.SampleLevel(s0_space2, float2(_979, _980), 0.0f);
  float _985 = _983.x + -0.5f;
  float _986 = _985 * cb2_022x;
  float _987 = _986 + 0.5f;
  float _988 = _987 * 2.0f;
  float _989 = _988 * _969;
  float _990 = _988 * _970;
  float _991 = _988 * _971;
  float _995 = float((uint)(cb2_019z));
  float _996 = float((uint)(cb2_019w));
  float _997 = _995 + SV_Position.x;
  float _998 = _996 + SV_Position.y;
  uint _999 = uint(_997);
  uint _1000 = uint(_998);
  uint _1003 = cb2_019x + -1u;
  uint _1004 = cb2_019y + -1u;
  int _1005 = _999 & _1003;
  int _1006 = _1000 & _1004;
  float4 _1007 = t3.Load(int3(_1005, _1006, 0));
  float _1011 = _1007.x * 2.0f;
  float _1012 = _1007.y * 2.0f;
  float _1013 = _1007.z * 2.0f;
  float _1014 = _1011 + -1.0f;
  float _1015 = _1012 + -1.0f;
  float _1016 = _1013 + -1.0f;
  float _1017 = _1014 * _497;
  float _1018 = _1015 * _497;
  float _1019 = _1016 * _497;
  float _1020 = _1017 + _989;
  float _1021 = _1018 + _990;
  float _1022 = _1019 + _991;
  float _1023 = dot(float3(_1020, _1021, _1022), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _1020;
  SV_Target.y = _1021;
  SV_Target.z = _1022;
  SV_Target.w = _1023;
  SV_Target_1.x = _1023;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

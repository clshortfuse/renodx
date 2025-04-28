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
  float4 _63 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _67 = _45 - _33;
  float _68 = _46 - _34;
  float _69 = _47 - _35;
  float _70 = _62 * _67;
  float _71 = _62 * _68;
  float _72 = _62 * _69;
  float _73 = _70 + _33;
  float _74 = _71 + _34;
  float _75 = _72 + _35;
  float _76 = dot(float3(_73, _74, _75), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _80 = t0[0].SExposureData_020;
  float _82 = t0[0].SExposureData_004;
  float _84 = cb2_018x * 0.5f;
  float _85 = _84 * cb2_018y;
  float _86 = _82.x - _85;
  float _87 = cb2_018y * cb2_018x;
  float _88 = 1.0f / _87;
  float _89 = _86 * _88;
  float _90 = _76 / _80.x;
  float _91 = _90 * 5464.01611328125f;
  float _92 = _91 + 9.99999993922529e-09f;
  float _93 = log2(_92);
  float _94 = _93 - _86;
  float _95 = _94 * _88;
  float _96 = saturate(_95);
  float2 _97 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _96), 0.0f);
  float _100 = max(_97.y, 1.0000000116860974e-07f);
  float _101 = _97.x / _100;
  float _102 = _101 + _89;
  float _103 = _102 / _88;
  float _104 = _103 - _82.x;
  float _105 = -0.0f - _104;
  float _107 = _105 - cb2_027x;
  float _108 = max(0.0f, _107);
  float _111 = cb2_026z * _108;
  float _112 = _104 - cb2_027x;
  float _113 = max(0.0f, _112);
  float _115 = cb2_026w * _113;
  bool _116 = (_104 < 0.0f);
  float _117 = select(_116, _111, _115);
  float _118 = exp2(_117);
  float _119 = _118 * _73;
  float _120 = _118 * _74;
  float _121 = _118 * _75;
  float _126 = cb2_024y * _63.x;
  float _127 = cb2_024z * _63.y;
  float _128 = cb2_024w * _63.z;
  float _129 = _126 + _119;
  float _130 = _127 + _120;
  float _131 = _128 + _121;
  float _136 = _129 * cb2_025x;
  float _137 = _130 * cb2_025y;
  float _138 = _131 * cb2_025z;
  float _139 = dot(float3(_136, _137, _138), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _140 = t0[0].SExposureData_012;
  float _142 = _139 * 5464.01611328125f;
  float _143 = _142 * _140.x;
  float _144 = _143 + 9.99999993922529e-09f;
  float _145 = log2(_144);
  float _146 = _145 + 16.929765701293945f;
  float _147 = _146 * 0.05734497308731079f;
  float _148 = saturate(_147);
  float _149 = _148 * _148;
  float _150 = _148 * 2.0f;
  float _151 = 3.0f - _150;
  float _152 = _149 * _151;
  float _153 = _137 * 0.8450999855995178f;
  float _154 = _138 * 0.14589999616146088f;
  float _155 = _153 + _154;
  float _156 = _155 * 2.4890189170837402f;
  float _157 = _155 * 0.3754962384700775f;
  float _158 = _155 * 2.811495304107666f;
  float _159 = _155 * 5.519708156585693f;
  float _160 = _139 - _156;
  float _161 = _152 * _160;
  float _162 = _161 + _156;
  float _163 = _152 * 0.5f;
  float _164 = _163 + 0.5f;
  float _165 = _164 * _160;
  float _166 = _165 + _156;
  float _167 = _136 - _157;
  float _168 = _137 - _158;
  float _169 = _138 - _159;
  float _170 = _164 * _167;
  float _171 = _164 * _168;
  float _172 = _164 * _169;
  float _173 = _170 + _157;
  float _174 = _171 + _158;
  float _175 = _172 + _159;
  float _176 = 1.0f / _166;
  float _177 = _162 * _176;
  float _178 = _177 * _173;
  float _179 = _177 * _174;
  float _180 = _177 * _175;
  float _184 = cb2_020x * TEXCOORD0_centroid.x;
  float _185 = cb2_020y * TEXCOORD0_centroid.y;
  float _188 = _184 + cb2_020z;
  float _189 = _185 + cb2_020w;
  float _192 = dot(float2(_188, _189), float2(_188, _189));
  float _193 = 1.0f - _192;
  float _194 = saturate(_193);
  float _195 = log2(_194);
  float _196 = _195 * cb2_021w;
  float _197 = exp2(_196);
  float _201 = _178 - cb2_021x;
  float _202 = _179 - cb2_021y;
  float _203 = _180 - cb2_021z;
  float _204 = _201 * _197;
  float _205 = _202 * _197;
  float _206 = _203 * _197;
  float _207 = _204 + cb2_021x;
  float _208 = _205 + cb2_021y;
  float _209 = _206 + cb2_021z;
  float _210 = t0[0].SExposureData_000;
  float _212 = max(_80.x, 0.0010000000474974513f);
  float _213 = 1.0f / _212;
  float _214 = _213 * _210.x;
  bool _217 = ((uint)(cb2_069y) == 0);
  float _223;
  float _224;
  float _225;
  float _279;
  float _280;
  float _281;
  float _372;
  float _373;
  float _374;
  float _419;
  float _420;
  float _421;
  float _422;
  float _471;
  float _472;
  float _473;
  float _474;
  float _499;
  float _500;
  float _501;
  float _651;
  float _688;
  float _689;
  float _690;
  float _719;
  float _720;
  float _721;
  float _802;
  float _803;
  float _804;
  float _810;
  float _811;
  float _812;
  float _826;
  float _827;
  float _828;
  float _853;
  float _865;
  float _893;
  float _905;
  float _917;
  float _918;
  float _919;
  float _946;
  float _947;
  float _948;
  if (!_217) {
    float _219 = _214 * _207;
    float _220 = _214 * _208;
    float _221 = _214 * _209;
    _223 = _219;
    _224 = _220;
    _225 = _221;
  } else {
    _223 = _207;
    _224 = _208;
    _225 = _209;
  }
  float _226 = _223 * 0.6130970120429993f;
  float _227 = mad(0.33952298760414124f, _224, _226);
  float _228 = mad(0.04737899824976921f, _225, _227);
  float _229 = _223 * 0.07019399851560593f;
  float _230 = mad(0.9163540005683899f, _224, _229);
  float _231 = mad(0.013451999984681606f, _225, _230);
  float _232 = _223 * 0.02061600051820278f;
  float _233 = mad(0.10956999659538269f, _224, _232);
  float _234 = mad(0.8698149919509888f, _225, _233);
  float _235 = log2(_228);
  float _236 = log2(_231);
  float _237 = log2(_234);
  float _238 = _235 * 0.04211956635117531f;
  float _239 = _236 * 0.04211956635117531f;
  float _240 = _237 * 0.04211956635117531f;
  float _241 = _238 + 0.6252607107162476f;
  float _242 = _239 + 0.6252607107162476f;
  float _243 = _240 + 0.6252607107162476f;
  float4 _244 = t6.SampleLevel(s2_space2, float3(_241, _242, _243), 0.0f);
  bool _250 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_250 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _254 = cb2_017x * _244.x;
    float _255 = cb2_017x * _244.y;
    float _256 = cb2_017x * _244.z;
    float _258 = _254 + cb2_017y;
    float _259 = _255 + cb2_017y;
    float _260 = _256 + cb2_017y;
    float _261 = exp2(_258);
    float _262 = exp2(_259);
    float _263 = exp2(_260);
    float _264 = _261 + 1.0f;
    float _265 = _262 + 1.0f;
    float _266 = _263 + 1.0f;
    float _267 = 1.0f / _264;
    float _268 = 1.0f / _265;
    float _269 = 1.0f / _266;
    float _271 = cb2_017z * _267;
    float _272 = cb2_017z * _268;
    float _273 = cb2_017z * _269;
    float _275 = _271 + cb2_017w;
    float _276 = _272 + cb2_017w;
    float _277 = _273 + cb2_017w;
    _279 = _275;
    _280 = _276;
    _281 = _277;
  } else {
    _279 = _244.x;
    _280 = _244.y;
    _281 = _244.z;
  }
  float _282 = _279 * 23.0f;
  float _283 = _282 + -14.473931312561035f;
  float _284 = exp2(_283);
  float _285 = _280 * 23.0f;
  float _286 = _285 + -14.473931312561035f;
  float _287 = exp2(_286);
  float _288 = _281 * 23.0f;
  float _289 = _288 + -14.473931312561035f;
  float _290 = exp2(_289);
  float _291 = dot(float3(_284, _287, _290), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _296 = dot(float3(_284, _287, _290), float3(_284, _287, _290));
  float _297 = rsqrt(_296);
  float _298 = _297 * _284;
  float _299 = _297 * _287;
  float _300 = _297 * _290;
  float _301 = cb2_001x - _298;
  float _302 = cb2_001y - _299;
  float _303 = cb2_001z - _300;
  float _304 = dot(float3(_301, _302, _303), float3(_301, _302, _303));
  float _307 = cb2_002z * _304;
  float _309 = _307 + cb2_002w;
  float _310 = saturate(_309);
  float _312 = cb2_002x * _310;
  float _313 = _291 - _284;
  float _314 = _291 - _287;
  float _315 = _291 - _290;
  float _316 = _312 * _313;
  float _317 = _312 * _314;
  float _318 = _312 * _315;
  float _319 = _316 + _284;
  float _320 = _317 + _287;
  float _321 = _318 + _290;
  float _323 = cb2_002y * _310;
  float _324 = 0.10000000149011612f - _319;
  float _325 = 0.10000000149011612f - _320;
  float _326 = 0.10000000149011612f - _321;
  float _327 = _324 * _323;
  float _328 = _325 * _323;
  float _329 = _326 * _323;
  float _330 = _327 + _319;
  float _331 = _328 + _320;
  float _332 = _329 + _321;
  float _333 = saturate(_330);
  float _334 = saturate(_331);
  float _335 = saturate(_332);
  float _340 = cb2_004x * TEXCOORD0_centroid.x;
  float _341 = cb2_004y * TEXCOORD0_centroid.y;
  float _344 = _340 + cb2_004z;
  float _345 = _341 + cb2_004w;
  float4 _351 = t7.Sample(s2_space2, float2(_344, _345));
  float _356 = _351.x * cb2_003x;
  float _357 = _351.y * cb2_003y;
  float _358 = _351.z * cb2_003z;
  float _359 = _351.w * cb2_003w;
  float _362 = _359 + cb2_026y;
  float _363 = saturate(_362);
  bool _366 = ((uint)(cb2_069y) == 0);
  if (!_366) {
    float _368 = _356 * _214;
    float _369 = _357 * _214;
    float _370 = _358 * _214;
    _372 = _368;
    _373 = _369;
    _374 = _370;
  } else {
    _372 = _356;
    _373 = _357;
    _374 = _358;
  }
  bool _377 = ((uint)(cb2_028x) == 2);
  bool _378 = ((uint)(cb2_028x) == 3);
  int _379 = (uint)(cb2_028x) & -2;
  bool _380 = (_379 == 2);
  bool _381 = ((uint)(cb2_028x) == 6);
  bool _382 = _380 || _381;
  if (_382) {
    float _384 = _372 * _363;
    float _385 = _373 * _363;
    float _386 = _374 * _363;
    float _387 = _363 * _363;
    _419 = _384;
    _420 = _385;
    _421 = _386;
    _422 = _387;
  } else {
    bool _389 = ((uint)(cb2_028x) == 4);
    if (_389) {
      float _391 = _372 + -1.0f;
      float _392 = _373 + -1.0f;
      float _393 = _374 + -1.0f;
      float _394 = _363 + -1.0f;
      float _395 = _391 * _363;
      float _396 = _392 * _363;
      float _397 = _393 * _363;
      float _398 = _394 * _363;
      float _399 = _395 + 1.0f;
      float _400 = _396 + 1.0f;
      float _401 = _397 + 1.0f;
      float _402 = _398 + 1.0f;
      _419 = _399;
      _420 = _400;
      _421 = _401;
      _422 = _402;
    } else {
      bool _404 = ((uint)(cb2_028x) == 5);
      if (_404) {
        float _406 = _372 + -0.5f;
        float _407 = _373 + -0.5f;
        float _408 = _374 + -0.5f;
        float _409 = _363 + -0.5f;
        float _410 = _406 * _363;
        float _411 = _407 * _363;
        float _412 = _408 * _363;
        float _413 = _409 * _363;
        float _414 = _410 + 0.5f;
        float _415 = _411 + 0.5f;
        float _416 = _412 + 0.5f;
        float _417 = _413 + 0.5f;
        _419 = _414;
        _420 = _415;
        _421 = _416;
        _422 = _417;
      } else {
        _419 = _372;
        _420 = _373;
        _421 = _374;
        _422 = _363;
      }
    }
  }
  if (_377) {
    float _424 = _419 + _333;
    float _425 = _420 + _334;
    float _426 = _421 + _335;
    _471 = _424;
    _472 = _425;
    _473 = _426;
    _474 = cb2_025w;
  } else {
    if (_378) {
      float _429 = 1.0f - _419;
      float _430 = 1.0f - _420;
      float _431 = 1.0f - _421;
      float _432 = _429 * _333;
      float _433 = _430 * _334;
      float _434 = _431 * _335;
      float _435 = _432 + _419;
      float _436 = _433 + _420;
      float _437 = _434 + _421;
      _471 = _435;
      _472 = _436;
      _473 = _437;
      _474 = cb2_025w;
    } else {
      bool _439 = ((uint)(cb2_028x) == 4);
      if (_439) {
        float _441 = _419 * _333;
        float _442 = _420 * _334;
        float _443 = _421 * _335;
        _471 = _441;
        _472 = _442;
        _473 = _443;
        _474 = cb2_025w;
      } else {
        bool _445 = ((uint)(cb2_028x) == 5);
        if (_445) {
          float _447 = _333 * 2.0f;
          float _448 = _447 * _419;
          float _449 = _334 * 2.0f;
          float _450 = _449 * _420;
          float _451 = _335 * 2.0f;
          float _452 = _451 * _421;
          _471 = _448;
          _472 = _450;
          _473 = _452;
          _474 = cb2_025w;
        } else {
          if (_381) {
            float _455 = _333 - _419;
            float _456 = _334 - _420;
            float _457 = _335 - _421;
            _471 = _455;
            _472 = _456;
            _473 = _457;
            _474 = cb2_025w;
          } else {
            float _459 = _419 - _333;
            float _460 = _420 - _334;
            float _461 = _421 - _335;
            float _462 = _422 * _459;
            float _463 = _422 * _460;
            float _464 = _422 * _461;
            float _465 = _462 + _333;
            float _466 = _463 + _334;
            float _467 = _464 + _335;
            float _468 = 1.0f - _422;
            float _469 = _468 * cb2_025w;
            _471 = _465;
            _472 = _466;
            _473 = _467;
            _474 = _469;
          }
        }
      }
    }
  }
  float _480 = cb2_016x - _471;
  float _481 = cb2_016y - _472;
  float _482 = cb2_016z - _473;
  float _483 = _480 * cb2_016w;
  float _484 = _481 * cb2_016w;
  float _485 = _482 * cb2_016w;
  float _486 = _483 + _471;
  float _487 = _484 + _472;
  float _488 = _485 + _473;
  bool _491 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_491 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _495 = cb2_024x * _486;
    float _496 = cb2_024x * _487;
    float _497 = cb2_024x * _488;
    _499 = _495;
    _500 = _496;
    _501 = _497;
  } else {
    _499 = _486;
    _500 = _487;
    _501 = _488;
  }
  float _504 = _499 * 0.9708889722824097f;
  float _505 = mad(0.026962999254465103f, _500, _504);
  float _506 = mad(0.002148000057786703f, _501, _505);
  float _507 = _499 * 0.01088900025933981f;
  float _508 = mad(0.9869629740715027f, _500, _507);
  float _509 = mad(0.002148000057786703f, _501, _508);
  float _510 = mad(0.026962999254465103f, _500, _507);
  float _511 = mad(0.9621480107307434f, _501, _510);
  float _512 = max(_506, 0.0f);
  float _513 = max(_509, 0.0f);
  float _514 = max(_511, 0.0f);
  float _515 = min(_512, cb2_095y);
  float _516 = min(_513, cb2_095y);
  float _517 = min(_514, cb2_095y);
  bool _520 = ((uint)(cb2_095x) == 0);
  bool _523 = ((uint)(cb2_094w) == 0);
  bool _525 = ((uint)(cb2_094z) == 0);
  bool _527 = ((uint)(cb2_094y) != 0);
  bool _529 = ((uint)(cb2_094x) == 0);
  bool _531 = ((uint)(cb2_069z) != 0);
  float _578 = asfloat((uint)(cb2_075y));
  float _579 = asfloat((uint)(cb2_075z));
  float _580 = asfloat((uint)(cb2_075w));
  float _581 = asfloat((uint)(cb2_074z));
  float _582 = asfloat((uint)(cb2_074w));
  float _583 = asfloat((uint)(cb2_075x));
  float _584 = asfloat((uint)(cb2_073w));
  float _585 = asfloat((uint)(cb2_074x));
  float _586 = asfloat((uint)(cb2_074y));
  float _587 = asfloat((uint)(cb2_077x));
  float _588 = asfloat((uint)(cb2_077y));
  float _589 = asfloat((uint)(cb2_079x));
  float _590 = asfloat((uint)(cb2_079y));
  float _591 = asfloat((uint)(cb2_079z));
  float _592 = asfloat((uint)(cb2_078y));
  float _593 = asfloat((uint)(cb2_078z));
  float _594 = asfloat((uint)(cb2_078w));
  float _595 = asfloat((uint)(cb2_077z));
  float _596 = asfloat((uint)(cb2_077w));
  float _597 = asfloat((uint)(cb2_078x));
  float _598 = asfloat((uint)(cb2_072y));
  float _599 = asfloat((uint)(cb2_072z));
  float _600 = asfloat((uint)(cb2_072w));
  float _601 = asfloat((uint)(cb2_071x));
  float _602 = asfloat((uint)(cb2_071y));
  float _603 = asfloat((uint)(cb2_076x));
  float _604 = asfloat((uint)(cb2_070w));
  float _605 = asfloat((uint)(cb2_070x));
  float _606 = asfloat((uint)(cb2_070y));
  float _607 = asfloat((uint)(cb2_070z));
  float _608 = asfloat((uint)(cb2_073x));
  float _609 = asfloat((uint)(cb2_073y));
  float _610 = asfloat((uint)(cb2_073z));
  float _611 = asfloat((uint)(cb2_071z));
  float _612 = asfloat((uint)(cb2_071w));
  float _613 = asfloat((uint)(cb2_072x));
  float _614 = max(_516, _517);
  float _615 = max(_515, _614);
  float _616 = 1.0f / _615;
  float _617 = _616 * _515;
  float _618 = _616 * _516;
  float _619 = _616 * _517;
  float _620 = abs(_617);
  float _621 = log2(_620);
  float _622 = _621 * _605;
  float _623 = exp2(_622);
  float _624 = abs(_618);
  float _625 = log2(_624);
  float _626 = _625 * _606;
  float _627 = exp2(_626);
  float _628 = abs(_619);
  float _629 = log2(_628);
  float _630 = _629 * _607;
  float _631 = exp2(_630);
  if (_527) {
    float _634 = asfloat((uint)(cb2_076w));
    float _636 = asfloat((uint)(cb2_076z));
    float _638 = asfloat((uint)(cb2_076y));
    float _639 = _636 * _516;
    float _640 = _638 * _515;
    float _641 = _634 * _517;
    float _642 = _640 + _641;
    float _643 = _642 + _639;
    _651 = _643;
  } else {
    float _645 = _612 * _516;
    float _646 = _611 * _515;
    float _647 = _613 * _517;
    float _648 = _645 + _646;
    float _649 = _648 + _647;
    _651 = _649;
  }
  float _652 = abs(_651);
  float _653 = log2(_652);
  float _654 = _653 * _604;
  float _655 = exp2(_654);
  float _656 = log2(_655);
  float _657 = _656 * _603;
  float _658 = exp2(_657);
  float _659 = select(_531, _658, _655);
  float _660 = _659 * _601;
  float _661 = _660 + _602;
  float _662 = 1.0f / _661;
  float _663 = _662 * _655;
  if (_527) {
    if (!_529) {
      float _666 = _623 * _595;
      float _667 = _627 * _596;
      float _668 = _631 * _597;
      float _669 = _667 + _666;
      float _670 = _669 + _668;
      float _671 = _627 * _593;
      float _672 = _623 * _592;
      float _673 = _631 * _594;
      float _674 = _671 + _672;
      float _675 = _674 + _673;
      float _676 = _631 * _591;
      float _677 = _627 * _590;
      float _678 = _623 * _589;
      float _679 = _677 + _678;
      float _680 = _679 + _676;
      float _681 = max(_675, _680);
      float _682 = max(_670, _681);
      float _683 = 1.0f / _682;
      float _684 = _683 * _670;
      float _685 = _683 * _675;
      float _686 = _683 * _680;
      _688 = _684;
      _689 = _685;
      _690 = _686;
    } else {
      _688 = _623;
      _689 = _627;
      _690 = _631;
    }
    float _691 = _688 * _588;
    float _692 = exp2(_691);
    float _693 = _692 * _587;
    float _694 = saturate(_693);
    float _695 = _688 * _587;
    float _696 = _688 - _695;
    float _697 = saturate(_696);
    float _698 = max(_587, _697);
    float _699 = min(_698, _694);
    float _700 = _689 * _588;
    float _701 = exp2(_700);
    float _702 = _701 * _587;
    float _703 = saturate(_702);
    float _704 = _689 * _587;
    float _705 = _689 - _704;
    float _706 = saturate(_705);
    float _707 = max(_587, _706);
    float _708 = min(_707, _703);
    float _709 = _690 * _588;
    float _710 = exp2(_709);
    float _711 = _710 * _587;
    float _712 = saturate(_711);
    float _713 = _690 * _587;
    float _714 = _690 - _713;
    float _715 = saturate(_714);
    float _716 = max(_587, _715);
    float _717 = min(_716, _712);
    _719 = _699;
    _720 = _708;
    _721 = _717;
  } else {
    _719 = _623;
    _720 = _627;
    _721 = _631;
  }
  float _722 = _719 * _611;
  float _723 = _720 * _612;
  float _724 = _723 + _722;
  float _725 = _721 * _613;
  float _726 = _724 + _725;
  float _727 = 1.0f / _726;
  float _728 = _727 * _663;
  float _729 = saturate(_728);
  float _730 = _729 * _719;
  float _731 = saturate(_730);
  float _732 = _729 * _720;
  float _733 = saturate(_732);
  float _734 = _729 * _721;
  float _735 = saturate(_734);
  float _736 = _731 * _598;
  float _737 = _598 - _736;
  float _738 = _733 * _599;
  float _739 = _599 - _738;
  float _740 = _735 * _600;
  float _741 = _600 - _740;
  float _742 = _735 * _613;
  float _743 = _731 * _611;
  float _744 = _733 * _612;
  float _745 = _663 - _743;
  float _746 = _745 - _744;
  float _747 = _746 - _742;
  float _748 = saturate(_747);
  float _749 = _739 * _612;
  float _750 = _737 * _611;
  float _751 = _741 * _613;
  float _752 = _749 + _750;
  float _753 = _752 + _751;
  float _754 = 1.0f / _753;
  float _755 = _754 * _748;
  float _756 = _755 * _737;
  float _757 = _756 + _731;
  float _758 = saturate(_757);
  float _759 = _755 * _739;
  float _760 = _759 + _733;
  float _761 = saturate(_760);
  float _762 = _755 * _741;
  float _763 = _762 + _735;
  float _764 = saturate(_763);
  float _765 = _764 * _613;
  float _766 = _758 * _611;
  float _767 = _761 * _612;
  float _768 = _663 - _766;
  float _769 = _768 - _767;
  float _770 = _769 - _765;
  float _771 = saturate(_770);
  float _772 = _771 * _608;
  float _773 = _772 + _758;
  float _774 = saturate(_773);
  float _775 = _771 * _609;
  float _776 = _775 + _761;
  float _777 = saturate(_776);
  float _778 = _771 * _610;
  float _779 = _778 + _764;
  float _780 = saturate(_779);
  if (!_525) {
    float _782 = _774 * _584;
    float _783 = _777 * _585;
    float _784 = _780 * _586;
    float _785 = _783 + _782;
    float _786 = _785 + _784;
    float _787 = _777 * _582;
    float _788 = _774 * _581;
    float _789 = _780 * _583;
    float _790 = _787 + _788;
    float _791 = _790 + _789;
    float _792 = _780 * _580;
    float _793 = _777 * _579;
    float _794 = _774 * _578;
    float _795 = _793 + _794;
    float _796 = _795 + _792;
    if (!_523) {
      float _798 = saturate(_786);
      float _799 = saturate(_791);
      float _800 = saturate(_796);
      _802 = _800;
      _803 = _799;
      _804 = _798;
    } else {
      _802 = _796;
      _803 = _791;
      _804 = _786;
    }
  } else {
    _802 = _780;
    _803 = _777;
    _804 = _774;
  }
  if (!_520) {
    float _806 = _804 * _584;
    float _807 = _803 * _584;
    float _808 = _802 * _584;
    _810 = _808;
    _811 = _807;
    _812 = _806;
  } else {
    _810 = _802;
    _811 = _803;
    _812 = _804;
  }
  if (_491) {
    float _816 = cb1_018z * 9.999999747378752e-05f;
    float _817 = _816 * _812;
    float _818 = _816 * _811;
    float _819 = _816 * _810;
    float _821 = 5000.0f / cb1_018y;
    float _822 = _817 * _821;
    float _823 = _818 * _821;
    float _824 = _819 * _821;
    _826 = _822;
    _827 = _823;
    _828 = _824;
  } else {
    _826 = _812;
    _827 = _811;
    _828 = _810;
  }
  float _829 = _826 * 1.6047500371932983f;
  float _830 = mad(-0.5310800075531006f, _827, _829);
  float _831 = mad(-0.07366999983787537f, _828, _830);
  float _832 = _826 * -0.10208000242710114f;
  float _833 = mad(1.1081299781799316f, _827, _832);
  float _834 = mad(-0.006049999967217445f, _828, _833);
  float _835 = _826 * -0.0032599999103695154f;
  float _836 = mad(-0.07275000214576721f, _827, _835);
  float _837 = mad(1.0760200023651123f, _828, _836);
  if (_491) {
    // float _839 = max(_831, 0.0f);
    // float _840 = max(_834, 0.0f);
    // float _841 = max(_837, 0.0f);
    // bool _842 = !(_839 >= 0.0030399328097701073f);
    // if (!_842) {
    //   float _844 = abs(_839);
    //   float _845 = log2(_844);
    //   float _846 = _845 * 0.4166666567325592f;
    //   float _847 = exp2(_846);
    //   float _848 = _847 * 1.0549999475479126f;
    //   float _849 = _848 + -0.054999999701976776f;
    //   _853 = _849;
    // } else {
    //   float _851 = _839 * 12.923210144042969f;
    //   _853 = _851;
    // }
    // bool _854 = !(_840 >= 0.0030399328097701073f);
    // if (!_854) {
    //   float _856 = abs(_840);
    //   float _857 = log2(_856);
    //   float _858 = _857 * 0.4166666567325592f;
    //   float _859 = exp2(_858);
    //   float _860 = _859 * 1.0549999475479126f;
    //   float _861 = _860 + -0.054999999701976776f;
    //   _865 = _861;
    // } else {
    //   float _863 = _840 * 12.923210144042969f;
    //   _865 = _863;
    // }
    // bool _866 = !(_841 >= 0.0030399328097701073f);
    // if (!_866) {
    //   float _868 = abs(_841);
    //   float _869 = log2(_868);
    //   float _870 = _869 * 0.4166666567325592f;
    //   float _871 = exp2(_870);
    //   float _872 = _871 * 1.0549999475479126f;
    //   float _873 = _872 + -0.054999999701976776f;
    //   _946 = _853;
    //   _947 = _865;
    //   _948 = _873;
    // } else {
    //   float _875 = _841 * 12.923210144042969f;
    //   _946 = _853;
    //   _947 = _865;
    //   _948 = _875;
    // }
    _946 = renodx::color::srgb::EncodeSafe(_831);
    _947 = renodx::color::srgb::EncodeSafe(_834);
    _948 = renodx::color::srgb::EncodeSafe(_837);

  } else {
    float _877 = saturate(_831);
    float _878 = saturate(_834);
    float _879 = saturate(_837);
    bool _880 = ((uint)(cb1_018w) == -2);
    if (!_880) {
      bool _882 = !(_877 >= 0.0030399328097701073f);
      if (!_882) {
        float _884 = abs(_877);
        float _885 = log2(_884);
        float _886 = _885 * 0.4166666567325592f;
        float _887 = exp2(_886);
        float _888 = _887 * 1.0549999475479126f;
        float _889 = _888 + -0.054999999701976776f;
        _893 = _889;
      } else {
        float _891 = _877 * 12.923210144042969f;
        _893 = _891;
      }
      bool _894 = !(_878 >= 0.0030399328097701073f);
      if (!_894) {
        float _896 = abs(_878);
        float _897 = log2(_896);
        float _898 = _897 * 0.4166666567325592f;
        float _899 = exp2(_898);
        float _900 = _899 * 1.0549999475479126f;
        float _901 = _900 + -0.054999999701976776f;
        _905 = _901;
      } else {
        float _903 = _878 * 12.923210144042969f;
        _905 = _903;
      }
      bool _906 = !(_879 >= 0.0030399328097701073f);
      if (!_906) {
        float _908 = abs(_879);
        float _909 = log2(_908);
        float _910 = _909 * 0.4166666567325592f;
        float _911 = exp2(_910);
        float _912 = _911 * 1.0549999475479126f;
        float _913 = _912 + -0.054999999701976776f;
        _917 = _893;
        _918 = _905;
        _919 = _913;
      } else {
        float _915 = _879 * 12.923210144042969f;
        _917 = _893;
        _918 = _905;
        _919 = _915;
      }
    } else {
      _917 = _877;
      _918 = _878;
      _919 = _879;
    }
    float _924 = abs(_917);
    float _925 = abs(_918);
    float _926 = abs(_919);
    float _927 = log2(_924);
    float _928 = log2(_925);
    float _929 = log2(_926);
    float _930 = _927 * cb2_000z;
    float _931 = _928 * cb2_000z;
    float _932 = _929 * cb2_000z;
    float _933 = exp2(_930);
    float _934 = exp2(_931);
    float _935 = exp2(_932);
    float _936 = _933 * cb2_000y;
    float _937 = _934 * cb2_000y;
    float _938 = _935 * cb2_000y;
    float _939 = _936 + cb2_000x;
    float _940 = _937 + cb2_000x;
    float _941 = _938 + cb2_000x;
    float _942 = saturate(_939);
    float _943 = saturate(_940);
    float _944 = saturate(_941);
    _946 = _942;
    _947 = _943;
    _948 = _944;
  }
  float _952 = cb2_023x * TEXCOORD0_centroid.x;
  float _953 = cb2_023y * TEXCOORD0_centroid.y;
  float _956 = _952 + cb2_023z;
  float _957 = _953 + cb2_023w;
  float4 _960 = t9.SampleLevel(s0_space2, float2(_956, _957), 0.0f);
  float _962 = _960.x + -0.5f;
  float _963 = _962 * cb2_022x;
  float _964 = _963 + 0.5f;
  float _965 = _964 * 2.0f;
  float _966 = _965 * _946;
  float _967 = _965 * _947;
  float _968 = _965 * _948;
  float _972 = float((uint)(cb2_019z));
  float _973 = float((uint)(cb2_019w));
  float _974 = _972 + SV_Position.x;
  float _975 = _973 + SV_Position.y;
  uint _976 = uint(_974);
  uint _977 = uint(_975);
  uint _980 = cb2_019x + -1u;
  uint _981 = cb2_019y + -1u;
  int _982 = _976 & _980;
  int _983 = _977 & _981;
  float4 _984 = t3.Load(int3(_982, _983, 0));
  float _988 = _984.x * 2.0f;
  float _989 = _984.y * 2.0f;
  float _990 = _984.z * 2.0f;
  float _991 = _988 + -1.0f;
  float _992 = _989 + -1.0f;
  float _993 = _990 + -1.0f;
  float _994 = _991 * _474;
  float _995 = _992 * _474;
  float _996 = _993 * _474;
  float _997 = _994 + _966;
  float _998 = _995 + _967;
  float _999 = _996 + _968;
  float _1000 = dot(float3(_997, _998, _999), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _997;
  SV_Target.y = _998;
  SV_Target.z = _999;
  SV_Target.w = _1000;
  SV_Target_1.x = _1000;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

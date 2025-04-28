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
  float4 _89 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _93 = _71 - _59;
  float _94 = _72 - _60;
  float _95 = _73 - _61;
  float _96 = _88 * _93;
  float _97 = _88 * _94;
  float _98 = _88 * _95;
  float _99 = _96 + _59;
  float _100 = _97 + _60;
  float _101 = _98 + _61;
  float _102 = dot(float3(_99, _100, _101), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _106 = t0[0].SExposureData_020;
  float _108 = t0[0].SExposureData_004;
  float _110 = cb2_018x * 0.5f;
  float _111 = _110 * cb2_018y;
  float _112 = _108.x - _111;
  float _113 = cb2_018y * cb2_018x;
  float _114 = 1.0f / _113;
  float _115 = _112 * _114;
  float _116 = _102 / _106.x;
  float _117 = _116 * 5464.01611328125f;
  float _118 = _117 + 9.99999993922529e-09f;
  float _119 = log2(_118);
  float _120 = _119 - _112;
  float _121 = _120 * _114;
  float _122 = saturate(_121);
  float2 _123 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _122), 0.0f);
  float _126 = max(_123.y, 1.0000000116860974e-07f);
  float _127 = _123.x / _126;
  float _128 = _127 + _115;
  float _129 = _128 / _114;
  float _130 = _129 - _108.x;
  float _131 = -0.0f - _130;
  float _133 = _131 - cb2_027x;
  float _134 = max(0.0f, _133);
  float _136 = cb2_026z * _134;
  float _137 = _130 - cb2_027x;
  float _138 = max(0.0f, _137);
  float _140 = cb2_026w * _138;
  bool _141 = (_130 < 0.0f);
  float _142 = select(_141, _136, _140);
  float _143 = exp2(_142);
  float _144 = _143 * _99;
  float _145 = _143 * _100;
  float _146 = _143 * _101;
  float _151 = cb2_024y * _89.x;
  float _152 = cb2_024z * _89.y;
  float _153 = cb2_024w * _89.z;
  float _154 = _151 + _144;
  float _155 = _152 + _145;
  float _156 = _153 + _146;
  float _161 = _154 * cb2_025x;
  float _162 = _155 * cb2_025y;
  float _163 = _156 * cb2_025z;
  float _164 = dot(float3(_161, _162, _163), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _165 = t0[0].SExposureData_012;
  float _167 = _164 * 5464.01611328125f;
  float _168 = _167 * _165.x;
  float _169 = _168 + 9.99999993922529e-09f;
  float _170 = log2(_169);
  float _171 = _170 + 16.929765701293945f;
  float _172 = _171 * 0.05734497308731079f;
  float _173 = saturate(_172);
  float _174 = _173 * _173;
  float _175 = _173 * 2.0f;
  float _176 = 3.0f - _175;
  float _177 = _174 * _176;
  float _178 = _162 * 0.8450999855995178f;
  float _179 = _163 * 0.14589999616146088f;
  float _180 = _178 + _179;
  float _181 = _180 * 2.4890189170837402f;
  float _182 = _180 * 0.3754962384700775f;
  float _183 = _180 * 2.811495304107666f;
  float _184 = _180 * 5.519708156585693f;
  float _185 = _164 - _181;
  float _186 = _177 * _185;
  float _187 = _186 + _181;
  float _188 = _177 * 0.5f;
  float _189 = _188 + 0.5f;
  float _190 = _189 * _185;
  float _191 = _190 + _181;
  float _192 = _161 - _182;
  float _193 = _162 - _183;
  float _194 = _163 - _184;
  float _195 = _189 * _192;
  float _196 = _189 * _193;
  float _197 = _189 * _194;
  float _198 = _195 + _182;
  float _199 = _196 + _183;
  float _200 = _197 + _184;
  float _201 = 1.0f / _191;
  float _202 = _187 * _201;
  float _203 = _202 * _198;
  float _204 = _202 * _199;
  float _205 = _202 * _200;
  float _209 = cb2_020x * TEXCOORD0_centroid.x;
  float _210 = cb2_020y * TEXCOORD0_centroid.y;
  float _213 = _209 + cb2_020z;
  float _214 = _210 + cb2_020w;
  float _217 = dot(float2(_213, _214), float2(_213, _214));
  float _218 = 1.0f - _217;
  float _219 = saturate(_218);
  float _220 = log2(_219);
  float _221 = _220 * cb2_021w;
  float _222 = exp2(_221);
  float _226 = _203 - cb2_021x;
  float _227 = _204 - cb2_021y;
  float _228 = _205 - cb2_021z;
  float _229 = _226 * _222;
  float _230 = _227 * _222;
  float _231 = _228 * _222;
  float _232 = _229 + cb2_021x;
  float _233 = _230 + cb2_021y;
  float _234 = _231 + cb2_021z;
  float _235 = t0[0].SExposureData_000;
  float _237 = max(_106.x, 0.0010000000474974513f);
  float _238 = 1.0f / _237;
  float _239 = _238 * _235.x;
  bool _242 = ((uint)(cb2_069y) == 0);
  float _248;
  float _249;
  float _250;
  float _304;
  float _305;
  float _306;
  float _396;
  float _397;
  float _398;
  float _443;
  float _444;
  float _445;
  float _446;
  float _493;
  float _494;
  float _495;
  float _520;
  float _521;
  float _522;
  float _672;
  float _709;
  float _710;
  float _711;
  float _740;
  float _741;
  float _742;
  float _823;
  float _824;
  float _825;
  float _831;
  float _832;
  float _833;
  float _847;
  float _848;
  float _849;
  float _874;
  float _886;
  float _914;
  float _926;
  float _938;
  float _939;
  float _940;
  float _967;
  float _968;
  float _969;
  if (!_242) {
    float _244 = _239 * _232;
    float _245 = _239 * _233;
    float _246 = _239 * _234;
    _248 = _244;
    _249 = _245;
    _250 = _246;
  } else {
    _248 = _232;
    _249 = _233;
    _250 = _234;
  }
  float _251 = _248 * 0.6130970120429993f;
  float _252 = mad(0.33952298760414124f, _249, _251);
  float _253 = mad(0.04737899824976921f, _250, _252);
  float _254 = _248 * 0.07019399851560593f;
  float _255 = mad(0.9163540005683899f, _249, _254);
  float _256 = mad(0.013451999984681606f, _250, _255);
  float _257 = _248 * 0.02061600051820278f;
  float _258 = mad(0.10956999659538269f, _249, _257);
  float _259 = mad(0.8698149919509888f, _250, _258);
  float _260 = log2(_253);
  float _261 = log2(_256);
  float _262 = log2(_259);
  float _263 = _260 * 0.04211956635117531f;
  float _264 = _261 * 0.04211956635117531f;
  float _265 = _262 * 0.04211956635117531f;
  float _266 = _263 + 0.6252607107162476f;
  float _267 = _264 + 0.6252607107162476f;
  float _268 = _265 + 0.6252607107162476f;
  float4 _269 = t5.SampleLevel(s2_space2, float3(_266, _267, _268), 0.0f);
  bool _275 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_275 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _279 = cb2_017x * _269.x;
    float _280 = cb2_017x * _269.y;
    float _281 = cb2_017x * _269.z;
    float _283 = _279 + cb2_017y;
    float _284 = _280 + cb2_017y;
    float _285 = _281 + cb2_017y;
    float _286 = exp2(_283);
    float _287 = exp2(_284);
    float _288 = exp2(_285);
    float _289 = _286 + 1.0f;
    float _290 = _287 + 1.0f;
    float _291 = _288 + 1.0f;
    float _292 = 1.0f / _289;
    float _293 = 1.0f / _290;
    float _294 = 1.0f / _291;
    float _296 = cb2_017z * _292;
    float _297 = cb2_017z * _293;
    float _298 = cb2_017z * _294;
    float _300 = _296 + cb2_017w;
    float _301 = _297 + cb2_017w;
    float _302 = _298 + cb2_017w;
    _304 = _300;
    _305 = _301;
    _306 = _302;
  } else {
    _304 = _269.x;
    _305 = _269.y;
    _306 = _269.z;
  }
  float _307 = _304 * 23.0f;
  float _308 = _307 + -14.473931312561035f;
  float _309 = exp2(_308);
  float _310 = _305 * 23.0f;
  float _311 = _310 + -14.473931312561035f;
  float _312 = exp2(_311);
  float _313 = _306 * 23.0f;
  float _314 = _313 + -14.473931312561035f;
  float _315 = exp2(_314);
  float _316 = dot(float3(_309, _312, _315), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _321 = dot(float3(_309, _312, _315), float3(_309, _312, _315));
  float _322 = rsqrt(_321);
  float _323 = _322 * _309;
  float _324 = _322 * _312;
  float _325 = _322 * _315;
  float _326 = cb2_001x - _323;
  float _327 = cb2_001y - _324;
  float _328 = cb2_001z - _325;
  float _329 = dot(float3(_326, _327, _328), float3(_326, _327, _328));
  float _332 = cb2_002z * _329;
  float _334 = _332 + cb2_002w;
  float _335 = saturate(_334);
  float _337 = cb2_002x * _335;
  float _338 = _316 - _309;
  float _339 = _316 - _312;
  float _340 = _316 - _315;
  float _341 = _337 * _338;
  float _342 = _337 * _339;
  float _343 = _337 * _340;
  float _344 = _341 + _309;
  float _345 = _342 + _312;
  float _346 = _343 + _315;
  float _348 = cb2_002y * _335;
  float _349 = 0.10000000149011612f - _344;
  float _350 = 0.10000000149011612f - _345;
  float _351 = 0.10000000149011612f - _346;
  float _352 = _349 * _348;
  float _353 = _350 * _348;
  float _354 = _351 * _348;
  float _355 = _352 + _344;
  float _356 = _353 + _345;
  float _357 = _354 + _346;
  float _358 = saturate(_355);
  float _359 = saturate(_356);
  float _360 = saturate(_357);
  float _364 = cb2_004x * TEXCOORD0_centroid.x;
  float _365 = cb2_004y * TEXCOORD0_centroid.y;
  float _368 = _364 + cb2_004z;
  float _369 = _365 + cb2_004w;
  float4 _375 = t6.Sample(s2_space2, float2(_368, _369));
  float _380 = _375.x * cb2_003x;
  float _381 = _375.y * cb2_003y;
  float _382 = _375.z * cb2_003z;
  float _383 = _375.w * cb2_003w;
  float _386 = _383 + cb2_026y;
  float _387 = saturate(_386);
  bool _390 = ((uint)(cb2_069y) == 0);
  if (!_390) {
    float _392 = _380 * _239;
    float _393 = _381 * _239;
    float _394 = _382 * _239;
    _396 = _392;
    _397 = _393;
    _398 = _394;
  } else {
    _396 = _380;
    _397 = _381;
    _398 = _382;
  }
  bool _401 = ((uint)(cb2_028x) == 2);
  bool _402 = ((uint)(cb2_028x) == 3);
  int _403 = (uint)(cb2_028x) & -2;
  bool _404 = (_403 == 2);
  bool _405 = ((uint)(cb2_028x) == 6);
  bool _406 = _404 || _405;
  if (_406) {
    float _408 = _396 * _387;
    float _409 = _397 * _387;
    float _410 = _398 * _387;
    float _411 = _387 * _387;
    _443 = _408;
    _444 = _409;
    _445 = _410;
    _446 = _411;
  } else {
    bool _413 = ((uint)(cb2_028x) == 4);
    if (_413) {
      float _415 = _396 + -1.0f;
      float _416 = _397 + -1.0f;
      float _417 = _398 + -1.0f;
      float _418 = _387 + -1.0f;
      float _419 = _415 * _387;
      float _420 = _416 * _387;
      float _421 = _417 * _387;
      float _422 = _418 * _387;
      float _423 = _419 + 1.0f;
      float _424 = _420 + 1.0f;
      float _425 = _421 + 1.0f;
      float _426 = _422 + 1.0f;
      _443 = _423;
      _444 = _424;
      _445 = _425;
      _446 = _426;
    } else {
      bool _428 = ((uint)(cb2_028x) == 5);
      if (_428) {
        float _430 = _396 + -0.5f;
        float _431 = _397 + -0.5f;
        float _432 = _398 + -0.5f;
        float _433 = _387 + -0.5f;
        float _434 = _430 * _387;
        float _435 = _431 * _387;
        float _436 = _432 * _387;
        float _437 = _433 * _387;
        float _438 = _434 + 0.5f;
        float _439 = _435 + 0.5f;
        float _440 = _436 + 0.5f;
        float _441 = _437 + 0.5f;
        _443 = _438;
        _444 = _439;
        _445 = _440;
        _446 = _441;
      } else {
        _443 = _396;
        _444 = _397;
        _445 = _398;
        _446 = _387;
      }
    }
  }
  if (_401) {
    float _448 = _443 + _358;
    float _449 = _444 + _359;
    float _450 = _445 + _360;
    _493 = _448;
    _494 = _449;
    _495 = _450;
  } else {
    if (_402) {
      float _453 = 1.0f - _443;
      float _454 = 1.0f - _444;
      float _455 = 1.0f - _445;
      float _456 = _453 * _358;
      float _457 = _454 * _359;
      float _458 = _455 * _360;
      float _459 = _456 + _443;
      float _460 = _457 + _444;
      float _461 = _458 + _445;
      _493 = _459;
      _494 = _460;
      _495 = _461;
    } else {
      bool _463 = ((uint)(cb2_028x) == 4);
      if (_463) {
        float _465 = _443 * _358;
        float _466 = _444 * _359;
        float _467 = _445 * _360;
        _493 = _465;
        _494 = _466;
        _495 = _467;
      } else {
        bool _469 = ((uint)(cb2_028x) == 5);
        if (_469) {
          float _471 = _358 * 2.0f;
          float _472 = _471 * _443;
          float _473 = _359 * 2.0f;
          float _474 = _473 * _444;
          float _475 = _360 * 2.0f;
          float _476 = _475 * _445;
          _493 = _472;
          _494 = _474;
          _495 = _476;
        } else {
          if (_405) {
            float _479 = _358 - _443;
            float _480 = _359 - _444;
            float _481 = _360 - _445;
            _493 = _479;
            _494 = _480;
            _495 = _481;
          } else {
            float _483 = _443 - _358;
            float _484 = _444 - _359;
            float _485 = _445 - _360;
            float _486 = _446 * _483;
            float _487 = _446 * _484;
            float _488 = _446 * _485;
            float _489 = _486 + _358;
            float _490 = _487 + _359;
            float _491 = _488 + _360;
            _493 = _489;
            _494 = _490;
            _495 = _491;
          }
        }
      }
    }
  }
  float _501 = cb2_016x - _493;
  float _502 = cb2_016y - _494;
  float _503 = cb2_016z - _495;
  float _504 = _501 * cb2_016w;
  float _505 = _502 * cb2_016w;
  float _506 = _503 * cb2_016w;
  float _507 = _504 + _493;
  float _508 = _505 + _494;
  float _509 = _506 + _495;
  bool _512 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_512 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _516 = cb2_024x * _507;
    float _517 = cb2_024x * _508;
    float _518 = cb2_024x * _509;
    _520 = _516;
    _521 = _517;
    _522 = _518;
  } else {
    _520 = _507;
    _521 = _508;
    _522 = _509;
  }
  float _525 = _520 * 0.9708889722824097f;
  float _526 = mad(0.026962999254465103f, _521, _525);
  float _527 = mad(0.002148000057786703f, _522, _526);
  float _528 = _520 * 0.01088900025933981f;
  float _529 = mad(0.9869629740715027f, _521, _528);
  float _530 = mad(0.002148000057786703f, _522, _529);
  float _531 = mad(0.026962999254465103f, _521, _528);
  float _532 = mad(0.9621480107307434f, _522, _531);
  float _533 = max(_527, 0.0f);
  float _534 = max(_530, 0.0f);
  float _535 = max(_532, 0.0f);
  float _536 = min(_533, cb2_095y);
  float _537 = min(_534, cb2_095y);
  float _538 = min(_535, cb2_095y);
  bool _541 = ((uint)(cb2_095x) == 0);
  bool _544 = ((uint)(cb2_094w) == 0);
  bool _546 = ((uint)(cb2_094z) == 0);
  bool _548 = ((uint)(cb2_094y) != 0);
  bool _550 = ((uint)(cb2_094x) == 0);
  bool _552 = ((uint)(cb2_069z) != 0);
  float _599 = asfloat((uint)(cb2_075y));
  float _600 = asfloat((uint)(cb2_075z));
  float _601 = asfloat((uint)(cb2_075w));
  float _602 = asfloat((uint)(cb2_074z));
  float _603 = asfloat((uint)(cb2_074w));
  float _604 = asfloat((uint)(cb2_075x));
  float _605 = asfloat((uint)(cb2_073w));
  float _606 = asfloat((uint)(cb2_074x));
  float _607 = asfloat((uint)(cb2_074y));
  float _608 = asfloat((uint)(cb2_077x));
  float _609 = asfloat((uint)(cb2_077y));
  float _610 = asfloat((uint)(cb2_079x));
  float _611 = asfloat((uint)(cb2_079y));
  float _612 = asfloat((uint)(cb2_079z));
  float _613 = asfloat((uint)(cb2_078y));
  float _614 = asfloat((uint)(cb2_078z));
  float _615 = asfloat((uint)(cb2_078w));
  float _616 = asfloat((uint)(cb2_077z));
  float _617 = asfloat((uint)(cb2_077w));
  float _618 = asfloat((uint)(cb2_078x));
  float _619 = asfloat((uint)(cb2_072y));
  float _620 = asfloat((uint)(cb2_072z));
  float _621 = asfloat((uint)(cb2_072w));
  float _622 = asfloat((uint)(cb2_071x));
  float _623 = asfloat((uint)(cb2_071y));
  float _624 = asfloat((uint)(cb2_076x));
  float _625 = asfloat((uint)(cb2_070w));
  float _626 = asfloat((uint)(cb2_070x));
  float _627 = asfloat((uint)(cb2_070y));
  float _628 = asfloat((uint)(cb2_070z));
  float _629 = asfloat((uint)(cb2_073x));
  float _630 = asfloat((uint)(cb2_073y));
  float _631 = asfloat((uint)(cb2_073z));
  float _632 = asfloat((uint)(cb2_071z));
  float _633 = asfloat((uint)(cb2_071w));
  float _634 = asfloat((uint)(cb2_072x));
  float _635 = max(_537, _538);
  float _636 = max(_536, _635);
  float _637 = 1.0f / _636;
  float _638 = _637 * _536;
  float _639 = _637 * _537;
  float _640 = _637 * _538;
  float _641 = abs(_638);
  float _642 = log2(_641);
  float _643 = _642 * _626;
  float _644 = exp2(_643);
  float _645 = abs(_639);
  float _646 = log2(_645);
  float _647 = _646 * _627;
  float _648 = exp2(_647);
  float _649 = abs(_640);
  float _650 = log2(_649);
  float _651 = _650 * _628;
  float _652 = exp2(_651);
  if (_548) {
    float _655 = asfloat((uint)(cb2_076w));
    float _657 = asfloat((uint)(cb2_076z));
    float _659 = asfloat((uint)(cb2_076y));
    float _660 = _657 * _537;
    float _661 = _659 * _536;
    float _662 = _655 * _538;
    float _663 = _661 + _662;
    float _664 = _663 + _660;
    _672 = _664;
  } else {
    float _666 = _633 * _537;
    float _667 = _632 * _536;
    float _668 = _634 * _538;
    float _669 = _666 + _667;
    float _670 = _669 + _668;
    _672 = _670;
  }
  float _673 = abs(_672);
  float _674 = log2(_673);
  float _675 = _674 * _625;
  float _676 = exp2(_675);
  float _677 = log2(_676);
  float _678 = _677 * _624;
  float _679 = exp2(_678);
  float _680 = select(_552, _679, _676);
  float _681 = _680 * _622;
  float _682 = _681 + _623;
  float _683 = 1.0f / _682;
  float _684 = _683 * _676;
  if (_548) {
    if (!_550) {
      float _687 = _644 * _616;
      float _688 = _648 * _617;
      float _689 = _652 * _618;
      float _690 = _688 + _687;
      float _691 = _690 + _689;
      float _692 = _648 * _614;
      float _693 = _644 * _613;
      float _694 = _652 * _615;
      float _695 = _692 + _693;
      float _696 = _695 + _694;
      float _697 = _652 * _612;
      float _698 = _648 * _611;
      float _699 = _644 * _610;
      float _700 = _698 + _699;
      float _701 = _700 + _697;
      float _702 = max(_696, _701);
      float _703 = max(_691, _702);
      float _704 = 1.0f / _703;
      float _705 = _704 * _691;
      float _706 = _704 * _696;
      float _707 = _704 * _701;
      _709 = _705;
      _710 = _706;
      _711 = _707;
    } else {
      _709 = _644;
      _710 = _648;
      _711 = _652;
    }
    float _712 = _709 * _609;
    float _713 = exp2(_712);
    float _714 = _713 * _608;
    float _715 = saturate(_714);
    float _716 = _709 * _608;
    float _717 = _709 - _716;
    float _718 = saturate(_717);
    float _719 = max(_608, _718);
    float _720 = min(_719, _715);
    float _721 = _710 * _609;
    float _722 = exp2(_721);
    float _723 = _722 * _608;
    float _724 = saturate(_723);
    float _725 = _710 * _608;
    float _726 = _710 - _725;
    float _727 = saturate(_726);
    float _728 = max(_608, _727);
    float _729 = min(_728, _724);
    float _730 = _711 * _609;
    float _731 = exp2(_730);
    float _732 = _731 * _608;
    float _733 = saturate(_732);
    float _734 = _711 * _608;
    float _735 = _711 - _734;
    float _736 = saturate(_735);
    float _737 = max(_608, _736);
    float _738 = min(_737, _733);
    _740 = _720;
    _741 = _729;
    _742 = _738;
  } else {
    _740 = _644;
    _741 = _648;
    _742 = _652;
  }
  float _743 = _740 * _632;
  float _744 = _741 * _633;
  float _745 = _744 + _743;
  float _746 = _742 * _634;
  float _747 = _745 + _746;
  float _748 = 1.0f / _747;
  float _749 = _748 * _684;
  float _750 = saturate(_749);
  float _751 = _750 * _740;
  float _752 = saturate(_751);
  float _753 = _750 * _741;
  float _754 = saturate(_753);
  float _755 = _750 * _742;
  float _756 = saturate(_755);
  float _757 = _752 * _619;
  float _758 = _619 - _757;
  float _759 = _754 * _620;
  float _760 = _620 - _759;
  float _761 = _756 * _621;
  float _762 = _621 - _761;
  float _763 = _756 * _634;
  float _764 = _752 * _632;
  float _765 = _754 * _633;
  float _766 = _684 - _764;
  float _767 = _766 - _765;
  float _768 = _767 - _763;
  float _769 = saturate(_768);
  float _770 = _760 * _633;
  float _771 = _758 * _632;
  float _772 = _762 * _634;
  float _773 = _770 + _771;
  float _774 = _773 + _772;
  float _775 = 1.0f / _774;
  float _776 = _775 * _769;
  float _777 = _776 * _758;
  float _778 = _777 + _752;
  float _779 = saturate(_778);
  float _780 = _776 * _760;
  float _781 = _780 + _754;
  float _782 = saturate(_781);
  float _783 = _776 * _762;
  float _784 = _783 + _756;
  float _785 = saturate(_784);
  float _786 = _785 * _634;
  float _787 = _779 * _632;
  float _788 = _782 * _633;
  float _789 = _684 - _787;
  float _790 = _789 - _788;
  float _791 = _790 - _786;
  float _792 = saturate(_791);
  float _793 = _792 * _629;
  float _794 = _793 + _779;
  float _795 = saturate(_794);
  float _796 = _792 * _630;
  float _797 = _796 + _782;
  float _798 = saturate(_797);
  float _799 = _792 * _631;
  float _800 = _799 + _785;
  float _801 = saturate(_800);
  if (!_546) {
    float _803 = _795 * _605;
    float _804 = _798 * _606;
    float _805 = _801 * _607;
    float _806 = _804 + _803;
    float _807 = _806 + _805;
    float _808 = _798 * _603;
    float _809 = _795 * _602;
    float _810 = _801 * _604;
    float _811 = _808 + _809;
    float _812 = _811 + _810;
    float _813 = _801 * _601;
    float _814 = _798 * _600;
    float _815 = _795 * _599;
    float _816 = _814 + _815;
    float _817 = _816 + _813;
    if (!_544) {
      float _819 = saturate(_807);
      float _820 = saturate(_812);
      float _821 = saturate(_817);
      _823 = _821;
      _824 = _820;
      _825 = _819;
    } else {
      _823 = _817;
      _824 = _812;
      _825 = _807;
    }
  } else {
    _823 = _801;
    _824 = _798;
    _825 = _795;
  }
  if (!_541) {
    float _827 = _825 * _605;
    float _828 = _824 * _605;
    float _829 = _823 * _605;
    _831 = _829;
    _832 = _828;
    _833 = _827;
  } else {
    _831 = _823;
    _832 = _824;
    _833 = _825;
  }
  if (_512) {
    float _837 = cb1_018z * 9.999999747378752e-05f;
    float _838 = _837 * _833;
    float _839 = _837 * _832;
    float _840 = _837 * _831;
    float _842 = 5000.0f / cb1_018y;
    float _843 = _838 * _842;
    float _844 = _839 * _842;
    float _845 = _840 * _842;
    _847 = _843;
    _848 = _844;
    _849 = _845;
  } else {
    _847 = _833;
    _848 = _832;
    _849 = _831;
  }
  float _850 = _847 * 1.6047500371932983f;
  float _851 = mad(-0.5310800075531006f, _848, _850);
  float _852 = mad(-0.07366999983787537f, _849, _851);
  float _853 = _847 * -0.10208000242710114f;
  float _854 = mad(1.1081299781799316f, _848, _853);
  float _855 = mad(-0.006049999967217445f, _849, _854);
  float _856 = _847 * -0.0032599999103695154f;
  float _857 = mad(-0.07275000214576721f, _848, _856);
  float _858 = mad(1.0760200023651123f, _849, _857);
  if (_512) {
    // float _860 = max(_852, 0.0f);
    // float _861 = max(_855, 0.0f);
    // float _862 = max(_858, 0.0f);
    // bool _863 = !(_860 >= 0.0030399328097701073f);
    // if (!_863) {
    //   float _865 = abs(_860);
    //   float _866 = log2(_865);
    //   float _867 = _866 * 0.4166666567325592f;
    //   float _868 = exp2(_867);
    //   float _869 = _868 * 1.0549999475479126f;
    //   float _870 = _869 + -0.054999999701976776f;
    //   _874 = _870;
    // } else {
    //   float _872 = _860 * 12.923210144042969f;
    //   _874 = _872;
    // }
    // bool _875 = !(_861 >= 0.0030399328097701073f);
    // if (!_875) {
    //   float _877 = abs(_861);
    //   float _878 = log2(_877);
    //   float _879 = _878 * 0.4166666567325592f;
    //   float _880 = exp2(_879);
    //   float _881 = _880 * 1.0549999475479126f;
    //   float _882 = _881 + -0.054999999701976776f;
    //   _886 = _882;
    // } else {
    //   float _884 = _861 * 12.923210144042969f;
    //   _886 = _884;
    // }
    // bool _887 = !(_862 >= 0.0030399328097701073f);
    // if (!_887) {
    //   float _889 = abs(_862);
    //   float _890 = log2(_889);
    //   float _891 = _890 * 0.4166666567325592f;
    //   float _892 = exp2(_891);
    //   float _893 = _892 * 1.0549999475479126f;
    //   float _894 = _893 + -0.054999999701976776f;
    //   _967 = _874;
    //   _968 = _886;
    //   _969 = _894;
    // } else {
    //   float _896 = _862 * 12.923210144042969f;
    //   _967 = _874;
    //   _968 = _886;
    //   _969 = _896;
    // }
    _967 = renodx::color::srgb::EncodeSafe(_852);
    _968 = renodx::color::srgb::EncodeSafe(_855);
    _969 = renodx::color::srgb::EncodeSafe(_858);

  } else {
    float _898 = saturate(_852);
    float _899 = saturate(_855);
    float _900 = saturate(_858);
    bool _901 = ((uint)(cb1_018w) == -2);
    if (!_901) {
      bool _903 = !(_898 >= 0.0030399328097701073f);
      if (!_903) {
        float _905 = abs(_898);
        float _906 = log2(_905);
        float _907 = _906 * 0.4166666567325592f;
        float _908 = exp2(_907);
        float _909 = _908 * 1.0549999475479126f;
        float _910 = _909 + -0.054999999701976776f;
        _914 = _910;
      } else {
        float _912 = _898 * 12.923210144042969f;
        _914 = _912;
      }
      bool _915 = !(_899 >= 0.0030399328097701073f);
      if (!_915) {
        float _917 = abs(_899);
        float _918 = log2(_917);
        float _919 = _918 * 0.4166666567325592f;
        float _920 = exp2(_919);
        float _921 = _920 * 1.0549999475479126f;
        float _922 = _921 + -0.054999999701976776f;
        _926 = _922;
      } else {
        float _924 = _899 * 12.923210144042969f;
        _926 = _924;
      }
      bool _927 = !(_900 >= 0.0030399328097701073f);
      if (!_927) {
        float _929 = abs(_900);
        float _930 = log2(_929);
        float _931 = _930 * 0.4166666567325592f;
        float _932 = exp2(_931);
        float _933 = _932 * 1.0549999475479126f;
        float _934 = _933 + -0.054999999701976776f;
        _938 = _914;
        _939 = _926;
        _940 = _934;
      } else {
        float _936 = _900 * 12.923210144042969f;
        _938 = _914;
        _939 = _926;
        _940 = _936;
      }
    } else {
      _938 = _898;
      _939 = _899;
      _940 = _900;
    }
    float _945 = abs(_938);
    float _946 = abs(_939);
    float _947 = abs(_940);
    float _948 = log2(_945);
    float _949 = log2(_946);
    float _950 = log2(_947);
    float _951 = _948 * cb2_000z;
    float _952 = _949 * cb2_000z;
    float _953 = _950 * cb2_000z;
    float _954 = exp2(_951);
    float _955 = exp2(_952);
    float _956 = exp2(_953);
    float _957 = _954 * cb2_000y;
    float _958 = _955 * cb2_000y;
    float _959 = _956 * cb2_000y;
    float _960 = _957 + cb2_000x;
    float _961 = _958 + cb2_000x;
    float _962 = _959 + cb2_000x;
    float _963 = saturate(_960);
    float _964 = saturate(_961);
    float _965 = saturate(_962);
    _967 = _963;
    _968 = _964;
    _969 = _965;
  }
  float _970 = dot(float3(_967, _968, _969), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _967;
  SV_Target.y = _968;
  SV_Target.z = _969;
  SV_Target.w = _970;
  SV_Target_1.x = _970;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

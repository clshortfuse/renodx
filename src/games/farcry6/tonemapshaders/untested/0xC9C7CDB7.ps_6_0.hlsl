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
  float _360;
  float _361;
  float _362;
  float _407;
  float _408;
  float _409;
  float _410;
  float _457;
  float _458;
  float _459;
  float _484;
  float _485;
  float _486;
  float _636;
  float _673;
  float _674;
  float _675;
  float _704;
  float _705;
  float _706;
  float _787;
  float _788;
  float _789;
  float _795;
  float _796;
  float _797;
  float _811;
  float _812;
  float _813;
  float _838;
  float _850;
  float _878;
  float _890;
  float _902;
  float _903;
  float _904;
  float _931;
  float _932;
  float _933;
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
  float _328 = cb2_004x * TEXCOORD0_centroid.x;
  float _329 = cb2_004y * TEXCOORD0_centroid.y;
  float _332 = _328 + cb2_004z;
  float _333 = _329 + cb2_004w;
  float4 _339 = t6.Sample(s2_space2, float2(_332, _333));
  float _344 = _339.x * cb2_003x;
  float _345 = _339.y * cb2_003y;
  float _346 = _339.z * cb2_003z;
  float _347 = _339.w * cb2_003w;
  float _350 = _347 + cb2_026y;
  float _351 = saturate(_350);
  bool _354 = ((uint)(cb2_069y) == 0);
  if (!_354) {
    float _356 = _344 * _248;
    float _357 = _345 * _248;
    float _358 = _346 * _248;
    _360 = _356;
    _361 = _357;
    _362 = _358;
  } else {
    _360 = _344;
    _361 = _345;
    _362 = _346;
  }
  bool _365 = ((uint)(cb2_028x) == 2);
  bool _366 = ((uint)(cb2_028x) == 3);
  int _367 = (uint)(cb2_028x) & -2;
  bool _368 = (_367 == 2);
  bool _369 = ((uint)(cb2_028x) == 6);
  bool _370 = _368 || _369;
  if (_370) {
    float _372 = _360 * _351;
    float _373 = _361 * _351;
    float _374 = _362 * _351;
    float _375 = _351 * _351;
    _407 = _372;
    _408 = _373;
    _409 = _374;
    _410 = _375;
  } else {
    bool _377 = ((uint)(cb2_028x) == 4);
    if (_377) {
      float _379 = _360 + -1.0f;
      float _380 = _361 + -1.0f;
      float _381 = _362 + -1.0f;
      float _382 = _351 + -1.0f;
      float _383 = _379 * _351;
      float _384 = _380 * _351;
      float _385 = _381 * _351;
      float _386 = _382 * _351;
      float _387 = _383 + 1.0f;
      float _388 = _384 + 1.0f;
      float _389 = _385 + 1.0f;
      float _390 = _386 + 1.0f;
      _407 = _387;
      _408 = _388;
      _409 = _389;
      _410 = _390;
    } else {
      bool _392 = ((uint)(cb2_028x) == 5);
      if (_392) {
        float _394 = _360 + -0.5f;
        float _395 = _361 + -0.5f;
        float _396 = _362 + -0.5f;
        float _397 = _351 + -0.5f;
        float _398 = _394 * _351;
        float _399 = _395 * _351;
        float _400 = _396 * _351;
        float _401 = _397 * _351;
        float _402 = _398 + 0.5f;
        float _403 = _399 + 0.5f;
        float _404 = _400 + 0.5f;
        float _405 = _401 + 0.5f;
        _407 = _402;
        _408 = _403;
        _409 = _404;
        _410 = _405;
      } else {
        _407 = _360;
        _408 = _361;
        _409 = _362;
        _410 = _351;
      }
    }
  }
  if (_365) {
    float _412 = _407 + _318;
    float _413 = _408 + _321;
    float _414 = _409 + _324;
    _457 = _412;
    _458 = _413;
    _459 = _414;
  } else {
    if (_366) {
      float _417 = 1.0f - _407;
      float _418 = 1.0f - _408;
      float _419 = 1.0f - _409;
      float _420 = _417 * _318;
      float _421 = _418 * _321;
      float _422 = _419 * _324;
      float _423 = _420 + _407;
      float _424 = _421 + _408;
      float _425 = _422 + _409;
      _457 = _423;
      _458 = _424;
      _459 = _425;
    } else {
      bool _427 = ((uint)(cb2_028x) == 4);
      if (_427) {
        float _429 = _407 * _318;
        float _430 = _408 * _321;
        float _431 = _409 * _324;
        _457 = _429;
        _458 = _430;
        _459 = _431;
      } else {
        bool _433 = ((uint)(cb2_028x) == 5);
        if (_433) {
          float _435 = _318 * 2.0f;
          float _436 = _435 * _407;
          float _437 = _321 * 2.0f;
          float _438 = _437 * _408;
          float _439 = _324 * 2.0f;
          float _440 = _439 * _409;
          _457 = _436;
          _458 = _438;
          _459 = _440;
        } else {
          if (_369) {
            float _443 = _318 - _407;
            float _444 = _321 - _408;
            float _445 = _324 - _409;
            _457 = _443;
            _458 = _444;
            _459 = _445;
          } else {
            float _447 = _407 - _318;
            float _448 = _408 - _321;
            float _449 = _409 - _324;
            float _450 = _410 * _447;
            float _451 = _410 * _448;
            float _452 = _410 * _449;
            float _453 = _450 + _318;
            float _454 = _451 + _321;
            float _455 = _452 + _324;
            _457 = _453;
            _458 = _454;
            _459 = _455;
          }
        }
      }
    }
  }
  float _465 = cb2_016x - _457;
  float _466 = cb2_016y - _458;
  float _467 = cb2_016z - _459;
  float _468 = _465 * cb2_016w;
  float _469 = _466 * cb2_016w;
  float _470 = _467 * cb2_016w;
  float _471 = _468 + _457;
  float _472 = _469 + _458;
  float _473 = _470 + _459;
  bool _476 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_476 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _480 = cb2_024x * _471;
    float _481 = cb2_024x * _472;
    float _482 = cb2_024x * _473;
    _484 = _480;
    _485 = _481;
    _486 = _482;
  } else {
    _484 = _471;
    _485 = _472;
    _486 = _473;
  }
  float _489 = _484 * 0.9708889722824097f;
  float _490 = mad(0.026962999254465103f, _485, _489);
  float _491 = mad(0.002148000057786703f, _486, _490);
  float _492 = _484 * 0.01088900025933981f;
  float _493 = mad(0.9869629740715027f, _485, _492);
  float _494 = mad(0.002148000057786703f, _486, _493);
  float _495 = mad(0.026962999254465103f, _485, _492);
  float _496 = mad(0.9621480107307434f, _486, _495);
  float _497 = max(_491, 0.0f);
  float _498 = max(_494, 0.0f);
  float _499 = max(_496, 0.0f);
  float _500 = min(_497, cb2_095y);
  float _501 = min(_498, cb2_095y);
  float _502 = min(_499, cb2_095y);
  bool _505 = ((uint)(cb2_095x) == 0);
  bool _508 = ((uint)(cb2_094w) == 0);
  bool _510 = ((uint)(cb2_094z) == 0);
  bool _512 = ((uint)(cb2_094y) != 0);
  bool _514 = ((uint)(cb2_094x) == 0);
  bool _516 = ((uint)(cb2_069z) != 0);
  float _563 = asfloat((uint)(cb2_075y));
  float _564 = asfloat((uint)(cb2_075z));
  float _565 = asfloat((uint)(cb2_075w));
  float _566 = asfloat((uint)(cb2_074z));
  float _567 = asfloat((uint)(cb2_074w));
  float _568 = asfloat((uint)(cb2_075x));
  float _569 = asfloat((uint)(cb2_073w));
  float _570 = asfloat((uint)(cb2_074x));
  float _571 = asfloat((uint)(cb2_074y));
  float _572 = asfloat((uint)(cb2_077x));
  float _573 = asfloat((uint)(cb2_077y));
  float _574 = asfloat((uint)(cb2_079x));
  float _575 = asfloat((uint)(cb2_079y));
  float _576 = asfloat((uint)(cb2_079z));
  float _577 = asfloat((uint)(cb2_078y));
  float _578 = asfloat((uint)(cb2_078z));
  float _579 = asfloat((uint)(cb2_078w));
  float _580 = asfloat((uint)(cb2_077z));
  float _581 = asfloat((uint)(cb2_077w));
  float _582 = asfloat((uint)(cb2_078x));
  float _583 = asfloat((uint)(cb2_072y));
  float _584 = asfloat((uint)(cb2_072z));
  float _585 = asfloat((uint)(cb2_072w));
  float _586 = asfloat((uint)(cb2_071x));
  float _587 = asfloat((uint)(cb2_071y));
  float _588 = asfloat((uint)(cb2_076x));
  float _589 = asfloat((uint)(cb2_070w));
  float _590 = asfloat((uint)(cb2_070x));
  float _591 = asfloat((uint)(cb2_070y));
  float _592 = asfloat((uint)(cb2_070z));
  float _593 = asfloat((uint)(cb2_073x));
  float _594 = asfloat((uint)(cb2_073y));
  float _595 = asfloat((uint)(cb2_073z));
  float _596 = asfloat((uint)(cb2_071z));
  float _597 = asfloat((uint)(cb2_071w));
  float _598 = asfloat((uint)(cb2_072x));
  float _599 = max(_501, _502);
  float _600 = max(_500, _599);
  float _601 = 1.0f / _600;
  float _602 = _601 * _500;
  float _603 = _601 * _501;
  float _604 = _601 * _502;
  float _605 = abs(_602);
  float _606 = log2(_605);
  float _607 = _606 * _590;
  float _608 = exp2(_607);
  float _609 = abs(_603);
  float _610 = log2(_609);
  float _611 = _610 * _591;
  float _612 = exp2(_611);
  float _613 = abs(_604);
  float _614 = log2(_613);
  float _615 = _614 * _592;
  float _616 = exp2(_615);
  if (_512) {
    float _619 = asfloat((uint)(cb2_076w));
    float _621 = asfloat((uint)(cb2_076z));
    float _623 = asfloat((uint)(cb2_076y));
    float _624 = _621 * _501;
    float _625 = _623 * _500;
    float _626 = _619 * _502;
    float _627 = _625 + _626;
    float _628 = _627 + _624;
    _636 = _628;
  } else {
    float _630 = _597 * _501;
    float _631 = _596 * _500;
    float _632 = _598 * _502;
    float _633 = _630 + _631;
    float _634 = _633 + _632;
    _636 = _634;
  }
  float _637 = abs(_636);
  float _638 = log2(_637);
  float _639 = _638 * _589;
  float _640 = exp2(_639);
  float _641 = log2(_640);
  float _642 = _641 * _588;
  float _643 = exp2(_642);
  float _644 = select(_516, _643, _640);
  float _645 = _644 * _586;
  float _646 = _645 + _587;
  float _647 = 1.0f / _646;
  float _648 = _647 * _640;
  if (_512) {
    if (!_514) {
      float _651 = _608 * _580;
      float _652 = _612 * _581;
      float _653 = _616 * _582;
      float _654 = _652 + _651;
      float _655 = _654 + _653;
      float _656 = _612 * _578;
      float _657 = _608 * _577;
      float _658 = _616 * _579;
      float _659 = _656 + _657;
      float _660 = _659 + _658;
      float _661 = _616 * _576;
      float _662 = _612 * _575;
      float _663 = _608 * _574;
      float _664 = _662 + _663;
      float _665 = _664 + _661;
      float _666 = max(_660, _665);
      float _667 = max(_655, _666);
      float _668 = 1.0f / _667;
      float _669 = _668 * _655;
      float _670 = _668 * _660;
      float _671 = _668 * _665;
      _673 = _669;
      _674 = _670;
      _675 = _671;
    } else {
      _673 = _608;
      _674 = _612;
      _675 = _616;
    }
    float _676 = _673 * _573;
    float _677 = exp2(_676);
    float _678 = _677 * _572;
    float _679 = saturate(_678);
    float _680 = _673 * _572;
    float _681 = _673 - _680;
    float _682 = saturate(_681);
    float _683 = max(_572, _682);
    float _684 = min(_683, _679);
    float _685 = _674 * _573;
    float _686 = exp2(_685);
    float _687 = _686 * _572;
    float _688 = saturate(_687);
    float _689 = _674 * _572;
    float _690 = _674 - _689;
    float _691 = saturate(_690);
    float _692 = max(_572, _691);
    float _693 = min(_692, _688);
    float _694 = _675 * _573;
    float _695 = exp2(_694);
    float _696 = _695 * _572;
    float _697 = saturate(_696);
    float _698 = _675 * _572;
    float _699 = _675 - _698;
    float _700 = saturate(_699);
    float _701 = max(_572, _700);
    float _702 = min(_701, _697);
    _704 = _684;
    _705 = _693;
    _706 = _702;
  } else {
    _704 = _608;
    _705 = _612;
    _706 = _616;
  }
  float _707 = _704 * _596;
  float _708 = _705 * _597;
  float _709 = _708 + _707;
  float _710 = _706 * _598;
  float _711 = _709 + _710;
  float _712 = 1.0f / _711;
  float _713 = _712 * _648;
  float _714 = saturate(_713);
  float _715 = _714 * _704;
  float _716 = saturate(_715);
  float _717 = _714 * _705;
  float _718 = saturate(_717);
  float _719 = _714 * _706;
  float _720 = saturate(_719);
  float _721 = _716 * _583;
  float _722 = _583 - _721;
  float _723 = _718 * _584;
  float _724 = _584 - _723;
  float _725 = _720 * _585;
  float _726 = _585 - _725;
  float _727 = _720 * _598;
  float _728 = _716 * _596;
  float _729 = _718 * _597;
  float _730 = _648 - _728;
  float _731 = _730 - _729;
  float _732 = _731 - _727;
  float _733 = saturate(_732);
  float _734 = _724 * _597;
  float _735 = _722 * _596;
  float _736 = _726 * _598;
  float _737 = _734 + _735;
  float _738 = _737 + _736;
  float _739 = 1.0f / _738;
  float _740 = _739 * _733;
  float _741 = _740 * _722;
  float _742 = _741 + _716;
  float _743 = saturate(_742);
  float _744 = _740 * _724;
  float _745 = _744 + _718;
  float _746 = saturate(_745);
  float _747 = _740 * _726;
  float _748 = _747 + _720;
  float _749 = saturate(_748);
  float _750 = _749 * _598;
  float _751 = _743 * _596;
  float _752 = _746 * _597;
  float _753 = _648 - _751;
  float _754 = _753 - _752;
  float _755 = _754 - _750;
  float _756 = saturate(_755);
  float _757 = _756 * _593;
  float _758 = _757 + _743;
  float _759 = saturate(_758);
  float _760 = _756 * _594;
  float _761 = _760 + _746;
  float _762 = saturate(_761);
  float _763 = _756 * _595;
  float _764 = _763 + _749;
  float _765 = saturate(_764);
  if (!_510) {
    float _767 = _759 * _569;
    float _768 = _762 * _570;
    float _769 = _765 * _571;
    float _770 = _768 + _767;
    float _771 = _770 + _769;
    float _772 = _762 * _567;
    float _773 = _759 * _566;
    float _774 = _765 * _568;
    float _775 = _772 + _773;
    float _776 = _775 + _774;
    float _777 = _765 * _565;
    float _778 = _762 * _564;
    float _779 = _759 * _563;
    float _780 = _778 + _779;
    float _781 = _780 + _777;
    if (!_508) {
      float _783 = saturate(_771);
      float _784 = saturate(_776);
      float _785 = saturate(_781);
      _787 = _785;
      _788 = _784;
      _789 = _783;
    } else {
      _787 = _781;
      _788 = _776;
      _789 = _771;
    }
  } else {
    _787 = _765;
    _788 = _762;
    _789 = _759;
  }
  if (!_505) {
    float _791 = _789 * _569;
    float _792 = _788 * _569;
    float _793 = _787 * _569;
    _795 = _793;
    _796 = _792;
    _797 = _791;
  } else {
    _795 = _787;
    _796 = _788;
    _797 = _789;
  }
  if (_476) {
    float _801 = cb1_018z * 9.999999747378752e-05f;
    float _802 = _801 * _797;
    float _803 = _801 * _796;
    float _804 = _801 * _795;
    float _806 = 5000.0f / cb1_018y;
    float _807 = _802 * _806;
    float _808 = _803 * _806;
    float _809 = _804 * _806;
    _811 = _807;
    _812 = _808;
    _813 = _809;
  } else {
    _811 = _797;
    _812 = _796;
    _813 = _795;
  }
  float _814 = _811 * 1.6047500371932983f;
  float _815 = mad(-0.5310800075531006f, _812, _814);
  float _816 = mad(-0.07366999983787537f, _813, _815);
  float _817 = _811 * -0.10208000242710114f;
  float _818 = mad(1.1081299781799316f, _812, _817);
  float _819 = mad(-0.006049999967217445f, _813, _818);
  float _820 = _811 * -0.0032599999103695154f;
  float _821 = mad(-0.07275000214576721f, _812, _820);
  float _822 = mad(1.0760200023651123f, _813, _821);
  if (_476) {
    // float _824 = max(_816, 0.0f);
    // float _825 = max(_819, 0.0f);
    // float _826 = max(_822, 0.0f);
    // bool _827 = !(_824 >= 0.0030399328097701073f);
    // if (!_827) {
    //   float _829 = abs(_824);
    //   float _830 = log2(_829);
    //   float _831 = _830 * 0.4166666567325592f;
    //   float _832 = exp2(_831);
    //   float _833 = _832 * 1.0549999475479126f;
    //   float _834 = _833 + -0.054999999701976776f;
    //   _838 = _834;
    // } else {
    //   float _836 = _824 * 12.923210144042969f;
    //   _838 = _836;
    // }
    // bool _839 = !(_825 >= 0.0030399328097701073f);
    // if (!_839) {
    //   float _841 = abs(_825);
    //   float _842 = log2(_841);
    //   float _843 = _842 * 0.4166666567325592f;
    //   float _844 = exp2(_843);
    //   float _845 = _844 * 1.0549999475479126f;
    //   float _846 = _845 + -0.054999999701976776f;
    //   _850 = _846;
    // } else {
    //   float _848 = _825 * 12.923210144042969f;
    //   _850 = _848;
    // }
    // bool _851 = !(_826 >= 0.0030399328097701073f);
    // if (!_851) {
    //   float _853 = abs(_826);
    //   float _854 = log2(_853);
    //   float _855 = _854 * 0.4166666567325592f;
    //   float _856 = exp2(_855);
    //   float _857 = _856 * 1.0549999475479126f;
    //   float _858 = _857 + -0.054999999701976776f;
    //   _931 = _838;
    //   _932 = _850;
    //   _933 = _858;
    // } else {
    //   float _860 = _826 * 12.923210144042969f;
    //   _931 = _838;
    //   _932 = _850;
    //   _933 = _860;
    // }
    _931 = renodx::color::srgb::EncodeSafe(_816);
    _932 = renodx::color::srgb::EncodeSafe(_819);
    _933 = renodx::color::srgb::EncodeSafe(_822);

  } else {
    float _862 = saturate(_816);
    float _863 = saturate(_819);
    float _864 = saturate(_822);
    bool _865 = ((uint)(cb1_018w) == -2);
    if (!_865) {
      bool _867 = !(_862 >= 0.0030399328097701073f);
      if (!_867) {
        float _869 = abs(_862);
        float _870 = log2(_869);
        float _871 = _870 * 0.4166666567325592f;
        float _872 = exp2(_871);
        float _873 = _872 * 1.0549999475479126f;
        float _874 = _873 + -0.054999999701976776f;
        _878 = _874;
      } else {
        float _876 = _862 * 12.923210144042969f;
        _878 = _876;
      }
      bool _879 = !(_863 >= 0.0030399328097701073f);
      if (!_879) {
        float _881 = abs(_863);
        float _882 = log2(_881);
        float _883 = _882 * 0.4166666567325592f;
        float _884 = exp2(_883);
        float _885 = _884 * 1.0549999475479126f;
        float _886 = _885 + -0.054999999701976776f;
        _890 = _886;
      } else {
        float _888 = _863 * 12.923210144042969f;
        _890 = _888;
      }
      bool _891 = !(_864 >= 0.0030399328097701073f);
      if (!_891) {
        float _893 = abs(_864);
        float _894 = log2(_893);
        float _895 = _894 * 0.4166666567325592f;
        float _896 = exp2(_895);
        float _897 = _896 * 1.0549999475479126f;
        float _898 = _897 + -0.054999999701976776f;
        _902 = _878;
        _903 = _890;
        _904 = _898;
      } else {
        float _900 = _864 * 12.923210144042969f;
        _902 = _878;
        _903 = _890;
        _904 = _900;
      }
    } else {
      _902 = _862;
      _903 = _863;
      _904 = _864;
    }
    float _909 = abs(_902);
    float _910 = abs(_903);
    float _911 = abs(_904);
    float _912 = log2(_909);
    float _913 = log2(_910);
    float _914 = log2(_911);
    float _915 = _912 * cb2_000z;
    float _916 = _913 * cb2_000z;
    float _917 = _914 * cb2_000z;
    float _918 = exp2(_915);
    float _919 = exp2(_916);
    float _920 = exp2(_917);
    float _921 = _918 * cb2_000y;
    float _922 = _919 * cb2_000y;
    float _923 = _920 * cb2_000y;
    float _924 = _921 + cb2_000x;
    float _925 = _922 + cb2_000x;
    float _926 = _923 + cb2_000x;
    float _927 = saturate(_924);
    float _928 = saturate(_925);
    float _929 = saturate(_926);
    _931 = _927;
    _932 = _928;
    _933 = _929;
  }
  float _934 = dot(float3(_931, _932, _933), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _931;
  SV_Target.y = _932;
  SV_Target.z = _933;
  SV_Target.w = _934;
  SV_Target_1.x = _934;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

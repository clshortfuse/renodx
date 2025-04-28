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

Texture3D<float2> t9 : register(t9);

Texture2D<float4> t10 : register(t10);

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
  float _25 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _27 = t8.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _31 = _27.x * 6.283199787139893f;
  float _32 = cos(_31);
  float _33 = sin(_31);
  float _34 = _32 * _27.z;
  float _35 = _33 * _27.z;
  float _36 = _34 + TEXCOORD0_centroid.x;
  float _37 = _35 + TEXCOORD0_centroid.y;
  float _38 = _36 * 10.0f;
  float _39 = 10.0f - _38;
  float _40 = min(_38, _39);
  float _41 = saturate(_40);
  float _42 = _41 * _34;
  float _43 = _37 * 10.0f;
  float _44 = 10.0f - _43;
  float _45 = min(_43, _44);
  float _46 = saturate(_45);
  float _47 = _46 * _35;
  float _48 = _42 + TEXCOORD0_centroid.x;
  float _49 = _47 + TEXCOORD0_centroid.y;
  float4 _50 = t8.SampleLevel(s2_space2, float2(_48, _49), 0.0f);
  float _52 = _50.w * _42;
  float _53 = _50.w * _47;
  float _54 = 1.0f - _27.y;
  float _55 = saturate(_54);
  float _56 = _52 * _55;
  float _57 = _53 * _55;
  float _58 = _56 + TEXCOORD0_centroid.x;
  float _59 = _57 + TEXCOORD0_centroid.y;
  float4 _60 = t8.SampleLevel(s2_space2, float2(_58, _59), 0.0f);
  bool _62 = (_60.y > 0.0f);
  float _63 = select(_62, TEXCOORD0_centroid.x, _58);
  float _64 = select(_62, TEXCOORD0_centroid.y, _59);
  float4 _65 = t1.SampleLevel(s4_space2, float2(_63, _64), 0.0f);
  float _69 = max(_65.x, 0.0f);
  float _70 = max(_65.y, 0.0f);
  float _71 = max(_65.z, 0.0f);
  float _72 = min(_69, 65000.0f);
  float _73 = min(_70, 65000.0f);
  float _74 = min(_71, 65000.0f);
  float4 _75 = t4.SampleLevel(s2_space2, float2(_63, _64), 0.0f);
  float _80 = max(_75.x, 0.0f);
  float _81 = max(_75.y, 0.0f);
  float _82 = max(_75.z, 0.0f);
  float _83 = max(_75.w, 0.0f);
  float _84 = min(_80, 5000.0f);
  float _85 = min(_81, 5000.0f);
  float _86 = min(_82, 5000.0f);
  float _87 = min(_83, 5000.0f);
  float _90 = _25.x * cb0_028z;
  float _91 = _90 + cb0_028x;
  float _92 = cb2_027w / _91;
  float _93 = 1.0f - _92;
  float _94 = abs(_93);
  float _96 = cb2_027y * _94;
  float _98 = _96 - cb2_027z;
  float _99 = saturate(_98);
  float _100 = max(_99, _87);
  float _101 = saturate(_100);
  float4 _102 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _106 = _84 - _72;
  float _107 = _85 - _73;
  float _108 = _86 - _74;
  float _109 = _101 * _106;
  float _110 = _101 * _107;
  float _111 = _101 * _108;
  float _112 = _109 + _72;
  float _113 = _110 + _73;
  float _114 = _111 + _74;
  float _115 = dot(float3(_112, _113, _114), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _119 = t0[0].SExposureData_020;
  float _121 = t0[0].SExposureData_004;
  float _123 = cb2_018x * 0.5f;
  float _124 = _123 * cb2_018y;
  float _125 = _121.x - _124;
  float _126 = cb2_018y * cb2_018x;
  float _127 = 1.0f / _126;
  float _128 = _125 * _127;
  float _129 = _115 / _119.x;
  float _130 = _129 * 5464.01611328125f;
  float _131 = _130 + 9.99999993922529e-09f;
  float _132 = log2(_131);
  float _133 = _132 - _125;
  float _134 = _133 * _127;
  float _135 = saturate(_134);
  float2 _136 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _135), 0.0f);
  float _139 = max(_136.y, 1.0000000116860974e-07f);
  float _140 = _136.x / _139;
  float _141 = _140 + _128;
  float _142 = _141 / _127;
  float _143 = _142 - _121.x;
  float _144 = -0.0f - _143;
  float _146 = _144 - cb2_027x;
  float _147 = max(0.0f, _146);
  float _150 = cb2_026z * _147;
  float _151 = _143 - cb2_027x;
  float _152 = max(0.0f, _151);
  float _154 = cb2_026w * _152;
  bool _155 = (_143 < 0.0f);
  float _156 = select(_155, _150, _154);
  float _157 = exp2(_156);
  float _158 = _157 * _112;
  float _159 = _157 * _113;
  float _160 = _157 * _114;
  float _165 = cb2_024y * _102.x;
  float _166 = cb2_024z * _102.y;
  float _167 = cb2_024w * _102.z;
  float _168 = _165 + _158;
  float _169 = _166 + _159;
  float _170 = _167 + _160;
  float _175 = _168 * cb2_025x;
  float _176 = _169 * cb2_025y;
  float _177 = _170 * cb2_025z;
  float _178 = dot(float3(_175, _176, _177), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _179 = t0[0].SExposureData_012;
  float _181 = _178 * 5464.01611328125f;
  float _182 = _181 * _179.x;
  float _183 = _182 + 9.99999993922529e-09f;
  float _184 = log2(_183);
  float _185 = _184 + 16.929765701293945f;
  float _186 = _185 * 0.05734497308731079f;
  float _187 = saturate(_186);
  float _188 = _187 * _187;
  float _189 = _187 * 2.0f;
  float _190 = 3.0f - _189;
  float _191 = _188 * _190;
  float _192 = _176 * 0.8450999855995178f;
  float _193 = _177 * 0.14589999616146088f;
  float _194 = _192 + _193;
  float _195 = _194 * 2.4890189170837402f;
  float _196 = _194 * 0.3754962384700775f;
  float _197 = _194 * 2.811495304107666f;
  float _198 = _194 * 5.519708156585693f;
  float _199 = _178 - _195;
  float _200 = _191 * _199;
  float _201 = _200 + _195;
  float _202 = _191 * 0.5f;
  float _203 = _202 + 0.5f;
  float _204 = _203 * _199;
  float _205 = _204 + _195;
  float _206 = _175 - _196;
  float _207 = _176 - _197;
  float _208 = _177 - _198;
  float _209 = _203 * _206;
  float _210 = _203 * _207;
  float _211 = _203 * _208;
  float _212 = _209 + _196;
  float _213 = _210 + _197;
  float _214 = _211 + _198;
  float _215 = 1.0f / _205;
  float _216 = _201 * _215;
  float _217 = _216 * _212;
  float _218 = _216 * _213;
  float _219 = _216 * _214;
  float _223 = cb2_020x * TEXCOORD0_centroid.x;
  float _224 = cb2_020y * TEXCOORD0_centroid.y;
  float _227 = _223 + cb2_020z;
  float _228 = _224 + cb2_020w;
  float _231 = dot(float2(_227, _228), float2(_227, _228));
  float _232 = 1.0f - _231;
  float _233 = saturate(_232);
  float _234 = log2(_233);
  float _235 = _234 * cb2_021w;
  float _236 = exp2(_235);
  float _240 = _217 - cb2_021x;
  float _241 = _218 - cb2_021y;
  float _242 = _219 - cb2_021z;
  float _243 = _240 * _236;
  float _244 = _241 * _236;
  float _245 = _242 * _236;
  float _246 = _243 + cb2_021x;
  float _247 = _244 + cb2_021y;
  float _248 = _245 + cb2_021z;
  float _249 = t0[0].SExposureData_000;
  float _251 = max(_119.x, 0.0010000000474974513f);
  float _252 = 1.0f / _251;
  float _253 = _252 * _249.x;
  bool _256 = ((uint)(cb2_069y) == 0);
  float _262;
  float _263;
  float _264;
  float _318;
  float _319;
  float _320;
  float _366;
  float _367;
  float _368;
  float _413;
  float _414;
  float _415;
  float _416;
  float _465;
  float _466;
  float _467;
  float _468;
  float _493;
  float _494;
  float _495;
  float _645;
  float _682;
  float _683;
  float _684;
  float _713;
  float _714;
  float _715;
  float _796;
  float _797;
  float _798;
  float _804;
  float _805;
  float _806;
  float _820;
  float _821;
  float _822;
  float _847;
  float _859;
  float _887;
  float _899;
  float _911;
  float _912;
  float _913;
  float _940;
  float _941;
  float _942;
  if (!_256) {
    float _258 = _253 * _246;
    float _259 = _253 * _247;
    float _260 = _253 * _248;
    _262 = _258;
    _263 = _259;
    _264 = _260;
  } else {
    _262 = _246;
    _263 = _247;
    _264 = _248;
  }
  float _265 = _262 * 0.6130970120429993f;
  float _266 = mad(0.33952298760414124f, _263, _265);
  float _267 = mad(0.04737899824976921f, _264, _266);
  float _268 = _262 * 0.07019399851560593f;
  float _269 = mad(0.9163540005683899f, _263, _268);
  float _270 = mad(0.013451999984681606f, _264, _269);
  float _271 = _262 * 0.02061600051820278f;
  float _272 = mad(0.10956999659538269f, _263, _271);
  float _273 = mad(0.8698149919509888f, _264, _272);
  float _274 = log2(_267);
  float _275 = log2(_270);
  float _276 = log2(_273);
  float _277 = _274 * 0.04211956635117531f;
  float _278 = _275 * 0.04211956635117531f;
  float _279 = _276 * 0.04211956635117531f;
  float _280 = _277 + 0.6252607107162476f;
  float _281 = _278 + 0.6252607107162476f;
  float _282 = _279 + 0.6252607107162476f;
  float4 _283 = t6.SampleLevel(s2_space2, float3(_280, _281, _282), 0.0f);
  bool _289 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_289 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _293 = cb2_017x * _283.x;
    float _294 = cb2_017x * _283.y;
    float _295 = cb2_017x * _283.z;
    float _297 = _293 + cb2_017y;
    float _298 = _294 + cb2_017y;
    float _299 = _295 + cb2_017y;
    float _300 = exp2(_297);
    float _301 = exp2(_298);
    float _302 = exp2(_299);
    float _303 = _300 + 1.0f;
    float _304 = _301 + 1.0f;
    float _305 = _302 + 1.0f;
    float _306 = 1.0f / _303;
    float _307 = 1.0f / _304;
    float _308 = 1.0f / _305;
    float _310 = cb2_017z * _306;
    float _311 = cb2_017z * _307;
    float _312 = cb2_017z * _308;
    float _314 = _310 + cb2_017w;
    float _315 = _311 + cb2_017w;
    float _316 = _312 + cb2_017w;
    _318 = _314;
    _319 = _315;
    _320 = _316;
  } else {
    _318 = _283.x;
    _319 = _283.y;
    _320 = _283.z;
  }
  float _321 = _318 * 23.0f;
  float _322 = _321 + -14.473931312561035f;
  float _323 = exp2(_322);
  float _324 = _319 * 23.0f;
  float _325 = _324 + -14.473931312561035f;
  float _326 = exp2(_325);
  float _327 = _320 * 23.0f;
  float _328 = _327 + -14.473931312561035f;
  float _329 = exp2(_328);
  float _334 = cb2_004x * TEXCOORD0_centroid.x;
  float _335 = cb2_004y * TEXCOORD0_centroid.y;
  float _338 = _334 + cb2_004z;
  float _339 = _335 + cb2_004w;
  float4 _345 = t7.Sample(s2_space2, float2(_338, _339));
  float _350 = _345.x * cb2_003x;
  float _351 = _345.y * cb2_003y;
  float _352 = _345.z * cb2_003z;
  float _353 = _345.w * cb2_003w;
  float _356 = _353 + cb2_026y;
  float _357 = saturate(_356);
  bool _360 = ((uint)(cb2_069y) == 0);
  if (!_360) {
    float _362 = _350 * _253;
    float _363 = _351 * _253;
    float _364 = _352 * _253;
    _366 = _362;
    _367 = _363;
    _368 = _364;
  } else {
    _366 = _350;
    _367 = _351;
    _368 = _352;
  }
  bool _371 = ((uint)(cb2_028x) == 2);
  bool _372 = ((uint)(cb2_028x) == 3);
  int _373 = (uint)(cb2_028x) & -2;
  bool _374 = (_373 == 2);
  bool _375 = ((uint)(cb2_028x) == 6);
  bool _376 = _374 || _375;
  if (_376) {
    float _378 = _366 * _357;
    float _379 = _367 * _357;
    float _380 = _368 * _357;
    float _381 = _357 * _357;
    _413 = _378;
    _414 = _379;
    _415 = _380;
    _416 = _381;
  } else {
    bool _383 = ((uint)(cb2_028x) == 4);
    if (_383) {
      float _385 = _366 + -1.0f;
      float _386 = _367 + -1.0f;
      float _387 = _368 + -1.0f;
      float _388 = _357 + -1.0f;
      float _389 = _385 * _357;
      float _390 = _386 * _357;
      float _391 = _387 * _357;
      float _392 = _388 * _357;
      float _393 = _389 + 1.0f;
      float _394 = _390 + 1.0f;
      float _395 = _391 + 1.0f;
      float _396 = _392 + 1.0f;
      _413 = _393;
      _414 = _394;
      _415 = _395;
      _416 = _396;
    } else {
      bool _398 = ((uint)(cb2_028x) == 5);
      if (_398) {
        float _400 = _366 + -0.5f;
        float _401 = _367 + -0.5f;
        float _402 = _368 + -0.5f;
        float _403 = _357 + -0.5f;
        float _404 = _400 * _357;
        float _405 = _401 * _357;
        float _406 = _402 * _357;
        float _407 = _403 * _357;
        float _408 = _404 + 0.5f;
        float _409 = _405 + 0.5f;
        float _410 = _406 + 0.5f;
        float _411 = _407 + 0.5f;
        _413 = _408;
        _414 = _409;
        _415 = _410;
        _416 = _411;
      } else {
        _413 = _366;
        _414 = _367;
        _415 = _368;
        _416 = _357;
      }
    }
  }
  if (_371) {
    float _418 = _413 + _323;
    float _419 = _414 + _326;
    float _420 = _415 + _329;
    _465 = _418;
    _466 = _419;
    _467 = _420;
    _468 = cb2_025w;
  } else {
    if (_372) {
      float _423 = 1.0f - _413;
      float _424 = 1.0f - _414;
      float _425 = 1.0f - _415;
      float _426 = _423 * _323;
      float _427 = _424 * _326;
      float _428 = _425 * _329;
      float _429 = _426 + _413;
      float _430 = _427 + _414;
      float _431 = _428 + _415;
      _465 = _429;
      _466 = _430;
      _467 = _431;
      _468 = cb2_025w;
    } else {
      bool _433 = ((uint)(cb2_028x) == 4);
      if (_433) {
        float _435 = _413 * _323;
        float _436 = _414 * _326;
        float _437 = _415 * _329;
        _465 = _435;
        _466 = _436;
        _467 = _437;
        _468 = cb2_025w;
      } else {
        bool _439 = ((uint)(cb2_028x) == 5);
        if (_439) {
          float _441 = _323 * 2.0f;
          float _442 = _441 * _413;
          float _443 = _326 * 2.0f;
          float _444 = _443 * _414;
          float _445 = _329 * 2.0f;
          float _446 = _445 * _415;
          _465 = _442;
          _466 = _444;
          _467 = _446;
          _468 = cb2_025w;
        } else {
          if (_375) {
            float _449 = _323 - _413;
            float _450 = _326 - _414;
            float _451 = _329 - _415;
            _465 = _449;
            _466 = _450;
            _467 = _451;
            _468 = cb2_025w;
          } else {
            float _453 = _413 - _323;
            float _454 = _414 - _326;
            float _455 = _415 - _329;
            float _456 = _416 * _453;
            float _457 = _416 * _454;
            float _458 = _416 * _455;
            float _459 = _456 + _323;
            float _460 = _457 + _326;
            float _461 = _458 + _329;
            float _462 = 1.0f - _416;
            float _463 = _462 * cb2_025w;
            _465 = _459;
            _466 = _460;
            _467 = _461;
            _468 = _463;
          }
        }
      }
    }
  }
  float _474 = cb2_016x - _465;
  float _475 = cb2_016y - _466;
  float _476 = cb2_016z - _467;
  float _477 = _474 * cb2_016w;
  float _478 = _475 * cb2_016w;
  float _479 = _476 * cb2_016w;
  float _480 = _477 + _465;
  float _481 = _478 + _466;
  float _482 = _479 + _467;
  bool _485 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_485 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _489 = cb2_024x * _480;
    float _490 = cb2_024x * _481;
    float _491 = cb2_024x * _482;
    _493 = _489;
    _494 = _490;
    _495 = _491;
  } else {
    _493 = _480;
    _494 = _481;
    _495 = _482;
  }
  float _498 = _493 * 0.9708889722824097f;
  float _499 = mad(0.026962999254465103f, _494, _498);
  float _500 = mad(0.002148000057786703f, _495, _499);
  float _501 = _493 * 0.01088900025933981f;
  float _502 = mad(0.9869629740715027f, _494, _501);
  float _503 = mad(0.002148000057786703f, _495, _502);
  float _504 = mad(0.026962999254465103f, _494, _501);
  float _505 = mad(0.9621480107307434f, _495, _504);
  float _506 = max(_500, 0.0f);
  float _507 = max(_503, 0.0f);
  float _508 = max(_505, 0.0f);
  float _509 = min(_506, cb2_095y);
  float _510 = min(_507, cb2_095y);
  float _511 = min(_508, cb2_095y);
  bool _514 = ((uint)(cb2_095x) == 0);
  bool _517 = ((uint)(cb2_094w) == 0);
  bool _519 = ((uint)(cb2_094z) == 0);
  bool _521 = ((uint)(cb2_094y) != 0);
  bool _523 = ((uint)(cb2_094x) == 0);
  bool _525 = ((uint)(cb2_069z) != 0);
  float _572 = asfloat((uint)(cb2_075y));
  float _573 = asfloat((uint)(cb2_075z));
  float _574 = asfloat((uint)(cb2_075w));
  float _575 = asfloat((uint)(cb2_074z));
  float _576 = asfloat((uint)(cb2_074w));
  float _577 = asfloat((uint)(cb2_075x));
  float _578 = asfloat((uint)(cb2_073w));
  float _579 = asfloat((uint)(cb2_074x));
  float _580 = asfloat((uint)(cb2_074y));
  float _581 = asfloat((uint)(cb2_077x));
  float _582 = asfloat((uint)(cb2_077y));
  float _583 = asfloat((uint)(cb2_079x));
  float _584 = asfloat((uint)(cb2_079y));
  float _585 = asfloat((uint)(cb2_079z));
  float _586 = asfloat((uint)(cb2_078y));
  float _587 = asfloat((uint)(cb2_078z));
  float _588 = asfloat((uint)(cb2_078w));
  float _589 = asfloat((uint)(cb2_077z));
  float _590 = asfloat((uint)(cb2_077w));
  float _591 = asfloat((uint)(cb2_078x));
  float _592 = asfloat((uint)(cb2_072y));
  float _593 = asfloat((uint)(cb2_072z));
  float _594 = asfloat((uint)(cb2_072w));
  float _595 = asfloat((uint)(cb2_071x));
  float _596 = asfloat((uint)(cb2_071y));
  float _597 = asfloat((uint)(cb2_076x));
  float _598 = asfloat((uint)(cb2_070w));
  float _599 = asfloat((uint)(cb2_070x));
  float _600 = asfloat((uint)(cb2_070y));
  float _601 = asfloat((uint)(cb2_070z));
  float _602 = asfloat((uint)(cb2_073x));
  float _603 = asfloat((uint)(cb2_073y));
  float _604 = asfloat((uint)(cb2_073z));
  float _605 = asfloat((uint)(cb2_071z));
  float _606 = asfloat((uint)(cb2_071w));
  float _607 = asfloat((uint)(cb2_072x));
  float _608 = max(_510, _511);
  float _609 = max(_509, _608);
  float _610 = 1.0f / _609;
  float _611 = _610 * _509;
  float _612 = _610 * _510;
  float _613 = _610 * _511;
  float _614 = abs(_611);
  float _615 = log2(_614);
  float _616 = _615 * _599;
  float _617 = exp2(_616);
  float _618 = abs(_612);
  float _619 = log2(_618);
  float _620 = _619 * _600;
  float _621 = exp2(_620);
  float _622 = abs(_613);
  float _623 = log2(_622);
  float _624 = _623 * _601;
  float _625 = exp2(_624);
  if (_521) {
    float _628 = asfloat((uint)(cb2_076w));
    float _630 = asfloat((uint)(cb2_076z));
    float _632 = asfloat((uint)(cb2_076y));
    float _633 = _630 * _510;
    float _634 = _632 * _509;
    float _635 = _628 * _511;
    float _636 = _634 + _635;
    float _637 = _636 + _633;
    _645 = _637;
  } else {
    float _639 = _606 * _510;
    float _640 = _605 * _509;
    float _641 = _607 * _511;
    float _642 = _639 + _640;
    float _643 = _642 + _641;
    _645 = _643;
  }
  float _646 = abs(_645);
  float _647 = log2(_646);
  float _648 = _647 * _598;
  float _649 = exp2(_648);
  float _650 = log2(_649);
  float _651 = _650 * _597;
  float _652 = exp2(_651);
  float _653 = select(_525, _652, _649);
  float _654 = _653 * _595;
  float _655 = _654 + _596;
  float _656 = 1.0f / _655;
  float _657 = _656 * _649;
  if (_521) {
    if (!_523) {
      float _660 = _617 * _589;
      float _661 = _621 * _590;
      float _662 = _625 * _591;
      float _663 = _661 + _660;
      float _664 = _663 + _662;
      float _665 = _621 * _587;
      float _666 = _617 * _586;
      float _667 = _625 * _588;
      float _668 = _665 + _666;
      float _669 = _668 + _667;
      float _670 = _625 * _585;
      float _671 = _621 * _584;
      float _672 = _617 * _583;
      float _673 = _671 + _672;
      float _674 = _673 + _670;
      float _675 = max(_669, _674);
      float _676 = max(_664, _675);
      float _677 = 1.0f / _676;
      float _678 = _677 * _664;
      float _679 = _677 * _669;
      float _680 = _677 * _674;
      _682 = _678;
      _683 = _679;
      _684 = _680;
    } else {
      _682 = _617;
      _683 = _621;
      _684 = _625;
    }
    float _685 = _682 * _582;
    float _686 = exp2(_685);
    float _687 = _686 * _581;
    float _688 = saturate(_687);
    float _689 = _682 * _581;
    float _690 = _682 - _689;
    float _691 = saturate(_690);
    float _692 = max(_581, _691);
    float _693 = min(_692, _688);
    float _694 = _683 * _582;
    float _695 = exp2(_694);
    float _696 = _695 * _581;
    float _697 = saturate(_696);
    float _698 = _683 * _581;
    float _699 = _683 - _698;
    float _700 = saturate(_699);
    float _701 = max(_581, _700);
    float _702 = min(_701, _697);
    float _703 = _684 * _582;
    float _704 = exp2(_703);
    float _705 = _704 * _581;
    float _706 = saturate(_705);
    float _707 = _684 * _581;
    float _708 = _684 - _707;
    float _709 = saturate(_708);
    float _710 = max(_581, _709);
    float _711 = min(_710, _706);
    _713 = _693;
    _714 = _702;
    _715 = _711;
  } else {
    _713 = _617;
    _714 = _621;
    _715 = _625;
  }
  float _716 = _713 * _605;
  float _717 = _714 * _606;
  float _718 = _717 + _716;
  float _719 = _715 * _607;
  float _720 = _718 + _719;
  float _721 = 1.0f / _720;
  float _722 = _721 * _657;
  float _723 = saturate(_722);
  float _724 = _723 * _713;
  float _725 = saturate(_724);
  float _726 = _723 * _714;
  float _727 = saturate(_726);
  float _728 = _723 * _715;
  float _729 = saturate(_728);
  float _730 = _725 * _592;
  float _731 = _592 - _730;
  float _732 = _727 * _593;
  float _733 = _593 - _732;
  float _734 = _729 * _594;
  float _735 = _594 - _734;
  float _736 = _729 * _607;
  float _737 = _725 * _605;
  float _738 = _727 * _606;
  float _739 = _657 - _737;
  float _740 = _739 - _738;
  float _741 = _740 - _736;
  float _742 = saturate(_741);
  float _743 = _733 * _606;
  float _744 = _731 * _605;
  float _745 = _735 * _607;
  float _746 = _743 + _744;
  float _747 = _746 + _745;
  float _748 = 1.0f / _747;
  float _749 = _748 * _742;
  float _750 = _749 * _731;
  float _751 = _750 + _725;
  float _752 = saturate(_751);
  float _753 = _749 * _733;
  float _754 = _753 + _727;
  float _755 = saturate(_754);
  float _756 = _749 * _735;
  float _757 = _756 + _729;
  float _758 = saturate(_757);
  float _759 = _758 * _607;
  float _760 = _752 * _605;
  float _761 = _755 * _606;
  float _762 = _657 - _760;
  float _763 = _762 - _761;
  float _764 = _763 - _759;
  float _765 = saturate(_764);
  float _766 = _765 * _602;
  float _767 = _766 + _752;
  float _768 = saturate(_767);
  float _769 = _765 * _603;
  float _770 = _769 + _755;
  float _771 = saturate(_770);
  float _772 = _765 * _604;
  float _773 = _772 + _758;
  float _774 = saturate(_773);
  if (!_519) {
    float _776 = _768 * _578;
    float _777 = _771 * _579;
    float _778 = _774 * _580;
    float _779 = _777 + _776;
    float _780 = _779 + _778;
    float _781 = _771 * _576;
    float _782 = _768 * _575;
    float _783 = _774 * _577;
    float _784 = _781 + _782;
    float _785 = _784 + _783;
    float _786 = _774 * _574;
    float _787 = _771 * _573;
    float _788 = _768 * _572;
    float _789 = _787 + _788;
    float _790 = _789 + _786;
    if (!_517) {
      float _792 = saturate(_780);
      float _793 = saturate(_785);
      float _794 = saturate(_790);
      _796 = _794;
      _797 = _793;
      _798 = _792;
    } else {
      _796 = _790;
      _797 = _785;
      _798 = _780;
    }
  } else {
    _796 = _774;
    _797 = _771;
    _798 = _768;
  }
  if (!_514) {
    float _800 = _798 * _578;
    float _801 = _797 * _578;
    float _802 = _796 * _578;
    _804 = _802;
    _805 = _801;
    _806 = _800;
  } else {
    _804 = _796;
    _805 = _797;
    _806 = _798;
  }
  if (_485) {
    float _810 = cb1_018z * 9.999999747378752e-05f;
    float _811 = _810 * _806;
    float _812 = _810 * _805;
    float _813 = _810 * _804;
    float _815 = 5000.0f / cb1_018y;
    float _816 = _811 * _815;
    float _817 = _812 * _815;
    float _818 = _813 * _815;
    _820 = _816;
    _821 = _817;
    _822 = _818;
  } else {
    _820 = _806;
    _821 = _805;
    _822 = _804;
  }
  float _823 = _820 * 1.6047500371932983f;
  float _824 = mad(-0.5310800075531006f, _821, _823);
  float _825 = mad(-0.07366999983787537f, _822, _824);
  float _826 = _820 * -0.10208000242710114f;
  float _827 = mad(1.1081299781799316f, _821, _826);
  float _828 = mad(-0.006049999967217445f, _822, _827);
  float _829 = _820 * -0.0032599999103695154f;
  float _830 = mad(-0.07275000214576721f, _821, _829);
  float _831 = mad(1.0760200023651123f, _822, _830);
  if (_485) {
    // float _833 = max(_825, 0.0f);
    // float _834 = max(_828, 0.0f);
    // float _835 = max(_831, 0.0f);
    // bool _836 = !(_833 >= 0.0030399328097701073f);
    // if (!_836) {
    //   float _838 = abs(_833);
    //   float _839 = log2(_838);
    //   float _840 = _839 * 0.4166666567325592f;
    //   float _841 = exp2(_840);
    //   float _842 = _841 * 1.0549999475479126f;
    //   float _843 = _842 + -0.054999999701976776f;
    //   _847 = _843;
    // } else {
    //   float _845 = _833 * 12.923210144042969f;
    //   _847 = _845;
    // }
    // bool _848 = !(_834 >= 0.0030399328097701073f);
    // if (!_848) {
    //   float _850 = abs(_834);
    //   float _851 = log2(_850);
    //   float _852 = _851 * 0.4166666567325592f;
    //   float _853 = exp2(_852);
    //   float _854 = _853 * 1.0549999475479126f;
    //   float _855 = _854 + -0.054999999701976776f;
    //   _859 = _855;
    // } else {
    //   float _857 = _834 * 12.923210144042969f;
    //   _859 = _857;
    // }
    // bool _860 = !(_835 >= 0.0030399328097701073f);
    // if (!_860) {
    //   float _862 = abs(_835);
    //   float _863 = log2(_862);
    //   float _864 = _863 * 0.4166666567325592f;
    //   float _865 = exp2(_864);
    //   float _866 = _865 * 1.0549999475479126f;
    //   float _867 = _866 + -0.054999999701976776f;
    //   _940 = _847;
    //   _941 = _859;
    //   _942 = _867;
    // } else {
    //   float _869 = _835 * 12.923210144042969f;
    //   _940 = _847;
    //   _941 = _859;
    //   _942 = _869;
    // }
    _940 = renodx::color::srgb::EncodeSafe(_825);
    _941 = renodx::color::srgb::EncodeSafe(_828);
    _942 = renodx::color::srgb::EncodeSafe(_831);

  } else {
    float _871 = saturate(_825);
    float _872 = saturate(_828);
    float _873 = saturate(_831);
    bool _874 = ((uint)(cb1_018w) == -2);
    if (!_874) {
      bool _876 = !(_871 >= 0.0030399328097701073f);
      if (!_876) {
        float _878 = abs(_871);
        float _879 = log2(_878);
        float _880 = _879 * 0.4166666567325592f;
        float _881 = exp2(_880);
        float _882 = _881 * 1.0549999475479126f;
        float _883 = _882 + -0.054999999701976776f;
        _887 = _883;
      } else {
        float _885 = _871 * 12.923210144042969f;
        _887 = _885;
      }
      bool _888 = !(_872 >= 0.0030399328097701073f);
      if (!_888) {
        float _890 = abs(_872);
        float _891 = log2(_890);
        float _892 = _891 * 0.4166666567325592f;
        float _893 = exp2(_892);
        float _894 = _893 * 1.0549999475479126f;
        float _895 = _894 + -0.054999999701976776f;
        _899 = _895;
      } else {
        float _897 = _872 * 12.923210144042969f;
        _899 = _897;
      }
      bool _900 = !(_873 >= 0.0030399328097701073f);
      if (!_900) {
        float _902 = abs(_873);
        float _903 = log2(_902);
        float _904 = _903 * 0.4166666567325592f;
        float _905 = exp2(_904);
        float _906 = _905 * 1.0549999475479126f;
        float _907 = _906 + -0.054999999701976776f;
        _911 = _887;
        _912 = _899;
        _913 = _907;
      } else {
        float _909 = _873 * 12.923210144042969f;
        _911 = _887;
        _912 = _899;
        _913 = _909;
      }
    } else {
      _911 = _871;
      _912 = _872;
      _913 = _873;
    }
    float _918 = abs(_911);
    float _919 = abs(_912);
    float _920 = abs(_913);
    float _921 = log2(_918);
    float _922 = log2(_919);
    float _923 = log2(_920);
    float _924 = _921 * cb2_000z;
    float _925 = _922 * cb2_000z;
    float _926 = _923 * cb2_000z;
    float _927 = exp2(_924);
    float _928 = exp2(_925);
    float _929 = exp2(_926);
    float _930 = _927 * cb2_000y;
    float _931 = _928 * cb2_000y;
    float _932 = _929 * cb2_000y;
    float _933 = _930 + cb2_000x;
    float _934 = _931 + cb2_000x;
    float _935 = _932 + cb2_000x;
    float _936 = saturate(_933);
    float _937 = saturate(_934);
    float _938 = saturate(_935);
    _940 = _936;
    _941 = _937;
    _942 = _938;
  }
  float _946 = cb2_023x * TEXCOORD0_centroid.x;
  float _947 = cb2_023y * TEXCOORD0_centroid.y;
  float _950 = _946 + cb2_023z;
  float _951 = _947 + cb2_023w;
  float4 _954 = t10.SampleLevel(s0_space2, float2(_950, _951), 0.0f);
  float _956 = _954.x + -0.5f;
  float _957 = _956 * cb2_022x;
  float _958 = _957 + 0.5f;
  float _959 = _958 * 2.0f;
  float _960 = _959 * _940;
  float _961 = _959 * _941;
  float _962 = _959 * _942;
  float _966 = float((uint)(cb2_019z));
  float _967 = float((uint)(cb2_019w));
  float _968 = _966 + SV_Position.x;
  float _969 = _967 + SV_Position.y;
  uint _970 = uint(_968);
  uint _971 = uint(_969);
  uint _974 = cb2_019x + -1u;
  uint _975 = cb2_019y + -1u;
  int _976 = _970 & _974;
  int _977 = _971 & _975;
  float4 _978 = t3.Load(int3(_976, _977, 0));
  float _982 = _978.x * 2.0f;
  float _983 = _978.y * 2.0f;
  float _984 = _978.z * 2.0f;
  float _985 = _982 + -1.0f;
  float _986 = _983 + -1.0f;
  float _987 = _984 + -1.0f;
  float _988 = _985 * _468;
  float _989 = _986 * _468;
  float _990 = _987 * _468;
  float _991 = _988 + _960;
  float _992 = _989 + _961;
  float _993 = _990 + _962;
  float _994 = dot(float3(_991, _992, _993), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _991;
  SV_Target.y = _992;
  SV_Target.z = _993;
  SV_Target.w = _994;
  SV_Target_1.x = _994;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

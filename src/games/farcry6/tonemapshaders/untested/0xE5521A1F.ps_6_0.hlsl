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
  float cb2_005x : packoffset(c005.x);
  float cb2_006x : packoffset(c006.x);
  float cb2_006y : packoffset(c006.y);
  float cb2_006z : packoffset(c006.z);
  float cb2_006w : packoffset(c006.w);
  float cb2_007x : packoffset(c007.x);
  float cb2_007y : packoffset(c007.y);
  float cb2_007z : packoffset(c007.z);
  float cb2_007w : packoffset(c007.w);
  float cb2_008x : packoffset(c008.x);
  float cb2_008y : packoffset(c008.y);
  float cb2_008z : packoffset(c008.z);
  float cb2_008w : packoffset(c008.w);
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
  float4 _22 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _26 = max(_22.x, 0.0f);
  float _27 = max(_22.y, 0.0f);
  float _28 = max(_22.z, 0.0f);
  float _29 = min(_26, 65000.0f);
  float _30 = min(_27, 65000.0f);
  float _31 = min(_28, 65000.0f);
  float4 _32 = t3.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _37 = max(_32.x, 0.0f);
  float _38 = max(_32.y, 0.0f);
  float _39 = max(_32.z, 0.0f);
  float _40 = max(_32.w, 0.0f);
  float _41 = min(_37, 5000.0f);
  float _42 = min(_38, 5000.0f);
  float _43 = min(_39, 5000.0f);
  float _44 = min(_40, 5000.0f);
  float _47 = _20.x * cb0_028z;
  float _48 = _47 + cb0_028x;
  float _49 = cb2_027w / _48;
  float _50 = 1.0f - _49;
  float _51 = abs(_50);
  float _53 = cb2_027y * _51;
  float _55 = _53 - cb2_027z;
  float _56 = saturate(_55);
  float _57 = max(_56, _44);
  float _58 = saturate(_57);
  float _62 = cb2_006x * TEXCOORD0_centroid.x;
  float _63 = cb2_006y * TEXCOORD0_centroid.y;
  float _66 = _62 + cb2_006z;
  float _67 = _63 + cb2_006w;
  float _71 = cb2_007x * TEXCOORD0_centroid.x;
  float _72 = cb2_007y * TEXCOORD0_centroid.y;
  float _75 = _71 + cb2_007z;
  float _76 = _72 + cb2_007w;
  float _80 = cb2_008x * TEXCOORD0_centroid.x;
  float _81 = cb2_008y * TEXCOORD0_centroid.y;
  float _84 = _80 + cb2_008z;
  float _85 = _81 + cb2_008w;
  float4 _86 = t1.SampleLevel(s2_space2, float2(_66, _67), 0.0f);
  float _88 = max(_86.x, 0.0f);
  float _89 = min(_88, 65000.0f);
  float4 _90 = t1.SampleLevel(s2_space2, float2(_75, _76), 0.0f);
  float _92 = max(_90.y, 0.0f);
  float _93 = min(_92, 65000.0f);
  float4 _94 = t1.SampleLevel(s2_space2, float2(_84, _85), 0.0f);
  float _96 = max(_94.z, 0.0f);
  float _97 = min(_96, 65000.0f);
  float4 _98 = t3.SampleLevel(s2_space2, float2(_66, _67), 0.0f);
  float _100 = max(_98.x, 0.0f);
  float _101 = min(_100, 5000.0f);
  float4 _102 = t3.SampleLevel(s2_space2, float2(_75, _76), 0.0f);
  float _104 = max(_102.y, 0.0f);
  float _105 = min(_104, 5000.0f);
  float4 _106 = t3.SampleLevel(s2_space2, float2(_84, _85), 0.0f);
  float _108 = max(_106.z, 0.0f);
  float _109 = min(_108, 5000.0f);
  float4 _110 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _116 = cb2_005x * _110.x;
  float _117 = cb2_005x * _110.y;
  float _118 = cb2_005x * _110.z;
  float _119 = _89 - _29;
  float _120 = _93 - _30;
  float _121 = _97 - _31;
  float _122 = _116 * _119;
  float _123 = _117 * _120;
  float _124 = _118 * _121;
  float _125 = _122 + _29;
  float _126 = _123 + _30;
  float _127 = _124 + _31;
  float _128 = _101 - _41;
  float _129 = _105 - _42;
  float _130 = _109 - _43;
  float _131 = _116 * _128;
  float _132 = _117 * _129;
  float _133 = _118 * _130;
  float _134 = _131 + _41;
  float _135 = _132 + _42;
  float _136 = _133 + _43;
  float4 _137 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _141 = _134 - _125;
  float _142 = _135 - _126;
  float _143 = _136 - _127;
  float _144 = _141 * _58;
  float _145 = _142 * _58;
  float _146 = _143 * _58;
  float _147 = _144 + _125;
  float _148 = _145 + _126;
  float _149 = _146 + _127;
  float _150 = dot(float3(_147, _148, _149), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _154 = t0[0].SExposureData_020;
  float _156 = t0[0].SExposureData_004;
  float _158 = cb2_018x * 0.5f;
  float _159 = _158 * cb2_018y;
  float _160 = _156.x - _159;
  float _161 = cb2_018y * cb2_018x;
  float _162 = 1.0f / _161;
  float _163 = _160 * _162;
  float _164 = _150 / _154.x;
  float _165 = _164 * 5464.01611328125f;
  float _166 = _165 + 9.99999993922529e-09f;
  float _167 = log2(_166);
  float _168 = _167 - _160;
  float _169 = _168 * _162;
  float _170 = saturate(_169);
  float2 _171 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _170), 0.0f);
  float _174 = max(_171.y, 1.0000000116860974e-07f);
  float _175 = _171.x / _174;
  float _176 = _175 + _163;
  float _177 = _176 / _162;
  float _178 = _177 - _156.x;
  float _179 = -0.0f - _178;
  float _181 = _179 - cb2_027x;
  float _182 = max(0.0f, _181);
  float _185 = cb2_026z * _182;
  float _186 = _178 - cb2_027x;
  float _187 = max(0.0f, _186);
  float _189 = cb2_026w * _187;
  bool _190 = (_178 < 0.0f);
  float _191 = select(_190, _185, _189);
  float _192 = exp2(_191);
  float _193 = _192 * _147;
  float _194 = _192 * _148;
  float _195 = _192 * _149;
  float _200 = cb2_024y * _137.x;
  float _201 = cb2_024z * _137.y;
  float _202 = cb2_024w * _137.z;
  float _203 = _200 + _193;
  float _204 = _201 + _194;
  float _205 = _202 + _195;
  float _210 = _203 * cb2_025x;
  float _211 = _204 * cb2_025y;
  float _212 = _205 * cb2_025z;
  float _213 = dot(float3(_210, _211, _212), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _214 = t0[0].SExposureData_012;
  float _216 = _213 * 5464.01611328125f;
  float _217 = _216 * _214.x;
  float _218 = _217 + 9.99999993922529e-09f;
  float _219 = log2(_218);
  float _220 = _219 + 16.929765701293945f;
  float _221 = _220 * 0.05734497308731079f;
  float _222 = saturate(_221);
  float _223 = _222 * _222;
  float _224 = _222 * 2.0f;
  float _225 = 3.0f - _224;
  float _226 = _223 * _225;
  float _227 = _211 * 0.8450999855995178f;
  float _228 = _212 * 0.14589999616146088f;
  float _229 = _227 + _228;
  float _230 = _229 * 2.4890189170837402f;
  float _231 = _229 * 0.3754962384700775f;
  float _232 = _229 * 2.811495304107666f;
  float _233 = _229 * 5.519708156585693f;
  float _234 = _213 - _230;
  float _235 = _226 * _234;
  float _236 = _235 + _230;
  float _237 = _226 * 0.5f;
  float _238 = _237 + 0.5f;
  float _239 = _238 * _234;
  float _240 = _239 + _230;
  float _241 = _210 - _231;
  float _242 = _211 - _232;
  float _243 = _212 - _233;
  float _244 = _238 * _241;
  float _245 = _238 * _242;
  float _246 = _238 * _243;
  float _247 = _244 + _231;
  float _248 = _245 + _232;
  float _249 = _246 + _233;
  float _250 = 1.0f / _240;
  float _251 = _236 * _250;
  float _252 = _251 * _247;
  float _253 = _251 * _248;
  float _254 = _251 * _249;
  float _258 = cb2_020x * TEXCOORD0_centroid.x;
  float _259 = cb2_020y * TEXCOORD0_centroid.y;
  float _262 = _258 + cb2_020z;
  float _263 = _259 + cb2_020w;
  float _266 = dot(float2(_262, _263), float2(_262, _263));
  float _267 = 1.0f - _266;
  float _268 = saturate(_267);
  float _269 = log2(_268);
  float _270 = _269 * cb2_021w;
  float _271 = exp2(_270);
  float _275 = _252 - cb2_021x;
  float _276 = _253 - cb2_021y;
  float _277 = _254 - cb2_021z;
  float _278 = _275 * _271;
  float _279 = _276 * _271;
  float _280 = _277 * _271;
  float _281 = _278 + cb2_021x;
  float _282 = _279 + cb2_021y;
  float _283 = _280 + cb2_021z;
  float _284 = t0[0].SExposureData_000;
  float _286 = max(_154.x, 0.0010000000474974513f);
  float _287 = 1.0f / _286;
  float _288 = _287 * _284.x;
  bool _291 = ((uint)(cb2_069y) == 0);
  float _297;
  float _298;
  float _299;
  float _353;
  float _354;
  float _355;
  float _400;
  float _401;
  float _402;
  float _447;
  float _448;
  float _449;
  float _450;
  float _497;
  float _498;
  float _499;
  float _524;
  float _525;
  float _526;
  float _676;
  float _713;
  float _714;
  float _715;
  float _744;
  float _745;
  float _746;
  float _827;
  float _828;
  float _829;
  float _835;
  float _836;
  float _837;
  float _851;
  float _852;
  float _853;
  float _878;
  float _890;
  float _918;
  float _930;
  float _942;
  float _943;
  float _944;
  float _971;
  float _972;
  float _973;
  if (!_291) {
    float _293 = _288 * _281;
    float _294 = _288 * _282;
    float _295 = _288 * _283;
    _297 = _293;
    _298 = _294;
    _299 = _295;
  } else {
    _297 = _281;
    _298 = _282;
    _299 = _283;
  }
  float _300 = _297 * 0.6130970120429993f;
  float _301 = mad(0.33952298760414124f, _298, _300);
  float _302 = mad(0.04737899824976921f, _299, _301);
  float _303 = _297 * 0.07019399851560593f;
  float _304 = mad(0.9163540005683899f, _298, _303);
  float _305 = mad(0.013451999984681606f, _299, _304);
  float _306 = _297 * 0.02061600051820278f;
  float _307 = mad(0.10956999659538269f, _298, _306);
  float _308 = mad(0.8698149919509888f, _299, _307);
  float _309 = log2(_302);
  float _310 = log2(_305);
  float _311 = log2(_308);
  float _312 = _309 * 0.04211956635117531f;
  float _313 = _310 * 0.04211956635117531f;
  float _314 = _311 * 0.04211956635117531f;
  float _315 = _312 + 0.6252607107162476f;
  float _316 = _313 + 0.6252607107162476f;
  float _317 = _314 + 0.6252607107162476f;
  float4 _318 = t5.SampleLevel(s2_space2, float3(_315, _316, _317), 0.0f);
  bool _324 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_324 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _328 = cb2_017x * _318.x;
    float _329 = cb2_017x * _318.y;
    float _330 = cb2_017x * _318.z;
    float _332 = _328 + cb2_017y;
    float _333 = _329 + cb2_017y;
    float _334 = _330 + cb2_017y;
    float _335 = exp2(_332);
    float _336 = exp2(_333);
    float _337 = exp2(_334);
    float _338 = _335 + 1.0f;
    float _339 = _336 + 1.0f;
    float _340 = _337 + 1.0f;
    float _341 = 1.0f / _338;
    float _342 = 1.0f / _339;
    float _343 = 1.0f / _340;
    float _345 = cb2_017z * _341;
    float _346 = cb2_017z * _342;
    float _347 = cb2_017z * _343;
    float _349 = _345 + cb2_017w;
    float _350 = _346 + cb2_017w;
    float _351 = _347 + cb2_017w;
    _353 = _349;
    _354 = _350;
    _355 = _351;
  } else {
    _353 = _318.x;
    _354 = _318.y;
    _355 = _318.z;
  }
  float _356 = _353 * 23.0f;
  float _357 = _356 + -14.473931312561035f;
  float _358 = exp2(_357);
  float _359 = _354 * 23.0f;
  float _360 = _359 + -14.473931312561035f;
  float _361 = exp2(_360);
  float _362 = _355 * 23.0f;
  float _363 = _362 + -14.473931312561035f;
  float _364 = exp2(_363);
  float _368 = cb2_004x * TEXCOORD0_centroid.x;
  float _369 = cb2_004y * TEXCOORD0_centroid.y;
  float _372 = _368 + cb2_004z;
  float _373 = _369 + cb2_004w;
  float4 _379 = t7.Sample(s2_space2, float2(_372, _373));
  float _384 = _379.x * cb2_003x;
  float _385 = _379.y * cb2_003y;
  float _386 = _379.z * cb2_003z;
  float _387 = _379.w * cb2_003w;
  float _390 = _387 + cb2_026y;
  float _391 = saturate(_390);
  bool _394 = ((uint)(cb2_069y) == 0);
  if (!_394) {
    float _396 = _384 * _288;
    float _397 = _385 * _288;
    float _398 = _386 * _288;
    _400 = _396;
    _401 = _397;
    _402 = _398;
  } else {
    _400 = _384;
    _401 = _385;
    _402 = _386;
  }
  bool _405 = ((uint)(cb2_028x) == 2);
  bool _406 = ((uint)(cb2_028x) == 3);
  int _407 = (uint)(cb2_028x) & -2;
  bool _408 = (_407 == 2);
  bool _409 = ((uint)(cb2_028x) == 6);
  bool _410 = _408 || _409;
  if (_410) {
    float _412 = _400 * _391;
    float _413 = _401 * _391;
    float _414 = _402 * _391;
    float _415 = _391 * _391;
    _447 = _412;
    _448 = _413;
    _449 = _414;
    _450 = _415;
  } else {
    bool _417 = ((uint)(cb2_028x) == 4);
    if (_417) {
      float _419 = _400 + -1.0f;
      float _420 = _401 + -1.0f;
      float _421 = _402 + -1.0f;
      float _422 = _391 + -1.0f;
      float _423 = _419 * _391;
      float _424 = _420 * _391;
      float _425 = _421 * _391;
      float _426 = _422 * _391;
      float _427 = _423 + 1.0f;
      float _428 = _424 + 1.0f;
      float _429 = _425 + 1.0f;
      float _430 = _426 + 1.0f;
      _447 = _427;
      _448 = _428;
      _449 = _429;
      _450 = _430;
    } else {
      bool _432 = ((uint)(cb2_028x) == 5);
      if (_432) {
        float _434 = _400 + -0.5f;
        float _435 = _401 + -0.5f;
        float _436 = _402 + -0.5f;
        float _437 = _391 + -0.5f;
        float _438 = _434 * _391;
        float _439 = _435 * _391;
        float _440 = _436 * _391;
        float _441 = _437 * _391;
        float _442 = _438 + 0.5f;
        float _443 = _439 + 0.5f;
        float _444 = _440 + 0.5f;
        float _445 = _441 + 0.5f;
        _447 = _442;
        _448 = _443;
        _449 = _444;
        _450 = _445;
      } else {
        _447 = _400;
        _448 = _401;
        _449 = _402;
        _450 = _391;
      }
    }
  }
  if (_405) {
    float _452 = _447 + _358;
    float _453 = _448 + _361;
    float _454 = _449 + _364;
    _497 = _452;
    _498 = _453;
    _499 = _454;
  } else {
    if (_406) {
      float _457 = 1.0f - _447;
      float _458 = 1.0f - _448;
      float _459 = 1.0f - _449;
      float _460 = _457 * _358;
      float _461 = _458 * _361;
      float _462 = _459 * _364;
      float _463 = _460 + _447;
      float _464 = _461 + _448;
      float _465 = _462 + _449;
      _497 = _463;
      _498 = _464;
      _499 = _465;
    } else {
      bool _467 = ((uint)(cb2_028x) == 4);
      if (_467) {
        float _469 = _447 * _358;
        float _470 = _448 * _361;
        float _471 = _449 * _364;
        _497 = _469;
        _498 = _470;
        _499 = _471;
      } else {
        bool _473 = ((uint)(cb2_028x) == 5);
        if (_473) {
          float _475 = _358 * 2.0f;
          float _476 = _475 * _447;
          float _477 = _361 * 2.0f;
          float _478 = _477 * _448;
          float _479 = _364 * 2.0f;
          float _480 = _479 * _449;
          _497 = _476;
          _498 = _478;
          _499 = _480;
        } else {
          if (_409) {
            float _483 = _358 - _447;
            float _484 = _361 - _448;
            float _485 = _364 - _449;
            _497 = _483;
            _498 = _484;
            _499 = _485;
          } else {
            float _487 = _447 - _358;
            float _488 = _448 - _361;
            float _489 = _449 - _364;
            float _490 = _450 * _487;
            float _491 = _450 * _488;
            float _492 = _450 * _489;
            float _493 = _490 + _358;
            float _494 = _491 + _361;
            float _495 = _492 + _364;
            _497 = _493;
            _498 = _494;
            _499 = _495;
          }
        }
      }
    }
  }
  float _505 = cb2_016x - _497;
  float _506 = cb2_016y - _498;
  float _507 = cb2_016z - _499;
  float _508 = _505 * cb2_016w;
  float _509 = _506 * cb2_016w;
  float _510 = _507 * cb2_016w;
  float _511 = _508 + _497;
  float _512 = _509 + _498;
  float _513 = _510 + _499;
  bool _516 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_516 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _520 = cb2_024x * _511;
    float _521 = cb2_024x * _512;
    float _522 = cb2_024x * _513;
    _524 = _520;
    _525 = _521;
    _526 = _522;
  } else {
    _524 = _511;
    _525 = _512;
    _526 = _513;
  }
  float _529 = _524 * 0.9708889722824097f;
  float _530 = mad(0.026962999254465103f, _525, _529);
  float _531 = mad(0.002148000057786703f, _526, _530);
  float _532 = _524 * 0.01088900025933981f;
  float _533 = mad(0.9869629740715027f, _525, _532);
  float _534 = mad(0.002148000057786703f, _526, _533);
  float _535 = mad(0.026962999254465103f, _525, _532);
  float _536 = mad(0.9621480107307434f, _526, _535);
  float _537 = max(_531, 0.0f);
  float _538 = max(_534, 0.0f);
  float _539 = max(_536, 0.0f);
  float _540 = min(_537, cb2_095y);
  float _541 = min(_538, cb2_095y);
  float _542 = min(_539, cb2_095y);
  bool _545 = ((uint)(cb2_095x) == 0);
  bool _548 = ((uint)(cb2_094w) == 0);
  bool _550 = ((uint)(cb2_094z) == 0);
  bool _552 = ((uint)(cb2_094y) != 0);
  bool _554 = ((uint)(cb2_094x) == 0);
  bool _556 = ((uint)(cb2_069z) != 0);
  float _603 = asfloat((uint)(cb2_075y));
  float _604 = asfloat((uint)(cb2_075z));
  float _605 = asfloat((uint)(cb2_075w));
  float _606 = asfloat((uint)(cb2_074z));
  float _607 = asfloat((uint)(cb2_074w));
  float _608 = asfloat((uint)(cb2_075x));
  float _609 = asfloat((uint)(cb2_073w));
  float _610 = asfloat((uint)(cb2_074x));
  float _611 = asfloat((uint)(cb2_074y));
  float _612 = asfloat((uint)(cb2_077x));
  float _613 = asfloat((uint)(cb2_077y));
  float _614 = asfloat((uint)(cb2_079x));
  float _615 = asfloat((uint)(cb2_079y));
  float _616 = asfloat((uint)(cb2_079z));
  float _617 = asfloat((uint)(cb2_078y));
  float _618 = asfloat((uint)(cb2_078z));
  float _619 = asfloat((uint)(cb2_078w));
  float _620 = asfloat((uint)(cb2_077z));
  float _621 = asfloat((uint)(cb2_077w));
  float _622 = asfloat((uint)(cb2_078x));
  float _623 = asfloat((uint)(cb2_072y));
  float _624 = asfloat((uint)(cb2_072z));
  float _625 = asfloat((uint)(cb2_072w));
  float _626 = asfloat((uint)(cb2_071x));
  float _627 = asfloat((uint)(cb2_071y));
  float _628 = asfloat((uint)(cb2_076x));
  float _629 = asfloat((uint)(cb2_070w));
  float _630 = asfloat((uint)(cb2_070x));
  float _631 = asfloat((uint)(cb2_070y));
  float _632 = asfloat((uint)(cb2_070z));
  float _633 = asfloat((uint)(cb2_073x));
  float _634 = asfloat((uint)(cb2_073y));
  float _635 = asfloat((uint)(cb2_073z));
  float _636 = asfloat((uint)(cb2_071z));
  float _637 = asfloat((uint)(cb2_071w));
  float _638 = asfloat((uint)(cb2_072x));
  float _639 = max(_541, _542);
  float _640 = max(_540, _639);
  float _641 = 1.0f / _640;
  float _642 = _641 * _540;
  float _643 = _641 * _541;
  float _644 = _641 * _542;
  float _645 = abs(_642);
  float _646 = log2(_645);
  float _647 = _646 * _630;
  float _648 = exp2(_647);
  float _649 = abs(_643);
  float _650 = log2(_649);
  float _651 = _650 * _631;
  float _652 = exp2(_651);
  float _653 = abs(_644);
  float _654 = log2(_653);
  float _655 = _654 * _632;
  float _656 = exp2(_655);
  if (_552) {
    float _659 = asfloat((uint)(cb2_076w));
    float _661 = asfloat((uint)(cb2_076z));
    float _663 = asfloat((uint)(cb2_076y));
    float _664 = _661 * _541;
    float _665 = _663 * _540;
    float _666 = _659 * _542;
    float _667 = _665 + _666;
    float _668 = _667 + _664;
    _676 = _668;
  } else {
    float _670 = _637 * _541;
    float _671 = _636 * _540;
    float _672 = _638 * _542;
    float _673 = _670 + _671;
    float _674 = _673 + _672;
    _676 = _674;
  }
  float _677 = abs(_676);
  float _678 = log2(_677);
  float _679 = _678 * _629;
  float _680 = exp2(_679);
  float _681 = log2(_680);
  float _682 = _681 * _628;
  float _683 = exp2(_682);
  float _684 = select(_556, _683, _680);
  float _685 = _684 * _626;
  float _686 = _685 + _627;
  float _687 = 1.0f / _686;
  float _688 = _687 * _680;
  if (_552) {
    if (!_554) {
      float _691 = _648 * _620;
      float _692 = _652 * _621;
      float _693 = _656 * _622;
      float _694 = _692 + _691;
      float _695 = _694 + _693;
      float _696 = _652 * _618;
      float _697 = _648 * _617;
      float _698 = _656 * _619;
      float _699 = _696 + _697;
      float _700 = _699 + _698;
      float _701 = _656 * _616;
      float _702 = _652 * _615;
      float _703 = _648 * _614;
      float _704 = _702 + _703;
      float _705 = _704 + _701;
      float _706 = max(_700, _705);
      float _707 = max(_695, _706);
      float _708 = 1.0f / _707;
      float _709 = _708 * _695;
      float _710 = _708 * _700;
      float _711 = _708 * _705;
      _713 = _709;
      _714 = _710;
      _715 = _711;
    } else {
      _713 = _648;
      _714 = _652;
      _715 = _656;
    }
    float _716 = _713 * _613;
    float _717 = exp2(_716);
    float _718 = _717 * _612;
    float _719 = saturate(_718);
    float _720 = _713 * _612;
    float _721 = _713 - _720;
    float _722 = saturate(_721);
    float _723 = max(_612, _722);
    float _724 = min(_723, _719);
    float _725 = _714 * _613;
    float _726 = exp2(_725);
    float _727 = _726 * _612;
    float _728 = saturate(_727);
    float _729 = _714 * _612;
    float _730 = _714 - _729;
    float _731 = saturate(_730);
    float _732 = max(_612, _731);
    float _733 = min(_732, _728);
    float _734 = _715 * _613;
    float _735 = exp2(_734);
    float _736 = _735 * _612;
    float _737 = saturate(_736);
    float _738 = _715 * _612;
    float _739 = _715 - _738;
    float _740 = saturate(_739);
    float _741 = max(_612, _740);
    float _742 = min(_741, _737);
    _744 = _724;
    _745 = _733;
    _746 = _742;
  } else {
    _744 = _648;
    _745 = _652;
    _746 = _656;
  }
  float _747 = _744 * _636;
  float _748 = _745 * _637;
  float _749 = _748 + _747;
  float _750 = _746 * _638;
  float _751 = _749 + _750;
  float _752 = 1.0f / _751;
  float _753 = _752 * _688;
  float _754 = saturate(_753);
  float _755 = _754 * _744;
  float _756 = saturate(_755);
  float _757 = _754 * _745;
  float _758 = saturate(_757);
  float _759 = _754 * _746;
  float _760 = saturate(_759);
  float _761 = _756 * _623;
  float _762 = _623 - _761;
  float _763 = _758 * _624;
  float _764 = _624 - _763;
  float _765 = _760 * _625;
  float _766 = _625 - _765;
  float _767 = _760 * _638;
  float _768 = _756 * _636;
  float _769 = _758 * _637;
  float _770 = _688 - _768;
  float _771 = _770 - _769;
  float _772 = _771 - _767;
  float _773 = saturate(_772);
  float _774 = _764 * _637;
  float _775 = _762 * _636;
  float _776 = _766 * _638;
  float _777 = _774 + _775;
  float _778 = _777 + _776;
  float _779 = 1.0f / _778;
  float _780 = _779 * _773;
  float _781 = _780 * _762;
  float _782 = _781 + _756;
  float _783 = saturate(_782);
  float _784 = _780 * _764;
  float _785 = _784 + _758;
  float _786 = saturate(_785);
  float _787 = _780 * _766;
  float _788 = _787 + _760;
  float _789 = saturate(_788);
  float _790 = _789 * _638;
  float _791 = _783 * _636;
  float _792 = _786 * _637;
  float _793 = _688 - _791;
  float _794 = _793 - _792;
  float _795 = _794 - _790;
  float _796 = saturate(_795);
  float _797 = _796 * _633;
  float _798 = _797 + _783;
  float _799 = saturate(_798);
  float _800 = _796 * _634;
  float _801 = _800 + _786;
  float _802 = saturate(_801);
  float _803 = _796 * _635;
  float _804 = _803 + _789;
  float _805 = saturate(_804);
  if (!_550) {
    float _807 = _799 * _609;
    float _808 = _802 * _610;
    float _809 = _805 * _611;
    float _810 = _808 + _807;
    float _811 = _810 + _809;
    float _812 = _802 * _607;
    float _813 = _799 * _606;
    float _814 = _805 * _608;
    float _815 = _812 + _813;
    float _816 = _815 + _814;
    float _817 = _805 * _605;
    float _818 = _802 * _604;
    float _819 = _799 * _603;
    float _820 = _818 + _819;
    float _821 = _820 + _817;
    if (!_548) {
      float _823 = saturate(_811);
      float _824 = saturate(_816);
      float _825 = saturate(_821);
      _827 = _825;
      _828 = _824;
      _829 = _823;
    } else {
      _827 = _821;
      _828 = _816;
      _829 = _811;
    }
  } else {
    _827 = _805;
    _828 = _802;
    _829 = _799;
  }
  if (!_545) {
    float _831 = _829 * _609;
    float _832 = _828 * _609;
    float _833 = _827 * _609;
    _835 = _833;
    _836 = _832;
    _837 = _831;
  } else {
    _835 = _827;
    _836 = _828;
    _837 = _829;
  }
  if (_516) {
    float _841 = cb1_018z * 9.999999747378752e-05f;
    float _842 = _841 * _837;
    float _843 = _841 * _836;
    float _844 = _841 * _835;
    float _846 = 5000.0f / cb1_018y;
    float _847 = _842 * _846;
    float _848 = _843 * _846;
    float _849 = _844 * _846;
    _851 = _847;
    _852 = _848;
    _853 = _849;
  } else {
    _851 = _837;
    _852 = _836;
    _853 = _835;
  }
  float _854 = _851 * 1.6047500371932983f;
  float _855 = mad(-0.5310800075531006f, _852, _854);
  float _856 = mad(-0.07366999983787537f, _853, _855);
  float _857 = _851 * -0.10208000242710114f;
  float _858 = mad(1.1081299781799316f, _852, _857);
  float _859 = mad(-0.006049999967217445f, _853, _858);
  float _860 = _851 * -0.0032599999103695154f;
  float _861 = mad(-0.07275000214576721f, _852, _860);
  float _862 = mad(1.0760200023651123f, _853, _861);
  if (_516) {
    // float _864 = max(_856, 0.0f);
    // float _865 = max(_859, 0.0f);
    // float _866 = max(_862, 0.0f);
    // bool _867 = !(_864 >= 0.0030399328097701073f);
    // if (!_867) {
    //   float _869 = abs(_864);
    //   float _870 = log2(_869);
    //   float _871 = _870 * 0.4166666567325592f;
    //   float _872 = exp2(_871);
    //   float _873 = _872 * 1.0549999475479126f;
    //   float _874 = _873 + -0.054999999701976776f;
    //   _878 = _874;
    // } else {
    //   float _876 = _864 * 12.923210144042969f;
    //   _878 = _876;
    // }
    // bool _879 = !(_865 >= 0.0030399328097701073f);
    // if (!_879) {
    //   float _881 = abs(_865);
    //   float _882 = log2(_881);
    //   float _883 = _882 * 0.4166666567325592f;
    //   float _884 = exp2(_883);
    //   float _885 = _884 * 1.0549999475479126f;
    //   float _886 = _885 + -0.054999999701976776f;
    //   _890 = _886;
    // } else {
    //   float _888 = _865 * 12.923210144042969f;
    //   _890 = _888;
    // }
    // bool _891 = !(_866 >= 0.0030399328097701073f);
    // if (!_891) {
    //   float _893 = abs(_866);
    //   float _894 = log2(_893);
    //   float _895 = _894 * 0.4166666567325592f;
    //   float _896 = exp2(_895);
    //   float _897 = _896 * 1.0549999475479126f;
    //   float _898 = _897 + -0.054999999701976776f;
    //   _971 = _878;
    //   _972 = _890;
    //   _973 = _898;
    // } else {
    //   float _900 = _866 * 12.923210144042969f;
    //   _971 = _878;
    //   _972 = _890;
    //   _973 = _900;
    // }
    _971 = renodx::color::srgb::EncodeSafe(_856);
    _972 = renodx::color::srgb::EncodeSafe(_859);
    _973 = renodx::color::srgb::EncodeSafe(_862);

  } else {
    float _902 = saturate(_856);
    float _903 = saturate(_859);
    float _904 = saturate(_862);
    bool _905 = ((uint)(cb1_018w) == -2);
    if (!_905) {
      bool _907 = !(_902 >= 0.0030399328097701073f);
      if (!_907) {
        float _909 = abs(_902);
        float _910 = log2(_909);
        float _911 = _910 * 0.4166666567325592f;
        float _912 = exp2(_911);
        float _913 = _912 * 1.0549999475479126f;
        float _914 = _913 + -0.054999999701976776f;
        _918 = _914;
      } else {
        float _916 = _902 * 12.923210144042969f;
        _918 = _916;
      }
      bool _919 = !(_903 >= 0.0030399328097701073f);
      if (!_919) {
        float _921 = abs(_903);
        float _922 = log2(_921);
        float _923 = _922 * 0.4166666567325592f;
        float _924 = exp2(_923);
        float _925 = _924 * 1.0549999475479126f;
        float _926 = _925 + -0.054999999701976776f;
        _930 = _926;
      } else {
        float _928 = _903 * 12.923210144042969f;
        _930 = _928;
      }
      bool _931 = !(_904 >= 0.0030399328097701073f);
      if (!_931) {
        float _933 = abs(_904);
        float _934 = log2(_933);
        float _935 = _934 * 0.4166666567325592f;
        float _936 = exp2(_935);
        float _937 = _936 * 1.0549999475479126f;
        float _938 = _937 + -0.054999999701976776f;
        _942 = _918;
        _943 = _930;
        _944 = _938;
      } else {
        float _940 = _904 * 12.923210144042969f;
        _942 = _918;
        _943 = _930;
        _944 = _940;
      }
    } else {
      _942 = _902;
      _943 = _903;
      _944 = _904;
    }
    float _949 = abs(_942);
    float _950 = abs(_943);
    float _951 = abs(_944);
    float _952 = log2(_949);
    float _953 = log2(_950);
    float _954 = log2(_951);
    float _955 = _952 * cb2_000z;
    float _956 = _953 * cb2_000z;
    float _957 = _954 * cb2_000z;
    float _958 = exp2(_955);
    float _959 = exp2(_956);
    float _960 = exp2(_957);
    float _961 = _958 * cb2_000y;
    float _962 = _959 * cb2_000y;
    float _963 = _960 * cb2_000y;
    float _964 = _961 + cb2_000x;
    float _965 = _962 + cb2_000x;
    float _966 = _963 + cb2_000x;
    float _967 = saturate(_964);
    float _968 = saturate(_965);
    float _969 = saturate(_966);
    _971 = _967;
    _972 = _968;
    _973 = _969;
  }
  float _974 = dot(float3(_971, _972, _973), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _971;
  SV_Target.y = _972;
  SV_Target.z = _973;
  SV_Target.w = _974;
  SV_Target_1.x = _974;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

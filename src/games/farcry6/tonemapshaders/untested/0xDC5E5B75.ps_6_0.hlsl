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

Texture2D<float4> t8 : register(t8);

Texture3D<float2> t9 : register(t9);

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
  float _22 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _24 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _28 = _24.x * 6.283199787139893f;
  float _29 = cos(_28);
  float _30 = sin(_28);
  float _31 = _29 * _24.z;
  float _32 = _30 * _24.z;
  float _33 = _31 + TEXCOORD0_centroid.x;
  float _34 = _32 + TEXCOORD0_centroid.y;
  float _35 = _33 * 10.0f;
  float _36 = 10.0f - _35;
  float _37 = min(_35, _36);
  float _38 = saturate(_37);
  float _39 = _38 * _31;
  float _40 = _34 * 10.0f;
  float _41 = 10.0f - _40;
  float _42 = min(_40, _41);
  float _43 = saturate(_42);
  float _44 = _43 * _32;
  float _45 = _39 + TEXCOORD0_centroid.x;
  float _46 = _44 + TEXCOORD0_centroid.y;
  float4 _47 = t7.SampleLevel(s2_space2, float2(_45, _46), 0.0f);
  float _49 = _47.w * _39;
  float _50 = _47.w * _44;
  float _51 = 1.0f - _24.y;
  float _52 = saturate(_51);
  float _53 = _49 * _52;
  float _54 = _50 * _52;
  float _58 = cb2_015x * TEXCOORD0_centroid.x;
  float _59 = cb2_015y * TEXCOORD0_centroid.y;
  float _62 = _58 + cb2_015z;
  float _63 = _59 + cb2_015w;
  float4 _64 = t8.SampleLevel(s0_space2, float2(_62, _63), 0.0f);
  float _68 = saturate(_64.x);
  float _69 = saturate(_64.z);
  float _72 = cb2_026x * _69;
  float _73 = _68 * 6.283199787139893f;
  float _74 = cos(_73);
  float _75 = sin(_73);
  float _76 = _72 * _74;
  float _77 = _75 * _72;
  float _78 = 1.0f - _64.y;
  float _79 = saturate(_78);
  float _80 = _76 * _79;
  float _81 = _77 * _79;
  float _82 = _53 + TEXCOORD0_centroid.x;
  float _83 = _82 + _80;
  float _84 = _54 + TEXCOORD0_centroid.y;
  float _85 = _84 + _81;
  float4 _86 = t7.SampleLevel(s2_space2, float2(_83, _85), 0.0f);
  bool _88 = (_86.y > 0.0f);
  float _89 = select(_88, TEXCOORD0_centroid.x, _83);
  float _90 = select(_88, TEXCOORD0_centroid.y, _85);
  float4 _91 = t1.SampleLevel(s4_space2, float2(_89, _90), 0.0f);
  float _95 = max(_91.x, 0.0f);
  float _96 = max(_91.y, 0.0f);
  float _97 = max(_91.z, 0.0f);
  float _98 = min(_95, 65000.0f);
  float _99 = min(_96, 65000.0f);
  float _100 = min(_97, 65000.0f);
  float4 _101 = t3.SampleLevel(s2_space2, float2(_89, _90), 0.0f);
  float _106 = max(_101.x, 0.0f);
  float _107 = max(_101.y, 0.0f);
  float _108 = max(_101.z, 0.0f);
  float _109 = max(_101.w, 0.0f);
  float _110 = min(_106, 5000.0f);
  float _111 = min(_107, 5000.0f);
  float _112 = min(_108, 5000.0f);
  float _113 = min(_109, 5000.0f);
  float _116 = _22.x * cb0_028z;
  float _117 = _116 + cb0_028x;
  float _118 = cb2_027w / _117;
  float _119 = 1.0f - _118;
  float _120 = abs(_119);
  float _122 = cb2_027y * _120;
  float _124 = _122 - cb2_027z;
  float _125 = saturate(_124);
  float _126 = max(_125, _113);
  float _127 = saturate(_126);
  float4 _128 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _132 = _110 - _98;
  float _133 = _111 - _99;
  float _134 = _112 - _100;
  float _135 = _127 * _132;
  float _136 = _127 * _133;
  float _137 = _127 * _134;
  float _138 = _135 + _98;
  float _139 = _136 + _99;
  float _140 = _137 + _100;
  float _141 = dot(float3(_138, _139, _140), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _145 = t0[0].SExposureData_020;
  float _147 = t0[0].SExposureData_004;
  float _149 = cb2_018x * 0.5f;
  float _150 = _149 * cb2_018y;
  float _151 = _147.x - _150;
  float _152 = cb2_018y * cb2_018x;
  float _153 = 1.0f / _152;
  float _154 = _151 * _153;
  float _155 = _141 / _145.x;
  float _156 = _155 * 5464.01611328125f;
  float _157 = _156 + 9.99999993922529e-09f;
  float _158 = log2(_157);
  float _159 = _158 - _151;
  float _160 = _159 * _153;
  float _161 = saturate(_160);
  float2 _162 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _161), 0.0f);
  float _165 = max(_162.y, 1.0000000116860974e-07f);
  float _166 = _162.x / _165;
  float _167 = _166 + _154;
  float _168 = _167 / _153;
  float _169 = _168 - _147.x;
  float _170 = -0.0f - _169;
  float _172 = _170 - cb2_027x;
  float _173 = max(0.0f, _172);
  float _175 = cb2_026z * _173;
  float _176 = _169 - cb2_027x;
  float _177 = max(0.0f, _176);
  float _179 = cb2_026w * _177;
  bool _180 = (_169 < 0.0f);
  float _181 = select(_180, _175, _179);
  float _182 = exp2(_181);
  float _183 = _182 * _138;
  float _184 = _182 * _139;
  float _185 = _182 * _140;
  float _190 = cb2_024y * _128.x;
  float _191 = cb2_024z * _128.y;
  float _192 = cb2_024w * _128.z;
  float _193 = _190 + _183;
  float _194 = _191 + _184;
  float _195 = _192 + _185;
  float _200 = _193 * cb2_025x;
  float _201 = _194 * cb2_025y;
  float _202 = _195 * cb2_025z;
  float _203 = dot(float3(_200, _201, _202), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _204 = t0[0].SExposureData_012;
  float _206 = _203 * 5464.01611328125f;
  float _207 = _206 * _204.x;
  float _208 = _207 + 9.99999993922529e-09f;
  float _209 = log2(_208);
  float _210 = _209 + 16.929765701293945f;
  float _211 = _210 * 0.05734497308731079f;
  float _212 = saturate(_211);
  float _213 = _212 * _212;
  float _214 = _212 * 2.0f;
  float _215 = 3.0f - _214;
  float _216 = _213 * _215;
  float _217 = _201 * 0.8450999855995178f;
  float _218 = _202 * 0.14589999616146088f;
  float _219 = _217 + _218;
  float _220 = _219 * 2.4890189170837402f;
  float _221 = _219 * 0.3754962384700775f;
  float _222 = _219 * 2.811495304107666f;
  float _223 = _219 * 5.519708156585693f;
  float _224 = _203 - _220;
  float _225 = _216 * _224;
  float _226 = _225 + _220;
  float _227 = _216 * 0.5f;
  float _228 = _227 + 0.5f;
  float _229 = _228 * _224;
  float _230 = _229 + _220;
  float _231 = _200 - _221;
  float _232 = _201 - _222;
  float _233 = _202 - _223;
  float _234 = _228 * _231;
  float _235 = _228 * _232;
  float _236 = _228 * _233;
  float _237 = _234 + _221;
  float _238 = _235 + _222;
  float _239 = _236 + _223;
  float _240 = 1.0f / _230;
  float _241 = _226 * _240;
  float _242 = _241 * _237;
  float _243 = _241 * _238;
  float _244 = _241 * _239;
  float _248 = cb2_020x * TEXCOORD0_centroid.x;
  float _249 = cb2_020y * TEXCOORD0_centroid.y;
  float _252 = _248 + cb2_020z;
  float _253 = _249 + cb2_020w;
  float _256 = dot(float2(_252, _253), float2(_252, _253));
  float _257 = 1.0f - _256;
  float _258 = saturate(_257);
  float _259 = log2(_258);
  float _260 = _259 * cb2_021w;
  float _261 = exp2(_260);
  float _265 = _242 - cb2_021x;
  float _266 = _243 - cb2_021y;
  float _267 = _244 - cb2_021z;
  float _268 = _265 * _261;
  float _269 = _266 * _261;
  float _270 = _267 * _261;
  float _271 = _268 + cb2_021x;
  float _272 = _269 + cb2_021y;
  float _273 = _270 + cb2_021z;
  float _274 = t0[0].SExposureData_000;
  float _276 = max(_145.x, 0.0010000000474974513f);
  float _277 = 1.0f / _276;
  float _278 = _277 * _274.x;
  bool _281 = ((uint)(cb2_069y) == 0);
  float _287;
  float _288;
  float _289;
  float _343;
  float _344;
  float _345;
  float _390;
  float _391;
  float _392;
  float _437;
  float _438;
  float _439;
  float _440;
  float _487;
  float _488;
  float _489;
  float _514;
  float _515;
  float _516;
  float _666;
  float _703;
  float _704;
  float _705;
  float _734;
  float _735;
  float _736;
  float _817;
  float _818;
  float _819;
  float _825;
  float _826;
  float _827;
  float _841;
  float _842;
  float _843;
  float _868;
  float _880;
  float _908;
  float _920;
  float _932;
  float _933;
  float _934;
  float _961;
  float _962;
  float _963;
  if (!_281) {
    float _283 = _278 * _271;
    float _284 = _278 * _272;
    float _285 = _278 * _273;
    _287 = _283;
    _288 = _284;
    _289 = _285;
  } else {
    _287 = _271;
    _288 = _272;
    _289 = _273;
  }
  float _290 = _287 * 0.6130970120429993f;
  float _291 = mad(0.33952298760414124f, _288, _290);
  float _292 = mad(0.04737899824976921f, _289, _291);
  float _293 = _287 * 0.07019399851560593f;
  float _294 = mad(0.9163540005683899f, _288, _293);
  float _295 = mad(0.013451999984681606f, _289, _294);
  float _296 = _287 * 0.02061600051820278f;
  float _297 = mad(0.10956999659538269f, _288, _296);
  float _298 = mad(0.8698149919509888f, _289, _297);
  float _299 = log2(_292);
  float _300 = log2(_295);
  float _301 = log2(_298);
  float _302 = _299 * 0.04211956635117531f;
  float _303 = _300 * 0.04211956635117531f;
  float _304 = _301 * 0.04211956635117531f;
  float _305 = _302 + 0.6252607107162476f;
  float _306 = _303 + 0.6252607107162476f;
  float _307 = _304 + 0.6252607107162476f;
  float4 _308 = t5.SampleLevel(s2_space2, float3(_305, _306, _307), 0.0f);
  bool _314 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_314 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _318 = cb2_017x * _308.x;
    float _319 = cb2_017x * _308.y;
    float _320 = cb2_017x * _308.z;
    float _322 = _318 + cb2_017y;
    float _323 = _319 + cb2_017y;
    float _324 = _320 + cb2_017y;
    float _325 = exp2(_322);
    float _326 = exp2(_323);
    float _327 = exp2(_324);
    float _328 = _325 + 1.0f;
    float _329 = _326 + 1.0f;
    float _330 = _327 + 1.0f;
    float _331 = 1.0f / _328;
    float _332 = 1.0f / _329;
    float _333 = 1.0f / _330;
    float _335 = cb2_017z * _331;
    float _336 = cb2_017z * _332;
    float _337 = cb2_017z * _333;
    float _339 = _335 + cb2_017w;
    float _340 = _336 + cb2_017w;
    float _341 = _337 + cb2_017w;
    _343 = _339;
    _344 = _340;
    _345 = _341;
  } else {
    _343 = _308.x;
    _344 = _308.y;
    _345 = _308.z;
  }
  float _346 = _343 * 23.0f;
  float _347 = _346 + -14.473931312561035f;
  float _348 = exp2(_347);
  float _349 = _344 * 23.0f;
  float _350 = _349 + -14.473931312561035f;
  float _351 = exp2(_350);
  float _352 = _345 * 23.0f;
  float _353 = _352 + -14.473931312561035f;
  float _354 = exp2(_353);
  float _358 = cb2_004x * TEXCOORD0_centroid.x;
  float _359 = cb2_004y * TEXCOORD0_centroid.y;
  float _362 = _358 + cb2_004z;
  float _363 = _359 + cb2_004w;
  float4 _369 = t6.Sample(s2_space2, float2(_362, _363));
  float _374 = _369.x * cb2_003x;
  float _375 = _369.y * cb2_003y;
  float _376 = _369.z * cb2_003z;
  float _377 = _369.w * cb2_003w;
  float _380 = _377 + cb2_026y;
  float _381 = saturate(_380);
  bool _384 = ((uint)(cb2_069y) == 0);
  if (!_384) {
    float _386 = _374 * _278;
    float _387 = _375 * _278;
    float _388 = _376 * _278;
    _390 = _386;
    _391 = _387;
    _392 = _388;
  } else {
    _390 = _374;
    _391 = _375;
    _392 = _376;
  }
  bool _395 = ((uint)(cb2_028x) == 2);
  bool _396 = ((uint)(cb2_028x) == 3);
  int _397 = (uint)(cb2_028x) & -2;
  bool _398 = (_397 == 2);
  bool _399 = ((uint)(cb2_028x) == 6);
  bool _400 = _398 || _399;
  if (_400) {
    float _402 = _390 * _381;
    float _403 = _391 * _381;
    float _404 = _392 * _381;
    float _405 = _381 * _381;
    _437 = _402;
    _438 = _403;
    _439 = _404;
    _440 = _405;
  } else {
    bool _407 = ((uint)(cb2_028x) == 4);
    if (_407) {
      float _409 = _390 + -1.0f;
      float _410 = _391 + -1.0f;
      float _411 = _392 + -1.0f;
      float _412 = _381 + -1.0f;
      float _413 = _409 * _381;
      float _414 = _410 * _381;
      float _415 = _411 * _381;
      float _416 = _412 * _381;
      float _417 = _413 + 1.0f;
      float _418 = _414 + 1.0f;
      float _419 = _415 + 1.0f;
      float _420 = _416 + 1.0f;
      _437 = _417;
      _438 = _418;
      _439 = _419;
      _440 = _420;
    } else {
      bool _422 = ((uint)(cb2_028x) == 5);
      if (_422) {
        float _424 = _390 + -0.5f;
        float _425 = _391 + -0.5f;
        float _426 = _392 + -0.5f;
        float _427 = _381 + -0.5f;
        float _428 = _424 * _381;
        float _429 = _425 * _381;
        float _430 = _426 * _381;
        float _431 = _427 * _381;
        float _432 = _428 + 0.5f;
        float _433 = _429 + 0.5f;
        float _434 = _430 + 0.5f;
        float _435 = _431 + 0.5f;
        _437 = _432;
        _438 = _433;
        _439 = _434;
        _440 = _435;
      } else {
        _437 = _390;
        _438 = _391;
        _439 = _392;
        _440 = _381;
      }
    }
  }
  if (_395) {
    float _442 = _437 + _348;
    float _443 = _438 + _351;
    float _444 = _439 + _354;
    _487 = _442;
    _488 = _443;
    _489 = _444;
  } else {
    if (_396) {
      float _447 = 1.0f - _437;
      float _448 = 1.0f - _438;
      float _449 = 1.0f - _439;
      float _450 = _447 * _348;
      float _451 = _448 * _351;
      float _452 = _449 * _354;
      float _453 = _450 + _437;
      float _454 = _451 + _438;
      float _455 = _452 + _439;
      _487 = _453;
      _488 = _454;
      _489 = _455;
    } else {
      bool _457 = ((uint)(cb2_028x) == 4);
      if (_457) {
        float _459 = _437 * _348;
        float _460 = _438 * _351;
        float _461 = _439 * _354;
        _487 = _459;
        _488 = _460;
        _489 = _461;
      } else {
        bool _463 = ((uint)(cb2_028x) == 5);
        if (_463) {
          float _465 = _348 * 2.0f;
          float _466 = _465 * _437;
          float _467 = _351 * 2.0f;
          float _468 = _467 * _438;
          float _469 = _354 * 2.0f;
          float _470 = _469 * _439;
          _487 = _466;
          _488 = _468;
          _489 = _470;
        } else {
          if (_399) {
            float _473 = _348 - _437;
            float _474 = _351 - _438;
            float _475 = _354 - _439;
            _487 = _473;
            _488 = _474;
            _489 = _475;
          } else {
            float _477 = _437 - _348;
            float _478 = _438 - _351;
            float _479 = _439 - _354;
            float _480 = _440 * _477;
            float _481 = _440 * _478;
            float _482 = _440 * _479;
            float _483 = _480 + _348;
            float _484 = _481 + _351;
            float _485 = _482 + _354;
            _487 = _483;
            _488 = _484;
            _489 = _485;
          }
        }
      }
    }
  }
  float _495 = cb2_016x - _487;
  float _496 = cb2_016y - _488;
  float _497 = cb2_016z - _489;
  float _498 = _495 * cb2_016w;
  float _499 = _496 * cb2_016w;
  float _500 = _497 * cb2_016w;
  float _501 = _498 + _487;
  float _502 = _499 + _488;
  float _503 = _500 + _489;
  bool _506 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_506 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _510 = cb2_024x * _501;
    float _511 = cb2_024x * _502;
    float _512 = cb2_024x * _503;
    _514 = _510;
    _515 = _511;
    _516 = _512;
  } else {
    _514 = _501;
    _515 = _502;
    _516 = _503;
  }
  float _519 = _514 * 0.9708889722824097f;
  float _520 = mad(0.026962999254465103f, _515, _519);
  float _521 = mad(0.002148000057786703f, _516, _520);
  float _522 = _514 * 0.01088900025933981f;
  float _523 = mad(0.9869629740715027f, _515, _522);
  float _524 = mad(0.002148000057786703f, _516, _523);
  float _525 = mad(0.026962999254465103f, _515, _522);
  float _526 = mad(0.9621480107307434f, _516, _525);
  float _527 = max(_521, 0.0f);
  float _528 = max(_524, 0.0f);
  float _529 = max(_526, 0.0f);
  float _530 = min(_527, cb2_095y);
  float _531 = min(_528, cb2_095y);
  float _532 = min(_529, cb2_095y);
  bool _535 = ((uint)(cb2_095x) == 0);
  bool _538 = ((uint)(cb2_094w) == 0);
  bool _540 = ((uint)(cb2_094z) == 0);
  bool _542 = ((uint)(cb2_094y) != 0);
  bool _544 = ((uint)(cb2_094x) == 0);
  bool _546 = ((uint)(cb2_069z) != 0);
  float _593 = asfloat((uint)(cb2_075y));
  float _594 = asfloat((uint)(cb2_075z));
  float _595 = asfloat((uint)(cb2_075w));
  float _596 = asfloat((uint)(cb2_074z));
  float _597 = asfloat((uint)(cb2_074w));
  float _598 = asfloat((uint)(cb2_075x));
  float _599 = asfloat((uint)(cb2_073w));
  float _600 = asfloat((uint)(cb2_074x));
  float _601 = asfloat((uint)(cb2_074y));
  float _602 = asfloat((uint)(cb2_077x));
  float _603 = asfloat((uint)(cb2_077y));
  float _604 = asfloat((uint)(cb2_079x));
  float _605 = asfloat((uint)(cb2_079y));
  float _606 = asfloat((uint)(cb2_079z));
  float _607 = asfloat((uint)(cb2_078y));
  float _608 = asfloat((uint)(cb2_078z));
  float _609 = asfloat((uint)(cb2_078w));
  float _610 = asfloat((uint)(cb2_077z));
  float _611 = asfloat((uint)(cb2_077w));
  float _612 = asfloat((uint)(cb2_078x));
  float _613 = asfloat((uint)(cb2_072y));
  float _614 = asfloat((uint)(cb2_072z));
  float _615 = asfloat((uint)(cb2_072w));
  float _616 = asfloat((uint)(cb2_071x));
  float _617 = asfloat((uint)(cb2_071y));
  float _618 = asfloat((uint)(cb2_076x));
  float _619 = asfloat((uint)(cb2_070w));
  float _620 = asfloat((uint)(cb2_070x));
  float _621 = asfloat((uint)(cb2_070y));
  float _622 = asfloat((uint)(cb2_070z));
  float _623 = asfloat((uint)(cb2_073x));
  float _624 = asfloat((uint)(cb2_073y));
  float _625 = asfloat((uint)(cb2_073z));
  float _626 = asfloat((uint)(cb2_071z));
  float _627 = asfloat((uint)(cb2_071w));
  float _628 = asfloat((uint)(cb2_072x));
  float _629 = max(_531, _532);
  float _630 = max(_530, _629);
  float _631 = 1.0f / _630;
  float _632 = _631 * _530;
  float _633 = _631 * _531;
  float _634 = _631 * _532;
  float _635 = abs(_632);
  float _636 = log2(_635);
  float _637 = _636 * _620;
  float _638 = exp2(_637);
  float _639 = abs(_633);
  float _640 = log2(_639);
  float _641 = _640 * _621;
  float _642 = exp2(_641);
  float _643 = abs(_634);
  float _644 = log2(_643);
  float _645 = _644 * _622;
  float _646 = exp2(_645);
  if (_542) {
    float _649 = asfloat((uint)(cb2_076w));
    float _651 = asfloat((uint)(cb2_076z));
    float _653 = asfloat((uint)(cb2_076y));
    float _654 = _651 * _531;
    float _655 = _653 * _530;
    float _656 = _649 * _532;
    float _657 = _655 + _656;
    float _658 = _657 + _654;
    _666 = _658;
  } else {
    float _660 = _627 * _531;
    float _661 = _626 * _530;
    float _662 = _628 * _532;
    float _663 = _660 + _661;
    float _664 = _663 + _662;
    _666 = _664;
  }
  float _667 = abs(_666);
  float _668 = log2(_667);
  float _669 = _668 * _619;
  float _670 = exp2(_669);
  float _671 = log2(_670);
  float _672 = _671 * _618;
  float _673 = exp2(_672);
  float _674 = select(_546, _673, _670);
  float _675 = _674 * _616;
  float _676 = _675 + _617;
  float _677 = 1.0f / _676;
  float _678 = _677 * _670;
  if (_542) {
    if (!_544) {
      float _681 = _638 * _610;
      float _682 = _642 * _611;
      float _683 = _646 * _612;
      float _684 = _682 + _681;
      float _685 = _684 + _683;
      float _686 = _642 * _608;
      float _687 = _638 * _607;
      float _688 = _646 * _609;
      float _689 = _686 + _687;
      float _690 = _689 + _688;
      float _691 = _646 * _606;
      float _692 = _642 * _605;
      float _693 = _638 * _604;
      float _694 = _692 + _693;
      float _695 = _694 + _691;
      float _696 = max(_690, _695);
      float _697 = max(_685, _696);
      float _698 = 1.0f / _697;
      float _699 = _698 * _685;
      float _700 = _698 * _690;
      float _701 = _698 * _695;
      _703 = _699;
      _704 = _700;
      _705 = _701;
    } else {
      _703 = _638;
      _704 = _642;
      _705 = _646;
    }
    float _706 = _703 * _603;
    float _707 = exp2(_706);
    float _708 = _707 * _602;
    float _709 = saturate(_708);
    float _710 = _703 * _602;
    float _711 = _703 - _710;
    float _712 = saturate(_711);
    float _713 = max(_602, _712);
    float _714 = min(_713, _709);
    float _715 = _704 * _603;
    float _716 = exp2(_715);
    float _717 = _716 * _602;
    float _718 = saturate(_717);
    float _719 = _704 * _602;
    float _720 = _704 - _719;
    float _721 = saturate(_720);
    float _722 = max(_602, _721);
    float _723 = min(_722, _718);
    float _724 = _705 * _603;
    float _725 = exp2(_724);
    float _726 = _725 * _602;
    float _727 = saturate(_726);
    float _728 = _705 * _602;
    float _729 = _705 - _728;
    float _730 = saturate(_729);
    float _731 = max(_602, _730);
    float _732 = min(_731, _727);
    _734 = _714;
    _735 = _723;
    _736 = _732;
  } else {
    _734 = _638;
    _735 = _642;
    _736 = _646;
  }
  float _737 = _734 * _626;
  float _738 = _735 * _627;
  float _739 = _738 + _737;
  float _740 = _736 * _628;
  float _741 = _739 + _740;
  float _742 = 1.0f / _741;
  float _743 = _742 * _678;
  float _744 = saturate(_743);
  float _745 = _744 * _734;
  float _746 = saturate(_745);
  float _747 = _744 * _735;
  float _748 = saturate(_747);
  float _749 = _744 * _736;
  float _750 = saturate(_749);
  float _751 = _746 * _613;
  float _752 = _613 - _751;
  float _753 = _748 * _614;
  float _754 = _614 - _753;
  float _755 = _750 * _615;
  float _756 = _615 - _755;
  float _757 = _750 * _628;
  float _758 = _746 * _626;
  float _759 = _748 * _627;
  float _760 = _678 - _758;
  float _761 = _760 - _759;
  float _762 = _761 - _757;
  float _763 = saturate(_762);
  float _764 = _754 * _627;
  float _765 = _752 * _626;
  float _766 = _756 * _628;
  float _767 = _764 + _765;
  float _768 = _767 + _766;
  float _769 = 1.0f / _768;
  float _770 = _769 * _763;
  float _771 = _770 * _752;
  float _772 = _771 + _746;
  float _773 = saturate(_772);
  float _774 = _770 * _754;
  float _775 = _774 + _748;
  float _776 = saturate(_775);
  float _777 = _770 * _756;
  float _778 = _777 + _750;
  float _779 = saturate(_778);
  float _780 = _779 * _628;
  float _781 = _773 * _626;
  float _782 = _776 * _627;
  float _783 = _678 - _781;
  float _784 = _783 - _782;
  float _785 = _784 - _780;
  float _786 = saturate(_785);
  float _787 = _786 * _623;
  float _788 = _787 + _773;
  float _789 = saturate(_788);
  float _790 = _786 * _624;
  float _791 = _790 + _776;
  float _792 = saturate(_791);
  float _793 = _786 * _625;
  float _794 = _793 + _779;
  float _795 = saturate(_794);
  if (!_540) {
    float _797 = _789 * _599;
    float _798 = _792 * _600;
    float _799 = _795 * _601;
    float _800 = _798 + _797;
    float _801 = _800 + _799;
    float _802 = _792 * _597;
    float _803 = _789 * _596;
    float _804 = _795 * _598;
    float _805 = _802 + _803;
    float _806 = _805 + _804;
    float _807 = _795 * _595;
    float _808 = _792 * _594;
    float _809 = _789 * _593;
    float _810 = _808 + _809;
    float _811 = _810 + _807;
    if (!_538) {
      float _813 = saturate(_801);
      float _814 = saturate(_806);
      float _815 = saturate(_811);
      _817 = _815;
      _818 = _814;
      _819 = _813;
    } else {
      _817 = _811;
      _818 = _806;
      _819 = _801;
    }
  } else {
    _817 = _795;
    _818 = _792;
    _819 = _789;
  }
  if (!_535) {
    float _821 = _819 * _599;
    float _822 = _818 * _599;
    float _823 = _817 * _599;
    _825 = _823;
    _826 = _822;
    _827 = _821;
  } else {
    _825 = _817;
    _826 = _818;
    _827 = _819;
  }
  if (_506) {
    float _831 = cb1_018z * 9.999999747378752e-05f;
    float _832 = _831 * _827;
    float _833 = _831 * _826;
    float _834 = _831 * _825;
    float _836 = 5000.0f / cb1_018y;
    float _837 = _832 * _836;
    float _838 = _833 * _836;
    float _839 = _834 * _836;
    _841 = _837;
    _842 = _838;
    _843 = _839;
  } else {
    _841 = _827;
    _842 = _826;
    _843 = _825;
  }
  float _844 = _841 * 1.6047500371932983f;
  float _845 = mad(-0.5310800075531006f, _842, _844);
  float _846 = mad(-0.07366999983787537f, _843, _845);
  float _847 = _841 * -0.10208000242710114f;
  float _848 = mad(1.1081299781799316f, _842, _847);
  float _849 = mad(-0.006049999967217445f, _843, _848);
  float _850 = _841 * -0.0032599999103695154f;
  float _851 = mad(-0.07275000214576721f, _842, _850);
  float _852 = mad(1.0760200023651123f, _843, _851);
  if (_506) {
    // float _854 = max(_846, 0.0f);
    // float _855 = max(_849, 0.0f);
    // float _856 = max(_852, 0.0f);
    // bool _857 = !(_854 >= 0.0030399328097701073f);
    // if (!_857) {
    //   float _859 = abs(_854);
    //   float _860 = log2(_859);
    //   float _861 = _860 * 0.4166666567325592f;
    //   float _862 = exp2(_861);
    //   float _863 = _862 * 1.0549999475479126f;
    //   float _864 = _863 + -0.054999999701976776f;
    //   _868 = _864;
    // } else {
    //   float _866 = _854 * 12.923210144042969f;
    //   _868 = _866;
    // }
    // bool _869 = !(_855 >= 0.0030399328097701073f);
    // if (!_869) {
    //   float _871 = abs(_855);
    //   float _872 = log2(_871);
    //   float _873 = _872 * 0.4166666567325592f;
    //   float _874 = exp2(_873);
    //   float _875 = _874 * 1.0549999475479126f;
    //   float _876 = _875 + -0.054999999701976776f;
    //   _880 = _876;
    // } else {
    //   float _878 = _855 * 12.923210144042969f;
    //   _880 = _878;
    // }
    // bool _881 = !(_856 >= 0.0030399328097701073f);
    // if (!_881) {
    //   float _883 = abs(_856);
    //   float _884 = log2(_883);
    //   float _885 = _884 * 0.4166666567325592f;
    //   float _886 = exp2(_885);
    //   float _887 = _886 * 1.0549999475479126f;
    //   float _888 = _887 + -0.054999999701976776f;
    //   _961 = _868;
    //   _962 = _880;
    //   _963 = _888;
    // } else {
    //   float _890 = _856 * 12.923210144042969f;
    //   _961 = _868;
    //   _962 = _880;
    //   _963 = _890;
    // }
    _961 = renodx::color::srgb::EncodeSafe(_846);
    _962 = renodx::color::srgb::EncodeSafe(_849);
    _963 = renodx::color::srgb::EncodeSafe(_852);

  } else {
    float _892 = saturate(_846);
    float _893 = saturate(_849);
    float _894 = saturate(_852);
    bool _895 = ((uint)(cb1_018w) == -2);
    if (!_895) {
      bool _897 = !(_892 >= 0.0030399328097701073f);
      if (!_897) {
        float _899 = abs(_892);
        float _900 = log2(_899);
        float _901 = _900 * 0.4166666567325592f;
        float _902 = exp2(_901);
        float _903 = _902 * 1.0549999475479126f;
        float _904 = _903 + -0.054999999701976776f;
        _908 = _904;
      } else {
        float _906 = _892 * 12.923210144042969f;
        _908 = _906;
      }
      bool _909 = !(_893 >= 0.0030399328097701073f);
      if (!_909) {
        float _911 = abs(_893);
        float _912 = log2(_911);
        float _913 = _912 * 0.4166666567325592f;
        float _914 = exp2(_913);
        float _915 = _914 * 1.0549999475479126f;
        float _916 = _915 + -0.054999999701976776f;
        _920 = _916;
      } else {
        float _918 = _893 * 12.923210144042969f;
        _920 = _918;
      }
      bool _921 = !(_894 >= 0.0030399328097701073f);
      if (!_921) {
        float _923 = abs(_894);
        float _924 = log2(_923);
        float _925 = _924 * 0.4166666567325592f;
        float _926 = exp2(_925);
        float _927 = _926 * 1.0549999475479126f;
        float _928 = _927 + -0.054999999701976776f;
        _932 = _908;
        _933 = _920;
        _934 = _928;
      } else {
        float _930 = _894 * 12.923210144042969f;
        _932 = _908;
        _933 = _920;
        _934 = _930;
      }
    } else {
      _932 = _892;
      _933 = _893;
      _934 = _894;
    }
    float _939 = abs(_932);
    float _940 = abs(_933);
    float _941 = abs(_934);
    float _942 = log2(_939);
    float _943 = log2(_940);
    float _944 = log2(_941);
    float _945 = _942 * cb2_000z;
    float _946 = _943 * cb2_000z;
    float _947 = _944 * cb2_000z;
    float _948 = exp2(_945);
    float _949 = exp2(_946);
    float _950 = exp2(_947);
    float _951 = _948 * cb2_000y;
    float _952 = _949 * cb2_000y;
    float _953 = _950 * cb2_000y;
    float _954 = _951 + cb2_000x;
    float _955 = _952 + cb2_000x;
    float _956 = _953 + cb2_000x;
    float _957 = saturate(_954);
    float _958 = saturate(_955);
    float _959 = saturate(_956);
    _961 = _957;
    _962 = _958;
    _963 = _959;
  }
  float _964 = dot(float3(_961, _962, _963), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _961;
  SV_Target.y = _962;
  SV_Target.z = _963;
  SV_Target.w = _964;
  SV_Target_1.x = _964;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

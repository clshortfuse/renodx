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
  float _351;
  float _352;
  float _353;
  float _398;
  float _399;
  float _400;
  float _401;
  float _448;
  float _449;
  float _450;
  float _475;
  float _476;
  float _477;
  float _627;
  float _664;
  float _665;
  float _666;
  float _695;
  float _696;
  float _697;
  float _778;
  float _779;
  float _780;
  float _786;
  float _787;
  float _788;
  float _802;
  float _803;
  float _804;
  float _829;
  float _841;
  float _869;
  float _881;
  float _893;
  float _894;
  float _895;
  float _922;
  float _923;
  float _924;
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
  float _319 = cb2_004x * TEXCOORD0_centroid.x;
  float _320 = cb2_004y * TEXCOORD0_centroid.y;
  float _323 = _319 + cb2_004z;
  float _324 = _320 + cb2_004w;
  float4 _330 = t6.Sample(s2_space2, float2(_323, _324));
  float _335 = _330.x * cb2_003x;
  float _336 = _330.y * cb2_003y;
  float _337 = _330.z * cb2_003z;
  float _338 = _330.w * cb2_003w;
  float _341 = _338 + cb2_026y;
  float _342 = saturate(_341);
  bool _345 = ((uint)(cb2_069y) == 0);
  if (!_345) {
    float _347 = _335 * _239;
    float _348 = _336 * _239;
    float _349 = _337 * _239;
    _351 = _347;
    _352 = _348;
    _353 = _349;
  } else {
    _351 = _335;
    _352 = _336;
    _353 = _337;
  }
  bool _356 = ((uint)(cb2_028x) == 2);
  bool _357 = ((uint)(cb2_028x) == 3);
  int _358 = (uint)(cb2_028x) & -2;
  bool _359 = (_358 == 2);
  bool _360 = ((uint)(cb2_028x) == 6);
  bool _361 = _359 || _360;
  if (_361) {
    float _363 = _351 * _342;
    float _364 = _352 * _342;
    float _365 = _353 * _342;
    float _366 = _342 * _342;
    _398 = _363;
    _399 = _364;
    _400 = _365;
    _401 = _366;
  } else {
    bool _368 = ((uint)(cb2_028x) == 4);
    if (_368) {
      float _370 = _351 + -1.0f;
      float _371 = _352 + -1.0f;
      float _372 = _353 + -1.0f;
      float _373 = _342 + -1.0f;
      float _374 = _370 * _342;
      float _375 = _371 * _342;
      float _376 = _372 * _342;
      float _377 = _373 * _342;
      float _378 = _374 + 1.0f;
      float _379 = _375 + 1.0f;
      float _380 = _376 + 1.0f;
      float _381 = _377 + 1.0f;
      _398 = _378;
      _399 = _379;
      _400 = _380;
      _401 = _381;
    } else {
      bool _383 = ((uint)(cb2_028x) == 5);
      if (_383) {
        float _385 = _351 + -0.5f;
        float _386 = _352 + -0.5f;
        float _387 = _353 + -0.5f;
        float _388 = _342 + -0.5f;
        float _389 = _385 * _342;
        float _390 = _386 * _342;
        float _391 = _387 * _342;
        float _392 = _388 * _342;
        float _393 = _389 + 0.5f;
        float _394 = _390 + 0.5f;
        float _395 = _391 + 0.5f;
        float _396 = _392 + 0.5f;
        _398 = _393;
        _399 = _394;
        _400 = _395;
        _401 = _396;
      } else {
        _398 = _351;
        _399 = _352;
        _400 = _353;
        _401 = _342;
      }
    }
  }
  if (_356) {
    float _403 = _398 + _309;
    float _404 = _399 + _312;
    float _405 = _400 + _315;
    _448 = _403;
    _449 = _404;
    _450 = _405;
  } else {
    if (_357) {
      float _408 = 1.0f - _398;
      float _409 = 1.0f - _399;
      float _410 = 1.0f - _400;
      float _411 = _408 * _309;
      float _412 = _409 * _312;
      float _413 = _410 * _315;
      float _414 = _411 + _398;
      float _415 = _412 + _399;
      float _416 = _413 + _400;
      _448 = _414;
      _449 = _415;
      _450 = _416;
    } else {
      bool _418 = ((uint)(cb2_028x) == 4);
      if (_418) {
        float _420 = _398 * _309;
        float _421 = _399 * _312;
        float _422 = _400 * _315;
        _448 = _420;
        _449 = _421;
        _450 = _422;
      } else {
        bool _424 = ((uint)(cb2_028x) == 5);
        if (_424) {
          float _426 = _309 * 2.0f;
          float _427 = _426 * _398;
          float _428 = _312 * 2.0f;
          float _429 = _428 * _399;
          float _430 = _315 * 2.0f;
          float _431 = _430 * _400;
          _448 = _427;
          _449 = _429;
          _450 = _431;
        } else {
          if (_360) {
            float _434 = _309 - _398;
            float _435 = _312 - _399;
            float _436 = _315 - _400;
            _448 = _434;
            _449 = _435;
            _450 = _436;
          } else {
            float _438 = _398 - _309;
            float _439 = _399 - _312;
            float _440 = _400 - _315;
            float _441 = _401 * _438;
            float _442 = _401 * _439;
            float _443 = _401 * _440;
            float _444 = _441 + _309;
            float _445 = _442 + _312;
            float _446 = _443 + _315;
            _448 = _444;
            _449 = _445;
            _450 = _446;
          }
        }
      }
    }
  }
  float _456 = cb2_016x - _448;
  float _457 = cb2_016y - _449;
  float _458 = cb2_016z - _450;
  float _459 = _456 * cb2_016w;
  float _460 = _457 * cb2_016w;
  float _461 = _458 * cb2_016w;
  float _462 = _459 + _448;
  float _463 = _460 + _449;
  float _464 = _461 + _450;
  bool _467 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_467 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _471 = cb2_024x * _462;
    float _472 = cb2_024x * _463;
    float _473 = cb2_024x * _464;
    _475 = _471;
    _476 = _472;
    _477 = _473;
  } else {
    _475 = _462;
    _476 = _463;
    _477 = _464;
  }
  float _480 = _475 * 0.9708889722824097f;
  float _481 = mad(0.026962999254465103f, _476, _480);
  float _482 = mad(0.002148000057786703f, _477, _481);
  float _483 = _475 * 0.01088900025933981f;
  float _484 = mad(0.9869629740715027f, _476, _483);
  float _485 = mad(0.002148000057786703f, _477, _484);
  float _486 = mad(0.026962999254465103f, _476, _483);
  float _487 = mad(0.9621480107307434f, _477, _486);
  float _488 = max(_482, 0.0f);
  float _489 = max(_485, 0.0f);
  float _490 = max(_487, 0.0f);
  float _491 = min(_488, cb2_095y);
  float _492 = min(_489, cb2_095y);
  float _493 = min(_490, cb2_095y);
  bool _496 = ((uint)(cb2_095x) == 0);
  bool _499 = ((uint)(cb2_094w) == 0);
  bool _501 = ((uint)(cb2_094z) == 0);
  bool _503 = ((uint)(cb2_094y) != 0);
  bool _505 = ((uint)(cb2_094x) == 0);
  bool _507 = ((uint)(cb2_069z) != 0);
  float _554 = asfloat((uint)(cb2_075y));
  float _555 = asfloat((uint)(cb2_075z));
  float _556 = asfloat((uint)(cb2_075w));
  float _557 = asfloat((uint)(cb2_074z));
  float _558 = asfloat((uint)(cb2_074w));
  float _559 = asfloat((uint)(cb2_075x));
  float _560 = asfloat((uint)(cb2_073w));
  float _561 = asfloat((uint)(cb2_074x));
  float _562 = asfloat((uint)(cb2_074y));
  float _563 = asfloat((uint)(cb2_077x));
  float _564 = asfloat((uint)(cb2_077y));
  float _565 = asfloat((uint)(cb2_079x));
  float _566 = asfloat((uint)(cb2_079y));
  float _567 = asfloat((uint)(cb2_079z));
  float _568 = asfloat((uint)(cb2_078y));
  float _569 = asfloat((uint)(cb2_078z));
  float _570 = asfloat((uint)(cb2_078w));
  float _571 = asfloat((uint)(cb2_077z));
  float _572 = asfloat((uint)(cb2_077w));
  float _573 = asfloat((uint)(cb2_078x));
  float _574 = asfloat((uint)(cb2_072y));
  float _575 = asfloat((uint)(cb2_072z));
  float _576 = asfloat((uint)(cb2_072w));
  float _577 = asfloat((uint)(cb2_071x));
  float _578 = asfloat((uint)(cb2_071y));
  float _579 = asfloat((uint)(cb2_076x));
  float _580 = asfloat((uint)(cb2_070w));
  float _581 = asfloat((uint)(cb2_070x));
  float _582 = asfloat((uint)(cb2_070y));
  float _583 = asfloat((uint)(cb2_070z));
  float _584 = asfloat((uint)(cb2_073x));
  float _585 = asfloat((uint)(cb2_073y));
  float _586 = asfloat((uint)(cb2_073z));
  float _587 = asfloat((uint)(cb2_071z));
  float _588 = asfloat((uint)(cb2_071w));
  float _589 = asfloat((uint)(cb2_072x));
  float _590 = max(_492, _493);
  float _591 = max(_491, _590);
  float _592 = 1.0f / _591;
  float _593 = _592 * _491;
  float _594 = _592 * _492;
  float _595 = _592 * _493;
  float _596 = abs(_593);
  float _597 = log2(_596);
  float _598 = _597 * _581;
  float _599 = exp2(_598);
  float _600 = abs(_594);
  float _601 = log2(_600);
  float _602 = _601 * _582;
  float _603 = exp2(_602);
  float _604 = abs(_595);
  float _605 = log2(_604);
  float _606 = _605 * _583;
  float _607 = exp2(_606);
  if (_503) {
    float _610 = asfloat((uint)(cb2_076w));
    float _612 = asfloat((uint)(cb2_076z));
    float _614 = asfloat((uint)(cb2_076y));
    float _615 = _612 * _492;
    float _616 = _614 * _491;
    float _617 = _610 * _493;
    float _618 = _616 + _617;
    float _619 = _618 + _615;
    _627 = _619;
  } else {
    float _621 = _588 * _492;
    float _622 = _587 * _491;
    float _623 = _589 * _493;
    float _624 = _621 + _622;
    float _625 = _624 + _623;
    _627 = _625;
  }
  float _628 = abs(_627);
  float _629 = log2(_628);
  float _630 = _629 * _580;
  float _631 = exp2(_630);
  float _632 = log2(_631);
  float _633 = _632 * _579;
  float _634 = exp2(_633);
  float _635 = select(_507, _634, _631);
  float _636 = _635 * _577;
  float _637 = _636 + _578;
  float _638 = 1.0f / _637;
  float _639 = _638 * _631;
  if (_503) {
    if (!_505) {
      float _642 = _599 * _571;
      float _643 = _603 * _572;
      float _644 = _607 * _573;
      float _645 = _643 + _642;
      float _646 = _645 + _644;
      float _647 = _603 * _569;
      float _648 = _599 * _568;
      float _649 = _607 * _570;
      float _650 = _647 + _648;
      float _651 = _650 + _649;
      float _652 = _607 * _567;
      float _653 = _603 * _566;
      float _654 = _599 * _565;
      float _655 = _653 + _654;
      float _656 = _655 + _652;
      float _657 = max(_651, _656);
      float _658 = max(_646, _657);
      float _659 = 1.0f / _658;
      float _660 = _659 * _646;
      float _661 = _659 * _651;
      float _662 = _659 * _656;
      _664 = _660;
      _665 = _661;
      _666 = _662;
    } else {
      _664 = _599;
      _665 = _603;
      _666 = _607;
    }
    float _667 = _664 * _564;
    float _668 = exp2(_667);
    float _669 = _668 * _563;
    float _670 = saturate(_669);
    float _671 = _664 * _563;
    float _672 = _664 - _671;
    float _673 = saturate(_672);
    float _674 = max(_563, _673);
    float _675 = min(_674, _670);
    float _676 = _665 * _564;
    float _677 = exp2(_676);
    float _678 = _677 * _563;
    float _679 = saturate(_678);
    float _680 = _665 * _563;
    float _681 = _665 - _680;
    float _682 = saturate(_681);
    float _683 = max(_563, _682);
    float _684 = min(_683, _679);
    float _685 = _666 * _564;
    float _686 = exp2(_685);
    float _687 = _686 * _563;
    float _688 = saturate(_687);
    float _689 = _666 * _563;
    float _690 = _666 - _689;
    float _691 = saturate(_690);
    float _692 = max(_563, _691);
    float _693 = min(_692, _688);
    _695 = _675;
    _696 = _684;
    _697 = _693;
  } else {
    _695 = _599;
    _696 = _603;
    _697 = _607;
  }
  float _698 = _695 * _587;
  float _699 = _696 * _588;
  float _700 = _699 + _698;
  float _701 = _697 * _589;
  float _702 = _700 + _701;
  float _703 = 1.0f / _702;
  float _704 = _703 * _639;
  float _705 = saturate(_704);
  float _706 = _705 * _695;
  float _707 = saturate(_706);
  float _708 = _705 * _696;
  float _709 = saturate(_708);
  float _710 = _705 * _697;
  float _711 = saturate(_710);
  float _712 = _707 * _574;
  float _713 = _574 - _712;
  float _714 = _709 * _575;
  float _715 = _575 - _714;
  float _716 = _711 * _576;
  float _717 = _576 - _716;
  float _718 = _711 * _589;
  float _719 = _707 * _587;
  float _720 = _709 * _588;
  float _721 = _639 - _719;
  float _722 = _721 - _720;
  float _723 = _722 - _718;
  float _724 = saturate(_723);
  float _725 = _715 * _588;
  float _726 = _713 * _587;
  float _727 = _717 * _589;
  float _728 = _725 + _726;
  float _729 = _728 + _727;
  float _730 = 1.0f / _729;
  float _731 = _730 * _724;
  float _732 = _731 * _713;
  float _733 = _732 + _707;
  float _734 = saturate(_733);
  float _735 = _731 * _715;
  float _736 = _735 + _709;
  float _737 = saturate(_736);
  float _738 = _731 * _717;
  float _739 = _738 + _711;
  float _740 = saturate(_739);
  float _741 = _740 * _589;
  float _742 = _734 * _587;
  float _743 = _737 * _588;
  float _744 = _639 - _742;
  float _745 = _744 - _743;
  float _746 = _745 - _741;
  float _747 = saturate(_746);
  float _748 = _747 * _584;
  float _749 = _748 + _734;
  float _750 = saturate(_749);
  float _751 = _747 * _585;
  float _752 = _751 + _737;
  float _753 = saturate(_752);
  float _754 = _747 * _586;
  float _755 = _754 + _740;
  float _756 = saturate(_755);
  if (!_501) {
    float _758 = _750 * _560;
    float _759 = _753 * _561;
    float _760 = _756 * _562;
    float _761 = _759 + _758;
    float _762 = _761 + _760;
    float _763 = _753 * _558;
    float _764 = _750 * _557;
    float _765 = _756 * _559;
    float _766 = _763 + _764;
    float _767 = _766 + _765;
    float _768 = _756 * _556;
    float _769 = _753 * _555;
    float _770 = _750 * _554;
    float _771 = _769 + _770;
    float _772 = _771 + _768;
    if (!_499) {
      float _774 = saturate(_762);
      float _775 = saturate(_767);
      float _776 = saturate(_772);
      _778 = _776;
      _779 = _775;
      _780 = _774;
    } else {
      _778 = _772;
      _779 = _767;
      _780 = _762;
    }
  } else {
    _778 = _756;
    _779 = _753;
    _780 = _750;
  }
  if (!_496) {
    float _782 = _780 * _560;
    float _783 = _779 * _560;
    float _784 = _778 * _560;
    _786 = _784;
    _787 = _783;
    _788 = _782;
  } else {
    _786 = _778;
    _787 = _779;
    _788 = _780;
  }
  if (_467) {
    float _792 = cb1_018z * 9.999999747378752e-05f;
    float _793 = _792 * _788;
    float _794 = _792 * _787;
    float _795 = _792 * _786;
    float _797 = 5000.0f / cb1_018y;
    float _798 = _793 * _797;
    float _799 = _794 * _797;
    float _800 = _795 * _797;
    _802 = _798;
    _803 = _799;
    _804 = _800;
  } else {
    _802 = _788;
    _803 = _787;
    _804 = _786;
  }
  float _805 = _802 * 1.6047500371932983f;
  float _806 = mad(-0.5310800075531006f, _803, _805);
  float _807 = mad(-0.07366999983787537f, _804, _806);
  float _808 = _802 * -0.10208000242710114f;
  float _809 = mad(1.1081299781799316f, _803, _808);
  float _810 = mad(-0.006049999967217445f, _804, _809);
  float _811 = _802 * -0.0032599999103695154f;
  float _812 = mad(-0.07275000214576721f, _803, _811);
  float _813 = mad(1.0760200023651123f, _804, _812);
  if (_467) {
    // float _815 = max(_807, 0.0f);
    // float _816 = max(_810, 0.0f);
    // float _817 = max(_813, 0.0f);
    // bool _818 = !(_815 >= 0.0030399328097701073f);
    // if (!_818) {
    //   float _820 = abs(_815);
    //   float _821 = log2(_820);
    //   float _822 = _821 * 0.4166666567325592f;
    //   float _823 = exp2(_822);
    //   float _824 = _823 * 1.0549999475479126f;
    //   float _825 = _824 + -0.054999999701976776f;
    //   _829 = _825;
    // } else {
    //   float _827 = _815 * 12.923210144042969f;
    //   _829 = _827;
    // }
    // bool _830 = !(_816 >= 0.0030399328097701073f);
    // if (!_830) {
    //   float _832 = abs(_816);
    //   float _833 = log2(_832);
    //   float _834 = _833 * 0.4166666567325592f;
    //   float _835 = exp2(_834);
    //   float _836 = _835 * 1.0549999475479126f;
    //   float _837 = _836 + -0.054999999701976776f;
    //   _841 = _837;
    // } else {
    //   float _839 = _816 * 12.923210144042969f;
    //   _841 = _839;
    // }
    // bool _842 = !(_817 >= 0.0030399328097701073f);
    // if (!_842) {
    //   float _844 = abs(_817);
    //   float _845 = log2(_844);
    //   float _846 = _845 * 0.4166666567325592f;
    //   float _847 = exp2(_846);
    //   float _848 = _847 * 1.0549999475479126f;
    //   float _849 = _848 + -0.054999999701976776f;
    //   _922 = _829;
    //   _923 = _841;
    //   _924 = _849;
    // } else {
    //   float _851 = _817 * 12.923210144042969f;
    //   _922 = _829;
    //   _923 = _841;
    //   _924 = _851;
    // }
    _922 = renodx::color::srgb::EncodeSafe(_807);
    _923 = renodx::color::srgb::EncodeSafe(_810);
    _924 = renodx::color::srgb::EncodeSafe(_813);

  } else {
    float _853 = saturate(_807);
    float _854 = saturate(_810);
    float _855 = saturate(_813);
    bool _856 = ((uint)(cb1_018w) == -2);
    if (!_856) {
      bool _858 = !(_853 >= 0.0030399328097701073f);
      if (!_858) {
        float _860 = abs(_853);
        float _861 = log2(_860);
        float _862 = _861 * 0.4166666567325592f;
        float _863 = exp2(_862);
        float _864 = _863 * 1.0549999475479126f;
        float _865 = _864 + -0.054999999701976776f;
        _869 = _865;
      } else {
        float _867 = _853 * 12.923210144042969f;
        _869 = _867;
      }
      bool _870 = !(_854 >= 0.0030399328097701073f);
      if (!_870) {
        float _872 = abs(_854);
        float _873 = log2(_872);
        float _874 = _873 * 0.4166666567325592f;
        float _875 = exp2(_874);
        float _876 = _875 * 1.0549999475479126f;
        float _877 = _876 + -0.054999999701976776f;
        _881 = _877;
      } else {
        float _879 = _854 * 12.923210144042969f;
        _881 = _879;
      }
      bool _882 = !(_855 >= 0.0030399328097701073f);
      if (!_882) {
        float _884 = abs(_855);
        float _885 = log2(_884);
        float _886 = _885 * 0.4166666567325592f;
        float _887 = exp2(_886);
        float _888 = _887 * 1.0549999475479126f;
        float _889 = _888 + -0.054999999701976776f;
        _893 = _869;
        _894 = _881;
        _895 = _889;
      } else {
        float _891 = _855 * 12.923210144042969f;
        _893 = _869;
        _894 = _881;
        _895 = _891;
      }
    } else {
      _893 = _853;
      _894 = _854;
      _895 = _855;
    }
    float _900 = abs(_893);
    float _901 = abs(_894);
    float _902 = abs(_895);
    float _903 = log2(_900);
    float _904 = log2(_901);
    float _905 = log2(_902);
    float _906 = _903 * cb2_000z;
    float _907 = _904 * cb2_000z;
    float _908 = _905 * cb2_000z;
    float _909 = exp2(_906);
    float _910 = exp2(_907);
    float _911 = exp2(_908);
    float _912 = _909 * cb2_000y;
    float _913 = _910 * cb2_000y;
    float _914 = _911 * cb2_000y;
    float _915 = _912 + cb2_000x;
    float _916 = _913 + cb2_000x;
    float _917 = _914 + cb2_000x;
    float _918 = saturate(_915);
    float _919 = saturate(_916);
    float _920 = saturate(_917);
    _922 = _918;
    _923 = _919;
    _924 = _920;
  }
  float _925 = dot(float3(_922, _923, _924), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _922;
  SV_Target.y = _923;
  SV_Target.z = _924;
  SV_Target.w = _925;
  SV_Target_1.x = _925;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

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
  float _617;
  float _618;
  float _619;
  float _644;
  float _656;
  float _684;
  float _696;
  float _708;
  float _709;
  float _710;
  float _737;
  float _738;
  float _739;
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
  float _517 = _514 * 0.9708889722824097f;
  float _518 = mad(0.026962999254465103f, _515, _517);
  float _519 = mad(0.002148000057786703f, _516, _518);
  float _520 = _514 * 0.01088900025933981f;
  float _521 = mad(0.9869629740715027f, _515, _520);
  float _522 = mad(0.002148000057786703f, _516, _521);
  float _523 = mad(0.026962999254465103f, _515, _520);
  float _524 = mad(0.9621480107307434f, _516, _523);
  if (_506) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _529 = cb1_018y * 0.10000000149011612f;
        float _530 = log2(cb1_018z);
        float _531 = _530 + -13.287712097167969f;
        float _532 = _531 * 1.4929734468460083f;
        float _533 = _532 + 18.0f;
        float _534 = exp2(_533);
        float _535 = _534 * 0.18000000715255737f;
        float _536 = abs(_535);
        float _537 = log2(_536);
        float _538 = _537 * 1.5f;
        float _539 = exp2(_538);
        float _540 = _539 * _529;
        float _541 = _540 / cb1_018z;
        float _542 = _541 + -0.07636754959821701f;
        float _543 = _537 * 1.2750000953674316f;
        float _544 = exp2(_543);
        float _545 = _544 * 0.07636754959821701f;
        float _546 = cb1_018y * 0.011232397519052029f;
        float _547 = _546 * _539;
        float _548 = _547 / cb1_018z;
        float _549 = _545 - _548;
        float _550 = _544 + -0.11232396960258484f;
        float _551 = _550 * _529;
        float _552 = _551 / cb1_018z;
        float _553 = _552 * cb1_018z;
        float _554 = abs(_519);
        float _555 = abs(_522);
        float _556 = abs(_524);
        float _557 = log2(_554);
        float _558 = log2(_555);
        float _559 = log2(_556);
        float _560 = _557 * 1.5f;
        float _561 = _558 * 1.5f;
        float _562 = _559 * 1.5f;
        float _563 = exp2(_560);
        float _564 = exp2(_561);
        float _565 = exp2(_562);
        float _566 = _563 * _553;
        float _567 = _564 * _553;
        float _568 = _565 * _553;
        float _569 = _557 * 1.2750000953674316f;
        float _570 = _558 * 1.2750000953674316f;
        float _571 = _559 * 1.2750000953674316f;
        float _572 = exp2(_569);
        float _573 = exp2(_570);
        float _574 = exp2(_571);
        float _575 = _572 * _542;
        float _576 = _573 * _542;
        float _577 = _574 * _542;
        float _578 = _575 + _549;
        float _579 = _576 + _549;
        float _580 = _577 + _549;
        float _581 = _566 / _578;
        float _582 = _567 / _579;
        float _583 = _568 / _580;
        float _584 = _581 * 9.999999747378752e-05f;
        float _585 = _582 * 9.999999747378752e-05f;
        float _586 = _583 * 9.999999747378752e-05f;
        float _587 = 5000.0f / cb1_018y;
        float _588 = _584 * _587;
        float _589 = _585 * _587;
        float _590 = _586 * _587;
        _617 = _588;
        _618 = _589;
        _619 = _590;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_519, _522, _524));
      _617 = tonemapped.x, _618 = tonemapped.y, _619 = tonemapped.z;
    }
      } else {
        float _592 = _519 + 0.020616600289940834f;
        float _593 = _522 + 0.020616600289940834f;
        float _594 = _524 + 0.020616600289940834f;
        float _595 = _592 * _519;
        float _596 = _593 * _522;
        float _597 = _594 * _524;
        float _598 = _595 + -7.456949970219284e-05f;
        float _599 = _596 + -7.456949970219284e-05f;
        float _600 = _597 + -7.456949970219284e-05f;
        float _601 = _519 * 0.9837960004806519f;
        float _602 = _522 * 0.9837960004806519f;
        float _603 = _524 * 0.9837960004806519f;
        float _604 = _601 + 0.4336790144443512f;
        float _605 = _602 + 0.4336790144443512f;
        float _606 = _603 + 0.4336790144443512f;
        float _607 = _604 * _519;
        float _608 = _605 * _522;
        float _609 = _606 * _524;
        float _610 = _607 + 0.24617899954319f;
        float _611 = _608 + 0.24617899954319f;
        float _612 = _609 + 0.24617899954319f;
        float _613 = _598 / _610;
        float _614 = _599 / _611;
        float _615 = _600 / _612;
        _617 = _613;
        _618 = _614;
        _619 = _615;
      }
      float _620 = _617 * 1.6047500371932983f;
      float _621 = mad(-0.5310800075531006f, _618, _620);
      float _622 = mad(-0.07366999983787537f, _619, _621);
      float _623 = _617 * -0.10208000242710114f;
      float _624 = mad(1.1081299781799316f, _618, _623);
      float _625 = mad(-0.006049999967217445f, _619, _624);
      float _626 = _617 * -0.0032599999103695154f;
      float _627 = mad(-0.07275000214576721f, _618, _626);
      float _628 = mad(1.0760200023651123f, _619, _627);
      if (_506) {
        // float _630 = max(_622, 0.0f);
        // float _631 = max(_625, 0.0f);
        // float _632 = max(_628, 0.0f);
        // bool _633 = !(_630 >= 0.0030399328097701073f);
        // if (!_633) {
        //   float _635 = abs(_630);
        //   float _636 = log2(_635);
        //   float _637 = _636 * 0.4166666567325592f;
        //   float _638 = exp2(_637);
        //   float _639 = _638 * 1.0549999475479126f;
        //   float _640 = _639 + -0.054999999701976776f;
        //   _644 = _640;
        // } else {
        //   float _642 = _630 * 12.923210144042969f;
        //   _644 = _642;
        // }
        // bool _645 = !(_631 >= 0.0030399328097701073f);
        // if (!_645) {
        //   float _647 = abs(_631);
        //   float _648 = log2(_647);
        //   float _649 = _648 * 0.4166666567325592f;
        //   float _650 = exp2(_649);
        //   float _651 = _650 * 1.0549999475479126f;
        //   float _652 = _651 + -0.054999999701976776f;
        //   _656 = _652;
        // } else {
        //   float _654 = _631 * 12.923210144042969f;
        //   _656 = _654;
        // }
        // bool _657 = !(_632 >= 0.0030399328097701073f);
        // if (!_657) {
        //   float _659 = abs(_632);
        //   float _660 = log2(_659);
        //   float _661 = _660 * 0.4166666567325592f;
        //   float _662 = exp2(_661);
        //   float _663 = _662 * 1.0549999475479126f;
        //   float _664 = _663 + -0.054999999701976776f;
        //   _737 = _644;
        //   _738 = _656;
        //   _739 = _664;
        // } else {
        //   float _666 = _632 * 12.923210144042969f;
        //   _737 = _644;
        //   _738 = _656;
        //   _739 = _666;
        // }
        _737 = renodx::color::srgb::EncodeSafe(_622);
        _738 = renodx::color::srgb::EncodeSafe(_625);
        _739 = renodx::color::srgb::EncodeSafe(_628);

      } else {
        float _668 = saturate(_622);
        float _669 = saturate(_625);
        float _670 = saturate(_628);
        bool _671 = ((uint)(cb1_018w) == -2);
        if (!_671) {
          bool _673 = !(_668 >= 0.0030399328097701073f);
          if (!_673) {
            float _675 = abs(_668);
            float _676 = log2(_675);
            float _677 = _676 * 0.4166666567325592f;
            float _678 = exp2(_677);
            float _679 = _678 * 1.0549999475479126f;
            float _680 = _679 + -0.054999999701976776f;
            _684 = _680;
          } else {
            float _682 = _668 * 12.923210144042969f;
            _684 = _682;
          }
          bool _685 = !(_669 >= 0.0030399328097701073f);
          if (!_685) {
            float _687 = abs(_669);
            float _688 = log2(_687);
            float _689 = _688 * 0.4166666567325592f;
            float _690 = exp2(_689);
            float _691 = _690 * 1.0549999475479126f;
            float _692 = _691 + -0.054999999701976776f;
            _696 = _692;
          } else {
            float _694 = _669 * 12.923210144042969f;
            _696 = _694;
          }
          bool _697 = !(_670 >= 0.0030399328097701073f);
          if (!_697) {
            float _699 = abs(_670);
            float _700 = log2(_699);
            float _701 = _700 * 0.4166666567325592f;
            float _702 = exp2(_701);
            float _703 = _702 * 1.0549999475479126f;
            float _704 = _703 + -0.054999999701976776f;
            _708 = _684;
            _709 = _696;
            _710 = _704;
          } else {
            float _706 = _670 * 12.923210144042969f;
            _708 = _684;
            _709 = _696;
            _710 = _706;
          }
        } else {
          _708 = _668;
          _709 = _669;
          _710 = _670;
        }
        float _715 = abs(_708);
        float _716 = abs(_709);
        float _717 = abs(_710);
        float _718 = log2(_715);
        float _719 = log2(_716);
        float _720 = log2(_717);
        float _721 = _718 * cb2_000z;
        float _722 = _719 * cb2_000z;
        float _723 = _720 * cb2_000z;
        float _724 = exp2(_721);
        float _725 = exp2(_722);
        float _726 = exp2(_723);
        float _727 = _724 * cb2_000y;
        float _728 = _725 * cb2_000y;
        float _729 = _726 * cb2_000y;
        float _730 = _727 + cb2_000x;
        float _731 = _728 + cb2_000x;
        float _732 = _729 + cb2_000x;
        float _733 = saturate(_730);
        float _734 = saturate(_731);
        float _735 = saturate(_732);
        _737 = _733;
        _738 = _734;
        _739 = _735;
      }
      float _740 = dot(float3(_737, _738, _739), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _737;
      SV_Target.y = _738;
      SV_Target.z = _739;
      SV_Target.w = _740;
      SV_Target_1.x = _740;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

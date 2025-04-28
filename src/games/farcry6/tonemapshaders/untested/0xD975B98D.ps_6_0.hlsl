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
  float _30 = cb2_015x * TEXCOORD0_centroid.x;
  float _31 = cb2_015y * TEXCOORD0_centroid.y;
  float _34 = _30 + cb2_015z;
  float _35 = _31 + cb2_015w;
  float4 _36 = t8.SampleLevel(s0_space2, float2(_34, _35), 0.0f);
  float _40 = saturate(_36.x);
  float _41 = saturate(_36.z);
  float _44 = cb2_026x * _41;
  float _45 = _40 * 6.283199787139893f;
  float _46 = cos(_45);
  float _47 = sin(_45);
  float _48 = _44 * _46;
  float _49 = _47 * _44;
  float _50 = 1.0f - _36.y;
  float _51 = saturate(_50);
  float _52 = _48 * _51;
  float _53 = _49 * _51;
  float _54 = _52 + TEXCOORD0_centroid.x;
  float _55 = _53 + TEXCOORD0_centroid.y;
  float4 _56 = t1.SampleLevel(s4_space2, float2(_54, _55), 0.0f);
  float _60 = max(_56.x, 0.0f);
  float _61 = max(_56.y, 0.0f);
  float _62 = max(_56.z, 0.0f);
  float _63 = min(_60, 65000.0f);
  float _64 = min(_61, 65000.0f);
  float _65 = min(_62, 65000.0f);
  float4 _66 = t4.SampleLevel(s2_space2, float2(_54, _55), 0.0f);
  float _71 = max(_66.x, 0.0f);
  float _72 = max(_66.y, 0.0f);
  float _73 = max(_66.z, 0.0f);
  float _74 = max(_66.w, 0.0f);
  float _75 = min(_71, 5000.0f);
  float _76 = min(_72, 5000.0f);
  float _77 = min(_73, 5000.0f);
  float _78 = min(_74, 5000.0f);
  float _81 = _25.x * cb0_028z;
  float _82 = _81 + cb0_028x;
  float _83 = cb2_027w / _82;
  float _84 = 1.0f - _83;
  float _85 = abs(_84);
  float _87 = cb2_027y * _85;
  float _89 = _87 - cb2_027z;
  float _90 = saturate(_89);
  float _91 = max(_90, _78);
  float _92 = saturate(_91);
  float4 _93 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _97 = _75 - _63;
  float _98 = _76 - _64;
  float _99 = _77 - _65;
  float _100 = _92 * _97;
  float _101 = _92 * _98;
  float _102 = _92 * _99;
  float _103 = _100 + _63;
  float _104 = _101 + _64;
  float _105 = _102 + _65;
  float _106 = dot(float3(_103, _104, _105), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _110 = t0[0].SExposureData_020;
  float _112 = t0[0].SExposureData_004;
  float _114 = cb2_018x * 0.5f;
  float _115 = _114 * cb2_018y;
  float _116 = _112.x - _115;
  float _117 = cb2_018y * cb2_018x;
  float _118 = 1.0f / _117;
  float _119 = _116 * _118;
  float _120 = _106 / _110.x;
  float _121 = _120 * 5464.01611328125f;
  float _122 = _121 + 9.99999993922529e-09f;
  float _123 = log2(_122);
  float _124 = _123 - _116;
  float _125 = _124 * _118;
  float _126 = saturate(_125);
  float2 _127 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _126), 0.0f);
  float _130 = max(_127.y, 1.0000000116860974e-07f);
  float _131 = _127.x / _130;
  float _132 = _131 + _119;
  float _133 = _132 / _118;
  float _134 = _133 - _112.x;
  float _135 = -0.0f - _134;
  float _137 = _135 - cb2_027x;
  float _138 = max(0.0f, _137);
  float _140 = cb2_026z * _138;
  float _141 = _134 - cb2_027x;
  float _142 = max(0.0f, _141);
  float _144 = cb2_026w * _142;
  bool _145 = (_134 < 0.0f);
  float _146 = select(_145, _140, _144);
  float _147 = exp2(_146);
  float _148 = _147 * _103;
  float _149 = _147 * _104;
  float _150 = _147 * _105;
  float _155 = cb2_024y * _93.x;
  float _156 = cb2_024z * _93.y;
  float _157 = cb2_024w * _93.z;
  float _158 = _155 + _148;
  float _159 = _156 + _149;
  float _160 = _157 + _150;
  float _165 = _158 * cb2_025x;
  float _166 = _159 * cb2_025y;
  float _167 = _160 * cb2_025z;
  float _168 = dot(float3(_165, _166, _167), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _169 = t0[0].SExposureData_012;
  float _171 = _168 * 5464.01611328125f;
  float _172 = _171 * _169.x;
  float _173 = _172 + 9.99999993922529e-09f;
  float _174 = log2(_173);
  float _175 = _174 + 16.929765701293945f;
  float _176 = _175 * 0.05734497308731079f;
  float _177 = saturate(_176);
  float _178 = _177 * _177;
  float _179 = _177 * 2.0f;
  float _180 = 3.0f - _179;
  float _181 = _178 * _180;
  float _182 = _166 * 0.8450999855995178f;
  float _183 = _167 * 0.14589999616146088f;
  float _184 = _182 + _183;
  float _185 = _184 * 2.4890189170837402f;
  float _186 = _184 * 0.3754962384700775f;
  float _187 = _184 * 2.811495304107666f;
  float _188 = _184 * 5.519708156585693f;
  float _189 = _168 - _185;
  float _190 = _181 * _189;
  float _191 = _190 + _185;
  float _192 = _181 * 0.5f;
  float _193 = _192 + 0.5f;
  float _194 = _193 * _189;
  float _195 = _194 + _185;
  float _196 = _165 - _186;
  float _197 = _166 - _187;
  float _198 = _167 - _188;
  float _199 = _193 * _196;
  float _200 = _193 * _197;
  float _201 = _193 * _198;
  float _202 = _199 + _186;
  float _203 = _200 + _187;
  float _204 = _201 + _188;
  float _205 = 1.0f / _195;
  float _206 = _191 * _205;
  float _207 = _206 * _202;
  float _208 = _206 * _203;
  float _209 = _206 * _204;
  float _213 = cb2_020x * TEXCOORD0_centroid.x;
  float _214 = cb2_020y * TEXCOORD0_centroid.y;
  float _217 = _213 + cb2_020z;
  float _218 = _214 + cb2_020w;
  float _221 = dot(float2(_217, _218), float2(_217, _218));
  float _222 = 1.0f - _221;
  float _223 = saturate(_222);
  float _224 = log2(_223);
  float _225 = _224 * cb2_021w;
  float _226 = exp2(_225);
  float _230 = _207 - cb2_021x;
  float _231 = _208 - cb2_021y;
  float _232 = _209 - cb2_021z;
  float _233 = _230 * _226;
  float _234 = _231 * _226;
  float _235 = _232 * _226;
  float _236 = _233 + cb2_021x;
  float _237 = _234 + cb2_021y;
  float _238 = _235 + cb2_021z;
  float _239 = t0[0].SExposureData_000;
  float _241 = max(_110.x, 0.0010000000474974513f);
  float _242 = 1.0f / _241;
  float _243 = _242 * _239.x;
  bool _246 = ((uint)(cb2_069y) == 0);
  float _252;
  float _253;
  float _254;
  float _308;
  float _309;
  float _310;
  float _356;
  float _357;
  float _358;
  float _403;
  float _404;
  float _405;
  float _406;
  float _455;
  float _456;
  float _457;
  float _458;
  float _483;
  float _484;
  float _485;
  float _586;
  float _587;
  float _588;
  float _613;
  float _625;
  float _653;
  float _665;
  float _677;
  float _678;
  float _679;
  float _706;
  float _707;
  float _708;
  if (!_246) {
    float _248 = _243 * _236;
    float _249 = _243 * _237;
    float _250 = _243 * _238;
    _252 = _248;
    _253 = _249;
    _254 = _250;
  } else {
    _252 = _236;
    _253 = _237;
    _254 = _238;
  }
  float _255 = _252 * 0.6130970120429993f;
  float _256 = mad(0.33952298760414124f, _253, _255);
  float _257 = mad(0.04737899824976921f, _254, _256);
  float _258 = _252 * 0.07019399851560593f;
  float _259 = mad(0.9163540005683899f, _253, _258);
  float _260 = mad(0.013451999984681606f, _254, _259);
  float _261 = _252 * 0.02061600051820278f;
  float _262 = mad(0.10956999659538269f, _253, _261);
  float _263 = mad(0.8698149919509888f, _254, _262);
  float _264 = log2(_257);
  float _265 = log2(_260);
  float _266 = log2(_263);
  float _267 = _264 * 0.04211956635117531f;
  float _268 = _265 * 0.04211956635117531f;
  float _269 = _266 * 0.04211956635117531f;
  float _270 = _267 + 0.6252607107162476f;
  float _271 = _268 + 0.6252607107162476f;
  float _272 = _269 + 0.6252607107162476f;
  float4 _273 = t6.SampleLevel(s2_space2, float3(_270, _271, _272), 0.0f);
  bool _279 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_279 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _283 = cb2_017x * _273.x;
    float _284 = cb2_017x * _273.y;
    float _285 = cb2_017x * _273.z;
    float _287 = _283 + cb2_017y;
    float _288 = _284 + cb2_017y;
    float _289 = _285 + cb2_017y;
    float _290 = exp2(_287);
    float _291 = exp2(_288);
    float _292 = exp2(_289);
    float _293 = _290 + 1.0f;
    float _294 = _291 + 1.0f;
    float _295 = _292 + 1.0f;
    float _296 = 1.0f / _293;
    float _297 = 1.0f / _294;
    float _298 = 1.0f / _295;
    float _300 = cb2_017z * _296;
    float _301 = cb2_017z * _297;
    float _302 = cb2_017z * _298;
    float _304 = _300 + cb2_017w;
    float _305 = _301 + cb2_017w;
    float _306 = _302 + cb2_017w;
    _308 = _304;
    _309 = _305;
    _310 = _306;
  } else {
    _308 = _273.x;
    _309 = _273.y;
    _310 = _273.z;
  }
  float _311 = _308 * 23.0f;
  float _312 = _311 + -14.473931312561035f;
  float _313 = exp2(_312);
  float _314 = _309 * 23.0f;
  float _315 = _314 + -14.473931312561035f;
  float _316 = exp2(_315);
  float _317 = _310 * 23.0f;
  float _318 = _317 + -14.473931312561035f;
  float _319 = exp2(_318);
  float _324 = cb2_004x * TEXCOORD0_centroid.x;
  float _325 = cb2_004y * TEXCOORD0_centroid.y;
  float _328 = _324 + cb2_004z;
  float _329 = _325 + cb2_004w;
  float4 _335 = t7.Sample(s2_space2, float2(_328, _329));
  float _340 = _335.x * cb2_003x;
  float _341 = _335.y * cb2_003y;
  float _342 = _335.z * cb2_003z;
  float _343 = _335.w * cb2_003w;
  float _346 = _343 + cb2_026y;
  float _347 = saturate(_346);
  bool _350 = ((uint)(cb2_069y) == 0);
  if (!_350) {
    float _352 = _340 * _243;
    float _353 = _341 * _243;
    float _354 = _342 * _243;
    _356 = _352;
    _357 = _353;
    _358 = _354;
  } else {
    _356 = _340;
    _357 = _341;
    _358 = _342;
  }
  bool _361 = ((uint)(cb2_028x) == 2);
  bool _362 = ((uint)(cb2_028x) == 3);
  int _363 = (uint)(cb2_028x) & -2;
  bool _364 = (_363 == 2);
  bool _365 = ((uint)(cb2_028x) == 6);
  bool _366 = _364 || _365;
  if (_366) {
    float _368 = _356 * _347;
    float _369 = _357 * _347;
    float _370 = _358 * _347;
    float _371 = _347 * _347;
    _403 = _368;
    _404 = _369;
    _405 = _370;
    _406 = _371;
  } else {
    bool _373 = ((uint)(cb2_028x) == 4);
    if (_373) {
      float _375 = _356 + -1.0f;
      float _376 = _357 + -1.0f;
      float _377 = _358 + -1.0f;
      float _378 = _347 + -1.0f;
      float _379 = _375 * _347;
      float _380 = _376 * _347;
      float _381 = _377 * _347;
      float _382 = _378 * _347;
      float _383 = _379 + 1.0f;
      float _384 = _380 + 1.0f;
      float _385 = _381 + 1.0f;
      float _386 = _382 + 1.0f;
      _403 = _383;
      _404 = _384;
      _405 = _385;
      _406 = _386;
    } else {
      bool _388 = ((uint)(cb2_028x) == 5);
      if (_388) {
        float _390 = _356 + -0.5f;
        float _391 = _357 + -0.5f;
        float _392 = _358 + -0.5f;
        float _393 = _347 + -0.5f;
        float _394 = _390 * _347;
        float _395 = _391 * _347;
        float _396 = _392 * _347;
        float _397 = _393 * _347;
        float _398 = _394 + 0.5f;
        float _399 = _395 + 0.5f;
        float _400 = _396 + 0.5f;
        float _401 = _397 + 0.5f;
        _403 = _398;
        _404 = _399;
        _405 = _400;
        _406 = _401;
      } else {
        _403 = _356;
        _404 = _357;
        _405 = _358;
        _406 = _347;
      }
    }
  }
  if (_361) {
    float _408 = _403 + _313;
    float _409 = _404 + _316;
    float _410 = _405 + _319;
    _455 = _408;
    _456 = _409;
    _457 = _410;
    _458 = cb2_025w;
  } else {
    if (_362) {
      float _413 = 1.0f - _403;
      float _414 = 1.0f - _404;
      float _415 = 1.0f - _405;
      float _416 = _413 * _313;
      float _417 = _414 * _316;
      float _418 = _415 * _319;
      float _419 = _416 + _403;
      float _420 = _417 + _404;
      float _421 = _418 + _405;
      _455 = _419;
      _456 = _420;
      _457 = _421;
      _458 = cb2_025w;
    } else {
      bool _423 = ((uint)(cb2_028x) == 4);
      if (_423) {
        float _425 = _403 * _313;
        float _426 = _404 * _316;
        float _427 = _405 * _319;
        _455 = _425;
        _456 = _426;
        _457 = _427;
        _458 = cb2_025w;
      } else {
        bool _429 = ((uint)(cb2_028x) == 5);
        if (_429) {
          float _431 = _313 * 2.0f;
          float _432 = _431 * _403;
          float _433 = _316 * 2.0f;
          float _434 = _433 * _404;
          float _435 = _319 * 2.0f;
          float _436 = _435 * _405;
          _455 = _432;
          _456 = _434;
          _457 = _436;
          _458 = cb2_025w;
        } else {
          if (_365) {
            float _439 = _313 - _403;
            float _440 = _316 - _404;
            float _441 = _319 - _405;
            _455 = _439;
            _456 = _440;
            _457 = _441;
            _458 = cb2_025w;
          } else {
            float _443 = _403 - _313;
            float _444 = _404 - _316;
            float _445 = _405 - _319;
            float _446 = _406 * _443;
            float _447 = _406 * _444;
            float _448 = _406 * _445;
            float _449 = _446 + _313;
            float _450 = _447 + _316;
            float _451 = _448 + _319;
            float _452 = 1.0f - _406;
            float _453 = _452 * cb2_025w;
            _455 = _449;
            _456 = _450;
            _457 = _451;
            _458 = _453;
          }
        }
      }
    }
  }
  float _464 = cb2_016x - _455;
  float _465 = cb2_016y - _456;
  float _466 = cb2_016z - _457;
  float _467 = _464 * cb2_016w;
  float _468 = _465 * cb2_016w;
  float _469 = _466 * cb2_016w;
  float _470 = _467 + _455;
  float _471 = _468 + _456;
  float _472 = _469 + _457;
  bool _475 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_475 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _479 = cb2_024x * _470;
    float _480 = cb2_024x * _471;
    float _481 = cb2_024x * _472;
    _483 = _479;
    _484 = _480;
    _485 = _481;
  } else {
    _483 = _470;
    _484 = _471;
    _485 = _472;
  }
  float _486 = _483 * 0.9708889722824097f;
  float _487 = mad(0.026962999254465103f, _484, _486);
  float _488 = mad(0.002148000057786703f, _485, _487);
  float _489 = _483 * 0.01088900025933981f;
  float _490 = mad(0.9869629740715027f, _484, _489);
  float _491 = mad(0.002148000057786703f, _485, _490);
  float _492 = mad(0.026962999254465103f, _484, _489);
  float _493 = mad(0.9621480107307434f, _485, _492);
  if (_475) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _498 = cb1_018y * 0.10000000149011612f;
        float _499 = log2(cb1_018z);
        float _500 = _499 + -13.287712097167969f;
        float _501 = _500 * 1.4929734468460083f;
        float _502 = _501 + 18.0f;
        float _503 = exp2(_502);
        float _504 = _503 * 0.18000000715255737f;
        float _505 = abs(_504);
        float _506 = log2(_505);
        float _507 = _506 * 1.5f;
        float _508 = exp2(_507);
        float _509 = _508 * _498;
        float _510 = _509 / cb1_018z;
        float _511 = _510 + -0.07636754959821701f;
        float _512 = _506 * 1.2750000953674316f;
        float _513 = exp2(_512);
        float _514 = _513 * 0.07636754959821701f;
        float _515 = cb1_018y * 0.011232397519052029f;
        float _516 = _515 * _508;
        float _517 = _516 / cb1_018z;
        float _518 = _514 - _517;
        float _519 = _513 + -0.11232396960258484f;
        float _520 = _519 * _498;
        float _521 = _520 / cb1_018z;
        float _522 = _521 * cb1_018z;
        float _523 = abs(_488);
        float _524 = abs(_491);
        float _525 = abs(_493);
        float _526 = log2(_523);
        float _527 = log2(_524);
        float _528 = log2(_525);
        float _529 = _526 * 1.5f;
        float _530 = _527 * 1.5f;
        float _531 = _528 * 1.5f;
        float _532 = exp2(_529);
        float _533 = exp2(_530);
        float _534 = exp2(_531);
        float _535 = _532 * _522;
        float _536 = _533 * _522;
        float _537 = _534 * _522;
        float _538 = _526 * 1.2750000953674316f;
        float _539 = _527 * 1.2750000953674316f;
        float _540 = _528 * 1.2750000953674316f;
        float _541 = exp2(_538);
        float _542 = exp2(_539);
        float _543 = exp2(_540);
        float _544 = _541 * _511;
        float _545 = _542 * _511;
        float _546 = _543 * _511;
        float _547 = _544 + _518;
        float _548 = _545 + _518;
        float _549 = _546 + _518;
        float _550 = _535 / _547;
        float _551 = _536 / _548;
        float _552 = _537 / _549;
        float _553 = _550 * 9.999999747378752e-05f;
        float _554 = _551 * 9.999999747378752e-05f;
        float _555 = _552 * 9.999999747378752e-05f;
        float _556 = 5000.0f / cb1_018y;
        float _557 = _553 * _556;
        float _558 = _554 * _556;
        float _559 = _555 * _556;
        _586 = _557;
        _587 = _558;
        _588 = _559;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_488, _491, _493));
      _586 = tonemapped.x, _587 = tonemapped.y, _588 = tonemapped.z;
    }
      } else {
        float _561 = _488 + 0.020616600289940834f;
        float _562 = _491 + 0.020616600289940834f;
        float _563 = _493 + 0.020616600289940834f;
        float _564 = _561 * _488;
        float _565 = _562 * _491;
        float _566 = _563 * _493;
        float _567 = _564 + -7.456949970219284e-05f;
        float _568 = _565 + -7.456949970219284e-05f;
        float _569 = _566 + -7.456949970219284e-05f;
        float _570 = _488 * 0.9837960004806519f;
        float _571 = _491 * 0.9837960004806519f;
        float _572 = _493 * 0.9837960004806519f;
        float _573 = _570 + 0.4336790144443512f;
        float _574 = _571 + 0.4336790144443512f;
        float _575 = _572 + 0.4336790144443512f;
        float _576 = _573 * _488;
        float _577 = _574 * _491;
        float _578 = _575 * _493;
        float _579 = _576 + 0.24617899954319f;
        float _580 = _577 + 0.24617899954319f;
        float _581 = _578 + 0.24617899954319f;
        float _582 = _567 / _579;
        float _583 = _568 / _580;
        float _584 = _569 / _581;
        _586 = _582;
        _587 = _583;
        _588 = _584;
      }
      float _589 = _586 * 1.6047500371932983f;
      float _590 = mad(-0.5310800075531006f, _587, _589);
      float _591 = mad(-0.07366999983787537f, _588, _590);
      float _592 = _586 * -0.10208000242710114f;
      float _593 = mad(1.1081299781799316f, _587, _592);
      float _594 = mad(-0.006049999967217445f, _588, _593);
      float _595 = _586 * -0.0032599999103695154f;
      float _596 = mad(-0.07275000214576721f, _587, _595);
      float _597 = mad(1.0760200023651123f, _588, _596);
      if (_475) {
        // float _599 = max(_591, 0.0f);
        // float _600 = max(_594, 0.0f);
        // float _601 = max(_597, 0.0f);
        // bool _602 = !(_599 >= 0.0030399328097701073f);
        // if (!_602) {
        //   float _604 = abs(_599);
        //   float _605 = log2(_604);
        //   float _606 = _605 * 0.4166666567325592f;
        //   float _607 = exp2(_606);
        //   float _608 = _607 * 1.0549999475479126f;
        //   float _609 = _608 + -0.054999999701976776f;
        //   _613 = _609;
        // } else {
        //   float _611 = _599 * 12.923210144042969f;
        //   _613 = _611;
        // }
        // bool _614 = !(_600 >= 0.0030399328097701073f);
        // if (!_614) {
        //   float _616 = abs(_600);
        //   float _617 = log2(_616);
        //   float _618 = _617 * 0.4166666567325592f;
        //   float _619 = exp2(_618);
        //   float _620 = _619 * 1.0549999475479126f;
        //   float _621 = _620 + -0.054999999701976776f;
        //   _625 = _621;
        // } else {
        //   float _623 = _600 * 12.923210144042969f;
        //   _625 = _623;
        // }
        // bool _626 = !(_601 >= 0.0030399328097701073f);
        // if (!_626) {
        //   float _628 = abs(_601);
        //   float _629 = log2(_628);
        //   float _630 = _629 * 0.4166666567325592f;
        //   float _631 = exp2(_630);
        //   float _632 = _631 * 1.0549999475479126f;
        //   float _633 = _632 + -0.054999999701976776f;
        //   _706 = _613;
        //   _707 = _625;
        //   _708 = _633;
        // } else {
        //   float _635 = _601 * 12.923210144042969f;
        //   _706 = _613;
        //   _707 = _625;
        //   _708 = _635;
        // }
        _706 = renodx::color::srgb::EncodeSafe(_591);
        _707 = renodx::color::srgb::EncodeSafe(_594);
        _708 = renodx::color::srgb::EncodeSafe(_597);

      } else {
        float _637 = saturate(_591);
        float _638 = saturate(_594);
        float _639 = saturate(_597);
        bool _640 = ((uint)(cb1_018w) == -2);
        if (!_640) {
          bool _642 = !(_637 >= 0.0030399328097701073f);
          if (!_642) {
            float _644 = abs(_637);
            float _645 = log2(_644);
            float _646 = _645 * 0.4166666567325592f;
            float _647 = exp2(_646);
            float _648 = _647 * 1.0549999475479126f;
            float _649 = _648 + -0.054999999701976776f;
            _653 = _649;
          } else {
            float _651 = _637 * 12.923210144042969f;
            _653 = _651;
          }
          bool _654 = !(_638 >= 0.0030399328097701073f);
          if (!_654) {
            float _656 = abs(_638);
            float _657 = log2(_656);
            float _658 = _657 * 0.4166666567325592f;
            float _659 = exp2(_658);
            float _660 = _659 * 1.0549999475479126f;
            float _661 = _660 + -0.054999999701976776f;
            _665 = _661;
          } else {
            float _663 = _638 * 12.923210144042969f;
            _665 = _663;
          }
          bool _666 = !(_639 >= 0.0030399328097701073f);
          if (!_666) {
            float _668 = abs(_639);
            float _669 = log2(_668);
            float _670 = _669 * 0.4166666567325592f;
            float _671 = exp2(_670);
            float _672 = _671 * 1.0549999475479126f;
            float _673 = _672 + -0.054999999701976776f;
            _677 = _653;
            _678 = _665;
            _679 = _673;
          } else {
            float _675 = _639 * 12.923210144042969f;
            _677 = _653;
            _678 = _665;
            _679 = _675;
          }
        } else {
          _677 = _637;
          _678 = _638;
          _679 = _639;
        }
        float _684 = abs(_677);
        float _685 = abs(_678);
        float _686 = abs(_679);
        float _687 = log2(_684);
        float _688 = log2(_685);
        float _689 = log2(_686);
        float _690 = _687 * cb2_000z;
        float _691 = _688 * cb2_000z;
        float _692 = _689 * cb2_000z;
        float _693 = exp2(_690);
        float _694 = exp2(_691);
        float _695 = exp2(_692);
        float _696 = _693 * cb2_000y;
        float _697 = _694 * cb2_000y;
        float _698 = _695 * cb2_000y;
        float _699 = _696 + cb2_000x;
        float _700 = _697 + cb2_000x;
        float _701 = _698 + cb2_000x;
        float _702 = saturate(_699);
        float _703 = saturate(_700);
        float _704 = saturate(_701);
        _706 = _702;
        _707 = _703;
        _708 = _704;
      }
      float _712 = cb2_023x * TEXCOORD0_centroid.x;
      float _713 = cb2_023y * TEXCOORD0_centroid.y;
      float _716 = _712 + cb2_023z;
      float _717 = _713 + cb2_023w;
      float4 _720 = t10.SampleLevel(s0_space2, float2(_716, _717), 0.0f);
      float _722 = _720.x + -0.5f;
      float _723 = _722 * cb2_022x;
      float _724 = _723 + 0.5f;
      float _725 = _724 * 2.0f;
      float _726 = _725 * _706;
      float _727 = _725 * _707;
      float _728 = _725 * _708;
      float _732 = float((uint)(cb2_019z));
      float _733 = float((uint)(cb2_019w));
      float _734 = _732 + SV_Position.x;
      float _735 = _733 + SV_Position.y;
      uint _736 = uint(_734);
      uint _737 = uint(_735);
      uint _740 = cb2_019x + -1u;
      uint _741 = cb2_019y + -1u;
      int _742 = _736 & _740;
      int _743 = _737 & _741;
      float4 _744 = t3.Load(int3(_742, _743, 0));
      float _748 = _744.x * 2.0f;
      float _749 = _744.y * 2.0f;
      float _750 = _744.z * 2.0f;
      float _751 = _748 + -1.0f;
      float _752 = _749 + -1.0f;
      float _753 = _750 + -1.0f;
      float _754 = _751 * _458;
      float _755 = _752 * _458;
      float _756 = _753 * _458;
      float _757 = _754 + _726;
      float _758 = _755 + _727;
      float _759 = _756 + _728;
      float _760 = dot(float3(_757, _758, _759), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _757;
      SV_Target.y = _758;
      SV_Target.z = _759;
      SV_Target.w = _760;
      SV_Target_1.x = _760;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

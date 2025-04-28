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
  float _602;
  float _603;
  float _604;
  float _629;
  float _641;
  float _669;
  float _681;
  float _693;
  float _694;
  float _695;
  float _722;
  float _723;
  float _724;
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
  float _502 = _499 * 0.9708889722824097f;
  float _503 = mad(0.026962999254465103f, _500, _502);
  float _504 = mad(0.002148000057786703f, _501, _503);
  float _505 = _499 * 0.01088900025933981f;
  float _506 = mad(0.9869629740715027f, _500, _505);
  float _507 = mad(0.002148000057786703f, _501, _506);
  float _508 = mad(0.026962999254465103f, _500, _505);
  float _509 = mad(0.9621480107307434f, _501, _508);
  if (_491) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _514 = cb1_018y * 0.10000000149011612f;
        float _515 = log2(cb1_018z);
        float _516 = _515 + -13.287712097167969f;
        float _517 = _516 * 1.4929734468460083f;
        float _518 = _517 + 18.0f;
        float _519 = exp2(_518);
        float _520 = _519 * 0.18000000715255737f;
        float _521 = abs(_520);
        float _522 = log2(_521);
        float _523 = _522 * 1.5f;
        float _524 = exp2(_523);
        float _525 = _524 * _514;
        float _526 = _525 / cb1_018z;
        float _527 = _526 + -0.07636754959821701f;
        float _528 = _522 * 1.2750000953674316f;
        float _529 = exp2(_528);
        float _530 = _529 * 0.07636754959821701f;
        float _531 = cb1_018y * 0.011232397519052029f;
        float _532 = _531 * _524;
        float _533 = _532 / cb1_018z;
        float _534 = _530 - _533;
        float _535 = _529 + -0.11232396960258484f;
        float _536 = _535 * _514;
        float _537 = _536 / cb1_018z;
        float _538 = _537 * cb1_018z;
        float _539 = abs(_504);
        float _540 = abs(_507);
        float _541 = abs(_509);
        float _542 = log2(_539);
        float _543 = log2(_540);
        float _544 = log2(_541);
        float _545 = _542 * 1.5f;
        float _546 = _543 * 1.5f;
        float _547 = _544 * 1.5f;
        float _548 = exp2(_545);
        float _549 = exp2(_546);
        float _550 = exp2(_547);
        float _551 = _548 * _538;
        float _552 = _549 * _538;
        float _553 = _550 * _538;
        float _554 = _542 * 1.2750000953674316f;
        float _555 = _543 * 1.2750000953674316f;
        float _556 = _544 * 1.2750000953674316f;
        float _557 = exp2(_554);
        float _558 = exp2(_555);
        float _559 = exp2(_556);
        float _560 = _557 * _527;
        float _561 = _558 * _527;
        float _562 = _559 * _527;
        float _563 = _560 + _534;
        float _564 = _561 + _534;
        float _565 = _562 + _534;
        float _566 = _551 / _563;
        float _567 = _552 / _564;
        float _568 = _553 / _565;
        float _569 = _566 * 9.999999747378752e-05f;
        float _570 = _567 * 9.999999747378752e-05f;
        float _571 = _568 * 9.999999747378752e-05f;
        float _572 = 5000.0f / cb1_018y;
        float _573 = _569 * _572;
        float _574 = _570 * _572;
        float _575 = _571 * _572;
        _602 = _573;
        _603 = _574;
        _604 = _575;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_504, _507, _509));
      _602 = tonemapped.x, _603 = tonemapped.y, _604 = tonemapped.z;
    }
      } else {
        float _577 = _504 + 0.020616600289940834f;
        float _578 = _507 + 0.020616600289940834f;
        float _579 = _509 + 0.020616600289940834f;
        float _580 = _577 * _504;
        float _581 = _578 * _507;
        float _582 = _579 * _509;
        float _583 = _580 + -7.456949970219284e-05f;
        float _584 = _581 + -7.456949970219284e-05f;
        float _585 = _582 + -7.456949970219284e-05f;
        float _586 = _504 * 0.9837960004806519f;
        float _587 = _507 * 0.9837960004806519f;
        float _588 = _509 * 0.9837960004806519f;
        float _589 = _586 + 0.4336790144443512f;
        float _590 = _587 + 0.4336790144443512f;
        float _591 = _588 + 0.4336790144443512f;
        float _592 = _589 * _504;
        float _593 = _590 * _507;
        float _594 = _591 * _509;
        float _595 = _592 + 0.24617899954319f;
        float _596 = _593 + 0.24617899954319f;
        float _597 = _594 + 0.24617899954319f;
        float _598 = _583 / _595;
        float _599 = _584 / _596;
        float _600 = _585 / _597;
        _602 = _598;
        _603 = _599;
        _604 = _600;
      }
      float _605 = _602 * 1.6047500371932983f;
      float _606 = mad(-0.5310800075531006f, _603, _605);
      float _607 = mad(-0.07366999983787537f, _604, _606);
      float _608 = _602 * -0.10208000242710114f;
      float _609 = mad(1.1081299781799316f, _603, _608);
      float _610 = mad(-0.006049999967217445f, _604, _609);
      float _611 = _602 * -0.0032599999103695154f;
      float _612 = mad(-0.07275000214576721f, _603, _611);
      float _613 = mad(1.0760200023651123f, _604, _612);
      if (_491) {
        // float _615 = max(_607, 0.0f);
        // float _616 = max(_610, 0.0f);
        // float _617 = max(_613, 0.0f);
        // bool _618 = !(_615 >= 0.0030399328097701073f);
        // if (!_618) {
        //   float _620 = abs(_615);
        //   float _621 = log2(_620);
        //   float _622 = _621 * 0.4166666567325592f;
        //   float _623 = exp2(_622);
        //   float _624 = _623 * 1.0549999475479126f;
        //   float _625 = _624 + -0.054999999701976776f;
        //   _629 = _625;
        // } else {
        //   float _627 = _615 * 12.923210144042969f;
        //   _629 = _627;
        // }
        // bool _630 = !(_616 >= 0.0030399328097701073f);
        // if (!_630) {
        //   float _632 = abs(_616);
        //   float _633 = log2(_632);
        //   float _634 = _633 * 0.4166666567325592f;
        //   float _635 = exp2(_634);
        //   float _636 = _635 * 1.0549999475479126f;
        //   float _637 = _636 + -0.054999999701976776f;
        //   _641 = _637;
        // } else {
        //   float _639 = _616 * 12.923210144042969f;
        //   _641 = _639;
        // }
        // bool _642 = !(_617 >= 0.0030399328097701073f);
        // if (!_642) {
        //   float _644 = abs(_617);
        //   float _645 = log2(_644);
        //   float _646 = _645 * 0.4166666567325592f;
        //   float _647 = exp2(_646);
        //   float _648 = _647 * 1.0549999475479126f;
        //   float _649 = _648 + -0.054999999701976776f;
        //   _722 = _629;
        //   _723 = _641;
        //   _724 = _649;
        // } else {
        //   float _651 = _617 * 12.923210144042969f;
        //   _722 = _629;
        //   _723 = _641;
        //   _724 = _651;
        // }
        _722 = renodx::color::srgb::EncodeSafe(_607);
        _723 = renodx::color::srgb::EncodeSafe(_610);
        _724 = renodx::color::srgb::EncodeSafe(_613);

      } else {
        float _653 = saturate(_607);
        float _654 = saturate(_610);
        float _655 = saturate(_613);
        bool _656 = ((uint)(cb1_018w) == -2);
        if (!_656) {
          bool _658 = !(_653 >= 0.0030399328097701073f);
          if (!_658) {
            float _660 = abs(_653);
            float _661 = log2(_660);
            float _662 = _661 * 0.4166666567325592f;
            float _663 = exp2(_662);
            float _664 = _663 * 1.0549999475479126f;
            float _665 = _664 + -0.054999999701976776f;
            _669 = _665;
          } else {
            float _667 = _653 * 12.923210144042969f;
            _669 = _667;
          }
          bool _670 = !(_654 >= 0.0030399328097701073f);
          if (!_670) {
            float _672 = abs(_654);
            float _673 = log2(_672);
            float _674 = _673 * 0.4166666567325592f;
            float _675 = exp2(_674);
            float _676 = _675 * 1.0549999475479126f;
            float _677 = _676 + -0.054999999701976776f;
            _681 = _677;
          } else {
            float _679 = _654 * 12.923210144042969f;
            _681 = _679;
          }
          bool _682 = !(_655 >= 0.0030399328097701073f);
          if (!_682) {
            float _684 = abs(_655);
            float _685 = log2(_684);
            float _686 = _685 * 0.4166666567325592f;
            float _687 = exp2(_686);
            float _688 = _687 * 1.0549999475479126f;
            float _689 = _688 + -0.054999999701976776f;
            _693 = _669;
            _694 = _681;
            _695 = _689;
          } else {
            float _691 = _655 * 12.923210144042969f;
            _693 = _669;
            _694 = _681;
            _695 = _691;
          }
        } else {
          _693 = _653;
          _694 = _654;
          _695 = _655;
        }
        float _700 = abs(_693);
        float _701 = abs(_694);
        float _702 = abs(_695);
        float _703 = log2(_700);
        float _704 = log2(_701);
        float _705 = log2(_702);
        float _706 = _703 * cb2_000z;
        float _707 = _704 * cb2_000z;
        float _708 = _705 * cb2_000z;
        float _709 = exp2(_706);
        float _710 = exp2(_707);
        float _711 = exp2(_708);
        float _712 = _709 * cb2_000y;
        float _713 = _710 * cb2_000y;
        float _714 = _711 * cb2_000y;
        float _715 = _712 + cb2_000x;
        float _716 = _713 + cb2_000x;
        float _717 = _714 + cb2_000x;
        float _718 = saturate(_715);
        float _719 = saturate(_716);
        float _720 = saturate(_717);
        _722 = _718;
        _723 = _719;
        _724 = _720;
      }
      float _728 = cb2_023x * TEXCOORD0_centroid.x;
      float _729 = cb2_023y * TEXCOORD0_centroid.y;
      float _732 = _728 + cb2_023z;
      float _733 = _729 + cb2_023w;
      float4 _736 = t9.SampleLevel(s0_space2, float2(_732, _733), 0.0f);
      float _738 = _736.x + -0.5f;
      float _739 = _738 * cb2_022x;
      float _740 = _739 + 0.5f;
      float _741 = _740 * 2.0f;
      float _742 = _741 * _722;
      float _743 = _741 * _723;
      float _744 = _741 * _724;
      float _748 = float((uint)(cb2_019z));
      float _749 = float((uint)(cb2_019w));
      float _750 = _748 + SV_Position.x;
      float _751 = _749 + SV_Position.y;
      uint _752 = uint(_750);
      uint _753 = uint(_751);
      uint _756 = cb2_019x + -1u;
      uint _757 = cb2_019y + -1u;
      int _758 = _752 & _756;
      int _759 = _753 & _757;
      float4 _760 = t3.Load(int3(_758, _759, 0));
      float _764 = _760.x * 2.0f;
      float _765 = _760.y * 2.0f;
      float _766 = _760.z * 2.0f;
      float _767 = _764 + -1.0f;
      float _768 = _765 + -1.0f;
      float _769 = _766 + -1.0f;
      float _770 = _767 * _474;
      float _771 = _768 * _474;
      float _772 = _769 * _474;
      float _773 = _770 + _742;
      float _774 = _771 + _743;
      float _775 = _772 + _744;
      float _776 = dot(float3(_773, _774, _775), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _773;
      SV_Target.y = _774;
      SV_Target.z = _775;
      SV_Target.w = _776;
      SV_Target_1.x = _776;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

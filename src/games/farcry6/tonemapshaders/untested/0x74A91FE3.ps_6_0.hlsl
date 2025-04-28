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
  float _623;
  float _624;
  float _625;
  float _650;
  float _662;
  float _690;
  float _702;
  float _714;
  float _715;
  float _716;
  float _743;
  float _744;
  float _745;
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
  float _523 = _520 * 0.9708889722824097f;
  float _524 = mad(0.026962999254465103f, _521, _523);
  float _525 = mad(0.002148000057786703f, _522, _524);
  float _526 = _520 * 0.01088900025933981f;
  float _527 = mad(0.9869629740715027f, _521, _526);
  float _528 = mad(0.002148000057786703f, _522, _527);
  float _529 = mad(0.026962999254465103f, _521, _526);
  float _530 = mad(0.9621480107307434f, _522, _529);
  if (_512) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _535 = cb1_018y * 0.10000000149011612f;
        float _536 = log2(cb1_018z);
        float _537 = _536 + -13.287712097167969f;
        float _538 = _537 * 1.4929734468460083f;
        float _539 = _538 + 18.0f;
        float _540 = exp2(_539);
        float _541 = _540 * 0.18000000715255737f;
        float _542 = abs(_541);
        float _543 = log2(_542);
        float _544 = _543 * 1.5f;
        float _545 = exp2(_544);
        float _546 = _545 * _535;
        float _547 = _546 / cb1_018z;
        float _548 = _547 + -0.07636754959821701f;
        float _549 = _543 * 1.2750000953674316f;
        float _550 = exp2(_549);
        float _551 = _550 * 0.07636754959821701f;
        float _552 = cb1_018y * 0.011232397519052029f;
        float _553 = _552 * _545;
        float _554 = _553 / cb1_018z;
        float _555 = _551 - _554;
        float _556 = _550 + -0.11232396960258484f;
        float _557 = _556 * _535;
        float _558 = _557 / cb1_018z;
        float _559 = _558 * cb1_018z;
        float _560 = abs(_525);
        float _561 = abs(_528);
        float _562 = abs(_530);
        float _563 = log2(_560);
        float _564 = log2(_561);
        float _565 = log2(_562);
        float _566 = _563 * 1.5f;
        float _567 = _564 * 1.5f;
        float _568 = _565 * 1.5f;
        float _569 = exp2(_566);
        float _570 = exp2(_567);
        float _571 = exp2(_568);
        float _572 = _569 * _559;
        float _573 = _570 * _559;
        float _574 = _571 * _559;
        float _575 = _563 * 1.2750000953674316f;
        float _576 = _564 * 1.2750000953674316f;
        float _577 = _565 * 1.2750000953674316f;
        float _578 = exp2(_575);
        float _579 = exp2(_576);
        float _580 = exp2(_577);
        float _581 = _578 * _548;
        float _582 = _579 * _548;
        float _583 = _580 * _548;
        float _584 = _581 + _555;
        float _585 = _582 + _555;
        float _586 = _583 + _555;
        float _587 = _572 / _584;
        float _588 = _573 / _585;
        float _589 = _574 / _586;
        float _590 = _587 * 9.999999747378752e-05f;
        float _591 = _588 * 9.999999747378752e-05f;
        float _592 = _589 * 9.999999747378752e-05f;
        float _593 = 5000.0f / cb1_018y;
        float _594 = _590 * _593;
        float _595 = _591 * _593;
        float _596 = _592 * _593;
        _623 = _594;
        _624 = _595;
        _625 = _596;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_525, _528, _530));
      _623 = tonemapped.x, _624 = tonemapped.y, _625 = tonemapped.z;
    }
      } else {
        float _598 = _525 + 0.020616600289940834f;
        float _599 = _528 + 0.020616600289940834f;
        float _600 = _530 + 0.020616600289940834f;
        float _601 = _598 * _525;
        float _602 = _599 * _528;
        float _603 = _600 * _530;
        float _604 = _601 + -7.456949970219284e-05f;
        float _605 = _602 + -7.456949970219284e-05f;
        float _606 = _603 + -7.456949970219284e-05f;
        float _607 = _525 * 0.9837960004806519f;
        float _608 = _528 * 0.9837960004806519f;
        float _609 = _530 * 0.9837960004806519f;
        float _610 = _607 + 0.4336790144443512f;
        float _611 = _608 + 0.4336790144443512f;
        float _612 = _609 + 0.4336790144443512f;
        float _613 = _610 * _525;
        float _614 = _611 * _528;
        float _615 = _612 * _530;
        float _616 = _613 + 0.24617899954319f;
        float _617 = _614 + 0.24617899954319f;
        float _618 = _615 + 0.24617899954319f;
        float _619 = _604 / _616;
        float _620 = _605 / _617;
        float _621 = _606 / _618;
        _623 = _619;
        _624 = _620;
        _625 = _621;
      }
      float _626 = _623 * 1.6047500371932983f;
      float _627 = mad(-0.5310800075531006f, _624, _626);
      float _628 = mad(-0.07366999983787537f, _625, _627);
      float _629 = _623 * -0.10208000242710114f;
      float _630 = mad(1.1081299781799316f, _624, _629);
      float _631 = mad(-0.006049999967217445f, _625, _630);
      float _632 = _623 * -0.0032599999103695154f;
      float _633 = mad(-0.07275000214576721f, _624, _632);
      float _634 = mad(1.0760200023651123f, _625, _633);
      if (_512) {
        // float _636 = max(_628, 0.0f);
        // float _637 = max(_631, 0.0f);
        // float _638 = max(_634, 0.0f);
        // bool _639 = !(_636 >= 0.0030399328097701073f);
        // if (!_639) {
        //   float _641 = abs(_636);
        //   float _642 = log2(_641);
        //   float _643 = _642 * 0.4166666567325592f;
        //   float _644 = exp2(_643);
        //   float _645 = _644 * 1.0549999475479126f;
        //   float _646 = _645 + -0.054999999701976776f;
        //   _650 = _646;
        // } else {
        //   float _648 = _636 * 12.923210144042969f;
        //   _650 = _648;
        // }
        // bool _651 = !(_637 >= 0.0030399328097701073f);
        // if (!_651) {
        //   float _653 = abs(_637);
        //   float _654 = log2(_653);
        //   float _655 = _654 * 0.4166666567325592f;
        //   float _656 = exp2(_655);
        //   float _657 = _656 * 1.0549999475479126f;
        //   float _658 = _657 + -0.054999999701976776f;
        //   _662 = _658;
        // } else {
        //   float _660 = _637 * 12.923210144042969f;
        //   _662 = _660;
        // }
        // bool _663 = !(_638 >= 0.0030399328097701073f);
        // if (!_663) {
        //   float _665 = abs(_638);
        //   float _666 = log2(_665);
        //   float _667 = _666 * 0.4166666567325592f;
        //   float _668 = exp2(_667);
        //   float _669 = _668 * 1.0549999475479126f;
        //   float _670 = _669 + -0.054999999701976776f;
        //   _743 = _650;
        //   _744 = _662;
        //   _745 = _670;
        // } else {
        //   float _672 = _638 * 12.923210144042969f;
        //   _743 = _650;
        //   _744 = _662;
        //   _745 = _672;
        // }
        _743 = renodx::color::srgb::EncodeSafe(_628);
        _744 = renodx::color::srgb::EncodeSafe(_631);
        _745 = renodx::color::srgb::EncodeSafe(_634);

      } else {
        float _674 = saturate(_628);
        float _675 = saturate(_631);
        float _676 = saturate(_634);
        bool _677 = ((uint)(cb1_018w) == -2);
        if (!_677) {
          bool _679 = !(_674 >= 0.0030399328097701073f);
          if (!_679) {
            float _681 = abs(_674);
            float _682 = log2(_681);
            float _683 = _682 * 0.4166666567325592f;
            float _684 = exp2(_683);
            float _685 = _684 * 1.0549999475479126f;
            float _686 = _685 + -0.054999999701976776f;
            _690 = _686;
          } else {
            float _688 = _674 * 12.923210144042969f;
            _690 = _688;
          }
          bool _691 = !(_675 >= 0.0030399328097701073f);
          if (!_691) {
            float _693 = abs(_675);
            float _694 = log2(_693);
            float _695 = _694 * 0.4166666567325592f;
            float _696 = exp2(_695);
            float _697 = _696 * 1.0549999475479126f;
            float _698 = _697 + -0.054999999701976776f;
            _702 = _698;
          } else {
            float _700 = _675 * 12.923210144042969f;
            _702 = _700;
          }
          bool _703 = !(_676 >= 0.0030399328097701073f);
          if (!_703) {
            float _705 = abs(_676);
            float _706 = log2(_705);
            float _707 = _706 * 0.4166666567325592f;
            float _708 = exp2(_707);
            float _709 = _708 * 1.0549999475479126f;
            float _710 = _709 + -0.054999999701976776f;
            _714 = _690;
            _715 = _702;
            _716 = _710;
          } else {
            float _712 = _676 * 12.923210144042969f;
            _714 = _690;
            _715 = _702;
            _716 = _712;
          }
        } else {
          _714 = _674;
          _715 = _675;
          _716 = _676;
        }
        float _721 = abs(_714);
        float _722 = abs(_715);
        float _723 = abs(_716);
        float _724 = log2(_721);
        float _725 = log2(_722);
        float _726 = log2(_723);
        float _727 = _724 * cb2_000z;
        float _728 = _725 * cb2_000z;
        float _729 = _726 * cb2_000z;
        float _730 = exp2(_727);
        float _731 = exp2(_728);
        float _732 = exp2(_729);
        float _733 = _730 * cb2_000y;
        float _734 = _731 * cb2_000y;
        float _735 = _732 * cb2_000y;
        float _736 = _733 + cb2_000x;
        float _737 = _734 + cb2_000x;
        float _738 = _735 + cb2_000x;
        float _739 = saturate(_736);
        float _740 = saturate(_737);
        float _741 = saturate(_738);
        _743 = _739;
        _744 = _740;
        _745 = _741;
      }
      float _746 = dot(float3(_743, _744, _745), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _743;
      SV_Target.y = _744;
      SV_Target.z = _745;
      SV_Target.w = _746;
      SV_Target_1.x = _746;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

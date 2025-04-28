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
  float cb2_026z : packoffset(c026.z);
  float cb2_026w : packoffset(c026.w);
  float cb2_027x : packoffset(c027.x);
  float cb2_027y : packoffset(c027.y);
  float cb2_027z : packoffset(c027.z);
  float cb2_027w : packoffset(c027.w);
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
  float4 _26 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _30 = _26.x * 6.283199787139893f;
  float _31 = cos(_30);
  float _32 = sin(_30);
  float _33 = _31 * _26.z;
  float _34 = _32 * _26.z;
  float _35 = _33 + TEXCOORD0_centroid.x;
  float _36 = _34 + TEXCOORD0_centroid.y;
  float _37 = _35 * 10.0f;
  float _38 = 10.0f - _37;
  float _39 = min(_37, _38);
  float _40 = saturate(_39);
  float _41 = _40 * _33;
  float _42 = _36 * 10.0f;
  float _43 = 10.0f - _42;
  float _44 = min(_42, _43);
  float _45 = saturate(_44);
  float _46 = _45 * _34;
  float _47 = _41 + TEXCOORD0_centroid.x;
  float _48 = _46 + TEXCOORD0_centroid.y;
  float4 _49 = t7.SampleLevel(s2_space2, float2(_47, _48), 0.0f);
  float _51 = _49.w * _41;
  float _52 = _49.w * _46;
  float _53 = 1.0f - _26.y;
  float _54 = saturate(_53);
  float _55 = _51 * _54;
  float _56 = _52 * _54;
  float _57 = _55 + TEXCOORD0_centroid.x;
  float _58 = _56 + TEXCOORD0_centroid.y;
  float4 _59 = t7.SampleLevel(s2_space2, float2(_57, _58), 0.0f);
  bool _61 = (_59.y > 0.0f);
  float _62 = select(_61, TEXCOORD0_centroid.x, _57);
  float _63 = select(_61, TEXCOORD0_centroid.y, _58);
  float4 _64 = t1.SampleLevel(s4_space2, float2(_62, _63), 0.0f);
  float _68 = max(_64.x, 0.0f);
  float _69 = max(_64.y, 0.0f);
  float _70 = max(_64.z, 0.0f);
  float _71 = min(_68, 65000.0f);
  float _72 = min(_69, 65000.0f);
  float _73 = min(_70, 65000.0f);
  float4 _74 = t4.SampleLevel(s2_space2, float2(_62, _63), 0.0f);
  float _79 = max(_74.x, 0.0f);
  float _80 = max(_74.y, 0.0f);
  float _81 = max(_74.z, 0.0f);
  float _82 = max(_74.w, 0.0f);
  float _83 = min(_79, 5000.0f);
  float _84 = min(_80, 5000.0f);
  float _85 = min(_81, 5000.0f);
  float _86 = min(_82, 5000.0f);
  float _89 = _24.x * cb0_028z;
  float _90 = _89 + cb0_028x;
  float _91 = cb2_027w / _90;
  float _92 = 1.0f - _91;
  float _93 = abs(_92);
  float _95 = cb2_027y * _93;
  float _97 = _95 - cb2_027z;
  float _98 = saturate(_97);
  float _99 = max(_98, _86);
  float _100 = saturate(_99);
  float4 _101 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _105 = _83 - _71;
  float _106 = _84 - _72;
  float _107 = _85 - _73;
  float _108 = _100 * _105;
  float _109 = _100 * _106;
  float _110 = _100 * _107;
  float _111 = _108 + _71;
  float _112 = _109 + _72;
  float _113 = _110 + _73;
  float _114 = dot(float3(_111, _112, _113), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _118 = t0[0].SExposureData_020;
  float _120 = t0[0].SExposureData_004;
  float _122 = cb2_018x * 0.5f;
  float _123 = _122 * cb2_018y;
  float _124 = _120.x - _123;
  float _125 = cb2_018y * cb2_018x;
  float _126 = 1.0f / _125;
  float _127 = _124 * _126;
  float _128 = _114 / _118.x;
  float _129 = _128 * 5464.01611328125f;
  float _130 = _129 + 9.99999993922529e-09f;
  float _131 = log2(_130);
  float _132 = _131 - _124;
  float _133 = _132 * _126;
  float _134 = saturate(_133);
  float2 _135 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _134), 0.0f);
  float _138 = max(_135.y, 1.0000000116860974e-07f);
  float _139 = _135.x / _138;
  float _140 = _139 + _127;
  float _141 = _140 / _126;
  float _142 = _141 - _120.x;
  float _143 = -0.0f - _142;
  float _145 = _143 - cb2_027x;
  float _146 = max(0.0f, _145);
  float _149 = cb2_026z * _146;
  float _150 = _142 - cb2_027x;
  float _151 = max(0.0f, _150);
  float _153 = cb2_026w * _151;
  bool _154 = (_142 < 0.0f);
  float _155 = select(_154, _149, _153);
  float _156 = exp2(_155);
  float _157 = _156 * _111;
  float _158 = _156 * _112;
  float _159 = _156 * _113;
  float _164 = cb2_024y * _101.x;
  float _165 = cb2_024z * _101.y;
  float _166 = cb2_024w * _101.z;
  float _167 = _164 + _157;
  float _168 = _165 + _158;
  float _169 = _166 + _159;
  float _174 = _167 * cb2_025x;
  float _175 = _168 * cb2_025y;
  float _176 = _169 * cb2_025z;
  float _177 = dot(float3(_174, _175, _176), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _178 = t0[0].SExposureData_012;
  float _180 = _177 * 5464.01611328125f;
  float _181 = _180 * _178.x;
  float _182 = _181 + 9.99999993922529e-09f;
  float _183 = log2(_182);
  float _184 = _183 + 16.929765701293945f;
  float _185 = _184 * 0.05734497308731079f;
  float _186 = saturate(_185);
  float _187 = _186 * _186;
  float _188 = _186 * 2.0f;
  float _189 = 3.0f - _188;
  float _190 = _187 * _189;
  float _191 = _175 * 0.8450999855995178f;
  float _192 = _176 * 0.14589999616146088f;
  float _193 = _191 + _192;
  float _194 = _193 * 2.4890189170837402f;
  float _195 = _193 * 0.3754962384700775f;
  float _196 = _193 * 2.811495304107666f;
  float _197 = _193 * 5.519708156585693f;
  float _198 = _177 - _194;
  float _199 = _190 * _198;
  float _200 = _199 + _194;
  float _201 = _190 * 0.5f;
  float _202 = _201 + 0.5f;
  float _203 = _202 * _198;
  float _204 = _203 + _194;
  float _205 = _174 - _195;
  float _206 = _175 - _196;
  float _207 = _176 - _197;
  float _208 = _202 * _205;
  float _209 = _202 * _206;
  float _210 = _202 * _207;
  float _211 = _208 + _195;
  float _212 = _209 + _196;
  float _213 = _210 + _197;
  float _214 = 1.0f / _204;
  float _215 = _200 * _214;
  float _216 = _215 * _211;
  float _217 = _215 * _212;
  float _218 = _215 * _213;
  float _222 = cb2_020x * TEXCOORD0_centroid.x;
  float _223 = cb2_020y * TEXCOORD0_centroid.y;
  float _226 = _222 + cb2_020z;
  float _227 = _223 + cb2_020w;
  float _230 = dot(float2(_226, _227), float2(_226, _227));
  float _231 = 1.0f - _230;
  float _232 = saturate(_231);
  float _233 = log2(_232);
  float _234 = _233 * cb2_021w;
  float _235 = exp2(_234);
  float _239 = _216 - cb2_021x;
  float _240 = _217 - cb2_021y;
  float _241 = _218 - cb2_021z;
  float _242 = _239 * _235;
  float _243 = _240 * _235;
  float _244 = _241 * _235;
  float _245 = _242 + cb2_021x;
  float _246 = _243 + cb2_021y;
  float _247 = _244 + cb2_021z;
  float _248 = t0[0].SExposureData_000;
  float _250 = max(_118.x, 0.0010000000474974513f);
  float _251 = 1.0f / _250;
  float _252 = _251 * _248.x;
  bool _255 = ((uint)(cb2_069y) == 0);
  float _261;
  float _262;
  float _263;
  float _317;
  float _318;
  float _319;
  float _350;
  float _351;
  float _352;
  float _453;
  float _454;
  float _455;
  float _480;
  float _492;
  float _520;
  float _532;
  float _544;
  float _545;
  float _546;
  float _573;
  float _574;
  float _575;
  if (!_255) {
    float _257 = _252 * _245;
    float _258 = _252 * _246;
    float _259 = _252 * _247;
    _261 = _257;
    _262 = _258;
    _263 = _259;
  } else {
    _261 = _245;
    _262 = _246;
    _263 = _247;
  }
  float _264 = _261 * 0.6130970120429993f;
  float _265 = mad(0.33952298760414124f, _262, _264);
  float _266 = mad(0.04737899824976921f, _263, _265);
  float _267 = _261 * 0.07019399851560593f;
  float _268 = mad(0.9163540005683899f, _262, _267);
  float _269 = mad(0.013451999984681606f, _263, _268);
  float _270 = _261 * 0.02061600051820278f;
  float _271 = mad(0.10956999659538269f, _262, _270);
  float _272 = mad(0.8698149919509888f, _263, _271);
  float _273 = log2(_266);
  float _274 = log2(_269);
  float _275 = log2(_272);
  float _276 = _273 * 0.04211956635117531f;
  float _277 = _274 * 0.04211956635117531f;
  float _278 = _275 * 0.04211956635117531f;
  float _279 = _276 + 0.6252607107162476f;
  float _280 = _277 + 0.6252607107162476f;
  float _281 = _278 + 0.6252607107162476f;
  float4 _282 = t6.SampleLevel(s2_space2, float3(_279, _280, _281), 0.0f);
  bool _288 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_288 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _292 = cb2_017x * _282.x;
    float _293 = cb2_017x * _282.y;
    float _294 = cb2_017x * _282.z;
    float _296 = _292 + cb2_017y;
    float _297 = _293 + cb2_017y;
    float _298 = _294 + cb2_017y;
    float _299 = exp2(_296);
    float _300 = exp2(_297);
    float _301 = exp2(_298);
    float _302 = _299 + 1.0f;
    float _303 = _300 + 1.0f;
    float _304 = _301 + 1.0f;
    float _305 = 1.0f / _302;
    float _306 = 1.0f / _303;
    float _307 = 1.0f / _304;
    float _309 = cb2_017z * _305;
    float _310 = cb2_017z * _306;
    float _311 = cb2_017z * _307;
    float _313 = _309 + cb2_017w;
    float _314 = _310 + cb2_017w;
    float _315 = _311 + cb2_017w;
    _317 = _313;
    _318 = _314;
    _319 = _315;
  } else {
    _317 = _282.x;
    _318 = _282.y;
    _319 = _282.z;
  }
  float _320 = _317 * 23.0f;
  float _321 = _320 + -14.473931312561035f;
  float _322 = exp2(_321);
  float _323 = _318 * 23.0f;
  float _324 = _323 + -14.473931312561035f;
  float _325 = exp2(_324);
  float _326 = _319 * 23.0f;
  float _327 = _326 + -14.473931312561035f;
  float _328 = exp2(_327);
  float _335 = cb2_016x - _322;
  float _336 = cb2_016y - _325;
  float _337 = cb2_016z - _328;
  float _338 = _335 * cb2_016w;
  float _339 = _336 * cb2_016w;
  float _340 = _337 * cb2_016w;
  float _341 = _338 + _322;
  float _342 = _339 + _325;
  float _343 = _340 + _328;
  if (_288 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _346 = cb2_024x * _341;
    float _347 = cb2_024x * _342;
    float _348 = cb2_024x * _343;
    _350 = _346;
    _351 = _347;
    _352 = _348;
  } else {
    _350 = _341;
    _351 = _342;
    _352 = _343;
  }
  float _353 = _350 * 0.9708889722824097f;
  float _354 = mad(0.026962999254465103f, _351, _353);
  float _355 = mad(0.002148000057786703f, _352, _354);
  float _356 = _350 * 0.01088900025933981f;
  float _357 = mad(0.9869629740715027f, _351, _356);
  float _358 = mad(0.002148000057786703f, _352, _357);
  float _359 = mad(0.026962999254465103f, _351, _356);
  float _360 = mad(0.9621480107307434f, _352, _359);
  if (_288) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _365 = cb1_018y * 0.10000000149011612f;
        float _366 = log2(cb1_018z);
        float _367 = _366 + -13.287712097167969f;
        float _368 = _367 * 1.4929734468460083f;
        float _369 = _368 + 18.0f;
        float _370 = exp2(_369);
        float _371 = _370 * 0.18000000715255737f;
        float _372 = abs(_371);
        float _373 = log2(_372);
        float _374 = _373 * 1.5f;
        float _375 = exp2(_374);
        float _376 = _375 * _365;
        float _377 = _376 / cb1_018z;
        float _378 = _377 + -0.07636754959821701f;
        float _379 = _373 * 1.2750000953674316f;
        float _380 = exp2(_379);
        float _381 = _380 * 0.07636754959821701f;
        float _382 = cb1_018y * 0.011232397519052029f;
        float _383 = _382 * _375;
        float _384 = _383 / cb1_018z;
        float _385 = _381 - _384;
        float _386 = _380 + -0.11232396960258484f;
        float _387 = _386 * _365;
        float _388 = _387 / cb1_018z;
        float _389 = _388 * cb1_018z;
        float _390 = abs(_355);
        float _391 = abs(_358);
        float _392 = abs(_360);
        float _393 = log2(_390);
        float _394 = log2(_391);
        float _395 = log2(_392);
        float _396 = _393 * 1.5f;
        float _397 = _394 * 1.5f;
        float _398 = _395 * 1.5f;
        float _399 = exp2(_396);
        float _400 = exp2(_397);
        float _401 = exp2(_398);
        float _402 = _399 * _389;
        float _403 = _400 * _389;
        float _404 = _401 * _389;
        float _405 = _393 * 1.2750000953674316f;
        float _406 = _394 * 1.2750000953674316f;
        float _407 = _395 * 1.2750000953674316f;
        float _408 = exp2(_405);
        float _409 = exp2(_406);
        float _410 = exp2(_407);
        float _411 = _408 * _378;
        float _412 = _409 * _378;
        float _413 = _410 * _378;
        float _414 = _411 + _385;
        float _415 = _412 + _385;
        float _416 = _413 + _385;
        float _417 = _402 / _414;
        float _418 = _403 / _415;
        float _419 = _404 / _416;
        float _420 = _417 * 9.999999747378752e-05f;
        float _421 = _418 * 9.999999747378752e-05f;
        float _422 = _419 * 9.999999747378752e-05f;
        float _423 = 5000.0f / cb1_018y;
        float _424 = _420 * _423;
        float _425 = _421 * _423;
        float _426 = _422 * _423;
        _453 = _424;
        _454 = _425;
        _455 = _426;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_355, _358, _360));
      _453 = tonemapped.x, _454 = tonemapped.y, _455 = tonemapped.z;
    }
      } else {
        float _428 = _355 + 0.020616600289940834f;
        float _429 = _358 + 0.020616600289940834f;
        float _430 = _360 + 0.020616600289940834f;
        float _431 = _428 * _355;
        float _432 = _429 * _358;
        float _433 = _430 * _360;
        float _434 = _431 + -7.456949970219284e-05f;
        float _435 = _432 + -7.456949970219284e-05f;
        float _436 = _433 + -7.456949970219284e-05f;
        float _437 = _355 * 0.9837960004806519f;
        float _438 = _358 * 0.9837960004806519f;
        float _439 = _360 * 0.9837960004806519f;
        float _440 = _437 + 0.4336790144443512f;
        float _441 = _438 + 0.4336790144443512f;
        float _442 = _439 + 0.4336790144443512f;
        float _443 = _440 * _355;
        float _444 = _441 * _358;
        float _445 = _442 * _360;
        float _446 = _443 + 0.24617899954319f;
        float _447 = _444 + 0.24617899954319f;
        float _448 = _445 + 0.24617899954319f;
        float _449 = _434 / _446;
        float _450 = _435 / _447;
        float _451 = _436 / _448;
        _453 = _449;
        _454 = _450;
        _455 = _451;
      }
      float _456 = _453 * 1.6047500371932983f;
      float _457 = mad(-0.5310800075531006f, _454, _456);
      float _458 = mad(-0.07366999983787537f, _455, _457);
      float _459 = _453 * -0.10208000242710114f;
      float _460 = mad(1.1081299781799316f, _454, _459);
      float _461 = mad(-0.006049999967217445f, _455, _460);
      float _462 = _453 * -0.0032599999103695154f;
      float _463 = mad(-0.07275000214576721f, _454, _462);
      float _464 = mad(1.0760200023651123f, _455, _463);
      if (_288) {
        // float _466 = max(_458, 0.0f);
        // float _467 = max(_461, 0.0f);
        // float _468 = max(_464, 0.0f);
        // bool _469 = !(_466 >= 0.0030399328097701073f);
        // if (!_469) {
        //   float _471 = abs(_466);
        //   float _472 = log2(_471);
        //   float _473 = _472 * 0.4166666567325592f;
        //   float _474 = exp2(_473);
        //   float _475 = _474 * 1.0549999475479126f;
        //   float _476 = _475 + -0.054999999701976776f;
        //   _480 = _476;
        // } else {
        //   float _478 = _466 * 12.923210144042969f;
        //   _480 = _478;
        // }
        // bool _481 = !(_467 >= 0.0030399328097701073f);
        // if (!_481) {
        //   float _483 = abs(_467);
        //   float _484 = log2(_483);
        //   float _485 = _484 * 0.4166666567325592f;
        //   float _486 = exp2(_485);
        //   float _487 = _486 * 1.0549999475479126f;
        //   float _488 = _487 + -0.054999999701976776f;
        //   _492 = _488;
        // } else {
        //   float _490 = _467 * 12.923210144042969f;
        //   _492 = _490;
        // }
        // bool _493 = !(_468 >= 0.0030399328097701073f);
        // if (!_493) {
        //   float _495 = abs(_468);
        //   float _496 = log2(_495);
        //   float _497 = _496 * 0.4166666567325592f;
        //   float _498 = exp2(_497);
        //   float _499 = _498 * 1.0549999475479126f;
        //   float _500 = _499 + -0.054999999701976776f;
        //   _573 = _480;
        //   _574 = _492;
        //   _575 = _500;
        // } else {
        //   float _502 = _468 * 12.923210144042969f;
        //   _573 = _480;
        //   _574 = _492;
        //   _575 = _502;
        // }
        _573 = renodx::color::srgb::EncodeSafe(_458);
        _574 = renodx::color::srgb::EncodeSafe(_461);
        _575 = renodx::color::srgb::EncodeSafe(_464);

      } else {
        float _504 = saturate(_458);
        float _505 = saturate(_461);
        float _506 = saturate(_464);
        bool _507 = ((uint)(cb1_018w) == -2);
        if (!_507) {
          bool _509 = !(_504 >= 0.0030399328097701073f);
          if (!_509) {
            float _511 = abs(_504);
            float _512 = log2(_511);
            float _513 = _512 * 0.4166666567325592f;
            float _514 = exp2(_513);
            float _515 = _514 * 1.0549999475479126f;
            float _516 = _515 + -0.054999999701976776f;
            _520 = _516;
          } else {
            float _518 = _504 * 12.923210144042969f;
            _520 = _518;
          }
          bool _521 = !(_505 >= 0.0030399328097701073f);
          if (!_521) {
            float _523 = abs(_505);
            float _524 = log2(_523);
            float _525 = _524 * 0.4166666567325592f;
            float _526 = exp2(_525);
            float _527 = _526 * 1.0549999475479126f;
            float _528 = _527 + -0.054999999701976776f;
            _532 = _528;
          } else {
            float _530 = _505 * 12.923210144042969f;
            _532 = _530;
          }
          bool _533 = !(_506 >= 0.0030399328097701073f);
          if (!_533) {
            float _535 = abs(_506);
            float _536 = log2(_535);
            float _537 = _536 * 0.4166666567325592f;
            float _538 = exp2(_537);
            float _539 = _538 * 1.0549999475479126f;
            float _540 = _539 + -0.054999999701976776f;
            _544 = _520;
            _545 = _532;
            _546 = _540;
          } else {
            float _542 = _506 * 12.923210144042969f;
            _544 = _520;
            _545 = _532;
            _546 = _542;
          }
        } else {
          _544 = _504;
          _545 = _505;
          _546 = _506;
        }
        float _551 = abs(_544);
        float _552 = abs(_545);
        float _553 = abs(_546);
        float _554 = log2(_551);
        float _555 = log2(_552);
        float _556 = log2(_553);
        float _557 = _554 * cb2_000z;
        float _558 = _555 * cb2_000z;
        float _559 = _556 * cb2_000z;
        float _560 = exp2(_557);
        float _561 = exp2(_558);
        float _562 = exp2(_559);
        float _563 = _560 * cb2_000y;
        float _564 = _561 * cb2_000y;
        float _565 = _562 * cb2_000y;
        float _566 = _563 + cb2_000x;
        float _567 = _564 + cb2_000x;
        float _568 = _565 + cb2_000x;
        float _569 = saturate(_566);
        float _570 = saturate(_567);
        float _571 = saturate(_568);
        _573 = _569;
        _574 = _570;
        _575 = _571;
      }
      float _579 = cb2_023x * TEXCOORD0_centroid.x;
      float _580 = cb2_023y * TEXCOORD0_centroid.y;
      float _583 = _579 + cb2_023z;
      float _584 = _580 + cb2_023w;
      float4 _587 = t9.SampleLevel(s0_space2, float2(_583, _584), 0.0f);
      float _589 = _587.x + -0.5f;
      float _590 = _589 * cb2_022x;
      float _591 = _590 + 0.5f;
      float _592 = _591 * 2.0f;
      float _593 = _592 * _573;
      float _594 = _592 * _574;
      float _595 = _592 * _575;
      float _599 = float((uint)(cb2_019z));
      float _600 = float((uint)(cb2_019w));
      float _601 = _599 + SV_Position.x;
      float _602 = _600 + SV_Position.y;
      uint _603 = uint(_601);
      uint _604 = uint(_602);
      uint _607 = cb2_019x + -1u;
      uint _608 = cb2_019y + -1u;
      int _609 = _603 & _607;
      int _610 = _604 & _608;
      float4 _611 = t3.Load(int3(_609, _610, 0));
      float _615 = _611.x * 2.0f;
      float _616 = _611.y * 2.0f;
      float _617 = _611.z * 2.0f;
      float _618 = _615 + -1.0f;
      float _619 = _616 + -1.0f;
      float _620 = _617 + -1.0f;
      float _621 = _618 * cb2_025w;
      float _622 = _619 * cb2_025w;
      float _623 = _620 * cb2_025w;
      float _624 = _621 + _593;
      float _625 = _622 + _594;
      float _626 = _623 + _595;
      float _627 = dot(float3(_624, _625, _626), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _624;
      SV_Target.y = _625;
      SV_Target.z = _626;
      SV_Target.w = _627;
      SV_Target_1.x = _627;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

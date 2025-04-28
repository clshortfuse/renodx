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
  float _21 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _23 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _27 = _23.x * 6.283199787139893f;
  float _28 = cos(_27);
  float _29 = sin(_27);
  float _30 = _28 * _23.z;
  float _31 = _29 * _23.z;
  float _32 = _30 + TEXCOORD0_centroid.x;
  float _33 = _31 + TEXCOORD0_centroid.y;
  float _34 = _32 * 10.0f;
  float _35 = 10.0f - _34;
  float _36 = min(_34, _35);
  float _37 = saturate(_36);
  float _38 = _37 * _30;
  float _39 = _33 * 10.0f;
  float _40 = 10.0f - _39;
  float _41 = min(_39, _40);
  float _42 = saturate(_41);
  float _43 = _42 * _31;
  float _44 = _38 + TEXCOORD0_centroid.x;
  float _45 = _43 + TEXCOORD0_centroid.y;
  float4 _46 = t6.SampleLevel(s2_space2, float2(_44, _45), 0.0f);
  float _48 = _46.w * _38;
  float _49 = _46.w * _43;
  float _50 = 1.0f - _23.y;
  float _51 = saturate(_50);
  float _52 = _48 * _51;
  float _53 = _49 * _51;
  float _57 = cb2_015x * TEXCOORD0_centroid.x;
  float _58 = cb2_015y * TEXCOORD0_centroid.y;
  float _61 = _57 + cb2_015z;
  float _62 = _58 + cb2_015w;
  float4 _63 = t7.SampleLevel(s0_space2, float2(_61, _62), 0.0f);
  float _67 = saturate(_63.x);
  float _68 = saturate(_63.z);
  float _71 = cb2_026x * _68;
  float _72 = _67 * 6.283199787139893f;
  float _73 = cos(_72);
  float _74 = sin(_72);
  float _75 = _71 * _73;
  float _76 = _74 * _71;
  float _77 = 1.0f - _63.y;
  float _78 = saturate(_77);
  float _79 = _75 * _78;
  float _80 = _76 * _78;
  float _81 = _52 + TEXCOORD0_centroid.x;
  float _82 = _81 + _79;
  float _83 = _53 + TEXCOORD0_centroid.y;
  float _84 = _83 + _80;
  float4 _85 = t6.SampleLevel(s2_space2, float2(_82, _84), 0.0f);
  bool _87 = (_85.y > 0.0f);
  float _88 = select(_87, TEXCOORD0_centroid.x, _82);
  float _89 = select(_87, TEXCOORD0_centroid.y, _84);
  float4 _90 = t1.SampleLevel(s4_space2, float2(_88, _89), 0.0f);
  float _94 = max(_90.x, 0.0f);
  float _95 = max(_90.y, 0.0f);
  float _96 = max(_90.z, 0.0f);
  float _97 = min(_94, 65000.0f);
  float _98 = min(_95, 65000.0f);
  float _99 = min(_96, 65000.0f);
  float4 _100 = t3.SampleLevel(s2_space2, float2(_88, _89), 0.0f);
  float _105 = max(_100.x, 0.0f);
  float _106 = max(_100.y, 0.0f);
  float _107 = max(_100.z, 0.0f);
  float _108 = max(_100.w, 0.0f);
  float _109 = min(_105, 5000.0f);
  float _110 = min(_106, 5000.0f);
  float _111 = min(_107, 5000.0f);
  float _112 = min(_108, 5000.0f);
  float _115 = _21.x * cb0_028z;
  float _116 = _115 + cb0_028x;
  float _117 = cb2_027w / _116;
  float _118 = 1.0f - _117;
  float _119 = abs(_118);
  float _121 = cb2_027y * _119;
  float _123 = _121 - cb2_027z;
  float _124 = saturate(_123);
  float _125 = max(_124, _112);
  float _126 = saturate(_125);
  float4 _127 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _131 = _109 - _97;
  float _132 = _110 - _98;
  float _133 = _111 - _99;
  float _134 = _126 * _131;
  float _135 = _126 * _132;
  float _136 = _126 * _133;
  float _137 = _134 + _97;
  float _138 = _135 + _98;
  float _139 = _136 + _99;
  float _140 = dot(float3(_137, _138, _139), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _144 = t0[0].SExposureData_020;
  float _146 = t0[0].SExposureData_004;
  float _148 = cb2_018x * 0.5f;
  float _149 = _148 * cb2_018y;
  float _150 = _146.x - _149;
  float _151 = cb2_018y * cb2_018x;
  float _152 = 1.0f / _151;
  float _153 = _150 * _152;
  float _154 = _140 / _144.x;
  float _155 = _154 * 5464.01611328125f;
  float _156 = _155 + 9.99999993922529e-09f;
  float _157 = log2(_156);
  float _158 = _157 - _150;
  float _159 = _158 * _152;
  float _160 = saturate(_159);
  float2 _161 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _160), 0.0f);
  float _164 = max(_161.y, 1.0000000116860974e-07f);
  float _165 = _161.x / _164;
  float _166 = _165 + _153;
  float _167 = _166 / _152;
  float _168 = _167 - _146.x;
  float _169 = -0.0f - _168;
  float _171 = _169 - cb2_027x;
  float _172 = max(0.0f, _171);
  float _174 = cb2_026z * _172;
  float _175 = _168 - cb2_027x;
  float _176 = max(0.0f, _175);
  float _178 = cb2_026w * _176;
  bool _179 = (_168 < 0.0f);
  float _180 = select(_179, _174, _178);
  float _181 = exp2(_180);
  float _182 = _181 * _137;
  float _183 = _181 * _138;
  float _184 = _181 * _139;
  float _189 = cb2_024y * _127.x;
  float _190 = cb2_024z * _127.y;
  float _191 = cb2_024w * _127.z;
  float _192 = _189 + _182;
  float _193 = _190 + _183;
  float _194 = _191 + _184;
  float _199 = _192 * cb2_025x;
  float _200 = _193 * cb2_025y;
  float _201 = _194 * cb2_025z;
  float _202 = dot(float3(_199, _200, _201), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _203 = t0[0].SExposureData_012;
  float _205 = _202 * 5464.01611328125f;
  float _206 = _205 * _203.x;
  float _207 = _206 + 9.99999993922529e-09f;
  float _208 = log2(_207);
  float _209 = _208 + 16.929765701293945f;
  float _210 = _209 * 0.05734497308731079f;
  float _211 = saturate(_210);
  float _212 = _211 * _211;
  float _213 = _211 * 2.0f;
  float _214 = 3.0f - _213;
  float _215 = _212 * _214;
  float _216 = _200 * 0.8450999855995178f;
  float _217 = _201 * 0.14589999616146088f;
  float _218 = _216 + _217;
  float _219 = _218 * 2.4890189170837402f;
  float _220 = _218 * 0.3754962384700775f;
  float _221 = _218 * 2.811495304107666f;
  float _222 = _218 * 5.519708156585693f;
  float _223 = _202 - _219;
  float _224 = _215 * _223;
  float _225 = _224 + _219;
  float _226 = _215 * 0.5f;
  float _227 = _226 + 0.5f;
  float _228 = _227 * _223;
  float _229 = _228 + _219;
  float _230 = _199 - _220;
  float _231 = _200 - _221;
  float _232 = _201 - _222;
  float _233 = _227 * _230;
  float _234 = _227 * _231;
  float _235 = _227 * _232;
  float _236 = _233 + _220;
  float _237 = _234 + _221;
  float _238 = _235 + _222;
  float _239 = 1.0f / _229;
  float _240 = _225 * _239;
  float _241 = _240 * _236;
  float _242 = _240 * _237;
  float _243 = _240 * _238;
  float _247 = cb2_020x * TEXCOORD0_centroid.x;
  float _248 = cb2_020y * TEXCOORD0_centroid.y;
  float _251 = _247 + cb2_020z;
  float _252 = _248 + cb2_020w;
  float _255 = dot(float2(_251, _252), float2(_251, _252));
  float _256 = 1.0f - _255;
  float _257 = saturate(_256);
  float _258 = log2(_257);
  float _259 = _258 * cb2_021w;
  float _260 = exp2(_259);
  float _264 = _241 - cb2_021x;
  float _265 = _242 - cb2_021y;
  float _266 = _243 - cb2_021z;
  float _267 = _264 * _260;
  float _268 = _265 * _260;
  float _269 = _266 * _260;
  float _270 = _267 + cb2_021x;
  float _271 = _268 + cb2_021y;
  float _272 = _269 + cb2_021z;
  float _273 = t0[0].SExposureData_000;
  float _275 = max(_144.x, 0.0010000000474974513f);
  float _276 = 1.0f / _275;
  float _277 = _276 * _273.x;
  bool _280 = ((uint)(cb2_069y) == 0);
  float _286;
  float _287;
  float _288;
  float _342;
  float _343;
  float _344;
  float _374;
  float _375;
  float _376;
  float _477;
  float _478;
  float _479;
  float _504;
  float _516;
  float _544;
  float _556;
  float _568;
  float _569;
  float _570;
  float _597;
  float _598;
  float _599;
  if (!_280) {
    float _282 = _277 * _270;
    float _283 = _277 * _271;
    float _284 = _277 * _272;
    _286 = _282;
    _287 = _283;
    _288 = _284;
  } else {
    _286 = _270;
    _287 = _271;
    _288 = _272;
  }
  float _289 = _286 * 0.6130970120429993f;
  float _290 = mad(0.33952298760414124f, _287, _289);
  float _291 = mad(0.04737899824976921f, _288, _290);
  float _292 = _286 * 0.07019399851560593f;
  float _293 = mad(0.9163540005683899f, _287, _292);
  float _294 = mad(0.013451999984681606f, _288, _293);
  float _295 = _286 * 0.02061600051820278f;
  float _296 = mad(0.10956999659538269f, _287, _295);
  float _297 = mad(0.8698149919509888f, _288, _296);
  float _298 = log2(_291);
  float _299 = log2(_294);
  float _300 = log2(_297);
  float _301 = _298 * 0.04211956635117531f;
  float _302 = _299 * 0.04211956635117531f;
  float _303 = _300 * 0.04211956635117531f;
  float _304 = _301 + 0.6252607107162476f;
  float _305 = _302 + 0.6252607107162476f;
  float _306 = _303 + 0.6252607107162476f;
  float4 _307 = t5.SampleLevel(s2_space2, float3(_304, _305, _306), 0.0f);
  bool _313 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_313 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _317 = cb2_017x * _307.x;
    float _318 = cb2_017x * _307.y;
    float _319 = cb2_017x * _307.z;
    float _321 = _317 + cb2_017y;
    float _322 = _318 + cb2_017y;
    float _323 = _319 + cb2_017y;
    float _324 = exp2(_321);
    float _325 = exp2(_322);
    float _326 = exp2(_323);
    float _327 = _324 + 1.0f;
    float _328 = _325 + 1.0f;
    float _329 = _326 + 1.0f;
    float _330 = 1.0f / _327;
    float _331 = 1.0f / _328;
    float _332 = 1.0f / _329;
    float _334 = cb2_017z * _330;
    float _335 = cb2_017z * _331;
    float _336 = cb2_017z * _332;
    float _338 = _334 + cb2_017w;
    float _339 = _335 + cb2_017w;
    float _340 = _336 + cb2_017w;
    _342 = _338;
    _343 = _339;
    _344 = _340;
  } else {
    _342 = _307.x;
    _343 = _307.y;
    _344 = _307.z;
  }
  float _345 = _342 * 23.0f;
  float _346 = _345 + -14.473931312561035f;
  float _347 = exp2(_346);
  float _348 = _343 * 23.0f;
  float _349 = _348 + -14.473931312561035f;
  float _350 = exp2(_349);
  float _351 = _344 * 23.0f;
  float _352 = _351 + -14.473931312561035f;
  float _353 = exp2(_352);
  float _359 = cb2_016x - _347;
  float _360 = cb2_016y - _350;
  float _361 = cb2_016z - _353;
  float _362 = _359 * cb2_016w;
  float _363 = _360 * cb2_016w;
  float _364 = _361 * cb2_016w;
  float _365 = _362 + _347;
  float _366 = _363 + _350;
  float _367 = _364 + _353;
  if (_313 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _370 = cb2_024x * _365;
    float _371 = cb2_024x * _366;
    float _372 = cb2_024x * _367;
    _374 = _370;
    _375 = _371;
    _376 = _372;
  } else {
    _374 = _365;
    _375 = _366;
    _376 = _367;
  }
  float _377 = _374 * 0.9708889722824097f;
  float _378 = mad(0.026962999254465103f, _375, _377);
  float _379 = mad(0.002148000057786703f, _376, _378);
  float _380 = _374 * 0.01088900025933981f;
  float _381 = mad(0.9869629740715027f, _375, _380);
  float _382 = mad(0.002148000057786703f, _376, _381);
  float _383 = mad(0.026962999254465103f, _375, _380);
  float _384 = mad(0.9621480107307434f, _376, _383);
  if (_313) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _389 = cb1_018y * 0.10000000149011612f;
        float _390 = log2(cb1_018z);
        float _391 = _390 + -13.287712097167969f;
        float _392 = _391 * 1.4929734468460083f;
        float _393 = _392 + 18.0f;
        float _394 = exp2(_393);
        float _395 = _394 * 0.18000000715255737f;
        float _396 = abs(_395);
        float _397 = log2(_396);
        float _398 = _397 * 1.5f;
        float _399 = exp2(_398);
        float _400 = _399 * _389;
        float _401 = _400 / cb1_018z;
        float _402 = _401 + -0.07636754959821701f;
        float _403 = _397 * 1.2750000953674316f;
        float _404 = exp2(_403);
        float _405 = _404 * 0.07636754959821701f;
        float _406 = cb1_018y * 0.011232397519052029f;
        float _407 = _406 * _399;
        float _408 = _407 / cb1_018z;
        float _409 = _405 - _408;
        float _410 = _404 + -0.11232396960258484f;
        float _411 = _410 * _389;
        float _412 = _411 / cb1_018z;
        float _413 = _412 * cb1_018z;
        float _414 = abs(_379);
        float _415 = abs(_382);
        float _416 = abs(_384);
        float _417 = log2(_414);
        float _418 = log2(_415);
        float _419 = log2(_416);
        float _420 = _417 * 1.5f;
        float _421 = _418 * 1.5f;
        float _422 = _419 * 1.5f;
        float _423 = exp2(_420);
        float _424 = exp2(_421);
        float _425 = exp2(_422);
        float _426 = _423 * _413;
        float _427 = _424 * _413;
        float _428 = _425 * _413;
        float _429 = _417 * 1.2750000953674316f;
        float _430 = _418 * 1.2750000953674316f;
        float _431 = _419 * 1.2750000953674316f;
        float _432 = exp2(_429);
        float _433 = exp2(_430);
        float _434 = exp2(_431);
        float _435 = _432 * _402;
        float _436 = _433 * _402;
        float _437 = _434 * _402;
        float _438 = _435 + _409;
        float _439 = _436 + _409;
        float _440 = _437 + _409;
        float _441 = _426 / _438;
        float _442 = _427 / _439;
        float _443 = _428 / _440;
        float _444 = _441 * 9.999999747378752e-05f;
        float _445 = _442 * 9.999999747378752e-05f;
        float _446 = _443 * 9.999999747378752e-05f;
        float _447 = 5000.0f / cb1_018y;
        float _448 = _444 * _447;
        float _449 = _445 * _447;
        float _450 = _446 * _447;
        _477 = _448;
        _478 = _449;
        _479 = _450;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_379, _382, _384));
      _477 = tonemapped.x, _478 = tonemapped.y, _479 = tonemapped.z;
    }
      } else {
        float _452 = _379 + 0.020616600289940834f;
        float _453 = _382 + 0.020616600289940834f;
        float _454 = _384 + 0.020616600289940834f;
        float _455 = _452 * _379;
        float _456 = _453 * _382;
        float _457 = _454 * _384;
        float _458 = _455 + -7.456949970219284e-05f;
        float _459 = _456 + -7.456949970219284e-05f;
        float _460 = _457 + -7.456949970219284e-05f;
        float _461 = _379 * 0.9837960004806519f;
        float _462 = _382 * 0.9837960004806519f;
        float _463 = _384 * 0.9837960004806519f;
        float _464 = _461 + 0.4336790144443512f;
        float _465 = _462 + 0.4336790144443512f;
        float _466 = _463 + 0.4336790144443512f;
        float _467 = _464 * _379;
        float _468 = _465 * _382;
        float _469 = _466 * _384;
        float _470 = _467 + 0.24617899954319f;
        float _471 = _468 + 0.24617899954319f;
        float _472 = _469 + 0.24617899954319f;
        float _473 = _458 / _470;
        float _474 = _459 / _471;
        float _475 = _460 / _472;
        _477 = _473;
        _478 = _474;
        _479 = _475;
      }
      float _480 = _477 * 1.6047500371932983f;
      float _481 = mad(-0.5310800075531006f, _478, _480);
      float _482 = mad(-0.07366999983787537f, _479, _481);
      float _483 = _477 * -0.10208000242710114f;
      float _484 = mad(1.1081299781799316f, _478, _483);
      float _485 = mad(-0.006049999967217445f, _479, _484);
      float _486 = _477 * -0.0032599999103695154f;
      float _487 = mad(-0.07275000214576721f, _478, _486);
      float _488 = mad(1.0760200023651123f, _479, _487);
      if (_313) {
        // float _490 = max(_482, 0.0f);
        // float _491 = max(_485, 0.0f);
        // float _492 = max(_488, 0.0f);
        // bool _493 = !(_490 >= 0.0030399328097701073f);
        // if (!_493) {
        //   float _495 = abs(_490);
        //   float _496 = log2(_495);
        //   float _497 = _496 * 0.4166666567325592f;
        //   float _498 = exp2(_497);
        //   float _499 = _498 * 1.0549999475479126f;
        //   float _500 = _499 + -0.054999999701976776f;
        //   _504 = _500;
        // } else {
        //   float _502 = _490 * 12.923210144042969f;
        //   _504 = _502;
        // }
        // bool _505 = !(_491 >= 0.0030399328097701073f);
        // if (!_505) {
        //   float _507 = abs(_491);
        //   float _508 = log2(_507);
        //   float _509 = _508 * 0.4166666567325592f;
        //   float _510 = exp2(_509);
        //   float _511 = _510 * 1.0549999475479126f;
        //   float _512 = _511 + -0.054999999701976776f;
        //   _516 = _512;
        // } else {
        //   float _514 = _491 * 12.923210144042969f;
        //   _516 = _514;
        // }
        // bool _517 = !(_492 >= 0.0030399328097701073f);
        // if (!_517) {
        //   float _519 = abs(_492);
        //   float _520 = log2(_519);
        //   float _521 = _520 * 0.4166666567325592f;
        //   float _522 = exp2(_521);
        //   float _523 = _522 * 1.0549999475479126f;
        //   float _524 = _523 + -0.054999999701976776f;
        //   _597 = _504;
        //   _598 = _516;
        //   _599 = _524;
        // } else {
        //   float _526 = _492 * 12.923210144042969f;
        //   _597 = _504;
        //   _598 = _516;
        //   _599 = _526;
        // }
        _597 = renodx::color::srgb::EncodeSafe(_482);
        _598 = renodx::color::srgb::EncodeSafe(_485);
        _599 = renodx::color::srgb::EncodeSafe(_488);

      } else {
        float _528 = saturate(_482);
        float _529 = saturate(_485);
        float _530 = saturate(_488);
        bool _531 = ((uint)(cb1_018w) == -2);
        if (!_531) {
          bool _533 = !(_528 >= 0.0030399328097701073f);
          if (!_533) {
            float _535 = abs(_528);
            float _536 = log2(_535);
            float _537 = _536 * 0.4166666567325592f;
            float _538 = exp2(_537);
            float _539 = _538 * 1.0549999475479126f;
            float _540 = _539 + -0.054999999701976776f;
            _544 = _540;
          } else {
            float _542 = _528 * 12.923210144042969f;
            _544 = _542;
          }
          bool _545 = !(_529 >= 0.0030399328097701073f);
          if (!_545) {
            float _547 = abs(_529);
            float _548 = log2(_547);
            float _549 = _548 * 0.4166666567325592f;
            float _550 = exp2(_549);
            float _551 = _550 * 1.0549999475479126f;
            float _552 = _551 + -0.054999999701976776f;
            _556 = _552;
          } else {
            float _554 = _529 * 12.923210144042969f;
            _556 = _554;
          }
          bool _557 = !(_530 >= 0.0030399328097701073f);
          if (!_557) {
            float _559 = abs(_530);
            float _560 = log2(_559);
            float _561 = _560 * 0.4166666567325592f;
            float _562 = exp2(_561);
            float _563 = _562 * 1.0549999475479126f;
            float _564 = _563 + -0.054999999701976776f;
            _568 = _544;
            _569 = _556;
            _570 = _564;
          } else {
            float _566 = _530 * 12.923210144042969f;
            _568 = _544;
            _569 = _556;
            _570 = _566;
          }
        } else {
          _568 = _528;
          _569 = _529;
          _570 = _530;
        }
        float _575 = abs(_568);
        float _576 = abs(_569);
        float _577 = abs(_570);
        float _578 = log2(_575);
        float _579 = log2(_576);
        float _580 = log2(_577);
        float _581 = _578 * cb2_000z;
        float _582 = _579 * cb2_000z;
        float _583 = _580 * cb2_000z;
        float _584 = exp2(_581);
        float _585 = exp2(_582);
        float _586 = exp2(_583);
        float _587 = _584 * cb2_000y;
        float _588 = _585 * cb2_000y;
        float _589 = _586 * cb2_000y;
        float _590 = _587 + cb2_000x;
        float _591 = _588 + cb2_000x;
        float _592 = _589 + cb2_000x;
        float _593 = saturate(_590);
        float _594 = saturate(_591);
        float _595 = saturate(_592);
        _597 = _593;
        _598 = _594;
        _599 = _595;
      }
      float _600 = dot(float3(_597, _598, _599), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _597;
      SV_Target.y = _598;
      SV_Target.z = _599;
      SV_Target.w = _600;
      SV_Target_1.x = _600;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

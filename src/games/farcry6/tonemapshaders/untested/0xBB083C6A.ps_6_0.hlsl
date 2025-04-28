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

Texture3D<float2> t7 : register(t7);

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
  float _20 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _25 = cb2_015x * TEXCOORD0_centroid.x;
  float _26 = cb2_015y * TEXCOORD0_centroid.y;
  float _29 = _25 + cb2_015z;
  float _30 = _26 + cb2_015w;
  float4 _31 = t6.SampleLevel(s0_space2, float2(_29, _30), 0.0f);
  float _35 = saturate(_31.x);
  float _36 = saturate(_31.z);
  float _39 = cb2_026x * _36;
  float _40 = _35 * 6.283199787139893f;
  float _41 = cos(_40);
  float _42 = sin(_40);
  float _43 = _39 * _41;
  float _44 = _42 * _39;
  float _45 = 1.0f - _31.y;
  float _46 = saturate(_45);
  float _47 = _43 * _46;
  float _48 = _44 * _46;
  float _49 = _47 + TEXCOORD0_centroid.x;
  float _50 = _48 + TEXCOORD0_centroid.y;
  float4 _51 = t1.SampleLevel(s4_space2, float2(_49, _50), 0.0f);
  float _55 = max(_51.x, 0.0f);
  float _56 = max(_51.y, 0.0f);
  float _57 = max(_51.z, 0.0f);
  float _58 = min(_55, 65000.0f);
  float _59 = min(_56, 65000.0f);
  float _60 = min(_57, 65000.0f);
  float4 _61 = t3.SampleLevel(s2_space2, float2(_49, _50), 0.0f);
  float _66 = max(_61.x, 0.0f);
  float _67 = max(_61.y, 0.0f);
  float _68 = max(_61.z, 0.0f);
  float _69 = max(_61.w, 0.0f);
  float _70 = min(_66, 5000.0f);
  float _71 = min(_67, 5000.0f);
  float _72 = min(_68, 5000.0f);
  float _73 = min(_69, 5000.0f);
  float _76 = _20.x * cb0_028z;
  float _77 = _76 + cb0_028x;
  float _78 = cb2_027w / _77;
  float _79 = 1.0f - _78;
  float _80 = abs(_79);
  float _82 = cb2_027y * _80;
  float _84 = _82 - cb2_027z;
  float _85 = saturate(_84);
  float _86 = max(_85, _73);
  float _87 = saturate(_86);
  float4 _88 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _92 = _70 - _58;
  float _93 = _71 - _59;
  float _94 = _72 - _60;
  float _95 = _87 * _92;
  float _96 = _87 * _93;
  float _97 = _87 * _94;
  float _98 = _95 + _58;
  float _99 = _96 + _59;
  float _100 = _97 + _60;
  float _101 = dot(float3(_98, _99, _100), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _105 = t0[0].SExposureData_020;
  float _107 = t0[0].SExposureData_004;
  float _109 = cb2_018x * 0.5f;
  float _110 = _109 * cb2_018y;
  float _111 = _107.x - _110;
  float _112 = cb2_018y * cb2_018x;
  float _113 = 1.0f / _112;
  float _114 = _111 * _113;
  float _115 = _101 / _105.x;
  float _116 = _115 * 5464.01611328125f;
  float _117 = _116 + 9.99999993922529e-09f;
  float _118 = log2(_117);
  float _119 = _118 - _111;
  float _120 = _119 * _113;
  float _121 = saturate(_120);
  float2 _122 = t7.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _121), 0.0f);
  float _125 = max(_122.y, 1.0000000116860974e-07f);
  float _126 = _122.x / _125;
  float _127 = _126 + _114;
  float _128 = _127 / _113;
  float _129 = _128 - _107.x;
  float _130 = -0.0f - _129;
  float _132 = _130 - cb2_027x;
  float _133 = max(0.0f, _132);
  float _135 = cb2_026z * _133;
  float _136 = _129 - cb2_027x;
  float _137 = max(0.0f, _136);
  float _139 = cb2_026w * _137;
  bool _140 = (_129 < 0.0f);
  float _141 = select(_140, _135, _139);
  float _142 = exp2(_141);
  float _143 = _142 * _98;
  float _144 = _142 * _99;
  float _145 = _142 * _100;
  float _150 = cb2_024y * _88.x;
  float _151 = cb2_024z * _88.y;
  float _152 = cb2_024w * _88.z;
  float _153 = _150 + _143;
  float _154 = _151 + _144;
  float _155 = _152 + _145;
  float _160 = _153 * cb2_025x;
  float _161 = _154 * cb2_025y;
  float _162 = _155 * cb2_025z;
  float _163 = dot(float3(_160, _161, _162), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _164 = t0[0].SExposureData_012;
  float _166 = _163 * 5464.01611328125f;
  float _167 = _166 * _164.x;
  float _168 = _167 + 9.99999993922529e-09f;
  float _169 = log2(_168);
  float _170 = _169 + 16.929765701293945f;
  float _171 = _170 * 0.05734497308731079f;
  float _172 = saturate(_171);
  float _173 = _172 * _172;
  float _174 = _172 * 2.0f;
  float _175 = 3.0f - _174;
  float _176 = _173 * _175;
  float _177 = _161 * 0.8450999855995178f;
  float _178 = _162 * 0.14589999616146088f;
  float _179 = _177 + _178;
  float _180 = _179 * 2.4890189170837402f;
  float _181 = _179 * 0.3754962384700775f;
  float _182 = _179 * 2.811495304107666f;
  float _183 = _179 * 5.519708156585693f;
  float _184 = _163 - _180;
  float _185 = _176 * _184;
  float _186 = _185 + _180;
  float _187 = _176 * 0.5f;
  float _188 = _187 + 0.5f;
  float _189 = _188 * _184;
  float _190 = _189 + _180;
  float _191 = _160 - _181;
  float _192 = _161 - _182;
  float _193 = _162 - _183;
  float _194 = _188 * _191;
  float _195 = _188 * _192;
  float _196 = _188 * _193;
  float _197 = _194 + _181;
  float _198 = _195 + _182;
  float _199 = _196 + _183;
  float _200 = 1.0f / _190;
  float _201 = _186 * _200;
  float _202 = _201 * _197;
  float _203 = _201 * _198;
  float _204 = _201 * _199;
  float _208 = cb2_020x * TEXCOORD0_centroid.x;
  float _209 = cb2_020y * TEXCOORD0_centroid.y;
  float _212 = _208 + cb2_020z;
  float _213 = _209 + cb2_020w;
  float _216 = dot(float2(_212, _213), float2(_212, _213));
  float _217 = 1.0f - _216;
  float _218 = saturate(_217);
  float _219 = log2(_218);
  float _220 = _219 * cb2_021w;
  float _221 = exp2(_220);
  float _225 = _202 - cb2_021x;
  float _226 = _203 - cb2_021y;
  float _227 = _204 - cb2_021z;
  float _228 = _225 * _221;
  float _229 = _226 * _221;
  float _230 = _227 * _221;
  float _231 = _228 + cb2_021x;
  float _232 = _229 + cb2_021y;
  float _233 = _230 + cb2_021z;
  float _234 = t0[0].SExposureData_000;
  float _236 = max(_105.x, 0.0010000000474974513f);
  float _237 = 1.0f / _236;
  float _238 = _237 * _234.x;
  bool _241 = ((uint)(cb2_069y) == 0);
  float _247;
  float _248;
  float _249;
  float _303;
  float _304;
  float _305;
  float _380;
  float _381;
  float _382;
  float _483;
  float _484;
  float _485;
  float _510;
  float _522;
  float _550;
  float _562;
  float _574;
  float _575;
  float _576;
  float _603;
  float _604;
  float _605;
  if (!_241) {
    float _243 = _238 * _231;
    float _244 = _238 * _232;
    float _245 = _238 * _233;
    _247 = _243;
    _248 = _244;
    _249 = _245;
  } else {
    _247 = _231;
    _248 = _232;
    _249 = _233;
  }
  float _250 = _247 * 0.6130970120429993f;
  float _251 = mad(0.33952298760414124f, _248, _250);
  float _252 = mad(0.04737899824976921f, _249, _251);
  float _253 = _247 * 0.07019399851560593f;
  float _254 = mad(0.9163540005683899f, _248, _253);
  float _255 = mad(0.013451999984681606f, _249, _254);
  float _256 = _247 * 0.02061600051820278f;
  float _257 = mad(0.10956999659538269f, _248, _256);
  float _258 = mad(0.8698149919509888f, _249, _257);
  float _259 = log2(_252);
  float _260 = log2(_255);
  float _261 = log2(_258);
  float _262 = _259 * 0.04211956635117531f;
  float _263 = _260 * 0.04211956635117531f;
  float _264 = _261 * 0.04211956635117531f;
  float _265 = _262 + 0.6252607107162476f;
  float _266 = _263 + 0.6252607107162476f;
  float _267 = _264 + 0.6252607107162476f;
  float4 _268 = t5.SampleLevel(s2_space2, float3(_265, _266, _267), 0.0f);
  bool _274 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_274 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _278 = cb2_017x * _268.x;
    float _279 = cb2_017x * _268.y;
    float _280 = cb2_017x * _268.z;
    float _282 = _278 + cb2_017y;
    float _283 = _279 + cb2_017y;
    float _284 = _280 + cb2_017y;
    float _285 = exp2(_282);
    float _286 = exp2(_283);
    float _287 = exp2(_284);
    float _288 = _285 + 1.0f;
    float _289 = _286 + 1.0f;
    float _290 = _287 + 1.0f;
    float _291 = 1.0f / _288;
    float _292 = 1.0f / _289;
    float _293 = 1.0f / _290;
    float _295 = cb2_017z * _291;
    float _296 = cb2_017z * _292;
    float _297 = cb2_017z * _293;
    float _299 = _295 + cb2_017w;
    float _300 = _296 + cb2_017w;
    float _301 = _297 + cb2_017w;
    _303 = _299;
    _304 = _300;
    _305 = _301;
  } else {
    _303 = _268.x;
    _304 = _268.y;
    _305 = _268.z;
  }
  float _306 = _303 * 23.0f;
  float _307 = _306 + -14.473931312561035f;
  float _308 = exp2(_307);
  float _309 = _304 * 23.0f;
  float _310 = _309 + -14.473931312561035f;
  float _311 = exp2(_310);
  float _312 = _305 * 23.0f;
  float _313 = _312 + -14.473931312561035f;
  float _314 = exp2(_313);
  float _315 = dot(float3(_308, _311, _314), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _320 = dot(float3(_308, _311, _314), float3(_308, _311, _314));
  float _321 = rsqrt(_320);
  float _322 = _321 * _308;
  float _323 = _321 * _311;
  float _324 = _321 * _314;
  float _325 = cb2_001x - _322;
  float _326 = cb2_001y - _323;
  float _327 = cb2_001z - _324;
  float _328 = dot(float3(_325, _326, _327), float3(_325, _326, _327));
  float _331 = cb2_002z * _328;
  float _333 = _331 + cb2_002w;
  float _334 = saturate(_333);
  float _336 = cb2_002x * _334;
  float _337 = _315 - _308;
  float _338 = _315 - _311;
  float _339 = _315 - _314;
  float _340 = _336 * _337;
  float _341 = _336 * _338;
  float _342 = _336 * _339;
  float _343 = _340 + _308;
  float _344 = _341 + _311;
  float _345 = _342 + _314;
  float _347 = cb2_002y * _334;
  float _348 = 0.10000000149011612f - _343;
  float _349 = 0.10000000149011612f - _344;
  float _350 = 0.10000000149011612f - _345;
  float _351 = _348 * _347;
  float _352 = _349 * _347;
  float _353 = _350 * _347;
  float _354 = _351 + _343;
  float _355 = _352 + _344;
  float _356 = _353 + _345;
  float _357 = saturate(_354);
  float _358 = saturate(_355);
  float _359 = saturate(_356);
  float _365 = cb2_016x - _357;
  float _366 = cb2_016y - _358;
  float _367 = cb2_016z - _359;
  float _368 = _365 * cb2_016w;
  float _369 = _366 * cb2_016w;
  float _370 = _367 * cb2_016w;
  float _371 = _368 + _357;
  float _372 = _369 + _358;
  float _373 = _370 + _359;
  if (_274 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _376 = cb2_024x * _371;
    float _377 = cb2_024x * _372;
    float _378 = cb2_024x * _373;
    _380 = _376;
    _381 = _377;
    _382 = _378;
  } else {
    _380 = _371;
    _381 = _372;
    _382 = _373;
  }
  float _383 = _380 * 0.9708889722824097f;
  float _384 = mad(0.026962999254465103f, _381, _383);
  float _385 = mad(0.002148000057786703f, _382, _384);
  float _386 = _380 * 0.01088900025933981f;
  float _387 = mad(0.9869629740715027f, _381, _386);
  float _388 = mad(0.002148000057786703f, _382, _387);
  float _389 = mad(0.026962999254465103f, _381, _386);
  float _390 = mad(0.9621480107307434f, _382, _389);
  if (_274) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _395 = cb1_018y * 0.10000000149011612f;
        float _396 = log2(cb1_018z);
        float _397 = _396 + -13.287712097167969f;
        float _398 = _397 * 1.4929734468460083f;
        float _399 = _398 + 18.0f;
        float _400 = exp2(_399);
        float _401 = _400 * 0.18000000715255737f;
        float _402 = abs(_401);
        float _403 = log2(_402);
        float _404 = _403 * 1.5f;
        float _405 = exp2(_404);
        float _406 = _405 * _395;
        float _407 = _406 / cb1_018z;
        float _408 = _407 + -0.07636754959821701f;
        float _409 = _403 * 1.2750000953674316f;
        float _410 = exp2(_409);
        float _411 = _410 * 0.07636754959821701f;
        float _412 = cb1_018y * 0.011232397519052029f;
        float _413 = _412 * _405;
        float _414 = _413 / cb1_018z;
        float _415 = _411 - _414;
        float _416 = _410 + -0.11232396960258484f;
        float _417 = _416 * _395;
        float _418 = _417 / cb1_018z;
        float _419 = _418 * cb1_018z;
        float _420 = abs(_385);
        float _421 = abs(_388);
        float _422 = abs(_390);
        float _423 = log2(_420);
        float _424 = log2(_421);
        float _425 = log2(_422);
        float _426 = _423 * 1.5f;
        float _427 = _424 * 1.5f;
        float _428 = _425 * 1.5f;
        float _429 = exp2(_426);
        float _430 = exp2(_427);
        float _431 = exp2(_428);
        float _432 = _429 * _419;
        float _433 = _430 * _419;
        float _434 = _431 * _419;
        float _435 = _423 * 1.2750000953674316f;
        float _436 = _424 * 1.2750000953674316f;
        float _437 = _425 * 1.2750000953674316f;
        float _438 = exp2(_435);
        float _439 = exp2(_436);
        float _440 = exp2(_437);
        float _441 = _438 * _408;
        float _442 = _439 * _408;
        float _443 = _440 * _408;
        float _444 = _441 + _415;
        float _445 = _442 + _415;
        float _446 = _443 + _415;
        float _447 = _432 / _444;
        float _448 = _433 / _445;
        float _449 = _434 / _446;
        float _450 = _447 * 9.999999747378752e-05f;
        float _451 = _448 * 9.999999747378752e-05f;
        float _452 = _449 * 9.999999747378752e-05f;
        float _453 = 5000.0f / cb1_018y;
        float _454 = _450 * _453;
        float _455 = _451 * _453;
        float _456 = _452 * _453;
        _483 = _454;
        _484 = _455;
        _485 = _456;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_385, _388, _390));
      _483 = tonemapped.x, _484 = tonemapped.y, _485 = tonemapped.z;
    }
      } else {
        float _458 = _385 + 0.020616600289940834f;
        float _459 = _388 + 0.020616600289940834f;
        float _460 = _390 + 0.020616600289940834f;
        float _461 = _458 * _385;
        float _462 = _459 * _388;
        float _463 = _460 * _390;
        float _464 = _461 + -7.456949970219284e-05f;
        float _465 = _462 + -7.456949970219284e-05f;
        float _466 = _463 + -7.456949970219284e-05f;
        float _467 = _385 * 0.9837960004806519f;
        float _468 = _388 * 0.9837960004806519f;
        float _469 = _390 * 0.9837960004806519f;
        float _470 = _467 + 0.4336790144443512f;
        float _471 = _468 + 0.4336790144443512f;
        float _472 = _469 + 0.4336790144443512f;
        float _473 = _470 * _385;
        float _474 = _471 * _388;
        float _475 = _472 * _390;
        float _476 = _473 + 0.24617899954319f;
        float _477 = _474 + 0.24617899954319f;
        float _478 = _475 + 0.24617899954319f;
        float _479 = _464 / _476;
        float _480 = _465 / _477;
        float _481 = _466 / _478;
        _483 = _479;
        _484 = _480;
        _485 = _481;
      }
      float _486 = _483 * 1.6047500371932983f;
      float _487 = mad(-0.5310800075531006f, _484, _486);
      float _488 = mad(-0.07366999983787537f, _485, _487);
      float _489 = _483 * -0.10208000242710114f;
      float _490 = mad(1.1081299781799316f, _484, _489);
      float _491 = mad(-0.006049999967217445f, _485, _490);
      float _492 = _483 * -0.0032599999103695154f;
      float _493 = mad(-0.07275000214576721f, _484, _492);
      float _494 = mad(1.0760200023651123f, _485, _493);
      if (_274) {
        // float _496 = max(_488, 0.0f);
        // float _497 = max(_491, 0.0f);
        // float _498 = max(_494, 0.0f);
        // bool _499 = !(_496 >= 0.0030399328097701073f);
        // if (!_499) {
        //   float _501 = abs(_496);
        //   float _502 = log2(_501);
        //   float _503 = _502 * 0.4166666567325592f;
        //   float _504 = exp2(_503);
        //   float _505 = _504 * 1.0549999475479126f;
        //   float _506 = _505 + -0.054999999701976776f;
        //   _510 = _506;
        // } else {
        //   float _508 = _496 * 12.923210144042969f;
        //   _510 = _508;
        // }
        // bool _511 = !(_497 >= 0.0030399328097701073f);
        // if (!_511) {
        //   float _513 = abs(_497);
        //   float _514 = log2(_513);
        //   float _515 = _514 * 0.4166666567325592f;
        //   float _516 = exp2(_515);
        //   float _517 = _516 * 1.0549999475479126f;
        //   float _518 = _517 + -0.054999999701976776f;
        //   _522 = _518;
        // } else {
        //   float _520 = _497 * 12.923210144042969f;
        //   _522 = _520;
        // }
        // bool _523 = !(_498 >= 0.0030399328097701073f);
        // if (!_523) {
        //   float _525 = abs(_498);
        //   float _526 = log2(_525);
        //   float _527 = _526 * 0.4166666567325592f;
        //   float _528 = exp2(_527);
        //   float _529 = _528 * 1.0549999475479126f;
        //   float _530 = _529 + -0.054999999701976776f;
        //   _603 = _510;
        //   _604 = _522;
        //   _605 = _530;
        // } else {
        //   float _532 = _498 * 12.923210144042969f;
        //   _603 = _510;
        //   _604 = _522;
        //   _605 = _532;
        // }
        _603 = renodx::color::srgb::EncodeSafe(_488);
        _604 = renodx::color::srgb::EncodeSafe(_491);
        _605 = renodx::color::srgb::EncodeSafe(_494);

      } else {
        float _534 = saturate(_488);
        float _535 = saturate(_491);
        float _536 = saturate(_494);
        bool _537 = ((uint)(cb1_018w) == -2);
        if (!_537) {
          bool _539 = !(_534 >= 0.0030399328097701073f);
          if (!_539) {
            float _541 = abs(_534);
            float _542 = log2(_541);
            float _543 = _542 * 0.4166666567325592f;
            float _544 = exp2(_543);
            float _545 = _544 * 1.0549999475479126f;
            float _546 = _545 + -0.054999999701976776f;
            _550 = _546;
          } else {
            float _548 = _534 * 12.923210144042969f;
            _550 = _548;
          }
          bool _551 = !(_535 >= 0.0030399328097701073f);
          if (!_551) {
            float _553 = abs(_535);
            float _554 = log2(_553);
            float _555 = _554 * 0.4166666567325592f;
            float _556 = exp2(_555);
            float _557 = _556 * 1.0549999475479126f;
            float _558 = _557 + -0.054999999701976776f;
            _562 = _558;
          } else {
            float _560 = _535 * 12.923210144042969f;
            _562 = _560;
          }
          bool _563 = !(_536 >= 0.0030399328097701073f);
          if (!_563) {
            float _565 = abs(_536);
            float _566 = log2(_565);
            float _567 = _566 * 0.4166666567325592f;
            float _568 = exp2(_567);
            float _569 = _568 * 1.0549999475479126f;
            float _570 = _569 + -0.054999999701976776f;
            _574 = _550;
            _575 = _562;
            _576 = _570;
          } else {
            float _572 = _536 * 12.923210144042969f;
            _574 = _550;
            _575 = _562;
            _576 = _572;
          }
        } else {
          _574 = _534;
          _575 = _535;
          _576 = _536;
        }
        float _581 = abs(_574);
        float _582 = abs(_575);
        float _583 = abs(_576);
        float _584 = log2(_581);
        float _585 = log2(_582);
        float _586 = log2(_583);
        float _587 = _584 * cb2_000z;
        float _588 = _585 * cb2_000z;
        float _589 = _586 * cb2_000z;
        float _590 = exp2(_587);
        float _591 = exp2(_588);
        float _592 = exp2(_589);
        float _593 = _590 * cb2_000y;
        float _594 = _591 * cb2_000y;
        float _595 = _592 * cb2_000y;
        float _596 = _593 + cb2_000x;
        float _597 = _594 + cb2_000x;
        float _598 = _595 + cb2_000x;
        float _599 = saturate(_596);
        float _600 = saturate(_597);
        float _601 = saturate(_598);
        _603 = _599;
        _604 = _600;
        _605 = _601;
      }
      float _606 = dot(float3(_603, _604, _605), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _603;
      SV_Target.y = _604;
      SV_Target.z = _605;
      SV_Target.w = _606;
      SV_Target_1.x = _606;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

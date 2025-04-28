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

Texture3D<float2> t6 : register(t6);

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
  float cb2_026z : packoffset(c026.z);
  float cb2_026w : packoffset(c026.w);
  float cb2_027x : packoffset(c027.x);
  float cb2_027y : packoffset(c027.y);
  float cb2_027z : packoffset(c027.z);
  float cb2_027w : packoffset(c027.w);
  uint cb2_069y : packoffset(c069.y);
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
  float _18 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _20 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _24 = max(_20.x, 0.0f);
  float _25 = max(_20.y, 0.0f);
  float _26 = max(_20.z, 0.0f);
  float _27 = min(_24, 65000.0f);
  float _28 = min(_25, 65000.0f);
  float _29 = min(_26, 65000.0f);
  float4 _30 = t3.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _35 = max(_30.x, 0.0f);
  float _36 = max(_30.y, 0.0f);
  float _37 = max(_30.z, 0.0f);
  float _38 = max(_30.w, 0.0f);
  float _39 = min(_35, 5000.0f);
  float _40 = min(_36, 5000.0f);
  float _41 = min(_37, 5000.0f);
  float _42 = min(_38, 5000.0f);
  float _45 = _18.x * cb0_028z;
  float _46 = _45 + cb0_028x;
  float _47 = cb2_027w / _46;
  float _48 = 1.0f - _47;
  float _49 = abs(_48);
  float _51 = cb2_027y * _49;
  float _53 = _51 - cb2_027z;
  float _54 = saturate(_53);
  float _55 = max(_54, _42);
  float _56 = saturate(_55);
  float4 _57 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _61 = _39 - _27;
  float _62 = _40 - _28;
  float _63 = _41 - _29;
  float _64 = _56 * _61;
  float _65 = _56 * _62;
  float _66 = _56 * _63;
  float _67 = _64 + _27;
  float _68 = _65 + _28;
  float _69 = _66 + _29;
  float _70 = dot(float3(_67, _68, _69), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _74 = t0[0].SExposureData_020;
  float _76 = t0[0].SExposureData_004;
  float _78 = cb2_018x * 0.5f;
  float _79 = _78 * cb2_018y;
  float _80 = _76.x - _79;
  float _81 = cb2_018y * cb2_018x;
  float _82 = 1.0f / _81;
  float _83 = _80 * _82;
  float _84 = _70 / _74.x;
  float _85 = _84 * 5464.01611328125f;
  float _86 = _85 + 9.99999993922529e-09f;
  float _87 = log2(_86);
  float _88 = _87 - _80;
  float _89 = _88 * _82;
  float _90 = saturate(_89);
  float2 _91 = t6.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _90), 0.0f);
  float _94 = max(_91.y, 1.0000000116860974e-07f);
  float _95 = _91.x / _94;
  float _96 = _95 + _83;
  float _97 = _96 / _82;
  float _98 = _97 - _76.x;
  float _99 = -0.0f - _98;
  float _101 = _99 - cb2_027x;
  float _102 = max(0.0f, _101);
  float _105 = cb2_026z * _102;
  float _106 = _98 - cb2_027x;
  float _107 = max(0.0f, _106);
  float _109 = cb2_026w * _107;
  bool _110 = (_98 < 0.0f);
  float _111 = select(_110, _105, _109);
  float _112 = exp2(_111);
  float _113 = _112 * _67;
  float _114 = _112 * _68;
  float _115 = _112 * _69;
  float _120 = cb2_024y * _57.x;
  float _121 = cb2_024z * _57.y;
  float _122 = cb2_024w * _57.z;
  float _123 = _120 + _113;
  float _124 = _121 + _114;
  float _125 = _122 + _115;
  float _130 = _123 * cb2_025x;
  float _131 = _124 * cb2_025y;
  float _132 = _125 * cb2_025z;
  float _133 = dot(float3(_130, _131, _132), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _134 = t0[0].SExposureData_012;
  float _136 = _133 * 5464.01611328125f;
  float _137 = _136 * _134.x;
  float _138 = _137 + 9.99999993922529e-09f;
  float _139 = log2(_138);
  float _140 = _139 + 16.929765701293945f;
  float _141 = _140 * 0.05734497308731079f;
  float _142 = saturate(_141);
  float _143 = _142 * _142;
  float _144 = _142 * 2.0f;
  float _145 = 3.0f - _144;
  float _146 = _143 * _145;
  float _147 = _131 * 0.8450999855995178f;
  float _148 = _132 * 0.14589999616146088f;
  float _149 = _147 + _148;
  float _150 = _149 * 2.4890189170837402f;
  float _151 = _149 * 0.3754962384700775f;
  float _152 = _149 * 2.811495304107666f;
  float _153 = _149 * 5.519708156585693f;
  float _154 = _133 - _150;
  float _155 = _146 * _154;
  float _156 = _155 + _150;
  float _157 = _146 * 0.5f;
  float _158 = _157 + 0.5f;
  float _159 = _158 * _154;
  float _160 = _159 + _150;
  float _161 = _130 - _151;
  float _162 = _131 - _152;
  float _163 = _132 - _153;
  float _164 = _158 * _161;
  float _165 = _158 * _162;
  float _166 = _158 * _163;
  float _167 = _164 + _151;
  float _168 = _165 + _152;
  float _169 = _166 + _153;
  float _170 = 1.0f / _160;
  float _171 = _156 * _170;
  float _172 = _171 * _167;
  float _173 = _171 * _168;
  float _174 = _171 * _169;
  float _178 = cb2_020x * TEXCOORD0_centroid.x;
  float _179 = cb2_020y * TEXCOORD0_centroid.y;
  float _182 = _178 + cb2_020z;
  float _183 = _179 + cb2_020w;
  float _186 = dot(float2(_182, _183), float2(_182, _183));
  float _187 = 1.0f - _186;
  float _188 = saturate(_187);
  float _189 = log2(_188);
  float _190 = _189 * cb2_021w;
  float _191 = exp2(_190);
  float _195 = _172 - cb2_021x;
  float _196 = _173 - cb2_021y;
  float _197 = _174 - cb2_021z;
  float _198 = _195 * _191;
  float _199 = _196 * _191;
  float _200 = _197 * _191;
  float _201 = _198 + cb2_021x;
  float _202 = _199 + cb2_021y;
  float _203 = _200 + cb2_021z;
  float _204 = t0[0].SExposureData_000;
  float _206 = max(_74.x, 0.0010000000474974513f);
  float _207 = 1.0f / _206;
  float _208 = _207 * _204.x;
  bool _211 = ((uint)(cb2_069y) == 0);
  float _217;
  float _218;
  float _219;
  float _273;
  float _274;
  float _275;
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
  if (!_211) {
    float _213 = _208 * _201;
    float _214 = _208 * _202;
    float _215 = _208 * _203;
    _217 = _213;
    _218 = _214;
    _219 = _215;
  } else {
    _217 = _201;
    _218 = _202;
    _219 = _203;
  }
  float _220 = _217 * 0.6130970120429993f;
  float _221 = mad(0.33952298760414124f, _218, _220);
  float _222 = mad(0.04737899824976921f, _219, _221);
  float _223 = _217 * 0.07019399851560593f;
  float _224 = mad(0.9163540005683899f, _218, _223);
  float _225 = mad(0.013451999984681606f, _219, _224);
  float _226 = _217 * 0.02061600051820278f;
  float _227 = mad(0.10956999659538269f, _218, _226);
  float _228 = mad(0.8698149919509888f, _219, _227);
  float _229 = log2(_222);
  float _230 = log2(_225);
  float _231 = log2(_228);
  float _232 = _229 * 0.04211956635117531f;
  float _233 = _230 * 0.04211956635117531f;
  float _234 = _231 * 0.04211956635117531f;
  float _235 = _232 + 0.6252607107162476f;
  float _236 = _233 + 0.6252607107162476f;
  float _237 = _234 + 0.6252607107162476f;
  float4 _238 = t5.SampleLevel(s2_space2, float3(_235, _236, _237), 0.0f);
  bool _244 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_244 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _248 = cb2_017x * _238.x;
    float _249 = cb2_017x * _238.y;
    float _250 = cb2_017x * _238.z;
    float _252 = _248 + cb2_017y;
    float _253 = _249 + cb2_017y;
    float _254 = _250 + cb2_017y;
    float _255 = exp2(_252);
    float _256 = exp2(_253);
    float _257 = exp2(_254);
    float _258 = _255 + 1.0f;
    float _259 = _256 + 1.0f;
    float _260 = _257 + 1.0f;
    float _261 = 1.0f / _258;
    float _262 = 1.0f / _259;
    float _263 = 1.0f / _260;
    float _265 = cb2_017z * _261;
    float _266 = cb2_017z * _262;
    float _267 = cb2_017z * _263;
    float _269 = _265 + cb2_017w;
    float _270 = _266 + cb2_017w;
    float _271 = _267 + cb2_017w;
    _273 = _269;
    _274 = _270;
    _275 = _271;
  } else {
    _273 = _238.x;
    _274 = _238.y;
    _275 = _238.z;
  }
  float _276 = _273 * 23.0f;
  float _277 = _276 + -14.473931312561035f;
  float _278 = exp2(_277);
  float _279 = _274 * 23.0f;
  float _280 = _279 + -14.473931312561035f;
  float _281 = exp2(_280);
  float _282 = _275 * 23.0f;
  float _283 = _282 + -14.473931312561035f;
  float _284 = exp2(_283);
  float _285 = dot(float3(_278, _281, _284), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _290 = dot(float3(_278, _281, _284), float3(_278, _281, _284));
  float _291 = rsqrt(_290);
  float _292 = _291 * _278;
  float _293 = _291 * _281;
  float _294 = _291 * _284;
  float _295 = cb2_001x - _292;
  float _296 = cb2_001y - _293;
  float _297 = cb2_001z - _294;
  float _298 = dot(float3(_295, _296, _297), float3(_295, _296, _297));
  float _301 = cb2_002z * _298;
  float _303 = _301 + cb2_002w;
  float _304 = saturate(_303);
  float _306 = cb2_002x * _304;
  float _307 = _285 - _278;
  float _308 = _285 - _281;
  float _309 = _285 - _284;
  float _310 = _306 * _307;
  float _311 = _306 * _308;
  float _312 = _306 * _309;
  float _313 = _310 + _278;
  float _314 = _311 + _281;
  float _315 = _312 + _284;
  float _317 = cb2_002y * _304;
  float _318 = 0.10000000149011612f - _313;
  float _319 = 0.10000000149011612f - _314;
  float _320 = 0.10000000149011612f - _315;
  float _321 = _318 * _317;
  float _322 = _319 * _317;
  float _323 = _320 * _317;
  float _324 = _321 + _313;
  float _325 = _322 + _314;
  float _326 = _323 + _315;
  float _327 = saturate(_324);
  float _328 = saturate(_325);
  float _329 = saturate(_326);
  float _335 = cb2_016x - _327;
  float _336 = cb2_016y - _328;
  float _337 = cb2_016z - _329;
  float _338 = _335 * cb2_016w;
  float _339 = _336 * cb2_016w;
  float _340 = _337 * cb2_016w;
  float _341 = _338 + _327;
  float _342 = _339 + _328;
  float _343 = _340 + _329;
  if (_244 && RENODX_TONE_MAP_TYPE == 0.f) {
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
  if (_244) {
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
      if (_244) {
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
      float _576 = dot(float3(_573, _574, _575), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _573;
      SV_Target.y = _574;
      SV_Target.z = _575;
      SV_Target.w = _576;
      SV_Target_1.x = _576;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

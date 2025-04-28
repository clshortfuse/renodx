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
  float cb2_005x : packoffset(c005.x);
  float cb2_006x : packoffset(c006.x);
  float cb2_006y : packoffset(c006.y);
  float cb2_006z : packoffset(c006.z);
  float cb2_006w : packoffset(c006.w);
  float cb2_007x : packoffset(c007.x);
  float cb2_007y : packoffset(c007.y);
  float cb2_007z : packoffset(c007.z);
  float cb2_007w : packoffset(c007.w);
  float cb2_008x : packoffset(c008.x);
  float cb2_008y : packoffset(c008.y);
  float cb2_008z : packoffset(c008.z);
  float cb2_008w : packoffset(c008.w);
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
  float _19 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _21 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _25 = max(_21.x, 0.0f);
  float _26 = max(_21.y, 0.0f);
  float _27 = max(_21.z, 0.0f);
  float _28 = min(_25, 65000.0f);
  float _29 = min(_26, 65000.0f);
  float _30 = min(_27, 65000.0f);
  float4 _31 = t3.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _36 = max(_31.x, 0.0f);
  float _37 = max(_31.y, 0.0f);
  float _38 = max(_31.z, 0.0f);
  float _39 = max(_31.w, 0.0f);
  float _40 = min(_36, 5000.0f);
  float _41 = min(_37, 5000.0f);
  float _42 = min(_38, 5000.0f);
  float _43 = min(_39, 5000.0f);
  float _46 = _19.x * cb0_028z;
  float _47 = _46 + cb0_028x;
  float _48 = cb2_027w / _47;
  float _49 = 1.0f - _48;
  float _50 = abs(_49);
  float _52 = cb2_027y * _50;
  float _54 = _52 - cb2_027z;
  float _55 = saturate(_54);
  float _56 = max(_55, _43);
  float _57 = saturate(_56);
  float _61 = cb2_006x * TEXCOORD0_centroid.x;
  float _62 = cb2_006y * TEXCOORD0_centroid.y;
  float _65 = _61 + cb2_006z;
  float _66 = _62 + cb2_006w;
  float _70 = cb2_007x * TEXCOORD0_centroid.x;
  float _71 = cb2_007y * TEXCOORD0_centroid.y;
  float _74 = _70 + cb2_007z;
  float _75 = _71 + cb2_007w;
  float _79 = cb2_008x * TEXCOORD0_centroid.x;
  float _80 = cb2_008y * TEXCOORD0_centroid.y;
  float _83 = _79 + cb2_008z;
  float _84 = _80 + cb2_008w;
  float4 _85 = t1.SampleLevel(s2_space2, float2(_65, _66), 0.0f);
  float _87 = max(_85.x, 0.0f);
  float _88 = min(_87, 65000.0f);
  float4 _89 = t1.SampleLevel(s2_space2, float2(_74, _75), 0.0f);
  float _91 = max(_89.y, 0.0f);
  float _92 = min(_91, 65000.0f);
  float4 _93 = t1.SampleLevel(s2_space2, float2(_83, _84), 0.0f);
  float _95 = max(_93.z, 0.0f);
  float _96 = min(_95, 65000.0f);
  float4 _97 = t3.SampleLevel(s2_space2, float2(_65, _66), 0.0f);
  float _99 = max(_97.x, 0.0f);
  float _100 = min(_99, 5000.0f);
  float4 _101 = t3.SampleLevel(s2_space2, float2(_74, _75), 0.0f);
  float _103 = max(_101.y, 0.0f);
  float _104 = min(_103, 5000.0f);
  float4 _105 = t3.SampleLevel(s2_space2, float2(_83, _84), 0.0f);
  float _107 = max(_105.z, 0.0f);
  float _108 = min(_107, 5000.0f);
  float4 _109 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _115 = cb2_005x * _109.x;
  float _116 = cb2_005x * _109.y;
  float _117 = cb2_005x * _109.z;
  float _118 = _88 - _28;
  float _119 = _92 - _29;
  float _120 = _96 - _30;
  float _121 = _115 * _118;
  float _122 = _116 * _119;
  float _123 = _117 * _120;
  float _124 = _121 + _28;
  float _125 = _122 + _29;
  float _126 = _123 + _30;
  float _127 = _100 - _40;
  float _128 = _104 - _41;
  float _129 = _108 - _42;
  float _130 = _115 * _127;
  float _131 = _116 * _128;
  float _132 = _117 * _129;
  float _133 = _130 + _40;
  float _134 = _131 + _41;
  float _135 = _132 + _42;
  float4 _136 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _140 = _133 - _124;
  float _141 = _134 - _125;
  float _142 = _135 - _126;
  float _143 = _140 * _57;
  float _144 = _141 * _57;
  float _145 = _142 * _57;
  float _146 = _143 + _124;
  float _147 = _144 + _125;
  float _148 = _145 + _126;
  float _149 = dot(float3(_146, _147, _148), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _153 = t0[0].SExposureData_020;
  float _155 = t0[0].SExposureData_004;
  float _157 = cb2_018x * 0.5f;
  float _158 = _157 * cb2_018y;
  float _159 = _155.x - _158;
  float _160 = cb2_018y * cb2_018x;
  float _161 = 1.0f / _160;
  float _162 = _159 * _161;
  float _163 = _149 / _153.x;
  float _164 = _163 * 5464.01611328125f;
  float _165 = _164 + 9.99999993922529e-09f;
  float _166 = log2(_165);
  float _167 = _166 - _159;
  float _168 = _167 * _161;
  float _169 = saturate(_168);
  float2 _170 = t7.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _169), 0.0f);
  float _173 = max(_170.y, 1.0000000116860974e-07f);
  float _174 = _170.x / _173;
  float _175 = _174 + _162;
  float _176 = _175 / _161;
  float _177 = _176 - _155.x;
  float _178 = -0.0f - _177;
  float _180 = _178 - cb2_027x;
  float _181 = max(0.0f, _180);
  float _184 = cb2_026z * _181;
  float _185 = _177 - cb2_027x;
  float _186 = max(0.0f, _185);
  float _188 = cb2_026w * _186;
  bool _189 = (_177 < 0.0f);
  float _190 = select(_189, _184, _188);
  float _191 = exp2(_190);
  float _192 = _191 * _146;
  float _193 = _191 * _147;
  float _194 = _191 * _148;
  float _199 = cb2_024y * _136.x;
  float _200 = cb2_024z * _136.y;
  float _201 = cb2_024w * _136.z;
  float _202 = _199 + _192;
  float _203 = _200 + _193;
  float _204 = _201 + _194;
  float _209 = _202 * cb2_025x;
  float _210 = _203 * cb2_025y;
  float _211 = _204 * cb2_025z;
  float _212 = dot(float3(_209, _210, _211), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _213 = t0[0].SExposureData_012;
  float _215 = _212 * 5464.01611328125f;
  float _216 = _215 * _213.x;
  float _217 = _216 + 9.99999993922529e-09f;
  float _218 = log2(_217);
  float _219 = _218 + 16.929765701293945f;
  float _220 = _219 * 0.05734497308731079f;
  float _221 = saturate(_220);
  float _222 = _221 * _221;
  float _223 = _221 * 2.0f;
  float _224 = 3.0f - _223;
  float _225 = _222 * _224;
  float _226 = _210 * 0.8450999855995178f;
  float _227 = _211 * 0.14589999616146088f;
  float _228 = _226 + _227;
  float _229 = _228 * 2.4890189170837402f;
  float _230 = _228 * 0.3754962384700775f;
  float _231 = _228 * 2.811495304107666f;
  float _232 = _228 * 5.519708156585693f;
  float _233 = _212 - _229;
  float _234 = _225 * _233;
  float _235 = _234 + _229;
  float _236 = _225 * 0.5f;
  float _237 = _236 + 0.5f;
  float _238 = _237 * _233;
  float _239 = _238 + _229;
  float _240 = _209 - _230;
  float _241 = _210 - _231;
  float _242 = _211 - _232;
  float _243 = _237 * _240;
  float _244 = _237 * _241;
  float _245 = _237 * _242;
  float _246 = _243 + _230;
  float _247 = _244 + _231;
  float _248 = _245 + _232;
  float _249 = 1.0f / _239;
  float _250 = _235 * _249;
  float _251 = _250 * _246;
  float _252 = _250 * _247;
  float _253 = _250 * _248;
  float _257 = cb2_020x * TEXCOORD0_centroid.x;
  float _258 = cb2_020y * TEXCOORD0_centroid.y;
  float _261 = _257 + cb2_020z;
  float _262 = _258 + cb2_020w;
  float _265 = dot(float2(_261, _262), float2(_261, _262));
  float _266 = 1.0f - _265;
  float _267 = saturate(_266);
  float _268 = log2(_267);
  float _269 = _268 * cb2_021w;
  float _270 = exp2(_269);
  float _274 = _251 - cb2_021x;
  float _275 = _252 - cb2_021y;
  float _276 = _253 - cb2_021z;
  float _277 = _274 * _270;
  float _278 = _275 * _270;
  float _279 = _276 * _270;
  float _280 = _277 + cb2_021x;
  float _281 = _278 + cb2_021y;
  float _282 = _279 + cb2_021z;
  float _283 = t0[0].SExposureData_000;
  float _285 = max(_153.x, 0.0010000000474974513f);
  float _286 = 1.0f / _285;
  float _287 = _286 * _283.x;
  bool _290 = ((uint)(cb2_069y) == 0);
  float _296;
  float _297;
  float _298;
  float _352;
  float _353;
  float _354;
  float _384;
  float _385;
  float _386;
  float _487;
  float _488;
  float _489;
  float _514;
  float _526;
  float _554;
  float _566;
  float _578;
  float _579;
  float _580;
  float _607;
  float _608;
  float _609;
  if (!_290) {
    float _292 = _287 * _280;
    float _293 = _287 * _281;
    float _294 = _287 * _282;
    _296 = _292;
    _297 = _293;
    _298 = _294;
  } else {
    _296 = _280;
    _297 = _281;
    _298 = _282;
  }
  float _299 = _296 * 0.6130970120429993f;
  float _300 = mad(0.33952298760414124f, _297, _299);
  float _301 = mad(0.04737899824976921f, _298, _300);
  float _302 = _296 * 0.07019399851560593f;
  float _303 = mad(0.9163540005683899f, _297, _302);
  float _304 = mad(0.013451999984681606f, _298, _303);
  float _305 = _296 * 0.02061600051820278f;
  float _306 = mad(0.10956999659538269f, _297, _305);
  float _307 = mad(0.8698149919509888f, _298, _306);
  float _308 = log2(_301);
  float _309 = log2(_304);
  float _310 = log2(_307);
  float _311 = _308 * 0.04211956635117531f;
  float _312 = _309 * 0.04211956635117531f;
  float _313 = _310 * 0.04211956635117531f;
  float _314 = _311 + 0.6252607107162476f;
  float _315 = _312 + 0.6252607107162476f;
  float _316 = _313 + 0.6252607107162476f;
  float4 _317 = t5.SampleLevel(s2_space2, float3(_314, _315, _316), 0.0f);
  bool _323 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_323 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _327 = cb2_017x * _317.x;
    float _328 = cb2_017x * _317.y;
    float _329 = cb2_017x * _317.z;
    float _331 = _327 + cb2_017y;
    float _332 = _328 + cb2_017y;
    float _333 = _329 + cb2_017y;
    float _334 = exp2(_331);
    float _335 = exp2(_332);
    float _336 = exp2(_333);
    float _337 = _334 + 1.0f;
    float _338 = _335 + 1.0f;
    float _339 = _336 + 1.0f;
    float _340 = 1.0f / _337;
    float _341 = 1.0f / _338;
    float _342 = 1.0f / _339;
    float _344 = cb2_017z * _340;
    float _345 = cb2_017z * _341;
    float _346 = cb2_017z * _342;
    float _348 = _344 + cb2_017w;
    float _349 = _345 + cb2_017w;
    float _350 = _346 + cb2_017w;
    _352 = _348;
    _353 = _349;
    _354 = _350;
  } else {
    _352 = _317.x;
    _353 = _317.y;
    _354 = _317.z;
  }
  float _355 = _352 * 23.0f;
  float _356 = _355 + -14.473931312561035f;
  float _357 = exp2(_356);
  float _358 = _353 * 23.0f;
  float _359 = _358 + -14.473931312561035f;
  float _360 = exp2(_359);
  float _361 = _354 * 23.0f;
  float _362 = _361 + -14.473931312561035f;
  float _363 = exp2(_362);
  float _369 = cb2_016x - _357;
  float _370 = cb2_016y - _360;
  float _371 = cb2_016z - _363;
  float _372 = _369 * cb2_016w;
  float _373 = _370 * cb2_016w;
  float _374 = _371 * cb2_016w;
  float _375 = _372 + _357;
  float _376 = _373 + _360;
  float _377 = _374 + _363;
  if (_323 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _380 = cb2_024x * _375;
    float _381 = cb2_024x * _376;
    float _382 = cb2_024x * _377;
    _384 = _380;
    _385 = _381;
    _386 = _382;
  } else {
    _384 = _375;
    _385 = _376;
    _386 = _377;
  }
  float _387 = _384 * 0.9708889722824097f;
  float _388 = mad(0.026962999254465103f, _385, _387);
  float _389 = mad(0.002148000057786703f, _386, _388);
  float _390 = _384 * 0.01088900025933981f;
  float _391 = mad(0.9869629740715027f, _385, _390);
  float _392 = mad(0.002148000057786703f, _386, _391);
  float _393 = mad(0.026962999254465103f, _385, _390);
  float _394 = mad(0.9621480107307434f, _386, _393);
  if (_323) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _399 = cb1_018y * 0.10000000149011612f;
        float _400 = log2(cb1_018z);
        float _401 = _400 + -13.287712097167969f;
        float _402 = _401 * 1.4929734468460083f;
        float _403 = _402 + 18.0f;
        float _404 = exp2(_403);
        float _405 = _404 * 0.18000000715255737f;
        float _406 = abs(_405);
        float _407 = log2(_406);
        float _408 = _407 * 1.5f;
        float _409 = exp2(_408);
        float _410 = _409 * _399;
        float _411 = _410 / cb1_018z;
        float _412 = _411 + -0.07636754959821701f;
        float _413 = _407 * 1.2750000953674316f;
        float _414 = exp2(_413);
        float _415 = _414 * 0.07636754959821701f;
        float _416 = cb1_018y * 0.011232397519052029f;
        float _417 = _416 * _409;
        float _418 = _417 / cb1_018z;
        float _419 = _415 - _418;
        float _420 = _414 + -0.11232396960258484f;
        float _421 = _420 * _399;
        float _422 = _421 / cb1_018z;
        float _423 = _422 * cb1_018z;
        float _424 = abs(_389);
        float _425 = abs(_392);
        float _426 = abs(_394);
        float _427 = log2(_424);
        float _428 = log2(_425);
        float _429 = log2(_426);
        float _430 = _427 * 1.5f;
        float _431 = _428 * 1.5f;
        float _432 = _429 * 1.5f;
        float _433 = exp2(_430);
        float _434 = exp2(_431);
        float _435 = exp2(_432);
        float _436 = _433 * _423;
        float _437 = _434 * _423;
        float _438 = _435 * _423;
        float _439 = _427 * 1.2750000953674316f;
        float _440 = _428 * 1.2750000953674316f;
        float _441 = _429 * 1.2750000953674316f;
        float _442 = exp2(_439);
        float _443 = exp2(_440);
        float _444 = exp2(_441);
        float _445 = _442 * _412;
        float _446 = _443 * _412;
        float _447 = _444 * _412;
        float _448 = _445 + _419;
        float _449 = _446 + _419;
        float _450 = _447 + _419;
        float _451 = _436 / _448;
        float _452 = _437 / _449;
        float _453 = _438 / _450;
        float _454 = _451 * 9.999999747378752e-05f;
        float _455 = _452 * 9.999999747378752e-05f;
        float _456 = _453 * 9.999999747378752e-05f;
        float _457 = 5000.0f / cb1_018y;
        float _458 = _454 * _457;
        float _459 = _455 * _457;
        float _460 = _456 * _457;
        _487 = _458;
        _488 = _459;
        _489 = _460;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_389, _392, _394));
      _487 = tonemapped.x, _488 = tonemapped.y, _489 = tonemapped.z;
    }
      } else {
        float _462 = _389 + 0.020616600289940834f;
        float _463 = _392 + 0.020616600289940834f;
        float _464 = _394 + 0.020616600289940834f;
        float _465 = _462 * _389;
        float _466 = _463 * _392;
        float _467 = _464 * _394;
        float _468 = _465 + -7.456949970219284e-05f;
        float _469 = _466 + -7.456949970219284e-05f;
        float _470 = _467 + -7.456949970219284e-05f;
        float _471 = _389 * 0.9837960004806519f;
        float _472 = _392 * 0.9837960004806519f;
        float _473 = _394 * 0.9837960004806519f;
        float _474 = _471 + 0.4336790144443512f;
        float _475 = _472 + 0.4336790144443512f;
        float _476 = _473 + 0.4336790144443512f;
        float _477 = _474 * _389;
        float _478 = _475 * _392;
        float _479 = _476 * _394;
        float _480 = _477 + 0.24617899954319f;
        float _481 = _478 + 0.24617899954319f;
        float _482 = _479 + 0.24617899954319f;
        float _483 = _468 / _480;
        float _484 = _469 / _481;
        float _485 = _470 / _482;
        _487 = _483;
        _488 = _484;
        _489 = _485;
      }
      float _490 = _487 * 1.6047500371932983f;
      float _491 = mad(-0.5310800075531006f, _488, _490);
      float _492 = mad(-0.07366999983787537f, _489, _491);
      float _493 = _487 * -0.10208000242710114f;
      float _494 = mad(1.1081299781799316f, _488, _493);
      float _495 = mad(-0.006049999967217445f, _489, _494);
      float _496 = _487 * -0.0032599999103695154f;
      float _497 = mad(-0.07275000214576721f, _488, _496);
      float _498 = mad(1.0760200023651123f, _489, _497);
      if (_323) {
        // float _500 = max(_492, 0.0f);
        // float _501 = max(_495, 0.0f);
        // float _502 = max(_498, 0.0f);
        // bool _503 = !(_500 >= 0.0030399328097701073f);
        // if (!_503) {
        //   float _505 = abs(_500);
        //   float _506 = log2(_505);
        //   float _507 = _506 * 0.4166666567325592f;
        //   float _508 = exp2(_507);
        //   float _509 = _508 * 1.0549999475479126f;
        //   float _510 = _509 + -0.054999999701976776f;
        //   _514 = _510;
        // } else {
        //   float _512 = _500 * 12.923210144042969f;
        //   _514 = _512;
        // }
        // bool _515 = !(_501 >= 0.0030399328097701073f);
        // if (!_515) {
        //   float _517 = abs(_501);
        //   float _518 = log2(_517);
        //   float _519 = _518 * 0.4166666567325592f;
        //   float _520 = exp2(_519);
        //   float _521 = _520 * 1.0549999475479126f;
        //   float _522 = _521 + -0.054999999701976776f;
        //   _526 = _522;
        // } else {
        //   float _524 = _501 * 12.923210144042969f;
        //   _526 = _524;
        // }
        // bool _527 = !(_502 >= 0.0030399328097701073f);
        // if (!_527) {
        //   float _529 = abs(_502);
        //   float _530 = log2(_529);
        //   float _531 = _530 * 0.4166666567325592f;
        //   float _532 = exp2(_531);
        //   float _533 = _532 * 1.0549999475479126f;
        //   float _534 = _533 + -0.054999999701976776f;
        //   _607 = _514;
        //   _608 = _526;
        //   _609 = _534;
        // } else {
        //   float _536 = _502 * 12.923210144042969f;
        //   _607 = _514;
        //   _608 = _526;
        //   _609 = _536;
        // }
        _607 = renodx::color::srgb::EncodeSafe(_492);
        _608 = renodx::color::srgb::EncodeSafe(_495);
        _609 = renodx::color::srgb::EncodeSafe(_498);

      } else {
        float _538 = saturate(_492);
        float _539 = saturate(_495);
        float _540 = saturate(_498);
        bool _541 = ((uint)(cb1_018w) == -2);
        if (!_541) {
          bool _543 = !(_538 >= 0.0030399328097701073f);
          if (!_543) {
            float _545 = abs(_538);
            float _546 = log2(_545);
            float _547 = _546 * 0.4166666567325592f;
            float _548 = exp2(_547);
            float _549 = _548 * 1.0549999475479126f;
            float _550 = _549 + -0.054999999701976776f;
            _554 = _550;
          } else {
            float _552 = _538 * 12.923210144042969f;
            _554 = _552;
          }
          bool _555 = !(_539 >= 0.0030399328097701073f);
          if (!_555) {
            float _557 = abs(_539);
            float _558 = log2(_557);
            float _559 = _558 * 0.4166666567325592f;
            float _560 = exp2(_559);
            float _561 = _560 * 1.0549999475479126f;
            float _562 = _561 + -0.054999999701976776f;
            _566 = _562;
          } else {
            float _564 = _539 * 12.923210144042969f;
            _566 = _564;
          }
          bool _567 = !(_540 >= 0.0030399328097701073f);
          if (!_567) {
            float _569 = abs(_540);
            float _570 = log2(_569);
            float _571 = _570 * 0.4166666567325592f;
            float _572 = exp2(_571);
            float _573 = _572 * 1.0549999475479126f;
            float _574 = _573 + -0.054999999701976776f;
            _578 = _554;
            _579 = _566;
            _580 = _574;
          } else {
            float _576 = _540 * 12.923210144042969f;
            _578 = _554;
            _579 = _566;
            _580 = _576;
          }
        } else {
          _578 = _538;
          _579 = _539;
          _580 = _540;
        }
        float _585 = abs(_578);
        float _586 = abs(_579);
        float _587 = abs(_580);
        float _588 = log2(_585);
        float _589 = log2(_586);
        float _590 = log2(_587);
        float _591 = _588 * cb2_000z;
        float _592 = _589 * cb2_000z;
        float _593 = _590 * cb2_000z;
        float _594 = exp2(_591);
        float _595 = exp2(_592);
        float _596 = exp2(_593);
        float _597 = _594 * cb2_000y;
        float _598 = _595 * cb2_000y;
        float _599 = _596 * cb2_000y;
        float _600 = _597 + cb2_000x;
        float _601 = _598 + cb2_000x;
        float _602 = _599 + cb2_000x;
        float _603 = saturate(_600);
        float _604 = saturate(_601);
        float _605 = saturate(_602);
        _607 = _603;
        _608 = _604;
        _609 = _605;
      }
      float _610 = dot(float3(_607, _608, _609), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _607;
      SV_Target.y = _608;
      SV_Target.z = _609;
      SV_Target.w = _610;
      SV_Target_1.x = _610;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

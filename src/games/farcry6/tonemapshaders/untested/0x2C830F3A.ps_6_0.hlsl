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
  float _305;
  float _306;
  float _307;
  float _408;
  float _409;
  float _410;
  float _435;
  float _447;
  float _475;
  float _487;
  float _499;
  float _500;
  float _501;
  float _528;
  float _529;
  float _530;
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
  float _290 = cb2_016x - _278;
  float _291 = cb2_016y - _281;
  float _292 = cb2_016z - _284;
  float _293 = _290 * cb2_016w;
  float _294 = _291 * cb2_016w;
  float _295 = _292 * cb2_016w;
  float _296 = _293 + _278;
  float _297 = _294 + _281;
  float _298 = _295 + _284;
  if (_244 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _301 = cb2_024x * _296;
    float _302 = cb2_024x * _297;
    float _303 = cb2_024x * _298;
    _305 = _301;
    _306 = _302;
    _307 = _303;
  } else {
    _305 = _296;
    _306 = _297;
    _307 = _298;
  }
  float _308 = _305 * 0.9708889722824097f;
  float _309 = mad(0.026962999254465103f, _306, _308);
  float _310 = mad(0.002148000057786703f, _307, _309);
  float _311 = _305 * 0.01088900025933981f;
  float _312 = mad(0.9869629740715027f, _306, _311);
  float _313 = mad(0.002148000057786703f, _307, _312);
  float _314 = mad(0.026962999254465103f, _306, _311);
  float _315 = mad(0.9621480107307434f, _307, _314);
  if (_244) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _320 = cb1_018y * 0.10000000149011612f;
        float _321 = log2(cb1_018z);
        float _322 = _321 + -13.287712097167969f;
        float _323 = _322 * 1.4929734468460083f;
        float _324 = _323 + 18.0f;
        float _325 = exp2(_324);
        float _326 = _325 * 0.18000000715255737f;
        float _327 = abs(_326);
        float _328 = log2(_327);
        float _329 = _328 * 1.5f;
        float _330 = exp2(_329);
        float _331 = _330 * _320;
        float _332 = _331 / cb1_018z;
        float _333 = _332 + -0.07636754959821701f;
        float _334 = _328 * 1.2750000953674316f;
        float _335 = exp2(_334);
        float _336 = _335 * 0.07636754959821701f;
        float _337 = cb1_018y * 0.011232397519052029f;
        float _338 = _337 * _330;
        float _339 = _338 / cb1_018z;
        float _340 = _336 - _339;
        float _341 = _335 + -0.11232396960258484f;
        float _342 = _341 * _320;
        float _343 = _342 / cb1_018z;
        float _344 = _343 * cb1_018z;
        float _345 = abs(_310);
        float _346 = abs(_313);
        float _347 = abs(_315);
        float _348 = log2(_345);
        float _349 = log2(_346);
        float _350 = log2(_347);
        float _351 = _348 * 1.5f;
        float _352 = _349 * 1.5f;
        float _353 = _350 * 1.5f;
        float _354 = exp2(_351);
        float _355 = exp2(_352);
        float _356 = exp2(_353);
        float _357 = _354 * _344;
        float _358 = _355 * _344;
        float _359 = _356 * _344;
        float _360 = _348 * 1.2750000953674316f;
        float _361 = _349 * 1.2750000953674316f;
        float _362 = _350 * 1.2750000953674316f;
        float _363 = exp2(_360);
        float _364 = exp2(_361);
        float _365 = exp2(_362);
        float _366 = _363 * _333;
        float _367 = _364 * _333;
        float _368 = _365 * _333;
        float _369 = _366 + _340;
        float _370 = _367 + _340;
        float _371 = _368 + _340;
        float _372 = _357 / _369;
        float _373 = _358 / _370;
        float _374 = _359 / _371;
        float _375 = _372 * 9.999999747378752e-05f;
        float _376 = _373 * 9.999999747378752e-05f;
        float _377 = _374 * 9.999999747378752e-05f;
        float _378 = 5000.0f / cb1_018y;
        float _379 = _375 * _378;
        float _380 = _376 * _378;
        float _381 = _377 * _378;
        _408 = _379;
        _409 = _380;
        _410 = _381;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_310, _313, _315));
      _408 = tonemapped.x, _409 = tonemapped.y, _410 = tonemapped.z;
    }
      } else {
        float _383 = _310 + 0.020616600289940834f;
        float _384 = _313 + 0.020616600289940834f;
        float _385 = _315 + 0.020616600289940834f;
        float _386 = _383 * _310;
        float _387 = _384 * _313;
        float _388 = _385 * _315;
        float _389 = _386 + -7.456949970219284e-05f;
        float _390 = _387 + -7.456949970219284e-05f;
        float _391 = _388 + -7.456949970219284e-05f;
        float _392 = _310 * 0.9837960004806519f;
        float _393 = _313 * 0.9837960004806519f;
        float _394 = _315 * 0.9837960004806519f;
        float _395 = _392 + 0.4336790144443512f;
        float _396 = _393 + 0.4336790144443512f;
        float _397 = _394 + 0.4336790144443512f;
        float _398 = _395 * _310;
        float _399 = _396 * _313;
        float _400 = _397 * _315;
        float _401 = _398 + 0.24617899954319f;
        float _402 = _399 + 0.24617899954319f;
        float _403 = _400 + 0.24617899954319f;
        float _404 = _389 / _401;
        float _405 = _390 / _402;
        float _406 = _391 / _403;
        _408 = _404;
        _409 = _405;
        _410 = _406;
      }
      float _411 = _408 * 1.6047500371932983f;
      float _412 = mad(-0.5310800075531006f, _409, _411);
      float _413 = mad(-0.07366999983787537f, _410, _412);
      float _414 = _408 * -0.10208000242710114f;
      float _415 = mad(1.1081299781799316f, _409, _414);
      float _416 = mad(-0.006049999967217445f, _410, _415);
      float _417 = _408 * -0.0032599999103695154f;
      float _418 = mad(-0.07275000214576721f, _409, _417);
      float _419 = mad(1.0760200023651123f, _410, _418);
      if (_244) {
        // float _421 = max(_413, 0.0f);
        // float _422 = max(_416, 0.0f);
        // float _423 = max(_419, 0.0f);
        // bool _424 = !(_421 >= 0.0030399328097701073f);
        // if (!_424) {
        //   float _426 = abs(_421);
        //   float _427 = log2(_426);
        //   float _428 = _427 * 0.4166666567325592f;
        //   float _429 = exp2(_428);
        //   float _430 = _429 * 1.0549999475479126f;
        //   float _431 = _430 + -0.054999999701976776f;
        //   _435 = _431;
        // } else {
        //   float _433 = _421 * 12.923210144042969f;
        //   _435 = _433;
        // }
        // bool _436 = !(_422 >= 0.0030399328097701073f);
        // if (!_436) {
        //   float _438 = abs(_422);
        //   float _439 = log2(_438);
        //   float _440 = _439 * 0.4166666567325592f;
        //   float _441 = exp2(_440);
        //   float _442 = _441 * 1.0549999475479126f;
        //   float _443 = _442 + -0.054999999701976776f;
        //   _447 = _443;
        // } else {
        //   float _445 = _422 * 12.923210144042969f;
        //   _447 = _445;
        // }
        // bool _448 = !(_423 >= 0.0030399328097701073f);
        // if (!_448) {
        //   float _450 = abs(_423);
        //   float _451 = log2(_450);
        //   float _452 = _451 * 0.4166666567325592f;
        //   float _453 = exp2(_452);
        //   float _454 = _453 * 1.0549999475479126f;
        //   float _455 = _454 + -0.054999999701976776f;
        //   _528 = _435;
        //   _529 = _447;
        //   _530 = _455;
        // } else {
        //   float _457 = _423 * 12.923210144042969f;
        //   _528 = _435;
        //   _529 = _447;
        //   _530 = _457;
        // }
        _528 = renodx::color::srgb::EncodeSafe(_413);
        _529 = renodx::color::srgb::EncodeSafe(_416);
        _530 = renodx::color::srgb::EncodeSafe(_419);

      } else {
        float _459 = saturate(_413);
        float _460 = saturate(_416);
        float _461 = saturate(_419);
        bool _462 = ((uint)(cb1_018w) == -2);
        if (!_462) {
          bool _464 = !(_459 >= 0.0030399328097701073f);
          if (!_464) {
            float _466 = abs(_459);
            float _467 = log2(_466);
            float _468 = _467 * 0.4166666567325592f;
            float _469 = exp2(_468);
            float _470 = _469 * 1.0549999475479126f;
            float _471 = _470 + -0.054999999701976776f;
            _475 = _471;
          } else {
            float _473 = _459 * 12.923210144042969f;
            _475 = _473;
          }
          bool _476 = !(_460 >= 0.0030399328097701073f);
          if (!_476) {
            float _478 = abs(_460);
            float _479 = log2(_478);
            float _480 = _479 * 0.4166666567325592f;
            float _481 = exp2(_480);
            float _482 = _481 * 1.0549999475479126f;
            float _483 = _482 + -0.054999999701976776f;
            _487 = _483;
          } else {
            float _485 = _460 * 12.923210144042969f;
            _487 = _485;
          }
          bool _488 = !(_461 >= 0.0030399328097701073f);
          if (!_488) {
            float _490 = abs(_461);
            float _491 = log2(_490);
            float _492 = _491 * 0.4166666567325592f;
            float _493 = exp2(_492);
            float _494 = _493 * 1.0549999475479126f;
            float _495 = _494 + -0.054999999701976776f;
            _499 = _475;
            _500 = _487;
            _501 = _495;
          } else {
            float _497 = _461 * 12.923210144042969f;
            _499 = _475;
            _500 = _487;
            _501 = _497;
          }
        } else {
          _499 = _459;
          _500 = _460;
          _501 = _461;
        }
        float _506 = abs(_499);
        float _507 = abs(_500);
        float _508 = abs(_501);
        float _509 = log2(_506);
        float _510 = log2(_507);
        float _511 = log2(_508);
        float _512 = _509 * cb2_000z;
        float _513 = _510 * cb2_000z;
        float _514 = _511 * cb2_000z;
        float _515 = exp2(_512);
        float _516 = exp2(_513);
        float _517 = exp2(_514);
        float _518 = _515 * cb2_000y;
        float _519 = _516 * cb2_000y;
        float _520 = _517 * cb2_000y;
        float _521 = _518 + cb2_000x;
        float _522 = _519 + cb2_000x;
        float _523 = _520 + cb2_000x;
        float _524 = saturate(_521);
        float _525 = saturate(_522);
        float _526 = saturate(_523);
        _528 = _524;
        _529 = _525;
        _530 = _526;
      }
      float _531 = dot(float3(_528, _529, _530), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _528;
      SV_Target.y = _529;
      SV_Target.z = _530;
      SV_Target.w = _531;
      SV_Target_1.x = _531;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

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

Texture3D<float2> t7 : register(t7);

Texture2D<float4> t8 : register(t8);

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
  float _23 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _25 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _29 = max(_25.x, 0.0f);
  float _30 = max(_25.y, 0.0f);
  float _31 = max(_25.z, 0.0f);
  float _32 = min(_29, 65000.0f);
  float _33 = min(_30, 65000.0f);
  float _34 = min(_31, 65000.0f);
  float4 _35 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _40 = max(_35.x, 0.0f);
  float _41 = max(_35.y, 0.0f);
  float _42 = max(_35.z, 0.0f);
  float _43 = max(_35.w, 0.0f);
  float _44 = min(_40, 5000.0f);
  float _45 = min(_41, 5000.0f);
  float _46 = min(_42, 5000.0f);
  float _47 = min(_43, 5000.0f);
  float _50 = _23.x * cb0_028z;
  float _51 = _50 + cb0_028x;
  float _52 = cb2_027w / _51;
  float _53 = 1.0f - _52;
  float _54 = abs(_53);
  float _56 = cb2_027y * _54;
  float _58 = _56 - cb2_027z;
  float _59 = saturate(_58);
  float _60 = max(_59, _47);
  float _61 = saturate(_60);
  float4 _62 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _66 = _44 - _32;
  float _67 = _45 - _33;
  float _68 = _46 - _34;
  float _69 = _61 * _66;
  float _70 = _61 * _67;
  float _71 = _61 * _68;
  float _72 = _69 + _32;
  float _73 = _70 + _33;
  float _74 = _71 + _34;
  float _75 = dot(float3(_72, _73, _74), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _79 = t0[0].SExposureData_020;
  float _81 = t0[0].SExposureData_004;
  float _83 = cb2_018x * 0.5f;
  float _84 = _83 * cb2_018y;
  float _85 = _81.x - _84;
  float _86 = cb2_018y * cb2_018x;
  float _87 = 1.0f / _86;
  float _88 = _85 * _87;
  float _89 = _75 / _79.x;
  float _90 = _89 * 5464.01611328125f;
  float _91 = _90 + 9.99999993922529e-09f;
  float _92 = log2(_91);
  float _93 = _92 - _85;
  float _94 = _93 * _87;
  float _95 = saturate(_94);
  float2 _96 = t7.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _95), 0.0f);
  float _99 = max(_96.y, 1.0000000116860974e-07f);
  float _100 = _96.x / _99;
  float _101 = _100 + _88;
  float _102 = _101 / _87;
  float _103 = _102 - _81.x;
  float _104 = -0.0f - _103;
  float _106 = _104 - cb2_027x;
  float _107 = max(0.0f, _106);
  float _110 = cb2_026z * _107;
  float _111 = _103 - cb2_027x;
  float _112 = max(0.0f, _111);
  float _114 = cb2_026w * _112;
  bool _115 = (_103 < 0.0f);
  float _116 = select(_115, _110, _114);
  float _117 = exp2(_116);
  float _118 = _117 * _72;
  float _119 = _117 * _73;
  float _120 = _117 * _74;
  float _125 = cb2_024y * _62.x;
  float _126 = cb2_024z * _62.y;
  float _127 = cb2_024w * _62.z;
  float _128 = _125 + _118;
  float _129 = _126 + _119;
  float _130 = _127 + _120;
  float _135 = _128 * cb2_025x;
  float _136 = _129 * cb2_025y;
  float _137 = _130 * cb2_025z;
  float _138 = dot(float3(_135, _136, _137), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _139 = t0[0].SExposureData_012;
  float _141 = _138 * 5464.01611328125f;
  float _142 = _141 * _139.x;
  float _143 = _142 + 9.99999993922529e-09f;
  float _144 = log2(_143);
  float _145 = _144 + 16.929765701293945f;
  float _146 = _145 * 0.05734497308731079f;
  float _147 = saturate(_146);
  float _148 = _147 * _147;
  float _149 = _147 * 2.0f;
  float _150 = 3.0f - _149;
  float _151 = _148 * _150;
  float _152 = _136 * 0.8450999855995178f;
  float _153 = _137 * 0.14589999616146088f;
  float _154 = _152 + _153;
  float _155 = _154 * 2.4890189170837402f;
  float _156 = _154 * 0.3754962384700775f;
  float _157 = _154 * 2.811495304107666f;
  float _158 = _154 * 5.519708156585693f;
  float _159 = _138 - _155;
  float _160 = _151 * _159;
  float _161 = _160 + _155;
  float _162 = _151 * 0.5f;
  float _163 = _162 + 0.5f;
  float _164 = _163 * _159;
  float _165 = _164 + _155;
  float _166 = _135 - _156;
  float _167 = _136 - _157;
  float _168 = _137 - _158;
  float _169 = _163 * _166;
  float _170 = _163 * _167;
  float _171 = _163 * _168;
  float _172 = _169 + _156;
  float _173 = _170 + _157;
  float _174 = _171 + _158;
  float _175 = 1.0f / _165;
  float _176 = _161 * _175;
  float _177 = _176 * _172;
  float _178 = _176 * _173;
  float _179 = _176 * _174;
  float _183 = cb2_020x * TEXCOORD0_centroid.x;
  float _184 = cb2_020y * TEXCOORD0_centroid.y;
  float _187 = _183 + cb2_020z;
  float _188 = _184 + cb2_020w;
  float _191 = dot(float2(_187, _188), float2(_187, _188));
  float _192 = 1.0f - _191;
  float _193 = saturate(_192);
  float _194 = log2(_193);
  float _195 = _194 * cb2_021w;
  float _196 = exp2(_195);
  float _200 = _177 - cb2_021x;
  float _201 = _178 - cb2_021y;
  float _202 = _179 - cb2_021z;
  float _203 = _200 * _196;
  float _204 = _201 * _196;
  float _205 = _202 * _196;
  float _206 = _203 + cb2_021x;
  float _207 = _204 + cb2_021y;
  float _208 = _205 + cb2_021z;
  float _209 = t0[0].SExposureData_000;
  float _211 = max(_79.x, 0.0010000000474974513f);
  float _212 = 1.0f / _211;
  float _213 = _212 * _209.x;
  bool _216 = ((uint)(cb2_069y) == 0);
  float _222;
  float _223;
  float _224;
  float _278;
  float _279;
  float _280;
  float _311;
  float _312;
  float _313;
  float _414;
  float _415;
  float _416;
  float _441;
  float _453;
  float _481;
  float _493;
  float _505;
  float _506;
  float _507;
  float _534;
  float _535;
  float _536;
  if (!_216) {
    float _218 = _213 * _206;
    float _219 = _213 * _207;
    float _220 = _213 * _208;
    _222 = _218;
    _223 = _219;
    _224 = _220;
  } else {
    _222 = _206;
    _223 = _207;
    _224 = _208;
  }
  float _225 = _222 * 0.6130970120429993f;
  float _226 = mad(0.33952298760414124f, _223, _225);
  float _227 = mad(0.04737899824976921f, _224, _226);
  float _228 = _222 * 0.07019399851560593f;
  float _229 = mad(0.9163540005683899f, _223, _228);
  float _230 = mad(0.013451999984681606f, _224, _229);
  float _231 = _222 * 0.02061600051820278f;
  float _232 = mad(0.10956999659538269f, _223, _231);
  float _233 = mad(0.8698149919509888f, _224, _232);
  float _234 = log2(_227);
  float _235 = log2(_230);
  float _236 = log2(_233);
  float _237 = _234 * 0.04211956635117531f;
  float _238 = _235 * 0.04211956635117531f;
  float _239 = _236 * 0.04211956635117531f;
  float _240 = _237 + 0.6252607107162476f;
  float _241 = _238 + 0.6252607107162476f;
  float _242 = _239 + 0.6252607107162476f;
  float4 _243 = t6.SampleLevel(s2_space2, float3(_240, _241, _242), 0.0f);
  bool _249 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_249 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _253 = cb2_017x * _243.x;
    float _254 = cb2_017x * _243.y;
    float _255 = cb2_017x * _243.z;
    float _257 = _253 + cb2_017y;
    float _258 = _254 + cb2_017y;
    float _259 = _255 + cb2_017y;
    float _260 = exp2(_257);
    float _261 = exp2(_258);
    float _262 = exp2(_259);
    float _263 = _260 + 1.0f;
    float _264 = _261 + 1.0f;
    float _265 = _262 + 1.0f;
    float _266 = 1.0f / _263;
    float _267 = 1.0f / _264;
    float _268 = 1.0f / _265;
    float _270 = cb2_017z * _266;
    float _271 = cb2_017z * _267;
    float _272 = cb2_017z * _268;
    float _274 = _270 + cb2_017w;
    float _275 = _271 + cb2_017w;
    float _276 = _272 + cb2_017w;
    _278 = _274;
    _279 = _275;
    _280 = _276;
  } else {
    _278 = _243.x;
    _279 = _243.y;
    _280 = _243.z;
  }
  float _281 = _278 * 23.0f;
  float _282 = _281 + -14.473931312561035f;
  float _283 = exp2(_282);
  float _284 = _279 * 23.0f;
  float _285 = _284 + -14.473931312561035f;
  float _286 = exp2(_285);
  float _287 = _280 * 23.0f;
  float _288 = _287 + -14.473931312561035f;
  float _289 = exp2(_288);
  float _296 = cb2_016x - _283;
  float _297 = cb2_016y - _286;
  float _298 = cb2_016z - _289;
  float _299 = _296 * cb2_016w;
  float _300 = _297 * cb2_016w;
  float _301 = _298 * cb2_016w;
  float _302 = _299 + _283;
  float _303 = _300 + _286;
  float _304 = _301 + _289;
  if (_249 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _307 = cb2_024x * _302;
    float _308 = cb2_024x * _303;
    float _309 = cb2_024x * _304;
    _311 = _307;
    _312 = _308;
    _313 = _309;
  } else {
    _311 = _302;
    _312 = _303;
    _313 = _304;
  }
  float _314 = _311 * 0.9708889722824097f;
  float _315 = mad(0.026962999254465103f, _312, _314);
  float _316 = mad(0.002148000057786703f, _313, _315);
  float _317 = _311 * 0.01088900025933981f;
  float _318 = mad(0.9869629740715027f, _312, _317);
  float _319 = mad(0.002148000057786703f, _313, _318);
  float _320 = mad(0.026962999254465103f, _312, _317);
  float _321 = mad(0.9621480107307434f, _313, _320);
  if (_249) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _326 = cb1_018y * 0.10000000149011612f;
        float _327 = log2(cb1_018z);
        float _328 = _327 + -13.287712097167969f;
        float _329 = _328 * 1.4929734468460083f;
        float _330 = _329 + 18.0f;
        float _331 = exp2(_330);
        float _332 = _331 * 0.18000000715255737f;
        float _333 = abs(_332);
        float _334 = log2(_333);
        float _335 = _334 * 1.5f;
        float _336 = exp2(_335);
        float _337 = _336 * _326;
        float _338 = _337 / cb1_018z;
        float _339 = _338 + -0.07636754959821701f;
        float _340 = _334 * 1.2750000953674316f;
        float _341 = exp2(_340);
        float _342 = _341 * 0.07636754959821701f;
        float _343 = cb1_018y * 0.011232397519052029f;
        float _344 = _343 * _336;
        float _345 = _344 / cb1_018z;
        float _346 = _342 - _345;
        float _347 = _341 + -0.11232396960258484f;
        float _348 = _347 * _326;
        float _349 = _348 / cb1_018z;
        float _350 = _349 * cb1_018z;
        float _351 = abs(_316);
        float _352 = abs(_319);
        float _353 = abs(_321);
        float _354 = log2(_351);
        float _355 = log2(_352);
        float _356 = log2(_353);
        float _357 = _354 * 1.5f;
        float _358 = _355 * 1.5f;
        float _359 = _356 * 1.5f;
        float _360 = exp2(_357);
        float _361 = exp2(_358);
        float _362 = exp2(_359);
        float _363 = _360 * _350;
        float _364 = _361 * _350;
        float _365 = _362 * _350;
        float _366 = _354 * 1.2750000953674316f;
        float _367 = _355 * 1.2750000953674316f;
        float _368 = _356 * 1.2750000953674316f;
        float _369 = exp2(_366);
        float _370 = exp2(_367);
        float _371 = exp2(_368);
        float _372 = _369 * _339;
        float _373 = _370 * _339;
        float _374 = _371 * _339;
        float _375 = _372 + _346;
        float _376 = _373 + _346;
        float _377 = _374 + _346;
        float _378 = _363 / _375;
        float _379 = _364 / _376;
        float _380 = _365 / _377;
        float _381 = _378 * 9.999999747378752e-05f;
        float _382 = _379 * 9.999999747378752e-05f;
        float _383 = _380 * 9.999999747378752e-05f;
        float _384 = 5000.0f / cb1_018y;
        float _385 = _381 * _384;
        float _386 = _382 * _384;
        float _387 = _383 * _384;
        _414 = _385;
        _415 = _386;
        _416 = _387;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_316, _319, _321));
      _414 = tonemapped.x, _415 = tonemapped.y, _416 = tonemapped.z;
    }
      } else {
        float _389 = _316 + 0.020616600289940834f;
        float _390 = _319 + 0.020616600289940834f;
        float _391 = _321 + 0.020616600289940834f;
        float _392 = _389 * _316;
        float _393 = _390 * _319;
        float _394 = _391 * _321;
        float _395 = _392 + -7.456949970219284e-05f;
        float _396 = _393 + -7.456949970219284e-05f;
        float _397 = _394 + -7.456949970219284e-05f;
        float _398 = _316 * 0.9837960004806519f;
        float _399 = _319 * 0.9837960004806519f;
        float _400 = _321 * 0.9837960004806519f;
        float _401 = _398 + 0.4336790144443512f;
        float _402 = _399 + 0.4336790144443512f;
        float _403 = _400 + 0.4336790144443512f;
        float _404 = _401 * _316;
        float _405 = _402 * _319;
        float _406 = _403 * _321;
        float _407 = _404 + 0.24617899954319f;
        float _408 = _405 + 0.24617899954319f;
        float _409 = _406 + 0.24617899954319f;
        float _410 = _395 / _407;
        float _411 = _396 / _408;
        float _412 = _397 / _409;
        _414 = _410;
        _415 = _411;
        _416 = _412;
      }
      float _417 = _414 * 1.6047500371932983f;
      float _418 = mad(-0.5310800075531006f, _415, _417);
      float _419 = mad(-0.07366999983787537f, _416, _418);
      float _420 = _414 * -0.10208000242710114f;
      float _421 = mad(1.1081299781799316f, _415, _420);
      float _422 = mad(-0.006049999967217445f, _416, _421);
      float _423 = _414 * -0.0032599999103695154f;
      float _424 = mad(-0.07275000214576721f, _415, _423);
      float _425 = mad(1.0760200023651123f, _416, _424);
      if (_249) {
        // float _427 = max(_419, 0.0f);
        // float _428 = max(_422, 0.0f);
        // float _429 = max(_425, 0.0f);
        // bool _430 = !(_427 >= 0.0030399328097701073f);
        // if (!_430) {
        //   float _432 = abs(_427);
        //   float _433 = log2(_432);
        //   float _434 = _433 * 0.4166666567325592f;
        //   float _435 = exp2(_434);
        //   float _436 = _435 * 1.0549999475479126f;
        //   float _437 = _436 + -0.054999999701976776f;
        //   _441 = _437;
        // } else {
        //   float _439 = _427 * 12.923210144042969f;
        //   _441 = _439;
        // }
        // bool _442 = !(_428 >= 0.0030399328097701073f);
        // if (!_442) {
        //   float _444 = abs(_428);
        //   float _445 = log2(_444);
        //   float _446 = _445 * 0.4166666567325592f;
        //   float _447 = exp2(_446);
        //   float _448 = _447 * 1.0549999475479126f;
        //   float _449 = _448 + -0.054999999701976776f;
        //   _453 = _449;
        // } else {
        //   float _451 = _428 * 12.923210144042969f;
        //   _453 = _451;
        // }
        // bool _454 = !(_429 >= 0.0030399328097701073f);
        // if (!_454) {
        //   float _456 = abs(_429);
        //   float _457 = log2(_456);
        //   float _458 = _457 * 0.4166666567325592f;
        //   float _459 = exp2(_458);
        //   float _460 = _459 * 1.0549999475479126f;
        //   float _461 = _460 + -0.054999999701976776f;
        //   _534 = _441;
        //   _535 = _453;
        //   _536 = _461;
        // } else {
        //   float _463 = _429 * 12.923210144042969f;
        //   _534 = _441;
        //   _535 = _453;
        //   _536 = _463;
        // }
        _534 = renodx::color::srgb::EncodeSafe(_419);
        _535 = renodx::color::srgb::EncodeSafe(_422);
        _536 = renodx::color::srgb::EncodeSafe(_425);

      } else {
        float _465 = saturate(_419);
        float _466 = saturate(_422);
        float _467 = saturate(_425);
        bool _468 = ((uint)(cb1_018w) == -2);
        if (!_468) {
          bool _470 = !(_465 >= 0.0030399328097701073f);
          if (!_470) {
            float _472 = abs(_465);
            float _473 = log2(_472);
            float _474 = _473 * 0.4166666567325592f;
            float _475 = exp2(_474);
            float _476 = _475 * 1.0549999475479126f;
            float _477 = _476 + -0.054999999701976776f;
            _481 = _477;
          } else {
            float _479 = _465 * 12.923210144042969f;
            _481 = _479;
          }
          bool _482 = !(_466 >= 0.0030399328097701073f);
          if (!_482) {
            float _484 = abs(_466);
            float _485 = log2(_484);
            float _486 = _485 * 0.4166666567325592f;
            float _487 = exp2(_486);
            float _488 = _487 * 1.0549999475479126f;
            float _489 = _488 + -0.054999999701976776f;
            _493 = _489;
          } else {
            float _491 = _466 * 12.923210144042969f;
            _493 = _491;
          }
          bool _494 = !(_467 >= 0.0030399328097701073f);
          if (!_494) {
            float _496 = abs(_467);
            float _497 = log2(_496);
            float _498 = _497 * 0.4166666567325592f;
            float _499 = exp2(_498);
            float _500 = _499 * 1.0549999475479126f;
            float _501 = _500 + -0.054999999701976776f;
            _505 = _481;
            _506 = _493;
            _507 = _501;
          } else {
            float _503 = _467 * 12.923210144042969f;
            _505 = _481;
            _506 = _493;
            _507 = _503;
          }
        } else {
          _505 = _465;
          _506 = _466;
          _507 = _467;
        }
        float _512 = abs(_505);
        float _513 = abs(_506);
        float _514 = abs(_507);
        float _515 = log2(_512);
        float _516 = log2(_513);
        float _517 = log2(_514);
        float _518 = _515 * cb2_000z;
        float _519 = _516 * cb2_000z;
        float _520 = _517 * cb2_000z;
        float _521 = exp2(_518);
        float _522 = exp2(_519);
        float _523 = exp2(_520);
        float _524 = _521 * cb2_000y;
        float _525 = _522 * cb2_000y;
        float _526 = _523 * cb2_000y;
        float _527 = _524 + cb2_000x;
        float _528 = _525 + cb2_000x;
        float _529 = _526 + cb2_000x;
        float _530 = saturate(_527);
        float _531 = saturate(_528);
        float _532 = saturate(_529);
        _534 = _530;
        _535 = _531;
        _536 = _532;
      }
      float _540 = cb2_023x * TEXCOORD0_centroid.x;
      float _541 = cb2_023y * TEXCOORD0_centroid.y;
      float _544 = _540 + cb2_023z;
      float _545 = _541 + cb2_023w;
      float4 _548 = t8.SampleLevel(s0_space2, float2(_544, _545), 0.0f);
      float _550 = _548.x + -0.5f;
      float _551 = _550 * cb2_022x;
      float _552 = _551 + 0.5f;
      float _553 = _552 * 2.0f;
      float _554 = _553 * _534;
      float _555 = _553 * _535;
      float _556 = _553 * _536;
      float _560 = float((uint)(cb2_019z));
      float _561 = float((uint)(cb2_019w));
      float _562 = _560 + SV_Position.x;
      float _563 = _561 + SV_Position.y;
      uint _564 = uint(_562);
      uint _565 = uint(_563);
      uint _568 = cb2_019x + -1u;
      uint _569 = cb2_019y + -1u;
      int _570 = _564 & _568;
      int _571 = _565 & _569;
      float4 _572 = t3.Load(int3(_570, _571, 0));
      float _576 = _572.x * 2.0f;
      float _577 = _572.y * 2.0f;
      float _578 = _572.z * 2.0f;
      float _579 = _576 + -1.0f;
      float _580 = _577 + -1.0f;
      float _581 = _578 + -1.0f;
      float _582 = _579 * cb2_025w;
      float _583 = _580 * cb2_025w;
      float _584 = _581 * cb2_025w;
      float _585 = _582 + _554;
      float _586 = _583 + _555;
      float _587 = _584 + _556;
      float _588 = dot(float3(_585, _586, _587), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _585;
      SV_Target.y = _586;
      SV_Target.z = _587;
      SV_Target.w = _588;
      SV_Target_1.x = _588;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

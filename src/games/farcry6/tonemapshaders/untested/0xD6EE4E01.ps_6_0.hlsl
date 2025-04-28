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
  float4 _21 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _25 = _21.x * 6.283199787139893f;
  float _26 = cos(_25);
  float _27 = sin(_25);
  float _28 = _26 * _21.z;
  float _29 = _27 * _21.z;
  float _30 = _28 + TEXCOORD0_centroid.x;
  float _31 = _29 + TEXCOORD0_centroid.y;
  float _32 = _30 * 10.0f;
  float _33 = 10.0f - _32;
  float _34 = min(_32, _33);
  float _35 = saturate(_34);
  float _36 = _35 * _28;
  float _37 = _31 * 10.0f;
  float _38 = 10.0f - _37;
  float _39 = min(_37, _38);
  float _40 = saturate(_39);
  float _41 = _40 * _29;
  float _42 = _36 + TEXCOORD0_centroid.x;
  float _43 = _41 + TEXCOORD0_centroid.y;
  float4 _44 = t6.SampleLevel(s2_space2, float2(_42, _43), 0.0f);
  float _46 = _44.w * _36;
  float _47 = _44.w * _41;
  float _48 = 1.0f - _21.y;
  float _49 = saturate(_48);
  float _50 = _46 * _49;
  float _51 = _47 * _49;
  float _52 = _50 + TEXCOORD0_centroid.x;
  float _53 = _51 + TEXCOORD0_centroid.y;
  float4 _54 = t6.SampleLevel(s2_space2, float2(_52, _53), 0.0f);
  bool _56 = (_54.y > 0.0f);
  float _57 = select(_56, TEXCOORD0_centroid.x, _52);
  float _58 = select(_56, TEXCOORD0_centroid.y, _53);
  float4 _59 = t1.SampleLevel(s4_space2, float2(_57, _58), 0.0f);
  float _63 = max(_59.x, 0.0f);
  float _64 = max(_59.y, 0.0f);
  float _65 = max(_59.z, 0.0f);
  float _66 = min(_63, 65000.0f);
  float _67 = min(_64, 65000.0f);
  float _68 = min(_65, 65000.0f);
  float4 _69 = t3.SampleLevel(s2_space2, float2(_57, _58), 0.0f);
  float _74 = max(_69.x, 0.0f);
  float _75 = max(_69.y, 0.0f);
  float _76 = max(_69.z, 0.0f);
  float _77 = max(_69.w, 0.0f);
  float _78 = min(_74, 5000.0f);
  float _79 = min(_75, 5000.0f);
  float _80 = min(_76, 5000.0f);
  float _81 = min(_77, 5000.0f);
  float _84 = _19.x * cb0_028z;
  float _85 = _84 + cb0_028x;
  float _86 = cb2_027w / _85;
  float _87 = 1.0f - _86;
  float _88 = abs(_87);
  float _90 = cb2_027y * _88;
  float _92 = _90 - cb2_027z;
  float _93 = saturate(_92);
  float _94 = max(_93, _81);
  float _95 = saturate(_94);
  float4 _96 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _100 = _78 - _66;
  float _101 = _79 - _67;
  float _102 = _80 - _68;
  float _103 = _95 * _100;
  float _104 = _95 * _101;
  float _105 = _95 * _102;
  float _106 = _103 + _66;
  float _107 = _104 + _67;
  float _108 = _105 + _68;
  float _109 = dot(float3(_106, _107, _108), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _113 = t0[0].SExposureData_020;
  float _115 = t0[0].SExposureData_004;
  float _117 = cb2_018x * 0.5f;
  float _118 = _117 * cb2_018y;
  float _119 = _115.x - _118;
  float _120 = cb2_018y * cb2_018x;
  float _121 = 1.0f / _120;
  float _122 = _119 * _121;
  float _123 = _109 / _113.x;
  float _124 = _123 * 5464.01611328125f;
  float _125 = _124 + 9.99999993922529e-09f;
  float _126 = log2(_125);
  float _127 = _126 - _119;
  float _128 = _127 * _121;
  float _129 = saturate(_128);
  float2 _130 = t7.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _129), 0.0f);
  float _133 = max(_130.y, 1.0000000116860974e-07f);
  float _134 = _130.x / _133;
  float _135 = _134 + _122;
  float _136 = _135 / _121;
  float _137 = _136 - _115.x;
  float _138 = -0.0f - _137;
  float _140 = _138 - cb2_027x;
  float _141 = max(0.0f, _140);
  float _144 = cb2_026z * _141;
  float _145 = _137 - cb2_027x;
  float _146 = max(0.0f, _145);
  float _148 = cb2_026w * _146;
  bool _149 = (_137 < 0.0f);
  float _150 = select(_149, _144, _148);
  float _151 = exp2(_150);
  float _152 = _151 * _106;
  float _153 = _151 * _107;
  float _154 = _151 * _108;
  float _159 = cb2_024y * _96.x;
  float _160 = cb2_024z * _96.y;
  float _161 = cb2_024w * _96.z;
  float _162 = _159 + _152;
  float _163 = _160 + _153;
  float _164 = _161 + _154;
  float _169 = _162 * cb2_025x;
  float _170 = _163 * cb2_025y;
  float _171 = _164 * cb2_025z;
  float _172 = dot(float3(_169, _170, _171), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _173 = t0[0].SExposureData_012;
  float _175 = _172 * 5464.01611328125f;
  float _176 = _175 * _173.x;
  float _177 = _176 + 9.99999993922529e-09f;
  float _178 = log2(_177);
  float _179 = _178 + 16.929765701293945f;
  float _180 = _179 * 0.05734497308731079f;
  float _181 = saturate(_180);
  float _182 = _181 * _181;
  float _183 = _181 * 2.0f;
  float _184 = 3.0f - _183;
  float _185 = _182 * _184;
  float _186 = _170 * 0.8450999855995178f;
  float _187 = _171 * 0.14589999616146088f;
  float _188 = _186 + _187;
  float _189 = _188 * 2.4890189170837402f;
  float _190 = _188 * 0.3754962384700775f;
  float _191 = _188 * 2.811495304107666f;
  float _192 = _188 * 5.519708156585693f;
  float _193 = _172 - _189;
  float _194 = _185 * _193;
  float _195 = _194 + _189;
  float _196 = _185 * 0.5f;
  float _197 = _196 + 0.5f;
  float _198 = _197 * _193;
  float _199 = _198 + _189;
  float _200 = _169 - _190;
  float _201 = _170 - _191;
  float _202 = _171 - _192;
  float _203 = _197 * _200;
  float _204 = _197 * _201;
  float _205 = _197 * _202;
  float _206 = _203 + _190;
  float _207 = _204 + _191;
  float _208 = _205 + _192;
  float _209 = 1.0f / _199;
  float _210 = _195 * _209;
  float _211 = _210 * _206;
  float _212 = _210 * _207;
  float _213 = _210 * _208;
  float _217 = cb2_020x * TEXCOORD0_centroid.x;
  float _218 = cb2_020y * TEXCOORD0_centroid.y;
  float _221 = _217 + cb2_020z;
  float _222 = _218 + cb2_020w;
  float _225 = dot(float2(_221, _222), float2(_221, _222));
  float _226 = 1.0f - _225;
  float _227 = saturate(_226);
  float _228 = log2(_227);
  float _229 = _228 * cb2_021w;
  float _230 = exp2(_229);
  float _234 = _211 - cb2_021x;
  float _235 = _212 - cb2_021y;
  float _236 = _213 - cb2_021z;
  float _237 = _234 * _230;
  float _238 = _235 * _230;
  float _239 = _236 * _230;
  float _240 = _237 + cb2_021x;
  float _241 = _238 + cb2_021y;
  float _242 = _239 + cb2_021z;
  float _243 = t0[0].SExposureData_000;
  float _245 = max(_113.x, 0.0010000000474974513f);
  float _246 = 1.0f / _245;
  float _247 = _246 * _243.x;
  bool _250 = ((uint)(cb2_069y) == 0);
  float _256;
  float _257;
  float _258;
  float _312;
  float _313;
  float _314;
  float _344;
  float _345;
  float _346;
  float _447;
  float _448;
  float _449;
  float _474;
  float _486;
  float _514;
  float _526;
  float _538;
  float _539;
  float _540;
  float _567;
  float _568;
  float _569;
  if (!_250) {
    float _252 = _247 * _240;
    float _253 = _247 * _241;
    float _254 = _247 * _242;
    _256 = _252;
    _257 = _253;
    _258 = _254;
  } else {
    _256 = _240;
    _257 = _241;
    _258 = _242;
  }
  float _259 = _256 * 0.6130970120429993f;
  float _260 = mad(0.33952298760414124f, _257, _259);
  float _261 = mad(0.04737899824976921f, _258, _260);
  float _262 = _256 * 0.07019399851560593f;
  float _263 = mad(0.9163540005683899f, _257, _262);
  float _264 = mad(0.013451999984681606f, _258, _263);
  float _265 = _256 * 0.02061600051820278f;
  float _266 = mad(0.10956999659538269f, _257, _265);
  float _267 = mad(0.8698149919509888f, _258, _266);
  float _268 = log2(_261);
  float _269 = log2(_264);
  float _270 = log2(_267);
  float _271 = _268 * 0.04211956635117531f;
  float _272 = _269 * 0.04211956635117531f;
  float _273 = _270 * 0.04211956635117531f;
  float _274 = _271 + 0.6252607107162476f;
  float _275 = _272 + 0.6252607107162476f;
  float _276 = _273 + 0.6252607107162476f;
  float4 _277 = t5.SampleLevel(s2_space2, float3(_274, _275, _276), 0.0f);
  bool _283 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_283 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _287 = cb2_017x * _277.x;
    float _288 = cb2_017x * _277.y;
    float _289 = cb2_017x * _277.z;
    float _291 = _287 + cb2_017y;
    float _292 = _288 + cb2_017y;
    float _293 = _289 + cb2_017y;
    float _294 = exp2(_291);
    float _295 = exp2(_292);
    float _296 = exp2(_293);
    float _297 = _294 + 1.0f;
    float _298 = _295 + 1.0f;
    float _299 = _296 + 1.0f;
    float _300 = 1.0f / _297;
    float _301 = 1.0f / _298;
    float _302 = 1.0f / _299;
    float _304 = cb2_017z * _300;
    float _305 = cb2_017z * _301;
    float _306 = cb2_017z * _302;
    float _308 = _304 + cb2_017w;
    float _309 = _305 + cb2_017w;
    float _310 = _306 + cb2_017w;
    _312 = _308;
    _313 = _309;
    _314 = _310;
  } else {
    _312 = _277.x;
    _313 = _277.y;
    _314 = _277.z;
  }
  float _315 = _312 * 23.0f;
  float _316 = _315 + -14.473931312561035f;
  float _317 = exp2(_316);
  float _318 = _313 * 23.0f;
  float _319 = _318 + -14.473931312561035f;
  float _320 = exp2(_319);
  float _321 = _314 * 23.0f;
  float _322 = _321 + -14.473931312561035f;
  float _323 = exp2(_322);
  float _329 = cb2_016x - _317;
  float _330 = cb2_016y - _320;
  float _331 = cb2_016z - _323;
  float _332 = _329 * cb2_016w;
  float _333 = _330 * cb2_016w;
  float _334 = _331 * cb2_016w;
  float _335 = _332 + _317;
  float _336 = _333 + _320;
  float _337 = _334 + _323;
  if (_283 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _340 = cb2_024x * _335;
    float _341 = cb2_024x * _336;
    float _342 = cb2_024x * _337;
    _344 = _340;
    _345 = _341;
    _346 = _342;
  } else {
    _344 = _335;
    _345 = _336;
    _346 = _337;
  }
  float _347 = _344 * 0.9708889722824097f;
  float _348 = mad(0.026962999254465103f, _345, _347);
  float _349 = mad(0.002148000057786703f, _346, _348);
  float _350 = _344 * 0.01088900025933981f;
  float _351 = mad(0.9869629740715027f, _345, _350);
  float _352 = mad(0.002148000057786703f, _346, _351);
  float _353 = mad(0.026962999254465103f, _345, _350);
  float _354 = mad(0.9621480107307434f, _346, _353);
  if (_283) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _359 = cb1_018y * 0.10000000149011612f;
        float _360 = log2(cb1_018z);
        float _361 = _360 + -13.287712097167969f;
        float _362 = _361 * 1.4929734468460083f;
        float _363 = _362 + 18.0f;
        float _364 = exp2(_363);
        float _365 = _364 * 0.18000000715255737f;
        float _366 = abs(_365);
        float _367 = log2(_366);
        float _368 = _367 * 1.5f;
        float _369 = exp2(_368);
        float _370 = _369 * _359;
        float _371 = _370 / cb1_018z;
        float _372 = _371 + -0.07636754959821701f;
        float _373 = _367 * 1.2750000953674316f;
        float _374 = exp2(_373);
        float _375 = _374 * 0.07636754959821701f;
        float _376 = cb1_018y * 0.011232397519052029f;
        float _377 = _376 * _369;
        float _378 = _377 / cb1_018z;
        float _379 = _375 - _378;
        float _380 = _374 + -0.11232396960258484f;
        float _381 = _380 * _359;
        float _382 = _381 / cb1_018z;
        float _383 = _382 * cb1_018z;
        float _384 = abs(_349);
        float _385 = abs(_352);
        float _386 = abs(_354);
        float _387 = log2(_384);
        float _388 = log2(_385);
        float _389 = log2(_386);
        float _390 = _387 * 1.5f;
        float _391 = _388 * 1.5f;
        float _392 = _389 * 1.5f;
        float _393 = exp2(_390);
        float _394 = exp2(_391);
        float _395 = exp2(_392);
        float _396 = _393 * _383;
        float _397 = _394 * _383;
        float _398 = _395 * _383;
        float _399 = _387 * 1.2750000953674316f;
        float _400 = _388 * 1.2750000953674316f;
        float _401 = _389 * 1.2750000953674316f;
        float _402 = exp2(_399);
        float _403 = exp2(_400);
        float _404 = exp2(_401);
        float _405 = _402 * _372;
        float _406 = _403 * _372;
        float _407 = _404 * _372;
        float _408 = _405 + _379;
        float _409 = _406 + _379;
        float _410 = _407 + _379;
        float _411 = _396 / _408;
        float _412 = _397 / _409;
        float _413 = _398 / _410;
        float _414 = _411 * 9.999999747378752e-05f;
        float _415 = _412 * 9.999999747378752e-05f;
        float _416 = _413 * 9.999999747378752e-05f;
        float _417 = 5000.0f / cb1_018y;
        float _418 = _414 * _417;
        float _419 = _415 * _417;
        float _420 = _416 * _417;
        _447 = _418;
        _448 = _419;
        _449 = _420;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_349, _352, _354));
      _447 = tonemapped.x, _448 = tonemapped.y, _449 = tonemapped.z;
    }
      } else {
        float _422 = _349 + 0.020616600289940834f;
        float _423 = _352 + 0.020616600289940834f;
        float _424 = _354 + 0.020616600289940834f;
        float _425 = _422 * _349;
        float _426 = _423 * _352;
        float _427 = _424 * _354;
        float _428 = _425 + -7.456949970219284e-05f;
        float _429 = _426 + -7.456949970219284e-05f;
        float _430 = _427 + -7.456949970219284e-05f;
        float _431 = _349 * 0.9837960004806519f;
        float _432 = _352 * 0.9837960004806519f;
        float _433 = _354 * 0.9837960004806519f;
        float _434 = _431 + 0.4336790144443512f;
        float _435 = _432 + 0.4336790144443512f;
        float _436 = _433 + 0.4336790144443512f;
        float _437 = _434 * _349;
        float _438 = _435 * _352;
        float _439 = _436 * _354;
        float _440 = _437 + 0.24617899954319f;
        float _441 = _438 + 0.24617899954319f;
        float _442 = _439 + 0.24617899954319f;
        float _443 = _428 / _440;
        float _444 = _429 / _441;
        float _445 = _430 / _442;
        _447 = _443;
        _448 = _444;
        _449 = _445;
      }
      float _450 = _447 * 1.6047500371932983f;
      float _451 = mad(-0.5310800075531006f, _448, _450);
      float _452 = mad(-0.07366999983787537f, _449, _451);
      float _453 = _447 * -0.10208000242710114f;
      float _454 = mad(1.1081299781799316f, _448, _453);
      float _455 = mad(-0.006049999967217445f, _449, _454);
      float _456 = _447 * -0.0032599999103695154f;
      float _457 = mad(-0.07275000214576721f, _448, _456);
      float _458 = mad(1.0760200023651123f, _449, _457);
      if (_283) {
        // float _460 = max(_452, 0.0f);
        // float _461 = max(_455, 0.0f);
        // float _462 = max(_458, 0.0f);
        // bool _463 = !(_460 >= 0.0030399328097701073f);
        // if (!_463) {
        //   float _465 = abs(_460);
        //   float _466 = log2(_465);
        //   float _467 = _466 * 0.4166666567325592f;
        //   float _468 = exp2(_467);
        //   float _469 = _468 * 1.0549999475479126f;
        //   float _470 = _469 + -0.054999999701976776f;
        //   _474 = _470;
        // } else {
        //   float _472 = _460 * 12.923210144042969f;
        //   _474 = _472;
        // }
        // bool _475 = !(_461 >= 0.0030399328097701073f);
        // if (!_475) {
        //   float _477 = abs(_461);
        //   float _478 = log2(_477);
        //   float _479 = _478 * 0.4166666567325592f;
        //   float _480 = exp2(_479);
        //   float _481 = _480 * 1.0549999475479126f;
        //   float _482 = _481 + -0.054999999701976776f;
        //   _486 = _482;
        // } else {
        //   float _484 = _461 * 12.923210144042969f;
        //   _486 = _484;
        // }
        // bool _487 = !(_462 >= 0.0030399328097701073f);
        // if (!_487) {
        //   float _489 = abs(_462);
        //   float _490 = log2(_489);
        //   float _491 = _490 * 0.4166666567325592f;
        //   float _492 = exp2(_491);
        //   float _493 = _492 * 1.0549999475479126f;
        //   float _494 = _493 + -0.054999999701976776f;
        //   _567 = _474;
        //   _568 = _486;
        //   _569 = _494;
        // } else {
        //   float _496 = _462 * 12.923210144042969f;
        //   _567 = _474;
        //   _568 = _486;
        //   _569 = _496;
        // }
        _567 = renodx::color::srgb::EncodeSafe(_452);
        _568 = renodx::color::srgb::EncodeSafe(_455);
        _569 = renodx::color::srgb::EncodeSafe(_458);

      } else {
        float _498 = saturate(_452);
        float _499 = saturate(_455);
        float _500 = saturate(_458);
        bool _501 = ((uint)(cb1_018w) == -2);
        if (!_501) {
          bool _503 = !(_498 >= 0.0030399328097701073f);
          if (!_503) {
            float _505 = abs(_498);
            float _506 = log2(_505);
            float _507 = _506 * 0.4166666567325592f;
            float _508 = exp2(_507);
            float _509 = _508 * 1.0549999475479126f;
            float _510 = _509 + -0.054999999701976776f;
            _514 = _510;
          } else {
            float _512 = _498 * 12.923210144042969f;
            _514 = _512;
          }
          bool _515 = !(_499 >= 0.0030399328097701073f);
          if (!_515) {
            float _517 = abs(_499);
            float _518 = log2(_517);
            float _519 = _518 * 0.4166666567325592f;
            float _520 = exp2(_519);
            float _521 = _520 * 1.0549999475479126f;
            float _522 = _521 + -0.054999999701976776f;
            _526 = _522;
          } else {
            float _524 = _499 * 12.923210144042969f;
            _526 = _524;
          }
          bool _527 = !(_500 >= 0.0030399328097701073f);
          if (!_527) {
            float _529 = abs(_500);
            float _530 = log2(_529);
            float _531 = _530 * 0.4166666567325592f;
            float _532 = exp2(_531);
            float _533 = _532 * 1.0549999475479126f;
            float _534 = _533 + -0.054999999701976776f;
            _538 = _514;
            _539 = _526;
            _540 = _534;
          } else {
            float _536 = _500 * 12.923210144042969f;
            _538 = _514;
            _539 = _526;
            _540 = _536;
          }
        } else {
          _538 = _498;
          _539 = _499;
          _540 = _500;
        }
        float _545 = abs(_538);
        float _546 = abs(_539);
        float _547 = abs(_540);
        float _548 = log2(_545);
        float _549 = log2(_546);
        float _550 = log2(_547);
        float _551 = _548 * cb2_000z;
        float _552 = _549 * cb2_000z;
        float _553 = _550 * cb2_000z;
        float _554 = exp2(_551);
        float _555 = exp2(_552);
        float _556 = exp2(_553);
        float _557 = _554 * cb2_000y;
        float _558 = _555 * cb2_000y;
        float _559 = _556 * cb2_000y;
        float _560 = _557 + cb2_000x;
        float _561 = _558 + cb2_000x;
        float _562 = _559 + cb2_000x;
        float _563 = saturate(_560);
        float _564 = saturate(_561);
        float _565 = saturate(_562);
        _567 = _563;
        _568 = _564;
        _569 = _565;
      }
      float _570 = dot(float3(_567, _568, _569), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _567;
      SV_Target.y = _568;
      SV_Target.z = _569;
      SV_Target.w = _570;
      SV_Target_1.x = _570;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

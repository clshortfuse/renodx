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
  float _335;
  float _336;
  float _337;
  float _438;
  float _439;
  float _440;
  float _465;
  float _477;
  float _505;
  float _517;
  float _529;
  float _530;
  float _531;
  float _558;
  float _559;
  float _560;
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
  float _320 = cb2_016x - _308;
  float _321 = cb2_016y - _311;
  float _322 = cb2_016z - _314;
  float _323 = _320 * cb2_016w;
  float _324 = _321 * cb2_016w;
  float _325 = _322 * cb2_016w;
  float _326 = _323 + _308;
  float _327 = _324 + _311;
  float _328 = _325 + _314;
  if (_274 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _331 = cb2_024x * _326;
    float _332 = cb2_024x * _327;
    float _333 = cb2_024x * _328;
    _335 = _331;
    _336 = _332;
    _337 = _333;
  } else {
    _335 = _326;
    _336 = _327;
    _337 = _328;
  }
  float _338 = _335 * 0.9708889722824097f;
  float _339 = mad(0.026962999254465103f, _336, _338);
  float _340 = mad(0.002148000057786703f, _337, _339);
  float _341 = _335 * 0.01088900025933981f;
  float _342 = mad(0.9869629740715027f, _336, _341);
  float _343 = mad(0.002148000057786703f, _337, _342);
  float _344 = mad(0.026962999254465103f, _336, _341);
  float _345 = mad(0.9621480107307434f, _337, _344);
  if (_274) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _350 = cb1_018y * 0.10000000149011612f;
        float _351 = log2(cb1_018z);
        float _352 = _351 + -13.287712097167969f;
        float _353 = _352 * 1.4929734468460083f;
        float _354 = _353 + 18.0f;
        float _355 = exp2(_354);
        float _356 = _355 * 0.18000000715255737f;
        float _357 = abs(_356);
        float _358 = log2(_357);
        float _359 = _358 * 1.5f;
        float _360 = exp2(_359);
        float _361 = _360 * _350;
        float _362 = _361 / cb1_018z;
        float _363 = _362 + -0.07636754959821701f;
        float _364 = _358 * 1.2750000953674316f;
        float _365 = exp2(_364);
        float _366 = _365 * 0.07636754959821701f;
        float _367 = cb1_018y * 0.011232397519052029f;
        float _368 = _367 * _360;
        float _369 = _368 / cb1_018z;
        float _370 = _366 - _369;
        float _371 = _365 + -0.11232396960258484f;
        float _372 = _371 * _350;
        float _373 = _372 / cb1_018z;
        float _374 = _373 * cb1_018z;
        float _375 = abs(_340);
        float _376 = abs(_343);
        float _377 = abs(_345);
        float _378 = log2(_375);
        float _379 = log2(_376);
        float _380 = log2(_377);
        float _381 = _378 * 1.5f;
        float _382 = _379 * 1.5f;
        float _383 = _380 * 1.5f;
        float _384 = exp2(_381);
        float _385 = exp2(_382);
        float _386 = exp2(_383);
        float _387 = _384 * _374;
        float _388 = _385 * _374;
        float _389 = _386 * _374;
        float _390 = _378 * 1.2750000953674316f;
        float _391 = _379 * 1.2750000953674316f;
        float _392 = _380 * 1.2750000953674316f;
        float _393 = exp2(_390);
        float _394 = exp2(_391);
        float _395 = exp2(_392);
        float _396 = _393 * _363;
        float _397 = _394 * _363;
        float _398 = _395 * _363;
        float _399 = _396 + _370;
        float _400 = _397 + _370;
        float _401 = _398 + _370;
        float _402 = _387 / _399;
        float _403 = _388 / _400;
        float _404 = _389 / _401;
        float _405 = _402 * 9.999999747378752e-05f;
        float _406 = _403 * 9.999999747378752e-05f;
        float _407 = _404 * 9.999999747378752e-05f;
        float _408 = 5000.0f / cb1_018y;
        float _409 = _405 * _408;
        float _410 = _406 * _408;
        float _411 = _407 * _408;
        _438 = _409;
        _439 = _410;
        _440 = _411;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_340, _343, _345));
      _438 = tonemapped.x, _439 = tonemapped.y, _440 = tonemapped.z;
    }
      } else {
        float _413 = _340 + 0.020616600289940834f;
        float _414 = _343 + 0.020616600289940834f;
        float _415 = _345 + 0.020616600289940834f;
        float _416 = _413 * _340;
        float _417 = _414 * _343;
        float _418 = _415 * _345;
        float _419 = _416 + -7.456949970219284e-05f;
        float _420 = _417 + -7.456949970219284e-05f;
        float _421 = _418 + -7.456949970219284e-05f;
        float _422 = _340 * 0.9837960004806519f;
        float _423 = _343 * 0.9837960004806519f;
        float _424 = _345 * 0.9837960004806519f;
        float _425 = _422 + 0.4336790144443512f;
        float _426 = _423 + 0.4336790144443512f;
        float _427 = _424 + 0.4336790144443512f;
        float _428 = _425 * _340;
        float _429 = _426 * _343;
        float _430 = _427 * _345;
        float _431 = _428 + 0.24617899954319f;
        float _432 = _429 + 0.24617899954319f;
        float _433 = _430 + 0.24617899954319f;
        float _434 = _419 / _431;
        float _435 = _420 / _432;
        float _436 = _421 / _433;
        _438 = _434;
        _439 = _435;
        _440 = _436;
      }
      float _441 = _438 * 1.6047500371932983f;
      float _442 = mad(-0.5310800075531006f, _439, _441);
      float _443 = mad(-0.07366999983787537f, _440, _442);
      float _444 = _438 * -0.10208000242710114f;
      float _445 = mad(1.1081299781799316f, _439, _444);
      float _446 = mad(-0.006049999967217445f, _440, _445);
      float _447 = _438 * -0.0032599999103695154f;
      float _448 = mad(-0.07275000214576721f, _439, _447);
      float _449 = mad(1.0760200023651123f, _440, _448);
      if (_274) {
        // float _451 = max(_443, 0.0f);
        // float _452 = max(_446, 0.0f);
        // float _453 = max(_449, 0.0f);
        // bool _454 = !(_451 >= 0.0030399328097701073f);
        // if (!_454) {
        //   float _456 = abs(_451);
        //   float _457 = log2(_456);
        //   float _458 = _457 * 0.4166666567325592f;
        //   float _459 = exp2(_458);
        //   float _460 = _459 * 1.0549999475479126f;
        //   float _461 = _460 + -0.054999999701976776f;
        //   _465 = _461;
        // } else {
        //   float _463 = _451 * 12.923210144042969f;
        //   _465 = _463;
        // }
        // bool _466 = !(_452 >= 0.0030399328097701073f);
        // if (!_466) {
        //   float _468 = abs(_452);
        //   float _469 = log2(_468);
        //   float _470 = _469 * 0.4166666567325592f;
        //   float _471 = exp2(_470);
        //   float _472 = _471 * 1.0549999475479126f;
        //   float _473 = _472 + -0.054999999701976776f;
        //   _477 = _473;
        // } else {
        //   float _475 = _452 * 12.923210144042969f;
        //   _477 = _475;
        // }
        // bool _478 = !(_453 >= 0.0030399328097701073f);
        // if (!_478) {
        //   float _480 = abs(_453);
        //   float _481 = log2(_480);
        //   float _482 = _481 * 0.4166666567325592f;
        //   float _483 = exp2(_482);
        //   float _484 = _483 * 1.0549999475479126f;
        //   float _485 = _484 + -0.054999999701976776f;
        //   _558 = _465;
        //   _559 = _477;
        //   _560 = _485;
        // } else {
        //   float _487 = _453 * 12.923210144042969f;
        //   _558 = _465;
        //   _559 = _477;
        //   _560 = _487;
        // }
        _558 = renodx::color::srgb::EncodeSafe(_443);
        _559 = renodx::color::srgb::EncodeSafe(_446);
        _560 = renodx::color::srgb::EncodeSafe(_449);

      } else {
        float _489 = saturate(_443);
        float _490 = saturate(_446);
        float _491 = saturate(_449);
        bool _492 = ((uint)(cb1_018w) == -2);
        if (!_492) {
          bool _494 = !(_489 >= 0.0030399328097701073f);
          if (!_494) {
            float _496 = abs(_489);
            float _497 = log2(_496);
            float _498 = _497 * 0.4166666567325592f;
            float _499 = exp2(_498);
            float _500 = _499 * 1.0549999475479126f;
            float _501 = _500 + -0.054999999701976776f;
            _505 = _501;
          } else {
            float _503 = _489 * 12.923210144042969f;
            _505 = _503;
          }
          bool _506 = !(_490 >= 0.0030399328097701073f);
          if (!_506) {
            float _508 = abs(_490);
            float _509 = log2(_508);
            float _510 = _509 * 0.4166666567325592f;
            float _511 = exp2(_510);
            float _512 = _511 * 1.0549999475479126f;
            float _513 = _512 + -0.054999999701976776f;
            _517 = _513;
          } else {
            float _515 = _490 * 12.923210144042969f;
            _517 = _515;
          }
          bool _518 = !(_491 >= 0.0030399328097701073f);
          if (!_518) {
            float _520 = abs(_491);
            float _521 = log2(_520);
            float _522 = _521 * 0.4166666567325592f;
            float _523 = exp2(_522);
            float _524 = _523 * 1.0549999475479126f;
            float _525 = _524 + -0.054999999701976776f;
            _529 = _505;
            _530 = _517;
            _531 = _525;
          } else {
            float _527 = _491 * 12.923210144042969f;
            _529 = _505;
            _530 = _517;
            _531 = _527;
          }
        } else {
          _529 = _489;
          _530 = _490;
          _531 = _491;
        }
        float _536 = abs(_529);
        float _537 = abs(_530);
        float _538 = abs(_531);
        float _539 = log2(_536);
        float _540 = log2(_537);
        float _541 = log2(_538);
        float _542 = _539 * cb2_000z;
        float _543 = _540 * cb2_000z;
        float _544 = _541 * cb2_000z;
        float _545 = exp2(_542);
        float _546 = exp2(_543);
        float _547 = exp2(_544);
        float _548 = _545 * cb2_000y;
        float _549 = _546 * cb2_000y;
        float _550 = _547 * cb2_000y;
        float _551 = _548 + cb2_000x;
        float _552 = _549 + cb2_000x;
        float _553 = _550 + cb2_000x;
        float _554 = saturate(_551);
        float _555 = saturate(_552);
        float _556 = saturate(_553);
        _558 = _554;
        _559 = _555;
        _560 = _556;
      }
      float _561 = dot(float3(_558, _559, _560), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _558;
      SV_Target.y = _559;
      SV_Target.z = _560;
      SV_Target.w = _561;
      SV_Target_1.x = _561;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

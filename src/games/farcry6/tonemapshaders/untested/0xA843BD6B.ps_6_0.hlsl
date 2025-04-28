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

Texture2D<float4> t8 : register(t8);

Texture3D<float2> t9 : register(t9);

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
  float cb2_003x : packoffset(c003.x);
  float cb2_003y : packoffset(c003.y);
  float cb2_003z : packoffset(c003.z);
  float cb2_003w : packoffset(c003.w);
  float cb2_004x : packoffset(c004.x);
  float cb2_004y : packoffset(c004.y);
  float cb2_004z : packoffset(c004.z);
  float cb2_004w : packoffset(c004.w);
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
  float _22 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _27 = cb2_015x * TEXCOORD0_centroid.x;
  float _28 = cb2_015y * TEXCOORD0_centroid.y;
  float _31 = _27 + cb2_015z;
  float _32 = _28 + cb2_015w;
  float4 _33 = t8.SampleLevel(s0_space2, float2(_31, _32), 0.0f);
  float _37 = saturate(_33.x);
  float _38 = saturate(_33.z);
  float _41 = cb2_026x * _38;
  float _42 = _37 * 6.283199787139893f;
  float _43 = cos(_42);
  float _44 = sin(_42);
  float _45 = _41 * _43;
  float _46 = _44 * _41;
  float _47 = 1.0f - _33.y;
  float _48 = saturate(_47);
  float _49 = _45 * _48;
  float _50 = _46 * _48;
  float _51 = _49 + TEXCOORD0_centroid.x;
  float _52 = _50 + TEXCOORD0_centroid.y;
  float4 _53 = t1.SampleLevel(s4_space2, float2(_51, _52), 0.0f);
  float _57 = max(_53.x, 0.0f);
  float _58 = max(_53.y, 0.0f);
  float _59 = max(_53.z, 0.0f);
  float _60 = min(_57, 65000.0f);
  float _61 = min(_58, 65000.0f);
  float _62 = min(_59, 65000.0f);
  float4 _63 = t3.SampleLevel(s2_space2, float2(_51, _52), 0.0f);
  float _68 = max(_63.x, 0.0f);
  float _69 = max(_63.y, 0.0f);
  float _70 = max(_63.z, 0.0f);
  float _71 = max(_63.w, 0.0f);
  float _72 = min(_68, 5000.0f);
  float _73 = min(_69, 5000.0f);
  float _74 = min(_70, 5000.0f);
  float _75 = min(_71, 5000.0f);
  float _78 = _22.x * cb0_028z;
  float _79 = _78 + cb0_028x;
  float _80 = cb2_027w / _79;
  float _81 = 1.0f - _80;
  float _82 = abs(_81);
  float _84 = cb2_027y * _82;
  float _86 = _84 - cb2_027z;
  float _87 = saturate(_86);
  float _88 = max(_87, _75);
  float _89 = saturate(_88);
  float _93 = cb2_006x * _51;
  float _94 = cb2_006y * _52;
  float _97 = _93 + cb2_006z;
  float _98 = _94 + cb2_006w;
  float _102 = cb2_007x * _51;
  float _103 = cb2_007y * _52;
  float _106 = _102 + cb2_007z;
  float _107 = _103 + cb2_007w;
  float _111 = cb2_008x * _51;
  float _112 = cb2_008y * _52;
  float _115 = _111 + cb2_008z;
  float _116 = _112 + cb2_008w;
  float4 _117 = t1.SampleLevel(s2_space2, float2(_97, _98), 0.0f);
  float _119 = max(_117.x, 0.0f);
  float _120 = min(_119, 65000.0f);
  float4 _121 = t1.SampleLevel(s2_space2, float2(_106, _107), 0.0f);
  float _123 = max(_121.y, 0.0f);
  float _124 = min(_123, 65000.0f);
  float4 _125 = t1.SampleLevel(s2_space2, float2(_115, _116), 0.0f);
  float _127 = max(_125.z, 0.0f);
  float _128 = min(_127, 65000.0f);
  float4 _129 = t3.SampleLevel(s2_space2, float2(_97, _98), 0.0f);
  float _131 = max(_129.x, 0.0f);
  float _132 = min(_131, 5000.0f);
  float4 _133 = t3.SampleLevel(s2_space2, float2(_106, _107), 0.0f);
  float _135 = max(_133.y, 0.0f);
  float _136 = min(_135, 5000.0f);
  float4 _137 = t3.SampleLevel(s2_space2, float2(_115, _116), 0.0f);
  float _139 = max(_137.z, 0.0f);
  float _140 = min(_139, 5000.0f);
  float4 _141 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _147 = cb2_005x * _141.x;
  float _148 = cb2_005x * _141.y;
  float _149 = cb2_005x * _141.z;
  float _150 = _120 - _60;
  float _151 = _124 - _61;
  float _152 = _128 - _62;
  float _153 = _147 * _150;
  float _154 = _148 * _151;
  float _155 = _149 * _152;
  float _156 = _153 + _60;
  float _157 = _154 + _61;
  float _158 = _155 + _62;
  float _159 = _132 - _72;
  float _160 = _136 - _73;
  float _161 = _140 - _74;
  float _162 = _147 * _159;
  float _163 = _148 * _160;
  float _164 = _149 * _161;
  float _165 = _162 + _72;
  float _166 = _163 + _73;
  float _167 = _164 + _74;
  float4 _168 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _172 = _165 - _156;
  float _173 = _166 - _157;
  float _174 = _167 - _158;
  float _175 = _172 * _89;
  float _176 = _173 * _89;
  float _177 = _174 * _89;
  float _178 = _175 + _156;
  float _179 = _176 + _157;
  float _180 = _177 + _158;
  float _181 = dot(float3(_178, _179, _180), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _185 = t0[0].SExposureData_020;
  float _187 = t0[0].SExposureData_004;
  float _189 = cb2_018x * 0.5f;
  float _190 = _189 * cb2_018y;
  float _191 = _187.x - _190;
  float _192 = cb2_018y * cb2_018x;
  float _193 = 1.0f / _192;
  float _194 = _191 * _193;
  float _195 = _181 / _185.x;
  float _196 = _195 * 5464.01611328125f;
  float _197 = _196 + 9.99999993922529e-09f;
  float _198 = log2(_197);
  float _199 = _198 - _191;
  float _200 = _199 * _193;
  float _201 = saturate(_200);
  float2 _202 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _201), 0.0f);
  float _205 = max(_202.y, 1.0000000116860974e-07f);
  float _206 = _202.x / _205;
  float _207 = _206 + _194;
  float _208 = _207 / _193;
  float _209 = _208 - _187.x;
  float _210 = -0.0f - _209;
  float _212 = _210 - cb2_027x;
  float _213 = max(0.0f, _212);
  float _215 = cb2_026z * _213;
  float _216 = _209 - cb2_027x;
  float _217 = max(0.0f, _216);
  float _219 = cb2_026w * _217;
  bool _220 = (_209 < 0.0f);
  float _221 = select(_220, _215, _219);
  float _222 = exp2(_221);
  float _223 = _222 * _178;
  float _224 = _222 * _179;
  float _225 = _222 * _180;
  float _230 = cb2_024y * _168.x;
  float _231 = cb2_024z * _168.y;
  float _232 = cb2_024w * _168.z;
  float _233 = _230 + _223;
  float _234 = _231 + _224;
  float _235 = _232 + _225;
  float _240 = _233 * cb2_025x;
  float _241 = _234 * cb2_025y;
  float _242 = _235 * cb2_025z;
  float _243 = dot(float3(_240, _241, _242), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _244 = t0[0].SExposureData_012;
  float _246 = _243 * 5464.01611328125f;
  float _247 = _246 * _244.x;
  float _248 = _247 + 9.99999993922529e-09f;
  float _249 = log2(_248);
  float _250 = _249 + 16.929765701293945f;
  float _251 = _250 * 0.05734497308731079f;
  float _252 = saturate(_251);
  float _253 = _252 * _252;
  float _254 = _252 * 2.0f;
  float _255 = 3.0f - _254;
  float _256 = _253 * _255;
  float _257 = _241 * 0.8450999855995178f;
  float _258 = _242 * 0.14589999616146088f;
  float _259 = _257 + _258;
  float _260 = _259 * 2.4890189170837402f;
  float _261 = _259 * 0.3754962384700775f;
  float _262 = _259 * 2.811495304107666f;
  float _263 = _259 * 5.519708156585693f;
  float _264 = _243 - _260;
  float _265 = _256 * _264;
  float _266 = _265 + _260;
  float _267 = _256 * 0.5f;
  float _268 = _267 + 0.5f;
  float _269 = _268 * _264;
  float _270 = _269 + _260;
  float _271 = _240 - _261;
  float _272 = _241 - _262;
  float _273 = _242 - _263;
  float _274 = _268 * _271;
  float _275 = _268 * _272;
  float _276 = _268 * _273;
  float _277 = _274 + _261;
  float _278 = _275 + _262;
  float _279 = _276 + _263;
  float _280 = 1.0f / _270;
  float _281 = _266 * _280;
  float _282 = _281 * _277;
  float _283 = _281 * _278;
  float _284 = _281 * _279;
  float _288 = cb2_020x * TEXCOORD0_centroid.x;
  float _289 = cb2_020y * TEXCOORD0_centroid.y;
  float _292 = _288 + cb2_020z;
  float _293 = _289 + cb2_020w;
  float _296 = dot(float2(_292, _293), float2(_292, _293));
  float _297 = 1.0f - _296;
  float _298 = saturate(_297);
  float _299 = log2(_298);
  float _300 = _299 * cb2_021w;
  float _301 = exp2(_300);
  float _305 = _282 - cb2_021x;
  float _306 = _283 - cb2_021y;
  float _307 = _284 - cb2_021z;
  float _308 = _305 * _301;
  float _309 = _306 * _301;
  float _310 = _307 * _301;
  float _311 = _308 + cb2_021x;
  float _312 = _309 + cb2_021y;
  float _313 = _310 + cb2_021z;
  float _314 = t0[0].SExposureData_000;
  float _316 = max(_185.x, 0.0010000000474974513f);
  float _317 = 1.0f / _316;
  float _318 = _317 * _314.x;
  bool _321 = ((uint)(cb2_069y) == 0);
  float _327;
  float _328;
  float _329;
  float _383;
  float _384;
  float _385;
  float _430;
  float _431;
  float _432;
  float _477;
  float _478;
  float _479;
  float _480;
  float _527;
  float _528;
  float _529;
  float _554;
  float _555;
  float _556;
  float _657;
  float _658;
  float _659;
  float _684;
  float _696;
  float _724;
  float _736;
  float _748;
  float _749;
  float _750;
  float _777;
  float _778;
  float _779;
  if (!_321) {
    float _323 = _318 * _311;
    float _324 = _318 * _312;
    float _325 = _318 * _313;
    _327 = _323;
    _328 = _324;
    _329 = _325;
  } else {
    _327 = _311;
    _328 = _312;
    _329 = _313;
  }
  float _330 = _327 * 0.6130970120429993f;
  float _331 = mad(0.33952298760414124f, _328, _330);
  float _332 = mad(0.04737899824976921f, _329, _331);
  float _333 = _327 * 0.07019399851560593f;
  float _334 = mad(0.9163540005683899f, _328, _333);
  float _335 = mad(0.013451999984681606f, _329, _334);
  float _336 = _327 * 0.02061600051820278f;
  float _337 = mad(0.10956999659538269f, _328, _336);
  float _338 = mad(0.8698149919509888f, _329, _337);
  float _339 = log2(_332);
  float _340 = log2(_335);
  float _341 = log2(_338);
  float _342 = _339 * 0.04211956635117531f;
  float _343 = _340 * 0.04211956635117531f;
  float _344 = _341 * 0.04211956635117531f;
  float _345 = _342 + 0.6252607107162476f;
  float _346 = _343 + 0.6252607107162476f;
  float _347 = _344 + 0.6252607107162476f;
  float4 _348 = t5.SampleLevel(s2_space2, float3(_345, _346, _347), 0.0f);
  bool _354 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_354 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _358 = cb2_017x * _348.x;
    float _359 = cb2_017x * _348.y;
    float _360 = cb2_017x * _348.z;
    float _362 = _358 + cb2_017y;
    float _363 = _359 + cb2_017y;
    float _364 = _360 + cb2_017y;
    float _365 = exp2(_362);
    float _366 = exp2(_363);
    float _367 = exp2(_364);
    float _368 = _365 + 1.0f;
    float _369 = _366 + 1.0f;
    float _370 = _367 + 1.0f;
    float _371 = 1.0f / _368;
    float _372 = 1.0f / _369;
    float _373 = 1.0f / _370;
    float _375 = cb2_017z * _371;
    float _376 = cb2_017z * _372;
    float _377 = cb2_017z * _373;
    float _379 = _375 + cb2_017w;
    float _380 = _376 + cb2_017w;
    float _381 = _377 + cb2_017w;
    _383 = _379;
    _384 = _380;
    _385 = _381;
  } else {
    _383 = _348.x;
    _384 = _348.y;
    _385 = _348.z;
  }
  float _386 = _383 * 23.0f;
  float _387 = _386 + -14.473931312561035f;
  float _388 = exp2(_387);
  float _389 = _384 * 23.0f;
  float _390 = _389 + -14.473931312561035f;
  float _391 = exp2(_390);
  float _392 = _385 * 23.0f;
  float _393 = _392 + -14.473931312561035f;
  float _394 = exp2(_393);
  float _398 = cb2_004x * TEXCOORD0_centroid.x;
  float _399 = cb2_004y * TEXCOORD0_centroid.y;
  float _402 = _398 + cb2_004z;
  float _403 = _399 + cb2_004w;
  float4 _409 = t7.Sample(s2_space2, float2(_402, _403));
  float _414 = _409.x * cb2_003x;
  float _415 = _409.y * cb2_003y;
  float _416 = _409.z * cb2_003z;
  float _417 = _409.w * cb2_003w;
  float _420 = _417 + cb2_026y;
  float _421 = saturate(_420);
  bool _424 = ((uint)(cb2_069y) == 0);
  if (!_424) {
    float _426 = _414 * _318;
    float _427 = _415 * _318;
    float _428 = _416 * _318;
    _430 = _426;
    _431 = _427;
    _432 = _428;
  } else {
    _430 = _414;
    _431 = _415;
    _432 = _416;
  }
  bool _435 = ((uint)(cb2_028x) == 2);
  bool _436 = ((uint)(cb2_028x) == 3);
  int _437 = (uint)(cb2_028x) & -2;
  bool _438 = (_437 == 2);
  bool _439 = ((uint)(cb2_028x) == 6);
  bool _440 = _438 || _439;
  if (_440) {
    float _442 = _430 * _421;
    float _443 = _431 * _421;
    float _444 = _432 * _421;
    float _445 = _421 * _421;
    _477 = _442;
    _478 = _443;
    _479 = _444;
    _480 = _445;
  } else {
    bool _447 = ((uint)(cb2_028x) == 4);
    if (_447) {
      float _449 = _430 + -1.0f;
      float _450 = _431 + -1.0f;
      float _451 = _432 + -1.0f;
      float _452 = _421 + -1.0f;
      float _453 = _449 * _421;
      float _454 = _450 * _421;
      float _455 = _451 * _421;
      float _456 = _452 * _421;
      float _457 = _453 + 1.0f;
      float _458 = _454 + 1.0f;
      float _459 = _455 + 1.0f;
      float _460 = _456 + 1.0f;
      _477 = _457;
      _478 = _458;
      _479 = _459;
      _480 = _460;
    } else {
      bool _462 = ((uint)(cb2_028x) == 5);
      if (_462) {
        float _464 = _430 + -0.5f;
        float _465 = _431 + -0.5f;
        float _466 = _432 + -0.5f;
        float _467 = _421 + -0.5f;
        float _468 = _464 * _421;
        float _469 = _465 * _421;
        float _470 = _466 * _421;
        float _471 = _467 * _421;
        float _472 = _468 + 0.5f;
        float _473 = _469 + 0.5f;
        float _474 = _470 + 0.5f;
        float _475 = _471 + 0.5f;
        _477 = _472;
        _478 = _473;
        _479 = _474;
        _480 = _475;
      } else {
        _477 = _430;
        _478 = _431;
        _479 = _432;
        _480 = _421;
      }
    }
  }
  if (_435) {
    float _482 = _477 + _388;
    float _483 = _478 + _391;
    float _484 = _479 + _394;
    _527 = _482;
    _528 = _483;
    _529 = _484;
  } else {
    if (_436) {
      float _487 = 1.0f - _477;
      float _488 = 1.0f - _478;
      float _489 = 1.0f - _479;
      float _490 = _487 * _388;
      float _491 = _488 * _391;
      float _492 = _489 * _394;
      float _493 = _490 + _477;
      float _494 = _491 + _478;
      float _495 = _492 + _479;
      _527 = _493;
      _528 = _494;
      _529 = _495;
    } else {
      bool _497 = ((uint)(cb2_028x) == 4);
      if (_497) {
        float _499 = _477 * _388;
        float _500 = _478 * _391;
        float _501 = _479 * _394;
        _527 = _499;
        _528 = _500;
        _529 = _501;
      } else {
        bool _503 = ((uint)(cb2_028x) == 5);
        if (_503) {
          float _505 = _388 * 2.0f;
          float _506 = _505 * _477;
          float _507 = _391 * 2.0f;
          float _508 = _507 * _478;
          float _509 = _394 * 2.0f;
          float _510 = _509 * _479;
          _527 = _506;
          _528 = _508;
          _529 = _510;
        } else {
          if (_439) {
            float _513 = _388 - _477;
            float _514 = _391 - _478;
            float _515 = _394 - _479;
            _527 = _513;
            _528 = _514;
            _529 = _515;
          } else {
            float _517 = _477 - _388;
            float _518 = _478 - _391;
            float _519 = _479 - _394;
            float _520 = _480 * _517;
            float _521 = _480 * _518;
            float _522 = _480 * _519;
            float _523 = _520 + _388;
            float _524 = _521 + _391;
            float _525 = _522 + _394;
            _527 = _523;
            _528 = _524;
            _529 = _525;
          }
        }
      }
    }
  }
  float _535 = cb2_016x - _527;
  float _536 = cb2_016y - _528;
  float _537 = cb2_016z - _529;
  float _538 = _535 * cb2_016w;
  float _539 = _536 * cb2_016w;
  float _540 = _537 * cb2_016w;
  float _541 = _538 + _527;
  float _542 = _539 + _528;
  float _543 = _540 + _529;
  bool _546 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_546 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _550 = cb2_024x * _541;
    float _551 = cb2_024x * _542;
    float _552 = cb2_024x * _543;
    _554 = _550;
    _555 = _551;
    _556 = _552;
  } else {
    _554 = _541;
    _555 = _542;
    _556 = _543;
  }
  float _557 = _554 * 0.9708889722824097f;
  float _558 = mad(0.026962999254465103f, _555, _557);
  float _559 = mad(0.002148000057786703f, _556, _558);
  float _560 = _554 * 0.01088900025933981f;
  float _561 = mad(0.9869629740715027f, _555, _560);
  float _562 = mad(0.002148000057786703f, _556, _561);
  float _563 = mad(0.026962999254465103f, _555, _560);
  float _564 = mad(0.9621480107307434f, _556, _563);
  if (_546) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _569 = cb1_018y * 0.10000000149011612f;
        float _570 = log2(cb1_018z);
        float _571 = _570 + -13.287712097167969f;
        float _572 = _571 * 1.4929734468460083f;
        float _573 = _572 + 18.0f;
        float _574 = exp2(_573);
        float _575 = _574 * 0.18000000715255737f;
        float _576 = abs(_575);
        float _577 = log2(_576);
        float _578 = _577 * 1.5f;
        float _579 = exp2(_578);
        float _580 = _579 * _569;
        float _581 = _580 / cb1_018z;
        float _582 = _581 + -0.07636754959821701f;
        float _583 = _577 * 1.2750000953674316f;
        float _584 = exp2(_583);
        float _585 = _584 * 0.07636754959821701f;
        float _586 = cb1_018y * 0.011232397519052029f;
        float _587 = _586 * _579;
        float _588 = _587 / cb1_018z;
        float _589 = _585 - _588;
        float _590 = _584 + -0.11232396960258484f;
        float _591 = _590 * _569;
        float _592 = _591 / cb1_018z;
        float _593 = _592 * cb1_018z;
        float _594 = abs(_559);
        float _595 = abs(_562);
        float _596 = abs(_564);
        float _597 = log2(_594);
        float _598 = log2(_595);
        float _599 = log2(_596);
        float _600 = _597 * 1.5f;
        float _601 = _598 * 1.5f;
        float _602 = _599 * 1.5f;
        float _603 = exp2(_600);
        float _604 = exp2(_601);
        float _605 = exp2(_602);
        float _606 = _603 * _593;
        float _607 = _604 * _593;
        float _608 = _605 * _593;
        float _609 = _597 * 1.2750000953674316f;
        float _610 = _598 * 1.2750000953674316f;
        float _611 = _599 * 1.2750000953674316f;
        float _612 = exp2(_609);
        float _613 = exp2(_610);
        float _614 = exp2(_611);
        float _615 = _612 * _582;
        float _616 = _613 * _582;
        float _617 = _614 * _582;
        float _618 = _615 + _589;
        float _619 = _616 + _589;
        float _620 = _617 + _589;
        float _621 = _606 / _618;
        float _622 = _607 / _619;
        float _623 = _608 / _620;
        float _624 = _621 * 9.999999747378752e-05f;
        float _625 = _622 * 9.999999747378752e-05f;
        float _626 = _623 * 9.999999747378752e-05f;
        float _627 = 5000.0f / cb1_018y;
        float _628 = _624 * _627;
        float _629 = _625 * _627;
        float _630 = _626 * _627;
        _657 = _628;
        _658 = _629;
        _659 = _630;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_559, _562, _564));
      _657 = tonemapped.x, _658 = tonemapped.y, _659 = tonemapped.z;
    }
      } else {
        float _632 = _559 + 0.020616600289940834f;
        float _633 = _562 + 0.020616600289940834f;
        float _634 = _564 + 0.020616600289940834f;
        float _635 = _632 * _559;
        float _636 = _633 * _562;
        float _637 = _634 * _564;
        float _638 = _635 + -7.456949970219284e-05f;
        float _639 = _636 + -7.456949970219284e-05f;
        float _640 = _637 + -7.456949970219284e-05f;
        float _641 = _559 * 0.9837960004806519f;
        float _642 = _562 * 0.9837960004806519f;
        float _643 = _564 * 0.9837960004806519f;
        float _644 = _641 + 0.4336790144443512f;
        float _645 = _642 + 0.4336790144443512f;
        float _646 = _643 + 0.4336790144443512f;
        float _647 = _644 * _559;
        float _648 = _645 * _562;
        float _649 = _646 * _564;
        float _650 = _647 + 0.24617899954319f;
        float _651 = _648 + 0.24617899954319f;
        float _652 = _649 + 0.24617899954319f;
        float _653 = _638 / _650;
        float _654 = _639 / _651;
        float _655 = _640 / _652;
        _657 = _653;
        _658 = _654;
        _659 = _655;
      }
      float _660 = _657 * 1.6047500371932983f;
      float _661 = mad(-0.5310800075531006f, _658, _660);
      float _662 = mad(-0.07366999983787537f, _659, _661);
      float _663 = _657 * -0.10208000242710114f;
      float _664 = mad(1.1081299781799316f, _658, _663);
      float _665 = mad(-0.006049999967217445f, _659, _664);
      float _666 = _657 * -0.0032599999103695154f;
      float _667 = mad(-0.07275000214576721f, _658, _666);
      float _668 = mad(1.0760200023651123f, _659, _667);
      if (_546) {
        // float _670 = max(_662, 0.0f);
        // float _671 = max(_665, 0.0f);
        // float _672 = max(_668, 0.0f);
        // bool _673 = !(_670 >= 0.0030399328097701073f);
        // if (!_673) {
        //   float _675 = abs(_670);
        //   float _676 = log2(_675);
        //   float _677 = _676 * 0.4166666567325592f;
        //   float _678 = exp2(_677);
        //   float _679 = _678 * 1.0549999475479126f;
        //   float _680 = _679 + -0.054999999701976776f;
        //   _684 = _680;
        // } else {
        //   float _682 = _670 * 12.923210144042969f;
        //   _684 = _682;
        // }
        // bool _685 = !(_671 >= 0.0030399328097701073f);
        // if (!_685) {
        //   float _687 = abs(_671);
        //   float _688 = log2(_687);
        //   float _689 = _688 * 0.4166666567325592f;
        //   float _690 = exp2(_689);
        //   float _691 = _690 * 1.0549999475479126f;
        //   float _692 = _691 + -0.054999999701976776f;
        //   _696 = _692;
        // } else {
        //   float _694 = _671 * 12.923210144042969f;
        //   _696 = _694;
        // }
        // bool _697 = !(_672 >= 0.0030399328097701073f);
        // if (!_697) {
        //   float _699 = abs(_672);
        //   float _700 = log2(_699);
        //   float _701 = _700 * 0.4166666567325592f;
        //   float _702 = exp2(_701);
        //   float _703 = _702 * 1.0549999475479126f;
        //   float _704 = _703 + -0.054999999701976776f;
        //   _777 = _684;
        //   _778 = _696;
        //   _779 = _704;
        // } else {
        //   float _706 = _672 * 12.923210144042969f;
        //   _777 = _684;
        //   _778 = _696;
        //   _779 = _706;
        // }
        _777 = renodx::color::srgb::EncodeSafe(_662);
        _778 = renodx::color::srgb::EncodeSafe(_665);
        _779 = renodx::color::srgb::EncodeSafe(_668);

      } else {
        float _708 = saturate(_662);
        float _709 = saturate(_665);
        float _710 = saturate(_668);
        bool _711 = ((uint)(cb1_018w) == -2);
        if (!_711) {
          bool _713 = !(_708 >= 0.0030399328097701073f);
          if (!_713) {
            float _715 = abs(_708);
            float _716 = log2(_715);
            float _717 = _716 * 0.4166666567325592f;
            float _718 = exp2(_717);
            float _719 = _718 * 1.0549999475479126f;
            float _720 = _719 + -0.054999999701976776f;
            _724 = _720;
          } else {
            float _722 = _708 * 12.923210144042969f;
            _724 = _722;
          }
          bool _725 = !(_709 >= 0.0030399328097701073f);
          if (!_725) {
            float _727 = abs(_709);
            float _728 = log2(_727);
            float _729 = _728 * 0.4166666567325592f;
            float _730 = exp2(_729);
            float _731 = _730 * 1.0549999475479126f;
            float _732 = _731 + -0.054999999701976776f;
            _736 = _732;
          } else {
            float _734 = _709 * 12.923210144042969f;
            _736 = _734;
          }
          bool _737 = !(_710 >= 0.0030399328097701073f);
          if (!_737) {
            float _739 = abs(_710);
            float _740 = log2(_739);
            float _741 = _740 * 0.4166666567325592f;
            float _742 = exp2(_741);
            float _743 = _742 * 1.0549999475479126f;
            float _744 = _743 + -0.054999999701976776f;
            _748 = _724;
            _749 = _736;
            _750 = _744;
          } else {
            float _746 = _710 * 12.923210144042969f;
            _748 = _724;
            _749 = _736;
            _750 = _746;
          }
        } else {
          _748 = _708;
          _749 = _709;
          _750 = _710;
        }
        float _755 = abs(_748);
        float _756 = abs(_749);
        float _757 = abs(_750);
        float _758 = log2(_755);
        float _759 = log2(_756);
        float _760 = log2(_757);
        float _761 = _758 * cb2_000z;
        float _762 = _759 * cb2_000z;
        float _763 = _760 * cb2_000z;
        float _764 = exp2(_761);
        float _765 = exp2(_762);
        float _766 = exp2(_763);
        float _767 = _764 * cb2_000y;
        float _768 = _765 * cb2_000y;
        float _769 = _766 * cb2_000y;
        float _770 = _767 + cb2_000x;
        float _771 = _768 + cb2_000x;
        float _772 = _769 + cb2_000x;
        float _773 = saturate(_770);
        float _774 = saturate(_771);
        float _775 = saturate(_772);
        _777 = _773;
        _778 = _774;
        _779 = _775;
      }
      float _780 = dot(float3(_777, _778, _779), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _777;
      SV_Target.y = _778;
      SV_Target.z = _779;
      SV_Target.w = _780;
      SV_Target_1.x = _780;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

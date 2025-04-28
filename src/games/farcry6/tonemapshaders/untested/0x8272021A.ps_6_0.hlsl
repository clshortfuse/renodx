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

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t9 : register(t9);

Texture3D<float2> t10 : register(t10);

Texture2D<float4> t11 : register(t11);

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
  float _26 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _31 = cb2_015x * TEXCOORD0_centroid.x;
  float _32 = cb2_015y * TEXCOORD0_centroid.y;
  float _35 = _31 + cb2_015z;
  float _36 = _32 + cb2_015w;
  float4 _37 = t9.SampleLevel(s0_space2, float2(_35, _36), 0.0f);
  float _41 = saturate(_37.x);
  float _42 = saturate(_37.z);
  float _45 = cb2_026x * _42;
  float _46 = _41 * 6.283199787139893f;
  float _47 = cos(_46);
  float _48 = sin(_46);
  float _49 = _45 * _47;
  float _50 = _48 * _45;
  float _51 = 1.0f - _37.y;
  float _52 = saturate(_51);
  float _53 = _49 * _52;
  float _54 = _50 * _52;
  float _55 = _53 + TEXCOORD0_centroid.x;
  float _56 = _54 + TEXCOORD0_centroid.y;
  float4 _57 = t1.SampleLevel(s4_space2, float2(_55, _56), 0.0f);
  float _61 = max(_57.x, 0.0f);
  float _62 = max(_57.y, 0.0f);
  float _63 = max(_57.z, 0.0f);
  float _64 = min(_61, 65000.0f);
  float _65 = min(_62, 65000.0f);
  float _66 = min(_63, 65000.0f);
  float4 _67 = t4.SampleLevel(s2_space2, float2(_55, _56), 0.0f);
  float _72 = max(_67.x, 0.0f);
  float _73 = max(_67.y, 0.0f);
  float _74 = max(_67.z, 0.0f);
  float _75 = max(_67.w, 0.0f);
  float _76 = min(_72, 5000.0f);
  float _77 = min(_73, 5000.0f);
  float _78 = min(_74, 5000.0f);
  float _79 = min(_75, 5000.0f);
  float _82 = _26.x * cb0_028z;
  float _83 = _82 + cb0_028x;
  float _84 = cb2_027w / _83;
  float _85 = 1.0f - _84;
  float _86 = abs(_85);
  float _88 = cb2_027y * _86;
  float _90 = _88 - cb2_027z;
  float _91 = saturate(_90);
  float _92 = max(_91, _79);
  float _93 = saturate(_92);
  float _97 = cb2_006x * _55;
  float _98 = cb2_006y * _56;
  float _101 = _97 + cb2_006z;
  float _102 = _98 + cb2_006w;
  float _106 = cb2_007x * _55;
  float _107 = cb2_007y * _56;
  float _110 = _106 + cb2_007z;
  float _111 = _107 + cb2_007w;
  float _115 = cb2_008x * _55;
  float _116 = cb2_008y * _56;
  float _119 = _115 + cb2_008z;
  float _120 = _116 + cb2_008w;
  float4 _121 = t1.SampleLevel(s2_space2, float2(_101, _102), 0.0f);
  float _123 = max(_121.x, 0.0f);
  float _124 = min(_123, 65000.0f);
  float4 _125 = t1.SampleLevel(s2_space2, float2(_110, _111), 0.0f);
  float _127 = max(_125.y, 0.0f);
  float _128 = min(_127, 65000.0f);
  float4 _129 = t1.SampleLevel(s2_space2, float2(_119, _120), 0.0f);
  float _131 = max(_129.z, 0.0f);
  float _132 = min(_131, 65000.0f);
  float4 _133 = t4.SampleLevel(s2_space2, float2(_101, _102), 0.0f);
  float _135 = max(_133.x, 0.0f);
  float _136 = min(_135, 5000.0f);
  float4 _137 = t4.SampleLevel(s2_space2, float2(_110, _111), 0.0f);
  float _139 = max(_137.y, 0.0f);
  float _140 = min(_139, 5000.0f);
  float4 _141 = t4.SampleLevel(s2_space2, float2(_119, _120), 0.0f);
  float _143 = max(_141.z, 0.0f);
  float _144 = min(_143, 5000.0f);
  float4 _145 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _151 = cb2_005x * _145.x;
  float _152 = cb2_005x * _145.y;
  float _153 = cb2_005x * _145.z;
  float _154 = _124 - _64;
  float _155 = _128 - _65;
  float _156 = _132 - _66;
  float _157 = _151 * _154;
  float _158 = _152 * _155;
  float _159 = _153 * _156;
  float _160 = _157 + _64;
  float _161 = _158 + _65;
  float _162 = _159 + _66;
  float _163 = _136 - _76;
  float _164 = _140 - _77;
  float _165 = _144 - _78;
  float _166 = _151 * _163;
  float _167 = _152 * _164;
  float _168 = _153 * _165;
  float _169 = _166 + _76;
  float _170 = _167 + _77;
  float _171 = _168 + _78;
  float4 _172 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _176 = _169 - _160;
  float _177 = _170 - _161;
  float _178 = _171 - _162;
  float _179 = _176 * _93;
  float _180 = _177 * _93;
  float _181 = _178 * _93;
  float _182 = _179 + _160;
  float _183 = _180 + _161;
  float _184 = _181 + _162;
  float _185 = dot(float3(_182, _183, _184), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _189 = t0[0].SExposureData_020;
  float _191 = t0[0].SExposureData_004;
  float _193 = cb2_018x * 0.5f;
  float _194 = _193 * cb2_018y;
  float _195 = _191.x - _194;
  float _196 = cb2_018y * cb2_018x;
  float _197 = 1.0f / _196;
  float _198 = _195 * _197;
  float _199 = _185 / _189.x;
  float _200 = _199 * 5464.01611328125f;
  float _201 = _200 + 9.99999993922529e-09f;
  float _202 = log2(_201);
  float _203 = _202 - _195;
  float _204 = _203 * _197;
  float _205 = saturate(_204);
  float2 _206 = t10.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _205), 0.0f);
  float _209 = max(_206.y, 1.0000000116860974e-07f);
  float _210 = _206.x / _209;
  float _211 = _210 + _198;
  float _212 = _211 / _197;
  float _213 = _212 - _191.x;
  float _214 = -0.0f - _213;
  float _216 = _214 - cb2_027x;
  float _217 = max(0.0f, _216);
  float _219 = cb2_026z * _217;
  float _220 = _213 - cb2_027x;
  float _221 = max(0.0f, _220);
  float _223 = cb2_026w * _221;
  bool _224 = (_213 < 0.0f);
  float _225 = select(_224, _219, _223);
  float _226 = exp2(_225);
  float _227 = _226 * _182;
  float _228 = _226 * _183;
  float _229 = _226 * _184;
  float _234 = cb2_024y * _172.x;
  float _235 = cb2_024z * _172.y;
  float _236 = cb2_024w * _172.z;
  float _237 = _234 + _227;
  float _238 = _235 + _228;
  float _239 = _236 + _229;
  float _244 = _237 * cb2_025x;
  float _245 = _238 * cb2_025y;
  float _246 = _239 * cb2_025z;
  float _247 = dot(float3(_244, _245, _246), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _248 = t0[0].SExposureData_012;
  float _250 = _247 * 5464.01611328125f;
  float _251 = _250 * _248.x;
  float _252 = _251 + 9.99999993922529e-09f;
  float _253 = log2(_252);
  float _254 = _253 + 16.929765701293945f;
  float _255 = _254 * 0.05734497308731079f;
  float _256 = saturate(_255);
  float _257 = _256 * _256;
  float _258 = _256 * 2.0f;
  float _259 = 3.0f - _258;
  float _260 = _257 * _259;
  float _261 = _245 * 0.8450999855995178f;
  float _262 = _246 * 0.14589999616146088f;
  float _263 = _261 + _262;
  float _264 = _263 * 2.4890189170837402f;
  float _265 = _263 * 0.3754962384700775f;
  float _266 = _263 * 2.811495304107666f;
  float _267 = _263 * 5.519708156585693f;
  float _268 = _247 - _264;
  float _269 = _260 * _268;
  float _270 = _269 + _264;
  float _271 = _260 * 0.5f;
  float _272 = _271 + 0.5f;
  float _273 = _272 * _268;
  float _274 = _273 + _264;
  float _275 = _244 - _265;
  float _276 = _245 - _266;
  float _277 = _246 - _267;
  float _278 = _272 * _275;
  float _279 = _272 * _276;
  float _280 = _272 * _277;
  float _281 = _278 + _265;
  float _282 = _279 + _266;
  float _283 = _280 + _267;
  float _284 = 1.0f / _274;
  float _285 = _270 * _284;
  float _286 = _285 * _281;
  float _287 = _285 * _282;
  float _288 = _285 * _283;
  float _292 = cb2_020x * TEXCOORD0_centroid.x;
  float _293 = cb2_020y * TEXCOORD0_centroid.y;
  float _296 = _292 + cb2_020z;
  float _297 = _293 + cb2_020w;
  float _300 = dot(float2(_296, _297), float2(_296, _297));
  float _301 = 1.0f - _300;
  float _302 = saturate(_301);
  float _303 = log2(_302);
  float _304 = _303 * cb2_021w;
  float _305 = exp2(_304);
  float _309 = _286 - cb2_021x;
  float _310 = _287 - cb2_021y;
  float _311 = _288 - cb2_021z;
  float _312 = _309 * _305;
  float _313 = _310 * _305;
  float _314 = _311 * _305;
  float _315 = _312 + cb2_021x;
  float _316 = _313 + cb2_021y;
  float _317 = _314 + cb2_021z;
  float _318 = t0[0].SExposureData_000;
  float _320 = max(_189.x, 0.0010000000474974513f);
  float _321 = 1.0f / _320;
  float _322 = _321 * _318.x;
  bool _325 = ((uint)(cb2_069y) == 0);
  float _331;
  float _332;
  float _333;
  float _387;
  float _388;
  float _389;
  float _435;
  float _436;
  float _437;
  float _482;
  float _483;
  float _484;
  float _485;
  float _534;
  float _535;
  float _536;
  float _537;
  float _562;
  float _563;
  float _564;
  float _665;
  float _666;
  float _667;
  float _692;
  float _704;
  float _732;
  float _744;
  float _756;
  float _757;
  float _758;
  float _785;
  float _786;
  float _787;
  if (!_325) {
    float _327 = _322 * _315;
    float _328 = _322 * _316;
    float _329 = _322 * _317;
    _331 = _327;
    _332 = _328;
    _333 = _329;
  } else {
    _331 = _315;
    _332 = _316;
    _333 = _317;
  }
  float _334 = _331 * 0.6130970120429993f;
  float _335 = mad(0.33952298760414124f, _332, _334);
  float _336 = mad(0.04737899824976921f, _333, _335);
  float _337 = _331 * 0.07019399851560593f;
  float _338 = mad(0.9163540005683899f, _332, _337);
  float _339 = mad(0.013451999984681606f, _333, _338);
  float _340 = _331 * 0.02061600051820278f;
  float _341 = mad(0.10956999659538269f, _332, _340);
  float _342 = mad(0.8698149919509888f, _333, _341);
  float _343 = log2(_336);
  float _344 = log2(_339);
  float _345 = log2(_342);
  float _346 = _343 * 0.04211956635117531f;
  float _347 = _344 * 0.04211956635117531f;
  float _348 = _345 * 0.04211956635117531f;
  float _349 = _346 + 0.6252607107162476f;
  float _350 = _347 + 0.6252607107162476f;
  float _351 = _348 + 0.6252607107162476f;
  float4 _352 = t6.SampleLevel(s2_space2, float3(_349, _350, _351), 0.0f);
  bool _358 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_358 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _362 = cb2_017x * _352.x;
    float _363 = cb2_017x * _352.y;
    float _364 = cb2_017x * _352.z;
    float _366 = _362 + cb2_017y;
    float _367 = _363 + cb2_017y;
    float _368 = _364 + cb2_017y;
    float _369 = exp2(_366);
    float _370 = exp2(_367);
    float _371 = exp2(_368);
    float _372 = _369 + 1.0f;
    float _373 = _370 + 1.0f;
    float _374 = _371 + 1.0f;
    float _375 = 1.0f / _372;
    float _376 = 1.0f / _373;
    float _377 = 1.0f / _374;
    float _379 = cb2_017z * _375;
    float _380 = cb2_017z * _376;
    float _381 = cb2_017z * _377;
    float _383 = _379 + cb2_017w;
    float _384 = _380 + cb2_017w;
    float _385 = _381 + cb2_017w;
    _387 = _383;
    _388 = _384;
    _389 = _385;
  } else {
    _387 = _352.x;
    _388 = _352.y;
    _389 = _352.z;
  }
  float _390 = _387 * 23.0f;
  float _391 = _390 + -14.473931312561035f;
  float _392 = exp2(_391);
  float _393 = _388 * 23.0f;
  float _394 = _393 + -14.473931312561035f;
  float _395 = exp2(_394);
  float _396 = _389 * 23.0f;
  float _397 = _396 + -14.473931312561035f;
  float _398 = exp2(_397);
  float _403 = cb2_004x * TEXCOORD0_centroid.x;
  float _404 = cb2_004y * TEXCOORD0_centroid.y;
  float _407 = _403 + cb2_004z;
  float _408 = _404 + cb2_004w;
  float4 _414 = t8.Sample(s2_space2, float2(_407, _408));
  float _419 = _414.x * cb2_003x;
  float _420 = _414.y * cb2_003y;
  float _421 = _414.z * cb2_003z;
  float _422 = _414.w * cb2_003w;
  float _425 = _422 + cb2_026y;
  float _426 = saturate(_425);
  bool _429 = ((uint)(cb2_069y) == 0);
  if (!_429) {
    float _431 = _419 * _322;
    float _432 = _420 * _322;
    float _433 = _421 * _322;
    _435 = _431;
    _436 = _432;
    _437 = _433;
  } else {
    _435 = _419;
    _436 = _420;
    _437 = _421;
  }
  bool _440 = ((uint)(cb2_028x) == 2);
  bool _441 = ((uint)(cb2_028x) == 3);
  int _442 = (uint)(cb2_028x) & -2;
  bool _443 = (_442 == 2);
  bool _444 = ((uint)(cb2_028x) == 6);
  bool _445 = _443 || _444;
  if (_445) {
    float _447 = _435 * _426;
    float _448 = _436 * _426;
    float _449 = _437 * _426;
    float _450 = _426 * _426;
    _482 = _447;
    _483 = _448;
    _484 = _449;
    _485 = _450;
  } else {
    bool _452 = ((uint)(cb2_028x) == 4);
    if (_452) {
      float _454 = _435 + -1.0f;
      float _455 = _436 + -1.0f;
      float _456 = _437 + -1.0f;
      float _457 = _426 + -1.0f;
      float _458 = _454 * _426;
      float _459 = _455 * _426;
      float _460 = _456 * _426;
      float _461 = _457 * _426;
      float _462 = _458 + 1.0f;
      float _463 = _459 + 1.0f;
      float _464 = _460 + 1.0f;
      float _465 = _461 + 1.0f;
      _482 = _462;
      _483 = _463;
      _484 = _464;
      _485 = _465;
    } else {
      bool _467 = ((uint)(cb2_028x) == 5);
      if (_467) {
        float _469 = _435 + -0.5f;
        float _470 = _436 + -0.5f;
        float _471 = _437 + -0.5f;
        float _472 = _426 + -0.5f;
        float _473 = _469 * _426;
        float _474 = _470 * _426;
        float _475 = _471 * _426;
        float _476 = _472 * _426;
        float _477 = _473 + 0.5f;
        float _478 = _474 + 0.5f;
        float _479 = _475 + 0.5f;
        float _480 = _476 + 0.5f;
        _482 = _477;
        _483 = _478;
        _484 = _479;
        _485 = _480;
      } else {
        _482 = _435;
        _483 = _436;
        _484 = _437;
        _485 = _426;
      }
    }
  }
  if (_440) {
    float _487 = _482 + _392;
    float _488 = _483 + _395;
    float _489 = _484 + _398;
    _534 = _487;
    _535 = _488;
    _536 = _489;
    _537 = cb2_025w;
  } else {
    if (_441) {
      float _492 = 1.0f - _482;
      float _493 = 1.0f - _483;
      float _494 = 1.0f - _484;
      float _495 = _492 * _392;
      float _496 = _493 * _395;
      float _497 = _494 * _398;
      float _498 = _495 + _482;
      float _499 = _496 + _483;
      float _500 = _497 + _484;
      _534 = _498;
      _535 = _499;
      _536 = _500;
      _537 = cb2_025w;
    } else {
      bool _502 = ((uint)(cb2_028x) == 4);
      if (_502) {
        float _504 = _482 * _392;
        float _505 = _483 * _395;
        float _506 = _484 * _398;
        _534 = _504;
        _535 = _505;
        _536 = _506;
        _537 = cb2_025w;
      } else {
        bool _508 = ((uint)(cb2_028x) == 5);
        if (_508) {
          float _510 = _392 * 2.0f;
          float _511 = _510 * _482;
          float _512 = _395 * 2.0f;
          float _513 = _512 * _483;
          float _514 = _398 * 2.0f;
          float _515 = _514 * _484;
          _534 = _511;
          _535 = _513;
          _536 = _515;
          _537 = cb2_025w;
        } else {
          if (_444) {
            float _518 = _392 - _482;
            float _519 = _395 - _483;
            float _520 = _398 - _484;
            _534 = _518;
            _535 = _519;
            _536 = _520;
            _537 = cb2_025w;
          } else {
            float _522 = _482 - _392;
            float _523 = _483 - _395;
            float _524 = _484 - _398;
            float _525 = _485 * _522;
            float _526 = _485 * _523;
            float _527 = _485 * _524;
            float _528 = _525 + _392;
            float _529 = _526 + _395;
            float _530 = _527 + _398;
            float _531 = 1.0f - _485;
            float _532 = _531 * cb2_025w;
            _534 = _528;
            _535 = _529;
            _536 = _530;
            _537 = _532;
          }
        }
      }
    }
  }
  float _543 = cb2_016x - _534;
  float _544 = cb2_016y - _535;
  float _545 = cb2_016z - _536;
  float _546 = _543 * cb2_016w;
  float _547 = _544 * cb2_016w;
  float _548 = _545 * cb2_016w;
  float _549 = _546 + _534;
  float _550 = _547 + _535;
  float _551 = _548 + _536;
  bool _554 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_554 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _558 = cb2_024x * _549;
    float _559 = cb2_024x * _550;
    float _560 = cb2_024x * _551;
    _562 = _558;
    _563 = _559;
    _564 = _560;
  } else {
    _562 = _549;
    _563 = _550;
    _564 = _551;
  }
  float _565 = _562 * 0.9708889722824097f;
  float _566 = mad(0.026962999254465103f, _563, _565);
  float _567 = mad(0.002148000057786703f, _564, _566);
  float _568 = _562 * 0.01088900025933981f;
  float _569 = mad(0.9869629740715027f, _563, _568);
  float _570 = mad(0.002148000057786703f, _564, _569);
  float _571 = mad(0.026962999254465103f, _563, _568);
  float _572 = mad(0.9621480107307434f, _564, _571);
  if (_554) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _577 = cb1_018y * 0.10000000149011612f;
        float _578 = log2(cb1_018z);
        float _579 = _578 + -13.287712097167969f;
        float _580 = _579 * 1.4929734468460083f;
        float _581 = _580 + 18.0f;
        float _582 = exp2(_581);
        float _583 = _582 * 0.18000000715255737f;
        float _584 = abs(_583);
        float _585 = log2(_584);
        float _586 = _585 * 1.5f;
        float _587 = exp2(_586);
        float _588 = _587 * _577;
        float _589 = _588 / cb1_018z;
        float _590 = _589 + -0.07636754959821701f;
        float _591 = _585 * 1.2750000953674316f;
        float _592 = exp2(_591);
        float _593 = _592 * 0.07636754959821701f;
        float _594 = cb1_018y * 0.011232397519052029f;
        float _595 = _594 * _587;
        float _596 = _595 / cb1_018z;
        float _597 = _593 - _596;
        float _598 = _592 + -0.11232396960258484f;
        float _599 = _598 * _577;
        float _600 = _599 / cb1_018z;
        float _601 = _600 * cb1_018z;
        float _602 = abs(_567);
        float _603 = abs(_570);
        float _604 = abs(_572);
        float _605 = log2(_602);
        float _606 = log2(_603);
        float _607 = log2(_604);
        float _608 = _605 * 1.5f;
        float _609 = _606 * 1.5f;
        float _610 = _607 * 1.5f;
        float _611 = exp2(_608);
        float _612 = exp2(_609);
        float _613 = exp2(_610);
        float _614 = _611 * _601;
        float _615 = _612 * _601;
        float _616 = _613 * _601;
        float _617 = _605 * 1.2750000953674316f;
        float _618 = _606 * 1.2750000953674316f;
        float _619 = _607 * 1.2750000953674316f;
        float _620 = exp2(_617);
        float _621 = exp2(_618);
        float _622 = exp2(_619);
        float _623 = _620 * _590;
        float _624 = _621 * _590;
        float _625 = _622 * _590;
        float _626 = _623 + _597;
        float _627 = _624 + _597;
        float _628 = _625 + _597;
        float _629 = _614 / _626;
        float _630 = _615 / _627;
        float _631 = _616 / _628;
        float _632 = _629 * 9.999999747378752e-05f;
        float _633 = _630 * 9.999999747378752e-05f;
        float _634 = _631 * 9.999999747378752e-05f;
        float _635 = 5000.0f / cb1_018y;
        float _636 = _632 * _635;
        float _637 = _633 * _635;
        float _638 = _634 * _635;
        _665 = _636;
        _666 = _637;
        _667 = _638;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_567, _570, _572));
      _665 = tonemapped.x, _666 = tonemapped.y, _667 = tonemapped.z;
    }
      } else {
        float _640 = _567 + 0.020616600289940834f;
        float _641 = _570 + 0.020616600289940834f;
        float _642 = _572 + 0.020616600289940834f;
        float _643 = _640 * _567;
        float _644 = _641 * _570;
        float _645 = _642 * _572;
        float _646 = _643 + -7.456949970219284e-05f;
        float _647 = _644 + -7.456949970219284e-05f;
        float _648 = _645 + -7.456949970219284e-05f;
        float _649 = _567 * 0.9837960004806519f;
        float _650 = _570 * 0.9837960004806519f;
        float _651 = _572 * 0.9837960004806519f;
        float _652 = _649 + 0.4336790144443512f;
        float _653 = _650 + 0.4336790144443512f;
        float _654 = _651 + 0.4336790144443512f;
        float _655 = _652 * _567;
        float _656 = _653 * _570;
        float _657 = _654 * _572;
        float _658 = _655 + 0.24617899954319f;
        float _659 = _656 + 0.24617899954319f;
        float _660 = _657 + 0.24617899954319f;
        float _661 = _646 / _658;
        float _662 = _647 / _659;
        float _663 = _648 / _660;
        _665 = _661;
        _666 = _662;
        _667 = _663;
      }
      float _668 = _665 * 1.6047500371932983f;
      float _669 = mad(-0.5310800075531006f, _666, _668);
      float _670 = mad(-0.07366999983787537f, _667, _669);
      float _671 = _665 * -0.10208000242710114f;
      float _672 = mad(1.1081299781799316f, _666, _671);
      float _673 = mad(-0.006049999967217445f, _667, _672);
      float _674 = _665 * -0.0032599999103695154f;
      float _675 = mad(-0.07275000214576721f, _666, _674);
      float _676 = mad(1.0760200023651123f, _667, _675);
      if (_554) {
        // float _678 = max(_670, 0.0f);
        // float _679 = max(_673, 0.0f);
        // float _680 = max(_676, 0.0f);
        // bool _681 = !(_678 >= 0.0030399328097701073f);
        // if (!_681) {
        //   float _683 = abs(_678);
        //   float _684 = log2(_683);
        //   float _685 = _684 * 0.4166666567325592f;
        //   float _686 = exp2(_685);
        //   float _687 = _686 * 1.0549999475479126f;
        //   float _688 = _687 + -0.054999999701976776f;
        //   _692 = _688;
        // } else {
        //   float _690 = _678 * 12.923210144042969f;
        //   _692 = _690;
        // }
        // bool _693 = !(_679 >= 0.0030399328097701073f);
        // if (!_693) {
        //   float _695 = abs(_679);
        //   float _696 = log2(_695);
        //   float _697 = _696 * 0.4166666567325592f;
        //   float _698 = exp2(_697);
        //   float _699 = _698 * 1.0549999475479126f;
        //   float _700 = _699 + -0.054999999701976776f;
        //   _704 = _700;
        // } else {
        //   float _702 = _679 * 12.923210144042969f;
        //   _704 = _702;
        // }
        // bool _705 = !(_680 >= 0.0030399328097701073f);
        // if (!_705) {
        //   float _707 = abs(_680);
        //   float _708 = log2(_707);
        //   float _709 = _708 * 0.4166666567325592f;
        //   float _710 = exp2(_709);
        //   float _711 = _710 * 1.0549999475479126f;
        //   float _712 = _711 + -0.054999999701976776f;
        //   _785 = _692;
        //   _786 = _704;
        //   _787 = _712;
        // } else {
        //   float _714 = _680 * 12.923210144042969f;
        //   _785 = _692;
        //   _786 = _704;
        //   _787 = _714;
        // }
        _785 = renodx::color::srgb::EncodeSafe(_670);
        _786 = renodx::color::srgb::EncodeSafe(_673);
        _787 = renodx::color::srgb::EncodeSafe(_676);

      } else {
        float _716 = saturate(_670);
        float _717 = saturate(_673);
        float _718 = saturate(_676);
        bool _719 = ((uint)(cb1_018w) == -2);
        if (!_719) {
          bool _721 = !(_716 >= 0.0030399328097701073f);
          if (!_721) {
            float _723 = abs(_716);
            float _724 = log2(_723);
            float _725 = _724 * 0.4166666567325592f;
            float _726 = exp2(_725);
            float _727 = _726 * 1.0549999475479126f;
            float _728 = _727 + -0.054999999701976776f;
            _732 = _728;
          } else {
            float _730 = _716 * 12.923210144042969f;
            _732 = _730;
          }
          bool _733 = !(_717 >= 0.0030399328097701073f);
          if (!_733) {
            float _735 = abs(_717);
            float _736 = log2(_735);
            float _737 = _736 * 0.4166666567325592f;
            float _738 = exp2(_737);
            float _739 = _738 * 1.0549999475479126f;
            float _740 = _739 + -0.054999999701976776f;
            _744 = _740;
          } else {
            float _742 = _717 * 12.923210144042969f;
            _744 = _742;
          }
          bool _745 = !(_718 >= 0.0030399328097701073f);
          if (!_745) {
            float _747 = abs(_718);
            float _748 = log2(_747);
            float _749 = _748 * 0.4166666567325592f;
            float _750 = exp2(_749);
            float _751 = _750 * 1.0549999475479126f;
            float _752 = _751 + -0.054999999701976776f;
            _756 = _732;
            _757 = _744;
            _758 = _752;
          } else {
            float _754 = _718 * 12.923210144042969f;
            _756 = _732;
            _757 = _744;
            _758 = _754;
          }
        } else {
          _756 = _716;
          _757 = _717;
          _758 = _718;
        }
        float _763 = abs(_756);
        float _764 = abs(_757);
        float _765 = abs(_758);
        float _766 = log2(_763);
        float _767 = log2(_764);
        float _768 = log2(_765);
        float _769 = _766 * cb2_000z;
        float _770 = _767 * cb2_000z;
        float _771 = _768 * cb2_000z;
        float _772 = exp2(_769);
        float _773 = exp2(_770);
        float _774 = exp2(_771);
        float _775 = _772 * cb2_000y;
        float _776 = _773 * cb2_000y;
        float _777 = _774 * cb2_000y;
        float _778 = _775 + cb2_000x;
        float _779 = _776 + cb2_000x;
        float _780 = _777 + cb2_000x;
        float _781 = saturate(_778);
        float _782 = saturate(_779);
        float _783 = saturate(_780);
        _785 = _781;
        _786 = _782;
        _787 = _783;
      }
      float _791 = cb2_023x * TEXCOORD0_centroid.x;
      float _792 = cb2_023y * TEXCOORD0_centroid.y;
      float _795 = _791 + cb2_023z;
      float _796 = _792 + cb2_023w;
      float4 _799 = t11.SampleLevel(s0_space2, float2(_795, _796), 0.0f);
      float _801 = _799.x + -0.5f;
      float _802 = _801 * cb2_022x;
      float _803 = _802 + 0.5f;
      float _804 = _803 * 2.0f;
      float _805 = _804 * _785;
      float _806 = _804 * _786;
      float _807 = _804 * _787;
      float _811 = float((uint)(cb2_019z));
      float _812 = float((uint)(cb2_019w));
      float _813 = _811 + SV_Position.x;
      float _814 = _812 + SV_Position.y;
      uint _815 = uint(_813);
      uint _816 = uint(_814);
      uint _819 = cb2_019x + -1u;
      uint _820 = cb2_019y + -1u;
      int _821 = _815 & _819;
      int _822 = _816 & _820;
      float4 _823 = t3.Load(int3(_821, _822, 0));
      float _827 = _823.x * 2.0f;
      float _828 = _823.y * 2.0f;
      float _829 = _823.z * 2.0f;
      float _830 = _827 + -1.0f;
      float _831 = _828 + -1.0f;
      float _832 = _829 + -1.0f;
      float _833 = _830 * _537;
      float _834 = _831 * _537;
      float _835 = _832 * _537;
      float _836 = _833 + _805;
      float _837 = _834 + _806;
      float _838 = _835 + _807;
      float _839 = dot(float3(_836, _837, _838), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _836;
      SV_Target.y = _837;
      SV_Target.z = _838;
      SV_Target.w = _839;
      SV_Target_1.x = _839;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

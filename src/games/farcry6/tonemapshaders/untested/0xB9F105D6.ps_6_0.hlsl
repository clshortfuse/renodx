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
  float cb2_001x : packoffset(c001.x);
  float cb2_001y : packoffset(c001.y);
  float cb2_001z : packoffset(c001.z);
  float cb2_002x : packoffset(c002.x);
  float cb2_002y : packoffset(c002.y);
  float cb2_002z : packoffset(c002.z);
  float cb2_002w : packoffset(c002.w);
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
  float4 _28 = t9.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _32 = _28.x * 6.283199787139893f;
  float _33 = cos(_32);
  float _34 = sin(_32);
  float _35 = _33 * _28.z;
  float _36 = _34 * _28.z;
  float _37 = _35 + TEXCOORD0_centroid.x;
  float _38 = _36 + TEXCOORD0_centroid.y;
  float _39 = _37 * 10.0f;
  float _40 = 10.0f - _39;
  float _41 = min(_39, _40);
  float _42 = saturate(_41);
  float _43 = _42 * _35;
  float _44 = _38 * 10.0f;
  float _45 = 10.0f - _44;
  float _46 = min(_44, _45);
  float _47 = saturate(_46);
  float _48 = _47 * _36;
  float _49 = _43 + TEXCOORD0_centroid.x;
  float _50 = _48 + TEXCOORD0_centroid.y;
  float4 _51 = t9.SampleLevel(s2_space2, float2(_49, _50), 0.0f);
  float _53 = _51.w * _43;
  float _54 = _51.w * _48;
  float _55 = 1.0f - _28.y;
  float _56 = saturate(_55);
  float _57 = _53 * _56;
  float _58 = _54 * _56;
  float _59 = _57 + TEXCOORD0_centroid.x;
  float _60 = _58 + TEXCOORD0_centroid.y;
  float4 _61 = t9.SampleLevel(s2_space2, float2(_59, _60), 0.0f);
  bool _63 = (_61.y > 0.0f);
  float _64 = select(_63, TEXCOORD0_centroid.x, _59);
  float _65 = select(_63, TEXCOORD0_centroid.y, _60);
  float4 _66 = t1.SampleLevel(s4_space2, float2(_64, _65), 0.0f);
  float _70 = max(_66.x, 0.0f);
  float _71 = max(_66.y, 0.0f);
  float _72 = max(_66.z, 0.0f);
  float _73 = min(_70, 65000.0f);
  float _74 = min(_71, 65000.0f);
  float _75 = min(_72, 65000.0f);
  float4 _76 = t4.SampleLevel(s2_space2, float2(_64, _65), 0.0f);
  float _81 = max(_76.x, 0.0f);
  float _82 = max(_76.y, 0.0f);
  float _83 = max(_76.z, 0.0f);
  float _84 = max(_76.w, 0.0f);
  float _85 = min(_81, 5000.0f);
  float _86 = min(_82, 5000.0f);
  float _87 = min(_83, 5000.0f);
  float _88 = min(_84, 5000.0f);
  float _91 = _26.x * cb0_028z;
  float _92 = _91 + cb0_028x;
  float _93 = cb2_027w / _92;
  float _94 = 1.0f - _93;
  float _95 = abs(_94);
  float _97 = cb2_027y * _95;
  float _99 = _97 - cb2_027z;
  float _100 = saturate(_99);
  float _101 = max(_100, _88);
  float _102 = saturate(_101);
  float _106 = cb2_006x * _64;
  float _107 = cb2_006y * _65;
  float _110 = _106 + cb2_006z;
  float _111 = _107 + cb2_006w;
  float _115 = cb2_007x * _64;
  float _116 = cb2_007y * _65;
  float _119 = _115 + cb2_007z;
  float _120 = _116 + cb2_007w;
  float _124 = cb2_008x * _64;
  float _125 = cb2_008y * _65;
  float _128 = _124 + cb2_008z;
  float _129 = _125 + cb2_008w;
  float4 _130 = t1.SampleLevel(s2_space2, float2(_110, _111), 0.0f);
  float _132 = max(_130.x, 0.0f);
  float _133 = min(_132, 65000.0f);
  float4 _134 = t1.SampleLevel(s2_space2, float2(_119, _120), 0.0f);
  float _136 = max(_134.y, 0.0f);
  float _137 = min(_136, 65000.0f);
  float4 _138 = t1.SampleLevel(s2_space2, float2(_128, _129), 0.0f);
  float _140 = max(_138.z, 0.0f);
  float _141 = min(_140, 65000.0f);
  float4 _142 = t4.SampleLevel(s2_space2, float2(_110, _111), 0.0f);
  float _144 = max(_142.x, 0.0f);
  float _145 = min(_144, 5000.0f);
  float4 _146 = t4.SampleLevel(s2_space2, float2(_119, _120), 0.0f);
  float _148 = max(_146.y, 0.0f);
  float _149 = min(_148, 5000.0f);
  float4 _150 = t4.SampleLevel(s2_space2, float2(_128, _129), 0.0f);
  float _152 = max(_150.z, 0.0f);
  float _153 = min(_152, 5000.0f);
  float4 _154 = t7.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _160 = cb2_005x * _154.x;
  float _161 = cb2_005x * _154.y;
  float _162 = cb2_005x * _154.z;
  float _163 = _133 - _73;
  float _164 = _137 - _74;
  float _165 = _141 - _75;
  float _166 = _160 * _163;
  float _167 = _161 * _164;
  float _168 = _162 * _165;
  float _169 = _166 + _73;
  float _170 = _167 + _74;
  float _171 = _168 + _75;
  float _172 = _145 - _85;
  float _173 = _149 - _86;
  float _174 = _153 - _87;
  float _175 = _160 * _172;
  float _176 = _161 * _173;
  float _177 = _162 * _174;
  float _178 = _175 + _85;
  float _179 = _176 + _86;
  float _180 = _177 + _87;
  float4 _181 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _185 = _178 - _169;
  float _186 = _179 - _170;
  float _187 = _180 - _171;
  float _188 = _185 * _102;
  float _189 = _186 * _102;
  float _190 = _187 * _102;
  float _191 = _188 + _169;
  float _192 = _189 + _170;
  float _193 = _190 + _171;
  float _194 = dot(float3(_191, _192, _193), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _198 = t0[0].SExposureData_020;
  float _200 = t0[0].SExposureData_004;
  float _202 = cb2_018x * 0.5f;
  float _203 = _202 * cb2_018y;
  float _204 = _200.x - _203;
  float _205 = cb2_018y * cb2_018x;
  float _206 = 1.0f / _205;
  float _207 = _204 * _206;
  float _208 = _194 / _198.x;
  float _209 = _208 * 5464.01611328125f;
  float _210 = _209 + 9.99999993922529e-09f;
  float _211 = log2(_210);
  float _212 = _211 - _204;
  float _213 = _212 * _206;
  float _214 = saturate(_213);
  float2 _215 = t10.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _214), 0.0f);
  float _218 = max(_215.y, 1.0000000116860974e-07f);
  float _219 = _215.x / _218;
  float _220 = _219 + _207;
  float _221 = _220 / _206;
  float _222 = _221 - _200.x;
  float _223 = -0.0f - _222;
  float _225 = _223 - cb2_027x;
  float _226 = max(0.0f, _225);
  float _229 = cb2_026z * _226;
  float _230 = _222 - cb2_027x;
  float _231 = max(0.0f, _230);
  float _233 = cb2_026w * _231;
  bool _234 = (_222 < 0.0f);
  float _235 = select(_234, _229, _233);
  float _236 = exp2(_235);
  float _237 = _236 * _191;
  float _238 = _236 * _192;
  float _239 = _236 * _193;
  float _244 = cb2_024y * _181.x;
  float _245 = cb2_024z * _181.y;
  float _246 = cb2_024w * _181.z;
  float _247 = _244 + _237;
  float _248 = _245 + _238;
  float _249 = _246 + _239;
  float _254 = _247 * cb2_025x;
  float _255 = _248 * cb2_025y;
  float _256 = _249 * cb2_025z;
  float _257 = dot(float3(_254, _255, _256), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _258 = t0[0].SExposureData_012;
  float _260 = _257 * 5464.01611328125f;
  float _261 = _260 * _258.x;
  float _262 = _261 + 9.99999993922529e-09f;
  float _263 = log2(_262);
  float _264 = _263 + 16.929765701293945f;
  float _265 = _264 * 0.05734497308731079f;
  float _266 = saturate(_265);
  float _267 = _266 * _266;
  float _268 = _266 * 2.0f;
  float _269 = 3.0f - _268;
  float _270 = _267 * _269;
  float _271 = _255 * 0.8450999855995178f;
  float _272 = _256 * 0.14589999616146088f;
  float _273 = _271 + _272;
  float _274 = _273 * 2.4890189170837402f;
  float _275 = _273 * 0.3754962384700775f;
  float _276 = _273 * 2.811495304107666f;
  float _277 = _273 * 5.519708156585693f;
  float _278 = _257 - _274;
  float _279 = _270 * _278;
  float _280 = _279 + _274;
  float _281 = _270 * 0.5f;
  float _282 = _281 + 0.5f;
  float _283 = _282 * _278;
  float _284 = _283 + _274;
  float _285 = _254 - _275;
  float _286 = _255 - _276;
  float _287 = _256 - _277;
  float _288 = _282 * _285;
  float _289 = _282 * _286;
  float _290 = _282 * _287;
  float _291 = _288 + _275;
  float _292 = _289 + _276;
  float _293 = _290 + _277;
  float _294 = 1.0f / _284;
  float _295 = _280 * _294;
  float _296 = _295 * _291;
  float _297 = _295 * _292;
  float _298 = _295 * _293;
  float _302 = cb2_020x * TEXCOORD0_centroid.x;
  float _303 = cb2_020y * TEXCOORD0_centroid.y;
  float _306 = _302 + cb2_020z;
  float _307 = _303 + cb2_020w;
  float _310 = dot(float2(_306, _307), float2(_306, _307));
  float _311 = 1.0f - _310;
  float _312 = saturate(_311);
  float _313 = log2(_312);
  float _314 = _313 * cb2_021w;
  float _315 = exp2(_314);
  float _319 = _296 - cb2_021x;
  float _320 = _297 - cb2_021y;
  float _321 = _298 - cb2_021z;
  float _322 = _319 * _315;
  float _323 = _320 * _315;
  float _324 = _321 * _315;
  float _325 = _322 + cb2_021x;
  float _326 = _323 + cb2_021y;
  float _327 = _324 + cb2_021z;
  float _328 = t0[0].SExposureData_000;
  float _330 = max(_198.x, 0.0010000000474974513f);
  float _331 = 1.0f / _330;
  float _332 = _331 * _328.x;
  bool _335 = ((uint)(cb2_069y) == 0);
  float _341;
  float _342;
  float _343;
  float _397;
  float _398;
  float _399;
  float _490;
  float _491;
  float _492;
  float _537;
  float _538;
  float _539;
  float _540;
  float _589;
  float _590;
  float _591;
  float _592;
  float _617;
  float _618;
  float _619;
  float _720;
  float _721;
  float _722;
  float _747;
  float _759;
  float _787;
  float _799;
  float _811;
  float _812;
  float _813;
  float _840;
  float _841;
  float _842;
  if (!_335) {
    float _337 = _332 * _325;
    float _338 = _332 * _326;
    float _339 = _332 * _327;
    _341 = _337;
    _342 = _338;
    _343 = _339;
  } else {
    _341 = _325;
    _342 = _326;
    _343 = _327;
  }
  float _344 = _341 * 0.6130970120429993f;
  float _345 = mad(0.33952298760414124f, _342, _344);
  float _346 = mad(0.04737899824976921f, _343, _345);
  float _347 = _341 * 0.07019399851560593f;
  float _348 = mad(0.9163540005683899f, _342, _347);
  float _349 = mad(0.013451999984681606f, _343, _348);
  float _350 = _341 * 0.02061600051820278f;
  float _351 = mad(0.10956999659538269f, _342, _350);
  float _352 = mad(0.8698149919509888f, _343, _351);
  float _353 = log2(_346);
  float _354 = log2(_349);
  float _355 = log2(_352);
  float _356 = _353 * 0.04211956635117531f;
  float _357 = _354 * 0.04211956635117531f;
  float _358 = _355 * 0.04211956635117531f;
  float _359 = _356 + 0.6252607107162476f;
  float _360 = _357 + 0.6252607107162476f;
  float _361 = _358 + 0.6252607107162476f;
  float4 _362 = t6.SampleLevel(s2_space2, float3(_359, _360, _361), 0.0f);
  bool _368 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_368 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _372 = cb2_017x * _362.x;
    float _373 = cb2_017x * _362.y;
    float _374 = cb2_017x * _362.z;
    float _376 = _372 + cb2_017y;
    float _377 = _373 + cb2_017y;
    float _378 = _374 + cb2_017y;
    float _379 = exp2(_376);
    float _380 = exp2(_377);
    float _381 = exp2(_378);
    float _382 = _379 + 1.0f;
    float _383 = _380 + 1.0f;
    float _384 = _381 + 1.0f;
    float _385 = 1.0f / _382;
    float _386 = 1.0f / _383;
    float _387 = 1.0f / _384;
    float _389 = cb2_017z * _385;
    float _390 = cb2_017z * _386;
    float _391 = cb2_017z * _387;
    float _393 = _389 + cb2_017w;
    float _394 = _390 + cb2_017w;
    float _395 = _391 + cb2_017w;
    _397 = _393;
    _398 = _394;
    _399 = _395;
  } else {
    _397 = _362.x;
    _398 = _362.y;
    _399 = _362.z;
  }
  float _400 = _397 * 23.0f;
  float _401 = _400 + -14.473931312561035f;
  float _402 = exp2(_401);
  float _403 = _398 * 23.0f;
  float _404 = _403 + -14.473931312561035f;
  float _405 = exp2(_404);
  float _406 = _399 * 23.0f;
  float _407 = _406 + -14.473931312561035f;
  float _408 = exp2(_407);
  float _409 = dot(float3(_402, _405, _408), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _414 = dot(float3(_402, _405, _408), float3(_402, _405, _408));
  float _415 = rsqrt(_414);
  float _416 = _415 * _402;
  float _417 = _415 * _405;
  float _418 = _415 * _408;
  float _419 = cb2_001x - _416;
  float _420 = cb2_001y - _417;
  float _421 = cb2_001z - _418;
  float _422 = dot(float3(_419, _420, _421), float3(_419, _420, _421));
  float _425 = cb2_002z * _422;
  float _427 = _425 + cb2_002w;
  float _428 = saturate(_427);
  float _430 = cb2_002x * _428;
  float _431 = _409 - _402;
  float _432 = _409 - _405;
  float _433 = _409 - _408;
  float _434 = _430 * _431;
  float _435 = _430 * _432;
  float _436 = _430 * _433;
  float _437 = _434 + _402;
  float _438 = _435 + _405;
  float _439 = _436 + _408;
  float _441 = cb2_002y * _428;
  float _442 = 0.10000000149011612f - _437;
  float _443 = 0.10000000149011612f - _438;
  float _444 = 0.10000000149011612f - _439;
  float _445 = _442 * _441;
  float _446 = _443 * _441;
  float _447 = _444 * _441;
  float _448 = _445 + _437;
  float _449 = _446 + _438;
  float _450 = _447 + _439;
  float _451 = saturate(_448);
  float _452 = saturate(_449);
  float _453 = saturate(_450);
  float _458 = cb2_004x * TEXCOORD0_centroid.x;
  float _459 = cb2_004y * TEXCOORD0_centroid.y;
  float _462 = _458 + cb2_004z;
  float _463 = _459 + cb2_004w;
  float4 _469 = t8.Sample(s2_space2, float2(_462, _463));
  float _474 = _469.x * cb2_003x;
  float _475 = _469.y * cb2_003y;
  float _476 = _469.z * cb2_003z;
  float _477 = _469.w * cb2_003w;
  float _480 = _477 + cb2_026y;
  float _481 = saturate(_480);
  bool _484 = ((uint)(cb2_069y) == 0);
  if (!_484) {
    float _486 = _474 * _332;
    float _487 = _475 * _332;
    float _488 = _476 * _332;
    _490 = _486;
    _491 = _487;
    _492 = _488;
  } else {
    _490 = _474;
    _491 = _475;
    _492 = _476;
  }
  bool _495 = ((uint)(cb2_028x) == 2);
  bool _496 = ((uint)(cb2_028x) == 3);
  int _497 = (uint)(cb2_028x) & -2;
  bool _498 = (_497 == 2);
  bool _499 = ((uint)(cb2_028x) == 6);
  bool _500 = _498 || _499;
  if (_500) {
    float _502 = _490 * _481;
    float _503 = _491 * _481;
    float _504 = _492 * _481;
    float _505 = _481 * _481;
    _537 = _502;
    _538 = _503;
    _539 = _504;
    _540 = _505;
  } else {
    bool _507 = ((uint)(cb2_028x) == 4);
    if (_507) {
      float _509 = _490 + -1.0f;
      float _510 = _491 + -1.0f;
      float _511 = _492 + -1.0f;
      float _512 = _481 + -1.0f;
      float _513 = _509 * _481;
      float _514 = _510 * _481;
      float _515 = _511 * _481;
      float _516 = _512 * _481;
      float _517 = _513 + 1.0f;
      float _518 = _514 + 1.0f;
      float _519 = _515 + 1.0f;
      float _520 = _516 + 1.0f;
      _537 = _517;
      _538 = _518;
      _539 = _519;
      _540 = _520;
    } else {
      bool _522 = ((uint)(cb2_028x) == 5);
      if (_522) {
        float _524 = _490 + -0.5f;
        float _525 = _491 + -0.5f;
        float _526 = _492 + -0.5f;
        float _527 = _481 + -0.5f;
        float _528 = _524 * _481;
        float _529 = _525 * _481;
        float _530 = _526 * _481;
        float _531 = _527 * _481;
        float _532 = _528 + 0.5f;
        float _533 = _529 + 0.5f;
        float _534 = _530 + 0.5f;
        float _535 = _531 + 0.5f;
        _537 = _532;
        _538 = _533;
        _539 = _534;
        _540 = _535;
      } else {
        _537 = _490;
        _538 = _491;
        _539 = _492;
        _540 = _481;
      }
    }
  }
  if (_495) {
    float _542 = _537 + _451;
    float _543 = _538 + _452;
    float _544 = _539 + _453;
    _589 = _542;
    _590 = _543;
    _591 = _544;
    _592 = cb2_025w;
  } else {
    if (_496) {
      float _547 = 1.0f - _537;
      float _548 = 1.0f - _538;
      float _549 = 1.0f - _539;
      float _550 = _547 * _451;
      float _551 = _548 * _452;
      float _552 = _549 * _453;
      float _553 = _550 + _537;
      float _554 = _551 + _538;
      float _555 = _552 + _539;
      _589 = _553;
      _590 = _554;
      _591 = _555;
      _592 = cb2_025w;
    } else {
      bool _557 = ((uint)(cb2_028x) == 4);
      if (_557) {
        float _559 = _537 * _451;
        float _560 = _538 * _452;
        float _561 = _539 * _453;
        _589 = _559;
        _590 = _560;
        _591 = _561;
        _592 = cb2_025w;
      } else {
        bool _563 = ((uint)(cb2_028x) == 5);
        if (_563) {
          float _565 = _451 * 2.0f;
          float _566 = _565 * _537;
          float _567 = _452 * 2.0f;
          float _568 = _567 * _538;
          float _569 = _453 * 2.0f;
          float _570 = _569 * _539;
          _589 = _566;
          _590 = _568;
          _591 = _570;
          _592 = cb2_025w;
        } else {
          if (_499) {
            float _573 = _451 - _537;
            float _574 = _452 - _538;
            float _575 = _453 - _539;
            _589 = _573;
            _590 = _574;
            _591 = _575;
            _592 = cb2_025w;
          } else {
            float _577 = _537 - _451;
            float _578 = _538 - _452;
            float _579 = _539 - _453;
            float _580 = _540 * _577;
            float _581 = _540 * _578;
            float _582 = _540 * _579;
            float _583 = _580 + _451;
            float _584 = _581 + _452;
            float _585 = _582 + _453;
            float _586 = 1.0f - _540;
            float _587 = _586 * cb2_025w;
            _589 = _583;
            _590 = _584;
            _591 = _585;
            _592 = _587;
          }
        }
      }
    }
  }
  float _598 = cb2_016x - _589;
  float _599 = cb2_016y - _590;
  float _600 = cb2_016z - _591;
  float _601 = _598 * cb2_016w;
  float _602 = _599 * cb2_016w;
  float _603 = _600 * cb2_016w;
  float _604 = _601 + _589;
  float _605 = _602 + _590;
  float _606 = _603 + _591;
  bool _609 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_609 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _613 = cb2_024x * _604;
    float _614 = cb2_024x * _605;
    float _615 = cb2_024x * _606;
    _617 = _613;
    _618 = _614;
    _619 = _615;
  } else {
    _617 = _604;
    _618 = _605;
    _619 = _606;
  }
  float _620 = _617 * 0.9708889722824097f;
  float _621 = mad(0.026962999254465103f, _618, _620);
  float _622 = mad(0.002148000057786703f, _619, _621);
  float _623 = _617 * 0.01088900025933981f;
  float _624 = mad(0.9869629740715027f, _618, _623);
  float _625 = mad(0.002148000057786703f, _619, _624);
  float _626 = mad(0.026962999254465103f, _618, _623);
  float _627 = mad(0.9621480107307434f, _619, _626);
  if (_609) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _632 = cb1_018y * 0.10000000149011612f;
        float _633 = log2(cb1_018z);
        float _634 = _633 + -13.287712097167969f;
        float _635 = _634 * 1.4929734468460083f;
        float _636 = _635 + 18.0f;
        float _637 = exp2(_636);
        float _638 = _637 * 0.18000000715255737f;
        float _639 = abs(_638);
        float _640 = log2(_639);
        float _641 = _640 * 1.5f;
        float _642 = exp2(_641);
        float _643 = _642 * _632;
        float _644 = _643 / cb1_018z;
        float _645 = _644 + -0.07636754959821701f;
        float _646 = _640 * 1.2750000953674316f;
        float _647 = exp2(_646);
        float _648 = _647 * 0.07636754959821701f;
        float _649 = cb1_018y * 0.011232397519052029f;
        float _650 = _649 * _642;
        float _651 = _650 / cb1_018z;
        float _652 = _648 - _651;
        float _653 = _647 + -0.11232396960258484f;
        float _654 = _653 * _632;
        float _655 = _654 / cb1_018z;
        float _656 = _655 * cb1_018z;
        float _657 = abs(_622);
        float _658 = abs(_625);
        float _659 = abs(_627);
        float _660 = log2(_657);
        float _661 = log2(_658);
        float _662 = log2(_659);
        float _663 = _660 * 1.5f;
        float _664 = _661 * 1.5f;
        float _665 = _662 * 1.5f;
        float _666 = exp2(_663);
        float _667 = exp2(_664);
        float _668 = exp2(_665);
        float _669 = _666 * _656;
        float _670 = _667 * _656;
        float _671 = _668 * _656;
        float _672 = _660 * 1.2750000953674316f;
        float _673 = _661 * 1.2750000953674316f;
        float _674 = _662 * 1.2750000953674316f;
        float _675 = exp2(_672);
        float _676 = exp2(_673);
        float _677 = exp2(_674);
        float _678 = _675 * _645;
        float _679 = _676 * _645;
        float _680 = _677 * _645;
        float _681 = _678 + _652;
        float _682 = _679 + _652;
        float _683 = _680 + _652;
        float _684 = _669 / _681;
        float _685 = _670 / _682;
        float _686 = _671 / _683;
        float _687 = _684 * 9.999999747378752e-05f;
        float _688 = _685 * 9.999999747378752e-05f;
        float _689 = _686 * 9.999999747378752e-05f;
        float _690 = 5000.0f / cb1_018y;
        float _691 = _687 * _690;
        float _692 = _688 * _690;
        float _693 = _689 * _690;
        _720 = _691;
        _721 = _692;
        _722 = _693;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_622, _625, _627));
      _720 = tonemapped.x, _721 = tonemapped.y, _722 = tonemapped.z;
    }
      } else {
        float _695 = _622 + 0.020616600289940834f;
        float _696 = _625 + 0.020616600289940834f;
        float _697 = _627 + 0.020616600289940834f;
        float _698 = _695 * _622;
        float _699 = _696 * _625;
        float _700 = _697 * _627;
        float _701 = _698 + -7.456949970219284e-05f;
        float _702 = _699 + -7.456949970219284e-05f;
        float _703 = _700 + -7.456949970219284e-05f;
        float _704 = _622 * 0.9837960004806519f;
        float _705 = _625 * 0.9837960004806519f;
        float _706 = _627 * 0.9837960004806519f;
        float _707 = _704 + 0.4336790144443512f;
        float _708 = _705 + 0.4336790144443512f;
        float _709 = _706 + 0.4336790144443512f;
        float _710 = _707 * _622;
        float _711 = _708 * _625;
        float _712 = _709 * _627;
        float _713 = _710 + 0.24617899954319f;
        float _714 = _711 + 0.24617899954319f;
        float _715 = _712 + 0.24617899954319f;
        float _716 = _701 / _713;
        float _717 = _702 / _714;
        float _718 = _703 / _715;
        _720 = _716;
        _721 = _717;
        _722 = _718;
      }
      float _723 = _720 * 1.6047500371932983f;
      float _724 = mad(-0.5310800075531006f, _721, _723);
      float _725 = mad(-0.07366999983787537f, _722, _724);
      float _726 = _720 * -0.10208000242710114f;
      float _727 = mad(1.1081299781799316f, _721, _726);
      float _728 = mad(-0.006049999967217445f, _722, _727);
      float _729 = _720 * -0.0032599999103695154f;
      float _730 = mad(-0.07275000214576721f, _721, _729);
      float _731 = mad(1.0760200023651123f, _722, _730);
      if (_609) {
        // float _733 = max(_725, 0.0f);
        // float _734 = max(_728, 0.0f);
        // float _735 = max(_731, 0.0f);
        // bool _736 = !(_733 >= 0.0030399328097701073f);
        // if (!_736) {
        //   float _738 = abs(_733);
        //   float _739 = log2(_738);
        //   float _740 = _739 * 0.4166666567325592f;
        //   float _741 = exp2(_740);
        //   float _742 = _741 * 1.0549999475479126f;
        //   float _743 = _742 + -0.054999999701976776f;
        //   _747 = _743;
        // } else {
        //   float _745 = _733 * 12.923210144042969f;
        //   _747 = _745;
        // }
        // bool _748 = !(_734 >= 0.0030399328097701073f);
        // if (!_748) {
        //   float _750 = abs(_734);
        //   float _751 = log2(_750);
        //   float _752 = _751 * 0.4166666567325592f;
        //   float _753 = exp2(_752);
        //   float _754 = _753 * 1.0549999475479126f;
        //   float _755 = _754 + -0.054999999701976776f;
        //   _759 = _755;
        // } else {
        //   float _757 = _734 * 12.923210144042969f;
        //   _759 = _757;
        // }
        // bool _760 = !(_735 >= 0.0030399328097701073f);
        // if (!_760) {
        //   float _762 = abs(_735);
        //   float _763 = log2(_762);
        //   float _764 = _763 * 0.4166666567325592f;
        //   float _765 = exp2(_764);
        //   float _766 = _765 * 1.0549999475479126f;
        //   float _767 = _766 + -0.054999999701976776f;
        //   _840 = _747;
        //   _841 = _759;
        //   _842 = _767;
        // } else {
        //   float _769 = _735 * 12.923210144042969f;
        //   _840 = _747;
        //   _841 = _759;
        //   _842 = _769;
        // }
        _840 = renodx::color::srgb::EncodeSafe(_725);
        _841 = renodx::color::srgb::EncodeSafe(_728);
        _842 = renodx::color::srgb::EncodeSafe(_731);

      } else {
        float _771 = saturate(_725);
        float _772 = saturate(_728);
        float _773 = saturate(_731);
        bool _774 = ((uint)(cb1_018w) == -2);
        if (!_774) {
          bool _776 = !(_771 >= 0.0030399328097701073f);
          if (!_776) {
            float _778 = abs(_771);
            float _779 = log2(_778);
            float _780 = _779 * 0.4166666567325592f;
            float _781 = exp2(_780);
            float _782 = _781 * 1.0549999475479126f;
            float _783 = _782 + -0.054999999701976776f;
            _787 = _783;
          } else {
            float _785 = _771 * 12.923210144042969f;
            _787 = _785;
          }
          bool _788 = !(_772 >= 0.0030399328097701073f);
          if (!_788) {
            float _790 = abs(_772);
            float _791 = log2(_790);
            float _792 = _791 * 0.4166666567325592f;
            float _793 = exp2(_792);
            float _794 = _793 * 1.0549999475479126f;
            float _795 = _794 + -0.054999999701976776f;
            _799 = _795;
          } else {
            float _797 = _772 * 12.923210144042969f;
            _799 = _797;
          }
          bool _800 = !(_773 >= 0.0030399328097701073f);
          if (!_800) {
            float _802 = abs(_773);
            float _803 = log2(_802);
            float _804 = _803 * 0.4166666567325592f;
            float _805 = exp2(_804);
            float _806 = _805 * 1.0549999475479126f;
            float _807 = _806 + -0.054999999701976776f;
            _811 = _787;
            _812 = _799;
            _813 = _807;
          } else {
            float _809 = _773 * 12.923210144042969f;
            _811 = _787;
            _812 = _799;
            _813 = _809;
          }
        } else {
          _811 = _771;
          _812 = _772;
          _813 = _773;
        }
        float _818 = abs(_811);
        float _819 = abs(_812);
        float _820 = abs(_813);
        float _821 = log2(_818);
        float _822 = log2(_819);
        float _823 = log2(_820);
        float _824 = _821 * cb2_000z;
        float _825 = _822 * cb2_000z;
        float _826 = _823 * cb2_000z;
        float _827 = exp2(_824);
        float _828 = exp2(_825);
        float _829 = exp2(_826);
        float _830 = _827 * cb2_000y;
        float _831 = _828 * cb2_000y;
        float _832 = _829 * cb2_000y;
        float _833 = _830 + cb2_000x;
        float _834 = _831 + cb2_000x;
        float _835 = _832 + cb2_000x;
        float _836 = saturate(_833);
        float _837 = saturate(_834);
        float _838 = saturate(_835);
        _840 = _836;
        _841 = _837;
        _842 = _838;
      }
      float _846 = cb2_023x * TEXCOORD0_centroid.x;
      float _847 = cb2_023y * TEXCOORD0_centroid.y;
      float _850 = _846 + cb2_023z;
      float _851 = _847 + cb2_023w;
      float4 _854 = t11.SampleLevel(s0_space2, float2(_850, _851), 0.0f);
      float _856 = _854.x + -0.5f;
      float _857 = _856 * cb2_022x;
      float _858 = _857 + 0.5f;
      float _859 = _858 * 2.0f;
      float _860 = _859 * _840;
      float _861 = _859 * _841;
      float _862 = _859 * _842;
      float _866 = float((uint)(cb2_019z));
      float _867 = float((uint)(cb2_019w));
      float _868 = _866 + SV_Position.x;
      float _869 = _867 + SV_Position.y;
      uint _870 = uint(_868);
      uint _871 = uint(_869);
      uint _874 = cb2_019x + -1u;
      uint _875 = cb2_019y + -1u;
      int _876 = _870 & _874;
      int _877 = _871 & _875;
      float4 _878 = t3.Load(int3(_876, _877, 0));
      float _882 = _878.x * 2.0f;
      float _883 = _878.y * 2.0f;
      float _884 = _878.z * 2.0f;
      float _885 = _882 + -1.0f;
      float _886 = _883 + -1.0f;
      float _887 = _884 + -1.0f;
      float _888 = _885 * _592;
      float _889 = _886 * _592;
      float _890 = _887 * _592;
      float _891 = _888 + _860;
      float _892 = _889 + _861;
      float _893 = _890 + _862;
      float _894 = dot(float3(_891, _892, _893), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _891;
      SV_Target.y = _892;
      SV_Target.z = _893;
      SV_Target.w = _894;
      SV_Target_1.x = _894;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}

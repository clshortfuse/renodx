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
  float cb2_009x : packoffset(c009.x);
  float cb2_009y : packoffset(c009.y);
  float cb2_009z : packoffset(c009.z);
  float cb2_010x : packoffset(c010.x);
  float cb2_010y : packoffset(c010.y);
  float cb2_010z : packoffset(c010.z);
  float cb2_011x : packoffset(c011.x);
  float cb2_011y : packoffset(c011.y);
  float cb2_011z : packoffset(c011.z);
  float cb2_011w : packoffset(c011.w);
  float cb2_012x : packoffset(c012.x);
  float cb2_012y : packoffset(c012.y);
  float cb2_012z : packoffset(c012.z);
  float cb2_012w : packoffset(c012.w);
  float cb2_013x : packoffset(c013.x);
  float cb2_013y : packoffset(c013.y);
  float cb2_013z : packoffset(c013.z);
  float cb2_013w : packoffset(c013.w);
  float cb2_014x : packoffset(c014.x);
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
  float4 _25 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);  // vignette related? affects inside of oval
  float _29 = max(_25.x, 0.0f);
  float _30 = max(_25.y, 0.0f);
  float _31 = max(_25.z, 0.0f);
  float _32 = min(_29, 65000.0f);
  float _33 = min(_30, 65000.0f);
  float _34 = min(_31, 65000.0f);
  float4 _35 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);  // vignette related? affects outside of oval
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
  float _65 = cb2_013x * TEXCOORD0_centroid.x;
  float _66 = cb2_013y * TEXCOORD0_centroid.y;
  float _69 = _65 + cb2_013z;
  float _70 = _66 + cb2_013w;
  float _73 = dot(float2(_69, _70), float2(_69, _70));
  float _74 = abs(_73);
  float _75 = log2(_74);
  float _76 = _75 * cb2_014x;
  float _77 = exp2(_76);
  float _78 = saturate(_77);
  float _82 = cb2_011x * TEXCOORD0_centroid.x;
  float _83 = cb2_011y * TEXCOORD0_centroid.y;
  float _86 = _82 + cb2_011z;
  float _87 = _83 + cb2_011w;
  float _88 = _86 * _78;
  float _89 = _87 * _78;
  float _90 = _88 + TEXCOORD0_centroid.x;
  float _91 = _89 + TEXCOORD0_centroid.y;
  float _95 = cb2_012x * TEXCOORD0_centroid.x;
  float _96 = cb2_012y * TEXCOORD0_centroid.y;
  float _99 = _95 + cb2_012z;
  float _100 = _96 + cb2_012w;
  float _101 = _99 * _78;
  float _102 = _100 * _78;
  float _103 = _101 + TEXCOORD0_centroid.x;
  float _104 = _102 + TEXCOORD0_centroid.y;
  float4 _105 = t1.SampleLevel(s2_space2, float2(_90, _91), 0.0f);  // vignette related? affects inside of oval
  float _109 = max(_105.x, 0.0f);
  float _110 = max(_105.y, 0.0f);
  float _111 = max(_105.z, 0.0f);
  float _112 = min(_109, 65000.0f);
  float _113 = min(_110, 65000.0f);
  float _114 = min(_111, 65000.0f);
  float4 _115 = t1.SampleLevel(s2_space2, float2(_103, _104), 0.0f);  // vignette related? affects inside of oval
  float _119 = max(_115.x, 0.0f);
  float _120 = max(_115.y, 0.0f);
  float _121 = max(_115.z, 0.0f);
  float _122 = min(_119, 65000.0f);
  float _123 = min(_120, 65000.0f);
  float _124 = min(_121, 65000.0f);
  float4 _125 = t4.SampleLevel(s2_space2, float2(_90, _91), 0.0f);  // vignette related? affects outside of oval
  float _129 = max(_125.x, 0.0f);
  float _130 = max(_125.y, 0.0f);
  float _131 = max(_125.z, 0.0f);
  float _132 = min(_129, 5000.0f);
  float _133 = min(_130, 5000.0f);
  float _134 = min(_131, 5000.0f);
  float4 _135 = t4.SampleLevel(s2_space2, float2(_103, _104), 0.0f);  // vignette related? affects outside of oval
  float _139 = max(_135.x, 0.0f);
  float _140 = max(_135.y, 0.0f);
  float _141 = max(_135.z, 0.0f);
  float _142 = min(_139, 5000.0f);
  float _143 = min(_140, 5000.0f);
  float _144 = min(_141, 5000.0f);
  float _149 = 1.0f - cb2_009x;
  float _150 = 1.0f - cb2_009y;
  float _151 = 1.0f - cb2_009z;
  float _156 = _149 - cb2_010x;
  float _157 = _150 - cb2_010y;
  float _158 = _151 - cb2_010z;
  float _159 = saturate(_156);
  float _160 = saturate(_157);
  float _161 = saturate(_158);
  float _162 = _159 * _32;
  float _163 = _160 * _33;
  float _164 = _161 * _34;
  float _165 = cb2_009x * _112;
  float _166 = cb2_009y * _113;
  float _167 = cb2_009z * _114;
  float _168 = _165 + _162;
  float _169 = _166 + _163;
  float _170 = _167 + _164;
  float _171 = cb2_010x * _122;
  float _172 = cb2_010y * _123;
  float _173 = cb2_010z * _124;
  float _174 = _168 + _171;
  float _175 = _169 + _172;
  float _176 = _170 + _173;
  float _177 = _159 * _44;
  float _178 = _160 * _45;
  float _179 = _161 * _46;
  float _180 = cb2_009x * _132;
  float _181 = cb2_009y * _133;
  float _182 = cb2_009z * _134;
  float _183 = cb2_010x * _142;
  float _184 = cb2_010y * _143;
  float _185 = cb2_010z * _144;
  float4 _186 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _190 = _177 - _174;
  float _191 = _190 + _180;
  float _192 = _191 + _183;
  float _193 = _178 - _175;
  float _194 = _193 + _181;
  float _195 = _194 + _184;
  float _196 = _179 - _176;
  float _197 = _196 + _182;
  float _198 = _197 + _185;
  float _199 = _192 * _61;
  float _200 = _195 * _61;
  float _201 = _198 * _61;
  float _202 = _199 + _174;
  float _203 = _200 + _175;
  float _204 = _201 + _176;
  float _205 = dot(float3(_202, _203, _204), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));

  float _209 = t0[0].SExposureData_020;  //  SExposureData _209 = t0.Load(0);  //  bin2hlsl:  asfloat(_8.Load(5u).x);

  float _211 = t0[0].SExposureData_004;  //  SExposureData _211 = t0.Load(0);  //  bin2hlsl:  asfloat(_8.Load(1u).x); // exposure

  float _213 = cb2_018x * 0.5f;
  float _214 = _213 * cb2_018y;
  float _215 = _211.x - _214;
  float _216 = cb2_018y * cb2_018x;
  float _217 = 1.0f / _216;
  float _218 = _215 * _217;
  float _219 = _205 / _209.x;
  float _220 = _219 * 5464.01611328125f;
  float _221 = _220 + 9.99999993922529e-09f;
  float _222 = log2(_221);
  float _223 = _222 - _215;
  float _224 = _223 * _217;
  float _225 = saturate(_224);
  float2 _226 = t7.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _225), 0.0f);
  float _229 = max(_226.y, 1.0000000116860974e-07f);
  float _230 = _226.x / _229;
  float _231 = _230 + _218;
  float _232 = _231 / _217;
  float _233 = _232 - _211.x;
  float _234 = -0.0f - _233;
  float _236 = _234 - cb2_027x;
  float _237 = max(0.0f, _236);
  float _240 = cb2_026z * _237;
  float _241 = _233 - cb2_027x;
  float _242 = max(0.0f, _241);
  float _244 = cb2_026w * _242;
  bool _245 = (_233 < 0.0f);
  float _246 = select(_245, _240, _244);
  float _247 = exp2(_246);
  float _248 = _247 * _202;
  float _249 = _247 * _203;
  float _250 = _247 * _204;
  float _255 = cb2_024y * _186.x;
  float _256 = cb2_024z * _186.y;
  float _257 = cb2_024w * _186.z;
  float _258 = _255 + _248;
  float _259 = _256 + _249;
  float _260 = _257 + _250;
  float _265 = _258 * cb2_025x;
  float _266 = _259 * cb2_025y;
  float _267 = _260 * cb2_025z;
  float _268 = dot(float3(_265, _266, _267), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _269 = t0[0].SExposureData_012;  //  SExposureData _269 = t0.Load(0);  // bin2hlsl: asfloat(_8.Load(3u).x)
  float _271 = _268 * 5464.01611328125f;
  float _272 = _271 * _269.x;
  float _273 = _272 + 9.99999993922529e-09f;
  float _274 = log2(_273);
  float _275 = _274 + 16.929765701293945f;
  float _276 = _275 * 0.05734497308731079f;
  float _277 = saturate(_276);
  float _278 = _277 * _277;
  float _279 = _277 * 2.0f;
  float _280 = 3.0f - _279;
  float _281 = _278 * _280;
  float _282 = _266 * 0.8450999855995178f;
  float _283 = _267 * 0.14589999616146088f;
  float _284 = _282 + _283;
  float _285 = _284 * 2.4890189170837402f;
  float _286 = _284 * 0.3754962384700775f;
  float _287 = _284 * 2.811495304107666f;
  float _288 = _284 * 5.519708156585693f;
  float _289 = _268 - _285;
  float _290 = _281 * _289;
  float _291 = _290 + _285;
  float _292 = _281 * 0.5f;
  float _293 = _292 + 0.5f;
  float _294 = _293 * _289;
  float _295 = _294 + _285;
  float _296 = _265 - _286;
  float _297 = _266 - _287;
  float _298 = _267 - _288;
  float _299 = _293 * _296;
  float _300 = _293 * _297;
  float _301 = _293 * _298;
  float _302 = _299 + _286;
  float _303 = _300 + _287;
  float _304 = _301 + _288;
  float _305 = 1.0f / _295;
  float _306 = _291 * _305;
  float _307 = _306 * _302;
  float _308 = _306 * _303;
  float _309 = _306 * _304;
  float _313 = cb2_020x * TEXCOORD0_centroid.x;
  float _314 = cb2_020y * TEXCOORD0_centroid.y;
  float _317 = _313 + cb2_020z;
  float _318 = _314 + cb2_020w;
  float _321 = dot(float2(_317, _318), float2(_317, _318));
  float _322 = 1.0f - _321;
  float _323 = saturate(_322);
  float _324 = log2(_323);
  float _325 = _324 * cb2_021w;
  float _326 = exp2(_325);
  float _330 = _307 - cb2_021x;
  float _331 = _308 - cb2_021y;
  float _332 = _309 - cb2_021z;
  float _333 = _330 * _326;
  float _334 = _331 * _326;
  float _335 = _332 * _326;
  float _336 = _333 + cb2_021x;
  float _337 = _334 + cb2_021y;
  float _338 = _335 + cb2_021z;
  float _339 = t0[0].SExposureData_000;  // SExposureData _339 = t0.Load(0);  //  bin2hlsl: asfloat(_8.Load(0u).x)
  float _341 = max(_209.x, 0.0010000000474974513f);
  float _342 = 1.0f / _341;
  float _343 = _342 * _339.x;
  bool _346 = ((uint)(cb2_069y) == 0);
  float _352;
  float _353;
  float _354;
  float _408;
  float _409;
  float _410;
  float _441;
  float _442;
  float _443;
  float _544;
  float _545;
  float _546;
  float _571;
  float _583;
  float _611;
  float _623;
  float _635;
  float _636;
  float _637;
  float _664;
  float _665;
  float _666;
  if (!_346) {
    float _348 = _343 * _336;
    float _349 = _343 * _337;
    float _350 = _343 * _338;
    _352 = _348;
    _353 = _349;
    _354 = _350;
  } else {
    _352 = _336;
    _353 = _337;
    _354 = _338;
  }

  // BT.709 -> AP1
  float _355 = _352 * 0.6130970120429993f;
  float _356 = mad(0.33952298760414124f, _353, _355);
  float _357 = mad(0.04737899824976921f, _354, _356);
  float _358 = _352 * 0.07019399851560593f;
  float _359 = mad(0.9163540005683899f, _353, _358);
  float _360 = mad(0.013451999984681606f, _354, _359);
  float _361 = _352 * 0.02061600051820278f;
  float _362 = mad(0.10956999659538269f, _353, _361);
  float _363 = mad(0.8698149919509888f, _354, _362);
  float _364 = log2(_357);
  float _365 = log2(_360);
  float _366 = log2(_363);
  float _367 = _364 * 0.04211956635117531f;
  float _368 = _365 * 0.04211956635117531f;
  float _369 = _366 * 0.04211956635117531f;
  float _370 = _367 + 0.6252607107162476f;
  float _371 = _368 + 0.6252607107162476f;
  float _372 = _369 + 0.6252607107162476f;
  float4 _373 = t6.SampleLevel(s2_space2, float3(_370, _371, _372), 0.0f);  // tonemapping LUT
  bool _379 = ((int)(uint)(cb1_018w) > (int)-1);  // if hdr is enabled
  if (_379 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _383 = cb2_017x * _373.x;
    float _384 = cb2_017x * _373.y;
    float _385 = cb2_017x * _373.z;
    float _387 = _383 + cb2_017y;
    float _388 = _384 + cb2_017y;
    float _389 = _385 + cb2_017y;
    float _390 = exp2(_387);
    float _391 = exp2(_388);
    float _392 = exp2(_389);
    float _393 = _390 + 1.0f;
    float _394 = _391 + 1.0f;
    float _395 = _392 + 1.0f;
    float _396 = 1.0f / _393;
    float _397 = 1.0f / _394;
    float _398 = 1.0f / _395;
    float _400 = cb2_017z * _396;
    float _401 = cb2_017z * _397;
    float _402 = cb2_017z * _398;
    float _404 = _400 + cb2_017w;
    float _405 = _401 + cb2_017w;
    float _406 = _402 + cb2_017w;
    _408 = _404;
    _409 = _405;
    _410 = _406;
  } else {
    _408 = _373.x;
    _409 = _373.y;
    _410 = _373.z;
  }
  // decode LUT
  float _411 = _408 * 23.0f;
  float _412 = _411 + -14.473931312561035f;
  float _413 = exp2(_412);
  float _414 = _409 * 23.0f;
  float _415 = _414 + -14.473931312561035f;
  float _416 = exp2(_415);
  float _417 = _410 * 23.0f;
  float _418 = _417 + -14.473931312561035f;
  float _419 = exp2(_418);

  float _426 = cb2_016x - _413;
  float _427 = cb2_016y - _416;
  float _428 = cb2_016z - _419;
  float _429 = _426 * cb2_016w;
  float _430 = _427 * cb2_016w;
  float _431 = _428 * cb2_016w;
  float _432 = _429 + _413;
  float _433 = _430 + _416;
  float _434 = _431 + _419;

  if (_379 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _437 = cb2_024x * _432;
    float _438 = cb2_024x * _433;
    float _439 = cb2_024x * _434;
    _441 = _437;
    _442 = _438;
    _443 = _439;
  } else {
    _441 = _432;
    _442 = _433;
    _443 = _434;
  }
  float _444 = _441 * 0.9708889722824097f;
  float _445 = mad(0.026962999254465103f, _442, _444);
  float _446 = mad(0.002148000057786703f, _443, _445);
  float _447 = _441 * 0.01088900025933981f;
  float _448 = mad(0.9869629740715027f, _442, _447);
  float _449 = mad(0.002148000057786703f, _443, _448);
  float _450 = mad(0.026962999254465103f, _442, _447);
  float _451 = mad(0.9621480107307434f, _443, _450);
  if (_379) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      float _456 = cb1_018y * 0.10000000149011612f;
      float _457 = log2(cb1_018z);
      float _458 = _457 + -13.287712097167969f;
      float _459 = _458 * 1.4929734468460083f;
      float _460 = _459 + 18.0f;
      float _461 = exp2(_460);
      float _462 = _461 * 0.18000000715255737f;
      float _463 = abs(_462);
      float _464 = log2(_463);
      float _465 = _464 * 1.5f;
      float _466 = exp2(_465);
      float _467 = _466 * _456;
      float _468 = _467 / cb1_018z;
      float _469 = _468 + -0.07636754959821701f;
      float _470 = _464 * 1.2750000953674316f;
      float _471 = exp2(_470);
      float _472 = _471 * 0.07636754959821701f;
      float _473 = cb1_018y * 0.011232397519052029f;
      float _474 = _473 * _466;
      float _475 = _474 / cb1_018z;
      float _476 = _472 - _475;
      float _477 = _471 + -0.11232396960258484f;
      float _478 = _477 * _456;
      float _479 = _478 / cb1_018z;
      float _480 = _479 * cb1_018z;
      float _481 = abs(_446);
      float _482 = abs(_449);
      float _483 = abs(_451);
      float _484 = log2(_481);
      float _485 = log2(_482);
      float _486 = log2(_483);
      float _487 = _484 * 1.5f;
      float _488 = _485 * 1.5f;
      float _489 = _486 * 1.5f;
      float _490 = exp2(_487);
      float _491 = exp2(_488);
      float _492 = exp2(_489);
      float _493 = _490 * _480;
      float _494 = _491 * _480;
      float _495 = _492 * _480;
      float _496 = _484 * 1.2750000953674316f;
      float _497 = _485 * 1.2750000953674316f;
      float _498 = _486 * 1.2750000953674316f;
      float _499 = exp2(_496);
      float _500 = exp2(_497);
      float _501 = exp2(_498);
      float _502 = _499 * _469;
      float _503 = _500 * _469;
      float _504 = _501 * _469;
      float _505 = _502 + _476;
      float _506 = _503 + _476;
      float _507 = _504 + _476;
      float _508 = _493 / _505;
      float _509 = _494 / _506;
      float _510 = _495 / _507;
      float _511 = _508 * 9.999999747378752e-05f;
      float _512 = _509 * 9.999999747378752e-05f;
      float _513 = _510 * 9.999999747378752e-05f;
      float _514 = 5000.0f / cb1_018y;
      float _515 = _511 * _514;
      float _516 = _512 * _514;
      float _517 = _513 * _514;    
      _544 = _515;
      _545 = _516;
      _546 = _517;
    } else {

      float3 tonemapped = ApplyCustomToneMap(float3(_446, _449, _451));
      _544 = tonemapped.x, _545 = tonemapped.y, _546 = tonemapped.z;
    }

  } else {
    float _519 = _446 + 0.020616600289940834f;
    float _520 = _449 + 0.020616600289940834f;
    float _521 = _451 + 0.020616600289940834f;
    float _522 = _519 * _446;
    float _523 = _520 * _449;
    float _524 = _521 * _451;
    float _525 = _522 + -7.456949970219284e-05f;
    float _526 = _523 + -7.456949970219284e-05f;
    float _527 = _524 + -7.456949970219284e-05f;
    float _528 = _446 * 0.9837960004806519f;
    float _529 = _449 * 0.9837960004806519f;
    float _530 = _451 * 0.9837960004806519f;
    float _531 = _528 + 0.4336790144443512f;
    float _532 = _529 + 0.4336790144443512f;
    float _533 = _530 + 0.4336790144443512f;
    float _534 = _531 * _446;
    float _535 = _532 * _449;
    float _536 = _533 * _451;
    float _537 = _534 + 0.24617899954319f;
    float _538 = _535 + 0.24617899954319f;
    float _539 = _536 + 0.24617899954319f;
    float _540 = _525 / _537;
    float _541 = _526 / _538;
    float _542 = _527 / _539;
    _544 = _540;
    _545 = _541;
    _546 = _542;
  }
  float _547 = _544 * 1.6047500371932983f;
  float _548 = mad(-0.5310800075531006f, _545, _547);
  float _549 = mad(-0.07366999983787537f, _546, _548);
  float _550 = _544 * -0.10208000242710114f;
  float _551 = mad(1.1081299781799316f, _545, _550);
  float _552 = mad(-0.006049999967217445f, _546, _551);
  float _553 = _544 * -0.0032599999103695154f;
  float _554 = mad(-0.07275000214576721f, _545, _553);
  float _555 = mad(1.0760200023651123f, _546, _554);
  if (_379) {
    // float _557 = max(_549, 0.0f);
    // float _558 = max(_552, 0.0f);
    // float _559 = max(_555, 0.0f);
    // bool _560 = !(_557 >= 0.0030399328097701073f);
    // if (!_560) {
    //   float _562 = abs(_557);
    //   float _563 = log2(_562);
    //   float _564 = _563 * 0.4166666567325592f;
    //   float _565 = exp2(_564);
    //   float _566 = _565 * 1.0549999475479126f;
    //   float _567 = _566 + -0.054999999701976776f;
    //   _571 = _567;
    // } else {
    //   float _569 = _557 * 12.923210144042969f;
    //   _571 = _569;
    // }
    // bool _572 = !(_558 >= 0.0030399328097701073f);
    // if (!_572) {
    //   float _574 = abs(_558);
    //   float _575 = log2(_574);
    //   float _576 = _575 * 0.4166666567325592f;
    //   float _577 = exp2(_576);
    //   float _578 = _577 * 1.0549999475479126f;
    //   float _579 = _578 + -0.054999999701976776f;
    //   _583 = _579;
    // } else {
    //   float _581 = _558 * 12.923210144042969f;
    //   _583 = _581;
    // }
    // bool _584 = !(_559 >= 0.0030399328097701073f);
    // if (!_584) {
    //   float _586 = abs(_559);
    //   float _587 = log2(_586);
    //   float _588 = _587 * 0.4166666567325592f;
    //   float _589 = exp2(_588);
    //   float _590 = _589 * 1.0549999475479126f;
    //   float _591 = _590 + -0.054999999701976776f;
    //   _664 = _571;
    //   _665 = _583;
    //   _666 = _591;
    // } else {
    //   float _593 = _559 * 12.923210144042969f;
    //   _664 = _571;
    //   _665 = _583;
    //   _666 = _593;
    // }
    _664 = renodx::color::srgb::EncodeSafe(_549);
    _665 = renodx::color::srgb::EncodeSafe(_552);
    _666 = renodx::color::srgb::EncodeSafe(_555);
  } else {
    float _595 = saturate(_549);
    float _596 = saturate(_552);
    float _597 = saturate(_555);
    bool _598 = ((uint)(cb1_018w) == -2);
    if (!_598) {
      bool _600 = !(_595 >= 0.0030399328097701073f);
      if (!_600) {
        float _602 = abs(_595);
        float _603 = log2(_602);
        float _604 = _603 * 0.4166666567325592f;
        float _605 = exp2(_604);
        float _606 = _605 * 1.0549999475479126f;
        float _607 = _606 + -0.054999999701976776f;
        _611 = _607;
      } else {
        float _609 = _595 * 12.923210144042969f;
        _611 = _609;
      }
      bool _612 = !(_596 >= 0.0030399328097701073f);
      if (!_612) {
        float _614 = abs(_596);
        float _615 = log2(_614);
        float _616 = _615 * 0.4166666567325592f;
        float _617 = exp2(_616);
        float _618 = _617 * 1.0549999475479126f;
        float _619 = _618 + -0.054999999701976776f;
        _623 = _619;
      } else {
        float _621 = _596 * 12.923210144042969f;
        _623 = _621;
      }
      bool _624 = !(_597 >= 0.0030399328097701073f);
      if (!_624) {
        float _626 = abs(_597);
        float _627 = log2(_626);
        float _628 = _627 * 0.4166666567325592f;
        float _629 = exp2(_628);
        float _630 = _629 * 1.0549999475479126f;
        float _631 = _630 + -0.054999999701976776f;
        _635 = _611;
        _636 = _623;
        _637 = _631;
      } else {
        float _633 = _597 * 12.923210144042969f;
        _635 = _611;
        _636 = _623;
        _637 = _633;
      }
    } else {
      _635 = _595;
      _636 = _596;
      _637 = _597;
    }
    float _642 = abs(_635);
    float _643 = abs(_636);
    float _644 = abs(_637);
    float _645 = log2(_642);
    float _646 = log2(_643);
    float _647 = log2(_644);
    float _648 = _645 * cb2_000z;
    float _649 = _646 * cb2_000z;
    float _650 = _647 * cb2_000z;
    float _651 = exp2(_648);
    float _652 = exp2(_649);
    float _653 = exp2(_650);
    float _654 = _651 * cb2_000y;
    float _655 = _652 * cb2_000y;
    float _656 = _653 * cb2_000y;
    float _657 = _654 + cb2_000x;
    float _658 = _655 + cb2_000x;
    float _659 = _656 + cb2_000x;
    float _660 = saturate(_657);
    float _661 = saturate(_658);
    float _662 = saturate(_659);
    _664 = _660;
    _665 = _661;
    _666 = _662;
  }
  float _670 = cb2_023x * TEXCOORD0_centroid.x;
  float _671 = cb2_023y * TEXCOORD0_centroid.y;
  float _674 = _670 + cb2_023z;
  float _675 = _671 + cb2_023w;
  float4 _678 = t8.SampleLevel(s0_space2, float2(_674, _675), 0.0f);
  float _680 = _678.x + -0.5f;
  float _681 = _680 * cb2_022x;
  float _682 = _681 + 0.5f;
  float _683 = _682 * 2.0f;
  float _684 = _683 * _664;
  float _685 = _683 * _665;
  float _686 = _683 * _666;
  float _690 = float((uint)(cb2_019z));
  float _691 = float((uint)(cb2_019w));
  float _692 = _690 + SV_Position.x;
  float _693 = _691 + SV_Position.y;
  uint _694 = uint(_692);
  uint _695 = uint(_693);
  uint _698 = cb2_019x + -1u;
  uint _699 = cb2_019y + -1u;
  int _700 = _694 & _698;
  int _701 = _695 & _699;

  // noise
  float4 _702 = t3.Load(int3(_700, _701, 0));
  float _706 = _702.x * 2.0f;
  float _707 = _702.y * 2.0f;
  float _708 = _702.z * 2.0f;
  float _709 = _706 + -1.0f;
  float _710 = _707 + -1.0f;
  float _711 = _708 + -1.0f;
  float _712 = _709 * cb2_025w;
  float _713 = _710 * cb2_025w;
  float _714 = _711 * cb2_025w;
  float _715 = _712 + _684;
  float _716 = _713 + _685;
  float _717 = _714 + _686;

  float _718 = dot(float3(_715, _716, _717), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  
  SV_Target.x = _715;
  SV_Target.y = _716;
  SV_Target.z = _717;
  SV_Target.w = _718;
  SV_Target_1.x = _718;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

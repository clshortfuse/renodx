#include "../tonemap/tonemap.hlsli"

// rl_default_primitive_bink_hdr_gradient: HDR10 Bink video (PQ decode -> AP1) tone mapped with the vanilla ACES chain (t40/t13, space15).
// The RenoDX path replaces the sRGB-encoded result after the discard, before the vanilla tint and alpha.

Texture2D<float4> t29_space15 : register(t29, space15);

Texture3D<float4> t40_space15 : register(t40, space15);

Texture2D<float4> t13_space15 : register(t13, space15);

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

cbuffer cb0_space5 : register(b0, space5) {
  float cb0_space5_008x : packoffset(c008.x);
  float cb0_space5_008y : packoffset(c008.y);
  float cb0_space5_008z : packoffset(c008.z);
};

cbuffer cb1_space9 : register(b1, space9) {
  float cb1_space9_034x : packoffset(c034.x);
  float cb1_space9_035z : packoffset(c035.z);
};

cbuffer cb3_space9 : register(b3, space9) {
  float cb3_space9_036y : packoffset(c036.y);
  float cb3_space9_036w : packoffset(c036.w);
  float cb3_space9_037x : packoffset(c037.x);
  float cb3_space9_037y : packoffset(c037.y);
  float cb3_space9_038x : packoffset(c038.x);
  float cb3_space9_038y : packoffset(c038.y);
  float cb3_space9_038z : packoffset(c038.z);
  float cb3_space9_038w : packoffset(c038.w);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s2_space1 : register(s2, space1);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
  float4 SV_Target_2 : SV_Target2;
  float4 SV_Target_3 : SV_Target3;
  float4 SV_Target_4 : SV_Target4;
};

OutputSignature main(
    noperspective float4 SV_Position : SV_Position,
    linear float4 ATTRIBUTE_POSITION_INTERPOLATED : ATTRIBUTE_POSITION_INTERPOLATED,
    linear float2 UVS_PACKED_ATTR : UVS_PACKED_ATTR,
    linear float ATTRIBUTE_REFLECTION_DIST : ATTRIBUTE_REFLECTION_DIST,
    linear float ATTRIBUTE_OBJECT_ID : ATTRIBUTE_OBJECT_ID,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    linear float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    linear float ATTRIBUTE_LIGHT_MASK : ATTRIBUTE_LIGHT_MASK,
    linear float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    linear float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    linear float3 ATTRIBUTE_POSITION_VIEW : ATTRIBUTE_POSITION_VIEW,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  float4 SV_Target_3;
  float4 SV_Target_4;
  bool _14 = (SV_IsFrontFace != 0);
  bool _33 = (ATTRIBUTE_REFLECTION_DIST < 0.0f);
  if (_33) discard;
  float _34 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _35 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _40 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _41 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _42 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _43 = select(_14, ATTRIBUTE_NORMAL.x, _40);
  float _44 = select(_14, ATTRIBUTE_NORMAL.y, _41);
  float _45 = select(_14, ATTRIBUTE_NORMAL.z, _42);
  float _46 = _34 + 1.0f;
  float _47 = 1.0f - _35;
  float _48 = _46 * 0.5f;
  float _49 = _47 * 0.5f;
  float4 _52 = t29_space15.SampleBias(s0_space1, float2(_48, _49), cb1_space9_035z, int2(0, 0));
  float _54 = _52.x * ATTRIBUTE_VCOLOR.w;
  float _55 = max(_54, 0.0f);
  float _56 = min(1.0f, _55);
  float4 _61 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _63 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _65 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _67 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _71 = cb3_space9_038x * _63.x;
  float _73 = _71 + cb3_space9_038z;
  float _75 = cb3_space9_038y * _65.x;
  float _77 = _75 + cb3_space9_038w;
  float _78 = _67.x + _61.x;
  float _81 = cb3_space9_037x * _78;
  float _82 = _73 * 0.008609036915004253f;
  float _83 = _73 * 0.5600313544273376f;
  float _84 = _81 + _82;
  float _85 = _81 - _82;
  float _86 = _83 + _81;
  float _87 = _77 * 0.11102962493896484f;
  float _88 = _77 * 0.3206271827220917f;
  float _89 = _84 + _87;
  float _90 = _85 - _87;
  float _91 = _86 - _88;
  float _92 = max(_89, 0.0f);
  float _93 = max(_90, 0.0f);
  float _94 = max(_91, 0.0f);
  float _95 = log2(_92);
  float _96 = log2(_93);
  float _97 = log2(_94);
  float _98 = _95 * 0.012683313339948654f;
  float _99 = _96 * 0.012683313339948654f;
  float _100 = _97 * 0.012683313339948654f;
  float _101 = exp2(_98);
  float _102 = exp2(_99);
  float _103 = exp2(_100);
  float _104 = _101 + -0.8359375f;
  float _105 = _102 + -0.8359375f;
  float _106 = _103 + -0.8359375f;
  float _107 = max(0.0f, _104);
  float _108 = max(0.0f, _105);
  float _109 = max(0.0f, _106);
  float _110 = _101 * 18.6875f;
  float _111 = _102 * 18.6875f;
  float _112 = _103 * 18.6875f;
  float _113 = 18.8515625f - _110;
  float _114 = 18.8515625f - _111;
  float _115 = 18.8515625f - _112;
  float _116 = _107 / _113;
  float _117 = _108 / _114;
  float _118 = _109 / _115;
  float _119 = abs(_116);
  float _120 = abs(_117);
  float _121 = abs(_118);
  float _122 = log2(_119);
  float _123 = log2(_120);
  float _124 = log2(_121);
  float _125 = _122 * 6.277394771575928f;
  float _126 = _123 * 6.277394771575928f;
  float _127 = _124 * 6.277394771575928f;
  float _128 = exp2(_125);
  float _129 = exp2(_126);
  float _130 = exp2(_127);
  float _131 = _128 * 3.4366066455841064f;
  float _132 = _128 * 0.791329562664032f;
  float _133 = _129 * 2.5064520835876465f;
  float _134 = _129 * 1.9836004972457886f;
  float _135 = _129 * 0.09891371428966522f;
  float _136 = _131 - _133;
  float _137 = _134 - _132;
  float _138 = _128 * -0.02594989910721779f;
  float _139 = _138 - _135;
  float _140 = _130 * 0.06984542310237885f;
  float _141 = _130 * 0.192270889878273f;
  float _142 = _130 * 1.124863624572754f;
  float _143 = _136 + _140;
  float _144 = _137 - _141;
  float _145 = _139 + _142;
  float _147 = cb3_space9_037y * 368.6400146484375f;
  float _148 = _147 * _143;
  float _149 = _147 * _144;
  float _150 = _147 * _145;
  float _151 = max(_148, 9.999999747378752e-05f);
  float _152 = max(_149, 9.999999747378752e-05f);
  float _153 = max(_150, 9.999999747378752e-05f);
  float _157 = log2(_151);
  float _158 = log2(_152);
  float _159 = log2(_153);
  float _160 = _157 + 9.720000267028809f;
  float _161 = _158 + 9.720000267028809f;
  float _162 = _159 + 9.720000267028809f;
  float _163 = _160 * 0.03030303120613098f;
  float _164 = _161 * 0.03030303120613098f;
  float _165 = _162 * 0.03030303120613098f;
  float _166 = _163 + 0.23496760427951813f;
  float _167 = _164 + 0.23496760427951813f;
  float _168 = _165 + 0.23496760427951813f;
  uint3 _169;
  t40_space15.GetDimensions(_169.x, _169.y, _169.z);
  uint2 _173;
  t13_space15.GetDimensions(_173.x, _173.y);
  uint _175 = _169.x + -1u;
  uint _176 = _169.y + -1u;
  uint _177 = _169.z + -1u;
  float _178 = float((uint)_175);
  float _179 = float((uint)_176);
  float _180 = float((uint)_177);
  float _181 = float((uint)_169.x);
  float _182 = float((uint)_169.y);
  float _183 = float((uint)_169.z);
  float _184 = _178 / _181;
  float _185 = _179 / _182;
  float _186 = _180 / _183;
  float _187 = 0.5f / _181;
  float _188 = 0.5f / _182;
  float _189 = 0.5f / _183;
  float _190 = _184 * _166;
  float _191 = _185 * _167;
  float _192 = _186 * _168;
  float _193 = _187 + _190;
  float _194 = _188 + _191;
  float _195 = _189 + _192;
  float4 _196 = t40_space15.SampleLevel(s2_space1, float3(_193, _194, _195), 0.0f);
  float _199 = exp2(_157);
  float _200 = exp2(_158);
  float _201 = exp2(_159);
  float _202 = _199 * 0.6954522132873535f;
  float _203 = mad(0.14067870378494263f, _200, _202);
  float _204 = mad(0.16386906802654266f, _201, _203);
  float _205 = _199 * 0.044794563204050064f;
  float _206 = mad(0.8596711158752441f, _200, _205);
  float _207 = mad(0.0955343171954155f, _201, _206);
  float _208 = _199 * -0.005525882821530104f;
  float _209 = mad(0.004025210160762072f, _200, _208);
  float _210 = mad(1.0015007257461548f, _201, _209);
  float _211 = _196.x + 1.0f;
  float _212 = _204 * _211;
  float _213 = _207 * _211;
  float _214 = _210 * _211;
  float _215 = _212 + _196.y;
  float _216 = max(_215, 0.0f);
  float _217 = max(_213, 0.0f);
  float _218 = max(_214, 0.0f);
  float _219 = min(_216, 65536.0f);
  float _220 = min(_217, 65536.0f);
  float _221 = min(_218, 65536.0f);
  float _222 = _219 * 1.4514392614364624f;
  float _223 = mad(-0.2365107536315918f, _220, _222);
  float _224 = mad(-0.21492856740951538f, _221, _223);
  float _225 = _219 * -0.07655377686023712f;
  float _226 = mad(1.17622971534729f, _220, _225);
  float _227 = mad(-0.09967592358589172f, _221, _226);
  float _228 = _219 * 0.008316148072481155f;
  float _229 = mad(-0.006032449658960104f, _220, _228);
  float _230 = mad(0.9977163076400757f, _221, _229);
  float _231 = max(_224, 0.0f);
  float _232 = max(_227, 0.0f);
  float _233 = max(_230, 0.0f);
  float _234 = min(_231, 65504.0f);
  float _235 = min(_232, 65504.0f);
  float _236 = min(_233, 65504.0f);
  float _237 = _234 * 0.970889151096344f;
  float _238 = mad(0.026963284239172935f, _235, _237);
  float _239 = mad(0.0021475818939507008f, _236, _238);
  float _240 = _234 * 0.010889154858887196f;
  float _241 = mad(0.9869632720947266f, _235, _240);
  float _242 = mad(0.0021475818939507008f, _236, _241);
  float _243 = mad(0.026963284239172935f, _235, _240);
  float _244 = mad(0.9621475338935852f, _236, _243);
  float _245 = log2(_239);
  float _246 = log2(_242);
  float _247 = log2(_244);
  float _248 = _245 + 17.47393035888672f;
  float _249 = _246 + 17.47393035888672f;
  float _250 = _247 + 17.47393035888672f;
  float _251 = _248 * 0.03030303120613098f;
  float _252 = _249 * 0.03030303120613098f;
  float _253 = _250 * 0.03030303120613098f;
  uint _254 = _173.x + -1u;
  float _255 = float((uint)_254);
  float _256 = float((uint)_173.x);
  float _257 = _255 / _256;
  float _258 = 0.5f / _256;
  float _259 = _251 * _257;
  float _260 = _252 * _257;
  float _261 = _253 * _257;
  float _262 = _259 + _258;
  float _263 = _260 + _258;
  float _264 = _261 + _258;
  float4 _265 = t13_space15.SampleLevel(s2_space1, float2(_262, 0.5f), 0.0f);
  float4 _267 = t13_space15.SampleLevel(s2_space1, float2(_263, 0.5f), 0.0f);
  float4 _269 = t13_space15.SampleLevel(s2_space1, float2(_264, 0.5f), 0.0f);
  float _271 = _265.x * 3.321928024291992f;
  float _272 = _267.x * 3.321928024291992f;
  float _273 = _269.x * 3.321928024291992f;
  float _274 = exp2(_271);
  float _275 = exp2(_272);
  float _276 = exp2(_273);
  float _277 = _274 / cb3_space9_036w;
  float _278 = _275 / cb3_space9_036w;
  float _279 = _276 / cb3_space9_036w;
  bool _280 = (cb3_space9_036y < 500.0f);
  float _318;
  float _319;
  float _320;
  float _370;
  float _378;
  float _386;
  if (_280) {
    float _282 = _277 * 0.6624541878700256f;
    float _283 = mad(0.13400420546531677f, _278, _282);
    float _284 = mad(0.15618768334388733f, _279, _283);
    float _285 = _277 * 0.2722287178039551f;
    float _286 = mad(0.6740817427635193f, _278, _285);
    float _287 = mad(0.053689517080783844f, _279, _286);
    float _288 = _277 * -0.005574649665504694f;
    float _289 = mad(0.00406073359772563f, _278, _288);
    float _290 = mad(1.0103391408920288f, _279, _289);
    float _291 = _287 + _284;
    float _292 = _291 + _290;
    bool _293 = (_292 == 0.0f);
    float _294 = select(_293, 1.000000013351432e-10f, _292);
    float _295 = _284 / _294;
    float _296 = _287 / _294;
    float _297 = max(_287, 0.0f);
    float _298 = log2(_297);
    float _299 = _298 * 0.9811000227928162f;
    float _300 = exp2(_299);
    float _301 = _300 * _295;
    float _302 = max(_296, 1.000000013351432e-10f);
    float _303 = _301 / _302;
    float _304 = 1.0f - _295;
    float _305 = _304 - _296;
    float _306 = _300 * _305;
    float _307 = _306 / _302;
    float _308 = _303 * 1.6410233974456787f;
    float _309 = mad(-0.32480329275131226f, _300, _308);
    float _310 = mad(-0.23642469942569733f, _307, _309);
    float _311 = _303 * -0.663662850856781f;
    float _312 = mad(1.6153316497802734f, _300, _311);
    float _313 = mad(0.016756348311901093f, _307, _312);
    float _314 = _303 * 0.011721894145011902f;
    float _315 = mad(-0.008284442126750946f, _300, _314);
    float _316 = mad(0.9883948564529419f, _307, _315);
    _318 = _310;
    _319 = _313;
    _320 = _316;
  } else {
    _318 = _277;
    _319 = _278;
    _320 = _279;
  }
  float _321 = _318 * 1.6047539710998535f;
  float _322 = mad(-0.5310794711112976f, _319, _321);
  float _323 = mad(-0.07367203384637833f, _320, _322);
  float _324 = _318 * -0.10208318382501602f;
  float _325 = mad(1.108132243156433f, _319, _324);
  float _326 = mad(-0.006051875650882721f, _320, _325);
  float _327 = _318 * -0.0032670421060174704f;
  float _328 = mad(-0.07275524735450745f, _319, _327);
  float _329 = mad(1.0760219097137451f, _320, _328);
  float _330 = max(_323, 0.0f);
  float _331 = max(_326, 0.0f);
  float _332 = max(_329, 0.0f);
  float _333 = _330 * ATTRIBUTE_VCOLOR.x;
  float _334 = _331 * ATTRIBUTE_VCOLOR.y;
  float _335 = _332 * ATTRIBUTE_VCOLOR.z;
  float _336 = abs(_333);
  float _337 = abs(_334);
  float _338 = abs(_335);
  float _339 = log2(_336);
  float _340 = log2(_337);
  float _341 = log2(_338);
  float _342 = _339 * 0.4166666567325592f;
  float _343 = _340 * 0.4166666567325592f;
  float _344 = _341 * 0.4166666567325592f;
  float _345 = exp2(_342);
  float _346 = exp2(_343);
  float _347 = exp2(_344);
  bool _348 = isfinite(_345);
  bool _349 = isfinite(_346);
  bool _350 = isfinite(_347);
  float _351 = _345 * 1.0549999475479126f;
  float _352 = _346 * 1.0549999475479126f;
  float _353 = _347 * 1.0549999475479126f;
  float _354 = _351 + -0.054999999701976776f;
  float _355 = select(_348, _354, 0.9999999403953552f);
  float _356 = _352 + -0.054999999701976776f;
  float _357 = select(_349, _356, 0.9999999403953552f);
  float _358 = _353 + -0.054999999701976776f;
  float _359 = select(_350, _358, 0.9999999403953552f);
  float _360 = _334 * 12.920000076293945f;
  float _361 = _335 * 12.920000076293945f;
  bool _362 = (_333 > 0.0031308000907301903f);
  if (!_362) {
    float _364 = _333 * 12.920000076293945f;
    bool _365 = (_333 < 0.0031308000907301903f);
    if (!_365) {
      bool _367 = (_333 == 0.0031308000907301903f);
      if (_367) {
        _370 = _355;
      } else {
        _370 = 0.0f;
      }
    } else {
      _370 = _364;
    }
  } else {
    _370 = _355;
  }
  bool _371 = (_334 > 0.0031308000907301903f);
  if (!_371) {
    bool _373 = (_334 < 0.0031308000907301903f);
    if (!_373) {
      bool _375 = (_334 == 0.0031308000907301903f);
      if (_375) {
        _378 = _357;
      } else {
        _378 = 0.0f;
      }
    } else {
      _378 = _360;
    }
  } else {
    _378 = _357;
  }
  bool _379 = (_335 > 0.0031308000907301903f);
  if (!_379) {
    bool _381 = (_335 < 0.0031308000907301903f);
    if (!_381) {
      bool _383 = (_335 == 0.0031308000907301903f);
      if (_383) {
        _386 = _359;
      } else {
        _386 = 0.0f;
      }
    } else {
      _386 = _361;
    }
  } else {
    _386 = _359;
  }
  float _387 = dot(float3(_43, _44, _45), float3(_43, _44, _45));
  float _388 = rsqrt(_387);
  float _389 = _388 * _43;
  float _390 = _388 * _44;
  float _391 = _388 * _45;
  float _392 = _56 - cb1_space9_034x;
  bool _393 = (_392 < 0.0f);
  if (_393) discard;
  float _394 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _395 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _396 = _395 + _394;
  float _397 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _398 = _396 + _397;
  float _399 = sqrt(_398);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_160, _161, _162), 1.f);
    _370 = video.r;
    _378 = video.g;
    _386 = video.b;
  }
  float _400 = _370 * cb0_space5_008x;
  float _401 = _378 * cb0_space5_008y;
  float _402 = _386 * cb0_space5_008z;
  float _403 = _391 + -1.0f;
  float _404 = dot(float3(_389, _390, _403), float3(_389, _390, _403));
  float _405 = rsqrt(_404);
  float _406 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _407 = _406 + 0.5f;
  uint _408 = uint(_407);
  uint _409 = _408 % 13;
  float _410 = float((uint)_409);
  float _411 = _410 * 0.03846153989434242f;
  float _412 = _411 + 0.5f;
  bool _413 = (_400 < 0.0f);
  bool _414 = (_401 < 0.0f);
  bool _415 = (_402 < 0.0f);
  float _416 = select(_413, -0.0f, _400);
  float _417 = select(_414, -0.0f, _401);
  float _418 = select(_415, -0.0f, _402);
  float _419 = _389 * 0.5f;
  float _420 = _419 * _405;
  float _421 = _390 * 0.5f;
  float _422 = _421 * _405;
  float _423 = _420 + 0.5f;
  float _424 = _422 + 0.5f;
  SV_Target.x = _423;
  SV_Target.y = _424;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _416;
  SV_Target_2.y = _417;
  SV_Target_2.z = _418;
  SV_Target_2.w = _399;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _412;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}

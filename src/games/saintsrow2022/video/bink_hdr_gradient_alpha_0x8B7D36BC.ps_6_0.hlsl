#include "../tonemap/tonemap.hlsli"

// rl_default_primitive_bink_hdr_gradient_alpha: HDR10 Bink video (PQ decode -> AP1) tone mapped with the vanilla ACES chain (t40/t13, space15).
// The RenoDX path replaces the sRGB-encoded result after the discard, before the vanilla tint and alpha.

Texture2D<float4> t29_space15 : register(t29, space15);

Texture3D<float4> t40_space15 : register(t40, space15);

Texture2D<float4> t13_space15 : register(t13, space15);

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

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
    linear float ATTRIBUTE_OBJECT_ID : ATTRIBUTE_OBJECT_ID,
    linear float ATTRIBUTE_LIGHT_MASK : ATTRIBUTE_LIGHT_MASK,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    linear float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
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
  bool _15 = (SV_IsFrontFace != 0);
  float _33 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _34 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _39 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _40 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _41 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _42 = select(_15, ATTRIBUTE_NORMAL.x, _39);
  float _43 = select(_15, ATTRIBUTE_NORMAL.y, _40);
  float _44 = select(_15, ATTRIBUTE_NORMAL.z, _41);
  float _45 = _33 + 1.0f;
  float _46 = 1.0f - _34;
  float _47 = _45 * 0.5f;
  float _48 = _46 * 0.5f;
  float4 _51 = t29_space15.SampleBias(s0_space1, float2(_47, _48), cb1_space9_035z, int2(0, 0));
  float4 _55 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _57 = _51.x * ATTRIBUTE_VCOLOR.w;
  float _58 = _57 * _55.x;
  float _59 = max(_58, 0.0f);
  float _60 = min(1.0f, _59);
  float4 _63 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _65 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _67 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _69 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _73 = cb3_space9_038x * _65.x;
  float _75 = _73 + cb3_space9_038z;
  float _77 = cb3_space9_038y * _67.x;
  float _79 = _77 + cb3_space9_038w;
  float _80 = _69.x + _63.x;
  float _83 = cb3_space9_037x * _80;
  float _84 = _75 * 0.008609036915004253f;
  float _85 = _75 * 0.5600313544273376f;
  float _86 = _83 + _84;
  float _87 = _83 - _84;
  float _88 = _85 + _83;
  float _89 = _79 * 0.11102962493896484f;
  float _90 = _79 * 0.3206271827220917f;
  float _91 = _86 + _89;
  float _92 = _87 - _89;
  float _93 = _88 - _90;
  float _94 = max(_91, 0.0f);
  float _95 = max(_92, 0.0f);
  float _96 = max(_93, 0.0f);
  float _97 = log2(_94);
  float _98 = log2(_95);
  float _99 = log2(_96);
  float _100 = _97 * 0.012683313339948654f;
  float _101 = _98 * 0.012683313339948654f;
  float _102 = _99 * 0.012683313339948654f;
  float _103 = exp2(_100);
  float _104 = exp2(_101);
  float _105 = exp2(_102);
  float _106 = _103 + -0.8359375f;
  float _107 = _104 + -0.8359375f;
  float _108 = _105 + -0.8359375f;
  float _109 = max(0.0f, _106);
  float _110 = max(0.0f, _107);
  float _111 = max(0.0f, _108);
  float _112 = _103 * 18.6875f;
  float _113 = _104 * 18.6875f;
  float _114 = _105 * 18.6875f;
  float _115 = 18.8515625f - _112;
  float _116 = 18.8515625f - _113;
  float _117 = 18.8515625f - _114;
  float _118 = _109 / _115;
  float _119 = _110 / _116;
  float _120 = _111 / _117;
  float _121 = abs(_118);
  float _122 = abs(_119);
  float _123 = abs(_120);
  float _124 = log2(_121);
  float _125 = log2(_122);
  float _126 = log2(_123);
  float _127 = _124 * 6.277394771575928f;
  float _128 = _125 * 6.277394771575928f;
  float _129 = _126 * 6.277394771575928f;
  float _130 = exp2(_127);
  float _131 = exp2(_128);
  float _132 = exp2(_129);
  float _133 = _130 * 3.4366066455841064f;
  float _134 = _130 * 0.791329562664032f;
  float _135 = _131 * 2.5064520835876465f;
  float _136 = _131 * 1.9836004972457886f;
  float _137 = _131 * 0.09891371428966522f;
  float _138 = _133 - _135;
  float _139 = _136 - _134;
  float _140 = _130 * -0.02594989910721779f;
  float _141 = _140 - _137;
  float _142 = _132 * 0.06984542310237885f;
  float _143 = _132 * 0.192270889878273f;
  float _144 = _132 * 1.124863624572754f;
  float _145 = _138 + _142;
  float _146 = _139 - _143;
  float _147 = _141 + _144;
  float _149 = cb3_space9_037y * 368.6400146484375f;
  float _150 = _149 * _145;
  float _151 = _149 * _146;
  float _152 = _149 * _147;
  float _153 = max(_150, 9.999999747378752e-05f);
  float _154 = max(_151, 9.999999747378752e-05f);
  float _155 = max(_152, 9.999999747378752e-05f);
  float _159 = log2(_153);
  float _160 = log2(_154);
  float _161 = log2(_155);
  float _162 = _159 + 9.720000267028809f;
  float _163 = _160 + 9.720000267028809f;
  float _164 = _161 + 9.720000267028809f;
  float _165 = _162 * 0.03030303120613098f;
  float _166 = _163 * 0.03030303120613098f;
  float _167 = _164 * 0.03030303120613098f;
  float _168 = _165 + 0.23496760427951813f;
  float _169 = _166 + 0.23496760427951813f;
  float _170 = _167 + 0.23496760427951813f;
  uint3 _171;
  t40_space15.GetDimensions(_171.x, _171.y, _171.z);
  uint2 _175;
  t13_space15.GetDimensions(_175.x, _175.y);
  uint _177 = _171.x + -1u;
  uint _178 = _171.y + -1u;
  uint _179 = _171.z + -1u;
  float _180 = float((uint)_177);
  float _181 = float((uint)_178);
  float _182 = float((uint)_179);
  float _183 = float((uint)_171.x);
  float _184 = float((uint)_171.y);
  float _185 = float((uint)_171.z);
  float _186 = _180 / _183;
  float _187 = _181 / _184;
  float _188 = _182 / _185;
  float _189 = 0.5f / _183;
  float _190 = 0.5f / _184;
  float _191 = 0.5f / _185;
  float _192 = _186 * _168;
  float _193 = _187 * _169;
  float _194 = _188 * _170;
  float _195 = _189 + _192;
  float _196 = _190 + _193;
  float _197 = _191 + _194;
  float4 _198 = t40_space15.SampleLevel(s2_space1, float3(_195, _196, _197), 0.0f);
  float _201 = exp2(_159);
  float _202 = exp2(_160);
  float _203 = exp2(_161);
  float _204 = _201 * 0.6954522132873535f;
  float _205 = mad(0.14067870378494263f, _202, _204);
  float _206 = mad(0.16386906802654266f, _203, _205);
  float _207 = _201 * 0.044794563204050064f;
  float _208 = mad(0.8596711158752441f, _202, _207);
  float _209 = mad(0.0955343171954155f, _203, _208);
  float _210 = _201 * -0.005525882821530104f;
  float _211 = mad(0.004025210160762072f, _202, _210);
  float _212 = mad(1.0015007257461548f, _203, _211);
  float _213 = _198.x + 1.0f;
  float _214 = _206 * _213;
  float _215 = _209 * _213;
  float _216 = _212 * _213;
  float _217 = _214 + _198.y;
  float _218 = max(_217, 0.0f);
  float _219 = max(_215, 0.0f);
  float _220 = max(_216, 0.0f);
  float _221 = min(_218, 65536.0f);
  float _222 = min(_219, 65536.0f);
  float _223 = min(_220, 65536.0f);
  float _224 = _221 * 1.4514392614364624f;
  float _225 = mad(-0.2365107536315918f, _222, _224);
  float _226 = mad(-0.21492856740951538f, _223, _225);
  float _227 = _221 * -0.07655377686023712f;
  float _228 = mad(1.17622971534729f, _222, _227);
  float _229 = mad(-0.09967592358589172f, _223, _228);
  float _230 = _221 * 0.008316148072481155f;
  float _231 = mad(-0.006032449658960104f, _222, _230);
  float _232 = mad(0.9977163076400757f, _223, _231);
  float _233 = max(_226, 0.0f);
  float _234 = max(_229, 0.0f);
  float _235 = max(_232, 0.0f);
  float _236 = min(_233, 65504.0f);
  float _237 = min(_234, 65504.0f);
  float _238 = min(_235, 65504.0f);
  float _239 = _236 * 0.970889151096344f;
  float _240 = mad(0.026963284239172935f, _237, _239);
  float _241 = mad(0.0021475818939507008f, _238, _240);
  float _242 = _236 * 0.010889154858887196f;
  float _243 = mad(0.9869632720947266f, _237, _242);
  float _244 = mad(0.0021475818939507008f, _238, _243);
  float _245 = mad(0.026963284239172935f, _237, _242);
  float _246 = mad(0.9621475338935852f, _238, _245);
  float _247 = log2(_241);
  float _248 = log2(_244);
  float _249 = log2(_246);
  float _250 = _247 + 17.47393035888672f;
  float _251 = _248 + 17.47393035888672f;
  float _252 = _249 + 17.47393035888672f;
  float _253 = _250 * 0.03030303120613098f;
  float _254 = _251 * 0.03030303120613098f;
  float _255 = _252 * 0.03030303120613098f;
  uint _256 = _175.x + -1u;
  float _257 = float((uint)_256);
  float _258 = float((uint)_175.x);
  float _259 = _257 / _258;
  float _260 = 0.5f / _258;
  float _261 = _253 * _259;
  float _262 = _254 * _259;
  float _263 = _255 * _259;
  float _264 = _261 + _260;
  float _265 = _262 + _260;
  float _266 = _263 + _260;
  float4 _267 = t13_space15.SampleLevel(s2_space1, float2(_264, 0.5f), 0.0f);
  float4 _269 = t13_space15.SampleLevel(s2_space1, float2(_265, 0.5f), 0.0f);
  float4 _271 = t13_space15.SampleLevel(s2_space1, float2(_266, 0.5f), 0.0f);
  float _273 = _267.x * 3.321928024291992f;
  float _274 = _269.x * 3.321928024291992f;
  float _275 = _271.x * 3.321928024291992f;
  float _276 = exp2(_273);
  float _277 = exp2(_274);
  float _278 = exp2(_275);
  float _279 = _276 / cb3_space9_036w;
  float _280 = _277 / cb3_space9_036w;
  float _281 = _278 / cb3_space9_036w;
  bool _282 = (cb3_space9_036y < 500.0f);
  float _320;
  float _321;
  float _322;
  float _372;
  float _380;
  float _388;
  if (_282) {
    float _284 = _279 * 0.6624541878700256f;
    float _285 = mad(0.13400420546531677f, _280, _284);
    float _286 = mad(0.15618768334388733f, _281, _285);
    float _287 = _279 * 0.2722287178039551f;
    float _288 = mad(0.6740817427635193f, _280, _287);
    float _289 = mad(0.053689517080783844f, _281, _288);
    float _290 = _279 * -0.005574649665504694f;
    float _291 = mad(0.00406073359772563f, _280, _290);
    float _292 = mad(1.0103391408920288f, _281, _291);
    float _293 = _289 + _286;
    float _294 = _293 + _292;
    bool _295 = (_294 == 0.0f);
    float _296 = select(_295, 1.000000013351432e-10f, _294);
    float _297 = _286 / _296;
    float _298 = _289 / _296;
    float _299 = max(_289, 0.0f);
    float _300 = log2(_299);
    float _301 = _300 * 0.9811000227928162f;
    float _302 = exp2(_301);
    float _303 = _302 * _297;
    float _304 = max(_298, 1.000000013351432e-10f);
    float _305 = _303 / _304;
    float _306 = 1.0f - _297;
    float _307 = _306 - _298;
    float _308 = _302 * _307;
    float _309 = _308 / _304;
    float _310 = _305 * 1.6410233974456787f;
    float _311 = mad(-0.32480329275131226f, _302, _310);
    float _312 = mad(-0.23642469942569733f, _309, _311);
    float _313 = _305 * -0.663662850856781f;
    float _314 = mad(1.6153316497802734f, _302, _313);
    float _315 = mad(0.016756348311901093f, _309, _314);
    float _316 = _305 * 0.011721894145011902f;
    float _317 = mad(-0.008284442126750946f, _302, _316);
    float _318 = mad(0.9883948564529419f, _309, _317);
    _320 = _312;
    _321 = _315;
    _322 = _318;
  } else {
    _320 = _279;
    _321 = _280;
    _322 = _281;
  }
  float _323 = _320 * 1.6047539710998535f;
  float _324 = mad(-0.5310794711112976f, _321, _323);
  float _325 = mad(-0.07367203384637833f, _322, _324);
  float _326 = _320 * -0.10208318382501602f;
  float _327 = mad(1.108132243156433f, _321, _326);
  float _328 = mad(-0.006051875650882721f, _322, _327);
  float _329 = _320 * -0.0032670421060174704f;
  float _330 = mad(-0.07275524735450745f, _321, _329);
  float _331 = mad(1.0760219097137451f, _322, _330);
  float _332 = max(_325, 0.0f);
  float _333 = max(_328, 0.0f);
  float _334 = max(_331, 0.0f);
  float _335 = _332 * ATTRIBUTE_VCOLOR.x;
  float _336 = _333 * ATTRIBUTE_VCOLOR.y;
  float _337 = _334 * ATTRIBUTE_VCOLOR.z;
  float _338 = abs(_335);
  float _339 = abs(_336);
  float _340 = abs(_337);
  float _341 = log2(_338);
  float _342 = log2(_339);
  float _343 = log2(_340);
  float _344 = _341 * 0.4166666567325592f;
  float _345 = _342 * 0.4166666567325592f;
  float _346 = _343 * 0.4166666567325592f;
  float _347 = exp2(_344);
  float _348 = exp2(_345);
  float _349 = exp2(_346);
  bool _350 = isfinite(_347);
  bool _351 = isfinite(_348);
  bool _352 = isfinite(_349);
  float _353 = _347 * 1.0549999475479126f;
  float _354 = _348 * 1.0549999475479126f;
  float _355 = _349 * 1.0549999475479126f;
  float _356 = _353 + -0.054999999701976776f;
  float _357 = select(_350, _356, 0.9999999403953552f);
  float _358 = _354 + -0.054999999701976776f;
  float _359 = select(_351, _358, 0.9999999403953552f);
  float _360 = _355 + -0.054999999701976776f;
  float _361 = select(_352, _360, 0.9999999403953552f);
  float _362 = _336 * 12.920000076293945f;
  float _363 = _337 * 12.920000076293945f;
  bool _364 = (_335 > 0.0031308000907301903f);
  if (!_364) {
    float _366 = _335 * 12.920000076293945f;
    bool _367 = (_335 < 0.0031308000907301903f);
    if (!_367) {
      bool _369 = (_335 == 0.0031308000907301903f);
      if (_369) {
        _372 = _357;
      } else {
        _372 = 0.0f;
      }
    } else {
      _372 = _366;
    }
  } else {
    _372 = _357;
  }
  bool _373 = (_336 > 0.0031308000907301903f);
  if (!_373) {
    bool _375 = (_336 < 0.0031308000907301903f);
    if (!_375) {
      bool _377 = (_336 == 0.0031308000907301903f);
      if (_377) {
        _380 = _359;
      } else {
        _380 = 0.0f;
      }
    } else {
      _380 = _362;
    }
  } else {
    _380 = _359;
  }
  bool _381 = (_337 > 0.0031308000907301903f);
  if (!_381) {
    bool _383 = (_337 < 0.0031308000907301903f);
    if (!_383) {
      bool _385 = (_337 == 0.0031308000907301903f);
      if (_385) {
        _388 = _361;
      } else {
        _388 = 0.0f;
      }
    } else {
      _388 = _363;
    }
  } else {
    _388 = _361;
  }
  float _389 = dot(float3(_42, _43, _44), float3(_42, _43, _44));
  float _390 = rsqrt(_389);
  float _391 = _390 * _42;
  float _392 = _390 * _43;
  float _393 = _390 * _44;
  float _394 = _60 - cb1_space9_034x;
  bool _395 = (_394 < 0.0f);
  if (_395) discard;
  float _396 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _397 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _398 = _397 + _396;
  float _399 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _400 = _398 + _399;
  float _401 = sqrt(_400);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_162, _163, _164), 1.f);
    _372 = video.r;
    _380 = video.g;
    _388 = video.b;
  }
  float _402 = _372 * cb0_space5_008x;
  float _403 = _380 * cb0_space5_008y;
  float _404 = _388 * cb0_space5_008z;
  float _405 = _393 + -1.0f;
  float _406 = dot(float3(_391, _392, _405), float3(_391, _392, _405));
  float _407 = rsqrt(_406);
  float _408 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _409 = _408 + 0.5f;
  uint _410 = uint(_409);
  uint _411 = _410 % 13;
  float _412 = float((uint)_411);
  float _413 = _412 * 0.03846153989434242f;
  float _414 = _413 + 0.5f;
  bool _415 = (_402 < 0.0f);
  bool _416 = (_403 < 0.0f);
  bool _417 = (_404 < 0.0f);
  float _418 = select(_415, -0.0f, _402);
  float _419 = select(_416, -0.0f, _403);
  float _420 = select(_417, -0.0f, _404);
  float _421 = _391 * 0.5f;
  float _422 = _421 * _407;
  float _423 = _392 * 0.5f;
  float _424 = _423 * _407;
  float _425 = _422 + 0.5f;
  float _426 = _424 + 0.5f;
  SV_Target.x = _425;
  SV_Target.y = _426;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _418;
  SV_Target_2.y = _419;
  SV_Target_2.z = _420;
  SV_Target_2.w = _401;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _414;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}

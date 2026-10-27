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
  bool _15 = (SV_IsFrontFace != 0);
  bool _34 = (ATTRIBUTE_REFLECTION_DIST < 0.0f);
  if (_34) discard;
  float _35 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _36 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _41 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _42 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _43 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _44 = select(_15, ATTRIBUTE_NORMAL.x, _41);
  float _45 = select(_15, ATTRIBUTE_NORMAL.y, _42);
  float _46 = select(_15, ATTRIBUTE_NORMAL.z, _43);
  float _47 = _35 + 1.0f;
  float _48 = 1.0f - _36;
  float _49 = _47 * 0.5f;
  float _50 = _48 * 0.5f;
  float4 _53 = t29_space15.SampleBias(s0_space1, float2(_49, _50), cb1_space9_035z, int2(0, 0));
  float4 _57 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _59 = _53.x * ATTRIBUTE_VCOLOR.w;
  float _60 = _59 * _57.x;
  float _61 = max(_60, 0.0f);
  float _62 = min(1.0f, _61);
  float4 _65 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _67 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _69 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _71 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _75 = cb3_space9_038x * _67.x;
  float _77 = _75 + cb3_space9_038z;
  float _79 = cb3_space9_038y * _69.x;
  float _81 = _79 + cb3_space9_038w;
  float _82 = _71.x + _65.x;
  float _85 = cb3_space9_037x * _82;
  float _86 = _77 * 0.008609036915004253f;
  float _87 = _77 * 0.5600313544273376f;
  float _88 = _85 + _86;
  float _89 = _85 - _86;
  float _90 = _87 + _85;
  float _91 = _81 * 0.11102962493896484f;
  float _92 = _81 * 0.3206271827220917f;
  float _93 = _88 + _91;
  float _94 = _89 - _91;
  float _95 = _90 - _92;
  float _96 = max(_93, 0.0f);
  float _97 = max(_94, 0.0f);
  float _98 = max(_95, 0.0f);
  float _99 = log2(_96);
  float _100 = log2(_97);
  float _101 = log2(_98);
  float _102 = _99 * 0.012683313339948654f;
  float _103 = _100 * 0.012683313339948654f;
  float _104 = _101 * 0.012683313339948654f;
  float _105 = exp2(_102);
  float _106 = exp2(_103);
  float _107 = exp2(_104);
  float _108 = _105 + -0.8359375f;
  float _109 = _106 + -0.8359375f;
  float _110 = _107 + -0.8359375f;
  float _111 = max(0.0f, _108);
  float _112 = max(0.0f, _109);
  float _113 = max(0.0f, _110);
  float _114 = _105 * 18.6875f;
  float _115 = _106 * 18.6875f;
  float _116 = _107 * 18.6875f;
  float _117 = 18.8515625f - _114;
  float _118 = 18.8515625f - _115;
  float _119 = 18.8515625f - _116;
  float _120 = _111 / _117;
  float _121 = _112 / _118;
  float _122 = _113 / _119;
  float _123 = abs(_120);
  float _124 = abs(_121);
  float _125 = abs(_122);
  float _126 = log2(_123);
  float _127 = log2(_124);
  float _128 = log2(_125);
  float _129 = _126 * 6.277394771575928f;
  float _130 = _127 * 6.277394771575928f;
  float _131 = _128 * 6.277394771575928f;
  float _132 = exp2(_129);
  float _133 = exp2(_130);
  float _134 = exp2(_131);
  float _135 = _132 * 3.4366066455841064f;
  float _136 = _132 * 0.791329562664032f;
  float _137 = _133 * 2.5064520835876465f;
  float _138 = _133 * 1.9836004972457886f;
  float _139 = _133 * 0.09891371428966522f;
  float _140 = _135 - _137;
  float _141 = _138 - _136;
  float _142 = _132 * -0.02594989910721779f;
  float _143 = _142 - _139;
  float _144 = _134 * 0.06984542310237885f;
  float _145 = _134 * 0.192270889878273f;
  float _146 = _134 * 1.124863624572754f;
  float _147 = _140 + _144;
  float _148 = _141 - _145;
  float _149 = _143 + _146;
  float _151 = cb3_space9_037y * 368.6400146484375f;
  float _152 = _151 * _147;
  float _153 = _151 * _148;
  float _154 = _151 * _149;
  float _155 = max(_152, 9.999999747378752e-05f);
  float _156 = max(_153, 9.999999747378752e-05f);
  float _157 = max(_154, 9.999999747378752e-05f);
  float _161 = log2(_155);
  float _162 = log2(_156);
  float _163 = log2(_157);
  float _164 = _161 + 9.720000267028809f;
  float _165 = _162 + 9.720000267028809f;
  float _166 = _163 + 9.720000267028809f;
  float _167 = _164 * 0.03030303120613098f;
  float _168 = _165 * 0.03030303120613098f;
  float _169 = _166 * 0.03030303120613098f;
  float _170 = _167 + 0.23496760427951813f;
  float _171 = _168 + 0.23496760427951813f;
  float _172 = _169 + 0.23496760427951813f;
  uint3 _173;
  t40_space15.GetDimensions(_173.x, _173.y, _173.z);
  uint2 _177;
  t13_space15.GetDimensions(_177.x, _177.y);
  uint _179 = _173.x + -1u;
  uint _180 = _173.y + -1u;
  uint _181 = _173.z + -1u;
  float _182 = float((uint)_179);
  float _183 = float((uint)_180);
  float _184 = float((uint)_181);
  float _185 = float((uint)_173.x);
  float _186 = float((uint)_173.y);
  float _187 = float((uint)_173.z);
  float _188 = _182 / _185;
  float _189 = _183 / _186;
  float _190 = _184 / _187;
  float _191 = 0.5f / _185;
  float _192 = 0.5f / _186;
  float _193 = 0.5f / _187;
  float _194 = _188 * _170;
  float _195 = _189 * _171;
  float _196 = _190 * _172;
  float _197 = _191 + _194;
  float _198 = _192 + _195;
  float _199 = _193 + _196;
  float4 _200 = t40_space15.SampleLevel(s2_space1, float3(_197, _198, _199), 0.0f);
  float _203 = exp2(_161);
  float _204 = exp2(_162);
  float _205 = exp2(_163);
  float _206 = _203 * 0.6954522132873535f;
  float _207 = mad(0.14067870378494263f, _204, _206);
  float _208 = mad(0.16386906802654266f, _205, _207);
  float _209 = _203 * 0.044794563204050064f;
  float _210 = mad(0.8596711158752441f, _204, _209);
  float _211 = mad(0.0955343171954155f, _205, _210);
  float _212 = _203 * -0.005525882821530104f;
  float _213 = mad(0.004025210160762072f, _204, _212);
  float _214 = mad(1.0015007257461548f, _205, _213);
  float _215 = _200.x + 1.0f;
  float _216 = _208 * _215;
  float _217 = _211 * _215;
  float _218 = _214 * _215;
  float _219 = _216 + _200.y;
  float _220 = max(_219, 0.0f);
  float _221 = max(_217, 0.0f);
  float _222 = max(_218, 0.0f);
  float _223 = min(_220, 65536.0f);
  float _224 = min(_221, 65536.0f);
  float _225 = min(_222, 65536.0f);
  float _226 = _223 * 1.4514392614364624f;
  float _227 = mad(-0.2365107536315918f, _224, _226);
  float _228 = mad(-0.21492856740951538f, _225, _227);
  float _229 = _223 * -0.07655377686023712f;
  float _230 = mad(1.17622971534729f, _224, _229);
  float _231 = mad(-0.09967592358589172f, _225, _230);
  float _232 = _223 * 0.008316148072481155f;
  float _233 = mad(-0.006032449658960104f, _224, _232);
  float _234 = mad(0.9977163076400757f, _225, _233);
  float _235 = max(_228, 0.0f);
  float _236 = max(_231, 0.0f);
  float _237 = max(_234, 0.0f);
  float _238 = min(_235, 65504.0f);
  float _239 = min(_236, 65504.0f);
  float _240 = min(_237, 65504.0f);
  float _241 = _238 * 0.970889151096344f;
  float _242 = mad(0.026963284239172935f, _239, _241);
  float _243 = mad(0.0021475818939507008f, _240, _242);
  float _244 = _238 * 0.010889154858887196f;
  float _245 = mad(0.9869632720947266f, _239, _244);
  float _246 = mad(0.0021475818939507008f, _240, _245);
  float _247 = mad(0.026963284239172935f, _239, _244);
  float _248 = mad(0.9621475338935852f, _240, _247);
  float _249 = log2(_243);
  float _250 = log2(_246);
  float _251 = log2(_248);
  float _252 = _249 + 17.47393035888672f;
  float _253 = _250 + 17.47393035888672f;
  float _254 = _251 + 17.47393035888672f;
  float _255 = _252 * 0.03030303120613098f;
  float _256 = _253 * 0.03030303120613098f;
  float _257 = _254 * 0.03030303120613098f;
  uint _258 = _177.x + -1u;
  float _259 = float((uint)_258);
  float _260 = float((uint)_177.x);
  float _261 = _259 / _260;
  float _262 = 0.5f / _260;
  float _263 = _255 * _261;
  float _264 = _256 * _261;
  float _265 = _257 * _261;
  float _266 = _263 + _262;
  float _267 = _264 + _262;
  float _268 = _265 + _262;
  float4 _269 = t13_space15.SampleLevel(s2_space1, float2(_266, 0.5f), 0.0f);
  float4 _271 = t13_space15.SampleLevel(s2_space1, float2(_267, 0.5f), 0.0f);
  float4 _273 = t13_space15.SampleLevel(s2_space1, float2(_268, 0.5f), 0.0f);
  float _275 = _269.x * 3.321928024291992f;
  float _276 = _271.x * 3.321928024291992f;
  float _277 = _273.x * 3.321928024291992f;
  float _278 = exp2(_275);
  float _279 = exp2(_276);
  float _280 = exp2(_277);
  float _281 = _278 / cb3_space9_036w;
  float _282 = _279 / cb3_space9_036w;
  float _283 = _280 / cb3_space9_036w;
  bool _284 = (cb3_space9_036y < 500.0f);
  float _322;
  float _323;
  float _324;
  float _374;
  float _382;
  float _390;
  if (_284) {
    float _286 = _281 * 0.6624541878700256f;
    float _287 = mad(0.13400420546531677f, _282, _286);
    float _288 = mad(0.15618768334388733f, _283, _287);
    float _289 = _281 * 0.2722287178039551f;
    float _290 = mad(0.6740817427635193f, _282, _289);
    float _291 = mad(0.053689517080783844f, _283, _290);
    float _292 = _281 * -0.005574649665504694f;
    float _293 = mad(0.00406073359772563f, _282, _292);
    float _294 = mad(1.0103391408920288f, _283, _293);
    float _295 = _291 + _288;
    float _296 = _295 + _294;
    bool _297 = (_296 == 0.0f);
    float _298 = select(_297, 1.000000013351432e-10f, _296);
    float _299 = _288 / _298;
    float _300 = _291 / _298;
    float _301 = max(_291, 0.0f);
    float _302 = log2(_301);
    float _303 = _302 * 0.9811000227928162f;
    float _304 = exp2(_303);
    float _305 = _304 * _299;
    float _306 = max(_300, 1.000000013351432e-10f);
    float _307 = _305 / _306;
    float _308 = 1.0f - _299;
    float _309 = _308 - _300;
    float _310 = _304 * _309;
    float _311 = _310 / _306;
    float _312 = _307 * 1.6410233974456787f;
    float _313 = mad(-0.32480329275131226f, _304, _312);
    float _314 = mad(-0.23642469942569733f, _311, _313);
    float _315 = _307 * -0.663662850856781f;
    float _316 = mad(1.6153316497802734f, _304, _315);
    float _317 = mad(0.016756348311901093f, _311, _316);
    float _318 = _307 * 0.011721894145011902f;
    float _319 = mad(-0.008284442126750946f, _304, _318);
    float _320 = mad(0.9883948564529419f, _311, _319);
    _322 = _314;
    _323 = _317;
    _324 = _320;
  } else {
    _322 = _281;
    _323 = _282;
    _324 = _283;
  }
  float _325 = _322 * 1.6047539710998535f;
  float _326 = mad(-0.5310794711112976f, _323, _325);
  float _327 = mad(-0.07367203384637833f, _324, _326);
  float _328 = _322 * -0.10208318382501602f;
  float _329 = mad(1.108132243156433f, _323, _328);
  float _330 = mad(-0.006051875650882721f, _324, _329);
  float _331 = _322 * -0.0032670421060174704f;
  float _332 = mad(-0.07275524735450745f, _323, _331);
  float _333 = mad(1.0760219097137451f, _324, _332);
  float _334 = max(_327, 0.0f);
  float _335 = max(_330, 0.0f);
  float _336 = max(_333, 0.0f);
  float _337 = _334 * ATTRIBUTE_VCOLOR.x;
  float _338 = _335 * ATTRIBUTE_VCOLOR.y;
  float _339 = _336 * ATTRIBUTE_VCOLOR.z;
  float _340 = abs(_337);
  float _341 = abs(_338);
  float _342 = abs(_339);
  float _343 = log2(_340);
  float _344 = log2(_341);
  float _345 = log2(_342);
  float _346 = _343 * 0.4166666567325592f;
  float _347 = _344 * 0.4166666567325592f;
  float _348 = _345 * 0.4166666567325592f;
  float _349 = exp2(_346);
  float _350 = exp2(_347);
  float _351 = exp2(_348);
  bool _352 = isfinite(_349);
  bool _353 = isfinite(_350);
  bool _354 = isfinite(_351);
  float _355 = _349 * 1.0549999475479126f;
  float _356 = _350 * 1.0549999475479126f;
  float _357 = _351 * 1.0549999475479126f;
  float _358 = _355 + -0.054999999701976776f;
  float _359 = select(_352, _358, 0.9999999403953552f);
  float _360 = _356 + -0.054999999701976776f;
  float _361 = select(_353, _360, 0.9999999403953552f);
  float _362 = _357 + -0.054999999701976776f;
  float _363 = select(_354, _362, 0.9999999403953552f);
  float _364 = _338 * 12.920000076293945f;
  float _365 = _339 * 12.920000076293945f;
  bool _366 = (_337 > 0.0031308000907301903f);
  if (!_366) {
    float _368 = _337 * 12.920000076293945f;
    bool _369 = (_337 < 0.0031308000907301903f);
    if (!_369) {
      bool _371 = (_337 == 0.0031308000907301903f);
      if (_371) {
        _374 = _359;
      } else {
        _374 = 0.0f;
      }
    } else {
      _374 = _368;
    }
  } else {
    _374 = _359;
  }
  bool _375 = (_338 > 0.0031308000907301903f);
  if (!_375) {
    bool _377 = (_338 < 0.0031308000907301903f);
    if (!_377) {
      bool _379 = (_338 == 0.0031308000907301903f);
      if (_379) {
        _382 = _361;
      } else {
        _382 = 0.0f;
      }
    } else {
      _382 = _364;
    }
  } else {
    _382 = _361;
  }
  bool _383 = (_339 > 0.0031308000907301903f);
  if (!_383) {
    bool _385 = (_339 < 0.0031308000907301903f);
    if (!_385) {
      bool _387 = (_339 == 0.0031308000907301903f);
      if (_387) {
        _390 = _363;
      } else {
        _390 = 0.0f;
      }
    } else {
      _390 = _365;
    }
  } else {
    _390 = _363;
  }
  float _391 = dot(float3(_44, _45, _46), float3(_44, _45, _46));
  float _392 = rsqrt(_391);
  float _393 = _392 * _44;
  float _394 = _392 * _45;
  float _395 = _392 * _46;
  float _396 = _62 - cb1_space9_034x;
  bool _397 = (_396 < 0.0f);
  if (_397) discard;
  float _398 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _399 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _400 = _399 + _398;
  float _401 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _402 = _400 + _401;
  float _403 = sqrt(_402);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_164, _165, _166), 1.f);
    _374 = video.r;
    _382 = video.g;
    _390 = video.b;
  }
  float _404 = _374 * cb0_space5_008x;
  float _405 = _382 * cb0_space5_008y;
  float _406 = _390 * cb0_space5_008z;
  float _407 = _395 + -1.0f;
  float _408 = dot(float3(_393, _394, _407), float3(_393, _394, _407));
  float _409 = rsqrt(_408);
  float _410 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _411 = _410 + 0.5f;
  uint _412 = uint(_411);
  uint _413 = _412 % 13;
  float _414 = float((uint)_413);
  float _415 = _414 * 0.03846153989434242f;
  float _416 = _415 + 0.5f;
  bool _417 = (_404 < 0.0f);
  bool _418 = (_405 < 0.0f);
  bool _419 = (_406 < 0.0f);
  float _420 = select(_417, -0.0f, _404);
  float _421 = select(_418, -0.0f, _405);
  float _422 = select(_419, -0.0f, _406);
  float _423 = _393 * 0.5f;
  float _424 = _423 * _409;
  float _425 = _394 * 0.5f;
  float _426 = _425 * _409;
  float _427 = _424 + 0.5f;
  float _428 = _426 + 0.5f;
  SV_Target.x = _427;
  SV_Target.y = _428;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _420;
  SV_Target_2.y = _421;
  SV_Target_2.z = _422;
  SV_Target_2.w = _403;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _416;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}

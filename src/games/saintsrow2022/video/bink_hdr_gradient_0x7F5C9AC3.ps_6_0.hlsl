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
  bool _14 = (SV_IsFrontFace != 0);
  float _32 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _33 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _38 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _39 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _40 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _41 = select(_14, ATTRIBUTE_NORMAL.x, _38);
  float _42 = select(_14, ATTRIBUTE_NORMAL.y, _39);
  float _43 = select(_14, ATTRIBUTE_NORMAL.z, _40);
  float _44 = _32 + 1.0f;
  float _45 = 1.0f - _33;
  float _46 = _44 * 0.5f;
  float _47 = _45 * 0.5f;
  float4 _50 = t29_space15.SampleBias(s0_space1, float2(_46, _47), cb1_space9_035z, int2(0, 0));
  float _52 = _50.x * ATTRIBUTE_VCOLOR.w;
  float _53 = max(_52, 0.0f);
  float _54 = min(1.0f, _53);
  float4 _59 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _61 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _63 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _65 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _69 = cb3_space9_038x * _61.x;
  float _71 = _69 + cb3_space9_038z;
  float _73 = cb3_space9_038y * _63.x;
  float _75 = _73 + cb3_space9_038w;
  float _76 = _65.x + _59.x;
  float _79 = cb3_space9_037x * _76;
  float _80 = _71 * 0.008609036915004253f;
  float _81 = _71 * 0.5600313544273376f;
  float _82 = _79 + _80;
  float _83 = _79 - _80;
  float _84 = _81 + _79;
  float _85 = _75 * 0.11102962493896484f;
  float _86 = _75 * 0.3206271827220917f;
  float _87 = _82 + _85;
  float _88 = _83 - _85;
  float _89 = _84 - _86;
  float _90 = max(_87, 0.0f);
  float _91 = max(_88, 0.0f);
  float _92 = max(_89, 0.0f);
  float _93 = log2(_90);
  float _94 = log2(_91);
  float _95 = log2(_92);
  float _96 = _93 * 0.012683313339948654f;
  float _97 = _94 * 0.012683313339948654f;
  float _98 = _95 * 0.012683313339948654f;
  float _99 = exp2(_96);
  float _100 = exp2(_97);
  float _101 = exp2(_98);
  float _102 = _99 + -0.8359375f;
  float _103 = _100 + -0.8359375f;
  float _104 = _101 + -0.8359375f;
  float _105 = max(0.0f, _102);
  float _106 = max(0.0f, _103);
  float _107 = max(0.0f, _104);
  float _108 = _99 * 18.6875f;
  float _109 = _100 * 18.6875f;
  float _110 = _101 * 18.6875f;
  float _111 = 18.8515625f - _108;
  float _112 = 18.8515625f - _109;
  float _113 = 18.8515625f - _110;
  float _114 = _105 / _111;
  float _115 = _106 / _112;
  float _116 = _107 / _113;
  float _117 = abs(_114);
  float _118 = abs(_115);
  float _119 = abs(_116);
  float _120 = log2(_117);
  float _121 = log2(_118);
  float _122 = log2(_119);
  float _123 = _120 * 6.277394771575928f;
  float _124 = _121 * 6.277394771575928f;
  float _125 = _122 * 6.277394771575928f;
  float _126 = exp2(_123);
  float _127 = exp2(_124);
  float _128 = exp2(_125);
  float _129 = _126 * 3.4366066455841064f;
  float _130 = _126 * 0.791329562664032f;
  float _131 = _127 * 2.5064520835876465f;
  float _132 = _127 * 1.9836004972457886f;
  float _133 = _127 * 0.09891371428966522f;
  float _134 = _129 - _131;
  float _135 = _132 - _130;
  float _136 = _126 * -0.02594989910721779f;
  float _137 = _136 - _133;
  float _138 = _128 * 0.06984542310237885f;
  float _139 = _128 * 0.192270889878273f;
  float _140 = _128 * 1.124863624572754f;
  float _141 = _134 + _138;
  float _142 = _135 - _139;
  float _143 = _137 + _140;
  float _145 = cb3_space9_037y * 368.6400146484375f;
  float _146 = _145 * _141;
  float _147 = _145 * _142;
  float _148 = _145 * _143;
  float _149 = max(_146, 9.999999747378752e-05f);
  float _150 = max(_147, 9.999999747378752e-05f);
  float _151 = max(_148, 9.999999747378752e-05f);
  float _155 = log2(_149);
  float _156 = log2(_150);
  float _157 = log2(_151);
  float _158 = _155 + 9.720000267028809f;
  float _159 = _156 + 9.720000267028809f;
  float _160 = _157 + 9.720000267028809f;
  float _161 = _158 * 0.03030303120613098f;
  float _162 = _159 * 0.03030303120613098f;
  float _163 = _160 * 0.03030303120613098f;
  float _164 = _161 + 0.23496760427951813f;
  float _165 = _162 + 0.23496760427951813f;
  float _166 = _163 + 0.23496760427951813f;
  uint3 _167;
  t40_space15.GetDimensions(_167.x, _167.y, _167.z);
  uint2 _171;
  t13_space15.GetDimensions(_171.x, _171.y);
  uint _173 = _167.x + -1u;
  uint _174 = _167.y + -1u;
  uint _175 = _167.z + -1u;
  float _176 = float((uint)_173);
  float _177 = float((uint)_174);
  float _178 = float((uint)_175);
  float _179 = float((uint)_167.x);
  float _180 = float((uint)_167.y);
  float _181 = float((uint)_167.z);
  float _182 = _176 / _179;
  float _183 = _177 / _180;
  float _184 = _178 / _181;
  float _185 = 0.5f / _179;
  float _186 = 0.5f / _180;
  float _187 = 0.5f / _181;
  float _188 = _182 * _164;
  float _189 = _183 * _165;
  float _190 = _184 * _166;
  float _191 = _185 + _188;
  float _192 = _186 + _189;
  float _193 = _187 + _190;
  float4 _194 = t40_space15.SampleLevel(s2_space1, float3(_191, _192, _193), 0.0f);
  float _197 = exp2(_155);
  float _198 = exp2(_156);
  float _199 = exp2(_157);
  float _200 = _197 * 0.6954522132873535f;
  float _201 = mad(0.14067870378494263f, _198, _200);
  float _202 = mad(0.16386906802654266f, _199, _201);
  float _203 = _197 * 0.044794563204050064f;
  float _204 = mad(0.8596711158752441f, _198, _203);
  float _205 = mad(0.0955343171954155f, _199, _204);
  float _206 = _197 * -0.005525882821530104f;
  float _207 = mad(0.004025210160762072f, _198, _206);
  float _208 = mad(1.0015007257461548f, _199, _207);
  float _209 = _194.x + 1.0f;
  float _210 = _202 * _209;
  float _211 = _205 * _209;
  float _212 = _208 * _209;
  float _213 = _210 + _194.y;
  float _214 = max(_213, 0.0f);
  float _215 = max(_211, 0.0f);
  float _216 = max(_212, 0.0f);
  float _217 = min(_214, 65536.0f);
  float _218 = min(_215, 65536.0f);
  float _219 = min(_216, 65536.0f);
  float _220 = _217 * 1.4514392614364624f;
  float _221 = mad(-0.2365107536315918f, _218, _220);
  float _222 = mad(-0.21492856740951538f, _219, _221);
  float _223 = _217 * -0.07655377686023712f;
  float _224 = mad(1.17622971534729f, _218, _223);
  float _225 = mad(-0.09967592358589172f, _219, _224);
  float _226 = _217 * 0.008316148072481155f;
  float _227 = mad(-0.006032449658960104f, _218, _226);
  float _228 = mad(0.9977163076400757f, _219, _227);
  float _229 = max(_222, 0.0f);
  float _230 = max(_225, 0.0f);
  float _231 = max(_228, 0.0f);
  float _232 = min(_229, 65504.0f);
  float _233 = min(_230, 65504.0f);
  float _234 = min(_231, 65504.0f);
  float _235 = _232 * 0.970889151096344f;
  float _236 = mad(0.026963284239172935f, _233, _235);
  float _237 = mad(0.0021475818939507008f, _234, _236);
  float _238 = _232 * 0.010889154858887196f;
  float _239 = mad(0.9869632720947266f, _233, _238);
  float _240 = mad(0.0021475818939507008f, _234, _239);
  float _241 = mad(0.026963284239172935f, _233, _238);
  float _242 = mad(0.9621475338935852f, _234, _241);
  float _243 = log2(_237);
  float _244 = log2(_240);
  float _245 = log2(_242);
  float _246 = _243 + 17.47393035888672f;
  float _247 = _244 + 17.47393035888672f;
  float _248 = _245 + 17.47393035888672f;
  float _249 = _246 * 0.03030303120613098f;
  float _250 = _247 * 0.03030303120613098f;
  float _251 = _248 * 0.03030303120613098f;
  uint _252 = _171.x + -1u;
  float _253 = float((uint)_252);
  float _254 = float((uint)_171.x);
  float _255 = _253 / _254;
  float _256 = 0.5f / _254;
  float _257 = _249 * _255;
  float _258 = _250 * _255;
  float _259 = _251 * _255;
  float _260 = _257 + _256;
  float _261 = _258 + _256;
  float _262 = _259 + _256;
  float4 _263 = t13_space15.SampleLevel(s2_space1, float2(_260, 0.5f), 0.0f);
  float4 _265 = t13_space15.SampleLevel(s2_space1, float2(_261, 0.5f), 0.0f);
  float4 _267 = t13_space15.SampleLevel(s2_space1, float2(_262, 0.5f), 0.0f);
  float _269 = _263.x * 3.321928024291992f;
  float _270 = _265.x * 3.321928024291992f;
  float _271 = _267.x * 3.321928024291992f;
  float _272 = exp2(_269);
  float _273 = exp2(_270);
  float _274 = exp2(_271);
  float _275 = _272 / cb3_space9_036w;
  float _276 = _273 / cb3_space9_036w;
  float _277 = _274 / cb3_space9_036w;
  bool _278 = (cb3_space9_036y < 500.0f);
  float _316;
  float _317;
  float _318;
  float _368;
  float _376;
  float _384;
  if (_278) {
    float _280 = _275 * 0.6624541878700256f;
    float _281 = mad(0.13400420546531677f, _276, _280);
    float _282 = mad(0.15618768334388733f, _277, _281);
    float _283 = _275 * 0.2722287178039551f;
    float _284 = mad(0.6740817427635193f, _276, _283);
    float _285 = mad(0.053689517080783844f, _277, _284);
    float _286 = _275 * -0.005574649665504694f;
    float _287 = mad(0.00406073359772563f, _276, _286);
    float _288 = mad(1.0103391408920288f, _277, _287);
    float _289 = _285 + _282;
    float _290 = _289 + _288;
    bool _291 = (_290 == 0.0f);
    float _292 = select(_291, 1.000000013351432e-10f, _290);
    float _293 = _282 / _292;
    float _294 = _285 / _292;
    float _295 = max(_285, 0.0f);
    float _296 = log2(_295);
    float _297 = _296 * 0.9811000227928162f;
    float _298 = exp2(_297);
    float _299 = _298 * _293;
    float _300 = max(_294, 1.000000013351432e-10f);
    float _301 = _299 / _300;
    float _302 = 1.0f - _293;
    float _303 = _302 - _294;
    float _304 = _298 * _303;
    float _305 = _304 / _300;
    float _306 = _301 * 1.6410233974456787f;
    float _307 = mad(-0.32480329275131226f, _298, _306);
    float _308 = mad(-0.23642469942569733f, _305, _307);
    float _309 = _301 * -0.663662850856781f;
    float _310 = mad(1.6153316497802734f, _298, _309);
    float _311 = mad(0.016756348311901093f, _305, _310);
    float _312 = _301 * 0.011721894145011902f;
    float _313 = mad(-0.008284442126750946f, _298, _312);
    float _314 = mad(0.9883948564529419f, _305, _313);
    _316 = _308;
    _317 = _311;
    _318 = _314;
  } else {
    _316 = _275;
    _317 = _276;
    _318 = _277;
  }
  float _319 = _316 * 1.6047539710998535f;
  float _320 = mad(-0.5310794711112976f, _317, _319);
  float _321 = mad(-0.07367203384637833f, _318, _320);
  float _322 = _316 * -0.10208318382501602f;
  float _323 = mad(1.108132243156433f, _317, _322);
  float _324 = mad(-0.006051875650882721f, _318, _323);
  float _325 = _316 * -0.0032670421060174704f;
  float _326 = mad(-0.07275524735450745f, _317, _325);
  float _327 = mad(1.0760219097137451f, _318, _326);
  float _328 = max(_321, 0.0f);
  float _329 = max(_324, 0.0f);
  float _330 = max(_327, 0.0f);
  float _331 = _328 * ATTRIBUTE_VCOLOR.x;
  float _332 = _329 * ATTRIBUTE_VCOLOR.y;
  float _333 = _330 * ATTRIBUTE_VCOLOR.z;
  float _334 = abs(_331);
  float _335 = abs(_332);
  float _336 = abs(_333);
  float _337 = log2(_334);
  float _338 = log2(_335);
  float _339 = log2(_336);
  float _340 = _337 * 0.4166666567325592f;
  float _341 = _338 * 0.4166666567325592f;
  float _342 = _339 * 0.4166666567325592f;
  float _343 = exp2(_340);
  float _344 = exp2(_341);
  float _345 = exp2(_342);
  bool _346 = isfinite(_343);
  bool _347 = isfinite(_344);
  bool _348 = isfinite(_345);
  float _349 = _343 * 1.0549999475479126f;
  float _350 = _344 * 1.0549999475479126f;
  float _351 = _345 * 1.0549999475479126f;
  float _352 = _349 + -0.054999999701976776f;
  float _353 = select(_346, _352, 0.9999999403953552f);
  float _354 = _350 + -0.054999999701976776f;
  float _355 = select(_347, _354, 0.9999999403953552f);
  float _356 = _351 + -0.054999999701976776f;
  float _357 = select(_348, _356, 0.9999999403953552f);
  float _358 = _332 * 12.920000076293945f;
  float _359 = _333 * 12.920000076293945f;
  bool _360 = (_331 > 0.0031308000907301903f);
  if (!_360) {
    float _362 = _331 * 12.920000076293945f;
    bool _363 = (_331 < 0.0031308000907301903f);
    if (!_363) {
      bool _365 = (_331 == 0.0031308000907301903f);
      if (_365) {
        _368 = _353;
      } else {
        _368 = 0.0f;
      }
    } else {
      _368 = _362;
    }
  } else {
    _368 = _353;
  }
  bool _369 = (_332 > 0.0031308000907301903f);
  if (!_369) {
    bool _371 = (_332 < 0.0031308000907301903f);
    if (!_371) {
      bool _373 = (_332 == 0.0031308000907301903f);
      if (_373) {
        _376 = _355;
      } else {
        _376 = 0.0f;
      }
    } else {
      _376 = _358;
    }
  } else {
    _376 = _355;
  }
  bool _377 = (_333 > 0.0031308000907301903f);
  if (!_377) {
    bool _379 = (_333 < 0.0031308000907301903f);
    if (!_379) {
      bool _381 = (_333 == 0.0031308000907301903f);
      if (_381) {
        _384 = _357;
      } else {
        _384 = 0.0f;
      }
    } else {
      _384 = _359;
    }
  } else {
    _384 = _357;
  }
  float _385 = dot(float3(_41, _42, _43), float3(_41, _42, _43));
  float _386 = rsqrt(_385);
  float _387 = _386 * _41;
  float _388 = _386 * _42;
  float _389 = _386 * _43;
  float _390 = _54 - cb1_space9_034x;
  bool _391 = (_390 < 0.0f);
  if (_391) discard;
  float _392 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _393 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _394 = _393 + _392;
  float _395 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _396 = _394 + _395;
  float _397 = sqrt(_396);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_158, _159, _160), 1.f);
    _368 = video.r;
    _376 = video.g;
    _384 = video.b;
  }
  float _398 = _368 * cb0_space5_008x;
  float _399 = _376 * cb0_space5_008y;
  float _400 = _384 * cb0_space5_008z;
  float _401 = _389 + -1.0f;
  float _402 = dot(float3(_387, _388, _401), float3(_387, _388, _401));
  float _403 = rsqrt(_402);
  float _404 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _405 = _404 + 0.5f;
  uint _406 = uint(_405);
  uint _407 = _406 % 13;
  float _408 = float((uint)_407);
  float _409 = _408 * 0.03846153989434242f;
  float _410 = _409 + 0.5f;
  bool _411 = (_398 < 0.0f);
  bool _412 = (_399 < 0.0f);
  bool _413 = (_400 < 0.0f);
  float _414 = select(_411, -0.0f, _398);
  float _415 = select(_412, -0.0f, _399);
  float _416 = select(_413, -0.0f, _400);
  float _417 = _387 * 0.5f;
  float _418 = _417 * _403;
  float _419 = _388 * 0.5f;
  float _420 = _419 * _403;
  float _421 = _418 + 0.5f;
  float _422 = _420 + 0.5f;
  SV_Target.x = _421;
  SV_Target.y = _422;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _414;
  SV_Target_2.y = _415;
  SV_Target_2.z = _416;
  SV_Target_2.w = _397;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _410;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}

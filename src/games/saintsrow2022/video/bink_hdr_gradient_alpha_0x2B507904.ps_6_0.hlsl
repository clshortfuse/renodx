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
  float cb0_space5_008w : packoffset(c008.w);
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

float4 main(
    noperspective float4 SV_Position : SV_Position,
    float4 ATTRIBUTE_POSITION_INTERPOLATED : ATTRIBUTE_POSITION_INTERPOLATED,
    linear float2 UVS_PACKED_ATTR : UVS_PACKED_ATTR,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  float _23 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _24 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _25 = _23 + 1.0f;
  float _26 = 1.0f - _24;
  float _27 = _25 * 0.5f;
  float _28 = _26 * 0.5f;
  float4 _31 = t29_space15.SampleBias(s0_space1, float2(_27, _28), cb1_space9_035z, int2(0, 0));
  float4 _35 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _37 = _31.x * ATTRIBUTE_VCOLOR.w;
  float _38 = _37 * _35.x;
  float _39 = max(_38, 0.0f);
  float _40 = min(1.0f, _39);
  float4 _43 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _45 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _47 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _49 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _53 = cb3_space9_038x * _45.x;
  float _55 = _53 + cb3_space9_038z;
  float _57 = cb3_space9_038y * _47.x;
  float _59 = _57 + cb3_space9_038w;
  float _60 = _49.x + _43.x;
  float _63 = cb3_space9_037x * _60;
  float _64 = _55 * 0.008609036915004253f;
  float _65 = _55 * 0.5600313544273376f;
  float _66 = _63 + _64;
  float _67 = _63 - _64;
  float _68 = _65 + _63;
  float _69 = _59 * 0.11102962493896484f;
  float _70 = _59 * 0.3206271827220917f;
  float _71 = _66 + _69;
  float _72 = _67 - _69;
  float _73 = _68 - _70;
  float _74 = max(_71, 0.0f);
  float _75 = max(_72, 0.0f);
  float _76 = max(_73, 0.0f);
  float _77 = log2(_74);
  float _78 = log2(_75);
  float _79 = log2(_76);
  float _80 = _77 * 0.012683313339948654f;
  float _81 = _78 * 0.012683313339948654f;
  float _82 = _79 * 0.012683313339948654f;
  float _83 = exp2(_80);
  float _84 = exp2(_81);
  float _85 = exp2(_82);
  float _86 = _83 + -0.8359375f;
  float _87 = _84 + -0.8359375f;
  float _88 = _85 + -0.8359375f;
  float _89 = max(0.0f, _86);
  float _90 = max(0.0f, _87);
  float _91 = max(0.0f, _88);
  float _92 = _83 * 18.6875f;
  float _93 = _84 * 18.6875f;
  float _94 = _85 * 18.6875f;
  float _95 = 18.8515625f - _92;
  float _96 = 18.8515625f - _93;
  float _97 = 18.8515625f - _94;
  float _98 = _89 / _95;
  float _99 = _90 / _96;
  float _100 = _91 / _97;
  float _101 = abs(_98);
  float _102 = abs(_99);
  float _103 = abs(_100);
  float _104 = log2(_101);
  float _105 = log2(_102);
  float _106 = log2(_103);
  float _107 = _104 * 6.277394771575928f;
  float _108 = _105 * 6.277394771575928f;
  float _109 = _106 * 6.277394771575928f;
  float _110 = exp2(_107);
  float _111 = exp2(_108);
  float _112 = exp2(_109);
  float _113 = _110 * 3.4366066455841064f;
  float _114 = _110 * 0.791329562664032f;
  float _115 = _111 * 2.5064520835876465f;
  float _116 = _111 * 1.9836004972457886f;
  float _117 = _111 * 0.09891371428966522f;
  float _118 = _113 - _115;
  float _119 = _116 - _114;
  float _120 = _110 * -0.02594989910721779f;
  float _121 = _120 - _117;
  float _122 = _112 * 0.06984542310237885f;
  float _123 = _112 * 0.192270889878273f;
  float _124 = _112 * 1.124863624572754f;
  float _125 = _118 + _122;
  float _126 = _119 - _123;
  float _127 = _121 + _124;
  float _129 = cb3_space9_037y * 368.6400146484375f;
  float _130 = _129 * _125;
  float _131 = _129 * _126;
  float _132 = _129 * _127;
  float _133 = max(_130, 9.999999747378752e-05f);
  float _134 = max(_131, 9.999999747378752e-05f);
  float _135 = max(_132, 9.999999747378752e-05f);
  float _139 = log2(_133);
  float _140 = log2(_134);
  float _141 = log2(_135);
  float _142 = _139 + 9.720000267028809f;
  float _143 = _140 + 9.720000267028809f;
  float _144 = _141 + 9.720000267028809f;
  float _145 = _142 * 0.03030303120613098f;
  float _146 = _143 * 0.03030303120613098f;
  float _147 = _144 * 0.03030303120613098f;
  float _148 = _145 + 0.23496760427951813f;
  float _149 = _146 + 0.23496760427951813f;
  float _150 = _147 + 0.23496760427951813f;
  uint3 _151;
  t40_space15.GetDimensions(_151.x, _151.y, _151.z);
  uint2 _155;
  t13_space15.GetDimensions(_155.x, _155.y);
  uint _157 = _151.x + -1u;
  uint _158 = _151.y + -1u;
  uint _159 = _151.z + -1u;
  float _160 = float((uint)_157);
  float _161 = float((uint)_158);
  float _162 = float((uint)_159);
  float _163 = float((uint)_151.x);
  float _164 = float((uint)_151.y);
  float _165 = float((uint)_151.z);
  float _166 = _160 / _163;
  float _167 = _161 / _164;
  float _168 = _162 / _165;
  float _169 = 0.5f / _163;
  float _170 = 0.5f / _164;
  float _171 = 0.5f / _165;
  float _172 = _166 * _148;
  float _173 = _167 * _149;
  float _174 = _168 * _150;
  float _175 = _169 + _172;
  float _176 = _170 + _173;
  float _177 = _171 + _174;
  float4 _178 = t40_space15.SampleLevel(s2_space1, float3(_175, _176, _177), 0.0f);
  float _181 = exp2(_139);
  float _182 = exp2(_140);
  float _183 = exp2(_141);
  float _184 = _181 * 0.6954522132873535f;
  float _185 = mad(0.14067870378494263f, _182, _184);
  float _186 = mad(0.16386906802654266f, _183, _185);
  float _187 = _181 * 0.044794563204050064f;
  float _188 = mad(0.8596711158752441f, _182, _187);
  float _189 = mad(0.0955343171954155f, _183, _188);
  float _190 = _181 * -0.005525882821530104f;
  float _191 = mad(0.004025210160762072f, _182, _190);
  float _192 = mad(1.0015007257461548f, _183, _191);
  float _193 = _178.x + 1.0f;
  float _194 = _186 * _193;
  float _195 = _189 * _193;
  float _196 = _192 * _193;
  float _197 = _194 + _178.y;
  float _198 = max(_197, 0.0f);
  float _199 = max(_195, 0.0f);
  float _200 = max(_196, 0.0f);
  float _201 = min(_198, 65536.0f);
  float _202 = min(_199, 65536.0f);
  float _203 = min(_200, 65536.0f);
  float _204 = _201 * 1.4514392614364624f;
  float _205 = mad(-0.2365107536315918f, _202, _204);
  float _206 = mad(-0.21492856740951538f, _203, _205);
  float _207 = _201 * -0.07655377686023712f;
  float _208 = mad(1.17622971534729f, _202, _207);
  float _209 = mad(-0.09967592358589172f, _203, _208);
  float _210 = _201 * 0.008316148072481155f;
  float _211 = mad(-0.006032449658960104f, _202, _210);
  float _212 = mad(0.9977163076400757f, _203, _211);
  float _213 = max(_206, 0.0f);
  float _214 = max(_209, 0.0f);
  float _215 = max(_212, 0.0f);
  float _216 = min(_213, 65504.0f);
  float _217 = min(_214, 65504.0f);
  float _218 = min(_215, 65504.0f);
  float _219 = _216 * 0.970889151096344f;
  float _220 = mad(0.026963284239172935f, _217, _219);
  float _221 = mad(0.0021475818939507008f, _218, _220);
  float _222 = _216 * 0.010889154858887196f;
  float _223 = mad(0.9869632720947266f, _217, _222);
  float _224 = mad(0.0021475818939507008f, _218, _223);
  float _225 = mad(0.026963284239172935f, _217, _222);
  float _226 = mad(0.9621475338935852f, _218, _225);
  float _227 = log2(_221);
  float _228 = log2(_224);
  float _229 = log2(_226);
  float _230 = _227 + 17.47393035888672f;
  float _231 = _228 + 17.47393035888672f;
  float _232 = _229 + 17.47393035888672f;
  float _233 = _230 * 0.03030303120613098f;
  float _234 = _231 * 0.03030303120613098f;
  float _235 = _232 * 0.03030303120613098f;
  uint _236 = _155.x + -1u;
  float _237 = float((uint)_236);
  float _238 = float((uint)_155.x);
  float _239 = _237 / _238;
  float _240 = 0.5f / _238;
  float _241 = _233 * _239;
  float _242 = _234 * _239;
  float _243 = _235 * _239;
  float _244 = _241 + _240;
  float _245 = _242 + _240;
  float _246 = _243 + _240;
  float4 _247 = t13_space15.SampleLevel(s2_space1, float2(_244, 0.5f), 0.0f);
  float4 _249 = t13_space15.SampleLevel(s2_space1, float2(_245, 0.5f), 0.0f);
  float4 _251 = t13_space15.SampleLevel(s2_space1, float2(_246, 0.5f), 0.0f);
  float _253 = _247.x * 3.321928024291992f;
  float _254 = _249.x * 3.321928024291992f;
  float _255 = _251.x * 3.321928024291992f;
  float _256 = exp2(_253);
  float _257 = exp2(_254);
  float _258 = exp2(_255);
  float _259 = _256 / cb3_space9_036w;
  float _260 = _257 / cb3_space9_036w;
  float _261 = _258 / cb3_space9_036w;
  bool _262 = (cb3_space9_036y < 500.0f);
  float _300;
  float _301;
  float _302;
  float _352;
  float _360;
  float _368;
  if (_262) {
    float _264 = _259 * 0.6624541878700256f;
    float _265 = mad(0.13400420546531677f, _260, _264);
    float _266 = mad(0.15618768334388733f, _261, _265);
    float _267 = _259 * 0.2722287178039551f;
    float _268 = mad(0.6740817427635193f, _260, _267);
    float _269 = mad(0.053689517080783844f, _261, _268);
    float _270 = _259 * -0.005574649665504694f;
    float _271 = mad(0.00406073359772563f, _260, _270);
    float _272 = mad(1.0103391408920288f, _261, _271);
    float _273 = _269 + _266;
    float _274 = _273 + _272;
    bool _275 = (_274 == 0.0f);
    float _276 = select(_275, 1.000000013351432e-10f, _274);
    float _277 = _266 / _276;
    float _278 = _269 / _276;
    float _279 = max(_269, 0.0f);
    float _280 = log2(_279);
    float _281 = _280 * 0.9811000227928162f;
    float _282 = exp2(_281);
    float _283 = _282 * _277;
    float _284 = max(_278, 1.000000013351432e-10f);
    float _285 = _283 / _284;
    float _286 = 1.0f - _277;
    float _287 = _286 - _278;
    float _288 = _282 * _287;
    float _289 = _288 / _284;
    float _290 = _285 * 1.6410233974456787f;
    float _291 = mad(-0.32480329275131226f, _282, _290);
    float _292 = mad(-0.23642469942569733f, _289, _291);
    float _293 = _285 * -0.663662850856781f;
    float _294 = mad(1.6153316497802734f, _282, _293);
    float _295 = mad(0.016756348311901093f, _289, _294);
    float _296 = _285 * 0.011721894145011902f;
    float _297 = mad(-0.008284442126750946f, _282, _296);
    float _298 = mad(0.9883948564529419f, _289, _297);
    _300 = _292;
    _301 = _295;
    _302 = _298;
  } else {
    _300 = _259;
    _301 = _260;
    _302 = _261;
  }
  float _303 = _300 * 1.6047539710998535f;
  float _304 = mad(-0.5310794711112976f, _301, _303);
  float _305 = mad(-0.07367203384637833f, _302, _304);
  float _306 = _300 * -0.10208318382501602f;
  float _307 = mad(1.108132243156433f, _301, _306);
  float _308 = mad(-0.006051875650882721f, _302, _307);
  float _309 = _300 * -0.0032670421060174704f;
  float _310 = mad(-0.07275524735450745f, _301, _309);
  float _311 = mad(1.0760219097137451f, _302, _310);
  float _312 = max(_305, 0.0f);
  float _313 = max(_308, 0.0f);
  float _314 = max(_311, 0.0f);
  float _315 = _312 * ATTRIBUTE_VCOLOR.x;
  float _316 = _313 * ATTRIBUTE_VCOLOR.y;
  float _317 = _314 * ATTRIBUTE_VCOLOR.z;
  float _318 = abs(_315);
  float _319 = abs(_316);
  float _320 = abs(_317);
  float _321 = log2(_318);
  float _322 = log2(_319);
  float _323 = log2(_320);
  float _324 = _321 * 0.4166666567325592f;
  float _325 = _322 * 0.4166666567325592f;
  float _326 = _323 * 0.4166666567325592f;
  float _327 = exp2(_324);
  float _328 = exp2(_325);
  float _329 = exp2(_326);
  bool _330 = isfinite(_327);
  bool _331 = isfinite(_328);
  bool _332 = isfinite(_329);
  float _333 = _327 * 1.0549999475479126f;
  float _334 = _328 * 1.0549999475479126f;
  float _335 = _329 * 1.0549999475479126f;
  float _336 = _333 + -0.054999999701976776f;
  float _337 = select(_330, _336, 0.9999999403953552f);
  float _338 = _334 + -0.054999999701976776f;
  float _339 = select(_331, _338, 0.9999999403953552f);
  float _340 = _335 + -0.054999999701976776f;
  float _341 = select(_332, _340, 0.9999999403953552f);
  float _342 = _316 * 12.920000076293945f;
  float _343 = _317 * 12.920000076293945f;
  bool _344 = (_315 > 0.0031308000907301903f);
  if (!_344) {
    float _346 = _315 * 12.920000076293945f;
    bool _347 = (_315 < 0.0031308000907301903f);
    if (!_347) {
      bool _349 = (_315 == 0.0031308000907301903f);
      if (_349) {
        _352 = _337;
      } else {
        _352 = 0.0f;
      }
    } else {
      _352 = _346;
    }
  } else {
    _352 = _337;
  }
  bool _353 = (_316 > 0.0031308000907301903f);
  if (!_353) {
    bool _355 = (_316 < 0.0031308000907301903f);
    if (!_355) {
      bool _357 = (_316 == 0.0031308000907301903f);
      if (_357) {
        _360 = _339;
      } else {
        _360 = 0.0f;
      }
    } else {
      _360 = _342;
    }
  } else {
    _360 = _339;
  }
  bool _361 = (_317 > 0.0031308000907301903f);
  if (!_361) {
    bool _363 = (_317 < 0.0031308000907301903f);
    if (!_363) {
      bool _365 = (_317 == 0.0031308000907301903f);
      if (_365) {
        _368 = _341;
      } else {
        _368 = 0.0f;
      }
    } else {
      _368 = _343;
    }
  } else {
    _368 = _341;
  }
  float _369 = _40 - cb1_space9_034x;
  bool _370 = (_369 < 0.0f);
  if (_370) discard;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_142, _143, _144), 1.f);
    _352 = video.r;
    _360 = video.g;
    _368 = video.b;
  }
  float _376 = cb0_space5_008x * _352;
  float _377 = cb0_space5_008y * _360;
  float _378 = cb0_space5_008z * _368;
  float _379 = cb0_space5_008w * _40;
  float _380 = _376 * cb0_space5_008w;
  float _381 = _377 * cb0_space5_008w;
  float _382 = _378 * cb0_space5_008w;
  SV_Target.x = _380;
  SV_Target.y = _381;
  SV_Target.z = _382;
  SV_Target.w = _379;
  return SV_Target;
}

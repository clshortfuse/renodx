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
    linear float ATTRIBUTE_REFLECTION_DIST : ATTRIBUTE_REFLECTION_DIST,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  bool _24 = (ATTRIBUTE_REFLECTION_DIST < 0.0f);
  if (_24) discard;
  float _25 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _26 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _27 = _25 + 1.0f;
  float _28 = 1.0f - _26;
  float _29 = _27 * 0.5f;
  float _30 = _28 * 0.5f;
  float4 _33 = t29_space15.SampleBias(s0_space1, float2(_29, _30), cb1_space9_035z, int2(0, 0));
  float4 _37 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _39 = _33.x * ATTRIBUTE_VCOLOR.w;
  float _40 = _39 * _37.x;
  float _41 = max(_40, 0.0f);
  float _42 = min(1.0f, _41);
  float4 _45 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _47 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _49 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _51 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _55 = cb3_space9_038x * _47.x;
  float _57 = _55 + cb3_space9_038z;
  float _59 = cb3_space9_038y * _49.x;
  float _61 = _59 + cb3_space9_038w;
  float _62 = _51.x + _45.x;
  float _65 = cb3_space9_037x * _62;
  float _66 = _57 * 0.008609036915004253f;
  float _67 = _57 * 0.5600313544273376f;
  float _68 = _65 + _66;
  float _69 = _65 - _66;
  float _70 = _67 + _65;
  float _71 = _61 * 0.11102962493896484f;
  float _72 = _61 * 0.3206271827220917f;
  float _73 = _68 + _71;
  float _74 = _69 - _71;
  float _75 = _70 - _72;
  float _76 = max(_73, 0.0f);
  float _77 = max(_74, 0.0f);
  float _78 = max(_75, 0.0f);
  float _79 = log2(_76);
  float _80 = log2(_77);
  float _81 = log2(_78);
  float _82 = _79 * 0.012683313339948654f;
  float _83 = _80 * 0.012683313339948654f;
  float _84 = _81 * 0.012683313339948654f;
  float _85 = exp2(_82);
  float _86 = exp2(_83);
  float _87 = exp2(_84);
  float _88 = _85 + -0.8359375f;
  float _89 = _86 + -0.8359375f;
  float _90 = _87 + -0.8359375f;
  float _91 = max(0.0f, _88);
  float _92 = max(0.0f, _89);
  float _93 = max(0.0f, _90);
  float _94 = _85 * 18.6875f;
  float _95 = _86 * 18.6875f;
  float _96 = _87 * 18.6875f;
  float _97 = 18.8515625f - _94;
  float _98 = 18.8515625f - _95;
  float _99 = 18.8515625f - _96;
  float _100 = _91 / _97;
  float _101 = _92 / _98;
  float _102 = _93 / _99;
  float _103 = abs(_100);
  float _104 = abs(_101);
  float _105 = abs(_102);
  float _106 = log2(_103);
  float _107 = log2(_104);
  float _108 = log2(_105);
  float _109 = _106 * 6.277394771575928f;
  float _110 = _107 * 6.277394771575928f;
  float _111 = _108 * 6.277394771575928f;
  float _112 = exp2(_109);
  float _113 = exp2(_110);
  float _114 = exp2(_111);
  float _115 = _112 * 3.4366066455841064f;
  float _116 = _112 * 0.791329562664032f;
  float _117 = _113 * 2.5064520835876465f;
  float _118 = _113 * 1.9836004972457886f;
  float _119 = _113 * 0.09891371428966522f;
  float _120 = _115 - _117;
  float _121 = _118 - _116;
  float _122 = _112 * -0.02594989910721779f;
  float _123 = _122 - _119;
  float _124 = _114 * 0.06984542310237885f;
  float _125 = _114 * 0.192270889878273f;
  float _126 = _114 * 1.124863624572754f;
  float _127 = _120 + _124;
  float _128 = _121 - _125;
  float _129 = _123 + _126;
  float _131 = cb3_space9_037y * 368.6400146484375f;
  float _132 = _131 * _127;
  float _133 = _131 * _128;
  float _134 = _131 * _129;
  float _135 = max(_132, 9.999999747378752e-05f);
  float _136 = max(_133, 9.999999747378752e-05f);
  float _137 = max(_134, 9.999999747378752e-05f);
  float _141 = log2(_135);
  float _142 = log2(_136);
  float _143 = log2(_137);
  float _144 = _141 + 9.720000267028809f;
  float _145 = _142 + 9.720000267028809f;
  float _146 = _143 + 9.720000267028809f;
  float _147 = _144 * 0.03030303120613098f;
  float _148 = _145 * 0.03030303120613098f;
  float _149 = _146 * 0.03030303120613098f;
  float _150 = _147 + 0.23496760427951813f;
  float _151 = _148 + 0.23496760427951813f;
  float _152 = _149 + 0.23496760427951813f;
  uint3 _153;
  t40_space15.GetDimensions(_153.x, _153.y, _153.z);
  uint2 _157;
  t13_space15.GetDimensions(_157.x, _157.y);
  uint _159 = _153.x + -1u;
  uint _160 = _153.y + -1u;
  uint _161 = _153.z + -1u;
  float _162 = float((uint)_159);
  float _163 = float((uint)_160);
  float _164 = float((uint)_161);
  float _165 = float((uint)_153.x);
  float _166 = float((uint)_153.y);
  float _167 = float((uint)_153.z);
  float _168 = _162 / _165;
  float _169 = _163 / _166;
  float _170 = _164 / _167;
  float _171 = 0.5f / _165;
  float _172 = 0.5f / _166;
  float _173 = 0.5f / _167;
  float _174 = _168 * _150;
  float _175 = _169 * _151;
  float _176 = _170 * _152;
  float _177 = _171 + _174;
  float _178 = _172 + _175;
  float _179 = _173 + _176;
  float4 _180 = t40_space15.SampleLevel(s2_space1, float3(_177, _178, _179), 0.0f);
  float _183 = exp2(_141);
  float _184 = exp2(_142);
  float _185 = exp2(_143);
  float _186 = _183 * 0.6954522132873535f;
  float _187 = mad(0.14067870378494263f, _184, _186);
  float _188 = mad(0.16386906802654266f, _185, _187);
  float _189 = _183 * 0.044794563204050064f;
  float _190 = mad(0.8596711158752441f, _184, _189);
  float _191 = mad(0.0955343171954155f, _185, _190);
  float _192 = _183 * -0.005525882821530104f;
  float _193 = mad(0.004025210160762072f, _184, _192);
  float _194 = mad(1.0015007257461548f, _185, _193);
  float _195 = _180.x + 1.0f;
  float _196 = _188 * _195;
  float _197 = _191 * _195;
  float _198 = _194 * _195;
  float _199 = _196 + _180.y;
  float _200 = max(_199, 0.0f);
  float _201 = max(_197, 0.0f);
  float _202 = max(_198, 0.0f);
  float _203 = min(_200, 65536.0f);
  float _204 = min(_201, 65536.0f);
  float _205 = min(_202, 65536.0f);
  float _206 = _203 * 1.4514392614364624f;
  float _207 = mad(-0.2365107536315918f, _204, _206);
  float _208 = mad(-0.21492856740951538f, _205, _207);
  float _209 = _203 * -0.07655377686023712f;
  float _210 = mad(1.17622971534729f, _204, _209);
  float _211 = mad(-0.09967592358589172f, _205, _210);
  float _212 = _203 * 0.008316148072481155f;
  float _213 = mad(-0.006032449658960104f, _204, _212);
  float _214 = mad(0.9977163076400757f, _205, _213);
  float _215 = max(_208, 0.0f);
  float _216 = max(_211, 0.0f);
  float _217 = max(_214, 0.0f);
  float _218 = min(_215, 65504.0f);
  float _219 = min(_216, 65504.0f);
  float _220 = min(_217, 65504.0f);
  float _221 = _218 * 0.970889151096344f;
  float _222 = mad(0.026963284239172935f, _219, _221);
  float _223 = mad(0.0021475818939507008f, _220, _222);
  float _224 = _218 * 0.010889154858887196f;
  float _225 = mad(0.9869632720947266f, _219, _224);
  float _226 = mad(0.0021475818939507008f, _220, _225);
  float _227 = mad(0.026963284239172935f, _219, _224);
  float _228 = mad(0.9621475338935852f, _220, _227);
  float _229 = log2(_223);
  float _230 = log2(_226);
  float _231 = log2(_228);
  float _232 = _229 + 17.47393035888672f;
  float _233 = _230 + 17.47393035888672f;
  float _234 = _231 + 17.47393035888672f;
  float _235 = _232 * 0.03030303120613098f;
  float _236 = _233 * 0.03030303120613098f;
  float _237 = _234 * 0.03030303120613098f;
  uint _238 = _157.x + -1u;
  float _239 = float((uint)_238);
  float _240 = float((uint)_157.x);
  float _241 = _239 / _240;
  float _242 = 0.5f / _240;
  float _243 = _235 * _241;
  float _244 = _236 * _241;
  float _245 = _237 * _241;
  float _246 = _243 + _242;
  float _247 = _244 + _242;
  float _248 = _245 + _242;
  float4 _249 = t13_space15.SampleLevel(s2_space1, float2(_246, 0.5f), 0.0f);
  float4 _251 = t13_space15.SampleLevel(s2_space1, float2(_247, 0.5f), 0.0f);
  float4 _253 = t13_space15.SampleLevel(s2_space1, float2(_248, 0.5f), 0.0f);
  float _255 = _249.x * 3.321928024291992f;
  float _256 = _251.x * 3.321928024291992f;
  float _257 = _253.x * 3.321928024291992f;
  float _258 = exp2(_255);
  float _259 = exp2(_256);
  float _260 = exp2(_257);
  float _261 = _258 / cb3_space9_036w;
  float _262 = _259 / cb3_space9_036w;
  float _263 = _260 / cb3_space9_036w;
  bool _264 = (cb3_space9_036y < 500.0f);
  float _302;
  float _303;
  float _304;
  float _354;
  float _362;
  float _370;
  if (_264) {
    float _266 = _261 * 0.6624541878700256f;
    float _267 = mad(0.13400420546531677f, _262, _266);
    float _268 = mad(0.15618768334388733f, _263, _267);
    float _269 = _261 * 0.2722287178039551f;
    float _270 = mad(0.6740817427635193f, _262, _269);
    float _271 = mad(0.053689517080783844f, _263, _270);
    float _272 = _261 * -0.005574649665504694f;
    float _273 = mad(0.00406073359772563f, _262, _272);
    float _274 = mad(1.0103391408920288f, _263, _273);
    float _275 = _271 + _268;
    float _276 = _275 + _274;
    bool _277 = (_276 == 0.0f);
    float _278 = select(_277, 1.000000013351432e-10f, _276);
    float _279 = _268 / _278;
    float _280 = _271 / _278;
    float _281 = max(_271, 0.0f);
    float _282 = log2(_281);
    float _283 = _282 * 0.9811000227928162f;
    float _284 = exp2(_283);
    float _285 = _284 * _279;
    float _286 = max(_280, 1.000000013351432e-10f);
    float _287 = _285 / _286;
    float _288 = 1.0f - _279;
    float _289 = _288 - _280;
    float _290 = _284 * _289;
    float _291 = _290 / _286;
    float _292 = _287 * 1.6410233974456787f;
    float _293 = mad(-0.32480329275131226f, _284, _292);
    float _294 = mad(-0.23642469942569733f, _291, _293);
    float _295 = _287 * -0.663662850856781f;
    float _296 = mad(1.6153316497802734f, _284, _295);
    float _297 = mad(0.016756348311901093f, _291, _296);
    float _298 = _287 * 0.011721894145011902f;
    float _299 = mad(-0.008284442126750946f, _284, _298);
    float _300 = mad(0.9883948564529419f, _291, _299);
    _302 = _294;
    _303 = _297;
    _304 = _300;
  } else {
    _302 = _261;
    _303 = _262;
    _304 = _263;
  }
  float _305 = _302 * 1.6047539710998535f;
  float _306 = mad(-0.5310794711112976f, _303, _305);
  float _307 = mad(-0.07367203384637833f, _304, _306);
  float _308 = _302 * -0.10208318382501602f;
  float _309 = mad(1.108132243156433f, _303, _308);
  float _310 = mad(-0.006051875650882721f, _304, _309);
  float _311 = _302 * -0.0032670421060174704f;
  float _312 = mad(-0.07275524735450745f, _303, _311);
  float _313 = mad(1.0760219097137451f, _304, _312);
  float _314 = max(_307, 0.0f);
  float _315 = max(_310, 0.0f);
  float _316 = max(_313, 0.0f);
  float _317 = _314 * ATTRIBUTE_VCOLOR.x;
  float _318 = _315 * ATTRIBUTE_VCOLOR.y;
  float _319 = _316 * ATTRIBUTE_VCOLOR.z;
  float _320 = abs(_317);
  float _321 = abs(_318);
  float _322 = abs(_319);
  float _323 = log2(_320);
  float _324 = log2(_321);
  float _325 = log2(_322);
  float _326 = _323 * 0.4166666567325592f;
  float _327 = _324 * 0.4166666567325592f;
  float _328 = _325 * 0.4166666567325592f;
  float _329 = exp2(_326);
  float _330 = exp2(_327);
  float _331 = exp2(_328);
  bool _332 = isfinite(_329);
  bool _333 = isfinite(_330);
  bool _334 = isfinite(_331);
  float _335 = _329 * 1.0549999475479126f;
  float _336 = _330 * 1.0549999475479126f;
  float _337 = _331 * 1.0549999475479126f;
  float _338 = _335 + -0.054999999701976776f;
  float _339 = select(_332, _338, 0.9999999403953552f);
  float _340 = _336 + -0.054999999701976776f;
  float _341 = select(_333, _340, 0.9999999403953552f);
  float _342 = _337 + -0.054999999701976776f;
  float _343 = select(_334, _342, 0.9999999403953552f);
  float _344 = _318 * 12.920000076293945f;
  float _345 = _319 * 12.920000076293945f;
  bool _346 = (_317 > 0.0031308000907301903f);
  if (!_346) {
    float _348 = _317 * 12.920000076293945f;
    bool _349 = (_317 < 0.0031308000907301903f);
    if (!_349) {
      bool _351 = (_317 == 0.0031308000907301903f);
      if (_351) {
        _354 = _339;
      } else {
        _354 = 0.0f;
      }
    } else {
      _354 = _348;
    }
  } else {
    _354 = _339;
  }
  bool _355 = (_318 > 0.0031308000907301903f);
  if (!_355) {
    bool _357 = (_318 < 0.0031308000907301903f);
    if (!_357) {
      bool _359 = (_318 == 0.0031308000907301903f);
      if (_359) {
        _362 = _341;
      } else {
        _362 = 0.0f;
      }
    } else {
      _362 = _344;
    }
  } else {
    _362 = _341;
  }
  bool _363 = (_319 > 0.0031308000907301903f);
  if (!_363) {
    bool _365 = (_319 < 0.0031308000907301903f);
    if (!_365) {
      bool _367 = (_319 == 0.0031308000907301903f);
      if (_367) {
        _370 = _343;
      } else {
        _370 = 0.0f;
      }
    } else {
      _370 = _345;
    }
  } else {
    _370 = _343;
  }
  float _371 = _42 - cb1_space9_034x;
  bool _372 = (_371 < 0.0f);
  if (_372) discard;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_144, _145, _146), 1.f);
    _354 = video.r;
    _362 = video.g;
    _370 = video.b;
  }
  float _378 = cb0_space5_008x * _354;
  float _379 = cb0_space5_008y * _362;
  float _380 = cb0_space5_008z * _370;
  float _381 = cb0_space5_008w * _42;
  float _382 = _378 * cb0_space5_008w;
  float _383 = _379 * cb0_space5_008w;
  float _384 = _380 * cb0_space5_008w;
  SV_Target.x = _382;
  SV_Target.y = _383;
  SV_Target.z = _384;
  SV_Target.w = _381;
  return SV_Target;
}

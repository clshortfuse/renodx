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
    linear float4 ATTRIBUTE_INSTANCE_PARAMS : ATTRIBUTE_INSTANCE_PARAMS,
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
  float _35 = _33.x * ATTRIBUTE_VCOLOR.w;
  float _36 = max(_35, 0.0f);
  float _37 = min(1.0f, _36);
  float4 _42 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _44 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _46 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _48 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _52 = cb3_space9_038x * _44.x;
  float _54 = _52 + cb3_space9_038z;
  float _56 = cb3_space9_038y * _46.x;
  float _58 = _56 + cb3_space9_038w;
  float _59 = _48.x + _42.x;
  float _62 = cb3_space9_037x * _59;
  float _63 = _54 * 0.008609036915004253f;
  float _64 = _54 * 0.5600313544273376f;
  float _65 = _62 + _63;
  float _66 = _62 - _63;
  float _67 = _64 + _62;
  float _68 = _58 * 0.11102962493896484f;
  float _69 = _58 * 0.3206271827220917f;
  float _70 = _65 + _68;
  float _71 = _66 - _68;
  float _72 = _67 - _69;
  float _73 = max(_70, 0.0f);
  float _74 = max(_71, 0.0f);
  float _75 = max(_72, 0.0f);
  float _76 = log2(_73);
  float _77 = log2(_74);
  float _78 = log2(_75);
  float _79 = _76 * 0.012683313339948654f;
  float _80 = _77 * 0.012683313339948654f;
  float _81 = _78 * 0.012683313339948654f;
  float _82 = exp2(_79);
  float _83 = exp2(_80);
  float _84 = exp2(_81);
  float _85 = _82 + -0.8359375f;
  float _86 = _83 + -0.8359375f;
  float _87 = _84 + -0.8359375f;
  float _88 = max(0.0f, _85);
  float _89 = max(0.0f, _86);
  float _90 = max(0.0f, _87);
  float _91 = _82 * 18.6875f;
  float _92 = _83 * 18.6875f;
  float _93 = _84 * 18.6875f;
  float _94 = 18.8515625f - _91;
  float _95 = 18.8515625f - _92;
  float _96 = 18.8515625f - _93;
  float _97 = _88 / _94;
  float _98 = _89 / _95;
  float _99 = _90 / _96;
  float _100 = abs(_97);
  float _101 = abs(_98);
  float _102 = abs(_99);
  float _103 = log2(_100);
  float _104 = log2(_101);
  float _105 = log2(_102);
  float _106 = _103 * 6.277394771575928f;
  float _107 = _104 * 6.277394771575928f;
  float _108 = _105 * 6.277394771575928f;
  float _109 = exp2(_106);
  float _110 = exp2(_107);
  float _111 = exp2(_108);
  float _112 = _109 * 3.4366066455841064f;
  float _113 = _109 * 0.791329562664032f;
  float _114 = _110 * 2.5064520835876465f;
  float _115 = _110 * 1.9836004972457886f;
  float _116 = _110 * 0.09891371428966522f;
  float _117 = _112 - _114;
  float _118 = _115 - _113;
  float _119 = _109 * -0.02594989910721779f;
  float _120 = _119 - _116;
  float _121 = _111 * 0.06984542310237885f;
  float _122 = _111 * 0.192270889878273f;
  float _123 = _111 * 1.124863624572754f;
  float _124 = _117 + _121;
  float _125 = _118 - _122;
  float _126 = _120 + _123;
  float _128 = cb3_space9_037y * 368.6400146484375f;
  float _129 = _128 * _124;
  float _130 = _128 * _125;
  float _131 = _128 * _126;
  float _132 = max(_129, 9.999999747378752e-05f);
  float _133 = max(_130, 9.999999747378752e-05f);
  float _134 = max(_131, 9.999999747378752e-05f);
  float _138 = log2(_132);
  float _139 = log2(_133);
  float _140 = log2(_134);
  float _141 = _138 + 9.720000267028809f;
  float _142 = _139 + 9.720000267028809f;
  float _143 = _140 + 9.720000267028809f;
  float _144 = _141 * 0.03030303120613098f;
  float _145 = _142 * 0.03030303120613098f;
  float _146 = _143 * 0.03030303120613098f;
  float _147 = _144 + 0.23496760427951813f;
  float _148 = _145 + 0.23496760427951813f;
  float _149 = _146 + 0.23496760427951813f;
  uint3 _150;
  t40_space15.GetDimensions(_150.x, _150.y, _150.z);
  uint2 _154;
  t13_space15.GetDimensions(_154.x, _154.y);
  uint _156 = _150.x + -1u;
  uint _157 = _150.y + -1u;
  uint _158 = _150.z + -1u;
  float _159 = float((uint)_156);
  float _160 = float((uint)_157);
  float _161 = float((uint)_158);
  float _162 = float((uint)_150.x);
  float _163 = float((uint)_150.y);
  float _164 = float((uint)_150.z);
  float _165 = _159 / _162;
  float _166 = _160 / _163;
  float _167 = _161 / _164;
  float _168 = 0.5f / _162;
  float _169 = 0.5f / _163;
  float _170 = 0.5f / _164;
  float _171 = _165 * _147;
  float _172 = _166 * _148;
  float _173 = _167 * _149;
  float _174 = _168 + _171;
  float _175 = _169 + _172;
  float _176 = _170 + _173;
  float4 _177 = t40_space15.SampleLevel(s2_space1, float3(_174, _175, _176), 0.0f);
  float _180 = exp2(_138);
  float _181 = exp2(_139);
  float _182 = exp2(_140);
  float _183 = _180 * 0.6954522132873535f;
  float _184 = mad(0.14067870378494263f, _181, _183);
  float _185 = mad(0.16386906802654266f, _182, _184);
  float _186 = _180 * 0.044794563204050064f;
  float _187 = mad(0.8596711158752441f, _181, _186);
  float _188 = mad(0.0955343171954155f, _182, _187);
  float _189 = _180 * -0.005525882821530104f;
  float _190 = mad(0.004025210160762072f, _181, _189);
  float _191 = mad(1.0015007257461548f, _182, _190);
  float _192 = _177.x + 1.0f;
  float _193 = _185 * _192;
  float _194 = _188 * _192;
  float _195 = _191 * _192;
  float _196 = _193 + _177.y;
  float _197 = max(_196, 0.0f);
  float _198 = max(_194, 0.0f);
  float _199 = max(_195, 0.0f);
  float _200 = min(_197, 65536.0f);
  float _201 = min(_198, 65536.0f);
  float _202 = min(_199, 65536.0f);
  float _203 = _200 * 1.4514392614364624f;
  float _204 = mad(-0.2365107536315918f, _201, _203);
  float _205 = mad(-0.21492856740951538f, _202, _204);
  float _206 = _200 * -0.07655377686023712f;
  float _207 = mad(1.17622971534729f, _201, _206);
  float _208 = mad(-0.09967592358589172f, _202, _207);
  float _209 = _200 * 0.008316148072481155f;
  float _210 = mad(-0.006032449658960104f, _201, _209);
  float _211 = mad(0.9977163076400757f, _202, _210);
  float _212 = max(_205, 0.0f);
  float _213 = max(_208, 0.0f);
  float _214 = max(_211, 0.0f);
  float _215 = min(_212, 65504.0f);
  float _216 = min(_213, 65504.0f);
  float _217 = min(_214, 65504.0f);
  float _218 = _215 * 0.970889151096344f;
  float _219 = mad(0.026963284239172935f, _216, _218);
  float _220 = mad(0.0021475818939507008f, _217, _219);
  float _221 = _215 * 0.010889154858887196f;
  float _222 = mad(0.9869632720947266f, _216, _221);
  float _223 = mad(0.0021475818939507008f, _217, _222);
  float _224 = mad(0.026963284239172935f, _216, _221);
  float _225 = mad(0.9621475338935852f, _217, _224);
  float _226 = log2(_220);
  float _227 = log2(_223);
  float _228 = log2(_225);
  float _229 = _226 + 17.47393035888672f;
  float _230 = _227 + 17.47393035888672f;
  float _231 = _228 + 17.47393035888672f;
  float _232 = _229 * 0.03030303120613098f;
  float _233 = _230 * 0.03030303120613098f;
  float _234 = _231 * 0.03030303120613098f;
  uint _235 = _154.x + -1u;
  float _236 = float((uint)_235);
  float _237 = float((uint)_154.x);
  float _238 = _236 / _237;
  float _239 = 0.5f / _237;
  float _240 = _232 * _238;
  float _241 = _233 * _238;
  float _242 = _234 * _238;
  float _243 = _240 + _239;
  float _244 = _241 + _239;
  float _245 = _242 + _239;
  float4 _246 = t13_space15.SampleLevel(s2_space1, float2(_243, 0.5f), 0.0f);
  float4 _248 = t13_space15.SampleLevel(s2_space1, float2(_244, 0.5f), 0.0f);
  float4 _250 = t13_space15.SampleLevel(s2_space1, float2(_245, 0.5f), 0.0f);
  float _252 = _246.x * 3.321928024291992f;
  float _253 = _248.x * 3.321928024291992f;
  float _254 = _250.x * 3.321928024291992f;
  float _255 = exp2(_252);
  float _256 = exp2(_253);
  float _257 = exp2(_254);
  float _258 = _255 / cb3_space9_036w;
  float _259 = _256 / cb3_space9_036w;
  float _260 = _257 / cb3_space9_036w;
  bool _261 = (cb3_space9_036y < 500.0f);
  float _299;
  float _300;
  float _301;
  float _351;
  float _359;
  float _367;
  if (_261) {
    float _263 = _258 * 0.6624541878700256f;
    float _264 = mad(0.13400420546531677f, _259, _263);
    float _265 = mad(0.15618768334388733f, _260, _264);
    float _266 = _258 * 0.2722287178039551f;
    float _267 = mad(0.6740817427635193f, _259, _266);
    float _268 = mad(0.053689517080783844f, _260, _267);
    float _269 = _258 * -0.005574649665504694f;
    float _270 = mad(0.00406073359772563f, _259, _269);
    float _271 = mad(1.0103391408920288f, _260, _270);
    float _272 = _268 + _265;
    float _273 = _272 + _271;
    bool _274 = (_273 == 0.0f);
    float _275 = select(_274, 1.000000013351432e-10f, _273);
    float _276 = _265 / _275;
    float _277 = _268 / _275;
    float _278 = max(_268, 0.0f);
    float _279 = log2(_278);
    float _280 = _279 * 0.9811000227928162f;
    float _281 = exp2(_280);
    float _282 = _281 * _276;
    float _283 = max(_277, 1.000000013351432e-10f);
    float _284 = _282 / _283;
    float _285 = 1.0f - _276;
    float _286 = _285 - _277;
    float _287 = _281 * _286;
    float _288 = _287 / _283;
    float _289 = _284 * 1.6410233974456787f;
    float _290 = mad(-0.32480329275131226f, _281, _289);
    float _291 = mad(-0.23642469942569733f, _288, _290);
    float _292 = _284 * -0.663662850856781f;
    float _293 = mad(1.6153316497802734f, _281, _292);
    float _294 = mad(0.016756348311901093f, _288, _293);
    float _295 = _284 * 0.011721894145011902f;
    float _296 = mad(-0.008284442126750946f, _281, _295);
    float _297 = mad(0.9883948564529419f, _288, _296);
    _299 = _291;
    _300 = _294;
    _301 = _297;
  } else {
    _299 = _258;
    _300 = _259;
    _301 = _260;
  }
  float _302 = _299 * 1.6047539710998535f;
  float _303 = mad(-0.5310794711112976f, _300, _302);
  float _304 = mad(-0.07367203384637833f, _301, _303);
  float _305 = _299 * -0.10208318382501602f;
  float _306 = mad(1.108132243156433f, _300, _305);
  float _307 = mad(-0.006051875650882721f, _301, _306);
  float _308 = _299 * -0.0032670421060174704f;
  float _309 = mad(-0.07275524735450745f, _300, _308);
  float _310 = mad(1.0760219097137451f, _301, _309);
  float _311 = max(_304, 0.0f);
  float _312 = max(_307, 0.0f);
  float _313 = max(_310, 0.0f);
  float _314 = _311 * ATTRIBUTE_VCOLOR.x;
  float _315 = _312 * ATTRIBUTE_VCOLOR.y;
  float _316 = _313 * ATTRIBUTE_VCOLOR.z;
  float _317 = abs(_314);
  float _318 = abs(_315);
  float _319 = abs(_316);
  float _320 = log2(_317);
  float _321 = log2(_318);
  float _322 = log2(_319);
  float _323 = _320 * 0.4166666567325592f;
  float _324 = _321 * 0.4166666567325592f;
  float _325 = _322 * 0.4166666567325592f;
  float _326 = exp2(_323);
  float _327 = exp2(_324);
  float _328 = exp2(_325);
  bool _329 = isfinite(_326);
  bool _330 = isfinite(_327);
  bool _331 = isfinite(_328);
  float _332 = _326 * 1.0549999475479126f;
  float _333 = _327 * 1.0549999475479126f;
  float _334 = _328 * 1.0549999475479126f;
  float _335 = _332 + -0.054999999701976776f;
  float _336 = select(_329, _335, 0.9999999403953552f);
  float _337 = _333 + -0.054999999701976776f;
  float _338 = select(_330, _337, 0.9999999403953552f);
  float _339 = _334 + -0.054999999701976776f;
  float _340 = select(_331, _339, 0.9999999403953552f);
  float _341 = _315 * 12.920000076293945f;
  float _342 = _316 * 12.920000076293945f;
  bool _343 = (_314 > 0.0031308000907301903f);
  if (!_343) {
    float _345 = _314 * 12.920000076293945f;
    bool _346 = (_314 < 0.0031308000907301903f);
    if (!_346) {
      bool _348 = (_314 == 0.0031308000907301903f);
      if (_348) {
        _351 = _336;
      } else {
        _351 = 0.0f;
      }
    } else {
      _351 = _345;
    }
  } else {
    _351 = _336;
  }
  bool _352 = (_315 > 0.0031308000907301903f);
  if (!_352) {
    bool _354 = (_315 < 0.0031308000907301903f);
    if (!_354) {
      bool _356 = (_315 == 0.0031308000907301903f);
      if (_356) {
        _359 = _338;
      } else {
        _359 = 0.0f;
      }
    } else {
      _359 = _341;
    }
  } else {
    _359 = _338;
  }
  bool _360 = (_316 > 0.0031308000907301903f);
  if (!_360) {
    bool _362 = (_316 < 0.0031308000907301903f);
    if (!_362) {
      bool _364 = (_316 == 0.0031308000907301903f);
      if (_364) {
        _367 = _340;
      } else {
        _367 = 0.0f;
      }
    } else {
      _367 = _342;
    }
  } else {
    _367 = _340;
  }
  float _368 = _37 - cb1_space9_034x;
  bool _369 = (_368 < 0.0f);
  if (_369) discard;
  float _375 = _37 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _376 = _375 * cb0_space5_008w;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_141, _142, _143), 1.f);
    _351 = video.r;
    _359 = video.g;
    _367 = video.b;
  }
  float _377 = _351 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _378 = _377 * cb0_space5_008x;
  float _379 = _378 * cb0_space5_008w;
  float _380 = _359 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _381 = _380 * cb0_space5_008y;
  float _382 = _381 * cb0_space5_008w;
  float _383 = _367 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _384 = _383 * cb0_space5_008z;
  float _385 = _384 * cb0_space5_008w;
  SV_Target.x = _379;
  SV_Target.y = _382;
  SV_Target.z = _385;
  SV_Target.w = _376;
  return SV_Target;
}

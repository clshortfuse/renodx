#include "../tonemap/tonemap.hlsli"

// rl_default_primitive_bink_hdr_alpha: HDR10 Bink video (PQ decode -> AP1) tone mapped with the vanilla ACES chain (t40/t13, space15).
// The RenoDX path replaces the sRGB-encoded result after the discard, before the vanilla tint and alpha.

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
    linear float4 ATTRIBUTE_INSTANCE_PARAMS : ATTRIBUTE_INSTANCE_PARAMS,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  float4 _22 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _24 = _22.x * ATTRIBUTE_VCOLOR.w;
  float _25 = max(_24, 0.0f);
  float _26 = min(1.0f, _25);
  float4 _29 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _31 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _33 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _35 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _39 = cb3_space9_038x * _31.x;
  float _41 = _39 + cb3_space9_038z;
  float _43 = cb3_space9_038y * _33.x;
  float _45 = _43 + cb3_space9_038w;
  float _46 = _35.x + _29.x;
  float _49 = cb3_space9_037x * _46;
  float _50 = _41 * 0.008609036915004253f;
  float _51 = _41 * 0.5600313544273376f;
  float _52 = _49 + _50;
  float _53 = _49 - _50;
  float _54 = _51 + _49;
  float _55 = _45 * 0.11102962493896484f;
  float _56 = _45 * 0.3206271827220917f;
  float _57 = _52 + _55;
  float _58 = _53 - _55;
  float _59 = _54 - _56;
  float _60 = max(_57, 0.0f);
  float _61 = max(_58, 0.0f);
  float _62 = max(_59, 0.0f);
  float _63 = log2(_60);
  float _64 = log2(_61);
  float _65 = log2(_62);
  float _66 = _63 * 0.012683313339948654f;
  float _67 = _64 * 0.012683313339948654f;
  float _68 = _65 * 0.012683313339948654f;
  float _69 = exp2(_66);
  float _70 = exp2(_67);
  float _71 = exp2(_68);
  float _72 = _69 + -0.8359375f;
  float _73 = _70 + -0.8359375f;
  float _74 = _71 + -0.8359375f;
  float _75 = max(0.0f, _72);
  float _76 = max(0.0f, _73);
  float _77 = max(0.0f, _74);
  float _78 = _69 * 18.6875f;
  float _79 = _70 * 18.6875f;
  float _80 = _71 * 18.6875f;
  float _81 = 18.8515625f - _78;
  float _82 = 18.8515625f - _79;
  float _83 = 18.8515625f - _80;
  float _84 = _75 / _81;
  float _85 = _76 / _82;
  float _86 = _77 / _83;
  float _87 = abs(_84);
  float _88 = abs(_85);
  float _89 = abs(_86);
  float _90 = log2(_87);
  float _91 = log2(_88);
  float _92 = log2(_89);
  float _93 = _90 * 6.277394771575928f;
  float _94 = _91 * 6.277394771575928f;
  float _95 = _92 * 6.277394771575928f;
  float _96 = exp2(_93);
  float _97 = exp2(_94);
  float _98 = exp2(_95);
  float _99 = _96 * 3.4366066455841064f;
  float _100 = _96 * 0.791329562664032f;
  float _101 = _97 * 2.5064520835876465f;
  float _102 = _97 * 1.9836004972457886f;
  float _103 = _97 * 0.09891371428966522f;
  float _104 = _99 - _101;
  float _105 = _102 - _100;
  float _106 = _96 * -0.02594989910721779f;
  float _107 = _106 - _103;
  float _108 = _98 * 0.06984542310237885f;
  float _109 = _98 * 0.192270889878273f;
  float _110 = _98 * 1.124863624572754f;
  float _111 = _104 + _108;
  float _112 = _105 - _109;
  float _113 = _107 + _110;
  float _115 = cb3_space9_037y * 368.6400146484375f;
  float _116 = _115 * _111;
  float _117 = _115 * _112;
  float _118 = _115 * _113;
  float _119 = max(_116, 9.999999747378752e-05f);
  float _120 = max(_117, 9.999999747378752e-05f);
  float _121 = max(_118, 9.999999747378752e-05f);
  float _125 = log2(_119);
  float _126 = log2(_120);
  float _127 = log2(_121);
  float _128 = _125 + 9.720000267028809f;
  float _129 = _126 + 9.720000267028809f;
  float _130 = _127 + 9.720000267028809f;
  float _131 = _128 * 0.03030303120613098f;
  float _132 = _129 * 0.03030303120613098f;
  float _133 = _130 * 0.03030303120613098f;
  float _134 = _131 + 0.23496760427951813f;
  float _135 = _132 + 0.23496760427951813f;
  float _136 = _133 + 0.23496760427951813f;
  uint3 _137;
  t40_space15.GetDimensions(_137.x, _137.y, _137.z);
  uint2 _141;
  t13_space15.GetDimensions(_141.x, _141.y);
  uint _143 = _137.x + -1u;
  uint _144 = _137.y + -1u;
  uint _145 = _137.z + -1u;
  float _146 = float((uint)_143);
  float _147 = float((uint)_144);
  float _148 = float((uint)_145);
  float _149 = float((uint)_137.x);
  float _150 = float((uint)_137.y);
  float _151 = float((uint)_137.z);
  float _152 = _146 / _149;
  float _153 = _147 / _150;
  float _154 = _148 / _151;
  float _155 = 0.5f / _149;
  float _156 = 0.5f / _150;
  float _157 = 0.5f / _151;
  float _158 = _152 * _134;
  float _159 = _153 * _135;
  float _160 = _154 * _136;
  float _161 = _155 + _158;
  float _162 = _156 + _159;
  float _163 = _157 + _160;
  float4 _164 = t40_space15.SampleLevel(s2_space1, float3(_161, _162, _163), 0.0f);
  float _167 = exp2(_125);
  float _168 = exp2(_126);
  float _169 = exp2(_127);
  float _170 = _167 * 0.6954522132873535f;
  float _171 = mad(0.14067870378494263f, _168, _170);
  float _172 = mad(0.16386906802654266f, _169, _171);
  float _173 = _167 * 0.044794563204050064f;
  float _174 = mad(0.8596711158752441f, _168, _173);
  float _175 = mad(0.0955343171954155f, _169, _174);
  float _176 = _167 * -0.005525882821530104f;
  float _177 = mad(0.004025210160762072f, _168, _176);
  float _178 = mad(1.0015007257461548f, _169, _177);
  float _179 = _164.x + 1.0f;
  float _180 = _172 * _179;
  float _181 = _175 * _179;
  float _182 = _178 * _179;
  float _183 = _180 + _164.y;
  float _184 = max(_183, 0.0f);
  float _185 = max(_181, 0.0f);
  float _186 = max(_182, 0.0f);
  float _187 = min(_184, 65536.0f);
  float _188 = min(_185, 65536.0f);
  float _189 = min(_186, 65536.0f);
  float _190 = _187 * 1.4514392614364624f;
  float _191 = mad(-0.2365107536315918f, _188, _190);
  float _192 = mad(-0.21492856740951538f, _189, _191);
  float _193 = _187 * -0.07655377686023712f;
  float _194 = mad(1.17622971534729f, _188, _193);
  float _195 = mad(-0.09967592358589172f, _189, _194);
  float _196 = _187 * 0.008316148072481155f;
  float _197 = mad(-0.006032449658960104f, _188, _196);
  float _198 = mad(0.9977163076400757f, _189, _197);
  float _199 = max(_192, 0.0f);
  float _200 = max(_195, 0.0f);
  float _201 = max(_198, 0.0f);
  float _202 = min(_199, 65504.0f);
  float _203 = min(_200, 65504.0f);
  float _204 = min(_201, 65504.0f);
  float _205 = _202 * 0.970889151096344f;
  float _206 = mad(0.026963284239172935f, _203, _205);
  float _207 = mad(0.0021475818939507008f, _204, _206);
  float _208 = _202 * 0.010889154858887196f;
  float _209 = mad(0.9869632720947266f, _203, _208);
  float _210 = mad(0.0021475818939507008f, _204, _209);
  float _211 = mad(0.026963284239172935f, _203, _208);
  float _212 = mad(0.9621475338935852f, _204, _211);
  float _213 = log2(_207);
  float _214 = log2(_210);
  float _215 = log2(_212);
  float _216 = _213 + 17.47393035888672f;
  float _217 = _214 + 17.47393035888672f;
  float _218 = _215 + 17.47393035888672f;
  float _219 = _216 * 0.03030303120613098f;
  float _220 = _217 * 0.03030303120613098f;
  float _221 = _218 * 0.03030303120613098f;
  uint _222 = _141.x + -1u;
  float _223 = float((uint)_222);
  float _224 = float((uint)_141.x);
  float _225 = _223 / _224;
  float _226 = 0.5f / _224;
  float _227 = _219 * _225;
  float _228 = _220 * _225;
  float _229 = _221 * _225;
  float _230 = _227 + _226;
  float _231 = _228 + _226;
  float _232 = _229 + _226;
  float4 _233 = t13_space15.SampleLevel(s2_space1, float2(_230, 0.5f), 0.0f);
  float4 _235 = t13_space15.SampleLevel(s2_space1, float2(_231, 0.5f), 0.0f);
  float4 _237 = t13_space15.SampleLevel(s2_space1, float2(_232, 0.5f), 0.0f);
  float _239 = _233.x * 3.321928024291992f;
  float _240 = _235.x * 3.321928024291992f;
  float _241 = _237.x * 3.321928024291992f;
  float _242 = exp2(_239);
  float _243 = exp2(_240);
  float _244 = exp2(_241);
  float _245 = _242 / cb3_space9_036w;
  float _246 = _243 / cb3_space9_036w;
  float _247 = _244 / cb3_space9_036w;
  bool _248 = (cb3_space9_036y < 500.0f);
  float _286;
  float _287;
  float _288;
  float _338;
  float _346;
  float _354;
  if (_248) {
    float _250 = _245 * 0.6624541878700256f;
    float _251 = mad(0.13400420546531677f, _246, _250);
    float _252 = mad(0.15618768334388733f, _247, _251);
    float _253 = _245 * 0.2722287178039551f;
    float _254 = mad(0.6740817427635193f, _246, _253);
    float _255 = mad(0.053689517080783844f, _247, _254);
    float _256 = _245 * -0.005574649665504694f;
    float _257 = mad(0.00406073359772563f, _246, _256);
    float _258 = mad(1.0103391408920288f, _247, _257);
    float _259 = _255 + _252;
    float _260 = _259 + _258;
    bool _261 = (_260 == 0.0f);
    float _262 = select(_261, 1.000000013351432e-10f, _260);
    float _263 = _252 / _262;
    float _264 = _255 / _262;
    float _265 = max(_255, 0.0f);
    float _266 = log2(_265);
    float _267 = _266 * 0.9811000227928162f;
    float _268 = exp2(_267);
    float _269 = _268 * _263;
    float _270 = max(_264, 1.000000013351432e-10f);
    float _271 = _269 / _270;
    float _272 = 1.0f - _263;
    float _273 = _272 - _264;
    float _274 = _268 * _273;
    float _275 = _274 / _270;
    float _276 = _271 * 1.6410233974456787f;
    float _277 = mad(-0.32480329275131226f, _268, _276);
    float _278 = mad(-0.23642469942569733f, _275, _277);
    float _279 = _271 * -0.663662850856781f;
    float _280 = mad(1.6153316497802734f, _268, _279);
    float _281 = mad(0.016756348311901093f, _275, _280);
    float _282 = _271 * 0.011721894145011902f;
    float _283 = mad(-0.008284442126750946f, _268, _282);
    float _284 = mad(0.9883948564529419f, _275, _283);
    _286 = _278;
    _287 = _281;
    _288 = _284;
  } else {
    _286 = _245;
    _287 = _246;
    _288 = _247;
  }
  float _289 = _286 * 1.6047539710998535f;
  float _290 = mad(-0.5310794711112976f, _287, _289);
  float _291 = mad(-0.07367203384637833f, _288, _290);
  float _292 = _286 * -0.10208318382501602f;
  float _293 = mad(1.108132243156433f, _287, _292);
  float _294 = mad(-0.006051875650882721f, _288, _293);
  float _295 = _286 * -0.0032670421060174704f;
  float _296 = mad(-0.07275524735450745f, _287, _295);
  float _297 = mad(1.0760219097137451f, _288, _296);
  float _298 = max(_291, 0.0f);
  float _299 = max(_294, 0.0f);
  float _300 = max(_297, 0.0f);
  float _301 = _298 * ATTRIBUTE_VCOLOR.x;
  float _302 = _299 * ATTRIBUTE_VCOLOR.y;
  float _303 = _300 * ATTRIBUTE_VCOLOR.z;
  float _304 = abs(_301);
  float _305 = abs(_302);
  float _306 = abs(_303);
  float _307 = log2(_304);
  float _308 = log2(_305);
  float _309 = log2(_306);
  float _310 = _307 * 0.4166666567325592f;
  float _311 = _308 * 0.4166666567325592f;
  float _312 = _309 * 0.4166666567325592f;
  float _313 = exp2(_310);
  float _314 = exp2(_311);
  float _315 = exp2(_312);
  bool _316 = isfinite(_313);
  bool _317 = isfinite(_314);
  bool _318 = isfinite(_315);
  float _319 = _313 * 1.0549999475479126f;
  float _320 = _314 * 1.0549999475479126f;
  float _321 = _315 * 1.0549999475479126f;
  float _322 = _319 + -0.054999999701976776f;
  float _323 = select(_316, _322, 0.9999999403953552f);
  float _324 = _320 + -0.054999999701976776f;
  float _325 = select(_317, _324, 0.9999999403953552f);
  float _326 = _321 + -0.054999999701976776f;
  float _327 = select(_318, _326, 0.9999999403953552f);
  float _328 = _302 * 12.920000076293945f;
  float _329 = _303 * 12.920000076293945f;
  bool _330 = (_301 > 0.0031308000907301903f);
  if (!_330) {
    float _332 = _301 * 12.920000076293945f;
    bool _333 = (_301 < 0.0031308000907301903f);
    if (!_333) {
      bool _335 = (_301 == 0.0031308000907301903f);
      if (_335) {
        _338 = _323;
      } else {
        _338 = 0.0f;
      }
    } else {
      _338 = _332;
    }
  } else {
    _338 = _323;
  }
  bool _339 = (_302 > 0.0031308000907301903f);
  if (!_339) {
    bool _341 = (_302 < 0.0031308000907301903f);
    if (!_341) {
      bool _343 = (_302 == 0.0031308000907301903f);
      if (_343) {
        _346 = _325;
      } else {
        _346 = 0.0f;
      }
    } else {
      _346 = _328;
    }
  } else {
    _346 = _325;
  }
  bool _347 = (_303 > 0.0031308000907301903f);
  if (!_347) {
    bool _349 = (_303 < 0.0031308000907301903f);
    if (!_349) {
      bool _351 = (_303 == 0.0031308000907301903f);
      if (_351) {
        _354 = _327;
      } else {
        _354 = 0.0f;
      }
    } else {
      _354 = _329;
    }
  } else {
    _354 = _327;
  }
  float _355 = _26 - cb1_space9_034x;
  bool _356 = (_355 < 0.0f);
  if (_356) discard;
  float _362 = _26 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _363 = _362 * cb0_space5_008w;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_128, _129, _130), 1.f);
    _338 = video.r;
    _346 = video.g;
    _354 = video.b;
  }
  float _364 = _338 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _365 = _364 * cb0_space5_008x;
  float _366 = _365 * cb0_space5_008w;
  float _367 = _346 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _368 = _367 * cb0_space5_008y;
  float _369 = _368 * cb0_space5_008w;
  float _370 = _354 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _371 = _370 * cb0_space5_008z;
  float _372 = _371 * cb0_space5_008w;
  SV_Target.x = _366;
  SV_Target.y = _369;
  SV_Target.z = _372;
  SV_Target.w = _363;
  return SV_Target;
}

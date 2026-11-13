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
    linear float ATTRIBUTE_REFLECTION_DIST : ATTRIBUTE_REFLECTION_DIST,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    linear float4 ATTRIBUTE_INSTANCE_PARAMS : ATTRIBUTE_INSTANCE_PARAMS,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  bool _21 = (ATTRIBUTE_REFLECTION_DIST < 0.0f);
  if (_21) discard;
  float4 _24 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _26 = _24.x * ATTRIBUTE_VCOLOR.w;
  float _27 = max(_26, 0.0f);
  float _28 = min(1.0f, _27);
  float4 _31 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _33 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _35 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _37 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _41 = cb3_space9_038x * _33.x;
  float _43 = _41 + cb3_space9_038z;
  float _45 = cb3_space9_038y * _35.x;
  float _47 = _45 + cb3_space9_038w;
  float _48 = _37.x + _31.x;
  float _51 = cb3_space9_037x * _48;
  float _52 = _43 * 0.008609036915004253f;
  float _53 = _43 * 0.5600313544273376f;
  float _54 = _51 + _52;
  float _55 = _51 - _52;
  float _56 = _53 + _51;
  float _57 = _47 * 0.11102962493896484f;
  float _58 = _47 * 0.3206271827220917f;
  float _59 = _54 + _57;
  float _60 = _55 - _57;
  float _61 = _56 - _58;
  float _62 = max(_59, 0.0f);
  float _63 = max(_60, 0.0f);
  float _64 = max(_61, 0.0f);
  float _65 = log2(_62);
  float _66 = log2(_63);
  float _67 = log2(_64);
  float _68 = _65 * 0.012683313339948654f;
  float _69 = _66 * 0.012683313339948654f;
  float _70 = _67 * 0.012683313339948654f;
  float _71 = exp2(_68);
  float _72 = exp2(_69);
  float _73 = exp2(_70);
  float _74 = _71 + -0.8359375f;
  float _75 = _72 + -0.8359375f;
  float _76 = _73 + -0.8359375f;
  float _77 = max(0.0f, _74);
  float _78 = max(0.0f, _75);
  float _79 = max(0.0f, _76);
  float _80 = _71 * 18.6875f;
  float _81 = _72 * 18.6875f;
  float _82 = _73 * 18.6875f;
  float _83 = 18.8515625f - _80;
  float _84 = 18.8515625f - _81;
  float _85 = 18.8515625f - _82;
  float _86 = _77 / _83;
  float _87 = _78 / _84;
  float _88 = _79 / _85;
  float _89 = abs(_86);
  float _90 = abs(_87);
  float _91 = abs(_88);
  float _92 = log2(_89);
  float _93 = log2(_90);
  float _94 = log2(_91);
  float _95 = _92 * 6.277394771575928f;
  float _96 = _93 * 6.277394771575928f;
  float _97 = _94 * 6.277394771575928f;
  float _98 = exp2(_95);
  float _99 = exp2(_96);
  float _100 = exp2(_97);
  float _101 = _98 * 3.4366066455841064f;
  float _102 = _98 * 0.791329562664032f;
  float _103 = _99 * 2.5064520835876465f;
  float _104 = _99 * 1.9836004972457886f;
  float _105 = _99 * 0.09891371428966522f;
  float _106 = _101 - _103;
  float _107 = _104 - _102;
  float _108 = _98 * -0.02594989910721779f;
  float _109 = _108 - _105;
  float _110 = _100 * 0.06984542310237885f;
  float _111 = _100 * 0.192270889878273f;
  float _112 = _100 * 1.124863624572754f;
  float _113 = _106 + _110;
  float _114 = _107 - _111;
  float _115 = _109 + _112;
  float _117 = cb3_space9_037y * 368.6400146484375f;
  float _118 = _117 * _113;
  float _119 = _117 * _114;
  float _120 = _117 * _115;
  float _121 = max(_118, 9.999999747378752e-05f);
  float _122 = max(_119, 9.999999747378752e-05f);
  float _123 = max(_120, 9.999999747378752e-05f);
  float _127 = log2(_121);
  float _128 = log2(_122);
  float _129 = log2(_123);
  float _130 = _127 + 9.720000267028809f;
  float _131 = _128 + 9.720000267028809f;
  float _132 = _129 + 9.720000267028809f;
  float _133 = _130 * 0.03030303120613098f;
  float _134 = _131 * 0.03030303120613098f;
  float _135 = _132 * 0.03030303120613098f;
  float _136 = _133 + 0.23496760427951813f;
  float _137 = _134 + 0.23496760427951813f;
  float _138 = _135 + 0.23496760427951813f;
  uint3 _139;
  t40_space15.GetDimensions(_139.x, _139.y, _139.z);
  uint2 _143;
  t13_space15.GetDimensions(_143.x, _143.y);
  uint _145 = _139.x + -1u;
  uint _146 = _139.y + -1u;
  uint _147 = _139.z + -1u;
  float _148 = float((uint)_145);
  float _149 = float((uint)_146);
  float _150 = float((uint)_147);
  float _151 = float((uint)_139.x);
  float _152 = float((uint)_139.y);
  float _153 = float((uint)_139.z);
  float _154 = _148 / _151;
  float _155 = _149 / _152;
  float _156 = _150 / _153;
  float _157 = 0.5f / _151;
  float _158 = 0.5f / _152;
  float _159 = 0.5f / _153;
  float _160 = _154 * _136;
  float _161 = _155 * _137;
  float _162 = _156 * _138;
  float _163 = _157 + _160;
  float _164 = _158 + _161;
  float _165 = _159 + _162;
  float4 _166 = t40_space15.SampleLevel(s2_space1, float3(_163, _164, _165), 0.0f);
  float _169 = exp2(_127);
  float _170 = exp2(_128);
  float _171 = exp2(_129);
  float _172 = _169 * 0.6954522132873535f;
  float _173 = mad(0.14067870378494263f, _170, _172);
  float _174 = mad(0.16386906802654266f, _171, _173);
  float _175 = _169 * 0.044794563204050064f;
  float _176 = mad(0.8596711158752441f, _170, _175);
  float _177 = mad(0.0955343171954155f, _171, _176);
  float _178 = _169 * -0.005525882821530104f;
  float _179 = mad(0.004025210160762072f, _170, _178);
  float _180 = mad(1.0015007257461548f, _171, _179);
  float _181 = _166.x + 1.0f;
  float _182 = _174 * _181;
  float _183 = _177 * _181;
  float _184 = _180 * _181;
  float _185 = _182 + _166.y;
  float _186 = max(_185, 0.0f);
  float _187 = max(_183, 0.0f);
  float _188 = max(_184, 0.0f);
  float _189 = min(_186, 65536.0f);
  float _190 = min(_187, 65536.0f);
  float _191 = min(_188, 65536.0f);
  float _192 = _189 * 1.4514392614364624f;
  float _193 = mad(-0.2365107536315918f, _190, _192);
  float _194 = mad(-0.21492856740951538f, _191, _193);
  float _195 = _189 * -0.07655377686023712f;
  float _196 = mad(1.17622971534729f, _190, _195);
  float _197 = mad(-0.09967592358589172f, _191, _196);
  float _198 = _189 * 0.008316148072481155f;
  float _199 = mad(-0.006032449658960104f, _190, _198);
  float _200 = mad(0.9977163076400757f, _191, _199);
  float _201 = max(_194, 0.0f);
  float _202 = max(_197, 0.0f);
  float _203 = max(_200, 0.0f);
  float _204 = min(_201, 65504.0f);
  float _205 = min(_202, 65504.0f);
  float _206 = min(_203, 65504.0f);
  float _207 = _204 * 0.970889151096344f;
  float _208 = mad(0.026963284239172935f, _205, _207);
  float _209 = mad(0.0021475818939507008f, _206, _208);
  float _210 = _204 * 0.010889154858887196f;
  float _211 = mad(0.9869632720947266f, _205, _210);
  float _212 = mad(0.0021475818939507008f, _206, _211);
  float _213 = mad(0.026963284239172935f, _205, _210);
  float _214 = mad(0.9621475338935852f, _206, _213);
  float _215 = log2(_209);
  float _216 = log2(_212);
  float _217 = log2(_214);
  float _218 = _215 + 17.47393035888672f;
  float _219 = _216 + 17.47393035888672f;
  float _220 = _217 + 17.47393035888672f;
  float _221 = _218 * 0.03030303120613098f;
  float _222 = _219 * 0.03030303120613098f;
  float _223 = _220 * 0.03030303120613098f;
  uint _224 = _143.x + -1u;
  float _225 = float((uint)_224);
  float _226 = float((uint)_143.x);
  float _227 = _225 / _226;
  float _228 = 0.5f / _226;
  float _229 = _221 * _227;
  float _230 = _222 * _227;
  float _231 = _223 * _227;
  float _232 = _229 + _228;
  float _233 = _230 + _228;
  float _234 = _231 + _228;
  float4 _235 = t13_space15.SampleLevel(s2_space1, float2(_232, 0.5f), 0.0f);
  float4 _237 = t13_space15.SampleLevel(s2_space1, float2(_233, 0.5f), 0.0f);
  float4 _239 = t13_space15.SampleLevel(s2_space1, float2(_234, 0.5f), 0.0f);
  float _241 = _235.x * 3.321928024291992f;
  float _242 = _237.x * 3.321928024291992f;
  float _243 = _239.x * 3.321928024291992f;
  float _244 = exp2(_241);
  float _245 = exp2(_242);
  float _246 = exp2(_243);
  float _247 = _244 / cb3_space9_036w;
  float _248 = _245 / cb3_space9_036w;
  float _249 = _246 / cb3_space9_036w;
  bool _250 = (cb3_space9_036y < 500.0f);
  float _288;
  float _289;
  float _290;
  float _340;
  float _348;
  float _356;
  if (_250) {
    float _252 = _247 * 0.6624541878700256f;
    float _253 = mad(0.13400420546531677f, _248, _252);
    float _254 = mad(0.15618768334388733f, _249, _253);
    float _255 = _247 * 0.2722287178039551f;
    float _256 = mad(0.6740817427635193f, _248, _255);
    float _257 = mad(0.053689517080783844f, _249, _256);
    float _258 = _247 * -0.005574649665504694f;
    float _259 = mad(0.00406073359772563f, _248, _258);
    float _260 = mad(1.0103391408920288f, _249, _259);
    float _261 = _257 + _254;
    float _262 = _261 + _260;
    bool _263 = (_262 == 0.0f);
    float _264 = select(_263, 1.000000013351432e-10f, _262);
    float _265 = _254 / _264;
    float _266 = _257 / _264;
    float _267 = max(_257, 0.0f);
    float _268 = log2(_267);
    float _269 = _268 * 0.9811000227928162f;
    float _270 = exp2(_269);
    float _271 = _270 * _265;
    float _272 = max(_266, 1.000000013351432e-10f);
    float _273 = _271 / _272;
    float _274 = 1.0f - _265;
    float _275 = _274 - _266;
    float _276 = _270 * _275;
    float _277 = _276 / _272;
    float _278 = _273 * 1.6410233974456787f;
    float _279 = mad(-0.32480329275131226f, _270, _278);
    float _280 = mad(-0.23642469942569733f, _277, _279);
    float _281 = _273 * -0.663662850856781f;
    float _282 = mad(1.6153316497802734f, _270, _281);
    float _283 = mad(0.016756348311901093f, _277, _282);
    float _284 = _273 * 0.011721894145011902f;
    float _285 = mad(-0.008284442126750946f, _270, _284);
    float _286 = mad(0.9883948564529419f, _277, _285);
    _288 = _280;
    _289 = _283;
    _290 = _286;
  } else {
    _288 = _247;
    _289 = _248;
    _290 = _249;
  }
  float _291 = _288 * 1.6047539710998535f;
  float _292 = mad(-0.5310794711112976f, _289, _291);
  float _293 = mad(-0.07367203384637833f, _290, _292);
  float _294 = _288 * -0.10208318382501602f;
  float _295 = mad(1.108132243156433f, _289, _294);
  float _296 = mad(-0.006051875650882721f, _290, _295);
  float _297 = _288 * -0.0032670421060174704f;
  float _298 = mad(-0.07275524735450745f, _289, _297);
  float _299 = mad(1.0760219097137451f, _290, _298);
  float _300 = max(_293, 0.0f);
  float _301 = max(_296, 0.0f);
  float _302 = max(_299, 0.0f);
  float _303 = _300 * ATTRIBUTE_VCOLOR.x;
  float _304 = _301 * ATTRIBUTE_VCOLOR.y;
  float _305 = _302 * ATTRIBUTE_VCOLOR.z;
  float _306 = abs(_303);
  float _307 = abs(_304);
  float _308 = abs(_305);
  float _309 = log2(_306);
  float _310 = log2(_307);
  float _311 = log2(_308);
  float _312 = _309 * 0.4166666567325592f;
  float _313 = _310 * 0.4166666567325592f;
  float _314 = _311 * 0.4166666567325592f;
  float _315 = exp2(_312);
  float _316 = exp2(_313);
  float _317 = exp2(_314);
  bool _318 = isfinite(_315);
  bool _319 = isfinite(_316);
  bool _320 = isfinite(_317);
  float _321 = _315 * 1.0549999475479126f;
  float _322 = _316 * 1.0549999475479126f;
  float _323 = _317 * 1.0549999475479126f;
  float _324 = _321 + -0.054999999701976776f;
  float _325 = select(_318, _324, 0.9999999403953552f);
  float _326 = _322 + -0.054999999701976776f;
  float _327 = select(_319, _326, 0.9999999403953552f);
  float _328 = _323 + -0.054999999701976776f;
  float _329 = select(_320, _328, 0.9999999403953552f);
  float _330 = _304 * 12.920000076293945f;
  float _331 = _305 * 12.920000076293945f;
  bool _332 = (_303 > 0.0031308000907301903f);
  if (!_332) {
    float _334 = _303 * 12.920000076293945f;
    bool _335 = (_303 < 0.0031308000907301903f);
    if (!_335) {
      bool _337 = (_303 == 0.0031308000907301903f);
      if (_337) {
        _340 = _325;
      } else {
        _340 = 0.0f;
      }
    } else {
      _340 = _334;
    }
  } else {
    _340 = _325;
  }
  bool _341 = (_304 > 0.0031308000907301903f);
  if (!_341) {
    bool _343 = (_304 < 0.0031308000907301903f);
    if (!_343) {
      bool _345 = (_304 == 0.0031308000907301903f);
      if (_345) {
        _348 = _327;
      } else {
        _348 = 0.0f;
      }
    } else {
      _348 = _330;
    }
  } else {
    _348 = _327;
  }
  bool _349 = (_305 > 0.0031308000907301903f);
  if (!_349) {
    bool _351 = (_305 < 0.0031308000907301903f);
    if (!_351) {
      bool _353 = (_305 == 0.0031308000907301903f);
      if (_353) {
        _356 = _329;
      } else {
        _356 = 0.0f;
      }
    } else {
      _356 = _331;
    }
  } else {
    _356 = _329;
  }
  float _357 = _28 - cb1_space9_034x;
  bool _358 = (_357 < 0.0f);
  if (_358) discard;
  float _364 = _28 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _365 = _364 * cb0_space5_008w;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_130, _131, _132), 1.f);
    _340 = video.r;
    _348 = video.g;
    _356 = video.b;
  }
  float _366 = _340 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _367 = _366 * cb0_space5_008x;
  float _368 = _367 * cb0_space5_008w;
  float _369 = _348 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _370 = _369 * cb0_space5_008y;
  float _371 = _370 * cb0_space5_008w;
  float _372 = _356 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _373 = _372 * cb0_space5_008z;
  float _374 = _373 * cb0_space5_008w;
  SV_Target.x = _368;
  SV_Target.y = _371;
  SV_Target.z = _374;
  SV_Target.w = _365;
  return SV_Target;
}

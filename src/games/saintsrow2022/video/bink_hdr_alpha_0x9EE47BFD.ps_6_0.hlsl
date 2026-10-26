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
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  bool _20 = (ATTRIBUTE_REFLECTION_DIST < 0.0f);
  if (_20) discard;
  float4 _23 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _25 = _23.x * ATTRIBUTE_VCOLOR.w;
  float _26 = max(_25, 0.0f);
  float _27 = min(1.0f, _26);
  float4 _30 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _32 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _34 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _36 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _40 = cb3_space9_038x * _32.x;
  float _42 = _40 + cb3_space9_038z;
  float _44 = cb3_space9_038y * _34.x;
  float _46 = _44 + cb3_space9_038w;
  float _47 = _36.x + _30.x;
  float _50 = cb3_space9_037x * _47;
  float _51 = _42 * 0.008609036915004253f;
  float _52 = _42 * 0.5600313544273376f;
  float _53 = _50 + _51;
  float _54 = _50 - _51;
  float _55 = _52 + _50;
  float _56 = _46 * 0.11102962493896484f;
  float _57 = _46 * 0.3206271827220917f;
  float _58 = _53 + _56;
  float _59 = _54 - _56;
  float _60 = _55 - _57;
  float _61 = max(_58, 0.0f);
  float _62 = max(_59, 0.0f);
  float _63 = max(_60, 0.0f);
  float _64 = log2(_61);
  float _65 = log2(_62);
  float _66 = log2(_63);
  float _67 = _64 * 0.012683313339948654f;
  float _68 = _65 * 0.012683313339948654f;
  float _69 = _66 * 0.012683313339948654f;
  float _70 = exp2(_67);
  float _71 = exp2(_68);
  float _72 = exp2(_69);
  float _73 = _70 + -0.8359375f;
  float _74 = _71 + -0.8359375f;
  float _75 = _72 + -0.8359375f;
  float _76 = max(0.0f, _73);
  float _77 = max(0.0f, _74);
  float _78 = max(0.0f, _75);
  float _79 = _70 * 18.6875f;
  float _80 = _71 * 18.6875f;
  float _81 = _72 * 18.6875f;
  float _82 = 18.8515625f - _79;
  float _83 = 18.8515625f - _80;
  float _84 = 18.8515625f - _81;
  float _85 = _76 / _82;
  float _86 = _77 / _83;
  float _87 = _78 / _84;
  float _88 = abs(_85);
  float _89 = abs(_86);
  float _90 = abs(_87);
  float _91 = log2(_88);
  float _92 = log2(_89);
  float _93 = log2(_90);
  float _94 = _91 * 6.277394771575928f;
  float _95 = _92 * 6.277394771575928f;
  float _96 = _93 * 6.277394771575928f;
  float _97 = exp2(_94);
  float _98 = exp2(_95);
  float _99 = exp2(_96);
  float _100 = _97 * 3.4366066455841064f;
  float _101 = _97 * 0.791329562664032f;
  float _102 = _98 * 2.5064520835876465f;
  float _103 = _98 * 1.9836004972457886f;
  float _104 = _98 * 0.09891371428966522f;
  float _105 = _100 - _102;
  float _106 = _103 - _101;
  float _107 = _97 * -0.02594989910721779f;
  float _108 = _107 - _104;
  float _109 = _99 * 0.06984542310237885f;
  float _110 = _99 * 0.192270889878273f;
  float _111 = _99 * 1.124863624572754f;
  float _112 = _105 + _109;
  float _113 = _106 - _110;
  float _114 = _108 + _111;
  float _116 = cb3_space9_037y * 368.6400146484375f;
  float _117 = _116 * _112;
  float _118 = _116 * _113;
  float _119 = _116 * _114;
  float _120 = max(_117, 9.999999747378752e-05f);
  float _121 = max(_118, 9.999999747378752e-05f);
  float _122 = max(_119, 9.999999747378752e-05f);
  float _126 = log2(_120);
  float _127 = log2(_121);
  float _128 = log2(_122);
  float _129 = _126 + 9.720000267028809f;
  float _130 = _127 + 9.720000267028809f;
  float _131 = _128 + 9.720000267028809f;
  float _132 = _129 * 0.03030303120613098f;
  float _133 = _130 * 0.03030303120613098f;
  float _134 = _131 * 0.03030303120613098f;
  float _135 = _132 + 0.23496760427951813f;
  float _136 = _133 + 0.23496760427951813f;
  float _137 = _134 + 0.23496760427951813f;
  uint3 _138;
  t40_space15.GetDimensions(_138.x, _138.y, _138.z);
  uint2 _142;
  t13_space15.GetDimensions(_142.x, _142.y);
  uint _144 = _138.x + -1u;
  uint _145 = _138.y + -1u;
  uint _146 = _138.z + -1u;
  float _147 = float((uint)_144);
  float _148 = float((uint)_145);
  float _149 = float((uint)_146);
  float _150 = float((uint)_138.x);
  float _151 = float((uint)_138.y);
  float _152 = float((uint)_138.z);
  float _153 = _147 / _150;
  float _154 = _148 / _151;
  float _155 = _149 / _152;
  float _156 = 0.5f / _150;
  float _157 = 0.5f / _151;
  float _158 = 0.5f / _152;
  float _159 = _153 * _135;
  float _160 = _154 * _136;
  float _161 = _155 * _137;
  float _162 = _156 + _159;
  float _163 = _157 + _160;
  float _164 = _158 + _161;
  float4 _165 = t40_space15.SampleLevel(s2_space1, float3(_162, _163, _164), 0.0f);
  float _168 = exp2(_126);
  float _169 = exp2(_127);
  float _170 = exp2(_128);
  float _171 = _168 * 0.6954522132873535f;
  float _172 = mad(0.14067870378494263f, _169, _171);
  float _173 = mad(0.16386906802654266f, _170, _172);
  float _174 = _168 * 0.044794563204050064f;
  float _175 = mad(0.8596711158752441f, _169, _174);
  float _176 = mad(0.0955343171954155f, _170, _175);
  float _177 = _168 * -0.005525882821530104f;
  float _178 = mad(0.004025210160762072f, _169, _177);
  float _179 = mad(1.0015007257461548f, _170, _178);
  float _180 = _165.x + 1.0f;
  float _181 = _173 * _180;
  float _182 = _176 * _180;
  float _183 = _179 * _180;
  float _184 = _181 + _165.y;
  float _185 = max(_184, 0.0f);
  float _186 = max(_182, 0.0f);
  float _187 = max(_183, 0.0f);
  float _188 = min(_185, 65536.0f);
  float _189 = min(_186, 65536.0f);
  float _190 = min(_187, 65536.0f);
  float _191 = _188 * 1.4514392614364624f;
  float _192 = mad(-0.2365107536315918f, _189, _191);
  float _193 = mad(-0.21492856740951538f, _190, _192);
  float _194 = _188 * -0.07655377686023712f;
  float _195 = mad(1.17622971534729f, _189, _194);
  float _196 = mad(-0.09967592358589172f, _190, _195);
  float _197 = _188 * 0.008316148072481155f;
  float _198 = mad(-0.006032449658960104f, _189, _197);
  float _199 = mad(0.9977163076400757f, _190, _198);
  float _200 = max(_193, 0.0f);
  float _201 = max(_196, 0.0f);
  float _202 = max(_199, 0.0f);
  float _203 = min(_200, 65504.0f);
  float _204 = min(_201, 65504.0f);
  float _205 = min(_202, 65504.0f);
  float _206 = _203 * 0.970889151096344f;
  float _207 = mad(0.026963284239172935f, _204, _206);
  float _208 = mad(0.0021475818939507008f, _205, _207);
  float _209 = _203 * 0.010889154858887196f;
  float _210 = mad(0.9869632720947266f, _204, _209);
  float _211 = mad(0.0021475818939507008f, _205, _210);
  float _212 = mad(0.026963284239172935f, _204, _209);
  float _213 = mad(0.9621475338935852f, _205, _212);
  float _214 = log2(_208);
  float _215 = log2(_211);
  float _216 = log2(_213);
  float _217 = _214 + 17.47393035888672f;
  float _218 = _215 + 17.47393035888672f;
  float _219 = _216 + 17.47393035888672f;
  float _220 = _217 * 0.03030303120613098f;
  float _221 = _218 * 0.03030303120613098f;
  float _222 = _219 * 0.03030303120613098f;
  uint _223 = _142.x + -1u;
  float _224 = float((uint)_223);
  float _225 = float((uint)_142.x);
  float _226 = _224 / _225;
  float _227 = 0.5f / _225;
  float _228 = _220 * _226;
  float _229 = _221 * _226;
  float _230 = _222 * _226;
  float _231 = _228 + _227;
  float _232 = _229 + _227;
  float _233 = _230 + _227;
  float4 _234 = t13_space15.SampleLevel(s2_space1, float2(_231, 0.5f), 0.0f);
  float4 _236 = t13_space15.SampleLevel(s2_space1, float2(_232, 0.5f), 0.0f);
  float4 _238 = t13_space15.SampleLevel(s2_space1, float2(_233, 0.5f), 0.0f);
  float _240 = _234.x * 3.321928024291992f;
  float _241 = _236.x * 3.321928024291992f;
  float _242 = _238.x * 3.321928024291992f;
  float _243 = exp2(_240);
  float _244 = exp2(_241);
  float _245 = exp2(_242);
  float _246 = _243 / cb3_space9_036w;
  float _247 = _244 / cb3_space9_036w;
  float _248 = _245 / cb3_space9_036w;
  bool _249 = (cb3_space9_036y < 500.0f);
  float _287;
  float _288;
  float _289;
  float _339;
  float _347;
  float _355;
  if (_249) {
    float _251 = _246 * 0.6624541878700256f;
    float _252 = mad(0.13400420546531677f, _247, _251);
    float _253 = mad(0.15618768334388733f, _248, _252);
    float _254 = _246 * 0.2722287178039551f;
    float _255 = mad(0.6740817427635193f, _247, _254);
    float _256 = mad(0.053689517080783844f, _248, _255);
    float _257 = _246 * -0.005574649665504694f;
    float _258 = mad(0.00406073359772563f, _247, _257);
    float _259 = mad(1.0103391408920288f, _248, _258);
    float _260 = _256 + _253;
    float _261 = _260 + _259;
    bool _262 = (_261 == 0.0f);
    float _263 = select(_262, 1.000000013351432e-10f, _261);
    float _264 = _253 / _263;
    float _265 = _256 / _263;
    float _266 = max(_256, 0.0f);
    float _267 = log2(_266);
    float _268 = _267 * 0.9811000227928162f;
    float _269 = exp2(_268);
    float _270 = _269 * _264;
    float _271 = max(_265, 1.000000013351432e-10f);
    float _272 = _270 / _271;
    float _273 = 1.0f - _264;
    float _274 = _273 - _265;
    float _275 = _269 * _274;
    float _276 = _275 / _271;
    float _277 = _272 * 1.6410233974456787f;
    float _278 = mad(-0.32480329275131226f, _269, _277);
    float _279 = mad(-0.23642469942569733f, _276, _278);
    float _280 = _272 * -0.663662850856781f;
    float _281 = mad(1.6153316497802734f, _269, _280);
    float _282 = mad(0.016756348311901093f, _276, _281);
    float _283 = _272 * 0.011721894145011902f;
    float _284 = mad(-0.008284442126750946f, _269, _283);
    float _285 = mad(0.9883948564529419f, _276, _284);
    _287 = _279;
    _288 = _282;
    _289 = _285;
  } else {
    _287 = _246;
    _288 = _247;
    _289 = _248;
  }
  float _290 = _287 * 1.6047539710998535f;
  float _291 = mad(-0.5310794711112976f, _288, _290);
  float _292 = mad(-0.07367203384637833f, _289, _291);
  float _293 = _287 * -0.10208318382501602f;
  float _294 = mad(1.108132243156433f, _288, _293);
  float _295 = mad(-0.006051875650882721f, _289, _294);
  float _296 = _287 * -0.0032670421060174704f;
  float _297 = mad(-0.07275524735450745f, _288, _296);
  float _298 = mad(1.0760219097137451f, _289, _297);
  float _299 = max(_292, 0.0f);
  float _300 = max(_295, 0.0f);
  float _301 = max(_298, 0.0f);
  float _302 = _299 * ATTRIBUTE_VCOLOR.x;
  float _303 = _300 * ATTRIBUTE_VCOLOR.y;
  float _304 = _301 * ATTRIBUTE_VCOLOR.z;
  float _305 = abs(_302);
  float _306 = abs(_303);
  float _307 = abs(_304);
  float _308 = log2(_305);
  float _309 = log2(_306);
  float _310 = log2(_307);
  float _311 = _308 * 0.4166666567325592f;
  float _312 = _309 * 0.4166666567325592f;
  float _313 = _310 * 0.4166666567325592f;
  float _314 = exp2(_311);
  float _315 = exp2(_312);
  float _316 = exp2(_313);
  bool _317 = isfinite(_314);
  bool _318 = isfinite(_315);
  bool _319 = isfinite(_316);
  float _320 = _314 * 1.0549999475479126f;
  float _321 = _315 * 1.0549999475479126f;
  float _322 = _316 * 1.0549999475479126f;
  float _323 = _320 + -0.054999999701976776f;
  float _324 = select(_317, _323, 0.9999999403953552f);
  float _325 = _321 + -0.054999999701976776f;
  float _326 = select(_318, _325, 0.9999999403953552f);
  float _327 = _322 + -0.054999999701976776f;
  float _328 = select(_319, _327, 0.9999999403953552f);
  float _329 = _303 * 12.920000076293945f;
  float _330 = _304 * 12.920000076293945f;
  bool _331 = (_302 > 0.0031308000907301903f);
  if (!_331) {
    float _333 = _302 * 12.920000076293945f;
    bool _334 = (_302 < 0.0031308000907301903f);
    if (!_334) {
      bool _336 = (_302 == 0.0031308000907301903f);
      if (_336) {
        _339 = _324;
      } else {
        _339 = 0.0f;
      }
    } else {
      _339 = _333;
    }
  } else {
    _339 = _324;
  }
  bool _340 = (_303 > 0.0031308000907301903f);
  if (!_340) {
    bool _342 = (_303 < 0.0031308000907301903f);
    if (!_342) {
      bool _344 = (_303 == 0.0031308000907301903f);
      if (_344) {
        _347 = _326;
      } else {
        _347 = 0.0f;
      }
    } else {
      _347 = _329;
    }
  } else {
    _347 = _326;
  }
  bool _348 = (_304 > 0.0031308000907301903f);
  if (!_348) {
    bool _350 = (_304 < 0.0031308000907301903f);
    if (!_350) {
      bool _352 = (_304 == 0.0031308000907301903f);
      if (_352) {
        _355 = _328;
      } else {
        _355 = 0.0f;
      }
    } else {
      _355 = _330;
    }
  } else {
    _355 = _328;
  }
  float _356 = _27 - cb1_space9_034x;
  bool _357 = (_356 < 0.0f);
  if (_357) discard;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_129, _130, _131), 1.f);
    _339 = video.r;
    _347 = video.g;
    _355 = video.b;
  }
  float _363 = cb0_space5_008x * _339;
  float _364 = cb0_space5_008y * _347;
  float _365 = cb0_space5_008z * _355;
  float _366 = cb0_space5_008w * _27;
  float _367 = _363 * cb0_space5_008w;
  float _368 = _364 * cb0_space5_008w;
  float _369 = _365 * cb0_space5_008w;
  SV_Target.x = _367;
  SV_Target.y = _368;
  SV_Target.z = _369;
  SV_Target.w = _366;
  return SV_Target;
}

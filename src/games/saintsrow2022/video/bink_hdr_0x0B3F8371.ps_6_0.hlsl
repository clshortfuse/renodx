#include "../tonemap/tonemap.hlsli"

// rl_default_primitive_bink_hdr: HDR10 Bink video (PQ decode -> AP1) tone mapped with the vanilla ACES chain (t40/t13, space15).
// The RenoDX path replaces the sRGB-encoded result after the discard, before the vanilla tint and alpha.

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
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  float _18 = max(ATTRIBUTE_VCOLOR.w, 0.0f);
  float _19 = min(1.0f, _18);
  float4 _24 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _26 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _28 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _30 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _34 = cb3_space9_038x * _26.x;
  float _36 = _34 + cb3_space9_038z;
  float _38 = cb3_space9_038y * _28.x;
  float _40 = _38 + cb3_space9_038w;
  float _41 = _30.x + _24.x;
  float _44 = cb3_space9_037x * _41;
  float _45 = _36 * 0.008609036915004253f;
  float _46 = _36 * 0.5600313544273376f;
  float _47 = _44 + _45;
  float _48 = _44 - _45;
  float _49 = _46 + _44;
  float _50 = _40 * 0.11102962493896484f;
  float _51 = _40 * 0.3206271827220917f;
  float _52 = _47 + _50;
  float _53 = _48 - _50;
  float _54 = _49 - _51;
  float _55 = max(_52, 0.0f);
  float _56 = max(_53, 0.0f);
  float _57 = max(_54, 0.0f);
  float _58 = log2(_55);
  float _59 = log2(_56);
  float _60 = log2(_57);
  float _61 = _58 * 0.012683313339948654f;
  float _62 = _59 * 0.012683313339948654f;
  float _63 = _60 * 0.012683313339948654f;
  float _64 = exp2(_61);
  float _65 = exp2(_62);
  float _66 = exp2(_63);
  float _67 = _64 + -0.8359375f;
  float _68 = _65 + -0.8359375f;
  float _69 = _66 + -0.8359375f;
  float _70 = max(0.0f, _67);
  float _71 = max(0.0f, _68);
  float _72 = max(0.0f, _69);
  float _73 = _64 * 18.6875f;
  float _74 = _65 * 18.6875f;
  float _75 = _66 * 18.6875f;
  float _76 = 18.8515625f - _73;
  float _77 = 18.8515625f - _74;
  float _78 = 18.8515625f - _75;
  float _79 = _70 / _76;
  float _80 = _71 / _77;
  float _81 = _72 / _78;
  float _82 = abs(_79);
  float _83 = abs(_80);
  float _84 = abs(_81);
  float _85 = log2(_82);
  float _86 = log2(_83);
  float _87 = log2(_84);
  float _88 = _85 * 6.277394771575928f;
  float _89 = _86 * 6.277394771575928f;
  float _90 = _87 * 6.277394771575928f;
  float _91 = exp2(_88);
  float _92 = exp2(_89);
  float _93 = exp2(_90);
  float _94 = _91 * 3.4366066455841064f;
  float _95 = _91 * 0.791329562664032f;
  float _96 = _92 * 2.5064520835876465f;
  float _97 = _92 * 1.9836004972457886f;
  float _98 = _92 * 0.09891371428966522f;
  float _99 = _94 - _96;
  float _100 = _97 - _95;
  float _101 = _91 * -0.02594989910721779f;
  float _102 = _101 - _98;
  float _103 = _93 * 0.06984542310237885f;
  float _104 = _93 * 0.192270889878273f;
  float _105 = _93 * 1.124863624572754f;
  float _106 = _99 + _103;
  float _107 = _100 - _104;
  float _108 = _102 + _105;
  float _110 = cb3_space9_037y * 368.6400146484375f;
  float _111 = _110 * _106;
  float _112 = _110 * _107;
  float _113 = _110 * _108;
  float _114 = max(_111, 9.999999747378752e-05f);
  float _115 = max(_112, 9.999999747378752e-05f);
  float _116 = max(_113, 9.999999747378752e-05f);
  float _120 = log2(_114);
  float _121 = log2(_115);
  float _122 = log2(_116);
  float _123 = _120 + 9.720000267028809f;
  float _124 = _121 + 9.720000267028809f;
  float _125 = _122 + 9.720000267028809f;
  float _126 = _123 * 0.03030303120613098f;
  float _127 = _124 * 0.03030303120613098f;
  float _128 = _125 * 0.03030303120613098f;
  float _129 = _126 + 0.23496760427951813f;
  float _130 = _127 + 0.23496760427951813f;
  float _131 = _128 + 0.23496760427951813f;
  uint3 _132;
  t40_space15.GetDimensions(_132.x, _132.y, _132.z);
  uint2 _136;
  t13_space15.GetDimensions(_136.x, _136.y);
  uint _138 = _132.x + -1u;
  uint _139 = _132.y + -1u;
  uint _140 = _132.z + -1u;
  float _141 = float((uint)_138);
  float _142 = float((uint)_139);
  float _143 = float((uint)_140);
  float _144 = float((uint)_132.x);
  float _145 = float((uint)_132.y);
  float _146 = float((uint)_132.z);
  float _147 = _141 / _144;
  float _148 = _142 / _145;
  float _149 = _143 / _146;
  float _150 = 0.5f / _144;
  float _151 = 0.5f / _145;
  float _152 = 0.5f / _146;
  float _153 = _147 * _129;
  float _154 = _148 * _130;
  float _155 = _149 * _131;
  float _156 = _150 + _153;
  float _157 = _151 + _154;
  float _158 = _152 + _155;
  float4 _159 = t40_space15.SampleLevel(s2_space1, float3(_156, _157, _158), 0.0f);
  float _162 = exp2(_120);
  float _163 = exp2(_121);
  float _164 = exp2(_122);
  float _165 = _162 * 0.6954522132873535f;
  float _166 = mad(0.14067870378494263f, _163, _165);
  float _167 = mad(0.16386906802654266f, _164, _166);
  float _168 = _162 * 0.044794563204050064f;
  float _169 = mad(0.8596711158752441f, _163, _168);
  float _170 = mad(0.0955343171954155f, _164, _169);
  float _171 = _162 * -0.005525882821530104f;
  float _172 = mad(0.004025210160762072f, _163, _171);
  float _173 = mad(1.0015007257461548f, _164, _172);
  float _174 = _159.x + 1.0f;
  float _175 = _167 * _174;
  float _176 = _170 * _174;
  float _177 = _173 * _174;
  float _178 = _175 + _159.y;
  float _179 = max(_178, 0.0f);
  float _180 = max(_176, 0.0f);
  float _181 = max(_177, 0.0f);
  float _182 = min(_179, 65536.0f);
  float _183 = min(_180, 65536.0f);
  float _184 = min(_181, 65536.0f);
  float _185 = _182 * 1.4514392614364624f;
  float _186 = mad(-0.2365107536315918f, _183, _185);
  float _187 = mad(-0.21492856740951538f, _184, _186);
  float _188 = _182 * -0.07655377686023712f;
  float _189 = mad(1.17622971534729f, _183, _188);
  float _190 = mad(-0.09967592358589172f, _184, _189);
  float _191 = _182 * 0.008316148072481155f;
  float _192 = mad(-0.006032449658960104f, _183, _191);
  float _193 = mad(0.9977163076400757f, _184, _192);
  float _194 = max(_187, 0.0f);
  float _195 = max(_190, 0.0f);
  float _196 = max(_193, 0.0f);
  float _197 = min(_194, 65504.0f);
  float _198 = min(_195, 65504.0f);
  float _199 = min(_196, 65504.0f);
  float _200 = _197 * 0.970889151096344f;
  float _201 = mad(0.026963284239172935f, _198, _200);
  float _202 = mad(0.0021475818939507008f, _199, _201);
  float _203 = _197 * 0.010889154858887196f;
  float _204 = mad(0.9869632720947266f, _198, _203);
  float _205 = mad(0.0021475818939507008f, _199, _204);
  float _206 = mad(0.026963284239172935f, _198, _203);
  float _207 = mad(0.9621475338935852f, _199, _206);
  float _208 = log2(_202);
  float _209 = log2(_205);
  float _210 = log2(_207);
  float _211 = _208 + 17.47393035888672f;
  float _212 = _209 + 17.47393035888672f;
  float _213 = _210 + 17.47393035888672f;
  float _214 = _211 * 0.03030303120613098f;
  float _215 = _212 * 0.03030303120613098f;
  float _216 = _213 * 0.03030303120613098f;
  uint _217 = _136.x + -1u;
  float _218 = float((uint)_217);
  float _219 = float((uint)_136.x);
  float _220 = _218 / _219;
  float _221 = 0.5f / _219;
  float _222 = _214 * _220;
  float _223 = _215 * _220;
  float _224 = _216 * _220;
  float _225 = _222 + _221;
  float _226 = _223 + _221;
  float _227 = _224 + _221;
  float4 _228 = t13_space15.SampleLevel(s2_space1, float2(_225, 0.5f), 0.0f);
  float4 _230 = t13_space15.SampleLevel(s2_space1, float2(_226, 0.5f), 0.0f);
  float4 _232 = t13_space15.SampleLevel(s2_space1, float2(_227, 0.5f), 0.0f);
  float _234 = _228.x * 3.321928024291992f;
  float _235 = _230.x * 3.321928024291992f;
  float _236 = _232.x * 3.321928024291992f;
  float _237 = exp2(_234);
  float _238 = exp2(_235);
  float _239 = exp2(_236);
  float _240 = _237 / cb3_space9_036w;
  float _241 = _238 / cb3_space9_036w;
  float _242 = _239 / cb3_space9_036w;
  bool _243 = (cb3_space9_036y < 500.0f);
  float _281;
  float _282;
  float _283;
  float _333;
  float _341;
  float _349;
  if (_243) {
    float _245 = _240 * 0.6624541878700256f;
    float _246 = mad(0.13400420546531677f, _241, _245);
    float _247 = mad(0.15618768334388733f, _242, _246);
    float _248 = _240 * 0.2722287178039551f;
    float _249 = mad(0.6740817427635193f, _241, _248);
    float _250 = mad(0.053689517080783844f, _242, _249);
    float _251 = _240 * -0.005574649665504694f;
    float _252 = mad(0.00406073359772563f, _241, _251);
    float _253 = mad(1.0103391408920288f, _242, _252);
    float _254 = _250 + _247;
    float _255 = _254 + _253;
    bool _256 = (_255 == 0.0f);
    float _257 = select(_256, 1.000000013351432e-10f, _255);
    float _258 = _247 / _257;
    float _259 = _250 / _257;
    float _260 = max(_250, 0.0f);
    float _261 = log2(_260);
    float _262 = _261 * 0.9811000227928162f;
    float _263 = exp2(_262);
    float _264 = _263 * _258;
    float _265 = max(_259, 1.000000013351432e-10f);
    float _266 = _264 / _265;
    float _267 = 1.0f - _258;
    float _268 = _267 - _259;
    float _269 = _263 * _268;
    float _270 = _269 / _265;
    float _271 = _266 * 1.6410233974456787f;
    float _272 = mad(-0.32480329275131226f, _263, _271);
    float _273 = mad(-0.23642469942569733f, _270, _272);
    float _274 = _266 * -0.663662850856781f;
    float _275 = mad(1.6153316497802734f, _263, _274);
    float _276 = mad(0.016756348311901093f, _270, _275);
    float _277 = _266 * 0.011721894145011902f;
    float _278 = mad(-0.008284442126750946f, _263, _277);
    float _279 = mad(0.9883948564529419f, _270, _278);
    _281 = _273;
    _282 = _276;
    _283 = _279;
  } else {
    _281 = _240;
    _282 = _241;
    _283 = _242;
  }
  float _284 = _281 * 1.6047539710998535f;
  float _285 = mad(-0.5310794711112976f, _282, _284);
  float _286 = mad(-0.07367203384637833f, _283, _285);
  float _287 = _281 * -0.10208318382501602f;
  float _288 = mad(1.108132243156433f, _282, _287);
  float _289 = mad(-0.006051875650882721f, _283, _288);
  float _290 = _281 * -0.0032670421060174704f;
  float _291 = mad(-0.07275524735450745f, _282, _290);
  float _292 = mad(1.0760219097137451f, _283, _291);
  float _293 = max(_286, 0.0f);
  float _294 = max(_289, 0.0f);
  float _295 = max(_292, 0.0f);
  float _296 = _293 * ATTRIBUTE_VCOLOR.x;
  float _297 = _294 * ATTRIBUTE_VCOLOR.y;
  float _298 = _295 * ATTRIBUTE_VCOLOR.z;
  float _299 = abs(_296);
  float _300 = abs(_297);
  float _301 = abs(_298);
  float _302 = log2(_299);
  float _303 = log2(_300);
  float _304 = log2(_301);
  float _305 = _302 * 0.4166666567325592f;
  float _306 = _303 * 0.4166666567325592f;
  float _307 = _304 * 0.4166666567325592f;
  float _308 = exp2(_305);
  float _309 = exp2(_306);
  float _310 = exp2(_307);
  bool _311 = isfinite(_308);
  bool _312 = isfinite(_309);
  bool _313 = isfinite(_310);
  float _314 = _308 * 1.0549999475479126f;
  float _315 = _309 * 1.0549999475479126f;
  float _316 = _310 * 1.0549999475479126f;
  float _317 = _314 + -0.054999999701976776f;
  float _318 = select(_311, _317, 0.9999999403953552f);
  float _319 = _315 + -0.054999999701976776f;
  float _320 = select(_312, _319, 0.9999999403953552f);
  float _321 = _316 + -0.054999999701976776f;
  float _322 = select(_313, _321, 0.9999999403953552f);
  float _323 = _297 * 12.920000076293945f;
  float _324 = _298 * 12.920000076293945f;
  bool _325 = (_296 > 0.0031308000907301903f);
  if (!_325) {
    float _327 = _296 * 12.920000076293945f;
    bool _328 = (_296 < 0.0031308000907301903f);
    if (!_328) {
      bool _330 = (_296 == 0.0031308000907301903f);
      if (_330) {
        _333 = _318;
      } else {
        _333 = 0.0f;
      }
    } else {
      _333 = _327;
    }
  } else {
    _333 = _318;
  }
  bool _334 = (_297 > 0.0031308000907301903f);
  if (!_334) {
    bool _336 = (_297 < 0.0031308000907301903f);
    if (!_336) {
      bool _338 = (_297 == 0.0031308000907301903f);
      if (_338) {
        _341 = _320;
      } else {
        _341 = 0.0f;
      }
    } else {
      _341 = _323;
    }
  } else {
    _341 = _320;
  }
  bool _342 = (_298 > 0.0031308000907301903f);
  if (!_342) {
    bool _344 = (_298 < 0.0031308000907301903f);
    if (!_344) {
      bool _346 = (_298 == 0.0031308000907301903f);
      if (_346) {
        _349 = _322;
      } else {
        _349 = 0.0f;
      }
    } else {
      _349 = _324;
    }
  } else {
    _349 = _322;
  }
  float _350 = _19 - cb1_space9_034x;
  bool _351 = (_350 < 0.0f);
  if (_351) discard;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_123, _124, _125), 1.f);
    _333 = video.r;
    _341 = video.g;
    _349 = video.b;
  }
  float _357 = cb0_space5_008x * _333;
  float _358 = cb0_space5_008y * _341;
  float _359 = cb0_space5_008z * _349;
  float _360 = cb0_space5_008w * _19;
  float _361 = _357 * cb0_space5_008w;
  float _362 = _358 * cb0_space5_008w;
  float _363 = _359 * cb0_space5_008w;
  SV_Target.x = _361;
  SV_Target.y = _362;
  SV_Target.z = _363;
  SV_Target.w = _360;
  return SV_Target;
}

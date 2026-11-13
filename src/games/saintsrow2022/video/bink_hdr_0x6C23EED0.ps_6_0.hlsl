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
    linear float ATTRIBUTE_REFLECTION_DIST : ATTRIBUTE_REFLECTION_DIST,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    linear float4 ATTRIBUTE_INSTANCE_PARAMS : ATTRIBUTE_INSTANCE_PARAMS,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  bool _20 = (ATTRIBUTE_REFLECTION_DIST < 0.0f);
  if (_20) discard;
  float _21 = max(ATTRIBUTE_VCOLOR.w, 0.0f);
  float _22 = min(1.0f, _21);
  float4 _27 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _29 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _31 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _33 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _37 = cb3_space9_038x * _29.x;
  float _39 = _37 + cb3_space9_038z;
  float _41 = cb3_space9_038y * _31.x;
  float _43 = _41 + cb3_space9_038w;
  float _44 = _33.x + _27.x;
  float _47 = cb3_space9_037x * _44;
  float _48 = _39 * 0.008609036915004253f;
  float _49 = _39 * 0.5600313544273376f;
  float _50 = _47 + _48;
  float _51 = _47 - _48;
  float _52 = _49 + _47;
  float _53 = _43 * 0.11102962493896484f;
  float _54 = _43 * 0.3206271827220917f;
  float _55 = _50 + _53;
  float _56 = _51 - _53;
  float _57 = _52 - _54;
  float _58 = max(_55, 0.0f);
  float _59 = max(_56, 0.0f);
  float _60 = max(_57, 0.0f);
  float _61 = log2(_58);
  float _62 = log2(_59);
  float _63 = log2(_60);
  float _64 = _61 * 0.012683313339948654f;
  float _65 = _62 * 0.012683313339948654f;
  float _66 = _63 * 0.012683313339948654f;
  float _67 = exp2(_64);
  float _68 = exp2(_65);
  float _69 = exp2(_66);
  float _70 = _67 + -0.8359375f;
  float _71 = _68 + -0.8359375f;
  float _72 = _69 + -0.8359375f;
  float _73 = max(0.0f, _70);
  float _74 = max(0.0f, _71);
  float _75 = max(0.0f, _72);
  float _76 = _67 * 18.6875f;
  float _77 = _68 * 18.6875f;
  float _78 = _69 * 18.6875f;
  float _79 = 18.8515625f - _76;
  float _80 = 18.8515625f - _77;
  float _81 = 18.8515625f - _78;
  float _82 = _73 / _79;
  float _83 = _74 / _80;
  float _84 = _75 / _81;
  float _85 = abs(_82);
  float _86 = abs(_83);
  float _87 = abs(_84);
  float _88 = log2(_85);
  float _89 = log2(_86);
  float _90 = log2(_87);
  float _91 = _88 * 6.277394771575928f;
  float _92 = _89 * 6.277394771575928f;
  float _93 = _90 * 6.277394771575928f;
  float _94 = exp2(_91);
  float _95 = exp2(_92);
  float _96 = exp2(_93);
  float _97 = _94 * 3.4366066455841064f;
  float _98 = _94 * 0.791329562664032f;
  float _99 = _95 * 2.5064520835876465f;
  float _100 = _95 * 1.9836004972457886f;
  float _101 = _95 * 0.09891371428966522f;
  float _102 = _97 - _99;
  float _103 = _100 - _98;
  float _104 = _94 * -0.02594989910721779f;
  float _105 = _104 - _101;
  float _106 = _96 * 0.06984542310237885f;
  float _107 = _96 * 0.192270889878273f;
  float _108 = _96 * 1.124863624572754f;
  float _109 = _102 + _106;
  float _110 = _103 - _107;
  float _111 = _105 + _108;
  float _113 = cb3_space9_037y * 368.6400146484375f;
  float _114 = _113 * _109;
  float _115 = _113 * _110;
  float _116 = _113 * _111;
  float _117 = max(_114, 9.999999747378752e-05f);
  float _118 = max(_115, 9.999999747378752e-05f);
  float _119 = max(_116, 9.999999747378752e-05f);
  float _123 = log2(_117);
  float _124 = log2(_118);
  float _125 = log2(_119);
  float _126 = _123 + 9.720000267028809f;
  float _127 = _124 + 9.720000267028809f;
  float _128 = _125 + 9.720000267028809f;
  float _129 = _126 * 0.03030303120613098f;
  float _130 = _127 * 0.03030303120613098f;
  float _131 = _128 * 0.03030303120613098f;
  float _132 = _129 + 0.23496760427951813f;
  float _133 = _130 + 0.23496760427951813f;
  float _134 = _131 + 0.23496760427951813f;
  uint3 _135;
  t40_space15.GetDimensions(_135.x, _135.y, _135.z);
  uint2 _139;
  t13_space15.GetDimensions(_139.x, _139.y);
  uint _141 = _135.x + -1u;
  uint _142 = _135.y + -1u;
  uint _143 = _135.z + -1u;
  float _144 = float((uint)_141);
  float _145 = float((uint)_142);
  float _146 = float((uint)_143);
  float _147 = float((uint)_135.x);
  float _148 = float((uint)_135.y);
  float _149 = float((uint)_135.z);
  float _150 = _144 / _147;
  float _151 = _145 / _148;
  float _152 = _146 / _149;
  float _153 = 0.5f / _147;
  float _154 = 0.5f / _148;
  float _155 = 0.5f / _149;
  float _156 = _150 * _132;
  float _157 = _151 * _133;
  float _158 = _152 * _134;
  float _159 = _153 + _156;
  float _160 = _154 + _157;
  float _161 = _155 + _158;
  float4 _162 = t40_space15.SampleLevel(s2_space1, float3(_159, _160, _161), 0.0f);
  float _165 = exp2(_123);
  float _166 = exp2(_124);
  float _167 = exp2(_125);
  float _168 = _165 * 0.6954522132873535f;
  float _169 = mad(0.14067870378494263f, _166, _168);
  float _170 = mad(0.16386906802654266f, _167, _169);
  float _171 = _165 * 0.044794563204050064f;
  float _172 = mad(0.8596711158752441f, _166, _171);
  float _173 = mad(0.0955343171954155f, _167, _172);
  float _174 = _165 * -0.005525882821530104f;
  float _175 = mad(0.004025210160762072f, _166, _174);
  float _176 = mad(1.0015007257461548f, _167, _175);
  float _177 = _162.x + 1.0f;
  float _178 = _170 * _177;
  float _179 = _173 * _177;
  float _180 = _176 * _177;
  float _181 = _178 + _162.y;
  float _182 = max(_181, 0.0f);
  float _183 = max(_179, 0.0f);
  float _184 = max(_180, 0.0f);
  float _185 = min(_182, 65536.0f);
  float _186 = min(_183, 65536.0f);
  float _187 = min(_184, 65536.0f);
  float _188 = _185 * 1.4514392614364624f;
  float _189 = mad(-0.2365107536315918f, _186, _188);
  float _190 = mad(-0.21492856740951538f, _187, _189);
  float _191 = _185 * -0.07655377686023712f;
  float _192 = mad(1.17622971534729f, _186, _191);
  float _193 = mad(-0.09967592358589172f, _187, _192);
  float _194 = _185 * 0.008316148072481155f;
  float _195 = mad(-0.006032449658960104f, _186, _194);
  float _196 = mad(0.9977163076400757f, _187, _195);
  float _197 = max(_190, 0.0f);
  float _198 = max(_193, 0.0f);
  float _199 = max(_196, 0.0f);
  float _200 = min(_197, 65504.0f);
  float _201 = min(_198, 65504.0f);
  float _202 = min(_199, 65504.0f);
  float _203 = _200 * 0.970889151096344f;
  float _204 = mad(0.026963284239172935f, _201, _203);
  float _205 = mad(0.0021475818939507008f, _202, _204);
  float _206 = _200 * 0.010889154858887196f;
  float _207 = mad(0.9869632720947266f, _201, _206);
  float _208 = mad(0.0021475818939507008f, _202, _207);
  float _209 = mad(0.026963284239172935f, _201, _206);
  float _210 = mad(0.9621475338935852f, _202, _209);
  float _211 = log2(_205);
  float _212 = log2(_208);
  float _213 = log2(_210);
  float _214 = _211 + 17.47393035888672f;
  float _215 = _212 + 17.47393035888672f;
  float _216 = _213 + 17.47393035888672f;
  float _217 = _214 * 0.03030303120613098f;
  float _218 = _215 * 0.03030303120613098f;
  float _219 = _216 * 0.03030303120613098f;
  uint _220 = _139.x + -1u;
  float _221 = float((uint)_220);
  float _222 = float((uint)_139.x);
  float _223 = _221 / _222;
  float _224 = 0.5f / _222;
  float _225 = _217 * _223;
  float _226 = _218 * _223;
  float _227 = _219 * _223;
  float _228 = _225 + _224;
  float _229 = _226 + _224;
  float _230 = _227 + _224;
  float4 _231 = t13_space15.SampleLevel(s2_space1, float2(_228, 0.5f), 0.0f);
  float4 _233 = t13_space15.SampleLevel(s2_space1, float2(_229, 0.5f), 0.0f);
  float4 _235 = t13_space15.SampleLevel(s2_space1, float2(_230, 0.5f), 0.0f);
  float _237 = _231.x * 3.321928024291992f;
  float _238 = _233.x * 3.321928024291992f;
  float _239 = _235.x * 3.321928024291992f;
  float _240 = exp2(_237);
  float _241 = exp2(_238);
  float _242 = exp2(_239);
  float _243 = _240 / cb3_space9_036w;
  float _244 = _241 / cb3_space9_036w;
  float _245 = _242 / cb3_space9_036w;
  bool _246 = (cb3_space9_036y < 500.0f);
  float _284;
  float _285;
  float _286;
  float _336;
  float _344;
  float _352;
  if (_246) {
    float _248 = _243 * 0.6624541878700256f;
    float _249 = mad(0.13400420546531677f, _244, _248);
    float _250 = mad(0.15618768334388733f, _245, _249);
    float _251 = _243 * 0.2722287178039551f;
    float _252 = mad(0.6740817427635193f, _244, _251);
    float _253 = mad(0.053689517080783844f, _245, _252);
    float _254 = _243 * -0.005574649665504694f;
    float _255 = mad(0.00406073359772563f, _244, _254);
    float _256 = mad(1.0103391408920288f, _245, _255);
    float _257 = _253 + _250;
    float _258 = _257 + _256;
    bool _259 = (_258 == 0.0f);
    float _260 = select(_259, 1.000000013351432e-10f, _258);
    float _261 = _250 / _260;
    float _262 = _253 / _260;
    float _263 = max(_253, 0.0f);
    float _264 = log2(_263);
    float _265 = _264 * 0.9811000227928162f;
    float _266 = exp2(_265);
    float _267 = _266 * _261;
    float _268 = max(_262, 1.000000013351432e-10f);
    float _269 = _267 / _268;
    float _270 = 1.0f - _261;
    float _271 = _270 - _262;
    float _272 = _266 * _271;
    float _273 = _272 / _268;
    float _274 = _269 * 1.6410233974456787f;
    float _275 = mad(-0.32480329275131226f, _266, _274);
    float _276 = mad(-0.23642469942569733f, _273, _275);
    float _277 = _269 * -0.663662850856781f;
    float _278 = mad(1.6153316497802734f, _266, _277);
    float _279 = mad(0.016756348311901093f, _273, _278);
    float _280 = _269 * 0.011721894145011902f;
    float _281 = mad(-0.008284442126750946f, _266, _280);
    float _282 = mad(0.9883948564529419f, _273, _281);
    _284 = _276;
    _285 = _279;
    _286 = _282;
  } else {
    _284 = _243;
    _285 = _244;
    _286 = _245;
  }
  float _287 = _284 * 1.6047539710998535f;
  float _288 = mad(-0.5310794711112976f, _285, _287);
  float _289 = mad(-0.07367203384637833f, _286, _288);
  float _290 = _284 * -0.10208318382501602f;
  float _291 = mad(1.108132243156433f, _285, _290);
  float _292 = mad(-0.006051875650882721f, _286, _291);
  float _293 = _284 * -0.0032670421060174704f;
  float _294 = mad(-0.07275524735450745f, _285, _293);
  float _295 = mad(1.0760219097137451f, _286, _294);
  float _296 = max(_289, 0.0f);
  float _297 = max(_292, 0.0f);
  float _298 = max(_295, 0.0f);
  float _299 = _296 * ATTRIBUTE_VCOLOR.x;
  float _300 = _297 * ATTRIBUTE_VCOLOR.y;
  float _301 = _298 * ATTRIBUTE_VCOLOR.z;
  float _302 = abs(_299);
  float _303 = abs(_300);
  float _304 = abs(_301);
  float _305 = log2(_302);
  float _306 = log2(_303);
  float _307 = log2(_304);
  float _308 = _305 * 0.4166666567325592f;
  float _309 = _306 * 0.4166666567325592f;
  float _310 = _307 * 0.4166666567325592f;
  float _311 = exp2(_308);
  float _312 = exp2(_309);
  float _313 = exp2(_310);
  bool _314 = isfinite(_311);
  bool _315 = isfinite(_312);
  bool _316 = isfinite(_313);
  float _317 = _311 * 1.0549999475479126f;
  float _318 = _312 * 1.0549999475479126f;
  float _319 = _313 * 1.0549999475479126f;
  float _320 = _317 + -0.054999999701976776f;
  float _321 = select(_314, _320, 0.9999999403953552f);
  float _322 = _318 + -0.054999999701976776f;
  float _323 = select(_315, _322, 0.9999999403953552f);
  float _324 = _319 + -0.054999999701976776f;
  float _325 = select(_316, _324, 0.9999999403953552f);
  float _326 = _300 * 12.920000076293945f;
  float _327 = _301 * 12.920000076293945f;
  bool _328 = (_299 > 0.0031308000907301903f);
  if (!_328) {
    float _330 = _299 * 12.920000076293945f;
    bool _331 = (_299 < 0.0031308000907301903f);
    if (!_331) {
      bool _333 = (_299 == 0.0031308000907301903f);
      if (_333) {
        _336 = _321;
      } else {
        _336 = 0.0f;
      }
    } else {
      _336 = _330;
    }
  } else {
    _336 = _321;
  }
  bool _337 = (_300 > 0.0031308000907301903f);
  if (!_337) {
    bool _339 = (_300 < 0.0031308000907301903f);
    if (!_339) {
      bool _341 = (_300 == 0.0031308000907301903f);
      if (_341) {
        _344 = _323;
      } else {
        _344 = 0.0f;
      }
    } else {
      _344 = _326;
    }
  } else {
    _344 = _323;
  }
  bool _345 = (_301 > 0.0031308000907301903f);
  if (!_345) {
    bool _347 = (_301 < 0.0031308000907301903f);
    if (!_347) {
      bool _349 = (_301 == 0.0031308000907301903f);
      if (_349) {
        _352 = _325;
      } else {
        _352 = 0.0f;
      }
    } else {
      _352 = _327;
    }
  } else {
    _352 = _325;
  }
  float _353 = _22 - cb1_space9_034x;
  bool _354 = (_353 < 0.0f);
  if (_354) discard;
  float _360 = _22 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _361 = _360 * cb0_space5_008w;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_126, _127, _128), 1.f);
    _336 = video.r;
    _344 = video.g;
    _352 = video.b;
  }
  float _362 = _336 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _363 = _362 * cb0_space5_008x;
  float _364 = _363 * cb0_space5_008w;
  float _365 = _344 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _366 = _365 * cb0_space5_008y;
  float _367 = _366 * cb0_space5_008w;
  float _368 = _352 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _369 = _368 * cb0_space5_008z;
  float _370 = _369 * cb0_space5_008w;
  SV_Target.x = _364;
  SV_Target.y = _367;
  SV_Target.z = _370;
  SV_Target.w = _361;
  return SV_Target;
}

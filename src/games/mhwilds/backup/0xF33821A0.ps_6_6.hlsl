Texture2D<float4> SrcTexture : register(t0);

Texture2D<float4> OCIO_lut1d_0 : register(t1);

Texture3D<float4> OCIO_lut3d_1 : register(t2);

SamplerState PointBorder : register(s2, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _15 = (_11.x) * 0.6954519748687744f;
  float _16 = mad((_11.y), 0.1406790018081665f, _15);
  float _17 = mad((_11.z), 0.1638689935207367f, _16);
  float _18 = (_11.x) * 0.04479460045695305f;
  float _19 = mad((_11.y), 0.8596709966659546f, _18);
  float _20 = mad((_11.z), 0.0955343022942543f, _19);
  float _21 = (_11.x) * -0.00552588002756238f;
  float _22 = mad((_11.y), 0.004025210160762072f, _21);
  float _23 = mad((_11.z), 1.0015000104904175f, _22);
  float _24 = abs(_17);
  bool _25 = (_24 > 6.103515625e-05f);
  float _37;
  float _66;
  float _93;
  float _265;
  float _266;
  float _267;
  float _268;
  float _269;
  if (_25) {
    float _27 = min(_24, 65504.0f);
    float _28 = log2(_27);
    float _29 = floor(_28);
    float _30 = exp2(_29);
    float _31 = _27 - _30;
    float _32 = _31 / _30;
    float _33 = dot(float3(_29, _32, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _37 = _33;
  } else {
    float _35 = _24 * 16777216.0f;
    _37 = _35;
  }
  bool _38 = (_17 > 0.0f);
  float _39 = (_38 ? 0.0f : 32768.0f);
  float _40 = _37 + _39;
  float _41 = _40 * 0.00024420025874860585f;
  float _42 = floor(_41);
  float _43 = _42 * 4095.0f;
  float _44 = _40 + 0.5f;
  float _45 = _44 - _43;
  float _46 = _45 * 0.000244140625f;
  float _47 = _42 + 0.5f;
  float _48 = _47 * 0.05882352963089943f;
  float4 _51 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_46, _48), 0.0f);
  float _53 = abs(_20);
  bool _54 = (_53 > 6.103515625e-05f);
  if (_54) {
    float _56 = min(_53, 65504.0f);
    float _57 = log2(_56);
    float _58 = floor(_57);
    float _59 = exp2(_58);
    float _60 = _56 - _59;
    float _61 = _60 / _59;
    float _62 = dot(float3(_58, _61, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _66 = _62;
  } else {
    float _64 = _53 * 16777216.0f;
    _66 = _64;
  }
  bool _67 = (_20 > 0.0f);
  float _68 = (_67 ? 0.0f : 32768.0f);
  float _69 = _66 + _68;
  float _70 = _69 * 0.00024420025874860585f;
  float _71 = floor(_70);
  float _72 = _71 * 4095.0f;
  float _73 = _69 + 0.5f;
  float _74 = _73 - _72;
  float _75 = _74 * 0.000244140625f;
  float _76 = _71 + 0.5f;
  float _77 = _76 * 0.05882352963089943f;
  float4 _78 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_75, _77), 0.0f);
  float _80 = abs(_23);
  bool _81 = (_80 > 6.103515625e-05f);
  if (_81) {
    float _83 = min(_80, 65504.0f);
    float _84 = log2(_83);
    float _85 = floor(_84);
    float _86 = exp2(_85);
    float _87 = _83 - _86;
    float _88 = _87 / _86;
    float _89 = dot(float3(_85, _88, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _93 = _89;
  } else {
    float _91 = _80 * 16777216.0f;
    _93 = _91;
  }
  bool _94 = (_23 > 0.0f);
  float _95 = (_94 ? 0.0f : 32768.0f);
  float _96 = _93 + _95;
  float _97 = _96 * 0.00024420025874860585f;
  float _98 = floor(_97);
  float _99 = _98 * 4095.0f;
  float _100 = _96 + 0.5f;
  float _101 = _100 - _99;
  float _102 = _101 * 0.000244140625f;
  float _103 = _98 + 0.5f;
  float _104 = _103 * 0.05882352963089943f;
  float4 _105 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_102, _104), 0.0f);
  float _107 = (_51.x) * 64.0f;
  float _108 = (_78.x) * 64.0f;
  float _109 = (_105.x) * 64.0f;
  float _110 = floor(_107);
  float _111 = floor(_108);
  float _112 = floor(_109);
  float _113 = _107 - _110;
  float _114 = _108 - _111;
  float _115 = _109 - _112;
  float _116 = _112 + 0.5f;
  float _117 = _111 + 0.5f;
  float _118 = _110 + 0.5f;
  float _119 = _116 * 0.015384615398943424f;
  float _120 = _117 * 0.015384615398943424f;
  float _121 = _118 * 0.015384615398943424f;
  float4 _124 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _120, _121), 0.0f);
  float _128 = _119 + 0.015384615398943424f;
  float _129 = _120 + 0.015384615398943424f;
  float _130 = _121 + 0.015384615398943424f;
  float4 _131 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _129, _130), 0.0f);
  bool _135 = !(_113 >= _114);
  if (!_135) {
    bool _137 = !(_114 >= _115);
    if (!_137) {
      float4 _139 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _120, _130), 0.0f);
      float4 _143 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _129, _130), 0.0f);
      float _147 = _113 - _114;
      float _148 = _114 - _115;
      float _149 = (_139.x) * _147;
      float _150 = (_139.y) * _147;
      float _151 = (_139.z) * _147;
      float _152 = (_143.x) * _148;
      float _153 = (_143.y) * _148;
      float _154 = (_143.z) * _148;
      float _155 = _152 + _149;
      float _156 = _153 + _150;
      float _157 = _154 + _151;
      _265 = _155;
      _266 = _156;
      _267 = _157;
      _268 = _113;
      _269 = _115;
    } else {
      bool _159 = !(_113 >= _115);
      if (!_159) {
        float4 _161 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _120, _130), 0.0f);
        float4 _165 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _120, _130), 0.0f);
        float _169 = _113 - _115;
        float _170 = _115 - _114;
        float _171 = (_161.x) * _169;
        float _172 = (_161.y) * _169;
        float _173 = (_161.z) * _169;
        float _174 = (_165.x) * _170;
        float _175 = (_165.y) * _170;
        float _176 = (_165.z) * _170;
        float _177 = _174 + _171;
        float _178 = _175 + _172;
        float _179 = _176 + _173;
        _265 = _177;
        _266 = _178;
        _267 = _179;
        _268 = _113;
        _269 = _114;
      } else {
        float4 _181 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _120, _121), 0.0f);
        float4 _185 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _120, _130), 0.0f);
        float _189 = _115 - _113;
        float _190 = _113 - _114;
        float _191 = (_181.x) * _189;
        float _192 = (_181.y) * _189;
        float _193 = (_181.z) * _189;
        float _194 = (_185.x) * _190;
        float _195 = (_185.y) * _190;
        float _196 = (_185.z) * _190;
        float _197 = _194 + _191;
        float _198 = _195 + _192;
        float _199 = _196 + _193;
        _265 = _197;
        _266 = _198;
        _267 = _199;
        _268 = _115;
        _269 = _114;
      }
    }
  } else {
    bool _201 = !(_114 <= _115);
    if (!_201) {
      float4 _203 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _120, _121), 0.0f);
      float4 _207 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _129, _121), 0.0f);
      float _211 = _115 - _114;
      float _212 = _114 - _113;
      float _213 = (_203.x) * _211;
      float _214 = (_203.y) * _211;
      float _215 = (_203.z) * _211;
      float _216 = (_207.x) * _212;
      float _217 = (_207.y) * _212;
      float _218 = (_207.z) * _212;
      float _219 = _216 + _213;
      float _220 = _217 + _214;
      float _221 = _218 + _215;
      _265 = _219;
      _266 = _220;
      _267 = _221;
      _268 = _115;
      _269 = _113;
    } else {
      bool _223 = !(_113 >= _115);
      if (!_223) {
        float4 _225 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _129, _121), 0.0f);
        float4 _229 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _129, _130), 0.0f);
        float _233 = _114 - _113;
        float _234 = _113 - _115;
        float _235 = (_225.x) * _233;
        float _236 = (_225.y) * _233;
        float _237 = (_225.z) * _233;
        float _238 = (_229.x) * _234;
        float _239 = (_229.y) * _234;
        float _240 = (_229.z) * _234;
        float _241 = _238 + _235;
        float _242 = _239 + _236;
        float _243 = _240 + _237;
        _265 = _241;
        _266 = _242;
        _267 = _243;
        _268 = _114;
        _269 = _115;
      } else {
        float4 _245 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _129, _121), 0.0f);
        float4 _249 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _129, _121), 0.0f);
        float _253 = _114 - _115;
        float _254 = _115 - _113;
        float _255 = (_245.x) * _253;
        float _256 = (_245.y) * _253;
        float _257 = (_245.z) * _253;
        float _258 = (_249.x) * _254;
        float _259 = (_249.y) * _254;
        float _260 = (_249.z) * _254;
        float _261 = _258 + _255;
        float _262 = _259 + _256;
        float _263 = _260 + _257;
        _265 = _261;
        _266 = _262;
        _267 = _263;
        _268 = _114;
        _269 = _113;
      }
    }
  }
  float _270 = 1.0f - _268;
  float _271 = _270 * (_124.x);
  float _272 = _270 * (_124.y);
  float _273 = _270 * (_124.z);
  float _274 = _271 + _265;
  float _275 = _272 + _266;
  float _276 = _273 + _267;
  float _277 = _269 * (_131.x);
  float _278 = _269 * (_131.y);
  float _279 = _269 * (_131.z);
  float _280 = _274 + _277;
  float _281 = _275 + _278;
  float _282 = _276 + _279;
  float _283 = saturate(_280);
  float _284 = saturate(_281);
  float _285 = saturate(_282);
  float _286 = log2(_283);
  float _287 = log2(_284);
  float _288 = log2(_285);
  float _289 = _286 * 0.012683313339948654f;
  float _290 = _287 * 0.012683313339948654f;
  float _291 = _288 * 0.012683313339948654f;
  float _292 = exp2(_289);
  float _293 = exp2(_290);
  float _294 = exp2(_291);
  float _295 = _292 + -0.8359375f;
  float _296 = _293 + -0.8359375f;
  float _297 = _294 + -0.8359375f;
  float _298 = max(0.0f, _295);
  float _299 = max(0.0f, _296);
  float _300 = max(0.0f, _297);
  float _301 = _292 * 18.6875f;
  float _302 = _293 * 18.6875f;
  float _303 = _294 * 18.6875f;
  float _304 = 18.8515625f - _301;
  float _305 = 18.8515625f - _302;
  float _306 = 18.8515625f - _303;
  float _307 = _298 / _304;
  float _308 = _299 / _305;
  float _309 = _300 / _306;
  float _310 = log2(_307);
  float _311 = log2(_308);
  float _312 = log2(_309);
  float _313 = _310 * 6.277394771575928f;
  float _314 = _311 * 6.277394771575928f;
  float _315 = _312 * 6.277394771575928f;
  float _316 = exp2(_313);
  float _317 = exp2(_314);
  float _318 = exp2(_315);
  float _319 = _317 * 100.0f;
  float _320 = _318 * 100.0f;
  float _321 = _316 * 166.04910278320312f;
  float _322 = mad(-0.5876399874687195f, _319, _321);
  float _323 = mad(-0.07285170257091522f, _320, _322);
  float _324 = _316 * -12.454999923706055f;
  float _325 = mad(1.1328999996185303f, _319, _324);
  float _326 = mad(-0.00834800023585558f, _320, _325);
  float _327 = _316 * -1.8150999546051025f;
  float _328 = mad(-0.10057900100946426f, _319, _327);
  float _329 = mad(1.1187299489974976f, _320, _328);
  SV_Target.x = _323;
  SV_Target.y = _326;
  SV_Target.z = _329;
  SV_Target.w = 1.0f;
  return SV_Target;
}

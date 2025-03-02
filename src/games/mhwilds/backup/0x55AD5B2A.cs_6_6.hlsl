Texture2D<float4> OCIO_lut1d_0 : register(t0);

Texture3D<float4> OCIO_lut3d_1 : register(t1);

RWTexture3D<float4> OutLUT : register(u0);

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

[numthreads(8, 8, 8)]
void main(uint3 SV_DispatchThreadID: SV_DispatchThreadID) {
  float _9 = float((uint)(SV_DispatchThreadID.x));
  float _10 = float((uint)(SV_DispatchThreadID.y));
  float _11 = float((uint)(SV_DispatchThreadID.z));
  float _12 = _9 * 0.01587301678955555f;
  float _13 = _10 * 0.01587301678955555f;
  float _14 = _11 * 0.01587301678955555f;
  bool _15 = !(_12 <= -0.3013699948787689f);
  float _28;
  float _42;
  float _56;
  float _79;
  float _108;
  float _135;
  float _307;
  float _308;
  float _309;
  float _310;
  float _311;
  if (!_15) {
    float _17 = _9 * 0.2780952751636505f;
    float _18 = _17 + -8.720000267028809f;
    float _19 = exp2(_18);
    float _20 = _19 + -3.0517578125e-05f;
    _28 = _20;
  } else {
    bool _22 = (_12 < 1.468000054359436f);
    _28 = 65504.0f;
    if (_22) {
      float _24 = _9 * 0.2780952751636505f;
      float _25 = _24 + -9.720000267028809f;
      float _26 = exp2(_25);
      _28 = _26;
    }
  }
  bool _29 = !(_13 <= -0.3013699948787689f);
  if (!_29) {
    float _31 = _10 * 0.2780952751636505f;
    float _32 = _31 + -8.720000267028809f;
    float _33 = exp2(_32);
    float _34 = _33 + -3.0517578125e-05f;
    _42 = _34;
  } else {
    bool _36 = (_13 < 1.468000054359436f);
    _42 = 65504.0f;
    if (_36) {
      float _38 = _10 * 0.2780952751636505f;
      float _39 = _38 + -9.720000267028809f;
      float _40 = exp2(_39);
      _42 = _40;
    }
  }
  bool _43 = !(_14 <= -0.3013699948787689f);
  if (!_43) {
    float _45 = _11 * 0.2780952751636505f;
    float _46 = _45 + -8.720000267028809f;
    float _47 = exp2(_46);
    float _48 = _47 + -3.0517578125e-05f;
    _56 = _48;
  } else {
    bool _50 = (_14 < 1.468000054359436f);
    _56 = 65504.0f;
    if (_50) {
      float _52 = _11 * 0.2780952751636505f;
      float _53 = _52 + -9.720000267028809f;
      float _54 = exp2(_53);
      _56 = _54;
    }
  }
  float _57 = _28 * 0.6954519748687744f;
  float _58 = mad(_42, 0.1406790018081665f, _57);
  float _59 = mad(_56, 0.1638689935207367f, _58);
  float _60 = _28 * 0.04479460045695305f;
  float _61 = mad(_42, 0.8596709966659546f, _60);
  float _62 = mad(_56, 0.0955343022942543f, _61);
  float _63 = _28 * -0.00552588002756238f;
  float _64 = mad(_42, 0.004025210160762072f, _63);
  float _65 = mad(_56, 1.0015000104904175f, _64);
  float _66 = abs(_59);
  bool _67 = (_66 > 6.103515625e-05f);
  if (_67) {
    float _69 = min(_66, 65504.0f);
    float _70 = log2(_69);
    float _71 = floor(_70);
    float _72 = exp2(_71);
    float _73 = _69 - _72;
    float _74 = _73 / _72;
    float _75 = dot(float3(_71, _74, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _79 = _75;
  } else {
    float _77 = _66 * 16777216.0f;
    _79 = _77;
  }
  bool _80 = (_59 > 0.0f);
  float _81 = (_80 ? 0.0f : 32768.0f);
  float _82 = _79 + _81;
  float _83 = _82 * 0.00024420025874860585f;
  float _84 = floor(_83);
  float _85 = _84 * 4095.0f;
  float _86 = _82 + 0.5f;
  float _87 = _86 - _85;
  float _88 = _87 * 0.000244140625f;
  float _89 = _84 + 0.5f;
  float _90 = _89 * 0.05882352963089943f;
  float4 _93 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_88, _90), 0.0f);
  float _95 = abs(_62);
  bool _96 = (_95 > 6.103515625e-05f);
  if (_96) {
    float _98 = min(_95, 65504.0f);
    float _99 = log2(_98);
    float _100 = floor(_99);
    float _101 = exp2(_100);
    float _102 = _98 - _101;
    float _103 = _102 / _101;
    float _104 = dot(float3(_100, _103, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _108 = _104;
  } else {
    float _106 = _95 * 16777216.0f;
    _108 = _106;
  }
  bool _109 = (_62 > 0.0f);
  float _110 = (_109 ? 0.0f : 32768.0f);
  float _111 = _108 + _110;
  float _112 = _111 * 0.00024420025874860585f;
  float _113 = floor(_112);
  float _114 = _113 * 4095.0f;
  float _115 = _111 + 0.5f;
  float _116 = _115 - _114;
  float _117 = _116 * 0.000244140625f;
  float _118 = _113 + 0.5f;
  float _119 = _118 * 0.05882352963089943f;
  float4 _120 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_117, _119), 0.0f);
  float _122 = abs(_65);
  bool _123 = (_122 > 6.103515625e-05f);
  if (_123) {
    float _125 = min(_122, 65504.0f);
    float _126 = log2(_125);
    float _127 = floor(_126);
    float _128 = exp2(_127);
    float _129 = _125 - _128;
    float _130 = _129 / _128;
    float _131 = dot(float3(_127, _130, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _135 = _131;
  } else {
    float _133 = _122 * 16777216.0f;
    _135 = _133;
  }
  bool _136 = (_65 > 0.0f);
  float _137 = (_136 ? 0.0f : 32768.0f);
  float _138 = _135 + _137;
  float _139 = _138 * 0.00024420025874860585f;
  float _140 = floor(_139);
  float _141 = _140 * 4095.0f;
  float _142 = _138 + 0.5f;
  float _143 = _142 - _141;
  float _144 = _143 * 0.000244140625f;
  float _145 = _140 + 0.5f;
  float _146 = _145 * 0.05882352963089943f;
  float4 _147 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_144, _146), 0.0f);
  float _149 = (_93.x) * 64.0f;
  float _150 = (_120.x) * 64.0f;
  float _151 = (_147.x) * 64.0f;
  float _152 = floor(_149);
  float _153 = floor(_150);
  float _154 = floor(_151);
  float _155 = _149 - _152;
  float _156 = _150 - _153;
  float _157 = _151 - _154;
  float _158 = _154 + 0.5f;
  float _159 = _153 + 0.5f;
  float _160 = _152 + 0.5f;
  float _161 = _158 * 0.015384615398943424f;
  float _162 = _159 * 0.015384615398943424f;
  float _163 = _160 * 0.015384615398943424f;
  float4 _166 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _162, _163), 0.0f);
  float _170 = _161 + 0.015384615398943424f;
  float _171 = _162 + 0.015384615398943424f;
  float _172 = _163 + 0.015384615398943424f;
  float4 _173 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _171, _172), 0.0f);
  bool _177 = !(_155 >= _156);
  if (!_177) {
    bool _179 = !(_156 >= _157);
    if (!_179) {
      float4 _181 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _162, _172), 0.0f);
      float4 _185 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _171, _172), 0.0f);
      float _189 = _155 - _156;
      float _190 = _156 - _157;
      float _191 = (_181.x) * _189;
      float _192 = (_181.y) * _189;
      float _193 = (_181.z) * _189;
      float _194 = (_185.x) * _190;
      float _195 = (_185.y) * _190;
      float _196 = (_185.z) * _190;
      float _197 = _194 + _191;
      float _198 = _195 + _192;
      float _199 = _196 + _193;
      _307 = _197;
      _308 = _198;
      _309 = _199;
      _310 = _155;
      _311 = _157;
    } else {
      bool _201 = !(_155 >= _157);
      if (!_201) {
        float4 _203 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _162, _172), 0.0f);
        float4 _207 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _162, _172), 0.0f);
        float _211 = _155 - _157;
        float _212 = _157 - _156;
        float _213 = (_203.x) * _211;
        float _214 = (_203.y) * _211;
        float _215 = (_203.z) * _211;
        float _216 = (_207.x) * _212;
        float _217 = (_207.y) * _212;
        float _218 = (_207.z) * _212;
        float _219 = _216 + _213;
        float _220 = _217 + _214;
        float _221 = _218 + _215;
        _307 = _219;
        _308 = _220;
        _309 = _221;
        _310 = _155;
        _311 = _156;
      } else {
        float4 _223 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _162, _163), 0.0f);
        float4 _227 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _162, _172), 0.0f);
        float _231 = _157 - _155;
        float _232 = _155 - _156;
        float _233 = (_223.x) * _231;
        float _234 = (_223.y) * _231;
        float _235 = (_223.z) * _231;
        float _236 = (_227.x) * _232;
        float _237 = (_227.y) * _232;
        float _238 = (_227.z) * _232;
        float _239 = _236 + _233;
        float _240 = _237 + _234;
        float _241 = _238 + _235;
        _307 = _239;
        _308 = _240;
        _309 = _241;
        _310 = _157;
        _311 = _156;
      }
    }
  } else {
    bool _243 = !(_156 <= _157);
    if (!_243) {
      float4 _245 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _162, _163), 0.0f);
      float4 _249 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _171, _163), 0.0f);
      float _253 = _157 - _156;
      float _254 = _156 - _155;
      float _255 = (_245.x) * _253;
      float _256 = (_245.y) * _253;
      float _257 = (_245.z) * _253;
      float _258 = (_249.x) * _254;
      float _259 = (_249.y) * _254;
      float _260 = (_249.z) * _254;
      float _261 = _258 + _255;
      float _262 = _259 + _256;
      float _263 = _260 + _257;
      _307 = _261;
      _308 = _262;
      _309 = _263;
      _310 = _157;
      _311 = _155;
    } else {
      bool _265 = !(_155 >= _157);
      if (!_265) {
        float4 _267 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _171, _163), 0.0f);
        float4 _271 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _171, _172), 0.0f);
        float _275 = _156 - _155;
        float _276 = _155 - _157;
        float _277 = (_267.x) * _275;
        float _278 = (_267.y) * _275;
        float _279 = (_267.z) * _275;
        float _280 = (_271.x) * _276;
        float _281 = (_271.y) * _276;
        float _282 = (_271.z) * _276;
        float _283 = _280 + _277;
        float _284 = _281 + _278;
        float _285 = _282 + _279;
        _307 = _283;
        _308 = _284;
        _309 = _285;
        _310 = _156;
        _311 = _157;
      } else {
        float4 _287 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _171, _163), 0.0f);
        float4 _291 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _171, _163), 0.0f);
        float _295 = _156 - _157;
        float _296 = _157 - _155;
        float _297 = (_287.x) * _295;
        float _298 = (_287.y) * _295;
        float _299 = (_287.z) * _295;
        float _300 = (_291.x) * _296;
        float _301 = (_291.y) * _296;
        float _302 = (_291.z) * _296;
        float _303 = _300 + _297;
        float _304 = _301 + _298;
        float _305 = _302 + _299;
        _307 = _303;
        _308 = _304;
        _309 = _305;
        _310 = _156;
        _311 = _155;
      }
    }
  }
  float _312 = 1.0f - _310;
  float _313 = _312 * (_166.x);
  float _314 = _312 * (_166.y);
  float _315 = _312 * (_166.z);
  float _316 = _313 + _307;
  float _317 = _314 + _308;
  float _318 = _315 + _309;
  float _319 = _311 * (_173.x);
  float _320 = _311 * (_173.y);
  float _321 = _311 * (_173.z);
  float _322 = _316 + _319;
  float _323 = _317 + _320;
  float _324 = _318 + _321;
  float _325 = saturate(_322);
  float _326 = saturate(_323);
  float _327 = saturate(_324);
  float _328 = log2(_325);
  float _329 = log2(_326);
  float _330 = log2(_327);
  float _331 = _328 * 0.012683313339948654f;
  float _332 = _329 * 0.012683313339948654f;
  float _333 = _330 * 0.012683313339948654f;
  float _334 = exp2(_331);
  float _335 = exp2(_332);
  float _336 = exp2(_333);
  float _337 = _334 + -0.8359375f;
  float _338 = _335 + -0.8359375f;
  float _339 = _336 + -0.8359375f;
  float _340 = max(0.0f, _337);
  float _341 = max(0.0f, _338);
  float _342 = max(0.0f, _339);
  float _343 = _334 * 18.6875f;
  float _344 = _335 * 18.6875f;
  float _345 = _336 * 18.6875f;
  float _346 = 18.8515625f - _343;
  float _347 = 18.8515625f - _344;
  float _348 = 18.8515625f - _345;
  float _349 = _340 / _346;
  float _350 = _341 / _347;
  float _351 = _342 / _348;
  float _352 = log2(_349);
  float _353 = log2(_350);
  float _354 = log2(_351);
  float _355 = _352 * 6.277394771575928f;
  float _356 = _353 * 6.277394771575928f;
  float _357 = _354 * 6.277394771575928f;
  float _358 = exp2(_355);
  float _359 = exp2(_356);
  float _360 = exp2(_357);
  float _361 = _359 * 100.0f;
  float _362 = _360 * 100.0f;
  float _363 = _358 * 166.04910278320312f;
  float _364 = mad(-0.5876399874687195f, _361, _363);
  float _365 = mad(-0.07285170257091522f, _362, _364);
  float _366 = _358 * -12.454999923706055f;
  float _367 = mad(1.1328999996185303f, _361, _366);
  float _368 = mad(-0.00834800023585558f, _362, _367);
  float _369 = _358 * -1.8150999546051025f;
  float _370 = mad(-0.10057900100946426f, _361, _369);
  float _371 = mad(1.1187299489974976f, _362, _370);
  OutLUT[int3(((uint)(SV_DispatchThreadID.x)), ((uint)(SV_DispatchThreadID.y)), ((uint)(SV_DispatchThreadID.z)))] = float4(_365, _368, _371, 1.0f);
}

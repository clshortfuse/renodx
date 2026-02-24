#include "../OCIO.hlsli"

Texture2D<float4> OCIO_lut1d_0 : register(t0);

Texture3D<float4> OCIO_lut3d_1 : register(t1);

RWTexture3D<float4> OutLUT : register(u0);

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _9 = float((uint)SV_DispatchThreadID.x);
  float _10 = float((uint)SV_DispatchThreadID.y);
  float _11 = float((uint)SV_DispatchThreadID.z);
  float _12 = _9 * 0.01587301678955555f;
  float _13 = _10 * 0.01587301678955555f;
  float _14 = _11 * 0.01587301678955555f;
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
  float _335;
  float _346;
  float _357;
  if (!(!(_12 <= -0.3013699948787689f))) {
    _28 = (exp2((_9 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_12 < 1.468000054359436f) {
      _28 = exp2((_9 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _28 = 65504.0f;
    }
  }
  if (!(!(_13 <= -0.3013699948787689f))) {
    _42 = (exp2((_10 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_13 < 1.468000054359436f) {
      _42 = exp2((_10 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _42 = 65504.0f;
    }
  }
  if (!(!(_14 <= -0.3013699948787689f))) {
    _56 = (exp2((_11 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_14 < 1.468000054359436f) {
      _56 = exp2((_11 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _56 = 65504.0f;
    }
  }

  // AP1 -> AP0
  float _59 = mad(_56, 0.1638689935207367f, mad(_42, 0.1406790018081665f, (_28 * 0.6954519748687744f)));
  float _62 = mad(_56, 0.0955343022942543f, mad(_42, 0.8596709966659546f, (_28 * 0.04479460045695305f)));
  float _65 = mad(_56, 1.0015000104904175f, mad(_42, 0.004025210160762072f, (_28 * -0.00552588002756238f)));
  float _66 = abs(_59);
  if (_66 > 6.103515625e-05f) {
    float _69 = min(_66, 65504.0f);
    float _71 = floor(log2(_69));
    float _72 = exp2(_71);
    _79 = dot(float3(_71, ((_69 - _72) / _72), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _79 = (_66 * 16777216.0f);
  }
  float _82 = _79 + select((_59 < 0.0f), 32768.0f, 0.0f);
  float _84 = floor(_82 * 0.00024420025874860585f);
  float4 _93 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_82 + 0.5f) - (_84 * 4095.0f)) * 0.000244140625f), ((_84 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _95 = abs(_62);
  if (_95 > 6.103515625e-05f) {
    float _98 = min(_95, 65504.0f);
    float _100 = floor(log2(_98));
    float _101 = exp2(_100);
    _108 = dot(float3(_100, ((_98 - _101) / _101), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _108 = (_95 * 16777216.0f);
  }
  float _111 = _108 + select((_62 < 0.0f), 32768.0f, 0.0f);
  float _113 = floor(_111 * 0.00024420025874860585f);
  float4 _120 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_111 + 0.5f) - (_113 * 4095.0f)) * 0.000244140625f), ((_113 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _122 = abs(_65);
  if (_122 > 6.103515625e-05f) {
    float _125 = min(_122, 65504.0f);
    float _127 = floor(log2(_125));
    float _128 = exp2(_127);
    _135 = dot(float3(_127, ((_125 - _128) / _128), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _135 = (_122 * 16777216.0f);
  }
  float _138 = _135 + select((_65 < 0.0f), 32768.0f, 0.0f);
  float _140 = floor(_138 * 0.00024420025874860585f);
  float4 _147 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_138 + 0.5f) - (_140 * 4095.0f)) * 0.000244140625f), ((_140 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _149 = _93.x * 64.0f;
  float _150 = _120.x * 64.0f;
  float _151 = _147.x * 64.0f;
  float _152 = floor(_149);
  float _153 = floor(_150);
  float _154 = floor(_151);
  float _155 = _149 - _152;
  float _156 = _150 - _153;
  float _157 = _151 - _154;
  float _161 = (_154 + 0.5f) * 0.015384615398943424f;
  float _162 = (_153 + 0.5f) * 0.015384615398943424f;
  float _163 = (_152 + 0.5f) * 0.015384615398943424f;
  float4 _166 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _162, _163), 0.0f);
  float _170 = _161 + 0.015384615398943424f;
  float _171 = _162 + 0.015384615398943424f;
  float _172 = _163 + 0.015384615398943424f;
  float4 _173 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _171, _172), 0.0f);
  if (!(!(_155 >= _156))) {
    if (!(!(_156 >= _157))) {
      float4 _181 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _162, _172), 0.0f);
      float4 _185 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _171, _172), 0.0f);
      float _189 = _155 - _156;
      float _190 = _156 - _157;
      _307 = ((_185.x * _190) + (_181.x * _189));
      _308 = ((_185.y * _190) + (_181.y * _189));
      _309 = ((_185.z * _190) + (_181.z * _189));
      _310 = _155;
      _311 = _157;
    } else {
      if (!(!(_155 >= _157))) {
        float4 _203 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _162, _172), 0.0f);
        float4 _207 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _162, _172), 0.0f);
        float _211 = _155 - _157;
        float _212 = _157 - _156;
        _307 = ((_207.x * _212) + (_203.x * _211));
        _308 = ((_207.y * _212) + (_203.y * _211));
        _309 = ((_207.z * _212) + (_203.z * _211));
        _310 = _155;
        _311 = _156;
      } else {
        float4 _223 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _162, _163), 0.0f);
        float4 _227 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _162, _172), 0.0f);
        float _231 = _157 - _155;
        float _232 = _155 - _156;
        _307 = ((_227.x * _232) + (_223.x * _231));
        _308 = ((_227.y * _232) + (_223.y * _231));
        _309 = ((_227.z * _232) + (_223.z * _231));
        _310 = _157;
        _311 = _156;
      }
    }
  } else {
    if (!(!(_156 <= _157))) {
      float4 _245 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _162, _163), 0.0f);
      float4 _249 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _171, _163), 0.0f);
      float _253 = _157 - _156;
      float _254 = _156 - _155;
      _307 = ((_249.x * _254) + (_245.x * _253));
      _308 = ((_249.y * _254) + (_245.y * _253));
      _309 = ((_249.z * _254) + (_245.z * _253));
      _310 = _157;
      _311 = _155;
    } else {
      if (!(!(_155 >= _157))) {
        float4 _267 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _171, _163), 0.0f);
        float4 _271 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _171, _172), 0.0f);
        float _275 = _156 - _155;
        float _276 = _155 - _157;
        _307 = ((_271.x * _276) + (_267.x * _275));
        _308 = ((_271.y * _276) + (_267.y * _275));
        _309 = ((_271.z * _276) + (_267.z * _275));
        _310 = _156;
        _311 = _157;
      } else {
        float4 _287 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_161, _171, _163), 0.0f);
        float4 _291 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_170, _171, _163), 0.0f);
        float _295 = _156 - _157;
        float _296 = _157 - _155;
        _307 = ((_291.x * _296) + (_287.x * _295));
        _308 = ((_291.y * _296) + (_287.y * _295));
        _309 = ((_291.z * _296) + (_287.z * _295));
        _310 = _156;
        _311 = _155;
      }
    }
  }
  float _312 = 1.0f - _310;
  float _322 = ((_312 * _166.x) + _307) + (_311 * _173.x);
  float _323 = ((_312 * _166.y) + _308) + (_311 * _173.y);
  float _324 = ((_312 * _166.z) + _309) + (_311 * _173.z);
  if (!(!(_322 >= 0.03928571194410324f))) {
    _335 = exp2(log2((_322 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _335 = (_322 * 0.07738011330366135f);
  }
  if (!(!(_323 >= 0.03928571194410324f))) {
    _346 = exp2(log2((_323 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _346 = (_323 * 0.07738011330366135f);
  }
  if (!(!(_324 >= 0.03928571194410324f))) {
    _357 = exp2(log2((_324 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _357 = (_324 * 0.07738011330366135f);
  }

  OutLUT[SV_DispatchThreadID] = float4(_335, _346, _357, 1.0f);
}


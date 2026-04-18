#include "../common.hlsli"

float3 SampleOCIO(
    float3 _61, float _64, float _67,
    Texture2D<float4> OCIO_lut1d_0, SamplerState BilinearClamp,
    Texture3D<float4> OCIO_lut3d_1, SamplerState TrilinearClamp) {
  float _81;
  float _110;
  float _137;
  float _309;
  float _310;
  float _311;
  float _312;
  float _313;

  // lut sample START
  float _68 = abs(_61);
  if (_68 > 6.103515625e-05f) {
    float _71 = min(_68, 65504.0f);
    float _73 = floor(log2(_71));
    float _74 = exp2(_73);
    _81 = dot(float3(_73, ((_71 - _74) / _74), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _81 = (_68 * 16777216.0f);
  }
  float _84 = _81 + select((_61 < 0.0f), 32768.0f, 0.0f);
  float _86 = floor(_84 * 0.00024420025874860585f);
  float4 _95 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_84 + 0.5f) - (_86 * 4095.0f)) * 0.000244140625f), ((_86 + 0.5f) * 0.05882352963089943f)), 0.0f);

  float _97 = abs(_64);
  if (_97 > 6.103515625e-05f) {
    float _100 = min(_97, 65504.0f);
    float _102 = floor(log2(_100));
    float _103 = exp2(_102);
    _110 = dot(float3(_102, ((_100 - _103) / _103), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _110 = (_97 * 16777216.0f);
  }
  float _113 = _110 + select((_64 < 0.0f), 32768.0f, 0.0f);
  float _115 = floor(_113 * 0.00024420025874860585f);
  float4 _122 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_113 + 0.5f) - (_115 * 4095.0f)) * 0.000244140625f), ((_115 + 0.5f) * 0.05882352963089943f)), 0.0f);

  float _124 = abs(_67);
  if (_124 > 6.103515625e-05f) {
    float _127 = min(_124, 65504.0f);
    float _129 = floor(log2(_127));
    float _130 = exp2(_129);
    _137 = dot(float3(_129, ((_127 - _130) / _130), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _137 = (_124 * 16777216.0f);
  }
  float _140 = _137 + select((_67 < 0.0f), 32768.0f, 0.0f);
  float _142 = floor(_140 * 0.00024420025874860585f);
  float4 _149 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_140 + 0.5f) - (_142 * 4095.0f)) * 0.000244140625f), ((_142 + 0.5f) * 0.05882352963089943f)), 0.0f);

  float _151 = _95.x * 64.0f;
  float _152 = _122.x * 64.0f;
  float _153 = _149.x * 64.0f;
  float _154 = floor(_151);
  float _155 = floor(_152);
  float _156 = floor(_153);
  float _157 = _151 - _154;
  float _158 = _152 - _155;
  float _159 = _153 - _156;

  float _163 = (_156 + 0.5f) * 0.015384615398943424f;
  float _164 = (_155 + 0.5f) * 0.015384615398943424f;
  float _165 = (_154 + 0.5f) * 0.015384615398943424f;
  float4 _168 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _164, _165), 0.0f);
  float _172 = _163 + 0.015384615398943424f;
  float _173 = _164 + 0.015384615398943424f;
  float _174 = _165 + 0.015384615398943424f;
  float4 _175 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _173, _174), 0.0f);

  if (!(!(_157 >= _158))) {
    if (!(!(_158 >= _159))) {
      float4 _183 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _164, _174), 0.0f);
      float4 _187 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _174), 0.0f);
      float _191 = _157 - _158;
      float _192 = _158 - _159;
      _309 = ((_187.x * _192) + (_183.x * _191));
      _310 = ((_187.y * _192) + (_183.y * _191));
      _311 = ((_187.z * _192) + (_183.z * _191));
      _312 = _157;
      _313 = _159;
    } else {
      if (!(!(_157 >= _159))) {
        float4 _205 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _164, _174), 0.0f);
        float4 _209 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _174), 0.0f);
        float _213 = _157 - _159;
        float _214 = _159 - _158;
        _309 = ((_209.x * _214) + (_205.x * _213));
        _310 = ((_209.y * _214) + (_205.y * _213));
        _311 = ((_209.z * _214) + (_205.z * _213));
        _312 = _157;
        _313 = _158;
      } else {
        float4 _225 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _165), 0.0f);
        float4 _229 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _174), 0.0f);
        float _233 = _159 - _157;
        float _234 = _157 - _158;
        _309 = ((_229.x * _234) + (_225.x * _233));
        _310 = ((_229.y * _234) + (_225.y * _233));
        _311 = ((_229.z * _234) + (_225.z * _233));
        _312 = _159;
        _313 = _158;
      }
    }
  } else {
    if (!(!(_158 <= _159))) {
      float4 _247 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _165), 0.0f);
      float4 _251 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _173, _165), 0.0f);
      float _255 = _159 - _158;
      float _256 = _158 - _157;
      _309 = ((_251.x * _256) + (_247.x * _255));
      _310 = ((_251.y * _256) + (_247.y * _255));
      _311 = ((_251.z * _256) + (_247.z * _255));
      _312 = _159;
      _313 = _157;
    } else {
      if (!(!(_157 >= _159))) {
        float4 _269 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _165), 0.0f);
        float4 _273 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _174), 0.0f);
        float _277 = _158 - _157;
        float _278 = _157 - _159;
        _309 = ((_273.x * _278) + (_269.x * _277));
        _310 = ((_273.y * _278) + (_269.y * _277));
        _311 = ((_273.z * _278) + (_269.z * _277));
        _312 = _158;
        _313 = _159;
      } else {
        float4 _289 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _165), 0.0f);
        float4 _293 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _173, _165), 0.0f);
        float _297 = _158 - _159;
        float _298 = _159 - _157;
        _309 = ((_293.x * _298) + (_289.x * _297));
        _310 = ((_293.y * _298) + (_289.y * _297));
        _311 = ((_293.z * _298) + (_289.z * _297));
        _312 = _158;
        _313 = _157;
      }
    }
  }

  float _314 = 1.0f - _312;
  float3 lut_output = float3((((_314 * _168.x) + _309) + (_313 * _175.x)),
                             (((_314 * _168.y) + _310) + (_313 * _175.y)),
                             (((_314 * _168.z) + _311) + (_313 * _175.z)));
  // lut sample END

  return lut_output;
}

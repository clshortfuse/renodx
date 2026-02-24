#include "../OCIO.hlsli"

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
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  // AP1 -> AP0
  float _17 = mad(_11.z, 0.1638689935207367f, mad(_11.y, 0.1406790018081665f, (_11.x * 0.6954519748687744f)));
  float _20 = mad(_11.z, 0.0955343022942543f, mad(_11.y, 0.8596709966659546f, (_11.x * 0.04479460045695305f)));
  float _23 = mad(_11.z, 1.0015000104904175f, mad(_11.y, 0.004025210160762072f, (_11.x * -0.00552588002756238f)));
  float _24 = abs(_17);
  float _37;
  float _66;
  float _93;
  float _265;
  float _266;
  float _267;
  float _268;
  float _269;
  if (_24 > 6.103515625e-05f) {
    float _27 = min(_24, 65504.0f);
    float _29 = floor(log2(_27));
    float _30 = exp2(_29);
    _37 = dot(float3(_29, ((_27 - _30) / _30), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _37 = (_24 * 16777216.0f);
  }
  float _40 = _37 + select((_17 < 0.0f), 32768.0f, 0.0f);
  float _42 = floor(_40 * 0.00024420025874860585f);
  float4 _51 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_40 + 0.5f) - (_42 * 4095.0f)) * 0.000244140625f), ((_42 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _53 = abs(_20);
  if (_53 > 6.103515625e-05f) {
    float _56 = min(_53, 65504.0f);
    float _58 = floor(log2(_56));
    float _59 = exp2(_58);
    _66 = dot(float3(_58, ((_56 - _59) / _59), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _66 = (_53 * 16777216.0f);
  }
  float _69 = _66 + select((_20 < 0.0f), 32768.0f, 0.0f);
  float _71 = floor(_69 * 0.00024420025874860585f);
  float4 _78 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_69 + 0.5f) - (_71 * 4095.0f)) * 0.000244140625f), ((_71 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _80 = abs(_23);
  if (_80 > 6.103515625e-05f) {
    float _83 = min(_80, 65504.0f);
    float _85 = floor(log2(_83));
    float _86 = exp2(_85);
    _93 = dot(float3(_85, ((_83 - _86) / _86), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _93 = (_80 * 16777216.0f);
  }
  float _96 = _93 + select((_23 < 0.0f), 32768.0f, 0.0f);
  float _98 = floor(_96 * 0.00024420025874860585f);
  float4 _105 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_96 + 0.5f) - (_98 * 4095.0f)) * 0.000244140625f), ((_98 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _107 = _51.x * 64.0f;
  float _108 = _78.x * 64.0f;
  float _109 = _105.x * 64.0f;
  float _110 = floor(_107);
  float _111 = floor(_108);
  float _112 = floor(_109);
  float _113 = _107 - _110;
  float _114 = _108 - _111;
  float _115 = _109 - _112;
  float _119 = (_112 + 0.5f) * 0.015384615398943424f;
  float _120 = (_111 + 0.5f) * 0.015384615398943424f;
  float _121 = (_110 + 0.5f) * 0.015384615398943424f;
  float4 _124 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _120, _121), 0.0f);
  float _128 = _119 + 0.015384615398943424f;
  float _129 = _120 + 0.015384615398943424f;
  float _130 = _121 + 0.015384615398943424f;
  float4 _131 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _129, _130), 0.0f);
  if (!(!(_113 >= _114))) {
    if (!(!(_114 >= _115))) {
      float4 _139 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _120, _130), 0.0f);
      float4 _143 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _129, _130), 0.0f);
      float _147 = _113 - _114;
      float _148 = _114 - _115;
      _265 = ((_143.x * _148) + (_139.x * _147));
      _266 = ((_143.y * _148) + (_139.y * _147));
      _267 = ((_143.z * _148) + (_139.z * _147));
      _268 = _113;
      _269 = _115;
    } else {
      if (!(!(_113 >= _115))) {
        float4 _161 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _120, _130), 0.0f);
        float4 _165 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _120, _130), 0.0f);
        float _169 = _113 - _115;
        float _170 = _115 - _114;
        _265 = ((_165.x * _170) + (_161.x * _169));
        _266 = ((_165.y * _170) + (_161.y * _169));
        _267 = ((_165.z * _170) + (_161.z * _169));
        _268 = _113;
        _269 = _114;
      } else {
        float4 _181 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _120, _121), 0.0f);
        float4 _185 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _120, _130), 0.0f);
        float _189 = _115 - _113;
        float _190 = _113 - _114;
        _265 = ((_185.x * _190) + (_181.x * _189));
        _266 = ((_185.y * _190) + (_181.y * _189));
        _267 = ((_185.z * _190) + (_181.z * _189));
        _268 = _115;
        _269 = _114;
      }
    }
  } else {
    if (!(!(_114 <= _115))) {
      float4 _203 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _120, _121), 0.0f);
      float4 _207 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _129, _121), 0.0f);
      float _211 = _115 - _114;
      float _212 = _114 - _113;
      _265 = ((_207.x * _212) + (_203.x * _211));
      _266 = ((_207.y * _212) + (_203.y * _211));
      _267 = ((_207.z * _212) + (_203.z * _211));
      _268 = _115;
      _269 = _113;
    } else {
      if (!(!(_113 >= _115))) {
        float4 _225 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _129, _121), 0.0f);
        float4 _229 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _129, _130), 0.0f);
        float _233 = _114 - _113;
        float _234 = _113 - _115;
        _265 = ((_229.x * _234) + (_225.x * _233));
        _266 = ((_229.y * _234) + (_225.y * _233));
        _267 = ((_229.z * _234) + (_225.z * _233));
        _268 = _114;
        _269 = _115;
      } else {
        float4 _245 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_119, _129, _121), 0.0f);
        float4 _249 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_128, _129, _121), 0.0f);
        float _253 = _114 - _115;
        float _254 = _115 - _113;
        _265 = ((_249.x * _254) + (_245.x * _253));
        _266 = ((_249.y * _254) + (_245.y * _253));
        _267 = ((_249.z * _254) + (_245.z * _253));
        _268 = _114;
        _269 = _113;
      }
    }
  }
  float _270 = 1.0f - _268;
  SV_Target.x = (((_270 * _124.x) + _265) + (_269 * _131.x));
  SV_Target.y = (((_270 * _124.y) + _266) + (_269 * _131.y));
  SV_Target.z = (((_270 * _124.z) + _267) + (_269 * _131.z));
  SV_Target.w = 1.0f;

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}



#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float cb0_015z : packoffset(c015.z);
};

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  int _6 = int(SV_Position.x);
  int _7 = int(SV_Position.y);
  float4 _9 = t0.Load(int3(_6, _7, 0));
  return _9;
  float4 _18 = t0.Load(int3(_6, ((uint)(_7 + -1u)), 0));
  float4 _23 = t0.Load(int3(((uint)(_6 + -1u)), _7, 0));
  float4 _31 = t0.Load(int3(((uint)(_6 + 1u)), _7, 0));
  float4 _36 = t0.Load(int3(_6, ((uint)(_7 + 1u)), 0));
  float _41 = _18.y * _18.y;
  float _44 = _23.y * _23.y;
  float _47 = _9.y * _9.y;
  float _50 = _31.y * _31.y;
  float _53 = _36.y * _36.y;
  float _62 = max(max(_44, max(_47, _50)), max(_41, _53));
  float _74 = asfloat(((uint)(((int)((uint)((int)(asint(saturate(asfloat(((uint)(2129690299u - (int)(asint(_62))))) * min(min(min(_44, min(_47, _50)), min(_41, _53)), (1.0f - _62)))))) >> 1)) + 532432441u))) * (1.0f / (8.0f - (saturate(cb0_015z) * 3.0f)));
  float _75 = -0.0f - _74;
  float _77 = 1.0f - (_74 * 4.0f);
  float _80 = asfloat(((uint)(2129764351u - (int)(asint(_77)))));
  float _83 = (2.0f - (_80 * _77)) * _80;
  /* SV_Target.x = sqrt(saturate(_83 * ((((((_23.x * _23.x) + (_18.x * _18.x)) + (_31.x * _31.x)) + (_36.x * _36.x)) * _75) + (_9.x * _9.x))));
  SV_Target.y = sqrt(saturate(_83 * (((((_44 + _41) + _50) + _53) * _75) + _47)));
  SV_Target.z = sqrt(saturate(_83 * ((((((_23.z * _23.z) + (_18.z * _18.z)) + (_31.z * _31.z)) + (_36.z * _36.z)) * _75) + (_9.z * _9.z))));
   */

  SV_Target.x = renodx::math::SqrtSafe((_83 * ((((((_23.x * _23.x) + (_18.x * _18.x)) + (_31.x * _31.x)) + (_36.x * _36.x)) * _75) + (_9.x * _9.x))));
  SV_Target.y = renodx::math::SqrtSafe((_83 * (((((_44 + _41) + _50) + _53) * _75) + _47)));
  SV_Target.z = renodx::math::SqrtSafe((_83 * ((((((_23.z * _23.z) + (_18.z * _18.z)) + (_31.z * _31.z)) + (_36.z * _36.z)) * _75) + (_9.z * _9.z))));

  SV_Target.w = _9.w;
  return SV_Target;
}

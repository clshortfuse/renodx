#include "./common.hlsl"
#include "./uncharted2.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb12 : register(b12) {
  float cb12_022x : packoffset(c022.x);
  float cb12_022y : packoffset(c022.y);
  float cb12_073x : packoffset(c073.x);
  float cb12_073y : packoffset(c073.y);
  float cb12_270x : packoffset(c270.x);
  float cb12_270y : packoffset(c270.y);
  float cb12_271x : packoffset(c271.x);
};

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  int _10 = int(SV_Position.x);
  int _11 = int(SV_Position.y);
  float _14 = 1.0f / cb12_271x;
  float _18 = cb12_073y * _14;
  float _19 = float(_10);
  float _20 = float(_11);
  float4 _32 = t1.Load(int3((uint)(uint(((cb12_270x * _14) + _19) * cb12_271x)), (uint)(uint((_20 - (cb12_270y * _14)) * cb12_271x)), 0));
  float4 _34 = t0.Load(int3(_10, _11, 0));

  // if (RENODX_TONE_MAP_TYPE != 0) {
  //   // float clamp_value = Uncharted2Tonemap1(100.f);
  //   float clamp_value = 5.f;
  //   _34.rgb = ClampPostProcessing(_34.rgb, clamp_value);

  //   //_34.rgb = Uncharted2Tonemap1(_34.rgb);
  // }

  float _41 = ((_14 * CustomPixelConsts_032.x) * cb12_073x) - _19;
  float _42 = (_18 * CustomPixelConsts_032.y) - _20;
  float _58 = saturate(select((((cb12_022x * _32.x) + cb12_022y) >= 1.0f), 1.0f, 0.0f) + float((bool)(bool)((sqrt((_41 * _41) + (_42 * _42)) / _18) < 0.05000000074505806f)));

  //_58 *= CUSTOM_SUNSHAFTS_STRENGTH;
  //_34.rgb *= CUSTOM_SUNSHAFTS_STRENGTH;

  SV_Target.x = (_58 * _34.x);
  SV_Target.y = (_58 * _34.y);
  SV_Target.z = (_58 * _34.z);

  // SV_Target.rgb = CustomBloomTonemap(SV_Target.rgb, 0.8f);
  //SV_Target.rgb *= CUSTOM_SUNSHAFTS_STRENGTH;

  SV_Target.w = 1.0f;
  return SV_Target;
}

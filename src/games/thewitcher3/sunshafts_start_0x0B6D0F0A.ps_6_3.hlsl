#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

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

  if (RENODX_TONE_MAP_TYPE != 0) {
    _34.rgb = min(_34.rgb, 1.f);
  }


  float temp_cb12_022x = cb12_022x;
  float temp_cb12_022y = cb12_022y;
  if (RENODX_TONE_MAP_TYPE != 0) {
    //temp_cb12_022x *= 200;
    //temp_cb12_022y *= 20;
  }

  float _41 = ((_14 * CustomPixelConsts_032.x) * cb12_073x) - _19;
  float _42 = (_18 * CustomPixelConsts_032.y) - _20;
  float _58 = saturate(select((((temp_cb12_022x * _32.x) + temp_cb12_022y) >= 1.0f), 1.0f, 0.0f) + float((bool)(bool)((sqrt((_41 * _41) + (_42 * _42)) / _18) < 0.05000000074505806f)));

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

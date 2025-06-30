#include "common.hlsl"

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
  float cb12_000x : packoffset(c000.x);
  float cb12_000y : packoffset(c000.y);
  float cb12_000z : packoffset(c000.z);
  float cb12_021x : packoffset(c021.x);
  float cb12_021y : packoffset(c021.y);
  float cb12_022x : packoffset(c022.x);
  float cb12_022y : packoffset(c022.y);
  float cb12_211x : packoffset(c211.x);
  float cb12_211y : packoffset(c211.y);
  float cb12_211z : packoffset(c211.z);
  float cb12_211w : packoffset(c211.w);
  float cb12_212x : packoffset(c212.x);
  float cb12_212y : packoffset(c212.y);
  float cb12_212z : packoffset(c212.z);
  float cb12_212w : packoffset(c212.w);
  float cb12_213x : packoffset(c213.x);
  float cb12_213y : packoffset(c213.y);
  float cb12_213z : packoffset(c213.z);
  float cb12_213w : packoffset(c213.w);
  float cb12_214x : packoffset(c214.x);
  float cb12_214y : packoffset(c214.y);
  float cb12_214z : packoffset(c214.z);
  float cb12_214w : packoffset(c214.w);
  float cb12_271x : packoffset(c271.x);
};

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  int _8 = int(SV_Position.x);
  int _9 = int(SV_Position.y);
  float _10 = float(_8);
  float _11 = float(_9);
  float4 _18 = t1.Load(int3((uint)(uint(cb12_271x * _10)), (uint)(uint(cb12_271x * _11)), 0));
  float4 _20 = t0.Load(int3(_8, _9, 0));
  float _114;
  float _123;
  float _124;
  float _125;
  float _126;
  [branch]
  if (!(_18.x >= SV_Position.z)) {
    float _38 = min(max((1.0f / ((((cb12_022x * _18.x) + cb12_022y) * cb12_021x) + cb12_021y)), -3.4028234663852886e+38f), 3.4028234663852886e+38f);
    float _48 = saturate(sqrt(saturate((_38 - CustomPixelConsts_000.x) * CustomPixelConsts_000.w)) * CustomPixelConsts_000.z);
    if (!(!(_38 >= (min(max((1.0f / (cb12_021y + cb12_021x)), -3.4028234663852886e+38f), 3.4028234663852886e+38f) * 0.9990000128746033f)))) {
      float _91 = mad(cb12_213w, _18.x, mad(cb12_212w, _11, (cb12_211w * _10))) + cb12_214w;
      float _99 = ((mad(cb12_213x, _18.x, mad(cb12_212x, _11, (cb12_211x * _10))) + cb12_214x) / _91) - cb12_000x;
      float _100 = ((mad(cb12_213y, _18.x, mad(cb12_212y, _11, (cb12_211y * _10))) + cb12_214y) / _91) - cb12_000y;
      float _101 = ((mad(cb12_213z, _18.x, mad(cb12_212z, _11, (cb12_211z * _10))) + cb12_214z) / _91) - cb12_000z;
      _114 = (saturate(1.0f - (((_101 * rsqrt(dot(float3(_99, _100, _101), float3(_99, _100, _101)))) - CustomPixelConsts_032.x) * CustomPixelConsts_032.y)) * _48);
    } else {
      _114 = _48;
    }
    float _116 = ceil(_114 * 3.0f);
    float _118 = _116 * 8.0f;
    _123 = (_118 * _20.x);
    _124 = (_118 * _20.y);
    _125 = (_118 * _20.z);
    _126 = (_116 * 0.3333333432674408f);
  } else {
    _123 = 0.0f;
    _124 = 0.0f;
    _125 = 0.0f;
    _126 = 0.0f;
  }
  SV_Target.x = _123;
  SV_Target.y = _124;
  SV_Target.z = _125;
  SV_Target.w = _126;

  //SV_Target.rgb = CustomBloomTonemap(SV_Target.rgb);
  return SV_Target;
}

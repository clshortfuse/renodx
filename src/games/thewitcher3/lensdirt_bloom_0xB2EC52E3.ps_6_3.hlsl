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

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _61 = t0.SampleLevel(s0, float2(min(max(((float(int(CustomPixelConsts_064.x)) + (CustomPixelConsts_016.x * ((float((uint)((int)(int(SV_Position.x)) - (int)(int(CustomPixelConsts_064.z)))) + 0.5f) / CustomPixelConsts_048.x))) / CustomPixelConsts_000.x), ((CustomPixelConsts_080.x + 0.5f) / CustomPixelConsts_000.x)), ((CustomPixelConsts_080.z + 0.5f) / CustomPixelConsts_000.x)), min(max(((float(int(CustomPixelConsts_064.y)) + (CustomPixelConsts_016.y * ((float((uint)((int)(int(SV_Position.y)) - (int)(int(CustomPixelConsts_064.w)))) + 0.5f) / CustomPixelConsts_048.y))) / CustomPixelConsts_000.y), ((CustomPixelConsts_080.y + 0.5f) / CustomPixelConsts_000.y)), ((CustomPixelConsts_080.w + 0.5f) / CustomPixelConsts_000.y))), 0.0f);
  float4 _78 = t1.Sample(s1, float2((CustomPixelConsts_128.x * SV_Position.x), (CustomPixelConsts_128.y * SV_Position.y)));

  //_61.rgb = CustomBloomTonemap(_61.rgb, 0.375f);

  _78 *= CUSTOM_LENS_DIRT;
  //_61 *= CUSTOM_BLOOM;
  
  SV_Target.x = (((_78.x * CustomPixelConsts_112.x) + CustomPixelConsts_096.x) * _61.x);
  SV_Target.y = (((_78.y * CustomPixelConsts_112.y) + CustomPixelConsts_096.y) * _61.y);
  SV_Target.z = (((_78.z * CustomPixelConsts_112.z) + CustomPixelConsts_096.z) * _61.z);
  SV_Target.w = 0.0f;
  return SV_Target;
}

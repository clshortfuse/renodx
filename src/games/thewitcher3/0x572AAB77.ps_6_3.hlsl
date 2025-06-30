#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

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

SamplerState s1 : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_2 : TEXCOORD2
) : SV_Target {
  float4 SV_Target;
  float _16 = (TEXCOORD.x - CustomPixelConsts_272.x) / CustomPixelConsts_272.x;
  float _17 = (TEXCOORD.y - CustomPixelConsts_272.y) / CustomPixelConsts_272.y;
  float _21 = sqrt((_17 * _17) + (_16 * _16));
  float _24 = saturate((_21 - CustomPixelConsts_256.y) * CustomPixelConsts_256.z);
  float4 _25 = t0.SampleLevel(s1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  float _55;
  float _56;
  [branch]
  if (_24 > 0.0f) {
    float _39 = ((_24 * _24) * CustomPixelConsts_256.x) * min(max((1.0f / _21), -3.4028234663852886e+38f), 3.4028234663852886e+38f);
    float _41 = (_16 * CustomPixelConsts_272.z) * _39;
    float _43 = (_17 * CustomPixelConsts_272.w) * _39;
    float4 _48 = t0.SampleLevel(s1, float2((TEXCOORD.x - (_41 * 2.0f)), (TEXCOORD.y - (_43 * 2.0f))), 0.0f);
    float4 _52 = t0.SampleLevel(s1, float2((TEXCOORD.x - _41), (TEXCOORD.y - _43)), 0.0f);

    _55 = _48.x;
    _56 = _52.y;
  } else {
    _55 = _25.x;
    _56 = _25.y;
  }
  float _90 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_55)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _91 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_56)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _92 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_25.z)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _93 = dot(float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f), float3(_90, _91, _92));
  float _99 = saturate((_93 - CustomPixelConsts_160.x) * CustomPixelConsts_160.y);
  float _104 = saturate((_93 - CustomPixelConsts_160.z) * CustomPixelConsts_160.w);
  float _114 = exp2(log2(max(0.0f, _90)) * 2.200000047683716f);
  float _115 = exp2(log2(max(0.0f, _91)) * 2.200000047683716f);
  float _116 = exp2(log2(max(0.0f, _92)) * 2.200000047683716f);
  float _117 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_114, _115, _116));
  float _136 = ((CustomPixelConsts_176.x - CustomPixelConsts_192.x) * _99) + CustomPixelConsts_192.x;
  float _137 = ((CustomPixelConsts_176.y - CustomPixelConsts_192.y) * _99) + CustomPixelConsts_192.y;
  float _138 = ((CustomPixelConsts_176.z - CustomPixelConsts_192.z) * _99) + CustomPixelConsts_192.z;
  float _139 = ((CustomPixelConsts_176.w - CustomPixelConsts_192.w) * _99) + CustomPixelConsts_192.w;
  float _156 = ((CustomPixelConsts_208.w - _139) * _104) + _139;
  float _185 = CustomPixelConsts_144.x * exp2(log2(max(0.0f, (((_156 * (_114 - _117)) + _117) * (lerp(_136, CustomPixelConsts_208.x, _104))))) * 0.4545454680919647f);
  float _186 = CustomPixelConsts_144.y * exp2(log2(max(0.0f, (((_156 * (_115 - _117)) + _117) * (lerp(_137, CustomPixelConsts_208.y, _104))))) * 0.4545454680919647f);
  float _187 = CustomPixelConsts_144.z * exp2(log2(max(0.0f, (((_156 * (_116 - _117)) + _117) * (lerp(_138, CustomPixelConsts_208.z, _104))))) * 0.4545454680919647f);
  float _188 = TEXCOORD_2.x + -0.5f;
  float _189 = TEXCOORD_2.y + -0.5f;
  float _196 = saturate((sqrt((_189 * _189) + (_188 * _188)) * 2.4390244483947754f) + -0.6707317233085632f);
  float _197 = _196 * _196;
  float _221 = saturate((CustomPixelConsts_096.w * min(dot(float4(-0.10000000149011612f, -0.10499999672174454f, 1.1200000047683716f, 0.09000000357627869f), float4((_197 * _197), (_197 * _196), _197, _196)), 0.9399999976158142f)) * saturate(1.0f - dot(float3((pow(_185, 2.200000047683716f)), (pow(_186, 2.200000047683716f)), (pow(_187, 2.200000047683716f))), float3(CustomPixelConsts_096.x, CustomPixelConsts_096.y, CustomPixelConsts_096.z))));
  float _238 = CustomPixelConsts_240.y - CustomPixelConsts_240.x;
  SV_Target.x = (((lerp(_185, CustomPixelConsts_112.x, _221)) * _238) + CustomPixelConsts_240.x);
  SV_Target.y = (((lerp(_186, CustomPixelConsts_112.y, _221)) * _238) + CustomPixelConsts_240.x);
  SV_Target.z = (((lerp(_187, CustomPixelConsts_112.z, _221)) * _238) + CustomPixelConsts_240.x);
  SV_Target.w = 1.0f;
  return SV_Target;
}

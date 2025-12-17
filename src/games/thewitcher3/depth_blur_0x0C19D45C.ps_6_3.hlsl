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
  float cb12_000x : packoffset(c000.x);
  float cb12_000y : packoffset(c000.y);
  float cb12_000z : packoffset(c000.z);
  float cb12_021x : packoffset(c021.x);
  float cb12_021y : packoffset(c021.y);
  float cb12_022x : packoffset(c022.x);
  float cb12_022y : packoffset(c022.y);
  float cb12_073z : packoffset(c073.z);
  float cb12_073w : packoffset(c073.w);
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

SamplerState s0 : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;

  //float alpha = 1.f;

  float _11 = float(int(SV_Position.x));
  float _12 = float(int(SV_Position.y));
  float4 _19 = t1.Load(int3((uint)(uint(cb12_271x * _11)), (uint)(uint(cb12_271x * _12)), 0));

  //_19.w = 1.f;

  float _112;
  [branch]
  if (!(!(_19.x >= SV_Position.z))) {
    if (true) discard;
  }
  float _36 = min(max((1.0f / ((((cb12_022x * _19.x) + cb12_022y) * cb12_021x) + cb12_021y)), -3.4028234663852886e+38f), 3.4028234663852886e+38f);
  float _46 = saturate(sqrt(saturate((_36 - CustomPixelConsts_000.x) * CustomPixelConsts_000.w)) * CustomPixelConsts_000.z);
  if (!(!(_36 >= (min(max((1.0f / (cb12_021y + cb12_021x)), -3.4028234663852886e+38f), 3.4028234663852886e+38f) * 0.9990000128746033f)))) {
    float _89 = mad(cb12_213w, _19.x, mad(cb12_212w, _12, (cb12_211w * _11))) + cb12_214w;
    float _97 = ((mad(cb12_213x, _19.x, mad(cb12_212x, _12, (cb12_211x * _11))) + cb12_214x) / _89) - cb12_000x;
    float _98 = ((mad(cb12_213y, _19.x, mad(cb12_212y, _12, (cb12_211y * _11))) + cb12_214y) / _89) - cb12_000y;
    float _99 = ((mad(cb12_213z, _19.x, mad(cb12_212z, _12, (cb12_211z * _11))) + cb12_214z) / _89) - cb12_000z;
    _112 = (saturate(1.0f - (((_99 * rsqrt(dot(float3(_97, _98, _99), float3(_97, _98, _99)))) - CustomPixelConsts_032.x) * CustomPixelConsts_032.y)) * _46);

    //_112 *= 5;
  } else {
    _112 = _46;

    _112 *= CUSTOM_DEPTH_BLUR;
  }

  //_112 *= 5;

  [branch]
  if (!(!(_112 <= 0.009999999776482582f))) {
    if (true) discard;
  }
  float _122 = (cb12_073z * SV_Position.x) * cb12_271x;
  float _124 = (cb12_073w * SV_Position.y) * cb12_271x;
  float _126 = (cb12_073z * _112) * cb12_271x;
  float _128 = (cb12_073w * _112) * cb12_271x;
  float4 _129 = t0.SampleLevel(s0, float2(_122, _124), 0.0f);

  //_129.w = alpha;

  float _134 = _126 * 0.5f;
  float _135 = _128 * 1.5f;
  float4 _138 = t0.SampleLevel(s0, float2((_122 - _134), (_124 - _135)), 0.0f);

  //_138.w = alpha;

  float _143 = _126 * 1.5f;
  float _144 = _128 * 0.5f;
  float4 _147 = t0.SampleLevel(s0, float2((_143 + _122), (_124 - _144)), 0.0f);
  float4 _154 = t0.SampleLevel(s0, float2((_134 + _122), (_135 + _124)), 0.0f);
  float4 _161 = t0.SampleLevel(s0, float2((_122 - _143), (_144 + _124)), 0.0f);

  //_147.w = alpha;
  //_154.w = alpha;
  //_161.w = alpha;

  float _166 = _126 * 2.0f;
  float4 _171 = t0.SampleLevel(s0, float2((_122 - _166), (cb12_271x * (cb12_073w * (SV_Position.y - _112)))), 0.0f);

  //_171.w = alpha;

  float _176 = _128 * 2.0f;
  float4 _181 = t0.SampleLevel(s0, float2((cb12_271x * (cb12_073z * (_112 + SV_Position.x))), (_124 - _176)), 0.0f);
  float4 _190 = t0.SampleLevel(s0, float2((_166 + _122), (cb12_271x * (cb12_073w * (_112 + SV_Position.y)))), 0.0f);
  float4 _199 = t0.SampleLevel(s0, float2((cb12_271x * (cb12_073z * (SV_Position.x - _112))), (_176 + _124)), 0.0f);

  //_181.w = alpha;
  //_190.w = alpha;
  //_199.w = alpha;

  float _239 = ((((_171.w + _129.w) + _181.w) + _190.w) + _199.w) + ((((_147.w + _138.w) + _154.w) + _161.w) * 4.0f);
  float _240 = max(0.0010000000474974513f, _239);
  SV_Target.x = (((((((_171.x + _129.x) + _181.x) + _190.x) + _199.x) + ((((_147.x + _138.x) + _154.x) + _161.x) * 4.0f)) / _240) * 0.0416666679084301f);
  SV_Target.y = (((((((_171.y + _129.y) + _181.y) + _190.y) + _199.y) + ((((_147.y + _138.y) + _154.y) + _161.y) * 4.0f)) / _240) * 0.0416666679084301f);
  SV_Target.z = (((((((_171.z + _129.z) + _181.z) + _190.z) + _199.z) + ((((_147.z + _138.z) + _154.z) + _161.z) * 4.0f)) / _240) * 0.0416666679084301f);
  SV_Target.w = saturate(_239 * 25.0f);

  //SV_Target.rgb *= 5.f;

  //SV_Target.rgb = renodx::color::correct::Luminance(SV_Target.rgb, _129.rgb);

  return SV_Target;
}

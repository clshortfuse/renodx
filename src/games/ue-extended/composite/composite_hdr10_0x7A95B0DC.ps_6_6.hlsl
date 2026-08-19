#include "./composite.hlsli"

// Found in MIGHTREYA demo (UE 5.7.3.0)

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_001z : packoffset(c001.z);
  float cb0_001w : packoffset(c001.w);
  uint cb0_002x : packoffset(c002.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
  noperspective float4 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _11 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float _58;
  float _59;
  float _60;
  float _138;
  float _139;
  float _140;
  if ((uint)(cb0_002x) == 0) {
    _58 = (pow(_11.x, 2.4000000953674316f));
    _59 = (pow(_11.y, 2.4000000953674316f));
    _60 = (pow(_11.z, 2.4000000953674316f));
  } else {
    _58 = select((_11.x > 0.040449999272823334f), exp2(log2((abs(_11.x) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_11.x * 0.07739938050508499f));
    _59 = select((_11.y > 0.040449999272823334f), exp2(log2((abs(_11.y) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_11.y * 0.07739938050508499f));
    _60 = select((_11.z > 0.040449999272823334f), exp2(log2((abs(_11.z) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_11.z * 0.07739938050508499f));
  }
  float4 _77 = t1.Sample(s1, float2(TEXCOORD.x, TEXCOORD.y));

  if (HandleUICompositing(_11, _77, SV_Target, TEXCOORD.xy, t1, s1)) {
    return SV_Target;
  }

  float _87 = (pow(_77.x, 0.012683313339948654f));
  float _88 = (pow(_77.y, 0.012683313339948654f));
  float _89 = (pow(_77.z, 0.012683313339948654f));
  float _114 = exp2(log2(max(0.0f, (_87 + -0.8359375f)) / (18.8515625f - (_87 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _115 = exp2(log2(max(0.0f, (_88 + -0.8359375f)) / (18.8515625f - (_88 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _116 = exp2(log2(max(0.0f, (_89 + -0.8359375f)) / (18.8515625f - (_89 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  if ((bool)(_11.w > 0.0f) && (bool)(_11.w < 1.0f)) {
    float _123 = max(_114, 0.0f);
    float _124 = max(_115, 0.0f);
    float _125 = max(_116, 0.0f);
    float _133 = ((((1.0f / ((dot(float3(_123, _124, _125), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / cb0_001z) + 1.0f)) * cb0_001z) + -1.0f) * _11.w) + 1.0f;
    _138 = (_133 * _123);
    _139 = (_133 * _124);
    _140 = (_133 * _125);
  } else {
    _138 = _114;
    _139 = _115;
    _140 = _116;
  }
  float _141 = 1.0f - _11.w;
  float _160 = exp2(log2(((_138 * _141) + ((cb0_001w * mad(0.043313056230545044f, _60, mad(0.3292830288410187f, _59, (_58 * 0.6274039149284363f)))) * cb0_001z)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _161 = exp2(log2(((_139 * _141) + ((cb0_001w * mad(0.011362319812178612f, _60, mad(0.919540286064148f, _59, (_58 * 0.06909731030464172f)))) * cb0_001z)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _162 = exp2(log2(((_140 * _141) + ((cb0_001w * mad(0.8955953121185303f, _60, mad(0.08801331371068954f, _59, (_58 * 0.016391439363360405f)))) * cb0_001z)) * 9.999999747378752e-05f) * 0.1593017578125f);
  SV_Target.x = exp2(log2((1.0f / ((_160 * 18.6875f) + 1.0f)) * ((_160 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.y = exp2(log2((1.0f / ((_161 * 18.6875f) + 1.0f)) * ((_161 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.z = exp2(log2((1.0f / ((_162 * 18.6875f) + 1.0f)) * ((_162 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.w = _11.w;
  return SV_Target;
}

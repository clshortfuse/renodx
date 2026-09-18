#include "./composite.hlsli"

// Found in Stalker 2 (New update)

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_001z : packoffset(c001.z);
  float cb0_001w : packoffset(c001.w);
  float cb0_003x : packoffset(c003.x);
  float cb0_004x : packoffset(c004.x);
  float cb0_004y : packoffset(c004.y);
  float cb0_004z : packoffset(c004.z);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float4 _11 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float _16 = max(6.103519990574569e-05f, _11.x);
  float _17 = max(6.103519990574569e-05f, _11.y);
  float _18 = max(6.103519990574569e-05f, _11.z);
  float _40 = select((_16 > 0.040449999272823334f), exp2(log2((_16 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_16 * 0.07739938050508499f));
  float _41 = select((_17 > 0.040449999272823334f), exp2(log2((_17 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_17 * 0.07739938050508499f));
  float _42 = select((_18 > 0.040449999272823334f), exp2(log2((_18 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_18 * 0.07739938050508499f));
  float _50 = saturate(dot(float3(_40, _41, _42), float3(cb0_004x, cb0_004y, cb0_004z)));
  float _60 = saturate(lerp(_50, _40, cb0_003x));
  float _61 = saturate(lerp(_50, _41, cb0_003x));
  float _62 = saturate(lerp(_50, _42, cb0_003x));
  float4 _79 = t1.Sample(s1, float2(TEXCOORD.x, TEXCOORD.y));

  if (HandleUICompositing(_11, _79, SV_Target, TEXCOORD.xy, t1, s1)) {
    return SV_Target;
  }

  float _89 = (pow(_79.x, 0.012683313339948654f));
  float _90 = (pow(_79.y, 0.012683313339948654f));
  float _91 = (pow(_79.z, 0.012683313339948654f));
  float _116 = exp2(log2(max(0.0f, (_89 + -0.8359375f)) / (18.8515625f - (_89 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _117 = exp2(log2(max(0.0f, (_90 + -0.8359375f)) / (18.8515625f - (_90 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _118 = exp2(log2(max(0.0f, (_91 + -0.8359375f)) / (18.8515625f - (_91 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _139;
  float _140;
  float _141;
  if ((bool)(_11.w > 0.0f) && (bool)(_11.w < 1.0f)) {
    float _124 = max(_116, 0.0f);
    float _125 = max(_117, 0.0f);
    float _126 = max(_118, 0.0f);
    float _134 = ((((1.0f / ((dot(float3(_124, _125, _126), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / cb0_001z) + 1.0f)) * cb0_001z) + -1.0f) * _11.w) + 1.0f;
    _139 = (_134 * _124);
    _140 = (_134 * _125);
    _141 = (_134 * _126);
  } else {
    _139 = _116;
    _140 = _117;
    _141 = _118;
  }
  float _142 = 1.0f - _11.w;
  float _161 = exp2(log2(((_139 * _142) + ((cb0_001w * mad(0.043313056230545044f, _62, mad(0.3292830288410187f, _61, (_60 * 0.6274039149284363f)))) * cb0_001z)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _162 = exp2(log2(((_140 * _142) + ((cb0_001w * mad(0.011362319812178612f, _62, mad(0.919540286064148f, _61, (_60 * 0.06909731030464172f)))) * cb0_001z)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _163 = exp2(log2(((_141 * _142) + ((cb0_001w * mad(0.8955953121185303f, _62, mad(0.08801331371068954f, _61, (_60 * 0.016391439363360405f)))) * cb0_001z)) * 9.999999747378752e-05f) * 0.1593017578125f);
  SV_Target.x = exp2(log2((1.0f / ((_161 * 18.6875f) + 1.0f)) * ((_161 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.y = exp2(log2((1.0f / ((_162 * 18.6875f) + 1.0f)) * ((_162 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.z = exp2(log2((1.0f / ((_163 * 18.6875f) + 1.0f)) * ((_163 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.w = _11.w;
  return SV_Target;
}

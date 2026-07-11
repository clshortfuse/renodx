#include "./composite.hlsli"

// Found in Hellblade 2

Texture2D<float4> UITexture : register(t0);

Texture2D<float4> SceneTexture : register(t1);

cbuffer $Globals : register(b0) {
  float UILevel : packoffset(c000.x);
  float UILuminance : packoffset(c000.y);
};

SamplerState UISampler : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float4 _10 = UITexture.Sample(UISampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _21 = select((_10.x > 0.0f), max(6.103519990574569e-05f, _10.x), 0.0f);
  float _22 = select((_10.y > 0.0f), max(6.103519990574569e-05f, _10.y), 0.0f);
  float _23 = select((_10.z > 0.0f), max(6.103519990574569e-05f, _10.z), 0.0f);
  float _45 = select((_21 > 0.040449999272823334f), exp2(log2((_21 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_21 * 0.07739938050508499f));
  float _46 = select((_22 > 0.040449999272823334f), exp2(log2((_22 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_22 * 0.07739938050508499f));
  float _47 = select((_23 > 0.040449999272823334f), exp2(log2((_23 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_23 * 0.07739938050508499f));
  float4 _63 = SceneTexture.Sample(UISampler, float2(TEXCOORD.x, TEXCOORD.y));

  if (HandleIntermediateCompositing(_10, _63, SV_Target)) {
    return SV_Target;
  }

  float _73 = (pow(_63.x, 0.012683313339948654f));
  float _74 = (pow(_63.y, 0.012683313339948654f));
  float _75 = (pow(_63.z, 0.012683313339948654f));
  float _100 = exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _101 = exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _102 = exp2(log2(max(0.0f, (_75 + -0.8359375f)) / (18.8515625f - (_75 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _123;
  float _124;
  float _125;
  if ((bool)(_10.w > 0.0f) && (bool)(_10.w < 1.0f)) {
    float _108 = max(_100, 0.0f);
    float _109 = max(_101, 0.0f);
    float _110 = max(_102, 0.0f);
    float _118 = ((((1.0f / ((dot(float3(_108, _109, _110), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / UILevel) + 1.0f)) * UILevel) + -1.0f) * _10.w) + 1.0f;
    _123 = (_118 * _108);
    _124 = (_118 * _109);
    _125 = (_118 * _110);
  } else {
    _123 = _100;
    _124 = _101;
    _125 = _102;
  }
  float _126 = 1.0f - _10.w;
  SV_Target.x = (((_123 * _126) + ((UILuminance * mad(0.043313056230545044f, _47, mad(0.3292830288410187f, _46, (_45 * 0.6274039149284363f)))) * UILevel)) * 0.012500000186264515f);
  SV_Target.y = (((_124 * _126) + ((UILuminance * mad(0.011362319812178612f, _47, mad(0.919540286064148f, _46, (_45 * 0.06909731030464172f)))) * UILevel)) * 0.012500000186264515f);
  SV_Target.z = (((_125 * _126) + ((UILuminance * mad(0.8955953121185303f, _47, mad(0.08801331371068954f, _46, (_45 * 0.016391439363360405f)))) * UILevel)) * 0.012500000186264515f);
  SV_Target.w = 1.0f;
  return SV_Target;
}

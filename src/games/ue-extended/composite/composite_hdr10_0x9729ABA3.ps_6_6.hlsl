#include "./composite.hlsli"

// Found in Hellblade 2

Texture2D<float4> UITexture : register(t0);

Texture2D<float4> SceneTexture : register(t1);

cbuffer $Globals : register(b0) {
  float UILevel : packoffset(c000.x);
  float UILuminance : packoffset(c000.y);
};

SamplerState UISampler : register(s0);

SamplerState SceneSampler : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float4 _11 = UITexture.Sample(UISampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _22 = select((_11.x > 0.0f), max(6.103519990574569e-05f, _11.x), 0.0f);
  float _23 = select((_11.y > 0.0f), max(6.103519990574569e-05f, _11.y), 0.0f);
  float _24 = select((_11.z > 0.0f), max(6.103519990574569e-05f, _11.z), 0.0f);
  float _46 = select((_22 > 0.040449999272823334f), exp2(log2((_22 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_22 * 0.07739938050508499f));
  float _47 = select((_23 > 0.040449999272823334f), exp2(log2((_23 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_23 * 0.07739938050508499f));
  float _48 = select((_24 > 0.040449999272823334f), exp2(log2((_24 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_24 * 0.07739938050508499f));
  float4 _65 = SceneTexture.Sample(SceneSampler, float2(TEXCOORD.x, TEXCOORD.y));

  if (HandleUICompositing(_11, _65, SV_Target, TEXCOORD.xy, SceneTexture, SceneSampler)) {
    return SV_Target;
  }

  float _75 = (pow(_65.x, 0.012683313339948654f));
  float _76 = (pow(_65.y, 0.012683313339948654f));
  float _77 = (pow(_65.z, 0.012683313339948654f));
  float _102 = exp2(log2(max(0.0f, (_75 + -0.8359375f)) / (18.8515625f - (_75 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _103 = exp2(log2(max(0.0f, (_76 + -0.8359375f)) / (18.8515625f - (_76 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _104 = exp2(log2(max(0.0f, (_77 + -0.8359375f)) / (18.8515625f - (_77 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _125;
  float _126;
  float _127;
  if ((bool)(_11.w > 0.0f) && (bool)(_11.w < 1.0f)) {
    float _110 = max(_102, 0.0f);
    float _111 = max(_103, 0.0f);
    float _112 = max(_104, 0.0f);
    float _120 = ((((1.0f / ((dot(float3(_110, _111, _112), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / UILevel) + 1.0f)) * UILevel) + -1.0f) * _11.w) + 1.0f;
    _125 = (_120 * _110);
    _126 = (_120 * _111);
    _127 = (_120 * _112);
  } else {
    _125 = _102;
    _126 = _103;
    _127 = _104;
  }
  float _128 = 1.0f - _11.w;
  float _147 = exp2(log2(((_125 * _128) + ((UILuminance * mad(0.043313056230545044f, _48, mad(0.3292830288410187f, _47, (_46 * 0.6274039149284363f)))) * UILevel)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _148 = exp2(log2(((_126 * _128) + ((UILuminance * mad(0.011362319812178612f, _48, mad(0.919540286064148f, _47, (_46 * 0.06909731030464172f)))) * UILevel)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _149 = exp2(log2(((_127 * _128) + ((UILuminance * mad(0.8955953121185303f, _48, mad(0.08801331371068954f, _47, (_46 * 0.016391439363360405f)))) * UILevel)) * 9.999999747378752e-05f) * 0.1593017578125f);
  SV_Target.x = exp2(log2((1.0f / ((_147 * 18.6875f) + 1.0f)) * ((_147 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.y = exp2(log2((1.0f / ((_148 * 18.6875f) + 1.0f)) * ((_148 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.z = exp2(log2((1.0f / ((_149 * 18.6875f) + 1.0f)) * ((_149 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.w = _11.w;
  return SV_Target;
}

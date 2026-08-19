#include "./composite.hlsli"

// Split Fiction native HDR, UE 5.4.4

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
  float4 _39 = UITexture.Sample(UISampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _41 = _39.x;
  float _42 = _39.y;
  float _43 = _39.z;
  float _44 = _39.w;
  float _73 = (_41 > 0.040449999272823333740234375f) ? exp2(log2((_41 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f) * 2.400000095367431640625f) : (_41 * 0.077399380505084991455078125f);
  float _74 = (_42 > 0.040449999272823333740234375f) ? exp2(log2((_42 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f) * 2.400000095367431640625f) : (_42 * 0.077399380505084991455078125f);
  float _75 = (_43 > 0.040449999272823333740234375f) ? exp2(log2((_43 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f) * 2.400000095367431640625f) : (_43 * 0.077399380505084991455078125f);
  float4 _104 = SceneTexture.Sample(SceneSampler, float2(TEXCOORD.x, TEXCOORD.y));

  if (HandleUICompositing(_39, _104, SV_Target, TEXCOORD.xy, SceneTexture, SceneSampler)) {
    return SV_Target;
  }

  float _116 = exp2(log2(_104.x) * 0.0126833133399486541748046875f);
  float _117 = exp2(log2(_104.y) * 0.0126833133399486541748046875f);
  float _118 = exp2(log2(_104.z) * 0.0126833133399486541748046875f);
  float _147 = exp2(log2(max(0.0f, _116 + (-0.8359375f)) / (18.8515625f - (_116 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f;
  float _149 = exp2(log2(max(0.0f, _117 + (-0.8359375f)) / (18.8515625f - (_117 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f;
  float _150 = exp2(log2(max(0.0f, _118 + (-0.8359375f)) / (18.8515625f - (_118 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f;
  float _177;
  float _178;
  float _179;
  if ((_44 > 0.0f) && (_44 < 1.0f)) {
    float _156 = max(_147, 0.0f);
    float _157 = max(_149, 0.0f);
    float _158 = max(_150, 0.0f);
    float _173 = ((((1.0f / ((dot(float3(_156, _157, _158), float3(0.2626999914646148681640625f, 0.677999973297119140625f, 0.0593000017106533050537109375f)) / UILevel) + 1.0f)) * UILevel) + (-1.0f)) * _44) + 1.0f;
    _177 = _173 * _156;
    _178 = _173 * _157;
    _179 = _173 * _158;
  } else {
    _177 = _147;
    _178 = _149;
    _179 = _150;
  }
  float _180 = 1.0f - _44;
  float _201 = exp2(log2(((_177 * _180) + ((UILuminance * mad(0.0433130562305450439453125f, _75, mad(0.3292830288410186767578125f, _74, _73 * 0.627403914928436279296875f))) * UILevel)) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
  float _202 = exp2(log2(((_178 * _180) + ((UILuminance * mad(0.01136231981217861175537109375f, _75, mad(0.91954028606414794921875f, _74, _73 * 0.0690973103046417236328125f))) * UILevel)) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
  float _203 = exp2(log2(((_179 * _180) + ((UILuminance * mad(0.8955953121185302734375f, _75, mad(0.088013313710689544677734375f, _74, _73 * 0.01639143936336040496826171875f))) * UILevel)) * 9.9999997473787516355514526367188e-05f) * 0.1593017578125f);
  SV_Target.x = exp2(log2((1.0f / ((_201 * 18.6875f) + 1.0f)) * ((_201 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.y = exp2(log2((1.0f / ((_202 * 18.6875f) + 1.0f)) * ((_202 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.z = exp2(log2((1.0f / ((_203 * 18.6875f) + 1.0f)) * ((_203 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.w = 1.0f;
  return SV_Target;
}

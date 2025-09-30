#include "../composite.hlsl"

Texture2D<float4> UITexture : register(t0);

Texture2D<float4> SceneTexture : register(t1);

cbuffer $Globals : register(b0) {
  float UILevel : packoffset(c000.x);
  float UILuminance : packoffset(c000.y);
};

SamplerState UISampler : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _10 = UITexture.Sample(UISampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _15 = max(6.103519990574569e-05f, _10.x);
  float _16 = max(6.103519990574569e-05f, _10.y);
  float _17 = max(6.103519990574569e-05f, _10.z);
  float _39 = select((_15 > 0.040449999272823334f), exp2(log2((_15 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_15 * 0.07739938050508499f));
  float _40 = select((_16 > 0.040449999272823334f), exp2(log2((_16 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_16 * 0.07739938050508499f));
  float _41 = select((_17 > 0.040449999272823334f), exp2(log2((_17 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_17 * 0.07739938050508499f));
  float4 _57 = SceneTexture.Sample(UISampler, float2(TEXCOORD.x, TEXCOORD.y));
  if (HandleUICompositing(_10, _57, SV_Target)) {
    SV_Target.rgb = renodx::color::pq::DecodeSafe(SV_Target.rgb, RENODX_DIFFUSE_WHITE_NITS);
    return SV_Target;
  }
  float _67 = (pow(_57.x, 0.012683313339948654f));
  float _68 = (pow(_57.y, 0.012683313339948654f));
  float _69 = (pow(_57.z, 0.012683313339948654f));
  float _94 = exp2(log2(max(0.0f, (_67 + -0.8359375f)) / (18.8515625f - (_67 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _95 = exp2(log2(max(0.0f, (_68 + -0.8359375f)) / (18.8515625f - (_68 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _96 = exp2(log2(max(0.0f, (_69 + -0.8359375f)) / (18.8515625f - (_69 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _117;
  float _118;
  float _119;
  if ((bool)(_10.w > 0.0f) && (bool)(_10.w < 1.0f)) {
    float _102 = max(_94, 0.0f);
    float _103 = max(_95, 0.0f);
    float _104 = max(_96, 0.0f);
    float _112 = ((((1.0f / ((dot(float3(_102, _103, _104), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / UILevel) + 1.0f)) * UILevel) + -1.0f) * _10.w) + 1.0f;
    _117 = (_112 * _102);
    _118 = (_112 * _103);
    _119 = (_112 * _104);
  } else {
    _117 = _94;
    _118 = _95;
    _119 = _96;
  }
  float _120 = 1.0f - _10.w;
  SV_Target.x = (((_117 * _120) + ((UILuminance * mad(0.043313056230545044f, _41, mad(0.3292830288410187f, _40, (_39 * 0.6274039149284363f)))) * UILevel)) * 0.012500000186264515f);
  SV_Target.y = (((_118 * _120) + ((UILuminance * mad(0.011362319812178612f, _41, mad(0.919540286064148f, _40, (_39 * 0.06909731030464172f)))) * UILevel)) * 0.012500000186264515f);
  SV_Target.z = (((_119 * _120) + ((UILuminance * mad(0.8955953121185303f, _41, mad(0.08801331371068954f, _40, (_39 * 0.016391439363360405f)))) * UILevel)) * 0.012500000186264515f);
  SV_Target.w = 1.0f;
  return SV_Target;
}

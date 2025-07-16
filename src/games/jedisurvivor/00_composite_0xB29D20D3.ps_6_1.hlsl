#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t2 : register(t2);

cbuffer cb0 : register(b0) {
  float cb0_012x : packoffset(c012.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 composited_color_pq;
  float4 _10 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float4 scene_color_pq = t1.Sample(s1, float2(TEXCOORD.x, TEXCOORD.y));
  float4 ui_color_pq = t2.SampleLevel(s2, _10.rgb * 0.96875f + 0.015625f, 0.0f) * 1.05f;
  float ui_alpha = _10.a;

  if (HandleUICompositing(float4(ui_color_pq.rgb, _10.a), scene_color_pq, composited_color_pq)) {
    return composited_color_pq;
  }

  float3 scene_color_linear = renodx::color::pq::DecodeSafe(scene_color_pq.rgb, 1.f);

  [branch]
  if ((ui_alpha > 0.f) && (ui_alpha < 1.f)) {
    scene_color_linear = max(0, scene_color_linear);
    float _120 = (((cb0_012x * (1.f / ((renodx::color::luma::from::BT601(scene_color_linear) / cb0_012x) + 1.f))) - 1.f) * ui_alpha) + 1.0f;
    scene_color_linear *= _120;
  } else {
    // noop
  }

  float _128 = 1.0f - ui_alpha;
  float3 composited_color_linear = (((exp2(log2(max(0.f, (exp2(log2(ui_color_pq.rgb) * 0.012683313339948654f) + -0.8359375f)) / (18.8515625f - (exp2(log2(ui_color_pq.rgb) * 0.012683313339948654f) * 18.6875f))) * 6.277394771575928f) * 10000.0f) * cb0_012x) + (scene_color_linear * _128));
  composited_color_pq.rgb = renodx::color::pq::EncodeSafe(composited_color_linear, 1.f);
  composited_color_pq.w = 1.0f;
  return composited_color_pq;
}

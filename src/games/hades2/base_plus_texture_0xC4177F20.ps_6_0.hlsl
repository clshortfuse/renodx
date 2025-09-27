#include "./shared.h"

Texture2D<float4> Texture : register(t0, space2);

Texture2D<float4> Base : register(t3, space1);

SamplerState Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 COLOR: COLOR,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float4 _6 = Texture.Sample(Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _11 = Base.Sample(Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  _6 = max(0.f, _6);
  _11 = max(0.f, _11);

  if (shader_injection.custom_is_base_texture_render == 1.f) {
    _6 = lerp(0.5f, _6, CUSTOM_VIGNETTE);
  }
  float _27;
  float _39;
  float _51;
  float _63;
  if (_11.x < 0.5f) {
    _27 = (_6.x * (_11.x * 2.0f));
  } else {
    _27 = (1.0f - ((1.0f - _6.x) * ((1.0f - _11.x) * 2.0f)));
  }
  if (_11.y < 0.5f) {
    _39 = (_6.y * (_11.y * 2.0f));
  } else {
    _39 = (1.0f - ((1.0f - _6.y) * ((1.0f - _11.y) * 2.0f)));
  }
  if (_11.z < 0.5f) {
    _51 = (_6.z * (_11.z * 2.0f));
  } else {
    _51 = (1.0f - ((1.0f - _6.z) * ((1.0f - _11.z) * 2.0f)));
  }
  if (_11.w < 0.5f) {
    _63 = (_6.w * (_11.w * 2.0f));
  } else {
    _63 = (1.0f - ((1.0f - _6.w) * ((1.0f - _11.w) * 2.0f)));
  }
  SV_Target.x = _27;
  SV_Target.y = _39;
  SV_Target.z = _51;
  SV_Target.w = saturate(_63);
  if (RENODX_TONE_MAP_TYPE == 0.f) return saturate(SV_Target);

  if (shader_injection.custom_is_base_texture_render == 1.f) {
    float3 untonemapped = renodx::color::srgb::DecodeSafe(SV_Target.rgb);
    float3 tonemapped = renodx::draw::ToneMapPass(untonemapped);

    [branch]
    if (CUSTOM_GRAIN_STRENGTH != 0.f) {
      tonemapped = renodx::effects::ApplyFilmGrain(
          tonemapped,
          TEXCOORD,
          CUSTOM_RANDOM,
          CUSTOM_GRAIN_STRENGTH * 0.03f,
          1.f);
    }

    float3 scaled = renodx::draw::RenderIntermediatePass(tonemapped);
    SV_Target.rgb = scaled;
  }
  return SV_Target;
}

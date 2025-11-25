#include "./shared.h"

SamplerState Sampler_s : register(s0);
Texture2D<float4> Texture : register(t0);
Texture2D<float4> Base : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0: SV_POSITION0, float4 v1: COLOR0, float2 v2: TEXCOORD0, out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = Base.Sample(Sampler_s, v2.xy).xyzw;

  r0 = max(0.f, r0);

  r1.xyzw = float4(1, 1, 1, 1) + -r0.xyzw;
  r1.xyzw = r1.xyzw + r1.xyzw;
  r2.xyzw = Texture.Sample(Sampler_s, v2.xy).xyzw;

  r2 = max(0.f, r2);

  r3.xyzw = float4(1, 1, 1, 1) + -r2.xyzw;
  r1.xyzw = -r1.xyzw * r3.xyzw + float4(1, 1, 1, 1);
  r2.x = dot(r2.xx, r0.xx);
  r3.xyzw = cmp(r0.xyzw < float4(0.5, 0.5, 0.5, 0.5));
  o0.x = r3.x ? r2.x : r1.x;
  r0.x = dot(r2.yy, r0.yy);
  o0.y = r3.y ? r0.x : r1.y;
  r0.x = dot(r2.zz, r0.zz);
  r0.y = dot(r2.ww, r0.ww);
  o0.zw = r3.zw ? r0.xy : r1.zw;

  o0.w = saturate(o0.w);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0 = saturate(o0);
  } else if (true) {
    float3 untonemapped = renodx::color::srgb::DecodeSafe(o0.rgb);
    float3 tonemapped = renodx::draw::ToneMapPass(untonemapped);

    [branch]
    if (CUSTOM_GRAIN_STRENGTH != 0.f) {
      tonemapped = renodx::effects::ApplyFilmGrain(
          tonemapped,
          v2,
          CUSTOM_RANDOM,
          CUSTOM_GRAIN_STRENGTH * 0.03f,
          1.f);
    }

    float3 scaled = renodx::draw::RenderIntermediatePass(tonemapped);
    o0.rgb = scaled;
  }

  return;
}

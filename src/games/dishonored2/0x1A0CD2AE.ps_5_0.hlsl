#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 06 15:37:32 2026

cbuffer PerViewCB : register(b1) {
  float4 cb_alwaystweak : packoffset(c0);
  float4 cb_viewrandom : packoffset(c1);
  float4x4 cb_viewprojectionmatrix : packoffset(c2);
  float4x4 cb_viewmatrix : packoffset(c6);
  float4 cb_subpixeloffset : packoffset(c10);
  float4x4 cb_projectionmatrix : packoffset(c11);
  float4x4 cb_previousviewprojectionmatrix : packoffset(c15);
  float4x4 cb_previousviewmatrix : packoffset(c19);
  float4x4 cb_previousprojectionmatrix : packoffset(c23);
  float4 cb_mousecursorposition : packoffset(c27);
  float4 cb_mousebuttonsdown : packoffset(c28);
  float4 cb_jittervectors : packoffset(c29);
  float4x4 cb_inverseviewprojectionmatrix : packoffset(c30);
  float4x4 cb_inverseviewmatrix : packoffset(c34);
  float4x4 cb_inverseprojectionmatrix : packoffset(c38);
  float4 cb_globalviewinfos : packoffset(c42);
  float3 cb_wscamforwarddir : packoffset(c43);
  uint cb_alwaysone : packoffset(c43.w);
  float3 cb_wscamupdir : packoffset(c44);
  uint cb_usecompressedhdrbuffers : packoffset(c44.w);
  float3 cb_wscampos : packoffset(c45);
  float cb_time : packoffset(c45.w);
  float3 cb_wscamleftdir : packoffset(c46);
  float cb_systime : packoffset(c46.w);
  float2 cb_jitterrelativetopreviousframe : packoffset(c47);
  float2 cb_worldtime : packoffset(c47.z);
  float2 cb_shadowmapatlasslicedimensions : packoffset(c48);
  float2 cb_resolutionscale : packoffset(c48.z);
  float2 cb_parallelshadowmapslicedimensions : packoffset(c49);
  float cb_framenumber : packoffset(c49.z);
  uint cb_alwayszero : packoffset(c49.w);
}

SamplerState smp_bilinearsampler_s : register(s0);
Texture2D<float4> ro_identity_bufferin : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : INTERP0,
    float4 pixel_position : SV_POSITION0,
    out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb_resolutionscale.xy * v0.xy;
  ro_identity_bufferin.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.zw = fDest.xy;
  r1.xy = r0.xy * r0.zw + float2(-0.5, -0.5);
  r1.xy = floor(r1.xy);
  r2.xyzw = float4(0.5, 0.5, -0.5, -0.5) + r1.xyxy;
  r1.xy = float2(2.5, 2.5) + r1.xy;
  r0.xy = r0.xy * r0.zw + -r2.xy;
  r0.zw = float2(1, 1) / r0.zw;
  r1.zw = r0.xy * r0.xy;
  r3.xy = r1.zw * r0.xy;
  r3.zw = float2(2.5, 2.5) * r1.zw;
  r3.xy = r3.xy * float2(1.5, 1.5) + -r3.zw;
  r3.xy = float2(1, 1) + r3.xy;
  r3.zw = r1.zw * r0.xy + r0.xy;
  r0.xy = r1.zw * r0.xy + -r1.zw;
  r1.zw = -r3.zw * float2(0.5, 0.5) + r1.zw;
  r3.zw = float2(1, 1) + -r1.zw;
  r3.zw = r3.zw + -r3.xy;
  r3.zw = -r0.xy * float2(0.5, 0.5) + r3.zw;
  r0.xy = float2(0.5, 0.5) * r0.xy;
  r3.xy = r3.xy + r3.zw;
  r3.zw = r3.zw / r3.xy;
  r2.xy = r3.zw + r2.xy;
  r4.xyzw = r2.zyxw * r0.zwzw;
  r2.xy = r1.xy * r0.zw;
  r5.xyzw = ro_identity_bufferin.SampleLevel(smp_bilinearsampler_s, r4.zw, 0).xyzw;
  r5.rgb = renodx::draw::InvertIntermediatePass(r5.rgb);
  r5.xyzw = r5.xyzw * r3.xxxx;
  r5.xyzw = r5.xyzw * r1.wwww;
  r6.xyzw = ro_identity_bufferin.SampleLevel(smp_bilinearsampler_s, r4.xw, 0).xyzw;
  r6.rgb = renodx::draw::InvertIntermediatePass(r6.rgb);
  r6.xyzw = r6.xyzw * r1.zzzz;
  r5.xyzw = r6.xyzw * r1.wwww + r5.xyzw;
  r2.zw = r4.wy;
  r6.xyzw = ro_identity_bufferin.SampleLevel(smp_bilinearsampler_s, r2.xz, 0).xyzw;
  r6.rgb = renodx::draw::InvertIntermediatePass(r6.rgb);
  r7.xyzw = ro_identity_bufferin.SampleLevel(smp_bilinearsampler_s, r2.xw, 0).xyzw;
  r7.rgb = renodx::draw::InvertIntermediatePass(r7.rgb);
  r7.xyzw = r7.xyzw * r0.xxxx;
  r6.xyzw = r6.xyzw * r0.xxxx;
  r5.xyzw = r6.xyzw * r1.wwww + r5.xyzw;
  r6.xyzw = ro_identity_bufferin.SampleLevel(smp_bilinearsampler_s, r4.xy, 0).xyzw;
  r6.rgb = renodx::draw::InvertIntermediatePass(r6.rgb);
  r8.xyzw = ro_identity_bufferin.SampleLevel(smp_bilinearsampler_s, r4.zy, 0).xyzw;
  r8.rgb = renodx::draw::InvertIntermediatePass(r8.rgb);
  r8.xyzw = r8.xyzw * r3.xxxx;
  r6.xyzw = r6.xyzw * r1.zzzz;
  r5.xyzw = r6.xyzw * r3.yyyy + r5.xyzw;
  r5.xyzw = r8.xyzw * r3.yyyy + r5.xyzw;
  r5.xyzw = r7.xyzw * r3.yyyy + r5.xyzw;
  r4.y = r2.y;
  r2.xyzw = ro_identity_bufferin.SampleLevel(smp_bilinearsampler_s, r2.xy, 0).xyzw;
  r2.rgb = renodx::draw::InvertIntermediatePass(r2.rgb);
  r2.xyzw = r2.xyzw * r0.xxxx;
  r6.xyzw = ro_identity_bufferin.SampleLevel(smp_bilinearsampler_s, r4.xy, 0).xyzw;
  r6.rgb = renodx::draw::InvertIntermediatePass(r6.rgb);
  r4.xyzw = ro_identity_bufferin.SampleLevel(smp_bilinearsampler_s, r4.zy, 0).xyzw;
  r4.rgb = renodx::draw::InvertIntermediatePass(r4.rgb);
  r3.xyzw = r4.xyzw * r3.xxxx;
  r1.xyzw = r6.xyzw * r1.zzzz;
  r1.xyzw = r1.xyzw * r0.yyyy + r5.xyzw;
  r1.xyzw = r3.xyzw * r0.yyyy + r1.xyzw;
  o0.xyzw = r2.xyzw * r0.yyyy + r1.xyzw;

  if (DISHONORED2_SHARPENING > 0.f) {
    const float2 input_uv = cb_resolutionscale.xy * v0.xy;
    const float2 texel_size = 1.f / fDest.xy;
    const float3 sample_left = renodx::draw::InvertIntermediatePass(
        ro_identity_bufferin.SampleLevel(
            smp_bilinearsampler_s, input_uv - float2(texel_size.x, 0.f), 0.f).rgb);
    const float3 sample_right = renodx::draw::InvertIntermediatePass(
        ro_identity_bufferin.SampleLevel(
            smp_bilinearsampler_s, input_uv + float2(texel_size.x, 0.f), 0.f).rgb);
    const float3 sample_up = renodx::draw::InvertIntermediatePass(
        ro_identity_bufferin.SampleLevel(
            smp_bilinearsampler_s, input_uv - float2(0.f, texel_size.y), 0.f).rgb);
    const float3 sample_down = renodx::draw::InvertIntermediatePass(
        ro_identity_bufferin.SampleLevel(
            smp_bilinearsampler_s, input_uv + float2(0.f, texel_size.y), 0.f).rgb);
    const float3 neighborhood_average =
        (sample_left + sample_right + sample_up + sample_down) * 0.25f;
    const float3 neighborhood_min = min(
        min(sample_left, sample_right), min(sample_up, sample_down));
    const float3 neighborhood_max = max(
        max(sample_left, sample_right), max(sample_up, sample_down));
    const float3 sharpened = clamp(
        o0.rgb + (o0.rgb - neighborhood_average) * 2.f,
        min(neighborhood_min, o0.rgb),
        max(neighborhood_max, o0.rgb));
    o0.rgb = lerp(o0.rgb, sharpened, saturate(DISHONORED2_SHARPENING));
  }

  if (DISHONORED2_FILM_GRAIN > 0.f) {
    const float frame_phase = (float)(cb_framenumber % 1024u);
    const float grain = frac(sin(
        dot(floor(pixel_position.xy), float2(12.9898f, 78.233f))
        + frame_phase * 0.754877666f) * 43758.5453f) - 0.5f;
    o0.rgb = max(
        0.f,
        o0.rgb * (1.f + grain * 0.06f * saturate(DISHONORED2_FILM_GRAIN)));
  }

  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}

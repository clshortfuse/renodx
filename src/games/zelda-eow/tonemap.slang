// Tonemapper
#version 450
#ifndef USE_VIGNETTE
#define USE_VIGNETTE 0
#endif

#include "./common.slang"
#include "./hejldawson_extended.hlsli"

#if USE_VIGNETTE
layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 0, binding = 25, std140) uniform fp_c6 {
  vec4 _m0[4096];
}
fp_c6_1;
#endif

layout(set = 0, binding = 24, std140) uniform fp_c5 {
  vec4 _m0[4096];
}
fp_c5_1;

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) noperspective in vec4 uv;
layout(location = 0) out vec4 out;

void main() {
  vec4 scene = textureLodOffset(fp_t_tcb_8, uv.xy, 0, 0);

#if USE_VIGNETTE
  float vignetteCurve = CalculateVignette();
  vignetteCurve = lerp(1.f, vignetteCurve, CUSTOM_VIGNETTE);
  scene = vignetteCurve * scene;
#endif
  
  float exposure = fp_c5_1._m0[0].x;
  vec2 param = fp_c1_1._m0[0].xy;

  vec3 untonemapped = scene.rgb * exposure;
  if (RENODX_TONE_MAP_TYPE != 6.f) untonemapped = max(0, untonemapped - 0.004f);  // lower shadows like vanilla
  vec3 vanilla = lerp(renodx::tonemap::ExponentialRollOff(untonemapped), HejlDawson::ApplyLinear(untonemapped, 2.2f, param.x, param.y), LUT_STRENGTH);
  vanilla = renodx::color::correct::GamutCompress(vanilla);
  
  if (RENODX_TONE_MAP_TYPE != 6.f) untonemapped = lerp(untonemapped, HejlDawson::ApplyExtended(untonemapped, 2.2f, param.x, param.y), LUT_STRENGTH);

  // why are the values like this...?
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    out.rgb = vanilla;
  } 
  else if (RENODX_TONE_MAP_TYPE == 3.f) {
    out.rgb = ColorCorrect(untonemapped, vanilla);
  }
  else if (RENODX_TONE_MAP_TYPE == 6.f) {
    out.rgb = ZeldaEOWApplyHejlDawsonToneMap(untonemapped, param.x, param.y);
    out.rgb = renodx::draw::RenderIntermediatePass(out.rgb);
    return;
  }
  out.rgb = ApplyColorGrade(out.rgb);
  out.rgb = DisplayMap(out.rgb);
  out.rgb = renodx::draw::RenderIntermediatePass(out.rgb);
}

#if USE_VIGNETTE
float CalculateVignette() {
  float2 invViewport = vec2(1.0 / fp_c3_1._m0[0].z, 1.0 / fp_c3_1._m0[0].w);
  float2 uvOrigin = uv.xy - fp_c3_1._m0[0].xy;
  float2 radialUv = fma(uvOrigin, invViewport, fp_c6_1._m0[1].xy) - vec2(0.5);

  float radialX2 = radialUv.x * radialUv.x;
  float radialY = radialUv.y * fp_c6_1._m0[0].w;
  float radialDist2 = fma(radialY, radialY, radialX2);
  float vignetteBase = fma(radialDist2, -fp_c6_1._m0[0].x, fp_c6_1._m0[0].x);
  float vignette = saturate(vignetteBase);
  float vignetteCurve = pow(vignette, fp_c6_1._m0[0].y) + fp_c6_1._m0[0].z;
  vignetteCurve = saturate(vignetteCurve);
  return vignetteCurve;
}
#endif
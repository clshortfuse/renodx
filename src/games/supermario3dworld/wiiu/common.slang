#version 450
#include "../shared.slang"

layout(set = 1, binding = 2, std140) uniform post_params {
  ivec4 uf_remappedPS[1];
  vec4 uf_fragCoordScale;
}
post_params_1;

#ifdef FINAL_LEVEL
layout(set = 1, binding = 3, std140) uniform final_level_params {
  ivec4 uf_remappedPS[1];
  vec4 uf_fragCoordScale;
}
final_level_params_1;
#endif

#ifdef WRECK
layout(set = 1, binding = 5, std140) uniform wreck_params {
  ivec4 uf_remappedPS[2];
  vec4 uf_fragCoordScale;
}
wreck_params_1;
#endif

#ifdef LUT
#ifdef WRECK
layout(set = 1, binding = 6, std140) uniform lut_params {
#elif defined(FINAL_LEVEL)
layout(set = 1, binding = 4, std140) uniform lut_params {
#else
layout(set = 1, binding = 3, std140) uniform lut_params {
#endif
  ivec4 uf_remappedPS[2];
  vec4 uf_fragCoordScale;
}
lut_params_1;
#endif

#if defined(VIGNETTE) && !defined(WRECK) && !defined(FINAL_LEVEL)
layout(set = 1, binding = 4, std140) uniform vignette_params {
  ivec4 uf_remappedPS[1];
  vec4 uf_fragCoordScale;
}
vignette_params_1;
#endif

#ifdef WRECK
layout(set = 1, binding = 0) uniform sampler2D fp_t_tcb_8;
layout(set = 1, binding = 1) uniform sampler2D fp_t_tcb_E;
layout(set = 1, binding = 2) uniform sampler2D fp_t_tcb_12;
layout(set = 1, binding = 3) uniform sampler2D fp_t_tcb_14;
layout(set = 1, binding = 4) uniform sampler2D fp_t_tcb_16;
#ifdef LUT
layout(set = 1, binding = 7) uniform sampler3D fp_t_tcb_C;
#endif
#elif defined(FINAL_LEVEL)
layout(set = 1, binding = 0) uniform sampler2D fp_t_tcb_8;
layout(set = 1, binding = 1) uniform sampler2D fp_t_tcb_E;
layout(set = 1, binding = 2) uniform sampler2D fp_t_tcb_12;
#ifdef LUT
layout(set = 1, binding = 5) uniform sampler3D fp_t_tcb_C;
#endif
#elif !defined(LUT)
#ifdef BLOOM
#ifndef VIGNETTE
layout(set = 1, binding = 0) uniform sampler2D fp_t_tcb_8;
layout(set = 1, binding = 1) uniform sampler2D fp_t_tcb_10;
#else
layout(set = 1, binding = 1) uniform sampler2D fp_t_tcb_E;
layout(set = 1, binding = 2) uniform sampler2D fp_t_tcb_10;
layout(set = 1, binding = 3) uniform sampler2D fp_t_tcb_12;
layout(set = 1, binding = 0) uniform sampler2D fp_t_tcb_8;
#endif
#else
layout(set = 1, binding = 0) uniform sampler2D fp_t_tcb_8;
#endif
#else
layout(set = 1, binding = 0) uniform sampler2D fp_t_tcb_8;
layout(set = 1, binding = 2) uniform sampler2D fp_t_tcb_10;
layout(set = 1, binding = 1) uniform sampler3D fp_t_tcb_C;
#endif

#ifdef WRECK
layout(location = 0) in vec4 uvFlowA;
layout(location = 1) in vec4 uvFlowB;
layout(location = 2) in vec4 uv;
#else
layout(location = 0) in vec4 uv;
#endif
layout(location = 0) out vec4 out;

void main() {
  vec4 scene;
  vec3 bloom = vec3(0.0);
  float scale = intBitsToFloat(post_params_1.uf_remappedPS[0].x);
#ifdef LUT
  scale = intBitsToFloat(lut_params_1.uf_remappedPS[0].x);
#endif
#if defined(VIGNETTE) && !defined(WRECK) && !defined(FINAL_LEVEL)
  scale = intBitsToFloat(vignette_params_1.uf_remappedPS[0].x);
#endif

#ifdef WRECK
  const float flowBias = 0.501960813999176025390625;
  vec2 flow16 = texture(fp_t_tcb_16, uvFlowA.xy).xy;
  vec2 uv14 = fma(flow16 - vec2(flowBias), vec2(intBitsToFloat(wreck_params_1.uf_remappedPS[0].x)), uvFlowB.xy);
  vec2 flow14 = texture(fp_t_tcb_14, uv14).xy;
  vec2 flow = (flow14 - vec2(flowBias)) * intBitsToFloat(wreck_params_1.uf_remappedPS[1].w);
  vec2 flowUv = uv.xy + flow;

  scene = texture(fp_t_tcb_8, flowUv);
  bool hasFlow = (flow.x != 0.0) || isnan(flow.x) || (flow.y != 0.0) || isnan(flow.y);
  if (hasFlow) {
    vec2 tapOffset = flow * intBitsToFloat(wreck_params_1.uf_remappedPS[0].y);
    scene.y = texture(fp_t_tcb_8, flowUv + tapOffset).y;
    scene.x = texture(fp_t_tcb_8, flowUv + tapOffset * 2.0).x;
  }

  vec3 vignette = texture(fp_t_tcb_E, flowUv).xyz * intBitsToFloat(wreck_params_1.uf_remappedPS[1].z) + intBitsToFloat(wreck_params_1.uf_remappedPS[1].y);
  bloom = texture(fp_t_tcb_12, flowUv).xyz * vignette;
  scale = intBitsToFloat(wreck_params_1.uf_remappedPS[1].x);
#elif defined(FINAL_LEVEL)
  scene = texture(fp_t_tcb_8, uv.xy);
  vec3 vignette = texture(fp_t_tcb_E, uv.xy).xyz * intBitsToFloat(final_level_params_1.uf_remappedPS[0].z) + intBitsToFloat(final_level_params_1.uf_remappedPS[0].y);
  bloom = texture(fp_t_tcb_12, uv.xy).xyz * vignette;
  scale = intBitsToFloat(final_level_params_1.uf_remappedPS[0].x);
#else
  scene = texture(fp_t_tcb_8, uv.xy).xyzw;
  // out = scene;
  // return;
#ifdef BLOOM
  bloom = texture(fp_t_tcb_10, uv.xy).xyz;
#endif
#endif

  bloom *= CUSTOM_BLOOM;
#if defined(VIGNETTE) && !defined(WRECK) && !defined(FINAL_LEVEL)
  vec3 effect = texture(fp_t_tcb_12, uv.xy).xyz;
  vec3 vignette = texture(fp_t_tcb_E, uv.xy).xyz * intBitsToFloat(vignette_params_1.uf_remappedPS[0].z) + intBitsToFloat(vignette_params_1.uf_remappedPS[0].y);
  bloom += effect * vignette;
#endif
  scene.xyz = scene.xyz * scale;
  scene.xyz += bloom.xyz;

  vec3 color = saturate(scene.xyz);
#ifdef LUT
  color = lut(color);
#endif
  [branch]
  if (RENODX_TONE_MAP_TYPE != 0) {
    vec3 hdr = scene.xyz;
#ifdef LUT
    hdr = lut(hdr, true);
#endif
    color = ColourCorrect(hdr, color);
  }
  color = ApplyColorGrade(color);
  color = DisplayMap(color);
  color = renodx::draw::RenderIntermediatePass(color);
  out = vec4(color, scene.w);
}

#ifdef LUT
float3 lut(float3 color, bool is_hdr = false) {
  float max_channel_scale;
  [branch]
  if (is_hdr)
    max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color);
  else
    max_channel_scale = 1.f;
  vec3 lutCoord = color * max_channel_scale * intBitsToFloat(lut_params_1.uf_remappedPS[1].z) + intBitsToFloat(lut_params_1.uf_remappedPS[1].w);
  vec3 lutColor = texture(fp_t_tcb_C, lutCoord).xyz;
  return lerp(color, lutColor / max_channel_scale, LUT_STRENGTH);
}
#endif 
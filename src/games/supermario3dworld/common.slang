#version 450
#include "./shared.slang"

layout(set = 0, binding = 23, std140) uniform fp_c4 {
  vec4 _m0[4096];
}
fp_c4_1;

#ifdef BF_CUTSCENE
layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_10;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
#elif defined(BF_ATTACK)
layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_16;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_14;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_10;
#elif defined(BF_LUT_FLOW)
layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_16;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_14;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_10;
#elif defined(WRECK)
layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_16;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_14;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_E;
layout(set = 2, binding = 132) uniform sampler2D fp_t_tcb_12;
#elif defined(FINAL_LEVEL)
layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_E;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_12;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;
#else
#ifdef BLOOM
#ifndef VIGNETTE
layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_10;
#else
layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_E;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_10;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_12;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_8;
#endif
#else
layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
#endif
#endif

#ifdef LUT
#if defined(BF_LUT_FLOW) || defined(BF_ATTACK)
layout(set = 2, binding = 132) uniform sampler3D fp_t_tcb_C;
#elif defined(WRECK)
layout(set = 2, binding = 133) uniform sampler3D fp_t_tcb_C;
#elif defined(FINAL_LEVEL)
layout(set = 2, binding = 131) uniform sampler3D fp_t_tcb_C;
#else
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_C;
#endif
#endif

#ifdef BF_CUTSCENE
layout(location = 0) in vec4 uv;
layout(location = 1) in vec4 cutsceneTint;
layout(location = 2) in vec4 cutsceneAxis;
layout(location = 3) in vec4 bfScale;
#elif defined(BF_ATTACK)
layout(location = 2) in vec4 uvFlowA;
layout(location = 1) in vec4 uvFlowB;
layout(location = 0) in vec4 uv;
layout(location = 3) in vec4 bfScale;
layout(location = 5) in vec4 attackAxis;
layout(location = 4) in vec4 attackTint;
layout(location = 6) in vec4 attackStrength;
#elif defined(BF_LUT_FLOW)
layout(location = 2) in vec4 uvFlowA;
layout(location = 1) in vec4 uvFlowB;
layout(location = 0) in vec4 uv;
layout(location = 3) in vec4 bfScale;
#elif defined(WRECK)
layout(location = 2) in vec4 uvFlowA;
layout(location = 1) in vec4 uvFlowB;
layout(location = 0) in vec4 uv;
#elif defined(FINAL_LEVEL)
layout(location = 0) in vec4 uv;
#else
layout(location = 0) in vec4 uv;
#ifdef BF
layout(location = 1) in vec4 bfScale;
#endif
#endif
layout(location = 0) out vec4 out;

void main() {
  vec4 scene;
  vec3 bloom = vec3(0.0);
  vec3 attackAdd = vec3(0.0);
  float scale;

#ifdef BF_CUTSCENE
  vec3 tex10 = texture(fp_t_tcb_10, uv.xy).xyz;
  vec4 tex8 = texture(fp_t_tcb_8, uv.xy);

  vec2 delta = uv.xy - vec2(0.5);
  float radialSq = dot(delta, delta);
  float radial = clamp(exp2(log2(abs(radialSq)) * 4.0), 0.0, 1.0);
  float directional = clamp(fma(delta.y, -cutsceneAxis.y, delta.x * cutsceneAxis.x), 0.0, 1.0);
  vec3 flare = directional * radial * cutsceneTint.xyz;

  scene = tex8;
  bloom = tex10 + flare * bfScale.x;
  scale = fp_c4_1._m0[1].x;

#elif defined(BF_ATTACK)
  const float flowBias = 0.501960813999176025390625;
  vec2 flow16 = texture(fp_t_tcb_16, uvFlowA.xy).xy;
  vec2 uv14 = fma(flow16 - vec2(flowBias), vec2(fp_c4_1._m0[2].x), uvFlowB.xy);
  vec2 flow14 = texture(fp_t_tcb_14, uv14).xy;
  vec2 flow = (flow14 - vec2(flowBias)) * fp_c4_1._m0[1].w;
  vec2 flowUv = uv.xy + flow;

  scene = texture(fp_t_tcb_8, flowUv);
  bool hasFlow = (flow.x != 0.0) || isnan(flow.x) || (flow.y != 0.0) || isnan(flow.y);
  if (hasFlow) {
    vec2 tapOffset = flow * fp_c4_1._m0[2].y;
    scene.y = texture(fp_t_tcb_8, flowUv + tapOffset).y;
    scene.x = texture(fp_t_tcb_8, flowUv + tapOffset * 2.0).x;
  }
  bloom = texture(fp_t_tcb_10, flowUv).xyz;
  scale = bfScale.w;

  vec2 delta = flowUv - vec2(0.5);
  float radialSq = dot(delta, delta);
  float radial = clamp(exp2(log2(abs(radialSq)) * 4.0), 0.0, 1.0);
  float directional = clamp(fma(delta.y, -attackAxis.y, delta.x * attackAxis.x), 0.0, 1.0);
  vec3 flare = directional * radial * attackTint.xyz;
  attackAdd = flare * attackStrength.x;

#elif defined(BF_LUT_FLOW)
  const float flowBias = 0.501960813999176025390625;
  vec2 flow16 = texture(fp_t_tcb_16, uvFlowA.xy).xy;
  vec2 uv14 = fma(flow16 - vec2(flowBias), vec2(fp_c4_1._m0[2].x), uvFlowB.xy);
  vec2 flow14 = texture(fp_t_tcb_14, uv14).xy;
  vec2 flow = (flow14 - vec2(flowBias)) * fp_c4_1._m0[1].w;
  vec2 flowUv = uv.xy + flow;

  scene = texture(fp_t_tcb_8, flowUv);
  bool hasFlow = (flow.x != 0.0) || isnan(flow.x) || (flow.y != 0.0) || isnan(flow.y);
  if (hasFlow) {
    vec2 tapOffset = flow * fp_c4_1._m0[2].y;
    scene.y = texture(fp_t_tcb_8, flowUv + tapOffset).y;
    scene.x = texture(fp_t_tcb_8, flowUv + tapOffset * 2.0).x;
  }
  bloom = texture(fp_t_tcb_10, flowUv).xyz;
  scale = bfScale.w;

#elif defined(FINAL_LEVEL)
  scene = texture(fp_t_tcb_8, uv.xy);
  vec3 vignette = texture(fp_t_tcb_E, uv.xy).xyz * fp_c4_1._m0[1].z + fp_c4_1._m0[1].y;
  bloom = texture(fp_t_tcb_12, uv.xy).xyz * vignette;
  scale = fp_c4_1._m0[1].x;

#elif defined(WRECK)
  const float flowBias = 0.501960813999176025390625;
  vec2 flow16 = texture(fp_t_tcb_16, uvFlowA.xy).xy;
  vec2 uv14 = fma(flow16 - vec2(flowBias), vec2(fp_c4_1._m0[2].x), uvFlowB.xy);
  vec2 flow14 = texture(fp_t_tcb_14, uv14).xy;
  vec2 flow = (flow14 - vec2(flowBias)) * fp_c4_1._m0[1].w;
  vec2 flowUv = uv.xy + flow;

  scene = texture(fp_t_tcb_8, flowUv);
  bool hasFlow = (flow.x != 0.0) || isnan(flow.x) || (flow.y != 0.0) || isnan(flow.y);
  if (hasFlow) {
    vec2 tapOffset = flow * fp_c4_1._m0[2].y;
    scene.y = texture(fp_t_tcb_8, flowUv + tapOffset).y;
    scene.x = texture(fp_t_tcb_8, flowUv + tapOffset * 2.0).x;
  }

  vec3 vignette = texture(fp_t_tcb_E, flowUv).xyz * fp_c4_1._m0[1].z + fp_c4_1._m0[1].y;
  bloom = texture(fp_t_tcb_12, flowUv).xyz * vignette;
  scale = fp_c4_1._m0[1].x;

#else
#ifndef BF
  scale = fp_c4_1._m0[1].x;
#else
  scale = bfScale.w;
#endif
  scene = texture(fp_t_tcb_8, uv.xy).xyzw;
#ifdef BLOOM
  bloom = texture(fp_t_tcb_10, uv.xy).xyz;
#endif
#endif

#if !defined(BF_LUT_FLOW) && !defined(BF_CUTSCENE) && !defined(FINAL_LEVEL) && !defined(WRECK) && !defined(BF_ATTACK)

#if defined(LUT) || defined(BF)
  vec3 preSwapColor = scene.xyz;
  scene.xyz = bloom.xyz;
  bloom.xyz = preSwapColor.xyz;
#endif
#endif

  bloom *= CUSTOM_BLOOM;
#if defined(VIGNETTE) && !defined(FINAL_LEVEL) && !defined(WRECK)
  vec3 effect = texture(fp_t_tcb_12, uv.xy).xyz;
  vec3 vignette = texture(fp_t_tcb_E, uv.xy).xyz * fp_c4_1._m0[1].z + fp_c4_1._m0[1].y;
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
#ifdef BF_ATTACK
  color += attackAdd;
#endif
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
  vec3 lutCoord = color * max_channel_scale * fp_c4_1._m0[4].z + fp_c4_1._m0[4].w;
  vec3 lutColor = texture(fp_t_tcb_C, lutCoord).xyz;
  return lerp(color, lutColor / max_channel_scale, LUT_STRENGTH);
}
#endif 
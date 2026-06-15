#version 450
#include "./shared.h"
#include "./shared.slang"

layout(set = 0, binding = 0, std140) uniform support_buffer {
  uint _m0;
  uint _m1[8];
  vec4 _m2;
  vec4 _m3;
  int _m4;
  float _m5[73];
  ivec4 _m6;
  int _m7;
}
support_buffer_1;

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler3D fp_t_tcb_A;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_C;

layout(location = 0) in vec4 in;
layout(location = 0) out vec4 out;

void main() {
  bool enablePreScale = (floatBitsToInt(fp_c3_1._m0[0].x) != 0);
  bool enableLutA = (floatBitsToInt(fp_c3_1._m0[0].z) != 0);
  bool enableBloomLike = (floatBitsToInt(fp_c3_1._m0[0].w) != 0);
  bool enableRimA = (floatBitsToInt(fp_c3_1._m0[1].y) != 0);
  bool enableRimB = (floatBitsToInt(fp_c3_1._m0[1].w) != 0);
  bool enableLutC = (floatBitsToInt(fp_c3_1._m0[2].w) != 0);

  vec2 uv = in.xy;
  vec3 scene = texture(fp_t_tcb_8, uv).xyz;
  vec3 hdr;

  if (enablePreScale) {
    scene *= fp_c3_1._m0[0].y;
  }

  vec3 colorRgb = scene;
  hdr = scene;

  if (enableLutA) {
    hdr = lutA(scene, true);
    colorRgb = lutA(scene);
  }

  // if (enableBloomLike || enableRimA || enableRimB || enableLutC) {
  //   colorRgb = 1;
  //   out.xyzw = 0;
  //   return;
  // }

  vec2 centeredUv = vec2(0.5) - uv;

  if (enableBloomLike) {
    float radius = min(length(centeredUv) * 2.0, 1.0);
    float gain = radius * radius * radius * fp_c3_1._m0[1].x;
    vec3 lifted = exp2(log2(abs(colorRgb)) * 4.0);
    colorRgb = fma(lifted - colorRgb, vec3(gain), colorRgb);
  }

  if (enableRimA) {
    float radius = length(centeredUv);
    float falloff = clamp((fma(radius, 2.0, -0.5)) * 2.0, 0.0, 1.0);
    float gain = falloff * falloff * fp_c3_1._m0[1].z;
    vec3 biasRgb = vec3(0.13699999451637268, 0.0, 0.20000000298023224);
    colorRgb = fma(biasRgb - colorRgb, vec3(gain), colorRgb);
  }

  if (enableRimB) {
    float radius = length(centeredUv);
    float falloff = clamp((fma(fp_c3_1._m0[2].z, fp_c1_1._m0[0].y, radius)) * 5.0, 0.0, 1.0);
    float gain = falloff * falloff * fp_c3_1._m0[2].x;
    float zDriven = fma(fp_c3_1._m0[2].y, fp_c1_1._m0[0].x, -colorRgb.y) + 0.20000000298023224;

    colorRgb = vec3(
        fma((-colorRgb.x + 0.6000000238418579), gain, colorRgb.x),
        fma(zDriven, gain, colorRgb.y),
        fma(gain, -colorRgb.z, colorRgb.z));
  }

  if (enableLutC) {
    vec3 lutUv = fma(colorRgb, vec3(0.9375), vec3(0.03125));
    vec3 lutColor = texture(fp_t_tcb_C, lutUv).xyz;

    vec2 offsetUv = uv - fp_c3_1._m0[3].zw;
    float dist2 = dot(offsetUv, offsetUv);
    float invDist = inversesqrt(dist2);
    float dist = sqrt(dist2);
    vec2 dir = offsetUv * invDist;

    float x = dir.x;
    float y = dir.y;
    float s0 = -float(y < -x) + float(y > -x);
    float s1 = -float(y < x) + float(y > x);
    float s2 = -float(y < 0.0) + float(y > 0.0);
    float s3 = -float(x < 0.0) + float(x > 0.0);
    float chooseY = float((s0 * s1) >= 0.0);
    float phase = fma(x, chooseY * s2 + (1.0 - chooseY) * s3, y * (chooseY * s2));

    float p = fp_c3_1._m0[4].x;
    float w0 = p * 18.84929656982421875;
    float w1 = p * 6.2830986976623535;
    float w2 = p * 31.41549301147461;

    float sA = sin(fma(phase, 4.0, w2));
    float sB = sin(fma(phase, 9.0, -w0) + 1.0);
    float sC = sin(fma(phase, 13.0, w1) + 2.0);

    float wave = fma(sA, fp_c1_1._m0[0].z, sB * 0.05999999865889549);
    wave = fma(sC, fp_c1_1._m0[0].w, wave);
    wave = fma(fma(2.0, fp_c3_1._m0[3].y, 0.4000000059604645), fp_c3_1._m0[3].x, wave);

    float blend = clamp((fma(dist, 2.0, -wave) + 0.20000000298023224) * 2.5, 0.0, 1.0);

    vec3 mixed = colorRgb + (lutColor - colorRgb) * (1.0 - blend);

    colorRgb = mixed;

  }

  if (RENODX_TONE_MAP_TYPE != 0) colorRgb = ColourCorrect(hdr, colorRgb);
  else colorRgb = saturate(colorRgb); // in case lut isn't used
  out.xyz = colorRgb;
  out.w = 0.0;
  out.xyz = ApplyColorGrade(out.xyz);
  out.xyz = DisplayMap(out.xyz);
  out = renodx::draw::RenderIntermediatePass(out);
}

vec3 lutA(vec3 color, bool scaled = false) {
  float scale = renodx::math::Select(scaled, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1);
  color *= scale;
  vec3 lutUv = color * 0.9375 + 0.03125;
  vec3 lutColor = texture(fp_t_tcb_A, lutUv).xyz;
  color = (renodx::math::Select(RENODX_TONE_MAP_TYPE != 0, color, saturate(color))) / scale;
  color = lerp(color, lutColor / scale, LUT_STRENGTH);
  return color;
}
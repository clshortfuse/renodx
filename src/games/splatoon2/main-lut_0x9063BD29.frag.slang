#version 450
#include "./shared.h"
#include "./shared.slang"

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_10;

layout(location = 0) in vec4 _36;
layout(location = 1) in vec4 _38;
layout(location = 0) out vec4 out;

void main()
{
    vec2 uv = _36.xy;
    vec3 bloom = texture(fp_t_tcb_A, uv).xyz;
    vec4 blendSample = texture(fp_t_tcb_8, uv);

    float blendWeight = _38.w;
    vec3 blended = fma(blendSample.xyz, blendWeight, bloom);

    out.xyz = lut(blended, true);
    out.w = blendSample.w;
    vec3 sdr = lerp(renodx::tonemap::ExponentialRollOff(blended), lut(blended), LUT_STRENGTH);
    if (RENODX_TONE_MAP_TYPE != 0.f) out.xyz = ColourCorrect(lerp(blended, out.xyz, LUT_STRENGTH), sdr);
    else out.xyz = sdr;
    out.xyz = ApplyColorGrade(out.xyz);
    out.xyz = Tonemap(out.xyz);
    out.xyz = renodx::draw::RenderIntermediatePass(out.xyz);
}

vec3 lut(vec3 input, bool hdr = false) {
  const float kNegInvLn2 = -1.44269502162933349609375;
  float scale = 1;
  if (hdr) scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(input);
  input *= scale;

  float luma = fma(input.z, fp_c1_1._m0[0].y, fma(input.y, fp_c1_1._m0[0].x, input.x * 0.29890000820159912109375));
  float invLuma = 1.0 / luma;

  float lumaCurve = exp2(luma * kNegInvLn2);
  vec3 channelCurve = exp2(input * kNegInvLn2);
  vec3 normalized = input * invLuma;

  float oneMinusLumaCurve = 1.0 - lumaCurve;
  float oneMinusLumaCurveSq = oneMinusLumaCurve * oneMinusLumaCurve;

  vec3 curveBias = fma(normalized, -oneMinusLumaCurve, -channelCurve);
  vec3 remapped = fma(normalized, oneMinusLumaCurve, fma(oneMinusLumaCurveSq, curveBias, oneMinusLumaCurveSq));
  vec3 lutCoords = fma(remapped, fp_c3_1._m0[5].x, fp_c3_1._m0[5].y);

  return texture(fp_t_tcb_10, lutCoords).xyz / scale;
}

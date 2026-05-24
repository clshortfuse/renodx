#version 450
#include "./shared.h"
#include "./shared.slang"

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_14;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 _33;
layout(location = 0) out vec4 out;



void main()
{
    vec2 uv = _33.xy;

    float lutU = saturate(uv.x * fp_c3_1._m0[11].x * fp_c3_1._m0[10].z);
    float lutV = saturate(uv.y * fp_c3_1._m0[11].y * fp_c3_1._m0[10].w);

    vec3 lutA = texture(fp_t_tcb_14, vec2(lutU, lutV)).xyz;
    vec3 lutB = texture(fp_t_tcb_C, vec2(lutU, lutV)).xyz;
    vec3 base = texture(fp_t_tcb_8, uv).xyz;

    float exposure = exp2(fp_c3_1._m0[0].x);
    vec3 hdr = exposure * (lutA + lutB + base);
    vec3 output = ApplyTonemap(hdr, RENODX_TONE_MAP_TYPE != 0.f);

    if (RENODX_TONE_MAP_TYPE != 0.f) output = MetroidCorrect(output, ApplyTonemap(hdr));

    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION == 1.f) {
      peak = renodx::color::correct::GammaSafe(peak, true);
    }
    if (RENODX_GAMMA_CORRECTION == 2.f) {
      peak = renodx::color::correct::GammaSafe(peak, true, 2.4);
    }

    output = renodx::tonemap::neutwo::PerChannel(output, peak);
    out.xyz = renodx::draw::RenderIntermediatePass(output);
      // apply inverse gamma to undo swap chain decoding, since this shader is writing to the swap chain
    out.w = 0.0;
}

vec3 ApplyTonemap(vec3 hdr, bool useHdrPath = false)
{
  const float kBiasA = 0.589999973773956298828125;
  const float kBiasB = 0.02999999932944774627685546875;
  const float kLumaR = 0.2989999949932098388671875;
  const float kHdrBlendStart = 0.0;
  const float kHdrBlendEnd = 4.0;

  vec3 curve = fma(hdr, fp_c1_1._m0[0].x, kBiasA);
  vec3 toe = fma(hdr, fp_c1_1._m0[0].y, kBiasB);
  vec3 denom = fma(hdr, curve, fp_c1_1._m0[0].z);
  vec3 mappedSdr = clamp((hdr * toe) * (1.0 / denom), 0.0, 1.0);

  vec3 toneMapped = mappedSdr;
  if (useHdrPath) {
    vec3 mappedHdr = (hdr * toe) * (1.0 / denom);
    float hdrPeak = max(max(hdr.x, hdr.y), hdr.z);
    float hdrBlend = smoothstep(kHdrBlendStart, kHdrBlendEnd, hdrPeak);
    toneMapped = mix(mappedHdr, hdr, hdrBlend);
  }

  float mixWeight = fma(toneMapped.z, fp_c1_1._m0[1].x, fma(toneMapped.y, fp_c1_1._m0[0].w, toneMapped.x * kLumaR));
  float logMix = log2(mixWeight);

  vec3 blend = fma(mixWeight, -fp_c3_1._m0[2].xyz, toneMapped);
  vec3 add = mixWeight * fp_c3_1._m0[2].xyz;
  float blendAmount = exp2(logMix * fp_c3_1._m0[2].w);
  return fma(blend, blendAmount, add);
}

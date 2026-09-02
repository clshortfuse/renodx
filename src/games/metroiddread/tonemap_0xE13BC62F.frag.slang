#version 450
#include "./shared.h"


layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

#define METROID_GAMMA fp_c3_1._m0[0].y
#include "./shared.slang"

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

    vec2 lutUV = saturate(uv.xy * fp_c3_1._m0[11].xy * fp_c3_1._m0[10].zw);
    vec3 lutA = texture(fp_t_tcb_14, lutUV).xyz;
    vec3 lutB = texture(fp_t_tcb_C, lutUV).xyz;
    vec3 base = texture(fp_t_tcb_8, uv).xyz;

    float exposure = exp2(fp_c3_1._m0[0].x);
    vec3 hdr = exposure * (lutA + lutB + base);
    vec3 output = ApplyTonemap(hdr, RENODX_TONE_MAP_TYPE != 0.f);

    if (RENODX_TONE_MAP_TYPE != 0.f) output = MetroidCorrect(output, ApplyTonemap(hdr));

    
    output = ApplyVanillaPostCurve(output);
    output = ApplyColorGrade(output);
   

    

    if (RENODX_TONE_MAP_TYPE != 0.f) {
      float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      if (RENODX_GAMMA_CORRECTION == 1.f) {
        peak = renodx::color::correct::GammaSafe(peak, true);
      }
      if (RENODX_GAMMA_CORRECTION == 2.f) {
        peak = renodx::color::correct::GammaSafe(peak, true, 2.4);
      }

      output = renodx::tonemap::neutwo::PerChannel(output, peak);
    }

    out.xyz = renodx::draw::RenderIntermediatePass(output);
    out.w = 0.0;
}

vec3 ApplyTonemap(vec3 hdr, bool useHdrPath = false)
{
  const float kBiasA = 0.589999973773956298828125;
  const float kBiasB = 0.02999999932944774627685546875;
  const float kLumaR = 0.2989999949932098388671875;
  const float kHdrBlendStart = 0.0;
  const float kHdrBlendEnd = 1.0;

  vec3 curve = fma(hdr, fp_c1_1._m0[0].x, kBiasA);
  vec3 toe = fma(hdr, fp_c1_1._m0[0].y, kBiasB);
  vec3 denom = fma(hdr, curve, fp_c1_1._m0[0].z);
  vec3 mappedSdr = clamp((hdr * toe) * (1.0 / denom), 0.0, 1.0);

  vec3 toneMapped = mappedSdr;
  if (useHdrPath) {
    vec3 mappedHdr = (hdr * toe) * (1.0 / denom);
    float hdrPeak = renodx::math::Max(hdr);
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

/*#version 450

layout(set = 0, binding = 0, std140) uniform support_buffer
{
  uint _m0;
  uint _m1[8];
  vec4 _m2;
  vec4 _m3;
  int _m4;
  float _m5[73];
  ivec4 _m6;
  int _m7;
} support_buffer_1;

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
layout(location = 0) out vec4 _36;

void main()
{
  float _43 = _33.x;
  float _45 = _33.y;
  precise float _244 = _43 * fp_c3_1._m0[11].x;
  float _47 = _244;
  precise float _248 = _45 * fp_c3_1._m0[11].y;
  float _49 = _248;
  precise float _254 = _47 * fp_c3_1._m0[10].z;
  float _51 = _254;
  float _53 = clamp(_51, 0.0, 1.0);
  precise float _264 = _49 * fp_c3_1._m0[10].w;
  float _55 = _264;
  float _57 = clamp(_55, 0.0, 1.0);
  vec3 _61 = texture(fp_t_tcb_14, vec2(_53, _57)).xyz;
  float _63 = _61.x;
  float _65 = _61.y;
  float _67 = _61.z;
  vec3 _69 = texture(fp_t_tcb_C, vec2(_53, _57)).xyz;
  float _71 = _69.x;
  float _73 = _69.y;
  float _75 = _69.z;
  vec3 _77 = texture(fp_t_tcb_8, vec2(_43, _45)).xyz;
  float _79 = _77.x;
  float _81 = _77.y;
  float _83 = _77.z;
  float _85 = exp2(fp_c3_1._m0[0].x);
  precise float _309 = _63 + _71;
  float _87 = _309;
  precise float _312 = _65 + _73;
  float _89 = _312;
  precise float _315 = _67 + _75;
  float _91 = _315;
  precise float _318 = _87 + _79;
  float _93 = _318;
  precise float _321 = _89 + _81;
  float _95 = _321;
  precise float _324 = _91 + _83;
  float _97 = _324;
  precise float _327 = _85 * _93;
  float _99 = _327;
  precise float _330 = _85 * _95;
  float _101 = _330;
  precise float _333 = _85 * _97;
  float _103 = _333;
  float _105 = fma(_99, fp_c1_1._m0[0].x, 0.589999973773956298828125);
  float _107 = fma(_101, fp_c1_1._m0[0].x, 0.589999973773956298828125);
  float _109 = fma(_99, fp_c1_1._m0[0].y, 0.02999999932944774627685546875);
  float _111 = fma(_103, fp_c1_1._m0[0].x, 0.589999973773956298828125);
  float _113 = fma(_99, _105, fp_c1_1._m0[0].z);
  float _115 = fma(_101, _107, fp_c1_1._m0[0].z);
  precise float _363 = 1.0 / _113;
  float _117 = _363;
  float _119 = fma(_101, fp_c1_1._m0[0].y, 0.02999999932944774627685546875);
  precise float _369 = 1.0 / _115;
  float _121 = _369;
  precise float _372 = _99 * _109;
  float _123 = _372;
  float _125 = fma(_103, _111, fp_c1_1._m0[0].z);
  float _127 = fma(_103, fp_c1_1._m0[0].y, 0.02999999932944774627685546875);
  precise float _383 = 1.0 / _125;
  float _129 = _383;
  precise float _386 = _101 * _119;
  float _131 = _386;
  precise float _389 = _103 * _127;
  float _133 = _389;
  precise float _392 = _123 * _117;
  float _135 = _392;
  float _137 = clamp(_135, 0.0, 1.0);
  precise float _397 = _131 * _121;
  float _139 = _397;
  float _141 = clamp(_139, 0.0, 1.0);
  precise float _402 = _137 * 0.2989999949932098388671875;
  float _143 = _402;
  precise float _405 = _133 * _129;
  float _145 = _405;
  float _147 = clamp(_145, 0.0, 1.0);
  float _149 = fma(_141, fp_c1_1._m0[0].w, _143);
  float _151 = fma(_147, fp_c1_1._m0[1].x, _149);
  float _153 = log2(_151);
  float _155 = -fp_c3_1._m0[2].x;
  float _157 = fma(_151, _155, _137);
  float _159 = -fp_c3_1._m0[2].y;
  float _161 = fma(_151, _159, _141);
  precise float _437 = _151 * fp_c3_1._m0[2].y;
  float _163 = _437;
  float _165 = -fp_c3_1._m0[2].z;
  float _167 = fma(_151, _165, _147);
  precise float _448 = _151 * fp_c3_1._m0[2].z;
  float _169 = _448;
  precise float _452 = _153 * fp_c3_1._m0[2].w;
  float _171 = _452;
  precise float _456 = _151 * fp_c3_1._m0[2].x;
  float _173 = _456;
  float _175 = exp2(_171);
  float _177 = clamp(_175, 0.0, 1.0);
  precise float _464 = fp_c3_1._m0[0].y * 0.454545438289642333984375;
  float _179 = _464;
  float _181 = fma(_157, _177, _173);
  float _183 = fma(_161, _177, _163);
  float _185 = abs(_181);
  float _187 = log2(_185);
  float _189 = fma(_167, _177, _169);
  float _191 = abs(_183);
  float _193 = log2(_191);
  float _195 = abs(_189);
  float _197 = log2(_195);
  precise float _491 = _179 * _187;
  float _199 = _491;
  precise float _495 = 1.0 / fp_c3_1._m0[5].x;
  float _201 = _495;
  precise float _498 = _179 * _193;
  float _203 = _498;
  precise float _501 = _179 * _197;
  float _205 = _501;
  float _207 = exp2(_199);
  float _209 = exp2(_203);
  precise float _508 = _201 * 2.2000000476837158203125;
  float _211 = _508;
  float _213 = exp2(_205);
  float _215 = log2(_207);
  float _217 = log2(_209);
  float _219 = log2(_213);
  precise float _519 = _211 * _215;
  float _221 = _519;
  precise float _522 = _211 * _217;
  float _223 = _522;
  precise float _525 = _211 * _219;
  float _225 = _525;
  float _227 = exp2(_221);
  float _229 = exp2(_223);
  float _231 = exp2(_225);
  _36.x = _227;
  _36.y = _229;
  _36.z = _231;
  _36.w = 0.0;
}
*/

#version 450
#include "../shared.h"
#include "../shared.slang"

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

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_10;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_C;

layout(location = 0) in vec4 _34;
layout(location = 0) out vec4 _37;

void main()
{
    vec2 uv = _34.xy;
    float exposure = 1 / texture(fp_t_tcb_10, vec2(0.0)).x;
    vec3 scene = texture(fp_t_tcb_8, uv).xyz;

    vec3 finalColor = lut(scene) * exposure;
    vec3 hdr = lut(scene, true) * exposure;
    if (RENODX_TONE_MAP_TYPE != 0) finalColor = ColourCorrect(hdr, finalColor);
    finalColor = ApplyColorGrade(finalColor);
    finalColor = DisplayMap(finalColor);
    finalColor = renodx::draw::RenderIntermediatePass(finalColor);

    _37 = vec4(finalColor, 1.0);
}

vec3 lut(vec3 color, bool extended = false) {
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.f);
  color *= scale;
  vec3 encoded = renodx::math::SafePow(color, fp_c3_1._m0[2].x);
  vec3 sampleCoord = encoded * fp_c3_1._m0[3].z + fp_c3_1._m0[3].w;
  vec3 lut = texture(fp_t_tcb_C, sampleCoord).xyz;
  lut = lerp(color, lut, LUT_STRENGTH);
  lut = renodx::color::srgb::DecodeSafe(lut) / scale;
  return lut;

}
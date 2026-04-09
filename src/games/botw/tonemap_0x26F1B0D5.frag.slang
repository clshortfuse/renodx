#version 430
#include "./shared.h"

layout(set = 1, binding = 2, std140) uniform ufBlock
{
    ivec4 uf_remappedPS[1];
    vec4 uf_fragCoordScale;
} _355;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
layout(set = 1, binding = 1) uniform sampler2D textureUnitPS1;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 0) out vec4 passPixelColor0;

float mul_nonIEEE(float a, float b)
{
    return ((a != 0.0) && (b != 0.0)) ? (a * b) : 0.0;
}

void main()
{
    vec4 R0f = vec4(0.0);
    vec4 R1f = vec4(0.0);
    vec4 R123f = vec4(0.0);
    vec4 R125f = vec4(0.0);
    vec4 R126f = vec4(0.0);
    vec4 R127f = vec4(0.0);
    float PV0fx = 0.0;
    float PV0fy = 0.0;
    float PV0fz = 0.0;
    float PV0fw = 0.0;
    float PV1fx = 0.0;
    float PV1fy = 0.0;
    float PV1fz = 0.0;
    float PV1fw = 0.0;
    float PS0f = 0.0;
    float PS1f = 0.0;
    vec4 tempf = vec4(0.0);
    ivec4 ARi = ivec4(0);
    bool predResult = true;
    R0f = passParameterSem0;
    vec3 _74 = texture(textureUnitPS0, vec2(R0f.x, R0f.y)).xyz;
    R1f.x = _74.x;
    R1f.y = _74.y;
    R1f.z = _74.z;
    float _85 = R0f.x;
    float _87 = R0f.y;
    vec3 _90 = texture(textureUnitPS1, vec2(_85, _87)).xyz;
    R0f.x = _90.x;
    R0f.y = _90.y;
    R0f.z = _90.z;
    R126f.x = R1f.x + R0f.x;
    R127f.y = R1f.y + R0f.y;
    R126f.z = R1f.z + R0f.z;
    R125f.w = 1.0;
    tempf.x = dot(vec4(R126f.x, R127f.y, R126f.z, intBitsToFloat(int(0x80000000))), vec4(intBitsToFloat(1050216812), intBitsToFloat(1058417515), intBitsToFloat(1038764684), 0.0));
    PV1fx = tempf.x;
    PV1fy = tempf.x;
    PV1fz = tempf.x;
    PV1fw = tempf.x;
    R127f.x = (-R127f.y) * intBitsToFloat(1069066811);
    PV0fy = (-PV1fx) * intBitsToFloat(1069066811);
    R127f.z = (-R126f.x) * intBitsToFloat(1069066811);
    R127f.w = (-R126f.z) * intBitsToFloat(1069066811);
    R126f.w = 1.0 / PV1fx;
    PS1f = exp2(PV0fy);
    PV0fx = (-PS1f) + 1.0;
    PS0f = exp2(R127f.x);
    R127f.x = (-PS0f) + 1.0;
    float param = PV0fx;
    float param_1 = PV0fx;
    R126f.y = mul_nonIEEE(param, param_1);
    PV1fz = PV0fx * R126f.w;
    PS1f = exp2(R127f.w);
    float backupReg0f = R127f.z;
    float param_2 = R126f.x;
    float param_3 = PV1fz;
    R126f.x = mul_nonIEEE(param_2, param_3);
    PV0fy = (-PS1f) + 1.0;
    float param_4 = R126f.z;
    float param_5 = PV1fz;
    R127f.z = mul_nonIEEE(param_4, param_5);
    float param_6 = R127f.y;
    float param_7 = PV1fz;
    R127f.w = mul_nonIEEE(param_6, param_7);
    PS0f = exp2(backupReg0f);
    PV1fx = R127f.x + (-R127f.w);
    PV1fy = PV0fy + (-R127f.z);
    PV1fw = (-PS0f) + 1.0;
    float param_8 = PV1fx;
    float param_9 = R126f.y;
    R127f.x = mul_nonIEEE(param_8, param_9) + R127f.w;
    R127f.x = clamp(R127f.x, 0.0, 1.0);
    PV0fy = PV1fw + (-R126f.x);
    float param_10 = PV1fy;
    float param_11 = R126f.y;
    R127f.z = mul_nonIEEE(param_10, param_11) + R127f.z;
    R127f.z = clamp(R127f.z, 0.0, 1.0);
    float param_12 = PV0fy;
    float param_13 = R126f.y;
    R126f.x = mul_nonIEEE(param_12, param_13) + R126f.x;
    R126f.x = clamp(R126f.x, 0.0, 1.0);
    PV1fw = max(R127f.x, R127f.z);
    tempf.x = dot(vec4(R126f.x, R127f.x, R127f.z, R125f.w), vec4(intBitsToFloat(1059760811), intBitsToFloat(1059760811), intBitsToFloat(1059760811), -1.0));
    PV0fx = tempf.x;
    PV0fy = tempf.x;
    PV0fz = tempf.x;
    PV0fw = tempf.x;
    R126f.z = max(R126f.x, PV1fw);
    backupReg0f = R127f.x;
    float backupReg1f = R127f.z;
    R127f.x = R126f.x + (-R126f.z);
    float param_14 = -PV0fx;
    float param_15 = PV0fx;
    R123f.y = mul_nonIEEE(param_14, param_15) + 1.0;
    R127f.z = backupReg0f + (-R126f.z);
    R125f.w = backupReg1f + (-R126f.z);
    float param_16 = R123f.y;
    float param_17 = intBitsToFloat(_355.uf_remappedPS[0].y);
    R123f.x = mul_nonIEEE(param_16, param_17) + intBitsToFloat(_355.uf_remappedPS[0].x);
    float param_18 = R127f.x;
    float param_19 = R123f.x;
    R0f.x = mul_nonIEEE(param_18, param_19) + R126f.z;
    float param_20 = R127f.z;
    float param_21 = R123f.x;
    R0f.y = mul_nonIEEE(param_20, param_21) + R126f.z;
    float param_22 = R125f.w;
    float param_23 = R123f.x;
    R0f.z = mul_nonIEEE(param_22, param_23) + R126f.z;
    
    float3 tonemapped = R0f.xyz;
    float3 untonemapped = float3(_74 + _90);
    float3 grading_input = max(untonemapped, 0.f);
    float3 output = renodx::draw::ToneMapPass(saturate(tonemapped));
    if (RENODX_TONE_MAP_TYPE != 0.f) {
      float3 neutral_sdr = lerp(
          renodx::tonemap::renodrt::NeutralSDR(grading_input),
          renodx::tonemap::ExponentialRollOff(grading_input, 0.75f),
          CUSTOM_SATURATION_CLIP);

      if (RENODX_COLOR_GRADE_STRENGTH == 0.f) {
        output = renodx::draw::ToneMapPass(untonemapped);
      } else {
        float3 graded_sdr = max(tonemapped, 0.f);

        output = renodx::draw::ToneMapPass(
            untonemapped,
            graded_sdr,
            neutral_sdr);
      }
    }
    passPixelColor0 = float4(renodx::draw::RenderIntermediatePass(output), R0f.w);
}

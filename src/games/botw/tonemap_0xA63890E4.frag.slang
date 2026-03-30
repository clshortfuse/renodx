#version 450
#include "./shared.h"

layout(set = 1, binding = 2, std140) uniform ufBlock
{
    ivec4 uf_remappedPS[1];
    vec4 uf_fragCoordScale;
} _409;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
layout(set = 1, binding = 1) uniform sampler2D textureUnitPS1;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 0) out vec4 passPixelColor0;

float mul_nonIEEE(float a, float b)
{
    if ((a == 0.0) || (b == 0.0))
    {
        return 0.0;
    }
    return a * b;
}

/* renodx::draw::Config GetRenderIntermediatePassConfig()
{
    renodx::draw::Config config = renodx::draw::BuildConfig();


    // RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS = default game-to-UI ratio
    config.gamma_correction = RENODX_GAMMA_CORRECTION;
    config.intermediate_scaling = RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    config.intermediate_encoding = 0;
    config.intermediate_color_space = renodx::color::convert::COLOR_SPACE_BT709;

    // Examples:
    // config.gamma_correction = renodx::draw::GAMMA_CORRECTION_GAMMA_2_2;
    // config.intermediate_scaling = 1.f;
    // config.intermediate_scaling = RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    // config.intermediate_encoding = renodx::draw::ENCODING_SCRGB;
    // config.intermediate_color_space = renodx::color::convert::COLOR_SPACE_BT2020;
    // config.swap_chain_gamma_correction = renodx::draw::GAMMA_CORRECTION_NONE;

    return config;
} */

void main()
{
    vec4 R0f = vec4(0.0);
    vec4 R1f = vec4(0.0);
    vec4 R123f = vec4(0.0);
    vec4 R125f = vec4(0.0);
    vec4 R126f = vec4(0.0);
    vec4 R127f = vec4(0.0);
    vec4 PV0f = vec4(0.0);
    vec4 PV1f = vec4(0.0);
    float PS0f = 0.0;
    float PS1f = 0.0;
    vec4 tempf = vec4(0.0);
    ivec4 ARi = ivec4(0);
    bool predResult = true;
    R0f = passParameterSem0;
    vec3 _64 = texture(textureUnitPS0, R0f.xy).xyz;
    R1f.x = _64.x;
    R1f.y = _64.y;
    R1f.z = _64.z;
    vec4 _77 = R0f;
    vec3 _80 = texture(textureUnitPS1, _77.xy).xyz;
    R0f.x = _80.x;
    R0f.y = _80.y;
    R0f.z = _80.z;
    R126f.x = R1f.x + R0f.x;
    PV0f.x = R126f.x;
    R127f.y = R1f.y + R0f.y;
    PV0f.y = R127f.y;
    R126f.z = R1f.z + R0f.z;
    PV0f.z = R126f.z;
    R125f.w = 1.0;
    tempf.x = dot(vec4(PV0f.x, PV0f.y, PV0f.z, -0.0), vec4(intBitsToFloat(1050216812), intBitsToFloat(1058417515), intBitsToFloat(1038764684), 0.0));
    PV1f.x = tempf.x;
    PV1f.y = tempf.x;
    PV1f.z = tempf.x;
    PV1f.w = tempf.x;
    R127f.x = (-R127f.y) * intBitsToFloat(1069066811);
    PV0f.y = (-PV1f.x) * intBitsToFloat(1069066811);
    R127f.z = (-R126f.x) * intBitsToFloat(1069066811);
    R127f.w = (-R126f.z) * intBitsToFloat(1069066811);
    R126f.w = 1.0 / PV1f.x;
    PS0f = R126f.w;
    PS1f = exp2(PV0f.y);
    PV0f.x = (-PS1f) + 1.0;
    PS0f = exp2(R127f.x);
    R127f.x = (-PS0f) + 1.0;
    float param = PV0f.x;
    float param_1 = PV0f.x;
    R126f.y = mul_nonIEEE(param, param_1);
    PV1f.z = PV0f.x * R126f.w;
    PS1f = exp2(R127f.w);
    float backupReg0f = R126f.x;
    float backupReg1f = R127f.z;
    float param_2 = backupReg0f;
    float param_3 = PV1f.z;
    R126f.x = mul_nonIEEE(param_2, param_3);
    PV0f.y = (-PS1f) + 1.0;
    float param_4 = R126f.z;
    float param_5 = PV1f.z;
    R127f.z = mul_nonIEEE(param_4, param_5);
    PV0f.z = R127f.z;
    float param_6 = R127f.y;
    float param_7 = PV1f.z;
    R127f.w = mul_nonIEEE(param_6, param_7);
    PV0f.w = R127f.w;
    PS0f = exp2(backupReg1f);
    PV1f.x = R127f.x + (-PV0f.w);
    PV1f.y = PV0f.y + (-PV0f.z);
    PV1f.w = (-PS0f) + 1.0;
    backupReg0f = R127f.z;
    float param_8 = PV1f.x;
    float param_9 = R126f.y;
    R127f.x = mul_nonIEEE(param_8, param_9) + R127f.w;
    R127f.x = clamp(R127f.x, 0.0, 1.0);
    PV0f.x = R127f.x;
    PV0f.y = PV1f.w + (-R126f.x);
    float param_10 = PV1f.y;
    float param_11 = R126f.y;
    R127f.z = mul_nonIEEE(param_10, param_11) + backupReg0f;
    R127f.z = clamp(R127f.z, 0.0, 1.0);
    PV0f.z = R127f.z;
    backupReg0f = R126f.x;
    float param_12 = PV0f.y;
    float param_13 = R126f.y;
    R126f.x = mul_nonIEEE(param_12, param_13) + backupReg0f;
    R126f.x = clamp(R126f.x, 0.0, 1.0);
    PV1f.x = R126f.x;
    PV1f.w = max(PV0f.x, PV0f.z);
    tempf.x = dot(vec4(PV1f.x, R127f.x, R127f.z, R125f.w), vec4(intBitsToFloat(1059760811), intBitsToFloat(1059760811), intBitsToFloat(1059760811), -1.0));
    PV0f.x = tempf.x;
    PV0f.y = tempf.x;
    PV0f.z = tempf.x;
    PV0f.w = tempf.x;
    R126f.z = max(PV1f.x, PV1f.w);
    PS0f = R126f.z;
    backupReg0f = R127f.x;
    backupReg1f = R127f.z;
    R127f.x = R126f.x + (-PS0f);
    float param_14 = -PV0f.x;
    float param_15 = PV0f.x;
    R123f.y = mul_nonIEEE(param_14, param_15) + 1.0;
    PV1f.y = R123f.y;
    R127f.z = backupReg0f + (-PS0f);
    R125f.w = backupReg1f + (-PS0f);
    float param_16 = PV1f.y;
    float param_17 = intBitsToFloat(_409.uf_remappedPS[0].y);
    R123f.x = mul_nonIEEE(param_16, param_17) + intBitsToFloat(_409.uf_remappedPS[0].x);
    PV0f.x = R123f.x;
    float param_18 = R127f.x;
    float param_19 = PV0f.x;
    R0f.x = mul_nonIEEE(param_18, param_19) + R126f.z;
    float param_20 = R127f.z;
    float param_21 = PV0f.x;
    R0f.y = mul_nonIEEE(param_20, param_21) + R126f.z;
    float param_22 = R125f.w;
    float param_23 = PV0f.x;
    R0f.z = mul_nonIEEE(param_22, param_23) + R126f.z;

    float3 tonemapped = R0f.xyz;
    float3 untonemapped = float3(_64 + _80);
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
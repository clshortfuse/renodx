#include "../cp2077/composite.hlsl"

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
    SPIRV_Cross_Output stage_output;
    float4 outputColor = float4(composite().rgb, 1.f);
    // R11G11B10_FLOAT LUT
    outputColor.r = asfloat(asuint(outputColor.r) + 65536u);
    outputColor.g = asfloat(asuint(outputColor.g) + 65536u);
    outputColor.b = asfloat(asuint(outputColor.b) + 131072u);

    stage_output.SV_Target = outputColor;
    return stage_output;
}

#include "./shared.h"

static float4 COLOR;
static float4 TEXCOORD;
static float4 POSITION;
static float4 SV_Position0;
static uint4 ID_VALUE;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float4 POSITION : POSITION;
    float4 SV_Position : SV_Position;
    float4 COLOR : COLOR;
    float4 TEXCOORD : TEXCOORD;
    uint4 ID_VALUE : ID_VALUE;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target;
};

float dp2_f32(float2 a, float2 b)
{
    precise float _26 = a.x * b.x;
    return mad(a.y, b.y, _26);
}

void frag_main()
{
    float2 _41 = float2(TEXCOORD.x - 0.5f, TEXCOORD.y - 0.5f);
    float _43 = sqrt(dp2_f32(_41, _41));
    float _53 = (COLOR.w * 0.5f) * exp2(log2(1.0f - min(_43 + _43, 1.0f)) * 1.5f);

    _53 *= CUSTOM_BLOOM;

    SV_Target.x = _53 * COLOR.x;
    SV_Target.y = _53 * COLOR.y;
    SV_Target.z = _53 * COLOR.z;
    SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    POSITION = stage_input.POSITION;
    SV_Position0 = stage_input.SV_Position;
    COLOR = stage_input.COLOR;
    TEXCOORD = stage_input.TEXCOORD;
    ID_VALUE = stage_input.ID_VALUE;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}

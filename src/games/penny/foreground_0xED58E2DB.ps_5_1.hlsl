#include "./common.hlsl"

Texture2D<float4> T0[256] : register(t0, space0);

static float4 SV_Position0;
static float4 NOISE;
static float2 OFFSET;
static uint ID_VALUE;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float4 SV_Position : SV_Position;
    float4 NOISE : NOISE;
    float2 OFFSET : OFFSET;
    nointerpolation uint ID_VALUE : ID_VALUE;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target;
};

int cvt_f32_i32(float v)
{
    return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp3_f32(float3 a, float3 b)
{
    precise float _56 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _56));
}

float dp2_f32(float2 a, float2 b)
{
    precise float _43 = a.x * b.x;
    return mad(a.y, b.y, _43);
}

void frag_main()
{
    float4 _95 = T0[NonUniformResourceIndex(ID_VALUE)].Load(int3(uint2(uint(cvt_f32_i32(SV_Position0.x)), uint(cvt_f32_i32(SV_Position0.y))), 0u));
    float _101 = floor(NOISE.z);
    float _109 = frac(NOISE.x * 0.103100001811981201171875f);
    float _110 = frac(NOISE.y * 0.103100001811981201171875f);
    float _111 = frac(_101 * 0.103100001811981201171875f);
    float _113 = _110 + 31.31999969482421875f;
    float _114 = _109 + 31.31999969482421875f;
    float _117 = dp3_f32(float3(_109, _110, _111), float3(_111 + 31.31999969482421875f, _113, _114));
    float _123 = frac(((_109 + _117) + (_110 + _117)) * (_111 + _117));
    float _126 = frac((_101 + 1.0f) * 0.103100001811981201171875f);
    float _130 = dp3_f32(float3(_109, _110, _126), float3(_126 + 31.31999969482421875f, _113, _114));
    float _140 = mad(frac(NOISE.z), frac(((_109 + _130) + (_110 + _130)) * (_130 + _126)) - _123, _123) * 0.03125f;
    float2 _145 = float2(OFFSET.x, OFFSET.y);
    float _146 = dp2_f32(_145, _145);
    SV_Target.x = mad(-_140, _146, _95.x);
    SV_Target.y = mad(-_140, _146, _95.y);
    SV_Target.z = mad(-_140, _146, _95.z);
    SV_Target.w = 1.0f;

    SV_Target.xyz = CustomTonemap(SV_Target.xyz);

}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    SV_Position0 = stage_input.SV_Position;
    SV_Position0.w = 1.0 / SV_Position0.w;
    NOISE = stage_input.NOISE;
    OFFSET = stage_input.OFFSET;
    ID_VALUE = stage_input.ID_VALUE;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}

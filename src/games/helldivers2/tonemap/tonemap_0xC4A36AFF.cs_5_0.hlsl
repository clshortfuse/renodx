#include "../common.hlsl"
struct _346
{
    uint2 _m0;
    uint _m1;
};

struct _1992
{
    uint3 _m0;
    uint _m1;
};

static const float _2126[30] = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
static const float _64[10][30] = { { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f } };
static const float _69[1] = { 0.0f };
static const float4 _275[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

cbuffer cb0_buf : register(b0)
{
    uint4 cb0_m[44] : packoffset(c0);
};

cbuffer cb1_buf : register(b1)
{
    float4 cb1_m0 : packoffset(c0);
    uint4 cb1_m1 : packoffset(c1);
    float4 cb1_m2 : packoffset(c2);
    float4 cb1_m3 : packoffset(c3);
    float3 cb1_m4 : packoffset(c4);
    uint cb1_m5 : packoffset(c4.w);
    float4 cb1_m6 : packoffset(c5);
    float4 cb1_m7 : packoffset(c6);
    float2 cb1_m8 : packoffset(c7);
    float2 cb1_m9 : packoffset(c7.z);
    uint4 cb1_m10 : packoffset(c8);
    uint4 cb1_m11 : packoffset(c9);
    uint4 cb1_m12 : packoffset(c10);
    uint4 cb1_m13 : packoffset(c11);
    uint4 cb1_m14 : packoffset(c12);
    uint4 cb1_m15 : packoffset(c13);
    uint4 cb1_m16 : packoffset(c14);
    uint4 cb1_m17 : packoffset(c15);
    uint4 cb1_m18 : packoffset(c16);
    uint4 cb1_m19 : packoffset(c17);
    float cb1_m20 : packoffset(c18);
    float2 cb1_m21 : packoffset(c18.y);
    float cb1_m22 : packoffset(c18.w);
    float4 cb1_m23 : packoffset(c19);
};

SamplerState s0 : register(s0);
SamplerState s1 : register(s1);
SamplerState s2 : register(s2);
SamplerState s3 : register(s3);
SamplerState s4 : register(s4);
SamplerState s5 : register(s5);
SamplerState s6 : register(s6);
SamplerState s7 : register(s7);
SamplerState s8 : register(s8);
SamplerState s9 : register(s9);
Buffer<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t9 : register(t9);
Texture2D<float4> t10 : register(t10);
Texture3D<float4> t11 : register(t11);
Buffer<float4> t12 : register(t12);
Buffer<float4> t13 : register(t13);
RWTexture2D<float4> u0 : register(u0);
RWTexture2D<float4> u1 : register(u1);
RWTexture2D<float4> u2 : register(u2);

static uint3 gl_LocalInvocationID;
static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

groupshared float g0[10][30];
groupshared float g1[1];



uint3 spvTextureSize(Texture3D<float4> Tex, uint Level, out uint Param)
{
    uint3 ret;
    Tex.GetDimensions(Level, ret.x, ret.y, ret.z, Param);
    return ret;
}

uint2 spvImageSize(RWTexture2D<float4> Tex, out uint Param)
{
    uint2 ret;
    Tex.GetDimensions(ret.x, ret.y);
    Param = 0u;
    return ret;
}

uint spvBitfieldInsert(uint Base, uint Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint2 spvBitfieldInsert(uint2 Base, uint2 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint3 spvBitfieldInsert(uint3 Base, uint3 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint4 spvBitfieldInsert(uint4 Base, uint4 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
    return (Base >> Offset) & Mask;
}

uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
    return (Base >> Offset) & Mask;
}

uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
    return (Base >> Offset) & Mask;
}

uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
    return (Base >> Offset) & Mask;
}

int spvBitfieldSExtract(int Base, int Offset, int Count)
{
    int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
    int Masked = (Base >> Offset) & Mask;
    int ExtendShift = (32 - Count) & 31;
    return (Masked << ExtendShift) >> ExtendShift;
}

int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
{
    int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
    int2 Masked = (Base >> Offset) & Mask;
    int ExtendShift = (32 - Count) & 31;
    return (Masked << ExtendShift) >> ExtendShift;
}

int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
{
    int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
    int3 Masked = (Base >> Offset) & Mask;
    int ExtendShift = (32 - Count) & 31;
    return (Masked << ExtendShift) >> ExtendShift;
}

int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
{
    int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
    int4 Masked = (Base >> Offset) & Mask;
    int ExtendShift = (32 - Count) & 31;
    return (Masked << ExtendShift) >> ExtendShift;
}

float dp2_f32(float2 a, float2 b)
{
    precise float _337 = a.x * b.x;
    return mad(a.y, b.y, _337);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _323 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _323));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _305 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _305)));
}

void comp_main()
{
    uint _345_dummy_parameter;
    _346 _347 = { spvImageSize(u0, _345_dummy_parameter), 1u };
    uint _359 = gl_GlobalInvocationID.x - gl_LocalInvocationID.x;
    uint _360 = gl_GlobalInvocationID.y - gl_LocalInvocationID.y;
    uint _362 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _363 = spvBitfieldUExtract(_362, 1u, 3u);
    uint _365 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _362, 0u, 1u);
    uint _366 = _359 + _363;
    uint _367 = _365 + _360;
    float _372 = float(_347._m0.x);
    float _373 = float(_347._m0.y);
    float _374 = (float(_366) + 0.5f) / _372;
    float _375 = (float(_367) + 0.5f) / _373;
    bool _384 = cb1_m3.y == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _384) && (gl_LocalInvocationID.y == 0u))
    {
        g1[0u] = t8.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    if (_362 < 36u)
    {
        bool _412 = _362 < 4u;
        bool _413 = _362 < 12u;
        bool _414 = _362 < 20u;
        bool _415 = _362 < 28u;
        uint _426 = _412 ? ((_362 >> 1u) * 9u) : (_413 ? 0u : (_414 ? 9u : (_415 ? (((_362 - 20u) & 7u) + 1u) : (((_362 - 28u) & 7u) + 1u))));
        uint _427 = _412 ? ((_362 & 1u) * 9u) : (_413 ? (((_362 - 4u) & 7u) + 1u) : (_414 ? (((_362 - 12u) & 7u) + 1u) : (_415 ? 0u : 9u)));
        float _428 = 1.0f / _372;
        float _429 = 1.0f / _373;
        float _448 = clamp((_428 * (float(int(_426 - 1u)) + 0.5f)) + (_428 * float(int(_359))), 0.0f, 1.0f);
        float _449 = clamp(((float(int(_427 - 1u)) + 0.5f) * _429) + (float(int(_360)) * _429), 0.0f, 1.0f);
        float2 _452 = float2(_448, _449);
        float _457 = mad(t6.SampleLevel(s5, _452, 0.0f).x, 2.0f, -1.0f);
        float _472;
        if (_457 > 0.0f)
        {
            _472 = min(sqrt(_457), t0.Load(8u).x);
        }
        else
        {
            _472 = max(_457, -t0.Load(7u).x);
        }
        float4 _476 = t5.SampleLevel(s4, _452, 0.0f);
        float2 _486 = float2(_476.x * cb1_m2.z, _476.y * cb1_m2.w);
        bool _499 = (cb1_m9.x != 0.0f) && (cb1_m9.y != 0.0f);
        bool _503 = (cb1_m7.w != 0.0f) && (cb1_m8.x != 0.0f);
        float _515 = exp2(max(_499 ? clamp((sqrt(dp2_f32(_486, _486)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _503 ? clamp((abs(_472) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float _517 = _448 - 0.5f;
        float _518 = _449 - 0.5f;
        float2 _519 = float2(_517, _518);
        float _523 = mad(cb1_m20, dp2_f32(_519, _519), 1.0f);
        float _545 = mad(exp2(log2(clamp(cb1_m20, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(cb1_m21.x, -0.089999973773956298828125f, 1.0f);
        float _546 = (_523 * mad(mad(cb1_m21.y, -0.001999996602535247802734375f, 0.092000000178813934326171875f), cb1_m21.x, 1.0f)) * _545;
        float _547 = _545 * (_523 * mad(mad(cb1_m21.y, 0.04500000178813934326171875f, 0.046999998390674591064453125f), cb1_m21.x, 1.0f));
        float _548 = _545 * (_523 * mad(mad(cb1_m21.y, 0.0f, 0.04500000178813934326171875f), cb1_m21.x, 1.0f));
        float _549 = mad(_517, _546, 0.5f);
        float _550 = mad(_546, _518, 0.5f);
        float _551 = mad(_517, _547, 0.5f);
        float _552 = mad(_547, _518, 0.5f);
        float2 _555 = float2(_549, _550);
        float4 _557 = t1.SampleLevel(s0, _555, 0.0f);
        float _558 = _557.x;
        bool _559 = _503 || _499;
        float _593;
        if (_559)
        {
            float4 _565 = t2.SampleLevel(s1, _555, 0.0f);
            float _566 = _565.x;
            float _574 = asfloat(cb0_m[43u].w) * 20.0f;
            float _590 = mad(mad(t9.SampleLevel(s7, float2(mad(_549, 30.0f, sin(_574)), mad(_550, 30.0f, cos(_574))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_566, max(_565.y, _565.z)), 1.0000000133514319600180897396058e-10f)), _566);
            _593 = mad(_515, _558 - _590, _590);
        }
        else
        {
            _593 = _558;
        }
        float2 _594 = float2(_551, _552);
        float4 _596 = t1.SampleLevel(s0, _594, 0.0f);
        float _597 = _596.y;
        float _630;
        if (_559)
        {
            float4 _603 = t2.SampleLevel(s1, _594, 0.0f);
            float _605 = _603.y;
            float _611 = asfloat(cb0_m[43u].w) * 20.0f;
            float _627 = mad(mad(t9.SampleLevel(s7, float2(mad(_551, 30.0f, sin(_611)), mad(_552, 30.0f, cos(_611))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_603.x, max(_605, _603.z)), 1.0000000133514319600180897396058e-10f)), _605);
            _630 = mad(_515, _597 - _627, _627);
        }
        else
        {
            _630 = _597;
        }
        float _631 = mad(_517, _548, 0.5f);
        float _632 = mad(_548, _518, 0.5f);
        float2 _633 = float2(_631, _632);
        float4 _635 = t1.SampleLevel(s0, _633, 0.0f);
        float _636 = _635.z;
        float _669;
        if (_559)
        {
            float4 _642 = t2.SampleLevel(s1, _633, 0.0f);
            float _645 = _642.z;
            float _650 = asfloat(cb0_m[43u].w) * 20.0f;
            float _666 = mad(mad(t9.SampleLevel(s7, float2(mad(_631, 30.0f, sin(_650)), mad(_632, 30.0f, cos(_650))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_642.x, max(_642.y, _645)), 1.0000000133514319600180897396058e-10f)), _645);
            _669 = mad(_515, _636 - _666, _666);
        }
        else
        {
            _669 = _636;
        }
        float _674 = _384 ? g1[0u] : cb1_m3.x;
        float4 _678 = t7.SampleLevel(s6, _452, 0.0f);
        float _679 = _678.x;
        float _687 = max(cb1_m3.w - dp3_f32(float3(_679, _678.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
        float _691 = mad(_593, _674, _679 / _687);
        float _692 = mad(_630, _674, _678.y / _687);
        float _693 = mad(_669, _674, _678.z / _687);
        float _697 = 1.0f / (max(_691, max(_693, _692)) + 1.0f);
        float _698 = _691 * _697;
        float _700 = _697 * _693;
        float3 _701 = float3(_698, _700, _697 * _692);
        uint _706 = (_427 * 12u) >> 2u;
        g0[_426][_706] = dp3_f32(_701, float3(0.25f, 0.25f, 0.5f));
        uint _709 = _706 + 1u;
        g0[_426][_709] = dp2_f32(float2(_698, _700), float2(0.5f, -0.5f));
        uint _712 = _706 + 2u;
        g0[_426][_712] = dp3_f32(_701, float3(-0.25f, -0.25f, 0.5f));
    }
    float2 _717 = float2(_374, _375);
    float _721 = mad(t6.SampleLevel(s5, _717, 0.0f).x, 2.0f, -1.0f);
    float _736;
    if (_721 > 0.0f)
    {
        _736 = min(sqrt(_721), t0.Load(8u).x);
    }
    else
    {
        _736 = max(_721, -t0.Load(7u).x);
    }
    float4 _740 = t5.SampleLevel(s4, _717, 0.0f);
    float _741 = _740.x;
    float _742 = _740.y;
    float2 _753 = float2(_741 * cb1_m2.z, _742 * cb1_m2.w);
    bool _765 = (cb1_m9.x != 0.0f) && (cb1_m9.y != 0.0f);
    bool _769 = (cb1_m7.w != 0.0f) && (cb1_m8.x != 0.0f);
    float _773 = abs(_736);
    float _781 = exp2(max(_765 ? clamp((sqrt(dp2_f32(_753, _753)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _769 ? clamp((_773 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _782 = _374 - 0.5f;
    float _783 = _375 - 0.5f;
    float2 _784 = float2(_782, _783);
    float _785 = dp2_f32(_784, _784);
    float _788 = mad(cb1_m20, _785, 1.0f);
    float _810 = mad(exp2(log2(clamp(cb1_m20, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(cb1_m21.x, -0.089999973773956298828125f, 1.0f);
    float _811 = (_788 * mad(mad(cb1_m21.y, -0.001999996602535247802734375f, 0.092000000178813934326171875f), cb1_m21.x, 1.0f)) * _810;
    float _812 = _810 * (_788 * mad(cb1_m21.x, mad(cb1_m21.y, 0.04500000178813934326171875f, 0.046999998390674591064453125f), 1.0f));
    float _813 = _810 * (_788 * mad(cb1_m21.x, mad(cb1_m21.y, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _814 = mad(_782, _811, 0.5f);
    float _815 = mad(_811, _783, 0.5f);
    float _816 = mad(_782, _812, 0.5f);
    float _817 = mad(_812, _783, 0.5f);
    float2 _820 = float2(_814, _815);
    float4 _822 = t1.SampleLevel(s0, _820, 0.0f);
    float _823 = _822.x;
    bool _824 = _769 || _765;
    float _857;
    if (_824)
    {
        float4 _830 = t2.SampleLevel(s1, _820, 0.0f);
        float _831 = _830.x;
        float _838 = asfloat(cb0_m[43u].w) * 20.0f;
        float _854 = mad(mad(t9.SampleLevel(s7, float2(mad(_814, 30.0f, sin(_838)), mad(_815, 30.0f, cos(_838))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_831, max(_830.y, _830.z)), 1.0000000133514319600180897396058e-10f)), _831);
        _857 = mad(_781, _823 - _854, _854);
    }
    else
    {
        _857 = _823;
    }
    float2 _858 = float2(_816, _817);
    float4 _860 = t1.SampleLevel(s0, _858, 0.0f);
    float _861 = _860.y;
    float _894;
    if (_824)
    {
        float4 _867 = t2.SampleLevel(s1, _858, 0.0f);
        float _869 = _867.y;
        float _875 = asfloat(cb0_m[43u].w) * 20.0f;
        float _891 = mad(mad(t9.SampleLevel(s7, float2(mad(_816, 30.0f, sin(_875)), mad(_817, 30.0f, cos(_875))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_867.x, max(_869, _867.z)), 1.0000000133514319600180897396058e-10f)), _869);
        _894 = mad(_781, _861 - _891, _891);
    }
    else
    {
        _894 = _861;
    }
    float _895 = mad(_782, _813, 0.5f);
    float _896 = mad(_813, _783, 0.5f);
    float2 _897 = float2(_895, _896);
    float4 _899 = t1.SampleLevel(s0, _897, 0.0f);
    float _900 = _899.z;
    float _933;
    if (_824)
    {
        float4 _906 = t2.SampleLevel(s1, _897, 0.0f);
        float _909 = _906.z;
        float _914 = asfloat(cb0_m[43u].w) * 20.0f;
        float _930 = mad(mad(t9.SampleLevel(s7, float2(mad(_895, 30.0f, sin(_914)), mad(_896, 30.0f, cos(_914))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_906.x, max(_906.y, _909)), 1.0000000133514319600180897396058e-10f)), _909);
        _933 = mad(_781, _900 - _930, _930);
    }
    else
    {
        _933 = _900;
    }
    float _938 = _384 ? g1[0u] : cb1_m3.x;
    float4 _942 = t7.SampleLevel(s6, _717, 0.0f);
    float _943 = _942.x;
    float _951 = max(cb1_m3.w - dp3_f32(float3(_943, _942.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _955 = mad(_857, _938, _943 / _951);
    float _956 = mad(_894, _938, _942.y / _951);
    float _957 = mad(_933, _938, _942.z / _951);
    float _961 = 1.0f / (max(_955, max(_957, _956)) + 1.0f);
    float _962 = _955 * _961;
    float _964 = _957 * _961;
    float3 _965 = float3(_962, _964, _956 * _961);
    float _966 = dp3_f32(_965, float3(0.25f, 0.25f, 0.5f));
    float _967 = dp3_f32(_965, float3(-0.25f, -0.25f, 0.5f));
    float _969 = dp2_f32(float2(_962, _964), float2(0.5f, -0.5f));
    uint _970 = _363 + 1u;
    uint _971 = _363 + 2u;
    uint _972 = _365 * 12u;
    uint _975 = (_972 + 12u) >> 2u;
    g0[_970][_975] = _966;
    uint _978 = _975 + 1u;
    g0[_970][_978] = _969;
    uint _981 = _975 + 2u;
    g0[_970][_981] = _967;
    float2 _984 = float2(_741 * cb1_m2.x, _742 * cb1_m2.y);
    float _988 = min(sqrt(dp2_f32(_984, _984)) * 0.07500000298023223876953125f, 1.0f);
    float _989 = _374 - _741;
    float _990 = _375 - _742;
    float _998 = (max(abs(mad(_990, 2.0f, -1.0f)), abs(mad(_989, 2.0f, -1.0f))) >= 1.0f) ? (-_988) : _988;
    float _1005 = floor(mad(_989, cb1_m2.x, -0.5f));
    float _1006 = floor(mad(_990, cb1_m2.y, -0.5f));
    float _1007 = _1005 + 0.5f;
    float _1008 = _1006 + 0.5f;
    float _1012 = mad(_989, cb1_m2.x, -_1007);
    float _1014 = mad(_990, cb1_m2.y, -_1008);
    float _1016 = mad(-_989, cb1_m2.x, _1007);
    float _1018 = mad(-_990, cb1_m2.y, _1008);
    float _1025 = mad(_1012, mad(_1016, 1.5f, 2.0f), 0.5f);
    float _1026 = mad(mad(_1018, 1.5f, 2.0f), _1014, 0.5f);
    float _1027 = _1012 * _1012;
    float _1028 = _1014 * _1014;
    float _1033 = _1027 * mad(_1012, 0.5f, -0.5f);
    float _1034 = mad(_1014, 0.5f, -0.5f) * _1028;
    float _1037 = _1012 * mad(_1012, mad(_1016, 0.5f, 1.0f), -0.5f);
    float _1038 = mad(mad(_1018, 0.5f, 1.0f), _1014, -0.5f) * _1014;
    float _1041 = mad(_1012, _1025, mad(_1027, mad(_1012, 1.5f, -2.5f), 1.0f));
    float _1042 = mad(_1026, _1014, mad(mad(_1014, 1.5f, -2.5f), _1028, 1.0f));
    float _1049 = (_1005 - 0.5f) / cb1_m2.x;
    float _1050 = (_1006 - 0.5f) / cb1_m2.y;
    float _1051 = (_1005 + 2.5f) / cb1_m2.x;
    float _1052 = (_1006 + 2.5f) / cb1_m2.y;
    float _1053 = (((_1026 * _1014) / _1042) + _1008) / cb1_m2.y;
    float _1054 = (_1007 + ((_1012 * _1025) / _1041)) / cb1_m2.x;
    float4 _1059 = t3.SampleLevel(s2, float2(_1049, _1050), 0.0f);
    float4 _1068 = t3.SampleLevel(s2, float2(_1051, _1050), 0.0f);
    float4 _1086 = t3.SampleLevel(s2, float2(_1054, _1050), 0.0f);
    float4 _1098 = t3.SampleLevel(s2, float2(_1049, _1053), 0.0f);
    float4 _1110 = t3.SampleLevel(s2, float2(_1054, _1053), 0.0f);
    float4 _1122 = t3.SampleLevel(s2, float2(_1051, _1053), 0.0f);
    float4 _1134 = t3.SampleLevel(s2, float2(_1049, _1052), 0.0f);
    float4 _1146 = t3.SampleLevel(s2, float2(_1054, _1052), 0.0f);
    float4 _1158 = t3.SampleLevel(s2, float2(_1051, _1052), 0.0f);
    float _1165 = mad(_1033 * _1158.x, _1034, mad(_1041 * _1146.x, _1034, mad(_1037 * _1134.x, _1034, mad(_1033 * _1122.x, _1042, mad(_1041 * _1110.x, _1042, mad(_1037 * _1098.x, _1042, mad(_1041 * _1086.x, _1038, ((_1033 * _1068.x) * _1038) + ((_1037 * _1059.x) * _1038))))))));
    float _1167 = mad(_1033 * _1158.z, _1034, mad(_1041 * _1146.z, _1034, mad(_1037 * _1134.z, _1034, mad(_1033 * _1122.z, _1042, mad(_1041 * _1110.z, _1042, mad(_1037 * _1098.z, _1042, mad(_1041 * _1086.z, _1038, ((_1037 * _1059.z) * _1038) + ((_1033 * _1068.z) * _1038))))))));
    float3 _1168 = float3(_1165, _1167, mad(_1033 * _1158.y, _1034, mad(_1041 * _1146.y, _1034, mad(_1037 * _1134.y, _1034, mad(_1033 * _1122.y, _1042, mad(_1041 * _1110.y, _1042, mad(_1037 * _1098.y, _1042, mad(_1041 * _1086.y, _1038, ((_1037 * _1059.y) * _1038) + ((_1033 * _1068.y) * _1038)))))))));
    float _1169 = dp3_f32(_1168, float3(0.25f, 0.25f, 0.5f));
    float _1170 = dp3_f32(_1168, float3(-0.25f, -0.25f, 0.5f));
    float _1172 = dp2_f32(float2(_1165, _1167), float2(0.5f, -0.5f));
    GroupMemoryBarrierWithGroupSync();
    uint _1173 = _972 >> 2u;
    uint _1177 = _1173 + 1u;
    uint _1181 = _1173 + 2u;
    uint _1267 = (_972 + 24u) >> 2u;
    uint _1271 = _1267 + 1u;
    uint _1275 = _1267 + 2u;
    float _1296 = min(min(min(min(_966, g0[_970][_1173]), g0[_363][_975]), g0[_971][_975]), g0[_970][_1267]);
    float _1297 = max(max(max(max(_966, g0[_970][_1173]), g0[_363][_975]), g0[_971][_975]), g0[_970][_1267]);
    float _1315 = (((((((_966 + g0[_970][_1173]) + g0[_363][_1173]) + g0[_363][_975]) + g0[_971][_1173]) + g0[_971][_975]) + g0[_363][_1267]) + g0[_970][_1267]) + g0[_971][_1267];
    float _1329 = _1315 * 0.111111111938953399658203125f;
    float _1330 = (g0[_971][_1271] + (g0[_970][_1271] + (g0[_363][_1271] + (g0[_971][_978] + (g0[_971][_1177] + (g0[_363][_978] + (g0[_363][_1177] + (_969 + g0[_970][_1177])))))))) * 0.111111111938953399658203125f;
    float _1331 = (g0[_971][_1275] + (g0[_970][_1275] + (g0[_363][_1275] + (g0[_971][_981] + (g0[_971][_1181] + (g0[_363][_981] + (g0[_363][_1181] + (_967 + g0[_970][_1181])))))))) * 0.111111111938953399658203125f;
    float _1350 = mad(_1169 / max(mad(_1315, 0.111111111938953399658203125f, _1169), 1.0000000116860974230803549289703e-07f), 0.5f, 0.75f);
    float _1351 = sqrt(max((mad(g0[_971][_1267], g0[_971][_1267], mad(g0[_970][_1267], g0[_970][_1267], mad(g0[_363][_1267], g0[_363][_1267], mad(g0[_971][_975], g0[_971][_975], mad(g0[_971][_1173], g0[_971][_1173], mad(g0[_363][_975], g0[_363][_975], mad(g0[_363][_1173], g0[_363][_1173], (g0[_970][_1173] * g0[_970][_1173]) + (_966 * _966)))))))) * 0.111111111938953399658203125f) - (_1329 * _1329), 1.0000000133514319600180897396058e-10f)) * _1350;
    float _1352 = _1350 * sqrt(max((mad(g0[_971][_1271], g0[_971][_1271], mad(g0[_970][_1271], g0[_970][_1271], mad(g0[_363][_1271], g0[_363][_1271], mad(g0[_971][_978], g0[_971][_978], mad(g0[_971][_1177], g0[_971][_1177], mad(g0[_363][_978], g0[_363][_978], mad(g0[_363][_1177], g0[_363][_1177], (_969 * _969) + (g0[_970][_1177] * g0[_970][_1177])))))))) * 0.111111111938953399658203125f) - (_1330 * _1330), 1.0000000133514319600180897396058e-10f));
    float _1353 = _1350 * sqrt(max((mad(g0[_971][_1275], g0[_971][_1275], mad(g0[_970][_1275], g0[_970][_1275], mad(g0[_363][_1275], g0[_363][_1275], mad(g0[_971][_981], g0[_971][_981], mad(g0[_971][_1181], g0[_971][_1181], mad(g0[_363][_981], g0[_363][_981], mad(g0[_363][_1181], g0[_363][_1181], (_967 * _967) + (g0[_970][_1181] * g0[_970][_1181])))))))) * 0.111111111938953399658203125f) - (_1331 * _1331), 1.0000000133514319600180897396058e-10f));
    float _1357 = _1329 + _1351;
    float _1358 = _1352 + _1330;
    float _1359 = _1353 + _1331;
    float _1360 = (_1329 - _1351) + _1357;
    float _1361 = _1358 + (_1330 - _1352);
    float _1362 = _1359 + (_1331 - _1353);
    float _1372 = mad(_1360, -0.5f, _1169);
    float _1373 = mad(_1361, -0.5f, _1172);
    float _1374 = mad(_1362, -0.5f, _1170);
    float _1382 = max(max(abs(_1373 / mad((_1352 - _1330) + _1358, 0.5f, 9.9999997473787516355514526367188e-05f)), abs(_1372 / mad(_1357 + (_1351 - _1329), 0.5f, 9.9999997473787516355514526367188e-05f))), abs(_1374 / mad((_1353 - _1331) + _1359, 0.5f, 9.9999997473787516355514526367188e-05f)));
    bool _1383 = _1382 > 1.0f;
    uint2 _1401 = uint2(_366, _367);
    float _1405 = max((_1169 / ((_1169 + (mad(_1297, 0.5f, max(_1297 * 0.5f, max(max(max(max(_966, g0[_363][_1173]), g0[_971][_1173]), g0[_363][_1267]), g0[_971][_1267]) * 0.5f)) - mad(_1296, 0.5f, min(_1296 * 0.5f, min(min(min(min(_966, g0[_363][_1173]), g0[_971][_1173]), g0[_363][_1267]), g0[_971][_1267]) * 0.5f)))) + 1.0000000116860974230803549289703e-07f)) * mad(abs(_998), 0.85000002384185791015625f, 0.100000001490116119384765625f), u2[_1401].x * 0.75f);
    bool _1406 = _998 < 0.0f;
    float _1407 = _1406 ? _966 : (_1383 ? mad(_1360, 0.5f, _1372 / _1382) : _1169);
    float _1408 = _1406 ? _969 : (_1383 ? mad(_1361, 0.5f, _1373 / _1382) : _1172);
    float _1409 = _1406 ? _967 : (_1383 ? mad(_1362, 0.5f, _1374 / _1382) : _1170);
    float _1417 = clamp(mad(t4.SampleLevel(s3, _717, 0.0f).y, 1.0f - _1405, _1405), 0.0039215688593685626983642578125f, 0.949999988079071044921875f);
    float _1421 = mad(cb1_m0.x, 1.0f - _1417, _1417);
    float _1425 = mad(_1421, _966 - _1407, _1407);
    float _1426 = mad(_1421, _969 - _1408, _1408);
    float _1427 = mad(_1421, _967 - _1409, _1409);
    float _1428 = _1425 - _1427;
    float _1429 = _1428 + _1426;
    float _1430 = _1425 + _1427;
    float _1431 = _1428 - _1426;
    u1[_1401] = float4(_1429, _1430, _1431, 0.0f);
    u2[_1401] = _1421.xxxx;
    if (!((_347._m0.x < _366) || (_347._m0.y < _367)))
    {
        float _1439 = dp3_f32(float3(_1429, _1430, _1431), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1446 = cb1_m7.x * mad(-_773, cb1_m8.y, 1.0f);
        float _1450 = mad(_1446, _1429 - _1439, _1439);
        float _1451 = mad(_1446, _1430 - _1439, _1439);
        float _1452 = mad(_1446, _1431 - _1439, _1439);
        float _1453 = _783 + _783;
        float _1454 = _782 + _782;
        float _1455 = abs(_1454);
        float _1456 = abs(_1453);
        float _1460 = min(_1455, _1456) * (1.0f / max(_1455, _1456));
        float _1461 = _1460 * _1460;
        float _1465 = mad(_1461, mad(_1461, mad(_1461, mad(_1461, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1474 = mad(_1460, _1465, (_1455 < _1456) ? mad(_1460 * _1465, -2.0f, 1.57079637050628662109375f) : 0.0f) + (((-_1454) > _1454) ? (-3.1415927410125732421875f) : 0.0f);
        float _1475 = min(_1453, _1454);
        float _1476 = max(_1453, _1454);
        float _1483 = ((_1475 < (-_1475)) && (_1476 >= (-_1476))) ? (-_1474) : _1474;
        float4 _1487 = t10.SampleLevel(s8, _717, 0.0f);
        float _1488 = _1487.x;
        float _1489 = _1487.y;
        float _1490 = _1487.z;
        float _1491 = _1487.w;
        float _1496 = (_1451 - _1452) * 1.73205077648162841796875f;
        float _1498 = mad(_1450, 2.0f, -_1451);
        float _1499 = _1498 - _1452;
        float _1500 = abs(_1499);
        float _1501 = abs(_1496);
        float _1505 = min(_1500, _1501) * (1.0f / max(_1500, _1501));
        float _1506 = _1505 * _1505;
        float _1510 = mad(_1506, mad(_1506, mad(_1506, mad(_1506, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1519 = mad(_1505, _1510, (_1500 < _1501) ? mad(_1505 * _1510, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1499 < (_1452 - _1498)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1520 = min(_1496, _1499);
        float _1521 = max(_1496, _1499);
        float _1530 = ((_1450 == _1451) && (_1452 == _1451)) ? 0.0f : ((((_1520 < (-_1520)) && (_1521 >= (-_1521))) ? (-_1519) : _1519) * 57.295780181884765625f);
        float _1539 = mad(cb1_m23.x, -360.0f, (_1530 < 0.0f) ? (_1530 + 360.0f) : _1530);
        float _1549 = clamp(1.0f - (abs((_1539 < (-180.0f)) ? (_1539 + 360.0f) : ((_1539 > 180.0f) ? (_1539 - 360.0f) : _1539)) / (cb1_m23.y * 180.0f)), 0.0f, 1.0f);
        float _1554 = dp3_f32(float3(_1450, _1451, _1452), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1557 = cb1_m23.z * (mad(_1549, -2.0f, 3.0f) * (_1549 * _1549));
        float _1569 = mad(cb1_m22, mad(_1557, _1450 - _1554, _1554) - _1450, _1450);
        float _1570 = mad(cb1_m22, mad(_1557, _1451 - _1554, _1554) - _1451, _1451);
        float _1571 = mad(cb1_m22, mad(_1557, _1452 - _1554, _1554) - _1452, _1452);
        float _1573;
        _1573 = 0.0f;
        float _1574;
        uint _1577;
        uint _1576 = 0u;
        for (;;)
        {
            if (_1576 >= 8u)
            {
                break;
            }
            uint _1588 = min((_1576 & 3u), 4u);
            float _1608 = mad(float(_1576), 0.785398185253143310546875f, -_1483);
            float _1609 = _1608 + 1.57079637050628662109375f;
            _1574 = mad(_1491 * (dp4_f32(t12.Load((_1576 >> 2u) + 10u), float4(_275[_1588].x, _275[_1588].y, _275[_1588].z, _275[_1588].w)) * clamp((abs((_1609 > 3.1415927410125732421875f) ? (_1608 - 4.7123889923095703125f) : _1609) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _1573, _1573);
            _1577 = _1576 + 1u;
            _1573 = _1574;
            _1576 = _1577;
            continue;
        }
        float _1620 = clamp(_1573, 0.0f, 1.0f);
        float _1638 = abs(t12.Load(8u).x);
        float2 _1641 = float2(_782 * 1.40999996662139892578125f, _783 * 1.40999996662139892578125f);
        float _1643 = sqrt(dp2_f32(_1641, _1641));
        float _1644 = min(_1643, 1.0f);
        float _1645 = _1644 * _1644;
        float _1650 = clamp(_1643 - 0.5f, 0.0f, 1.0f);
        float _1653 = (_1644 * _1645) + (mad(-_1644, _1645, 1.0f) * (_1650 * _1650));
        float _1654 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _1638, -1.0f);
        float _1656 = _1489 + _1654;
        float _1658 = clamp((_1490 + _1654) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _1664 = clamp(_1656 + _1656, 0.0f, 1.0f);
        float _1682 = dp3_f32(float3(t13.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1688 = mad(sin(_1489 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_1682)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _1690 = _1688 * 0.02999999932944774627685546875f;
        float _1691 = mad(_1638, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _1695 = mad(mad(-_1653, _1653, 1.0f), 1.0f - _1691, _1691);
        float _1696 = min((exp2(log2(_1653) * 0.699999988079071044921875f) * (mad(_1664, -2.0f, 3.0f) * (_1664 * _1664))) + ((_1658 * _1658) * mad(_1658, -2.0f, 3.0f)), 1.0f);
        float _1706 = mad(_1696, mad(_1695, _1688 * 0.62000000476837158203125f, mad(_1569, _1620, -_1569)), mad(-_1569, _1620, _1569));
        float _1707 = mad(_1696, mad(_1695, _1690, mad(_1620, _1570, -_1570)), mad(-_1620, _1570, _1570));
        float _1708 = mad(_1696, mad(_1695, _1690, mad(_1620, _1571, -_1571)), mad(-_1620, _1571, _1571));
        float _1711 = mad(_1489, _1490 * (1.0f - _1491), _1491);
        float _1713;
        _1713 = 0.0f;
        float _1714;
        uint _1717;
        uint _1716 = 0u;
        for (;;)
        {
            if (int(_1716) >= 8)
            {
                break;
            }
            float4 _1724 = t12.Load(_1716);
            float _1726 = _1724.y;
            float _1728 = _1724.x - _1483;
            _1714 = mad(_1711 * (_1724.w * clamp(((_1726 - 3.1415927410125732421875f) + abs((_1728 > 3.1415927410125732421875f) ? (_1728 - 6.283185482025146484375f) : ((_1728 < (-3.1415927410125732421875f)) ? (_1728 + 6.283185482025146484375f) : _1728))) / max(_1726 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _1713, _1713);
            _1717 = _1716 + 1u;
            _1713 = _1714;
            _1716 = _1717;
            continue;
        }
        float _1747 = clamp(_1713 + _1713, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _1751 = mad(_1747, 0.310000002384185791015625f - _1706, _1706);
        float _1752 = mad(_1747, 0.014999999664723873138427734375f - _1707, _1707);
        float _1753 = mad(_1747, 0.014999999664723873138427734375f - _1708, _1708);
        float4 _1754 = t12.Load(12u);
        float _1755 = _1754.x;
        float _1783;
        float _1784;
        float _1785;
        if (_1755 != 0.0f)
        {
            float _1762 = clamp(_1682, 0.0f, 1.0f);
            float _1772 = clamp((_1488 + (_1755 - 1.0f)) / max(mad(_1755, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _1776 = clamp(_1755 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _1779 = mad(_1776, -2.0f, 3.0f) * (_1776 * _1776);
            _1783 = mad((_1762 * (_1488 * 0.790000021457672119140625f)) * _1772, _1779, _1751);
            _1784 = mad(_1779, _1772 * (_1762 * (_1488 * 0.85000002384185791015625f)), _1752);
            _1785 = mad(_1779, _1772 * (_1762 * (_1488 * 0.930000007152557373046875f)), _1753);
        }
        else
        {
            _1783 = _1751;
            _1784 = _1752;
            _1785 = _1753;
        }
        float _1790 = 1.0f / max(1.0f - max(max(_1785, _1784), _1783), 6.099999882280826568603515625e-05f);
        float _1797 = min(-(_1790 * _1783), 0.0f);
        float _1798 = min(-(_1790 * _1784), 0.0f);
        float _1799 = min(-(_1790 * _1785), 0.0f);
        float _1809 = clamp(-((1.0f / cb1_m6.y) * (sqrt(_785) - cb1_m6.x)), 0.0f, 1.0f);
        float _1810 = mad(_1809, -2.0f, 3.0f);
        float _1811 = _1809 * _1809;
        float _1812 = _1810 * _1811;
        float _1814 = mad(-_1810, _1811, 1.0f);
        float _1834 = cb1_m6.w * cb1_m6.z;
        float3 _1844 = float3(mad(_1797 + ((cb1_m4.x * _1814) - (_1797 * _1812)), _1834, -_1797), mad(_1834, ((cb1_m4.y * _1814) - (_1812 * _1798)) + _1798, -_1798), mad(_1834, ((cb1_m4.z * _1814) - (_1812 * _1799)) + _1799, -_1799));
#if 1
  float _1851 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1844) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1844), 65504.0f);
  float _1852 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1844) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1844), 65504.0f);
  float _1853 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1844) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1844), 65504.0f);
#endif
        float _1857 = max(max(_1852, _1851), _1853);
        float _1862 = (max(_1857, 9.9999997473787516355514526367188e-05f) - max(min(min(_1852, _1851), _1853), 9.9999997473787516355514526367188e-05f)) / max(_1857, 0.00999999977648258209228515625f);
        float _1873 = mad(sqrt(mad(_1851 - _1853, _1851, ((_1853 - _1852) * _1853) + ((_1852 - _1851) * _1852))), 1.75f, (_1853 + _1852) + _1851);
        float _1874 = _1862 - 0.4000000059604644775390625f;
        float _1879 = max(1.0f - abs(_1874 * 2.5f), 0.0f);
        float _1886 = mad(mad(clamp(mad(_1874, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1879, _1879, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1894 = ((_1873 <= 0.1599999964237213134765625f) ? _1886 : ((_1873 >= 0.4799999892711639404296875f) ? 0.0f : (_1886 * ((0.07999999821186065673828125f / (_1873 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1895 = _1894 * _1851;
        float _1896 = _1894 * _1852;
        float _1897 = _1894 * _1853;
        float _1902 = (_1896 - _1897) * 1.73205077648162841796875f;
        float _1904 = (_1895 * 2.0f) - _1896;
        float _1906 = mad(-_1894, _1853, _1904);
        float _1907 = abs(_1906);
        float _1908 = abs(_1902);
        float _1912 = min(_1907, _1908) * (1.0f / max(_1907, _1908));
        float _1913 = _1912 * _1912;
        float _1917 = mad(_1913, mad(_1913, mad(_1913, mad(_1913, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1927 = mad(_1912, _1917, (_1907 < _1908) ? mad(_1912 * _1917, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1906 < mad(_1894, _1853, -_1904)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1928 = min(_1902, _1906);
        float _1929 = max(_1902, _1906);
        float _1938 = ((_1897 == _1896) && (_1895 == _1896)) ? 0.0f : ((((_1928 < (-_1928)) && (_1929 >= (-_1929))) ? (-_1927) : _1927) * 57.295780181884765625f);
        float _1941 = (_1938 < 0.0f) ? (_1938 + 360.0f) : _1938;
        float _1951 = max(1.0f - abs(((_1941 < (-180.0f)) ? (_1941 + 360.0f) : ((_1941 > 180.0f) ? (_1941 - 360.0f) : _1941)) * 0.01481481455266475677490234375f), 0.0f);
        float _1954 = mad(_1951, -2.0f, 3.0f) * (_1951 * _1951);
        float3 _1965 = float3(clamp(_1895 + (((_1862 * (_1954 * _1954)) * mad(-_1894, _1851, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1896, 0.0f, 65504.0f), clamp(_1897, 0.0f, 65504.0f));
        float _1969 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1965), 0.0f, 65504.0f);
        float _1970 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1965), 0.0f, 65504.0f);
        float _1971 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1965), 0.0f, 65504.0f);

        float _1973 = dp3_f32(float3(_1969, _1970, _1971), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1980 = float3(mad(_1969 - _1973, 0.959999978542327880859375f, _1973), mad(_1970 - _1973, 0.959999978542327880859375f, _1973), mad(_1971 - _1973, 0.959999978542327880859375f, _1973));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_1401] = float4(CustomACES(_1980), 1.f);
    return;
  }
#endif
        float3 _1984 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1980), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1980), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1980));
        float _1985 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1984);
        float _1986 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1984);
        float _1987 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1984);
        uint _1989;
        spvTextureSize(t11, 0u, _1989);
        bool _1990 = _1989 > 0u;
        uint _1991_dummy_parameter;
        _1992 _1993 = { spvTextureSize(t11, 0u, _1991_dummy_parameter), 1u };
        float _1996 = float(_1990 ? _1993._m0.x : 0u);
        float _1999 = float(_1990 ? _1993._m0.y : 0u);
        float _2002 = float(_1990 ? _1993._m0.z : 0u);
        float _2006 = float(_1986 >= _1987);
        float _2007 = mad(_1986 - _1987, _2006, _1987);
        float _2008 = mad(_1987 - _1986, _2006, _1986);
        float _2010 = mad(_2006, -1.0f, 0.666666686534881591796875f);
        float _2016 = float(_1985 >= _2007);
        float _2017 = mad(_1985 - _2007, _2016, _2007);
        float _2018 = mad(_2008 - _2008, _2016, _2008);
        float _2020 = mad(_2007 - _1985, _2016, _1985);
        float _2022 = _2017 - min(_2020, _2018);
        float4 _2046 = t11.SampleLevel(s9, float3(abs(mad(mad(_2006, 1.0f, -1.0f) - _2010, _2016, _2010) + ((_2020 - _2018) / mad(_2022, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1996 + _1996)), (1.0f / (_1999 + _1999)) + (_2022 / (_2017 + 9.9999997473787516355514526367188e-05f)), mad(_2017 * 3.0f, 1.0f / mad(_2017, 3.0f, 1.5f), 1.0f / (_2002 + _2002))), 0.0f);
        float _2047 = _2046.x;
        float _2048 = _2046.y;
        float _2049 = _2046.z;
        float3 _2077 = float3(mad(_2049, mad(_2048, clamp(abs(mad(frac(_2047 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_2047 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _2048, 1.0f), _2049, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_2047 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _2048, 1.0f), _2049, -3.5073844628641381859779357910156e-05f));
        float3 _2081 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _2077), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _2077), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _2077));
        float3 _2085 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _2081), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _2081), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _2081));
        float _2094 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _2085) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _2105 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _2085) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _2115 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _2085) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_1401] = float4(min(exp2(log2(mad(_2094, 18.8515625f, 0.8359375f) / mad(_2094, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_2105, 18.8515625f, 0.8359375f) / mad(_2105, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_2115, 18.8515625f, 0.8359375f) / mad(_2115, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

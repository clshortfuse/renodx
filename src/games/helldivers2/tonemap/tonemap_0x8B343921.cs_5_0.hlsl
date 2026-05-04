#include "../common.hlsl"
struct _351
{
    uint2 _m0;
    uint _m1;
};

struct _2020
{
    uint3 _m0;
    uint _m1;
};

static const float _2154[30] = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
static const float _65[10][30] = { { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f } };
static const float _70[1] = { 0.0f };
static const float4 _278[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
RWTexture2D<float4> u3 : register(u3);

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
    precise float _342 = a.x * b.x;
    return mad(a.y, b.y, _342);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _328 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _328));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _310 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _310)));
}

void comp_main()
{
    uint _350_dummy_parameter;
    _351 _352 = { spvImageSize(u0, _350_dummy_parameter), 1u };
    uint _364 = gl_GlobalInvocationID.x - gl_LocalInvocationID.x;
    uint _365 = gl_GlobalInvocationID.y - gl_LocalInvocationID.y;
    uint _367 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _368 = spvBitfieldUExtract(_367, 1u, 3u);
    uint _370 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _367, 0u, 1u);
    uint _371 = _364 + _368;
    uint _372 = _370 + _365;
    float _377 = float(_352._m0.x);
    float _378 = float(_352._m0.y);
    float _379 = (float(_371) + 0.5f) / _377;
    float _380 = (float(_372) + 0.5f) / _378;
    bool _389 = cb1_m3.y == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _389) && (gl_LocalInvocationID.y == 0u))
    {
        g1[0u] = t8.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    if (_367 < 36u)
    {
        bool _417 = _367 < 4u;
        bool _418 = _367 < 12u;
        bool _419 = _367 < 20u;
        bool _420 = _367 < 28u;
        uint _431 = _417 ? ((_367 >> 1u) * 9u) : (_418 ? 0u : (_419 ? 9u : (_420 ? (((_367 - 20u) & 7u) + 1u) : (((_367 - 28u) & 7u) + 1u))));
        uint _432 = _417 ? ((_367 & 1u) * 9u) : (_418 ? (((_367 - 4u) & 7u) + 1u) : (_419 ? (((_367 - 12u) & 7u) + 1u) : (_420 ? 0u : 9u)));
        float _433 = 1.0f / _377;
        float _434 = 1.0f / _378;
        float _453 = clamp((_433 * (float(int(_431 - 1u)) + 0.5f)) + (_433 * float(int(_364))), 0.0f, 1.0f);
        float _454 = clamp(((float(int(_432 - 1u)) + 0.5f) * _434) + (float(int(_365)) * _434), 0.0f, 1.0f);
        float2 _457 = float2(_453, _454);
        float _462 = mad(t6.SampleLevel(s5, _457, 0.0f).x, 2.0f, -1.0f);
        float _477;
        if (_462 > 0.0f)
        {
            _477 = min(sqrt(_462), t0.Load(8u).x);
        }
        else
        {
            _477 = max(_462, -t0.Load(7u).x);
        }
        float4 _481 = t5.SampleLevel(s4, _457, 0.0f);
        float2 _491 = float2(_481.x * cb1_m2.z, _481.y * cb1_m2.w);
        bool _504 = (cb1_m9.x != 0.0f) && (cb1_m9.y != 0.0f);
        bool _508 = (cb1_m7.w != 0.0f) && (cb1_m8.x != 0.0f);
        float _520 = exp2(max(_504 ? clamp((sqrt(dp2_f32(_491, _491)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _508 ? clamp((abs(_477) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float _522 = _453 - 0.5f;
        float _523 = _454 - 0.5f;
        float2 _524 = float2(_522, _523);
        float _528 = mad(cb1_m20, dp2_f32(_524, _524), 1.0f);
        float _550 = mad(exp2(log2(clamp(cb1_m20, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(cb1_m21.x, -0.089999973773956298828125f, 1.0f);
        float _551 = (_528 * mad(mad(cb1_m21.y, -0.001999996602535247802734375f, 0.092000000178813934326171875f), cb1_m21.x, 1.0f)) * _550;
        float _552 = _550 * (_528 * mad(mad(cb1_m21.y, 0.04500000178813934326171875f, 0.046999998390674591064453125f), cb1_m21.x, 1.0f));
        float _553 = _550 * (_528 * mad(mad(cb1_m21.y, 0.0f, 0.04500000178813934326171875f), cb1_m21.x, 1.0f));
        float _554 = mad(_522, _551, 0.5f);
        float _555 = mad(_551, _523, 0.5f);
        float _556 = mad(_522, _552, 0.5f);
        float _557 = mad(_552, _523, 0.5f);
        float2 _560 = float2(_554, _555);
        float4 _562 = t1.SampleLevel(s0, _560, 0.0f);
        float _563 = _562.x;
        bool _564 = _508 || _504;
        float _598;
        if (_564)
        {
            float4 _570 = t2.SampleLevel(s1, _560, 0.0f);
            float _571 = _570.x;
            float _579 = asfloat(cb0_m[43u].w) * 20.0f;
            float _595 = mad(mad(t9.SampleLevel(s7, float2(mad(_554, 30.0f, sin(_579)), mad(_555, 30.0f, cos(_579))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_571, max(_570.y, _570.z)), 1.0000000133514319600180897396058e-10f)), _571);
            _598 = mad(_520, _563 - _595, _595);
        }
        else
        {
            _598 = _563;
        }
        float2 _599 = float2(_556, _557);
        float4 _601 = t1.SampleLevel(s0, _599, 0.0f);
        float _602 = _601.y;
        float _635;
        if (_564)
        {
            float4 _608 = t2.SampleLevel(s1, _599, 0.0f);
            float _610 = _608.y;
            float _616 = asfloat(cb0_m[43u].w) * 20.0f;
            float _632 = mad(mad(t9.SampleLevel(s7, float2(mad(_556, 30.0f, sin(_616)), mad(_557, 30.0f, cos(_616))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_608.x, max(_610, _608.z)), 1.0000000133514319600180897396058e-10f)), _610);
            _635 = mad(_520, _602 - _632, _632);
        }
        else
        {
            _635 = _602;
        }
        float _636 = mad(_522, _553, 0.5f);
        float _637 = mad(_553, _523, 0.5f);
        float2 _638 = float2(_636, _637);
        float4 _640 = t1.SampleLevel(s0, _638, 0.0f);
        float _641 = _640.z;
        float _674;
        if (_564)
        {
            float4 _647 = t2.SampleLevel(s1, _638, 0.0f);
            float _650 = _647.z;
            float _655 = asfloat(cb0_m[43u].w) * 20.0f;
            float _671 = mad(mad(t9.SampleLevel(s7, float2(mad(_636, 30.0f, sin(_655)), mad(_637, 30.0f, cos(_655))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_647.x, max(_647.y, _650)), 1.0000000133514319600180897396058e-10f)), _650);
            _674 = mad(_520, _641 - _671, _671);
        }
        else
        {
            _674 = _641;
        }
        float _679 = _389 ? g1[0u] : cb1_m3.x;
        float4 _683 = t7.SampleLevel(s6, _457, 0.0f);
        float _684 = _683.x;
        float _692 = max(cb1_m3.w - dp3_f32(float3(_684, _683.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
        float _696 = mad(_598, _679, _684 / _692);
        float _697 = mad(_635, _679, _683.y / _692);
        float _698 = mad(_674, _679, _683.z / _692);
        float _702 = 1.0f / (max(_696, max(_698, _697)) + 1.0f);
        float _703 = _696 * _702;
        float _705 = _702 * _698;
        float3 _706 = float3(_703, _705, _702 * _697);
        uint _711 = (_432 * 12u) >> 2u;
        g0[_431][_711] = dp3_f32(_706, float3(0.25f, 0.25f, 0.5f));
        uint _714 = _711 + 1u;
        g0[_431][_714] = dp2_f32(float2(_703, _705), float2(0.5f, -0.5f));
        uint _717 = _711 + 2u;
        g0[_431][_717] = dp3_f32(_706, float3(-0.25f, -0.25f, 0.5f));
    }
    float2 _722 = float2(_379, _380);
    float _726 = mad(t6.SampleLevel(s5, _722, 0.0f).x, 2.0f, -1.0f);
    float _741;
    if (_726 > 0.0f)
    {
        _741 = min(sqrt(_726), t0.Load(8u).x);
    }
    else
    {
        _741 = max(_726, -t0.Load(7u).x);
    }
    float4 _745 = t5.SampleLevel(s4, _722, 0.0f);
    float _746 = _745.x;
    float _747 = _745.y;
    float2 _758 = float2(_746 * cb1_m2.z, _747 * cb1_m2.w);
    bool _770 = (cb1_m9.x != 0.0f) && (cb1_m9.y != 0.0f);
    bool _774 = (cb1_m7.w != 0.0f) && (cb1_m8.x != 0.0f);
    float _778 = abs(_741);
    float _786 = exp2(max(_770 ? clamp((sqrt(dp2_f32(_758, _758)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _774 ? clamp((_778 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _787 = _379 - 0.5f;
    float _788 = _380 - 0.5f;
    float2 _789 = float2(_787, _788);
    float _790 = dp2_f32(_789, _789);
    float _793 = mad(cb1_m20, _790, 1.0f);
    float _815 = mad(exp2(log2(clamp(cb1_m20, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(cb1_m21.x, -0.089999973773956298828125f, 1.0f);
    float _816 = (_793 * mad(mad(cb1_m21.y, -0.001999996602535247802734375f, 0.092000000178813934326171875f), cb1_m21.x, 1.0f)) * _815;
    float _817 = _815 * (_793 * mad(cb1_m21.x, mad(cb1_m21.y, 0.04500000178813934326171875f, 0.046999998390674591064453125f), 1.0f));
    float _818 = _815 * (_793 * mad(cb1_m21.x, mad(cb1_m21.y, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _819 = mad(_787, _816, 0.5f);
    float _820 = mad(_816, _788, 0.5f);
    float _821 = mad(_787, _817, 0.5f);
    float _822 = mad(_788, _817, 0.5f);
    float2 _825 = float2(_819, _820);
    float4 _827 = t1.SampleLevel(s0, _825, 0.0f);
    float _828 = _827.x;
    bool _829 = _774 || _770;
    float _862;
    if (_829)
    {
        float4 _835 = t2.SampleLevel(s1, _825, 0.0f);
        float _836 = _835.x;
        float _843 = asfloat(cb0_m[43u].w) * 20.0f;
        float _859 = mad(mad(t9.SampleLevel(s7, float2(mad(_819, 30.0f, sin(_843)), mad(_820, 30.0f, cos(_843))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_836, max(_835.y, _835.z)), 1.0000000133514319600180897396058e-10f)), _836);
        _862 = mad(_786, _828 - _859, _859);
    }
    else
    {
        _862 = _828;
    }
    float2 _863 = float2(_821, _822);
    float4 _865 = t1.SampleLevel(s0, _863, 0.0f);
    float _866 = _865.y;
    float _899;
    if (_829)
    {
        float4 _872 = t2.SampleLevel(s1, _863, 0.0f);
        float _874 = _872.y;
        float _880 = asfloat(cb0_m[43u].w) * 20.0f;
        float _896 = mad(mad(t9.SampleLevel(s7, float2(mad(_821, 30.0f, sin(_880)), mad(_822, 30.0f, cos(_880))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_872.x, max(_874, _872.z)), 1.0000000133514319600180897396058e-10f)), _874);
        _899 = mad(_786, _866 - _896, _896);
    }
    else
    {
        _899 = _866;
    }
    float _900 = mad(_787, _818, 0.5f);
    float _901 = mad(_788, _818, 0.5f);
    float2 _902 = float2(_900, _901);
    float4 _904 = t1.SampleLevel(s0, _902, 0.0f);
    float _905 = _904.z;
    float _938;
    if (_829)
    {
        float4 _911 = t2.SampleLevel(s1, _902, 0.0f);
        float _914 = _911.z;
        float _919 = asfloat(cb0_m[43u].w) * 20.0f;
        float _935 = mad(mad(t9.SampleLevel(s7, float2(mad(_900, 30.0f, sin(_919)), mad(_901, 30.0f, cos(_919))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_911.x, max(_911.y, _914)), 1.0000000133514319600180897396058e-10f)), _914);
        _938 = mad(_786, _905 - _935, _935);
    }
    else
    {
        _938 = _905;
    }
    float _943 = _389 ? g1[0u] : cb1_m3.x;
    float4 _947 = t7.SampleLevel(s6, _722, 0.0f);
    float _948 = _947.x;
    float _956 = max(cb1_m3.w - dp3_f32(float3(_948, _947.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _960 = mad(_862, _943, _948 / _956);
    float _961 = mad(_899, _943, _947.y / _956);
    float _962 = mad(_938, _943, _947.z / _956);
    float _966 = 1.0f / (max(_960, max(_962, _961)) + 1.0f);
    float _967 = _960 * _966;
    float _969 = _962 * _966;
    float3 _970 = float3(_967, _969, _961 * _966);
    float _971 = dp3_f32(_970, float3(0.25f, 0.25f, 0.5f));
    float _972 = dp3_f32(_970, float3(-0.25f, -0.25f, 0.5f));
    float _974 = dp2_f32(float2(_967, _969), float2(0.5f, -0.5f));
    uint _975 = _368 + 1u;
    uint _976 = _368 + 2u;
    uint _977 = _370 * 12u;
    uint _980 = (_977 + 12u) >> 2u;
    g0[_975][_980] = _971;
    uint _983 = _980 + 1u;
    g0[_975][_983] = _974;
    uint _986 = _980 + 2u;
    g0[_975][_986] = _972;
    float2 _989 = float2(_746 * cb1_m2.x, _747 * cb1_m2.y);
    float _993 = min(sqrt(dp2_f32(_989, _989)) * 0.07500000298023223876953125f, 1.0f);
    float _994 = _379 - _746;
    float _995 = _380 - _747;
    float _1003 = (max(abs(mad(_995, 2.0f, -1.0f)), abs(mad(_994, 2.0f, -1.0f))) >= 1.0f) ? (-_993) : _993;
    float _1010 = floor(mad(cb1_m2.x, _994, -0.5f));
    float _1011 = floor(mad(_995, cb1_m2.y, -0.5f));
    float _1012 = _1010 + 0.5f;
    float _1013 = _1011 + 0.5f;
    float _1017 = mad(cb1_m2.x, _994, -_1012);
    float _1019 = mad(_995, cb1_m2.y, -_1013);
    float _1021 = mad(-cb1_m2.x, _994, _1012);
    float _1023 = mad(-_995, cb1_m2.y, _1013);
    float _1030 = mad(_1017, mad(_1021, 1.5f, 2.0f), 0.5f);
    float _1031 = mad(mad(_1023, 1.5f, 2.0f), _1019, 0.5f);
    float _1032 = _1017 * _1017;
    float _1033 = _1019 * _1019;
    float _1038 = _1032 * mad(_1017, 0.5f, -0.5f);
    float _1039 = mad(_1019, 0.5f, -0.5f) * _1033;
    float _1042 = _1017 * mad(_1017, mad(_1021, 0.5f, 1.0f), -0.5f);
    float _1043 = mad(mad(_1023, 0.5f, 1.0f), _1019, -0.5f) * _1019;
    float _1046 = mad(_1017, _1030, mad(_1032, mad(_1017, 1.5f, -2.5f), 1.0f));
    float _1047 = mad(_1031, _1019, mad(mad(_1019, 1.5f, -2.5f), _1033, 1.0f));
    float _1054 = (_1010 - 0.5f) / cb1_m2.x;
    float _1055 = (_1011 - 0.5f) / cb1_m2.y;
    float _1056 = (_1010 + 2.5f) / cb1_m2.x;
    float _1057 = (_1011 + 2.5f) / cb1_m2.y;
    float _1058 = (_1013 + ((_1031 * _1019) / _1047)) / cb1_m2.y;
    float _1059 = (_1012 + ((_1017 * _1030) / _1046)) / cb1_m2.x;
    float4 _1064 = t3.SampleLevel(s2, float2(_1054, _1055), 0.0f);
    float4 _1073 = t3.SampleLevel(s2, float2(_1056, _1055), 0.0f);
    float4 _1091 = t3.SampleLevel(s2, float2(_1059, _1055), 0.0f);
    float4 _1103 = t3.SampleLevel(s2, float2(_1054, _1058), 0.0f);
    float4 _1115 = t3.SampleLevel(s2, float2(_1059, _1058), 0.0f);
    float4 _1127 = t3.SampleLevel(s2, float2(_1056, _1058), 0.0f);
    float4 _1139 = t3.SampleLevel(s2, float2(_1054, _1057), 0.0f);
    float4 _1151 = t3.SampleLevel(s2, float2(_1059, _1057), 0.0f);
    float4 _1163 = t3.SampleLevel(s2, float2(_1056, _1057), 0.0f);
    float _1170 = mad(_1038 * _1163.x, _1039, mad(_1046 * _1151.x, _1039, mad(_1042 * _1139.x, _1039, mad(_1038 * _1127.x, _1047, mad(_1046 * _1115.x, _1047, mad(_1042 * _1103.x, _1047, mad(_1046 * _1091.x, _1043, ((_1038 * _1073.x) * _1043) + ((_1042 * _1064.x) * _1043))))))));
    float _1172 = mad(_1038 * _1163.z, _1039, mad(_1046 * _1151.z, _1039, mad(_1042 * _1139.z, _1039, mad(_1038 * _1127.z, _1047, mad(_1046 * _1115.z, _1047, mad(_1042 * _1103.z, _1047, mad(_1046 * _1091.z, _1043, ((_1042 * _1064.z) * _1043) + ((_1038 * _1073.z) * _1043))))))));
    float3 _1173 = float3(_1170, _1172, mad(_1038 * _1163.y, _1039, mad(_1046 * _1151.y, _1039, mad(_1042 * _1139.y, _1039, mad(_1038 * _1127.y, _1047, mad(_1046 * _1115.y, _1047, mad(_1042 * _1103.y, _1047, mad(_1046 * _1091.y, _1043, ((_1042 * _1064.y) * _1043) + ((_1038 * _1073.y) * _1043)))))))));
    float _1174 = dp3_f32(_1173, float3(0.25f, 0.25f, 0.5f));
    float _1175 = dp3_f32(_1173, float3(-0.25f, -0.25f, 0.5f));
    float _1177 = dp2_f32(float2(_1170, _1172), float2(0.5f, -0.5f));
    GroupMemoryBarrierWithGroupSync();
    uint _1178 = _977 >> 2u;
    uint _1182 = _1178 + 1u;
    uint _1186 = _1178 + 2u;
    uint _1272 = (_977 + 24u) >> 2u;
    uint _1276 = _1272 + 1u;
    uint _1280 = _1272 + 2u;
    float _1301 = min(min(min(min(_971, g0[_975][_1178]), g0[_368][_980]), g0[_976][_980]), g0[_975][_1272]);
    float _1302 = max(max(max(max(_971, g0[_975][_1178]), g0[_368][_980]), g0[_976][_980]), g0[_975][_1272]);
    float _1320 = (((((((_971 + g0[_975][_1178]) + g0[_368][_1178]) + g0[_368][_980]) + g0[_976][_1178]) + g0[_976][_980]) + g0[_368][_1272]) + g0[_975][_1272]) + g0[_976][_1272];
    float _1334 = _1320 * 0.111111111938953399658203125f;
    float _1335 = (g0[_976][_1276] + (g0[_975][_1276] + (g0[_368][_1276] + (g0[_976][_983] + (g0[_976][_1182] + (g0[_368][_983] + (g0[_368][_1182] + (_974 + g0[_975][_1182])))))))) * 0.111111111938953399658203125f;
    float _1336 = (g0[_976][_1280] + (g0[_975][_1280] + (g0[_368][_1280] + (g0[_976][_986] + (g0[_976][_1186] + (g0[_368][_986] + (g0[_368][_1186] + (_972 + g0[_975][_1186])))))))) * 0.111111111938953399658203125f;
    float _1355 = mad(_1174 / max(mad(_1320, 0.111111111938953399658203125f, _1174), 1.0000000116860974230803549289703e-07f), 0.5f, 0.75f);
    float _1356 = sqrt(max((mad(g0[_976][_1272], g0[_976][_1272], mad(g0[_975][_1272], g0[_975][_1272], mad(g0[_368][_1272], g0[_368][_1272], mad(g0[_976][_980], g0[_976][_980], mad(g0[_976][_1178], g0[_976][_1178], mad(g0[_368][_980], g0[_368][_980], mad(g0[_368][_1178], g0[_368][_1178], (g0[_975][_1178] * g0[_975][_1178]) + (_971 * _971)))))))) * 0.111111111938953399658203125f) - (_1334 * _1334), 1.0000000133514319600180897396058e-10f)) * _1355;
    float _1357 = _1355 * sqrt(max((mad(g0[_976][_1276], g0[_976][_1276], mad(g0[_975][_1276], g0[_975][_1276], mad(g0[_368][_1276], g0[_368][_1276], mad(g0[_976][_983], g0[_976][_983], mad(g0[_976][_1182], g0[_976][_1182], mad(g0[_368][_983], g0[_368][_983], mad(g0[_368][_1182], g0[_368][_1182], (_974 * _974) + (g0[_975][_1182] * g0[_975][_1182])))))))) * 0.111111111938953399658203125f) - (_1335 * _1335), 1.0000000133514319600180897396058e-10f));
    float _1358 = _1355 * sqrt(max((mad(g0[_976][_1280], g0[_976][_1280], mad(g0[_975][_1280], g0[_975][_1280], mad(g0[_368][_1280], g0[_368][_1280], mad(g0[_976][_986], g0[_976][_986], mad(g0[_976][_1186], g0[_976][_1186], mad(g0[_368][_986], g0[_368][_986], mad(g0[_368][_1186], g0[_368][_1186], (_972 * _972) + (g0[_975][_1186] * g0[_975][_1186])))))))) * 0.111111111938953399658203125f) - (_1336 * _1336), 1.0000000133514319600180897396058e-10f));
    float _1362 = _1334 + _1356;
    float _1363 = _1357 + _1335;
    float _1364 = _1358 + _1336;
    float _1365 = (_1334 - _1356) + _1362;
    float _1366 = _1363 + (_1335 - _1357);
    float _1367 = _1364 + (_1336 - _1358);
    float _1377 = mad(_1365, -0.5f, _1174);
    float _1378 = mad(_1366, -0.5f, _1177);
    float _1379 = mad(_1367, -0.5f, _1175);
    float _1387 = max(max(abs(_1378 / mad((_1357 - _1335) + _1363, 0.5f, 9.9999997473787516355514526367188e-05f)), abs(_1377 / mad(_1362 + (_1356 - _1334), 0.5f, 9.9999997473787516355514526367188e-05f))), abs(_1379 / mad((_1358 - _1336) + _1364, 0.5f, 9.9999997473787516355514526367188e-05f)));
    bool _1388 = _1387 > 1.0f;
    uint2 _1406 = uint2(_371, _372);
    float _1410 = max((_1174 / ((_1174 + (mad(_1302, 0.5f, max(_1302 * 0.5f, max(max(max(max(_971, g0[_368][_1178]), g0[_976][_1178]), g0[_368][_1272]), g0[_976][_1272]) * 0.5f)) - mad(_1301, 0.5f, min(_1301 * 0.5f, min(min(min(min(_971, g0[_368][_1178]), g0[_976][_1178]), g0[_368][_1272]), g0[_976][_1272]) * 0.5f)))) + 1.0000000116860974230803549289703e-07f)) * mad(abs(_1003), 0.85000002384185791015625f, 0.100000001490116119384765625f), u2[_1406].x * 0.75f);
    bool _1411 = _1003 < 0.0f;
    float _1412 = _1411 ? _971 : (_1388 ? mad(_1365, 0.5f, _1377 / _1387) : _1174);
    float _1413 = _1411 ? _974 : (_1388 ? mad(_1366, 0.5f, _1378 / _1387) : _1177);
    float _1414 = _1411 ? _972 : (_1388 ? mad(_1367, 0.5f, _1379 / _1387) : _1175);
    float _1422 = clamp(mad(t4.SampleLevel(s3, _722, 0.0f).y, 1.0f - _1410, _1410), 0.0039215688593685626983642578125f, 0.949999988079071044921875f);
    float _1426 = mad(1.0f - _1422, cb1_m0.x, _1422);
    float _1430 = mad(_1426, _971 - _1412, _1412);
    float _1431 = mad(_1426, _974 - _1413, _1413);
    float _1432 = mad(_1426, _972 - _1414, _1414);
    float _1433 = _1430 - _1432;
    float _1434 = _1433 + _1431;
    float _1435 = _1430 + _1432;
    float _1436 = _1433 - _1431;
    u1[_1406] = float4(_1434, _1435, _1436, 0.0f);
    u2[_1406] = _1426.xxxx;
    u3[_1406] = float4(_1430, _1431, _1432, _1430);
    if (!((_352._m0.x < _371) || (_352._m0.y < _372)))
    {
        float _1446 = dp3_f32(float3(_1434, _1435, _1436), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1453 = mad(-_778, cb1_m8.y, 1.0f) * cb1_m7.x;
        float _1457 = mad(_1453, _1434 - _1446, _1446);
        float _1458 = mad(_1453, _1435 - _1446, _1446);
        float _1459 = mad(_1453, _1436 - _1446, _1446);
        float _1460 = _788 + _788;
        float _1461 = _787 + _787;
        float _1462 = abs(_1461);
        float _1463 = abs(_1460);
        float _1467 = min(_1462, _1463) * (1.0f / max(_1462, _1463));
        float _1468 = _1467 * _1467;
        float _1472 = mad(_1468, mad(_1468, mad(_1468, mad(_1468, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1481 = mad(_1467, _1472, (_1462 < _1463) ? mad(_1467 * _1472, -2.0f, 1.57079637050628662109375f) : 0.0f) + (((-_1461) > _1461) ? (-3.1415927410125732421875f) : 0.0f);
        float _1482 = min(_1460, _1461);
        float _1483 = max(_1460, _1461);
        float _1490 = ((_1482 < (-_1482)) && (_1483 >= (-_1483))) ? (-_1481) : _1481;
        float4 _1494 = t10.SampleLevel(s8, _722, 0.0f);
        float _1495 = _1494.x;
        float _1496 = _1494.y;
        float _1497 = _1494.z;
        float _1498 = _1494.w;
        float _1503 = (_1458 - _1459) * 1.73205077648162841796875f;
        float _1505 = mad(_1457, 2.0f, -_1458);
        float _1506 = _1505 - _1459;
        float _1507 = abs(_1506);
        float _1508 = abs(_1503);
        float _1512 = min(_1507, _1508) * (1.0f / max(_1507, _1508));
        float _1513 = _1512 * _1512;
        float _1517 = mad(_1513, mad(_1513, mad(_1513, mad(_1513, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1526 = mad(_1512, _1517, (_1507 < _1508) ? mad(_1512 * _1517, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1506 < (_1459 - _1505)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1527 = min(_1503, _1506);
        float _1528 = max(_1503, _1506);
        float _1537 = ((_1457 == _1458) && (_1459 == _1458)) ? 0.0f : ((((_1527 < (-_1527)) && (_1528 >= (-_1528))) ? (-_1526) : _1526) * 57.295780181884765625f);
        float _1546 = mad(cb1_m23.y, -360.0f, (_1537 < 0.0f) ? (_1537 + 360.0f) : _1537);
        float _1556 = clamp(1.0f - (abs((_1546 < (-180.0f)) ? (_1546 + 360.0f) : ((_1546 > 180.0f) ? (_1546 - 360.0f) : _1546)) / (cb1_m23.z * 180.0f)), 0.0f, 1.0f);
        float _1561 = dp3_f32(float3(_1457, _1458, _1459), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1564 = cb1_m23.w * (mad(_1556, -2.0f, 3.0f) * (_1556 * _1556));
        float _1576 = mad(cb1_m22, mad(_1564, _1457 - _1561, _1561) - _1457, _1457);
        float _1577 = mad(cb1_m22, mad(_1564, _1458 - _1561, _1561) - _1458, _1458);
        float _1578 = mad(cb1_m22, mad(_1564, _1459 - _1561, _1561) - _1459, _1459);
        float _1580;
        _1580 = 0.0f;
        float _1581;
        uint _1584;
        uint _1583 = 0u;
        for (;;)
        {
            if (_1583 >= 8u)
            {
                break;
            }
            uint _1595 = min((_1583 & 3u), 4u);
            float _1615 = mad(float(_1583), 0.785398185253143310546875f, -_1490);
            float _1616 = _1615 + 1.57079637050628662109375f;
            _1581 = mad(_1498 * (dp4_f32(t12.Load((_1583 >> 2u) + 10u), float4(_278[_1595].x, _278[_1595].y, _278[_1595].z, _278[_1595].w)) * clamp((abs((_1616 > 3.1415927410125732421875f) ? (_1615 - 4.7123889923095703125f) : _1616) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _1580, _1580);
            _1584 = _1583 + 1u;
            _1580 = _1581;
            _1583 = _1584;
            continue;
        }
        float _1627 = clamp(_1580, 0.0f, 1.0f);
        float _1640 = asfloat(cb0_m[43u].w);
        float _1646 = abs(t12.Load(8u).x);
        float2 _1649 = float2(_787 * 1.40999996662139892578125f, _788 * 1.40999996662139892578125f);
        float _1651 = sqrt(dp2_f32(_1649, _1649));
        float _1652 = min(_1651, 1.0f);
        float _1653 = _1652 * _1652;
        float _1658 = clamp(_1651 - 0.5f, 0.0f, 1.0f);
        float _1661 = (_1652 * _1653) + (mad(-_1652, _1653, 1.0f) * (_1658 * _1658));
        float _1662 = mad(mad(mad(sin(_1640 * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _1646, -1.0f);
        float _1664 = _1496 + _1662;
        float _1666 = clamp((_1497 + _1662) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _1673 = clamp(_1664 + _1664, 0.0f, 1.0f);
        float _1683 = mad(sin(_1496 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f);
        float _1690 = dp3_f32(float3(t13.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1695 = mad(exp2(log2(abs(_1690)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _1699 = _1683 * (_1695 * 0.02999999932944774627685546875f);
        float _1700 = mad(_1646, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _1704 = mad(mad(-_1661, _1661, 1.0f), 1.0f - _1700, _1700);
        float _1705 = min((exp2(log2(_1661) * 0.699999988079071044921875f) * (mad(_1673, -2.0f, 3.0f) * (_1673 * _1673))) + (mad(_1666, -2.0f, 3.0f) * (_1666 * _1666)), 1.0f);
        float _1715 = mad(_1705, mad((_1683 * _1695) * 0.62000000476837158203125f, _1704, mad(_1576, _1627, -_1576)), mad(-_1576, _1627, _1576));
        float _1716 = mad(_1705, mad(_1704, _1699, mad(_1627, _1577, -_1577)), mad(-_1627, _1577, _1577));
        float _1717 = mad(_1705, mad(_1704, _1699, mad(_1627, _1578, -_1578)), mad(-_1627, _1578, _1578));
        float _1720 = mad(_1496, _1497 * (1.0f - _1498), _1498);
        float _1722;
        _1722 = 0.0f;
        float _1723;
        uint _1726;
        uint _1725 = 0u;
        for (;;)
        {
            if (int(_1725) >= 8)
            {
                break;
            }
            float4 _1733 = t12.Load(_1725);
            float _1735 = _1733.y;
            float _1737 = _1733.x - _1490;
            _1723 = mad(_1720 * (_1733.w * clamp(((_1735 - 3.1415927410125732421875f) + abs((_1737 > 3.1415927410125732421875f) ? (_1737 - 6.283185482025146484375f) : ((_1737 < (-3.1415927410125732421875f)) ? (_1737 + 6.283185482025146484375f) : _1737))) / max(_1735 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _1722, _1722);
            _1726 = _1725 + 1u;
            _1722 = _1723;
            _1725 = _1726;
            continue;
        }
        float _1756 = clamp(_1722 + _1722, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _1760 = mad(_1756, 0.310000002384185791015625f - _1715, _1715);
        float _1761 = mad(_1756, 0.014999999664723873138427734375f - _1716, _1716);
        float _1762 = mad(_1756, 0.014999999664723873138427734375f - _1717, _1717);
        float4 _1763 = t12.Load(12u);
        float _1764 = _1763.x;
        float _1792;
        float _1793;
        float _1794;
        if (_1764 != 0.0f)
        {
            float _1771 = clamp(_1690, 0.0f, 1.0f);
            float _1781 = clamp((_1495 + (_1764 - 1.0f)) / max(mad(_1764, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _1785 = clamp(_1764 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _1788 = mad(_1785, -2.0f, 3.0f) * (_1785 * _1785);
            _1792 = mad(_1788, _1781 * (_1771 * (_1495 * 0.930000007152557373046875f)), _1762);
            _1793 = mad(_1788, _1781 * (_1771 * (_1495 * 0.85000002384185791015625f)), _1761);
            _1794 = mad((_1771 * (_1495 * 0.790000021457672119140625f)) * _1781, _1788, _1760);
        }
        else
        {
            _1792 = _1762;
            _1793 = _1761;
            _1794 = _1760;
        }
        bool _1797 = cb1_m23.x > 0.0f;
        bool _1801 = frac((_380 * 420.0f) + (_1640 * 0.20000000298023223876953125f)) >= 0.5f;
        float _1802 = _1801 ? 0.300000011920928955078125f : 0.0f;
        float _1803 = cb1_m23.x * _1802;
        float _1811 = _1797 ? mad(_1803, 0.0f - _1794, _1794) : _1794;
        float _1812 = _1797 ? mad(_1803, (_1801 ? 0.100000001490116119384765625f : 0.0f) - _1793, _1793) : _1793;
        float _1813 = _1797 ? mad(_1803, _1802 - _1792, _1792) : _1792;
        float _1818 = 1.0f / max(1.0f - max(max(_1813, _1812), _1811), 6.099999882280826568603515625e-05f);
        float _1825 = min(-(_1818 * _1811), 0.0f);
        float _1826 = min(-(_1818 * _1812), 0.0f);
        float _1827 = min(-(_1818 * _1813), 0.0f);
        float _1837 = clamp(-((sqrt(_790) - cb1_m6.x) * (1.0f / cb1_m6.y)), 0.0f, 1.0f);
        float _1838 = mad(_1837, -2.0f, 3.0f);
        float _1839 = _1837 * _1837;
        float _1840 = _1838 * _1839;
        float _1842 = mad(-_1838, _1839, 1.0f);
        float _1862 = cb1_m6.z * cb1_m6.w;
        float3 _1872 = float3(mad(_1825 + ((_1842 * cb1_m4.x) - (_1825 * _1840)), _1862, -_1825), mad(_1862, ((cb1_m4.y * _1842) - (_1840 * _1826)) + _1826, -_1826), mad(_1862, ((cb1_m4.z * _1842) - (_1840 * _1827)) + _1827, -_1827));
#if 1
  float _1879 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1872) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1872), 65504.0f);
  float _1880 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1872) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1872), 65504.0f);
  float _1881 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1872) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1872), 65504.0f);
#endif
        float _1885 = max(max(_1880, _1879), _1881);
        float _1890 = (max(_1885, 9.9999997473787516355514526367188e-05f) - max(min(min(_1880, _1879), _1881), 9.9999997473787516355514526367188e-05f)) / max(_1885, 0.00999999977648258209228515625f);
        float _1901 = mad(sqrt(mad(_1879 - _1881, _1879, ((_1881 - _1880) * _1881) + ((_1880 - _1879) * _1880))), 1.75f, (_1881 + _1880) + _1879);
        float _1902 = _1890 - 0.4000000059604644775390625f;
        float _1907 = max(1.0f - abs(_1902 * 2.5f), 0.0f);
        float _1914 = mad(mad(clamp(mad(_1902, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1907, _1907, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1922 = ((_1901 <= 0.1599999964237213134765625f) ? _1914 : ((_1901 >= 0.4799999892711639404296875f) ? 0.0f : (_1914 * ((0.07999999821186065673828125f / (_1901 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1923 = _1879 * _1922;
        float _1924 = _1880 * _1922;
        float _1925 = _1881 * _1922;
        float _1930 = (_1924 - _1925) * 1.73205077648162841796875f;
        float _1932 = (_1923 * 2.0f) - _1924;
        float _1934 = mad(-_1881, _1922, _1932);
        float _1935 = abs(_1934);
        float _1936 = abs(_1930);
        float _1940 = min(_1935, _1936) * (1.0f / max(_1935, _1936));
        float _1941 = _1940 * _1940;
        float _1945 = mad(_1941, mad(_1941, mad(_1941, mad(_1941, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1955 = mad(_1940, _1945, (_1935 < _1936) ? mad(_1940 * _1945, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1934 < mad(_1881, _1922, -_1932)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1956 = min(_1930, _1934);
        float _1957 = max(_1930, _1934);
        float _1966 = ((_1925 == _1924) && (_1924 == _1923)) ? 0.0f : ((((_1956 < (-_1956)) && (_1957 >= (-_1957))) ? (-_1955) : _1955) * 57.295780181884765625f);
        float _1969 = (_1966 < 0.0f) ? (_1966 + 360.0f) : _1966;
        float _1979 = max(1.0f - abs(((_1969 < (-180.0f)) ? (_1969 + 360.0f) : ((_1969 > 180.0f) ? (_1969 - 360.0f) : _1969)) * 0.01481481455266475677490234375f), 0.0f);
        float _1982 = mad(_1979, -2.0f, 3.0f) * (_1979 * _1979);
        float3 _1993 = float3(clamp(_1923 + (((_1890 * (_1982 * _1982)) * mad(-_1879, _1922, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1924, 0.0f, 65504.0f), clamp(_1925, 0.0f, 65504.0f));
        float _1997 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1993), 0.0f, 65504.0f);
        float _1998 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1993), 0.0f, 65504.0f);
        float _1999 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1993), 0.0f, 65504.0f);

        float _2001 = dp3_f32(float3(_1997, _1998, _1999), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _2008 = float3(mad(_1997 - _2001, 0.959999978542327880859375f, _2001), mad(_1998 - _2001, 0.959999978542327880859375f, _2001), mad(_1999 - _2001, 0.959999978542327880859375f, _2001));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_1406] = float4(CustomACES(_2008), 1.f);
    return;
  }
#endif
        float3 _2012 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _2008), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _2008), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _2008));
        float _2013 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _2012);
        float _2014 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _2012);
        float _2015 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _2012);
        uint _2017;
        spvTextureSize(t11, 0u, _2017);
        bool _2018 = _2017 > 0u;
        uint _2019_dummy_parameter;
        _2020 _2021 = { spvTextureSize(t11, 0u, _2019_dummy_parameter), 1u };
        float _2024 = float(_2018 ? _2021._m0.x : 0u);
        float _2027 = float(_2018 ? _2021._m0.y : 0u);
        float _2030 = float(_2018 ? _2021._m0.z : 0u);
        float _2034 = float(_2014 >= _2015);
        float _2035 = mad(_2014 - _2015, _2034, _2015);
        float _2036 = mad(_2015 - _2014, _2034, _2014);
        float _2038 = mad(_2034, -1.0f, 0.666666686534881591796875f);
        float _2044 = float(_2013 >= _2035);
        float _2045 = mad(_2013 - _2035, _2044, _2035);
        float _2046 = mad(_2036 - _2036, _2044, _2036);
        float _2048 = mad(_2035 - _2013, _2044, _2013);
        float _2050 = _2045 - min(_2048, _2046);
        float4 _2074 = t11.SampleLevel(s9, float3(abs(mad(mad(_2034, 1.0f, -1.0f) - _2038, _2044, _2038) + ((_2048 - _2046) / mad(_2050, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_2024 + _2024)), (1.0f / (_2027 + _2027)) + (_2050 / (_2045 + 9.9999997473787516355514526367188e-05f)), mad(_2045 * 3.0f, 1.0f / mad(_2045, 3.0f, 1.5f), 1.0f / (_2030 + _2030))), 0.0f);
        float _2075 = _2074.x;
        float _2076 = _2074.y;
        float _2077 = _2074.z;
        float3 _2105 = float3(mad(_2077, mad(_2076, clamp(abs(mad(frac(_2075 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_2075 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _2076, 1.0f), _2077, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_2075 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _2076, 1.0f), _2077, -3.5073844628641381859779357910156e-05f));
        float3 _2109 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _2105), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _2105), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _2105));
        float3 _2113 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _2109), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _2109), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _2109));
        float _2122 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _2113) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _2133 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _2113) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _2143 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _2113) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_1406] = float4(min(exp2(log2(mad(_2122, 18.8515625f, 0.8359375f) / mad(_2122, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_2133, 18.8515625f, 0.8359375f) / mad(_2133, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_2143, 18.8515625f, 0.8359375f) / mad(_2143, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

#include "../common.hlsl"
struct _350
{
    uint2 _m0;
    uint _m1;
};

struct _2017
{
    uint3 _m0;
    uint _m1;
};

static const float _2151[30] = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
static const float _64[10][30] = { { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f } };
static const float _69[1] = { 0.0f };
static const float4 _277[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _341 = a.x * b.x;
    return mad(a.y, b.y, _341);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _327 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _327));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _309 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _309)));
}

void comp_main()
{
    uint _349_dummy_parameter;
    _350 _351 = { spvImageSize(u0, _349_dummy_parameter), 1u };
    uint _363 = gl_GlobalInvocationID.x - gl_LocalInvocationID.x;
    uint _364 = gl_GlobalInvocationID.y - gl_LocalInvocationID.y;
    uint _366 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _367 = spvBitfieldUExtract(_366, 1u, 3u);
    uint _369 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _366, 0u, 1u);
    uint _370 = _363 + _367;
    uint _371 = _369 + _364;
    float _376 = float(_351._m0.x);
    float _377 = float(_351._m0.y);
    float _378 = (float(_370) + 0.5f) / _376;
    float _379 = (float(_371) + 0.5f) / _377;
    bool _388 = cb1_m3.y == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _388) && (gl_LocalInvocationID.y == 0u))
    {
        g1[0u] = t8.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    if (_366 < 36u)
    {
        bool _416 = _366 < 4u;
        bool _417 = _366 < 12u;
        bool _418 = _366 < 20u;
        bool _419 = _366 < 28u;
        uint _430 = _416 ? ((_366 >> 1u) * 9u) : (_417 ? 0u : (_418 ? 9u : (_419 ? (((_366 - 20u) & 7u) + 1u) : (((_366 - 28u) & 7u) + 1u))));
        uint _431 = _416 ? ((_366 & 1u) * 9u) : (_417 ? (((_366 - 4u) & 7u) + 1u) : (_418 ? (((_366 - 12u) & 7u) + 1u) : (_419 ? 0u : 9u)));
        float _432 = 1.0f / _376;
        float _433 = 1.0f / _377;
        float _452 = clamp((_432 * (float(int(_430 - 1u)) + 0.5f)) + (_432 * float(int(_363))), 0.0f, 1.0f);
        float _453 = clamp(((float(int(_431 - 1u)) + 0.5f) * _433) + (float(int(_364)) * _433), 0.0f, 1.0f);
        float2 _456 = float2(_452, _453);
        float _461 = mad(t6.SampleLevel(s5, _456, 0.0f).x, 2.0f, -1.0f);
        float _476;
        if (_461 > 0.0f)
        {
            _476 = min(sqrt(_461), t0.Load(8u).x);
        }
        else
        {
            _476 = max(_461, -t0.Load(7u).x);
        }
        float4 _480 = t5.SampleLevel(s4, _456, 0.0f);
        float2 _490 = float2(_480.x * cb1_m2.z, _480.y * cb1_m2.w);
        bool _503 = (cb1_m9.x != 0.0f) && (cb1_m9.y != 0.0f);
        bool _507 = (cb1_m7.w != 0.0f) && (cb1_m8.x != 0.0f);
        float _519 = exp2(max(_503 ? clamp((sqrt(dp2_f32(_490, _490)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _507 ? clamp((abs(_476) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float _521 = _452 - 0.5f;
        float _522 = _453 - 0.5f;
        float2 _523 = float2(_521, _522);
        float _527 = mad(cb1_m20, dp2_f32(_523, _523), 1.0f);
        float _549 = mad(exp2(log2(clamp(cb1_m20, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(cb1_m21.x, -0.089999973773956298828125f, 1.0f);
        float _550 = (_527 * mad(mad(cb1_m21.y, -0.001999996602535247802734375f, 0.092000000178813934326171875f), cb1_m21.x, 1.0f)) * _549;
        float _551 = _549 * (_527 * mad(mad(cb1_m21.y, 0.04500000178813934326171875f, 0.046999998390674591064453125f), cb1_m21.x, 1.0f));
        float _552 = _549 * (_527 * mad(mad(cb1_m21.y, 0.0f, 0.04500000178813934326171875f), cb1_m21.x, 1.0f));
        float _553 = mad(_521, _550, 0.5f);
        float _554 = mad(_550, _522, 0.5f);
        float _555 = mad(_521, _551, 0.5f);
        float _556 = mad(_551, _522, 0.5f);
        float2 _559 = float2(_553, _554);
        float4 _561 = t1.SampleLevel(s0, _559, 0.0f);
        float _562 = _561.x;
        bool _563 = _507 || _503;
        float _597;
        if (_563)
        {
            float4 _569 = t2.SampleLevel(s1, _559, 0.0f);
            float _570 = _569.x;
            float _578 = asfloat(cb0_m[43u].w) * 20.0f;
            float _594 = mad(mad(t9.SampleLevel(s7, float2(mad(_553, 30.0f, sin(_578)), mad(_554, 30.0f, cos(_578))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_570, max(_569.y, _569.z)), 1.0000000133514319600180897396058e-10f)), _570);
            _597 = mad(_519, _562 - _594, _594);
        }
        else
        {
            _597 = _562;
        }
        float2 _598 = float2(_555, _556);
        float4 _600 = t1.SampleLevel(s0, _598, 0.0f);
        float _601 = _600.y;
        float _634;
        if (_563)
        {
            float4 _607 = t2.SampleLevel(s1, _598, 0.0f);
            float _609 = _607.y;
            float _615 = asfloat(cb0_m[43u].w) * 20.0f;
            float _631 = mad(mad(t9.SampleLevel(s7, float2(mad(_555, 30.0f, sin(_615)), mad(_556, 30.0f, cos(_615))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_607.x, max(_609, _607.z)), 1.0000000133514319600180897396058e-10f)), _609);
            _634 = mad(_519, _601 - _631, _631);
        }
        else
        {
            _634 = _601;
        }
        float _635 = mad(_521, _552, 0.5f);
        float _636 = mad(_552, _522, 0.5f);
        float2 _637 = float2(_635, _636);
        float4 _639 = t1.SampleLevel(s0, _637, 0.0f);
        float _640 = _639.z;
        float _673;
        if (_563)
        {
            float4 _646 = t2.SampleLevel(s1, _637, 0.0f);
            float _649 = _646.z;
            float _654 = asfloat(cb0_m[43u].w) * 20.0f;
            float _670 = mad(mad(t9.SampleLevel(s7, float2(mad(_635, 30.0f, sin(_654)), mad(_636, 30.0f, cos(_654))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_646.x, max(_646.y, _649)), 1.0000000133514319600180897396058e-10f)), _649);
            _673 = mad(_519, _640 - _670, _670);
        }
        else
        {
            _673 = _640;
        }
        float _678 = _388 ? g1[0u] : cb1_m3.x;
        float4 _682 = t7.SampleLevel(s6, _456, 0.0f);
        float _683 = _682.x;
        float _691 = max(cb1_m3.w - dp3_f32(float3(_683, _682.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
        float _695 = mad(_597, _678, _683 / _691);
        float _696 = mad(_634, _678, _682.y / _691);
        float _697 = mad(_673, _678, _682.z / _691);
        float _701 = 1.0f / (max(_695, max(_697, _696)) + 1.0f);
        float _702 = _695 * _701;
        float _704 = _701 * _697;
        float3 _705 = float3(_702, _704, _701 * _696);
        uint _710 = (_431 * 12u) >> 2u;
        g0[_430][_710] = dp3_f32(_705, float3(0.25f, 0.25f, 0.5f));
        uint _713 = _710 + 1u;
        g0[_430][_713] = dp2_f32(float2(_702, _704), float2(0.5f, -0.5f));
        uint _716 = _710 + 2u;
        g0[_430][_716] = dp3_f32(_705, float3(-0.25f, -0.25f, 0.5f));
    }
    float2 _721 = float2(_378, _379);
    float _725 = mad(t6.SampleLevel(s5, _721, 0.0f).x, 2.0f, -1.0f);
    float _740;
    if (_725 > 0.0f)
    {
        _740 = min(sqrt(_725), t0.Load(8u).x);
    }
    else
    {
        _740 = max(_725, -t0.Load(7u).x);
    }
    float4 _744 = t5.SampleLevel(s4, _721, 0.0f);
    float _745 = _744.x;
    float _746 = _744.y;
    float2 _757 = float2(_745 * cb1_m2.z, _746 * cb1_m2.w);
    bool _769 = (cb1_m9.x != 0.0f) && (cb1_m9.y != 0.0f);
    bool _773 = (cb1_m7.w != 0.0f) && (cb1_m8.x != 0.0f);
    float _777 = abs(_740);
    float _785 = exp2(max(_769 ? clamp((sqrt(dp2_f32(_757, _757)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _773 ? clamp((_777 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _786 = _378 - 0.5f;
    float _787 = _379 - 0.5f;
    float2 _788 = float2(_786, _787);
    float _789 = dp2_f32(_788, _788);
    float _792 = mad(cb1_m20, _789, 1.0f);
    float _814 = mad(exp2(log2(clamp(cb1_m20, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(cb1_m21.x, -0.089999973773956298828125f, 1.0f);
    float _815 = (_792 * mad(mad(cb1_m21.y, -0.001999996602535247802734375f, 0.092000000178813934326171875f), cb1_m21.x, 1.0f)) * _814;
    float _816 = _814 * (_792 * mad(mad(cb1_m21.y, 0.04500000178813934326171875f, 0.046999998390674591064453125f), cb1_m21.x, 1.0f));
    float _817 = _814 * (_792 * mad(cb1_m21.x, mad(cb1_m21.y, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _818 = mad(_786, _815, 0.5f);
    float _819 = mad(_815, _787, 0.5f);
    float _820 = mad(_786, _816, 0.5f);
    float _821 = mad(_787, _816, 0.5f);
    float2 _824 = float2(_818, _819);
    float4 _826 = t1.SampleLevel(s0, _824, 0.0f);
    float _827 = _826.x;
    bool _828 = _773 || _769;
    float _861;
    if (_828)
    {
        float4 _834 = t2.SampleLevel(s1, _824, 0.0f);
        float _835 = _834.x;
        float _842 = asfloat(cb0_m[43u].w) * 20.0f;
        float _858 = mad(mad(t9.SampleLevel(s7, float2(mad(_818, 30.0f, sin(_842)), mad(_819, 30.0f, cos(_842))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_835, max(_834.y, _834.z)), 1.0000000133514319600180897396058e-10f)), _835);
        _861 = mad(_785, _827 - _858, _858);
    }
    else
    {
        _861 = _827;
    }
    float2 _862 = float2(_820, _821);
    float4 _864 = t1.SampleLevel(s0, _862, 0.0f);
    float _865 = _864.y;
    float _898;
    if (_828)
    {
        float4 _871 = t2.SampleLevel(s1, _862, 0.0f);
        float _873 = _871.y;
        float _879 = asfloat(cb0_m[43u].w) * 20.0f;
        float _895 = mad(mad(t9.SampleLevel(s7, float2(mad(_820, 30.0f, sin(_879)), mad(_821, 30.0f, cos(_879))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_871.x, max(_873, _871.z)), 1.0000000133514319600180897396058e-10f)), _873);
        _898 = mad(_785, _865 - _895, _895);
    }
    else
    {
        _898 = _865;
    }
    float _899 = mad(_786, _817, 0.5f);
    float _900 = mad(_787, _817, 0.5f);
    float2 _901 = float2(_899, _900);
    float4 _903 = t1.SampleLevel(s0, _901, 0.0f);
    float _904 = _903.z;
    float _937;
    if (_828)
    {
        float4 _910 = t2.SampleLevel(s1, _901, 0.0f);
        float _913 = _910.z;
        float _918 = asfloat(cb0_m[43u].w) * 20.0f;
        float _934 = mad(mad(t9.SampleLevel(s7, float2(mad(_899, 30.0f, sin(_918)), mad(_900, 30.0f, cos(_918))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_910.x, max(_910.y, _913)), 1.0000000133514319600180897396058e-10f)), _913);
        _937 = mad(_785, _904 - _934, _934);
    }
    else
    {
        _937 = _904;
    }
    float _942 = _388 ? g1[0u] : cb1_m3.x;
    float4 _946 = t7.SampleLevel(s6, _721, 0.0f);
    float _947 = _946.x;
    float _955 = max(cb1_m3.w - dp3_f32(float3(_947, _946.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _959 = mad(_942, _861, _947 / _955);
    float _960 = mad(_942, _898, _946.y / _955);
    float _961 = mad(_942, _937, _946.z / _955);
    float _965 = 1.0f / (max(_959, max(_961, _960)) + 1.0f);
    float _966 = _959 * _965;
    float _968 = _961 * _965;
    float3 _969 = float3(_966, _968, _960 * _965);
    float _970 = dp3_f32(_969, float3(0.25f, 0.25f, 0.5f));
    float _971 = dp3_f32(_969, float3(-0.25f, -0.25f, 0.5f));
    float _973 = dp2_f32(float2(_966, _968), float2(0.5f, -0.5f));
    uint _974 = _367 + 1u;
    uint _975 = _367 + 2u;
    uint _976 = _369 * 12u;
    uint _979 = (_976 + 12u) >> 2u;
    g0[_974][_979] = _970;
    uint _982 = _979 + 1u;
    g0[_974][_982] = _973;
    uint _985 = _979 + 2u;
    g0[_974][_985] = _971;
    float2 _988 = float2(_745 * cb1_m2.x, _746 * cb1_m2.y);
    float _992 = min(sqrt(dp2_f32(_988, _988)) * 0.07500000298023223876953125f, 1.0f);
    float _993 = _378 - _745;
    float _994 = _379 - _746;
    float _1002 = (max(abs(mad(_994, 2.0f, -1.0f)), abs(mad(_993, 2.0f, -1.0f))) >= 1.0f) ? (-_992) : _992;
    float _1009 = floor(mad(cb1_m2.x, _993, -0.5f));
    float _1010 = floor(mad(_994, cb1_m2.y, -0.5f));
    float _1011 = _1009 + 0.5f;
    float _1012 = _1010 + 0.5f;
    float _1016 = mad(cb1_m2.x, _993, -_1011);
    float _1018 = mad(_994, cb1_m2.y, -_1012);
    float _1020 = mad(-cb1_m2.x, _993, _1011);
    float _1022 = mad(-_994, cb1_m2.y, _1012);
    float _1029 = mad(_1016, mad(_1020, 1.5f, 2.0f), 0.5f);
    float _1030 = mad(mad(_1022, 1.5f, 2.0f), _1018, 0.5f);
    float _1031 = _1016 * _1016;
    float _1032 = _1018 * _1018;
    float _1037 = _1031 * mad(_1016, 0.5f, -0.5f);
    float _1038 = mad(_1018, 0.5f, -0.5f) * _1032;
    float _1041 = _1016 * mad(_1016, mad(_1020, 0.5f, 1.0f), -0.5f);
    float _1042 = mad(mad(_1022, 0.5f, 1.0f), _1018, -0.5f) * _1018;
    float _1045 = mad(_1016, _1029, mad(_1031, mad(_1016, 1.5f, -2.5f), 1.0f));
    float _1046 = mad(_1030, _1018, mad(mad(_1018, 1.5f, -2.5f), _1032, 1.0f));
    float _1053 = (_1009 - 0.5f) / cb1_m2.x;
    float _1054 = (_1010 - 0.5f) / cb1_m2.y;
    float _1055 = (_1009 + 2.5f) / cb1_m2.x;
    float _1056 = (_1010 + 2.5f) / cb1_m2.y;
    float _1057 = (_1012 + ((_1030 * _1018) / _1046)) / cb1_m2.y;
    float _1058 = (_1011 + ((_1016 * _1029) / _1045)) / cb1_m2.x;
    float4 _1063 = t3.SampleLevel(s2, float2(_1053, _1054), 0.0f);
    float4 _1072 = t3.SampleLevel(s2, float2(_1055, _1054), 0.0f);
    float4 _1090 = t3.SampleLevel(s2, float2(_1058, _1054), 0.0f);
    float4 _1102 = t3.SampleLevel(s2, float2(_1053, _1057), 0.0f);
    float4 _1114 = t3.SampleLevel(s2, float2(_1058, _1057), 0.0f);
    float4 _1126 = t3.SampleLevel(s2, float2(_1055, _1057), 0.0f);
    float4 _1138 = t3.SampleLevel(s2, float2(_1053, _1056), 0.0f);
    float4 _1150 = t3.SampleLevel(s2, float2(_1058, _1056), 0.0f);
    float4 _1162 = t3.SampleLevel(s2, float2(_1055, _1056), 0.0f);
    float _1169 = mad(_1037 * _1162.x, _1038, mad(_1045 * _1150.x, _1038, mad(_1041 * _1138.x, _1038, mad(_1037 * _1126.x, _1046, mad(_1045 * _1114.x, _1046, mad(_1041 * _1102.x, _1046, mad(_1045 * _1090.x, _1042, ((_1037 * _1072.x) * _1042) + ((_1041 * _1063.x) * _1042))))))));
    float _1171 = mad(_1037 * _1162.z, _1038, mad(_1045 * _1150.z, _1038, mad(_1041 * _1138.z, _1038, mad(_1037 * _1126.z, _1046, mad(_1045 * _1114.z, _1046, mad(_1041 * _1102.z, _1046, mad(_1045 * _1090.z, _1042, ((_1041 * _1063.z) * _1042) + ((_1037 * _1072.z) * _1042))))))));
    float3 _1172 = float3(_1169, _1171, mad(_1037 * _1162.y, _1038, mad(_1045 * _1150.y, _1038, mad(_1041 * _1138.y, _1038, mad(_1037 * _1126.y, _1046, mad(_1045 * _1114.y, _1046, mad(_1041 * _1102.y, _1046, mad(_1045 * _1090.y, _1042, ((_1041 * _1063.y) * _1042) + ((_1037 * _1072.y) * _1042)))))))));
    float _1173 = dp3_f32(_1172, float3(0.25f, 0.25f, 0.5f));
    float _1174 = dp3_f32(_1172, float3(-0.25f, -0.25f, 0.5f));
    float _1176 = dp2_f32(float2(_1169, _1171), float2(0.5f, -0.5f));
    GroupMemoryBarrierWithGroupSync();
    uint _1177 = _976 >> 2u;
    uint _1181 = _1177 + 1u;
    uint _1185 = _1177 + 2u;
    uint _1271 = (_976 + 24u) >> 2u;
    uint _1275 = _1271 + 1u;
    uint _1279 = _1271 + 2u;
    float _1300 = min(min(min(min(_970, g0[_974][_1177]), g0[_367][_979]), g0[_975][_979]), g0[_974][_1271]);
    float _1301 = max(max(max(max(_970, g0[_974][_1177]), g0[_367][_979]), g0[_975][_979]), g0[_974][_1271]);
    float _1319 = (((((((_970 + g0[_974][_1177]) + g0[_367][_1177]) + g0[_367][_979]) + g0[_975][_1177]) + g0[_975][_979]) + g0[_367][_1271]) + g0[_974][_1271]) + g0[_975][_1271];
    float _1333 = _1319 * 0.111111111938953399658203125f;
    float _1334 = (g0[_975][_1275] + (g0[_974][_1275] + (g0[_367][_1275] + (g0[_975][_982] + (g0[_975][_1181] + (g0[_367][_982] + (g0[_367][_1181] + (_973 + g0[_974][_1181])))))))) * 0.111111111938953399658203125f;
    float _1335 = (g0[_975][_1279] + (g0[_974][_1279] + (g0[_367][_1279] + (g0[_975][_985] + (g0[_975][_1185] + (g0[_367][_985] + (g0[_367][_1185] + (_971 + g0[_974][_1185])))))))) * 0.111111111938953399658203125f;
    float _1354 = mad(_1173 / max(mad(_1319, 0.111111111938953399658203125f, _1173), 1.0000000116860974230803549289703e-07f), 0.5f, 0.75f);
    float _1355 = sqrt(max((mad(g0[_975][_1271], g0[_975][_1271], mad(g0[_974][_1271], g0[_974][_1271], mad(g0[_367][_1271], g0[_367][_1271], mad(g0[_975][_979], g0[_975][_979], mad(g0[_975][_1177], g0[_975][_1177], mad(g0[_367][_979], g0[_367][_979], mad(g0[_367][_1177], g0[_367][_1177], (g0[_974][_1177] * g0[_974][_1177]) + (_970 * _970)))))))) * 0.111111111938953399658203125f) - (_1333 * _1333), 1.0000000133514319600180897396058e-10f)) * _1354;
    float _1356 = _1354 * sqrt(max((mad(g0[_975][_1275], g0[_975][_1275], mad(g0[_974][_1275], g0[_974][_1275], mad(g0[_367][_1275], g0[_367][_1275], mad(g0[_975][_982], g0[_975][_982], mad(g0[_975][_1181], g0[_975][_1181], mad(g0[_367][_982], g0[_367][_982], mad(g0[_367][_1181], g0[_367][_1181], (_973 * _973) + (g0[_974][_1181] * g0[_974][_1181])))))))) * 0.111111111938953399658203125f) - (_1334 * _1334), 1.0000000133514319600180897396058e-10f));
    float _1357 = _1354 * sqrt(max((mad(g0[_975][_1279], g0[_975][_1279], mad(g0[_974][_1279], g0[_974][_1279], mad(g0[_367][_1279], g0[_367][_1279], mad(g0[_975][_985], g0[_975][_985], mad(g0[_975][_1185], g0[_975][_1185], mad(g0[_367][_985], g0[_367][_985], mad(g0[_367][_1185], g0[_367][_1185], (_971 * _971) + (g0[_974][_1185] * g0[_974][_1185])))))))) * 0.111111111938953399658203125f) - (_1335 * _1335), 1.0000000133514319600180897396058e-10f));
    float _1361 = _1333 + _1355;
    float _1362 = _1356 + _1334;
    float _1363 = _1357 + _1335;
    float _1364 = (_1333 - _1355) + _1361;
    float _1365 = _1362 + (_1334 - _1356);
    float _1366 = _1363 + (_1335 - _1357);
    float _1376 = mad(_1364, -0.5f, _1173);
    float _1377 = mad(_1365, -0.5f, _1176);
    float _1378 = mad(_1366, -0.5f, _1174);
    float _1386 = max(max(abs(_1377 / mad((_1356 - _1334) + _1362, 0.5f, 9.9999997473787516355514526367188e-05f)), abs(_1376 / mad(_1361 + (_1355 - _1333), 0.5f, 9.9999997473787516355514526367188e-05f))), abs(_1378 / mad((_1357 - _1335) + _1363, 0.5f, 9.9999997473787516355514526367188e-05f)));
    bool _1387 = _1386 > 1.0f;
    uint2 _1405 = uint2(_370, _371);
    float _1409 = max((_1173 / ((_1173 + (mad(_1301, 0.5f, max(_1301 * 0.5f, max(max(max(max(_970, g0[_367][_1177]), g0[_975][_1177]), g0[_367][_1271]), g0[_975][_1271]) * 0.5f)) - mad(_1300, 0.5f, min(_1300 * 0.5f, min(min(min(min(_970, g0[_367][_1177]), g0[_975][_1177]), g0[_367][_1271]), g0[_975][_1271]) * 0.5f)))) + 1.0000000116860974230803549289703e-07f)) * mad(abs(_1002), 0.85000002384185791015625f, 0.100000001490116119384765625f), u2[_1405].x * 0.75f);
    bool _1410 = _1002 < 0.0f;
    float _1411 = _1410 ? _970 : (_1387 ? mad(_1364, 0.5f, _1376 / _1386) : _1173);
    float _1412 = _1410 ? _973 : (_1387 ? mad(_1365, 0.5f, _1377 / _1386) : _1176);
    float _1413 = _1410 ? _971 : (_1387 ? mad(_1366, 0.5f, _1378 / _1386) : _1174);
    float _1421 = clamp(mad(t4.SampleLevel(s3, _721, 0.0f).y, 1.0f - _1409, _1409), 0.0039215688593685626983642578125f, 0.949999988079071044921875f);
    float _1425 = mad(cb1_m0.x, 1.0f - _1421, _1421);
    float _1429 = mad(_1425, _970 - _1411, _1411);
    float _1430 = mad(_1425, _973 - _1412, _1412);
    float _1431 = mad(_1425, _971 - _1413, _1413);
    float _1432 = _1429 - _1431;
    float _1433 = _1432 + _1430;
    float _1434 = _1429 + _1431;
    float _1435 = _1432 - _1430;
    u1[_1405] = float4(_1433, _1434, _1435, 0.0f);
    u2[_1405] = _1425.xxxx;
    if (!((_351._m0.x < _370) || (_351._m0.y < _371)))
    {
        float _1443 = dp3_f32(float3(_1433, _1434, _1435), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1450 = cb1_m7.x * mad(-_777, cb1_m8.y, 1.0f);
        float _1454 = mad(_1450, _1433 - _1443, _1443);
        float _1455 = mad(_1450, _1434 - _1443, _1443);
        float _1456 = mad(_1450, _1435 - _1443, _1443);
        float _1457 = _787 + _787;
        float _1458 = _786 + _786;
        float _1459 = abs(_1458);
        float _1460 = abs(_1457);
        float _1464 = min(_1459, _1460) * (1.0f / max(_1459, _1460));
        float _1465 = _1464 * _1464;
        float _1469 = mad(_1465, mad(_1465, mad(_1465, mad(_1465, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1478 = mad(_1464, _1469, (_1459 < _1460) ? mad(_1464 * _1469, -2.0f, 1.57079637050628662109375f) : 0.0f) + (((-_1458) > _1458) ? (-3.1415927410125732421875f) : 0.0f);
        float _1479 = min(_1457, _1458);
        float _1480 = max(_1457, _1458);
        float _1487 = ((_1479 < (-_1479)) && (_1480 >= (-_1480))) ? (-_1478) : _1478;
        float4 _1491 = t10.SampleLevel(s8, _721, 0.0f);
        float _1492 = _1491.x;
        float _1493 = _1491.y;
        float _1494 = _1491.z;
        float _1495 = _1491.w;
        float _1500 = (_1455 - _1456) * 1.73205077648162841796875f;
        float _1502 = mad(_1454, 2.0f, -_1455);
        float _1503 = _1502 - _1456;
        float _1504 = abs(_1503);
        float _1505 = abs(_1500);
        float _1509 = min(_1504, _1505) * (1.0f / max(_1504, _1505));
        float _1510 = _1509 * _1509;
        float _1514 = mad(_1510, mad(_1510, mad(_1510, mad(_1510, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1523 = mad(_1509, _1514, (_1504 < _1505) ? mad(_1509 * _1514, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1503 < (_1456 - _1502)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1524 = min(_1500, _1503);
        float _1525 = max(_1500, _1503);
        float _1534 = ((_1454 == _1455) && (_1456 == _1455)) ? 0.0f : ((((_1524 < (-_1524)) && (_1525 >= (-_1525))) ? (-_1523) : _1523) * 57.295780181884765625f);
        float _1543 = mad(cb1_m23.y, -360.0f, (_1534 < 0.0f) ? (_1534 + 360.0f) : _1534);
        float _1553 = clamp(1.0f - (abs((_1543 < (-180.0f)) ? (_1543 + 360.0f) : ((_1543 > 180.0f) ? (_1543 - 360.0f) : _1543)) / (cb1_m23.z * 180.0f)), 0.0f, 1.0f);
        float _1558 = dp3_f32(float3(_1454, _1455, _1456), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1561 = (mad(_1553, -2.0f, 3.0f) * (_1553 * _1553)) * cb1_m23.w;
        float _1573 = mad(mad(_1561, _1454 - _1558, _1558) - _1454, cb1_m22, _1454);
        float _1574 = mad(mad(_1561, _1455 - _1558, _1558) - _1455, cb1_m22, _1455);
        float _1575 = mad(mad(_1561, _1456 - _1558, _1558) - _1456, cb1_m22, _1456);
        float _1577;
        _1577 = 0.0f;
        float _1578;
        uint _1581;
        uint _1580 = 0u;
        for (;;)
        {
            if (_1580 >= 8u)
            {
                break;
            }
            uint _1592 = min((_1580 & 3u), 4u);
            float _1612 = mad(float(_1580), 0.785398185253143310546875f, -_1487);
            float _1613 = _1612 + 1.57079637050628662109375f;
            _1578 = mad(_1495 * (dp4_f32(t12.Load((_1580 >> 2u) + 10u), float4(_277[_1592].x, _277[_1592].y, _277[_1592].z, _277[_1592].w)) * clamp((abs((_1613 > 3.1415927410125732421875f) ? (_1612 - 4.7123889923095703125f) : _1613) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _1577, _1577);
            _1581 = _1580 + 1u;
            _1577 = _1578;
            _1580 = _1581;
            continue;
        }
        float _1624 = clamp(_1577, 0.0f, 1.0f);
        float _1637 = asfloat(cb0_m[43u].w);
        float _1643 = abs(t12.Load(8u).x);
        float2 _1646 = float2(_786 * 1.40999996662139892578125f, _787 * 1.40999996662139892578125f);
        float _1648 = sqrt(dp2_f32(_1646, _1646));
        float _1649 = min(_1648, 1.0f);
        float _1650 = _1649 * _1649;
        float _1655 = clamp(_1648 - 0.5f, 0.0f, 1.0f);
        float _1658 = (_1649 * _1650) + (mad(-_1649, _1650, 1.0f) * (_1655 * _1655));
        float _1659 = mad(mad(mad(sin(_1637 * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _1643, -1.0f);
        float _1661 = _1493 + _1659;
        float _1663 = clamp((_1494 + _1659) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _1670 = clamp(_1661 + _1661, 0.0f, 1.0f);
        float _1680 = mad(sin(_1493 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f);
        float _1687 = dp3_f32(float3(t13.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1692 = mad(exp2(log2(abs(_1687)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _1696 = _1680 * (_1692 * 0.02999999932944774627685546875f);
        float _1697 = mad(_1643, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _1701 = mad(mad(-_1658, _1658, 1.0f), 1.0f - _1697, _1697);
        float _1702 = min((exp2(log2(_1658) * 0.699999988079071044921875f) * (mad(_1670, -2.0f, 3.0f) * (_1670 * _1670))) + (mad(_1663, -2.0f, 3.0f) * (_1663 * _1663)), 1.0f);
        float _1712 = mad(_1702, mad((_1680 * _1692) * 0.62000000476837158203125f, _1701, mad(_1573, _1624, -_1573)), mad(-_1573, _1624, _1573));
        float _1713 = mad(_1702, mad(_1701, _1696, mad(_1624, _1574, -_1574)), mad(-_1624, _1574, _1574));
        float _1714 = mad(_1702, mad(_1701, _1696, mad(_1624, _1575, -_1575)), mad(-_1624, _1575, _1575));
        float _1717 = mad(_1493, _1494 * (1.0f - _1495), _1495);
        float _1719;
        _1719 = 0.0f;
        float _1720;
        uint _1723;
        uint _1722 = 0u;
        for (;;)
        {
            if (int(_1722) >= 8)
            {
                break;
            }
            float4 _1730 = t12.Load(_1722);
            float _1732 = _1730.y;
            float _1734 = _1730.x - _1487;
            _1720 = mad(_1717 * (_1730.w * clamp(((_1732 - 3.1415927410125732421875f) + abs((_1734 > 3.1415927410125732421875f) ? (_1734 - 6.283185482025146484375f) : ((_1734 < (-3.1415927410125732421875f)) ? (_1734 + 6.283185482025146484375f) : _1734))) / max(_1732 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _1719, _1719);
            _1723 = _1722 + 1u;
            _1719 = _1720;
            _1722 = _1723;
            continue;
        }
        float _1753 = clamp(_1719 + _1719, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _1757 = mad(_1753, 0.310000002384185791015625f - _1712, _1712);
        float _1758 = mad(_1753, 0.014999999664723873138427734375f - _1713, _1713);
        float _1759 = mad(_1753, 0.014999999664723873138427734375f - _1714, _1714);
        float4 _1760 = t12.Load(12u);
        float _1761 = _1760.x;
        float _1789;
        float _1790;
        float _1791;
        if (_1761 != 0.0f)
        {
            float _1768 = clamp(_1687, 0.0f, 1.0f);
            float _1778 = clamp((_1492 + (_1761 - 1.0f)) / max(mad(_1761, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _1782 = clamp(_1761 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _1785 = mad(_1782, -2.0f, 3.0f) * (_1782 * _1782);
            _1789 = mad(_1785, _1778 * (_1768 * (_1492 * 0.930000007152557373046875f)), _1759);
            _1790 = mad(_1785, _1778 * (_1768 * (_1492 * 0.85000002384185791015625f)), _1758);
            _1791 = mad((_1768 * (_1492 * 0.790000021457672119140625f)) * _1778, _1785, _1757);
        }
        else
        {
            _1789 = _1759;
            _1790 = _1758;
            _1791 = _1757;
        }
        bool _1794 = cb1_m23.x > 0.0f;
        bool _1798 = frac((_379 * 420.0f) + (_1637 * 0.20000000298023223876953125f)) >= 0.5f;
        float _1799 = _1798 ? 0.300000011920928955078125f : 0.0f;
        float _1800 = _1799 * cb1_m23.x;
        float _1808 = _1794 ? mad(_1800, 0.0f - _1791, _1791) : _1791;
        float _1809 = _1794 ? mad(_1800, (_1798 ? 0.100000001490116119384765625f : 0.0f) - _1790, _1790) : _1790;
        float _1810 = _1794 ? mad(_1800, _1799 - _1789, _1789) : _1789;
        float _1815 = 1.0f / max(1.0f - max(max(_1810, _1809), _1808), 6.099999882280826568603515625e-05f);
        float _1822 = min(-(_1815 * _1808), 0.0f);
        float _1823 = min(-(_1815 * _1809), 0.0f);
        float _1824 = min(-(_1815 * _1810), 0.0f);
        float _1834 = clamp(-((sqrt(_789) - cb1_m6.x) * (1.0f / cb1_m6.y)), 0.0f, 1.0f);
        float _1835 = mad(_1834, -2.0f, 3.0f);
        float _1836 = _1834 * _1834;
        float _1837 = _1835 * _1836;
        float _1839 = mad(-_1835, _1836, 1.0f);
        float _1859 = cb1_m6.w * cb1_m6.z;
        float3 _1869 = float3(mad(_1822 + ((cb1_m4.x * _1839) - (_1822 * _1837)), _1859, -_1822), mad(_1859, ((cb1_m4.y * _1839) - (_1837 * _1823)) + _1823, -_1823), mad(_1859, ((cb1_m4.z * _1839) - (_1837 * _1824)) + _1824, -_1824));
#if 1
  float _1876 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1869) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1869), 65504.0f);
  float _1877 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1869) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1869), 65504.0f);
  float _1878 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1869) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1869), 65504.0f);
#endif
        float _1882 = max(max(_1877, _1876), _1878);
        float _1887 = (max(_1882, 9.9999997473787516355514526367188e-05f) - max(min(min(_1877, _1876), _1878), 9.9999997473787516355514526367188e-05f)) / max(_1882, 0.00999999977648258209228515625f);
        float _1898 = mad(sqrt(mad(_1876 - _1878, _1876, ((_1878 - _1877) * _1878) + ((_1877 - _1876) * _1877))), 1.75f, (_1878 + _1877) + _1876);
        float _1899 = _1887 - 0.4000000059604644775390625f;
        float _1904 = max(1.0f - abs(_1899 * 2.5f), 0.0f);
        float _1911 = mad(mad(clamp(mad(_1899, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1904, _1904, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1919 = ((_1898 <= 0.1599999964237213134765625f) ? _1911 : ((_1898 >= 0.4799999892711639404296875f) ? 0.0f : (_1911 * ((0.07999999821186065673828125f / (_1898 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1920 = _1876 * _1919;
        float _1921 = _1877 * _1919;
        float _1922 = _1878 * _1919;
        float _1927 = (_1921 - _1922) * 1.73205077648162841796875f;
        float _1929 = (_1920 * 2.0f) - _1921;
        float _1931 = mad(-_1878, _1919, _1929);
        float _1932 = abs(_1931);
        float _1933 = abs(_1927);
        float _1937 = min(_1932, _1933) * (1.0f / max(_1932, _1933));
        float _1938 = _1937 * _1937;
        float _1942 = mad(_1938, mad(_1938, mad(_1938, mad(_1938, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1952 = mad(_1937, _1942, (_1932 < _1933) ? mad(_1937 * _1942, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1931 < mad(_1878, _1919, -_1929)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1953 = min(_1927, _1931);
        float _1954 = max(_1927, _1931);
        float _1963 = ((_1922 == _1921) && (_1920 == _1921)) ? 0.0f : ((((_1953 < (-_1953)) && (_1954 >= (-_1954))) ? (-_1952) : _1952) * 57.295780181884765625f);
        float _1966 = (_1963 < 0.0f) ? (_1963 + 360.0f) : _1963;
        float _1976 = max(1.0f - abs(((_1966 < (-180.0f)) ? (_1966 + 360.0f) : ((_1966 > 180.0f) ? (_1966 - 360.0f) : _1966)) * 0.01481481455266475677490234375f), 0.0f);
        float _1979 = mad(_1976, -2.0f, 3.0f) * (_1976 * _1976);
        float3 _1990 = float3(clamp(_1920 + (((_1887 * (_1979 * _1979)) * mad(-_1876, _1919, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1921, 0.0f, 65504.0f), clamp(_1922, 0.0f, 65504.0f));
        float _1994 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1990), 0.0f, 65504.0f);
        float _1995 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1990), 0.0f, 65504.0f);
        float _1996 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1990), 0.0f, 65504.0f);

        float _1998 = dp3_f32(float3(_1994, _1995, _1996), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _2005 = float3(mad(_1994 - _1998, 0.959999978542327880859375f, _1998), mad(_1995 - _1998, 0.959999978542327880859375f, _1998), mad(_1996 - _1998, 0.959999978542327880859375f, _1998));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_1405] = float4(CustomACES(_2005), 1.f);
    return;
  }
#endif
        float3 _2009 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _2005), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _2005), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _2005));
        float _2010 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _2009);
        float _2011 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _2009);
        float _2012 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _2009);
        uint _2014;
        spvTextureSize(t11, 0u, _2014);
        bool _2015 = _2014 > 0u;
        uint _2016_dummy_parameter;
        _2017 _2018 = { spvTextureSize(t11, 0u, _2016_dummy_parameter), 1u };
        float _2021 = float(_2015 ? _2018._m0.x : 0u);
        float _2024 = float(_2015 ? _2018._m0.y : 0u);
        float _2027 = float(_2015 ? _2018._m0.z : 0u);
        float _2031 = float(_2011 >= _2012);
        float _2032 = mad(_2011 - _2012, _2031, _2012);
        float _2033 = mad(_2012 - _2011, _2031, _2011);
        float _2035 = mad(_2031, -1.0f, 0.666666686534881591796875f);
        float _2041 = float(_2010 >= _2032);
        float _2042 = mad(_2010 - _2032, _2041, _2032);
        float _2043 = mad(_2033 - _2033, _2041, _2033);
        float _2045 = mad(_2032 - _2010, _2041, _2010);
        float _2047 = _2042 - min(_2045, _2043);
        float4 _2071 = t11.SampleLevel(s9, float3(abs(mad(mad(_2031, 1.0f, -1.0f) - _2035, _2041, _2035) + ((_2045 - _2043) / mad(_2047, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_2021 + _2021)), (1.0f / (_2024 + _2024)) + (_2047 / (_2042 + 9.9999997473787516355514526367188e-05f)), mad(_2042 * 3.0f, 1.0f / mad(_2042, 3.0f, 1.5f), 1.0f / (_2027 + _2027))), 0.0f);
        float _2072 = _2071.x;
        float _2073 = _2071.y;
        float _2074 = _2071.z;
        float3 _2102 = float3(mad(_2074, mad(_2073, clamp(abs(mad(frac(_2072 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_2072 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _2073, 1.0f), _2074, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_2072 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _2073, 1.0f), _2074, -3.5073844628641381859779357910156e-05f));
        float3 _2106 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _2102), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _2102), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _2102));
        float3 _2110 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _2106), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _2106), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _2106));
        float _2119 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _2110) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _2130 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _2110) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _2140 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _2110) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_1405] = float4(min(exp2(log2(mad(_2119, 18.8515625f, 0.8359375f) / mad(_2119, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_2130, 18.8515625f, 0.8359375f) / mad(_2130, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_2140, 18.8515625f, 0.8359375f) / mad(_2140, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

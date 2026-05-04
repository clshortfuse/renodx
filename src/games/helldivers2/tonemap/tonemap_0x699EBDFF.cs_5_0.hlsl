#include "../common.hlsl"
struct _347
{
    uint2 _m0;
    uint _m1;
};

struct _1995
{
    uint3 _m0;
    uint _m1;
};

static const float _2129[30] = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
static const float _65[10][30] = { { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f }, { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f } };
static const float _70[1] = { 0.0f };
static const float4 _276[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _338 = a.x * b.x;
    return mad(a.y, b.y, _338);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _324 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _324));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _306 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _306)));
}

void comp_main()
{
    uint _346_dummy_parameter;
    _347 _348 = { spvImageSize(u0, _346_dummy_parameter), 1u };
    uint _360 = gl_GlobalInvocationID.x - gl_LocalInvocationID.x;
    uint _361 = gl_GlobalInvocationID.y - gl_LocalInvocationID.y;
    uint _363 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _364 = spvBitfieldUExtract(_363, 1u, 3u);
    uint _366 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _363, 0u, 1u);
    uint _367 = _360 + _364;
    uint _368 = _366 + _361;
    float _373 = float(_348._m0.x);
    float _374 = float(_348._m0.y);
    float _375 = (float(_367) + 0.5f) / _373;
    float _376 = (float(_368) + 0.5f) / _374;
    bool _385 = cb1_m3.y == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _385) && (gl_LocalInvocationID.y == 0u))
    {
        g1[0u] = t8.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    if (_363 < 36u)
    {
        bool _413 = _363 < 4u;
        bool _414 = _363 < 12u;
        bool _415 = _363 < 20u;
        bool _416 = _363 < 28u;
        uint _427 = _413 ? ((_363 >> 1u) * 9u) : (_414 ? 0u : (_415 ? 9u : (_416 ? (((_363 - 20u) & 7u) + 1u) : (((_363 - 28u) & 7u) + 1u))));
        uint _428 = _413 ? ((_363 & 1u) * 9u) : (_414 ? (((_363 - 4u) & 7u) + 1u) : (_415 ? (((_363 - 12u) & 7u) + 1u) : (_416 ? 0u : 9u)));
        float _429 = 1.0f / _373;
        float _430 = 1.0f / _374;
        float _449 = clamp((_429 * (float(int(_427 - 1u)) + 0.5f)) + (_429 * float(int(_360))), 0.0f, 1.0f);
        float _450 = clamp(((float(int(_428 - 1u)) + 0.5f) * _430) + (float(int(_361)) * _430), 0.0f, 1.0f);
        float2 _453 = float2(_449, _450);
        float _458 = mad(t6.SampleLevel(s5, _453, 0.0f).x, 2.0f, -1.0f);
        float _473;
        if (_458 > 0.0f)
        {
            _473 = min(sqrt(_458), t0.Load(8u).x);
        }
        else
        {
            _473 = max(_458, -t0.Load(7u).x);
        }
        float4 _477 = t5.SampleLevel(s4, _453, 0.0f);
        float2 _487 = float2(_477.x * cb1_m2.z, _477.y * cb1_m2.w);
        bool _500 = (cb1_m9.x != 0.0f) && (cb1_m9.y != 0.0f);
        bool _504 = (cb1_m7.w != 0.0f) && (cb1_m8.x != 0.0f);
        float _516 = exp2(max(_500 ? clamp((sqrt(dp2_f32(_487, _487)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _504 ? clamp((abs(_473) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float _518 = _449 - 0.5f;
        float _519 = _450 - 0.5f;
        float2 _520 = float2(_518, _519);
        float _524 = mad(cb1_m20, dp2_f32(_520, _520), 1.0f);
        float _546 = mad(exp2(log2(clamp(cb1_m20, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(cb1_m21.x, -0.089999973773956298828125f, 1.0f);
        float _547 = (_524 * mad(mad(cb1_m21.y, -0.001999996602535247802734375f, 0.092000000178813934326171875f), cb1_m21.x, 1.0f)) * _546;
        float _548 = _546 * (_524 * mad(mad(cb1_m21.y, 0.04500000178813934326171875f, 0.046999998390674591064453125f), cb1_m21.x, 1.0f));
        float _549 = _546 * (_524 * mad(mad(cb1_m21.y, 0.0f, 0.04500000178813934326171875f), cb1_m21.x, 1.0f));
        float _550 = mad(_518, _547, 0.5f);
        float _551 = mad(_547, _519, 0.5f);
        float _552 = mad(_518, _548, 0.5f);
        float _553 = mad(_548, _519, 0.5f);
        float2 _556 = float2(_550, _551);
        float4 _558 = t1.SampleLevel(s0, _556, 0.0f);
        float _559 = _558.x;
        bool _560 = _504 || _500;
        float _594;
        if (_560)
        {
            float4 _566 = t2.SampleLevel(s1, _556, 0.0f);
            float _567 = _566.x;
            float _575 = asfloat(cb0_m[43u].w) * 20.0f;
            float _591 = mad(mad(t9.SampleLevel(s7, float2(mad(_550, 30.0f, sin(_575)), mad(_551, 30.0f, cos(_575))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_567, max(_566.y, _566.z)), 1.0000000133514319600180897396058e-10f)), _567);
            _594 = mad(_516, _559 - _591, _591);
        }
        else
        {
            _594 = _559;
        }
        float2 _595 = float2(_552, _553);
        float4 _597 = t1.SampleLevel(s0, _595, 0.0f);
        float _598 = _597.y;
        float _631;
        if (_560)
        {
            float4 _604 = t2.SampleLevel(s1, _595, 0.0f);
            float _606 = _604.y;
            float _612 = asfloat(cb0_m[43u].w) * 20.0f;
            float _628 = mad(mad(t9.SampleLevel(s7, float2(mad(_552, 30.0f, sin(_612)), mad(_553, 30.0f, cos(_612))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_604.x, max(_606, _604.z)), 1.0000000133514319600180897396058e-10f)), _606);
            _631 = mad(_516, _598 - _628, _628);
        }
        else
        {
            _631 = _598;
        }
        float _632 = mad(_518, _549, 0.5f);
        float _633 = mad(_549, _519, 0.5f);
        float2 _634 = float2(_632, _633);
        float4 _636 = t1.SampleLevel(s0, _634, 0.0f);
        float _637 = _636.z;
        float _670;
        if (_560)
        {
            float4 _643 = t2.SampleLevel(s1, _634, 0.0f);
            float _646 = _643.z;
            float _651 = asfloat(cb0_m[43u].w) * 20.0f;
            float _667 = mad(mad(t9.SampleLevel(s7, float2(mad(_632, 30.0f, sin(_651)), mad(_633, 30.0f, cos(_651))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_643.x, max(_643.y, _646)), 1.0000000133514319600180897396058e-10f)), _646);
            _670 = mad(_516, _637 - _667, _667);
        }
        else
        {
            _670 = _637;
        }
        float _675 = _385 ? g1[0u] : cb1_m3.x;
        float4 _679 = t7.SampleLevel(s6, _453, 0.0f);
        float _680 = _679.x;
        float _688 = max(cb1_m3.w - dp3_f32(float3(_680, _679.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
        float _692 = mad(_675, _594, _680 / _688);
        float _693 = mad(_675, _631, _679.y / _688);
        float _694 = mad(_675, _670, _679.z / _688);
        float _698 = 1.0f / (max(_692, max(_694, _693)) + 1.0f);
        float _699 = _692 * _698;
        float _701 = _698 * _694;
        float3 _702 = float3(_699, _701, _698 * _693);
        uint _707 = (_428 * 12u) >> 2u;
        g0[_427][_707] = dp3_f32(_702, float3(0.25f, 0.25f, 0.5f));
        uint _710 = _707 + 1u;
        g0[_427][_710] = dp2_f32(float2(_699, _701), float2(0.5f, -0.5f));
        uint _713 = _707 + 2u;
        g0[_427][_713] = dp3_f32(_702, float3(-0.25f, -0.25f, 0.5f));
    }
    float2 _718 = float2(_375, _376);
    float _722 = mad(t6.SampleLevel(s5, _718, 0.0f).x, 2.0f, -1.0f);
    float _737;
    if (_722 > 0.0f)
    {
        _737 = min(sqrt(_722), t0.Load(8u).x);
    }
    else
    {
        _737 = max(_722, -t0.Load(7u).x);
    }
    float4 _741 = t5.SampleLevel(s4, _718, 0.0f);
    float _742 = _741.x;
    float _743 = _741.y;
    float2 _754 = float2(_742 * cb1_m2.z, _743 * cb1_m2.w);
    bool _766 = (cb1_m9.x != 0.0f) && (cb1_m9.y != 0.0f);
    bool _770 = (cb1_m7.w != 0.0f) && (cb1_m8.x != 0.0f);
    float _774 = abs(_737);
    float _782 = exp2(max(_766 ? clamp((sqrt(dp2_f32(_754, _754)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _770 ? clamp((_774 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _783 = _375 - 0.5f;
    float _784 = _376 - 0.5f;
    float2 _785 = float2(_783, _784);
    float _786 = dp2_f32(_785, _785);
    float _789 = mad(cb1_m20, _786, 1.0f);
    float _811 = mad(exp2(log2(clamp(cb1_m20, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(cb1_m21.x, -0.089999973773956298828125f, 1.0f);
    float _812 = (_789 * mad(mad(cb1_m21.y, -0.001999996602535247802734375f, 0.092000000178813934326171875f), cb1_m21.x, 1.0f)) * _811;
    float _813 = _811 * (_789 * mad(cb1_m21.x, mad(cb1_m21.y, 0.04500000178813934326171875f, 0.046999998390674591064453125f), 1.0f));
    float _814 = _811 * (_789 * mad(cb1_m21.x, mad(cb1_m21.y, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _815 = mad(_783, _812, 0.5f);
    float _816 = mad(_812, _784, 0.5f);
    float _817 = mad(_783, _813, 0.5f);
    float _818 = mad(_813, _784, 0.5f);
    float2 _821 = float2(_815, _816);
    float4 _823 = t1.SampleLevel(s0, _821, 0.0f);
    float _824 = _823.x;
    bool _825 = _770 || _766;
    float _858;
    if (_825)
    {
        float4 _831 = t2.SampleLevel(s1, _821, 0.0f);
        float _832 = _831.x;
        float _839 = asfloat(cb0_m[43u].w) * 20.0f;
        float _855 = mad(mad(t9.SampleLevel(s7, float2(mad(_815, 30.0f, sin(_839)), mad(_816, 30.0f, cos(_839))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_832, max(_831.y, _831.z)), 1.0000000133514319600180897396058e-10f)), _832);
        _858 = mad(_782, _824 - _855, _855);
    }
    else
    {
        _858 = _824;
    }
    float2 _859 = float2(_817, _818);
    float4 _861 = t1.SampleLevel(s0, _859, 0.0f);
    float _862 = _861.y;
    float _895;
    if (_825)
    {
        float4 _868 = t2.SampleLevel(s1, _859, 0.0f);
        float _870 = _868.y;
        float _876 = asfloat(cb0_m[43u].w) * 20.0f;
        float _892 = mad(mad(t9.SampleLevel(s7, float2(mad(_817, 30.0f, sin(_876)), mad(_818, 30.0f, cos(_876))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_868.x, max(_870, _868.z)), 1.0000000133514319600180897396058e-10f)), _870);
        _895 = mad(_782, _862 - _892, _892);
    }
    else
    {
        _895 = _862;
    }
    float _896 = mad(_783, _814, 0.5f);
    float _897 = mad(_814, _784, 0.5f);
    float2 _898 = float2(_896, _897);
    float4 _900 = t1.SampleLevel(s0, _898, 0.0f);
    float _901 = _900.z;
    float _934;
    if (_825)
    {
        float4 _907 = t2.SampleLevel(s1, _898, 0.0f);
        float _910 = _907.z;
        float _915 = asfloat(cb0_m[43u].w) * 20.0f;
        float _931 = mad(mad(t9.SampleLevel(s7, float2(mad(_896, 30.0f, sin(_915)), mad(_897, 30.0f, cos(_915))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_907.x, max(_907.y, _910)), 1.0000000133514319600180897396058e-10f)), _910);
        _934 = mad(_782, _901 - _931, _931);
    }
    else
    {
        _934 = _901;
    }
    float _939 = _385 ? g1[0u] : cb1_m3.x;
    float4 _943 = t7.SampleLevel(s6, _718, 0.0f);
    float _944 = _943.x;
    float _952 = max(cb1_m3.w - dp3_f32(float3(_944, _943.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _956 = mad(_858, _939, _944 / _952);
    float _957 = mad(_895, _939, _943.y / _952);
    float _958 = mad(_934, _939, _943.z / _952);
    float _962 = 1.0f / (max(_956, max(_958, _957)) + 1.0f);
    float _963 = _956 * _962;
    float _965 = _958 * _962;
    float3 _966 = float3(_963, _965, _957 * _962);
    float _967 = dp3_f32(_966, float3(0.25f, 0.25f, 0.5f));
    float _968 = dp3_f32(_966, float3(-0.25f, -0.25f, 0.5f));
    float _970 = dp2_f32(float2(_963, _965), float2(0.5f, -0.5f));
    uint _971 = _364 + 1u;
    uint _972 = _364 + 2u;
    uint _973 = _366 * 12u;
    uint _976 = (_973 + 12u) >> 2u;
    g0[_971][_976] = _967;
    uint _979 = _976 + 1u;
    g0[_971][_979] = _970;
    uint _982 = _976 + 2u;
    g0[_971][_982] = _968;
    float2 _985 = float2(_742 * cb1_m2.x, _743 * cb1_m2.y);
    float _989 = min(sqrt(dp2_f32(_985, _985)) * 0.07500000298023223876953125f, 1.0f);
    float _990 = _375 - _742;
    float _991 = _376 - _743;
    float _999 = (max(abs(mad(_991, 2.0f, -1.0f)), abs(mad(_990, 2.0f, -1.0f))) >= 1.0f) ? (-_989) : _989;
    float _1006 = floor(mad(cb1_m2.x, _990, -0.5f));
    float _1007 = floor(mad(_991, cb1_m2.y, -0.5f));
    float _1008 = _1006 + 0.5f;
    float _1009 = _1007 + 0.5f;
    float _1013 = mad(cb1_m2.x, _990, -_1008);
    float _1015 = mad(_991, cb1_m2.y, -_1009);
    float _1017 = mad(-cb1_m2.x, _990, _1008);
    float _1019 = mad(-_991, cb1_m2.y, _1009);
    float _1026 = mad(_1013, mad(_1017, 1.5f, 2.0f), 0.5f);
    float _1027 = mad(mad(_1019, 1.5f, 2.0f), _1015, 0.5f);
    float _1028 = _1013 * _1013;
    float _1029 = _1015 * _1015;
    float _1034 = _1028 * mad(_1013, 0.5f, -0.5f);
    float _1035 = mad(_1015, 0.5f, -0.5f) * _1029;
    float _1038 = _1013 * mad(_1013, mad(_1017, 0.5f, 1.0f), -0.5f);
    float _1039 = mad(mad(_1019, 0.5f, 1.0f), _1015, -0.5f) * _1015;
    float _1042 = mad(_1013, _1026, mad(_1028, mad(_1013, 1.5f, -2.5f), 1.0f));
    float _1043 = mad(_1027, _1015, mad(mad(_1015, 1.5f, -2.5f), _1029, 1.0f));
    float _1050 = (_1006 - 0.5f) / cb1_m2.x;
    float _1051 = (_1007 - 0.5f) / cb1_m2.y;
    float _1052 = (_1006 + 2.5f) / cb1_m2.x;
    float _1053 = (_1007 + 2.5f) / cb1_m2.y;
    float _1054 = (((_1027 * _1015) / _1043) + _1009) / cb1_m2.y;
    float _1055 = (_1008 + ((_1013 * _1026) / _1042)) / cb1_m2.x;
    float4 _1060 = t3.SampleLevel(s2, float2(_1050, _1051), 0.0f);
    float4 _1069 = t3.SampleLevel(s2, float2(_1052, _1051), 0.0f);
    float4 _1087 = t3.SampleLevel(s2, float2(_1055, _1051), 0.0f);
    float4 _1099 = t3.SampleLevel(s2, float2(_1050, _1054), 0.0f);
    float4 _1111 = t3.SampleLevel(s2, float2(_1055, _1054), 0.0f);
    float4 _1123 = t3.SampleLevel(s2, float2(_1052, _1054), 0.0f);
    float4 _1135 = t3.SampleLevel(s2, float2(_1050, _1053), 0.0f);
    float4 _1147 = t3.SampleLevel(s2, float2(_1055, _1053), 0.0f);
    float4 _1159 = t3.SampleLevel(s2, float2(_1052, _1053), 0.0f);
    float _1166 = mad(_1034 * _1159.x, _1035, mad(_1042 * _1147.x, _1035, mad(_1038 * _1135.x, _1035, mad(_1034 * _1123.x, _1043, mad(_1042 * _1111.x, _1043, mad(_1038 * _1099.x, _1043, mad(_1042 * _1087.x, _1039, ((_1034 * _1069.x) * _1039) + ((_1038 * _1060.x) * _1039))))))));
    float _1168 = mad(_1034 * _1159.z, _1035, mad(_1042 * _1147.z, _1035, mad(_1038 * _1135.z, _1035, mad(_1034 * _1123.z, _1043, mad(_1042 * _1111.z, _1043, mad(_1038 * _1099.z, _1043, mad(_1042 * _1087.z, _1039, ((_1038 * _1060.z) * _1039) + ((_1034 * _1069.z) * _1039))))))));
    float3 _1169 = float3(_1166, _1168, mad(_1034 * _1159.y, _1035, mad(_1042 * _1147.y, _1035, mad(_1038 * _1135.y, _1035, mad(_1034 * _1123.y, _1043, mad(_1042 * _1111.y, _1043, mad(_1038 * _1099.y, _1043, mad(_1042 * _1087.y, _1039, ((_1038 * _1060.y) * _1039) + ((_1034 * _1069.y) * _1039)))))))));
    float _1170 = dp3_f32(_1169, float3(0.25f, 0.25f, 0.5f));
    float _1171 = dp3_f32(_1169, float3(-0.25f, -0.25f, 0.5f));
    float _1173 = dp2_f32(float2(_1166, _1168), float2(0.5f, -0.5f));
    GroupMemoryBarrierWithGroupSync();
    uint _1174 = _973 >> 2u;
    uint _1178 = _1174 + 1u;
    uint _1182 = _1174 + 2u;
    uint _1268 = (_973 + 24u) >> 2u;
    uint _1272 = _1268 + 1u;
    uint _1276 = _1268 + 2u;
    float _1297 = min(min(min(min(_967, g0[_971][_1174]), g0[_364][_976]), g0[_972][_976]), g0[_971][_1268]);
    float _1298 = max(max(max(max(_967, g0[_971][_1174]), g0[_364][_976]), g0[_972][_976]), g0[_971][_1268]);
    float _1316 = (((((((_967 + g0[_971][_1174]) + g0[_364][_1174]) + g0[_364][_976]) + g0[_972][_1174]) + g0[_972][_976]) + g0[_364][_1268]) + g0[_971][_1268]) + g0[_972][_1268];
    float _1330 = _1316 * 0.111111111938953399658203125f;
    float _1331 = (g0[_972][_1272] + (g0[_971][_1272] + (g0[_364][_1272] + (g0[_972][_979] + (g0[_972][_1178] + (g0[_364][_979] + (g0[_364][_1178] + (_970 + g0[_971][_1178])))))))) * 0.111111111938953399658203125f;
    float _1332 = (g0[_972][_1276] + (g0[_971][_1276] + (g0[_364][_1276] + (g0[_972][_982] + (g0[_972][_1182] + (g0[_364][_982] + (g0[_364][_1182] + (_968 + g0[_971][_1182])))))))) * 0.111111111938953399658203125f;
    float _1351 = mad(_1170 / max(mad(_1316, 0.111111111938953399658203125f, _1170), 1.0000000116860974230803549289703e-07f), 0.5f, 0.75f);
    float _1352 = sqrt(max((mad(g0[_972][_1268], g0[_972][_1268], mad(g0[_971][_1268], g0[_971][_1268], mad(g0[_364][_1268], g0[_364][_1268], mad(g0[_972][_976], g0[_972][_976], mad(g0[_972][_1174], g0[_972][_1174], mad(g0[_364][_976], g0[_364][_976], mad(g0[_364][_1174], g0[_364][_1174], (g0[_971][_1174] * g0[_971][_1174]) + (_967 * _967)))))))) * 0.111111111938953399658203125f) - (_1330 * _1330), 1.0000000133514319600180897396058e-10f)) * _1351;
    float _1353 = _1351 * sqrt(max((mad(g0[_972][_1272], g0[_972][_1272], mad(g0[_971][_1272], g0[_971][_1272], mad(g0[_364][_1272], g0[_364][_1272], mad(g0[_972][_979], g0[_972][_979], mad(g0[_972][_1178], g0[_972][_1178], mad(g0[_364][_979], g0[_364][_979], mad(g0[_364][_1178], g0[_364][_1178], (_970 * _970) + (g0[_971][_1178] * g0[_971][_1178])))))))) * 0.111111111938953399658203125f) - (_1331 * _1331), 1.0000000133514319600180897396058e-10f));
    float _1354 = _1351 * sqrt(max((mad(g0[_972][_1276], g0[_972][_1276], mad(g0[_971][_1276], g0[_971][_1276], mad(g0[_364][_1276], g0[_364][_1276], mad(g0[_972][_982], g0[_972][_982], mad(g0[_972][_1182], g0[_972][_1182], mad(g0[_364][_982], g0[_364][_982], mad(g0[_364][_1182], g0[_364][_1182], (_968 * _968) + (g0[_971][_1182] * g0[_971][_1182])))))))) * 0.111111111938953399658203125f) - (_1332 * _1332), 1.0000000133514319600180897396058e-10f));
    float _1358 = _1330 + _1352;
    float _1359 = _1353 + _1331;
    float _1360 = _1354 + _1332;
    float _1361 = (_1330 - _1352) + _1358;
    float _1362 = _1359 + (_1331 - _1353);
    float _1363 = _1360 + (_1332 - _1354);
    float _1373 = mad(_1361, -0.5f, _1170);
    float _1374 = mad(_1362, -0.5f, _1173);
    float _1375 = mad(_1363, -0.5f, _1171);
    float _1383 = max(max(abs(_1374 / mad((_1353 - _1331) + _1359, 0.5f, 9.9999997473787516355514526367188e-05f)), abs(_1373 / mad(_1358 + (_1352 - _1330), 0.5f, 9.9999997473787516355514526367188e-05f))), abs(_1375 / mad((_1354 - _1332) + _1360, 0.5f, 9.9999997473787516355514526367188e-05f)));
    bool _1384 = _1383 > 1.0f;
    uint2 _1402 = uint2(_367, _368);
    float _1406 = max((_1170 / ((_1170 + (mad(_1298, 0.5f, max(_1298 * 0.5f, max(max(max(max(_967, g0[_364][_1174]), g0[_972][_1174]), g0[_364][_1268]), g0[_972][_1268]) * 0.5f)) - mad(_1297, 0.5f, min(_1297 * 0.5f, min(min(min(min(_967, g0[_364][_1174]), g0[_972][_1174]), g0[_364][_1268]), g0[_972][_1268]) * 0.5f)))) + 1.0000000116860974230803549289703e-07f)) * mad(abs(_999), 0.85000002384185791015625f, 0.100000001490116119384765625f), u2[_1402].x * 0.75f);
    bool _1407 = _999 < 0.0f;
    float _1408 = _1407 ? _967 : (_1384 ? mad(_1361, 0.5f, _1373 / _1383) : _1170);
    float _1409 = _1407 ? _970 : (_1384 ? mad(_1362, 0.5f, _1374 / _1383) : _1173);
    float _1410 = _1407 ? _968 : (_1384 ? mad(_1363, 0.5f, _1375 / _1383) : _1171);
    float _1418 = clamp(mad(t4.SampleLevel(s3, _718, 0.0f).y, 1.0f - _1406, _1406), 0.0039215688593685626983642578125f, 0.949999988079071044921875f);
    float _1422 = mad(1.0f - _1418, cb1_m0.x, _1418);
    float _1426 = mad(_1422, _967 - _1408, _1408);
    float _1427 = mad(_1422, _970 - _1409, _1409);
    float _1428 = mad(_1422, _968 - _1410, _1410);
    float _1429 = _1426 - _1428;
    float _1430 = _1429 + _1427;
    float _1431 = _1426 + _1428;
    float _1432 = _1429 - _1427;
    u1[_1402] = float4(_1430, _1431, _1432, 0.0f);
    u2[_1402] = _1422.xxxx;
    u3[_1402] = float4(_1426, _1427, _1428, _1426);
    if (!((_348._m0.x < _367) || (_348._m0.y < _368)))
    {
        float _1442 = dp3_f32(float3(_1430, _1431, _1432), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1449 = mad(-_774, cb1_m8.y, 1.0f) * cb1_m7.x;
        float _1453 = mad(_1449, _1430 - _1442, _1442);
        float _1454 = mad(_1449, _1431 - _1442, _1442);
        float _1455 = mad(_1449, _1432 - _1442, _1442);
        float _1456 = _784 + _784;
        float _1457 = _783 + _783;
        float _1458 = abs(_1457);
        float _1459 = abs(_1456);
        float _1463 = min(_1458, _1459) * (1.0f / max(_1458, _1459));
        float _1464 = _1463 * _1463;
        float _1468 = mad(_1464, mad(_1464, mad(_1464, mad(_1464, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1477 = mad(_1463, _1468, (_1458 < _1459) ? mad(_1463 * _1468, -2.0f, 1.57079637050628662109375f) : 0.0f) + (((-_1457) > _1457) ? (-3.1415927410125732421875f) : 0.0f);
        float _1478 = min(_1456, _1457);
        float _1479 = max(_1456, _1457);
        float _1486 = ((_1478 < (-_1478)) && (_1479 >= (-_1479))) ? (-_1477) : _1477;
        float4 _1490 = t10.SampleLevel(s8, _718, 0.0f);
        float _1491 = _1490.x;
        float _1492 = _1490.y;
        float _1493 = _1490.z;
        float _1494 = _1490.w;
        float _1499 = (_1454 - _1455) * 1.73205077648162841796875f;
        float _1501 = mad(_1453, 2.0f, -_1454);
        float _1502 = _1501 - _1455;
        float _1503 = abs(_1502);
        float _1504 = abs(_1499);
        float _1508 = min(_1503, _1504) * (1.0f / max(_1503, _1504));
        float _1509 = _1508 * _1508;
        float _1513 = mad(_1509, mad(_1509, mad(_1509, mad(_1509, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1522 = mad(_1508, _1513, (_1503 < _1504) ? mad(_1508 * _1513, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1502 < (_1455 - _1501)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1523 = min(_1499, _1502);
        float _1524 = max(_1499, _1502);
        float _1533 = ((_1453 == _1454) && (_1455 == _1454)) ? 0.0f : ((((_1523 < (-_1523)) && (_1524 >= (-_1524))) ? (-_1522) : _1522) * 57.295780181884765625f);
        float _1542 = mad(cb1_m23.x, -360.0f, (_1533 < 0.0f) ? (_1533 + 360.0f) : _1533);
        float _1552 = clamp(1.0f - (abs((_1542 < (-180.0f)) ? (_1542 + 360.0f) : ((_1542 > 180.0f) ? (_1542 - 360.0f) : _1542)) / (cb1_m23.y * 180.0f)), 0.0f, 1.0f);
        float _1557 = dp3_f32(float3(_1453, _1454, _1455), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1560 = cb1_m23.z * (mad(_1552, -2.0f, 3.0f) * (_1552 * _1552));
        float _1572 = mad(cb1_m22, mad(_1560, _1453 - _1557, _1557) - _1453, _1453);
        float _1573 = mad(cb1_m22, mad(_1560, _1454 - _1557, _1557) - _1454, _1454);
        float _1574 = mad(cb1_m22, mad(_1560, _1455 - _1557, _1557) - _1455, _1455);
        float _1576;
        _1576 = 0.0f;
        float _1577;
        uint _1580;
        uint _1579 = 0u;
        for (;;)
        {
            if (_1579 >= 8u)
            {
                break;
            }
            uint _1591 = min((_1579 & 3u), 4u);
            float _1611 = mad(float(_1579), 0.785398185253143310546875f, -_1486);
            float _1612 = _1611 + 1.57079637050628662109375f;
            _1577 = mad(_1494 * (dp4_f32(t12.Load((_1579 >> 2u) + 10u), float4(_276[_1591].x, _276[_1591].y, _276[_1591].z, _276[_1591].w)) * clamp((abs((_1612 > 3.1415927410125732421875f) ? (_1611 - 4.7123889923095703125f) : _1612) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _1576, _1576);
            _1580 = _1579 + 1u;
            _1576 = _1577;
            _1579 = _1580;
            continue;
        }
        float _1623 = clamp(_1576, 0.0f, 1.0f);
        float _1641 = abs(t12.Load(8u).x);
        float2 _1644 = float2(_783 * 1.40999996662139892578125f, _784 * 1.40999996662139892578125f);
        float _1646 = sqrt(dp2_f32(_1644, _1644));
        float _1647 = min(_1646, 1.0f);
        float _1648 = _1647 * _1647;
        float _1653 = clamp(_1646 - 0.5f, 0.0f, 1.0f);
        float _1656 = (_1647 * _1648) + (mad(-_1647, _1648, 1.0f) * (_1653 * _1653));
        float _1657 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _1641, -1.0f);
        float _1659 = _1492 + _1657;
        float _1661 = clamp((_1493 + _1657) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _1667 = clamp(_1659 + _1659, 0.0f, 1.0f);
        float _1685 = dp3_f32(float3(t13.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _1691 = mad(sin(_1492 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_1685)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _1693 = _1691 * 0.02999999932944774627685546875f;
        float _1694 = mad(_1641, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _1698 = mad(mad(-_1656, _1656, 1.0f), 1.0f - _1694, _1694);
        float _1699 = min((exp2(log2(_1656) * 0.699999988079071044921875f) * (mad(_1667, -2.0f, 3.0f) * (_1667 * _1667))) + ((_1661 * _1661) * mad(_1661, -2.0f, 3.0f)), 1.0f);
        float _1709 = mad(_1699, mad(_1698, _1691 * 0.62000000476837158203125f, mad(_1572, _1623, -_1572)), mad(-_1572, _1623, _1572));
        float _1710 = mad(_1699, mad(_1698, _1693, mad(_1623, _1573, -_1573)), mad(-_1623, _1573, _1573));
        float _1711 = mad(_1699, mad(_1698, _1693, mad(_1623, _1574, -_1574)), mad(-_1623, _1574, _1574));
        float _1714 = mad(_1492, _1493 * (1.0f - _1494), _1494);
        float _1716;
        _1716 = 0.0f;
        float _1717;
        uint _1720;
        uint _1719 = 0u;
        for (;;)
        {
            if (int(_1719) >= 8)
            {
                break;
            }
            float4 _1727 = t12.Load(_1719);
            float _1729 = _1727.y;
            float _1731 = _1727.x - _1486;
            _1717 = mad(_1714 * (_1727.w * clamp(((_1729 - 3.1415927410125732421875f) + abs((_1731 > 3.1415927410125732421875f) ? (_1731 - 6.283185482025146484375f) : ((_1731 < (-3.1415927410125732421875f)) ? (_1731 + 6.283185482025146484375f) : _1731))) / max(_1729 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _1716, _1716);
            _1720 = _1719 + 1u;
            _1716 = _1717;
            _1719 = _1720;
            continue;
        }
        float _1750 = clamp(_1716 + _1716, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _1754 = mad(_1750, 0.310000002384185791015625f - _1709, _1709);
        float _1755 = mad(_1750, 0.014999999664723873138427734375f - _1710, _1710);
        float _1756 = mad(_1750, 0.014999999664723873138427734375f - _1711, _1711);
        float4 _1757 = t12.Load(12u);
        float _1758 = _1757.x;
        float _1786;
        float _1787;
        float _1788;
        if (_1758 != 0.0f)
        {
            float _1765 = clamp(_1685, 0.0f, 1.0f);
            float _1775 = clamp((_1491 + (_1758 - 1.0f)) / max(mad(_1758, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _1779 = clamp(_1758 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _1782 = mad(_1779, -2.0f, 3.0f) * (_1779 * _1779);
            _1786 = mad((_1765 * (_1491 * 0.790000021457672119140625f)) * _1775, _1782, _1754);
            _1787 = mad(_1782, _1775 * (_1765 * (_1491 * 0.85000002384185791015625f)), _1755);
            _1788 = mad(_1782, _1775 * (_1765 * (_1491 * 0.930000007152557373046875f)), _1756);
        }
        else
        {
            _1786 = _1754;
            _1787 = _1755;
            _1788 = _1756;
        }
        float _1793 = 1.0f / max(1.0f - max(max(_1788, _1787), _1786), 6.099999882280826568603515625e-05f);
        float _1800 = min(-(_1793 * _1786), 0.0f);
        float _1801 = min(-(_1793 * _1787), 0.0f);
        float _1802 = min(-(_1793 * _1788), 0.0f);
        float _1812 = clamp(-((1.0f / cb1_m6.y) * (sqrt(_786) - cb1_m6.x)), 0.0f, 1.0f);
        float _1813 = mad(_1812, -2.0f, 3.0f);
        float _1814 = _1812 * _1812;
        float _1815 = _1813 * _1814;
        float _1817 = mad(-_1813, _1814, 1.0f);
        float _1837 = cb1_m6.w * cb1_m6.z;
        float3 _1847 = float3(mad(_1800 + ((cb1_m4.x * _1817) - (_1800 * _1815)), _1837, -_1800), mad(_1837, ((_1817 * cb1_m4.y) - (_1815 * _1801)) + _1801, -_1801), mad(_1837, ((cb1_m4.z * _1817) - (_1815 * _1802)) + _1802, -_1802));
#if 1
  float _1854 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1847) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1847), 65504.0f);
  float _1855 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1847) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1847), 65504.0f);
  float _1856 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1847) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1847), 65504.0f);
#endif
        float _1860 = max(max(_1855, _1854), _1856);
        float _1865 = (max(_1860, 9.9999997473787516355514526367188e-05f) - max(min(min(_1855, _1854), _1856), 9.9999997473787516355514526367188e-05f)) / max(_1860, 0.00999999977648258209228515625f);
        float _1876 = mad(sqrt(mad(_1854 - _1856, _1854, ((_1856 - _1855) * _1856) + ((_1855 - _1854) * _1855))), 1.75f, (_1856 + _1855) + _1854);
        float _1877 = _1865 - 0.4000000059604644775390625f;
        float _1882 = max(1.0f - abs(_1877 * 2.5f), 0.0f);
        float _1889 = mad(mad(clamp(mad(_1877, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1882, _1882, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1897 = ((_1876 <= 0.1599999964237213134765625f) ? _1889 : ((_1876 >= 0.4799999892711639404296875f) ? 0.0f : (_1889 * ((0.07999999821186065673828125f / (_1876 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1898 = _1897 * _1854;
        float _1899 = _1855 * _1897;
        float _1900 = _1856 * _1897;
        float _1905 = (_1899 - _1900) * 1.73205077648162841796875f;
        float _1907 = (_1898 * 2.0f) - _1899;
        float _1909 = mad(-_1856, _1897, _1907);
        float _1910 = abs(_1909);
        float _1911 = abs(_1905);
        float _1915 = min(_1910, _1911) * (1.0f / max(_1910, _1911));
        float _1916 = _1915 * _1915;
        float _1920 = mad(_1916, mad(_1916, mad(_1916, mad(_1916, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1930 = mad(_1915, _1920, (_1910 < _1911) ? mad(_1915 * _1920, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1909 < mad(_1856, _1897, -_1907)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1931 = min(_1905, _1909);
        float _1932 = max(_1905, _1909);
        float _1941 = ((_1900 == _1899) && (_1898 == _1899)) ? 0.0f : ((((_1931 < (-_1931)) && (_1932 >= (-_1932))) ? (-_1930) : _1930) * 57.295780181884765625f);
        float _1944 = (_1941 < 0.0f) ? (_1941 + 360.0f) : _1941;
        float _1954 = max(1.0f - abs(((_1944 < (-180.0f)) ? (_1944 + 360.0f) : ((_1944 > 180.0f) ? (_1944 - 360.0f) : _1944)) * 0.01481481455266475677490234375f), 0.0f);
        float _1957 = mad(_1954, -2.0f, 3.0f) * (_1954 * _1954);
        float3 _1968 = float3(clamp(_1898 + (((_1865 * (_1957 * _1957)) * mad(-_1897, _1854, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1899, 0.0f, 65504.0f), clamp(_1900, 0.0f, 65504.0f));
        float _1972 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1968), 0.0f, 65504.0f);
        float _1973 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1968), 0.0f, 65504.0f);
        float _1974 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1968), 0.0f, 65504.0f);

        float _1976 = dp3_f32(float3(_1972, _1973, _1974), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1983 = float3(mad(_1972 - _1976, 0.959999978542327880859375f, _1976), mad(_1973 - _1976, 0.959999978542327880859375f, _1976), mad(_1974 - _1976, 0.959999978542327880859375f, _1976));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_1402] = float4(CustomACES(_1983), 1.f);
    return;
  }
#endif
        float3 _1987 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1983), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1983), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1983));
        float _1988 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1987);
        float _1989 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1987);
        float _1990 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1987);
        uint _1992;
        spvTextureSize(t11, 0u, _1992);
        bool _1993 = _1992 > 0u;
        uint _1994_dummy_parameter;
        _1995 _1996 = { spvTextureSize(t11, 0u, _1994_dummy_parameter), 1u };
        float _1999 = float(_1993 ? _1996._m0.x : 0u);
        float _2002 = float(_1993 ? _1996._m0.y : 0u);
        float _2005 = float(_1993 ? _1996._m0.z : 0u);
        float _2009 = float(_1989 >= _1990);
        float _2010 = mad(_1989 - _1990, _2009, _1990);
        float _2011 = mad(_1990 - _1989, _2009, _1989);
        float _2013 = mad(_2009, -1.0f, 0.666666686534881591796875f);
        float _2019 = float(_1988 >= _2010);
        float _2020 = mad(_1988 - _2010, _2019, _2010);
        float _2021 = mad(_2011 - _2011, _2019, _2011);
        float _2023 = mad(_2010 - _1988, _2019, _1988);
        float _2025 = _2020 - min(_2023, _2021);
        float4 _2049 = t11.SampleLevel(s9, float3(abs(mad(mad(_2009, 1.0f, -1.0f) - _2013, _2019, _2013) + ((_2023 - _2021) / mad(_2025, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1999 + _1999)), (1.0f / (_2002 + _2002)) + (_2025 / (_2020 + 9.9999997473787516355514526367188e-05f)), mad(_2020 * 3.0f, 1.0f / mad(_2020, 3.0f, 1.5f), 1.0f / (_2005 + _2005))), 0.0f);
        float _2050 = _2049.x;
        float _2051 = _2049.y;
        float _2052 = _2049.z;
        float3 _2080 = float3(mad(_2052, mad(_2051, clamp(abs(mad(frac(_2050 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_2050 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _2051, 1.0f), _2052, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_2050 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _2051, 1.0f), _2052, -3.5073844628641381859779357910156e-05f));
        float3 _2084 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _2080), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _2080), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _2080));
        float3 _2088 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _2084), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _2084), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _2084));
        float _2097 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _2088) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _2108 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _2088) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _2118 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _2088) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_1402] = float4(min(exp2(log2(mad(_2097, 18.8515625f, 0.8359375f) / mad(_2097, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_2108, 18.8515625f, 0.8359375f) / mad(_2108, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_2118, 18.8515625f, 0.8359375f) / mad(_2118, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

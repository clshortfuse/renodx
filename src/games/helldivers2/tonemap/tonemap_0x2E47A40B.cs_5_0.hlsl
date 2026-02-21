#include "../common.hlsl"
struct _395
{
    uint2 _m0;
    uint _m1;
};

struct _1612
{
    uint3 _m0;
    uint _m1;
};

static const float _55[1] = { 0.0f };
static const float4 _333[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

cbuffer cb0_buf : register(b0)
{
    uint4 cb0_m[44] : packoffset(c0);
};

cbuffer cb1_buf : register(b1)
{
    uint4 cb1_m[20] : packoffset(c0);
};

SamplerState s0 : register(s0);
SamplerState s1 : register(s1);
SamplerState s2 : register(s2);
SamplerState s3 : register(s3);
SamplerState s4 : register(s4);
SamplerState s5 : register(s5);
SamplerState s6 : register(s6);
SamplerState s7 : register(s7);
Buffer<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t8 : register(t8);
Texture3D<float4> t9 : register(t9);
Buffer<float4> t10 : register(t10);
Buffer<float4> t11 : register(t11);
RWTexture2D<float4> u0 : register(u0);

static uint3 gl_LocalInvocationID;
static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

groupshared float g0[1];



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
    precise float _386 = a.x * b.x;
    return mad(a.y, b.y, _386);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _372 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _372));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _354 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _354)));
}

void comp_main()
{
    uint _394_dummy_parameter;
    _395 _396 = { spvImageSize(u0, _394_dummy_parameter), 1u };
    uint _411 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _415 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_411, 1u, 3u);
    uint _416 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _411, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _423 = (float(_415) + 0.5f) / float(_396._m0.x);
    float _424 = (float(_416) + 0.5f) / float(_396._m0.y);
    bool _428 = (_396._m0.x < _415) || (_396._m0.y < _416);
    bool _434 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _434) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _449 = float2(_423, _424);
    float _454 = mad(t4.SampleLevel(s3, _449, 0.0f).x, 2.0f, -1.0f);
    float _469;
    if (_454 > 0.0f)
    {
        _469 = min(sqrt(_454), t0.Load(8u).x);
    }
    else
    {
        _469 = max(_454, -t0.Load(7u).x);
    }
    float4 _473 = t3.SampleLevel(s2, _449, 0.0f);
    float2 _485 = float2(_473.x * asfloat(cb1_m[2u].x), _473.y * asfloat(cb1_m[2u].y));
    bool _500 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _505 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float _509 = abs(_469);
    float _517 = exp2(max(_500 ? clamp((sqrt(dp2_f32(_485, _485)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _505 ? clamp((_509 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _518 = _423 - 0.5f;
    float _519 = _424 - 0.5f;
    float2 _520 = float2(_518, _519);
    float _521 = dp2_f32(_520, _520);
    float _524 = asfloat(cb1_m[18u].x);
    float _525 = mad(_521, _524, 1.0f);
    float _531 = asfloat(cb1_m[18u].z);
    float _538 = asfloat(cb1_m[18u].y);
    float _550 = mad(exp2(log2(clamp(_524, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(asfloat(cb1_m[18u].y), -0.089999973773956298828125f, 1.0f);
    float _551 = (_525 * mad(_538, mad(_531, -0.001999996602535247802734375f, 0.092000000178813934326171875f), 1.0f)) * _550;
    float _552 = _550 * (_525 * mad(_538, mad(_531, 0.04500000178813934326171875f, 0.046999998390674591064453125f), 1.0f));
    float _553 = _550 * (_525 * mad(_538, mad(_531, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _554 = mad(_518, _551, 0.5f);
    float _555 = mad(_551, _519, 0.5f);
    float _556 = mad(_518, _552, 0.5f);
    float _557 = mad(_519, _552, 0.5f);
    float2 _560 = float2(_554, _555);
    float4 _562 = t1.SampleLevel(s0, _560, 0.0f);
    float _563 = _562.x;
    bool _564 = _505 || _500;
    float _597;
    if (_564)
    {
        float4 _570 = t2.SampleLevel(s1, _560, 0.0f);
        float _571 = _570.x;
        float _578 = asfloat(cb0_m[43u].w) * 20.0f;
        float _594 = mad(mad(t7.SampleLevel(s5, float2(mad(_554, 30.0f, sin(_578)), mad(_555, 30.0f, cos(_578))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_571, max(_570.y, _570.z)), 1.0000000133514319600180897396058e-10f)), _571);
        _597 = mad(_517, _563 - _594, _594);
    }
    else
    {
        _597 = _563;
    }
    float2 _598 = float2(_556, _557);
    float4 _600 = t1.SampleLevel(s0, _598, 0.0f);
    float _601 = _600.y;
    float _634;
    if (_564)
    {
        float4 _607 = t2.SampleLevel(s1, _598, 0.0f);
        float _609 = _607.y;
        float _615 = asfloat(cb0_m[43u].w) * 20.0f;
        float _631 = mad(mad(t7.SampleLevel(s5, float2(mad(_556, 30.0f, sin(_615)), mad(_557, 30.0f, cos(_615))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_607.x, max(_609, _607.z)), 1.0000000133514319600180897396058e-10f)), _609);
        _634 = mad(_517, _601 - _631, _631);
    }
    else
    {
        _634 = _601;
    }
    float _635 = mad(_518, _553, 0.5f);
    float _636 = mad(_519, _553, 0.5f);
    float2 _637 = float2(_635, _636);
    float4 _639 = t1.SampleLevel(s0, _637, 0.0f);
    float _640 = _639.z;
    float _673;
    if (_564)
    {
        float4 _646 = t2.SampleLevel(s1, _637, 0.0f);
        float _649 = _646.z;
        float _654 = asfloat(cb0_m[43u].w) * 20.0f;
        float _670 = mad(mad(t7.SampleLevel(s5, float2(mad(_635, 30.0f, sin(_654)), mad(_636, 30.0f, cos(_654))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_646.x, max(_646.y, _649)), 1.0000000133514319600180897396058e-10f)), _649);
        _673 = mad(_517, _640 - _670, _670);
    }
    else
    {
        _673 = _640;
    }
    float _679 = _434 ? g0[0u] : asfloat(cb1_m[2u].z);
    float4 _683 = t5.SampleLevel(s4, _449, 0.0f);
    float _684 = _683.x;
    float _693 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_684, _683.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _697 = mad(_597, _679, _684 / _693);
    float _698 = mad(_634, _679, _683.y / _693);
    float _699 = mad(_673, _679, _683.z / _693);
    float _703 = 1.0f / (max(_697, max(_699, _698)) + 1.0f);
    float _704 = _697 * _703;
    float _706 = _703 * _699;
    float3 _707 = float3(_704, _706, _703 * _698);
    float _708 = dp3_f32(_707, float3(0.25f, 0.25f, 0.5f));
    float _709 = dp3_f32(_707, float3(-0.25f, -0.25f, 0.5f));
    float _711 = dp2_f32(float2(_704, _706), float2(0.5f, -0.5f));
    float _712 = _708 - _709;
    float _713 = _711 + _712;
    float _714 = _708 + _709;
    float _715 = _712 - _711;
    bool _716 = !_428;
    float _1073;
    float _1074;
    float _1075;
    if (_716)
    {
        float _720 = dp3_f32(float3(_713, _714, _715), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _729 = mad(-_509, asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _733 = mad(_729, _713 - _720, _720);
        float _734 = mad(_729, _714 - _720, _720);
        float _735 = mad(_729, _715 - _720, _720);
        float _736 = _519 + _519;
        float _737 = _518 + _518;
        float _738 = abs(_737);
        float _739 = abs(_736);
        float _743 = min(_738, _739) * (1.0f / max(_738, _739));
        float _744 = _743 * _743;
        float _748 = mad(_744, mad(_744, mad(_744, mad(_744, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _757 = mad(_743, _748, (_738 < _739) ? mad(_743 * _748, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_737 < (-_737)) ? (-3.1415927410125732421875f) : 0.0f);
        float _758 = min(_737, _736);
        float _759 = max(_737, _736);
        float _766 = ((_758 < (-_758)) && (_759 >= (-_759))) ? (-_757) : _757;
        float4 _770 = t8.SampleLevel(s6, _449, 0.0f);
        float _771 = _770.x;
        float _772 = _770.y;
        float _773 = _770.z;
        float _774 = _770.w;
        float _779 = (_734 - _735) * 1.73205077648162841796875f;
        float _781 = mad(_733, 2.0f, -_734);
        float _782 = _781 - _735;
        float _783 = abs(_779);
        float _784 = abs(_782);
        float _788 = min(_783, _784) * (1.0f / max(_783, _784));
        float _789 = _788 * _788;
        float _793 = mad(_789, mad(_789, mad(_789, mad(_789, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _802 = mad(_788, _793, (_783 > _784) ? mad(_788 * _793, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_782 < (_735 - _781)) ? (-3.1415927410125732421875f) : 0.0f);
        float _803 = min(_779, _782);
        float _804 = max(_779, _782);
        float _813 = ((_735 == _734) && (_734 == _733)) ? 0.0f : ((((_803 < (-_803)) && (_804 >= (-_804))) ? (-_802) : _802) * 57.295780181884765625f);
        float _824 = mad(asfloat(cb1_m[19u].x), -360.0f, (_813 < 0.0f) ? (_813 + 360.0f) : _813);
        float _834 = clamp(1.0f - (abs((_824 < (-180.0f)) ? (_824 + 360.0f) : ((_824 > 180.0f) ? (_824 - 360.0f) : _824)) / (asfloat(cb1_m[19u].y) * 180.0f)), 0.0f, 1.0f);
        float _839 = dp3_f32(float3(_733, _734, _735), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _843 = (mad(_834, -2.0f, 3.0f) * (_834 * _834)) * asfloat(cb1_m[19u].z);
        float _855 = asfloat(cb1_m[18u].w);
        float _856 = mad(mad(_843, _733 - _839, _839) - _733, _855, _733);
        float _857 = mad(_855, mad(_734 - _839, _843, _839) - _734, _734);
        float _858 = mad(_855, mad(_735 - _839, _843, _839) - _735, _735);
        float _860;
        _860 = 0.0f;
        float _861;
        uint _864;
        uint _863 = 0u;
        for (;;)
        {
            if (_863 >= 8u)
            {
                break;
            }
            uint _875 = min((_863 & 3u), 4u);
            float _895 = mad(float(_863), 0.785398185253143310546875f, -_766);
            float _896 = _895 + 1.57079637050628662109375f;
            _861 = mad(_774 * (dp4_f32(t10.Load((_863 >> 2u) + 10u), float4(_333[_875].x, _333[_875].y, _333[_875].z, _333[_875].w)) * clamp((abs((_896 > 3.1415927410125732421875f) ? (_895 - 4.7123889923095703125f) : _896) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _860, _860);
            _864 = _863 + 1u;
            _860 = _861;
            _863 = _864;
            continue;
        }
        float _907 = clamp(_860, 0.0f, 1.0f);
        float _925 = abs(t10.Load(8u).x);
        float2 _928 = float2(_518 * 1.40999996662139892578125f, _519 * 1.40999996662139892578125f);
        float _930 = sqrt(dp2_f32(_928, _928));
        float _931 = min(_930, 1.0f);
        float _932 = _931 * _931;
        float _937 = clamp(_930 - 0.5f, 0.0f, 1.0f);
        float _940 = (_931 * _932) + (mad(-_931, _932, 1.0f) * (_937 * _937));
        float _941 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _925, -1.0f);
        float _943 = _772 + _941;
        float _945 = clamp((_773 + _941) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _952 = clamp(_943 + _943, 0.0f, 1.0f);
        float _969 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _975 = mad(sin(_772 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_969)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _977 = _975 * 0.02999999932944774627685546875f;
        float _978 = mad(_925, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _982 = mad(mad(-_940, _940, 1.0f), 1.0f - _978, _978);
        float _983 = min((exp2(log2(_940) * 0.699999988079071044921875f) * (mad(_952, -2.0f, 3.0f) * (_952 * _952))) + (mad(_945, -2.0f, 3.0f) * (_945 * _945)), 1.0f);
        float _993 = mad(_983, mad(_982, _975 * 0.62000000476837158203125f, mad(_856, _907, -_856)), mad(-_856, _907, _856));
        float _994 = mad(_983, mad(_982, _977, mad(_907, _857, -_857)), mad(-_907, _857, _857));
        float _995 = mad(_983, mad(_982, _977, mad(_907, _858, -_858)), mad(-_907, _858, _858));
        float _998 = mad(_772, _773 * (1.0f - _774), _774);
        float _1000;
        _1000 = 0.0f;
        float _1001;
        uint _1004;
        uint _1003 = 0u;
        for (;;)
        {
            if (int(_1003) >= 8)
            {
                break;
            }
            float4 _1011 = t10.Load(_1003);
            float _1013 = _1011.y;
            float _1015 = _1011.x - _766;
            _1001 = mad(_998 * (_1011.w * clamp(((_1013 - 3.1415927410125732421875f) + abs((_1015 > 3.1415927410125732421875f) ? (_1015 - 6.283185482025146484375f) : ((_1015 < (-3.1415927410125732421875f)) ? (_1015 + 6.283185482025146484375f) : _1015))) / max(_1013 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _1000, _1000);
            _1004 = _1003 + 1u;
            _1000 = _1001;
            _1003 = _1004;
            continue;
        }
        float _1034 = clamp(_1000 + _1000, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _1038 = mad(_1034, 0.310000002384185791015625f - _993, _993);
        float _1039 = mad(_1034, 0.014999999664723873138427734375f - _994, _994);
        float _1040 = mad(_1034, 0.014999999664723873138427734375f - _995, _995);
        float4 _1041 = t10.Load(12u);
        float _1042 = _1041.x;
        float _1070;
        float _1071;
        float _1072;
        if (_1042 != 0.0f)
        {
            float _1049 = clamp(_969, 0.0f, 1.0f);
            float _1059 = clamp((_771 + (_1042 - 1.0f)) / max(mad(_1042, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _1063 = clamp(_1042 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _1066 = mad(_1063, -2.0f, 3.0f) * (_1063 * _1063);
            _1070 = mad((_1049 * (_771 * 0.790000021457672119140625f)) * _1059, _1066, _1038);
            _1071 = mad(_1066, _1059 * (_1049 * (_771 * 0.85000002384185791015625f)), _1039);
            _1072 = mad(_1066, _1059 * (_1049 * (_771 * 0.930000007152557373046875f)), _1040);
        }
        else
        {
            _1070 = _1038;
            _1071 = _1039;
            _1072 = _1040;
        }
        _1073 = _1070;
        _1074 = _1071;
        _1075 = _1072;
    }
    else
    {
        _1073 = _713;
        _1074 = _714;
        _1075 = _715;
    }
    float _1080 = 1.0f / max(1.0f - max(max(_1074, _1075), _1073), 6.099999882280826568603515625e-05f);
    float _1087 = min(-(_1080 * _1073), 0.0f);
    float _1088 = min(-(_1080 * _1074), 0.0f);
    float _1089 = min(-(_1080 * _1075), 0.0f);
    float _1101 = clamp(-((1.0f / asfloat(cb1_m[5u].y)) * (sqrt(_521) - asfloat(cb1_m[5u].x))), 0.0f, 1.0f);
    float _1102 = mad(_1101, -2.0f, 3.0f);
    float _1103 = _1101 * _1101;
    float _1104 = _1102 * _1103;
    float _1106 = mad(-_1102, _1103, 1.0f);
    float _1133 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
    float3 _1146 = float3(_428 ? (-_1087) : mad(_1087 + ((_1106 * asfloat(cb1_m[4u].x)) - (_1087 * _1104)), _1133, -_1087), _428 ? (-_1088) : mad(_1133, ((_1106 * asfloat(cb1_m[4u].y)) - (_1104 * _1088)) + _1088, -_1088), _428 ? (-_1089) : mad(_1133, ((_1106 * asfloat(cb1_m[4u].z)) - (_1104 * _1089)) + _1089, -_1089));
    float _1147 = dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1146);
    float _1148 = dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1146);
    float _1149 = dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1146);
    bool _1153 = asfloat(cb1_m[8u].x) != 0.0f;
    float _1172;
    float _1173;
    float _1174;
    if (!_1153)
    {
        float _1159 = asfloat(cb1_m[9u].y);
        float _1165 = asfloat(cb1_m[9u].x);
        _1172 = clamp(mad(_1165, mad(_1149, _1159, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1173 = clamp(mad(_1165, mad(_1148, _1159, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1174 = clamp(mad(_1165, mad(_1147, _1159, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
    }
    else
    {
        _1172 = _1149;
        _1173 = _1148;
        _1174 = _1147;
    }
    float _1178 = mad(asfloat(cb1_m[8u].y), -0.0005000000237487256526947021484375f, 0.312709987163543701171875f);
    float _1186 = mad(asfloat(cb1_m[8u].z), 0.0005000000237487256526947021484375f, (_1178 * 2.86999988555908203125f) - ((_1178 * _1178) * 3.0f));
    float _1187 = _1186 - 0.2750950753688812255859375f;
    float _1188 = _1178 / _1187;
    float _1192 = ((1.0f - _1178) + (0.2750950753688812255859375f - _1186)) / _1187;
    float3 _1202 = float3(_1174, _1173, _1172);
    float3 _1209 = float3((0.94923698902130126953125f / mad(_1192, -0.1624000072479248046875f, mad(_1188, 0.732800006866455078125f, 0.4296000003814697265625f))) * dp3_f32(float3(0.390404999256134033203125f, 0.549941003322601318359375f, 0.008926319889724254608154296875f), _1202), dp3_f32(float3(0.070841602981090545654296875f, 0.963172018527984619140625f, 0.001357750035822391510009765625f), _1202) * (1.035419940948486328125f / mad(_1192, 0.006099999882280826568603515625f, mad(_1188, -0.703599989414215087890625f, 1.6974999904632568359375f))), dp3_f32(float3(0.02310819923877716064453125f, 0.1280210018157958984375f, 0.936245024204254150390625f), _1202) * (1.0872800350189208984375f / mad(_1192, 0.98339998722076416015625f, mad(_1188, 0.0030000000260770320892333984375f, 0.013600000180304050445556640625f))));
    float3 _1219 = float3(dp3_f32(float3(2.85846996307373046875f, -1.62879002094268798828125f, -0.0248910002410411834716796875f), _1209), dp3_f32(float3(-0.21018199622631072998046875f, 1.1582000255584716796875f, 0.0003242809907533228397369384765625f), _1209), dp3_f32(float3(-0.0418119989335536956787109375f, -0.118169002234935760498046875f, 1.0686700344085693359375f), _1209));
    float _1224 = dp3_f32(_1219, float3(asfloat(cb1_m[9u].w), asfloat(cb1_m[10u].x), asfloat(cb1_m[10u].y)));
    float _1233 = dp3_f32(_1219, float3(asfloat(cb1_m[10u].z), asfloat(cb1_m[10u].w), asfloat(cb1_m[11u].x)));
    float _1243 = dp3_f32(_1219, float3(asfloat(cb1_m[11u].y), asfloat(cb1_m[11u].z), asfloat(cb1_m[11u].w)));
    float _1245 = dp3_f32(float3(_1224, _1233, _1243), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1248 = asfloat(cb1_m[14u].w);
    float _1256 = clamp((_1245 - _1248) * (1.0f / (asfloat(cb1_m[15u].x) - _1248)), 0.0f, 1.0f);
    float _1260 = mad(-mad(_1256, -2.0f, 3.0f), _1256 * _1256, 1.0f);
    float _1263 = asfloat(cb1_m[15u].y);
    float _1271 = clamp((_1245 - _1263) * (1.0f / (asfloat(cb1_m[15u].z) - _1263)), 0.0f, 1.0f);
    float _1272 = mad(_1271, -2.0f, 3.0f);
    float _1273 = _1271 * _1271;
    float _1274 = _1272 * _1273;
    float _1277 = 1.0f - clamp(mad(_1272, _1273, _1260), 0.0f, 1.0f);
    float _1308;
    float _1309;
    float _1310;
    if (_1153)
    {
        _1308 = asfloat(cb1_m[16u].y) + 1.0f;
        _1309 = asfloat(cb1_m[15u].w) + 1.0f;
        _1310 = asfloat(cb1_m[16u].x) + 1.0f;
    }
    else
    {
        float _1295 = asfloat(cb1_m[15u].w);
        float _1299 = asfloat(cb1_m[16u].x);
        _1308 = mad(_1299, 0.5f, mad(_1295, 0.25f, 1.0f)) + asfloat(cb1_m[16u].y);
        _1309 = _1295 + 1.0f;
        _1310 = mad(_1295, 0.5f, _1299) + 1.0f;
    }
    float _1362 = mad(_1274 * (_1233 * asfloat(cb1_m[14u].y)), _1308, ((_1260 * (_1233 * asfloat(cb1_m[12u].y))) * _1309) + ((_1277 * (_1233 * asfloat(cb1_m[13u].y))) * _1310));
    float _1363 = mad(_1274 * (_1243 * asfloat(cb1_m[14u].z)), _1308, ((_1260 * (_1243 * asfloat(cb1_m[12u].z))) * _1309) + ((_1277 * (_1243 * asfloat(cb1_m[13u].z))) * _1310));
    float _1364 = mad(_1274 * (_1224 * asfloat(cb1_m[14u].x)), _1308, ((_1277 * (_1224 * asfloat(cb1_m[13u].x))) * _1310) + ((_1260 * (_1224 * asfloat(cb1_m[12u].x))) * _1309));
    float _1368 = float(_1362 >= _1363);
    float _1369 = mad(_1362 - _1363, _1368, _1363);
    float _1370 = mad(_1368, _1363 - _1362, _1362);
    float _1372 = mad(_1368, -1.0f, 0.666666686534881591796875f);
    float _1378 = float(_1369 <= _1364);
    float _1379 = mad(_1364 - _1369, _1378, _1369);
    float _1380 = mad(_1378, _1370 - _1370, _1370);
    float _1382 = mad(_1378, _1369 - _1364, _1364);
    float _1384 = _1379 - min(_1382, _1380);
    float _1390 = _1384 / (_1379 + 9.9999997473787516355514526367188e-05f);
    float _1395 = abs(((_1382 - _1380) / mad(_1384, 6.0f, 9.9999997473787516355514526367188e-05f)) + mad(_1378, mad(_1368, 1.0f, -1.0f) - _1372, _1372)) + asfloat(cb1_m[9u].z);
    float _1401 = (_1395 < 0.0f) ? (_1395 + 1.0f) : ((_1395 > 1.0f) ? (_1395 - 1.0f) : _1395);
    float _1423 = mad(_1390, clamp(abs(mad(frac(_1401 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1424 = mad(_1390, clamp(abs(mad(frac(_1401 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1425 = mad(_1390, clamp(abs(mad(frac(_1401 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1430 = dp3_f32(float3(_1379 * _1423, _1379 * _1424, _1379 * _1425), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1439 = asfloat(cb1_m[8u].w);
    float _1440 = mad(mad(_1379, _1423, -_1430), _1439, _1430);
    float _1441 = mad(_1439, mad(_1379, _1424, -_1430), _1430);
    float _1442 = mad(_1439, mad(_1379, _1425, -_1430), _1430);
    float _1463;
    float _1464;
    float _1465;
    if (_1153)
    {
        float _1450 = asfloat(cb1_m[9u].x);
        float _1459 = asfloat(cb1_m[9u].y);
        _1463 = _1459 * clamp(mad(_1450, _1442 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1464 = _1459 * clamp(mad(_1450, _1441 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1465 = clamp(mad(_1440 - 0.1800537109375f, _1450, 0.1800537109375f), 0.0f, 65504.0f) * _1459;
    }
    else
    {
        _1463 = _1442;
        _1464 = _1441;
        _1465 = _1440;
    }
    if (_716)
    {
#if 1
  float _1471 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1465 * 2.5f, 65504.0f) : _1465;
  float _1472 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1464 * 2.5f, 65504.0f) : _1464;
  float _1473 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1463 * 2.5f, 65504.0f) : _1463;
#endif
        float _1477 = max(max(_1471, _1472), _1473);
        float _1482 = (max(_1477, 9.9999997473787516355514526367188e-05f) - max(min(min(_1471, _1472), _1473), 9.9999997473787516355514526367188e-05f)) / max(_1477, 0.00999999977648258209228515625f);
        float _1493 = mad(sqrt(mad(_1471, _1471 - _1473, ((_1473 - _1472) * _1473) + ((_1472 - _1471) * _1472))), 1.75f, _1471 + (_1473 + _1472));
        float _1494 = _1482 - 0.4000000059604644775390625f;
        float _1499 = max(1.0f - abs(_1494 * 2.5f), 0.0f);
        float _1506 = mad(mad(clamp(mad(_1494, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1499, _1499, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1514 = ((_1493 <= 0.1599999964237213134765625f) ? _1506 : ((_1493 >= 0.4799999892711639404296875f) ? 0.0f : (_1506 * ((0.07999999821186065673828125f / (_1493 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1515 = _1471 * _1514;
        float _1516 = _1514 * _1472;
        float _1517 = _1514 * _1473;
        float _1522 = (_1516 - _1517) * 1.73205077648162841796875f;
        float _1524 = (_1515 * 2.0f) - _1516;
        float _1526 = mad(-_1514, _1473, _1524);
        float _1527 = abs(_1526);
        float _1528 = abs(_1522);
        float _1532 = min(_1527, _1528) * (1.0f / max(_1527, _1528));
        float _1533 = _1532 * _1532;
        float _1537 = mad(_1533, mad(_1533, mad(_1533, mad(_1533, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1547 = mad(_1532, _1537, (_1527 < _1528) ? mad(_1532 * _1537, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1526 < mad(_1514, _1473, -_1524)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1548 = min(_1522, _1526);
        float _1549 = max(_1522, _1526);
        float _1558 = ((_1515 == _1516) && (_1517 == _1516)) ? 0.0f : ((((_1548 < (-_1548)) && (_1549 >= (-_1549))) ? (-_1547) : _1547) * 57.295780181884765625f);
        float _1561 = (_1558 < 0.0f) ? (_1558 + 360.0f) : _1558;
        float _1571 = max(1.0f - abs(((_1561 < (-180.0f)) ? (_1561 + 360.0f) : ((_1561 > 180.0f) ? (_1561 - 360.0f) : _1561)) * 0.01481481455266475677490234375f), 0.0f);
        float _1574 = mad(_1571, -2.0f, 3.0f) * (_1571 * _1571);
        float3 _1585 = float3(clamp(_1515 + (((_1482 * (_1574 * _1574)) * mad(-_1471, _1514, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1516, 0.0f, 65504.0f), clamp(_1517, 0.0f, 65504.0f));
        float _1589 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1585), 0.0f, 65504.0f);
        float _1590 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1585), 0.0f, 65504.0f);
        float _1591 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1585), 0.0f, 65504.0f);

        float _1593 = dp3_f32(float3(_1589, _1590, _1591), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1600 = float3(mad(_1589 - _1593, 0.959999978542327880859375f, _1593), mad(_1590 - _1593, 0.959999978542327880859375f, _1593), mad(_1591 - _1593, 0.959999978542327880859375f, _1593));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[uint2(_415, _416)] = float4(CustomACES(_1600), 1.f);
    return;
  }
#endif
        float3 _1604 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1600), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1600), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1600));
        float _1605 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1604);
        float _1606 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1604);
        float _1607 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1604);
        uint _1609;
        spvTextureSize(t9, 0u, _1609);
        bool _1610 = _1609 > 0u;
        uint _1611_dummy_parameter;
        _1612 _1613 = { spvTextureSize(t9, 0u, _1611_dummy_parameter), 1u };
        float _1616 = float(_1610 ? _1613._m0.x : 0u);
        float _1619 = float(_1610 ? _1613._m0.y : 0u);
        float _1622 = float(_1610 ? _1613._m0.z : 0u);
        float _1626 = float(_1606 >= _1607);
        float _1627 = mad(_1606 - _1607, _1626, _1607);
        float _1628 = mad(_1607 - _1606, _1626, _1606);
        float _1630 = mad(_1626, -1.0f, 0.666666686534881591796875f);
        float _1636 = float(_1605 >= _1627);
        float _1637 = mad(_1605 - _1627, _1636, _1627);
        float _1638 = mad(_1628 - _1628, _1636, _1628);
        float _1640 = mad(_1627 - _1605, _1636, _1605);
        float _1642 = _1637 - min(_1640, _1638);
        float4 _1666 = t9.SampleLevel(s7, float3(abs(mad(mad(_1626, 1.0f, -1.0f) - _1630, _1636, _1630) + ((_1640 - _1638) / mad(_1642, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1616 + _1616)), (1.0f / (_1619 + _1619)) + (_1642 / (_1637 + 9.9999997473787516355514526367188e-05f)), mad(_1637 * 3.0f, 1.0f / mad(_1637, 3.0f, 1.5f), 1.0f / (_1622 + _1622))), 0.0f);
        float _1667 = _1666.x;
        float _1668 = _1666.y;
        float _1669 = _1666.z;
        float3 _1697 = float3(mad(_1669, mad(_1668, clamp(abs(mad(frac(_1667 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1667 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1668, 1.0f), _1669, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1667 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1668, 1.0f), _1669, -3.5073844628641381859779357910156e-05f));
        float3 _1701 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1697), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1697), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1697));
        float3 _1705 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1701), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1701), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1701));
        float _1714 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1705) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1725 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1705) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1735 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1705) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[uint2(_415, _416)] = float4(min(exp2(log2(mad(_1714, 18.8515625f, 0.8359375f) / mad(_1714, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1725, 18.8515625f, 0.8359375f) / mad(_1725, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1735, 18.8515625f, 0.8359375f) / mad(_1735, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

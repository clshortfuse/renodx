#include "../common.hlsl"
struct _321
{
    uint2 _m0;
    uint _m1;
};

struct _1113
{
    uint3 _m0;
    uint _m1;
};

static const float _57[1] = { 0.0f };
static const float4 _246[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

cbuffer cb0_buf : register(b0)
{
    uint4 cb0_m[44] : packoffset(c0);
};

cbuffer cb1_buf : register(b1)
{
    uint4 cb1_m0 : packoffset(c0);
    uint4 cb1_m1 : packoffset(c1);
    float2 cb1_m2 : packoffset(c2);
    float2 cb1_m3 : packoffset(c2.z);
    float4 cb1_m4 : packoffset(c3);
    float3 cb1_m5 : packoffset(c4);
    uint cb1_m6 : packoffset(c4.w);
    float4 cb1_m7 : packoffset(c5);
    float4 cb1_m8 : packoffset(c6);
    float2 cb1_m9 : packoffset(c7);
    float2 cb1_m10 : packoffset(c7.z);
    uint4 cb1_m11 : packoffset(c8);
    uint4 cb1_m12 : packoffset(c9);
    uint4 cb1_m13 : packoffset(c10);
    uint4 cb1_m14 : packoffset(c11);
    uint4 cb1_m15 : packoffset(c12);
    uint4 cb1_m16 : packoffset(c13);
    uint4 cb1_m17 : packoffset(c14);
    uint4 cb1_m18 : packoffset(c15);
    uint4 cb1_m19 : packoffset(c16);
    uint4 cb1_m20 : packoffset(c17);
    float4 cb1_m21 : packoffset(c18);
    float4 cb1_m22 : packoffset(c19);
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
RWTexture2D<float4> u1 : register(u1);

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
    precise float _312 = a.x * b.x;
    return mad(a.y, b.y, _312);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _298 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _298));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _280 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _280)));
}

void comp_main()
{
    uint _320_dummy_parameter;
    _321 _322 = { spvImageSize(u0, _320_dummy_parameter), 1u };
    uint _337 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _341 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_337, 1u, 3u);
    uint _342 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _337, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _349 = (float(_341) + 0.5f) / float(_322._m0.x);
    float _350 = (float(_342) + 0.5f) / float(_322._m0.y);
    bool _359 = cb1_m3.y == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _359) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _374 = float2(_349, _350);
    float _379 = mad(t4.SampleLevel(s3, _374, 0.0f).x, 2.0f, -1.0f);
    float _394;
    if (_379 > 0.0f)
    {
        _394 = min(sqrt(_379), t0.Load(8u).x);
    }
    else
    {
        _394 = max(_379, -t0.Load(7u).x);
    }
    bool _405 = (cb1_m10.x != 0.0f) && (cb1_m10.y != 0.0f);
    bool _409 = (cb1_m8.w != 0.0f) && (cb1_m9.x != 0.0f);
    float4 _413 = t1.SampleLevel(s0, _374, 0.0f);
    float _414 = _413.x;
    float _415 = _413.y;
    float _416 = _413.z;
    float _484;
    float _485;
    float _486;
    if (_409 || _405)
    {
        float4 _423 = t3.SampleLevel(s2, _374, 0.0f);
        float2 _432 = float2(_423.x * cb1_m2.x, _423.y * cb1_m2.y);
        float _446 = exp2(max(_405 ? clamp((sqrt(dp2_f32(_432, _432)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _409 ? clamp((abs(_394) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float4 _450 = t2.SampleLevel(s1, _374, 0.0f);
        float _451 = _450.x;
        float _452 = _450.y;
        float _453 = _450.z;
        float _459 = asfloat(cb0_m[43u].w) * 20.0f;
        float _470 = mad(t7.SampleLevel(s5, float2(mad(_349, 30.0f, sin(_459)), mad(_350, 30.0f, cos(_459))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f);
        float _474 = sqrt(max(max(_451, max(_452, _453)), 1.0000000133514319600180897396058e-10f));
        float _475 = mad(_470, _474, _451);
        float _476 = mad(_470, _474, _452);
        float _477 = mad(_470, _474, _453);
        _484 = mad(_446, _416 - _477, _477);
        _485 = mad(_446, _415 - _476, _476);
        _486 = mad(_446, _414 - _475, _475);
    }
    else
    {
        _484 = _416;
        _485 = _415;
        _486 = _414;
    }
    float _491 = _359 ? g0[0u] : cb1_m3.x;
    float4 _495 = t5.SampleLevel(s4, _374, 0.0f);
    float _496 = _495.x;
    float _504 = max(cb1_m4.y - dp3_f32(float3(_496, _495.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _508 = mad(_486, _491, _496 / _504);
    float _509 = mad(_485, _491, _495.y / _504);
    float _510 = mad(_484, _491, _495.z / _504);
    float _514 = 1.0f / (max(_508, max(_510, _509)) + 1.0f);
    float _515 = _508 * _514;
    float _517 = _510 * _514;
    float3 _518 = float3(_515, _517, _509 * _514);
    float _519 = dp3_f32(_518, float3(0.25f, 0.25f, 0.5f));
    float _520 = dp3_f32(_518, float3(-0.25f, -0.25f, 0.5f));
    float _522 = dp2_f32(float2(_515, _517), float2(0.5f, -0.5f));
    uint2 _524 = uint2(_341, _342);
    u1[_524] = float4(_519, _522, _520, _519);
    if (!((_322._m0.x < _341) || (_322._m0.y < _342)))
    {
        float _529 = _519 - _520;
        float _530 = _522 + _529;
        float _531 = _519 + _520;
        float _532 = _529 - _522;
        float _534 = dp3_f32(float3(_530, _531, _532), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _542 = mad(-abs(_394), cb1_m9.y, 1.0f) * cb1_m8.x;
        float _546 = mad(_542, _530 - _534, _534);
        float _547 = mad(_531 - _534, _542, _534);
        float _548 = mad(_532 - _534, _542, _534);
        float _549 = _349 - 0.5f;
        float _550 = _350 - 0.5f;
        float _551 = _550 + _550;
        float _552 = _549 + _549;
        float _553 = abs(_552);
        float _554 = abs(_551);
        float _558 = min(_553, _554) * (1.0f / max(_553, _554));
        float _559 = _558 * _558;
        float _563 = mad(_559, mad(_559, mad(_559, mad(_559, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _572 = mad(_558, _563, (_553 < _554) ? mad(_558 * _563, -2.0f, 1.57079637050628662109375f) : 0.0f) + (((-_552) > _552) ? (-3.1415927410125732421875f) : 0.0f);
        float _573 = min(_551, _552);
        float _574 = max(_551, _552);
        float _581 = ((_573 < (-_573)) && (_574 >= (-_574))) ? (-_572) : _572;
        float4 _585 = t8.SampleLevel(s6, _374, 0.0f);
        float _586 = _585.x;
        float _587 = _585.y;
        float _588 = _585.z;
        float _589 = _585.w;
        float _594 = (_547 - _548) * 1.73205077648162841796875f;
        float _596 = mad(_546, 2.0f, -_547);
        float _597 = _596 - _548;
        float _598 = abs(_597);
        float _599 = abs(_594);
        float _603 = min(_598, _599) * (1.0f / max(_598, _599));
        float _604 = _603 * _603;
        float _608 = mad(_604, mad(_604, mad(_604, mad(_604, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _617 = mad(_603, _608, (_598 < _599) ? mad(_603 * _608, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_597 < (_548 - _596)) ? (-3.1415927410125732421875f) : 0.0f);
        float _618 = min(_594, _597);
        float _619 = max(_594, _597);
        float _628 = ((_546 == _547) && (_548 == _547)) ? 0.0f : ((((_618 < (-_618)) && (_619 >= (-_619))) ? (-_617) : _617) * 57.295780181884765625f);
        float _637 = mad(cb1_m22.y, -360.0f, (_628 < 0.0f) ? (_628 + 360.0f) : _628);
        float _647 = clamp(1.0f - (abs((_637 < (-180.0f)) ? (_637 + 360.0f) : ((_637 > 180.0f) ? (_637 - 360.0f) : _637)) / (cb1_m22.z * 180.0f)), 0.0f, 1.0f);
        float _652 = dp3_f32(float3(_546, _547, _548), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _655 = (mad(_647, -2.0f, 3.0f) * (_647 * _647)) * cb1_m22.w;
        float _667 = mad(mad(_655, _546 - _652, _652) - _546, cb1_m21.w, _546);
        float _668 = mad(cb1_m21.w, mad(_655, _547 - _652, _652) - _547, _547);
        float _669 = mad(cb1_m21.w, mad(_655, _548 - _652, _652) - _548, _548);
        float _671;
        _671 = 0.0f;
        float _672;
        uint _675;
        uint _674 = 0u;
        for (;;)
        {
            if (_674 >= 8u)
            {
                break;
            }
            uint _686 = min((_674 & 3u), 4u);
            float _706 = mad(float(_674), 0.785398185253143310546875f, -_581);
            float _707 = _706 + 1.57079637050628662109375f;
            _672 = mad(_589 * (dp4_f32(t10.Load((_674 >> 2u) + 10u), float4(_246[_686].x, _246[_686].y, _246[_686].z, _246[_686].w)) * clamp((abs((_707 > 3.1415927410125732421875f) ? (_706 - 4.7123889923095703125f) : _707) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _671, _671);
            _675 = _674 + 1u;
            _671 = _672;
            _674 = _675;
            continue;
        }
        float _718 = clamp(_671, 0.0f, 1.0f);
        float _731 = asfloat(cb0_m[43u].w);
        float _737 = abs(t10.Load(8u).x);
        float2 _740 = float2(_549 * 1.40999996662139892578125f, _550 * 1.40999996662139892578125f);
        float _742 = sqrt(dp2_f32(_740, _740));
        float _743 = min(_742, 1.0f);
        float _744 = _743 * _743;
        float _749 = clamp(_742 - 0.5f, 0.0f, 1.0f);
        float _752 = (_743 * _744) + (mad(-_743, _744, 1.0f) * (_749 * _749));
        float _753 = mad(mad(mad(sin(_731 * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _737, -1.0f);
        float _755 = _587 + _753;
        float _757 = clamp((_588 + _753) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _763 = clamp(_755 + _755, 0.0f, 1.0f);
        float _774 = mad(sin(_587 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f);
        float _781 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _786 = mad(exp2(log2(abs(_781)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _790 = _774 * (_786 * 0.02999999932944774627685546875f);
        float _791 = mad(_737, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _795 = mad(mad(-_752, _752, 1.0f), 1.0f - _791, _791);
        float _796 = min((exp2(log2(_752) * 0.699999988079071044921875f) * (mad(_763, -2.0f, 3.0f) * (_763 * _763))) + ((_757 * _757) * mad(_757, -2.0f, 3.0f)), 1.0f);
        float _806 = mad(_796, mad((_774 * _786) * 0.62000000476837158203125f, _795, mad(_667, _718, -_667)), mad(-_667, _718, _667));
        float _807 = mad(_796, mad(_795, _790, mad(_718, _668, -_668)), mad(-_718, _668, _668));
        float _808 = mad(_796, mad(_795, _790, mad(_718, _669, -_669)), mad(-_718, _669, _669));
        float _811 = mad(_587, _588 * (1.0f - _589), _589);
        float _813;
        _813 = 0.0f;
        float _814;
        uint _817;
        uint _816 = 0u;
        for (;;)
        {
            if (int(_816) >= 8)
            {
                break;
            }
            float4 _824 = t10.Load(_816);
            float _826 = _824.y;
            float _828 = _824.x - _581;
            _814 = mad(_811 * (_824.w * clamp((abs((_828 > 3.1415927410125732421875f) ? (_828 - 6.283185482025146484375f) : ((_828 < (-3.1415927410125732421875f)) ? (_828 + 6.283185482025146484375f) : _828)) + (_826 - 3.1415927410125732421875f)) / max(_826 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _813, _813);
            _817 = _816 + 1u;
            _813 = _814;
            _816 = _817;
            continue;
        }
        float _847 = clamp(_813 + _813, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _851 = mad(_847, 0.310000002384185791015625f - _806, _806);
        float _852 = mad(_847, 0.014999999664723873138427734375f - _807, _807);
        float _853 = mad(_847, 0.014999999664723873138427734375f - _808, _808);
        float4 _854 = t10.Load(12u);
        float _855 = _854.x;
        float _883;
        float _884;
        float _885;
        if (_855 != 0.0f)
        {
            float _862 = clamp(_781, 0.0f, 1.0f);
            float _872 = clamp((_586 + (_855 - 1.0f)) / max(mad(_855, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _876 = clamp(_855 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _879 = mad(_876, -2.0f, 3.0f) * (_876 * _876);
            _883 = mad(_879, _872 * (_862 * (_586 * 0.930000007152557373046875f)), _853);
            _884 = mad(_879, _872 * (_862 * (_586 * 0.85000002384185791015625f)), _852);
            _885 = mad((_862 * (_586 * 0.790000021457672119140625f)) * _872, _879, _851);
        }
        else
        {
            _883 = _853;
            _884 = _852;
            _885 = _851;
        }
        bool _888 = cb1_m22.x > 0.0f;
        bool _892 = frac((_350 * 420.0f) + (_731 * 0.20000000298023223876953125f)) >= 0.5f;
        float _893 = _892 ? 0.300000011920928955078125f : 0.0f;
        float _894 = _893 * cb1_m22.x;
        float _902 = _888 ? mad(_894, 0.0f - _885, _885) : _885;
        float _903 = _888 ? mad(_894, (_892 ? 0.100000001490116119384765625f : 0.0f) - _884, _884) : _884;
        float _904 = _888 ? mad(_894, _893 - _883, _883) : _883;
        float _909 = 1.0f / max(1.0f - max(max(_904, _903), _902), 6.099999882280826568603515625e-05f);
        float _916 = min(-(_909 * _902), 0.0f);
        float _917 = min(-(_909 * _903), 0.0f);
        float _918 = min(-(_909 * _904), 0.0f);
        float2 _919 = float2(_549, _550);
        float _930 = clamp(-((sqrt(dp2_f32(_919, _919)) - cb1_m7.x) * (1.0f / cb1_m7.y)), 0.0f, 1.0f);
        float _931 = mad(_930, -2.0f, 3.0f);
        float _932 = _930 * _930;
        float _933 = _931 * _932;
        float _935 = mad(-_931, _932, 1.0f);
        float _955 = cb1_m7.z * cb1_m7.w;
        float3 _965 = float3(mad(_916 + ((cb1_m5.x * _935) - (_916 * _933)), _955, -_916), mad(_955, ((cb1_m5.y * _935) - (_933 * _917)) + _917, -_917), mad(_955, ((_935 * cb1_m5.z) - (_933 * _918)) + _918, -_918));
#if 1
  float _972 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _965) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _965), 65504.0f);
  float _973 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _965) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _965), 65504.0f);
  float _974 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _965) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _965), 65504.0f);
#endif
        float _978 = max(max(_973, _972), _974);
        float _983 = (max(_978, 9.9999997473787516355514526367188e-05f) - max(min(min(_973, _972), _974), 9.9999997473787516355514526367188e-05f)) / max(_978, 0.00999999977648258209228515625f);
        float _994 = mad(sqrt(mad(_972 - _974, _972, ((_974 - _973) * _974) + ((_973 - _972) * _973))), 1.75f, (_974 + _973) + _972);
        float _995 = _983 - 0.4000000059604644775390625f;
        float _1000 = max(1.0f - abs(_995 * 2.5f), 0.0f);
        float _1007 = mad(mad(clamp(mad(_995, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1000, _1000, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1015 = ((_994 <= 0.1599999964237213134765625f) ? _1007 : ((_994 >= 0.4799999892711639404296875f) ? 0.0f : (_1007 * ((0.07999999821186065673828125f / (_994 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1016 = _1015 * _972;
        float _1017 = _1015 * _973;
        float _1018 = _1015 * _974;
        float _1023 = (_1017 - _1018) * 1.73205077648162841796875f;
        float _1025 = (_1016 * 2.0f) - _1017;
        float _1027 = mad(-_1015, _974, _1025);
        float _1028 = abs(_1027);
        float _1029 = abs(_1023);
        float _1033 = min(_1028, _1029) * (1.0f / max(_1028, _1029));
        float _1034 = _1033 * _1033;
        float _1038 = mad(_1034, mad(_1034, mad(_1034, mad(_1034, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1048 = mad(_1033, _1038, (_1028 < _1029) ? mad(_1033 * _1038, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1027 < mad(_1015, _974, -_1025)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1049 = min(_1023, _1027);
        float _1050 = max(_1023, _1027);
        float _1059 = ((_1016 == _1017) && (_1018 == _1017)) ? 0.0f : ((((_1049 < (-_1049)) && (_1050 >= (-_1050))) ? (-_1048) : _1048) * 57.295780181884765625f);
        float _1062 = (_1059 < 0.0f) ? (_1059 + 360.0f) : _1059;
        float _1072 = max(1.0f - abs(((_1062 < (-180.0f)) ? (_1062 + 360.0f) : ((_1062 > 180.0f) ? (_1062 - 360.0f) : _1062)) * 0.01481481455266475677490234375f), 0.0f);
        float _1075 = mad(_1072, -2.0f, 3.0f) * (_1072 * _1072);
        float3 _1086 = float3(clamp(_1016 + (((_983 * (_1075 * _1075)) * mad(-_1015, _972, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1017, 0.0f, 65504.0f), clamp(_1018, 0.0f, 65504.0f));
        float _1090 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1086), 0.0f, 65504.0f);
        float _1091 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1086), 0.0f, 65504.0f);
        float _1092 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1086), 0.0f, 65504.0f);

        float _1094 = dp3_f32(float3(_1090, _1091, _1092), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1101 = float3(mad(_1090 - _1094, 0.959999978542327880859375f, _1094), mad(_1091 - _1094, 0.959999978542327880859375f, _1094), mad(_1092 - _1094, 0.959999978542327880859375f, _1094));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_524] = float4(CustomACES(_1101), 1.f);
    return;
  }
#endif
        float3 _1105 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1101), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1101), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1101));
        float _1106 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1105);
        float _1107 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1105);
        float _1108 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1105);
        uint _1110;
        spvTextureSize(t9, 0u, _1110);
        bool _1111 = _1110 > 0u;
        uint _1112_dummy_parameter;
        _1113 _1114 = { spvTextureSize(t9, 0u, _1112_dummy_parameter), 1u };
        float _1117 = float(_1111 ? _1114._m0.x : 0u);
        float _1120 = float(_1111 ? _1114._m0.y : 0u);
        float _1123 = float(_1111 ? _1114._m0.z : 0u);
        float _1127 = float(_1107 >= _1108);
        float _1128 = mad(_1107 - _1108, _1127, _1108);
        float _1129 = mad(_1127, _1108 - _1107, _1107);
        float _1131 = mad(_1127, -1.0f, 0.666666686534881591796875f);
        float _1137 = float(_1106 >= _1128);
        float _1138 = mad(_1106 - _1128, _1137, _1128);
        float _1139 = mad(_1129 - _1129, _1137, _1129);
        float _1141 = mad(_1128 - _1106, _1137, _1106);
        float _1143 = _1138 - min(_1141, _1139);
        float4 _1167 = t9.SampleLevel(s7, float3(abs(mad(mad(_1127, 1.0f, -1.0f) - _1131, _1137, _1131) + ((_1141 - _1139) / mad(_1143, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1117 + _1117)), (1.0f / (_1120 + _1120)) + (_1143 / (_1138 + 9.9999997473787516355514526367188e-05f)), mad(_1138 * 3.0f, 1.0f / mad(_1138, 3.0f, 1.5f), 1.0f / (_1123 + _1123))), 0.0f);
        float _1168 = _1167.x;
        float _1169 = _1167.y;
        float _1170 = _1167.z;
        float3 _1198 = float3(mad(_1170, mad(_1169, clamp(abs(mad(frac(_1168 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1168 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1169, 1.0f), _1170, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1168 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1169, 1.0f), _1170, -3.5073844628641381859779357910156e-05f));
        float3 _1202 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1198), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1198), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1198));
        float3 _1206 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1202), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1202), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1202));
        float _1215 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1206) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1226 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1206) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1236 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1206) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_524] = float4(min(exp2(log2(mad(_1215, 18.8515625f, 0.8359375f) / mad(_1215, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1226, 18.8515625f, 0.8359375f) / mad(_1226, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1236, 18.8515625f, 0.8359375f) / mad(_1236, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

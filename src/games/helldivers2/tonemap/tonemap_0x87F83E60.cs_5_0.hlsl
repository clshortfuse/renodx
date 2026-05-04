#include "../common.hlsl"
struct _327
{
    uint2 _m0;
    uint _m1;
};

struct _1221
{
    uint3 _m0;
    uint _m1;
};

static const float _56[1] = { 0.0f };
static const float4 _269[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _318 = a.x * b.x;
    return mad(a.y, b.y, _318);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _304 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _304));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _286 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _286)));
}

void comp_main()
{
    uint _326_dummy_parameter;
    _327 _328 = { spvImageSize(u0, _326_dummy_parameter), 1u };
    uint _343 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _347 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_343, 1u, 3u);
    uint _348 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _343, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _355 = (float(_347) + 0.5f) / float(_328._m0.x);
    float _356 = (float(_348) + 0.5f) / float(_328._m0.y);
    bool _366 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _366) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _381 = float2(_355, _356);
    float _386 = mad(t4.SampleLevel(s3, _381, 0.0f).x, 2.0f, -1.0f);
    float _401;
    if (_386 > 0.0f)
    {
        _401 = min(sqrt(_386), t0.Load(8u).x);
    }
    else
    {
        _401 = max(_386, -t0.Load(7u).x);
    }
    float4 _405 = t3.SampleLevel(s2, _381, 0.0f);
    float2 _417 = float2(_405.x * asfloat(cb1_m[2u].x), _405.y * asfloat(cb1_m[2u].y));
    bool _432 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _437 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float _441 = abs(_401);
    float _449 = exp2(max(_432 ? clamp((sqrt(dp2_f32(_417, _417)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _437 ? clamp((_441 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _450 = _355 - 0.5f;
    float _451 = _356 - 0.5f;
    float2 _452 = float2(_450, _451);
    float _453 = dp2_f32(_452, _452);
    float _456 = asfloat(cb1_m[18u].x);
    float _457 = mad(_453, _456, 1.0f);
    float _463 = asfloat(cb1_m[18u].z);
    float _470 = asfloat(cb1_m[18u].y);
    float _482 = mad(exp2(log2(clamp(_456, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(asfloat(cb1_m[18u].y), -0.089999973773956298828125f, 1.0f);
    float _483 = (_457 * mad(_470, mad(_463, -0.001999996602535247802734375f, 0.092000000178813934326171875f), 1.0f)) * _482;
    float _484 = _482 * (_457 * mad(_470, mad(_463, 0.04500000178813934326171875f, 0.046999998390674591064453125f), 1.0f));
    float _485 = _482 * (_457 * mad(_470, mad(_463, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _486 = mad(_450, _483, 0.5f);
    float _487 = mad(_483, _451, 0.5f);
    float _488 = mad(_450, _484, 0.5f);
    float _489 = mad(_484, _451, 0.5f);
    float2 _492 = float2(_486, _487);
    float4 _494 = t1.SampleLevel(s0, _492, 0.0f);
    float _495 = _494.x;
    bool _496 = _437 || _432;
    float _529;
    if (_496)
    {
        float4 _502 = t2.SampleLevel(s1, _492, 0.0f);
        float _503 = _502.x;
        float _510 = asfloat(cb0_m[43u].w) * 20.0f;
        float _526 = mad(mad(t7.SampleLevel(s5, float2(mad(_486, 30.0f, sin(_510)), mad(_487, 30.0f, cos(_510))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_503, max(_502.y, _502.z)), 1.0000000133514319600180897396058e-10f)), _503);
        _529 = mad(_449, _495 - _526, _526);
    }
    else
    {
        _529 = _495;
    }
    float2 _530 = float2(_488, _489);
    float4 _532 = t1.SampleLevel(s0, _530, 0.0f);
    float _533 = _532.y;
    float _566;
    if (_496)
    {
        float4 _539 = t2.SampleLevel(s1, _530, 0.0f);
        float _541 = _539.y;
        float _547 = asfloat(cb0_m[43u].w) * 20.0f;
        float _563 = mad(mad(t7.SampleLevel(s5, float2(mad(_488, 30.0f, sin(_547)), mad(_489, 30.0f, cos(_547))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_539.x, max(_541, _539.z)), 1.0000000133514319600180897396058e-10f)), _541);
        _566 = mad(_449, _533 - _563, _563);
    }
    else
    {
        _566 = _533;
    }
    float _567 = mad(_450, _485, 0.5f);
    float _568 = mad(_451, _485, 0.5f);
    float2 _569 = float2(_567, _568);
    float4 _571 = t1.SampleLevel(s0, _569, 0.0f);
    float _572 = _571.z;
    float _605;
    if (_496)
    {
        float4 _578 = t2.SampleLevel(s1, _569, 0.0f);
        float _581 = _578.z;
        float _586 = asfloat(cb0_m[43u].w) * 20.0f;
        float _602 = mad(mad(t7.SampleLevel(s5, float2(mad(_567, 30.0f, sin(_586)), mad(_568, 30.0f, cos(_586))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_578.x, max(_578.y, _581)), 1.0000000133514319600180897396058e-10f)), _581);
        _605 = mad(_449, _572 - _602, _602);
    }
    else
    {
        _605 = _572;
    }
    float _611 = _366 ? g0[0u] : asfloat(cb1_m[2u].z);
    float4 _615 = t5.SampleLevel(s4, _381, 0.0f);
    float _616 = _615.x;
    float _625 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_616, _615.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _629 = mad(_529, _611, _616 / _625);
    float _630 = mad(_566, _611, _615.y / _625);
    float _631 = mad(_605, _611, _615.z / _625);
    float _635 = 1.0f / (max(_629, max(_631, _630)) + 1.0f);
    float _636 = _629 * _635;
    float _638 = _631 * _635;
    float3 _639 = float3(_636, _638, _630 * _635);
    float _640 = dp3_f32(_639, float3(0.25f, 0.25f, 0.5f));
    float _641 = dp3_f32(_639, float3(-0.25f, -0.25f, 0.5f));
    float _643 = dp2_f32(float2(_636, _638), float2(0.5f, -0.5f));
    uint2 _645 = uint2(_347, _348);
    u1[_645] = float4(_640, _643, _641, _640);
    if (!((_328._m0.x < _347) || (_328._m0.y < _348)))
    {
        float _650 = _640 - _641;
        float _651 = _643 + _650;
        float _652 = _640 + _641;
        float _653 = _650 - _643;
        float _655 = dp3_f32(float3(_651, _652, _653), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _664 = mad(-_441, asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _668 = mad(_664, _651 - _655, _655);
        float _669 = mad(_652 - _655, _664, _655);
        float _670 = mad(_653 - _655, _664, _655);
        float _671 = _451 + _451;
        float _672 = _450 + _450;
        float _673 = abs(_672);
        float _674 = abs(_671);
        float _678 = min(_673, _674) * (1.0f / max(_673, _674));
        float _679 = _678 * _678;
        float _683 = mad(_679, mad(_679, mad(_679, mad(_679, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _692 = mad(_678, _683, (_673 < _674) ? mad(_678 * _683, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_672 < (-_672)) ? (-3.1415927410125732421875f) : 0.0f);
        float _693 = min(_672, _671);
        float _694 = max(_672, _671);
        float _701 = ((_693 < (-_693)) && (_694 >= (-_694))) ? (-_692) : _692;
        float4 _705 = t8.SampleLevel(s6, _381, 0.0f);
        float _706 = _705.x;
        float _707 = _705.y;
        float _708 = _705.z;
        float _709 = _705.w;
        float _714 = (_669 - _670) * 1.73205077648162841796875f;
        float _716 = mad(_668, 2.0f, -_669);
        float _717 = _716 - _670;
        float _718 = abs(_717);
        float _719 = abs(_714);
        float _723 = min(_718, _719) * (1.0f / max(_718, _719));
        float _724 = _723 * _723;
        float _728 = mad(_724, mad(_724, mad(_724, mad(_724, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _737 = mad(_723, _728, (_718 < _719) ? mad(_723 * _728, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_717 < (_670 - _716)) ? (-3.1415927410125732421875f) : 0.0f);
        float _738 = min(_714, _717);
        float _739 = max(_714, _717);
        float _748 = ((_670 == _669) && (_669 == _668)) ? 0.0f : ((((_738 < (-_738)) && (_739 >= (-_739))) ? (-_737) : _737) * 57.295780181884765625f);
        float _759 = mad(asfloat(cb1_m[19u].x), -360.0f, (_748 < 0.0f) ? (_748 + 360.0f) : _748);
        float _769 = clamp(1.0f - (abs((_759 < (-180.0f)) ? (_759 + 360.0f) : ((_759 > 180.0f) ? (_759 - 360.0f) : _759)) / (asfloat(cb1_m[19u].y) * 180.0f)), 0.0f, 1.0f);
        float _774 = dp3_f32(float3(_668, _669, _670), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _778 = (mad(_769, -2.0f, 3.0f) * (_769 * _769)) * asfloat(cb1_m[19u].z);
        float _790 = asfloat(cb1_m[18u].w);
        float _791 = mad(mad(_778, _668 - _774, _774) - _668, _790, _668);
        float _792 = mad(_790, mad(_778, _669 - _774, _774) - _669, _669);
        float _793 = mad(_790, mad(_778, _670 - _774, _774) - _670, _670);
        float _795;
        _795 = 0.0f;
        float _796;
        uint _799;
        uint _798 = 0u;
        for (;;)
        {
            if (_798 >= 8u)
            {
                break;
            }
            uint _810 = min((_798 & 3u), 4u);
            float _830 = mad(float(_798), 0.785398185253143310546875f, -_701);
            float _831 = _830 + 1.57079637050628662109375f;
            _796 = mad(_709 * (dp4_f32(t10.Load((_798 >> 2u) + 10u), float4(_269[_810].x, _269[_810].y, _269[_810].z, _269[_810].w)) * clamp((abs((_831 > 3.1415927410125732421875f) ? (_830 - 4.7123889923095703125f) : _831) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _795, _795);
            _799 = _798 + 1u;
            _795 = _796;
            _798 = _799;
            continue;
        }
        float _842 = clamp(_795, 0.0f, 1.0f);
        float _860 = abs(t10.Load(8u).x);
        float2 _863 = float2(_450 * 1.40999996662139892578125f, _451 * 1.40999996662139892578125f);
        float _865 = sqrt(dp2_f32(_863, _863));
        float _866 = min(_865, 1.0f);
        float _867 = _866 * _866;
        float _872 = clamp(_865 - 0.5f, 0.0f, 1.0f);
        float _875 = (_866 * _867) + (mad(-_866, _867, 1.0f) * (_872 * _872));
        float _876 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _860, -1.0f);
        float _878 = _707 + _876;
        float _880 = clamp((_708 + _876) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _886 = clamp(_878 + _878, 0.0f, 1.0f);
        float _897 = mad(sin(_707 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f);
        float _904 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _909 = mad(exp2(log2(abs(_904)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _913 = _897 * (_909 * 0.02999999932944774627685546875f);
        float _914 = mad(_860, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _918 = mad(mad(-_875, _875, 1.0f), 1.0f - _914, _914);
        float _919 = min((exp2(log2(_875) * 0.699999988079071044921875f) * (mad(_886, -2.0f, 3.0f) * (_886 * _886))) + ((_880 * _880) * mad(_880, -2.0f, 3.0f)), 1.0f);
        float _929 = mad(_919, mad((_897 * _909) * 0.62000000476837158203125f, _918, mad(_791, _842, -_791)), mad(-_791, _842, _791));
        float _930 = mad(_919, mad(_918, _913, mad(_842, _792, -_792)), mad(-_842, _792, _792));
        float _931 = mad(_919, mad(_918, _913, mad(_842, _793, -_793)), mad(-_842, _793, _793));
        float _934 = mad(_707, _708 * (1.0f - _709), _709);
        float _936;
        _936 = 0.0f;
        float _937;
        uint _940;
        uint _939 = 0u;
        for (;;)
        {
            if (int(_939) >= 8)
            {
                break;
            }
            float4 _947 = t10.Load(_939);
            float _949 = _947.y;
            float _951 = _947.x - _701;
            _937 = mad(_934 * (_947.w * clamp((abs((_951 > 3.1415927410125732421875f) ? (_951 - 6.283185482025146484375f) : ((_951 < (-3.1415927410125732421875f)) ? (_951 + 6.283185482025146484375f) : _951)) + (_949 - 3.1415927410125732421875f)) / max(_949 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _936, _936);
            _940 = _939 + 1u;
            _936 = _937;
            _939 = _940;
            continue;
        }
        float _970 = clamp(_936 + _936, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _974 = mad(_970, 0.310000002384185791015625f - _929, _929);
        float _975 = mad(_970, 0.014999999664723873138427734375f - _930, _930);
        float _976 = mad(_970, 0.014999999664723873138427734375f - _931, _931);
        float4 _977 = t10.Load(12u);
        float _978 = _977.x;
        float _1006;
        float _1007;
        float _1008;
        if (_978 != 0.0f)
        {
            float _985 = clamp(_904, 0.0f, 1.0f);
            float _995 = clamp((_706 + (_978 - 1.0f)) / max(mad(_978, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _999 = clamp(_978 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _1002 = mad(_999, -2.0f, 3.0f) * (_999 * _999);
            _1006 = mad((_985 * (_706 * 0.790000021457672119140625f)) * _995, _1002, _974);
            _1007 = mad(_1002, _995 * (_985 * (_706 * 0.85000002384185791015625f)), _975);
            _1008 = mad(_1002, _995 * (_985 * (_706 * 0.930000007152557373046875f)), _976);
        }
        else
        {
            _1006 = _974;
            _1007 = _975;
            _1008 = _976;
        }
        float _1013 = 1.0f / max(1.0f - max(max(_1008, _1007), _1006), 6.099999882280826568603515625e-05f);
        float _1020 = min(-(_1013 * _1006), 0.0f);
        float _1021 = min(-(_1013 * _1007), 0.0f);
        float _1022 = min(-(_1013 * _1008), 0.0f);
        float _1034 = clamp(-((1.0f / asfloat(cb1_m[5u].y)) * (sqrt(_453) - asfloat(cb1_m[5u].x))), 0.0f, 1.0f);
        float _1035 = mad(_1034, -2.0f, 3.0f);
        float _1036 = _1034 * _1034;
        float _1037 = _1035 * _1036;
        float _1039 = mad(-_1035, _1036, 1.0f);
        float _1063 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
        float3 _1073 = float3(mad(_1020 + ((_1039 * asfloat(cb1_m[4u].x)) - (_1020 * _1037)), _1063, -_1020), mad(_1063, ((_1039 * asfloat(cb1_m[4u].y)) - (_1037 * _1021)) + _1021, -_1021), mad(_1063, ((_1039 * asfloat(cb1_m[4u].z)) - (_1037 * _1022)) + _1022, -_1022));
#if 1
  float _1080 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1073) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1073), 65504.0f);
  float _1081 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1073) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1073), 65504.0f);
  float _1082 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1073) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1073), 65504.0f);
#endif
        float _1086 = max(max(_1081, _1080), _1082);
        float _1091 = (max(_1086, 9.9999997473787516355514526367188e-05f) - max(min(min(_1081, _1080), _1082), 9.9999997473787516355514526367188e-05f)) / max(_1086, 0.00999999977648258209228515625f);
        float _1102 = mad(sqrt(mad(_1080 - _1082, _1080, ((_1082 - _1081) * _1082) + ((_1081 - _1080) * _1081))), 1.75f, (_1082 + _1081) + _1080);
        float _1103 = _1091 - 0.4000000059604644775390625f;
        float _1108 = max(1.0f - abs(_1103 * 2.5f), 0.0f);
        float _1115 = mad(mad(clamp(mad(_1103, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1108, _1108, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1123 = ((_1102 <= 0.1599999964237213134765625f) ? _1115 : ((_1102 >= 0.4799999892711639404296875f) ? 0.0f : (_1115 * ((0.07999999821186065673828125f / (_1102 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1124 = _1123 * _1080;
        float _1125 = _1123 * _1081;
        float _1126 = _1123 * _1082;
        float _1131 = (_1125 - _1126) * 1.73205077648162841796875f;
        float _1133 = (_1124 * 2.0f) - _1125;
        float _1135 = mad(-_1123, _1082, _1133);
        float _1136 = abs(_1135);
        float _1137 = abs(_1131);
        float _1141 = min(_1136, _1137) * (1.0f / max(_1136, _1137));
        float _1142 = _1141 * _1141;
        float _1146 = mad(_1142, mad(_1142, mad(_1142, mad(_1142, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1156 = mad(_1141, _1146, (_1136 < _1137) ? mad(_1141 * _1146, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1135 < mad(_1123, _1082, -_1133)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1157 = min(_1131, _1135);
        float _1158 = max(_1131, _1135);
        float _1167 = ((_1124 == _1125) && (_1126 == _1125)) ? 0.0f : ((((_1157 < (-_1157)) && (_1158 >= (-_1158))) ? (-_1156) : _1156) * 57.295780181884765625f);
        float _1170 = (_1167 < 0.0f) ? (_1167 + 360.0f) : _1167;
        float _1180 = max(1.0f - abs(((_1170 < (-180.0f)) ? (_1170 + 360.0f) : ((_1170 > 180.0f) ? (_1170 - 360.0f) : _1170)) * 0.01481481455266475677490234375f), 0.0f);
        float _1183 = mad(_1180, -2.0f, 3.0f) * (_1180 * _1180);
        float3 _1194 = float3(clamp(_1124 + (((_1091 * (_1183 * _1183)) * mad(-_1123, _1080, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1125, 0.0f, 65504.0f), clamp(_1126, 0.0f, 65504.0f));
        float _1198 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1194), 0.0f, 65504.0f);
        float _1199 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1194), 0.0f, 65504.0f);
        float _1200 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1194), 0.0f, 65504.0f);

        float _1202 = dp3_f32(float3(_1198, _1199, _1200), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1209 = float3(mad(_1198 - _1202, 0.959999978542327880859375f, _1202), mad(_1199 - _1202, 0.959999978542327880859375f, _1202), mad(_1200 - _1202, 0.959999978542327880859375f, _1202));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_645] = float4(CustomACES(_1209), 1.f);
    return;
  }
#endif
        float3 _1213 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1209), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1209), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1209));
        float _1214 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1213);
        float _1215 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1213);
        float _1216 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1213);
        uint _1218;
        spvTextureSize(t9, 0u, _1218);
        bool _1219 = _1218 > 0u;
        uint _1220_dummy_parameter;
        _1221 _1222 = { spvTextureSize(t9, 0u, _1220_dummy_parameter), 1u };
        float _1225 = float(_1219 ? _1222._m0.x : 0u);
        float _1228 = float(_1219 ? _1222._m0.y : 0u);
        float _1231 = float(_1219 ? _1222._m0.z : 0u);
        float _1235 = float(_1215 >= _1216);
        float _1236 = mad(_1215 - _1216, _1235, _1216);
        float _1237 = mad(_1235, _1216 - _1215, _1215);
        float _1239 = mad(_1235, -1.0f, 0.666666686534881591796875f);
        float _1245 = float(_1214 >= _1236);
        float _1246 = mad(_1214 - _1236, _1245, _1236);
        float _1247 = mad(_1245, _1237 - _1237, _1237);
        float _1249 = mad(_1245, _1236 - _1214, _1214);
        float _1251 = _1246 - min(_1249, _1247);
        float4 _1275 = t9.SampleLevel(s7, float3(abs(mad(_1245, mad(_1235, 1.0f, -1.0f) - _1239, _1239) + ((_1249 - _1247) / mad(_1251, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1225 + _1225)), (1.0f / (_1228 + _1228)) + (_1251 / (_1246 + 9.9999997473787516355514526367188e-05f)), mad(_1246 * 3.0f, 1.0f / mad(_1246, 3.0f, 1.5f), 1.0f / (_1231 + _1231))), 0.0f);
        float _1276 = _1275.x;
        float _1277 = _1275.y;
        float _1278 = _1275.z;
        float3 _1306 = float3(mad(_1278, mad(_1277, clamp(abs(mad(frac(_1276 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1276 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1277, 1.0f), _1278, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1276 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1277, 1.0f), _1278, -3.5073844628641381859779357910156e-05f));
        float3 _1310 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1306), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1306), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1306));
        float3 _1314 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1310), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1310), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1310));
        float _1323 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1314) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1334 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1314) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1344 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1314) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_645] = float4(min(exp2(log2(mad(_1323, 18.8515625f, 0.8359375f) / mad(_1323, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1334, 18.8515625f, 0.8359375f) / mad(_1334, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1344, 18.8515625f, 0.8359375f) / mad(_1344, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

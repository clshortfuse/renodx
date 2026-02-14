#include "../common.hlsl"
struct _326
{
    uint2 _m0;
    uint _m1;
};

struct _1217
{
    uint3 _m0;
    uint _m1;
};

static const float _55[1] = { 0.0f };
static const float4 _268[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _317 = a.x * b.x;
    return mad(a.y, b.y, _317);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _303 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _303));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _285 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _285)));
}

void comp_main()
{
    uint _325_dummy_parameter;
    _326 _327 = { spvImageSize(u0, _325_dummy_parameter), 1u };
    uint _342 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _346 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_342, 1u, 3u);
    uint _347 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _342, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _354 = (float(_346) + 0.5f) / float(_327._m0.x);
    float _355 = (float(_347) + 0.5f) / float(_327._m0.y);
    bool _365 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _365) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _380 = float2(_354, _355);
    float _385 = mad(t4.SampleLevel(s3, _380, 0.0f).x, 2.0f, -1.0f);
    float _400;
    if (_385 > 0.0f)
    {
        _400 = min(sqrt(_385), t0.Load(8u).x);
    }
    else
    {
        _400 = max(_385, -t0.Load(7u).x);
    }
    float4 _404 = t3.SampleLevel(s2, _380, 0.0f);
    float2 _416 = float2(_404.x * asfloat(cb1_m[2u].x), _404.y * asfloat(cb1_m[2u].y));
    bool _431 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _436 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float _440 = abs(_400);
    float _448 = exp2(max(_431 ? clamp((sqrt(dp2_f32(_416, _416)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _436 ? clamp((_440 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _449 = _354 - 0.5f;
    float _450 = _355 - 0.5f;
    float2 _451 = float2(_449, _450);
    float _452 = dp2_f32(_451, _451);
    float _455 = asfloat(cb1_m[18u].x);
    float _456 = mad(_452, _455, 1.0f);
    float _462 = asfloat(cb1_m[18u].z);
    float _469 = asfloat(cb1_m[18u].y);
    float _481 = mad(exp2(log2(clamp(_455, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(asfloat(cb1_m[18u].y), -0.089999973773956298828125f, 1.0f);
    float _482 = (_456 * mad(_469, mad(_462, -0.001999996602535247802734375f, 0.092000000178813934326171875f), 1.0f)) * _481;
    float _483 = _481 * (_456 * mad(_469, mad(_462, 0.04500000178813934326171875f, 0.046999998390674591064453125f), 1.0f));
    float _484 = _481 * (_456 * mad(_469, mad(_462, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _485 = mad(_449, _482, 0.5f);
    float _486 = mad(_482, _450, 0.5f);
    float _487 = mad(_449, _483, 0.5f);
    float _488 = mad(_450, _483, 0.5f);
    float2 _491 = float2(_485, _486);
    float4 _493 = t1.SampleLevel(s0, _491, 0.0f);
    float _494 = _493.x;
    bool _495 = _436 || _431;
    float _528;
    if (_495)
    {
        float4 _501 = t2.SampleLevel(s1, _491, 0.0f);
        float _502 = _501.x;
        float _509 = asfloat(cb0_m[43u].w) * 20.0f;
        float _525 = mad(mad(t7.SampleLevel(s5, float2(mad(_485, 30.0f, sin(_509)), mad(_486, 30.0f, cos(_509))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_502, max(_501.y, _501.z)), 1.0000000133514319600180897396058e-10f)), _502);
        _528 = mad(_448, _494 - _525, _525);
    }
    else
    {
        _528 = _494;
    }
    float2 _529 = float2(_487, _488);
    float4 _531 = t1.SampleLevel(s0, _529, 0.0f);
    float _532 = _531.y;
    float _565;
    if (_495)
    {
        float4 _538 = t2.SampleLevel(s1, _529, 0.0f);
        float _540 = _538.y;
        float _546 = asfloat(cb0_m[43u].w) * 20.0f;
        float _562 = mad(mad(t7.SampleLevel(s5, float2(mad(_487, 30.0f, sin(_546)), mad(_488, 30.0f, cos(_546))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_538.x, max(_540, _538.z)), 1.0000000133514319600180897396058e-10f)), _540);
        _565 = mad(_448, _532 - _562, _562);
    }
    else
    {
        _565 = _532;
    }
    float _566 = mad(_449, _484, 0.5f);
    float _567 = mad(_450, _484, 0.5f);
    float2 _568 = float2(_566, _567);
    float4 _570 = t1.SampleLevel(s0, _568, 0.0f);
    float _571 = _570.z;
    float _604;
    if (_495)
    {
        float4 _577 = t2.SampleLevel(s1, _568, 0.0f);
        float _580 = _577.z;
        float _585 = asfloat(cb0_m[43u].w) * 20.0f;
        float _601 = mad(mad(t7.SampleLevel(s5, float2(mad(_566, 30.0f, sin(_585)), mad(_567, 30.0f, cos(_585))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_577.x, max(_577.y, _580)), 1.0000000133514319600180897396058e-10f)), _580);
        _604 = mad(_448, _571 - _601, _601);
    }
    else
    {
        _604 = _571;
    }
    if (!((_327._m0.x < _346) || (_327._m0.y < _347)))
    {
        float _613 = _365 ? g0[0u] : asfloat(cb1_m[2u].z);
        float4 _617 = t5.SampleLevel(s4, _380, 0.0f);
        float _618 = _617.x;
        float _627 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_618, _617.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
        float _631 = mad(_528, _613, _618 / _627);
        float _632 = mad(_565, _613, _617.y / _627);
        float _633 = mad(_604, _613, _617.z / _627);
        float _637 = 1.0f / (max(_631, max(_633, _632)) + 1.0f);
        float _638 = _631 * _637;
        float _640 = _633 * _637;
        float3 _641 = float3(_638, _640, _632 * _637);
        float _642 = dp3_f32(_641, float3(0.25f, 0.25f, 0.5f));
        float _643 = dp3_f32(_641, float3(-0.25f, -0.25f, 0.5f));
        float _645 = dp2_f32(float2(_638, _640), float2(0.5f, -0.5f));
        float _646 = _642 - _643;
        float _647 = _645 + _646;
        float _648 = _642 + _643;
        float _649 = _646 - _645;
        float _651 = dp3_f32(float3(_647, _648, _649), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _660 = mad(-_440, asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _664 = mad(_660, _647 - _651, _651);
        float _665 = mad(_648 - _651, _660, _651);
        float _666 = mad(_649 - _651, _660, _651);
        float _667 = _450 + _450;
        float _668 = _449 + _449;
        float _669 = abs(_668);
        float _670 = abs(_667);
        float _674 = min(_669, _670) * (1.0f / max(_669, _670));
        float _675 = _674 * _674;
        float _679 = mad(_675, mad(_675, mad(_675, mad(_675, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _688 = mad(_674, _679, (_669 < _670) ? mad(_674 * _679, -2.0f, 1.57079637050628662109375f) : 0.0f) + (((-_668) > _668) ? (-3.1415927410125732421875f) : 0.0f);
        float _689 = min(_667, _668);
        float _690 = max(_667, _668);
        float _697 = ((_689 < (-_689)) && (_690 >= (-_690))) ? (-_688) : _688;
        float4 _701 = t8.SampleLevel(s6, _380, 0.0f);
        float _702 = _701.x;
        float _703 = _701.y;
        float _704 = _701.z;
        float _705 = _701.w;
        float _710 = (_665 - _666) * 1.73205077648162841796875f;
        float _712 = mad(_664, 2.0f, -_665);
        float _713 = _712 - _666;
        float _714 = abs(_713);
        float _715 = abs(_710);
        float _719 = min(_714, _715) * (1.0f / max(_714, _715));
        float _720 = _719 * _719;
        float _724 = mad(_720, mad(_720, mad(_720, mad(_720, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _733 = mad(_719, _724, (_714 < _715) ? mad(_719 * _724, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_713 < (_666 - _712)) ? (-3.1415927410125732421875f) : 0.0f);
        float _734 = min(_710, _713);
        float _735 = max(_710, _713);
        float _744 = ((_665 == _664) && (_665 == _666)) ? 0.0f : ((((_734 < (-_734)) && (_735 >= (-_735))) ? (-_733) : _733) * 57.295780181884765625f);
        float _755 = mad(asfloat(cb1_m[19u].x), -360.0f, (_744 < 0.0f) ? (_744 + 360.0f) : _744);
        float _765 = clamp(1.0f - (abs((_755 < (-180.0f)) ? (_755 + 360.0f) : ((_755 > 180.0f) ? (_755 - 360.0f) : _755)) / (asfloat(cb1_m[19u].y) * 180.0f)), 0.0f, 1.0f);
        float _770 = dp3_f32(float3(_664, _665, _666), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _774 = (mad(_765, -2.0f, 3.0f) * (_765 * _765)) * asfloat(cb1_m[19u].z);
        float _786 = asfloat(cb1_m[18u].w);
        float _787 = mad(mad(_774, _664 - _770, _770) - _664, _786, _664);
        float _788 = mad(_786, mad(_774, _665 - _770, _770) - _665, _665);
        float _789 = mad(_786, mad(_774, _666 - _770, _770) - _666, _666);
        float _791;
        _791 = 0.0f;
        float _792;
        uint _795;
        uint _794 = 0u;
        for (;;)
        {
            if (_794 >= 8u)
            {
                break;
            }
            uint _806 = min((_794 & 3u), 4u);
            float _826 = mad(float(_794), 0.785398185253143310546875f, -_697);
            float _827 = _826 + 1.57079637050628662109375f;
            _792 = mad(_705 * (dp4_f32(t10.Load((_794 >> 2u) + 10u), float4(_268[_806].x, _268[_806].y, _268[_806].z, _268[_806].w)) * clamp((abs((_827 > 3.1415927410125732421875f) ? (_826 - 4.7123889923095703125f) : _827) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _791, _791);
            _795 = _794 + 1u;
            _791 = _792;
            _794 = _795;
            continue;
        }
        float _838 = clamp(_791, 0.0f, 1.0f);
        float _856 = abs(t10.Load(8u).x);
        float2 _859 = float2(_449 * 1.40999996662139892578125f, _450 * 1.40999996662139892578125f);
        float _861 = sqrt(dp2_f32(_859, _859));
        float _862 = min(_861, 1.0f);
        float _863 = _862 * _862;
        float _868 = clamp(_861 - 0.5f, 0.0f, 1.0f);
        float _871 = (_862 * _863) + (mad(-_862, _863, 1.0f) * (_868 * _868));
        float _872 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _856, -1.0f);
        float _874 = _703 + _872;
        float _876 = clamp((_704 + _872) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _882 = clamp(_874 + _874, 0.0f, 1.0f);
        float _893 = mad(sin(_703 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f);
        float _900 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _905 = mad(exp2(log2(abs(_900)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _909 = _893 * (_905 * 0.02999999932944774627685546875f);
        float _910 = mad(_856, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _914 = mad(mad(-_871, _871, 1.0f), 1.0f - _910, _910);
        float _915 = min((exp2(log2(_871) * 0.699999988079071044921875f) * (mad(_882, -2.0f, 3.0f) * (_882 * _882))) + ((_876 * _876) * mad(_876, -2.0f, 3.0f)), 1.0f);
        float _925 = mad(_915, mad((_893 * _905) * 0.62000000476837158203125f, _914, mad(_787, _838, -_787)), mad(-_787, _838, _787));
        float _926 = mad(_915, mad(_914, _909, mad(_838, _788, -_788)), mad(-_838, _788, _788));
        float _927 = mad(_915, mad(_914, _909, mad(_838, _789, -_789)), mad(-_838, _789, _789));
        float _930 = mad(_703, _704 * (1.0f - _705), _705);
        float _932;
        _932 = 0.0f;
        float _933;
        uint _936;
        uint _935 = 0u;
        for (;;)
        {
            if (int(_935) >= 8)
            {
                break;
            }
            float4 _943 = t10.Load(_935);
            float _945 = _943.y;
            float _947 = _943.x - _697;
            _933 = mad(_930 * (_943.w * clamp((abs((_947 > 3.1415927410125732421875f) ? (_947 - 6.283185482025146484375f) : ((_947 < (-3.1415927410125732421875f)) ? (_947 + 6.283185482025146484375f) : _947)) + (_945 - 3.1415927410125732421875f)) / max(_945 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _932, _932);
            _936 = _935 + 1u;
            _932 = _933;
            _935 = _936;
            continue;
        }
        float _966 = clamp(_932 + _932, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _970 = mad(_966, 0.310000002384185791015625f - _925, _925);
        float _971 = mad(_966, 0.014999999664723873138427734375f - _926, _926);
        float _972 = mad(_966, 0.014999999664723873138427734375f - _927, _927);
        float4 _973 = t10.Load(12u);
        float _974 = _973.x;
        float _1002;
        float _1003;
        float _1004;
        if (_974 != 0.0f)
        {
            float _981 = clamp(_900, 0.0f, 1.0f);
            float _991 = clamp((_702 + (_974 - 1.0f)) / max(mad(_974, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _995 = clamp(_974 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _998 = mad(_995, -2.0f, 3.0f) * (_995 * _995);
            _1002 = mad((_981 * (_702 * 0.790000021457672119140625f)) * _991, _998, _970);
            _1003 = mad(_998, _991 * (_981 * (_702 * 0.85000002384185791015625f)), _971);
            _1004 = mad(_998, _991 * (_981 * (_702 * 0.930000007152557373046875f)), _972);
        }
        else
        {
            _1002 = _970;
            _1003 = _971;
            _1004 = _972;
        }
        float _1009 = 1.0f / max(1.0f - max(max(_1004, _1003), _1002), 6.099999882280826568603515625e-05f);
        float _1016 = min(-(_1009 * _1002), 0.0f);
        float _1017 = min(-(_1009 * _1003), 0.0f);
        float _1018 = min(-(_1009 * _1004), 0.0f);
        float _1030 = clamp(-((1.0f / asfloat(cb1_m[5u].y)) * (sqrt(_452) - asfloat(cb1_m[5u].x))), 0.0f, 1.0f);
        float _1031 = mad(_1030, -2.0f, 3.0f);
        float _1032 = _1030 * _1030;
        float _1033 = _1031 * _1032;
        float _1035 = mad(-_1031, _1032, 1.0f);
        float _1059 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
        float3 _1069 = float3(mad(_1016 + ((_1035 * asfloat(cb1_m[4u].x)) - (_1016 * _1033)), _1059, -_1016), mad(_1059, ((_1035 * asfloat(cb1_m[4u].y)) - (_1033 * _1017)) + _1017, -_1017), mad(_1059, ((_1035 * asfloat(cb1_m[4u].z)) - (_1033 * _1018)) + _1018, -_1018));
#if 1
  float _1076 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1069) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1069), 65504.0f);
  float _1077 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1069) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1069), 65504.0f);
  float _1078 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1069) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1069), 65504.0f);
#endif
        float _1082 = max(max(_1077, _1076), _1078);
        float _1087 = (max(_1082, 9.9999997473787516355514526367188e-05f) - max(min(min(_1077, _1076), _1078), 9.9999997473787516355514526367188e-05f)) / max(_1082, 0.00999999977648258209228515625f);
        float _1098 = mad(sqrt(mad(_1076 - _1078, _1076, ((_1078 - _1077) * _1078) + ((_1077 - _1076) * _1077))), 1.75f, (_1078 + _1077) + _1076);
        float _1099 = _1087 - 0.4000000059604644775390625f;
        float _1104 = max(1.0f - abs(_1099 * 2.5f), 0.0f);
        float _1111 = mad(mad(clamp(mad(_1099, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1104, _1104, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1119 = ((_1098 <= 0.1599999964237213134765625f) ? _1111 : ((_1098 >= 0.4799999892711639404296875f) ? 0.0f : (_1111 * ((0.07999999821186065673828125f / (_1098 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1120 = _1119 * _1076;
        float _1121 = _1119 * _1077;
        float _1122 = _1119 * _1078;
        float _1127 = (_1121 - _1122) * 1.73205077648162841796875f;
        float _1129 = (_1120 * 2.0f) - _1121;
        float _1131 = mad(-_1119, _1078, _1129);
        float _1132 = abs(_1131);
        float _1133 = abs(_1127);
        float _1137 = min(_1132, _1133) * (1.0f / max(_1132, _1133));
        float _1138 = _1137 * _1137;
        float _1142 = mad(_1138, mad(_1138, mad(_1138, mad(_1138, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1152 = mad(_1137, _1142, (_1132 < _1133) ? mad(_1137 * _1142, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1131 < mad(_1119, _1078, -_1129)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1153 = min(_1127, _1131);
        float _1154 = max(_1127, _1131);
        float _1163 = ((_1120 == _1121) && (_1122 == _1121)) ? 0.0f : ((((_1153 < (-_1153)) && (_1154 >= (-_1154))) ? (-_1152) : _1152) * 57.295780181884765625f);
        float _1166 = (_1163 < 0.0f) ? (_1163 + 360.0f) : _1163;
        float _1176 = max(1.0f - abs(((_1166 < (-180.0f)) ? (_1166 + 360.0f) : ((_1166 > 180.0f) ? (_1166 - 360.0f) : _1166)) * 0.01481481455266475677490234375f), 0.0f);
        float _1179 = mad(_1176, -2.0f, 3.0f) * (_1176 * _1176);
        float3 _1190 = float3(clamp(_1120 + (((_1087 * (_1179 * _1179)) * mad(-_1119, _1076, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1121, 0.0f, 65504.0f), clamp(_1122, 0.0f, 65504.0f));
        float _1194 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1190), 0.0f, 65504.0f);
        float _1195 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1190), 0.0f, 65504.0f);
        float _1196 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1190), 0.0f, 65504.0f);

        float _1198 = dp3_f32(float3(_1194, _1195, _1196), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1205 = float3(mad(_1194 - _1198, 0.959999978542327880859375f, _1198), mad(_1195 - _1198, 0.959999978542327880859375f, _1198), mad(_1196 - _1198, 0.959999978542327880859375f, _1198));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[uint2(_346, _347)] = float4(CustomACES(_1205), 1.f);
    return;
  }
#endif
        float3 _1209 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1205), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1205), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1205));
        float _1210 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1209);
        float _1211 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1209);
        float _1212 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1209);
        uint _1214;
        spvTextureSize(t9, 0u, _1214);
        bool _1215 = _1214 > 0u;
        uint _1216_dummy_parameter;
        _1217 _1218 = { spvTextureSize(t9, 0u, _1216_dummy_parameter), 1u };
        float _1221 = float(_1215 ? _1218._m0.x : 0u);
        float _1224 = float(_1215 ? _1218._m0.y : 0u);
        float _1227 = float(_1215 ? _1218._m0.z : 0u);
        float _1231 = float(_1211 >= _1212);
        float _1232 = mad(_1211 - _1212, _1231, _1212);
        float _1233 = mad(_1231, _1212 - _1211, _1211);
        float _1235 = mad(_1231, -1.0f, 0.666666686534881591796875f);
        float _1241 = float(_1210 >= _1232);
        float _1242 = mad(_1210 - _1232, _1241, _1232);
        float _1243 = mad(_1233 - _1233, _1241, _1233);
        float _1245 = mad(_1232 - _1210, _1241, _1210);
        float _1247 = _1242 - min(_1245, _1243);
        float4 _1271 = t9.SampleLevel(s7, float3(abs(mad(mad(_1231, 1.0f, -1.0f) - _1235, _1241, _1235) + ((_1245 - _1243) / mad(_1247, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1221 + _1221)), (1.0f / (_1224 + _1224)) + (_1247 / (_1242 + 9.9999997473787516355514526367188e-05f)), mad(_1242 * 3.0f, 1.0f / mad(_1242, 3.0f, 1.5f), 1.0f / (_1227 + _1227))), 0.0f);
        float _1272 = _1271.x;
        float _1273 = _1271.y;
        float _1274 = _1271.z;
        float3 _1302 = float3(mad(_1274, mad(_1273, clamp(abs(mad(frac(_1272 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1272 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1273, 1.0f), _1274, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1272 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1273, 1.0f), _1274, -3.5073844628641381859779357910156e-05f));
        float3 _1306 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1302), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1302), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1302));
        float3 _1310 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1306), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1306), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1306));
        float _1319 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1310) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1330 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1310) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1340 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1310) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[uint2(_346, _347)] = float4(min(exp2(log2(mad(_1319, 18.8515625f, 0.8359375f) / mad(_1319, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1330, 18.8515625f, 0.8359375f) / mad(_1330, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1340, 18.8515625f, 0.8359375f) / mad(_1340, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

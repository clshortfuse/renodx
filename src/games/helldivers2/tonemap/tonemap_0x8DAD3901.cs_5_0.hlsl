#include "../common.hlsl"
struct _315
{
    uint2 _m0;
    uint _m1;
};

struct _1084
{
    uint3 _m0;
    uint _m1;
};

static const float _56[1] = { 0.0f };
static const float4 _243[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _306 = a.x * b.x;
    return mad(a.y, b.y, _306);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _292 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _292));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _274 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _274)));
}

void comp_main()
{
    uint _314_dummy_parameter;
    _315 _316 = { spvImageSize(u0, _314_dummy_parameter), 1u };
    uint _331 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _335 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_331, 1u, 3u);
    uint _336 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _331, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _343 = (float(_335) + 0.5f) / float(_316._m0.x);
    float _344 = (float(_336) + 0.5f) / float(_316._m0.y);
    bool _353 = cb1_m3.y == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _353) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _368 = float2(_343, _344);
    float _373 = mad(t4.SampleLevel(s3, _368, 0.0f).x, 2.0f, -1.0f);
    float _388;
    if (_373 > 0.0f)
    {
        _388 = min(sqrt(_373), t0.Load(8u).x);
    }
    else
    {
        _388 = max(_373, -t0.Load(7u).x);
    }
    bool _399 = (cb1_m10.x != 0.0f) && (cb1_m10.y != 0.0f);
    bool _403 = (cb1_m8.w != 0.0f) && (cb1_m9.x != 0.0f);
    float4 _407 = t1.SampleLevel(s0, _368, 0.0f);
    float _408 = _407.x;
    float _409 = _407.y;
    float _410 = _407.z;
    float _478;
    float _479;
    float _480;
    if (_403 || _399)
    {
        float4 _417 = t3.SampleLevel(s2, _368, 0.0f);
        float2 _426 = float2(_417.x * cb1_m2.x, _417.y * cb1_m2.y);
        float _440 = exp2(max(_399 ? clamp((sqrt(dp2_f32(_426, _426)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _403 ? clamp((abs(_388) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float4 _444 = t2.SampleLevel(s1, _368, 0.0f);
        float _445 = _444.x;
        float _446 = _444.y;
        float _447 = _444.z;
        float _453 = asfloat(cb0_m[43u].w) * 20.0f;
        float _464 = mad(t7.SampleLevel(s5, float2(mad(_343, 30.0f, sin(_453)), mad(_344, 30.0f, cos(_453))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f);
        float _468 = sqrt(max(max(_445, max(_446, _447)), 1.0000000133514319600180897396058e-10f));
        float _469 = mad(_464, _468, _445);
        float _470 = mad(_464, _468, _446);
        float _471 = mad(_464, _468, _447);
        _478 = mad(_410 - _471, _440, _471);
        _479 = mad(_409 - _470, _440, _470);
        _480 = mad(_440, _408 - _469, _469);
    }
    else
    {
        _478 = _410;
        _479 = _409;
        _480 = _408;
    }
    if (!((_316._m0.x < _335) || (_316._m0.y < _336)))
    {
        float _488 = _353 ? g0[0u] : cb1_m3.x;
        float4 _492 = t5.SampleLevel(s4, _368, 0.0f);
        float _493 = _492.x;
        float _501 = max(cb1_m4.y - dp3_f32(float3(_493, _492.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
        float _505 = mad(_480, _488, _493 / _501);
        float _506 = mad(_479, _488, _492.y / _501);
        float _507 = mad(_478, _488, _492.z / _501);
        float _511 = 1.0f / (max(_505, max(_507, _506)) + 1.0f);
        float _512 = _505 * _511;
        float _514 = _507 * _511;
        float3 _515 = float3(_512, _514, _506 * _511);
        float _516 = dp3_f32(_515, float3(0.25f, 0.25f, 0.5f));
        float _517 = dp3_f32(_515, float3(-0.25f, -0.25f, 0.5f));
        float _519 = dp2_f32(float2(_512, _514), float2(0.5f, -0.5f));
        float _520 = _516 - _517;
        float _521 = _519 + _520;
        float _522 = _516 + _517;
        float _523 = _520 - _519;
        float _525 = dp3_f32(float3(_521, _522, _523), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _533 = mad(-abs(_388), cb1_m9.y, 1.0f) * cb1_m8.x;
        float _537 = mad(_533, _521 - _525, _525);
        float _538 = mad(_533, _522 - _525, _525);
        float _539 = mad(_533, _523 - _525, _525);
        float _540 = _343 - 0.5f;
        float _541 = _344 - 0.5f;
        float _542 = _541 + _541;
        float _543 = _540 + _540;
        float _544 = abs(_543);
        float _545 = abs(_542);
        float _549 = min(_544, _545) * (1.0f / max(_544, _545));
        float _550 = _549 * _549;
        float _554 = mad(_550, mad(_550, mad(_550, mad(_550, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _563 = mad(_549, _554, (_544 < _545) ? mad(_549 * _554, -2.0f, 1.57079637050628662109375f) : 0.0f) + (((-_543) > _543) ? (-3.1415927410125732421875f) : 0.0f);
        float _564 = min(_542, _543);
        float _565 = max(_542, _543);
        float _572 = ((_564 < (-_564)) && (_565 >= (-_565))) ? (-_563) : _563;
        float4 _576 = t8.SampleLevel(s6, _368, 0.0f);
        float _577 = _576.x;
        float _578 = _576.y;
        float _579 = _576.z;
        float _580 = _576.w;
        float _585 = (_538 - _539) * 1.73205077648162841796875f;
        float _587 = mad(_537, 2.0f, -_538);
        float _588 = _587 - _539;
        float _589 = abs(_585);
        float _590 = abs(_588);
        float _594 = min(_589, _590) * (1.0f / max(_589, _590));
        float _595 = _594 * _594;
        float _599 = mad(_595, mad(_595, mad(_595, mad(_595, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _608 = mad(_594, _599, (_589 > _590) ? mad(_594 * _599, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_588 < (_539 - _587)) ? (-3.1415927410125732421875f) : 0.0f);
        float _609 = min(_585, _588);
        float _610 = max(_585, _588);
        float _619 = ((_537 == _538) && (_539 == _538)) ? 0.0f : ((((_609 < (-_609)) && (_610 >= (-_610))) ? (-_608) : _608) * 57.295780181884765625f);
        float _628 = mad(cb1_m22.x, -360.0f, (_619 < 0.0f) ? (_619 + 360.0f) : _619);
        float _638 = clamp(1.0f - (abs((_628 < (-180.0f)) ? (_628 + 360.0f) : ((_628 > 180.0f) ? (_628 - 360.0f) : _628)) / (cb1_m22.y * 180.0f)), 0.0f, 1.0f);
        float _643 = dp3_f32(float3(_537, _538, _539), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _646 = (mad(_638, -2.0f, 3.0f) * (_638 * _638)) * cb1_m22.z;
        float _658 = mad(mad(_646, _537 - _643, _643) - _537, cb1_m21.w, _537);
        float _659 = mad(mad(_646, _538 - _643, _643) - _538, cb1_m21.w, _538);
        float _660 = mad(mad(_646, _539 - _643, _643) - _539, cb1_m21.w, _539);
        float _662;
        _662 = 0.0f;
        float _663;
        uint _666;
        uint _665 = 0u;
        for (;;)
        {
            if (_665 >= 8u)
            {
                break;
            }
            uint _677 = min((_665 & 3u), 4u);
            float _697 = mad(float(_665), 0.785398185253143310546875f, -_572);
            float _698 = _697 + 1.57079637050628662109375f;
            _663 = mad(_580 * (dp4_f32(t10.Load((_665 >> 2u) + 10u), float4(_243[_677].x, _243[_677].y, _243[_677].z, _243[_677].w)) * clamp((abs((_698 > 3.1415927410125732421875f) ? (_697 - 4.7123889923095703125f) : _698) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _662, _662);
            _666 = _665 + 1u;
            _662 = _663;
            _665 = _666;
            continue;
        }
        float _709 = clamp(_662, 0.0f, 1.0f);
        float _727 = abs(t10.Load(8u).x);
        float2 _730 = float2(_540 * 1.40999996662139892578125f, _541 * 1.40999996662139892578125f);
        float _732 = sqrt(dp2_f32(_730, _730));
        float _733 = min(_732, 1.0f);
        float _734 = _733 * _733;
        float _739 = clamp(_732 - 0.5f, 0.0f, 1.0f);
        float _742 = (_733 * _734) + (mad(-_733, _734, 1.0f) * (_739 * _739));
        float _743 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _727, -1.0f);
        float _745 = _578 + _743;
        float _747 = clamp((_579 + _743) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _754 = clamp(_745 + _745, 0.0f, 1.0f);
        float _764 = mad(sin(_578 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f);
        float _771 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _776 = mad(exp2(log2(abs(_771)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _780 = _764 * (_776 * 0.02999999932944774627685546875f);
        float _781 = mad(_727, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _785 = mad(mad(-_742, _742, 1.0f), 1.0f - _781, _781);
        float _786 = min((exp2(log2(_742) * 0.699999988079071044921875f) * (mad(_754, -2.0f, 3.0f) * (_754 * _754))) + (mad(_747, -2.0f, 3.0f) * (_747 * _747)), 1.0f);
        float _796 = mad(_786, mad((_764 * _776) * 0.62000000476837158203125f, _785, mad(_658, _709, -_658)), mad(-_658, _709, _658));
        float _797 = mad(_786, mad(_785, _780, mad(_709, _659, -_659)), mad(-_709, _659, _659));
        float _798 = mad(_786, mad(_785, _780, mad(_709, _660, -_660)), mad(-_709, _660, _660));
        float _801 = mad(_578, _579 * (1.0f - _580), _580);
        float _803;
        _803 = 0.0f;
        float _804;
        uint _807;
        uint _806 = 0u;
        for (;;)
        {
            if (int(_806) >= 8)
            {
                break;
            }
            float4 _814 = t10.Load(_806);
            float _816 = _814.y;
            float _818 = _814.x - _572;
            _804 = mad(_801 * (_814.w * clamp(((_816 - 3.1415927410125732421875f) + abs((_818 > 3.1415927410125732421875f) ? (_818 - 6.283185482025146484375f) : ((_818 < (-3.1415927410125732421875f)) ? (_818 + 6.283185482025146484375f) : _818))) / max(_816 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _803, _803);
            _807 = _806 + 1u;
            _803 = _804;
            _806 = _807;
            continue;
        }
        float _837 = clamp(_803 + _803, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _841 = mad(_837, 0.310000002384185791015625f - _796, _796);
        float _842 = mad(_837, 0.014999999664723873138427734375f - _797, _797);
        float _843 = mad(_837, 0.014999999664723873138427734375f - _798, _798);
        float4 _844 = t10.Load(12u);
        float _845 = _844.x;
        float _873;
        float _874;
        float _875;
        if (_845 != 0.0f)
        {
            float _852 = clamp(_771, 0.0f, 1.0f);
            float _862 = clamp((_577 + (_845 - 1.0f)) / max(mad(_845, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _866 = clamp(_845 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _869 = mad(_866, -2.0f, 3.0f) * (_866 * _866);
            _873 = mad((_852 * (_577 * 0.790000021457672119140625f)) * _862, _869, _841);
            _874 = mad(_869, _862 * (_852 * (_577 * 0.85000002384185791015625f)), _842);
            _875 = mad(_869, _862 * (_852 * (_577 * 0.930000007152557373046875f)), _843);
        }
        else
        {
            _873 = _841;
            _874 = _842;
            _875 = _843;
        }
        float _880 = 1.0f / max(1.0f - max(max(_875, _874), _873), 6.099999882280826568603515625e-05f);
        float _887 = min(-(_880 * _873), 0.0f);
        float _888 = min(-(_880 * _874), 0.0f);
        float _889 = min(-(_880 * _875), 0.0f);
        float2 _890 = float2(_540, _541);
        float _901 = clamp(-((1.0f / cb1_m7.y) * (sqrt(dp2_f32(_890, _890)) - cb1_m7.x)), 0.0f, 1.0f);
        float _902 = mad(_901, -2.0f, 3.0f);
        float _903 = _901 * _901;
        float _904 = _902 * _903;
        float _906 = mad(-_902, _903, 1.0f);
        float _926 = cb1_m7.z * cb1_m7.w;
        float3 _936 = float3(mad(_887 + ((cb1_m5.x * _906) - (_887 * _904)), _926, -_887), mad(_926, ((cb1_m5.y * _906) - (_904 * _888)) + _888, -_888), mad(_926, ((cb1_m5.z * _906) - (_904 * _889)) + _889, -_889));
#if 1
  float _943 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _936) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _936), 65504.0f);
  float _944 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _936) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _936), 65504.0f);
  float _945 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _936) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _936), 65504.0f);
#endif
        float _949 = max(max(_944, _943), _945);
        float _954 = (max(_949, 9.9999997473787516355514526367188e-05f) - max(min(min(_944, _943), _945), 9.9999997473787516355514526367188e-05f)) / max(_949, 0.00999999977648258209228515625f);
        float _965 = mad(sqrt(mad(_943 - _945, _943, ((_945 - _944) * _945) + ((_944 - _943) * _944))), 1.75f, (_945 + _944) + _943);
        float _966 = _954 - 0.4000000059604644775390625f;
        float _971 = max(1.0f - abs(_966 * 2.5f), 0.0f);
        float _978 = mad(mad(clamp(mad(_966, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_971, _971, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _986 = ((_965 <= 0.1599999964237213134765625f) ? _978 : ((_965 >= 0.4799999892711639404296875f) ? 0.0f : (_978 * ((0.07999999821186065673828125f / (_965 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _987 = _986 * _943;
        float _988 = _986 * _944;
        float _989 = _986 * _945;
        float _994 = (_988 - _989) * 1.73205077648162841796875f;
        float _996 = (_987 * 2.0f) - _988;
        float _998 = mad(-_986, _945, _996);
        float _999 = abs(_998);
        float _1000 = abs(_994);
        float _1004 = min(_999, _1000) * (1.0f / max(_999, _1000));
        float _1005 = _1004 * _1004;
        float _1009 = mad(_1005, mad(_1005, mad(_1005, mad(_1005, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1019 = mad(_1004, _1009, (_999 < _1000) ? mad(_1004 * _1009, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_998 < mad(_986, _945, -_996)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1020 = min(_994, _998);
        float _1021 = max(_994, _998);
        float _1030 = ((_987 == _988) && (_989 == _988)) ? 0.0f : ((((_1020 < (-_1020)) && (_1021 >= (-_1021))) ? (-_1019) : _1019) * 57.295780181884765625f);
        float _1033 = (_1030 < 0.0f) ? (_1030 + 360.0f) : _1030;
        float _1043 = max(1.0f - abs(((_1033 < (-180.0f)) ? (_1033 + 360.0f) : ((_1033 > 180.0f) ? (_1033 - 360.0f) : _1033)) * 0.01481481455266475677490234375f), 0.0f);
        float _1046 = mad(_1043, -2.0f, 3.0f) * (_1043 * _1043);
        float3 _1057 = float3(clamp(_987 + (((_954 * (_1046 * _1046)) * mad(-_986, _943, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_988, 0.0f, 65504.0f), clamp(_989, 0.0f, 65504.0f));
        float _1061 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1057), 0.0f, 65504.0f);
        float _1062 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1057), 0.0f, 65504.0f);
        float _1063 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1057), 0.0f, 65504.0f);

        float _1065 = dp3_f32(float3(_1061, _1062, _1063), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1072 = float3(mad(_1061 - _1065, 0.959999978542327880859375f, _1065), mad(_1062 - _1065, 0.959999978542327880859375f, _1065), mad(_1063 - _1065, 0.959999978542327880859375f, _1065));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[uint2(_335, _336)] = float4(CustomACES(_1072), 1.f);
    return;
  }
#endif
        float3 _1076 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1072), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1072), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1072));
        float _1077 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1076);
        float _1078 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1076);
        float _1079 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1076);
        uint _1081;
        spvTextureSize(t9, 0u, _1081);
        bool _1082 = _1081 > 0u;
        uint _1083_dummy_parameter;
        _1084 _1085 = { spvTextureSize(t9, 0u, _1083_dummy_parameter), 1u };
        float _1088 = float(_1082 ? _1085._m0.x : 0u);
        float _1091 = float(_1082 ? _1085._m0.y : 0u);
        float _1094 = float(_1082 ? _1085._m0.z : 0u);
        float _1098 = float(_1078 >= _1079);
        float _1099 = mad(_1078 - _1079, _1098, _1079);
        float _1100 = mad(_1098, _1079 - _1078, _1078);
        float _1102 = mad(_1098, -1.0f, 0.666666686534881591796875f);
        float _1108 = float(_1077 >= _1099);
        float _1109 = mad(_1077 - _1099, _1108, _1099);
        float _1110 = mad(_1100 - _1100, _1108, _1100);
        float _1112 = mad(_1099 - _1077, _1108, _1077);
        float _1114 = _1109 - min(_1112, _1110);
        float4 _1138 = t9.SampleLevel(s7, float3(abs(mad(mad(_1098, 1.0f, -1.0f) - _1102, _1108, _1102) + ((_1112 - _1110) / mad(_1114, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1088 + _1088)), (1.0f / (_1091 + _1091)) + (_1114 / (_1109 + 9.9999997473787516355514526367188e-05f)), mad(_1109 * 3.0f, 1.0f / mad(_1109, 3.0f, 1.5f), 1.0f / (_1094 + _1094))), 0.0f);
        float _1139 = _1138.x;
        float _1140 = _1138.y;
        float _1141 = _1138.z;
        float3 _1169 = float3(mad(_1141, mad(_1140, clamp(abs(mad(frac(_1139 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1139 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1140, 1.0f), _1141, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1139 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1140, 1.0f), _1141, -3.5073844628641381859779357910156e-05f));
        float3 _1173 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1169), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1169), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1169));
        float3 _1177 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1173), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1173), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1173));
        float _1186 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1177) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1197 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1177) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1207 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1177) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[uint2(_335, _336)] = float4(min(exp2(log2(mad(_1186, 18.8515625f, 0.8359375f) / mad(_1186, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1197, 18.8515625f, 0.8359375f) / mad(_1197, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1207, 18.8515625f, 0.8359375f) / mad(_1207, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

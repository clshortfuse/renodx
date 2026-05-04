#include "../common.hlsl"
struct _320
{
    uint2 _m0;
    uint _m1;
};

struct _1109
{
    uint3 _m0;
    uint _m1;
};

static const float _56[1] = { 0.0f };
static const float4 _245[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _311 = a.x * b.x;
    return mad(a.y, b.y, _311);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _297 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _297));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _279 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _279)));
}

void comp_main()
{
    uint _319_dummy_parameter;
    _320 _321 = { spvImageSize(u0, _319_dummy_parameter), 1u };
    uint _336 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _340 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_336, 1u, 3u);
    uint _341 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _336, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _348 = (float(_340) + 0.5f) / float(_321._m0.x);
    float _349 = (float(_341) + 0.5f) / float(_321._m0.y);
    bool _358 = cb1_m3.y == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _358) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _373 = float2(_348, _349);
    float _378 = mad(t4.SampleLevel(s3, _373, 0.0f).x, 2.0f, -1.0f);
    float _393;
    if (_378 > 0.0f)
    {
        _393 = min(sqrt(_378), t0.Load(8u).x);
    }
    else
    {
        _393 = max(_378, -t0.Load(7u).x);
    }
    bool _404 = (cb1_m10.x != 0.0f) && (cb1_m10.y != 0.0f);
    bool _408 = (cb1_m8.w != 0.0f) && (cb1_m9.x != 0.0f);
    float4 _412 = t1.SampleLevel(s0, _373, 0.0f);
    float _413 = _412.x;
    float _414 = _412.y;
    float _415 = _412.z;
    float _483;
    float _484;
    float _485;
    if (_408 || _404)
    {
        float4 _422 = t3.SampleLevel(s2, _373, 0.0f);
        float2 _431 = float2(_422.x * cb1_m2.x, _422.y * cb1_m2.y);
        float _445 = exp2(max(_404 ? clamp((sqrt(dp2_f32(_431, _431)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _408 ? clamp((abs(_393) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float4 _449 = t2.SampleLevel(s1, _373, 0.0f);
        float _450 = _449.x;
        float _451 = _449.y;
        float _452 = _449.z;
        float _458 = asfloat(cb0_m[43u].w) * 20.0f;
        float _469 = mad(t7.SampleLevel(s5, float2(mad(_348, 30.0f, sin(_458)), mad(_349, 30.0f, cos(_458))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f);
        float _473 = sqrt(max(max(_450, max(_451, _452)), 1.0000000133514319600180897396058e-10f));
        float _474 = mad(_469, _473, _450);
        float _475 = mad(_469, _473, _451);
        float _476 = mad(_469, _473, _452);
        _483 = mad(_445, _415 - _476, _476);
        _484 = mad(_445, _414 - _475, _475);
        _485 = mad(_445, _413 - _474, _474);
    }
    else
    {
        _483 = _415;
        _484 = _414;
        _485 = _413;
    }
    if (!((_321._m0.x < _340) || (_321._m0.y < _341)))
    {
        float _493 = _358 ? g0[0u] : cb1_m3.x;
        float4 _497 = t5.SampleLevel(s4, _373, 0.0f);
        float _498 = _497.x;
        float _506 = max(cb1_m4.y - dp3_f32(float3(_498, _497.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
        float _510 = mad(_485, _493, _498 / _506);
        float _511 = mad(_484, _493, _497.y / _506);
        float _512 = mad(_483, _493, _497.z / _506);
        float _516 = 1.0f / (max(_510, max(_512, _511)) + 1.0f);
        float _517 = _510 * _516;
        float _519 = _512 * _516;
        float3 _520 = float3(_517, _519, _511 * _516);
        float _521 = dp3_f32(_520, float3(0.25f, 0.25f, 0.5f));
        float _522 = dp3_f32(_520, float3(-0.25f, -0.25f, 0.5f));
        float _524 = dp2_f32(float2(_517, _519), float2(0.5f, -0.5f));
        float _525 = _521 - _522;
        float _526 = _524 + _525;
        float _527 = _521 + _522;
        float _528 = _525 - _524;
        float _530 = dp3_f32(float3(_526, _527, _528), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _538 = mad(-abs(_393), cb1_m9.y, 1.0f) * cb1_m8.x;
        float _542 = mad(_538, _526 - _530, _530);
        float _543 = mad(_538, _527 - _530, _530);
        float _544 = mad(_538, _528 - _530, _530);
        float _545 = _348 - 0.5f;
        float _546 = _349 - 0.5f;
        float _547 = _546 + _546;
        float _548 = _545 + _545;
        float _549 = abs(_548);
        float _550 = abs(_547);
        float _554 = min(_549, _550) * (1.0f / max(_549, _550));
        float _555 = _554 * _554;
        float _559 = mad(_555, mad(_555, mad(_555, mad(_555, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _568 = mad(_554, _559, (_549 < _550) ? mad(_554 * _559, -2.0f, 1.57079637050628662109375f) : 0.0f) + (((-_548) > _548) ? (-3.1415927410125732421875f) : 0.0f);
        float _569 = min(_547, _548);
        float _570 = max(_547, _548);
        float _577 = ((_569 < (-_569)) && (_570 >= (-_570))) ? (-_568) : _568;
        float4 _581 = t8.SampleLevel(s6, _373, 0.0f);
        float _582 = _581.x;
        float _583 = _581.y;
        float _584 = _581.z;
        float _585 = _581.w;
        float _590 = (_543 - _544) * 1.73205077648162841796875f;
        float _592 = mad(_542, 2.0f, -_543);
        float _593 = _592 - _544;
        float _594 = abs(_593);
        float _595 = abs(_590);
        float _599 = min(_594, _595) * (1.0f / max(_594, _595));
        float _600 = _599 * _599;
        float _604 = mad(_600, mad(_600, mad(_600, mad(_600, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _613 = mad(_599, _604, (_594 < _595) ? mad(_599 * _604, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_593 < (_544 - _592)) ? (-3.1415927410125732421875f) : 0.0f);
        float _614 = min(_590, _593);
        float _615 = max(_590, _593);
        float _624 = ((_542 == _543) && (_544 == _543)) ? 0.0f : ((((_614 < (-_614)) && (_615 >= (-_615))) ? (-_613) : _613) * 57.295780181884765625f);
        float _633 = mad(cb1_m22.y, -360.0f, (_624 < 0.0f) ? (_624 + 360.0f) : _624);
        float _643 = clamp(1.0f - (abs((_633 < (-180.0f)) ? (_633 + 360.0f) : ((_633 > 180.0f) ? (_633 - 360.0f) : _633)) / (cb1_m22.z * 180.0f)), 0.0f, 1.0f);
        float _648 = dp3_f32(float3(_542, _543, _544), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _651 = (mad(_643, -2.0f, 3.0f) * (_643 * _643)) * cb1_m22.w;
        float _663 = mad(mad(_651, _542 - _648, _648) - _542, cb1_m21.w, _542);
        float _664 = mad(cb1_m21.w, mad(_651, _543 - _648, _648) - _543, _543);
        float _665 = mad(cb1_m21.w, mad(_651, _544 - _648, _648) - _544, _544);
        float _667;
        _667 = 0.0f;
        float _668;
        uint _671;
        uint _670 = 0u;
        for (;;)
        {
            if (_670 >= 8u)
            {
                break;
            }
            uint _682 = min((_670 & 3u), 4u);
            float _702 = mad(float(_670), 0.785398185253143310546875f, -_577);
            float _703 = _702 + 1.57079637050628662109375f;
            _668 = mad(_585 * (dp4_f32(t10.Load((_670 >> 2u) + 10u), float4(_245[_682].x, _245[_682].y, _245[_682].z, _245[_682].w)) * clamp((abs((_703 > 3.1415927410125732421875f) ? (_702 - 4.7123889923095703125f) : _703) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _667, _667);
            _671 = _670 + 1u;
            _667 = _668;
            _670 = _671;
            continue;
        }
        float _714 = clamp(_667, 0.0f, 1.0f);
        float _727 = asfloat(cb0_m[43u].w);
        float _733 = abs(t10.Load(8u).x);
        float2 _736 = float2(_545 * 1.40999996662139892578125f, _546 * 1.40999996662139892578125f);
        float _738 = sqrt(dp2_f32(_736, _736));
        float _739 = min(_738, 1.0f);
        float _740 = _739 * _739;
        float _745 = clamp(_738 - 0.5f, 0.0f, 1.0f);
        float _748 = (_739 * _740) + (mad(-_739, _740, 1.0f) * (_745 * _745));
        float _749 = mad(mad(mad(sin(_727 * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _733, -1.0f);
        float _751 = _583 + _749;
        float _753 = clamp((_584 + _749) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _759 = clamp(_751 + _751, 0.0f, 1.0f);
        float _770 = mad(sin(_583 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f);
        float _777 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _782 = mad(exp2(log2(abs(_777)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _786 = _770 * (_782 * 0.02999999932944774627685546875f);
        float _787 = mad(_733, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _791 = mad(mad(-_748, _748, 1.0f), 1.0f - _787, _787);
        float _792 = min((exp2(log2(_748) * 0.699999988079071044921875f) * (mad(_759, -2.0f, 3.0f) * (_759 * _759))) + ((_753 * _753) * mad(_753, -2.0f, 3.0f)), 1.0f);
        float _802 = mad(_792, mad((_770 * _782) * 0.62000000476837158203125f, _791, mad(_663, _714, -_663)), mad(-_663, _714, _663));
        float _803 = mad(_792, mad(_791, _786, mad(_714, _664, -_664)), mad(-_714, _664, _664));
        float _804 = mad(_792, mad(_791, _786, mad(_714, _665, -_665)), mad(-_714, _665, _665));
        float _807 = mad(_583, _584 * (1.0f - _585), _585);
        float _809;
        _809 = 0.0f;
        float _810;
        uint _813;
        uint _812 = 0u;
        for (;;)
        {
            if (int(_812) >= 8)
            {
                break;
            }
            float4 _820 = t10.Load(_812);
            float _822 = _820.y;
            float _824 = _820.x - _577;
            _810 = mad(_807 * (_820.w * clamp((abs((_824 > 3.1415927410125732421875f) ? (_824 - 6.283185482025146484375f) : ((_824 < (-3.1415927410125732421875f)) ? (_824 + 6.283185482025146484375f) : _824)) + (_822 - 3.1415927410125732421875f)) / max(_822 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _809, _809);
            _813 = _812 + 1u;
            _809 = _810;
            _812 = _813;
            continue;
        }
        float _843 = clamp(_809 + _809, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _847 = mad(_843, 0.310000002384185791015625f - _802, _802);
        float _848 = mad(_843, 0.014999999664723873138427734375f - _803, _803);
        float _849 = mad(_843, 0.014999999664723873138427734375f - _804, _804);
        float4 _850 = t10.Load(12u);
        float _851 = _850.x;
        float _879;
        float _880;
        float _881;
        if (_851 != 0.0f)
        {
            float _858 = clamp(_777, 0.0f, 1.0f);
            float _868 = clamp((_582 + (_851 - 1.0f)) / max(mad(_851, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _872 = clamp(_851 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _875 = mad(_872, -2.0f, 3.0f) * (_872 * _872);
            _879 = mad(_875, _868 * (_858 * (_582 * 0.930000007152557373046875f)), _849);
            _880 = mad(_875, _868 * (_858 * (_582 * 0.85000002384185791015625f)), _848);
            _881 = mad((_858 * (_582 * 0.790000021457672119140625f)) * _868, _875, _847);
        }
        else
        {
            _879 = _849;
            _880 = _848;
            _881 = _847;
        }
        bool _884 = cb1_m22.x > 0.0f;
        bool _888 = frac((_349 * 420.0f) + (_727 * 0.20000000298023223876953125f)) >= 0.5f;
        float _889 = _888 ? 0.300000011920928955078125f : 0.0f;
        float _890 = _889 * cb1_m22.x;
        float _898 = _884 ? mad(_890, 0.0f - _881, _881) : _881;
        float _899 = _884 ? mad(_890, (_888 ? 0.100000001490116119384765625f : 0.0f) - _880, _880) : _880;
        float _900 = _884 ? mad(_890, _889 - _879, _879) : _879;
        float _905 = 1.0f / max(1.0f - max(max(_900, _899), _898), 6.099999882280826568603515625e-05f);
        float _912 = min(-(_905 * _898), 0.0f);
        float _913 = min(-(_905 * _899), 0.0f);
        float _914 = min(-(_905 * _900), 0.0f);
        float2 _915 = float2(_545, _546);
        float _926 = clamp(-((sqrt(dp2_f32(_915, _915)) - cb1_m7.x) * (1.0f / cb1_m7.y)), 0.0f, 1.0f);
        float _927 = mad(_926, -2.0f, 3.0f);
        float _928 = _926 * _926;
        float _929 = _927 * _928;
        float _931 = mad(-_927, _928, 1.0f);
        float _951 = cb1_m7.z * cb1_m7.w;
        float3 _961 = float3(mad(_912 + ((cb1_m5.x * _931) - (_912 * _929)), _951, -_912), mad(_951, ((cb1_m5.y * _931) - (_929 * _913)) + _913, -_913), mad(_951, ((cb1_m5.z * _931) - (_929 * _914)) + _914, -_914));
#if 1
  float _968 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _961) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _961), 65504.0f);
  float _969 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _961) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _961), 65504.0f);
  float _970 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _961) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _961), 65504.0f);
#endif
        float _974 = max(max(_969, _968), _970);
        float _979 = (max(_974, 9.9999997473787516355514526367188e-05f) - max(min(min(_969, _968), _970), 9.9999997473787516355514526367188e-05f)) / max(_974, 0.00999999977648258209228515625f);
        float _990 = mad(sqrt(mad(_968 - _970, _968, ((_970 - _969) * _970) + ((_969 - _968) * _969))), 1.75f, (_970 + _969) + _968);
        float _991 = _979 - 0.4000000059604644775390625f;
        float _996 = max(1.0f - abs(_991 * 2.5f), 0.0f);
        float _1003 = mad(mad(clamp(mad(_991, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_996, _996, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1011 = ((_990 <= 0.1599999964237213134765625f) ? _1003 : ((_990 >= 0.4799999892711639404296875f) ? 0.0f : (_1003 * ((0.07999999821186065673828125f / (_990 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1012 = _1011 * _968;
        float _1013 = _1011 * _969;
        float _1014 = _1011 * _970;
        float _1019 = (_1013 - _1014) * 1.73205077648162841796875f;
        float _1021 = (_1012 * 2.0f) - _1013;
        float _1023 = mad(-_1011, _970, _1021);
        float _1024 = abs(_1023);
        float _1025 = abs(_1019);
        float _1029 = min(_1024, _1025) * (1.0f / max(_1024, _1025));
        float _1030 = _1029 * _1029;
        float _1034 = mad(_1030, mad(_1030, mad(_1030, mad(_1030, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1044 = mad(_1029, _1034, (_1024 < _1025) ? mad(_1029 * _1034, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1023 < mad(_1011, _970, -_1021)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1045 = min(_1019, _1023);
        float _1046 = max(_1019, _1023);
        float _1055 = ((_1012 == _1013) && (_1014 == _1013)) ? 0.0f : ((((_1045 < (-_1045)) && (_1046 >= (-_1046))) ? (-_1044) : _1044) * 57.295780181884765625f);
        float _1058 = (_1055 < 0.0f) ? (_1055 + 360.0f) : _1055;
        float _1068 = max(1.0f - abs(((_1058 < (-180.0f)) ? (_1058 + 360.0f) : ((_1058 > 180.0f) ? (_1058 - 360.0f) : _1058)) * 0.01481481455266475677490234375f), 0.0f);
        float _1071 = mad(_1068, -2.0f, 3.0f) * (_1068 * _1068);
        float3 _1082 = float3(clamp(_1012 + (((_979 * (_1071 * _1071)) * mad(-_1011, _968, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1013, 0.0f, 65504.0f), clamp(_1014, 0.0f, 65504.0f));
        float _1086 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1082), 0.0f, 65504.0f);
        float _1087 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1082), 0.0f, 65504.0f);
        float _1088 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1082), 0.0f, 65504.0f);

        float _1090 = dp3_f32(float3(_1086, _1087, _1088), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1097 = float3(mad(_1086 - _1090, 0.959999978542327880859375f, _1090), mad(_1087 - _1090, 0.959999978542327880859375f, _1090), mad(_1088 - _1090, 0.959999978542327880859375f, _1090));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[uint2(_340, _341)] = float4(CustomACES(_1097), 1.f);
    return;
  }
#endif
        float3 _1101 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1097), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1097), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1097));
        float _1102 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1101);
        float _1103 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1101);
        float _1104 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1101);
        uint _1106;
        spvTextureSize(t9, 0u, _1106);
        bool _1107 = _1106 > 0u;
        uint _1108_dummy_parameter;
        _1109 _1110 = { spvTextureSize(t9, 0u, _1108_dummy_parameter), 1u };
        float _1113 = float(_1107 ? _1110._m0.x : 0u);
        float _1116 = float(_1107 ? _1110._m0.y : 0u);
        float _1119 = float(_1107 ? _1110._m0.z : 0u);
        float _1123 = float(_1103 >= _1104);
        float _1124 = mad(_1103 - _1104, _1123, _1104);
        float _1125 = mad(_1123, _1104 - _1103, _1103);
        float _1127 = mad(_1123, -1.0f, 0.666666686534881591796875f);
        float _1133 = float(_1102 >= _1124);
        float _1134 = mad(_1102 - _1124, _1133, _1124);
        float _1135 = mad(_1125 - _1125, _1133, _1125);
        float _1137 = mad(_1124 - _1102, _1133, _1102);
        float _1139 = _1134 - min(_1137, _1135);
        float4 _1163 = t9.SampleLevel(s7, float3(abs(mad(mad(_1123, 1.0f, -1.0f) - _1127, _1133, _1127) + ((_1137 - _1135) / mad(_1139, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1113 + _1113)), (1.0f / (_1116 + _1116)) + (_1139 / (_1134 + 9.9999997473787516355514526367188e-05f)), mad(_1134 * 3.0f, 1.0f / mad(_1134, 3.0f, 1.5f), 1.0f / (_1119 + _1119))), 0.0f);
        float _1164 = _1163.x;
        float _1165 = _1163.y;
        float _1166 = _1163.z;
        float3 _1194 = float3(mad(_1166, mad(_1165, clamp(abs(mad(frac(_1164 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1164 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1165, 1.0f), _1166, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1164 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1165, 1.0f), _1166, -3.5073844628641381859779357910156e-05f));
        float3 _1198 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1194), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1194), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1194));
        float3 _1202 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1198), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1198), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1198));
        float _1211 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1202) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1222 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1202) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1232 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1202) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[uint2(_340, _341)] = float4(min(exp2(log2(mad(_1211, 18.8515625f, 0.8359375f) / mad(_1211, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1222, 18.8515625f, 0.8359375f) / mad(_1222, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1232, 18.8515625f, 0.8359375f) / mad(_1232, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

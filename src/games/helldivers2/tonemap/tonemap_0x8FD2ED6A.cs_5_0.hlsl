#include "../common.hlsl"
struct _316
{
    uint2 _m0;
    uint _m1;
};

struct _1087
{
    uint3 _m0;
    uint _m1;
};

static const float _57[1] = { 0.0f };
static const float4 _244[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _307 = a.x * b.x;
    return mad(a.y, b.y, _307);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _293 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _293));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _275 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _275)));
}

void comp_main()
{
    uint _315_dummy_parameter;
    _316 _317 = { spvImageSize(u0, _315_dummy_parameter), 1u };
    uint _332 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _336 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_332, 1u, 3u);
    uint _337 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _332, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _344 = (float(_336) + 0.5f) / float(_317._m0.x);
    float _345 = (float(_337) + 0.5f) / float(_317._m0.y);
    bool _354 = cb1_m3.y == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _354) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _369 = float2(_344, _345);
    float _374 = mad(t4.SampleLevel(s3, _369, 0.0f).x, 2.0f, -1.0f);
    float _389;
    if (_374 > 0.0f)
    {
        _389 = min(sqrt(_374), t0.Load(8u).x);
    }
    else
    {
        _389 = max(_374, -t0.Load(7u).x);
    }
    bool _400 = (cb1_m10.x != 0.0f) && (cb1_m10.y != 0.0f);
    bool _404 = (cb1_m8.w != 0.0f) && (cb1_m9.x != 0.0f);
    float4 _408 = t1.SampleLevel(s0, _369, 0.0f);
    float _409 = _408.x;
    float _410 = _408.y;
    float _411 = _408.z;
    float _479;
    float _480;
    float _481;
    if (_404 || _400)
    {
        float4 _418 = t3.SampleLevel(s2, _369, 0.0f);
        float2 _427 = float2(_418.x * cb1_m2.x, _418.y * cb1_m2.y);
        float _441 = exp2(max(_400 ? clamp((sqrt(dp2_f32(_427, _427)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _404 ? clamp((abs(_389) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float4 _445 = t2.SampleLevel(s1, _369, 0.0f);
        float _446 = _445.x;
        float _447 = _445.y;
        float _448 = _445.z;
        float _454 = asfloat(cb0_m[43u].w) * 20.0f;
        float _465 = mad(t7.SampleLevel(s5, float2(mad(_344, 30.0f, sin(_454)), mad(_345, 30.0f, cos(_454))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f);
        float _469 = sqrt(max(max(_446, max(_447, _448)), 1.0000000133514319600180897396058e-10f));
        float _470 = mad(_465, _469, _446);
        float _471 = mad(_465, _469, _447);
        float _472 = mad(_465, _469, _448);
        _479 = mad(_411 - _472, _441, _472);
        _480 = mad(_441, _410 - _471, _471);
        _481 = mad(_441, _409 - _470, _470);
    }
    else
    {
        _479 = _411;
        _480 = _410;
        _481 = _409;
    }
    float _486 = _354 ? g0[0u] : cb1_m3.x;
    float4 _490 = t5.SampleLevel(s4, _369, 0.0f);
    float _491 = _490.x;
    float _499 = max(cb1_m4.y - dp3_f32(float3(_491, _490.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _503 = mad(_481, _486, _491 / _499);
    float _504 = mad(_480, _486, _490.y / _499);
    float _505 = mad(_479, _486, _490.z / _499);
    float _509 = 1.0f / (max(_503, max(_505, _504)) + 1.0f);
    float _510 = _503 * _509;
    float _512 = _505 * _509;
    float3 _513 = float3(_510, _512, _504 * _509);
    float _514 = dp3_f32(_513, float3(0.25f, 0.25f, 0.5f));
    float _515 = dp3_f32(_513, float3(-0.25f, -0.25f, 0.5f));
    float _517 = dp2_f32(float2(_510, _512), float2(0.5f, -0.5f));
    uint2 _519 = uint2(_336, _337);
    u1[_519] = float4(_514, _517, _515, _514);
    if (!((_317._m0.x < _336) || (_317._m0.y < _337)))
    {
        float _524 = _514 - _515;
        float _525 = _517 + _524;
        float _526 = _514 + _515;
        float _527 = _524 - _517;
        float _529 = dp3_f32(float3(_525, _526, _527), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _537 = mad(-abs(_389), cb1_m9.y, 1.0f) * cb1_m8.x;
        float _541 = mad(_537, _525 - _529, _529);
        float _542 = mad(_537, _526 - _529, _529);
        float _543 = mad(_537, _527 - _529, _529);
        float _544 = _344 - 0.5f;
        float _545 = _345 - 0.5f;
        float _546 = _545 + _545;
        float _547 = _544 + _544;
        float _548 = abs(_547);
        float _549 = abs(_546);
        float _553 = min(_548, _549) * (1.0f / max(_548, _549));
        float _554 = _553 * _553;
        float _558 = mad(_554, mad(_554, mad(_554, mad(_554, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _567 = mad(_553, _558, (_548 < _549) ? mad(_553 * _558, -2.0f, 1.57079637050628662109375f) : 0.0f) + (((-_547) > _547) ? (-3.1415927410125732421875f) : 0.0f);
        float _568 = min(_546, _547);
        float _569 = max(_546, _547);
        float _576 = ((_568 < (-_568)) && (_569 >= (-_569))) ? (-_567) : _567;
        float4 _580 = t8.SampleLevel(s6, _369, 0.0f);
        float _581 = _580.x;
        float _582 = _580.y;
        float _583 = _580.z;
        float _584 = _580.w;
        float _589 = (_542 - _543) * 1.73205077648162841796875f;
        float _591 = mad(_541, 2.0f, -_542);
        float _592 = _591 - _543;
        float _593 = abs(_589);
        float _594 = abs(_592);
        float _598 = min(_593, _594) * (1.0f / max(_593, _594));
        float _599 = _598 * _598;
        float _603 = mad(_599, mad(_599, mad(_599, mad(_599, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _612 = mad(_598, _603, (_593 > _594) ? mad(_598 * _603, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_592 < (_543 - _591)) ? (-3.1415927410125732421875f) : 0.0f);
        float _613 = min(_589, _592);
        float _614 = max(_589, _592);
        float _623 = ((_541 == _542) && (_543 == _542)) ? 0.0f : ((((_613 < (-_613)) && (_614 >= (-_614))) ? (-_612) : _612) * 57.295780181884765625f);
        float _632 = mad(cb1_m22.x, -360.0f, (_623 < 0.0f) ? (_623 + 360.0f) : _623);
        float _642 = clamp(1.0f - (abs((_632 < (-180.0f)) ? (_632 + 360.0f) : ((_632 > 180.0f) ? (_632 - 360.0f) : _632)) / (cb1_m22.y * 180.0f)), 0.0f, 1.0f);
        float _647 = dp3_f32(float3(_541, _542, _543), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _650 = (mad(_642, -2.0f, 3.0f) * (_642 * _642)) * cb1_m22.z;
        float _662 = mad(mad(_650, _541 - _647, _647) - _541, cb1_m21.w, _541);
        float _663 = mad(mad(_650, _542 - _647, _647) - _542, cb1_m21.w, _542);
        float _664 = mad(mad(_650, _543 - _647, _647) - _543, cb1_m21.w, _543);
        float _666;
        _666 = 0.0f;
        float _667;
        uint _670;
        uint _669 = 0u;
        for (;;)
        {
            if (_669 >= 8u)
            {
                break;
            }
            uint _681 = min((_669 & 3u), 4u);
            float _701 = mad(float(_669), 0.785398185253143310546875f, -_576);
            float _702 = _701 + 1.57079637050628662109375f;
            _667 = mad(_584 * (dp4_f32(t10.Load((_669 >> 2u) + 10u), float4(_244[_681].x, _244[_681].y, _244[_681].z, _244[_681].w)) * clamp((abs((_702 > 3.1415927410125732421875f) ? (_701 - 4.7123889923095703125f) : _702) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _666, _666);
            _670 = _669 + 1u;
            _666 = _667;
            _669 = _670;
            continue;
        }
        float _713 = clamp(_666, 0.0f, 1.0f);
        float _731 = abs(t10.Load(8u).x);
        float2 _734 = float2(_544 * 1.40999996662139892578125f, _545 * 1.40999996662139892578125f);
        float _736 = sqrt(dp2_f32(_734, _734));
        float _737 = min(_736, 1.0f);
        float _738 = _737 * _737;
        float _743 = clamp(_736 - 0.5f, 0.0f, 1.0f);
        float _746 = (_737 * _738) + (mad(-_737, _738, 1.0f) * (_743 * _743));
        float _747 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _731, -1.0f);
        float _749 = _582 + _747;
        float _751 = clamp((_583 + _747) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _758 = clamp(_749 + _749, 0.0f, 1.0f);
        float _775 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _781 = mad(sin(_582 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_775)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _783 = _781 * 0.02999999932944774627685546875f;
        float _784 = mad(_731, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _788 = mad(mad(-_746, _746, 1.0f), 1.0f - _784, _784);
        float _789 = min((exp2(log2(_746) * 0.699999988079071044921875f) * (mad(_758, -2.0f, 3.0f) * (_758 * _758))) + (mad(_751, -2.0f, 3.0f) * (_751 * _751)), 1.0f);
        float _799 = mad(_789, mad(_788, _781 * 0.62000000476837158203125f, mad(_662, _713, -_662)), mad(-_662, _713, _662));
        float _800 = mad(_789, mad(_788, _783, mad(_713, _663, -_663)), mad(-_713, _663, _663));
        float _801 = mad(_789, mad(_788, _783, mad(_713, _664, -_664)), mad(-_713, _664, _664));
        float _804 = mad(_582, _583 * (1.0f - _584), _584);
        float _806;
        _806 = 0.0f;
        float _807;
        uint _810;
        uint _809 = 0u;
        for (;;)
        {
            if (int(_809) >= 8)
            {
                break;
            }
            float4 _817 = t10.Load(_809);
            float _819 = _817.y;
            float _821 = _817.x - _576;
            _807 = mad(_804 * (_817.w * clamp(((_819 - 3.1415927410125732421875f) + abs((_821 > 3.1415927410125732421875f) ? (_821 - 6.283185482025146484375f) : ((_821 < (-3.1415927410125732421875f)) ? (_821 + 6.283185482025146484375f) : _821))) / max(_819 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _806, _806);
            _810 = _809 + 1u;
            _806 = _807;
            _809 = _810;
            continue;
        }
        float _840 = clamp(_806 + _806, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _844 = mad(_840, 0.310000002384185791015625f - _799, _799);
        float _845 = mad(_840, 0.014999999664723873138427734375f - _800, _800);
        float _846 = mad(_840, 0.014999999664723873138427734375f - _801, _801);
        float4 _847 = t10.Load(12u);
        float _848 = _847.x;
        float _876;
        float _877;
        float _878;
        if (_848 != 0.0f)
        {
            float _855 = clamp(_775, 0.0f, 1.0f);
            float _865 = clamp((_581 + (_848 - 1.0f)) / max(mad(_848, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _869 = clamp(_848 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _872 = mad(_869, -2.0f, 3.0f) * (_869 * _869);
            _876 = mad((_855 * (_581 * 0.790000021457672119140625f)) * _865, _872, _844);
            _877 = mad(_872, _865 * (_855 * (_581 * 0.85000002384185791015625f)), _845);
            _878 = mad(_872, _865 * (_855 * (_581 * 0.930000007152557373046875f)), _846);
        }
        else
        {
            _876 = _844;
            _877 = _845;
            _878 = _846;
        }
        float _883 = 1.0f / max(1.0f - max(max(_878, _877), _876), 6.099999882280826568603515625e-05f);
        float _890 = min(-(_883 * _876), 0.0f);
        float _891 = min(-(_883 * _877), 0.0f);
        float _892 = min(-(_883 * _878), 0.0f);
        float2 _893 = float2(_544, _545);
        float _904 = clamp(-((1.0f / cb1_m7.y) * (sqrt(dp2_f32(_893, _893)) - cb1_m7.x)), 0.0f, 1.0f);
        float _905 = mad(_904, -2.0f, 3.0f);
        float _906 = _904 * _904;
        float _907 = _905 * _906;
        float _909 = mad(-_905, _906, 1.0f);
        float _929 = cb1_m7.w * cb1_m7.z;
        float3 _939 = float3(mad(_890 + ((cb1_m5.x * _909) - (_890 * _907)), _929, -_890), mad(_929, ((cb1_m5.y * _909) - (_907 * _891)) + _891, -_891), mad(_929, ((_909 * cb1_m5.z) - (_907 * _892)) + _892, -_892));
#if 1
  float _946 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _939) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _939), 65504.0f);
  float _947 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _939) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _939), 65504.0f);
  float _948 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _939) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _939), 65504.0f);
#endif
        float _952 = max(max(_947, _946), _948);
        float _957 = (max(_952, 9.9999997473787516355514526367188e-05f) - max(min(min(_947, _946), _948), 9.9999997473787516355514526367188e-05f)) / max(_952, 0.00999999977648258209228515625f);
        float _968 = mad(sqrt(mad(_946 - _948, _946, ((_948 - _947) * _948) + ((_947 - _946) * _947))), 1.75f, (_948 + _947) + _946);
        float _969 = _957 - 0.4000000059604644775390625f;
        float _974 = max(1.0f - abs(_969 * 2.5f), 0.0f);
        float _981 = mad(mad(clamp(mad(_969, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_974, _974, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _989 = ((_968 <= 0.1599999964237213134765625f) ? _981 : ((_968 >= 0.4799999892711639404296875f) ? 0.0f : (_981 * ((0.07999999821186065673828125f / (_968 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _990 = _989 * _946;
        float _991 = _989 * _947;
        float _992 = _989 * _948;
        float _997 = (_991 - _992) * 1.73205077648162841796875f;
        float _999 = (_990 * 2.0f) - _991;
        float _1001 = mad(-_989, _948, _999);
        float _1002 = abs(_1001);
        float _1003 = abs(_997);
        float _1007 = min(_1002, _1003) * (1.0f / max(_1002, _1003));
        float _1008 = _1007 * _1007;
        float _1012 = mad(_1008, mad(_1008, mad(_1008, mad(_1008, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1022 = mad(_1007, _1012, (_1002 < _1003) ? mad(_1007 * _1012, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1001 < mad(_989, _948, -_999)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1023 = min(_997, _1001);
        float _1024 = max(_997, _1001);
        float _1033 = ((_990 == _991) && (_992 == _991)) ? 0.0f : ((((_1023 < (-_1023)) && (_1024 >= (-_1024))) ? (-_1022) : _1022) * 57.295780181884765625f);
        float _1036 = (_1033 < 0.0f) ? (_1033 + 360.0f) : _1033;
        float _1046 = max(1.0f - abs(((_1036 < (-180.0f)) ? (_1036 + 360.0f) : ((_1036 > 180.0f) ? (_1036 - 360.0f) : _1036)) * 0.01481481455266475677490234375f), 0.0f);
        float _1049 = mad(_1046, -2.0f, 3.0f) * (_1046 * _1046);
        float3 _1060 = float3(clamp(_990 + (((_957 * (_1049 * _1049)) * mad(-_989, _946, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_991, 0.0f, 65504.0f), clamp(_992, 0.0f, 65504.0f));
        float _1064 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1060), 0.0f, 65504.0f);
        float _1065 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1060), 0.0f, 65504.0f);
        float _1066 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1060), 0.0f, 65504.0f);

        float _1068 = dp3_f32(float3(_1064, _1065, _1066), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1075 = float3(mad(_1064 - _1068, 0.959999978542327880859375f, _1068), mad(_1065 - _1068, 0.959999978542327880859375f, _1068), mad(_1066 - _1068, 0.959999978542327880859375f, _1068));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_519] = float4(CustomACES(_1075), 1.f);
    return;
  }
#endif
        float3 _1079 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1075), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1075), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1075));
        float _1080 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1079);
        float _1081 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1079);
        float _1082 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1079);
        uint _1084;
        spvTextureSize(t9, 0u, _1084);
        bool _1085 = _1084 > 0u;
        uint _1086_dummy_parameter;
        _1087 _1088 = { spvTextureSize(t9, 0u, _1086_dummy_parameter), 1u };
        float _1091 = float(_1085 ? _1088._m0.x : 0u);
        float _1094 = float(_1085 ? _1088._m0.y : 0u);
        float _1097 = float(_1085 ? _1088._m0.z : 0u);
        float _1101 = float(_1081 >= _1082);
        float _1102 = mad(_1081 - _1082, _1101, _1082);
        float _1103 = mad(_1101, _1082 - _1081, _1081);
        float _1105 = mad(_1101, -1.0f, 0.666666686534881591796875f);
        float _1111 = float(_1080 >= _1102);
        float _1112 = mad(_1080 - _1102, _1111, _1102);
        float _1113 = mad(_1103 - _1103, _1111, _1103);
        float _1115 = mad(_1102 - _1080, _1111, _1080);
        float _1117 = _1112 - min(_1115, _1113);
        float4 _1141 = t9.SampleLevel(s7, float3(abs(mad(mad(_1101, 1.0f, -1.0f) - _1105, _1111, _1105) + ((_1115 - _1113) / mad(_1117, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1091 + _1091)), (1.0f / (_1094 + _1094)) + (_1117 / (_1112 + 9.9999997473787516355514526367188e-05f)), mad(_1112 * 3.0f, 1.0f / mad(_1112, 3.0f, 1.5f), 1.0f / (_1097 + _1097))), 0.0f);
        float _1142 = _1141.x;
        float _1143 = _1141.y;
        float _1144 = _1141.z;
        float3 _1172 = float3(mad(_1144, mad(_1143, clamp(abs(mad(frac(_1142 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1142 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1143, 1.0f), _1144, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1142 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1143, 1.0f), _1144, -3.5073844628641381859779357910156e-05f));
        float3 _1176 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1172), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1172), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1172));
        float3 _1180 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1176), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1176), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1176));
        float _1189 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1180) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1200 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1180) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1210 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1180) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_519] = float4(min(exp2(log2(mad(_1189, 18.8515625f, 0.8359375f) / mad(_1189, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1200, 18.8515625f, 0.8359375f) / mad(_1200, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1210, 18.8515625f, 0.8359375f) / mad(_1210, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

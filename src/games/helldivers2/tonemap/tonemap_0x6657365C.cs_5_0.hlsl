#include "../common.hlsl"
struct _391
{
    uint2 _m0;
    uint _m1;
};

struct _1529
{
    uint3 _m0;
    uint _m1;
};

static const float _55[1] = { 0.0f };
static const float4 _327[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _382 = a.x * b.x;
    return mad(a.y, b.y, _382);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _368 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _368));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _350 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _350)));
}

void comp_main()
{
    uint _390_dummy_parameter;
    _391 _392 = { spvImageSize(u0, _390_dummy_parameter), 1u };
    uint _407 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _411 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_407, 1u, 3u);
    uint _412 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _407, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _419 = (float(_411) + 0.5f) / float(_392._m0.x);
    float _420 = (float(_412) + 0.5f) / float(_392._m0.y);
    bool _424 = (_392._m0.x < _411) || (_392._m0.y < _412);
    bool _430 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _430) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _445 = float2(_419, _420);
    float _450 = mad(t4.SampleLevel(s3, _445, 0.0f).x, 2.0f, -1.0f);
    float _465;
    if (_450 > 0.0f)
    {
        _465 = min(sqrt(_450), t0.Load(8u).x);
    }
    else
    {
        _465 = max(_450, -t0.Load(7u).x);
    }
    bool _479 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _484 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float4 _488 = t1.SampleLevel(s0, _445, 0.0f);
    float _489 = _488.x;
    float _490 = _488.y;
    float _491 = _488.z;
    float _560;
    float _561;
    float _562;
    if (_484 || _479)
    {
        float4 _498 = t3.SampleLevel(s2, _445, 0.0f);
        float2 _509 = float2(_498.x * asfloat(cb1_m[2u].x), _498.y * asfloat(cb1_m[2u].y));
        float _523 = exp2(max(_479 ? clamp((sqrt(dp2_f32(_509, _509)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _484 ? clamp((abs(_465) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float4 _527 = t2.SampleLevel(s1, _445, 0.0f);
        float _528 = _527.x;
        float _529 = _527.y;
        float _530 = _527.z;
        float _535 = asfloat(cb0_m[43u].w) * 20.0f;
        float _546 = mad(t7.SampleLevel(s5, float2(mad(_419, 30.0f, sin(_535)), mad(_420, 30.0f, cos(_535))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f);
        float _550 = sqrt(max(max(_528, max(_529, _530)), 1.0000000133514319600180897396058e-10f));
        float _551 = mad(_546, _550, _528);
        float _552 = mad(_546, _550, _529);
        float _553 = mad(_546, _550, _530);
        _560 = mad(_523, _491 - _553, _553);
        _561 = mad(_523, _490 - _552, _552);
        _562 = mad(_523, _489 - _551, _551);
    }
    else
    {
        _560 = _491;
        _561 = _490;
        _562 = _489;
    }
    float _568 = _430 ? g0[0u] : asfloat(cb1_m[2u].z);
    float4 _572 = t5.SampleLevel(s4, _445, 0.0f);
    float _573 = _572.x;
    float _582 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_573, _572.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _586 = mad(_568, _562, _573 / _582);
    float _587 = mad(_568, _561, _572.y / _582);
    float _588 = mad(_560, _568, _572.z / _582);
    float _592 = 1.0f / (max(_586, max(_588, _587)) + 1.0f);
    float _593 = _586 * _592;
    float _595 = _592 * _588;
    float3 _596 = float3(_593, _595, _592 * _587);
    float _597 = dp3_f32(_596, float3(0.25f, 0.25f, 0.5f));
    float _598 = dp3_f32(_596, float3(-0.25f, -0.25f, 0.5f));
    float _600 = dp2_f32(float2(_593, _595), float2(0.5f, -0.5f));
    float _601 = _597 - _598;
    float _602 = _600 + _601;
    float _603 = _597 + _598;
    float _604 = _601 - _600;
    bool _605 = !_424;
    float _986;
    float _987;
    float _988;
    if (_605)
    {
        float _609 = dp3_f32(float3(_602, _603, _604), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _619 = mad(-abs(_465), asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _623 = mad(_619, _602 - _609, _609);
        float _624 = mad(_619, _603 - _609, _609);
        float _625 = mad(_604 - _609, _619, _609);
        float _626 = _419 - 0.5f;
        float _627 = _420 - 0.5f;
        float _628 = _627 + _627;
        float _629 = _626 + _626;
        float _630 = abs(_629);
        float _631 = abs(_628);
        float _635 = min(_630, _631) * (1.0f / max(_630, _631));
        float _636 = _635 * _635;
        float _640 = mad(_636, mad(_636, mad(_636, mad(_636, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _649 = mad(_635, _640, (_630 < _631) ? mad(_635 * _640, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_629 < (-_629)) ? (-3.1415927410125732421875f) : 0.0f);
        float _650 = min(_629, _628);
        float _651 = max(_629, _628);
        float _658 = ((_650 < (-_650)) && (_651 >= (-_651))) ? (-_649) : _649;
        float4 _662 = t8.SampleLevel(s6, _445, 0.0f);
        float _663 = _662.x;
        float _664 = _662.y;
        float _665 = _662.z;
        float _666 = _662.w;
        float _671 = (_624 - _625) * 1.73205077648162841796875f;
        float _673 = mad(_623, 2.0f, -_624);
        float _674 = _673 - _625;
        float _675 = abs(_671);
        float _676 = abs(_674);
        float _680 = min(_675, _676) * (1.0f / max(_675, _676));
        float _681 = _680 * _680;
        float _685 = mad(_681, mad(_681, mad(_681, mad(_681, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _694 = mad(_680, _685, (_675 > _676) ? mad(_680 * _685, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_674 < (_625 - _673)) ? (-3.1415927410125732421875f) : 0.0f);
        float _695 = min(_671, _674);
        float _696 = max(_671, _674);
        float _705 = ((_625 == _624) && (_624 == _623)) ? 0.0f : ((((_695 < (-_695)) && (_696 >= (-_696))) ? (-_694) : _694) * 57.295780181884765625f);
        float _716 = mad(asfloat(cb1_m[19u].y), -360.0f, (_705 < 0.0f) ? (_705 + 360.0f) : _705);
        float _726 = clamp(1.0f - (abs((_716 < (-180.0f)) ? (_716 + 360.0f) : ((_716 > 180.0f) ? (_716 - 360.0f) : _716)) / (asfloat(cb1_m[19u].z) * 180.0f)), 0.0f, 1.0f);
        float _731 = dp3_f32(float3(_623, _624, _625), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _735 = (mad(_726, -2.0f, 3.0f) * (_726 * _726)) * asfloat(cb1_m[19u].w);
        float _747 = asfloat(cb1_m[18u].w);
        float _748 = mad(mad(_735, _623 - _731, _731) - _623, _747, _623);
        float _749 = mad(_747, mad(_624 - _731, _735, _731) - _624, _624);
        float _750 = mad(_747, mad(_735, _625 - _731, _731) - _625, _625);
        float _752;
        _752 = 0.0f;
        float _753;
        uint _756;
        uint _755 = 0u;
        for (;;)
        {
            if (_755 >= 8u)
            {
                break;
            }
            uint _767 = min((_755 & 3u), 4u);
            float _787 = mad(float(_755), 0.785398185253143310546875f, -_658);
            float _788 = _787 + 1.57079637050628662109375f;
            _753 = mad(_666 * (dp4_f32(t10.Load((_755 >> 2u) + 10u), float4(_327[_767].x, _327[_767].y, _327[_767].z, _327[_767].w)) * clamp((abs((_788 > 3.1415927410125732421875f) ? (_787 - 4.7123889923095703125f) : _788) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _752, _752);
            _756 = _755 + 1u;
            _752 = _753;
            _755 = _756;
            continue;
        }
        float _799 = clamp(_752, 0.0f, 1.0f);
        float _812 = asfloat(cb0_m[43u].w);
        float _818 = abs(t10.Load(8u).x);
        float2 _821 = float2(_626 * 1.40999996662139892578125f, _627 * 1.40999996662139892578125f);
        float _823 = sqrt(dp2_f32(_821, _821));
        float _824 = min(_823, 1.0f);
        float _825 = _824 * _824;
        float _830 = clamp(_823 - 0.5f, 0.0f, 1.0f);
        float _833 = (_824 * _825) + (mad(-_824, _825, 1.0f) * (_830 * _830));
        float _834 = mad(mad(mad(sin(_812 * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _818, -1.0f);
        float _836 = _664 + _834;
        float _838 = clamp((_665 + _834) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _845 = clamp(_836 + _836, 0.0f, 1.0f);
        float _862 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _868 = mad(sin(_664 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_862)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _870 = _868 * 0.02999999932944774627685546875f;
        float _871 = mad(_818, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _875 = mad(mad(-_833, _833, 1.0f), 1.0f - _871, _871);
        float _876 = min((exp2(log2(_833) * 0.699999988079071044921875f) * (mad(_845, -2.0f, 3.0f) * (_845 * _845))) + (mad(_838, -2.0f, 3.0f) * (_838 * _838)), 1.0f);
        float _886 = mad(_876, mad(_875, _868 * 0.62000000476837158203125f, mad(_748, _799, -_748)), mad(-_748, _799, _748));
        float _887 = mad(_876, mad(_875, _870, mad(_799, _749, -_749)), mad(-_799, _749, _749));
        float _888 = mad(_876, mad(_875, _870, mad(_799, _750, -_750)), mad(-_799, _750, _750));
        float _891 = mad(_664, _665 * (1.0f - _666), _666);
        float _893;
        _893 = 0.0f;
        float _894;
        uint _897;
        uint _896 = 0u;
        for (;;)
        {
            if (int(_896) >= 8)
            {
                break;
            }
            float4 _904 = t10.Load(_896);
            float _906 = _904.y;
            float _908 = _904.x - _658;
            _894 = mad(_891 * (_904.w * clamp((abs((_908 > 3.1415927410125732421875f) ? (_908 - 6.283185482025146484375f) : ((_908 < (-3.1415927410125732421875f)) ? (_908 + 6.283185482025146484375f) : _908)) + (_906 - 3.1415927410125732421875f)) / max(_906 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _893, _893);
            _897 = _896 + 1u;
            _893 = _894;
            _896 = _897;
            continue;
        }
        float _927 = clamp(_893 + _893, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _931 = mad(_927, 0.310000002384185791015625f - _886, _886);
        float _932 = mad(_927, 0.014999999664723873138427734375f - _887, _887);
        float _933 = mad(_927, 0.014999999664723873138427734375f - _888, _888);
        float4 _934 = t10.Load(12u);
        float _935 = _934.x;
        float _963;
        float _964;
        float _965;
        if (_935 != 0.0f)
        {
            float _942 = clamp(_862, 0.0f, 1.0f);
            float _952 = clamp((_663 + (_935 - 1.0f)) / max(mad(_935, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _956 = clamp(_935 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _959 = mad(_956, -2.0f, 3.0f) * (_956 * _956);
            _963 = mad(_959, _952 * (_942 * (_663 * 0.930000007152557373046875f)), _933);
            _964 = mad(_959, _952 * (_942 * (_663 * 0.85000002384185791015625f)), _932);
            _965 = mad((_942 * (_663 * 0.790000021457672119140625f)) * _952, _959, _931);
        }
        else
        {
            _963 = _933;
            _964 = _932;
            _965 = _931;
        }
        float _968 = asfloat(cb1_m[19u].x);
        bool _969 = _968 > 0.0f;
        bool _973 = frac((_420 * 420.0f) + (_812 * 0.20000000298023223876953125f)) >= 0.5f;
        float _974 = _973 ? 0.300000011920928955078125f : 0.0f;
        float _975 = _968 * _974;
        _986 = _969 ? mad(_975, 0.0f - _965, _965) : _965;
        _987 = _969 ? mad(_975, (_973 ? 0.100000001490116119384765625f : 0.0f) - _964, _964) : _964;
        _988 = _969 ? mad(_975, _974 - _963, _963) : _963;
    }
    else
    {
        _986 = _602;
        _987 = _603;
        _988 = _604;
    }
    float _993 = 1.0f / max(1.0f - max(max(_987, _988), _986), 6.099999882280826568603515625e-05f);
    float _1000 = min(-(_993 * _986), 0.0f);
    float _1001 = min(-(_993 * _987), 0.0f);
    float _1002 = min(-(_993 * _988), 0.0f);
    float2 _1005 = float2(_419 - 0.5f, _420 - 0.5f);
    float _1018 = clamp(-((sqrt(dp2_f32(_1005, _1005)) - asfloat(cb1_m[5u].x)) * (1.0f / asfloat(cb1_m[5u].y))), 0.0f, 1.0f);
    float _1019 = mad(_1018, -2.0f, 3.0f);
    float _1020 = _1018 * _1018;
    float _1021 = _1019 * _1020;
    float _1023 = mad(-_1019, _1020, 1.0f);
    float _1050 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
    float3 _1063 = float3(_424 ? (-_1000) : mad(_1000 + ((_1023 * asfloat(cb1_m[4u].x)) - (_1000 * _1021)), _1050, -_1000), _424 ? (-_1001) : mad(_1050, ((_1023 * asfloat(cb1_m[4u].y)) - (_1021 * _1001)) + _1001, -_1001), _424 ? (-_1002) : mad(_1050, ((_1023 * asfloat(cb1_m[4u].z)) - (_1021 * _1002)) + _1002, -_1002));
    float _1064 = dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1063);
    float _1065 = dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1063);
    float _1066 = dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1063);
    bool _1070 = asfloat(cb1_m[8u].x) != 0.0f;
    float _1089;
    float _1090;
    float _1091;
    if (!_1070)
    {
        float _1076 = asfloat(cb1_m[9u].y);
        float _1082 = asfloat(cb1_m[9u].x);
        _1089 = clamp(mad(_1082, mad(_1066, _1076, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1090 = clamp(mad(_1082, mad(_1065, _1076, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1091 = clamp(mad(_1082, mad(_1064, _1076, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
    }
    else
    {
        _1089 = _1066;
        _1090 = _1065;
        _1091 = _1064;
    }
    float _1095 = mad(asfloat(cb1_m[8u].y), -0.0005000000237487256526947021484375f, 0.312709987163543701171875f);
    float _1103 = mad(asfloat(cb1_m[8u].z), 0.0005000000237487256526947021484375f, (_1095 * 2.86999988555908203125f) - ((_1095 * _1095) * 3.0f));
    float _1104 = _1103 - 0.2750950753688812255859375f;
    float _1105 = _1095 / _1104;
    float _1109 = ((1.0f - _1095) + (0.2750950753688812255859375f - _1103)) / _1104;
    float3 _1119 = float3(_1091, _1090, _1089);
    float3 _1126 = float3((0.94923698902130126953125f / mad(_1109, -0.1624000072479248046875f, mad(_1105, 0.732800006866455078125f, 0.4296000003814697265625f))) * dp3_f32(float3(0.390404999256134033203125f, 0.549941003322601318359375f, 0.008926319889724254608154296875f), _1119), dp3_f32(float3(0.070841602981090545654296875f, 0.963172018527984619140625f, 0.001357750035822391510009765625f), _1119) * (1.035419940948486328125f / mad(_1109, 0.006099999882280826568603515625f, mad(_1105, -0.703599989414215087890625f, 1.6974999904632568359375f))), dp3_f32(float3(0.02310819923877716064453125f, 0.1280210018157958984375f, 0.936245024204254150390625f), _1119) * (1.0872800350189208984375f / mad(_1109, 0.98339998722076416015625f, mad(_1105, 0.0030000000260770320892333984375f, 0.013600000180304050445556640625f))));
    float3 _1136 = float3(dp3_f32(float3(2.85846996307373046875f, -1.62879002094268798828125f, -0.0248910002410411834716796875f), _1126), dp3_f32(float3(-0.21018199622631072998046875f, 1.1582000255584716796875f, 0.0003242809907533228397369384765625f), _1126), dp3_f32(float3(-0.0418119989335536956787109375f, -0.118169002234935760498046875f, 1.0686700344085693359375f), _1126));
    float _1141 = dp3_f32(_1136, float3(asfloat(cb1_m[9u].w), asfloat(cb1_m[10u].x), asfloat(cb1_m[10u].y)));
    float _1150 = dp3_f32(_1136, float3(asfloat(cb1_m[10u].z), asfloat(cb1_m[10u].w), asfloat(cb1_m[11u].x)));
    float _1160 = dp3_f32(_1136, float3(asfloat(cb1_m[11u].y), asfloat(cb1_m[11u].z), asfloat(cb1_m[11u].w)));
    float _1162 = dp3_f32(float3(_1141, _1150, _1160), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1165 = asfloat(cb1_m[14u].w);
    float _1173 = clamp((_1162 - _1165) * (1.0f / (asfloat(cb1_m[15u].x) - _1165)), 0.0f, 1.0f);
    float _1177 = mad(-mad(_1173, -2.0f, 3.0f), _1173 * _1173, 1.0f);
    float _1180 = asfloat(cb1_m[15u].y);
    float _1188 = clamp((_1162 - _1180) * (1.0f / (asfloat(cb1_m[15u].z) - _1180)), 0.0f, 1.0f);
    float _1189 = mad(_1188, -2.0f, 3.0f);
    float _1190 = _1188 * _1188;
    float _1191 = _1189 * _1190;
    float _1194 = 1.0f - clamp(mad(_1189, _1190, _1177), 0.0f, 1.0f);
    float _1225;
    float _1226;
    float _1227;
    if (_1070)
    {
        _1225 = asfloat(cb1_m[16u].y) + 1.0f;
        _1226 = asfloat(cb1_m[15u].w) + 1.0f;
        _1227 = asfloat(cb1_m[16u].x) + 1.0f;
    }
    else
    {
        float _1212 = asfloat(cb1_m[15u].w);
        float _1216 = asfloat(cb1_m[16u].x);
        _1225 = mad(_1216, 0.5f, mad(_1212, 0.25f, 1.0f)) + asfloat(cb1_m[16u].y);
        _1226 = _1212 + 1.0f;
        _1227 = mad(_1212, 0.5f, _1216) + 1.0f;
    }
    float _1279 = mad(_1191 * (_1150 * asfloat(cb1_m[14u].y)), _1225, ((_1177 * (_1150 * asfloat(cb1_m[12u].y))) * _1226) + ((_1194 * (_1150 * asfloat(cb1_m[13u].y))) * _1227));
    float _1280 = mad(_1191 * (_1160 * asfloat(cb1_m[14u].z)), _1225, ((_1177 * (_1160 * asfloat(cb1_m[12u].z))) * _1226) + ((_1194 * (_1160 * asfloat(cb1_m[13u].z))) * _1227));
    float _1281 = mad(_1191 * (_1141 * asfloat(cb1_m[14u].x)), _1225, ((_1194 * (_1141 * asfloat(cb1_m[13u].x))) * _1227) + ((_1177 * (_1141 * asfloat(cb1_m[12u].x))) * _1226));
    float _1285 = float(_1279 >= _1280);
    float _1286 = mad(_1279 - _1280, _1285, _1280);
    float _1287 = mad(_1285, _1280 - _1279, _1279);
    float _1289 = mad(_1285, -1.0f, 0.666666686534881591796875f);
    float _1295 = float(_1286 <= _1281);
    float _1296 = mad(_1281 - _1286, _1295, _1286);
    float _1297 = mad(_1295, _1287 - _1287, _1287);
    float _1299 = mad(_1295, _1286 - _1281, _1281);
    float _1301 = _1296 - min(_1299, _1297);
    float _1307 = _1301 / (_1296 + 9.9999997473787516355514526367188e-05f);
    float _1312 = abs(((_1299 - _1297) / mad(_1301, 6.0f, 9.9999997473787516355514526367188e-05f)) + mad(_1295, mad(_1285, 1.0f, -1.0f) - _1289, _1289)) + asfloat(cb1_m[9u].z);
    float _1318 = (_1312 < 0.0f) ? (_1312 + 1.0f) : ((_1312 > 1.0f) ? (_1312 - 1.0f) : _1312);
    float _1340 = mad(_1307, clamp(abs(mad(frac(_1318 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1341 = mad(_1307, clamp(abs(mad(frac(_1318 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1342 = mad(_1307, clamp(abs(mad(frac(_1318 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1347 = dp3_f32(float3(_1296 * _1340, _1296 * _1341, _1296 * _1342), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1356 = asfloat(cb1_m[8u].w);
    float _1357 = mad(mad(_1296, _1340, -_1347), _1356, _1347);
    float _1358 = mad(_1356, mad(_1296, _1341, -_1347), _1347);
    float _1359 = mad(_1356, mad(_1296, _1342, -_1347), _1347);
    float _1380;
    float _1381;
    float _1382;
    if (_1070)
    {
        float _1367 = asfloat(cb1_m[9u].x);
        float _1376 = asfloat(cb1_m[9u].y);
        _1380 = _1376 * clamp(mad(_1367, _1359 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1381 = _1376 * clamp(mad(_1367, _1358 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1382 = clamp(mad(_1357 - 0.1800537109375f, _1367, 0.1800537109375f), 0.0f, 65504.0f) * _1376;
    }
    else
    {
        _1380 = _1359;
        _1381 = _1358;
        _1382 = _1357;
    }
    if (_605)
    {
#if 1
  float _1388 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1382 * 2.5f, 65504.0f) : _1382;
  float _1389 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1381 * 2.5f, 65504.0f) : _1381;
  float _1390 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1380 * 2.5f, 65504.0f) : _1380;
#endif
        float _1394 = max(max(_1388, _1389), _1390);
        float _1399 = (max(_1394, 9.9999997473787516355514526367188e-05f) - max(min(min(_1388, _1389), _1390), 9.9999997473787516355514526367188e-05f)) / max(_1394, 0.00999999977648258209228515625f);
        float _1410 = mad(sqrt(mad(_1388, _1388 - _1390, ((_1390 - _1389) * _1390) + ((_1389 - _1388) * _1389))), 1.75f, _1388 + (_1390 + _1389));
        float _1411 = _1399 - 0.4000000059604644775390625f;
        float _1416 = max(1.0f - abs(_1411 * 2.5f), 0.0f);
        float _1423 = mad(mad(clamp(mad(_1411, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1416, _1416, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1431 = ((_1410 <= 0.1599999964237213134765625f) ? _1423 : ((_1410 >= 0.4799999892711639404296875f) ? 0.0f : (_1423 * ((0.07999999821186065673828125f / (_1410 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1432 = _1388 * _1431;
        float _1433 = _1431 * _1389;
        float _1434 = _1431 * _1390;
        float _1439 = (_1433 - _1434) * 1.73205077648162841796875f;
        float _1441 = (_1432 * 2.0f) - _1433;
        float _1443 = mad(-_1431, _1390, _1441);
        float _1444 = abs(_1443);
        float _1445 = abs(_1439);
        float _1449 = min(_1444, _1445) * (1.0f / max(_1444, _1445));
        float _1450 = _1449 * _1449;
        float _1454 = mad(_1450, mad(_1450, mad(_1450, mad(_1450, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1464 = mad(_1449, _1454, (_1444 < _1445) ? mad(_1449 * _1454, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1443 < mad(_1431, _1390, -_1441)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1465 = min(_1439, _1443);
        float _1466 = max(_1439, _1443);
        float _1475 = ((_1432 == _1433) && (_1434 == _1433)) ? 0.0f : ((((_1465 < (-_1465)) && (_1466 >= (-_1466))) ? (-_1464) : _1464) * 57.295780181884765625f);
        float _1478 = (_1475 < 0.0f) ? (_1475 + 360.0f) : _1475;
        float _1488 = max(1.0f - abs(((_1478 < (-180.0f)) ? (_1478 + 360.0f) : ((_1478 > 180.0f) ? (_1478 - 360.0f) : _1478)) * 0.01481481455266475677490234375f), 0.0f);
        float _1491 = mad(_1488, -2.0f, 3.0f) * (_1488 * _1488);
        float3 _1502 = float3(clamp(_1432 + (((_1399 * (_1491 * _1491)) * mad(-_1388, _1431, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1433, 0.0f, 65504.0f), clamp(_1434, 0.0f, 65504.0f));
        float _1506 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1502), 0.0f, 65504.0f);
        float _1507 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1502), 0.0f, 65504.0f);
        float _1508 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1502), 0.0f, 65504.0f);

        float _1510 = dp3_f32(float3(_1506, _1507, _1508), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1517 = float3(mad(_1506 - _1510, 0.959999978542327880859375f, _1510), mad(_1507 - _1510, 0.959999978542327880859375f, _1510), mad(_1508 - _1510, 0.959999978542327880859375f, _1510));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[uint2(_411, _412)] = float4(CustomACES(_1517), 1.f);
    return;
  }
#endif
        float3 _1521 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1517), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1517), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1517));
        float _1522 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1521);
        float _1523 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1521);
        float _1524 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1521);
        uint _1526;
        spvTextureSize(t9, 0u, _1526);
        bool _1527 = _1526 > 0u;
        uint _1528_dummy_parameter;
        _1529 _1530 = { spvTextureSize(t9, 0u, _1528_dummy_parameter), 1u };
        float _1533 = float(_1527 ? _1530._m0.x : 0u);
        float _1536 = float(_1527 ? _1530._m0.y : 0u);
        float _1539 = float(_1527 ? _1530._m0.z : 0u);
        float _1543 = float(_1523 >= _1524);
        float _1544 = mad(_1523 - _1524, _1543, _1524);
        float _1545 = mad(_1524 - _1523, _1543, _1523);
        float _1547 = mad(_1543, -1.0f, 0.666666686534881591796875f);
        float _1553 = float(_1522 >= _1544);
        float _1554 = mad(_1522 - _1544, _1553, _1544);
        float _1555 = mad(_1545 - _1545, _1553, _1545);
        float _1557 = mad(_1544 - _1522, _1553, _1522);
        float _1559 = _1554 - min(_1557, _1555);
        float4 _1583 = t9.SampleLevel(s7, float3(abs(mad(mad(_1543, 1.0f, -1.0f) - _1547, _1553, _1547) + ((_1557 - _1555) / mad(_1559, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1533 + _1533)), (1.0f / (_1536 + _1536)) + (_1559 / (_1554 + 9.9999997473787516355514526367188e-05f)), mad(_1554 * 3.0f, 1.0f / mad(_1554, 3.0f, 1.5f), 1.0f / (_1539 + _1539))), 0.0f);
        float _1584 = _1583.x;
        float _1585 = _1583.y;
        float _1586 = _1583.z;
        float3 _1614 = float3(mad(_1586, mad(_1585, clamp(abs(mad(frac(_1584 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1584 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1585, 1.0f), _1586, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1584 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1585, 1.0f), _1586, -3.5073844628641381859779357910156e-05f));
        float3 _1618 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1614), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1614), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1614));
        float3 _1622 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1618), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1618), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1618));
        float _1631 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1622) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1642 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1622) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1652 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1622) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[uint2(_411, _412)] = float4(min(exp2(log2(mad(_1631, 18.8515625f, 0.8359375f) / mad(_1631, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1642, 18.8515625f, 0.8359375f) / mad(_1642, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1652, 18.8515625f, 0.8359375f) / mad(_1652, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

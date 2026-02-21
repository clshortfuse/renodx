#include "../common.hlsl"
struct _386
{
    uint2 _m0;
    uint _m1;
};

struct _1503
{
    uint3 _m0;
    uint _m1;
};

static const float _55[1] = { 0.0f };
static const float4 _324[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _377 = a.x * b.x;
    return mad(a.y, b.y, _377);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _363 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _363));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _345 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _345)));
}

void comp_main()
{
    uint _385_dummy_parameter;
    _386 _387 = { spvImageSize(u0, _385_dummy_parameter), 1u };
    uint _402 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _406 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_402, 1u, 3u);
    uint _407 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _402, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _414 = (float(_406) + 0.5f) / float(_387._m0.x);
    float _415 = (float(_407) + 0.5f) / float(_387._m0.y);
    bool _419 = (_387._m0.x < _406) || (_387._m0.y < _407);
    bool _425 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _425) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _440 = float2(_414, _415);
    float _445 = mad(t4.SampleLevel(s3, _440, 0.0f).x, 2.0f, -1.0f);
    float _460;
    if (_445 > 0.0f)
    {
        _460 = min(sqrt(_445), t0.Load(8u).x);
    }
    else
    {
        _460 = max(_445, -t0.Load(7u).x);
    }
    bool _474 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _479 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float4 _483 = t1.SampleLevel(s0, _440, 0.0f);
    float _484 = _483.x;
    float _485 = _483.y;
    float _486 = _483.z;
    float _555;
    float _556;
    float _557;
    if (_479 || _474)
    {
        float4 _493 = t3.SampleLevel(s2, _440, 0.0f);
        float2 _504 = float2(_493.x * asfloat(cb1_m[2u].x), _493.y * asfloat(cb1_m[2u].y));
        float _518 = exp2(max(_474 ? clamp((sqrt(dp2_f32(_504, _504)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _479 ? clamp((abs(_460) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float4 _522 = t2.SampleLevel(s1, _440, 0.0f);
        float _523 = _522.x;
        float _524 = _522.y;
        float _525 = _522.z;
        float _530 = asfloat(cb0_m[43u].w) * 20.0f;
        float _541 = mad(t7.SampleLevel(s5, float2(mad(_414, 30.0f, sin(_530)), mad(_415, 30.0f, cos(_530))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f);
        float _545 = sqrt(max(max(_523, max(_524, _525)), 1.0000000133514319600180897396058e-10f));
        float _546 = mad(_541, _545, _523);
        float _547 = mad(_541, _545, _524);
        float _548 = mad(_541, _545, _525);
        _555 = mad(_518, _486 - _548, _548);
        _556 = mad(_518, _485 - _547, _547);
        _557 = mad(_518, _484 - _546, _546);
    }
    else
    {
        _555 = _486;
        _556 = _485;
        _557 = _484;
    }
    float _563 = _425 ? g0[0u] : asfloat(cb1_m[2u].z);
    float4 _567 = t5.SampleLevel(s4, _440, 0.0f);
    float _568 = _567.x;
    float _577 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_568, _567.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _581 = mad(_557, _563, _568 / _577);
    float _582 = mad(_556, _563, _567.y / _577);
    float _583 = mad(_555, _563, _567.z / _577);
    float _587 = 1.0f / (max(_581, max(_583, _582)) + 1.0f);
    float _588 = _581 * _587;
    float _590 = _587 * _583;
    float3 _591 = float3(_588, _590, _587 * _582);
    float _592 = dp3_f32(_591, float3(0.25f, 0.25f, 0.5f));
    float _593 = dp3_f32(_591, float3(-0.25f, -0.25f, 0.5f));
    float _595 = dp2_f32(float2(_588, _590), float2(0.5f, -0.5f));
    float _596 = _592 - _593;
    float _597 = _595 + _596;
    float _598 = _592 + _593;
    float _599 = _596 - _595;
    bool _600 = !_419;
    float _960;
    float _961;
    float _962;
    if (_600)
    {
        float _604 = dp3_f32(float3(_597, _598, _599), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _614 = mad(-abs(_460), asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _618 = mad(_614, _597 - _604, _604);
        float _619 = mad(_598 - _604, _614, _604);
        float _620 = mad(_599 - _604, _614, _604);
        float _621 = _414 - 0.5f;
        float _622 = _415 - 0.5f;
        float _623 = _622 + _622;
        float _624 = _621 + _621;
        float _625 = abs(_624);
        float _626 = abs(_623);
        float _630 = min(_625, _626) * (1.0f / max(_625, _626));
        float _631 = _630 * _630;
        float _635 = mad(_631, mad(_631, mad(_631, mad(_631, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _644 = mad(_630, _635, (_625 < _626) ? mad(_630 * _635, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_624 < (-_624)) ? (-3.1415927410125732421875f) : 0.0f);
        float _645 = min(_624, _623);
        float _646 = max(_624, _623);
        float _653 = ((_645 < (-_645)) && (_646 >= (-_646))) ? (-_644) : _644;
        float4 _657 = t8.SampleLevel(s6, _440, 0.0f);
        float _658 = _657.x;
        float _659 = _657.y;
        float _660 = _657.z;
        float _661 = _657.w;
        float _666 = (_619 - _620) * 1.73205077648162841796875f;
        float _668 = mad(_618, 2.0f, -_619);
        float _669 = _668 - _620;
        float _670 = abs(_666);
        float _671 = abs(_669);
        float _675 = min(_670, _671) * (1.0f / max(_670, _671));
        float _676 = _675 * _675;
        float _680 = mad(_676, mad(_676, mad(_676, mad(_676, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _689 = mad(_675, _680, (_670 > _671) ? mad(_675 * _680, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_669 < (_620 - _668)) ? (-3.1415927410125732421875f) : 0.0f);
        float _690 = min(_666, _669);
        float _691 = max(_666, _669);
        float _700 = ((_620 == _619) && (_619 == _618)) ? 0.0f : ((((_690 < (-_690)) && (_691 >= (-_691))) ? (-_689) : _689) * 57.295780181884765625f);
        float _711 = mad(asfloat(cb1_m[19u].x), -360.0f, (_700 < 0.0f) ? (_700 + 360.0f) : _700);
        float _721 = clamp(1.0f - (abs((_711 < (-180.0f)) ? (_711 + 360.0f) : ((_711 > 180.0f) ? (_711 - 360.0f) : _711)) / (asfloat(cb1_m[19u].y) * 180.0f)), 0.0f, 1.0f);
        float _726 = dp3_f32(float3(_618, _619, _620), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _730 = (mad(_721, -2.0f, 3.0f) * (_721 * _721)) * asfloat(cb1_m[19u].z);
        float _742 = asfloat(cb1_m[18u].w);
        float _743 = mad(mad(_730, _618 - _726, _726) - _618, _742, _618);
        float _744 = mad(_742, mad(_730, _619 - _726, _726) - _619, _619);
        float _745 = mad(_742, mad(_730, _620 - _726, _726) - _620, _620);
        float _747;
        _747 = 0.0f;
        float _748;
        uint _751;
        uint _750 = 0u;
        for (;;)
        {
            if (_750 >= 8u)
            {
                break;
            }
            uint _762 = min((_750 & 3u), 4u);
            float _782 = mad(float(_750), 0.785398185253143310546875f, -_653);
            float _783 = _782 + 1.57079637050628662109375f;
            _748 = mad(_661 * (dp4_f32(t10.Load((_750 >> 2u) + 10u), float4(_324[_762].x, _324[_762].y, _324[_762].z, _324[_762].w)) * clamp((abs((_783 > 3.1415927410125732421875f) ? (_782 - 4.7123889923095703125f) : _783) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _747, _747);
            _751 = _750 + 1u;
            _747 = _748;
            _750 = _751;
            continue;
        }
        float _794 = clamp(_747, 0.0f, 1.0f);
        float _812 = abs(t10.Load(8u).x);
        float2 _815 = float2(_621 * 1.40999996662139892578125f, _622 * 1.40999996662139892578125f);
        float _817 = sqrt(dp2_f32(_815, _815));
        float _818 = min(_817, 1.0f);
        float _819 = _818 * _818;
        float _824 = clamp(_817 - 0.5f, 0.0f, 1.0f);
        float _827 = (_818 * _819) + (mad(-_818, _819, 1.0f) * (_824 * _824));
        float _828 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _812, -1.0f);
        float _830 = _659 + _828;
        float _832 = clamp((_660 + _828) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _839 = clamp(_830 + _830, 0.0f, 1.0f);
        float _856 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _862 = mad(sin(_659 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_856)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _864 = _862 * 0.02999999932944774627685546875f;
        float _865 = mad(_812, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _869 = mad(mad(-_827, _827, 1.0f), 1.0f - _865, _865);
        float _870 = min((exp2(log2(_827) * 0.699999988079071044921875f) * (mad(_839, -2.0f, 3.0f) * (_839 * _839))) + (mad(_832, -2.0f, 3.0f) * (_832 * _832)), 1.0f);
        float _880 = mad(_870, mad(_869, _862 * 0.62000000476837158203125f, mad(_743, _794, -_743)), mad(-_743, _794, _743));
        float _881 = mad(_870, mad(_869, _864, mad(_794, _744, -_744)), mad(-_794, _744, _744));
        float _882 = mad(_870, mad(_869, _864, mad(_794, _745, -_745)), mad(-_794, _745, _745));
        float _885 = mad(_659, _660 * (1.0f - _661), _661);
        float _887;
        _887 = 0.0f;
        float _888;
        uint _891;
        uint _890 = 0u;
        for (;;)
        {
            if (int(_890) >= 8)
            {
                break;
            }
            float4 _898 = t10.Load(_890);
            float _900 = _898.y;
            float _902 = _898.x - _653;
            _888 = mad(_885 * (_898.w * clamp(((_900 - 3.1415927410125732421875f) + abs((_902 > 3.1415927410125732421875f) ? (_902 - 6.283185482025146484375f) : ((_902 < (-3.1415927410125732421875f)) ? (_902 + 6.283185482025146484375f) : _902))) / max(_900 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _887, _887);
            _891 = _890 + 1u;
            _887 = _888;
            _890 = _891;
            continue;
        }
        float _921 = clamp(_887 + _887, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _925 = mad(_921, 0.310000002384185791015625f - _880, _880);
        float _926 = mad(_921, 0.014999999664723873138427734375f - _881, _881);
        float _927 = mad(_921, 0.014999999664723873138427734375f - _882, _882);
        float4 _928 = t10.Load(12u);
        float _929 = _928.x;
        float _957;
        float _958;
        float _959;
        if (_929 != 0.0f)
        {
            float _936 = clamp(_856, 0.0f, 1.0f);
            float _946 = clamp((_658 + (_929 - 1.0f)) / max(mad(_929, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _950 = clamp(_929 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _953 = mad(_950, -2.0f, 3.0f) * (_950 * _950);
            _957 = mad((_936 * (_658 * 0.790000021457672119140625f)) * _946, _953, _925);
            _958 = mad(_953, _946 * (_936 * (_658 * 0.85000002384185791015625f)), _926);
            _959 = mad(_953, _946 * (_936 * (_658 * 0.930000007152557373046875f)), _927);
        }
        else
        {
            _957 = _925;
            _958 = _926;
            _959 = _927;
        }
        _960 = _957;
        _961 = _958;
        _962 = _959;
    }
    else
    {
        _960 = _597;
        _961 = _598;
        _962 = _599;
    }
    float _967 = 1.0f / max(1.0f - max(max(_961, _962), _960), 6.099999882280826568603515625e-05f);
    float _974 = min(-(_967 * _960), 0.0f);
    float _975 = min(-(_967 * _961), 0.0f);
    float _976 = min(-(_967 * _962), 0.0f);
    float2 _979 = float2(_414 - 0.5f, _415 - 0.5f);
    float _992 = clamp(-((1.0f / asfloat(cb1_m[5u].y)) * (sqrt(dp2_f32(_979, _979)) - asfloat(cb1_m[5u].x))), 0.0f, 1.0f);
    float _993 = mad(_992, -2.0f, 3.0f);
    float _994 = _992 * _992;
    float _995 = _993 * _994;
    float _997 = mad(-_993, _994, 1.0f);
    float _1024 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
    float3 _1037 = float3(_419 ? (-_974) : mad(_974 + ((_997 * asfloat(cb1_m[4u].x)) - (_974 * _995)), _1024, -_974), _419 ? (-_975) : mad(_1024, ((_997 * asfloat(cb1_m[4u].y)) - (_995 * _975)) + _975, -_975), _419 ? (-_976) : mad(_1024, ((_997 * asfloat(cb1_m[4u].z)) - (_995 * _976)) + _976, -_976));
    float _1038 = dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1037);
    float _1039 = dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1037);
    float _1040 = dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1037);
    bool _1044 = asfloat(cb1_m[8u].x) != 0.0f;
    float _1063;
    float _1064;
    float _1065;
    if (!_1044)
    {
        float _1050 = asfloat(cb1_m[9u].y);
        float _1056 = asfloat(cb1_m[9u].x);
        _1063 = clamp(mad(_1056, mad(_1040, _1050, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1064 = clamp(mad(_1056, mad(_1039, _1050, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1065 = clamp(mad(_1056, mad(_1038, _1050, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
    }
    else
    {
        _1063 = _1040;
        _1064 = _1039;
        _1065 = _1038;
    }
    float _1069 = mad(asfloat(cb1_m[8u].y), -0.0005000000237487256526947021484375f, 0.312709987163543701171875f);
    float _1077 = mad(asfloat(cb1_m[8u].z), 0.0005000000237487256526947021484375f, (_1069 * 2.86999988555908203125f) - ((_1069 * _1069) * 3.0f));
    float _1078 = _1077 - 0.2750950753688812255859375f;
    float _1079 = _1069 / _1078;
    float _1083 = ((1.0f - _1069) + (0.2750950753688812255859375f - _1077)) / _1078;
    float3 _1093 = float3(_1065, _1064, _1063);
    float3 _1100 = float3((0.94923698902130126953125f / mad(_1083, -0.1624000072479248046875f, mad(_1079, 0.732800006866455078125f, 0.4296000003814697265625f))) * dp3_f32(float3(0.390404999256134033203125f, 0.549941003322601318359375f, 0.008926319889724254608154296875f), _1093), dp3_f32(float3(0.070841602981090545654296875f, 0.963172018527984619140625f, 0.001357750035822391510009765625f), _1093) * (1.035419940948486328125f / mad(_1083, 0.006099999882280826568603515625f, mad(_1079, -0.703599989414215087890625f, 1.6974999904632568359375f))), dp3_f32(float3(0.02310819923877716064453125f, 0.1280210018157958984375f, 0.936245024204254150390625f), _1093) * (1.0872800350189208984375f / mad(_1083, 0.98339998722076416015625f, mad(_1079, 0.0030000000260770320892333984375f, 0.013600000180304050445556640625f))));
    float3 _1110 = float3(dp3_f32(float3(2.85846996307373046875f, -1.62879002094268798828125f, -0.0248910002410411834716796875f), _1100), dp3_f32(float3(-0.21018199622631072998046875f, 1.1582000255584716796875f, 0.0003242809907533228397369384765625f), _1100), dp3_f32(float3(-0.0418119989335536956787109375f, -0.118169002234935760498046875f, 1.0686700344085693359375f), _1100));
    float _1115 = dp3_f32(_1110, float3(asfloat(cb1_m[9u].w), asfloat(cb1_m[10u].x), asfloat(cb1_m[10u].y)));
    float _1124 = dp3_f32(_1110, float3(asfloat(cb1_m[10u].z), asfloat(cb1_m[10u].w), asfloat(cb1_m[11u].x)));
    float _1134 = dp3_f32(_1110, float3(asfloat(cb1_m[11u].y), asfloat(cb1_m[11u].z), asfloat(cb1_m[11u].w)));
    float _1136 = dp3_f32(float3(_1115, _1124, _1134), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1139 = asfloat(cb1_m[14u].w);
    float _1147 = clamp((_1136 - _1139) * (1.0f / (asfloat(cb1_m[15u].x) - _1139)), 0.0f, 1.0f);
    float _1151 = mad(-mad(_1147, -2.0f, 3.0f), _1147 * _1147, 1.0f);
    float _1154 = asfloat(cb1_m[15u].y);
    float _1162 = clamp((_1136 - _1154) * (1.0f / (asfloat(cb1_m[15u].z) - _1154)), 0.0f, 1.0f);
    float _1163 = mad(_1162, -2.0f, 3.0f);
    float _1164 = _1162 * _1162;
    float _1165 = _1163 * _1164;
    float _1168 = 1.0f - clamp(mad(_1163, _1164, _1151), 0.0f, 1.0f);
    float _1199;
    float _1200;
    float _1201;
    if (_1044)
    {
        _1199 = asfloat(cb1_m[16u].y) + 1.0f;
        _1200 = asfloat(cb1_m[15u].w) + 1.0f;
        _1201 = asfloat(cb1_m[16u].x) + 1.0f;
    }
    else
    {
        float _1186 = asfloat(cb1_m[15u].w);
        float _1190 = asfloat(cb1_m[16u].x);
        _1199 = mad(_1190, 0.5f, mad(_1186, 0.25f, 1.0f)) + asfloat(cb1_m[16u].y);
        _1200 = _1186 + 1.0f;
        _1201 = mad(_1186, 0.5f, _1190) + 1.0f;
    }
    float _1253 = mad(_1165 * (_1124 * asfloat(cb1_m[14u].y)), _1199, ((_1151 * (_1124 * asfloat(cb1_m[12u].y))) * _1200) + ((_1168 * (_1124 * asfloat(cb1_m[13u].y))) * _1201));
    float _1254 = mad(_1165 * (_1134 * asfloat(cb1_m[14u].z)), _1199, ((_1151 * (_1134 * asfloat(cb1_m[12u].z))) * _1200) + ((_1168 * (_1134 * asfloat(cb1_m[13u].z))) * _1201));
    float _1255 = mad(_1165 * (_1115 * asfloat(cb1_m[14u].x)), _1199, ((_1168 * (_1115 * asfloat(cb1_m[13u].x))) * _1201) + ((_1151 * (_1115 * asfloat(cb1_m[12u].x))) * _1200));
    float _1259 = float(_1253 >= _1254);
    float _1260 = mad(_1253 - _1254, _1259, _1254);
    float _1261 = mad(_1259, _1254 - _1253, _1253);
    float _1263 = mad(_1259, -1.0f, 0.666666686534881591796875f);
    float _1269 = float(_1260 <= _1255);
    float _1270 = mad(_1255 - _1260, _1269, _1260);
    float _1271 = mad(_1269, _1261 - _1261, _1261);
    float _1273 = mad(_1269, _1260 - _1255, _1255);
    float _1275 = _1270 - min(_1273, _1271);
    float _1281 = _1275 / (_1270 + 9.9999997473787516355514526367188e-05f);
    float _1286 = abs(((_1273 - _1271) / mad(_1275, 6.0f, 9.9999997473787516355514526367188e-05f)) + mad(_1269, mad(_1259, 1.0f, -1.0f) - _1263, _1263)) + asfloat(cb1_m[9u].z);
    float _1292 = (_1286 < 0.0f) ? (_1286 + 1.0f) : ((_1286 > 1.0f) ? (_1286 - 1.0f) : _1286);
    float _1314 = mad(_1281, clamp(abs(mad(frac(_1292 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1315 = mad(_1281, clamp(abs(mad(frac(_1292 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1316 = mad(_1281, clamp(abs(mad(frac(_1292 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1321 = dp3_f32(float3(_1270 * _1314, _1270 * _1315, _1270 * _1316), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1330 = asfloat(cb1_m[8u].w);
    float _1331 = mad(mad(_1270, _1314, -_1321), _1330, _1321);
    float _1332 = mad(_1330, mad(_1270, _1315, -_1321), _1321);
    float _1333 = mad(_1330, mad(_1270, _1316, -_1321), _1321);
    float _1354;
    float _1355;
    float _1356;
    if (_1044)
    {
        float _1341 = asfloat(cb1_m[9u].x);
        float _1350 = asfloat(cb1_m[9u].y);
        _1354 = _1350 * clamp(mad(_1341, _1333 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1355 = _1350 * clamp(mad(_1341, _1332 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1356 = clamp(mad(_1331 - 0.1800537109375f, _1341, 0.1800537109375f), 0.0f, 65504.0f) * _1350;
    }
    else
    {
        _1354 = _1333;
        _1355 = _1332;
        _1356 = _1331;
    }
    if (_600)
    {
#if 1
  float _1362 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1356 * 2.5f, 65504.0f) : _1356;
  float _1363 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1355 * 2.5f, 65504.0f) : _1355;
  float _1364 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1354 * 2.5f, 65504.0f) : _1354;
#endif
        float _1368 = max(max(_1362, _1363), _1364);
        float _1373 = (max(_1368, 9.9999997473787516355514526367188e-05f) - max(min(min(_1362, _1363), _1364), 9.9999997473787516355514526367188e-05f)) / max(_1368, 0.00999999977648258209228515625f);
        float _1384 = mad(sqrt(mad(_1362, _1362 - _1364, ((_1364 - _1363) * _1364) + ((_1363 - _1362) * _1363))), 1.75f, _1362 + (_1364 + _1363));
        float _1385 = _1373 - 0.4000000059604644775390625f;
        float _1390 = max(1.0f - abs(_1385 * 2.5f), 0.0f);
        float _1397 = mad(mad(clamp(mad(_1385, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1390, _1390, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1405 = ((_1384 <= 0.1599999964237213134765625f) ? _1397 : ((_1384 >= 0.4799999892711639404296875f) ? 0.0f : (_1397 * ((0.07999999821186065673828125f / (_1384 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1406 = _1362 * _1405;
        float _1407 = _1405 * _1363;
        float _1408 = _1405 * _1364;
        float _1413 = (_1407 - _1408) * 1.73205077648162841796875f;
        float _1415 = (_1406 * 2.0f) - _1407;
        float _1417 = mad(-_1405, _1364, _1415);
        float _1418 = abs(_1417);
        float _1419 = abs(_1413);
        float _1423 = min(_1418, _1419) * (1.0f / max(_1418, _1419));
        float _1424 = _1423 * _1423;
        float _1428 = mad(_1424, mad(_1424, mad(_1424, mad(_1424, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1438 = mad(_1423, _1428, (_1418 < _1419) ? mad(_1423 * _1428, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1417 < mad(_1405, _1364, -_1415)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1439 = min(_1413, _1417);
        float _1440 = max(_1413, _1417);
        float _1449 = ((_1406 == _1407) && (_1408 == _1407)) ? 0.0f : ((((_1439 < (-_1439)) && (_1440 >= (-_1440))) ? (-_1438) : _1438) * 57.295780181884765625f);
        float _1452 = (_1449 < 0.0f) ? (_1449 + 360.0f) : _1449;
        float _1462 = max(1.0f - abs(((_1452 < (-180.0f)) ? (_1452 + 360.0f) : ((_1452 > 180.0f) ? (_1452 - 360.0f) : _1452)) * 0.01481481455266475677490234375f), 0.0f);
        float _1465 = mad(_1462, -2.0f, 3.0f) * (_1462 * _1462);
        float3 _1476 = float3(clamp(_1406 + (((_1373 * (_1465 * _1465)) * mad(-_1362, _1405, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1407, 0.0f, 65504.0f), clamp(_1408, 0.0f, 65504.0f));
        float _1480 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1476), 0.0f, 65504.0f);
        float _1481 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1476), 0.0f, 65504.0f);
        float _1482 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1476), 0.0f, 65504.0f);

        float _1484 = dp3_f32(float3(_1480, _1481, _1482), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1491 = float3(mad(_1480 - _1484, 0.959999978542327880859375f, _1484), mad(_1481 - _1484, 0.959999978542327880859375f, _1484), mad(_1482 - _1484, 0.959999978542327880859375f, _1484));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[uint2(_406, _407)] = float4(CustomACES(_1491), 1.f);
    return;
  }
#endif
        float3 _1495 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1491), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1491), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1491));
        float _1496 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1495);
        float _1497 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1495);
        float _1498 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1495);
        uint _1500;
        spvTextureSize(t9, 0u, _1500);
        bool _1501 = _1500 > 0u;
        uint _1502_dummy_parameter;
        _1503 _1504 = { spvTextureSize(t9, 0u, _1502_dummy_parameter), 1u };
        float _1507 = float(_1501 ? _1504._m0.x : 0u);
        float _1510 = float(_1501 ? _1504._m0.y : 0u);
        float _1513 = float(_1501 ? _1504._m0.z : 0u);
        float _1517 = float(_1497 >= _1498);
        float _1518 = mad(_1497 - _1498, _1517, _1498);
        float _1519 = mad(_1498 - _1497, _1517, _1497);
        float _1521 = mad(_1517, -1.0f, 0.666666686534881591796875f);
        float _1527 = float(_1496 >= _1518);
        float _1528 = mad(_1496 - _1518, _1527, _1518);
        float _1529 = mad(_1519 - _1519, _1527, _1519);
        float _1531 = mad(_1518 - _1496, _1527, _1496);
        float _1533 = _1528 - min(_1531, _1529);
        float4 _1557 = t9.SampleLevel(s7, float3(abs(mad(mad(_1517, 1.0f, -1.0f) - _1521, _1527, _1521) + ((_1531 - _1529) / mad(_1533, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1507 + _1507)), (1.0f / (_1510 + _1510)) + (_1533 / (_1528 + 9.9999997473787516355514526367188e-05f)), mad(_1528 * 3.0f, 1.0f / mad(_1528, 3.0f, 1.5f), 1.0f / (_1513 + _1513))), 0.0f);
        float _1558 = _1557.x;
        float _1559 = _1557.y;
        float _1560 = _1557.z;
        float3 _1588 = float3(mad(_1560, mad(_1559, clamp(abs(mad(frac(_1558 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1558 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1559, 1.0f), _1560, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1558 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1559, 1.0f), _1560, -3.5073844628641381859779357910156e-05f));
        float3 _1592 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1588), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1588), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1588));
        float3 _1596 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1592), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1592), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1592));
        float _1605 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1596) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1616 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1596) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1626 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1596) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[uint2(_406, _407)] = float4(min(exp2(log2(mad(_1605, 18.8515625f, 0.8359375f) / mad(_1605, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1616, 18.8515625f, 0.8359375f) / mad(_1616, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1626, 18.8515625f, 0.8359375f) / mad(_1626, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

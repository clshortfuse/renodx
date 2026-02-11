#include "../common.hlsl"
struct _396
{
    uint2 _m0;
    uint _m1;
};

struct _1616
{
    uint3 _m0;
    uint _m1;
};

static const float _56[1] = { 0.0f };
static const float4 _334[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _387 = a.x * b.x;
    return mad(a.y, b.y, _387);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _373 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _373));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _355 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _355)));
}

void comp_main()
{
    uint _395_dummy_parameter;
    _396 _397 = { spvImageSize(u0, _395_dummy_parameter), 1u };
    uint _412 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _416 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_412, 1u, 3u);
    uint _417 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _412, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _424 = (float(_416) + 0.5f) / float(_397._m0.x);
    float _425 = (float(_417) + 0.5f) / float(_397._m0.y);
    bool _429 = (_397._m0.x < _416) || (_397._m0.y < _417);
    bool _435 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _435) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _450 = float2(_424, _425);
    float _455 = mad(t4.SampleLevel(s3, _450, 0.0f).x, 2.0f, -1.0f);
    float _470;
    if (_455 > 0.0f)
    {
        _470 = min(sqrt(_455), t0.Load(8u).x);
    }
    else
    {
        _470 = max(_455, -t0.Load(7u).x);
    }
    float4 _474 = t3.SampleLevel(s2, _450, 0.0f);
    float2 _486 = float2(_474.x * asfloat(cb1_m[2u].x), _474.y * asfloat(cb1_m[2u].y));
    bool _501 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _506 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float _510 = abs(_470);
    float _518 = exp2(max(_501 ? clamp((sqrt(dp2_f32(_486, _486)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _506 ? clamp((_510 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _519 = _424 - 0.5f;
    float _520 = _425 - 0.5f;
    float2 _521 = float2(_519, _520);
    float _522 = dp2_f32(_521, _521);
    float _525 = asfloat(cb1_m[18u].x);
    float _526 = mad(_522, _525, 1.0f);
    float _532 = asfloat(cb1_m[18u].z);
    float _539 = asfloat(cb1_m[18u].y);
    float _551 = mad(exp2(log2(clamp(_525, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(asfloat(cb1_m[18u].y), -0.089999973773956298828125f, 1.0f);
    float _552 = (_526 * mad(_539, mad(_532, -0.001999996602535247802734375f, 0.092000000178813934326171875f), 1.0f)) * _551;
    float _553 = _551 * (_526 * mad(_539, mad(_532, 0.04500000178813934326171875f, 0.046999998390674591064453125f), 1.0f));
    float _554 = _551 * (_526 * mad(_539, mad(_532, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _555 = mad(_519, _552, 0.5f);
    float _556 = mad(_552, _520, 0.5f);
    float _557 = mad(_519, _553, 0.5f);
    float _558 = mad(_553, _520, 0.5f);
    float2 _561 = float2(_555, _556);
    float4 _563 = t1.SampleLevel(s0, _561, 0.0f);
    float _564 = _563.x;
    bool _565 = _506 || _501;
    float _598;
    if (_565)
    {
        float4 _571 = t2.SampleLevel(s1, _561, 0.0f);
        float _572 = _571.x;
        float _579 = asfloat(cb0_m[43u].w) * 20.0f;
        float _595 = mad(mad(t7.SampleLevel(s5, float2(mad(_555, 30.0f, sin(_579)), mad(_556, 30.0f, cos(_579))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_572, max(_571.y, _571.z)), 1.0000000133514319600180897396058e-10f)), _572);
        _598 = mad(_518, _564 - _595, _595);
    }
    else
    {
        _598 = _564;
    }
    float2 _599 = float2(_557, _558);
    float4 _601 = t1.SampleLevel(s0, _599, 0.0f);
    float _602 = _601.y;
    float _635;
    if (_565)
    {
        float4 _608 = t2.SampleLevel(s1, _599, 0.0f);
        float _610 = _608.y;
        float _616 = asfloat(cb0_m[43u].w) * 20.0f;
        float _632 = mad(mad(t7.SampleLevel(s5, float2(mad(_557, 30.0f, sin(_616)), mad(_558, 30.0f, cos(_616))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_608.x, max(_610, _608.z)), 1.0000000133514319600180897396058e-10f)), _610);
        _635 = mad(_518, _602 - _632, _632);
    }
    else
    {
        _635 = _602;
    }
    float _636 = mad(_519, _554, 0.5f);
    float _637 = mad(_554, _520, 0.5f);
    float2 _638 = float2(_636, _637);
    float4 _640 = t1.SampleLevel(s0, _638, 0.0f);
    float _641 = _640.z;
    float _674;
    if (_565)
    {
        float4 _647 = t2.SampleLevel(s1, _638, 0.0f);
        float _650 = _647.z;
        float _655 = asfloat(cb0_m[43u].w) * 20.0f;
        float _671 = mad(mad(t7.SampleLevel(s5, float2(mad(_636, 30.0f, sin(_655)), mad(_637, 30.0f, cos(_655))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_647.x, max(_647.y, _650)), 1.0000000133514319600180897396058e-10f)), _650);
        _674 = mad(_518, _641 - _671, _671);
    }
    else
    {
        _674 = _641;
    }
    float _680 = _435 ? g0[0u] : asfloat(cb1_m[2u].z);
    float4 _684 = t5.SampleLevel(s4, _450, 0.0f);
    float _685 = _684.x;
    float _694 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_685, _684.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _698 = mad(_598, _680, _685 / _694);
    float _699 = mad(_635, _680, _684.y / _694);
    float _700 = mad(_674, _680, _684.z / _694);
    float _704 = 1.0f / (max(_698, max(_700, _699)) + 1.0f);
    float _705 = _698 * _704;
    float _707 = _704 * _700;
    float3 _708 = float3(_705, _707, _704 * _699);
    float _709 = dp3_f32(_708, float3(0.25f, 0.25f, 0.5f));
    float _710 = dp3_f32(_708, float3(-0.25f, -0.25f, 0.5f));
    float _712 = dp2_f32(float2(_705, _707), float2(0.5f, -0.5f));
    uint2 _714 = uint2(_416, _417);
    u1[_714] = float4(_709, _712, _710, _709);
    float _716 = _709 - _710;
    float _717 = _712 + _716;
    float _718 = _709 + _710;
    float _719 = _716 - _712;
    bool _720 = !_429;
    float _1077;
    float _1078;
    float _1079;
    if (_720)
    {
        float _724 = dp3_f32(float3(_717, _718, _719), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _733 = mad(-_510, asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _737 = mad(_733, _717 - _724, _724);
        float _738 = mad(_733, _718 - _724, _724);
        float _739 = mad(_733, _719 - _724, _724);
        float _740 = _520 + _520;
        float _741 = _519 + _519;
        float _742 = abs(_741);
        float _743 = abs(_740);
        float _747 = min(_742, _743) * (1.0f / max(_742, _743));
        float _748 = _747 * _747;
        float _752 = mad(_748, mad(_748, mad(_748, mad(_748, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _761 = mad(_747, _752, (_742 < _743) ? mad(_747 * _752, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_741 < (-_741)) ? (-3.1415927410125732421875f) : 0.0f);
        float _762 = min(_741, _740);
        float _763 = max(_741, _740);
        float _770 = ((_762 < (-_762)) && (_763 >= (-_763))) ? (-_761) : _761;
        float4 _774 = t8.SampleLevel(s6, _450, 0.0f);
        float _775 = _774.x;
        float _776 = _774.y;
        float _777 = _774.z;
        float _778 = _774.w;
        float _783 = (_738 - _739) * 1.73205077648162841796875f;
        float _785 = mad(_737, 2.0f, -_738);
        float _786 = _785 - _739;
        float _787 = abs(_783);
        float _788 = abs(_786);
        float _792 = min(_787, _788) * (1.0f / max(_787, _788));
        float _793 = _792 * _792;
        float _797 = mad(_793, mad(_793, mad(_793, mad(_793, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _806 = mad(_792, _797, (_787 > _788) ? mad(_792 * _797, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_786 < (_739 - _785)) ? (-3.1415927410125732421875f) : 0.0f);
        float _807 = min(_783, _786);
        float _808 = max(_783, _786);
        float _817 = ((_739 == _738) && (_737 == _738)) ? 0.0f : ((((_807 < (-_807)) && (_808 >= (-_808))) ? (-_806) : _806) * 57.295780181884765625f);
        float _828 = mad(asfloat(cb1_m[19u].x), -360.0f, (_817 < 0.0f) ? (_817 + 360.0f) : _817);
        float _838 = clamp(1.0f - (abs((_828 < (-180.0f)) ? (_828 + 360.0f) : ((_828 > 180.0f) ? (_828 - 360.0f) : _828)) / (asfloat(cb1_m[19u].y) * 180.0f)), 0.0f, 1.0f);
        float _843 = dp3_f32(float3(_737, _738, _739), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _847 = (mad(_838, -2.0f, 3.0f) * (_838 * _838)) * asfloat(cb1_m[19u].z);
        float _859 = asfloat(cb1_m[18u].w);
        float _860 = mad(mad(_847, _737 - _843, _843) - _737, _859, _737);
        float _861 = mad(mad(_738 - _843, _847, _843) - _738, _859, _738);
        float _862 = mad(mad(_739 - _843, _847, _843) - _739, _859, _739);
        float _864;
        _864 = 0.0f;
        float _865;
        uint _868;
        uint _867 = 0u;
        for (;;)
        {
            if (_867 >= 8u)
            {
                break;
            }
            uint _879 = min((_867 & 3u), 4u);
            float _899 = mad(float(_867), 0.785398185253143310546875f, -_770);
            float _900 = _899 + 1.57079637050628662109375f;
            _865 = mad(_778 * (dp4_f32(t10.Load((_867 >> 2u) + 10u), float4(_334[_879].x, _334[_879].y, _334[_879].z, _334[_879].w)) * clamp((abs((_900 > 3.1415927410125732421875f) ? (_899 - 4.7123889923095703125f) : _900) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _864, _864);
            _868 = _867 + 1u;
            _864 = _865;
            _867 = _868;
            continue;
        }
        float _911 = clamp(_864, 0.0f, 1.0f);
        float _929 = abs(t10.Load(8u).x);
        float2 _932 = float2(_519 * 1.40999996662139892578125f, _520 * 1.40999996662139892578125f);
        float _934 = sqrt(dp2_f32(_932, _932));
        float _935 = min(_934, 1.0f);
        float _936 = _935 * _935;
        float _941 = clamp(_934 - 0.5f, 0.0f, 1.0f);
        float _944 = (_935 * _936) + (mad(-_935, _936, 1.0f) * (_941 * _941));
        float _945 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _929, -1.0f);
        float _947 = _776 + _945;
        float _949 = clamp((_777 + _945) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _956 = clamp(_947 + _947, 0.0f, 1.0f);
        float _973 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _979 = mad(sin(_776 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_973)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _981 = _979 * 0.02999999932944774627685546875f;
        float _982 = mad(_929, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _986 = mad(mad(-_944, _944, 1.0f), 1.0f - _982, _982);
        float _987 = min((exp2(log2(_944) * 0.699999988079071044921875f) * (mad(_956, -2.0f, 3.0f) * (_956 * _956))) + (mad(_949, -2.0f, 3.0f) * (_949 * _949)), 1.0f);
        float _997 = mad(_987, mad(_986, _979 * 0.62000000476837158203125f, mad(_860, _911, -_860)), mad(-_860, _911, _860));
        float _998 = mad(_987, mad(_986, _981, mad(_911, _861, -_861)), mad(-_911, _861, _861));
        float _999 = mad(_987, mad(_986, _981, mad(_911, _862, -_862)), mad(-_911, _862, _862));
        float _1002 = mad(_776, _777 * (1.0f - _778), _778);
        float _1004;
        _1004 = 0.0f;
        float _1005;
        uint _1008;
        uint _1007 = 0u;
        for (;;)
        {
            if (int(_1007) >= 8)
            {
                break;
            }
            float4 _1015 = t10.Load(_1007);
            float _1017 = _1015.y;
            float _1019 = _1015.x - _770;
            _1005 = mad(_1002 * (_1015.w * clamp(((_1017 - 3.1415927410125732421875f) + abs((_1019 > 3.1415927410125732421875f) ? (_1019 - 6.283185482025146484375f) : ((_1019 < (-3.1415927410125732421875f)) ? (_1019 + 6.283185482025146484375f) : _1019))) / max(_1017 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _1004, _1004);
            _1008 = _1007 + 1u;
            _1004 = _1005;
            _1007 = _1008;
            continue;
        }
        float _1038 = clamp(_1004 + _1004, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _1042 = mad(_1038, 0.310000002384185791015625f - _997, _997);
        float _1043 = mad(_1038, 0.014999999664723873138427734375f - _998, _998);
        float _1044 = mad(_1038, 0.014999999664723873138427734375f - _999, _999);
        float4 _1045 = t10.Load(12u);
        float _1046 = _1045.x;
        float _1074;
        float _1075;
        float _1076;
        if (_1046 != 0.0f)
        {
            float _1053 = clamp(_973, 0.0f, 1.0f);
            float _1063 = clamp((_775 + (_1046 - 1.0f)) / max(mad(_1046, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _1067 = clamp(_1046 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _1070 = mad(_1067, -2.0f, 3.0f) * (_1067 * _1067);
            _1074 = mad((_1053 * (_775 * 0.790000021457672119140625f)) * _1063, _1070, _1042);
            _1075 = mad(_1070, _1063 * (_1053 * (_775 * 0.85000002384185791015625f)), _1043);
            _1076 = mad(_1070, _1063 * (_1053 * (_775 * 0.930000007152557373046875f)), _1044);
        }
        else
        {
            _1074 = _1042;
            _1075 = _1043;
            _1076 = _1044;
        }
        _1077 = _1074;
        _1078 = _1075;
        _1079 = _1076;
    }
    else
    {
        _1077 = _717;
        _1078 = _718;
        _1079 = _719;
    }
    float _1084 = 1.0f / max(1.0f - max(max(_1078, _1079), _1077), 6.099999882280826568603515625e-05f);
    float _1091 = min(-(_1084 * _1077), 0.0f);
    float _1092 = min(-(_1084 * _1078), 0.0f);
    float _1093 = min(-(_1084 * _1079), 0.0f);
    float _1105 = clamp(-((1.0f / asfloat(cb1_m[5u].y)) * (sqrt(_522) - asfloat(cb1_m[5u].x))), 0.0f, 1.0f);
    float _1106 = mad(_1105, -2.0f, 3.0f);
    float _1107 = _1105 * _1105;
    float _1108 = _1106 * _1107;
    float _1110 = mad(-_1106, _1107, 1.0f);
    float _1137 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
    float3 _1150 = float3(_429 ? (-_1091) : mad(_1091 + ((_1110 * asfloat(cb1_m[4u].x)) - (_1091 * _1108)), _1137, -_1091), _429 ? (-_1092) : mad(_1137, ((_1110 * asfloat(cb1_m[4u].y)) - (_1108 * _1092)) + _1092, -_1092), _429 ? (-_1093) : mad(_1137, ((_1110 * asfloat(cb1_m[4u].z)) - (_1108 * _1093)) + _1093, -_1093));
    float _1151 = dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1150);
    float _1152 = dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1150);
    float _1153 = dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1150);
    bool _1157 = asfloat(cb1_m[8u].x) != 0.0f;
    float _1176;
    float _1177;
    float _1178;
    if (!_1157)
    {
        float _1163 = asfloat(cb1_m[9u].y);
        float _1169 = asfloat(cb1_m[9u].x);
        _1176 = clamp(mad(_1169, mad(_1153, _1163, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1177 = clamp(mad(_1169, mad(_1152, _1163, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1178 = clamp(mad(_1169, mad(_1151, _1163, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
    }
    else
    {
        _1176 = _1153;
        _1177 = _1152;
        _1178 = _1151;
    }
    float _1182 = mad(asfloat(cb1_m[8u].y), -0.0005000000237487256526947021484375f, 0.312709987163543701171875f);
    float _1190 = mad(asfloat(cb1_m[8u].z), 0.0005000000237487256526947021484375f, (_1182 * 2.86999988555908203125f) - ((_1182 * _1182) * 3.0f));
    float _1191 = _1190 - 0.2750950753688812255859375f;
    float _1192 = _1182 / _1191;
    float _1196 = ((1.0f - _1182) + (0.2750950753688812255859375f - _1190)) / _1191;
    float3 _1206 = float3(_1178, _1177, _1176);
    float3 _1213 = float3((0.94923698902130126953125f / mad(_1196, -0.1624000072479248046875f, mad(_1192, 0.732800006866455078125f, 0.4296000003814697265625f))) * dp3_f32(float3(0.390404999256134033203125f, 0.549941003322601318359375f, 0.008926319889724254608154296875f), _1206), dp3_f32(float3(0.070841602981090545654296875f, 0.963172018527984619140625f, 0.001357750035822391510009765625f), _1206) * (1.035419940948486328125f / mad(_1196, 0.006099999882280826568603515625f, mad(_1192, -0.703599989414215087890625f, 1.6974999904632568359375f))), dp3_f32(float3(0.02310819923877716064453125f, 0.1280210018157958984375f, 0.936245024204254150390625f), _1206) * (1.0872800350189208984375f / mad(_1196, 0.98339998722076416015625f, mad(_1192, 0.0030000000260770320892333984375f, 0.013600000180304050445556640625f))));
    float3 _1223 = float3(dp3_f32(float3(2.85846996307373046875f, -1.62879002094268798828125f, -0.0248910002410411834716796875f), _1213), dp3_f32(float3(-0.21018199622631072998046875f, 1.1582000255584716796875f, 0.0003242809907533228397369384765625f), _1213), dp3_f32(float3(-0.0418119989335536956787109375f, -0.118169002234935760498046875f, 1.0686700344085693359375f), _1213));
    float _1228 = dp3_f32(_1223, float3(asfloat(cb1_m[9u].w), asfloat(cb1_m[10u].x), asfloat(cb1_m[10u].y)));
    float _1237 = dp3_f32(_1223, float3(asfloat(cb1_m[10u].z), asfloat(cb1_m[10u].w), asfloat(cb1_m[11u].x)));
    float _1247 = dp3_f32(_1223, float3(asfloat(cb1_m[11u].y), asfloat(cb1_m[11u].z), asfloat(cb1_m[11u].w)));
    float _1249 = dp3_f32(float3(_1228, _1237, _1247), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1252 = asfloat(cb1_m[14u].w);
    float _1260 = clamp((_1249 - _1252) * (1.0f / (asfloat(cb1_m[15u].x) - _1252)), 0.0f, 1.0f);
    float _1264 = mad(-mad(_1260, -2.0f, 3.0f), _1260 * _1260, 1.0f);
    float _1267 = asfloat(cb1_m[15u].y);
    float _1275 = clamp((_1249 - _1267) * (1.0f / (asfloat(cb1_m[15u].z) - _1267)), 0.0f, 1.0f);
    float _1276 = mad(_1275, -2.0f, 3.0f);
    float _1277 = _1275 * _1275;
    float _1278 = _1276 * _1277;
    float _1281 = 1.0f - clamp(mad(_1276, _1277, _1264), 0.0f, 1.0f);
    float _1312;
    float _1313;
    float _1314;
    if (_1157)
    {
        _1312 = asfloat(cb1_m[16u].y) + 1.0f;
        _1313 = asfloat(cb1_m[15u].w) + 1.0f;
        _1314 = asfloat(cb1_m[16u].x) + 1.0f;
    }
    else
    {
        float _1299 = asfloat(cb1_m[15u].w);
        float _1303 = asfloat(cb1_m[16u].x);
        _1312 = mad(_1303, 0.5f, mad(_1299, 0.25f, 1.0f)) + asfloat(cb1_m[16u].y);
        _1313 = _1299 + 1.0f;
        _1314 = mad(_1299, 0.5f, _1303) + 1.0f;
    }
    float _1366 = mad(_1278 * (_1237 * asfloat(cb1_m[14u].y)), _1312, ((_1264 * (_1237 * asfloat(cb1_m[12u].y))) * _1313) + ((_1281 * (_1237 * asfloat(cb1_m[13u].y))) * _1314));
    float _1367 = mad(_1278 * (_1247 * asfloat(cb1_m[14u].z)), _1312, ((_1264 * (_1247 * asfloat(cb1_m[12u].z))) * _1313) + ((_1281 * (_1247 * asfloat(cb1_m[13u].z))) * _1314));
    float _1368 = mad(_1278 * (_1228 * asfloat(cb1_m[14u].x)), _1312, ((_1281 * (_1228 * asfloat(cb1_m[13u].x))) * _1314) + ((_1264 * (_1228 * asfloat(cb1_m[12u].x))) * _1313));
    float _1372 = float(_1366 >= _1367);
    float _1373 = mad(_1366 - _1367, _1372, _1367);
    float _1374 = mad(_1372, _1367 - _1366, _1366);
    float _1376 = mad(_1372, -1.0f, 0.666666686534881591796875f);
    float _1382 = float(_1373 <= _1368);
    float _1383 = mad(_1368 - _1373, _1382, _1373);
    float _1384 = mad(_1382, _1374 - _1374, _1374);
    float _1386 = mad(_1382, _1373 - _1368, _1368);
    float _1388 = _1383 - min(_1386, _1384);
    float _1394 = _1388 / (_1383 + 9.9999997473787516355514526367188e-05f);
    float _1399 = abs(((_1386 - _1384) / mad(_1388, 6.0f, 9.9999997473787516355514526367188e-05f)) + mad(_1382, mad(_1372, 1.0f, -1.0f) - _1376, _1376)) + asfloat(cb1_m[9u].z);
    float _1405 = (_1399 < 0.0f) ? (_1399 + 1.0f) : ((_1399 > 1.0f) ? (_1399 - 1.0f) : _1399);
    float _1427 = mad(_1394, clamp(abs(mad(frac(_1405 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1428 = mad(_1394, clamp(abs(mad(frac(_1405 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1429 = mad(_1394, clamp(abs(mad(frac(_1405 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1434 = dp3_f32(float3(_1383 * _1427, _1383 * _1428, _1383 * _1429), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1443 = asfloat(cb1_m[8u].w);
    float _1444 = mad(mad(_1383, _1427, -_1434), _1443, _1434);
    float _1445 = mad(_1443, mad(_1383, _1428, -_1434), _1434);
    float _1446 = mad(_1443, mad(_1383, _1429, -_1434), _1434);
    float _1467;
    float _1468;
    float _1469;
    if (_1157)
    {
        float _1454 = asfloat(cb1_m[9u].x);
        float _1463 = asfloat(cb1_m[9u].y);
        _1467 = _1463 * clamp(mad(_1454, _1446 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1468 = _1463 * clamp(mad(_1454, _1445 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1469 = clamp(mad(_1444 - 0.1800537109375f, _1454, 0.1800537109375f), 0.0f, 65504.0f) * _1463;
    }
    else
    {
        _1467 = _1446;
        _1468 = _1445;
        _1469 = _1444;
    }
    if (_720)
    {
#if 1
  float _1475 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1469 * 2.5f, 65504.0f) : _1469;
  float _1476 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1468 * 2.5f, 65504.0f) : _1468;
  float _1477 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1467 * 2.5f, 65504.0f) : _1467;
#endif
        float _1481 = max(max(_1475, _1476), _1477);
        float _1486 = (max(_1481, 9.9999997473787516355514526367188e-05f) - max(min(min(_1475, _1476), _1477), 9.9999997473787516355514526367188e-05f)) / max(_1481, 0.00999999977648258209228515625f);
        float _1497 = mad(sqrt(mad(_1475, _1475 - _1477, ((_1477 - _1476) * _1477) + ((_1476 - _1475) * _1476))), 1.75f, _1475 + (_1477 + _1476));
        float _1498 = _1486 - 0.4000000059604644775390625f;
        float _1503 = max(1.0f - abs(_1498 * 2.5f), 0.0f);
        float _1510 = mad(mad(clamp(mad(_1498, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1503, _1503, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1518 = ((_1497 <= 0.1599999964237213134765625f) ? _1510 : ((_1497 >= 0.4799999892711639404296875f) ? 0.0f : (_1510 * ((0.07999999821186065673828125f / (_1497 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1519 = _1475 * _1518;
        float _1520 = _1518 * _1476;
        float _1521 = _1518 * _1477;
        float _1526 = (_1520 - _1521) * 1.73205077648162841796875f;
        float _1528 = (_1519 * 2.0f) - _1520;
        float _1530 = mad(-_1518, _1477, _1528);
        float _1531 = abs(_1530);
        float _1532 = abs(_1526);
        float _1536 = min(_1531, _1532) * (1.0f / max(_1531, _1532));
        float _1537 = _1536 * _1536;
        float _1541 = mad(_1537, mad(_1537, mad(_1537, mad(_1537, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1551 = mad(_1536, _1541, (_1531 < _1532) ? mad(_1536 * _1541, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1530 < mad(_1518, _1477, -_1528)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1552 = min(_1526, _1530);
        float _1553 = max(_1526, _1530);
        float _1562 = ((_1519 == _1520) && (_1521 == _1520)) ? 0.0f : ((((_1552 < (-_1552)) && (_1553 >= (-_1553))) ? (-_1551) : _1551) * 57.295780181884765625f);
        float _1565 = (_1562 < 0.0f) ? (_1562 + 360.0f) : _1562;
        float _1575 = max(1.0f - abs(((_1565 < (-180.0f)) ? (_1565 + 360.0f) : ((_1565 > 180.0f) ? (_1565 - 360.0f) : _1565)) * 0.01481481455266475677490234375f), 0.0f);
        float _1578 = mad(_1575, -2.0f, 3.0f) * (_1575 * _1575);
        float3 _1589 = float3(clamp(_1519 + (((_1486 * (_1578 * _1578)) * mad(-_1475, _1518, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1520, 0.0f, 65504.0f), clamp(_1521, 0.0f, 65504.0f));
        float _1593 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1589), 0.0f, 65504.0f);
        float _1594 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1589), 0.0f, 65504.0f);
        float _1595 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1589), 0.0f, 65504.0f);

        float _1597 = dp3_f32(float3(_1593, _1594, _1595), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1604 = float3(mad(_1593 - _1597, 0.959999978542327880859375f, _1597), mad(_1594 - _1597, 0.959999978542327880859375f, _1597), mad(_1595 - _1597, 0.959999978542327880859375f, _1597));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_714] = float4(CustomACES(_1604), 1.f);
    return;
  }
#endif
        float3 _1608 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1604), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1604), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1604));
        float _1609 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1608);
        float _1610 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1608);
        float _1611 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1608);
        uint _1613;
        spvTextureSize(t9, 0u, _1613);
        bool _1614 = _1613 > 0u;
        uint _1615_dummy_parameter;
        _1616 _1617 = { spvTextureSize(t9, 0u, _1615_dummy_parameter), 1u };
        float _1620 = float(_1614 ? _1617._m0.x : 0u);
        float _1623 = float(_1614 ? _1617._m0.y : 0u);
        float _1626 = float(_1614 ? _1617._m0.z : 0u);
        float _1630 = float(_1610 >= _1611);
        float _1631 = mad(_1610 - _1611, _1630, _1611);
        float _1632 = mad(_1611 - _1610, _1630, _1610);
        float _1634 = mad(_1630, -1.0f, 0.666666686534881591796875f);
        float _1640 = float(_1609 >= _1631);
        float _1641 = mad(_1609 - _1631, _1640, _1631);
        float _1642 = mad(_1632 - _1632, _1640, _1632);
        float _1644 = mad(_1631 - _1609, _1640, _1609);
        float _1646 = _1641 - min(_1644, _1642);
        float4 _1670 = t9.SampleLevel(s7, float3(abs(mad(mad(_1630, 1.0f, -1.0f) - _1634, _1640, _1634) + ((_1644 - _1642) / mad(_1646, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1620 + _1620)), (1.0f / (_1623 + _1623)) + (_1646 / (_1641 + 9.9999997473787516355514526367188e-05f)), mad(_1641 * 3.0f, 1.0f / mad(_1641, 3.0f, 1.5f), 1.0f / (_1626 + _1626))), 0.0f);
        float _1671 = _1670.x;
        float _1672 = _1670.y;
        float _1673 = _1670.z;
        float3 _1701 = float3(mad(_1673, mad(_1672, clamp(abs(mad(frac(_1671 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1671 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1672, 1.0f), _1673, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1671 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1672, 1.0f), _1673, -3.5073844628641381859779357910156e-05f));
        float3 _1705 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1701), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1701), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1701));
        float3 _1709 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1705), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1705), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1705));
        float _1718 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1709) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1729 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1709) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1739 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1709) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_714] = float4(min(exp2(log2(mad(_1718, 18.8515625f, 0.8359375f) / mad(_1718, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1729, 18.8515625f, 0.8359375f) / mad(_1729, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1739, 18.8515625f, 0.8359375f) / mad(_1739, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

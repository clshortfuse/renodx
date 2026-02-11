#include "../common.hlsl"
struct _387
{
    uint2 _m0;
    uint _m1;
};

struct _1507
{
    uint3 _m0;
    uint _m1;
};

static const float _56[1] = { 0.0f };
static const float4 _325[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _378 = a.x * b.x;
    return mad(a.y, b.y, _378);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _364 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _364));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _346 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _346)));
}

void comp_main()
{
    uint _386_dummy_parameter;
    _387 _388 = { spvImageSize(u0, _386_dummy_parameter), 1u };
    uint _403 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _407 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_403, 1u, 3u);
    uint _408 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _403, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _415 = (float(_407) + 0.5f) / float(_388._m0.x);
    float _416 = (float(_408) + 0.5f) / float(_388._m0.y);
    bool _420 = (_388._m0.x < _407) || (_388._m0.y < _408);
    bool _426 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _426) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _441 = float2(_415, _416);
    float _446 = mad(t4.SampleLevel(s3, _441, 0.0f).x, 2.0f, -1.0f);
    float _461;
    if (_446 > 0.0f)
    {
        _461 = min(sqrt(_446), t0.Load(8u).x);
    }
    else
    {
        _461 = max(_446, -t0.Load(7u).x);
    }
    bool _475 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _480 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float4 _484 = t1.SampleLevel(s0, _441, 0.0f);
    float _485 = _484.x;
    float _486 = _484.y;
    float _487 = _484.z;
    float _556;
    float _557;
    float _558;
    if (_480 || _475)
    {
        float4 _494 = t3.SampleLevel(s2, _441, 0.0f);
        float2 _505 = float2(_494.x * asfloat(cb1_m[2u].x), _494.y * asfloat(cb1_m[2u].y));
        float _519 = exp2(max(_475 ? clamp((sqrt(dp2_f32(_505, _505)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _480 ? clamp((abs(_461) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float4 _523 = t2.SampleLevel(s1, _441, 0.0f);
        float _524 = _523.x;
        float _525 = _523.y;
        float _526 = _523.z;
        float _531 = asfloat(cb0_m[43u].w) * 20.0f;
        float _542 = mad(t7.SampleLevel(s5, float2(mad(_415, 30.0f, sin(_531)), mad(_416, 30.0f, cos(_531))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f);
        float _546 = sqrt(max(max(_524, max(_525, _526)), 1.0000000133514319600180897396058e-10f));
        float _547 = mad(_542, _546, _524);
        float _548 = mad(_542, _546, _525);
        float _549 = mad(_542, _546, _526);
        _556 = mad(_519, _487 - _549, _549);
        _557 = mad(_519, _486 - _548, _548);
        _558 = mad(_519, _485 - _547, _547);
    }
    else
    {
        _556 = _487;
        _557 = _486;
        _558 = _485;
    }
    float _564 = _426 ? g0[0u] : asfloat(cb1_m[2u].z);
    float4 _568 = t5.SampleLevel(s4, _441, 0.0f);
    float _569 = _568.x;
    float _578 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_569, _568.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _582 = mad(_558, _564, _569 / _578);
    float _583 = mad(_557, _564, _568.y / _578);
    float _584 = mad(_556, _564, _568.z / _578);
    float _588 = 1.0f / (max(_582, max(_584, _583)) + 1.0f);
    float _589 = _582 * _588;
    float _591 = _588 * _584;
    float3 _592 = float3(_589, _591, _588 * _583);
    float _593 = dp3_f32(_592, float3(0.25f, 0.25f, 0.5f));
    float _594 = dp3_f32(_592, float3(-0.25f, -0.25f, 0.5f));
    float _596 = dp2_f32(float2(_589, _591), float2(0.5f, -0.5f));
    uint2 _598 = uint2(_407, _408);
    u1[_598] = float4(_593, _596, _594, _593);
    float _600 = _593 - _594;
    float _601 = _596 + _600;
    float _602 = _593 + _594;
    float _603 = _600 - _596;
    bool _604 = !_420;
    float _964;
    float _965;
    float _966;
    if (_604)
    {
        float _608 = dp3_f32(float3(_601, _602, _603), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _618 = mad(-abs(_461), asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _622 = mad(_618, _601 - _608, _608);
        float _623 = mad(_618, _602 - _608, _608);
        float _624 = mad(_618, _603 - _608, _608);
        float _625 = _415 - 0.5f;
        float _626 = _416 - 0.5f;
        float _627 = _626 + _626;
        float _628 = _625 + _625;
        float _629 = abs(_628);
        float _630 = abs(_627);
        float _634 = min(_629, _630) * (1.0f / max(_629, _630));
        float _635 = _634 * _634;
        float _639 = mad(_635, mad(_635, mad(_635, mad(_635, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _648 = mad(_634, _639, (_629 < _630) ? mad(_634 * _639, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_628 < (-_628)) ? (-3.1415927410125732421875f) : 0.0f);
        float _649 = min(_628, _627);
        float _650 = max(_628, _627);
        float _657 = ((_649 < (-_649)) && (_650 >= (-_650))) ? (-_648) : _648;
        float4 _661 = t8.SampleLevel(s6, _441, 0.0f);
        float _662 = _661.x;
        float _663 = _661.y;
        float _664 = _661.z;
        float _665 = _661.w;
        float _672 = (_623 - _624) * 1.73205077648162841796875f;
        float _674 = mad(_622, 2.0f, -_623);
        float _675 = _674 - _624;
        float _676 = abs(_675);
        float _677 = abs(_672);
        float _681 = min(_676, _677) * (1.0f / max(_676, _677));
        float _682 = _681 * _681;
        float _686 = mad(_682, mad(_682, mad(_682, mad(_682, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _695 = mad(_681, _686, (_676 < _677) ? mad(_681 * _686, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_675 < (_624 - _674)) ? (-3.1415927410125732421875f) : 0.0f);
        float _696 = min(_672, _675);
        float _697 = max(_672, _675);
        float _706 = ((_624 == _623) && (_623 == _622)) ? 0.0f : ((((_696 < (-_696)) && (_697 >= (-_697))) ? (-_695) : _695) * 57.295780181884765625f);
        float _717 = mad(asfloat(cb1_m[19u].x), -360.0f, (_706 < 0.0f) ? (_706 + 360.0f) : _706);
        float _727 = clamp(1.0f - (abs((_717 < (-180.0f)) ? (_717 + 360.0f) : ((_717 > 180.0f) ? (_717 - 360.0f) : _717)) / (asfloat(cb1_m[19u].y) * 180.0f)), 0.0f, 1.0f);
        float _732 = dp3_f32(float3(_622, _623, _624), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _736 = (mad(_727, -2.0f, 3.0f) * (_727 * _727)) * asfloat(cb1_m[19u].z);
        float _748 = asfloat(cb1_m[18u].w);
        float _749 = mad(mad(_736, _622 - _732, _732) - _622, _748, _622);
        float _750 = mad(_748, mad(_736, _623 - _732, _732) - _623, _623);
        float _751 = mad(_748, mad(_736, _624 - _732, _732) - _624, _624);
        float _753;
        _753 = 0.0f;
        float _754;
        uint _757;
        uint _756 = 0u;
        for (;;)
        {
            if (_756 >= 8u)
            {
                break;
            }
            uint _768 = min((_756 & 3u), 4u);
            float _788 = mad(float(_756), 0.785398185253143310546875f, -_657);
            float _789 = _788 + 1.57079637050628662109375f;
            _754 = mad(_665 * (dp4_f32(t10.Load((_756 >> 2u) + 10u), float4(_325[_768].x, _325[_768].y, _325[_768].z, _325[_768].w)) * clamp((abs((_789 > 3.1415927410125732421875f) ? (_788 - 4.7123889923095703125f) : _789) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _753, _753);
            _757 = _756 + 1u;
            _753 = _754;
            _756 = _757;
            continue;
        }
        float _800 = clamp(_753, 0.0f, 1.0f);
        float _818 = abs(t10.Load(8u).x);
        float2 _819 = float2(_625 * 1.40999996662139892578125f, _626 * 1.40999996662139892578125f);
        float _821 = sqrt(dp2_f32(_819, _819));
        float _822 = min(_821, 1.0f);
        float _823 = _822 * _822;
        float _828 = clamp(_821 - 0.5f, 0.0f, 1.0f);
        float _831 = (_822 * _823) + (mad(-_822, _823, 1.0f) * (_828 * _828));
        float _832 = mad(mad(mad(sin(asfloat(cb0_m[43u].w) * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _818, -1.0f);
        float _834 = _663 + _832;
        float _836 = clamp((_664 + _832) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _842 = clamp(_834 + _834, 0.0f, 1.0f);
        float _860 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _866 = mad(sin(_663 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_860)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _868 = _866 * 0.02999999932944774627685546875f;
        float _869 = mad(_818, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _873 = mad(mad(-_831, _831, 1.0f), 1.0f - _869, _869);
        float _874 = min((exp2(log2(_831) * 0.699999988079071044921875f) * (mad(_842, -2.0f, 3.0f) * (_842 * _842))) + ((_836 * _836) * mad(_836, -2.0f, 3.0f)), 1.0f);
        float _884 = mad(_874, mad(_873, _866 * 0.62000000476837158203125f, mad(_749, _800, -_749)), mad(-_749, _800, _749));
        float _885 = mad(_874, mad(_873, _868, mad(_800, _750, -_750)), mad(-_800, _750, _750));
        float _886 = mad(_874, mad(_873, _868, mad(_800, _751, -_751)), mad(-_800, _751, _751));
        float _889 = mad(_663, _664 * (1.0f - _665), _665);
        float _891;
        _891 = 0.0f;
        float _892;
        uint _895;
        uint _894 = 0u;
        for (;;)
        {
            if (int(_894) >= 8)
            {
                break;
            }
            float4 _902 = t10.Load(_894);
            float _904 = _902.y;
            float _906 = _902.x - _657;
            _892 = mad(_889 * (_902.w * clamp((abs((_906 > 3.1415927410125732421875f) ? (_906 - 6.283185482025146484375f) : ((_906 < (-3.1415927410125732421875f)) ? (_906 + 6.283185482025146484375f) : _906)) + (_904 - 3.1415927410125732421875f)) / max(_904 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _891, _891);
            _895 = _894 + 1u;
            _891 = _892;
            _894 = _895;
            continue;
        }
        float _925 = clamp(_891 + _891, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _929 = mad(_925, 0.310000002384185791015625f - _884, _884);
        float _930 = mad(_925, 0.014999999664723873138427734375f - _885, _885);
        float _931 = mad(_925, 0.014999999664723873138427734375f - _886, _886);
        float4 _932 = t10.Load(12u);
        float _933 = _932.x;
        float _961;
        float _962;
        float _963;
        if (_933 != 0.0f)
        {
            float _940 = clamp(_860, 0.0f, 1.0f);
            float _950 = clamp((_662 + (_933 - 1.0f)) / max(mad(_933, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _954 = clamp(_933 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _957 = mad(_954, -2.0f, 3.0f) * (_954 * _954);
            _961 = mad((_940 * (_662 * 0.790000021457672119140625f)) * _950, _957, _929);
            _962 = mad(_957, _950 * (_940 * (_662 * 0.85000002384185791015625f)), _930);
            _963 = mad(_957, _950 * (_940 * (_662 * 0.930000007152557373046875f)), _931);
        }
        else
        {
            _961 = _929;
            _962 = _930;
            _963 = _931;
        }
        _964 = _961;
        _965 = _962;
        _966 = _963;
    }
    else
    {
        _964 = _601;
        _965 = _602;
        _966 = _603;
    }
    float _971 = 1.0f / max(1.0f - max(max(_965, _966), _964), 6.099999882280826568603515625e-05f);
    float _978 = min(-(_971 * _964), 0.0f);
    float _979 = min(-(_971 * _965), 0.0f);
    float _980 = min(-(_971 * _966), 0.0f);
    float2 _983 = float2(_415 - 0.5f, _416 - 0.5f);
    float _996 = clamp(-((1.0f / asfloat(cb1_m[5u].y)) * (sqrt(dp2_f32(_983, _983)) - asfloat(cb1_m[5u].x))), 0.0f, 1.0f);
    float _997 = mad(_996, -2.0f, 3.0f);
    float _998 = _996 * _996;
    float _999 = _997 * _998;
    float _1001 = mad(-_997, _998, 1.0f);
    float _1028 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
    float3 _1041 = float3(_420 ? (-_978) : mad(_978 + ((_1001 * asfloat(cb1_m[4u].x)) - (_978 * _999)), _1028, -_978), _420 ? (-_979) : mad(_1028, ((_1001 * asfloat(cb1_m[4u].y)) - (_999 * _979)) + _979, -_979), _420 ? (-_980) : mad(_1028, ((_1001 * asfloat(cb1_m[4u].z)) - (_999 * _980)) + _980, -_980));
    float _1042 = dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1041);
    float _1043 = dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1041);
    float _1044 = dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1041);
    bool _1048 = asfloat(cb1_m[8u].x) != 0.0f;
    float _1067;
    float _1068;
    float _1069;
    if (!_1048)
    {
        float _1054 = asfloat(cb1_m[9u].y);
        float _1060 = asfloat(cb1_m[9u].x);
        _1067 = clamp(mad(_1060, mad(_1044, _1054, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1068 = clamp(mad(_1060, mad(_1043, _1054, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1069 = clamp(mad(_1060, mad(_1042, _1054, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
    }
    else
    {
        _1067 = _1044;
        _1068 = _1043;
        _1069 = _1042;
    }
    float _1073 = mad(asfloat(cb1_m[8u].y), -0.0005000000237487256526947021484375f, 0.312709987163543701171875f);
    float _1081 = mad(asfloat(cb1_m[8u].z), 0.0005000000237487256526947021484375f, (_1073 * 2.86999988555908203125f) - ((_1073 * _1073) * 3.0f));
    float _1082 = _1081 - 0.2750950753688812255859375f;
    float _1083 = _1073 / _1082;
    float _1087 = ((1.0f - _1073) + (0.2750950753688812255859375f - _1081)) / _1082;
    float3 _1097 = float3(_1069, _1068, _1067);
    float3 _1104 = float3((0.94923698902130126953125f / mad(_1087, -0.1624000072479248046875f, mad(_1083, 0.732800006866455078125f, 0.4296000003814697265625f))) * dp3_f32(float3(0.390404999256134033203125f, 0.549941003322601318359375f, 0.008926319889724254608154296875f), _1097), dp3_f32(float3(0.070841602981090545654296875f, 0.963172018527984619140625f, 0.001357750035822391510009765625f), _1097) * (1.035419940948486328125f / mad(_1087, 0.006099999882280826568603515625f, mad(_1083, -0.703599989414215087890625f, 1.6974999904632568359375f))), dp3_f32(float3(0.02310819923877716064453125f, 0.1280210018157958984375f, 0.936245024204254150390625f), _1097) * (1.0872800350189208984375f / mad(_1087, 0.98339998722076416015625f, mad(_1083, 0.0030000000260770320892333984375f, 0.013600000180304050445556640625f))));
    float3 _1114 = float3(dp3_f32(float3(2.85846996307373046875f, -1.62879002094268798828125f, -0.0248910002410411834716796875f), _1104), dp3_f32(float3(-0.21018199622631072998046875f, 1.1582000255584716796875f, 0.0003242809907533228397369384765625f), _1104), dp3_f32(float3(-0.0418119989335536956787109375f, -0.118169002234935760498046875f, 1.0686700344085693359375f), _1104));
    float _1119 = dp3_f32(_1114, float3(asfloat(cb1_m[9u].w), asfloat(cb1_m[10u].x), asfloat(cb1_m[10u].y)));
    float _1128 = dp3_f32(_1114, float3(asfloat(cb1_m[10u].z), asfloat(cb1_m[10u].w), asfloat(cb1_m[11u].x)));
    float _1138 = dp3_f32(_1114, float3(asfloat(cb1_m[11u].y), asfloat(cb1_m[11u].z), asfloat(cb1_m[11u].w)));
    float _1140 = dp3_f32(float3(_1119, _1128, _1138), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1143 = asfloat(cb1_m[14u].w);
    float _1151 = clamp((_1140 - _1143) * (1.0f / (asfloat(cb1_m[15u].x) - _1143)), 0.0f, 1.0f);
    float _1155 = mad(-mad(_1151, -2.0f, 3.0f), _1151 * _1151, 1.0f);
    float _1158 = asfloat(cb1_m[15u].y);
    float _1166 = clamp((_1140 - _1158) * (1.0f / (asfloat(cb1_m[15u].z) - _1158)), 0.0f, 1.0f);
    float _1167 = mad(_1166, -2.0f, 3.0f);
    float _1168 = _1166 * _1166;
    float _1169 = _1167 * _1168;
    float _1172 = 1.0f - clamp(mad(_1167, _1168, _1155), 0.0f, 1.0f);
    float _1203;
    float _1204;
    float _1205;
    if (_1048)
    {
        _1203 = asfloat(cb1_m[16u].y) + 1.0f;
        _1204 = asfloat(cb1_m[15u].w) + 1.0f;
        _1205 = asfloat(cb1_m[16u].x) + 1.0f;
    }
    else
    {
        float _1190 = asfloat(cb1_m[15u].w);
        float _1194 = asfloat(cb1_m[16u].x);
        _1203 = mad(_1194, 0.5f, mad(_1190, 0.25f, 1.0f)) + asfloat(cb1_m[16u].y);
        _1204 = _1190 + 1.0f;
        _1205 = mad(_1190, 0.5f, _1194) + 1.0f;
    }
    float _1257 = mad(_1169 * (_1128 * asfloat(cb1_m[14u].y)), _1203, ((_1155 * (_1128 * asfloat(cb1_m[12u].y))) * _1204) + ((_1172 * (_1128 * asfloat(cb1_m[13u].y))) * _1205));
    float _1258 = mad(_1169 * (_1138 * asfloat(cb1_m[14u].z)), _1203, ((_1155 * (_1138 * asfloat(cb1_m[12u].z))) * _1204) + ((_1172 * (_1138 * asfloat(cb1_m[13u].z))) * _1205));
    float _1259 = mad(_1169 * (_1119 * asfloat(cb1_m[14u].x)), _1203, ((_1172 * (_1119 * asfloat(cb1_m[13u].x))) * _1205) + ((_1155 * (_1119 * asfloat(cb1_m[12u].x))) * _1204));
    float _1263 = float(_1257 >= _1258);
    float _1264 = mad(_1257 - _1258, _1263, _1258);
    float _1265 = mad(_1263, _1258 - _1257, _1257);
    float _1267 = mad(_1263, -1.0f, 0.666666686534881591796875f);
    float _1273 = float(_1264 <= _1259);
    float _1274 = mad(_1259 - _1264, _1273, _1264);
    float _1275 = mad(_1273, _1265 - _1265, _1265);
    float _1277 = mad(_1273, _1264 - _1259, _1259);
    float _1279 = _1274 - min(_1277, _1275);
    float _1285 = _1279 / (_1274 + 9.9999997473787516355514526367188e-05f);
    float _1290 = abs(((_1277 - _1275) / mad(_1279, 6.0f, 9.9999997473787516355514526367188e-05f)) + mad(_1273, mad(_1263, 1.0f, -1.0f) - _1267, _1267)) + asfloat(cb1_m[9u].z);
    float _1296 = (_1290 < 0.0f) ? (_1290 + 1.0f) : ((_1290 > 1.0f) ? (_1290 - 1.0f) : _1290);
    float _1318 = mad(_1285, clamp(abs(mad(frac(_1296 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1319 = mad(_1285, clamp(abs(mad(frac(_1296 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1320 = mad(_1285, clamp(abs(mad(frac(_1296 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1325 = dp3_f32(float3(_1274 * _1318, _1274 * _1319, _1274 * _1320), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1334 = asfloat(cb1_m[8u].w);
    float _1335 = mad(mad(_1274, _1318, -_1325), _1334, _1325);
    float _1336 = mad(_1334, mad(_1274, _1319, -_1325), _1325);
    float _1337 = mad(_1334, mad(_1274, _1320, -_1325), _1325);
    float _1358;
    float _1359;
    float _1360;
    if (_1048)
    {
        float _1345 = asfloat(cb1_m[9u].x);
        float _1354 = asfloat(cb1_m[9u].y);
        _1358 = _1354 * clamp(mad(_1345, _1337 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1359 = _1354 * clamp(mad(_1345, _1336 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1360 = clamp(mad(_1335 - 0.1800537109375f, _1345, 0.1800537109375f), 0.0f, 65504.0f) * _1354;
    }
    else
    {
        _1358 = _1337;
        _1359 = _1336;
        _1360 = _1335;
    }
    if (_604)
    {
#if 1
  float _1366 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1360 * 2.5f, 65504.0f) : _1360;
  float _1367 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1359 * 2.5f, 65504.0f) : _1359;
  float _1368 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1358 * 2.5f, 65504.0f) : _1358;
#endif
        float _1372 = max(max(_1366, _1367), _1368);
        float _1377 = (max(_1372, 9.9999997473787516355514526367188e-05f) - max(min(min(_1366, _1367), _1368), 9.9999997473787516355514526367188e-05f)) / max(_1372, 0.00999999977648258209228515625f);
        float _1388 = mad(sqrt(mad(_1366, _1366 - _1368, ((_1368 - _1367) * _1368) + ((_1367 - _1366) * _1367))), 1.75f, _1366 + (_1368 + _1367));
        float _1389 = _1377 - 0.4000000059604644775390625f;
        float _1394 = max(1.0f - abs(_1389 * 2.5f), 0.0f);
        float _1401 = mad(mad(clamp(mad(_1389, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1394, _1394, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1409 = ((_1388 <= 0.1599999964237213134765625f) ? _1401 : ((_1388 >= 0.4799999892711639404296875f) ? 0.0f : (_1401 * ((0.07999999821186065673828125f / (_1388 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1410 = _1366 * _1409;
        float _1411 = _1409 * _1367;
        float _1412 = _1409 * _1368;
        float _1417 = (_1411 - _1412) * 1.73205077648162841796875f;
        float _1419 = (_1410 * 2.0f) - _1411;
        float _1421 = mad(-_1409, _1368, _1419);
        float _1422 = abs(_1421);
        float _1423 = abs(_1417);
        float _1427 = min(_1422, _1423) * (1.0f / max(_1422, _1423));
        float _1428 = _1427 * _1427;
        float _1432 = mad(_1428, mad(_1428, mad(_1428, mad(_1428, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1442 = mad(_1427, _1432, (_1422 < _1423) ? mad(_1427 * _1432, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1421 < mad(_1409, _1368, -_1419)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1443 = min(_1417, _1421);
        float _1444 = max(_1417, _1421);
        float _1453 = ((_1410 == _1411) && (_1412 == _1411)) ? 0.0f : ((((_1443 < (-_1443)) && (_1444 >= (-_1444))) ? (-_1442) : _1442) * 57.295780181884765625f);
        float _1456 = (_1453 < 0.0f) ? (_1453 + 360.0f) : _1453;
        float _1466 = max(1.0f - abs(((_1456 < (-180.0f)) ? (_1456 + 360.0f) : ((_1456 > 180.0f) ? (_1456 - 360.0f) : _1456)) * 0.01481481455266475677490234375f), 0.0f);
        float _1469 = mad(_1466, -2.0f, 3.0f) * (_1466 * _1466);
        float3 _1480 = float3(clamp(_1410 + (((_1377 * (_1469 * _1469)) * mad(-_1366, _1409, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1411, 0.0f, 65504.0f), clamp(_1412, 0.0f, 65504.0f));
        float _1484 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1480), 0.0f, 65504.0f);
        float _1485 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1480), 0.0f, 65504.0f);
        float _1486 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1480), 0.0f, 65504.0f);

        float _1488 = dp3_f32(float3(_1484, _1485, _1486), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1495 = float3(mad(_1484 - _1488, 0.959999978542327880859375f, _1488), mad(_1485 - _1488, 0.959999978542327880859375f, _1488), mad(_1486 - _1488, 0.959999978542327880859375f, _1488));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_598] = float4(CustomACES(_1495), 1.f);
    return;
  }
#endif
        float3 _1499 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1495), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1495), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1495));
        float _1500 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1499);
        float _1501 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1499);
        float _1502 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1499);
        uint _1504;
        spvTextureSize(t9, 0u, _1504);
        bool _1505 = _1504 > 0u;
        uint _1506_dummy_parameter;
        _1507 _1508 = { spvTextureSize(t9, 0u, _1506_dummy_parameter), 1u };
        float _1511 = float(_1505 ? _1508._m0.x : 0u);
        float _1514 = float(_1505 ? _1508._m0.y : 0u);
        float _1517 = float(_1505 ? _1508._m0.z : 0u);
        float _1521 = float(_1501 >= _1502);
        float _1522 = mad(_1501 - _1502, _1521, _1502);
        float _1523 = mad(_1502 - _1501, _1521, _1501);
        float _1525 = mad(_1521, -1.0f, 0.666666686534881591796875f);
        float _1531 = float(_1500 >= _1522);
        float _1532 = mad(_1500 - _1522, _1531, _1522);
        float _1533 = mad(_1523 - _1523, _1531, _1523);
        float _1535 = mad(_1522 - _1500, _1531, _1500);
        float _1537 = _1532 - min(_1535, _1533);
        float4 _1561 = t9.SampleLevel(s7, float3(abs(mad(mad(_1521, 1.0f, -1.0f) - _1525, _1531, _1525) + ((_1535 - _1533) / mad(_1537, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1511 + _1511)), (1.0f / (_1514 + _1514)) + (_1537 / (_1532 + 9.9999997473787516355514526367188e-05f)), mad(_1532 * 3.0f, 1.0f / mad(_1532, 3.0f, 1.5f), 1.0f / (_1517 + _1517))), 0.0f);
        float _1562 = _1561.x;
        float _1563 = _1561.y;
        float _1564 = _1561.z;
        float3 _1592 = float3(mad(_1564, mad(_1563, clamp(abs(mad(frac(_1562 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1562 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1563, 1.0f), _1564, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1562 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1563, 1.0f), _1564, -3.5073844628641381859779357910156e-05f));
        float3 _1596 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1592), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1592), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1592));
        float3 _1600 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1596), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1596), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1596));
        float _1609 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1600) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1620 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1600) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1630 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1600) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_598] = float4(min(exp2(log2(mad(_1609, 18.8515625f, 0.8359375f) / mad(_1609, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1620, 18.8515625f, 0.8359375f) / mad(_1620, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1630, 18.8515625f, 0.8359375f) / mad(_1630, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

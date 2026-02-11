#include "../common.hlsl"
struct _392
{
    uint2 _m0;
    uint _m1;
};

struct _1533
{
    uint3 _m0;
    uint _m1;
};

static const float _56[1] = { 0.0f };
static const float4 _328[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _383 = a.x * b.x;
    return mad(a.y, b.y, _383);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _369 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _369));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _351 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _351)));
}

void comp_main()
{
    uint _391_dummy_parameter;
    _392 _393 = { spvImageSize(u0, _391_dummy_parameter), 1u };
    uint _408 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _412 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_408, 1u, 3u);
    uint _413 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _408, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _420 = (float(_412) + 0.5f) / float(_393._m0.x);
    float _421 = (float(_413) + 0.5f) / float(_393._m0.y);
    bool _425 = (_393._m0.x < _412) || (_393._m0.y < _413);
    bool _431 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _431) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _446 = float2(_420, _421);
    float _451 = mad(t4.SampleLevel(s3, _446, 0.0f).x, 2.0f, -1.0f);
    float _466;
    if (_451 > 0.0f)
    {
        _466 = min(sqrt(_451), t0.Load(8u).x);
    }
    else
    {
        _466 = max(_451, -t0.Load(7u).x);
    }
    bool _480 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _485 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float4 _489 = t1.SampleLevel(s0, _446, 0.0f);
    float _490 = _489.x;
    float _491 = _489.y;
    float _492 = _489.z;
    float _561;
    float _562;
    float _563;
    if (_485 || _480)
    {
        float4 _499 = t3.SampleLevel(s2, _446, 0.0f);
        float2 _510 = float2(_499.x * asfloat(cb1_m[2u].x), _499.y * asfloat(cb1_m[2u].y));
        float _524 = exp2(max(_480 ? clamp((sqrt(dp2_f32(_510, _510)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _485 ? clamp((abs(_466) - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
        float4 _528 = t2.SampleLevel(s1, _446, 0.0f);
        float _529 = _528.x;
        float _530 = _528.y;
        float _531 = _528.z;
        float _536 = asfloat(cb0_m[43u].w) * 20.0f;
        float _547 = mad(t7.SampleLevel(s5, float2(mad(_420, 30.0f, sin(_536)), mad(_421, 30.0f, cos(_536))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f);
        float _551 = sqrt(max(max(_529, max(_530, _531)), 1.0000000133514319600180897396058e-10f));
        float _552 = mad(_547, _551, _529);
        float _553 = mad(_547, _551, _530);
        float _554 = mad(_547, _551, _531);
        _561 = mad(_524, _492 - _554, _554);
        _562 = mad(_524, _491 - _553, _553);
        _563 = mad(_524, _490 - _552, _552);
    }
    else
    {
        _561 = _492;
        _562 = _491;
        _563 = _490;
    }
    float _569 = _431 ? g0[0u] : asfloat(cb1_m[2u].z);
    float4 _573 = t5.SampleLevel(s4, _446, 0.0f);
    float _574 = _573.x;
    float _583 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_574, _573.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _587 = mad(_569, _563, _574 / _583);
    float _588 = mad(_569, _562, _573.y / _583);
    float _589 = mad(_561, _569, _573.z / _583);
    float _593 = 1.0f / (max(_587, max(_589, _588)) + 1.0f);
    float _594 = _587 * _593;
    float _596 = _593 * _589;
    float3 _597 = float3(_594, _596, _593 * _588);
    float _598 = dp3_f32(_597, float3(0.25f, 0.25f, 0.5f));
    float _599 = dp3_f32(_597, float3(-0.25f, -0.25f, 0.5f));
    float _601 = dp2_f32(float2(_594, _596), float2(0.5f, -0.5f));
    uint2 _603 = uint2(_412, _413);
    u1[_603] = float4(_598, _601, _599, _598);
    float _605 = _598 - _599;
    float _606 = _601 + _605;
    float _607 = _598 + _599;
    float _608 = _605 - _601;
    bool _609 = !_425;
    float _990;
    float _991;
    float _992;
    if (_609)
    {
        float _613 = dp3_f32(float3(_606, _607, _608), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _623 = mad(-abs(_466), asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _627 = mad(_623, _606 - _613, _613);
        float _628 = mad(_623, _607 - _613, _613);
        float _629 = mad(_623, _608 - _613, _613);
        float _630 = _420 - 0.5f;
        float _631 = _421 - 0.5f;
        float _632 = _631 + _631;
        float _633 = _630 + _630;
        float _634 = abs(_633);
        float _635 = abs(_632);
        float _639 = min(_634, _635) * (1.0f / max(_634, _635));
        float _640 = _639 * _639;
        float _644 = mad(_640, mad(_640, mad(_640, mad(_640, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _653 = mad(_639, _644, (_634 < _635) ? mad(_639 * _644, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_633 < (-_633)) ? (-3.1415927410125732421875f) : 0.0f);
        float _654 = min(_633, _632);
        float _655 = max(_633, _632);
        float _662 = ((_654 < (-_654)) && (_655 >= (-_655))) ? (-_653) : _653;
        float4 _666 = t8.SampleLevel(s6, _446, 0.0f);
        float _667 = _666.x;
        float _668 = _666.y;
        float _669 = _666.z;
        float _670 = _666.w;
        float _677 = (_628 - _629) * 1.73205077648162841796875f;
        float _679 = mad(_627, 2.0f, -_628);
        float _680 = _679 - _629;
        float _681 = abs(_680);
        float _682 = abs(_677);
        float _686 = min(_681, _682) * (1.0f / max(_681, _682));
        float _687 = _686 * _686;
        float _691 = mad(_687, mad(_687, mad(_687, mad(_687, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _700 = mad(_686, _691, (_681 < _682) ? mad(_686 * _691, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_680 < (_629 - _679)) ? (-3.1415927410125732421875f) : 0.0f);
        float _701 = min(_677, _680);
        float _702 = max(_677, _680);
        float _711 = ((_629 == _628) && (_628 == _627)) ? 0.0f : ((((_701 < (-_701)) && (_702 >= (-_702))) ? (-_700) : _700) * 57.295780181884765625f);
        float _722 = mad(asfloat(cb1_m[19u].y), -360.0f, (_711 < 0.0f) ? (_711 + 360.0f) : _711);
        float _732 = clamp(1.0f - (abs((_722 < (-180.0f)) ? (_722 + 360.0f) : ((_722 > 180.0f) ? (_722 - 360.0f) : _722)) / (asfloat(cb1_m[19u].z) * 180.0f)), 0.0f, 1.0f);
        float _737 = dp3_f32(float3(_627, _628, _629), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _741 = (mad(_732, -2.0f, 3.0f) * (_732 * _732)) * asfloat(cb1_m[19u].w);
        float _753 = asfloat(cb1_m[18u].w);
        float _754 = mad(mad(_741, _627 - _737, _737) - _627, _753, _627);
        float _755 = mad(_753, mad(_741, _628 - _737, _737) - _628, _628);
        float _756 = mad(_753, mad(_741, _629 - _737, _737) - _629, _629);
        float _758;
        _758 = 0.0f;
        float _759;
        uint _762;
        uint _761 = 0u;
        for (;;)
        {
            if (_761 >= 8u)
            {
                break;
            }
            uint _773 = min((_761 & 3u), 4u);
            float _793 = mad(float(_761), 0.785398185253143310546875f, -_662);
            float _794 = _793 + 1.57079637050628662109375f;
            _759 = mad(_670 * (dp4_f32(t10.Load((_761 >> 2u) + 10u), float4(_328[_773].x, _328[_773].y, _328[_773].z, _328[_773].w)) * clamp((abs((_794 > 3.1415927410125732421875f) ? (_793 - 4.7123889923095703125f) : _794) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _758, _758);
            _762 = _761 + 1u;
            _758 = _759;
            _761 = _762;
            continue;
        }
        float _805 = clamp(_758, 0.0f, 1.0f);
        float _818 = asfloat(cb0_m[43u].w);
        float _824 = abs(t10.Load(8u).x);
        float2 _825 = float2(_630 * 1.40999996662139892578125f, _631 * 1.40999996662139892578125f);
        float _827 = sqrt(dp2_f32(_825, _825));
        float _828 = min(_827, 1.0f);
        float _829 = _828 * _828;
        float _834 = clamp(_827 - 0.5f, 0.0f, 1.0f);
        float _837 = (_828 * _829) + (mad(-_828, _829, 1.0f) * (_834 * _834));
        float _838 = mad(mad(mad(sin(_818 * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _824, -1.0f);
        float _840 = _668 + _838;
        float _842 = clamp((_669 + _838) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _848 = clamp(_840 + _840, 0.0f, 1.0f);
        float _866 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _872 = mad(sin(_668 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_866)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _874 = _872 * 0.02999999932944774627685546875f;
        float _875 = mad(_824, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _879 = mad(mad(-_837, _837, 1.0f), 1.0f - _875, _875);
        float _880 = min((exp2(log2(_837) * 0.699999988079071044921875f) * (mad(_848, -2.0f, 3.0f) * (_848 * _848))) + ((_842 * _842) * mad(_842, -2.0f, 3.0f)), 1.0f);
        float _890 = mad(_880, mad(_879, _872 * 0.62000000476837158203125f, mad(_754, _805, -_754)), mad(-_754, _805, _754));
        float _891 = mad(_880, mad(_879, _874, mad(_805, _755, -_755)), mad(-_805, _755, _755));
        float _892 = mad(_880, mad(_879, _874, mad(_805, _756, -_756)), mad(-_805, _756, _756));
        float _895 = mad(_668, _669 * (1.0f - _670), _670);
        float _897;
        _897 = 0.0f;
        float _898;
        uint _901;
        uint _900 = 0u;
        for (;;)
        {
            if (int(_900) >= 8)
            {
                break;
            }
            float4 _908 = t10.Load(_900);
            float _910 = _908.y;
            float _912 = _908.x - _662;
            _898 = mad(_895 * (_908.w * clamp((abs((_912 > 3.1415927410125732421875f) ? (_912 - 6.283185482025146484375f) : ((_912 < (-3.1415927410125732421875f)) ? (_912 + 6.283185482025146484375f) : _912)) + (_910 - 3.1415927410125732421875f)) / max(_910 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _897, _897);
            _901 = _900 + 1u;
            _897 = _898;
            _900 = _901;
            continue;
        }
        float _931 = clamp(_897 + _897, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _935 = mad(_931, 0.310000002384185791015625f - _890, _890);
        float _936 = mad(_931, 0.014999999664723873138427734375f - _891, _891);
        float _937 = mad(_931, 0.014999999664723873138427734375f - _892, _892);
        float4 _938 = t10.Load(12u);
        float _939 = _938.x;
        float _967;
        float _968;
        float _969;
        if (_939 != 0.0f)
        {
            float _946 = clamp(_866, 0.0f, 1.0f);
            float _956 = clamp((_667 + (_939 - 1.0f)) / max(mad(_939, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _960 = clamp(_939 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _963 = mad(_960, -2.0f, 3.0f) * (_960 * _960);
            _967 = mad(_963, _956 * (_946 * (_667 * 0.930000007152557373046875f)), _937);
            _968 = mad(_963, _956 * (_946 * (_667 * 0.85000002384185791015625f)), _936);
            _969 = mad((_946 * (_667 * 0.790000021457672119140625f)) * _956, _963, _935);
        }
        else
        {
            _967 = _937;
            _968 = _936;
            _969 = _935;
        }
        float _972 = asfloat(cb1_m[19u].x);
        bool _973 = _972 > 0.0f;
        bool _977 = frac((_421 * 420.0f) + (_818 * 0.20000000298023223876953125f)) >= 0.5f;
        float _978 = _977 ? 0.300000011920928955078125f : 0.0f;
        float _979 = _972 * _978;
        _990 = _973 ? mad(_979, 0.0f - _969, _969) : _969;
        _991 = _973 ? mad(_979, (_977 ? 0.100000001490116119384765625f : 0.0f) - _968, _968) : _968;
        _992 = _973 ? mad(_979, _978 - _967, _967) : _967;
    }
    else
    {
        _990 = _606;
        _991 = _607;
        _992 = _608;
    }
    float _997 = 1.0f / max(1.0f - max(max(_991, _992), _990), 6.099999882280826568603515625e-05f);
    float _1004 = min(-(_997 * _990), 0.0f);
    float _1005 = min(-(_997 * _991), 0.0f);
    float _1006 = min(-(_997 * _992), 0.0f);
    float2 _1009 = float2(_420 - 0.5f, _421 - 0.5f);
    float _1022 = clamp(-((sqrt(dp2_f32(_1009, _1009)) - asfloat(cb1_m[5u].x)) * (1.0f / asfloat(cb1_m[5u].y))), 0.0f, 1.0f);
    float _1023 = mad(_1022, -2.0f, 3.0f);
    float _1024 = _1022 * _1022;
    float _1025 = _1023 * _1024;
    float _1027 = mad(-_1023, _1024, 1.0f);
    float _1054 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
    float3 _1067 = float3(_425 ? (-_1004) : mad(_1004 + ((_1027 * asfloat(cb1_m[4u].x)) - (_1004 * _1025)), _1054, -_1004), _425 ? (-_1005) : mad(_1054, ((_1027 * asfloat(cb1_m[4u].y)) - (_1025 * _1005)) + _1005, -_1005), _425 ? (-_1006) : mad(_1054, ((_1027 * asfloat(cb1_m[4u].z)) - (_1025 * _1006)) + _1006, -_1006));
    float _1068 = dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1067);
    float _1069 = dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1067);
    float _1070 = dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1067);
    bool _1074 = asfloat(cb1_m[8u].x) != 0.0f;
    float _1093;
    float _1094;
    float _1095;
    if (!_1074)
    {
        float _1080 = asfloat(cb1_m[9u].y);
        float _1086 = asfloat(cb1_m[9u].x);
        _1093 = clamp(mad(_1086, mad(_1070, _1080, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1094 = clamp(mad(_1086, mad(_1069, _1080, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
        _1095 = clamp(mad(_1086, mad(_1068, _1080, -0.1800537109375f), 0.1800537109375f), 0.0f, 65504.0f);
    }
    else
    {
        _1093 = _1070;
        _1094 = _1069;
        _1095 = _1068;
    }
    float _1099 = mad(asfloat(cb1_m[8u].y), -0.0005000000237487256526947021484375f, 0.312709987163543701171875f);
    float _1107 = mad(asfloat(cb1_m[8u].z), 0.0005000000237487256526947021484375f, (_1099 * 2.86999988555908203125f) - ((_1099 * _1099) * 3.0f));
    float _1108 = _1107 - 0.2750950753688812255859375f;
    float _1109 = _1099 / _1108;
    float _1113 = ((1.0f - _1099) + (0.2750950753688812255859375f - _1107)) / _1108;
    float3 _1123 = float3(_1095, _1094, _1093);
    float3 _1130 = float3((0.94923698902130126953125f / mad(_1113, -0.1624000072479248046875f, mad(_1109, 0.732800006866455078125f, 0.4296000003814697265625f))) * dp3_f32(float3(0.390404999256134033203125f, 0.549941003322601318359375f, 0.008926319889724254608154296875f), _1123), dp3_f32(float3(0.070841602981090545654296875f, 0.963172018527984619140625f, 0.001357750035822391510009765625f), _1123) * (1.035419940948486328125f / mad(_1113, 0.006099999882280826568603515625f, mad(_1109, -0.703599989414215087890625f, 1.6974999904632568359375f))), dp3_f32(float3(0.02310819923877716064453125f, 0.1280210018157958984375f, 0.936245024204254150390625f), _1123) * (1.0872800350189208984375f / mad(_1113, 0.98339998722076416015625f, mad(_1109, 0.0030000000260770320892333984375f, 0.013600000180304050445556640625f))));
    float3 _1140 = float3(dp3_f32(float3(2.85846996307373046875f, -1.62879002094268798828125f, -0.0248910002410411834716796875f), _1130), dp3_f32(float3(-0.21018199622631072998046875f, 1.1582000255584716796875f, 0.0003242809907533228397369384765625f), _1130), dp3_f32(float3(-0.0418119989335536956787109375f, -0.118169002234935760498046875f, 1.0686700344085693359375f), _1130));
    float _1145 = dp3_f32(_1140, float3(asfloat(cb1_m[9u].w), asfloat(cb1_m[10u].x), asfloat(cb1_m[10u].y)));
    float _1154 = dp3_f32(_1140, float3(asfloat(cb1_m[10u].z), asfloat(cb1_m[10u].w), asfloat(cb1_m[11u].x)));
    float _1164 = dp3_f32(_1140, float3(asfloat(cb1_m[11u].y), asfloat(cb1_m[11u].z), asfloat(cb1_m[11u].w)));
    float _1166 = dp3_f32(float3(_1145, _1154, _1164), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1169 = asfloat(cb1_m[14u].w);
    float _1177 = clamp((_1166 - _1169) * (1.0f / (asfloat(cb1_m[15u].x) - _1169)), 0.0f, 1.0f);
    float _1181 = mad(-mad(_1177, -2.0f, 3.0f), _1177 * _1177, 1.0f);
    float _1184 = asfloat(cb1_m[15u].y);
    float _1192 = clamp((_1166 - _1184) * (1.0f / (asfloat(cb1_m[15u].z) - _1184)), 0.0f, 1.0f);
    float _1193 = mad(_1192, -2.0f, 3.0f);
    float _1194 = _1192 * _1192;
    float _1195 = _1193 * _1194;
    float _1198 = 1.0f - clamp(mad(_1193, _1194, _1181), 0.0f, 1.0f);
    float _1229;
    float _1230;
    float _1231;
    if (_1074)
    {
        _1229 = asfloat(cb1_m[16u].y) + 1.0f;
        _1230 = asfloat(cb1_m[15u].w) + 1.0f;
        _1231 = asfloat(cb1_m[16u].x) + 1.0f;
    }
    else
    {
        float _1216 = asfloat(cb1_m[15u].w);
        float _1220 = asfloat(cb1_m[16u].x);
        _1229 = mad(_1220, 0.5f, mad(_1216, 0.25f, 1.0f)) + asfloat(cb1_m[16u].y);
        _1230 = _1216 + 1.0f;
        _1231 = mad(_1216, 0.5f, _1220) + 1.0f;
    }
    float _1283 = mad(_1195 * (_1154 * asfloat(cb1_m[14u].y)), _1229, ((_1181 * (_1154 * asfloat(cb1_m[12u].y))) * _1230) + ((_1198 * (_1154 * asfloat(cb1_m[13u].y))) * _1231));
    float _1284 = mad(_1195 * (_1164 * asfloat(cb1_m[14u].z)), _1229, ((_1181 * (_1164 * asfloat(cb1_m[12u].z))) * _1230) + ((_1198 * (_1164 * asfloat(cb1_m[13u].z))) * _1231));
    float _1285 = mad(_1195 * (_1145 * asfloat(cb1_m[14u].x)), _1229, ((_1198 * (_1145 * asfloat(cb1_m[13u].x))) * _1231) + ((_1181 * (_1145 * asfloat(cb1_m[12u].x))) * _1230));
    float _1289 = float(_1283 >= _1284);
    float _1290 = mad(_1283 - _1284, _1289, _1284);
    float _1291 = mad(_1289, _1284 - _1283, _1283);
    float _1293 = mad(_1289, -1.0f, 0.666666686534881591796875f);
    float _1299 = float(_1290 <= _1285);
    float _1300 = mad(_1285 - _1290, _1299, _1290);
    float _1301 = mad(_1299, _1291 - _1291, _1291);
    float _1303 = mad(_1299, _1290 - _1285, _1285);
    float _1305 = _1300 - min(_1303, _1301);
    float _1311 = _1305 / (_1300 + 9.9999997473787516355514526367188e-05f);
    float _1316 = abs(((_1303 - _1301) / mad(_1305, 6.0f, 9.9999997473787516355514526367188e-05f)) + mad(_1299, mad(_1289, 1.0f, -1.0f) - _1293, _1293)) + asfloat(cb1_m[9u].z);
    float _1322 = (_1316 < 0.0f) ? (_1316 + 1.0f) : ((_1316 > 1.0f) ? (_1316 - 1.0f) : _1316);
    float _1344 = mad(_1311, clamp(abs(mad(frac(_1322 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1345 = mad(_1311, clamp(abs(mad(frac(_1322 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1346 = mad(_1311, clamp(abs(mad(frac(_1322 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
    float _1351 = dp3_f32(float3(_1300 * _1344, _1300 * _1345, _1300 * _1346), float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f));
    float _1360 = asfloat(cb1_m[8u].w);
    float _1361 = mad(mad(_1300, _1344, -_1351), _1360, _1351);
    float _1362 = mad(_1360, mad(_1300, _1345, -_1351), _1351);
    float _1363 = mad(_1360, mad(_1300, _1346, -_1351), _1351);
    float _1384;
    float _1385;
    float _1386;
    if (_1074)
    {
        float _1371 = asfloat(cb1_m[9u].x);
        float _1380 = asfloat(cb1_m[9u].y);
        _1384 = _1380 * clamp(mad(_1371, _1363 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1385 = _1380 * clamp(mad(_1371, _1362 - 0.1800537109375f, 0.1800537109375f), 0.0f, 65504.0f);
        _1386 = clamp(mad(_1361 - 0.1800537109375f, _1371, 0.1800537109375f), 0.0f, 65504.0f) * _1380;
    }
    else
    {
        _1384 = _1363;
        _1385 = _1362;
        _1386 = _1361;
    }
    if (_609)
    {
#if 1
  float _1392 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1386 * 2.5f, 65504.0f) : _1386;
  float _1393 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1385 * 2.5f, 65504.0f) : _1385;
  float _1394 = (RENODX_TONE_MAP_TYPE == 0) ? min(_1384 * 2.5f, 65504.0f) : _1384;
#endif
        float _1398 = max(max(_1392, _1393), _1394);
        float _1403 = (max(_1398, 9.9999997473787516355514526367188e-05f) - max(min(min(_1392, _1393), _1394), 9.9999997473787516355514526367188e-05f)) / max(_1398, 0.00999999977648258209228515625f);
        float _1414 = mad(sqrt(mad(_1392, _1392 - _1394, ((_1394 - _1393) * _1394) + ((_1393 - _1392) * _1393))), 1.75f, _1392 + (_1394 + _1393));
        float _1415 = _1403 - 0.4000000059604644775390625f;
        float _1420 = max(1.0f - abs(_1415 * 2.5f), 0.0f);
        float _1427 = mad(mad(clamp(mad(_1415, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1420, _1420, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1435 = ((_1414 <= 0.1599999964237213134765625f) ? _1427 : ((_1414 >= 0.4799999892711639404296875f) ? 0.0f : (_1427 * ((0.07999999821186065673828125f / (_1414 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1436 = _1392 * _1435;
        float _1437 = _1435 * _1393;
        float _1438 = _1435 * _1394;
        float _1443 = (_1437 - _1438) * 1.73205077648162841796875f;
        float _1445 = (_1436 * 2.0f) - _1437;
        float _1447 = mad(-_1435, _1394, _1445);
        float _1448 = abs(_1447);
        float _1449 = abs(_1443);
        float _1453 = min(_1448, _1449) * (1.0f / max(_1448, _1449));
        float _1454 = _1453 * _1453;
        float _1458 = mad(_1454, mad(_1454, mad(_1454, mad(_1454, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1468 = mad(_1453, _1458, (_1448 < _1449) ? mad(_1453 * _1458, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1447 < mad(_1435, _1394, -_1445)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1469 = min(_1443, _1447);
        float _1470 = max(_1443, _1447);
        float _1479 = ((_1436 == _1437) && (_1438 == _1437)) ? 0.0f : ((((_1469 < (-_1469)) && (_1470 >= (-_1470))) ? (-_1468) : _1468) * 57.295780181884765625f);
        float _1482 = (_1479 < 0.0f) ? (_1479 + 360.0f) : _1479;
        float _1492 = max(1.0f - abs(((_1482 < (-180.0f)) ? (_1482 + 360.0f) : ((_1482 > 180.0f) ? (_1482 - 360.0f) : _1482)) * 0.01481481455266475677490234375f), 0.0f);
        float _1495 = mad(_1492, -2.0f, 3.0f) * (_1492 * _1492);
        float3 _1506 = float3(clamp(_1436 + (((_1403 * (_1495 * _1495)) * mad(-_1392, _1435, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1437, 0.0f, 65504.0f), clamp(_1438, 0.0f, 65504.0f));
        float _1510 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1506), 0.0f, 65504.0f);
        float _1511 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1506), 0.0f, 65504.0f);
        float _1512 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1506), 0.0f, 65504.0f);

        float _1514 = dp3_f32(float3(_1510, _1511, _1512), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1521 = float3(mad(_1510 - _1514, 0.959999978542327880859375f, _1514), mad(_1511 - _1514, 0.959999978542327880859375f, _1514), mad(_1512 - _1514, 0.959999978542327880859375f, _1514));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_603] = float4(CustomACES(_1521), 1.f);
    return;
  }
#endif
        float3 _1525 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1521), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1521), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1521));
        float _1526 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1525);
        float _1527 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1525);
        float _1528 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1525);
        uint _1530;
        spvTextureSize(t9, 0u, _1530);
        bool _1531 = _1530 > 0u;
        uint _1532_dummy_parameter;
        _1533 _1534 = { spvTextureSize(t9, 0u, _1532_dummy_parameter), 1u };
        float _1537 = float(_1531 ? _1534._m0.x : 0u);
        float _1540 = float(_1531 ? _1534._m0.y : 0u);
        float _1543 = float(_1531 ? _1534._m0.z : 0u);
        float _1547 = float(_1527 >= _1528);
        float _1548 = mad(_1527 - _1528, _1547, _1528);
        float _1549 = mad(_1528 - _1527, _1547, _1527);
        float _1551 = mad(_1547, -1.0f, 0.666666686534881591796875f);
        float _1557 = float(_1526 >= _1548);
        float _1558 = mad(_1526 - _1548, _1557, _1548);
        float _1559 = mad(_1549 - _1549, _1557, _1549);
        float _1561 = mad(_1548 - _1526, _1557, _1526);
        float _1563 = _1558 - min(_1561, _1559);
        float4 _1587 = t9.SampleLevel(s7, float3(abs(mad(mad(_1547, 1.0f, -1.0f) - _1551, _1557, _1551) + ((_1561 - _1559) / mad(_1563, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1537 + _1537)), (1.0f / (_1540 + _1540)) + (_1563 / (_1558 + 9.9999997473787516355514526367188e-05f)), mad(_1558 * 3.0f, 1.0f / mad(_1558, 3.0f, 1.5f), 1.0f / (_1543 + _1543))), 0.0f);
        float _1588 = _1587.x;
        float _1589 = _1587.y;
        float _1590 = _1587.z;
        float3 _1618 = float3(mad(_1590, mad(_1589, clamp(abs(mad(frac(_1588 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1588 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1589, 1.0f), _1590, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1588 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1589, 1.0f), _1590, -3.5073844628641381859779357910156e-05f));
        float3 _1622 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1618), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1618), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1618));
        float3 _1626 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1622), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1622), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1622));
        float _1635 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1626) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1646 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1626) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1656 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1626) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_603] = float4(min(exp2(log2(mad(_1635, 18.8515625f, 0.8359375f) / mad(_1635, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1646, 18.8515625f, 0.8359375f) / mad(_1646, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1656, 18.8515625f, 0.8359375f) / mad(_1656, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

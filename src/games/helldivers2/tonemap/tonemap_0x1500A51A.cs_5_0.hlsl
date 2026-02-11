#include "../common.hlsl"
struct _331
{
    uint2 _m0;
    uint _m1;
};

struct _1243
{
    uint3 _m0;
    uint _m1;
};

static const float _55[1] = { 0.0f };
static const float4 _271[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _322 = a.x * b.x;
    return mad(a.y, b.y, _322);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _308 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _308));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _290 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _290)));
}

void comp_main()
{
    uint _330_dummy_parameter;
    _331 _332 = { spvImageSize(u0, _330_dummy_parameter), 1u };
    uint _347 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _351 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_347, 1u, 3u);
    uint _352 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _347, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _359 = (float(_351) + 0.5f) / float(_332._m0.x);
    float _360 = (float(_352) + 0.5f) / float(_332._m0.y);
    bool _370 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _370) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _385 = float2(_359, _360);
    float _390 = mad(t4.SampleLevel(s3, _385, 0.0f).x, 2.0f, -1.0f);
    float _405;
    if (_390 > 0.0f)
    {
        _405 = min(sqrt(_390), t0.Load(8u).x);
    }
    else
    {
        _405 = max(_390, -t0.Load(7u).x);
    }
    float4 _409 = t3.SampleLevel(s2, _385, 0.0f);
    float2 _421 = float2(_409.x * asfloat(cb1_m[2u].x), _409.y * asfloat(cb1_m[2u].y));
    bool _436 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _441 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float _445 = abs(_405);
    float _453 = exp2(max(_436 ? clamp((sqrt(dp2_f32(_421, _421)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _441 ? clamp((_445 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _454 = _359 - 0.5f;
    float _455 = _360 - 0.5f;
    float2 _456 = float2(_454, _455);
    float _457 = dp2_f32(_456, _456);
    float _460 = asfloat(cb1_m[18u].x);
    float _461 = mad(_457, _460, 1.0f);
    float _467 = asfloat(cb1_m[18u].z);
    float _474 = asfloat(cb1_m[18u].y);
    float _486 = mad(exp2(log2(clamp(_460, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(asfloat(cb1_m[18u].y), -0.089999973773956298828125f, 1.0f);
    float _487 = (_461 * mad(_474, mad(_467, -0.001999996602535247802734375f, 0.092000000178813934326171875f), 1.0f)) * _486;
    float _488 = _486 * (_461 * mad(_474, mad(_467, 0.04500000178813934326171875f, 0.046999998390674591064453125f), 1.0f));
    float _489 = _486 * (_461 * mad(_474, mad(_467, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _490 = mad(_454, _487, 0.5f);
    float _491 = mad(_487, _455, 0.5f);
    float _492 = mad(_454, _488, 0.5f);
    float _493 = mad(_455, _488, 0.5f);
    float2 _496 = float2(_490, _491);
    float4 _498 = t1.SampleLevel(s0, _496, 0.0f);
    float _499 = _498.x;
    bool _500 = _441 || _436;
    float _533;
    if (_500)
    {
        float4 _506 = t2.SampleLevel(s1, _496, 0.0f);
        float _507 = _506.x;
        float _514 = asfloat(cb0_m[43u].w) * 20.0f;
        float _530 = mad(mad(t7.SampleLevel(s5, float2(mad(_490, 30.0f, sin(_514)), mad(_491, 30.0f, cos(_514))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_507, max(_506.y, _506.z)), 1.0000000133514319600180897396058e-10f)), _507);
        _533 = mad(_453, _499 - _530, _530);
    }
    else
    {
        _533 = _499;
    }
    float2 _534 = float2(_492, _493);
    float4 _536 = t1.SampleLevel(s0, _534, 0.0f);
    float _537 = _536.y;
    float _570;
    if (_500)
    {
        float4 _543 = t2.SampleLevel(s1, _534, 0.0f);
        float _545 = _543.y;
        float _551 = asfloat(cb0_m[43u].w) * 20.0f;
        float _567 = mad(mad(t7.SampleLevel(s5, float2(mad(_492, 30.0f, sin(_551)), mad(_493, 30.0f, cos(_551))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_543.x, max(_545, _543.z)), 1.0000000133514319600180897396058e-10f)), _545);
        _570 = mad(_453, _537 - _567, _567);
    }
    else
    {
        _570 = _537;
    }
    float _571 = mad(_454, _489, 0.5f);
    float _572 = mad(_455, _489, 0.5f);
    float2 _573 = float2(_571, _572);
    float4 _575 = t1.SampleLevel(s0, _573, 0.0f);
    float _576 = _575.z;
    float _609;
    if (_500)
    {
        float4 _582 = t2.SampleLevel(s1, _573, 0.0f);
        float _585 = _582.z;
        float _590 = asfloat(cb0_m[43u].w) * 20.0f;
        float _606 = mad(mad(t7.SampleLevel(s5, float2(mad(_571, 30.0f, sin(_590)), mad(_572, 30.0f, cos(_590))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_582.x, max(_582.y, _585)), 1.0000000133514319600180897396058e-10f)), _585);
        _609 = mad(_453, _576 - _606, _606);
    }
    else
    {
        _609 = _576;
    }
    if (!((_332._m0.x < _351) || (_332._m0.y < _352)))
    {
        float _618 = _370 ? g0[0u] : asfloat(cb1_m[2u].z);
        float4 _622 = t5.SampleLevel(s4, _385, 0.0f);
        float _623 = _622.x;
        float _632 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_623, _622.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
        float _636 = mad(_533, _618, _623 / _632);
        float _637 = mad(_570, _618, _622.y / _632);
        float _638 = mad(_609, _618, _622.z / _632);
        float _642 = 1.0f / (max(_636, max(_638, _637)) + 1.0f);
        float _643 = _636 * _642;
        float _645 = _638 * _642;
        float3 _646 = float3(_643, _645, _637 * _642);
        float _647 = dp3_f32(_646, float3(0.25f, 0.25f, 0.5f));
        float _648 = dp3_f32(_646, float3(-0.25f, -0.25f, 0.5f));
        float _650 = dp2_f32(float2(_643, _645), float2(0.5f, -0.5f));
        float _651 = _647 - _648;
        float _652 = _650 + _651;
        float _653 = _647 + _648;
        float _654 = _651 - _650;
        float _656 = dp3_f32(float3(_652, _653, _654), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _665 = mad(-_445, asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _669 = mad(_665, _652 - _656, _656);
        float _670 = mad(_653 - _656, _665, _656);
        float _671 = mad(_654 - _656, _665, _656);
        float _672 = _455 + _455;
        float _673 = _454 + _454;
        float _674 = abs(_673);
        float _675 = abs(_672);
        float _679 = min(_674, _675) * (1.0f / max(_674, _675));
        float _680 = _679 * _679;
        float _684 = mad(_680, mad(_680, mad(_680, mad(_680, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _693 = mad(_679, _684, (_674 < _675) ? mad(_679 * _684, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_673 < (-_673)) ? (-3.1415927410125732421875f) : 0.0f);
        float _694 = min(_673, _672);
        float _695 = max(_673, _672);
        float _702 = ((_694 < (-_694)) && (_695 >= (-_695))) ? (-_693) : _693;
        float4 _706 = t8.SampleLevel(s6, _385, 0.0f);
        float _707 = _706.x;
        float _708 = _706.y;
        float _709 = _706.z;
        float _710 = _706.w;
        float _715 = (_670 - _671) * 1.73205077648162841796875f;
        float _717 = mad(_669, 2.0f, -_670);
        float _718 = _717 - _671;
        float _719 = abs(_715);
        float _720 = abs(_718);
        float _724 = min(_719, _720) * (1.0f / max(_719, _720));
        float _725 = _724 * _724;
        float _729 = mad(_725, mad(_725, mad(_725, mad(_725, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _738 = mad(_724, _729, (_719 > _720) ? mad(_724 * _729, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_718 < (_671 - _717)) ? (-3.1415927410125732421875f) : 0.0f);
        float _739 = min(_715, _718);
        float _740 = max(_715, _718);
        float _749 = ((_671 == _670) && (_670 == _669)) ? 0.0f : ((((_739 < (-_739)) && (_740 >= (-_740))) ? (-_738) : _738) * 57.295780181884765625f);
        float _760 = mad(asfloat(cb1_m[19u].y), -360.0f, (_749 < 0.0f) ? (_749 + 360.0f) : _749);
        float _770 = clamp(1.0f - (abs((_760 < (-180.0f)) ? (_760 + 360.0f) : ((_760 > 180.0f) ? (_760 - 360.0f) : _760)) / (asfloat(cb1_m[19u].z) * 180.0f)), 0.0f, 1.0f);
        float _775 = dp3_f32(float3(_669, _670, _671), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _779 = (mad(_770, -2.0f, 3.0f) * (_770 * _770)) * asfloat(cb1_m[19u].w);
        float _791 = asfloat(cb1_m[18u].w);
        float _792 = mad(mad(_779, _669 - _775, _775) - _669, _791, _669);
        float _793 = mad(_791, mad(_779, _670 - _775, _775) - _670, _670);
        float _794 = mad(_791, mad(_779, _671 - _775, _775) - _671, _671);
        float _796;
        _796 = 0.0f;
        float _797;
        uint _800;
        uint _799 = 0u;
        for (;;)
        {
            if (_799 >= 8u)
            {
                break;
            }
            uint _811 = min((_799 & 3u), 4u);
            float _831 = mad(float(_799), 0.785398185253143310546875f, -_702);
            float _832 = _831 + 1.57079637050628662109375f;
            _797 = mad(_710 * (dp4_f32(t10.Load((_799 >> 2u) + 10u), float4(_271[_811].x, _271[_811].y, _271[_811].z, _271[_811].w)) * clamp((abs((_832 > 3.1415927410125732421875f) ? (_831 - 4.7123889923095703125f) : _832) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _796, _796);
            _800 = _799 + 1u;
            _796 = _797;
            _799 = _800;
            continue;
        }
        float _843 = clamp(_796, 0.0f, 1.0f);
        float _856 = asfloat(cb0_m[43u].w);
        float _862 = abs(t10.Load(8u).x);
        float2 _865 = float2(_454 * 1.40999996662139892578125f, _455 * 1.40999996662139892578125f);
        float _867 = sqrt(dp2_f32(_865, _865));
        float _868 = min(_867, 1.0f);
        float _869 = _868 * _868;
        float _874 = clamp(_867 - 0.5f, 0.0f, 1.0f);
        float _877 = (_868 * _869) + (mad(-_868, _869, 1.0f) * (_874 * _874));
        float _878 = mad(mad(mad(sin(_856 * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _862, -1.0f);
        float _880 = _708 + _878;
        float _882 = clamp((_709 + _878) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _889 = clamp(_880 + _880, 0.0f, 1.0f);
        float _899 = mad(sin(_708 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f);
        float _906 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _911 = mad(exp2(log2(abs(_906)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _915 = _899 * (_911 * 0.02999999932944774627685546875f);
        float _916 = mad(_862, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _920 = mad(mad(-_877, _877, 1.0f), 1.0f - _916, _916);
        float _921 = min((exp2(log2(_877) * 0.699999988079071044921875f) * (mad(_889, -2.0f, 3.0f) * (_889 * _889))) + (mad(_882, -2.0f, 3.0f) * (_882 * _882)), 1.0f);
        float _931 = mad(_921, mad((_899 * _911) * 0.62000000476837158203125f, _920, mad(_792, _843, -_792)), mad(-_792, _843, _792));
        float _932 = mad(_921, mad(_920, _915, mad(_843, _793, -_793)), mad(-_843, _793, _793));
        float _933 = mad(_921, mad(_920, _915, mad(_843, _794, -_794)), mad(-_843, _794, _794));
        float _936 = mad(_708, _709 * (1.0f - _710), _710);
        float _938;
        _938 = 0.0f;
        float _939;
        uint _942;
        uint _941 = 0u;
        for (;;)
        {
            if (int(_941) >= 8)
            {
                break;
            }
            float4 _949 = t10.Load(_941);
            float _951 = _949.y;
            float _953 = _949.x - _702;
            _939 = mad(_936 * (_949.w * clamp(((_951 - 3.1415927410125732421875f) + abs((_953 > 3.1415927410125732421875f) ? (_953 - 6.283185482025146484375f) : ((_953 < (-3.1415927410125732421875f)) ? (_953 + 6.283185482025146484375f) : _953))) / max(_951 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _938, _938);
            _942 = _941 + 1u;
            _938 = _939;
            _941 = _942;
            continue;
        }
        float _972 = clamp(_938 + _938, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _976 = mad(_972, 0.310000002384185791015625f - _931, _931);
        float _977 = mad(_972, 0.014999999664723873138427734375f - _932, _932);
        float _978 = mad(_972, 0.014999999664723873138427734375f - _933, _933);
        float4 _979 = t10.Load(12u);
        float _980 = _979.x;
        float _1008;
        float _1009;
        float _1010;
        if (_980 != 0.0f)
        {
            float _987 = clamp(_906, 0.0f, 1.0f);
            float _997 = clamp((_707 + (_980 - 1.0f)) / max(mad(_980, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _1001 = clamp(_980 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _1004 = mad(_1001, -2.0f, 3.0f) * (_1001 * _1001);
            _1008 = mad(_1004, _997 * (_987 * (_707 * 0.930000007152557373046875f)), _978);
            _1009 = mad(_1004, _997 * (_987 * (_707 * 0.85000002384185791015625f)), _977);
            _1010 = mad((_987 * (_707 * 0.790000021457672119140625f)) * _997, _1004, _976);
        }
        else
        {
            _1008 = _978;
            _1009 = _977;
            _1010 = _976;
        }
        float _1013 = asfloat(cb1_m[19u].x);
        bool _1014 = _1013 > 0.0f;
        bool _1018 = frac((_360 * 420.0f) + (_856 * 0.20000000298023223876953125f)) >= 0.5f;
        float _1019 = _1018 ? 0.300000011920928955078125f : 0.0f;
        float _1020 = _1013 * _1019;
        float _1028 = _1014 ? mad(_1020, 0.0f - _1010, _1010) : _1010;
        float _1029 = _1014 ? mad(_1020, (_1018 ? 0.100000001490116119384765625f : 0.0f) - _1009, _1009) : _1009;
        float _1030 = _1014 ? mad(_1020, _1019 - _1008, _1008) : _1008;
        float _1035 = 1.0f / max(1.0f - max(max(_1030, _1029), _1028), 6.099999882280826568603515625e-05f);
        float _1042 = min(-(_1035 * _1028), 0.0f);
        float _1043 = min(-(_1035 * _1029), 0.0f);
        float _1044 = min(-(_1035 * _1030), 0.0f);
        float _1056 = clamp(-((sqrt(_457) - asfloat(cb1_m[5u].x)) * (1.0f / asfloat(cb1_m[5u].y))), 0.0f, 1.0f);
        float _1057 = mad(_1056, -2.0f, 3.0f);
        float _1058 = _1056 * _1056;
        float _1059 = _1057 * _1058;
        float _1061 = mad(-_1057, _1058, 1.0f);
        float _1085 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
        float3 _1095 = float3(mad(_1042 + ((_1061 * asfloat(cb1_m[4u].x)) - (_1042 * _1059)), _1085, -_1042), mad(_1085, ((_1061 * asfloat(cb1_m[4u].y)) - (_1059 * _1043)) + _1043, -_1043), mad(_1085, ((_1061 * asfloat(cb1_m[4u].z)) - (_1059 * _1044)) + _1044, -_1044));
#if 1
  float _1102 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1095) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1095), 65504.0f);
  float _1103 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1095) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1095), 65504.0f);
  float _1104 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1095) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1095), 65504.0f);
#endif
        float _1108 = max(max(_1103, _1102), _1104);
        float _1113 = (max(_1108, 9.9999997473787516355514526367188e-05f) - max(min(min(_1103, _1102), _1104), 9.9999997473787516355514526367188e-05f)) / max(_1108, 0.00999999977648258209228515625f);
        float _1124 = mad(sqrt(mad(_1102 - _1104, _1102, ((_1104 - _1103) * _1104) + ((_1103 - _1102) * _1103))), 1.75f, (_1104 + _1103) + _1102);
        float _1125 = _1113 - 0.4000000059604644775390625f;
        float _1130 = max(1.0f - abs(_1125 * 2.5f), 0.0f);
        float _1137 = mad(mad(clamp(mad(_1125, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1130, _1130, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1145 = ((_1124 <= 0.1599999964237213134765625f) ? _1137 : ((_1124 >= 0.4799999892711639404296875f) ? 0.0f : (_1137 * ((0.07999999821186065673828125f / (_1124 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1146 = _1145 * _1102;
        float _1147 = _1145 * _1103;
        float _1148 = _1145 * _1104;
        float _1153 = (_1147 - _1148) * 1.73205077648162841796875f;
        float _1155 = (_1146 * 2.0f) - _1147;
        float _1157 = mad(-_1145, _1104, _1155);
        float _1158 = abs(_1157);
        float _1159 = abs(_1153);
        float _1163 = min(_1158, _1159) * (1.0f / max(_1158, _1159));
        float _1164 = _1163 * _1163;
        float _1168 = mad(_1164, mad(_1164, mad(_1164, mad(_1164, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1178 = mad(_1163, _1168, (_1158 < _1159) ? mad(_1163 * _1168, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1157 < mad(_1145, _1104, -_1155)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1179 = min(_1153, _1157);
        float _1180 = max(_1153, _1157);
        float _1189 = ((_1146 == _1147) && (_1148 == _1147)) ? 0.0f : ((((_1179 < (-_1179)) && (_1180 >= (-_1180))) ? (-_1178) : _1178) * 57.295780181884765625f);
        float _1192 = (_1189 < 0.0f) ? (_1189 + 360.0f) : _1189;
        float _1202 = max(1.0f - abs(((_1192 < (-180.0f)) ? (_1192 + 360.0f) : ((_1192 > 180.0f) ? (_1192 - 360.0f) : _1192)) * 0.01481481455266475677490234375f), 0.0f);
        float _1205 = mad(_1202, -2.0f, 3.0f) * (_1202 * _1202);
        float3 _1216 = float3(clamp(_1146 + (((_1113 * (_1205 * _1205)) * mad(-_1145, _1102, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1147, 0.0f, 65504.0f), clamp(_1148, 0.0f, 65504.0f));
        float _1220 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1216), 0.0f, 65504.0f);
        float _1221 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1216), 0.0f, 65504.0f);
        float _1222 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1216), 0.0f, 65504.0f);

        float _1224 = dp3_f32(float3(_1220, _1221, _1222), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1231 = float3(mad(_1220 - _1224, 0.959999978542327880859375f, _1224), mad(_1221 - _1224, 0.959999978542327880859375f, _1224), mad(_1222 - _1224, 0.959999978542327880859375f, _1224));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[uint2(_351, _352)] = float4(CustomACES(_1231), 1.f);
    return;
  }
#endif
        float3 _1235 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1231), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1231), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1231));
        float _1236 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1235);
        float _1237 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1235);
        float _1238 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1235);
        uint _1240;
        spvTextureSize(t9, 0u, _1240);
        bool _1241 = _1240 > 0u;
        uint _1242_dummy_parameter;
        _1243 _1244 = { spvTextureSize(t9, 0u, _1242_dummy_parameter), 1u };
        float _1247 = float(_1241 ? _1244._m0.x : 0u);
        float _1250 = float(_1241 ? _1244._m0.y : 0u);
        float _1253 = float(_1241 ? _1244._m0.z : 0u);
        float _1257 = float(_1237 >= _1238);
        float _1258 = mad(_1237 - _1238, _1257, _1238);
        float _1259 = mad(_1257, _1238 - _1237, _1237);
        float _1261 = mad(_1257, -1.0f, 0.666666686534881591796875f);
        float _1267 = float(_1236 >= _1258);
        float _1268 = mad(_1236 - _1258, _1267, _1258);
        float _1269 = mad(_1259 - _1259, _1267, _1259);
        float _1271 = mad(_1258 - _1236, _1267, _1236);
        float _1273 = _1268 - min(_1271, _1269);
        float4 _1297 = t9.SampleLevel(s7, float3(abs(mad(mad(_1257, 1.0f, -1.0f) - _1261, _1267, _1261) + ((_1271 - _1269) / mad(_1273, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1247 + _1247)), (1.0f / (_1250 + _1250)) + (_1273 / (_1268 + 9.9999997473787516355514526367188e-05f)), mad(_1268 * 3.0f, 1.0f / mad(_1268, 3.0f, 1.5f), 1.0f / (_1253 + _1253))), 0.0f);
        float _1298 = _1297.x;
        float _1299 = _1297.y;
        float _1300 = _1297.z;
        float3 _1328 = float3(mad(_1300, mad(_1299, clamp(abs(mad(frac(_1298 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1298 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1299, 1.0f), _1300, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1298 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1299, 1.0f), _1300, -3.5073844628641381859779357910156e-05f));
        float3 _1332 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1328), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1328), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1328));
        float3 _1336 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1332), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1332), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1332));
        float _1345 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1336) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1356 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1336) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1366 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1336) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[uint2(_351, _352)] = float4(min(exp2(log2(mad(_1345, 18.8515625f, 0.8359375f) / mad(_1345, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1356, 18.8515625f, 0.8359375f) / mad(_1356, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1366, 18.8515625f, 0.8359375f) / mad(_1366, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

#include "../common.hlsl"
struct _332
{
    uint2 _m0;
    uint _m1;
};

struct _1246
{
    uint3 _m0;
    uint _m1;
};

static const float _56[1] = { 0.0f };
static const float4 _272[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

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
    precise float _323 = a.x * b.x;
    return mad(a.y, b.y, _323);
}

float dp3_f32(float3 a, float3 b)
{
    precise float _309 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _309));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _291 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _291)));
}

void comp_main()
{
    uint _331_dummy_parameter;
    _332 _333 = { spvImageSize(u0, _331_dummy_parameter), 1u };
    uint _348 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 8u);
    uint _352 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + spvBitfieldUExtract(_348, 1u, 3u);
    uint _353 = spvBitfieldInsert(spvBitfieldUExtract(gl_LocalInvocationID.y, 0u, 29u), _348, 0u, 1u) + (gl_GlobalInvocationID.y - gl_LocalInvocationID.y);
    float _360 = (float(_352) + 0.5f) / float(_333._m0.x);
    float _361 = (float(_353) + 0.5f) / float(_333._m0.y);
    bool _371 = asfloat(cb1_m[2u].w) == 1.0f;
    if (((gl_LocalInvocationID.x == 0u) && _371) && (gl_LocalInvocationID.y == 0u))
    {
        g0[0u] = t6.Load(int3(uint2(0u, 0u), 0u)).x;
    }
    GroupMemoryBarrierWithGroupSync();
    float2 _386 = float2(_360, _361);
    float _391 = mad(t4.SampleLevel(s3, _386, 0.0f).x, 2.0f, -1.0f);
    float _406;
    if (_391 > 0.0f)
    {
        _406 = min(sqrt(_391), t0.Load(8u).x);
    }
    else
    {
        _406 = max(_391, -t0.Load(7u).x);
    }
    float4 _410 = t3.SampleLevel(s2, _386, 0.0f);
    float2 _422 = float2(_410.x * asfloat(cb1_m[2u].x), _410.y * asfloat(cb1_m[2u].y));
    bool _437 = (asfloat(cb1_m[7u].z) != 0.0f) && (asfloat(cb1_m[7u].w) != 0.0f);
    bool _442 = (asfloat(cb1_m[6u].w) != 0.0f) && (asfloat(cb1_m[7u].x) != 0.0f);
    float _446 = abs(_406);
    float _454 = exp2(max(_437 ? clamp((sqrt(dp2_f32(_422, _422)) - 2.0f) * 0.0555555559694766998291015625f, 0.0f, 1.0f) : 0.0f, _442 ? clamp((_446 - 0.0471399985253810882568359375f) * 1.0494720935821533203125f, 0.0f, 1.0f) : 0.0f) * (-4.3280849456787109375f));
    float _455 = _360 - 0.5f;
    float _456 = _361 - 0.5f;
    float2 _457 = float2(_455, _456);
    float _458 = dp2_f32(_457, _457);
    float _461 = asfloat(cb1_m[18u].x);
    float _462 = mad(_458, _461, 1.0f);
    float _468 = asfloat(cb1_m[18u].z);
    float _475 = asfloat(cb1_m[18u].y);
    float _487 = mad(exp2(log2(clamp(_461, 0.0f, 1.0f)) * 0.75f), -0.339999973773956298828125f, 1.0f) * mad(asfloat(cb1_m[18u].y), -0.089999973773956298828125f, 1.0f);
    float _488 = (_462 * mad(_475, mad(_468, -0.001999996602535247802734375f, 0.092000000178813934326171875f), 1.0f)) * _487;
    float _489 = _487 * (_462 * mad(_475, mad(_468, 0.04500000178813934326171875f, 0.046999998390674591064453125f), 1.0f));
    float _490 = _487 * (_462 * mad(_475, mad(_468, 0.0f, 0.04500000178813934326171875f), 1.0f));
    float _491 = mad(_455, _488, 0.5f);
    float _492 = mad(_488, _456, 0.5f);
    float _493 = mad(_455, _489, 0.5f);
    float _494 = mad(_489, _456, 0.5f);
    float2 _497 = float2(_491, _492);
    float4 _499 = t1.SampleLevel(s0, _497, 0.0f);
    float _500 = _499.x;
    bool _501 = _442 || _437;
    float _534;
    if (_501)
    {
        float4 _507 = t2.SampleLevel(s1, _497, 0.0f);
        float _508 = _507.x;
        float _515 = asfloat(cb0_m[43u].w) * 20.0f;
        float _531 = mad(mad(t7.SampleLevel(s5, float2(mad(_491, 30.0f, sin(_515)), mad(_492, 30.0f, cos(_515))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_508, max(_507.y, _507.z)), 1.0000000133514319600180897396058e-10f)), _508);
        _534 = mad(_454, _500 - _531, _531);
    }
    else
    {
        _534 = _500;
    }
    float2 _535 = float2(_493, _494);
    float4 _537 = t1.SampleLevel(s0, _535, 0.0f);
    float _538 = _537.y;
    float _571;
    if (_501)
    {
        float4 _544 = t2.SampleLevel(s1, _535, 0.0f);
        float _546 = _544.y;
        float _552 = asfloat(cb0_m[43u].w) * 20.0f;
        float _568 = mad(mad(t7.SampleLevel(s5, float2(mad(_493, 30.0f, sin(_552)), mad(_494, 30.0f, cos(_552))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_544.x, max(_546, _544.z)), 1.0000000133514319600180897396058e-10f)), _546);
        _571 = mad(_454, _538 - _568, _568);
    }
    else
    {
        _571 = _538;
    }
    float _572 = mad(_455, _490, 0.5f);
    float _573 = mad(_490, _456, 0.5f);
    float2 _574 = float2(_572, _573);
    float4 _576 = t1.SampleLevel(s0, _574, 0.0f);
    float _577 = _576.z;
    float _610;
    if (_501)
    {
        float4 _583 = t2.SampleLevel(s1, _574, 0.0f);
        float _586 = _583.z;
        float _591 = asfloat(cb0_m[43u].w) * 20.0f;
        float _607 = mad(mad(t7.SampleLevel(s5, float2(mad(_572, 30.0f, sin(_591)), mad(_573, 30.0f, cos(_591))), 0.0f).x, 0.00999999977648258209228515625f, -0.004999999888241291046142578125f), sqrt(max(max(_583.x, max(_583.y, _586)), 1.0000000133514319600180897396058e-10f)), _586);
        _610 = mad(_454, _577 - _607, _607);
    }
    else
    {
        _610 = _577;
    }
    float _616 = _371 ? g0[0u] : asfloat(cb1_m[2u].z);
    float4 _620 = t5.SampleLevel(s4, _386, 0.0f);
    float _621 = _620.x;
    float _630 = max(asfloat(cb1_m[3u].y) - dp3_f32(float3(_621, _620.yz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f)), 6.099999882280826568603515625e-05f);
    float _634 = mad(_534, _616, _621 / _630);
    float _635 = mad(_571, _616, _620.y / _630);
    float _636 = mad(_610, _616, _620.z / _630);
    float _640 = 1.0f / (max(_634, max(_636, _635)) + 1.0f);
    float _641 = _634 * _640;
    float _643 = _636 * _640;
    float3 _644 = float3(_641, _643, _635 * _640);
    float _645 = dp3_f32(_644, float3(0.25f, 0.25f, 0.5f));
    float _646 = dp3_f32(_644, float3(-0.25f, -0.25f, 0.5f));
    float _648 = dp2_f32(float2(_641, _643), float2(0.5f, -0.5f));
    uint2 _650 = uint2(_352, _353);
    u1[_650] = float4(_645, _648, _646, _645);
    if (!((_333._m0.x < _352) || (_333._m0.y < _353)))
    {
        float _655 = _645 - _646;
        float _656 = _648 + _655;
        float _657 = _645 + _646;
        float _658 = _655 - _648;
        float _660 = dp3_f32(float3(_656, _657, _658), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _669 = mad(-_446, asfloat(cb1_m[7u].y), 1.0f) * asfloat(cb1_m[6u].x);
        float _673 = mad(_669, _656 - _660, _660);
        float _674 = mad(_657 - _660, _669, _660);
        float _675 = mad(_658 - _660, _669, _660);
        float _676 = _456 + _456;
        float _677 = _455 + _455;
        float _678 = abs(_677);
        float _679 = abs(_676);
        float _683 = min(_678, _679) * (1.0f / max(_678, _679));
        float _684 = _683 * _683;
        float _688 = mad(_684, mad(_684, mad(_684, mad(_684, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _697 = mad(_683, _688, (_678 < _679) ? mad(_683 * _688, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_677 < (-_677)) ? (-3.1415927410125732421875f) : 0.0f);
        float _698 = min(_677, _676);
        float _699 = max(_677, _676);
        float _706 = ((_698 < (-_698)) && (_699 >= (-_699))) ? (-_697) : _697;
        float4 _710 = t8.SampleLevel(s6, _386, 0.0f);
        float _711 = _710.x;
        float _712 = _710.y;
        float _713 = _710.z;
        float _714 = _710.w;
        float _719 = (_674 - _675) * 1.73205077648162841796875f;
        float _721 = mad(_673, 2.0f, -_674);
        float _722 = _721 - _675;
        float _723 = abs(_719);
        float _724 = abs(_722);
        float _728 = min(_723, _724) * (1.0f / max(_723, _724));
        float _729 = _728 * _728;
        float _733 = mad(_729, mad(_729, mad(_729, mad(_729, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _742 = mad(_728, _733, (_723 > _724) ? mad(_728 * _733, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_722 < (_675 - _721)) ? (-3.1415927410125732421875f) : 0.0f);
        float _743 = min(_719, _722);
        float _744 = max(_719, _722);
        float _753 = ((_675 == _674) && (_674 == _673)) ? 0.0f : ((((_743 < (-_743)) && (_744 >= (-_744))) ? (-_742) : _742) * 57.295780181884765625f);
        float _764 = mad(asfloat(cb1_m[19u].y), -360.0f, (_753 < 0.0f) ? (_753 + 360.0f) : _753);
        float _774 = clamp(1.0f - (abs((_764 < (-180.0f)) ? (_764 + 360.0f) : ((_764 > 180.0f) ? (_764 - 360.0f) : _764)) / (asfloat(cb1_m[19u].z) * 180.0f)), 0.0f, 1.0f);
        float _779 = dp3_f32(float3(_673, _674, _675), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _783 = (mad(_774, -2.0f, 3.0f) * (_774 * _774)) * asfloat(cb1_m[19u].w);
        float _795 = asfloat(cb1_m[18u].w);
        float _796 = mad(mad(_783, _673 - _779, _779) - _673, _795, _673);
        float _797 = mad(_795, mad(_783, _674 - _779, _779) - _674, _674);
        float _798 = mad(_795, mad(_783, _675 - _779, _779) - _675, _675);
        float _800;
        _800 = 0.0f;
        float _801;
        uint _804;
        uint _803 = 0u;
        for (;;)
        {
            if (_803 >= 8u)
            {
                break;
            }
            uint _815 = min((_803 & 3u), 4u);
            float _835 = mad(float(_803), 0.785398185253143310546875f, -_706);
            float _836 = _835 + 1.57079637050628662109375f;
            _801 = mad(_714 * (dp4_f32(t10.Load((_803 >> 2u) + 10u), float4(_272[_815].x, _272[_815].y, _272[_815].z, _272[_815].w)) * clamp((abs((_836 > 3.1415927410125732421875f) ? (_835 - 4.7123889923095703125f) : _836) - 2.19911479949951171875f) * 2.1220657825469970703125f, 0.0f, 1.0f)), 1.0f - _800, _800);
            _804 = _803 + 1u;
            _800 = _801;
            _803 = _804;
            continue;
        }
        float _847 = clamp(_800, 0.0f, 1.0f);
        float _860 = asfloat(cb0_m[43u].w);
        float _866 = abs(t10.Load(8u).x);
        float2 _869 = float2(_455 * 1.40999996662139892578125f, _456 * 1.40999996662139892578125f);
        float _871 = sqrt(dp2_f32(_869, _869));
        float _872 = min(_871, 1.0f);
        float _873 = _872 * _872;
        float _878 = clamp(_871 - 0.5f, 0.0f, 1.0f);
        float _881 = (_872 * _873) + (mad(-_872, _873, 1.0f) * (_878 * _878));
        float _882 = mad(mad(mad(sin(_860 * 6.0f), 0.5f, 0.5f), 0.089999973773956298828125f, 0.910000026226043701171875f), _866, -1.0f);
        float _884 = _712 + _882;
        float _886 = clamp((_713 + _882) * 1.53846156597137451171875f, 0.0f, 1.0f);
        float _893 = clamp(_884 + _884, 0.0f, 1.0f);
        float _910 = dp3_f32(float3(t11.Load(8u).xyz), float3(0.21269999444484710693359375f, 0.715200006961822509765625f, 0.07209999859333038330078125f));
        float _916 = mad(sin(_712 * 17.52899932861328125f) + 1.0f, -0.1149999797344207763671875f, 0.89999997615814208984375f) * mad(exp2(log2(abs(_910)) * 0.699999988079071044921875f), 0.10000002384185791015625f, 0.89999997615814208984375f);
        float _918 = _916 * 0.02999999932944774627685546875f;
        float _919 = mad(_866, -0.3499999940395355224609375f, 0.3499999940395355224609375f);
        float _923 = mad(mad(-_881, _881, 1.0f), 1.0f - _919, _919);
        float _924 = min((exp2(log2(_881) * 0.699999988079071044921875f) * (mad(_893, -2.0f, 3.0f) * (_893 * _893))) + (mad(_886, -2.0f, 3.0f) * (_886 * _886)), 1.0f);
        float _934 = mad(_924, mad(_923, _916 * 0.62000000476837158203125f, mad(_796, _847, -_796)), mad(-_796, _847, _796));
        float _935 = mad(_924, mad(_923, _918, mad(_847, _797, -_797)), mad(-_847, _797, _797));
        float _936 = mad(_924, mad(_923, _918, mad(_847, _798, -_798)), mad(-_847, _798, _798));
        float _939 = mad(_712, _713 * (1.0f - _714), _714);
        float _941;
        _941 = 0.0f;
        float _942;
        uint _945;
        uint _944 = 0u;
        for (;;)
        {
            if (int(_944) >= 8)
            {
                break;
            }
            float4 _952 = t10.Load(_944);
            float _954 = _952.y;
            float _956 = _952.x - _706;
            _942 = mad(_939 * (_952.w * clamp(((_954 - 3.1415927410125732421875f) + abs((_956 > 3.1415927410125732421875f) ? (_956 - 6.283185482025146484375f) : ((_956 < (-3.1415927410125732421875f)) ? (_956 + 6.283185482025146484375f) : _956))) / max(_954 * 0.699999988079071044921875f, 0.001000000047497451305389404296875f), 0.0f, 1.0f)), 1.0f - _941, _941);
            _945 = _944 + 1u;
            _941 = _942;
            _944 = _945;
            continue;
        }
        float _975 = clamp(_941 + _941, 0.0f, 1.0f) * 0.949999988079071044921875f;
        float _979 = mad(_975, 0.310000002384185791015625f - _934, _934);
        float _980 = mad(_975, 0.014999999664723873138427734375f - _935, _935);
        float _981 = mad(_975, 0.014999999664723873138427734375f - _936, _936);
        float4 _982 = t10.Load(12u);
        float _983 = _982.x;
        float _1011;
        float _1012;
        float _1013;
        if (_983 != 0.0f)
        {
            float _990 = clamp(_910, 0.0f, 1.0f);
            float _1000 = clamp((_711 + (_983 - 1.0f)) / max(mad(_983, 0.5f, 0.5f), 0.001000000047497451305389404296875f), 0.0f, 1.0f);
            float _1004 = clamp(_983 * 2.857142925262451171875f, 0.0f, 1.0f);
            float _1007 = mad(_1004, -2.0f, 3.0f) * (_1004 * _1004);
            _1011 = mad(_1007, _1000 * (_990 * (_711 * 0.930000007152557373046875f)), _981);
            _1012 = mad(_1007, _1000 * (_990 * (_711 * 0.85000002384185791015625f)), _980);
            _1013 = mad((_990 * (_711 * 0.790000021457672119140625f)) * _1000, _1007, _979);
        }
        else
        {
            _1011 = _981;
            _1012 = _980;
            _1013 = _979;
        }
        float _1016 = asfloat(cb1_m[19u].x);
        bool _1017 = _1016 > 0.0f;
        bool _1021 = frac((_361 * 420.0f) + (_860 * 0.20000000298023223876953125f)) >= 0.5f;
        float _1022 = _1021 ? 0.300000011920928955078125f : 0.0f;
        float _1023 = _1016 * _1022;
        float _1031 = _1017 ? mad(_1023, 0.0f - _1013, _1013) : _1013;
        float _1032 = _1017 ? mad(_1023, (_1021 ? 0.100000001490116119384765625f : 0.0f) - _1012, _1012) : _1012;
        float _1033 = _1017 ? mad(_1023, _1022 - _1011, _1011) : _1011;
        float _1038 = 1.0f / max(1.0f - max(max(_1033, _1032), _1031), 6.099999882280826568603515625e-05f);
        float _1045 = min(-(_1038 * _1031), 0.0f);
        float _1046 = min(-(_1038 * _1032), 0.0f);
        float _1047 = min(-(_1038 * _1033), 0.0f);
        float _1059 = clamp(-((sqrt(_458) - asfloat(cb1_m[5u].x)) * (1.0f / asfloat(cb1_m[5u].y))), 0.0f, 1.0f);
        float _1060 = mad(_1059, -2.0f, 3.0f);
        float _1061 = _1059 * _1059;
        float _1062 = _1060 * _1061;
        float _1064 = mad(-_1060, _1061, 1.0f);
        float _1088 = asfloat(cb1_m[5u].w) * asfloat(cb1_m[5u].z);
        float3 _1098 = float3(mad(_1045 + ((_1064 * asfloat(cb1_m[4u].x)) - (_1045 * _1062)), _1088, -_1045), mad(_1088, ((_1064 * asfloat(cb1_m[4u].y)) - (_1062 * _1046)) + _1046, -_1046), mad(_1088, ((_1064 * asfloat(cb1_m[4u].z)) - (_1062 * _1047)) + _1047, -_1047));
#if 1
  float _1105 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1098) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.4397009909152984619140625f, 0.3829779922962188720703125f, 0.1773349940776824951171875f), _1098), 65504.0f);
  float _1106 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1098) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.08979229629039764404296875f, 0.813422977924346923828125f, 0.09676159918308258056640625f), _1098), 65504.0f);
  float _1107 = (RENODX_TONE_MAP_TYPE == 0) ? min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1098) * 2.5f, 65504.0f) : min(dp3_f32(float3(0.01754399947822093963623046875f, 0.11154399812221527099609375f, 0.870703995227813720703125f), _1098), 65504.0f);
#endif
        float _1111 = max(max(_1106, _1105), _1107);
        float _1116 = (max(_1111, 9.9999997473787516355514526367188e-05f) - max(min(min(_1106, _1105), _1107), 9.9999997473787516355514526367188e-05f)) / max(_1111, 0.00999999977648258209228515625f);
        float _1127 = mad(sqrt(mad(_1105 - _1107, _1105, ((_1107 - _1106) * _1107) + ((_1106 - _1105) * _1106))), 1.75f, (_1107 + _1106) + _1105);
        float _1128 = _1116 - 0.4000000059604644775390625f;
        float _1133 = max(1.0f - abs(_1128 * 2.5f), 0.0f);
        float _1140 = mad(mad(clamp(mad(_1128, asfloat(0x7f800000u /* inf */), 0.5f), 0.0f, 1.0f), 2.0f, -1.0f), mad(-_1133, _1133, 1.0f), 1.0f) * 0.02500000037252902984619140625f;
        float _1148 = ((_1127 <= 0.1599999964237213134765625f) ? _1140 : ((_1127 >= 0.4799999892711639404296875f) ? 0.0f : (_1140 * ((0.07999999821186065673828125f / (_1127 * 0.3333333432674407958984375f)) - 0.5f)))) + 1.0f;
        float _1149 = _1148 * _1105;
        float _1150 = _1148 * _1106;
        float _1151 = _1148 * _1107;
        float _1156 = (_1150 - _1151) * 1.73205077648162841796875f;
        float _1158 = (_1149 * 2.0f) - _1150;
        float _1160 = mad(-_1148, _1107, _1158);
        float _1161 = abs(_1160);
        float _1162 = abs(_1156);
        float _1166 = min(_1161, _1162) * (1.0f / max(_1161, _1162));
        float _1167 = _1166 * _1166;
        float _1171 = mad(_1167, mad(_1167, mad(_1167, mad(_1167, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
        float _1181 = mad(_1166, _1171, (_1161 < _1162) ? mad(_1166 * _1171, -2.0f, 1.57079637050628662109375f) : 0.0f) + ((_1160 < mad(_1148, _1107, -_1158)) ? (-3.1415927410125732421875f) : 0.0f);
        float _1182 = min(_1156, _1160);
        float _1183 = max(_1156, _1160);
        float _1192 = ((_1149 == _1150) && (_1151 == _1150)) ? 0.0f : ((((_1182 < (-_1182)) && (_1183 >= (-_1183))) ? (-_1181) : _1181) * 57.295780181884765625f);
        float _1195 = (_1192 < 0.0f) ? (_1192 + 360.0f) : _1192;
        float _1205 = max(1.0f - abs(((_1195 < (-180.0f)) ? (_1195 + 360.0f) : ((_1195 > 180.0f) ? (_1195 - 360.0f) : _1195)) * 0.01481481455266475677490234375f), 0.0f);
        float _1208 = mad(_1205, -2.0f, 3.0f) * (_1205 * _1205);
        float3 _1219 = float3(clamp(_1149 + (((_1116 * (_1208 * _1208)) * mad(-_1148, _1105, 0.02999999932944774627685546875f)) * 0.180000007152557373046875f), 0.0f, 65504.0f), clamp(_1150, 0.0f, 65504.0f), clamp(_1151, 0.0f, 65504.0f));
        float _1223 = clamp(dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1219), 0.0f, 65504.0f);
        float _1224 = clamp(dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1219), 0.0f, 65504.0f);
        float _1225 = clamp(dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1219), 0.0f, 65504.0f);

        float _1227 = dp3_f32(float3(_1223, _1224, _1225), float3(0.2722289860248565673828125f, 0.674081981182098388671875f, 0.0536894984543323516845703125f));
        float3 _1234 = float3(mad(_1223 - _1227, 0.959999978542327880859375f, _1227), mad(_1224 - _1227, 0.959999978542327880859375f, _1227), mad(_1225 - _1227, 0.959999978542327880859375f, _1227));
#if 1
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[_650] = float4(CustomACES(_1234), 1.f);
    return;
  }
#endif
        float3 _1238 = float3(dp3_f32(float3(0.695452213287353515625f, 0.140678703784942626953125f, 0.16386906802654266357421875f), _1234), dp3_f32(float3(0.0447945632040500640869140625f, 0.859671115875244140625f, 0.095534317195415496826171875f), _1234), dp3_f32(float3(-0.0055258828215301036834716796875f, 0.0040252101607620716094970703125f, 1.00150072574615478515625f), _1234));
        float _1239 = dp3_f32(float3(1.45143926143646240234375f, -0.236510753631591796875f, -0.214928567409515380859375f), _1238);
        float _1240 = dp3_f32(float3(-0.07655377686023712158203125f, 1.1762297153472900390625f, -0.0996759235858917236328125f), _1238);
        float _1241 = dp3_f32(float3(0.0083161480724811553955078125f, -0.0060324496589601039886474609375f, 0.99771630764007568359375f), _1238);
        uint _1243;
        spvTextureSize(t9, 0u, _1243);
        bool _1244 = _1243 > 0u;
        uint _1245_dummy_parameter;
        _1246 _1247 = { spvTextureSize(t9, 0u, _1245_dummy_parameter), 1u };
        float _1250 = float(_1244 ? _1247._m0.x : 0u);
        float _1253 = float(_1244 ? _1247._m0.y : 0u);
        float _1256 = float(_1244 ? _1247._m0.z : 0u);
        float _1260 = float(_1240 >= _1241);
        float _1261 = mad(_1240 - _1241, _1260, _1241);
        float _1262 = mad(_1260, _1241 - _1240, _1240);
        float _1264 = mad(_1260, -1.0f, 0.666666686534881591796875f);
        float _1270 = float(_1239 >= _1261);
        float _1271 = mad(_1239 - _1261, _1270, _1261);
        float _1272 = mad(_1262 - _1262, _1270, _1262);
        float _1274 = mad(_1261 - _1239, _1270, _1239);
        float _1276 = _1271 - min(_1274, _1272);
        float4 _1300 = t9.SampleLevel(s7, float3(abs(mad(mad(_1260, 1.0f, -1.0f) - _1264, _1270, _1264) + ((_1274 - _1272) / mad(_1276, 6.0f, 9.9999997473787516355514526367188e-05f))) + (1.0f / (_1250 + _1250)), (1.0f / (_1253 + _1253)) + (_1276 / (_1271 + 9.9999997473787516355514526367188e-05f)), mad(_1271 * 3.0f, 1.0f / mad(_1271, 3.0f, 1.5f), 1.0f / (_1256 + _1256))), 0.0f);
        float _1301 = _1300.x;
        float _1302 = _1300.y;
        float _1303 = _1300.z;
        float3 _1331 = float3(mad(_1303, mad(_1302, clamp(abs(mad(frac(_1301 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f), -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1301 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1302, 1.0f), _1303, -3.5073844628641381859779357910156e-05f), mad(mad(clamp(abs(mad(frac(_1301 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, _1302, 1.0f), _1303, -3.5073844628641381859779357910156e-05f));
        float3 _1335 = float3(dp3_f32(float3(0.662454187870025634765625f, 0.1340042054653167724609375f, 0.1561876833438873291015625f), _1331), dp3_f32(float3(0.272228717803955078125f, 0.674081742763519287109375f, 0.053689517080783843994140625f), _1331), dp3_f32(float3(-0.0055746496655046939849853515625f, 0.0040607335977256298065185546875f, 1.01033914089202880859375f), _1331));
        float3 _1339 = float3(dp3_f32(float3(0.98722398281097412109375f, -0.0061132698319852352142333984375f, 0.01595330052077770233154296875f), _1335), dp3_f32(float3(-0.007598360069096088409423828125f, 1.00186002254486083984375f, 0.0053301998414099216461181640625f), _1335), dp3_f32(float3(0.003072570078074932098388671875f, -0.0050959498621523380279541015625f, 1.0816800594329833984375f), _1335));
        float _1348 = exp2(log2(abs(dp3_f32(float3(1.71665096282958984375f, -0.35567080974578857421875f, -0.2533662319183349609375f), _1339) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1359 = exp2(log2(abs(dp3_f32(float3(-0.666684329509735107421875f, 1.616481304168701171875f, 0.0157685391604900360107421875f), _1339) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        float _1369 = exp2(log2(abs(dp3_f32(float3(0.0176398493349552154541015625f, -0.04277060925960540771484375f, 0.94210326671600341796875f), _1339) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
        u0[_650] = float4(min(exp2(log2(mad(_1348, 18.8515625f, 0.8359375f) / mad(_1348, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1359, 18.8515625f, 0.8359375f) / mad(_1359, 18.6875f, 1.0f)) * 78.84375f), 1.0f), min(exp2(log2(mad(_1369, 18.8515625f, 0.8359375f) / mad(_1369, 18.6875f, 1.0f)) * 78.84375f), 1.0f), 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

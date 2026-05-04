struct _37
{
    uint _m0;
    uint _m1;
};

static const _37 _963 = { 0u, 0u };
static const _37 _40[100] = { { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u } };

cbuffer cb0_buf : register(b0)
{
    float2 cb0_m0 : packoffset(c0);
    uint2 cb0_m1 : packoffset(c0.z);
    float4 cb0_m2 : packoffset(c1);
    float3 cb0_m3 : packoffset(c2);
    float cb0_m4 : packoffset(c2.w);
    float4 cb0_m5 : packoffset(c3);
    float3 cb0_m6 : packoffset(c4);
    uint cb0_m7 : packoffset(c4.w);
    uint2 cb0_m8 : packoffset(c5);
    float2 cb0_m9 : packoffset(c5.z);
    float2 cb0_m10 : packoffset(c6);
    float2 cb0_m11 : packoffset(c6.z);
    uint2 cb0_m12 : packoffset(c7);
    float cb0_m13 : packoffset(c7.z);
    uint cb0_m14 : packoffset(c7.w);
    float2 cb0_m15 : packoffset(c8);
    float2 cb0_m16 : packoffset(c8.z);
    float cb0_m17 : packoffset(c9);
    uint3 cb0_m18 : packoffset(c9.y);
};

cbuffer cb1_buf : register(b1)
{
    uint4 cb1_m0 : packoffset(c0);
    uint4 cb1_m1 : packoffset(c1);
    uint4 cb1_m2 : packoffset(c2);
    uint4 cb1_m3 : packoffset(c3);
    uint4 cb1_m4 : packoffset(c4);
    uint4 cb1_m5 : packoffset(c5);
    uint4 cb1_m6 : packoffset(c6);
    uint4 cb1_m7 : packoffset(c7);
    uint4 cb1_m8 : packoffset(c8);
    uint4 cb1_m9 : packoffset(c9);
    float4 cb1_m10 : packoffset(c10);
};

SamplerState s0 : register(s0);
Texture2D<float4> t0 : register(t0);
Texture2D<uint4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
RWTexture2D<float4> u0 : register(u0);
RWTexture2D<float4> u1 : register(u1);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

groupshared _37 g0[100];

uint spvPackHalf2x16(float2 value)
{
    uint2 Packed = f32tof16(value);
    return Packed.x | (Packed.y << 16);
}

float2 spvUnpackHalf2x16(uint value)
{
    return f16tof32(uint2(value & 0xffff, value >> 16));
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
    precise float _147 = a.x * b.x;
    return mad(a.y, b.y, _147);
}

uint f32_to_f16(float2 v)
{
    return spvPackHalf2x16(float2((abs(v.x) <= 3.4028234663852885981170418348452e+38f) ? clamp(v.x, -65504.0f, 65504.0f) : v.x, (abs(v.y) <= 3.4028234663852885981170418348452e+38f) ? clamp(v.y, -65504.0f, 65504.0f) : v.y));
}

void comp_main()
{
    uint _161 = (gl_WorkGroupID.x << 3u) - 1u;
    uint _162 = (gl_WorkGroupID.y << 3u) - 1u;
    uint _168 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 10u);
    float4 _173 = t2.Load(int3(uint2(_161 + gl_LocalInvocationID.x, gl_LocalInvocationID.y + _162), 0u));
    float _174 = _173.x;
    float _176 = _173.z;
    float _179 = _173.y * 0.5f;
    g0[_168]._m0 = f32_to_f16(float2(mad(_176, 0.25f, (_174 * 0.25f) + _179), mad(dp2_f32(float2(_174, _176), float2(0.5f, -0.5f)), 0.5f, 0.5f)));
    g0[_168]._m1 = f32_to_f16(float2(mad(mad(_176, -0.25f, (_174 * (-0.25f)) + _179), 0.5f, 0.5f), _173.w));
    int _202 = int(gl_LocalInvocationID.x);
    bool _203 = _202 >= 2;
    bool _204 = _202 >= 4;
    uint _208 = _204 ? spvBitfieldInsert(8u, gl_LocalInvocationID.x, 0u, 1u) : (_203 ? gl_LocalInvocationID.y : spvBitfieldInsert(8u, gl_LocalInvocationID.x, 0u, 3u));
    uint _209 = _204 ? spvBitfieldInsert(8u, gl_LocalInvocationID.y, 0u, 1u) : (_203 ? (gl_LocalInvocationID.x + 6u) : spvBitfieldInsert(0u, gl_LocalInvocationID.y, 0u, 31u));
    uint _211 = (_209 * 10u) + _208;
    float4 _215 = t2.Load(int3(uint2(_161 + _208, _162 + _209), 0u));
    float _216 = _215.x;
    float _218 = _215.z;
    float _221 = _215.y * 0.5f;
    g0[_211]._m0 = f32_to_f16(float2(mad(_218, 0.25f, (_216 * 0.25f) + _221), mad(dp2_f32(float2(_216, _218), float2(0.5f, -0.5f)), 0.5f, 0.5f)));
    g0[_211]._m1 = f32_to_f16(float2(mad(mad(_218, -0.25f, (_216 * (-0.25f)) + _221), 0.5f, 0.5f), _215.w));
    GroupMemoryBarrierWithGroupSync();
    uint _242 = gl_LocalInvocationID.x + (gl_WorkGroupID.x * 8u);
    uint _243 = gl_LocalInvocationID.y + (gl_WorkGroupID.y * 8u);
    float _248 = float(int(_242)) + 0.5f;
    float _249 = float(int(_243)) + 0.5f;
    float _256 = _248 * cb0_m9.x;
    float _257 = _249 * cb0_m9.y;
    uint _258 = _168 + 11u;
    uint _259 = _168 + 1u;
    uint _260 = _168 + 2u;
    uint _261 = _168 + 10u;
    float2 _268 = spvUnpackHalf2x16(g0[_258]._m0);
    float _269 = _268.x;
    float2 _270 = spvUnpackHalf2x16(g0[_258]._m1);
    float _271 = _270.x;
    uint2 _273 = uint2(_242, _243);
    uint4 _274 = t1.Load(int3(_273, 0u));
    uint _275 = _274.x;
    float2 _278 = spvUnpackHalf2x16(g0[_258]._m0);
    float _279 = _278.y;
    float _280 = _270.y;
    float _281 = _268.y;
    float2 _286 = spvUnpackHalf2x16(g0[_168]._m0);
    float _287 = _286.x;
    float2 _288 = spvUnpackHalf2x16(g0[_168]._m1);
    float _289 = _288.x;
    float _290 = _286.y;
    float _291 = _288.y;
    float2 _298 = spvUnpackHalf2x16(g0[_259]._m0);
    float _299 = _298.x;
    float2 _300 = spvUnpackHalf2x16(g0[_259]._m1);
    float _301 = _300.x;
    float _302 = _298.y;
    float _303 = _300.y;
    float2 _332 = spvUnpackHalf2x16(g0[_260]._m0);
    float _333 = _332.x;
    float2 _334 = spvUnpackHalf2x16(g0[_260]._m1);
    float _335 = _334.x;
    float _336 = _332.y;
    float _337 = _334.y;
    float2 _344 = spvUnpackHalf2x16(g0[_261]._m0);
    float _345 = _344.x;
    float2 _346 = spvUnpackHalf2x16(g0[_261]._m1);
    float _347 = _346.x;
    float _348 = _344.y;
    float _349 = _346.y;
    uint _372 = _168 + 12u;
    uint _373 = _168 + 20u;
    uint _374 = _168 + 21u;
    uint _375 = _168 + 22u;
    float2 _382 = spvUnpackHalf2x16(g0[_372]._m0);
    float _383 = _382.x;
    float2 _384 = spvUnpackHalf2x16(g0[_372]._m1);
    float _385 = _384.x;
    float _386 = _382.y;
    float _387 = _384.y;
    float2 _394 = spvUnpackHalf2x16(g0[_373]._m0);
    float _395 = _394.x;
    float2 _396 = spvUnpackHalf2x16(g0[_373]._m1);
    float _397 = _396.x;
    float _398 = _394.y;
    float _399 = _396.y;
    float2 _428 = spvUnpackHalf2x16(g0[_374]._m0);
    float _429 = _428.x;
    float2 _430 = spvUnpackHalf2x16(g0[_374]._m1);
    float _431 = _430.x;
    float _432 = _428.y;
    float _433 = _430.y;
    float2 _440 = spvUnpackHalf2x16(g0[_375]._m0);
    float _441 = _440.x;
    float2 _442 = spvUnpackHalf2x16(g0[_375]._m1);
    float _443 = _442.x;
    float _444 = _440.y;
    float _445 = _442.y;
    float _449 = (((((((_269 + _287) + _299) + _333) + _345) + _383) + _395) + _429) + _441;
    float _450 = _444 + (_432 + (_398 + (_386 + (_348 + (((_290 + _279) + _302) + _336)))));
    float _451 = _443 + (_431 + (_397 + (_385 + (_347 + (((_271 + _289) + _301) + _335)))));
    float _456 = min(min(min(min(_269, min(_287, _299)), min(_333, _345)), min(_383, _395)), min(_429, _441));
    float _464 = max(max(max(max(_269, max(_287, _299)), max(_333, _345)), max(_383, _395)), max(_429, _441));
    float _502 = (((_256 * cb0_m15.x) * cb0_m17) + (mad(cb1_m10.z, float(_275 & 16383u), -0.5f) * 0.25f)) * cb0_m16.x;
    float _503 = ((mad(cb1_m10.w, float(spvBitfieldUExtract(_275, 14u, 13u)), -0.5f) * 0.25f) + (_257 * cb0_m15.y)) * cb0_m16.y;
    float _686;
    float _687;
    float _688;
    float _689;
    if (cb0_m12.y != 0u)
    {
        float _515 = 1.0f / cb0_m10.x;
        float _516 = 1.0f / cb0_m10.y;
        float _521 = floor(mad(_502, cb0_m10.x, -0.5f)) + 0.5f;
        float _522 = floor(mad(_503, cb0_m10.y, -0.5f)) + 0.5f;
        float _524 = mad(_503, cb0_m10.y, -_522);
        float _526 = mad(_502, cb0_m10.x, -_521);
        float _527 = _526 * _526;
        float _528 = _524 * _524;
        float _529 = _527 * _526;
        float _530 = _524 * _528;
        float _535 = (mad(_524, _528, _524) * (-0.5f)) + _528;
        float _536 = _527 + (mad(_527, _526, _526) * (-0.5f));
        float _543 = ((_530 * 1.5f) - (_528 * 2.5f)) + 1.0f;
        float _544 = ((_529 * 1.5f) - (_527 * 2.5f)) + 1.0f;
        float _547 = (_529 - _527) * 0.5f;
        float _548 = (_530 - _528) * 0.5f;
        float _555 = mad(_527 - _529, 0.5f, (1.0f - _536) - _544);
        float _556 = mad(_528 - _530, 0.5f, (1.0f - _535) - _543);
        float _557 = _543 + _556;
        float _558 = _555 + _544;
        float _563 = _515 * _521;
        float _564 = _522 * _516;
        float _565 = _515 * (_521 + (_555 / _558));
        float _566 = ((_556 / _557) + _522) * _516;
        float2 _569 = float2(_563, _564);
        float4 _572 = t3.SampleLevel(s0, _569, 0.0f, int2(-1, -1));
        float _577 = _535 * _536;
        float2 _578 = float2(_565, _564);
        float4 _580 = t3.SampleLevel(s0, _578, 0.0f, int2(0, -1));
        float _585 = _535 * _558;
        float _586 = _557 * _536;
        float4 _600 = t3.SampleLevel(s0, _569, 0.0f, int2(2, -1));
        float _605 = _535 * _547;
        float _606 = _548 * _536;
        float2 _611 = float2(_563, _566);
        float4 _613 = t3.SampleLevel(s0, _611, 0.0f, int2(-1, 0));
        float4 _624 = t3.SampleLevel(s0, float2(_565, _566), 0.0f);
        float _629 = _557 * _558;
        float4 _635 = t3.SampleLevel(s0, _611, 0.0f, int2(2, 0));
        float _640 = _547 * _557;
        float _641 = _558 * _548;
        float4 _647 = t3.SampleLevel(s0, _569, 0.0f, int2(-1, 2));
        float4 _657 = t3.SampleLevel(s0, _578, 0.0f, int2(0, 2));
        float4 _667 = t3.SampleLevel(s0, _569, 0.0f, int2(2, 2));
        float _672 = _547 * _548;
        _686 = mad(_667.w, _672, mad(_657.w, _641, mad(_647.w, _606, mad(_640, _635.w, mad(_624.w, _629, mad(_613.w, _586, mad(_605, _600.w, (_572.w * _577) + (_585 * _580.w))))))));
        _687 = mad(_667.z, _672, mad(_657.z, _641, mad(_647.z, _606, mad(_640, _635.z, mad(_624.z, _629, mad(_613.z, _586, mad(_605, _600.z, (_572.z * _577) + (_585 * _580.z))))))));
        _688 = mad(_667.y, _672, mad(_657.y, _641, mad(_647.y, _606, mad(_640, _635.y, mad(_624.y, _629, mad(_613.y, _586, mad(_605, _600.y, (_572.y * _577) + (_585 * _580.y))))))));
        _689 = mad(_667.x, _672, mad(_657.x, _641, mad(_647.x, _606, mad(_640, _635.x, mad(_624.x, _629, mad(_613.x, _586, mad(_605, _600.x, (_585 * _580.x) + (_572.x * _577))))))));
    }
    else
    {
        float4 _681 = t3.SampleLevel(s0, float2(_502, _503), 0.0f);
        _686 = _681.w;
        _687 = _681.z;
        _688 = _681.y;
        _689 = _681.x;
    }
    bool _696 = (cb0_m12.x != 0u) && (_275 != 0u);
    uint _697 = _275 >> 30u;
    bool _699 = (_275 & 536870912u) != 0u;
    bool _703 = ((!_699) && (_697 == 0u)) || ((_275 & 268435456u) != 0u);
    float2 _714 = float2((_256 - _502) * 3840.0f, (_257 - _503) * 2160.0f);
    float _720 = mad(1.25f - exp2(-dp2_f32(_714, _714)), (_699 && (!_703)) ? 0.5f : 1.0f, min(min(_433, _445), min(min(_387, _399), min(min(_337, _349), min(min(_291, _303), _280)))));
    bool _724 = _697 != 0u;
    float _725 = _724 ? (_696 ? _689 : (_449 * 0.111111111938953399658203125f)) : _269;
    float _726 = _724 ? (_696 ? _688 : (_450 * 0.111111111938953399658203125f)) : _281;
    float _727 = _724 ? (_696 ? _687 : (_451 * 0.111111111938953399658203125f)) : _271;
    float _729 = clamp(max(_720, _686), 0.0f, 1.0f);
    float _733 = mad(_729, min(_464, max(_456, _689)) - _725, _725);
    float _734 = mad(_729, min(max(min(min(_432, _444), min(min(_386, _398), min(min(min(_290, _302), _279), min(_336, _348)))), _688), max(max(_432, _444), max(max(_386, _398), max(max(_336, _348), max(_279, max(_290, _302)))))) - _726, _726);
    float _735 = mad(_729, min(max(min(min(_431, _443), min(min(_385, _397), min(min(_335, _347), min(min(_289, _301), _271)))), _687), max(max(_431, _443), max(max(_385, _397), max(max(_335, _347), max(_271, max(_289, _301)))))) - _727, _727);
    bool _736 = max(max(_433, _445), max(max(_387, _399), max(max(_337, _349), max(_280, max(_291, _303))))) == 1.0f;
    float _739 = (_736 || (_686 == 1.0f)) ? 0.800000011920928955078125f : 0.89999997615814208984375f;
    float _742 = (_456 - _464) + 1.0f;
    float _759 = mad(clamp(dp2_f32(((cb0_m13 * (_699 ? 2.0f : float(_724))) * (_724 ? _739 : 0.0f)).xx, (_742 * _742).xx), 0.0f, 1.0f) * 0.25f, clamp(mad(mad(_449, -0.111111111938953399658203125f, _269), 4.0f, _269), 0.0f, 1.0f) - _269, _269);
    float _769 = _703 ? asfloat(cb0_m14) : 0.0f;
    float _770 = mad(mad(_449, 0.111111111938953399658203125f, -_759), _769, _759);
    float _771 = mad(_769, mad(_450, 0.111111111938953399658203125f, -_281), _281);
    float _772 = mad(_769, mad(_451, 0.111111111938953399658203125f, -_271), _271);
    float _774 = (_696 && _724) ? _739 : 0.0f;
    float _778 = mad(_733 - _770, _774, _770);
    float _779 = mad(_734 - _771, _774, _771);
    float _780 = mad(_735 - _772, _774, _772);
    float _790 = _733 + (((_778 - _733) > 0.0f) ? 0.00146484375f : (-0.00146484375f));
    float _791 = (((_779 - _734) > 0.0f) ? 0.00146484375f : (-0.00146484375f)) + _734;
    float _792 = _735 + (((_780 - _735) > 0.0f) ? 0.00146484375f : (-0.00146484375f));
    float _793 = _778 - _790;
    float _794 = _779 - _791;
    float _795 = _780 - _792;
    float _796 = _770 - _778;
    float _797 = _771 - _779;
    float _798 = _772 - _780;
    float _820 = (((_793 + _796) * (_790 - _778)) >= 0.0f) ? _790 : (((_793 * _796) >= 0.0f) ? _778 : _770);
    float _821 = (((_791 - _779) * (_797 + _794)) >= 0.0f) ? _791 : (((_797 * _794) >= 0.0f) ? _779 : _771);
    float _822 = (((_792 - _780) * (_798 + _795)) >= 0.0f) ? _792 : (((_798 * _795) >= 0.0f) ? _780 : _772);
    float _841;
    float _842;
    float _843;
    float _844;
    if (cb0_m18.x != 0u)
    {
        float4 _830 = t3.Load(int3(_273, 0u));
        float _831 = _830.x;
        float _832 = _830.y;
        float _833 = _830.z;
        _841 = 1.0f;
        _842 = mad(_820 - _831, 0.1500000059604644775390625f, _831);
        _843 = mad(_822 - _833, 0.1500000059604644775390625f, _833);
        _844 = mad(_821 - _832, 0.1500000059604644775390625f, _832);
    }
    else
    {
        _841 = _736 ? 1.0f : _720;
        _842 = _820;
        _843 = _822;
        _844 = _821;
    }
    float _850 = mad(-_843, 2.0f, 1.0f);
    float _870 = mad(cb0_m2.x, frac(sin(mad(mad(_249, cb0_m9.y, cb0_m0.y), 543.30999755859375f, mad(_248, cb0_m9.x, cb0_m0.x))) * 493013.0f), cb0_m2.y);
    float _871 = ((_842 + mad(_844, 2.0f, -1.0f)) + _850) * _870;
    float _872 = (_842 + mad(_843, 2.0f, -1.0f)) * _870;
    float _873 = (_850 + (_842 + mad(-_844, 2.0f, 1.0f))) * _870;
    u1[_273] = float4(_820, _821, _822, _841);
    float2 _882 = float2(mad(_248, cb0_m11.x, -0.5f), mad(_249, cb0_m11.y, -0.5f));
    float _893 = clamp(cb0_m5.y * exp2(-(cb0_m5.x * (0.5f - dp2_f32(_882, _882)))), 0.0f, 1.0f);
    float _900 = mad(-cb0_m4, _893, cb0_m4);
    float _902 = cb0_m4 * (_893 * _893);
    float _926 = mad(cb0_m2.x, frac(sin(mad(mad(_249, cb0_m11.y, cb0_m0.y), 543.30999755859375f, mad(_248, cb0_m11.x, cb0_m0.x))) * 493013.0f), cb0_m2.y);
    float4 _931 = t0.Load(int3(_273, 0u));
    float _936 = 1.0f - _931.w;
    float _937 = mad(mad(_902, cb0_m6.x, mad(_871 * _871, _900, cb0_m3.x)) * _926, _936, _931.x);
    float _938 = mad(mad(_902, cb0_m6.y, mad(_872 * _872, _900, cb0_m3.y)) * _926, _936, _931.y);
    float _939 = mad(mad(_902, cb0_m6.z, mad(_873 * _873, _900, cb0_m3.z)) * _926, _936, _931.z);
    float _958 = min(mad(exp2(log2(max(_937, 0.00313066993840038776397705078125f)) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f), _937 * 12.9200000762939453125f);
    u0[_273] = float4(_958, min(mad(exp2(log2(max(_938, 0.00313066993840038776397705078125f)) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f), _938 * 12.9200000762939453125f), min(mad(exp2(log2(max(_939, 0.00313066993840038776397705078125f)) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f), _939 * 12.9200000762939453125f), _958);
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}

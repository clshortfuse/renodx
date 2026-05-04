#include "./common.hlsl"

struct _34
{
    uint _m0;
    uint _m1;
};

static const _34 _814 = { 0u, 0u };
static const _34 _37[100] = { { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u }, { 0u, 0u } };

cbuffer cb0_buf : register(b0)
{
    uint2 cb0_m0 : packoffset(c0);
    float2 cb0_m1 : packoffset(c0.z);
    float2 cb0_m2 : packoffset(c1);
    uint2 cb0_m3 : packoffset(c1.z);
    uint2 cb0_m4 : packoffset(c2);
    float cb0_m5 : packoffset(c2.z);
    uint cb0_m6 : packoffset(c2.w);
    float2 cb0_m7 : packoffset(c3);
    float2 cb0_m8 : packoffset(c3.z);
    float cb0_m9 : packoffset(c4);
    uint3 cb0_m10 : packoffset(c4.y);
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
Texture2D<uint4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
RWTexture2D<float4> u0 : register(u0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

groupshared _34 g0[100];

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
    precise float _128 = a.x * b.x;
    return mad(a.y, b.y, _128);
}

uint f32_to_f16(float2 v)
{
    return spvPackHalf2x16(float2((abs(v.x) <= 3.4028234663852885981170418348452e+38f) ? clamp(v.x, -65504.0f, 65504.0f) : v.x, (abs(v.y) <= 3.4028234663852885981170418348452e+38f) ? clamp(v.y, -65504.0f, 65504.0f) : v.y));
}

void comp_main()
{
    uint _142 = (gl_WorkGroupID.x << 3u) - 1u;
    uint _143 = (gl_WorkGroupID.y << 3u) - 1u;
    uint _149 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 10u);

    float4 _154 = t1.Load(int3(uint2(_142 + gl_LocalInvocationID.x, gl_LocalInvocationID.y + _143), 0u));
    if (RENODX_TONE_MAP_TYPE > 1) {
        float _taa_peak_154 = max(max(_154.x, _154.y), _154.z);
        _154.xyz *= rcp(1.0f + _taa_peak_154);
        _154.xyz = saturate(_154.xyz);
    }
    float _155 = _154.x;
    float _157 = _154.z;
    float _160 = _154.y * 0.5f;
    g0[_149]._m0 = f32_to_f16(float2(mad(_157, 0.25f, (_155 * 0.25f) + _160), mad(dp2_f32(float2(_155, _157), float2(0.5f, -0.5f)), 0.5f, 0.5f)));
    g0[_149]._m1 = f32_to_f16(float2(mad(mad(_157, -0.25f, (_155 * (-0.25f)) + _160), 0.5f, 0.5f), _154.w));
    int _183 = int(gl_LocalInvocationID.x);
    bool _184 = _183 >= 2;
    bool _185 = _183 >= 4;
    uint _189 = _185 ? spvBitfieldInsert(8u, gl_LocalInvocationID.x, 0u, 1u) : (_184 ? gl_LocalInvocationID.y : spvBitfieldInsert(8u, gl_LocalInvocationID.x, 0u, 3u));
    uint _190 = _185 ? spvBitfieldInsert(8u, gl_LocalInvocationID.y, 0u, 1u) : (_184 ? (gl_LocalInvocationID.x + 6u) : spvBitfieldInsert(0u, gl_LocalInvocationID.y, 0u, 31u));
    uint _192 = (_190 * 10u) + _189;
    float4 _196 = t1.Load(int3(uint2(_142 + _189, _143 + _190), 0u));
    if (RENODX_TONE_MAP_TYPE > 1) {
        float _taa_peak_196 = max(max(_196.x, _196.y), _196.z);
        _196.xyz *= rcp(1.0f + _taa_peak_196);
        _196.xyz = saturate(_196.xyz);
    }
    float _197 = _196.x;
    float _199 = _196.z;
    float _202 = _196.y * 0.5f;
    g0[_192]._m0 = f32_to_f16(float2(mad(_199, 0.25f, (_197 * 0.25f) + _202), mad(dp2_f32(float2(_197, _199), float2(0.5f, -0.5f)), 0.5f, 0.5f)));
    g0[_192]._m1 = f32_to_f16(float2(mad(mad(_199, -0.25f, (_197 * (-0.25f)) + _202), 0.5f, 0.5f), _196.w));
    GroupMemoryBarrierWithGroupSync();
    uint _223 = gl_LocalInvocationID.x + (gl_WorkGroupID.x * 8u);
    uint _224 = gl_LocalInvocationID.y + (gl_WorkGroupID.y * 8u);
    float _237 = (float(int(_223)) + 0.5f) * cb0_m1.x;
    float _238 = (float(int(_224)) + 0.5f) * cb0_m1.y;
    uint _239 = _149 + 11u;
    uint _240 = _149 + 1u;
    uint _241 = _149 + 2u;
    uint _242 = _149 + 10u;
    float2 _249 = spvUnpackHalf2x16(g0[_239]._m0);
    float _250 = _249.x;
    float2 _251 = spvUnpackHalf2x16(g0[_239]._m1);
    float _252 = _251.x;
    uint2 _254 = uint2(_223, _224);
    uint4 _255 = t0.Load(int3(_254, 0u));
    uint _256 = _255.x;
    float2 _259 = spvUnpackHalf2x16(g0[_239]._m0);
    float _260 = _259.y;
    float _261 = _251.y;
    float _262 = _249.y;
    float2 _267 = spvUnpackHalf2x16(g0[_149]._m0);
    float _268 = _267.x;
    float2 _269 = spvUnpackHalf2x16(g0[_149]._m1);
    float _270 = _269.x;
    float _271 = _267.y;
    float _272 = _269.y;
    float2 _279 = spvUnpackHalf2x16(g0[_240]._m0);
    float _280 = _279.x;
    float2 _281 = spvUnpackHalf2x16(g0[_240]._m1);
    float _282 = _281.x;
    float _283 = _279.y;
    float _284 = _281.y;
    float2 _313 = spvUnpackHalf2x16(g0[_241]._m0);
    float _314 = _313.x;
    float2 _315 = spvUnpackHalf2x16(g0[_241]._m1);
    float _316 = _315.x;
    float _317 = _313.y;
    float _318 = _315.y;
    float2 _325 = spvUnpackHalf2x16(g0[_242]._m0);
    float _326 = _325.x;
    float2 _327 = spvUnpackHalf2x16(g0[_242]._m1);
    float _328 = _327.x;
    float _329 = _325.y;
    float _330 = _327.y;
    uint _353 = _149 + 12u;
    uint _354 = _149 + 20u;
    uint _355 = _149 + 21u;
    uint _356 = _149 + 22u;
    float2 _363 = spvUnpackHalf2x16(g0[_353]._m0);
    float _364 = _363.x;
    float2 _365 = spvUnpackHalf2x16(g0[_353]._m1);
    float _366 = _365.x;
    float _367 = _363.y;
    float _368 = _365.y;
    float2 _375 = spvUnpackHalf2x16(g0[_354]._m0);
    float _376 = _375.x;
    float2 _377 = spvUnpackHalf2x16(g0[_354]._m1);
    float _378 = _377.x;
    float _379 = _375.y;
    float _380 = _377.y;
    float2 _409 = spvUnpackHalf2x16(g0[_355]._m0);
    float _410 = _409.x;
    float2 _411 = spvUnpackHalf2x16(g0[_355]._m1);
    float _412 = _411.x;
    float _413 = _409.y;
    float _414 = _411.y;
    float2 _421 = spvUnpackHalf2x16(g0[_356]._m0);
    float _422 = _421.x;
    float2 _423 = spvUnpackHalf2x16(g0[_356]._m1);
    float _424 = _423.x;
    float _425 = _421.y;
    float _426 = _423.y;
    float _430 = (((((((_250 + _268) + _280) + _314) + _326) + _364) + _376) + _410) + _422;
    float _431 = _425 + (_413 + (_379 + (_367 + (_329 + (_317 + (_283 + (_260 + _271)))))));
    float _432 = _424 + (_412 + (_378 + (_366 + (_328 + (_316 + (_282 + (_252 + _270)))))));
    float _437 = min(min(min(min(_250, min(_268, _280)), min(_314, _326)), min(_364, _376)), min(_410, _422));
    float _445 = max(max(max(max(_250, max(_268, _280)), max(_314, _326)), max(_364, _376)), max(_410, _422));
    float _483 = (((_237 * cb0_m7.x) * cb0_m9) + (mad(float(_256 & 16383u), cb1_m10.z, -0.5f) * 0.25f)) * cb0_m8.x;
    float _484 = cb0_m8.y * ((mad(float(spvBitfieldUExtract(_256, 14u, 13u)), cb1_m10.w, -0.5f) * 0.25f) + (_238 * cb0_m7.y));
    float _667;
    float _668;
    float _669;
    float _670;
    if (cb0_m4.y != 0u)
    {
        float _496 = 1.0f / cb0_m2.x;
        float _497 = 1.0f / cb0_m2.y;
        float _502 = floor(mad(_483, cb0_m2.x, -0.5f)) + 0.5f;
        float _503 = floor(mad(_484, cb0_m2.y, -0.5f)) + 0.5f;
        float _505 = mad(_484, cb0_m2.y, -_503);
        float _507 = mad(_483, cb0_m2.x, -_502);
        float _508 = _507 * _507;
        float _509 = _505 * _505;
        float _510 = _508 * _507;
        float _511 = _505 * _509;
        float _516 = (mad(_505, _509, _505) * (-0.5f)) + _509;
        float _517 = _508 + (mad(_508, _507, _507) * (-0.5f));
        float _524 = ((_511 * 1.5f) - (_509 * 2.5f)) + 1.0f;
        float _525 = ((_510 * 1.5f) - (_508 * 2.5f)) + 1.0f;
        float _528 = (_510 - _508) * 0.5f;
        float _529 = (_511 - _509) * 0.5f;
        float _536 = mad(_508 - _510, 0.5f, (1.0f - _517) - _525);
        float _537 = mad(_509 - _511, 0.5f, (1.0f - _516) - _524);
        float _538 = _524 + _537;
        float _539 = _536 + _525;
        float _544 = _496 * _502;
        float _545 = _503 * _497;
        float _546 = _496 * (_502 + (_536 / _539));
        float _547 = ((_537 / _538) + _503) * _497;
        float2 _550 = float2(_544, _545);
        float4 _553 = t2.SampleLevel(s0, _550, 0.0f, int2(-1, -1));
        float _558 = _516 * _517;
        float2 _559 = float2(_546, _545);
        float4 _561 = t2.SampleLevel(s0, _559, 0.0f, int2(0, -1));
        float _566 = _516 * _539;
        float _567 = _538 * _517;
        float4 _581 = t2.SampleLevel(s0, _550, 0.0f, int2(2, -1));
        float _586 = _516 * _528;
        float _587 = _529 * _517;
        float2 _592 = float2(_544, _547);
        float4 _594 = t2.SampleLevel(s0, _592, 0.0f, int2(-1, 0));
        float4 _605 = t2.SampleLevel(s0, float2(_546, _547), 0.0f);
        float _610 = _538 * _539;
        float4 _616 = t2.SampleLevel(s0, _592, 0.0f, int2(2, 0));
        float _621 = _528 * _538;
        float _622 = _539 * _529;
        float4 _628 = t2.SampleLevel(s0, _550, 0.0f, int2(-1, 2));
        float4 _638 = t2.SampleLevel(s0, _559, 0.0f, int2(0, 2));
        float4 _648 = t2.SampleLevel(s0, _550, 0.0f, int2(2, 2));
        float _653 = _528 * _529;
        _667 = mad(_648.w, _653, mad(_638.w, _622, mad(_628.w, _587, mad(_621, _616.w, mad(_605.w, _610, mad(_594.w, _567, mad(_586, _581.w, (_553.w * _558) + (_566 * _561.w))))))));
        _668 = mad(_648.z, _653, mad(_638.z, _622, mad(_628.z, _587, mad(_621, _616.z, mad(_605.z, _610, mad(_594.z, _567, mad(_586, _581.z, (_553.z * _558) + (_566 * _561.z))))))));
        _669 = mad(_648.y, _653, mad(_638.y, _622, mad(_628.y, _587, mad(_621, _616.y, mad(_605.y, _610, mad(_594.y, _567, mad(_586, _581.y, (_553.y * _558) + (_566 * _561.y))))))));
        _670 = mad(_648.x, _653, mad(_638.x, _622, mad(_628.x, _587, mad(_621, _616.x, mad(_605.x, _610, mad(_594.x, _567, mad(_586, _581.x, (_566 * _561.x) + (_553.x * _558))))))));
    }
    else
    {
        float4 _662 = t2.SampleLevel(s0, float2(_483, _484), 0.0f);
        _667 = _662.w;
        _668 = _662.z;
        _669 = _662.y;
        _670 = _662.x;
    }
    bool _677 = (cb0_m4.x != 0u) && (_256 != 0u);
    uint _678 = _256 >> 30u;
    bool _680 = (_256 & 536870912u) != 0u;
    bool _684 = ((_256 & 268435456u) != 0u) || ((!_680) && (_678 == 0u));
    float2 _695 = float2((_237 - _483) * 3840.0f, (_238 - _484) * 2160.0f);
    float _701 = mad(1.25f - exp2(-dp2_f32(_695, _695)), (_680 && (!_684)) ? 0.5f : 1.0f, min(min(_414, _426), min(min(_368, _380), min(min(_318, _330), min(_261, min(_272, _284))))));
    bool _705 = _678 != 0u;
    float _706 = _705 ? (_677 ? _670 : (_430 * 0.111111111938953399658203125f)) : _250;
    float _707 = _705 ? (_677 ? _669 : (_431 * 0.111111111938953399658203125f)) : _262;
    float _708 = _705 ? (_677 ? _668 : (_432 * 0.111111111938953399658203125f)) : _252;
    float _710 = clamp(max(_701, _667), 0.0f, 1.0f);
    float _714 = mad(_710, min(_445, max(_437, _670)) - _706, _706);
    float _715 = mad(min(max(min(min(_413, _425), min(min(_367, _379), min(min(_317, _329), min(_260, min(_271, _283))))), _669), max(max(_413, _425), max(max(_367, _379), max(max(_317, _329), max(_260, max(_271, _283)))))) - _707, _710, _707);
    float _716 = mad(min(max(_668, min(min(_412, _424), min(min(_366, _378), min(min(_316, _328), min(_252, min(_270, _282)))))), max(max(_412, _424), max(max(_366, _378), max(max(_316, _328), max(_252, max(_270, _282)))))) - _708, _710, _708);
    bool _717 = max(max(_414, _426), max(max(_368, _380), max(max(_318, _330), max(_261, max(_272, _284))))) == 1.0f;
    float _720 = (_717 || (_667 == 1.0f)) ? 0.800000011920928955078125f : 0.89999997615814208984375f;
    float _723 = (_437 - _445) + 1.0f;
    float _740 = mad(clamp(dp2_f32(((cb0_m5 * (_680 ? 2.0f : float(_705))) * (_705 ? _720 : 0.0f)).xx, (_723 * _723).xx), 0.0f, 1.0f) * 0.25f, clamp(mad(mad(_430, -0.111111111938953399658203125f, _250), 4.0f, _250), 0.0f, 1.0f) - _250, _250);
    float _750 = _684 ? asfloat(cb0_m6) : 0.0f;
    float _751 = mad(mad(_430, 0.111111111938953399658203125f, -_740), _750, _740);
    float _752 = mad(mad(_431, 0.111111111938953399658203125f, -_262), _750, _262);
    float _753 = mad(mad(_432, 0.111111111938953399658203125f, -_252), _750, _252);
    float _755 = (_677 && _705) ? _720 : 0.0f;
    float _759 = mad(_714 - _751, _755, _751);
    float _760 = mad(_715 - _752, _755, _752);
    float _761 = mad(_716 - _753, _755, _753);
    float _771 = (((_759 - _714) > 0.0f) ? 0.00146484375f : (-0.00146484375f)) + _714;
    float _772 = (((_760 - _715) > 0.0f) ? 0.00146484375f : (-0.00146484375f)) + _715;
    float _773 = _716 + (((_761 - _716) > 0.0f) ? 0.00146484375f : (-0.00146484375f));
    float _774 = _759 - _771;
    float _775 = _760 - _772;
    float _776 = _761 - _773;
    float _777 = _751 - _759;
    float _778 = _752 - _760;
    float _779 = _753 - _761;
    float _811;
    if (cb0_m10.x != 0u)
    {
        _811 = 1.0f;
    }
    else
    {
        _811 = _717 ? 1.0f : _701;
    }

    float _out_r = (((_774 + _777) * (_771 - _759)) >= 0.0f) ? _771 : (((_774 * _777) >= 0.0f) ? _759 : _751);
    float _out_g = (((_772 - _760) * (_778 + _775)) >= 0.0f) ? _772 : (((_778 * _775) >= 0.0f) ? _760 : _752);
    float _out_b = (((_773 - _761) * (_779 + _776)) >= 0.0f) ? _773 : (((_779 * _776) >= 0.0f) ? _761 : _753);

    u0[_254] = float4(_out_r, _out_g, _out_b, _811);

}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}

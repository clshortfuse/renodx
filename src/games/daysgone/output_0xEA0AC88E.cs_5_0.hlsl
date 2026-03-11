#include "./common.hlsl"

struct _37
{
    uint _m0;
    uint _m1;
};

static const _37 _1006 = { 0u, 0u };
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
    float4 cb0_m8 : packoffset(c5);
    uint2 cb0_m9 : packoffset(c6);
    float2 cb0_m10 : packoffset(c6.z);
    float2 cb0_m11 : packoffset(c7);
    float2 cb0_m12 : packoffset(c7.z);
    uint2 cb0_m13 : packoffset(c8);
    float cb0_m14 : packoffset(c8.z);
    uint cb0_m15 : packoffset(c8.w);
    float2 cb0_m16 : packoffset(c9);
    float2 cb0_m17 : packoffset(c9.z);
    float cb0_m18 : packoffset(c10);
    uint3 cb0_m19 : packoffset(c10.y);
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
    precise float _152 = a.x * b.x;
    return mad(a.y, b.y, _152);
}

uint f32_to_f16(float2 v)
{
    return spvPackHalf2x16(float2((abs(v.x) <= 3.4028234663852885981170418348452e+38f) ? clamp(v.x, -65504.0f, 65504.0f) : v.x, (abs(v.y) <= 3.4028234663852885981170418348452e+38f) ? clamp(v.y, -65504.0f, 65504.0f) : v.y));
}

void comp_main()
{
    uint _166 = (gl_WorkGroupID.x << 3u) - 1u;
    uint _167 = (gl_WorkGroupID.y << 3u) - 1u;
    uint _173 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 10u);

    float2 uv = float2(gl_LocalInvocationID.x, gl_LocalInvocationID.y);

    float4 _178 = t2.Load(int3(uint2(_166 + gl_LocalInvocationID.x, gl_LocalInvocationID.y + _167), 0u));
    if (RENODX_TONE_MAP_TYPE > 1) {
        float _taa_peak_178 = max(max(_178.x, _178.y), _178.z);
        _178.xyz *= rcp(1.0f + _taa_peak_178);
        _178.xyz = saturate(_178.xyz);
    }

    float _179 = _178.x;
    float _181 = _178.z;
    float _184 = _178.y * 0.5f;
    g0[_173]._m0 = f32_to_f16(float2(mad(_181, 0.25f, (_179 * 0.25f) + _184), mad(dp2_f32(float2(_179, _181), float2(0.5f, -0.5f)), 0.5f, 0.5f)));
    g0[_173]._m1 = f32_to_f16(float2(mad(mad(_181, -0.25f, (_179 * (-0.25f)) + _184), 0.5f, 0.5f), _178.w));
    int _207 = int(gl_LocalInvocationID.x);
    bool _208 = _207 >= 2;
    bool _209 = _207 >= 4;
    uint _213 = _209 ? spvBitfieldInsert(8u, gl_LocalInvocationID.x, 0u, 1u) : (_208 ? gl_LocalInvocationID.y : spvBitfieldInsert(8u, gl_LocalInvocationID.x, 0u, 3u));
    uint _214 = _209 ? spvBitfieldInsert(8u, gl_LocalInvocationID.y, 0u, 1u) : (_208 ? (gl_LocalInvocationID.x + 6u) : spvBitfieldInsert(0u, gl_LocalInvocationID.y, 0u, 31u));
    uint _216 = (_214 * 10u) + _213;

    float4 _220 = t2.Load(int3(uint2(_166 + _213, _167 + _214), 0u));
    if (RENODX_TONE_MAP_TYPE > 1) {
        float _taa_peak_220 = max(max(_220.x, _220.y), _220.z);
        _220.xyz *= rcp(1.0f + _taa_peak_220);
        _220.xyz = saturate(_220.xyz);
    }

    float _221 = _220.x;
    float _223 = _220.z;
    float _226 = _220.y * 0.5f;
    g0[_216]._m0 = f32_to_f16(float2(mad(_223, 0.25f, (_221 * 0.25f) + _226), mad(dp2_f32(float2(_221, _223), float2(0.5f, -0.5f)), 0.5f, 0.5f)));
    g0[_216]._m1 = f32_to_f16(float2(mad(mad(_223, -0.25f, (_221 * (-0.25f)) + _226), 0.5f, 0.5f), _220.w));
    GroupMemoryBarrierWithGroupSync();
    uint _247 = gl_LocalInvocationID.x + (gl_WorkGroupID.x * 8u);
    uint _248 = gl_LocalInvocationID.y + (gl_WorkGroupID.y * 8u);
    float _253 = float(int(_247)) + 0.5f;
    float _254 = float(int(_248)) + 0.5f;
    float _261 = _253 * cb0_m10.x;
    float _262 = _254 * cb0_m10.y;
    uint _263 = _173 + 11u;
    uint _264 = _173 + 1u;
    uint _265 = _173 + 2u;
    uint _266 = _173 + 10u;
    float2 _273 = spvUnpackHalf2x16(g0[_263]._m0);
    float _274 = _273.x;
    float2 _275 = spvUnpackHalf2x16(g0[_263]._m1);
    float _276 = _275.x;
    uint2 _278 = uint2(_247, _248);
    uint4 _279 = t1.Load(int3(_278, 0u));
    uint _280 = _279.x;
    float2 _283 = spvUnpackHalf2x16(g0[_263]._m0);
    float _284 = _283.y;
    float _285 = _275.y;
    float _286 = _273.y;
    float2 _291 = spvUnpackHalf2x16(g0[_173]._m0);
    float _292 = _291.x;
    float2 _293 = spvUnpackHalf2x16(g0[_173]._m1);
    float _294 = _293.x;
    float _295 = _291.y;
    float _296 = _293.y;
    float2 _303 = spvUnpackHalf2x16(g0[_264]._m0);
    float _304 = _303.x;
    float2 _305 = spvUnpackHalf2x16(g0[_264]._m1);
    float _306 = _305.x;
    float _307 = _303.y;
    float _308 = _305.y;
    float2 _337 = spvUnpackHalf2x16(g0[_265]._m0);
    float _338 = _337.x;
    float2 _339 = spvUnpackHalf2x16(g0[_265]._m1);
    float _340 = _339.x;
    float _341 = _337.y;
    float _342 = _339.y;
    float2 _349 = spvUnpackHalf2x16(g0[_266]._m0);
    float _350 = _349.x;
    float2 _351 = spvUnpackHalf2x16(g0[_266]._m1);
    float _352 = _351.x;
    float _353 = _349.y;
    float _354 = _351.y;
    uint _377 = _173 + 12u;
    uint _378 = _173 + 20u;
    uint _379 = _173 + 21u;
    uint _380 = _173 + 22u;
    float2 _387 = spvUnpackHalf2x16(g0[_377]._m0);
    float _388 = _387.x;
    float2 _389 = spvUnpackHalf2x16(g0[_377]._m1);
    float _390 = _389.x;
    float _391 = _387.y;
    float _392 = _389.y;
    float2 _399 = spvUnpackHalf2x16(g0[_378]._m0);
    float _400 = _399.x;
    float2 _401 = spvUnpackHalf2x16(g0[_378]._m1);
    float _402 = _401.x;
    float _403 = _399.y;
    float _404 = _401.y;
    float2 _433 = spvUnpackHalf2x16(g0[_379]._m0);
    float _434 = _433.x;
    float2 _435 = spvUnpackHalf2x16(g0[_379]._m1);
    float _436 = _435.x;
    float _437 = _433.y;
    float _438 = _435.y;
    float2 _445 = spvUnpackHalf2x16(g0[_380]._m0);
    float _446 = _445.x;
    float2 _447 = spvUnpackHalf2x16(g0[_380]._m1);
    float _448 = _447.x;
    float _449 = _445.y;
    float _450 = _447.y;
    float _454 = (((((((_274 + _292) + _304) + _338) + _350) + _388) + _400) + _434) + _446;
    float _455 = _449 + (_437 + (_403 + (_391 + (_353 + (((_295 + _284) + _307) + _341)))));
    float _456 = _448 + (_436 + (_402 + (_390 + (_352 + (((_276 + _294) + _306) + _340)))));
    float _461 = min(min(min(min(_274, min(_292, _304)), min(_338, _350)), min(_388, _400)), min(_434, _446));
    float _469 = max(max(max(max(_274, max(_292, _304)), max(_338, _350)), max(_388, _400)), max(_434, _446));
    float _507 = (((_261 * cb0_m16.x) * cb0_m18) + (mad(float(_280 & 16383u), cb1_m10.z, -0.5f) * 0.25f)) * cb0_m17.x;
    float _508 = ((mad(float(spvBitfieldUExtract(_280, 14u, 13u)), cb1_m10.w, -0.5f) * 0.25f) + (_262 * cb0_m16.y)) * cb0_m17.y;
    float _691;
    float _692;
    float _693;
    float _694;
    if (cb0_m13.y != 0u)
    {
        float _520 = 1.0f / cb0_m11.x;
        float _521 = 1.0f / cb0_m11.y;
        float _526 = floor(mad(_507, cb0_m11.x, -0.5f)) + 0.5f;
        float _527 = floor(mad(_508, cb0_m11.y, -0.5f)) + 0.5f;
        float _529 = mad(_508, cb0_m11.y, -_527);
        float _531 = mad(_507, cb0_m11.x, -_526);
        float _532 = _531 * _531;
        float _533 = _529 * _529;
        float _534 = _532 * _531;
        float _535 = _529 * _533;
        float _540 = (mad(_529, _533, _529) * (-0.5f)) + _533;
        float _541 = _532 + (mad(_532, _531, _531) * (-0.5f));
        float _548 = ((_535 * 1.5f) - (_533 * 2.5f)) + 1.0f;
        float _549 = ((_534 * 1.5f) - (_532 * 2.5f)) + 1.0f;
        float _552 = (_534 - _532) * 0.5f;
        float _553 = (_535 - _533) * 0.5f;
        float _560 = mad(_532 - _534, 0.5f, (1.0f - _541) - _549);
        float _561 = mad(_533 - _535, 0.5f, (1.0f - _540) - _548);
        float _562 = _548 + _561;
        float _563 = _560 + _549;
        float _568 = _520 * _526;
        float _569 = _527 * _521;
        float _570 = _520 * (_526 + (_560 / _563));
        float _571 = ((_561 / _562) + _527) * _521;
        float2 _574 = float2(_568, _569);
        float4 _577 = t3.SampleLevel(s0, _574, 0.0f, int2(-1, -1));
        float _582 = _540 * _541;
        float2 _583 = float2(_570, _569);
        float4 _585 = t3.SampleLevel(s0, _583, 0.0f, int2(0, -1));
        float _590 = _540 * _563;
        float _591 = _562 * _541;
        float4 _605 = t3.SampleLevel(s0, _574, 0.0f, int2(2, -1));
        float _610 = _540 * _552;
        float _611 = _553 * _541;
        float2 _616 = float2(_568, _571);
        float4 _618 = t3.SampleLevel(s0, _616, 0.0f, int2(-1, 0));
        float4 _629 = t3.SampleLevel(s0, float2(_570, _571), 0.0f);
        float _634 = _562 * _563;
        float4 _640 = t3.SampleLevel(s0, _616, 0.0f, int2(2, 0));
        float _645 = _552 * _562;
        float _646 = _563 * _553;
        float4 _652 = t3.SampleLevel(s0, _574, 0.0f, int2(-1, 2));
        float4 _662 = t3.SampleLevel(s0, _583, 0.0f, int2(0, 2));
        float4 _672 = t3.SampleLevel(s0, _574, 0.0f, int2(2, 2));
        float _677 = _552 * _553;
        _691 = mad(_672.w, _677, mad(_662.w, _646, mad(_652.w, _611, mad(_645, _640.w, mad(_629.w, _634, mad(_618.w, _591, mad(_610, _605.w, (_577.w * _582) + (_590 * _585.w))))))));
        _692 = mad(_672.z, _677, mad(_662.z, _646, mad(_652.z, _611, mad(_645, _640.z, mad(_629.z, _634, mad(_618.z, _591, mad(_610, _605.z, (_577.z * _582) + (_590 * _585.z))))))));
        _693 = mad(_672.y, _677, mad(_662.y, _646, mad(_652.y, _611, mad(_645, _640.y, mad(_629.y, _634, mad(_618.y, _591, mad(_610, _605.y, (_577.y * _582) + (_590 * _585.y))))))));
        _694 = mad(_672.x, _677, mad(_662.x, _646, mad(_652.x, _611, mad(_645, _640.x, mad(_629.x, _634, mad(_618.x, _591, mad(_610, _605.x, (_590 * _585.x) + (_577.x * _582))))))));
    }
    else
    {
        float4 _686 = t3.SampleLevel(s0, float2(_507, _508), 0.0f);
        _691 = _686.w;
        _692 = _686.z;
        _693 = _686.y;
        _694 = _686.x;
    }
    bool _701 = (cb0_m13.x != 0u) && (_280 != 0u);
    uint _702 = _280 >> 30u;
    bool _704 = (_280 & 536870912u) != 0u;
    bool _708 = ((!_704) && (_702 == 0u)) || ((_280 & 268435456u) != 0u);
    float2 _719 = float2((_261 - _507) * 3840.0f, (_262 - _508) * 2160.0f);
    float _725 = mad(1.25f - exp2(-dp2_f32(_719, _719)), (_704 && (!_708)) ? 0.5f : 1.0f, min(min(_438, _450), min(min(_392, _404), min(min(_342, _354), min(min(_296, _308), _285)))));
    bool _729 = _702 != 0u;
    float _730 = _729 ? (_701 ? _694 : (_454 * 0.111111111938953399658203125f)) : _274;
    float _731 = _729 ? (_701 ? _693 : (_455 * 0.111111111938953399658203125f)) : _286;
    float _732 = _729 ? (_701 ? _692 : (_456 * 0.111111111938953399658203125f)) : _276;
    float _734 = clamp(max(_725, _691), 0.0f, 1.0f);
    float _738 = mad(_734, min(_469, max(_461, _694)) - _730, _730);
    float _739 = mad(_734, min(max(min(min(_437, _449), min(min(_391, _403), min(min(min(_295, _307), _284), min(_341, _353)))), _693), max(max(_437, _449), max(max(_391, _403), max(max(_341, _353), max(_284, max(_295, _307)))))) - _731, _731);
    float _740 = mad(_734, min(max(min(min(_436, _448), min(min(_390, _402), min(min(_340, _352), min(min(_294, _306), _276)))), _692), max(max(_436, _448), max(max(_390, _402), max(max(_340, _352), max(_276, max(_294, _306)))))) - _732, _732);
    bool _741 = max(max(_438, _450), max(max(_392, _404), max(max(_342, _354), max(_285, max(_296, _308))))) == 1.0f;
    float _744 = (_741 || (_691 == 1.0f)) ? 0.800000011920928955078125f : 0.89999997615814208984375f;
    float _747 = (_461 - _469) + 1.0f;
    float _764 = mad(clamp(dp2_f32(((cb0_m14 * (_704 ? 2.0f : float(_729))) * (_729 ? _744 : 0.0f)).xx, (_747 * _747).xx), 0.0f, 1.0f) * 0.25f, clamp(mad(mad(_454, -0.111111111938953399658203125f, _274), 4.0f, _274), 0.0f, 1.0f) - _274, _274);
    float _774 = _708 ? asfloat(cb0_m15) : 0.0f;
    float _775 = mad(mad(_454, 0.111111111938953399658203125f, -_764), _774, _764);
    float _776 = mad(_774, mad(_455, 0.111111111938953399658203125f, -_286), _286);
    float _777 = mad(_774, mad(_456, 0.111111111938953399658203125f, -_276), _276);
    float _779 = (_701 && _729) ? _744 : 0.0f;
    float _783 = mad(_738 - _775, _779, _775);
    float _784 = mad(_739 - _776, _779, _776);
    float _785 = mad(_740 - _777, _779, _777);
    float _795 = _738 + (((_783 - _738) > 0.0f) ? 0.00146484375f : (-0.00146484375f));
    float _796 = (((_784 - _739) > 0.0f) ? 0.00146484375f : (-0.00146484375f)) + _739;
    float _797 = _740 + (((_785 - _740) > 0.0f) ? 0.00146484375f : (-0.00146484375f));
    float _798 = _783 - _795;
    float _799 = _784 - _796;
    float _800 = _785 - _797;
    float _801 = _775 - _783;
    float _802 = _776 - _784;
    float _803 = _777 - _785;
    float _825 = (((_798 + _801) * (_795 - _783)) >= 0.0f) ? _795 : (((_798 * _801) >= 0.0f) ? _783 : _775);
    float _826 = (((_796 - _784) * (_802 + _799)) >= 0.0f) ? _796 : (((_802 * _799) >= 0.0f) ? _784 : _776);
    float _827 = (((_797 - _785) * (_803 + _800)) >= 0.0f) ? _797 : (((_803 * _800) >= 0.0f) ? _785 : _777);
    float _846;
    float _847;
    float _848;
    float _849;
    if (cb0_m19.x != 0u)
    {
        float4 _835 = t3.Load(int3(_278, 0u));
        float _836 = _835.x;
        float _837 = _835.y;
        float _838 = _835.z;
        _846 = 1.0f;
        _847 = mad(_825 - _836, 0.1500000059604644775390625f, _836);
        _848 = mad(_827 - _838, 0.1500000059604644775390625f, _838);
        _849 = mad(_826 - _837, 0.1500000059604644775390625f, _837);
    }
    else
    {
        _846 = _741 ? 1.0f : _725;
        _847 = _825;
        _848 = _827;
        _849 = _826;
    }
    float _855 = mad(-_848, 2.0f, 1.0f);
    float _875 = mad(frac(sin(mad(mad(_254, cb0_m10.y, cb0_m0.y), 543.30999755859375f, mad(_253, cb0_m10.x, cb0_m0.x))) * 493013.0f), cb0_m2.x, cb0_m2.y);
    //if (RENODX_TONE_MAP_TYPE != 0) _875 = 1.0f;
    float _876 = ((_847 + mad(_849, 2.0f, -1.0f)) + _855) * _875;
    float _877 = (_847 + mad(_848, 2.0f, -1.0f)) * _875;
    float _878 = (_855 + (_847 + mad(-_849, 2.0f, 1.0f))) * _875;

    // Invert max-channel Reinhard to restore HDR range. Must use the output peak,
    // not the input scales, because the TAA output blends history with current frame.
    if (RENODX_TONE_MAP_TYPE > 1) {
        float3 _taa_comp = float3(_876, _877, _878) * rcp(_875);
        float _taa_comp_peak = max(max(_taa_comp.r, _taa_comp.g), _taa_comp.b);
        float _taa_inv = rcp(max(1.0f - _taa_comp_peak, 1e-5f));
        _876 = _taa_comp.r * _taa_inv * _875;
        _877 = _taa_comp.g * _taa_inv * _875;
        _878 = _taa_comp.b * _taa_inv * _875;
    }

    // u1 is written in compressed TAA space — consistent with t3 history reads next frame.
    u1[_278] = float4(_825, _826, _827, _846);

    // float2 _887 = float2(mad(_253, cb0_m12.x, -0.5f), mad(_254, cb0_m12.y, -0.5f));
    // float _898 = clamp(cb0_m5.y * exp2(-(cb0_m5.x * (0.5f - dp2_f32(_887, _887)))), 0.0f, 1.0f);
    // float _908 = cb0_m8.x * mad(-cb0_m4, _898, cb0_m4);
    // float _910 = cb0_m4 * (_898 * _898);

    float game_scale = RENODX_TONE_MAP_TYPE > 0 ? 1.0f : cb0_m8.x;
    float2 _887 = float2(mad(_253, cb0_m12.x, -0.5f), mad(_254, cb0_m12.y, -0.5f));
    float _898 = clamp(cb0_m5.y * exp2(-(cb0_m5.x * (0.5f - dp2_f32(_887, _887)))), 0.0f, 1.0f);
    float _908 = game_scale * mad(-cb0_m4, _898, cb0_m4);
    float _910 = cb0_m4 * (_898 * _898);

#if 0 // SDR OUTPUT VALUES (cb0_m11.x instead of cb0_m12.x originally)
    float2 _882 = float2(mad(_248, cb0_m12.x, -0.5f), mad(_254, cb0_m11.y, -0.5f));
    float _893 = clamp(cb0_m5.y * exp2(-(cb0_m5.x * (0.5f - dp2_f32(_882, _882)))), 0.0f, 1.0f);
    float _900 = mad(-cb0_m4, _893, cb0_m4);
    float _902 = cb0_m4 * (_893 * _893);
#endif

    float _934 = mad(frac(sin(mad(mad(_254, cb0_m12.y, cb0_m0.y), 543.30999755859375f, mad(_253, cb0_m12.x, cb0_m0.x))) * 493013.0f), cb0_m2.x, cb0_m2.y);
    //if (RENODX_TONE_MAP_TYPE != 0) _934 = 1.0f;
    float4 _939 = t0.Load(int3(_278, 0u));
    float _949 = 1.0f - _939.w;

    // cb0_m8.y is UI brightness
    // _908 is ITM peak scaling

    // float _953 = (cb0_m8.y * _939.x) + ((mad(cb0_m6.x, _910, mad(_876 * _876, _908, cb0_m3.x)) * _934) * _949);
    // float _954 = ((mad(cb0_m6.y, _910, mad(_877 * _877, _908, cb0_m3.y)) * _934) * _949) + (cb0_m8.y * _939.y);
    // float _955 = ((mad(_910, cb0_m6.z, mad(_878 * _878, _908, cb0_m3.z)) * _934) * _949) + (cb0_m8.y * _939.z);

    //     float3 scene_pre_ui = float3(
    //                               mad(cb0_m6.x, _910, mad(_876 * _876, _908, cb0_m3.x)),
    //                               mad(cb0_m6.y, _910, mad(_877 * _877, _908, cb0_m3.y)),
    //                               mad(cb0_m6.z, _910, mad(_878 * _878, _908, cb0_m3.z))
    // ) * _934;
    if (RENODX_TONE_MAP_TYPE > 1) {
      float3 scene_pre_ui = mad(cb0_m6.xyz, _910, (mad(float3(_876 * _876, _877 * _877, _878 * _878), _908, cb0_m3.xyz)) * _934);
      float4 final_linear;
    //   final_linear = float4(scene_pre_ui, 1.f);
    //   final_linear.xyz = renodx::color::pq::EncodeSafe(final_linear.xyz, RENODX_DIFFUSE_WHITE_NITS);
      HandleUICompositing(_939, scene_pre_ui, final_linear, uv);
      // float3 final_linear = _939.rgb + scene_pre_ui * (1 - _939.a);
      u0[_278] = final_linear;
    }  
    else if (RENODX_TONE_MAP_TYPE == 1) {
      //   float _953 = (_939.x) + ((mad(cb0_m6.x, _910, mad(_876 * _876, 1.f, cb0_m3.x)) * _934) * _949);
      //   float _954 = ((mad(cb0_m6.y, _910, mad(_877 * _877, 1.f, cb0_m3.y)) * _934) * _949) + (_939.y);
      //   float _955 = ((mad(_910, cb0_m6.z, mad(_878 * _878, 1.f, cb0_m3.z)) * _934) * _949) + (_939.z);
        float3 scene_pre_ui = mad(cb0_m6.xyz, _910, (mad(float3(_876 * _876, _877 * _877, _878 * _878), _908, cb0_m3.xyz)) * _934);
          //   float _983 = exp2(log2(abs((scene_pre_ui.x * 0.0199999995529651641845703125f) + ((exp2(scene_pre_ui.x * (-40.95999908447265625f)) - 1.0f) * 0.0004499999922700226306915283203125f))) * 0.1593017578125f);
          //   float _984 = exp2(log2(abs((scene_pre_ui.y * 0.0199999995529651641845703125f) + ((exp2(scene_pre_ui.y * (-40.95999908447265625f)) - 1.0f) * 0.0004499999922700226306915283203125f))) * 0.1593017578125f);
          //   float _985 = exp2(log2(abs((scene_pre_ui.z * 0.0199999995529651641845703125f) + ((exp2(scene_pre_ui.z * (-40.95999908447265625f)) - 1.0f) * 0.0004499999922700226306915283203125f))) * 0.1593017578125f);
        float3 final_linear = _939.rgb + scene_pre_ui * (1 - _939.a);
          // float _1001 = exp2(log2(mad(_983, 18.8515625f, 0.8359375f) / mad(_983, 18.6875f, 1.0f)) * 78.84375f);
          //  u0[_278] = float4(_1001, exp2(log2(mad(_984, 18.8515625f, 0.8359375f) / mad(_984, 18.6875f, 1.0f)) * 78.84375f), exp2(log2(mad(_985, 18.8515625f, 0.8359375f) / mad(_985, 18.6875f, 1.0f)) * 78.84375f), _1001);
          float3 pq_color = renodx::color::pq::Encode(final_linear, RENODX_DIFFUSE_WHITE_NITS);
      u0[_278] = float4(pq_color, pq_color.x);
    } else {
      float _953 = (cb0_m8.y * _939.x) + ((mad(cb0_m6.x, _910, mad(_876 * _876, _908, cb0_m3.x)) * _934) * _949);
      float _954 = ((mad(cb0_m6.y, _910, mad(_877 * _877, _908, cb0_m3.y)) * _934) * _949) + (cb0_m8.y * _939.y);
      float _955 = ((mad(_910, cb0_m6.z, mad(_878 * _878, _908, cb0_m3.z)) * _934) * _949) + (cb0_m8.y * _939.z);
      float3 final_linear = float3(_953, _954, _955);
      float _983 = exp2(log2(abs((final_linear.x * 0.0199999995529651641845703125f) + ((exp2(final_linear.x * (-40.95999908447265625f)) - 1.0f) * 0.0004499999922700226306915283203125f))) * 0.1593017578125f);
      float _984 = exp2(log2(abs((final_linear.y * 0.0199999995529651641845703125f) + ((exp2(final_linear.y * (-40.95999908447265625f)) - 1.0f) * 0.0004499999922700226306915283203125f))) * 0.1593017578125f);
      float _985 = exp2(log2(abs((final_linear.z * 0.0199999995529651641845703125f) + ((exp2(final_linear.z * (-40.95999908447265625f)) - 1.0f) * 0.0004499999922700226306915283203125f))) * 0.1593017578125f);
      float _1001 = exp2(log2(mad(_983, 18.8515625f, 0.8359375f) / mad(_983, 18.6875f, 1.0f)) * 78.84375f);
      u0[_278] = float4(_1001, exp2(log2(mad(_984, 18.8515625f, 0.8359375f) / mad(_984, 18.6875f, 1.0f)) * 78.84375f), exp2(log2(mad(_985, 18.8515625f, 0.8359375f) / mad(_985, 18.6875f, 1.0f)) * 78.84375f), _1001);
    }


    // float _983 = exp2(log2(abs((final_linear.x * 0.0199999995529651641845703125f) + ((exp2(final_linear.x * (-40.95999908447265625f)) - 1.0f) * 0.0004499999922700226306915283203125f))) * 0.1593017578125f);
    // float _984 = exp2(log2(abs((final_linear.y * 0.0199999995529651641845703125f) + ((exp2(final_linear.y * (-40.95999908447265625f)) - 1.0f) * 0.0004499999922700226306915283203125f))) * 0.1593017578125f);
    // float _985 = exp2(log2(abs((final_linear.z * 0.0199999995529651641845703125f) + ((exp2(final_linear.z * (-40.95999908447265625f)) - 1.0f) * 0.0004499999922700226306915283203125f))) * 0.1593017578125f);
    // float _1001 = exp2(log2(mad(_983, 18.8515625f, 0.8359375f) / mad(_983, 18.6875f, 1.0f)) * 78.84375f);
    // u0[_278] = float4(_1001, exp2(log2(mad(_984, 18.8515625f, 0.8359375f) / mad(_984, 18.6875f, 1.0f)) * 78.84375f), exp2(log2(mad(_985, 18.8515625f, 0.8359375f) / mad(_985, 18.6875f, 1.0f)) * 78.84375f), _1001);
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}

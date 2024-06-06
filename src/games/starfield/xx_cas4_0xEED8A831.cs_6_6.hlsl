cbuffer _16_18 : register(b0, space6)
{
    float4 _18_m0[9] : packoffset(c0);
};

cbuffer _21_23 : register(b0, space8)
{
    float4 _23_m0[4] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space8);
RWTexture2D<float4> _11 : register(u0, space8);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

uint spvPackHalf2x16(float2 value)
{
    uint2 Packed = f32tof16(value);
    return Packed.x | (Packed.y << 16);
}

float2 spvUnpackHalf2x16(uint value)
{
    return f16tof32(uint2(value & 0xffff, value >> 16));
}

void comp_main()
{
    uint4 _55 = asuint(_23_m0[2u]);
    uint _58 = _55.x + (((gl_LocalInvocationID.x >> 1u) & 7u) | (gl_WorkGroupID.x << 4u));
    uint _59 = ((((gl_LocalInvocationID.x >> 3u) & 6u) | (gl_LocalInvocationID.x & 1u)) | (gl_WorkGroupID.y << 4u)) + _55.y;
    uint4 _69 = asuint(_23_m0[3u]);
    uint _70 = _69.x;
    uint _71 = _69.y;
    uint _72 = _69.z;
    uint _73 = _69.w;
    uint _74 = _58 << 16u;
    uint _76 = uint(int(_74) >> int(16u));
    uint _77 = _59 << 16u;
    uint _87 = uint(int(max(min(_76, _72), _70) << 16u) >> int(16u));
    uint _89 = uint(int(max(min(uint(int(_77 + 4294901760u) >> int(16u)), _73), _71) << 16u) >> int(16u));
    float4 _91 = _8.Load(int3(uint2(_87, _89), 0u));
    float _94 = _91.x;
    float _95 = _91.y;
    float _96 = _91.z;
    uint _98 = uint(int(_74 + 4294901760u) >> int(16u));
    uint _107 = uint(int(max(min(uint(int(_77) >> int(16u)), _73), _71) << 16u) >> int(16u));
    float4 _108 = _8.Load(int3(uint2(uint(int(max(min(_98, _72), _70) << 16u) >> int(16u)), _107), 0u));
    float _110 = _108.x;
    float _111 = _108.y;
    float _112 = _108.z;
    float4 _113 = _8.Load(int3(uint2(_87, _107), 0u));
    float _115 = _113.x;
    float _116 = _113.y;
    float _117 = _113.z;
    uint _120 = uint(int(_74 + 65536u) >> int(16u));
    float4 _125 = _8.Load(int3(uint2(uint(int(max(min(_120, _72), _70) << 16u) >> int(16u)), _107), 0u));
    float _127 = _125.x;
    float _128 = _125.y;
    float _129 = _125.z;
    uint _135 = uint(int(max(min(uint(int(_77 + 65536u) >> int(16u)), _73), _71) << 16u) >> int(16u));
    float4 _136 = _8.Load(int3(uint2(_87, _135), 0u));
    float _138 = _136.x;
    float _139 = _136.y;
    float _140 = _136.z;
    uint _144 = uint(int((_58 << 16u) + 524288u) >> int(16u));
    uint _148 = uint(int(max(min(_144, _72), _70) << 16u) >> int(16u));
    float4 _149 = _8.Load(int3(uint2(_148, _89), 0u));
    float _151 = _149.x;
    float _152 = _149.y;
    float _153 = _149.z;
    uint _156 = uint(int(_74 + 458752u) >> int(16u));
    float4 _161 = _8.Load(int3(uint2(uint(int(max(min(_156, _72), _70) << 16u) >> int(16u)), _107), 0u));
    float _163 = _161.x;
    float _164 = _161.y;
    float _165 = _161.z;
    float4 _166 = _8.Load(int3(uint2(_148, _107), 0u));
    float _168 = _166.x;
    float _169 = _166.y;
    float _170 = _166.z;
    uint _173 = uint(int(_74 + 589824u) >> int(16u));
    float4 _178 = _8.Load(int3(uint2(uint(int(max(min(_173, _72), _70) << 16u) >> int(16u)), _107), 0u));
    float _180 = _178.x;
    float _181 = _178.y;
    float _182 = _178.z;
    float4 _183 = _8.Load(int3(uint2(_148, _135), 0u));
    float _185 = _183.x;
    float _186 = _183.y;
    float _187 = _183.z;
    float _214 = min(1.0f, _95 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_95 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _215 = min(1.0f, _152 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_152 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _246 = min(1.0f, _111 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_111 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _247 = min(1.0f, _164 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_164 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _278 = min(1.0f, _116 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_116 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _279 = min(1.0f, _169 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_169 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _310 = min(1.0f, _128 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_128 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _311 = min(1.0f, _181 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_181 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _342 = min(1.0f, _139 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_139 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _343 = min(1.0f, _186 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_186 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _366 = max(max(_310, _342), max(max(_214, _246), _278));
    float _367 = max(max(_311, _343), max(max(_215, _247), _279));
    float2 _384 = spvUnpackHalf2x16(asuint(_23_m0[1u]).y & 65535u);
    float _385 = _384.x;
    float _386 = _385 * sqrt(clamp(min(min(min(_310, _342), min(min(_214, _246), _278)), 1.0f - _366) * (1.0f / _366), 0.0f, 1.0f));
    float _387 = _385 * sqrt(clamp(min(min(min(_311, _343), min(min(_215, _247), _279)), 1.0f - _367) * (1.0f / _367), 0.0f, 1.0f));
    float _393 = 1.0f / ((_386 * 4.0f) + 1.0f);
    float _394 = 1.0f / ((_387 * 4.0f) + 1.0f);
    float _416 = max(_18_m0[1u].w, 0.00100040435791015625f);
    if ((_58 <= _55.z) && (_59 <= _55.w))
    {
        float _472 = 1.0f / _416;
        _11[uint2(_58, _59)] = float4(max((exp2(_472 * log2(clamp(((min(1.0f, _115 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_115 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (((((min(1.0f, _110 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_110 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (min(1.0f, _94 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_94 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _127 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_127 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _138 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_138 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) * _386)) * _393, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), max((exp2(_472 * log2(clamp(((_386 * (((_246 + _214) + _310) + _342)) + _278) * _393, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), max((exp2(_472 * log2(clamp(((min(1.0f, _117 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_117 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (((((min(1.0f, _112 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_112 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (min(1.0f, _96 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_96 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _129 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_129 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _140 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_140 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) * _386)) * _393, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), 1.0f);
    }
    uint _549 = _58 + 8u;
    uint4 _553 = asuint(_23_m0[2u]);
    if ((_549 <= _553.z) && (_59 <= _553.w))
    {
        float _560 = 1.0f / _416;
        _11[uint2(_549, _59)] = float4(max((exp2(_560 * log2(clamp(((_387 * ((((min(1.0f, _163 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_163 + 0.05499267578125f) * 0.94775390625f))) + (min(1.0f, _151 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_151 + 0.05499267578125f) * 0.94775390625f)))) + (min(1.0f, _180 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_180 + 0.05499267578125f) * 0.94775390625f)))) + (min(1.0f, _185 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_185 + 0.05499267578125f) * 0.94775390625f))))) + (min(1.0f, _168 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_168 + 0.05499267578125f) * 0.94775390625f)))) * _394, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), max((exp2(_560 * log2(clamp(((_387 * (((_247 + _215) + _311) + _343)) + _279) * _394, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), max((exp2(_560 * log2(clamp(((_387 * ((((min(1.0f, _165 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_165 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (min(1.0f, _153 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_153 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _182 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_182 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _187 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_187 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)))) + (min(1.0f, _170 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_170 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) * _394, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), 1.0f);
    }
    uint _581 = _59 + 8u;
    uint4 _584 = asuint(_23_m0[3u]);
    uint _585 = _584.x;
    uint _586 = _584.y;
    uint _587 = _584.z;
    uint _588 = _584.w;
    uint _589 = _581 << 16u;
    uint _597 = uint(int(max(min(_76, _587), _585) << 16u) >> int(16u));
    uint _599 = uint(int(max(min(uint(int(_589 + 4294901760u) >> int(16u)), _588), _586) << 16u) >> int(16u));
    float4 _601 = _8.Load(int3(uint2(_597, _599), 0u));
    float _603 = _601.x;
    float _604 = _601.y;
    float _605 = _601.z;
    uint _614 = uint(int(max(min(uint(int(_589) >> int(16u)), _588), _586) << 16u) >> int(16u));
    float4 _615 = _8.Load(int3(uint2(uint(int(max(min(_98, _587), _585) << 16u) >> int(16u)), _614), 0u));
    float _617 = _615.x;
    float _618 = _615.y;
    float _619 = _615.z;
    float4 _620 = _8.Load(int3(uint2(_597, _614), 0u));
    float _622 = _620.x;
    float _623 = _620.y;
    float _624 = _620.z;
    float4 _629 = _8.Load(int3(uint2(uint(int(max(min(_120, _587), _585) << 16u) >> int(16u)), _614), 0u));
    float _631 = _629.x;
    float _632 = _629.y;
    float _633 = _629.z;
    uint _639 = uint(int(max(min(uint(int(_589 + 65536u) >> int(16u)), _588), _586) << 16u) >> int(16u));
    float4 _640 = _8.Load(int3(uint2(_597, _639), 0u));
    float _642 = _640.x;
    float _643 = _640.y;
    float _644 = _640.z;
    uint _648 = uint(int(max(min(_144, _587), _585) << 16u) >> int(16u));
    float4 _649 = _8.Load(int3(uint2(_648, _599), 0u));
    float _651 = _649.x;
    float _652 = _649.y;
    float _653 = _649.z;
    float4 _658 = _8.Load(int3(uint2(uint(int(max(min(_156, _587), _585) << 16u) >> int(16u)), _614), 0u));
    float _660 = _658.x;
    float _661 = _658.y;
    float _662 = _658.z;
    float4 _663 = _8.Load(int3(uint2(_648, _614), 0u));
    float _665 = _663.x;
    float _666 = _663.y;
    float _667 = _663.z;
    float4 _672 = _8.Load(int3(uint2(uint(int(max(min(_173, _587), _585) << 16u) >> int(16u)), _614), 0u));
    float _674 = _672.x;
    float _675 = _672.y;
    float _676 = _672.z;
    float4 _677 = _8.Load(int3(uint2(_648, _639), 0u));
    float _679 = _677.x;
    float _680 = _677.y;
    float _681 = _677.z;
    float _707 = min(1.0f, _604 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_604 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _708 = min(1.0f, _652 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_652 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _739 = min(1.0f, _618 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_618 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _740 = min(1.0f, _661 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_661 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _771 = min(1.0f, _623 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_623 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _772 = min(1.0f, _666 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_666 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _803 = min(1.0f, _632 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_632 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _804 = min(1.0f, _675 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_675 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _835 = min(1.0f, _643 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_643 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _836 = min(1.0f, _680 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_680 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w);
    float _859 = max(max(_803, _835), max(max(_707, _739), _771));
    float _860 = max(max(_804, _836), max(max(_708, _740), _772));
    float _873 = _385 * sqrt(clamp(min(min(min(_803, _835), min(min(_707, _739), _771)), 1.0f - _859) * (1.0f / _859), 0.0f, 1.0f));
    float _874 = _385 * sqrt(clamp(min(min(min(_804, _836), min(min(_708, _740), _772)), 1.0f - _860) * (1.0f / _860), 0.0f, 1.0f));
    float _879 = 1.0f / ((_873 * 4.0f) + 1.0f);
    float _880 = 1.0f / ((_874 * 4.0f) + 1.0f);
    uint4 _904 = asuint(_23_m0[2u]);
    if ((_58 <= _904.z) && (_581 <= _904.w))
    {
        float _958 = 1.0f / _416;
        _11[uint2(_58, _581)] = float4(max((exp2(_958 * log2(clamp(((min(1.0f, _622 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_622 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (((((min(1.0f, _617 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_617 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (min(1.0f, _603 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_603 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _631 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_631 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _642 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_642 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) * _873)) * _879, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), max((exp2(_958 * log2(clamp(((_873 * (((_739 + _707) + _803) + _835)) + _771) * _879, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), max((exp2(_958 * log2(clamp(((min(1.0f, _624 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_624 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (((((min(1.0f, _619 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_619 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (min(1.0f, _605 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_605 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _633 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_633 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _644 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_644 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) * _873)) * _879, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), 1.0f);
    }
    uint4 _1035 = asuint(_23_m0[2u]);
    if ((_549 <= _1035.z) && (_581 <= _1035.w))
    {
        float _1042 = 1.0f / _416;
        _11[uint2(_549, _581)] = float4(max((exp2(_1042 * log2(clamp(((_874 * ((((min(1.0f, _660 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_660 + 0.05499267578125f) * 0.94775390625f))) + (min(1.0f, _651 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_651 + 0.05499267578125f) * 0.94775390625f)))) + (min(1.0f, _674 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_674 + 0.05499267578125f) * 0.94775390625f)))) + (min(1.0f, _679 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_679 + 0.05499267578125f) * 0.94775390625f))))) + (min(1.0f, _665 * asfloat(0x7f800000u /* inf */)) * exp2(_18_m0[1u].w * log2((_665 + 0.05499267578125f) * 0.94775390625f)))) * _880, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), max((exp2(_1042 * log2(clamp(((_874 * (((_740 + _708) + _804) + _836)) + _772) * _880, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), max((exp2(_1042 * log2(clamp(((_874 * ((((min(1.0f, _662 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_662 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)) + (min(1.0f, _653 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_653 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _676 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_676 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) + (min(1.0f, _681 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_681 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w)))) + (min(1.0f, _667 * asfloat(0x7f800000u /* inf */)) * exp2(log2((_667 + 0.05499267578125f) * 0.94775390625f) * _18_m0[1u].w))) * _880, 0.0f, 1.0f))) * 1.0546875f) + (-0.05499267578125f), 0.0f), 1.0f);
    }
}

[numthreads(64, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    comp_main();
}

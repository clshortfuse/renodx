#include "../../common.hlsli"

static const float4 _73[5] = { float4(1.0f, 0.0f, 0.0f, 0.0f), float4(0.0f, 1.0f, 0.0f, 0.0f), float4(0.0f, 0.0f, 1.0f, 0.0f), float4(0.0f, 0.0f, 0.0f, 1.0f), 0.0f.xxxx };

cbuffer cb0_buf : register(b0){
    int4 cb0_m0 : packoffset(c0);
    int2 cb0_m1 : packoffset(c1);
    uint2 cb0_m2 : packoffset(c1.z);
    uint4 cb0_m3 : packoffset(c2);
    float2 cb0_m4 : packoffset(c3);
    float2 cb0_m5 : packoffset(c3.z);
    uint2 cb0_m6 : packoffset(c4);
    float2 cb0_m7 : packoffset(c4.z);
    uint2 cb0_m8 : packoffset(c5);
    float2 cb0_m9 : packoffset(c5.z);
    float4 cb0_m10 : packoffset(c6);
    float4 cb0_m11 : packoffset(c7);
};

SamplerState s1 : register(s1);
Texture2D<uint4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t9 : register(t9);
RWTexture2D<float4> u0 : register(u0);
RWTexture2D<float4> u1 : register(u1);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp2_f32(float2 a, float2 b)
{
    precise float _142 = a.x * b.x;
    return mad(a.y, b.y, _142);
}

int cvt_f32_i32(float v)
{
    return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _113 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _113)));
}

float dp3_f32(float3 a, float3 b)
{
    precise float _98 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _98));
}

void comp_main()
{
    float _168 = float(cb0_m0.x);
    float _169 = float(cb0_m0.y);
    float _172 = (float(int(gl_GlobalInvocationID.x)) + 0.5f) / _168;
    float _173 = (float(int(gl_GlobalInvocationID.y)) + 0.5f) / _169;
    uint2 _175 = uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y);
    float4 _176 = t1.Load(int3(_175, 0u));
    float _177 = _176.x;
    float _178 = _176.y;
    float2 _188 = float2(float(cb0_m1.x) * _177, _178 * float(cb0_m1.y));
    float _190 = sqrt(dp2_f32(_188, _188));
    float _193 = float(_190 > 0.00999999977648258209228515625f);
    float4 _197 = t2.Load(int3(_175, 0u));
    float _198 = _197.x;
    float _205 = cb0_m4.y / (_198 - cb0_m4.x);
    float _206 = mad(_168, mad(_177, _193, _172), -0.5f);
    float _207 = mad(mad(_178, _193, _173), _169, -0.5f);
    float _208 = floor(_206);
    float _209 = floor(_207);
    int _210 = cvt_f32_i32(_208);
    int _211 = cvt_f32_i32(_209);
    float _212 = _206 - _208;
    float _213 = _207 - _209;
    float _216 = (_209 - _207) + 1.0f;
    float _217 = (_208 - _206) + 1.0f;
    float _218 = _216 * _217;
    float _219 = _212 * _216;
    float _220 = _213 * _217;
    float _221 = _212 * _213;
    float _235 = cb0_m5.x * mad(trunc(_168 * 0.5f) / _168, 2.0f, -1.0f);
    float _236 = mad(trunc(_169 * 0.5f) / _169, -2.0f, 1.0f) * cb0_m5.y;
    float2 _237 = float2(_168, _169);
    float _239 = sqrt(dp2_f32(_237, _237));
    float _242 = mad(min(_239 * 0.00045394556946121156215667724609375f, 1.0f), 2.0f, 1.0f);
    uint _244;
    uint _247;
    _244 = 0u;
    _247 = 0u;
    uint _250;
    uint _245;
    uint _248;
    uint _249 = 0u;
    for (;;)
    {
        if (int(_249) >= 4)
        {
            break;
        }
        uint _261 = uint(_210 + int(_249 & 1u));
        uint _264 = uint(((_249 < 2u) ? 0 : 1) + _211);
        if ((_261 < uint(cb0_m0.x)) && (_264 < uint(cb0_m0.y)))
        {
            uint _277 = min(_249, 4u);
            float _294 = dp4_f32(float4(_218, _219, _220, _221), float4(_73[_277].x, _73[_277].y, _73[_277].z, _73[_277].w));
            uint _345;
            uint _346;
            if (_294 > 0.00999999977648258209228515625f)
            {
                float _302 = asfloat(t0.Load(int3(uint2(_261, _264), 0u)).x);
                float _304 = cb0_m4.y / (_302 - cb0_m4.x);
                float _305 = _205 - _304;
                uint _343;
                uint _344;
                if (_305 > 0.0f)
                {
                    float _311 = cb0_m4.y / (min(_198, _302) - cb0_m4.x);
                    float3 _322 = float3(-(_311 * cb0_m5.x), _311 * cb0_m5.y, _311);
                    float3 _325 = float3(_235 * _311, _311 * _236, _311);
                    _343 = asuint(mad(_294, exp2(_242 * log2(clamp(((max(_205, _304) * (_239 * (sqrt(dp3_f32(_322, _322)) / sqrt(dp3_f32(_325, _325))))) * 1.3699999726668465882539749145508e-05f) / _305, 0.0f, 1.0f))), asfloat(_247)));
                    _344 = asuint(_294 + asfloat(_244));
                }
                else
                {
                    _343 = _247;
                    _344 = _244;
                }
                _345 = _343;
                _346 = _344;
            }
            else
            {
                _345 = _247;
                _346 = _244;
            }
            _248 = _345;
            _245 = _346;
        }
        else
        {
            _248 = _247;
            _245 = _244;
        }
        _250 = _249 + 1u;
        _244 = _245;
        _247 = _248;
        _249 = _250;
        continue;
    }
    float _347 = asfloat(_244);
    uint _353 = gl_GlobalInvocationID.y + 1u;
    uint _354 = gl_GlobalInvocationID.y - 1u;
    float _366 = cb0_m4.y / (asfloat(t0.Load(int3(_175, 0u)).x) - cb0_m4.x);
    float _372 = cb0_m4.y / (asfloat(t0.Load(int3(uint2(gl_GlobalInvocationID.x, _353), 0u)).x) - cb0_m4.x);
    float4 _384 = t7.Load(int3(_175, 0u));
    float _385 = _384.x;
    float4 _392 = t9.Load(int3(uint2(0u, 0u), 0u));
    float _393 = _392.x;
    float _395 = (_393 == 0.0f) ? 1.0f : _393;
    float _404;
    float _406;
    float _408;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
    _404 = clamp((max(_385, 0.0f) / cb0_m10.x) * _395, 0.0f, 65504.0f);
    _406 = clamp((max(_384.z, 0.0f) / cb0_m10.x) * _395, 0.0f, 65504.0f);
    _408 = clamp((max(_384.y, 0.0f) / cb0_m10.x) * _395, 0.0f, 65504.0f) * 0.5f;
    } else {
    _404 = (_385 / cb0_m10.x) * _395;
    _406 = (_384.z / cb0_m10.x) * _395;
    _408 = ((_384.y / cb0_m10.x) * _395) * 0.5f;
    }
    u1[_175] = float4(mad(_406, 0.25f, _408 + (_404 * 0.25f)), (_404 * 0.5f) - (_406 * 0.5f), mad(_406, -0.25f, _408 + (_404 * (-0.25f))), (((((cb0_m4.y / (asfloat(t0.Load(int3(uint2(gl_GlobalInvocationID.x, _354), 0u)).x) - cb0_m4.x)) - _366) > (_366 * 0.00999999977648258209228515625f)) && ((_366 - _372) > (_372 * 0.00999999977648258209228515625f))) ? 0.0f : 1.0f) * ((_347 > 0.0f) ? clamp(1.0f - (asfloat(_247) / _347), 0.0f, 1.0f) : 0.0f));
    float4 _420 = t6.Load(int3(_175, 0u));
    float _432 = mad(_420.x, cb0_m7.x, -cb0_m9.x);
    float _434 = mad(_420.y, cb0_m7.y, -cb0_m9.y);
    float2 _437 = float2(_168 * _432, _434 * _169);
    float2 _439 = float2(_432, _434);
    float _442 = sqrt(dp2_f32(_439, _439));
    uint _443 = asuint(_442);
    float _527;
    float _528;
    if (sqrt(dp2_f32(_437, _437)) > 0.00999999977648258209228515625f)
    {
        int _452 = cb0_m0.x - 1;
        int _453 = cb0_m0.y - 1;
        uint _461;
        uint _456;
        uint _459;
        uint _455 = _443;
        uint _458 = 1065353216u;
        uint _460 = 4294967295u;
        float _462;
        float _463;
        for (;;)
        {
            _462 = asfloat(_458);
            _463 = asfloat(_455);
            int _466 = int(_460);
            if (_466 > 1)
            {
                break;
            }
            bool _470 = _466 < 0;
            bool _471 = _466 > 0;
            _459 = _458;
            _456 = _455;
            uint _473;
            uint _475;
            uint _477;
            uint _476 = 4294967295u;
            for (;;)
            {
                int _480 = int(_476);
                if (_480 > 1)
                {
                    break;
                }
                uint _484 = gl_GlobalInvocationID.x + _476;
                uint _485 = gl_GlobalInvocationID.y + _460;
                int _486 = int(_484);
                int _487 = int(_485);
                bool _488 = _480 < 0;
                int _489 = max(_486, 0);
                int _490 = max(_487, 0);
                float4 _505 = t6.Load(int3(uint2((_480 > 0) ? uint(min(_452, (_488 ? _489 : _486))) : (_488 ? uint(_489) : _484), _471 ? uint(min(_453, (_470 ? _490 : _487))) : (_470 ? uint(_490) : _485)), 0u));
                float _509 = mad(cb0_m7.x, _505.x, -cb0_m9.x);
                float _511 = mad(_505.y, cb0_m7.y, -cb0_m9.y);
                float2 _512 = float2(_509, _511);
                float _514 = sqrt(dp2_f32(_512, _512));
                float _516 = max(_514, asfloat(_456));
                _475 = asuint(_516);
                float _517 = max(_514, _516);
                _473 = asuint(min(dp2_f32(float2(_509 / _517, _511 / _517), float2(_432 / _517, _434 / _517)), asfloat(_459)));
                _477 = _476 + 1u;
                _459 = _473;
                _456 = _475;
                _476 = _477;
                continue;
            }
            _461 = _460 + 1u;
            _455 = _456;
            _458 = _459;
            _460 = _461;
            continue;
        }
        _527 = _463;
        _528 = _462;
    }
    else
    {
        _527 = _442;
        _528 = 1.0f;
    }
    float2 _554 = float2(t5.SampleLevel(s1, float2(max(min(_168 * (_172 + _177), _168 - 0.5f), 0.5f) / float(cb0_m0.z), max(min(_169 - 0.5f, _169 * (_178 + _173)), 0.5f) / float(cb0_m0.w)), 0.0f).xy);
    float2 _556 = float2(_177, _178);
    float _563 = _190 * 0.0500000007450580596923828125f;
    float _572 = -((cb0_m4.y / cb0_m4.x) * cb0_m11.z);
    uint _575;
    uint _578;
    uint _580;
    _575 = 0u;
    _578 = asuint(_572);
    _580 = 0u;
    uint _583;
    uint _576;
    uint _579;
    uint _581;
    uint _582 = 4294967295u;
    for (;;)
    {
        if (int(_582) >= 2)
        {
            break;
        }
        _581 = _580;
        _579 = _578;
        _576 = _575;
        uint _591;
        uint _593;
        uint _594;
        uint _596;
        uint _595 = 4294967295u;
        for (;;)
        {
            if (int(_595) >= 2)
            {
                break;
            }
            uint _603 = gl_GlobalInvocationID.x + _595;
            uint _604 = gl_GlobalInvocationID.y + _582;
            float _621 = ((cb0_m4.y / (t2.Load(int3(uint2(_603, _604), 0u)).x - cb0_m4.x)) * cb0_m11.z) * float((_603 < uint(cb0_m0.x)) && (uint(cb0_m0.y) > _604));
            _594 = (_572 == _621) ? (_576 | 1u) : _576;
            _593 = asuint(min(_621, asfloat(_579)));
            _591 = asuint(max(_621, asfloat(_581)));
            _596 = _595 + 1u;
            _581 = _591;
            _579 = _593;
            _576 = _594;
            _595 = _596;
            continue;
        }
        _583 = _582 + 1u;
        _575 = _576;
        _578 = _579;
        _580 = _581;
        _582 = _583;
        continue;
    }
    float _637 = max(clamp(1.0f - _528, 0.0f, 1.0f) * clamp(_527 * 100.0f, 0.0f, 1.0f), clamp(mad((asfloat(_578) / asfloat(_580)) - 1.0f, (_575 != 0u) ? 0.0f : 1.0f, (_190 > 1.0f) ? ((1.0f - min(sqrt(dp2_f32(_554, _554)) / sqrt(dp2_f32(_556, _556)), 1.0f)) * min(_563 * (_563 * _563), 1.0f)) : 0.0f), 0.0f, 1.0f));
    uint _645 = uint(max(int(gl_GlobalInvocationID.x - 1u), 0));
    uint _646 = uint(max(int(_354), 0));
    uint2 _647 = uint2(_645, _646);
    float4 _648 = t3.Load(int3(_647, 0u));
    float _649 = _648.x;
    float4 _651 = t4.Load(int3(_647, 0u));
    float _652 = _651.x;
    uint2 _654 = uint2(gl_GlobalInvocationID.x, _646);
    float4 _655 = t3.Load(int3(_654, 0u));
    float _656 = _655.x;
    float4 _657 = t4.Load(int3(_654, 0u));
    float _658 = _657.x;
    uint _669 = uint(min((cb0_m0.x - 1), int(gl_GlobalInvocationID.x + 1u)));
    uint2 _670 = uint2(_669, _646);
    float4 _671 = t3.Load(int3(_670, 0u));
    float _672 = _671.x;
    float4 _673 = t4.Load(int3(_670, 0u));
    float _674 = _673.x;
    uint2 _677 = uint2(_645, gl_GlobalInvocationID.y);
    float4 _678 = t3.Load(int3(_677, 0u));
    float _679 = _678.x;
    float4 _680 = t4.Load(int3(_677, 0u));
    float _681 = _680.x;
    float4 _684 = t3.Load(int3(_175, 0u));
    float _685 = _684.x;
    float4 _686 = t4.Load(int3(_175, 0u));
    float _687 = _686.x;
    uint2 _690 = uint2(_669, gl_GlobalInvocationID.y);
    float4 _691 = t3.Load(int3(_690, 0u));
    float _692 = _691.x;
    float4 _693 = t4.Load(int3(_690, 0u));
    float _694 = _693.x;
    uint _699 = uint(min((cb0_m0.y - 1), int(_353)));
    uint2 _700 = uint2(_645, _699);
    float4 _701 = t3.Load(int3(_700, 0u));
    float _702 = _701.x;
    float4 _703 = t4.Load(int3(_700, 0u));
    float _704 = _703.x;
    uint2 _707 = uint2(gl_GlobalInvocationID.x, _699);
    float4 _708 = t3.Load(int3(_707, 0u));
    float _709 = _708.x;
    float4 _710 = t4.Load(int3(_707, 0u));
    float _711 = _710.x;
    uint2 _714 = uint2(_669, _699);
    float4 _715 = t3.Load(int3(_714, 0u));
    float _716 = _715.x;
    float4 _717 = t4.Load(int3(_714, 0u));
    float _718 = _717.x;
    float _881;
    float _882;
    if ((((((((((_649 + _652) + (_656 + _658)) + (_672 + _674)) + (_679 + _681)) + (_685 + _687)) + (_692 + _694)) + (_702 + _704)) + (_709 + _711)) + (_716 + _718)) > 0.0f)
    {
        float3 _757 = float3(_385, _384.yz);
        float _758 = dp3_f32(_757, _757);
        float3 _759 = float3(t7.Load(int3(_647, 0u)).xyz);
        float _764 = mad(dp3_f32(_757, _759) / max(_758, dp3_f32(_759, _759)), -6.0f, 7.0f);
        float3 _773 = float3(t7.Load(int3(_654, 0u)).xyz);
        float _778 = mad(dp3_f32(_757, _773) / max(_758, dp3_f32(_773, _773)), -6.0f, 7.0f);
        float3 _787 = float3(t7.Load(int3(_670, 0u)).xyz);
        float _792 = mad(dp3_f32(_757, _787) / max(_758, dp3_f32(_787, _787)), -6.0f, 7.0f);
        float3 _801 = float3(t7.Load(int3(_677, 0u)).xyz);
        float _806 = mad(dp3_f32(_757, _801) / max(_758, dp3_f32(_801, _801)), -6.0f, 7.0f);
        float _816 = mad(_758 / _758, -6.0f, 7.0f);
        float3 _825 = float3(t7.Load(int3(_690, 0u)).xyz);
        float _830 = mad(dp3_f32(_757, _825) / max(_758, dp3_f32(_825, _825)), -6.0f, 7.0f);
        float3 _839 = float3(t7.Load(int3(_700, 0u)).xyz);
        float _844 = mad(dp3_f32(_757, _839) / max(_758, dp3_f32(_839, _839)), -6.0f, 7.0f);
        float3 _853 = float3(t7.Load(int3(_707, 0u)).xyz);
        float _858 = mad(dp3_f32(_757, _853) / max(_758, dp3_f32(_853, _853)), -6.0f, 7.0f);
        float3 _867 = float3(t7.Load(int3(_714, 0u)).xyz);
        float _872 = mad(dp3_f32(_757, _867) / max(_758, dp3_f32(_867, _867)), -6.0f, 7.0f);
        _881 = max(max(max(max(max(max(max(max(max(_637, exp2(_764 * log2(_652))), exp2(_778 * log2(_658))), exp2(_792 * log2(_674))), exp2(_806 * log2(_681))), exp2(_816 * log2(_687))), exp2(_830 * log2(_694))), exp2(_844 * log2(_704))), exp2(_858 * log2(_711))), exp2(_872 * log2(_718)));
        _882 = max(max(max(max(max(max(max(max(max(exp2(_764 * log2(_649)), 0.0f), exp2(_778 * log2(_656))), exp2(_792 * log2(_672))), exp2(_806 * log2(_679))), exp2(_816 * log2(_685))), exp2(_830 * log2(_692))), exp2(_844 * log2(_702))), exp2(_858 * log2(_709))), exp2(_872 * log2(_716)));
    }
    else
    {
        _881 = _637;
        _882 = 0.0f;
    }
    u0[_175] = float4(_882, _881, _882, _882);
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

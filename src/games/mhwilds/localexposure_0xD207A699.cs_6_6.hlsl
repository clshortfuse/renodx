cbuffer RangeCompressInfoUBO : register(b0, space0)
{
    float4 RangeCompressInfo_m0[2] : packoffset(c0);
};

cbuffer RootConstantUBO : register(b0, space32)
{
    float4 RootConstant_m0[1] : packoffset(c0);
};

cbuffer TonemapUBO : register(b1, space0)
{
    float4 Tonemap_m0[6] : packoffset(c0);
};

Buffer<uint4> WhitePtSrv : register(t0, space0);
Texture2D<float4> SceneColorSRV : register(t1, space0);
RWTexture3D<float4> BilateralLuminanceUav : register(u0, space0);
SamplerState PointClamp : register(s1, space32);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
static uint gl_LocalInvocationIndex;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
    uint gl_LocalInvocationIndex : SV_GroupIndex;
};

groupshared uint _38[2048];

void comp_main()
{
    uint4 _57 = asuint(RootConstant_m0[0u]);
    uint _58 = _57.x;
    float _61 = float(_58 & 65535u);
    float _64 = float(_58 >> 16u);
    float _65 = 1.0f / _61;
    float _67 = 1.0f / _64;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 0u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 8u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 16u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 24u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 32u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 40u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 48u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 56u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 64u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 72u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 80u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 88u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 96u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 104u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 112u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 120u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 128u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 136u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 144u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 152u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 160u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 168u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 176u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 184u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 192u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 200u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 208u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 216u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 224u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 232u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 240u) * 8u)] = 0u;
    _38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + 248u) * 8u)] = 0u;
    GroupMemoryBarrierWithGroupSync();
    uint _230;
    uint _228 = 0u;
    for (;;)
    {
        _230 = 0u;
        float _244;
        float _245;
        bool _254;
        for (;;)
        {
            uint _237 = ((gl_LocalInvocationID.x << 1u) + (gl_WorkGroupID.x << 6u)) + _230;
            uint _239 = ((gl_LocalInvocationID.y << 1u) + (gl_WorkGroupID.y << 6u)) + _228;
            _244 = (float(_237) + 1.0f) * _65;
            _245 = (float(_239) + 1.0f) * _67;
            _254 = (_239 < (uint(_64) + 4294967295u)) && (_237 < (uint(_61) + 4294967295u));
            if (_254)
            {
                float _264;
                if (asuint(Tonemap_m0[1u]).y == 0u)
                {
                    _264 = 1.0f;
                }
                else
                {
                    _264 = asfloat(WhitePtSrv.Load(0u).x);
                }
                float _266 = _264 * Tonemap_m0[0u].x;
                float4 _273 = SceneColorSRV.GatherRed(PointClamp, float2(_244, _245));
                float4 _290 = SceneColorSRV.GatherGreen(PointClamp, float2(_244, _245));
                float4 _304 = SceneColorSRV.GatherBlue(PointClamp, float2(_244, _245));
                float _346 = (Tonemap_m0[4u].z * log2(max(dot(float3((_273.x * _266) * RangeCompressInfo_m0[0u].y, (_290.x * _266) * RangeCompressInfo_m0[0u].y, (_304.x * _266) * RangeCompressInfo_m0[0u].y), float3(0.25f, 0.5f, 0.25f)), 9.9999997473787516355514526367188e-06f) + 9.9999997473787516355514526367188e-06f)) + Tonemap_m0[4u].w;
                float _349 = clamp(_346, 0.0f, 1.0f) * 31.0f;
                uint _351 = uint(_349);
                float _356 = frac(_349);
                float _357 = 1.0f - _356;
                float _361 = _346 * 512.0f;
                uint _379;
                InterlockedAdd(_38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + (min(_351, 31u) * 8u)) * 8u)], (uint(_361 * _357) & 65535u) | (uint(_357 * 512.0f) << 16u), _379);
                uint _385;
                InterlockedAdd(_38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + (min((_351 + 1u), 31u) * 8u)) * 8u)], (uint(_361 * _356) & 65535u) | (uint(_356 * 512.0f) << 16u), _385);
                float _393 = (Tonemap_m0[4u].z * log2(max(dot(float3((_273.y * _266) * RangeCompressInfo_m0[0u].y, (_290.y * _266) * RangeCompressInfo_m0[0u].y, (_304.y * _266) * RangeCompressInfo_m0[0u].y), float3(0.25f, 0.5f, 0.25f)), 9.9999997473787516355514526367188e-06f) + 9.9999997473787516355514526367188e-06f)) + Tonemap_m0[4u].w;
                float _395 = clamp(_393, 0.0f, 1.0f) * 31.0f;
                uint _396 = uint(_395);
                float _400 = frac(_395);
                float _401 = 1.0f - _400;
                float _404 = _393 * 512.0f;
                uint _422;
                InterlockedAdd(_38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + (min(_396, 31u) * 8u)) * 8u)], (uint(_404 * _401) & 65535u) | (uint(_401 * 512.0f) << 16u), _422);
                uint _428;
                InterlockedAdd(_38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + (min((_396 + 1u), 31u) * 8u)) * 8u)], (uint(_404 * _400) & 65535u) | (uint(_400 * 512.0f) << 16u), _428);
                float _436 = (Tonemap_m0[4u].z * log2(max(dot(float3((_273.z * _266) * RangeCompressInfo_m0[0u].y, (_290.z * _266) * RangeCompressInfo_m0[0u].y, (_304.z * _266) * RangeCompressInfo_m0[0u].y), float3(0.25f, 0.5f, 0.25f)), 9.9999997473787516355514526367188e-06f) + 9.9999997473787516355514526367188e-06f)) + Tonemap_m0[4u].w;
                float _438 = clamp(_436, 0.0f, 1.0f) * 31.0f;
                uint _439 = uint(_438);
                float _443 = frac(_438);
                float _444 = 1.0f - _443;
                float _447 = _436 * 512.0f;
                uint _465;
                InterlockedAdd(_38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + (min(_439, 31u) * 8u)) * 8u)], (uint(_447 * _444) & 65535u) | (uint(_444 * 512.0f) << 16u), _465);
                uint _471;
                InterlockedAdd(_38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + (min((_439 + 1u), 31u) * 8u)) * 8u)], (uint(_447 * _443) & 65535u) | (uint(_443 * 512.0f) << 16u), _471);
                float _479 = (Tonemap_m0[4u].z * log2(max(dot(float3((_273.w * _266) * RangeCompressInfo_m0[0u].y, (_290.w * _266) * RangeCompressInfo_m0[0u].y, (_304.w * _266) * RangeCompressInfo_m0[0u].y), float3(0.25f, 0.5f, 0.25f)), 9.9999997473787516355514526367188e-06f) + 9.9999997473787516355514526367188e-06f)) + Tonemap_m0[4u].w;
                float _481 = clamp(_479, 0.0f, 1.0f) * 31.0f;
                uint _482 = uint(_481);
                float _486 = frac(_481);
                float _487 = 1.0f - _486;
                float _490 = _479 * 512.0f;
                uint _508;
                InterlockedAdd(_38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + (min(_482, 31u) * 8u)) * 8u)], (uint(_490 * _487) & 65535u) | (uint(_487 * 512.0f) << 16u), _508);
                uint _514;
                InterlockedAdd(_38[gl_LocalInvocationID.y + ((gl_LocalInvocationID.x + (min((_482 + 1u), 31u) * 8u)) * 8u)], (uint(_490 * _486) & 65535u) | (uint(_486 * 512.0f) << 16u), _514);
            }
            uint _231 = _230 + 16u;
            if (_231 < 64u)
            {
                _230 = _231;
                continue;
            }
            else
            {
                break;
            }
        }
        uint _229 = _228 + 16u;
        if (_229 < 64u)
        {
            _228 = _229;
            continue;
        }
        else
        {
            break;
        }
    }
    GroupMemoryBarrierWithGroupSync();
    if (gl_LocalInvocationIndex < 32u)
    {
        float _523;
        float _525;
        float _528;
        float _529;
        uint _530;
        float _522 = 0.0f;
        float _524 = 0.0f;
        uint _526 = 0u;
        for (;;)
        {
            _528 = _522;
            _529 = _524;
            _530 = 0u;
            for (;;)
            {
                uint _535 = _526 + ((_530 + (gl_LocalInvocationIndex * 8u)) * 8u);
                float _541 = float(_38[_535] >> 16u) * 0.001953125f;
                _523 = _541 + _528;
                _525 = (((float(_38[_535] & 65535u) * 0.001953125f) - (_541 * Tonemap_m0[4u].w)) / Tonemap_m0[4u].z) + _529;
                uint _531 = _530 + 1u;
                if (_531 == 8u)
                {
                    break;
                }
                else
                {
                    _528 = _523;
                    _529 = _525;
                    _530 = _531;
                }
            }
            uint _527 = _526 + 1u;
            if (_527 == 8u)
            {
                break;
            }
            else
            {
                _522 = _523;
                _524 = _525;
                _526 = _527;
                continue;
            }
        }
        BilateralLuminanceUav[uint3(gl_WorkGroupID.x, gl_WorkGroupID.y, gl_LocalInvocationIndex)] = float4(_525, _523, _525, _525);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    gl_LocalInvocationIndex = stage_input.gl_LocalInvocationIndex;
    comp_main();
}

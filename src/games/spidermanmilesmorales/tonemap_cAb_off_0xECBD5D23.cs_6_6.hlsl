#include "./common.hlsl"

Texture3D<float4> g_TmToneMapLookup : register(t5, space0);
Texture2D<float4> g_TmRadianceMap : register(t6, space0);
Texture2D<float4> g_TmBloomMap : register(t7, space0);
Texture3D<float4> g_TmColorFilterMap : register(t9, space0);
Texture2D<float4> g_TmFilmGrainNoise : register(t10, space0);
Buffer<uint4> g_TmAdaptedLumBuffer : register(t11, space0);
Texture2D<float4> g_TmSrgbOverlayMap : register(t12, space0);
Texture2D<float4> g_TmRadianceBlurMap : register(t13, space0);
RWTexture2D<float4> g_TmOutput : register(u0, space0);
RWTexture2D<float4> g_TmOutputHudless : register(u1, space0);
SamplerState g_PointClampSampler : register(s0, space0);
SamplerState g_LinearClampSampler : register(s2, space0);
SamplerState g_LinearWrapSampler : register(s3, space0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

groupshared float _39[128];

void comp_main()
{
    uint _50 = gl_GlobalInvocationID.x & 7u;
    uint _52 = gl_GlobalInvocationID.y & 7u;
    uint _55 = (_52 << 3u) | _50;
    uint _58 = (_55 * 3277u) >> 14u;
    uint _65 = ((_58 * 4294967291u) + _55) << 1u;
    float _78 = (float((gl_GlobalInvocationID.x - _50) + _65) + 0.5f) * ToneMapCBuffer_m0[0u].x;
    float _79 = (float((gl_GlobalInvocationID.y - _52) + _58) + 0.5f) * ToneMapCBuffer_m0[0u].y;
    uint _119 = _65 + (_58 * 10u);
    _39[_119] = log2(max(dot(float3(g_TmRadianceMap.SampleLevel(g_PointClampSampler, float2(_78, _79), 0.0f, int2(-1, -1)).xyz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)), 9.9999997473787516355514526367188e-06f));
    _39[_119 | 1u] = log2(max(dot(float3(g_TmRadianceMap.SampleLevel(g_PointClampSampler, float2(_78, _79), 0.0f, int2(0, -1)).xyz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)), 9.9999997473787516355514526367188e-06f));
    GroupMemoryBarrierWithGroupSync();
    uint _127 = (_52 * 10u) + _50;
    uint _128 = _127 + 11u;
    float _136 = _39[_128] + (-0.60000002384185791015625f);
    float _138 = _39[_128] + 0.60000002384185791015625f;
    float _222 = ((((((((ToneMapCBuffer_m0[3u].x * _39[_128]) - _39[_128]) + (ToneMapCBuffer_m0[3u].z * min(max(_39[_127], _136), _138))) + (ToneMapCBuffer_m0[3u].y * min(max(_39[_127 + 1u], _136), _138))) + (ToneMapCBuffer_m0[3u].z * min(max(_39[_127 + 2u], _136), _138))) + (ToneMapCBuffer_m0[3u].y * min(max(_39[_127 + 10u], _136), _138))) + (ToneMapCBuffer_m0[3u].y * min(max(_39[_127 + 12u], _136), _138))) + (ToneMapCBuffer_m0[3u].z * min(max(_39[_127 + 20u], _136), _138))) + (ToneMapCBuffer_m0[3u].y * min(max(_39[_127 + 21u], _136), _138));
    float _224 = exp2(_222 + (ToneMapCBuffer_m0[3u].z * min(max(_39[_127 + 22u], _136), _138)));
    float _233 = ToneMapCBuffer_m0[0u].x * (float(gl_GlobalInvocationID.x) + 0.5f);
    float _234 = ToneMapCBuffer_m0[0u].y * (float(gl_GlobalInvocationID.y) + 0.5f);
    float4 _238 = g_TmRadianceMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f);
    float4 _248 = g_TmBloomMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f);
    float _253 = _248.x + (_238.x * _224);
    float _254 = _248.y + (_238.y * _224);
    float _255 = _248.z + (_238.z * _224);
    float _286;
    float _287;
    float _288;
    if (ToneMapCBuffer_m0[7u].y != 0.0f)
    {
        float _267 = clamp(dot(float3(_253, _254, _255), float3(0.300000011920928955078125f, 0.5f, 0.20000000298023223876953125f)), 0.0f, 1.0f);
        float _282 = ((((((_267 * _267) * _267) * ((((_267 * 6.0f) + (-15.0f)) * _267) + 10.0f)) - _267) * ToneMapCBuffer_m0[7u].y) + _267) / max(_267, 9.9999997473787516355514526367188e-06f);
        _286 = _282 * _253;
        _287 = _282 * _254;
        _288 = _282 * _255;
    }
    else
    {
        _286 = _253;
        _287 = _254;
        _288 = _255;
    }
    float _298 = (_233 * ToneMapCBuffer_m0[6u].x) + ToneMapCBuffer_m0[6u].z;
    float _299 = (_234 * ToneMapCBuffer_m0[6u].y) + ToneMapCBuffer_m0[6u].w;
    float _306 = clamp((1.0f - max(abs(_298), abs(_299))) * 4096.0f, 0.0f, 1.0f);
    float4 _313 = g_TmSrgbOverlayMap.SampleLevel(g_LinearClampSampler, float2((_298 * 0.5f) + 0.5f, (_299 * 0.5f) + 0.5f), 0.0f);
    float _319 = _313.x * _306;
    float _320 = _313.y * _306;
    float _321 = _313.z * _306;
    float _324 = (_313.w + (-1.0f)) * _306;
    float _342 = min(clamp((ToneMapCBuffer_m0[5u].z * dot(float3(_319, _320, _321), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f))) - ToneMapCBuffer_m0[5u].w, 0.0f, 1.0f), clamp(19.5f - ((_324 + 1.0f) * 20.0f), 0.0f, 1.0f));
    float _443;
    float _444;
    float _445;
    if (_342 > 0.0f)
    {
        float4 _346 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f);
        float4 _355 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f, int2(-1, -1));
        float4 _360 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f, int2(0, -1));
        float4 _366 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f, int2(1, -1));
        float4 _372 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f, int2(-1, 0));
        float4 _378 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f, int2(1, 0));
        float4 _384 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f, int2(-1, 1));
        float4 _390 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f, int2(0, 1));
        float4 _396 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_233, _234), 0.0f, int2(1, 1));
        _443 = (((((_346.x * 0.25f) - _286) + ((((_372.x + _360.x) + _378.x) + _390.x) * 0.125f)) + ((((_366.x + _355.x) + _384.x) + _396.x) * 0.0625f)) * _342) + _286;
        _444 = (((((_346.y * 0.25f) - _287) + ((((_372.y + _360.y) + _378.y) + _390.y) * 0.125f)) + ((((_366.y + _355.y) + _384.y) + _396.y) * 0.0625f)) * _342) + _287;
        _445 = (((((_346.z * 0.25f) - _288) + ((((_372.z + _360.z) + _378.z) + _390.z) * 0.125f)) + ((((_366.z + _355.z) + _384.z) + _396.z) * 0.0625f)) * _342) + _288;
    }
    else
    {
        _443 = _286;
        _444 = _287;
        _445 = _288;
    }
    float _457 = ((_233 * 2.0f) - ToneMapCBuffer_m0[5u].x) * ToneMapCBuffer_m0[2u].y;
    float _458 = ToneMapCBuffer_m0[2u].z * ((_234 * 2.0f) - ToneMapCBuffer_m0[5u].y);
    float _465 = max(sqrt(dot(float2(_457, _458), float2(_457, _458))) - ToneMapCBuffer_m0[2u].w, 0.0f);
    float _468 = 1.0f / ((_465 * _465) + 1.0f);
    float _469 = _468 * _468;
    float _481 = (ToneMapCBuffer_m0[1u].z * 2.0f) + (-0.5f);
    float _483 = ToneMapCBuffer_m0[1u].z * 6.283185482025146484375f;
    float _485 = _233 - _481;
    float _486 = (ToneMapCBuffer_m0[1u].w * _234) - _481;
    float _487 = sin(_483);
    float _488 = cos(_483);
    float _505 = g_TmFilmGrainNoise.SampleLevel(g_LinearWrapSampler, float2(((_481 - (_486 * _487)) + (_485 * _488)) * ToneMapCBuffer_m0[1u].x, (((_485 * _487) + _481) + (_486 * _488)) * ToneMapCBuffer_m0[1u].x), 0.0f).x * 2.0f;
    float _512 = ((((_505 >= 1.0f) ? _505 : (1.0f / (2.0f - _505))) + (-1.0f)) * ToneMapCBuffer_m0[1u].y) + 1.0f;
    float _522 = ToneMapCBuffer_m0[2u].x * asfloat(g_TmAdaptedLumBuffer.Load(1u).x);
    float4 _540 = g_TmToneMapLookup.SampleLevel(g_LinearClampSampler, float3((log2(((_469 * _443) * _512) * _522) * 0.060546875f) + 0.6513671875f, (log2(((_469 * _444) * _512) * _522) * 0.060546875f) + 0.6513671875f, (log2(((_469 * _445) * _512) * _522) * 0.060546875f) + 0.6513671875f), 0.0f);
    float _548 = (ToneMapCBuffer_m0[7u].w != 0.0f) ? ToneMapCBuffer_m0[7u].z : 1.0f;
    float _549 = _548 * _540.x;
    float _550 = _548 * _540.y;
    float _551 = _548 * _540.z;
    float _552 = (-0.0f) - _324;
    float _557 = (_549 * _552) + _319;
    float _558 = (_550 * _552) + _320;
    float _559 = (_551 * _552) + _321;
    float _613;
    float _614;
    float _615;
    float _616;
    float _617;
    float _618;
    if (ToneMapCBuffer_m0[7u].x != 0.0f)
    {
        float _562 = max(_557, 1.0f);
        float _563 = max(_558, 1.0f);
        float _564 = max(_559, 1.0f);
        float _565 = 1.0f / _562;
        float _566 = 1.0f / _563;
        float _567 = 1.0f / _564;
        float _568 = _565 * _557;
        float _569 = _566 * _558;
        float _570 = _567 * _559;
        float _571 = _565 * _549;
        float _572 = _566 * _550;
        float _573 = _567 * _551;
        float4 _584 = g_TmColorFilterMap.SampleLevel(g_LinearClampSampler, float3((_568 * 0.96875f) + 0.015625f, (_569 * 0.96875f) + 0.015625f, (_570 * 0.96875f) + 0.015625f), 0.0f);
        float _586 = _584.x;
        float _587 = _584.y;
        float _588 = _584.z;
        _613 = ((ToneMapCBuffer_m0[7u].x * (_586 - _568)) + _568) * _562;
        _614 = ((ToneMapCBuffer_m0[7u].x * (_587 - _569)) + _569) * _563;
        _615 = ((ToneMapCBuffer_m0[7u].x * (_588 - _570)) + _570) * _564;
        _616 = ((ToneMapCBuffer_m0[7u].x * (_586 - _571)) + _571) * _562;
        _617 = ((ToneMapCBuffer_m0[7u].x * (_587 - _572)) + _572) * _563;
        _618 = ((ToneMapCBuffer_m0[7u].x * (_588 - _573)) + _573) * _564;
    }
    else
    {
        _613 = _557;
        _614 = _558;
        _615 = _559;
        _616 = _549;
        _617 = _550;
        _618 = _551;
    }
    float _749;
    float _750;
    float _751;
    float _752;
    float _753;
    float _754;
    if (ToneMapCBuffer_m0[3u].w != 0.0f)
    {
        float m_HdrGamma;
        if (RENODX_GAMMA_ADJUST_TYPE) {
            m_HdrGamma = RENODX_GAMMA_ADJUST_VALUE;
        } else {
            m_HdrGamma = ToneMapCBuffer_m0[3u].w * RENODX_GAMMA_ADJUST_VALUE;
        }

        float3 scene = float3(_613, _614, _615);
        scene = renodx::math::SignPow(scene, m_HdrGamma);
        float _631 = scene.r, _632 = scene.g, _633 = scene.b;

        float _634 = ToneMapCBuffer_m0[8u].x * 9.9999997473787516355514526367188e-05f;
        float _664 = exp2(log2(mad(0.0432999990880489349365234375f, _633, mad(0.329299986362457275390625f, _632, _631 * 0.627399981021881103515625f)) * _634) * 0.1593017578125f);
        float _665 = exp2(log2(mad(0.011400000192224979400634765625f, _633, mad(0.91949999332427978515625f, _632, _631 * 0.069099999964237213134765625f)) * _634) * 0.1593017578125f);
        float _666 = exp2(log2(mad(0.895600020885467529296875f, _633, mad(0.087999999523162841796875f, _632, _631 * 0.01640000008046627044677734375f)) * _634) * 0.1593017578125f);

        float3 color = float3(_616, _617, _618);
        color = renodx::math::SignPow(color, m_HdrGamma);
        float _701 = color.r, _702 = color.g, _703 = color.b;

        float _722 = exp2(log2(mad(0.0432999990880489349365234375f, _703, mad(0.329299986362457275390625f, _702, _701 * 0.627399981021881103515625f)) * _634) * 0.1593017578125f);
        float _723 = exp2(log2(mad(0.011400000192224979400634765625f, _703, mad(0.91949999332427978515625f, _702, _701 * 0.069099999964237213134765625f)) * _634) * 0.1593017578125f);
        float _724 = exp2(log2(mad(0.895600020885467529296875f, _703, mad(0.087999999523162841796875f, _702, _701 * 0.01640000008046627044677734375f)) * _634) * 0.1593017578125f);
        _749 = exp2(log2(((_664 * 18.8515625f) + 0.8359375f) / ((_664 * 18.6875f) + 1.0f)) * 78.84375f);
        _750 = exp2(log2(((_665 * 18.8515625f) + 0.8359375f) / ((_665 * 18.6875f) + 1.0f)) * 78.84375f);
        _751 = exp2(log2(((_666 * 18.8515625f) + 0.8359375f) / ((_666 * 18.6875f) + 1.0f)) * 78.84375f);
        _752 = exp2(log2(((_722 * 18.8515625f) + 0.8359375f) / ((_722 * 18.6875f) + 1.0f)) * 78.84375f);
        _753 = exp2(log2(((_723 * 18.8515625f) + 0.8359375f) / ((_723 * 18.6875f) + 1.0f)) * 78.84375f);
        _754 = exp2(log2(((_724 * 18.8515625f) + 0.8359375f) / ((_724 * 18.6875f) + 1.0f)) * 78.84375f);
    }
    else
    {
        _749 = _613;
        _750 = _614;
        _751 = _615;
        _752 = _616;
        _753 = _617;
        _754 = _618;
    }
    g_TmOutput[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_749, _750, _751, 1.0f);
    if (ToneMapCBuffer_m0[9u].z != 0.0f)
    {
        g_TmOutputHudless[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_752, _753, _754, 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

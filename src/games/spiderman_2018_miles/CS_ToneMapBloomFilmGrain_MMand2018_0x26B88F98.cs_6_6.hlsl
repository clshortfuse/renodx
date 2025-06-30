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
SamplerState g_LinearClampSampler : register(s2, space0);
SamplerState g_LinearWrapSampler : register(s3, space0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main()
{
    float _55 = ToneMapCBuffer_m0[0u].x * (float(gl_GlobalInvocationID.x) + 0.5f);
    float _56 = (float(gl_GlobalInvocationID.y) + 0.5f) * ToneMapCBuffer_m0[0u].y;
    float4 _62 = g_TmRadianceMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f);
    float4 _70 = g_TmBloomMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f);
    float _75 = _70.x + _62.x;
    float _76 = _70.y + _62.y;
    float _77 = _70.z + _62.z;
    float _112;
    float _113;
    float _114;
    if (ToneMapCBuffer_m0[7u].y != 0.0f)
    {
        float _92 = clamp(dot(float3(_75, _76, _77), float3(0.300000011920928955078125f, 0.5f, 0.20000000298023223876953125f)), 0.0f, 1.0f);
        float _108 = ((((((_92 * _92) * _92) * ((((_92 * 6.0f) + (-15.0f)) * _92) + 10.0f)) - _92) * ToneMapCBuffer_m0[7u].y) + _92) / max(_92, 9.9999997473787516355514526367188e-06f);
        _112 = _108 * _75;
        _113 = _108 * _76;
        _114 = _108 * _77;
    }
    else
    {
        _112 = _75;
        _113 = _76;
        _114 = _77;
    }
    float _124 = (_55 * ToneMapCBuffer_m0[6u].x) + ToneMapCBuffer_m0[6u].z;
    float _125 = (_56 * ToneMapCBuffer_m0[6u].y) + ToneMapCBuffer_m0[6u].w;
    float _132 = clamp((1.0f - max(abs(_124), abs(_125))) * 4096.0f, 0.0f, 1.0f);
    float4 _139 = g_TmSrgbOverlayMap.SampleLevel(g_LinearClampSampler, float2((_124 * 0.5f) + 0.5f, (_125 * 0.5f) + 0.5f), 0.0f);
    float _145 = _139.x * _132;
    float _146 = _139.y * _132;
    float _147 = _139.z * _132;
    float _150 = (_139.w + (-1.0f)) * _132;
    float _171 = min(clamp((ToneMapCBuffer_m0[5u].z * dot(float3(_145, _146, _147), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f))) - ToneMapCBuffer_m0[5u].w, 0.0f, 1.0f), clamp(19.5f - ((_150 + 1.0f) * 20.0f), 0.0f, 1.0f));
    float _278;
    float _279;
    float _280;
    if (_171 > 0.0f)
    {
        float4 _175 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f);
        float4 _186 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f, int2(-1, -1));
        float4 _194 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f, int2(0, -1));
        float4 _201 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f, int2(1, -1));
        float4 _207 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f, int2(-1, 0));
        float4 _213 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f, int2(1, 0));
        float4 _219 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f, int2(-1, 1));
        float4 _225 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f, int2(0, 1));
        float4 _231 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_55, _56), 0.0f, int2(1, 1));
        _278 = (((((_175.x * 0.25f) - _112) + ((((_207.x + _194.x) + _213.x) + _225.x) * 0.125f)) + ((((_201.x + _186.x) + _219.x) + _231.x) * 0.0625f)) * _171) + _112;
        _279 = (((((_175.y * 0.25f) - _113) + ((((_207.y + _194.y) + _213.y) + _225.y) * 0.125f)) + ((((_201.y + _186.y) + _219.y) + _231.y) * 0.0625f)) * _171) + _113;
        _280 = (((((_175.z * 0.25f) - _114) + ((((_207.z + _194.z) + _213.z) + _225.z) * 0.125f)) + ((((_201.z + _186.z) + _219.z) + _231.z) * 0.0625f)) * _171) + _114;
    }
    else
    {
        _278 = _112;
        _279 = _113;
        _280 = _114;
    }
    float _293 = ((_55 * 2.0f) - ToneMapCBuffer_m0[5u].x) * ToneMapCBuffer_m0[2u].y;
    float _294 = ToneMapCBuffer_m0[2u].z * ((_56 * 2.0f) - ToneMapCBuffer_m0[5u].y);
    float _301 = max(sqrt(dot(float2(_293, _294), float2(_293, _294))) - ToneMapCBuffer_m0[2u].w, 0.0f);
    float _304 = 1.0f / ((_301 * _301) + 1.0f);
    float _305 = _304 * _304;
    float _317 = (ToneMapCBuffer_m0[1u].z * 2.0f) + (-0.5f);
    float _319 = ToneMapCBuffer_m0[1u].z * 6.283185482025146484375f;
    float _321 = _55 - _317;
    float _322 = (ToneMapCBuffer_m0[1u].w * _56) - _317;
    float _323 = sin(_319);
    float _324 = cos(_319);
    float _341 = g_TmFilmGrainNoise.SampleLevel(g_LinearWrapSampler, float2(((_317 - (_322 * _323)) + (_321 * _324)) * ToneMapCBuffer_m0[1u].x, (((_321 * _323) + _317) + (_322 * _324)) * ToneMapCBuffer_m0[1u].x), 0.0f).x * 2.0f;
    float _348 = ((((_341 >= 1.0f) ? _341 : (1.0f / (2.0f - _341))) + (-1.0f)) * ToneMapCBuffer_m0[1u].y) + 1.0f;
    float _358 = ToneMapCBuffer_m0[2u].x * asfloat(g_TmAdaptedLumBuffer.Load(1u).x);
    float4 _376 = g_TmToneMapLookup.SampleLevel(g_LinearClampSampler, float3((log2(((_305 * _278) * _348) * _358) * 0.060546875f) + 0.6513671875f, (log2(((_305 * _279) * _348) * _358) * 0.060546875f) + 0.6513671875f, (log2(((_305 * _280) * _348) * _358) * 0.060546875f) + 0.6513671875f), 0.0f);
    float _384 = (ToneMapCBuffer_m0[7u].w != 0.0f) ? ToneMapCBuffer_m0[7u].z : 1.0f;
    float _385 = _384 * _376.x;
    float _386 = _384 * _376.y;
    float _387 = _384 * _376.z;
    float _388 = (-0.0f) - _150;
    float _393 = (_385 * _388) + _145;
    float _394 = (_386 * _388) + _146;
    float _395 = (_387 * _388) + _147;
    float _449;
    float _450;
    float _451;
    float _452;
    float _453;
    float _454;
    if (ToneMapCBuffer_m0[7u].x != 0.0f)
    {
        float _398 = max(_393, 1.0f);
        float _399 = max(_394, 1.0f);
        float _400 = max(_395, 1.0f);
        float _401 = 1.0f / _398;
        float _402 = 1.0f / _399;
        float _403 = 1.0f / _400;
        float _404 = _401 * _393;
        float _405 = _402 * _394;
        float _406 = _403 * _395;
        float _407 = _401 * _385;
        float _408 = _402 * _386;
        float _409 = _403 * _387;
        float4 _420 = g_TmColorFilterMap.SampleLevel(g_LinearClampSampler, float3((_404 * 0.96875f) + 0.015625f, (_405 * 0.96875f) + 0.015625f, (_406 * 0.96875f) + 0.015625f), 0.0f);
        float _422 = _420.x;
        float _423 = _420.y;
        float _424 = _420.z;
        _449 = ((ToneMapCBuffer_m0[7u].x * (_422 - _404)) + _404) * _398;
        _450 = ((ToneMapCBuffer_m0[7u].x * (_423 - _405)) + _405) * _399;
        _451 = ((ToneMapCBuffer_m0[7u].x * (_424 - _406)) + _406) * _400;
        _452 = ((ToneMapCBuffer_m0[7u].x * (_422 - _407)) + _407) * _398;
        _453 = ((ToneMapCBuffer_m0[7u].x * (_423 - _408)) + _408) * _399;
        _454 = ((ToneMapCBuffer_m0[7u].x * (_424 - _409)) + _409) * _400;
    }
    else
    {
        _449 = _393;
        _450 = _394;
        _451 = _395;
        _452 = _385;
        _453 = _386;
        _454 = _387;
    }
    float _588;
    float _589;
    float _590;
    float _591;
    float _592;
    float _593;
    if (ToneMapCBuffer_m0[3u].w != 0.0f)
    {
        // float _470 = exp2(log2(_449) * ToneMapCBuffer_m0[3u].w);
        // float _471 = exp2(log2(_450) * ToneMapCBuffer_m0[3u].w);
        // float _472 = exp2(log2(_451) * ToneMapCBuffer_m0[3u].w);
        float3 scene = float3(_449, _450, _451);
        scene = renodx::math::SignPow(scene, m_HdrGamma);
        float _470 = scene.r, _471 = scene.g, _472 = scene.b;

        float _473 = ToneMapCBuffer_m0[8u].x * 9.9999997473787516355514526367188e-05f;
        float _503 = exp2(log2(mad(0.0432999990880489349365234375f, _472, mad(0.329299986362457275390625f, _471, _470 * 0.627399981021881103515625f)) * _473) * 0.1593017578125f);
        float _504 = exp2(log2(mad(0.011400000192224979400634765625f, _472, mad(0.91949999332427978515625f, _471, _470 * 0.069099999964237213134765625f)) * _473) * 0.1593017578125f);
        float _505 = exp2(log2(mad(0.895600020885467529296875f, _472, mad(0.087999999523162841796875f, _471, _470 * 0.01640000008046627044677734375f)) * _473) * 0.1593017578125f);

        // float _540 = exp2(log2(_452) * ToneMapCBuffer_m0[3u].w);
        // float _541 = exp2(log2(_453) * ToneMapCBuffer_m0[3u].w);
        // float _542 = exp2(log2(_454) * ToneMapCBuffer_m0[3u].w);
        float3 color = float3(_452, _453, _454);
        color = renodx::math::SignPow(color, m_HdrGamma);
        float _540 = color.r, _541 = color.g, _542 = color.b;

        float _561 = exp2(log2(mad(0.0432999990880489349365234375f, _542, mad(0.329299986362457275390625f, _541, _540 * 0.627399981021881103515625f)) * _473) * 0.1593017578125f);
        float _562 = exp2(log2(mad(0.011400000192224979400634765625f, _542, mad(0.91949999332427978515625f, _541, _540 * 0.069099999964237213134765625f)) * _473) * 0.1593017578125f);
        float _563 = exp2(log2(mad(0.895600020885467529296875f, _542, mad(0.087999999523162841796875f, _541, _540 * 0.01640000008046627044677734375f)) * _473) * 0.1593017578125f);
        _588 = exp2(log2(((_503 * 18.8515625f) + 0.8359375f) / ((_503 * 18.6875f) + 1.0f)) * 78.84375f);
        _589 = exp2(log2(((_504 * 18.8515625f) + 0.8359375f) / ((_504 * 18.6875f) + 1.0f)) * 78.84375f);
        _590 = exp2(log2(((_505 * 18.8515625f) + 0.8359375f) / ((_505 * 18.6875f) + 1.0f)) * 78.84375f);
        _591 = exp2(log2(((_561 * 18.8515625f) + 0.8359375f) / ((_561 * 18.6875f) + 1.0f)) * 78.84375f);
        _592 = exp2(log2(((_562 * 18.8515625f) + 0.8359375f) / ((_562 * 18.6875f) + 1.0f)) * 78.84375f);
        _593 = exp2(log2(((_563 * 18.8515625f) + 0.8359375f) / ((_563 * 18.6875f) + 1.0f)) * 78.84375f);
    }
    else
    {
        _588 = _449;
        _589 = _450;
        _590 = _451;
        _591 = _452;
        _592 = _453;
        _593 = _454;
    }
    g_TmOutput[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_588, _589, _590, 1.0f);
    if (ToneMapCBuffer_m0[9u].z != 0.0f)
    {
        g_TmOutputHudless[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_591, _592, _593, 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

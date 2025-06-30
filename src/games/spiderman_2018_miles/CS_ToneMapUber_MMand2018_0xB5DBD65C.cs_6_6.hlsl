#include "./common.hlsl"

Texture3D<float4> g_TmToneMapLookup : register(t5, space0);
Texture2D<float4> g_TmRadianceMap : register(t6, space0);
Texture2D<float4> g_TmBloomMap : register(t7, space0);
Texture2D<float4> g_TmChromaticAbMap : register(t8, space0);
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

groupshared float _40[128];

void comp_main()
{
    // --- Thread-local Index Calculation ---
    uint _51 = gl_GlobalInvocationID.x & 7u;
    uint _53 = gl_GlobalInvocationID.y & 7u;
    uint _56 = (_53 << 3u) | _51;
    uint _59 = (_56 * 3277u) >> 14u;
    uint _66 = ((_59 * 4294967291u) + _56) << 1u;
    float _79 = (float((gl_GlobalInvocationID.x - _51) + _66) + 0.5f) * ToneMapCBuffer_m0[0u].x;
    float _80 = (float((gl_GlobalInvocationID.y - _53) + _59) + 0.5f) * ToneMapCBuffer_m0[0u].y;
    uint _120 = _66 + (_59 * 10u);
    
    // --- Luminance Sampling --- 
    _40[_120] = log2(max(dot(float3(g_TmRadianceMap.SampleLevel(g_PointClampSampler, float2(_79, _80), 0.0f, int2(-1, -1)).xyz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)), 9.9999997473787516355514526367188e-06f));
    _40[_120 | 1u] = log2(max(dot(float3(g_TmRadianceMap.SampleLevel(g_PointClampSampler, float2(_79, _80), 0.0f, int2(0, -1)).xyz), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)), 9.9999997473787516355514526367188e-06f));
    GroupMemoryBarrierWithGroupSync();
    
    // --- Local Adaptation Filtering ---
    uint _128 = (_53 * 10u) + _51;
    uint _129 = _128 + 11u;
    float _137 = _40[_129] + (-0.60000002384185791015625f);
    float _139 = _40[_129] + 0.60000002384185791015625f;
    float _223 = ((((((((ToneMapCBuffer_m0[3u].x * _40[_129]) - _40[_129]) + (ToneMapCBuffer_m0[3u].z * min(max(_40[_128], _137), _139))) + (ToneMapCBuffer_m0[3u].y * min(max(_40[_128 + 1u], _137), _139))) + (ToneMapCBuffer_m0[3u].z * min(max(_40[_128 + 2u], _137), _139))) + (ToneMapCBuffer_m0[3u].y * min(max(_40[_128 + 10u], _137), _139))) + (ToneMapCBuffer_m0[3u].y * min(max(_40[_128 + 12u], _137), _139))) + (ToneMapCBuffer_m0[3u].z * min(max(_40[_128 + 20u], _137), _139))) + (ToneMapCBuffer_m0[3u].y * min(max(_40[_128 + 21u], _137), _139));
    float _225 = exp2(_223 + (ToneMapCBuffer_m0[3u].z * min(max(_40[_128 + 22u], _137), _139)));
    
    // --- Main Texture ---
    float _234 = ToneMapCBuffer_m0[0u].x * (float(gl_GlobalInvocationID.x) + 0.5f);
    float _235 = ToneMapCBuffer_m0[0u].y * (float(gl_GlobalInvocationID.y) + 0.5f);
    float4 _239 = g_TmRadianceMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f);
    float _244 = _239.x * _225;
    float _245 = _239.y * _225;
    float _246 = _239.z * _225;

    float3 inputColor = float3(_244, _245, _246);

    // --- Chromatic Aberration and Bloom ---
    float _250 = _234 * 2.0f;
    float _252 = _235 * 2.0f;
    float _254 = _250 + (-1.0f);
    float _256 = (_252 * ToneMapCBuffer_m0[1u].w) - ToneMapCBuffer_m0[1u].w;
    float _268 = clamp((ToneMapCBuffer_m0[4u].z * dot(float2(_254, _256), float2(_254, _256))) - ToneMapCBuffer_m0[4u].w, 0.0f, 1.0f);
    float _270 = ToneMapCBuffer_m0[4u].y * _268;
    float _276 = _270 * 0.5f;
    float _293 = saturate(_268 * 1.6665999889373779296875f);
    float4 _305 = g_TmBloomMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f);
    float _310 = ((_293 * (g_TmChromaticAbMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f).x - _244)) + _244) + _305.x;
    float _311 = ((_293 * (g_TmChromaticAbMap.SampleLevel(g_LinearClampSampler, float2(_234 - (_276 * _254), _235 - (_276 * _256)), 0.0f).y - _245)) + _245) + _305.y;
    float _312 = (((g_TmChromaticAbMap.SampleLevel(g_LinearClampSampler, float2(_234 - (_270 * _254), _235 - (_270 * _256)), 0.0f).z - _246) * _293) + _246) + _305.z;
    
    // --- Contrast Slider ---
    float _342;
    float _343;
    float _344;
    if (ToneMapCBuffer_m0[7u].y != 0.0f)    // if contrast slider is not 10
    {
        float _323 = saturate(dot(float3(_310, _311, _312), float3(0.3f, 0.5f, 0.2f)));
        float _338 = ((((((_323 * _323) * _323) * ((((_323 * 6.0f) + (-15.0f)) * _323) + 10.0f)) - _323) * ToneMapCBuffer_m0[7u].y) + _323) / max(_323, 9.9999997473787516355514526367188e-06f);
        _342 = _338 * _310;
        _343 = _338 * _311;
        _344 = _338 * _312;
    }
    else
    {
        _342 = _310;
        _343 = _311;
        _344 = _312;
    }
    
    // --- UI ---
    float _354 = (_234 * ToneMapCBuffer_m0[6u].x) + ToneMapCBuffer_m0[6u].z;
    float _355 = (_235 * ToneMapCBuffer_m0[6u].y) + ToneMapCBuffer_m0[6u].w;
    float _362 = clamp((1.0f - max(abs(_354), abs(_355))) * 4096.0f, 0.0f, 1.0f);
    float4 _369 = g_TmSrgbOverlayMap.SampleLevel(g_LinearClampSampler, float2((_354 * 0.5f) + 0.5f, (_355 * 0.5f) + 0.5f), 0.0f);
    float _375 = _369.x * _362;
    float _376 = _369.y * _362;
    float _377 = _369.z * _362;
    float _379 = (_369.w + (-1.0f)) * _362;

    // --- Radial Blur? ---
    float _397 = min(clamp((ToneMapCBuffer_m0[5u].z * dot(float3(_375, _376, _377), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f))) - ToneMapCBuffer_m0[5u].w, 0.0f, 1.0f), clamp(19.5f - ((_379 + 1.0f) * 20.0f), 0.0f, 1.0f));
    float _498;
    float _499;
    float _500;
    if (_397 > 0.0f)
    {
        float4 _401 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f);
        float4 _410 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f, int2(-1, -1));
        float4 _415 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f, int2(0, -1));
        float4 _421 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f, int2(1, -1));
        float4 _427 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f, int2(-1, 0));
        float4 _433 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f, int2(1, 0));
        float4 _439 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f, int2(-1, 1));
        float4 _445 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f, int2(0, 1));
        float4 _451 = g_TmRadianceBlurMap.SampleLevel(g_LinearClampSampler, float2(_234, _235), 0.0f, int2(1, 1));
        _498 = (((((_401.x * 0.25f) - _342) + ((((_427.x + _415.x) + _433.x) + _445.x) * 0.125f)) + ((((_421.x + _410.x) + _439.x) + _451.x) * 0.0625f)) * _397) + _342;
        _499 = (((((_401.y * 0.25f) - _343) + ((((_427.y + _415.y) + _433.y) + _445.y) * 0.125f)) + ((((_421.y + _410.y) + _439.y) + _451.y) * 0.0625f)) * _397) + _343;
        _500 = (((((_401.z * 0.25f) - _344) + ((((_427.z + _415.z) + _433.z) + _445.z) * 0.125f)) + ((((_421.z + _410.z) + _439.z) + _451.z) * 0.0625f)) * _397) + _344;
    }
    else
    {
        _498 = _342;
        _499 = _343;
        _500 = _344;
    }

    // --- ToneMap Setup ---
    float _509 = (_250 - ToneMapCBuffer_m0[5u].x) * ToneMapCBuffer_m0[2u].y;
    float _510 = ToneMapCBuffer_m0[2u].z * (_252 - ToneMapCBuffer_m0[5u].y);
    float _517 = max(sqrt(dot(float2(_509, _510), float2(_509, _510))) - ToneMapCBuffer_m0[2u].w, 0.0f);
    float _520 = 1.0f / ((_517 * _517) + 1.0f);
    float _521 = _520 * _520;

    // --- Film Grain ---
    float _530 = (ToneMapCBuffer_m0[1u].z * 2.0f) + (-0.5f);
    float _532 = ToneMapCBuffer_m0[1u].z * 6.283185482025146484375f;
    float _534 = _234 - _530;
    float _535 = (ToneMapCBuffer_m0[1u].w * _235) - _530;
    float _536 = sin(_532);
    float _537 = cos(_532);
    float _554 = g_TmFilmGrainNoise.SampleLevel(g_LinearWrapSampler, float2(((_530 - (_535 * _536)) + (_534 * _537)) * ToneMapCBuffer_m0[1u].x, (((_534 * _536) + _530) + (_535 * _537)) * ToneMapCBuffer_m0[1u].x), 0.0f).x * 2.0f;
    float _561 = ((((_554 >= 1.0f) ? _554 : (1.0f / (2.0f - _554))) + (-1.0f)) * ToneMapCBuffer_m0[1u].y) + 1.0f;  // ToneMapCBuffer_m0[1u].y = film grain strength

    // --- Auto Exposure ---
    float _571 = ToneMapCBuffer_m0[2u].x * asfloat(g_TmAdaptedLumBuffer.Load(1u).x);

    // --- Tone Mapping LUT Application ---
    float3 lutInputColor = _521 * float3(_498, _499, _500) * _561 * _571;
    const float lutScale = 31.f / 512.f, lutOffset = 333.5f / 512.f;
    const float3 lutInputShaped = (log2(lutInputColor) * lutScale) + lutOffset;
    float4 _589 = g_TmToneMapLookup.SampleLevel(g_LinearClampSampler, lutInputShaped, 0.0f);
    float _597 = (ToneMapCBuffer_m0[7u].w != 0.0f) ? ToneMapCBuffer_m0[7u].z : 1.0f;
    float _598 = _597 * _589.x;
    float _599 = _597 * _589.y;
    float _600 = _597 * _589.z;

#if 0  // scale LUT Output
    float3 lutInputColorTM = renodx::tonemap::dice::BT709(lutInputColor, 1500.f / 200.f, 1.f);
    float3 lutOutputColor = renodx::math::SignPow(float3(_598, _599, _600), 2.2f);
    float3 scaledLUTOutput = UpgradeToneMap(lutInputColor, lutInputColorTM, lutOutputColor, 1.f, 2u);
    scaledLUTOutput = renodx::tonemap::dice::BT709(scaledLUTOutput, 1080.f / 200.f, 1.f);
    scaledLUTOutput = renodx::math::SignPow(scaledLUTOutput, 1.f / 2.2f);

    _598 = scaledLUTOutput.r, _599 = scaledLUTOutput.g, _600 = scaledLUTOutput.b;
#endif

    //  --- Blend UI and Game ---
    float _601 = (-0.0f) - _379;
    float _606 = (_598 * _601) + _375;
    float _607 = (_599 * _601) + _376;
    float _608 = (_600 * _601) + _377;

    // inputColor = pow(float3(_606, _607, _608), 2.2f);

    float _662;
    float _663;
    float _664;
    float _665;
    float _666;
    float _667;
    // LUT Application, tonemap, apply LUT, inverse tonemap
    if (ToneMapCBuffer_m0[7u].x != 0.0f)
    {
        float _611 = max(_606, 1.0f);
        float _612 = max(_607, 1.0f);
        float _613 = max(_608, 1.0f);
        float _614 = 1.0f / _611;
        float _615 = 1.0f / _612;
        float _616 = 1.0f / _613;
        float _617 = _614 * _606;
        float _618 = _615 * _607;
        float _619 = _616 * _608;
        float _620 = _614 * _598;
        float _621 = _615 * _599;
        float _622 = _616 * _600;
        float4 _633 = g_TmColorFilterMap.SampleLevel(g_LinearClampSampler, float3((_617 * 0.96875f) + 0.015625f, (_618 * 0.96875f) + 0.015625f, (_619 * 0.96875f) + 0.015625f), 0.0f);
        float _635 = _633.x;
        float _636 = _633.y;
        float _637 = _633.z;
        _662 = ((ToneMapCBuffer_m0[7u].x * (_635 - _617)) + _617) * _611;
        _663 = ((ToneMapCBuffer_m0[7u].x * (_636 - _618)) + _618) * _612;
        _664 = ((ToneMapCBuffer_m0[7u].x * (_637 - _619)) + _619) * _613;
        _665 = ((ToneMapCBuffer_m0[7u].x * (_635 - _620)) + _620) * _611;
        _666 = ((ToneMapCBuffer_m0[7u].x * (_636 - _621)) + _621) * _612;
        _667 = ((ToneMapCBuffer_m0[7u].x * (_637 - _622)) + _622) * _613;
    }
    else
    {
        _662 = _606;
        _663 = _607;
        _664 = _608;
        _665 = _598;
        _666 = _599;
        _667 = _600;
    }
    
    float _798;
    float _799;
    float _800;
    float _801;
    float _802;
    float _803;

    if (ToneMapCBuffer_m0[3u].w != 0.0f)    // BT.2020 + PQ
    {
        // scene gamma - 1.9 for some reason
        float3 scene = float3(_662, _663, _664);
        scene = renodx::math::SignPow(scene, m_HdrGamma);
        float _680 = scene.r, _681 = scene.g, _682 = scene.b;        
        
        // scene nits
        float _683 = ToneMapCBuffer_m0[8u].x * 9.9999997473787516355514526367188e-05f;

        // bt.2020
        float _713 = exp2(log2(mad(0.0432999990880489349365234375f, _682, mad(0.329299986362457275390625f, _681, _680 * 0.627399981021881103515625f)) * _683) * 0.1593017578125f);
        float _714 = exp2(log2(mad(0.011400000192224979400634765625f, _682, mad(0.91949999332427978515625f, _681, _680 * 0.069099999964237213134765625f)) * _683) * 0.1593017578125f);
        float _715 = exp2(log2(mad(0.895600020885467529296875f, _682, mad(0.087999999523162841796875f, _681, _680 * 0.01640000008046627044677734375f)) * _683) * 0.1593017578125f);

        float3 color = float3(_665, _666, _667);
        color = renodx::math::SignPow(color, m_HdrGamma);
        float _750 = color.r, _751 = color.g, _752 = color.b;

        float _771 = exp2(log2(mad(0.0432999990880489349365234375f, _752, mad(0.329299986362457275390625f, _751, _750 * 0.627399981021881103515625f)) * _683) * 0.1593017578125f);
        float _772 = exp2(log2(mad(0.011400000192224979400634765625f, _752, mad(0.91949999332427978515625f, _751, _750 * 0.069099999964237213134765625f)) * _683) * 0.1593017578125f);
        float _773 = exp2(log2(mad(0.895600020885467529296875f, _752, mad(0.087999999523162841796875f, _751, _750 * 0.01640000008046627044677734375f)) * _683) * 0.1593017578125f);
        _798 = exp2(log2(((_713 * 18.8515625f) + 0.8359375f) / ((_713 * 18.6875f) + 1.0f)) * 78.84375f);
        _799 = exp2(log2(((_714 * 18.8515625f) + 0.8359375f) / ((_714 * 18.6875f) + 1.0f)) * 78.84375f);
        _800 = exp2(log2(((_715 * 18.8515625f) + 0.8359375f) / ((_715 * 18.6875f) + 1.0f)) * 78.84375f);
        
        _801 = exp2(log2(((_771 * 18.8515625f) + 0.8359375f) / ((_771 * 18.6875f) + 1.0f)) * 78.84375f);
        _802 = exp2(log2(((_772 * 18.8515625f) + 0.8359375f) / ((_772 * 18.6875f) + 1.0f)) * 78.84375f);
        _803 = exp2(log2(((_773 * 18.8515625f) + 0.8359375f) / ((_773 * 18.6875f) + 1.0f)) * 78.84375f);
    }
    else
    {
        _798 = _662;
        _799 = _663;
        _800 = _664;
        _801 = _665;
        _802 = _666;
        _803 = _667;
    }
    // --- Write Final Outputs ---
    g_TmOutput[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_798, _799, _800, 1.0f);
    // g_TmOutput[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(inputColor), 200.f), 1.0f);
    if (ToneMapCBuffer_m0[9u].z != 0.0f)
    {
        g_TmOutputHudless[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_801, _802, _803, 1.0f);
    }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
    comp_main();
}

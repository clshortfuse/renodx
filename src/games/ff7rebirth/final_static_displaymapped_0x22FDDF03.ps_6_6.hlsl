#include "./common.hlsl"

cbuffer _GlobalsUBO : register(b0, space0)
{
    float4 _Globals_m0[55] : packoffset(c0);
};

cbuffer ViewUBO : register(b1, space0)
{
    float4 View_m0[300] : packoffset(c0);
};

Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0, space0);
Texture2D<float4> ColorTexture : register(t1, space0);
Texture2D<float4> GlareTexture : register(t2, space0);
Texture2D<float4> CompositeSDRTexture : register(t3, space0);
Texture3D<float4> BT709PQToBT2020PQLUT : register(t4, space0);
SamplerState View_SharedBilinearClampedSampler : register(s0, space0);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 TEXCOORD_1;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    noperspective float2 TEXCOORD : TEXCOORD0;
    noperspective float4 TEXCOORD_1 : TEXCOORD1;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

float getMidGray() {
  float3 lutInputColor = saturate(renodx::color::pq::Encode(0.18f, 100.f));
  float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT,
                                         View_SharedBilinearClampedSampler,
                                         lutInputColor,
                                         32u);
  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult, 250);

  return renodx::color::y::from::BT2020(lutOutputColor_bt2020);
}

void frag_main()
{
    bool _58 = _Globals_m0[54u].z != 0.0f;
    uint _68 = uint(int(gl_FragCoord.x));
    uint _69 = uint(int(gl_FragCoord.y));
    uint4 _81 = asuint(_Globals_m0[43u]);
    float _86 = gl_FragCoord.x - float(_81.x);
    float _87 = gl_FragCoord.y - float(_81.y);
    float _97 = clamp(_86 * _Globals_m0[44u].z, 0.0f, 1.0f);
    float _98 = clamp(_87 * _Globals_m0[44u].w, 0.0f, 1.0f);
    float _113 = _58 ? clamp(_Globals_m0[44u].z * ((floor(_86 * 0.5f) * 2.0f) + 1.0f), 0.0f, 1.0f) : _97;
    float _114 = _58 ? clamp(((floor(_87 * 0.5f) * 2.0f) + 1.0f) * _Globals_m0[44u].w, 0.0f, 1.0f) : _98;
    uint4 _125 = asuint(_Globals_m0[29u]);
    uint4 _160 = asuint(_Globals_m0[36u]);
    float4 _206 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(min(max(((_Globals_m0[30u].x * _113) + float(_125.x)) * _Globals_m0[27u].z, _Globals_m0[33u].x), _Globals_m0[33u].z), min(max(((_Globals_m0[30u].y * _114) + float(_125.y)) * _Globals_m0[27u].w, _Globals_m0[33u].y), _Globals_m0[33u].w)), 0.0f);
    float _223 = (1.0f / max(0.001000000047497451305389404296875f, _Globals_m0[48u].y)) * TEXCOORD_1.z;
    float _232 = (_223 * _223) * (1.0f / max(9.9999997473787516355514526367188e-06f, dot(float3(TEXCOORD_1.x, TEXCOORD_1.y, _223), float3(TEXCOORD_1.x, TEXCOORD_1.y, _223))));
    float _237 = (((_232 * _232) + (-1.0f)) * _Globals_m0[48u].x) + 1.0f;
    float _238 = _237 * min(_206.x, 65504.0f);
    float _239 = _237 * min(_206.y, 65504.0f);
    float _240 = _237 * min(_206.z, 65504.0f);
    float4 _243 = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(min(max(((_Globals_m0[37u].x * _113) + float(_160.x)) * _Globals_m0[34u].z, _Globals_m0[40u].x), _Globals_m0[40u].z), min(max(((_Globals_m0[37u].y * _114) + float(_160.y)) * _Globals_m0[34u].w, _Globals_m0[40u].y), _Globals_m0[40u].w)), 0.0f);
    float _248 = _243.w;
    float _277 = clamp(_Globals_m0[30u].x * 0.00026041668024845421314239501953125f, 0.0f, 1.0f);
    float _278 = float(int(_68));
    float _280 = _278 * 0.61803400516510009765625f;
    float _282 = float(int(_69)) * 0.61803400516510009765625f;
    float _290 = max(1.0000000116860974230803549289703e-07f, frac(tan(sqrt((_282 * _282) + (_280 * _280))) * _278));
    float _295 = floor(frac(_Globals_m0[50u].w) * 59.940059661865234375f);
    float _296 = _290 + 0.3333333432674407958984375f;
    float _298 = _290 + 0.666666686534881591796875f;
    float _300 = _295 * 63.131244659423828125f;
    float _311 = (frac(_300 + _290) * 2.0f) + (-1.0f);
    float _312 = (frac(_296 + _300) * 2.0f) + (-1.0f);
    float _313 = (frac(_298 + _300) * 2.0f) + (-1.0f);
    float _315 = (_295 + 1.0f) * 63.131244659423828125f;
    float _325 = (frac(_315 + _290) * 2.0f) + (-1.0f);
    float _326 = (frac(_296 + _315) * 2.0f) + (-1.0f);
    float _327 = (frac(_298 + _315) * 2.0f) + (-1.0f);
    float _337 = (abs(_311) > abs(_325)) ? _311 : _325;
    float _338 = (abs(_312) > abs(_326)) ? _312 : _326;
    float _339 = (abs(_313) > abs(_327)) ? _313 : _327;
    float _340 = _277 * _277;
    float _387 = ((View_m0[164u].z + (-1.0f)) * _Globals_m0[50u].z) + 1.0f;
    float _391 = (((float(int(uint(_337 > 0.0f) - uint(_337 < 0.0f))) * _Globals_m0[50u].x) * (1.0f - exp2(log2(max(0.0f, 1.0f - abs(_337))) * _340))) * View_m0[164u].y) * _387;
    float _395 = (((float(int(uint(_338 > 0.0f) - uint(_338 < 0.0f))) * _Globals_m0[50u].x) * (1.0f - exp2(log2(max(0.0f, 1.0f - abs(_338))) * _340))) * View_m0[164u].y) * _387;
    float _399 = (((float(int(uint(_339 > 0.0f) - uint(_339 < 0.0f))) * _Globals_m0[50u].x) * (1.0f - exp2(log2(max(0.0f, 1.0f - abs(_339))) * _340))) * View_m0[164u].y) * _387;
    float _400 = dot(float3(_391, _395, _399), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _430 = (((_Globals_m0[49u].x * ((min(_243.x, 65504.0f) - _238) + (_238 * _248))) + _238) + _391) + ((_400 - _391) * _Globals_m0[50u].y);
    float _450 = (((_Globals_m0[49u].x * ((min(_243.y, 65504.0f) - _239) + (_239 * _248))) + _239) + _395) + ((_400 - _395) * _Globals_m0[50u].y);
    float _466 = (((_Globals_m0[49u].x * (((_240 * _248) - _240) + min(_243.z, 65504.0f))) + _240) + _399) + ((_400 - _399) * _Globals_m0[50u].y);


    float3 ungraded_bt709 = float3(_430, _450, _466);
    float3 lutInputColor = saturate(renodx::color::pq::EncodeSafe(ungraded_bt709, 100.f));
    float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT, View_SharedBilinearClampedSampler, lutInputColor, 32u);
    float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult);
    float3 tonemapped = lutOutputColor_bt2020;
#if 1
    tonemapped = extractColorGradeAndApplyTonemap(ungraded_bt709, lutOutputColor_bt2020, getMidGray());
#endif
    float _509 = tonemapped.r, _524 = tonemapped.g, _538 = tonemapped.b;

    float4 _542 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((_Globals_m0[44u].x * 0.5625f) * _Globals_m0[44u].w, 1.0f) * (_97 + (-0.5f))) + 0.5f, (min((_Globals_m0[44u].y * 1.77777779102325439453125f) * _Globals_m0[44u].z, 1.0f) * (_98 + (-0.5f))) + 0.5f), 0.0f);
    float _544 = _542.x;
    float _545 = _542.y;
    float _546 = _542.z;
    float _547 = _542.w;
    float _560;
    if (_544 < 0.003130800090730190277099609375f)
    {
        _560 = _544 * 12.9200000762939453125f;
    }
    else
    {
        _560 = (exp2(log2(_544) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _568;
    if (_545 < 0.003130800090730190277099609375f)
    {
        _568 = _545 * 12.9200000762939453125f;
    }
    else
    {
        _568 = (exp2(log2(_545) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _576;
    if (_546 < 0.003130800090730190277099609375f)
    {
        _576 = _546 * 12.9200000762939453125f;
    }
    else
    {
        _576 = (exp2(log2(_546) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _577 = _547 * _547;
    float _585 = 1.0f / ((_509 * 40.0f) + 1.0f);
    float _586 = 1.0f / ((_524 * 40.0f) + 1.0f);
    float _587 = 1.0f / ((_538 * 40.0f) + 1.0f);
    float _610 = exp2(log2(_560) * 2.2000000476837158203125f);
    float _611 = exp2(log2(_568) * 2.2000000476837158203125f);
    float _612 = exp2(log2(_576) * 2.2000000476837158203125f);
    float _643 = exp2(log2(clamp(((dot(float3(0.627403914928436279296875f, 0.3292829990386962890625f, 0.04331310093402862548828125f), float3(_610, _611, _612)) * RENODX_GRAPHICS_WHITE_NITS) + (((_509 * 10000.0f) * _547) * (((1.0f - _585) * _577) + _585))) * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
    float _654 = clamp(exp2(log2(max(0.0f, ((_643 * 18.8515625f) + 0.8359375f) * (1.0f / ((_643 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f);
    float _659 = exp2(log2(clamp(((dot(float3(0.069097302854061126708984375f, 0.919540584087371826171875f, 0.011362300254404544830322265625f), float3(_610, _611, _612)) * RENODX_GRAPHICS_WHITE_NITS) + (((_524 * 10000.0f) * _547) * (((1.0f - _586) * _577) + _586))) * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
    float _670 = clamp(exp2(log2(max(0.0f, ((_659 * 18.8515625f) + 0.8359375f) * (1.0f / ((_659 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f);
    float _675 = exp2(log2(clamp(((dot(float3(0.0163914002478122711181640625f, 0.088013298809528350830078125f, 0.8955953121185302734375f), float3(_610, _611, _612)) * RENODX_GRAPHICS_WHITE_NITS) + (((_538 * 10000.0f) * _547) * (((1.0f - _587) * _577) + _587))) * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
    float _686 = clamp(exp2(log2(max(0.0f, ((_675 * 18.8515625f) + 0.8359375f) * (1.0f / ((_675 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f);
    float _688 = (View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4(uint3(_68 & 127u, _69 & 127u, asuint(View_m0[175u]).x & 63u), 0u)).x * 2.0f) + (-1.0f);
    float _706 = ((1.0f - sqrt(1.0f - abs(_688))) * float(int(uint(_688 > 0.0f) - uint(_688 < 0.0f)))) * 0.000977517105638980865478515625f;
    SV_Target.x = clamp(((abs((_654 * 2.0f) + (-1.0f)) + (-0.9980449676513671875f)) < 0.0f) ? (_706 + _654) : _654, 0.0f, 1.0f);
    SV_Target.y = clamp(((abs((_670 * 2.0f) + (-1.0f)) + (-0.9980449676513671875f)) < 0.0f) ? (_706 + _670) : _670, 0.0f, 1.0f);
    SV_Target.z = clamp(((abs((_686 * 2.0f) + (-1.0f)) + (-0.9980449676513671875f)) < 0.0f) ? (_706 + _686) : _686, 0.0f, 1.0f);
    SV_Target.w = 0.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    TEXCOORD = stage_input.TEXCOORD;
    TEXCOORD_1 = stage_input.TEXCOORD_1;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}

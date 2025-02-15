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
Texture3D<float4> BT2020PQTosRGBLUT : register(t5, space0);
Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t6);
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
    bool _62 = _Globals_m0[54u].z != 0.0f;
    uint4 _85 = asuint(_Globals_m0[43u]);
    float _90 = gl_FragCoord.x - float(_85.x);
    float _91 = gl_FragCoord.y - float(_85.y);
    float _101 = clamp(_90 * _Globals_m0[44u].z, 0.0f, 1.0f);
    float _102 = clamp(_91 * _Globals_m0[44u].w, 0.0f, 1.0f);
    float _117 = _62 ? clamp(_Globals_m0[44u].z * ((floor(_90 * 0.5f) * 2.0f) + 1.0f), 0.0f, 1.0f) : _101;
    float _118 = _62 ? clamp(((floor(_91 * 0.5f) * 2.0f) + 1.0f) * _Globals_m0[44u].w, 0.0f, 1.0f) : _102;
    uint4 _129 = asuint(_Globals_m0[29u]);
    uint4 _164 = asuint(_Globals_m0[36u]);
    float4 _210 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(min(max(((_Globals_m0[30u].x * _117) + float(_129.x)) * _Globals_m0[27u].z, _Globals_m0[33u].x), _Globals_m0[33u].z), min(max(((_Globals_m0[30u].y * _118) + float(_129.y)) * _Globals_m0[27u].w, _Globals_m0[33u].y), _Globals_m0[33u].w)), 0.0f);
    float _227 = (1.0f / max(0.001000000047497451305389404296875f, _Globals_m0[48u].y)) * TEXCOORD_1.z;
    float _236 = (_227 * _227) * (1.0f / max(9.9999997473787516355514526367188e-06f, dot(float3(TEXCOORD_1.x, TEXCOORD_1.y, _227), float3(TEXCOORD_1.x, TEXCOORD_1.y, _227))));
    float _241 = (((_236 * _236) + (-1.0f)) * _Globals_m0[48u].x) + 1.0f;
    float _242 = _241 * min(_210.x, 65504.0f);
    float _243 = _241 * min(_210.y, 65504.0f);
    float _244 = _241 * min(_210.z, 65504.0f);
    float4 _247 = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(min(max(((_Globals_m0[37u].x * _117) + float(_164.x)) * _Globals_m0[34u].z, _Globals_m0[40u].x), _Globals_m0[40u].z), min(max(((_Globals_m0[37u].y * _118) + float(_164.y)) * _Globals_m0[34u].w, _Globals_m0[40u].y), _Globals_m0[40u].w)), 0.0f);
    float _252 = _247.w;
    float _281 = (_Globals_m0[49u].x * ((min(_247.x, 65504.0f) - _242) + (_242 * _252))) + _242;
    float _301 = (_Globals_m0[49u].x * ((min(_247.y, 65504.0f) - _243) + (_243 * _252))) + _243;
    float _317 = (_Globals_m0[49u].x * (((_244 * _252) - _244) + min(_247.z, 65504.0f))) + _244;

#if 0
    float3 color = float3(_281, _301, _317);
    color = pow(color * 0.00999999977648258209228515625f, 0.1593017578125f);
    _281 = color.r, _301 = color.g, _317 = color.b;
    
    
    float4 _340 = BT709PQToBT2020PQLUT.SampleLevel(View_SharedBilinearClampedSampler, float3((clamp(exp2(log2(max(0.0f, ((_281 * 18.8515625f) + 0.8359375f) * (1.0f / ((_281 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f) * 0.96875f) + 0.015625f, (clamp(exp2(log2(max(0.0f, ((_301 * 18.8515625f) + 0.8359375f) * (1.0f / ((_301 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f) * 0.96875f) + 0.015625f, (clamp(exp2(log2(max(0.0f, ((_317 * 18.8515625f) + 0.8359375f) * (1.0f / ((_317 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f) * 0.96875f) + 0.015625f), 0.0f);
    float _349 = exp2(log2(clamp(_340.x, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
    float _360 = exp2(log2(max(0.0f, (_349 + (-0.8359375f)) * (1.0f / (18.8515625f - (_349 * 18.6875f))))) * 6.277394771575927734375f);
    float _361 = _360 * 10000.0f;
    float _366 = exp2(log2(clamp(_340.y, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
    float _375 = exp2(log2(max(0.0f, (_366 + (-0.8359375f)) * (1.0f / (18.8515625f - (_366 * 18.6875f))))) * 6.277394771575927734375f);
    float _376 = _375 * 10000.0f;
    float _380 = exp2(log2(clamp(_340.z, 0.0f, 1.0f)) * 0.0126833133399486541748046875f);
    float _389 = exp2(log2(max(0.0f, (_380 + (-0.8359375f)) * (1.0f / (18.8515625f - (_380 * 18.6875f))))) * 6.277394771575927734375f);
    float _390 = _389 * 10000.0f;
#else
    float3 ungraded_bt709 = float3(_281, _301, _317);
    float3 lutInputColor = saturate(renodx::color::pq::EncodeSafe(ungraded_bt709, 100.f));
    float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT, View_SharedBilinearClampedSampler, lutInputColor, 32u);
    float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult);
    float3 tonemapped = lutOutputColor_bt2020;

#endif
#if 1
    tonemapped = extractColorGradeAndApplyTonemap(ungraded_bt709, lutOutputColor_bt2020, getMidGray());
#endif
    float _360 = tonemapped.r, _375 = tonemapped.g, _389 = tonemapped.b;
    float _361 = tonemapped.r * 10000.f, _376 = tonemapped.g * 10000.f, _390 = tonemapped.b * 10000.f;

    float _409 = max(9.9999997473787516355514526367188e-05f, _Globals_m0[52u].x);
    float _411 = max(9.9999997473787516355514526367188e-05f, _Globals_m0[52u].y);
    float _412 = max(9.9999997473787516355514526367188e-05f, _Globals_m0[52u].z);
    float _416 = 1.0f / dot(float3(_409, _411, _412), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _417 = dot(float3(_361, _376, _390), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) * 9.9999997473787516355514526367188e-05f;
    float _423 = exp2(log2(clamp((_417 * _409) * _416, 0.0f, 1.0f)) * 0.1593017578125f);
    float _440 = exp2(log2(clamp((_417 * _411) * _416, 0.0f, 1.0f)) * 0.1593017578125f);
    float _457 = exp2(log2(clamp((_417 * _412) * _416, 0.0f, 1.0f)) * 0.1593017578125f);
    float4 _477 = BT2020PQTosRGBLUT.SampleLevel(View_SharedBilinearClampedSampler, float3((clamp(exp2(log2(max(0.0f, ((_423 * 18.8515625f) + 0.8359375f) * (1.0f / ((_423 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f) * 0.96875f) + 0.015625f, (clamp(exp2(log2(max(0.0f, ((_440 * 18.8515625f) + 0.8359375f) * (1.0f / ((_440 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f) * 0.96875f) + 0.015625f, (clamp(exp2(log2(max(0.0f, ((_457 * 18.8515625f) + 0.8359375f) * (1.0f / ((_457 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f) * 0.96875f) + 0.015625f), 0.0f);
    float _479 = _477.x;
    float _480 = _477.y;
    float _481 = _477.z;
    float _494;
    if (_479 < 0.040449999272823333740234375f)
    {
        _494 = _479 * 0.077399380505084991455078125f;
    }
    else
    {
        _494 = exp2(log2((_479 + 0.054999999701976776123046875f) * 0.947867333889007568359375f) * 2.400000095367431640625f);
    }
    float _502;
    if (_480 < 0.040449999272823333740234375f)
    {
        _502 = _480 * 0.077399380505084991455078125f;
    }
    else
    {
        _502 = exp2(log2((_480 + 0.054999999701976776123046875f) * 0.947867333889007568359375f) * 2.400000095367431640625f);
    }
    float _510;
    if (_481 < 0.040449999272823333740234375f)
    {
        _510 = _481 * 0.077399380505084991455078125f;
    }
    else
    {
        _510 = exp2(log2((_481 + 0.054999999701976776123046875f) * 0.947867333889007568359375f) * 2.400000095367431640625f);
    }
    float _513 = (1.0f / max(0.001000000047497451305389404296875f, _Globals_m0[51u].z)) * TEXCOORD_1.w;
    float _520 = (_513 * _513) * (1.0f / max(9.9999997473787516355514526367188e-06f, dot(float3(TEXCOORD_1.x, TEXCOORD_1.y, _513), float3(TEXCOORD_1.x, TEXCOORD_1.y, _513))));
    float _524 = (clamp(_520 * _520, 0.0f, 1.0f) + (-1.0f)) * _Globals_m0[51u].y;
    float _525 = (-0.0f) - _524;
    float4 _531 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((_Globals_m0[44u].x * 0.5625f) * _Globals_m0[44u].w, 1.0f) * (_101 + (-0.5f))) + 0.5f, (min((_Globals_m0[44u].y * 1.77777779102325439453125f) * _Globals_m0[44u].z, 1.0f) * (_102 + (-0.5f))) + 0.5f), 0.0f);
    float _536 = _531.w;
    float _546 = (((_494 * _Globals_m0[51u].x) * _525) * _536) + _531.x;
    float _547 = (((_502 * _Globals_m0[51u].x) * _525) * _536) + _531.y;
    float _548 = (((_510 * _Globals_m0[51u].x) * _525) * _536) + _531.z;
    float _549 = _536 * ((_524 * _Globals_m0[51u].x) + 1.0f);
    float _562;
    if (_546 < 0.003130800090730190277099609375f)
    {
        _562 = _546 * 12.9200000762939453125f;
    }
    else
    {
        _562 = (exp2(log2(_546) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _570;
    if (_547 < 0.003130800090730190277099609375f)
    {
        _570 = _547 * 12.9200000762939453125f;
    }
    else
    {
        _570 = (exp2(log2(_547) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _578;
    if (_548 < 0.003130800090730190277099609375f)
    {
        _578 = _548 * 12.9200000762939453125f;
    }
    else
    {
        _578 = (exp2(log2(_548) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _579 = _549 * _549;
    float _587 = 1.0f / ((_360 * 40.0f) + 1.0f);
    float _588 = 1.0f / ((_375 * 40.0f) + 1.0f);
    float _589 = 1.0f / ((_389 * 40.0f) + 1.0f);
    float _612 = exp2(log2(_562) * 2.2000000476837158203125f);
    float _613 = exp2(log2(_570) * 2.2000000476837158203125f);
    float _614 = exp2(log2(_578) * 2.2000000476837158203125f);
    float _644 = exp2(log2(clamp(((dot(float3(0.627403914928436279296875f, 0.3292829990386962890625f, 0.04331310093402862548828125f), float3(_612, _613, _614)) * RENODX_GRAPHICS_WHITE_NITS) + ((_549 * _361) * (((1.0f - _587) * _579) + _587))) * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
    float _655 = clamp(exp2(log2(max(0.0f, ((_644 * 18.8515625f) + 0.8359375f) * (1.0f / ((_644 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f);
    float _660 = exp2(log2(clamp(((dot(float3(0.069097302854061126708984375f, 0.919540584087371826171875f, 0.011362300254404544830322265625f), float3(_612, _613, _614)) * RENODX_GRAPHICS_WHITE_NITS) + ((_549 * _376) * (((1.0f - _588) * _579) + _588))) * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
    float _671 = clamp(exp2(log2(max(0.0f, ((_660 * 18.8515625f) + 0.8359375f) * (1.0f / ((_660 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f);
    float _676 = exp2(log2(clamp(((dot(float3(0.0163914002478122711181640625f, 0.088013298809528350830078125f, 0.8955953121185302734375f), float3(_612, _613, _614)) * RENODX_GRAPHICS_WHITE_NITS) + ((_549 * _390) * (((1.0f - _589) * _579) + _589))) * 9.9999997473787516355514526367188e-05f, 0.0f, 1.0f)) * 0.1593017578125f);
    float _687 = clamp(exp2(log2(max(0.0f, ((_676 * 18.8515625f) + 0.8359375f) * (1.0f / ((_676 * 18.6875f) + 1.0f)))) * 78.84375f), 0.0f, 1.0f);
    float _689 = (View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4(uint3(uint(int(gl_FragCoord.x)) & 127u, uint(int(gl_FragCoord.y)) & 127u, asuint(View_m0[175u]).x & 63u), 0u)).x * 2.0f) + (-1.0f);
    float _707 = ((1.0f - sqrt(1.0f - abs(_689))) * float(int(uint(_689 > 0.0f) - uint(_689 < 0.0f)))) * 0.000977517105638980865478515625f;
    SV_Target.x = clamp(((abs((_655 * 2.0f) + (-1.0f)) + (-0.9980449676513671875f)) < 0.0f) ? (_707 + _655) : _655, 0.0f, 1.0f);
    SV_Target.y = clamp(((abs((_671 * 2.0f) + (-1.0f)) + (-0.9980449676513671875f)) < 0.0f) ? (_707 + _671) : _671, 0.0f, 1.0f);
    SV_Target.z = clamp(((abs((_687 * 2.0f) + (-1.0f)) + (-0.9980449676513671875f)) < 0.0f) ? (_707 + _687) : _687, 0.0f, 1.0f);
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

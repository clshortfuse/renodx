cbuffer _RootShaderParametersUBO : register(b0, space0) {
  float4 _RootShaderParameters_m0[49] : packoffset(c0);
}

cbuffer UniformBufferConstants_ViewUBO : register(b1, space0) {
  float4 UniformBufferConstants_View_m0[344] : packoffset(c0);
}

StructuredBuffer<float4> EyeAdaptationBuffer : register(t0, space0);
Texture2D<float4> ColorTexture : register(t1, space0);
Texture2D<float4> BloomTexture : register(t2, space0);
StructuredBuffer<float4> SceneColorApplyParamaters : register(t3, space0);
Texture2D<float3> FilmGrainTexture : register(t4, space0);
StructuredBuffer<float4> FilmGrainTextureConstants : register(t5, space0);
Texture2D<float4> BloomDirtMaskTexture : register(t6, space0);
Texture3D<float4> ColorGradingLUT : register(t7, space0);
SamplerState ColorSampler : register(s0, space0);
SamplerState BloomSampler : register(s1, space0);
SamplerState FilmGrainSampler : register(s2, space0);
SamplerState BloomDirtMaskSampler : register(s3, space0);
SamplerState ColorGradingLUTSampler : register(s4, space0);

static float2 TEXCOORD;
static float2 TEXCOORD_1;
static float4 TEXCOORD_2;
static float2 TEXCOORD_3;
static float2 TEXCOORD_4;
static float4 SV_Target;
static float SV_Target_1;

struct SPIRV_Cross_Input {
  noperspective float2 TEXCOORD : TEXCOORD0;
  noperspective float2 TEXCOORD_1 : TEXCOORD1;
  noperspective float4 TEXCOORD_2 : TEXCOORD2;
  noperspective float2 TEXCOORD_3 : TEXCOORD3;
  noperspective float2 TEXCOORD_4 : TEXCOORD4;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

void frag_main() {
  float _98 = (_RootShaderParameters_m0[45u].z * TEXCOORD_3.x) + _RootShaderParameters_m0[45u].x;
  float _99 = (_RootShaderParameters_m0[45u].w * TEXCOORD_3.y) + _RootShaderParameters_m0[45u].y;
  float _112 = float(int(uint(_98 > 0.0f) - uint(_98 < 0.0f)));
  float _113 = float(int(uint(_99 > 0.0f) - uint(_99 < 0.0f)));
  float _120 = clamp(abs(_98) - _RootShaderParameters_m0[43u].z, 0.0f, 1.0f);
  float _121 = clamp(abs(_99) - _RootShaderParameters_m0[43u].z, 0.0f, 1.0f);
  float4 _188 = ColorTexture.Sample(
    ColorSampler,
    float2(min(max((((((_98 - ((_120 * _RootShaderParameters_m0[43u].x) * _112)) * _RootShaderParameters_m0[46u].z) + _RootShaderParameters_m0[46u].x) * _RootShaderParameters_m0[10u].x) + _RootShaderParameters_m0[10u].z) * _RootShaderParameters_m0[9u].z, _RootShaderParameters_m0[15u].x), _RootShaderParameters_m0[15u].z), min(max((((((_99 - ((_121 * _RootShaderParameters_m0[43u].x) * _113)) * _RootShaderParameters_m0[46u].w) + _RootShaderParameters_m0[46u].y) * _RootShaderParameters_m0[10u].y) + _RootShaderParameters_m0[10u].w) * _RootShaderParameters_m0[9u].w, _RootShaderParameters_m0[15u].y), _RootShaderParameters_m0[15u].w))
  );
  float _190 = _188.x;
  float4 _204 = ColorTexture.Sample(
    ColorSampler,
    float2(min(max(((_RootShaderParameters_m0[10u].x * (((_98 - ((_120 * _RootShaderParameters_m0[43u].y) * _112)) * _RootShaderParameters_m0[46u].z) + _RootShaderParameters_m0[46u].x)) + _RootShaderParameters_m0[10u].z) * _RootShaderParameters_m0[9u].z, _RootShaderParameters_m0[15u].x), _RootShaderParameters_m0[15u].z), min(max(((_RootShaderParameters_m0[10u].y * (((_99 - ((_121 * _RootShaderParameters_m0[43u].y) * _113)) * _RootShaderParameters_m0[46u].w) + _RootShaderParameters_m0[46u].y)) + _RootShaderParameters_m0[10u].w) * _RootShaderParameters_m0[9u].w, _RootShaderParameters_m0[15u].y), _RootShaderParameters_m0[15u].w))
  );
  float _206 = _204.y;
  float4 _220 = ColorTexture.Sample(
    ColorSampler, float2(min(max(TEXCOORD.x, _RootShaderParameters_m0[15u].x), _RootShaderParameters_m0[15u].z), min(max(TEXCOORD.y, _RootShaderParameters_m0[15u].y), _RootShaderParameters_m0[15u].w))
  );
  float _222 = _220.z;
  float4 _248 = BloomTexture.Sample(
    BloomSampler,
    float2(min(max((_RootShaderParameters_m0[33u].x * TEXCOORD.x) + _RootShaderParameters_m0[33u].z, _RootShaderParameters_m0[34u].x), _RootShaderParameters_m0[34u].z), min(max((_RootShaderParameters_m0[33u].y * TEXCOORD.y) + _RootShaderParameters_m0[33u].w, _RootShaderParameters_m0[34u].y), _RootShaderParameters_m0[34u].w))
  );
  float4 _271 = BloomDirtMaskTexture.Sample(
    BloomDirtMaskSampler,
    float2((((_RootShaderParameters_m0[45u].z * TEXCOORD_3.x) + _RootShaderParameters_m0[45u].x) * 0.5f) + 0.5f, 0.5f - (((_RootShaderParameters_m0[45u].w * TEXCOORD_3.y) + _RootShaderParameters_m0[45u].y) * 0.5f))
  );
  float _295 = _RootShaderParameters_m0[44u].x * TEXCOORD_1.x;
  float _296 = _RootShaderParameters_m0[44u].x * TEXCOORD_1.y;
  float _301 = 1.0f / (dot(float2(_295, _296), float2(_295, _296)) + 1.0f);
  float3 _321 = SceneColorApplyParamaters.Load(0u).xyz;
  float _326 = dot(float3(_190, _206, _222), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
  float _346 = (float(uint(floor(_RootShaderParameters_m0[9u].x * TEXCOORD.x)) & 1u) * 2.0f) + (-1.0f);
  float _351 = (float(uint(floor(_RootShaderParameters_m0[9u].y * TEXCOORD.y)) & 1u) * 2.0f) + (-1.0f);
  float4 _368 = ColorTexture.Sample(
    ColorSampler,
    float2(min(max((_346 * _RootShaderParameters_m0[9u].z) + TEXCOORD.x, _RootShaderParameters_m0[15u].x), _RootShaderParameters_m0[15u].z), min(max(TEXCOORD.y, _RootShaderParameters_m0[15u].y), _RootShaderParameters_m0[15u].w))
  );
  float _370 = _368.x;
  float4 _391 = ColorTexture.Sample(
    ColorSampler,
    float2(min(max(TEXCOORD.x, _RootShaderParameters_m0[15u].x), _RootShaderParameters_m0[15u].z), min(max((_RootShaderParameters_m0[9u].w * _351) + TEXCOORD.y, _RootShaderParameters_m0[15u].y), _RootShaderParameters_m0[15u].w))
  );
  float _393 = _391.x;
  float _418 = asfloat(EyeAdaptationBuffer.Load(0u).x) * UniformBufferConstants_View_m0[132u].w;
  float _432 = (-0.0f) - (_RootShaderParameters_m0[44u].y * clamp(1.0f - (_418 * max(max(abs(_326 - dot(float3(_370, _368.yz), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))), abs(_326 - dot(float3(_393, _391.yz), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), max(abs(ddx_fine(_326) * _346), abs(ddy_fine(_326) * _351)))), 0.0f, 1.0f));
  float _462 = _418 * (_301 * _301);
  float _475 = (((_462 * _RootShaderParameters_m0[41u].x) * _321.x) * ((((((((_370 - (_190 * 4.0f)) + _393) + _190) - (ddx_fine(_190) * _346)) + _190) - (ddy_fine(_190) * _351)) * _432) + _190)) + ((((_RootShaderParameters_m0[42u].x * _271.x) + 1.0f) * _248.x) * _462);
  float _476 = (((_462 * _RootShaderParameters_m0[41u].y) * _321.y) * ((((((((_368.y - (_206 * 4.0f)) + _391.y) + _206) - (ddx_fine(_206) * _346)) + _206) - (ddy_fine(_206) * _351)) * _432) + _206)) + ((((_RootShaderParameters_m0[42u].y * _271.y) + 1.0f) * _248.y) * _462);
  float _477 = (((_462 * _RootShaderParameters_m0[41u].z) * _321.z) * ((((((((_368.z - (_222 * 4.0f)) + _391.z) + _222) - (ddx_fine(_222) * _346)) + _222) - (ddy_fine(_222) * _351)) * _432) + _222)) + ((((_RootShaderParameters_m0[42u].z * _271.z) + 1.0f) * _248.z) * _462);
  float4 _511 = ColorGradingLUT.Sample(
    ColorGradingLUTSampler,
    float3((_RootShaderParameters_m0[47u].z * clamp((log2(_475 + 0.00266771926544606685638427734375f) * 0.071428574621677398681640625f) + 0.61072695255279541015625f, 0.0f, 1.0f)) + _RootShaderParameters_m0[47u].w, (_RootShaderParameters_m0[47u].z * clamp((log2(_476 + 0.00266771926544606685638427734375f) * 0.071428574621677398681640625f) + 0.61072695255279541015625f, 0.0f, 1.0f)) + _RootShaderParameters_m0[47u].w, (_RootShaderParameters_m0[47u].z * clamp((log2(_477 + 0.00266771926544606685638427734375f) * 0.071428574621677398681640625f) + 0.61072695255279541015625f, 0.0f, 1.0f)) + _RootShaderParameters_m0[47u].w)
  );
  float3 _530 = FilmGrainTextureConstants.Load(0u).xyz;
  float _534 = dot(float3(_475, _476, _477), float3(0.0405550040304660797119140625f, 0.73296964168548583984375f, -0.0315674953162670135498046875f));
  float _544 = clamp(_534 / _RootShaderParameters_m0[2u].z, 0.0f, 1.0f);
  float _549 = (_544 * _544) * (3.0f - (_544 * 2.0f));
  float _558 = clamp(
    (_534 - _RootShaderParameters_m0[2u].w) / (_RootShaderParameters_m0[3u].x - _RootShaderParameters_m0[2u].w),
    0.0f,
    1.0f
  );
  float _562 = (_558 * _558) * (3.0f - (_558 * 2.0f));
  float _573 = (((_549 - _562) * _RootShaderParameters_m0[2u].x) + (_RootShaderParameters_m0[1u].w * (1.0f - _549))) + (_RootShaderParameters_m0[2u].y * _562);
  float3 _588 = FilmGrainTexture.SampleLevel(
    FilmGrainSampler,
    float2((_RootShaderParameters_m0[5u].x * TEXCOORD_3.x) + _RootShaderParameters_m0[5u].z, (_RootShaderParameters_m0[5u].y * TEXCOORD_3.y) + _RootShaderParameters_m0[5u].w),
    0.0f
  );
  float4 _636 = ColorGradingLUT.Sample(
    ColorGradingLUTSampler,
    float3(
      (_RootShaderParameters_m0[47u].z * clamp((log2((((((_588.x * _530.x) + (-1.0f)) * _573) + 1.0f) * _475) + 0.00266771926544606685638427734375f) * 0.071428574621677398681640625f) + 0.61072695255279541015625f, 0.0f, 1.0f)) + _RootShaderParameters_m0[47u].w,
      (_RootShaderParameters_m0[47u].z * clamp((log2((((((_588.y * _530.y) + (-1.0f)) * _573) + 1.0f) * _476) + 0.00266771926544606685638427734375f) * 0.071428574621677398681640625f) + 0.61072695255279541015625f, 0.0f, 1.0f)) + _RootShaderParameters_m0[47u].w,
      (_RootShaderParameters_m0[47u].z * clamp((log2((((((_588.z * _530.z) + (-1.0f)) * _573) + 1.0f) * _477) + 0.00266771926544606685638427734375f) * 0.071428574621677398681640625f) + 0.61072695255279541015625f, 0.0f, 1.0f)) + _RootShaderParameters_m0[47u].w
    )
  );
  float _641 = _636.x * 1.0499999523162841796875f;
  float _642 = _636.y * 1.0499999523162841796875f;
  float _643 = _636.z * 1.0499999523162841796875f;
  float _656;
  float _658;
  float _660;
  if (asuint(_RootShaderParameters_m0[48u]).z == 0u) {
    _656 = _641;
    _658 = _642;
    _660 = _643;
  } else {
    float _699 = exp2(log2(_641) * 0.0126833133399486541748046875f);
    float _700 = exp2(log2(_642) * 0.0126833133399486541748046875f);
    float _701 = exp2(log2(_643) * 0.0126833133399486541748046875f);
    float _740 = max(6.1035199905745685100555419921875e-05f, (exp2(log2(max(0.0f, _699 + (-0.8359375f)) / (18.8515625f - (_699 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f) / _RootShaderParameters_m0[48u].x);
    float _742 = max(6.1035199905745685100555419921875e-05f, (exp2(log2(max(0.0f, _700 + (-0.8359375f)) / (18.8515625f - (_700 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f) / _RootShaderParameters_m0[48u].x);
    float _743 = max(6.1035199905745685100555419921875e-05f, (exp2(log2(max(0.0f, _701 + (-0.8359375f)) / (18.8515625f - (_701 * 18.6875f))) * 6.277394771575927734375f) * 10000.0f) / _RootShaderParameters_m0[48u].x);
    _656 = min(_740 * 12.9200000762939453125f, (exp2(log2(max(_740, 0.00313066993840038776397705078125f)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
    _658 = min(_742 * 12.9200000762939453125f, (exp2(log2(max(_742, 0.00313066993840038776397705078125f)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
    _660 = min(_743 * 12.9200000762939453125f, (exp2(log2(max(_743, 0.00313066993840038776397705078125f)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
  }
  float _670 = (frac(sin((TEXCOORD_2.w * 543.30999755859375f) + TEXCOORD_2.z) * 493013.0f) * 2.0f) + (-1.0f);
  float _674 = min(max(_670 * asfloat(0x7f800000u /* inf */), -1.0f), 1.0f);
  float _684 = (_674 - (sqrt(clamp(1.0f - abs(_670), 0.0f, 1.0f)) * _674)) * _RootShaderParameters_m0[48u].y;
  SV_Target.x = _684 + _656;
  SV_Target.y = _684 + _658;
  SV_Target.z = _684 + _660;
  SV_Target.w = 0.0f;
  SV_Target_1 = dot(float3(_511.x * 1.0499999523162841796875f, _511.y * 1.0499999523162841796875f, _511.z * 1.0499999523162841796875f), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  TEXCOORD_1 = stage_input.TEXCOORD_1;
  TEXCOORD_2 = stage_input.TEXCOORD_2;
  TEXCOORD_3 = stage_input.TEXCOORD_3;
  TEXCOORD_4 = stage_input.TEXCOORD_4;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}

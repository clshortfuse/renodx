
struct _EyeAdaptationBuffer {
  float data[4];
};
StructuredBuffer<_EyeAdaptationBuffer> EyeAdaptationBuffer : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> BloomTexture : register(t2);

struct _SceneColorApplyParamaters {
  float data[4];
};
StructuredBuffer<_SceneColorApplyParamaters> SceneColorApplyParamaters : register(t3);

Texture2D<float4> BloomDirtMaskTexture : register(t4);

Texture3D<float4> ColorGradingLUT : register(t5);

cbuffer cb0 : register(b0) {
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_034z : packoffset(c034.z);
  float cb0_034w : packoffset(c034.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  float cb0_044x : packoffset(c044.x);
  float cb0_045x : packoffset(c045.x);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_045w : packoffset(c045.w);
  float cb0_047z : packoffset(c047.z);
  float cb0_047w : packoffset(c047.w);
  float cb0_048x : packoffset(c048.x);
  uint cb0_048y : packoffset(c048.y);
};

cbuffer UniformBufferConstants_View : register(b1) {
  float UniformBufferConstants_View_136z : packoffset(c136.z);
};

SamplerState ColorSampler : register(s0);

SamplerState BloomSampler : register(s1);

SamplerState BloomDirtMaskSampler : register(s2);

SamplerState ColorGradingLUTSampler : register(s3);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float SV_Target_1 : SV_Target1;
};

OutputSignature main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float2 TEXCOORD_1: TEXCOORD1,
    noperspective float4 TEXCOORD_2: TEXCOORD2,
    noperspective float2 TEXCOORD_3: TEXCOORD3,
    noperspective float2 TEXCOORD_4: TEXCOORD4,
    noperspective float4 SV_Position: SV_Position) {
  float4 SV_Target;

  float SV_Target_1;
  float4 _34 = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));
  float4 _54 = SceneColorApplyParamaters[0].data[0 / 4];
  float4 _81 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_033x) * (TEXCOORD.x)) + (cb0_033z)), (cb0_034x))), (cb0_034z))), (min((max((((cb0_033y) * (TEXCOORD.y)) + (cb0_033w)), (cb0_034y))), (cb0_034w)))));
  float4 _105 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_045z) * (TEXCOORD_3.x)) + (cb0_045x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_045w) * (TEXCOORD_3.y)) + (cb0_045y)) * 0.5f))));
  float _127 = (cb0_044x) * (TEXCOORD_1.x);
  float _128 = (cb0_044x) * (TEXCOORD_1.y);
  float _131 = 1.0f / ((dot(float2(_127, _128), float2(_127, _128))) + 1.0f);
  float _134 = ((((float4)(EyeAdaptationBuffer[0].data[0 / 4])).x) * 0.009999999776482582f) * (_131 * _131);
  float _144 = exp2(((log2((_134 * ((((UniformBufferConstants_View_136z) * (_81.x)) * (((cb0_042x) * (_105.x)) + 1.0f)) + ((((UniformBufferConstants_View_136z) * (_34.x)) * (cb0_041x)) * (_54.x)))))) * 0.1593017578125f));
  float _145 = exp2(((log2((_134 * ((((UniformBufferConstants_View_136z) * (_81.y)) * (((cb0_042y) * (_105.y)) + 1.0f)) + ((((UniformBufferConstants_View_136z) * (_34.y)) * (cb0_041y)) * (_54.y)))))) * 0.1593017578125f));
  float _146 = exp2(((log2((_134 * ((((UniformBufferConstants_View_136z) * (_81.z)) * (((cb0_042z) * (_105.z)) + 1.0f)) + ((((UniformBufferConstants_View_136z) * (_34.z)) * (cb0_041z)) * (_54.z)))))) * 0.1593017578125f));
  float4 _185 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((cb0_047z) * (exp2(((log2(((1.0f / ((_144 * 18.6875f) + 1.0f)) * ((_144 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_047w)), (((cb0_047z) * (exp2(((log2(((1.0f / ((_145 * 18.6875f) + 1.0f)) * ((_145 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_047w)), (((cb0_047z) * (exp2(((log2(((1.0f / ((_146 * 18.6875f) + 1.0f)) * ((_146 * 18.8515625f) + 0.8359375f)))) * 78.84375f)))) + (cb0_047w))));

  float _189 = (_185.x) * 1.0499999523162842f;
  float _190 = (_185.y) * 1.0499999523162842f;
  float _191 = (_185.z) * 1.0499999523162842f;
  float _199 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 0.00390625f) + -0.001953125f;
  float _200 = _199 + _189;
  float _201 = _199 + _190;
  float _202 = _199 + _191;
  float _276 = _200;
  float _277 = _201;
  float _278 = _202;
  if (!((((uint)(cb0_048y)) == 0))) {
    float _213 = exp2(((log2(_200)) * 0.012683313339948654f));
    float _214 = exp2(((log2(_201)) * 0.012683313339948654f));
    float _215 = exp2(((log2(_202)) * 0.012683313339948654f));
    float _248 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_213 + -0.8359375f))) / (18.8515625f - (_213 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_048x)));
    float _249 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_214 + -0.8359375f))) / (18.8515625f - (_214 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_048x)));
    float _250 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_215 + -0.8359375f))) / (18.8515625f - (_215 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_048x)));
    _276 = (min((_248 * 12.920000076293945f), (((exp2(((log2((max(_248, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _277 = (min((_249 * 12.920000076293945f), (((exp2(((log2((max(_249, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _278 = (min((_250 * 12.920000076293945f), (((exp2(((log2((max(_250, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  SV_Target.x = _276;
  SV_Target.y = _277;
  SV_Target.z = _278;
  SV_Target.w = 0.0f;

  // Depth buffer
  SV_Target_1 = (dot(float3(_189, _190, _191), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

Texture2D<float4> ColorTexture : register(t0);

Texture2D<float4> BloomTexture : register(t1);

struct _SceneColorApplyParamaters {
  float data[4];
};
StructuredBuffer<_SceneColorApplyParamaters> SceneColorApplyParamaters : register(t2);

Texture2D<float4> BloomDirtMaskTexture : register(t3);

Texture3D<float4> ColorGradingLUT : register(t4);

cbuffer cb0 : register(b0) {
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_036w : packoffset(c036.w);
  float cb0_037x : packoffset(c037.x);
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
  float cb0_044z : packoffset(c044.z);
  float cb0_045x : packoffset(c045.x);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_047x : packoffset(c047.x);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_050y : packoffset(c050.y);
  uint cb0_050z : packoffset(c050.z);
  float cb0_050w : packoffset(c050.w);
  float cb0_051x : packoffset(c051.x);
};

cbuffer UniformBufferConstants_View : register(b1) {
  float UniformBufferConstants_View_140w : packoffset(c140.w);
};

SamplerState ColorSampler : register(s0);

SamplerState BloomSampler : register(s1);

SamplerState BloomDirtMaskSampler : register(s2);

SamplerState ColorGradingLUTSampler : register(s3);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 TEXCOORD_1: TEXCOORD1,
    noperspective float4 TEXCOORD_2: TEXCOORD2,
    noperspective float2 TEXCOORD_3: TEXCOORD3,
    noperspective float2 TEXCOORD_4: TEXCOORD4,
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  float4 _34 = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));
  float4 _51 = SceneColorApplyParamaters[0].data[0 / 4];
  float4 _78 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _102 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float _124 = (cb0_047x) * (TEXCOORD_1.z);
  float _125 = (cb0_047x) * (TEXCOORD_1.w);
  float _128 = 1.0f / ((dot(float2(_124, _125), float2(_124, _125))) + 1.0f);
  float _131 = ((TEXCOORD_1.x) * 0.009999999776482582f) * (_128 * _128);
  float _141 = exp2(((log2((_131 * ((((UniformBufferConstants_View_140w) * (_78.x)) * (((cb0_045x) * (_102.x)) + 1.0f)) + ((((UniformBufferConstants_View_140w) * (_34.x)) * (cb0_044x)) * (_51.x)))))) * 0.1593017578125f));
  float _142 = exp2(((log2((_131 * ((((UniformBufferConstants_View_140w) * (_78.y)) * (((cb0_045y) * (_102.y)) + 1.0f)) + ((((UniformBufferConstants_View_140w) * (_34.y)) * (cb0_044y)) * (_51.y)))))) * 0.1593017578125f));
  float _143 = exp2(((log2((_131 * ((((UniformBufferConstants_View_140w) * (_78.z)) * (((cb0_045z) * (_102.z)) + 1.0f)) + ((((UniformBufferConstants_View_140w) * (_34.z)) * (cb0_044z)) * (_51.z)))))) * 0.1593017578125f));
  float4 _179 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((exp2(((log2(((1.0f / ((_141 * 18.6875f) + 1.0f)) * ((_141 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f), (((exp2(((log2(((1.0f / ((_142 * 18.6875f) + 1.0f)) * ((_142 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f), (((exp2(((log2(((1.0f / ((_143 * 18.6875f) + 1.0f)) * ((_143 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f)));
  float _192 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 0.00390625f) + -0.001953125f;
  float _193 = _192 + ((_179.x) * 1.0499999523162842f);
  float _194 = _192 + ((_179.y) * 1.0499999523162842f);
  float _195 = _192 + ((_179.z) * 1.0499999523162842f);
  float _269 = _193;
  float _270 = _194;
  float _271 = _195;
  if (!((((uint)(cb0_050z)) == 0))) {
    float _206 = exp2(((log2(_193)) * 0.012683313339948654f));
    float _207 = exp2(((log2(_194)) * 0.012683313339948654f));
    float _208 = exp2(((log2(_195)) * 0.012683313339948654f));
    float _241 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_206 + -0.8359375f))) / (18.8515625f - (_206 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    float _242 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_207 + -0.8359375f))) / (18.8515625f - (_207 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    float _243 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_208 + -0.8359375f))) / (18.8515625f - (_208 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    _269 = (min((_241 * 12.920000076293945f), (((exp2(((log2((max(_241, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _270 = (min((_242 * 12.920000076293945f), (((exp2(((log2((max(_242, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _271 = (min((_243 * 12.920000076293945f), (((exp2(((log2((max(_243, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  SV_Target.x = (saturate(((((_269 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f)));
  SV_Target.y = (saturate(((((_270 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f)));
  SV_Target.z = (saturate(((((_271 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f)));
  SV_Target.w = 0.0f;
  return SV_Target;
}

#include "./common.hlsl"

Texture2D<float4> ColorTexture : register(t0);

Texture2D<float4> BloomTexture : register(t1);

struct _SceneColorApplyParamaters {
  float data[4];
};
StructuredBuffer<_SceneColorApplyParamaters> SceneColorApplyParamaters : register(t2);

Texture3D<float4> LumBilateralGrid : register(t3);

Texture2D<float4> BlurredLogLum : register(t4);

Texture2D<float4> BloomDirtMaskTexture : register(t5);

Texture3D<float4> ColorGradingLUT : register(t6);

cbuffer cb0 : register(b0) {
  float cb0_009z : packoffset(c009.z);
  float cb0_009w : packoffset(c009.w);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_010w : packoffset(c010.w);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_025y : packoffset(c025.y);
  float cb0_025z : packoffset(c025.z);
  float cb0_025w : packoffset(c025.w);
  float cb0_027x : packoffset(c027.x);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
  float cb0_032x : packoffset(c032.x);
  float cb0_032y : packoffset(c032.y);
  float cb0_032z : packoffset(c032.z);
  float cb0_032w : packoffset(c032.w);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
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
  float cb0_046x : packoffset(c046.x);
  float cb0_046y : packoffset(c046.y);
  float cb0_046z : packoffset(c046.z);
  float cb0_047x : packoffset(c047.x);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_049x : packoffset(c049.x);
  float cb0_049y : packoffset(c049.y);
  float cb0_049z : packoffset(c049.z);
  float cb0_049w : packoffset(c049.w);
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

SamplerState LumBilateralGridSampler : register(s2);

SamplerState BlurredLogLumSampler : register(s3);

SamplerState BloomDirtMaskSampler : register(s4);

SamplerState ColorGradingLUTSampler : register(s5);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 TEXCOORD_1: TEXCOORD1,
    noperspective float4 TEXCOORD_2: TEXCOORD2,
    noperspective float2 TEXCOORD_3: TEXCOORD3,
    noperspective float2 TEXCOORD_4: TEXCOORD4,
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;

  float _41 = ((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x);
  float _42 = ((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y);
  float _53 = float(((int(((bool)((_41 > 0.0f))))) - (int(((bool)((_41 < 0.0f)))))));
  float _54 = float(((int(((bool)((_42 > 0.0f))))) - (int(((bool)((_42 < 0.0f)))))));
  float _59 = saturate(((abs(_41)) - (cb0_046z)));
  float _60 = saturate(((abs(_42)) - (cb0_046z)));
  float _147 = (UniformBufferConstants_View_140w) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((((_41 - ((_59 * (cb0_046x)) * _53)) * (cb0_049z)) + (cb0_049x)) * (cb0_010x)) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((((_42 - ((_60 * (cb0_046x)) * _54)) * (cb0_049w)) + (cb0_049y)) * (cb0_010y)) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).x);
  float _148 = (UniformBufferConstants_View_140w) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max(((((cb0_010x) * (((_41 - ((_59 * (cb0_046y)) * _53)) * (cb0_049z)) + (cb0_049x))) + (cb0_010z)) * (cb0_009z)), (cb0_015x))), (cb0_015z))), (min((max(((((cb0_010y) * (((_42 - ((_60 * (cb0_046y)) * _54)) * (cb0_049w)) + (cb0_049y))) + (cb0_010w)) * (cb0_009w)), (cb0_015y))), (cb0_015w))))))).y);
  float _149 = (UniformBufferConstants_View_140w) * (((float4)(ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w))))))).z);
  float _158 = log2((max((dot(float3(_147, _148, _149), float3((cb0_027x), (cb0_027y), (cb0_027z)))), (cb0_025w))));
  float4 _174 = LumBilateralGrid.Sample(LumBilateralGridSampler, float3(((cb0_033z) * (TEXCOORD_4.x)), ((cb0_033w) * (TEXCOORD_4.y)), (((((cb0_025y)*_158) + (cb0_025z)) * 0.96875f) + 0.015625f)));
  float _183 = (((bool)(((_174.y) < 0.0010000000474974513f))) ? (((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) : ((_174.x) / (_174.y)));
  float _186 = log2((TEXCOORD_1.x));
  float _188 = (_183 + _186) + (((((float4)(BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y))))).x) - _183) * (cb0_032w));
  float _193 = _186 + _158;
  float _195 = _188 - (TEXCOORD_1.y);
  bool _196 = (_195 > 0.0f);
  float _208;
  float _445;
  float _446;
  float _447;
  if (_196) {
    _208 = (max(0.0f, (_195 - (cb0_034x))));
  } else {
    _208 = (min(0.0f, ((cb0_034y) + _195)));
  }
  float _215 = exp2(((((_188 - _193) + ((_193 - _188) * (cb0_032z))) - _208) + (_208 * ((_196 ? (cb0_032x) : (cb0_032y))))));
  float4 _227 = SceneColorApplyParamaters[0].data[0 / 4];
  float4 _254 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _278 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float _300 = (cb0_047x) * (TEXCOORD_1.z);
  float _301 = (cb0_047x) * (TEXCOORD_1.w);
  // These two control vingette
  if (injectedData.toneMapType != 0.f) {
    _300 *= injectedData.vignetteStrength;
    _301 *= injectedData.vignetteStrength;
  }

  float _304 = 1.0f / ((dot(float2(_300, _301), float2(_300, _301))) + 1.0f);
  float _307 = ((TEXCOORD_1.x) * 0.009999999776482582f) * (_304 * _304);
  float _317 = exp2(((log2((_307 * ((((UniformBufferConstants_View_140w) * (_254.x)) * (((cb0_045x) * (_278.x)) + 1.0f)) + (((_215 * _147) * (cb0_044x)) * (_227.x)))))) * 0.1593017578125f));
  float _318 = exp2(((log2((_307 * ((((UniformBufferConstants_View_140w) * (_254.y)) * (((cb0_045y) * (_278.y)) + 1.0f)) + (((_215 * _148) * (cb0_044y)) * (_227.y)))))) * 0.1593017578125f));
  float _319 = exp2(((log2((_307 * ((((UniformBufferConstants_View_140w) * (_254.z)) * (((cb0_045z) * (_278.z)) + 1.0f)) + (((_215 * _149) * (cb0_044z)) * (_227.z)))))) * 0.1593017578125f));
  float4 _355 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((exp2(((log2(((1.0f / ((_317 * 18.6875f) + 1.0f)) * ((_317 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f), (((exp2(((log2(((1.0f / ((_318 * 18.6875f) + 1.0f)) * ((_318 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f), (((exp2(((log2(((1.0f / ((_319 * 18.6875f) + 1.0f)) * ((_319 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f)));
  float _368 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 0.00390625f) + -0.001953125f;
  float _369 = _368 + ((_355.x) * 1.0499999523162842f);
  float _370 = _368 + ((_355.y) * 1.0499999523162842f);
  float _371 = _368 + ((_355.z) * 1.0499999523162842f);
  _445 = _369;
  _446 = _370;
  _447 = _371;
  if (!((((uint)(cb0_050z)) == 0))) {
    float _382 = exp2(((log2(_369)) * 0.012683313339948654f));
    float _383 = exp2(((log2(_370)) * 0.012683313339948654f));
    float _384 = exp2(((log2(_371)) * 0.012683313339948654f));
    float _417 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_382 + -0.8359375f))) / (18.8515625f - (_382 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    float _418 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_383 + -0.8359375f))) / (18.8515625f - (_383 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    float _419 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_384 + -0.8359375f))) / (18.8515625f - (_384 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    _445 = (min((_417 * 12.920000076293945f), (((exp2(((log2((max(_417, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _446 = (min((_418 * 12.920000076293945f), (((exp2(((log2((max(_418, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _447 = (min((_419 * 12.920000076293945f), (((exp2(((log2((max(_419, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float contrast = cb0_051x;
  float brightness = cb0_050w;
  if (injectedData.toneMapType > 0.f) {
    contrast = DEFAULT_CONTRAST;
    brightness = DEFAULT_BRIGHTNESS;
  }
  /* SV_Target.x = (saturate(((((_445 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f)));
  SV_Target.y = (saturate(((((_446 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f)));
  SV_Target.z = (saturate(((((_447 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f))); */
  SV_Target.x = (saturate(((((_445 + -0.5f) + (brightness)) * (contrast)) + 0.5f)));
  SV_Target.y = (saturate(((((_446 + -0.5f) + (brightness)) * (contrast)) + 0.5f)));
  SV_Target.z = (saturate(((((_447 + -0.5f) + (brightness)) * (contrast)) + 0.5f)));
  SV_Target.w = 0.0f;
  return SV_Target;
}

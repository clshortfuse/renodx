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
  float cb0_009x : packoffset(c009.x);
  float cb0_009y : packoffset(c009.y);
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
  float cb0_047y : packoffset(c047.y);
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
  float _568;
  float _569;
  float _570;
  if (_196) {
    _208 = (max(0.0f, (_195 - (cb0_034x))));
  } else {
    _208 = (min(0.0f, ((cb0_034y) + _195)));
  }
  float _215 = exp2(((((_188 - _193) + ((_193 - _188) * (cb0_032z))) - _208) + (_208 * ((_196 ? (cb0_032x) : (cb0_032y))))));
  float _216 = _215 * _147;
  float _217 = _215 * _148;
  float _218 = _215 * _149;
  float _219 = _215 * (UniformBufferConstants_View_140w);
  float _222 = dot(float3(_216, _217, _218), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
  float _235 = ((float((uint)((int)(((uint)(uint((floor(((cb0_009x) * (TEXCOORD.x))))))) & 1)))) * 2.0f) + -1.0f;
  float _239 = ((float((uint)((int)(((uint)(uint((floor(((cb0_009y) * (TEXCOORD.y))))))) & 1)))) * 2.0f) + -1.0f;
  float4 _254 = ColorTexture.Sample(ColorSampler, float2((min((max(((_235 * (cb0_009z)) + (TEXCOORD.x)), (cb0_015x))), (cb0_015z))), (min((max((TEXCOORD.y), (cb0_015y))), (cb0_015w)))));
  float _258 = (_254.x) * _219;
  float _259 = (_254.y) * _219;
  float _260 = (_254.z) * _219;
  float4 _276 = ColorTexture.Sample(ColorSampler, float2((min((max((TEXCOORD.x), (cb0_015x))), (cb0_015z))), (min((max((((cb0_009w)*_239) + (TEXCOORD.y)), (cb0_015y))), (cb0_015w)))));
  float _280 = (_276.x) * _219;
  float _281 = (_276.y) * _219;
  float _282 = (_276.z) * _219;
  float _314 = -0.0f - ((cb0_047y) * (saturate((1.0f - ((max((max((abs((_222 - (dot(float3(_258, _259, _260), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)))))), (abs((_222 - (dot(float3(_280, _281, _282), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)))))))), (max((abs(((ddx_fine(_222)) * _235))), (abs(((ddy_fine(_222)) * _239))))))) * (TEXCOORD_1.x))))));
  float4 _350 = SceneColorApplyParamaters[0].data[0 / 4];
  float4 _377 = BloomTexture.Sample(BloomSampler, float2((min((max((((cb0_036x) * (TEXCOORD.x)) + (cb0_036z)), (cb0_037x))), (cb0_037z))), (min((max((((cb0_036y) * (TEXCOORD.y)) + (cb0_036w)), (cb0_037y))), (cb0_037w)))));
  float4 _401 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2((((((cb0_048z) * (TEXCOORD_3.x)) + (cb0_048x)) * 0.5f) + 0.5f), (0.5f - ((((cb0_048w) * (TEXCOORD_3.y)) + (cb0_048y)) * 0.5f))));
  float _423 = (cb0_047x) * (TEXCOORD_1.z);
  float _424 = (cb0_047x) * (TEXCOORD_1.w);
  // These two control vingette
  if (injectedData.toneMapType != 0.f) {
    _423 *= injectedData.vignetteStrength;
    _424 *= injectedData.vignetteStrength;
  }

  float _427 = 1.0f / ((dot(float2(_423, _424), float2(_423, _424))) + 1.0f);
  float _430 = ((TEXCOORD_1.x) * 0.009999999776482582f) * (_427 * _427);
  float _440 = exp2(((log2((_430 * ((((UniformBufferConstants_View_140w) * (_377.x)) * (((cb0_045x) * (_401.x)) + 1.0f)) + ((((((((((_258 - (_216 * 4.0f)) + _280) + _216) - ((ddx_fine(_216)) * _235)) + _216) - ((ddy_fine(_216)) * _239)) * _314) + _216) * (cb0_044x)) * (_350.x)))))) * 0.1593017578125f));
  float _441 = exp2(((log2((_430 * ((((UniformBufferConstants_View_140w) * (_377.y)) * (((cb0_045y) * (_401.y)) + 1.0f)) + ((((((((((_259 - (_217 * 4.0f)) + _281) + _217) - ((ddx_fine(_217)) * _235)) + _217) - ((ddy_fine(_217)) * _239)) * _314) + _217) * (cb0_044y)) * (_350.y)))))) * 0.1593017578125f));
  float _442 = exp2(((log2((_430 * ((((UniformBufferConstants_View_140w) * (_377.z)) * (((cb0_045z) * (_401.z)) + 1.0f)) + ((((((((((_260 - (_218 * 4.0f)) + _282) + _218) - ((ddx_fine(_218)) * _235)) + _218) - ((ddy_fine(_218)) * _239)) * _314) + _218) * (cb0_044z)) * (_350.z)))))) * 0.1593017578125f));
  float4 _478 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3((((exp2(((log2(((1.0f / ((_440 * 18.6875f) + 1.0f)) * ((_440 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f), (((exp2(((log2(((1.0f / ((_441 * 18.6875f) + 1.0f)) * ((_441 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f), (((exp2(((log2(((1.0f / ((_442 * 18.6875f) + 1.0f)) * ((_442 * 18.8515625f) + 0.8359375f)))) * 78.84375f))) * 0.96875f) + 0.015625f)));
  float _491 = ((frac(((sin((((TEXCOORD_2.w) * 543.3099975585938f) + (TEXCOORD_2.z)))) * 493013.0f))) * 0.00390625f) + -0.001953125f;
  float _492 = _491 + ((_478.x) * 1.0499999523162842f);
  float _493 = _491 + ((_478.y) * 1.0499999523162842f);
  float _494 = _491 + ((_478.z) * 1.0499999523162842f);
  _568 = _492;
  _569 = _493;
  _570 = _494;
  if (!((((uint)(cb0_050z)) == 0))) {
    float _505 = exp2(((log2(_492)) * 0.012683313339948654f));
    float _506 = exp2(((log2(_493)) * 0.012683313339948654f));
    float _507 = exp2(((log2(_494)) * 0.012683313339948654f));
    float _540 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_505 + -0.8359375f))) / (18.8515625f - (_505 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    float _541 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_506 + -0.8359375f))) / (18.8515625f - (_506 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    float _542 = max(6.103519990574569e-05f, (((exp2(((log2(((max(0.0f, (_507 + -0.8359375f))) / (18.8515625f - (_507 * 18.6875f))))) * 6.277394771575928f))) * 10000.0f) / (cb0_050y)));
    _568 = (min((_540 * 12.920000076293945f), (((exp2(((log2((max(_540, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _569 = (min((_541 * 12.920000076293945f), (((exp2(((log2((max(_541, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
    _570 = (min((_542 * 12.920000076293945f), (((exp2(((log2((max(_542, 0.0031306699384003878f)))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  float contrast = cb0_051x;
  float brightness = cb0_050w;
  if (injectedData.toneMapType > 0.f) {
    contrast = DEFAULT_CONTRAST;
    brightness = DEFAULT_BRIGHTNESS;
  }
  /* SV_Target.x = (saturate(((((_568 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f)));
  SV_Target.y = (saturate(((((_569 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f)));
  SV_Target.z = (saturate(((((_570 + -0.5f) + (cb0_050w)) * (cb0_051x)) + 0.5f))); */
  SV_Target.x = (saturate(((((_568 + -0.5f) + (brightness)) * (contrast)) + 0.5f)));
  SV_Target.y = (saturate(((((_569 + -0.5f) + (brightness)) * (contrast)) + 0.5f)));
  SV_Target.z = (saturate(((((_570 + -0.5f) + (brightness)) * (contrast)) + 0.5f)));
  SV_Target.w = 0.0f;
  return SV_Target;
}

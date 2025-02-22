#include "./common.hlsl"

struct _View_PreExposureSceneData {
  float PreExposure;
  float OneOverPreExposure;
  float AverageSceneLuminance;
  uint IsValid;
  float PrevPreExposure;
  float PrevOneOverPreExposure;
  float PreExposureCorrection;
  uint PrevIsValid;
};
StructuredBuffer<_View_PreExposureSceneData> View_PreExposureSceneData : register(t0);

struct _EyeAdaptationBuffer {
  float data[4];
};
StructuredBuffer<float4> EyeAdaptationBuffer : register(t1);

Texture2D<float4> ColorTexture : register(t2);

Texture2D<float4> BloomTexture : register(t3);

struct _SceneColorApplyParamaters {
  float data[4];
};
StructuredBuffer<_SceneColorApplyParamaters> SceneColorApplyParamaters : register(t4);

Texture3D<float4> LumBilateralGrid : register(t5);

Texture2D<float4> BlurredLogLum : register(t6);

Texture2D<float4> BloomDirtMaskTexture : register(t7);

Texture3D<float4> ColorGradingLUT : register(t8);

cbuffer cb0 : register(b0) {
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_025y : packoffset(c025.y);
  float cb0_025z : packoffset(c025.z);
  float cb0_025w : packoffset(c025.w);
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034z : packoffset(c034.z);
  float cb0_034w : packoffset(c034.w);
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
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_050z : packoffset(c050.z);
  float cb0_050w : packoffset(c050.w);
  float cb0_051x : packoffset(c051.x);
  float cb0_051y : packoffset(c051.y);
  uint cb0_051z : packoffset(c051.z);
};

SamplerState ColorSampler : register(s0);

SamplerState BloomSampler : register(s1);

SamplerState LumBilateralGridSampler : register(s2);

SamplerState BlurredLogLumSampler : register(s3);

SamplerState BloomDirtMaskSampler : register(s4);

SamplerState ColorGradingLUTSampler : register(s5);

OutputSignature main(
    noperspective float2 TEXCOORD: TEXCOORD0,
    noperspective float2 TEXCOORD_1: TEXCOORD1,
    noperspective float4 TEXCOORD_2: TEXCOORD2,
    noperspective float2 TEXCOORD_3: TEXCOORD3,
    noperspective float2 TEXCOORD_4: TEXCOORD4,
    noperspective float4 SV_Position: SV_Position) {
  float4 SV_Target;
  float3 untonemapped;
  float SV_Target_1;
  /* int4 _27 = asuint(View_PreExposureSceneData[0].data[12 / 4]);
  float _29 = float((uint)((int)(_27.x))); */
  // float4 _30 = View_PreExposureSceneData[0].data[4 / 4];
  float _29 = View_PreExposureSceneData.Load(0u).IsValid;
  float _30 = View_PreExposureSceneData.Load(0u).OneOverPreExposure;

  // float _32 = (_30.x) + -1.0f;
  float _32 = (_30) + -1.0f;
  float _33 = _32 * _29;
  float _34 = _33 + 1.0f;
  // float4 _36 = EyeAdaptationBuffer.Load(0u);
  float4 _36 = EyeAdaptationBuffer.Load(0u);
  float _44 = max((TEXCOORD.x), (cb0_015x));
  float _45 = max((TEXCOORD.y), (cb0_015y));
  float _46 = min(_44, (cb0_015z));
  float _47 = min(_45, (cb0_015w));
  float4 _50 = ColorTexture.Sample(ColorSampler, float2(_46, _47));
  float _59 = (cb0_036x) * (TEXCOORD.x);
  float _60 = (cb0_036y) * (TEXCOORD.y);
  float _61 = _59 + (cb0_036z);
  float _62 = _60 + (cb0_036w);
  float _68 = max(_61, (cb0_037x));
  float _69 = max(_62, (cb0_037y));
  float _70 = min(_68, (cb0_037z));
  float _71 = min(_69, (cb0_037w));
  float4 _74 = BloomTexture.Sample(BloomSampler, float2(_70, _71));
  float _83 = (cb0_048z) * (TEXCOORD_3.x);
  float _84 = (cb0_048w) * (TEXCOORD_3.y);
  float _85 = _83 + (cb0_048x);
  float _86 = _84 + (cb0_048y);
  float _87 = _85 * 0.5f;
  float _88 = _86 * 0.5f;
  float _89 = _87 + 0.5f;
  float _90 = 0.5f - _88;
  float4 _93 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2(_89, _90));
  float _101 = (cb0_045x) * (_93.x);
  float _102 = (cb0_045y) * (_93.y);
  float _103 = (cb0_045z) * (_93.z);
  float _104 = _101 + 1.0f;
  float _105 = _102 + 1.0f;
  float _106 = _103 + 1.0f;
  float4 _112 = SceneColorApplyParamaters[0].data[0 / 4];
  float _116 = (_50.x) * _34;
  float _117 = (_50.y) * _34;
  float _118 = (_50.z) * _34;
  float _121 = dot(float3(_116, _117, _118), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f));
  float _122 = max(_121, (cb0_025w));
  float _123 = log2(_122);
  float _124 = (_36.w) * 0.18000000715255737f;
  float _127 = _124 * (cb0_034x);
  float _128 = log2(_127);
  float _133 = (cb0_034z) * (TEXCOORD_4.x);
  float _134 = (cb0_034w) * (TEXCOORD_4.y);
  float _136 = (cb0_025y)*_123;
  float _138 = _136 + (cb0_025z);
  float _139 = _138 * 0.96875f;
  float _140 = _139 + 0.015625f;
  float4 _143 = LumBilateralGrid.Sample(LumBilateralGridSampler, float3(_133, _134, _140));
  float _146 = (_143.x) / (_143.y);
  float4 _149 = BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y)));
  bool _151 = ((_143.y) < 0.0010000000474974513f);
  float _152 = (_151 ? (_149.x) : _146);
  float _153 = (_149.x) - _152;
  float _154 = _153 * (cb0_033w);
  float _155 = log2((_36.x));
  float _156 = _152 + _155;
  float _157 = _156 + _154;
  float _162 = _155 + _123;
  float _163 = _162 - _157;
  float _164 = _157 - _128;
  bool _165 = (_164 > 0.0f);
  float _166 = (_165 ? (cb0_033x) : (cb0_033y));
  float _167 = _166 * _164;
  float _168 = _163 * (cb0_033z);
  float _169 = _128 - _162;
  float _170 = _169 + _168;
  float _171 = _170 + _167;
  float _172 = exp2(_171);
  float _173 = _34 * (_36.x);
  float _174 = _173 * _172;
  float _175 = (cb0_044x) * (_50.x);
  float _176 = _175 * (_112.x);
  float _177 = _176 * _174;
  float _178 = (cb0_044y) * (_50.y);
  float _179 = _178 * (_112.y);
  float _180 = _179 * _174;
  float _181 = (cb0_044z) * (_50.z);
  float _182 = _181 * (_112.z);
  float _183 = _182 * _174;
  untonemapped = float3(_177, _180, _183);

  float _184 = (_74.x) * _173;
  float _185 = _184 * _104;
  float _186 = (_74.y) * _173;
  float _187 = _186 * _105;
  float _188 = (_74.z) * _173;
  float _189 = _188 * _106;

  float _190 = _185 + 0.002667719265446067f;
  float _191 = _190 + _177;
  float _192 = _187 + 0.002667719265446067f;
  float _193 = _192 + _180;
  float _194 = _189 + 0.002667719265446067f;
  float _195 = _194 + _183;

  float _196 = log2(_191);
  float _197 = log2(_193);
  float _198 = log2(_195);
  float _199 = _196 * 0.0714285746216774f;
  float _200 = _197 * 0.0714285746216774f;
  float _201 = _198 * 0.0714285746216774f;
  float _202 = _199 + 0.6107269525527954f;
  float _203 = _200 + 0.6107269525527954f;
  float _204 = _201 + 0.6107269525527954f;

  float _205 = saturate(_202);
  float _206 = saturate(_203);
  float _207 = saturate(_204);
  float _210 = (cb0_050z)*_205;
  float _211 = (cb0_050z)*_206;
  float _212 = (cb0_050z)*_207;
  float _214 = _210 + (cb0_050w);
  float _215 = _211 + (cb0_050w);
  float _216 = _212 + (cb0_050w);
  float4 _219 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3(_214, _215, _216));
  return LutToneMap(untonemapped, float3(_214, _215, _216), ColorGradingLUT, ColorGradingLUTSampler);
  float _223 = (_219.x) * 1.0499999523162842f;
  float _224 = (_219.y) * 1.0499999523162842f;
  float _225 = (_219.z) * 1.0499999523162842f;
  float _226 = dot(float3(_223, _224, _225), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  bool _229 = (((uint)(cb0_051z)) == 0);
  float _300 = _223;
  float _301 = _224;
  float _302 = _225;
  if (!_229) {
    float _231 = log2(_223);
    float _232 = log2(_224);
    float _233 = log2(_225);
    float _234 = _231 * 0.012683313339948654f;
    float _235 = _232 * 0.012683313339948654f;
    float _236 = _233 * 0.012683313339948654f;
    float _237 = exp2(_234);
    float _238 = exp2(_235);
    float _239 = exp2(_236);
    float _240 = _237 + -0.8359375f;
    float _241 = _238 + -0.8359375f;
    float _242 = _239 + -0.8359375f;
    float _243 = max(0.0f, _240);
    float _244 = max(0.0f, _241);
    float _245 = max(0.0f, _242);
    float _246 = _237 * 18.6875f;
    float _247 = _238 * 18.6875f;
    float _248 = _239 * 18.6875f;
    float _249 = 18.8515625f - _246;
    float _250 = 18.8515625f - _247;
    float _251 = 18.8515625f - _248;
    float _252 = _243 / _249;
    float _253 = _244 / _250;
    float _254 = _245 / _251;
    float _255 = log2(_252);
    float _256 = log2(_253);
    float _257 = log2(_254);
    float _258 = _255 * 6.277394771575928f;
    float _259 = _256 * 6.277394771575928f;
    float _260 = _257 * 6.277394771575928f;
    float _261 = exp2(_258);
    float _262 = exp2(_259);
    float _263 = exp2(_260);
    float _264 = _261 * 10000.0f;
    float _265 = _262 * 10000.0f;
    float _266 = _263 * 10000.0f;
    float _269 = _264 / (cb0_051x);
    float _270 = _265 / (cb0_051x);
    float _271 = _266 / (cb0_051x);
    float _272 = max(6.103519990574569e-05f, _269);
    float _273 = max(6.103519990574569e-05f, _270);
    float _274 = max(6.103519990574569e-05f, _271);
    float _275 = max(_272, 0.0031306699384003878f);
    float _276 = max(_273, 0.0031306699384003878f);
    float _277 = max(_274, 0.0031306699384003878f);
    float _278 = log2(_275);
    float _279 = log2(_276);
    float _280 = log2(_277);
    float _281 = _278 * 0.4166666567325592f;
    float _282 = _279 * 0.4166666567325592f;
    float _283 = _280 * 0.4166666567325592f;
    float _284 = exp2(_281);
    float _285 = exp2(_282);
    float _286 = exp2(_283);
    float _287 = _284 * 1.0549999475479126f;
    float _288 = _285 * 1.0549999475479126f;
    float _289 = _286 * 1.0549999475479126f;
    float _290 = _287 + -0.054999999701976776f;
    float _291 = _288 + -0.054999999701976776f;
    float _292 = _289 + -0.054999999701976776f;
    float _293 = _272 * 12.920000076293945f;
    float _294 = _273 * 12.920000076293945f;
    float _295 = _274 * 12.920000076293945f;
    float _296 = min(_293, _290);
    float _297 = min(_294, _291);
    float _298 = min(_295, _292);
    _300 = _296;
    _301 = _297;
    _302 = _298;
  }
  float _303 = (TEXCOORD_2.w) * 543.3099975585938f;
  float _304 = _303 + (TEXCOORD_2.z);
  float _305 = sin(_304);
  float _306 = _305 * 493013.0f;
  float _307 = frac(_306);
  float _308 = _307 * 2.0f;
  float _309 = _308 + -1.0f;
  float _310 = _309 * 0x7FF0000000000000;
  float _311 = max(_310, -1.0f);
  float _312 = min(_311, 1.0f);
  float _313 = abs(_309);
  float _314 = 1.0f - _313;
  float _315 = saturate(_314);
  float _316 = sqrt(_315);
  float _317 = _316 * _312;
  float _318 = _312 - _317;
  float _321 = _318 * (cb0_051y);
  float _322 = _321 + _300;
  float _323 = _321 + _301;
  float _324 = _321 + _302;
  SV_Target.x = _322;
  SV_Target.y = _323;
  SV_Target.z = _324;
  SV_Target.w = 0.0f;

  SV_Target_1 = _226;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

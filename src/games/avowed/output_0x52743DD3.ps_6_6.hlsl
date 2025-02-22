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
  float cb0_047x : packoffset(c047.x);
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
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) {
  float4 SV_Target;
  float3 untonemapped;

  float SV_Target_1;
  /* int4 _29 = asint(View_PreExposureSceneData[0].data[12 / 4]);
  float _31 = float((uint)((int)(_29.x)));
  float4 _32 = View_PreExposureSceneData[0].data[4 / 4]; */
  float _31 = View_PreExposureSceneData.Load(0u).IsValid;
  float _32 = View_PreExposureSceneData.Load(0u).OneOverPreExposure;
  float _34 = (_32) + -1.0f;
  float _35 = _34 * _31;
  float _36 = _35 + 1.0f;
  float4 _38 = EyeAdaptationBuffer.Load(0u);
  float _46 = max((TEXCOORD.x), (cb0_015x));
  float _47 = max((TEXCOORD.y), (cb0_015y));
  float _48 = min(_46, (cb0_015z));
  float _49 = min(_47, (cb0_015w));
  float4 _52 = ColorTexture.Sample(ColorSampler, float2(_48, _49));
  float _61 = (cb0_036x) * (TEXCOORD.x);
  float _62 = (cb0_036y) * (TEXCOORD.y);
  float _63 = _61 + (cb0_036z);
  float _64 = _62 + (cb0_036w);
  float _70 = max(_63, (cb0_037x));
  float _71 = max(_64, (cb0_037y));
  float _72 = min(_70, (cb0_037z));
  float _73 = min(_71, (cb0_037w));
  float4 _76 = BloomTexture.Sample(BloomSampler, float2(_72, _73));
  float _85 = (cb0_048z) * (TEXCOORD_3.x);
  float _86 = (cb0_048w) * (TEXCOORD_3.y);
  float _87 = _85 + (cb0_048x);
  float _88 = _86 + (cb0_048y);
  float _89 = _87 * 0.5f;
  float _90 = _88 * 0.5f;
  float _91 = _89 + 0.5f;
  float _92 = 0.5f - _90;
  float4 _95 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2(_91, _92));
  float _103 = (cb0_045x) * (_95.x);
  float _104 = (cb0_045y) * (_95.y);
  float _105 = (cb0_045z) * (_95.z);
  float _106 = _103 + 1.0f;
  float _107 = _104 + 1.0f;
  float _108 = _105 + 1.0f;
  float _109 = _106 * (_76.x);
  float _110 = _107 * (_76.y);
  float _111 = _108 * (_76.z);
  float _114 = (cb0_047x) * (TEXCOORD_1.x);
  float _115 = (cb0_047x) * (TEXCOORD_1.y);
  float _116 = dot(float2(_114, _115), float2(_114, _115));
  float _117 = _116 + 1.0f;
  float _118 = 1.0f / _117;
  float _119 = _118 * _118;
  float4 _125 = SceneColorApplyParamaters[0].data[0 / 4];
  float _129 = (_52.x) * _36;
  float _130 = (_52.y) * _36;
  float _131 = (_52.z) * _36;
  float _134 = dot(float3(_129, _130, _131), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f));
  float _135 = max(_134, (cb0_025w));
  float _136 = log2(_135);
  float _137 = (_38.w) * 0.18000000715255737f;
  float _140 = _137 * (cb0_034x);
  float _141 = log2(_140);
  float _146 = (cb0_034z) * (TEXCOORD_4.x);
  float _147 = (cb0_034w) * (TEXCOORD_4.y);
  float _149 = (cb0_025y) * _136;
  float _151 = _149 + (cb0_025z);
  float _152 = _151 * 0.96875f;
  float _153 = _152 + 0.015625f;
  float4 _156 = LumBilateralGrid.Sample(LumBilateralGridSampler, float3(_146, _147, _153));
  float _159 = (_156.x) / (_156.y);
  float4 _162 = BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y)));
  bool _164 = ((_156.y) < 0.0010000000474974513f);
  float _165 = (_164 ? (_162.x) : _159);
  float _166 = (_162.x) - _165;
  float _167 = _166 * (cb0_033w);
  float _168 = log2((_38.x));
  float _169 = _165 + _168;
  float _170 = _169 + _167;
  float _175 = _168 + _136;
  float _176 = _175 - _170;
  float _177 = _170 - _141;
  bool _178 = (_177 > 0.0f);
  float _179 = (_178 ? (cb0_033x) : (cb0_033y));
  float _180 = _179 * _177;
  float _181 = _176 * (cb0_033z);
  float _182 = _141 - _175;
  float _183 = _182 + _181;
  float _184 = _183 + _180;
  float _185 = exp2(_184);
  float _186 = _36 * (_38.x);
  float _187 = _186 * _119;
  float _188 = _187 * _185;
  float _189 = (cb0_044x) * (_52.x);
  float _190 = _189 * (_125.x);
  float _191 = _190 * _188;
  float _192 = (cb0_044y) * (_52.y);
  float _193 = _192 * (_125.y);
  float _194 = _193 * _188;
  float _195 = (cb0_044z) * (_52.z);
  float _196 = _195 * (_125.z);
  float _197 = _196 * _188;

  untonemapped = float3(_191, _194, _197);

  float _198 = _109 * _187;
  float _199 = _110 * _187;
  float _200 = _111 * _187;
  float _201 = _198 + 0.002667719265446067f;
  float _202 = _201 + _191;
  float _203 = _199 + 0.002667719265446067f;
  float _204 = _203 + _194;
  float _205 = _200 + 0.002667719265446067f;
  float _206 = _205 + _197;
  float _207 = log2(_202);
  float _208 = log2(_204);
  float _209 = log2(_206);
  float _210 = _207 * 0.0714285746216774f;
  float _211 = _208 * 0.0714285746216774f;
  float _212 = _209 * 0.0714285746216774f;
  float _213 = _210 + 0.6107269525527954f;
  float _214 = _211 + 0.6107269525527954f;
  float _215 = _212 + 0.6107269525527954f;
  float _216 = saturate(_213);
  float _217 = saturate(_214);
  float _218 = saturate(_215);
  float _221 = (cb0_050z) * _216;
  float _222 = (cb0_050z) * _217;
  float _223 = (cb0_050z) * _218;
  float _225 = _221 + (cb0_050w);
  float _226 = _222 + (cb0_050w);
  float _227 = _223 + (cb0_050w);
  float4 _230 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3(_225, _226, _227));
  return LutToneMap(untonemapped, float3(_225, _226, _227), ColorGradingLUT, ColorGradingLUTSampler);

  float _234 = (_230.x) * 1.0499999523162842f;
  float _235 = (_230.y) * 1.0499999523162842f;
  float _236 = (_230.z) * 1.0499999523162842f;
  float _237 = dot(float3(_234, _235, _236), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  bool _240 = (((uint)(cb0_051z)) == 0);
  float _311 = _234;
  float _312 = _235;
  float _313 = _236;
  if (!_240) {
    float _242 = log2(_234);
    float _243 = log2(_235);
    float _244 = log2(_236);
    float _245 = _242 * 0.012683313339948654f;
    float _246 = _243 * 0.012683313339948654f;
    float _247 = _244 * 0.012683313339948654f;
    float _248 = exp2(_245);
    float _249 = exp2(_246);
    float _250 = exp2(_247);
    float _251 = _248 + -0.8359375f;
    float _252 = _249 + -0.8359375f;
    float _253 = _250 + -0.8359375f;
    float _254 = max(0.0f, _251);
    float _255 = max(0.0f, _252);
    float _256 = max(0.0f, _253);
    float _257 = _248 * 18.6875f;
    float _258 = _249 * 18.6875f;
    float _259 = _250 * 18.6875f;
    float _260 = 18.8515625f - _257;
    float _261 = 18.8515625f - _258;
    float _262 = 18.8515625f - _259;
    float _263 = _254 / _260;
    float _264 = _255 / _261;
    float _265 = _256 / _262;
    float _266 = log2(_263);
    float _267 = log2(_264);
    float _268 = log2(_265);
    float _269 = _266 * 6.277394771575928f;
    float _270 = _267 * 6.277394771575928f;
    float _271 = _268 * 6.277394771575928f;
    float _272 = exp2(_269);
    float _273 = exp2(_270);
    float _274 = exp2(_271);
    float _275 = _272 * 10000.0f;
    float _276 = _273 * 10000.0f;
    float _277 = _274 * 10000.0f;
    float _280 = _275 / (cb0_051x);
    float _281 = _276 / (cb0_051x);
    float _282 = _277 / (cb0_051x);
    float _283 = max(6.103519990574569e-05f, _280);
    float _284 = max(6.103519990574569e-05f, _281);
    float _285 = max(6.103519990574569e-05f, _282);
    float _286 = max(_283, 0.0031306699384003878f);
    float _287 = max(_284, 0.0031306699384003878f);
    float _288 = max(_285, 0.0031306699384003878f);
    float _289 = log2(_286);
    float _290 = log2(_287);
    float _291 = log2(_288);
    float _292 = _289 * 0.4166666567325592f;
    float _293 = _290 * 0.4166666567325592f;
    float _294 = _291 * 0.4166666567325592f;
    float _295 = exp2(_292);
    float _296 = exp2(_293);
    float _297 = exp2(_294);
    float _298 = _295 * 1.0549999475479126f;
    float _299 = _296 * 1.0549999475479126f;
    float _300 = _297 * 1.0549999475479126f;
    float _301 = _298 + -0.054999999701976776f;
    float _302 = _299 + -0.054999999701976776f;
    float _303 = _300 + -0.054999999701976776f;
    float _304 = _283 * 12.920000076293945f;
    float _305 = _284 * 12.920000076293945f;
    float _306 = _285 * 12.920000076293945f;
    float _307 = min(_304, _301);
    float _308 = min(_305, _302);
    float _309 = min(_306, _303);
    _311 = _307;
    _312 = _308;
    _313 = _309;
  }
  float _314 = (TEXCOORD_2.w) * 543.3099975585938f;
  float _315 = _314 + (TEXCOORD_2.z);
  float _316 = sin(_315);
  float _317 = _316 * 493013.0f;
  float _318 = frac(_317);
  float _319 = _318 * 2.0f;
  float _320 = _319 + -1.0f;
  float _321 = _320 * 0x7FF0000000000000;
  float _322 = max(_321, -1.0f);
  float _323 = min(_322, 1.0f);
  float _324 = abs(_320);
  float _325 = 1.0f - _324;
  float _326 = saturate(_325);
  float _327 = sqrt(_326);
  float _328 = _327 * _323;
  float _329 = _323 - _328;
  float _332 = _329 * (cb0_051y);
  float _333 = _332 + _311;
  float _334 = _332 + _312;
  float _335 = _332 + _313;
  SV_Target.x = _333;
  SV_Target.y = _334;
  SV_Target.z = _335;
  SV_Target.w = 0.0f;
  SV_Target_1 = _237;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

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

RWTexture2D<float4> RWOutputTexture : register(u0);

RWTexture2D<float4> RWOutputLuminance : register(u1);

cbuffer cb0 : register(b0) {
  float cb0_001x : packoffset(c001.x);
  float cb0_001y : packoffset(c001.y);
  float cb0_009x : packoffset(c009.x);
  float cb0_009y : packoffset(c009.y);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_010w : packoffset(c010.w);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_016z : packoffset(c016.z);
  float cb0_016w : packoffset(c016.w);
  uint cb0_018x : packoffset(c018.x);
  uint cb0_018y : packoffset(c018.y);
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

[numthreads(8, 8, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float3 untonemapped;
  uint initial = (cb0_018x) + (vThreadID.x);
  uint end = (cb0_018y) + (vThreadID.y);

  float _22 = float((uint)(vThreadID.x));
  float _23 = float((uint)(vThreadID.y));
  float _27 = float((uint)(cb0_018x));
  float _28 = float((uint)(cb0_018y));
  float _29 = _22 + 0.5f;
  float _30 = _29 + _27;
  float _31 = _23 + 0.5f;
  float _32 = _31 + _28;
  float _36 = _30 * (cb0_016z);
  float _37 = _32 * (cb0_016w);
  float _38 = _36 + -0.5f;
  float _39 = _37 + -0.5f;
  float _40 = abs(_38);
  float _41 = abs(_39);
  float _42 = max(_40, _41);
  bool _43 = !(_42 >= 0.5f);
  float _342;
  float _343;
  float _344;
  if (_43) {
    float _48 = (cb0_016z)*_29;
    float _49 = (cb0_016w)*_31;
    float _53 = _48 + (cb0_001x);
    float _54 = _49 + (cb0_001y);
    float _58 = (cb0_009x)*_48;
    float _59 = (cb0_009y)*_49;
    float _63 = _58 - (cb0_010z);
    float _64 = _59 - (cb0_010w);
    float _67 = _63 / (cb0_010x);
    float _68 = _64 / (cb0_010y);
    /* int4 _70 = asint(View_PreExposureSceneData[0].data[12 / 4]);
    float _72 = float((uint)((int)(_70.x)));
    float4 _73 = View_PreExposureSceneData[0].data[4 / 4]; */
    float _72 = View_PreExposureSceneData.Load(0u).IsValid;
    float _73 = View_PreExposureSceneData.Load(0u).OneOverPreExposure;
    float _75 = (_73) + -1.0f;
    float _76 = _75 * _72;
    float _77 = _76 + 1.0f;
    float4 _79 = EyeAdaptationBuffer.Load(0u);
    float _87 = max(_48, (cb0_015x));
    float _88 = max(_49, (cb0_015y));
    float _89 = min(_87, (cb0_015z));
    float _90 = min(_88, (cb0_015w));
    float4 _93 = ColorTexture.SampleLevel(ColorSampler, float2(_89, _90), 0.0f);
    float _102 = (cb0_036x)*_48;
    float _103 = (cb0_036y)*_49;
    float _104 = _102 + (cb0_036z);
    float _105 = _103 + (cb0_036w);
    float _111 = max(_104, (cb0_037x));
    float _112 = max(_105, (cb0_037y));
    float _113 = min(_111, (cb0_037z));
    float _114 = min(_112, (cb0_037w));
    float4 _117 = BloomTexture.SampleLevel(BloomSampler, float2(_113, _114), 0.0f);
    float _126 = (cb0_048z)*_67;
    float _127 = (cb0_048w)*_68;
    float _128 = _126 + (cb0_048x);
    float _129 = _127 + (cb0_048y);
    float _130 = _128 * 0.5f;
    float _131 = _129 * 0.5f;
    float _132 = _130 + 0.5f;
    float _133 = 0.5f - _131;
    float4 _136 = BloomDirtMaskTexture.SampleLevel(BloomDirtMaskSampler, float2(_132, _133), 0.0f);
    float _144 = (cb0_045x) * (_136.x);
    float _145 = (cb0_045y) * (_136.y);
    float _146 = (cb0_045z) * (_136.z);
    float _147 = _144 + 1.0f;
    float _148 = _145 + 1.0f;
    float _149 = _146 + 1.0f;
    float4 _155 = SceneColorApplyParamaters[0].data[0 / 4];
    float _159 = (_93.x) * _77;
    float _160 = (_93.y) * _77;
    float _161 = (_93.z) * _77;
    float _164 = dot(float3(_159, _160, _161), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f));
    float _165 = max(_164, (cb0_025w));
    float _166 = log2(_165);
    float _167 = (_79.w) * 0.18000000715255737f;
    float _170 = _167 * (cb0_034x);
    float _171 = log2(_170);
    float _176 = (cb0_034z)*_48;
    float _177 = (cb0_034w)*_49;
    float _179 = (cb0_025y)*_166;
    float _181 = _179 + (cb0_025z);
    float _182 = _181 * 0.96875f;
    float _183 = _182 + 0.015625f;
    float4 _186 = LumBilateralGrid.SampleLevel(LumBilateralGridSampler, float3(_176, _177, _183), 0.0f);
    float _189 = (_186.x) / (_186.y);
    float4 _192 = BlurredLogLum.SampleLevel(BlurredLogLumSampler, float2(_48, _49), 0.0f);
    bool _194 = ((_186.y) < 0.0010000000474974513f);
    float _195 = (_194 ? (_192.x) : _189);
    float _196 = (_192.x) - _195;
    float _197 = _196 * (cb0_033w);
    float _198 = log2((_79.x));
    float _199 = _195 + _198;
    float _200 = _199 + _197;
    float _204 = _198 + _166;
    float _205 = _204 - _200;
    float _206 = _200 - _171;
    bool _207 = (_206 > 0.0f);
    float _208 = (_207 ? (cb0_033x) : (cb0_033y));
    float _209 = _208 * _206;
    float _210 = _205 * (cb0_033z);
    float _211 = _171 - _204;
    float _212 = _211 + _210;
    float _213 = _212 + _209;
    float _214 = exp2(_213);
    float _215 = _77 * (_79.x);
    float _216 = _215 * _214;
    float _217 = (cb0_044x) * (_93.x);
    float _218 = _217 * (_155.x);
    float _219 = _218 * _216;
    float _220 = (cb0_044y) * (_93.y);
    float _221 = _220 * (_155.y);
    float _222 = _221 * _216;
    float _223 = (cb0_044z) * (_93.z);
    float _224 = _223 * (_155.z);
    float _225 = _224 * _216;

    untonemapped = float3(_219, _222, _225);

    float _226 = (_117.x) * _215;
    float _227 = _226 * _147;
    float _228 = (_117.y) * _215;
    float _229 = _228 * _148;
    float _230 = (_117.z) * _215;
    float _231 = _230 * _149;
    float _232 = _227 + 0.002667719265446067f;
    float _233 = _232 + _219;
    float _234 = _229 + 0.002667719265446067f;
    float _235 = _234 + _222;
    float _236 = _231 + 0.002667719265446067f;
    float _237 = _236 + _225;
    float _238 = log2(_233);
    float _239 = log2(_235);
    float _240 = log2(_237);
    float _241 = _238 * 0.0714285746216774f;
    float _242 = _239 * 0.0714285746216774f;
    float _243 = _240 * 0.0714285746216774f;
    float _244 = _241 + 0.6107269525527954f;
    float _245 = _242 + 0.6107269525527954f;
    float _246 = _243 + 0.6107269525527954f;
    float _247 = saturate(_244);
    float _248 = saturate(_245);
    float _249 = saturate(_246);
    float _252 = (cb0_050z)*_247;
    float _253 = (cb0_050z)*_248;
    float _254 = (cb0_050z)*_249;
    float _256 = _252 + (cb0_050w);
    float _257 = _253 + (cb0_050w);
    float _258 = _254 + (cb0_050w);
    float4 _261 = ColorGradingLUT.SampleLevel(ColorGradingLUTSampler, float3(_256, _257, _258), 0.0f);
    OutputSignature output = LutToneMap(untonemapped, float3(_256, _257, _258), ColorGradingLUT, ColorGradingLUTSampler);
    RWOutputTexture[int2(initial, end)] = output.SV_Target;
    RWOutputLuminance[int2(initial, end)] = float4(output.SV_Target_1, output.SV_Target_1, output.SV_Target_1, output.SV_Target_1);
    return;

    float _265 = (_261.x) * 1.0499999523162842f;
    float _266 = (_261.y) * 1.0499999523162842f;
    float _267 = (_261.z) * 1.0499999523162842f;
    float _268 = dot(float3(_265, _266, _267), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
    bool _271 = (((uint)(cb0_051z)) == 0);
    _342 = _265;
    _343 = _266;
    _344 = _267;
    do {
      if (!_271) {
        float _273 = log2(_265);
        float _274 = log2(_266);
        float _275 = log2(_267);
        float _276 = _273 * 0.012683313339948654f;
        float _277 = _274 * 0.012683313339948654f;
        float _278 = _275 * 0.012683313339948654f;
        float _279 = exp2(_276);
        float _280 = exp2(_277);
        float _281 = exp2(_278);
        float _282 = _279 + -0.8359375f;
        float _283 = _280 + -0.8359375f;
        float _284 = _281 + -0.8359375f;
        float _285 = max(0.0f, _282);
        float _286 = max(0.0f, _283);
        float _287 = max(0.0f, _284);
        float _288 = _279 * 18.6875f;
        float _289 = _280 * 18.6875f;
        float _290 = _281 * 18.6875f;
        float _291 = 18.8515625f - _288;
        float _292 = 18.8515625f - _289;
        float _293 = 18.8515625f - _290;
        float _294 = _285 / _291;
        float _295 = _286 / _292;
        float _296 = _287 / _293;
        float _297 = log2(_294);
        float _298 = log2(_295);
        float _299 = log2(_296);
        float _300 = _297 * 6.277394771575928f;
        float _301 = _298 * 6.277394771575928f;
        float _302 = _299 * 6.277394771575928f;
        float _303 = exp2(_300);
        float _304 = exp2(_301);
        float _305 = exp2(_302);
        float _306 = _303 * 10000.0f;
        float _307 = _304 * 10000.0f;
        float _308 = _305 * 10000.0f;
        float _311 = _306 / (cb0_051x);
        float _312 = _307 / (cb0_051x);
        float _313 = _308 / (cb0_051x);
        float _314 = max(6.103519990574569e-05f, _311);
        float _315 = max(6.103519990574569e-05f, _312);
        float _316 = max(6.103519990574569e-05f, _313);
        float _317 = max(_314, 0.0031306699384003878f);
        float _318 = max(_315, 0.0031306699384003878f);
        float _319 = max(_316, 0.0031306699384003878f);
        float _320 = log2(_317);
        float _321 = log2(_318);
        float _322 = log2(_319);
        float _323 = _320 * 0.4166666567325592f;
        float _324 = _321 * 0.4166666567325592f;
        float _325 = _322 * 0.4166666567325592f;
        float _326 = exp2(_323);
        float _327 = exp2(_324);
        float _328 = exp2(_325);
        float _329 = _326 * 1.0549999475479126f;
        float _330 = _327 * 1.0549999475479126f;
        float _331 = _328 * 1.0549999475479126f;
        float _332 = _329 + -0.054999999701976776f;
        float _333 = _330 + -0.054999999701976776f;
        float _334 = _331 + -0.054999999701976776f;
        float _335 = _314 * 12.920000076293945f;
        float _336 = _315 * 12.920000076293945f;
        float _337 = _316 * 12.920000076293945f;
        float _338 = min(_335, _332);
        float _339 = min(_336, _333);
        float _340 = min(_337, _334);
        _342 = _338;
        _343 = _339;
        _344 = _340;
      }
      float _345 = _54 * 543.3099975585938f;
      float _346 = _53 + _345;
      float _347 = sin(_346);
      float _348 = _347 * 493013.0f;
      float _349 = frac(_348);
      float _350 = _349 * 2.0f;
      float _351 = _350 + -1.0f;
      float _352 = _351 * 0x7FF0000000000000;
      float _353 = max(_352, -1.0f);
      float _354 = min(_353, 1.0f);
      float _355 = abs(_351);
      float _356 = 1.0f - _355;
      float _357 = saturate(_356);
      float _358 = sqrt(_357);
      float _359 = _358 * _354;
      float _360 = _354 - _359;
      float _363 = _360 * (cb0_051y);
      float _364 = _363 + _342;
      float _365 = _363 + _343;
      float _366 = _363 + _344;
      uint _370 = (cb0_018x) + (vThreadID.x);
      uint _371 = (cb0_018y) + (vThreadID.y);
      RWOutputTexture[int2(_370, _371)] = float4(_364, _365, _366, 0.0f);
      RWOutputLuminance[int2(_370, _371)] = float4(_268, _268, _268, _268);
    } while (false);
  }
}

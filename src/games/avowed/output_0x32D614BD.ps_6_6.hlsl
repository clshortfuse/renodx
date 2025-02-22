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
  /*  int4 _29 = asint(View_PreExposureSceneData[0].data[12 / 4]);
   float _31 = float((uint)((int)(_29.x)));
   float4 _32 = View_PreExposureSceneData[0].data[4 / 4]; */
  float _31 = View_PreExposureSceneData.Load(0u).IsValid;
  float _32 = View_PreExposureSceneData.Load(0u).OneOverPreExposure;
  float _34 = (_32) + -1.0f;
  float _35 = _34 * _31;
  float _36 = _35 + 1.0f;
  float4 _38 = EyeAdaptationBuffer.Load(0u);
  float _50 = (cb0_048z) * (TEXCOORD_3.x);
  float _51 = (cb0_048w) * (TEXCOORD_3.y);
  float _52 = _50 + (cb0_048x);
  float _53 = _51 + (cb0_048y);
  bool _54 = (_52 > 0.0f);
  bool _55 = (_53 > 0.0f);
  bool _56 = (_52 < 0.0f);
  bool _57 = (_53 < 0.0f);
  int _58 = int(_54);
  int _59 = int(_55);
  int _60 = int(_56);
  int _61 = int(_57);
  int _62 = _58 - _60;
  int _63 = _59 - _61;
  float _64 = float(_62);
  float _65 = float(_63);
  float _66 = abs(_52);
  float _67 = abs(_53);
  float _68 = _66 - (cb0_046z);
  float _69 = _67 - (cb0_046z);
  float _70 = saturate(_68);
  float _71 = saturate(_69);
  float _72 = _70 * (cb0_046x);
  float _73 = _72 * _64;
  float _74 = _71 * (cb0_046x);
  float _75 = _74 * _65;
  float _76 = _70 * (cb0_046y);
  float _77 = _76 * _64;
  float _78 = _71 * (cb0_046y);
  float _79 = _78 * _65;
  float _80 = _52 - _73;
  float _81 = _53 - _75;
  float _82 = _52 - _77;
  float _83 = _53 - _79;
  float _89 = _80 * (cb0_049z);
  float _90 = _81 * (cb0_049w);
  float _91 = _89 + (cb0_049x);
  float _92 = _90 + (cb0_049y);
  float _93 = _82 * (cb0_049z);
  float _94 = _83 * (cb0_049w);
  float _95 = _93 + (cb0_049x);
  float _96 = _94 + (cb0_049y);
  float _103 = _91 * (cb0_010x);
  float _104 = _92 * (cb0_010y);
  float _107 = _103 + (cb0_010z);
  float _108 = _104 + (cb0_010w);
  float _109 = _107 * (cb0_009z);
  float _110 = _108 * (cb0_009w);
  float _111 = (cb0_010x) * _95;
  float _112 = (cb0_010y) * _96;
  float _113 = _111 + (cb0_010z);
  float _114 = _112 + (cb0_010w);
  float _115 = _113 * (cb0_009z);
  float _116 = _114 * (cb0_009w);
  float _122 = max(_109, (cb0_015x));
  float _123 = max(_110, (cb0_015y));
  float _124 = min(_122, (cb0_015z));
  float _125 = min(_123, (cb0_015w));
  float4 _128 = ColorTexture.Sample(ColorSampler, float2(_124, _125));
  float _135 = max(_115, (cb0_015x));
  float _136 = max(_116, (cb0_015y));
  float _137 = min(_135, (cb0_015z));
  float _138 = min(_136, (cb0_015w));
  float4 _141 = ColorTexture.Sample(ColorSampler, float2(_137, _138));
  float _148 = max((TEXCOORD.x), (cb0_015x));
  float _149 = max((TEXCOORD.y), (cb0_015y));
  float _150 = min(_148, (cb0_015z));
  float _151 = min(_149, (cb0_015w));
  float4 _154 = ColorTexture.Sample(ColorSampler, float2(_150, _151));
  float _161 = (cb0_036x) * (TEXCOORD.x);
  float _162 = (cb0_036y) * (TEXCOORD.y);
  float _163 = _161 + (cb0_036z);
  float _164 = _162 + (cb0_036w);
  float _170 = max(_163, (cb0_037x));
  float _171 = max(_164, (cb0_037y));
  float _172 = min(_170, (cb0_037z));
  float _173 = min(_171, (cb0_037w));
  float4 _176 = BloomTexture.Sample(BloomSampler, float2(_172, _173));
  float _185 = (cb0_048z) * (TEXCOORD_3.x);
  float _186 = (cb0_048w) * (TEXCOORD_3.y);
  float _187 = _185 + (cb0_048x);
  float _188 = _186 + (cb0_048y);
  float _189 = _187 * 0.5f;
  float _190 = _188 * 0.5f;
  float _191 = _189 + 0.5f;
  float _192 = 0.5f - _190;
  float4 _195 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2(_191, _192));
  float _203 = (cb0_045x) * (_195.x);
  float _204 = (cb0_045y) * (_195.y);
  float _205 = (cb0_045z) * (_195.z);
  float _206 = _203 + 1.0f;
  float _207 = _204 + 1.0f;
  float _208 = _205 + 1.0f;
  float _209 = _206 * (_176.x);
  float _210 = _207 * (_176.y);
  float _211 = _208 * (_176.z);
  float _214 = (cb0_047x) * (TEXCOORD_1.x);
  float _215 = (cb0_047x) * (TEXCOORD_1.y);
  float _216 = dot(float2(_214, _215), float2(_214, _215));
  float _217 = _216 + 1.0f;
  float _218 = 1.0f / _217;
  float _219 = _218 * _218;
  float4 _225 = SceneColorApplyParamaters[0].data[0 / 4];
  float _229 = (_128.x) * _36;
  float _230 = (_141.y) * _36;
  float _231 = (_154.z) * _36;
  float _234 = dot(float3(_229, _230, _231), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f));
  float _235 = max(_234, (cb0_025w));
  float _236 = log2(_235);
  float _237 = (_38.w) * 0.18000000715255737f;
  float _240 = _237 * (cb0_034x);
  float _241 = log2(_240);
  float _246 = (cb0_034z) * (TEXCOORD_4.x);
  float _247 = (cb0_034w) * (TEXCOORD_4.y);
  float _249 = (cb0_025y) * _236;
  float _251 = _249 + (cb0_025z);
  float _252 = _251 * 0.96875f;
  float _253 = _252 + 0.015625f;
  float4 _256 = LumBilateralGrid.Sample(LumBilateralGridSampler, float3(_246, _247, _253));
  float _259 = (_256.x) / (_256.y);
  float4 _262 = BlurredLogLum.Sample(BlurredLogLumSampler, float2((TEXCOORD_4.x), (TEXCOORD_4.y)));
  bool _264 = ((_256.y) < 0.0010000000474974513f);
  float _265 = (_264 ? (_262.x) : _259);
  float _266 = (_262.x) - _265;
  float _267 = _266 * (cb0_033w);
  float _268 = log2((_38.x));
  float _269 = _265 + _268;
  float _270 = _269 + _267;
  float _275 = _268 + _236;
  float _276 = _275 - _270;
  float _277 = _270 - _241;
  bool _278 = (_277 > 0.0f);
  float _279 = (_278 ? (cb0_033x) : (cb0_033y));
  float _280 = _279 * _277;
  float _281 = _276 * (cb0_033z);
  float _282 = _241 - _275;
  float _283 = _282 + _281;
  float _284 = _283 + _280;
  float _285 = exp2(_284);
  float _286 = _36 * (_38.x);
  float _287 = _286 * _219;
  float _288 = _287 * _285;
  float _289 = (cb0_044x) * (_128.x);
  float _290 = _289 * (_225.x);
  float _291 = _290 * _288;
  float _292 = (cb0_044y) * (_141.y);
  float _293 = _292 * (_225.y);
  float _294 = _293 * _288;
  float _295 = (cb0_044z) * (_154.z);
  float _296 = _295 * (_225.z);
  float _297 = _296 * _288;
  untonemapped = float3(_291, _294, _297);

  float _298 = _209 * _287;
  float _299 = _210 * _287;
  float _300 = _211 * _287;


  float _301 = _298 + 0.002667719265446067f;
  float _302 = _301 + _291;
  float _303 = _299 + 0.002667719265446067f;
  float _304 = _303 + _294;
  float _305 = _300 + 0.002667719265446067f;
  float _306 = _305 + _297;
  float _307 = log2(_302);
  float _308 = log2(_304);
  float _309 = log2(_306);
  float _310 = _307 * 0.0714285746216774f;
  float _311 = _308 * 0.0714285746216774f;
  float _312 = _309 * 0.0714285746216774f;
  float _313 = _310 + 0.6107269525527954f;
  float _314 = _311 + 0.6107269525527954f;
  float _315 = _312 + 0.6107269525527954f;
  float _316 = saturate(_313);
  float _317 = saturate(_314);
  float _318 = saturate(_315);
  float _321 = (cb0_050z) * _316;
  float _322 = (cb0_050z) * _317;
  float _323 = (cb0_050z) * _318;
  float _325 = _321 + (cb0_050w);
  float _326 = _322 + (cb0_050w);
  float _327 = _323 + (cb0_050w);
  float4 _330 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3(_325, _326, _327));
  return LutToneMap(untonemapped, float3(_325, _326, _327), ColorGradingLUT, ColorGradingLUTSampler);

  float _334 = (_330.x) * 1.0499999523162842f;
  float _335 = (_330.y) * 1.0499999523162842f;
  float _336 = (_330.z) * 1.0499999523162842f;
  float _337 = dot(float3(_334, _335, _336), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  bool _340 = (((uint)(cb0_051z)) == 0);
  float _411 = _334;
  float _412 = _335;
  float _413 = _336;
  if (!_340) {
    float _342 = log2(_334);
    float _343 = log2(_335);
    float _344 = log2(_336);
    float _345 = _342 * 0.012683313339948654f;
    float _346 = _343 * 0.012683313339948654f;
    float _347 = _344 * 0.012683313339948654f;
    float _348 = exp2(_345);
    float _349 = exp2(_346);
    float _350 = exp2(_347);
    float _351 = _348 + -0.8359375f;
    float _352 = _349 + -0.8359375f;
    float _353 = _350 + -0.8359375f;
    float _354 = max(0.0f, _351);
    float _355 = max(0.0f, _352);
    float _356 = max(0.0f, _353);
    float _357 = _348 * 18.6875f;
    float _358 = _349 * 18.6875f;
    float _359 = _350 * 18.6875f;
    float _360 = 18.8515625f - _357;
    float _361 = 18.8515625f - _358;
    float _362 = 18.8515625f - _359;
    float _363 = _354 / _360;
    float _364 = _355 / _361;
    float _365 = _356 / _362;
    float _366 = log2(_363);
    float _367 = log2(_364);
    float _368 = log2(_365);
    float _369 = _366 * 6.277394771575928f;
    float _370 = _367 * 6.277394771575928f;
    float _371 = _368 * 6.277394771575928f;
    float _372 = exp2(_369);
    float _373 = exp2(_370);
    float _374 = exp2(_371);
    float _375 = _372 * 10000.0f;
    float _376 = _373 * 10000.0f;
    float _377 = _374 * 10000.0f;
    float _380 = _375 / (cb0_051x);
    float _381 = _376 / (cb0_051x);
    float _382 = _377 / (cb0_051x);
    float _383 = max(6.103519990574569e-05f, _380);
    float _384 = max(6.103519990574569e-05f, _381);
    float _385 = max(6.103519990574569e-05f, _382);
    float _386 = max(_383, 0.0031306699384003878f);
    float _387 = max(_384, 0.0031306699384003878f);
    float _388 = max(_385, 0.0031306699384003878f);
    float _389 = log2(_386);
    float _390 = log2(_387);
    float _391 = log2(_388);
    float _392 = _389 * 0.4166666567325592f;
    float _393 = _390 * 0.4166666567325592f;
    float _394 = _391 * 0.4166666567325592f;
    float _395 = exp2(_392);
    float _396 = exp2(_393);
    float _397 = exp2(_394);
    float _398 = _395 * 1.0549999475479126f;
    float _399 = _396 * 1.0549999475479126f;
    float _400 = _397 * 1.0549999475479126f;
    float _401 = _398 + -0.054999999701976776f;
    float _402 = _399 + -0.054999999701976776f;
    float _403 = _400 + -0.054999999701976776f;
    float _404 = _383 * 12.920000076293945f;
    float _405 = _384 * 12.920000076293945f;
    float _406 = _385 * 12.920000076293945f;
    float _407 = min(_404, _401);
    float _408 = min(_405, _402);
    float _409 = min(_406, _403);
    _411 = _407;
    _412 = _408;
    _413 = _409;
  }
  float _414 = (TEXCOORD_2.w) * 543.3099975585938f;
  float _415 = _414 + (TEXCOORD_2.z);
  float _416 = sin(_415);
  float _417 = _416 * 493013.0f;
  float _418 = frac(_417);
  float _419 = _418 * 2.0f;
  float _420 = _419 + -1.0f;
  float _421 = _420 * 0x7FF0000000000000;
  float _422 = max(_421, -1.0f);
  float _423 = min(_422, 1.0f);
  float _424 = abs(_420);
  float _425 = 1.0f - _424;
  float _426 = saturate(_425);
  float _427 = sqrt(_426);
  float _428 = _427 * _423;
  float _429 = _423 - _428;
  float _432 = _429 * (cb0_051y);
  float _433 = _432 + _411;
  float _434 = _432 + _412;
  float _435 = _432 + _413;
  SV_Target.x = _433;
  SV_Target.y = _434;
  SV_Target.z = _435;
  SV_Target.w = 0.0f;
  SV_Target_1 = _337;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

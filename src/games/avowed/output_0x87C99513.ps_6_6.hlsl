#include "./common.hlsl"

struct _View_PreExposureSceneData {
  float data[8];
};
StructuredBuffer<_View_PreExposureSceneData> View_PreExposureSceneData : register(t0);

struct _EyeAdaptationBuffer {
  float data[4];
};
StructuredBuffer<_EyeAdaptationBuffer> EyeAdaptationBuffer : register(t1);

Texture2D<float4> ColorTexture : register(t2);

Texture2D<float4> BloomTexture : register(t3);

struct _SceneColorApplyParamaters {
  float data[4];
};
StructuredBuffer<_SceneColorApplyParamaters> SceneColorApplyParamaters : register(t4);

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

SamplerState BloomDirtMaskSampler : register(s2);

SamplerState ColorGradingLUTSampler : register(s3);

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
  int4 _23 = asint(View_PreExposureSceneData[0].data[12 / 4]);
  float _25 = float((uint)((int)(_23.x)));
  float4 _26 = View_PreExposureSceneData[0].data[4 / 4];
  float _28 = (_26.x) + -1.0f;
  float _29 = _28 * _25;
  float _30 = _29 + 1.0f;
  float4 _32 = EyeAdaptationBuffer[0].data[0 / 4];
  float _43 = (cb0_048z) * (TEXCOORD_3.x);
  float _44 = (cb0_048w) * (TEXCOORD_3.y);
  float _45 = _43 + (cb0_048x);
  float _46 = _44 + (cb0_048y);
  bool _47 = (_45 > 0.0f);
  bool _48 = (_46 > 0.0f);
  bool _49 = (_45 < 0.0f);
  bool _50 = (_46 < 0.0f);
  int _51 = int(_47);
  int _52 = int(_48);
  int _53 = int(_49);
  int _54 = int(_50);
  int _55 = _51 - _53;
  int _56 = _52 - _54;
  float _57 = float(_55);
  float _58 = float(_56);
  float _59 = abs(_45);
  float _60 = abs(_46);
  float _61 = _59 - (cb0_046z);
  float _62 = _60 - (cb0_046z);
  float _63 = saturate(_61);
  float _64 = saturate(_62);
  float _65 = _63 * (cb0_046x);
  float _66 = _65 * _57;
  float _67 = _64 * (cb0_046x);
  float _68 = _67 * _58;
  float _69 = _63 * (cb0_046y);
  float _70 = _69 * _57;
  float _71 = _64 * (cb0_046y);
  float _72 = _71 * _58;
  float _73 = _45 - _66;
  float _74 = _46 - _68;
  float _75 = _45 - _70;
  float _76 = _46 - _72;
  float _82 = _73 * (cb0_049z);
  float _83 = _74 * (cb0_049w);
  float _84 = _82 + (cb0_049x);
  float _85 = _83 + (cb0_049y);
  float _86 = _75 * (cb0_049z);
  float _87 = _76 * (cb0_049w);
  float _88 = _86 + (cb0_049x);
  float _89 = _87 + (cb0_049y);
  float _96 = _84 * (cb0_010x);
  float _97 = _85 * (cb0_010y);
  float _100 = _96 + (cb0_010z);
  float _101 = _97 + (cb0_010w);
  float _102 = _100 * (cb0_009z);
  float _103 = _101 * (cb0_009w);
  float _104 = (cb0_010x) * _88;
  float _105 = (cb0_010y) * _89;
  float _106 = _104 + (cb0_010z);
  float _107 = _105 + (cb0_010w);
  float _108 = _106 * (cb0_009z);
  float _109 = _107 * (cb0_009w);
  float _115 = max(_102, (cb0_015x));
  float _116 = max(_103, (cb0_015y));
  float _117 = min(_115, (cb0_015z));
  float _118 = min(_116, (cb0_015w));
  float4 _121 = ColorTexture.Sample(ColorSampler, float2(_117, _118));
  float _128 = max(_108, (cb0_015x));
  float _129 = max(_109, (cb0_015y));
  float _130 = min(_128, (cb0_015z));
  float _131 = min(_129, (cb0_015w));
  float4 _134 = ColorTexture.Sample(ColorSampler, float2(_130, _131));
  float _141 = max((TEXCOORD.x), (cb0_015x));
  float _142 = max((TEXCOORD.y), (cb0_015y));
  float _143 = min(_141, (cb0_015z));
  float _144 = min(_142, (cb0_015w));
  float4 _147 = ColorTexture.Sample(ColorSampler, float2(_143, _144));
  float _154 = (cb0_036x) * (TEXCOORD.x);
  float _155 = (cb0_036y) * (TEXCOORD.y);
  float _156 = _154 + (cb0_036z);
  float _157 = _155 + (cb0_036w);
  float _163 = max(_156, (cb0_037x));
  float _164 = max(_157, (cb0_037y));
  float _165 = min(_163, (cb0_037z));
  float _166 = min(_164, (cb0_037w));
  float4 _169 = BloomTexture.Sample(BloomSampler, float2(_165, _166));
  float _178 = (cb0_048z) * (TEXCOORD_3.x);
  float _179 = (cb0_048w) * (TEXCOORD_3.y);
  float _180 = _178 + (cb0_048x);
  float _181 = _179 + (cb0_048y);
  float _182 = _180 * 0.5f;
  float _183 = _181 * 0.5f;
  float _184 = _182 + 0.5f;
  float _185 = 0.5f - _183;
  float4 _188 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2(_184, _185));
  float _196 = (cb0_045x) * (_188.x);
  float _197 = (cb0_045y) * (_188.y);
  float _198 = (cb0_045z) * (_188.z);
  float _199 = _196 + 1.0f;
  float _200 = _197 + 1.0f;
  float _201 = _198 + 1.0f;
  float _202 = _199 * (_169.x);
  float _203 = _200 * (_169.y);
  float _204 = _201 * (_169.z);
  float _207 = (cb0_047x) * (TEXCOORD_1.x);
  float _208 = (cb0_047x) * (TEXCOORD_1.y);
  float _209 = dot(float2(_207, _208), float2(_207, _208));
  float _210 = _209 + 1.0f;
  float _211 = 1.0f / _210;
  float _212 = _211 * _211;
  float4 _218 = SceneColorApplyParamaters[0].data[0 / 4];
  float _222 = _30 * (_32.x);
  float _223 = _222 * _212;
  float _224 = (cb0_044x) * (_121.x);
  float _225 = _224 * _223;
  float _226 = _225 * (_218.x);
  float _227 = (cb0_044y) * (_134.y);
  float _228 = _227 * _223;
  float _229 = _228 * (_218.y);
  float _230 = (cb0_044z) * (_147.z);
  float _231 = _230 * _223;
  float _232 = _231 * (_218.z);
  untonemapped = float3(_226, _229, _232);

  float _233 = _202 * _223;
  float _234 = _203 * _223;
  float _235 = _204 * _223;
  float _236 = _233 + 0.002667719265446067f;
  float _237 = _236 + _226;
  float _238 = _234 + 0.002667719265446067f;
  float _239 = _238 + _229;
  float _240 = _235 + 0.002667719265446067f;
  float _241 = _240 + _232;
  float _242 = log2(_237);
  float _243 = log2(_239);
  float _244 = log2(_241);
  float _245 = _242 * 0.0714285746216774f;
  float _246 = _243 * 0.0714285746216774f;
  float _247 = _244 * 0.0714285746216774f;
  float _248 = _245 + 0.6107269525527954f;
  float _249 = _246 + 0.6107269525527954f;
  float _250 = _247 + 0.6107269525527954f;
  float _251 = saturate(_248);
  float _252 = saturate(_249);
  float _253 = saturate(_250);
  float _256 = (cb0_050z) * _251;
  float _257 = (cb0_050z) * _252;
  float _258 = (cb0_050z) * _253;
  float _260 = _256 + (cb0_050w);
  float _261 = _257 + (cb0_050w);
  float _262 = _258 + (cb0_050w);
  float4 _265 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3(_260, _261, _262));
  return LutToneMap(untonemapped, float3(_260, _261, _262), ColorGradingLUT, ColorGradingLUTSampler);

  float _269 = (_265.x) * 1.0499999523162842f;
  float _270 = (_265.y) * 1.0499999523162842f;
  float _271 = (_265.z) * 1.0499999523162842f;
  float _272 = dot(float3(_269, _270, _271), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  bool _275 = (((uint)(cb0_051z)) == 0);
  float _346 = _269;
  float _347 = _270;
  float _348 = _271;
  if (!_275) {
    float _277 = log2(_269);
    float _278 = log2(_270);
    float _279 = log2(_271);
    float _280 = _277 * 0.012683313339948654f;
    float _281 = _278 * 0.012683313339948654f;
    float _282 = _279 * 0.012683313339948654f;
    float _283 = exp2(_280);
    float _284 = exp2(_281);
    float _285 = exp2(_282);
    float _286 = _283 + -0.8359375f;
    float _287 = _284 + -0.8359375f;
    float _288 = _285 + -0.8359375f;
    float _289 = max(0.0f, _286);
    float _290 = max(0.0f, _287);
    float _291 = max(0.0f, _288);
    float _292 = _283 * 18.6875f;
    float _293 = _284 * 18.6875f;
    float _294 = _285 * 18.6875f;
    float _295 = 18.8515625f - _292;
    float _296 = 18.8515625f - _293;
    float _297 = 18.8515625f - _294;
    float _298 = _289 / _295;
    float _299 = _290 / _296;
    float _300 = _291 / _297;
    float _301 = log2(_298);
    float _302 = log2(_299);
    float _303 = log2(_300);
    float _304 = _301 * 6.277394771575928f;
    float _305 = _302 * 6.277394771575928f;
    float _306 = _303 * 6.277394771575928f;
    float _307 = exp2(_304);
    float _308 = exp2(_305);
    float _309 = exp2(_306);
    float _310 = _307 * 10000.0f;
    float _311 = _308 * 10000.0f;
    float _312 = _309 * 10000.0f;
    float _315 = _310 / (cb0_051x);
    float _316 = _311 / (cb0_051x);
    float _317 = _312 / (cb0_051x);
    float _318 = max(6.103519990574569e-05f, _315);
    float _319 = max(6.103519990574569e-05f, _316);
    float _320 = max(6.103519990574569e-05f, _317);
    float _321 = max(_318, 0.0031306699384003878f);
    float _322 = max(_319, 0.0031306699384003878f);
    float _323 = max(_320, 0.0031306699384003878f);
    float _324 = log2(_321);
    float _325 = log2(_322);
    float _326 = log2(_323);
    float _327 = _324 * 0.4166666567325592f;
    float _328 = _325 * 0.4166666567325592f;
    float _329 = _326 * 0.4166666567325592f;
    float _330 = exp2(_327);
    float _331 = exp2(_328);
    float _332 = exp2(_329);
    float _333 = _330 * 1.0549999475479126f;
    float _334 = _331 * 1.0549999475479126f;
    float _335 = _332 * 1.0549999475479126f;
    float _336 = _333 + -0.054999999701976776f;
    float _337 = _334 + -0.054999999701976776f;
    float _338 = _335 + -0.054999999701976776f;
    float _339 = _318 * 12.920000076293945f;
    float _340 = _319 * 12.920000076293945f;
    float _341 = _320 * 12.920000076293945f;
    float _342 = min(_339, _336);
    float _343 = min(_340, _337);
    float _344 = min(_341, _338);
    _346 = _342;
    _347 = _343;
    _348 = _344;
  }
  float _349 = (TEXCOORD_2.w) * 543.3099975585938f;
  float _350 = _349 + (TEXCOORD_2.z);
  float _351 = sin(_350);
  float _352 = _351 * 493013.0f;
  float _353 = frac(_352);
  float _354 = _353 * 2.0f;
  float _355 = _354 + -1.0f;
  float _356 = _355 * 0x7FF0000000000000;
  float _357 = max(_356, -1.0f);
  float _358 = min(_357, 1.0f);
  float _359 = abs(_355);
  float _360 = 1.0f - _359;
  float _361 = saturate(_360);
  float _362 = sqrt(_361);
  float _363 = _362 * _358;
  float _364 = _358 - _363;
  float _367 = _364 * (cb0_051y);
  float _368 = _367 + _346;
  float _369 = _367 + _347;
  float _370 = _367 + _348;
  SV_Target.x = _368;
  SV_Target.y = _369;
  SV_Target.z = _370;
  SV_Target.w = 0.0f;
  SV_Target_1 = _272;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

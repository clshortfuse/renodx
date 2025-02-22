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

Texture2D<float4> BloomDirtMaskTexture : register(t5);

Texture3D<float4> ColorGradingLUT : register(t6);

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

SamplerState BloomDirtMaskSampler : register(s2);

SamplerState ColorGradingLUTSampler : register(s3);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float3 untonemapped;

  /* int4 _21 = asint(View_PreExposureSceneData[0].data[12 / 4]);
  float _23 = float((uint)((int)(_21.x)));
  float4 _24 = View_PreExposureSceneData[0].data[4 / 4]; */
  float _23 = View_PreExposureSceneData.Load(0u).IsValid;
  float _24 = View_PreExposureSceneData.Load(0u).OneOverPreExposure;
  float _26 = (_24) + -1.0f;
  float _27 = _26 * _23;
  float _28 = _27 + 1.0f;
  /* float4 _30 = EyeAdaptationBuffer.Load(0u); */
  float4 _30 = EyeAdaptationBuffer.Load(0u);
  float _37 = max((TEXCOORD.x), (cb0_015x));
  float _38 = max((TEXCOORD.y), (cb0_015y));
  float _39 = min(_37, (cb0_015z));
  float _40 = min(_38, (cb0_015w));
  float4 _43 = ColorTexture.Sample(ColorSampler, float2(_39, _40));
  float _52 = (cb0_036x) * (TEXCOORD.x);
  float _53 = (cb0_036y) * (TEXCOORD.y);
  float _54 = _52 + (cb0_036z);
  float _55 = _53 + (cb0_036w);
  float _61 = max(_54, (cb0_037x));
  float _62 = max(_55, (cb0_037y));
  float _63 = min(_61, (cb0_037z));
  float _64 = min(_62, (cb0_037w));
  float4 _67 = BloomTexture.Sample(BloomSampler, float2(_63, _64));
  float _76 = (cb0_048z) * (TEXCOORD_3.x);
  float _77 = (cb0_048w) * (TEXCOORD_3.y);
  float _78 = _76 + (cb0_048x);
  float _79 = _77 + (cb0_048y);
  float _80 = _78 * 0.5f;
  float _81 = _79 * 0.5f;
  float _82 = _80 + 0.5f;
  float _83 = 0.5f - _81;
  float4 _86 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2(_82, _83));
  float _94 = (cb0_045x) * (_86.x);
  float _95 = (cb0_045y) * (_86.y);
  float _96 = (cb0_045z) * (_86.z);
  float _97 = _94 + 1.0f;
  float _98 = _95 + 1.0f;
  float _99 = _96 + 1.0f;
  float4 _105 = SceneColorApplyParamaters[0].data[0 / 4];
  float _109 = _28 * (_30.x);
  float _110 = (_43.x) * _109;
  float _111 = _110 * (cb0_044x);
  float _112 = _111 * (_105.x);
  float _113 = (_43.y) * _109;
  float _114 = _113 * (cb0_044y);
  float _115 = _114 * (_105.y);
  float _116 = (_43.z) * _109;
  float _117 = _116 * (cb0_044z);
  float _118 = _117 * (_105.z);

  untonemapped = float3(_112, _115, _118);

  float _119 = (_67.x) * _109;
  float _120 = _119 * _97;
  float _121 = (_67.y) * _109;
  float _122 = _121 * _98;
  float _123 = (_67.z) * _109;
  float _124 = _123 * _99;
  float _125 = _120 + 0.002667719265446067f;
  float _126 = _125 + _112;
  float _127 = _122 + 0.002667719265446067f;
  float _128 = _127 + _115;
  float _129 = _124 + 0.002667719265446067f;
  float _130 = _129 + _118;
  float _131 = log2(_126);
  float _132 = log2(_128);
  float _133 = log2(_130);
  float _134 = _131 * 0.0714285746216774f;
  float _135 = _132 * 0.0714285746216774f;
  float _136 = _133 * 0.0714285746216774f;
  float _137 = _134 + 0.6107269525527954f;
  float _138 = _135 + 0.6107269525527954f;
  float _139 = _136 + 0.6107269525527954f;
  float _140 = saturate(_137);
  float _141 = saturate(_138);
  float _142 = saturate(_139);
  float _145 = (cb0_050z) * _140;
  float _146 = (cb0_050z) * _141;
  float _147 = (cb0_050z) * _142;
  float _149 = _145 + (cb0_050w);
  float _150 = _146 + (cb0_050w);
  float _151 = _147 + (cb0_050w);
  float4 _154 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3(_149, _150, _151));
  return LutToneMap(untonemapped, float3(_149, _150, _151), ColorGradingLUT, ColorGradingLUTSampler).SV_Target;

  float _158 = (_154.x) * 1.0499999523162842f;
  float _159 = (_154.y) * 1.0499999523162842f;
  float _160 = (_154.z) * 1.0499999523162842f;
  bool _163 = (((uint)(cb0_051z)) == 0);
  float _234 = _158;
  float _235 = _159;
  float _236 = _160;
  if (!_163) {
    float _165 = log2(_158);
    float _166 = log2(_159);
    float _167 = log2(_160);
    float _168 = _165 * 0.012683313339948654f;
    float _169 = _166 * 0.012683313339948654f;
    float _170 = _167 * 0.012683313339948654f;
    float _171 = exp2(_168);
    float _172 = exp2(_169);
    float _173 = exp2(_170);
    float _174 = _171 + -0.8359375f;
    float _175 = _172 + -0.8359375f;
    float _176 = _173 + -0.8359375f;
    float _177 = max(0.0f, _174);
    float _178 = max(0.0f, _175);
    float _179 = max(0.0f, _176);
    float _180 = _171 * 18.6875f;
    float _181 = _172 * 18.6875f;
    float _182 = _173 * 18.6875f;
    float _183 = 18.8515625f - _180;
    float _184 = 18.8515625f - _181;
    float _185 = 18.8515625f - _182;
    float _186 = _177 / _183;
    float _187 = _178 / _184;
    float _188 = _179 / _185;
    float _189 = log2(_186);
    float _190 = log2(_187);
    float _191 = log2(_188);
    float _192 = _189 * 6.277394771575928f;
    float _193 = _190 * 6.277394771575928f;
    float _194 = _191 * 6.277394771575928f;
    float _195 = exp2(_192);
    float _196 = exp2(_193);
    float _197 = exp2(_194);
    float _198 = _195 * 10000.0f;
    float _199 = _196 * 10000.0f;
    float _200 = _197 * 10000.0f;
    float _203 = _198 / (cb0_051x);
    float _204 = _199 / (cb0_051x);
    float _205 = _200 / (cb0_051x);
    float _206 = max(6.103519990574569e-05f, _203);
    float _207 = max(6.103519990574569e-05f, _204);
    float _208 = max(6.103519990574569e-05f, _205);
    float _209 = max(_206, 0.0031306699384003878f);
    float _210 = max(_207, 0.0031306699384003878f);
    float _211 = max(_208, 0.0031306699384003878f);
    float _212 = log2(_209);
    float _213 = log2(_210);
    float _214 = log2(_211);
    float _215 = _212 * 0.4166666567325592f;
    float _216 = _213 * 0.4166666567325592f;
    float _217 = _214 * 0.4166666567325592f;
    float _218 = exp2(_215);
    float _219 = exp2(_216);
    float _220 = exp2(_217);
    float _221 = _218 * 1.0549999475479126f;
    float _222 = _219 * 1.0549999475479126f;
    float _223 = _220 * 1.0549999475479126f;
    float _224 = _221 + -0.054999999701976776f;
    float _225 = _222 + -0.054999999701976776f;
    float _226 = _223 + -0.054999999701976776f;
    float _227 = _206 * 12.920000076293945f;
    float _228 = _207 * 12.920000076293945f;
    float _229 = _208 * 12.920000076293945f;
    float _230 = min(_227, _224);
    float _231 = min(_228, _225);
    float _232 = min(_229, _226);
    _234 = _230;
    _235 = _231;
    _236 = _232;
  }
  float _237 = (TEXCOORD_2.w) * 543.3099975585938f;
  float _238 = _237 + (TEXCOORD_2.z);
  float _239 = sin(_238);
  float _240 = _239 * 493013.0f;
  float _241 = frac(_240);
  float _242 = _241 * 2.0f;
  float _243 = _242 + -1.0f;
  float _244 = _243 * 0x7FF0000000000000;
  float _245 = max(_244, -1.0f);
  float _246 = min(_245, 1.0f);
  float _247 = abs(_243);
  float _248 = 1.0f - _247;
  float _249 = saturate(_248);
  float _250 = sqrt(_249);
  float _251 = _250 * _246;
  float _252 = _246 - _251;
  float _255 = _252 * (cb0_051y);
  float _256 = _255 + _234;
  float _257 = _255 + _235;
  float _258 = _255 + _236;
  SV_Target.x = _256;
  SV_Target.y = _257;
  SV_Target.z = _258;
  SV_Target.w = 0.0f;
  return SV_Target;
}

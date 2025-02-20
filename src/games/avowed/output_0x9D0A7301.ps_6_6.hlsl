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
  int4 _21 = asint(View_PreExposureSceneData[0].data[12 / 4]);
  float _23 = float((uint)((int)(_21.x)));
  float4 _24 = View_PreExposureSceneData[0].data[4 / 4];
  float _26 = (_24.x) + -1.0f;
  float _27 = _26 * _23;
  float _28 = _27 + 1.0f;
  float4 _30 = EyeAdaptationBuffer[0].data[0 / 4];
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
  return LutToneMap(untonemapped, float3(_149, _150, _151), ColorGradingLUT, ColorGradingLUTSampler);

  float _158 = (_154.x) * 1.0499999523162842f;
  float _159 = (_154.y) * 1.0499999523162842f;
  float _160 = (_154.z) * 1.0499999523162842f;
  float _161 = dot(float3(_158, _159, _160), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  bool _164 = (((uint)(cb0_051z)) == 0);
  float _235 = _158;
  float _236 = _159;
  float _237 = _160;
  if (!_164) {
    float _166 = log2(_158);
    float _167 = log2(_159);
    float _168 = log2(_160);
    float _169 = _166 * 0.012683313339948654f;
    float _170 = _167 * 0.012683313339948654f;
    float _171 = _168 * 0.012683313339948654f;
    float _172 = exp2(_169);
    float _173 = exp2(_170);
    float _174 = exp2(_171);
    float _175 = _172 + -0.8359375f;
    float _176 = _173 + -0.8359375f;
    float _177 = _174 + -0.8359375f;
    float _178 = max(0.0f, _175);
    float _179 = max(0.0f, _176);
    float _180 = max(0.0f, _177);
    float _181 = _172 * 18.6875f;
    float _182 = _173 * 18.6875f;
    float _183 = _174 * 18.6875f;
    float _184 = 18.8515625f - _181;
    float _185 = 18.8515625f - _182;
    float _186 = 18.8515625f - _183;
    float _187 = _178 / _184;
    float _188 = _179 / _185;
    float _189 = _180 / _186;
    float _190 = log2(_187);
    float _191 = log2(_188);
    float _192 = log2(_189);
    float _193 = _190 * 6.277394771575928f;
    float _194 = _191 * 6.277394771575928f;
    float _195 = _192 * 6.277394771575928f;
    float _196 = exp2(_193);
    float _197 = exp2(_194);
    float _198 = exp2(_195);
    float _199 = _196 * 10000.0f;
    float _200 = _197 * 10000.0f;
    float _201 = _198 * 10000.0f;
    float _204 = _199 / (cb0_051x);
    float _205 = _200 / (cb0_051x);
    float _206 = _201 / (cb0_051x);
    float _207 = max(6.103519990574569e-05f, _204);
    float _208 = max(6.103519990574569e-05f, _205);
    float _209 = max(6.103519990574569e-05f, _206);
    float _210 = max(_207, 0.0031306699384003878f);
    float _211 = max(_208, 0.0031306699384003878f);
    float _212 = max(_209, 0.0031306699384003878f);
    float _213 = log2(_210);
    float _214 = log2(_211);
    float _215 = log2(_212);
    float _216 = _213 * 0.4166666567325592f;
    float _217 = _214 * 0.4166666567325592f;
    float _218 = _215 * 0.4166666567325592f;
    float _219 = exp2(_216);
    float _220 = exp2(_217);
    float _221 = exp2(_218);
    float _222 = _219 * 1.0549999475479126f;
    float _223 = _220 * 1.0549999475479126f;
    float _224 = _221 * 1.0549999475479126f;
    float _225 = _222 + -0.054999999701976776f;
    float _226 = _223 + -0.054999999701976776f;
    float _227 = _224 + -0.054999999701976776f;
    float _228 = _207 * 12.920000076293945f;
    float _229 = _208 * 12.920000076293945f;
    float _230 = _209 * 12.920000076293945f;
    float _231 = min(_228, _225);
    float _232 = min(_229, _226);
    float _233 = min(_230, _227);
    _235 = _231;
    _236 = _232;
    _237 = _233;
  }
  float _238 = (TEXCOORD_2.w) * 543.3099975585938f;
  float _239 = _238 + (TEXCOORD_2.z);
  float _240 = sin(_239);
  float _241 = _240 * 493013.0f;
  float _242 = frac(_241);
  float _243 = _242 * 2.0f;
  float _244 = _243 + -1.0f;
  float _245 = _244 * 0x7FF0000000000000;
  float _246 = max(_245, -1.0f);
  float _247 = min(_246, 1.0f);
  float _248 = abs(_244);
  float _249 = 1.0f - _248;
  float _250 = saturate(_249);
  float _251 = sqrt(_250);
  float _252 = _251 * _247;
  float _253 = _247 - _252;
  float _256 = _253 * (cb0_051y);
  float _257 = _256 + _235;
  float _258 = _256 + _236;
  float _259 = _256 + _237;
  SV_Target.x = _257;
  SV_Target.y = _258;
  SV_Target.z = _259;
  SV_Target.w = 0.0f;
  SV_Target_1 = _161;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
